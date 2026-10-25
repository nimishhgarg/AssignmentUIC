<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String ctx = request.getContextPath();
    String csrf = (String) request.getAttribute("csrf");
    String current = "prompt";
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Generate Prompt</title>
<link rel="stylesheet" href="<%= ctx %>/assets/css/fonts.css">
<link rel="stylesheet" href="<%= ctx %>/assets/css/header.css">
<link rel="stylesheet" href="<%= ctx %>/assets/css/prompt.css" media="all">
</head>
<body>
<%@ include file="header.jspf" %>

<a class="back" id="back-link" href="<%= ctx %>/prompt">
    <span class="home-img">
        <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#A855F7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true" focusable="false"><path d="M5 12l-2 0l9 -9l9 9l-2 0"/><path d="M5 12v7a2 2 0 0 0 2 2h10a2 2 0 0 0 2 -2v-7"/><path d="M9 21v-6a2 2 0 0 1 2 -2h2a2 2 0 0 1 2 2v6"/></svg>
    </span>
    <span class="back-text">/</span>
    <span class="back-text">Generate Prompt</span>
</a>

<main>
    <h1>Generate <br><span class="accent">Worksheet Prompt</span></h1>
    <p class="text-field">Provide your experiment aim to generate a structured, optimized prompt for creating a comprehensive, high-quality worksheet.</p>

    <section class="prompt">
        <div class="prompt-top">
            <label class="prompt-heading" for="aim-input">Experiment Aim</label>
            <button type="button" class="help" id="open-settings" aria-haspopup="dialog" aria-controls="settings">Settings</button>
        </div>
        <textarea id="aim-input" maxlength="1000" placeholder="e.g. Write a Python program to implement Dijkstra's shortest path algorithm."></textarea>
        <p class="counter" id="aim-count">0 / 1000</p>
    </section>

    <h2 class="section-title">Choose AI Platform</h2>
    <p class="text-field text-field-flush">Choose an AI platform to generate the worksheet data. Copy the returned JSON response and paste it into the <a class="inline-link" href="<%= ctx %>/worksheet">Create Worksheet</a> page.</p>

    <label class="ai">
        <img class="aiimg" src="<%= ctx %>/assets/img/chatgpt.webp" alt="" width="50" height="50">
        <span class="ai-info">
            <span class="ai-row">
                <span class="ai-title">
                    <span class="aihead">ChatGPT</span>
                    <span class="tag tag-green">Preferred</span>
                </span>
                <input type="radio" class="circle-option" name="ai" value="chatgpt" checked>
            </span>
            <span class="aibody">Optimized content with consistent structure, professional formatting, and reliable results.</span>
        </span>
    </label>

    <label class="ai">
        <img class="aiimg" src="<%= ctx %>/assets/img/claude.webp" alt="" width="50" height="50">
        <span class="ai-info">
            <span class="ai-row">
                <span class="ai-title">
                    <span class="aihead">Claude</span>
                    <span class="tag tag-orange">Optional</span>
                </span>
                <input type="radio" class="circle-option" name="ai" value="claude">
            </span>
            <span class="aibody">Highly structured content and quality code, though tokens may exhaust faster.</span>
        </span>
    </label>

    <button type="button" class="btn" id="generate-btn">
        <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true" focusable="false"><path d="M6 21l15 -15l-3 -3l-15 15l3 3"/><path d="M15 6l3 3"/><path d="M9 3a2 2 0 0 0 2 2a2 2 0 0 0 -2 2a2 2 0 0 0 -2 -2a2 2 0 0 0 2 -2"/><path d="M19 13a2 2 0 0 0 2 2a2 2 0 0 0 -2 2a2 2 0 0 0 -2 -2a2 2 0 0 0 2 -2"/></svg>
        <span>Generate prompt</span>
        <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true" focusable="false"><path d="M5 12l14 0"/><path d="M15 16l4 -4"/><path d="M15 8l4 4"/></svg>
    </button>
</main>

<div class="overlay" id="overlay" hidden></div>

<div class="sheet" id="settings" role="dialog" aria-modal="true" aria-labelledby="sheet-title" hidden>
    <div class="bar"></div>

    <div class="sheet-head">
        <div class="sheet-title-wrap">
            <div class="sheet-icon">
                <svg xmlns="http://www.w3.org/2000/svg" width="35" height="35" viewBox="0 0 24 24" fill="none" stroke="#A855F7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true" focusable="false"><path d="M10.325 4.317c.426 -1.756 2.924 -1.756 3.35 0a1.724 1.724 0 0 0 2.573 1.066c1.543 -.94 3.31 .826 2.37 2.37a1.724 1.724 0 0 0 1.065 2.572c1.756 .426 1.756 2.924 0 3.35a1.724 1.724 0 0 0 -1.066 2.573c.94 1.543 -.826 3.31 -2.37 2.37a1.724 1.724 0 0 0 -2.572 1.065c-.426 1.756 -2.924 1.756 -3.35 0a1.724 1.724 0 0 0 -2.573 -1.066c-1.543 .94 -3.31 -.826 -2.37 -2.37a1.724 1.724 0 0 0 -1.065 -2.572c-1.756 -.426 -1.756 -2.924 0 -3.35a1.724 1.724 0 0 0 1.066 -2.573c-.94 -1.543 .826 -3.31 2.37 -2.37c1 .608 2.296 .07 2.572 -1.065"/><path d="M9 12a3 3 0 1 0 6 0a3 3 0 0 0 -6 0"/></svg>
            </div>
            <div>
                <p class="prompt-heading sheet-title" id="sheet-title">Prompt Settings</p>
                <p class="sheet-sub">Build custom prompt structures for better worksheet generation.</p>
            </div>
        </div>
        <button type="button" class="icon-btn" id="close-settings" aria-label="Close settings">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true" focusable="false"><path d="M6.707 5.293l5.293 5.292l5.293 -5.292a1 1 0 0 1 1.414 1.414l-5.292 5.293l5.292 5.293a1 1 0 0 1 -1.414 1.414l-5.293 -5.292l-5.293 5.292a1 1 0 1 1 -1.414 -1.414l5.292 -5.293l-5.292 -5.293a1 1 0 0 1 1.414 -1.414"/></svg>
        </button>
    </div>

    <div class="sheet-body" id="sheet-body">
        <div class="sheet-bar">
            <p class="prompt-heading sheet-sub-title">Your Sections <span class="hint">(Use the grip to reorder)</span></p>
            <button type="button" class="help reset" id="reset-sections-btn">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true" focusable="false"><path d="M20 11a8.1 8.1 0 0 0 -15.5 -2m-.5 -4v4h4"/><path d="M4 13a8.1 8.1 0 0 0 15.5 2m.5 4v-4h-4"/></svg>
                <span>Reset</span>
            </button>
        </div>

        <div class="drag-list" id="prompt-drag-list"></div>

        <template id="section-template">
            <div class="section-item">
                <button type="button" class="grip" aria-label="Reorder section. Use the up and down arrow keys.">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#999999" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true" focusable="false"><path d="M8 5a1 1 0 1 0 2 0a1 1 0 1 0 -2 0"/><path d="M8 12a1 1 0 1 0 2 0a1 1 0 1 0 -2 0"/><path d="M8 19a1 1 0 1 0 2 0a1 1 0 1 0 -2 0"/><path d="M14 5a1 1 0 1 0 2 0a1 1 0 1 0 -2 0"/><path d="M14 12a1 1 0 1 0 2 0a1 1 0 1 0 -2 0"/><path d="M14 19a1 1 0 1 0 2 0a1 1 0 1 0 -2 0"/></svg>
                </button>
                <span class="badge"></span>
                <p class="row-name"></p>
                <div class="row-actions">
                    <button type="button" class="act act-edit" aria-label="Edit section name"></button>
                    <button type="button" class="act act-del" aria-label="Delete section"></button>
                </div>
            </div>
        </template>

        <button type="button" class="add-btn" id="add-section-btn">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true" focusable="false"><path d="M12 5l0 14"/><path d="M5 12l14 0"/></svg>
            <span>Add New Section</span>
        </button>

        <div class="add-panel" id="add-section" hidden>
            <p class="prompt-heading add-title">Add New Section</p>
            <p class="sheet-sub">Create your own section to include in the prompt.</p>
            <div class="field" id="new-section-field">
                <span class="field-icon" aria-hidden="true">
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" focusable="false"><path d="M14 3v4a1 1 0 0 0 1 1h4"/><path d="M17 21h-10a2 2 0 0 1 -2 -2v-14a2 2 0 0 1 2 -2h7l5 5v11a2 2 0 0 1 -2 2"/><path d="M9 17h6"/><path d="M9 13h6"/></svg>
                </span>
                <input type="text" id="new-section-input" class="section-input" maxlength="40" autocomplete="off" aria-label="New section name" placeholder="Section name (e.g. Software Requirement)">
            </div>
            <div class="add-actions">
                <button type="button" class="add-btn add-btn-ghost" id="add-section-cancel">Cancel</button>
                <button type="button" class="add-btn" id="add-section-confirm">Add Section</button>
            </div>
        </div>
    </div>

    <div class="sheet-actions">
        <button type="button" class="setting-btn" id="cancel-section-btn">Cancel</button>
        <button type="button" class="setting-btn setting-btn-primary" id="save-section-btn">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true" focusable="false"><path d="M14 3v4a1 1 0 0 0 1 1h4"/><path d="M17 21h-10a2 2 0 0 1 -2 -2v-14a2 2 0 0 1 2 -2h7l5 5v11a2 2 0 0 1 -2 2"/><path d="M9 9l1 0"/><path d="M9 13l6 0"/><path d="M9 17l6 0"/></svg>
            <span>Save Changes</span>
        </button>
    </div>
</div>

<script src="<%= ctx %>/assets/js/popup.js"></script>
<script>
(function () {
    'use strict';

    var DEFAULTS = ['AIM', 'Objective', 'Theory', 'Source Code', 'Output', 'Learning Outcomes'];
    var MAX_SECTIONS = 15;
    var MAX_NAME = 40;
    var MIN_AIM = 10;
    var MAX_AIM = 1000;
    var AI = {
        chatgpt: { url: 'https://chatgpt.com/?q=' },
        claude: { url: 'https://claude.ai/new?q=' }
    };

    var TEMPLATE = String.raw`ROLE: ASSUIC worksheet generator for college programming practicals.

OUTPUT: Reply with ONLY raw ASSUIC text that starts with assuic=[ and ends with ]. No greeting, notes, Markdown, code fences, backticks or backslashes. Never convert to JSON or escape any character.

FORMAT:
assuic=[
"Heading": {content},
"Heading": {content}
]
Braces are literal. Put a comma after every field except the last. Each field is ONE physical line. Never add headings other than those defined below.

COMMANDS (literal text): &assuicnl = new line, &assuicbullet = bullet, &assuicin = one indent level (4 spaces, Source Code only). Never use \n, \t, <br>, real line breaks or tabs.

STEP 1 - COUNT: Read AIM and count the separate questions. Label them A, B, C in order. For each question, list the files its solution needs. Use one file unless the question clearly needs more (modules, classes, header files, web pages).

STEP 2 - HEADINGS (exact spelling and order):
- 1 question, 1 file: AIM, Objective, Theory, Source Code, Output, Learning Outcomes.
- 1 question, several files: AIM, Objective, Theory, Source Code(main.py), Source Code(module.py), Output(main.py), Learning Outcomes. Use the real file names, entry file first, and label Output with the entry file that is run.
- Several questions, 1 file each: AIM, Objective, Theory, Source Code(A), Output(A), Source Code(B), Output(B), Learning Outcomes.
- Several questions, some with several files: write A: before the file name, all files of question A first, then its Output, then question B, for example Source Code(A: main.py), Source Code(A: module.py), Output(A: main.py), Source Code(B), Output(B).
- If HEADINGS omits a section, omit it. Keep any other given heading exactly as written.
- Keep the order of HEADINGS. Expand Source Code and Output in place, where they appear in HEADINGS.

STYLE: simple college-student language, basic concepts.
AIM: 1 question means 1-2 lines. Several questions means one bullet per question: &assuicbullet Question A text&assuicnl&assuicbullet Question B text
Objective and Learning Outcomes: ONE combined field for all questions. 4-6 points, each starting with &assuicbullet, joined by &assuicnl. No sub-headings, no A/B labels.
Theory: ONE combined field for all questions. 100-150 words per question, only the concepts needed, paragraphs joined by &assuicnl. No sub-headings or labels.
Any other heading (Algorithm, Conclusion...): short student style using &assuicnl and &assuicbullet.

SOURCE CODE: Use the language given, else Python. Complete, correct, short, beginner-level, and it solves its question. When a question has several files, each Source Code field holds only that file, and the files must work together exactly (correct imports, names and paths). ZERO comments or docstrings. Deterministic: hardcode all data, no input(), random or time. Print clear results. Use single quotes only, never double quotes (in HTML use single-quoted attributes). End every line with &assuicnl. Indent ONLY with &assuicin (once per level, right after &assuicnl), never with spaces or tabs. A blank line is two &assuicnl, used only between imports, functions/classes and main. No trailing spaces.
Example: def f(n):&assuicnl&assuicinif n % 2 == 0:&assuicnl&assuicin&assuicinreturn 'Even'&assuicnl&assuicinreturn 'Odd'&assuicnl&assuicnlprint(f(4))

OUTPUT: the exact console output when the entry file is run with all its files together. If you can run code, run it and copy the real output. Otherwise trace it line by line and never guess. Write only the printed text with no labels, lines joined by &assuicnl, no trailing &assuicnl. For web pages, write the visible text of the rendered page, one line per element. Example for the code above: Even

SILENT CHECK: question count correct, file list correct, headings exact and in order, zero comments, indentation only via &assuicin, no double quotes, files import each other correctly, each Output matches its code, Objective/Theory/Learning Outcomes combined with no labels.`;

    var ICON_PENCIL = '<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true" focusable="false" style="pointer-events:none"><path d="M12.085 6.5l5.415 5.415l-8.793 8.792a1 1 0 0 1 -.707 .293h-4a1 1 0 0 1 -1 -1v-4a1 1 0 0 1 .293 -.707zm5.406 -2.698a3.828 3.828 0 0 1 1.716 6.405l-.292 .293l-5.415 -5.415l.293 -.292a3.83 3.83 0 0 1 3.698 -.991"/></svg>';
    var ICON_CHECK = '<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true" focusable="false" style="pointer-events:none"><path d="M5 12l5 5l10 -10"/></svg>';
    var ICON_TRASH = '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true" focusable="false" style="pointer-events:none"><path d="M4 7l16 0"/><path d="M10 11l0 6"/><path d="M14 11l0 6"/><path d="M5 7l1 12a2 2 0 0 0 2 2h8a2 2 0 0 0 2 -2l1 -12"/><path d="M9 7v-3a1 1 0 0 1 1 -1h4a1 1 0 0 1 1 1v3"/></svg>';
    var ICON_CROSS = '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true" focusable="false" style="pointer-events:none"><path d="M18 6l-12 12"/><path d="M6 6l12 12"/></svg>';

    function $(id) { return document.getElementById(id); }

    var aimEl = $('aim-input');
    var countEl = $('aim-count');
    var openBtn = $('open-settings');
    var overlay = $('overlay');
    var sheet = $('settings');
    var scroller = $('sheet-body');
    var closeBtn = $('close-settings');
    var listEl = $('prompt-drag-list');
    var tpl = $('section-template');
    var addBtn = $('add-section-btn');
    var addPanel = $('add-section');
    var newField = $('new-section-field');
    var newInput = $('new-section-input');
    var addConfirm = $('add-section-confirm');
    var addCancel = $('add-section-cancel');
    var resetBtn = $('reset-sections-btn');
    var saveBtn = $('save-section-btn');
    var cancelBtn = $('cancel-section-btn');
    var genBtn = $('generate-btn');
    var backLink = $('back-link');

    var nextId = 1;
    var sections = make(DEFAULTS);
    var snapshot = clone(sections);
    var editing = null;
    var lastFocus = null;
    var busy = false;

    function make(names) {
        return names.map(function (n) { return { id: nextId++, name: n }; });
    }

    function clone(list) {
        return list.map(function (s) { return { id: s.id, name: s.name }; });
    }

    function find(id) {
        for (var i = 0; i < sections.length; i++) {
            if (sections[i].id === id) return sections[i];
        }
        return null;
    }

    function notify(head, body) {
        if (typeof window.MyPopup === 'function') {
            window.MyPopup(head, body);
        } else {
            window.alert(head + '\n' + body);
        }
    }

    function cleanName(value) {
        return String(value)
            .replace(/[\u0000-\u001F\u007F,"\\{}\[\]&]/g, ' ')
            .replace(/\s+/g, ' ')
            .trim()
            .slice(0, MAX_NAME);
    }

    function isValidName(name, selfId) {
        if (!name) return false;
        var lower = name.toLowerCase();
        for (var i = 0; i < sections.length; i++) {
            if (sections[i].id !== selfId && sections[i].name.toLowerCase() === lower) return false;
        }
        return true;
    }

    function render() {
        listEl.textContent = '';
        var onlyOne = sections.length <= 1;
        sections.forEach(function (s, i) {
            var node = tpl.content.firstElementChild.cloneNode(true);
            var grip = node.querySelector('.grip');
            var del = node.querySelector('.act-del');
            node.dataset.id = s.id;
            node.querySelector('.badge').textContent = i + 1;
            node.querySelector('.row-name').textContent = s.name;
            node.querySelector('.act-edit').innerHTML = ICON_PENCIL;
            del.innerHTML = ICON_TRASH;
            del.disabled = onlyOne;
            grip.addEventListener('pointerdown', onDown);
            grip.addEventListener('keydown', onGripKey);
            listEl.appendChild(node);
        });
        addBtn.disabled = sections.length >= MAX_SECTIONS;
    }

    function renumber() {
        Array.prototype.forEach.call(listEl.querySelectorAll('.section-item'), function (node, i) {
            node.querySelector('.badge').textContent = i + 1;
        });
    }

    function syncOrder() {
        var map = {};
        sections.forEach(function (s) { map[s.id] = s; });
        var order = Array.prototype.map.call(listEl.querySelectorAll('.section-item'), function (n) {
            return Number(n.dataset.id);
        });
        sections = order.map(function (id) { return map[id]; }).filter(Boolean);
    }

    function setEditIcons(node, on) {
        var edit = node.querySelector('.act-edit');
        var del = node.querySelector('.act-del');
        edit.innerHTML = on ? ICON_CHECK : ICON_PENCIL;
        edit.classList.toggle('is-editing', on);
        edit.setAttribute('aria-label', on ? 'Save section name' : 'Edit section name');
        del.innerHTML = on ? ICON_CROSS : ICON_TRASH;
        del.setAttribute('aria-label', on ? 'Cancel editing' : 'Delete section');
        del.disabled = on ? false : sections.length <= 1;
    }

    function startEdit(node) {
        var id = Number(node.dataset.id);
        if (editing && editing.id === id) return;
        endEdit(true);
        var item = find(id);
        if (!item) return;

        var nameEl = node.querySelector('.row-name');
        var input = document.createElement('input');
        input.type = 'text';
        input.className = 'edit-input';
        input.maxLength = MAX_NAME;
        input.value = item.name;
        input.autocomplete = 'off';
        input.setAttribute('aria-label', 'Section name');

        nameEl.hidden = true;
        nameEl.after(input);
        setEditIcons(node, true);
        editing = { id: id, node: node, input: input };

        input.addEventListener('keydown', function (e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                endEdit(true);
            } else if (e.key === 'Escape') {
                e.preventDefault();
                e.stopPropagation();
                endEdit(false);
            }
        });
        input.addEventListener('blur', function () {
            if (editing && editing.input === input) endEdit(true);
        });

        input.focus();
        input.select();
    }

    function endEdit(apply) {
        if (!editing) return;
        var ed = editing;
        editing = null;

        var item = find(ed.id);

        if (apply && item) {
            var value = cleanName(ed.input.value);
            if (isValidName(value, ed.id)) item.name = value;
        }

        if (ed.node.parentNode) {
            var nameEl = ed.node.querySelector('.row-name');
            nameEl.textContent = item ? item.name : '';
            nameEl.hidden = false;
            if (ed.input.parentNode) ed.input.parentNode.removeChild(ed.input);
            setEditIcons(ed.node, false);
        }
    }

    listEl.addEventListener('mousedown', function (e) {
        if (e.target.closest('.act')) e.preventDefault();
    });

    listEl.addEventListener('click', function (e) {
        var del = e.target.closest('.act-del');
        var edit = e.target.closest('.act-edit');
        var node = e.target.closest('.section-item');
        if (!node || (!del && !edit)) return;
        var id = Number(node.dataset.id);

        if (del) {
            if (editing && editing.id === id) {
                endEdit(false);
                return;
            }
            if (sections.length <= 1) return;
            endEdit(true);
            sections = sections.filter(function (s) { return s.id !== id; });
            render();
            return;
        }

        if (editing && editing.id === id) {
            endEdit(true);
        } else {
            startEdit(node);
        }
    });

    function onGripKey(e) {
        if (e.key !== 'ArrowUp' && e.key !== 'ArrowDown') return;
        e.preventDefault();
        var id = Number(e.currentTarget.closest('.section-item').dataset.id);
        endEdit(true);
        var i = sections.findIndex(function (s) { return s.id === id; });
        var j = i + (e.key === 'ArrowUp' ? -1 : 1);
        if (i < 0 || j < 0 || j >= sections.length) return;
        sections.splice(j, 0, sections.splice(i, 1)[0]);
        render();
        var target = listEl.children[j];
        target.querySelector('.grip').focus();
        target.scrollIntoView({ block: 'nearest' });
    }

    function showAdd(on) {
        addPanel.hidden = !on;
        addBtn.hidden = on;
        newField.classList.remove('is-invalid');
        if (on) {
            newInput.focus();
        } else {
            newInput.value = '';
        }
    }

    function addSection() {
        endEdit(true);
        if (sections.length >= MAX_SECTIONS) return;
        var value = cleanName(newInput.value);
        if (!isValidName(value, null)) {
            newField.classList.add('is-invalid');
            newInput.focus();
            return;
        }
        sections.push({ id: nextId++, name: value });
        render();
        showAdd(false);
        if (listEl.lastElementChild) listEl.lastElementChild.scrollIntoView({ block: 'nearest' });
    }

    function openSettings() {
        snapshot = clone(sections);
        lastFocus = document.activeElement;
        overlay.hidden = false;
        sheet.hidden = false;
        document.body.classList.add('is-locked');
        scroller.scrollTop = 0;
        showAdd(false);
        closeBtn.focus();
    }

    function closeSettings() {
        sheet.hidden = true;
        overlay.hidden = true;
        document.body.classList.remove('is-locked');
        if (lastFocus && typeof lastFocus.focus === 'function') lastFocus.focus();
    }

    function cancelSettings() {
        endEdit(false);
        sections = clone(snapshot);
        render();
        showAdd(false);
        closeSettings();
    }

    function isDirty() {
        var a = sections.map(function (s) { return s.name; }).join('\u0001');
        var b = snapshot.map(function (s) { return s.name; }).join('\u0001');
        return a !== b;
    }

    function requestClose() {
        endEdit(true);
        if (isDirty()) {
            notify('Unsaved Changes', 'You have unsaved changes. Tap Save Changes to keep them, or Cancel to discard.');
            return;
        }
        cancelSettings();
    }

    function saveSettings() {
        endEdit(true);
        snapshot = clone(sections);
        showAdd(false);
        closeSettings();
        notify('Settings Saved', 'Your prompt settings have been saved successfully.');
    }

    function resetSections() {
        endEdit(false);
        sections = make(DEFAULTS);
        render();
    }

    openBtn.addEventListener('click', openSettings);
    closeBtn.addEventListener('click', requestClose);
    overlay.addEventListener('click', requestClose);
    cancelBtn.addEventListener('click', cancelSettings);
    saveBtn.addEventListener('click', saveSettings);
    resetBtn.addEventListener('click', resetSections);
    addBtn.addEventListener('click', function () { endEdit(true); showAdd(true); });
    addCancel.addEventListener('click', function () { showAdd(false); });
    addConfirm.addEventListener('click', addSection);

    newInput.addEventListener('input', function () {
        newField.classList.remove('is-invalid');
    });

    newInput.addEventListener('keydown', function (e) {
        if (e.key === 'Enter') {
            e.preventDefault();
            addSection();
        } else if (e.key === 'Escape') {
            e.preventDefault();
            e.stopPropagation();
            showAdd(false);
            addBtn.focus();
        }
    });

    newInput.addEventListener('focus', function () {
        setTimeout(function () {
            newInput.scrollIntoView({ block: 'center', behavior: 'smooth' });
        }, 300);
    });

    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape' && !sheet.hidden) requestClose();
    });

    sheet.addEventListener('keydown', function (e) {
        if (e.key !== 'Tab') return;
        var all = sheet.querySelectorAll('button, input');
        var focusable = Array.prototype.filter.call(all, function (el) {
            return !el.disabled && el.offsetParent !== null;
        });
        if (!focusable.length) return;
        var first = focusable[0];
        var last = focusable[focusable.length - 1];
        if (e.shiftKey && document.activeElement === first) {
            e.preventDefault();
            last.focus();
        } else if (!e.shiftKey && document.activeElement === last) {
            e.preventDefault();
            first.focus();
        }
    });

    var dragged = null;
    var pending = null;
    var pendingHandle = null;
    var pendingPointer = null;
    var startY = 0;
    var currentY = 0;
    var items = [];
    var dragRect = null;
    var listTop = 0;
    var listBottom = 0;
    var swapLocked = false;
    var swapTimer = null;
    var scrollFrame = 0;
    var ACTIVATE = 20;
    var SWAP_RATIO = 0.7;
    var DAMPING = 0.4;
    var SWAP_MS = 320;

    function getItems() {
        return Array.prototype.slice.call(listEl.querySelectorAll('.section-item'));
    }

    function computeBounds() {
        var tops = [];
        var bottoms = [];
        items.forEach(function (it) {
            var r = it.getBoundingClientRect();
            tops.push(r.top);
            bottoms.push(r.bottom);
        });
        listTop = Math.min.apply(null, tops);
        listBottom = Math.max.apply(null, bottoms);
    }

    function onDown(e) {
        if (e.pointerType === 'mouse' && e.button !== 0) return;
        var handle = e.currentTarget;
        var item = handle.closest('.section-item');
        if (!item) return;

        endEdit(true);
        e.preventDefault();
        pending = item;
        pendingHandle = handle;
        pendingPointer = e.pointerId;
        startY = e.clientY;
        currentY = e.clientY;

        try { handle.setPointerCapture(e.pointerId); } catch (err) {}

        document.addEventListener('pointermove', onMove);
        document.addEventListener('pointerup', onUp);
        document.addEventListener('pointercancel', onUp);
    }

    function autoScroll() {
        if (!dragged) return;
        var r = scroller.getBoundingClientRect();
        var zone = 56;
        var step = 0;
        if (currentY < r.top + zone) {
            step = -Math.ceil((r.top + zone - currentY) / 5);
        } else if (currentY > r.bottom - zone) {
            step = Math.ceil((currentY - (r.bottom - zone)) / 5);
        }
        if (step) {
            var before = scroller.scrollTop;
            scroller.scrollTop = before + step;
            var moved = scroller.scrollTop - before;
            if (moved) {
                startY -= moved;
                listTop -= moved;
                listBottom -= moved;
                dragRect = { top: dragRect.top - moved, bottom: dragRect.bottom - moved };
                onMove({ clientY: currentY });
            }
        }
        scrollFrame = requestAnimationFrame(autoScroll);
    }

    function activate() {
        dragged = pending;
        items = getItems();
        computeBounds();
        dragged.classList.add('dragging');
        dragged.style.transition = 'none';
        dragged.style.pointerEvents = 'none';
        document.body.style.userSelect = 'none';
        dragRect = dragged.getBoundingClientRect();
        scrollFrame = requestAnimationFrame(autoScroll);
    }

    function onMove(e) {
        if (!pending) return;
        currentY = e.clientY;
        var raw = currentY - startY;

        if (!dragged) {
            if (Math.abs(raw) < ACTIVATE) return;
            activate();
            raw = currentY - startY;
        }

        var delta = raw * DAMPING;
        var minDelta = listTop - dragRect.top;
        var maxDelta = listBottom - dragRect.bottom;
        if (delta < minDelta) delta = minDelta;
        if (delta > maxDelta) delta = maxDelta;

        dragged.style.transform = 'translateY(' + delta + 'px)';
        if (swapLocked) return;

        var rect = dragged.getBoundingClientRect();
        var down = delta > 0;
        var up = delta < 0;

        for (var i = 0; i < items.length; i++) {
            var sib = items[i];
            if (sib === dragged) continue;
            var after = !!(dragged.compareDocumentPosition(sib) & Node.DOCUMENT_POSITION_FOLLOWING);
            if (after && !down) continue;
            if (!after && !up) continue;

            var sr = sib.getBoundingClientRect();
            var overlap = Math.max(0, Math.min(rect.bottom, sr.bottom) - Math.max(rect.top, sr.top));
            var ratio = sr.height ? overlap / sr.height : 0;
            if (ratio < SWAP_RATIO) continue;

            swap(sib, after ? 'after' : 'before');
            break;
        }
    }

    function swap(sib, position) {
        var old = new Map();
        items.forEach(function (it) { old.set(it, it.getBoundingClientRect()); });

        if (position === 'after') {
            sib.after(dragged);
        } else {
            sib.before(dragged);
        }

        items = getItems();

        items.forEach(function (it) {
            if (it === dragged) return;
            var oldRect = old.get(it);
            if (!oldRect) return;
            var diff = oldRect.top - it.getBoundingClientRect().top;
            if (diff) {
                it.style.transition = 'none';
                it.style.transform = 'translateY(' + diff + 'px)';
                requestAnimationFrame(function () {
                    it.style.transition = 'transform ' + SWAP_MS + 'ms ease';
                    it.style.transform = '';
                });
            }
        });

        startY = currentY;
        dragged.style.transform = 'translateY(0px)';
        dragRect = dragged.getBoundingClientRect();
        computeBounds();
        renumber();
        syncOrder();

        swapLocked = true;
        if (swapTimer) clearTimeout(swapTimer);
        swapTimer = setTimeout(function () { swapLocked = false; }, SWAP_MS);
    }

    function onUp() {
        cancelAnimationFrame(scrollFrame);

        if (pendingHandle) {
            try { pendingHandle.releasePointerCapture(pendingPointer); } catch (err) {}
        }

        if (dragged) {
            var done = dragged;
            done.style.transition = 'transform 150ms ease';
            done.style.transform = '';
            done.style.pointerEvents = '';
            done.classList.remove('dragging');
            document.body.style.userSelect = '';
            setTimeout(function () { done.style.transition = ''; }, 160);
        }

        dragged = null;
        pending = null;
        pendingHandle = null;
        pendingPointer = null;
        dragRect = null;

        if (swapTimer) {
            clearTimeout(swapTimer);
            swapTimer = null;
        }
        swapLocked = false;

        syncOrder();
        renumber();

        document.removeEventListener('pointermove', onMove);
        document.removeEventListener('pointerup', onUp);
        document.removeEventListener('pointercancel', onUp);
    }

    function updateCount() {
        countEl.textContent = aimEl.value.length + ' / ' + MAX_AIM;
    }

    aimEl.addEventListener('input', function () {
        aimEl.classList.remove('is-invalid');
        updateCount();
    });

    function generate() {
        if (busy) return;

        var aim = aimEl.value.replace(/\r\n?/g, '\n').trim();

        if (aim.length < MIN_AIM) {
            aimEl.classList.add('is-invalid');
            aimEl.focus();
            notify('Missing Information', 'Please complete the missing information to proceed furthur.');
            return;
        }

        var headings = sections.map(function (s) { return s.name; }).join(', ');
        var selected = document.querySelector('input[name="ai"]:checked');
        var target = AI[selected ? selected.value : 'chatgpt'];
        var url = target.url + encodeURIComponent(TEMPLATE + '\n\nAIM: ' + aim + '\nHEADINGS: ' + headings);

        busy = true;
        genBtn.setAttribute('aria-disabled', 'true');
        setTimeout(function () {
            busy = false;
            genBtn.removeAttribute('aria-disabled');
        }, 1500);

        var link = document.createElement('a');
        link.href = url;
        link.target = '_blank';
        link.rel = 'noopener noreferrer';
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
    }

    genBtn.addEventListener('click', generate);

    backLink.addEventListener('click', function (e) {
        if (document.referrer && document.referrer.indexOf(window.location.origin) === 0 && window.history.length > 1) {
            e.preventDefault();
            window.history.back();
        }
    });

    render();
    updateCount();
})();
</script>
</body>
</html>
