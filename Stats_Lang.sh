#!/bin/bash
# -*- coding: utf8
# Auteur: Cagliostro <atfield2501@gmail.com>
# Script de statistique sur l'usage des charctères et des mots dans un fichier txt.


ROUGE="\\033[1;31m"
JAUNE="\\033[1;33m"
VERT="\\033[1;32m"

sequence=("A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "T" "U" "V" "W" "X" "Y" "Z")


Fonction_Quit(){                                     
   exit
}


Fonction_Erreur(){
   echo -e "$ROUGE""Erreur.."
   echo -e "$VERT""Vous devez spécifiez une cible."
   echo -e "$VERT""Stats_lang -h pour obtenir l'exemple de la commande"
}


Fonction_Version(){
   echo -e "$VERT""  *****************  "
   echo -e "$VERT""  *  Stat_Langue  *  "
   echo -e "$VERT""  *****************  "
   echo -e "$VERT""  **   (;,,;)    **  "
   echo -e "$VERT""  *****************  "
   echo -e "$VERT""  *    V  1.O     *  "
   echo -e "$VERT""  *****************  "
   echo -e "$JAUNE""----------------------"
}


Fonction_Nettoyage(){                                   
   rm -f .Var02.tmp
   rm -f .total01.tmp
   rm -f .total02.tmp
   rm -f temporaire.tmp
   rm -f temporaire01.tmp
   rm -f temporaire02.tmp
   rm -f temporaire03.tmp
   rm -f temporaire04.tmp
   rm -f temporaire05.tmp
   rm -f temporaire06.tmp
   rm -f Total.tmp
}


Fonction_Aide(){                                 
   echo -e "$VERT" "Programme de satistique sur l'usage des lettres dans une langue"
   echo -e "$VERT" "La cible doit etre un fichier.txt\n"
   echo -e "$VERT" "usage:"
   echo -e "$VERT" "Stats_lang <cible.txt>\n"
   echo -e "$VERT" "Stats_lang -v //pour le numéro de version\n"
   echo -e "$VERT" "Stats_lang <cible.txt> //pour le nombres de mots utilisant un charactère donné\n"
   echo -e "$VERT" "Stats_lang <cible.txt> --g //pour afficher un graphique\n"
   echo -e "$VERT" "Stats_lang <cible.txt> --d //pour le mode disparition. Renvois le nombre de mots ne comportant pas la cible"
   echo -e "$VERT" "La cible doit etre un charactère alphabétique.\n"
}


Fonction_tri(){
   echo -e "$JAUNE""--- Mise en ordre ---"; echo -en "$VERT""" 
   sort -nr temporaire03.tmp > temporaire04.tmp
   cat temporaire04.tmp
   rm -f temporaire03.tmp

}


Fonction_Pricipale(){
   for e in ${sequence[*]}
   do
      cat $1 | grep -ni "$e" > temporaire.tmp        # Tri le fichier en entrée et renvoie la sortie ne comportant que la lettre vers le fichier temporaire.tmp
      wc -l temporaire.tmp > temporaire01.tmp     # Compte le nombre de lignes dans le fichier ne comportant que les mots comportant l'objet de la recherche (lettre) et renvois son resultat sur celui-ci
      cut -d t -f 1 temporaire01.tmp > temporaire02.tmp   # Coupe la deuxieme colonne du fichier pour le réécrire proprement. 
      echo -e "   $(cat temporaire02.tmp)"" - $e - " >> temporaire03.tmp # Envois le résultat dans un fichier pour appliquer un tri
      rm -f temporaire02.tmp  # Reintialisation du fichier pour la lettre suivante
   done
   cat temporaire03.tmp
   Fonction_tri
}



Fonction_Disparition(){
   for e in ${sequence[*]}
   do
      cat $1 | grep -niv "$e" > temporaire.tmp         # Tri le fichier en entrée et renvoie la sortie ne comportant pas lettre vers le fichier temporaire.tmp
      wc -l temporaire.tmp > temporaire01.tmp      # Compte le nombre de lignes dans le fichier ne comportant que les mots comportant l'objet de la recherche (lettre) et renvois son resultat sur celui-ci
      cut -d t -f 1 temporaire01.tmp > temporaire02.tmp    # Coupe la deuxieme colonne du fichier pour le réécrire proprement.
      echo -e "   $(cat temporaire02.tmp)"" - $e - " >> temporaire03.tmp  # Envois le résultat dans un fichier pour appliquer un trie
      rm -f temporaire02.tmp  
   done
   cat temporaire03.tmp
   Fonction_tri
}


Fonction_Graph(){
   for e in ${sequence[*]} 
   do
      cat $1 | wc -l > Total.tmp   # Calcul du total
      total=`cut -d T -f 1 Total.tmp` # Stockage du resultat dans une variable
  

      cat $1 | grep -ni "$e" > temporaire.tmp   # Tri le fichier en entrée et renvoie la sortie ne comportant que la lettre vers le fichier temporaire.tmp       
      pourcent=`echo -e "$(echo -e "$(wc -l temporaire.tmp | cut -d t -f 1)")"`    # Compte le nombre de lignes est le renvois.
      let "pourcent = ($pourcent * 100)/"$total""   # Calcul du pourcentage
      let "barreG = $pourcent"/10                          # Ajout du barre-graphe. Divise le porcentage par dix pour afficher le nombre en barre
      i=0
      while [ $i != $barreG ]
      do
         echo -n "|" >> temporaire06.tmp # Ecriture du barre-graphe dans un fichier temporaire
         let i+=1 
      done
      barreGraphe=`cat temporaire06.tmp` # Assignation du contenu du fichier dans une variable
      echo -e "  $pourcent % - $e - $barreGraphe" >> temporaire05.tmp            # ecriture du pourcentage dans un fichier
      rm -f temporaire06.tmp   # Suppression du fichier temporaire
      touch temporaire06.tmp   # Recréation du fichier vide pour cohérence avec la commande cat qui leve une erreur quant aucun fichier n'est créer pareque aucun barre-graphe
   done 

   echo -e "$JAUNE""-- Statistiques ---"; echo -en "$VERT"""  
   cat temporaire05.tmp 
   echo -e "$JAUNE""--- Mise en ordre ---"; echo -en "$VERT""" 
   sort -nr temporaire05.tmp > temporaire04.tmp
   cat temporaire04.tmp
   rm -f temporaire03.tmp          
}


echo -e "$JAUNE""----------------------"             # DEBUT DU PROGRAMME//////////////////////////////////////////
echo -e "$VERT""  $0              "
echo -e "$VERT""    PID="$$"          "
echo -e "$JAUNE""----------------------"

echo -e "$VERT""    $1"                              # Affichage du nom du fichier cible.
echo -e "$JAUNE""----------------------"

if [ $# = 0 ]                                        # Message d'erreur si aucun parametre n'est passé à la commande.
then
Fonction_Erreur

elif [ $1 = -h ]                                     # Pour l'appel du parametre -h (aide/help)
then
Fonction_Aide

elif [ $1 = -v ]                                     # Pour appel de numéro de version.
then
Fonction_Version

else                                                 
test -f $1                                           # Vérification de l'existence du fichier.
   if [ $? = 1 ]
   then
   echo -e "$ROUGE""Erreur... Aucun fichier."
   Fonction_Quit

   else
   echo -e "$VERT""Total de mots:"                    # ENTETE DE LA PAGE..
   wc -w $1 1> .Var02.tmp 2> /dev/null                #
   cat .Var02.tmp                                     #
   echo -e "$JAUNE""----------------------"           #
                                                      #
   echo -e "$VERT""Total de charactères:"             #
   wc -m $1 1> .Var02.tmp 2> /dev/null                #
   cat .Var02.tmp                                     #
   echo -e "$JAUNE""----------------------"           #
   echo -e "$VERT""    STATISTIQUES   "               #
fi 


   if [ "$2" = --d ]
   then
   echo -e "$VERT""     Calcul //"
   echo -e "$JAUNE""----------------------"
   echo -e "$VERT"""
   Fonction_Disparition $1
   elif [ "$2" = --g ]
   then
   echo -e "$VERT""     Calcul //"
   echo -e "$JAUNE""----------------------"
   echo -e "$VERT"""
   Fonction_Graph $1
 else
   echo -e "$VERT""     Calcul //"
   echo -e "$JAUNE""----------------------"
   echo -e "$VERT"""
   Fonction_Pricipale $1 $2                           # Stat Langue 
                             
fi  
 

 


echo -e ""
echo -e "$JAUNE""----------------------"

fi
Fonction_Nettoyage

