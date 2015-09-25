package ar.edu.unq.epers.service

import ar.edu.unq.epers.exception.NuevaPasswordInvalida
import ar.edu.unq.epers.exception.UsuarioNoExiste
import ar.edu.unq.epers.exception.UsuarioYaExiste
import ar.edu.unq.epers.exception.ValidacionException
import ar.edu.unq.epers.generadorDeCodigo.GeneradorDeCodigo
import ar.edu.unq.epers.home.usuario.UsuarioHome
import ar.edu.unq.epers.mailing.Enviador
import ar.edu.unq.epers.mailing.Mail
import java.sql.Date
import org.junit.Assert
import org.junit.Before
import org.junit.Test

import static org.mockito.Matchers.*
import static org.mockito.Mockito.*

class test_UsuarioService {
	var Usuario usuario
	var UsuarioHome mockHome
	var Enviador mockEnviador
	var UsuarioService sistema
	var GeneradorDeCodigo mockGeneradorDeCodigo
	
	@Before
	def void setUp() {
		this.usuario = new Usuario("Alan", "Marino", "marinoalan", "1234", "marinoalan@gmail.com", new Date(115,10,12))
																	//Año -> 2015 = 1900 + 115 // Mes -> 11 = 10 + 1 // Dia -> 12
		this.mockHome = mock(UsuarioHome)
		this.mockEnviador = mock(Enviador)
		this.mockGeneradorDeCodigo = mock(GeneradorDeCodigo)
		this.sistema = new UsuarioService(mockHome, mockEnviador,mockGeneradorDeCodigo)
	}
	
	
	@Test
	def test_BienRegistrado() {
		when(this.mockHome.existeUsuario(usuario)).thenReturn(false)
		sistema.registrarUsuario(usuario)
		verify(mockHome).actualizar(usuario,this.mockHome.insertar())
	}

	@Test (expected = UsuarioYaExiste )
	def test_MalRegistrado() throws Exception{
		when(this.mockHome.existeUsuario(usuario)).thenReturn(true)
		sistema.registrarUsuario(usuario)
		Assert.fail()
	}
	
	@Test (expected = ValidacionException )
	def test_NoSePuedeValidarCuenta() throws Exception{
		when(this.mockHome.getUsuarioPor(usuario.getCodigoDeValidacion(),"codigoDeValidacion")).thenReturn(null)
		sistema.validarCuenta("CODIGO ERRONEO")
		Assert.fail()
	}
	
	@Test
	def test_ValidarCuenta() {
		when(this.mockHome.getUsuarioPor(usuario.getCodigoDeValidacion(),"codigoDeValidacion")).thenReturn(usuario)
		sistema.validarCuenta(usuario.getCodigoDeValidacion())
		Assert::assertEquals(true,this.usuario.getValidado())
	}
	
	@Test
	def test_IngresarUsuario() {
		when(this.mockHome.getUsuarioPor(usuario.getNombreDeUsuario(),"nombreDeUsuario")).thenReturn(usuario)
		Assert::assertEquals(usuario,sistema.ingresarUsuario(usuario.getNombreDeUsuario(),usuario.getPassword()))
	}
	
	@Test (expected = UsuarioNoExiste )
	def test_NoSePuedeIngresarUsuario_PorqueNoExisteUsuario() throws Exception{
		when(this.mockHome.getUsuarioPor(usuario.getNombreDeUsuario(),"nombreDeUsuario")).thenReturn(null)
		sistema.ingresarUsuario(usuario.getNombreDeUsuario(),usuario.getPassword())
		Assert.fail()
	}
	
	@Test (expected = UsuarioNoExiste )
	def test_NoSePuedeIngresarUsuario_PorqueEstaMalLaPassword() throws Exception{
		when(this.mockHome.getUsuarioPor(usuario.getNombreDeUsuario(),"nombreDeUsuario")).thenReturn(usuario)
		sistema.ingresarUsuario(usuario.getNombreDeUsuario(),"PASSWORD INVALIDO")
			Assert.fail()
	}
	
	@Test
	def test_CambiarPassword() {
		when(this.mockHome.getUsuarioPor(usuario.getNombreDeUsuario(),"nombreDeUsuario")).thenReturn(usuario)
		sistema.cambiarPassword(usuario.getNombreDeUsuario(),usuario.getPassword(),"nuevaPassword")
		Assert::assertEquals("nuevaPassword",usuario.getPassword())
	}
	
	@Test(expected = NuevaPasswordInvalida )
	def test_NoSePuedeCambiarPassword_PorqueNoExisteUsuario() {
		when(this.mockHome.getUsuarioPor(usuario.getNombreDeUsuario(),"nombreDeUsuario")).thenReturn(null)
		sistema.cambiarPassword(usuario.getNombreDeUsuario(),usuario.getPassword(),"nuevaPassword")
		Assert.fail()
	}
	
	@Test(expected = NuevaPasswordInvalida )
	def test_NoSePuedeCambiarPassword_PorqueEstaMalLaPassword() {
		when(this.mockHome.getUsuarioPor(usuario.getNombreDeUsuario(),"nombreDeUsuario")).thenReturn(usuario)
			sistema.cambiarPassword(usuario.getNombreDeUsuario(),"PASSWORD INVALIDO","nuevaPassword")
			Assert.fail()
		}
	
	@Test
	def test_EnviarMail() {
		when(this.mockHome.existeUsuario(usuario)).thenReturn(false)
		sistema.registrarUsuario(usuario)
		verify(this.mockEnviador, times(1)).enviarMail(any(Mail))
	} 
}