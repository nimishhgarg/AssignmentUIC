<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="app.Config, app.Database.Student" %>
<%
    String ctx = request.getContextPath();
    String csrf = (String) request.getAttribute("csrf");
    String current = "worksheet";
    Student student = (Student) request.getAttribute("student");
    String sName = student == null ? "" : student.name;
    String sUid = student == null ? "" : student.uid;
    String sBranch = student == null ? "" : student.branch;
    String sSemester = student == null ? "" : student.semester;
    String sSection = student == null ? "" : student.section;
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Create Worksheet</title>
<link rel="stylesheet" href="<%= ctx %>/assets/css/fonts.css">
<link rel="stylesheet" href="<%= ctx %>/assets/css/header.css">
  <link rel="stylesheet" href="<%= ctx %>/assets/css/worksheet.css" type="text/css" media="all">

  <style>

    .settings {
      flex-direction: column;
      overflow: hidden;
    }

    .settings-fixed {
      flex-shrink: 0;
    }

    .settings-scroll {
      flex: 1;
      min-height: 0;
      overflow-y: auto;
      padding-bottom: 24px;
    }

    .modal-overlay {
      position: fixed;
      inset: 0;
      background-color: rgba(11, 16, 32, 0.55);
      z-index: 998;
    }

    .modal-overlay[hidden],
    .download-modal[hidden] {
      display: none;
    }

    .download-modal {
      background-color: white;
      position: fixed;
      width: 94%;
      max-width: 420px;
      margin: 0;
      box-sizing: border-box;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      border-radius: 10px;
      padding: 15px 10px;
      z-index: 999;
    }

    .modal-close {
      display: flex;
      align-items: flex-end;
      justify-content: flex-end;
    }

    .modal-close-btn {
      display: flex;
      padding: 0;
      border: 0;
      background: none;
      cursor: pointer;
    }

    .modal-title {
      font-size: 22px;
      text-align: center;
      margin: 0;
    }

    .modal-text {
      text-align: center;
      margin-top: 1px;
    }

    .download-img {
      background-color: #F5EEFF;
      width: 70px;
      height: 70px;
      border-radius: 100%;
      align-items: center;
      justify-content: center;
      display: flex;
      margin: 0 auto 10px;
    }

    .download-img.success {
      background-color: #ECFDF5;
    }

    .progress-row {
      display: flex;
      align-items: center;
      gap: 10px;
      width: 90%;
      margin: 6px 5% 10px;
    }

    .progressbar {
      background-color: #F5EEFF;
      width: 100%;
      margin: 0;
      height: 8px;
      border-radius: 30px;
      border: none;
      overflow: hidden;
    }

    .progress-fill {
      background-color: #9333EA;
      height: 100%;
      width: 0;
      border-radius: 30px;
      transition: width 0.4s ease;
    }

    .progress-value {
      margin: 0;
      font-family: uicbold;
      min-width: 36px;
      text-align: right;
    }

    .downloadprogress {
      width: 96%;
      margin: 0 2%;
      border-radius: 10px;
      padding: 10px;
      background-color: #F5EEFF;
      box-sizing: border-box;
    }

    .progress-step {
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .progress-step + .progress-step {
      margin-top: 5px;
    }

    .progress-icon {
      width: 24px;
      height: 24px;
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0;
    }

    .progress-dot {
      background-color: #888888;
      width: 10px;
      height: 10px;
      border-radius: 100%;
    }

    .progress-step.is-active .progresstext,
    .progress-step.is-done .progresstext {
      color: #0B1020;
    }

    .progresstext {
      font-family: uic;
      margin: 0;
      font-size: 13px;
      color: #888888;
    }

    .uic-loader {
      width: 24px;
      height: 24px;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 3px;
      flex-shrink: 0;
    }

    .uic-loader span {
      width: 5px;
      height: 5px;
      flex: 0 0 5px;
      border-radius: 50%;
      background: #9333EA;
      animation: uic-dot 1s infinite ease-in-out;
    }

    .uic-loader span:nth-child(2) {
      animation-delay: 0.15s;
    }

    .uic-loader span:nth-child(3) {
      animation-delay: 0.3s;
    }

    @keyframes uic-dot {
      0%, 60%, 100% {
        opacity: 0.3;
        transform: translateY(0);
      }
      30% {
        opacity: 1;
        transform: translateY(-4px);
      }
    }

    @media (prefers-reduced-motion: reduce) {
      .uic-loader span {
        animation: none;
        opacity: 1;
      }

      .progress-fill {
        transition: none;
      }
    }

    .modal-actions {
      display: flex;
      align-items: center;
      gap: 6px;
      margin-top: 10px;
    }

    .download-btn {
      background-color: #F5EEFF;
      padding: 12px;
      color: #9333EA;
      font-family: uicbold;
      font-size: 13px;
      display: flex;
      align-items: center;
      gap: 6px;
      width: 100%;
      border: 0;
      border-radius: 10px;
      justify-content: center;
      cursor: pointer;
    }

    .download-btn.primary {
      background-color: #2563EB;
      color: white;
    }

    .download-btn[hidden] {
      display: none;
    }
  </style>
</head>

<body>
<%@ include file="header.jspf" %>

  <div class="background" id="bg"></div>

  <div class="settings" id="settings">

    <div class="settings-fixed">
      <div class="bar"></div>

      <div class="settings-head">
        <div class="settings-head-left">
          <div class="settings-icon">
            <svg xmlns="http://www.w3.org/2000/svg" width="35" height="35" viewBox="0 0 24 24" fill="none" stroke="#A855F7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M3 19a9 9 0 0 1 9 0a9 9 0 0 1 9 0"></path>
              <path d="M3 6a9 9 0 0 1 9 0a9 9 0 0 1 9 0"></path>
              <path d="M3 6l0 13"></path>
              <path d="M12 6l0 13"></path>
              <path d="M21 6l0 13"></path>
            </svg>
          </div>
          <div>
            <p class="prompt-heading" style="font-size: 18px;">Choose Subject</p>
            <p class="text-field" style="margin: 0; font-size: 11px;">Select a subject from your course to generate the worksheet.</p>
          </div>
        </div>

        <div class="settings-close" id="settings-close">
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="currentColor"><path d="M6.707 5.293l5.293 5.292l5.293 -5.292a1 1 0 0 1 1.414 1.414l-5.292 5.293l5.292 5.293a1 1 0 0 1 -1.414 1.414l-5.293 -5.292l-5.293 5.292a1 1 0 1 1 -1.414 -1.414l5.292 -5.293l-5.292 -5.293a1 1 0 0 1 1.414 -1.414"></path></svg>
        </div>
      </div>

      <div class="subject-search">
        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#888888" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 10a7 7 0 1 0 14 0a7 7 0 1 0 -14 0"></path><path d="M21 21l-6 -6"></path></svg>
        <input type="text" id="search-subject" placeholder="Search By Subject Name or Code" autocomplete="off">
      </div>
    </div>

    <div class="settings-scroll">
      <div class="subject-list" id="subject-list"></div>

      <template id="subject-template">
        <div class="box-data">
          <div class="subject-row">
            <div class="subject-row-info">
              <svg xmlns="http://www.w3.org/2000/svg" width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="#A855F7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M3 19a9 9 0 0 1 9 0a9 9 0 0 1 9 0"></path>
                <path d="M3 6a9 9 0 0 1 9 0a9 9 0 0 1 9 0"></path>
                <path d="M3 6l0 13"></path>
                <path d="M12 6l0 13"></path>
                <path d="M21 6l0 13"></path>
              </svg>
              <p class="box-body">
                <span class="subject-name"></span><br>
                <span class="subject-code"></span>
              </p>
            </div>
            <div class="subject-delete">
              <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#DC2626" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="pointer-events: none;"><path d="M4 7l16 0"></path><path d="M10 11l0 6"></path><path d="M14 11l0 6"></path><path d="M5 7l1 12a2 2 0 0 0 2 2h8a2 2 0 0 0 2 -2l1 -12"></path><path d="M9 7v-3a1 1 0 0 1 1 -1h4a1 1 0 0 1 1 1v3"></path></svg>
            </div>
          </div>
        </div>
      </template>

      <div class="prompt-order" id="add-section-btn">
        <div style="display: flex; align-items: center; gap: 6px;">
          <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 5l0 14"></path><path d="M5 12l14 0"></path></svg>
          <p class="prompt-order-head">Add New Subject</p>
        </div>
      </div>

      <div id="add-section" style="display: none;">
        <p class="prompt-heading" style="font-size: 15px; margin-top: 15px;">Add New Subject</p>
        <p class="text-field" style="margin: 0; font-size: 11px;">Add your own subject to include in the worksheet.</p>

        <div class="add-field">
          <div class="add-field-icon">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 3v4a1 1 0 0 0 1 1h4"></path><path d="M17 21h-10a2 2 0 0 1 -2 -2v-14a2 2 0 0 1 2 -2h7l5 5v11a2 2 0 0 1 -2 2"></path><path d="M9 17h6"></path><path d="M9 13h6"></path></svg>
          </div>
          <input type="text" id="new-subject-name" placeholder="Enter subject name" autocomplete="off">
        </div>

        <div class="add-field">
          <div class="add-field-icon">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 3v4a1 1 0 0 0 1 1h4"></path><path d="M17 21h-10a2 2 0 0 1 -2 -2v-14a2 2 0 0 1 2 -2h7l5 5v11a2 2 0 0 1 -2 2"></path><path d="M9 17h6"></path><path d="M9 13h6"></path></svg>
          </div>
          <input type="text" id="new-subject-code" placeholder="Enter subject code" autocomplete="off">
        </div>

        <div class="add-buttons">
          <div class="prompt-order cancel" id="add-section-cancel">
            <p class="prompt-order-head">Cancel</p>
          </div>
          <div class="prompt-order" id="add-section-confirm">
            <p class="prompt-order-head">Add Subject</p>
          </div>
        </div>
      </div>
    </div>

  </div>

  <div class="back" id="back-btn">
    <div class="home-img">
      <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#A855F7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M5 12l-2 0l9 -9l9 9l-2 0" />
        <path d="M5 12v7a2 2 0 0 0 2 2h10a2 2 0 0 0 2 -2v-7" />
        <path d="M9 21v-6a2 2 0 0 1 2 -2h2a2 2 0 0 1 2 2v6" />
      </svg>
    </div>
    <p class="back-text" style="display: flex;">&nbsp;&nbsp;/&nbsp;&nbsp;Create Worksheet</p>
  </div>

  <h1>Create <br><span style="color: #A855F7;">Worksheet</span></h1>
  <p class="text-field">Review your details carefully, select the appropriate options, and generate a well-structured worksheet in seconds.</p>

  <div class="box">
    <div style="display: flex; align-items: center; justify-content: space-between;">
      <div class="box-head">
        <div class="box-img">
          <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="white">
            <path d="M12 2a5 5 0 1 1 -5 5l.005 -.217a5 5 0 0 1 4.995 -4.783z" />
            <path d="M14 14a5 5 0 0 1 5 5v1a2 2 0 0 1 -2 2h-10a2 2 0 0 1 -2 -2v-1a5 5 0 0 1 5 -5h4z" />
          </svg>
        </div>
        <p class="box-heading">Your Information</p>
      </div>
      <div class="help" style="display: flex; align-items: center; gap: 2px;" onclick="location.href='<%= ctx %>/settings'">
        <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <path d="M4 20h4l10.5 -10.5a2.828 2.828 0 1 0 -4 -4l-10.5 10.5v4" />
          <path d="M13.5 6.5l4 4" />
        </svg>
        <span>Update Info</span>
      </div>
    </div>
    <div class="box-data">
      <p class="box-body"><%= Config.esc(Config.show(sName)) %> <br>
        <span style="font-size: 10px; color: #888888;">UID: <%= Config.esc(Config.show(sUid)) %>&nbsp;&nbsp; <span style="color: black;">|</span>&nbsp;&nbsp;<%= Config.esc(Config.show(sBranch)) %>&nbsp;&nbsp; <span style="color: black;">|</span>&nbsp;&nbsp;Sem: <%= Config.esc(Config.show(sSemester)) %>&nbsp;&nbsp; <span style="color: black;">|</span>&nbsp;&nbsp;Section: <%= Config.esc(Config.show(sSection)) %></span>
      </p>
    </div>
  </div>

  <div class="box">
    <div class="box-head">
      <div class="box-img">
        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="white">
          <path d="M21.5 5.134a1 1 0 0 1 .493 .748l.007 .118v13a1 1 0 0 1 -1.5 .866a8 8 0 0 0 -7.5 -.266v-15.174a10 10 0 0 1 8.5 .708m-10.5 -.707l.001 15.174a8 8 0 0 0 -7.234 .117l-.327 .18l-.103 .044l-.049 .016l-.11 .026l-.061 .01l-.117 .006h-.042l-.11 -.012l-.077 -.014l-.108 -.032l-.126 -.056l-.095 -.056l-.089 -.067l-.06 -.056l-.073 -.082l-.064 -.089l-.022 -.036l-.032 -.06l-.044 -.103l-.016 -.049l-.026 -.11l-.01 -.061l-.004 -.049l-.002 -13.068a1 1 0 0 1 .5 -.866a10 10 0 0 1 8.5 -.707" />
        </svg>
      </div>
      <p class="box-heading">Subject Selection</p>
    </div>
    <div class="box-data" id="subject-box">
      <div class="subject-row">
        <div class="subject-row-info">
          <svg xmlns="http://www.w3.org/2000/svg" width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="#A855F7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M3 19a9 9 0 0 1 9 0a9 9 0 0 1 9 0" />
            <path d="M3 6a9 9 0 0 1 9 0a9 9 0 0 1 9 0" />
            <path d="M3 6l0 13" />
            <path d="M12 6l0 13" />
            <path d="M21 6l0 13" />
          </svg>
          <p class="box-body">
            <span id="selected-subject-name">Choose Subject</span><br>
            <span class="subject-code" id="selected-subject-code">Select a subject from your course to generate worksheet.</span>
          </p>
        </div>
        <div class="subject-arrow" id="subject-arrow">
          <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="3" stroke="#A855F7" class="size-6" width="16" height="16">
            <path stroke-linecap="round" stroke-linejoin="round" d="m8.25 4.5 7.5 7.5-7.5 7.5"></path>
          </svg>
        </div>
      </div>
    </div>
  </div>

  <div class="box">
    <div class="box-head">
      <div class="box-img">
        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="white">
          <path d="M16 2c.183 0 .355 .05 .502 .135l.033 .02c.28 .177 .465 .49 .465 .845v1h1a3 3 0 0 1 2.995 2.824l.005 .176v12a3 3 0 0 1 -2.824 2.995l-.176 .005h-12a3 3 0 0 1 -2.995 -2.824l-.005 -.176v-12a3 3 0 0 1 2.824 -2.995l.176 -.005h1v-1a1 1 0 0 1 .514 -.874l.093 -.046l.066 -.025l.1 -.029l.107 -.019l.12 -.007q .083 0 .161 .013l.122 .029l.04 .012l.06 .023c.328 .135 .568 .44 .61 .806l.007 .117v1h6v-1a1 1 0 0 1 1 -1m3 7h-14v9.625c0 .705 .386 1.286 .883 1.366l.117 .009h12c.513 0 .936 -.53 .993 -1.215l.007 -.16z" />
        </svg>
      </div>
      <p class="box-heading">Worksheet Details</p>
    </div>

    <div class="box-data" style="padding: 2px 10px;">
      <p class="box-data-head">Worksheet Title</p>
      <div style="display: flex; align-items: center; gap: 10px;">
        <svg xmlns="http://www.w3.org/2000/svg" width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="#A855F7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 12a9 9 0 1 0 18 0a9 9 0 0 0 -18 0" /><path d="M3.6 9h16.8" /><path d="M3.6 15h16.8" /><path d="M11.5 3a17 17 0 0 0 0 18" /><path d="M12.5 3a17 17 0 0 1 0 18" /></svg>
        <input type="text" id="worksheet-number" placeholder="e.g. WORKSHEET 1.1" autocomplete="off">
      </div>
    </div>

    <div class="box-data" style="padding: 2px 10px;">
      <p class="box-data-head">Date of Performance</p>
      <div style="display: flex; align-items: center; gap: 10px;">
        <svg xmlns="http://www.w3.org/2000/svg" width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="#A855F7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <path d="M4 7a2 2 0 0 1 2 -2h12a2 2 0 0 1 2 2v12a2 2 0 0 1 -2 2h-12a2 2 0 0 1 -2 -2v-12" />
          <path d="M16 3v4" /><path d="M8 3v4" /><path d="M4 11h16" />
          <path d="M7 14h.013" /><path d="M10.01 14h.005" /><path d="M13.01 14h.005" /><path d="M16.015 14h.005" />
          <path d="M13.015 17h.005" /><path d="M7.01 17h.005" /><path d="M10.01 17h.005" />
        </svg>
        <input type="text" id="worksheet-date" placeholder="Date of Performance (e.g. 07-09-2026)" autocomplete="off">
      </div>
    </div>
  </div>

  <div class="box">
    <div class="box-head">
      <div class="box-img">
        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="white">
          <path d="M12 2l.117 .007a1 1 0 0 1 .876 .876l.007 .117v4l.005 .15a2 2 0 0 0 1.838 1.844l.157 .006h4l.117 .007a1 1 0 0 1 .876 .876l.007 .117v9a3 3 0 0 1 -2.824 2.995l-.176 .005h-10a3 3 0 0 1 -2.995 -2.824l-.005 -.176v-14a3 3 0 0 1 2.824 -2.995l.176 -.005zm3 14h-6a1 1 0 0 0 0 2h6a1 1 0 0 0 0 -2m0 -4h-6a1 1 0 0 0 0 2h6a1 1 0 0 0 0 -2" />
          <path d="M19 7h-4l-.001 -4.001z" />
        </svg>
      </div>
      <p class="box-heading">Worksheet Content</p>
    </div>
    <div class="optcontent">
      <div class="headingopt">
        <span>Worksheet Content</span>
        <div class="help" id="paste-btn" style="display: flex; align-items: center; gap: 2px;">
          <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M9 5h-2a2 2 0 0 0 -2 2v12a2 2 0 0 0 2 2h10a2 2 0 0 0 2 -2v-12a2 2 0 0 0 -2 -2h-2" />
            <path d="M9 5a2 2 0 0 1 2 -2h2a2 2 0 0 1 2 2a2 2 0 0 1 -2 2h-2a2 2 0 0 1 -2 -2" />
            <path d="M9 12h6" /><path d="M9 16h6" />
          </svg>
          <span>Paste</span>
        </div>
      </div>
      <textarea id="worksheet-content" placeholder="Paste Worksheet Generated Raw Data."></textarea>
    </div>
  </div>

  <div class="box">
    <div class="box-head">
      <div class="box-img">
        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M15 12h.01" /><path d="M12 12h.01" /><path d="M9 12h.01" /><path d="M6 19a2 2 0 0 1 -2 -2v-4l-1 -1l1 -1v-4a2 2 0 0 1 2 -2" /><path d="M18 19a2 2 0 0 0 2 -2v-4l1 -1l-1 -1v-4a2 2 0 0 0 -2 -2" /></svg>
      </div>
      <p class="box-heading">Output Format</p>
    </div>
    <div class="box-choose">
      <div class="boxopt" data-group="output" data-value="Terminal">
        <div style="display: flex; align-items: flex-start; gap: 7px;">
          <div style="padding-top: 4px;">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#555555" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M8 9l3 3l-3 3" /><path d="M13 15l3 0" /><path d="M3 6a2 2 0 0 1 2 -2h14a2 2 0 0 1 2 2v12a2 2 0 0 1 -2 2h-14a2 2 0 0 1 -2 -2l0 -12" /></svg>
          </div>
          <div>
            <p class="choosehead">Terminal</p>
            <p class="choosebody">Console Format</p>
          </div>
        </div>
      </div>

      <div class="boxopt" data-group="output" data-value="Written">
        <div style="display: flex; align-items: flex-start; gap: 7px;">
          <div style="padding-top: 4px;">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#FF3535" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M6 4h11a2 2 0 0 1 2 2v12a2 2 0 0 1 -2 2h-11a1 1 0 0 1 -1 -1v-14a1 1 0 0 1 1 -1m3 0v18" /><path d="M13 8l2 0" /><path d="M13 12l2 0" /></svg>
          </div>
          <div>
            <p class="choosehead">Written</p>
            <p class="choosebody">Document format</p>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div class="box">
    <div class="box-head">
      <div class="box-img">
        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="white">
          <path d="M20 16a1 1 0 0 1 1 1v2a3 3 0 0 1 -3 3h-12a3 3 0 0 1 -3 -3v-2a1 1 0 0 1 2 0v2a1 1 0 0 0 1 1h12a1 1 0 0 0 1 -1v-2a1 1 0 0 1 1 -1m-8 -13a1 1 0 0 1 1 1v9.585l3.293 -3.292a1 1 0 0 1 1.414 1.414l-5 5a1 1 0 0 1 -.09 .08l.09 -.08a1 1 0 0 1 -.674 .292l-.033 .001h-.032l-.054 -.004l.086 .004a1 1 0 0 1 -.617 -.213a1 1 0 0 1 -.09 -.08l-5 -5a1 1 0 0 1 1.414 -1.414l3.293 3.292v-9.585a1 1 0 0 1 1 -1" />
        </svg>
      </div>
      <p class="box-heading">Generate Worksheet</p>
    </div>
    <div class="box-choose">
      <div class="boxopt" data-group="generate" data-value="DOCX">
        <div style="display: flex; align-items: flex-start; gap: 7px;">
          <div style="padding-top: 4px;">
            <img src="<%= ctx %>/assets/img/docx.webp" class="outputimg" alt="DOCX">
          </div>
          <div>
            <p class="choosehead">DOCX</p>
            <p class="choosebody">Editable Document</p>
          </div>
        </div>
      </div>

      <div class="boxopt" data-group="generate" data-value="PDF">
        <div style="display: flex; align-items: flex-start; gap: 7px;">
          <div style="padding-top: 4px;">
            <img src="<%= ctx %>/assets/img/pdf.webp" class="outputimg" alt="PDF">
          </div>
          <div>
            <p class="choosehead">PDF</p>
            <p class="choosebody">Read-Only Document</p>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div class="btn" id="generate-btn">
    <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
      <path d="M6 21l15 -15l-3 -3l-15 15l3 3"></path>
      <path d="M15 6l3 3"></path>
      <path d="M9 3a2 2 0 0 0 2 2a2 2 0 0 0 -2 2a2 2 0 0 0 -2 -2a2 2 0 0 0 2 -2"></path>
      <path d="M19 13a2 2 0 0 0 2 2a2 2 0 0 0 -2 2a2 2 0 0 0 -2 -2a2 2 0 0 0 2 -2"></path>
    </svg>
    <span id="generate-label">Generate Worksheet</span>
    <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
      <path d="M5 12l14 0" />
      <path d="M15 16l4 -4" />
      <path d="M15 8l4 4" />
    </svg>
  </div>

  <div class="modal-overlay" id="modal-overlay" hidden></div>

  <div class="download-modal" id="generating-modal" role="dialog" aria-modal="true" aria-labelledby="generating-title" hidden>

    <div class="modal-close">
      <button type="button" class="modal-close-btn" id="generating-close" aria-label="Cancel">
        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="#888888"><path stroke="none" d="M0 0h24v24H0z" fill="none"></path><path d="M6.707 5.293l5.293 5.292l5.293 -5.292a1 1 0 0 1 1.414 1.414l-5.292 5.293l5.292 5.293a1 1 0 0 1 -1.414 1.414l-5.293 -5.292l-5.293 5.292a1 1 0 1 1 -1.414 -1.414l5.292 -5.293l-5.292 -5.293a1 1 0 0 1 1.414 -1.414"></path></svg>
      </button>
    </div>

    <div class="download-img">
      <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="#9333EA" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path stroke="none" d="M0 0h24v24H0z" fill="none" /><path d="M14 3v4a1 1 0 0 0 1 1h4" /><path d="M17 21h-10a2 2 0 0 1 -2 -2v-14a2 2 0 0 1 2 -2h7l5 5v11a2 2 0 0 1 -2 2" /><path d="M9 17h6" /><path d="M9 13h6" /></svg>
    </div>

    <h1 class="modal-title" id="generating-title">Generating Worksheet</h1>
    <p class="text-field modal-text">Please wait while we create your worksheet...</p>

    <div class="progress-row">
      <div class="progressbar" role="progressbar" id="progress-track" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0">
        <div class="progress-fill" id="progress-fill"></div>
      </div>
      <p class="text-field progress-value" id="progress-value">0%</p>
    </div>

    <div class="downloadprogress" id="progress-steps">
      <div class="progress-step" data-step="0">
        <span class="progress-icon"></span>
        <p class="progresstext">Sending Payload To Server</p>
      </div>
      <div class="progress-step" data-step="1">
        <span class="progress-icon"></span>
        <p class="progresstext">Processing Content</p>
      </div>
      <div class="progress-step" data-step="2">
        <span class="progress-icon"></span>
        <p class="progresstext" id="progress-file-label">Creating PDF File</p>
      </div>
      <div class="progress-step" data-step="3">
        <span class="progress-icon"></span>
        <p class="progresstext">Finalizing...</p>
      </div>
    </div>

  </div>

  <div class="download-modal" id="result-modal" role="dialog" aria-modal="true" aria-labelledby="result-title" hidden>

    <div class="modal-close">
      <button type="button" class="modal-close-btn" id="result-close" aria-label="Close">
        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="#888888"><path stroke="none" d="M0 0h24v24H0z" fill="none"></path><path d="M6.707 5.293l5.293 5.292l5.293 -5.292a1 1 0 0 1 1.414 1.414l-5.292 5.293l5.292 5.293a1 1 0 0 1 -1.414 1.414l-5.293 -5.292l-5.293 5.292a1 1 0 1 1 -1.414 -1.414l5.292 -5.293l-5.292 -5.293a1 1 0 0 1 1.414 -1.414"></path></svg>
      </button>
    </div>

    <div class="download-img success">
      <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 24 24" fill="#16A34A"><path stroke="none" d="M0 0h24v24H0z" fill="none" /><path d="M20.707 6.293a1 1 0 0 1 0 1.414l-10 10a1 1 0 0 1 -1.414 0l-5 -5a1 1 0 0 1 1.414 -1.414l4.293 4.293l9.293 -9.293a1 1 0 0 1 1.414 0" /></svg>
    </div>

    <h1 class="modal-title" id="result-title">Worksheet Ready!</h1>
    <p class="text-field modal-text">Your worksheet has been generated successfully.</p>

    <div class="box-data">
      <div class="subject-row">
        <div class="subject-row-info">
          <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="#9333EA" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path stroke="none" d="M0 0h24v24H0z" fill="none" /><path d="M14 3v4a1 1 0 0 0 1 1h4" /><path d="M17 21h-10a2 2 0 0 1 -2 -2v-14a2 2 0 0 1 2 -2h7l5 5v11a2 2 0 0 1 -2 2" /><path d="M9 17h6" /><path d="M9 13h6" /></svg>
          <p class="box-body">
            <span id="result-file-name"></span><br>
            <span class="subject-code" id="result-file-meta"></span>
          </p>
        </div>
      </div>
    </div>

    <div class="modal-actions">
      <button type="button" class="download-btn" id="preview-btn">
        <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path stroke="none" d="M0 0h24v24H0z" fill="none" /><path d="M10 12a2 2 0 1 0 4 0a2 2 0 0 0 -4 0" /><path d="M21 12c-2.4 4 -5.4 6 -9 6c-3.6 0 -6.6 -2 -9 -6c2.4 -4 5.4 -6 9 -6c3.6 0 6.6 2 9 6" /></svg>
        <span>Preview</span>
      </button>

      <button type="button" class="download-btn primary" id="download-btn">
        <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="currentColor"><path stroke="none" d="M0 0h24v24H0z" fill="none" /><path d="M20 16a1 1 0 0 1 1 1v2a3 3 0 0 1 -3 3h-12a3 3 0 0 1 -3 -3v-2a1 1 0 0 1 2 0v2a1 1 0 0 0 1 1h12a1 1 0 0 0 1 -1v-2a1 1 0 0 1 1 -1m-8 -13a1 1 0 0 1 1 1v9.585l3.293 -3.292a1 1 0 0 1 1.414 1.414l-5 5a1 1 0 0 1 -.09 .08l.09 -.08a1 1 0 0 1 -.674 .292l-.033 .001h-.032l-.054 -.004l.086 .004a1 1 0 0 1 -.617 -.213a1 1 0 0 1 -.09 -.08l-5 -5a1 1 0 0 1 1.414 -1.414l3.293 3.292v-9.585a1 1 0 0 1 1 -1" /></svg>
        <span>Download</span>
      </button>
    </div>

  </div>

  <script src="<%= ctx %>/assets/js/popup.js"></script>
  <script>
    (function () {
      'use strict';

      var CONFIG = <%= request.getAttribute("configJson") %>;
      var student = <%= request.getAttribute("studentJson") %>;
      var dbSubjects = <%= request.getAttribute("subjectsJson") %>;

      var DEFAULT_NAME = 'Choose Subject';
      var DEFAULT_TEXT = 'Select a subject from your course to generate worksheet.';
      var FILENAME_PATTERN = /^[A-Za-z0-9._-]+$/;
      var PROGRESS_BY_STAGE = [10, 30, 75, 92, 100];

      var ICON_DONE = '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="#9333EA"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M17 3.34a10 10 0 1 1 -14.995 8.984l-.005 -.324l.005 -.324a10 10 0 0 1 14.995 -8.336zm-1.293 5.953a1 1 0 0 0 -1.32 -.083l-.094 .083l-3.293 3.292l-1.293 -1.292l-.094 -.083a1 1 0 0 0 -1.403 1.403l.083 .094l2 2l.094 .083a1 1 0 0 0 1.226 0l.094 -.083l4 -4l.083 -.094a1 1 0 0 0 -.083 -1.32z"/></svg>';
      var ICON_ACTIVE = '<div class="uic-loader" role="status" aria-label="Loading"><span></span><span></span><span></span></div>';
      var ICON_PENDING = '<div class="progress-dot"></div>';

      var state = {
        customSubjects: [],
        selectedSubject: null,
        options: { output: '', generate: '' },
        busy: false,
        controller: null,
        cancelled: false,
        creepTimer: null,
        progress: 0,
        file: null
      };

      var $ = function (id) { return document.getElementById(id); };

      var el = {
        background: $('bg'),
        settings: $('settings'),
        settingsClose: $('settings-close'),
        addSection: $('add-section'),
        addSectionBtn: $('add-section-btn'),
        addConfirm: $('add-section-confirm'),
        addCancel: $('add-section-cancel'),
        list: $('subject-list'),
        template: $('subject-template'),
        search: $('search-subject'),
        newName: $('new-subject-name'),
        newCode: $('new-subject-code'),
        subjectBox: $('subject-box'),
        shownName: $('selected-subject-name'),
        shownCode: $('selected-subject-code'),
        arrow: $('subject-arrow'),
        title: $('worksheet-number'),
        date: $('worksheet-date'),
        content: $('worksheet-content'),
        paste: $('paste-btn'),
        back: $('back-btn'),
        generate: $('generate-btn'),
        generateLabel: $('generate-label'),
        overlay: $('modal-overlay'),
        generatingModal: $('generating-modal'),
        generatingClose: $('generating-close'),
        progressTrack: $('progress-track'),
        progressFill: $('progress-fill'),
        progressValue: $('progress-value'),
        progressSteps: document.querySelectorAll('#progress-steps .progress-step'),
        progressFileLabel: $('progress-file-label'),
        resultModal: $('result-modal'),
        resultClose: $('result-close'),
        resultName: $('result-file-name'),
        resultMeta: $('result-file-meta'),
        previewBtn: $('preview-btn'),
        downloadBtn: $('download-btn')
      };

      function notify(head, message) {
        if (typeof window.MyPopup === 'function') {
          window.MyPopup(head, message);
        }
      }

      function showSettings(visible) {
        el.background.style.display = visible ? 'block' : 'none';
        el.settings.style.display = visible ? 'flex' : 'none';

        if (visible) {
          el.search.value = '';
          showSection(false);
          renderList();
        }
      }

      function showSection(visible) {
        el.addSection.style.display = visible ? 'block' : 'none';
        el.addSectionBtn.style.display = visible ? 'none' : 'flex';
      }

      function allSubjects() {
        return dbSubjects.concat(state.customSubjects);
      }

      function updateSubjectView() {
        var subject = state.selectedSubject;

        if (subject) {
          el.shownName.textContent = subject.name;
          el.shownCode.textContent = 'Subject Code: ' + subject.code;
          el.arrow.style.display = 'flex';
          el.subjectBox.classList.add('selected');
        } else {
          el.shownName.textContent = DEFAULT_NAME;
          el.shownCode.textContent = DEFAULT_TEXT;
          el.arrow.style.display = 'none';
          el.subjectBox.classList.remove('selected');
        }
      }

      function renderList() {
        var query = el.search.value.trim().toLowerCase();
        el.list.innerHTML = '';

        var matches = allSubjects().filter(function (subject) {
          return subject.name.toLowerCase().indexOf(query) !== -1 ||
                 subject.code.toLowerCase().indexOf(query) !== -1;
        });

        if (!matches.length) {
          var empty = document.createElement('p');
          empty.className = 'empty-text';
          empty.textContent = 'No subjects found.';
          el.list.appendChild(empty);
          return;
        }

        matches.forEach(function (subject) {
          var node = el.template.content.firstElementChild.cloneNode(true);
          node.querySelector('.subject-name').textContent = subject.name;
          node.querySelector('.subject-code').textContent = 'Subject Code: ' + subject.code;
          node.dataset.code = subject.code;

          if (state.selectedSubject && state.selectedSubject.code === subject.code) {
            node.classList.add('selected');
          }
          if (!subject.custom) {
            node.querySelector('.subject-delete').style.display = 'none';
          }

          el.list.appendChild(node);
        });
      }

      function resetAddForm() {
        el.newName.value = '';
        el.newCode.value = '';
        showSection(false);
      }

      function addCustomSubject() {
        var name = el.newName.value.trim();
        var code = el.newCode.value.trim();

        if (!name || !code) {
          notify('Missing Details', 'Please enter both subject name and subject code.');
          return;
        }

        var exists = allSubjects().some(function (subject) {
          return subject.code.toLowerCase() === code.toLowerCase();
        });

        if (exists) {
          notify('Duplicate Subject', 'A subject with this code already exists.');
          return;
        }

        state.customSubjects.push({ name: name, code: code, custom: true });
        resetAddForm();
        renderList();
      }

      function handleListClick(event) {
        var row = event.target.closest('.box-data');
        if (!row) return;

        var code = row.dataset.code;

        if (event.target.closest('.subject-delete')) {
          state.customSubjects = state.customSubjects.filter(function (subject) {
            return subject.code !== code;
          });
          if (state.selectedSubject && state.selectedSubject.code === code) {
            state.selectedSubject = null;
          }
          updateSubjectView();
          renderList();
          return;
        }

        state.selectedSubject = allSubjects().filter(function (subject) {
          return subject.code === code;
        })[0] || null;

        updateSubjectView();
        showSettings(false);
      }

      function handleOptionClick(option) {
        var group = option.dataset.group;
        var value = option.dataset.value;
        var wasSelected = option.classList.contains('selected');

        document.querySelectorAll('.boxopt[data-group="' + group + '"]').forEach(function (other) {
          other.classList.remove('selected');
        });

        if (wasSelected) {
          state.options[group] = '';
        } else {
          option.classList.add('selected');
          state.options[group] = value;
        }
      }

      function pasteContent() {
        if (!navigator.clipboard || !navigator.clipboard.readText) {
          notify('Paste Unavailable', 'Clipboard access is not supported here. Please paste manually.');
          return;
        }

        navigator.clipboard.readText().then(function (text) {
          el.content.value = text;
        }).catch(function () {
          notify('Paste Failed', 'Clipboard access was denied. Please paste manually.');
        });
      }

      function buildPayload() {
        var s = student || {};

        return {
          student_details: {
            left: {
              'Student Name': s.name || '',
              'Branch': s.branch || '',
              'Semester': s.semester || '',
              'Subject Name': state.selectedSubject ? state.selectedSubject.name : '',
              'Subject Code': state.selectedSubject ? state.selectedSubject.code : ''
            },
            right: {
              'UID': s.uid || '',
              'Section/Group': s.section || '',
              'Date of Performance': el.date.value.trim()
            }
          },
          worksheet: {
            title: el.title.value.trim().toUpperCase(),
            output: state.options.output,
            generate: state.options.generate
          },
          content: el.content.value.trim()
        };
      }

      function validatePayload(data) {
        if (!data.student_details.left['Student Name']) {
          return { title: 'Session Expired', message: 'Student details not found. Please log in again.' };
        }
        if (!data.student_details.left['Subject Name']) {
          return { title: 'Subject Required', message: 'Please choose a subject.' };
        }
        if (!data.worksheet.title) {
          return { title: 'Title Required', message: 'Please enter the worksheet title.' };
        }
        if (!data.student_details.right['Date of Performance']) {
          return { title: 'Date Required', message: 'Please enter the date of performance.' };
        }
        if (!data.content) {
          return { title: 'Content Required', message: 'Please paste the worksheet content.' };
        }
        if (data.content.indexOf('assuic=[') !== 0 || data.content.slice(-1) !== ']') {
          return { title: 'Invalid Content', message: 'The content must start with assuic=[ and end with ]. Please paste the AI response again.' };
        }
        if (!data.worksheet.output) {
          return { title: 'Output Format Required', message: 'Please choose an output format.' };
        }
        if (!data.worksheet.generate) {
          return { title: 'File Type Required', message: 'Please choose DOCX or PDF.' };
        }
        return null;
      }

      function setGenerateBusy(busy) {
        el.generate.style.pointerEvents = busy ? 'none' : 'auto';
        el.generate.style.opacity = busy ? '0.7' : '1';
        el.generateLabel.textContent = busy ? 'Generating...' : 'Generate Worksheet';
      }

      function openModal(modal) {
        el.overlay.hidden = false;
        modal.hidden = false;
      }

      function closeModal(modal) {
        modal.hidden = true;
        if (el.generatingModal.hidden && el.resultModal.hidden) {
          el.overlay.hidden = true;
        }
      }

      function setProgress(value) {
        state.progress = value;
        el.progressFill.style.width = value + '%';
        el.progressValue.textContent = value + '%';
        el.progressTrack.setAttribute('aria-valuenow', String(value));
      }

      function setStage(stage) {
        stopCreep();

        Array.prototype.forEach.call(el.progressSteps, function (step, index) {
          var icon = step.querySelector('.progress-icon');
          step.classList.remove('is-done', 'is-active');

          if (index < stage) {
            icon.innerHTML = ICON_DONE;
            step.classList.add('is-done');
          } else if (index === stage) {
            icon.innerHTML = ICON_ACTIVE;
            step.classList.add('is-active');
          } else {
            icon.innerHTML = ICON_PENDING;
          }
        });

        setProgress(PROGRESS_BY_STAGE[stage]);

        if (stage === 1) startCreep(PROGRESS_BY_STAGE[2] - 5);
      }

      function startCreep(ceiling) {
        stopCreep();
        state.creepTimer = setInterval(function () {
          if (state.progress < ceiling) setProgress(state.progress + 1);
        }, 350);
      }

      function stopCreep() {
        if (state.creepTimer) {
          clearInterval(state.creepTimer);
          state.creepTimer = null;
        }
      }

      function endpoint(path) {
        return CONFIG.apiBase + path;
      }

      function extractError(result, status) {
        if (result && typeof result.detail === 'string') return result.detail;

        if (result && Array.isArray(result.detail) && result.detail.length) {
          return result.detail.map(function (item) {
            var where = Array.isArray(item.loc) ? item.loc.slice(1).join('.') : '';
            return (where ? where + ': ' : '') + (item.msg || 'Invalid value');
          }).join('\n');
        }

        if (result && result.message) return result.message;

        return 'Worksheet generation failed (HTTP ' + status + ').';
      }

      function releaseFile() {
        if (state.file && state.file.blobUrl) {
          URL.revokeObjectURL(state.file.blobUrl);
        }
        state.file = null;
      }

      function formatSize(bytes) {
        if (!bytes) return '';
        if (bytes < 1024 * 1024) return Math.max(1, Math.round(bytes / 1024)) + ' KB';
        return (bytes / (1024 * 1024)).toFixed(1) + ' MB';
      }

      function formatDate(date) {
        return date.toLocaleDateString('en-GB', { day: 'numeric', month: 'short', year: 'numeric' });
      }

      function fetchFile(filename, signal) {
        var url = endpoint(CONFIG.downloadPath) + encodeURIComponent(filename);

        return fetch(url, { signal: signal }).then(function (response) {
          if (!response.ok) throw new Error('File unavailable');
          return response.blob();
        }).then(function (blob) {
          return { url: url, blob: blob };
        }).catch(function (error) {
          if (error && error.name === 'AbortError') throw error;
          return { url: url, blob: null };
        });
      }

      function renderResult(file) {
        el.resultName.textContent = file.name;
        el.resultMeta.textContent = [file.kind, formatSize(file.size), file.date]
          .filter(Boolean)
          .join(' \u2022 ');
        el.previewBtn.hidden = file.kind !== 'PDF';
      }

      function previewFile() {
        if (!state.file) return;
        window.open(state.file.blobUrl || state.file.remoteUrl, '_blank', 'noopener');
      }

      function downloadFile() {
        if (!state.file) return;

        var link = document.createElement('a');
        link.href = state.file.blobUrl || state.file.remoteUrl;
        link.download = state.file.name;
        link.rel = 'noopener';
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
      }

      function delay(ms) {
        return new Promise(function (resolve) { setTimeout(resolve, ms); });
      }

      async function generateWorksheet() {
        if (state.busy) return;

        var payload = buildPayload();
        var problem = validatePayload(payload);

        if (problem) {
          notify(problem.title, problem.message);
          return;
        }

        var kind = payload.worksheet.generate;
        var controller = new AbortController();
        var timedOut = false;
        var timeout = setTimeout(function () {
          timedOut = true;
          controller.abort();
        }, CONFIG.timeoutMs);

        state.busy = true;
        state.cancelled = false;
        state.controller = controller;
        releaseFile();
        setGenerateBusy(true);

        el.progressFileLabel.textContent = 'Creating ' + kind + ' File';
        setStage(0);
        closeModal(el.resultModal);
        openModal(el.generatingModal);

        try {
          var request = fetch(endpoint(CONFIG.generatePath), {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload),
            signal: controller.signal
          });
          setStage(1);

          var response = await request;
          var result = await response.json().catch(function () { return null; });

          if (!response.ok) {
            throw new Error(extractError(result, response.status));
          }

          var filename = result && (kind === 'PDF' ? result.pdf : result.docx);
          filename = filename || (result && (result.pdf || result.docx));

          if (!filename || !FILENAME_PATTERN.test(filename)) {
            throw new Error('The server did not return a valid file name.');
          }

          setStage(2);
          var fetched = await fetchFile(filename, controller.signal);

          setStage(3);
          await delay(250);

          state.file = {
            name: filename,
            kind: filename.split('.').pop().toUpperCase(),
            size: fetched.blob ? fetched.blob.size : 0,
            date: formatDate(new Date()),
            remoteUrl: fetched.url,
            blobUrl: fetched.blob ? URL.createObjectURL(fetched.blob) : ''
          };

          setStage(4);
          await delay(350);

          renderResult(state.file);
          closeModal(el.generatingModal);
          openModal(el.resultModal);
        } catch (error) {
          closeModal(el.generatingModal);

          if (error && error.name === 'AbortError') {
            if (timedOut) {
              notify('Request Timed Out', 'The server took too long to respond. Please try again.');
            }
          } else if (error instanceof TypeError) {
            notify('Connection Error', 'Unable to reach the server. Check your connection and try again.');
          } else {
            notify('Generation Failed', error.message || 'Worksheet generation failed.');
          }
        } finally {
          clearTimeout(timeout);
          stopCreep();
          state.busy = false;
          state.controller = null;
          setGenerateBusy(false);
        }
      }

      function cancelGeneration() {
        if (state.controller) {
          state.cancelled = true;
          state.controller.abort();
        }
        closeModal(el.generatingModal);
      }

      el.background.addEventListener('click', function () { showSettings(false); });
      el.settingsClose.addEventListener('click', function () { showSettings(false); });
      el.subjectBox.addEventListener('click', function () { showSettings(true); });
      el.addSectionBtn.addEventListener('click', function () { showSection(true); });
      el.addConfirm.addEventListener('click', addCustomSubject);
      el.addCancel.addEventListener('click', resetAddForm);
      el.search.addEventListener('input', renderList);
      el.list.addEventListener('click', handleListClick);

      document.querySelectorAll('.boxopt').forEach(function (option) {
        option.addEventListener('click', function () { handleOptionClick(option); });
      });

      el.paste.addEventListener('click', pasteContent);
      el.back.addEventListener('click', function () { history.back(); });
      el.generate.addEventListener('click', generateWorksheet);

      el.generatingClose.addEventListener('click', cancelGeneration);
      el.resultClose.addEventListener('click', function () { closeModal(el.resultModal); });
      el.previewBtn.addEventListener('click', previewFile);
      el.downloadBtn.addEventListener('click', downloadFile);

      el.overlay.addEventListener('click', function () {
        if (!el.resultModal.hidden) closeModal(el.resultModal);
      });

      document.addEventListener('keydown', function (event) {
        if (event.key !== 'Escape') return;
        if (!el.resultModal.hidden) closeModal(el.resultModal);
        else if (!el.generatingModal.hidden) cancelGeneration();
      });

      window.addEventListener('beforeunload', releaseFile);

      updateSubjectView();
    })();
  </script>
</body>
</html>
