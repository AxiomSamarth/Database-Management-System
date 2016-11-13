import MySQLdb as ms

def connection():
	conn = ms.connect(host="localhost",user="root",passwd="Sam*1234",db="replicaDB")
	c = conn.cursor()

	return c,conn