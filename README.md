<div align="center">

# AssignmentUIC

### Create worksheets faster. Keep the quality high.

**AssignmentUIC** is a worksheet-generation project designed to help students create clean, organized programming worksheets with less repetitive formatting. It combines a Java web application with a Python backend that generates worksheet documents and PDFs from structured content.

<p>
  <img src="https://img.shields.io/badge/Java-Web%20Application-orange?style=for-the-badge&logo=java" alt="Java Web Application">
  <img src="https://img.shields.io/badge/Python-FastAPI-009688?style=for-the-badge&logo=fastapi" alt="Python FastAPI">
  <img src="https://img.shields.io/badge/License-MIT-blue?style=for-the-badge" alt="MIT License">
</p>

<p>
  <strong>Objective:</strong> Make worksheet creation fast, simple, and consistent—without compromising presentation quality.
</p>

</div>

---

## ✨ Overview

AssignmentUIC brings worksheet preparation into one workflow:

- Create structured programming worksheets.
- Include student details, worksheet titles, dates, aims, theory, source code, and output.
- Generate formatted DOCX or PDF documents through the Python backend.
- Use the Java web application as the user-facing interface.
- Run the backend locally and connect to it through HTTP.

## 🧰 Technologies

| Component | Technology |
| --- | --- |
| Web application | Java, JSP, Servlets |
| Backend API | Python, FastAPI, Uvicorn |
| Document generation | python-docx |
| Database connectivity | MySQL Connector/J |
| IDE | Eclipse IDE for Enterprise Java and Web Developers |

## 📁 Project Structure

```text
AssignmentUIC/
├── src/
│   └── main/
│       ├── java/
│       │   └── app/
│       └── webapp/
├── config/
│   └── config.json
├── core/
├── modules/
├── resources/
├── main.py
├── requirements.txt
└── LICENSE
```

---

## 🚀 Setup and Run

### 1. Import the Java web application into Eclipse

The Java web application is located in:

```text
src/main/
```

<div align="center">

```text
┌──────────────────────────────────────────────┐
│                  src/main                    │
│                                              │
│   java/                 webapp/              │
│   Java source           Web resources        │
│                                              │
└──────────────────────────────────────────────┘
                      ↓
        Import into Eclipse as a
          Dynamic Web Project
```

**Import the `src/main` folder into your Eclipse Dynamic Web Project.**

</div>

1. Open Eclipse IDE for Enterprise Java and Web Developers.
2. Create or open a **Dynamic Web Project**.
3. Import/copy the contents of `src/main` into the project's corresponding source and web-content locations.
4. Configure your Apache Tomcat server in Eclipse.
5. Run the web application on the server.

### 2. Set up the Python backend

Open a terminal in the project root directory—the directory containing `main.py` and `requirements.txt`.

<div align="center">

```text
┌──────────────────────────────────────────────┐
│              BACKEND SETUP                   │
│                                              │
│  Create a virtual environment                │
│  Activate the environment                    │
│  Install the required packages               │
└──────────────────────────────────────────────┘
```

</div>

Create and activate the virtual environment:

```bash
python3 -m venv venv
source venv/bin/activate
```

Install the dependencies:

```bash
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
```

### 3. Start the backend server

Run this command from the same project root directory:

<div align="center">

```text
┌──────────────────────────────────────────────┐
│               RUN BACKEND                    │
│                                              │
│  Start the AssignmentUIC FastAPI service     │
│  Address: 0.0.0.0                            │
│  Port:    6969                               │
│  Reload:  Enabled                            │
└──────────────────────────────────────────────┘
```

</div>

```bash
uvicorn main:app --host 0.0.0.0 --port 6969 --reload
```

The backend will be available at:

- API base: `http://127.0.0.1:6969`
- API documentation: `http://127.0.0.1:6969/docs`

### 4. Check backend health

After starting the server, open this address in your browser:

<div align="center">

```text
┌──────────────────────────────────────────────┐
│               BACKEND HEALTH                 │
│                                              │
│  Visit: http://127.0.0.1:6969/health         │
│                                              │
│  Confirm that the backend responds           │
│  successfully before using the application.  │
└──────────────────────────────────────────────┘
```

</div>

Or check it from the terminal:

```bash
curl -i http://127.0.0.1:6969/health
```

---

## 🔌 Backend API

| Method | Endpoint | Purpose |
| --- | --- | --- |
| `POST` | `/graphql` | Submit worksheet data for document generation |
| `GET` | `/download/{filename}` | Download a generated document |
| `GET` | `/health` | Check backend availability |

The `/graphql` route accepts a JSON request containing student details, worksheet settings, and worksheet content. The API responds with generated-file information; use the download endpoint to retrieve the generated file.

## 🌐 CORS and Network Access

The backend is configured to accept cross-origin browser requests from any origin.

The server's `0.0.0.0` bind address allows it to listen on available network interfaces. To access it from another device or server, make sure the host is reachable and the port is permitted by the network or firewall.

> **Deployment note:** Open CORS and exposing a development server to the public internet can create security risks. For production use, restrict allowed origins, use a production server configuration, and apply appropriate access controls.

## 📄 License

This project is licensed under the **MIT License**. See the [`LICENSE`](LICENSE) file for details.

---
