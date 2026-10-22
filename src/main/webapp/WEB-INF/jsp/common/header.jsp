<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle != null ? pageTitle : 'Chapter One – Online Bookstore'}</title>
    
    <!-- Google Fonts: Modern Professional Typography (Plus Jakarta Sans & Lora) -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Lora:ital,wght@0,400;0,500;0,600;1,400;1,500&family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <!-- Inlined Master Stylesheet: Guaranteed Instant Rendering Immune to Browser Caching -->
    <style>
        :root {
            --plum-dark: #240e18;
            --plum-main: #361724;
            --plum-card: #421e2e;
            --plum-hover: #502538;
            --gold-accent: #c49a6c;
            --gold-light: #dfb990;
            --bg-cream: #fbf8f3;
            --bg-ivory: #f4ece2;
            --text-primary: #2c121e;
            --text-muted: #6b5b63;
            --border-warm: #e8ded4;
            --font-heading: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            --font-sans: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            --font-serif: 'Lora', Georgia, 'Times New Roman', serif;
        }

        body {
            font-family: var(--font-sans) !important;
            background-color: #fbf8f3 !important;
            color: #2c121e !important;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            margin: 0;
            padding: 0;
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
        }

        main { flex: 1; }

        /* Typography - Human-Crafted, Natural Modern Flow */
        h1, h2, h3, h4, h5, h6, .font-serif, .serif-heading, .font-heading {
            font-family: var(--font-heading) !important;
            letter-spacing: -0.025em !important;
            font-weight: 700;
        }

        .italic-accent {
            font-family: var(--font-serif) !important;
            font-style: italic !important;
            font-weight: 500 !important;
            color: #c49a6c !important;
        }

        /* Navbar */
        .navbar-literary {
            background-color: #fbf8f3 !important;
            border-bottom: 1px solid #eaddcf !important;
            padding: 1.1rem 0 !important;
        }

        .navbar-brand-literary {
            font-family: var(--font-heading) !important;
            font-size: 1.85rem !important;
            font-weight: 800 !important;
            letter-spacing: -0.03em !important;
            color: #361724 !important;
            display: flex !important;
            align-items: center !important;
            gap: 0.4rem !important;
            text-decoration: none !important;
        }

        .brand-quill {
            color: #c49a6c !important;
            font-size: 1.5rem !important;
            transform: rotate(20deg);
            display: inline-block;
        }

        .nav-link-literary {
            font-family: var(--font-sans) !important;
            font-size: 0.8rem !important;
            text-transform: uppercase !important;
            letter-spacing: 1.8px !important;
            font-weight: 600 !important;
            color: #361724 !important;
            padding: 0.5rem 1.1rem !important;
            text-decoration: none !important;
            transition: color 0.2s ease !important;
        }

        .nav-link-literary:hover, .nav-link-literary.active {
            color: #c49a6c !important;
        }

        /* Buttons */
        .btn-plum {
            background-color: #361724 !important;
            color: #ffffff !important;
            font-family: var(--font-sans) !important;
            font-size: 0.8rem !important;
            text-transform: uppercase !important;
            letter-spacing: 1.6px !important;
            font-weight: 600 !important;
            padding: 0.75rem 1.8rem !important;
            border-radius: 6px !important;
            border: 1px solid #361724 !important;
            text-decoration: none !important;
            display: inline-block;
            transition: all 0.25s ease !important;
        }

        .btn-plum:hover {
            background-color: #4d2133 !important;
            color: #ffffff !important;
            transform: translateY(-1px);
        }

        .btn-outline-plum {
            background-color: transparent !important;
            color: #361724 !important;
            font-family: var(--font-sans) !important;
            font-size: 0.8rem !important;
            text-transform: uppercase !important;
            letter-spacing: 1.6px !important;
            font-weight: 600 !important;
            padding: 0.75rem 1.8rem !important;
            border-radius: 6px !important;
            border: 1.5px solid #361724 !important;
            text-decoration: none !important;
            display: inline-block;
            transition: all 0.25s ease !important;
        }

        .btn-outline-plum:hover {
            background-color: #361724 !important;
            color: #ffffff !important;
        }

        /* Hero Section */
        .hero-editorial {
            position: relative !important;
            background-color: #240e18 !important;
            background-size: cover !important;
            background-position: center center !important;
            background-repeat: no-repeat !important;
            padding: 5.5rem 0 4.5rem 0 !important;
            overflow: hidden !important;
        }

        .hero-editorial::before {
            content: "" !important;
            position: absolute !important;
            inset: 0 !important;
            background: linear-gradient(
                95deg,
                rgba(20, 7, 14, 0.94) 0%,
                rgba(32, 12, 21, 0.90) 38%,
                rgba(36, 14, 24, 0.72) 70%,
                rgba(20, 7, 14, 0.88) 100%
            ) !important;
            z-index: 1 !important;
            pointer-events: none !important;
        }

        .hero-editorial .container {
            position: relative !important;
            z-index: 2 !important;
        }

        .hero-sparkle {
            color: #dfb990 !important;
            font-size: 1.4rem !important;
            display: inline-block;
            margin-bottom: 0.5rem;
        }

        .hero-title-editorial {
            font-family: var(--font-heading) !important;
            font-size: 3.8rem !important;
            line-height: 1.1 !important;
            color: #ffffff !important;
            font-weight: 800 !important;
            letter-spacing: -0.03em !important;
            margin-bottom: 1.5rem !important;
            text-shadow: 0 4px 25px rgba(0, 0, 0, 0.5) !important;
        }

        .hero-title-editorial .italic-accent {
            color: #e5b77e !important;
            font-style: italic;
            text-shadow: 0 0 30px rgba(229, 183, 126, 0.45) !important;
        }

        @media (max-width: 991px) {
            .hero-title-editorial { font-size: 2.6rem !important; }
            .hero-editorial { padding: 3.5rem 0 3rem 0 !important; }
        }

        .hero-subtitle-editorial {
            font-size: 1.12rem !important;
            line-height: 1.75 !important;
            color: rgba(245, 236, 227, 0.92) !important;
            max-width: 500px !important;
            margin-bottom: 2.2rem !important;
            text-shadow: 0 2px 10px rgba(0, 0, 0, 0.4) !important;
        }

        .hero-btn-primary {
            background: linear-gradient(135deg, #c49a6c, #a87948) !important;
            color: #ffffff !important;
            border: 1px solid rgba(255, 255, 255, 0.25) !important;
            font-weight: 600 !important;
            padding: 0.85rem 1.8rem !important;
            border-radius: 8px !important;
            box-shadow: 0 10px 25px rgba(196, 154, 108, 0.4) !important;
            transition: all 0.25s ease !important;
            text-decoration: none !important;
            display: inline-flex !important;
            align-items: center !important;
            gap: 0.5rem !important;
        }

        .hero-btn-primary:hover {
            background: linear-gradient(135deg, #d4a97b, #b78550) !important;
            transform: translateY(-2px) !important;
            box-shadow: 0 14px 30px rgba(196, 154, 108, 0.55) !important;
            color: #ffffff !important;
        }

        .hero-btn-secondary {
            background: rgba(255, 255, 255, 0.1) !important;
            backdrop-filter: blur(10px) !important;
            -webkit-backdrop-filter: blur(10px) !important;
            color: #ffffff !important;
            border: 1.5px solid rgba(223, 185, 144, 0.6) !important;
            font-weight: 600 !important;
            padding: 0.85rem 1.8rem !important;
            border-radius: 8px !important;
            transition: all 0.25s ease !important;
            text-decoration: none !important;
            display: inline-flex !important;
            align-items: center !important;
            gap: 0.5rem !important;
        }

        .hero-btn-secondary:hover {
            background: rgba(223, 185, 144, 0.25) !important;
            border-color: #dfb990 !important;
            color: #ffffff !important;
            transform: translateY(-2px) !important;
        }

        .hero-image-wrapper {
            position: relative !important;
            border-radius: 18px !important;
            padding: 5px !important;
            background: linear-gradient(135deg, rgba(196, 154, 108, 0.45), rgba(36, 14, 24, 0.3)) !important;
            box-shadow: 0 25px 60px rgba(0, 0, 0, 0.5) !important;
        }

        .hero-image-styled {
            width: 100% !important;
            border-radius: 14px !important;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.3) !important;
            object-fit: cover !important;
            display: block !important;
            border: 1px solid rgba(255, 255, 255, 0.12) !important;
        }

        /* Floating & Standalone Quote Card */
        .hero-quote-card-standalone {
            background: rgba(36, 14, 24, 0.82) !important;
            backdrop-filter: blur(16px) !important;
            -webkit-backdrop-filter: blur(16px) !important;
            border: 1.5px solid rgba(196, 154, 108, 0.45) !important;
            border-radius: 20px !important;
            padding: 2.8rem 2.6rem !important;
            color: #ffffff !important;
            box-shadow: 0 25px 60px rgba(0, 0, 0, 0.55), 0 0 35px rgba(196, 154, 108, 0.18) !important;
            max-width: 480px !important;
            width: 100% !important;
            margin-left: auto !important;
            margin-right: 0 !important;
            position: relative !important;
            overflow: hidden !important;
            animation: textRevealUp 1s cubic-bezier(0.16, 1, 0.3, 1) 0.35s both !important;
        }

        @media (max-width: 991px) {
            .hero-quote-card-standalone {
                margin: 2rem auto 0 auto !important;
                padding: 2rem 1.8rem !important;
                max-width: 100% !important;
            }
        }

        .hero-quote-card-standalone::before {
            content: "" !important;
            position: absolute !important;
            top: -50% !important;
            right: -50% !important;
            width: 200% !important;
            height: 200% !important;
            background: radial-gradient(circle, rgba(196, 154, 108, 0.15) 0%, transparent 60%) !important;
            pointer-events: none !important;
        }

        .hero-quote-card-standalone .quote-mark {
            font-family: var(--font-serif) !important;
            font-size: 3.6rem !important;
            line-height: 0.6 !important;
            color: #dfb990 !important;
            display: block !important;
            margin-bottom: 1rem !important;
            text-shadow: 0 0 20px rgba(223, 185, 144, 0.45) !important;
        }

        .hero-quote-card-standalone .quote-text {
            font-family: var(--font-serif) !important;
            font-size: 1.7rem !important;
            line-height: 1.5 !important;
            font-style: italic !important;
            color: #ffffff !important;
            font-weight: 500 !important;
            text-shadow: 0 2px 14px rgba(0, 0, 0, 0.5) !important;
        }

        .hero-quote-card-standalone .quote-divider {
            height: 1px !important;
            background: linear-gradient(90deg, rgba(196, 154, 108, 0.55), transparent) !important;
            border: none !important;
        }

        .hero-quote-card-standalone .quote-badge {
            color: #dfb990 !important;
            font-size: 0.82rem !important;
            text-transform: uppercase !important;
            letter-spacing: 1.5px !important;
            font-weight: 600 !important;
            display: inline-flex !important;
            align-items: center !important;
        }

        .floating-quote-card {
            position: absolute !important;
            top: 24px !important;
            right: 24px !important;
            background: rgba(44, 18, 30, 0.94) !important;
            backdrop-filter: blur(8px) !important;
            border: 1px solid rgba(196, 154, 108, 0.4) !important;
            border-radius: 14px !important;
            padding: 1.4rem 1.6rem !important;
            max-width: 250px !important;
            color: #ffffff !important;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.25) !important;
            z-index: 10 !important;
            text-align: center !important;
        }

        .quote-mark {
            font-family: var(--font-serif) !important;
            font-size: 2.2rem !important;
            line-height: 0.8 !important;
            color: #c49a6c !important;
            display: block !important;
            margin-bottom: 0.4rem !important;
        }

        .quote-text {
            font-family: var(--font-serif) !important;
            font-size: 1.15rem !important;
            line-height: 1.4 !important;
            font-style: italic !important;
            margin-bottom: 0.5rem !important;
            color: #ffffff !important;
        }

        .quote-sparkle {
            color: #c49a6c !important;
            font-size: 0.9rem !important;
        }

        /* Smooth Hero Text Reveal Animations */
        @keyframes textRevealUp {
            0% {
                opacity: 0;
                transform: translateY(32px);
                filter: blur(4px);
            }
            100% {
                opacity: 1;
                transform: translateY(0);
                filter: blur(0);
            }
        }

        .hero-badge-reveal {
            animation: textRevealUp 0.8s cubic-bezier(0.16, 1, 0.3, 1) 0.05s both !important;
            display: inline-block !important;
        }

        .hero-reveal-line {
            display: block !important;
            overflow: hidden !important;
            padding-bottom: 3px;
        }

        .hero-reveal-line > span {
            display: inline-block !important;
            animation: textRevealUp 0.95s cubic-bezier(0.16, 1, 0.3, 1) both;
        }

        .hero-reveal-line:nth-child(1) > span {
            animation-delay: 0.12s;
        }
        .hero-reveal-line:nth-child(2) > span {
            animation-delay: 0.28s;
        }
        .hero-reveal-line:nth-child(3) > span {
            animation-delay: 0.44s;
        }

        .hero-sub-reveal {
            animation: textRevealUp 0.9s cubic-bezier(0.16, 1, 0.3, 1) 0.58s both !important;
        }

        .hero-btn-reveal {
            animation: textRevealUp 0.9s cubic-bezier(0.16, 1, 0.3, 1) 0.72s both !important;
        }

        /* Hero Divider Strip — Bold gradient bar below hero */
        .hero-divider-strip {
            height: 7px !important;
            background: linear-gradient(
                90deg,
                #240e18 0%,
                #602b43 18%,
                #c49a6c 40%,
                #dfb990 52%,
                #c49a6c 64%,
                #602b43 82%,
                #240e18 100%
            ) !important;
            width: 100% !important;
            display: block !important;
        }

        /* Continuous Infinite Moving Text Strip (Marquee) */
        .sparkle-banner, .marquee-strip {
            background-color: #240e18 !important;
            color: #ffffff !important;
            border-top: 1px solid rgba(196, 154, 108, 0.25) !important;
            border-bottom: 1px solid rgba(196, 154, 108, 0.25) !important;
            overflow: hidden !important;
            white-space: nowrap !important;
            padding: 1.15rem 0 !important;
            position: relative !important;
            user-select: none;
            box-shadow: inset 0 2px 10px rgba(0, 0, 0, 0.25);
        }

        .marquee-track {
            display: flex !important;
            width: max-content !important;
            animation: continuousMarqueeScroll 28s linear infinite !important;
        }

        .marquee-strip:hover .marquee-track,
        .sparkle-banner:hover .marquee-track {
            animation-play-state: paused !important;
        }

        .marquee-content {
            display: flex !important;
            align-items: center !important;
            gap: 1.8rem !important;
            padding-right: 1.8rem !important;
            font-family: var(--font-sans) !important;
            font-size: 0.96rem !important;
            font-weight: 500 !important;
            letter-spacing: 0.6px !important;
            color: #f7eedf !important;
        }

        .marquee-sep {
            color: #c49a6c !important;
            font-size: 1.3rem !important;
            margin: 0 0.4rem !important;
            opacity: 0.85;
        }

        .marquee-highlight {
            color: #dfb990 !important;
            font-family: var(--font-serif) !important;
            font-style: italic !important;
            font-weight: 600 !important;
        }

        @keyframes continuousMarqueeScroll {
            0% {
                transform: translateX(0);
            }
            100% {
                transform: translateX(-50%);
            }
        }

        /* Pillars Section */
        .pillars-section {
            background-color: #361724 !important;
            padding: 5rem 0 !important;
        }

        .pillar-card {
            background-color: #fcf9f5 !important;
            border: 1px solid #e8ded4 !important;
            border-radius: 16px !important;
            padding: 2.5rem 1.8rem !important;
            height: 100% !important;
            display: flex !important;
            flex-direction: column !important;
            text-align: center !important;
            align-items: center !important;
            transition: all 0.3s ease !important;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08) !important;
        }

        .pillar-card:hover {
            transform: translateY(-8px) !important;
            box-shadow: 0 20px 35px rgba(0, 0, 0, 0.2) !important;
            border-color: #c49a6c !important;
        }

        .pillar-icon-badge {
            width: 70px !important;
            height: 70px !important;
            border-radius: 50% !important;
            background-color: #481e30 !important;
            color: #dfb990 !important;
            display: flex !important;
            align-items: center !important;
            justify-content: center !important;
            font-size: 1.75rem !important;
            margin-bottom: 1.5rem !important;
            border: 1.5px solid rgba(196, 154, 108, 0.35) !important;
        }

        .pillar-title {
            font-family: var(--font-heading) !important;
            font-size: 1.15rem !important;
            font-weight: 700 !important;
            text-transform: uppercase !important;
            letter-spacing: 0.8px !important;
            color: #240e18 !important;
            margin-bottom: 0.9rem !important;
        }

        .pillar-desc {
            font-size: 0.93rem !important;
            line-height: 1.7 !important;
            color: #6b5b63 !important;
            margin-bottom: 1.8rem !important;
            flex-grow: 1 !important;
        }

        .pillar-link {
            font-family: var(--font-sans) !important;
            font-size: 0.78rem !important;
            font-weight: 700 !important;
            text-transform: uppercase !important;
            letter-spacing: 1.2px !important;
            color: #361724 !important;
            text-decoration: none !important;
            transition: color 0.2s ease !important;
        }

        .pillar-link:hover {
            color: #c49a6c !important;
        }

        /* Values Section */
        /* =========================================================================
           4. EDITORIAL VALUES STATEMENT SECTION (Modern Luxury Animations)
           ========================================================================= */
        .values-section {
            background-color: #fbf8f3 !important;
            padding: 5.5rem 0 4.5rem 0 !important;
            position: relative;
        }

        .values-heading {
            font-family: var(--font-heading) !important;
            font-size: 2.75rem !important;
            font-weight: 800 !important;
            letter-spacing: -0.025em !important;
            color: #240e18 !important;
            text-align: center !important;
            margin-bottom: 0.6rem !important;
        }

        .values-heading .italic-accent {
            font-family: var(--font-serif) !important;
            font-style: italic !important;
            font-weight: 500 !important;
            color: #c49a6c !important;
        }

        .values-subheart {
            text-align: center !important;
            margin-bottom: 3.2rem !important;
        }

        .values-subheart i {
            display: inline-block !important;
            color: #c49a6c !important;
            font-size: 1.35rem !important;
            animation: heartPulse 2.8s ease-in-out infinite !important;
            transform-origin: center !important;
        }

        @keyframes heartPulse {
            0%, 100% {
                transform: scale(1);
                filter: drop-shadow(0 0 0 rgba(196, 154, 108, 0));
            }
            15% {
                transform: scale(1.35);
                filter: drop-shadow(0 4px 10px rgba(196, 154, 108, 0.5));
            }
            30% {
                transform: scale(1.1);
            }
            45% {
                transform: scale(1.25);
                filter: drop-shadow(0 3px 8px rgba(196, 154, 108, 0.4));
            }
        }

        /* Luxury Value Cards with Smooth Elevation & Micro-Interactions */
        .value-card-premium {
            background: #ffffff !important;
            border: 1px solid #ebdcd0 !important;
            border-radius: 20px !important;
            padding: 2.2rem 1.6rem !important;
            text-align: center !important;
            height: 100% !important;
            display: flex !important;
            flex-direction: column !important;
            align-items: center !important;
            box-shadow: 0 10px 30px rgba(44, 18, 30, 0.05) !important;
            transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1) !important;
            position: relative !important;
            overflow: hidden !important;
        }

        .value-card-premium::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #dfb990, #c49a6c, #8c5b1c);
            opacity: 0;
            transition: opacity 0.35s ease;
        }

        .value-card-premium:hover {
            transform: translateY(-10px) !important;
            box-shadow: 0 22px 45px rgba(44, 18, 30, 0.12), 0 0 25px rgba(196, 154, 108, 0.18) !important;
            border-color: #c49a6c !important;
        }

        .value-card-premium:hover::before {
            opacity: 1;
        }

        .value-icon-badge {
            width: 72px !important;
            height: 72px !important;
            border-radius: 50% !important;
            display: flex !important;
            align-items: center !important;
            justify-content: center !important;
            background: linear-gradient(135deg, #fbf7f2 0%, #f4ece2 100%) !important;
            border: 1.5px solid rgba(196, 154, 108, 0.45) !important;
            color: #8c5b1c !important;
            font-size: 1.85rem !important;
            margin-bottom: 1.3rem !important;
            transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1) !important;
            box-shadow: 0 4px 15px rgba(196, 154, 108, 0.15) !important;
        }

        .value-card-premium:hover .value-icon-badge {
            transform: scale(1.15) rotate(6deg) !important;
            background: linear-gradient(135deg, #240e18 0%, #421e2e 100%) !important;
            color: #dfb990 !important;
            border-color: #c49a6c !important;
            box-shadow: 0 10px 25px rgba(36, 14, 24, 0.3) !important;
        }

        .value-pill {
            font-family: var(--font-sans) !important;
            font-size: 0.72rem !important;
            font-weight: 700 !important;
            text-transform: uppercase !important;
            letter-spacing: 1.8px !important;
            color: #8c5b1c !important;
            background: rgba(196, 154, 108, 0.12) !important;
            border: 1px solid rgba(196, 154, 108, 0.25) !important;
            padding: 0.25rem 0.8rem !important;
            border-radius: 20px !important;
            margin-bottom: 0.85rem !important;
            display: inline-block !important;
        }

        .value-card-desc {
            font-size: 0.98rem !important;
            line-height: 1.65 !important;
            color: #4a3b43 !important;
            font-weight: 500 !important;
            margin: 0 !important;
        }

        .values-bottom-bar {
            background-color: #f4ece2 !important;
            border: 1px solid #e8ded4 !important;
            border-radius: 14px !important;
            padding: 1.4rem 2.4rem !important;
            display: flex !important;
            justify-content: space-between !important;
            align-items: center !important;
            margin-top: 3.8rem !important;
            box-shadow: 0 8px 25px rgba(44, 18, 30, 0.05) !important;
        }

        .values-bar-text {
            font-family: var(--font-heading) !important;
            font-size: 1.15rem !important;
            font-weight: 700 !important;
            letter-spacing: -0.01em !important;
            color: #240e18 !important;
            display: flex !important;
            align-items: center !important;
            gap: 0.6rem !important;
        }

        /* Editorial Book Cards */
        .book-card-editorial {
            background: #ffffff !important;
            border: 1px solid #e8ded4 !important;
            border-radius: 14px !important;
            overflow: hidden !important;
            transition: all 0.3s ease !important;
            height: 100% !important;
            display: flex !important;
            flex-direction: column !important;
        }

        .book-card-editorial:hover {
            transform: translateY(-6px) !important;
            box-shadow: 0 15px 35px rgba(36, 14, 24, 0.12) !important;
            border-color: #c49a6c !important;
        }

        .book-cover-editorial {
            background: linear-gradient(135deg, #361724 0%, #4a2132 100%) !important;
            color: #dfb990 !important;
            height: 200px !important;
            display: flex !important;
            flex-direction: column !important;
            align-items: center !important;
            justify-content: center !important;
            position: relative !important;
        }

        /* Footer */
        .footer-editorial {
            background-color: #240e18 !important;
            color: #fcf8f2 !important;
            padding: 4.5rem 0 2rem 0 !important;
            margin-top: auto !important;
            border-top: 1px solid rgba(196, 154, 108, 0.25) !important;
        }

        .footer-brand {
            font-family: var(--font-heading) !important;
            font-size: 1.9rem !important;
            font-weight: 800 !important;
            letter-spacing: -0.03em !important;
            color: #ffffff !important;
            margin-bottom: 0.5rem !important;
            display: flex !important;
            align-items: center !important;
            gap: 0.4rem !important;
        }

        .footer-tagline {
            font-family: var(--font-serif) !important;
            font-style: italic !important;
            font-size: 1.05rem !important;
            color: #dfb990 !important;
            margin-bottom: 1.5rem !important;
        }

        .footer-heading {
            font-family: var(--font-sans) !important;
            font-size: 0.75rem !important;
            text-transform: uppercase !important;
            letter-spacing: 2px !important;
            font-weight: 700 !important;
            color: #c49a6c !important;
            margin-bottom: 1.25rem !important;
        }

        .footer-links { list-style: none !important; padding: 0 !important; margin: 0 !important; }
        .footer-links li { margin-bottom: 0.65rem !important; }
        .footer-links a {
            color: #d8c8cc !important;
            text-decoration: none !important;
            font-size: 0.88rem !important;
            transition: color 0.2s ease !important;
        }
        .footer-links a:hover { color: #dfb990 !important; }

        .social-circle-link {
            width: 36px !important;
            height: 36px !important;
            border-radius: 50% !important;
            background: rgba(255, 255, 255, 0.08) !important;
            color: #ffffff !important;
            display: inline-flex !important;
            align-items: center !important;
            justify-content: center !important;
            text-decoration: none !important;
            margin-right: 0.5rem !important;
            transition: all 0.2s ease !important;
        }
        .social-circle-link:hover {
            background: #c49a6c !important;
            color: #ffffff !important;
        }

        .newsletter-input-group {
            background: #ffffff !important;
            border-radius: 6px !important;
            overflow: hidden !important;
            display: flex !important;
        }

        .newsletter-input {
            border: none !important;
            padding: 0.75rem 1rem !important;
            font-size: 0.88rem !important;
            width: 100% !important;
            outline: none !important;
        }

        .newsletter-btn {
            background: #361724 !important;
            border: none !important;
            color: #ffffff !important;
            padding: 0 1.2rem !important;
        }

        .footer-bottom-bar {
            border-top: 1px solid rgba(255, 255, 255, 0.08) !important;
            padding-top: 1.5rem !important;
            margin-top: 3.5rem !important;
            font-size: 0.8rem !important;
            color: rgba(255, 255, 255, 0.45) !important;
        }

        .badge-ebook {
            background-color: #f5edf1 !important;
            color: #361724 !important;
            border: 1px solid rgba(54, 23, 36, 0.2) !important;
            font-weight: 600 !important;
        }

        .badge-printed {
            background-color: #f7eedf !important;
            color: #8c5b1c !important;
            border: 1px solid #ebd3b4 !important;
            font-weight: 600 !important;
        }

        /* =========================================================================
           ENTRANCE & FLOAT-UP ANIMATIONS (Books float up with smooth stagger)
           ========================================================================= */
        @keyframes floatUpFade {
            0% {
                opacity: 0;
                transform: translateY(42px) scale(0.96);
            }
            60% {
                opacity: 0.9;
            }
            100% {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }

        @keyframes heroGentleFloat {
            0%, 100% {
                transform: translateY(0px);
            }
            50% {
                transform: translateY(-8px);
            }
        }

        .animate-card-rise {
            animation: floatUpFade 0.85s cubic-bezier(0.16, 1, 0.3, 1) both;
        }

        .delay-1 { animation-delay: 0.06s; }
        .delay-2 { animation-delay: 0.14s; }
        .delay-3 { animation-delay: 0.22s; }
        .delay-4 { animation-delay: 0.30s; }
        .delay-5 { animation-delay: 0.38s; }
        .delay-6 { animation-delay: 0.46s; }
        .delay-7 { animation-delay: 0.54s; }
        .delay-8 { animation-delay: 0.62s; }

        /* Smooth interactive book card hover elevation */
        .book-card, .book-card-editorial {
            transition: transform 0.35s cubic-bezier(0.16, 1, 0.3, 1), box-shadow 0.35s cubic-bezier(0.16, 1, 0.3, 1) !important;
            border-radius: 16px !important;
        }

        .book-card:hover, .book-card-editorial:hover {
            transform: translateY(-8px) !important;
            box-shadow: 0 18px 40px rgba(36, 14, 24, 0.16) !important;
        }

        .book-cover-placeholder img, .book-cover-editorial img {
            transition: transform 0.45s ease, filter 0.45s ease !important;
        }

        .book-card:hover .book-cover-placeholder img,
        .book-card-editorial:hover .book-cover-editorial img {
            transform: scale(1.06);
            filter: brightness(1.04);
        }

        .hero-image-styled {
            animation: floatUpFade 1s cubic-bezier(0.16, 1, 0.3, 1) both, heroGentleFloat 5s ease-in-out infinite 1s !important;
        }

        .floating-quote-card {
            animation: floatUpFade 1.1s cubic-bezier(0.16, 1, 0.3, 1) 0.2s both !important;
        }
    </style>
</head>
<body>
