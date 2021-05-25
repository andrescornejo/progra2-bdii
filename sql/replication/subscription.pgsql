create subscription dvd_subscription
	connection 'dbname=dvdrental host=localhost port=5432 user=rep password=admin'
	publication dvd_publication;
	
-- drop subscription dvd_subscription;