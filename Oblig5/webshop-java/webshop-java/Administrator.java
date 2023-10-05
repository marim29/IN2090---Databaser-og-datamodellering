import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet; 
import java.sql.SQLException;
import java.sql.Statement;

import java.util.LinkedList;
import java.util.List;
import java.util.Scanner;

public class Administrator {

    private static String user = ""; // Input your UiO-username
    private static String pwd = ""; // Input the password for the _priv-user you got in a mail
    // Connection details
    private static String connectionStr = 
        "user=" + user + "_priv&" + 
        "port=5432&" +  
        "password=" + pwd + "";
    private static String host = "jdbc:postgresql://dbpg-ifi-kurs.uio.no"; 

    public static void main(String[] agrs) {

        try {
            // Load driver for PostgreSQL
            Class.forName("org.postgresql.Driver");
            // Create a connection to the database
            Connection connection = DriverManager.getConnection(host + "/" + user
                    + "?sslmode=require&ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory&" + connectionStr);

            int ch = 0;
            while (ch != 3) {
                System.out.println("-- ADMINISTRATOR --");
                System.out.println("Please choose an option:\n 1. Create bills\n 2. Insert new product\n 3. Exit");
                ch = getIntFromUser("Option: ", true);

                if (ch == 1) {
                    makeBills(connection);
                } else if (ch == 2) {
                    insertProduct(connection);
                }
            }
        } catch (SQLException|ClassNotFoundException ex) {
            System.err.println("Error encountered: " + ex.getMessage());
        }
    }

    private static void makeBills(Connection connection)  throws SQLException {
        // TODO: Oppg 2
    }


    private static void insertProduct(Connection connection) throws SQLException {
        // TODO: Oppg 3
    }

    /**
     * Utility method that gets an int as input from user
     * Prints the argument message before getting input
     * If second argument is true, the user does not need to give input and can leave
     * the field blank (resulting in a null)
     */
    private static Integer getIntFromUser(String message, boolean canBeBlank) {
        while (true) {
            String str = getStrFromUser(message);
            if (str.equals("") && canBeBlank) {
                return null;
            }
            try {
                return Integer.valueOf(str);
            } catch (NumberFormatException ex) {
                System.out.println("Please provide an integer or leave blank.");
            }
        }
    }

    /**
     * Utility method that gets a String as input from user
     * Prints the argument message before getting input
     */
    private static String getStrFromUser(String message) {
        Scanner s = new Scanner(System.in);
        System.out.print(message);
        return s.nextLine();
    }
}
