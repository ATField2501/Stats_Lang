#!/bin/bash
# -*- coding: utf8
# Auteur: Cagliostro <atfield2501@gmail.com>
# Script de statistique sur l'usage des lettres dans une langue donnée.


ROUGE="\\033[1;31m"
JAUNE="\\033[1;33m"
VERT="\\033[1;32m"

letters=("A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z")

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


Fonction_Pricipale(){
   i=0
   let "max=26"
   while [ $i != $max ]
   do    
      mot=${letters[$i]}                                  # Utilisation d'un tableau pour ne pas repeter la procedure 26 fois.
      cat $1 | grep -ni $mot > temporaire.tmp             # Tri le fichier en entrée et renvoie la sortie ne comportant que la lettre vers le fichier temporaire.tmp
      wc -l temporaire.tmp > temporaire01.tmp             # Compte le nombre de lignes dans le fichier ne comportant que les mots avec l'objet de la recherche (lettre) et renvois son resultat sur celui-ci
      cut -d t -f 1 temporaire01.tmp > temporaire02.tmp   # Coupe la deuxieme colonne du fichier pour le réécrire proprement.
      echo -e "   $(cat temporaire02.tmp)"" - "$mot" - " >> temporaire03.tmp  # Envois le résultat dans un fichier pour appliquer un trie             
      let i+=1
   done

   sort -nr temporaire03.tmp > temporaire04.tmp
   cat temporaire04.tmp
   rm -f temporaire04.tmp
}



Fonction_Disparition(){
   i=0
   let "max=26"
   while [ $i != $max ]
   do    
      mot=${letters[$i]}  
      cat $1 | grep -niv $mot > temporaire.tmp               # Tri le fichier en entrée et renvoie la sortie ne comportant pas lettre vers le fichier temporaire.tmp
      wc -l temporaire.tmp > temporaire01.tmp               # Compte le nombre de lignes ne comportant que les mots avec l'objet de la recherche (lettre) et renvois son resultat sur celui-ci
      cut -d t -f 1 temporaire01.tmp > temporaire02.tmp     # Coupe la deuxieme colonne du fichier pour le réécrire proprement.
      echo -e "   $(cat temporaire02.tmp)"" - "$mot" - " >> temporaire03.tmp  # Envois le résultat dans un fichier pour appliquer un trie
      let i+=1
   done

   sort -nr temporaire03.tmp > temporaire04.tmp
   cat temporaire04.tmp
  

}


Fonction_Graph(){
   cat $1 | wc -l > Total.tmp   # Calcul du total
   total=`cut -d T -f 1 Total.tmp` # Stockage du resultat dans une variable
  

   cat $1 | grep -ni "a" > temporaire.tmp   # Tri le fichier en entrée et renvoie la sortie ne comportant que la lettre vers le fichier temporaire.tmp       
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
   echo -e "  $pourcent % - A - $barreGraphe" >> temporaire05.tmp            # ecriture du pourcentage dans un fichier
   rm -f temporaire06.tmp   # Suppression du fichier temporaire
   touch temporaire06.tmp   # REcréation du fichier vide pour cohérence avec la commande cat qui leve une erreur quant aucun fichier n'est créer pareque aucun barre-graphe


   cat $1 | grep -ni "b" > temporaire.tmp        
   pourcent=`echo -e "$(echo -e "$(wc -l temporaire.tmp | cut -d t -f 1)")"`   
   let "pourcent = ($pourcent * 100)/"$total""   
   let "barreG = $pourcent"/10    
   i=0
   while [ $i != $barreG ]
   do
      echo -n "|" >> temporaire06.tmp 
      let i+=1 
   done
   barreGraphe=`cat temporaire06.tmp` 
   echo -e "  $pourcent % - B - $barreGraphe" >> temporaire05.tmp           
   rm -f temporaire06.tmp
   touch temporaire06.tmp


   cat $1 | grep -ni "c" > temporaire.tmp        
   pourcent=`echo -e "$(echo -e "$(wc -l temporaire.tmp | cut -d t -f 1)")"`   
   let "pourcent = ($pourcent * 100)/"$total""   
   let "barreG = $pourcent"/10    
   i=0
   while [ $i != $barreG ]
   do
      echo -n "|" >> temporaire06.tmp 
      let i+=1 
   done
   barreGraphe=`cat temporaire06.tmp` 
   echo -e "  $pourcent % - c - $barreGraphe" >> temporaire05.tmp           
   rm -f temporaire06.tmp
   touch temporaire06.tmp

    
   cat $1 | grep -ni "d" > temporaire.tmp        
   pourcent=`echo -e "$(echo -e "$(wc -l temporaire.tmp | cut -d t -f 1)")"`   
   let "pourcent = ($pourcent * 100)/"$total""   
   let "barreG = $pourcent"/10    
   i=0
   while [ $i != $barreG ]
   do
      echo -n "|" >> temporaire06.tmp 
      let i+=1 
   done
   barreGraphe=`cat temporaire06.tmp` 
   echo -e "  $pourcent % - D - $barreGraphe" >> temporaire05.tmp           
   rm -f temporaire06.tmp
   touch temporaire06.tmp

     
   cat $1 | grep -ni "e" > temporaire.tmp        
   pourcent=`echo -e "$(echo -e "$(wc -l temporaire.tmp | cut -d t -f 1)")"`   
   let "pourcent = ($pourcent * 100)/"$total""   
   let "barreG = $pourcent"/10    
   i=0
   while [ $i != $barreG ]
   do
      echo -n "|" >> temporaire06.tmp 
      let i+=1 
   done
   barreGraphe=`cat temporaire06.tmp` 
   echo -e "  $pourcent % - E - $barreGraphe" >> temporaire05.tmp           
   rm -f temporaire06.tmp
   touch temporaire06.tmp

       
   cat $1 | grep -ni "f" > temporaire.tmp        
   pourcent=`echo -e "$(echo -e "$(wc -l temporaire.tmp | cut -d t -f 1)")"`   
   let "pourcent = ($pourcent * 100)/"$total""   
   let "barreG = $pourcent"/10    
   i=0
   while [ $i != $barreG ]
   do
      echo -n "|" >> temporaire06.tmp 
      let i+=1 
   done
   barreGraphe=`cat temporaire06.tmp` 
   echo -e "  $pourcent % - F - $barreGraphe" >> temporaire05.tmp           
   rm -f temporaire06.tmp
   touch temporaire06.tmp

    
   cat $1 | grep -ni "g" > temporaire.tmp        
   pourcent=`echo -e "$(echo -e "$(wc -l temporaire.tmp | cut -d t -f 1)")"`   
   let "pourcent = ($pourcent * 100)/"$total""   
   let "barreG = $pourcent"/10    
   i=0
   while [ $i != $barreG ]
   do
      echo -n "|" >> temporaire06.tmp 
      let i+=1 
   done
   barreGraphe=`cat temporaire06.tmp` 
   echo -e "  $pourcent % - G - $barreGraphe" >> temporaire05.tmp           
   rm -f temporaire06.tmp
   touch temporaire06.tmp

   
   cat $1 | grep -ni "h" > temporaire.tmp        
   pourcent=`echo -e "$(echo -e "$(wc -l temporaire.tmp | cut -d t -f 1)")"`   
   let "pourcent = ($pourcent * 100)/"$total""   
   let "barreG = $pourcent"/10    
   i=0
   while [ $i != $barreG ]
   do
      echo -n "|" >> temporaire06.tmp 
      let i+=1 
   done
   barreGraphe=`cat temporaire06.tmp` 
   echo -e "  $pourcent % - H - $barreGraphe" >> temporaire05.tmp           
   rm -f temporaire06.tmp
   touch temporaire06.tmp

   
   cat $1 | grep -ni "i" > temporaire.tmp        
   pourcent=`echo -e "$(echo -e "$(wc -l temporaire.tmp | cut -d t -f 1)")"`   
   let "pourcent = ($pourcent * 100)/"$total""   
   let "barreG = $pourcent"/10    
   i=0
   while [ $i != $barreG ]
   do
      echo -n "|" >> temporaire06.tmp 
      let i+=1 
   done
   barreGraphe=`cat temporaire06.tmp` 
   echo -e "  $pourcent % - I - $barreGraphe" >> temporaire05.tmp           
   rm -f temporaire06.tmp
   touch temporaire06.tmp

  
   cat $1 | grep -ni "j" > temporaire.tmp        
   pourcent=`echo -e "$(echo -e "$(wc -l temporaire.tmp | cut -d t -f 1)")"`   
   let "pourcent = ($pourcent * 100)/"$total""   
   let "barreG = $pourcent"/10    
   i=0
   while [ $i != $barreG ]
   do
      echo -n "|" >> temporaire06.tmp 
      let i+=1 
   done
   barreGraphe=`cat temporaire06.tmp` 
   echo -e "  $pourcent % - J - $barreGraphe" >> temporaire05.tmp           
   rm -f temporaire06.tmp
   touch temporaire06.tmp

      
   cat $1 | grep -ni "k" > temporaire.tmp        
   pourcent=`echo -e "$(echo -e "$(wc -l temporaire.tmp | cut -d t -f 1)")"`   
   let "pourcent = ($pourcent * 100)/"$total""   
   let "barreG = $pourcent"/10    
   i=0
   while [ $i != $barreG ]
   do
      echo -n "|" >> temporaire06.tmp 
      let i+=1 
   done
   barreGraphe=`cat temporaire06.tmp` 
   echo -e "  $pourcent % - K - $barreGraphe" >> temporaire05.tmp           
   rm -f temporaire06.tmp
   touch temporaire06.tmp


   cat $1 | grep -ni "l" > temporaire.tmp        
   pourcent=`echo -e "$(echo -e "$(wc -l temporaire.tmp | cut -d t -f 1)")"`   
   let "pourcent = ($pourcent * 100)/"$total""   
   let "barreG = $pourcent"/10    
   i=0
   while [ $i != $barreG ]
   do
      echo -n "|" >> temporaire06.tmp 
      let i+=1 
   done
   barreGraphe=`cat temporaire06.tmp` 
   echo -e "  $pourcent % - L - $barreGraphe" >> temporaire05.tmp           
   rm -f temporaire06.tmp
   touch temporaire06.tmp


   cat $1 | grep -ni "m" > temporaire.tmp        
   pourcent=`echo -e "$(echo -e "$(wc -l temporaire.tmp | cut -d t -f 1)")"`   
   let "pourcent = ($pourcent * 100)/"$total""   
   let "barreG = $pourcent"/10    
   i=0
   while [ $i != $barreG ]
   do
      echo -n "|" >> temporaire06.tmp 
      let i+=1 
   done
   barreGraphe=`cat temporaire06.tmp` 
   echo -e "  $pourcent % - M - $barreGraphe" >> temporaire05.tmp           
   rm -f temporaire06.tmp
   touch temporaire06.tmp

 
   cat $1 | grep -ni "n" > temporaire.tmp        
   pourcent=`echo -e "$(echo -e "$(wc -l temporaire.tmp | cut -d t -f 1)")"`   
   let "pourcent = ($pourcent * 100)/"$total""   
   let "barreG = $pourcent"/10    
   i=0
   while [ $i != $barreG ]
   do
      echo -n "|" >> temporaire06.tmp 
      let i+=1 
   done
   barreGraphe=`cat temporaire06.tmp` 
   echo -e "  $pourcent % - N - $barreGraphe" >> temporaire05.tmp           
   rm -f temporaire06.tmp
   touch temporaire06.tmp

   
   cat $1 | grep -ni "o" > temporaire.tmp        
   pourcent=`echo -e "$(echo -e "$(wc -l temporaire.tmp | cut -d t -f 1)")"`   
   let "pourcent = ($pourcent * 100)/"$total""   
   let "barreG = $pourcent"/10    
   i=0
   while [ $i != $barreG ]
   do
      echo -n "|" >> temporaire06.tmp 
      let i+=1 
   done
   barreGraphe=`cat temporaire06.tmp` 
   echo -e "  $pourcent % - O - $barreGraphe" >> temporaire05.tmp           
   rm -f temporaire06.tmp
   touch temporaire06.tmp


   cat $1 | grep -ni "p" > temporaire.tmp        
   pourcent=`echo -e "$(echo -e "$(wc -l temporaire.tmp | cut -d t -f 1)")"`   
   let "pourcent = ($pourcent * 100)/"$total""   
   let "barreG = $pourcent"/10    
   i=0
   while [ $i != $barreG ]
   do
      echo -n "|" >> temporaire06.tmp 
      let i+=1 
   done
   barreGraphe=`cat temporaire06.tmp` 
   echo -e "  $pourcent % - P - $barreGraphe" >> temporaire05.tmp           
   rm -f temporaire06.tmp
   touch temporaire06.tmp


   cat $1 | grep -ni "q" > temporaire.tmp        
   pourcent=`echo -e "$(echo -e "$(wc -l temporaire.tmp | cut -d t -f 1)")"`   
   let "pourcent = ($pourcent * 100)/"$total""   
   let "barreG = $pourcent"/10    
   i=0
   while [ $i != $barreG ]
   do
      echo -n "|" >> temporaire06.tmp 
      let i+=1 
   done
   barreGraphe=`cat temporaire06.tmp` 
   echo -e "  $pourcent % - Q - $barreGraphe" >> temporaire05.tmp           
   rm -f temporaire06.tmp
   touch temporaire06.tmp


   cat $1 | grep -ni "r" > temporaire.tmp        
   pourcent=`echo -e "$(echo -e "$(wc -l temporaire.tmp | cut -d t -f 1)")"`   
   let "pourcent = ($pourcent * 100)/"$total""   
   let "barreG = $pourcent"/10    
   i=0
   while [ $i != $barreG ]
   do
      echo -n "|" >> temporaire06.tmp 
      let i+=1 
   done
   barreGraphe=`cat temporaire06.tmp` 
   echo -e "  $pourcent % - R - $barreGraphe" >> temporaire05.tmp           
   rm -f temporaire06.tmp
   touch temporaire06.tmp


   cat $1 | grep -ni "s" > temporaire.tmp        
   pourcent=`echo -e "$(echo -e "$(wc -l temporaire.tmp | cut -d t -f 1)")"`   
   let "pourcent = ($pourcent * 100)/"$total""   
   let "barreG = $pourcent"/10    
   i=0
   while [ $i != $barreG ]
   do
      echo -n "|" >> temporaire06.tmp 
      let i+=1 
   done
   barreGraphe=`cat temporaire06.tmp` 
   echo -e "  $pourcent % - S - $barreGraphe" >> temporaire05.tmp           
   rm -f temporaire06.tmp
   touch temporaire06.tmp


   cat $1 | grep -ni "t" > temporaire.tmp        
   pourcent=`echo -e "$(echo -e "$(wc -l temporaire.tmp | cut -d t -f 1)")"`   
   let "pourcent = ($pourcent * 100)/"$total""   
   let "barreG = $pourcent"/10    
   i=0
   while [ $i != $barreG ]
   do
      echo -n "|" >> temporaire06.tmp 
      let i+=1 
   done
   barreGraphe=`cat temporaire06.tmp` 
   echo -e "  $pourcent % - T - $barreGraphe" >> temporaire05.tmp           
   rm -f temporaire06.tmp
   touch temporaire06.tmp

                                       
   cat $1 | grep -ni "u" > temporaire.tmp        
   pourcent=`echo -e "$(echo -e "$(wc -l temporaire.tmp | cut -d t -f 1)")"`   
   let "pourcent = ($pourcent * 100)/"$total""   
   let "barreG = $pourcent"/10    
   i=0
   while [ $i != $barreG ]
   do
      echo -n "|" >> temporaire06.tmp 
      let i+=1 
   done
   barreGraphe=`cat temporaire06.tmp` 
   echo -e "  $pourcent % - U - $barreGraphe" >> temporaire05.tmp           
   rm -f temporaire06.tmp
   touch temporaire06.tmp

 
   cat $1 | grep -ni "v" > temporaire.tmp        
   pourcent=`echo -e "$(echo -e "$(wc -l temporaire.tmp | cut -d t -f 1)")"`   
   let "pourcent = ($pourcent * 100)/"$total""   
   let "barreG = $pourcent"/10    
   i=0
   while [ $i != $barreG ]
   do
      echo -n "|" >> temporaire06.tmp 
      let i+=1 
   done
   barreGraphe=`cat temporaire06.tmp` 
   echo -e "  $pourcent % - V - $barreGraphe" >> temporaire05.tmp           
   rm -f temporaire06.tmp
   touch temporaire06.tmp


   cat $1 | grep -ni "w" > temporaire.tmp        
   pourcent=`echo -e "$(echo -e "$(wc -l temporaire.tmp | cut -d t -f 1)")"`   
   let "pourcent = ($pourcent * 100)/"$total""   
   let "barreG = $pourcent"/10    
   i=0
   while [ $i != $barreG ]
   do
      echo -n "|" >> temporaire06.tmp 
      let i+=1 
   done
   barreGraphe=`cat temporaire06.tmp` 
   echo -e "  $pourcent % - W - $barreGraphe" >> temporaire05.tmp           
   rm -f temporaire06.tmp
   touch temporaire06.tmp


   cat $1 | grep -ni "x" > temporaire.tmp        
   pourcent=`echo -e "$(echo -e "$(wc -l temporaire.tmp | cut -d t -f 1)")"`   
   let "pourcent = ($pourcent * 100)/"$total""   
   let "barreG = $pourcent"/10    
   i=0
   while [ $i != $barreG ]
   do
      echo -n "|" >> temporaire06.tmp 
      let i+=1 
   done
   barreGraphe=`cat temporaire06.tmp` 
   echo -e "  $pourcent % - X - $barreGraphe" >> temporaire05.tmp           
   rm -f temporaire06.tmp
   touch temporaire06.tmp

            
   cat $1 | grep -ni "y" > temporaire.tmp        
   pourcent=`echo -e "$(echo -e "$(wc -l temporaire.tmp | cut -d t -f 1)")"`   
   let "pourcent = ($pourcent * 100)/"$total""   
   let "barreG = $pourcent"/10    
   i=0
   while [ $i != $barreG ]
   do
      echo -n "|" >> temporaire06.tmp 
      let i+=1 
   done
   barreGraphe=`cat temporaire06.tmp` 
   echo -e "  $pourcent % - Y - $barreGraphe" >> temporaire05.tmp           
   rm -f temporaire06.tmp
   touch temporaire06.tmp


   cat $1 | grep -ni "z" > temporaire.tmp        
   pourcent=`echo -e "$(echo -e "$(wc -l temporaire.tmp | cut -d t -f 1)")"`   
   let "pourcent = ($pourcent * 100)/"$total""   
   let "barreG = $pourcent"/10    
   i=0
   while [ $i != $barreG ]
   do
      echo -n "|" >> temporaire06.tmp 
      let i+=1 
   done
   barreGraphe=`cat temporaire06.tmp` 
   echo -e "  $pourcent % - Z - $barreGraphe" >> temporaire05.tmp           
   rm -f temporaire06.tmp
   touch temporaire06.tmp

 

   sort -nr temporaire05.tmp >> temporaire04.tmp
   echo -e "$JAUNE""-- Statistiques ---"; echo -en "$VERT""" 
   cat temporaire05.tmp
   echo -e "$JAUNE""--- Mise en ordre ---"; echo -en "$VERT""" 
   cat temporaire04.tmp
              
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

