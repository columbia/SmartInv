1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFIV_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFIV_I_883		"	;
8 		string	public		symbol =	"	RUSS_PFIV_I_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		551263562969539000000000000					;	
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
92 	//     < RUSS_PFIV_I_metadata_line_1_____NOVOLIPETSK_20211101 >									
93 	//        < 61ZI82xVUb0S9W2nYw9313355On9C7924rHJZpC45GLEPP735QQCYtvQ864grmB2 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000013782853.736402000000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000001507ED >									
96 	//     < RUSS_PFIV_I_metadata_line_2_____FLETCHER_GROUP_HOLDINGS_LIMITED_20211101 >									
97 	//        < EFWA1XnDfcF1kGKj1367oUc7d87OR138VFWBsQtV5iBZgLdcCBwJk6lq6215eAqf >									
98 	//        <  u =="0.000000000000000001" : ] 000000013782853.736402000000000000 ; 000000027930828.071557100000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000001507ED2A9E7B >									
100 	//     < RUSS_PFIV_I_metadata_line_3_____UNIVERSAL_CARGO_LOGISTICS_HOLDINGS_BV_20211101 >									
101 	//        < 2skK6Ky1Wv829d37f457W3hDYWz8m2MKb8sPv6IxukjHtCtJznU3B0dS481nytir >									
102 	//        <  u =="0.000000000000000001" : ] 000000027930828.071557100000000000 ; 000000041954110.627371000000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000002A9E7B400453 >									
104 	//     < RUSS_PFIV_I_metadata_line_4_____STOILENSKY_GOK_20211101 >									
105 	//        < rN4it883XZbvtO4SIfGW36W5ZMeqVy59HYR95e7O3yklg7tbY5tJafT9wmB99xwR >									
106 	//        <  u =="0.000000000000000001" : ] 000000041954110.627371000000000000 ; 000000055456022.849798600000000000 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000000000400453549E82 >									
108 	//     < RUSS_PFIV_I_metadata_line_5_____ALTAI_KOKS_20211101 >									
109 	//        < 1nKM6MwjJsr01xG5WxmXeJforv7GE3fHFd0jJ8421TisGp6ugUy0L176Tm9xXWhH >									
110 	//        <  u =="0.000000000000000001" : ] 000000055456022.849798600000000000 ; 000000068577751.402161800000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000549E8268A42F >									
112 	//     < RUSS_PFIV_I_metadata_line_6_____VIZ_STAL_20211101 >									
113 	//        < IXZSs11b78oGHXCkS8PgW8rqBDv28f0e4r7qX8Noji8S0D9sOfrYnr0gZtFCT7pR >									
114 	//        <  u =="0.000000000000000001" : ] 000000068577751.402161800000000000 ; 000000082432226.787404900000000000 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000000000068A42F7DC817 >									
116 	//     < RUSS_PFIV_I_metadata_line_7_____NLMK_PLATE_SALES_SA_20211101 >									
117 	//        < DwcbY8LW9G9KxZ7rX3Fiuf6vaLBwN9cttSVc75abQWys6GDtMc564GZAYRS4Q62V >									
118 	//        <  u =="0.000000000000000001" : ] 000000082432226.787404900000000000 ; 000000096098225.224516200000000000 ] >									
119 	//        < 0x00000000000000000000000000000000000000000000000000007DC81792A25F >									
120 	//     < RUSS_PFIV_I_metadata_line_8_____NLMK_INDIANA_LLC_20211101 >									
121 	//        < sw158DEI1v370EpbceozLRI0T30KtDQKAVbGz3x6itq8f2t2i9h1pw4KFhxSUB30 >									
122 	//        <  u =="0.000000000000000001" : ] 000000096098225.224516200000000000 ; 000000110065453.483729000000000000 ] >									
123 	//        < 0x000000000000000000000000000000000000000000000000000092A25FA7F251 >									
124 	//     < RUSS_PFIV_I_metadata_line_9_____STEEL_FUNDING_DAC_20211101 >									
125 	//        < x0ETTL6eR393Ci57MEDU8rS2D61copn0AgVd3sPB2h67aPy6x4i6x2ePu2GwU75X >									
126 	//        <  u =="0.000000000000000001" : ] 000000110065453.483729000000000000 ; 000000124395942.359507000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000000A7F251BDD02A >									
128 	//     < RUSS_PFIV_I_metadata_line_10_____ZAO_URALS_PRECISION_ALLOYS_PLANT_20211101 >									
129 	//        < 4S66XjwzzTle5Nn41y1v5EfdnL5OMyhxgS2F7R9TtQc0fuYF1xtSte7l8W2VZH8S >									
130 	//        <  u =="0.000000000000000001" : ] 000000124395942.359507000000000000 ; 000000138846338.101156000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000000BDD02AD3DCDA >									
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
174 	//     < RUSS_PFIV_I_metadata_line_11_____TOP_GUN_INVESTMENT_CORP_20211101 >									
175 	//        < Xfe7HJ7ud6dE6678HUe6i8x8AJ47F0TZNZ0gj4Mqh5aUuo7JJuMPe93tm39fbm2y >									
176 	//        <  u =="0.000000000000000001" : ] 000000138846338.101156000000000000 ; 000000152729279.018380000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000000D3DCDAE90BE0 >									
178 	//     < RUSS_PFIV_I_metadata_line_12_____NLMK_ARKTIKGAZ_20211101 >									
179 	//        < 34ml3Q99iO3bpc239xqsui8HxnooGMToDjt5Ntffh67mjHaD46sifEA1fIVp2or9 >									
180 	//        <  u =="0.000000000000000001" : ] 000000152729279.018380000000000000 ; 000000165748651.789575000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000000E90BE0FCE991 >									
182 	//     < RUSS_PFIV_I_metadata_line_13_____TUSCANY_INTERTRADE_20211101 >									
183 	//        < mF07dBxEfzb3tQ4vpCW6Fv7SPgJyjjiLPmHqkYfj3860Vt6QeO1w96F399fPMOkM >									
184 	//        <  u =="0.000000000000000001" : ] 000000165748651.789575000000000000 ; 000000179771111.613534000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000000FCE9911124F17 >									
186 	//     < RUSS_PFIV_I_metadata_line_14_____MOORFIELD_COMMODITIES_20211101 >									
187 	//        < LiiQ6J803VWo1miRm8932lQ3N5DyFcd43W48iDWVx7jrLAN64S5k6T0ln21LwcE8 >									
188 	//        <  u =="0.000000000000000001" : ] 000000179771111.613534000000000000 ; 000000193095443.275374000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000001124F17126A3E8 >									
190 	//     < RUSS_PFIV_I_metadata_line_15_____NLMK_COATING_20211101 >									
191 	//        < M2SMwINvi3GF1tuo15l7Xd08yO4FhEpX3H7RKl16m9aZo6u0x1317C368n8B36dY >									
192 	//        <  u =="0.000000000000000001" : ] 000000193095443.275374000000000000 ; 000000207766999.303434000000000000 ] >									
193 	//        < 0x00000000000000000000000000000000000000000000000000126A3E813D06FC >									
194 	//     < RUSS_PFIV_I_metadata_line_16_____NLMK_MAXI_GROUP_20211101 >									
195 	//        < 1ueMIwx8rAnyh02SPajax71421q3631u46Q0P6jC9fnufzN1xN62SMK1nS220f3s >									
196 	//        <  u =="0.000000000000000001" : ] 000000207766999.303434000000000000 ; 000000222341826.973281000000000000 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000000013D06FC1534447 >									
198 	//     < RUSS_PFIV_I_metadata_line_17_____NLMK_SERVICES_LLC_20211101 >									
199 	//        < FY38FdlPJ549Pe6XoUGDZ4boMp6w1m8sr63IZi2A5WyE50tKM48w5b984nMI8Nke >									
200 	//        <  u =="0.000000000000000001" : ] 000000222341826.973281000000000000 ; 000000235562833.688552000000000000 ] >									
201 	//        < 0x00000000000000000000000000000000000000000000000000153444716770BB >									
202 	//     < RUSS_PFIV_I_metadata_line_18_____STEEL_INVEST_FINANCE_20211101 >									
203 	//        < ugzAAMMkwxek2u58O7f12PD22TQIrlUg0l3e2MkJBrB295Yyn7xGIZ40TO9f010Q >									
204 	//        <  u =="0.000000000000000001" : ] 000000235562833.688552000000000000 ; 000000249795749.489214000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000016770BB17D2877 >									
206 	//     < RUSS_PFIV_I_metadata_line_19_____CLABECQ_20211101 >									
207 	//        < P269kGO3iwW6pTKc5i2w1VlE7kXREa9c2jmeC6Lq8rwgh88Fls6846ct25Kd19eV >									
208 	//        <  u =="0.000000000000000001" : ] 000000249795749.489214000000000000 ; 000000263218381.539435000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000000017D2877191A3AE >									
210 	//     < RUSS_PFIV_I_metadata_line_20_____HOLIDAY_HOTEL_NLMK_20211101 >									
211 	//        < 9beGFsR9k19G7Uh20k0FGh8i8SEfz6y8Fl30KKyX6c0P4DnU65p48Ktl8arGfA8F >									
212 	//        <  u =="0.000000000000000001" : ] 000000263218381.539435000000000000 ; 000000276566093.596788000000000000 ] >									
213 	//        < 0x00000000000000000000000000000000000000000000000000191A3AE1A601A1 >									
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
256 	//     < RUSS_PFIV_I_metadata_line_21_____STEELCO_MED_TRADING_20211101 >									
257 	//        < a02Gc0d7rKmw97FCT8Lc8x5TZrj8SvdAY5yNU1a87Wnicb0DYNYtbf3hjIGWDy7E >									
258 	//        <  u =="0.000000000000000001" : ] 000000276566093.596788000000000000 ; 000000289715111.459232000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000001A601A11BA11F7 >									
260 	//     < RUSS_PFIV_I_metadata_line_22_____LIPETSKY_GIPROMEZ_20211101 >									
261 	//        < 4l227lg01RghWSx3v737M3zLO6TwgrKWh2a5ppFqwVZMC4ZxY12k87wzFfVxWOXh >									
262 	//        <  u =="0.000000000000000001" : ] 000000289715111.459232000000000000 ; 000000304183023.711150000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000001BA11F71D0257E >									
264 	//     < RUSS_PFIV_I_metadata_line_23_____NORTH_OIL_GAS_CO_20211101 >									
265 	//        < 813rmKx8gnIlaS9U9Hjf7m98kyZ0xcPwHYy144nvPj15E5Bg13FtLerKE4g5bT5g >									
266 	//        <  u =="0.000000000000000001" : ] 000000304183023.711150000000000000 ; 000000317733198.767461000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000001D0257E1E4D288 >									
268 	//     < RUSS_PFIV_I_metadata_line_24_____STOYLENSKY_GOK_20211101 >									
269 	//        < YXj8GH79T4iGA0aJJrm794wywdYG11P5t51S86ytf646ds9bJ964s941hwCx06jy >									
270 	//        <  u =="0.000000000000000001" : ] 000000317733198.767461000000000000 ; 000000331095428.221367000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000001E4D2881F93627 >									
272 	//     < RUSS_PFIV_I_metadata_line_25_____NLMK_RECORDING_CENTER_OOO_20211101 >									
273 	//        < jvIM50v28xXR0acoa29kjI1BEPIWLeay2Nd1xp4cY2ou1ZDJXdh3YJ3TQkg12FNw >									
274 	//        <  u =="0.000000000000000001" : ] 000000331095428.221367000000000000 ; 000000345486027.219160000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000001F9362720F2B7B >									
276 	//     < RUSS_PFIV_I_metadata_line_26_____URAL_ARCHI_CONSTRUCTION_RD_INSTITUTE_20211101 >									
277 	//        < r278QpX9X8U8512US3A6eTcmgUWKK3eLmKcqaVdPd4jjCV08HV0C08G7P15rdySl >									
278 	//        <  u =="0.000000000000000001" : ] 000000345486027.219160000000000000 ; 000000358990234.108993000000000000 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000000000020F2B7B223C68F >									
280 	//     < RUSS_PFIV_I_metadata_line_27_____PO_URALMETALLURGSTROY_ZAO_20211101 >									
281 	//        < RbQftdpJjr4u8yGQzz1Au466O2r5RzX167Ut2OKVUeT4VKSScL0ySM3Of2W2ckqg >									
282 	//        <  u =="0.000000000000000001" : ] 000000358990234.108993000000000000 ; 000000372237511.749523000000000000 ] >									
283 	//        < 0x00000000000000000000000000000000000000000000000000223C68F237FD47 >									
284 	//     < RUSS_PFIV_I_metadata_line_28_____NLMK_LONG_PRODUCTS_20211101 >									
285 	//        < HF24kh36gPwc2o19dz95bSr89Ko0xfb6wxgk3Ksk62iSLZs65SdZuk53oD5wS92Z >									
286 	//        <  u =="0.000000000000000001" : ] 000000372237511.749523000000000000 ; 000000386175018.750232000000000000 ] >									
287 	//        < 0x00000000000000000000000000000000000000000000000000237FD4724D419E >									
288 	//     < RUSS_PFIV_I_metadata_line_29_____USSURIYSKAYA_SCRAP_METAL_20211101 >									
289 	//        < GE4lTR982A4dWrucKpJc36CNhjep488LY3Dax8XMiOW8aB3wpZZ4l7sjsrU2840C >									
290 	//        <  u =="0.000000000000000001" : ] 000000386175018.750232000000000000 ; 000000399573745.069331000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000024D419E261B37F >									
292 	//     < RUSS_PFIV_I_metadata_line_30_____NOVOLIPETSKY_PRINTING_HOUSE_20211101 >									
293 	//        < 8CWR2fj5U6Zh3oIL3N4AM9oY8V9fd565M2WJbr83JdipM9K92i4W8I7y9L8CwUF9 >									
294 	//        <  u =="0.000000000000000001" : ] 000000399573745.069331000000000000 ; 000000412616871.512249000000000000 ] >									
295 	//        < 0x00000000000000000000000000000000000000000000000000261B37F2759A77 >									
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
338 	//     < RUSS_PFIV_I_metadata_line_31_____CHUPIT_LIMITED_20211101 >									
339 	//        < Thf1W3VF29r3DDuHkNE9W9SjKjNikwx8X9pi3Bf546OyWzpsU798Se35H1Z88jb0 >									
340 	//        <  u =="0.000000000000000001" : ] 000000412616871.512249000000000000 ; 000000426546396.884615000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000002759A7728ADBB0 >									
342 	//     < RUSS_PFIV_I_metadata_line_32_____ZHERNOVSKY_I_MINING_PROCESS_COMPLEX_20211101 >									
343 	//        < 6EovEiv7MNNTz8WJ7VD91prrbS7c39h67Qwt20iUe00N5Dl8JAXiO23GiFW10207 >									
344 	//        <  u =="0.000000000000000001" : ] 000000426546396.884615000000000000 ; 000000439891253.488242000000000000 ] >									
345 	//        < 0x0000000000000000000000000000000000000000000000000028ADBB029F3885 >									
346 	//     < RUSS_PFIV_I_metadata_line_33_____KSIEMP_20211101 >									
347 	//        < n6ju30Q1E7Sm6W83js3cCRCjV8yX8vk31wmAXurjAAB4280sMMfhCqDi90mKxmBX >									
348 	//        <  u =="0.000000000000000001" : ] 000000439891253.488242000000000000 ; 000000453066313.816076000000000000 ] >									
349 	//        < 0x0000000000000000000000000000000000000000000000000029F38852B35307 >									
350 	//     < RUSS_PFIV_I_metadata_line_34_____STROITELNY_MONTAZHNYI_TREST_20211101 >									
351 	//        < 9Dq521y2mg3I879l1nYUco6YJww30s1DvF0bA2IjYcb9JQ16rL4l51KePvQSN6pp >									
352 	//        <  u =="0.000000000000000001" : ] 000000453066313.816076000000000000 ; 000000467758676.192767000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000002B353072C9BE3C >									
354 	//     < RUSS_PFIV_I_metadata_line_35_____VTORMETSNAB_20211101 >									
355 	//        < qnmiyydPSu3g15B94nLHE9qsLPUo075A91Y0gDkDj0MTQ93IvHy6l756DeO4259N >									
356 	//        <  u =="0.000000000000000001" : ] 000000467758676.192767000000000000 ; 000000482526459.327522000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000002C9BE3C2E046E6 >									
358 	//     < RUSS_PFIV_I_metadata_line_36_____DOLOMIT_20211101 >									
359 	//        < a4Bc63HU4lZY4SJ45j1a8586L171JqKkW76stGAD85wpwbfo91romang34gRdUdF >									
360 	//        <  u =="0.000000000000000001" : ] 000000482526459.327522000000000000 ; 000000495829496.749937000000000000 ] >									
361 	//        < 0x000000000000000000000000000000000000000000000000002E046E62F49366 >									
362 	//     < RUSS_PFIV_I_metadata_line_37_____KALUGA_ELECTRIC_STEELMAKING_PLANT_20211101 >									
363 	//        < qJ8qGgOLLx72su7290so8GaRlOm1eYOs96BKRqnT1WY8f4p26pHi1T1I8i9HMiU4 >									
364 	//        <  u =="0.000000000000000001" : ] 000000495829496.749937000000000000 ; 000000510228335.542233000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000002F4936630A8BF2 >									
366 	//     < RUSS_PFIV_I_metadata_line_38_____LIPETSKOMBANK_20211101 >									
367 	//        < 65H80RwFEoi5eV8q5FFsLrbsjf31VGmK1L30539S8k13QfxdyFa2sCZQuWP0Wlm5 >									
368 	//        <  u =="0.000000000000000001" : ] 000000510228335.542233000000000000 ; 000000524430421.901071000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000030A8BF232037A2 >									
370 	//     < RUSS_PFIV_I_metadata_line_39_____NIZHNESERGINSKY_HARDWARE_METALL_WORKS_20211101 >									
371 	//        < W8NOHc56sFHo6857xTV846A3a0N5xnZ3OcTg9oeOW879TN939cgkwX93rT3kCLJj >									
372 	//        <  u =="0.000000000000000001" : ] 000000524430421.901071000000000000 ; 000000537919573.612975000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000032037A2334CCD5 >									
374 	//     < RUSS_PFIV_I_metadata_line_40_____KALUGA_SCIENTIFIC_PROD_ELECTROMETALL_PLANT_20211101 >									
375 	//        < PpkCSQ6MTU8dFm13u4pW25WsiyfcMEMtwn8kPWw8kxck1ltsKBF6pNPoITD8dd69 >									
376 	//        <  u =="0.000000000000000001" : ] 000000537919573.612975000000000000 ; 000000551263562.969539000000000000 ] >									
377 	//        < 0x00000000000000000000000000000000000000000000000000334CCD53492954 >									
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