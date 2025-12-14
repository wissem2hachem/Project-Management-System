<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <div class="max-w-2xl mx-auto">
            <div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
                <div class="px-6 py-4 border-b border-gray-200 flex justify-between items-center">
                    <h2 class="text-xl font-bold text-gray-900">Edit Task</h2>
                </div>

                <form action="${pageContext.request.contextPath}/tasks/" method="post" class="p-6 space-y-6">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="taskId" value="${task.id}">

                    <div>
                        <label for="status" class="block text-sm font-medium text-gray-700 mb-1">Status</label>
                        <select id="status" name="status"
                            class="w-full rounded-lg border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500">
                            <option value="TODO" ${task.status=='TODO' ? 'selected' : '' }>To Do</option>
                            <option value="IN_PROGRESS" ${task.status=='IN_PROGRESS' ? 'selected' : '' }>In Progress
                            </option>
                            <option value="DONE" ${task.status=='DONE' ? 'selected' : '' }>Done</option>
                        </select>
                    </div>

                    <div class="flex justify-end space-x-3 pt-4">
                        <a href="${pageContext.request.contextPath}/tasks/"
                            class="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50">
                            Cancel
                        </a>
                        <button type="submit"
                            class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2">
                            Save Changes
                        </button>
                    </div>
                </form>
            </div>
        </div>