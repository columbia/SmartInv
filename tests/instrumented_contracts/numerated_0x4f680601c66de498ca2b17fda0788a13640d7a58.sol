1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RE_Portfolio_IX_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RE_Portfolio_IX_883		"	;
8 		string	public		symbol =	"	RE883IX		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1404357449531340000000000000					;	
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
92 	//     < RE_Portfolio_IX_metadata_line_1_____Coface_sa_NR_m_AAm_A2_20250515 >									
93 	//        < 88AgS2F5z46BUk9go47NZRGbUUF9L1ulxVbFChaYRSgnkIPKkb0CexcSa9C9LI0M >									
94 	//        < 1E-018 limites [ 1E-018 ; 18624924,6937051 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000006F036329 >									
96 	//     < RE_Portfolio_IX_metadata_line_2_____Collard_and_Partners_20250515 >									
97 	//        < vlyvT9gB2FYccmP6U3LoLV2rV90D1fHPP5wf2rsA584Du44Mdl86EGh34zFB8BYZ >									
98 	//        < 1E-018 limites [ 18624924,6937051 ; 68874631,9508929 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000006F03632919A865B0F >									
100 	//     < RE_Portfolio_IX_metadata_line_3_____Continental_Casualty_Co_A_A_20250515 >									
101 	//        < hH2UrZ74q9xzE9yfj7GRpfFCHMd42c20Wm87Az4pZN0WLW4lN458s3SaE9VWwh9k >									
102 	//        < 1E-018 limites [ 68874631,9508929 ; 101498328,385074 ] >									
103 	//        < 0x000000000000000000000000000000000000000000000019A865B0F25CFA2A7A >									
104 	//     < RE_Portfolio_IX_metadata_line_4_____Continental_Reinsurance_Plc_Bp_20250515 >									
105 	//        < 115gWxp0JrqasadIp7kQnbP29LcfxTfN0nQu9HXFDy1z48y3g4H5hYRTL93rSKO2 >									
106 	//        < 1E-018 limites [ 101498328,385074 ; 116002561,283613 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000025CFA2A7A2B36DDE74 >									
108 	//     < RE_Portfolio_IX_metadata_line_5_____Converium_20250515 >									
109 	//        < 0CLLaJt136L02HH7V6MpZBT4IqNUOGE6YHs3wD5uR7H5Ukare8ePOkyY5mho8AQq >									
110 	//        < 1E-018 limites [ 116002561,283613 ; 139649964,386638 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000002B36DDE7434060F14A >									
112 	//     < RE_Portfolio_IX_metadata_line_6_____Copenhagen_Reinsurance_Company_20250515 >									
113 	//        < Qzl522Bq70Q392lQ8p72mCRkRtge8dUTQLhkEVm6GEs0cmojP2ZhK4IjJOzQo85P >									
114 	//        < 1E-018 limites [ 139649964,386638 ; 205712184,04366 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000034060F14A4CA23E3D8 >									
116 	//     < RE_Portfolio_IX_metadata_line_7_____Coverys_Managing_Agency_Limited_20250515 >									
117 	//        < i4D6TuTh9Igs3bbAY8FFi0nqBJMr27gT7dkh99b73Ozhzx0sXNirsdn0o7N6ZFob >									
118 	//        < 1E-018 limites [ 205712184,04366 ; 224867352,068255 ] >									
119 	//        < 0x00000000000000000000000000000000000000000000004CA23E3D853C505B5A >									
120 	//     < RE_Portfolio_IX_metadata_line_8_____Coverys_Managing_Agency_Limited_20250515 >									
121 	//        < xG9R9JlfO5642fzFKTY3Q328k0TfN3h97UeWUqO75rKCkEQ2QZiRvC3n50A575Fa >									
122 	//        < 1E-018 limites [ 224867352,068255 ; 274254167,804167 ] >									
123 	//        < 0x000000000000000000000000000000000000000000000053C505B5A662AEA840 >									
124 	//     < RE_Portfolio_IX_metadata_line_9_____Coverys_Managing_Agency_Limited_20250515 >									
125 	//        < v6pRPC2v8V43pCu4Y9owQ4ufI9bFtdNM9YVw64hzoBm0sAO26ew52QKHz7H6qcep >									
126 	//        < 1E-018 limites [ 274254167,804167 ; 292366457,709014 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000662AEA8406CEA3D17E >									
128 	//     < RE_Portfolio_IX_metadata_line_10_____Coverys_Managing_Agency_Limited_20250515 >									
129 	//        < afPat8fDGKD5Trz2rTRVhjUuVKX6Ki9eZ3RL6tJ60FIw06KuRnCn92V4bWYv4kDJ >									
130 	//        < 1E-018 limites [ 292366457,709014 ; 333609481,239023 ] >									
131 	//        < 0x00000000000000000000000000000000000000000000006CEA3D17E7C477AD8F >									
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
174 	//     < RE_Portfolio_IX_metadata_line_11_____Coverys_Managing_Agency_Limited_20250515 >									
175 	//        < 96r29cfzPjb5s9v0PkeC4z5v7TnwTkifXM89Q3oS629vZrLIfPKS77PwuURiq08Z >									
176 	//        < 1E-018 limites [ 333609481,239023 ; 374945539,340977 ] >									
177 	//        < 0x00000000000000000000000000000000000000000000007C477AD8F8BAD97F42 >									
178 	//     < RE_Portfolio_IX_metadata_line_12_____Coverys_Managing_Agency_Limited_20250515 >									
179 	//        < Qa0HEbtO36xd8Qw28BNao0CZ4g8GEF82pNVV25Zai5T0MR7rUwdSjqlV9q37io38 >									
180 	//        < 1E-018 limites [ 374945539,340977 ; 409790344,441723 ] >									
181 	//        < 0x00000000000000000000000000000000000000000000008BAD97F4298A8A7340 >									
182 	//     < RE_Portfolio_IX_metadata_line_13_____Credit_Guarantee_20250515 >									
183 	//        < SYiYy9QxAzh3Q7IV690025M212MFH8ViKh903dAX3b372B73HqmKZC4l35wlvBgr >									
184 	//        < 1E-018 limites [ 409790344,441723 ; 438481185,387929 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000098A8A7340A358D32FE >									
186 	//     < RE_Portfolio_IX_metadata_line_14_____Delta_Lloyd_Schadeverzekerina_NV_Am_20250515 >									
187 	//        < BhpUcI8eUPPRR2hEBds294RBDMy490H0Q9nwSQa14Xtoss5X0v0SZT21Pd6vlR9h >									
188 	//        < 1E-018 limites [ 438481185,387929 ; 454547146,537046 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000A358D32FEA954FE911 >									
190 	//     < RE_Portfolio_IX_metadata_line_15_____Delvag_LuftfahrtversicherungsmAG_m_A_20250515 >									
191 	//        < 14hRl8NO9FIrnH1TDzSlJ937Rw9qRD18111TI49wrNpX2y4wNhsy6Jk91m5qMVxd >									
192 	//        < 1E-018 limites [ 454547146,537046 ; 478104850,249938 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000A954FE911B21BA1D14 >									
194 	//     < RE_Portfolio_IX_metadata_line_16_____Deutsche_Rueckversicherung_20250515 >									
195 	//        < 4ABE2v2nz3VVQyKOET13L242t26K05059UnMQ9690m818bq6my8cKkesDb8unKUb >									
196 	//        < 1E-018 limites [ 478104850,249938 ; 521879887,120306 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000B21BA1D14C26A584DC >									
198 	//     < RE_Portfolio_IX_metadata_line_17_____DEVK_Deutche_Ap_m_20250515 >									
199 	//        < v8wDs2NzZ6xODg1L94J3HvBQt31N8g9akEw13WLnO7LD86ljh1rRL6ReE83X5DX4 >									
200 	//        < 1E-018 limites [ 521879887,120306 ; 545797069,567282 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000C26A584DCCB5343E40 >									
202 	//     < RE_Portfolio_IX_metadata_line_18_____Devonshire_Group_20250515 >									
203 	//        < wymO39mF2D9fizJkw7xT157Md4P251syJ881i0B35q36wfpG9QJid0391exT74Ls >									
204 	//        < 1E-018 limites [ 545797069,567282 ; 612010223,580769 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000CB5343E40E3FDD7F8A >									
206 	//     < RE_Portfolio_IX_metadata_line_19_____Doha_insurance_CO_QSC_Am_Am_20250515 >									
207 	//        < tyF22LGce9p727e394xBTeGGKq6GXK5BKiIiE0MO349Qt79AxTG6waPH8BqyxiqK >									
208 	//        < 1E-018 limites [ 612010223,580769 ; 672065865,298308 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000E3FDD7F8AFA5D32295 >									
210 	//     < RE_Portfolio_IX_metadata_line_20_____Dongbu_Insurance_Co_Limited_Am_20250515 >									
211 	//        < rz53f3ly6p3ZP0ya2vQyx2LuHZVmQTjdH1s0v6K15e3VGX6bU7lH405mqA5W0rXm >									
212 	//        < 1E-018 limites [ 672065865,298308 ; 748241209,849411 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000FA5D32295116BDD7C8C >									
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
256 	//     < RE_Portfolio_IX_metadata_line_21_____Dorinco_Reinsurance_Company_20250515 >									
257 	//        < 13W17RUGn435IxW078dy8Y5TQ9e5nmwMG269OaEzX4QhI4X80izuT35iuE29B4Sd >									
258 	//        < 1E-018 limites [ 748241209,849411 ; 817808730,727887 ] >									
259 	//        < 0x00000000000000000000000000000000000000000000116BDD7C8C130A851964 >									
260 	//     < RE_Portfolio_IX_metadata_line_22_____Ecclesiastical_Insurance_Office_PLC_Am_A_20250515 >									
261 	//        < 59sNGCHMpZdLGti6D852440ivcBdQN0oVK8eqZlkL5ZTLDljK091ZOnyF5I4k6bW >									
262 	//        < 1E-018 limites [ 817808730,727887 ; 833829771,722031 ] >									
263 	//        < 0x00000000000000000000000000000000000000000000130A851964136A034488 >									
264 	//     < RE_Portfolio_IX_metadata_line_23_____Echo_Rueckversicherungs_m_AG__Echo_Re__Am_20250515 >									
265 	//        < lsg5Zfdk4o0VVgQRcBX3771t1m8BqUO5a3irHKsoUq6afZevL1HEgfQ0Jrx6whS3 >									
266 	//        < 1E-018 limites [ 833829771,722031 ; 857703894,624017 ] >									
267 	//        < 0x00000000000000000000000000000000000000000000136A03448813F85049CA >									
268 	//     < RE_Portfolio_IX_metadata_line_24_____Emirates_Ins_Co__PSC__Am_20250515 >									
269 	//        < J7zT5NN3v2j08EsUY7sRw5I0sq1e7o2k6J53a78g42D0mQ7NT4ovxKKbxms5ytl3 >									
270 	//        < 1E-018 limites [ 857703894,624017 ; 927407740,383387 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000013F85049CA1597C7EA8A >									
272 	//     < RE_Portfolio_IX_metadata_line_25_____Emirates_Retakaful_limited_Bpp_20250515 >									
273 	//        < 0Y0kTso43otg59rq0G498a5fUksL866fI5OsRpbV1eIyu30L2a5cRM025uiel7YA >									
274 	//        < 1E-018 limites [ 927407740,383387 ; 939222985,153632 ] >									
275 	//        < 0x000000000000000000000000000000000000000000001597C7EA8A15DE348C87 >									
276 	//     < RE_Portfolio_IX_metadata_line_26_____Endurance_at_Lloyd_s_Limited_20250515 >									
277 	//        < pZwY7WmF4KNMs7x1CItuox4cDSf84eVARbAXiJxbQI2scSL35b8V0EH7sitkEp0E >									
278 	//        < 1E-018 limites [ 939222985,153632 ; 978807189,240854 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000015DE348C8716CA254040 >									
280 	//     < RE_Portfolio_IX_metadata_line_27_____Endurance_at_Lloyd_s_Limited_20250515 >									
281 	//        < A8F7EHKo20un388VWu898Y0RF0P40o9hQBb93MM61LoIHBC5Z1RUQpTp0gCNIF3G >									
282 	//        < 1E-018 limites [ 978807189,240854 ; 999684565,540226 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000016CA254040174695995E >									
284 	//     < RE_Portfolio_IX_metadata_line_28_____Endurance_at_Lloyd_s_Limited_20250515 >									
285 	//        < 0K1fjU734A8WEJ3H3xs6B41685523757JeIdJgCRBb2Rzelt052Q84j9a8OkxtOS >									
286 	//        < 1E-018 limites [ 999684565,540226 ; 1045088529,15821 ] >									
287 	//        < 0x00000000000000000000000000000000000000000000174695995E1855368CA7 >									
288 	//     < RE_Portfolio_IX_metadata_line_29_____Endurance_Specialty_Holdings_Limited_20250515 >									
289 	//        < 6Lj195g0n3Ow8kLKu0KV3UD136Q61mYaW33QO73pPUrbghDtKaA212sJ40o9sI9L >									
290 	//        < 1E-018 limites [ 1045088529,15821 ; 1084699261,5999 ] >									
291 	//        < 0x000000000000000000000000000000000000000000001855368CA719414FBB03 >									
292 	//     < RE_Portfolio_IX_metadata_line_30_____Endurance_Specialty_Holdings_Limited_20250515 >									
293 	//        < 4bA5O0DK4Wh0ZNka0qv3f36wY6Qo789g8ZhkGoGmO0LiD5EO8120g7G5707v77p0 >									
294 	//        < 1E-018 limites [ 1084699261,5999 ; 1123329642,39898 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000019414FBB031A27910383 >									
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
338 	//     < RE_Portfolio_IX_metadata_line_31_____Endurance_Specialty_Holdings_Limited_20250515 >									
339 	//        < F510Gx7m9VNvRJBOX547ZvTKpB3kcyRAcpm1k1Q9JPHVDBGN7PmSO906Yn973jYc >									
340 	//        < 1E-018 limites [ 1123329642,39898 ; 1176216062,36013 ] >									
341 	//        < 0x000000000000000000000000000000000000000000001A279103831B62CB4950 >									
342 	//     < RE_Portfolio_IX_metadata_line_32_____Endurance_Specialty_Insurance_Limited__Montpelier_Reinsurance_Limited__A_A_20250515 >									
343 	//        < 5iromV0pBYZe98vgY56xWyS99ulp46f94wYk12vnB9c7PfgbT2KIP1Xt6j1m3f5e >									
344 	//        < 1E-018 limites [ 1176216062,36013 ; 1212196789,15603 ] >									
345 	//        < 0x000000000000000000000000000000000000000000001B62CB49501C394184B7 >									
346 	//     < RE_Portfolio_IX_metadata_line_33_____Eni_Insurance_Limited_A_20250515 >									
347 	//        < 91jxwPQ8H2Nd8MYF14DB3847igk1y64yOlGIxpJ4T7uU9s88RKdzM2XC4RO0mJ27 >									
348 	//        < 1E-018 limites [ 1212196789,15603 ; 1225897192,68736 ] >									
349 	//        < 0x000000000000000000000000000000000000000000001C394184B71C8AEAACD8 >									
350 	//     < RE_Portfolio_IX_metadata_line_34_____Enterprise_Reinsurance_20250515 >									
351 	//        < Fhiw2tJHuF3SJF0wEXS22Y2QzHICwP36U61vZCV2rFFzh6Wwn8g0Pi282KYp5Z6d >									
352 	//        < 1E-018 limites [ 1225897192,68736 ; 1244307994,52385 ] >									
353 	//        < 0x000000000000000000000000000000000000000000001C8AEAACD81CF8A75450 >									
354 	//     < RE_Portfolio_IX_metadata_line_35_____Equator_Reinsurances_Limited_Ap_20250515 >									
355 	//        < 7230XL5dcdUmmd2p19r73yA655TNfsz8C9T94W721sxhqc2p5FrlB5EPD39t271K >									
356 	//        < 1E-018 limites [ 1244307994,52385 ; 1283064101,15244 ] >									
357 	//        < 0x000000000000000000000000000000000000000000001CF8A754501DDFA87477 >									
358 	//     < RE_Portfolio_IX_metadata_line_36_____Equity_Syndicate_Management_Limited_20250515 >									
359 	//        < 0BG6pRvAV4F7EFVK1kvvjXi3T0djw5S9F8kWwM9TIaq34L43u56rx95lkUMpEZ90 >									
360 	//        < 1E-018 limites [ 1283064101,15244 ;  ] >									
361 	//        < 0x000000000000000000000000000000000000000000001DDFA874771E8D4BCDCE >									
362 	//     < RE_Portfolio_IX_metadata_line_37_____ERS_Syndicate_Management_Limited_20250515 >									
363 	//        < 3G8tQWhisWj6PTYym9fbzi7p0N46JpcQ8d9Fi7Ptc37FG3sI81659T39q0mHpb5R >									
364 	//        < 1E-018 limites [ 1312195737,22211 ; 1330508826,2292 ] >									
365 	//        < 0x000000000000000000000000000000000000000000001E8D4BCDCE1EFA735C32 >									
366 	//     < RE_Portfolio_IX_metadata_line_38_____ERS_Syndicate_Management_Limited_20250515 >									
367 	//        < 5F7bN446VBrp46aSb9sVhjcb58SJj815Kb4gjqH59t17uK8he42ZdegTW0pn57a9 >									
368 	//        < 1E-018 limites [ 1330508826,2292 ; 1372864750,2701 ] >									
369 	//        < 0x000000000000000000000000000000000000000000001EFA735C321FF6E95F07 >									
370 	//     < RE_Portfolio_IX_metadata_line_39_____ERS_Syndicate_Management_Limited_20250515 >									
371 	//        < 9yaSaA7h7cn3Qkd31qBke6Qv76m65xH2chLViy586WMTJfLxW0svsWMaco9ahljr >									
372 	//        < 1E-018 limites [ 1372864750,2701 ; 1392217700,90178 ] >									
373 	//        < 0x000000000000000000000000000000000000000000001FF6E95F07206A43A15E >									
374 	//     < RE_Portfolio_IX_metadata_line_40_____Euler_Hermes_Reinsurance_AG_AAm_m_20250515 >									
375 	//        < UIry0a7US3zbBvfL1639YTtQq6255ghkwLc7u8270BgvERu0VjSe3pzMlbw5iN0t >									
376 	//        < 1E-018 limites [ 1392217700,90178 ; 1404357449,53134 ] >									
377 	//        < 0x00000000000000000000000000000000000000000000206A43A15E20B29F6AAD >									
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