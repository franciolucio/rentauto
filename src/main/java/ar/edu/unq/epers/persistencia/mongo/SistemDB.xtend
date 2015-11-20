package ar.edu.unq.epers.persistencia.mongo

import ar.edu.unq.epers.model.Usuario
import com.mongodb.BasicDBList
import com.mongodb.BasicDBObject
import com.mongodb.DB
import com.mongodb.MongoClient
import java.net.UnknownHostException
import java.util.List
import org.mongojack.JacksonDBCollection

class SistemDB {
	static SistemDB INSTANCE
	MongoClient mongoClient
	DB db

	synchronized def static SistemDB instance() {
		if (INSTANCE == null) {
			INSTANCE = new SistemDB
		}
		return INSTANCE
	}

	private new() {
		try {
			mongoClient = new MongoClient("localhost", 27017)
		} catch (UnknownHostException e) {
			throw new RuntimeException(e)
		}
		db = mongoClient.getDB("persistencia")
	}

	def <T> Collection<T> collection(Class<T> entityType) {
		val dbCollection = db.getCollection(entityType.getSimpleName())
		new Collection<T>(JacksonDBCollection.wrap(dbCollection, entityType, String))
	}

	def collection() {
		collection(AutoCalificado)
	}

	def drop() {
		collection.mongoCollection.drop
	}
}
