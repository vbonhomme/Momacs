MenuGauche = sidebarMenu(id = "sidebarmenu",
                         
                         menuItem("Home", tabName = "Home",  icon = icon("home", lib="font-awesome")),
                         
                         tags$br(), tags$br(), tags$br(),
                         
                         menuItem("Team", icon = icon("book", lib="font-awesome"),
                                  menuItem("Vincent Bonhomme",  href = "http://www.isem.univ-montp2.fr/recherche/equipes/phylogenie-et-evolution-moleculaire/personnel/douzery-emmanuel/", newtab = TRUE,     icon = shiny::icon("male"), selected = NULL  ),
              

                                  menuItem("Jimmy Lopez",  href = "http://www.isem.univ-montp2.fr/recherche/les-plate-formes/bioinformatique-labex/personnel/", newtab = TRUE,   icon = shiny::icon("male"), selected = NULL  )
                         )
                         
)
