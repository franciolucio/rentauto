package ar.edu.unq.epers.generadorDeCodigo

import ar.edu.unq.epers.service.Usuario

interface GeneradorDeCodigo {
	
	/**
  		* El GeneradorDeCodigo es una interface que tiene el mensaje generarCodigo
  		* que cualquiera que la implementa lo va a redefinir
  		* @param usuario - el objeto Usuario al cual se le va a cargar ese codigo 
  		* generado
		*/
	def void generarCodigo(Usuario usuario)
}