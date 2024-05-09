1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXXXIII_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXXXIII_I_883		"	;
8 		string	public		symbol =	"	RUSS_PFXXXIII_I_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		613007041352206000000000000					;	
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
92 	//     < RUSS_PFXXXIII_I_metadata_line_1_____PIK_GROUP_20211101 >									
93 	//        < z3zUewe64j5qYRI19PtHpqVTN91R2qZ325aox2q7fHExFfD1b2fhR9DXoenHdmr8 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000016187729.897294500000000000 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000000018B355 >									
96 	//     < RUSS_PFXXXIII_I_metadata_line_2_____PIK_INDUSTRIYA_20211101 >									
97 	//        < laIhRgC7TSL1NdODDsKChdQ12C31NDBnC7wOfPv6JcOgA0tXvBxfsRAq7C16dN7F >									
98 	//        <  u =="0.000000000000000001" : ] 000000016187729.897294500000000000 ; 000000032943540.059724900000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000018B355324492 >									
100 	//     < RUSS_PFXXXIII_I_metadata_line_3_____STROYINVEST_20211101 >									
101 	//        < 5izj01U2N6IipFs0aP2621F4p4OuU4bs8qteHwmyF7L6A6qnvAhrtatVBd1je6PR >									
102 	//        <  u =="0.000000000000000001" : ] 000000032943540.059724900000000000 ; 000000046438645.309193900000000000 ] >									
103 	//        < 0x000000000000000000000000000000000000000000000000000032449246DC19 >									
104 	//     < RUSS_PFXXXIII_I_metadata_line_4_____PIK_TECHNOLOGY_20211101 >									
105 	//        < GMhLH3EBX187RW2pmvsEThZ9kTfYJHaq4208bH8Zb7f1z9U1l2dZbLa090c04oKT >									
106 	//        <  u =="0.000000000000000001" : ] 000000046438645.309193900000000000 ; 000000062322647.909619700000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000046DC195F18C9 >									
108 	//     < RUSS_PFXXXIII_I_metadata_line_5_____PIK_REGION_20211101 >									
109 	//        < 7XR7NC0j0AHV18y4r6as20hlK8T09oso4pe5EpoUMtZtys01MeI8GZZlzoO8xe2p >									
110 	//        <  u =="0.000000000000000001" : ] 000000062322647.909619700000000000 ; 000000079480616.368655700000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000005F18C979471E >									
112 	//     < RUSS_PFXXXIII_I_metadata_line_6_____PIK_NERUD_OOO_20211101 >									
113 	//        < WNkt40rq13368IwI6Ob5Hs40U3y220wm069zc5GUE21092yvCqaB0vwI9Qbv5ryu >									
114 	//        <  u =="0.000000000000000001" : ] 000000079480616.368655700000000000 ; 000000094795865.626811300000000000 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000000000079471E90A5A3 >									
116 	//     < RUSS_PFXXXIII_I_metadata_line_7_____PIK_MFS_OOO_20211101 >									
117 	//        < F1MQ6PIqh3hP7wW4X49pRoK8g7yggWtpK2jZO9141282L2z5po20G63l29l65AtO >									
118 	//        <  u =="0.000000000000000001" : ] 000000094795865.626811300000000000 ; 000000111472047.961209000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000000090A5A3AA17C5 >									
120 	//     < RUSS_PFXXXIII_I_metadata_line_8_____PIK_COMFORT_20211101 >									
121 	//        < deZD82iv135tkCeXUv5UZFmjC2Z0Oe5SFfOMZ7k9YY75CUq8Z5rc7Gi0oxVBp7q4 >									
122 	//        <  u =="0.000000000000000001" : ] 000000111472047.961209000000000000 ; 000000125528580.142460000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000AA17C5BF8A9A >									
124 	//     < RUSS_PFXXXIII_I_metadata_line_9_____TRADING_HOUSE_OSNOVA_20211101 >									
125 	//        < k9hGmWYoZJhUu62QhMLUHdDHCabqO53G6tUP516UO4IBt6zDTVK65VS80O23NlV1 >									
126 	//        <  u =="0.000000000000000001" : ] 000000125528580.142460000000000000 ; 000000139414144.338201000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000000BF8A9AD4BAA6 >									
128 	//     < RUSS_PFXXXIII_I_metadata_line_10_____KHROMTSOVSKY_KARIER_20211101 >									
129 	//        < TfF8aEydHnNNd1etIXLPTM6RD6v9mD44lpPalQww94x7nNgXJV84x2ceqtwLF69f >									
130 	//        <  u =="0.000000000000000001" : ] 000000139414144.338201000000000000 ; 000000154222771.839772000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000000D4BAA6EB5345 >									
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
174 	//     < RUSS_PFXXXIII_I_metadata_line_11_____480_KZHI_20211101 >									
175 	//        < 6M00Q0lADW1mbi2BXMz3y4Fu87BV6O9lGwJyX9N7xp4JEh8Tmw6YZGN9AW1zHTcW >									
176 	//        <  u =="0.000000000000000001" : ] 000000154222771.839772000000000000 ; 000000170050296.565889000000000000 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000000000EB534510379E6 >									
178 	//     < RUSS_PFXXXIII_I_metadata_line_12_____PIK_YUG_OOO_20211101 >									
179 	//        < 3ORx1jIN8HwJEc1H7ZclAr6O1D99eCQ2kW9BuPpyAt6c0SIC4MkqczmE4cjGMbI0 >									
180 	//        <  u =="0.000000000000000001" : ] 000000170050296.565889000000000000 ; 000000186653376.006379000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000010379E611CCF7A >									
182 	//     < RUSS_PFXXXIII_I_metadata_line_13_____YUGOOO_ORG_20211101 >									
183 	//        < P9y9aI1NRz4BoeOh05MD75r0U5YXTCU3d1P3oZl9Gw2mfB7TaAQb847571eSzhJ3 >									
184 	//        <  u =="0.000000000000000001" : ] 000000186653376.006379000000000000 ; 000000200674537.715874000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000011CCF7A132347E >									
186 	//     < RUSS_PFXXXIII_I_metadata_line_14_____KRASNAYA_PRESNYA_SUGAR_REFINERY_20211101 >									
187 	//        < 0IzgWy6LWL3ai5WEN9JG88UR78ge7E7oM6EiTZLm6DQgV4Zy901hztM5VYFNhp4m >									
188 	//        <  u =="0.000000000000000001" : ] 000000200674537.715874000000000000 ; 000000217172201.181365000000000000 ] >									
189 	//        < 0x00000000000000000000000000000000000000000000000000132347E14B60E4 >									
190 	//     < RUSS_PFXXXIII_I_metadata_line_15_____NOVOROSGRAGDANPROEKT_20211101 >									
191 	//        < u769yQ27OkLdv2jp9SfW58T85f64IAxI1mbJAe4BG2k60D7y49D9H55IKfj80E27 >									
192 	//        <  u =="0.000000000000000001" : ] 000000217172201.181365000000000000 ; 000000232516706.758014000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000014B60E4162CAD7 >									
194 	//     < RUSS_PFXXXIII_I_metadata_line_16_____STATUS_LAND_OOO_20211101 >									
195 	//        < xJQ9V70OT1553c4LRaFm8ut5qvWVi7Xv1y675H1e8aou0Q53r7fIsQaH8s73OoU5 >									
196 	//        <  u =="0.000000000000000001" : ] 000000232516706.758014000000000000 ; 000000247657972.835506000000000000 ] >									
197 	//        < 0x00000000000000000000000000000000000000000000000000162CAD7179E565 >									
198 	//     < RUSS_PFXXXIII_I_metadata_line_17_____PIK_PODYOM_20211101 >									
199 	//        < it59pS19C0gSmg3Nd42nxjrYf3i9H7rB199j3b476IQ7s1Nl1JdP0kRJEB4M8LnX >									
200 	//        <  u =="0.000000000000000001" : ] 000000247657972.835506000000000000 ; 000000263327663.945916000000000000 ] >									
201 	//        < 0x00000000000000000000000000000000000000000000000000179E565191CE5E >									
202 	//     < RUSS_PFXXXIII_I_metadata_line_18_____PODYOM_ORG_20211101 >									
203 	//        < k1M4f3ZiLmbd5n9DF2921m1pN6A25q1n9aWz7b0yvZgi8TZvxnjAFww67H6n6v21 >									
204 	//        <  u =="0.000000000000000001" : ] 000000263327663.945916000000000000 ; 000000278988882.017683000000000000 ] >									
205 	//        < 0x00000000000000000000000000000000000000000000000000191CE5E1A9B408 >									
206 	//     < RUSS_PFXXXIII_I_metadata_line_19_____PIK_COMFORT_OOO_20211101 >									
207 	//        < DU9lfmSeAZ180K2juVV0vSQQFaBb80hK2fyii6T9Qy5bJ6gaIS0tDHzs5zdh0S2n >									
208 	//        <  u =="0.000000000000000001" : ] 000000278988882.017683000000000000 ; 000000292381121.488323000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000001A9B4081BE2360 >									
210 	//     < RUSS_PFXXXIII_I_metadata_line_20_____PIK_KUBAN_20211101 >									
211 	//        < 50X8IDPDD1mH8Ih95WGV8Ot80nZai1Jsh4YO120g456b2pKroc6iXQZskwF54L09 >									
212 	//        <  u =="0.000000000000000001" : ] 000000292381121.488323000000000000 ; 000000306703437.073479000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000001BE23601D3FE08 >									
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
256 	//     < RUSS_PFXXXIII_I_metadata_line_21_____KUBAN_ORG_20211101 >									
257 	//        < vGvaz0h65TIMPCrzry2Z4YuL6bj2zV26701k086gdg2HB3Ih36d30hkUL5z9UeG1 >									
258 	//        <  u =="0.000000000000000001" : ] 000000306703437.073479000000000000 ; 000000321573864.237981000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000001D3FE081EAAECA >									
260 	//     < RUSS_PFXXXIII_I_metadata_line_22_____MORTON_OOO_20211101 >									
261 	//        < w3ROwK4J1DU1gHjNJVQHx2xqsJU7h47Ql1eD27WyZe67psTfm72R8V0kvZPc4a6d >									
262 	//        <  u =="0.000000000000000001" : ] 000000321573864.237981000000000000 ; 000000337170267.103618000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000001EAAECA2027B23 >									
264 	//     < RUSS_PFXXXIII_I_metadata_line_23_____ZAO_PIK_REGION_20211101 >									
265 	//        < vTJPeGbIWcb2lXFI3N76Bb4n4U74GBsk14UAGegcGgXHFXbfWj81Nqt1qx2IsvLq >									
266 	//        <  u =="0.000000000000000001" : ] 000000337170267.103618000000000000 ; 000000351909814.360443000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000002027B23218F8C5 >									
268 	//     < RUSS_PFXXXIII_I_metadata_line_24_____ZAO_MONETTSCHIK_20211101 >									
269 	//        < 7HbMXaUGFp00q0GYsF2stz7Ik7r066aKqOEZeIeRA1V95Y3S216Jj7963N6cz170 >									
270 	//        <  u =="0.000000000000000001" : ] 000000351909814.360443000000000000 ; 000000367934567.924359000000000000 ] >									
271 	//        < 0x00000000000000000000000000000000000000000000000000218F8C52316C71 >									
272 	//     < RUSS_PFXXXIII_I_metadata_line_25_____STROYFORMAT_OOO_20211101 >									
273 	//        < VOak7ot2nVj8VRE8xO3lM2fc9R6d3AR1Mos18G359kYWtZQVf2tL4FCyn4Gq84i1 >									
274 	//        <  u =="0.000000000000000001" : ] 000000367934567.924359000000000000 ; 000000384598034.749177000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002316C7124AD99B >									
276 	//     < RUSS_PFXXXIII_I_metadata_line_26_____VOLGA_FORM_REINFORCED_CONCRETE_PLANT_20211101 >									
277 	//        < DLxCsh2SjGd4oOZkxLiI2okRa64d46tUTH8dMW3F64tOv6kSvZP01Kli4jZbwY54 >									
278 	//        <  u =="0.000000000000000001" : ] 000000384598034.749177000000000000 ; 000000399701350.999592000000000000 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000000000024AD99B261E557 >									
280 	//     < RUSS_PFXXXIII_I_metadata_line_27_____ZARECHYE_SPORT_20211101 >									
281 	//        < hI2I7f1HY6xSKlUjj5j53RYGGsQ2VOFHP45p6rU81M8XSBhvTTp8zOB9hTS23l1c >									
282 	//        <  u =="0.000000000000000001" : ] 000000399701350.999592000000000000 ; 000000415911051.234629000000000000 ] >									
283 	//        < 0x00000000000000000000000000000000000000000000000000261E55727AA141 >									
284 	//     < RUSS_PFXXXIII_I_metadata_line_28_____PIK_PROFILE_OOO_20211101 >									
285 	//        < Q8xeZLTUk79T6G8p005401aMtlZ3txHcEUI59Tqsn1JSjq3OVdD77MUOFTu4C2z9 >									
286 	//        <  u =="0.000000000000000001" : ] 000000415911051.234629000000000000 ; 000000432761905.439778000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000027AA141294579F >									
288 	//     < RUSS_PFXXXIII_I_metadata_line_29_____FENTROUMA_HOLDINGS_LIMITED_20211101 >									
289 	//        < 7HKntZI8pj4cd79uOCqu70L7FTLY6lLBJZ6Z7x85TjVwXWBRFkOfv31nm6H2nY86 >									
290 	//        <  u =="0.000000000000000001" : ] 000000432761905.439778000000000000 ; 000000447779577.906738000000000000 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000000000294579F2AB41E6 >									
292 	//     < RUSS_PFXXXIII_I_metadata_line_30_____PODMOKOVYE_20211101 >									
293 	//        < x3OsfZ59Mtx8On965s6mbU261sz9epQR0w9Oq840o6e6h7c397g9nOv1CoYw0196 >									
294 	//        <  u =="0.000000000000000001" : ] 000000447779577.906738000000000000 ; 000000463796659.858658000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000002AB41E62C3B292 >									
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
338 	//     < RUSS_PFXXXIII_I_metadata_line_31_____STROYINVESTREGION_20211101 >									
339 	//        < 4kXpRpB439zf4sWeR4N5zt5v2zi04nReSPj49d2ON90EO4PQJsH40Q8ryqQ5dVr3 >									
340 	//        <  u =="0.000000000000000001" : ] 000000463796659.858658000000000000 ; 000000478509824.184394000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000002C3B2922DA25E6 >									
342 	//     < RUSS_PFXXXIII_I_metadata_line_32_____PIK_DEVELOPMENT_20211101 >									
343 	//        < g6jq1g8SfUZZ78I9qip0ZB0JW0Jlemm647ehM3Vw57ko8HfOe0ERN8zdjgtAOBaW >									
344 	//        <  u =="0.000000000000000001" : ] 000000478509824.184394000000000000 ; 000000491523817.941947000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000002DA25E62EE017E >									
346 	//     < RUSS_PFXXXIII_I_metadata_line_33_____TAKSOMOTORNIY_PARK_20211101 >									
347 	//        < q2gceUc2wajEI4PqIuG9M8X4pk3J5WIm69nx8q9a781Ch95dFKESU951OY0z5oL5 >									
348 	//        <  u =="0.000000000000000001" : ] 000000491523817.941947000000000000 ; 000000505004720.088999000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000002EE017E3029378 >									
350 	//     < RUSS_PFXXXIII_I_metadata_line_34_____KALTENBERG_LIMITED_20211101 >									
351 	//        < 28XNr5xcR359juzGQx7bBW5Kkz9ZFv6vZ8299NPi38OXrHyVc8So0WuOeQOP7NM8 >									
352 	//        <  u =="0.000000000000000001" : ] 000000505004720.088999000000000000 ; 000000521022862.045571000000000000 ] >									
353 	//        < 0x00000000000000000000000000000000000000000000000000302937831B048E >									
354 	//     < RUSS_PFXXXIII_I_metadata_line_35_____MAYAK_OOO_20211101 >									
355 	//        < LVmv2V48Y2cQcc2w3KV9KLhEDAdmzJf0J5naS9b04pJes5yyq82PETT04Sw65995 >									
356 	//        <  u =="0.000000000000000001" : ] 000000521022862.045571000000000000 ; 000000535712292.695713000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000031B048E3316E9D >									
358 	//     < RUSS_PFXXXIII_I_metadata_line_36_____MAYAK_ORG_20211101 >									
359 	//        < fAs5s4A5OB8MlRp65yPAKBvYyOPesXD5ze3YxNTEzlLxc17GBCmTqqnmlmS3W0b6 >									
360 	//        <  u =="0.000000000000000001" : ] 000000535712292.695713000000000000 ; 000000551476226.076981000000000000 ] >									
361 	//        < 0x000000000000000000000000000000000000000000000000003316E9D3497C67 >									
362 	//     < RUSS_PFXXXIII_I_metadata_line_37_____UDSK_OOO_20211101 >									
363 	//        < 5ZW2r8YyHuKmh6r0el9YiEbG4DCjXP5sUk7Z2xU8Ff72lg6Efyfy1zol2KHgw3jM >									
364 	//        <  u =="0.000000000000000001" : ] 000000551476226.076981000000000000 ; 000000565121164.831142000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000003497C6735E4E74 >									
366 	//     < RUSS_PFXXXIII_I_metadata_line_38_____ROSTOVSKOYE_MORE_OOO_20211101 >									
367 	//        < 4K2JW8HWbTFE29VYpMJLttKW441b7t294W9v39K3F63vmLb9bpF0NpIVy3NT836P >									
368 	//        <  u =="0.000000000000000001" : ] 000000565121164.831142000000000000 ; 000000581839536.204972000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000035E4E74377D112 >									
370 	//     < RUSS_PFXXXIII_I_metadata_line_39_____MONETCHIK_20211101 >									
371 	//        < 6FsG9cp2j7mW8Sfofq266914oWv45f0iha82wZMZYwANlW1am9N1dt6NW3ojLS3u >									
372 	//        <  u =="0.000000000000000001" : ] 000000581839536.204972000000000000 ; 000000595983530.105555000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000377D11238D6611 >									
374 	//     < RUSS_PFXXXIII_I_metadata_line_40_____KUSKOVSKOGO_ORDENA_ZNAK_POCHETA_CHEM_PLANT_20211101 >									
375 	//        < OR3pem0z9pfNDFAs3X7MGNrRChpbbHlA4VkB1rZjR4etT4NZBmo77F0In1fm9EvT >									
376 	//        <  u =="0.000000000000000001" : ] 000000595983530.105555000000000000 ; 000000613007041.352206000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000038D66113A75FE0 >									
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