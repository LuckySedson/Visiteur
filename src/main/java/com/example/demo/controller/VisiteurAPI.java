package com.example.demo.controller;

import java.util.List;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
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

    @PostMapping
    public void create(@RequestBody VisiteurDTO visiteurDTO) {
        visiteurService.ajouterVisiteur(visiteurDTO);
    }

    @PutMapping("/{id}")
    public void update(@PathVariable int id, @RequestBody VisiteurDTO visiteurDTO) {
        visiteurService.modifierVisiteur(id, visiteurDTO);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable int id) {
        visiteurService.supprimerVisiteur(id);
    }
}
