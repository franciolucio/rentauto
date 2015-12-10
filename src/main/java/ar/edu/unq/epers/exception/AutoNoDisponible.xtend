package ar.edu.unq.epers.exception

class AutoNoDisponible extends Exception{

	new(){
		super("El auto que intenta reservar no se encuentra disponible")
	}
}