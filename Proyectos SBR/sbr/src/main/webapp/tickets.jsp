<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.sbr.web.model.Ticket" %>

<%
  // Anti-cache
  response.setHeader("Cache-Control","no-cache, no-store, must-revalidate");
  response.setHeader("Pragma","no-cache");
  response.setDateHeader("Expires",0);

  // Sesión (acepta usuarioLogeado o usuario)
  Object user = session.getAttribute("usuarioLogeado");
  if (user == null) user = session.getAttribute("usuario");
  if (user == null) { response.sendRedirect("login.jsp"); return; }

  // Mensaje flash (opcional, lo setea el servlet en sesión)
  String flash = (String) session.getAttribute("flash");
  if (flash != null) session.removeAttribute("flash");

  // Tickets desde el servlet
  List<Ticket> tickets = (List<Ticket>) request.getAttribute("tickets");
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Mis tickets</title>

  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

  <style>
    :root{
      --glass: rgba(255,255,255,.18);
      --glass-border: rgba(255,255,255,.35);
      --grad1: #0d6efd;
      --grad2: #0a4fa3;
    }
    html,body{height:100%}
    body{
      margin:0;
      background: url("<%=request.getContextPath()%>/img/welcofondo.png") no-repeat center/cover fixed;
      font-family:'Segoe UI', system-ui, -apple-system, Arial, sans-serif;
      display:grid; place-items:center; color:#fff;
    }
    .cardx{
      width:min(980px,95vw);
      padding:28px; border-radius:20px;
      background:var(--glass); border:1px solid var(--glass-border);
      backdrop-filter: blur(10px); box-shadow:0 10px 30px rgba(0,0,0,.35);
    }
    .title{
      font-weight:800; font-size:clamp(1.4rem,2.2vw + 1rem,2rem);
      background:linear-gradient(90deg,var(--grad1),var(--grad2));
      -webkit-background-clip:text; -webkit-text-fill-color:transparent;
    }
    .btn-grad{background:linear-gradient(90deg,var(--grad1),var(--grad2)); border:none; color:#fff}
    .btn-grad:hover{background:linear-gradient(90deg,var(--grad2),var(--grad1))}
    /* Tabla legible sobre fondo glass */
    table{width:100%; border-collapse:separate; border-spacing:0; border-radius:12px; overflow:hidden}
    thead th{background:rgba(255,255,255,.92); color:#111; padding:12px 16px}
    tbody td{background:rgba(255,255,255,.55); color:#111; padding:12px 16px}
    tbody tr:nth-child(odd) td{background:rgba(255,255,255,.42)}
    .badge-pill{border-radius:50rem; padding:.35rem .75rem; font-weight:700}
  </style>
</head>
<body>
<main class="cardx">
  <div class="d-flex justify-content-between align-items-center mb-3">
    <h1 class="title m-0">Mis tickets</h1>
    <div class="d-flex gap-2">
      <a class="btn btn-outline-light" href="dashboard.jsp">Volver</a>
      <form action="LogoutServlet" method="post" class="d-inline">
        <button class="btn btn-grad">Cerrar sesión</button>
      </form>
    </div>
  </div>

  <% if (flash != null) { %>
    <div class="alert alert-success py-2 mb-3"><%= flash %></div>
  <% } %>

  <!-- Crear ticket -->
  <form class="row g-2 mb-3" action="tickets" method="post" autocomplete="off">
    <div class="col-12 col-md-9">
      <input type="text" name="descripcion" class="form-control" placeholder="Describe tu problema…" required>
    </div>
    <div class="col-12 col-md-3 d-grid">
      <button class="btn btn-grad">Crear ticket</button>
    </div>
  </form>

  <!-- Listado -->
  <div class="table-responsive">
    <table class="table align-middle m-0">
      <thead>
        <tr>
          <th style="width:60px">#</th>
          <th>Descripción</th>
          <th style="width:160px">Estado</th>
          <th style="width:200px">Creado</th>
          <th style="width:260px">Acciones</th>
        </tr>
      </thead>
      <tbody>
      <%
        if (tickets != null && !tickets.isEmpty()) {
          int i = 1;
          for (Ticket t : tickets) {
            String e = (t.getEstado() == null) ? "pendiente" : t.getEstado().toLowerCase();
            boolean esPendiente = "pendiente".equals(e);
            boolean esEnProceso = "en_proceso".equals(e);
            boolean esResuelto  = "resuelto".equals(e);

            String badgeClass = esPendiente ? "bg-secondary"
                             : (esEnProceso ? "bg-info text-dark" : "bg-success");
            String badgeText  = esPendiente ? "PENDIENTE"
                             : (esEnProceso ? "EN PROCESO" : "RESUELTO");

            boolean puedeEnProceso = esPendiente;
            boolean puedeResuelto  = esEnProceso;
      %>
        <tr>
          <!-- Si prefieres el id real, usa t.getIdTicket() -->
          <td><%= i++ %></td>
          <td><%= t.getDescripcion() %></td>
          <td><span class="badge badge-pill <%= badgeClass %>"><%= badgeText %></span></td>
          <td><%= t.getFechaCreacion() %></td>
          <td>
            <div class="d-flex gap-2">
              <!-- Pasar a EN PROCESO -->
              <form action="tickets" method="post" class="d-inline">
                <input type="hidden" name="accion" value="proceso">
                <input type="hidden" name="id" value="<%= t.getIdTicket() %>">
                <button class="btn btn-sm btn-outline-dark" <%= puedeEnProceso ? "" : "disabled" %>>
                  En proceso
                </button>
              </form>
              <!-- Pasar a RESUELTO -->
              <form action="tickets" method="post" class="d-inline">
                <input type="hidden" name="accion" value="resuelto">
                <input type="hidden" name="id" value="<%= t.getIdTicket() %>">
                <button class="btn btn-sm btn-outline-dark" <%= puedeResuelto ? "" : "disabled" %>>
                  Resuelto
                </button>
              </form>
            </div>
          </td>
        </tr>
      <%
          }
        } else {
      %>
        <tr>
          <td colspan="5" class="text-center" style="color:#222">Aún no tienes tickets.</td>
        </tr>
      <%
        }
      %>
      </tbody>
    </table>
  </div>

  <hr class="border-light opacity-50 my-3"/>
  <small class="opacity-75">© 2025 Support Bot Remote.</small>
</main>
</body>
</html>
