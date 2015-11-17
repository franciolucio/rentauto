package ar.edu.unq.epers.model

import java.util.Date
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Auto {
	String marca
	String modelo
	Integer año
	String patente
	Double costoBase
	Categoria categoria
	Integer id
	
	//Debe estar ordenado
	List<Reserva> reservas
	Ubicacion ubicacionInicial
	new(){}
	new(String marca, String modelo, Integer anio, String patente, Categoria categoria, Double costoBase, Ubicacion ubicacionInicial){
		this.marca = marca
		this.modelo = modelo
		this.año = anio
		this.patente = patente
		this.costoBase = costoBase
		this.categoria = categoria
		this.ubicacionInicial = ubicacionInicial
		this.reservas = newArrayList()
	}
	

	def getUbicacion(){
		this.ubicacionParaDia(new Date());
	}
	
	def ubicacionParaDia(Date unDia){
		val encontrado = reservas.findLast[ it.fin <= unDia ]
		if(encontrado != null){
			return encontrado.destino
		}else{
			"".equals(ubicacionInicial.nombre)
			return ubicacionInicial
		}
	}
	
	def Boolean estaLibre(Date desde, Date hasta){
		reservas.forall[ !seSuperpone(desde,hasta) ]
	}
	
	def agregarReserva(Reserva reserva){
		reserva.validar
		reservas.add(reserva)
		reservas.sortInplaceBy[inicio]
	}
	
	def costoTotal(){
		return categoria.calcularCosto(this)
	}
	
}
