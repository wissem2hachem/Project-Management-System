<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

                <div id="project-detail-content">
                    <!-- Project Header -->
                    <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6 mb-8">
                        <div class="flex flex-col lg:flex-row lg:items-start lg:justify-between">
                            <div class="flex-1">
                                <div class="flex items-center mb-4">
                                    <div class="w-12 h-12 rounded-lg bg-blue-100 flex items-center justify-center mr-4">
                                        <i class="fas fa-project-diagram text-blue-500 text-xl"></i>
                                    </div>
                                    <div>
                                        <h1 class="text-2xl font-bold text-gray-900">
                                            <c:out value="${project.name}" />
                                        </h1>
                                        <div class="flex items-center mt-2 space-x-4">
                                            <span class="px-3 py-1 rounded-full text-sm font-medium
                                        ${project.status == 'COMPLETED' ? 'bg-green-100 text-green-800' :
                                          project.status == 'IN_PROGRESS' ? 'bg-blue-100 text-blue-800' :
                                          project.status == 'ON_HOLD' ? 'bg-yellow-100 text-yellow-800' :
                                          'bg-gray-100 text-gray-800'}">
                                                <c:out value="${project.status}" />
                                            </span>
                                            <span class="text-sm text-gray-600">
                                                <i class="fas fa-user mr-1"></i>
                                                Owner:
                                                <c:out value="${project.owner.name}" />
                                            </span>
                                            <span class="text-sm text-gray-600">
                                                <i class="fas fa-calendar-alt mr-1"></i>
                                                Due:
                                                <fmt:formatDate value="${project.dueDate}" pattern="MMM dd, yyyy" />
                                            </span>
                                        </div>
                                    </div>
                                </div>

                                <p class="text-gray-700 mb-6">
                                    <c:out value="${project.description}" />
                                </p>

                                <!-- Progress Bar -->
                                <div class="mb-4">
                                    <div class="flex justify-between text-sm text-gray-600 mb-2">
                                        <span>Project Progress</span>
                                        <span>${project.progressPercentage}%</span>
                                    </div>
                                    <div class="w-full bg-gray-200 rounded-full h-3">
                                        <div class="bg-blue-600 h-3 rounded-full progress-bar"
                                            style="width: ${project.progressPercentage}%"></div>
                                    </div>
                                </div>
                            </div>

                            <div class="mt-4 lg:mt-0 flex space-x-3">
                                <button
                                    class="inline-flex items-center px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50">
                                    <i class="fas fa-edit mr-2"></i>
                                    Edit
                                </button>
                                <a href="${pageContext.request.contextPath}/tasks/create?projectId=${project.id}"
                                    class="inline-flex items-center px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
                                    <i class="fas fa-plus mr-2"></i>
                                    Add Task
                                </a>
                            </div>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
                        <!-- Main Content -->
                        <div class="lg:col-span-2 space-y-8">
                            <!-- Quick Stats -->
                            <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                                <div class="bg-white rounded-lg border border-gray-200 p-4">
                                    <div class="text-center">
                                        <p class="text-2xl font-bold text-gray-900">${fn:length(project.tasks)}</p>
                                        <p class="text-sm text-gray-600 mt-1">Total Tasks</p>
                                    </div>
                                </div>

                                <div class="bg-white rounded-lg border border-gray-200 p-4">
                                    <div class="text-center">
                                        <p class="text-2xl font-bold text-green-600">
                                            ${fn:length(project.tasks) - fn:length(tasks.filter(t -> t.status !=
                                            'DONE'))}
                                        </p>
                                        <p class="text-sm text-gray-600 mt-1">Completed</p>
                                    </div>
                                </div>

                                <div class="bg-white rounded-lg border border-gray-200 p-4">
                                    <div class="text-center">
                                        <p class="text-2xl font-bold text-blue-600">
                                            ${fn:length(tasks.filter(t -> t.status == 'IN_PROGRESS'))}
                                        </p>
                                        <p class="text-sm text-gray-600 mt-1">In Progress</p>
                                    </div>
                                </div>

                                <div class="bg-white rounded-lg border border-gray-200 p-4">
                                    <div class="text-center">
                                        <p class="text-2xl font-bold text-yellow-600">
                                            ${fn:length(tasks.filter(t -> t.status == 'TODO'))}
                                        </p>
                                        <p class="text-sm text-gray-600 mt-1">Pending</p>
                                    </div>
                                </div>
                            </div>

                            <!-- Recent Tasks -->
                            <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                                <div class="flex items-center justify-between mb-6">
                                    <h3 class="text-lg font-semibold text-gray-900">Recent Tasks</h3>
                                    <a href="${pageContext.request.contextPath}/tasks/?projectId=${project.id}"
                                        class="text-blue-600 hover:text-blue-800 text-sm font-medium">
                                        View All <i class="fas fa-arrow-right ml-1"></i>
                                    </a>
                                </div>

                                <div class="space-y-4">
                                    <c:forEach var="task" items="${tasks}" end="5">
                                        <div
                                            class="flex items-center justify-between p-4 border border-gray-200 rounded-lg hover:bg-gray-50">
                                            <div class="flex items-center">
                                                <div
                                                    class="w-10 h-10 rounded-lg bg-gray-100 flex items-center justify-center mr-4">
                                                    <i class="fas fa-tasks text-gray-500"></i>
                                                </div>
                                                <div>
                                                    <h4 class="font-medium text-gray-900">
                                                        <a href="${pageContext.request.contextPath}/tasks/view/${task.id}"
                                                            class="hover:text-blue-600">
                                                            <c:out value="${task.title}" />
                                                        </a>
                                                    </h4>
                                                    <div class="flex items-center mt-1 space-x-3 text-sm text-gray-500">
                                                        <span class="flex items-center">
                                                            <i class="fas fa-flag mr-1"></i>
                                                            <span class="px-2 py-0.5 rounded text-xs
                                                        ${task.priority == 'HIGH' ? 'bg-red-100 text-red-800' :
                                                          task.priority == 'MEDIUM' ? 'bg-yellow-100 text-yellow-800' :
                                                          'bg-green-100 text-green-800'}">
                                                                <c:out value="${task.priority}" />
                                                            </span>
                                                        </span>
                                                        <span class="flex items-center">
                                                            <i class="fas fa-user mr-1"></i>
                                                            <c:out
                                                                value="${task.assignee != null ? task.assignee.name : 'Unassigned'}" />
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="flex items-center space-x-4">
                                                <span class="px-3 py-1 rounded-full text-xs font-medium
                                            ${task.status == 'DONE' ? 'bg-green-100 text-green-800' :
                                              task.status == 'IN_PROGRESS' ? 'bg-blue-100 text-blue-800' :
                                              'bg-gray-100 text-gray-800'}">
                                                    <c:out value="${task.status}" />
                                                </span>
                                                <span class="text-sm text-gray-500">
                                                    <fmt:formatDate value="${task.dueDate}" pattern="MMM dd" />
                                                </span>
                                            </div>
                                        </div>
                                    </c:forEach>

                                    <c:if test="${empty tasks}">
                                        <div class="text-center py-8">
                                            <i class="fas fa-tasks text-3xl text-gray-300 mb-4"></i>
                                            <p class="text-gray-500">No tasks yet</p>
                                            <p class="text-sm text-gray-400 mt-1">Create your first task to get started
                                            </p>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>

                        <!-- Sidebar -->
                        <div class="space-y-6">
                            <!-- Team Members -->
                            <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                                <div class="flex items-center justify-between mb-6">
                                    <h3 class="text-lg font-semibold text-gray-900">Team Members</h3>
                                    <a href="${pageContext.request.contextPath}/projects/members/${project.id}"
                                        class="text-blue-600 hover:text-blue-800 text-sm font-medium">
                                        Manage
                                    </a>
                                </div>

                                <div class="space-y-4">
                                    <c:forEach var="member" items="${members}">
                                        <div class="flex items-center justify-between">
                                            <div class="flex items-center">
                                                <div
                                                    class="w-10 h-10 rounded-full bg-blue-100 flex items-center justify-center mr-3">
                                                    <span class="text-blue-600 font-semibold">
                                                        <c:out value="${member.user.name.charAt(0)}" />
                                                    </span>
                                                </div>
                                                <div>
                                                    <h4 class="font-medium text-gray-900">
                                                        <c:out value="${member.user.name}" />
                                                    </h4>
                                                    <p class="text-sm text-gray-500">
                                                        <c:out value="${member.role}" />
                                                    </p>
                                                </div>
                                            </div>
                                            <c:if test="${member.user.id == project.owner.id}">
                                                <span
                                                    class="px-2 py-1 rounded text-xs font-medium bg-yellow-100 text-yellow-800">
                                                    Owner
                                                </span>
                                            </c:if>
                                        </div>
                                    </c:forEach>

                                    <c:if test="${empty members}">
                                        <p class="text-gray-500 text-center py-4">No team members yet</p>
                                    </c:if>
                                </div>
                            </div>

                            <!-- Project Timeline -->
                            <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                                <h3 class="text-lg font-semibold text-gray-900 mb-6">Project Timeline</h3>

                                <div class="space-y-6">
                                    <div class="relative pl-8">
                                        <div class="absolute left-0 top-0 w-3 h-3 bg-blue-500 rounded-full"></div>
                                        <div>
                                            <p class="font-medium text-gray-900">Project Created</p>
                                            <p class="text-sm text-gray-500">
                                                <fmt:formatDate value="${project.createdDate}" pattern="MMM dd, yyyy" />
                                            </p>
                                        </div>
                                    </div>

                                    <div class="relative pl-8">
                                        <div class="absolute left-0 top-0 w-3 h-3 bg-green-500 rounded-full"></div>
                                        <div>
                                            <p class="font-medium text-gray-900">First Task Completed</p>
                                            <p class="text-sm text-gray-500">--</p>
                                        </div>
                                    </div>

                                    <div class="relative pl-8">
                                        <div class="absolute left-0 top-0 w-3 h-3 bg-yellow-500 rounded-full"></div>
                                        <div>
                                            <p class="font-medium text-gray-900">Project Deadline</p>
                                            <p class="text-sm text-gray-500">
                                                <fmt:formatDate value="${project.dueDate}" pattern="MMM dd, yyyy" />
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Quick Actions -->
                            <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                                <h3 class="text-lg font-semibold text-gray-900 mb-4">Quick Actions</h3>

                                <div class="space-y-3">
                                    <a href="${pageContext.request.contextPath}/tasks/create?projectId=${project.id}"
                                        class="flex items-center justify-between p-3 border border-gray-200 rounded-lg hover:bg-gray-50">
                                        <div class="flex items-center">
                                            <i class="fas fa-plus text-blue-500 mr-3"></i>
                                            <span>Add New Task</span>
                                        </div>
                                        <i class="fas fa-chevron-right text-gray-400"></i>
                                    </a>

                                    <a href="${pageContext.request.contextPath}/projects/members/${project.id}"
                                        class="flex items-center justify-between p-3 border border-gray-200 rounded-lg hover:bg-gray-50">
                                        <div class="flex items-center">
                                            <i class="fas fa-user-plus text-green-500 mr-3"></i>
                                            <span>Invite Team Members</span>
                                        </div>
                                        <i class="fas fa-chevron-right text-gray-400"></i>
                                    </a>

                                    <a href="${pageContext.request.contextPath}/tasks/kanban?projectId=${project.id}"
                                        class="flex items-center justify-between p-3 border border-gray-200 rounded-lg hover:bg-gray-50">
                                        <div class="flex items-center">
                                            <i class="fas fa-columns text-purple-500 mr-3"></i>
                                            <span>View Kanban Board</span>
                                        </div>
                                        <i class="fas fa-chevron-right text-gray-400"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>