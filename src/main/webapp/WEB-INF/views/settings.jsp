<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="app.Config, app.Database.Student" %>
<%
    String ctx = request.getContextPath();
    String csrf = (String) request.getAttribute("csrf");
    String current = "settings";
    Student student = (Student) request.getAttribute("student");
    String[][] subjects = (String[][]) request.getAttribute("subjects");
    String subjectStatus = (String) request.getAttribute("subjectStatus");
    String[][] FIELDS = {
        {"name", "Student Name", "e.g. Nimish Garg"},
        {"uid", "Student UID", "e.g. 26MCI10253"},
        {"branch", "Branch", "e.g. MCA (AI ML)"},
        {"section", "Section/Group", "e.g. 26MAM-4B"},
        {"semester", "Semester", "e.g. 1"}
    };
%>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="<%= ctx %>/assets/css/settings.css" type="text/css" media="all"/>
    <script src="<%= ctx %>/assets/js/popup.js"></script>
    <title>Settings</title>
<link rel="stylesheet" href="<%= ctx %>/assets/css/fonts.css">
<link rel="stylesheet" href="<%= ctx %>/assets/css/header.css">
  </head>
  <body>
    <%@ include file="header.jspf" %>
    <div class="back" onclick="history.back()">
      <div class="home-img">
        <svg
          xmlns="http://www.w3.org/2000/svg"
          width="22"
          height="22"
          viewBox="0 0 24 24"
          fill="none"
          stroke="#A855F7"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
          class="icon icon-tabler icons-tabler-outline icon-tabler-home"
        >
          <path stroke="none" d="M0 0h24v24H0z" fill="none" />
          <path d="M5 12l-2 0l9 -9l9 9l-2 0" />
          <path d="M5 12v7a2 2 0 0 0 2 2h10a2 2 0 0 0 2 -2v-7" />
          <path d="M9 21v-6a2 2 0 0 1 2 -2h2a2 2 0 0 1 2 2v6" />
        </svg>
      </div>
      <p class="back-text" style="margin: 0; display: flex">&nbsp;&nbsp;/&nbsp;&nbsp;Settings</p>
    </div>

    <h1><span style="color: #a855f7">Settings</span></h1>
    <p class="text-field">
      Review and maintain your information carefully, as it is directly applied to generated worksheets.
    </p>

    <div class="menuoptset">
      <div class="setopt" id="profileopt" style="border-bottom: 2px solid #a855f7" onclick="DisplayData('profile');">
        Profile
      </div>
      <div class="setopt" id="subjectopt" onclick="DisplayData('subject');">Subjects</div>
    </div>

    <div class="profiletab" id="profile">
      <% for (String[] f : FIELDS) { String key = f[0]; String value = student.get(key); %>
      <div class="myprofile">
        <p class="profilelabel"><%= Config.esc(f[1]) %></p>

        <div class="box" id="field-<%= key %>">
          <span><%= !value.isEmpty() ? Config.esc(value) : "Not Set" %></span>
          <svg
            xmlns="http://www.w3.org/2000/svg"
            width="18"
            height="18"
            viewBox="0 0 24 24"
            fill="currentColor"
            class="icon icon-tabler icons-tabler-filled icon-tabler-pencil"
            onclick="toggleEdit('<%= key %>', 'edit');"
          >
            <path stroke="none" d="M0 0h24v24H0z" fill="none" />
            <path
              d="M12.085 6.5l5.415 5.415l-8.793 8.792a1 1 0 0 1 -.707 .293h-4a1 1 0 0 1 -1 -1v-4a1 1 0 0 1 .293 -.707zm5.406 -2.698a3.828 3.828 0 0 1 1.716 6.405l-.292 .293l-5.415 -5.415l.293 -.292a3.83 3.83 0 0 1 3.698 -.991"
            />
          </svg>
        </div>

        <div class="text-box-container" id="field-<%= key %>-edit">
          <input
            type="text"
            id="field-<%= key %>-input"
            placeholder="<%= Config.esc(f[2]) %>"
            value="<%= Config.esc(value) %>"
          />
          <div style="display: flex; align-items: center; gap: 12px">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              width="24"
              height="24"
              viewBox="0 0 24 24"
              fill="#A855F7"
              class="icon icon-tabler icons-tabler-filled icon-tabler-check"
              onclick="saveField('<%= key %>');"
            >
              <path stroke="none" d="M0 0h24v24H0z" fill="none" />
              <path
                d="M20.707 6.293a1 1 0 0 1 0 1.414l-10 10a1 1 0 0 1 -1.414 0l-5 -5a1 1 0 0 1 1.414 -1.414l4.293 4.293l9.293 -9.293a1 1 0 0 1 1.414 0"
              />
            </svg>
            <svg
              xmlns="http://www.w3.org/2000/svg"
              width="24"
              height="24"
              viewBox="0 0 24 24"
              fill="#A855F7"
              class="icon icon-tabler icons-tabler-filled icon-tabler-x"
              onclick="toggleEdit('<%= key %>', 'view');"
            >
              <path stroke="none" d="M0 0h24v24H0z" fill="none" />
              <path
                d="M6.707 5.293l5.293 5.292l5.293 -5.292a1 1 0 0 1 1.414 1.414l-5.292 5.293l5.292 5.293a1 1 0 0 1 -1.414 1.414l-5.293 -5.292l-5.293 5.292a1 1 0 1 1 -1.414 -1.414l5.292 -5.293l-5.292 -5.293a1 1 0 0 1 1.414 -1.414"
              />
            </svg>
          </div>
        </div>
      </div>
      <% } %>

    </div>
    <div class="subjecttab" id="subject">
      <% if ("ok".equals(subjectStatus)) { %>
      <p class="profilelabel" style="margin-left: 3%">My Course</p>
      <div class="box" style="margin: 0 3%; width: 94%; margin-bottom: 8px">
        <span><%= Config.esc(subjects[0][2]) %></span>
      </div>

      <p class="profilelabel" style="margin-left: 3%">My Subjects</p>
      <% for (String[] subject : subjects) { %>
      <div class="box-data">
        <div style="display: flex; align-items: center; gap: 10px">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            width="26"
            height="26"
            viewBox="0 0 24 24"
            fill="none"
            stroke="#A855F7"
            stroke-width="2"
            stroke-linecap="round"
            stroke-linejoin="round"
            class="icon icon-tabler icons-tabler-outline icon-tabler-book"
          >
            <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
            <path d="M3 19a9 9 0 0 1 9 0a9 9 0 0 1 9 0"></path>
            <path d="M3 6a9 9 0 0 1 9 0a9 9 0 0 1 9 0"></path>
            <path d="M3 6l0 13"></path>
            <path d="M12 6l0 13"></path>
            <path d="M21 6l0 13"></path>
          </svg>
          <div>
            <p class="box-body"><%= Config.esc(subject[0]) %></p>
            <p class="box-body" style="font-size: 10px; color: #888888">
              Subject Code: <%= Config.esc(subject[1]) %>
            </p>
          </div>
        </div>
      </div>
      <% } %> <% } %>
    </div>
  <script>
	const SettingsAjax = {
		url: "<%= ctx %>/settings/update",
		nonce: "<%= Config.js(csrf) %>",
	};
	const SubjectStatus = "<%= Config.js(subjectStatus) %>";
	const ProfileTab = document.getElementById("profile");
	const SubjectTab = document.getElementById("subject");
	const ProfileBtn = document.getElementById("profileopt");
	const SubjectBtn = document.getElementById("subjectopt");

	function DisplayData(opt) {
		const showProfile = opt === "profile";
		ProfileTab.style.display = showProfile ? "block" : "none";
		SubjectTab.style.display = showProfile ? "none" : "block";
		ProfileBtn.style.borderBottom = showProfile ? "2px solid #A855F7" : "none";
		ProfileBtn.style.color = showProfile ? "#A855F7" : "#333333";
		SubjectBtn.style.borderBottom = showProfile ? "none" : "2px solid #A855F7";
		SubjectBtn.style.color = showProfile ? "#333333" : "#A855F7";

		if (!showProfile) {
			if (SubjectStatus === "missing") {
				MyPopup("Missing Information", "Student UID and Semester are needed to fetch subjects.");
			} else if (SubjectStatus === "unsupported") {
				MyPopup("Course Unavailable", "This course is currently not supported by our platform.");
			}
		}
	}
	DisplayData("profile");

	function toggleEdit(key, mode) {
		const view = document.getElementById("field-" + key);
		const edit = document.getElementById("field-" + key + "-edit");
		if (!view || !edit) return;
		const showEdit = mode === "edit";
		view.style.display = showEdit ? "none" : "flex";
		edit.style.display = showEdit ? "flex" : "none";
		if (showEdit) {
			const input = document.getElementById("field-" + key + "-input");
			if (input) input.focus();
		}
	}

	function saveField(key) {
		const input = document.getElementById("field-" + key + "-input");
		const view = document.getElementById("field-" + key);
		if (!input || !view) return;
		const value = input.value.trim();
		toggleEdit(key, "view");
		const body = new URLSearchParams();
		body.append("action", "SettingsUpdate");
		body.append("nonce", SettingsAjax.nonce);
		body.append("key", key);
		body.append("value", value);
		fetch(SettingsAjax.url, {
			method: "POST",
			headers: {
				"Content-Type": "application/x-www-form-urlencoded"
			},
			body: body.toString(),
		}).then((response) => response.json()).then((data) => {
			if (data.success) {
				const span = view.querySelector("span");
				if (span) span.textContent = data.data.value || "Not Set";
				MyPopup("Profile Updated", "Your profile information has been updated successfully.");
			} else {
				MyPopup("Profile Updation Failed", "Please try again or check your information.");
			}
		}).catch(() => {
			MyPopup("Profile Updation Failed", "Please try again or check your information.");
		});
	}
  </script>
  </body>
</html>
