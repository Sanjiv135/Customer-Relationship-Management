<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CRM System - Professional Customer Relationship Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <style>
        .hero-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 100px 0;
            margin-bottom: 50px;
        }
        
        .feature-icon {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            color: white;
            font-size: 24px;
        }
        
        .feature-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
            padding: 30px 20px;
            text-align: center;
            height: 100%;
        }
        
        .feature-card:hover {
            transform: translateY(-5px);
        }
        
        .stats-section {
            background: #f8f9fa;
            padding: 60px 0;
        }
        
        .stat-number {
            font-size: 2.5rem;
            font-weight: bold;
            color: #667eea;
        }
        
        .cta-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 80px 0;
            text-align: center;
        }
        
        .btn-cta {
            background: white;
            color: #667eea;
            padding: 12px 30px;
            font-weight: bold;
            border-radius: 25px;
            border: none;
            transition: all 0.3s ease;
        }
        
        .btn-cta:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        
        .navbar-brand {
            font-weight: bold;
            font-size: 1.5rem;
        }
    </style>
</head>
<body>
   
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top">
        <div class="container">
            <a class="navbar-brand" href="index.jsp">
                <i class="fas fa-chart-line"></i> CRM Pro
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="login.jsp">Login</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="signup.jsp">Sign Up</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    
    <section class="hero-section">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6">
                    <h1 class="display-4 fw-bold mb-4">Streamline Your Customer Relationships</h1>
                    <p class="lead mb-4">Powerful CRM solution designed to help businesses of all sizes manage customer interactions, track complaints, and drive growth through better customer relationships.</p>
                    <a href="signup.jsp" class="btn btn-cta btn-lg">Get Started Free</a>
                </div>
                <div class="col-lg-6 text-center">
                    
                    <div style="font-size: 120px; opacity: 0.8;">👥</div>
                </div>
            </div>
        </div>
    </section>

   
    <section class="container mb-5">
        <div class="row text-center mb-5">
            <div class="col">
                <h2 class="fw-bold">Why Choose Our CRM?</h2>
                <p class="text-muted">Comprehensive features designed to transform your customer relationships</p>
            </div>
        </div>
        <div class="row g-4">
            <div class="col-md-4">
                <div class="feature-card">
                    <div class="feature-icon">
                        👥
                    </div>
                    <h5>Customer Management</h5>
                    <p class="text-muted">Centralize all customer information, interactions, and history in one secure platform.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="feature-card">
                    <div class="feature-icon">
                        📊
                    </div>
                    <h5>Analytics & Reporting</h5>
                    <p class="text-muted">Gain valuable insights with comprehensive analytics and customizable reports.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="feature-card">
                    <div class="feature-icon">
                        🔧
                    </div>
                    <h5>Complaint Resolution</h5>
                    <p class="text-muted">Efficiently track, manage, and resolve customer complaints with our streamlined workflow.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="feature-card">
                    <div class="feature-icon">
                        📱
                    </div>
                    <h5>Mobile Ready</h5>
                    <p class="text-muted">Access your CRM from anywhere with our fully responsive design.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="feature-card">
                    <div class="feature-icon">
                        🛡️
                    </div>
                    <h5>Secure & Reliable</h5>
                    <p class="text-muted">Enterprise-grade security with 99.9% uptime guarantee for your peace of mind.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="feature-card">
                    <div class="feature-icon">
                        ⚡
                    </div>
                    <h5>Fast Implementation</h5>
                    <p class="text-muted">Get up and running in hours, not weeks, with our intuitive interface.</p>
                </div>
            </div>
        </div>
    </section>

  
    <section class="stats-section">
        <div class="container">
            <div class="row text-center">
                <div class="col-md-3">
                    <div class="stat-number">500+</div>
                    <p class="text-muted">Businesses Trust Us</p>
                </div>
                <div class="col-md-3">
                    <div class="stat-number">50K+</div>
                    <p class="text-muted">Active Users</p>
                </div>
                <div class="col-md-3">
                    <div class="stat-number">99.9%</div>
                    <p class="text-muted">Uptime</p>
                </div>
                <div class="col-md-3">
                    <div class="stat-number">24/7</div>
                    <p class="text-muted">Support</p>
                </div>
            </div>
        </div>
    </section>

    
    <section class="cta-section">
        <div class="container">
            <h2 class="mb-4">Ready to Transform Your Customer Relationships?</h2>
            <p class="lead mb-4">Join thousands of businesses that trust our CRM solution</p>
            <div class="d-flex gap-3 justify-content-center flex-wrap">
                <a href="signup.jsp" class="btn btn-cta btn-lg">Start Free Trial</a>
                <a href="login.jsp" class="btn btn-outline-light btn-lg">Login to Account</a>
            </div>
        </div>
    </section>

   
    <footer class="bg-dark text-white py-4">
        <div class="container text-center">
            <p>&copy; 2025 CRM System. All rights reserved.</p>
            <p class="text-muted">Professional Customer Relationship Management Solution</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://kit.fontawesome.com/your-fontawesome-kit.js"></script>
</body>
</html>