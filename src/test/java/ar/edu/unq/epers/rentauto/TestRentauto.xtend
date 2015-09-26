package ar.edu.unq.epers.rentauto

import ar.edu.unq.epers.homes.rentauto.ManejadorDeHomes
import org.junit.Assert
import org.junit.Before
import org.junit.Test

import static ar.edu.unq.epers.extensions.DateExtensions.*

class TestRentauto extends SetUpGeneral{
	
	var ManejadorDeHomes manejadorDeHomes
	
	
	@Before
	def void SetUp(){
		manejadorDeHomes = new ManejadorDeHomes()
	}
	
	@Test
	def void usuarioReservaUnAuto(){
		manejadorDeHomes.hacerReserva(empresa, reserva01)
		var reservaObtenida = manejadorDeHomes.obtenerReserva(1)
		
		Assert::assertEquals("Retiro",reservaObtenida.origen.nombre)
		Assert::assertEquals("Aeroparque",reservaObtenida.destino.nombre)
		Assert::assertEquals(nuevaFecha(2015, 03, 01),reservaObtenida.inicio)
		Assert::assertEquals(nuevaFecha(2015, 03, 05),reservaObtenida.fin)
		Assert::assertEquals("Peugeot",reservaObtenida.auto.marca)
		
	}
	
	@Test
	def void usuarioBuscaAutosDisponiblesEnUnaUbicacionYDeterminadaFecha(){
		manejadorDeHomes.hacerReserva(empresa, reserva01)
		manejadorDeHomes.hacerReserva(empresa, reserva02)
		
		var autosDisponibles01 = manejadorDeHomes.autosDisponibles(retiro, nuevaFecha(2015, 01, 01))
		// En esa fecha no hay reservas para ninguno de los dos autos
		Assert::assertEquals(2, autosDisponibles01.size)
		
		var autosDisponibles02 = manejadorDeHomes.autosDisponibles(retiro, nuevaFecha(2015, 04, 11))
		// En esa fecha solo hay un auto reservado(auto01)
		Assert::assertEquals(1, autosDisponibles02.size)
		
		var autosDisponibles03 = manejadorDeHomes.autosDisponibles(retiro, nuevaFecha(2015, 06, 30))
		//En esa fecha los dos autos estan reservados (auto01 y auto02)
		Assert::assertEquals(0, autosDisponibles03.size)
		
	}
	
	@Test
	def void usuarioBuscaAutosPosibles(){
		manejadorDeHomes.hacerReserva(empresa, reserva01)
		manejadorDeHomes.hacerReserva(empresa, reserva02)
		
		var autosPosibles = manejadorDeHomes.autosPosibles(retiro, aeroparque, nuevaFecha(2015, 03, 01), nuevaFecha(2015, 06, 24), categoriaFamiliar)
		//Solo hay un auto posible para los datos buscados (auto01)
		Assert::assertEquals(1, autosPosibles.size)
	}
}
	
