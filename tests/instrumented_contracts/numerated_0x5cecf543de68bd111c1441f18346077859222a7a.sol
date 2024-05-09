1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXXXVI_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXXXVI_I_883		"	;
8 		string	public		symbol =	"	RUSS_PFXXXVI_I_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		598028592051817000000000000					;	
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
92 	//     < RUSS_PFXXXVI_I_metadata_line_1_____ROSNEFT_20211101 >									
93 	//        < 6oOrwmf809Tqn0xA98D4GltDo4NS8wX80sLVeplSZu3HMS5Y83Mnu9DhGp0452WX >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000015430032.277590900000000000 ] >									
95 	//        < 0x0000000000000000000000000000000000000000000000000000000000178B5B >									
96 	//     < RUSS_PFXXXVI_I_metadata_line_2_____ROSNEFT_GBP_20211101 >									
97 	//        < DL7GY0C8aMuj1qcUF0UJ5lv3TNjW20H5zD1275ln2I3Ys07iVb8CN654nsh5Gxz9 >									
98 	//        <  u =="0.000000000000000001" : ] 000000015430032.277590900000000000 ; 000000031633078.819096900000000000 ] >									
99 	//        < 0x0000000000000000000000000000000000000000000000000000178B5B3044AC >									
100 	//     < RUSS_PFXXXVI_I_metadata_line_3_____ROSNEFT_USD_20211101 >									
101 	//        < LL0A15xY2jzkuYzNeRAo975R3C69y6Z1EAbmZJgJbr4H6uScWpK1K9A8Gzhr5251 >									
102 	//        <  u =="0.000000000000000001" : ] 000000031633078.819096900000000000 ; 000000045202749.867386900000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000003044AC44F953 >									
104 	//     < RUSS_PFXXXVI_I_metadata_line_4_____ROSNEFT_SA_CHF_20211101 >									
105 	//        < 0wfN15Up0REdyZwDh5LiTGbgci1IqDk8AEKg4f8uRj4v2Z2iT5mx480OHkzQk8eW >									
106 	//        <  u =="0.000000000000000001" : ] 000000045202749.867386900000000000 ; 000000061743402.683194000000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000044F9535E3684 >									
108 	//     < RUSS_PFXXXVI_I_metadata_line_5_____ROSNEFT_GMBH_EUR_20211101 >									
109 	//        < VADx3HW4GI667Fi3ndC3a9k1O81858LpNl60338wkX67M2kv79SK0xlNvplcYbyj >									
110 	//        <  u =="0.000000000000000001" : ] 000000061743402.683194000000000000 ; 000000075543141.585860800000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000005E368473450A >									
112 	//     < RUSS_PFXXXVI_I_metadata_line_6_____BAIKALFINANSGRUP_20211101 >									
113 	//        < pZ4fUjXP0n4BMyO3NR8y6u4On5o61u72fosQ4Y2867Dt0BHKJo8o5U4utu496K42 >									
114 	//        <  u =="0.000000000000000001" : ] 000000075543141.585860800000000000 ; 000000088728803.259899800000000000 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000000000073450A8763B0 >									
116 	//     < RUSS_PFXXXVI_I_metadata_line_7_____BAIKAL_ORG_20211101 >									
117 	//        < eU4UQSGL8J5p2Q3XJ4WC69OH5PKhrMh3e1WP3wZOvyAosmD7hAPwEmPOV6Qac10o >									
118 	//        <  u =="0.000000000000000001" : ] 000000088728803.259899800000000000 ; 000000105979616.076433000000000000 ] >									
119 	//        < 0x00000000000000000000000000000000000000000000000000008763B0A1B64A >									
120 	//     < RUSS_PFXXXVI_I_metadata_line_8_____BAIKAL_AB_20211101 >									
121 	//        < 884M4umWkaB16gXeQcpn55jVbIt830H4AtaV1AfFqZa8B2n2Vent2K5El68D03u6 >									
122 	//        <  u =="0.000000000000000001" : ] 000000105979616.076433000000000000 ; 000000120946512.090898000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000A1B64AB88CBB >									
124 	//     < RUSS_PFXXXVI_I_metadata_line_9_____BAIKAL_CHF_20211101 >									
125 	//        < sksWlrZ03yzryz8rt97ZQY84Y4TbSlLpx20Jn98c6dgTVOcwy2kX4n4NMTC5FQUF >									
126 	//        <  u =="0.000000000000000001" : ] 000000120946512.090898000000000000 ; 000000136552066.490448000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000000B88CBBD05CA7 >									
128 	//     < RUSS_PFXXXVI_I_metadata_line_10_____BAIKAL_BYR_20211101 >									
129 	//        < Mjcq9x3v1h58a7Ij4gLQik551gFLBaxGy959IVfuacTTsUI94Gqlav5av9X67wZs >									
130 	//        <  u =="0.000000000000000001" : ] 000000136552066.490448000000000000 ; 000000151514614.842168000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000000D05CA7E73165 >									
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
174 	//     < RUSS_PFXXXVI_I_metadata_line_11_____YUKOS_ABI_20211101 >									
175 	//        < yXfYk7x2JrL4n18jnE2Mb5YuF2of3WkAhRkt6nrNxY9crTU8Vkm6CHQ8T69r1M79 >									
176 	//        <  u =="0.000000000000000001" : ] 000000151514614.842168000000000000 ; 000000167892545.876698000000000000 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000000000E731651002F07 >									
178 	//     < RUSS_PFXXXVI_I_metadata_line_12_____YUKOS_ABII_20211101 >									
179 	//        < kf241v8T6pvG08C6Llthw3kVBQtG93i8lE4m1kPS8r6by5S82BQRDhfVhXAepC6O >									
180 	//        <  u =="0.000000000000000001" : ] 000000167892545.876698000000000000 ; 000000183346723.427777000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000001002F07117C3D0 >									
182 	//     < RUSS_PFXXXVI_I_metadata_line_13_____YUKOS_ABIII_20211101 >									
183 	//        < 8VsC5P4n6ef6BG546RzX2V04t4RCw3LBTS56PLBtHhx0sj480Idg776mCywD4AIk >									
184 	//        <  u =="0.000000000000000001" : ] 000000183346723.427777000000000000 ; 000000196850049.583184000000000000 ] >									
185 	//        < 0x00000000000000000000000000000000000000000000000000117C3D012C5E8D >									
186 	//     < RUSS_PFXXXVI_I_metadata_line_14_____YUKOS_ABIV_20211101 >									
187 	//        < 6ERrEgpfDt1y6X17H78x99kkG6do6oP8y75dr19kZAhZHgQ5fOPGY6mk87F3W0nu >									
188 	//        <  u =="0.000000000000000001" : ] 000000196850049.583184000000000000 ; 000000213540595.883397000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000012C5E8D145D64C >									
190 	//     < RUSS_PFXXXVI_I_metadata_line_15_____YUKOS_ABV_20211101 >									
191 	//        < GPf14b8oOavAwd2po3a5C6O6iR2BUOaOKGsg1eV80HDIQo4t28Rn5IXcv18Mzr3A >									
192 	//        <  u =="0.000000000000000001" : ] 000000213540595.883397000000000000 ; 000000227104931.112997000000000000 ] >									
193 	//        < 0x00000000000000000000000000000000000000000000000000145D64C15A88DD >									
194 	//     < RUSS_PFXXXVI_I_metadata_line_16_____ROSNEFT_TRADE_LIMITED_20211101 >									
195 	//        < tsfEkgE5EodAh2mF3yIS09LbUQFqdnZ6sK3134W72KUC5HVJs1erx84qu3nuL9vC >									
196 	//        <  u =="0.000000000000000001" : ] 000000227104931.112997000000000000 ; 000000244303154.550124000000000000 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000000015A88DD174C6EB >									
198 	//     < RUSS_PFXXXVI_I_metadata_line_17_____NEFT_AKTIV_20211101 >									
199 	//        < 3b5h56cgV66rNv9OH218j2ls7oXzSzvrI2iZH52RgiXkq10d5LZQJDwJ86FRQya1 >									
200 	//        <  u =="0.000000000000000001" : ] 000000244303154.550124000000000000 ; 000000258505992.566003000000000000 ] >									
201 	//        < 0x00000000000000000000000000000000000000000000000000174C6EB18A72E7 >									
202 	//     < RUSS_PFXXXVI_I_metadata_line_18_____ACHINSK_OIL_REFINERY_VNK_20211101 >									
203 	//        < ySVdpVOS0pzc82YVRrJ0PDAe1vdz4IC6kr76188RHDFG1kIYZ821QOt4243n02S9 >									
204 	//        <  u =="0.000000000000000001" : ] 000000258505992.566003000000000000 ; 000000272452109.233791000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000018A72E719FBA9B >									
206 	//     < RUSS_PFXXXVI_I_metadata_line_19_____ROSPAN_INT_20211101 >									
207 	//        < JSs1en9u8jNWnL83Y20wDMUErU9910ru6DQm91Ha6O39XD9M6277tg09DJm7bt01 >									
208 	//        <  u =="0.000000000000000001" : ] 000000272452109.233791000000000000 ; 000000286577049.059721000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000000019FBA9B1B54829 >									
210 	//     < RUSS_PFXXXVI_I_metadata_line_20_____STROYTRANSGAZ_LIMITED_20211101 >									
211 	//        < SMwSmvi6y77e2c961xf5V6ie856C2ajP5yOJ31pXybujpxVjT56C3Ja0fc5Yp826 >									
212 	//        <  u =="0.000000000000000001" : ] 000000286577049.059721000000000000 ; 000000303235143.640260000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000001B548291CEB33A >									
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
256 	//     < RUSS_PFXXXVI_I_metadata_line_21_____ROSNEFT_LIMITED_20211101 >									
257 	//        < 25Q4L513r79XlnvXdvzB8KEE28KWc8324W52UN3TzKs34qE2TyBcQw9xn20N9dHL >									
258 	//        <  u =="0.000000000000000001" : ] 000000303235143.640260000000000000 ; 000000318178549.456692000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000001CEB33A1E5807F >									
260 	//     < RUSS_PFXXXVI_I_metadata_line_22_____TAIHU_LIMITED_20211101 >									
261 	//        < v22Mt59xMzlARu30Xp5q3tf9vqC29BU6b159C6ik54fPc9roUF1u5s0F0s43akXw >									
262 	//        <  u =="0.000000000000000001" : ] 000000318178549.456692000000000000 ; 000000333104658.008700000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000001E5807F1FC4702 >									
264 	//     < RUSS_PFXXXVI_I_metadata_line_23_____TAIHU_ORG_20211101 >									
265 	//        < NXc72w3AzxM3W8H5Lwybr8mLk6CF6ls4LRry8c23EZEm47QwXTI2384qve3B04h8 >									
266 	//        <  u =="0.000000000000000001" : ] 000000333104658.008700000000000000 ; 000000348878604.287521000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000001FC470221458B4 >									
268 	//     < RUSS_PFXXXVI_I_metadata_line_24_____EAST_SIBERIAN_GAS_CO_20211101 >									
269 	//        < u8432L8YbhAXjvyKkV2uv71UGa4Eth999Q3QUflw4f6PP1J6532z3aCe3OusYE89 >									
270 	//        <  u =="0.000000000000000001" : ] 000000348878604.287521000000000000 ; 000000362736487.275237000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000021458B42297DF1 >									
272 	//     < RUSS_PFXXXVI_I_metadata_line_25_____RN_TUAPSINSKIY_NPZ_20211101 >									
273 	//        < 8haTsbPfm9PBWBI6oEEvrqspzONSep50F8X5ZS25d4j7j3bCRdk6HgYScsasrSTm >									
274 	//        <  u =="0.000000000000000001" : ] 000000362736487.275237000000000000 ; 000000376479024.042041000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002297DF123E761E >									
276 	//     < RUSS_PFXXXVI_I_metadata_line_26_____ROSPAN_ORG_20211101 >									
277 	//        < NEY6O5DSEj4lOFQ0TfQNxmP42KMnTuB3mp2msLbOCgXR109i3HiNyU3AV3G9458A >									
278 	//        <  u =="0.000000000000000001" : ] 000000376479024.042041000000000000 ; 000000390413200.596266000000000000 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000000000023E761E253B928 >									
280 	//     < RUSS_PFXXXVI_I_metadata_line_27_____SYSRAN_20211101 >									
281 	//        < Q8U1sw4A4WK3l802uxs58QdONoR8fSQwaGvSeb9IXD0VJ0M7ihWKZ17UlL9w6d46 >									
282 	//        <  u =="0.000000000000000001" : ] 000000390413200.596266000000000000 ; 000000403824133.435252000000000000 ] >									
283 	//        < 0x00000000000000000000000000000000000000000000000000253B9282682FCD >									
284 	//     < RUSS_PFXXXVI_I_metadata_line_28_____SYSRAN_ORG_20211101 >									
285 	//        < jhgcAEmdF7PKbR2gf300Kkpqv48xAHnHcy32OsrfVGsNB9P1wHFHE6Swkh9Cq8Ql >									
286 	//        <  u =="0.000000000000000001" : ] 000000403824133.435252000000000000 ; 000000419478805.902084000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000002682FCD28012E9 >									
288 	//     < RUSS_PFXXXVI_I_metadata_line_29_____ARTAG_20211101 >									
289 	//        < 64435HxSev0E2w4tT1ik24x3RKKDHBkyCj88c90B90cXt9tz9hZrgn00cRMGFIZA >									
290 	//        <  u =="0.000000000000000001" : ] 000000419478805.902084000000000000 ; 000000434280673.257655000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000028012E9296A8E3 >									
292 	//     < RUSS_PFXXXVI_I_metadata_line_30_____ARTAG_ORG_20211101 >									
293 	//        < 5DdW57E49c2L5A7erDVPbTC61gb42I6Juc2Ctx5XUBCaNP2IjT4eaGJ31R7IHhI6 >									
294 	//        <  u =="0.000000000000000001" : ] 000000434280673.257655000000000000 ; 000000449946478.506331000000000000 ] >									
295 	//        < 0x00000000000000000000000000000000000000000000000000296A8E32AE9058 >									
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
338 	//     < RUSS_PFXXXVI_I_metadata_line_31_____RN_TUAPSE_REFINERY_LLC_20211101 >									
339 	//        < F1qo0fXUJ6066fona9B5Q3w0p4dW633Un1XUDB0FO18SZ79FkD91FYFUuvv9k86Q >									
340 	//        <  u =="0.000000000000000001" : ] 000000449946478.506331000000000000 ; 000000466641896.112142000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000002AE90582C809FE >									
342 	//     < RUSS_PFXXXVI_I_metadata_line_32_____TUAPSE_ORG_20211101 >									
343 	//        < HXjbA3s8m6hsqxE38631A46bhkW9081U8618i01517f73Xb9rG3Kn3VQS2cqpRNy >									
344 	//        <  u =="0.000000000000000001" : ] 000000466641896.112142000000000000 ; 000000480041609.093958000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000002C809FE2DC7C41 >									
346 	//     < RUSS_PFXXXVI_I_metadata_line_33_____NATIONAL_OIL_CONSORTIUM_20211101 >									
347 	//        < ofBkA2iKNI972IS5S1144j10g2cV1akoE2vlPOyemE2Gscrg36r0gMk86OC2BV4w >									
348 	//        <  u =="0.000000000000000001" : ] 000000480041609.093958000000000000 ; 000000494187512.406063000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000002DC7C412F211FF >									
350 	//     < RUSS_PFXXXVI_I_metadata_line_34_____RN_ASTRA_20211101 >									
351 	//        < 79403egtSnAN7hxw2v34Ajer1hQw0HwGf3Fb8UL2qIj8lY49vKF60PxsVev47bbG >									
352 	//        <  u =="0.000000000000000001" : ] 000000494187512.406063000000000000 ; 000000509539674.935424000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000002F211FF3097EEF >									
354 	//     < RUSS_PFXXXVI_I_metadata_line_35_____ASTRA_ORG_20211101 >									
355 	//        < 82DctXTOZnSuy3DlQYQ3kiYWJ36eDl8IGY476enit8GwmlSYAv6gb20PkvyyV7Sz >									
356 	//        <  u =="0.000000000000000001" : ] 000000509539674.935424000000000000 ; 000000526074476.867536000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000003097EEF322B9D8 >									
358 	//     < RUSS_PFXXXVI_I_metadata_line_36_____ROSNEFT_DEUTSCHLAND_GMBH_20211101 >									
359 	//        < m4B8ce9MQ045cC7i5xYvjlTr7557lg3W4ZY7jJ98LwUtg3m6B0cfHP45n7Nk82e8 >									
360 	//        <  u =="0.000000000000000001" : ] 000000526074476.867536000000000000 ; 000000539117282.069232000000000000 ] >									
361 	//        < 0x00000000000000000000000000000000000000000000000000322B9D8336A0B0 >									
362 	//     < RUSS_PFXXXVI_I_metadata_line_37_____ITERA_GROUP_LIMITED_20211101 >									
363 	//        < w2K2ZXFjOt917Dhhuu7j68dECISiM1N3p5Bkc5k63M16HE7g4tIWP0rd5x81m27W >									
364 	//        <  u =="0.000000000000000001" : ] 000000539117282.069232000000000000 ; 000000556012978.534754000000000000 ] >									
365 	//        < 0x00000000000000000000000000000000000000000000000000336A0B03506892 >									
366 	//     < RUSS_PFXXXVI_I_metadata_line_38_____SAMOTLORNEFTEGAZ_20211101 >									
367 	//        < BFY7h0vNBQr3fbsf8FI670B37DP4BE6y63797k7A020x24FJYKR79Tn4ossHn6CW >									
368 	//        <  u =="0.000000000000000001" : ] 000000556012978.534754000000000000 ; 000000570029777.077363000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000003506892365CBE2 >									
370 	//     < RUSS_PFXXXVI_I_metadata_line_39_____KUBANNEFTEPRODUCT_20211101 >									
371 	//        < fck36b3CZj5SVG34r490tM9RUm92811TUOBAS0L4sRdeyLzA84Tw4i4X5KIcZbz9 >									
372 	//        <  u =="0.000000000000000001" : ] 000000570029777.077363000000000000 ; 000000584686621.762641000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000365CBE237C2936 >									
374 	//     < RUSS_PFXXXVI_I_metadata_line_40_____KUBAN_ORG_20211101 >									
375 	//        < K2ADW5x1A48cahKdTklFzZDaJiVSXmbaYibJ911FgkUl3YtvVQnz3eG5BW7af650 >									
376 	//        <  u =="0.000000000000000001" : ] 000000584686621.762641000000000000 ; 000000598028592.051817000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000037C293639084EB >									
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