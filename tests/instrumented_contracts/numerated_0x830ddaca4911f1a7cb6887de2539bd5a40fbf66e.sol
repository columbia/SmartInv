1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXXVII_II_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXXVII_II_883		"	;
8 		string	public		symbol =	"	RUSS_PFXXVII_II_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		807837516650864000000000000					;	
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
92 	//     < RUSS_PFXXVII_II_metadata_line_1_____SIBUR_20231101 >									
93 	//        < 9v49V0SnhzcB57DSnlrWiMeMK0Ve1D662e9No6T43anNc66nCKZgwdPSDoyU1HgN >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000019786508.253109800000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000001E311B >									
96 	//     < RUSS_PFXXVII_II_metadata_line_2_____SIBURTYUMENGAZ_20231101 >									
97 	//        < 7MDXcD6Uwthyf0NMh7907r16kXgTDtT476Q28J965std9xx76926b29F122N8bMD >									
98 	//        <  u =="0.000000000000000001" : ] 000000019786508.253109800000000000 ; 000000035925097.346869500000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000001E311B36D13E >									
100 	//     < RUSS_PFXXVII_II_metadata_line_3_____VOLGOPROMGAZ_GROUP_20231101 >									
101 	//        < iS4ALDQhB2yAer2Ok8d7dKh0hj0807n77cr3foN9SYhm9aTl382ICaJWQ7m3lGVO >									
102 	//        <  u =="0.000000000000000001" : ] 000000035925097.346869500000000000 ; 000000052797858.948898200000000000 ] >									
103 	//        < 0x000000000000000000000000000000000000000000000000000036D13E50902A >									
104 	//     < RUSS_PFXXVII_II_metadata_line_4_____KSTOVO_20231101 >									
105 	//        < zwl4l4RmXH2Us0c4F2ReMk22gStxu5bo5HqcIh90vhnsY7IpI5h3e4Yc2Bwvp9Qn >									
106 	//        <  u =="0.000000000000000001" : ] 000000052797858.948898200000000000 ; 000000077250728.222993200000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000050902A75E011 >									
108 	//     < RUSS_PFXXVII_II_metadata_line_5_____SIBUR_MOTORS_20231101 >									
109 	//        < 7C25QkldZRP3b61qX79Cg16mVBH7x7c71ye0yWdb18B02U4d3bwBRgHI435G2l9I >									
110 	//        <  u =="0.000000000000000001" : ] 000000077250728.222993200000000000 ; 000000100947604.380362000000000000 ] >									
111 	//        < 0x000000000000000000000000000000000000000000000000000075E0119A08A8 >									
112 	//     < RUSS_PFXXVII_II_metadata_line_6_____SIBUR_FINANCE_20231101 >									
113 	//        < 2PzWn2nnqoBjB4oUEM30D63I275B532nxwl9kc7MR9991RV33TB4Dk7kzn00R2GY >									
114 	//        <  u =="0.000000000000000001" : ] 000000100947604.380362000000000000 ; 000000119007217.178692000000000000 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000000000009A08A8B59732 >									
116 	//     < RUSS_PFXXVII_II_metadata_line_7_____AKRILAT_20231101 >									
117 	//        < a8HC4fhLW90j3gKhT8If4qKmK770WGuAJ29ZC0j17wu9Ekb0RqI9t1Wq86AXUdDQ >									
118 	//        <  u =="0.000000000000000001" : ] 000000119007217.178692000000000000 ; 000000142920556.790933000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000B59732DA1458 >									
120 	//     < RUSS_PFXXVII_II_metadata_line_8_____SINOPEC_RUBBER_20231101 >									
121 	//        < 647T25nQuVRXG8mApJFRD2W83XXYVtIHAa1i3tS0pm4715T2xD2Q5ZDSWrUZ021U >									
122 	//        <  u =="0.000000000000000001" : ] 000000142920556.790933000000000000 ; 000000165483156.016621000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000DA1458FC81DC >									
124 	//     < RUSS_PFXXVII_II_metadata_line_9_____TOBOLSK_NEFTEKHIM_20231101 >									
125 	//        < S8u84bwW76w97X5oX3wjukg8J6P9ooe7gk0Hqm26kz93YyKk3cZ9Fxa0JizK2sl7 >									
126 	//        <  u =="0.000000000000000001" : ] 000000165483156.016621000000000000 ; 000000184490168.258179000000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000000FC81DC1198279 >									
128 	//     < RUSS_PFXXVII_II_metadata_line_10_____SIBUR_PETF_20231101 >									
129 	//        < 66B46o3W352h62GidFLVJ16F0mo9YZ64fwej4x18r4uYDxuUcnJ9Mx26Uj2iQbm0 >									
130 	//        <  u =="0.000000000000000001" : ] 000000184490168.258179000000000000 ; 000000205561260.340694000000000000 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000000001198279139A95E >									
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
174 	//     < RUSS_PFXXVII_II_metadata_line_11_____MURAVLENKOVSKY_GAS_PROCESS_PLANT_20231101 >									
175 	//        < xp2V7ZMmJ8sQNOIT8y7vzhorBw6ti63dZ35372Cifn112yv8D7oQY38lp287I7MH >									
176 	//        <  u =="0.000000000000000001" : ] 000000205561260.340694000000000000 ; 000000230100655.393408000000000000 ] >									
177 	//        < 0x00000000000000000000000000000000000000000000000000139A95E15F1B12 >									
178 	//     < RUSS_PFXXVII_II_metadata_line_12_____OOO_IT_SERVICE_20231101 >									
179 	//        < Bkn94G1OJeUyg6zcOla96zCSdp8GQJ757l5JqK9bMPxP8PHz8loEOW6evlT93lSr >									
180 	//        <  u =="0.000000000000000001" : ] 000000230100655.393408000000000000 ; 000000245830024.059699000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000015F1B121771B5A >									
182 	//     < RUSS_PFXXVII_II_metadata_line_13_____ZAO_MIRACLE_20231101 >									
183 	//        < hOA7hRIekqwXUY9jlU5E4RAmu4vOInPrZ74CNfNM6EeC23bb7Yt7YIMNU3M0NjoP >									
184 	//        <  u =="0.000000000000000001" : ] 000000245830024.059699000000000000 ; 000000267497256.947116000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001771B5A1982B1E >									
186 	//     < RUSS_PFXXVII_II_metadata_line_14_____NOVATEK_POLYMER_20231101 >									
187 	//        < 04GQltwSrFMl9ID27vkVfvH8k55dX4VjFIFHRD118u7xqxpcm019MGwS09p4mg1m >									
188 	//        <  u =="0.000000000000000001" : ] 000000267497256.947116000000000000 ; 000000291828972.827602000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000001982B1E1BD4BB1 >									
190 	//     < RUSS_PFXXVII_II_metadata_line_15_____SOUTHWEST_GAS_PIPELINES_20231101 >									
191 	//        < Lk6e5o5M366dH26WNyWA30L84qQ7A4h8yuu7NtOesfH0KZRq15cdHGDXoCfssE69 >									
192 	//        <  u =="0.000000000000000001" : ] 000000291828972.827602000000000000 ; 000000315406246.125984000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000001BD4BB11E14591 >									
194 	//     < RUSS_PFXXVII_II_metadata_line_16_____YUGRAGAZPERERABOTKA_20231101 >									
195 	//        < 2eITbr1E0ZTkB5ll9Wi7CAASMaIImOdAD4uh5g9qxd6813QHJAulTN94esmjRqEI >									
196 	//        <  u =="0.000000000000000001" : ] 000000315406246.125984000000000000 ; 000000338075350.025492000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000001E14591203DCAF >									
198 	//     < RUSS_PFXXVII_II_metadata_line_17_____TOMSKNEFTEKHIM_20231101 >									
199 	//        < B3BLkg376D2151t0XI63gG7JvudtKG1lptnf9iA80KUW4LebggVeOJ43o07bj1c7 >									
200 	//        <  u =="0.000000000000000001" : ] 000000338075350.025492000000000000 ; 000000357347870.301198000000000000 ] >									
201 	//        < 0x00000000000000000000000000000000000000000000000000203DCAF2214503 >									
202 	//     < RUSS_PFXXVII_II_metadata_line_18_____BALTIC_LNG_20231101 >									
203 	//        < PmN91EDGYgd0E3jBwWQ1MwooPDyROY6A68zXW36EGoQaB0h6i4soS7M42NMn203N >									
204 	//        <  u =="0.000000000000000001" : ] 000000357347870.301198000000000000 ; 000000376132450.568840000000000000 ] >									
205 	//        < 0x00000000000000000000000000000000000000000000000000221450323DEEBD >									
206 	//     < RUSS_PFXXVII_II_metadata_line_19_____SIBUR_INT_GMBH_20231101 >									
207 	//        < 4ups4LOYd3msI49uZPg5l02yUrh09g0oYeIf1t19zIdgKfe2p0cFaQyJbJ67cHTP >									
208 	//        <  u =="0.000000000000000001" : ] 000000376132450.568840000000000000 ; 000000396293995.290200000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000000023DEEBD25CB258 >									
210 	//     < RUSS_PFXXVII_II_metadata_line_20_____TOBOL_SK_POLIMER_20231101 >									
211 	//        < 0Xkrk9UYBLL84Y4VNzKJPJRdBba2I35pTQsihmq7e0vw4kTtA1F3j5g7Uk0F2cA9 >									
212 	//        <  u =="0.000000000000000001" : ] 000000396293995.290200000000000000 ; 000000413273552.755682000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000025CB2582769AFB >									
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
256 	//     < RUSS_PFXXVII_II_metadata_line_21_____SIBUR_SCIENT_RD_INSTITUTE_GAS_PROCESS_20231101 >									
257 	//        < Pu0IsEFj75wn1a2QpzGgIT0eMZ3l8hX6U1495g089HQiAwLUoo6MdKNxmWnzn5Rb >									
258 	//        <  u =="0.000000000000000001" : ] 000000413273552.755682000000000000 ; 000000429399285.169023000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000002769AFB28F3619 >									
260 	//     < RUSS_PFXXVII_II_metadata_line_22_____ZAPSIBNEFTEKHIM_20231101 >									
261 	//        < pMR6TYAe94xL8tS2rVRHKgXR395LGb4C8i07ahVkUFv3GfquPVx30PWv8xW58h24 >									
262 	//        <  u =="0.000000000000000001" : ] 000000429399285.169023000000000000 ; 000000446500132.395753000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000028F36192A94E1D >									
264 	//     < RUSS_PFXXVII_II_metadata_line_23_____RUSVINYL_20231101 >									
265 	//        < dY4VK4Rq43vJ3rEG2duwdpi7Q1qi5RjY8fA6uP385t7X7y7W64kZj2q1sL7mqYMN >									
266 	//        <  u =="0.000000000000000001" : ] 000000446500132.395753000000000000 ; 000000470534721.460244000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000002A94E1D2CDFAA0 >									
268 	//     < RUSS_PFXXVII_II_metadata_line_24_____SIBUR_SECURITIES_LIMITED_20231101 >									
269 	//        < irXz8cN6JeSNR29aDS7jTXMSO2KwS6HXNJ9457k63LuSi8LXnuvD6BYQ1063Lpt0 >									
270 	//        <  u =="0.000000000000000001" : ] 000000470534721.460244000000000000 ; 000000489395856.360040000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000002CDFAA02EAC242 >									
272 	//     < RUSS_PFXXVII_II_metadata_line_25_____ACRYLATE_20231101 >									
273 	//        < Jq536EOXTufGUvOv74J565WUwldgP7O4590D7Zz1QlN3y4k9nE1hG4UnVvpx51aG >									
274 	//        <  u =="0.000000000000000001" : ] 000000489395856.360040000000000000 ; 000000509505844.776635000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002EAC24230971B8 >									
276 	//     < RUSS_PFXXVII_II_metadata_line_26_____BIAXPLEN_20231101 >									
277 	//        < Q8tOmsB4O87Eq4x177EKGApsXi6f4T88w7A7u58N14zRT60v83C7QUok9o1Rxo8j >									
278 	//        <  u =="0.000000000000000001" : ] 000000509505844.776635000000000000 ; 000000531117074.236206000000000000 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000000000030971B832A6B9B >									
280 	//     < RUSS_PFXXVII_II_metadata_line_27_____PORTENERGO_20231101 >									
281 	//        < Om0e096P6S182G02aa246V3m7jYQ5EerqaTAPJc0LeZjkJAtr3n2QiKt1g7I4ln0 >									
282 	//        <  u =="0.000000000000000001" : ] 000000531117074.236206000000000000 ; 000000555053793.050291000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000032A6B9B34EF1E3 >									
284 	//     < RUSS_PFXXVII_II_metadata_line_28_____POLIEF_20231101 >									
285 	//        < o26ePQDTC4114opQdV5O7zVRBleirz23r6SZ13t6gwj6t3D4IV9qDk19JLFBfMsL >									
286 	//        <  u =="0.000000000000000001" : ] 000000555053793.050291000000000000 ; 000000579324941.325985000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000034EF1E3373FACE >									
288 	//     < RUSS_PFXXVII_II_metadata_line_29_____RUSPAV_20231101 >									
289 	//        < 575xZBiN2h08M86j9FqffGSZWP60WE036C5Z1962Wr1Hw60snor51Fuggai2JDq6 >									
290 	//        <  u =="0.000000000000000001" : ] 000000579324941.325985000000000000 ; 000000604190311.404956000000000000 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000000000373FACE399EBD7 >									
292 	//     < RUSS_PFXXVII_II_metadata_line_30_____NEFTEKHIMIA_20231101 >									
293 	//        < gmYKJ3lxoVk3Ji11v858FfYqoNEozQoz9SNMF8S33n2IzTxK1FbH9Dg6WInWJO6c >									
294 	//        <  u =="0.000000000000000001" : ] 000000604190311.404956000000000000 ; 000000628222306.937613000000000000 ] >									
295 	//        < 0x00000000000000000000000000000000000000000000000000399EBD73BE9757 >									
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
338 	//     < RUSS_PFXXVII_II_metadata_line_31_____OTECHESTVENNYE_POLIMERY_20231101 >									
339 	//        < 2502vR782WEuILeSUBzc7muhzjDlrf2pHoZ8YvINravUu72G9J4cX5Dk2Wy5M5rk >									
340 	//        <  u =="0.000000000000000001" : ] 000000628222306.937613000000000000 ; 000000644215795.234901000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000003BE97573D6FECC >									
342 	//     < RUSS_PFXXVII_II_metadata_line_32_____SIBUR_TRANS_20231101 >									
343 	//        < fYdCK6lyNUBi9jXP2Dpj41s9IzCWCRQnrkLLVuzpXzxG65V1XQP19RYs65L4c6uY >									
344 	//        <  u =="0.000000000000000001" : ] 000000644215795.234901000000000000 ; 000000663382370.306951000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000003D6FECC3F43DBD >									
346 	//     < RUSS_PFXXVII_II_metadata_line_33_____TOGLIATTIKAUCHUK_20231101 >									
347 	//        < 1K2GO73iwa7Km7258s3y9y5TWtAFy9Ff4nWKYK8rk6IZO5NNCxT4Z617D3JU5v89 >									
348 	//        <  u =="0.000000000000000001" : ] 000000663382370.306951000000000000 ; 000000684481999.911044000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000003F43DBD4146FC8 >									
350 	//     < RUSS_PFXXVII_II_metadata_line_34_____NPP_NEFTEKHIMIYA_OOO_20231101 >									
351 	//        < SL6rJPRp2l9N335yRbZsg2W47ogIV9730xhx6mrxgqX9IW92u143v2bHirxL0uT4 >									
352 	//        <  u =="0.000000000000000001" : ] 000000684481999.911044000000000000 ; 000000705569993.366206000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000004146FC84349D47 >									
354 	//     < RUSS_PFXXVII_II_metadata_line_35_____SIBUR_KHIMPROM_20231101 >									
355 	//        < bc3q4SIn44N28iWL8HQ4Fke1U2S03Kl38H92nQiLaJ31Ba1t7juY321KZG5lJ1N2 >									
356 	//        <  u =="0.000000000000000001" : ] 000000705569993.366206000000000000 ; 000000723739802.067457000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000004349D4745056DC >									
358 	//     < RUSS_PFXXVII_II_metadata_line_36_____SIBUR_VOLZHSKY_20231101 >									
359 	//        < 4Ha3eG28ZnlhT8T9uoXAefJwblW1k2v6cVgR2F1p7VMHnZAx5a9V1mybNz1I8qF6 >									
360 	//        <  u =="0.000000000000000001" : ] 000000723739802.067457000000000000 ; 000000740329220.202653000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000045056DC469A71A >									
362 	//     < RUSS_PFXXVII_II_metadata_line_37_____VORONEZHSINTEZKAUCHUK_20231101 >									
363 	//        < m2z4iJq5x4MZ2fFp3ytR00ae21580Azq31bcJ4x5i08oTwWJTD8nwtFEFC3x9nAl >									
364 	//        <  u =="0.000000000000000001" : ] 000000740329220.202653000000000000 ; 000000759744228.853584000000000000 ] >									
365 	//        < 0x00000000000000000000000000000000000000000000000000469A71A4874717 >									
366 	//     < RUSS_PFXXVII_II_metadata_line_38_____INFO_TECH_SERVICE_CO_20231101 >									
367 	//        < dL212iA8oNCM8mD91U3R1H52T44h0z1T1Ag8LILEqJaE092tI1qF4x114bJEsi71 >									
368 	//        <  u =="0.000000000000000001" : ] 000000759744228.853584000000000000 ; 000000775692093.113185000000000000 ] >									
369 	//        < 0x00000000000000000000000000000000000000000000000000487471749F9CB9 >									
370 	//     < RUSS_PFXXVII_II_metadata_line_39_____LNG_NOVAENGINEERING_20231101 >									
371 	//        < 4FRw80BwnNk7YOSbxzr0qxa379pgr1rYS6d7pYe9p3Z5Tjd4wvy5c52ef6QfEbHK >									
372 	//        <  u =="0.000000000000000001" : ] 000000775692093.113185000000000000 ; 000000792188799.138194000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000049F9CB94B8C8C0 >									
374 	//     < RUSS_PFXXVII_II_metadata_line_40_____SIBGAZPOLIMER_20231101 >									
375 	//        < YhHb77I6ZQg584M82jZSnt4wYH19fon9j1sFw9c6RY3asW6IGvf09bS0UU8dN35J >									
376 	//        <  u =="0.000000000000000001" : ] 000000792188799.138194000000000000 ; 000000807837516.650864000000000000 ] >									
377 	//        < 0x000000000000000000000000000000000000000000000000004B8C8C04D0A988 >									
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