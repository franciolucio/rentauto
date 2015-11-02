package ar.edu.unq.epers.home.rentauto

import ar.edu.unq.epers.exception.NoSonAmigosException
import ar.edu.unq.epers.model.Mensaje
import ar.edu.unq.epers.model.RelacionesMensaje
import ar.edu.unq.epers.service.Usuario
import org.neo4j.graphdb.Direction
import org.neo4j.graphdb.DynamicLabel
import org.neo4j.graphdb.GraphDatabaseService
import org.neo4j.graphdb.Node
import org.neo4j.graphdb.RelationshipType

class MensajeHome {
	
	HomeUsuario usuarioHome
	GraphDatabaseService graph
	
	new(GraphDatabaseService graph) {
		this.graph = graph 
		this.usuarioHome = new HomeUsuario(graph)	
	}
	
	def eliminarNodosSiExiste(Mensaje mensaje) {
		val nodo = getNodo(mensaje)
		if(nodo == null) return else
		nodo.relationships.forEach[delete]
		nodo.delete
	}
	
	def enviarMensaje(Usuario destinador, Usuario destinatario, Mensaje mensaje) throws NoSonAmigosException{
		if(!usuarioHome.sonAmigos(destinador, destinatario)) throw new NoSonAmigosException
		crearNodo(mensaje)
		destinadorDestinatario(destinador, destinatario, mensaje)
	}
	
	def crearMensaje(Node nodo) {
		new Mensaje => [
			id = nodo.getProperty("id") as Integer
			asunto = nodo.getProperty("asunto") as String
			cuerpo = nodo.getProperty("cuerpo") as String
		]
	}
	
	def mensajeLabel() {
		DynamicLabel.label("Mensaje")
	}
	
	def destinadorDestinatario(Usuario de, Usuario para, Mensaje mensaje) {
		val nodoDe = usuarioHome.getNodo(de)
		val nodoPara = usuarioHome.getNodo(para)
		var nodoMensaje = this.getNodo(mensaje)
		nodoMensaje.createRelationshipTo(nodoDe, RelacionesMensaje.DE);
		nodoMensaje.createRelationshipTo(nodoPara, RelacionesMensaje.PARA);
	}
	
	def getNodo(Mensaje mensaje) {
		graph.findNodes(mensajeLabel, "id", mensaje.id).head
	}
	
	def mensajesRecibidos(Usuario usuario) {
		nodosRelacionados(usuarioHome.getNodo(usuario), RelacionesMensaje.PARA, Direction.INCOMING)
	}
	
	def mensajesEnviados(Usuario usuario) {
		nodosRelacionados(usuarioHome.getNodo(usuario), RelacionesMensaje.DE, Direction.INCOMING)
	}
	
	def nodosRelacionados(Node nodo, RelationshipType tipo, Direction direccion) {
		nodo.getRelationships(tipo, direccion).map[it.getOtherNode(nodo)]
	}
	
	def crearNodo(Mensaje mensaje) {
		val node = graph.createNode(mensajeLabel)
		node.setProperty("id", mensaje.id)
		node.setProperty("asunto", mensaje.asunto)
		node.setProperty("cuerpo", mensaje.cuerpo)
	}
	
}