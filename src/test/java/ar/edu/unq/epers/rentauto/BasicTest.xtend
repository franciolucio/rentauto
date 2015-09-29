package ar.edu.unq.epers.rentauto

import ar.edu.unq.epers.homes.rentauto.ManejadorDeHomes
import org.junit.Assert
import org.junit.Before
import org.junit.Test

class BasicTest extends SetUpGeneral {
	
	var ManejadorDeHomes manejadorDeHomes
	
	
	@Before
	def void SetUp(){
		manejadorDeHomes = new ManejadorDeHomes()
	}
	
	@Test
	def agregarAuto() {
		this.manejadorDeHomes.guardarAuto(auto01)
		Assert:: assertEquals("OPQ231",this.manejadorDeHomes.getAuto(auto01.id).patente)
	}
	
	@Test
	def agregarEmpresa() {
		this.manejadorDeHomes.guardarEmpresa(empresa)
		Assert:: assertEquals("Empresa Somos Nosotros",this.manejadorDeHomes.getEmpresa(empresa.id).nombreEmpresa)
	}

}