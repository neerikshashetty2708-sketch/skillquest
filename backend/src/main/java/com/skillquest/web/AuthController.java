package com.skillquest.web;

import com.skillquest.model.User;
import com.skillquest.repo.UserRepository;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.context.HttpSessionSecurityContextRepository;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/auth")
public class AuthController {
    record RegisterRequest(String name, String email, String password) {}
    record LoginRequest(String email, String password) {}

    private final UserRepository users;
    private final PasswordEncoder encoder;
    private final AuthenticationManager authManager;

    public AuthController(UserRepository users, PasswordEncoder encoder, AuthenticationManager authManager) {
        this.users = users; this.encoder = encoder; this.authManager = authManager;
    }

    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody RegisterRequest r) {
        if (r.email() == null || r.password() == null || r.password().length() < 6)
            return ResponseEntity.badRequest().body(Map.of("error", "Valid email and 6+ char password required"));
        if (users.findByEmail(r.email()).isPresent())
            return ResponseEntity.status(409).body(Map.of("error", "Email already registered"));
        User u = new User();
        u.setName(r.name()); u.setEmail(r.email()); u.setPasswordHash(encoder.encode(r.password()));
        users.save(u);
        return ResponseEntity.ok(Map.of("message", "Registered"));
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest r, HttpServletRequest req, HttpServletResponse res) {
        try {
            Authentication auth = authManager.authenticate(
                new UsernamePasswordAuthenticationToken(r.email(), r.password()));
            SecurityContext ctx = SecurityContextHolder.createEmptyContext();
            ctx.setAuthentication(auth);
            SecurityContextHolder.setContext(ctx);
            new HttpSessionSecurityContextRepository().saveContext(ctx, req, res);
            return me(auth);
        } catch (Exception e) {
            return ResponseEntity.status(401).body(Map.of("error", "Invalid credentials"));
        }
    }

    @GetMapping("/me")
    public ResponseEntity<?> me(Authentication auth) {
        User u = users.findByEmail(auth.getName()).orElseThrow();
        return ResponseEntity.ok(Map.of("id", u.getId(), "name", u.getName(), "email", u.getEmail(), "role", u.getRole()));
    }

    @PostMapping("/logout")
    public ResponseEntity<?> logout(HttpServletRequest req) {
        var s = req.getSession(false);
        if (s != null) s.invalidate();
        SecurityContextHolder.clearContext();
        return ResponseEntity.ok(Map.of("message", "Logged out"));
    }
}
