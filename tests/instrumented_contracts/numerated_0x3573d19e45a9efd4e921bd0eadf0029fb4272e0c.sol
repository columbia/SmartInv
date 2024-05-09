1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXV_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXV_III_883		"	;
8 		string	public		symbol =	"	RUSS_PFXV_III_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		995290381143701000000000000					;	
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
92 	//     < RUSS_PFXV_III_metadata_line_1_____POLYMETAL_20251101 >									
93 	//        < fYdeMs7cbDya4WC714VWTQT847u52wNrkzt652U766l6IZ20bx4fSVG1Z5HN7C03 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000028022188.732928600000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000002AC22B >									
96 	//     < RUSS_PFXV_III_metadata_line_2_____POLYMETAL_GBP_20251101 >									
97 	//        < rLV396rNW38H78vL5Thzp0RAR0zp0BiTHw6T84Cj1cNl8lQIY99Fhs16VeMhB7WA >									
98 	//        <  u =="0.000000000000000001" : ] 000000028022188.732928600000000000 ; 000000053748040.294277700000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000002AC22B520354 >									
100 	//     < RUSS_PFXV_III_metadata_line_3_____POLYMETAL_USD_20251101 >									
101 	//        < ep9Yj5LfkSX76Xfx9R2bsneFFpegz3D4MZn649LYPg439ym2gi8g3bAWuP8ZneN1 >									
102 	//        <  u =="0.000000000000000001" : ] 000000053748040.294277700000000000 ; 000000078085842.067653100000000000 ] >									
103 	//        < 0x0000000000000000000000000000000000000000000000000000520354772648 >									
104 	//     < RUSS_PFXV_III_metadata_line_4_____POLYMETAL_ORG_20251101 >									
105 	//        < D9bR79x7UTbIift3TBoggc3ekuKvQ92mc9Tx5U8PTYp555q51IK09mJBb9OUR12o >									
106 	//        <  u =="0.000000000000000001" : ] 000000078085842.067653100000000000 ; 000000112779310.760608000000000000 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000000000772648AC166B >									
108 	//     < RUSS_PFXV_III_metadata_line_5_____POLYMETAL_DAO_20251101 >									
109 	//        < ansu9NoPIYD84yYyAo3OkNDmZ689mQ510vM0fx9B4ll88435EuRPON1GE6170g47 >									
110 	//        <  u =="0.000000000000000001" : ] 000000112779310.760608000000000000 ; 000000132416711.989164000000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000AC166BCA0D47 >									
112 	//     < RUSS_PFXV_III_metadata_line_6_____POLYMETAL_DAC_20251101 >									
113 	//        < 97HG31hTPNz3236rFVrtWu0cc3WRv6Emu0syzq18O7459Ae97BpaxwQ8jVdOUKgW >									
114 	//        <  u =="0.000000000000000001" : ] 000000132416711.989164000000000000 ; 000000166230127.385514000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000CA0D47FDA5A5 >									
116 	//     < RUSS_PFXV_III_metadata_line_7_____PPF_GROUP_RUB_20251101 >									
117 	//        < R1IiBYhjEz8uj5WPQhL5f03BMc998xGM6qK13n0DW1S5s4o5R7hfI41Bc28IL4Ak >									
118 	//        <  u =="0.000000000000000001" : ] 000000166230127.385514000000000000 ; 000000189964312.339896000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000000FDA5A5121DCCF >									
120 	//     < RUSS_PFXV_III_metadata_line_8_____PPF_GROUP_RUB_AB_20251101 >									
121 	//        < 24ARgU142TP21JIwHEHa1ewZTF6wLl39aQVnQx30bi3i5ea7l9HKJSN3gE64C46q >									
122 	//        <  u =="0.000000000000000001" : ] 000000189964312.339896000000000000 ; 000000214383174.163934000000000000 ] >									
123 	//        < 0x00000000000000000000000000000000000000000000000000121DCCF1471F6D >									
124 	//     < RUSS_PFXV_III_metadata_line_9_____ICT_GROUP_20251101 >									
125 	//        < eI6fawo276Us9M15KiARw3E3N3ZCTI0oyay4x1amBO83V8U81Q8Tfxt7ugJD410F >									
126 	//        <  u =="0.000000000000000001" : ] 000000214383174.163934000000000000 ; 000000245967266.909260000000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000001471F6D17750F7 >									
128 	//     < RUSS_PFXV_III_metadata_line_10_____ICT_GROUP_ORG_20251101 >									
129 	//        < iAUssaIvO96GOM4E8vt1mI135LL886sGruWmQn22gk3yI96IJ444772JP6zAdfH0 >									
130 	//        <  u =="0.000000000000000001" : ] 000000245967266.909260000000000000 ; 000000277649993.981807000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000017750F71A7A907 >									
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
174 	//     < RUSS_PFXV_III_metadata_line_11_____ENISEYSKAYA_1_ORG_20251101 >									
175 	//        < 3bpjO9V41Y8XFA2Hz616j168JjFjy4h0ai0FIN3Hy280Shp7tiuH3804j8EaMmPI >									
176 	//        <  u =="0.000000000000000001" : ] 000000277649993.981807000000000000 ; 000000298667565.929471000000000000 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000000001A7A9071C7BB05 >									
178 	//     < RUSS_PFXV_III_metadata_line_12_____ENISEYSKAYA_1_DAO_20251101 >									
179 	//        < AW5j7DKadmeOFbeu1HXSkqpFbqjYds3SQ4bUayhy26Mc68MeH9YT3K2P0Omdj8HA >									
180 	//        <  u =="0.000000000000000001" : ] 000000298667565.929471000000000000 ; 000000319405237.607226000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000001C7BB051E75FAC >									
182 	//     < RUSS_PFXV_III_metadata_line_13_____ENISEYSKAYA_1_DAOPI_20251101 >									
183 	//        < dqDeax8r8UucTXq6I9OpOt040aA7Dp37rLQw47NllWzQGLy68448xAS0HF4NEOa2 >									
184 	//        <  u =="0.000000000000000001" : ] 000000319405237.607226000000000000 ; 000000348449816.166590000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001E75FAC213B136 >									
186 	//     < RUSS_PFXV_III_metadata_line_14_____ENISEYSKAYA_1_DAC_20251101 >									
187 	//        < 43m6NLZbADmLkXV4QuGxb32pR0OZ7gbcWyi66tr57SN8eo5Pp9NRuA1T29WjHmhV >									
188 	//        <  u =="0.000000000000000001" : ] 000000348449816.166590000000000000 ; 000000369879908.944852000000000000 ] >									
189 	//        < 0x00000000000000000000000000000000000000000000000000213B1362346457 >									
190 	//     < RUSS_PFXV_III_metadata_line_15_____ENISEYSKAYA_1_BIMI_20251101 >									
191 	//        < lKquxJH6vlDj7T8d46jrM39GmZ9Rg98UaRRHVQGO79Jg2447uN875vXxDzHl69Qj >									
192 	//        <  u =="0.000000000000000001" : ] 000000369879908.944852000000000000 ; 000000389616371.423611000000000000 ] >									
193 	//        < 0x00000000000000000000000000000000000000000000000000234645725281E5 >									
194 	//     < RUSS_PFXV_III_metadata_line_16_____ENISEYSKAYA_2_ORG_20251101 >									
195 	//        < zLTn928S39g5P7nV8To9uLG68jCg31DV2W8H7ps1M7K67bwaiHkxx1iEey6GMRg7 >									
196 	//        <  u =="0.000000000000000001" : ] 000000389616371.423611000000000000 ; 000000421282337.495756000000000000 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000000025281E5282D36A >									
198 	//     < RUSS_PFXV_III_metadata_line_17_____ENISEYSKAYA_2_DAO_20251101 >									
199 	//        < i6FcJY9O2i2hTKY6Q6iobh9jN1cwf7UMUPeLZ86k4U6RA508eJwQYLMiy9NarH4R >									
200 	//        <  u =="0.000000000000000001" : ] 000000421282337.495756000000000000 ; 000000441362713.725163000000000000 ] >									
201 	//        < 0x00000000000000000000000000000000000000000000000000282D36A2A1774F >									
202 	//     < RUSS_PFXV_III_metadata_line_18_____ENISEYSKAYA_2_DAOPI_20251101 >									
203 	//        < 44W85V5975UWSXEr0FC7142ayCvFMB6rJ2lP6X4854sJKL8DLCZXu59F7s2wtOA9 >									
204 	//        <  u =="0.000000000000000001" : ] 000000441362713.725163000000000000 ; 000000462459177.284736000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000002A1774F2C1A81E >									
206 	//     < RUSS_PFXV_III_metadata_line_19_____ENISEYSKAYA_2_DAC_20251101 >									
207 	//        < KV41kshYb4jv0CkWv3DEV3yku5La81O6a0Bjxw818nifA373KQ02B092V3dTHut7 >									
208 	//        <  u =="0.000000000000000001" : ] 000000462459177.284736000000000000 ; 000000481356938.381996000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000002C1A81E2DE7E0E >									
210 	//     < RUSS_PFXV_III_metadata_line_20_____ENISEYSKAYA_2_BIMI_20251101 >									
211 	//        < 6IaeNI56609e5yGyQBKZX85G36NGJ7f6pl92CiiTplyb70qu64I0yy2C517aCi8I >									
212 	//        <  u =="0.000000000000000001" : ] 000000481356938.381996000000000000 ; 000000508607984.535456000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000002DE7E0E30812FE >									
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
256 	//     < RUSS_PFXV_III_metadata_line_21_____YENISEISKAYA_GTK_1_ORG_20251101 >									
257 	//        < Iz23Bf1EW43x22L9mWpE727SGmtx761V2u1c56c6x20c6Sq5xf7YL4Bh6Su9n75V >									
258 	//        <  u =="0.000000000000000001" : ] 000000508607984.535456000000000000 ; 000000529498439.554500000000000000 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000000030812FE327F354 >									
260 	//     < RUSS_PFXV_III_metadata_line_22_____YENISEISKAYA_GTK_1_DAO_20251101 >									
261 	//        < 53C33r2j0hCH1eQMEm47WkoVlR6u9QAa85t181wvKMm8cqEAkX0hR4QlZf3s4v5J >									
262 	//        <  u =="0.000000000000000001" : ] 000000529498439.554500000000000000 ; 000000554307158.777124000000000000 ] >									
263 	//        < 0x00000000000000000000000000000000000000000000000000327F35434DCE3C >									
264 	//     < RUSS_PFXV_III_metadata_line_23_____YENISEISKAYA_GTK_1_DAOPI_20251101 >									
265 	//        < PQr32Ar106BAzoQGtNH0kEWu4A92C0iCOFOyb4sHT65417IAbCFCu2h0SPI9p2QZ >									
266 	//        <  u =="0.000000000000000001" : ] 000000554307158.777124000000000000 ; 000000573849835.759021000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000034DCE3C36BA018 >									
268 	//     < RUSS_PFXV_III_metadata_line_24_____YENISEISKAYA_GTK_1_DAC_20251101 >									
269 	//        < bsswbXIB1vv767A1KgW5DwWsSyUtMI1119nPh7m6B4bH37OY7jSBRspB6u86rvB4 >									
270 	//        <  u =="0.000000000000000001" : ] 000000573849835.759021000000000000 ; 000000593076908.195218000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000036BA018388F6AB >									
272 	//     < RUSS_PFXV_III_metadata_line_25_____YENISEISKAYA_GTK_1_BIMI_20251101 >									
273 	//        < PNS4mrs2IbNMp6fwuIqTl4cRMM42Z94474mnGt834X6sdUpceQ3o4e4Cw2ZJTKyP >									
274 	//        <  u =="0.000000000000000001" : ] 000000593076908.195218000000000000 ; 000000621837687.241578000000000000 ] >									
275 	//        < 0x00000000000000000000000000000000000000000000000000388F6AB3B4D959 >									
276 	//     < RUSS_PFXV_III_metadata_line_26_____YENISEISKAYA_GTK_2_ORG_20251101 >									
277 	//        < xo8dW8Dy1oGktUJDH4DoSfMhiVqQP7q3cFnwiKVAc8TmqKWRRa61fKo1GiY2Zb2s >									
278 	//        <  u =="0.000000000000000001" : ] 000000621837687.241578000000000000 ; 000000642018316.910716000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000003B4D9593D3A468 >									
280 	//     < RUSS_PFXV_III_metadata_line_27_____YENISEISKAYA_GTK_2_DAO_20251101 >									
281 	//        < eZdU0muR3RU0vetA62d4s6m33ja84DwdaVI5wXNE481OseUbo8jN2f4KKTqTJ9lw >									
282 	//        <  u =="0.000000000000000001" : ] 000000642018316.910716000000000000 ; 000000672915469.211192000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000003D3A468402C99B >									
284 	//     < RUSS_PFXV_III_metadata_line_28_____YENISEISKAYA_GTK_2_DAOPI_20251101 >									
285 	//        < 4f2Lw8mX93372ECxq9e15LASa9jK85E04RIX1B81Q6weaBHv29al14igjZE60rwN >									
286 	//        <  u =="0.000000000000000001" : ] 000000672915469.211192000000000000 ; 000000693347757.779769000000000000 ] >									
287 	//        < 0x00000000000000000000000000000000000000000000000000402C99B421F6F8 >									
288 	//     < RUSS_PFXV_III_metadata_line_29_____YENISEISKAYA_GTK_2_DAC_20251101 >									
289 	//        < 5lqvNUBK51z40Bpl3p9ZkGA8SDprn2E0MJC6c15NlvB1712xOe1VU29n9hT74A2Y >									
290 	//        <  u =="0.000000000000000001" : ] 000000693347757.779769000000000000 ; 000000717444318.089675000000000000 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000000000421F6F8446BBB0 >									
292 	//     < RUSS_PFXV_III_metadata_line_30_____YENISEISKAYA_GTK_2_BIMI_20251101 >									
293 	//        < Ssu6eLy6XL45D8Vv94v4qH8YKtJdv826yjYje20Im34J7VZvo1VOp5X85k8DD04S >									
294 	//        <  u =="0.000000000000000001" : ] 000000717444318.089675000000000000 ; 000000750311672.721146000000000000 ] >									
295 	//        < 0x00000000000000000000000000000000000000000000000000446BBB0478E27F >									
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
338 	//     < RUSS_PFXV_III_metadata_line_31_____ZAO_ENISEY_MINING_GEOLOGIC_CO_1_ORG_20251101 >									
339 	//        < 72LKFdXF8FoWZ9G4w9F2RV47P2M64D8ygrrqf5qOmL70ZVpzJh1JS98m6hSbFrmp >									
340 	//        <  u =="0.000000000000000001" : ] 000000750311672.721146000000000000 ; 000000771860134.901605000000000000 ] >									
341 	//        < 0x00000000000000000000000000000000000000000000000000478E27F499C3DD >									
342 	//     < RUSS_PFXV_III_metadata_line_32_____ZAO_ENISEY_MINING_GEOLOGIC_CO_1_DAO_20251101 >									
343 	//        < O5MT731D5F6tkHf59k4629Xa6F36il81Sy7EFY8RP8Kdts96Sd9Qy64A3I58q7Xv >									
344 	//        <  u =="0.000000000000000001" : ] 000000771860134.901605000000000000 ; 000000794543247.604125000000000000 ] >									
345 	//        < 0x00000000000000000000000000000000000000000000000000499C3DD4BC6075 >									
346 	//     < RUSS_PFXV_III_metadata_line_33_____ZAO_ENISEY_MINING_GEOLOGIC_CO_1_DAOPI_20251101 >									
347 	//        < CE4p6AuHKZGo06AtgbZ63xiQwrMV4CeD3O015mG8RX7gK5uY7nGWbX5qH991S2t8 >									
348 	//        <  u =="0.000000000000000001" : ] 000000794543247.604125000000000000 ; 000000820227812.834311000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000004BC60754E3917D >									
350 	//     < RUSS_PFXV_III_metadata_line_34_____ZAO_ENISEY_MINING_GEOLOGIC_CO_1_DAC_20251101 >									
351 	//        < 31z9i50Q6Q09JUXw0k737F37q51OiQUhIJRk6PH846fgF9b9cfgRd2T46M60IX3Q >									
352 	//        <  u =="0.000000000000000001" : ] 000000820227812.834311000000000000 ; 000000847872487.826369000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000004E3917D50DC031 >									
354 	//     < RUSS_PFXV_III_metadata_line_35_____ZAO_ENISEY_MINING_GEOLOGIC_CO_1_BIMI_20251101 >									
355 	//        < 856IoO9Cc43PFJB0UJG1swsJxHX4yQyvglgG0s6T6Km52797753PbeZ5e7qGJ7KZ >									
356 	//        <  u =="0.000000000000000001" : ] 000000847872487.826369000000000000 ; 000000878007470.764093000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000050DC03153BBBAB >									
358 	//     < RUSS_PFXV_III_metadata_line_36_____ZAO_ENISEY_MINING_GEOLOGIC_CO_2_ORG_20251101 >									
359 	//        < 9gR468YW2ff9tRadStZ2w4buBoinGm77YCT4LaIUP0tFObQEhoPXxm77f79msL4A >									
360 	//        <  u =="0.000000000000000001" : ] 000000878007470.764093000000000000 ; 000000903967093.201839000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000053BBBAB5635825 >									
362 	//     < RUSS_PFXV_III_metadata_line_37_____ZAO_ENISEY_MINING_GEOLOGIC_CO_2_DAO_20251101 >									
363 	//        < 4cPHwvV5iVu19Y7P21xXZf07ec9dTBWDWB41fP4s82f35J64nJ0Zy767dL7diHk5 >									
364 	//        <  u =="0.000000000000000001" : ] 000000903967093.201839000000000000 ; 000000926866851.301725000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000005635825586495D >									
366 	//     < RUSS_PFXV_III_metadata_line_38_____ZAO_ENISEY_MINING_GEOLOGIC_CO_2_DAOPI_20251101 >									
367 	//        < DY866haqoW9HtnYWzO2B1E1Q26dooX8it7E4bCb5YHwiVXpeUl4evYGQK5859rgp >									
368 	//        <  u =="0.000000000000000001" : ] 000000926866851.301725000000000000 ; 000000948952846.401117000000000000 ] >									
369 	//        < 0x00000000000000000000000000000000000000000000000000586495D5A7FCB5 >									
370 	//     < RUSS_PFXV_III_metadata_line_39_____ZAO_ENISEY_MINING_GEOLOGIC_CO_2_DAC_20251101 >									
371 	//        < 1VHsFFo1S1BLz8vWs83vO4VzH58sN6z24GT91t6eBnjN13qlNjG69ZVVTxljDAB3 >									
372 	//        <  u =="0.000000000000000001" : ] 000000948952846.401117000000000000 ; 000000971231296.904485000000000000 ] >									
373 	//        < 0x000000000000000000000000000000000000000000000000005A7FCB55C9FB3A >									
374 	//     < RUSS_PFXV_III_metadata_line_40_____ZAO_ENISEY_MINING_GEOLOGIC_CO_2_BIMI_20251101 >									
375 	//        < MYrQ48z8vEC3F7n1KT0P7Y5F9v7cu85900fR1d2189fdk5b9eIp3H9IHuc2N4Tm5 >									
376 	//        <  u =="0.000000000000000001" : ] 000000971231296.904485000000000000 ; 000000995290381.143701000000000000 ] >									
377 	//        < 0x000000000000000000000000000000000000000000000000005C9FB3A5EEB14E >									
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