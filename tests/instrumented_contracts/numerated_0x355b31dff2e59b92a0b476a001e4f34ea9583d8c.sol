1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXXX_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXXX_III_883		"	;
8 		string	public		symbol =	"	RUSS_PFXXX_III_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1055709684171920000000000000					;	
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
92 	//     < RUSS_PFXXX_III_metadata_line_1_____CANPOTEX_20251101 >									
93 	//        < M4ZT4RDo71cyR8E9ZKoqSt3HMi67kQat6noHieMEvpXq9QYl4DRtdH1a0nQdw7O1 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000031780339.095597100000000000 ] >									
95 	//        < 0x0000000000000000000000000000000000000000000000000000000000307E32 >									
96 	//     < RUSS_PFXXX_III_metadata_line_2_____CANPOTEX_SHIPPING_SERVICES_20251101 >									
97 	//        < 8TN0l75913S2vX4o238KU8gE114uwLtn8l2nl890a405LFh2l9vSrxLFt4Dg9Dj2 >									
98 	//        <  u =="0.000000000000000001" : ] 000000031780339.095597100000000000 ; 000000060025143.454178000000000000 ] >									
99 	//        < 0x0000000000000000000000000000000000000000000000000000307E325B9752 >									
100 	//     < RUSS_PFXXX_III_metadata_line_3_____CANPOTEX_INT_PTE_LIMITED_20251101 >									
101 	//        < NHj1dBX0h536PNkjbJzQuE4IIs8Jh23pIP2ug7B6R0j8xvy091zXyQEcjSE27M4R >									
102 	//        <  u =="0.000000000000000001" : ] 000000060025143.454178000000000000 ; 000000082864891.338710000000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000005B97527E7119 >									
104 	//     < RUSS_PFXXX_III_metadata_line_4_____PORTLAND_BULK_TERMINALS_LLC_20251101 >									
105 	//        < zjZ1fSk6BU38kN865ovBKZ9aDxs5XjYzp12e9L92tS1C2Td1622Ffhpw3xARS9Wa >									
106 	//        <  u =="0.000000000000000001" : ] 000000082864891.338710000000000000 ; 000000111344369.553257000000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000007E7119A9E5E5 >									
108 	//     < RUSS_PFXXX_III_metadata_line_5_____CANPOTEX_INT_CANCADA_LTD_20251101 >									
109 	//        < 5RCBxl748cFHm1TdkK1C122sl30aooa2HYkn1Uq9XmIJsiWOYj8xVMkO7WPkKz9t >									
110 	//        <  u =="0.000000000000000001" : ] 000000111344369.553257000000000000 ; 000000130345738.192150000000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000A9E5E5C6E44E >									
112 	//     < RUSS_PFXXX_III_metadata_line_6_____CANPOTEX_HK_LIMITED_20251101 >									
113 	//        < 36XhP8lARlqZYTte5k0o38XC2HvA8Qcf3em5197u0KdT7S2X8aAoT6dl8kN03T2Y >									
114 	//        <  u =="0.000000000000000001" : ] 000000130345738.192150000000000000 ; 000000154689737.140808000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000C6E44EEC09AE >									
116 	//     < RUSS_PFXXX_III_metadata_line_7_____CANPOTEX_ORG_20251101 >									
117 	//        < I01F9ImG7716N8jGBD9tTUu0RXQkv1wlb3pLxRm06L1rm2BaXFcn476oI8b9R440 >									
118 	//        <  u =="0.000000000000000001" : ] 000000154689737.140808000000000000 ; 000000178275220.538369000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000000EC09AE11006C2 >									
120 	//     < RUSS_PFXXX_III_metadata_line_8_____CANPOTEX_FND_20251101 >									
121 	//        < jTTCka2Qidn61XjV2Eqr7HrzvmD8kZKkHAc2wU7kszy8jNT13cf6pweEseTf8ib9 >									
122 	//        <  u =="0.000000000000000001" : ] 000000178275220.538369000000000000 ; 000000202405678.531323000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000011006C2134D8B8 >									
124 	//     < RUSS_PFXXX_III_metadata_line_9_____CANPOTEX_gbp_20251101 >									
125 	//        < g453Qm0Q8h5P1607LNL7sY2PuaTjYh9P02c3qgRUA41mxgCWs3r39prrw3aoC7vp >									
126 	//        <  u =="0.000000000000000001" : ] 000000202405678.531323000000000000 ; 000000225879782.284545000000000000 ] >									
127 	//        < 0x00000000000000000000000000000000000000000000000000134D8B8158AA4A >									
128 	//     < RUSS_PFXXX_III_metadata_line_10_____CANPOTEX_SHIPPING_SERVICES_gbp_20251101 >									
129 	//        < 107mJ6jdYX7758VKG0Zg1P1GhBpjalky2Marq5j2r1j0HXf75nOI9VCXX6pNszDx >									
130 	//        <  u =="0.000000000000000001" : ] 000000225879782.284545000000000000 ; 000000251791386.139786000000000000 ] >									
131 	//        < 0x00000000000000000000000000000000000000000000000000158AA4A1803403 >									
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
174 	//     < RUSS_PFXXX_III_metadata_line_11_____CANPOTEX_INT_PTE_LIMITED_gbp_20251101 >									
175 	//        < u2xEkWu04jF55SDRczySkk6Jw1q08Gr89eQsNC5qGV01PTT3PHq9m9L7u62KzjG3 >									
176 	//        <  u =="0.000000000000000001" : ] 000000251791386.139786000000000000 ; 000000276299746.097205000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000018034031A59997 >									
178 	//     < RUSS_PFXXX_III_metadata_line_12_____PORTLAND_BULK_TERMINALS_LLC_gbp_20251101 >									
179 	//        < BpD2kzw9NkxPcoEQ3V802TpfZrfk98k090O54IYSV2bRKm04qX1B4SMtHmhz89U2 >									
180 	//        <  u =="0.000000000000000001" : ] 000000276299746.097205000000000000 ; 000000298221493.070256000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000001A599971C70CC5 >									
182 	//     < RUSS_PFXXX_III_metadata_line_13_____CANPOTEX_INT_CANCADA_LTD_gbp_20251101 >									
183 	//        < jsJrP4TZzjH0vaw09uWa2T90fa4ucN2YLYL1p8eeNlQST86V4i718lfbpGxggj3T >									
184 	//        <  u =="0.000000000000000001" : ] 000000298221493.070256000000000000 ; 000000324607656.027948000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001C70CC51EF4FDE >									
186 	//     < RUSS_PFXXX_III_metadata_line_14_____CANPOTEX_HK_LIMITED_gbp_20251101 >									
187 	//        < fJ37R7FUo7j4x7z380Hn5B6H658lT47QiDWe3oByynG544919pQ1oUWwFLrgDr8Z >									
188 	//        <  u =="0.000000000000000001" : ] 000000324607656.027948000000000000 ; 000000357396675.797034000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000001EF4FDE2215814 >									
190 	//     < RUSS_PFXXX_III_metadata_line_15_____CANPOTEX_ORG_gbp_20251101 >									
191 	//        < 532VM5RHEW7BLXMc90q09NLIhii2bxzu5e2uw95oOxrWtFOaY04B8UvAb6py4VX1 >									
192 	//        <  u =="0.000000000000000001" : ] 000000357396675.797034000000000000 ; 000000380941171.018548000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000022158142454525 >									
194 	//     < RUSS_PFXXX_III_metadata_line_16_____CANPOTEX_FND_gbp_20251101 >									
195 	//        < EJZvCn8trN7x4NROjqI2Gsm8aXeb553oHX6klj4kl29wXN4u5Wk90cbO1ZfC9Ni7 >									
196 	//        <  u =="0.000000000000000001" : ] 000000380941171.018548000000000000 ; 000000401687119.806141000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000002454525264ED08 >									
198 	//     < RUSS_PFXXX_III_metadata_line_17_____CANPOTEX_usd_20251101 >									
199 	//        < zd2zcaB48RZvSWcnM94ql04A445kE3GB5gpId8cWgfVd468D40v77yE9yYOPFiz5 >									
200 	//        <  u =="0.000000000000000001" : ] 000000401687119.806141000000000000 ; 000000426758514.796628000000000000 ] >									
201 	//        < 0x00000000000000000000000000000000000000000000000000264ED0828B2E8B >									
202 	//     < RUSS_PFXXX_III_metadata_line_18_____CANPOTEX_SHIPPING_SERVICES_usd_20251101 >									
203 	//        < 0j0i0GyX0CrwhW4u5gQS5d3860h9Mp5t64LSt9uDX0G4w30P7qUcEO4xP4512mi4 >									
204 	//        <  u =="0.000000000000000001" : ] 000000426758514.796628000000000000 ; 000000462435951.338100000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000028B2E8B2C19F0B >									
206 	//     < RUSS_PFXXX_III_metadata_line_19_____CANPOTEX_INT_PTE_LIMITED_usd_20251101 >									
207 	//        < oPB1r00627h63gpT0twYGQ3nzoM20wpu6VazRe6usy32P35Ve3P2Tgk18D258ja1 >									
208 	//        <  u =="0.000000000000000001" : ] 000000462435951.338100000000000000 ; 000000495364947.274070000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000002C19F0B2F3DDEF >									
210 	//     < RUSS_PFXXX_III_metadata_line_20_____PORTLAND_BULK_TERMINALS_LLC_usd_20251101 >									
211 	//        < mjkF1yzaQ396ri3wv00rVK0EJ3Mjs02lq1SzhhvcodK1pD66ZXfq4Bh25AoxY771 >									
212 	//        <  u =="0.000000000000000001" : ] 000000495364947.274070000000000000 ; 000000527775149.214971000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000002F3DDEF325522B >									
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
256 	//     < RUSS_PFXXX_III_metadata_line_21_____CANPOTEX_INT_CANCADA_LTD_usd_20251101 >									
257 	//        < J2yG238xp56Pl32IAfj73h4XFq7OlwrLilnGve2nuBIcRfz8sYX14rx6reh0401P >									
258 	//        <  u =="0.000000000000000001" : ] 000000527775149.214971000000000000 ; 000000553781700.786871000000000000 ] >									
259 	//        < 0x00000000000000000000000000000000000000000000000000325522B34D00FA >									
260 	//     < RUSS_PFXXX_III_metadata_line_22_____CANPOTEX_HK_LIMITED_usd_20251101 >									
261 	//        < S92kY63KK30rDOI1FzBk9t036BNVM87AAJKL7mi3c6748x0M42A8p34IQ621LjNZ >									
262 	//        <  u =="0.000000000000000001" : ] 000000553781700.786871000000000000 ; 000000574417175.453457000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000034D00FA36C7DB6 >									
264 	//     < RUSS_PFXXX_III_metadata_line_23_____CANPOTEX_ORG_usd_20251101 >									
265 	//        < Qv326ZFSpQ9cFuedmQUu3jfSf2P1r2z0Am96H8dBI3Dui9C6e05sl516r7yF7351 >									
266 	//        <  u =="0.000000000000000001" : ] 000000574417175.453457000000000000 ; 000000596726073.132764000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000036C7DB638E881F >									
268 	//     < RUSS_PFXXX_III_metadata_line_24_____CANPOTEX_FND_usd_20251101 >									
269 	//        < 0YEX4A9NMUDc60oXB3i6f4VCC9AbY8E979HUQl57B1tw9q9P03JE0HSD0kkcsK8F >									
270 	//        <  u =="0.000000000000000001" : ] 000000596726073.132764000000000000 ; 000000619689145.235058000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000038E881F3B19213 >									
272 	//     < RUSS_PFXXX_III_metadata_line_25_____CANPOTEX_chf_20251101 >									
273 	//        < R7kKu0549v4i9U95vEt6dW499l0BsYT2U6cnGm1Q0hV0E9ea4YBnpQzbMc4ivOg4 >									
274 	//        <  u =="0.000000000000000001" : ] 000000619689145.235058000000000000 ; 000000641075759.409533000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000003B192133D23438 >									
276 	//     < RUSS_PFXXX_III_metadata_line_26_____CANPOTEX_SHIPPING_SERVICES_chf_20251101 >									
277 	//        < Y26mnYp4v8S9F7BT9Z2Q34xMVT6ZE8jzkbV6BiKwHed0H2EIsz7e47oJlLr6qH25 >									
278 	//        <  u =="0.000000000000000001" : ] 000000641075759.409533000000000000 ; 000000671936151.300861000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000003D234384014B0F >									
280 	//     < RUSS_PFXXX_III_metadata_line_27_____CANPOTEX_INT_PTE_LIMITED_chf_20251101 >									
281 	//        < 9Tr3exV5pEIa4Miku92O9gN2L3Y5ZdjL5d2Z7VQP57AP8b7Zx63o5S87ASOF54KQ >									
282 	//        <  u =="0.000000000000000001" : ] 000000671936151.300861000000000000 ; 000000707416595.991067000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000004014B0F4376E9C >									
284 	//     < RUSS_PFXXX_III_metadata_line_28_____PORTLAND_BULK_TERMINALS_LLC_chf_20251101 >									
285 	//        < UsGoD3mt58t0s9gO1Tsih4cUTzUGI5aySn05RFSgRUd59Xy7Rd4u7r7I9yAUuBLf >									
286 	//        <  u =="0.000000000000000001" : ] 000000707416595.991067000000000000 ; 000000733814095.609213000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000004376E9C45FB622 >									
288 	//     < RUSS_PFXXX_III_metadata_line_29_____CANPOTEX_INT_CANCADA_LTD_chf_20251101 >									
289 	//        < mckIm706iJI5Z9K6qRWt1f0NdjZ11LNpb429399E0P432r191IHxy4086GsioYH4 >									
290 	//        <  u =="0.000000000000000001" : ] 000000733814095.609213000000000000 ; 000000765510748.008365000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000045FB62249013A3 >									
292 	//     < RUSS_PFXXX_III_metadata_line_30_____CANPOTEX_HK_LIMITED_chf_20251101 >									
293 	//        < 5s5OFW4g328A29FQNuU6X0eZwC8fjAsS35L7X57Zq029DcF9T3SQ89wSNCGvETj4 >									
294 	//        <  u =="0.000000000000000001" : ] 000000765510748.008365000000000000 ; 000000785524580.592113000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000049013A34AE9D8A >									
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
338 	//     < RUSS_PFXXX_III_metadata_line_31_____CANPOTEX_ORG_chf_20251101 >									
339 	//        < 75qiMpn4qJ4w5L1B6RHYoDkLu3zqV5eTtk25cAwxhY6MHG4CnA40fv08QyoBwm7P >									
340 	//        <  u =="0.000000000000000001" : ] 000000785524580.592113000000000000 ; 000000813910049.417270000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000004AE9D8A4D9ED9D >									
342 	//     < RUSS_PFXXX_III_metadata_line_32_____CANPOTEX_FND_chf_20251101 >									
343 	//        < 5NRpK6TLsKu3Bu1GB7jC9v9y9OB3dzVK4wG8WFLXOtgXrP6Qs9m1QjX5CT0Mg20H >									
344 	//        <  u =="0.000000000000000001" : ] 000000813910049.417270000000000000 ; 000000845791671.392679000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000004D9ED9D50A935F >									
346 	//     < RUSS_PFXXX_III_metadata_line_33_____CANPOTEX_eur_20251101 >									
347 	//        < sNJ4Gsv39O4BaR4R1FT6oCj66HiNMsLMS6D59jvEtvvQfTULIS5xBr4y645o5bmR >									
348 	//        <  u =="0.000000000000000001" : ] 000000845791671.392679000000000000 ; 000000864864854.852504000000000000 ] >									
349 	//        < 0x0000000000000000000000000000000000000000000000000050A935F527ADD5 >									
350 	//     < RUSS_PFXXX_III_metadata_line_34_____CANPOTEX_SHIPPING_SERVICES_eur_20251101 >									
351 	//        < b20bARB60e3g57L0S0J8NWRb3WZ4P1Vzr7729H5ZLhTZ8uVIOakxb9su37PmN4Km >									
352 	//        <  u =="0.000000000000000001" : ] 000000864864854.852504000000000000 ; 000000896554882.566915000000000000 ] >									
353 	//        < 0x00000000000000000000000000000000000000000000000000527ADD555808C0 >									
354 	//     < RUSS_PFXXX_III_metadata_line_35_____CANPOTEX_INT_PTE_LIMITED_eur_20251101 >									
355 	//        < BOK1LT6W9L8u4NhbuwP5qW16wQz0EvsRp3kzM4WGq6hrm8J2E3qK5A74n9ziuhOx >									
356 	//        <  u =="0.000000000000000001" : ] 000000896554882.566915000000000000 ; 000000927823272.279356000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000055808C0587BEF7 >									
358 	//     < RUSS_PFXXX_III_metadata_line_36_____PORTLAND_BULK_TERMINALS_LLC_eur_20251101 >									
359 	//        < h52aD5435XlDn98btev0A3wHe3659s4R7v9cjRlfd2F7EKO5Tr31gnZ8bBT9q4v9 >									
360 	//        <  u =="0.000000000000000001" : ] 000000927823272.279356000000000000 ; 000000947728754.640711000000000000 ] >									
361 	//        < 0x00000000000000000000000000000000000000000000000000587BEF75A61E8B >									
362 	//     < RUSS_PFXXX_III_metadata_line_37_____CANPOTEX_INT_CANCADA_LTD_eur_20251101 >									
363 	//        < ljYm3azax5Oo0E7co66iD2X6QMa8Ge9RBw8lsGuL8I8e8pf7OTBpVFHuznJyD1b9 >									
364 	//        <  u =="0.000000000000000001" : ] 000000947728754.640711000000000000 ; 000000979129724.857152000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000005A61E8B5D6088C >									
366 	//     < RUSS_PFXXX_III_metadata_line_38_____CANPOTEX_HK_LIMITED_eur_20251101 >									
367 	//        < qpYWBMdglEcWWGUNJ3I3UFeF337Z4VV8e7k14uAeShj0Pr8dBgq4k6Xq2gAE3n4p >									
368 	//        <  u =="0.000000000000000001" : ] 000000979129724.857152000000000000 ; 000001009575147.524610000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000005D6088C6047D4B >									
370 	//     < RUSS_PFXXX_III_metadata_line_39_____CANPOTEX_ORG_eur_20251101 >									
371 	//        < 00m1V3l9am10L169B70cgoS7tSAi0hZXnVEA6F74zIi7IX2946lYLt4g1y99zPZq >									
372 	//        <  u =="0.000000000000000001" : ] 000001009575147.524610000000000000 ; 000001028690749.299110000000000000 ] >									
373 	//        < 0x000000000000000000000000000000000000000000000000006047D4B621A853 >									
374 	//     < RUSS_PFXXX_III_metadata_line_40_____CANPOTEX_FND_eur_20251101 >									
375 	//        < S6XG06eXf8C0917My8d4p35nwLv6Ew19PRBnKdleTQNqTVZCDkcR94NV04x1mAdH >									
376 	//        <  u =="0.000000000000000001" : ] 000001028690749.299110000000000000 ; 000001055709684.171930000000000000 ] >									
377 	//        < 0x00000000000000000000000000000000000000000000000000621A85364AE298 >									
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