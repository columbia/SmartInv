1 pragma solidity ^0.4.24;							// 0.4.24+commit.e67f0147.Emscripten.clang																									
2 	/*																																
3 																																	
4 																																	
5 	*/																																
6 	interface IERC20Token {																																
7 	      function totalSupply() public constant returns (uint);         																																
8 	      function balanceOf(address tokenlender) public constant returns (uint balance);         																																
9 	      function allowance(address tokenlender, address spender) public constant returns (uint remaining);         																																
10 	      function transfer(address to, uint tokens) public returns (bool success);         																																
11 	      function approve(address spender, uint tokens) public returns (bool success);         																																
12 	      function transferFrom(address from, address to, uint tokens) public returns (bool success);         																																
13 	//																																
14 	      event Transfer(address indexed from, address indexed to, uint tokens);         																																
15 	      event Approval(address indexed tokenlender, address indexed spender, uint tokens);																																
16 	}																																
17 	/*																																
18 																																	
19 	*/																																
20 	contract			LifeSet_008			{	// CPS88 Life Settlement beta 8																									
21 	//																																
22 	//																																
23 					// ownership.../.../.../.../.../																												
24 																																	
25 					address	owner	;																										
26 																																	
27 					function	detOwner		() 	public	{																							
28 						owner	=	0x694f59266d12e339047353a170e21233806ab900								;					
29 					}																												
30 																																	
31 					modifier	onlyOwner		() 		{																							
32 						require(msg.sender == owner )										;																	
33 						_;																											
34 					}																												
35 	/*																																
36 																																	
37 	*/																																
38 					uint256		public		consecutiveDeaths												;												
39 					uint256		public		lastHash												;												
40 																																	
41 		//			uint256		public		lastBlock_v1Hash_uint256												;												
42 					uint256		public		deathData_v1												;												
43 					bool		public		CLE_Beta_Pictoris												;												
44 																																	
45 					address		public		User_1		=	msg.sender									;												
46 					uint256		public		Standard_1		=	100000000000000000000 ;																					
47 	/*																																
48 																																	
49 																																	
50 																																	
51 																																	
52 																																	
53 																																	
54 																																	
55 																																	
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
80 	*/																																
81 	/*																																
82 																																	
83 																																	
84 																																	
85 																																	
86 																																	
87 	*/																																
88 					// part.I_fixe.../.../.../.../.../																												
89 	//																																
90 	/*	i	*/		uint256	public	DeathFactor_i					;																					
91 	/*	ii	*/		uint256	public	DeathFactor_ii					;																					
92 	/*	iii	*/		uint256	public	DeathFactor_iii					;																					
93 	/*	iv	*/		uint256	public	DeathFactor_iv					;																					
94 	/*	v	*/		uint256	public	DeathFactor_v					;																					
95 	/*	i	*/		uint256	public	LifeFactor_i					;																					
96 	/*	ii	*/		uint256	public	LifeFactor_ii					;																					
97 	/*	iii	*/		uint256	public	LifeFactor_iii					;																					
98 	/*	iv	*/		uint256	public	LifeFactor_iv					;																					
99 	/*	v	*/		uint256	public	LifeFactor_v					;																					
100 	/*	0	*/		uint256	public	lastBlock_f0					;																					
101 	/*	1	*/		uint256	public	lastBlock_f1					;																					
102 	/*	2	*/		uint256	public	lastBlock_f2					;																					
103 	/*	3	*/		uint256	public	lastBlock_f3					;																					
104 	/*	4	*/		uint256	public	lastBlock_f4					;																					
105 	/*	5	*/		uint256	public	lastBlock_f5					;																					
106 	/*	6	*/		uint256	public	lastBlock_f6					;																					
107 	/*	7	*/		uint256	public	lastBlock_f7					;																					
108 	/*	8	*/		uint256	public	lastBlock_f8					;																					
109 	/*	9	*/		uint256	public	lastBlock_f9					;																					
110 	/*	10	*/		uint256	public	lastBlock_f10					;																					
111 	/*	11	*/		uint256	public	lastBlock_f11					;																					
112 	/*	12	*/		uint256	public	lastBlock_f12					;																					
113 	/*	13	*/		uint256	public	lastBlock_f13					;																					
114 	/*	14	*/		uint256	public	lastBlock_f14					;																					
115 	/*	15	*/		uint256	public	lastBlock_f15					;																					
116 	/*	16	*/		uint256	public	lastBlock_f16					;																					
117 	/*	17	*/		uint256	public	lastBlock_f17					;																					
118 	/*	18	*/		uint256	public	lastBlock_f18					;																					
119 	/*	19	*/		uint256	public	lastBlock_f19					;																					
120 	/*	0	*/		uint256	public	lastBlock_f0Hash_uint256					;																					
121 	/*	1	*/		uint256	public	lastBlock_f1Hash_uint256					;																					
122 	/*	2	*/		uint256	public	lastBlock_f2Hash_uint256					;																					
123 	/*	3	*/		uint256	public	lastBlock_f3Hash_uint256					;																					
124 	/*	4	*/		uint256	public	lastBlock_f4Hash_uint256					;																					
125 	/*	5	*/		uint256	public	lastBlock_f5Hash_uint256					;																					
126 	/*	6	*/		uint256	public	lastBlock_f6Hash_uint256					;																					
127 	/*	7	*/		uint256	public	lastBlock_f7Hash_uint256					;																					
128 	/*	8	*/		uint256	public	lastBlock_f8Hash_uint256					;																					
129 	/*	9	*/		uint256	public	lastBlock_f9Hash_uint256					;																					
130 	/*	10	*/		uint256	public	lastBlock_f10Hash_uint256					;																					
131 	/*	11	*/		uint256	public	lastBlock_f11Hash_uint256					;																					
132 	/*	12	*/		uint256	public	lastBlock_f12Hash_uint256					;																					
133 	/*	13	*/		uint256	public	lastBlock_f13Hash_uint256					;																					
134 	/*	14	*/		uint256	public	lastBlock_f14Hash_uint256					;																					
135 	/*	15	*/		uint256	public	lastBlock_f15Hash_uint256					;																					
136 	/*	16	*/		uint256	public	lastBlock_f16Hash_uint256					;																					
137 	/*	17	*/		uint256	public	lastBlock_f17Hash_uint256					;																					
138 	/*	18	*/		uint256	public	lastBlock_f18Hash_uint256					;																					
139 	/*	19	*/		uint256	public	lastBlock_f19Hash_uint256					;																					
140 	/*	0	*/		uint256	public	deathData_f0					;																					
141 	/*	1	*/		uint256	public	deathData_f1					;																					
142 	/*	2	*/		uint256	public	deathData_f2					;																					
143 	/*	3	*/		uint256	public	deathData_f3					;																					
144 	/*	4	*/		uint256	public	deathData_f4					;																					
145 	/*	5	*/		uint256	public	deathData_f5					;																					
146 	/*	6	*/		uint256	public	deathData_f6					;																					
147 	/*	7	*/		uint256	public	deathData_f7					;																					
148 	/*	8	*/		uint256	public	deathData_f8					;																					
149 	/*	9	*/		uint256	public	deathData_f9					;																					
150 	/*	10	*/		uint256	public	deathData_f10					;																					
151 	/*	11	*/		uint256	public	deathData_f11					;																					
152 	/*	12	*/		uint256	public	deathData_f12					;																					
153 	/*	13	*/		uint256	public	deathData_f13					;																					
154 	/*	14	*/		uint256	public	deathData_f14					;																					
155 	/*	15	*/		uint256	public	deathData_f15					;																					
156 	/*	16	*/		uint256	public	deathData_f16					;																					
157 	/*	17	*/		uint256	public	deathData_f17					;																					
158 	/*	18	*/		uint256	public	deathData_f18					;																					
159 	/*	19	*/		uint256	public	deathData_f19					;																					
160 	/*																																
161 																																	
162 																																	
163 																																	
164 																																	
165 																																	
166 																																	
167 																																	
168 																																	
169 	*/																																
170 					// part.II_variable.../.../.../.../.../																												
171 	//																																
172 	//	i			uint256	public	DeathFactor_i					;																					
173 	//	ii			uint256	public	DeathFactor_ii					;																					
174 	//	iii			uint256	public	DeathFactor_iii					;																					
175 	//	iv			uint256	public	DeathFactor_iv					;																					
176 	//	v			uint256	public	DeathFactor_v					;																					
177 	//	i			uint256	public	LifeFactor_i					;																					
178 	//	ii			uint256	public	LifeFactor_ii					;																					
179 	//	iii			uint256	public	LifeFactor_iii					;																					
180 	//	iv			uint256	public	LifeFactor_iv					;																					
181 	//	v			uint256	public	LifeFactor_v					;																					
182 	/*	0	*/		uint256	public	lastBlock_v0					;																					
183 	/*	1	*/		uint256	public	lastBlock_v1					;																					
184 	/*	2	*/		uint256	public	lastBlock_v2					;																					
185 	/*	3	*/		uint256	public	lastBlock_v3					;																					
186 	/*	4	*/		uint256	public	lastBlock_v4					;																					
187 	/*	5	*/		uint256	public	lastBlock_v5					;																					
188 	/*	6	*/		uint256	public	lastBlock_v6					;																					
189 	/*	7	*/		uint256	public	lastBlock_v7					;																					
190 	/*	8	*/		uint256	public	lastBlock_v8					;																					
191 	/*	9	*/		uint256	public	lastBlock_v9					;																					
192 	/*	10	*/		uint256	public	lastBlock_v10					;																					
193 	/*	11	*/		uint256	public	lastBlock_v11					;																					
194 	/*	12	*/		uint256	public	lastBlock_v12					;																					
195 	/*	13	*/		uint256	public	lastBlock_v13					;																					
196 	/*	14	*/		uint256	public	lastBlock_v14					;																					
197 	/*	15	*/		uint256	public	lastBlock_v15					;																					
198 	/*	16	*/		uint256	public	lastBlock_v16					;																					
199 	/*	17	*/		uint256	public	lastBlock_v17					;																					
200 	/*	18	*/		uint256	public	lastBlock_v18					;																					
201 	/*	19	*/		uint256	public	lastBlock_v19					;																					
202 	/*	0	*/		uint256	public	lastBlock_v0Hash_uint256					;																					
203 	/*	1	*/		uint256	public	lastBlock_v1Hash_uint256					;																					
204 	/*	2	*/		uint256	public	lastBlock_v2Hash_uint256					;																					
205 	/*	3	*/		uint256	public	lastBlock_v3Hash_uint256					;																					
206 	/*	4	*/		uint256	public	lastBlock_v4Hash_uint256					;																					
207 	/*	5	*/		uint256	public	lastBlock_v5Hash_uint256					;																					
208 	/*	6	*/		uint256	public	lastBlock_v6Hash_uint256					;																					
209 	/*	7	*/		uint256	public	lastBlock_v7Hash_uint256					;																					
210 	/*	8	*/		uint256	public	lastBlock_v8Hash_uint256					;																					
211 	/*	9	*/		uint256	public	lastBlock_v9Hash_uint256					;																					
212 	/*	10	*/		uint256	public	lastBlock_v10Hash_uint256					;																					
213 	/*	11	*/		uint256	public	lastBlock_v11Hash_uint256					;																					
214 	/*	12	*/		uint256	public	lastBlock_v12Hash_uint256					;																					
215 	/*	13	*/		uint256	public	lastBlock_v13Hash_uint256					;																					
216 	/*	14	*/		uint256	public	lastBlock_v14Hash_uint256					;																					
217 	/*	15	*/		uint256	public	lastBlock_v15Hash_uint256					;																					
218 	/*	16	*/		uint256	public	lastBlock_v16Hash_uint256					;																					
219 	/*	17	*/		uint256	public	lastBlock_v17Hash_uint256					;																					
220 	/*	18	*/		uint256	public	lastBlock_v18Hash_uint256					;																					
221 	/*	19	*/		uint256	public	lastBlock_v19Hash_uint256					;																					
222 	/*	0	*/		uint256	public	deathData_v0					;																					
223 	//	1			uint256	public	deathData_v1					;		// confer ‘part.E’ & ‘part.E’’ p.10 pour la déclaration relative ;																			
224 	/*	2	*/		uint256	public	deathData_v2					;																					
225 	/*	3	*/		uint256	public	deathData_v3					;																					
226 	/*	4	*/		uint256	public	deathData_v4					;																					
227 	/*	5	*/		uint256	public	deathData_v5					;																					
228 	/*	6	*/		uint256	public	deathData_v6					;																					
229 	/*	7	*/		uint256	public	deathData_v7					;																					
230 	/*	8	*/		uint256	public	deathData_v8					;																					
231 	/*	9	*/		uint256	public	deathData_v9					;																					
232 	/*	10	*/		uint256	public	deathData_v10					;																					
233 	/*	11	*/		uint256	public	deathData_v11					;																					
234 	/*	12	*/		uint256	public	deathData_v12					;																					
235 	/*	13	*/		uint256	public	deathData_v13					;																					
236 	/*	14	*/		uint256	public	deathData_v14					;																					
237 	/*	15	*/		uint256	public	deathData_v15					;																					
238 	/*	16	*/		uint256	public	deathData_v16					;																					
239 	/*	17	*/		uint256	public	deathData_v17					;																					
240 	/*	18	*/		uint256	public	deathData_v18					;																					
241 	/*	19	*/		uint256	public	deathData_v19					;																					
242 	/*																																
243 																																	
244 																																	
245 																																	
246 																																	
247 																																	
248 																																	
249 																																	
250 																																	
251 	*/																																
252 					// part.III_active.../.../.../.../.../																												
253 	//																																
254 	//	i			uint256	public	DeathFactor_i					;																					
255 	//	ii			uint256	public	DeathFactor_ii					;																					
256 	//	iii			uint256	public	DeathFactor_iii					;																					
257 	//	iv			uint256	public	DeathFactor_iv					;																					
258 	//	v			uint256	public	DeathFactor_v					;																					
259 	//	i			uint256	public	LifeFactor_i					;																					
260 	//	ii			uint256	public	LifeFactor_ii					;																					
261 	//	iii			uint256	public	LifeFactor_iii					;																					
262 	//	iv			uint256	public	LifeFactor_iv					;																					
263 	//	v			uint256	public	LifeFactor_v					;																					
264 	/*	0	*/		uint256	public	lastBlock_a0					;																					
265 	/*	1	*/		uint256	public	lastBlock_a1					;																					
266 	/*	2	*/		uint256	public	lastBlock_a2					;																					
267 	/*	3	*/		uint256	public	lastBlock_a3					;																					
268 	/*	4	*/		uint256	public	lastBlock_a4					;																					
269 	/*	5	*/		uint256	public	lastBlock_a5					;																					
270 	/*	6	*/		uint256	public	lastBlock_a6					;																					
271 	/*	7	*/		uint256	public	lastBlock_a7					;																					
272 	/*	8	*/		uint256	public	lastBlock_a8					;																					
273 	/*	9	*/		uint256	public	lastBlock_a9					;																					
274 	/*	10	*/		uint256	public	lastBlock_a10					;																					
275 	/*	11	*/		uint256	public	lastBlock_a11					;																					
276 	/*	12	*/		uint256	public	lastBlock_a12					;																					
277 	/*	13	*/		uint256	public	lastBlock_a13					;																					
278 	/*	14	*/		uint256	public	lastBlock_a14					;																					
279 	/*	15	*/		uint256	public	lastBlock_a15					;																					
280 	/*	16	*/		uint256	public	lastBlock_a16					;																					
281 	/*	17	*/		uint256	public	lastBlock_a17					;																					
282 	/*	18	*/		uint256	public	lastBlock_a18					;																					
283 	/*	19	*/		uint256	public	lastBlock_a19					;																					
284 	/*	0	*/		uint256	public	lastBlock_a0Hash_uint256					;																					
285 	/*	1	*/		uint256	public	lastBlock_a1Hash_uint256					;																					
286 	/*	2	*/		uint256	public	lastBlock_a2Hash_uint256					;																					
287 	/*	3	*/		uint256	public	lastBlock_a3Hash_uint256					;																					
288 	/*	4	*/		uint256	public	lastBlock_a4Hash_uint256					;																					
289 	/*	5	*/		uint256	public	lastBlock_a5Hash_uint256					;																					
290 	/*	6	*/		uint256	public	lastBlock_a6Hash_uint256					;																					
291 	/*	7	*/		uint256	public	lastBlock_a7Hash_uint256					;																					
292 	/*	8	*/		uint256	public	lastBlock_a8Hash_uint256					;																					
293 	/*	9	*/		uint256	public	lastBlock_a9Hash_uint256					;																					
294 	/*	10	*/		uint256	public	lastBlock_a10Hash_uint256					;																					
295 	/*	11	*/		uint256	public	lastBlock_a11Hash_uint256					;																					
296 	/*	12	*/		uint256	public	lastBlock_a12Hash_uint256					;																					
297 	/*	13	*/		uint256	public	lastBlock_a13Hash_uint256					;																					
298 	/*	14	*/		uint256	public	lastBlock_a14Hash_uint256					;																					
299 	/*	15	*/		uint256	public	lastBlock_a15Hash_uint256					;																					
300 	/*	16	*/		uint256	public	lastBlock_a16Hash_uint256					;																					
301 	/*	17	*/		uint256	public	lastBlock_a17Hash_uint256					;																					
302 	/*	18	*/		uint256	public	lastBlock_a18Hash_uint256					;																					
303 	/*	19	*/		uint256	public	lastBlock_a19Hash_uint256					;																					
304 	/*	0	*/		uint256	public	deathData_a0					;																					
305 	/*	1	*/		uint256	public	deathData_a1					;																					
306 	/*	2	*/		uint256	public	deathData_a2					;																					
307 	/*	3	*/		uint256	public	deathData_a3					;																					
308 	/*	4	*/		uint256	public	deathData_a4					;																					
309 	/*	5	*/		uint256	public	deathData_a5					;																					
310 	/*	6	*/		uint256	public	deathData_a6					;																					
311 	/*	7	*/		uint256	public	deathData_a7					;																					
312 	/*	8	*/		uint256	public	deathData_a8					;																					
313 	/*	9	*/		uint256	public	deathData_a9					;																					
314 	/*	10	*/		uint256	public	deathData_a10					;																					
315 	/*	11	*/		uint256	public	deathData_a11					;																					
316 	/*	12	*/		uint256	public	deathData_a12					;																					
317 	/*	13	*/		uint256	public	deathData_a13					;																					
318 	/*	14	*/		uint256	public	deathData_a14					;																					
319 	/*	15	*/		uint256	public	deathData_a15					;																					
320 	/*	16	*/		uint256	public	deathData_a16					;																					
321 	/*	17	*/		uint256	public	deathData_a17					;																					
322 	/*	18	*/		uint256	public	deathData_a18					;																					
323 	/*	19	*/		uint256	public	deathData_a19					;																					
324 	/*																																
325 																																	
326 																																	
327 																																	
328 																																	
329 																																	
330 																																	
331 																																	
332 																																	
333 	*/																																
334 					// part.I_fixe_assignation.../.../.../.../.../																												
335 	//																																
336 					function	LifeSet_008		() 	public	{	// constructeur																						
337 	/*	i	*/			DeathFactor_i	=	57896044618658097711785492504343953926634992332820282019728792003956564819968		;					
338 	/*	ii	*/			DeathFactor_ii					=	21807848692836600000000000000										;					
339 	/*	iii	*/			DeathFactor_iii					=	21079851993102300000000000000										;					
340 	/*	iv	*/			DeathFactor_iv					=	96991823642008000000000000000										;					
341 	/*	v	*/			DeathFactor_v					=	23715149500320100000000000000										;					
342 	/*	i	*/			LifeFactor_i					=	72342521561722900000000000000										;					
343 	/*	ii	*/			LifeFactor_ii					=	28761789998958900000000000000										;					
344 	/*	iii	*/			LifeFactor_iii					=	49073762341743800000000000000										;					
345 	/*	iv	*/			LifeFactor_iv					=	69895676296429600000000000000										;					
346 	/*	v	*/			LifeFactor_v					=	36799331971979100000000000000										;					
347 	/*	0	*/			lastBlock_f0					=	(block.number)										;											
348 	/*	1	*/			lastBlock_f1					=	(block.number-1)										;											
349 	/*	2	*/			lastBlock_f2					=	(block.number-2)										;											
350 	/*	3	*/			lastBlock_f3					=	(block.number-3)										;											
351 	/*	4	*/			lastBlock_f4					=	(block.number-4)										;											
352 	/*	5	*/			lastBlock_f5					=	(block.number-5)										;											
353 	/*	6	*/			lastBlock_f6					=	(block.number-6)										;											
354 	/*	7	*/			lastBlock_f7					=	(block.number-7)										;											
355 	/*	8	*/			lastBlock_f8					=	(block.number-8)										;											
356 	/*	9	*/			lastBlock_f9					=	(block.number-9)										;											
357 	/*	10	*/			lastBlock_f10					=	(block.number-10)										;											
358 	/*	11	*/			lastBlock_f11					=	(block.number-11)										;											
359 	/*	12	*/			lastBlock_f12					=	(block.number-12)										;											
360 	/*	13	*/			lastBlock_f13					=	(block.number-13)										;											
361 	/*	14	*/			lastBlock_f14					=	(block.number-14)										;											
362 	/*	15	*/			lastBlock_f15					=	(block.number-15)										;											
363 	/*	16	*/			lastBlock_f16					=	(block.number-16)										;											
364 	/*	17	*/			lastBlock_f17					=	(block.number-17)										;											
365 	/*	18	*/			lastBlock_f18					=	(block.number-18)										;											
366 	/*	19	*/			lastBlock_f19					=	(block.number-19)										;											
367 	/*	0	*/			lastBlock_f0Hash_uint256					=	uint256(block.blockhash(block.number))								;											
368 	/*	1	*/			lastBlock_f1Hash_uint256					=	uint256(block.blockhash(block.number-1))								;											
369 	/*	2	*/			lastBlock_f2Hash_uint256					=	uint256(block.blockhash(block.number-2))								;											
370 	/*	3	*/			lastBlock_f3Hash_uint256					=	uint256(block.blockhash(block.number-3))								;											
371 	/*	4	*/			lastBlock_f4Hash_uint256					=	uint256(block.blockhash(block.number-4))								;											
372 	/*	5	*/			lastBlock_f5Hash_uint256					=	uint256(block.blockhash(block.number-5))								;											
373 	/*	6	*/			lastBlock_f6Hash_uint256					=	uint256(block.blockhash(block.number-6))								;											
374 	/*	7	*/			lastBlock_f7Hash_uint256					=	uint256(block.blockhash(block.number-7))								;											
375 	/*	8	*/			lastBlock_f8Hash_uint256					=	uint256(block.blockhash(block.number-8))								;											
376 	/*	9	*/			lastBlock_f9Hash_uint256					=	uint256(block.blockhash(block.number-9))								;											
377 	/*	10	*/			lastBlock_f10Hash_uint256					=	uint256(block.blockhash(block.number-10))						;											
378 	/*	11	*/			lastBlock_f11Hash_uint256					=	uint256(block.blockhash(block.number-11))							;											
379 	/*	12	*/			lastBlock_f12Hash_uint256					=	uint256(block.blockhash(block.number-12))							;											
380 	/*	13	*/			lastBlock_f13Hash_uint256					=	uint256(block.blockhash(block.number-13))							;											
381 	/*	14	*/			lastBlock_f14Hash_uint256					=	uint256(block.blockhash(block.number-14))							;											
382 	/*	15	*/			lastBlock_f15Hash_uint256					=	uint256(block.blockhash(block.number-15))							;											
383 	/*	16	*/			lastBlock_f16Hash_uint256					=	uint256(block.blockhash(block.number-16))							;											
384 	/*	17	*/			lastBlock_f17Hash_uint256					=	uint256(block.blockhash(block.number-17))							;											
385 	/*	18	*/			lastBlock_f18Hash_uint256					=	uint256(block.blockhash(block.number-18))							;											
386 	/*	19	*/			lastBlock_f19Hash_uint256					=	uint256(block.blockhash(block.number-19))							;											
387 	/*	0	*/			deathData_f0					=	uint256(block.blockhash(block.number)) / DeathFactor_i							;											
388 	/*	1	*/			deathData_f1					=	uint256(block.blockhash(block.number-1)) / DeathFactor_i							;											
389 	/*	2	*/			deathData_f2					=	uint256(block.blockhash(block.number-2)) / DeathFactor_i							;											
390 	/*	3	*/			deathData_f3					=	uint256(block.blockhash(block.number-3)) / DeathFactor_i							;											
391 	/*	4	*/			deathData_f4					=	uint256(block.blockhash(block.number-4)) / DeathFactor_i							;											
392 	/*	5	*/			deathData_f5					=	uint256(block.blockhash(block.number-5)) / DeathFactor_i							;											
393 	/*	6	*/			deathData_f6					=	uint256(block.blockhash(block.number-6)) / DeathFactor_i							;											
394 	/*	7	*/			deathData_f7					=	uint256(block.blockhash(block.number-7)) / DeathFactor_i							;											
395 	/*	8	*/			deathData_f8					=	uint256(block.blockhash(block.number-8)) / DeathFactor_i							;											
396 	/*	9	*/			deathData_f9					=	uint256(block.blockhash(block.number-9)) / DeathFactor_i							;											
397 	/*	10	*/			deathData_f10					=	uint256(block.blockhash(block.number-10)) / DeathFactor_i					;											
398 	/*	11	*/			deathData_f11					=	uint256(block.blockhash(block.number-11)) / DeathFactor_i						;											
399 	/*	12	*/			deathData_f12					=	uint256(block.blockhash(block.number-12)) / DeathFactor_i						;											
400 	/*	13	*/			deathData_f13					=	uint256(block.blockhash(block.number-13)) / DeathFactor_i						;											
401 	/*	14	*/			deathData_f14					=	uint256(block.blockhash(block.number-14)) / DeathFactor_i						;											
402 	/*	15	*/			deathData_f15					=	uint256(block.blockhash(block.number-15)) / DeathFactor_i						;											
403 	/*	16	*/			deathData_f16					=	uint256(block.blockhash(block.number-16)) / DeathFactor_i						;											
404 	/*	17	*/			deathData_f17					=	uint256(block.blockhash(block.number-17)) / DeathFactor_i						;											
405 	/*	18	*/			deathData_f18					=	uint256(block.blockhash(block.number-18)) / DeathFactor_i						;											
406 	/*	19	*/			deathData_f19					=	uint256(block.blockhash(block.number-19)) / DeathFactor_i						;											
407 					}																										
408 	/*																																
409 																																	
410 	*/																																
411 						// part.A_eligibility_inputs.../.../.../.../.../																											
412 	//																																
413 	//	0	*/			address 	public	User_1				=	msg.sender									;		
414 	/*	1	*/			address 	public	User_2		;	//  	=	_User_2									;											
415 	/*	2	*/			address 	public	User_3		;	//  	=	_User_3									;											
416 	/*	3	*/			address 	public	User_4		;	//  	=	_User_4									;											
417 	/*	4	*/			address 	public	User_5		;	//  	=	_User_5									;											
418 	//																																
419 	/*	0	*/			IERC20Token		public	Securities_1		;	//  	_Securities_1									;
420 	/*	1	*/			IERC20Token		public	Securities_2		;	//  	_Securities_2									;											
421 	/*	2	*/			IERC20Token		public	Securities_3		;	//  	_Securities_3									;											
422 	/*	3	*/			IERC20Token		public	Securities_4		;	//  	_Securities_4									;											
423 	/*	4	*/			IERC20Token		public	Securities_5		;	//  	_Securities_5									;											
424 	//																																
425 	//	0	*/			uint256		public	Standard_1		;	//  	_Standard_1									;	
426 	/*	1	*/			uint256		public	Standard_2		;	//  	_Standard_2									;											
427 	/*	2	*/			uint256		public	Standard_3		;	//  	_Standard_3									;											
428 	/*	3	*/			uint256		public	Standard_4		;	//  	_Standard_4									;											
429 	/*	4	*/			uint256		public	Standard_5		;	//  	_Standard_5									;											
430 	/*																																
431 																																	
432 	*/																																
433 						// part.B_eligibility_functions.../.../.../.../.../																											
434 	//																																
435 	/*	0	*/			function	Eligibility_Group_1					( 																					
436 	/*	1	*/				address		_User_1		,																						
437 	/*	2	*/				IERC20Token		_Securities_1		,																						
438 	/*	3	*/				uint256		_Standard_1																								
439 	/*	4	*/			)																											
440 	/*	5	*/				public		onlyOwner																								
441 	/*	6	*/			{																											
442 	//	7	*/				User_1		=	_User_1		;																					
443 	/*	8	*/				Securities_1		=	_Securities_1		;																					
444 	//	9	*/				Standard_1		=	_Standard_1		;																					
445 	/*	10	*/			}																											
446 	/*	0	*/			function	Eligibility_Group_2					( 																					
447 	/*	1	*/				address		_User_2		,																						
448 	/*	2	*/				IERC20Token		_Securities_2		,																						
449 	/*	3	*/				uint256		_Standard_2																								
450 	/*	4	*/			)																											
451 	/*	5	*/				public		onlyOwner																								
452 	/*	6	*/			{																											
453 	/*	7	*/				User_2		=	_User_2		;																					
454 	/*	8	*/				Securities_2		=	_Securities_2		;																					
455 	/*	9	*/				Standard_2		=	_Standard_2		;																					
456 	/*	10	*/			}																											
457 	/*	0	*/			function	Eligibility_Group_3					( 																					
458 	/*	1	*/				address		_User_3		,																						
459 	/*	2	*/				IERC20Token		_Securities_3		,																						
460 	/*	3	*/				uint256		_Standard_3																								
461 	/*	4	*/			)																											
462 	/*	5	*/				public		onlyOwner																								
463 	/*	6	*/			{																											
464 	/*	7	*/				User_3		=	_User_3		;																					
465 	/*	8	*/				Securities_3		=	_Securities_3		;																					
466 	/*	9	*/				Standard_3		=	_Standard_3		;																					
467 	/*	10	*/			}																											
468 	/*	0	*/			function	Eligibility_Group_4					( 																					
469 	/*	1	*/				address		_User_4		,																						
470 	/*	2	*/				IERC20Token		_Securities_4		,																						
471 	/*	3	*/				uint256		_Standard_4																								
472 	/*	4	*/			)																											
473 	/*	5	*/				public		onlyOwner																								
474 	/*	6	*/			{																											
475 	/*	7	*/				User_4		=	_User_4		;																					
476 	/*	8	*/				Securities_4		=	_Securities_4		;																					
477 	/*	9	*/				Standard_4		=	_Standard_4		;																					
478 	/*	10	*/			}																											
479 	/*	0	*/			function	Eligibility_Group_5					( 																					
480 	/*	1	*/				address		_User_5		,																						
481 	/*	2	*/				IERC20Token		_Securities_5		,																						
482 	/*	3	*/				uint256		_Standard_5																								
483 	/*	4	*/			)																											
484 	/*	5	*/				public		onlyOwner																								
485 	/*	6	*/			{																											
486 	/*	7	*/				User_5		=	_User_5		;																					
487 	/*	8	*/				Securities_5		=	_Securities_5		;																					
488 	/*	9	*/				Standard_5		=	_Standard_5		;																					
489 	/*	10	*/			}																											
490 	/*																																
491 																																	
492 																																	
493 																																	
494 																																	
495 																																	
496 																																	
497 	*/																																
498 						// part.II_variable_assignation.../.../.../.../.../																											
499 	//																																
500 function	ReinsureSeveralDeaths	(bool _hedge		) public returns ( bool	) {						
501 	//	i	*/				DeathFactor_i					=															;				
502 	//	ii	*/				DeathFactor_ii					=	94688065443371500000000000000										;				
503 	//	iii	*/				DeathFactor_iii					=	8095242467221090000000000000										;				
504 	//	iv	*/				DeathFactor_iv					=	70848091325669100000000000000										;				
505 	//	v	*/				DeathFactor_v					=	21173149574191900000000000000										;				
506 	//	i	*/				LifeFactor_i					=	74559480568093600000000000000										;				
507 	//	ii	*/				LifeFactor_ii					=	31797319262872900000000000000										;				
508 	//	iii	*/				LifeFactor_iii					=	64530670832690800000000000000										;				
509 	//	iv	*/				LifeFactor_iv					=	56232775078129000000000000000										;				
510 	//	v	*/				LifeFactor_v					=	35086346921014300000000000000										;				
511 	/*	0	*/				lastBlock_v0					=	(block.number)										;										
512 	/*	1	*/				lastBlock_v1					=	(block.number-1)										;										
513 	/*	2	*/				lastBlock_v2					=	(block.number-2)										;										
514 	/*	3	*/				lastBlock_v3					=	(block.number-3)										;										
515 	/*	4	*/				lastBlock_v4					=	(block.number-4)										;										
516 	/*	5	*/				lastBlock_v5					=	(block.number-5)										;										
517 	/*	6	*/				lastBlock_v6					=	(block.number-6)										;										
518 	/*	7	*/				lastBlock_v7					=	(block.number-7)										;										
519 	/*	8	*/				lastBlock_v8					=	(block.number-8)										;										
520 	/*	9	*/				lastBlock_v9					=	(block.number-9)										;										
521 	/*	10	*/				lastBlock_v10					=	(block.number-10)										;										
522 	/*	11	*/				lastBlock_v11					=	(block.number-11)										;										
523 	/*	12	*/				lastBlock_v12					=	(block.number-12)										;										
524 	/*	13	*/				lastBlock_v13					=	(block.number-13)										;										
525 	/*	14	*/				lastBlock_v14					=	(block.number-14)										;										
526 	/*	15	*/				lastBlock_v15					=	(block.number-15)										;										
527 	/*	16	*/				lastBlock_v16					=	(block.number-16)										;										
528 	/*	17	*/				lastBlock_v17					=	(block.number-17)										;										
529 	/*	18	*/				lastBlock_v18					=	(block.number-18)										;										
530 	/*	19	*/				lastBlock_v19					=	(block.number-19)										;										
531 	/*	0	*/				lastBlock_v0Hash_uint256					=	uint256(block.blockhash(block.number))							;										
532 	//	1	*/				lastBlock_v1Hash_uint256					=	uint256(block.blockhash(block.number-1))							;										
533 	/*	2	*/				lastBlock_v2Hash_uint256					=	uint256(block.blockhash(block.number-2))							;										
534 	/*	3	*/				lastBlock_v3Hash_uint256					=	uint256(block.blockhash(block.number-3))							;										
535 	/*	4	*/				lastBlock_v4Hash_uint256					=	uint256(block.blockhash(block.number-4))							;										
536 	/*	5	*/				lastBlock_v5Hash_uint256					=	uint256(block.blockhash(block.number-5))							;										
537 	/*	6	*/				lastBlock_v6Hash_uint256					=	uint256(block.blockhash(block.number-6))							;										
538 	/*	7	*/				lastBlock_v7Hash_uint256					=	uint256(block.blockhash(block.number-7))							;										
539 	/*	8	*/				lastBlock_v8Hash_uint256					=	uint256(block.blockhash(block.number-8))							;										
540 	/*	9	*/				lastBlock_v9Hash_uint256					=	uint256(block.blockhash(block.number-9))							;										
541 	/*	10	*/				lastBlock_v10Hash_uint256					=	uint256(block.blockhash(block.number-10))						;										
542 	/*	11	*/				lastBlock_v11Hash_uint256					=	uint256(block.blockhash(block.number-11))						;										
543 	/*	12	*/				lastBlock_v12Hash_uint256					=	uint256(block.blockhash(block.number-12))						;										
544 	/*	13	*/				lastBlock_v13Hash_uint256					=	uint256(block.blockhash(block.number-13))						;										
545 	/*	14	*/				lastBlock_v14Hash_uint256					=	uint256(block.blockhash(block.number-14))						;										
546 	/*	15	*/				lastBlock_v15Hash_uint256					=	uint256(block.blockhash(block.number-15))						;										
547 	/*	16	*/				lastBlock_v16Hash_uint256					=	uint256(block.blockhash(block.number-16))						;										
548 	/*	17	*/				lastBlock_v17Hash_uint256					=	uint256(block.blockhash(block.number-17))						;										
549 	/*	18	*/				lastBlock_v18Hash_uint256					=	uint256(block.blockhash(block.number-18))						;										
550 	/*	19	*/				lastBlock_v19Hash_uint256					=	uint256(block.blockhash(block.number-19))						;										
551 	/*	0	*/				deathData_v0					=	uint256(block.blockhash(block.number)) / DeathFactor_i						;										
552 	/*	1	*/				deathData_v1					=	uint256(block.blockhash(block.number-1)) / DeathFactor_i						;										
553 	/*	2	*/				deathData_v2					=	uint256(block.blockhash(block.number-2)) / DeathFactor_i						;										
554 	/*	3	*/				deathData_v3					=	uint256(block.blockhash(block.number-3)) / DeathFactor_i						;										
555 	/*	4	*/				deathData_v4					=	uint256(block.blockhash(block.number-4)) / DeathFactor_i						;										
556 	/*	5	*/				deathData_v5					=	uint256(block.blockhash(block.number-5)) / DeathFactor_i						;										
557 	/*	6	*/				deathData_v6					=	uint256(block.blockhash(block.number-6)) / DeathFactor_i						;										
558 	/*	7	*/				deathData_v7					=	uint256(block.blockhash(block.number-7)) / DeathFactor_i						;										
559 	/*	8	*/				deathData_v8					=	uint256(block.blockhash(block.number-8)) / DeathFactor_i						;										
560 	/*	9	*/				deathData_v9					=	uint256(block.blockhash(block.number-9)) / DeathFactor_i						;										
561 	/*	10	*/				deathData_v10					=	uint256(block.blockhash(block.number-10)) / DeathFactor_i				;									
562 	/*	11	*/				deathData_v11					=	uint256(block.blockhash(block.number-11)) / DeathFactor_i					;										
563 	/*	12	*/				deathData_v12					=	uint256(block.blockhash(block.number-12)) / DeathFactor_i					;										
564 	/*	13	*/				deathData_v13					=	uint256(block.blockhash(block.number-13)) / DeathFactor_i					;										
565 	/*	14	*/				deathData_v14					=	uint256(block.blockhash(block.number-14)) / DeathFactor_i					;										
566 	/*	15	*/				deathData_v15					=	uint256(block.blockhash(block.number-15)) / DeathFactor_i					;										
567 	/*	16	*/				deathData_v16					=	uint256(block.blockhash(block.number-16)) / DeathFactor_i					;										
568 	/*	17	*/				deathData_v17					=	uint256(block.blockhash(block.number-17)) / DeathFactor_i					;										
569 	/*	18	*/				deathData_v18					=	uint256(block.blockhash(block.number-18)) / DeathFactor_i					;										
570 	/*	19	*/				deathData_v19					=	uint256(block.blockhash(block.number-19)) / DeathFactor_i					;																											
571 															
572 	//																																
573 							consecutiveDeaths						=	0	;																		
574 	//																																
575 /* uint256 */		lastBlock_v1Hash_uint256				=	uint256(block.blockhash(block.number-1))									;					
576 	//																																
577 							if	(	lastHash				==	lastBlock_v1Hash_uint256						)	{												
578 									revert				()	;																			
579 							}																										
580 	//																																
581 							lastHash				=	lastBlock_v1Hash_uint256						;															
582 			/* uint256 */		deathData_v1				=	lastBlock_v1Hash_uint256						/	DeathFactor_i				;								
583 							/* bool */		CLE_Beta_Pictoris				=	deathData_v1				==	1	?	true	:	false	;									
584 	//																																
585 							if	(	CLE_Beta_Pictoris				==	_hedge		)	{																
586 									consecutiveDeaths				++	;																			
587 									return				true	;																			
588 									/* address */		/* public */		User_1		=	msg.sender						;											
589 	//			IERC20Token		/* public */		Securities_1		=	"0xd0a8B8D49cd9fA798171b36F2297bEc75981c358"						;											
590 									/* uint256 */		/* public */		Standard_1		=	100000000000000000000						;											
591 									require(		Securities_1		.transfer(		User_1		,	Standard_1		)	)	;											
592 							}	else	{																								
593 									consecutiveDeaths				=	0	;																		
594 									return				false	;																			
595 							}																										
596 						}																											
597 																																	
598 						function	Withdraw_1					()	public		{																		
599 							require(		msg.sender			==	0x694f59266d12e339047353a170e21233806ab900						)	;											
600 //							require(		ID_1			==	ID_control_1								)	;											
601 //							require(		Cmd_1			==	Cmd_control_1								)	;											
602 	//						require(		Depositary_function_1			==	Depositary_function_control_1								)	;											
603 	require(		Securities_1			.transfer(		0x694f59266d12e339047353a170e21233806ab900,	100000000000000000000			) )	;											
604 						}																											
605 						function	Withdraw_2					()	public		{																		
606 							require(		msg.sender			==	User_2								)	;											
607 //							require(		ID_2			==	ID_control_2								)	;											
608 //							require(		Cmd_2			==	Cmd_control_2								)	;											
609 	//						require(		Depositary_function_2			==	Depositary_function_control_2								)	;											
610 							require(		Securities_2			.transfer(		User_2			,	Standard_2			) )	;											
611 						}																											
612 						function	Withdraw_3					()	public		{																		
613 							require(		msg.sender			==	User_3								)	;											
614 //							require(		ID_3			==	ID_control_3								)	;											
615 //							require(		Cmd_3			==	Cmd_control_3								)	;											
616 	//						require(		Depositary_function_3			==	Depositary_function_control_3								)	;											
617 							require(		Securities_3			.transfer(		User_3			,	Standard_3			) )	;											
618 						}																											
619 						function	Withdraw_4					()	public		{																		
620 							require(		msg.sender			==	User_4								)	;											
621 //							require(		ID_4			==	ID_control_4								)	;											
622 //							require(		Cmd_4			==	Cmd_control_4								)	;											
623 	//						require(		Depositary_function_4			==	Depositary_function_control_4								)	;											
624 							require(		Securities_4			.transfer(		User_4			,	Standard_4			) )	;											
625 						}																											
626 						function	Withdraw_5					()	public		{																		
627 							require(		msg.sender			==	0x694f59266d12e339047353a170e21233806ab900						)	;											
628 //							require(		ID_5			==	ID_control_5								)	;											
629 //							require(		Cmd_5			==	Cmd_control_5								)	;											
630 	//						require(		Depositary_function_5			==	Depositary_function_control_5								)	;											
631 							require(		Securities_5			.transfer(		User_5			,	Standard_5			) )	;											
632 						}																																																																																									
633 					}