<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

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

        <!-- Project Creation Form -->
        <div class="max-w-3xl mx-auto">
            <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
                <form action="${pageContext.request.contextPath}/projects/" method="POST" id="createProjectForm">
                    <input type="hidden" name="action" value="create">

                    <!-- Project Name -->
                    <div class="mb-6">
                        <label for="name" class="block text-sm font-medium text-gray-700 mb-2">
                            Project Name <span class="text-red-500">*</span>
                        </label>
                        <input type="text" id="name" name="name"
                            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                            placeholder="Enter project name" required maxlength="100"
                            value="${sessionScope.formData != null ? sessionScope.formData.name[0] : ''}">
                        <p class="mt-1 text-sm text-gray-500">Choose a clear, descriptive name for your project</p>
                    </div>

                    <!-- Description -->
                    <div class="mb-6">
                        <label for="description"
                            class="block text-sm font-medium text-gray-700 mb-2">Description</label>
                        <textarea id="description" name="description"
                            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                            rows="4" placeholder="Describe your project objectives and scope"
                            maxlength="1000">${sessionScope.formData != null ? sessionScope.formData.description[0] : ''}</textarea>
                        <p class="mt-1 text-sm text-gray-500">Provide details about what this project aims to achieve
                        </p>
                    </div>

                    <!-- Due Date -->
                    <div class="mb-6">
                        <label for="dueDate" class="block text-sm font-medium text-gray-700 mb-2">Due Date</label>
                        <input type="date" id="dueDate" name="dueDate"
                            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                            value="${sessionScope.formData != null ? sessionScope.formData.dueDate[0] : ''}">
                        <p class="mt-1 text-sm text-gray-500">Optional: Set a deadline for project completion</p>
                    </div>

                    <!-- Status -->
                    <div class="mb-6">
                        <label for="status" class="block text-sm font-medium text-gray-700 mb-2">Status</label>
                        <select id="status" name="status"
                            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                            <option value="ACTIVE" selected>Active</option>
                            <option value="ON_HOLD">On Hold</option>
                            <option value="COMPLETED">Completed</option>
                        </select>
                        <p class="mt-1 text-sm text-gray-500">Current project status</p>
                    </div>

                    <!-- Info Box -->
                    <div class="bg-blue-50 border border-blue-200 rounded-lg p-4 mb-6">
                        <div class="flex items-start">
                            <i class="fas fa-info-circle text-blue-500 mr-3 mt-0.5"></i>
                            <div>
                                <p class="text-sm text-blue-800">
                                    <strong>Note:</strong> You will be set as the project owner. You can add team
                                    members after creating the project.
                                </p>
                            </div>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="flex justify-end gap-3">
                        <a href="${pageContext.request.contextPath}/projects/"
                            class="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50">
                            <i class="fas fa-times mr-2"></i> Cancel
                        </a>
                        <button type="submit" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
                            <i class="fas fa-plus mr-2"></i> Create Project
                        </button>
                    </div>
                </form>
            </div>

            <!-- Quick Tips Card -->
            <div class="bg-blue-50 border border-blue-200 rounded-lg p-6 mt-6">
                <h5 class="font-semibold text-blue-900 mb-3">
                    <i class="fas fa-lightbulb mr-2"></i> Tips for Creating Projects
                </h5>
                <ul class="space-y-2 text-sm text-blue-800">
                    <li class="flex items-start">
                        <i class="fas fa-check text-blue-600 mr-2 mt-0.5"></i>
                        <span>Use clear, descriptive names that reflect the project goals</span>
                    </li>
                    <li class="flex items-start">
                        <i class="fas fa-check text-blue-600 mr-2 mt-0.5"></i>
                        <span>Write a detailed description to align your team</span>
                    </li>
                    <li class="flex items-start">
                        <i class="fas fa-check text-blue-600 mr-2 mt-0.5"></i>
                        <span>Set realistic due dates with buffer time</span>
                    </li>
                    <li class="flex items-start">
                        <i class="fas fa-check text-blue-600 mr-2 mt-0.5"></i>
                        <span>Start with a simple scope and expand as needed</span>
                    </li>
                </ul>
            </div>
        </div>

        <!-- Clear form data from session -->
        <c:remove var="formData" scope="session" />

        <script>
            // Set minimum date to today
            const dueDateInput = document.getElementById('dueDate');
            const today = new Date().toISOString().split('T')[0];
            dueDateInput.setAttribute('min', today);

            // Auto-focus first field
            document.getElementById('name').focus();

            // Character counter for description
            const descriptionField = document.getElementById('description');
            descriptionField.addEventListener('input', function () {
                const remaining = 1000 - this.value.length;
                const formText = this.parentElement.querySelector('.text-gray-500');
                formText.textContent = `${remaining} characters remaining`;

                if (remaining < 100) {
                    formText.classList.add('text-amber-600');
                    formText.classList.remove('text-gray-500');
                } else {
                    formText.classList.add('text-gray-500');
                    formText.classList.remove('text-amber-600');
                }
            });
        </script>