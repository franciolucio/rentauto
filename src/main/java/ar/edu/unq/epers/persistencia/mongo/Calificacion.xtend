package ar.edu.unq.epers.persistencia.mongo

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Calificacion {
	
	NivelCalificacion calificacion
	String comentario
	NivelPrivacidad privacidad
	
	new (){}
	
	new (NivelCalificacion calificacion, String comentario, NivelPrivacidad privacidad) {
		this.calificacion = calificacion
		this.comentario = comentario
		this.privacidad = privacidad
	}
}