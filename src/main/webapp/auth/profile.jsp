<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

            <c:set var="pageTitle" value="My Profile" />
            <c:set var="pageSubtitle" value="Manage your account settings" />
            <c:set var="contentPage" value="/auth/profile.jsp" />
            <jsp:include page="/WEB-INF/templates/base.jsp" />

            <c:set var="contentPage" value="" /> %>
            <div id="profile-content">
                <div class="max-w-4xl mx-auto">
                    <!-- Header -->
                    <div class="mb-8">
                        <h2 class="text-2xl font-bold text-gray-900">Profile Settings</h2>
                        <p class="text-gray-600 mt-1">Manage your account information and preferences</p>
                    </div>

                    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
                        <!-- Left Column - Profile Info -->
                        <div class="lg:col-span-2 space-y-8">
                            <!-- Personal Information Card -->
                            <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                                <div class="flex items-center justify-between mb-6">
                                    <h3 class="text-lg font-semibold text-gray-900">Personal Information</h3>
                                    <button onclick="editPersonalInfo()"
                                        class="text-blue-600 hover:text-blue-800 text-sm font-medium">
                                        <i class="fas fa-edit mr-1"></i>
                                        Edit
                                    </button>
                                </div>

                                <div class="space-y-6">
                                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                        <div>
                                            <label class="block text-sm font-medium text-gray-500 mb-2">
                                                Full Name
                                            </label>
                                            <p class="text-gray-900">
                                                <c:out value="${user.name}" />
                                            </p>
                                        </div>

                                        <div>
                                            <label class="block text-sm font-medium text-gray-500 mb-2">
                                                Email Address
                                            </label>
                                            <p class="text-gray-900">
                                                <c:out value="${user.email}" />
                                            </p>
                                        </div>
                                    </div>

                                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                        <div>
                                            <label class="block text-sm font-medium text-gray-500 mb-2">
                                                Role
                                            </label>
                                            <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full
                                            ${user.role == 'ADMIN' ? 'bg-purple-100 text-purple-800' :
                                              user.role == 'MANAGER' ? 'bg-blue-100 text-blue-800' :
                                              'bg-green-100 text-green-800'}">
                                                <c:out value="${user.role}" />
                                            </span>
                                        </div>

                                        <div>
                                            <label class="block text-sm font-medium text-gray-500 mb-2">
                                                Member Since
                                            </label>
                                            <p class="text-gray-900">
                                                <fmt:formatDate value="${user.joinDate}" pattern="MMMM dd, yyyy" />
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Password Update Card -->
                            <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                                <h3 class="text-lg font-semibold text-gray-900 mb-6">Change Password</h3>

                                <form id="password-form" class="space-y-6">
                                    <div>
                                        <label class="block text-sm font-medium text-gray-700 mb-2">
                                            Current Password
                                        </label>
                                        <input type="password" id="current-password"
                                            class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                            placeholder="Enter current password">
                                    </div>

                                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                        <div>
                                            <label class="block text-sm font-medium text-gray-700 mb-2">
                                                New Password
                                            </label>
                                            <input type="password" id="new-password"
                                                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                                placeholder="Enter new password">
                                        </div>

                                        <div>
                                            <label class="block text-sm font-medium text-gray-700 mb-2">
                                                Confirm New Password
                                            </label>
                                            <input type="password" id="confirm-new-password"
                                                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                                placeholder="Confirm new password">
                                        </div>
                                    </div>

                                    <div id="password-error"
                                        class="hidden p-4 bg-red-50 border border-red-200 rounded-lg">
                                        <div class="flex items-center">
                                            <i class="fas fa-exclamation-circle text-red-500 mr-3"></i>
                                            <span class="text-red-700" id="error-message"></span>
                                        </div>
                                    </div>

                                    <div id="password-success"
                                        class="hidden p-4 bg-green-50 border border-green-200 rounded-lg">
                                        <div class="flex items-center">
                                            <i class="fas fa-check-circle text-green-500 mr-3"></i>
                                            <span class="text-green-700">Password updated successfully!</span>
                                        </div>
                                    </div>

                                    <div class="flex justify-end">
                                        <button type="submit"
                                            class="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2">
                                            Update Password
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <!-- Right Column - Profile Sidebar -->
                        <div class="space-y-6">
                            <!-- Profile Picture Card -->
                            <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                                <div class="text-center">
                                    <div class="relative inline-block mb-4">
                                        <div
                                            class="w-32 h-32 rounded-full bg-blue-100 flex items-center justify-center mx-auto mb-4">
                                            <c:choose>
                                                <c:when test="${not empty user.avatarUrl}">
                                                    <img src="${user.avatarUrl}" alt="${user.name}"
                                                        class="w-32 h-32 rounded-full object-cover">
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-4xl text-blue-600 font-bold">
                                                        <c:out value="${user.name.charAt(0)}" />
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <button onclick="changeAvatar()"
                                            class="absolute bottom-0 right-0 w-10 h-10 bg-blue-500 text-white rounded-full flex items-center justify-center hover:bg-blue-600">
                                            <i class="fas fa-camera"></i>
                                        </button>
                                    </div>

                                    <h3 class="text-lg font-semibold text-gray-900 mb-1">
                                        <c:out value="${user.name}" />
                                    </h3>
                                    <p class="text-gray-600 mb-4">
                                        <c:out value="${user.email}" />
                                    </p>

                                    <button onclick="uploadAvatar()"
                                        class="w-full px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50">
                                        Change Avatar
                                    </button>
                                </div>
                            </div>

                            <!-- Account Stats Card -->
                            <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                                <h3 class="text-lg font-semibold text-gray-900 mb-4">Account Stats</h3>

                                <div class="space-y-4">
                                    <div class="flex items-center justify-between">
                                        <div class="flex items-center">
                                            <div
                                                class="w-10 h-10 rounded-lg bg-blue-100 flex items-center justify-center mr-3">
                                                <i class="fas fa-project-diagram text-blue-500"></i>
                                            </div>
                                            <div>
                                                <p class="text-sm text-gray-600">Projects</p>
                                                <p class="text-lg font-semibold text-gray-900">${projectCount}</p>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="flex items-center justify-between">
                                        <div class="flex items-center">
                                            <div
                                                class="w-10 h-10 rounded-lg bg-green-100 flex items-center justify-center mr-3">
                                                <i class="fas fa-tasks text-green-500"></i>
                                            </div>
                                            <div>
                                                <p class="text-sm text-gray-600">Tasks</p>
                                                <p class="text-lg font-semibold text-gray-900">${taskCount}</p>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="flex items-center justify-between">
                                        <div class="flex items-center">
                                            <div
                                                class="w-10 h-10 rounded-lg bg-purple-100 flex items-center justify-center mr-3">
                                                <i class="fas fa-check-circle text-purple-500"></i>
                                            </div>
                                            <div>
                                                <p class="text-sm text-gray-600">Completed</p>
                                                <p class="text-lg font-semibold text-gray-900">${completedCount}</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Notification Settings -->
                            <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                                <h3 class="text-lg font-semibold text-gray-900 mb-4">Notification Settings</h3>

                                <div class="space-y-4">
                                    <div class="flex items-center justify-between">
                                        <div>
                                            <p class="text-sm font-medium text-gray-900">Email Notifications</p>
                                            <p class="text-xs text-gray-500">Receive updates via email</p>
                                        </div>
                                        <label class="relative inline-flex items-center cursor-pointer">
                                            <input type="checkbox" class="sr-only peer" checked>
                                            <div
                                                class="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-blue-600">
                                            </div>
                                        </label>
                                    </div>

                                    <div class="flex items-center justify-between">
                                        <div>
                                            <p class="text-sm font-medium text-gray-900">Task Assignments</p>
                                            <p class="text-xs text-gray-500">Notify when assigned new tasks</p>
                                        </div>
                                        <label class="relative inline-flex items-center cursor-pointer">
                                            <input type="checkbox" class="sr-only peer" checked>
                                            <div
                                                class="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-blue-600">
                                            </div>
                                        </label>
                                    </div>

                                    <div class="flex items-center justify-between">
                                        <div>
                                            <p class="text-sm font-medium text-gray-900">Deadline Reminders</p>
                                            <p class="text-xs text-gray-500">Remind before task deadlines</p>
                                        </div>
                                        <label class="relative inline-flex items-center cursor-pointer">
                                            <input type="checkbox" class="sr-only peer" checked>
                                            <div
                                                class="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-blue-600">
                                            </div>
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <script>
                function editPersonalInfo() {
                    // Implement edit functionality
                    alert('Edit personal information feature coming soon!');
                }

                function changeAvatar() {
                    // Implement avatar change
                    alert('Change avatar feature coming soon!');
                }

                function uploadAvatar() {
                    const input = document.createElement('input');
                    input.type = 'file';
                    input.accept = 'image/*';
                    input.onchange = function (e) {
                        const file = e.target.files[0];
                        if (file) {
                            // Upload file to server
                            const formData = new FormData();
                            formData.append('avatar', file);

                            fetch('${pageContext.request.contextPath}/api/users/avatar', {
                                method: 'POST',
                                body: formData
                            })
                                .then(response => {
                                    if (response.ok) {
                                        location.reload();
                                    }
                                })
                                .catch(error => console.error('Error:', error));
                        }
                    };
                    input.click();
                }

                // Handle password form submission
                document.getElementById('password-form').addEventListener('submit', function (e) {
                    e.preventDefault();

                    const currentPassword = document.getElementById('current-password').value;
                    const newPassword = document.getElementById('new-password').value;
                    const confirmPassword = document.getElementById('confirm-new-password').value;

                    const errorDiv = document.getElementById('password-error');
                    const successDiv = document.getElementById('password-success');
                    const errorMessage = document.getElementById('error-message');

                    // Hide previous messages
                    errorDiv.classList.add('hidden');
                    successDiv.classList.add('hidden');

                    // Validate
                    if (!currentPassword || !newPassword || !confirmPassword) {
                        errorMessage.textContent = 'All fields are required';
                        errorDiv.classList.remove('hidden');
                        return;
                    }

                    if (newPassword !== confirmPassword) {
                        errorMessage.textContent = 'New passwords do not match';
                        errorDiv.classList.remove('hidden');
                        return;
                    }

                    if (newPassword.length < 8) {
                        errorMessage.textContent = 'New password must be at least 8 characters';
                        errorDiv.classList.remove('hidden');
                        return;
                    }

                    // Submit password change
                    fetch('${pageContext.request.contextPath}/api/users/change-password', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                        },
                        body: JSON.stringify({
                            currentPassword: currentPassword,
                            newPassword: newPassword
                        })
                    })
                        .then(response => {
                            if (response.ok) {
                                successDiv.classList.remove('hidden');
                                document.getElementById('password-form').reset();
                                setTimeout(() => {
                                    successDiv.classList.add('hidden');
                                }, 3000);
                            } else {
                                errorMessage.textContent = 'Current password is incorrect';
                                errorDiv.classList.remove('hidden');
                            }
                        })
                        .catch(error => {
                            errorMessage.textContent = 'An error occurred. Please try again.';
                            errorDiv.classList.remove('hidden');
                        });
                });
            </script>