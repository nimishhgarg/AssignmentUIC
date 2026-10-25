<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="app.Config" %>
<%
    String ctx = request.getContextPath();
    String csrf = (String) request.getAttribute("csrf");
    String popupTitle = (String) request.getAttribute("popupTitle");
    String popupBody = (String) request.getAttribute("popupBody");
    String email = (String) request.getAttribute("email");
    boolean hasError = popupBody != null && !popupBody.isEmpty();
    String invalid = hasError ? " aria-invalid=\"true\"" : "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="robots" content="noindex, nofollow">
<title>Login | AssignmentUIC</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Caveat:wght@500&display=swap">
<link rel="stylesheet" href="<%= ctx %>/assets/css/login.css">
</head>
<body class="stage">

<div class="scene" aria-hidden="true">
    <span class="orb orb-a"></span>
    <span class="orb orb-b"></span>
    <span class="orb orb-c"></span>
    <svg class="crest crest-top" viewBox="0 0 1440 320" preserveAspectRatio="none" focusable="false"><path fill="#F7F2FF" d="M0,224L120,208C240,192,480,160,720,154.7C960,149,1200,171,1320,181.3L1440,192L1440,0L1320,0C1200,0,960,0,720,0C480,0,240,0,120,0L0,0Z"/></svg>
    <svg class="crest crest-base" viewBox="0 0 1440 320" preserveAspectRatio="none" focusable="false"><path fill="#FAF5FF" d="M0,160L120,170.7C240,181,480,203,720,218.7C960,235,1200,245,1320,240L1440,235L1440,320L1320,320C1200,320,960,320,720,320C480,320,240,320,120,320L0,320Z"/></svg>
    <span class="spark spark-a"></span>
    <span class="spark spark-b"></span>
    <span class="spark spark-c"></span>
    <span class="note note-a">Your Worksheets<br>Simplified</span>
    <span class="note note-b">Fast.<br>Free.</span>
    <span class="note note-c">From Ideas<br>to Worksheets</span>
</div>

<% if (hasError) { %>
<div class="popup" id="popup" role="alert">
    <div class="popup-main">
        <svg class="popup-icon" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#0B1020" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true" focusable="false"><path d="M3 12a9 9 0 1 0 18 0a9 9 0 1 0 -18 0"/><path d="M12 9v4"/><path d="M12 16v.01"/></svg>
        <div>
            <p class="popup-head"><%= Config.esc(popupTitle) %></p>
            <p class="popup-body"><%= Config.esc(popupBody) %></p>
        </div>
    </div>
    <button class="popup-close" type="button" aria-label="Close notification">
        <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#0B1020" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true" focusable="false"><path d="M18 6l-12 12"/><path d="M6 6l12 12"/></svg>
    </button>
</div>
<% } %>

<main class="shell">
    <div class="brand">
        <svg class="brand-mark" xmlns="http://www.w3.org/2000/svg" width="120" height="120" viewBox="0 0 24 24" fill="#818CF8" aria-hidden="true" focusable="false"><path d="M19 13.431v2.569c0 2.398 -3.205 4 -7 4s-7 -1.602 -7 -4v-2.569l5.886 2.354a3 3 0 0 0 2.011 .078l.217 -.078zm2 -2.955l-8.629 3.452a1 1 0 0 1 -.742 0l-10 -4c-.839 -.335 -.839 -1.521 0 -1.856l10 -4a1 1 0 0 1 .245 -.064l.126 -.008l.126 .008a1 1 0 0 1 .245 .064l10.032 4.013l.108 .055l.099 .068l.088 .076l.075 .082l.035 .044l.073 .115l.052 .115l.034 .102l.025 .135l.006 .058l.002 6.065a1 1 0 0 1 -2 0z"/></svg>
        <p class="title">Assignment<span class="title-accent">UIC</span></p>
        <ul class="tagline">
            <li>Fast</li>
            <li>Free</li>
            <li>For Lazy Guys</li>
        </ul>

        <section class="panel" aria-labelledby="panel-head">
            <h1 id="panel-head" class="panel-head">Welcome Back</h1>
            <p class="panel-sub">Login to continue and create amazing worksheets.</p>

            <form id="login-form" method="post" action="<%= ctx %>/login" novalidate>
                <input type="hidden" name="uic_nonce" value="<%= Config.esc(csrf) %>">

                <label class="lbl" for="email">Email Address</label>
                <div class="control">
                    <span class="control-icon" aria-hidden="true">
                        <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#7E22CE" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" focusable="false"><path d="M3 12a9 9 0 1 0 18 0a9 9 0 1 0 -18 0"/><path d="M9 10a3 3 0 1 0 6 0a3 3 0 1 0 -6 0"/><path d="M6.168 18.849a4 4 0 0 1 3.832 -2.849h4a4 4 0 0 1 3.834 2.855"/></svg>
                    </span>
                    <input id="email" class="control-input" type="email" name="email" autocomplete="username" autocapitalize="off" autocorrect="off" spellcheck="false" inputmode="email" maxlength="254" required placeholder="Enter your Email Address" value="<%= Config.esc(email) %>"<%= invalid %>>
                </div>

                <label class="lbl lbl-tight" for="pass">Password</label>
                <div class="control">
                    <span class="control-icon" aria-hidden="true">
                        <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#7E22CE" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" focusable="false"><path d="M5 13a2 2 0 0 1 2 -2h10a2 2 0 0 1 2 2v6a2 2 0 0 1 -2 2h-10a2 2 0 0 1 -2 -2v-6"/><path d="M11 16a1 1 0 1 0 2 0a1 1 0 0 0 -2 0"/><path d="M8 11v-4a4 4 0 1 1 8 0v4"/></svg>
                    </span>
                    <input id="pass" class="control-input" type="password" name="pass" autocomplete="current-password" maxlength="1024" required placeholder="Enter your password"<%= invalid %>>
                    <button class="control-toggle" type="button" aria-label="Show password" aria-pressed="false" aria-controls="pass" hidden>
                        <svg class="eye-on" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#6B6B6B" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" focusable="false"><path d="M10 12a2 2 0 1 0 4 0a2 2 0 0 0 -4 0"/><path d="M21 12c-2.4 4 -5.4 6 -9 6c-3.6 0 -6.6 -2 -9 -6c2.4 -4 5.4 -6 9 -6c3.6 0 6.6 2 9 6"/></svg>
                        <svg class="eye-off" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#6B6B6B" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" focusable="false" hidden><path d="M10.585 10.587a2 2 0 0 0 2.829 2.828"/><path d="M16.681 16.673a8.717 8.717 0 0 1 -4.681 1.327c-3.6 0 -6.6 -2 -9 -6c1.272 -2.12 2.712 -3.678 4.32 -4.674m2.86 -1.146a9.055 9.055 0 0 1 1.82 -.18c3.6 0 6.6 2 9 6c-.666 1.11 -1.379 2.067 -2.138 2.87"/><path d="M3 3l18 18"/></svg>
                    </button>
                </div>

                <div class="row">
                    <label class="check">
                        <input type="checkbox" name="remember" value="1" checked>
                        <span>Remember me</span>
                    </label>
                </div>

                <button class="submit" type="submit" name="uic_submit" value="1">Login</button>
            </form>
            <p class="alt-link">New here? <a href="<%= ctx %>/register">Create an account</a></p>
        </section>
    </div>
</main>

<script>
(function () {
    'use strict';

    var toggle = document.querySelector('.control-toggle');
    var pass = document.getElementById('pass');

    if (toggle && pass) {
        var eyeOn = toggle.querySelector('.eye-on');
        var eyeOff = toggle.querySelector('.eye-off');
        toggle.hidden = false;
        toggle.addEventListener('click', function () {
            var show = pass.type === 'password';
            pass.type = show ? 'text' : 'password';
            toggle.setAttribute('aria-pressed', show ? 'true' : 'false');
            toggle.setAttribute('aria-label', show ? 'Hide password' : 'Show password');
            eyeOn.hidden = show;
            eyeOff.hidden = !show;
            pass.focus();
        });
    }

    var form = document.getElementById('login-form');
    var submit = form ? form.querySelector('.submit') : null;

    if (form && submit) {
        form.addEventListener('submit', function (e) {
            if (submit.dataset.sent === '1') {
                e.preventDefault();
                return;
            }
            submit.dataset.sent = '1';
            submit.classList.add('is-busy');
        });

        window.addEventListener('pageshow', function () {
            submit.dataset.sent = '';
            submit.classList.remove('is-busy');
        });
    }

    var popup = document.getElementById('popup');

    if (popup) {
        var timer = setTimeout(closePopup, 8000);

        function closePopup() {
            clearTimeout(timer);
            popup.classList.add('is-closing');
            setTimeout(function () {
                if (popup.parentNode) popup.parentNode.removeChild(popup);
            }, 300);
        }

        popup.querySelector('.popup-close').addEventListener('click', closePopup);
    }
})();
</script>
</body>
</html>
