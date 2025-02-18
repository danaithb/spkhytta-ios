package com.bookingapp.cabin.backend.dtos;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;



@Getter
@Setter
@AllArgsConstructor
@Data
public class AuthRequestDTO {
    private String email;
    private String password;

}
