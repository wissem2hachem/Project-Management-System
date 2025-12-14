<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="pageTitle" value="Kanban Board" />
<c:set var="pageSubtitle" value="Visual task management" />
<c:set var="contentPage" value="/tasks/kanban.jsp" />
<jsp:include page="/WEB-INF/templates/base.jsp" />

<c:set var="contentPage" value="" />
<div id="kanban-content">
    <!-- Kanban Controls -->
    <div class="flex items-center justify-between mb-6">
        <div class="flex items-center space-x-4">
            <h2 class="text-xl font-semibold text-gray-900">Kanban Board</h2>
            <select class="border border-gray-300 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                <option>All Projects</option>
                <c:forEach var="project" items="${projects}">
                    <option value="${project.id}"><c:out value="${project.name}" /></option>
                </c:forEach>
            </select>
        </div>
        <div class="flex space-x-3">
            <button class="inline-flex items-center px-3 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50">
                <i class="fas fa-filter mr-2"></i>
                Filter
            </button>
            <button class="inline-flex items-center px-3 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50">
                <i class="fas fa-sort mr-2"></i>
                Sort
            </button>
        </div>
    </div>

    <!-- Kanban Columns -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-6">
        <!-- TODO Column -->
        <div class="kanban-column bg-gray-50 rounded-xl p-4">
            <div class="flex items-center justify-between mb-4">
                <div class="flex items-center">
                    <div class="w-3 h-3 bg-gray-400 rounded-full mr-2"></div>
                    <h3 class="font-semibold text-gray-700">To Do</h3>
                    <span class="ml-2 bg-gray-200 text-gray-700 text-xs font-medium px-2 py-1 rounded-full">
                        ${fn:length(todoTasks)}
                    </span>
                </div>
                <button class="text-gray-400 hover:text-gray-600">
                    <i class="fas fa-plus"></i>
                </button>
            </div>

            <div class="space-y-4" id="todo-column">
                <c:forEach var="task" items="${todoTasks}">
                    <div class="task-card bg-white rounded-lg shadow border border-gray-200 p-4 cursor-move hover:shadow-md"
                         draggable="true"
                         data-task-id="${task.id}">
                        <div class="flex items-start justify-between mb-2">
                            <h4 class="font-medium text-gray-900">
                                <c:out value="${task.title}" />
                            </h4>
                            <div class="dropdown relative">
                                <button class="text-gray-400 hover:text-gray-600">
                                    <i class="fas fa-ellipsis-v"></i>
                                </button>
                            </div>
                        </div>

                        <p class="text-sm text-gray-600 mb-3 line-clamp-2">
                            <c:out value="${task.description}" />
                        </p>

                        <div class="flex items-center justify-between">
                            <span class="px-2 py-1 rounded text-xs font-medium
                                        ${task.priority == 'HIGH' ? 'bg-red-100 text-red-800' :
                                          task.priority == 'MEDIUM' ? 'bg-yellow-100 text-yellow-800' :
                                          'bg-green-100 text-green-800'}">
                                <c:out value="${task.priority}" />
                            </span>
                            <div class="flex items-center text-sm text-gray-500">
                                <i class="fas fa-clock mr-1"></i>
                                <span>
                                    <fmt:formatDate value="${task.dueDate}" pattern="MMM dd" />
                                </span>
                            </div>
                        </div>

                        <div class="mt-3 flex items-center">
                            <div class="w-6 h-6 rounded-full bg-blue-500 flex items-center justify-center text-white text-xs mr-2">
                                <c:if test="${not empty task.assignee}">
                                    <c:out value="${task.assignee.name.charAt(0)}" />
                                </c:if>
                            </div>
                            <span class="text-sm text-gray-600">
                                <c:out value="${task.assignee.name}" />
                            </span>
                        </div>
                    </div>
                </c:forEach>

                <!-- Add Task Card -->
                <div class="border-2 border-dashed border-gray-300 rounded-lg p-4 text-center hover:border-gray-400 cursor-pointer">
                    <i class="fas fa-plus text-gray-400 mb-2"></i>
                    <p class="text-sm text-gray-600">Add new task</p>
                </div>
            </div>
        </div>

        <!-- IN PROGRESS Column -->
        <div class="kanban-column bg-blue-50 rounded-xl p-4">
            <div class="flex items-center justify-between mb-4">
                <div class="flex items-center">
                    <div class="w-3 h-3 bg-blue-500 rounded-full mr-2"></div>
                    <h3 class="font-semibold text-gray-700">In Progress</h3>
                    <span class="ml-2 bg-blue-200 text-blue-800 text-xs font-medium px-2 py-1 rounded-full">
                        ${fn:length(inProgressTasks)}
                    </span>
                </div>
            </div>

            <div class="space-y-4" id="inprogress-column">
                <c:forEach var="task" items="${inProgressTasks}">
                    <div class="task-card bg-white rounded-lg shadow border border-gray-200 p-4 cursor-move hover:shadow-md"
                         draggable="true"
                         data-task-id="${task.id}">
                        <!-- Task content similar to TODO column -->
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- IN REVIEW Column -->
        <div class="kanban-column bg-purple-50 rounded-xl p-4">
            <div class="flex items-center justify-between mb-4">
                <div class="flex items-center">
                    <div class="w-3 h-3 bg-purple-500 rounded-full mr-2"></div>
                    <h3 class="font-semibold text-gray-700">In Review</h3>
                    <span class="ml-2 bg-purple-200 text-purple-800 text-xs font-medium px-2 py-1 rounded-full">
                        ${fn:length(inReviewTasks)}
                    </span>
                </div>
            </div>

            <div class="space-y-4" id="review-column">
                <!-- Task cards -->
            </div>
        </div>

        <!-- DONE Column -->
        <div class="kanban-column bg-green-50 rounded-xl p-4">
            <div class="flex items-center justify-between mb-4">
                <div class="flex items-center">
                    <div class="w-3 h-3 bg-green-500 rounded-full mr-2"></div>
                    <h3 class="font-semibold text-gray-700">Done</h3>
                    <span class="ml-2 bg-green-200 text-green-800 text-xs font-medium px-2 py-1 rounded-full">
                        ${fn:length(doneTasks)}
                    </span>
                </div>
            </div>

            <div class="space-y-4" id="done-column">
                <!-- Task cards -->
            </div>
        </div>
    </div>
</div>

<!-- Drag and Drop JavaScript -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const columns = document.querySelectorAll('.kanban-column > div:last-child');
        let draggedTask = null;

        // Add drag events to task cards
        document.querySelectorAll('.task-card[draggable="true"]').forEach(task => {
            task.addEventListener('dragstart', function(e) {
                draggedTask = this;
                this.style.opacity = '0.5';
            });

            task.addEventListener('dragend', function(e) {
                this.style.opacity = '1';
                draggedTask = null;
            });
        });

        // Add drop events to columns
        columns.forEach(column => {
            column.addEventListener('dragover', function(e) {
                e.preventDefault();
                this.style.backgroundColor = 'rgba(0, 0, 0, 0.05)';
            });

            column.addEventListener('dragleave', function(e) {
                this.style.backgroundColor = '';
            });

            column.addEventListener('drop', function(e) {
                e.preventDefault();
                this.style.backgroundColor = '';

                if (draggedTask && this !== draggedTask.parentNode) {
                    this.insertBefore(draggedTask, this.lastElementChild);

                    // Update task status via API
                    const taskId = draggedTask.dataset.taskId;
                    const columnId = this.id;
                    let newStatus = 'TODO';

                    if (columnId.includes('inprogress')) newStatus = 'IN_PROGRESS';
                    if (columnId.includes('review')) newStatus = 'IN_REVIEW';
                    if (columnId.includes('done')) newStatus = 'DONE';

                    updateTaskStatus(taskId, newStatus);
                }
            });
        });
    });

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
                console.log('Task status updated:', data);
            })
            .catch(error => console.error('Error:', error));
    }
</script>