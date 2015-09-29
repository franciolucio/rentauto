package ar.edu.unq.epers.homes.rentauto

import ar.edu.unq.epers.model.Auto
import ar.edu.unq.epers.model.Ubicacion
import java.util.Date
import java.util.List
import org.hibernate.Query

class HomeAuto {
	
	def void save(Auto auto) {
		SessionManager.getSession().saveOrUpdate(auto)
	}
	
	def List<Auto> autosDisponibles(Ubicacion ubicacion, Date date){
		var Query q = SessionManager.getSession().createQuery("from Auto as auto where auto.id not in ( select reserva.auto.id from Reserva as reserva where :date between inicio and fin )") 
	    q.setDate("date", date)
	    var List<Auto> autosDisponibles = newArrayList
	    var List<Auto> listaDeAutos = q.list()
		for(Auto a : listaDeAutos){
			if(a.ubicacionParaDia(date).nombre == ubicacion.nombre)
				autosDisponibles.add(a)
		}
		return autosDisponibles
	}
	
	def Auto get(int id) {
		SessionManager.getSession().get(Auto, id) as Auto
	}
}