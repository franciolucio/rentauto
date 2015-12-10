package ar.edu.unq.epers.persistencia

import ar.edu.unq.epers.model.Auto
import ar.edu.unq.epers.model.Categoria
import ar.edu.unq.epers.model.Empresa
import ar.edu.unq.epers.model.Mensaje
import ar.edu.unq.epers.model.Reserva
import ar.edu.unq.epers.model.Ubicacion
import ar.edu.unq.epers.model.Usuario
import ar.edu.unq.epers.persistencia.cassandra.DbManagerCassandra
import ar.edu.unq.epers.persistencia.hibernate.DBManagerHibernate
import ar.edu.unq.epers.persistencia.mongo.SistemDB
import ar.edu.unq.epers.persistencia.neo4j.DBManagerNeo4j
import java.util.Date
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors class DBManager {
	
	DBManagerHibernate  dbManagerHibernate
	DBManagerNeo4j dbManagerNeo4J
	SistemDB dbManagerMongo
	DbManagerCassandra dbManagerCassandra

	new() {
		dbManagerHibernate = new DBManagerHibernate 
		dbManagerNeo4J = new DBManagerNeo4j
		dbManagerMongo = SistemDB.instance
		dbManagerCassandra = new DbManagerCassandra
	}

	def reservar(Empresa empresa, Reserva reserva) {
		dbManagerHibernate.hacerReserva(empresa, reserva)
	}

	def buscarAutosDisponibles(Ubicacion ubicacion, Date fecha) {
		var busquedaEnCache = dbManagerCassandra.buscarAutos(ubicacion,fecha)
		if(!(busquedaEnCache == null)){
			return pasarDePatenteAAuto(busquedaEnCache.patentesDeAutos)
		}
		else{
			var busquedaEnHibernate = dbManagerHibernate.autosDisponibles(ubicacion, fecha)
			
			dbManagerCassandra.guardarAutos(ubicacion,fecha,pasarDeAutoAPatente(busquedaEnHibernate))
		}
		
	}
	
	def List<Auto> pasarDePatenteAAuto(List<String> patentesDeAutos) {
		//ENTRAR A HIBERNATE BUSCAR LOS DISTITNTOS AUTOS POR LAS PATENTES
		//E IR GUARDANDOLOS EN UNA LISTA DE AUTOS
	}
	
	private def List<String> pasarDeAutoAPatente(List<Auto> autos){
		var List<String> patenteDeAutos = newArrayList
		for(Auto auto : autos){
			patenteDeAutos.add(auto.patente)
		}
		return patenteDeAutos
	}

	def buscaReservasExistentes(Ubicacion ubicacionInicio, Ubicacion ubicacionFin, Date fechaInicio, Date fechaFin,
		Categoria categoria) {
		dbManagerHibernate.reservasExistentes(ubicacionInicio, ubicacionFin, fechaInicio, fechaFin, categoria)
	}

	def crearAmistadEntre(Usuario seguidor, Usuario seguido) {
		dbManagerNeo4J.crearAmistad(seguidor, seguido)
	}

	def buscarAmigosDe(Usuario usuario) {
		dbManagerNeo4J.amigos(usuario)
	}

	def mandarMensaje(Usuario de, Usuario para, Mensaje mensaje) {
		dbManagerNeo4J.enviarMensaje(de, para, mensaje)
	}

	def conexionesDe(Usuario usuario) {
		dbManagerNeo4J.conectadosDe(usuario)
	}
}
