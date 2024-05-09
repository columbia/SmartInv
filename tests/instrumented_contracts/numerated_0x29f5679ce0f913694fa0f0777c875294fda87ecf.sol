1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RE_Portfolio_IV_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RE_Portfolio_IV_883		"	;
8 		string	public		symbol =	"	RE883IV		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1286737478908320000000000000					;	
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
92 	//     < RE_Portfolio_IV_metadata_line_1_____Ark_Syndicate_Management_Limited_20250515 >									
93 	//        < GNK77qUw5nah0bVnAR6K96cg0y176f3N56yy9l5037es113KkxZ91MQ6i0wU7ws7 >									
94 	//        < 1E-018 limites [ 1E-018 ; 33233233,2929992 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000C615E5B5 >									
96 	//     < RE_Portfolio_IV_metadata_line_2_____Ark_Syndicate_Management_Limited_20250515 >									
97 	//        < bhGU2V2uwRMiIg7H9X7jwaw06437iSTfJ1DUFJzVRNOZubV77p6HC3C454m5u005 >									
98 	//        < 1E-018 limites [ 33233233,2929992 ; 56512602,1085473 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000C615E5B5150D76526 >									
100 	//     < RE_Portfolio_IV_metadata_line_3_____Ark_Syndicate_Management_Limited_20250515 >									
101 	//        < 0966mB9LBI8sRJ48K9E1p3q1t86M1106Kog5ewl8DW7GF04l33z2iFo1RiL40bS5 >									
102 	//        < 1E-018 limites [ 56512602,1085473 ; 93152756,5213228 ] >									
103 	//        < 0x0000000000000000000000000000000000000000000000150D7652622B3BD578 >									
104 	//     < RE_Portfolio_IV_metadata_line_4_____Ark_Syndicate_Management_Limited_20250515 >									
105 	//        < n93Nc33HhleZfZHKY1U2HST89Zaq7PD0Zzh18ds6Y1b0ZVT1390kvKOh83weQc0y >									
106 	//        < 1E-018 limites [ 93152756,5213228 ; 107851101,880834 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000022B3BD578282D7BAA0 >									
108 	//     < RE_Portfolio_IV_metadata_line_5_____Ark_Syndicate_Management_Limited_20250515 >									
109 	//        < b26vmyq4pxJ6M6Q672b3r9Hz12nixaL8TsURft2A7nvJ6K40m16MJ8Kg9O88g57C >									
110 	//        < 1E-018 limites [ 107851101,880834 ; 170318758,593458 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000282D7BAA03F72DCF07 >									
112 	//     < RE_Portfolio_IV_metadata_line_6_____Artis_Group_20250515 >									
113 	//        < dGr6S1T35w70AUsC0A4Dk8BurwXAHmVR7gV30q1N3HJ996a1UjkLX8Tk2RLSSY4y >									
114 	//        < 1E-018 limites [ 170318758,593458 ; 200430677,593728 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000003F72DCF074AAA8F363 >									
116 	//     < RE_Portfolio_IV_metadata_line_7_____Artis_Group_20250515 >									
117 	//        < sfRoP1CWA8ITVJ458XyvA06Phv0KzxmnUmK9xIJMbt0F3xAU479O9iPwYpP97BW2 >									
118 	//        < 1E-018 limites [ 200430677,593728 ; 246257644,7963 ] >									
119 	//        < 0x00000000000000000000000000000000000000000000004AAA8F3635BBCF5A73 >									
120 	//     < RE_Portfolio_IV_metadata_line_8_____Ascot_Underwriting_Limited_20250515 >									
121 	//        < 25fAKnhY57s0QI1u2Kp1KH2uq8D0TNC7Ix3XnaxVu45Yek6sO3V010g9gfWZn805 >									
122 	//        < 1E-018 limites [ 246257644,7963 ; 315699955,468848 ] >									
123 	//        < 0x00000000000000000000000000000000000000000000005BBCF5A73759B7E90E >									
124 	//     < RE_Portfolio_IV_metadata_line_9_____Ascot_Underwriting_Limited_20250515 >									
125 	//        < 6o6Utc5bk15euaVkZ7DTaebNGk1UzH77Jp6Fx2qxjeBtN7826TiWAqFVs2QImB1W >									
126 	//        < 1E-018 limites [ 315699955,468848 ; 345515317,012035 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000759B7E90E80B6E8AA9 >									
128 	//     < RE_Portfolio_IV_metadata_line_10_____Asia_CapitaL_Rereinsurance_group_pte_Limited_Am_Am_20250515 >									
129 	//        < S0BAWavYHkixv3FmKSJX4o385OjyuG4nD8x2Bl37KAM6NN5OQl6FBK0MZwB39MLR >									
130 	//        < 1E-018 limites [ 345515317,012035 ; 417699154,358107 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000080B6E8AA99B9AE561F >									
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
174 	//     < RE_Portfolio_IV_metadata_line_11_____Aspen_Insurance_Holdings_Limited_20250515 >									
175 	//        < ncIBKNkx06tEz50Bb0KH6wEkX5RP30XwcJGIgch3FzVKTFQN9jn4f9OTDxrY9VbT >									
176 	//        < 1E-018 limites [ 417699154,358107 ; 434329542,732928 ] >									
177 	//        < 0x00000000000000000000000000000000000000000000009B9AE561FA1CCE4B95 >									
178 	//     < RE_Portfolio_IV_metadata_line_12_____Aspen_Insurance_UK_Limited_A_A_20250515 >									
179 	//        < 66g20ollYBow0DQ67N7qi5YlXzdRyN9WaL700Y1AXCb0763iRZI13pkx8FjRd38Y >									
180 	//        < 1E-018 limites [ 434329542,732928 ; 445834677,879017 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000A1CCE4B95A6161BCFF >									
182 	//     < RE_Portfolio_IV_metadata_line_13_____Aspen_Managing_Agency_Limited_20250515 >									
183 	//        < 9kwf2FyXdLl9O3OkTv4QUTS33Y8tNZ3nH3bRd04y8xNFH6e7938BiXbxuXCBRfz4 >									
184 	//        < 1E-018 limites [ 445834677,879017 ; 491843738,404566 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000A6161BCFFB739DFE44 >									
186 	//     < RE_Portfolio_IV_metadata_line_14_____Aspen_Managing_Agency_Limited_20250515 >									
187 	//        < 0tN5A17tlVAC40ksVor267d57HhJB0bwYsHfY6loZ7Mgq3wCswG92Y35ysbpbKm0 >									
188 	//        < 1E-018 limites [ 491843738,404566 ; 504405119,006281 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000B739DFE44BBE7D2390 >									
190 	//     < RE_Portfolio_IV_metadata_line_15_____Aspen_Managing_Agency_Limited_20250515 >									
191 	//        < GO1QB0HJkz74wdfZyWGA0bXFbbpQP9OXF9h46am9CUuhUslCjX1JIKZjR6wtD6AG >									
192 	//        < 1E-018 limites [ 504405119,006281 ; 564261471,246337 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000BBE7D2390D2342AF28 >									
194 	//     < RE_Portfolio_IV_metadata_line_16_____Assicurazioni_Generali_SPA_A_20250515 >									
195 	//        < R3R7DZvZiZLBuPGgWp6Mp5IF49g2Cs28q3iqQ187MUIPfoY372Y50ttFL8XY5N41 >									
196 	//        < 1E-018 limites [ 564261471,246337 ; 575032246,721798 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000D2342AF28D63759554 >									
198 	//     < RE_Portfolio_IV_metadata_line_17_____Assicurazioni_Generalli_Spa_20250515 >									
199 	//        < 13n0ANWi89iZ1P68eNJ29156449Q9bC1HquHnK145hS55ZdTEX1psH8CKfQ1iuy3 >									
200 	//        < 1E-018 limites [ 575032246,721798 ; 601358654,525638 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000D63759554E00607E60 >									
202 	//     < RE_Portfolio_IV_metadata_line_18_____Assurances_Mutuelles_De_France_Ap_A_20250515 >									
203 	//        < AI393JLT74408s029gIg23Cj2IcJ5AX9VddR5mSIgX8GLx0y9g1CHG9EidQU3nRP >									
204 	//        < 1E-018 limites [ 601358654,525638 ; 624452202,696774 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000E00607E60E8A0673A1 >									
206 	//     < RE_Portfolio_IV_metadata_line_19_____Asta_Managing_Agency_Limited_20250515 >									
207 	//        < 6S7227YRsaBZ684bB7ov8Za6boNgpB744C2v4ny0J6aNVRLUWPSl262blC7YI94C >									
208 	//        < 1E-018 limites [ 624452202,696774 ; 643038877,043383 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000E8A0673A1EF8CF774C >									
210 	//     < RE_Portfolio_IV_metadata_line_20_____Asta_Managing_Agency_Limited_20250515 >									
211 	//        < F4D77bz7KJNtyMiN7lh0dokp8gANkKTcV1D8OhMgl9Of1jaBs3MwEe2TDi6XWAKG >									
212 	//        < 1E-018 limites [ 643038877,043383 ; 699352562,34391 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000EF8CF774C104877549E >									
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
256 	//     < RE_Portfolio_IV_metadata_line_21_____Asta_Managing_Agency_Limited_20250515 >									
257 	//        < LftlGQ8ABEzLOWuxBMcgX52SuCJt6er7xER8zfIe5I5zA68ibiGqWWz8P68y57n1 >									
258 	//        < 1E-018 limites [ 699352562,34391 ; 741743264,010354 ] >									
259 	//        < 0x00000000000000000000000000000000000000000000104877549E1145226875 >									
260 	//     < RE_Portfolio_IV_metadata_line_22_____Asta_Managing_Agency_Limited_20250515 >									
261 	//        < ZmJx1npTDGYL7BsMJMouXMZTVznSe4N3W9no2FqzdHCQn9iHVcakAeUayHhD0KxT >									
262 	//        < 1E-018 limites [ 741743264,010354 ; 758213668,448121 ] >									
263 	//        < 0x00000000000000000000000000000000000000000000114522687511A74E4030 >									
264 	//     < RE_Portfolio_IV_metadata_line_23_____Asta_Managing_Agency_Limited_20250515 >									
265 	//        < 543y486VlEuGSna98wnEpgn1x6o8s6yKctZrUz7vUj8GY253vA5689a2JcPD9yVL >									
266 	//        < 1E-018 limites [ 758213668,448121 ; 771595164,020047 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000011A74E403011F710CAE6 >									
268 	//     < RE_Portfolio_IV_metadata_line_24_____Asta_Managing_Agency_Limited_20250515 >									
269 	//        < r3U6NyOl6kE797vafUX44OK86KtsK9G326a1te97PR51lVwD1V4Ni1vrj6m74ftx >									
270 	//        < 1E-018 limites [ 771595164,020047 ; 820866271,535796 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000011F710CAE6131CBE8945 >									
272 	//     < RE_Portfolio_IV_metadata_line_25_____Asta_Managing_Agency_Limited_20250515 >									
273 	//        < zdNa9kA870ND7JTy25rrQe1f8BEnqbp0janxMWfp8nnY1j9pX990rig356SDKmyy >									
274 	//        < 1E-018 limites [ 820866271,535796 ; 832162888,135598 ] >									
275 	//        < 0x00000000000000000000000000000000000000000000131CBE8945136013CE21 >									
276 	//     < RE_Portfolio_IV_metadata_line_26_____Asta_Managing_Agency_Limited_20250515 >									
277 	//        < 9IBX1W05z7kXE6viPk0w69bRDngQ84C3RyS8FijXLKVE55DKs6KbWGga0v3Sn80m >									
278 	//        < 1E-018 limites [ 832162888,135598 ; 853826333,353964 ] >									
279 	//        < 0x00000000000000000000000000000000000000000000136013CE2113E133996B >									
280 	//     < RE_Portfolio_IV_metadata_line_27_____Asta_Managing_Agency_Limited_20250515 >									
281 	//        < H3LLWhD3RZF7Qhcw9Ps1gawwS6CSC6Sb25b093D34308d6aw024cL8aTIvFUrH0n >									
282 	//        < 1E-018 limites [ 853826333,353964 ; 873606943,744548 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000013E133996B14571A6A5A >									
284 	//     < RE_Portfolio_IV_metadata_line_28_____Asta_Managing_Agency_Limited_20250515 >									
285 	//        < Zz0KWuhROZ6G0019574A3LH6C1fnSU8Ufd2474C0Z3NeZ7tp54b137BJiULrv0dM >									
286 	//        < 1E-018 limites [ 873606943,744548 ; 926867203,013495 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000014571A6A5A15948F1F21 >									
288 	//     < RE_Portfolio_IV_metadata_line_29_____Asta_Managing_Agency_Limited_20250515 >									
289 	//        < Y0R7uX28Tm9OyXs3QsNWWU7BJu2PYi9FI4243GY7jZ2F4N9m0W91m82c0XZjEPAn >									
290 	//        < 1E-018 limites [ 926867203,013495 ; 943650367,1903 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000015948F1F2115F89832A3 >									
292 	//     < RE_Portfolio_IV_metadata_line_30_____Asta_Managing_Agency_Limited_20250515 >									
293 	//        < QX6v1t8Jwv4WU6y0Z6SYADzW55BnD96qz2K7e6Opx61p9GgEDip7Q4qH21c355BH >									
294 	//        < 1E-018 limites [ 943650367,1903 ; 964042863,975243 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000015F89832A3167224ADB1 >									
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
338 	//     < RE_Portfolio_IV_metadata_line_31_____Asta_Managing_Agency_Limited_20250515 >									
339 	//        < Of4pSWtPyUQ2VN8EpyQR2l8ssd28Vs94woyA2udkUOCn1C3pYMVl6q0tGpYI4K0G >									
340 	//        < 1E-018 limites [ 964042863,975243 ; 1012544844,12417 ] >									
341 	//        < 0x00000000000000000000000000000000000000000000167224ADB117933CD3B0 >									
342 	//     < RE_Portfolio_IV_metadata_line_32_____Asta_Managing_Agency_Limited_20250515 >									
343 	//        < 7j215s65589GN9ZU2QmUUA50J7n24ja04n9xlV98eU1q2Kup59px1zN684vfK90r >									
344 	//        < 1E-018 limites [ 1012544844,12417 ; 1030763908,61855 ] >									
345 	//        < 0x0000000000000000000000000000000000000000000017933CD3B017FFD4E9C1 >									
346 	//     < RE_Portfolio_IV_metadata_line_33_____Asta_Managing_Agency_Limited_20250515 >									
347 	//        < zTqCw74u1QbCbnBUuLNaF93f0em0404L7Cfu5C2sSwv2NyfPe7ty0OGZ3p3SE0du >									
348 	//        < 1E-018 limites [ 1030763908,61855 ; 1064233725,87595 ] >									
349 	//        < 0x0000000000000000000000000000000000000000000017FFD4E9C118C753CD1F >									
350 	//     < RE_Portfolio_IV_metadata_line_34_____Asta_Managing_Agency_Limited_20250515 >									
351 	//        < Zgw7uai87T9aytL220y8DYs1DV89CdAVq58z0e3fWFfy3YEJng8w44mUGyg9u6id >									
352 	//        < 1E-018 limites [ 1064233725,87595 ; 1080233240,99136 ] >									
353 	//        < 0x0000000000000000000000000000000000000000000018C753CD1F1926B11FB7 >									
354 	//     < RE_Portfolio_IV_metadata_line_35_____Asta_Managing_Agency_Limited_20250515 >									
355 	//        < 9q1687xuSI2i4k02EpX54mAG4VvAd51w8W2vMG9Gd4lud53JNS8H2p3U60U6Li20 >									
356 	//        < 1E-018 limites [ 1080233240,99136 ; 1093559904,41456 ] >									
357 	//        < 0x000000000000000000000000000000000000000000001926B11FB719761FFF9D >									
358 	//     < RE_Portfolio_IV_metadata_line_36_____Asta_Managing_Agency_Limited_20250515 >									
359 	//        < 4AgVi9OFdzIqTS6tp1Q6OQtslObQxYUIN8qxMBb2OH0A4878K4Q2b1G9ZZk5IpId >									
360 	//        < 1E-018 limites [ 1093559904,41456 ;  ] >									
361 	//        < 0x0000000000000000000000000000000000000000000019761FFF9D1A400DE845 >									
362 	//     < RE_Portfolio_IV_metadata_line_37_____Asta_Managing_Agency_Limited_20250515 >									
363 	//        < 61stanSI9tYMGV31mzg2qru375J3K86mzAp20lL7OumeZHB1b1im53UnT2AevMH4 >									
364 	//        < 1E-018 limites [ 1127438024,49399 ; 1159792529,58135 ] >									
365 	//        < 0x000000000000000000000000000000000000000000001A400DE8451B00E6F6D2 >									
366 	//     < RE_Portfolio_IV_metadata_line_38_____Asta_Managing_Agency_Limited_20250515 >									
367 	//        < dSoSW0glrN7tk3f78wsuQDn3108u82l7W8MHs6UPI1uflTX8HQMD9z3oEnTovDe1 >									
368 	//        < 1E-018 limites [ 1159792529,58135 ; 1181038175,10479 ] >									
369 	//        < 0x000000000000000000000000000000000000000000001B00E6F6D21B7F893F1A >									
370 	//     < RE_Portfolio_IV_metadata_line_39_____Asta_Managing_Agency_Limited_20250515 >									
371 	//        < i7r131cOFs0zsf7Lc915ke695qbjq864CBF9lDkC9nm48P62xU4CBVssi8aFln5t >									
372 	//        < 1E-018 limites [ 1181038175,10479 ; 1238241050,28727 ] >									
373 	//        < 0x000000000000000000000000000000000000000000001B7F893F1A1CD47DE838 >									
374 	//     < RE_Portfolio_IV_metadata_line_40_____Asta_Managing_Agency_Limited_20250515 >									
375 	//        < f720wEA3DNcKbmzLwBsvBT5e3x5sA05Ol4JYBwoWr56Nh3MaPtcp7T5aePRxvphs >									
376 	//        < 1E-018 limites [ 1238241050,28727 ; 1286737478,90832 ] >									
377 	//        < 0x000000000000000000000000000000000000000000001CD47DE8381DF58D95A6 >									
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