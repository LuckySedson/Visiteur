package com.example.demo.page;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.demo.service.VisiteurService;

@Controller
@RequestMapping("page")
public class PageController {
    private final VisiteurService visiteurService;

    public PageController(VisiteurService visiteurService) {
        this.visiteurService = visiteurService;
    }

    @GetMapping("/home")
    public String home() {
        return "home";
    }

}
