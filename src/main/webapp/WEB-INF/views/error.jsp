<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<% String ctx = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Something went wrong</title>
<link rel="stylesheet" href="<%= ctx %>/assets/css/fonts.css">
<style>
    body{margin:0;min-height:100vh;display:flex;align-items:center;justify-content:center;background:linear-gradient(180deg,#fff,#faf7ff);font-family:uic,system-ui,sans-serif;text-align:center;color:#333}
    h1{font-family:uicbold,system-ui,sans-serif;font-size:34px;margin:0 0 6px}
    p{margin:0 0 18px;color:#6B6B6B;font-size:14px}
    a{display:inline-block;padding:10px 22px;border-radius:10px;background:#A855F7;color:#fff;text-decoration:none;font-family:uicbold,system-ui,sans-serif}
</style>
</head>
<body>
<main>
    <h1>Page not available</h1>
    <p>The page you asked for could not be shown.</p>
    <a href="<%= ctx %>/prompt">Go to home</a>
</main>
</body>
</html>