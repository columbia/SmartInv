1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFIII_II_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFIII_II_883		"	;
8 		string	public		symbol =	"	RUSS_PFIII_II_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		777437562636057000000000000					;	
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
92 	//     < RUSS_PFIII_II_metadata_line_1_____MOSENERGO_20231101 >									
93 	//        < sIrsdFlA94U8NMcrf9NeQLL2bClOLZrTbrovo79P1Oq6wfPISQ22MW9j1r598515 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000020997678.381727800000000000 ] >									
95 	//        < 0x0000000000000000000000000000000000000000000000000000000000200A38 >									
96 	//     < RUSS_PFIII_II_metadata_line_2_____CENTRAL_REPAIRS_A_MECHANICAL_PLANT_20231101 >									
97 	//        < CBz63Q3xJ1Je7TuQ4K8PvcB2XUlvmkWVwHU294gW01A8LL2CYlob9aj03rXPBsV2 >									
98 	//        <  u =="0.000000000000000001" : ] 000000020997678.381727800000000000 ; 000000043010361.790369900000000000 ] >									
99 	//        < 0x0000000000000000000000000000000000000000000000000000200A3841A0EC >									
100 	//     < RUSS_PFIII_II_metadata_line_3_____CENT_REMONTNO_MEKHANICHESK_ZAVOD_20231101 >									
101 	//        < XhTG5ES4fNIm5FUy6Zev3C4g4P5dU3bkYylFFcM4LFGP8v4uiLOQCtT3Xd47XSM1 >									
102 	//        <  u =="0.000000000000000001" : ] 000000043010361.790369900000000000 ; 000000059463531.009295900000000000 ] >									
103 	//        < 0x000000000000000000000000000000000000000000000000000041A0EC5ABBF1 >									
104 	//     < RUSS_PFIII_II_metadata_line_4_____ENERGOINVEST_ME_20231101 >									
105 	//        < Cvw76FT7F923MJbfhVnURk01An1ZLMGZ2mEmzxU64IHCO42Gh04M77psRA8LKrF7 >									
106 	//        <  u =="0.000000000000000001" : ] 000000059463531.009295900000000000 ; 000000081963993.750694000000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000005ABBF17D112F >									
108 	//     < RUSS_PFIII_II_metadata_line_5_____ENERGOKONSALT_20231101 >									
109 	//        < 161ep7rLZ4lm5Wk0gXeN3GmMS392SV9476DsevJNm8nPh9mgn12luP5gW4LZQmd7 >									
110 	//        <  u =="0.000000000000000001" : ] 000000081963993.750694000000000000 ; 000000099341577.436388700000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000007D112F97954E >									
112 	//     < RUSS_PFIII_II_metadata_line_6_____REMONT_INGENERNYH_KOMMUNIKACIY_20231101 >									
113 	//        < G03mh94FDGX8UBj89Ye342nmzm8e661qBQt9Dr6qX6b2AJ66oa3WgYR0IdlbM2gu >									
114 	//        <  u =="0.000000000000000001" : ] 000000099341577.436388700000000000 ; 000000116155116.527851000000000000 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000000000097954EB13D18 >									
116 	//     < RUSS_PFIII_II_metadata_line_7_____KVALITEK_NCO_20231101 >									
117 	//        < tExOUFxkQO6Wgjrcj86DUbAUtJJ30gg9KY43sa8EE571dtfrl9d8XwsS6V9RFOp0 >									
118 	//        <  u =="0.000000000000000001" : ] 000000116155116.527851000000000000 ; 000000137736689.934133000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000B13D18D22B65 >									
120 	//     < RUSS_PFIII_II_metadata_line_8_____CENT_MECHA_MAINTENANCE_PLANT_20231101 >									
121 	//        < vHBDu3XrjPU58v8C4e6vBRM56wERC6W9OaNm8ANB7jcOR1nlYa8gkBqn3Fs99D65 >									
122 	//        <  u =="0.000000000000000001" : ] 000000137736689.934133000000000000 ; 000000160065194.306857000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000D22B65F43D77 >									
124 	//     < RUSS_PFIII_II_metadata_line_9_____EPA_ENERGY_A_INDUSTRIAL_20231101 >									
125 	//        < PhUSjlr9vV2K89BX15WRR5624EM7tw1O129tJF71A57ybjGwF4m8F5iN2J6VDxm3 >									
126 	//        <  u =="0.000000000000000001" : ] 000000160065194.306857000000000000 ; 000000182899523.340673000000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000000F43D771171520 >									
128 	//     < RUSS_PFIII_II_metadata_line_10_____VYATENERGOMONTAZH_20231101 >									
129 	//        < 9x7OgQ8AY4489f078evTRtcPgSkZgz0Qk8H8e7QO16ibUG9tBxwn69UDCC9x3JTO >									
130 	//        <  u =="0.000000000000000001" : ] 000000182899523.340673000000000000 ; 000000203802712.813244000000000000 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000000001171520136FA6F >									
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
174 	//     < RUSS_PFIII_II_metadata_line_11_____TELPOENERGOREMONT_20231101 >									
175 	//        < 86vJWO6by173tXrJ53s0rr36f35R8Ya05cuEE1v9s7id0lasEB8NQD7P470Q6q51 >									
176 	//        <  u =="0.000000000000000001" : ] 000000203802712.813244000000000000 ; 000000224938762.946948000000000000 ] >									
177 	//        < 0x00000000000000000000000000000000000000000000000000136FA6F1573AB4 >									
178 	//     < RUSS_PFIII_II_metadata_line_12_____TSK_NOVAYA_MOSKVA_20231101 >									
179 	//        < L6XpnSOozRHW0NaXh8xZWfwnPHnbqkHYRKGK6KEgWVqG5v7HFpIDlOy70pqRnUqf >									
180 	//        <  u =="0.000000000000000001" : ] 000000224938762.946948000000000000 ; 000000243000188.213567000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000001573AB4172C9F3 >									
182 	//     < RUSS_PFIII_II_metadata_line_13_____ENERGO_KRAN_20231101 >									
183 	//        < 04EO40uF2Gk1ey910G98mU38sEU5FO34YZtCVD8rRQl3QsLC7e0639lQUCe0tstA >									
184 	//        <  u =="0.000000000000000001" : ] 000000243000188.213567000000000000 ; 000000264833807.675938000000000000 ] >									
185 	//        < 0x00000000000000000000000000000000000000000000000000172C9F31941AB5 >									
186 	//     < RUSS_PFIII_II_metadata_line_14_____TELPOENERGOREMONT_MOSKVA_20231101 >									
187 	//        < DNGqDef8T2rcrkN7JE0NdWWK7EJE7ztX8tXb22F6uc0RtlU6lP9N0JP70KnZ8L1y >									
188 	//        <  u =="0.000000000000000001" : ] 000000264833807.675938000000000000 ; 000000286597612.446700000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000001941AB51B55031 >									
190 	//     < RUSS_PFIII_II_metadata_line_15_____TELPOENERGOREMONT_NOVOMICHURINSK_20231101 >									
191 	//        < w2n1r4Ghrifl578d40InU1kQ2shPYZa9E8V9mxwM4YK19lVapsd6198vr41YXA9A >									
192 	//        <  u =="0.000000000000000001" : ] 000000286597612.446700000000000000 ; 000000304250285.462819000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000001B550311D03FC5 >									
194 	//     < RUSS_PFIII_II_metadata_line_16_____TREST_GIDROMONTAZH_20231101 >									
195 	//        < a5RNHz3ck3lBQ7N7RgrcQmHSvu9i1yC6s0XCfYAdi419F12jzertW44FMdj8e6ck >									
196 	//        <  u =="0.000000000000000001" : ] 000000304250285.462819000000000000 ; 000000326966035.535714000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000001D03FC51F2E91C >									
198 	//     < RUSS_PFIII_II_metadata_line_17_____MTS_20231101 >									
199 	//        < M2n8i8tdmLVTeZz8T5DjIRjT77zQko77YwVslegXOQJ9ClNsMO6wf169S0HMeRu7 >									
200 	//        <  u =="0.000000000000000001" : ] 000000326966035.535714000000000000 ; 000000343530479.000828000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000001F2E91C20C2F98 >									
202 	//     < RUSS_PFIII_II_metadata_line_18_____MTS_USD_20231101 >									
203 	//        < 958ElZ0lJxcfxV7yArTfBr61G273qNzfMu2LOI8aEyWL2NG1ORjOZBhxdwIuRG9u >									
204 	//        <  u =="0.000000000000000001" : ] 000000343530479.000828000000000000 ; 000000363686495.687367000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000020C2F9822AF10A >									
206 	//     < RUSS_PFIII_II_metadata_line_19_____UZDUNROBITA_20231101 >									
207 	//        < I44vRduvYU2i07053HC5PM5HLMh3bB3Y393jOBnD4oEmFVxaQoy5HXO4O70l1p93 >									
208 	//        <  u =="0.000000000000000001" : ] 000000363686495.687367000000000000 ; 000000384396395.547527000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000000022AF10A24A8AD8 >									
210 	//     < RUSS_PFIII_II_metadata_line_20_____UZDUNROBITA_SUM_20231101 >									
211 	//        < 4r94TE6DeX7j31dGgLD7AdmCsn1SXxK1LfZ2k072627m3r5y48HQBF1h0dTJl8tX >									
212 	//        <  u =="0.000000000000000001" : ] 000000384396395.547527000000000000 ; 000000407193132.019539000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000024A8AD826D53D1 >									
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
256 	//     < RUSS_PFIII_II_metadata_line_21_____BELARUSKALI_20231101 >									
257 	//        < 858G1MYxtlf3C5qu9LV8KXRw19bjP4BJeCV3odDywEgxqH42FD9yWjJCv4WIem05 >									
258 	//        <  u =="0.000000000000000001" : ] 000000407193132.019539000000000000 ; 000000426427912.421665000000000000 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000000026D53D128AAD67 >									
260 	//     < RUSS_PFIII_II_metadata_line_22_____URALKALI_20231101 >									
261 	//        < E75JJJRY3TUBTKCIMtse2e5t1bH5FnfbRejZOBBnVO8LPV0GIP3IWD2WnmsrUM32 >									
262 	//        <  u =="0.000000000000000001" : ] 000000426427912.421665000000000000 ; 000000447971373.183577000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000028AAD672AB8CD1 >									
264 	//     < RUSS_PFIII_II_metadata_line_23_____POTASH_CORP_20231101 >									
265 	//        < 8mQqEAm19a66o6HDX4ekRf6fsaEWJ5yI3gf26HHO85T7w3B694Pw24g6R77k7Csg >									
266 	//        <  u =="0.000000000000000001" : ] 000000447971373.183577000000000000 ; 000000467900282.159381000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000002AB8CD12C9F58C >									
268 	//     < RUSS_PFIII_II_metadata_line_24_____K+S_20231101 >									
269 	//        < 80F8axPpyFC5SHPOt7D8lE9v64v29kCN0W9ShHg5wxZ4y4M7cvcHZpH38eger023 >									
270 	//        <  u =="0.000000000000000001" : ] 000000467900282.159381000000000000 ; 000000486181262.312944000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000002C9F58C2E5DA8E >									
272 	//     < RUSS_PFIII_II_metadata_line_25_____FIRMA MORTDATEL OOO_20231101 >									
273 	//        < 9X50Ncf9v827GZqi71tF4ub2K7SmP3V53apPt21QpGH3iCtfpqp2Ap9Lg69xDJUJ >									
274 	//        <  u =="0.000000000000000001" : ] 000000486181262.312944000000000000 ; 000000501603922.636863000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002E5DA8E2FD6308 >									
276 	//     < RUSS_PFIII_II_metadata_line_26_____CHELYABINSK_METTALURGICAL_PLANT_20231101 >									
277 	//        < j14Y1WTd02bt6TLXH79qmyxZT0Gv4UjVNzEZOoBX5WQF522KkS60Mg6Y1CU8iWSa >									
278 	//        <  u =="0.000000000000000001" : ] 000000501603922.636863000000000000 ; 000000523884793.296576000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000002FD630831F627F >									
280 	//     < RUSS_PFIII_II_metadata_line_27_____RASPADSKAYA_20231101 >									
281 	//        < 3BbT3J4lFB7a5JCSozzV0yD5wGsX0070k9AyWbb12UudNjbI98898BQ5JxaSj0pV >									
282 	//        <  u =="0.000000000000000001" : ] 000000523884793.296576000000000000 ; 000000539997011.544812000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000031F627F337F855 >									
284 	//     < RUSS_PFIII_II_metadata_line_28_____ROSNEFT_20231101 >									
285 	//        < 3Y0vuB6WH6N5G7u7HvwWB4j4BAX9JxehqlVdii96C9uAttyRd1fpao3a1j4W41CA >									
286 	//        <  u =="0.000000000000000001" : ] 000000539997011.544812000000000000 ; 000000555682268.911307000000000000 ] >									
287 	//        < 0x00000000000000000000000000000000000000000000000000337F85534FE763 >									
288 	//     < RUSS_PFIII_II_metadata_line_29_____ROSTELECOM_20231101 >									
289 	//        < GTVa5UPSvZC38EQmXz3R0W2EIN2x9p5Lta8MqX666IJIMJXlI4kQYcbX4906PZN1 >									
290 	//        <  u =="0.000000000000000001" : ] 000000555682268.911307000000000000 ; 000000573935869.997647000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000034FE76336BC1B3 >									
292 	//     < RUSS_PFIII_II_metadata_line_30_____ROSTELECOM_USD_20231101 >									
293 	//        < gv5W760zTLRV2x227UmJ7Eor4o2RKhJW5BDDZ24j761Vc1ze8tR14EH8WouUv1y4 >									
294 	//        <  u =="0.000000000000000001" : ] 000000573935869.997647000000000000 ; 000000595135527.838163000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000036BC1B338C1AD1 >									
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
338 	//     < RUSS_PFIII_II_metadata_line_31_____SBERBANK_20231101 >									
339 	//        < q5Ch1SPJ9mxT9M4gDZbvgc45720w04no42GutVNF5TzHdm8DCJ4V1w5Dv95A3RIK >									
340 	//        <  u =="0.000000000000000001" : ] 000000595135527.838163000000000000 ; 000000613485996.936121000000000000 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000000000038C1AD13A81AF8 >									
342 	//     < RUSS_PFIII_II_metadata_line_32_____SBERBANK_USD_20231101 >									
343 	//        < YqB8JnMARMdv0v0AnAWj3uhtK9rtj1h98uY0a68LRDW193TDc0K1luJC9a5L87P9 >									
344 	//        <  u =="0.000000000000000001" : ] 000000613485996.936121000000000000 ; 000000633733265.364207000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000003A81AF83C7000F >									
346 	//     < RUSS_PFIII_II_metadata_line_33_____TATNEFT_20231101 >									
347 	//        < mbg3kG9tyva9IeuON9K3ntN5o51QfSy925ys6DR30U70ZL0TL130cy1kL14C9Zl1 >									
348 	//        <  u =="0.000000000000000001" : ] 000000633733265.364207000000000000 ; 000000651071049.729116000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000003C7000F3E174A1 >									
350 	//     < RUSS_PFIII_II_metadata_line_34_____TATNEFT_USD_20231101 >									
351 	//        < uk372S26L965xh8l6j5ABKCOfs351IMYg2I5bSakv5N72idBDFh1755056HriDdu >									
352 	//        <  u =="0.000000000000000001" : ] 000000651071049.729116000000000000 ; 000000669327665.235797000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000003E174A13FD501F >									
354 	//     < RUSS_PFIII_II_metadata_line_35_____TRANSNEFT_20231101 >									
355 	//        < 0oqQ93L5tmF86nArX6Xg97hFwFG3d4Jdy42SGLFk08Wwh1WcZzsEGQH48btFnJy0 >									
356 	//        <  u =="0.000000000000000001" : ] 000000669327665.235797000000000000 ; 000000690078657.083847000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000003FD501F41CF9FA >									
358 	//     < RUSS_PFIII_II_metadata_line_36_____TRANSNEFT_USD_20231101 >									
359 	//        < 3FlWjm30Do92f3NIqYp776fG2G5c7UQ746q0AxUCsJkFGfm8jcT3tHR4Qu0Ezb1O >									
360 	//        <  u =="0.000000000000000001" : ] 000000690078657.083847000000000000 ; 000000705562773.958313000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000041CF9FA4349A75 >									
362 	//     < RUSS_PFIII_II_metadata_line_37_____ROSOBORONEKSPORT_20231101 >									
363 	//        < p4VcYMMlQgeEA6LapMaExS8Thwbm0PCMsmcHf8qAbVP9KzeD6b46TpWCoLzz8K3h >									
364 	//        <  u =="0.000000000000000001" : ] 000000705562773.958313000000000000 ; 000000723740030.071972000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000004349A7545056F3 >									
366 	//     < RUSS_PFIII_II_metadata_line_38_____BASHNEFT_20231101 >									
367 	//        < 02l7fyhr4FjE5LaDA79PoHD4IYNj507IuhDa4lN120P7u18751lGK9W3fRt148Ef >									
368 	//        <  u =="0.000000000000000001" : ] 000000723740030.071972000000000000 ; 000000739226796.663415000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000045056F3467F878 >									
370 	//     < RUSS_PFIII_II_metadata_line_39_____BASHNEFT_AB_20231101 >									
371 	//        < zA0Rt7zsGWuSAe2sVUGfwxbLrdAsEaZJZT1OV9affW1XozVcow1h96yzCZRH4c0n >									
372 	//        <  u =="0.000000000000000001" : ] 000000739226796.663415000000000000 ; 000000761051885.933834000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000467F87848945E5 >									
374 	//     < RUSS_PFIII_II_metadata_line_40_____RAIFFEISENBANK_20231101 >									
375 	//        < k96M44jNM9FSG4BsWFU0Iomn3Z730rCfmZ0e9Kc763TQ3p6yJ0H9z3QmWNaO6FDX >									
376 	//        <  u =="0.000000000000000001" : ] 000000761051885.933834000000000000 ; 000000777437562.636057000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000048945E54A2468C >									
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