package com.example.javaci;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {
    // GET
    @GetMapping("/")
    public String greeting() {
        return "Greetings from Spring Boot!";
    }
}
/// hihi
