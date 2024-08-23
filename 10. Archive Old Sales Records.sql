/*Task 10: Archive Old Sales Records
Create a stored procedure that uses a cursor to iterate over sales records older than a specific 
date, move them to an archive table (SalesArchive), and then delete them from the original 
Sales table.
Potential procedure name: sp_archive_old_sales
Parameters: p_cutoff_date DATE
Potential Steps:
1. Declare a cursor to fetch sales records older than a given date.
2. For each record, insert it into the SalesArchive table.
3. After inserting record to SalesArchive table, delete the record from the Sales table.
The procedure should take the cutoff date as an input parameter.
For this task, you will need to create a table called SalesArchive. The structure of this table 
will be the same as the Sales table.*/


CREATE TABLE SalesArchive (
    sale_id SERIAL PRIMARY KEY,
    book_id INTEGER NOT NULL,
    customer_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    sale_date DATE NOT NULL,
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);


CREATE OR REPLACE PROCEDURE sp_archive_old_sales(
 p_cutoff_date DATE
)
LANGUAGE PLPGSQL
AS 
$$
DECLARE
	cutoff_sales sales%ROWTYPE;
	cutoff_cursor CURSOR FOR 
		SELECT * 
		FROM sales 
		WHERE sale_date < p_cutoff_date;
BEGIN
  	 OPEN cutoff_cursor;
	 LOOP
	 	--fetch cursor
        FETCH NEXT FROM cutoff_cursor INTO cutoff_sales;
            EXIT WHEN NOT FOUND;
		--insert data from row into salesarchive
		INSERT INTO SalesArchive (sale_id, book_id, customer_id, quantity, sale_date)
		VALUES(cutoff_sales.sale_id, cutoff_sales.book_id, cutoff_sales.customer_id, cutoff_sales.quantity, cutoff_sales.sale_date);
		--delete outdated records from sales
		DELETE FROM sales WHERE sale_id = cutoff_sales.sale_id; 
    END LOOP;
	COMMIT;
END;
$$;


call sp_archive_old_sales('2022-02-15');