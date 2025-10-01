<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // si ya hay sesión, manda a la bienvenida
    if (session.getAttribute("usuario") != null) {
        response.sendRedirect(request.getContextPath() + "/welcome.jsp");
        return;
    }
    String error = (String) request.getAttribute("error"); // <-- define 'error'
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Support Bot Remote</title>

  <!-- Bootstrap -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />

  <!-- Animaciones -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>

  <style>
    body {
      background-image: url('<%=request.getContextPath()%>/img/fondo_web.png');
      background-size: cover;
      background-repeat: no-repeat;
      background-position: center;
      margin: 0;
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      transition: background 0.3s ease, color 0.3s ease;
    }

    .toggle-theme {
      position: absolute;
      top: 15px;
      right: 20px;
      background: rgba(255, 255, 255, 0.8);
      border: none;
      padding: 8px 14px;
      border-radius: 20px;
      cursor: pointer;
      font-size: 0.9rem;
      font-weight: bold;
      transition: background 0.3s ease, color 0.3s ease;
    }
    .toggle-theme:hover { background: rgba(0, 0, 0, 0.1); }

    .titulo {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      font-size: 3rem;
      font-weight: bold;
      background: linear-gradient(90deg, #0d6efd, #0a4fa3);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      animation: fadeIn 1.2s ease-in-out;
      margin-top: 20px;
    }
    .subtitulo {
      font-size: 1.2rem;
      color: #0a4fa3;
      font-weight: 500;
      margin-bottom: 25px;
      animation: fadeIn 1.5s ease-in-out;
    }
    @keyframes fadeIn { from{opacity:0;transform:translateY(-10px);} to{opacity:1;transform:translateY(0);} }

    .contenedor-principal {
      flex: 1; display:flex; justify-content:flex-end; align-items:center; padding:0 60px;
    }
    .form-container {
      width: 380px;
      background: rgba(255, 255, 255, 0.2);
      backdrop-filter: blur(12px);
      -webkit-backdrop-filter: blur(12px);
      border-radius: 20px; padding: 30px;
      border: 1px solid rgba(255, 255, 255, 0.3);
      box-shadow: 0 8px 25px rgba(0,0,0,0.25);
      z-index: 2; position: relative;
      transition: background 0.3s ease, color 0.3s ease;
    }
    .btn-primary { background: linear-gradient(90deg, #0d6efd, #0a4fa3); border:none; transition:.3s ease; }
    .btn-primary:hover { background: linear-gradient(90deg, #0a4fa3, #0d6efd); transform: scale(1.05); }

    .nav-login { margin-top: 15px; display:flex; flex-direction:column; align-items:center; gap:6px; }
    .nav-login a { text-decoration:none; color:#0d6efd; font-size:.9rem; transition: color .3s ease; }
    .nav-login a:hover { text-decoration: underline; }

    .toggle-pass { font-size:.8rem; cursor:pointer; margin-top:5px; color:#007bff; transition: color .3s ease; }
    .toggle-pass:hover { text-decoration: underline; }

    footer { background: linear-gradient(90deg, #0d6efd, #0a4fa3); text-align:center; padding:10px; font-size:1.1rem; color:#fffbfb; transition: background .3s ease, color .3s ease; }

    @media (max-width: 768px) {
      .contenedor-principal { justify-content:center; padding:20px; }
      .form-container { width:100%; max-width:350px; }
      .titulo { font-size: 2.2rem; }
    }

    /* Modo oscuro */
    body.dark { color:#f0f0f0; }
    body.dark .form-container { background: rgba(0,0,0,0.6); border:1px solid rgba(255,255,255,0.2); color:#f0f0f0; }
    body.dark .titulo { background: linear-gradient(90deg,#66b2ff,#3385ff); -webkit-background-clip:text; -webkit-text-fill-color:transparent; }
    body.dark .subtitulo { color:#aaccff; }
    body.dark .toggle-theme { background: rgba(0,0,0,0.6); color:#fff; }
    body.dark footer { background: linear-gradient(90deg,#0a1a2f,#0d2b4d); color:#ccc; }
    body.dark .nav-login a, body.dark .toggle-pass { color:#aaccff; }
    body.dark .nav-login a:hover, body.dark .toggle-pass:hover { color:#cce6ff; }
  </style>
</head>
<body>
  <!-- Botón para cambiar tema -->
  <button class="toggle-theme" id="themeToggle">🌙 Modo Oscuro</button>

  <div class="text-center">
    <h1 class="titulo">Support Bot Remote</h1>
    <p class="subtitulo">Soporte remoto eficiente y confiable</p>
  </div>

  <div class="contenedor-principal">
    <div class="form-container animate__animated animate__fadeInRight">
      <h2 class="text-center mb-4">Inicio de Sesión</h2>

      <% if (error != null) { %>
  <div class="alert alert-danger py-2 my-2 text-center"><%= error %></div>
<% } %>

      <!-- Formulario REAL al servlet -->
<form action="<%=request.getContextPath()%>/LoginServlet" method="post" autocomplete="off">
    <div class="mb-3">
        <label for="email" class="form-label">Correo electrónico</label>
        <input type="text" class="form-control" id="email" name="email" 
               placeholder="Ingrese su correo" required>
    </div>

    <div class="mb-3">
        <label for="password" class="form-label">Contraseña</label>
        <input type="password" class="form-control" id="password" name="password" 
               placeholder="Ingrese su contraseña" required>
        <span class="toggle-pass" id="togglePassword">Mostrar contraseña</span>
    </div>

    <button type="submit" class="btn btn-primary w-100">Ingresar</button>
</form>

      <div class="nav-login mt-3">
        <a href="#">¿No eres cliente aún? Regístrate</a>
        <a href="#">¿Olvidaste tu contraseña?</a>
      </div>
    </div>
  </div>

  <footer>
    <p>&copy; 2025 Support Bot Remote. Todos los derechos reservados.</p>
  </footer>

  <script>
    // modo oscuro
    const themeToggle = document.getElementById("themeToggle");
    themeToggle.addEventListener("click", () => {
      document.body.classList.toggle("dark");
      themeToggle.textContent = document.body.classList.contains("dark") ? "☀️ Modo Claro" : "🌙 Modo Oscuro";
    });

    // mostrar/ocultar contraseña
    const togglePassword = document.getElementById("togglePassword");
    const pwd = document.getElementById("password");
    togglePassword.addEventListener("click", () => {
      pwd.type = (pwd.type === "password") ? "text" : "password";
      togglePassword.textContent = (pwd.type === "password") ? "Mostrar contraseña" : "Ocultar contraseña";
    });
  </script>

  <!-- Si usas un JS local -->
  <script src="<%=request.getContextPath()%>/js/support.js"></script>
</body>
</html>

