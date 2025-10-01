/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.sbr.web.model;

import java.sql.Timestamp;

public class Ticket {
    private int idTicket;
    private Integer idUsuario;   // puede venir null al listar si haces joins
    private Integer idServicio;  // opcional por ahora
    private Integer idTecnico;   // opcional por ahora
    private String descripcion;
    private String estado;       // 'pendiente' | 'en_proceso' | 'resuelto'
    private Timestamp fechaCreacion;

    public Ticket() {}

    public Ticket(int idTicket, Integer idUsuario, Integer idServicio, Integer idTecnico,
                  String descripcion, String estado, Timestamp fechaCreacion) {
        this.idTicket = idTicket;
        this.idUsuario = idUsuario;
        this.idServicio = idServicio;
        this.idTecnico = idTecnico;
        this.descripcion = descripcion;
        this.estado = estado;
        this.fechaCreacion = fechaCreacion;
    }

    // Getters y setters
    public int getIdTicket() { return idTicket; }
    public void setIdTicket(int idTicket) { this.idTicket = idTicket; }

    public Integer getIdUsuario() { return idUsuario; }
    public void setIdUsuario(Integer idUsuario) { this.idUsuario = idUsuario; }

    public Integer getIdServicio() { return idServicio; }
    public void setIdServicio(Integer idServicio) { this.idServicio = idServicio; }

    public Integer getIdTecnico() { return idTecnico; }
    public void setIdTecnico(Integer idTecnico) { this.idTecnico = idTecnico; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public Timestamp getFechaCreacion() { return fechaCreacion; }
    public void setFechaCreacion(Timestamp fechaCreacion) { this.fechaCreacion = fechaCreacion; }
}

