<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

            <div id="users-content">
                <!-- Header -->
                <div class="flex flex-col md:flex-row md:items-center justify-between mb-8">
                    <div class="mb-4 md:mb-0">
                        <h2 class="text-2xl font-bold text-gray-900">Users</h2>
                        <p class="text-gray-600 mt-1">View system users and their roles</p>
                    </div>
                </div>

                <!-- Users Table -->
                <div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
                    <div class="overflow-x-auto">
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th scope="col"
                                        class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        User
                                    </th>
                                    <th scope="col"
                                        class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Role
                                    </th>
                                    <th scope="col"
                                        class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Join Date
                                    </th>
                                    <th scope="col"
                                        class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Status
                                    </th>
                                </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                                <c:forEach var="user" items="${users}">
                                    <tr class="hover:bg-gray-50">
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <div class="flex items-center">
                                                <div class="flex-shrink-0 h-10 w-10">
                                                    <div
                                                        class="h-10 w-10 rounded-full bg-blue-100 flex items-center justify-center">
                                                        <c:choose>
                                                            <c:when test="${not empty user.avatarUrl}">
                                                                <img src="${user.avatarUrl}" alt="${user.name}"
                                                                    class="h-10 w-10 rounded-full">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-blue-600 font-semibold">
                                                                    <c:out value="${user.name.charAt(0)}" />
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                                <div class="ml-4">
                                                    <div class="text-sm font-medium text-gray-900">
                                                        <c:out value="${user.name}" />
                                                    </div>
                                                    <div class="text-sm text-gray-500">
                                                        <c:out value="${user.email}" />
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full
                                            ${user.role == 'ADMIN' ? 'bg-purple-100 text-purple-800' :
                                              user.role == 'MANAGER' ? 'bg-blue-100 text-blue-800' :
                                              'bg-green-100 text-green-800'}">
                                                <c:out value="${user.role}" />
                                            </span>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                            <c:choose>
                                                <c:when test="${not empty user.joinDate}">
                                                    ${user.joinDate.toString().substring(0, 10)}
                                                </c:when>
                                                <c:otherwise>
                                                    N/A
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <span
                                                class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                                                Active
                                            </span>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>