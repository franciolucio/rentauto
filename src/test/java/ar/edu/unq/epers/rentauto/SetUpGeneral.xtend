package ar.edu.unq.epers.rentauto

import ar.edu.unq.epers.model.Auto
import ar.edu.unq.epers.model.Categoria
import ar.edu.unq.epers.model.Deportivo
import ar.edu.unq.epers.model.Empresa
import ar.edu.unq.epers.model.Familiar
import ar.edu.unq.epers.model.Reserva
import ar.edu.unq.epers.model.Ubicacion
import ar.edu.unq.epers.model.UbicacionVirtual
import ar.edu.unq.epers.service.Usuario
import java.sql.Date
import org.junit.Before

import static ar.edu.unq.epers.extensions.DateExtensions.*

class SetUpGeneral {
	var protected Empresa empresa
	var protected UbicacionVirtual zonaSur
	var protected Categoria categoriaFamiliar
	var protected Categoria categoriaDeportivo
	var protected Ubicacion retiro
	var protected Ubicacion aeroparque
	var protected Auto auto01
	var protected Auto auto02
	var protected Reserva reserva01
	var protected Reserva reserva02
	var protected Usuario usuario

	@Before
	def void setUp() {
		this.usuario = new Usuario("Alan", "Marino", "marinoalan", "1234", "marinoalan@gmail.com", new Date(115,10,12))
		empresa = new Empresa => [
			cuit = "30-12345678-40"
			nombreEmpresa = "Empresa Somos Nosotros"
			cantidadMaximaDeReservasActivas = 5
			valorMaximoPorDia = 654D
		]
		
		zonaSur = new UbicacionVirtual() => [ 
		nombre = "Zona Sur"
		]
		
		zonaSur.ubicaciones.add(new Ubicacion("Berazategui"))
		zonaSur.ubicaciones.add(new Ubicacion("Bernal"))
		
		categoriaFamiliar = new Familiar() => [nombre = "Familiar"]
		categoriaDeportivo = new Deportivo() => [nombre = "Deportivo"]
		retiro = new Ubicacion("Retiro")
		aeroparque = new Ubicacion("Aeroparque")
		auto01 = new Auto("Peugeot", "206", 2000, "OPQ231", categoriaFamiliar, 80D, retiro)
		auto02 = new Auto("Ford", "fiesta", 2015, "NRE763", categoriaDeportivo, 150D, retiro)
		
		empresa.usuarios.add(usuario)
		
		reserva01 = new Reserva => [
			origen = this.retiro
			destino = this.aeroparque
			inicio = nuevaFecha(2015, 03, 01)
			fin = nuevaFecha(2015, 07, 01)
			it.auto = this.auto01
			it.usuario = usuario
		]
		
		reserva02 = new Reserva => [
			origen = this.retiro
			destino = this.aeroparque
			inicio = nuevaFecha(2015, 06, 25)
			fin = nuevaFecha(2016, 06, 25)
			it.auto = this.auto02
			it.usuario = usuario
		]
		
	}
}
	
