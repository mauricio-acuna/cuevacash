package com.cuevacash.userservice.entity;

/**
 * Enumeración que define los tipos de documentos de identidad
 * soportados en el sistema CuevaCash.
 * 
 * @author CuevaCash Development Team
 */
public enum DocumentType {
    /**
     * Cédula de Identidad
     */
    CEDULA("Cédula de Identidad"),
    
    /**
     * Registro Único del Contribuyente
     */
    RUC("RUC"),
    
    /**
     * Pasaporte
     */
    PASSPORT("Pasaporte"),
    
    /**
     * Documento de Identidad Extranjero
     */
    FOREIGN_ID("Documento Extranjero");

    private final String description;

    DocumentType(String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }

    @Override
    public String toString() {
        return description;
    }
}
