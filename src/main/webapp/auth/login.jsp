<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Login - Project Management</title>
            <script src="https://cdn.tailwindcss.com"></script>
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        </head>

        <body class="bg-gray-50 min-h-screen flex items-center justify-center">
            <div class="max-w-md w-full">
                <!-- Logo -->
                <div class="text-center mb-8">
                    <div class="inline-flex items-center justify-center w-16 h-16 bg-blue-500 rounded-2xl mb-4">
                        <i class="fas fa-tasks text-white text-2xl"></i>
                    </div>
                    <h1 class="text-3xl font-bold text-gray-900">ProjectFlow</h1>
                    <p class="text-gray-600 mt-2">Sign in to your account</p>
                </div>

                <!-- Login Form -->
                <div class="bg-white rounded-2xl shadow-lg p-8">
                    <c:if test="${not empty error}">
                        <div class="mb-4 p-4 bg-red-50 border border-red-200 rounded-lg">
                            <div class="flex items-center">
                                <i class="fas fa-exclamation-circle text-red-500 mr-3"></i>
                                <span class="text-red-700">${error}</span>
                            </div>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/user/login" method="post">
                        <input type="hidden" name="action" value="login">

                        <div class="space-y-6">
                            <!-- Email -->
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">
                                    Email Address
                                </label>
                                <div class="relative">
                                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                        <i class="fas fa-envelope text-gray-400"></i>
                                    </div>
                                    <input type="email" name="email" required
                                        class="pl-10 w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                        placeholder="you@example.com">
                                </div>
                            </div>

                            <!-- Password -->
                            <div>
                                <div class="flex items-center justify-between mb-2">
                                    <label class="block text-sm font-medium text-gray-700">
                                        Password
                                    </label>
                                    <a href="#" class="text-sm text-blue-600 hover:text-blue-800">
                                        Forgot password?
                                    </a>
                                </div>
                                <div class="relative">
                                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                        <i class="fas fa-lock text-gray-400"></i>
                                    </div>
                                    <input type="password" name="password" required
                                        class="pl-10 w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                        placeholder="••••••••">
                                </div>
                            </div>

                            <!-- Remember Me -->
                            <div class="flex items-center">
                                <input type="checkbox" id="remember" name="remember"
                                    class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded">
                                <label for="remember" class="ml-2 block text-sm text-gray-700">
                                    Remember me
                                </label>
                            </div>

                            <!-- Submit Button -->
                            <button type="submit"
                                class="w-full bg-blue-600 text-white py-3 px-4 rounded-lg hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-colors font-medium">
                                Sign In
                            </button>
                        </div>
                    </form>

                    <div class="mt-6 pt-6 border-t border-gray-200">
                        <p class="text-center text-sm text-gray-600">
                            Don't have an account?
                            <a href="${pageContext.request.contextPath}/auth/register.jsp"
                                class="text-blue-600 hover:text-blue-800 font-medium">
                                Sign up
                            </a>
                        </p>
                    </div>
                </div>

                <!-- Demo Credentials -->
                <div class="mt-8 text-center">
                    <p class="text-sm text-gray-600">Demo credentials:</p>
                    <p class="text-sm text-gray-500 mt-1">admin@example.com / admin123</p>
                    <p class="text-sm text-gray-500">pm@example.com / pm123</p>
                    <p class="text-sm text-gray-500">dev1@example.com / dev123</p>
                </div>
            </div>
        </body>

        </html>