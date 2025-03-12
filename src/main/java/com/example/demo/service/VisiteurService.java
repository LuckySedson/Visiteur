package com.example.demo.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.example.demo.dto.VisiteurDTO;
import com.example.demo.model.Visiteur;
import com.example.demo.repository.VisiteurRepository;

@Service
public class VisiteurService {
    private VisiteurRepository visiteurRepository;

    public VisiteurService(VisiteurRepository visiteurRepository) {
        this.visiteurRepository = visiteurRepository;
    }

    public List<VisiteurDTO> getAll() {
        List<Visiteur> visiteurlist = visiteurRepository.findAll();
        return visiteurlist.stream().map(visit -> maptovisiteurdto(visit)).collect(Collectors.toList());
    }

    private VisiteurDTO maptovisiteurdto(Visiteur visit) {
        return VisiteurDTO.builder()
                .numvisit(visit.getNumvisit())
                .nom(visit.getNom())
                .nbrjour(visit.getNbrjour())
                .tarifjour(visit.getTarifjour())
                .build();
    }

    public void ajouterVisiteur(VisiteurDTO visiteurDTO) {
        Visiteur visiteur = new Visiteur();
        visiteur.setNom(visiteurDTO.getNom());
        visiteur.setNbrjour(visiteurDTO.getNbrjour());
        visiteur.setTarifjour(visiteurDTO.getTarifjour());

        visiteurRepository.save(visiteur); // Sauvegarde dans la base de données
    }

    public void modifierVisiteur(int id, VisiteurDTO visiteurDTO) {
        Visiteur visiteur = visiteurRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Visiteur non trouvé"));
        visiteur.setNom(visiteurDTO.getNom());
        visiteur.setNbrjour(visiteurDTO.getNbrjour());
        visiteur.setTarifjour(visiteurDTO.getTarifjour());
        visiteurRepository.save(visiteur);
    }

    public void supprimerVisiteur(int id) {
        visiteurRepository.deleteById(id);
    }

}
