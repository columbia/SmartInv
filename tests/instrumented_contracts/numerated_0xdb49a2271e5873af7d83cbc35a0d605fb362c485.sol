1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXXXV_II_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXXXV_II_883		"	;
8 		string	public		symbol =	"	RUSS_PFXXXV_II_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		766375613856468000000000000					;	
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
92 	//     < RUSS_PFXXXV_II_metadata_line_1_____ALROSA_20231101 >									
93 	//        < eAxY7VDnRanh7MLdl7YauJQ84V3MS01dicCoyXTEM8Cis93oRmFJL9AD8cRpZTL7 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000017577492.048677200000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000001AD235 >									
96 	//     < RUSS_PFXXXV_II_metadata_line_2_____ARCOS_HK_LIMITED_20231101 >									
97 	//        < a79iMu0t3MWM1xtXe82w735JtYWw2ZCqN27D2c4DudtW8WvqC13eVhD139XUKQ1T >									
98 	//        <  u =="0.000000000000000001" : ] 000000017577492.048677200000000000 ; 000000034014159.826592300000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000001AD23533E6C8 >									
100 	//     < RUSS_PFXXXV_II_metadata_line_3_____ARCOS_ORG_20231101 >									
101 	//        < r23War76R3ppF0619uC3Hgua5Y431nT667wZ4yhmyu1rv9ulkg0GseGqK89eeiJL >									
102 	//        <  u =="0.000000000000000001" : ] 000000034014159.826592300000000000 ; 000000051846273.028170500000000000 ] >									
103 	//        < 0x000000000000000000000000000000000000000000000000000033E6C84F1C73 >									
104 	//     < RUSS_PFXXXV_II_metadata_line_4_____SUNLAND_HOLDINGS_SA_20231101 >									
105 	//        < FidYoi38X3X3A1L7eRqA0P12eLBtJYiF5CpXc3V4wlz5hZDallG5kP9i81SE086Z >									
106 	//        <  u =="0.000000000000000001" : ] 000000051846273.028170500000000000 ; 000000069506659.208994300000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000004F1C736A0F0A >									
108 	//     < RUSS_PFXXXV_II_metadata_line_5_____ARCOS_BELGIUM_NV_20231101 >									
109 	//        < 64w6CgJEuq3HoyYA48KCbQ39In8Iodn1OpP8D87ht24r38FZNiv0amzWmycV208g >									
110 	//        <  u =="0.000000000000000001" : ] 000000069506659.208994300000000000 ; 000000087162159.836151700000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000006A0F0A84FFB8 >									
112 	//     < RUSS_PFXXXV_II_metadata_line_6_____MEDIAGROUP_SITIM_20231101 >									
113 	//        < WcC0vbxMDq8wQ1SZX32esOG6XhrI4dOjZZXqVCk65T6wxKfm5dQGPq28naHn1M8h >									
114 	//        <  u =="0.000000000000000001" : ] 000000087162159.836151700000000000 ; 000000106705561.152175000000000000 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000000000084FFB8A2D1DC >									
116 	//     < RUSS_PFXXXV_II_metadata_line_7_____ALROSA_FINANCE_BV_20231101 >									
117 	//        < egw15KdR8T3TZoxI6uc042tcuUhpvY7V0pspWFPQNV42p5tN0F32o9aW976Os588 >									
118 	//        <  u =="0.000000000000000001" : ] 000000106705561.152175000000000000 ; 000000123125984.596213000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000A2D1DCBBE016 >									
120 	//     < RUSS_PFXXXV_II_metadata_line_8_____SHIPPING_CO_ALROSA_LENA_20231101 >									
121 	//        < RTi2Q4ZR8woo2OFQ4aS8U892dt56o035oBhbVHyZl9Xn9RP0650079l2Ys38KZiI >									
122 	//        <  u =="0.000000000000000001" : ] 000000123125984.596213000000000000 ; 000000145823236.722301000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000BBE016DE8234 >									
124 	//     < RUSS_PFXXXV_II_metadata_line_9_____LENA_ORG_20231101 >									
125 	//        < 0H1qJ8H1W07tfAetCfz72fTvbjgM2MTEn6067DZUbzBsbjUq9JK0OUM23P9ku0h0 >									
126 	//        <  u =="0.000000000000000001" : ] 000000145823236.722301000000000000 ; 000000161419404.654487000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000000DE8234F64E74 >									
128 	//     < RUSS_PFXXXV_II_metadata_line_10_____ALROSA_AFRICA_20231101 >									
129 	//        < MeBMAd5wA3m3y6YAhDV765M8K8gU4w12QZ7M7WDu32T6wsKgY7KymyY2P4Np2gRz >									
130 	//        <  u =="0.000000000000000001" : ] 000000161419404.654487000000000000 ; 000000182988466.682967000000000000 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000000000F64E7411737DF >									
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
174 	//     < RUSS_PFXXXV_II_metadata_line_11_____INVESTMENT_GROUP_ALROSA_20231101 >									
175 	//        < H24e3whKRhHDdmoaL6aj8frCVCPrfm94jUT3s43008MM6XC082263ud08d0C7GO0 >									
176 	//        <  u =="0.000000000000000001" : ] 000000182988466.682967000000000000 ; 000000201402464.850919000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000011737DF13350D6 >									
178 	//     < RUSS_PFXXXV_II_metadata_line_12_____INVESTITSIONNAYA_GRUPPA_ALROSA_20231101 >									
179 	//        < G20OZtTaz4lMG1dl77Z8fl5Hmyh0s84fJJdE23M5dOjsD68wI3mVJynMQ5XIm2G1 >									
180 	//        <  u =="0.000000000000000001" : ] 000000201402464.850919000000000000 ; 000000222266963.363670000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000013350D61532708 >									
182 	//     < RUSS_PFXXXV_II_metadata_line_13_____VILYUISKAYA_GES_3_20231101 >									
183 	//        < q2e3G1sYrkSZaU5lB7yZd2erbwNpOG3Er1w0090tsvf5wZ1q4KY8kRIZpU2R5XuO >									
184 	//        <  u =="0.000000000000000001" : ] 000000222266963.363670000000000000 ; 000000244311688.837549000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001532708174CA41 >									
186 	//     < RUSS_PFXXXV_II_metadata_line_14_____NPP_BUREVESTNIK_20231101 >									
187 	//        < srH0SDn44IWi69C1Y1C8M02mxyHPVOY0rHCd5WIdgMT6701o37oicqP10a0SRyg3 >									
188 	//        <  u =="0.000000000000000001" : ] 000000244311688.837549000000000000 ; 000000266726497.752847000000000000 ] >									
189 	//        < 0x00000000000000000000000000000000000000000000000000174CA41196FE0A >									
190 	//     < RUSS_PFXXXV_II_metadata_line_15_____NARNAUL_KRISTALL_FACTORY_20231101 >									
191 	//        < H5My4joEzAfc5dv4CC0Hs6wfgGqMrX1eV3kg3uW1EWkZVh8WCqsxv6J8K9A1wgPh >									
192 	//        <  u =="0.000000000000000001" : ] 000000266726497.752847000000000000 ; 000000283252286.455337000000000000 ] >									
193 	//        < 0x00000000000000000000000000000000000000000000000000196FE0A1B0356D >									
194 	//     < RUSS_PFXXXV_II_metadata_line_16_____NARNAUL_ORG_20231101 >									
195 	//        < kbCdQd8Z5q2uk7F69AZFx4G28MBvtg9a7x23Ec46P0tfs9DNHWl0z9BYZ4vUI433 >									
196 	//        <  u =="0.000000000000000001" : ] 000000283252286.455337000000000000 ; 000000300605641.416064000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000001B0356D1CAB014 >									
198 	//     < RUSS_PFXXXV_II_metadata_line_17_____HIDROELECTRICA_CHICAPA_SARL_20231101 >									
199 	//        < KtnN91hl294DOkr7fmLTJZxHKTK6cb2j6IkJwYbrdNtkfhowjS87liSgeQfBWR7e >									
200 	//        <  u =="0.000000000000000001" : ] 000000300605641.416064000000000000 ; 000000316511639.203208000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000001CAB0141E2F55C >									
202 	//     < RUSS_PFXXXV_II_metadata_line_18_____CHICAPA_ORG_20231101 >									
203 	//        < RVI2w4YJO128tBnA7vx485nlRaGuwGTIXt84T2ggu4GXLKcW60IAz5YMT41j480W >									
204 	//        <  u =="0.000000000000000001" : ] 000000316511639.203208000000000000 ; 000000333214782.285722000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000001E2F55C1FC7206 >									
206 	//     < RUSS_PFXXXV_II_metadata_line_19_____ALROSA_VGS_LLC_20231101 >									
207 	//        < I05K1OMr4Km69jM1V6s50dd4qfp8p50T4IRvg3mfWLwe44KV4kxz14R2264LhWmM >									
208 	//        <  u =="0.000000000000000001" : ] 000000333214782.285722000000000000 ; 000000354359445.025346000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000001FC720621CB5A9 >									
210 	//     < RUSS_PFXXXV_II_metadata_line_20_____ARCOS_DIAMOND_ISRAEL_20231101 >									
211 	//        < yx8wKQKyOCZ85558fpj0xw36m0ZbXPt3CSZR8OVJ1OkWw7XzVRVIctgv2O5x036X >									
212 	//        <  u =="0.000000000000000001" : ] 000000354359445.025346000000000000 ; 000000373370522.933952000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000021CB5A9239B7DC >									
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
256 	//     < RUSS_PFXXXV_II_metadata_line_21_____ALMAZY_ANABARA_20231101 >									
257 	//        < F4HNF516r23Nap7U4tVX9m0g20lT7ZV9p27Bzg0eTawY3hWaq29h4GhdSUI36pZV >									
258 	//        <  u =="0.000000000000000001" : ] 000000373370522.933952000000000000 ; 000000395041133.527796000000000000 ] >									
259 	//        < 0x00000000000000000000000000000000000000000000000000239B7DC25AC8F1 >									
260 	//     < RUSS_PFXXXV_II_metadata_line_22_____ALMAZY_ORG_20231101 >									
261 	//        < SCmTAejumFVV09I074GJnSS8RmLD1H5xA1chP3m7L5e1bcV43wX89Ej398j6D9yr >									
262 	//        <  u =="0.000000000000000001" : ] 000000395041133.527796000000000000 ; 000000412636894.251267000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000025AC8F1275A249 >									
264 	//     < RUSS_PFXXXV_II_metadata_line_23_____ALROSA_ORG_20231101 >									
265 	//        < eoEOurAaYfQU2T6XJq8aQ3Q938YBJN8CM9FxLxhkvEHgujkX5j7IrQ33Ne2Oz2ip >									
266 	//        <  u =="0.000000000000000001" : ] 000000412636894.251267000000000000 ; 000000431799907.075078000000000000 ] >									
267 	//        < 0x00000000000000000000000000000000000000000000000000275A249292DFD7 >									
268 	//     < RUSS_PFXXXV_II_metadata_line_24_____SEVERALMAZ_20231101 >									
269 	//        < 0SRhSXe2oxn7Rj0DrFTE0ZIQ4nl50wP4yBI60z8Qra0761Ivd3ExQL0T7X21c8Jk >									
270 	//        <  u =="0.000000000000000001" : ] 000000431799907.075078000000000000 ; 000000451297828.902414000000000000 ] >									
271 	//        < 0x00000000000000000000000000000000000000000000000000292DFD72B0A037 >									
272 	//     < RUSS_PFXXXV_II_metadata_line_25_____ARCOS_USA_20231101 >									
273 	//        < fL9iicd4c78npu1yF1h8lL28xMt855wmK5loaNhP1vs8tvSsKSH8kBYmliWE8fLz >									
274 	//        <  u =="0.000000000000000001" : ] 000000451297828.902414000000000000 ; 000000473134535.801090000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002B0A0372D1F22E >									
276 	//     < RUSS_PFXXXV_II_metadata_line_26_____NYURBA_20231101 >									
277 	//        < XHkp8944x5kANLn3k8lPBOn8330H29fed4p0x92984YhP5A1LDu13IF7EP9OXPQ0 >									
278 	//        <  u =="0.000000000000000001" : ] 000000473134535.801090000000000000 ; 000000489641355.326801000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000002D1F22E2EB2228 >									
280 	//     < RUSS_PFXXXV_II_metadata_line_27_____NYURBA_ORG_20231101 >									
281 	//        < 67fLMgFQtH54UM7H1Hvt6Vs5rV7Z3stF750Gke35Gr6ke66s98aj0L0Y70PB6H3w >									
282 	//        <  u =="0.000000000000000001" : ] 000000489641355.326801000000000000 ; 000000505238439.394153000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000002EB2228302EEC4 >									
284 	//     < RUSS_PFXXXV_II_metadata_line_28_____EAST_DMCC_20231101 >									
285 	//        < hn8h4Nd65Ux03dXSD7Y2MmP5oP64p5Yt64U5L4Lnnj4tHA1cWjvmL136QP2Ka403 >									
286 	//        <  u =="0.000000000000000001" : ] 000000505238439.394153000000000000 ; 000000522899545.103503000000000000 ] >									
287 	//        < 0x00000000000000000000000000000000000000000000000000302EEC431DE1A3 >									
288 	//     < RUSS_PFXXXV_II_metadata_line_29_____ALROSA_FINANCE_SA_20231101 >									
289 	//        < B95mv630E8TS5FSnvriC7xvOefymi6A1ot2erf170WYfi0X67hpwj5Fuo04NfZ43 >									
290 	//        <  u =="0.000000000000000001" : ] 000000522899545.103503000000000000 ; 000000543345962.184284000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000031DE1A333D1484 >									
292 	//     < RUSS_PFXXXV_II_metadata_line_30_____ALROSA_OVERSEAS_SA_20231101 >									
293 	//        < 822ht6vv2ShH154ikAEkLpqO3HQq39c5fsBXm7N31iM0074a2dpuIeaBxGU6ugq3 >									
294 	//        <  u =="0.000000000000000001" : ] 000000543345962.184284000000000000 ; 000000564712787.362122000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000033D148435DAEEF >									
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
338 	//     < RUSS_PFXXXV_II_metadata_line_31_____ARCOS_EAST_DMCC_20231101 >									
339 	//        < b6huBkj8Mg12cRt9AMEqIacS3WLJD56q1kbHg66k65G1Xl05OLB7L091f94lSzb2 >									
340 	//        <  u =="0.000000000000000001" : ] 000000564712787.362122000000000000 ; 000000584234686.652163000000000000 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000000000035DAEEF37B78AD >									
342 	//     < RUSS_PFXXXV_II_metadata_line_32_____HIDROCHICAPA_SARL_20231101 >									
343 	//        < 4bFT7ox0U16na55q56cnj40BsXps07h9FaW1cD0ecyo16kmr5KyVhgA4276YbAF7 >									
344 	//        <  u =="0.000000000000000001" : ] 000000584234686.652163000000000000 ; 000000607184251.321032000000000000 ] >									
345 	//        < 0x0000000000000000000000000000000000000000000000000037B78AD39E7D59 >									
346 	//     < RUSS_PFXXXV_II_metadata_line_33_____ALROSA_GAZ_20231101 >									
347 	//        < 8uD0OGf2G52M9Rcq6De77I14rp4T38W0hKcD1a73S67u71eH8AHS0XI0lVW59a1z >									
348 	//        <  u =="0.000000000000000001" : ] 000000607184251.321032000000000000 ; 000000628346590.338270000000000000 ] >									
349 	//        < 0x0000000000000000000000000000000000000000000000000039E7D593BEC7E3 >									
350 	//     < RUSS_PFXXXV_II_metadata_line_34_____SUNLAND_TRADING_SA_20231101 >									
351 	//        < Tg05CbGZW93Y90WoVkut4buo5TF234x36zC25PYnm7s1ukXl47j6RRP3a8f99uRt >									
352 	//        <  u =="0.000000000000000001" : ] 000000628346590.338270000000000000 ; 000000646918581.275620000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000003BEC7E33DB1E92 >									
354 	//     < RUSS_PFXXXV_II_metadata_line_35_____ORYOL_ALROSA_20231101 >									
355 	//        < L968H8SOa10A38hfhD1EBe7X4p5RKT5Gn2jT9n3Fljh1Cp92IgzQ9k29UjL962XJ >									
356 	//        <  u =="0.000000000000000001" : ] 000000646918581.275620000000000000 ; 000000663379796.100532000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000003DB1E923F43CBC >									
358 	//     < RUSS_PFXXXV_II_metadata_line_36_____GOLUBAYA_VOLNA_HEALTH_RESORT_20231101 >									
359 	//        < OqJ87m6RX72i8f86Nq017jhmT4PKmOWEJZ77bUE0bib1Ko8hve78ocqv5Z789xSI >									
360 	//        <  u =="0.000000000000000001" : ] 000000663379796.100532000000000000 ; 000000680611728.576708000000000000 ] >									
361 	//        < 0x000000000000000000000000000000000000000000000000003F43CBC40E87F5 >									
362 	//     < RUSS_PFXXXV_II_metadata_line_37_____GOLUBAYA_ORG_20231101 >									
363 	//        < k9Ok7fV0MNkb9tN5uJ93xPa346vgPK4zTR2fR5i66GI7eb914mX88eUa4MN6IR5f >									
364 	//        <  u =="0.000000000000000001" : ] 000000680611728.576708000000000000 ; 000000705458862.643825000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000040E87F543471DE >									
366 	//     < RUSS_PFXXXV_II_metadata_line_38_____SEVERNAYA_GORNO_GEOLOGIC_KOM_TERRA_20231101 >									
367 	//        < EYuV9gEWsF15LP04tefkmkm9as1aSe549YAwF5d1Kep6zW9vO3x65qnYn35q2819 >									
368 	//        <  u =="0.000000000000000001" : ] 000000705458862.643825000000000000 ; 000000722868265.923666000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000043471DE44F026B >									
370 	//     < RUSS_PFXXXV_II_metadata_line_39_____SEVERNAYA_ORG_20231101 >									
371 	//        < Ged9s790OAVSF4Hh7qzZ1hvuHM27Q4sM522n44289RliEx172JU4kcP7PJN7Up86 >									
372 	//        <  u =="0.000000000000000001" : ] 000000722868265.923666000000000000 ; 000000746505996.576124000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000044F026B47313E8 >									
374 	//     < RUSS_PFXXXV_II_metadata_line_40_____ALROSA_NEVA_20231101 >									
375 	//        < SvUF6S1MTdec3P5yXU5nwi8BU2s1u3N7Q3zIt3G9YucwPEKkTzW9mD96CzvUQHxv >									
376 	//        <  u =="0.000000000000000001" : ] 000000746505996.576124000000000000 ; 000000766375613.856468000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000047313E84916579 >									
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