1 pragma solidity 		^0.4.25	;						
2 										
3 	contract	CHEMCHINA_PFII_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	CHEMCHINA_PFII_I_883		"	;
8 		string	public		symbol =	"	CHEMCHINA_PFII_I_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		562437397317196000000000000					;	
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
92 	//     < CHEMCHINA_PFII_I_metadata_line_1_____CHANGZHOU_WUJIN_LINCHUAN_CHEMICAL_Co_Limited_20220321 >									
93 	//        < 91FsvSyof0Oi3nHqLqdpnZ55haDhCL4EaX8CszM9UbEsi3255wHz3KJ07xF86D7L >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000014381151.812580400000000000 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000000015F1A3 >									
96 	//     < CHEMCHINA_PFII_I_metadata_line_2_____Chem_Stone_Co__Limited_20220321 >									
97 	//        < vp6NY4xV3DPCb2OM2vR0Nt3VzVJSBh65UW41cE0VhWD9De7N3r36bGoBPo5y39iL >									
98 	//        <  u =="0.000000000000000001" : ] 000000014381151.812580400000000000 ; 000000028424445.411850500000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000015F1A32B5F4D >									
100 	//     < CHEMCHINA_PFII_I_metadata_line_3_____Chemleader_Biomedical_Co_Limited_20220321 >									
101 	//        < m2XN31HOKXiqOlQW2R618KQo0GzHilFbY2BeWF1Rqf9BqRMUaaQJGkC0892Lvt2q >									
102 	//        <  u =="0.000000000000000001" : ] 000000028424445.411850500000000000 ; 000000042186755.371384700000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000002B5F4D405F34 >									
104 	//     < CHEMCHINA_PFII_I_metadata_line_4_____Chemner_Pharma_20220321 >									
105 	//        < X4GQ5h5fNzQqBvfD365iNRCeyg7VzlmH1bCDT6rv0QU9bc3xvR9J8CWM099Z02Sm >									
106 	//        <  u =="0.000000000000000001" : ] 000000042186755.371384700000000000 ; 000000056108691.537899000000000000 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000000000405F34559D75 >									
108 	//     < CHEMCHINA_PFII_I_metadata_line_5_____Chemtour_Biotech__Suzhou__org_20220321 >									
109 	//        < TFLSoLnqk5D8eWOVRFpp3gBLg6DRAt1570Nq4WFMk2P708xfClC8uTxK4FFHgu8u >									
110 	//        <  u =="0.000000000000000001" : ] 000000056108691.537899000000000000 ; 000000070974303.241395100000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000559D756C4C56 >									
112 	//     < CHEMCHINA_PFII_I_metadata_line_6_____Chemtour_Biotech__Suzhou__Co__Ltd_20220321 >									
113 	//        < K75Lk6unACL05aY5m3bFt40gAVj4n9NyhaQ9DNA0in3wKT70ej80hlUExWKOk6yp >									
114 	//        <  u =="0.000000000000000001" : ] 000000070974303.241395100000000000 ; 000000083759223.972409200000000000 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000000000006C4C567FCE72 >									
116 	//     < CHEMCHINA_PFII_I_metadata_line_7_____Chemvon_Biotechnology_Co__Limited_20220321 >									
117 	//        < rFM32Y9Ch732y5U1yr8Xj1025lOr33dSnIOLu3Wy3vMAsB22NgBc32YXQ6K25PsL >									
118 	//        <  u =="0.000000000000000001" : ] 000000083759223.972409200000000000 ; 000000097803707.191067200000000000 ] >									
119 	//        < 0x00000000000000000000000000000000000000000000000000007FCE72953C93 >									
120 	//     < CHEMCHINA_PFII_I_metadata_line_8_____Chengdu_Aslee_Biopharmaceuticals,_inc__20220321 >									
121 	//        < O55QMj1HqHXJXMAaX2GYz25dxH1g0Yy1i0ty4ne9AcUH2Y3A77P1gv0B0Np3IZuj >									
122 	//        <  u =="0.000000000000000001" : ] 000000097803707.191067200000000000 ; 000000111758583.176953000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000953C93AA87B2 >									
124 	//     < CHEMCHINA_PFII_I_metadata_line_9_____Chuxiong_Yunzhi_Phytopharmaceutical_Co_Limited_20220321 >									
125 	//        < QAPIi6wtUxYn7OhrUDIiY1UuJySLmi781933df32Fn5J9d01y2VjslC0Fe8bdI79 >									
126 	//        <  u =="0.000000000000000001" : ] 000000111758583.176953000000000000 ; 000000127947806.209361000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000000AA87B2C33B9D >									
128 	//     < CHEMCHINA_PFII_I_metadata_line_10_____Conier_Chem_Pharma__Limited_20220321 >									
129 	//        < F81bufJGG5QMkQv7m6W8JK3W2pPOj2kwm2eI7Tn3cMMHHlZ4JUu0n9LMw0Hw30Vf >									
130 	//        <  u =="0.000000000000000001" : ] 000000127947806.209361000000000000 ; 000000141859134.979930000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000000C33B9DD875B9 >									
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
174 	//     < CHEMCHINA_PFII_I_metadata_line_11_____Cool_Pharm_Ltd_20220321 >									
175 	//        < a4rNwB2jtCzk4a86A9qSFCiEFA02IqcW3a2Tss039kfWySZ12iA0HIPlvEY3kgK2 >									
176 	//        <  u =="0.000000000000000001" : ] 000000141859134.979930000000000000 ; 000000155404743.239708000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000000D875B9ED20FA >									
178 	//     < CHEMCHINA_PFII_I_metadata_line_12_____Coresyn_Pharmatech_Co__Limited_20220321 >									
179 	//        < K84OKG51eN1RKkM7mCtcrCzf3Zsab484PaMV587u0A949aJLBiyKt4HWrSg7N1z5 >									
180 	//        <  u =="0.000000000000000001" : ] 000000155404743.239708000000000000 ; 000000167840007.502558000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000000ED20FA1001A81 >									
182 	//     < CHEMCHINA_PFII_I_metadata_line_13_____Dalian_Join_King_Fine_Chemical_org_20220321 >									
183 	//        < SQ2R01oMH6M2TxyKYP5pQ2QrG43cs9EJ0S0F8U5qIBalx13fmGWlr6794DS57r6A >									
184 	//        <  u =="0.000000000000000001" : ] 000000167840007.502558000000000000 ; 000000180494661.587986000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001001A8111369BA >									
186 	//     < CHEMCHINA_PFII_I_metadata_line_14_____Dalian_Join_King_Fine_Chemical_Co_Limited_20220321 >									
187 	//        < axQyBBLfHo8ynISaGXl3XscnO5EnPZY2fugLy0q8h9jUgTaRTgyd5MrkD4eV8O64 >									
188 	//        <  u =="0.000000000000000001" : ] 000000180494661.587986000000000000 ; 000000193710263.154628000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000011369BA1279412 >									
190 	//     < CHEMCHINA_PFII_I_metadata_line_15_____Dalian_Richfortune_Chemicals_Co_Limited_20220321 >									
191 	//        < nWhGN424A87P26u0ZxZpN7m8KrUEwaPZ45OB1ME418kl4064UWY6XP4OrQ44H93X >									
192 	//        <  u =="0.000000000000000001" : ] 000000193710263.154628000000000000 ; 000000206742032.251600000000000000 ] >									
193 	//        < 0x00000000000000000000000000000000000000000000000000127941213B769B >									
194 	//     < CHEMCHINA_PFII_I_metadata_line_16_____Daming_Changda_Co_Limited__LLBCHEM__20220321 >									
195 	//        < 1gC9Kp09uj4N2nFLo4byZDiP5ukvh4HMY0x2pZyP2vf0BpMd9wa6Tm5OqPwbYmKV >									
196 	//        <  u =="0.000000000000000001" : ] 000000206742032.251600000000000000 ; 000000222901020.045138000000000000 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000000013B769B1541EB6 >									
198 	//     < CHEMCHINA_PFII_I_metadata_line_17_____DATO_Chemicals_Co_Limited_20220321 >									
199 	//        < quj5b3KpcFHo3TWVbLug5XC90vlF3mcFM516q3OqGKeH0zokM3F2CgspUcdosITc >									
200 	//        <  u =="0.000000000000000001" : ] 000000222901020.045138000000000000 ; 000000238227099.425683000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000001541EB616B8176 >									
202 	//     < CHEMCHINA_PFII_I_metadata_line_18_____DC_Chemicals_20220321 >									
203 	//        < wTApc70lyr3Vz5bzamY5b6i3gU4Qq8Zn3fiuVQ28MgmA40mTy0Ne3jxpN3P5qYaS >									
204 	//        <  u =="0.000000000000000001" : ] 000000238227099.425683000000000000 ; 000000251661441.141712000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000016B81761800140 >									
206 	//     < CHEMCHINA_PFII_I_metadata_line_19_____Depont_Molecular_Co_Limited_20220321 >									
207 	//        < 8j066TqFac8NTmSZRw9HSiDYN0Lgo8aP6Ddfus6G5D92luUmKI6Es9a369X9BNnu >									
208 	//        <  u =="0.000000000000000001" : ] 000000251661441.141712000000000000 ; 000000265877277.199360000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000001800140195B250 >									
210 	//     < CHEMCHINA_PFII_I_metadata_line_20_____DSL_Chemicals_Co_Ltd_20220321 >									
211 	//        < YZMQ0ADO4sC75N98rU1IhCW5J261D8oz7tgwdO7eQ6JMUPc1ILp2PHTA7owh5NM9 >									
212 	//        <  u =="0.000000000000000001" : ] 000000265877277.199360000000000000 ; 000000278986312.395237000000000000 ] >									
213 	//        < 0x00000000000000000000000000000000000000000000000000195B2501A9B307 >									
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
256 	//     < CHEMCHINA_PFII_I_metadata_line_21_____Elsa_Biotechnology_org_20220321 >									
257 	//        < 9reYX9YyLX35GJ37haW3X8obl7Tj451HaGLs53H1b93BpO8svuAbPLlc95gUSqUd >									
258 	//        <  u =="0.000000000000000001" : ] 000000278986312.395237000000000000 ; 000000293694008.912164000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000001A9B3071C02439 >									
260 	//     < CHEMCHINA_PFII_I_metadata_line_22_____Elsa_Biotechnology_Co_Limited_20220321 >									
261 	//        < D7p7iQl1965C9zwLOXHfD6lG1ICwf21zL81B6c9SZXVlYwGh7E2zvE9JepsDHy2T >									
262 	//        <  u =="0.000000000000000001" : ] 000000293694008.912164000000000000 ; 000000308615843.125382000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000001C024391D6E910 >									
264 	//     < CHEMCHINA_PFII_I_metadata_line_23_____Enze_Chemicals_Co_Limited_20220321 >									
265 	//        < drzu1BbJj2P3pxM66fZgQEZgs840Ge3Y090p4R4o7R800VXXtV3Q5S7s902l7ElD >									
266 	//        <  u =="0.000000000000000001" : ] 000000308615843.125382000000000000 ; 000000321743321.302683000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000001D6E9101EAF0FC >									
268 	//     < CHEMCHINA_PFII_I_metadata_line_24_____EOS_Med_Chem_20220321 >									
269 	//        < jmORQ1L55Oe07d43q29i99dv11L2ygCwB48339N30RMa3115OUa97mU3q4gGMM5g >									
270 	//        <  u =="0.000000000000000001" : ] 000000321743321.302683000000000000 ; 000000334313855.260277000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000001EAF0FC1FE1F5A >									
272 	//     < CHEMCHINA_PFII_I_metadata_line_25_____EOS_Med_Chem_20220321 >									
273 	//        < 9VyF9DQGB7ImZezJmr08vchnTt5gSIXR2Hy926oW60T101zN8TsyBJK4ycaW05q4 >									
274 	//        <  u =="0.000000000000000001" : ] 000000334313855.260277000000000000 ; 000000349879610.963648000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000001FE1F5A215DFB9 >									
276 	//     < CHEMCHINA_PFII_I_metadata_line_26_____ETA_ChemTech_Co_Ltd_20220321 >									
277 	//        < 174cRc0bl0ToN0fwl4p6024TxRdOw4It5GK6yH7xFTU8BA2c6Etr69LjZ8ogO45L >									
278 	//        <  u =="0.000000000000000001" : ] 000000349879610.963648000000000000 ; 000000363675544.696950000000000000 ] >									
279 	//        < 0x00000000000000000000000000000000000000000000000000215DFB922AECC2 >									
280 	//     < CHEMCHINA_PFII_I_metadata_line_27_____FEIMING_CHEMICAL_LIMITED_20220321 >									
281 	//        < wt8ED4Emyq4ZAc5eQrQAQ3I681pKS61lP5YabPw28C92ot80d7hx3n7dv17C7ys1 >									
282 	//        <  u =="0.000000000000000001" : ] 000000363675544.696950000000000000 ; 000000377542665.584837000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000022AECC2240159B >									
284 	//     < CHEMCHINA_PFII_I_metadata_line_28_____FINETECH_INDUSTRY_LIMITED_20220321 >									
285 	//        < s6J5CYfs30Odu8058gw3oDxw2N34EY1GVpp93mFH1jTf5eL01yr9nlq0nJLP3Q89 >									
286 	//        <  u =="0.000000000000000001" : ] 000000377542665.584837000000000000 ; 000000390169499.629399000000000000 ] >									
287 	//        < 0x00000000000000000000000000000000000000000000000000240159B25359F6 >									
288 	//     < CHEMCHINA_PFII_I_metadata_line_29_____Finetech_Industry_Limited_20220321 >									
289 	//        < I2H9ADbbUbNdt0oAyC1WnpIxv4m0NxZ4rk7v8wcke9R5A2zyhFgxdUf7988Jo0x4 >									
290 	//        <  u =="0.000000000000000001" : ] 000000390169499.629399000000000000 ; 000000403182626.588839000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000025359F62673537 >									
292 	//     < CHEMCHINA_PFII_I_metadata_line_30_____Fluoropharm_org_20220321 >									
293 	//        < 8Y5p52pu8p92CPIw5b06bPPo44jy8x7h8JsQYPOcW5Rk5cOlCrGp87d427plk65R >									
294 	//        <  u =="0.000000000000000001" : ] 000000403182626.588839000000000000 ; 000000419357041.451906000000000000 ] >									
295 	//        < 0x00000000000000000000000000000000000000000000000000267353727FE358 >									
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
338 	//     < CHEMCHINA_PFII_I_metadata_line_31_____Fluoropharm_Co_Limited_20220321 >									
339 	//        < oyO8123RI8PxMSf8UL1XH6mVRmv3gRc0b0qI7GG1a20l4PnR2PsW3Hi7QwI21tUy >									
340 	//        <  u =="0.000000000000000001" : ] 000000419357041.451906000000000000 ; 000000432169817.796599000000000000 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000000000027FE3582937056 >									
342 	//     < CHEMCHINA_PFII_I_metadata_line_32_____Fond_Chemical_Co_Limited_20220321 >									
343 	//        < VU8DT8zmma2w95aX5R82rA7S68PS5s5KGD0BjM5WXIIsoESnVPZNKMk28uQuEy4e >									
344 	//        <  u =="0.000000000000000001" : ] 000000432169817.796599000000000000 ; 000000447163398.319946000000000000 ] >									
345 	//        < 0x0000000000000000000000000000000000000000000000000029370562AA5134 >									
346 	//     < CHEMCHINA_PFII_I_metadata_line_33_____Gansu_Research_Institute_of_Chemical_Industry_20220321 >									
347 	//        < ho0CrUB9P09SPgl3BT2po7Xh3V68GjGX19s7unQ92826l82zkAvKwyJi1YJYl97d >									
348 	//        <  u =="0.000000000000000001" : ] 000000447163398.319946000000000000 ; 000000461549108.243350000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000002AA51342C0449F >									
350 	//     < CHEMCHINA_PFII_I_metadata_line_34_____GL_Biochem__Shanghai__Ltd__20220321 >									
351 	//        < Ee7V0p1nH0WE31LT14Ebe1ep2KnelnQ61gq5ot6W0Jjm5feaKW0U6F0s8BGWfI5m >									
352 	//        <  u =="0.000000000000000001" : ] 000000461549108.243350000000000000 ; 000000476914473.437534000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000002C0449F2D7B6B7 >									
354 	//     < CHEMCHINA_PFII_I_metadata_line_35_____Guangzhou_Topwork_Chemical_Co__Limited_20220321 >									
355 	//        < A5100nzwmkaMHP0AG8o02dtg7y5hyC1U25F62dT3j9fohI9z2B5xx4n1hPkX84R3 >									
356 	//        <  u =="0.000000000000000001" : ] 000000476914473.437534000000000000 ; 000000493056084.688255000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000002D7B6B72F05808 >									
358 	//     < CHEMCHINA_PFII_I_metadata_line_36_____Hallochem_Pharma_Co_Limited_20220321 >									
359 	//        < 4s7n74xd2vFKW5dYbfWF3u11hH4AyIF279OfeJ8KKN91wr7208xT911uFdZUlfr2 >									
360 	//        <  u =="0.000000000000000001" : ] 000000493056084.688255000000000000 ; 000000508803657.272489000000000000 ] >									
361 	//        < 0x000000000000000000000000000000000000000000000000002F058083085F6E >									
362 	//     < CHEMCHINA_PFII_I_metadata_line_37_____Hanghzou_Fly_Source_Chemical_Co_Limited_20220321 >									
363 	//        < r9DjGKIFL2WMT2ni4K26ZeCb4cQbJrtgVNY8L7bmogLhC13vOlQ2EwTAog6a0R76 >									
364 	//        <  u =="0.000000000000000001" : ] 000000508803657.272489000000000000 ; 000000522776833.424361000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000003085F6E31DB1B3 >									
366 	//     < CHEMCHINA_PFII_I_metadata_line_38_____Hangzhou_Best_Chemicals_Co__Limited_20220321 >									
367 	//        < 1g0Lb432a38PEdIil4y53bqEOd5mxnDYBg00HMd5ShHGrNR1Qo8SzIcDlhVD2pr8 >									
368 	//        <  u =="0.000000000000000001" : ] 000000522776833.424361000000000000 ; 000000535365127.354788000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000031DB1B3330E701 >									
370 	//     < CHEMCHINA_PFII_I_metadata_line_39_____Hangzhou_Dayangchem_Co__Limited_20220321 >									
371 	//        < A57DKeJHInpcIW2h9blUczsHwbtL1s1K0aMoLyUl9y2tP6o5WcNGgl09Y62I8mt4 >									
372 	//        <  u =="0.000000000000000001" : ] 000000535365127.354788000000000000 ; 000000549188184.000230000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000330E701345FEA2 >									
374 	//     < CHEMCHINA_PFII_I_metadata_line_40_____Hangzhou_Dayangchem_org_20220321 >									
375 	//        < 6Oi0nP6vKCbwofVexA33zQZJE7T7xu99cW9s9QoJqPHg93BQX95b1TllARuHDPC8 >									
376 	//        <  u =="0.000000000000000001" : ] 000000549188184.000230000000000000 ; 000000562437397.317196000000000000 ] >									
377 	//        < 0x00000000000000000000000000000000000000000000000000345FEA235A361C >									
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