/* Notes: 
 * This code is modified from the original to work with 
 * the CS 352 chat client:
 *
 * 1. added args to allow for a command line to the port 
 * 2. Added 200 OK code to the sendResponse near line 77
 * 3. Changed default file name in getFilePath method to ./ from www 
 */ 

import java.io.*;
import java.net.ServerSocket;
import java.net.Socket;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;


public class HTTPChatServer {
    static int cookieCount = 0;
    static ArrayList < String > usernamesStored = new ArrayList < String > ();
    static ArrayList < String > usersStored = new ArrayList < String > ();
    static ArrayList < String > passwordsStored = new ArrayList < String > ();
    static ArrayList < String > messageStored = new ArrayList < String > ();
    static int itNum = 0;
    static int numUsers = 0;

    public static void main( String[] args ) throws Exception {
        
        
        BufferedReader loginbr = new BufferedReader(new FileReader("login/credentials.txt"));

        String line = loginbr.readLine();
        while (line != null) {
            String[] tempBuffer = line.split(",");
            usernamesStored.add(tempBuffer[0]);
            passwordsStored.add(tempBuffer[1]);
            line = loginbr.readLine();
        }
        loginbr.close();
        


	if (args.length != 1) 
        {
            System.err.println("Usage: java Server <port number>");
           
        }
        //create server socket given port number
        int portNumber = Integer.parseInt(args[0]);

        try (ServerSocket serverSocket = new ServerSocket(portNumber)) {
            while (true) {
                try (Socket client = serverSocket.accept()) {
                    handleClient(client);
                }
            }
        }
        
    }

    private static void handleClient(Socket client) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(client.getInputStream()));

        StringBuilder requestBuilder = new StringBuilder();
        String line;
        while (!(line = br.readLine()).isBlank()) {
            requestBuilder.append(line + "\r\n");
        }

        String request = requestBuilder.toString();

        

	    String[] requestsLines = request.split("\r\n");
        String[] requestLine = requestsLines[0].split(" ");
        String method = requestLine[0];
        String path = requestLine[1];
        String version = requestLine[2];
        String host = requestsLines[1].split(" ")[1];


	// build the reponse here
    String finish = "";
        while(br.ready()){
        char c = (char)br.read();
        finish = finish + c;
     }


        String[] currentInformation = finish.split("=");
        String currentInfo = currentInformation[0];
        
        
       // String content3 = "";
        String content2 = "";
       if(currentInfo.equals("message") && currentInformation[1] != null){
            String currentMessage = currentInformation[1];
           messageStored.add(currentMessage);
       }
       String currentLoginUsername = "";
        String currentLoginPassword = "";
        boolean authentication = false;
       if(currentInfo.equals("username")){
        finish = finish.replaceAll("username=", "");
        finish = finish.replaceAll("password=", "");
        String[] currentLogin = finish.split("&");
        currentLoginUsername = currentLogin[0];
        currentLoginPassword = currentLogin[1];  
        for (int x = 0; x < usernamesStored.size(); x++) {
            if (currentLoginUsername.equals(usernamesStored.get(x))) {
             if (currentLoginPassword.equals(passwordsStored.get(x))) {
                    usersStored.add(currentLoginUsername);
                    authentication = true; 
                   
                  }
             }
        }
   }




        if(method.equals("GET") && path.charAt(1) == 'c'){
            try {
                BufferedReader in = new BufferedReader(new FileReader("chat/chat.html"));
                String str;
                while ((str= in.readLine()) != null) {
                if(str.contains("<div")){
                        content2 += (str+ "\r\n");
                        for(int i = 0; i < usersStored.size(); i++){
                            content2 += ("<p>" + usersStored.get(i) + ": " + messageStored.get(i) +  "<p>" + "\r\n");
                        }       
                }
                else{
                    content2 += (str+ "\r\n");
                }
                }
                in.close();
            } catch (IOException e) {
             }
             
        }
        
        String strError = "";
        strError+= ("<html>" + "\r\n");
        strError+= ("<body>" + "\r\n");
        strError+= ("<h1>Error Page for CS352</h1>" + "\r\n");
        strError+= ("<p>" + "\r\n");
        strError+= (" You have entered wrong credentials or cookie mismatch took place. Please try again" + "\r\n");
        strError+= ("<p>" + "\r\n");
        strError+= ("<body>" + "\r\n");
        strError+= ("<html>" + "\r\n");
        strError+= ("Error Encountered" + "\r\n");


        
        
        int num = 0;
        System.out.println("ITERATION" + (num += 1));
        System.out.println(method);
        System.out.println(path);

         Path filePath = getFilePath(path);
        if (Files.exists(filePath)) {
            if(method.equals("GET") && path.charAt(1) == 'c')
            {
                String contentType = guessContentType(filePath);
                byte[] chatlog = content2.getBytes();
                sendResponse(client, "200 OK", contentType, chatlog);
                numUsers++;
                    
            }
            else if (method.equals("POST") && path.charAt(1) == 'l' && authentication == false)
            {
                byte[] errorResponse = (strError).getBytes();
                sendResponseError(client, "404 Not Found", "text/html", errorResponse);
            }
            else{
                String contentType = guessContentType(filePath);
                sendResponse(client, "200 OK", contentType, Files.readAllBytes(filePath)); 
            }
             
            
        } else {
            // 404
            byte[] notFoundContent = "<h1>Not found :(</h1>".getBytes();
            sendResponse(client, "404 Not Found", "text/html", notFoundContent);
        }
    



        List<String> headers = new ArrayList<>();
        for (int h = 2; h < requestsLines.length; h++) {
            String header = requestsLines[h];
            headers.add(header);
        }
        
        

        String accessLog = String.format("Client %s, method %s, path %s, version %s, host %s, headers %s",
                client.toString(), method, path, version, host, headers.toString());
        System.out.println(accessLog);

       


    }
    /**
    Sends a response to the client on a succesful login
     */
    private static void sendResponse(Socket client, String status, String contentType, byte[] content) throws IOException {
        OutputStream clientOutput = client.getOutputStream();
        clientOutput.write(("HTTP/1.1 200 OK" + status + "\r\n").getBytes());
        clientOutput.write(("ContentType: " + contentType + "\r\n").getBytes());
        clientOutput.write(("Set-Cookie: " + "user1" + "\r\n").getBytes());
        clientOutput.write("\r\n".getBytes());
        clientOutput.write(content);
        clientOutput.write("\r\n\r\n".getBytes());
        clientOutput.flush();
    }
    /**
     Sends a error response to the client 
     */
    private static void sendResponseError(Socket client, String status, String contentType, byte[] content) throws IOException {
        OutputStream clientOutput = client.getOutputStream();
        clientOutput.write(("HTTP/1.1 200 OK" + status + "\r\n").getBytes());
        clientOutput.write(("ContentType: " + contentType + "\r\n").getBytes());
        clientOutput.write("\r\n".getBytes());
        clientOutput.write(content);
        clientOutput.write("\r\n\r\n".getBytes());
        client.close();
    }

    private static Path getFilePath(String path) {
        if ("/".equals(path)) {
            path = "/index.html";
        }

        return Paths.get("./", path);
    }

    private static String guessContentType(Path filePath) throws IOException {
        return Files.probeContentType(filePath);
    }

}
