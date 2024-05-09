1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFVII_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFVII_III_883		"	;
8 		string	public		symbol =	"	RUSS_PFVII_III_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1042339756120710000000000000					;	
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
92 	//     < RUSS_PFVII_III_metadata_line_1_____NOVATEK_20251101 >									
93 	//        < fGF48l6848Z3WQE570rlTwt3Fc8OWQAG315f7642qFX290wfrpKfJKrlBwSk3Xeg >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000027797374.378013300000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000002A6A59 >									
96 	//     < RUSS_PFVII_III_metadata_line_2_____NORTHGAS_20251101 >									
97 	//        < yza0F321txmDnAdZwjK2RsOMLAbdLhKMNqvc3GM9D8qmJXD5H0UFTzmGyp6hM2NU >									
98 	//        <  u =="0.000000000000000001" : ] 000000027797374.378013300000000000 ; 000000053286667.403940600000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000002A6A59514F1B >									
100 	//     < RUSS_PFVII_III_metadata_line_3_____SEVERENERGIA_20251101 >									
101 	//        < qAhfkM9312m3g3Eb2Rwmo4gL4J604dW0wPd2khZrl5LuI6SQK2STZNfnoSkctJk6 >									
102 	//        <  u =="0.000000000000000001" : ] 000000053286667.403940600000000000 ; 000000078145087.111599400000000000 ] >									
103 	//        < 0x0000000000000000000000000000000000000000000000000000514F1B773D6D >									
104 	//     < RUSS_PFVII_III_metadata_line_4_____NOVATEK_ARCTIC_LNG_1_20251101 >									
105 	//        < 0D4ScAa9yh3359VALh4kjKFpp7sPm5KQCV1Ur19vf4mC5zMGbeOST4tNzcsrr138 >									
106 	//        <  u =="0.000000000000000001" : ] 000000078145087.111599400000000000 ; 000000097180118.369757600000000000 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000000000773D6D9448FC >									
108 	//     < RUSS_PFVII_III_metadata_line_5_____NOVATEK_YURKHAROVNEFTEGAS_20251101 >									
109 	//        < I9aAZDlt379KKO0gk3q04A9mKu13vfde2jpKRfsH4wN20f1GBOOOqntR73Mn92F3 >									
110 	//        <  u =="0.000000000000000001" : ] 000000097180118.369757600000000000 ; 000000127745795.079815000000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000009448FCC2ECB4 >									
112 	//     < RUSS_PFVII_III_metadata_line_6_____NOVATEK_GAS_POWER_GMBH_20251101 >									
113 	//        < dq0RX4b20t0Bu2W0l95Q0IqvO3L7OjxcWaPZ3Et1Nfcjb2GFPt8nA5SU9rmKK94w >									
114 	//        <  u =="0.000000000000000001" : ] 000000127745795.079815000000000000 ; 000000147281722.920975000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000C2ECB4E0BBEC >									
116 	//     < RUSS_PFVII_III_metadata_line_7_____OOO_CHERNICHNOYE_20251101 >									
117 	//        < cYQ4FNe556r9V8MAO02ly56AwgZHU7inhAkY1m579LOD717yNQIUs18Y4aW75lY1 >									
118 	//        <  u =="0.000000000000000001" : ] 000000147281722.920975000000000000 ; 000000168472617.045064000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000000E0BBEC101119E >									
120 	//     < RUSS_PFVII_III_metadata_line_8_____OAO_TAMBEYNEFTEGAS_20251101 >									
121 	//        < eq3P0V97Vf63XA4WVO20v7TRMurjG9f3JoH6xpj220FqQsYM0gEZUl01VT61Ax4y >									
122 	//        <  u =="0.000000000000000001" : ] 000000168472617.045064000000000000 ; 000000198608803.671477000000000000 ] >									
123 	//        < 0x00000000000000000000000000000000000000000000000000101119E12F0D90 >									
124 	//     < RUSS_PFVII_III_metadata_line_9_____NOVATEK_TRANSERVICE_20251101 >									
125 	//        < z65WXDFG5IG9O8pyo6l7PL9rBrSn37zh80D8090UOEdmpUJI3ByE8p4nmAKJlyNe >									
126 	//        <  u =="0.000000000000000001" : ] 000000198608803.671477000000000000 ; 000000220163065.355302000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000012F0D9014FF133 >									
128 	//     < RUSS_PFVII_III_metadata_line_10_____NOVATEK_ARCTIC_LNG_2_20251101 >									
129 	//        < 6QhJ8BPxF952qd52WV4mYbbtqWrVxXFP6RinhXf3JXP7V7z6K2xSP854JA4PMrWK >									
130 	//        <  u =="0.000000000000000001" : ] 000000220163065.355302000000000000 ; 000000248430515.988876000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000014FF13317B132C >									
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
174 	//     < RUSS_PFVII_III_metadata_line_11_____YAMAL_LNG_20251101 >									
175 	//        < XUkN7zPR1437h1nolxdRjS6g27Gh150Vb44x09V2pDlR80Wr0Yn56AYoJY09pPB9 >									
176 	//        <  u =="0.000000000000000001" : ] 000000248430515.988876000000000000 ; 000000276681818.838527000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000017B132C1A62ED6 >									
178 	//     < RUSS_PFVII_III_metadata_line_12_____OOO_YARGEO_20251101 >									
179 	//        < EVDl0fLMVNQcz361S9KIjJU1XRbqwp9gE9k2B2G2GKnE3vf3dG0ucuI8HOEA5Z28 >									
180 	//        <  u =="0.000000000000000001" : ] 000000276681818.838527000000000000 ; 000000305298930.075339000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000001A62ED61D1D965 >									
182 	//     < RUSS_PFVII_III_metadata_line_13_____NOVATEK_ARCTIC_LNG_3_20251101 >									
183 	//        < qQBy9wdo6bWvIa9MmMEOsVT39N8vqM1B7yKSSM1YBlNFH54isfsxkC423l6PhV06 >									
184 	//        <  u =="0.000000000000000001" : ] 000000305298930.075339000000000000 ; 000000330176825.470609000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001D1D9651F7CF53 >									
186 	//     < RUSS_PFVII_III_metadata_line_14_____TERNEFTEGAZ_JSC_20251101 >									
187 	//        < m533D6tIJUn1YGyRz3ylRJN28Fj1rk2Bi4g5E2ELqr3wH3T0h534mL2X62QAY20P >									
188 	//        <  u =="0.000000000000000001" : ] 000000330176825.470609000000000000 ; 000000349150073.453018000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000001F7CF53214C2BF >									
190 	//     < RUSS_PFVII_III_metadata_line_15_____OOO_UNITEX_20251101 >									
191 	//        < gV1PTt06s0SO36gytbgsKD9jl5f3bPr4vHz0yPqmh87bg040Vy7J1ST6g2L0y98S >									
192 	//        <  u =="0.000000000000000001" : ] 000000349150073.453018000000000000 ; 000000378168725.347750000000000000 ] >									
193 	//        < 0x00000000000000000000000000000000000000000000000000214C2BF2410A29 >									
194 	//     < RUSS_PFVII_III_metadata_line_16_____NOVATEK_FINANCE_DESIGNATED_ACTIVITY_CO_20251101 >									
195 	//        < dx8y7EQV37co9v44A3ioqs29paQpi13h7m50dW8DnwlJH61UWT1Eb8DLx6OqDjP5 >									
196 	//        <  u =="0.000000000000000001" : ] 000000378168725.347750000000000000 ; 000000404491193.504295000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000002410A29269345F >									
198 	//     < RUSS_PFVII_III_metadata_line_17_____NOVATEK_EQUITY_CYPRUS_LIMITED_20251101 >									
199 	//        < 6CtjmJ4SJrNr6D1mSJBnEq1CfSZ2YcEMz15vXpDMu5FTql663e37325D1sWJ94m9 >									
200 	//        <  u =="0.000000000000000001" : ] 000000404491193.504295000000000000 ; 000000430186508.021036000000000000 ] >									
201 	//        < 0x00000000000000000000000000000000000000000000000000269345F290699B >									
202 	//     < RUSS_PFVII_III_metadata_line_18_____BLUE_GAZ_SP_ZOO_20251101 >									
203 	//        < 1b2om95JzzirBw4o0nr0nX36XezKs07Hhy5CIGo7S9z31cOTX6db2FCqRP7KXiKY >									
204 	//        <  u =="0.000000000000000001" : ] 000000430186508.021036000000000000 ; 000000463225378.679579000000000000 ] >									
205 	//        < 0x00000000000000000000000000000000000000000000000000290699B2C2D36A >									
206 	//     < RUSS_PFVII_III_metadata_line_19_____NOVATEK_OVERSEAS_AG_20251101 >									
207 	//        < xzRt9Uc7SsWLMj2W701XRX8wUUg3H9D9Srnc1tp2H8uwl02EN5Z4Qln9le60P023 >									
208 	//        <  u =="0.000000000000000001" : ] 000000463225378.679579000000000000 ; 000000482868768.702249000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000002C2D36A2E0CC9D >									
210 	//     < RUSS_PFVII_III_metadata_line_20_____NOVATEK_POLSKA_SP_ZOO_20251101 >									
211 	//        < jLevS5VcAc8q8Gjr42eaWkR0Ii555ofec7dSJ4F5Gz2J04CsGG9hw2GWH6kJsK03 >									
212 	//        <  u =="0.000000000000000001" : ] 000000482868768.702249000000000000 ; 000000509589859.196884000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000002E0CC9D309928A >									
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
256 	//     < RUSS_PFVII_III_metadata_line_21_____CRYOGAS_VYSOTSK_CJSC_20251101 >									
257 	//        < e79S089Zz5S8XFeLJVaWQ8sXbBC360Q36i108frIr4eYa5285hGd5g4Vcw22t7X7 >									
258 	//        <  u =="0.000000000000000001" : ] 000000509589859.196884000000000000 ; 000000536259291.921611000000000000 ] >									
259 	//        < 0x00000000000000000000000000000000000000000000000000309928A3324449 >									
260 	//     < RUSS_PFVII_III_metadata_line_22_____OOO_PETRA_INVEST_M_20251101 >									
261 	//        < peRFYIR776Ha8I1tVP3bBSMZFpjg5MOODt3QG8Z7V0XCXJ5v0qqPhHT6xrMDlfZ1 >									
262 	//        <  u =="0.000000000000000001" : ] 000000536259291.921611000000000000 ; 000000570891905.703597000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000033244493671CA7 >									
264 	//     < RUSS_PFVII_III_metadata_line_23_____ARCTICGAS_20251101 >									
265 	//        < gSQT3YFG0Xe0f26Oxehr9DZ6VQ8i9d2nN7y392rW0g0M3P0AlKJ7G6vo1Z33vPOO >									
266 	//        <  u =="0.000000000000000001" : ] 000000570891905.703597000000000000 ; 000000591276888.269572000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000003671CA73863789 >									
268 	//     < RUSS_PFVII_III_metadata_line_24_____YARSALENEFTEGAZ_LLC_20251101 >									
269 	//        < 2nFB7nFKzC6237k2TUmTjVemuM19960FtHuE8P40k29QaxDZ1d2WkcQsRmY4ntY1 >									
270 	//        <  u =="0.000000000000000001" : ] 000000591276888.269572000000000000 ; 000000611115266.417870000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000038637893A47CE7 >									
272 	//     < RUSS_PFVII_III_metadata_line_25_____NOVATEK_CHELYABINSK_20251101 >									
273 	//        < Z95qH8DBFU3oh2CWZd191NchPrI8R1HK40003Rc2vEX04w7eY9rumZ5pCvz9u2P8 >									
274 	//        <  u =="0.000000000000000001" : ] 000000611115266.417870000000000000 ; 000000642774109.533921000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000003A47CE73D4CBA3 >									
276 	//     < RUSS_PFVII_III_metadata_line_26_____EVROTEK_ZAO_20251101 >									
277 	//        < weM1LmFGKg9iu2WC2G4b6kNX2rcmC4kIh66Id6mD7384YuNy4027GSji8FQM1HM4 >									
278 	//        <  u =="0.000000000000000001" : ] 000000642774109.533921000000000000 ; 000000677033433.759728000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000003D4CBA3409122F >									
280 	//     < RUSS_PFVII_III_metadata_line_27_____OOO_NOVASIB_20251101 >									
281 	//        < B777vg56zszK7G9b6d8RhF11BHsw15GRG06ZEq0NA5vcKi1v7OQ8IOj87J7c2bI6 >									
282 	//        <  u =="0.000000000000000001" : ] 000000677033433.759728000000000000 ; 000000708254005.031884000000000000 ] >									
283 	//        < 0x00000000000000000000000000000000000000000000000000409122F438B5B9 >									
284 	//     < RUSS_PFVII_III_metadata_line_28_____NOVATEK_PERM_OOO_20251101 >									
285 	//        < 9wghlcE58Iq311m6F2RksqpRx5Qg580r9loNl3kzKGgUqpO0ymEG66XGcnZLnCx8 >									
286 	//        <  u =="0.000000000000000001" : ] 000000708254005.031884000000000000 ; 000000734008944.258478000000000000 ] >									
287 	//        < 0x00000000000000000000000000000000000000000000000000438B5B9460023E >									
288 	//     < RUSS_PFVII_III_metadata_line_29_____NOVATEK_AZK_20251101 >									
289 	//        < Iz6o01PUbvsqM69p6l9YY2d4Vl8NX7jRf22KmH1k4l10311XVjU3RmA0y5tl7466 >									
290 	//        <  u =="0.000000000000000001" : ] 000000734008944.258478000000000000 ; 000000756119279.082964000000000000 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000000000460023E481BF18 >									
292 	//     < RUSS_PFVII_III_metadata_line_30_____NOVATEK_NORTH_WEST_20251101 >									
293 	//        < mEb4Pi1j8pvKCBYI4itztfBosS2CJ152O4q33w0vS0j31gxxH4PiIYCrzqy1YB41 >									
294 	//        <  u =="0.000000000000000001" : ] 000000756119279.082964000000000000 ; 000000779894448.302477000000000000 ] >									
295 	//        < 0x00000000000000000000000000000000000000000000000000481BF184A60645 >									
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
338 	//     < RUSS_PFVII_III_metadata_line_31_____OOO_EKOPROMSTROY_20251101 >									
339 	//        < wWRQ7YcV77J6KeQ13f395g1wad8hc1BipE37L7wxA1Z6E58p9x0im2am5d14ZFw0 >									
340 	//        <  u =="0.000000000000000001" : ] 000000779894448.302477000000000000 ; 000000799343200.249238000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000004A606454C3B370 >									
342 	//     < RUSS_PFVII_III_metadata_line_32_____OVERSEAS_EP_20251101 >									
343 	//        < F924oxje2GPRb7qGP4U0GmCd4dqZSJWwnGh41bgBH27sg63hTMqp1uchCp0yKDZ0 >									
344 	//        <  u =="0.000000000000000001" : ] 000000799343200.249238000000000000 ; 000000821253480.544889000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000004C3B3704E52224 >									
346 	//     < RUSS_PFVII_III_metadata_line_33_____KOL_SKAYA_VERF_20251101 >									
347 	//        < Kn70pvXMhO4gb8utjN9OsTyhFzJ7qH01Y6jU0aT86ehE1g3pl4L4lahyRzU73X86 >									
348 	//        <  u =="0.000000000000000001" : ] 000000821253480.544889000000000000 ; 000000844569501.895695000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000004E52224508B5F6 >									
350 	//     < RUSS_PFVII_III_metadata_line_34_____TARKOSELENEFTEGAS_20251101 >									
351 	//        < 7t88RK01kq81oD58gBkMXvVwhz68aY3UO1r3pZ66u0anHi8Jt940546RBDRA6G89 >									
352 	//        <  u =="0.000000000000000001" : ] 000000844569501.895695000000000000 ; 000000866543478.217807000000000000 ] >									
353 	//        < 0x00000000000000000000000000000000000000000000000000508B5F652A3D8C >									
354 	//     < RUSS_PFVII_III_metadata_line_35_____TAMBEYNEFTEGAS_OAO_20251101 >									
355 	//        < Fv634UmB9U7xVe79msdpM094695N6UX3A580JwOIxY4besM69lDYoPu57LM3M09B >									
356 	//        <  u =="0.000000000000000001" : ] 000000866543478.217807000000000000 ; 000000901129070.159832000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000052A3D8C55F038B >									
358 	//     < RUSS_PFVII_III_metadata_line_36_____OOO_NOVATEK_MOSCOW_REGION_20251101 >									
359 	//        < 62R1hCV9Vtihyrc2017AuYL3ArNuKsqE430G7y9SSr4hzP7xvsNXmn5NgwWE72jr >									
360 	//        <  u =="0.000000000000000001" : ] 000000901129070.159832000000000000 ; 000000928660894.063814000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000055F038B5890629 >									
362 	//     < RUSS_PFVII_III_metadata_line_37_____OILTECHPRODUKT_INVEST_20251101 >									
363 	//        < kdvT5ncIQEs5s2bp6QrnO0o5el4692vHEIk8sCBn4mwTMTscDIfVt19511WMHy0Q >									
364 	//        <  u =="0.000000000000000001" : ] 000000928660894.063814000000000000 ; 000000962252820.535139000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000058906295BC4802 >									
366 	//     < RUSS_PFVII_III_metadata_line_38_____NOVATEK_UST_LUGA_20251101 >									
367 	//        < V20F9SR9qIZ0wog9rZez88db3GFN90fyo62m894B8O1w19RG3HmMXl4Q51DR5tVn >									
368 	//        <  u =="0.000000000000000001" : ] 000000962252820.535139000000000000 ; 000000984403731.140090000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000005BC48025DE14B5 >									
370 	//     < RUSS_PFVII_III_metadata_line_39_____NOVATEK_SCIENTIFIC_TECHNICAL_CENTER_20251101 >									
371 	//        < Bw5eavyZ6yb7nG4ykng51JwwCuXCMd680v2hl22GYiz4W2Br57XyZv0p0KzJ1nu5 >									
372 	//        <  u =="0.000000000000000001" : ] 000000984403731.140090000000000000 ; 000001016204702.108330000000000000 ] >									
373 	//        < 0x000000000000000000000000000000000000000000000000005DE14B560E9AF6 >									
374 	//     < RUSS_PFVII_III_metadata_line_40_____NOVATEK_GAS_POWER_ASIA_PTE_LTD_20251101 >									
375 	//        < 934SMx537ERP440AU33jZ03885Q4TZTf8aQvy7jih6Ffi53y67CD8v5C9Xr9brZj >									
376 	//        <  u =="0.000000000000000001" : ] 000001016204702.108330000000000000 ; 000001042339756.120710000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000060E9AF66367BF8 >									
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