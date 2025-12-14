<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

            <!-- Back Button with gradient -->
            <div class="mb-6">
                <a href="${pageContext.request.contextPath}/projects/"
                    class="inline-flex items-center px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors">
                    <i class="fas fa-arrow-left mr-2"></i> Back to Projects
                </a>
            </div>

            <!-- Project Header with Gradient Background -->
            <div class="bg-gradient-to-r from-blue-500 to-blue-600 rounded-xl shadow-lg overflow-hidden mb-6">
                <div class="p-8 text-white">
                    <div class="flex items-start justify-between">
                        <div class="flex-1">
                            <h1 class="text-3xl font-bold mb-3">${project.name}</h1>
                            <c:if test="${not empty project.description}">
                                <p class="text-blue-100 text-lg max-w-3xl">${project.description}</p>
                            </c:if>
                        </div>
                        <div>
                            <c:choose>
                                <c:when test="${project.status == 'ACTIVE'}">
                                    <span
                                        class="px-4 py-2 bg-green-500 bg-opacity-90 rounded-full text-sm font-semibold backdrop-blur-sm">
                                        <i class="fas fa-circle mr-1"></i> Active
                                    </span>
                                </c:when>
                                <c:when test="${project.status == 'COMPLETED'}">
                                    <span
                                        class="px-4 py-2 bg-purple-500 bg-opacity-90 rounded-full text-sm font-semibold backdrop-blur-sm">
                                        <i class="fas fa-check-circle mr-1"></i> Completed
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span
                                        class="px-4 py-2 bg-amber-500 bg-opacity-90 rounded-full text-sm font-semibold backdrop-blur-sm">
                                        <i class="fas fa-pause-circle mr-1"></i> On Hold
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Project Meta Info with icons -->
                    <div class="flex flex-wrap gap-6 mt-6 pt-6 border-t border-blue-400 border-opacity-30">
                        <div class="flex items-center text-blue-100">
                            <div
                                class="w-10 h-10 bg-white bg-opacity-20 rounded-lg flex items-center justify-center mr-3">
                                <i class="fas fa-user"></i>
                            </div>
                            <div>
                                <p class="text-xs text-blue-200">Owner</p>
                                <p class="font-semibold">${project.owner.name}</p>
                            </div>
                        </div>
                        <div class="flex items-center text-blue-100">
                            <div
                                class="w-10 h-10 bg-white bg-opacity-20 rounded-lg flex items-center justify-center mr-3">
                                <i class="fas fa-calendar-plus"></i>
                            </div>
                            <div>
                                <p class="text-xs text-blue-200">Created</p>
                                <p class="font-semibold">${project.createdDate.toString().substring(0, 10)}</p>
                            </div>
                        </div>
                        <c:if test="${not empty project.dueDate}">
                            <div class="flex items-center text-blue-100">
                                <div
                                    class="w-10 h-10 bg-white bg-opacity-20 rounded-lg flex items-center justify-center mr-3">
                                    <i class="fas fa-flag"></i>
                                </div>
                                <div>
                                    <p class="text-xs text-blue-200">Due Date</p>
                                    <p class="font-semibold">${project.dueDate.toString().substring(0, 10)}</p>
                                </div>
                            </div>
                        </c:if>
                        <div class="flex items-center text-blue-100">
                            <div
                                class="w-10 h-10 bg-white bg-opacity-20 rounded-lg flex items-center justify-center mr-3">
                                <i class="fas fa-users"></i>
                            </div>
                            <div>
                                <p class="text-xs text-blue-200">Team Size</p>
                                <p class="font-semibold">${fn:length(members)} Members</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Statistics Cards with Hover Effects -->
            <div class="grid grid-cols-4 gap-4 mb-6">
                <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6 hover:shadow-md transition-shadow">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm text-gray-600 font-medium">Total Tasks</p>
                            <h3 class="text-4xl font-bold text-blue-600 mt-2">${totalTasks != null ? totalTasks : 0}
                            </h3>
                        </div>
                        <div class="w-14 h-14 bg-blue-100 rounded-xl flex items-center justify-center">
                            <i class="fas fa-tasks text-blue-600 text-2xl"></i>
                        </div>
                    </div>
                </div>

                <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6 hover:shadow-md transition-shadow">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm text-gray-600 font-medium">To Do</p>
                            <h3 class="text-4xl font-bold text-gray-600 mt-2">${todoTasks != null ? todoTasks : 0}</h3>
                        </div>
                        <div class="w-14 h-14 bg-gray-100 rounded-xl flex items-center justify-center">
                            <i class="fas fa-circle text-gray-600 text-2xl"></i>
                        </div>
                    </div>
                </div>

                <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6 hover:shadow-md transition-shadow">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm text-gray-600 font-medium">In Progress</p>
                            <h3 class="text-4xl font-bold text-amber-600 mt-2">${inProgressTasks != null ?
                                inProgressTasks : 0}</h3>
                        </div>
                        <div class="w-14 h-14 bg-amber-100 rounded-xl flex items-center justify-center">
                            <i class="fas fa-spinner text-amber-600 text-2xl"></i>
                        </div>
                    </div>
                </div>

                <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6 hover:shadow-md transition-shadow">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm text-gray-600 font-medium">Completed</p>
                            <h3 class="text-4xl font-bold text-green-600 mt-2">${doneTasks != null ? doneTasks : 0}</h3>
                        </div>
                        <div class="w-14 h-14 bg-green-100 rounded-xl flex items-center justify-center">
                            <i class="fas fa-check-circle text-green-600 text-2xl"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Progress Section with Better Design -->
            <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6 mb-6">
                <div class="flex items-center justify-between mb-4">
                    <h4 class="text-lg font-semibold text-gray-900">
                        <i class="fas fa-chart-line mr-2 text-blue-600"></i>
                        Project Progress
                    </h4>
                    <span class="text-3xl font-bold text-blue-600">
                        ${completionPercentage != null ? completionPercentage : 0}%
                    </span>
                </div>
                <div class="w-full bg-gray-200 rounded-full h-4 overflow-hidden">
                    <c:set var="completion" value="${completionPercentage != null ? completionPercentage : 0}" />
                    <div class="h-4 progress-bar transition-all duration-500 ease-out rounded-full ${completion < 30 ? 'bg-gradient-to-r from-red-500 to-red-600' : completion < 70 ? 'bg-gradient-to-r from-amber-500 to-amber-600' : 'bg-gradient-to-r from-green-500 to-green-600'}"
                        style="width: ${completion}%"></div>
                </div>
                <p class="text-sm text-gray-600 mt-2">
                    <c:choose>
                        <c:when test="${completion == 0}">Get started by creating tasks!</c:when>
                        <c:when test="${completion < 30}">Just getting started - keep pushing forward!</c:when>
                        <c:when test="${completion < 70}">Making good progress!</c:when>
                        <c:when test="${completion < 100}">Almost there - great work!</c:when>
                        <c:otherwise>Project complete! 🎉</c:otherwise>
                    </c:choose>
                </p>
            </div>

            <!-- Main Content Grid -->
            <div class="grid grid-cols-3 gap-6">
                <!-- Tasks Section (2 columns) -->
                <div class="col-span-2 space-y-6">
                    <!-- Tasks List -->
                    <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                        <div class="flex items-center justify-between mb-6">
                            <h4 class="text-xl font-semibold text-gray-900">
                                <i class="fas fa-list-check mr-2 text-blue-600"></i>
                                Tasks
                            </h4>
                            <a href="${pageContext.request.contextPath}/tasks/create?projectId=${project.id}"
                                class="inline-flex items-center px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 shadow-sm transition-colors">
                                <i class="fas fa-plus mr-2"></i> Add Task
                            </a>
                        </div>

                        <c:choose>
                            <c:when test="${empty tasks}">
                                <div class="text-center py-16 bg-gray-50 rounded-lg">
                                    <div
                                        class="w-20 h-20 bg-gray-200 rounded-full flex items-center justify-center mx-auto mb-4">
                                        <i class="fas fa-tasks text-gray-400 text-3xl"></i>
                                    </div>
                                    <h5 class="text-lg font-semibold text-gray-900 mb-2">No tasks yet</h5>
                                    <p class="text-gray-600 mb-6">Create your first task to get started with this
                                        project</p>
                                    <a href="${pageContext.request.contextPath}/tasks/create?projectId=${project.id}"
                                        class="inline-flex items-center px-5 py-2.5 bg-blue-600 text-white rounded-lg hover:bg-blue-700 shadow-sm">
                                        <i class="fas fa-plus mr-2"></i> Create First Task
                                    </a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="space-y-3 max-h-[700px] overflow-y-auto pr-2">
                                    <c:forEach var="task" items="${tasks}">
                                        <div class="group border border-gray-200 rounded-lg p-4 hover:border-blue-400 hover:shadow-md transition-all cursor-pointer bg-white"
                                            onclick="window.location.href='${pageContext.request.contextPath}/tasks/${task.id}'">
                                            <div class="flex items-start justify-between">
                                                <div class="flex-1">
                                                    <h5
                                                        class="font-semibold text-gray-900 mb-2 group-hover:text-blue-600 transition-colors">
                                                        ${fn:substring(task.title, 0, 80)}${fn:length(task.title) > 80 ?
                                                        '...' : ''}
                                                    </h5>
                                                    <div class="flex gap-2 flex-wrap">
                                                        <!-- Status Badge -->
                                                        <c:choose>
                                                            <c:when test="${task.status == 'TODO'}">
                                                                <span
                                                                    class="px-3 py-1 text-xs font-semibold rounded-full bg-gray-100 text-gray-700 border border-gray-300">
                                                                    <i class="fas fa-circle mr-1"></i> To Do
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${task.status == 'IN_PROGRESS'}">
                                                                <span
                                                                    class="px-3 py-1 text-xs font-semibold rounded-full bg-amber-100 text-amber-700 border border-amber-300">
                                                                    <i class="fas fa-spinner mr-1"></i> In Progress
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${task.status == 'DONE'}">
                                                                <span
                                                                    class="px-3 py-1 text-xs font-semibold rounded-full bg-green-100 text-green-700 border border-green-300">
                                                                    <i class="fas fa-check-circle mr-1"></i> Done
                                                                </span>
                                                            </c:when>
                                                        </c:choose>

                                                        <!-- Priority Badge -->
                                                        <c:choose>
                                                            <c:when test="${task.priority == 'HIGH'}">
                                                                <span
                                                                    class="px-3 py-1 text-xs font-semibold rounded-full bg-red-100 text-red-700 border border-red-300">
                                                                    <i class="fas fa-exclamation-circle mr-1"></i> High
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${task.priority == 'MEDIUM'}">
                                                                <span
                                                                    class="px-3 py-1 text-xs font-semibold rounded-full bg-blue-100 text-blue-700 border border-blue-300">
                                                                    <i class="fas fa-minus-circle mr-1"></i> Medium
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${task.priority == 'LOW'}">
                                                                <span
                                                                    class="px-3 py-1 text-xs font-semibold rounded-full bg-gray-100 text-gray-600 border border-gray-300">
                                                                    <i class="fas fa-arrow-down mr-1"></i> Low
                                                                </span>
                                                            </c:when>
                                                        </c:choose>
                                                    </div>
                                                </div>

                                                <!-- Task Meta -->
                                                <div class="flex flex-col items-end text-sm text-gray-600 ml-4">
                                                    <c:if test="${not empty task.assignee}">
                                                        <div class="flex items-center gap-2 mb-2">
                                                            <div class="w-8 h-8 rounded-full bg-gradient-to-br from-blue-500 to-blue-600 text-white flex items-center justify-center text-xs font-semibold shadow-sm"
                                                                title="${task.assignee.name}">
                                                                ${fn:substring(task.assignee.name, 0, 1)}
                                                            </div>
                                                        </div>
                                                    </c:if>
                                                    <c:if test="${not empty task.dueDate}">
                                                        <div class="flex items-center text-xs">
                                                            <i class="fas fa-calendar mr-1.5"></i>
                                                            <span>${task.dueDate.toString().substring(0, 10)}</span>
                                                        </div>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Sidebar (1 column) -->
                <div class="space-y-6">
                    <!-- Quick Actions -->
                    <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                        <h5 class="font-semibold text-gray-900 mb-4 flex items-center">
                            <i class="fas fa-bolt mr-2 text-amber-500"></i>
                            Quick Actions
                        </h5>
                        <div class="space-y-2">
                            <a href="${pageContext.request.contextPath}/tasks/create?projectId=${project.id}"
                                class="flex items-center w-full px-4 py-3 border-2 border-gray-200 rounded-lg text-gray-700 hover:bg-blue-50 hover:border-blue-300 transition-all">
                                <i class="fas fa-plus text-blue-600 mr-3 w-5"></i> Add Task
                            </a>
                            <a href="${pageContext.request.contextPath}/tasks/kanban?projectId=${project.id}"
                                class="flex items-center w-full px-4 py-3 border-2 border-gray-200 rounded-lg text-gray-700 hover:bg-purple-50 hover:border-purple-300 transition-all">
                                <i class="fas fa-columns text-purple-600 mr-3 w-5"></i> Kanban Board
                            </a>
                            <a href="${pageContext.request.contextPath}/projects/edit/${project.id}"
                                class="flex items-center w-full px-4 py-3 border-2 border-gray-200 rounded-lg text-gray-700 hover:bg-green-50 hover:border-green-300 transition-all">
                                <i class="fas fa-edit text-green-600 mr-3 w-5"></i> Edit Project
                            </a>
                        </div>
                    </div>

                    <!-- Team Members -->
                    <jsp:include page="/WEB-INF/templates/team-members.jsp" />
                </div>
            </div>