from flask import Flask,render_template,flash,request,url_for,redirect,session
from dbConnect import connection
from MySQLdb import escape_string as thwart
import datetime
import gc

app=Flask(__name__)
app.secret_key = "super secret key"

@app.route('/')
def home():
	if 'logged_in' in session:
		return redirect("/booking/")
	else:
		flash("Login required")
		return render_template("index.html")

@app.route('/signup/',methods=["GET","POST"])		
def signup():
	error = None

	try:

		c,conn = connection()

		if request.method == "POST":
			name = request.form['name']
			email = request.form['email']
			password = request.form['password']			

			x = c.execute("INSERT into users (name,email,password) VALUES (%s,%s,%s)",(thwart(name),thwart(email),thwart(password)))

			if x == True:
				flash("Successfully registered!")
				conn.commit()			
				conn.close()
				gc.collect()
				return redirect(u"/Login/")
			else:
				flash("Error signing up!")

	except Exception as e:
		flash(e)

	return render_template('signup.html')

@app.route('/Login/',methods = ['GET','POST'])
def Login():
	error = None
	if 'logged_in' in session:
		return redirect("/booking/")

	else:

		try:
			flag = 0

			if request.method == "POST":
				attempted_email = request.form['email']
				attempted_password = request.form['password']

				c,conn = connection()

				data = c.execute("SELECT * from users WHERE email = (%s) and password = (%s)",(thwart(attempted_email),thwart(attempted_password)))
				
				data = c.fetchall()
				if data:
					for i in data:
						if attempted_email == i[2] and attempted_password == i[3]:
							flag = 1
							id = i[0]

						if flag == 1:
							session['logged_in'] = True
							session['user_id'] = id
							return redirect("/booking/")
						else:
							flash("Invalid credentials! Try again!")	

				else:
					flash("User - I think you gotta signup!")
			
			else:
				return render_template('Login.html',error=error)

		except Exception as e:
			flash(e)


	return render_template('Login.html')

@app.route('/booking/',methods=["GET","POST"])
def booking():
	error = None
	parameters = None
	title = ""
	table = ""
	try:
		c,conn = connection()
		if request.method == "POST":
			source = request.form.get('source')
			destination = request.form.get('destination')
			date = request.form['date']

			#flash(date)

			if source == destination:
				flash("Ridiculous query user! Your source and destinations must be different!")

			else:
				c.execute("SELECT * FROM schedule WHERE source = (%s) and destination = (%s) and depart = (%s)",(source,destination,date))
				data = c.fetchall()

				if data:
					title = ['The ','available',' schedule ','is ','below']
					table = ['Trip Id','Airline Company','Source','Destination','Depart','Arrival','EC','BC','FC','BaseFare']

					for i in data:
						c.execute("select * from airlineCompany where companyId = %s",str(i[1]))
						row = c.fetchone()
						tripId = i[0]
						company = row[1]
						source = i[3]
						destination = i[4]
						Ddate = i[5]
						Adate = i[6]
						e = i[7]
						b = i[8]
						f = i[9]
						fare = i[10]

						parameters = [tripId,company,source,destination,Ddate,Adate,e,b,f,fare]

						flash(parameters)

				else:
					flash(['No service for the queried destinations!'])

		
	except Exception as e:
		flash(e)

	return render_template('booking.html',title=title,table=table,parameters=parameters)


@app.route('/ticket/')	
def ticket():
	return render_template('ticket.html')


@app.route('/schedule/',methods=["GET","POST"])	
def schedule():
	error = None

	try:

		c,conn = connection()

		if request.method == "POST":
			tripId = str(request.form['tripid'])
			count = int(request.form['count'])
			travelClass = request.form.get('class')
			acno = request.form['acno']
			acnop = request.form['acnop']

			'''flash(tripId)
			flash(count)
			flash(travelClass)
			flash(acno)
			flash(acnop)'''

			uid = session['user_id']
			c.execute("SELECT name FROM users where id = %s",str(uid))
			z = c.fetchone()
			name = z[0]

			c.execute("select * from schedule where tripId = %s",(tripId,))
			data = c.fetchone()

			if data:
				if travelClass == 'e':
					if count<= data[7]:
						#flash("Tickets available!")
						#flash(uid)
						Class = "Economy"

						
						#flash(name[0])
						

						if count == 1:
							seat = str(data[7])
						else:
							seat = str(data[7]-count+1) + " to " + str(data[7])

						#flash(count)
						#flash("Till here it's fine")
						#flash("tid" + tripId)

						x = c.execute('INSERT INTO bookedTickets (userId,tripId,count,class,seatNumbers) VALUES (%s,%s,%s,%s,%s)',(uid,tripId,count,Class,seat))
						y = c.execute('UPDATE schedule set economyClass = %s where tripId = %s',((data[7] - count),tripId))
						
						#flash(x)
						#flash(y)

						if x == True:
							
							conn.commit()	

							c.execute('select * from bookedTickets where userId = %s and tripId = %s order by ticketId desc',(str(uid),tripId))
							z = c.fetchone()
							tid = z[0]
							conn.close()
							gc.collect()
							
							#flash(data[5])
							#flash(data[6])
							#flash(data[10]*count)

							credentials = ["Booking successful",tid,name,tripId,data[3],data[4],data[5],data[6],seat,data[10]*count]
							flash(credentials)
							
							return redirect(url_for('ticket'))
							#return render_template('ticket.html')
						else:
							flash("Error signing up!")
					else:
						flash(data[7])
						flash("No seats available")
						#return redirect(url_for(booking))


				elif travelClass == 'b':
						if count<= data[8]:
							#flash("Tickets available!")
							#flash(uid)
							Class = "Business"

							
							#flash(name[0])
							

							if count == 1:
								seat = str(data[8])
							else:
								seat = str(data[8]-count+1) + " to " + str(data[8])

							#flash(count)
							#flash("Till here it's fine")
							#flash("tid" + tripId)

							x = c.execute('INSERT INTO bookedTickets (userId,tripId,count,class,seatNumbers) VALUES (%s,%s,%s,%s,%s)',(uid,thwart(tripId),count,Class,seat))
							y = c.execute('UPDATE schedule set businessClass = %s where tripId = %s',((data[8] - count),tripId))
							
							#flash(x)
							#flash(y)

							if x == True:
								
								conn.commit()	

								c.execute('select * from bookedTickets where userId = %s and tripId = %s order by ticketId desc',(str(uid),thwart(tripId)))
								z = c.fetchone()
								tid = z[0]
								conn.close()
								gc.collect()
								
								#flash(data[5])
								#flash(data[6])
								#flash(data[10]*count)

								credentials = ["Booking successful",tid,name,tripId,data[3],data[4],data[5],data[6],seat,data[10]*count*2]
								flash(credentials)
								
								return redirect(url_for('ticket'))
								#return render_template('ticket.html')
							else:
								flash("Error signing up!")
						else:
							flash(data[8])
							flash("No seats available")
							#return redirect(url_for(booking))

				else :
						if count<= data[9]:
							#flash("Tickets available!")
							#flash(uid)
							Class = "First"

							
							#flash(name[0])
							

							if count == 1:
								seat = str(data[9])
							else:
								seat = str(data[9]-count+1) + " to " + str(data[9])

							#flash(count)
							#flash("Till here it's fine")
							#flash("tid" + tripId)

							x = c.execute('INSERT INTO bookedTickets (userId,tripId,count,class,seatNumbers) VALUES (%s,%s,%s,%s,%s)',(uid,thwart(tripId),count,Class,seat))
							y = c.execute('UPDATE schedule set firstClass = %s where tripId = %s',((data[9] - count),tripId))
							
							#flash(x)
							#flash(y)

							if x == True:
								
								conn.commit()	

								c.execute('select * from bookedTickets where userId = %s and tripId = %s order by ticketId desc',(str(uid),thwart(tripId)))
								z = c.fetchone()
								tid = z[0]
								conn.close()
								gc.collect()
								
								#flash(data[5])
								#flash(data[6])
								#flash(data[10]*count)

								credentials = ["Booking successful",tid,name,tripId,data[3],data[4],data[5],data[6],seat,data[10]*count*3]
								flash(credentials)
								
								return redirect(url_for('ticket'))
								#return render_template('ticket.html')
							else:
								flash("Error signing up!")
						else:
							flash(data[9])
							flash("No seats available")
							#return redirect(url_for(booking))

			else:
				flash("You have chosen a non-existing tripId! Please go back and refer the correct one!")

	except Exception as e:
		return flash(e);



	return render_template('schedule.html')


@app.route('/ticketHistory/')
def ticketHistory():

	try:
		c, conn = connection()

		uid = session['user_id']
		c.execute('SELECT * FROM bookedTickets where userId = %s',str(uid))
		data = c.fetchall()

		
		table = ['Trip Id','Airline Company','Source','Destination','Depart','Arrival','Seat Numbers','BaseFare']

		for i in data:

			c.execute("SELECT * FROM schedule WHERE tripId = %s",(i[2],))
			s = c.fetchone()
			tripId = s[0]		
			AC = s[1]
			source = s[3]
			destination = s[4]
			depart = s[5]
			arrival = s[6]
			seat = i[5]
			if i[4] == "First":
				fare = s[10]*i[3]*3
			elif i[4] == "Business":
				fare = s[10]*i[3]*2
			else:
				fare = s[10]*i[3]
				
			parameters = [tripId,AC,source,destination,depart,arrival,seat,fare]
			flash(parameters)

	except Exception as e:
		flash(e)


	return render_template('ticketHistory.html',table=table)

@app.route('/cancelTicket/',methods=["GET","POST"])	
def cancelTicket():

	try:
		c, conn = connection()
		var = "";

		uid = session['user_id']
		c.execute("SELECT curdate()")
		x = c.fetchone()
		date = x[0]
					
		table = ['Ticket Id','Trip Id','Airline Company','Source','Destination','Depart','Arrival','Seat Numbers','Fare']

		c.execute('SELECT * FROM bookedTickets where userId = %s and tripId IN (select tripId from schedule where depart >= %s)',(str(uid),date))
		data = c.fetchall()

		for i in data:

			c.execute("SELECT * FROM schedule WHERE tripId = %s",(i[2],))
			s = c.fetchone()
			tid = i[0]
			tripId = s[0]		
			AC = s[1]
			source = s[3]
			destination = s[4]
			depart = s[5]
			arrival = s[6]
			seat = i[5]
			fare = s[10]*i[3]

			parameters = [tid,tripId,AC,source,destination,depart,arrival,seat,fare]
			flash(parameters)

		if request.method == "POST":
			ctid = str(request.form['ticketId'])

			c.execute("SELECT * FROM bookedTickets WHERE ticketId = %s",(ctid,))			
			x = c.fetchone()
			clas = x[4]
			count = str(x[3])
			tid = str(x[2])

			#flash(count)
			#a = str(int(count) + 5)
			#flash(a)
			#flash("count")
			

			if clas == "Economy":
				c.execute('SELECT * FROM schedule WHERE tripId = %s',(tid,))
				x = c.fetchone()
				cp = str(x[7])
				s = int(count) + int(cp)
				flash(s)
				c.execute('UPDATE schedule SET economyClass = %s WHERE tripId = %s',(s,tid))
				conn.commit()

			elif clas == "Business":
				c.execute('SELECT * FROM schedule WHERE tripId = %s',(tid,))
				x = c.fetchone()
				cp = str(x[8])
				s = int(count) + int(cp)
				flash(s)
				c.execute('UPDATE schedule SET businessClass = %s WHERE tripId = %s',(s,tid))
				conn.commit()

			else:
				c.execute('SELECT * FROM schedule WHERE tripId = %s',(tid,))
				x = c.fetchone()
				cp = str(x[9])
				s = int(count) + int(cp)
				flash(s)
				c.execute('UPDATE schedule SET firstClass = %s WHERE tripId = %s',(s,tid))
				conn.commit()

	
			x = c.execute("DELETE FROM bookedTickets WHERE ticketId = %s",(ctid,))
			if x:
				var = "Booking cancellation succesfull!"
				conn.commit()
				gc.collect()
				conn.close()

	except Exception as e:
		flash(e)


	return render_template('cancelTicket.html',table=table,var=var)

@app.route('/accountSettings/',methods=["GET","POST"])	
def accountSettings():

	try:
		c,conn = connection()
		uid = int(session['user_id'])

		if request.method == "POST":
			newEmail = str(request.form['email'])
			newPassword = str(request.form['password'])

			# flash(type(newEmail))
			# flash(type(newPassword))

			c.execute("UPDATE users SET email = %s, password = %s where id = %s",(newEmail,newPassword,uid))
			conn.commit()
			flash("Update successful!")
			gc.collect()
			conn.close()	


	except Exception as e:
		flash(e)


	return render_template('accountSettings.html')


@app.route('/predefinedQuery/')
def predefinedQuery():

	var = str(request.args.get('var'))

	try:
		c,conn = connection()

		c.execute("SELECT companyName FROM airlineCompany where companyId = %s",var)
		name = c.fetchone()[0]

		c.execute("SELECT count(*) FROM bookedTickets WHERE tripId IN (SELECT tripId FROM schedule WHERE airlineId = %s)",(var))
		x = c.fetchall()

		for i in x:
			count = i[0]

	except Exception as e:
		flash(e)

	

	return render_template('fame.html',var = name,count=count)

@app.route('/logout/')
def logout():
    # remove the username from the session if it's there
    session.pop('logged_in', None)
    return redirect(url_for('home'))

app.debug = True
app.run()