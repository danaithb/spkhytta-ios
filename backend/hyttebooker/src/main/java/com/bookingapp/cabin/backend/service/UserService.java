package com.bookingapp.cabin.backend.service;

import com.bookingapp.cabin.backend.model.Users;
import com.bookingapp.cabin.backend.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;
@Service
public class UserService {

    private final UserRepository userRepository;

    @Autowired
    public UserService(UserRepository usersRepository) {
        this.userRepository = usersRepository;
    }
    public Optional<Users> getUserByEmail(String email) {
        return userRepository.findByEmail(email);
    }


}
