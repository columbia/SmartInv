1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFIII_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFIII_III_883		"	;
8 		string	public		symbol =	"	RUSS_PFIII_III_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1078457842134810000000000000					;	
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
92 	//     < RUSS_PFIII_III_metadata_line_1_____MOSENERGO_20251101 >									
93 	//        < KU0tV07E5w2pu55F4iKf4Ul447N717k7NInvZitTM2thMO8o7deh1i980BaOmrFf >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000026348683.132683100000000000 ] >									
95 	//        < 0x0000000000000000000000000000000000000000000000000000000000283474 >									
96 	//     < RUSS_PFIII_III_metadata_line_2_____CENTRAL_REPAIRS_A_MECHANICAL_PLANT_20251101 >									
97 	//        < 7mhR5JUKJAKg51NMmBs8G3Nc4GWA9HPv03ly0na6W4ds7N8Jg0sJ8CmtV71SWAnr >									
98 	//        <  u =="0.000000000000000001" : ] 000000026348683.132683100000000000 ; 000000048960344.108822700000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000002834744AB522 >									
100 	//     < RUSS_PFIII_III_metadata_line_3_____CENT_REMONTNO_MEKHANICHESK_ZAVOD_20251101 >									
101 	//        < 1gjh1SLsMi9fQoGGY8D9hZSkwbRl3m0VnpkGI5z7PwAD5evYU9du93XIiay3l8NU >									
102 	//        <  u =="0.000000000000000001" : ] 000000048960344.108822700000000000 ; 000000076994608.250975800000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000004AB522757C05 >									
104 	//     < RUSS_PFIII_III_metadata_line_4_____ENERGOINVEST_ME_20251101 >									
105 	//        < HWwYRfK10FhSc806gZmi67MJt15w3CwJgA3WQle0YUaM9yH2y5Cr2B1DCmS6jl2Z >									
106 	//        <  u =="0.000000000000000001" : ] 000000076994608.250975800000000000 ; 000000107388070.869304000000000000 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000000000757C05A3DC77 >									
108 	//     < RUSS_PFIII_III_metadata_line_5_____ENERGOKONSALT_20251101 >									
109 	//        < 2uT8JkW99nrV5L7cJXO6Gw361bjGf6h9B6U9501QXj913NG91Y8VeQh8MYcwur7v >									
110 	//        <  u =="0.000000000000000001" : ] 000000107388070.869304000000000000 ; 000000128539849.595112000000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000A3DC77C422E1 >									
112 	//     < RUSS_PFIII_III_metadata_line_6_____REMONT_INGENERNYH_KOMMUNIKACIY_20251101 >									
113 	//        < 5izo3UtLAPqU9wHd5ph7khJ9tk0cHs6F1S0A2nOhb5fbI0r78345UwFX4Z6I00B2 >									
114 	//        <  u =="0.000000000000000001" : ] 000000128539849.595112000000000000 ; 000000147601305.755336000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000C422E1E138C3 >									
116 	//     < RUSS_PFIII_III_metadata_line_7_____KVALITEK_NCO_20251101 >									
117 	//        < 77rn34FjRrL54V3pZYL1tV326TRhcnAvDO537VR646Fk84MQJEeHi534fzsV1BNa >									
118 	//        <  u =="0.000000000000000001" : ] 000000147601305.755336000000000000 ; 000000167529964.589131000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000E138C3FFA164 >									
120 	//     < RUSS_PFIII_III_metadata_line_8_____CENT_MECHA_MAINTENANCE_PLANT_20251101 >									
121 	//        < JH3UUItWchIfc3zHTr7947210gV0VflrTXJMpxo9g9c6pDQ791HhKhKiywT5E6k4 >									
122 	//        <  u =="0.000000000000000001" : ] 000000167529964.589131000000000000 ; 000000199798271.310913000000000000 ] >									
123 	//        < 0x000000000000000000000000000000000000000000000000000FFA164130DE33 >									
124 	//     < RUSS_PFIII_III_metadata_line_9_____EPA_ENERGY_A_INDUSTRIAL_20251101 >									
125 	//        < 1hO26sf0Hp4iHh4vfxx5D757HoAsdK971X54CD2Fs6hTaS9e8g5xOi90KE8ZWkNg >									
126 	//        <  u =="0.000000000000000001" : ] 000000199798271.310913000000000000 ; 000000234648490.856804000000000000 ] >									
127 	//        < 0x00000000000000000000000000000000000000000000000000130DE331660B91 >									
128 	//     < RUSS_PFIII_III_metadata_line_10_____VYATENERGOMONTAZH_20251101 >									
129 	//        < 6mC4r5DUm2WVa5v4vqtPYao6Ie8ZLOS974X4ElxTvWGTXoFWwfXMZG1nGkp1760a >									
130 	//        <  u =="0.000000000000000001" : ] 000000234648490.856804000000000000 ; 000000262156538.172327000000000000 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000000001660B9119004E6 >									
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
174 	//     < RUSS_PFIII_III_metadata_line_11_____TELPOENERGOREMONT_20251101 >									
175 	//        < J81n352Cdp6zr6o420EN757AI3Y9B40Thqn3st46I2zvT4yYd3jMFAP2JugHkE52 >									
176 	//        <  u =="0.000000000000000001" : ] 000000262156538.172327000000000000 ; 000000282666271.217647000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000019004E61AF5083 >									
178 	//     < RUSS_PFIII_III_metadata_line_12_____TSK_NOVAYA_MOSKVA_20251101 >									
179 	//        < R727rCUo5q39Ze6bri9l443wV07wF7F4fr1qn7V6uVely6yEWd79a5gK9C31Noum >									
180 	//        <  u =="0.000000000000000001" : ] 000000282666271.217647000000000000 ; 000000304736618.275600000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000001AF50831D0FDBE >									
182 	//     < RUSS_PFIII_III_metadata_line_13_____ENERGO_KRAN_20251101 >									
183 	//        < qVuxrs044Uy8ap5HrdzEQM52xr79uZonp63XRz8Pp4ifPqdoT7SG8kB5EiD8iwtL >									
184 	//        <  u =="0.000000000000000001" : ] 000000304736618.275600000000000000 ; 000000328503713.695989000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001D0FDBE1F541C3 >									
186 	//     < RUSS_PFIII_III_metadata_line_14_____TELPOENERGOREMONT_MOSKVA_20251101 >									
187 	//        < u7cizu6QTn2EA139L1uS6ds2iAHxkwcT96tskplYxgV889QVt7G3NKiZYbXo55w6 >									
188 	//        <  u =="0.000000000000000001" : ] 000000328503713.695989000000000000 ; 000000356064807.811843000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000001F541C321F4FD1 >									
190 	//     < RUSS_PFIII_III_metadata_line_15_____TELPOENERGOREMONT_NOVOMICHURINSK_20251101 >									
191 	//        < OSs0RY6FjXIbZbKQqiXo43KjgM77nv4UrP261EMK0lX647a6OT69qZ360w1AuFBh >									
192 	//        <  u =="0.000000000000000001" : ] 000000356064807.811843000000000000 ; 000000382600573.444353000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000021F4FD1247CD59 >									
194 	//     < RUSS_PFIII_III_metadata_line_16_____TREST_GIDROMONTAZH_20251101 >									
195 	//        < zTq4rQcCHXeI55i2J4GeI8M5w7c13GZ4Jh5n4YpKvzToVoY99U63X420WqOIHv6g >									
196 	//        <  u =="0.000000000000000001" : ] 000000382600573.444353000000000000 ; 000000403418303.703349000000000000 ] >									
197 	//        < 0x00000000000000000000000000000000000000000000000000247CD592679146 >									
198 	//     < RUSS_PFIII_III_metadata_line_17_____MTS_20251101 >									
199 	//        < B6K83kndVzu71x8I2ocfIW8n31yl2b3wunX0DOvMBQJ9Ikop7CFM31LKdq39qnJ9 >									
200 	//        <  u =="0.000000000000000001" : ] 000000403418303.703349000000000000 ; 000000425448616.170663000000000000 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000000026791462892EDE >									
202 	//     < RUSS_PFIII_III_metadata_line_18_____MTS_USD_20251101 >									
203 	//        < B2k06RCJ2jG8ph024I4aAC0JF5J8UEEpNXNJdC6H7NWO0M84JnQQRB9201x2qqgB >									
204 	//        <  u =="0.000000000000000001" : ] 000000425448616.170663000000000000 ; 000000448511636.722500000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000002892EDE2AC5FDC >									
206 	//     < RUSS_PFIII_III_metadata_line_19_____UZDUNROBITA_20251101 >									
207 	//        < c64lvHl4OzLz96O8614BXw4NtQ6JxXRBaAdnPW7rx2w73MG6m9HlishK9C0R4Tlv >									
208 	//        <  u =="0.000000000000000001" : ] 000000448511636.722500000000000000 ; 000000484095357.512453000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000002AC5FDC2E2ABC0 >									
210 	//     < RUSS_PFIII_III_metadata_line_20_____UZDUNROBITA_SUM_20251101 >									
211 	//        < QyEGdYm5nMVbzbYlHrvIMQm9P9y6Ew6nP5ov22Xr4vVog8oIPabcUU4ZhehinjB7 >									
212 	//        <  u =="0.000000000000000001" : ] 000000484095357.512453000000000000 ; 000000517792435.753567000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000002E2ABC031616AC >									
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
256 	//     < RUSS_PFIII_III_metadata_line_21_____BELARUSKALI_20251101 >									
257 	//        < Ajvi12p0FHXC9ex3AW87w15519xacTp0j9GG1pOThAab5dA5qW8d6n4lYfpm39C7 >									
258 	//        <  u =="0.000000000000000001" : ] 000000517792435.753567000000000000 ; 000000546405842.709607000000000000 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000000031616AC341BFC8 >									
260 	//     < RUSS_PFIII_III_metadata_line_22_____URALKALI_20251101 >									
261 	//        < 5o42JVA9JO2ak1K405Xx13aB51n4lchy4bVAqmHy2p0sE702GrP59L6kK3EmA0zN >									
262 	//        <  u =="0.000000000000000001" : ] 000000546405842.709607000000000000 ; 000000565920449.939658000000000000 ] >									
263 	//        < 0x00000000000000000000000000000000000000000000000000341BFC835F86AD >									
264 	//     < RUSS_PFIII_III_metadata_line_23_____POTASH_CORP_20251101 >									
265 	//        < ik7UL83M8xPJtk5b66fJZO4WjHg58HZ1wi55BV6P239BvDjbi4uWX943I0Y8C10e >									
266 	//        <  u =="0.000000000000000001" : ] 000000565920449.939658000000000000 ; 000000591224179.208149000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000035F86AD38622F2 >									
268 	//     < RUSS_PFIII_III_metadata_line_24_____K+S_20251101 >									
269 	//        < 4Dj3LUavT34T1P0902K71M9Avj5G46mXPtrzi9iM3H8U6nxKK9dRvz318762Yhtl >									
270 	//        <  u =="0.000000000000000001" : ] 000000591224179.208149000000000000 ; 000000625745990.982924000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000038622F23BAD007 >									
272 	//     < RUSS_PFIII_III_metadata_line_25_____FIRMA MORTDATEL OOO_20251101 >									
273 	//        < d38h3Iie9M5ccPIU6tqugpPbp8AE9Ktq8iXeTkWQMuvcmENT3V63aCRgetN8YYw7 >									
274 	//        <  u =="0.000000000000000001" : ] 000000625745990.982924000000000000 ; 000000646002266.335273000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000003BAD0073D9B8A3 >									
276 	//     < RUSS_PFIII_III_metadata_line_26_____CHELYABINSK_METTALURGICAL_PLANT_20251101 >									
277 	//        < P5RyEa2OET9625IlI6RzeBvEc1MZ4129kch6dP95bcm5l1L15c6P8R1uf6IWl4Pe >									
278 	//        <  u =="0.000000000000000001" : ] 000000646002266.335273000000000000 ; 000000678195546.056294000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000003D9B8A340AD823 >									
280 	//     < RUSS_PFIII_III_metadata_line_27_____RASPADSKAYA_20251101 >									
281 	//        < WYPNpI1q8Ci9kZpeT9q783eyDKp5if3LlnRoN4xX7EKvPqa4s2smLD2Upu1gcz7z >									
282 	//        <  u =="0.000000000000000001" : ] 000000678195546.056294000000000000 ; 000000710561156.361060000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000040AD82343C3AF4 >									
284 	//     < RUSS_PFIII_III_metadata_line_28_____ROSNEFT_20251101 >									
285 	//        < Hf2XXX1p1ZCq0o2N82E4WX7t6pLmjCHpM0sS09YhaJdKKaOUD503CDN1OqgGwWO4 >									
286 	//        <  u =="0.000000000000000001" : ] 000000710561156.361060000000000000 ; 000000735399171.427242000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000043C3AF4462214D >									
288 	//     < RUSS_PFIII_III_metadata_line_29_____ROSTELECOM_20251101 >									
289 	//        < r89v8Y8zIj48Mj419sD438Z1S3FmOLN4x5aNVweXwF7vI2W6N9i16GGw53u7kY2V >									
290 	//        <  u =="0.000000000000000001" : ] 000000735399171.427242000000000000 ; 000000765414377.697473000000000000 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000000000462214D48FEDFE >									
292 	//     < RUSS_PFIII_III_metadata_line_30_____ROSTELECOM_USD_20251101 >									
293 	//        < 4KI53toyir6nVXQhYS6sP65O4Yq8U6y80aLd4k0LBahOzZymlvW9QK926jpFv9Qt >									
294 	//        <  u =="0.000000000000000001" : ] 000000765414377.697473000000000000 ; 000000798515339.044887000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000048FEDFE4C2700E >									
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
338 	//     < RUSS_PFIII_III_metadata_line_31_____SBERBANK_20251101 >									
339 	//        < AC1UWf17bVQh699h2Zi8ShT4lRbrvjmAfRyFmJJZE01q35S4GKtR0N4lG8oFIF57 >									
340 	//        <  u =="0.000000000000000001" : ] 000000798515339.044887000000000000 ; 000000828814559.936298000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000004C2700E4F0ABB0 >									
342 	//     < RUSS_PFIII_III_metadata_line_32_____SBERBANK_USD_20251101 >									
343 	//        < lUXzT91tyX71i2iP6C24T44s297K91y3K1jb7Y62i2Oah3q1BftEUOyzc0O4Tc8o >									
344 	//        <  u =="0.000000000000000001" : ] 000000828814559.936298000000000000 ; 000000850603091.432855000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000004F0ABB0511EAD5 >									
346 	//     < RUSS_PFIII_III_metadata_line_33_____TATNEFT_20251101 >									
347 	//        < 3U0fpsB3yV02Y98jIQHI38fObNfmo8PKF0tWN29Xf31986Fb4610s4T4Ir5S6Vj0 >									
348 	//        <  u =="0.000000000000000001" : ] 000000850603091.432855000000000000 ; 000000875847428.467596000000000000 ] >									
349 	//        < 0x00000000000000000000000000000000000000000000000000511EAD55386FE7 >									
350 	//     < RUSS_PFIII_III_metadata_line_34_____TATNEFT_USD_20251101 >									
351 	//        < 7V4n7by5126105a5zw7EFrTvpS8aQx3IONLwc37ZG5P2S5H0o6COMMbw8xB1gE3r >									
352 	//        <  u =="0.000000000000000001" : ] 000000875847428.467596000000000000 ; 000000898107241.103375000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000005386FE755A6724 >									
354 	//     < RUSS_PFIII_III_metadata_line_35_____TRANSNEFT_20251101 >									
355 	//        < A5UlDlr5rYAu8CCyJtL1FApSFDo7Kt88r2uIER7jckP586dlm5GTJu3A68KT1AkJ >									
356 	//        <  u =="0.000000000000000001" : ] 000000898107241.103375000000000000 ; 000000917574796.104108000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000055A67245781BA8 >									
358 	//     < RUSS_PFIII_III_metadata_line_36_____TRANSNEFT_USD_20251101 >									
359 	//        < EuU8BeibJ9pKyNVK2BY6epaNyvrkWH08UGMEr4ztxfs9GRS2hfHRsX908wpNTL6j >									
360 	//        <  u =="0.000000000000000001" : ] 000000917574796.104108000000000000 ; 000000952573584.289162000000000000 ] >									
361 	//        < 0x000000000000000000000000000000000000000000000000005781BA85AD830E >									
362 	//     < RUSS_PFIII_III_metadata_line_37_____ROSOBORONEKSPORT_20251101 >									
363 	//        < aw5iDHFoqwaH1NlDXJ95EF19e6i0aiLwSs23pO68uPzu4PIdn3l193iAJj3uMEP6 >									
364 	//        <  u =="0.000000000000000001" : ] 000000952573584.289162000000000000 ; 000000986266960.467029000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000005AD830E5E0EC88 >									
366 	//     < RUSS_PFIII_III_metadata_line_38_____BASHNEFT_20251101 >									
367 	//        < 3S43e81x3U17Uxi9143FuXqcX7D3MaT2sw8Z20bh16SpU3503BM36cNemoV8jcMe >									
368 	//        <  u =="0.000000000000000001" : ] 000000986266960.467029000000000000 ; 000001013961666.278180000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000005E0EC8860B2EC7 >									
370 	//     < RUSS_PFIII_III_metadata_line_39_____BASHNEFT_AB_20251101 >									
371 	//        < 4JFC2Sdh8wl1B5rp5379p942rO11WtyETK9q1Fd6Y38ww5HHkV76JDOldNQ1XwTc >									
372 	//        <  u =="0.000000000000000001" : ] 000001013961666.278180000000000000 ; 000001049358698.036490000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000060B2EC764131BE >									
374 	//     < RUSS_PFIII_III_metadata_line_40_____RAIFFEISENBANK_20251101 >									
375 	//        < 60D7K6h1jXvwj1XvGz8Snsh5q4w7Ex4JSOo5jZ3bxQa0Iq6W94qOi370fyEuHJ68 >									
376 	//        <  u =="0.000000000000000001" : ] 000001049358698.036490000000000000 ; 000001078457842.134810000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000064131BE66D9898 >									
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