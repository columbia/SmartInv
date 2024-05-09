1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXXVI_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXXVI_III_883		"	;
8 		string	public		symbol =	"	RUSS_PFXXVI_III_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1050136908396160000000000000					;	
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
92 	//     < RUSS_PFXXVI_III_metadata_line_1_____BLUE_STREAM_PIPE_CO_20251101 >									
93 	//        < Ca494Rs7xLS119pBRruIcCeLGedCYN2R82cxj0u65tqPr2Zsytq6Ta7Uoi1s33uh >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000031563105.327936800000000000 ] >									
95 	//        < 0x0000000000000000000000000000000000000000000000000000000000302957 >									
96 	//     < RUSS_PFXXVI_III_metadata_line_2_____BLUESTREAM_DAO_20251101 >									
97 	//        < MosV16G539Xw2UvTY5hgsmz54O1JY3spuVeS92Wgd14V1E6RXedC4QnEP6KV6hHH >									
98 	//        <  u =="0.000000000000000001" : ] 000000031563105.327936800000000000 ; 000000050763535.354072000000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000003029574D7582 >									
100 	//     < RUSS_PFXXVI_III_metadata_line_3_____BLUESTREAM_DAOPI_20251101 >									
101 	//        < M2f6L4wMLsI1UCLu01WI0g175uVg11Ywu6ac957XB75S9D2TzroW231My1V72lQ7 >									
102 	//        <  u =="0.000000000000000001" : ] 000000050763535.354072000000000000 ; 000000077982738.406813100000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000004D758276FE02 >									
104 	//     < RUSS_PFXXVI_III_metadata_line_4_____BLUESTREAM_DAC_20251101 >									
105 	//        < 2KrwI8Qcnbfhqq0Ffi5Yif0smiJJ8e78t2iUbT4Ee7QM420ThrWj9Y6Ij1uS5M6J >									
106 	//        <  u =="0.000000000000000001" : ] 000000077982738.406813100000000000 ; 000000112620423.656611000000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000076FE02ABD85A >									
108 	//     < RUSS_PFXXVI_III_metadata_line_5_____BLUESTREAM_BIMI_20251101 >									
109 	//        < DG34UetIlLl78CyaBSsL3P2i11YoPQ919KQ63chclhP2KW350cx3Jo2NEJ1n8KOd >									
110 	//        <  u =="0.000000000000000001" : ] 000000112620423.656611000000000000 ; 000000146963316.710887000000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000ABD85AE03F8C >									
112 	//     < RUSS_PFXXVI_III_metadata_line_6_____PANRUSGAZ_20251101 >									
113 	//        < Z54z2O4e8kaX9dWYcu0rUV0kQbvSjxh6x14ecnUq2PgH9kgDJOf2r60JW9Bm31lL >									
114 	//        <  u =="0.000000000000000001" : ] 000000146963316.710887000000000000 ; 000000181943214.198192000000000000 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000000000E03F8C1159F91 >									
116 	//     < RUSS_PFXXVI_III_metadata_line_7_____OKHRANA_PSC_20251101 >									
117 	//        < j49g3ft7xZ89lIbRRgh0I7UT47HMgURzEJtPMJ6gO7b38F336G4952aq9eiOrw12 >									
118 	//        <  u =="0.000000000000000001" : ] 000000181943214.198192000000000000 ; 000000209894772.265050000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000001159F911404625 >									
120 	//     < RUSS_PFXXVI_III_metadata_line_8_____PROEKTIROVANYE_OOO_20251101 >									
121 	//        < 03h5fTfe3i997YlYhUz86Q92x9s468ihP9ykjfQ5y55OSHoAg1m5jOM7yiWBu861 >									
122 	//        <  u =="0.000000000000000001" : ] 000000209894772.265050000000000000 ; 000000231561741.452806000000000000 ] >									
123 	//        < 0x00000000000000000000000000000000000000000000000000140462516155CE >									
124 	//     < RUSS_PFXXVI_III_metadata_line_9_____YUGOROSGAZ_20251101 >									
125 	//        < S3Sx0Poerr2FdbI5OEgtajqZOxP5I66Ez14CGM1iPH4igU4f15Q1cGmVA9RfudUn >									
126 	//        <  u =="0.000000000000000001" : ] 000000231561741.452806000000000000 ; 000000258864452.352744000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000016155CE18AFEED >									
128 	//     < RUSS_PFXXVI_III_metadata_line_10_____GAZPROM_FINANCE_BV_20251101 >									
129 	//        < 7I3v970Cfdzcv7HKc8563uoR8n1uSwlA2ep5oauNpZOt0YK0W4Y91J9yBYq6yier >									
130 	//        <  u =="0.000000000000000001" : ] 000000258864452.352744000000000000 ; 000000280039256.916179000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000018AFEED1AB4E56 >									
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
174 	//     < RUSS_PFXXVI_III_metadata_line_11_____WINTERSHALL_NOORDZEE_BV_20251101 >									
175 	//        < 7x0eAiq12tfY07qnP6iqSEGh2RXwp8GDW3L85eQMup6sUmW0ONoHSEdNx0rtb3IA >									
176 	//        <  u =="0.000000000000000001" : ] 000000280039256.916179000000000000 ; 000000307422848.260099000000000000 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000000001AB4E561D5170D >									
178 	//     < RUSS_PFXXVI_III_metadata_line_12_____WINTERSHALL_DAO_20251101 >									
179 	//        < wSD3g21GEiwFS0NJu94nEV9381CVNnF6x156Mkq9uEKsZBGWcdlCJ8lWFI0dcDRm >									
180 	//        <  u =="0.000000000000000001" : ] 000000307422848.260099000000000000 ; 000000327008774.560045000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000001D5170D1F2F9CD >									
182 	//     < RUSS_PFXXVI_III_metadata_line_13_____WINTERSHALL_DAOPI_20251101 >									
183 	//        < aSSxeyjUlYPOJOxYr9Fu6zOSdt1Pd5AhVFOq06edm5p9ZGQ7W3g1LH6d611DpENG >									
184 	//        <  u =="0.000000000000000001" : ] 000000327008774.560045000000000000 ; 000000349074851.732302000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001F2F9CD214A55D >									
186 	//     < RUSS_PFXXVI_III_metadata_line_14_____WINTERSHALL_DAC_20251101 >									
187 	//        < S0FVGU2z74qvX4337mYV5W6oY72324TSq3akd6v2qXLI4PGdge28v232g6zpLvlx >									
188 	//        <  u =="0.000000000000000001" : ] 000000349074851.732302000000000000 ; 000000369788359.784751000000000000 ] >									
189 	//        < 0x00000000000000000000000000000000000000000000000000214A55D2344094 >									
190 	//     < RUSS_PFXXVI_III_metadata_line_15_____WINTERSHALL_BIMI_20251101 >									
191 	//        < z29QLu93387sBJr4z19NEVEROV96CuL3PFCt0jb60P31PD1kDYv5hf1i5531I1YE >									
192 	//        <  u =="0.000000000000000001" : ] 000000369788359.784751000000000000 ; 000000388821260.567676000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000023440942514B4E >									
194 	//     < RUSS_PFXXVI_III_metadata_line_16_____SAKHALIN_HOLDINGS_BV_20251101 >									
195 	//        < lJ98WpV3JUp7Joe326iJ4jAJaN67OCFn1aBy6pmHq48nXx5AXE41lF62Pl3G42tI >									
196 	//        <  u =="0.000000000000000001" : ] 000000388821260.567676000000000000 ; 000000420392670.539661000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000002514B4E28177E3 >									
198 	//     < RUSS_PFXXVI_III_metadata_line_17_____TRANSGAS_KAZAN_20251101 >									
199 	//        < A8AyvuI4Zy1h1wcKU4H0d34fKuusNFqUk4AR274Vmv67pKYu8q2eqfo9jci5g2Xi >									
200 	//        <  u =="0.000000000000000001" : ] 000000420392670.539661000000000000 ; 000000453707368.171383000000000000 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000000028177E32B44D71 >									
202 	//     < RUSS_PFXXVI_III_metadata_line_18_____SOUTH_STREAM_SERBIA_20251101 >									
203 	//        < m0bp8K3e4O674G6ZOm7F36izQJZ5PP1pr7M3rRqiXfw53OjJW9kBtgB5eGZ3800F >									
204 	//        <  u =="0.000000000000000001" : ] 000000453707368.171383000000000000 ; 000000486344623.997563000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000002B44D712E61A5E >									
206 	//     < RUSS_PFXXVI_III_metadata_line_19_____WINTERSHALL_ERDGAS_HANDELSHAUS_ZUG_AG_20251101 >									
207 	//        < 4446o7sP5UEnM5qKH3UWipIx4WOXARc3e1tvXMCNn1mGb2Fp8K4b26O64laku9mz >									
208 	//        <  u =="0.000000000000000001" : ] 000000486344623.997563000000000000 ; 000000521413363.708113000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000002E61A5E31B9D18 >									
210 	//     < RUSS_PFXXVI_III_metadata_line_20_____TRANSGAZ_MOSCOW_OOO_20251101 >									
211 	//        < IPD5w3X7eM6iyrBm0L93Moj4jl0w48ppm50llO8V1TJ888oOjpKJGhSZw7G41kUm >									
212 	//        <  u =="0.000000000000000001" : ] 000000521413363.708113000000000000 ; 000000547729130.008966000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000031B9D18343C4B1 >									
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
256 	//     < RUSS_PFXXVI_III_metadata_line_21_____PERERABOTKA_20251101 >									
257 	//        < NyjWdkndW2h2kpxz3rXIMf8CpFY4YZFUmiFE05tG32ttuU9st3c39zY59XqnNJlF >									
258 	//        <  u =="0.000000000000000001" : ] 000000547729130.008966000000000000 ; 000000579131270.596855000000000000 ] >									
259 	//        < 0x00000000000000000000000000000000000000000000000000343C4B1373AF27 >									
260 	//     < RUSS_PFXXVI_III_metadata_line_22_____GAZPROM_EXPORT_20251101 >									
261 	//        < v24Ak2BX6GR7dc1i2uf0FXJa9PqEkjCwmWAhbxmgyWLU8OhibV8iT7I8Pg7I50ai >									
262 	//        <  u =="0.000000000000000001" : ] 000000579131270.596855000000000000 ; 000000600816055.908082000000000000 ] >									
263 	//        < 0x00000000000000000000000000000000000000000000000000373AF27394C5C6 >									
264 	//     < RUSS_PFXXVI_III_metadata_line_23_____WINGAS_20251101 >									
265 	//        < jT481uQwx14a365Bg001Xp8413ODqbU52z7En6nGCGPA25z8Tks7Nl5nKydr8csG >									
266 	//        <  u =="0.000000000000000001" : ] 000000600816055.908082000000000000 ; 000000633753408.843768000000000000 ] >									
267 	//        < 0x00000000000000000000000000000000000000000000000000394C5C63C707ED >									
268 	//     < RUSS_PFXXVI_III_metadata_line_24_____DOBYCHA_URENGOY_20251101 >									
269 	//        < 22i9OxFEseASz7y4MZ3cg1AX2a0Wzgga1TU7FDIZ3LmBw9ruxuwwOE68MlrCJdf7 >									
270 	//        <  u =="0.000000000000000001" : ] 000000633753408.843768000000000000 ; 000000653112895.324276000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000003C707ED3E4923A >									
272 	//     < RUSS_PFXXVI_III_metadata_line_25_____MOSENERGO_20251101 >									
273 	//        < TAYlbjdqZk8ssG3OF1P7g9y3byLQEY45z8XTlRtId8a363iw0Sf6w52v6a1MdsmL >									
274 	//        <  u =="0.000000000000000001" : ] 000000653112895.324276000000000000 ; 000000677852171.189879000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000003E4923A40A5201 >									
276 	//     < RUSS_PFXXVI_III_metadata_line_26_____OGK_2_AB_20251101 >									
277 	//        < L9aq8CtR6Qpw4ruAl121fL3jjAh5Ty9VWp30RrWQb0v63zeOGZ8xaCdM5S700oX3 >									
278 	//        <  u =="0.000000000000000001" : ] 000000677852171.189879000000000000 ; 000000705036427.057424000000000000 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000000000040A5201433CCDB >									
280 	//     < RUSS_PFXXVI_III_metadata_line_27_____TGC_1_20251101 >									
281 	//        < fbVMpxGbsSoplMEtQZXBzj1rs62QcRGW76GI2Ref88w1mzLE1Z98G1f2oWUlDws9 >									
282 	//        <  u =="0.000000000000000001" : ] 000000705036427.057424000000000000 ; 000000728479370.498853000000000000 ] >									
283 	//        < 0x00000000000000000000000000000000000000000000000000433CCDB4579241 >									
284 	//     < RUSS_PFXXVI_III_metadata_line_28_____GAZPROM_MEDIA_20251101 >									
285 	//        < Mchg2Xv93Dg1BxT1Qz5MawdgYs3h4CI1AD2uvW0t8WrasPw3N3ghhwv6CTwYSljm >									
286 	//        <  u =="0.000000000000000001" : ] 000000728479370.498853000000000000 ; 000000756212467.968060000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000004579241481E37F >									
288 	//     < RUSS_PFXXVI_III_metadata_line_29_____ENERGOHOLDING_LLC_20251101 >									
289 	//        < 3Ii7Zj0SS82L2FzM0Px1Wx66qO0UV3itcTh0JEjR5Bh4GL102326Kh3kI0z6Z2Wc >									
290 	//        <  u =="0.000000000000000001" : ] 000000756212467.968060000000000000 ; 000000779510585.387803000000000000 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000000000481E37F4A57053 >									
292 	//     < RUSS_PFXXVI_III_metadata_line_30_____TRANSGAZ_TOMSK_OOO_20251101 >									
293 	//        < Ub698Hk43NBIo767jXbs3c1Je2bO07SzTp5NJh0ujlkZYGZe8DdtP338ZyEqy3H4 >									
294 	//        <  u =="0.000000000000000001" : ] 000000779510585.387803000000000000 ; 000000800661036.457297000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000004A570534C5B638 >									
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
338 	//     < RUSS_PFXXVI_III_metadata_line_31_____DOBYCHA_YAMBURG_20251101 >									
339 	//        < 42KtRwxw5TgjtjL8KY1nfsXz5D9KoJ67Hv44b7gkdIQ6y8618CCNX0LeHOPAl6U2 >									
340 	//        <  u =="0.000000000000000001" : ] 000000800661036.457297000000000000 ; 000000820022714.306914000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000004C5B6384E3415F >									
342 	//     < RUSS_PFXXVI_III_metadata_line_32_____YAMBURG_DAO_20251101 >									
343 	//        < pVZHpOFRi6gsNWYeRgIRBw43pOyHm8642a986otb0FVM6wYZxXdEndY73xjhK6aP >									
344 	//        <  u =="0.000000000000000001" : ] 000000820022714.306914000000000000 ; 000000842118304.707341000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000004E3415F504F876 >									
346 	//     < RUSS_PFXXVI_III_metadata_line_33_____YAMBURG_DAOPI_20251101 >									
347 	//        < 5Au380uKJ5O9t92cupe9XTeejS958skB9Vusj5z4qx4e4oJad5jUh700W1f5idHu >									
348 	//        <  u =="0.000000000000000001" : ] 000000842118304.707341000000000000 ; 000000861617057.401773000000000000 ] >									
349 	//        < 0x00000000000000000000000000000000000000000000000000504F876522B92A >									
350 	//     < RUSS_PFXXVI_III_metadata_line_34_____YAMBURG_DAC_20251101 >									
351 	//        < b0R54w61iDv6D33Gb8HnG2nGw3N6sIo55475nJxUi8C2i5tCd5go8l7tJ7E9ZZN6 >									
352 	//        <  u =="0.000000000000000001" : ] 000000861617057.401773000000000000 ; 000000888956107.382225000000000000 ] >									
353 	//        < 0x00000000000000000000000000000000000000000000000000522B92A54C707B >									
354 	//     < RUSS_PFXXVI_III_metadata_line_35_____YAMBURG_BIMI_20251101 >									
355 	//        < 0EboqmsTs25225ZUBnZ1p6Dv22GWT95Gc237p8dkxM77F2GzRs7l42NflOZC3G4G >									
356 	//        <  u =="0.000000000000000001" : ] 000000888956107.382225000000000000 ; 000000923412252.929589000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000054C707B58103E9 >									
358 	//     < RUSS_PFXXVI_III_metadata_line_36_____EP_INTERNATIONAL_BV_20251101 >									
359 	//        < Crj0s2C22k4MX0400Ba55Wg19thJkyPoiB23a11VmC8g6U35304AW7QE68Mm25ya >									
360 	//        <  u =="0.000000000000000001" : ] 000000923412252.929589000000000000 ; 000000944358946.418827000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000058103E95A0FA37 >									
362 	//     < RUSS_PFXXVI_III_metadata_line_37_____TRANSGAZ_YUGORSK_20251101 >									
363 	//        < otyr0s1j207jDAyzm924pXE7S3IplYQgbzp4eZ618pBxc2LS35Sq35CgWD1D48QJ >									
364 	//        <  u =="0.000000000000000001" : ] 000000944358946.418827000000000000 ; 000000963823664.234896000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000005A0FA375BEAD9E >									
366 	//     < RUSS_PFXXVI_III_metadata_line_38_____GAZPROM_GERMANIA_20251101 >									
367 	//        < p58HBMba4GumGY0UA1L94J39f55vX11GS240V5958S973782keObz33m9S0r5j1Y >									
368 	//        <  u =="0.000000000000000001" : ] 000000963823664.234896000000000000 ; 000000986910742.735801000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000005BEAD9E5E1E802 >									
370 	//     < RUSS_PFXXVI_III_metadata_line_39_____GAZPROMENERGO_20251101 >									
371 	//        < H803B9GEBesNYoaCi1kjAhx54KWwghG425Nrh5Z0HYXZ427N9R8oB8bJeoBAXMNo >									
372 	//        <  u =="0.000000000000000001" : ] 000000986910742.735801000000000000 ; 000001018632152.718210000000000000 ] >									
373 	//        < 0x000000000000000000000000000000000000000000000000005E1E8026124F2F >									
374 	//     < RUSS_PFXXVI_III_metadata_line_40_____INDUSTRIJA_SRBIJE_20251101 >									
375 	//        < Rmbd68JJK8O1nt56abo9h848gN426Yfe0G6ZzAP6xDMOr0zGwUo1eYYi6863QRDA >									
376 	//        <  u =="0.000000000000000001" : ] 000001018632152.718210000000000000 ; 000001050136908.396160000000000000 ] >									
377 	//        < 0x000000000000000000000000000000000000000000000000006124F2F64261BB >									
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