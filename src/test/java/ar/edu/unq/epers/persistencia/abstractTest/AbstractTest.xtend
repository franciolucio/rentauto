package ar.edu.unq.epers.persistencia.abstractTest

import ar.edu.unq.epers.model.Auto
import ar.edu.unq.epers.model.Categoria
import ar.edu.unq.epers.model.Deportivo
import ar.edu.unq.epers.model.Empresa
import ar.edu.unq.epers.model.Familiar
import ar.edu.unq.epers.model.Mensaje
import ar.edu.unq.epers.model.Reserva
import ar.edu.unq.epers.model.TodoTerreno
import ar.edu.unq.epers.model.Ubicacion
import ar.edu.unq.epers.model.UbicacionVirtual
import ar.edu.unq.epers.model.Usuario
import ar.edu.unq.epers.persistencia.DBManager
import ar.edu.unq.epers.persistencia.hibernate.SessionManager
import java.sql.Date
import org.junit.After
import org.junit.Before

import static ar.edu.unq.epers.extensions.DateExtensions.*

class AbstractTest {
	
	protected DBManager dbManager
	protected Empresa empresa
	protected UbicacionVirtual zonaSur
	protected Categoria categoriaFamiliar
	protected Categoria categoriaDeportivo
	protected Categoria categoriaTodoTerreno
	protected Ubicacion retiro
	protected Ubicacion aeroparque
	protected Auto auto01
	protected Auto auto02
	protected Reserva reserva01
	protected Reserva reserva02
	protected Usuario lucio
	protected Usuario alan
	protected Usuario emiliano
	protected Usuario pepe
	protected Usuario coki
	

	
	
	@Before
	def void setUp() {
		
		dbManager = new DBManager()
		
		///////////////USUARIOS///////////////
		lucio = new Usuario("Lucio", "Francioni", "francioniLucio", "0001", "francioniLucio@gmail.com", new Date(115,10,12))
		alan = new Usuario("Alan", "Marino", "marinoalan", "0002", "marinoalan@gmail.com", new Date(115,10,12))
		emiliano = new Usuario("Emiliano", "Mancuso", "mancusoEmiliano", "0003", "mancusoEmiliano@gmail.com", new Date(115,10,12))
		pepe = new Usuario("Pepe", "Argento", "argentoPepe", "0004", "argentoPepe@gmail.com", new Date(115,10,12))
		coki = new Usuario("Coki", "Argento", "argentoCoki", "0005", "argentoCoki@gmail.com", new Date(115,10,12))
		
		///////////////EMPRESA///////////////
		empresa = new Empresa => [
			cuit = "30-12345678-40"
			nombreEmpresa = "Empresa Somos Nosotros"
			cantidadMaximaDeReservasActivas = 5
			valorMaximoPorDia = 654D
		]
		empresa.usuarios.add(alan)
		
		///////////////UBICACIONES///////////////
		zonaSur = new UbicacionVirtual() => [ 
			nombre = "Zona Sur"
		]
		
		zonaSur.ubicaciones.add(new Ubicacion("Berazategui"))
		zonaSur.ubicaciones.add(new Ubicacion("Bernal"))
		retiro = new Ubicacion("Retiro")
		aeroparque = new Ubicacion("Aeroparque")
		
		///////////////CATEGORIAS///////////////
		categoriaFamiliar = new Familiar() => [nombre = "Familiar"]
		categoriaDeportivo = new Deportivo() => [nombre = "Deportivo"]
		categoriaTodoTerreno = new TodoTerreno=> [nombre = "Todo terreno"]
		
		///////////////AUTOS///////////////
		auto01 = new Auto("Peugeot", "206", 2000, "OPQ231", categoriaFamiliar, 80D, retiro)
		auto02 = new Auto("Ford", "fiesta", 2015, "NRE763", categoriaDeportivo, 150D, retiro)
		
		
		
		///////////////RESERVAS///////////////
		reserva01 = new Reserva => [
			origen = this.retiro
			destino = this.aeroparque
			inicio = nuevaFecha(2015, 03, 01)
			fin = nuevaFecha(2015, 07, 01)
			it.auto = this.auto01
			it.usuario = alan
		]
		
		reserva02 = new Reserva => [
			origen = this.retiro
			destino = this.aeroparque
			inicio = nuevaFecha(2015, 06, 25)
			fin = nuevaFecha(2016, 06, 25)
			it.auto = this.auto02
			it.usuario = alan
		]
		
	}
}
	
