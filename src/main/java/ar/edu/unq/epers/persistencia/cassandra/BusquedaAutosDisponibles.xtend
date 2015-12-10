package ar.edu.unq.epers.persistencia.cassandra

import ar.edu.unq.epers.model.Ubicacion
import com.datastax.driver.mapping.annotations.FrozenValue
import com.datastax.driver.mapping.annotations.PartitionKey
import com.datastax.driver.mapping.annotations.Table
import java.util.Date
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
@Table(keyspace = "simplex", name = "busquedaAutosDisponibles")
class BusquedaAutosDisponibles {

	@PartitionKey()
    Ubicacion ubicacion
    @PartitionKey(1)
	Date fecha
	@FrozenValue
	List<String> patentesDeAutos
}