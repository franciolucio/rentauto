package ar.edu.unq.epers.persistencia.mongo

import ar.edu.unq.epers.persistencia.abstractTest.AbstractTest
import ar.edu.unq.epers.persistencia.neo4j.DBManagerNeo4j
import org.junit.After
import org.junit.Before
import org.junit.Test
import static org.junit.Assert.*

class DBManagerMongoTest extends AbstractTest{
	
	CentroDeCalificacionDeAutos centroDeCalificacionDeAutos
	AutoCalificado autoCalificado
	DBManagerNeo4j dbManagerNeo4j
	Calificacion calificacionPublica
	Calificacion calificacionPrivada
	Calificacion calificacionSoloAmigos
	
	@Before
	def void setup(){
		centroDeCalificacionDeAutos = new CentroDeCalificacionDeAutos()
		autoCalificado = new AutoCalificado => [
			patente = "NSJ000"
		]
		
		calificacionPublica = new Calificacion => [
			calificacion = NivelCalificacion.BUENO
			comentario = "Auto comodo y buen consumo"
			privacidad = NivelPrivacidad.PUBLICO
		]
		
		calificacionPrivada = new Calificacion => [
			calificacion = NivelCalificacion.MALO 
			comentario = "El auto no tenia nafta y andaba lento"
			privacidad = NivelPrivacidad.PRIVADO
		]
		
		calificacionSoloAmigos = new Calificacion => [
			calificacion = NivelCalificacion.BUENO 
			comentario = "Buen manejo y alineacion"
			privacidad = NivelPrivacidad.SOLOAMIGOS
		]
		
		dbManagerNeo4j = new DBManagerNeo4j
		
		lucio.id = 1
		alan.id = 2
		emiliano.id = 3
		pepe.id = 4
		coki.id = 5
		
		dbManagerNeo4j.crearNodo(lucio)
		dbManagerNeo4j.crearNodo(alan)
		dbManagerNeo4j.crearNodo(emiliano)
		dbManagerNeo4j.crearNodo(pepe)
		dbManagerNeo4j.crearNodo(coki)
		dbManagerNeo4j.crearAmistad(alan,pepe)
		dbManagerNeo4j.crearAmistad(pepe,emiliano)
		centroDeCalificacionDeAutos.dbManagerNeo4j = dbManagerNeo4j
	
	}
	
	@Test
	def	calificarAuto(){
		centroDeCalificacionDeAutos.calificarAuto(lucio,autoCalificado,calificacionPrivada)
		var calificacionDeAuto = centroDeCalificacionDeAutos.getAutosCalificadosPorPatente("NSJ000")
		assertEquals("NSJ000",calificacionDeAuto.get(0).patente)
		
	}
	
	@Test
	def publicacionesDeUnAmigo(){
		centroDeCalificacionDeAutos.calificarAuto(pepe,autoCalificado,calificacionPrivada)
		centroDeCalificacionDeAutos.calificarAuto(pepe,autoCalificado,calificacionPublica)
		centroDeCalificacionDeAutos.calificarAuto(pepe,autoCalificado,calificacionSoloAmigos)
		var publicaciones = centroDeCalificacionDeAutos.publicaciones(alan,pepe)
		
		assertEquals(2,publicaciones.size)
	}
	
	@Test
	def publicacionesDeUnNoAmigo(){
		centroDeCalificacionDeAutos.calificarAuto(coki,autoCalificado,calificacionPrivada)
		centroDeCalificacionDeAutos.calificarAuto(coki,autoCalificado,calificacionPublica)
		centroDeCalificacionDeAutos.calificarAuto(coki,autoCalificado,calificacionSoloAmigos)
		var publicaciones = centroDeCalificacionDeAutos.publicaciones(alan,coki)
		
		assertEquals(1,publicaciones.size)
	}
	
	@Test
	def publicacionesDeUnoMismo(){
		centroDeCalificacionDeAutos.calificarAuto(alan,autoCalificado,calificacionPrivada)
		centroDeCalificacionDeAutos.calificarAuto(alan,autoCalificado,calificacionPublica)
		centroDeCalificacionDeAutos.calificarAuto(alan,autoCalificado,calificacionSoloAmigos)
		var publicaciones = centroDeCalificacionDeAutos.publicaciones(alan,alan)
		
		assertEquals(3,publicaciones.size)
	}
	
	@After
	def void cleanDB() {
		centroDeCalificacionDeAutos.drop
	}
	
}