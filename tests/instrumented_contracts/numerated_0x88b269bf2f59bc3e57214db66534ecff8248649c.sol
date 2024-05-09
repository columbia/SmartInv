1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RE_Portfolio_XVII_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RE_Portfolio_XVII_883		"	;
8 		string	public		symbol =	"	RE883XVII		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1563129872774660000000000000					;	
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
92 	//     < RE_Portfolio_XVII_metadata_line_1_____Reinsurance_Research_Council_20250515 >									
93 	//        < qm6Q02Aj145ts6T00DM0wfCSGPb93mzqx7HHlH3dLpg6C8302d8p222RRSHLIiHf >									
94 	//        < 1E-018 limites [ 1E-018 ; 66649156,8621176 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000018D428CDA >									
96 	//     < RE_Portfolio_XVII_metadata_line_2_____Reinsurance_Solutions_International_20250515 >									
97 	//        < 0O9dSBr57eKkz995E6a35NkfGP0VKg0ww0Izgf86H113g9KR261o832hLm5Gp3s2 >									
98 	//        < 1E-018 limites [ 66649156,8621176 ; 102122323,191998 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000018D428CDA260B24E73 >									
100 	//     < RE_Portfolio_XVII_metadata_line_3_____Reliance_Reinsurance_20250515 >									
101 	//        < 73OsR47YVg2bJF2jVe0sy0y1tAkVKrLXLE4241Vh2aM09C9W9VDJn13hoaV8aYZk >									
102 	//        < 1E-018 limites [ 102122323,191998 ; 151460586,825799 ] >									
103 	//        < 0x0000000000000000000000000000000000000000000000260B24E73386C685AE >									
104 	//     < RE_Portfolio_XVII_metadata_line_4_____Renaissance_Reinsurance_20250515 >									
105 	//        < 2P6lQ6YMyZkTbQfx9k1htWIZE0VEJYZybE7HRAbXHP7lrlpx5X1K6o9J2zrVsIOg >									
106 	//        < 1E-018 limites [ 151460586,825799 ; 164902193,27429 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000386C685AE3D6E4C933 >									
108 	//     < RE_Portfolio_XVII_metadata_line_5_____RenaissanceRe_Holdings_Limited_20250515 >									
109 	//        < ZGJPzt5nkfWc3zij7Li2OqP61M1UL82VLAfHk0OR0oxQ2Jn73r179O9Uf9ot15d9 >									
110 	//        < 1E-018 limites [ 164902193,27429 ; 202828094,342709 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000003D6E4C9334B8F31E4E >									
112 	//     < RE_Portfolio_XVII_metadata_line_6_____RenaissanceRe_Holdings_Limited_20250515 >									
113 	//        < 2LVo7CI7e0FYYGq06t93I5ckE8Q5C980k01k04GbviJebJ0d5Yb6JNMEDH9R8lXJ >									
114 	//        < 1E-018 limites [ 202828094,342709 ; 213411057,081716 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000004B8F31E4E4F8077020 >									
116 	//     < RE_Portfolio_XVII_metadata_line_7_____RenaissanceRe_Holdings_Limited_20250515 >									
117 	//        < dt1865bWayXLgSu1N0jGxZoVx221KQQbS26zx8308adkv479vGf2F4bY1rtV3G8o >									
118 	//        < 1E-018 limites [ 213411057,081716 ; 242012797,119591 ] >									
119 	//        < 0x00000000000000000000000000000000000000000000004F80770205A2823AD3 >									
120 	//     < RE_Portfolio_XVII_metadata_line_8_____RenaissanceRe_Syndicate_Management_Limited_20250515 >									
121 	//        < 371c9sc85X3hHHN8QSU4Ozu9m1FUl46Q18pMeU7kFh8u59D687e7P40W0gdVa9if >									
122 	//        < 1E-018 limites [ 242012797,119591 ; 261274562,124983 ] >									
123 	//        < 0x00000000000000000000000000000000000000000000005A2823AD36155159C8 >									
124 	//     < RE_Portfolio_XVII_metadata_line_9_____RenaissanceRe_Syndicate_Management_Limited_20250515 >									
125 	//        < j6OmZ4Nyx0qqKvs7FQjqLWVOGzfH3Y80WMVLt5F1o6EHi789V24O0R457ZbIo68h >									
126 	//        < 1E-018 limites [ 261274562,124983 ; 273438019,142179 ] >									
127 	//        < 0x00000000000000000000000000000000000000000000006155159C865DD1502E >									
128 	//     < RE_Portfolio_XVII_metadata_line_10_____Republic_Western_Insurance_20250515 >									
129 	//        < 76BwRMoNypz12HN7UK6aHl4651mNz16DhUYWli89d1gn95pgas2jbE438YXX809C >									
130 	//        < 1E-018 limites [ 273438019,142179 ; 289504354,439651 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000065DD1502E6BD949867 >									
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
174 	//     < RE_Portfolio_XVII_metadata_line_11_____RGA_International_Re_Co_Limit_AAm_20250515 >									
175 	//        < F1890Ak3N7mt9I3O7ulvqmZ8sd6tm7rI4TDe3k64NC11YquCOOCF6c3lPSzPPh05 >									
176 	//        < 1E-018 limites [ 289504354,439651 ; 350711422,267671 ] >									
177 	//        < 0x00000000000000000000000000000000000000000000006BD94986782A672B46 >									
178 	//     < RE_Portfolio_XVII_metadata_line_12_____RGA_International_Reinsurance_Co_Limited_AAm_20250515 >									
179 	//        < 5woc7HEQ2bsRm8hWxAzh36sD04j2MlW5ncDgnzarP04hDUo048Xr6559x0RoWUU7 >									
180 	//        < 1E-018 limites [ 350711422,267671 ; 393308773,192233 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000082A672B469284D917B >									
182 	//     < RE_Portfolio_XVII_metadata_line_13_____Ridge_Underwriting_Agencies_Limited_20250515 >									
183 	//        < kzHU779R7j9f2pVKFUVk8xa6yGCM3dO5HDX4lSyFIo27guz1NTs2z0BFTyl49vIa >									
184 	//        < 1E-018 limites [ 393308773,192233 ; 446866592,043051 ] >									
185 	//        < 0x00000000000000000000000000000000000000000000009284D917BA67885078 >									
186 	//     < RE_Portfolio_XVII_metadata_line_14_____RITC_Syndicate_Management_Limited_20250515 >									
187 	//        < hIhfvD9IHLFl41IZ6zp4q9Y9XL680Xol8cNFS912z8r27QD11rId1ydm7LQELs1K >									
188 	//        < 1E-018 limites [ 446866592,043051 ; 468481758,857593 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000A67885078AE85E7101 >									
190 	//     < RE_Portfolio_XVII_metadata_line_15_____RITC_Syndicate_Management_Limited_20250515 >									
191 	//        < 8A90p5wt70VyZTI4j2T7HJ0n16gGn57wOS0l0JlFKf2V1EE1vQXOxu4nwSTY053i >									
192 	//        < 1E-018 limites [ 468481758,857593 ; 482544258,896634 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000AE85E7101B3C301D15 >									
194 	//     < RE_Portfolio_XVII_metadata_line_16_____Riverstone_Managing_Agency_Limited_20250515 >									
195 	//        < 84Gn1zPavc9472gN631ut1I960KLsk7lqdZU0eBdS8784Zj8rOTuN3WF2YiiXhbz >									
196 	//        < 1E-018 limites [ 482544258,896634 ; 494183192,87572 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000B3C301D15B818FB7AB >									
198 	//     < RE_Portfolio_XVII_metadata_line_17_____RiverStone_Managing_Agency_Limited_20250515 >									
199 	//        < IQd7R8m0fvD7ctlAwzRJG7A6DX4lGY0Bd8OeLb3sMyK89zuAou82v5h86z3Ca2Kd >									
200 	//        < 1E-018 limites [ 494183192,87572 ; 549334957,019866 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000B818FB7ABCCA4AA189 >									
202 	//     < RE_Portfolio_XVII_metadata_line_18_____Romania_BBBm_Astra_Asigurari_20250515 >									
203 	//        < I8fq42F5Foui35760yz22k0w6R26cC7PWu8owYGm97J9uPeD1G6Xo3kyB1TJqWV7 >									
204 	//        < 1E-018 limites [ 549334957,019866 ; 572848734,803152 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000CCA4AA189D5671CEFC >									
206 	//     < RE_Portfolio_XVII_metadata_line_19_____Royal_&_Sun_Alliance_Reinsurance_Limited_A_m_20250515 >									
207 	//        < w242gOOR25Us6um1u8l71LkYbmd7BJWN65E5LhAh526Q6XB90181jBQU4nGzNt9G >									
208 	//        < 1E-018 limites [ 572848734,803152 ; 589000136,166686 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000D5671CEFCDB6B6E424 >									
210 	//     < RE_Portfolio_XVII_metadata_line_20_____RUV_Versicherung_AG_20250515 >									
211 	//        < VZE1P98X8mArv1ACrEfXH1qJ15II980S1QO9d5ePT1RxH1Er2s0gE34SVnh8Ha64 >									
212 	//        < 1E-018 limites [ 589000136,166686 ; 646640336,006221 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000DB6B6E424F0E46DB34 >									
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
256 	//     < RE_Portfolio_XVII_metadata_line_21_____S_A_Meacock_and_Company_Limited_20250515 >									
257 	//        < fePjI68GX312ZR49D8T9p7kFBGZS1iRH23qR29w5f7Gy0c274850e82L15fsDpPT >									
258 	//        < 1E-018 limites [ 646640336,006221 ; 721053372,819782 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000F0E46DB3410C9D023B5 >									
260 	//     < RE_Portfolio_XVII_metadata_line_22_____SA_Meacock_and_Company_Limited_20250515 >									
261 	//        < A1ICmPHTq18xXQqJO73F3YXvy22T36C07i64Ax6L4h7Np2U237Gi9UpXZmUUTjTr >									
262 	//        < 1E-018 limites [ 721053372,819782 ; 795466519,12577 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000010C9D023B512855996FC >									
264 	//     < RE_Portfolio_XVII_metadata_line_23_____SAC_RE_Limited_20250515 >									
265 	//        < MtynOS1kmRP3C9n55rW5P070ugSdd589GvNW44ZpF07OFwNz3C53llc7XpLLZaDi >									
266 	//        < 1E-018 limites [ 795466519,12577 ; 818365818,686248 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000012855996FC130DD725E0 >									
268 	//     < RE_Portfolio_XVII_metadata_line_24_____Sagicor_at_Lloyd_s_Limited_20250515 >									
269 	//        < d28I4Cd639Wr5RNlqv6T9rPr9PSY0n6PAU98evTFQGICilrgwY8E4pD5R0L35f3j >									
270 	//        < 1E-018 limites [ 818365818,686248 ; 890688210,882252 ] >									
271 	//        < 0x00000000000000000000000000000000000000000000130DD725E014BCEA5C54 >									
272 	//     < RE_Portfolio_XVII_metadata_line_25_____Samsung_Fire_&_Marine_in_co_Limited_AAm_20250515 >									
273 	//        < p4qWenq0PZX84IEB0h1Gi4gll1Sl5sqJuY2jB7kGj7J7740TxM0c6giPr57yZ0Ne >									
274 	//        < 1E-018 limites [ 890688210,882252 ; 969497433,596497 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000014BCEA5C541692A7B0F3 >									
276 	//     < RE_Portfolio_XVII_metadata_line_26_____Saudi_Arabia_AAm_Saudi_Re_for_Cooperative_Reinsurance_Co_BBBp_m_20250515 >									
277 	//        < cP5jh2Ef308XM3Yt7kdsihL2Da5603LOr8d3d35b5ByHaKMP88pZuWFmx4TXHVDx >									
278 	//        < 1E-018 limites [ 969497433,596497 ; 987038135,9652 ] >									
279 	//        < 0x000000000000000000000000000000000000000000001692A7B0F316FB34ADD0 >									
280 	//     < RE_Portfolio_XVII_metadata_line_27_____Saudi_Arabian_Insurance_Am_20250515 >									
281 	//        < Hw826gcc780j3SoH1s8Arl72fc2MPWDTOr3We8zyjQONjqKC66zs72oXLO969kYE >									
282 	//        < 1E-018 limites [ 987038135,9652 ; 1039763617,32425 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000016FB34ADD018357960F8 >									
284 	//     < RE_Portfolio_XVII_metadata_line_28_____Saudi_Arabian_Insurance_Am_20250515 >									
285 	//        < fNqZMr39ow8zZbd874N7Xx4hwn9lMXE5bk74BpYWpWj2K38BbJR107dC46xYkCFk >									
286 	//        < 1E-018 limites [ 1039763617,32425 ; 1092036791,0843 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000018357960F8196D0BE978 >									
288 	//     < RE_Portfolio_XVII_metadata_line_29_____SCOR_20250515 >									
289 	//        < 28ZPMTKMK43VbL9FS877HQS9zriNAo50m6ImqUdJHI5cq8vAOH9T1BC7j131jf3K >									
290 	//        < 1E-018 limites [ 1092036791,0843 ; 1120639740,70763 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000196D0BE9781A17888CAA >									
292 	//     < RE_Portfolio_XVII_metadata_line_30_____SCOR_20250515 >									
293 	//        < GQjn6QOz7OgVONSFZiGzb6z6IT0iuLoVVmyE20wVu5z9W0yrFe4TuJ32CNf4fI6t >									
294 	//        < 1E-018 limites [ 1120639740,70763 ; 1182540752,26608 ] >									
295 	//        < 0x000000000000000000000000000000000000000000001A17888CAA1B887DFF4E >									
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
338 	//     < RE_Portfolio_XVII_metadata_line_31_____SCOR_20250515 >									
339 	//        < P857TQjxHo12yoqrnW1gtHM842h0C1JOZ9S2o4097wT0T68I94rnoOtEL28757Cj >									
340 	//        < 1E-018 limites [ 1182540752,26608 ; 1193519281,05685 ] >									
341 	//        < 0x000000000000000000000000000000000000000000001B887DFF4E1BC9EDE71D >									
342 	//     < RE_Portfolio_XVII_metadata_line_32_____SCOR_Global_Life_SE_AAm_A_20250515 >									
343 	//        < 2FT1n46P12ZAE8Jz614N56L0w9mn3L3xHxJ096Dw7xFqoJb1iDBKJ9HO8EtN69jU >									
344 	//        < 1E-018 limites [ 1193519281,05685 ; 1209508505,67561 ] >									
345 	//        < 0x000000000000000000000000000000000000000000001BC9EDE71D1C293B85FB >									
346 	//     < RE_Portfolio_XVII_metadata_line_33_____Scor_SE_20250515 >									
347 	//        < 9gI4lliSsLX8U5Cdfa34zp9Z9v5CE3ZOf84Msbb9S52R6757qrzB19OHzPs75j2e >									
348 	//        < 1E-018 limites [ 1209508505,67561 ; 1268547499,53517 ] >									
349 	//        < 0x000000000000000000000000000000000000000000001C293B85FB1D8921E0F5 >									
350 	//     < RE_Portfolio_XVII_metadata_line_34_____SCOR_SE_AAm_A_20250515 >									
351 	//        < LHMr9fn75mh59MmYMh5gareRNTLoX6M0a8t3F08Q6cSyXN37P233vNmvX328fb64 >									
352 	//        < 1E-018 limites [ 1268547499,53517 ; 1316789437,2124 ] >									
353 	//        < 0x000000000000000000000000000000000000000000001D8921E0F51EA8AD3BDD >									
354 	//     < RE_Portfolio_XVII_metadata_line_35_____SCOR_UK_Company_Limited_A_20250515 >									
355 	//        < 2Xgg4Vo0Sl01uFXp2701pg82FgJ5iH7Rs66SG7rtRdyf4TUN38xvC8PD2ew66h59 >									
356 	//        < 1E-018 limites [ 1316789437,2124 ; 1334591476,70819 ] >									
357 	//        < 0x000000000000000000000000000000000000000000001EA8AD3BDD1F12C8FD8A >									
358 	//     < RE_Portfolio_XVII_metadata_line_36_____Scottish_Re_20250515 >									
359 	//        < 7Ln56pONXgsgjQ5t1q4s0oZ0rERNGg9Nsnym0QeKPqjInINm4kWC009ZDuF23uhL >									
360 	//        < 1E-018 limites [ 1334591476,70819 ;  ] >									
361 	//        < 0x000000000000000000000000000000000000000000001F12C8FD8A1FB1E5D790 >									
362 	//     < RE_Portfolio_XVII_metadata_line_37_____Shelbourne_Syndicate_Services_Limited_20250515 >									
363 	//        < Mer4HItM816fy42OfggK8GKZOp45uPv11CwB2f4P1Nps8hHsM4A8O7bxWrY5P5hW >									
364 	//        < 1E-018 limites [ 1361286158,36557 ; 1394796329,78922 ] >									
365 	//        < 0x000000000000000000000000000000000000000000001FB1E5D7902079A24E46 >									
366 	//     < RE_Portfolio_XVII_metadata_line_38_____SIAT_m_Societá_Italiana_Assicurazioni_e_Riassicurazioni_pA_Am_20250515 >									
367 	//        < aK9JLf9e0N55O0uYFb3IJn38CW76eNVX4lMXO0H04ru3ZfIpoCu7r6QU1i8PkoSZ >									
368 	//        < 1E-018 limites [ 1394796329,78922 ; 1428673158,99868 ] >									
369 	//        < 0x000000000000000000000000000000000000000000002079A24E4621438E3EAF >									
370 	//     < RE_Portfolio_XVII_metadata_line_39_____Singapore_Reinsurance_20250515 >									
371 	//        < BiupkAEyIABHtgmgxL3284TgqFtJYU5SCI9N1Gxiax3M7D3bD41Oxk1kV2Eqpcn0 >									
372 	//        < 1E-018 limites [ 1428673158,99868 ; 1487993588,85547 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000021438E3EAF22A5220999 >									
374 	//     < RE_Portfolio_XVII_metadata_line_40_____Sinopec_Insurance_Limited_Ap_20250515 >									
375 	//        < 92h7i5Mr80p955Ah9k9Xjc1rv73O5jI8GGGL6NzG09R6384v426wlMBbKzlDLw2t >									
376 	//        < 1E-018 limites [ 1487993588,85547 ; 1563129872,77466 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000022A52209992464FAE881 >									
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