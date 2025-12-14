/**
 * Kanban Board - Drag and Drop Functionality
 */

class KanbanBoard {
    constructor(projectId) {
        this.projectId = projectId;
        this.draggedElement = null;
        this.init();
    }

    init() {
        this.setupDragAndDrop();
        console.log('Kanban board initialized for project:', this.projectId);
    }

    setupDragAndDrop() {
        const tasks = document.querySelectorAll('.kanban-task');
        const columns = document.querySelectorAll('.kanban-tasks');

        // Setup drag events for tasks
        tasks.forEach(task => {
            task.setAttribute('draggable', 'true');

            task.addEventListener('dragstart', (e) => this.handleDragStart(e));
            task.addEventListener('dragend', (e) => this.handleDragEnd(e));
        });

        // Setup drop zones (columns)
        columns.forEach(column => {
            column.addEventListener('dragover', (e) => this.handleDragOver(e));
            column.addEventListener('drop', (e) => this.handleDrop(e));
            column.addEventListener('dragleave', (e) => this.handleDragLeave(e));
            column.addEventListener('dragenter', (e) => this.handleDragEnter(e));
        });
    }

    handleDragStart(e) {
        this.draggedElement = e.target;
        e.target.classList.add('dragging');
        e.dataTransfer.effectAllowed = 'move';
        e.dataTransfer.setData('text/html', e.target.innerHTML);
    }

    handleDragEnd(e) {
        e.target.classList.remove('dragging');

        // Remove all drag over effects
        document.querySelectorAll('.kanban-tasks').forEach(column => {
            column.style.backgroundColor = '';
        });
    }

    handleDragOver(e) {
        if (e.preventDefault) {
            e.preventDefault();
        }
        e.dataTransfer.dropEffect = 'move';
        return false;
    }

    handleDragEnter(e) {
        if (e.target.classList.contains('kanban-tasks')) {
            e.target.style.backgroundColor = 'rgba(59, 130, 246, 0.05)';
        }
    }

    handleDragLeave(e) {
        if (e.target.classList.contains('kanban-tasks')) {
            e.target.style.backgroundColor = '';
        }
    }

    async handleDrop(e) {
        if (e.stopPropagation) {
            e.stopPropagation();
        }
        e.preventDefault();

        const dropZone = e.target.closest('.kanban-tasks');
        if (!dropZone) return;

        // Clear background color
        dropZone.style.backgroundColor = '';

        if (this.draggedElement && this.draggedElement !== e.target) {
            // Get the new status from the column
            const newStatus = dropZone.getAttribute('data-status');
            const taskId = this.draggedElement.getAttribute('data-task-id');

            // Move the element in DOM
            dropZone.appendChild(this.draggedElement);

            // Update the status badge in the card
            this.updateTaskStatusBadge(this.draggedElement, newStatus);

            // Update counts
            this.updateColumnCounts();

            // Update task status on server
            try {
                await this.updateTaskStatus(taskId, newStatus);
                Toast.success('Task status updated successfully');
            } catch (error) {
                console.error('Failed to update task status:', error);
                Toast.error('Failed to update task status');
                // Optionally: revert the move
            }
        }

        return false;
    }

    updateTaskStatusBadge(taskElement, status) {
        const badge = taskElement.querySelector('.badge');
        if (badge) {
            // Remove old classes
            badge.classList.remove('badge-todo', 'badge-progress', 'badge-done');

            // Add new class and update text
            const statusMap = {
                'TODO': { class: 'badge-todo', text: 'To Do' },
                'TO_DO': { class: 'badge-todo', text: 'To Do' },
                'IN_PROGRESS': { class: 'badge-progress', text: 'In Progress' },
                'DONE': { class: 'badge-done', text: 'Done' }
            };

            const statusInfo = statusMap[status] || { class: 'badge-todo', text: status };
            badge.classList.add(statusInfo.class);
            badge.textContent = statusInfo.text;
        }
    }

    updateColumnCounts() {
        document.querySelectorAll('.kanban-column').forEach(column => {
            const status = column.querySelector('.kanban-tasks').getAttribute('data-status');
            const count = column.querySelectorAll('.kanban-task').length;
            const countElement = column.querySelector('.kanban-count');
            if (countElement) {
                countElement.textContent = count;
            }
        });
    }

    async updateTaskStatus(taskId, newStatus) {
        const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf('/', 1));
        const url = `${contextPath}/api/tasks/${taskId}`;

        // Get current task data first
        const response = await fetch(url, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json'
            }
        });

        if (!response.ok) {
            throw new Error('Failed to fetch task data');
        }

        const taskData = await response.json();

        // Update status
        taskData.status = newStatus;

        // Send update request
        const updateResponse = await fetch(url, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                title: taskData.title,
                description: taskData.description,
                status: newStatus,
                priority: taskData.priority,
                projectId: taskData.projectId || this.projectId,
                assigneeId: taskData.assigneeId,
                dueDate: taskData.dueDate
            })
        });

        if (!updateResponse.ok) {
            throw new Error('Failed to update task status');
        }

        return await updateResponse.json();
    }

    // Add a new task to the board dynamically
    addTask(task, status) {
        const column = document.querySelector(`.kanban-tasks[data-status="${status}"]`);
        if (!column) return;

        const taskElement = this.createTaskElement(task);
        column.appendChild(taskElement);

        // Setup drag for the new task
        taskElement.setAttribute('draggable', 'true');
        taskElement.addEventListener('dragstart', (e) => this.handleDragStart(e));
        taskElement.addEventListener('dragend', (e) => this.handleDragEnd(e));

        this.updateColumnCounts();
    }

    createTaskElement(task) {
        const taskDiv = document.createElement('div');
        taskDiv.className = 'kanban-task';
        taskDiv.setAttribute('data-task-id', task.id);

        const statusClass = this.getStatusBadgeClass(task.status);
        const priorityClass = this.getPriorityBadgeClass(task.priority);

        taskDiv.innerHTML = `
            <div class="kanban-task-title">${this.escapeHtml(task.title)}</div>
            ${task.description ? `<p style="font-size: 0.8125rem; color: var(--text-secondary); margin: 0.5rem 0;">${this.escapeHtml(task.description)}</p>` : ''}
            <div class="kanban-task-meta">
                <div style="display: flex; gap: 0.25rem;">
                    <span class="badge ${statusClass}">${this.formatStatus(task.status)}</span>
                    <span class="badge ${priorityClass}">${task.priority || 'Medium'}</span>
                </div>
                <div style="display: flex; align-items: center; gap: 0.5rem;">
                    ${task.dueDate ? `<span title="Due date"><i class="fas fa-calendar"></i> ${DateUtils.format(task.dueDate, 'MMM DD')}</span>` : ''}
                    ${task.assignee ? `<div class="avatar avatar-sm" title="${this.escapeHtml(task.assignee.name)}">${getInitials(task.assignee.name)}</div>` : ''}
                </div>
            </div>
        `;

        // Make it clickable to view details
        taskDiv.style.cursor = 'pointer';
        taskDiv.addEventListener('click', (e) => {
            // Don't navigate if dragging
            if (!taskDiv.classList.contains('dragging')) {
                const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf('/', 1));
                window.location.href = `${contextPath}/tasks/detail.jsp?id=${task.id}`;
            }
        });

        return taskDiv;
    }

    getStatusBadgeClass(status) {
        const map = {
            'TODO': 'badge-todo',
            'TO_DO': 'badge-todo',
            'IN_PROGRESS': 'badge-progress',
            'DONE': 'badge-done'
        };
        return map[status] || 'badge-todo';
    }

    getPriorityBadgeClass(priority) {
        const map = {
            'LOW': 'badge-low',
            'MEDIUM': 'badge-medium',
            'HIGH': 'badge-high'
        };
        return map[priority?.toUpperCase()] || 'badge-medium';
    }

    formatStatus(status) {
        const map = {
            'TODO': 'To Do',
            'TO_DO': 'To Do',
            'IN_PROGRESS': 'In Progress',
            'DONE': 'Done'
        };
        return map[status] || status;
    }

    escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    // Refresh the board with new data
    async refresh() {
        try {
            LoadingIndicator.show('Loading tasks...');
            const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf('/', 1));
            const tasks = await API.get(`${contextPath}/api/projects/${this.projectId}/tasks`);

            // Clear all columns
            document.querySelectorAll('.kanban-tasks').forEach(column => {
                column.innerHTML = '';
            });

            // Add tasks to appropriate columns
            tasks.forEach(task => {
                this.addTask(task, task.status);
            });

            LoadingIndicator.hide();
        } catch (error) {
            console.error('Failed to refresh kanban board:', error);
            Toast.error('Failed to load tasks');
            LoadingIndicator.hide();
        }
    }
}

// Initialize kanban board when DOM is ready
document.addEventListener('DOMContentLoaded', function () {
    const kanbanBoard = document.querySelector('.kanban-board');
    if (kanbanBoard) {
        const projectId = kanbanBoard.getAttribute('data-project-id');
        if (projectId) {
            window.kanban = new KanbanBoard(projectId);
        }
    }
});

// Export for use in other scripts
window.KanbanBoard = KanbanBoard;
