1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXIX_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXIX_III_883		"	;
8 		string	public		symbol =	"	RUSS_PFXIX_III_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1046729532626950000000000000					;	
12 										
13 		event Transfer(address indexed from, address indexed to, uint256 value);								
14 										
15 		function SimpleERC20Token() public {								
16 			balanceOf[msg.sender] = totalSupply;							
17 			emit Transfer(address(0), msg.sender, totalSupply);							
18 		}								
19 										
20 		function transfer(address to, uint256 value) public returns (bool success) {								
21 			require(balanceOf[msg.sender] >= value);							
22 										
23 			balanceOf[msg.sender] -= value;  // deduct from sender's balance							
24 			balanceOf[to] += value;          // add to recipient's balance							
25 			emit Transfer(msg.sender, to, value);							
26 			return true;							
27 		}								
28 										
29 		event Approval(address indexed owner, address indexed spender, uint256 value);								
30 										
31 		mapping(address => mapping(address => uint256)) public allowance;								
32 										
33 		function approve(address spender, uint256 value)								
34 			public							
35 			returns (bool success)							
36 		{								
37 			allowance[msg.sender][spender] = value;							
38 			emit Approval(msg.sender, spender, value);							
39 			return true;							
40 		}								
41 										
42 		function transferFrom(address from, address to, uint256 value)								
43 			public							
44 			returns (bool success)							
45 		{								
46 			require(value <= balanceOf[from]);							
47 			require(value <= allowance[from][msg.sender]);							
48 										
49 			balanceOf[from] -= value;							
50 			balanceOf[to] += value;							
51 			allowance[from][msg.sender] -= value;							
52 			emit Transfer(from, to, value);							
53 			return true;							
54 		}								
55 //	}									
56 										
57 										
58 										
59 										
60 										
61 										
62 										
63 										
64 										
65 										
66 										
67 										
68 										
69 										
70 										
71 										
72 										
73 										
74 										
75 										
76 										
77 										
78 										
79 										
80 	// Programme d'émission - Lignes 1 à 10									
81 	//									
82 	//									
83 	//									
84 	//									
85 	//     [ Nom du portefeuille ; Numéro de la ligne ; Nom de la ligne ; Echéance ]									
86 	//         [ Adresse exportée ]									
87 	//         [ Unité ; Limite basse ; Limite haute ]									
88 	//         [ Hex ]									
89 	//									
90 	//									
91 	//									
92 	//     < RUSS_PFXIX_III_metadata_line_1_____Eurochem_20251101 >									
93 	//        < Kk8zMmRnTg6AfA112F6Ps2wnJA34gPBrD2e5ypTmF922n7jN6fKODV96XKrFOQ52 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000022367695.236534700000000000 ] >									
95 	//        < 0x0000000000000000000000000000000000000000000000000000000000222162 >									
96 	//     < RUSS_PFXIX_III_metadata_line_2_____Eurochem_Group_AG_Switzerland_20251101 >									
97 	//        < cP7a4FYxYvJn1cA19gwAzS5bk4E502cb5f14dsZmW654E8QrUVV7mN79yqm78dOo >									
98 	//        <  u =="0.000000000000000001" : ] 000000022367695.236534700000000000 ; 000000042781442.939095700000000000 ] >									
99 	//        < 0x0000000000000000000000000000000000000000000000000000222162414780 >									
100 	//     < RUSS_PFXIX_III_metadata_line_3_____Industrial _Group_Phosphorite_20251101 >									
101 	//        < cIc884Q318a72W2nsk5gqjJN85G3qtF58im0NMPclCl2c868F0wSpP06P332xsWG >									
102 	//        <  u =="0.000000000000000001" : ] 000000042781442.939095700000000000 ; 000000073516711.135540500000000000 ] >									
103 	//        < 0x0000000000000000000000000000000000000000000000000000414780702D77 >									
104 	//     < RUSS_PFXIX_III_metadata_line_4_____Novomoskovsky_Azot_20251101 >									
105 	//        < o4wq2oVp12ZI2N8Tqk6yde8BXh6vP29I5l3wqhZ8x3XCq1vPf0Aa087YyGbPWOEM >									
106 	//        <  u =="0.000000000000000001" : ] 000000073516711.135540500000000000 ; 000000092891394.824153000000000000 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000000000702D778DBDB3 >									
108 	//     < RUSS_PFXIX_III_metadata_line_5_____Novomoskovsky_Chlor_20251101 >									
109 	//        < 2391C5N92B58LV2s34eT66e872o2MFc42KRuxc66IFYX6YL35zcNJ65k0j4N86dk >									
110 	//        <  u =="0.000000000000000001" : ] 000000092891394.824153000000000000 ; 000000127961445.768936000000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000008DBDB3C340F1 >									
112 	//     < RUSS_PFXIX_III_metadata_line_6_____Nevinnomyssky_Azot_20251101 >									
113 	//        < Yp53n743hP4y64AAK517ZI8BYrzG02H8Jv08X71oE0wctGO5kB84PX554r69MH6H >									
114 	//        <  u =="0.000000000000000001" : ] 000000127961445.768936000000000000 ; 000000155788860.607155000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000C340F1EDB706 >									
116 	//     < RUSS_PFXIX_III_metadata_line_7_____EuroChem_Belorechenskie_Minudobrenia_20251101 >									
117 	//        < 1p862I47c85AWZ0138uSe98qy079rp1IJTnrSglz365BoSJGu6tpuu4F7T5JMmet >									
118 	//        <  u =="0.000000000000000001" : ] 000000155788860.607155000000000000 ; 000000174750247.430260000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000000EDB70610AA5D1 >									
120 	//     < RUSS_PFXIX_III_metadata_line_8_____Kovdorsky_GOK_20251101 >									
121 	//        < IbLB44j4764l2KWsiuhGEDB729gzLJg31y364YeS8Va7qcDNcN3d0069mal6HiLT >									
122 	//        <  u =="0.000000000000000001" : ] 000000174750247.430260000000000000 ; 000000199067432.702704000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000010AA5D112FC0B7 >									
124 	//     < RUSS_PFXIX_III_metadata_line_9_____Lifosa_AB_20251101 >									
125 	//        < rkFjwjbT4ckl3kdNT5fvsMZOF6oibnZF47Eb326qpJ00K4doBMwVZNR44ZDYB23A >									
126 	//        <  u =="0.000000000000000001" : ] 000000199067432.702704000000000000 ; 000000228482176.851893000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000012FC0B715CA2DA >									
128 	//     < RUSS_PFXIX_III_metadata_line_10_____EuroChem_Antwerpen_NV_20251101 >									
129 	//        < KmADeY4NJrli9708E45LK1807sjqAlolFk5Nox91mN1211dQ5d87dvoOcFbMtfM3 >									
130 	//        <  u =="0.000000000000000001" : ] 000000228482176.851893000000000000 ; 000000254077359.917851000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000015CA2DA183B0F8 >									
132 										
133 										
134 										
135 										
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
161 										
162 	// Programme d'émission - Lignes 11 à 20									
163 	//									
164 	//									
165 	//									
166 	//									
167 	//     [ Nom du portefeuille ; Numéro de la ligne ; Nom de la ligne ; Echéance ]									
168 	//         [ Adresse exportée ]									
169 	//         [ Unité ; Limite basse ; Limite haute ]									
170 	//         [ Hex ]									
171 	//									
172 	//									
173 	//									
174 	//     < RUSS_PFXIX_III_metadata_line_11_____EuroChem_VolgaKaliy_20251101 >									
175 	//        < fsyZwhXOFfgmjl7Pl2c3J29wQDS25047QCKSFUkN4m73vxh05Q87pGw221j6QQ01 >									
176 	//        <  u =="0.000000000000000001" : ] 000000254077359.917851000000000000 ; 000000275664536.453829000000000000 ] >									
177 	//        < 0x00000000000000000000000000000000000000000000000000183B0F81A4A176 >									
178 	//     < RUSS_PFXIX_III_metadata_line_12_____EuroChem_Usolsky_potash_complex_20251101 >									
179 	//        < G31CZ94C8P3BWyYvjD8Cq53bj97TF4Gh87997PZnf0M8IS1rTju051PhJLWtT9s9 >									
180 	//        <  u =="0.000000000000000001" : ] 000000275664536.453829000000000000 ; 000000299178311.323687000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000001A4A1761C88287 >									
182 	//     < RUSS_PFXIX_III_metadata_line_13_____EuroChem_ONGK_20251101 >									
183 	//        < TTldTrQOBHzD6N3EOpW7SNnIqG3gzmnTpVUQ97DYe97wUaXiL2zwhKA9LE9C1X5p >									
184 	//        <  u =="0.000000000000000001" : ] 000000299178311.323687000000000000 ; 000000319206922.079306000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001C882871E71234 >									
186 	//     < RUSS_PFXIX_III_metadata_line_14_____EuroChem_Northwest_20251101 >									
187 	//        < q8iuWUBu4EYOaRtEUB2J1EUG86b3617DN5Nf5Bi8gd1044652M2Pd875ZH97liNO >									
188 	//        <  u =="0.000000000000000001" : ] 000000319206922.079306000000000000 ; 000000351132891.119299000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000001E71234217C949 >									
190 	//     < RUSS_PFXIX_III_metadata_line_15_____EuroChem_Fertilizers_20251101 >									
191 	//        < bv370Srm5Z7ycwt8ZwlK7nAnnXdO7Iz3kd2xEXEx43V376p8HSQK28015WHZVe0z >									
192 	//        <  u =="0.000000000000000001" : ] 000000351132891.119299000000000000 ; 000000378107683.788203000000000000 ] >									
193 	//        < 0x00000000000000000000000000000000000000000000000000217C949240F250 >									
194 	//     < RUSS_PFXIX_III_metadata_line_16_____Astrakhan_Oil_and_Gas_Company_20251101 >									
195 	//        < K4TawC3okvg5Xp6Imh38pI4VDL8JOOy55pWQuS8J7FSY1i0B6zGiB46k4P4b8P5z >									
196 	//        <  u =="0.000000000000000001" : ] 000000378107683.788203000000000000 ; 000000399261879.883325000000000000 ] >									
197 	//        < 0x00000000000000000000000000000000000000000000000000240F25026139AC >									
198 	//     < RUSS_PFXIX_III_metadata_line_17_____Sary_Tas_Fertilizers_20251101 >									
199 	//        < a4js3gV4B3T524844p4dOYcU9HX77703G14hnxpIh97tM78imk1764xzbW0qx15T >									
200 	//        <  u =="0.000000000000000001" : ] 000000399261879.883325000000000000 ; 000000433508729.875832000000000000 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000000026139AC2957B59 >									
202 	//     < RUSS_PFXIX_III_metadata_line_18_____EuroChem_Karatau_20251101 >									
203 	//        < 443tTeUjX2qDTO95MJt5w00YKyS0pZ25yvW0s46Jn4If83gMEB99O50Bf3DwOCpK >									
204 	//        <  u =="0.000000000000000001" : ] 000000433508729.875832000000000000 ; 000000457221045.624263000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000002957B592B9A9F9 >									
206 	//     < RUSS_PFXIX_III_metadata_line_19_____Kamenkovskaya_Oil_Gas_Company_20251101 >									
207 	//        < 375rLd8974hTb0MyV4T4iLDEEA2tXPE15da24aJ9LLqqEvXKUsLkTpsflu0B3Bp3 >									
208 	//        <  u =="0.000000000000000001" : ] 000000457221045.624263000000000000 ; 000000486526164.252331000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000002B9A9F92E66148 >									
210 	//     < RUSS_PFXIX_III_metadata_line_20_____EuroChem_Trading_GmbH_Trading_20251101 >									
211 	//        < qYGh9y4qUXDnL29AaxwY85SqGtwT0W1Y4lO8pfP176aHg0NXAzOWms4sFBi8O7us >									
212 	//        <  u =="0.000000000000000001" : ] 000000486526164.252331000000000000 ; 000000510450544.542939000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000002E6614830AE2BE >									
214 										
215 										
216 										
217 										
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
243 										
244 	// Programme d'émission - Lignes 21 à 30									
245 	//									
246 	//									
247 	//									
248 	//									
249 	//     [ Nom du portefeuille ; Numéro de la ligne ; Nom de la ligne ; Echéance ]									
250 	//         [ Adresse exportée ]									
251 	//         [ Unité ; Limite basse ; Limite haute ]									
252 	//         [ Hex ]									
253 	//									
254 	//									
255 	//									
256 	//     < RUSS_PFXIX_III_metadata_line_21_____EuroChem_Trading_USA_Corp_20251101 >									
257 	//        < 0K9In4OJJxzaF1D54137sI0bRIYh9PfGjN2okxo93vRP3A01lqqvffX3QE5Y0R9V >									
258 	//        <  u =="0.000000000000000001" : ] 000000510450544.542939000000000000 ; 000000536977087.060325000000000000 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000000030AE2BE3335CAD >									
260 	//     < RUSS_PFXIX_III_metadata_line_22_____Ben_Trei_Ltd_20251101 >									
261 	//        < xn7seX970VH6D0NOHT6753OtWA5TZr5Ag88mL1oP645LJoZ65Y154ubnd9fl0DM7 >									
262 	//        <  u =="0.000000000000000001" : ] 000000536977087.060325000000000000 ; 000000567287338.096706000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000003335CAD3619C9E >									
264 	//     < RUSS_PFXIX_III_metadata_line_23_____EuroChem_Agro_SAS_20251101 >									
265 	//        < vpHj0n7U50sPP02K82atCZZw4YkI6hy37Irn081mWE2Ux5V082g20D1uSZ93V8p2 >									
266 	//        <  u =="0.000000000000000001" : ] 000000567287338.096706000000000000 ; 000000598887323.292365000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000003619C9E391D45C >									
268 	//     < RUSS_PFXIX_III_metadata_line_24_____EuroChem_Agro_Asia_20251101 >									
269 	//        < tgv7Aw9PIY0fyP6mI7fw363et0FGFb0hsnf0LzW20w4721UJ36UJAnHz19dj5LC8 >									
270 	//        <  u =="0.000000000000000001" : ] 000000598887323.292365000000000000 ; 000000618696757.381161000000000000 ] >									
271 	//        < 0x00000000000000000000000000000000000000000000000000391D45C3B00E6C >									
272 	//     < RUSS_PFXIX_III_metadata_line_25_____EuroChem_Agro_Iberia_20251101 >									
273 	//        < g27V3Oxr8X8kghcgPUXD0iVdmz5Eq441DOq8NPnp76Na0RA4O7d2ecfs472W6iWE >									
274 	//        <  u =="0.000000000000000001" : ] 000000618696757.381161000000000000 ; 000000648683928.735351000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000003B00E6C3DDD029 >									
276 	//     < RUSS_PFXIX_III_metadata_line_26_____EuroChem_Agricultural_Trading_Hellas_20251101 >									
277 	//        < 96LZJmrwJ9Z4xt1eo99Y5UeOCYnWytVxakdkFVDlsmeK31jJMv5TjF6Veix1dMtR >									
278 	//        <  u =="0.000000000000000001" : ] 000000648683928.735351000000000000 ; 000000680663118.814400000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000003DDD02940E9C08 >									
280 	//     < RUSS_PFXIX_III_metadata_line_27_____EuroChem_Agro_Spa_20251101 >									
281 	//        < WdHa1ihWl745xvyPy6KjB4AD8y8sri6I1difnN4a0j8qn4AOYeERpA9B4QfM8E27 >									
282 	//        <  u =="0.000000000000000001" : ] 000000680663118.814400000000000000 ; 000000707995249.000431000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000040E9C0843850A5 >									
284 	//     < RUSS_PFXIX_III_metadata_line_28_____EuroChem_Agro_GmbH_20251101 >									
285 	//        < v7Srmsd69vgLVv2djcac0O8I7pdlu3hOJGCJT610l8R4Ew5fz3w2DwH68bNB8QnF >									
286 	//        <  u =="0.000000000000000001" : ] 000000707995249.000431000000000000 ; 000000738303307.132177000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000043850A54668FBB >									
288 	//     < RUSS_PFXIX_III_metadata_line_29_____EuroChem_Agro_México_SA_20251101 >									
289 	//        < TPd51AZklra3ncxwLm6vy3EE1aRE0CFbQf4X607jsKP0yT6lTKiF1p0Y36bhi3l8 >									
290 	//        <  u =="0.000000000000000001" : ] 000000738303307.132177000000000000 ; 000000761055212.697106000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000004668FBB4894731 >									
292 	//     < RUSS_PFXIX_III_metadata_line_30_____EuroChem_Agro_Hungary_Kft_20251101 >									
293 	//        < 1WAj3ZwH1a5pBliDV2M11EtD6RG7l640GDIhj3YD9S94BrYH4w0SG5gf68jly3oU >									
294 	//        <  u =="0.000000000000000001" : ] 000000761055212.697106000000000000 ; 000000779572963.215639000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000048947314A588B0 >									
296 										
297 										
298 										
299 										
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
325 										
326 	// Programme d'émission - Lignes 31 à 40									
327 	//									
328 	//									
329 	//									
330 	//									
331 	//     [ Nom du portefeuille ; Numéro de la ligne ; Nom de la ligne ; Echéance ]									
332 	//         [ Adresse exportée ]									
333 	//         [ Unité ; Limite basse ; Limite haute ]									
334 	//         [ Hex ]									
335 	//									
336 	//									
337 	//									
338 	//     < RUSS_PFXIX_III_metadata_line_31_____Agrocenter_EuroChem_Srl_20251101 >									
339 	//        < rhfV78A05tGq2gIK54DOY2H0J46K2TQG7t2om5ncezxC1IzHutqei882720E7HxH >									
340 	//        <  u =="0.000000000000000001" : ] 000000779572963.215639000000000000 ; 000000801707756.191986000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000004A588B04C74F18 >									
342 	//     < RUSS_PFXIX_III_metadata_line_32_____EuroChem_Agro_Bulgaria_Ead_20251101 >									
343 	//        < 2o4z467c1hZvEmyFXAMGf5jMasyMCgWtl1Dp42MIWb58zB2g3O9GPEzb83Uh5gK7 >									
344 	//        <  u =="0.000000000000000001" : ] 000000801707756.191986000000000000 ; 000000827083771.026888000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000004C74F184EE0799 >									
346 	//     < RUSS_PFXIX_III_metadata_line_33_____EuroChem_Agro_doo_Beograd_20251101 >									
347 	//        < LJo8RSfn37251vrm306mL762264t154MfPt1i0u200f86UC97BVDzJ0P8HpIaoeZ >									
348 	//        <  u =="0.000000000000000001" : ] 000000827083771.026888000000000000 ; 000000854940710.051593000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000004EE07995188937 >									
350 	//     < RUSS_PFXIX_III_metadata_line_34_____EuroChem_Agro_Turkey_Tarim_Sanayi_ve_Ticaret_20251101 >									
351 	//        < hsuouCGD6fpw58I862H9oCu3yyyA023F6UA4UcE4Pf9v4V2O5Rk67GZ5P2veBu1x >									
352 	//        <  u =="0.000000000000000001" : ] 000000854940710.051593000000000000 ; 000000881473069.806756000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000005188937541056B >									
354 	//     < RUSS_PFXIX_III_metadata_line_35_____Emerger_Fertilizantes_SA_20251101 >									
355 	//        < 7fe3IoPHh7xs9Ec8bydoY2spP0oQh766Lg1kzr8pRv122Runl1O48AHgs3SLnqMX >									
356 	//        <  u =="0.000000000000000001" : ] 000000881473069.806756000000000000 ; 000000916026061.059994000000000000 ] >									
357 	//        < 0x00000000000000000000000000000000000000000000000000541056B575BEAE >									
358 	//     < RUSS_PFXIX_III_metadata_line_36_____EuroChem_Comercio_Produtos_Quimicos_20251101 >									
359 	//        < PDa2iUUdg7xWYJr5ak1nmyDf14q2BsP3c5fPZ1k9ydtuMxk13Lx4TM8Xj5Y3byG3 >									
360 	//        <  u =="0.000000000000000001" : ] 000000916026061.059994000000000000 ; 000000942423602.500759000000000000 ] >									
361 	//        < 0x00000000000000000000000000000000000000000000000000575BEAE59E0638 >									
362 	//     < RUSS_PFXIX_III_metadata_line_37_____Fertilizantes_Tocantines_Ltda_20251101 >									
363 	//        < G6aQ6nPwp90PkX8w5Q51uju1AJmD9x11n7U7q950MmO3JM1tTxojh6204kFNVl53 >									
364 	//        <  u =="0.000000000000000001" : ] 000000942423602.500759000000000000 ; 000000967960952.433866000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000059E06385C4FDBF >									
366 	//     < RUSS_PFXIX_III_metadata_line_38_____EuroChem_Agro_Trading_Shenzhen_20251101 >									
367 	//        < 394BY2v280EJ8yw0uTE1gDN7a5w6g8y976Cp6cfJ2Mnq5JzW5Y9252eAgOndeqfg >									
368 	//        <  u =="0.000000000000000001" : ] 000000967960952.433866000000000000 ; 000001003141365.088670000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000005C4FDBF5FAAC19 >									
370 	//     < RUSS_PFXIX_III_metadata_line_39_____EuroChem_Trading_RUS_20251101 >									
371 	//        < z3N6jhiv4eJO994E19g1MuDW9IiQo091mIP00Am54wmA39TjdWF1vJ467VbumlVb >									
372 	//        <  u =="0.000000000000000001" : ] 000001003141365.088670000000000000 ; 000001025515221.407030000000000000 ] >									
373 	//        < 0x000000000000000000000000000000000000000000000000005FAAC1961CCFE2 >									
374 	//     < RUSS_PFXIX_III_metadata_line_40_____AgroCenter_EuroChem_Ukraine_20251101 >									
375 	//        < 6Z0Nk102HZ5Qlaw6aMnWm1u7Ort7w0LkN7yY7ELamEYXf7ejO073n3on22WQ84uf >									
376 	//        <  u =="0.000000000000000001" : ] 000001025515221.407030000000000000 ; 000001046729532.626950000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000061CCFE263D2EB9 >									
378 										
379 										
380 										
381 										
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
407 	}