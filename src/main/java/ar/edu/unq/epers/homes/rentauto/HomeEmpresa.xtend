package ar.edu.unq.epers.homes.rentauto

import ar.edu.unq.epers.model.Auto
import ar.edu.unq.epers.model.Categoria
import ar.edu.unq.epers.model.Empresa
import ar.edu.unq.epers.model.Reserva
import ar.edu.unq.epers.model.Ubicacion
import java.util.Date
import java.util.List

class HomeEmpresa {
	
	def void save(Empresa empresa) {
		SessionManager.getSession().saveOrUpdate(empresa)
	}
	
	def Empresa getEmpresa(String cuit){
		return SessionManager.getSession().get(typeof(Empresa) ,cuit) as Empresa 
		
	}
	
	def Auto getAuto(String patente){
		return SessionManager.getSession().get(typeof(Auto) ,patente) as Auto
	}
	
	def List<Auto> getAutoPorUbicacionYDia (Ubicacion ubicacion, Date fecha){
		
	}
	
	def List<Auto> getAutoPor (Ubicacion origenODestino){
		
	}
	
	def List<Auto> getAutoPor (Date fecha){
		
	}
	
	def List<Auto> getAutoPor (Categoria categoria){
		
	}
	
	def void hacerReserva (Reserva reserva){
		
	}
}