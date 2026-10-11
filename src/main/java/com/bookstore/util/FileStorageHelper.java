package com.bookstore.util;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.util.*;
import java.util.concurrent.locks.ReentrantReadWriteLock;

/**
 * Utility class providing thread-safe, robust file read/write operations
 * for file handling data persistence (satisfies SE1020 File Handling requirement).
 * 
 * Supports reading/writing text files with pipe delimiter '|'.
 * Keeps both data/ folder and root directory synchronized.
 * 
 * @author IT25101062
 */
public class FileStorageHelper {

    private static final String DATA_DIR = "data";
    private static final Map<String, ReentrantReadWriteLock> FILE_LOCKS = new HashMap<>();

    private static synchronized ReentrantReadWriteLock getLockForFile(String filename) {
        return FILE_LOCKS.computeIfAbsent(filename, k -> new ReentrantReadWriteLock());
    }

    /**
     * Resolve the primary file path, ensuring data/ directory exists.
     */
    public static Path resolvePath(String filename) {
        try {
            Path dir = Paths.get(DATA_DIR);
            if (!Files.exists(dir)) {
                Files.createDirectories(dir);
            }
            return dir.resolve(filename);
        } catch (IOException e) {
            return Paths.get(filename);
        }
    }

    /**
     * Read all lines from a given text file, skipping empty lines and comment lines.
     * Thread-safe with ReadLock.
     */
    public static List<String> readAllLines(String filename) {
        ReentrantReadWriteLock lock = getLockForFile(filename);
        lock.readLock().lock();
        List<String> lines = new ArrayList<>();
        try {
            Path path = resolvePath(filename);
            // Fallback to root if data/ file does not exist yet
            if (!Files.exists(path) && Files.exists(Paths.get(filename))) {
                path = Paths.get(filename);
            }

            if (!Files.exists(path)) {
                return lines;
            }

            try (BufferedReader reader = Files.newBufferedReader(path, StandardCharsets.UTF_8)) {
                String line;
                while ((line = reader.readLine()) != null) {
                    line = line.trim();
                    if (!line.isEmpty() && !line.startsWith("#")) {
                        lines.add(line);
                    }
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading file: " + filename + " -> " + e.getMessage());
        } finally {
            lock.readLock().unlock();
        }
        return lines;
    }

    /**
     * Write lines to a file, replacing its contents safely.
     * Also synchronizes with root directory so both locations stay updated.
     * Thread-safe with WriteLock.
     */
    public static boolean writeAllLines(String filename, String header, List<String> lines) {
        ReentrantReadWriteLock lock = getLockForFile(filename);
        lock.writeLock().lock();
        try {
            Path primaryPath = resolvePath(filename);
            Path rootPath = Paths.get(filename);

            // Write to primary path (data/filename)
            writeLinesToPath(primaryPath, header, lines);

            // Synchronize with root copy
            try {
                writeLinesToPath(rootPath, header, lines);
            } catch (Exception ignored) {
                // Ignore root synchronization errors if non-critical
            }

            return true;
        } catch (IOException e) {
            System.err.println("Error writing to file " + filename + ": " + e.getMessage());
            return false;
        } finally {
            lock.writeLock().unlock();
        }
    }

    private static void writeLinesToPath(Path targetPath, String header, List<String> lines) throws IOException {
        Path tempPath = Paths.get(targetPath.toString() + ".tmp");
        try (BufferedWriter writer = Files.newBufferedWriter(tempPath, StandardCharsets.UTF_8)) {
            if (header != null && !header.isEmpty()) {
                writer.write(header);
                writer.newLine();
            }
            for (String line : lines) {
                writer.write(line);
                writer.newLine();
            }
            writer.flush();
        }
        Files.move(tempPath, targetPath, StandardCopyOption.REPLACE_EXISTING, StandardCopyOption.ATOMIC_MOVE);
    }

    /**
     * Append a single record to the file.
     */
    public static boolean appendLine(String filename, String line) {
        ReentrantReadWriteLock lock = getLockForFile(filename);
        lock.writeLock().lock();
        try {
            Path primaryPath = resolvePath(filename);
            Path rootPath = Paths.get(filename);

            appendLineToPath(primaryPath, line);
            try {
                appendLineToPath(rootPath, line);
            } catch (Exception ignored) {}

            return true;
        } catch (IOException e) {
            System.err.println("Error appending to file " + filename + ": " + e.getMessage());
            return false;
        } finally {
            lock.writeLock().unlock();
        }
    }

    private static void appendLineToPath(Path path, String line) throws IOException {
        try (BufferedWriter writer = Files.newBufferedWriter(path, StandardCharsets.UTF_8, 
                StandardOpenOption.CREATE, StandardOpenOption.APPEND)) {
            writer.write(line);
            writer.newLine();
            writer.flush();
        }
    }

    /**
     * Splits a pipe-delimited line safely, preserving empty trailing tokens.
     */
    public static String[] splitPipe(String line) {
        return line.split("\\|", -1);
    }

    /**
     * Joins fields with a pipe '|' delimiter.
     */
    public static String joinPipe(String... fields) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < fields.length; i++) {
            if (i > 0) sb.append("|");
            sb.append(fields[i] == null ? "" : fields[i].trim());
        }
        return sb.toString();
    }
}
