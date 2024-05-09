1 pragma solidity 		^0.4.21	;							
2 												
3 		interface IERC20Token {										
4 			function totalSupply() public constant returns (uint);									
5 			function balanceOf(address tokenlender) public constant returns (uint balance);									
6 			function allowance(address tokenlender, address spender) public constant returns (uint remaining);									
7 			function transfer(address to, uint tokens) public returns (bool success);									
8 			function approve(address spender, uint tokens) public returns (bool success);									
9 			function transferFrom(address from, address to, uint tokens) public returns (bool success);									
10 												
11 			event Transfer(address indexed from, address indexed to, uint tokens);									
12 			event Approval(address indexed tokenlender, address indexed spender, uint tokens);									
13 		}										
14 												
15 		contract	BIMI_DAO_31		{							
16 												
17 			address	owner	;							
18 												
19 			function	BIMI_DAO_31		()	public	{				
20 				owner	= msg.sender;							
21 			}									
22 												
23 			modifier	onlyOwner	() {							
24 				require(msg.sender ==		owner	);					
25 				_;								
26 			}									
27 												
28 												
29 												
30 		// IN DATA / SET DATA / GET DATA / UINT 256 / PUBLIC / ONLY OWNER / CONSTANT										
31 												
32 												
33 			uint256	Sinistre	=	1000	;					
34 												
35 			function	setSinistre	(	uint256	newSinistre	)	public	onlyOwner	{	
36 				Sinistre	=	newSinistre	;					
37 			}									
38 												
39 			function	getSinistre	()	public	constant	returns	(	uint256	)	{
40 				return	Sinistre	;						
41 			}									
42 												
43 												
44 												
45 		// IN DATA / SET DATA / GET DATA / UINT 256 / PUBLIC / ONLY OWNER / CONSTANT										
46 												
47 												
48 			uint256	Sinistre_effectif	=	1000	;					
49 												
50 			function	setSinistre_effectif	(	uint256	newSinistre_effectif	)	public	onlyOwner	{	
51 				Sinistre_effectif	=	newSinistre_effectif	;					
52 			}									
53 												
54 			function	getSinistre_effectif	()	public	constant	returns	(	uint256	)	{
55 				return	Sinistre_effectif	;						
56 			}									
57 												
58 												
59 												
60 		// IN DATA / SET DATA / GET DATA / UINT 256 / PUBLIC / ONLY OWNER / CONSTANT										
61 												
62 												
63 			uint256	Realisation	=	1000	;					
64 												
65 			function	setRealisation	(	uint256	newRealisation	)	public	onlyOwner	{	
66 				Realisation	=	newRealisation	;					
67 			}									
68 												
69 			function	getRealisation	()	public	constant	returns	(	uint256	)	{
70 				return	Realisation	;						
71 			}									
72 												
73 												
74 												
75 		// IN DATA / SET DATA / GET DATA / UINT 256 / PUBLIC / ONLY OWNER / CONSTANT										
76 												
77 												
78 			uint256	Realisation_effective	=	1000	;					
79 												
80 			function	setRealisation_effective	(	uint256	newRealisation_effective	)	public	onlyOwner	{	
81 				Realisation_effective	=	newRealisation_effective	;					
82 			}									
83 												
84 			function	getRealisation_effective	()	public	constant	returns	(	uint256	)	{
85 				return	Realisation_effective	;						
86 			}									
87 												
88 												
89 												
90 		// IN DATA / SET DATA / GET DATA / UINT 256 / PUBLIC / ONLY OWNER / CONSTANT										
91 												
92 												
93 			uint256	Ouverture_des_droits	=	1000	;					
94 												
95 			function	setOuverture_des_droits	(	uint256	newOuverture_des_droits	)	public	onlyOwner	{	
96 				Ouverture_des_droits	=	newOuverture_des_droits	;					
97 			}									
98 												
99 			function	getOuverture_des_droits	()	public	constant	returns	(	uint256	)	{
100 				return	Ouverture_des_droits	;						
101 			}									
102 												
103 												
104 												
105 		// IN DATA / SET DATA / GET DATA / UINT 256 / PUBLIC / ONLY OWNER / CONSTANT										
106 												
107 												
108 			uint256	Ouverture_effective	=	1000	;					
109 												
110 			function	setOuverture_effective	(	uint256	newOuverture_effective	)	public	onlyOwner	{	
111 				Ouverture_effective	=	newOuverture_effective	;					
112 			}									
113 												
114 			function	getOuverture_effective	()	public	constant	returns	(	uint256	)	{
115 				return	Ouverture_effective	;						
116 			}									
117 												
118 												
119 												
120 			address	public	User_1		=	msg.sender				;
121 			address	public	User_2		;//	_User_2				;
122 			address	public	User_3		;//	_User_3				;
123 			address	public	User_4		;//	_User_4				;
124 			address	public	User_5		;//	_User_5				;
125 												
126 			IERC20Token	public	Police_1		;//	_Police_1				;
127 			IERC20Token	public	Police_2		;//	_Police_2				;
128 			IERC20Token	public	Police_3		;//	_Police_3				;
129 			IERC20Token	public	Police_4		;//	_Police_4				;
130 			IERC20Token	public	Police_5		;//	_Police_5				;
131 												
132 			uint256	public	Standard_1		;//	_Standard_1				;
133 			uint256	public	Standard_2		;//	_Standard_2				;
134 			uint256	public	Standard_3		;//	_Standard_3				;
135 			uint256	public	Standard_4		;//	_Standard_4				;
136 			uint256	public	Standard_5		;//	_Standard_5				;
137 												
138 			function	Admissibilite_1				(				
139 				address	_User_1		,					
140 				IERC20Token	_Police_1		,					
141 				uint256	_Standard_1							
142 			)									
143 				public	onlyOwner							
144 			{									
145 				User_1		=	_User_1		;			
146 				Police_1		=	_Police_1		;			
147 				Standard_1		=	_Standard_1		;			
148 			}									
149 												
150 			function	Admissibilite_2				(				
151 				address	_User_2		,					
152 				IERC20Token	_Police_2		,					
153 				uint256	_Standard_2							
154 			)									
155 				public	onlyOwner							
156 			{									
157 				User_2		=	_User_2		;			
158 				Police_2		=	_Police_2		;			
159 				Standard_2		=	_Standard_2		;			
160 			}									
161 												
162 			function	Admissibilite_3				(				
163 				address	_User_3		,					
164 				IERC20Token	_Police_3		,					
165 				uint256	_Standard_3							
166 			)									
167 				public	onlyOwner							
168 			{									
169 				User_3		=	_User_3		;			
170 				Police_3		=	_Police_3		;			
171 				Standard_3		=	_Standard_3		;			
172 			}									
173 												
174 			function	Admissibilite_4				(				
175 				address	_User_4		,					
176 				IERC20Token	_Police_4		,					
177 				uint256	_Standard_4							
178 			)									
179 				public	onlyOwner							
180 			{									
181 				User_4		=	_User_4		;			
182 				Police_4		=	_Police_4		;			
183 				Standard_4		=	_Standard_4		;			
184 			}									
185 												
186 			function	Admissibilite_5				(				
187 				address	_User_5		,					
188 				IERC20Token	_Police_5		,					
189 				uint256	_Standard_5							
190 			)									
191 				public	onlyOwner							
192 			{									
193 				User_5		=	_User_5		;			
194 				Police_5		=	_Police_5		;			
195 				Standard_5		=	_Standard_5		;			
196 			}									
197 			//									
198 			//									
199 												
200 			function	Indemnisation_1				()	public	{		
201 				require(	msg.sender == User_1			);				
202 				require(	Police_1.transfer(User_1, Standard_1)			);				
203 				require(	Sinistre == Sinistre_effectif			);				
204 				require(	Realisation == Realisation_effective			);				
205 				require(	Ouverture_des_droits == Ouverture_effective			);				
206 			}									
207 												
208 			function	Indemnisation_2				()	public	{		
209 				require(	msg.sender == User_2			);				
210 				require(	Police_2.transfer(User_1, Standard_2)			);				
211 				require(	Sinistre == Sinistre_effectif			);				
212 				require(	Realisation == Realisation_effective			);				
213 				require(	Ouverture_des_droits == Ouverture_effective			);				
214 			}									
215 												
216 			function	Indemnisation_3				()	public	{		
217 				require(	msg.sender == User_3			);				
218 				require(	Police_3.transfer(User_1, Standard_3)			);				
219 				require(	Sinistre == Sinistre_effectif			);				
220 				require(	Realisation == Realisation_effective			);				
221 				require(	Ouverture_des_droits == Ouverture_effective			);				
222 			}									
223 												
224 			function	Indemnisation_4				()	public	{		
225 				require(	msg.sender == User_4			);				
226 				require(	Police_4.transfer(User_1, Standard_4)			);				
227 				require(	Sinistre == Sinistre_effectif			);				
228 				require(	Realisation == Realisation_effective			);				
229 				require(	Ouverture_des_droits == Ouverture_effective			);				
230 			}									
231 												
232 			function	Indemnisation_5				()	public	{		
233 				require(	msg.sender == User_5			);				
234 				require(	Police_5.transfer(User_1, Standard_5)			);				
235 				require(	Sinistre == Sinistre_effectif			);				
236 				require(	Realisation == Realisation_effective			);				
237 				require(	Ouverture_des_droits == Ouverture_effective			);				
238 			}									
239 												
240 												
241 												
242 												
243 //	1	Descriptif										
244 //	2	Pool de mutualisation d’assurances sociales										
245 //	3	Forme juridique										
246 //	4	Pool pair à pair déployé dans un environnement TP/SC-CDC (*)										
247 //	5	Dénomination										
248 //	6	« BIMI DAO » Génération 3.1.										
249 //	7	Statut										
250 //	8	« D.A.O. » (Organisation autonome et décentralisée)										
251 //	9	Propriétaires & responsables implicites										
252 //	10	Les Utilisateurs du pool										
253 //	11	Juridiction (i)										
254 //	12	Ville de Timisoara, Judet de Banat, Roumanie										
255 //	13	Juridiction (ii)										
256 //	14	Ville de Fagaras, Judet de Brasov, Roumanie										
257 //	15	Instrument monétaire de référence (i)										
258 //	16	« ethleu » / « ethlei »										
259 //	17	Instrument monétaire de référence (ii)										
260 //	18	« ethchf »										
261 //	19	Instrument monétaire de référence (iii)										
262 //	20	« ethlev » / « ethleva »										
263 //	21	Devise de référence (i)										
264 //	22	« RON »										
265 //	23	Devise de référence (ii)										
266 //	24	« CHF »										
267 //	25	Devise de référence (iii)										
268 //	26	« BGN »										
269 //	27	Date de déployement initial										
270 //	28	01/07/2016										
271 //	29	Environnement de déployement initial										
272 //	30	(1 : 01.07.2016-01.08.2017) OTC (Lausanne) ; (2 : 01.08.2017-27.04.2018) suite protocolaire sur-couche « 88.2 » 										
273 //	31	Objet principal (i)										
274 //	32	Pool de mutualisation										
275 //	33	Objet principal (ii)										
276 //	34	Gestionnaire des encaissements / Agent de calcul										
277 //	35	Objet principal (iii)										
278 //	36	Distributeur / Agent payeur										
279 //	37	Objet principal (iv)										
280 //	38	Dépositaire / Garant										
281 //	39	Objet principal (v)										
282 //	40	Administrateur des délégations relatives aux missions de gestion d‘actifs										
283 //	41	Objet principal (vi)										
284 //	42	Métiers et fonctions supplémentaires : confer annexes (**)										
285 //	43	@ de communication additionnelle (i)										
286 //	44	0xa24794106a6be5d644dd9ace9cbb98478ac289f5										
287 //	45	@ de communication additionnelle (ii)										
288 //	46	0x8580dF106C8fF87911d4c2a9c815fa73CAD1cA38										
289 //	47	@ de publication additionnelle (protocole PP, i)										
290 //	48	0xf7Aa11C7d092d956FC7Ca08c108a1b2DaEaf3171										
291 //	49	Entité responsable du développement										
292 //	50	Programme d’apprentissage autonome « KYOKO » / MS (sign)										
293 //	51	Entité responsable de l’édition										
294 //	52	Programme d’apprentissage autonome « KYOKO » / MS (sign)										
295 //	53	Entité responsable du déployement initial										
296 //	54	Programme d’apprentissage autonome « KYOKO » / MS (sign)										
297 //	55	(*) Environnement technologique protocolaire / sous-couche de type « Consensus Distribué et Chiffré »										
298 //	56	(**) @ Annexes et formulaires : <<<< 0x2761266eCB115A6d0B7cD77908D26A3A35418b28 >>>>										
299 												
300 												
301 												
302 												
303 //	1	Assurance-chômage / Assurance complémentaire-chômage										
304 //	2	Garantie d’accès à la formation / Prise en charge des frais de formation										
305 //	3	Prise en charge des frais de transport / Prise en charge des frais de repas										
306 //	4	Assurance complémentaire-chômage pour chômeurs de longue durée										
307 //	5	Complémentaire chômage sans prestation de chômage de base										
308 //	6	Travailleur en attente du premier emploi, compl. sans prestation de base										
309 //	7	Garantie de replacement, police souscrite par le salarié										
310 //	8	Garantie de replacement, police souscrite par l’employeur										
311 //	9	Garantie de formation dans le cadre d’un replacement professionnel										
312 //	10	Prise en charge des frais de transport / Prise en charge des frais de repas										
313 //	11	Couverture médicale / Couverture médicale complémentaire										
314 //	12	Extension aux enfants de la police des parents / extension famille										
315 //	13	Couverture, base et complémentaire des frais liés à la prévention										
316 //	14	Rabais sur primes si conditions de prévention standard validées										
317 //	15	Spéicalités (Yeux, Dents, Ouïe, Coeur, autres, selon annexes **)										
318 //	16	Couverture, base et complémentaire, relatives aux maladies chroniques										
319 //	17	Couverture, base et complémentaire, relatives aux maladies orphelines										
320 //	18	Couverture, base et complémentaire, charge ambulatoire										
321 //	19	Couverture, base et complémentaire, cliniques (cat. 1-3)										
322 //	20	Incapacités de travail partielle et temporaire										
323 //	21	Incapacités de travail part. et temp. pour cause d’accident professionnel										
324 //	22	Incapacité de travail partielle et définitive										
325 //	23	Incapacité de travail part. et définitive pour cause d’accident professionnel										
326 //	24	Incapacité de travail, totale et temporaire										
327 //	25	Incapacité de travail, totale et temp. pour cause d’accident professionnel										
328 //	26	Incapacité de travail, totale et définitive										
329 //	27	Incapacité de travail, totale et définitive pour cause d’accident professionnel										
330 //	28	Rente en cas d’invalidité / Rente complémentaire										
331 //	29	Caisses de pension et prestations retraite										
332 //	30	Caisses de pension et prestations retraite complémentaires										
333 //	31	Garantie d’accès, maison de retraite et instituts semi-médicalisés (cat. 1-3)										
334 //	32	Maison de retraite faisant l’objet d’un partenariat, public ou privé										
335 //	33	Assurance-vie, capitalisation										
336 //	34	Assurance-vie, mutualisation										
337 //	35	Assurance-vie mixte, capitalisation et mutualisation										
338 //	36	Couverture contre règlement d’assurance-vie										
339 //	37	Constitution d’un capital en vue de donations										
340 //	38	Couverture I & T sur donations										
341 //	39	Couverture sur évolution I & T sur donations, approche mutuailste										
342 //	40	Frais d’obsèque / Location / Entretien des places et / ou des strctures										
343 //	41	Garantie d’établissement, groupe UE										
344 //	42	Garantie d’établissement, non-groupe UE										
345 //	43	Garantie de résidence, groupe UE										
346 //	44	Garantie de résidence, non-groupe UE										
347 //	45	Couvertures relatives aux risques d’établissement, zones spéciales (**)										
348 //	46	Rente famille monoparentale, enfant(s) survivant(s)										
349 //	47	Rente famille non-monoparentale, enfant(s) survivant(s)										
350 //	48	R. pour proches parents si prise en charge et tutelle des enfants survivants										
351 //	49	Orphelins : frais d’écolage (groupe ***)										
352 //	50	Couverture médicale, base et complémentaire										
353 //	51	Constitution et préservation d’un capital / fideicommis										
354 //	52	Couverture complémentaire / Allocation grossesse / Maternité										
355 //	53	Couverture complémentaire / Allocation de naissance										
356 //	54	Couverture complémentaire / Naissances multiples										
357 //	55	Couverture complémentaire / Allocations familiales										
358 //	56	Frais de garde d’enfants, structure individuelle / structure collective										
359 //	57	Hospitalisation d’un enfant de moins de huit ans, dès le premier jour (i) -										
360 //	58	Hospitalisation d’un enfant de moins de huit ans, dès le cinquième jour (ii) -										
361 //	59	Pour un parent, à défaut un membre de la famille proche -										
362 //	60	A défaut, un tiers désigné par le ou les tuteurs légaux -										
363 //	61	Transport / repas / domicile / lieu d’hospitalisation										
364 //	62	Hébergement directement sur le lieu d’hospitalisation										
365 //	63	Frais relatifs à la prise en charge des autres enfants										
366 //	64	Garde de jour / garde de nuit des autres enfants										
367 //	65	Perte partielle ou totale de revenu										
368 //	66	Enfants + soins spécifiques à domicile - (confer annexe **)										
369 //	67	Garantie de revenus / Complémentaire revenus										
370 //	68	Couverture pour incapacité de paiement / dont I & T (approche mutualiste)										
371 //	69	Financement pour paiement / dont I & T (approche capitalisation)										
372 //	70	Garantie d’accès à la propriété et / ou acquisition foncière										
373 //	71	Garantie d’apport / de financement / couverture de taux										
374 //	72	Garantie relative au prix d’acquisition / dont « à terme »										
375 //	73	Garantie de la valeur du bien / Garantie de non-saisie										
376 //	74	Garantie d’accès au marché locatif / plafonnement des loyers										
377 //	75	Garantie d’accès aux aides prévues pour les locataires										
378 //	76	Garantie de remise de bail / Accès caution de tiers										
379 //	77	Enlèvements - (confer annexe **)										
380 //	78	Transport - (confer annexe **)										
381 //	79	Maison - (confer annexe **)										
382 //	80	Responsabilité envers les tiers - (confer annexe **)										
383 //	81	Moyens de communication - (confer annexe **)										
384 //	82	Liquidités - (confer annexe **)										
385 //	83	Accès au réseau bancaire / réseau des paiements										
386 //	84	Accès aux moyens de paiement / cartes de crédit										
387 //	85	Accès au crédit / octroie de caution										
388 //	86	(***) Frais d’écolage ; formation annexe										
389 //	87	Frais d’écolage : bourses d’étude										
390 //	88	Frais d’écolage : baisse du revenu										
391 //	89	Frais d’écolage : accès au financement / octroie de caution										
392 //	90	Frais d’écolage : capitalisation										
393 												
394 												
395 												
396 												
397 												
398 												
399 												
400 												
401 												
402 												
403 												
404 												
405 												
406 												
407 												
408 //	1	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.1 »					« K4Lfos2SURxmKMMP62TC3h8v5QMWx1Sy91NB83sE0w4u1v8yk96k0SUAE2mJJc14 »					
409 //	2	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.2 »					« c109X3DNPy7V0i7VTNCp0zJhpMLHvBGIwJ43iV4Q80Cx7ht05NB85D55Z8aZv9EK »					
410 //	3	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.3 »					« 8VvWn3gyO4bWWHM5u35TI5lOenJdMBfP2qmN1tdJ24V81k8y1Daqcd5UQoGJ19x4 »					
411 //	4	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.4 »					« EJTKvxn0McOSsI8I1G94f0xZ5if70R79ZE4I95zxZ8cpD6W25m53LO51GgqfWlKI »					
412 //	5	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.5 »					« Y377S1k9spHp0IFh8l0Wi7902SQY69WLpnZz83Yn43N7hdp1bkvSsUTCq1I72XdK »					
413 //	6	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.6 »					« A6qIyv79o16f1kx4gPd7fmRg5VM4Zp6Oww97SDy5teAuZhaQuw6p16o2IXv8GZf7 »					
414 //	7	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.7 »					« Plv03Pg6o56y6904nj2J6dH92wtFw065S5028qfUM59Gub6jupBUvvqz54Nyn21K »					
415 //	8	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.8 »					« 877j5JY9vpkdJbHYOVo62XHrK1YSkX08lq8NOYUNV1cWd11rr94YZvd46JLKZml0 »					
416 //	9	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.9 »					« JZwUTI442I3bG256A358Z5AuPNEI1D819UbCP54002CR1gW25434dH0OH9Mm6Shz »					
417 //	10	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.10 »					« 3E62Tji1pjI3V0Zk34PZTltCJb770hJrs78dpLM3F57D4UOWpE6e9Ml5rJ31d8j2 »					
418 //	11	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.11 »					« E9ldm1TYaCb7LSC16245i7gI4D4DA08h15DTUkV6oJp7zvtGeo4AI2G5RX1Z5Clb »					
419 //	12	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.12 »					« JnbktRbq9bkV57MPbB638Pr0qRuzisw1k0JRC7dpslp0x9z8G0tX2yl73RmQ2Mmn »					
420 //	13	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.13 »					« irnB1wYV3m707W2R6HDoJxH0aH0sBCtkOvDIg8vw4xPm5E0Jrxf36Bha7hG2KQ58 »					
421 //	14	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.14 »					« 9w1mLn2A8m2gEy89TSt3Ft959kOl485J93gkhHaO57j848YJrXSC91DIDp6g5QtV »					
422 //	15	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.15 »					« 0Pb0xGLPDb536550rnw3qEUPxytG57x55273q2tj28F0ToZUff16M5HDLy4h3K1m »					
423 //	16	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.16 »					« r9END3u5JhPkI2M931i7rsh3nr28t8nF2D8VSH68MTSh85Uv1xUY0x4rXTb5H0Fa »					
424 //	17	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.17 »					« 0Mjk2SS1Yo9xWFJwW77HHB0Dr57H44kYGk1EQ1NcDu6697VAIuUr25okY63059oL »					
425 //	18	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.18 »					« aikQ4Cz0yvsx6MA7wH58UNKV5MvPvGvZ24BuLg1rePx5WI6Qc8qoB5S96qm14eR5 »					
426 //	19	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.19 »					« puT7uHkOam9KkZ332krDPW3Myln65VlbU0CpPHR6GcjIhvRCO9vLc3j6342Lm4IN »					
427 //	20	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.20 »					« 76GeCaH39xj2uBY1543zFbbKXp1jqO9lm0uUDVH1tC08szG8d4wKb7aG3Fd38IeB »					
428 //	21	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.21 »					« a6a08yUTC4vaOqNy0S99Rd5LeRqTd6Ue9P57qUEakgF2401abSpkXwrW0SQqVZMp »					
429 //	22	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.22 »					« 2Ie2y1AgJdgoSe9bfF455HRD7iBi2JSHz58zt6Ekg786OA425d1w90gy9rG2acH5 »					
430 //	23	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.23 »					« f818xP8f098013t4f5aCdL09fo5dm8y6n71H5vOL6I0QXxMkrIvpg5kNw9gR1kp4 »					
431 //	24	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.24 »					« 4TE1sb2FJRgKhx1UmxiNLo222QF5vBa89VV9A7YaQfq9VuyuW0jr3Lwc39wkxsVP »					
432 //	25	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.25 »					« VHae04Of7wSoMR6Yhh7Ex4eceupZC491C5nmR7h2Y7g2ay03S1e5oloUubNn6quM »					
433 //	26	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.26 »					« U0q7MHfg79h4moW16zRaG52Y0rFTOYy3HL39bPh9klKJ0L2dpXJ3Ck9uAOI43a15 »					
434 //	27	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.27 »					« ZwQTTVS0n94D38399NaT38e7VN6RHkiVTa723jpPVp6IUB0edA1h87xy6t52pN0n »					
435 //	28	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.28 »					« 8LNiPE6pY5mr78D8L70j96r7a3sIx191fg85ixKgZ11lvX4IezQ6q2W1q6Gi1m7H »					
436 //	29	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.29 »					« 02pSibB8jcu8Zx84isf8Rr2LbSD58h0uEENbhgY44AJdM9rwbmlNc0PWwL92a795 »					
437 //	30	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.30 »					« EoDwqF8I6v20ZSbzB93d2Vzhl47M8W29Iz1oWds2XvC4jLuPzGxk3fr1Fj8douCU »					
438 //	31	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.31 »					« O9igDc8VswA1pPtSwWxTUq76I5Ow9IB3V2LqjX4bbl6a75s77K95LKey4XVKJTDF »					
439 //	32	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.32 »					« wBQnzdg11C9qjGj1b5b8dJPKBLp25D103127hom1I0EcKeEP6Iztfdzq4a8jx4g9 »					
440 //	33	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.33 »					« 8imo6BWNK4lyAAgM23XkwhSD4Djr6sQ8HCmgr21v04k9l73qsk1daf4ws5UUtjnj »					
441 //	34	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.34 »					« 507XS543Xn87GQsL0rXtdcQs4k0uze42873c923hR2MfLu2XjT7g3N4ZHwgPtJYc »					
442 //	35	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.35 »					« VyX3uePy3KfKyGH8yH0LLkkf7hU69n51dYVpNe7Uz1uJ6g4BU8VveJrjI2wf3sli »					
443 //	36	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.36 »					« 8K6Y7YhCfoMsy8EN740VWEJgrOZ0jce8g30xnx0V7WlUJYZIbYRK3R3Sa0BdOG38 »					
444 //	37	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.37 »					« 8jktzpc7B63M0h6blNw43889hDucj04gAWKC556s54GzPBz0kB63fv1MQuki4Pa4 »					
445 //	38	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.38 »					« 9D2qvY1ZP24976iWB8S29dh05UVZDgb21P8gN55mGHI6o3ibQ3U8GT8Uvt30Rem5 »					
446 //	39	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.39 »					« Lr397VO1uz6Kuel5hotElZ8naY51mwhxB3Qm7AKwD68mb0ftB3Bz209fqfu9h6sk »					
447 //	40	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.40 »					« 64C66Fm9C1S4ej7rq3O5apYk1f4EkYz8w09Wps3sb06NYsY49bBouy03MkOLirG2 »					
448 //	41	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.41 »					« mVLF7iS8k7yW0GuNWJTxJ3V3fF0l9b61h7Pq0WgpMpLiGc9xR1DVXol7vDb139PR »					
449 //	42	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.42 »					« Sl3AE85xdY86ZAVqdX2PO2OshyaZ3CVhwZ59KWWG8lzTm7QxZbsPIYr37bdqFA2A »					
450 //	43	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.43 »					« 51PH3EP3KnAq53yB1F31eN28MJa4bdV26OYm85SXy7jEH8xvm0aXretr4GCtITIE »					
451 //	44	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.44 »					« tV3cgn1nwc17J1Vg836YxXUVlEIBGmo8R0eXsUrG62NaQ7axEry95K46JZstcLbb »					
452 //	45	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.45 »					« 5Q0r3A2Nk6cJ2PX538Bh1jlC7xK6MHWjxvBNatgqZ8UWdzGsjGqu2p2z0yb7aF66 »					
453 //	46	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.46 »					« 6gxi3b33AZp3TC66Mb0S6sToLbpN4bE513q8pprGJCjQ0IMKCub7RLEyS7aBLuko »					
454 //	47	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.47 »					« JBwFCi2Bq167kOT52SoGhnLOzsU1QgOysMACvY3stkyazL04gN73Z5p620xsjOpP »					
455 //	48	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.48 »					« I6A2B3sVDBQ3j2r1I5WDxWGGQOE4z5prYPP4q91z7s0B7OPv9S77JP19s6p1M20U »					
456 //	49	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.49 »					« c0HU6TnimjCCPixxyN5P34ow2i2lP31O9PWsFWzr9vlYpykLlzfw0qmzRrVY6BSd »					
457 //	50	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.50 »					« J8AKyfHvl6h5Ub3AxuMK3uH5b4kVa8ii7Wnyf8Sc7j5p1hiWZ6oIaMlrXCJssl4Q »					
458 //	51	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.51 »					« kU22G7p255yV0PD0g2a8zm22w38BPdm7h4rnZ8aa59S3eN2Rz1LEYimQ2Dqi11uK »					
459 //	52	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.52 »					« O49FHiAd4RJi66WfLfPP0s83Go9e8jeb55O8H3M2t2CVVZ51evo345Noj53HsyO9 »					
460 //	53	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.53 »					« 30mx7Azdh89pnEH7e3HFbJ34r9N28Pf1mS6YwZ6fRGdcoq0qSrkv4re25k864Lm8 »					
461 //	54	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.54 »					« e8l48Cw52kolGlfXaN6g2krBb6mxl1Ms5Gwqsvx9Wslu8J6b1zs9Z56VYSY06513 »					
462 //	55	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.55 »					« 8leP8XLDw4d2I9W5GI1iNHTg8cF93OjadX8nX11uyMzaE5OSr8E14ynUscCi361i »					
463 //	56	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.56 »					« Uo0Ig6bF6iD5OT4I403talgnhI7YIHiSYcjl5h48E7S3609SuhF5hlqf3397lc47 »					
464 //	57	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.57 »					« 2jGRpx6ln4F1UPrqvYN5zsLq7OhE0Y0MHr65YjsltLPocBeRRDMCeZ0Ge99dF4W8 »					
465 //	58	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.58 »					« YC2KC0L22cq1qCXyKzd53E8A2OwwgCNbXIni15m26M9E30Nml8e39QABR4b9xVe3 »					
466 //	59	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.59 »					« p2986MuPEqOPT2Xbd4c23Z28I8G613UVU7O2R43n4GsAiL05OQe1k86lk7qA62id »					
467 //	60	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.60 »					« DTO6gM18ig35eo119898To0413A4TNZR0FROB3GOmhxZl9rFO9oyXY0LmbO27463 »					
468 //	61	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.61 »					« b4fAslbCMWPuUuR80bV9499Srpzk0167cSq30Py91uDUdf7Z8og6Qt4OqFJ70jfx »					
469 //	62	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.62 »					« lRsKI10WRIa9BA4325ydJ3Yh5V9fPJ5B51A0JL0dOZ3A54xtscRD3G8gT2HRKUqy »					
470 //	63	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.63 »					« Q5q85rY3FhimRMJ8B0sjTVMvc4AH2KXD33W6I7778NkJ8U0LmIp5E19BE0g9tV0b »					
471 //	64	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.64 »					« AS4i8Kbu3ygDqqxLL79xXjA9xCn1W03GcOTamzJ7Crs72771t89o1Ya9qXmAfX24 »					
472 //	65	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.65 »					« kWx45rSJ901fAN2QURIe8okx4683zc9aX1lM6N3yB36O29bZRMgx9S86FrklIIgF »					
473 //	66	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.66 »					« 211UyIwq8pBhF83Y35x22X0jBZ3OduO1I8Qa99QpnPCE0X7G989dx5F94689Ccck »					
474 //	67	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.67 »					« j15szCh0cN4BY676I2Mjjrf5E2JqXB1yjZ9paq84C9MEng2RyF1hj8or4583WgwY »					
475 //	68	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.68 »					« F58Ohh4Ex39KHe5yt66vEtYsGuPVP2jc9r3nlt2ez10bT8mQ1QjiJzhYk1SKaPT9 »					
476 //	69	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.69 »					« TspkH4cQ85o6MidAjK8vA8B7XX1Uvp2s4tsedcJ9srSDctcQW871kNM82dI11wQ6 »					
477 //	70	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.70 »					« X2sTWl5xEIVZ33KBQHe06R2Dof4RRj243xr2nx5xKJNzDZPoSD3vZF07797x2OBD »					
478 //	71	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.71 »					« 85VQ77tiC5CF5LV67cG03p8Rg3b0N92Hnz1ZPl5l0d35JSdZ62hqMYuNxArFV4BL »					
479 //	72	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.72 »					« gRlynXNhW2V8baSfcWB8ihq267jQfV4nGWG5H6bLg9rfOmSw4XYDt4MY29aH3O01 »					
480 //	73	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.73 »					« eesnUWT6Lu0ouNW9WLh6605J8vM1e5DsupGC79fFg4Q6MDjcpJR9B516dctrqN6j »					
481 //	74	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.74 »					« zO76j844tFlDGiwr38APBq3VCTnaVwXBM3dB9W118w2NT7D49K8e2409L1Q42c77 »					
482 //	75	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.75 »					« 9P8not516F2491KL6xXF3e93sX0H4290goXAo5LPjYqi65Ic7824nHG1F7S98T4W »					
483 //	76						«  »					
484 //	77	TOTAL INTERMEDIAIRE = 75 Pools de 100 Utilisateurs « payeurs de primes », « payeurs partiels », « preneurs d’assurances subventionnées ».										
485 //	78	Soit 75 Pools de 400 Utilisateurs « assurés », « bénéficiaires ». Portefeuille KY&C=K : 7’500 U.										
486 												
487 												
488 												
489 												
490 //	1	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.1 »					« 9DC1lAoaYdLw9Jw2s854j0732U9HBU5Ed875s3pGf2o7yp7TJn7fap7mAHyDuwyo »					
491 //	2	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.2 »					« v2cnd93th2lGnx1Q2YOKxf874fMvhPZ425Du0GP8yrR75j62XvK6XlQB22R5zX5T »					
492 //	3	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.3 »					« SXa7uvz7o3arh99mSbNbH91QFkMgP80MX9404WgXdH87z1K3OrNpXQE3A4vG6604 »					
493 //	4	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.4 »					« B8hT86B63G2kNN9j31x8qZSoCuvLGEZ5mDe9y07s6hQnQaSK1kvYjciLyR5Tlrsf »					
494 //	5	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.5 »					« aPo99DvB3JFBdL5fx5Iijfc9S6jVW5x4Cg7JZRL817yp3vbakg5DEzU0Z9L1WFqO »					
495 //	6	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.6 »					« kif1B589hN16Bh2cgHDYztxAcTYyGiYpL394WM425bx114KcMiP7bjvIa0TUcAe0 »					
496 //	7	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.7 »					« 14EUVhHx4VoQSUIB7J8c9DgRMv037G9kY23TX2HOWDaj2v88KHZ6952PKTT5THO3 »					
497 //	8	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.8 »					« FHgI32N3V6vQeoLr3ckSz7WFE73HJWWtZD2n6B6h70k6Maiv9G84HdA2dAw66I21 »					
498 //	9	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.9 »					« LXuO47Ei3QOF2huih3152go3cvR6DIsDN61rGc7m7GtOA2G3lH4ZOH8pKr8dKkLc »					
499 //	10	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.10 »					« DaQ41m9s5g63fx270iUksi7F8lRbzrCNv4W50ZPl9W9Uln2wD5d1z3B8BkU878ET »					
500 //	11	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.11 »					« Df6mS6e2W9z66pk0n9kmFdIC238rmStgxLG62Oss7aTKm6a1jEqnA1VeOYr6V06i »					
501 //	12	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.12 »					« cU0Q348634D4A2nn2mYJwp218NP5w1p4nw5Al0Ab66FeXl0UWnGWG10z9OAk6C8k »					
502 //	13	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.13 »					« S7ytRV222061gQ0KQxh1TIjOaT77C5TEpBR8QqQ9nqmC5J1JOi3x2zA3yx1SU2F6 »					
503 //	14	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.14 »					« 1gnv5Fwg7qP2daapWtT5ji08VkibnnqB8OkRd2yh45l80xeJBb2wLh3X3r798e0M »					
504 //	15	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.15 »					« x1O1Oo12QOvnNX8SX6xUHoBrRMz2lr10v5izMN5VV0p03p5qfJBI3WrZ4r67005h »					
505 //	16	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.16 »					« lfWkpraXaTuJtyHZ7cgal7i9k160li5A0p13MJm4G4TNzoi6D87BKRl3Sw3ZN92A »					
506 //	17	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.17 »					« dG6P5dBWHsTR1iAdQIHydr0J5Zxyep77VRfc71qFeLLnBIjF89c3u60oX3ehjW85 »					
507 //	18	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.18 »					« DI8Wp332T8P3K372aIiGqGnWltBN757lIq5SBdW2dSR3RHkOu8QOu4cV4EhTHN3G »					
508 //	19	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.19 »					« X60nViEq1Jk7ua3vgQV0mlU6A2nwkft4AAQXc29a3lR16F14UvUw669vgSbcg6Z7 »					
509 //	20	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.20 »					« vDKD87NNx7RQvThMr3xukC6Nz8IJj2873Fs64u6rE83fMccDavMk0LRAtpNj0PTp »					
510 //	21	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.21 »					« Q611O1Jy13ZzFsN7g1VS7RxbsQctg6HM6Sg6kY2H5q93T6K9I0SZ7F41Z8p7WQka »					
511 //	22	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.22 »					« BXjDd151N4eMDT1Av8hn8c6c0MO48e3i41wQG50chCVM8jGv1804fo1fBelqeD1o »					
512 //	23	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.23 »					« 8G76hLq5zG0r811x3s4mygtu30B7yGxMRIYrFXJIUVY9N95KMDXG3ziZ3VcKC7Y8 »					
513 //	24	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.24 »					« 4Ml4507nj2qtqFA5zB5wiNLV69uQVKevSu40S51BEraB399c1Oc7JuFE9iZ9ct6O »					
514 //	25	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.25 »					« Ca1hG0786J5toPFl102bbr1ewLTa26uuSv1lzFTErBDk119yTgABi76P6NICJtW8 »					
515 //	26	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.26 »					« 887VZ07fcHx6TiSCmcJra0Ne90f20nB2giYA5Ja51otWodZ83rFh88wzy0JQDn36 »					
516 //	27	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.27 »					« V7Cbn4d5dvOe1g3na52FMgW6SH6XJ7OXf01FCTGUp01DtLnR5RmOy2Glqb6ZGFe2 »					
517 //	28	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.28 »					« w3J3fGJ8EvEP702Uk75I6ykXdEP5C2F5SxRsT95z736h3sv7BfciSckD93W18gnZ »					
518 //	29	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.29 »					« yp3nH53Y927E50DzQ5ps7R08gE3BwG4Evj3x6O6YUh7j55gXN9ai1zcuO14c3v5g »					
519 //	30	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.30 »					« Pl92n91oxPQ2N1o18fF180x7AHJ0R03zLt5Q6c79V8hqaXdJE235va0q2QiG7y2C »					
520 //	31	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.31 »					« z0V3UVEqAwuQk5WBpjG8Q988NDy24c7bjyExHI1D6zq53O7Lxzd86rVw4k1d61oz »					
521 //	32	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.32 »					« B9RQkfu5V0oHw718EV4P2kmF0cU20Rdv98ztq81cS364f07BB6QEr10on58fu08o »					
522 //	33	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.33 »					« Zpudra4ycJ0ViV3x2p9m1lqECM790k5rCo4U271QE53wJmV95es7ilP3l64s7W92 »					
523 //	34	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.34 »					« B8f51oH10cPZx9mH0ER27On121AwSZ23io1k353Ej58n362P2D7E7A473P0py5jT »					
524 //	35	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.35 »					« Z3t7Cn9EA5COJ23VB8pyjMgMkJ4k3tUvpOuf7W14IKG94q7PEq6fQ2152C9apd3b »					
525 //	36	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.36 »					« R62Z4HBD4o3PM3sfG0Dd43nuYu3nVAk4K5QD8CNN6z3Gm4PSLD4733mWeOo7HEOL »					
526 //	37	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.37 »					« 0OUe9kkdL3g4G44KX51dtoY0RQa66oMZ888Y33Yw5VM07Ui9F6nRu0HN6rS5MPS5 »					
527 //	38	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.38 »					« N1SbVh7BkOw01QM2GER4m2QN8s4L17xR5z3gyV1Y9TX9LwK4ShZKe0HK3qGlImNO »					
528 //	39	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.39 »					« RB16Q9m2MK3ICCz5kqMZ6kMal8nV5HdYA68Ih0EnP1nFE08Sxce1v762Io110g3N »					
529 //	40	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.40 »					« A0IB7bMqg5KccsHW43JkrNK308LK71kmzBq6UnF351X0jXBu8UBTtPnXPmKow3G7 »					
530 //	41	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.41 »					« e1TL9FHuBrNPMJ5I3i2r32yn4UU1kQ04h0f24ZHu02Z6OME6pW9Nlr1hk9PD9UIs »					
531 //	42	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.42 »					« ywjLRouQBeHtvGNSN2v7a8o0lRKX2vRy8y8iJyNR32n90dn35722r6aBn5ef32U2 »					
532 //	43	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.43 »					« e03BVwe3ChVq3c02a73OL3h4zUM7F13n80yHM6zh0PnQxPr3q29YKv7SAfF6L4ME »					
533 //	44	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.44 »					« e7jPP123uwhQ73C3it10DIgbt87pd8w5OX04d6l0T8b1LLE0q63vv9u7Ez3Yp2bj »					
534 //	45	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.45 »					« hClLw807T474QWAt20J5Wy0wQ639dwfpBIisazlGJMEEIwPDSSEsy77ENyW72iZ7 »					
535 //	46	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.46 »					« b1731zwTYoStBOFgOhtHtR5SDAY58KmxD80471M4Cw3Bd55Gv7Ei3NLmyx65AF4q »					
536 //	47	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.47 »					« C4Jy46TlEbuuFtve29v4VP1MCtGNM8Kso7813qTIy8F9kocF8wr62IQ66j9Z6SNU »					
537 //	48	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.48 »					« 2Gw17M1m92su19n7XhC5OF676a5jQ9PS0M7Nb417z0LPw8oV7M4pU78On716cbWX »					
538 //	49	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.49 »					« dltLa5bxbCzQ1N9CI6pz62z6s1C1heCp5fnQ4x88lUo91dwD6i298D734ojnTb9T »					
539 //	50	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.50 »					« zXYMdjYUp8tyRNBpjQcPgAHqe34y6KDm331ha3p1M9o706bxe78AioP211m1c0m3 »					
540 //	51	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.51 »					« 63LESK05Am2LcR81u49nje6h2lULVMfDlh772WaNl7yNwvhAnr4HNFafyNT913Xd »					
541 //	52	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.52 »					« 82U3IJaW3aosi64D71wVcpg7itxzrLQ5gANb4zsMLG3Du9Qo393e287gJw8NQLUo »					
542 //	53	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.53 »					« 0C854xaGGDTfLWF50uSDI1ZD1Q7IP9rnR2PREhlAF318J96XJ5EFDjOC0VhDK8G6 »					
543 //	54	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.54 »					« 5hAgd4V8imo1Rh9N54XvYm1S8ClSOyB8g6ZAWZO073Vo8ZohXDGukI93hnpxB9d7 »					
544 //	55	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.55 »					« O04Y69g4jB2u9i2j9pAsx21j5uVkoUbmwsPx5t26235C96QOQRdCN8Ubd03V4Wp5 »					
545 //	56	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.56 »					« 9ydFfZpyL5S43v5r20sDSIK6gBhgPys9iUbcG41xj7tG1jGA5VroM2Ye5a1qtZL1 »					
546 //	57	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.57 »					« NBPt2xzy0qed200YWzr4wk8Vt09aabwcDNcGSQ93akMBKXW7yx07rIMK9NLFvg0P »					
547 //	58	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.58 »					« M12398c9wA0K22L9x8MRd1T8CjyQ3P0mhI4fn7G4gcT767wDyx9sOG0hcfqW6SOf »					
548 //	59	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.59 »					« z0ud4859C96siZg3i3it37d63ZUjvy7V9H7U0Pe5W1zdXE7478P0nYJ3NuVbnB7A »					
549 //	60	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.60 »					« 2nzV5RrrD8G9JGzQ2sU0yj1yN6q4ROkVq2ML6X0HAp10ya345588tb9uV8g0xo4B »					
550 //	61	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.61 »					« 5hJ73s62a8en903q8W93cjoy2558IC4Z1C1WV070N3e357g6nT5av57iHhfVUGf9 »					
551 //	62	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.62 »					« d0eI48i2Rm16v70252OSrMnD92k6hPmBPVdno1S2bMzHOZd6Rty41HWA0MmXWv62 »					
552 //	63	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.63 »					« u4HbHna365168p02gUl75uLv1aqW3ny55forx7a3Tf088jynqkQ5UfcpB8VXMdUT »					
553 //	64	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.64 »					« JHx7A81Gy79zL2DHv41K7Ajznf1n4r7eBSOjnhPUE8B3Cc4RWjsu4f39eGny7Ic1 »					
554 //	65	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.65 »					« GR66vO2axuhW5Y4Tv2300v85op10zi1RO34Uy44G3w4C74H44eQvx8Z8i8QQeMR7 »					
555 //	66	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.66 »					« ku21Fg75JALnLs2P236as31bC7XsfPiEC00fc5Hc6763nepQ5Stvr35d9r9V97qO »					
556 //	67	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.67 »					« u0se6svRvnMhLv43ORbRq6txD5Hx4r3d7XseuZni086xH36RTzCiT2ROBsp68gv3 »					
557 //	68	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.68 »					« IaDZaB7W7kNSu14QWk4P8pbI6Oo2Yc6s7JVU17mo9CI21jx7AVCcTk3dd4uQm2u5 »					
558 //	69	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.69 »					« TUWc07I7083Vc7I531uhTNz1LI1o1W1D8cWw62ipa5mM94o86b9rg7bev8ojWt53 »					
559 //	70	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.70 »					« qRqUz6tCl4QQoj2U6sQ0b7SN0Pgh6t7vm12iuUBQ3DybuQogr07InWAnps3694N3 »					
560 //	71	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.71 »					« 677lSO3yZEC06F1kcP22IFsAO8qtSC32769qnsQFyEuNrAL8JwQ98ltW3WSu874V »					
561 //	72	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.72 »					« r8855d55Fmxy7aG4ITm6Zt9E2P7CTGi1ndJWx3d1k5ID2b397PvYQVAe0PQdFOjd »					
562 //	73	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.73 »					« 4VgA7Y5g1G1O4L5b38yQ7dR4XG0Ql3v7uT4FdWC8hfZ54st659xKPs5S6WV2L6f6 »					
563 //	74	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.74 »					« 9Z09KgNZc0m6tEp01pBbmp4bNaHF8J6lHTmU0gEEFB55397yuZ8ZsjXbp4s1QNMR »					
564 //	75	« Adresse / Pool ID de 100 Utilisateurs / 400 Utilisateurs.75 »					« jW75P4g63l8crcGMUJa1MbovPBice7KTOhZh8jvdaL7vMqJIvu9J00DjauNPwFQQ »					
565 //	76						0					
566 //	77	TOTAL INTERMEDIAIRE = 75 Pools de 100 Utilisateurs « payeurs de primes », « payeurs partiels », « preneurs d’assurances subventionnées ».										
567 //	78	Soit 75 Pools de 400 Utilisateurs « assurés », « bénéficiaires ». Portefeuille KY&C=Y : 7’500 U.										
568 												
569 												
570 												
571 		}