package ar.edu.unq.epers.persistencia.neo4j

import ar.edu.unq.epers.exception.NoSonAmigosException
import ar.edu.unq.epers.model.Mensaje
import ar.edu.unq.epers.model.Usuario
import org.junit.After
import org.junit.Before
import org.junit.Test

import static org.junit.Assert.*

class DBManagerNeoJ4Test{
	
	var DBManagerNeo4j dbManagerNeo4j
	var Usuario lucio
	var Usuario alan
	var Usuario emiliano
	var Usuario pepe
	var Usuario coki
	var Mensaje mensaje01
	var Mensaje mensaje02

	
	@Before
	def void setUp() {
		dbManagerNeo4j = new DBManagerNeo4j
		lucio = new Usuario =>[ id = 1 nombre = "Lucio" apellido = "Francioni" ]
		alan = new Usuario =>[ id = 2 nombre = "Alan" apellido = "Marino" ]
		emiliano = new Usuario =>[ id = 3 nombre = "Emiliano" apellido = "Mancuso" ]
		pepe = new Usuario => [id = 4 nombre = "Pepe" apellido = "Argento"]
		coki = new Usuario => [id = 5 nombre = "Coki" apellido = "Argento"]
		mensaje01 = new Mensaje => [ id = 1 asunto = "Persistencia" cuerpo = "Materia de TPI" ]
		mensaje02 = new Mensaje => [ id = 2 asunto = "Interfaces" cuerpo = "Materia de CPI" ]
		dbManagerNeo4j.crearNodo(lucio)
		dbManagerNeo4j.crearNodo(alan)
		dbManagerNeo4j.crearNodo(emiliano)
		dbManagerNeo4j.crearNodo(pepe)
		dbManagerNeo4j.crearNodo(coki)
	}
	
	@After
	def void after(){
		dbManagerNeo4j.eliminarNodo(lucio)
		dbManagerNeo4j.eliminarNodo(alan)
		dbManagerNeo4j.eliminarNodo(emiliano)
		dbManagerNeo4j.eliminarNodo(pepe)
		dbManagerNeo4j.eliminarNodo(coki)
		dbManagerNeo4j.eliminarNodo(mensaje01)
		dbManagerNeo4j.eliminarNodo(mensaje02)
	}

	@Test
	//Como usuario quiero poder agregar a mis amigos que ya son miembro del sitio. 
	def void usuarioAgregaAmigos() {
		dbManagerNeo4j.crearAmistad(lucio, alan)
		val amigosLucio = dbManagerNeo4j.amigos(lucio)
		val amigosAlan = dbManagerNeo4j.amigos(alan)
		assertEquals(1, amigosLucio.length)
		assertEquals(1, amigosAlan.length)
	}
	
	@Test
	//Como usuario quiero poder consultar a mis amigos.
	def void usuarioConsultaSusAmigos() {
		dbManagerNeo4j.crearAmistad(alan, lucio)
		dbManagerNeo4j.crearAmistad(emiliano, lucio)
		val amigosLucio = dbManagerNeo4j.amigos(lucio)
		
		assertEquals(2, amigosLucio.length)
		assertTrue(amigosLucio.containsAll(#[alan, emiliano]))
	}
	
	@Test
	//Como usuario quiero poder mandar mensajes a mis amigos.
	def void usuarioMandaMensaje() {
		dbManagerNeo4j.crearAmistad(alan, lucio)
		dbManagerNeo4j.enviarMensaje(alan, lucio, mensaje01)
		
		val mensajesRecibidos = dbManagerNeo4j.mensajesRecibidos(lucio)
		val mensajesEnviados = dbManagerNeo4j.mensajesEnviados(alan)
	
		assertEquals(1, mensajesRecibidos.length)
		assertEquals(1, mensajesEnviados.length)
	}
	
	@Test (expected = NoSonAmigosException)
	//Como usuario quiero poder mandar mensajes a mis amigos.
	def void usuarioMandaMensajeSinSerAmigos() {
		dbManagerNeo4j.enviarMensaje(alan, lucio, mensaje01)
	}
	
	@Test
	/* Como usuario quiero poder saber todas las personas con las que estoy conectado, es decir,
	 * sea mis amigos y los amigos de mis amigos recursivamente.
	 */
	def usuarioConsultaAmigosYAmigosDeAmigos() {
		dbManagerNeo4j.crearAmistad(alan, emiliano)
		dbManagerNeo4j.crearAmistad(emiliano, lucio)
		dbManagerNeo4j.crearAmistad(lucio, pepe)
		
		val seguidoresDe = dbManagerNeo4j.conectadosDe(alan)
		
		assertFalse(seguidoresDe.contains(alan))
		assertEquals(3, seguidoresDe.length)
		assertTrue(seguidoresDe.containsAll(#[emiliano, lucio, pepe]))
	} 
	
}