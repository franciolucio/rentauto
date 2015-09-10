package ar.edu.unq.epers.usuarios

import ar.edu.unq.epers.excepciones_usuarios.NuevaPasswordInvalida
import ar.edu.unq.epers.excepciones_usuarios.UsuarioNoExiste
import ar.edu.unq.epers.excepciones_usuarios.UsuarioYaExiste
import ar.edu.unq.epers.excepciones_usuarios.ValidacionException

class Sistema {
	
	var Home home
	var Enviador enviador
	
	new (Home home, Enviador enviador){
		this.home = home
		this.enviador = enviador
  	}
	
	def registrarUsuario (Usuario usuarioNuevo) throws UsuarioYaExiste{
		if (this.home.existeUsuario(usuarioNuevo))
			throw new UsuarioYaExiste()
		usuarioNuevo.setCodigoDeValidacion(usuarioNuevo.getNombreDeUsuario+Math.random())
		this.home.ingresarUsuario(usuarioNuevo)
		this.enviador.enviarMail(new Mail("El codigo de Verificacion es: "+ usuarioNuevo.getCodigoDeValidacion(),"Nuevo Usuario",usuarioNuevo.getEmail(),"Sistema"))
	}
	
	def validarCuenta (String codigoValidacion) throws ValidacionException{
		val usuario = this.home.getUsuarioPorValidacion(codigoValidacion)
		if (usuario == null)
			throw new ValidacionException()
		usuario.validate()
		this.home.actualizar(usuario)
	}
	
	def ingresarUsuario (String userName, String password) throws UsuarioNoExiste{
		val usuario = this.home.getUsuarioPorNombreDeUsuario(userName)
		if (usuario != null && usuario.getPassword == password)
			return usuario	
		else
			throw new UsuarioNoExiste()
	}
	
	def cambiarPassword (String userName, String password, String nuevaPassword) throws NuevaPasswordInvalida{
		val usuario = this.home.getUsuarioPorNombreDeUsuario(userName)
		if (usuario != null && usuario.getPassword == password){
			usuario.setPassword(nuevaPassword)
			this.home.actualizar(usuario)
		}
		else
			throw new NuevaPasswordInvalida()
	}
	
}