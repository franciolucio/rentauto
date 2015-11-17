package ar.edu.unq.epers.model

import java.sql.Date
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.EqualsHashCode

@Accessors 
@EqualsHashCode
class Usuario {

	var Integer id
	var String nombre;
	var String apellido;
	var String nombreDeUsuario;
	var String password;
	var String email;
	var Date fechaDeNacimiento;
	var Boolean validado;
	var String codigoDeValidacion
	var List<Reserva> reservas

	new () {}
	
	new (String nombre, String apellido, String nombreDeUsuario, String password, String email, Date fechaDeNacimiento){
		this.nombre = nombre;
		this.apellido = apellido;
		this.nombreDeUsuario = nombreDeUsuario;
		this.password = password
		this.email = email;
		this.fechaDeNacimiento = fechaDeNacimiento;
		this.validado = false;
		this.codigoDeValidacion = null
		this.reservas = newArrayList
	}
	
	/**
  		* El usuario cambia el estado del flag validado por true
  		*/
	def validate (){
		this.validado = true
	}
	
	def agregarReserva(Reserva reserva) {
		reservas.add(reserva)
	}	
}