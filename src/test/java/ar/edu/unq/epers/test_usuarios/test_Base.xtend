package ar.edu.unq.epers.test_usuarios

import ar.edu.unq.epers.usuarios.Enviador
import ar.edu.unq.epers.usuarios.Home
import ar.edu.unq.epers.usuarios.Sistema
import ar.edu.unq.epers.usuarios.Usuario
import java.sql.Connection
import java.sql.Date
import java.sql.PreparedStatement
import java.sql.ResultSet
import org.junit.Assert
import org.junit.Before
import org.junit.Test

import static org.mockito.Mockito.*

class test_Base {
	var Usuario usuario
	var Home home
	var Enviador mockEnviador
	var Sistema sistema
	
	@Before
	def void setUp() {
		this.usuario = new Usuario("Alan", "Marino", "marinoalan", "1234", "marinoalan@gmail.com", new Date(115,10,12))
																	//Año -> 2015 = 1900 + 115 // Mes -> 11 = 10 + 1 // Dia -> 12
		this.home = new Home()
		this.mockEnviador = mock(Enviador)
		this.sistema = new Sistema(home, mockEnviador)
		
		//Esto sirve para que cada vez que se realiza un test se borre los datos y comience a trabajar con la tabla de Usuarios vacia
		var Connection conn = null
		var PreparedStatement ps = null
		try{
			conn = home.getConnection()
			ps = conn.prepareStatement("DELETE FROM Usuarios")
			ps.execute()
			ps.close()
			}
		finally{
			if(ps != null)
				ps.close()
			if(conn != null)
				conn.close()
		}	
	}
	
	@Test
	def test_registrarUsuario() {
		sistema.registrarUsuario(usuario)
		var Connection conn = null
		var PreparedStatement ps = null
		try{
			conn = home.getConnection()
			ps = conn.prepareStatement("SELECT nombre, apellido FROM Usuarios WHERE nombreDeUsuario = ?")
			ps.setString(1, usuario.getNombreDeUsuario())
			var ResultSet rs = ps.executeQuery()
			while(rs.next()){
				var String nombre = rs.getString("nombre")
				var String apellido = rs.getString("apellido")
				System.out.println("Nombre: " + nombre + " Apellido: " + apellido)
			}
			ps.close()
		}finally{
			if(ps != null)
				ps.close()
			if(conn != null)
				conn.close()
		}
	}
	 
	@Test
	def test_validarCuenta() {
		sistema.registrarUsuario(usuario)
		sistema.validarCuenta(usuario.getCodigoDeValidacion())
		var Connection conn = null
		var PreparedStatement ps = null
		try{
			conn = home.getConnection()
			ps = conn.prepareStatement("SELECT nombre, apellido, validado FROM Usuarios WHERE codigoDeValidacion = ?")
			ps.setString(1, usuario.getCodigoDeValidacion())
			var rs = ps.executeQuery()
			while(rs.next()){
				var String nombre = rs.getString("nombre")
				var String apellido = rs.getString("apellido")
				var Boolean estaValidado = rs.getBoolean("validado")
				System.out.println("Nombre: " + nombre + " Apellido: " + apellido + " Esta validado: " + estaValidado)
			}
			ps.close()
		}finally{
			if(ps != null)
				ps.close()
			if(conn != null)
				conn.close()
		}
	}
	
	@Test
	def void test_ingresarUsuario() {
		sistema.registrarUsuario(usuario);
		Assert::assertEquals(usuario.getNombreDeUsuario(),sistema.ingresarUsuario(usuario.getNombreDeUsuario(),usuario.getPassword()).getNombreDeUsuario());
	}
	
	@Test
	def test_cambiarPassword() {
		sistema.registrarUsuario(usuario)
		sistema.cambiarPassword(usuario.getNombreDeUsuario(),usuario.getPassword(),"nuevaPass")
		var Connection conn = null
		var PreparedStatement ps = null
		try{
			conn = home.getConnection()
			ps = conn.prepareStatement("SELECT nombre, apellido, password FROM Usuarios WHERE nombreDeUsuario = ?")
			ps.setString(1, usuario.getNombreDeUsuario())
			var rs = ps.executeQuery()
			while(rs.next()){
				var String nombre = rs.getString("nombre")
				var String apellido = rs.getString("apellido")
				var String password = rs.getString("password")
				System.out.println("Nombre: " + nombre + " Apellido: " + apellido + " Password: " + password)
			}
			ps.close()
		}finally{
			if(ps != null)
				ps.close()
			if(conn != null)
				conn.close()
		}
	}
}