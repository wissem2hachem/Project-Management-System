<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

            <!-- Back Button -->
            <div class="mb-4">
                <a href="${pageContext.request.contextPath}/tasks/"
                    class="inline-flex items-center text-gray-600 hover:text-gray-900">
                    <i class="fas fa-arrow-left mr-2"></i> Back to Tasks
                </a>
            </div>

            <!-- Success/Error Messages -->
            <c:if test="${not empty sessionScope.success}">
                <div class="bg-green-50 border border-green-200 rounded-lg p-4 mb-4">
                    <div class="flex items-center">
                        <i class="fas fa-check-circle text-green-500 mr-3"></i>
                        <span class="text-green-700">${sessionScope.success}</span>
                    </div>
                </div>
                <c:remove var="success" scope="session" />
            </c:if>

            <c:if test="${not empty sessionScope.error}">
                <div class="bg-red-50 border border-red-200 rounded-lg p-4 mb-4">
                    <div class="flex items-center">
                        <i class="fas fa-exclamation-circle text-red-500 mr-3"></i>
                        <span class="text-red-700">${sessionScope.error}</span>
                    </div>
                </div>
                <c:remove var="error" scope="session" />
            </c:if>

            <!-- Main Content Grid -->
            <div class="grid grid-cols-3 gap-6">
                <!-- Left Column (Task Details) - 2 columns -->
                <div class="col-span-2 space-y-6">
                    <!-- Task Header Card -->
                    <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
                        <div class="flex items-start justify-between mb-4">
                            <div class="flex-1">
                                <h1 class="text-2xl font-bold text-gray-900 mb-2">${task.title}</h1>
                                <div class="flex items-center gap-4 text-sm text-gray-600">
                                    <span class="flex items-center">
                                        <i class="fas fa-folder mr-2"></i>
                                        ${task.project.name}
                                    </span>
                                    <c:if test="${not empty task.dueDate}">
                                        <span class="flex items-center">
                                            <i class="fas fa-calendar mr-2"></i>
                                            Due: ${task.dueDate.toString().substring(0, 10)}
                                        </span>
                                    </c:if>
                                </div>
                            </div>
                        </div>

                        <!-- Status and Priority Badges -->
                        <div class="flex gap-2 mb-4">
                            <c:choose>
                                <c:when test="${task.status == 'TODO'}">
                                    <span class="px-3 py-1 text-sm font-medium rounded-full bg-gray-100 text-gray-800">
                                        <i class="fas fa-circle mr-1"></i> To Do
                                    </span>
                                </c:when>
                                <c:when test="${task.status == 'IN_PROGRESS'}">
                                    <span
                                        class="px-3 py-1 text-sm font-medium rounded-full bg-amber-100 text-amber-800">
                                        <i class="fas fa-spinner mr-1"></i> In Progress
                                    </span>
                                </c:when>
                                <c:when test="${task.status == 'DONE'}">
                                    <span
                                        class="px-3 py-1 text-sm font-medium rounded-full bg-green-100 text-green-800">
                                        <i class="fas fa-check-circle mr-1"></i> Done
                                    </span>
                                </c:when>
                            </c:choose>

                            <c:choose>
                                <c:when test="${task.priority == 'LOW'}">
                                    <span
                                        class="px-3 py-1 text-sm font-medium rounded-full bg-green-100 text-green-800">
                                        Low Priority
                                    </span>
                                </c:when>
                                <c:when test="${task.priority == 'MEDIUM'}">
                                    <span
                                        class="px-3 py-1 text-sm font-medium rounded-full bg-amber-100 text-amber-800">
                                        Medium Priority
                                    </span>
                                </c:when>
                                <c:when test="${task.priority == 'HIGH'}">
                                    <span class="px-3 py-1 text-sm font-medium rounded-full bg-red-100 text-red-800">
                                        High Priority
                                    </span>
                                </c:when>
                            </c:choose>
                        </div>

                        <!-- Task Description -->
                        <div class="mb-4">
                            <h3 class="text-sm font-semibold text-gray-900 mb-2">Description</h3>
                            <c:choose>
                                <c:when test="${not empty task.description}">
                                    <p class="text-gray-700 whitespace-pre-line">${task.description}</p>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-gray-500 italic">No description provided</p>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Quick Status Update -->
                        <div class="pt-4 border-t border-gray-200">
                            <h4 class="text-sm font-semibold text-gray-900 mb-3">Update Status</h4>
                            <div class="flex gap-2">
                                <form action="${pageContext.request.contextPath}/tasks/" method="POST"
                                    style="display: inline;">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="taskId" value="${task.id}">
                                    <input type="hidden" name="status" value="TODO">
                                    <button type="submit"
                                        class="px-4 py-2 text-sm border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 ${task.status == 'TODO' ? 'bg-gray-100' : ''}">
                                        <i class="fas fa-circle mr-1"></i> To Do
                                    </button>
                                </form>

                                <form action="${pageContext.request.contextPath}/tasks/" method="POST"
                                    style="display: inline;">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="taskId" value="${task.id}">
                                    <input type="hidden" name="status" value="IN_PROGRESS">
                                    <button type="submit"
                                        class="px-4 py-2 text-sm border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 ${task.status == 'IN_PROGRESS' ? 'bg-amber-100' : ''}">
                                        <i class="fas fa-spinner mr-1"></i> In Progress
                                    </button>
                                </form>

                                <form action="${pageContext.request.contextPath}/tasks/" method="POST"
                                    style="display: inline;">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="taskId" value="${task.id}">
                                    <input type="hidden" name="status" value="DONE">
                                    <button type="submit"
                                        class="px-4 py-2 text-sm border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 ${task.status == 'DONE' ? 'bg-green-100' : ''}">
                                        <i class="fas fa-check-circle mr-1"></i> Done
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- Comments Section -->
                    <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
                        <h3 class="text-lg font-semibold text-gray-900 mb-4">
                            <i class="fas fa-comments mr-2"></i>
                            Comments (${fn:length(task.comments)})
                        </h3>

                        <!-- Add Comment Form -->
                        <div class="mb-6 pb-6 border-b border-gray-200">
                            <form action="${pageContext.request.contextPath}/tasks/" method="POST">
                                <input type="hidden" name="action" value="comment">
                                <input type="hidden" name="taskId" value="${task.id}">

                                <div class="flex gap-3">
                                    <div class="flex-shrink-0">
                                        <div
                                            class="w-10 h-10 rounded-full bg-blue-500 text-white flex items-center justify-center font-medium">
                                            ${fn:substring(sessionScope.user.name, 0, 1)}
                                        </div>
                                    </div>
                                    <div class="flex-1">
                                        <textarea name="content" id="commentContent" rows="3"
                                            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                                            placeholder="Add a comment..." required maxlength="1000"></textarea>
                                        <div class="flex items-center justify-between mt-2">
                                            <span class="text-xs text-gray-500" id="charCount">0 / 1000</span>
                                            <button type="submit"
                                                class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
                                                <i class="fas fa-paper-plane mr-2"></i> Post Comment
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>

                        <!-- Comments List -->
                        <div class="space-y-4">
                            <c:choose>
                                <c:when test="${empty task.comments}">
                                    <div class="text-center py-8">
                                        <i class="fas fa-comments text-gray-300 text-4xl mb-3"></i>
                                        <p class="text-gray-500">No comments yet. Be the first to comment!</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="comment" items="${task.comments}">
                                        <div class="flex gap-3">
                                            <div class="flex-shrink-0">
                                                <div
                                                    class="w-10 h-10 rounded-full bg-gray-500 text-white flex items-center justify-center font-medium text-sm">
                                                    ${fn:substring(comment.author.name, 0, 1)}
                                                </div>
                                            </div>
                                            <div class="flex-1">
                                                <div class="bg-gray-50 rounded-lg p-4">
                                                    <div class="flex items-center justify-between mb-2">
                                                        <span
                                                            class="font-medium text-gray-900">${comment.author.name}</span>
                                                        <span class="text-xs text-gray-500">
                                                            ${comment.createdDate.toString().substring(0,
                                                            16).replace('T', ' ')}
                                                        </span>
                                                    </div>
                                                    <p class="text-gray-700 whitespace-pre-line">${comment.content}</p>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <!-- Right Column (Sidebar) - 1 column -->
                <div class="space-y-6">
                    <!-- Task Info Card -->
                    <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
                        <h4 class="font-semibold text-gray-900 mb-4">Task Information</h4>

                        <div class="space-y-3 text-sm">
                            <div>
                                <span class="text-gray-600">Assigned to</span>
                                <div class="mt-1 flex items-center">
                                    <c:if test="${not empty task.assignee}">
                                        <div
                                            class="w-6 h-6 rounded-full bg-blue-500 text-white flex items-center justify-center text-xs font-medium mr-2">
                                            ${fn:substring(task.assignee.name, 0, 1)}
                                        </div>
                                        <span class="font-medium text-gray-900">${task.assignee.name}</span>
                                    </c:if>
                                    <c:if test="${empty task.assignee}">
                                        <span class="text-gray-500">Unassigned</span>
                                    </c:if>
                                </div>
                            </div>

                            <div>
                                <span class="text-gray-600">Created</span>
                                <div class="mt-1 font-medium text-gray-900">
                                    ${task.createdDate.toString().substring(0, 10)}
                                </div>
                            </div>

                            <c:if test="${not empty task.dueDate}">
                                <div>
                                    <span class="text-gray-600">Due Date</span>
                                    <div class="mt-1 font-medium text-gray-900">
                                        ${task.dueDate.toString().substring(0, 10)}
                                    </div>
                                </div>
                            </c:if>

                            <div>
                                <span class="text-gray-600">Project</span>
                                <div class="mt-1">
                                    <a href="${pageContext.request.contextPath}/projects/view/${task.project.id}"
                                        class="font-medium text-blue-600 hover:text-blue-700">
                                        ${task.project.name}
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Actions Card -->
                    <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
                        <h4 class="font-semibold text-gray-900 mb-4">Actions</h4>
                        <div class="space-y-2">
                            <a href="${pageContext.request.contextPath}/tasks/edit/${task.id}"
                                class="flex items-center w-full px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50">
                                <i class="fas fa-edit mr-3"></i> Edit Task
                            </a>
                            <a href="${pageContext.request.contextPath}/tasks/kanban"
                                class="flex items-center w-full px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50">
                                <i class="fas fa-columns mr-3"></i> View Kanban
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <script>
                // Character counter for comment textarea
                const commentTextarea = document.getElementById('commentContent');
                const charCount = document.getElementById('charCount');

                if (commentTextarea && charCount) {
                    commentTextarea.addEventListener('input', function () {
                        const length = this.value.length;
                        charCount.textContent = `${length} / 1000`;

                        if (length > 900) {
                            charCount.classList.add('text-red-600');
                            charCount.classList.remove('text-gray-500');
                        } else {
                            charCount.classList.add('text-gray-500');
                            charCount.classList.remove('text-red-600');
                        }
                    });
                }
            </script>