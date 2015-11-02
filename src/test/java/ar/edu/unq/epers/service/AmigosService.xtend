package ar.edu.unq.epers.service

import ar.edu.unq.epers.exception.NoSonAmigosException
import ar.edu.unq.epers.model.Mensaje
import ar.edu.unq.epers.service.Usuario
import org.junit.After
import static org.junit.Assert.*
import org.junit.Before
import org.junit.Test

class AmigosService {
	
	Usuario lucio
	Usuario alan
	Usuario emiliano
	Usuario pepe
	Usuario coki
	GraphService graphService
	Mensaje mensaje01
	Mensaje mensaje02
	
	@Before
	def void setUp() {
		lucio = new Usuario =>[ id = 1 nombre = "Lucio" apellido = "Francioni" ]
		alan = new Usuario =>[ id = 2 nombre = "Alan" apellido = "Marino" ]
		emiliano = new Usuario =>[ id = 3 nombre = "Emiliano" apellido = "Mancuso" ]
		pepe = new Usuario => [id = 4 nombre = "Pepe" apellido = "Argento"]
		coki = new Usuario => [id = 4 nombre = "Coki" apellido = "Argento"]
		mensaje01 = new Mensaje => [ id = 1 asunto = "Persistencia" cuerpo = "Materia de TPI" ]
		mensaje02 = new Mensaje => [ id = 2 asunto = "Interfaces" cuerpo = "Materia de CPI" ]
		graphService = new GraphService
		graphService.crearNodo(lucio)
		graphService.crearNodo(alan)
		graphService.crearNodo(emiliano)
		graphService.crearNodo(pepe)
		graphService.crearNodo(coki)
	}
	
	@After
	def void after(){
		graphService.eliminarNodo(lucio)
		graphService.eliminarNodo(alan)
		graphService.eliminarNodo(emiliano)
		graphService.eliminarNodo(pepe)
		graphService.eliminarNodo(coki)
		graphService.eliminarNodo(mensaje01)
		graphService.eliminarNodo(mensaje02)
	}

	@Test
	//Como usuario quiero poder agregar a mis amigos que ya son miembro del sitio. 
	def void usuarioAgregaAmigos() {
		graphService.crearAmistad(lucio, alan)
		val amigosLucio = graphService.amigos(lucio)
		val amigosAlan = graphService.amigos(alan)
		assertEquals(1, amigosLucio.length)
		assertEquals(1, amigosAlan.length)
	}
	
	@Test
	//Como usuario quiero poder consultar a mis amigos.
	def void usuarioConsultaSusAmigos() {
		graphService.crearAmistad(alan, lucio)
		graphService.crearAmistad(emiliano, lucio)
		val amigosLucio = graphService.amigos(lucio)
		
		assertEquals(2, amigosLucio.length)
		assertTrue(amigosLucio.containsAll(#[alan, emiliano]))
	}
	
	@Test
	//Como usuario quiero poder mandar mensajes a mis amigos.
	def void usuarioMandaMensaje() {
		graphService.crearAmistad(alan, lucio)
		graphService.enviarMensaje(alan, lucio, mensaje01)
		
		val mensajesRecibidos = graphService.mensajesRecibidos(lucio)
		val mensajesEnviados = graphService.mensajesEnviados(alan)
	
		assertEquals(1, mensajesRecibidos.length)
		assertEquals(1, mensajesEnviados.length)
	}
	
	@Test (expected = NoSonAmigosException)
	//Como usuario quiero poder mandar mensajes a mis amigos.
	def void usuarioMandaMensajeSinSerAmigos() {
		graphService.enviarMensaje(alan, lucio, mensaje01)
	}
	
	@Test
	/* Como usuario quiero poder saber todas las personas con las que estoy conectado, es decir,
	 * sea mis amigos y los amigos de mis amigos recursivamente.
	 */
	def usuarioConsultaAmigosYAmigosDeAmigos() {
		graphService.crearAmistad(alan, emiliano)
		graphService.crearAmistad(emiliano, lucio)
		graphService.crearAmistad(lucio, pepe)
		
		val seguidoresDe = graphService.conectadosDe(alan)
		
		assertFalse(seguidoresDe.contains(alan))
		assertEquals(3, seguidoresDe.length)
		assertTrue(seguidoresDe.containsAll(#[emiliano, lucio, pepe]))
	} 
	
}