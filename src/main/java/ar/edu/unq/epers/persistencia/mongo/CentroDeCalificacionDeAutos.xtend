package ar.edu.unq.epers.persistencia.mongo

import ar.edu.unq.epers.model.Usuario
import ar.edu.unq.epers.persistencia.neo4j.DBManagerNeo4j
import org.eclipse.xtend.lib.annotations.Accessors
import org.mongojack.DBQuery

@Accessors
class CentroDeCalificacionDeAutos {
	
	DBManagerNeo4j dbManagerNeo4j
	
	def calificarAuto(Usuario usuarioQueCalifica,AutoCalificado autoCalif,Calificacion calificacion){
		val autoCalificado = SistemDB.instance().collection(AutoCalificado);
		val nuevaCalificacion = new AutoCalificado(usuarioQueCalifica.nombreDeUsuario,autoCalif.patente,autoCalif.categoria,calificacion)
		autoCalificado.insert(nuevaCalificacion)
	}
	
	def getAutosCalificadosPorPatente(String patente) {
		val autoCalificado = SistemDB.instance().collection(AutoCalificado);
		val autosCalificados = autoCalificado.mongoCollection.find(DBQuery.is("patente", patente));
		return autosCalificados
	}
	
	def publicaciones(Usuario u1 , Usuario u2){
		val autoCalificado = SistemDB.instance().collection(AutoCalificado);
		if (u1.equals(u2))
			return autoCalificado.mongoCollection.find(DBQuery.is("nombreDelUsuarioQueLoUtilizo", u1.nombreDeUsuario))
		if (dbManagerNeo4j.sonAmigos(u2,u1))
			return autoCalificado.mongoCollection.find(DBQuery.in("calificacion.privacidad", NivelPrivacidad.SOLOAMIGOS,NivelPrivacidad.PUBLICO).and(DBQuery.is("nombreDelUsuarioQueLoUtilizo",u2.nombreDeUsuario)))
		return autoCalificado.mongoCollection.find(DBQuery.is("calificacion.privacidad",NivelPrivacidad.PUBLICO).and(DBQuery.is("nombreDelUsuarioQueLoUtilizo",u2.nombreDeUsuario)))
	}

	def drop(){
		val autoCalificado = SistemDB.instance().collection(AutoCalificado);
		autoCalificado.mongoCollection.drop
	}
} 