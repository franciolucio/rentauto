package ar.edu.unq.epers.persistencia.neo4j

import ar.edu.unq.epers.model.Mensaje
import ar.edu.unq.epers.model.Usuario
import org.neo4j.graphdb.GraphDatabaseService

class DBManagerNeo4j {

	def usuarioHome(GraphDatabaseService graph) {
		new HomeUsuario(graph)
	}
	
	def mensajeHome(GraphDatabaseService graph) {
		new MensajeHome(graph)
	}
	
	def crearNodo(Usuario usuario) {
		GraphServiceRunner.run[usuarioHome(it).crearNodo(usuario); null]
	}
	
	def crearAmistad(Usuario seguidor, Usuario seguido) {
		GraphServiceRunner.run[usuarioHome(it).crearAmistad(seguidor, seguido)]
	}
	
	def eliminarNodo(Usuario usuario) {
		GraphServiceRunner.run[usuarioHome(it).eliminarNodo(usuario); null]
	}
	
	def eliminarNodo(Mensaje mensaje) {
		GraphServiceRunner.run[mensajeHome(it).eliminarNodosSiExiste(mensaje); null]
	}
	
	def getNodo(Usuario usuario) {
		GraphServiceRunner.run[usuarioHome(it).getNodo(usuario)]
	}
	
	def amigos(Usuario usuario) {
		GraphServiceRunner.run[val home = usuarioHome(it);
			home.amigos(usuario).map[home.crearUsuario(it)].toList
		]
	}
	
	def sonAmigos(Usuario usuario, Usuario usuario2){
		GraphServiceRunner.run[usuarioHome(it).sonAmigos(usuario, usuario2);]
	}
	
	def conectadosDe(Usuario usuario) {
		GraphServiceRunner.run[ 
			val home = usuarioHome(it);
			val nodosConectados = usuarioHome(it).conectadosDe(usuario) 
			nodosConectados.map[home.crearUsuario(it)].toList
		]
	}
	
	def enviarMensaje(Usuario de, Usuario para, Mensaje mensaje) {
		GraphServiceRunner.run[ mensajeHome(it).enviarMensaje(de, para, mensaje); null]
	}
	
	def mensajesRecibidos(Usuario usuario) {
		GraphServiceRunner.run[
			val home = mensajeHome(it);
			home.mensajesRecibidos(usuario).map[home.crearMensaje(it)].toList
		]	
	}
	
	def mensajesEnviados(Usuario usuario) {
		GraphServiceRunner.run[
			val home = mensajeHome(it);
			home.mensajesEnviados(usuario).map[home.crearMensaje(it)].toList
		]	
	}
}