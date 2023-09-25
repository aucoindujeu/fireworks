-- Ceci est le code source d'un petit programme de feux d'artifices. Tout est là ! Pour
-- commencer, je te conseille de lancer le jeu : appuie en même temps sur les touches :
-- alt (en bas à gauche) et L (vers la droite).

-- Est-ce que tu as pu lancer le jeu ?
-- Oui --------> Super ! On passe à la suite
-- Non --------> Est-ce que tu as bien appuyé sur les bonnes touches ? Est-ce qu'un message d'erreur est affiché ? Si oui, lequel ? Essaye de comprendre ce qu'il dit. Sinon, fais appel à un ami.

-- On va regarder de plus près ce que fait ce programme et on va le modifier. Ca devrait
-- changer notre feu d'artifices.

-- Ca c'est la taille de notre fenêtre dans laquelle va s'afficher notre jeu. Modifie la
-- largeur et la hauteur. Ensuite, sauvegarde en appuyant en même temps sur :
-- ctrl (en bas à gauche) et s (au milieu à gauche).
-- Puis, relance le jeu.
-- Est-ce que tu vois une différence ? Choisis une taille d'écran qui te convient.
LARGEUR = 1000
HAUTEUR = 600

-- Tu as remarqué que sur le premier écran du texte est écrit en deux tailles
-- différentes ? Dans les deux lignes qui suivent, essaye de comprendre quelles sont les
-- valeurs qui donnent la taille du texte.
-- Change la taille du petit et du grand texte, sauvegarde et relance le jeu.
-- Choisis une taille de texte qui te convient.
TEXTE_PETIT = love.graphics.newFont('font.ttf', 26)
TEXTE_GRAND = love.graphics.newFont('font.ttf', 52)

-- Ici, on définit la gravité de notre monde. Plus la gravité est élevée, plus on se
-- sent lourds et les objets tombent vite. Sur Terre, la gravité est de 9.81 m/s².
-- Essaye d'augmenter ou de baisser cette valeur pour voir ce que ça donne !
GRAVITE = 9.81

-- Et si on ajoutait du vent ? Augmente cette valeur et regarde ce que ça donne. Est-ce
-- que tu vois la différence ?
VENT = 0
-- Comment est-ce que tu ferais pour envoyer les feux d'artifices vers la gauche, plutôt
-- que vers la droite ?

-- A ton avis, que fait cette variable ? Change-la pour voir...
PUISSANCE_EXPLOSIONS = 100

-- Moi je trouve que le jeu est plus joli quand cette valeur est faible, mais essaye de mettre une valeur plus grande que 1...
VITESSE_DU_JEU = 0.2

-- Ha ! Là ça redevient intéressant. Ce qui suit est une "fonction". Une fonction
-- contient plusieurs instructions. Cette fonction est appelée lorsque le joueur appuie
-- sur la touche "f". La fonction "lancerFeux" fait elle-même appel à deux autres
-- fonctions: "genererUneCouleurAuHasard" et "creerNouveauFeu".
-- Qu'est-ce qui se passe si tu ajoutes d'autres appels à creerNouveauFeu?
function lancerFeux()
    couleur = genererUneCouleurAuHasard()
    creerNouveauFeu(couleur)
    creerNouveauFeu(couleur)
    creerNouveauFeu(couleur)

    -- Mais c'est un peu ennuyeux de lancer des feux d'artifices qui sont tous de la
    -- même couleur. Comment est-ce que tu ferais pour lancer des feux d'artifices
    -- tous de couleurs différentes ?
end

function boum(feu)
    -- Cette fonction "boum" est appelée quand un feu d'artifice explose. Chaque feu
    -- d'artifice donne alors naissance à un certain nombre d'étincelles. Ce nombre est
    -- pris au hasard. Comment ferais-tu pour modifier le nombre d'étincelles générées à
    -- chaque explosion ?
    nombreDEtincelles = genererUnNombreAuHasard(3, 10)
    lancerEtincelles(feu, nombreDEtincelles)
end

-- C'est tout ! Si tu veux tu peux essayer de comprendre les fonctions qui suivent. N'hésite pas à demander de l'aide.

function genererUnNombreAuHasard(min, max)
    return math.random(min, max)
end

function genererUneCouleurAuHasard()
    return {
        genererUnNombreAuHasard(0, 1000) / 1000,
        genererUnNombreAuHasard(0, 1000) / 1000,
        genererUnNombreAuHasard(0, 1000) / 1000,
    }
end

function creerNouveauFeu(couleur)
    local nouveauFeu = {}
    nouveauFeu.couleur = couleur
    nouveauFeu.peutExploser = true

    -- On place le feu au hasard en bas de l'écran
    nouveauFeu.corps = love.physics.newBody(MONDE, math.random(0.1 * LARGEUR, 0.9 * LARGEUR), HAUTEUR - 1, "dynamic")

    -- On applique au nouveau feu une petite force horizontale (vers la gauche ou la
    -- droite) et une grosse force verticale vers le haut
    local vitesseHorizontale = math.random( -150, 150)
    local vitesseVerticale = math.random( -800, -400)
    nouveauFeu.corps:applyLinearImpulse(vitesseHorizontale, vitesseVerticale)

    -- Le feu d'artifice est une boule de rayon 2 pixels
    nouveauFeu.forme = love.physics.newCircleShape(2)

    -- Une "fixture" est une combinaison d'un corps et d'une forme
    -- On lui donne une densité de 1 : une plus grosse densité signifie qu'il pèse
    -- plus lourd (mais il tombera tout aussi vite)
    nouveauFeu.fixture = love.physics.newFixture(nouveauFeu.corps, nouveauFeu.forme, 1)

    -- Les feux d'artifices ne rentrent pas en collision les uns avec les autres
    nouveauFeu.fixture:setCategory(1)
    -- nouveauFeu.fixture:setMask(1)

    -- Le nouveau feu est ajouté à la liste de feux existants
    table.insert(FEUX, nouveauFeu)
end

function lancerEtincelles(feu, nombre)
    local puissance = math.random(100, 200) * PUISSANCE_EXPLOSIONS / 100
    for i = 1, nombre do
        local nouveauFeu = {}
        -- On crée une petite lumière qui part de la position du feu dans chaque direction.
        nouveauFeu.corps = love.physics.newBody(MONDE, feu.corps:getX(), feu.corps:getY(), "dynamic")
        nouveauFeu.forme = love.physics.newCircleShape(1)
        nouveauFeu.couleur = feu.couleur
        -- La nouvelle explosion ne peut pas exploser à nouveau
        nouveauFeu.peutExploser = false

        -- Les lumières partent en étoile
        local vitesseHorizontale = puissance * math.cos(2 * math.pi * i / nombre)
        local vitesseVerticale = puissance * math.sin(2 * math.pi * i / nombre)

        -- On transmet à l'explosion la vitesse du feu qui la génère
        local vx, vy = feu.corps:getLinearVelocity()
        nouveauFeu.corps:applyLinearImpulse(vitesseHorizontale + vx, vitesseVerticale + vy)
        nouveauFeu.fixture = love.physics.newFixture(nouveauFeu.corps, nouveauFeu.forme, 1)
        nouveauFeu.fixture:setCategory(1)
        nouveauFeu.fixture:setMask(1)
        table.insert(FEUX, nouveauFeu)
    end
end

-- https://github.com/Ulydev/push
push = require 'push'


function love.load()
    GAME_STATE = "start"
    FEUX = {}

    -- Cette fonction est appelée une seule fois lors de la création de notre jeu
    -- Affichage en "pixel art" (sans aliasing)
    love.graphics.setDefaultFilter('nearest', 'nearest')
    push:setupScreen(LARGEUR, HAUTEUR, LARGEUR, HAUTEUR, {
        -- Ecran redimensionnable ?
        resizable = true,
        -- Plein écran ?
        -- fullscreen = true,
    })

    -- Titre de la fenêtre
    love.window.setTitle("Feu !")

    -- Créons les règles physiques de notre monde
    --un mètre fait 64 pixels
    love.physics.setMeter(64)
    MONDE = love.physics.newWorld(
        VENT * love.physics:getMeter(),
        GRAVITE * love.physics:getMeter(),
        true
    )
end

function love.update(dt)
    -- Cette fonction est appelée à chaque frame. On y met à jour les propriétés de chaque objet, y compris leurs positions
    for i = #FEUX, 1, -1 do
        if FEUX[i].corps:getY() > HAUTEUR then
            -- On se débarasse des feux d'artifices qui tombent sous le sol
            FEUX[i].corps:destroy()
            table.remove(FEUX, i)
        elseif FEUX[i].peutExploser then
            -- On fait exploser les feux d'artifices qui commencent à redescendre
            local vx, vy = FEUX[i].corps:getLinearVelocity()
            if vy > 0 then
                -- On laisse du temps pour exploser...
                if math.random(10) == 1 then
                    boum(FEUX[i])
                    table.remove(FEUX, i)
                end
            end
        end
    end

    -- On met à jour la position et la vitesse de chaque objet, mais lentement, parce
    -- que c'est plus agréable à regarder
    MONDE:update(dt * VITESSE_DU_JEU)
end

function love.draw()
    -- Cette fonction est appelée à chaque frame. On y met les instructions pour
    -- l'affichage de chaque objet.
    push:start()

    if GAME_STATE == "start" then
        love.graphics.setFont(TEXTE_GRAND)
        love.graphics.printf('Fireworks!', 0, HAUTEUR * 0.25, LARGEUR, 'center')
        love.graphics.setFont(TEXTE_PETIT)
        love.graphics.printf('Appuie sur f pour demarrer', 0, HAUTEUR * 0.25 + TEXTE_GRAND:getHeight() + 20, LARGEUR,
            'center')
    else
        -- On dessine tous les feux
        for i = 1, #FEUX do
            -- On colorie le feu d'artifice de sa couleur
            love.graphics.setColor(FEUX[i].couleur[1], FEUX[i].couleur[2], FEUX[i].couleur[3])
            -- Pour chaque feu on dessine un cercle de rayon 2
            love.graphics.circle("fill", FEUX[i].corps:getX(), FEUX[i].corps:getY(), FEUX[i].forme:getRadius())
        end
    end

    -- On n'oublie pas d'appeler cette fonction à la fin de chaque affichage
    push:finish()
end

function love.keypressed(key, scancode, isrepeat)
    -- Cette fonction est appelée dès qu'on appuie sur une touche

    if key == "f" then
        GAME_STATE = "play"
        lancerFeux()
    end
end

function love.resize(width, height)
    -- Cette fonction est appelée lorsqu'on redimensionne la taille de la fenêtre : il
    -- faut alors ajuster la manière dont on affiche les objets. Heureusement pour nous
    -- il n'y a pas grand-chose à faire.
    push:resize(width, height)
end
