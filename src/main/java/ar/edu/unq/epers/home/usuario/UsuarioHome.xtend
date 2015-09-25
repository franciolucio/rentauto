package ar.edu.unq.epers.home.usuario

import ar.edu.unq.epers.service.Usuario
import java.sql.Connection
import java.sql.DriverManager
import java.sql.PreparedStatement
import java.sql.ResultSet
import java.sql.SQLException

class UsuarioHome {
	
	new(){
		
	}
	/**
  		* El UsuarioHome verifica si ya existe ese usuarioNuevo en la base de datos
  		* @param usuarioNuevo - el objeto Usuario para verificar si ya esta en 
  		* la base de datos.
		*/
	def Boolean existeUsuario(Usuario usuarioNuevo) {
		var Connection conn = null
		var PreparedStatement ps = null
		try{
			conn = this.getConnection()
			ps = conn.prepareStatement("SELECT COUNT(*) AS existe FROM Usuarios WHERE nombreDeUsuario = ?")
			ps.setString(1, usuarioNuevo.getNombreDeUsuario())
			var ResultSet rs = ps.executeQuery()
			var int existe
			rs.next()
				existe = rs.getInt("existe")
			ps.close()
			return existe == 1
		}catch (Exception e) {
   			throw new SQLException("El usuario no existe en la base de datos", e)
   			}
		finally{
			if(ps != null)
				ps.close()
			if(conn != null)
				conn.close()
		}
	}
	
	/**
  		* El UsuarioHome nos devuelve un usuario segun los parametros solicitados
  		* @param propiedad - corresponde al valor que se le va a setear para 
  		* realizar la consulta, valor - dicho parametro nos permite seleccionar a 
  		* los usuarios por dicho valor.
		*/
	def getUsuarioPor(String propiedad, String valor) {
		var Connection conn = null
		var PreparedStatement ps = null
		try{
			conn = this.getConnection()
			ps = conn.prepareStatement("SELECT * FROM Usuarios WHERE " + valor + " = ?")
			ps.setString(1, propiedad)
			val rs = ps.executeQuery()
			if (rs.next){
				var usuario = new Usuario (rs.getString("nombre"), rs.getString("apellido"), rs.getString("nombreDeUsuario"), rs.getString("password"), rs.getString("email"), rs.getDate("fechaDeNacimiento"))
				usuario.codigoDeValidacion = rs.getString("codigoDeValidacion")				
				return usuario
			}
			else{
				return null
			}
		}catch (Exception e) {
   			throw new SQLException("No se encontro dicho usuario", e)
   			}
		finally{
			if(ps != null)
				ps.close()
			if(conn != null)
				conn.close()
		}
	}
	
	/**
  		* El UsuarioHome hace un efecto en la tabla segun la consulta que uno 
  		* realice
  		* @param usuario - corresponde al a que usuario se le va aplicar la consulta
  		* consultaSQL - dicho parametro nos permite realizar una consulta SQL para  
  		* realizar una accion.
		*/
	def actualizar(Usuario usuario, String consultaSQL) {
		var Connection conn = null
		var PreparedStatement ps = null
		try{
			conn = this.getConnection()
			ps = conn.prepareStatement(consultaSQL)
			ps.setString(1, usuario.getNombre())
			ps.setString(2, usuario.getApellido())
			ps.setString(3, usuario.getPassword())
			ps.setString(4, usuario.getEmail())
			ps.setDate(5, usuario.getFechaDeNacimiento())
			ps.setString(6, usuario.getCodigoDeValidacion())
			ps.setBoolean(7, usuario.getValidado())
			ps.setString(8, usuario.getNombreDeUsuario())
			ps.execute()
			ps.close()
		}catch (Exception e) {
   			throw new SQLException("No se puede hacer dicha consulta", e)
   			}
		finally{
			if(ps != null)
				ps.close()
			if(conn != null)
				conn.close()
		}
	
	}
	
	/**
  		* El UsuarioHome hace un INSERT en la tabla segun lo deseado
		*/
	def insertar() {
		"INSERT INTO Usuarios (nombre, apellido, password, email , fechaDeNacimiento, codigoDeValidacion, validado,nombreDeUsuario) VALUES (?,?,?,?,?,?,?,?)"
		}
	
	/**
  		* El UsuarioHome hace un UPDATE en la tabla segun lo deseado
		*/
	def update() {
		"UPDATE Usuarios SET nombre=?, apellido=?, password=?, email=?, fechaDeNacimiento=?, codigoDeValidacion = ?, validado=? WHERE nombreDeUsuario = ?"
	}
	
	def Connection getConnection() throws Exception {
		Class.forName("com.mysql.jdbc.Driver")
		return DriverManager.getConnection("jdbc:mysql://localhost/Persistencia?user=root&password=1234")
	}
	
	
	
}