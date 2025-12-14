<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>
                <c:out value="${pageTitle != null ? pageTitle : 'Project Management'}" />
            </title>
            <!-- Tailwind CSS -->
            <script src="https://cdn.tailwindcss.com"></script>
            <!-- Font Awesome -->
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <!-- Custom Styles -->
            <style>
                .sidebar {
                    transition: all 0.3s;
                }

                .sidebar.collapsed {
                    width: 70px;
                }

                .sidebar.collapsed .sidebar-text {
                    display: none;
                }

                .task-card {
                    border-left-width: 4px;
                }

                .priority-critical {
                    border-left-color: #dc2626;
                }

                .priority-high {
                    border-left-color: #ef4444;
                }

                .priority-medium {
                    border-left-color: #f59e0b;
                }

                .priority-low {
                    border-left-color: #10b981;
                }

                .kanban-column {
                    min-height: 500px;
                }

                .progress-bar {
                    transition: width 0.6s ease;
                }
            </style>
        </head>

        <body class="bg-gray-50">
            <div class="flex h-screen">
                <!-- Sidebar -->
                <div class="sidebar bg-gray-900 text-white w-64 flex flex-col">
                    <!-- Logo -->
                    <div class="p-6 border-b border-gray-800">
                        <div class="flex items-center space-x-3">
                            <i class="fas fa-tasks text-blue-400 text-xl"></i>
                            <h1 class="text-xl font-bold sidebar-text">ProjectFlow</h1>
                        </div>
                    </div>

                    <!-- Navigation -->
                    <nav class="flex-1 p-4">
                        <ul class="space-y-2">
                            <li>
                                <a href="${pageContext.request.contextPath}/dashboard"
                                    class="flex items-center space-x-3 p-3 rounded-lg hover:bg-gray-800 ${requestScope['jakarta.servlet.forward.request_uri'].contains('dashboard') ? 'bg-gray-800' : ''}">
                                    <i class="fas fa-chart-line w-6"></i>
                                    <span class="sidebar-text">Dashboard</span>
                                </a>
                            </li>
                            <li>
                                <a href="${pageContext.request.contextPath}/projects/"
                                    class="flex items-center space-x-3 p-3 rounded-lg hover:bg-gray-800 ${requestScope['jakarta.servlet.forward.request_uri'].contains('projects') ? 'bg-gray-800' : ''}">
                                    <i class="fas fa-project-diagram w-6"></i>
                                    <span class="sidebar-text">Projects</span>
                                </a>
                            </li>
                            <li>
                                <a href="${pageContext.request.contextPath}/tasks/"
                                    class="flex items-center space-x-3 p-3 rounded-lg hover:bg-gray-800 ${requestScope['jakarta.servlet.forward.request_uri'].contains('tasks') ? 'bg-gray-800' : ''}">
                                    <i class="fas fa-tasks w-6"></i>
                                    <span class="sidebar-text">Tasks</span>
                                </a>
                            </li>
                            <li>
                                <a href="${pageContext.request.contextPath}/tasks/kanban"
                                    class="flex items-center space-x-3 p-3 rounded-lg hover:bg-gray-800">
                                    <i class="fas fa-columns w-6"></i>
                                    <span class="sidebar-text">Kanban Board</span>
                                </a>
                            </li>
                            <c:if test="${user.role == 'ADMIN'}">
                                <li>
                                    <a href="${pageContext.request.contextPath}/admin/users"
                                        class="flex items-center space-x-3 p-3 rounded-lg hover:bg-gray-800">
                                        <i class="fas fa-users-cog w-6"></i>
                                        <span class="sidebar-text">Admin</span>
                                    </a>
                                </li>
                            </c:if>
                        </ul>

                        <!-- User Profile -->
                        <div class="mt-8 pt-8 border-t border-gray-800">
                            <div class="flex items-center space-x-3 p-3">
                                <div class="w-8 h-8 rounded-full bg-blue-500 flex items-center justify-center">
                                    <span class="text-sm font-semibold">
                                        <c:out value="${user.name.charAt(0)}" />
                                    </span>
                                </div>
                                <div class="sidebar-text">
                                    <p class="text-sm font-medium">
                                        <c:out value="${user.name}" />
                                    </p>
                                    <p class="text-xs text-gray-400">
                                        <c:out value="${user.role}" />
                                    </p>
                                </div>
                            </div>

                            <form action="${pageContext.request.contextPath}/user/logout" method="post" class="mt-2">
                                <input type="hidden" name="action" value="logout">
                                <button type="submit"
                                    class="flex items-center space-x-3 p-3 w-full text-left rounded-lg hover:bg-gray-800 text-red-400">
                                    <i class="fas fa-sign-out-alt w-6"></i>
                                    <span class="sidebar-text">Logout</span>
                                </button>
                            </form>
                        </div>
                    </nav>
                </div>

                <!-- Main Content -->
                <div class="flex-1 flex flex-col overflow-hidden">
                    <!-- Header -->
                    <header class="bg-white shadow-sm border-b">
                        <div class="flex items-center justify-between px-6 py-4">
                            <div>
                                <h2 class="text-xl font-semibold text-gray-800">
                                    <c:out value="${pageTitle != null ? pageTitle : 'Dashboard'}" />
                                </h2>
                                <p class="text-sm text-gray-600 mt-1">
                                    <c:out
                                        value="${pageSubtitle != null ? pageSubtitle : 'Project management dashboard'}" />
                                </p>
                            </div>

                            <div class="flex items-center space-x-4">


                                <!-- Search -->
                                <div class="relative">
                                    <input type="text" placeholder="Search..."
                                        class="pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                                    <i class="fas fa-search absolute left-3 top-3 text-gray-400"></i>
                                </div>
                            </div>
                        </div>
                    </header>

                    <!-- Page Content -->
                    <main class="flex-1 overflow-y-auto p-6">
                        <!-- Alert Messages -->
                        <c:if test="${not empty success}">
                            <div class="mb-4 p-4 bg-green-50 border border-green-200 rounded-lg">
                                <div class="flex items-center">
                                    <i class="fas fa-check-circle text-green-500 mr-3"></i>
                                    <span class="text-green-700">
                                        <c:out value="${success}" />
                                    </span>
                                </div>
                            </div>
                        </c:if>

                        <c:if test="${not empty error}">
                            <div class="mb-4 p-4 bg-red-50 border border-red-200 rounded-lg">
                                <div class="flex items-center">
                                    <i class="fas fa-exclamation-circle text-red-500 mr-3"></i>
                                    <span class="text-red-700">
                                        <c:out value="${error}" />
                                    </span>
                                </div>
                            </div>
                        </c:if>

                        <!-- Dynamic Content -->
                        <jsp:include page="${contentPage}" />
                    </main>
                </div>
            </div>

            <!-- JavaScript -->
            <script>
                // Toggle sidebar
                function toggleSidebar() {
                    document.querySelector('.sidebar').classList.toggle('collapsed');
                }

                // Update progress bars
                function updateProgressBars() {
                    document.querySelectorAll('.progress-bar').forEach(bar => {
                        const width = bar.style.width;
                        bar.style.width = '0';
                        setTimeout(() => {
                            bar.style.width = width;
                        }, 100);
                    });
                }

                // Initialize tooltips
                document.addEventListener('DOMContentLoaded', function () {
                    updateProgressBars();

                    // Add click handlers for status updates
                    document.querySelectorAll('.status-btn').forEach(btn => {
                        btn.addEventListener('click', function () {
                            const taskId = this.dataset.taskId;
                            const status = this.dataset.status;
                            updateTaskStatus(taskId, status);
                        });
                    });
                });

                // Update task status via AJAX
                function updateTaskStatus(taskId, status) {
                    fetch('${pageContext.request.contextPath}/api/tasks/' + taskId, {
                        method: 'PUT',
                        headers: {
                            'Content-Type': 'application/json',
                        },
                        body: JSON.stringify({ status: status })
                    })
                        .then(response => response.json())
                        .then(data => {
                            location.reload();
                        })
                        .catch(error => console.error('Error:', error));
                }
            </script>
        </body>

        </html>