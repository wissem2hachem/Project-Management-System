<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Kanban Board - Project Management</title>
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                </head>

                <body>
                    <div class="page-wrapper">
                        <div class="container-fluid main-content">
                            <!-- Header Section -->
                            <div class="d-flex justify-between align-center mb-3">
                                <div>
                                    <h1 style="margin-bottom: 0.5rem;">Kanban Board</h1>
                                    <p class="text-secondary" style="margin: 0;">Visualize and manage tasks workflow</p>
                                </div>
                                <div class="d-flex gap-2">
                                    <a href="${pageContext.request.contextPath}/tasks/" class="btn btn-outline">
                                        <i class="fas fa-list"></i> List View
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

                            <!-- Kanban Board -->
                            <div class="kanban-board" data-project-id="${sessionScope.user.id}">
                                <!-- To Do Column -->
                                <div class="kanban-column">
                                    <div class="kanban-header">
                                        <div class="d-flex align-center gap-2">
                                            <i class="fas fa-circle"
                                                style="color: var(--status-todo); font-size: 0.75rem;"></i>
                                            <span class="kanban-title">To Do</span>
                                        </div>
                                        <span class="kanban-count">${fn:length(todoTasks)}</span>
                                    </div>
                                    <div class="kanban-tasks" data-status="TODO">
                                        <c:choose>
                                            <c:when test="${empty todoTasks}">
                                                <div class="empty-state" style="padding: 2rem 1rem;">
                                                    <div class="empty-state-icon" style="font-size: 2rem;">
                                                        <i class="fas fa-inbox"></i>
                                                    </div>
                                                    <p style="margin: 0; font-size: 0.875rem;">No tasks</p>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="task" items="${todoTasks}">
                                                    <div class="kanban-task" data-task-id="${task.id}" draggable="true">
                                                        <div class="kanban-task-title">${fn:substring(task.title, 0,
                                                            50)}${fn:length(task.title) > 50 ? '...' : ''}</div>
                                                        <c:if test="${not empty task.description}">
                                                            <p
                                                                style="font-size: 0.8125rem; color: var(--text-secondary); margin: 0.5rem 0;">
                                                                ${fn:substring(task.description, 0,
                                                                80)}${fn:length(task.description) > 80 ? '...' : ''}
                                                            </p>
                                                        </c:if>
                                                        <div class="kanban-task-meta">
                                                            <div class="d-flex gap-1">
                                                                <span class="badge badge-todo">To Do</span>
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
                                                                </c:choose>
                                                            </div>
                                                            <div class="d-flex align-center gap-2">
                                                                <c:if test="${not empty task.dueDate}">
                                                                    <span style="font-size: 0.75rem;" title="Due date">
                                                                        <i class="fas fa-calendar"></i>
                                                                        <fmt:formatDate value="${task.dueDate}"
                                                                            pattern="MMM dd" />
                                                                    </span>
                                                                </c:if>
                                                                <c:if test="${not empty task.assignee}">
                                                                    <div class="avatar avatar-sm"
                                                                        title="${task.assignee.name}">
                                                                        ${fn:substring(task.assignee.name, 0,
                                                                        1)}${fn:substring(fn:split(task.assignee.name, '
                                                                        ')[1], 0, 1)}
                                                                    </div>
                                                                </c:if>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <!-- In Progress Column -->
                                <div class="kanban-column">
                                    <div class="kanban-header">
                                        <div class="d-flex align-center gap-2">
                                            <i class="fas fa-spinner"
                                                style="color: var(--status-progress); font-size: 0.75rem;"></i>
                                            <span class="kanban-title">In Progress</span>
                                        </div>
                                        <span class="kanban-count">${fn:length(inProgressTasks)}</span>
                                    </div>
                                    <div class="kanban-tasks" data-status="IN_PROGRESS">
                                        <c:choose>
                                            <c:when test="${empty inProgressTasks}">
                                                <div class="empty-state" style="padding: 2rem 1rem;">
                                                    <div class="empty-state-icon" style="font-size: 2rem;">
                                                        <i class="fas fa-inbox"></i>
                                                    </div>
                                                    <p style="margin: 0; font-size: 0.875rem;">No tasks</p>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="task" items="${inProgressTasks}">
                                                    <div class="kanban-task" data-task-id="${task.id}" draggable="true">
                                                        <div class="kanban-task-title">${fn:substring(task.title, 0,
                                                            50)}${fn:length(task.title) > 50 ? '...' : ''}</div>
                                                        <c:if test="${not empty task.description}">
                                                            <p
                                                                style="font-size: 0.8125rem; color: var(--text-secondary); margin: 0.5rem 0;">
                                                                ${fn:substring(task.description, 0,
                                                                80)}${fn:length(task.description) > 80 ? '...' : ''}
                                                            </p>
                                                        </c:if>
                                                        <div class="kanban-task-meta">
                                                            <div class="d-flex gap-1">
                                                                <span class="badge badge-progress">In Progress</span>
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
                                                                </c:choose>
                                                            </div>
                                                            <div class="d-flex align-center gap-2">
                                                                <c:if test="${not empty task.dueDate}">
                                                                    <span style="font-size: 0.75rem;" title="Due date">
                                                                        <i class="fas fa-calendar"></i>
                                                                        <fmt:formatDate value="${task.dueDate}"
                                                                            pattern="MMM dd" />
                                                                    </span>
                                                                </c:if>
                                                                <c:if test="${not empty task.assignee}">
                                                                    <div class="avatar avatar-sm"
                                                                        title="${task.assignee.name}">
                                                                        ${fn:substring(task.assignee.name, 0,
                                                                        1)}${fn:substring(fn:split(task.assignee.name, '
                                                                        ')[1], 0, 1)}
                                                                    </div>
                                                                </c:if>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <!-- Done Column -->
                                <div class="kanban-column">
                                    <div class="kanban-header">
                                        <div class="d-flex align-center gap-2">
                                            <i class="fas fa-check-circle"
                                                style="color: var(--status-done); font-size: 0.75rem;"></i>
                                            <span class="kanban-title">Done</span>
                                        </div>
                                        <span class="kanban-count">${fn:length(doneTasks)}</span>
                                    </div>
                                    <div class="kanban-tasks" data-status="DONE">
                                        <c:choose>
                                            <c:when test="${empty doneTasks}">
                                                <div class="empty-state" style="padding: 2rem 1rem;">
                                                    <div class="empty-state-icon" style="font-size: 2rem;">
                                                        <i class="fas fa-inbox"></i>
                                                    </div>
                                                    <p style="margin: 0; font-size: 0.875rem;">No tasks</p>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="task" items="${doneTasks}">
                                                    <div class="kanban-task" data-task-id="${task.id}" draggable="true">
                                                        <div class="kanban-task-title">${fn:substring(task.title, 0,
                                                            50)}${fn:length(task.title) > 50 ? '...' : ''}</div>
                                                        <c:if test="${not empty task.description}">
                                                            <p
                                                                style="font-size: 0.8125rem; color: var(--text-secondary); margin: 0.5rem 0;">
                                                                ${fn:substring(task.description, 0,
                                                                80)}${fn:length(task.description) > 80 ? '...' : ''}
                                                            </p>
                                                        </c:if>
                                                        <div class="kanban-task-meta">
                                                            <div class="d-flex gap-1">
                                                                <span class="badge badge-done">Done</span>
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
                                                                </c:choose>
                                                            </div>
                                                            <div class="d-flex align-center gap-2">
                                                                <c:if test="${not empty task.completionDate}">
                                                                    <span style="font-size: 0.75rem;" title="Completed">
                                                                        <i class="fas fa-check"></i>
                                                                        <fmt:formatDate value="${task.completionDate}"
                                                                            pattern="MMM dd" />
                                                                    </span>
                                                                </c:if>
                                                                <c:if test="${not empty task.assignee}">
                                                                    <div class="avatar avatar-sm"
                                                                        title="${task.assignee.name}">
                                                                        ${fn:substring(task.assignee.name, 0,
                                                                        1)}${fn:substring(fn:split(task.assignee.name, '
                                                                        ')[1], 0, 1)}
                                                                    </div>
                                                                </c:if>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>

                            <!-- Help Text -->
                            <div class="card mt-3"
                                style="background-color: var(--primary-50); border-color: var(--primary-200);">
                                <div class="d-flex align-center gap-2">
                                    <i class="fas fa-info-circle" style="color: var(--primary-600);"></i>
                                    <p style="margin: 0; font-size: 0.875rem; color: var(--primary-900);">
                                        <strong>Tip:</strong> Drag and drop tasks between columns to update their status
                                        automatically.
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <script src="${pageContext.request.contextPath}/js/common.js"></script>
                    <script src="${pageContext.request.contextPath}/js/kanban.js"></script>
                    <script>
                        // Make task cards clickable to view details (without interfering with drag)
                        document.addEventListener('DOMContentLoaded', function () {
                            const tasks = document.querySelectorAll('.kanban-task');
                            tasks.forEach(task => {
                                let isDragging = false;

                                task.addEventListener('dragstart', function () {
                                    isDragging = true;
                                });

                                task.addEventListener('dragend', function () {
                                    setTimeout(() => {
                                        isDragging = false;
                                    }, 100);
                                });

                                task.addEventListener('click', function (e) {
                                    if (!isDragging) {
                                        const taskId = this.getAttribute('data-task-id');
                                        window.location.href = '${pageContext.request.contextPath}/tasks/' + taskId;
                                    }
                                });
                            });
                        });
                    </script>
                </body>

                </html>