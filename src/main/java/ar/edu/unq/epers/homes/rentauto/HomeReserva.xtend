package ar.edu.unq.epers.homes.rentauto

import ar.edu.unq.epers.model.Auto
import ar.edu.unq.epers.model.Categoria
import ar.edu.unq.epers.model.Reserva
import ar.edu.unq.epers.model.Ubicacion
import java.util.Date
import java.util.List
import org.hibernate.Query

class HomeReserva {
	
	
	def List<Auto> autosPosibles(Ubicacion origen, Ubicacion destino, Date inicio, Date fin, Categoria categoria){
		var Query q = SessionManager.getSession().createQuery("select reserva.auto from Reserva as reserva where reserva.origen.nombre = :origen and reserva.destino.nombre = :destino and reserva.inicio = :inicio and reserva.fin = :fin and reserva.auto.categoria.nombre = :categoria")
		q.setDate("fin", fin);
		q.setDate("inicio",inicio);
		q.setString("origen", origen.nombre);
		q.setString("destino", destino.nombre);
		q.setString("categoria", categoria.nombre);
		q.list()
	}
	
	
	def Reserva get(int id) {
		SessionManager.getSession().get(Reserva, id) as Reserva
	}
	
	def delete(Reserva reserva) {
		SessionManager.getSession().delete(reserva)
	}
}