package hello;

import static spark.Spark.*;

public class hello
{
    public static void main(String[] args) {
        get("/hello", (req, res) -> "Hello world!\n");
    }
}