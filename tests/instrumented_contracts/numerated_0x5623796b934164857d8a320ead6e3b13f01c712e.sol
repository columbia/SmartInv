1 pragma solidity >=0.4.21 <0.6.0;
2 /*  CARBONTRAIL - MODULE OPESTA
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
19 //reference_interne (String ASCII convertie en Hex) = Référence dossier
20 //fiche (String ASCII convertie en Hex) = Référence fiche_opération_standardisée
21 //volumekWh(Integer) = Volume de CEE  en kWh CUMAC
22 //date_engagement(Integer) = Nombre de secondes entre le 1er Janvier 1970 et la date d'engagement de l'opération
23 //date_facture(Integer) = Nombre de secondes entre le 1er Janvier 1970 et la date de facture
24 //pro = (String ASCII convertie en Hex) =  Identité du pro au format PNCEE (RAISON SOCIALE;SIREN;ou RAISON SOCIALE;SIREN SOUS TRAITANT;RAISON SOCIALE;SIREN SOUS TRAITANT) encodée avec l'alogorithme MD5
25 //client_full (String ASCII convertie en Hex) =  Identité du client au format PNCEE (NOM;PRENOM pour un particulier RAISON SOCIALE;SIREN pour un professionnel) encodée avec l'alogorithme MD5
26 //address_full (String ASCII convertie en Hex) = Adresse de réalisation de l'opération au format PNCEE (NUMERO DE VOIE NOM DE VOIE;CODE POSTAL; VILLE) encodée avec l'alogorithme MD5
27 //declared_for (String ASCII convertie en Hex) = Adresse de l'obligé dans la blockchain (e.g. MGNS. primary address = 0x62073c7c87c988f2Be0EAF41b5c0481df98e886E)
28 
29 //nature_bon = Code parmi la liste suivante
30 //BACCARA : Arbitrage
31 //1 : Contribution financière (monnaie fiducaire ou cryptomonnaie) 
32 //2 : Bon d'achat pour des produits de consommation courante
33 //3 : Prêt bonifié
34 //4 : Audit ou conseil
35 //5 : Produit ou service offert
36 //6 : Opération réalisée sur patrimoine propre
37 
38 
39 //status = Code parmi la liste suivante
40 //BACCARA : Test
41 //1: Annulation Non Conformité
42 //2: Annulation Droit Suppression GPDR Client 
43 //3: Annulation Erreur Saisie
44 //4: -
45 //5: Documents reçus 
46 //6: Validé interne
47 //7: Déposé PNCEE
48 //8: Arbitrage
49 //9: Validé PNCEE
50 
51 //Exemple MGNS. s'engage le 16/01/2019 a poser gratuitement des mousseurs sur les 750 robinets de l'ECOLE DE CIRQUE PITRERIES 2 RUE DE STRASBOURG 83210 SOLLIES PONT SIRET 42493526000036. Posé et facturé par FRANCE MERGUEZ DISTRIBUTION SIRET 34493368400021 le 17/01/2019. ASH numéro MPE400099. Enregistrement dans la blockchain lors du dépot au PNCEE.
52 //client_full : MD5 ("ECOLE DE CIRQUE PITRERIES;42493526") = 95be74bce973b492a060a4a5e38fb916 -> 0x95be74bce973b492a060a4a5e38fb916
53 //adress_full : MD5 ("2 RUE DE STRASBOURG;83210;SOLLIES PONT") = c86f2d95804c4af2a1cbf85d64df29e0 -> 0xc86f2d95804c4af2a1cbf85d64df29e0
54 //pro : MD5 ("FRANCE MERGUEZ DISTRIBUTION;344933684") = 4cf60fe171f7487aedb1c0892f2614eb -> 0x4cf60fe171f7487aedb1c0892f2614eb
55 //declared_for :  0x62073c7c87c988f2Be0EAF41b5c0481df98e886E
56 //nature_bon : 5
57 //status : 7
58 //reference_interne : MPE400099 -> 0x4D50453430303039390A
59 //fiche : BAT-EQ-133 -> 0x4241542D45512D3133330A
60 //volumekWh : 2031750
61 //date_engagement : 1547659037
62 //date_facture : 1547745437
63 
64 contract CARBONTRAIL_OPESTA {
65     event OPESTA(
66         bytes32 client_full, 
67         bytes32 address_full,
68         bytes32 pro,
69         address declared_by,
70         address declared_for,
71         uint nature_bon,
72         uint status,
73         bytes32 reference_interne,
74         bytes32 fiche,
75         uint volumekWh,
76         uint date_engagement,
77         uint date_facture,
78         uint timestamp,
79         uint block
80     );
81 
82     function newOPESTA(bytes32 client_full, bytes32 address_full, bytes32 pro, address declared_for, uint nature_bon, uint status, bytes32 reference_interne, bytes32 fiche, uint volumekWh, uint date_engagement, uint date_facture) public  {
83         emit OPESTA(client_full, address_full, pro, msg.sender, declared_for, nature_bon, status, reference_interne, fiche, volumekWh, date_engagement, date_facture, block.timestamp, block.number);
84     }
85     
86     event UOPESTA(
87         bytes32 client_full, 
88         bytes32 address_full,
89         bytes32 pro,
90         address declared_by,
91         address declared_for,
92         uint nature_bon,
93         uint status,
94         bytes32 reference_interne,
95         bytes32 fiche,
96         uint volumekWh,
97         uint date_engagement,
98         uint date_facture,
99         uint timestamp,
100         uint block
101     );
102 
103     function updateOPESTA(bytes32 client_full, bytes32 address_full, bytes32 pro, address declared_for, uint nature_bon, uint status, bytes32 reference_interne, bytes32 fiche, uint volumekWh, uint date_engagement, uint date_facture) public  {
104         emit UOPESTA(client_full, address_full, pro, msg.sender, declared_for, nature_bon, status, reference_interne, fiche, volumekWh, date_engagement, date_facture, block.timestamp, block.number);
105     }
106 }