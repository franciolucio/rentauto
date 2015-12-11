package ar.edu.unq.epers.persistencia.cassandra

import ar.edu.unq.epers.persistencia.DBManager
import ar.edu.unq.epers.persistencia.abstractTest.AbstractTest
import org.junit.After
import org.junit.Assert
import org.junit.Before
import org.junit.Test

import static ar.edu.unq.epers.extensions.DateExtensions.*

class DBManagerCassandraTest extends AbstractTest{
	
	var DBManager dbManager
	
	@Before
	override setUp() {
		this.dbManager = new DBManager()
	 }
	
	@Test
	def void usuarioBuscaAutosDisponiblesEnUnaUbicacionYDeterminadaFecha(){
		dbManager.reservar(empresa, reserva01)
		dbManager.reservar(empresa, reserva02)

		var autosDisponibles01 = dbManager.buscarAutosDisponibles(aeroparque, nuevaFecha(2015, 06, 30))
		// En esa fecha no hay autos disponibles.
		Assert::assertEquals(0, autosDisponibles01.size)
		
		var autosDisponibles02 = dbManager.buscarAutosDisponibles(retiro, nuevaFecha(2015, 04, 11))
		// En esa fecha solo hay un auto reservado(auto02)
		Assert::assertEquals(1, autosDisponibles02.size)
		Assert::assertEquals("Ford", autosDisponibles02.get(0).marca)
		
		var autosDisponibles03 = dbManager.buscarAutosDisponibles(aeroparque, nuevaFecha(2017, 06, 30))
		//En esa fecha los dos autos estan disponibles (auto01 y auto02)
		Assert::assertEquals(2, autosDisponibles03.size)
		Assert::assertEquals("Peugeot", autosDisponibles03.get(0).marca)
		Assert::assertEquals("Ford", autosDisponibles03.get(1).marca)
	}
	
	@After
	def eliminarTablas() {
		dbManager.dbManagerCassandra.session.execute("DROP KEYSPACE IF EXISTS simplex");
		dbManager.dbManagerCassandra.cluster.close();
	}
}