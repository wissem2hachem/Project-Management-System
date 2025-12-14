<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>My Tasks - Project Management</title>
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                </head>

                <body>
                    <div class="page-wrapper">
                        <div class="container main-content">
                            <!-- Header Section -->
                            <div class="d-flex justify-between align-center mb-3">
                                <div>
                                    <h1 style="margin-bottom: 0.5rem;">My Tasks</h1>
                                    <p class text-secondary" style="margin: 0;">Manage your daily tasks and priorities
                                    </p>
                                </div>
                                <div class="d-flex gap-2">
                                    <a href="${pageContext.request.contextPath}/tasks/kanban" class="btn btn-outline">
                                        <i class="fas fa-columns"></i> Kanban Board
                                    </a>
                                    <a href="${pageContext.request.contextPath}/tasks/create" class="btn btn-primary">
                                        <i class="fas fa-plus"></i> New Task
                                    </a>
                                </div>
                            </div>

                            <!-- Success/Error Messages -->
                            <c:if test="${not empty sessionScope.success}">
                                <div class="alert alert-success">
                                    <i class="fas fa-check-circle"></i> ${sessionScope.success}
                                    <c:remove var="success" scope="session" />
                                </div>
                            </c:if>
                            <c:if test="${not empty sessionScope.error}">
                                <div class="alert alert-error">
                                    <i class="fas fa-exclamation-circle"></i> ${sessionScope.error}
                                    <c:remove var="error" scope="session" />
                                </div>
                            </c:if>

                            <!-- Filters and Search -->
                            <div class="card mb-3">
                                <div class="d-flex justify-between align-center gap-2">
                                    <div class="d-flex gap-2" style="flex: 1;">
                                        <input type="text" id="searchInput" class="form-control"
                                            placeholder="Search tasks..." style="max-width: 300px;"
                                            oninput="filterTasks()">

                                        <select id="statusFilter" class="form-control" style="max-width: 150px;"
                                            onchange="filterTasks()">
                                            <option value="">All Status</option>
                                            <option value="TODO">To Do</option>
                                            <option value="IN_PROGRESS">In Progress</option>
                                            <option value="DONE">Done</option>
                                        </select>

                                        <select id="priorityFilter" class="form-control" style="max-width: 150px;"
                                            onchange="filterTasks()">
                                            <option value="">All Priorities</option>
                                            <option value="LOW">Low</option>
                                            <option value="MEDIUM">Medium</option>
                                            <option value="HIGH">High</option>
                                        </select>
                                    </div>
                                    <div>
                                        <span class="text-secondary">Total: <strong
                                                id="taskCount">${fn:length(tasks)}</strong> tasks</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Task Stats Cards -->
                            <div class="grid grid-cols-3 mb-3">
                                <c:set var="todoCount" value="0" />
                                <c:set var="inProgressCount" value="0" />
                                <c:set var="doneCount" value="0" />
                                <c:forEach var="task" items="${tasks}">
                                    <c:choose>
                                        <c:when test="${task.status == 'TODO'}">
                                            <c:set var="todoCount" value="${todoCount + 1}" />
                                        </c:when>
                                        <c:when test="${task.status == 'IN_PROGRESS'}">
                                            <c:set var="inProgressCount" value="${inProgressCount + 1}" />
                                        </c:when>
                                        <c:when test="${task.status == 'DONE'}">
                                            <c:set var="doneCount" value="${doneCount + 1}" />
                                        </c:when>
                                    </c:choose>
                                </c:forEach>

                                <div class="card">
                                    <div class="d-flex align-center gap-2">
                                        <div style="width: 3rem; height: 3rem; border-radius: 0.5rem; background-color: rgba(59, 130, 246, 0.1); 
                                    display: flex; align-items: center; justify-content: center;">
                                            <i class="fas fa-circle" style="color: var(--status-todo);"></i>
                                        </div>
                                        <div>
                                            <p class="text-secondary" style="margin: 0; font-size: 0.875rem;">To Do</p>
                                            <h3 style="margin: 0;">${todoCount}</h3>
                                        </div>
                                    </div>
                                </div>

                                <div class="card">
                                    <div class="d-flex align-center gap-2">
                                        <div style="width: 3rem; height: 3rem; border-radius: 0.5rem; background-color: rgba(245, 158, 11, 0.1); 
                                    display: flex; align-items: center; justify-content: center;">
                                            <i class="fas fa-spinner" style="color: var(--status-progress);"></i>
                                        </div>
                                        <div>
                                            <p class="text-secondary" style="margin: 0; font-size: 0.875rem;">In
                                                Progress</p>
                                            <h3 style="margin: 0;">${inProgressCount}</h3>
                                        </div>
                                    </div>
                                </div>

                                <div class="card">
                                    <div class="d-flex align-center gap-2">
                                        <div style="width: 3rem; height: 3rem; border-radius: 0.5rem; background-color: rgba(16, 185, 129, 0.1); 
                                    display: flex; align-items: center; justify-content: center;">
                                            <i class="fas fa-check-circle" style="color: var(--status-done);"></i>
                                        </div>
                                        <div>
                                            <p class="text-secondary" style="margin: 0; font-size: 0.875rem;">Done</p>
                                            <h3 style="margin: 0;">${doneCount}</h3>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Progress Bar -->
                            <c:if test="${fn:length(tasks) > 0}">
                                <div class="card mb-3">
                                    <div class="d-flex justify-between align-center mb-2">
                                        <span class="text-secondary">Overall Progress</span>
                                        <span class="text-primary" style="font-weight: 600;">
                                            <fmt:formatNumber value="${(doneCount / fn:length(tasks)) * 100}"
                                                maxFractionDigits="0" />%
                                        </span>
                                    </div>
                                    <div class="progress progress-lg">
                                        <div class="progress-bar ${doneCount / fn:length(tasks) < 0.3 ? 'progress-bar-danger' : 
                                                     doneCount / fn:length(tasks) < 0.7 ? 'progress-bar-warning' : 'progress-bar-success'}"
                                            style="width: ${(doneCount / fn:length(tasks)) * 100}%"></div>
                                    </div>
                                </div>
                            </c:if>

                            <!-- Task Table -->
                            <div class="card">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>Task</th>
                                            <th>Status</th>
                                            <th>Priority</th>
                                            <th>Project</th>
                                            <th>Due Date</th>
                                            <th style="text-align: right;">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody id="taskTableBody">
                                        <c:choose>
                                            <c:when test="${empty tasks}">
                                                <tr class="empty-state-row">
                                                    <td colspan="6">
                                                        <div class="empty-state">
                                                            <div class="empty-state-icon">
                                                                <i class="fas fa-tasks"></i>
                                                            </div>
                                                            <div class="empty-state-title">No tasks found</div>
                                                            <div class="empty-state-description">Get started by creating
                                                                your first task!</div>
                                                            <a href="${pageContext.request.contextPath}/tasks/create"
                                                                class="btn btn-primary mt-2">
                                                                <i class="fas fa-plus"></i> Create Task
                                                            </a>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="task" items="${tasks}">
                                                    <tr class="task-row" data-status="${task.status}"
                                                        data-priority="${task.priority}"
                                                        data-title="${fn:toLowerCase(task.title)}">
                                                        <td>
                                                            <a href="${pageContext.request.contextPath}/tasks/${task.id}"
                                                                style="font-weight: 500; color: var(--text-primary); text-decoration: none;">
                                                                ${fn:substring(task.title, 0,
                                                                50)}${fn:length(task.title) > 50 ? '...' : ''}
                                                            </a>
                                                            <c:if test="${not empty task.description}">
                                                                <p
                                                                    style="margin: 0.25rem 0 0 0; font-size: 0.8125rem; color: var(--text-secondary);">
                                                                    ${fn:substring(task.description, 0,
                                                                    60)}${fn:length(task.description) > 60 ? '...' : ''}
                                                                </p>
                                                            </c:if>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${task.status == 'TODO'}">
                                                                    <span class="badge badge-todo">To Do</span>
                                                                </c:when>
                                                                <c:when test="${task.status == 'IN_PROGRESS'}">
                                                                    <span class="badge badge-progress">In
                                                                        Progress</span>
                                                                </c:when>
                                                                <c:when test="${task.status == 'DONE'}">
                                                                    <span class="badge badge-done">Done</span>
                                                                </c:when>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${task.priority == 'LOW'}">
                                                                    <span class="badge badge-low">Low</span>
                                                                </c:when>
                                                                <c:when test="${task.priority == 'MEDIUM'}">
                                                                    <span class="badge badge-medium">Medium</span>
                                                                </c:when>
                                                                <c:when test="${task.priority == 'HIGH'}">
                                                                    <span class="badge badge-high">High</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge badge-medium">-</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:if test="${not empty task.project}">
                                                                <span
                                                                    style="font-size: 0.875rem; color: var(--text-secondary);">
                                                                    ${task.project.name}
                                                                </span>
                                                            </c:if>
                                                        </td>
                                                        <td>
                                                            <c:if test="${not empty task.dueDate}">
                                                                <div style="font-size: 0.875rem;">
                                                                    <i class="fas fa-calendar"
                                                                        style="color: var(--text-tertiary); margin-right: 0.25rem;"></i>
                                                                    <fmt:formatDate value="${task.dueDate}"
                                                                        pattern="MMM dd, yyyy" />
                                                                </div>
                                                            </c:if>
                                                        </td>
                                                        <td style="text-align: right;">
                                                            <a href="${pageContext.request.contextPath}/tasks/${task.id}"
                                                                class="btn btn-sm btn-outline" title="View Details">
                                                                <i class="fas fa-eye"></i>
                                                            </a>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <script src="${pageContext.request.contextPath}/js/common.js"></script>
                    <script>
                        function filterTasks() {
                            const searchTerm = document.getElementById('searchInput').value.toLowerCase();
                            const statusFilter = document.getElementById('statusFilter').value;
                            const priorityFilter = document.getElementById('priorityFilter').value;

                            const rows = document.querySelectorAll('.task-row');
                            let visibleCount = 0;

                            rows.forEach(row => {
                                const title = row.getAttribute('data-title');
                                const status = row.getAttribute('data-status');
                                const priority = row.getAttribute('data-priority');

                                const matchesSearch = !searchTerm || title.includes(searchTerm);
                                const matchesStatus = !statusFilter || status === statusFilter;
                                const matchesPriority = !priorityFilter || priority === priorityFilter;

                                if (matchesSearch && matchesStatus && matchesPriority) {
                                    row.style.display = '';
                                    visibleCount++;
                                } else {
                                    row.style.display = 'none';
                                }
                            });

                            document.getElementById('taskCount').textContent = visibleCount;

                            // Show/hide empty state
                            const emptyStateRow = document.querySelector('.empty-state-row');
                            if (emptyStateRow) {
                                emptyStateRow.style.display = visibleCount === 0 ? '' : 'none';
                            }
                        }
                    </script>
                </body>

                </html>