package ar.edu.unq.epers.home.rentauto

import ar.edu.unq.epers.service.ServiceRentauto
import org.junit.Assert
import org.junit.Before
import org.junit.Test

import static ar.edu.unq.epers.extensions.DateExtensions.*

class HomeRentautoTest extends SetUpGeneral{
	
	var ServiceRentauto service

	@Before
	def void SetUp(){
		service = new ServiceRentauto()
	}
	
	@Test
	def void usuarioReservaUnAuto(){
		service.hacerReserva(empresa, reserva01)
		var reservaObtenida = service.obtenerReserva(1)
		
		Assert::assertEquals("Retiro",reservaObtenida.origen.nombre)
		Assert::assertEquals("Aeroparque",reservaObtenida.destino.nombre)
		Assert::assertEquals(nuevaFecha(2015, 03, 01),reservaObtenida.inicio)
		Assert::assertEquals(nuevaFecha(2015, 07, 01),reservaObtenida.fin)
		Assert::assertEquals("Peugeot",reservaObtenida.auto.marca)
	}
	
	@Test
	def void usuarioBuscaAutosDisponiblesEnUnaUbicacionYDeterminadaFecha(){
		service.hacerReserva(empresa, reserva01)
		service.hacerReserva(empresa, reserva02)

		var autosDisponibles01 = service.autosDisponibles(aeroparque, nuevaFecha(2015, 06, 30))
		// En esa fecha no hay autos disponibles.
		Assert::assertEquals(0, autosDisponibles01.size)
		
		var autosDisponibles02 = service.autosDisponibles(retiro, nuevaFecha(2015, 04, 11))
		// En esa fecha solo hay un auto reservado(auto02)
		Assert::assertEquals(1, autosDisponibles02.size)
		Assert::assertEquals("Ford", autosDisponibles02.get(0).marca)
		
		var autosDisponibles03 = service.autosDisponibles(aeroparque, nuevaFecha(2017, 06, 30))
		//En esa fecha los dos autos estan disponibles (auto01 y auto02)
		Assert::assertEquals(2, autosDisponibles03.size)
		Assert::assertEquals("Peugeot", autosDisponibles03.get(0).marca)
		Assert::assertEquals("Ford", autosDisponibles03.get(1).marca)
	}
	
	@Test
	def void usuarioBuscaLasReservasExistentes(){
		service.hacerReserva(empresa, reserva01)
		service.hacerReserva(empresa, reserva02)
		
		var reservasExistentes01 = service.reservasExistentes(null, null, null , null, categoriaFamiliar)
		//Solo hay reserva posible para los datos buscados (reserva01)
		Assert::assertEquals(1, reservasExistentes01.size)
		Assert::assertEquals("Peugeot", reservasExistentes01.get(0).auto.marca)
		
		var reservasExistentes02 = service.reservasExistentes(null, null, null , null, categoriaDeportivo)
		//Solo hay una reserva posible para los datos buscados (reserva02)
		Assert::assertEquals(1, reservasExistentes02.size)
		Assert::assertEquals("Ford", reservasExistentes02.get(0).auto.marca)
		
		var reservasExistentes03 = service.reservasExistentes(retiro, null, null, null, null)
		//En este caso filtro por la ubicacion inicial en este caso estan la reserva01 y reserva02
		Assert::assertEquals(2, reservasExistentes03.size)
	}
}