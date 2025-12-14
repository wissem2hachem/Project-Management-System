<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ProjectFlow - Modern Project Management</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .hero-gradient {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .feature-card {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .feature-card:hover {
            transform: translateY(-5px);
        }
    </style>
</head>
<body class="bg-gray-50">
<!-- Navigation -->
<nav class="bg-white shadow-sm">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16">
            <div class="flex items-center">
                <div class="flex-shrink-0 flex items-center">
                    <i class="fas fa-tasks text-blue-500 text-2xl mr-3"></i>
                    <span class="text-xl font-bold text-gray-900">ProjectFlow</span>
                </div>
                <div class="hidden sm:ml-6 sm:flex sm:space-x-8">
                    <a href="#features" class="text-gray-900 inline-flex items-center px-1 pt-1 text-sm font-medium">
                        Features
                    </a>
                    <a href="#how-it-works" class="text-gray-500 hover:text-gray-900 inline-flex items-center px-1 pt-1 text-sm font-medium">
                        How It Works
                    </a>
                    <a href="#pricing" class="text-gray-500 hover:text-gray-900 inline-flex items-center px-1 pt-1 text-sm font-medium">
                        Pricing
                    </a>
                </div>
            </div>
            <div class="flex items-center">
                <a href="${pageContext.request.contextPath}/auth/login.jsp"
                   class="text-gray-700 hover:text-gray-900 px-3 py-2 rounded-md text-sm font-medium">
                    Sign In
                </a>
                <a href="${pageContext.request.contextPath}/auth/register.jsp"
                   class="ml-4 inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-blue-600 hover:bg-blue-700">
                    Get Started
                </a>
            </div>
        </div>
    </div>
</nav>

<!-- Hero Section -->
<div class="hero-gradient">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-24">
        <div class="text-center">
            <h1 class="text-4xl tracking-tight font-extrabold text-white sm:text-5xl md:text-6xl">
                <span class="block">Streamline Your</span>
                <span class="block text-blue-200">Project Management</span>
            </h1>
            <p class="mt-3 max-w-md mx-auto text-xl text-blue-100 sm:text-2xl md:mt-5 md:max-w-3xl">
                The all-in-one platform for teams to plan, track, and collaborate on projects with ease.
            </p>
            <div class="mt-10 max-w-md mx-auto sm:flex sm:justify-center md:mt-12">
                <div class="rounded-md shadow">
                    <a href="${pageContext.request.contextPath}/auth/register.jsp"
                       class="w-full flex items-center justify-center px-8 py-3 border border-transparent text-base font-medium rounded-md text-blue-600 bg-white hover:bg-gray-50 md:py-4 md:text-lg md:px-10">
                        Start Free Trial
                    </a>
                </div>
                <div class="mt-3 rounded-md shadow sm:mt-0 sm:ml-3">
                    <a href="#features"
                       class="w-full flex items-center justify-center px-8 py-3 border border-transparent text-base font-medium rounded-md text-white bg-blue-500 hover:bg-blue-600 md:py-4 md:text-lg md:px-10">
                        Learn More
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Features Section -->
<div id="features" class="py-16 bg-white">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center">
            <h2 class="text-3xl font-extrabold text-gray-900 sm:text-4xl">
                Everything you need to manage projects
            </h2>
            <p class="mt-4 max-w-2xl text-xl text-gray-500 mx-auto">
                From simple task tracking to advanced project planning
            </p>
        </div>

        <div class="mt-16">
            <div class="grid grid-cols-1 gap-8 sm:grid-cols-2 lg:grid-cols-3">
                <!-- Feature 1 -->
                <div class="feature-card bg-white p-6 rounded-xl shadow-sm border border-gray-200">
                    <div class="w-12 h-12 rounded-lg bg-blue-100 flex items-center justify-center mb-6">
                        <i class="fas fa-tasks text-blue-500 text-xl"></i>
                    </div>
                    <h3 class="text-lg font-semibold text-gray-900 mb-3">Task Management</h3>
                    <p class="text-gray-600">
                        Create, assign, and track tasks with deadlines, priorities, and status updates.
                    </p>
                </div>

                <!-- Feature 2 -->
                <div class="feature-card bg-white p-6 rounded-xl shadow-sm border border-gray-200">
                    <div class="w-12 h-12 rounded-lg bg-green-100 flex items-center justify-center mb-6">
                        <i class="fas fa-columns text-green-500 text-xl"></i>
                    </div>
                    <h3 class="text-lg font-semibold text-gray-900 mb-3">Kanban Boards</h3>
                    <p class="text-gray-600">
                        Visualize workflow with drag-and-drop boards for better task organization.
                    </p>
                </div>

                <!-- Feature 3 -->
                <div class="feature-card bg-white p-6 rounded-xl shadow-sm border border-gray-200">
                    <div class="w-12 h-12 rounded-lg bg-purple-100 flex items-center justify-center mb-6">
                        <i class="fas fa-chart-line text-purple-500 text-xl"></i>
                    </div>
                    <h3 class="text-lg font-semibold text-gray-900 mb-3">Progress Tracking</h3>
                    <p class="text-gray-600">
                        Monitor project progress with real-time dashboards and analytics.
                    </p>
                </div>

                <!-- Feature 4 -->
                <div class="feature-card bg-white p-6 rounded-xl shadow-sm border border-gray-200">
                    <div class="w-12 h-12 rounded-lg bg-yellow-100 flex items-center justify-center mb-6">
                        <i class="fas fa-users text-yellow-500 text-xl"></i>
                    </div>
                    <h3 class="text-lg font-semibold text-gray-900 mb-3">Team Collaboration</h3>
                    <p class="text-gray-600">
                        Work together with comments, file sharing, and real-time notifications.
                    </p>
                </div>

                <!-- Feature 5 -->
                <div class="feature-card bg-white p-6 rounded-xl shadow-sm border border-gray-200">
                    <div class="w-12 h-12 rounded-lg bg-red-100 flex items-center justify-center mb-6">
                        <i class="fas fa-calendar-alt text-red-500 text-xl"></i>
                    </div>
                    <h3 class="text-lg font-semibold text-gray-900 mb-3">Time Tracking</h3>
                    <p class="text-gray-600">
                        Track time spent on tasks and generate detailed reports for analysis.
                    </p>
                </div>

                <!-- Feature 6 -->
                <div class="feature-card bg-white p-6 rounded-xl shadow-sm border border-gray-200">
                    <div class="w-12 h-12 rounded-lg bg-indigo-100 flex items-center justify-center mb-6">
                        <i class="fas fa-mobile-alt text-indigo-500 text-xl"></i>
                    </div>
                    <h3 class="text-lg font-semibold text-gray-900 mb-3">Mobile Access</h3>
                    <p class="text-gray-600">
                        Stay productive on the go with our mobile-friendly interface and apps.
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- How It Works -->
<div id="how-it-works" class="py-16 bg-gray-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center">
            <h2 class="text-3xl font-extrabold text-gray-900 sm:text-4xl">
                How It Works
            </h2>
            <p class="mt-4 max-w-2xl text-xl text-gray-500 mx-auto">
                Get started in just a few simple steps
            </p>
        </div>

        <div class="mt-16">
            <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                <!-- Step 1 -->
                <div class="text-center">
                    <div class="flex items-center justify-center w-16 h-16 bg-blue-100 rounded-full mx-auto mb-6">
                        <span class="text-2xl font-bold text-blue-600">1</span>
                    </div>
                    <h3 class="text-lg font-semibold text-gray-900 mb-3">Create Your Project</h3>
                    <p class="text-gray-600">
                        Set up your project with goals, timelines, and team members.
                    </p>
                </div>

                <!-- Step 2 -->
                <div class="text-center">
                    <div class="flex items-center justify-center w-16 h-16 bg-green-100 rounded-full mx-auto mb-6">
                        <span class="text-2xl font-bold text-green-600">2</span>
                    </div>
                    <h3 class="text-lg font-semibold text-gray-900 mb-3">Add Tasks & Assign</h3>
                    <p class="text-gray-600">
                        Break down projects into tasks and assign them to team members.
                    </p>
                </div>

                <!-- Step 3 -->
                <div class="text-center">
                    <div class="flex items-center justify-center w-16 h-16 bg-purple-100 rounded-full mx-auto mb-6">
                        <span class="text-2xl font-bold text-purple-600">3</span>
                    </div>
                    <h3 class="text-lg font-semibold text-gray-900 mb-3">Track & Collaborate</h3>
                    <p class="text-gray-600">
                        Monitor progress, collaborate in real-time, and achieve your goals.
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- CTA Section -->
<div class="bg-blue-700">
    <div class="max-w-7xl mx-auto py-12 px-4 sm:px-6 lg:py-16 lg:px-8 lg:flex lg:items-center lg:justify-between">
        <h2 class="text-3xl font-extrabold tracking-tight text-white sm:text-4xl">
            <span class="block">Ready to get started?</span>
            <span class="block text-blue-200">Start your free trial today.</span>
        </h2>
        <div class="mt-8 flex lg:mt-0 lg:flex-shrink-0">
            <div class="inline-flex rounded-md shadow">
                <a href="${pageContext.request.contextPath}/auth/register.jsp"
                   class="inline-flex items-center justify-center px-5 py-3 border border-transparent text-base font-medium rounded-md text-blue-600 bg-white hover:bg-gray-50">
                    Sign up for free
                </a>
            </div>
            <div class="ml-3 inline-flex rounded-md shadow">
                <a href="${pageContext.request.contextPath}/auth/login.jsp"
                   class="inline-flex items-center justify-center px-5 py-3 border border-transparent text-base font-medium rounded-md text-white bg-blue-600 hover:bg-blue-700">
                    Sign in
                </a>
            </div>
        </div>
    </div>
</div>

<!-- Footer -->
<footer class="bg-white">
    <div class="max-w-7xl mx-auto py-12 px-4 sm:px-6 md:flex md:items-center md:justify-between lg:px-8">
        <div class="flex justify-center space-x-6 md:order-2">
            <a href="#" class="text-gray-400 hover:text-gray-500">
                <i class="fab fa-twitter"></i>
            </a>
            <a href="#" class="text-gray-400 hover:text-gray-500">
                <i class="fab fa-facebook"></i>
            </a>
            <a href="#" class="text-gray-400 hover:text-gray-500">
                <i class="fab fa-linkedin"></i>
            </a>
            <a href="#" class="text-gray-400 hover:text-gray-500">
                <i class="fab fa-github"></i>
            </a>
        </div>
        <div class="mt-8 md:mt-0 md:order-1">
            <p class="text-center text-base text-gray-400">
                &copy; 2024 ProjectFlow. All rights reserved.
            </p>
        </div>
    </div>
</footer>
</body>
</html>