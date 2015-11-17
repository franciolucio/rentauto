package ar.edu.unq.epers.persistencia.hibernate

import ar.edu.unq.epers.model.Auto
import ar.edu.unq.epers.model.Categoria
import ar.edu.unq.epers.model.Empresa
import ar.edu.unq.epers.model.Reserva
import ar.edu.unq.epers.model.Ubicacion
import java.util.Date
import java.util.List

class DBManagerHibernate {
	
	/**
  		* El serviceRentauto es el encargado de contener todos los homes
  		* y es a quien le vamos a pedir todos los metedos deseados para 
  		* poder persistir las clases del modelo.	
  	*/
	
	HomeEmpresa homeEmpresa 
	HomeAuto homeAuto
	HomeReserva homeReserva
	
	new(){
		homeEmpresa = new HomeEmpresa()
		homeAuto = new HomeAuto()
		homeReserva = new HomeReserva()
	}
	
	/**
  		* Guarda la empresa en la base de datos.
  		* @param empresa - el objeto Empresa por que el se va a querer 
  		* guardar. 
	*/
	def guardarEmpresa(Empresa empresa) {
		SessionManager.runInSession([ homeEmpresa.save(empresa) ])
	}
	
	/**
  		* Guarda el auto en la base de datos.
  		* @param auto - el objeto Auto por el que se va a querer guardar. 
	*/
	def guardarAuto(Auto auto){
		SessionManager.runInSession([ homeAuto.save(auto) ])
	}
	
	/**
  		* Se realiza una reserva a la empresa 
  		* @param empresa - el objeto Empresa es donde vamos a querer guardar
  		* la reserva.
  		* reserva - el objeto Reserva es la reserva deseada para que se 
  		* guarde en dicha empresa. 
	*/
	def hacerReserva(Empresa empresa, Reserva reserva) {
		SessionManager.runInSession([ 
			reserva.reservar()
			empresa.agregarReserva(reserva)
			homeEmpresa.save(empresa)
		])
	}
	
	/**
  		* Devuelve los autos disponibles para una ubicacion y un 
  		* determinado dia. 
  		* @param ubicacion - el objeto Ubicacion es el primer parametro
  		* por el cual se va a filtrar los autos para dicha consulta.
  		* date - el objeto Date es el segundo parametro por el cual se
  		* va a filtrar los autos para dicha consulta
	*/
	def List<Auto> autosDisponibles(Ubicacion ubicacion, Date date){
		SessionManager.runInSession([ homeAuto.autosDisponibles(ubicacion, date) ])
	}
	
	/**
  		* Devuelve las reservas existentes cuya parametros sean los deseados
  		* para diche busqueda. 
  		* @param origen - el objeto Ubicacion es el primer parametro
  		* por el cual se va a filtrar para dicha consulta.
  		* destino - el objeto Ubicacion es el segundo parametro
  		* por el cual se va a filtrar para dicha consulta.
  		* inicio - el objeto Date es el tercer parametro por el cual se
  		* va a filtrar para dicha consulta.
  		* fin - el objeto Date es el cuarto parametro por el cual se
  		* va a filtrar para dicha consulta.
  		* categoria - el objeto Categoria es el quinto parametro por 
  		* el cual se va a filtrar para dicha consulta.
	*/
	def List<Reserva> reservasExistentes(Ubicacion origen, Ubicacion destino, Date inicio, Date fin, Categoria categoria){
		SessionManager.runInSession([ homeReserva.reservasExistentes(origen, destino, inicio, fin, categoria) ])
	}
	
	/**
  		* Nos devuelve una reserva cuya id se encuentre en la base de datos.
  		* @param id - el objeto int es por el cual vamos a obtener dicha 
  		* reserva.
	*/
	def obtenerReserva(int id) {
		SessionManager.runInSession([ homeReserva.get(id) ])	
	}
	
	/**
  		* Elimina de la base de datos la reserva deseada.
  		* @param reserva - el objeto Reserva es la reserva que se va a 
  		* eliminar de la base de datos.
	*/
	def borrarReserva(Reserva reserva) {
		SessionManager.runInSession([ homeReserva.delete(reserva) ])
	}
	
}
