<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="pageTitle" value="${project.name} - Team Members" />
<c:set var="pageSubtitle" value="Manage project team and permissions" />
<c:set var="contentPage" value="/projects/members.jsp" />
<jsp:include page="/WEB-INF/templates/base.jsp" />

<c:set var="contentPage" value="" />
<div id="members-content">
    <div class="max-w-6xl mx-auto">
        <!-- Header -->
        <div class="flex flex-col md:flex-row md:items-center justify-between mb-8">
            <div class="mb-4 md:mb-0">
                <div class="flex items-center">
                    <a href="${pageContext.request.contextPath}/projects/view/${project.id}"
                       class="text-blue-600 hover:text-blue-800 mr-3">
                        <i class="fas fa-arrow-left"></i>
                    </a>
                    <div>
                        <h2 class="text-2xl font-bold text-gray-900">Team Members</h2>
                        <p class="text-gray-600 mt-1">Manage team members for: <span class="font-medium"><c:out value="${project.name}" /></span></p>
                    </div>
                </div>
            </div>
            <button onclick="openInviteModal()"
                    class="inline-flex items-center px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
                <i class="fas fa-user-plus mr-2"></i>
                Invite Members
            </button>
        </div>

        <!-- Members Grid -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
            <c:forEach var="member" items="${members}">
                <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                    <div class="flex items-center justify-between mb-4">
                        <div class="flex items-center">
                            <div class="w-12 h-12 rounded-full bg-blue-100 flex items-center justify-center mr-4">
                                <span class="text-blue-600 font-bold text-lg">
                                    <c:out value="${member.user.name.charAt(0)}" />
                                </span>
                            </div>
                            <div>
                                <h3 class="font-semibold text-gray-900">
                                    <c:out value="${member.user.name}" />
                                </h3>
                                <p class="text-sm text-gray-500">
                                    <c:out value="${member.user.email}" />
                                </p>
                            </div>
                        </div>
                        <c:if test="${member.user.id == project.owner.id}">
                            <span class="px-2 py-1 rounded text-xs font-medium bg-yellow-100 text-yellow-800">
                                Owner
                            </span>
                        </c:if>
                    </div>

                    <div class="space-y-3">
                        <div>
                            <label class="block text-sm font-medium text-gray-500 mb-1">
                                Role
                            </label>
                            <div class="flex items-center justify-between">
                                <span class="px-3 py-1 rounded-full text-xs font-medium bg-gray-100 text-gray-800">
                                    <c:out value="${member.role}" />
                                </span>
                                <c:if test="${member.user.id != project.owner.id and sessionScope.user.id == project.owner.id}">
                                    <div class="dropdown relative">
                                        <button class="text-gray-400 hover:text-gray-600">
                                            <i class="fas fa-ellipsis-v"></i>
                                        </button>
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-500 mb-1">
                                Tasks Assigned
                            </label>
                            <p class="text-gray-900">
                                    ${memberTaskCounts[member.user.id] != null ? memberTaskCounts[member.user.id] : 0} tasks
                            </p>
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-500 mb-1">
                                Joined
                            </label>
                            <p class="text-gray-900">
                                <!-- You might want to add join date to ProjectMember entity -->
                                Recently
                            </p>
                        </div>
                    </div>

                    <c:if test="${member.user.id != project.owner.id and sessionScope.user.id == project.owner.id}">
                        <div class="mt-4 pt-4 border-t border-gray-200">
                            <button onclick="removeMember(${member.id})"
                                    class="w-full px-3 py-2 border border-red-300 text-red-600 rounded-lg hover:bg-red-50">
                                Remove from Project
                            </button>
                        </div>
                    </c:if>
                </div>
            </c:forEach>
        </div>

        <!-- Activity Log -->
        <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
            <h3 class="text-lg font-semibold text-gray-900 mb-6">Recent Team Activity</h3>

            <div class="space-y-6">
                <div class="flex items-start">
                    <div class="flex-shrink-0">
                        <div class="w-8 h-8 rounded-full bg-blue-100 flex items-center justify-center">
                            <i class="fas fa-user-plus text-blue-500"></i>
                        </div>
                    </div>
                    <div class="ml-4">
                        <p class="text-sm text-gray-900">
                            <span class="font-medium">John Doe</span> was added to the project
                        </p>
                        <p class="text-sm text-gray-500 mt-1">2 days ago</p>
                    </div>
                </div>

                <div class="flex items-start">
                    <div class="flex-shrink-0">
                        <div class="w-8 h-8 rounded-full bg-green-100 flex items-center justify-center">
                            <i class="fas fa-tasks text-green-500"></i>
                        </div>
                    </div>
                    <div class="ml-4">
                        <p class="text-sm text-gray-900">
                            <span class="font-medium">Sarah Johnson</span> completed task "Design Review"
                        </p>
                        <p class="text-sm text-gray-500 mt-1">3 days ago</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Invite Modal -->
<div id="invite-modal" class="hidden fixed inset-0 bg-gray-500 bg-opacity-75 flex items-center justify-center p-4 z-50">
    <div class="bg-white rounded-xl shadow-lg p-6 max-w-md w-full">
        <div class="flex items-center justify-between mb-6">
            <h3 class="text-lg font-semibold text-gray-900">Invite Team Members</h3>
            <button onclick="closeInviteModal()"
                    class="text-gray-400 hover:text-gray-600">
                <i class="fas fa-times"></i>
            </button>
        </div>

        <form id="invite-form" class="space-y-4">
            <input type="hidden" name="projectId" value="${project.id}">

            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">
                    Email Address <span class="text-red-500">*</span>
                </label>
                <input type="email"
                       id="invite-email"
                       required
                       class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                       placeholder="Enter email address">
                <p class="mt-2 text-sm text-gray-500">You can enter multiple emails separated by commas</p>
            </div>

            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">
                    Role <span class="text-red-500">*</span>
                </label>
                <select id="invite-role"
                        class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                    <option value="DEVELOPER">Developer</option>
                    <option value="DESIGNER">Designer</option>
                    <option value="TESTER">Tester</option>
                    <option value="MANAGER">Manager</option>
                    <option value="VIEWER">Viewer</option>
                </select>
            </div>

            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">
                    Message (Optional)
                </label>
                <textarea id="invite-message"
                          rows="3"
                          class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                          placeholder="Add a personal message..."></textarea>
            </div>

            <div id="invite-error" class="hidden p-4 bg-red-50 border border-red-200 rounded-lg">
                <div class="flex items-center">
                    <i class="fas fa-exclamation-circle text-red-500 mr-3"></i>
                    <span class="text-red-700" id="invite-error-message"></span>
                </div>
            </div>

            <div id="invite-success" class="hidden p-4 bg-green-50 border border-green-200 rounded-lg">
                <div class="flex items-center">
                    <i class="fas fa-check-circle text-green-500 mr-3"></i>
                    <span class="text-green-700">Invitation sent successfully!</span>
                </div>
            </div>

            <div class="flex items-center justify-end space-x-3 mt-6">
                <button type="button"
                        onclick="closeInviteModal()"
                        class="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50">
                    Cancel
                </button>
                <button type="submit"
                        class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
                    Send Invitation
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    function openInviteModal() {
        document.getElementById('invite-modal').classList.remove('hidden');
    }

    function closeInviteModal() {
        document.getElementById('invite-modal').classList.add('hidden');
        document.getElementById('invite-form').reset();

        // Hide messages
        document.getElementById('invite-error').classList.add('hidden');
        document.getElementById('invite-success').classList.add('hidden');
    }

    function removeMember(memberId) {
        if (confirm('Are you sure you want to remove this member from the project?')) {
            fetch('${pageContext.request.contextPath}/api/projects/${project.id}/members/' + memberId, {
                method: 'DELETE'
            })
                .then(response => {
                    if (response.ok) {
                        location.reload();
                    }
                })
                .catch(error => console.error('Error:', error));
        }
    }

    // Handle invite form submission
    document.getElementById('invite-form').addEventListener('submit', function(e) {
        e.preventDefault();

        const email = document.getElementById('invite-email').value;
        const role = document.getElementById('invite-role').value;
        const message = document.getElementById('invite-message').value;

        const errorDiv = document.getElementById('invite-error');
        const successDiv = document.getElementById('invite-success');
        const errorMessage = document.getElementById('invite-error-message');

        // Hide previous messages
        errorDiv.classList.add('hidden');
        successDiv.classList.add('hidden');

        if (!email) {
            errorMessage.textContent = 'Email address is required';
            errorDiv.classList.remove('hidden');
            return;
        }

        // Submit invitation
        fetch('${pageContext.request.contextPath}/api/projects/${project.id}/invite', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                email: email,
                role: role,
                message: message
            })
        })
            .then(response => {
                if (response.ok) {
                    successDiv.classList.remove('hidden');
                    setTimeout(() => {
                        closeInviteModal();
                        location.reload();
                    }, 2000);
                } else {
                    errorMessage.textContent = 'Failed to send invitation. Please try again.';
                    errorDiv.classList.remove('hidden');
                }
            })
            .catch(error => {
                errorMessage.textContent = 'An error occurred. Please try again.';
                errorDiv.classList.remove('hidden');
            });
    });

    // Close modal when clicking outside
    document.getElementById('invite-modal').addEventListener('click', function(e) {
        if (e.target === this) {
            closeInviteModal();
        }
    });
</script>