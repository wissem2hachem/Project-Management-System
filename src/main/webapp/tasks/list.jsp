<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="pageTitle" value="Tasks" />
<c:set var="pageSubtitle" value="Manage and track all tasks" />
<c:set var="contentPage" value="/tasks/list.jsp" />
<jsp:include page="/WEB-INF/templates/base.jsp" />

<c:set var="contentPage" value="" />
<div id="tasks-content">
    <!-- Header with Actions -->
    <div class="flex flex-col md:flex-row md:items-center justify-between mb-8">
        <div class="mb-4 md:mb-0">
            <h2 class="text-2xl font-bold text-gray-900">Tasks</h2>
            <p class="text-gray-600 mt-1">Track and manage all assigned tasks</p>
        </div>
        <div class="flex flex-wrap gap-3">
            <a href="${pageContext.request.contextPath}/tasks/create"
               class="inline-flex items-center px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-colors">
                <i class="fas fa-plus mr-2"></i>
                New Task
            </a>
            <a href="${pageContext.request.contextPath}/tasks/kanban"
               class="inline-flex items-center px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50">
                <i class="fas fa-columns mr-2"></i>
                Kanban View
            </a>
            <button class="inline-flex items-center px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50">
                <i class="fas fa-filter mr-2"></i>
                Filter
            </button>
        </div>
    </div>

    <!-- Stats Overview -->
    <div class="grid grid-cols-2 md:grid-cols-4 gap-4 mb-8">
        <div class="bg-white rounded-lg border border-gray-200 p-4">
            <div class="flex items-center">
                <div class="p-2 bg-blue-100 rounded-lg mr-3">
                    <i class="fas fa-tasks text-blue-500"></i>
                </div>
                <div>
                    <p class="text-sm text-gray-600">Total Tasks</p>
                    <p class="text-xl font-bold text-gray-900">${totalTasks}</p>
                </div>
            </div>
        </div>

        <div class="bg-white rounded-lg border border-gray-200 p-4">
            <div class="flex items-center">
                <div class="p-2 bg-yellow-100 rounded-lg mr-3">
                    <i class="fas fa-clock text-yellow-500"></i>
                </div>
                <div>
                    <p class="text-sm text-gray-600">Pending</p>
                    <p class="text-xl font-bold text-gray-900">${pendingTasks}</p>
                </div>
            </div>
        </div>

        <div class="bg-white rounded-lg border border-gray-200 p-4">
            <div class="flex items-center">
                <div class="p-2 bg-green-100 rounded-lg mr-3">
                    <i class="fas fa-check-circle text-green-500"></i>
                </div>
                <div>
                    <p class="text-sm text-gray-600">Completed</p>
                    <p class="text-xl font-bold text-gray-900">${completedTasks}</p>
                </div>
            </div>
        </div>

        <div class="bg-white rounded-lg border border-gray-200 p-4">
            <div class="flex items-center">
                <div class="p-2 bg-red-100 rounded-lg mr-3">
                    <i class="fas fa-exclamation-triangle text-red-500"></i>
                </div>
                <div>
                    <p class="text-sm text-gray-600">Overdue</p>
                    <p class="text-xl font-bold text-gray-900">${overdueTasks}</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Tasks Table -->
    <div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
        <div class="overflow-x-auto">
            <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-gray-50">
                <tr>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Task
                    </th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Project
                    </th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Status
                    </th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Priority
                    </th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Due Date
                    </th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Actions
                    </th>
                </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200">
                <c:forEach var="task" items="${tasks}">
                    <tr class="hover:bg-gray-50">
                        <td class="px-6 py-4 whitespace-nowrap">
                            <div class="flex items-center">
                                <div class="flex-shrink-0 h-10 w-10">
                                    <div class="h-10 w-10 rounded-full bg-blue-100 flex items-center justify-center">
                                        <i class="fas fa-tasks text-blue-500"></i>
                                    </div>
                                </div>
                                <div class="ml-4">
                                    <div class="text-sm font-medium text-gray-900">
                                        <a href="${pageContext.request.contextPath}/tasks/view/${task.id}"
                                           class="hover:text-blue-600">
                                            <c:out value="${task.title}" />
                                        </a>
                                    </div>
                                    <div class="text-sm text-gray-500 line-clamp-1">
                                        <c:out value="${task.description}" />
                                    </div>
                                </div>
                            </div>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <div class="text-sm text-gray-900">
                                <c:out value="${task.project.name}" />
                            </div>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap">
                                <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full
                                            ${task.status == 'DONE' ? 'bg-green-100 text-green-800' :
                                              task.status == 'IN_PROGRESS' ? 'bg-blue-100 text-blue-800' :
                                              task.status == 'IN_REVIEW' ? 'bg-purple-100 text-purple-800' :
                                              'bg-gray-100 text-gray-800'}">
                                    <c:out value="${task.status}" />
                                </span>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap">
                                <span class="px-2 py-1 text-xs font-medium rounded-full
                                            ${task.priority == 'HIGH' ? 'bg-red-100 text-red-800' :
                                              task.priority == 'MEDIUM' ? 'bg-yellow-100 text-yellow-800' :
                                              'bg-green-100 text-green-800'}">
                                    <c:out value="${task.priority}" />
                                </span>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                            <div class="flex items-center">
                                <i class="fas fa-calendar-alt mr-2"></i>
                                <fmt:formatDate value="${task.dueDate}" pattern="MMM dd, yyyy" />
                                <c:if test="${task.overdue}">
                                        <span class="ml-2 text-xs text-red-600">
                                            <i class="fas fa-exclamation-circle"></i> Overdue
                                        </span>
                                </c:if>
                            </div>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                            <div class="flex items-center space-x-2">
                                <button onclick="updateTaskStatus(${task.id}, 'IN_PROGRESS')"
                                        class="text-blue-600 hover:text-blue-900"
                                        title="Start Task">
                                    <i class="fas fa-play"></i>
                                </button>
                                <button onclick="updateTaskStatus(${task.id}, 'DONE')"
                                        class="text-green-600 hover:text-green-900"
                                        title="Complete Task">
                                    <i class="fas fa-check"></i>
                                </button>
                                <a href="${pageContext.request.contextPath}/tasks/view/${task.id}"
                                   class="text-gray-600 hover:text-gray-900"
                                   title="View Details">
                                    <i class="fas fa-eye"></i>
                                </a>
                                <button class="text-gray-600 hover:text-gray-900"
                                        title="More Options">
                                    <i class="fas fa-ellipsis-v"></i>
                                </button>
                            </div>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty tasks}">
                    <tr>
                        <td colspan="6" class="px-6 py-12 text-center">
                            <div class="text-gray-500">
                                <i class="fas fa-tasks text-4xl mb-4"></i>
                                <p class="text-lg font-medium">No tasks found</p>
                                <p class="mt-1">Get started by creating your first task</p>
                            </div>
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <c:if test="${not empty tasks and fn:length(tasks) > 0}">
            <div class="bg-white px-4 py-3 border-t border-gray-200 sm:px-6">
                <div class="flex items-center justify-between">
                    <div class="flex-1 flex justify-between sm:hidden">
                        <a href="#" class="relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50">
                            Previous
                        </a>
                        <a href="#" class="ml-3 relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50">
                            Next
                        </a>
                    </div>
                    <div class="hidden sm:flex-1 sm:flex sm:items-center sm:justify-between">
                        <div>
                            <p class="text-sm text-gray-700">
                                Showing <span class="font-medium">1</span> to <span class="font-medium">10</span> of <span class="font-medium">${totalTasks}</span> results
                            </p>
                        </div>
                        <div>
                            <nav class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px" aria-label="Pagination">
                                <a href="#" class="relative inline-flex items-center px-2 py-2 rounded-l-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50">
                                    <span class="sr-only">Previous</span>
                                    <i class="fas fa-chevron-left"></i>
                                </a>
                                <a href="#" class="relative inline-flex items-center px-4 py-2 border border-gray-300 bg-white text-sm font-medium text-gray-700 hover:bg-gray-50">
                                    1
                                </a>
                                <a href="#" class="relative inline-flex items-center px-2 py-2 rounded-r-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50">
                                    <span class="sr-only">Next</span>
                                    <i class="fas fa-chevron-right"></i>
                                </a>
                            </nav>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
    </div>
</div>

<script>
    function updateTaskStatus(taskId, status) {
        fetch('${pageContext.request.contextPath}/api/tasks/' + taskId, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ status: status })
        })
            .then(response => {
                if (response.ok) {
                    location.reload();
                }
            })
            .catch(error => console.error('Error:', error));
    }
</script>