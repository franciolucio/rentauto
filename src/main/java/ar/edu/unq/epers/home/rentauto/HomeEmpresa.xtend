package ar.edu.unq.epers.home.rentauto

import ar.edu.unq.epers.model.Empresa

class HomeEmpresa {
	
	/**
  		* Guarda una empresa en la base de datos 
  		* @param empresa - el objeto Empresa es la misma que se va a 
  		* guardar en la base de datos.
	*/
	def save(Empresa empresa) {
		SessionManager.getSession().saveOrUpdate(empresa)
	}
}