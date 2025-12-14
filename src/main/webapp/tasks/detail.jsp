<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="pageTitle" value="${task.title}" />
<c:set var="pageSubtitle" value="Task Details" />
<c:set var="contentPage" value="/tasks/detail.jsp" />
<jsp:include page="/WEB-INF/templates/base.jsp" />

<c:set var="contentPage" value="" />
<div id="task-detail-content">
    <div class="max-w-6xl mx-auto">
        <!-- Task Header -->
        <div class="flex flex-col lg:flex-row lg:items-start lg:justify-between mb-8">
            <div class="flex-1">
                <div class="flex items-center mb-4">
                    <h1 class="text-2xl font-bold text-gray-900 mr-4">
                        <c:out value="${task.title}" />
                    </h1>
                    <span class="px-3 py-1 rounded-full text-sm font-medium
                                ${task.status == 'DONE' ? 'bg-green-100 text-green-800' :
                                  task.status == 'IN_PROGRESS' ? 'bg-blue-100 text-blue-800' :
                                  task.status == 'IN_REVIEW' ? 'bg-purple-100 text-purple-800' :
                                  'bg-gray-100 text-gray-800'}">
                        <c:out value="${task.status}" />
                    </span>
                </div>

                <div class="flex flex-wrap items-center gap-4 text-sm text-gray-600">
                    <div class="flex items-center">
                        <i class="fas fa-project-diagram mr-2"></i>
                        <a href="${pageContext.request.contextPath}/projects/view/${task.project.id}"
                           class="text-blue-600 hover:text-blue-800">
                            <c:out value="${task.project.name}" />
                        </a>
                    </div>
                    <div class="flex items-center">
                        <i class="fas fa-user mr-2"></i>
                        <span>Assigned to:
                            <c:choose>
                                <c:when test="${not empty task.assignee}">
                                    <c:out value="${task.assignee.name}" />
                                </c:when>
                                <c:otherwise>
                                    <span class="text-gray-400">Unassigned</span>
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="flex items-center">
                        <i class="fas fa-calendar-alt mr-2"></i>
                        <span>
                            Due: <fmt:formatDate value="${task.dueDate}" pattern="MMM dd, yyyy" />
                        </span>
                    </div>
                    <div class="flex items-center">
                        <i class="fas fa-flag mr-2"></i>
                        <span class="px-2 py-1 rounded text-xs font-medium
                                    ${task.priority == 'HIGH' ? 'bg-red-100 text-red-800' :
                                      task.priority == 'MEDIUM' ? 'bg-yellow-100 text-yellow-800' :
                                      'bg-green-100 text-green-800'}">
                            <c:out value="${task.priority}" /> Priority
                        </span>
                    </div>
                </div>
            </div>

            <div class="mt-4 lg:mt-0 flex space-x-3">
                <div class="dropdown relative">
                    <button class="inline-flex items-center px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50">
                        <i class="fas fa-edit mr-2"></i>
                        Edit
                    </button>
                </div>
                <div class="dropdown relative">
                    <button class="inline-flex items-center px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
                        <i class="fas fa-check mr-2"></i>
                        Mark Complete
                    </button>
                </div>
            </div>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
            <!-- Left Column -->
            <div class="lg:col-span-2 space-y-8">
                <!-- Description -->
                <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                    <h3 class="text-lg font-semibold text-gray-900 mb-4">Description</h3>
                    <div class="prose max-w-none text-gray-700">
                        <c:choose>
                            <c:when test="${not empty task.description}">
                                <p><c:out value="${task.description}" /></p>
                            </c:when>
                            <c:otherwise>
                                <p class="text-gray-400 italic">No description provided.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Comments Section -->
                <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                    <h3 class="text-lg font-semibold text-gray-900 mb-4">Comments</h3>

                    <!-- Add Comment Form -->
                    <div class="mb-6">
                        <form action="${pageContext.request.contextPath}/tasks/comment" method="post" class="space-y-4">
                            <input type="hidden" name="action" value="comment">
                            <input type="hidden" name="taskId" value="${task.id}">

                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">
                                    Add Comment
                                </label>
                                <textarea name="content"
                                          rows="3"
                                          required
                                          class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                          placeholder="Write your comment here..."></textarea>
                            </div>

                            <div class="flex items-center justify-between">
                                <div class="flex items-center space-x-4">
                                    <button type="submit"
                                            class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
                                        Post Comment
                                    </button>
                                    <button type="button"
                                            class="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50">
                                        <i class="fas fa-paperclip mr-2"></i>
                                        Attach File
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>

                    <!-- Comments List -->
                    <div class="space-y-6">
                        <c:forEach var="comment" items="${comments}">
                            <div class="border-b border-gray-200 pb-6 last:border-0">
                                <div class="flex items-start space-x-4">
                                    <div class="flex-shrink-0">
                                        <div class="w-10 h-10 rounded-full bg-blue-100 flex items-center justify-center">
                                            <span class="text-blue-600 font-semibold">
                                                <c:out value="${comment.author.name.charAt(0)}" />
                                            </span>
                                        </div>
                                    </div>
                                    <div class="flex-1">
                                        <div class="flex items-center justify-between mb-2">
                                            <div>
                                                <h4 class="font-medium text-gray-900">
                                                    <c:out value="${comment.author.name}" />
                                                </h4>
                                                <p class="text-sm text-gray-500">
                                                    <fmt:formatDate value="${comment.createdDate}" pattern="MMM dd, yyyy 'at' hh:mm a" />
                                                </p>
                                            </div>
                                            <button class="text-gray-400 hover:text-gray-600">
                                                <i class="fas fa-ellipsis-v"></i>
                                            </button>
                                        </div>
                                        <p class="text-gray-700">
                                            <c:out value="${comment.content}" />
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>

                        <c:if test="${empty comments}">
                            <div class="text-center py-8">
                                <i class="fas fa-comments text-4xl text-gray-300 mb-4"></i>
                                <p class="text-gray-500">No comments yet. Be the first to comment!</p>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- Right Column (Sidebar) -->
            <div class="space-y-6">
                <!-- Task Details Card -->
                <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                    <h3 class="text-lg font-semibold text-gray-900 mb-4">Task Details</h3>

                    <div class="space-y-4">
                        <div>
                            <label class="block text-sm font-medium text-gray-500">Created</label>
                            <p class="text-sm text-gray-900 mt-1">
                                <fmt:formatDate value="${task.createdDate}" pattern="MMM dd, yyyy" />
                            </p>
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-500">Last Updated</label>
                            <p class="text-sm text-gray-900 mt-1">
                                <fmt:formatDate value="${task.completionDate != null ? task.completionDate : task.createdDate}"
                                                pattern="MMM dd, yyyy" />
                            </p>
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-500">Creator</label>
                            <div class="flex items-center mt-1">
                                <div class="w-6 h-6 rounded-full bg-gray-300 flex items-center justify-center text-xs mr-2">
                                    <!-- You might want to add creator to Task entity -->
                                </div>
                                <span class="text-sm text-gray-900">System</span>
                            </div>
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-500">Time Spent</label>
                            <p class="text-sm text-gray-900 mt-1">--</p>
                        </div>
                    </div>
                </div>

                <!-- Status Update Card -->
                <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                    <h3 class="text-lg font-semibold text-gray-900 mb-4">Update Status</h3>

                    <div class="space-y-3">
                        <button onclick="updateTaskStatus(${task.id}, 'TODO')"
                                class="w-full flex items-center justify-between px-4 py-3 border border-gray-300 rounded-lg hover:bg-gray-50 ${task.status == 'TODO' ? 'bg-gray-50' : ''}">
                            <div class="flex items-center">
                                <div class="w-3 h-3 rounded-full bg-gray-400 mr-3"></div>
                                <span>To Do</span>
                            </div>
                            <c:if test="${task.status == 'TODO'}">
                                <i class="fas fa-check text-blue-500"></i>
                            </c:if>
                        </button>

                        <button onclick="updateTaskStatus(${task.id}, 'IN_PROGRESS')"
                                class="w-full flex items-center justify-between px-4 py-3 border border-gray-300 rounded-lg hover:bg-gray-50 ${task.status == 'IN_PROGRESS' ? 'bg-gray-50' : ''}">
                            <div class="flex items-center">
                                <div class="w-3 h-3 rounded-full bg-blue-500 mr-3"></div>
                                <span>In Progress</span>
                            </div>
                            <c:if test="${task.status == 'IN_PROGRESS'}">
                                <i class="fas fa-check text-blue-500"></i>
                            </c:if>
                        </button>

                        <button onclick="updateTaskStatus(${task.id}, 'IN_REVIEW')"
                                class="w-full flex items-center justify-between px-4 py-3 border border-gray-300 rounded-lg hover:bg-gray-50 ${task.status == 'IN_REVIEW' ? 'bg-gray-50' : ''}">
                            <div class="flex items-center">
                                <div class="w-3 h-3 rounded-full bg-purple-500 mr-3"></div>
                                <span>In Review</span>
                            </div>
                            <c:if test="${task.status == 'IN_REVIEW'}">
                                <i class="fas fa-check text-blue-500"></i>
                            </c:if>
                        </button>

                        <button onclick="updateTaskStatus(${task.id}, 'DONE')"
                                class="w-full flex items-center justify-between px-4 py-3 border border-gray-300 rounded-lg hover:bg-gray-50 ${task.status == 'DONE' ? 'bg-gray-50' : ''}">
                            <div class="flex items-center">
                                <div class="w-3 h-3 rounded-full bg-green-500 mr-3"></div>
                                <span>Done</span>
                            </div>
                            <c:if test="${task.status == 'DONE'}">
                                <i class="fas fa-check text-blue-500"></i>
                            </c:if>
                        </button>
                    </div>
                </div>

                <!-- Attachments Card -->
                <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                    <div class="flex items-center justify-between mb-4">
                        <h3 class="text-lg font-semibold text-gray-900">Attachments</h3>
                        <button class="text-blue-600 hover:text-blue-800 text-sm">
                            <i class="fas fa-plus mr-1"></i>
                            Add
                        </button>
                    </div>

                    <div class="space-y-3">
                        <div class="flex items-center justify-between p-3 border border-gray-200 rounded-lg">
                            <div class="flex items-center">
                                <i class="fas fa-file-pdf text-red-500 text-lg mr-3"></i>
                                <div>
                                    <p class="text-sm font-medium text-gray-900">requirements.pdf</p>
                                    <p class="text-xs text-gray-500">2.4 MB</p>
                                </div>
                            </div>
                            <button class="text-gray-400 hover:text-gray-600">
                                <i class="fas fa-download"></i>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
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