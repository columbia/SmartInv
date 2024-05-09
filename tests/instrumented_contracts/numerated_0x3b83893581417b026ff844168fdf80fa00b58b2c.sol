1 pragma solidity 		^0.4.25	;						
2 										
3 	contract	CHEMCHINA_PFVI_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	CHEMCHINA_PFVI_I_883		"	;
8 		string	public		symbol =	"	CHEMCHINA_PFVI_I_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		565621903296050000000000000					;	
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
92 	//     < CHEMCHINA_PFVI_I_metadata_line_1_____Shanghai_PI_Chemicals_Limited_20220321 >									
93 	//        < LIP4FBx4jPIX9Oe202XO8n5KpISiQs19AF6WGy20n7z6P702MfT4b64FLgZ24946 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000013662100.063394300000000000 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000000014D8C2 >									
96 	//     < CHEMCHINA_PFVI_I_metadata_line_2_____Shanghai_PI_Chemicals_Limited_20220321 >									
97 	//        < n0f7qIJ9iP1R2vEBOP7M2O0Bx8zKW2GbqfB3xifN2E6k96acEo8M2rmE37834Rhm >									
98 	//        <  u =="0.000000000000000001" : ] 000000013662100.063394300000000000 ; 000000026986745.948062100000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000014D8C2292DB3 >									
100 	//     < CHEMCHINA_PFVI_I_metadata_line_3_____Shanghai_Race_Chemical_Co_Limited_20220321 >									
101 	//        < 5A8zL57W5g7uyo1rMGn0qSM2INf973G71RGFstoeQ4jE4DbYClS7Hp04qRcB9B8I >									
102 	//        <  u =="0.000000000000000001" : ] 000000026986745.948062100000000000 ; 000000041677026.378821600000000000 ] >									
103 	//        < 0x0000000000000000000000000000000000000000000000000000292DB33F9817 >									
104 	//     < CHEMCHINA_PFVI_I_metadata_line_4_____Shanghai_Sinch_Parmaceuticals_Tech__Co__Limited_20220321 >									
105 	//        < lB29db0S9TB57f2wt81Rh8M7D9z60PS5fNlHZMjP422d5Q2Dn9tixd5SdL8wEwQp >									
106 	//        <  u =="0.000000000000000001" : ] 000000041677026.378821600000000000 ; 000000055213537.163629000000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000003F9817543FCA >									
108 	//     < CHEMCHINA_PFVI_I_metadata_line_5_____Shanghai_Sunway_Pharmaceutical_Technology_Co_Limited_20220321 >									
109 	//        < EnSuJ3Nb6VDfQbP6mNRurnKnoywaNPQZM1S32w7ORafJKFW7f3qS42Thsix6oW29 >									
110 	//        <  u =="0.000000000000000001" : ] 000000055213537.163629000000000000 ; 000000069648298.807548900000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000543FCA6A465E >									
112 	//     < CHEMCHINA_PFVI_I_metadata_line_6_____Shanghai_Tauto_Biotech_Co_Limited_20220321 >									
113 	//        < AF1ECq1LXez1C2eO93dezUKNRp2s5zijzaSmTT8vmGHS1PGN2i9enIaouv5gm01X >									
114 	//        <  u =="0.000000000000000001" : ] 000000069648298.807548900000000000 ; 000000083146413.543644900000000000 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000000000006A465E7EDF11 >									
116 	//     < CHEMCHINA_PFVI_I_metadata_line_7_____Shanghai_UCHEM_org__20220321 >									
117 	//        < 6Wl5MTf4532q1Jp0To4Tpn9g7WB3U54Opazxm4EA1bxA1jT4Y60LmPl2fQqyH2nF >									
118 	//        <  u =="0.000000000000000001" : ] 000000083146413.543644900000000000 ; 000000098086659.865351400000000000 ] >									
119 	//        < 0x00000000000000000000000000000000000000000000000000007EDF1195AB1A >									
120 	//     < CHEMCHINA_PFVI_I_metadata_line_8_____Shanghai_UCHEM_inc__20220321 >									
121 	//        < Qb6plq5Y8pvsn59vh83gkqM7crYIvPb2Le0tT4pg8VAcuF5e3I5yHvTu7H0sUxB5 >									
122 	//        <  u =="0.000000000000000001" : ] 000000098086659.865351400000000000 ; 000000110952710.952777000000000000 ] >									
123 	//        < 0x000000000000000000000000000000000000000000000000000095AB1AA94CE7 >									
124 	//     < CHEMCHINA_PFVI_I_metadata_line_9_____Shanghai_UDChem_Technology_Co_Limited_20220321 >									
125 	//        < rr15G536C12gu8y09PYxww3v4a3rnhTWvAU3yRmy0uYW14E9cf3RFYp6314GGeYS >									
126 	//        <  u =="0.000000000000000001" : ] 000000110952710.952777000000000000 ; 000000124741581.657180000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000000A94CE7BE572E >									
128 	//     < CHEMCHINA_PFVI_I_metadata_line_10_____Shanghai_Witofly_Chemical_Co_Limited_20220321 >									
129 	//        < 7Rk6Tz1NZVP38ZzfrIyA0IxriU9jWhX6IYP65vL3njAX2xHgv1BjC2T8jgBxzqha >									
130 	//        <  u =="0.000000000000000001" : ] 000000124741581.657180000000000000 ; 000000140711566.758158000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000000BE572ED6B575 >									
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
174 	//     < CHEMCHINA_PFVI_I_metadata_line_11_____Shanghai_Worldyang_Chemical_Co_Limited_20220321 >									
175 	//        < RkToH57zMesf4OetLQWLM4474D83Y1h1W8I89hLQ0lg2UxhihS6hRTmHlm63rr55 >									
176 	//        <  u =="0.000000000000000001" : ] 000000140711566.758158000000000000 ; 000000156112707.371814000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000000D6B575EE3587 >									
178 	//     < CHEMCHINA_PFVI_I_metadata_line_12_____Shanghai_Yingxuan_Chempharm_Co__Limited_20220321 >									
179 	//        < 1L9pCm54f39uUqY7fNh4360ASvR82vOjRm0l54IT41eTI0dxj14XnkZJi8wh1EzR >									
180 	//        <  u =="0.000000000000000001" : ] 000000156112707.371814000000000000 ; 000000170076171.316953000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000000EE35871038401 >									
182 	//     < CHEMCHINA_PFVI_I_metadata_line_13_____SHANXI_WUCHAN_FINE_CHEMICAL_Co_Limited_20220321 >									
183 	//        < KF4HL1Jh4buzzKm1IiSTCH6eXZ2N0et93G9JR1NmJsSZ1DXBAd3AxD8M2BzKW401 >									
184 	//        <  u =="0.000000000000000001" : ] 000000170076171.316953000000000000 ; 000000183198992.988704000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000010384011178A1B >									
186 	//     < CHEMCHINA_PFVI_I_metadata_line_14_____SHENYANG_OLLYCHEM_CO_LTD_20220321 >									
187 	//        < 0mR05MPT3iESF56H7IBvr220dXHNb9Dc2RXguh2hH3X203r2y2r4Q0VRQ11Nurj8 >									
188 	//        <  u =="0.000000000000000001" : ] 000000183198992.988704000000000000 ; 000000199257983.368087000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000001178A1B1300B26 >									
190 	//     < CHEMCHINA_PFVI_I_metadata_line_15_____ShenZhen_Cerametek_Materials_org_20220321 >									
191 	//        < b7DS1usWVx9xJpVN4MKShg2ii2Y3P3aMQ78b8xr7o15MczkdJkoQmKh1p4Y2baum >									
192 	//        <  u =="0.000000000000000001" : ] 000000199257983.368087000000000000 ; 000000213479968.956006000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000001300B26145BE9D >									
194 	//     < CHEMCHINA_PFVI_I_metadata_line_16_____ShenZhen_Cerametek_Materials_Co_Limited_20220321 >									
195 	//        < YGUd280CYX3yOXWc2gD7u990P8lH9o9a7aFa9NzeVKCalBb016Bq4QvUix111Fyp >									
196 	//        <  u =="0.000000000000000001" : ] 000000213479968.956006000000000000 ; 000000229716941.647591000000000000 ] >									
197 	//        < 0x00000000000000000000000000000000000000000000000000145BE9D15E852E >									
198 	//     < CHEMCHINA_PFVI_I_metadata_line_17_____SHENZHEN_CHEMICAL_Co__Limited_20220321 >									
199 	//        < gIo6kw7a41MqrUmBOPk2F0d3iKQ2bd1HlG0A4sRJ7Y5qvA47np1Z1v9LCT0T23e0 >									
200 	//        <  u =="0.000000000000000001" : ] 000000229716941.647591000000000000 ; 000000244129688.205064000000000000 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000000015E852E1748329 >									
202 	//     < CHEMCHINA_PFVI_I_metadata_line_18_____SHOUGUANG_FUKANG_PHARMACEUTICAL_Co_Limited_20220321 >									
203 	//        < 7z5N1emd3qxUhG69bJ5Vtip6Hds2yM14uG66NKfWp586TMJ4c8tCVop25Y7z7579 >									
204 	//        <  u =="0.000000000000000001" : ] 000000244129688.205064000000000000 ; 000000258637598.461510000000000000 ] >									
205 	//        < 0x00000000000000000000000000000000000000000000000000174832918AA650 >									
206 	//     < CHEMCHINA_PFVI_I_metadata_line_19_____Shouyuan_Chemical_20220321 >									
207 	//        < KO88Oy5ptvL39KEkkT8Bhs4PTZf6H850BNokha5n7uux4s3cHi0N5OiXNHg106vn >									
208 	//        <  u =="0.000000000000000001" : ] 000000258637598.461510000000000000 ; 000000273209109.431222000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000000018AA6501A0E24F >									
210 	//     < CHEMCHINA_PFVI_I_metadata_line_20_____Sichuan_Apothe_Pharmaceuticals_Limited_20220321 >									
211 	//        < 6kKZQ8l5982F73nPJ732yoGeIr19x4jwKbrfKzcGm7H9n4fR0ysw9XXV2t68M3M7 >									
212 	//        <  u =="0.000000000000000001" : ] 000000273209109.431222000000000000 ; 000000287674665.531201000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000001A0E24F1B6F4EB >									
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
256 	//     < CHEMCHINA_PFVI_I_metadata_line_21_____Sichuan_Highlight_Fine_Chemicals_Co__Limited_20220321 >									
257 	//        < Z55kGVrccjT84rm9ZOSz3Qty1lpWmeKlneEI7M43S6IOZ7W7F8O1H6j865M0fa0u >									
258 	//        <  u =="0.000000000000000001" : ] 000000287674665.531201000000000000 ; 000000303094541.498588000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000001B6F4EB1CE7C4E >									
260 	//     < CHEMCHINA_PFVI_I_metadata_line_22_____SICHUAN_TONGSHENG_AMINO_ACID_org_20220321 >									
261 	//        < Og7U8MvbV8IlvdGQV6B93v0289scER7SUxerU4q8d73s6nJ7sB2l5t3TFm32ZaJe >									
262 	//        <  u =="0.000000000000000001" : ] 000000303094541.498588000000000000 ; 000000318480556.904090000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000001CE7C4E1E5F678 >									
264 	//     < CHEMCHINA_PFVI_I_metadata_line_23_____SICHUAN_TONGSHENG_AMINO_ACID_Co_Limited_20220321 >									
265 	//        < 9v46Z4PCecT03TOA9O7hiHy7z63R1i4mvh7G7Q7dig5502azgZgvsqG6h33TVicL >									
266 	//        <  u =="0.000000000000000001" : ] 000000318480556.904090000000000000 ; 000000334762067.885727000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000001E5F6781FECE6F >									
268 	//     < CHEMCHINA_PFVI_I_metadata_line_24_____SightChem_Co__Limited_20220321 >									
269 	//        < 24Z83479KksP96TXSq7Q415X2NXRJ0526E8uYZnDQeRLXFCccRK0kragCoeJcQ2f >									
270 	//        <  u =="0.000000000000000001" : ] 000000334762067.885727000000000000 ; 000000348001100.839438000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000001FECE6F21301EE >									
272 	//     < CHEMCHINA_PFVI_I_metadata_line_25_____Simagchem_Corporation_20220321 >									
273 	//        < lkP80f8VpVS938r97C5N4Nl7i0UMG0Fz0b90Er2S2RY20Q0F87SLC3hW0Bwdy0ks >									
274 	//        <  u =="0.000000000000000001" : ] 000000348001100.839438000000000000 ; 000000360746672.540924000000000000 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000000000021301EE22674AB >									
276 	//     < CHEMCHINA_PFVI_I_metadata_line_26_____SINO_GREAT_ENTERPRISE_Limited_20220321 >									
277 	//        < 0w4bbwkwjC2dKG6TOCSAppx4k62877Upv6Y6gdk3F9ASZ289DnkHDP3OqV71ICOQ >									
278 	//        <  u =="0.000000000000000001" : ] 000000360746672.540924000000000000 ; 000000376798979.382669000000000000 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000000000022674AB23EF31A >									
280 	//     < CHEMCHINA_PFVI_I_metadata_line_27_____SINO_High_Goal_chemical_Techonology_Co_Limited_20220321 >									
281 	//        < u842527GpN32r3fYBuPAPQP8eS35ennoz1sIFv1C2ru1A8xGHviP9sOc3z1aP1k5 >									
282 	//        <  u =="0.000000000000000001" : ] 000000376798979.382669000000000000 ; 000000391393395.130659000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000023EF31A255380C >									
284 	//     < CHEMCHINA_PFVI_I_metadata_line_28_____Sino_Rarechem_Labs_Co_Limited_20220321 >									
285 	//        < CjF298inmK0GwxlLSB1kUI23I3hO8634O92df25n8y6LDNqax9O5bN8K2u86Upwg >									
286 	//        <  u =="0.000000000000000001" : ] 000000391393395.130659000000000000 ; 000000403644197.455911000000000000 ] >									
287 	//        < 0x00000000000000000000000000000000000000000000000000255380C267E984 >									
288 	//     < CHEMCHINA_PFVI_I_metadata_line_29_____Sinofi_Ingredients_20220321 >									
289 	//        < vq6vQeo48TJ7bcOgaMx7NASyZ05JnX0r16Y62vazx9d2McBH4E6xNgSh65qdcGi4 >									
290 	//        <  u =="0.000000000000000001" : ] 000000403644197.455911000000000000 ; 000000418175881.448011000000000000 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000000000267E98427E15F4 >									
292 	//     < CHEMCHINA_PFVI_I_metadata_line_30_____Sinoway_20220321 >									
293 	//        < kVKorbzJgpmQKDr8FU6Evsamug9F6724bY256T8qjxNIAFf1pKwL0xlL7T8NJ6O0 >									
294 	//        <  u =="0.000000000000000001" : ] 000000418175881.448011000000000000 ; 000000433128768.028890000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000027E15F4294E6ED >									
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
338 	//     < CHEMCHINA_PFVI_I_metadata_line_31_____Skyrun_Industrial_Co_Limited_20220321 >									
339 	//        < 2or0VUw745Q0woH5w4jx5359m8u6co9Ki8tV79uPvw9U873WB3299gfxQ290EX6Q >									
340 	//        <  u =="0.000000000000000001" : ] 000000433128768.028890000000000000 ; 000000446945446.819696000000000000 ] >									
341 	//        < 0x00000000000000000000000000000000000000000000000000294E6ED2A9FC11 >									
342 	//     < CHEMCHINA_PFVI_I_metadata_line_32_____Spec_Chem_Industry_org_20220321 >									
343 	//        < f4HIP3e3ah5e909A8486kgdG0mURXh16iVLM0s6Y3x6EhZO969jGrPxp1MXd9lmt >									
344 	//        <  u =="0.000000000000000001" : ] 000000446945446.819696000000000000 ; 000000459324216.206273000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000002A9FC112BCDF86 >									
346 	//     < CHEMCHINA_PFVI_I_metadata_line_33_____Spec_Chem_Industry_inc__20220321 >									
347 	//        < 37LzRDp0gO0c40v7kmI115Xva3t9XIeLIEz5mxeyxxP77q7t0lI2G4V9TEqQn8TT >									
348 	//        <  u =="0.000000000000000001" : ] 000000459324216.206273000000000000 ; 000000472526382.651629000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000002BCDF862D1049E >									
350 	//     < CHEMCHINA_PFVI_I_metadata_line_34_____Stone_Lake_Pharma_Tech_Co_Limited_20220321 >									
351 	//        < sNrWn7A9vhJcQUo7g3iNfW2J4LaCTCAel4nO24t3pRB9HRx7VxY62WDH8dJXk9pL >									
352 	//        <  u =="0.000000000000000001" : ] 000000472526382.651629000000000000 ; 000000485258097.929442000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000002D1049E2E471F2 >									
354 	//     < CHEMCHINA_PFVI_I_metadata_line_35_____Suzhou_ChonTech_PharmaChem_Technology_Co__Limited_20220321 >									
355 	//        < 4551jz39YrMZOicL2fI37HHV044A1sTS8kjiVZ5db2Qx4MoTDP8eFXLCA70ohduo >									
356 	//        <  u =="0.000000000000000001" : ] 000000485258097.929442000000000000 ; 000000497983269.405695000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000002E471F22F7DCB7 >									
358 	//     < CHEMCHINA_PFVI_I_metadata_line_36_____Suzhou_Credit_International_Trading_Co__Limited_20220321 >									
359 	//        < rD7mk8zM2v1dBy0J8o8wh5Z8OfXg758f29f4570YLYWhb130rh5p6L0NrR9cg7z1 >									
360 	//        <  u =="0.000000000000000001" : ] 000000497983269.405695000000000000 ; 000000511455241.034529000000000000 ] >									
361 	//        < 0x000000000000000000000000000000000000000000000000002F7DCB730C6B34 >									
362 	//     < CHEMCHINA_PFVI_I_metadata_line_37_____Suzhou_KPChemical_Co_Limited_20220321 >									
363 	//        < D6p7iC69oI2DjAp10po7QpJ9L751pvW8Pmmvfo6Cl1tQ7jL4l4U169r5R0kcX6mM >									
364 	//        <  u =="0.000000000000000001" : ] 000000511455241.034529000000000000 ; 000000524583307.646943000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000030C6B34320735B >									
366 	//     < CHEMCHINA_PFVI_I_metadata_line_38_____Suzhou_Rovathin_Foreign_Trade_Co_Limited_20220321 >									
367 	//        < 2y319mR3v91U79ypH2WGjgWWFzU8ZTJx1v13kHX2l8ET9JuKwwGIE9vCi9tvLHl2 >									
368 	//        <  u =="0.000000000000000001" : ] 000000524583307.646943000000000000 ; 000000537931410.306172000000000000 ] >									
369 	//        < 0x00000000000000000000000000000000000000000000000000320735B334D175 >									
370 	//     < CHEMCHINA_PFVI_I_metadata_line_39_____SUZHOU_SINOERA_CHEM_org_20220321 >									
371 	//        < bo9IuoLiOhYiTb2sWfBqYuiw0rlf35244wEkzyrbz8X5ajL2N3Sv8T7lQNy02e17 >									
372 	//        <  u =="0.000000000000000001" : ] 000000537931410.306172000000000000 ; 000000551287152.691199000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000334D175349328B >									
374 	//     < CHEMCHINA_PFVI_I_metadata_line_40_____SUZHOU_SINOERA_CHEM_Co__Limited_20220321 >									
375 	//        < JMO11I58F9N5v1yKdv4zpx94a4o7lJq7SK9072jdf3zlJ8q76nAg2dlvFwmGXhOo >									
376 	//        <  u =="0.000000000000000001" : ] 000000551287152.691199000000000000 ; 000000565621903.296050000000000000 ] >									
377 	//        < 0x00000000000000000000000000000000000000000000000000349328B35F120E >									
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