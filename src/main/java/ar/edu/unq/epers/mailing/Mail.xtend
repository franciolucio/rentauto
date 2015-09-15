package ar.edu.unq.epers.usuarios

class Mail {
	
	var String body
	var String subject
	var String to
	var String from
	
	new (String body, String subject, String to, String from){
		this.body = body
		this.subject = subject
		this.to = to
		this.from = from
	}
}