package ar.edu.unq.epers.persistencia.cassandra

import ar.edu.unq.epers.model.Ubicacion
import com.datastax.driver.core.Cluster
import com.datastax.driver.core.Session
import com.datastax.driver.mapping.Mapper
import com.datastax.driver.mapping.MappingManager
import java.util.Date
import java.util.List

class DbManagerCassandra 	{
	Cluster cluster
	Session session
	Mapper<BusquedaAutosDisponibles> mapper

	def createSchema() {
		session.execute("CREATE KEYSPACE IF NOT EXISTS  simplex WITH replication = {'class':'SimpleStrategy', 'replication_factor':3};")

		session.execute("CREATE TYPE IF NOT EXISTS simplex.auto (" +
			"ubicacion text," + 
			"fecha text," +
			"patenetesDeAutos text);"
		)

		session.execute("CREATE TABLE IF NOT EXISTS simplex.BusquedaPorDia (" + 
			"ubicacion text, " + 
			"fecha text, " +
			"patenetesDeAutos list< frozen<String>>," + 
			"PRIMARY KEY (ubicacion, fecha));"
		)
		
		mapper = new MappingManager(session).mapper(BusquedaAutosDisponibles);
	}

	def connect() {
		cluster = Cluster.builder().addContactPoint("localhost").build();
		session = cluster.connect();
	}
	
	def buscarAutos(Ubicacion ubicacion, Date fecha) {
		mapper.get(ubicacion,fecha)
	}
	
	def guardarAutos(Ubicacion ub, Date fe, List<String> pat) {
		var busqueda = new BusquedaAutosDisponibles => [
			ubicacion = ub
			fecha = fe
			patentesDeAutos = pat
		]
		mapper.save(busqueda)
	}
}