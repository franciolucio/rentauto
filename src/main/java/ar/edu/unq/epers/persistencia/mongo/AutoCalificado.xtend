package ar.edu.unq.epers.persistencia.mongo

import ar.edu.unq.epers.model.Categoria
import com.fasterxml.jackson.annotation.JsonProperty
import org.eclipse.xtend.lib.annotations.Accessors
import org.mongojack.ObjectId

@Accessors
class AutoCalificado {
	
	String nombreDelUsuarioQueLoUtilizo
	String patente
	Categoria categoria
	Calificacion calificacion
	@ObjectId
	@JsonProperty("_id")
	String id
	
	new(){}
	
	new(String nombreDelUsuarioQueLoUtilizo, String patente, Categoria categoria,Calificacion calificacion) {
		this.nombreDelUsuarioQueLoUtilizo = nombreDelUsuarioQueLoUtilizo
		this.patente = patente
		this.categoria = categoria
		this.calificacion = calificacion
	}
}
