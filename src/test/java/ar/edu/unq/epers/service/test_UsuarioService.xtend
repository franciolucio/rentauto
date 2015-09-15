package ar.edu.unq.epers.test_usuarios

import ar.edu.unq.epers.excepciones_usuarios.NuevaPasswordInvalida
import ar.edu.unq.epers.excepciones_usuarios.UsuarioNoExiste
import ar.edu.unq.epers.excepciones_usuarios.UsuarioYaExiste
import ar.edu.unq.epers.excepciones_usuarios.ValidacionException
import ar.edu.unq.epers.usuarios.Enviador
import ar.edu.unq.epers.usuarios.Home
import ar.edu.unq.epers.usuarios.Mail
import ar.edu.unq.epers.usuarios.Sistema
import ar.edu.unq.epers.usuarios.Usuario
import java.sql.Date
import org.junit.Assert
import org.junit.Before
import org.junit.Test

import static org.mockito.Matchers.*
import static org.mockito.Mockito.*

class test_Sistema {
	var Usuario usuario
	var Home mockHome
	var Enviador mockEnviador
	var Sistema sistema
	
	@Before
	def void setUp() {
		this.usuario = new Usuario("Alan", "Marino", "marinoalan", "1234", "marinoalan@gmail.com", new Date(115,10,12))
																	//Año -> 2015 = 1900 + 115 // Mes -> 11 = 10 + 1 // Dia -> 12
		this.mockHome = mock(Home)
		this.mockEnviador = mock(Enviador)
		this.sistema = new Sistema(mockHome,mockEnviador)
	}
	
	
	@Test
	def test_BienRegistrado() {
		when(this.mockHome.existeUsuario(usuario)).thenReturn(false)
		sistema.registrarUsuario(usuario)
		verify(mockHome).ingresarUsuario(usuario)
	}

	@Test
	def test_MalRegistrado() throws Exception{
		when(this.mockHome.existeUsuario(usuario)).thenReturn(true)
		try {
			sistema.registrarUsuario(usuario)
			Assert.fail()
		}catch (UsuarioYaExiste u){
			u.printStackTrace()
		}
	}
	
	@Test
	def test_NoSePuedeValidarCuenta() throws Exception{
		when(this.mockHome.getUsuarioPorValidacion(usuario.getCodigoDeValidacion())).thenReturn(null)
		try {
			sistema.validarCuenta("CODIGO ERRONEO")
			Assert.fail()
		}catch (ValidacionException v){
			v.printStackTrace()
		}
	}
	
	@Test
	def test_ValidarCuenta() {
		when(this.mockHome.getUsuarioPorValidacion(usuario.getCodigoDeValidacion())).thenReturn(usuario)
		sistema.validarCuenta(usuario.getCodigoDeValidacion())
		Assert::assertEquals(true,this.usuario.getValidado())
	}
	
	@Test
	def test_IngresarUsuario() {
		when(this.mockHome.getUsuarioPorNombreDeUsuario(usuario.getNombreDeUsuario())).thenReturn(usuario)
		Assert::assertEquals(usuario,sistema.ingresarUsuario(usuario.getNombreDeUsuario(),usuario.getPassword()))
	}
	
	@Test
	def test_NoSePuedeIngresarUsuario_PorqueNoExisteUsuario() throws Exception{
		when(this.mockHome.getUsuarioPorNombreDeUsuario(usuario.getNombreDeUsuario())).thenReturn(null)
		try {
			sistema.ingresarUsuario(usuario.getNombreDeUsuario(),usuario.getPassword())
			Assert.fail()
		}catch (UsuarioNoExiste v){
			v.printStackTrace()
		}
	}
	
	@Test
	def test_NoSePuedeIngresarUsuario_PorqueEstaMalLaPassword() throws Exception{
		when(this.mockHome.getUsuarioPorNombreDeUsuario(usuario.getNombreDeUsuario())).thenReturn(usuario)
		try {
			sistema.ingresarUsuario(usuario.getNombreDeUsuario(),"PASSWORD INVALIDO")
			Assert.fail()
		}catch (UsuarioNoExiste v){
			v.printStackTrace()
		}
	}
	
	@Test
	def test_CambiarPassword() {
		when(this.mockHome.getUsuarioPorNombreDeUsuario(usuario.getNombreDeUsuario())).thenReturn(usuario)
		sistema.cambiarPassword(usuario.getNombreDeUsuario(),usuario.getPassword(),"nuevaPassword")
		Assert::assertEquals("nuevaPassword",usuario.getPassword())
	}
	
	@Test
	def test_NoSePuedeCambiarPassword_PorqueNoExisteUsuario() throws Exception{
		when(this.mockHome.getUsuarioPorNombreDeUsuario(usuario.getNombreDeUsuario())).thenReturn(null)
		try {
			sistema.cambiarPassword(usuario.getNombreDeUsuario(),usuario.getPassword(),"nuevaPassword")
			Assert.fail()
		}catch (NuevaPasswordInvalida v){
			v.printStackTrace();
		}
	}
	
	@Test
	def test_NoSePuedeCambiarPassword_PorqueEstaMalLaPassword() throws Exception{
		when(this.mockHome.getUsuarioPorNombreDeUsuario(usuario.getNombreDeUsuario())).thenReturn(usuario)
		try {
			sistema.cambiarPassword(usuario.getNombreDeUsuario(),"PASSWORD INVALIDO","nuevaPassword")
			Assert.fail()
		}catch (NuevaPasswordInvalida v){
			v.printStackTrace()
		}
	}
	
	@Test
	def test_EnviarMail() {
		when(this.mockHome.existeUsuario(usuario)).thenReturn(false)
		sistema.registrarUsuario(usuario)
		verify(this.mockEnviador, times(1)).enviarMail(any(Mail))
	} 
}