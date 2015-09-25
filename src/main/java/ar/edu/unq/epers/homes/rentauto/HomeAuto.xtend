package ar.edu.unq.epers.homes.rentauto

import ar.edu.unq.epers.model.Auto

interface HomeAuto {
	
	def void save(Auto auto)
	
	def Auto getAuto()
}