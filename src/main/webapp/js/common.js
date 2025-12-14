/**
 * Project Management System - Common JavaScript Utilities
 */

// ========================================
// Toast Notifications
// ========================================
const Toast = {
    container: null,

    init() {
        if (!this.container) {
            this.container = document.createElement('div');
            this.container.className = 'toast-container';
            document.body.appendChild(this.container);
        }
    },

    show(message, type = 'info', duration = 3000) {
        this.init();

        const toast = document.createElement('div');
        toast.className = `toast alert-${type}`;
        toast.innerHTML = `
            <div style="display: flex; align-items: start; gap: 0.75rem;">
                <span style="font-size: 1.25rem;">
                    ${this.getIcon(type)}
                </span>
                <div style="flex: 1;">
                    <p style="margin: 0; font-weight: 500; color: var(--text-primary);">
                        ${this.getTitle(type)}
                    </p>
                    <p style="margin: 0; margin-top: 0.25rem; font-size: 0.875rem; color: var(--text-secondary);">
                        ${message}
                    </p>
                </div>
                <button onclick="this.parentElement.parentElement.remove()" 
                        style="background: none; border: none; cursor: pointer; padding: 0; color: var(--text-secondary);">
                    <i class="fas fa-times"></i>
                </button>
            </div>
        `;

        this.container.appendChild(toast);

        if (duration > 0) {
            setTimeout(() => {
                toast.style.animation = 'slideOutRight 0.3s ease-out';
                setTimeout(() => toast.remove(), 300);
            }, duration);
        }
    },

    getIcon(type) {
        const icons = {
            success: '<i class="fas fa-check-circle" style="color: var(--success);"></i>',
            error: '<i class="fas fa-exclamation-circle" style="color: var(--error);"></i>',
            warning: '<i class="fas fa-exclamation-triangle" style="color: var(--warning);"></i>',
            info: '<i class="fas fa-info-circle" style="color: var(--info);"></i>'
        };
        return icons[type] || icons.info;
    },

    getTitle(type) {
        const titles = {
            success: 'Success',
            error: 'Error',
            warning: 'Warning',
            info: 'Information'
        };
        return titles[type] || titles.info;
    },

    success(message, duration = 3000) {
        this.show(message, 'success', duration);
    },

    error(message, duration = 5000) {
        this.show(message, 'error', duration);
    },

    warning(message, duration = 4000) {
        this.show(message, 'warning', duration);
    },

    info(message, duration = 3000) {
        this.show(message, 'info', duration);
    }
};

// Add slideOut animation
const style = document.createElement('style');
style.textContent = `
    @keyframes slideOutRight {
        from {
            transform: translateX(0);
            opacity: 1;
        }
        to {
            transform: translateX(100%);
            opacity: 0;
        }
    }
`;
document.head.appendChild(style);

// ========================================
// Confirmation Dialog
// ========================================
function confirm(message, title = 'Confirm Action') {
    return new Promise((resolve) => {
        const modal = document.createElement('div');
        modal.style.cssText = `
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(0, 0, 0, 0.5);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 10000;
        `;

        modal.innerHTML = `
            <div class="card" style="max-width: 400px; margin: 1rem;">
                <div class="card-header">
                    <h4 class="card-title" style="margin: 0;">${title}</h4>
                </div>
                <div class="card-body">
                    <p>${message}</p>
                </div>
                <div class="card-footer" style="display: flex; gap: 0.5rem; justify-content: flex-end;">
                    <button class="btn btn-secondary" onclick="this.closest('[style*=fixed]').remove(); window.confirmResolve(false);">
                        Cancel
                    </button>
                    <button class="btn btn-primary" onclick="this.closest('[style*=fixed]').remove(); window.confirmResolve(true);">
                        Confirm
                    </button>
                </div>
            </div>
        `;

        document.body.appendChild(modal);
        window.confirmResolve = resolve;
    });
}

// ========================================
// AJAX Helper
// ========================================
const API = {
    baseUrl: '',

    async request(url, options = {}) {
        const defaultOptions = {
            headers: {
                'Content-Type': 'application/json',
                ...options.headers
            }
        };

        try {
            const response = await fetch(this.baseUrl + url, { ...defaultOptions, ...options });

            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }

            const contentType = response.headers.get('content-type');
            if (contentType && contentType.includes('application/json')) {
                return await response.json();
            }

            return await response.text();
        } catch (error) {
            console.error('API request failed:', error);
            throw error;
        }
    },

    get(url) {
        return this.request(url, { method: 'GET' });
    },

    post(url, data) {
        return this.request(url, {
            method: 'POST',
            body: JSON.stringify(data)
        });
    },

    put(url, data) {
        return this.request(url, {
            method: 'PUT',
            body: JSON.stringify(data)
        });
    },

    delete(url) {
        return this.request(url, { method: 'DELETE' });
    }
};

// ========================================
// Date Formatting
// ========================================
const DateUtils = {
    format(dateString, format = 'MMM DD, YYYY') {
        if (!dateString) return '';

        const date = new Date(dateString);
        if (isNaN(date.getTime())) return dateString;

        const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        const monthsFull = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

        const replacements = {
            'YYYY': date.getFullYear(),
            'YY': String(date.getFullYear()).slice(-2),
            'MMMM': monthsFull[date.getMonth()],
            'MMM': months[date.getMonth()],
            'MM': String(date.getMonth() + 1).padStart(2, '0'),
            'DD': String(date.getDate()).padStart(2, '0'),
            'D': date.getDate(),
            'HH': String(date.getHours()).padStart(2, '0'),
            'mm': String(date.getMinutes()).padStart(2, '0'),
            'ss': String(date.getSeconds()).padStart(2, '0')
        };

        let formatted = format;
        for (const [key, value] of Object.entries(replacements)) {
            formatted = formatted.replace(key, value);
        }

        return formatted;
    },

    timeAgo(dateString) {
        if (!dateString) return '';

        const date = new Date(dateString);
        const now = new Date();
        const seconds = Math.floor((now - date) / 1000);

        const intervals = {
            year: 31536000,
            month: 2592000,
            week: 604800,
            day: 86400,
            hour: 3600,
            minute: 60
        };

        for (const [unit, secondsInUnit] of Object.entries(intervals)) {
            const interval = Math.floor(seconds / secondsInUnit);
            if (interval >= 1) {
                return interval === 1 ? `1 ${unit} ago` : `${interval} ${unit}s ago`;
            }
        }

        return 'just now';
    },

    daysUntil(dateString) {
        if (!dateString) return null;

        const date = new Date(dateString);
        const now = new Date();
        now.setHours(0, 0, 0, 0);
        date.setHours(0, 0, 0, 0);

        const diffTime = date - now;
        const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

        return diffDays;
    },

    isOverdue(dateString) {
        const days = this.daysUntil(dateString);
        return days !== null && days < 0;
    },

    getDueDateText(dateString) {
        if (!dateString) return '';

        const days = this.daysUntil(dateString);

        if (days === null) return '';
        if (days < 0) return `${Math.abs(days)} days overdue`;
        if (days === 0) return 'Due today';
        if (days === 1) return 'Due tomorrow';
        return `Due in ${days} days`;
    }
};

// ========================================
// Form Validation
// ========================================
const FormValidator = {
    validate(formElement) {
        const errors = [];
        const inputs = formElement.querySelectorAll('[required], [data-validate]');

        inputs.forEach(input => {
            this.clearError(input);

            // Required validation
            if (input.hasAttribute('required') && !input.value.trim()) {
                this.setError(input, `${this.getFieldName(input)} is required`);
                errors.push(input);
                return;
            }

            // Email validation
            if (input.type === 'email' && input.value) {
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailRegex.test(input.value)) {
                    this.setError(input, 'Please enter a valid email address');
                    errors.push(input);
                    return;
                }
            }

            // Date validation
            if (input.type === 'date' && input.value) {
                const date = new Date(input.value);
                if (isNaN(date.getTime())) {
                    this.setError(input, 'Please enter a valid date');
                    errors.push(input);
                    return;
                }

                // Check if future date is required
                if (input.hasAttribute('data-future') && date < new Date()) {
                    this.setError(input, 'Date must be in the future');
                    errors.push(input);
                    return;
                }
            }

            // Min length validation
            const minLength = input.getAttribute('minlength');
            if (minLength && input.value.length < parseInt(minLength)) {
                this.setError(input, `${this.getFieldName(input)} must be at least ${minLength} characters`);
                errors.push(input);
                return;
            }

            // Max length validation
            const maxLength = input.getAttribute('maxlength');
            if (maxLength && input.value.length > parseInt(maxLength)) {
                this.setError(input, `${this.getFieldName(input)} must be no more than ${maxLength} characters`);
                errors.push(input);
                return;
            }

            // Pattern validation
            const pattern = input.getAttribute('pattern');
            if (pattern && input.value) {
                const regex = new RegExp(pattern);
                if (!regex.test(input.value)) {
                    this.setError(input, input.getAttribute('data-pattern-message') || 'Invalid format');
                    errors.push(input);
                    return;
                }
            }
        });

        return errors.length === 0;
    },

    setError(input, message) {
        input.classList.add('is-invalid');

        let errorElement = input.parentElement.querySelector('.invalid-feedback');
        if (!errorElement) {
            errorElement = document.createElement('div');
            errorElement.className = 'invalid-feedback';
            input.parentElement.appendChild(errorElement);
        }
        errorElement.textContent = message;
    },

    clearError(input) {
        input.classList.remove('is-invalid');
        const errorElement = input.parentElement.querySelector('.invalid-feedback');
        if (errorElement) {
            errorElement.remove();
        }
    },

    getFieldName(input) {
        const label = input.parentElement.querySelector('label');
        if (label) {
            return label.textContent.replace('*', '').trim();
        }
        return input.name || input.id || 'This field';
    }
};

// ========================================
// Progress Bar Helper
// ========================================
function updateProgressBar(element, percentage) {
    const bar = element.querySelector('.progress-bar');
    if (bar) {
        bar.style.width = percentage + '%';

        // Change color based on percentage
        bar.classList.remove('progress-bar-danger', 'progress-bar-warning', 'progress-bar-success');
        if (percentage < 30) {
            bar.classList.add('progress-bar-danger');
        } else if (percentage < 70) {
            bar.classList.add('progress-bar-warning');
        } else {
            bar.classList.add('progress-bar-success');
        }
    }
}

// ========================================
// Avatar Helper
// ========================================
function getInitials(name) {
    if (!name) return '?';

    const parts = name.trim().split(' ');
    if (parts.length >= 2) {
        return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
    }
    return name.substring(0, 2).toUpperCase();
}

function createAvatar(name, size = '') {
    const initials = getInitials(name);
    const sizeClass = size ? `avatar-${size}` : '';
    return `<div class="avatar ${sizeClass}">${initials}</div>`;
}

// ========================================
// Loading Indicator
// ========================================
const LoadingIndicator = {
    show(message = 'Loading...') {
        let loader = document.getElementById('global-loader');
        if (!loader) {
            loader = document.createElement('div');
            loader.id = 'global-loader';
            loader.style.cssText = `
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background-color: rgba(0, 0, 0, 0.5);
                display: flex;
                align-items: center;
                justify-content: center;
                z-index: 9998;
            `;
            loader.innerHTML = `
                <div class="card" style="padding: 2rem; text-align: center;">
                    <div style="font-size: 2rem; color: var(--primary-600); margin-bottom: 1rem;">
                        <i class="fas fa-spinner fa-spin"></i>
                    </div>
                    <p style="margin: 0; color: var(--text-primary);">${message}</p>
                </div>
            `;
            document.body.appendChild(loader);
        }
    },

    hide() {
        const loader = document.getElementById('global-loader');
        if (loader) {
            loader.remove();
        }
    }
};

// ========================================
// Utility Functions
// ========================================

// Debounce function for search inputs
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

// Format file size
function formatFileSize(bytes) {
    if (bytes === 0) return '0 Bytes';
    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return Math.round(bytes / Math.pow(k, i) * 100) / 100 + ' ' + sizes[i];
}

// Capitalize first letter
function capitalize(str) {
    if (!str) return '';
    return str.charAt(0).toUpperCase() + str.slice(1).toLowerCase();
}

// Get status color
function getStatusColor(status) {
    const colors = {
        'TODO': 'var(--status-todo)',
        'TO_DO': 'var(--status-todo)',
        'IN_PROGRESS': 'var(--status-progress)',
        'DONE': 'var(--status-done)'
    };
    return colors[status] || 'var(--gray-500)';
}

// Get priority color
function getPriorityColor(priority) {
    const colors = {
        'LOW': 'var(--priority-low)',
        'MEDIUM': 'var(--priority-medium)',
        'HIGH': 'var(--priority-high)'
    };
    return colors[priority] || 'var(--gray-500)';
}

// ========================================
// Initialize on DOM ready
// ========================================
document.addEventListener('DOMContentLoaded', function () {
    console.log('Project Management System - JavaScript loaded');
});

// Export for use in other scripts
window.Toast = Toast;
window.API = API;
window.DateUtils = DateUtils;
window.FormValidator = FormValidator;
window.LoadingIndicator = LoadingIndicator;
window.confirmDialog = confirm;
window.updateProgressBar = updateProgressBar;
window.getInitials = getInitials;
window.createAvatar = createAvatar;
window.debounce = debounce;
window.formatFileSize = formatFileSize;
window.capitalize = capitalize;
window.getStatusColor = getStatusColor;
window.getPriorityColor = getPriorityColor;
