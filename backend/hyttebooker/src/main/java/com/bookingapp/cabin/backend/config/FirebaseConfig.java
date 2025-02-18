package com.bookingapp.cabin.backend.config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import java.io.IOException;
import java.io.InputStream;
//source:https://stackoverflow.com/questions/44185432/firebase-admin-sdk-with-java/47247539#47247539

@Configuration
public class FirebaseConfig {

    @Bean
    public FirebaseApp initializeFirebase() throws IOException {
        if (FirebaseApp.getApps().isEmpty()){
            try(InputStream serviceAccount = getClass().getClassLoader().getResourceAsStream("firebase-adminsdk.json")) {
                if (serviceAccount == null) {
                    throw new IOException("Kunne ikke finne firebase-adminsdk.json.");
                }

                FirebaseOptions options = new FirebaseOptions.Builder()
                        .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                        .build();

                return FirebaseApp.initializeApp(options);
            }
    }
    return FirebaseApp.getInstance();
}
}
