package com.example.demo.controller;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.dto.VisiteurDTO;
import com.example.demo.service.VisiteurService;

@RestController
@RequestMapping("visiteur")
public class VisiteurAPI {
    private final VisiteurService visiteurService;

    public VisiteurAPI(VisiteurService visiteurService) {
        this.visiteurService = visiteurService;
    }

    @GetMapping
    public List<VisiteurDTO> read() {
        return visiteurService.getAll();
    }

}
