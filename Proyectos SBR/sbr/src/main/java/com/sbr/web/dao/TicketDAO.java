/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.sbr.web.dao;

import com.sbr.web.model.Ticket;
import com.sbr.web.util.DB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class TicketDAO {

    // ---------- Helpers ----------
    private Ticket mapRow(ResultSet rs) throws Exception {
        Ticket t = new Ticket();
        t.setIdTicket(rs.getInt("id_ticket"));
        int u = rs.getInt("id_usuario");  t.setIdUsuario(rs.wasNull() ? null : u);
        int s = rs.getInt("id_servicio"); t.setIdServicio(rs.wasNull() ? null : s);
        int te = rs.getInt("id_tecnico"); t.setIdTecnico(rs.wasNull() ? null : te);
        t.setDescripcion(rs.getString("descripcion"));
        t.setEstado(rs.getString("estado"));                 // 'pendiente','en_proceso','resuelto'
        t.setFechaCreacion(rs.getTimestamp("fecha_creacion"));
        return t;
    }

    // ---------- C: crear ticket ----------
    // Devuelve el id generado
    public int crear(int idUsuario, String descripcion, Integer idServicio) {
        String sql = "INSERT INTO tickets (id_usuario, descripcion, id_servicio) VALUES (?, ?, ?)";
        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, idUsuario);
            ps.setString(2, descripcion);
            if (idServicio == null) ps.setNull(3, java.sql.Types.INTEGER); else ps.setInt(3, idServicio);

            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1; // error
    }

    // ---------- R: listar tickets por usuario ----------
    public List<Ticket> listarPorUsuario(int idUsuario) {
    List<Ticket> lista = new ArrayList<>();
    String sql = "SELECT * FROM tickets WHERE id_usuario = ? ORDER BY id_ticket DESC";
        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    // (opcional) listar todos para ADMIN
    public List<Ticket> listarTodos() {
        List<Ticket> lista = new ArrayList<>();
        String sql = "SELECT * FROM tickets ORDER BY id_ticket DESC";
        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) lista.add(mapRow(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return lista;
    }

    // ---------- R: obtener por id ----------
    public Ticket obtenerPorId(int idTicket) {
        String sql = "SELECT * FROM tickets WHERE id_ticket = ? LIMIT 1";
        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idTicket);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ---------- U: cambiar estado ----------
    // nuevoEstado: 'pendiente' | 'en_proceso' | 'resuelto'
    public boolean actualizarEstado(int idTicket, String nuevoEstado) {
        String sql = "UPDATE tickets SET estado = ? WHERE id_ticket = ?";
        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, nuevoEstado);
            ps.setInt(2, idTicket);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // (opcional) asignar técnico
    public boolean asignarTecnico(int idTicket, Integer idTecnico) {
        String sql = "UPDATE tickets SET id_tecnico = ? WHERE id_ticket = ?";
        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            if (idTecnico == null) ps.setNull(1, java.sql.Types.INTEGER); else ps.setInt(1, idTecnico);
            ps.setInt(2, idTicket);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }
}

