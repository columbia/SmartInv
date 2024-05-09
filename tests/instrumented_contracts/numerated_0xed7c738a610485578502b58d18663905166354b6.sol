1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFIII_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFIII_I_883		"	;
8 		string	public		symbol =	"	RUSS_PFIII_I_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		575487268745056000000000000					;	
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
92 	//     < RUSS_PFIII_I_metadata_line_1_____MOSENERGO_20211101 >									
93 	//        < 9qi0K6IKsljxpHA90o4t87543H35309I55ziZM2y12Qn0ID4b2k44wUs4JKn9hTs >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000014261482.495416200000000000 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000000015C2E4 >									
96 	//     < RUSS_PFIII_I_metadata_line_2_____CENTRAL_REPAIRS_A_MECHANICAL_PLANT_20211101 >									
97 	//        < 80V6YJYyr0S27Xi0riCdzRiK6Z33318g2rIiFKmKHX0jCMNuC7a932pjgif7CmMr >									
98 	//        <  u =="0.000000000000000001" : ] 000000014261482.495416200000000000 ; 000000028986815.431527200000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000015C2E42C3AFA >									
100 	//     < RUSS_PFIII_I_metadata_line_3_____CENT_REMONTNO_MEKHANICHESK_ZAVOD_20211101 >									
101 	//        < Wy68yPWznG706kHKkIJ4705Ccf784n5w1NC5T1rC478dAr855x3GXA88869Fgido >									
102 	//        <  u =="0.000000000000000001" : ] 000000028986815.431527200000000000 ; 000000042023465.424191800000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000002C3AFA401F6B >									
104 	//     < RUSS_PFIII_I_metadata_line_4_____ENERGOINVEST_ME_20211101 >									
105 	//        < fgv432l2S264oGk1L3XM87a56kb8pGW657B9rLozXLJ74suWJpNQMpRC1B013KG5 >									
106 	//        <  u =="0.000000000000000001" : ] 000000042023465.424191800000000000 ; 000000057051832.795405300000000000 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000000000401F6B570DDF >									
108 	//     < RUSS_PFIII_I_metadata_line_5_____ENERGOKONSALT_20211101 >									
109 	//        < em6XCQG4P027T1M3gG68Y6XD0is5x0BN8r1Ka6MT94UK56J101hdYphE9Ln6DGa0 >									
110 	//        <  u =="0.000000000000000001" : ] 000000057051832.795405300000000000 ; 000000070843422.337362600000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000570DDF6C1936 >									
112 	//     < RUSS_PFIII_I_metadata_line_6_____REMONT_INGENERNYH_KOMMUNIKACIY_20211101 >									
113 	//        < f4qWPQ7AmoXh6H35Vly7qV3yMEy0074jkj6cRHjf05I1kwlk4be4c5wPxyd5DOYt >									
114 	//        <  u =="0.000000000000000001" : ] 000000070843422.337362600000000000 ; 000000084675221.337900200000000000 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000000000006C1936813442 >									
116 	//     < RUSS_PFIII_I_metadata_line_7_____KVALITEK_NCO_20211101 >									
117 	//        < yOkfhL08dK52B73Wh2hMO55f663a9SOc0X2Rv974eemBD20X61DIMI4Q02Ujs71e >									
118 	//        <  u =="0.000000000000000001" : ] 000000084675221.337900200000000000 ; 000000099439152.888193400000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000000081344297BB6B >									
120 	//     < RUSS_PFIII_I_metadata_line_8_____CENT_MECHA_MAINTENANCE_PLANT_20211101 >									
121 	//        < j1rFittWb5gD4iy0020f8IO76299F5K3WobyY8GjTen2WtOFCAl8oK4XTd409LEE >									
122 	//        <  u =="0.000000000000000001" : ] 000000099439152.888193400000000000 ; 000000114034070.432413000000000000 ] >									
123 	//        < 0x000000000000000000000000000000000000000000000000000097BB6BAE008F >									
124 	//     < RUSS_PFIII_I_metadata_line_9_____EPA_ENERGY_A_INDUSTRIAL_20211101 >									
125 	//        < FfGix6A81yWyWP0A556Mybz2VVs0vzzgbmgCk8086865gVTIRXy9p0a4S255P1o6 >									
126 	//        <  u =="0.000000000000000001" : ] 000000114034070.432413000000000000 ; 000000127867948.048366000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000000AE008FC31C6B >									
128 	//     < RUSS_PFIII_I_metadata_line_10_____VYATENERGOMONTAZH_20211101 >									
129 	//        < vdYc1TCNfng1qMYM9YvUqQa7V3N8w3X4vQQ102m4DuSvCvKZ4GeC5v5Hc98leUu9 >									
130 	//        <  u =="0.000000000000000001" : ] 000000127867948.048366000000000000 ; 000000142342143.343331000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000000C31C6BD93266 >									
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
174 	//     < RUSS_PFIII_I_metadata_line_11_____TELPOENERGOREMONT_20211101 >									
175 	//        < Dz8Z456KRF97RaVI663HXumgR1395K8I3yKT6M6Gvv5RjnMugUwpOv2R0Mc2v9HD >									
176 	//        <  u =="0.000000000000000001" : ] 000000142342143.343331000000000000 ; 000000157343939.439754000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000000D93266F0167A >									
178 	//     < RUSS_PFIII_I_metadata_line_12_____TSK_NOVAYA_MOSKVA_20211101 >									
179 	//        < 67f1eCf2QvwYQ74J1511977jRGFeW7lM8Y7C695bPmtf8wq3VVX3yU5vEFJduqh7 >									
180 	//        <  u =="0.000000000000000001" : ] 000000157343939.439754000000000000 ; 000000172019127.963665000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000000F0167A1067AF9 >									
182 	//     < RUSS_PFIII_I_metadata_line_13_____ENERGO_KRAN_20211101 >									
183 	//        < B40ALPyY88fjX9dXvrZ0SYNdORZpiRbbZ4S37zK0NVw7VV55LyFCwTPS09520jEs >									
184 	//        <  u =="0.000000000000000001" : ] 000000172019127.963665000000000000 ; 000000185102229.691949000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001067AF911A718F >									
186 	//     < RUSS_PFIII_I_metadata_line_14_____TELPOENERGOREMONT_MOSKVA_20211101 >									
187 	//        < 7t12nrDhpOM7lk3CQG0nuDka7ZoS9n9lIYpCBmQpMi21A32s882SPm4SielZshiZ >									
188 	//        <  u =="0.000000000000000001" : ] 000000185102229.691949000000000000 ; 000000198884090.306478000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000011A718F12F7919 >									
190 	//     < RUSS_PFIII_I_metadata_line_15_____TELPOENERGOREMONT_NOVOMICHURINSK_20211101 >									
191 	//        < 1ivLk1aV83yXI3Kk1u97d5rspWRD5R0X2PyVstrs52Fs2LM0uaI3iyUv0lc295ck >									
192 	//        <  u =="0.000000000000000001" : ] 000000198884090.306478000000000000 ; 000000213772045.894262000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000012F791914630B5 >									
194 	//     < RUSS_PFIII_I_metadata_line_16_____TREST_GIDROMONTAZH_20211101 >									
195 	//        < D5H84CyE9rOkQi081zyGaE38J6Jh6qJ6MvFPGN1nbFefme74mEkjy5AzDTi0093H >									
196 	//        <  u =="0.000000000000000001" : ] 000000213772045.894262000000000000 ; 000000229265172.236468000000000000 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000000014630B515DD4B5 >									
198 	//     < RUSS_PFIII_I_metadata_line_17_____MTS_20211101 >									
199 	//        < Hfi1lLwM4T3Ag2ZJap5OxKVhM34BvdRVi6RE3SrE0vnfsAW861h3WM9eca2Zg6zK >									
200 	//        <  u =="0.000000000000000001" : ] 000000229265172.236468000000000000 ; 000000242524018.970839000000000000 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000000015DD4B51720FF2 >									
202 	//     < RUSS_PFIII_I_metadata_line_18_____MTS_USD_20211101 >									
203 	//        < 2673eSl5NYmZGyb3C82p701w8AT4naoyv4Yw53gaSlUbiH6W0fe1Mb4U5xv61L88 >									
204 	//        <  u =="0.000000000000000001" : ] 000000242524018.970839000000000000 ; 000000256148905.576571000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000001720FF2186DA2B >									
206 	//     < RUSS_PFIII_I_metadata_line_19_____UZDUNROBITA_20211101 >									
207 	//        < lZaN50CbuaiWxaGEB7p49J8gGVU76Xx393Djl43j73p9Cbc3J034Ak3ImZV9r3wC >									
208 	//        <  u =="0.000000000000000001" : ] 000000256148905.576571000000000000 ; 000000271379887.971756000000000000 ] >									
209 	//        < 0x00000000000000000000000000000000000000000000000000186DA2B19E17C5 >									
210 	//     < RUSS_PFIII_I_metadata_line_20_____UZDUNROBITA_SUM_20211101 >									
211 	//        < 3r29rv8IBZ4os725n6OMQlWmOEe4T1o1Buy54kkp0R8YRds7l5j9Gis6a69U7DQw >									
212 	//        <  u =="0.000000000000000001" : ] 000000271379887.971756000000000000 ; 000000285801598.097838000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000019E17C51B41940 >									
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
256 	//     < RUSS_PFIII_I_metadata_line_21_____BELARUSKALI_20211101 >									
257 	//        < e7vuxvho5CdT8EbDjpqv2JrRHlxarzcaN4O03z1iTYlQwWbY53um7Yw229HTG0os >									
258 	//        <  u =="0.000000000000000001" : ] 000000285801598.097838000000000000 ; 000000299071281.984436000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000001B419401C858B8 >									
260 	//     < RUSS_PFIII_I_metadata_line_22_____URALKALI_20211101 >									
261 	//        < Z748x3vnrL2UOEkvPXo5QFGVIeSZQ8w3398U2eQ0qG8VrH8vi5654LSJ5R7Z3n0L >									
262 	//        <  u =="0.000000000000000001" : ] 000000299071281.984436000000000000 ; 000000312759001.567986000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000001C858B81DD3B7C >									
264 	//     < RUSS_PFIII_I_metadata_line_23_____POTASH_CORP_20211101 >									
265 	//        < kPZFH5LrSDtyl71F8rsHjBG819tK07T0gNYRVsk0RfX8V93z79akGrG8P6QO89E2 >									
266 	//        <  u =="0.000000000000000001" : ] 000000312759001.567986000000000000 ; 000000327837643.203770000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000001DD3B7C1F43D94 >									
268 	//     < RUSS_PFIII_I_metadata_line_24_____K+S_20211101 >									
269 	//        < Pi673V8C9SL6l9qZ84loe6H2NKI8G7QplUHpWZ0BEfqv6V9K8Jl0x6NjxttwacBW >									
270 	//        <  u =="0.000000000000000001" : ] 000000327837643.203770000000000000 ; 000000340903114.393701000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000001F43D942082D47 >									
272 	//     < RUSS_PFIII_I_metadata_line_25_____FIRMA MORTDATEL OOO_20211101 >									
273 	//        < l7Y3Bo1gMqc28DUgWyGZ3C61m5FIyAgsTxd854oUJ0aGt4033W319OwH8swAJ4jh >									
274 	//        <  u =="0.000000000000000001" : ] 000000340903114.393701000000000000 ; 000000353863610.595328000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002082D4721BF3F9 >									
276 	//     < RUSS_PFIII_I_metadata_line_26_____CHELYABINSK_METTALURGICAL_PLANT_20211101 >									
277 	//        < T5xW5Pv2uzesRi0y5KX8R15851ZVFMhX2jmz5zl1Elu5SIkerzaJ243iWN1ZCcuN >									
278 	//        <  u =="0.000000000000000001" : ] 000000353863610.595328000000000000 ; 000000366881555.852169000000000000 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000000000021BF3F922FD11C >									
280 	//     < RUSS_PFIII_I_metadata_line_27_____RASPADSKAYA_20211101 >									
281 	//        < 3F1KPHwb6vF3OQuTS2EVfubV88UGPELadSS8p8hIJQ4Ii70TU6RMknFI4wPJT2Fr >									
282 	//        <  u =="0.000000000000000001" : ] 000000366881555.852169000000000000 ; 000000382424038.773128000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000022FD11C2478864 >									
284 	//     < RUSS_PFIII_I_metadata_line_28_____ROSNEFT_20211101 >									
285 	//        < 3Ud5w9a65l04C9PJ5qKT9OLt2eTQ8rp7A8tJ88Ti5k5Gy4c1uygg5Rsnjhgy4R37 >									
286 	//        <  u =="0.000000000000000001" : ] 000000382424038.773128000000000000 ; 000000397876664.880403000000000000 ] >									
287 	//        < 0x00000000000000000000000000000000000000000000000000247886425F1C92 >									
288 	//     < RUSS_PFIII_I_metadata_line_29_____ROSTELECOM_20211101 >									
289 	//        < K3G13Q3t6ej5azrY92vk38gz5p4PbA6Lpp64V8GtwbF76U2dd3F07JtVCTlkmSi6 >									
290 	//        <  u =="0.000000000000000001" : ] 000000397876664.880403000000000000 ; 000000413371631.795037000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000025F1C92276C14B >									
292 	//     < RUSS_PFIII_I_metadata_line_30_____ROSTELECOM_USD_20211101 >									
293 	//        < JNMhGTq2SzHtPZqXz9u42IJcgGJhVQz3z4i81mTLXJoJ64AcPDZySwYeDD45w5MF >									
294 	//        <  u =="0.000000000000000001" : ] 000000413371631.795037000000000000 ; 000000427019108.025160000000000000 ] >									
295 	//        < 0x00000000000000000000000000000000000000000000000000276C14B28B9457 >									
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
338 	//     < RUSS_PFIII_I_metadata_line_31_____SBERBANK_20211101 >									
339 	//        < XVH5APY93VkDhGg7Xg3zogRCp92v4lk893AlrP5PD6ohJi75o8YA2KXH4s746MG3 >									
340 	//        <  u =="0.000000000000000001" : ] 000000427019108.025160000000000000 ; 000000441586973.172105000000000000 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000000000028B94572A1CEE9 >									
342 	//     < RUSS_PFIII_I_metadata_line_32_____SBERBANK_USD_20211101 >									
343 	//        < CTNtl2200Ral6HvD4i82p0eI18F9pqypRGpPKT4S2qHSs2d43PzjVRF8s6G66ulW >									
344 	//        <  u =="0.000000000000000001" : ] 000000441586973.172105000000000000 ; 000000456228382.927509000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000002A1CEE92B82636 >									
346 	//     < RUSS_PFIII_I_metadata_line_33_____TATNEFT_20211101 >									
347 	//        < Lo6ui4zevS78H1022o50993vDzpuf78439zodEwF5vidnS8gzTZy90r2wVw82z4g >									
348 	//        <  u =="0.000000000000000001" : ] 000000456228382.927509000000000000 ; 000000471495516.634085000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000002B826362CF71F0 >									
350 	//     < RUSS_PFIII_I_metadata_line_34_____TATNEFT_USD_20211101 >									
351 	//        < Rf8ziT96Z95I62tODXKOUXQI4P860Wx44dUr9iRMtKX7Lm661Bl3P9R5e27RVPcH >									
352 	//        <  u =="0.000000000000000001" : ] 000000471495516.634085000000000000 ; 000000486980316.027341000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000002CF71F02E712B0 >									
354 	//     < RUSS_PFIII_I_metadata_line_35_____TRANSNEFT_20211101 >									
355 	//        < os4ZlhE580kJeu25jmV8191iOWvzMo0zpSRm91k1RDy3T8LZ9R7oHugJs0x8F5c6 >									
356 	//        <  u =="0.000000000000000001" : ] 000000486980316.027341000000000000 ; 000000502424300.219763000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000002E712B02FEA37E >									
358 	//     < RUSS_PFIII_I_metadata_line_36_____TRANSNEFT_USD_20211101 >									
359 	//        < c24B0IiluKA47A01LT42l5VSyC5eW0PT433QBvVdI2Vp1vksN5ZqchC6GIX94eLV >									
360 	//        <  u =="0.000000000000000001" : ] 000000502424300.219763000000000000 ; 000000517300333.574592000000000000 ] >									
361 	//        < 0x000000000000000000000000000000000000000000000000002FEA37E3155671 >									
362 	//     < RUSS_PFIII_I_metadata_line_37_____ROSOBORONEKSPORT_20211101 >									
363 	//        < EGjp104XOFvSRD8yAXFpv1Np5b2pw8ZY65iEGA5BKcFZDC4eEBT3554QpaJuL4FR >									
364 	//        <  u =="0.000000000000000001" : ] 000000517300333.574592000000000000 ; 000000531336094.477699000000000000 ] >									
365 	//        < 0x00000000000000000000000000000000000000000000000000315567132AC129 >									
366 	//     < RUSS_PFIII_I_metadata_line_38_____BASHNEFT_20211101 >									
367 	//        < 55Yhi25j2B7B04Vr6zg4WpwxJtVBLT219WFQUq7M6rYS7l0Nx8662PvG2NnN3Aqz >									
368 	//        <  u =="0.000000000000000001" : ] 000000531336094.477699000000000000 ; 000000546449237.535151000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000032AC129341D0BC >									
370 	//     < RUSS_PFIII_I_metadata_line_39_____BASHNEFT_AB_20211101 >									
371 	//        < tHA96256R36DhC5QEg3WKG2r7U72SAG59lfIZUjkr2GD2QGrnhFv6ru4EVz6MORK >									
372 	//        <  u =="0.000000000000000001" : ] 000000546449237.535151000000000000 ; 000000560682895.071678000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000341D0BC35788C2 >									
374 	//     < RUSS_PFIII_I_metadata_line_40_____RAIFFEISENBANK_20211101 >									
375 	//        < 6EBC5qN0TRoDgh3vZX2gaQm22293RlVO79cf146mZOjI7ok78AAl4P486xfXSG2k >									
376 	//        <  u =="0.000000000000000001" : ] 000000560682895.071678000000000000 ; 000000575487268.745056000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000035788C236E1FB7 >									
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