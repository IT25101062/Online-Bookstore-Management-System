<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="common/header.jsp"/>
<jsp:include page="common/navbar.jsp"/>
<jsp:include page="common/alerts.jsp"/>

<main>
    <!-- =========================================================================
         1. HERO SECTION (Editorial Literary Aesthetic with Cafe Background)
         ========================================================================= -->
    <section class="hero-editorial" style="background-image: url('${pageContext.request.contextPath}/images/hero-bg.jpg');">
        <div class="container">
            <div class="row align-items-center g-5">
                <!-- Left: Evocative Headline & Description with Smooth Text Reveal -->
                <div class="col-lg-6">
                    <span class="badge rounded-pill px-3 py-2 mb-3 hero-badge-reveal" style="background: rgba(196, 154, 108, 0.22); color: #f2cb9b; border: 1px solid rgba(196, 154, 108, 0.45); font-weight: 600; font-size: 0.82rem; letter-spacing: 0.8px; backdrop-filter: blur(8px);">
                        <i class="bi bi-book-half me-1"></i> WELCOME TO CHAPTER ONE
                    </span>
                    <h1 class="hero-title-editorial">
                        <span class="hero-reveal-line"><span>Every story</span></span>
                        <span class="hero-reveal-line"><span>deserves</span></span>
                        <span class="hero-reveal-line"><span>to be <span class="italic-accent">read.</span></span></span>
                    </h1>
                    <p class="hero-subtitle-editorial hero-sub-reveal">
                        We help authors bring their stories to life and connect them with readers who believe in the enduring power of words.
                    </p>
                    <div class="d-flex flex-wrap gap-3 hero-btn-reveal">
                        <a href="${pageContext.request.contextPath}/books" class="btn hero-btn-primary">
                            <i class="bi bi-book-half"></i> Bring Your Story To Life
                        </a>
                        <a href="${pageContext.request.contextPath}/books/search" class="btn hero-btn-secondary">
                            <i class="bi bi-compass"></i> Explore Books
                        </a>
                    </div>
                </div>

                <!-- Right: Standalone Literary Quote Showcase Card (Image Removed, Text Retained) -->
                <div class="col-lg-6 d-flex align-items-center justify-content-lg-end">
                    <div class="hero-quote-card-standalone shadow-lg">
                        <span class="quote-mark">&ldquo;</span>
                        <div class="quote-text">
                            Stories change us.<br>
                            Books stay with us forever.
                        </div>
                        <div class="quote-divider my-3"></div>
                        <div class="d-flex align-items-center justify-content-between">
                            <span class="quote-badge">
                                <i class="bi bi-bookmark-star-fill me-1"></i> SELECTED COLLECTION
                            </span>
                            <div class="text-warning small d-flex gap-1" title="Top Rated Collection">
                                <i class="bi bi-star-fill"></i>
                                <i class="bi bi-star-fill"></i>
                                <i class="bi bi-star-fill"></i>
                                <i class="bi bi-star-fill"></i>
                                <i class="bi bi-star-fill"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- =========================================================================
         HERO DIVIDER — Bold Warm Gradient Strip
         ========================================================================= -->
    <div class="hero-divider-strip"></div>

    <!-- =========================================================================
         2. EDITORIAL TRANSITION STRIP (Continuous Moving Literary Marquee)
         ========================================================================= -->
    <div class="marquee-strip">
        <div class="marquee-track">
            <div class="marquee-content">
                <span>Great stories start here</span>
                <span class="marquee-sep">&bull;</span>
                <span class="marquee-highlight">Connecting readers &amp; authors around the world</span>
                <span class="marquee-sep">&bull;</span>
                <span>Handcrafted collection</span>
                <span class="marquee-sep">&bull;</span>
                <span>Discover your next literary journey</span>
                <span class="marquee-sep">&bull;</span>
                <span class="marquee-highlight">Luxury Physical &amp; Digital Editions</span>
                <span class="marquee-sep">&bull;</span>
                <span>Same-day priority reading dispatch</span>
                <span class="marquee-sep">&bull;</span>
            </div>
            <div class="marquee-content" aria-hidden="true">
                <span>Great stories start here</span>
                <span class="marquee-sep">&bull;</span>
                <span class="marquee-highlight">Connecting readers &amp; authors around the world</span>
                <span class="marquee-sep">&bull;</span>
                <span>Handcrafted collection</span>
                <span class="marquee-sep">&bull;</span>
                <span>Discover your next literary journey</span>
                <span class="marquee-sep">&bull;</span>
                <span class="marquee-highlight">Luxury Physical &amp; Digital Editions</span>
                <span class="marquee-sep">&bull;</span>
                <span>Same-day priority reading dispatch</span>
                <span class="marquee-sep">&bull;</span>
            </div>
        </div>
    </div>

    <!-- =========================================================================
         3. CORE PILLARS SECTION (Deep Velvet Plum Background)
         ========================================================================= -->
    <section class="pillars-section">
        <div class="container">
            <div class="row g-4">
                <!-- Pillar 1: Publishing -->
                <div class="col-md-6 col-lg-3">
                    <div class="pillar-card">
                        <div class="pillar-icon-badge">
                            <i class="bi bi-book"></i>
                        </div>
                        <h4 class="pillar-title">Publishing</h4>
                        <p class="pillar-desc">
                            From manuscript to market. We guide you through every step of publishing your book with care and expertise.
                        </p>
                        <a href="${pageContext.request.contextPath}/books" class="pillar-link">
                            Learn More &rarr;
                        </a>
                    </div>
                </div>

                <!-- Pillar 2: Alpha Reader -->
                <div class="col-md-6 col-lg-3">
                    <div class="pillar-card">
                        <div class="pillar-icon-badge">
                            <i class="bi bi-feather"></i>
                        </div>
                        <h4 class="pillar-title">Alpha Reader</h4>
                        <p class="pillar-desc">
                            Get early, honest feedback on your story, characters, and plot. Perfect for shaping your manuscript before it's polished.
                        </p>
                        <a href="${pageContext.request.contextPath}/books" class="pillar-link">
                            Learn More &rarr;
                        </a>
                    </div>
                </div>

                <!-- Pillar 3: Beta Reader -->
                <div class="col-md-6 col-lg-3">
                    <div class="pillar-card">
                        <div class="pillar-icon-badge">
                            <i class="bi bi-journal-bookmark"></i>
                        </div>
                        <h4 class="pillar-title">Beta Reader</h4>
                        <p class="pillar-desc">
                            The second set of eyes your book needs before it meets the world. Thoughtful feedback from real readers.
                        </p>
                        <a href="${pageContext.request.contextPath}/books" class="pillar-link">
                            Learn More &rarr;
                        </a>
                    </div>
                </div>

                <!-- Pillar 4: Community -->
                <div class="col-md-6 col-lg-3">
                    <div class="pillar-card">
                        <div class="pillar-icon-badge">
                            <i class="bi bi-people"></i>
                        </div>
                        <h4 class="pillar-title">Community</h4>
                        <p class="pillar-desc">
                            Join a community of authors and readers who support, uplift, and celebrate each other's stories.
                        </p>
                        <c:choose>
                            <c:when test="${sessionScope.currentUser != null}">
                                <a href="${pageContext.request.contextPath}/profile" class="pillar-link">
                                    My Profile &rarr;
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/register" class="pillar-link">
                                    Join Us &rarr;
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- =========================================================================
         4. EDITORIAL VALUES STATEMENT SECTION
         ========================================================================= -->
    <section class="values-section">
        <div class="container">
            <h2 class="values-heading">
                For authors. For readers. For <span class="italic-accent">stories that matter.</span>
            </h2>
            <div class="values-subheart">
                <i class="bi bi-suit-heart-fill"></i>
            </div>

            <!-- 4 Luxury Value Cards Grid with Staggered Entrance & Interactive Elevation -->
            <div class="row g-4 justify-content-center">
                <div class="col-sm-6 col-lg-3 animate-card-rise delay-1">
                    <div class="value-card-premium">
                        <div class="value-icon-badge">
                            <i class="bi bi-heart"></i>
                        </div>
                        <span class="value-pill">Every Story</span>
                        <p class="value-card-desc">We believe in every story waiting to be told.</p>
                    </div>
                </div>
                <div class="col-sm-6 col-lg-3 animate-card-rise delay-2">
                    <div class="value-card-premium">
                        <div class="value-icon-badge">
                            <i class="bi bi-book-half"></i>
                        </div>
                        <span class="value-pill">Every Stage</span>
                        <p class="value-card-desc">We support authors at every stage of their journey.</p>
                    </div>
                </div>
                <div class="col-sm-6 col-lg-3 animate-card-rise delay-3">
                    <div class="value-card-premium">
                        <div class="value-icon-badge">
                            <i class="bi bi-chat-quote"></i>
                        </div>
                        <span class="value-pill">True Readers</span>
                        <p class="value-card-desc">We connect books with readers who truly care.</p>
                    </div>
                </div>
                <div class="col-sm-6 col-lg-3 animate-card-rise delay-4">
                    <div class="value-card-premium">
                        <div class="value-icon-badge">
                            <i class="bi bi-stars"></i>
                        </div>
                        <span class="value-pill">Story Magic</span>
                        <p class="value-card-desc">We celebrate creativity, diversity, and the magic of storytelling.</p>
                    </div>
                </div>
            </div>

            <!-- Bottom Horizontal Value Banner -->
            <div class="values-bottom-bar">
                <div class="values-bar-text">
                    <i class="bi bi-bookmark-fill" style="color: var(--gold-accent);"></i>
                    <span>Your story matters &mdash; let's make it unforgettable.</span>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/books" class="btn btn-plum">
                        Get Started Today
                    </a>
                </div>
            </div>
        </div>
    </section>

    <!-- =========================================================================
         5. FEATURED CATALOG PREVIEW (Connected to books.txt & Shopping Cart)
         ========================================================================= -->
    <section class="py-5" style="background-color: var(--bg-ivory); border-top: 1px solid var(--border-warm);">
        <div class="container my-3">
            <div class="d-flex flex-wrap justify-content-between align-items-end mb-4">
                <div>
                    <span class="text-uppercase small fw-bold tracking-widest text-muted">Curated Literature</span>
                    <h2 class="font-serif fw-bold text-dark mb-0">Featured Titles from the Catalog</h2>
                </div>
                <a href="${pageContext.request.contextPath}/books" class="btn btn-outline-plum mt-3 mt-md-0">
                    View Complete Catalog &rarr;
                </a>
            </div>

            <div class="row g-4">
                <c:forEach items="${featuredBooks}" var="b" varStatus="loop">
                    <div class="col-md-6 col-lg-3 animate-card-rise delay-${(loop.index % 8) + 1}">
                        <div class="book-card-editorial shadow-sm">
                            <div class="book-cover-editorial position-relative overflow-hidden" style="min-height: 200px; height: 200px;">
                                <c:choose>
                                    <c:when test="${not empty b.imageUrl}">
                                        <img src="${b.imageUrl}" alt="${b.title}" style="width: 100%; height: 100%; object-fit: cover;"
                                             onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                        <div class="d-flex flex-column align-items-center justify-content-center w-100 h-100" style="display: none !important;">
                                            <i class="bi bi-book fs-1 mb-2"></i>
                                            <small class="text-white-50">${b.category}</small>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <i class="bi bi-book fs-1 mb-2"></i>
                                        <small class="text-white-50">${b.category}</small>
                                    </c:otherwise>
                                </c:choose>
                                <span class="badge ${b.bookType == 'EBOOK' ? 'badge-ebook' : 'badge-printed'} position-absolute top-0 end-0 m-3 shadow-sm">
                                    ${b.bookType}
                                </span>
                            </div>
                            <div class="p-4 d-flex flex-column flex-grow-1">
                                <h5 class="font-serif fw-bold text-dark mb-1 text-truncate" title="${b.title}">
                                    ${b.title}
                                </h5>
                                <small class="text-muted mb-3">By ${b.author}</small>
                                
                                <p class="small text-secondary mb-3 flex-grow-1" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                                    ${b.description}
                                </p>

                                <div class="d-flex justify-content-between align-items-center pt-3 border-top mt-auto">
                                    <span class="fs-5 fw-bold text-dark">
                                        Rs. <fmt:formatNumber value="${b.calculateFinalPrice()}" minFractionDigits="2"/>
                                    </span>
                                    <div class="d-flex gap-1">
                                        <a href="${pageContext.request.contextPath}/books/view?id=${b.bookId}" class="btn btn-sm btn-outline-secondary rounded-pill px-3">
                                            Details
                                        </a>
                                        <c:if test="${b.isInStock()}">
                                            <form action="${pageContext.request.contextPath}/cart/add" method="post" class="d-inline">
                                                <input type="hidden" name="bookId" value="${b.bookId}"/>
                                                <input type="hidden" name="quantity" value="1"/>
                                                <button type="submit" class="btn btn-sm btn-plum rounded-pill px-3" title="Add to Cart">
                                                    <i class="bi bi-bag-plus"></i>
                                                </button>
                                            </form>
                                        </c:if>
                                        <c:if test="${sessionScope.currentUser != null && sessionScope.currentUser.hasAdminPrivileges()}">
                                            <a href="${pageContext.request.contextPath}/books/edit?id=${b.bookId}" class="btn btn-sm btn-outline-plum rounded-pill px-2" title="Edit Book">
                                                <i class="bi bi-pencil"></i>
                                            </a>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section>
</main>

<jsp:include page="common/footer.jsp"/>
