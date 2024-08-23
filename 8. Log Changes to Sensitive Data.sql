--Create a trigger that logs any changes made to sensitive data in a Customers table. Sensitive data:
--first name, last name, email address. The trigger should insert a record into an audit log table each 
--time a change is made. 

CREATE OR REPLACE FUNCTION log_sensitive_data_changes()
RETURNS TRIGGER 
LANGUAGE PLPGSQL
AS
$$
BEGIN
	IF OLD.first_name <> NEW.first_name 
	THEN
        INSERT INTO CustomersLog (column_name, old_value, new_value, changed_by)
        VALUES ('first_name', OLD.first_name, NEW.first_name, current_user);
    END IF;
	
    IF OLD.last_name <> NEW.last_name 
	THEN
        INSERT INTO CustomersLog (column_name, old_value, new_value, changed_by)
        VALUES ('last_name', OLD.last_name, NEW.last_name, current_user);
    END IF;

    IF OLD.email <> NEW.email
	THEN
        INSERT INTO CustomersLog (column_name, old_value, new_value, changed_by)
        VALUES ('email', OLD.email, NEW.email, current_user);
    END IF;
	
	RETURN NEW;
END;
$$;


CREATE OR REPLACE TRIGGER tr_log_sensitive_data_changes
  AFTER UPDATE
  ON customers
  FOR EACH ROW
  EXECUTE FUNCTION log_sensitive_data_changes();