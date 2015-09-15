package ar.edu.unq.epers.generadorDeCodigo

import ar.edu.unq.epers.service.Usuario

class GeneradorDeCodigoDummy implements GeneradorDeCodigo{
	
	/**
  		* El GeneradorDeCodigoDunny implementa la interface GeneradorDeCodigo y 
  		* redefine el mensaje generarCodigo, el cual es el encargado de generar un
  		* codigo de validacion para luego setearlo al usuario
  		* @param usuario - el objeto Usuario al cual se le va a cargar ese codigo 
  		* generado
		*/
	override def generarCodigo(Usuario usuario) {
		usuario.setCodigoDeValidacion(usuario.getNombreDeUsuario+Math.random())
	}
}