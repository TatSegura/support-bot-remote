/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.sbr.web.dao;

import com.sbr.web.model.Usuario;
import com.sbr.web.util.DB;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UsuarioDAO {

    // Valida por email + password (texto plano por ahora)
    public Usuario validarPorEmail(String email, String password) {
        Usuario u = null;
        String sql = "SELECT * FROM usuarios WHERE email = ? AND password = ? LIMIT 1";

        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    u = new Usuario(
                        rs.getInt("id"),
                        rs.getString("usuario"),
                        rs.getString("password"),
                        rs.getString("nombre"),
                        rs.getString("apellido"),
                        rs.getString("email"),
                        rs.getString("direccion"),
                        rs.getString("rol")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return u;
    }

    // O si prefieres login por 'usuario' + 'password', usa este:
    public Usuario validarPorUsuario(String usuario, String password) {
        Usuario u = null;
        String sql = "SELECT * FROM usuarios WHERE usuario = ? AND password = ? LIMIT 1";
        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, usuario);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    u = new Usuario(
                        rs.getInt("id"),
                        rs.getString("usuario"),
                        rs.getString("password"),
                        rs.getString("nombre"),
                        rs.getString("apellido"),
                        rs.getString("email"),
                        rs.getString("direccion"),
                        rs.getString("rol")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return u;
    }
}


