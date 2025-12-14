<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Register - Project Management</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    </head>

    <body class="bg-gradient-to-br from-blue-50 to-gray-100 min-h-screen flex items-center justify-center p-4">
        <div class="max-w-4xl w-full">
            <div class="bg-white rounded-2xl shadow-xl overflow-hidden">
                <div class="md:flex">
                    <!-- Left Side - Illustration -->
                    <div class="md:w-1/2 bg-gradient-to-br from-blue-500 to-purple-600 p-8 md:p-12 text-white">
                        <div class="h-full flex flex-col justify-center">
                            <div class="mb-8">
                                <div
                                    class="inline-flex items-center justify-center w-16 h-16 bg-white/20 rounded-2xl mb-6">
                                    <i class="fas fa-tasks text-2xl"></i>
                                </div>
                                <h1 class="text-3xl font-bold">Join ProjectFlow</h1>
                                <p class="mt-2 text-blue-100">Streamline your project management workflow</p>
                            </div>

                            <div class="space-y-6">
                                <div class="flex items-center">
                                    <div
                                        class="w-10 h-10 rounded-full bg-white/20 flex items-center justify-center mr-4">
                                        <i class="fas fa-check"></i>
                                    </div>
                                    <div>
                                        <h3 class="font-semibold">Track Progress</h3>
                                        <p class="text-sm text-blue-100 mt-1">Monitor project milestones and deadlines
                                        </p>
                                    </div>
                                </div>

                                <div class="flex items-center">
                                    <div
                                        class="w-10 h-10 rounded-full bg-white/20 flex items-center justify-center mr-4">
                                        <i class="fas fa-users"></i>
                                    </div>
                                    <div>
                                        <h3 class="font-semibold">Team Collaboration</h3>
                                        <p class="text-sm text-blue-100 mt-1">Work together efficiently with your team
                                        </p>
                                    </div>
                                </div>

                                <div class="flex items-center">
                                    <div
                                        class="w-10 h-10 rounded-full bg-white/20 flex items-center justify-center mr-4">
                                        <i class="fas fa-chart-line"></i>
                                    </div>
                                    <div>
                                        <h3 class="font-semibold">Analytics Dashboard</h3>
                                        <p class="text-sm text-blue-100 mt-1">Gain insights with comprehensive reports
                                        </p>
                                    </div>
                                </div>
                            </div>

                            <div class="mt-12 pt-8 border-t border-white/20">
                                <p class="text-sm">Already have an account?</p>
                                <a href="${pageContext.request.contextPath}/auth/login.jsp"
                                    class="inline-flex items-center mt-2 text-white font-medium hover:underline">
                                    Sign in here <i class="fas fa-arrow-right ml-2"></i>
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Right Side - Registration Form -->
                    <div class="md:w-1/2 p-8 md:p-12">
                        <div class="max-w-md mx-auto">
                            <h2 class="text-2xl font-bold text-gray-900">Create Account</h2>
                            <p class="text-gray-600 mt-2">Fill in your details to get started</p>

                            <c:if test="${not empty error}">
                                <div class="mt-4 p-4 bg-red-50 border border-red-200 rounded-lg">
                                    <div class="flex items-center">
                                        <i class="fas fa-exclamation-circle text-red-500 mr-3"></i>
                                        <span class="text-red-700">
                                            <c:out value="${error}" />
                                        </span>
                                    </div>
                                </div>
                            </c:if>

                            <form action="${pageContext.request.contextPath}/user/register" method="post"
                                class="mt-8 space-y-6">
                                <input type="hidden" name="action" value="register">

                                <!-- Name -->
                                <div>
                                    <label class="block text-sm font-medium text-gray-700 mb-2">
                                        Full Name <span class="text-red-500">*</span>
                                    </label>
                                    <div class="relative">
                                        <div
                                            class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                            <i class="fas fa-user text-gray-400"></i>
                                        </div>
                                        <input type="text" name="name" required
                                            class="pl-10 w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                            placeholder="John Doe">
                                    </div>
                                </div>

                                <!-- Email -->
                                <div>
                                    <label class="block text-sm font-medium text-gray-700 mb-2">
                                        Email Address <span class="text-red-500">*</span>
                                    </label>
                                    <div class="relative">
                                        <div
                                            class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                            <i class="fas fa-envelope text-gray-400"></i>
                                        </div>
                                        <input type="email" name="email" required
                                            class="pl-10 w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                            placeholder="you@example.com">
                                    </div>
                                </div>

                                <!-- Password -->
                                <div>
                                    <label class="block text-sm font-medium text-gray-700 mb-2">
                                        Password <span class="text-red-500">*</span>
                                    </label>
                                    <div class="relative">
                                        <div
                                            class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                            <i class="fas fa-lock text-gray-400"></i>
                                        </div>
                                        <input type="password" name="password" id="password" required
                                            class="pl-10 w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                            placeholder="••••••••">
                                    </div>
                                    <div class="mt-2 grid grid-cols-2 gap-2 text-xs text-gray-600">
                                        <div class="flex items-center">
                                            <i id="length-check" class="fas fa-circle text-gray-300 mr-1"></i>
                                            <span>8+ characters</span>
                                        </div>
                                        <div class="flex items-center">
                                            <i id="number-check" class="fas fa-circle text-gray-300 mr-1"></i>
                                            <span>Number</span>
                                        </div>
                                    </div>
                                </div>

                                <!-- Confirm Password -->
                                <div>
                                    <label class="block text-sm font-medium text-gray-700 mb-2">
                                        Confirm Password <span class="text-red-500">*</span>
                                    </label>
                                    <div class="relative">
                                        <div
                                            class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                            <i class="fas fa-lock text-gray-400"></i>
                                        </div>
                                        <input type="password" name="confirmPassword" id="confirmPassword" required
                                            class="pl-10 w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                            placeholder="••••••••">
                                    </div>
                                    <div id="password-match" class="mt-2 text-xs text-red-600 hidden">
                                        <i class="fas fa-exclamation-circle mr-1"></i>
                                        Passwords do not match
                                    </div>
                                </div>

                                <!-- Terms Agreement -->
                                <div class="flex items-start">
                                    <input type="checkbox" id="terms" name="terms" required
                                        class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded mt-1">
                                    <label for="terms" class="ml-2 block text-sm text-gray-700">
                                        I agree to the
                                        <a href="#" class="text-blue-600 hover:text-blue-800">Terms of Service</a>
                                        and
                                        <a href="#" class="text-blue-600 hover:text-blue-800">Privacy Policy</a>
                                    </label>
                                </div>

                                <!-- Submit Button -->
                                <button type="submit" id="submit-btn"
                                    class="w-full bg-gradient-to-r from-blue-500 to-purple-600 text-white py-3 px-4 rounded-lg hover:from-blue-600 hover:to-purple-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-all font-medium disabled:opacity-50 disabled:cursor-not-allowed">
                                    Create Account
                                </button>
                            </form>

                            <!-- Social Login -->
                            <div class="mt-8 pt-8 border-t border-gray-200">
                                <p class="text-center text-sm text-gray-600 mb-4">Or sign up with</p>
                                <div class="grid grid-cols-2 gap-3">
                                    <button type="button"
                                        class="flex items-center justify-center px-4 py-3 border border-gray-300 rounded-lg hover:bg-gray-50">
                                        <i class="fab fa-google text-red-500 mr-2"></i>
                                        <span>Google</span>
                                    </button>
                                    <button type="button"
                                        class="flex items-center justify-center px-4 py-3 border border-gray-300 rounded-lg hover:bg-gray-50">
                                        <i class="fab fa-github text-gray-800 mr-2"></i>
                                        <span>GitHub</span>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>

    <script>
        const password = document.getElementById('password');
        const confirmPassword = document.getElementById('confirmPassword');
        const submitBtn = document.getElementById('submit-btn');
        const lengthCheck = document.getElementById('length-check');
        const numberCheck = document.getElementById('number-check');
        const passwordMatch = document.getElementById('password-match');

        function validatePassword() {
            let isValid = true;

            // Check length
            if (password.value.length >= 8) {
                lengthCheck.className = 'fas fa-check-circle text-green-500 mr-1';
            } else {
                lengthCheck.className = 'fas fa-times-circle text-red-500 mr-1';
                isValid = false;
            }

            // Check for number
            if (/\d/.test(password.value)) {
                numberCheck.className = 'fas fa-check-circle text-green-500 mr-1';
            } else {
                numberCheck.className = 'fas fa-times-circle text-red-500 mr-1';
                isValid = false;
            }

            // Check password match
            if (confirmPassword.value && password.value !== confirmPassword.value) {
                passwordMatch.classList.remove('hidden');
                isValid = false;
            } else {
                passwordMatch.classList.add('hidden');
            }

            // Check if passwords are not empty and match
            if (password.value && confirmPassword.value && password.value === confirmPassword.value) {
                passwordMatch.classList.add('hidden');
            }

            submitBtn.disabled = !isValid;
            return isValid;
        }

        password.addEventListener('input', validatePassword);
        confirmPassword.addEventListener('input', validatePassword);

        // Form submission validation
        document.querySelector('form').addEventListener('submit', function (e) {
            if (!validatePassword()) {
                e.preventDefault();
                alert('Please fix the password validation errors.');
            }
        });
    </script>

    </html>