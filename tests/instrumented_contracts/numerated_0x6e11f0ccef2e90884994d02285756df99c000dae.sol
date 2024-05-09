1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXVIII_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXVIII_I_883		"	;
8 		string	public		symbol =	"	RUSS_PFXVIII_I_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		604142944846809000000000000					;	
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
92 	//     < RUSS_PFXVIII_I_metadata_line_1_____RESO_GARANTIA_20211101 >									
93 	//        < 60nwRgE01XXJ2v80SLk3y5ZYOH8PP5Lb9O7UGMY3Opq027lIo1vZi1t4slgXjd0S >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000017238132.451084700000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000001A4DA5 >									
96 	//     < RUSS_PFXVIII_I_metadata_line_2_____RESO_CREDIT_BANK_20211101 >									
97 	//        < K2f185KLnRxjBG2KkMt6n7yTgO4ulDpa7i6N9dK31r4gYVepcwIQiI33z5a03Bsg >									
98 	//        <  u =="0.000000000000000001" : ] 000000017238132.451084700000000000 ; 000000031401541.097964200000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000001A4DA52FEA3A >									
100 	//     < RUSS_PFXVIII_I_metadata_line_3_____RESO_LEASING_20211101 >									
101 	//        < F1KX70iA11pKg9cUqJqr225atvu88fH369s1902vSn05fR6Q7cQzAUZ62nmsC7W7 >									
102 	//        <  u =="0.000000000000000001" : ] 000000031401541.097964200000000000 ; 000000046518632.193703500000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000002FEA3A46FB57 >									
104 	//     < RUSS_PFXVIII_I_metadata_line_4_____OSZH_RESO_GARANTIA_20211101 >									
105 	//        < 0KJJQ2ZMM3g4o288201ih5c7ELAdUnxZm8YKKT320L62vk2Jrx3fWt1b9V23sYIB >									
106 	//        <  u =="0.000000000000000001" : ] 000000046518632.193703500000000000 ; 000000062445856.990240800000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000046FB575F48EA >									
108 	//     < RUSS_PFXVIII_I_metadata_line_5_____STRAKHOVOI_SINDIKAT_20211101 >									
109 	//        < 3of29jy8lI5l7gd61uaQ6lcE3nxlri5js0FX04Go7PPtEAWT2797D2X73d009CzD >									
110 	//        <  u =="0.000000000000000001" : ] 000000062445856.990240800000000000 ; 000000077455157.070667500000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000005F48EA762FEC >									
112 	//     < RUSS_PFXVIII_I_metadata_line_6_____RESO_FINANCIAL_MARKETS_20211101 >									
113 	//        < Sbzp1Zda2Z0vmJb5ybVr5GYy2AWI16a0PKO9U5u3xWs603p3LZCyV174qn769QiW >									
114 	//        <  u =="0.000000000000000001" : ] 000000077455157.070667500000000000 ; 000000093144714.877161200000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000762FEC8E20A7 >									
116 	//     < RUSS_PFXVIII_I_metadata_line_7_____LIPETSK_INSURANCE_CO_CHANCE_20211101 >									
117 	//        < 3NH6JOyS2x50t373BQggnvBYPPenx5A8xCRwpwSE76DyMbmhwa7IouvrT16Darz4 >									
118 	//        <  u =="0.000000000000000001" : ] 000000093144714.877161200000000000 ; 000000109340490.176763000000000000 ] >									
119 	//        < 0x00000000000000000000000000000000000000000000000000008E20A7A6D721 >									
120 	//     < RUSS_PFXVIII_I_metadata_line_8_____ALVENA_RESO_GROUP_20211101 >									
121 	//        < 40R2N0MypkO7lLiM5eqiTB1P35iq4x2k4gbfaa5FUmLH00gwqZnlu310FxotZZaM >									
122 	//        <  u =="0.000000000000000001" : ] 000000109340490.176763000000000000 ; 000000125601615.343752000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000A6D721BFA722 >									
124 	//     < RUSS_PFXVIII_I_metadata_line_9_____NADEZHNAYA_LIFE_INSURANCE_CO_20211101 >									
125 	//        < lPGzBwppjcF2dLmtYhpf51z6f7749iygM2780BTM5H49tPEoOAiUL08gPqXwJMd6 >									
126 	//        <  u =="0.000000000000000001" : ] 000000125601615.343752000000000000 ; 000000139935199.275881000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000000BFA722D58630 >									
128 	//     < RUSS_PFXVIII_I_metadata_line_10_____MSK_URALSIB_20211101 >									
129 	//        < G4fb022AYY3Os4DJM5Y9Fv0rbvxNORXPH5AoZc00drB2W4s5OnJ8EKCruQ4M54Mt >									
130 	//        <  u =="0.000000000000000001" : ] 000000139935199.275881000000000000 ; 000000153686115.733859000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000000D58630EA81A4 >									
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
174 	//     < RUSS_PFXVIII_I_metadata_line_11_____RESO_1_ORG_20211101 >									
175 	//        < 9R3yV67pQ3t2bR4754S555DM3H41uMU174XOB2tZmua5RVEE0YsNFuPbLW02zqD3 >									
176 	//        <  u =="0.000000000000000001" : ] 000000153686115.733859000000000000 ; 000000170699507.976927000000000000 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000000000EA81A4104777F >									
178 	//     < RUSS_PFXVIII_I_metadata_line_12_____RESO_1_DAO_20211101 >									
179 	//        < z3heqIh4HSum2dLy9b5Jpb5ZP7DdCVmIF2ih7Gp4bES0CE663UW9qep4wmD883Z5 >									
180 	//        <  u =="0.000000000000000001" : ] 000000170699507.976927000000000000 ; 000000184405554.428286000000000000 ] >									
181 	//        < 0x00000000000000000000000000000000000000000000000000104777F119616B >									
182 	//     < RUSS_PFXVIII_I_metadata_line_13_____RESO_1_DAOPI_20211101 >									
183 	//        < A0F4UM1P4fpaRW2I0Dxll8L78764t63my9s4rLCdGLPvOQ1J6hDmtHI7ao05nwnM >									
184 	//        <  u =="0.000000000000000001" : ] 000000184405554.428286000000000000 ; 000000200926662.567848000000000000 ] >									
185 	//        < 0x00000000000000000000000000000000000000000000000000119616B13296FA >									
186 	//     < RUSS_PFXVIII_I_metadata_line_14_____RESO_1_DAC_20211101 >									
187 	//        < 6ZZN2qv5cYH8y55q8C32zTqz8U1j12tPGeWnUzpm06bA0afuc0w0L5aX7eoBJKb7 >									
188 	//        <  u =="0.000000000000000001" : ] 000000200926662.567848000000000000 ; 000000216619563.641489000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000013296FA14A8904 >									
190 	//     < RUSS_PFXVIII_I_metadata_line_15_____RESO_1_BIMI_20211101 >									
191 	//        < UtUYrwOV8bN0C7Kflq2qi3J2pU19ofmB6iQrY40U3dFSzFid841vN78iSS7BIowe >									
192 	//        <  u =="0.000000000000000001" : ] 000000216619563.641489000000000000 ; 000000230121735.334113000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000014A890415F234E >									
194 	//     < RUSS_PFXVIII_I_metadata_line_16_____RESO_2_ORG_20211101 >									
195 	//        < Q3UL04IfKC5Kx65sXH0px8y909g9zFG198BBE5Dy0afJ2H7PAai3mz0eR6RQ84d0 >									
196 	//        <  u =="0.000000000000000001" : ] 000000230121735.334113000000000000 ; 000000243204005.236136000000000000 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000000015F234E1731991 >									
198 	//     < RUSS_PFXVIII_I_metadata_line_17_____RESO_2_DAO_20211101 >									
199 	//        < mpP4EIMsjG33nb4xOQ78Abt0dZhTag1722WB3R1A0T67FTYUqiIsLUEWv2Jkr75I >									
200 	//        <  u =="0.000000000000000001" : ] 000000243204005.236136000000000000 ; 000000259900910.723113000000000000 ] >									
201 	//        < 0x00000000000000000000000000000000000000000000000000173199118C93CB >									
202 	//     < RUSS_PFXVIII_I_metadata_line_18_____RESO_2_DAOPI_20211101 >									
203 	//        < Qgxr6d00V9eYAi13Aol2PraUpE25tKVm76x922WVQ9v7pB7wuL7xhSVydkvX0JcP >									
204 	//        <  u =="0.000000000000000001" : ] 000000259900910.723113000000000000 ; 000000275336430.119526000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000018C93CB1A4214B >									
206 	//     < RUSS_PFXVIII_I_metadata_line_19_____RESO_2_DAC_20211101 >									
207 	//        < d3UJ6FW6bl7P30H3P122r2du7GIAD0Sx4kSvFOs8Ki7dSaA4jTr28wE2iFfQid7M >									
208 	//        <  u =="0.000000000000000001" : ] 000000275336430.119526000000000000 ; 000000290324291.662090000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000001A4214B1BAFFED >									
210 	//     < RUSS_PFXVIII_I_metadata_line_20_____RESO_2_BIMI_20211101 >									
211 	//        < vXE46mCE7I1P98m7iKN31pD6Ui5qPg4060b415UQ300RAt73lde65CgKDUQQQq08 >									
212 	//        <  u =="0.000000000000000001" : ] 000000290324291.662090000000000000 ; 000000307008085.812411000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000001BAFFED1D47509 >									
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
256 	//     < RUSS_PFXVIII_I_metadata_line_21_____RESO_PENSII_1_ORG_20211101 >									
257 	//        < SE90uixRtoXwUJUIqjJ0zuHt8Ec3mKb6DvWHt9O4ENYkC4I7Jvp8B2jr8Vpl35or >									
258 	//        <  u =="0.000000000000000001" : ] 000000307008085.812411000000000000 ; 000000322186567.226410000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000001D475091EB9E21 >									
260 	//     < RUSS_PFXVIII_I_metadata_line_22_____RESO_PENSII_1_DAO_20211101 >									
261 	//        < 9k8H1iRoEBMx1mZnVx351LT345e72o5UTf1vgQ0V54xFQB34aOj19og8C12i4EAy >									
262 	//        <  u =="0.000000000000000001" : ] 000000322186567.226410000000000000 ; 000000339299240.655128000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000001EB9E21205BAC4 >									
264 	//     < RUSS_PFXVIII_I_metadata_line_23_____RESO_PENSII_1_DAOPI_20211101 >									
265 	//        < 9V184Q7p18i88Ayr4dQw73N62c8oLI2Ya1p6pSaD9R2j8Ibvo3y90384e8MWPC1j >									
266 	//        <  u =="0.000000000000000001" : ] 000000339299240.655128000000000000 ; 000000353430558.396331000000000000 ] >									
267 	//        < 0x00000000000000000000000000000000000000000000000000205BAC421B4AD0 >									
268 	//     < RUSS_PFXVIII_I_metadata_line_24_____RESO_PENSII_1_DAC_20211101 >									
269 	//        < l312Ug26dbQItluZmfGwyWXKlJNTkXd7Ztvz6h5vle3zu84jVMz4m7YWm552hg94 >									
270 	//        <  u =="0.000000000000000001" : ] 000000353430558.396331000000000000 ; 000000369788074.422272000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000021B4AD02344077 >									
272 	//     < RUSS_PFXVIII_I_metadata_line_25_____RESO_PENSII_1_BIMI_20211101 >									
273 	//        < 17Ttfh0fZxSLyTSH5Q14j9C4bbAD3p8b553RQxHjOWzIRupo4YK0EXHnSmLv392y >									
274 	//        <  u =="0.000000000000000001" : ] 000000369788074.422272000000000000 ; 000000383092894.721326000000000000 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000000000023440772488DA9 >									
276 	//     < RUSS_PFXVIII_I_metadata_line_26_____RESO_PENSII_2_ORG_20211101 >									
277 	//        < l5m5y0T9pkuZWa8WoLyGPd96Wo9j3i120eaD3PW07guV9269V2dX2Zvft9k7EXqF >									
278 	//        <  u =="0.000000000000000001" : ] 000000383092894.721326000000000000 ; 000000397880061.083928000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000002488DA925F1DE6 >									
280 	//     < RUSS_PFXVIII_I_metadata_line_27_____RESO_PENSII_2_DAO_20211101 >									
281 	//        < pjka9NPAH3H7tuu9kv7nxc77GwJKBuN82K4X92u82VdX3shUDOqTQFwHwmOaHWNF >									
282 	//        <  u =="0.000000000000000001" : ] 000000397880061.083928000000000000 ; 000000411761602.009088000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000025F1DE62744C60 >									
284 	//     < RUSS_PFXVIII_I_metadata_line_28_____RESO_PENSII_2_DAOPI_20211101 >									
285 	//        < Grv70e1W798QgT8akl8wZhO6HqF0mgXkz4kf8aM52yraC5Q56g9H4WC2geyAlLgv >									
286 	//        <  u =="0.000000000000000001" : ] 000000411761602.009088000000000000 ; 000000426977547.808152000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000002744C6028B841B >									
288 	//     < RUSS_PFXVIII_I_metadata_line_29_____RESO_PENSII_2_DAC_20211101 >									
289 	//        < ISGYoB07Ee227DlA95RzyrvvIKJ51Pyz8mTYXbn7g1Ai6Dn5wj7IKD6AelL4b7z2 >									
290 	//        <  u =="0.000000000000000001" : ] 000000426977547.808152000000000000 ; 000000444163917.699796000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000028B841B2A5BD88 >									
292 	//     < RUSS_PFXVIII_I_metadata_line_30_____RESO_PENSII_2_BIMI_20211101 >									
293 	//        < jtZ2T4g97O3iOSth70C4bB511QYY7p673vUY9IUINhys8Rs7Q7fI233tQ3n7UQ5T >									
294 	//        <  u =="0.000000000000000001" : ] 000000444163917.699796000000000000 ; 000000458151690.866141000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000002A5BD882BB1581 >									
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
338 	//     < RUSS_PFXVIII_I_metadata_line_31_____MIKA_ORG_20211101 >									
339 	//        < U1Ww63GTtC8Z8Z59dinJcB4r5ZXwoT5QzVipgA70L37wq62fdZ6Iud01OZ4g01Lu >									
340 	//        <  u =="0.000000000000000001" : ] 000000458151690.866141000000000000 ; 000000473213454.887405000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000002BB15812D21101 >									
342 	//     < RUSS_PFXVIII_I_metadata_line_32_____MIKA_DAO_20211101 >									
343 	//        < CSf7g9v0q7j1drPQyOS3q7Y83JFR693V5o0b11NnF6JevieZsbPX4o5VE32y8bh2 >									
344 	//        <  u =="0.000000000000000001" : ] 000000473213454.887405000000000000 ; 000000487802227.763905000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000002D211012E853BF >									
346 	//     < RUSS_PFXVIII_I_metadata_line_33_____MIKA_DAOPI_20211101 >									
347 	//        < O9YhkcKu6z20Zc2RYIvd45MJFqa2JKw0prk38p9776KIdak4x7JXEjfY9k5bwRg1 >									
348 	//        <  u =="0.000000000000000001" : ] 000000487802227.763905000000000000 ; 000000503893868.976847000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000002E853BF300E18B >									
350 	//     < RUSS_PFXVIII_I_metadata_line_34_____MIKA_DAC_20211101 >									
351 	//        < UkYf47jlA7lGihjV3AcAE94DZZ0Qc2axMe3DZjUoS5eRrrc9Gevv77jg23d4a7PV >									
352 	//        <  u =="0.000000000000000001" : ] 000000503893868.976847000000000000 ; 000000517694438.238585000000000000 ] >									
353 	//        < 0x00000000000000000000000000000000000000000000000000300E18B315F064 >									
354 	//     < RUSS_PFXVIII_I_metadata_line_35_____MIKA_BIMI_20211101 >									
355 	//        < yGz52l40z3Xr0tIh7g9b2E0w1hUJGStMqwSB2mqIY22pr14509fb4OEFQk7FM7aC >									
356 	//        <  u =="0.000000000000000001" : ] 000000517694438.238585000000000000 ; 000000532609110.552695000000000000 ] >									
357 	//        < 0x00000000000000000000000000000000000000000000000000315F06432CB26F >									
358 	//     < RUSS_PFXVIII_I_metadata_line_36_____MIKA_PENSII_ORG_20211101 >									
359 	//        < Z75Z2H6GxBsYJ06A4G1xdIRzH14t08oE07Jij79B1m5bleGcDkbF3QnO37qxyb4B >									
360 	//        <  u =="0.000000000000000001" : ] 000000532609110.552695000000000000 ; 000000545926656.570301000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000032CB26F341049A >									
362 	//     < RUSS_PFXVIII_I_metadata_line_37_____MIKA_PENSII_DAO_20211101 >									
363 	//        < dC349T5MUkJ81Qos1iso5DT995z34SMe3Z0M8TqlTOg5fp713xcMfnFAsN456oPw >									
364 	//        <  u =="0.000000000000000001" : ] 000000545926656.570301000000000000 ; 000000561423356.937724000000000000 ] >									
365 	//        < 0x00000000000000000000000000000000000000000000000000341049A358AA00 >									
366 	//     < RUSS_PFXVIII_I_metadata_line_38_____MIKA_PENSII_DAOPI_20211101 >									
367 	//        < Gun03c2Mn0Kse21c63TErI897jGHN04045Gf82Bu47coKAJnqvK6o5bcTtNr78ax >									
368 	//        <  u =="0.000000000000000001" : ] 000000561423356.937724000000000000 ; 000000575011929.125263000000000000 ] >									
369 	//        < 0x00000000000000000000000000000000000000000000000000358AA0036D6609 >									
370 	//     < RUSS_PFXVIII_I_metadata_line_39_____MIKA_PENSII_DAC_20211101 >									
371 	//        < cz1qtCBx5OG49zJGhyvmwHos8PxY6k170W1p5T6LTc7AJx19xX5gi3n8s9m20p35 >									
372 	//        <  u =="0.000000000000000001" : ] 000000575011929.125263000000000000 ; 000000590400730.692894000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000036D6609384E149 >									
374 	//     < RUSS_PFXVIII_I_metadata_line_40_____MIKA_PENSII_BIMI_20211101 >									
375 	//        < Clva2k5W5p9XaBdp9CDRt1QDq273BjU0CbBcPJN8XZ32bcHVm9ajcG7HEU6kW74O >									
376 	//        <  u =="0.000000000000000001" : ] 000000590400730.692894000000000000 ; 000000604142944.846810000000000000 ] >									
377 	//        < 0x00000000000000000000000000000000000000000000000000384E149399D956 >									
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