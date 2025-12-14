<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <div class="max-w-2xl mx-auto">
            <div class="bg-white rounded-lg shadow-sm border border-gray-200">
                <div class="px-6 py-4 border-b border-gray-200">
                    <h2 class="text-xl font-bold text-gray-900">Create New Task</h2>
                </div>

                <form action="${pageContext.request.contextPath}/tasks/" method="post" class="p-6 space-y-4">
                    <input type="hidden" name="action" value="create">

                    <!-- Title -->
                    <div>
                        <label for="title" class="block text-sm font-medium text-gray-700 mb-1">
                            Task Title <span class="text-red-500">*</span>
                        </label>
                        <input type="text" id="title" name="title" required placeholder="Enter task title"
                            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                    </div>

                    <!-- Project -->
                    <div>
                        <label for="projectId" class="block text-sm font-medium text-gray-700 mb-1">
                            Project <span class="text-red-500">*</span>
                        </label>
                        <select id="projectId" name="projectId" required
                            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                            <option value="">Select a project</option>
                            <c:forEach var="project" items="${projects}">
                                <option value="${project.id}">${project.name}</option>
                            </c:forEach>
                        </select>
                        <c:if test="${empty projects}">
                            <p class="text-red-500 text-sm mt-1">You need to create a project first!</p>
                        </c:if>
                    </div>

                    <!-- Description -->
                    <div>
                        <label for="description"
                            class="block text-sm font-medium text-gray-700 mb-1">Description</label>
                        <textarea id="description" name="description" rows="4" placeholder="Describe the task..."
                            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"></textarea>
                    </div>

                    <!-- Assignee - defaults to current user -->
                    <div>
                        <label for="assigneeId" class="block text-sm font-medium text-gray-700 mb-1">
                            Assign To
                        </label>
                        <select id="assigneeId" name="assigneeId"
                            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline focus:ring-2 focus:ring-blue-500">
                            <option value="${sessionScope.user.id}" selected>Me (${sessionScope.user.name})</option>
                            <!-- Note: Team members could be loaded dynamically via AJAX based on selected project -->
                        </select>
                        <p class="text-xs text-gray-500 mt-1">You can reassign the task later from the task detail page
                        </p>
                    </div>

                    <!-- Due Date -->
                    <div>
                        <label for="dueDate" class="block text-sm font-medium text-gray-700 mb-1">Due Date</label>
                        <input type="date" id="dueDate" name="dueDate"
                            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                    </div>

                    <!-- Priority -->
                    <div>
                        <label for="priority" class="block text-sm font-medium text-gray-700 mb-1">Priority</label>
                        <select id="priority" name="priority"
                            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                            <option value="LOW">Low</option>
                            <option value="MEDIUM" selected>Medium</option>
                            <option value="HIGH">High</option>
                        </select>
                    </div>

                    <!-- Status -->
                    <div>
                        <label for="status" class="block text-sm font-medium text-gray-700 mb-1">Status</label>
                        <select id="status" name="status"
                            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                            <option value="TODO" selected>To Do</option>
                            <option value="IN_PROGRESS">In Progress</option>
                            <option value="DONE">Done</option>
                        </select>
                    </div>

                    <!-- Buttons -->
                    <div class="flex justify-end gap-3 pt-4">
                        <a href="${pageContext.request.contextPath}/tasks/"
                            class="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50">
                            Cancel
                        </a>
                        <button type="submit" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700"
                            ${empty projects ? 'disabled' : '' }>
                            <i class="fas fa-plus mr-2"></i> Create Task
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            // Set minimum date to today
            const dueDateInput = document.getElementById('dueDate');
            const today = new Date().toISOString().split('T')[0];
            dueDateInput.setAttribute('min', today);
        </script>