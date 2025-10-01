/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.sbr.web.controller;

import com.sbr.web.dao.TicketDAO;
import com.sbr.web.model.Ticket;
import com.sbr.web.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/tickets", "/TicketsServlet"})
public class TicketsServlet extends HttpServlet {

    private final TicketDAO ticketDAO = new TicketDAO();

    // ===== Helpers =====
    private Usuario getUserFromSession(HttpSession session) {
        if (session == null) return null;
        Object o = session.getAttribute("usuarioLogeado");
        if (o instanceof Usuario) return (Usuario) o;
        o = session.getAttribute("usuario");
        if (o instanceof Usuario) return (Usuario) o;
        return null;
    }

    private String nz(String a, String b) { return (a != null) ? a : b; }

    private Integer parseIntOrNull(String s) {
        try { return (s == null || s.isBlank()) ? null : Integer.parseInt(s.trim()); }
        catch (Exception e) { return null; }
    }

    // ===== GET: listar mis tickets =====
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario user = getUserFromSession(session);
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Ticket> tickets = ticketDAO.listarPorUsuario(user.getId());
        request.setAttribute("tickets", tickets);
        request.getRequestDispatcher("tickets.jsp").forward(request, response);
    }

    // ===== POST: crear / cambiar estado =====
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario user = getUserFromSession(session);
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // soporta "action" y "accion"
        String action = nz(request.getParameter("action"), request.getParameter("accion"));

        // ---------- CAMBIAR ESTADO ----------
        // soporta:
        //  - action=estado & nuevoEstado=en_proceso|resuelto (versión anterior)
        //  - action=proceso | action=resuelto (versión nueva)
        if (action != null && (
                "estado".equalsIgnoreCase(action) ||
                "proceso".equalsIgnoreCase(action) ||
                "resuelto".equalsIgnoreCase(action))) {

            // id: soporta "idTicket" y "id"
            Integer idTicket = parseIntOrNull(nz(request.getParameter("idTicket"), request.getParameter("id")));
            if (idTicket == null) {
                response.sendRedirect("tickets");
                return;
            }

            // destino
            String nuevoEstado = request.getParameter("nuevoEstado");
            if (nuevoEstado == null) {
                // normaliza cuando viene como "proceso"/"resuelto"
                if ("proceso".equalsIgnoreCase(action)) nuevoEstado = "en_proceso";
                else if ("resuelto".equalsIgnoreCase(action)) nuevoEstado = "resuelto";
            }

            Ticket tk = ticketDAO.obtenerPorId(idTicket);
            if (tk != null && nuevoEstado != null) {
                boolean esDueno = (tk.getIdUsuario() != null && tk.getIdUsuario() == user.getId());
                boolean esAdmin = "ADMIN".equalsIgnoreCase(user.getRol());
                if (esDueno || esAdmin) {
                    String actual = (tk.getEstado() == null) ? "pendiente" : tk.getEstado().toLowerCase();
                    boolean ok = false;

                    if (esAdmin) {
                        // Admin: puede poner en_proceso si está pendiente, o resuelto si no está resuelto
                        if ("pendiente".equals(actual) && "en_proceso".equals(nuevoEstado)) ok = true;
                        if (!"resuelto".equals(actual) && "resuelto".equals(nuevoEstado)) ok = true;
                    } else {
                        // Usuario: pendiente -> en_proceso -> resuelto
                        if ("pendiente".equals(actual) && "en_proceso".equals(nuevoEstado)) ok = true;
                        if ("en_proceso".equals(actual) && "resuelto".equals(nuevoEstado)) ok = true;
                    }

                    if (ok && ticketDAO.actualizarEstado(idTicket, nuevoEstado)) {
                        session.setAttribute("flash", "Estado actualizado correctamente.");
                    }
                }
            }
            response.sendRedirect("tickets");
            return;
        }

        // ---------- CREAR TICKET ----------
        // soporta cualquier action distinto o sin action
        String descripcion = request.getParameter("descripcion");
        if (descripcion != null && !descripcion.isBlank()) {
            int idGen = ticketDAO.crear(user.getId(), descripcion.trim(), null); // id_servicio por ahora null
            if (idGen > 0) session.setAttribute("flash", "Ticket creado exitosamente.");
        }
        response.sendRedirect("tickets");
    }
}
