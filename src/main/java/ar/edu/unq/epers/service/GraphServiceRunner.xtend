package ar.edu.unq.epers.service

import org.eclipse.xtext.xbase.lib.Functions.Function1
import org.neo4j.graphdb.GraphDatabaseService
import org.neo4j.graphdb.factory.GraphDatabaseFactory

class GraphServiceRunner {
	static private GraphDatabaseService _graphDb

	static synchronized def GraphDatabaseService getGraphDb() {
		if (_graphDb == null) {
			_graphDb = new GraphDatabaseFactory()
				.newEmbeddedDatabaseBuilder("./target/neo4j")
				.newGraphDatabase();
				Runtime.runtime.addShutdownHook(new Thread([graphDb.shutdown]))
		}
		_graphDb
	}
	
	static def <T> T run(Function1<GraphDatabaseService, T> command){
		val tx = getGraphDb.beginTx
		try{
			val t = command.apply(getGraphDb)
			tx.success
			t
		}catch(Exception e){
			tx.failure
			throw e
		}finally{
			tx.close
		}
	}
}