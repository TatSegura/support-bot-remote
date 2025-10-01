<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sbr.web.model.Usuario" %>
<%
    // Anti-caché
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // Sesión
    Usuario user = (Usuario) session.getAttribute("usuarioLogeado");
    if (user == null) { response.sendRedirect("login.jsp"); return; }

    // Saludo
    java.time.LocalTime t = java.time.LocalTime.now();
    String saludo = t.isBefore(java.time.LocalTime.NOON) ? "¡Buenos días"
                 : (t.isBefore(java.time.LocalTime.of(18,0)) ? "¡Buenas tardes" : "¡Buenas noches");
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Dashboard</title>

  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="preload" as="image" href="<%=request.getContextPath()%>/img/welcofondo.png">

  <style>
    :root{ --glass:rgba(255,255,255,.18); --glass-border:rgba(255,255,255,.35); --grad1:#0d6efd; --grad2:#0a4fa3; }
    html,body{height:100%}
    body{
      margin:0; background:url("<%=request.getContextPath()%>/img/welcofondo.png") no-repeat center/cover fixed;
      font-family:'Segoe UI',system-ui,-apple-system,Arial,sans-serif; display:grid; place-items:center; color:#fff
    }
    .bg-overlay{position:fixed; inset:0; background:radial-gradient(ellipse at center,rgba(0,0,0,.18),rgba(0,0,0,.38) 70%); z-index:0}
    .welcome-card{
      position:relative; z-index:1; width:min(780px,92vw);
      padding:40px 32px; border-radius:20px; background:var(--glass);
      border:1px solid var(--glass-border); box-shadow:0 10px 30px rgba(0,0,0,.35);
      backdrop-filter:blur(10px); -webkit-backdrop-filter:blur(10px); text-align:center
    }
    .title{
      font-weight:800; font-size:clamp(1.6rem,2.6vw + 1rem,2.4rem); margin-bottom:.25rem;
      background:linear-gradient(90deg,var(--grad1),var(--grad2)); -webkit-background-clip:text; -webkit-text-fill-color:transparent;
      text-shadow:0 1px 2px rgba(0,0,0,.25)
    }
    .subtitle{font-size:1.05rem; margin-bottom:1.2rem; color:#f2f2f2; opacity:.95}
    .info{color:#f6f6f6; opacity:.95}
    .btn-grad{background:linear-gradient(90deg,var(--grad1),var(--grad2)); border:none; color:#fff}
    .btn-grad:hover{background:linear-gradient(90deg,var(--grad2),var(--grad1))}
    .btn-outline-light{border-color:rgba(255,255,255,.65); color:#fff}
    .btn-outline-light:hover{background:rgba(255,255,255,.12); border-color:#fff}
    @media (max-width:480px){ .welcome-card{padding:28px 22px} }
  </style>
</head>
<body>
  <div class="bg-overlay"></div>

  <main class="welcome-card">
    <h1 class="title"><%= saludo %>, <%= user.getNombre() %> <%= user.getApellido() %> 👋</h1>
    <p class="subtitle">Has iniciado sesión correctamente en <strong>Support Bot Remote</strong>.</p>

    <!-- Datos rápidos -->
    <div class="row g-3 justify-content-center info">
      <div class="col-12 col-md-4"><strong>Rol:</strong> <%= user.getRol() %></div>
      <div class="col-12 col-md-4"><strong>Correo:</strong> <%= user.getEmail() %></div>
      <div class="col-12 col-md-4"><strong>Dirección:</strong> <%= user.getDireccion() %></div>
    </div>

    <!-- Acciones -->
    <div class="d-grid gap-2 d-sm-flex justify-content-center mt-4">
      <a class="btn btn-grad px-4" href="tickets">Mis tickets</a>
      <form action="LogoutServlet" method="post" class="d-inline">
        <button class="btn btn-outline-light px-4">Cerrar sesión</button>
      </form>
    </div>

    <hr class="border-light opacity-50 my-4"/>
    <small class="opacity-75">© 2025 Support Bot Remote.</small>
  </main>
</body>
</html>
