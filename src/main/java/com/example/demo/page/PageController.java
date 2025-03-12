package com.example.demo.page;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.demo.dto.VisiteurDTO;
import com.example.demo.service.VisiteurService;

@Controller
@RequestMapping("page")
public class PageController {

    private final VisiteurService visiteurService;

    public PageController(VisiteurService visiteurService) {
        this.visiteurService = visiteurService;
    }

    @GetMapping("/home")
    public String home(Model model) {
        List<VisiteurDTO> visiteurs = visiteurService.getAll();
        model.addAttribute("visiteurs", visiteurs);
        return "home";
    }

    // @GetMapping("/visiteurs")
    // public String visiteurs() {
    // return "visiteurs"; //Affiche visiteur.jsp
    // }

}
