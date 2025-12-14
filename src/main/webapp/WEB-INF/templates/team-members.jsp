<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

            <!-- Team Members Management Section -->
            <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
                <div class="flex items-center justify-between mb-4">
                    <h4 class="text-lg font-semibold text-gray-900">
                        <i class="fas fa-users mr-2"></i>
                        Team Members (${fn:length(members)})
                    </h4>
                    <button onclick="showAddMemberModal()"
                        class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 text-sm">
                        <i class="fas fa-user-plus mr-2"></i> Add Member
                    </button>
                </div>

                <!-- Members List -->
                <c:choose>
                    <c:when test="${empty members}">
                        <div class="text-center py-8">
                            <i class="fas fa-users text-gray-300 text-4xl mb-3"></i>
                            <p class="text-gray-500">No team members yet</p>
                            <button onclick="showAddMemberModal()"
                                class="mt-3 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 text-sm">
                                Add First Member
                            </button>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="space-y-3">
                            <c:forEach var="member" items="${members}">
                                <div
                                    class="flex items-center justify-between p-3 border border-gray-200 rounded-lg hover:bg-gray-50">
                                    <div class="flex items-center gap-3">
                                        <!-- Avatar -->
                                        <div
                                            class="w-10 h-10 rounded-full bg-blue-500 text-white flex items-center justify-center text-sm font-medium">
                                            ${fn:substring(member.user.name, 0, 1)}
                                        </div>

                                        <!-- User Info -->
                                        <div>
                                            <div class="font-medium text-gray-900">${member.user.name}</div>
                                            <div class="text-sm text-gray-600">${member.user.email}</div>
                                        </div>
                                    </div>

                                    <!-- Role Badge -->
                                    <div class="flex items-center gap-2">
                                        <c:choose>
                                            <c:when test="${member.role == 'MANAGER'}">
                                                <span
                                                    class="px-3 py-1 text-xs font-medium rounded-full bg-purple-100 text-purple-800">
                                                    <i class="fas fa-crown mr-1"></i> Manager
                                                </span>
                                            </c:when>
                                            <c:when test="${member.role == 'DEVELOPER'}">
                                                <span
                                                    class="px-3 py-1 text-xs font-medium rounded-full bg-blue-100 text-blue-800">
                                                    <i class="fas fa-code mr-1"></i> Developer
                                                </span>
                                            </c:when>
                                            <c:when test="${member.role == 'TESTER'}">
                                                <span
                                                    class="px-3 py-1 text-xs font-medium rounded-full bg-green-100 text-green-800">
                                                    <i class="fas fa-flask mr-1"></i> Tester
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span
                                                    class="px-3 py-1 text-xs font-medium rounded-full bg-gray-100 text-gray-800">
                                                    Member
                                                </span>
                                            </c:otherwise>
                                        </c:choose>

                                        <!-- Remove Button (only if not owner) -->
                                        <c:if
                                            test="${member.user.id != project.owner.id && sessionScope.user.id == project.owner.id}">
                                            <form action="${pageContext.request.contextPath}/projects/members"
                                                method="POST" style="display: inline;"
                                                onsubmit="return confirm('Remove ${member.user.name} from this project?')">
                                                <input type="hidden" name="action" value="remove">
                                                <input type="hidden" name="projectId" value="${project.id}">
                                                <input type="hidden" name="memberId" value="${member.id}">
                                                <button type="submit" class="p-2 text-red-600 hover:bg-red-50 rounded">
                                                    <i class="fas fa-times"></i>
                                                </button>
                                            </form>
                                        </c:if>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Add Member Modal -->
            <div id="addMemberModal"
                class="hidden fixed inset-0 bg-gray-900 bg-opacity-50 flex items-center justify-center z-50">
                <div class="bg-white rounded-lg shadow-xl max-w-md w-full mx-4">
                    <div class="p-6 border-b border-gray-200">
                        <div class="flex items-center justify-between">
                            <h3 class="text-lg font-semibold text-gray-900">Add Team Member</h3>
                            <button onclick="hideAddMemberModal()" class="text-gray-400 hover:text-gray-600">
                                <i class="fas fa-times"></i>
                            </button>
                        </div>
                    </div>

                    <form action="${pageContext.request.contextPath}/projects/members" method="POST" class="p-6">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="projectId" value="${project.id}">

                        <!-- User Email Input -->
                        <div class="mb-4">
                            <label for="userEmail" class="block text-sm font-medium text-gray-700 mb-2">
                                User Email <span class="text-red-500">*</span>
                            </label>
                            <input type="email" id="userEmail" name="userEmail"
                                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                                placeholder="user@example.com" required>
                            <p class="mt-1 text-xs text-gray-500">Enter the email of an existing user</p>
                        </div>

                        <!-- Role Selection -->
                        <div class="mb-6">
                            <label for="role" class="block text-sm font-medium text-gray-700 mb-2">
                                Role <span class="text-red-500">*</span>
                            </label>
                            <select id="role" name="role"
                                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                                required>
                                <option value="DEVELOPER">Developer</option>
                                <option value="TESTER">Tester</option>
                                <option value="MANAGER">Manager</option>
                            </select>
                        </div>

                        <!-- Buttons -->
                        <div class="flex justify-end gap-3">
                            <button type="button" onclick="hideAddMemberModal()"
                                class="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50">
                                Cancel
                            </button>
                            <button type="submit" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
                                <i class="fas fa-user-plus mr-2"></i> Add Member
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <script>
                function showAddMemberModal() {
                    document.getElementById('addMemberModal').classList.remove('hidden');
                }

                function hideAddMemberModal() {
                    document.getElementById('addMemberModal').classList.add('hidden');
                }

                // Close modal on Escape key
                document.addEventListener('keydown', function (event) {
                    if (event.key === 'Escape') {
                        hideAddMemberModal();
                    }
                });

                // Close modal when clicking outside
                document.getElementById('addMemberModal')?.addEventListener('click', function (event) {
                    if (event.target === this) {
                        hideAddMemberModal();
                    }
                });
            </script>