1 pragma solidity 		^0.4.25	;						
2 										
3 	contract	CHEMCHINA_PFI_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	CHEMCHINA_PFI_I_883		"	;
8 		string	public		symbol =	"	CHEMCHINA_PFI_I_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		561734866207499000000000000					;	
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
92 	//     < CHEMCHINA_PFI_I_metadata_line_1_____001Chemical_20220321 >									
93 	//        < SHntZKht18nMcdKJknO5O2Gy6kqD5xzpeg0crOfCwDKXdRM6YmMk87p4zFR2WeEV >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000013490436.191562500000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000001495B4 >									
96 	//     < CHEMCHINA_PFI_I_metadata_line_2_____3B_Scientific__Wuhan__Corporation_Limited_20220321 >									
97 	//        < lXFy68Wcv5Jcj1FU8hRUA2KMlsJf51QSZMltMR0kxhk319Jwm99m7wNnxoG3bhPG >									
98 	//        <  u =="0.000000000000000001" : ] 000000013490436.191562500000000000 ; 000000027021597.099934200000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000001495B4293B50 >									
100 	//     < CHEMCHINA_PFI_I_metadata_line_3_____3Way_Pharm_inc__20220321 >									
101 	//        < mH56w79C98tIADFfq9EOto28525JK34iC9Dv2Q3jsq5Q0D3vI1ph6CmO1IRZW1PG >									
102 	//        <  u =="0.000000000000000001" : ] 000000027021597.099934200000000000 ; 000000043064326.123049400000000000 ] >									
103 	//        < 0x0000000000000000000000000000000000000000000000000000293B5041B601 >									
104 	//     < CHEMCHINA_PFI_I_metadata_line_4_____Acemay_Biochemicals_20220321 >									
105 	//        < L3Hp3UqDJVVGRqx6Yw8hxhDqVET8F0IPd0Ns3l7Wot27A29cjZrFqClZ99Heft78 >									
106 	//        <  u =="0.000000000000000001" : ] 000000043064326.123049400000000000 ; 000000056063549.168661400000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000041B601558BD3 >									
108 	//     < CHEMCHINA_PFI_I_metadata_line_5_____Aemon_Chemical_Technology_Co_Limited_20220321 >									
109 	//        < 70Jfl06Nwg8Y8RQpiI75x80ft10oc7oqpPK67TqP53PGgt6ngv2q9aIoPMlv4VxW >									
110 	//        <  u =="0.000000000000000001" : ] 000000056063549.168661400000000000 ; 000000069154886.730664900000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000558BD36985A1 >									
112 	//     < CHEMCHINA_PFI_I_metadata_line_6_____AgileBioChem_Co_Limited_20220321 >									
113 	//        < cAeg7qdHy93iJTMM3dJw0CZd0WNw2314BEY4FCR6AU49ExGw0W05s9G60n6jzK5Q >									
114 	//        <  u =="0.000000000000000001" : ] 000000069154886.730664900000000000 ; 000000084993288.918498200000000000 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000000000006985A181B081 >									
116 	//     < CHEMCHINA_PFI_I_metadata_line_7_____Aktin_Chemicals,_inc__20220321 >									
117 	//        < PJqZHB31o4AUxRRl8be5k2g0OXlCt8MXe3G6Y0Uw1805p9m37l210J3GxvwfIf3V >									
118 	//        <  u =="0.000000000000000001" : ] 000000084993288.918498200000000000 ; 000000098297181.651838700000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000000081B08195FD56 >									
120 	//     < CHEMCHINA_PFI_I_metadata_line_8_____Aktin_Chemicals,_org_20220321 >									
121 	//        < 02T2FxO8QiB9W1811nGj4pqMztgZ38UIpjN12tT5GSU9I2aVbxn0y997n5tSN6Bs >									
122 	//        <  u =="0.000000000000000001" : ] 000000098297181.651838700000000000 ; 000000110946475.204030000000000000 ] >									
123 	//        < 0x000000000000000000000000000000000000000000000000000095FD56A94A78 >									
124 	//     < CHEMCHINA_PFI_I_metadata_line_9_____Angene_International_Limited_20220321 >									
125 	//        < aGJ9Y1pdS5WQa95V6olw8L9NV2DuwF8pD7EoA4rr6P71C2bRjNig9AQ8s6IxwsBC >									
126 	//        <  u =="0.000000000000000001" : ] 000000110946475.204030000000000000 ; 000000125836198.865079000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000000A94A78C002C4 >									
128 	//     < CHEMCHINA_PFI_I_metadata_line_10_____ANSHAN_HIFI_CHEMICALS_Co__Limited_20220321 >									
129 	//        < 1SM2U611wahs935198qZv0iFd35M5F34xw5o15TfUxOvQ0PyF54LmD6BH104aY1f >									
130 	//        <  u =="0.000000000000000001" : ] 000000125836198.865079000000000000 ; 000000140457797.636842000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000000C002C4D65254 >									
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
174 	//     < CHEMCHINA_PFI_I_metadata_line_11_____Aromalake_Chemical_Corporation_Limited_20220321 >									
175 	//        < q60LoioKnC7bfY8D5ODD6iTrxovSykJA5jHjl0fOI8gn223B0d3Iuf122Q041196 >									
176 	//        <  u =="0.000000000000000001" : ] 000000140457797.636842000000000000 ; 000000152787236.992027000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000000D65254E92284 >									
178 	//     < CHEMCHINA_PFI_I_metadata_line_12_____Aromsyn_Co_Limited_20220321 >									
179 	//        < ky8P0U498n6tBYU43R55gUQ9Xk98u1e33aeHPLpW840x4La3v7y1QRd42fqNsU8l >									
180 	//        <  u =="0.000000000000000001" : ] 000000152787236.992027000000000000 ; 000000168038344.800047000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000000E9228410067FA >									
182 	//     < CHEMCHINA_PFI_I_metadata_line_13_____Arromax_Pharmatech_Co__Limited_20220321 >									
183 	//        < 7c0Rh1luiM4059rdh26CfyP4Opa52A46977r750ixDCs73E394RY4kPAj94zSDG1 >									
184 	//        <  u =="0.000000000000000001" : ] 000000168038344.800047000000000000 ; 000000180437052.914451000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000010067FA1135339 >									
186 	//     < CHEMCHINA_PFI_I_metadata_line_14_____Asambly_Chemicals_Co_Limited_20220321 >									
187 	//        < q21c4tGnER0W4We1kQWH8Xuhv5OjRarUnX1P0xbR8Cl78dsoVd48GeXpDiuEVVSL >									
188 	//        <  u =="0.000000000000000001" : ] 000000180437052.914451000000000000 ; 000000195318648.116764000000000000 ] >									
189 	//        < 0x00000000000000000000000000000000000000000000000000113533912A0859 >									
190 	//     < CHEMCHINA_PFI_I_metadata_line_15_____Atomax_Chemicals_Co__Limited_20220321 >									
191 	//        < 7Tec3HW842n8o3185K6zZXlsXL51X0Dsh4lchne4Rg26XB31CQDxncG6rN12HxOB >									
192 	//        <  u =="0.000000000000000001" : ] 000000195318648.116764000000000000 ; 000000210726532.012637000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000012A08591418B0D >									
194 	//     < CHEMCHINA_PFI_I_metadata_line_16_____Atomax_Chemicals_org_20220321 >									
195 	//        < 9XJ6y4P3J6NU8ahfdduEO3LKe0qDvlunxu3ljGK73BPXkG528vGJOR63jy5463x7 >									
196 	//        <  u =="0.000000000000000001" : ] 000000210726532.012637000000000000 ; 000000226143644.892808000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000001418B0D159115C >									
198 	//     < CHEMCHINA_PFI_I_metadata_line_17_____Beijing_Pure_Chem__Co_Limited_20220321 >									
199 	//        < ZTugt9jeg61he0ZSiEJWH847iM8FqKdCTZV29b6A853ziyFhG29eZf8B9E1JUgzU >									
200 	//        <  u =="0.000000000000000001" : ] 000000226143644.892808000000000000 ; 000000239485193.432416000000000000 ] >									
201 	//        < 0x00000000000000000000000000000000000000000000000000159115C16D6CE7 >									
202 	//     < CHEMCHINA_PFI_I_metadata_line_18_____BEIJING_SHLHT_CHEMICAL_TECHNOLOGY_20220321 >									
203 	//        < Td6gMrD4p5Q0Fw943J2X8M4x782cUHE788d4NFcnRbK4pw4I2O59qmB65T1TBtZ0 >									
204 	//        <  u =="0.000000000000000001" : ] 000000239485193.432416000000000000 ; 000000254948314.360139000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000016D6CE7185052F >									
206 	//     < CHEMCHINA_PFI_I_metadata_line_19_____Beijing_Smart_Chemicals_Co_Limited_20220321 >									
207 	//        < w9IIzqdCKr9t5Mbb4wOXe8MaPpUaS81bjg87WDCxK25h77k6RrzYfnWD25EH1sYW >									
208 	//        <  u =="0.000000000000000001" : ] 000000254948314.360139000000000000 ; 000000269505117.372652000000000000 ] >									
209 	//        < 0x00000000000000000000000000000000000000000000000000185052F19B3B70 >									
210 	//     < CHEMCHINA_PFI_I_metadata_line_20_____Beijing_Stable_Chemical_Co_Limited_20220321 >									
211 	//        < 22pBPS5P5cY5gljlPOR90OY8RO6371W72EZdo5a0gH7Sh4S8TzHeRe3yerfg30p6 >									
212 	//        <  u =="0.000000000000000001" : ] 000000269505117.372652000000000000 ; 000000283907334.226544000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000019B3B701B1354D >									
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
256 	//     < CHEMCHINA_PFI_I_metadata_line_21_____Beijing_Sunpu_Biochem___Tech__Co__Limited_20220321 >									
257 	//        < Ao6Ri704jn11352LiH5Y7E91PqnbOwsdUlMecMhYV3Eai748lW8Oeez2Av9j0CD9 >									
258 	//        <  u =="0.000000000000000001" : ] 000000283907334.226544000000000000 ; 000000296267685.430153000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000001B1354D1C41191 >									
260 	//     < CHEMCHINA_PFI_I_metadata_line_22_____Bellen_Chemistry_Co__Limited_20220321 >									
261 	//        < vvEaOHpyXO7up2U3Rk30Z9h0I9Es3ryHE5gXyZOfoQF8432bjp3l7L9F4s6zDS5f >									
262 	//        <  u =="0.000000000000000001" : ] 000000296267685.430153000000000000 ; 000000312064094.847747000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000001C411911DC2C09 >									
264 	//     < CHEMCHINA_PFI_I_metadata_line_23_____BEYO_CHEMICAL_Co__Limited_20220321 >									
265 	//        < 8cK309p3Y075v0SwfdNrX4lqNkIXv0FBN8j70Juymig5231sDiZbiOxL079T4E7P >									
266 	//        <  u =="0.000000000000000001" : ] 000000312064094.847747000000000000 ; 000000326514528.934342000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000001DC2C091F238BD >									
268 	//     < CHEMCHINA_PFI_I_metadata_line_24_____Beyond_Pharmaceutical_Co_Limited_20220321 >									
269 	//        < 4sj48926BQBVz683N3ySG4lPC3A8wA36V16u49014Wo3g6RHIFb45gIbL37tF727 >									
270 	//        <  u =="0.000000000000000001" : ] 000000326514528.934342000000000000 ; 000000340251544.896348000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000001F238BD2072EC2 >									
272 	//     < CHEMCHINA_PFI_I_metadata_line_25_____Binhai_Gaolou_Chemical_Co_Limited_20220321 >									
273 	//        < 4YTq70MJU3z4amt47U7e5jNLG59P9U39zE2932wi1Y9J2447j2f48X8uiK2DG517 >									
274 	//        <  u =="0.000000000000000001" : ] 000000340251544.896348000000000000 ; 000000354364202.683361000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002072EC221CB784 >									
276 	//     < CHEMCHINA_PFI_I_metadata_line_26_____Binhong_Industry_Co__Limited_20220321 >									
277 	//        < CyFmrpOME6oKuhli58IrvAp3H920g5087KusZRu1I1oD3FLCJP739iSNtIDtjo3y >									
278 	//        <  u =="0.000000000000000001" : ] 000000354364202.683361000000000000 ; 000000367569759.192729000000000000 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000000000021CB784230DDF0 >									
280 	//     < CHEMCHINA_PFI_I_metadata_line_27_____BLD_Pharmatech_org_20220321 >									
281 	//        < tUsOUsq8Ox1yQYLt5s50m0r83A0B8IN44T9Cwz7cR4N1ehb15vb865fB987rRL87 >									
282 	//        <  u =="0.000000000000000001" : ] 000000367569759.192729000000000000 ; 000000380259821.993897000000000000 ] >									
283 	//        < 0x00000000000000000000000000000000000000000000000000230DDF02443AFE >									
284 	//     < CHEMCHINA_PFI_I_metadata_line_28_____BLD_Pharmatech_Limited_20220321 >									
285 	//        < 0MRXAJ0171AJfDN2DjDiOUz9yHLGUXxnYhjoUteVL6WaC0Ky87VJ4HxgDpFc2EZ0 >									
286 	//        <  u =="0.000000000000000001" : ] 000000380259821.993897000000000000 ; 000000393694317.118556000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000002443AFE258BAD8 >									
288 	//     < CHEMCHINA_PFI_I_metadata_line_29_____Bocchem_20220321 >									
289 	//        < ju3X7k675F9GaDX5jj7x7Gf5u33ewff31H0du5U64lBpzI23iWm4lns8fB23zsX3 >									
290 	//        <  u =="0.000000000000000001" : ] 000000393694317.118556000000000000 ; 000000409726344.894086000000000000 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000000000258BAD8271315A >									
292 	//     < CHEMCHINA_PFI_I_metadata_line_30_____Boroncore_LLC_20220321 >									
293 	//        < 83dwh40Q6kjQPr5Azo3TrS5Z808V3498d2DtmLSwRhFhe944Eh3RIWg0BoO62VEH >									
294 	//        <  u =="0.000000000000000001" : ] 000000409726344.894086000000000000 ; 000000423522410.238724000000000000 ] >									
295 	//        < 0x00000000000000000000000000000000000000000000000000271315A2863E71 >									
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
338 	//     < CHEMCHINA_PFI_I_metadata_line_31_____BTC_Pharmaceuticals_Co_Limited_20220321 >									
339 	//        < lQ2OTV5uNA5Xqd6LSinOADeQ2Ng7Zxocn7GJRttOmt6t373dOUMMz7d2cujssJ43 >									
340 	//        <  u =="0.000000000000000001" : ] 000000423522410.238724000000000000 ; 000000436169094.785650000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000002863E712998A8D >									
342 	//     < CHEMCHINA_PFI_I_metadata_line_32_____Cangzhou_Goldlion_Chemicals_Co_Limited_20220321 >									
343 	//        < 9L6QEMZ5PU9249Cba71l7p74f4wTx5L0uWfcAU7Moh8tP5t4SLAbF7SXG9oSaKEa >									
344 	//        <  u =="0.000000000000000001" : ] 000000436169094.785650000000000000 ; 000000451052334.370698000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000002998A8D2B04051 >									
346 	//     < CHEMCHINA_PFI_I_metadata_line_33_____Capot_Chemical_Co_Limited_20220321 >									
347 	//        < A3Uf3oWWxU39QyC8721TI9YJen67dDjq9IkLhtt6eq0013612628DCZ5RuV994P7 >									
348 	//        <  u =="0.000000000000000001" : ] 000000451052334.370698000000000000 ; 000000467103514.309214000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000002B040512C8BE4F >									
350 	//     < CHEMCHINA_PFI_I_metadata_line_34_____CBS_TECHNOLOGY_LTD_20220321 >									
351 	//        < z711LUhD4Th6aRIwSth39Da1DNs2B1J3091a3XVPS1VoK4699N01m32G16ogYe9A >									
352 	//        <  u =="0.000000000000000001" : ] 000000467103514.309214000000000000 ; 000000480058543.980600000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000002C8BE4F2DC82DE >									
354 	//     < CHEMCHINA_PFI_I_metadata_line_35_____Changzhou_Carbochem_Co_Limited_20220321 >									
355 	//        < xfNWi5G685rb4Gf2U0rS07h534351dIvLg3n5WGZ3Y1Es4t5Sa1x3MOxq6k0A637 >									
356 	//        <  u =="0.000000000000000001" : ] 000000480058543.980600000000000000 ; 000000494015798.267553000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000002DC82DE2F1CEEC >									
358 	//     < CHEMCHINA_PFI_I_metadata_line_36_____Changzhou_Hengda_Biotechnology_Co__org_20220321 >									
359 	//        < 6YTK2kY0n8H28UmZ35RDUDcQ1GStFc2RlPqmV0EewVYLJAbIfQKLYwGjPXDPagxY >									
360 	//        <  u =="0.000000000000000001" : ] 000000494015798.267553000000000000 ; 000000510024630.538324000000000000 ] >									
361 	//        < 0x000000000000000000000000000000000000000000000000002F1CEEC30A3C5F >									
362 	//     < CHEMCHINA_PFI_I_metadata_line_37_____Changzhou_Hengda_Biotechnology_Co__Limited_20220321 >									
363 	//        < JUebsgW7eCjg20j52j5BX2atA57napGmgE034O30GBmzI1Cz4i8y7DE6uR3AfItN >									
364 	//        <  u =="0.000000000000000001" : ] 000000510024630.538324000000000000 ; 000000522586035.816742000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000030A3C5F31D672C >									
366 	//     < CHEMCHINA_PFI_I_metadata_line_38_____Changzhou_LanXu_Chemical_Co_Limited_20220321 >									
367 	//        < Mc690734vQtq7e0G1W4g80gdo8wt069XFrV4dl6TU79zZ6Up7w1X98196TneMAvk >									
368 	//        <  u =="0.000000000000000001" : ] 000000522586035.816742000000000000 ; 000000534886141.557242000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000031D672C3302BE6 >									
370 	//     < CHEMCHINA_PFI_I_metadata_line_39_____Changzhou_Standard_Chemicals_Co_Limited_20220321 >									
371 	//        < M4o2PE0C9kq1Sp0Ef47Szh8W2kt3WjPGzZ5n33cUFZe3gwIr41rJjvS28A31Q35k >									
372 	//        <  u =="0.000000000000000001" : ] 000000534886141.557242000000000000 ; 000000548817943.929687000000000000 ] >									
373 	//        < 0x000000000000000000000000000000000000000000000000003302BE63456E02 >									
374 	//     < CHEMCHINA_PFI_I_metadata_line_40_____CHANGZHOU_WEIJIA_CHEMICAL_Co_Limited_20220321 >									
375 	//        < jliI3T4Czfql4O1q5XzV0R7kg8zQjS3s4rI4S07530bjlJ09S3pbWr2A94658VSA >									
376 	//        <  u =="0.000000000000000001" : ] 000000548817943.929687000000000000 ; 000000561734866.207499000000000000 ] >									
377 	//        < 0x000000000000000000000000000000000000000000000000003456E0235923AF >									
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