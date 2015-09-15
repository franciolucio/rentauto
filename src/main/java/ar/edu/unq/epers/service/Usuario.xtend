package ar.edu.unq.epers.service

import java.sql.Date
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors class Usuario{

	var String nombre;
	var String apellido;
	var String nombreDeUsuario;
	var String password;
	var String email;
	var Date fechaDeNacimiento;
	var Boolean validado;
	var String codigoDeValidacion
	
	new (String nombre, String apellido, String nombreDeUsuario, String password, String email, Date fechaDeNacimiento){
		this.nombre = nombre;
		this.apellido = apellido;
		this.nombreDeUsuario = nombreDeUsuario;
		this.password = password
		this.email = email;
		this.fechaDeNacimiento = fechaDeNacimiento;
		this.validado = false;
		this.codigoDeValidacion = null
	}
	
	/**
  		* El usuario cambia el estado del flag validado por true
  		*/
	def validate (){
		this.validado = true
	}
}