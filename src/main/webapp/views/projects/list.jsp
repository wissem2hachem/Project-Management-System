<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

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

                <!-- Header Section -->
                <div class="flex items-center justify-between mb-6">
                    <div>
                        <h1 class="text-2xl font-bold text-gray-900">Projects</h1>
                        <p class="text-gray-600 mt-1">Manage your projects and teams</p>
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/projects/create"
                            class="inline-flex items-center px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
                            <i class="fas fa-plus mr-2"></i> New Project
                        </a>
                    </div>
                </div>

                <!-- Statistics Cards -->
                <div class="grid grid-cols-3 gap-6 mb-6">
                    <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
                        <div class="flex items-center">
                            <div class="p-3 rounded-lg bg-blue-100 mr-4">
                                <i class="fas fa-folder text-blue-600 text-2xl"></i>
                            </div>
                            <div>
                                <p class="text-sm text-gray-600">Total Projects</p>
                                <h3 class="text-2xl font-bold text-gray-900">${totalProjects != null ? totalProjects :
                                    fn:length(projects)}</h3>
                            </div>
                        </div>
                    </div>

                    <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
                        <div class="flex items-center">
                            <div class="p-3 rounded-lg bg-green-100 mr-4">
                                <i class="fas fa-play-circle text-green-600 text-2xl"></i>
                            </div>
                            <div>
                                <p class="text-sm text-gray-600">Active</p>
                                <h3 class="text-2xl font-bold text-gray-900">${activeProjects != null ? activeProjects :
                                    0}</h3>
                            </div>
                        </div>
                    </div>

                    <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
                        <div class="flex items-center">
                            <div class="p-3 rounded-lg bg-amber-100 mr-4">
                                <i class="fas fa-check-circle text-ambient-600 text-2xl"></i>
                            </div>
                            <div>
                                <p class="text-sm text-gray-600">Completed</p>
                                <h3 class="text-2xl font-bold text-gray-900">${completedProjects != null ?
                                    completedProjects : 0}</h3>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Search and Filter -->
                <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-4 mb-6">
                    <div class="flex gap-4">
                        <input type="text" id="searchInput"
                            class="flex-1 max-w-md px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                            placeholder="Search projects..." oninput="filterProjects()">

                        <select id="statusFilter"
                            class="px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                            onchange="filterProjects()">
                            <option value="">All Status</option>
                            <option value="ACTIVE">Active</option>
                            <option value="COMPLETED">Completed</option>
                            <option value="ON_HOLD">On Hold</option>
                        </select>
                    </div>
                </div>

                <!-- Projects Grid -->
                <c:choose>
                    <c:when test="${empty projects}">
                        <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-12">
                            <div class="text-center">
                                <i class="fas fa-folder-open text-gray-300 text-6xl mb-4"></i>
                                <h3 class="text-xl font-semibold text-gray-900 mb-2">No projects yet</h3>
                                <p class="text-gray-600 mb-6">Create your first project to get started with task
                                    management</p>
                                <a href="${pageContext.request.contextPath}/projects/create"
                                    class="inline-flex items-center px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
                                    <i class="fas fa-plus mr-2"></i> Create First Project
                                </a>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="grid grid-cols-3 gap-6" id="projectsGrid">
                            <c:forEach var="project" items="${projects}">
                                <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6 hover:shadow-md transition-shadow cursor-pointer project-card"
                                    data-name="${fn:toLowerCase(project.name)}" data-status="${project.status}"
                                    onclick="window.location.href='${pageContext.request.contextPath}/projects/view/${project.id}'">

                                    <!-- Project Header -->
                                    <div class="flex items-start justify-between mb-3">
                                        <h4 class="text-lg font-semibold text-gray-900">
                                            ${fn:substring(project.name, 0, 30)}${fn:length(project.name) > 30 ? '...' :
                                            ''}
                                        </h4>
                                        <c:choose>
                                            <c:when test="${project.status == 'ACTIVE'}">
                                                <span
                                                    class="px-2 py-1 text-xs font-medium rounded-full bg-green-100 text-green-800">
                                                    Active
                                                </span>
                                            </c:when>
                                            <c:when test="${project.status == 'COMPLETED'}">
                                                <span
                                                    class="px-2 py-1 text-xs font-medium rounded-full bg-blue-100 text-blue-800">
                                                    Completed
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span
                                                    class="px-2 py-1 text-xs font-medium rounded-full bg-amber-100 text-amber-800">
                                                    On Hold
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <!-- Description -->
                                    <c:if test="${not empty project.description}">
                                        <p class="text-sm text-gray-600 mb-4 line-clamp-2">
                                            ${fn:substring(project.description, 0, 100)}${fn:length(project.description)
                                            > 100 ? '...' : ''}
                                        </p>
                                    </c:if>

                                    <!-- Progress Bar -->
                                    <c:set var="taskCompletion" value="0" />
                                    <div class="mb-4">
                                        <div class="flex items-center justify-between text-sm mb-2">
                                            <span class="text-gray-600">Progress</span>
                                            <span class="font-semibold text-blue-600">${taskCompletion}%</span>
                                        </div>
                                        <div class="w-full bg-gray-200 rounded-full h-2">
                                            <div class="bg-blue-600 h-2 rounded-full progress-bar"
                                                style="width: ${taskCompletion}%"></div>
                                        </div>
                                    </div>

                                    <!-- Meta Information -->
                                    <div class="flex items-center justify-between text-sm text-gray-600">
                                        <div class="flex items-center">
                                            <i class="fas fa-user mr-1"></i>
                                            <span>${not empty project.owner ? project.owner.name : 'Unknown'}</span>
                                        </div>
                                        <div>
                                            <c:if test="${not empty project.dueDate}">
                                                <i class="fas fa-calendar mr-1"></i>
                                                <span>${project.dueDate.toString().substring(0, 10)}</span>
                                            </c:if>
                                            <c:if test="${empty project.dueDate}">
                                                <i class="fas fa-clock mr-1"></i>
                                                <span>${project.createdDate.toString().substring(0, 10)}</span>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <!-- No Results Message (Hidden by default) -->
                        <div id="noResults" class="bg-white rounded-lg shadow-sm border border-gray-200 p-12"
                            style="display: none;">
                            <div class="text-center">
                                <i class="fas fa-search text-gray-300 text-6xl mb-4"></i>
                                <h3 class="text-xl font-semibold text-gray-900 mb-2">No projects found</h3>
                                <p class="text-gray-600">Try adjusting your search or filter criteria</p>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>

                <script>
                    function filterProjects() {
                        const searchTerm = document.getElementById('searchInput').value.toLowerCase();
                        const statusFilter = document.getElementById('statusFilter').value;

                        const projectCards = document.querySelectorAll('.project-card');
                        let visibleCount = 0;

                        projectCards.forEach(card => {
                            const name = card.getAttribute('data-name');
                            const status = card.getAttribute('data-status');

                            const matchesSearch = !searchTerm || name.includes(searchTerm);
                            const matchesStatus = !statusFilter || status === statusFilter;

                            if (matchesSearch && matchesStatus) {
                                card.style.display = '';
                                visibleCount++;
                            } else {
                                card.style.display = 'none';
                            }
                        });

                        // Show/hide no results message
                        const noResults = document.getElementById('noResults');
                        const projectsGrid = document.getElementById('projectsGrid');

                        if (noResults && projectsGrid) {
                            if (visibleCount === 0) {
                                projectsGrid.style.display = 'none';
                                noResults.style.display = 'block';
                            } else {
                                projectsGrid.style.display = '';
                                noResults.style.display = 'none';
                            }
                        }
                    }
                </script>