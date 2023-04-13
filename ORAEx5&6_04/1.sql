create table t1(c1 numeric);

CREATE OR REPLACE PROCEDURE cw1
(
  p_param IN NUMBER DEFAULT 1000000,
  p_table_name IN VARCHAR2 DEFAULT 't1',
  p_column_name IN VARCHAR2 DEFAULT 'c1'
)
IS
BEGIN
  -- Check if table exists, if not create it
  BEGIN
    EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ' || p_table_name;
  EXCEPTION
    WHEN OTHERS THEN
      EXECUTE IMMEDIATE 'CREATE TABLE ' || p_table_name || ' (' || p_column_name || ' NUMBER)';
  END;

  -- Check if column exists, if not alter the table to add it
  BEGIN
    EXECUTE IMMEDIATE 'SELECT ' || p_column_name || ' FROM ' || p_table_name || ' WHERE ROWNUM = 1';
  EXCEPTION
    WHEN OTHERS THEN
      EXECUTE IMMEDIATE 'ALTER TABLE ' || p_table_name || ' ADD ' || p_column_name || ' NUMBER';
  END;

  -- Clear table of data
  EXECUTE IMMEDIATE 'TRUNCATE TABLE ' || p_table_name;

  -- Insert data into table
  FOR i IN 1..p_param LOOP
     EXECUTE IMMEDIATE 'INSERT INTO ' || p_table_name || ' (' || p_column_name || ') VALUES (' || i || ')';
  END LOOP;

  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;

BEGIN
  cw1(100, 't1', 'c1');
END;
