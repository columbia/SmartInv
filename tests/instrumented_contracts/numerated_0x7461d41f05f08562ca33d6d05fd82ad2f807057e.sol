1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RE_Portfolio_XIX_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RE_Portfolio_XIX_883		"	;
8 		string	public		symbol =	"	RE883XIX		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1340600412721820000000000000					;	
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
92 	//     < RE_Portfolio_XIX_metadata_line_1_____Thai_Reinsurance_Public_Company_20250515 >									
93 	//        < 6Xacg7qV0pmlCK86Ui8D1EfJYJT7KZ1E5GjoyNG0g6H6Kd3vsx473XyG3Y4nH61l >									
94 	//        < 1E-018 limites [ 1E-018 ; 36864781,5976893 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000DBBB3343 >									
96 	//     < RE_Portfolio_XIX_metadata_line_2_____Thailand_Asian_Re_20250515 >									
97 	//        < xz0s9bTrz7RR5756aBtCnB1A1F9zEzWe0X1218w8v16rByDe50700Nn59E2k4el1 >									
98 	//        < 1E-018 limites [ 36864781,5976893 ; 63941863,4799876 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000DBBB334317D1F8C5F >									
100 	//     < RE_Portfolio_XIX_metadata_line_3_____Thailand_BBBp_Asian_Re_m_Bp_20250515 >									
101 	//        < jdtil5D7nt3SuLJL2cg35xTx1NpnjBq3vZUwWckm7KaNbPW0peDYV1219fJY0JRc >									
102 	//        < 1E-018 limites [ 63941863,4799876 ; 111148150,472025 ] >									
103 	//        < 0x000000000000000000000000000000000000000000000017D1F8C5F2967EA03B >									
104 	//     < RE_Portfolio_XIX_metadata_line_4_____The_Channel_Managing_Agency_Limited_20250515 >									
105 	//        < 6U5Jv83h0rFK15oF15i0hSEiEQ7XfI1E047155jxuL0DsLlb0p8Hx6K41ZElNO71 >									
106 	//        < 1E-018 limites [ 111148150,472025 ; 183167663,472869 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000002967EA03B443C3AE7F >									
108 	//     < RE_Portfolio_XIX_metadata_line_5_____The_Channel_Managing_Agency_Limited_20250515 >									
109 	//        < TEtY8u1g3o714Cq066z3i6Rzj082U4e8nluoBYdvqFY91So7hTyI64r885EMuY9Z >									
110 	//        < 1E-018 limites [ 183167663,472869 ; 232397890,320488 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000443C3AE7F569330BDC >									
112 	//     < RE_Portfolio_XIX_metadata_line_6_____The_Fuji_Fire_&_Marine_Insurance_Co_Limited_Ap_m_20250515 >									
113 	//        < f4ERz1Wp71hM4XmLh4h943qjLr0tFpg4t0K6xvbM41ngAUm15xjN941yvb6peUFN >									
114 	//        < 1E-018 limites [ 232397890,320488 ; 244050519,202988 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000569330BDC5AEA78C04 >									
116 	//     < RE_Portfolio_XIX_metadata_line_7_____The_Mediterranean_&_Gulf_Insurance_&_Reinsurance_Company_Am_20250515 >									
117 	//        < 2n7ULJSoAaWNStOsq2IbEbWIHFY3X7t911a3OaHu695646hdD1RY4ZaD4wuCM4A2 >									
118 	//        < 1E-018 limites [ 244050519,202988 ; 278787034,066869 ] >									
119 	//        < 0x00000000000000000000000000000000000000000000005AEA78C0467DB34322 >									
120 	//     < RE_Portfolio_XIX_metadata_line_8_____The_Mediterranean_&_Gulf_Insurance_&_Reinsurance_Company_Am_20250515 >									
121 	//        < qFHigv1282OK1MR7hXH2bqR5x5MQQfevEz3yyh38N28J2fN36HtwmhMtwpo2v8WS >									
122 	//        < 1E-018 limites [ 278787034,066869 ; 307072893,163624 ] >									
123 	//        < 0x000000000000000000000000000000000000000000000067DB343227264C0ED8 >									
124 	//     < RE_Portfolio_XIX_metadata_line_9_____The_New_India_Assurance_Company_Limited_Am_20250515 >									
125 	//        < 8HW0tn493B8e1Q5L1KK51sOCWSwuHVq6l4323ldxR83XlaMl1a40p2O8R9768nk0 >									
126 	//        < 1E-018 limites [ 307072893,163624 ; 336339405,065176 ] >									
127 	//        < 0x00000000000000000000000000000000000000000000007264C0ED87D4BD360E >									
128 	//     < RE_Portfolio_XIX_metadata_line_10_____The_Oriental_Insurance_Company_Limited_Bpp_20250515 >									
129 	//        < x7eqCPp3OQna559cM4O53MR0Uebt21rt5J75D7FBk81Oh76ug66P75Q77XuU5q85 >									
130 	//        < 1E-018 limites [ 336339405,065176 ; 398265421,292264 ] >									
131 	//        < 0x00000000000000000000000000000000000000000000007D4BD360E945D8D025 >									
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
174 	//     < RE_Portfolio_XIX_metadata_line_11_____The_Toa_Reinsurance_Company_Limited_20250515 >									
175 	//        < C27HZf4FOaVYek5pX71243AS1BkKWRK5EVsbhjLk0FHT23W7N7I514Y9PG1ELvDl >									
176 	//        < 1E-018 limites [ 398265421,292264 ; 444981485,562693 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000945D8D025A5C4BDEC0 >									
178 	//     < RE_Portfolio_XIX_metadata_line_12_____Third_Point_Reinsurance_20250515 >									
179 	//        < fC0h29Rm9ocPohp9k7InnRo2vAz51YIlY88WsYK2c3rhIZ0Q1ZN28fI3jxq9pdkF >									
180 	//        < 1E-018 limites [ 444981485,562693 ; 506207468,160163 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000A5C4BDEC0BC93B4E34 >									
182 	//     < RE_Portfolio_XIX_metadata_line_13_____Toa_Re_Co_Ap_Ap_20250515 >									
183 	//        < 0F6Y2bYEjTQEty18YK1Yf8pU9Fnm7xkFLmDyHQvTFG1n9Ibtxm4C7OgWqT2IXZDZ >									
184 	//        < 1E-018 limites [ 506207468,160163 ; 552950676,871448 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000BC93B4E34CDFD7C81B >									
186 	//     < RE_Portfolio_XIX_metadata_line_14_____Tokio_Marine_Global_Re__Asia_Limited__20250515 >									
187 	//        < 4Uv7m9mj2c4tYBqpHP6Mdob500N05SIh1oRP2Rfqb2N822HqsuBGP3QmiI4qisfm >									
188 	//        < 1E-018 limites [ 552950676,871448 ; 585414558,533241 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000CDFD7C81BDA157BBE1 >									
190 	//     < RE_Portfolio_XIX_metadata_line_15_____Tokio_Marine_Holdings_Incorporated_20250515 >									
191 	//        < z95bDnU95A92kciV43h5sb2iZ7934ZS2t69z72Jc1Ws4PHAaS31Zh304VCgvB5TN >									
192 	//        < 1E-018 limites [ 585414558,533241 ; 602538129,447563 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000DA157BBE1E07683AC4 >									
194 	//     < RE_Portfolio_XIX_metadata_line_16_____Tokio_Marine_Kiln_Syndicates_Limited_20250515 >									
195 	//        < 6f4g2q9OeJV9c6VVvchEEnxr4Cv378e5yNB4nMrwtdy5V443S05kPc39XTc2HF06 >									
196 	//        < 1E-018 limites [ 602538129,447563 ; 628991114,826927 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000E07683AC4EA514482E >									
198 	//     < RE_Portfolio_XIX_metadata_line_17_____Tokio_Marine_Kiln_Syndicates_Limited_20250515 >									
199 	//        < iPt6B77Bl3RZ7h77fu88iO7ev488A2DjS4SZZxmencBOcET49Wp81gHOmA16l0E6 >									
200 	//        < 1E-018 limites [ 628991114,826927 ; 653664998,582608 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000EA514482EF3825A406 >									
202 	//     < RE_Portfolio_XIX_metadata_line_18_____Tokio_Marine_Kiln_Syndicates_Limited_20250515 >									
203 	//        < z8tE1C9pT508U5L9E4xTwNDi3807k9JZYk2uuR7i5ac5W8uyjo1tv409yFEjaZsU >									
204 	//        < 1E-018 limites [ 653664998,582608 ; 665148788,281526 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000F3825A406F7C988360 >									
206 	//     < RE_Portfolio_XIX_metadata_line_19_____Tokio_Marine_Kiln_Syndicates_Limited_20250515 >									
207 	//        < F5rbD2A4YFUm3t95c22MgJdko2IWDlDjD15B03u4Bn44nOxqF497Up68poE5l36F >									
208 	//        < 1E-018 limites [ 665148788,281526 ; 692363511,442255 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000F7C988360101ECEE29C >									
210 	//     < RE_Portfolio_XIX_metadata_line_20_____Tokio_Marine_Kiln_Syndicates_Limited_20250515 >									
211 	//        < 71qm6JMO9DdJ9dokd6M8010L8EP18g8g7QQbWisuxf0SOt3jOjriAgHtTxEPx4t6 >									
212 	//        < 1E-018 limites [ 692363511,442255 ; 724633371,593046 ] >									
213 	//        < 0x00000000000000000000000000000000000000000000101ECEE29C10DF26C8BB >									
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
256 	//     < RE_Portfolio_XIX_metadata_line_21_____Tokio_Marine_Kiln_Syndicates_Limited_20250515 >									
257 	//        < NtO4R5z8Hmq5gyTbb27oq3w879404Q7c7vAGxPb54wIFKgrsHL91QQ319PF7IgNW >									
258 	//        < 1E-018 limites [ 724633371,593046 ; 797817953,472696 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000010DF26C8BB12935D9807 >									
260 	//     < RE_Portfolio_XIX_metadata_line_22_____Tokio_Marine_Kiln_Syndicates_Limited_20250515 >									
261 	//        < b5Vq3e1JmThrk9aVq0BkT6H9rgC5886X04cLS8LKu5Kbn2ethsP01gxK359I9D0M >									
262 	//        < 1E-018 limites [ 797817953,472696 ; 826159686,009524 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000012935D9807133C4BA54C >									
264 	//     < RE_Portfolio_XIX_metadata_line_23_____Tokio_Marine_Kiln_Syndicates_Limited_20250515 >									
265 	//        < bagbt2n0F5CFG1Aaj6eH5ls5qnElLCnMN0L0P87O765u41AC0ChA93ZFGB6aEPTu >									
266 	//        < 1E-018 limites [ 826159686,009524 ; 837798262,824859 ] >									
267 	//        < 0x00000000000000000000000000000000000000000000133C4BA54C1381AAB45E >									
268 	//     < RE_Portfolio_XIX_metadata_line_24_____Tokio_Marine_Kiln_Syndicates_Limited_20250515 >									
269 	//        < y6fsIS3j1m8vv4eZ9whZ54VoS8CbFSz16V9QKtZ6xYDrfq6uf0rUxK7DJr1837Mq >									
270 	//        < 1E-018 limites [ 837798262,824859 ; 856011397,919842 ] >									
271 	//        < 0x000000000000000000000000000000000000000000001381AAB45E13EE39BE43 >									
272 	//     < RE_Portfolio_XIX_metadata_line_25_____Tokio_Marine_Nichido&_Fire_Ins_Co_Ap_App_20250515 >									
273 	//        < 75fl1uTS32nKG3OT9Pw5Ot8Y5LAmU43x0kGKoX82k4vnU95Dwztn12G6a3ESuCIk >									
274 	//        < 1E-018 limites [ 856011397,919842 ; 904493694,143151 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000013EE39BE43150F33DB3A >									
276 	//     < RE_Portfolio_XIX_metadata_line_26_____Torus_Underwriting_Management_Limited_20250515 >									
277 	//        < I12A7dRCEI2meH2ft5Cd6K7U7w9RMpQ3JLSwW1x49X5DEMFh0m0r2AElUyabMIFy >									
278 	//        < 1E-018 limites [ 904493694,143151 ; 925858141,165202 ] >									
279 	//        < 0x00000000000000000000000000000000000000000000150F33DB3A158E8B6A58 >									
280 	//     < RE_Portfolio_XIX_metadata_line_27_____Towers_Perrin_Reinsurance_20250515 >									
281 	//        < P1Gq46BCkvTcbhi1MGYTv588qA2CMse4xLrS9yoB0m1j9tr8l8Zusi31OSX137AP >									
282 	//        < 1E-018 limites [ 925858141,165202 ; 972670559,352482 ] >									
283 	//        < 0x00000000000000000000000000000000000000000000158E8B6A5816A5917F33 >									
284 	//     < RE_Portfolio_XIX_metadata_line_28_____Trans_Re_Zurich_Ap_Ap_20250515 >									
285 	//        < KU27aNuH8Ws1P056Spm5T6l5of15zm5GRkcQ5k5X6dB39S72r2BVPS9U90d31p55 >									
286 	//        < 1E-018 limites [ 972670559,352482 ; 1003445887,17497 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000016A5917F33175D00EBA1 >									
288 	//     < RE_Portfolio_XIX_metadata_line_29_____Transamerica_Reinsurance_20250515 >									
289 	//        < e6moO2T5A1i3E9iR4TVjMr76xI74u0j0STEZb3yx1wXdvv8AMxNaN9CN0q6VxCAK >									
290 	//        < 1E-018 limites [ 1003445887,17497 ; 1052832072,74501 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000175D00EBA118835E425E >									
292 	//     < RE_Portfolio_XIX_metadata_line_30_____Transatlantic_Holdings_Inc_20250515 >									
293 	//        < 46tMpDbp7q137KJzXfmVY6tyaB1ewU0W5870841Nwz9KQhsQst6iffUEMzL4ZCRw >									
294 	//        < 1E-018 limites [ 1052832072,74501 ; 1071982514,72323 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000018835E425E18F58383C4 >									
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
338 	//     < RE_Portfolio_XIX_metadata_line_31_____Transatlantic_Holdings_Incorporated_20250515 >									
339 	//        < mW5qxaV89E18KD5Z2RzfbZu3EwR5By3OFVv5X73vShbWYyk7koUyjR1FwEpGGDgw >									
340 	//        < 1E-018 limites [ 1071982514,72323 ; 1131282169,57941 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000018F58383C41A56F79B71 >									
342 	//     < RE_Portfolio_XIX_metadata_line_32_____Transatlantic_Re_Co_Ap_Ap_20250515 >									
343 	//        < 575zQ849jD7242nj6Bfdze2t4RVPlIVS9olpD2b633ayOnYVJGPT6jfJ071l2RDl >									
344 	//        < 1E-018 limites [ 1131282169,57941 ; 1148292341,15667 ] >									
345 	//        < 0x000000000000000000000000000000000000000000001A56F79B711ABC5B11B7 >									
346 	//     < RE_Portfolio_XIX_metadata_line_33_____Transatlantic_Reinsurance_Company_20250515 >									
347 	//        < 7U4iRcxih6bX09Kc46r4vzWlt7Oqa700Zp4szm674bt6pUMO4rDw1i9khwM8zXf5 >									
348 	//        < 1E-018 limites [ 1148292341,15667 ; 1167136300,51226 ] >									
349 	//        < 0x000000000000000000000000000000000000000000001ABC5B11B71B2CACAB57 >									
350 	//     < RE_Portfolio_XIX_metadata_line_34_____TransRe_London_Limited_Ap_20250515 >									
351 	//        < rsfbdcGB3Ha1l60W97Oj5O39zNmXjI3DKi798W4pv4W00l6U9g0VRy06j8HRrQOC >									
352 	//        < 1E-018 limites [ 1167136300,51226 ; 1191694904,72507 ] >									
353 	//        < 0x000000000000000000000000000000000000000000001B2CACAB571BBF0E201C >									
354 	//     < RE_Portfolio_XIX_metadata_line_35_____Travelers_Companies_inc_Ap_20250515 >									
355 	//        < LW88do6tS3Tecid7vhspU9uO9Dk71K3u55x93n93IMvH17b4A9MGo8MOPreMo3Xm >									
356 	//        < 1E-018 limites [ 1191694904,72507 ; 1204457921,47698 ] >									
357 	//        < 0x000000000000000000000000000000000000000000001BBF0E201C1C0B20F187 >									
358 	//     < RE_Portfolio_XIX_metadata_line_36_____Travelers_insurance_Co_A_20250515 >									
359 	//        < SAn1Xal1iTdOyy93T1ZWq18iGD31hmoZ9WBSD0pw35dH1JqLLcKJGD4hSnO0O5q8 >									
360 	//        < 1E-018 limites [ 1204457921,47698 ;  ] >									
361 	//        < 0x000000000000000000000000000000000000000000001C0B20F1871C8A40B8DB >									
362 	//     < RE_Portfolio_XIX_metadata_line_37_____Travelers_Syndicate_Management_Limited_20250515 >									
363 	//        < m33tL2DET1N5IfqkQy1z9Tw2ElQ48E99HZq24kH00Z61SAPff92cyEHoqDTnbj33 >									
364 	//        < 1E-018 limites [ 1225785812,23849 ; 1245765107,96977 ] >									
365 	//        < 0x000000000000000000000000000000000000000000001C8A40B8DB1D0156B540 >									
366 	//     < RE_Portfolio_XIX_metadata_line_38_____Travelers_Syndicate_Management_Limited_20250515 >									
367 	//        < D9s016f658m026HP66qaoGlovX72HLUwILoN7uPIeOr28I1ml1ey1E8BejNsS97M >									
368 	//        < 1E-018 limites [ 1245765107,96977 ; 1280751310,25896 ] >									
369 	//        < 0x000000000000000000000000000000000000000000001D0156B5401DD1DF6A85 >									
370 	//     < RE_Portfolio_XIX_metadata_line_39_____Travelers_Syndicate_Management_Limited_20250515 >									
371 	//        < 6U5dHCsHKpsER95yn91gfu5A1r049Vj8eEy74196r8n7WyTLycewi7r3pac7X11E >									
372 	//        < 1E-018 limites [ 1280751310,25896 ; 1315420823,44311 ] >									
373 	//        < 0x000000000000000000000000000000000000000000001DD1DF6A851EA084E51C >									
374 	//     < RE_Portfolio_XIX_metadata_line_40_____Triglav_Reinsurance_Co_A_20250515 >									
375 	//        < iT1Dw4CktA63FFDv2h9wr29Bz3N5zJbRL8uD1F51hVEAB9wpa70Ug744MCBy638t >									
376 	//        < 1E-018 limites [ 1315420823,44311 ; 1340600412,72182 ] >									
377 	//        < 0x000000000000000000000000000000000000000000001EA084E51C1F3699E62C >									
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