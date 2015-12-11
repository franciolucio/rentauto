package ar.edu.unq.epers.persistencia.cassandra

import ar.edu.unq.epers.model.Ubicacion
import com.datastax.driver.core.Cluster
import com.datastax.driver.core.Session
import com.datastax.driver.mapping.Mapper
import com.datastax.driver.mapping.MappingManager
import java.util.Date
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class DbManagerCassandra 	{
	Cluster cluster
	Session session
	Mapper<BusquedaAutosDisponibles> busquedas

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
		
		busquedas = new MappingManager(session).mapper(BusquedaAutosDisponibles);
	}

	def connect() {
		cluster = Cluster.builder().addContactPoint("localhost").build();
		session = cluster.connect();
	}
	
	def buscarAutos(Ubicacion ubicacion, Date fecha) {
		busquedas.get(ubicacion,fecha)
	}
	
	def guardarAutos(Ubicacion ub, Date fe, List<String> pat) {
		var busqueda = new BusquedaAutosDisponibles => [
			ubicacion = ub
			fecha = fe
			patentesDeAutos = pat
		]
		busquedas.save(busqueda)
	}
	
	private def Boolean between (Date fecha, Date fechaInicio, Date fechaFin){
		return (fecha.before(fechaFin) || fecha.equals(fechaFin)) && (fecha.after(fechaInicio) || fecha.equals(fechaInicio))
	}
	
	def actualizarCache(String patente, Date fechaInicio, Date fechaFin, Ubicacion destino){
		for(BusquedaAutosDisponibles b : busquedas){ 					//recorro las busquedas de autos disponibles para una fecha y ubicacion
			if(this.between(b.fecha,fechaInicio, fechaFin)) 			//veo si la fecha esta entre la de inicio y fin
				b.patentesDeAutos.remove(patente)						//si lo esta, elimino la patente del auto para esa fecha
			else{														//sino
				if (b.fecha.after(fechaFin) && destino != b.ubicacion)	//reviso las busquedas de los autos para las fechas posteriores a la fecha de fin y veo si la ubicacion es distinta del destino del auto
					b.patentesDeAutos.remove(patente)					//si lo esta, elimino la patente del auto para esa fecha
			}
		}		
	}
}