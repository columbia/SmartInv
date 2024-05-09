1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXXVII_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXXVII_I_883		"	;
8 		string	public		symbol =	"	RUSS_PFXXVII_I_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		599305625295470000000000000					;	
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
92 	//     < RUSS_PFXXVII_I_metadata_line_1_____SIBUR_20211101 >									
93 	//        < 8K9kSf1xGeTK7KPmVk67PMCjtnABtcuYjRf7egLYX0O15ipCo02w33X5ebZC7HjK >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000017257679.537300900000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000001A5548 >									
96 	//     < RUSS_PFXXVII_I_metadata_line_2_____SIBURTYUMENGAZ_20211101 >									
97 	//        < vE16vkfm4F6vz1Wc3tf1l62IEzA7V6H8OlC81Rlz0282l1Yh8sbiFcSn7IvljoU1 >									
98 	//        <  u =="0.000000000000000001" : ] 000000017257679.537300900000000000 ; 000000032353933.847403600000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000001A5548315E41 >									
100 	//     < RUSS_PFXXVII_I_metadata_line_3_____VOLGOPROMGAZ_GROUP_20211101 >									
101 	//        < T9T7V51Ly83DpPXFfm59brD7e957kLTCRWjwJmed1TLqf2JS7B0C0q87099AG1Qk >									
102 	//        <  u =="0.000000000000000001" : ] 000000032353933.847403600000000000 ; 000000047525316.440998000000000000 ] >									
103 	//        < 0x0000000000000000000000000000000000000000000000000000315E41488494 >									
104 	//     < RUSS_PFXXVII_I_metadata_line_4_____KSTOVO_20211101 >									
105 	//        < i5uw584vxUl6gGDvR2D3Hua09y4MLClsrQatUdvYv9DL69Bxmp9UcABRv28xC24r >									
106 	//        <  u =="0.000000000000000001" : ] 000000047525316.440998000000000000 ; 000000060879903.331445900000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000004884945CE536 >									
108 	//     < RUSS_PFXXVII_I_metadata_line_5_____SIBUR_MOTORS_20211101 >									
109 	//        < I94XCT9Vg8SiwhIxPzGWks54Sn81xw7zmZ205oJLr2rEzRfcUgU3mjF57gbxojv4 >									
110 	//        <  u =="0.000000000000000001" : ] 000000060879903.331445900000000000 ; 000000076390357.391254800000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000005CE536748FFC >									
112 	//     < RUSS_PFXXVII_I_metadata_line_6_____SIBUR_FINANCE_20211101 >									
113 	//        < A04IEQ6Yytjuhkl5wd8pR508kK8aH2mE8d4K37o9rF858sr5pI28wkdRjBM41W8L >									
114 	//        <  u =="0.000000000000000001" : ] 000000076390357.391254800000000000 ; 000000091190359.609649600000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000748FFC8B253C >									
116 	//     < RUSS_PFXXVII_I_metadata_line_7_____AKRILAT_20211101 >									
117 	//        < 15i2ezMOuA6EFfSrZANjS1fsR17lQAW5fojq4E3nqF0FXl4j99vO5F7u99UN2a5X >									
118 	//        <  u =="0.000000000000000001" : ] 000000091190359.609649600000000000 ; 000000107761294.927459000000000000 ] >									
119 	//        < 0x00000000000000000000000000000000000000000000000000008B253CA46E41 >									
120 	//     < RUSS_PFXXVII_I_metadata_line_8_____SINOPEC_RUBBER_20211101 >									
121 	//        < GGQx9J3renhMSZlAlW6BkjbdJJLOLA6V6O240S1peCX7rA1MrUDn5A2ZRZIADs53 >									
122 	//        <  u =="0.000000000000000001" : ] 000000107761294.927459000000000000 ; 000000124531258.968237000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000A46E41BE0506 >									
124 	//     < RUSS_PFXXVII_I_metadata_line_9_____TOBOLSK_NEFTEKHIM_20211101 >									
125 	//        < 8x43jIC3Zp4722H0e1756EJ2hTbT9cxOmBsPp6vpoJMY202blB94r3Ng2Rt406n3 >									
126 	//        <  u =="0.000000000000000001" : ] 000000124531258.968237000000000000 ; 000000140669467.234452000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000000BE0506D6A503 >									
128 	//     < RUSS_PFXXVII_I_metadata_line_10_____SIBUR_PETF_20211101 >									
129 	//        < 2Jzbrh8qan13X31qlPKTXau19sJs7M4ZO8K1pb5803Hlslr1a3j4qN04vkct3k0M >									
130 	//        <  u =="0.000000000000000001" : ] 000000140669467.234452000000000000 ; 000000154387122.393533000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000000D6A503EB9378 >									
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
174 	//     < RUSS_PFXXVII_I_metadata_line_11_____MURAVLENKOVSKY_GAS_PROCESS_PLANT_20211101 >									
175 	//        < 0bp61Ifza0e867qO62u2fXU8330g19OY1HTO21r6MjvXYcVRCrujvC2U1oN84m7b >									
176 	//        <  u =="0.000000000000000001" : ] 000000154387122.393533000000000000 ; 000000168587176.416669000000000000 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000000000EB93781013E5E >									
178 	//     < RUSS_PFXXVII_I_metadata_line_12_____OOO_IT_SERVICE_20211101 >									
179 	//        < 4SX73K299gMo16U5aV2i11g709Jsr7JWxBmnUN6D5P307u2n2st25nV6fAIp161I >									
180 	//        <  u =="0.000000000000000001" : ] 000000168587176.416669000000000000 ; 000000181679373.475449000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000001013E5E1153881 >									
182 	//     < RUSS_PFXXVII_I_metadata_line_13_____ZAO_MIRACLE_20211101 >									
183 	//        < 2RlfnIesgQn2E9ZBFa0V2E7aZIUqE8jWebh1IK98G0G1ECQdTj3Fq1xRw19ITz37 >									
184 	//        <  u =="0.000000000000000001" : ] 000000181679373.475449000000000000 ; 000000198505792.945183000000000000 ] >									
185 	//        < 0x00000000000000000000000000000000000000000000000000115388112EE553 >									
186 	//     < RUSS_PFXXVII_I_metadata_line_14_____NOVATEK_POLYMER_20211101 >									
187 	//        < JNyB9U1Q2G54W7SfENBBh0ASihAGqJOe8IEw5M75fUP8uB6ES1r4sq64cAEg6H6T >									
188 	//        <  u =="0.000000000000000001" : ] 000000198505792.945183000000000000 ; 000000213027140.586721000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000012EE5531450DBA >									
190 	//     < RUSS_PFXXVII_I_metadata_line_15_____SOUTHWEST_GAS_PIPELINES_20211101 >									
191 	//        < 52P98440V3w1S0213S7GX71a0fn4BTu7ZVSMr3greLwfJKig6J26hKSVw994AZ89 >									
192 	//        <  u =="0.000000000000000001" : ] 000000213027140.586721000000000000 ; 000000229322634.320575000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000001450DBA15DEB27 >									
194 	//     < RUSS_PFXXVII_I_metadata_line_16_____YUGRAGAZPERERABOTKA_20211101 >									
195 	//        < n581mTmm9Wwiv6k8YNuZcAdB90yBVfZhKz62vrSloAV3J6H4Kqce8e3N18LDqPev >									
196 	//        <  u =="0.000000000000000001" : ] 000000229322634.320575000000000000 ; 000000244431834.372375000000000000 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000000015DEB27174F92F >									
198 	//     < RUSS_PFXXVII_I_metadata_line_17_____TOMSKNEFTEKHIM_20211101 >									
199 	//        < LTf4qCa1FG72h2FqN89HSq7G31Iu33YlTE0m33q12LKj428IRn0p2QGPNhvTv690 >									
200 	//        <  u =="0.000000000000000001" : ] 000000244431834.372375000000000000 ; 000000258491235.293890000000000000 ] >									
201 	//        < 0x00000000000000000000000000000000000000000000000000174F92F18A6D24 >									
202 	//     < RUSS_PFXXVII_I_metadata_line_18_____BALTIC_LNG_20211101 >									
203 	//        < 92w7EL6rASFGccvfNM6Jr2lf1wfF1jrWJN41OT91na90yH2MU0G69tUFRt03oM32 >									
204 	//        <  u =="0.000000000000000001" : ] 000000258491235.293890000000000000 ; 000000273497901.774534000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000018A6D241A1531E >									
206 	//     < RUSS_PFXXVII_I_metadata_line_19_____SIBUR_INT_GMBH_20211101 >									
207 	//        < Uy3Sh6bjsxxzOAUNGkj56MvEVP561KkS2zvgN8H559Gg0m5dT4Av5n56Df80rBQs >									
208 	//        <  u =="0.000000000000000001" : ] 000000273497901.774534000000000000 ; 000000289975135.374181000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000001A1531E1BA778A >									
210 	//     < RUSS_PFXXVII_I_metadata_line_20_____TOBOL_SK_POLIMER_20211101 >									
211 	//        < wjKkz9QFvX8tQdprU563tkQSr4PB87fwAX376Jotz647TXISO3OGZ3Ih3unefAd8 >									
212 	//        <  u =="0.000000000000000001" : ] 000000289975135.374181000000000000 ; 000000306389865.149331000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000001BA778A1D3838B >									
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
256 	//     < RUSS_PFXXVII_I_metadata_line_21_____SIBUR_SCIENT_RD_INSTITUTE_GAS_PROCESS_20211101 >									
257 	//        < S6Qj3brPs2f97iGb03r7KWO8GK0l08Ru0cs80F5Eq1ucadBI36hMlejqYa85Zhvr >									
258 	//        <  u =="0.000000000000000001" : ] 000000306389865.149331000000000000 ; 000000319846099.848078000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000001D3838B1E80BE2 >									
260 	//     < RUSS_PFXXVII_I_metadata_line_22_____ZAPSIBNEFTEKHIM_20211101 >									
261 	//        < neUMv58F04h30Agj833W24jpV6OSx7qGMRR95mAfNceQYO757lPkLK73LE92M529 >									
262 	//        <  u =="0.000000000000000001" : ] 000000319846099.848078000000000000 ; 000000336418942.492715000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000001E80BE220155A6 >									
264 	//     < RUSS_PFXXVII_I_metadata_line_23_____RUSVINYL_20211101 >									
265 	//        < 0X6GNbFQ03nMbPk07jN0p4NS7fEH2n21Z2IaFI73X7qe19jX9tGUN7MOPnZ16llk >									
266 	//        <  u =="0.000000000000000001" : ] 000000336418942.492715000000000000 ; 000000353015357.315876000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000020155A621AA8A0 >									
268 	//     < RUSS_PFXXVII_I_metadata_line_24_____SIBUR_SECURITIES_LIMITED_20211101 >									
269 	//        < TRUkGxsi1xMR3k2VIOenK1P79fXyK4r9r12ED9T0j8X4UBdswUyv7s98zu8h9IOX >									
270 	//        <  u =="0.000000000000000001" : ] 000000353015357.315876000000000000 ; 000000367266911.247305000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000021AA8A023067A3 >									
272 	//     < RUSS_PFXXVII_I_metadata_line_25_____ACRYLATE_20211101 >									
273 	//        < NpDw4Q030Ou7ntzKHgGqNx9B2F163nK8JVjJJRwf99C8M58gzsNp2HlcLoiGRqQ7 >									
274 	//        <  u =="0.000000000000000001" : ] 000000367266911.247305000000000000 ; 000000380464462.375954000000000000 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000000000023067A32448AEE >									
276 	//     < RUSS_PFXXVII_I_metadata_line_26_____BIAXPLEN_20211101 >									
277 	//        < nhSJmS7PfLRoY0rMKtQSkIW7fR7w3C0G4fTR2kyMI17fgU664741Lf10Lj1inpTk >									
278 	//        <  u =="0.000000000000000001" : ] 000000380464462.375954000000000000 ; 000000393999685.391001000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000002448AEE2593221 >									
280 	//     < RUSS_PFXXVII_I_metadata_line_27_____PORTENERGO_20211101 >									
281 	//        < xi3Fet5k4lh2cVTw3yAq2U4vZ2DfQCjuX1Ce2h6r1E4rQtrU9JwcV2WYmnmxbj93 >									
282 	//        <  u =="0.000000000000000001" : ] 000000393999685.391001000000000000 ; 000000407290538.706300000000000000 ] >									
283 	//        < 0x00000000000000000000000000000000000000000000000000259322126D79DE >									
284 	//     < RUSS_PFXXVII_I_metadata_line_28_____POLIEF_20211101 >									
285 	//        < 8hEu9bC497cjY2T5UXa4dZ51106et9mj8Y1Q5AdK4Gt6MpE1nbciq26adc540UsC >									
286 	//        <  u =="0.000000000000000001" : ] 000000407290538.706300000000000000 ; 000000422591035.734203000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000026D79DE284D2A0 >									
288 	//     < RUSS_PFXXVII_I_metadata_line_29_____RUSPAV_20211101 >									
289 	//        < V1bg1419r7UV81QPICTY6xheF3ms8j9KphPWeFD26tCEMk9xj4rr64vIEWf0qyr1 >									
290 	//        <  u =="0.000000000000000001" : ] 000000422591035.734203000000000000 ; 000000435898143.922659000000000000 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000000000284D2A029920B6 >									
292 	//     < RUSS_PFXXVII_I_metadata_line_30_____NEFTEKHIMIA_20211101 >									
293 	//        < SbY27RP9juS9qq1q3ALurGFAq11wDEzx2GK40UI21V6XVA9KaaVmC38aID2J6ifC >									
294 	//        <  u =="0.000000000000000001" : ] 000000435898143.922659000000000000 ; 000000452643994.759795000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000029920B62B2AE0F >									
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
338 	//     < RUSS_PFXXVII_I_metadata_line_31_____OTECHESTVENNYE_POLIMERY_20211101 >									
339 	//        < a10ezn304TBz6dWV5k7FywiINzD4k12KIEyS3U52xljuQsJIOPPE6Ll1MN44587Y >									
340 	//        <  u =="0.000000000000000001" : ] 000000452643994.759795000000000000 ; 000000466705109.205646000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000002B2AE0F2C822AF >									
342 	//     < RUSS_PFXXVII_I_metadata_line_32_____SIBUR_TRANS_20211101 >									
343 	//        < 4N52Hblpe55me8WBZ2b9f96HS8TZXCCk1q9110Y6meqnAr0D1wUw6gFema218JRK >									
344 	//        <  u =="0.000000000000000001" : ] 000000466705109.205646000000000000 ; 000000480031086.142136000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000002C822AF2DC7825 >									
346 	//     < RUSS_PFXXVII_I_metadata_line_33_____TOGLIATTIKAUCHUK_20211101 >									
347 	//        < tCKxc4x2GqYDP85v6OG48Nx46p5NscO42kz1jJnRgcFlTly7iNqGO2WEBiS1kc1p >									
348 	//        <  u =="0.000000000000000001" : ] 000000480031086.142136000000000000 ; 000000496617277.446981000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000002DC78252F5C720 >									
350 	//     < RUSS_PFXXVII_I_metadata_line_34_____NPP_NEFTEKHIMIYA_OOO_20211101 >									
351 	//        < c085E0tH627KlFgc5b5Ap6u1MW9FNIl3qYaGG4wPg9TX8u0cT3QbXLH2YRfl42Fn >									
352 	//        <  u =="0.000000000000000001" : ] 000000496617277.446981000000000000 ; 000000509660581.882011000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000002F5C720309AE2A >									
354 	//     < RUSS_PFXXVII_I_metadata_line_35_____SIBUR_KHIMPROM_20211101 >									
355 	//        < 32yPwNFx0HVi0h89WU4t950IYm522Pz98lL335C9fmobhp77QsGolH39wOg5Fp8D >									
356 	//        <  u =="0.000000000000000001" : ] 000000509660581.882011000000000000 ; 000000525970778.839256000000000000 ] >									
357 	//        < 0x00000000000000000000000000000000000000000000000000309AE2A3229156 >									
358 	//     < RUSS_PFXXVII_I_metadata_line_36_____SIBUR_VOLZHSKY_20211101 >									
359 	//        < 5Lc953OKuSPK6p62JD80EqNYLY3v20zNLqGcVTxCZ0Qt8Do61H0TMgDLxVl5IJa6 >									
360 	//        <  u =="0.000000000000000001" : ] 000000525970778.839256000000000000 ; 000000542918459.250042000000000000 ] >									
361 	//        < 0x00000000000000000000000000000000000000000000000000322915633C6D86 >									
362 	//     < RUSS_PFXXVII_I_metadata_line_37_____VORONEZHSINTEZKAUCHUK_20211101 >									
363 	//        < jgK5nKNS0YzsxA8oO5l5sK3EZq27d4Zp8vr30Fb9hpH6j5v5rD23WSF7I72XZEeZ >									
364 	//        <  u =="0.000000000000000001" : ] 000000542918459.250042000000000000 ; 000000556004765.884488000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000033C6D86350655D >									
366 	//     < RUSS_PFXXVII_I_metadata_line_38_____INFO_TECH_SERVICE_CO_20211101 >									
367 	//        < Kk8g4f1mtZ2iX3IHssA8R3I832wKp1ZAwPMC6n83NNWwORSO3URIi3Rk90cGgPnP >									
368 	//        <  u =="0.000000000000000001" : ] 000000556004765.884488000000000000 ; 000000571446217.767880000000000000 ] >									
369 	//        < 0x00000000000000000000000000000000000000000000000000350655D367F52E >									
370 	//     < RUSS_PFXXVII_I_metadata_line_39_____LNG_NOVAENGINEERING_20211101 >									
371 	//        < SfQ4z5s6gnk5sxIruYSZ9nOI66j79u708DE220UPmdpJe7RF22Gt5lJ3QN2kIY0C >									
372 	//        <  u =="0.000000000000000001" : ] 000000571446217.767880000000000000 ; 000000586346398.609783000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000367F52E37EB190 >									
374 	//     < RUSS_PFXXVII_I_metadata_line_40_____SIBGAZPOLIMER_20211101 >									
375 	//        < 2uzeoPUdX26oi0RNqbs5HQt4P7v6y3e99vQc3K5D5YGWg8KdT6YS9Tu6AASW33Fj >									
376 	//        <  u =="0.000000000000000001" : ] 000000586346398.609783000000000000 ; 000000599305625.295470000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000037EB19039277C3 >									
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