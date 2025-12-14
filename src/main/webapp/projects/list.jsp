<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

                <div id="projects-content">
                    <!-- Header with Actions -->
                    <div class="flex items-center justify-between mb-8">
                        <div>
                            <h2 class="text-2xl font-bold text-gray-900">Projects</h2>
                            <p class="text-gray-600 mt-1">Manage and track all your projects in one place</p>
                        </div>
                        <div class="flex space-x-3">
                            <a href="${pageContext.request.contextPath}/projects/create"
                                class="inline-flex items-center px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2">
                                <i class="fas fa-plus mr-2"></i>
                                New Project
                            </a>
                            <button
                                class="inline-flex items-center px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50">
                                <i class="fas fa-filter mr-2"></i>
                                Filter
                            </button>
                        </div>
                    </div>

                    <!-- Projects Grid -->
                    <c:choose>
                        <c:when test="${empty projects}">
                            <div class="text-center py-12">
                                <div
                                    class="inline-flex items-center justify-center w-16 h-16 bg-gray-100 rounded-full mb-4">
                                    <i class="fas fa-project-diagram text-gray-400 text-2xl"></i>
                                </div>
                                <h3 class="text-lg font-medium text-gray-900 mb-2">No projects yet</h3>
                                <p class="text-gray-600 mb-6">Get started by creating your first project</p>
                                <a href="${pageContext.request.contextPath}/projects/create"
                                    class="inline-flex items-center px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
                                    <i class="fas fa-plus mr-2"></i>
                                    Create Project
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                                <c:forEach var="project" items="${projects}">
                                    <div
                                        class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden hover:shadow-md transition-shadow">
                                        <!-- Project Header -->
                                        <div class="p-6">
                                            <div class="flex items-start justify-between mb-4">
                                                <div>
                                                    <h3 class="text-lg font-semibold text-gray-900 mb-1">
                                                        <a href="${pageContext.request.contextPath}/projects/view/${project.id}"
                                                            class="hover:text-blue-600">
                                                            <c:out value="${project.name}" />
                                                        </a>
                                                    </h3>
                                                    <span class="px-2 py-1 rounded-full text-xs font-medium
                                ${project.status == 'COMPLETED' ? 'bg-green-100 text-green-800' :
                                    project.status == 'IN_PROGRESS' ? 'bg-blue-100 text-blue-800' :
                                    'bg-yellow-100 text-yellow-800'}">
                                                        <c:out value="${project.status}" />
                                                    </span>
                                                </div>
                                                <div class="dropdown relative">
                                                    <button class="p-1 text-gray-400 hover:text-gray-600">
                                                        <i class="fas fa-ellipsis-v"></i>
                                                    </button>
                                                </div>
                                            </div>

                                            <p class="text-gray-600 text-sm mb-4 line-clamp-2">
                                                <c:out value="${project.description}" />
                                            </p>

                                            <!-- Progress Bar -->
                                            <div class="mb-4">
                                                <div class="flex justify-between text-sm text-gray-600 mb-1">
                                                    <span>Progress</span>
                                                    <span>${project.progressPercentage}%</span>
                                                </div>
                                                <div class="w-full bg-gray-200 rounded-full h-2">
                                                    <div class="bg-blue-600 h-2 rounded-full progress-bar"
                                                        style="width: ${project.progressPercentage}%"></div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Project Footer -->
                                        <div class="px-6 py-4 bg-gray-50 border-t border-gray-200">
                                            <div class="flex items-center justify-between">
                                                <div class="flex items-center text-sm text-gray-600">
                                                    <i class="fas fa-calendar-alt mr-2"></i>
                                                    <span>
                                                        <fmt:formatDate value="${project.dueDate}" pattern="MMM dd" />
                                                    </span>
                                                </div>
                                                <div class="flex -space-x-2">
                                                    <!-- Team Members Avatars -->
                                                    <c:forEach var="member" items="${project.members}" end="2">
                                                        <div
                                                            class="w-8 h-8 rounded-full border-2 border-white bg-blue-500 flex items-center justify-center text-white text-xs font-medium">
                                                            <c:out value="${member.user.name.charAt(0)}" />
                                                        </div>
                                                    </c:forEach>
                                                    <c:if test="${fn:length(project.members) > 3}">
                                                        <div
                                                            class="w-8 h-8 rounded-full border-2 border-white bg-gray-300 flex items-center justify-center text-gray-700 text-xs font-medium">
                                                            +${fn:length(project.members) - 3}
                                                        </div>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>