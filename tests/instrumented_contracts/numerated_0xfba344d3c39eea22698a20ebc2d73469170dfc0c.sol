1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXXIV_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXXIV_I_883		"	;
8 		string	public		symbol =	"	RUSS_PFXXIV_I_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		602962850898693000000000000					;	
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
92 	//     < RUSS_PFXXIV_I_metadata_line_1_____ALFASTRAKHOVANIE_20211101 >									
93 	//        < 65DnH0JZYwX04kagQo12O4sjzNH44X9I1C5E621HWPsAmWq19TX36ax46CEpT4KL >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000013034440.462311200000000000 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000000013E394 >									
96 	//     < RUSS_PFXXIV_I_metadata_line_2_____ALFA_DAO_20211101 >									
97 	//        < 9wKLVVjB6m9PckvOxXh2tJulS2CwcZ5nRd2XX55vFH11HBcPydGy6Bw221NIztEg >									
98 	//        <  u =="0.000000000000000001" : ] 000000013034440.462311200000000000 ; 000000029081361.676530300000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000013E3942C5FE8 >									
100 	//     < RUSS_PFXXIV_I_metadata_line_3_____ALFA_DAOPI_20211101 >									
101 	//        < z3f8R7CEfYNxx5A9d4V6M7G8URX80f0UVRU8t7Vuzi322m8fn8Kjo5Fm29lR1CvU >									
102 	//        <  u =="0.000000000000000001" : ] 000000029081361.676530300000000000 ; 000000042676461.126178900000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000002C5FE8411E7E >									
104 	//     < RUSS_PFXXIV_I_metadata_line_4_____ALFA_DAC_20211101 >									
105 	//        < kef610h3CIFYZtUrdEYYPWH8jq70ncaFP2iZ05dTdH7I6Gx5SAVs5VihU6LuLfc9 >									
106 	//        <  u =="0.000000000000000001" : ] 000000042676461.126178900000000000 ; 000000059816115.779936300000000000 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000000000411E7E5B45AC >									
108 	//     < RUSS_PFXXIV_I_metadata_line_5_____ALFA_BIMI_20211101 >									
109 	//        < 8K8A5vCjscTtbbK4Kpa918W1qGbtV7IDVQ5B5DyRfw4v766N7Ms0kf6kr26jQ6qT >									
110 	//        <  u =="0.000000000000000001" : ] 000000059816115.779936300000000000 ; 000000073500958.244521300000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000005B45AC702750 >									
112 	//     < RUSS_PFXXIV_I_metadata_line_6_____SMO_SIBERIA_20211101 >									
113 	//        < Ehlr342oR0u38x5hbVTvrya8xmnN7SQ5qKb19AwNSmFRjr071f268B0QgVF9fxlz >									
114 	//        <  u =="0.000000000000000001" : ] 000000073500958.244521300000000000 ; 000000089208489.314662600000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000702750881F11 >									
116 	//     < RUSS_PFXXIV_I_metadata_line_7_____SIBERIA_DAO_20211101 >									
117 	//        < ge5d6IrcEVoA9inQYaG3H1V4Rz9T32GrgzNaElZFawmdMLFCsvu99XYnU8G2q7E7 >									
118 	//        <  u =="0.000000000000000001" : ] 000000089208489.314662600000000000 ; 000000103065519.883285000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000881F119D43F8 >									
120 	//     < RUSS_PFXXIV_I_metadata_line_8_____SIBERIA_DAOPI_20211101 >									
121 	//        < 1Ke7cGI9FkCs33mD4Y7TPV6p0P57cl1NWe8Ik77JOxB3S7674H7Lo2nIPC4GmbX1 >									
122 	//        <  u =="0.000000000000000001" : ] 000000103065519.883285000000000000 ; 000000119410829.685312000000000000 ] >									
123 	//        < 0x00000000000000000000000000000000000000000000000000009D43F8B634DB >									
124 	//     < RUSS_PFXXIV_I_metadata_line_9_____SIBERIA_DAC_20211101 >									
125 	//        < 8Vq8AF8w3HPKLo3wov5h0MXe8m5D9X6s38f4L1WKq7wcK53kGLl07Ob2C442A7s7 >									
126 	//        <  u =="0.000000000000000001" : ] 000000119410829.685312000000000000 ; 000000133898192.642355000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000000B634DBCC4FFB >									
128 	//     < RUSS_PFXXIV_I_metadata_line_10_____SIBERIA_BIMI_20211101 >									
129 	//        < xMesnaJn20xrWZ0RL6sX81wGQTbAi4960Ikwlx7RkeWBHo4Nb02dn8eZu1hHn6hN >									
130 	//        <  u =="0.000000000000000001" : ] 000000133898192.642355000000000000 ; 000000150601969.115201000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000000CC4FFBE5CCE5 >									
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
174 	//     < RUSS_PFXXIV_I_metadata_line_11_____ALFASTRAKHOVANIE_LIFE_20211101 >									
175 	//        < 2551QoIvRF5P5a45cKQ8Z7qG2n484fS863sACqiz2h6m9nclS2uNDZz3y5IXOPxO >									
176 	//        <  u =="0.000000000000000001" : ] 000000150601969.115201000000000000 ; 000000167170657.840152000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000000E5CCE5FF150A >									
178 	//     < RUSS_PFXXIV_I_metadata_line_12_____ALFA_LIFE_DAO_20211101 >									
179 	//        < 1ozQm8172nWzBe0b7Dhxn73CGPSgAz9827y8rDCI455nP055KbY1D5GAm64e9gtl >									
180 	//        <  u =="0.000000000000000001" : ] 000000167170657.840152000000000000 ; 000000183552038.398149000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000000FF150A1181404 >									
182 	//     < RUSS_PFXXIV_I_metadata_line_13_____ALFA_LIFE_DAOPI_20211101 >									
183 	//        < gp54rMRj7T42V594GI5BED9iYqX0gwYMf759LjZGqecj7K4Nwy9vBHBI970iGO80 >									
184 	//        <  u =="0.000000000000000001" : ] 000000183552038.398149000000000000 ; 000000200740452.090834000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000011814041324E3D >									
186 	//     < RUSS_PFXXIV_I_metadata_line_14_____ALFA_LIFE_DAC_20211101 >									
187 	//        < w2eoB6ClnX76MNfrfe4K4p805v229Tt7AN4DO5bPwNuXJ3aBD630kGqy4hr7wv42 >									
188 	//        <  u =="0.000000000000000001" : ] 000000200740452.090834000000000000 ; 000000215636520.844841000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000001324E3D1490904 >									
190 	//     < RUSS_PFXXIV_I_metadata_line_15_____ALFA_LIFE_BIMI_20211101 >									
191 	//        < 4cdXcj6o0bz3Ck8X0qK2j54oS7ys6121jB2Jq1mN493a0jdsFwrIeU5fLbFtdP6V >									
192 	//        <  u =="0.000000000000000001" : ] 000000215636520.844841000000000000 ; 000000229813556.919532000000000000 ] >									
193 	//        < 0x00000000000000000000000000000000000000000000000000149090415EAAEC >									
194 	//     < RUSS_PFXXIV_I_metadata_line_16_____ALFASTRAKHOVANIE_AVERS_20211101 >									
195 	//        < BAnp492kNll67z3264w6OiR363824154g99Q5KqE18G72mc889jopqwb2D7020l4 >									
196 	//        <  u =="0.000000000000000001" : ] 000000229813556.919532000000000000 ; 000000243361497.118260000000000000 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000000015EAAEC1735716 >									
198 	//     < RUSS_PFXXIV_I_metadata_line_17_____AVERS_DAO_20211101 >									
199 	//        < dbDKeH7yNw59BDVAw13nrZm84rIPpXxYnlAe2u00hfwvQT07c6BE3go1BrGZ8lDC >									
200 	//        <  u =="0.000000000000000001" : ] 000000243361497.118260000000000000 ; 000000257843873.456695000000000000 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000000017357161897043 >									
202 	//     < RUSS_PFXXIV_I_metadata_line_18_____AVERS_DAOPI_20211101 >									
203 	//        < 6WV518FDI5nIz9NBj6yV2mq69w05PJN6pbLdN22H3PJBq3kosWrfuetUKc0Fqels >									
204 	//        <  u =="0.000000000000000001" : ] 000000257843873.456695000000000000 ; 000000273011336.979626000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000018970431A0950E >									
206 	//     < RUSS_PFXXIV_I_metadata_line_19_____AVERS_DAC_20211101 >									
207 	//        < FmoZsihesmsv9Hd777ZTr7378IZ70D61D9RX6wp15tRptA75sWc464Pe2NVs7l8E >									
208 	//        <  u =="0.000000000000000001" : ] 000000273011336.979626000000000000 ; 000000288722774.998712000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000001A0950E1B88E55 >									
210 	//     < RUSS_PFXXIV_I_metadata_line_20_____AVERS_BIMI_20211101 >									
211 	//        < plLIQ2Qe36KyA08nQ2r3K468G7FK7OG6f3x93U4Ot37DBcI9ZmO6w5VWNn2DTLfY >									
212 	//        <  u =="0.000000000000000001" : ] 000000288722774.998712000000000000 ; 000000303765027.183276000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000001B88E551CF8237 >									
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
256 	//     < RUSS_PFXXIV_I_metadata_line_21_____ALFASTRAKHOVANIE_PLC_20211101 >									
257 	//        < l55bgRjph6c290RHf1aTk31NT974v140dkhs01ahZe4S4noIQ9gY3mcv798MV5Q8 >									
258 	//        <  u =="0.000000000000000001" : ] 000000303765027.183276000000000000 ; 000000317476567.255760000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000001CF82371E46E49 >									
260 	//     < RUSS_PFXXIV_I_metadata_line_22_____ALFASTRA_DAO_20211101 >									
261 	//        < yD2457Nx9u8zy52JS2pzLrt373y84t4t5hN4Dv86hwIa63RGYbUDzI4mvr37kJVv >									
262 	//        <  u =="0.000000000000000001" : ] 000000317476567.255760000000000000 ; 000000333368184.211595000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000001E46E491FCADF2 >									
264 	//     < RUSS_PFXXIV_I_metadata_line_23_____ALFASTRA_DAOPI_20211101 >									
265 	//        < SoKNtXWx8qh2oD2TFXH5y1ycu2Y6N5662mY7lbZyV9bKtXlsob2Rxzfxmi9ALhb6 >									
266 	//        <  u =="0.000000000000000001" : ] 000000333368184.211595000000000000 ; 000000346572176.142804000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000001FCADF2210D3C2 >									
268 	//     < RUSS_PFXXIV_I_metadata_line_24_____ALFASTRA_DAC_20211101 >									
269 	//        < 7221H0fNjT6c1SD5M00nLKNrfhV6s7NsDJ35B8Uy0tBP52kDM5oouh9wlR27hGEe >									
270 	//        <  u =="0.000000000000000001" : ] 000000346572176.142804000000000000 ; 000000362650904.224566000000000000 ] >									
271 	//        < 0x00000000000000000000000000000000000000000000000000210D3C22295C82 >									
272 	//     < RUSS_PFXXIV_I_metadata_line_25_____ALFASTRA_BIMI_20211101 >									
273 	//        < NkI4mHAUOGylK0J96zNtzIqVgaf6fbVjgbqnHn3G3FW0z3FvvWgWs66N0JaQ2t1b >									
274 	//        <  u =="0.000000000000000001" : ] 000000362650904.224566000000000000 ; 000000377913645.041203000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002295C82240A685 >									
276 	//     < RUSS_PFXXIV_I_metadata_line_26_____MEDITSINSKAYA_STRAKHOVAYA_KOMP_VIRMED_20211101 >									
277 	//        < ic9OrmEUVc9PRXmm7Vu7Yg330zHE4B0qNf75G94OSV702md4W4YwVQZb26ttVsjB >									
278 	//        <  u =="0.000000000000000001" : ] 000000377913645.041203000000000000 ; 000000393769964.264045000000000000 ] >									
279 	//        < 0x00000000000000000000000000000000000000000000000000240A685258D864 >									
280 	//     < RUSS_PFXXIV_I_metadata_line_27_____VIRMED_DAO_20211101 >									
281 	//        < 8vN37b15r806bF9k9ke2BR4KRZWqT3g5knR2G8Yw1irkWPV6z10kHwxvFbw76z2J >									
282 	//        <  u =="0.000000000000000001" : ] 000000393769964.264045000000000000 ; 000000408970249.190063000000000000 ] >									
283 	//        < 0x00000000000000000000000000000000000000000000000000258D8642700A01 >									
284 	//     < RUSS_PFXXIV_I_metadata_line_28_____VIRMED_DAOPI_20211101 >									
285 	//        < zDr0CSyFuyRlSuZfB9bGdpM40M5m0F6fQ4FbhTA25w97tAu0v3KOEmPj6d5ox7QO >									
286 	//        <  u =="0.000000000000000001" : ] 000000408970249.190063000000000000 ; 000000422761194.206975000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000002700A012851517 >									
288 	//     < RUSS_PFXXIV_I_metadata_line_29_____VIRMED_DAC_20211101 >									
289 	//        < 6z5ogvh81l5n3jf71amWwcPhBjU5pRkLm4lqT3uRe5D1T9Tone5X50QS7bxzn55e >									
290 	//        <  u =="0.000000000000000001" : ] 000000422761194.206975000000000000 ; 000000439174806.061093000000000000 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000000000285151729E20A9 >									
292 	//     < RUSS_PFXXIV_I_metadata_line_30_____VIRMED_BIMI_20211101 >									
293 	//        < 41410OV1i1ZQQKVuSO909POreXG70sx6N886GlfRzKjcAmLs870G1yolHWdFx71r >									
294 	//        <  u =="0.000000000000000001" : ] 000000439174806.061093000000000000 ; 000000455470868.942964000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000029E20A92B6FE4F >									
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
338 	//     < RUSS_PFXXIV_I_metadata_line_31_____MSK_ASSTRA_20211101 >									
339 	//        < 6NDUH8ti941A0lvS6bK5s1pEUoneW9796aluHs9yC0vbqy4H02V25969bn571dQE >									
340 	//        <  u =="0.000000000000000001" : ] 000000455470868.942964000000000000 ; 000000469653724.863797000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000002B6FE4F2CCA27C >									
342 	//     < RUSS_PFXXIV_I_metadata_line_32_____ASSTRA_DAO_20211101 >									
343 	//        < SJ3Qt3lV91ntBS9jDNy8230iZd397PyJUuMrPzHb6vv1smTM7WZ7LM7S0p3Q87m9 >									
344 	//        <  u =="0.000000000000000001" : ] 000000469653724.863797000000000000 ; 000000483407322.518188000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000002CCA27C2E19EFC >									
346 	//     < RUSS_PFXXIV_I_metadata_line_33_____ASSTRA_DAOPI_20211101 >									
347 	//        < qJxaWS9X53yorT51nhM9k100StszlkbT0016nT16OxPYBp34F1b10Cjh29t550Ag >									
348 	//        <  u =="0.000000000000000001" : ] 000000483407322.518188000000000000 ; 000000498849197.636243000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000002E19EFC2F92EF8 >									
350 	//     < RUSS_PFXXIV_I_metadata_line_34_____ASSTRA_DAC_20211101 >									
351 	//        < 2QT6I4902Z69UFW4hDdT389K5HHXT4ai9704xcIc8K3u25no6Z0Rr5k56s5US2zg >									
352 	//        <  u =="0.000000000000000001" : ] 000000498849197.636243000000000000 ; 000000513413684.694068000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000002F92EF830F6838 >									
354 	//     < RUSS_PFXXIV_I_metadata_line_35_____ASSTRA_BIMI_20211101 >									
355 	//        < r3085uVHEcTVm7g4lLKA1O99bZSKucCSo7hpE6aWBYhA8siOv8DnLoj0mQK6Xv2D >									
356 	//        <  u =="0.000000000000000001" : ] 000000513413684.694068000000000000 ; 000000527403447.000477000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000030F6838324C0F9 >									
358 	//     < RUSS_PFXXIV_I_metadata_line_36_____AVICOS_AFES_INSURANCE_GROUP_20211101 >									
359 	//        < uQLX5rzJxxQsNbHEc5wLNGenV1OB86L254SgVyTfUjM5g4eh4DQDfs3WU7lOsheA >									
360 	//        <  u =="0.000000000000000001" : ] 000000527403447.000477000000000000 ; 000000542594705.051985000000000000 ] >									
361 	//        < 0x00000000000000000000000000000000000000000000000000324C0F933BEF0F >									
362 	//     < RUSS_PFXXIV_I_metadata_line_37_____AVICOS_DAO_20211101 >									
363 	//        < z9280qOX8rJPFXB61Mn8Y70H94qJf7k0WS3PzI57K6Ql52QZfFHG0rYqq7LY0h3z >									
364 	//        <  u =="0.000000000000000001" : ] 000000542594705.051985000000000000 ; 000000556903324.634384000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000033BEF0F351C45C >									
366 	//     < RUSS_PFXXIV_I_metadata_line_38_____AVICOS_DAOPI_20211101 >									
367 	//        < n2Gv4OrR31bc1c95TAc0456Lwkv2X2cpCHcNehfG9956WDwc4THzwbeLhZVPlAl3 >									
368 	//        <  u =="0.000000000000000001" : ] 000000556903324.634384000000000000 ; 000000570555564.417809000000000000 ] >									
369 	//        < 0x00000000000000000000000000000000000000000000000000351C45C3669944 >									
370 	//     < RUSS_PFXXIV_I_metadata_line_39_____AVICOS_DAC_20211101 >									
371 	//        < lMl32Kej6M4bCN5h4ja5paSrsLIGKuhyp7k0N8nNGVqZ1Wj61C1zsb1DM8bPEb5f >									
372 	//        <  u =="0.000000000000000001" : ] 000000570555564.417809000000000000 ; 000000587283592.942734000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000036699443801FA7 >									
374 	//     < RUSS_PFXXIV_I_metadata_line_40_____AVICOS_BIMI_20211101 >									
375 	//        < 5I85TWE81B7WNrto4A810lpjM9k7jb6Qk6OJw5xMDH0nG81Jt89q4983EGlHwBpm >									
376 	//        <  u =="0.000000000000000001" : ] 000000587283592.942734000000000000 ; 000000602962850.898693000000000000 ] >									
377 	//        < 0x000000000000000000000000000000000000000000000000003801FA73980C5D >									
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