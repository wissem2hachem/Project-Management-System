<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

            <!-- Dashboard Header -->
            <div class="mb-6">
                <h1 class="text-2xl font-bold text-gray-900">Welcome back, ${sessionScope.user.name}!</h1>
                <p class="text-gray-600 mt-1">Here's what's happening with your projects and tasks</p>
            </div>

            <!-- Statistics Cards -->
            <div class="grid grid-cols-4 gap-6 mb-6">
                <!-- Total Projects -->
                <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm text-gray-600">Total Projects</p>
                            <h3 class="text-3xl font-bold text-gray-900 mt-1">
                                ${dashboardStats != null ? dashboardStats.totalProjects : fn:length(projects)}
                            </h3>
                        </div>
                        <div class="p-3 rounded-lg bg-blue-100">
                            <i class="fas fa-folder text-blue-600 text-2xl"></i>
                        </div>
                    </div>
                </div>

                <!-- Total Tasks -->
                <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm text-gray-600">Total Tasks</p>
                            <h3 class="text-3xl font-bold text-gray-900 mt-1">
                                ${dashboardStats != null ? dashboardStats.totalTasks : 0}
                            </h3>
                        </div>
                        <div class="p-3 rounded-lg bg-green-100">
                            <i class="fas fa-tasks text-green-600 text-2xl"></i>
                        </div>
                    </div>
                </div>

                <!-- In Progress -->
                <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm text-gray-600">In Progress</p>
                            <h3 class="text-3xl font-bold text-gray-900 mt-1">
                                ${ dashboardStats != null ? dashboardStats.inProgressTasks : 0}
                            </h3>
                        </div>
                        <div class="p-3 rounded-lg bg-amber-100">
                            <i class="fas fa-spinner text-amber-600 text-2xl"></i>
                        </div>
                    </div>
                </div>

                <!-- Completed -->
                <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm text-gray-600">Completed</p>
                            <h3 class="text-3xl font-bold text-gray-900 mt-1">
                                ${dashboardStats != null ? dashboardStats.completedTasks : 0}
                            </h3>
                        </div>
                        <div class="p-3 rounded-lg bg-green-100">
                            <i class="fas fa-check-circle text-green-600 text-2xl"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Main Content Grid -->
            <div class="grid grid-cols-3 gap-6">
                <!-- Left Column (2/3) - Projects Overview -->
                <div class="col-span-2 space-y-6">
                    <!-- Projects Overview -->
                    <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
                        <div class="flex items-center justify-between mb-4">
                            <h2 class="text-lg font-semibold text-gray-900">
                                <i class="fas fa-folder-open mr-2"></i>
                                Your Projects
                            </h2>
                            <a href="${pageContext.request.contextPath}/projects/create"
                                class="text-sm text-blue-600 hover:text-blue-700">
                                <i class="fas fa-plus mr-1"></i> New Project
                            </a>
                        </div>

                        <c:choose>
                            <c:when test="${empty projects}">
                                <div class="text-center py-12">
                                    <i class="fas fa-folder-open text-gray-300 text-5xl mb-4"></i>
                                    <h3 class="text-lg font-semibold text-gray-900 mb-2">No projects yet</h3>
                                    <p class="text-gray-600 mb-4">Create your first project to get started</p>
                                    <a href="${pageContext.request.contextPath}/projects/create"
                                        class="inline-flex items-center px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
                                        <i class="fas fa-plus mr-2"></i> Create Project
                                    </a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="space-y-4">
                                    <c:forEach var="project" items="${projects}" varStatus="status">
                                        <c:if test="${status.index < 5}">
                                            <div class="border border-gray-200 rounded-lg p-4 hover:border-blue-300 hover:shadow-sm transition-all cursor-pointer"
                                                onclick="window.location.href='${pageContext.request.contextPath}/projects/view/${project.id}'">
                                                <div class="flex items-start justify-between mb-3">
                                                    <div>
                                                        <h4 class="font-semibold text-gray-900">${project.name}</h4>
                                                        <c:if test="${not empty project.description}">
                                                            <p class="text-sm text-gray-600 mt-1">
                                                                ${fn:substring(project.description, 0,
                                                                100)}${fn:length(project.description) > 100 ? '...' :
                                                                ''}
                                                            </p>
                                                        </c:if>
                                                    </div>
                                                    <c:choose>
                                                        <c:when test="${project.status == 'ACTIVE'}">
                                                            <span
                                                                class="px-2 py-1 text-xs font-medium rounded-full bg-green-100 text-green-800">
                                                                Active
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${project.status == 'COMPLETED'}">
                                                            <span
                                                                class="px-2 py-1 text-xs font-medium rounded-full bg-blue-100 text-blue-800">
                                                                Completed
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span
                                                                class="px-2 py-1 text-xs font-medium rounded-full bg-amber-100 text-amber-800">
                                                                On Hold
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>

                                                <!-- Progress Bar -->
                                                <c:set var="progress"
                                                    value="${project.progressPercentage != null ? project.progressPercentage : 0}" />
                                                <div class="mb-2">
                                                    <div class="flex items-center justify-between text-xs mb-1">
                                                        <span class="text-gray-600">Progress</span>
                                                        <span class="font-semibold text-blue-600">${progress}%</span>
                                                    </div>
                                                    <div class="w-full bg-gray-200 rounded-full h-2">
                                                        <div class="h-2 rounded-full progress-bar ${progress < 30 ? 'bg-red-500' : progress < 70 ? 'bg-amber-500' : 'bg-green-500'}"
                                                            style="width: ${progress}%"></div>
                                                    </div>
                                                </div>

                                                <!-- Meta Info -->
                                                <div class="flex items-center gap-4 text-xs text-gray-600">
                                                    <span>
                                                        <i class="fas fa-user mr-1"></i>
                                                        ${project.owner.name}
                                                    </span>
                                                    <c:if test="${not empty project.dueDate}">
                                                        <span>
                                                            <i class="fas fa-calendar mr-1"></i>
                                                            Due: ${project.dueDate.toString().substring(0, 10)}
                                                        </span>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </c:if>
                                    </c:forEach>

                                    <c:if test="${fn:length(projects) > 5}">
                                        <a href="${pageContext.request.contextPath}/projects/"
                                            class="block text-center text-sm text-blue-600 hover:text-blue-700 py-2">
                                            View all ${fn:length(projects)} projects →
                                        </a>
                                    </c:if>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Right Column (1/3) - Quick Actions & Stats -->
                <div class="space-y-6">
                    <!-- Quick Actions -->
                    <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
                        <h3 class="font-semibold text-gray-900 mb-4">
                            <i class="fas fa-bolt mr-2"></i>
                            Quick Actions
                        </h3>
                        <div class="space-y-2">
                            <a href="${pageContext.request.contextPath}/tasks/create"
                                class="flex items-center w-full px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50">
                                <i class="fas fa-plus mr-3"></i> Create Task
                            </a>
                            <a href="${pageContext.request.contextPath}/projects/create"
                                class="flex items-center w-full px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50">
                                <i class="fas fa-folder-plus mr-3"></i> New Project
                            </a>
                            <a href="${pageContext.request.contextPath}/tasks/kanban"
                                class="flex items-center w-full px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50">
                                <i class="fas fa-columns mr-3"></i> Kanban Board
                            </a>
                            <a href="${pageContext.request.contextPath}/tasks/"
                                class="flex items-center w-full px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50">
                                <i class="fas fa-tasks mr-3"></i> View All Tasks
                            </a>
                        </div>
                    </div>

                    <!-- Task Breakdown -->
                    <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
                        <h3 class="font-semibold text-gray-900 mb-4">
                            <i class="fas fa-chart-pie mr-2"></i>
                            Task Breakdown
                        </h3>
                        <div class="space-y-3">
                            <div class="flex items-center justify-between">
                                <div class="flex items-center">
                                    <div class="w-3 h-3 rounded-full bg-gray-400 mr-2"></div>
                                    <span class="text-sm text-gray-700">To Do</span>
                                </div>
                                <span class="font-semibold text-gray-900">
                                    ${dashboardStats != null ? dashboardStats.todoTasks : 0}
                                </span>
                            </div>
                            <div class="flex items-center justify-between">
                                <div class="flex items-center">
                                    <div class="w-3 h-3 rounded-full bg-amber-500 mr-2"></div>
                                    <span class="text-sm text-gray-700">In Progress</span>
                                </div>
                                <span class="font-semibold text-gray-900">
                                    ${dashboardStats != null ? dashboardStats.inProgressTasks : 0}
                                </span>
                            </div>
                            <div class="flex items-center justify-between">
                                <div class="flex items-center">
                                    <div class="w-3 h-3 rounded-full bg-green-500 mr-2"></div>
                                    <span class="text-sm text-gray-700">Done</span>
                                </div>
                                <span class="font-semibold text-gray-900">
                                    ${dashboardStats != null ? dashboardStats.completedTasks : 0}
                                </span>
                            </div>
                        </div>
                    </div>

                    <!-- Activity Summary -->
                    <div class="bg-blue-50 border border-blue-200 rounded-lg p-6">
                        <h3 class="font-semibold text-blue-900 mb-2">
                            <i class="fas fa-info-circle mr-2"></i>
                            Productivity Tip
                        </h3>
                        <p class="text-sm text-blue-800">
                            Break down large tasks into smaller, manageable pieces. Use the Kanban board to visualize
                            your workflow!
                        </p>
                    </div>
                </div>
            </div>