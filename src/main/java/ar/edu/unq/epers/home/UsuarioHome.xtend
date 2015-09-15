package ar.edu.unq.epers.usuarios

import java.sql.Connection
import java.sql.DriverManager
import java.sql.PreparedStatement
import java.sql.ResultSet

class Home {
	
	new(){
		
	}
	
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
		}
		finally{
			if(ps != null)
				ps.close()
			if(conn != null)
				conn.close()
		}
	}
	
	
	def ingresarUsuario(Usuario usuarioNuevo) {
		var Connection conn = null
		var PreparedStatement ps = null
		try{
			conn = this.getConnection()
			ps = conn.prepareStatement("INSERT INTO Usuarios (nombre, apellido, nombreDeUsuario, password, email, fechaDeNacimiento, codigoDeValidacion) VALUES (?,?,?,?,?,?,?)")
			ps.setString(1, usuarioNuevo.getNombre())
			ps.setString(2, usuarioNuevo.getApellido())
			ps.setString(3, usuarioNuevo.getNombreDeUsuario())
			ps.setString(4, usuarioNuevo.getPassword())
			ps.setString(5, usuarioNuevo.getEmail())
			ps.setDate(6, usuarioNuevo.getFechaDeNacimiento())
			ps.setString(7, usuarioNuevo.getCodigoDeValidacion())
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
	
	
	def getUsuarioPorValidacion(String codigo) {
		var Connection conn = null
		var PreparedStatement ps = null
		try{
			conn = this.getConnection()
			ps = conn.prepareStatement("SELECT * FROM Usuarios WHERE codigoDeValidacion = ?")
			ps.setString(1, codigo)
			val rs = ps.executeQuery()
			if (rs.next){
				var usuario = new Usuario (rs.getString("nombre"), rs.getString("apellido"), rs.getString("nombreDeUsuario"), rs.getString("password"), rs.getString("email"), rs.getDate("fechaDeNacimiento"))
				return usuario
			}
			else{
				return null
			}
		}
		finally{
			if(ps != null)
				ps.close()
			if(conn != null)
				conn.close()
		}
	}
	
	def getUsuarioPorNombreDeUsuario(String userName) {
		var Connection conn = null
		var PreparedStatement ps = null
		try{
			conn = this.getConnection()
			ps = conn.prepareStatement("SELECT * FROM Usuarios WHERE nombreDeUsuario = ?")
			ps.setString(1, userName)
			val rs = ps.executeQuery()
			if (rs.next){
				var usuario = new Usuario (rs.getString("nombre"), rs.getString("apellido"), rs.getString("nombreDeUsuario"), rs.getString("password"), rs.getString("email"), rs.getDate("fechaDeNacimiento"))
				return usuario
			}
			else{
				return null
			}
		}
		finally{
			if(ps != null)
				ps.close()
			if(conn != null)
				conn.close()
		}
	}
	
	def actualizar(Usuario usuario) {
		var Connection conn = null
		var PreparedStatement ps = null
		try{
			conn = this.getConnection()
			ps = conn.prepareStatement("UPDATE Usuarios SET nombre=?, apellido=?, email=?, password=?, fechaDeNacimiento=?, validado=? WHERE nombreDeUsuario = ?")
			ps.setString(1, usuario.getNombre())
			ps.setString(2, usuario.getApellido())
			ps.setString(3, usuario.getEmail())
			ps.setString(4, usuario.getPassword())
			ps.setDate(5, usuario.getFechaDeNacimiento())
			ps.setBoolean(6, usuario.getValidado())
			ps.setString(7, usuario.getNombreDeUsuario())
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
	
	def Connection getConnection() throws Exception {
		Class.forName("com.mysql.jdbc.Driver")
		return DriverManager.getConnection("jdbc:mysql://localhost/Persistencia?user=root&password=1234")
	}
	
}