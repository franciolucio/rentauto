package ar.edu.unq.epers.service

import ar.edu.unq.epers.exception.NuevaPasswordInvalida
import ar.edu.unq.epers.exception.UsuarioNoExiste
import ar.edu.unq.epers.exception.UsuarioYaExiste
import ar.edu.unq.epers.exception.ValidacionException
import ar.edu.unq.epers.generadorDeCodigo.GeneradorDeCodigo
import ar.edu.unq.epers.home.UsuarioHome
import ar.edu.unq.epers.mailing.Enviador
import ar.edu.unq.epers.mailing.Mail

class UsuarioService {
	
	var UsuarioHome home
	var Enviador enviador
	var GeneradorDeCodigo generadorDeCodigo
	
	new (UsuarioHome home, Enviador enviador, GeneradorDeCodigo generadorDeCodigo){
		this.home = home
		this.enviador = enviador
		this.generadorDeCodigo = generadorDeCodigo
  	}
	
	 	/**
  		* Registra a un nuevo usuario en el Sistema
  		* @param usuarioNuevo - el objeto usuario 
  		* (completamente cargado exepto su codigo de validacion) a registrar
  		* @throws UsuarioYaExiste si se encuentra que existia un usuario
  		* con el mismo nombre anteriormente.
		*/
	def registrarUsuario (Usuario usuarioNuevo) throws UsuarioYaExiste{
		if (this.home.existeUsuario(usuarioNuevo))
			throw new UsuarioYaExiste()
		this.generadorDeCodigo.generarCodigo(usuarioNuevo)
		this.home.actualizar(usuarioNuevo,this.home.insertar())
		this.enviador.enviarMail(new Mail("El codigo de Verificacion es: "+ usuarioNuevo.getCodigoDeValidacion(),"Nuevo Usuario",usuarioNuevo.getEmail(),"Sistema"))
	}
	
	/**
  		* Valida la cuenta si el codigo de validacion del usuario es correcto
  		* @param codigoValidacion - el objeto String es el cargado de compararse 
  		* con el codigo de validacion seteado al registrarse el usuario
  		* @throws ValidacionException si dicho codigo de validacion no coicidiese
  		* con el mismo codigo que contiene el usuario
		*/
	def validarCuenta (String codigoValidacion) throws ValidacionException{
		val usuario = this.home.getUsuarioPor(codigoValidacion, "codigoDeValidacion")
		if (usuario == null)
			throw new ValidacionException()
		usuario.validate()
		this.home.actualizar(usuario, this.home.update())
		}
	
	/**
  		* El usuario ingresa al sistema colocando su userName y password
  		* @param userName y password son lo necesario para que el usuario 
  		* puede loguearse.
  		* @throws UsuarioNoExiste si dicho userName o password  no coicidiese
  		* con la que el usuario se registro
		*/
	def ingresarUsuario (String userName, String password) throws UsuarioNoExiste{
		val usuario = this.home.getUsuarioPor(userName, "nombreDeUsuario")
		if (usuario != null && usuario.getPassword == password)
			return usuario	
		else
			throw new UsuarioNoExiste()
	}
	
	/**
  		* El usuario ingresa al sistema y solicita cambiar la password
  		* @param userName y password son lo necesario para que el usuario 
  		* puede loguearse - nuevaPasswod es la nueva clave por la cual es usuario 
  		* a la hora de reingresar al sistema va puder hacerlo.
  		* @throws NuevaPasswordInvalida si el usuario no introduzco correctamente
  		* la nueva password
		*/
	def cambiarPassword (String userName, String password, String nuevaPassword) throws NuevaPasswordInvalida{
		val usuario = this.home.getUsuarioPor(userName, "nombreDeUsuario")
		if (usuario != null && usuario.getPassword == password){
			usuario.setPassword(nuevaPassword)
			this.home.actualizar(usuario,this.home.update()) 
		}
		else
			throw new NuevaPasswordInvalida()
	}
}