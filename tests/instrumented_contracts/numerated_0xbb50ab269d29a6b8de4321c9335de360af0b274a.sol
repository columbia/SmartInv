1 pragma solidity 		^0.4.21	;							
2 												
3 		contract	Annexe_SO_DIVA_SAS		{							
4 												
5 			address	owner	;							
6 												
7 			function	Annexe_SO_DIVA_SAS		()	public	{				
8 				owner	= msg.sender;							
9 			}									
10 												
11 			modifier	onlyOwner	() {							
12 				require(msg.sender ==		owner	);					
13 				_;								
14 			}									
15 												
16 												
17 												
18 		// IN DATA / SET DATA / GET DATA / UINT 256 / PUBLIC / ONLY OWNER / CONSTANT										
19 												
20 												
21 			uint256	Titulaire_Compte_1	=	1000	;					
22 												
23 			function	setTitulaire_Compte_1	(	uint256	newTitulaire_Compte_1	)	public	onlyOwner	{	
24 				Titulaire_Compte_1	=	newTitulaire_Compte_1	;					
25 			}									
26 												
27 			function	getTitulaire_Compte_1	()	public	constant	returns	(	uint256	)	{
28 				return	Titulaire_Compte_1	;						
29 			}									
30 												
31 												
32 												
33 		// IN DATA / SET DATA / GET DATA / UINT 256 / PUBLIC / ONLY OWNER / CONSTANT										
34 												
35 												
36 			uint256	AyantDroitEconomique_Compte_1	=	1000	;					
37 												
38 			function	setAyantDroitEconomique_Compte_1	(	uint256	newAyantDroitEconomique_Compte_1	)	public	onlyOwner	{	
39 				AyantDroitEconomique_Compte_1	=	newAyantDroitEconomique_Compte_1	;					
40 			}									
41 												
42 			function	getAyantDroitEconomique_Compte_1	()	public	constant	returns	(	uint256	)	{
43 				return	AyantDroitEconomique_Compte_1	;						
44 			}									
45 												
46 												
47 												
48 		// IN DATA / SET DATA / GET DATA / UINT 256 / PUBLIC / ONLY OWNER / CONSTANT										
49 												
50 												
51 			uint256	Titulaire_Compte_2	=	1000	;					
52 												
53 			function	setTitulaire_Compte_2	(	uint256	newTitulaire_Compte_2	)	public	onlyOwner	{	
54 				Titulaire_Compte_2	=	newTitulaire_Compte_2	;					
55 			}									
56 												
57 			function	getTitulaire_Compte_2	()	public	constant	returns	(	uint256	)	{
58 				return	Titulaire_Compte_2	;						
59 			}									
60 												
61 												
62 												
63 		// IN DATA / SET DATA / GET DATA / UINT 256 / PUBLIC / ONLY OWNER / CONSTANT										
64 												
65 												
66 			uint256	AyantDroitEconomique_Compte_2	=	1000	;					
67 												
68 			function	setAyantDroitEconomique_Compte_2	(	uint256	newAyantDroitEconomique_Compte_2	)	public	onlyOwner	{	
69 				AyantDroitEconomique_Compte_2	=	newAyantDroitEconomique_Compte_2	;					
70 			}									
71 												
72 			function	getAyantDroitEconomique_Compte_2	()	public	constant	returns	(	uint256	)	{
73 				return	AyantDroitEconomique_Compte_2	;						
74 			}									
75 												
76 												
77 												
78 												
79 		// IN DATA / SET DATA / GET DATA / UINT 256 / PUBLIC / ONLY OWNER / CONSTANT										
80 												
81 												
82 			uint256	Titulaire_Compte_3	=	1000	;					
83 												
84 			function	setTitulaire_Compte_3	(	uint256	newTitulaire_Compte_3	)	public	onlyOwner	{	
85 				Titulaire_Compte_3	=	newTitulaire_Compte_3	;					
86 			}									
87 												
88 			function	getTitulaire_Compte_3	()	public	constant	returns	(	uint256	)	{
89 				return	Titulaire_Compte_3	;						
90 			}									
91 												
92 												
93 												
94 		// IN DATA / SET DATA / GET DATA / UINT 256 / PUBLIC / ONLY OWNER / CONSTANT										
95 												
96 												
97 			uint256	AyantDroitEconomique_Compte_3	=	1000	;					
98 												
99 			function	setAyantDroitEconomique_Compte_3	(	uint256	newAyantDroitEconomique_Compte_3	)	public	onlyOwner	{	
100 				AyantDroitEconomique_Compte_3	=	newAyantDroitEconomique_Compte_3	;					
101 			}									
102 												
103 			function	getAyantDroitEconomique_Compte_3	()	public	constant	returns	(	uint256	)	{
104 				return	AyantDroitEconomique_Compte_3	;						
105 			}									
106 												
107 												
108 												
109 		// IN DATA / SET DATA / GET DATA / UINT 256 / PUBLIC / ONLY OWNER / CONSTANT										
110 												
111 												
112 			uint256	Titulaire_Compte_4	=	1000	;					
113 												
114 			function	setTitulaire_Compte_4	(	uint256	newTitulaire_Compte_4	)	public	onlyOwner	{	
115 				Titulaire_Compte_4	=	newTitulaire_Compte_4	;					
116 			}									
117 												
118 			function	getTitulaire_Compte_4	()	public	constant	returns	(	uint256	)	{
119 				return	Titulaire_Compte_4	;						
120 			}									
121 												
122 												
123 												
124 		// IN DATA / SET DATA / GET DATA / UINT 256 / PUBLIC / ONLY OWNER / CONSTANT										
125 												
126 												
127 			uint256	AyantDroitEconomique_Compte_4	=	1000	;					
128 												
129 			function	setAyantDroitEconomique_Compte_4	(	uint256	newAyantDroitEconomique_Compte_4	)	public	onlyOwner	{	
130 				AyantDroitEconomique_Compte_4	=	newAyantDroitEconomique_Compte_4	;					
131 			}									
132 												
133 			function	getAyantDroitEconomique_Compte_4	()	public	constant	returns	(	uint256	)	{
134 				return	AyantDroitEconomique_Compte_4	;						
135 			}									
136 												
137 												
138 												
139 												
140 												
141 												
142 												
143 												
144 												
145 												
146 												
147 												
148 												
149 												
150 												
151 												
152 												
153 												
154 												
155 												
156 												
157 												
158 												
159 												
160 												
161 		// IN DATA / SET DATA / GET DATA / UINT 256 / PUBLIC / ONLY OWNER / CONSTANT										
162 												
163 												
164 			uint256	Titulaire_Compte_5	=	1000	;					
165 												
166 			function	setTitulaire_Compte_5	(	uint256	newTitulaire_Compte_5	)	public	onlyOwner	{	
167 				Titulaire_Compte_5	=	newTitulaire_Compte_5	;					
168 			}									
169 												
170 			function	getTitulaire_Compte_5	()	public	constant	returns	(	uint256	)	{
171 				return	Titulaire_Compte_5	;						
172 			}									
173 												
174 												
175 												
176 		// IN DATA / SET DATA / GET DATA / UINT 256 / PUBLIC / ONLY OWNER / CONSTANT										
177 												
178 												
179 			uint256	AyantDroitEconomique_Compte_5	=	1000	;					
180 												
181 			function	setAyantDroitEconomique_Compte_5	(	uint256	newAyantDroitEconomique_Compte_5	)	public	onlyOwner	{	
182 				AyantDroitEconomique_Compte_5	=	newAyantDroitEconomique_Compte_5	;					
183 			}									
184 												
185 			function	getAyantDroitEconomique_Compte_5	()	public	constant	returns	(	uint256	)	{
186 				return	AyantDroitEconomique_Compte_5	;						
187 			}									
188 												
189 												
190 												
191 		// IN DATA / SET DATA / GET DATA / UINT 256 / PUBLIC / ONLY OWNER / CONSTANT										
192 												
193 												
194 			uint256	Titulaire_Compte_6	=	1000	;					
195 												
196 			function	setTitulaire_Compte_6	(	uint256	newTitulaire_Compte_6	)	public	onlyOwner	{	
197 				Titulaire_Compte_6	=	newTitulaire_Compte_6	;					
198 			}									
199 												
200 			function	getTitulaire_Compte_6	()	public	constant	returns	(	uint256	)	{
201 				return	Titulaire_Compte_6	;						
202 			}									
203 												
204 												
205 												
206 		// IN DATA / SET DATA / GET DATA / UINT 256 / PUBLIC / ONLY OWNER / CONSTANT										
207 												
208 												
209 			uint256	AyantDroitEconomique_Compte_6	=	1000	;					
210 												
211 			function	setAyantDroitEconomique_Compte_6	(	uint256	newAyantDroitEconomique_Compte_6	)	public	onlyOwner	{	
212 				AyantDroitEconomique_Compte_6	=	newAyantDroitEconomique_Compte_6	;					
213 			}									
214 												
215 			function	getAyantDroitEconomique_Compte_6	()	public	constant	returns	(	uint256	)	{
216 				return	AyantDroitEconomique_Compte_6	;						
217 			}									
218 												
219 												
220 												
221 												
222 												
223 												
224 												
225 												
226 												
227 												
228 												
229 												
230 												
231 												
232 												
233 												
234 												
235 												
236 												
237 												
238 												
239 												
240 												
241 												
242 												
243 		// IN DATA / SET DATA / GET DATA / UINT 256 / PUBLIC / ONLY OWNER / CONSTANT										
244 												
245 												
246 			uint256	Titulaire_Compte_7	=	1000	;					
247 												
248 			function	setTitulaire_Compte_7	(	uint256	newTitulaire_Compte_7	)	public	onlyOwner	{	
249 				Titulaire_Compte_7	=	newTitulaire_Compte_7	;					
250 			}									
251 												
252 			function	getTitulaire_Compte_7	()	public	constant	returns	(	uint256	)	{
253 				return	Titulaire_Compte_7	;						
254 			}									
255 												
256 												
257 												
258 		// IN DATA / SET DATA / GET DATA / UINT 256 / PUBLIC / ONLY OWNER / CONSTANT										
259 												
260 												
261 			uint256	AyantDroitEconomique_Compte_7	=	1000	;					
262 												
263 			function	setAyantDroitEconomique_Compte_7	(	uint256	newAyantDroitEconomique_Compte_7	)	public	onlyOwner	{	
264 				AyantDroitEconomique_Compte_7	=	newAyantDroitEconomique_Compte_7	;					
265 			}									
266 												
267 			function	getAyantDroitEconomique_Compte_7	()	public	constant	returns	(	uint256	)	{
268 				return	AyantDroitEconomique_Compte_7	;						
269 			}									
270 												
271 												
272 												
273 		// IN DATA / SET DATA / GET DATA / UINT 256 / PUBLIC / ONLY OWNER / CONSTANT										
274 												
275 												
276 			uint256	Titulaire_Compte_8	=	1000	;					
277 												
278 			function	setTitulaire_Compte_8	(	uint256	newTitulaire_Compte_8	)	public	onlyOwner	{	
279 				Titulaire_Compte_8	=	newTitulaire_Compte_8	;					
280 			}									
281 												
282 			function	getTitulaire_Compte_8	()	public	constant	returns	(	uint256	)	{
283 				return	Titulaire_Compte_8	;						
284 			}									
285 												
286 												
287 												
288 		// IN DATA / SET DATA / GET DATA / UINT 256 / PUBLIC / ONLY OWNER / CONSTANT										
289 												
290 												
291 			uint256	AyantDroitEconomique_Compte_8	=	1000	;					
292 												
293 			function	setAyantDroitEconomique_Compte_8	(	uint256	newAyantDroitEconomique_Compte_8	)	public	onlyOwner	{	
294 				AyantDroitEconomique_Compte_8	=	newAyantDroitEconomique_Compte_8	;					
295 			}									
296 												
297 			function	getAyantDroitEconomique_Compte_8	()	public	constant	returns	(	uint256	)	{
298 				return	AyantDroitEconomique_Compte_8	;						
299 			}									
300 												
301 												
302 												
303 												
304 												
305 												
306 												
307 												
308 												
309 												
310 												
311 												
312 												
313 												
314 												
315 												
316 												
317 												
318 												
319 												
320 												
321 												
322 												
323 												
324 												
325 		// IN DATA / SET DATA / GET DATA / UINT 256 / PUBLIC / ONLY OWNER / CONSTANT										
326 												
327 												
328 			uint256	Titulaire_Compte_9	=	1000	;					
329 												
330 			function	setTitulaire_Compte_9	(	uint256	newTitulaire_Compte_9	)	public	onlyOwner	{	
331 				Titulaire_Compte_9	=	newTitulaire_Compte_9	;					
332 			}									
333 												
334 			function	getTitulaire_Compte_9	()	public	constant	returns	(	uint256	)	{
335 				return	Titulaire_Compte_9	;						
336 			}									
337 												
338 												
339 												
340 		// IN DATA / SET DATA / GET DATA / UINT 256 / PUBLIC / ONLY OWNER / CONSTANT										
341 												
342 												
343 			uint256	AyantDroitEconomique_Compte_9	=	1000	;					
344 												
345 			function	setAyantDroitEconomique_Compte_9	(	uint256	newAyantDroitEconomique_Compte_9	)	public	onlyOwner	{	
346 				AyantDroitEconomique_Compte_9	=	newAyantDroitEconomique_Compte_9	;					
347 			}									
348 												
349 			function	getAyantDroitEconomique_Compte_9	()	public	constant	returns	(	uint256	)	{
350 				return	AyantDroitEconomique_Compte_9	;						
351 			}									
352 												
353 												
354 												
355 		// IN DATA / SET DATA / GET DATA / UINT 256 / PUBLIC / ONLY OWNER / CONSTANT										
356 												
357 												
358 			uint256	Titulaire_Compte_10	=	1000	;					
359 												
360 			function	setTitulaire_Compte_10	(	uint256	newTitulaire_Compte_10	)	public	onlyOwner	{	
361 				Titulaire_Compte_10	=	newTitulaire_Compte_10	;					
362 			}									
363 												
364 			function	getTitulaire_Compte_10	()	public	constant	returns	(	uint256	)	{
365 				return	Titulaire_Compte_10	;						
366 			}									
367 												
368 												
369 												
370 		// IN DATA / SET DATA / GET DATA / UINT 256 / PUBLIC / ONLY OWNER / CONSTANT										
371 												
372 												
373 			uint256	AyantDroitEconomique_Compte_10	=	1000	;					
374 												
375 			function	setAyantDroitEconomique_Compte_10	(	uint256	newAyantDroitEconomique_Compte_10	)	public	onlyOwner	{	
376 				AyantDroitEconomique_Compte_10	=	newAyantDroitEconomique_Compte_10	;					
377 			}									
378 												
379 			function	getAyantDroitEconomique_Compte_10	()	public	constant	returns	(	uint256	)	{
380 				return	AyantDroitEconomique_Compte_10	;						
381 			}									
382 												
383 												
384 												
385 												
386 												
387 												
388 												
389 												
390 												
391 												
392 												
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
407 //	Descriptif :											
408 //	Relevé « Teneur de Compte » positions « OTC-LLV »											
409 //	Edition initiale :											
410 //	19.01.2017											
411 //												
412 //	Teneur de Compte Intermédiaire :											
413 //	« C****** * P******* S********** Société Autonome et décentralisée (D.A.C.) »											
414 //	Titulaire des comptes (principal) / Groupe											
415 //	« S***** Société par Actions Simplifiée »											
416 //												
417 //	Titulaire effectif de chaque compte :											
418 //	confer  fonction « getTitulaire_Compte_(i) »											
419 //	Ayan-droit-économique de chaque compte :											
420 //	confer  fonction « getAyantDroitEconomique_Compte_(j) »											
421 //												
422 //	Place de marché :											
423 //	« LLV_v30_12 »											
424 //	Teneur de marché (sans obligation contractuelle) :											
425 //	« C****** * P******* S********** Société Autonome et décentralisée (D.A.C.) »											
426 //	Courtier / Distributeur :											
427 //	-											
428 //	Contrepartie centrale :											
429 //	« LLV_v30_12 »											
430 //	Dépositaire :											
431 //	« LLV_v30_12 »											
432 //	Teneur de compte (principal) / Holding :											
433 //	« LLV_v30_12 »											
434 //	Garant :											
435 //	« LLV_v30_12 »											
436 //	« Chambre de Compensation » :											
437 //	« LLV_v30_12 »											
438 //	Opérateur « Règlement-Livraison » :											
439 //	« LLV_v30_12 »											
440 //												
441 //												
442 //												
443 //												
444 //												
445 //												
446 //												
447 //												
448 //												
449 //												
450 //												
451 //												
452 //												
453 //												
454 //												
455 //												
456 //												
457 //												
458 //												
459 //												
460 //												
461 //												
462 //												
463 //												
464 //												
465 //												
466 //												
467 //												
468 //												
469 //												
470 //												
471 //												
472 //												
473 //												
474 //												
475 //												
476 //												
477 //												
478 //												
479 //												
480 //												
481 //												
482 //												
483 //												
484 //												
485 
486 
487         }