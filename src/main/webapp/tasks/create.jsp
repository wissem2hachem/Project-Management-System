<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="pageTitle" value="Create Task" />
<c:set var="pageSubtitle" value="Add a new task to your project" />
<c:set var="contentPage" value="/tasks/create.jsp" />
<jsp:include page="/WEB-INF/templates/base.jsp" />

<c:set var="contentPage" value="" />
<div id="create-task-content">
    <div class="max-w-3xl mx-auto">
        <!-- Header -->
        <div class="mb-8">
            <h2 class="text-2xl font-bold text-gray-900">Create New Task</h2>
            <p class="text-gray-600 mt-1">Fill in the details below to create a new task</p>
        </div>

        <!-- Form -->
        <form action="${pageContext.request.contextPath}/tasks/create" method="post" class="space-y-6">
            <input type="hidden" name="action" value="create">

            <!-- Basic Information Card -->
            <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                <h3 class="text-lg font-semibold text-gray-900 mb-4">Task Information</h3>

                <div class="space-y-4">
                    <!-- Title -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">
                            Task Title <span class="text-red-500">*</span>
                        </label>
                        <input type="text"
                               name="title"
                               required
                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                               placeholder="Enter task title">
                    </div>

                    <!-- Description -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">
                            Description
                        </label>
                        <textarea name="description"
                                  rows="4"
                                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                  placeholder="Describe the task in detail"></textarea>
                    </div>
                </div>
            </div>

            <!-- Project & Assignment Card -->
            <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                <h3 class="text-lg font-semibold text-gray-900 mb-4">Project & Assignment</h3>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <!-- Project Selection -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">
                            Project <span class="text-red-500">*</span>
                        </label>
                        <select name="projectId"
                                required
                                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                            <option value="">Select a project</option>
                            <c:forEach var="project" items="${projects}">
                                <option value="${project.id}">
                                    <c:out value="${project.name}" />
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Assignee Selection -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">
                            Assign To
                        </label>
                        <select name="assigneeId"
                                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                            <option value="">Unassigned</option>
                            <c:forEach var="user" items="${users}">
                                <option value="${user.id}">
                                    <c:out value="${user.name}" /> (<c:out value="${user.email}" />)
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
            </div>

            <!-- Task Details Card -->
            <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                <h3 class="text-lg font-semibold text-gray-900 mb-4">Task Details</h3>

                <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                    <!-- Priority -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">
                            Priority
                        </label>
                        <select name="priority"
                                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                            <option value="LOW">Low</option>
                            <option value="MEDIUM" selected>Medium</option>
                            <option value="HIGH">High</option>
                            <option value="CRITICAL">Critical</option>
                        </select>
                    </div>

                    <!-- Due Date -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">
                            Due Date
                        </label>
                        <input type="datetime-local"
                               name="dueDate"
                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                    </div>

                    <!-- Status -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">
                            Status
                        </label>
                        <select name="status"
                                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                            <option value="TODO">To Do</option>
                            <option value="IN_PROGRESS">In Progress</option>
                            <option value="IN_REVIEW">In Review</option>
                            <option value="DONE">Done</option>
                        </select>
                    </div>
                </div>

                <!-- Labels/Tags -->
                <div class="mt-6">
                    <label class="block text-sm font-medium text-gray-700 mb-2">
                        Tags
                    </label>
                    <div class="flex flex-wrap gap-2 mb-3" id="tags-container">
                        <!-- Tags will be added here -->
                    </div>
                    <div class="flex">
                        <input type="text"
                               id="tag-input"
                               class="flex-1 px-4 py-2 border border-gray-300 rounded-l-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                               placeholder="Add a tag">
                        <button type="button"
                                onclick="addTag()"
                                class="px-4 py-2 bg-gray-100 border border-l-0 border-gray-300 rounded-r-lg hover:bg-gray-200">
                            Add
                        </button>
                    </div>
                    <input type="hidden" name="tags" id="tags-input">
                </div>
            </div>

            <!-- Form Actions -->
            <div class="flex items-center justify-end space-x-3">
                <a href="${pageContext.request.contextPath}/tasks/"
                   class="px-6 py-3 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50">
                    Cancel
                </a>
                <button type="submit"
                        class="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2">
                    Create Task
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    let tags = [];

    function addTag() {
        const input = document.getElementById('tag-input');
        const tag = input.value.trim();

        if (tag && !tags.includes(tag)) {
            tags.push(tag);
            updateTagsDisplay();
            input.value = '';
        }
    }

    function updateTagsDisplay() {
        const container = document.getElementById('tags-container');
        const hiddenInput = document.getElementById('tags-input');

        container.innerHTML = '';
        tags.forEach((tag, index) => {
            const tagElement = document.createElement('span');
            tagElement.className = 'inline-flex items-center px-3 py-1 rounded-full text-sm bg-blue-100 text-blue-800';
            tagElement.innerHTML = `
                ${tag}
                <button type="button" onclick="removeTag(${index})" class="ml-2 text-blue-600 hover:text-blue-800">
                    <i class="fas fa-times"></i>
                </button>
            `;
            container.appendChild(tagElement);
        });

        hiddenInput.value = tags.join(',');
    }

    function removeTag(index) {
        tags.splice(index, 1);
        updateTagsDisplay();
    }

    // Allow pressing Enter to add tag
    document.getElementById('tag-input').addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            e.preventDefault();
            addTag();
        }
    });
</script>