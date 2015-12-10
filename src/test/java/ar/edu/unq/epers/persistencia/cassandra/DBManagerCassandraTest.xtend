package ar.edu.unq.epers.persistencia.cassandra

import ar.edu.unq.epers.model.Auto
import ar.edu.unq.epers.model.Ubicacion
import java.util.Date
import java.util.List
import org.junit.Assert
import org.junit.Before
import org.junit.Test

import static ar.edu.unq.epers.extensions.DateExtensions.*

class DBManagerCassandraTest {
	
//	CacheService SUT
//	Date unaFecha
//	Ubicacion unaUbicacion
//	List<Auto> autos
//	Auto car01;Auto car02;Auto car03
//	Auto car = new Auto()
//	
//	AutoCacheado auto1;AutoCacheado auto2;AutoCacheado auto3;AutoCacheado auto4;AutoCacheado auto5;AutoCacheado auto6
//	List<AutoCacheado> algunosAutos;List<AutoCacheado> otroListado
	
//	@Before
//	def void setUp(){
//		SUT = new CacheService
//		unaFecha = nuevaFecha(1993,12,29)
//		unaUbicacion = new Ubicacion("Avellaneda")
//		autos.add(car01);autos.add(car02);autos.add(car03)
		
//		auto1 = new AutoCacheado => [car.patente = "123 qwe"]
//		auto2 = new AutoCacheado => [car.patente = "283 hjs"]
//		auto3 = new AutoCacheado => [car.patente = "174 kjs"]
//		algunosAutos = newArrayList
//		algunosAutos.add(auto1);algunosAutos.add(auto2);algunosAutos.add(auto3)
//		auto4 = new AutoCacheado => [car.patente = "sdasdsde"]
//		auto5 = new AutoCacheado => [car.patente = "dsddsdass"]
//		auto6 = new AutoCacheado => [car.patente = "NLJWINS"]
//		otroListado = newArrayList
//		otroListado.add(auto4);algunosAutos.add(auto5);algunosAutos.add(auto6)
//	}
	
//	@Test
//	def void test_cacheo_de_datos_funciona_correctamente() {
//		
//		SUT.guardarAutos(autos,unaUbicacion,unaFecha)
//		
//		
//		var List<AutoCacheado> resultado =  SUT.obtenerAutos(unaUbicacion,unaFecha)
//		
//		Assert.assertEquals(resultado,autos)
//	}
	
	/* @Test
	def void test_cacheo_de_datos_nuevos_reemplaza_correctamente() {
		
		SUT.cachear(unaFecha,unaUbicacion,algunosAutos)
		SUT.cachear(unaFecha,unaUbicacion,otroListado)
		algunosAutos.addAll(otroListado)
		
		var BusquedaPorDiaReserva resultado =  SUT.getCached(unaFecha,unaUbicacion)
		
		Assert.assertEquals(resultado.autos , algunosAutos)
	}
	
	@Test
	def void test_autos_cacheados_en_cierta_fecha_son_eliminados_correctamente() {
		
		SUT.cachear(unaFecha,unaUbicacion,algunosAutos)
		var fechaAnterior = nuevaFecha(1993,1,1)
		var fechaPosterior = nuevaFecha(2000,12,12)
		
		SUT.deleteCachedCarBetween(fechaAnterior,fechaPosterior,auto3)
		var resultado = SUT.getCachedCarsBetween(fechaAnterior,fechaPosterior)
		
		Assert.assertTrue(contains(resultado,auto3))
	}
	
	def private contains(List<BusquedaPorDiaReserva> resultado,CachedCar autoQueDebeContener) {
		return resultado.findFirst[each | each.autos.contains(autoQueDebeContener)] == null
	}
	
	@After
	def void limpiar_base_de_datos() {
		SUT.cleanCache
	}*/
}