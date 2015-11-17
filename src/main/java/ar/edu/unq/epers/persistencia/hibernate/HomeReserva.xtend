package ar.edu.unq.epers.persistencia.hibernate

import ar.edu.unq.epers.model.Categoria
import ar.edu.unq.epers.model.Reserva
import ar.edu.unq.epers.model.Ubicacion
import java.util.Date
import java.util.List
import org.hibernate.Criteria
import org.hibernate.criterion.Restrictions

class HomeReserva {
	
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
		var Criteria cr =  SessionManager.getSession().createCriteria(Reserva)
		addRestrictionIfNotNull(cr,"origen", origen)
		addRestrictionIfNotNull(cr,"destino", destino)
		addRestrictionIfNotNull(cr,"inicio", inicio)
		addRestrictionIfNotNull(cr,"fin", fin)
		cr.createAlias("auto", "auto")
		addRestrictionIfNotNull(cr,"auto.categoria", categoria)
		return cr.list()
	}
	
	def addRestrictionIfNotNull(Criteria criteria, String propertyName, Object value) {
    if (value != null) 
        criteria.add(Restrictions.eq(propertyName, value))
    
	}
	
	/**
  		* Nos devuelve una reserva cuya id se encuentre en la base de datos.
  		* @param id - el objeto int es por el cual vamos a obtener dicha 
  		* reserva.
	*/
	def Reserva get(int id) {
		SessionManager.getSession().get(Reserva, id) as Reserva
	}
	
	/**
  		* Elimina de la base de datos la reserva deseada.
  		* @param reserva - el objeto Reserva es la reserva que se va a 
  		* eliminar de la base de datos.
	*/
	def delete(Reserva reserva) {
		SessionManager.getSession().delete(reserva)
	}
}