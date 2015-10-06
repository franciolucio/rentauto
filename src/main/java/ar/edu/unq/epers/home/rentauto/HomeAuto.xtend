package ar.edu.unq.epers.home.rentauto

import ar.edu.unq.epers.model.Auto
import ar.edu.unq.epers.model.Ubicacion
import java.util.Date
import java.util.List
import org.hibernate.Query

class HomeAuto {
	
	/**
  		* Guarda un auto en la base de datos 
  		* @param auto - el objeto Auto es el mismo que se va a guardar
  		* en la base de datos.
	*/
	def void save(Auto auto) {
		SessionManager.getSession().saveOrUpdate(auto)
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
		var Query q = SessionManager.getSession().createQuery("from Auto") 
	    var List<Auto> autosDisponibles = newArrayList
	    var List<Auto> listaDeAutos = q.list().toList
		for(Auto a : listaDeAutos){
			if(a.estaLibre(date,date) && a.ubicacionParaDia(date).nombre == ubicacion.nombre)
				autosDisponibles.add(a)
		}
		return autosDisponibles
	}
}