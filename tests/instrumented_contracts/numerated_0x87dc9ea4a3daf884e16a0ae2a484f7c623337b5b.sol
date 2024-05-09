1 pragma solidity 		^0.4.8	;						
2 											
3 		contract	Ownable		{						
4 			address	owner	;						
5 											
6 			function	Ownable	() {						
7 				owner	= msg.sender;						
8 			}								
9 											
10 			modifier	onlyOwner	() {						
11 				require(msg.sender ==		owner	);				
12 				_;							
13 			}								
14 											
15 			function 	transfertOwnership		(address	newOwner	)	onlyOwner	{	
16 				owner	=	newOwner	;				
17 			}								
18 		}									
19 											
20 											
21 											
22 		contract	YUZHURALZOLOTO_FORM_01				is	Ownable	{		
23 											
24 			string	public	constant	name =	"	YUZHURALZOLOTO_FORM_01		"	;
25 			string	public	constant	symbol =	"	UZU_01		"	;
26 			uint32	public	constant	decimals =		18			;
27 			uint	public		totalSupply =		0			;
28 											
29 			mapping (address => uint) balances;								
30 			mapping (address => mapping(address => uint)) allowed;								
31 											
32 			function mint(address _to, uint _value) onlyOwner {								
33 				assert(totalSupply + _value >= totalSupply && balances[_to] + _value >= balances[_to]);							
34 				balances[_to] += _value;							
35 				totalSupply += _value;							
36 			}								
37 											
38 			function balanceOf(address _owner) constant returns (uint balance) {								
39 				return balances[_owner];							
40 			}								
41 											
42 			function transfer(address _to, uint _value) returns (bool success) {								
43 				if(balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {							
44 					balances[msg.sender] -= _value; 						
45 					balances[_to] += _value;						
46 					return true;						
47 				}							
48 				return false;							
49 			}								
50 											
51 			function transferFrom(address _from, address _to, uint _value) returns (bool success) {								
52 				if( allowed[_from][msg.sender] >= _value &&							
53 					balances[_from] >= _value 						
54 					&& balances[_to] + _value >= balances[_to]) {						
55 					allowed[_from][msg.sender] -= _value;						
56 					balances[_from] -= _value;						
57 					balances[_to] += _value;						
58 					Transfer(_from, _to, _value);						
59 					return true;						
60 				}							
61 				return false;							
62 			}								
63 											
64 			function approve(address _spender, uint _value) returns (bool success) {								
65 				allowed[msg.sender][_spender] = _value;							
66 				Approval(msg.sender, _spender, _value);							
67 				return true;							
68 			}								
69 											
70 			function allowance(address _owner, address _spender) constant returns (uint remaining) {								
71 				return allowed[_owner][_spender];							
72 			}								
73 											
74 			event Transfer(address indexed _from, address indexed _to, uint _value);								
75 			event Approval(address indexed _owner, address indexed _spender, uint _value);								
76 										
77 											
78 											
79 											
80 //	1	Possible 1.1 « crédit »					« Défaut obligataire, obilgation (i), nominal »				
81 //	2	Possible 1.2 « crédit »					« Défaut obligataire, obilgation (i), intérêts »				
82 //	3	Possible 1.3 « crédit »					« Défaut obligataire, obilgation (iI), nominal »				
83 //	4	Possible 1.4 « crédit »					« Défaut obligataire, obilgation (ii), intérêts »				
84 //	5	Possible 1.5 « crédit »					« Assurance-crédit, support = police (i) »				
85 //	6	Possible 1.6 « crédit »					« Assurance-crédit, support = portefeuille de polices (j) »				
86 //	7	Possible 1.7 « crédit »					« Assurance-crédit, support = indice de polices (k) »				
87 //	8	Possible 1.8 « crédit »					« Assurance-crédit export, support = police (i) »				
88 //	9	Possible 1.9 « crédit »					« Assurance-crédit export, support = portefeuille de polices (j) »				
89 //	10	Possible 1.10 « crédit »					« Assurance-crédit export, support = indice de polices (k) »				
90 //	11	Possible 2.1 « liquidité »					« Trésorerie libre »				
91 //	12	Possible 2.2 « liquidité »					« Capacité temporaire à générer des flux de trésorerie libre »				
92 //	13	Possible 2.3 « liquidité »					« Capacités structurelles à générer ces flux »				
93 //	14	Possible 2.4 « liquidité »					« Accès aux découverts à court terme »				
94 //	15	Possible 2.5 « liquidité »					« Accès aux découverts à moyen terme »				
95 //	16	Possible 2.6 « liquidité »					« Accès aux financements bancaires »				
96 //	17	Possible 2.7 « liquidité »					« Accès aux financements institutionnels non-bancaires »				
97 //	18	Possible 2.8 « liquidité »					« Accès aux financements de pools pair à pair »				
98 //	19	Possible 2.9 « liquidité »					« IP-Matrice entités »				
99 //	20	Possible 2.10 « liquidité »					« IP-Matrice juridictions »				
100 //	21	Possible 3.1 « solvabilité »					« Niveau du ratio de solvabilité »				
101 //	22	Possible 3.2 « solvabilité »					« Restructuration »				
102 //	23	Possible 3.3 « solvabilité »					« Redressement »				
103 //	24	Possible 3.4 « solvabilité »					« Liquidation »				
104 //	25	Possible 3.5 « solvabilité »					« Déclaration de faillite, statut (i) »				
105 //	26	Possible 3.6 « solvabilité »					« Déclaration de faillite, statut (ii) »				
106 //	27	Possible 3.7 « solvabilité »					« Déclaration de faillite, statut (iii) »				
107 //	28	Possible 3.8 « solvabilité »					« Faillite effective / de fait »				
108 //	29	Possible 3.9 « solvabilité »					« IP-Matrice entités »				
109 //	30	Possible 3.10 « solvabilité »					« IP-Matrice juridictions »				
110 //	31	Possible 4.1 « états financiers »					« Chiffres d'affaires »				
111 //	32	Possible 4.2 « états financiers »					« Taux de rentabilité »				
112 //	33	Possible 4.3 « états financiers »					« Eléments bilantiels »				
113 //	34	Possible 4.4 « états financiers »					« Eléments relatifs aux ngagements hors-bilan »				
114 //	35	Possible 4.5 « états financiers »					« Eléments relatifs aux engagements hors-bilan : assurances sociales »				
115 //	36	Possible 4.6 « états financiers »					« Eléments relatifs aux engagements hors-bilan : prestations de rentes »				
116 //	37	Possible 4.7 « états financiers »					« Capacités de titrisation »				
117 //	38	Possible 4.8 « états financiers »					« Simulations éléments OBS (i) »				
118 //	39	Possible 4.9 « états financiers »					« Simulations éléments OBS (ii) »				
119 //	40	Possible 4.10 « états financiers »					« Simulations éléments OBS (iii) »				
120 //	41	Possible 5.1 « fonctions marchés »					« Ressources informationnelles brutes »				
121 //	42	Possible 5.2 « fonctions marchés »					« Ressources prix indicatifs »				
122 //	43	Possible 5.3 « fonctions marchés »					« Ressources prix fermes »  / « Carnets d'ordres »				
123 //	44	Possible 5.4 « fonctions marchés »					« Routage »				
124 //	45	Possible 5.5 « fonctions marchés »					« Négoce »				
125 //	46	Possible 5.6 « fonctions marchés »					« Places de marché »				
126 //	47	Possible 5.7 « fonctions marchés »					« Infrastructures matérielles »				
127 //	48	Possible 5.8 « fonctions marchés »					« Infrastructures logicielles »				
128 //	49	Possible 5.9 « fonctions marchés »					« Services de maintenance »				
129 //	50	Possible 5.10 « fonctions marchés »					« Solutions de renouvellement »				
130 //	51	Possible 6.1 « métiers post-marchés »					« Accès contrepartie centrale »				
131 //	52	Possible 6.2 « métiers post-marchés »					« Accès garant »				
132 //	53	Possible 6.3 « métiers post-marchés »					« Accès dépositaire » / « Accès dépositaire-contrepartie centrale »				
133 //	54	Possible 6.4 « métiers post-marchés »					« Accès chambre de compensation »				
134 //	55	Possible 6.5 « métiers post-marchés »					« Accès opérateur de règlement-livraison »				
135 //	56	Possible 6.6 « métiers post-marchés »					« Accès teneur de compte »				
136 //	57	Possible 6.7 « métiers post-marchés »					« Accès marchés prêts-emprunts de titres »				
137 //	58	Possible 6.8 « métiers post-marchés »					« Accès rémunération des comptes de devises en dépôt »				
138 //	59	Possible 6.9 « métiers post-marchés »					« Accès rémunération des comptes d'actifs en dépôt »				
139 //	60	Possible 6.10 « métiers post-marchés »					« Accès aux mécanismes de dépôt et appels de marge »				
140 //	61	Possible 7.1 « services financiers annexes »					« Système international de notation / sphère (i) »				
141 //	62	Possible 7.2 « services financiers annexes »					« Système international de notation / sphère (ii) »				
142 //	63	Possible 7.3 « services financiers annexes »					« Ressources informationnelles : études et recherches / sphère (i) »				
143 //	64	Possible 7.4 « services financiers annexes »					« Ressources informationnelles : études et recherches / sphère (ii) »				
144 //	65	Possible 7.5 « services financiers annexes »					« Eligibilité, groupe (i) »				
145 //	66	Possible 7.6 « services financiers annexes »					« Eligibilité, groupe (ii) »				
146 //	67	Possible 7.7 « services financiers annexes »					« Identifiant système de prélèvements programmables »				
147 //	68	Possible 7.8 « services financiers annexes »					« Ressources actuarielles »				
148 //	69	Possible 7.9 « services financiers annexes »					« Services fiduciaires »				
149 //	70	Possible 7.10 « services financiers annexes »					« Standards de prévention et remise sur primes de couverture »				
150 //	71	Possible 8.1 « services financiers annexes »					« Négoce / front »				
151 //	72	Possible 8.2 « services financiers annexes »					« Négoce / OTC »				
152 //	73	Possible 8.3 « services financiers annexes »					« Contrôle / middle »				
153 //	74	Possible 8.4 « services financiers annexes »					« Autorisation / middle »				
154 //	75	Possible 8.5 « services financiers annexes »					« Comptabilité / back »				
155 //	76	Possible 8.6 « services financiers annexes »					« Révision interne »				
156 //	77	Possible 8.7 « services financiers annexes »					« Révision externe »				
157 //	78	Possible 8.8 « services financiers annexes »					« Mise en conformité »				
158 											
159 											
160 											
161 											
162 //	79	Possible 9.1 « système bancaire »					« National »				
163 //	80	Possible 9.2 « système bancaire »					« International »				
164 //	81	Possible 9.3 « système bancaire »					« Holdings-filiales-groupes »				
165 //	82	Possible 9.4 « système bancaire »					« Système de paiement sphère (i = pro) »				
166 //	83	Possible 9.5 « système bancaire »					« Système de paiement sphère (ii = v) »				
167 //	84	Possible 9.6 « système bancaire »					« Système de paiement sphère (iii = neutre) »				
168 //	85	Possible 9.7 « système bancaire »					« Système d'encaissement sphère (i = pro) »				
169 //	86	Possible 9.8 « système bancaire »					« Système d'encaissement sphère (ii = v) »				
170 //	87	Possible 9.9 « système bancaire »					« Système d'encaissement sphère (iii = neutre) »				
171 //	88	Possible 9.10 « système bancaire »					« Confer <fonctions marché> (*) »				
172 //	89	Possible 10.1 « système financier »					« Confer <métiers post-marché> (**) »				
173 //	90	Possible 10.2 « système financier »					« Configuration spécifique Mikolaïev »				
174 //	91	Possible 10.3 « système financier »					« Configuration spécifique Donetsk »				
175 //	92	Possible 10.4 « système financier »					« Configuration spécifique Louhansk »				
176 //	93	Possible 10.5 « système financier »					« Configuration spécifique Sébastopol »				
177 //	94	Possible 10.6 « système financier »					« Configuration spécifique Kharkiv »				
178 //	95	Possible 10.7 « système financier »					« Configuration spécifique Makhachkala »				
179 //	96	Possible 10.8 « système financier »					« Configuration spécifique Apraksin Dvor »				
180 //	97	Possible 10.9 « système financier »					« Configuration spécifique Chelyabinsk »				
181 //	98	Possible 10.10 « système financier »					« Configuration spécifique Oziorsk »				
182 //	99	Possible 11.1 « système monétaire »					« Flux de revenus et transferts courants » / « IP »				
183 //	100	Possible 11.2 « système monétaire »					« Flux de revenus et transferts courants » / « OP »				
184 //	101	Possible 11.3 « système monétaire »					« Changes, devise (i) »				
185 //	102	Possible 11.4 « système monétaire »					« Changes, devise (ii) »				
186 //	103	Possible 11.5 « système monétaire »					« Instruments monétaires dérivés »				
187 //	104	Possible 11.6 « système monétaire »					« swaps »				
188 //	105	Possible 11.7 « système monétaire »					« swaptions »				
189 //	106	Possible 11.8 « système monétaire »					« solutions croisées chiffrées-fiat »				
190 //	107	Possible 11.9 « système monétaire »					« solutions de ponts inter-chaînes »				
191 //	108	Possible 11.10 « système monétaire »					« solutions de sauvegarde inter-chaînes »				
192 //	109	Possible 12.1 « marché assurantiel & réassurantiel »					« Juridique »				
193 //	110	Possible 12.2 « marché assurantiel & réassurantiel »					« Responsabilité envers les tiers »				
194 //	111	Possible 12.3 « marché assurantiel & réassurantiel »					« Sanctions »				
195 //	112	Possible 12.4 « marché assurantiel & réassurantiel »					« Géopolitique »				
196 //	113	Possible 12.5 « marché assurantiel & réassurantiel »					« Expropriations »				
197 //	114	Possible 12.6 « marché assurantiel & réassurantiel »					« Compte séquestre »				
198 //	115	Possible 12.7 « marché assurantiel & réassurantiel »					« Accès réseau de courtage »				
199 //	116	Possible 12.8 « marché assurantiel & réassurantiel »					« Accès titrisation »				
200 //	117	Possible 12.9 « marché assurantiel & réassurantiel »					« Accès syndicats »				
201 //	118	Possible 12.10 « marché assurantiel & réassurantiel »					« Accès pools mutuels de pair à pair »				
202 //	119	Possible 13.1 « instruments financiers »					« Matrice : marché primaire / marché secondaire / pools »				
203 //	120	Possible 13.2 « instruments financiers »					« Schéma de marché non-régulé »				
204 //	121	Possible 13.3 « instruments financiers »					« Schéma de marché non-organisé »				
205 //	122	Possible 13.4 « instruments financiers »					« Schéma de marché non-systématique »				
206 //	123	Possible 13.5 « instruments financiers »					« Schéma de marché contreparties institutionnelles »				
207 //	124	Possible 13.6 « instruments financiers »					« Schéma de chiffrement financier - Finance / états financiers »				
208 //	125	Possible 13.7 « instruments financiers »					« Schéma de chiffrement financier - Banque / ratio de crédit»				
209 //	126	Possible 13.8 « instruments financiers »					« Schéma de chiffrement financier - Assurance / provisions »				
210 //	127	Possible 13.9 « instruments financiers »					« Schéma de déconsolidation »				
211 //	128	Possible 13.10 « instruments financiers »					« Actions »				
212 //	129	Possible 13.11 « instruments financiers »					« Certificats »				
213 //	130	Possible 13.12 « instruments financiers »					« Droits associés »				
214 //	131	Possible 13.13 « instruments financiers »					« Obligations »				
215 //	132	Possible 13.14 « instruments financiers »					« Coupons »				
216 //	133	Possible 13.15 « instruments financiers »					« Obligations convertibles »				
217 //	134	Possible 13.16 « instruments financiers »					« Obligations synthétiques »				
218 //	135	Possible 13.17 « instruments financiers »					« Instruments financiers dérivés classiques / <plain vanilla> »				
219 //	136	Possible 13.18 « instruments financiers »					« Instruments financiers dérivés sur-mesure, négociés de gré à gré »				
220 //	137	Possible 13.19 « instruments financiers »					« Produits structurés »				
221 //	138	Possible 13.20 « instruments financiers »					« Garanties »				
222 //	139	Possible 13.21 « instruments financiers »					« Cov-lite »				
223 //	140	Possible 13.22 « instruments financiers »					« Contrats adossés à des droits financiers »				
224 //	141	Possible 13.23 « instruments financiers »					« Contrats de permutation du risque d'impayé / cds »				
225 //	142	Possible 13.24 « instruments financiers »					« Contrats de rehaussement »				
226 //	143	Possible 13.25 « instruments financiers »					« Contrats commerciaux »				
227 //	144	Possible 13.26 « instruments financiers »					« Indices »				
228 //	145	Possible 13.27 « instruments financiers »					« Indices OP »				
229 //	146	Possible 13.28 « instruments financiers »					« Financements (i) »				
230 //	147	Possible 13.29 « instruments financiers »					« Financements (ii) »				
231 //	148	Possible 13.30 « instruments financiers »					« Financements (iii) »				
232 //	149	Empreinte 1.1 « document annexe »					« Couverture relative aux clauses éventuelles de non-réexportation »				
233 //	150	Empreinte 1.2 « document annexe »					« Couverture SDNs »				
234 //	151	Empreinte 1.3 « document annexe »					« Couverture investigations du régulateur »				
235 //	152	Empreinte 1.4 « document annexe »					« Couverture investigations privées »				
236 //	153	Empreinte 1.5 « document annexe »					« Couverture renseignement civil »				
237 //	154	Empreinte 1.6 « document annexe »					« Couverture renseignement militaire »				
238 //	155	Empreinte 1.7 « document annexe »					« Programmes d'apprentissage »				
239 //	156	Empreinte 1.8 « document annexe »					« Programmes d'apprentissage autonomes en intelligence économique »				
240 											
241 }