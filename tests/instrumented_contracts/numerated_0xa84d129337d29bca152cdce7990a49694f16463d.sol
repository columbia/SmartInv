1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	SHERE_PFV_II_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	SHERE_PFV_II_883		"	;
8 		string	public		symbol =	"	SHERE_PFV_II_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1224678853849720000000000000					;	
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
92 	//     < SHERE_PFV_II_metadata_line_1_____AEROFLOT_20240505 >									
93 	//        < KCh954kuwbXD1EgVO2h744bGkK6eUP6z0zizKeYTAOdcuCIV5Z9cVsN6yRUq6NiK >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000045430588.864348200000000000 ] >									
95 	//        < 0x0000000000000000000000000000000000000000000000000000000000455253 >									
96 	//     < SHERE_PFV_II_metadata_line_2_____AEROFLOT_ORG_20240505 >									
97 	//        < 5Ps080d2z8H1Tt3Y79a48anwCXfYTEU2jd9GsWELn5E9Zn8a2ZQ360SQeS7HQX6m >									
98 	//        <  u =="0.000000000000000001" : ] 000000045430588.864348200000000000 ; 000000088010033.066337700000000000 ] >									
99 	//        < 0x0000000000000000000000000000000000000000000000000000455253864AEB >									
100 	//     < SHERE_PFV_II_metadata_line_3_____AURORA_20240505 >									
101 	//        < ri7pP5e86B0M7eOgRqO8JX7DCqKA1D54S0zl0WQ732FkPp1D4BQ7ymqi91onMi4B >									
102 	//        <  u =="0.000000000000000001" : ] 000000088010033.066337700000000000 ; 000000109662046.904612000000000000 ] >									
103 	//        < 0x0000000000000000000000000000000000000000000000000000864AEBA754BD >									
104 	//     < SHERE_PFV_II_metadata_line_4_____AURORA_ORG_20240505 >									
105 	//        < Kz1qj89Gomu6xx4pzQSTWtcY1F6071VygzkBWSzTQ7bf61ABG9Lb2JF3Xre7s3oQ >									
106 	//        <  u =="0.000000000000000001" : ] 000000109662046.904612000000000000 ; 000000148057672.478141000000000000 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000000000A754BDE1EB07 >									
108 	//     < SHERE_PFV_II_metadata_line_5_____RUSSIA _20240505 >									
109 	//        < wmwDr88MaIHO24kQoHiCMymoaRdwW98BV144J4Ap11J5Jd0HJ7sTI2QRXwe18TLx >									
110 	//        <  u =="0.000000000000000001" : ] 000000148057672.478141000000000000 ; 000000181473010.635004000000000000 ] >									
111 	//        < 0x000000000000000000000000000000000000000000000000000E1EB07114E7E5 >									
112 	//     < SHERE_PFV_II_metadata_line_6_____RUSSIA _ORG_20240505 >									
113 	//        < dqA7M8di8D8s4RvNr78jNKymY81711WmTIA5uopS2a8NQbwfft53cOIW03c3gDF4 >									
114 	//        <  u =="0.000000000000000001" : ] 000000181473010.635004000000000000 ; 000000206632643.228198000000000000 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000000000114E7E513B4BE0 >									
116 	//     < SHERE_PFV_II_metadata_line_7_____VICTORIA_20240505 >									
117 	//        < ab5oekSq8H0Dw94X3I9jRrYi46Y0Y6pN91QGy031vi6V2hxvDcE4kyX19NiC9nAp >									
118 	//        <  u =="0.000000000000000001" : ] 000000206632643.228198000000000000 ; 000000232444083.804062000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000013B4BE0162AE78 >									
120 	//     < SHERE_PFV_II_metadata_line_8_____VICTORIA_ORG_20240505 >									
121 	//        < R1Tuc0nqcuQXSy8in7EFkw98xmr13B75Ld9vECiUvuy8azqvDySg8C876T58M1yo >									
122 	//        <  u =="0.000000000000000001" : ] 000000232444083.804062000000000000 ; 000000269023575.886126000000000000 ] >									
123 	//        < 0x00000000000000000000000000000000000000000000000000162AE7819A7F56 >									
124 	//     < SHERE_PFV_II_metadata_line_9_____DOBROLET_20240505 >									
125 	//        < 8VCO434r70ml9SVY7w906Q56bg0z5z296esy80ZMY2IS1pg6yISTtQZ5vuF48759 >									
126 	//        <  u =="0.000000000000000001" : ] 000000269023575.886126000000000000 ; 000000311858219.828827000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000019A7F561DBDB9E >									
128 	//     < SHERE_PFV_II_metadata_line_10_____DOBROLET_ORG_20240505 >									
129 	//        < I095WNl28VM02ghXlECE1E9HH09ytbPq2TEylECgvmV4Rq340BAAZlnPauEvLt27 >									
130 	//        <  u =="0.000000000000000001" : ] 000000311858219.828827000000000000 ; 000000343002350.663919000000000000 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000000001DBDB9E20B614B >									
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
174 	//     < SHERE_PFV_II_metadata_line_11_____AEROFLOT_RUSSIAN_AIRLINES_20240505 >									
175 	//        < a0KosYbbrz3tJ45769EltBGyNDMn614Q30Se5rO4Br4p131C9w8tJjkhEGcCL5cR >									
176 	//        <  u =="0.000000000000000001" : ] 000000343002350.663919000000000000 ; 000000369469074.983487000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000020B614B233C3DB >									
178 	//     < SHERE_PFV_II_metadata_line_12_____AEROFLOT_RUSSIAN_AIRLINES_ORG_20240505 >									
179 	//        < i9iLlZLPjTpHN26uMPG96555uzbFEVOu40yyNzm1QlhQ9Wi4PUp9q5eA4Ou73I1C >									
180 	//        <  u =="0.000000000000000001" : ] 000000369469074.983487000000000000 ; 000000393487355.344285000000000000 ] >									
181 	//        < 0x00000000000000000000000000000000000000000000000000233C3DB2586A00 >									
182 	//     < SHERE_PFV_II_metadata_line_13_____OTDELSTROY_INVEST_20240505 >									
183 	//        < sh8P9vZ77oRGQP5dd2w5r2f3E82EtFwvO1ceUP9eq6IG572pg7FpcYd28I5U5H7x >									
184 	//        <  u =="0.000000000000000001" : ] 000000393487355.344285000000000000 ; 000000411229173.058322000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000002586A002737C65 >									
186 	//     < SHERE_PFV_II_metadata_line_14_____OTDELSTROY_INVEST_ORG_20240505 >									
187 	//        < ah1ZNxnrMmc7gCSzF93mFs1StFV5Jqo3ICRs0O5l2X77Z391pBtGwwm72Iz75M23 >									
188 	//        <  u =="0.000000000000000001" : ] 000000411229173.058322000000000000 ; 000000439953338.365687000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000002737C6529F50C6 >									
190 	//     < SHERE_PFV_II_metadata_line_15_____POBEDA_AIRLINES_20240505 >									
191 	//        < 12tTe92ijYtyN4d9bW9D9H066y1djVxXbW3Z610YGl078wVk52d3Wt4gqG48Ub3j >									
192 	//        <  u =="0.000000000000000001" : ] 000000439953338.365687000000000000 ; 000000458017037.647362000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000029F50C62BAE0E8 >									
194 	//     < SHERE_PFV_II_metadata_line_16_____POBEDA_AIRLINES_ORG_20240505 >									
195 	//        < Jn06y11K8eS3d8luXHu11J4ID13doZ4Re4km2hr82fYXW3gIG01249929DvhoZjW >									
196 	//        <  u =="0.000000000000000001" : ] 000000458017037.647362000000000000 ; 000000495465345.143929000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000002BAE0E82F40527 >									
198 	//     < SHERE_PFV_II_metadata_line_17_____DAROFAN_20240505 >									
199 	//        < 9SrT99eg6VgqApY2EdrWy7Wb0m3TzcrGUwc87tUmvNT5qm8XA0h7Y9Cx2GZDkrqD >									
200 	//        <  u =="0.000000000000000001" : ] 000000495465345.143929000000000000 ; 000000544358136.334661000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000002F4052733E9FE6 >									
202 	//     < SHERE_PFV_II_metadata_line_18_____DAROFAN_ORG_20240505 >									
203 	//        < 7lsLMi5A6MRqx7ETvA92mXp6dj8aQFxQi5sukW6t2oV8C85OA38CELFtEuk176XW >									
204 	//        <  u =="0.000000000000000001" : ] 000000544358136.334661000000000000 ; 000000566780737.815768000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000033E9FE6360D6BA >									
206 	//     < SHERE_PFV_II_metadata_line_19_____TERMINAL_20240505 >									
207 	//        < 7v5X9djruCNApTbP7KQYdFNeC8BQWl7GZSak9Ov6a2IwP2Vj56by067XDOu2p0gQ >									
208 	//        <  u =="0.000000000000000001" : ] 000000566780737.815768000000000000 ; 000000594497683.684072000000000000 ] >									
209 	//        < 0x00000000000000000000000000000000000000000000000000360D6BA38B21A8 >									
210 	//     < SHERE_PFV_II_metadata_line_20_____TERMINAL_ORG_20240505 >									
211 	//        < 10T74xP9RN1rhp77e74A7T7vWnK5Porz8E36YCu7rkL97rhv4phZMV460v7KVSYr >									
212 	//        <  u =="0.000000000000000001" : ] 000000594497683.684072000000000000 ; 000000611289837.729700000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000038B21A83A4C118 >									
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
256 	//     < SHERE_PFV_II_metadata_line_21_____AEROFLOT_FINANCE_20240505 >									
257 	//        < 07ji7t04ODw30eFurV2tCFDtYcAqu2YLV6Y4bcJ3MxX1f8U8Hm39iHEQn6tQ6ZRx >									
258 	//        <  u =="0.000000000000000001" : ] 000000611289837.729700000000000000 ; 000000643138020.154189000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000003A4C1183D559CA >									
260 	//     < SHERE_PFV_II_metadata_line_22_____AEROFLOT_FINANCE_ORG_20240505 >									
261 	//        < 157JJ44v75H6fh51vL88DT26J6V85R0IRz1Kio3E012Xr05uXeTcn6ZkHG7URx0A >									
262 	//        <  u =="0.000000000000000001" : ] 000000643138020.154189000000000000 ; 000000662420349.253619000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000003D559CA3F2C5F3 >									
264 	//     < SHERE_PFV_II_metadata_line_23_____SHEROTEL_20240505 >									
265 	//        < PVdR4DIunJZhkM58rMDjy9G6L352cy24Y0V8COqhsfFPhL0rVUoC4jmf7eQ61n67 >									
266 	//        <  u =="0.000000000000000001" : ] 000000662420349.253619000000000000 ; 000000688068615.712313000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000003F2C5F3419E8CE >									
268 	//     < SHERE_PFV_II_metadata_line_24_____SHEROTEL_ORG_20240505 >									
269 	//        < 5OR993Ad5j32m8Y5R9D7232C4u9YHnt36IGY57jf4jDCYA4g80mGi0G15xixasUX >									
270 	//        <  u =="0.000000000000000001" : ] 000000688068615.712313000000000000 ; 000000710136459.357915000000000000 ] >									
271 	//        < 0x00000000000000000000000000000000000000000000000000419E8CE43B950E >									
272 	//     < SHERE_PFV_II_metadata_line_25_____DALAVIA_KHABAROVSK_20240505 >									
273 	//        < N8ubUKC46s5IHcUnpEALR4waEQ1C63r5FGm8gqlAm4LCJ8javPTzwx8lVZ4KView >									
274 	//        <  u =="0.000000000000000001" : ] 000000710136459.357915000000000000 ; 000000758346836.887476000000000000 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000000000043B950E485253C >									
276 	//     < SHERE_PFV_II_metadata_line_26_____DALAVIA_KHABAROVSK_ORG_20240505 >									
277 	//        < 7HQuxYNf6GEXpj8l0p1ta8Oy6Sy35nGdkt1rRAbrcAyFDZ8N2wiV827j0AOJ39z4 >									
278 	//        <  u =="0.000000000000000001" : ] 000000758346836.887476000000000000 ; 000000788731590.220372000000000000 ] >									
279 	//        < 0x00000000000000000000000000000000000000000000000000485253C4B38247 >									
280 	//     < SHERE_PFV_II_metadata_line_27_____AEROFLOT_AVIATION_SCHOOL_20240505 >									
281 	//        < 1M37i89q915N9l6Xu8F6U6Pl3esk0LVVmQc1QrOWuOC16055b0XL1uhx9051X0Wp >									
282 	//        <  u =="0.000000000000000001" : ] 000000788731590.220372000000000000 ; 000000834958885.991526000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000004B382474FA0BD1 >									
284 	//     < SHERE_PFV_II_metadata_line_28_____AEROFLOT_AVIATION_SCHOOL_ORG_20240505 >									
285 	//        < hCyxs5G412So0X31qc216jn07vmahh8X28w5NnIjGa0Zr0y6pH82Dix02QetcE2s >									
286 	//        <  u =="0.000000000000000001" : ] 000000834958885.991526000000000000 ; 000000879910363.367961000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000004FA0BD153EA2FC >									
288 	//     < SHERE_PFV_II_metadata_line_29_____A_TECHNICS_20240505 >									
289 	//        < IWDd0o12OEFc277Y90lIjSiNAi7Cq8N5b8RJJbM1YA2i96o4ehx6qJ6y62jw8NPL >									
290 	//        <  u =="0.000000000000000001" : ] 000000879910363.367961000000000000 ; 000000926776109.154482000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000053EA2FC58625EB >									
292 	//     < SHERE_PFV_II_metadata_line_30_____A_TECHNICS_ORG_20240505 >									
293 	//        < 38Dz9Vqye81S18L3V6W1r3CuSQmfSNM8qBA73kxR5uobyJ7yBZZ3y2JxR1aJIDYS >									
294 	//        <  u =="0.000000000000000001" : ] 000000926776109.154482000000000000 ; 000000969034922.155496000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000058625EB5C6A144 >									
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
338 	//     < SHERE_PFV_II_metadata_line_31_____AEROMAR_20240505 >									
339 	//        < N2ossY20KG1DU49r0qbm84vq3ITlQ0o7YycfhS8wD9BQFNrZg5z51OeS599gx1Q4 >									
340 	//        <  u =="0.000000000000000001" : ] 000000969034922.155496000000000000 ; 000000990427630.725584000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000005C6A1445E745CB >									
342 	//     < SHERE_PFV_II_metadata_line_32_____AEROMAR_ORG_20240505 >									
343 	//        < aN1R96P0lcHB4W0elGLjgQd222Gu3GzOzrd7Qgwl1J96pd3qfaAe8ooAr3ZzY4FD >									
344 	//        <  u =="0.000000000000000001" : ] 000000990427630.725584000000000000 ; 000001020729473.824740000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000005E745CB6158273 >									
346 	//     < SHERE_PFV_II_metadata_line_33_____BUDGET_CARRIER_20240505 >									
347 	//        < gN299321xIQ9HN2jF8AD13kyw9ITkAuF7I9Tv0nrma8fa1Rs08bs7Ax246qG2CQJ >									
348 	//        <  u =="0.000000000000000001" : ] 000001020729473.824740000000000000 ; 000001056029386.357780000000000000 ] >									
349 	//        < 0x00000000000000000000000000000000000000000000000000615827364B5F7B >									
350 	//     < SHERE_PFV_II_metadata_line_34_____BUDGET_CARRIER_ORG_20240505 >									
351 	//        < QsAJq24Xmq4HXgyTF0q6OQg3x5AINfKHb1V6PofWRBdbD7d0Cg0t620TQbh1DO16 >									
352 	//        <  u =="0.000000000000000001" : ] 000001056029386.357780000000000000 ; 000001072789505.150670000000000000 ] >									
353 	//        < 0x0000000000000000000000000000000000000000000000000064B5F7B664F267 >									
354 	//     < SHERE_PFV_II_metadata_line_35_____NATUSANA_20240505 >									
355 	//        < N46qA87n48Qv9IkA78PYg0DX3O8ET9460JO8snKchVza87zmce3Dupbu0x0l2gzm >									
356 	//        <  u =="0.000000000000000001" : ] 000001072789505.150670000000000000 ; 000001112623002.602250000000000000 ] >									
357 	//        < 0x00000000000000000000000000000000000000000000000000664F2676A1BA5C >									
358 	//     < SHERE_PFV_II_metadata_line_36_____NATUSANA_ORG_20240505 >									
359 	//        < j90TnqE9vp3F0D7Z8a867yeX0W7dK97PQdc6Jl8IE7XAvw2Nw2C32B4t5nIZxj7h >									
360 	//        <  u =="0.000000000000000001" : ] 000001112623002.602250000000000000 ; 000001142540396.551030000000000000 ] >									
361 	//        < 0x000000000000000000000000000000000000000000000000006A1BA5C6CF60D8 >									
362 	//     < SHERE_PFV_II_metadata_line_37_____AEROFLOT_PENSIONS_20240505 >									
363 	//        < D1m84vx27Z97CGY69WeI5B018B8i2r69TB7oCLE2xmoP8d0NZ8PPN79Fb8O1S5la >									
364 	//        <  u =="0.000000000000000001" : ] 000001142540396.551030000000000000 ; 000001160616144.550330000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000006CF60D86EAF5AE >									
366 	//     < SHERE_PFV_II_metadata_line_38_____AEROFLOT_MUTU_20240505 >									
367 	//        < z2R8YwZvy6RBdwMqe3X4dx5i03WyM6YGlBP245g38fDOaPvkCL7Kx9c8MzKwDV3H >									
368 	//        <  u =="0.000000000000000001" : ] 000001160616144.550330000000000000 ; 000001184876919.723560000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000006EAF5AE70FFA8C >									
370 	//     < SHERE_PFV_II_metadata_line_39_____AEROFLOT_CAPITAL_20240505 >									
371 	//        < PzIz4Px8EA5I4n2JusDAmz4cwT7DLQ0Dz2M8vHw30h45PIS7rFF8sNm08xvts24e >									
372 	//        <  u =="0.000000000000000001" : ] 000001184876919.723560000000000000 ; 000001204109851.429820000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000070FFA8C72D5369 >									
374 	//     < SHERE_PFV_II_metadata_line_40_____AEROFLOT_HOLDINGS_20240505 >									
375 	//        < J099KUE1n23MGK314TPjNOcsCza68EPXp0H5MB7kPjUUO4vG9b70MMlxmAja3Fsu >									
376 	//        <  u =="0.000000000000000001" : ] 000001204109851.429820000000000000 ; 000001224678853.849720000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000072D536974CB62D >									
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