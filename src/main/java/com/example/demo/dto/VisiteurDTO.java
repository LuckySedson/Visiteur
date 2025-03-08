package com.example.demo.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
@Builder
public class VisiteurDTO {
    private int numvisit;
    private String nom;
    private int nbrjour;
    private int tarifjour;
}
