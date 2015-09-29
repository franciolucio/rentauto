package ar.edu.unq.epers.homes.rentauto

import ar.edu.unq.epers.model.Auto
import ar.edu.unq.epers.model.Categoria
import ar.edu.unq.epers.model.Empresa
import ar.edu.unq.epers.model.Reserva
import ar.edu.unq.epers.model.Ubicacion
import java.util.Date
import java.util.List

class ManejadorDeHomes {
	
	HomeEmpresa homeEmpresa 
	HomeAuto homeAuto
	HomeReserva homeReserva
	
	new(){
		homeEmpresa = new HomeEmpresa()
		homeAuto = new HomeAuto()
		homeReserva = new HomeReserva()
	}
	
	def guardarEmpresa(Empresa empresa) {
		SessionManager.runInSession([ homeEmpresa.save(empresa) ])
	}
	
	def guardarAuto(Auto auto){
		SessionManager.runInSession([ homeAuto.save(auto) ])
	}
	
	def hacerReserva(Empresa empresa, Reserva reserva) {
		reserva.reservar()
		empresa.agregarReserva(reserva)
		this.guardarEmpresa(empresa)
	}
	
	def List<Auto> autosDisponibles(Ubicacion ubicacion, Date date){
		SessionManager.runInSession([ homeAuto.autosDisponibles(ubicacion, date) ])
	}
	
	def List<Auto> autosPosibles(Ubicacion origen, Ubicacion destino, Date inicio, Date fin, Categoria categoria){
		SessionManager.runInSession([ homeReserva.autosPosibles(origen, destino, inicio, fin, categoria) ])
	}
	
	def obtenerReserva(int id) {
		SessionManager.runInSession([ homeReserva.get(id) ])	
	}
	
	def borrarReserva(Reserva reserva) {
		SessionManager.runInSession([ homeReserva.delete(reserva) ])
	}
	
	def getAuto(int id) {
		SessionManager.runInSession([ homeAuto.get(id) ])
	} 
	
	def getEmpresa(int id) {
		SessionManager.runInSession([ homeEmpresa.get(id) ])
	} 
	
}
