package ar.edu.unq.epers.persistencia.neo4j

import ar.edu.unq.epers.model.Usuario
import org.neo4j.graphdb.Direction
import org.neo4j.graphdb.DynamicLabel
import org.neo4j.graphdb.GraphDatabaseService
import org.neo4j.graphdb.Node
import org.neo4j.graphdb.RelationshipType
import org.neo4j.graphdb.traversal.Evaluators
import org.neo4j.graphdb.traversal.Uniqueness

class HomeUsuario{
	
	 GraphDatabaseService graph 
	
	new(GraphDatabaseService graph) {
		this.graph = graph
	}
	
	def usuarioLabel() {
		DynamicLabel.label("Usuario")
	}
	
	def crearNodo(Usuario usuario) {
		val node = graph.createNode(usuarioLabel)
		node.setProperty("id", usuario.id)
		node.setProperty("nombre", usuario.nombre)
		node.setProperty("apellido", usuario.apellido)
	}
	
	def crearUsuario(Node nodo) {
		new Usuario => [
			id = nodo.getProperty("id") as Integer
			nombre = nodo.getProperty("nombre") as String
			apellido = nodo.getProperty("apellido") as String
		]
	}
	
	def eliminarNodo(Usuario usuario) {
		val nodo = getNodo(usuario)
		nodo.relationships.forEach[delete]
		nodo.delete
	}
	
	def getNodo(Usuario usuario) {
		graph.findNodes(usuarioLabel, "id", usuario.id).head
	}
	
	def crearAmistad(Usuario seguidor, Usuario seguido) {
		val seguidorNode = getNodo(seguidor)
		val seguidoNode = getNodo(seguido)
		seguidorNode.createRelationshipTo(seguidoNode, RelacionesUsuarios.SIGUE)
		seguidoNode.createRelationshipTo(seguidorNode, RelacionesUsuarios.SIGUE)
	}
	
	def nodosRelacionados(Node nodo, RelationshipType tipo, Direction direccion) {
		nodo.getRelationships(tipo, direccion).map[it.getOtherNode(nodo)]
	}
	
	/**
	 * Retorna los usuarios que un usuario sigue.
	 */
	def amigos(Usuario usuario) {
		nodosRelacionados(getNodo(usuario), RelacionesUsuarios.SIGUE, Direction.OUTGOING)
	}
	
	/**
	 * Retorna los usuarios que un usuario sigue y los usuarios que siguen esos usuarios.
	 */
	def conectadosDe(Usuario usuario){
		var amigosTraversal = graph.traversalDescription()
			.depthFirst()
			.relationships( RelacionesUsuarios.SIGUE )
			.uniqueness( Uniqueness.NODE_GLOBAL )
			.evaluator( Evaluators.excludeStartPosition )
		amigosTraversal.traverse( getNodo(usuario) ).nodes()
	}
	
	/**
	 * Retorna si el usuario01 es amigo del usuario02.
	 */
	def sonAmigos(Usuario usuario01, Usuario usuario02) {
		return amigos(usuario01).map[crearUsuario(it)].toList.contains(usuario02)
	}

}