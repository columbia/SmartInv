1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RE_Portfolio_XIV_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RE_Portfolio_XIV_883		"	;
8 		string	public		symbol =	"	RE883XIV		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1544348011475110000000000000					;	
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
92 	//     < RE_Portfolio_XIV_metadata_line_1_____Montpelier_Underwriting_Agencies_Limited_20250515 >									
93 	//        < x5Vts2z5Cq772X6WtJR8pW1Un7OKQI6a5LpsEKc73NKQuo3Z4BeK3ME9ugSrw0d9 >									
94 	//        < 1E-018 limites [ 1E-018 ; 12117403,5211375 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000004839B2B4 >									
96 	//     < RE_Portfolio_XIV_metadata_line_2_____Montpelier_Underwriting_Agencies_Limited_20250515 >									
97 	//        < pB5A0Lm77lsvV296vJfouKCB8N333Xs2508O6b6UgQ66u138yYtZr4e6QuGKVG1B >									
98 	//        < 1E-018 limites [ 12117403,5211375 ; 72283429,5542331 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000004839B2B41AED7C49F >									
100 	//     < RE_Portfolio_XIV_metadata_line_3_____MS_Amlin_Plc_20250515 >									
101 	//        < 57j804app68uttTCx2jHn2WLgxKr8u25t86810z4lk85YTlaGQaqGOU5I7515jek >									
102 	//        < 1E-018 limites [ 72283429,5542331 ; 138917010,987791 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000001AED7C49F33C028B5E >									
104 	//     < RE_Portfolio_XIV_metadata_line_4_____MS_Amlin_PLC_BBBp_20250515 >									
105 	//        < UUkeeea0A82Anx8usU2jQL5q1pmfjF415K83mL2FVjio0ixb7qk1WNp3Np3KO1Xs >									
106 	//        < 1E-018 limites [ 138917010,987791 ; 150740217,679471 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000033C028B5E3827B537B >									
108 	//     < RE_Portfolio_XIV_metadata_line_5_____MS_Amlin_Underwriting_Limited_20250515 >									
109 	//        < WMZ8C6Q5qZ53c9i7MeWiCAHPXv0NZyaoHPnDB0HZNFpZSAlXKLD0O2IabUMfga1g >									
110 	//        < 1E-018 limites [ 150740217,679471 ; 194247264,480008 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000003827B537B485CDCFA4 >									
112 	//     < RE_Portfolio_XIV_metadata_line_6_____MS_Amlin_Underwriting_Limited_20250515 >									
113 	//        < gM6o88XIxz05817IE6RyU9zbNxzs6VX19A86m59AowccUB8Bow7mVH5e5F64VqSa >									
114 	//        < 1E-018 limites [ 194247264,480008 ; 219903880,764582 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000485CDCFA451EBAB360 >									
116 	//     < RE_Portfolio_XIV_metadata_line_7_____MS_Amlin_Underwriting_Limited_20250515 >									
117 	//        < f4tDM6YTsAqP7U6F817QBAEn1O9alV3iM19VH1ztZTosrl2K0Ya28M28oR88fX6b >									
118 	//        < 1E-018 limites [ 219903880,764582 ; 261370390,417575 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000051EBAB360615E392B5 >									
120 	//     < RE_Portfolio_XIV_metadata_line_8_____MSAD_Insurance_Group_Holdings_Incorporated_20250515 >									
121 	//        < xZssI11x93PJf0375DKLKMykmInbAXC03Fqcb0BouplFVZqX59H6i9i29ocy2LPS >									
122 	//        < 1E-018 limites [ 261370390,417575 ; 310154419,08619 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000615E392B5738AA17E8 >									
124 	//     < RE_Portfolio_XIV_metadata_line_9_____Munchener_Ruck_Munich_Re__Ap_20250515 >									
125 	//        < GF8XEi8d8Pd6SeUhT75Ut4Zz51e3Po8w5KYJ2GBE3QX9rXH7z5667eH4xUy59d9H >									
126 	//        < 1E-018 limites [ 310154419,08619 ; 351448543,719141 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000738AA17E882ECBED57 >									
128 	//     < RE_Portfolio_XIV_metadata_line_10_____Munich_American_Reassurance_Company_20250515 >									
129 	//        < leXW729EvKBt9T0nMoSUWGb1791sxX67ROBV1aQOi24TCp56AsB5TSMQHNkszOkO >									
130 	//        < 1E-018 limites [ 351448543,719141 ; 368934345,889944 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000082ECBED578970524D0 >									
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
174 	//     < RE_Portfolio_XIV_metadata_line_11_____Munich_Re_Group_20250515 >									
175 	//        < nSKL2c363g3BLa5Z8I4OsBH9AP9800H9aNNUX9815uM3m06BjMfhYmJL7x9oL2ui >									
176 	//        < 1E-018 limites [ 368934345,889944 ; 389958536,948538 ] >									
177 	//        < 0x00000000000000000000000000000000000000000000008970524D0914558372 >									
178 	//     < RE_Portfolio_XIV_metadata_line_12_____Munich_Re_Group_20250515 >									
179 	//        < Fi40jHIdQO5bOCsCE8684H10HHM104O32b4XNqZVG098IMb6Z9LjwDSw44MzqN5I >									
180 	//        < 1E-018 limites [ 389958536,948538 ; 435388713,555604 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000914558372A231E762F >									
182 	//     < RE_Portfolio_XIV_metadata_line_13_____Munich_Re_Group_20250515 >									
183 	//        < YW49f5KG8LP4TBS9m04sbW77F8Y770k387Oj7hy6FvvVzwaGiQCdN75KxH36aLwh >									
184 	//        < 1E-018 limites [ 435388713,555604 ; 486969634,303127 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000A231E762FB5690B35A >									
186 	//     < RE_Portfolio_XIV_metadata_line_14_____Munich_Re_Syndicate_Limited_20250515 >									
187 	//        < IG3X3F9KZ5i84Gp33LE4v2GT9l2I71uX0FrsbOnTmWXyoJZ3YAJpItKm856bLk09 >									
188 	//        < 1E-018 limites [ 486969634,303127 ; 498847945,56237 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000B5690B35AB9D5D90B0 >									
190 	//     < RE_Portfolio_XIV_metadata_line_15_____Munich_Re_Syndicate_Limited_20250515 >									
191 	//        < zzwsgEhuK5KSx2QKdu0ltIOC0JA8rOSVa89F4CfF7IP5u893IUjM82F7mIJm7oFa >									
192 	//        < 1E-018 limites [ 498847945,56237 ; 518787182,556995 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000B9D5D90B0C14366D23 >									
194 	//     < RE_Portfolio_XIV_metadata_line_16_____Munich_Re_Syndicate_Limited_20250515 >									
195 	//        < 1h3l2OaHHBHAvoV9ab04z8aq63Qv03hjGGg5BrE28VRm2hU5RnMi604J5itY5369 >									
196 	//        < 1E-018 limites [ 518787182,556995 ; 538720502,724537 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000C14366D23C8B064254 >									
198 	//     < RE_Portfolio_XIV_metadata_line_17_____Munich_Reinsurance_Company_20250515 >									
199 	//        < 6in8MpHCS3AX9y2wU54pKw7aF2t7cZL6Sn7iC9E00KJR6FUhY3eXCr4PCw9Gq8pe >									
200 	//        < 1E-018 limites [ 538720502,724537 ; 561929625,744253 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000C8B064254D155C9202 >									
202 	//     < RE_Portfolio_XIV_metadata_line_18_____Mutual_Reinsurance_Bureau_20250515 >									
203 	//        < m0STK0z318eYLHL98AEP23if1RpEDVh12a8tI6V63pha1g9NN2Ipbq734abwmz6R >									
204 	//        < 1E-018 limites [ 561929625,744253 ; 572623162,432259 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000D155C9202D55199CC7 >									
206 	//     < RE_Portfolio_XIV_metadata_line_19_____National_General_Insurance_Company__PSC__m_Am_20250515 >									
207 	//        < u4Uebd8v979X8Hp6Pk47572GZq7Jp1W6g316xW6VpeoDSjZ1YB2fSh0R9hY47ck9 >									
208 	//        < 1E-018 limites [ 572623162,432259 ; 606718391,550442 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000D55199CC7E2052CDA7 >									
210 	//     < RE_Portfolio_XIV_metadata_line_20_____National_Liability_&_Fire_Ins_Co_AAp_App_20250515 >									
211 	//        < t500zc2OQzBWm8FnSze1v2hV83SXX250iZd32a188aUD8d9EK9be3MRnHKnO8D8s >									
212 	//        < 1E-018 limites [ 606718391,550442 ; 643137191,242521 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000E2052CDA7EF9657B48 >									
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
256 	//     < RE_Portfolio_XIV_metadata_line_21_____National_Union_Fire_Ins_Co_Of_Pitisburgh_Pennsylvania_Ap_A_20250515 >									
257 	//        < 0e7lK37Gk59BdaFn1VOFL1LLRdkzAnbTl1g25T16Yjg0Ip0CXNZ22DC0yI60h97r >									
258 	//        < 1E-018 limites [ 643137191,242521 ; 658000285,62596 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000EF9657B48F51FCC386 >									
260 	//     < RE_Portfolio_XIV_metadata_line_22_____Navigators_Ins_Co_A_A_20250515 >									
261 	//        < 0G8Vr72Ij885VT5PMz214S3g64zEL5f07Jo8bE4fCtboanp4y4T0w9nP0UOI4Khj >									
262 	//        < 1E-018 limites [ 658000285,62596 ; 737808183,566224 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000F51FCC386112DADF3A8 >									
264 	//     < RE_Portfolio_XIV_metadata_line_23_____Navigators_Underwriting_Agency_Limited_20250515 >									
265 	//        < 77Z57Hf1vs8ihdC1017tiCqD2ZwlvXv3ZBqi3aD15HOtM46ej62D15K4Umg1vF0B >									
266 	//        < 1E-018 limites [ 737808183,566224 ; 788150204,765719 ] >									
267 	//        < 0x00000000000000000000000000000000000000000000112DADF3A81259BDC7B0 >									
268 	//     < RE_Portfolio_XIV_metadata_line_24_____Navigators_Underwriting_Agency_Limited_20250515 >									
269 	//        < j2Lku1w867tqTLjHBszu9emBq8yIvH2U44xOd6IXuh569nOSZ3181zCu76fXzDd7 >									
270 	//        < 1E-018 limites [ 788150204,765719 ; 812462552,295025 ] >									
271 	//        < 0x000000000000000000000000000000000000000000001259BDC7B012EAA77A71 >									
272 	//     < RE_Portfolio_XIV_metadata_line_25_____Neon_Underwriting_Limited_20250515 >									
273 	//        < IuGgH35o773r0u250rV15GPW36q48jJS8092H662Ka1vq0SaTevY3j58Ka33zKUZ >									
274 	//        < 1E-018 limites [ 812462552,295025 ; 859182749,164533 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000012EAA77A71140120D758 >									
276 	//     < RE_Portfolio_XIV_metadata_line_26_____Neon_Underwriting_Limited_20250515 >									
277 	//        < o33fgjH43kFpYE5MNNzMl8u042S1G0WoI5S9ol6Z37nDcwG03nJODJhqJjhdWRR3 >									
278 	//        < 1E-018 limites [ 859182749,164533 ; 886672597,947944 ] >									
279 	//        < 0x00000000000000000000000000000000000000000000140120D75814A4FB0586 >									
280 	//     < RE_Portfolio_XIV_metadata_line_27_____New_Hampshire_Ins_Ap_A_20250515 >									
281 	//        < pZ40I7ediK0mYQ2l92g2XX971MKioy0pL4bIL9ny85aX5wKF1lCObURyj4UYl1B5 >									
282 	//        < 1E-018 limites [ 886672597,947944 ; 963425755,543964 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000014A4FB0586166E770BB6 >									
284 	//     < RE_Portfolio_XIV_metadata_line_28_____New_Zealand_AA_CBL_Insurance_Limited_Am_20250515 >									
285 	//        < sw5H61ZY7b4a8p5wA1s0ghb2885liN3iV2xqR3z3SUEtDjwsWdnvgJ0lO82WReh9 >									
286 	//        < 1E-018 limites [ 963425755,543964 ; 1015707449,91526 ] >									
287 	//        < 0x00000000000000000000000000000000000000000000166E770BB617A6169493 >									
288 	//     < RE_Portfolio_XIV_metadata_line_29_____Newline_Underwriting_Management_Limited_20250515 >									
289 	//        < viS41171qp6PnkHg3yWY61GWk0In0dKZ4uOVXj597i97oyxvNR6j7QwRW0fHBet8 >									
290 	//        < 1E-018 limites [ 1015707449,91526 ; 1034219423,962 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000017A616949318146D9C70 >									
292 	//     < RE_Portfolio_XIV_metadata_line_30_____Newline_Underwriting_Management_Limited_20250515 >									
293 	//        < qF7m00AWiVW5AIM7A5bDe8rRj69zo2H2rK9ZorY6W1P934w544atV9TJ9LbDX80s >									
294 	//        < 1E-018 limites [ 1034219423,962 ; 1045982336,26699 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000018146D9C70185A8A640E >									
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
338 	//     < RE_Portfolio_XIV_metadata_line_31_____Nipponkoa_Insurance_CO__China__Limited_m_Am_20250515 >									
339 	//        < 8GGXdlr0PdUseHyjFXNXr9212b02XIFoJF65qjMV4yki13n99tvD5VenT7kW6jRS >									
340 	//        < 1E-018 limites [ 1045982336,26699 ; 1103787829,04471 ] >									
341 	//        < 0x00000000000000000000000000000000000000000000185A8A640E19B31692AC >									
342 	//     < RE_Portfolio_XIV_metadata_line_32_____NKSJ_Holdings_Incorporated_20250515 >									
343 	//        < pPrlpyM1CAWxch7T0iFy7WIL5Z34QU4B9KusJJwHv2zM9zF2V1D9027pXIxP7J8y >									
344 	//        < 1E-018 limites [ 1103787829,04471 ; 1118141576,81781 ] >									
345 	//        < 0x0000000000000000000000000000000000000000000019B31692AC1A08A4A765 >									
346 	//     < RE_Portfolio_XIV_metadata_line_33_____Noacional_de_Reasseguros_20250515 >									
347 	//        < 6dJo6f8od8juGGGv1rLKA75uq4Ql10I6Avm657v59O47r3Qyx4J2E6EVA4f3f8q6 >									
348 	//        < 1E-018 limites [ 1118141576,81781 ; 1141141470,27767 ] >									
349 	//        < 0x000000000000000000000000000000000000000000001A08A4A7651A91BBB4C7 >									
350 	//     < RE_Portfolio_XIV_metadata_line_34_____Novae_Syndicates_Limited_20250515 >									
351 	//        < trl4x30W3h5NVtbGMBfEy08o99PeKs3dR8KY07XKyRK24B8LPu723zOv0c5SmSUL >									
352 	//        < 1E-018 limites [ 1141141470,27767 ; 1165277159,52978 ] >									
353 	//        < 0x000000000000000000000000000000000000000000001A91BBB4C71B2197D864 >									
354 	//     < RE_Portfolio_XIV_metadata_line_35_____Novae_Syndicates_Limited_20250515 >									
355 	//        < 8z95BrEb70pqSe1C3gsuB15e5Qx40n5HrPg23352Ns2Wkov97e3AxGrSaKWO8ojh >									
356 	//        < 1E-018 limites [ 1165277159,52978 ; 1232882860,41083 ] >									
357 	//        < 0x000000000000000000000000000000000000000000001B2197D8641CB48DF54D >									
358 	//     < RE_Portfolio_XIV_metadata_line_36_____Novae_Syndicates_Limited_20250515 >									
359 	//        < vy8qm5YxFMIwELo9k8lC33SgcT77D5Rp5ZILSgvUO03E42AHomR4m4ztQApimSgC >									
360 	//        < 1E-018 limites [ 1232882860,41083 ;  ] >									
361 	//        < 0x000000000000000000000000000000000000000000001CB48DF54D1E0E1A85C7 >									
362 	//     < RE_Portfolio_XIV_metadata_line_37_____Odyssey_Re_20250515 >									
363 	//        < G71923TXVOd5JsG44MYW7ubtFdphx892EqilV1sw9tM4f0W58WIxir7xnUlSQBf2 >									
364 	//        < 1E-018 limites [ 1290856375,87123 ; 1365562355,90604 ] >									
365 	//        < 0x000000000000000000000000000000000000000000001E0E1A85C71FCB62CD3A >									
366 	//     < RE_Portfolio_XIV_metadata_line_38_____Odyssey_Re_Holdings_Corp_20250515 >									
367 	//        < 56ofL2KZ745JgHB77mic6n61vHD5C5Y90O2YTg8q9OFg21E4w2S60U3umN3AX7Tp >									
368 	//        < 1E-018 limites [ 1365562355,90604 ; 1421707651,22514 ] >									
369 	//        < 0x000000000000000000000000000000000000000000001FCB62CD3A211A09B936 >									
370 	//     < RE_Portfolio_XIV_metadata_line_39_____Odyssey_Re_Holdings_Corp_20250515 >									
371 	//        < nZlJD224351Shp525xF7eGMd9375Q32851mnuJK1PfhiWYG8ro6k2WU4jdj7Hw60 >									
372 	//        < 1E-018 limites [ 1421707651,22514 ; 1472011578,74957 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000211A09B9362245DF6CE6 >									
374 	//     < RE_Portfolio_XIV_metadata_line_40_____Odyssey_Re_Holdings_Corporation_20250515 >									
375 	//        < TGIXDSzN4apX4iBXki5k1hd54Oj5SleeXyW8WNLQN1JQylo0eJoJ8N1kcD6Xm8UG >									
376 	//        < 1E-018 limites [ 1472011578,74957 ; 1544348011,47511 ] >									
377 	//        < 0x000000000000000000000000000000000000000000002245DF6CE623F5080FEF >									
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