1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RE_Portfolio_X_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RE_Portfolio_X_883		"	;
8 		string	public		symbol =	"	RE883X		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1724616534055050000000000000					;	
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
92 	//     < RE_Portfolio_X_metadata_line_1_____European_Reinsurance_Consultants_20250515 >									
93 	//        < D8v81h27FBSiRtPlNUVdolxTsvg4ncf8r2M34lMwYWEh286X5H0sH4mMd88cC0JA >									
94 	//        < 1E-018 limites [ 1E-018 ; 35205224,2350521 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000D1D6EAAB >									
96 	//     < RE_Portfolio_X_metadata_line_2_____Everest_National_Insurance_Co_Ap_Ap_20250515 >									
97 	//        < 7dMdUH7TN5u875a70BvW0rJwCv1zhkdpTrQtH3RUXHd0q9HYKmURM2caVGPy2jjh >									
98 	//        < 1E-018 limites [ 35205224,2350521 ; 98251222,5673903 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000D1D6EAAB2499F79C4 >									
100 	//     < RE_Portfolio_X_metadata_line_3_____Everest_Re_Group_20250515 >									
101 	//        < zVF0rYI70D7b0OZ2tojFJGC48T2J60L6hnLWuW71Jgu8jq5Fv9G6mTz6y1kvd44n >									
102 	//        < 1E-018 limites [ 98251222,5673903 ; 154556676,857003 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000002499F79C43993AC7D9 >									
104 	//     < RE_Portfolio_X_metadata_line_4_____Everest_Re_Group_20250515 >									
105 	//        < rlKfySod6adx9adzH5n5Z6hQA599J1O77VIe50sS73qa4ua3Rdu6qy43vrXl8aa2 >									
106 	//        < 1E-018 limites [ 154556676,857003 ; 207287970,828712 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000003993AC7D94D388598E >									
108 	//     < RE_Portfolio_X_metadata_line_5_____Everest_Re_Group_20250515 >									
109 	//        < uqVK1eBQilSmY2VV14N9Ms0tum5s45uC02850O18UToO2G7TOjj21N3zO8b25ij5 >									
110 	//        < 1E-018 limites [ 207287970,828712 ; 220688404,426694 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000004D388598E52367C9EE >									
112 	//     < RE_Portfolio_X_metadata_line_6_____Everest_Re_Group_Limited_20250515 >									
113 	//        < n28srWQSUFTx3r0vWdoIE02pw9w7H8f02OCKNEPWe6BK86x09jobh6UT933Ji61m >									
114 	//        < 1E-018 limites [ 220688404,426694 ; 294655852,371998 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000052367C9EE6DC492849 >									
116 	//     < RE_Portfolio_X_metadata_line_7_____Evergreen_Insurance_Company_Limited_m_A_20250515 >									
117 	//        < qob52coqYbYlaI70L3P2k4U5Rr3AGG7e36r2IrtsVXd7342497XUEY6V6821Xh3f >									
118 	//        < 1E-018 limites [ 294655852,371998 ; 354261799,826067 ] >									
119 	//        < 0x00000000000000000000000000000000000000000000006DC49284983F909D82 >									
120 	//     < RE_Portfolio_X_metadata_line_8_____Evergreen_Re_20250515 >									
121 	//        < VZKXtWFqx1zsJouVbp67WpICU0MAIjHBRW7i2437HM47HjFZ4SliEJ4Z02Hc565N >									
122 	//        < 1E-018 limites [ 354261799,826067 ; 378253365,098779 ] >									
123 	//        < 0x000000000000000000000000000000000000000000000083F909D828CE90D6B1 >									
124 	//     < RE_Portfolio_X_metadata_line_9_____EWI_Re_Intermediaries_and_Consultants_20250515 >									
125 	//        < bk1WAE4jxce00Cua4l2z9Fib0Xo1NokvEukEQrZ3UmT7VKpfzwDMfsN9vgwuzp70 >									
126 	//        < 1E-018 limites [ 378253365,098779 ; 456146448,873707 ] >									
127 	//        < 0x00000000000000000000000000000000000000000000008CE90D6B1A9ED8408B >									
128 	//     < RE_Portfolio_X_metadata_line_10_____Factory_Mutual_Insurance_Co_Ap_Ap_20250515 >									
129 	//        < LeCPC7IVqW6ivvM23iYzV800fXES92fdV5Ro5Ry2h28r7j0pyWCZ8b3vI7F5HfjV >									
130 	//        < 1E-018 limites [ 456146448,873707 ; 471398070,734583 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000A9ED8408BAF9C06155 >									
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
174 	//     < RE_Portfolio_X_metadata_line_11_____Faraday_Underwriting_Limited_20250515 >									
175 	//        < 7py5tEh3TTSM3D511qSeMRPC62csW1LC5iI8s31vA9xL32861Y3XPXHNl6teScrL >									
176 	//        < 1E-018 limites [ 471398070,734583 ; 552066324,876761 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000AF9C06155CDA925E1B >									
178 	//     < RE_Portfolio_X_metadata_line_12_____Faraday_Underwriting_Limited_20250515 >									
179 	//        < Y6yqnZK075G96m9O12i52DpIc0v8W9jT77QDneVt74gO13Si4GX1yc4ccx1S583Y >									
180 	//        < 1E-018 limites [ 552066324,876761 ; 565449517,856386 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000CDA925E1BD2A577FDD >									
182 	//     < RE_Portfolio_X_metadata_line_13_____Faraday_Underwriting_Limited_20250515 >									
183 	//        < 4uGick1mI3SyVF8dzqi27gwx7x0YlD546GXb563zKAl9enL859W0qO48a9U0SB26 >									
184 	//        < 1E-018 limites [ 565449517,856386 ; 639504901,630417 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000D2A577FDDEE3BF0C27 >									
186 	//     < RE_Portfolio_X_metadata_line_14_____Faraday_Underwriting_Limited_20250515 >									
187 	//        < D8HgeA7KQzg8s1AHncyFky9nW6p4fi3DJGv8NHbT72fKVMQlk5Mwul9pmt6quAc1 >									
188 	//        < 1E-018 limites [ 639504901,630417 ; 715695508,049936 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000EE3BF0C2710A9E0AFC8 >									
190 	//     < RE_Portfolio_X_metadata_line_15_____Fiduciary_Intermediary_20250515 >									
191 	//        < N1fu7Si68f14m7i6YLiSVQ97qz33861Fy04zi7nRGTP4mt87wi1K167Gr5b0kX74 >									
192 	//        < 1E-018 limites [ 715695508,049936 ; 743637461,618944 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000010A9E0AFC811506CB965 >									
194 	//     < RE_Portfolio_X_metadata_line_16_____First_Capital_Insurance_Limited_A_20250515 >									
195 	//        < wCBWF7V08gp0mSoLL40cA1BVxgR2sCZLMx5dUxtq78Dg9wSc9PyWBJ0KECQLM2sm >									
196 	//        < 1E-018 limites [ 743637461,618944 ; 785991183,168893 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000011506CB965124CDF5FE0 >									
198 	//     < RE_Portfolio_X_metadata_line_17_____Flagstone_Reinsurance_Holdings_Limited_20250515 >									
199 	//        < EdxgK3q0a8D23GYrTX0zPG9026O9HHQ37v1T2z3FX9wSXkK7ks2Xg8F9AWEoP81n >									
200 	//        < 1E-018 limites [ 785991183,168893 ; 846829386,163266 ] >									
201 	//        < 0x00000000000000000000000000000000000000000000124CDF5FE013B77F1AEC >									
202 	//     < RE_Portfolio_X_metadata_line_18_____FolksAmerica_Reinsurance_Company_20250515 >									
203 	//        < 87qV9kH2SsA408r95gSXjBrv84sAzHn82hfLujCOY8dn6xwh8WpK37S9lnr9V3Er >									
204 	//        < 1E-018 limites [ 846829386,163266 ; 901925330,651468 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000013B77F1AEC14FFE4D83D >									
206 	//     < RE_Portfolio_X_metadata_line_19_____GBG_Insurance_limited_USA_Bpp_20250515 >									
207 	//        < j7j5mAMiZ2XJAy7W6g9M47b805wjn0b0W8NDPS1hcYChUFTvVX180ILar64i5se5 >									
208 	//        < 1E-018 limites [ 901925330,651468 ; 963613439,131181 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000014FFE4D83D166F956D9D >									
210 	//     < RE_Portfolio_X_metadata_line_20_____GE_ERC_20250515 >									
211 	//        < B8lQQKxTfltr7IydVrtZS21V742Trp5dxnuNYubmnk4P603r3011240BbP1haHng >									
212 	//        < 1E-018 limites [ 963613439,131181 ; 1007149153,42193 ] >									
213 	//        < 0x00000000000000000000000000000000000000000000166F956D9D177313A802 >									
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
256 	//     < RE_Portfolio_X_metadata_line_21_____General_Cologne_Re_20250515 >									
257 	//        < 47zVCP1yaRw527wI9To02P6A4l1L0XWrb89oKmKJmiA1iNy6UXz15z9p0y04bzW5 >									
258 	//        < 1E-018 limites [ 1007149153,42193 ; 1048176399,60965 ] >									
259 	//        < 0x00000000000000000000000000000000000000000000177313A80218679E440C >									
260 	//     < RE_Portfolio_X_metadata_line_22_____General_Insurance_Corporation_of_India_20250515 >									
261 	//        < WcI8agjWu00HLuOXPcgIW93U4dRsd38ayqQBM3z4918HsPojU053Tu8523e02zA3 >									
262 	//        < 1E-018 limites [ 1048176399,60965 ; 1094781549,32812 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000018679E440C197D6814A8 >									
264 	//     < RE_Portfolio_X_metadata_line_23_____General_Insurance_Corporation_of_India_Am_20250515 >									
265 	//        < b272RujYz55e4526K3x06I4oTnW3v6swg4jJ53mCS6o697FHsCjYZmv1lq10CmmK >									
266 	//        < 1E-018 limites [ 1094781549,32812 ; 1105997978,5313 ] >									
267 	//        < 0x00000000000000000000000000000000000000000000197D6814A819C042FE51 >									
268 	//     < RE_Portfolio_X_metadata_line_24_____General_Re_Co_AA_App_20250515 >									
269 	//        < 8iSY8q4g0I1EKYi3nXL0G127S4h5N1C8ChR9NGjW9gk9sQ35KLSB9lzK3572U7q3 >									
270 	//        < 1E-018 limites [ 1105997978,5313 ; 1170640506,34888 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000019C042FE511B418FA9BE >									
272 	//     < RE_Portfolio_X_metadata_line_25_____General_Reinsurance_AG_AAm_App_20250515 >									
273 	//        < 506mnh92Qnjd98H6JGPEePJSjqZK2WFVwPP9scSh8mg755V2aQ975ghBj8tY6I58 >									
274 	//        < 1E-018 limites [ 1170640506,34888 ; 1205540508,06079 ] >									
275 	//        < 0x000000000000000000000000000000000000000000001B418FA9BE1C1194D6EA >									
276 	//     < RE_Portfolio_X_metadata_line_26_____General_Security_Indemnity_Co_of_Arizona_AAm_A_20250515 >									
277 	//        < NwJ56wpssU33BXRh5tpJX7z8G7nVP7A86RmpIy1704a324a51YL6Qb5IPs7iZ3r1 >									
278 	//        < 1E-018 limites [ 1205540508,06079 ; 1228073254,88163 ] >									
279 	//        < 0x000000000000000000000000000000000000000000001C1194D6EA1C97E31524 >									
280 	//     < RE_Portfolio_X_metadata_line_27_____Generali_Group_20250515 >									
281 	//        < GXdph0Ey7ht53Wx46rI7r34Nw1lRYp91gwe5em47xjL0vDyzrGk86P5NcUgh8u7f >									
282 	//        < 1E-018 limites [ 1228073254,88163 ; 1246314210,20301 ] >									
283 	//        < 0x000000000000000000000000000000000000000000001C97E315241D049C9250 >									
284 	//     < RE_Portfolio_X_metadata_line_28_____Generali_Itallia_SPA_A_20250515 >									
285 	//        < EziC4N6N8Qe526PTj2qjeB3J9ifpKAp4z98XXnA8RHfwl4898g0z71r6kuAfMdui >									
286 	//        < 1E-018 limites [ 1246314210,20301 ; 1262776759,6049 ] >									
287 	//        < 0x000000000000000000000000000000000000000000001D049C92501D66BC6DAC >									
288 	//     < RE_Portfolio_X_metadata_line_29_____Gerling_Global_Financial_Services_20250515 >									
289 	//        < 57Z6p79tqy4VdQ8ee6Efw61KbZm29UoSnke0QYrK172YX7x262E4HJHbNoyBqxYQ >									
290 	//        < 1E-018 limites [ 1262776759,6049 ; 1317515363,57484 ] >									
291 	//        < 0x000000000000000000000000000000000000000000001D66BC6DAC1EAD00E8D9 >									
292 	//     < RE_Portfolio_X_metadata_line_30_____Gerling_Global_Re_20250515 >									
293 	//        < fndhvrI82gqh4b104s4xyGE551oJj45LaBnbE1G2Fu0pK47Z04R123F9V4R370Rs >									
294 	//        < 1E-018 limites [ 1317515363,57484 ; 1328252163,78192 ] >									
295 	//        < 0x000000000000000000000000000000000000000000001EAD00E8D91EECFFF76E >									
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
338 	//     < RE_Portfolio_X_metadata_line_31_____Gerling_Reinsurance_Australia_20250515 >									
339 	//        < S54BBy0WgSerb40zls8mmfM4b1R0Nks7D5xXz72B2H9WfeYnfR3t47uQxZo7YOnj >									
340 	//        < 1E-018 limites [ 1328252163,78192 ; 1389263686,16927 ] >									
341 	//        < 0x000000000000000000000000000000000000000000001EECFFF76E2058A8295C >									
342 	//     < RE_Portfolio_X_metadata_line_32_____Ghana_Re_20250515 >									
343 	//        < Xep07ob9dGSp2d2ELyw3c9dOyffxB8oX9zu3M2J69KFD1doYAugrz5932v0Oslg4 >									
344 	//        < 1E-018 limites [ 1389263686,16927 ; 1412155401,035 ] >									
345 	//        < 0x000000000000000000000000000000000000000000002058A8295C20E11A257B >									
346 	//     < RE_Portfolio_X_metadata_line_33_____Gill_and_Roeser_20250515 >									
347 	//        < shI4a8zbvo3kvH7js7M43Px1i5nGGX3L9Xrp9Alq1UvKK7I95347d3ZAMbz145u0 >									
348 	//        < 1E-018 limites [ 1412155401,035 ; 1443837426,52427 ] >									
349 	//        < 0x0000000000000000000000000000000000000000000020E11A257B219DF114B0 >									
350 	//     < RE_Portfolio_X_metadata_line_34_____Glacier_Group_20250515 >									
351 	//        < 62GoA3czxuX9gX3IEKduaWWrrYYbwQat1qco9swKndtE6qP590eFL6h7CF1ezsdx >									
352 	//        < 1E-018 limites [ 1443837426,52427 ; 1514306817,90679 ] >									
353 	//        < 0x00000000000000000000000000000000000000000000219DF114B02341F8D6B2 >									
354 	//     < RE_Portfolio_X_metadata_line_35_____Glacier_Group_20250515 >									
355 	//        < pVa1i24T24zGsciDN2N3c0yUGJOOW7DnufLAflv52tV2r5bfdsjuzwcg5GHhT5FI >									
356 	//        < 1E-018 limites [ 1514306817,90679 ; 1561105223,20555 ] >									
357 	//        < 0x000000000000000000000000000000000000000000002341F8D6B22458E989C4 >									
358 	//     < RE_Portfolio_X_metadata_line_36_____Global_Reinsurance_20250515 >									
359 	//        < xT7tNv6JsRskofyS3F849821DH9VKA1a1f0G4rdfyYP9FIcvz6b4NfG5B2Ezm9K2 >									
360 	//        < 1E-018 limites [ 1561105223,20555 ;  ] >									
361 	//        < 0x000000000000000000000000000000000000000000002458E989C424E6F08D4D >									
362 	//     < RE_Portfolio_X_metadata_line_37_____GMAC_Re_20250515 >									
363 	//        < jU4CJnL0d97607640u99MyrRrV71KC4iXmmEMe6O8G9g7as04cUrUUx5TwpB8bk8 >									
364 	//        < 1E-018 limites [ 1584933466,49313 ; 1653537746,74199 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000024E6F08D4D267FDA6046 >									
366 	//     < RE_Portfolio_X_metadata_line_38_____GMF_Assurances_BBB_Baa3_20250515 >									
367 	//        < 79vx3Blc8rW03wG3jNL6ugR9Cg7MuV3tuA7Z6J1U6a57NHb16G9zv399oc8S3cBt >									
368 	//        < 1E-018 limites [ 1653537746,74199 ; 1670808102,81451 ] >									
369 	//        < 0x00000000000000000000000000000000000000000000267FDA604626E6CAD91D >									
370 	//     < RE_Portfolio_X_metadata_line_39_____Gothaer_Allgemeine_Versicherung_AG_Am_Am_20250515 >									
371 	//        < qz5CMsmU5s3f5aYBM92Y8d6l25K97x14mG49ysfB6DhP5pyuW3r0wEA595jOHrkO >									
372 	//        < 1E-018 limites [ 1670808102,81451 ; 1697655608,00777 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000026E6CAD91D2786D0E3D4 >									
374 	//     < RE_Portfolio_X_metadata_line_40_____Great_Lakes_Reinsurance__UK__SE_AAm_Ap_20250515 >									
375 	//        < d728oj78xG9405BgT69TPvGmuIv9tBo0p89hNad0eP69qh4k7Q72jnAX5BeKv1OV >									
376 	//        < 1E-018 limites [ 1697655608,00777 ; 1724616534,05505 ] >									
377 	//        < 0x000000000000000000000000000000000000000000002786D0E3D4282783FF91 >									
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