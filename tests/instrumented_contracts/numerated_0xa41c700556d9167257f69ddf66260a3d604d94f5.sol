1 pragma solidity >=0.4.21 <0.6.0;
2 /*  CABRONTRAIL - MODULE INSCRIPTION / MISE A JOUR DU RCAI
3     Copyright (C) MXIX VALTHEFOX FOR MGNS. CAPITAL
4 
5     This program is free software: you can redistribute it and/or modify
6     it under the terms of the GNU General Public License as published by
7     the Free Software Foundation, either version 3 of the License, or
8     (at your option) any later version.
9 
10     This program is distributed in the hope that it will be useful,
11     but WITHOUT ANY WARRANTY; without even the implied warranty of
12     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
13     GNU General Public License for more details.
14 
15     See https://www.gnu.org/licenses/ for full terms.*/
16 
17 //------VARIABLES---------
18 
19 //info_concealed (String ASCII convertie en Hex) = 3 premieres lettres du nom du client - premiere lettre du nom du client - 4 dernières lettres du nom du client - 2 premiers chiffres du code postal du client - 4ème chiffre du code postal du client - 2 premières lettres de la ville du client
20 //client_full (String ASCII convertie en Hex) =  Identité du client au format PNCEE (NOM;PRENOM pour un particulier RAISON SOCIALE;SIRET pour un professionnel) encodée avec l'alogorithme MD5
21 //address_full (String ASCII convertie en Hex) = Adresse du client au format PNCEE (NUMERO DE VOIE NOM DE VOIE;CODE POSTAL; VILLE) encodée avec l'alogorithme MD5
22 //declared_for (String ASCII convertie en Hex) = Adresse de l'obligé dans la blockchain (e.g. MGNS. primary address = 0x62073c7c87c988f2Be0EAF41b5c0481df98e886E)
23 
24 //status = Code parmi la liste suivante
25 //BACCARA : Test
26 //1: Client Non Conforme
27 //2: Droit Suppression GPDR Client 
28 //3: Erreur Saisie
29 //4: -
30 //5: Entrée en relation sans RCAI
31 //6: Mise à jour fiche
32 //7: RCAI Antérieur 
33 //8: Entrée en Relation Arbitrage sans RCAI
34 //9: RCAI Bloc Actuel 
35 
36 //Exemple Entrée en relation de MGNS. avec lettre d'engagement envoyée par mail à M. Lucien Renard, 88 impasse du Colonel De Gaulle, 13001 MARSEILLE
37 //info_concealed : REN-L-ULLE-13-0-MA -> 0x52454E2D4C2D554C4C452D31332D302D4D410A
38 //client_full : MD5 ("RENARD;LUCIEN") = 7782b8d28bbc0afd1bfc6f84bcd1bceb -> 0x7782b8d28bbc0afd1bfc6f84bcd1bceb
39 //adress_full : MD5 ("88 IMPASSE DU COLONEL DE GAULLE;13001;MARSEILLE") = 40d3001c5cb5946d1d62b8b1363ec967 -> 0x40d3001c5cb5946d1d62b8b1363ec967
40 //declared_for :  0x62073c7c87c988f2Be0EAF41b5c0481df98e886E
41 //status : 9
42 
43 contract CARBONTRAIL_RCAI {
44     event RCAI(
45         bytes32 info_concealed,
46         bytes32 client_full, 
47         bytes32 address_full,
48         address declared_by,
49         address declared_for,
50         uint status,
51         uint timestamp,
52         uint block
53     );
54 
55     function newRCAI(bytes32 info_concealed, bytes32 client_full, bytes32 address_full, address declared_for, uint status) public  {
56         emit RCAI(info_concealed, client_full, address_full, msg.sender, declared_for, status, block.timestamp, block.number);
57     }
58 
59     event URCAI(
60         bytes32 client_full, 
61         bytes32 address_full,
62         address declared_by,
63         address declared_for,
64         uint status,
65         uint timestamp,
66         uint block
67     );
68 
69 function updateRCAI(bytes32 client_full, bytes32 address_full, address declared_for, uint status) public  {
70         emit URCAI(client_full, address_full, msg.sender, declared_for, status, block.timestamp, block.number);
71     }
72 }