1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXIV_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXIV_I_883		"	;
8 		string	public		symbol =	"	RUSS_PFXIV_I_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		607958860458894000000000000					;	
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
92 	//     < RUSS_PFXIV_I_metadata_line_1_____NORIMET_LIMITED_20211101 >									
93 	//        < 08m1fFuWkq09CT0P1Ksfoy24ROI9Tf4Dmr7QON1CFXUaa8X849l2a9ECIG6EGg61 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000015327057.229263200000000000 ] >									
95 	//        < 0x0000000000000000000000000000000000000000000000000000000000176322 >									
96 	//     < RUSS_PFXIV_I_metadata_line_2_____NORNICKEL_AUSTRALIA_PTY_LIMITED_20211101 >									
97 	//        < GG2FBUXK1vs4HnoJV2d9b4KCsEKm0p1RqHsY5z44FwJnNYgadCtA4S5TYPhxN126 >									
98 	//        <  u =="0.000000000000000001" : ] 000000015327057.229263200000000000 ; 000000032526314.213444800000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000017632231A197 >									
100 	//     < RUSS_PFXIV_I_metadata_line_3_____NORILSKGAZPROM_20211101 >									
101 	//        < 9mg45rDJ83C0wjQj6J9rO9BYk3tl9SJcu7l6l3R26x6B699xRlX0pcryAt4v6eMV >									
102 	//        <  u =="0.000000000000000001" : ] 000000032526314.213444800000000000 ; 000000047204909.158397000000000000 ] >									
103 	//        < 0x000000000000000000000000000000000000000000000000000031A19748076B >									
104 	//     < RUSS_PFXIV_I_metadata_line_4_____NORILSK_NICKEL_USA_INC_20211101 >									
105 	//        < pFt33k71Id02dbO8N7y5RQVJ1pqFrRBw6qWw34m622E90Yhdn62WO8r8LvCV6BS1 >									
106 	//        <  u =="0.000000000000000001" : ] 000000047204909.158397000000000000 ; 000000063895147.313597000000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000048076B617F0B >									
108 	//     < RUSS_PFXIV_I_metadata_line_5_____DALRYMPLE_RESOURCES_PTY_LTD_20211101 >									
109 	//        < 4t2U0FepH0G2DeG261Afd5eIjkF03d7Uj9ZUCx6e2s1WMDoBHwsB4tIYzW27X0t8 >									
110 	//        <  u =="0.000000000000000001" : ] 000000063895147.313597000000000000 ; 000000078308375.417202400000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000617F0B777D36 >									
112 	//     < RUSS_PFXIV_I_metadata_line_6_____MPI_NICKEL_PTY_LTD_20211101 >									
113 	//        < cJFTLM2NMJhSj44f5XqmXTHP40wPW6pMAsL1uF3B9qNzJ7fs1FY9Xi66J59ih5Gp >									
114 	//        <  u =="0.000000000000000001" : ] 000000078308375.417202400000000000 ; 000000093410610.418219400000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000777D368E8885 >									
116 	//     < RUSS_PFXIV_I_metadata_line_7_____CAWSE_PROPRIETARY_LIMITED_20211101 >									
117 	//        < 6MHlwBuCC0UK8Y9PeFlgm89Ou4UjGCp0ip97F3BP7wc517dhHC1F96YRfon29wzp >									
118 	//        <  u =="0.000000000000000001" : ] 000000093410610.418219400000000000 ; 000000107041619.145742000000000000 ] >									
119 	//        < 0x00000000000000000000000000000000000000000000000000008E8885A35522 >									
120 	//     < RUSS_PFXIV_I_metadata_line_8_____NORNICKEL_TERMINAL_20211101 >									
121 	//        < 0YC4R7U3lnbpB9yK6m1TD1JMy80UP2OAnK5F5BePcp45R49zHPUloxBdWV8BDRQA >									
122 	//        <  u =="0.000000000000000001" : ] 000000107041619.145742000000000000 ; 000000121409933.227613000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000A35522B941C1 >									
124 	//     < RUSS_PFXIV_I_metadata_line_9_____NORILSKPROMTRANSPORT_20211101 >									
125 	//        < kmY9m6519EfCzb6feN26CcXCuXtW96UJCR6l2b4Srcl56LPj0jiQMjvu8COdOq6w >									
126 	//        <  u =="0.000000000000000001" : ] 000000121409933.227613000000000000 ; 000000136531292.391690000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000000B941C1D05489 >									
128 	//     < RUSS_PFXIV_I_metadata_line_10_____NORILSKGEOLOGIYA_OOO_20211101 >									
129 	//        < 42nKfN9xw1S9edbV394jPg3SJ1gCuR9nXusDZyo8b35t67F9Wj6kpEe4Y2Eapm00 >									
130 	//        <  u =="0.000000000000000001" : ] 000000136531292.391690000000000000 ; 000000150725071.352523000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000000D05489E5FCFB >									
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
174 	//     < RUSS_PFXIV_I_metadata_line_11_____NORNICKEL_FINLAND_OY_20211101 >									
175 	//        < jd85OMGULSf952jpdPoVxRzGkrg03V1jB2Lm88L4Tf7Pe0j5l9Y2j8LZww96f46S >									
176 	//        <  u =="0.000000000000000001" : ] 000000150725071.352523000000000000 ; 000000164829837.735171000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000000E5FCFBFB82A8 >									
178 	//     < RUSS_PFXIV_I_metadata_line_12_____CORBIERE_HOLDINGS_LTD_20211101 >									
179 	//        < am39QqxgA969mcxL2qGk6G5JqgLpGucrrCEHfrzS2u6W58e9Cn7WWf3OJPi5f987 >									
180 	//        <  u =="0.000000000000000001" : ] 000000164829837.735171000000000000 ; 000000178834760.621018000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000000FB82A8110E154 >									
182 	//     < RUSS_PFXIV_I_metadata_line_13_____MEDVEZHY_RUCHEY_20211101 >									
183 	//        < 1FGfi3T73y6Ab4878sBCJkAxM99UiPbk7M31L7BZ3KRReG3kPHqB6N7IV8bjukoP >									
184 	//        <  u =="0.000000000000000001" : ] 000000178834760.621018000000000000 ; 000000194536492.260667000000000000 ] >									
185 	//        < 0x00000000000000000000000000000000000000000000000000110E154128D6D1 >									
186 	//     < RUSS_PFXIV_I_metadata_line_14_____NNK_TRADITSIYA_20211101 >									
187 	//        < 0yoKJW64W5Vx5FYSJdua7vD091jQpnZ584HBK1JgAOjFP49Jg4e5ba2O5QUimyuc >									
188 	//        <  u =="0.000000000000000001" : ] 000000194536492.260667000000000000 ; 000000209649410.910652000000000000 ] >									
189 	//        < 0x00000000000000000000000000000000000000000000000000128D6D113FE64D >									
190 	//     < RUSS_PFXIV_I_metadata_line_15_____RADIO_SEVERNY_GOROD_20211101 >									
191 	//        < xoOVD6J12cl5cDCr2Es958dz2BD01h6UGgFSF3a3LiLTLbnD8fGz5q76wWsch1Ob >									
192 	//        <  u =="0.000000000000000001" : ] 000000209649410.910652000000000000 ; 000000225974433.482538000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000013FE64D158CF43 >									
194 	//     < RUSS_PFXIV_I_metadata_line_16_____ALYKEL_20211101 >									
195 	//        < T0SD0211ypr6349PK0949k9ng99y3xse12SAYaozfB5sl1sVU50l0Ty53l4x9awP >									
196 	//        <  u =="0.000000000000000001" : ] 000000225974433.482538000000000000 ; 000000241605750.662098000000000000 ] >									
197 	//        < 0x00000000000000000000000000000000000000000000000000158CF43170A93F >									
198 	//     < RUSS_PFXIV_I_metadata_line_17_____GEOKOMP_OOO_20211101 >									
199 	//        < 716wjkcIVmnj53o84e1n74bneCMjcx0vCt66onjzSCmmMdDmz5wL0K92JwhqZidw >									
200 	//        <  u =="0.000000000000000001" : ] 000000241605750.662098000000000000 ; 000000258553787.155645000000000000 ] >									
201 	//        < 0x00000000000000000000000000000000000000000000000000170A93F18A8593 >									
202 	//     < RUSS_PFXIV_I_metadata_line_18_____LIONORE_SOUTH_AFRICA_20211101 >									
203 	//        < t3YR5gMtpE19Y06b4WI7RUHG2zv0uoTLXiE25RmXz9gEtx4LyY8Q7La8T34arlF8 >									
204 	//        <  u =="0.000000000000000001" : ] 000000258553787.155645000000000000 ; 000000274959971.425801000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000018A85931A38E3D >									
206 	//     < RUSS_PFXIV_I_metadata_line_19_____VESHCHATELNAYA_KORPORATSIYA_TELESFERA_20211101 >									
207 	//        < 6YRh9W93R7tomVRekeCh2VZ2Z7eNgIPllZ89Y557Y36x19UEsf31WQvvIx8TKyo3 >									
208 	//        <  u =="0.000000000000000001" : ] 000000274959971.425801000000000000 ; 000000289577139.359344000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000001A38E3D1B9DC12 >									
210 	//     < RUSS_PFXIV_I_metadata_line_20_____SRETENSKAYA_COPPER_COMPANY_20211101 >									
211 	//        < k3oPjexBhGIBmvae9ekCpHU2mlO8MceMsWVYXKnxZm346U0HEL8CvEbpC6LoH2pc >									
212 	//        <  u =="0.000000000000000001" : ] 000000289577139.359344000000000000 ; 000000305168582.570914000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000001B9DC121D1A67A >									
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
256 	//     < RUSS_PFXIV_I_metadata_line_21_____NORILSKNICKELREMONT_20211101 >									
257 	//        < z5qNOe0760I7TBS7sSvBAT5r2zNs7hqQw1yPiQ041YMa5VbHftb4YytQZ91sGB4o >									
258 	//        <  u =="0.000000000000000001" : ] 000000305168582.570914000000000000 ; 000000320335504.328999000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000001D1A67A1E8CB0E >									
260 	//     < RUSS_PFXIV_I_metadata_line_22_____NORILSK_NICKEL_INTERGENERATION_20211101 >									
261 	//        < xTzM8LJM76O771jKACm11e1D42tV44Wrn4OattyYOCIyXEc3ZrHM05EpgfcVyM68 >									
262 	//        <  u =="0.000000000000000001" : ] 000000320335504.328999000000000000 ; 000000336941507.410059000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000001E8CB0E20221C7 >									
264 	//     < RUSS_PFXIV_I_metadata_line_23_____PERVAYA_MILYA_OOO_20211101 >									
265 	//        < ssReYsAXFy1arg21A5hGZN53UTC2t73m3wlW5jHRSY0ek1GOJN04HWLf25As03jC >									
266 	//        <  u =="0.000000000000000001" : ] 000000336941507.410059000000000000 ; 000000354145511.490849000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000020221C721C6217 >									
268 	//     < RUSS_PFXIV_I_metadata_line_24_____NORILSKNICKELREMONT_OOO_20211101 >									
269 	//        < 58hXOaDA9gfB00Z8r7t4k4TVQ8kf4D7WQo554X3602xMbE7SuZmxqubHOYxeFYdl >									
270 	//        <  u =="0.000000000000000001" : ] 000000354145511.490849000000000000 ; 000000369304552.584034000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000021C62172338397 >									
272 	//     < RUSS_PFXIV_I_metadata_line_25_____NORNICKEL_INT_HOLDINS_CANADA_20211101 >									
273 	//        < 3IuU6n21VEU1gjAY8KH61gHG30lJcHInHgoJ5KqYDg2F1P5juu825CZFZ108GI1o >									
274 	//        <  u =="0.000000000000000001" : ] 000000369304552.584034000000000000 ; 000000383187425.552802000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002338397248B297 >									
276 	//     < RUSS_PFXIV_I_metadata_line_26_____INTERGEOPROYEKT_LLC_20211101 >									
277 	//        < Ow60D6YFmjG7GQwmqi0U53JOpF8D123fkQHanB88uwa4V6XIEVzt73cpNlbJkYz1 >									
278 	//        <  u =="0.000000000000000001" : ] 000000383187425.552802000000000000 ; 000000397871981.065020000000000000 ] >									
279 	//        < 0x00000000000000000000000000000000000000000000000000248B29725F1ABE >									
280 	//     < RUSS_PFXIV_I_metadata_line_27_____WESTERN_MINERALS_TECHNOLOGY_20211101 >									
281 	//        < LHZse4aiS0J5D4L974FH0nu93FCQDPv7T4M74sYnxHdd3q1xF980SO1oH1M8wz6f >									
282 	//        <  u =="0.000000000000000001" : ] 000000397871981.065020000000000000 ; 000000413927784.932743000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000025F1ABE2779A8A >									
284 	//     < RUSS_PFXIV_I_metadata_line_28_____NORMETIMPEX_20211101 >									
285 	//        < 0IkD1Bvh27W8w3MQEyn80g6N98FJeW2tdpYN0B4s92HRetmMb5jTp4zG4sg57uyN >									
286 	//        <  u =="0.000000000000000001" : ] 000000413927784.932743000000000000 ; 000000430321631.998409000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000002779A8A2909E63 >									
288 	//     < RUSS_PFXIV_I_metadata_line_29_____RAO_NORNICKEL_20211101 >									
289 	//        < 4A1jFoHKVNZ62VFP7odq9I4j2QBL4brjmDla247uD96NKqh9r5M3L7QH2d0yP2zy >									
290 	//        <  u =="0.000000000000000001" : ] 000000430321631.998409000000000000 ; 000000447438084.011816000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000002909E632AABC80 >									
292 	//     < RUSS_PFXIV_I_metadata_line_30_____ZAPOLYARNAYA_STROITELNAYA_KOMPANIYA_20211101 >									
293 	//        < sA56pJMnlwl790I4qTEy85Y66uOzml54XxG59UVqyy73xM0ss6M8o3sD2HSRBWnH >									
294 	//        <  u =="0.000000000000000001" : ] 000000447438084.011816000000000000 ; 000000461062048.881158000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000002AABC802BF865D >									
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
338 	//     < RUSS_PFXIV_I_metadata_line_31_____NORNICKEL_PROCESSING_TECH_20211101 >									
339 	//        < gJXN2mqmUAcv2i31ISPUeL7Tr3ibHkE2H9sCv7AR6B52i2NmuejsiGe8e2V1K8KC >									
340 	//        <  u =="0.000000000000000001" : ] 000000461062048.881158000000000000 ; 000000478285745.806480000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000002BF865D2D9CE5F >									
342 	//     < RUSS_PFXIV_I_metadata_line_32_____NORNICKEL_KTK_20211101 >									
343 	//        < 49C71xvK5P654F56lgl9Qy8915j8Yo5nbk7Q3jZBb4y5cVM22XqEi08xNQGM6Yti >									
344 	//        <  u =="0.000000000000000001" : ] 000000478285745.806480000000000000 ; 000000492601723.684835000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000002D9CE5F2EFA68C >									
346 	//     < RUSS_PFXIV_I_metadata_line_33_____NORILSKYI_OBESPECHIVAUSHYI_COMPLEX_20211101 >									
347 	//        < yjk6C526AVpg8hiLfRl34Ffj37auXXfdb2grHmWoMbbstPc1ie5x3oLd30l0yU6c >									
348 	//        <  u =="0.000000000000000001" : ] 000000492601723.684835000000000000 ; 000000507655243.552944000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000002EFA68C3069ED4 >									
350 	//     < RUSS_PFXIV_I_metadata_line_34_____GRK_BYSTRINSKOYE_20211101 >									
351 	//        < XJdamU1fK9yC8QXwU32pxl62930l3Q07Ydn1Kxk0m5fsoT5219o06IOY9297Nk5f >									
352 	//        <  u =="0.000000000000000001" : ] 000000507655243.552944000000000000 ; 000000521733610.183332000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000003069ED431C1A31 >									
354 	//     < RUSS_PFXIV_I_metadata_line_35_____NORILSKIY_KOMBINAT_20211101 >									
355 	//        < 8jfNfdY2352rFC8Xo55Q2NS5sQR12Gg1TpKAKy5Ucw0BP8FIAKw50GS299289vXM >									
356 	//        <  u =="0.000000000000000001" : ] 000000521733610.183332000000000000 ; 000000535619829.690229000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000031C1A313314A7F >									
358 	//     < RUSS_PFXIV_I_metadata_line_36_____HARJAVALTA_OY_20211101 >									
359 	//        < EWpu6zg6C0y6vR6Qy5eDufh92eh241Z3FLBwRaoyQ9I4de5j4N7p2mJ0GPDg13Q2 >									
360 	//        <  u =="0.000000000000000001" : ] 000000535619829.690229000000000000 ; 000000550214927.883906000000000000 ] >									
361 	//        < 0x000000000000000000000000000000000000000000000000003314A7F3478FB5 >									
362 	//     < RUSS_PFXIV_I_metadata_line_37_____ZAPOLYARNYI_TORGOVYI_ALIANS_20211101 >									
363 	//        < FfA8kQ6LqXJkI7k2T4aL73fP3I8YAV25uXtT8x7I6d64qSI3tEA6sP67lYgeE9A5 >									
364 	//        <  u =="0.000000000000000001" : ] 000000550214927.883906000000000000 ; 000000566797909.964511000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000003478FB5360DD6F >									
366 	//     < RUSS_PFXIV_I_metadata_line_38_____AVALON_20211101 >									
367 	//        < O847bqAG6Z8yWHO658rec024AA1zCmMc4Mx24FvssU8VABORNdfPTITvMZ38Uy5X >									
368 	//        <  u =="0.000000000000000001" : ] 000000566797909.964511000000000000 ; 000000580037749.182927000000000000 ] >									
369 	//        < 0x00000000000000000000000000000000000000000000000000360DD6F375113F >									
370 	//     < RUSS_PFXIV_I_metadata_line_39_____GUSINOOZERSKAYA_20211101 >									
371 	//        < 555RY1CuQoT1Cy1jPs740aLnOcOGsxLo73fwEhO036K8tQ741GH1gdJKc6Y6ZeOe >									
372 	//        <  u =="0.000000000000000001" : ] 000000580037749.182927000000000000 ; 000000594310228.511831000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000375113F38AD86F >									
374 	//     < RUSS_PFXIV_I_metadata_line_40_____NORNICKEL_PSMK_OOO_20211101 >									
375 	//        < kt35942r6p6uHt6EthZT913rmBUw50Dd57o0646R257g52SMT4T9VT4Jl2rmzb60 >									
376 	//        <  u =="0.000000000000000001" : ] 000000594310228.511831000000000000 ; 000000607958860.458894000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000038AD86F39FABEE >									
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