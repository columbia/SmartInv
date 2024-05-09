1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXXX_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXXX_I_883		"	;
8 		string	public		symbol =	"	RUSS_PFXXX_I_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		597921496520442000000000000					;	
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
92 	//     < RUSS_PFXXX_I_metadata_line_1_____CANPOTEX_20211101 >									
93 	//        < QS37IRn6V2qihTQDtHSEaTwBEIXAu74bd0vMS3u8d7WQ7msti52tI4E6qy28w63v >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000014652502.708891600000000000 ] >									
95 	//        < 0x0000000000000000000000000000000000000000000000000000000000165BA2 >									
96 	//     < RUSS_PFXXX_I_metadata_line_2_____CANPOTEX_SHIPPING_SERVICES_20211101 >									
97 	//        < nZXVhUS0wVTaMh6ImsP4G0J0G669rkhc9fbQ2uG2d2ugxS93wd3qBeksuTIF2C5f >									
98 	//        <  u =="0.000000000000000001" : ] 000000014652502.708891600000000000 ; 000000027652299.630575400000000000 ] >									
99 	//        < 0x0000000000000000000000000000000000000000000000000000165BA22A31AE >									
100 	//     < RUSS_PFXXX_I_metadata_line_3_____CANPOTEX_INT_PTE_LIMITED_20211101 >									
101 	//        < 30Edx7V32RFBc40OF091HJ1Kx95U6ONC24Lyf59iSYGzC3908e2bq20XHq1TsSoQ >									
102 	//        <  u =="0.000000000000000001" : ] 000000027652299.630575400000000000 ; 000000043986252.256327800000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000002A31AE431E21 >									
104 	//     < RUSS_PFXXX_I_metadata_line_4_____PORTLAND_BULK_TERMINALS_LLC_20211101 >									
105 	//        < yYl50kXH0tH522622l7Hn06syzBA3HytN27WDh66ZFQ1G910x6bxuh52E5cJXAO1 >									
106 	//        <  u =="0.000000000000000001" : ] 000000043986252.256327800000000000 ; 000000059641670.573557600000000000 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000000000431E215B0187 >									
108 	//     < RUSS_PFXXX_I_metadata_line_5_____CANPOTEX_INT_CANCADA_LTD_20211101 >									
109 	//        < XFhGvU9S7kbKqH4b1z48c28if6p7KQD8YY228H5pK16H7iXy3sUQN24Qkt0ezV93 >									
110 	//        <  u =="0.000000000000000001" : ] 000000059641670.573557600000000000 ; 000000076037940.284561300000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000005B0187740652 >									
112 	//     < RUSS_PFXXX_I_metadata_line_6_____CANPOTEX_HK_LIMITED_20211101 >									
113 	//        < hFHq940Vo9xx95W1b6ytJ39tSUJ763I5Pja468SE6P7oHP2Cay2qT37siIle5sdO >									
114 	//        <  u =="0.000000000000000001" : ] 000000076037940.284561300000000000 ; 000000090057864.462715300000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000740652896ADA >									
116 	//     < RUSS_PFXXX_I_metadata_line_7_____CANPOTEX_ORG_20211101 >									
117 	//        < I5uI8X4M044Bv1f9g5vWEH2gG53nr39mjx4Z5N85LA540690TolAN8EsfsVPx7un >									
118 	//        <  u =="0.000000000000000001" : ] 000000090057864.462715300000000000 ; 000000106872440.667870000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000896ADAA3130C >									
120 	//     < RUSS_PFXXX_I_metadata_line_8_____CANPOTEX_FND_20211101 >									
121 	//        < mU8niW10T3T8n34t33xfo25fd6OhC5yYham5JAxyBGd81BPIfgLQmqP7mv6dKGbQ >									
122 	//        <  u =="0.000000000000000001" : ] 000000106872440.667870000000000000 ; 000000123855379.537195000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000A3130CBCFD02 >									
124 	//     < RUSS_PFXXX_I_metadata_line_9_____CANPOTEX_gbp_20211101 >									
125 	//        < 6jBi8yF51z59HVonB9Wr7njDuhy2U8Y9BHibCuxFxHgCVlalMQ8v3O931NZsMv2M >									
126 	//        <  u =="0.000000000000000001" : ] 000000123855379.537195000000000000 ; 000000137589046.659843000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000000BCFD02D1F1B9 >									
128 	//     < RUSS_PFXXX_I_metadata_line_10_____CANPOTEX_SHIPPING_SERVICES_gbp_20211101 >									
129 	//        < 2F2y425gL0tDT6soUGW93h9a7Nr4j8DFJTUAxxP6HQ2U1F8WXKm8jAeko1c8YUSF >									
130 	//        <  u =="0.000000000000000001" : ] 000000137589046.659843000000000000 ; 000000150691051.609613000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000000D1F1B9E5EFB1 >									
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
174 	//     < RUSS_PFXXX_I_metadata_line_11_____CANPOTEX_INT_PTE_LIMITED_gbp_20211101 >									
175 	//        < k6o6tI9anrBc25r40XFOivjanZp46S6LH402GO2D0g3awA7w06xeSPp1oQe5o4G0 >									
176 	//        <  u =="0.000000000000000001" : ] 000000150691051.609613000000000000 ; 000000167256469.107381000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000000E5EFB1FF368F >									
178 	//     < RUSS_PFXXX_I_metadata_line_12_____PORTLAND_BULK_TERMINALS_LLC_gbp_20211101 >									
179 	//        < MiEIxbjXWI8905gUgj2Q5Pbv5D47NKB4Ge2YqkIvtS70pd32as57OwYySn98lAEZ >									
180 	//        <  u =="0.000000000000000001" : ] 000000167256469.107381000000000000 ; 000000181839276.502811000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000000FF368F11576F8 >									
182 	//     < RUSS_PFXXX_I_metadata_line_13_____CANPOTEX_INT_CANCADA_LTD_gbp_20211101 >									
183 	//        < jXg98IlWXHp7we85vC4vW6ucOW9aUa8r3q6YqIJMQ6751g953IEdKKY7xvk8wL8V >									
184 	//        <  u =="0.000000000000000001" : ] 000000181839276.502811000000000000 ; 000000195049337.506281000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000011576F81299F26 >									
186 	//     < RUSS_PFXXX_I_metadata_line_14_____CANPOTEX_HK_LIMITED_gbp_20211101 >									
187 	//        < cp4r8tJOyigdr41DqI06m71dFz7c5g7Tsi082Q9Hkkl459I2rbWFXIGFrA0HCt4m >									
188 	//        <  u =="0.000000000000000001" : ] 000000195049337.506281000000000000 ; 000000209732960.907392000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000001299F2614006F0 >									
190 	//     < RUSS_PFXXX_I_metadata_line_15_____CANPOTEX_ORG_gbp_20211101 >									
191 	//        < 8r2HmN45j5DfJniApIYgst4BgIgVT0s8L925cRtV4XaEb5KGarH6JJ5v87wYmK64 >									
192 	//        <  u =="0.000000000000000001" : ] 000000209732960.907392000000000000 ; 000000222836278.448316000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000014006F0154056C >									
194 	//     < RUSS_PFXXX_I_metadata_line_16_____CANPOTEX_FND_gbp_20211101 >									
195 	//        < Odvkv439BW82j9R5NK8G2qOFW74hYnz84Leb004ldcj6KbiPhKn2exSFm9X0xB1r >									
196 	//        <  u =="0.000000000000000001" : ] 000000222836278.448316000000000000 ; 000000239421719.425933000000000000 ] >									
197 	//        < 0x00000000000000000000000000000000000000000000000000154056C16D541C >									
198 	//     < RUSS_PFXXX_I_metadata_line_17_____CANPOTEX_usd_20211101 >									
199 	//        < jSFJVCo27qiG6yt2fz2QW14D4lUK1yWozD92jNA122QG47Wl3vAY8N2knNvuD84r >									
200 	//        <  u =="0.000000000000000001" : ] 000000239421719.425933000000000000 ; 000000252697888.578793000000000000 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000000016D541C181961D >									
202 	//     < RUSS_PFXXX_I_metadata_line_18_____CANPOTEX_SHIPPING_SERVICES_usd_20211101 >									
203 	//        < 2c9FPb2RZXNc9DvJN94lr2bTz822E2CbD3u5b269302fAdct0AOE3ssAEc9Pf0aY >									
204 	//        <  u =="0.000000000000000001" : ] 000000252697888.578793000000000000 ; 000000267779692.619435000000000000 ] >									
205 	//        < 0x00000000000000000000000000000000000000000000000000181961D1989971 >									
206 	//     < RUSS_PFXXX_I_metadata_line_19_____CANPOTEX_INT_PTE_LIMITED_usd_20211101 >									
207 	//        < 1saN8bVz20p62r8DHI59bsKvy0Bh3c6133fLx23XXqN2xyQKqwnq19R05db15AH0 >									
208 	//        <  u =="0.000000000000000001" : ] 000000267779692.619435000000000000 ; 000000282868064.717641000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000000019899711AF9F56 >									
210 	//     < RUSS_PFXXX_I_metadata_line_20_____PORTLAND_BULK_TERMINALS_LLC_usd_20211101 >									
211 	//        < 5nP36u12Z9yM9fP13gZbrzjVhyHZ3H52JP2LT0sPzVOU8WM03PKu7X1z5eVGmbba >									
212 	//        <  u =="0.000000000000000001" : ] 000000282868064.717641000000000000 ; 000000298224409.668137000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000001AF9F561C70DE9 >									
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
256 	//     < RUSS_PFXXX_I_metadata_line_21_____CANPOTEX_INT_CANCADA_LTD_usd_20211101 >									
257 	//        < 8md5CZKdc289kv40CXLLEi9agx197VG5fHQvLTq7Sd7t9Uz04VQHbbAL6E1JE2pM >									
258 	//        <  u =="0.000000000000000001" : ] 000000298224409.668137000000000000 ; 000000314454552.990043000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000001C70DE91DFD1CF >									
260 	//     < RUSS_PFXXX_I_metadata_line_22_____CANPOTEX_HK_LIMITED_usd_20211101 >									
261 	//        < Q0YXF0v7998zM78iTJP3xXK1a84ZJk3C05ybAr8j33wA34djI27P94i7nR3PUxbW >									
262 	//        <  u =="0.000000000000000001" : ] 000000314454552.990043000000000000 ; 000000331388786.932680000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000001DFD1CF1F9A8BF >									
264 	//     < RUSS_PFXXX_I_metadata_line_23_____CANPOTEX_ORG_usd_20211101 >									
265 	//        < m9RQsiX7TB35q5565rDj3MlI6FnvlqJ3OSa3Qwel3t1VNqCzBcCW65235JLKHj7i >									
266 	//        <  u =="0.000000000000000001" : ] 000000331388786.932680000000000000 ; 000000347168293.426780000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000001F9A8BF211BC9D >									
268 	//     < RUSS_PFXXX_I_metadata_line_24_____CANPOTEX_FND_usd_20211101 >									
269 	//        < 5g7ZP739pI5tlgi98GeU11K5c4z4o9MvR007QHdUEjU7O1gbCLZncCmVXM6z9WFi >									
270 	//        <  u =="0.000000000000000001" : ] 000000347168293.426780000000000000 ; 000000363612892.306730000000000000 ] >									
271 	//        < 0x00000000000000000000000000000000000000000000000000211BC9D22AD449 >									
272 	//     < RUSS_PFXXX_I_metadata_line_25_____CANPOTEX_chf_20211101 >									
273 	//        < 0qGZ7Kl30XEPqD45a6jbk4Kbhm6c0c23eQc1K9nkB4UR127gf9cam1hF3X0dp0i7 >									
274 	//        <  u =="0.000000000000000001" : ] 000000363612892.306730000000000000 ; 000000377343402.736702000000000000 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000000000022AD44923FC7C4 >									
276 	//     < RUSS_PFXXX_I_metadata_line_26_____CANPOTEX_SHIPPING_SERVICES_chf_20211101 >									
277 	//        < C19OSHxz7WNCHBd923rr7m6Xs1RrKrfa40C2QY055TrRG8atYjqsUFY7NCfwCvA7 >									
278 	//        <  u =="0.000000000000000001" : ] 000000377343402.736702000000000000 ; 000000391612698.850979000000000000 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000000000023FC7C42558DB6 >									
280 	//     < RUSS_PFXXX_I_metadata_line_27_____CANPOTEX_INT_PTE_LIMITED_chf_20211101 >									
281 	//        < pJyXDvdJVHYGtzqm3Watcu7lLqCtO4OENgb6EgIfF8Vv5Q39MD9vAPv4N60Sjo3Z >									
282 	//        <  u =="0.000000000000000001" : ] 000000391612698.850979000000000000 ; 000000408789252.749724000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000002558DB626FC34D >									
284 	//     < RUSS_PFXXX_I_metadata_line_28_____PORTLAND_BULK_TERMINALS_LLC_chf_20211101 >									
285 	//        < 31oN6I9gkwRM4bTrfYvEuMCLyH3T2O8c0EE5y0ar42zASdQeQ4ZBPYRV1mVLXRE2 >									
286 	//        <  u =="0.000000000000000001" : ] 000000408789252.749724000000000000 ; 000000421995519.191533000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000026FC34D283EA00 >									
288 	//     < RUSS_PFXXX_I_metadata_line_29_____CANPOTEX_INT_CANCADA_LTD_chf_20211101 >									
289 	//        < 2S56x6YfNbPiYS9JVRtMm1OVh5j33q8hiBjTkcva832S74Pq3zBm935XCrguag73 >									
290 	//        <  u =="0.000000000000000001" : ] 000000421995519.191533000000000000 ; 000000436563944.512603000000000000 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000000000283EA0029A24CA >									
292 	//     < RUSS_PFXXX_I_metadata_line_30_____CANPOTEX_HK_LIMITED_chf_20211101 >									
293 	//        < 6r9GgYJixOh4txLQHFWn962LB2106ol0Kv1n3qlOibhQS18V6yI76oDF5nVz95k5 >									
294 	//        <  u =="0.000000000000000001" : ] 000000436563944.512603000000000000 ; 000000449561879.793189000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000029A24CA2ADFA1C >									
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
338 	//     < RUSS_PFXXX_I_metadata_line_31_____CANPOTEX_ORG_chf_20211101 >									
339 	//        < c4zA41yLMdu4ImD9Uq2w4788D3qc3r7WFfS97ykFl5T2cKNLB5M4QM4zhbM2CF9G >									
340 	//        <  u =="0.000000000000000001" : ] 000000449561879.793189000000000000 ; 000000462856498.152238000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000002ADFA1C2C24352 >									
342 	//     < RUSS_PFXXX_I_metadata_line_32_____CANPOTEX_FND_chf_20211101 >									
343 	//        < PEb9htUYzQ032fj6XHT3xxfS2n4LNWMSEWq0HRK6U8O9qCB9UNS5ouX4LQXwbClo >									
344 	//        <  u =="0.000000000000000001" : ] 000000462856498.152238000000000000 ; 000000476462612.767624000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000002C243522D70635 >									
346 	//     < RUSS_PFXXX_I_metadata_line_33_____CANPOTEX_eur_20211101 >									
347 	//        < n845tNVUX01A9v41M1v7NFnBe9V5RsSeNp68DKRTLJbs3v7o9sxet35qouQh65hP >									
348 	//        <  u =="0.000000000000000001" : ] 000000476462612.767624000000000000 ; 000000490490707.577397000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000002D706352EC6DEF >									
350 	//     < RUSS_PFXXX_I_metadata_line_34_____CANPOTEX_SHIPPING_SERVICES_eur_20211101 >									
351 	//        < 1z096QmGh5iybMVL0aFWA3lqM4ZUPEuCePzYa0MGHCqU2R6N3ZuteaE9uVU95MDx >									
352 	//        <  u =="0.000000000000000001" : ] 000000490490707.577397000000000000 ; 000000506665494.477476000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000002EC6DEF3051C35 >									
354 	//     < RUSS_PFXXX_I_metadata_line_35_____CANPOTEX_INT_PTE_LIMITED_eur_20211101 >									
355 	//        < djm368aLO9IzsAGqqcPybrpU74I7UzKEod84X2JNR6n38wJnkRCzdnT5UK2t1s61 >									
356 	//        <  u =="0.000000000000000001" : ] 000000506665494.477476000000000000 ; 000000520401475.406880000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000003051C3531A11D4 >									
358 	//     < RUSS_PFXXX_I_metadata_line_36_____PORTLAND_BULK_TERMINALS_LLC_eur_20211101 >									
359 	//        < 191kjAGX8m1t2LMK4xK8L844ty5o37iAD6Jio30pFz7nsdXY5C366nZi73VEo9Es >									
360 	//        <  u =="0.000000000000000001" : ] 000000520401475.406880000000000000 ; 000000535780924.989256000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000031A11D4331896C >									
362 	//     < RUSS_PFXXX_I_metadata_line_37_____CANPOTEX_INT_CANCADA_LTD_eur_20211101 >									
363 	//        < 6k3Ve99kRf19QgmKusst5D9PiW82A5nGl1nlQx3041t42612OHJzDbpda2LISccQ >									
364 	//        <  u =="0.000000000000000001" : ] 000000535780924.989256000000000000 ; 000000552053920.581539000000000000 ] >									
365 	//        < 0x00000000000000000000000000000000000000000000000000331896C34A5E10 >									
366 	//     < RUSS_PFXXX_I_metadata_line_38_____CANPOTEX_HK_LIMITED_eur_20211101 >									
367 	//        < zS8RAWiyDQXoWy5nvlAWnep876aC0g26jO30qPuU9805k2cx2jUy61X3j624ioSx >									
368 	//        <  u =="0.000000000000000001" : ] 000000552053920.581539000000000000 ; 000000568081282.566630000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000034A5E10362D2C0 >									
370 	//     < RUSS_PFXXX_I_metadata_line_39_____CANPOTEX_ORG_eur_20211101 >									
371 	//        < 02P6F1H6kSg7gztnL5HIqP070CFNA8tzwZiI708Ip30xDXZZT0e7byPS5KXQ8zIF >									
372 	//        <  u =="0.000000000000000001" : ] 000000568081282.566630000000000000 ; 000000584084394.981343000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000362D2C037B3DF7 >									
374 	//     < RUSS_PFXXX_I_metadata_line_40_____CANPOTEX_FND_eur_20211101 >									
375 	//        < 7Epx70268beWa5CtX6l6PMuN0LrF15P6bp8U1o1WA9wl4057lcq9mhYy2pSnlZ12 >									
376 	//        <  u =="0.000000000000000001" : ] 000000584084394.981343000000000000 ; 000000597921496.520442000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000037B3DF73905B16 >									
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