1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	SEAPORT_Portfolio_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	SEAPORT_Portfolio_III_883		"	;
8 		string	public		symbol =	"	SEAPORT883III		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1212351653649260000000000000					;	
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
92 	//     < SEAPORT_Portfolio_III_metadata_line_1_____Sochi_Port_Authority_20250515 >									
93 	//        < N5c25pOC7RIvsC8iR6DKwUQw8XAvMos42m19WB0QgT354bj1zpwK5JIvLE3lNdq7 >									
94 	//        < 1E-018 limites [ 1E-018 ; 24173024,4266269 ] >									
95 	//        < 0x0000000000000000000000000000000000000000000000000000000090151D9E >									
96 	//     < SEAPORT_Portfolio_III_metadata_line_2_____Sochi_Port_Spe_Value_20250515 >									
97 	//        < CW1e6c4NiOJxDjR7vVTVrN96FWaL63m5LOzxCF16eDub90uGEgWCDbF7T6u21C2T >									
98 	//        < 1E-018 limites [ 24173024,4266269 ; 70412176,817712 ] >									
99 	//        < 0x0000000000000000000000000000000000000000000000090151D9E1A3B07685 >									
100 	//     < SEAPORT_Portfolio_III_metadata_line_3_____Solombala_Port_Spe_Value_20250515 >									
101 	//        < yfeXMo2j2apE74HqGGMU87yyWIuEtBUR5w3y4QjZrBOwiNFw06T0mOQ8s5kXg9H6 >									
102 	//        < 1E-018 limites [ 70412176,817712 ; 97416758,1548618 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000001A3B07685244A62F1B >									
104 	//     < SEAPORT_Portfolio_III_metadata_line_4_____Sovgavan_Port_Limited_20250515 >									
105 	//        < ZD3U1Sf1SKanXUXkJ7YhJ3m7MAYlvEhn2Vg0ia7zw69K4MbP2h9g1xx4yGR4KvZF >									
106 	//        < 1E-018 limites [ 97416758,1548618 ; 136747777,02979 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000244A62F1B32F148E5A >									
108 	//     < SEAPORT_Portfolio_III_metadata_line_5_____Port_Authority_of_St_Petersburg_20250515 >									
109 	//        < 8UGcZ1c97DC32u8RkLsNU9U8VFO5fzkHucidE64sDgH84aa3Pj5i61dof4L0mx4s >									
110 	//        < 1E-018 limites [ 136747777,02979 ; 161609547,464551 ] >									
111 	//        < 0x000000000000000000000000000000000000000000000032F148E5A3C3449B6E >									
112 	//     < SEAPORT_Portfolio_III_metadata_line_6_____Surgut_Port_Spe_Value_20250515 >									
113 	//        < MxRCsQUlOc1dnUR89yejMm3VUD3e2nNFqhM6y4m29ISdT476CenpHHPBDI4ft10X >									
114 	//        < 1E-018 limites [ 161609547,464551 ; 181738154,473837 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000003C3449B6E43B3E6C8B >									
116 	//     < SEAPORT_Portfolio_III_metadata_line_7_____Taganrog_Port_Authority_20250515 >									
117 	//        < 5hHEucQGNkI301x20gt04M9sj22ZghU77sbA402MbgnP1aNjv203cBZ4AwO8c85H >									
118 	//        < 1E-018 limites [ 181738154,473837 ; 222561478,06799 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000043B3E6C8B52E91DF52 >									
120 	//     < SEAPORT_Portfolio_III_metadata_line_8_____Tara_Port_Spe_Value_20250515 >									
121 	//        < VBSU0CdXN993TnfbvEcVv7VE0353colW357810rYib694Ae0Tsyptxx3czm83ieU >									
122 	//        < 1E-018 limites [ 222561478,06799 ; 241347812,860728 ] >									
123 	//        < 0x000000000000000000000000000000000000000000000052E91DF5259E8B8B5A >									
124 	//     < SEAPORT_Portfolio_III_metadata_line_9_____Temryuk_Port_Authority_20250515 >									
125 	//        < mzIasnrCk3DN7gqW61zkYpQsAiW3O9GPB7Dt6S4h8T31zVblR3G4k8VqLQ5QGSSg >									
126 	//        < 1E-018 limites [ 241347812,860728 ; 286188807,503747 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000059E8B8B5A6A9D178E2 >									
128 	//     < SEAPORT_Portfolio_III_metadata_line_10_____Tiksi_Sea_Trade_Port_20250515 >									
129 	//        < vkRd5lc9vwQ617sym4tZlrKYLP9NgRaLRMYWZUKi3h9o309pAF5sSQ76dB335HB8 >									
130 	//        < 1E-018 limites [ 286188807,503747 ; 304798054,669959 ] >									
131 	//        < 0x00000000000000000000000000000000000000000000006A9D178E2718BCEE0E >									
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
174 	//     < SEAPORT_Portfolio_III_metadata_line_11_____Tobolsk_Port_Spe_Value_20250515 >									
175 	//        < wRSgAc7u9737tR1FuoqP4sv411n24z5wzJj962ZE53Y9v6W4LemGmPQmfDJFc4N3 >									
176 	//        < 1E-018 limites [ 304798054,669959 ; 325878450,352155 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000718BCEE0E796630F9F >									
178 	//     < SEAPORT_Portfolio_III_metadata_line_12_____Tuapse_Port_Authorities_20250515 >									
179 	//        < ip2vLH3dp1Ba92GE8v96OjbL61sY09p17WwwTN0FG18Ye17Y12zC53kn7sup03hY >									
180 	//        < 1E-018 limites [ 325878450,352155 ; 361292717,805315 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000796630F9F86978F1D8 >									
182 	//     < SEAPORT_Portfolio_III_metadata_line_13_____Tver_Port_Spe_Value_20250515 >									
183 	//        < Aq5Q9Po2200gW6e6b2t03NL8GFw7JFmbB3b4C0TpTQ994er7EM1YauXiI33IxW01 >									
184 	//        < 1E-018 limites [ 361292717,805315 ; 395369082,633462 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000086978F1D89349559DB >									
186 	//     < SEAPORT_Portfolio_III_metadata_line_14_____Tyumen_Port_Spe_Value_20250515 >									
187 	//        < SY0aY8j8i2rmOndg2b03eiH7x1G4yM8n65rTekl2pV2wkEMg0326MC3P049sQ506 >									
188 	//        < 1E-018 limites [ 395369082,633462 ; 420347407,677249 ] >									
189 	//        < 0x00000000000000000000000000000000000000000000009349559DB9C9774013 >									
190 	//     < SEAPORT_Portfolio_III_metadata_line_15_____Ufa_Port_Spe_Value_20250515 >									
191 	//        < L4v5xA9MHZ32pZDV9qy01iPa77End75530ap7IE3E6J272VCqf6empc09WYBj39q >									
192 	//        < 1E-018 limites [ 420347407,677249 ; 462027798,80836 ] >									
193 	//        < 0x00000000000000000000000000000000000000000000009C9774013AC1E67ADC >									
194 	//     < SEAPORT_Portfolio_III_metadata_line_16_____Uglegorsk_Port_Authority_20250515 >									
195 	//        < oL3NYWz1e51A0D2zh322D07ieo9gKBGJP3YUx1QfBuo9vnvPmO4XFLevcYhXgx42 >									
196 	//        < 1E-018 limites [ 462027798,80836 ; 502237837,104432 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000AC1E67ADCBB1922112 >									
198 	//     < SEAPORT_Portfolio_III_metadata_line_17_____Ulan_Ude_Port_Spe_Value_20250515 >									
199 	//        < Lv74GT72ohrtHeJEn89Z4B3Y4fOIcR50X8364B3xJM4Gs568mOVC8PMIuMO1KyD1 >									
200 	//        < 1E-018 limites [ 502237837,104432 ; 520875103,568488 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000BB1922112C20A85748 >									
202 	//     < SEAPORT_Portfolio_III_metadata_line_18_____Ulyanovsk_Port_Spe_Value_20250515 >									
203 	//        < 84GW3dV0XuhV4Jak0oq2MLkWew6zBiFe3OUVFQ6r09kV9k2WJO66q4jlWRS3FsoR >									
204 	//        < 1E-018 limites [ 520875103,568488 ; 552770599,01717 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000C20A85748CDEC50131 >									
206 	//     < SEAPORT_Portfolio_III_metadata_line_19_____Ust_Kamchatsk_Sea_Trade_Port_20250515 >									
207 	//        < 3tWA9OCwOKFe6y1L5NrVDJ4rh0406V38xm6E2atggMI22cilcz46m8CYZ1PO4GuL >									
208 	//        < 1E-018 limites [ 552770599,01717 ; 587907385,448652 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000CDEC50131DB0337C64 >									
210 	//     < SEAPORT_Portfolio_III_metadata_line_20_____Ust_Luga_Sea_Port_20250515 >									
211 	//        < 5As75P0g4be7PW4e9Zn7J56DOFW4H0xDj1w9r54nchEc9Ca6xqVa8j503vtH8N3E >									
212 	//        < 1E-018 limites [ 587907385,448652 ; 613230699,671525 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000DB0337C64E4723CC03 >									
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
256 	//     < SEAPORT_Portfolio_III_metadata_line_21_____Vanino_Port_Authority_20250515 >									
257 	//        < 39aulGJyRds06AFT7h4wRrtybJoyh3VY1o4qwPH6w7y9yQdEEF9LkFRiZ2X7bEDo >									
258 	//        < 1E-018 limites [ 613230699,671525 ; 640293991,473941 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000E4723CC03EE8731A5F >									
260 	//     < SEAPORT_Portfolio_III_metadata_line_22_____Central_Office_of_the_Port_Vitino_20250515 >									
261 	//        < HNG2jKb45O3L11Pd6L6vI0tsOWWSiWL2917u8v2gfBqz1819mpwdN4U3I4Ims9GM >									
262 	//        < 1E-018 limites [ 640293991,473941 ; 660992415,885237 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000EE8731A5FF63D26468 >									
264 	//     < SEAPORT_Portfolio_III_metadata_line_23_____The_Commercial_Port_of_Vladivostok_JSC_20250515 >									
265 	//        < 9zM1rnfY7vE6iI6bm4zDML3lw3pBbq9aEgPfMDQmb5uEJ1G8FuC5KZ4U14r2Ju8B >									
266 	//        < 1E-018 limites [ 660992415,885237 ; 683795047,249155 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000F63D26468FEBBC7248 >									
268 	//     < SEAPORT_Portfolio_III_metadata_line_24_____Volgodonsk_Port_Spe_Value_20250515 >									
269 	//        < r05hMwcuypt87uPYC18Ho34Z3sN5cjzVC7ju30r94aXGDVcc1h33ZEPwruEP7blm >									
270 	//        < 1E-018 limites [ 683795047,249155 ; 703376088,063585 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000FEBBC7248106072BE5A >									
272 	//     < SEAPORT_Portfolio_III_metadata_line_25_____Volgograd_Port_Spe_Value_20250515 >									
273 	//        < 9D54iqqWQS54yK1y2V1F170MnTVoOSVDX88yBmBrO49M0AOVX8Ymj3XhZ4T36i25 >									
274 	//        < 1E-018 limites [ 703376088,063585 ; 731646315,773686 ] >									
275 	//        < 0x00000000000000000000000000000000000000000000106072BE5A1108F3B00D >									
276 	//     < SEAPORT_Portfolio_III_metadata_line_26_____Vostochny_Port_Joint_Stock_Company_20250515 >									
277 	//        < lR9M5NbL836b6w5LHQJS57c9PWlx1Qp63fTRXjctzLI7h9qk40441sS3Ap97y7Zr >									
278 	//        < 1E-018 limites [ 731646315,773686 ; 780063148,45697 ] >									
279 	//        < 0x000000000000000000000000000000000000000000001108F3B00D122989E951 >									
280 	//     < SEAPORT_Portfolio_III_metadata_line_27_____Vyborg_Port_Authority_20250515 >									
281 	//        < F24J8d041LE7XWQ2zNZo1Fw51936xt4n9I32BtBjGXe6tIRLLEBJU0LX64H8auhs >									
282 	//        < 1E-018 limites [ 780063148,45697 ; 829618161,684538 ] >									
283 	//        < 0x00000000000000000000000000000000000000000000122989E9511350E8DC5C >									
284 	//     < SEAPORT_Portfolio_III_metadata_line_28_____Vysotsk_Marine_Authority_20250515 >									
285 	//        < QGiqn7rhKaF71L7264mG0LsN4n5lS3o1p56SoLZ30uUFcbtOD7ahRDOHUUeW5eJN >									
286 	//        < 1E-018 limites [ 829618161,684538 ; 858789215,737113 ] >									
287 	//        < 0x000000000000000000000000000000000000000000001350E8DC5C13FEC85B59 >									
288 	//     < SEAPORT_Portfolio_III_metadata_line_29_____Yakutsk_Port_Spe_Value_20250515 >									
289 	//        < 9Zak1LcP7Ry6xyk8X2HR8GtDm8jFy6Bf0lfSNY6H1R318Pw8N94mMD3TgddeYTZP >									
290 	//        < 1E-018 limites [ 858789215,737113 ; 877520452,855942 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000013FEC85B59146E6DF4D9 >									
292 	//     < SEAPORT_Portfolio_III_metadata_line_30_____Yaroslavl_Port_Spe_Value_20250515 >									
293 	//        < 5six2Pnpiexpjh2VbtkoVz2eXW64ffr7lf43f6u8vO2TC5ESQFkre8Wbt5G29Jfq >									
294 	//        < 1E-018 limites [ 877520452,855942 ; 895890545,002664 ] >									
295 	//        < 0x00000000000000000000000000000000000000000000146E6DF4D914DBEC7E18 >									
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
338 	//     < SEAPORT_Portfolio_III_metadata_line_31_____JSC_Yeysk_Sea_Port_20250515 >									
339 	//        < pTfIoP5B71IjOIDy7STbd93z2TTvWZ6Bo1yi2qUs71qKl0x6WBTRZAf4KtPW7KZ9 >									
340 	//        < 1E-018 limites [ 895890545,002664 ; 934213684,631552 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000014DBEC7E1815C058F683 >									
342 	//     < SEAPORT_Portfolio_III_metadata_line_32_____Sea_Port_Zarubino_20250515 >									
343 	//        < 35iRQRc7d4oqehkoE2H0mDTwAp56Z0Hkc0Pud1355dAhgBW9cfh5W7Dj7bxKX8Wt >									
344 	//        < 1E-018 limites [ 934213684,631552 ; 959658988,283161 ] >									
345 	//        < 0x0000000000000000000000000000000000000000000015C058F6831658036A40 >									
346 	//     < SEAPORT_Portfolio_III_metadata_line_33_____Sevastopol_Marine_Trade_Port_20250515 >									
347 	//        < 4JMz36v5PCfa2a5D9t5pVee9uj2a91K2uwu66pd7jwC4BtUFZ2I1NAGH5u3975aW >									
348 	//        < 1E-018 limites [ 959658988,283161 ; 985045862,526475 ] >									
349 	//        < 0x000000000000000000000000000000000000000000001658036A4016EF54B600 >									
350 	//     < SEAPORT_Portfolio_III_metadata_line_34_____Sevastopol_Port_Spe_Value_20250515 >									
351 	//        < avvhK50jO2100iyoD90rtiztQk2jM3taYJu276ztIL7L3Q3SsyceeB3I6Pb3hO1V >									
352 	//        < 1E-018 limites [ 985045862,526475 ; 1032997479,62945 ] >									
353 	//        < 0x0000000000000000000000000000000000000000000016EF54B600180D25126E >									
354 	//     < SEAPORT_Portfolio_III_metadata_line_35_____Kerchenskaya_Port_Spe_Value_20250515 >									
355 	//        < cic5VJFMi81xaZj32KX2RyUUYOxcl8zF9JSgfTE5cfkSnRVK4r4PT28pBUfg7t9Q >									
356 	//        < 1E-018 limites [ 1032997479,62945 ; 1070357995,06771 ] >									
357 	//        < 0x00000000000000000000000000000000000000000000180D25126E18EBD4B1C6 >									
358 	//     < SEAPORT_Portfolio_III_metadata_line_36_____Kerch_Port_Spe_Value_20250515 >									
359 	//        < D6x4v1q911564i9Rrq5JafT2sI0n3bO3n4MTCXCC7VgvI5Tmd4KS8I0F3J3iJ4cS >									
360 	//        < 1E-018 limites [ 1070357995,06771 ;  ] >									
361 	//        < 0x0000000000000000000000000000000000000000000018EBD4B1C619F59EB05B >									
362 	//     < SEAPORT_Portfolio_III_metadata_line_37_____Feodossiya_Port_Spe_Value_20250515 >									
363 	//        < Z3bE0OY4xv7yjGv7guebeSCVzTM7203t7ESbk2FYFuxI54946y1WmxbO612vDz7N >									
364 	//        < 1E-018 limites [ 1114949996,557 ; 1133401209,07297 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000019F59EB05B1A6399013F >									
366 	//     < SEAPORT_Portfolio_III_metadata_line_38_____Yalta_Port_Spe_Value_20250515 >									
367 	//        < 50bSWARbOkzihMKN3IO7g68xe9jsNnd74e6L27GVyyEw9fFV9JPmz98BN2SICuw3 >									
368 	//        < 1E-018 limites [ 1133401209,07297 ; 1151185727,68806 ] >									
369 	//        < 0x000000000000000000000000000000000000000000001A6399013F1ACD9A06D4 >									
370 	//     < SEAPORT_Portfolio_III_metadata_line_39_____Vidradne_Port_Spe_Value_20250515 >									
371 	//        < So3gwQ0q543zXBPdte61LQR0Fyr5y7gMjPkyXnq0MK06h3Ret7d17D0y7e634sKw >									
372 	//        < 1E-018 limites [ 1151185727,68806 ; 1171897491,37218 ] >									
373 	//        < 0x000000000000000000000000000000000000000000001ACD9A06D41B490DAB85 >									
374 	//     < SEAPORT_Portfolio_III_metadata_line_40_____Severodvinsk_Port_Spe_Value_20250515 >									
375 	//        < EIlp4lJNYvWhXgSGfW9116Ta4pi97r0f4s08nIb933w154A2C7ze9W3cbo41R4Tc >									
376 	//        < 1E-018 limites [ 1171897491,37218 ; 1212351653,64926 ] >									
377 	//        < 0x000000000000000000000000000000000000000000001B490DAB851C3A2DD2A8 >									
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