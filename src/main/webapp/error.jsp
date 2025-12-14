<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - Project Management</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-50 min-h-screen flex items-center justify-center p-4">
<div class="max-w-md w-full text-center">
    <div class="mb-8">
        <div class="inline-flex items-center justify-center w-20 h-20 bg-red-100 rounded-full mb-6">
            <i class="fas fa-exclamation-triangle text-red-500 text-3xl"></i>
        </div>
        <h1 class="text-4xl font-bold text-gray-900 mb-2">
            <c:choose>
                <c:when test="${pageContext.errorData.statusCode == 404}">
                    404
                </c:when>
                <c:otherwise>
                    Oops!
                </c:otherwise>
            </c:choose>
        </h1>

        <c:choose>
            <c:when test="${pageContext.errorData.statusCode == 404}">
                <p class="text-xl text-gray-600 mb-6">Page Not Found</p>
                <p class="text-gray-500 mb-8">The page you're looking for doesn't exist or has been moved.</p>
            </c:when>
            <c:when test="${pageContext.errorData.statusCode == 500}">
                <p class="text-xl text-gray-600 mb-6">Server Error</p>
                <p class="text-gray-500 mb-8">Something went wrong on our end. Please try again later.</p>
            </c:when>
            <c:otherwise>
                <p class="text-xl text-gray-600 mb-6">An Error Occurred</p>
                <p class="text-gray-500 mb-8">${pageContext.exception.message}</p>
            </c:otherwise>
        </c:choose>

        <!-- Developer Info (only show in development) -->
        <c:if test="${pageContext.exception != null}">
            <div class="bg-gray-100 rounded-lg p-4 text-left mt-6">
                <h3 class="font-semibold text-gray-900 mb-2">Error Details:</h3>
                <pre class="text-sm text-gray-600 overflow-auto">${pageContext.exception}</pre>
            </div>
        </c:if>
    </div>

    <div class="space-y-4">
        <a href="${pageContext.request.contextPath}/"
           class="inline-flex items-center px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
            <i class="fas fa-home mr-2"></i>
            Go to Homepage
        </a>
        <button onclick="window.history.back()"
                class="inline-flex items-center px-6 py-3 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 ml-4">
            <i class="fas fa-arrow-left mr-2"></i>
            Go Back
        </button>
    </div>

    <div class="mt-8 pt-8 border-t border-gray-200">
        <p class="text-sm text-gray-500">
            Need help? <a href="mailto:support@example.com" class="text-blue-600 hover:text-blue-800">Contact Support</a>
        </p>
    </div>
</div>
</body>
</html>