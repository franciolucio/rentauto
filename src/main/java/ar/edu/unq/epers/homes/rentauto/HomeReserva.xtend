package ar.edu.unq.epers.homes.rentauto

import ar.edu.unq.epers.model.Auto
import ar.edu.unq.epers.model.Categoria
import ar.edu.unq.epers.model.Reserva
import ar.edu.unq.epers.model.Ubicacion
import java.util.Date
import java.util.List
import org.hibernate.Criteria
import org.hibernate.criterion.Restrictions

class HomeReserva {
	
	
	def List<Auto> autosPosibles(Ubicacion origen, Ubicacion destino, Date inicio, Date fin, Categoria categoria){
		var Criteria cr =  SessionManager.getSession().createCriteria(Reserva)
		addRestrictionIfNotNull(cr,"origen", origen)
		addRestrictionIfNotNull(cr,"destino", destino)
		addRestrictionIfNotNull(cr,"inicio", inicio)
		addRestrictionIfNotNull(cr,"fin", fin)
		//addRestrictionIfNotNull(cr,"auto.categoria", categoria)
		return cr.list()
	}
	
	def addRestrictionIfNotNull(Criteria criteria, String propertyName, Object value) {
    if (value != null) {
        criteria.add(Restrictions.eq(propertyName, value))
    }
}
	
	
	def Reserva get(int id) {
		SessionManager.getSession().get(Reserva, id) as Reserva
	}
	
	def delete(Reserva reserva) {
		SessionManager.getSession().delete(reserva)
	}
}