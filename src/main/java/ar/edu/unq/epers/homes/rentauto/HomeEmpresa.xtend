package ar.edu.unq.epers.homes.rentauto

import ar.edu.unq.epers.model.Empresa

class HomeEmpresa {
	
	def save(Empresa empresa) {
		SessionManager.getSession().saveOrUpdate(empresa)
	}
	
		def Empresa get(int id) {
		SessionManager.getSession().get(Empresa, id) as Empresa
	}
}