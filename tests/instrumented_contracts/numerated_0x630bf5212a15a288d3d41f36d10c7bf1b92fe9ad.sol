1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFVIII_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFVIII_III_883		"	;
8 		string	public		symbol =	"	RUSS_PFVIII_III_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		982211515395773000000000000					;	
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
92 	//     < RUSS_PFVIII_III_metadata_line_1_____NOVOLIPETSK_ORG_20251101 >									
93 	//        < R2vDoIfl4k1KxXKcvJO8MuCx1150U32bULgx9Uvp1sOYDkXrkt5ER4jhn3500K9e >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000032426323.381630700000000000 ] >									
95 	//        < 0x0000000000000000000000000000000000000000000000000000000000317A88 >									
96 	//     < RUSS_PFVIII_III_metadata_line_2_____LLC_NTK_20251101 >									
97 	//        < jnpSkPJa4Bpl30IHQ97UjJT49QR7ufVLYx9wi9WpfYdx1YRYaHt5lwdsaav7CnJp >									
98 	//        <  u =="0.000000000000000001" : ] 000000032426323.381630700000000000 ; 000000050749061.757622800000000000 ] >									
99 	//        < 0x0000000000000000000000000000000000000000000000000000317A884D6FDA >									
100 	//     < RUSS_PFVIII_III_metadata_line_3_____NATIONAL_LAMINATIONS_GROUP_20251101 >									
101 	//        < bm87o0a4PbcNeOIC1OuV0sLX07fZq7vm2Ws83JLaG2fnXPLl5jze6I8rXFKFtI0M >									
102 	//        <  u =="0.000000000000000001" : ] 000000050749061.757622800000000000 ; 000000085621450.697979700000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000004D6FDA82A5E1 >									
104 	//     < RUSS_PFVIII_III_metadata_line_4_____DOLOMITE_OJSC_20251101 >									
105 	//        < 9k96OOybY6TD1b2A21j7jBQ927YC8oMkN9EgDwLurOD705al7W5VH5gkiV0y98yz >									
106 	//        <  u =="0.000000000000000001" : ] 000000085621450.697979700000000000 ; 000000108498778.076990000000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000082A5E1A58E56 >									
108 	//     < RUSS_PFVIII_III_metadata_line_5_____LLC_TRADE_HOUSE_NLMK_20251101 >									
109 	//        < 4l71vSvGczEh1FYbY467jB64YA7TWN2ELMN47dxd0I54fF4mxWfGBq3P90QnsRth >									
110 	//        <  u =="0.000000000000000001" : ] 000000108498778.076990000000000000 ; 000000143231395.522753000000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000A58E56DA8DC4 >									
112 	//     < RUSS_PFVIII_III_metadata_line_6_____STUDENOVSK_MINING_CO_20251101 >									
113 	//        < L409KlIvUR44wLJp8ClS37hZ4xFnOW2j4k9I8201Nzd2Ykq2YxQiOU8u932g2sO8 >									
114 	//        <  u =="0.000000000000000001" : ] 000000143231395.522753000000000000 ; 000000164143588.920802000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000DA8DC4FA7697 >									
116 	//     < RUSS_PFVIII_III_metadata_line_7_____VMI_RECYCLING_GROUP_20251101 >									
117 	//        < n7I4s3Z2x6aP7gidL9QNTBn93a5tt7788BOz6HV3AyLUlbB8BSI08K25ZAA2m69s >									
118 	//        <  u =="0.000000000000000001" : ] 000000164143588.920802000000000000 ; 000000184193896.499582000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000000FA76971190EBE >									
120 	//     < RUSS_PFVIII_III_metadata_line_8_____VTORCHERMET_20251101 >									
121 	//        < aJTxilN1xtCd64qUQZsgxz26LUA7t46Z65qZ1REh414vK3sq5t0MBeJJ1e33WnK9 >									
122 	//        <  u =="0.000000000000000001" : ] 000000184193896.499582000000000000 ; 000000207382243.646884000000000000 ] >									
123 	//        < 0x000000000000000000000000000000000000000000000000001190EBE13C70B0 >									
124 	//     < RUSS_PFVIII_III_metadata_line_9_____KALUGA_RESEARCH_PROD_ELECTROMETALL_20251101 >									
125 	//        < W6TE74l9ko228h85wwp9da4wXC2Um3wma9N450ZcVJS97Ixz1u8BTrsjx4W5EW6v >									
126 	//        <  u =="0.000000000000000001" : ] 000000207382243.646884000000000000 ; 000000234060419.375910000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000013C70B016525DA >									
128 	//     < RUSS_PFVIII_III_metadata_line_10_____DANSTEEL_AS_20251101 >									
129 	//        < dd9pM8jtwD9uk9XHJuy4k2VSDtdB9yGM6VMr5dXcH6xV26BbIDe078OU6miPcH3M >									
130 	//        <  u =="0.000000000000000001" : ] 000000234060419.375910000000000000 ; 000000262197075.709064000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000016525DA19014BC >									
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
174 	//     < RUSS_PFVIII_III_metadata_line_11_____NOVATEK_ORG_20251101 >									
175 	//        < qfJ9YOe0l923Of0H5z8T8bVbMs4P8yot758i0OJ4m068TSG3QVM30Nkp5NF7Ue4R >									
176 	//        <  u =="0.000000000000000001" : ] 000000262197075.709064000000000000 ; 000000282182986.800663000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000019014BC1AE93BB >									
178 	//     < RUSS_PFVIII_III_metadata_line_12_____NOVATEK_AB_20251101 >									
179 	//        < wFwD8Lu8Ue07J143ty2w6s8S9FR07g8bdCijW61nxwjzp3Qx97HdGc48U822LKK1 >									
180 	//        <  u =="0.000000000000000001" : ] 000000282182986.800663000000000000 ; 000000300964728.926160000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000001AE93BB1CB3C59 >									
182 	//     < RUSS_PFVIII_III_metadata_line_13_____NOVATEK_DAC_20251101 >									
183 	//        < 34HMUQfuvj4wY5Ay4443EMHCH1MQoNXX9FMPU6h6589hoEra0wWNsFtq425nv052 >									
184 	//        <  u =="0.000000000000000001" : ] 000000300964728.926160000000000000 ; 000000332749679.344330000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001CB3C591FBBC58 >									
186 	//     < RUSS_PFVIII_III_metadata_line_14_____PUROVSKY_ZPK_20251101 >									
187 	//        < sxx1WM816MFI4Ufu7Kd27r0oazjBBUT27YJZKzNeLb73hAsIv1APL47bGIEe44b3 >									
188 	//        <  u =="0.000000000000000001" : ] 000000332749679.344330000000000000 ; 000000364856349.043866000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000001FBBC5822CBA03 >									
190 	//     < RUSS_PFVIII_III_metadata_line_15_____KOSTROMA_OOO_20251101 >									
191 	//        < SzxVQl2r3wvR9x1yJ564908jrjQDcbLO0JI8O03S5e2LKI7yXoC0WtU9zmC7ROKk >									
192 	//        <  u =="0.000000000000000001" : ] 000000364856349.043866000000000000 ; 000000391679127.219100000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000022CBA03255A7A9 >									
194 	//     < RUSS_PFVIII_III_metadata_line_16_____SHERWOOD_PREMIER_LLC_20251101 >									
195 	//        < 4F642VfDF1ZZa5GrR6v1NYOtrG4qaPBOvoL4LUyhWladfpqA0hNrxEK7ylS1Pvqh >									
196 	//        <  u =="0.000000000000000001" : ] 000000391679127.219100000000000000 ; 000000410380795.764110000000000000 ] >									
197 	//        < 0x00000000000000000000000000000000000000000000000000255A7A92723100 >									
198 	//     < RUSS_PFVIII_III_metadata_line_17_____GEOTRANSGAZ_JSC_20251101 >									
199 	//        < 2I4SyWGma03PMo4985n78625tVxDu8j0I945JpEK4tDeKtUoDZGyb1U6qPqhJ3wh >									
200 	//        <  u =="0.000000000000000001" : ] 000000410380795.764110000000000000 ; 000000429608850.161220000000000000 ] >									
201 	//        < 0x00000000000000000000000000000000000000000000000000272310028F87F5 >									
202 	//     < RUSS_PFVIII_III_metadata_line_18_____TAILIKSNEFTEGAS_20251101 >									
203 	//        < iW0HOPWR5AHaHOy6mPf99g8AMgvKdeuOFNHG3re5o4zeB8G4nWx02PYYTRDkH1MW >									
204 	//        <  u =="0.000000000000000001" : ] 000000429608850.161220000000000000 ; 000000461006083.652440000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000028F87F52BF7080 >									
206 	//     < RUSS_PFVIII_III_metadata_line_19_____URENGOYSKAYA_GAZOVAYA_KOMPANIYA_20251101 >									
207 	//        < u054PXH9jgI5023tVT272DTXoImOaPWkA1v27u0hgdmAXvZY9ZvYH5NEN1i514RI >									
208 	//        <  u =="0.000000000000000001" : ] 000000461006083.652440000000000000 ; 000000490211114.035879000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000002BF70802EC00B7 >									
210 	//     < RUSS_PFVIII_III_metadata_line_20_____PURNEFTEGAZGEOLOGIYA_20251101 >									
211 	//        < l4g86566GwB90z395RvLuulsEWBQBJfMC82zlqkDTCGH9yE6e5RqM83XF4F7axJD >									
212 	//        <  u =="0.000000000000000001" : ] 000000490211114.035879000000000000 ; 000000509988887.113091000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000002EC00B730A2E69 >									
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
256 	//     < RUSS_PFVIII_III_metadata_line_21_____OGK_2_20251101 >									
257 	//        < 0hd3SuTFN1ZPrAmu7T1Yzq8fL48rN3T7dhVew57v8o1DH2IV6tXM8HOP5P9MhkaX >									
258 	//        <  u =="0.000000000000000001" : ] 000000509988887.113091000000000000 ; 000000535204472.217199000000000000 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000000030A2E69330A83F >									
260 	//     < RUSS_PFVIII_III_metadata_line_22_____RYAZANSKAYA_GRES_OAO_20251101 >									
261 	//        < PP97gH18EFsHTcsnUmqPg21xJXlhsHs80Cjj896856ZSGWBlKRqqHY0JPAADKVQ5 >									
262 	//        <  u =="0.000000000000000001" : ] 000000535204472.217199000000000000 ; 000000553508762.400222000000000000 ] >									
263 	//        < 0x00000000000000000000000000000000000000000000000000330A83F34C965C >									
264 	//     < RUSS_PFVIII_III_metadata_line_23_____GAZPROM_INVESTPROJECT_20251101 >									
265 	//        < 0mv3liWT32bAucUf3NLfF28BGOV87rdN4WurHL8gwnm6kt7R4YmFN754XqwTX4kt >									
266 	//        <  u =="0.000000000000000001" : ] 000000553508762.400222000000000000 ; 000000572598637.639601000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000034C965C369B758 >									
268 	//     < RUSS_PFVIII_III_metadata_line_24_____TROITSKAYA_GRES_JSC_20251101 >									
269 	//        < DerlQ60agx0a33GUQdVN3f32tqIrPCD99vM1Wx9kNq8y870EPi4iOuaCMTCbIN8D >									
270 	//        <  u =="0.000000000000000001" : ] 000000572598637.639601000000000000 ; 000000594941856.464561000000000000 ] >									
271 	//        < 0x00000000000000000000000000000000000000000000000000369B75838BCF2A >									
272 	//     < RUSS_PFVIII_III_metadata_line_25_____SURGUTSKAYA_TPP_1_20251101 >									
273 	//        < 9Dr0PKf6dFyqNrdXd0H5tG8jq893mobe95gj11PHjv0CzCk1R983X0Ku5AklQNap >									
274 	//        <  u =="0.000000000000000001" : ] 000000594941856.464561000000000000 ; 000000615312030.248301000000000000 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000000000038BCF2A3AAE443 >									
276 	//     < RUSS_PFVIII_III_metadata_line_26_____NOVOCHERKASSKAYA_TPP_20251101 >									
277 	//        < olWPUh97fgTLgTA621NeU31R3bs6eu9HGo7Dj5b4Y9BYhAhpRGq94SKkFAOPr25l >									
278 	//        <  u =="0.000000000000000001" : ] 000000615312030.248301000000000000 ; 000000633669677.940874000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000003AAE4433C6E738 >									
280 	//     < RUSS_PFVIII_III_metadata_line_27_____KIRISHSKAYA_GRES_OGK_6_20251101 >									
281 	//        < C6Anzhn84wxzA4w1h7IFr5qn8newBS4AnaEZ1PJ8or7nN8Drvf2A2Wu8uHPz92Pp >									
282 	//        <  u =="0.000000000000000001" : ] 000000633669677.940874000000000000 ; 000000651986459.183897000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000003C6E7383E2DA36 >									
284 	//     < RUSS_PFVIII_III_metadata_line_28_____KRASNOYARSKAYA_GRES_2_20251101 >									
285 	//        < i43UjvvB78cIy61jeoLt49CeG37o85LJV5fQ7Hb4N62cgfo7t54qH1Du9RIB1U1l >									
286 	//        <  u =="0.000000000000000001" : ] 000000651986459.183897000000000000 ; 000000686922745.287254000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000003E2DA364182933 >									
288 	//     < RUSS_PFVIII_III_metadata_line_29_____CHEREPOVETSKAYA_GRES_20251101 >									
289 	//        < NGHg1Sb5kDZ4hAorexQO9urL28ZpNgb2TWnYeV3HbU4uw5534XGqvE5OcTxVV7t5 >									
290 	//        <  u =="0.000000000000000001" : ] 000000686922745.287254000000000000 ; 000000707204202.124540000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000041829334371BA4 >									
292 	//     < RUSS_PFVIII_III_metadata_line_30_____STAVROPOLSKAYA_GRES_20251101 >									
293 	//        < z10IJQZNt3ZS8pgvtSa4gf3bkO4oA2GnZ4jvhESD1X67Yl4S17XragiY8Lu5PDnn >									
294 	//        <  u =="0.000000000000000001" : ] 000000707204202.124540000000000000 ; 000000729595234.515230000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000004371BA44594623 >									
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
338 	//     < RUSS_PFVIII_III_metadata_line_31_____OGK_2_ORG_20251101 >									
339 	//        < YRw7HmrP3S6Kng139xCQj9xA7W97xx5qwYr27650gAt98f291pOqzK6G0e36YR2o >									
340 	//        <  u =="0.000000000000000001" : ] 000000729595234.515230000000000000 ; 000000749817469.754107000000000000 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000000000045946234782173 >									
342 	//     < RUSS_PFVIII_III_metadata_line_32_____OGK_2_PSKOV_GRES_20251101 >									
343 	//        < NqvwKtVi086Ab3Iv4JGNLvVjMV5Pewn6dhKARPCd1W10x4Q5fQ06671931vW1nTM >									
344 	//        <  u =="0.000000000000000001" : ] 000000749817469.754107000000000000 ; 000000772211516.802920000000000000 ] >									
345 	//        < 0x00000000000000000000000000000000000000000000000000478217349A4D20 >									
346 	//     < RUSS_PFVIII_III_metadata_line_33_____OGK_2_SEROV_GRES_20251101 >									
347 	//        < WiF82PKS5aby4K4wexKI1BW1X22AGuxn9w99g7Jrf25K6ZW1xHe0vA062UXY2TjG >									
348 	//        <  u =="0.000000000000000001" : ] 000000772211516.802920000000000000 ; 000000794953220.873538000000000000 ] >									
349 	//        < 0x0000000000000000000000000000000000000000000000000049A4D204BD009A >									
350 	//     < RUSS_PFVIII_III_metadata_line_34_____OGK_2_STAVROPOL_GRES_20251101 >									
351 	//        < 4937jGU3OpDrimsrvvBO9fNkfa4V2IOo1SFjfm17mBt1R1h856J8gY583Q190P81 >									
352 	//        <  u =="0.000000000000000001" : ] 000000794953220.873538000000000000 ; 000000830586580.348790000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000004BD009A4F35FE2 >									
354 	//     < RUSS_PFVIII_III_metadata_line_35_____OGK_2_SURGUT_GRES_20251101 >									
355 	//        < FX59XIy9YeF9O44DMj4Na77Fxk00vC4pPJ2sTns4e0F22slq44W6Z4xo7M9MYv9u >									
356 	//        <  u =="0.000000000000000001" : ] 000000830586580.348790000000000000 ; 000000849088051.039790000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000004F35FE250F9B05 >									
358 	//     < RUSS_PFVIII_III_metadata_line_36_____OGK_2_TROITSK_GRES_20251101 >									
359 	//        < EXYKGY3B4jGKVXp9gaB46t29LdebEk6yv66Xka7gcv4sK2535Au0uGxMJ5K6NxpY >									
360 	//        <  u =="0.000000000000000001" : ] 000000849088051.039790000000000000 ; 000000873794901.075186000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000050F9B055354E22 >									
362 	//     < RUSS_PFVIII_III_metadata_line_37_____OGK_2_NOVOCHERKASSK_GRES_20251101 >									
363 	//        < UeY6D9ZGRN0qIWU9fLWCw00KtKwZs2vaSq1zYJ9TbKomwPT4v5RRQfM8j0sam879 >									
364 	//        <  u =="0.000000000000000001" : ] 000000873794901.075186000000000000 ; 000000903169715.958927000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000005354E2256220AC >									
366 	//     < RUSS_PFVIII_III_metadata_line_38_____OGK_2_KIRISHI_GRES_20251101 >									
367 	//        < l9GF7M7eZryFt3imEknxR6NMl645vfP83J0S603fx78hO44vHkR6aAxjXwKo5yqP >									
368 	//        <  u =="0.000000000000000001" : ] 000000903169715.958927000000000000 ; 000000930382381.850632000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000056220AC58BA69E >									
370 	//     < RUSS_PFVIII_III_metadata_line_39_____OGK_2_RYAZAN_GRES_20251101 >									
371 	//        < 3uaQ6nSmQkoJPo9Emb4e98OZw4K0Ca2AQe0a821AegvZAmdjC2k0h4hP7k49i4KI >									
372 	//        <  u =="0.000000000000000001" : ] 000000930382381.850632000000000000 ; 000000954843429.015532000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000058BA69E5B0F9B7 >									
374 	//     < RUSS_PFVIII_III_metadata_line_40_____OGK_2_KRASNOYARSK_GRES_20251101 >									
375 	//        < h1GD2tL4g76XayVKWZ98LtRNlqRnTH0kiY5qsg3s3kSrc1Zt4uXy1R7tQ5L7sHtM >									
376 	//        <  u =="0.000000000000000001" : ] 000000954843429.015532000000000000 ; 000000982211515.395773000000000000 ] >									
377 	//        < 0x000000000000000000000000000000000000000000000000005B0F9B75DABC60 >									
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