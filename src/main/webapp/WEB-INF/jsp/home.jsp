<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>



<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des visiteurs</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        /* Style de la popup */
        .modal {
            display: none;
            position: fixed;
            z-index: 1;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.4);
        }
        .modal-content {
            background-color: white;
            margin: 10% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 50%;
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.2);
            border-radius: 8px;
        }
        .close {
            color: red;
            float: right;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }
        .chart-container {
            width: 300px;  /* Largeur fixe */
            height: 300px; /* Hauteur fixe */
            margin: 20px auto; /* Centrer le camembert */
        }
        
    </style>
</head>
<body>
    <h1>Liste des visiteurs</h1>

    <!-- Tableau affichant la liste des visiteurs -->
    <table border="1">
        <thead>
            <tr>
                <th>Numéro</th>
                <th>Nom</th>
                <th>Nombre de jours</th>
                <th>Tarif journalier</th>
                <th>Tarif</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody id="visiteursTable">
            <c:forEach var="visiteur" items="${visiteurs}">
                <tr data-id="${visiteur.numvisit}">
                    <td>${visiteur.numvisit}</td>
                    <td>${visiteur.nom}</td>
                    <td>${visiteur.nbrjour}</td>
                    <td>${visiteur.tarifjour}</td>
                    <td class="tarif-total">${visiteur.nbrjour * visiteur.tarifjour}</td>
                    <td>
                        <button class="edit-btn" 
                            data-id="${visiteur.numvisit}" 
                            data-nom="${visiteur.nom}" 
                            data-nbrjour="${visiteur.nbrjour}" 
                            data-tarifjour="${visiteur.tarifjour}">
                            Modifier
                        </button>
                    
                        <button class="delete-btn" data-id="${visiteur.numvisit}">
                            Supprimer
                        </button>
                    </td>
                    
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <br>
    <!-- Bouton pour afficher la popup -->
    <button onclick="openModal()">Ajouter un Visiteur</button>

    <h3>🟥 Tarif total minimal : <span id="tarifMin">0</span> Ar</h3>
    <h3>🟦 Tarif total maximal : <span id="tarifMax">0</span> Ar</h3>
    <h3>🟨 Tarif total payé : <span id="tarifTotal">0</span> Ar</h3>


        <!-- Ajout du canvas pour le camembert -->
    <div class="chart-container">
        <canvas id="tarifChart"></canvas>
    </div>
    

    <!-- La Popup (modale) -->
    <div id="modal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal()">&times;</span>
            <h2>Ajouter un Visiteur</h2>
            <form id="ajoutVisiteurForm">
                <label for="nom">Nom :</label>
                <input type="text" id="nom" name="nom" required><br><br>

                <label for="nbrjour">Nombre de jours :</label>
                <input type="number" id="nbrjour" name="nbrjour" required><br><br>

                <label for="tarifjour">Tarif journalier :</label>
                <input type="number" id="tarifjour" name="tarifjour" required><br><br>

                <button type="submit">Enregistrer</button>
                <button type="button" onclick="closeModal()">Annuler</button>
            </form>
        </div>
    </div>

    <!-- Popup de modification -->
    <div id="editModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal('editModal')">&times;</span>
            <h2>Modifier un Visiteur</h2>
            <form id="modifierVisiteurForm">
                <input type="hidden" id="editId">
                
                <label for="editNom">Nom :</label>
                <input type="text" id="editNom" required><br><br>

                <label for="editNbrjour">Nombre de jours :</label>
                <input type="number" id="editNbrjour" required><br><br>

                <label for="editTarifjour">Tarif journalier :</label>
                <input type="number" id="editTarifjour" required><br><br>

                <button type="submit">Modifier</button>
                <button type="button" onclick="closeModal('editModal')">Annuler</button>
            </form>
        </div>
    </div>

    <!-- Popup de confirmation pour la suppression -->
    <div id="deleteModal" class="modal">
        <div class="modal-content">
            <h2>Êtes-vous sûr de vouloir supprimer ce visiteur ?</h2>
            <input type="hidden" id="deleteId">
            <button onclick="deleteVisiteur()">Oui</button>
            <button onclick="closeModal('deleteModal')">Non</button>
        </div>
    </div>

    <script>
        // Fonction pour ouvrir la popup
        function openModal() {
            document.getElementById("modal").style.display = "block";
        }

        // Fonction pour fermer la popup
        function closeModal(modalId) {
            $("#" + modalId).css("display", "none");
        }
        

        $(document).on("click", ".edit-btn", function() {
            $("#editId").val($(this).data("id"));
            $("#editNom").val($(this).data("nom"));
            $("#editNbrjour").val($(this).data("nbrjour"));
            $("#editTarifjour").val($(this).data("tarifjour"));
            
            $("#editModal").css("display", "block"); // Ouvrir le modal Modifier
        });
        
        

        $(document).on("click", ".delete-btn", function() {
            $("#deleteId").val($(this).data("id"));
            $("#deleteModal").css("display", "block"); // Ouvrir le modal Suppression
        });
        
        

        // Ajouter un visiteur via AJAX
        $("#ajoutVisiteurForm").submit(function(event) {
            event.preventDefault();
            let visiteur = {
                nom: $("#nom").val(),
                nbrjour: $("#nbrjour").val(),
                tarifjour: $("#tarifjour").val()
            };

            $.ajax({
                type: "POST",
                url: "/visiteur",
                contentType: "application/json",
                data: JSON.stringify(visiteur),
                success: function() {
                    alert("Visiteur ajouté avec succès !");
                    closeModal();
                    calculerMinMax();
                    location.reload(); // Rafraîchir la page pour voir le nouveau visiteur
                },
                error: function() {
                    alert("Erreur lors de l'ajout du visiteur.");
                }
            });
        });

        // Modifier un visiteur
        $("#modifierVisiteurForm").submit(function(event) {
            event.preventDefault();
            let id = $("#editId").val();
            let visiteur = {
                nom: $("#editNom").val(),
                nbrjour: $("#editNbrjour").val(),
                tarifjour: $("#editTarifjour").val()
            };
        
            $.ajax({
                type: "PUT",
                url: "/visiteur/" + id,
                contentType: "application/json",
                data: JSON.stringify(visiteur),
                success: function() {
                    alert("Visiteur modifié avec succès !");
                    closeModal("editModal");
        
                    // Mettre à jour la ligne correspondante dans le tableau
                    let row = $("#visiteursTable").find("tr[data-id='" + id + "']");
                    row.find("td:nth-child(2)").text(visiteur.nom); // Met à jour le nom
                    row.find("td:nth-child(3)").text(visiteur.nbrjour); // Met à jour le nombre de jours
                    row.find("td:nth-child(4)").text(visiteur.tarifjour); // Met à jour le tarif journalier
                    row.find("td:nth-child(5)").text(visiteur.nbrjour * visiteur.tarifjour); // Met à jour le tarif total
        
                    
                    calculerMinMax();
                },
                error: function() {
                    alert("Erreur lors de la modification.");
                }
            });
        });
        
        

        // Supprimer un visiteur
        function deleteVisiteur() {
            let id = $("#deleteId").val();
        
            $.ajax({
                type: "DELETE",
                url: "/visiteur/" + id,
                success: function() {
                    alert("Visiteur supprimé avec succès !");
                    closeModal("deleteModal");
                    calculerMinMax();
                    location.reload();
                },
                error: function() {
                    alert("Erreur lors de la suppression.");
                }
            });
        }
        
        function calculerMinMax() {
            let tarifs = $(".tarif-total").map(function() {
                return Number($(this).text().trim()); // Convertir en nombre
            }).get(); // Récupérer tous les tarifs sous forme de tableau
        
            console.log("Tarifs récupérés :", tarifs); 
        
            if (tarifs.length > 0) {
                let tarifMin = Math.min(...tarifs);
                let tarifMax = Math.max(...tarifs);
                let tarifTotal = tarifs.reduce((sum, value) => sum + value, 0); 
        
                $("#tarifMin").text(tarifMin);
                $("#tarifMax").text(tarifMax);
                $("#tarifTotal").text(tarifTotal); 

                
                updateChart(tarifMin, tarifMax, tarifTotal);
            } else {
                $("#tarifMin").text("Aucune donnée");
                $("#tarifMax").text("Aucune donnée");
                $("#tarifTotal").text("0"); 

                // Mise à jour du graphique avec des valeurs vides
                updateChart(0, 0, 0);
            }
        }
        
        let tarifChart; 

        function updateChart(min, max, total) {
            let ctx = document.getElementById("tarifChart").getContext("2d");

            // Supprimer l'ancien graphique s'il existe
            if (tarifChart) {
                tarifChart.destroy();
            }

            tarifChart = new Chart(ctx, {
                type: "pie", // 🥧 camembert
                data: {
                    labels: ["Tarif Min", "Tarif Max", "Tarif Total"],
                    datasets: [{
                        label: "Répartition des tarifs",
                        data: [min, max, total],
                        backgroundColor: ["#ff6384", "#36a2eb", "#ffce56"],
                        borderColor: ["#ff6384", "#36a2eb", "#ffce56"],
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'top' // Affiche la légende en haut
                        }
                    }
                }
            });
        }


        $(document).ready(function() {
            calculerMinMax();
        });

    </script>
</body>
</html>