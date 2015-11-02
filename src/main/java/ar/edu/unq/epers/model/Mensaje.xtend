package ar.edu.unq.epers.model

import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.EqualsHashCode

@Accessors
@EqualsHashCode
class Mensaje {
	
	int id
	String asunto
	String cuerpo
	
}