<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="app.Config" %>
<%
    String ctx = request.getContextPath();
    String csrf = (String) request.getAttribute("csrf");
    String popupTitle = (String) request.getAttribute("popupTitle");
    String popupBody = (String) request.getAttribute("popupBody");
    String email = (String) request.getAttribute("email");
    boolean hasError = popupBody != null && !popupBody.isEmpty();
%>
<!DOCTYPE html>
<html lang="en">
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">

<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Caveat:wght@500&display=swap" rel="stylesheet">
<script src="<%= ctx %>/assets/js/popup.js"></script>
<script>window.MyPopupTopOffset = 310;</script>
<title>AssignmentUIC</title>

<style>

@font-face {
    font-family: 'uic';
    src: url('<%= ctx %>/assets/fonts/poppins.ttf') format('truetype');
    font-weight: normal;
    font-style: normal;
    font-display: swap;
}

@font-face {
    font-family: 'uicbold';
    src: url('<%= ctx %>/assets/fonts/bold.ttf') format('truetype');
    font-weight: bold;
    font-style: normal;
    font-display: swap;
}

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

html, body {
    width: 100%;
    height: 100%;
    overflow-x: hidden;
}

body {
    min-height: 100vh;
    min-height: 100dvh;
    height: auto;
    position: relative;
    display: flex;
    align-items: center;
    justify-content: center;
    background: linear-gradient(180deg, #ffffff 0%, #faf7ff 100%);
    font-family: Inter, sans-serif;
    padding: 24px 0 40px;
}

.background {
    position: fixed;
    inset: 0;
    overflow: hidden;
    z-index: -3;
    pointer-events: none;
}

.background-overlay {
    position: fixed;
    inset: 0;
    z-index: -2;
    background: radial-gradient(circle at 50% 20%, rgba(255, 255, 255, 0.6), rgba(255, 255, 255, 0) 60%);
    pointer-events: none;
}

.blob {
    position: absolute;
    border-radius: 50%;
    filter: blur(100px);
}

.blob1 {
    width: clamp(220px, 40vw, 420px);
    height: clamp(220px, 40vw, 420px);
    background: #E9D5FF;
    left: -10vw;
    top: -10vh;
    opacity: .8;
}

.blob2 {
    width: clamp(240px, 45vw, 500px);
    height: clamp(240px, 45vw, 500px);
    background: #DDD6FE;
    right: -12vw;
    bottom: -10vh;
    opacity: .7;
}

.blob3 {
    width: clamp(140px, 20vw, 250px);
    height: clamp(140px, 20vw, 250px);
    background: #F3E8FF;
    top: 40%;
    left: 55%;
    opacity: .5;
}

.wave-top {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
}

.wave-bottom {
    position: absolute;
    bottom: 0;
    left: 0;
    width: 100%;
}

.star {
    position: absolute;
    background: #A855F7;
    opacity: .25;
    clip-path: polygon(
        50% 0%,
        60% 40%,
        100% 50%,
        60% 60%,
        50% 100%,
        40% 60%,
        0% 50%,
        40% 40%
    );
}

.star1 {
    width: 18px;
    height: 18px;
    right: 12%;
    top: 15%;
}

.star2 {
    width: 10px;
    height: 10px;
    right: 9%;
    top: 18%;
}

.star3 {
    width: 22px;
    height: 22px;
    left: 8%;
    bottom: 18%;
}

.doodle {
    position: absolute;
    font-family: 'Caveat', cursive;
    color: #B794F4;
    font-size: clamp(20px, 3vw, 34px);
    line-height: 1.1;
    opacity: .55;
    user-select: none;
    max-width: 44vw;
}

.doodle.top-left {
    top: 10%;
    left: 5%;
}

.doodle.top-right {
    top: 8%;
    right: 5%;
    text-align: right;
}

.doodle.bottom-left {
    bottom: 10%;
    left: 6%;
}

@media (max-width: 480px) {
    .doodle.top-right {
        display: none;
    }
}

.login-wrapper {
    width: 100%;
    max-width: 420px;
    padding: 0 20px;
    transform: translateY(-3%);
}

.brand {
    width: 100%;
    text-align: center;
}

.brand svg {
    display: block;
    margin: 0 auto;
}

.brand-title {
    color: black;
    font-family: uicbold;
    font-size: 25px;
    text-align: center;
    margin: 0;
    margin-top: -15px;
}

.brand-tagline {
    color: #888888;
    font-family: uic;
    font-size: 12px;
    margin: 0;
    text-align: center;
}

.login-card {
    width: 100%;
    background-color: white;
    padding: 15px 20px;
    margin-top: 30px;
    border-radius: 15px;
    box-shadow: rgba(0, 0, 0, 0.35) 0px 5px 15px;
}

.card-title {
    color: black;
    font-family: uicbold;
    font-size: 25px;
    text-align: center;
    margin: 0;
}

.card-subtitle {
    color: #888888;
    font-family: uic;
    font-size: 12px;
    margin: 0;
    text-align: center;
}

.field-label {
    font-family: uicbold;
    font-size: 13px;
    color: #333333;
    margin-top: 20px;
    text-align: left;
}

.field-input {
    background-color: white;
    width: 100%;
    box-sizing: border-box;
    padding: 0px 6px;
    display: flex;
    align-items: center;
    border-radius: 8px;
    margin-top: 2px;
    gap: 1px;
    border: 1px solid #444444;
}

.field-icon {
    background-color: #E9D5FF;
    width: 42px;
    height: 38px;
    display: flex;
    align-items: center;
    border-radius: 5px;
    justify-content: center;
}

input[type="text"],
input[type="email"],
input[type="password"] {
    padding: 14px 8px;
    border: none;
    width: 100%;
    font-size: 13px;
    color: black;
    font-family: uicbold;
    outline: none;
    box-shadow: none;
    -webkit-appearance: none;
}

input[type="submit"] {
    padding: 10px 8px;
    border: none;
    width: 100%;
    font-size: 16px;
    font-family: uicbold;
    border-radius: 10px;
    color: white;
    background-color: #A855F7;
    margin-top: 20px;
    cursor: pointer;
}

.alt-link {
    color: #888888;
    font-family: uic;
    font-size: 13px;
    text-align: center;
    margin-top: 14px;
    margin-bottom: 4px;
}

.alt-link a {
    color: #A855F7;
    font-family: uicbold;
    text-decoration: none;
}

</style>

</head>
<body>

<div class="background">

    <div class="blob blob1"></div>
    <div class="blob blob2"></div>
    <div class="blob blob3"></div>

    <svg class="wave-top" viewBox="0 0 1440 320" preserveAspectRatio="none">
        <path fill="#F7F2FF"
        d="M0,224L120,208C240,192,480,160,720,154.7C960,149,1200,171,1320,181.3L1440,192L1440,0L1320,0C1200,0,960,0,720,0C480,0,240,0,120,0L0,0Z">
        </path>
    </svg>

    <svg class="wave-bottom" viewBox="0 0 1440 320" preserveAspectRatio="none">
        <path fill="#FAF5FF"
        d="M0,160L120,170.7C240,181,480,203,720,218.7C960,235,1200,245,1320,240L1440,235L1440,320L1320,320C1200,320,960,320,720,320C480,320,240,320,120,320L0,320Z">
        </path>
    </svg>

    <div class="star star1"></div>
    <div class="star star2"></div>
    <div class="star star3"></div>

    <div class="doodle top-left">Your Worksheets<br>Simplified</div>
    <div class="doodle top-right">Fast.<br>Free.</div>
    <div class="doodle bottom-left">From Ideas<br>to Worksheets</div>

</div>

<div class="background-overlay"></div>

<div class="login-wrapper">
    <div class="brand">
        <svg xmlns="http://www.w3.org/2000/svg" width="120" height="120" viewBox="0 0 24 24" fill="#818CF8" class="icon icon-tabler icons-tabler-filled icon-tabler-school">
            <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
            <path d="M19 13.431v2.569c0 2.398 -3.205 4 -7 4s-7 -1.602 -7 -4v-2.569l5.886 2.354a3 3 0 0 0 2.011 .078l.217 -.078zm2 -2.955l-8.629 3.452a1 1 0 0 1 -.742 0l-10 -4c-.839 -.335 -.839 -1.521 0 -1.856l10 -4a1 1 0 0 1 .245 -.064l.126 -.008l.126 .008a1 1 0 0 1 .245 .064l10.032 4.013l.108 .055l.099 .068l.088 .076l.075 .082l.035 .044l.073 .115l.052 .115l.034 .102l.025 .135l.006 .058l.002 6.065a1 1 0 0 1 -2 0z"></path>
        </svg>

        <p class="brand-title">Assignment<span style="color: #818CF8;font-size: 28px;">UIC</span></p>

        <p class="brand-tagline">FAST&nbsp;&nbsp;&nbsp;&nbsp;•&nbsp;&nbsp;&nbsp;&nbsp;FREE&nbsp;&nbsp;&nbsp;&nbsp;•&nbsp;&nbsp;&nbsp;&nbsp;FOR LAZY GUYS</p>

        <div class="login-card">
            <p class="card-title">Create Account</p>
            <p class="card-subtitle">Register to start creating amazing worksheets.</p>

            <form method="post" action="">
                <input type="hidden" name="uic_register_nonce" value="<%= Config.esc(csrf) %>">

                <p class="field-label">Email Address</p>
                <div class="field-input">
                    <div class="field-icon">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#A855F7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="icon icon-tabler icons-tabler-outline icon-tabler-user-circle"><path stroke="none" d="M0 0h24v24H0z" fill="none" /><path d="M3 12a9 9 0 1 0 18 0a9 9 0 1 0 -18 0" /><path d="M9 10a3 3 0 1 0 6 0a3 3 0 1 0 -6 0" /><path d="M6.168 18.849a4 4 0 0 1 3.832 -2.849h4a4 4 0 0 1 3.834 2.855" /></svg>
                    </div>
                    <input type="email" name="email" placeholder="Enter your Email Address" autocomplete="email" value="<%= Config.esc(email) %>">
                </div>

                <p class="field-label" style="margin-top: 10px;">Create Password</p>
                <div class="field-input">
                    <div class="field-icon">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#A855F7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="icon icon-tabler icons-tabler-outline icon-tabler-lock"><path stroke="none" d="M0 0h24v24H0z" fill="none" /><path d="M5 13a2 2 0 0 1 2 -2h10a2 2 0 0 1 2 2v6a2 2 0 0 1 -2 2h-10a2 2 0 0 1 -2 -2v-6" /><path d="M11 16a1 1 0 1 0 2 0a1 1 0 0 0 -2 0" /><path d="M8 11v-4a4 4 0 1 1 8 0v4" /></svg>
                    </div>
                    <input type="password" name="password" placeholder="Create a password" autocomplete="new-password">
                </div>

                <p class="field-label" style="margin-top: 10px;">Confirm Password</p>
                <div class="field-input">
                    <div class="field-icon">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#A855F7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="icon icon-tabler icons-tabler-outline icon-tabler-lock"><path stroke="none" d="M0 0h24v24H0z" fill="none" /><path d="M5 13a2 2 0 0 1 2 -2h10a2 2 0 0 1 2 2v6a2 2 0 0 1 -2 2h-10a2 2 0 0 1 -2 -2v-6" /><path d="M11 16a1 1 0 1 0 2 0a1 1 0 0 0 -2 0" /><path d="M8 11v-4a4 4 0 1 1 8 0v4" /></svg>
                    </div>
                    <input type="password" name="confirm_password" placeholder="Confirm your password" autocomplete="new-password">
                </div>

                <input type="submit" name="uic_register_submit" value="Create Account">
            </form>

            <p class="alt-link">Already have an account? <a href="<%= ctx %>/login">Login</a></p>
        </div>
    </div>
</div>

<% if (hasError) { %>
<script>
    MyPopup('<%= Config.js(popupTitle) %>', '<%= Config.js(popupBody) %>');
</script>
<% } %>

</body>
</html>
