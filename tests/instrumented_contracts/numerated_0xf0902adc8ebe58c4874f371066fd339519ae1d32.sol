1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	SHERE_PFIII_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	SHERE_PFIII_III_883		"	;
8 		string	public		symbol =	"	SHERE_PFIII_III_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1864492808887740000000000000					;	
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
92 	//     < SHERE_PFIII_III_metadata_line_1_____RUSSIAN_REINSURANCE_COMPANY_20260505 >									
93 	//        < suTWV88gAp9C1Cr8mrEt3W3L4f10872WP2E5b3BPHegZ5C582m3l0Bql8vg0091Q >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000034792693.530401300000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000003516E5 >									
96 	//     < SHERE_PFIII_III_metadata_line_2_____ERGO_20260505 >									
97 	//        < VFYRg6aegk0Xbl61cf90FKKfRBcahL6aB0pJaNUDOBBClBJ71v8l6F0RQk4d3uS8 >									
98 	//        <  u =="0.000000000000000001" : ] 000000034792693.530401300000000000 ; 000000066403107.295402300000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000003516E56552B7 >									
100 	//     < SHERE_PFIII_III_metadata_line_3_____AIG_20260505 >									
101 	//        < M517R0O0155CGIJm7QDjvZSJLi7eN2j15PrhIv0d1B8b9LsAj920b6za4Ne8sf4E >									
102 	//        <  u =="0.000000000000000001" : ] 000000066403107.295402300000000000 ; 000000085124999.806035800000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000006552B781E3F4 >									
104 	//     < SHERE_PFIII_III_metadata_line_4_____MARSH_MCLENNAN_RISK_CAPITAL_HOLDINGS_20260505 >									
105 	//        < bJ4l6F9X63h9p7v0sgI3RK6hyz92oUtyX93o3x6LSiDU55A7dCTMl0dzRYiPZlXy >									
106 	//        <  u =="0.000000000000000001" : ] 000000085124999.806035800000000000 ; 000000124979643.436818000000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000081E3F4BEB42C >									
108 	//     < SHERE_PFIII_III_metadata_line_5_____RUSSIAN_NATIONAL_REINSURANCE_COMPANY_RNRC_20260505 >									
109 	//        < bOVFO2Zgu29MGSPU7S077K952r6lZ7FO0DYKfi385uALLO5UO7H5v4NL8dvNH01I >									
110 	//        <  u =="0.000000000000000001" : ] 000000124979643.436818000000000000 ; 000000165313628.063531000000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000BEB42CFC3FA3 >									
112 	//     < SHERE_PFIII_III_metadata_line_6_____ALFASTRAKHOVANIE_GROUP_20260505 >									
113 	//        < ClDL3X40pZ5uFUMUYTgR7IrG7BX6r8a3qkV5W51SgFtP3ih38121276evw7f17oz >									
114 	//        <  u =="0.000000000000000001" : ] 000000165313628.063531000000000000 ; 000000196535347.224430000000000000 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000000000FC3FA312BE39F >									
116 	//     < SHERE_PFIII_III_metadata_line_7_____ALFA_GROUP_20260505 >									
117 	//        < 61Vo5Zt8Y5UsMZ94qg19u4MI2qbudIQ5CdpxSTCjD3X2cXGHpP1VyE5uSNf838Wu >									
118 	//        <  u =="0.000000000000000001" : ] 000000196535347.224430000000000000 ; 000000262255082.202745000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000012BE39F1902B64 >									
120 	//     < SHERE_PFIII_III_metadata_line_8_____INGOSSTRAKH_20260505 >									
121 	//        < 0dpj32p6PEt7TL5B6hR80lnTMpj42DfQ4p2C4qNloZ8AJf72TM0F4TR57Nb5MLGx >									
122 	//        <  u =="0.000000000000000001" : ] 000000262255082.202745000000000000 ; 000000342923441.108905000000000000 ] >									
123 	//        < 0x000000000000000000000000000000000000000000000000001902B6420B4278 >									
124 	//     < SHERE_PFIII_III_metadata_line_9_____ROSGOSSTRAKH_INSURANCE_COMPANY_20260505 >									
125 	//        < K3FMiC14bg4EOeEH1xk2m5Us5m0k5K3r9bGxyWn1KKvxbjf1nO5743BzM5UInL0G >									
126 	//        <  u =="0.000000000000000001" : ] 000000342923441.108905000000000000 ; 000000368938491.900234000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000020B4278232F499 >									
128 	//     < SHERE_PFIII_III_metadata_line_10_____SCOR_SE_20260505 >									
129 	//        < eNa30p12yW6PI4gxvYW89925xe93kUKwpn6S659HS5fn5NgRJ6g6ci6GRHiFSDYX >									
130 	//        <  u =="0.000000000000000001" : ] 000000368938491.900234000000000000 ; 000000415900595.159996000000000000 ] >									
131 	//        < 0x00000000000000000000000000000000000000000000000000232F49927A9D2C >									
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
174 	//     < SHERE_PFIII_III_metadata_line_11_____HANNOVERRE_20260505 >									
175 	//        < 3VVnVCajIqm46AFEz9H757Z0X4CwnGqBKdC380a4h35rn87fkZo59SSST60p1m0z >									
176 	//        <  u =="0.000000000000000001" : ] 000000415900595.159996000000000000 ; 000000474164209.690885000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000027A9D2C2D38465 >									
178 	//     < SHERE_PFIII_III_metadata_line_12_____SWISS_RE_20260505 >									
179 	//        < U9KH13KEMz749GLs599nXMJTiAbP1HwDmnvGiBVW21Ltnx6CGD9Q2xEyoo7w167w >									
180 	//        <  u =="0.000000000000000001" : ] 000000474164209.690885000000000000 ; 000000569174984.796105000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000002D384653647DFA >									
182 	//     < SHERE_PFIII_III_metadata_line_13_____MUNICH_RE_20260505 >									
183 	//        < 17kG1s4O4M91ZOBLsTF8NpWkr0Y9w581Gh48gh7jiaG365B0HGstn7APfD8ft7kD >									
184 	//        <  u =="0.000000000000000001" : ] 000000569174984.796105000000000000 ; 000000605772004.738011000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000003647DFA39C55B0 >									
186 	//     < SHERE_PFIII_III_metadata_line_14_____GEN_RE_20260505 >									
187 	//        < p6pP08GN9hDqL6o68QxNOUt5DHBwW22zMI20V4i81TdK465Fz1LcwL5A37Btb713 >									
188 	//        <  u =="0.000000000000000001" : ] 000000605772004.738011000000000000 ; 000000690161753.629153000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000039C55B041D1A6F >									
190 	//     < SHERE_PFIII_III_metadata_line_15_____PARTNER_RE_20260505 >									
191 	//        < k90BlT73aR6wPIg1nN6S8eKm9JJM8yGZTz6dNF1K4qgZ9BCIOddHoar9o0Fpuokh >									
192 	//        <  u =="0.000000000000000001" : ] 000000690161753.629153000000000000 ; 000000776693006.516563000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000041D1A6F4A123B5 >									
194 	//     < SHERE_PFIII_III_metadata_line_16_____EXOR_20260505 >									
195 	//        < 0TfQyGnSRoG3VrFsTL9BobvOG0DAo7978ZN8i06SS603Qdet0wnHKt1M37Ingr0l >									
196 	//        <  u =="0.000000000000000001" : ] 000000776693006.516563000000000000 ; 000000797154869.979194000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000004A123B54C05C9F >									
198 	//     < SHERE_PFIII_III_metadata_line_17_____XL_CATLIN_RE_20260505 >									
199 	//        < Naxd8wzG44oiG7inQ1QWzA7M7AFWf70iQNGBc28464opyAy1DW111V9b8070Bvoa >									
200 	//        <  u =="0.000000000000000001" : ] 000000797154869.979194000000000000 ; 000000819224801.744156000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000004C05C9F4E209B0 >									
202 	//     < SHERE_PFIII_III_metadata_line_18_____SOGAZ_20260505 >									
203 	//        < o39ILlyPf7VPQE9h0hMVzBxJcoY901XFV9q63Y1lZAXpGT2x03t7NDZJIbkjo62S >									
204 	//        <  u =="0.000000000000000001" : ] 000000819224801.744156000000000000 ; 000000862529165.151709000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000004E209B05241D75 >									
206 	//     < SHERE_PFIII_III_metadata_line_19_____GAZPROM_20260505 >									
207 	//        < k71b2uGH42UMz248liRW1ZCxDhHSeHJ5VXn4dmq3Cdj9127bqGg3hgZ63Mme2xE6 >									
208 	//        <  u =="0.000000000000000001" : ] 000000862529165.151709000000000000 ; 000000934083026.375017000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000005241D755914C2F >									
210 	//     < SHERE_PFIII_III_metadata_line_20_____VTB INSURANCE_20260505 >									
211 	//        < Q8V7u6NM4O6HDWD28F41j5rdp1lX1IoMO2414k5U5S4p2q3VLK958biggvS9L4dd >									
212 	//        <  u =="0.000000000000000001" : ] 000000934083026.375017000000000000 ; 000000971857619.428674000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000005914C2F5CAEFE2 >									
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
256 	//     < SHERE_PFIII_III_metadata_line_21_____WILLIS_LIMITED_20260505 >									
257 	//        < EP6f810bftWdXC7wsS5C855ymE8TMZ3jenV76qoL3V0g7x552y7971M9Auua8403 >									
258 	//        <  u =="0.000000000000000001" : ] 000000971857619.428674000000000000 ; 000001046553096.531410000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000005CAEFE263CE9CE >									
260 	//     < SHERE_PFIII_III_metadata_line_22_____GUY_CARPENTER_LIMITED_20260505 >									
261 	//        < GK0JXy7Gf43S84S7PA470v2lkQy6hbr74Jf34dRn63YkOvq00ENhmlrtmM9l6Y5g >									
262 	//        <  u =="0.000000000000000001" : ] 000001046553096.531410000000000000 ; 000001120679803.152390000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000063CE9CE6AE058C >									
264 	//     < SHERE_PFIII_III_metadata_line_23_____AON_BENFIELD_20260505 >									
265 	//        < MY4814XIgBAg5uGlVTC3vpQUtq3hRJCZQ7KZLlBEHaA14b3E5sk76S6596S11mmS >									
266 	//        <  u =="0.000000000000000001" : ] 000001120679803.152390000000000000 ; 000001170592011.665610000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000006AE058C6FA2E81 >									
268 	//     < SHERE_PFIII_III_metadata_line_24_____WILLIS_CIS_20260505 >									
269 	//        < jo9361kRUFN55hua6l2v03HCO40w8cJ31aPWI62y6dH4N734iN6pBIuN84re1ntZ >									
270 	//        <  u =="0.000000000000000001" : ] 000001170592011.665610000000000000 ; 000001196478129.659860000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000006FA2E81721AE45 >									
272 	//     < SHERE_PFIII_III_metadata_line_25_____POLISH_RE_20260505 >									
273 	//        < KEj4QC0BnyQdch0EMxh3l9WY3H6LbU3WI8qqkvqZyj35mS8yCq0q89ELKJ71T81M >									
274 	//        <  u =="0.000000000000000001" : ] 000001196478129.659860000000000000 ; 000001224547634.562210000000000000 ] >									
275 	//        < 0x00000000000000000000000000000000000000000000000000721AE4574C82EB >									
276 	//     < SHERE_PFIII_III_metadata_line_26_____TRUST_RE_20260505 >									
277 	//        < 57GSG6wdViYR2hTv9igL2qSus82mYcY4J1Ko70XSmL52WZXcpejSTvBrJ9g6xo54 >									
278 	//        <  u =="0.000000000000000001" : ] 000001224547634.562210000000000000 ; 000001262867683.340990000000000000 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000000000074C82EB786FBB0 >									
280 	//     < SHERE_PFIII_III_metadata_line_27_____MALAKUT_20260505 >									
281 	//        < EwFi2PrYZkOA979NeiA99K3C64B8hVQdYCCsqh2SUxBygmWJvDb3R3Ub115JFgno >									
282 	//        <  u =="0.000000000000000001" : ] 000001262867683.340990000000000000 ; 000001339956833.601970000000000000 ] >									
283 	//        < 0x00000000000000000000000000000000000000000000000000786FBB07FC9CA3 >									
284 	//     < SHERE_PFIII_III_metadata_line_28_____SCOR_RUS_20260505 >									
285 	//        < Sohh8mj4UA84O3p4NXRBsI0BDzg1ydl9COc4lyl4Ob3a19cxKt3O5963XE0UTH5i >									
286 	//        <  u =="0.000000000000000001" : ] 000001339956833.601970000000000000 ; 000001362951028.715200000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000007FC9CA381FB2BF >									
288 	//     < SHERE_PFIII_III_metadata_line_29_____AFM_20260505 >									
289 	//        < tQj45C4UkzP9YsGXMRQjwU2w9CU1k04gsh4892016yBjwX0Y2DKyD7Jx7GFqthbg >									
290 	//        <  u =="0.000000000000000001" : ] 000001362951028.715200000000000000 ; 000001386195978.140200000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000081FB2BF8432ACE >									
292 	//     < SHERE_PFIII_III_metadata_line_30_____SBERBANK_INSURANCE_20260505 >									
293 	//        < a48lIe3AP4NoEZ4648712Vr691cmD077l19Bk948gtadSeK26W90i4QAvyLAKPrT >									
294 	//        <  u =="0.000000000000000001" : ] 000001386195978.140200000000000000 ; 000001412246636.827920000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000008432ACE86AEAD8 >									
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
338 	//     < SHERE_PFIII_III_metadata_line_31_____Societe_Financiere_Sberbank_20260505 >									
339 	//        < pG00dNNGe8UaRnHD25X51yb8620CpwAKR7BZd45wWU8t2WO55nVrdXJHboEIgGy3 >									
340 	//        <  u =="0.000000000000000001" : ] 000001412246636.827920000000000000 ; 000001454922615.849970000000000000 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000000000086AEAD88AC0926 >									
342 	//     < SHERE_PFIII_III_metadata_line_32_____ENERGOGARANT_20260505 >									
343 	//        < 5711VqgH9T173GZKJTm6677lUlF90fq9LY193wp7XZCl57b6S6y0q3sOX9K375TY >									
344 	//        <  u =="0.000000000000000001" : ] 000001454922615.849970000000000000 ; 000001482952723.963110000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000008AC09268D6CE68 >									
346 	//     < SHERE_PFIII_III_metadata_line_33_____RSHB_INSURANCE_20260505 >									
347 	//        < 5P885033X2u83gG563a56J0Ftn6KLvmr90G74y0pnNDyB3j59x250lANtGdF8Xtu >									
348 	//        <  u =="0.000000000000000001" : ] 000001482952723.963110000000000000 ; 000001514912430.002090000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000008D6CE6890792AB >									
350 	//     < SHERE_PFIII_III_metadata_line_34_____EURASIA_20260505 >									
351 	//        < 4aXT86TYG1nh6GIzAv6B3Y7DC7OSJ8q4QuszsLzmN1X12258qph3GbCwodBuUR3T >									
352 	//        <  u =="0.000000000000000001" : ] 000001514912430.002090000000000000 ; 000001591074426.058400000000000000 ] >									
353 	//        < 0x0000000000000000000000000000000000000000000000000090792AB97BC973 >									
354 	//     < SHERE_PFIII_III_metadata_line_35_____BELARUS_RE_20260505 >									
355 	//        < LJPfD6k46K6TU3si19cA6p73rVD60ECYCR34rMX1xokq8187NDe82Drc3VXt9664 >									
356 	//        <  u =="0.000000000000000001" : ] 000001591074426.058400000000000000 ; 000001647729743.902010000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000097BC9739D23C6E >									
358 	//     < SHERE_PFIII_III_metadata_line_36_____RT_INSURANCE_20260505 >									
359 	//        < 1Sf0c0H6YowTLZlVZi6IySI6mumUkQw02w755vnV32nwE95xbr55v2YiopKkm2Pm >									
360 	//        <  u =="0.000000000000000001" : ] 000001647729743.902010000000000000 ; 000001670189099.257330000000000000 ] >									
361 	//        < 0x000000000000000000000000000000000000000000000000009D23C6E9F4819E >									
362 	//     < SHERE_PFIII_III_metadata_line_37_____ASPEN_20260505 >									
363 	//        < GlacQ2Ssr7IWffecc82vkArR6nvDlTze58N0R7o4E7Z4k8JMXc79hkeJc5v10xms >									
364 	//        <  u =="0.000000000000000001" : ] 000001670189099.257330000000000000 ; 000001738523625.581440000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000009F4819EA5CC6CB >									
366 	//     < SHERE_PFIII_III_metadata_line_38_____LOL_I_20260505 >									
367 	//        < 1P820Y5z63y2hy9VOD2r8Vb6YcI8VSiaEu89PaJ54P7rPrPhlpT1LM48tQGDBNK4 >									
368 	//        <  u =="0.000000000000000001" : ] 000001738523625.581440000000000000 ; 000001817890294.844600000000000000 ] >									
369 	//        < 0x00000000000000000000000000000000000000000000000000A5CC6CBAD5E165 >									
370 	//     < SHERE_PFIII_III_metadata_line_39_____LOL_4472_20260505 >									
371 	//        < XFjev26fuf2aeoS28n4EA9Y5v959bMp3B5jJgHgEnuhQzs7VY449TTdU43846lEC >									
372 	//        <  u =="0.000000000000000001" : ] 000001817890294.844600000000000000 ; 000001839875785.662510000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000AD5E165AF76D7B >									
374 	//     < SHERE_PFIII_III_metadata_line_40_____LOL_1183_20260505 >									
375 	//        < J84Y0NhqCHBB9yp2u35c5NJCMx7c61YLh12BadtC6Kz1y6a3mDewo7SxY7u26w3x >									
376 	//        <  u =="0.000000000000000001" : ] 000001839875785.662510000000000000 ; 000001864492808.887740000000000000 ] >									
377 	//        < 0x00000000000000000000000000000000000000000000000000AF76D7BB1CFD81 >									
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