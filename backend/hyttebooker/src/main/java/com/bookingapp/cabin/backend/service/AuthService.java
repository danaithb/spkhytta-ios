package com.bookingapp.cabin.backend.service;

import com.bookingapp.cabin.backend.model.Users;
import com.bookingapp.cabin.backend.repository.UserRepository;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import org.springframework.security.crypto.bcrypt.BCrypt;


import java.util.Optional;
@Service
public class AuthService {

    private final UserRepository userRepository;

    @Autowired
    public AuthService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public String authenticateUser(String email, String password) {
        Users user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Bruker ikke funnet"));
        if (!BCrypt.checkpw(password, user.getPassword())) {
            throw new RuntimeException("Feil passord");
        }
        try {
            return FirebaseAuth.getInstance().createCustomToken(user.getFirebaseUid());
        } catch (FirebaseAuthException e) {
            throw new RuntimeException("Kunne ikke generere Firebase-token", e);
        }
    }
}