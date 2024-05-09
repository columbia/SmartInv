1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	BANK_I_PFIII_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	BANK_I_PFIII_883		"	;
8 		string	public		symbol =	"	BANK_I_PFIII_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		439277148342774000000000000					;	
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
92 	//     < BANK_I_PFIII_metadata_line_1_____HEIDELBERG_Stadt_20260508 >									
93 	//        < Ag45GPnE650Np8xJ4T88BKY8w90ZwKqD38uWK7EDE41sZL7kGXgix6VPHIV02051 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000010762101.009513700000000000 ] >									
95 	//        < 0x0000000000000000000000000000000000000000000000000000000000106BF2 >									
96 	//     < BANK_I_PFIII_metadata_line_2_____SAARBRUECKEN_Stadt_20260508 >									
97 	//        < 6F03ECBT6p5lk6or1sia85CSj2TGQ5MciUv6xpyOfR6Og31HSYO7T089Q14ela2J >									
98 	//        <  u =="0.000000000000000001" : ] 000000010762101.009513700000000000 ; 000000021909802.028891300000000000 ] >									
99 	//        < 0x0000000000000000000000000000000000000000000000000000106BF2216E84 >									
100 	//     < BANK_I_PFIII_metadata_line_3_____KAISERSLAUTERN_Stadt_20260508 >									
101 	//        < 359li249021R8xom4EI2zO167eMI96KioOrPM16Cr7qr4iwvu7F7KQ56oofJ2KDI >									
102 	//        <  u =="0.000000000000000001" : ] 000000021909802.028891300000000000 ; 000000033014610.982483400000000000 ] >									
103 	//        < 0x0000000000000000000000000000000000000000000000000000216E84326055 >									
104 	//     < BANK_I_PFIII_metadata_line_4_____KOBLENZ_Stadt_20260508 >									
105 	//        < jo1AgpENN6zYq7Z3N5dj930faM8ABSxo5Olf6QAaGTBRCZd7r87KY1QgTMJACfGg >									
106 	//        <  u =="0.000000000000000001" : ] 000000033014610.982483400000000000 ; 000000043705031.166655000000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000032605542B047 >									
108 	//     < BANK_I_PFIII_metadata_line_5_____MAINZ_Stadt_20260508 >									
109 	//        < ua6YkSjQ7V263H9zhMMRv33WV1KEc0aKcvn8igWx487JG4z55C6gi9wQOoajA2eE >									
110 	//        <  u =="0.000000000000000001" : ] 000000043705031.166655000000000000 ; 000000054841304.596141400000000000 ] >									
111 	//        < 0x000000000000000000000000000000000000000000000000000042B04753AE62 >									
112 	//     < BANK_I_PFIII_metadata_line_6_____RUESSELSHEIM_AM_MAIN_Stadt_20260508 >									
113 	//        < JOZLGWCJ7wDwWA2iDJ7Wjehs1le7NxbHox85iiwE3DaX67KoRe0904R230At3Wu2 >									
114 	//        <  u =="0.000000000000000001" : ] 000000054841304.596141400000000000 ; 000000065604508.225039000000000000 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000000000053AE62641AC3 >									
116 	//     < BANK_I_PFIII_metadata_line_7_____INGELHEIM_AM_RHEIN_Stadt_20260508 >									
117 	//        < 7b495dbP60cJlsXpfHj8Ma87Ay1iyqRX9Z3zVw3hskr9XCQg9YjXoP1c4qd4T3d2 >									
118 	//        <  u =="0.000000000000000001" : ] 000000065604508.225039000000000000 ; 000000076394057.348761000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000641AC374916E >									
120 	//     < BANK_I_PFIII_metadata_line_8_____WIESBADEN_Stadt_20260508 >									
121 	//        < pvNdlIJhO7UNL975Y3RFi289R2F14D6ycYp36DKmP9SPL5Q3jr6jpeN940GtFx26 >									
122 	//        <  u =="0.000000000000000001" : ] 000000076394057.348761000000000000 ; 000000087406339.187522000000000000 ] >									
123 	//        < 0x000000000000000000000000000000000000000000000000000074916E855F1A >									
124 	//     < BANK_I_PFIII_metadata_line_9_____FRANKFURT_AM_MAIN_Stadt_20260508 >									
125 	//        < xhFxj5f8i783zh2XCQU6kz2IEcmL1kh8Fg8Czq9iBdBRxewm6VP3d8F0p9kWSI3V >									
126 	//        <  u =="0.000000000000000001" : ] 000000087406339.187522000000000000 ; 000000098272785.715595500000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000000855F1A95F3CF >									
128 	//     < BANK_I_PFIII_metadata_line_10_____DARMSTADT_Stadt_20260508 >									
129 	//        < 90H8RTIZPZCIc8hHzy8SDglU0958f0L47pfdp9o88ZQ08U4f695v9Pwl4raluWUv >									
130 	//        <  u =="0.000000000000000001" : ] 000000098272785.715595500000000000 ; 000000109462203.387655000000000000 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000000000095F3CFA706AC >									
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
174 	//     < BANK_I_PFIII_metadata_line_11_____LUDWIGSHAFEN_Stadt_20260508 >									
175 	//        < 3eBFSRjDhr43Ls93Z38Q8926famFkT641MRN9eE0uoU1Oyda6JX9qzh08GZ8CyhE >									
176 	//        <  u =="0.000000000000000001" : ] 000000109462203.387655000000000000 ; 000000120671268.483326000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000000A706ACB82137 >									
178 	//     < BANK_I_PFIII_metadata_line_12_____MANNHEIM_Stadt_20260508 >									
179 	//        < ay9i6AB2e92y6vi1YEpNSPv07Plqp35G7F54AoK0F88Ql6F9Ts7mqyJ10tVjQw3X >									
180 	//        <  u =="0.000000000000000001" : ] 000000120671268.483326000000000000 ; 000000131716206.169513000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000000B82137C8FBA5 >									
182 	//     < BANK_I_PFIII_metadata_line_13_____KARLSRUHE_Stadt_20260508 >									
183 	//        < vT2FqU4knn4P6Lj6QjnjCpkNLlT7K62bnVGOfy4kx4kK5L8xJnA68pCg977e23a0 >									
184 	//        <  u =="0.000000000000000001" : ] 000000131716206.169513000000000000 ; 000000142774455.729764000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000000C8FBA5D9DB46 >									
186 	//     < BANK_I_PFIII_metadata_line_14_____STUTTGART_Stadt_20260508 >									
187 	//        < WiIFKB1zxSBW9Mjhz6Ya2b6Go7KKFo2j3Vl9L59QIW0pNbf779B0sr12EN6M0JL3 >									
188 	//        <  u =="0.000000000000000001" : ] 000000142774455.729764000000000000 ; 000000153742834.694463000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000000D9DB46EA97CB >									
190 	//     < BANK_I_PFIII_metadata_line_15_____AUGSBURG_Stadt_20260508 >									
191 	//        < VtaUd0oq8xfsc9VXq8hO7k7Fn0J6w4lmWDI7tuU0j1JO3sQhUYwY9b48jlE9r7lz >									
192 	//        <  u =="0.000000000000000001" : ] 000000153742834.694463000000000000 ; 000000164462514.947098000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000000EA97CBFAF32B >									
194 	//     < BANK_I_PFIII_metadata_line_16_____INGOLSTADT_Stadt_20260508 >									
195 	//        < C7Bnc7rN17Ha4W1g1RLwfKnxls5h2iC6pUrGA2zmI767Bb1Z9KLJ7w16M9y3M2wV >									
196 	//        <  u =="0.000000000000000001" : ] 000000164462514.947098000000000000 ; 000000175596207.808190000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000000FAF32B10BF045 >									
198 	//     < BANK_I_PFIII_metadata_line_17_____NUERNBERG_Stadt_20260508 >									
199 	//        < 4oE2G9x1le0907FVYCN8nZm37u4RG8x8MgbzJTUKtiRjGO0IvD6Uj0KBx10jr7aJ >									
200 	//        <  u =="0.000000000000000001" : ] 000000175596207.808190000000000000 ; 000000186822533.384302000000000000 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000000010BF04511D118D >									
202 	//     < BANK_I_PFIII_metadata_line_18_____REGENSBURG_Stadt_20260508 >									
203 	//        < 1WSYf4kjRc3YxIm7p41s3IH0tmjdXv7R7Lo3yz6AfXoxgSvx59M408VBdCvwnLxR >									
204 	//        <  u =="0.000000000000000001" : ] 000000186822533.384302000000000000 ; 000000197856016.559184000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000011D118D12DE782 >									
206 	//     < BANK_I_PFIII_metadata_line_19_____HANNOVER_Stadt_20260508 >									
207 	//        < 445jKBVr1h2Sz19qwI8GIw6TrtvlN4pZw7gisb18wJ7j8gK0eEme90XTGp08Z8B0 >									
208 	//        <  u =="0.000000000000000001" : ] 000000197856016.559184000000000000 ; 000000208756807.705695000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000000012DE78213E89A1 >									
210 	//     < BANK_I_PFIII_metadata_line_20_____AACHEN_Stadt_20260508 >									
211 	//        < gw2m3ndf2sE9tHcB253PtE66X8iSIOLHtg3vy4xhXM8xZwZt2rjmw79jmO576B2J >									
212 	//        <  u =="0.000000000000000001" : ] 000000208756807.705695000000000000 ; 000000220073492.886009000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000013E89A114FCE35 >									
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
256 	//     < BANK_I_PFIII_metadata_line_21_____KOELN_Stadt_20260508 >									
257 	//        < GU27sm2g7yIiGRwEEhef8A2WnOB83pQ3X274O4Xt68S8HhuZecsT46Yfvl9059sL >									
258 	//        <  u =="0.000000000000000001" : ] 000000220073492.886009000000000000 ; 000000231369976.600709000000000000 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000000014FCE351610AE6 >									
260 	//     < BANK_I_PFIII_metadata_line_22_____DUESSELDORF_Stadt_20260508 >									
261 	//        < dh3YF3dFEm08x4tHpUCON7HbUDLCxbhhq16RHr1dK5iV56Tp8J9wxn9Cvo0e9J38 >									
262 	//        <  u =="0.000000000000000001" : ] 000000231369976.600709000000000000 ; 000000242117494.725825000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000001610AE61717125 >									
264 	//     < BANK_I_PFIII_metadata_line_23_____BONN_Stadt_20260508 >									
265 	//        < ins1L2ZMpcR9cO2ON153tucdMBiWk83t0IKoXq4b89qeDn4nrK6E9Ny3BJhHpLQW >									
266 	//        <  u =="0.000000000000000001" : ] 000000242117494.725825000000000000 ; 000000252859405.641052000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000001717125181D535 >									
268 	//     < BANK_I_PFIII_metadata_line_24_____DUISBURG_Stadt_20260508 >									
269 	//        < 2NGtVxliIAxq19Z6N9Qw4m1A64Vc8zWAWS5iJnh81T9gxIsx8c99sU94lDYjfnxx >									
270 	//        <  u =="0.000000000000000001" : ] 000000252859405.641052000000000000 ; 000000263783554.612477000000000000 ] >									
271 	//        < 0x00000000000000000000000000000000000000000000000000181D5351928073 >									
272 	//     < BANK_I_PFIII_metadata_line_25_____WUPPERTAL_Stadt_20260508 >									
273 	//        < 35XG0txf9gSxjF3Oo9w2hVXnut2w0A25RVw69irV6fnW12L93lwoG0LzmMJnpV48 >									
274 	//        <  u =="0.000000000000000001" : ] 000000263783554.612477000000000000 ; 000000274850973.749201000000000000 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000000000019280731A363A9 >									
276 	//     < BANK_I_PFIII_metadata_line_26_____ESSEN_Stadt_20260508 >									
277 	//        < 5B6J1jk1J4W1x2NTxejJCbG41Cq3n4rz39SzHJV5o8k8dqbniTHLx6q6ZeG8ZB9X >									
278 	//        <  u =="0.000000000000000001" : ] 000000274850973.749201000000000000 ; 000000285588044.024521000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000001A363A91B3C5D4 >									
280 	//     < BANK_I_PFIII_metadata_line_27_____DORTMUND_Stadt_20260508 >									
281 	//        < BG3ItkcHjwg9QDcabP5Mah87a62EN0Wi4COw1hyI4bmD5168f1N10rQNFeafCnBe >									
282 	//        <  u =="0.000000000000000001" : ] 000000285588044.024521000000000000 ; 000000296551260.961074000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000001B3C5D41C48056 >									
284 	//     < BANK_I_PFIII_metadata_line_28_____MUENSTER_Stadt_20260508 >									
285 	//        < fBSMeko7JgWYo8GR9561cyH3Me4D5ki6892J4IEndE6tbIXOo1S5jBY4ml7567NR >									
286 	//        <  u =="0.000000000000000001" : ] 000000296551260.961074000000000000 ; 000000307713558.271684000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000001C480561D5889C >									
288 	//     < BANK_I_PFIII_metadata_line_29_____MOENCHENGLADBACH_Stadt_20260508 >									
289 	//        < D8GG8toDoRpezP08zjg70216Lv85neU2CsP4EbLJYLr0GBF9l43o9G8L9AM6RDHJ >									
290 	//        <  u =="0.000000000000000001" : ] 000000307713558.271684000000000000 ; 000000318511221.420510000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000001D5889C1E60272 >									
292 	//     < BANK_I_PFIII_metadata_line_30_____WORMS_Stadt_20260508 >									
293 	//        < 0SMkY995994q79zX5TQB0172cEagoUrHTc6939495Y67gs424U8DubKDT6ad7Cy5 >									
294 	//        <  u =="0.000000000000000001" : ] 000000318511221.420510000000000000 ; 000000329393624.018460000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000001E602721F69D62 >									
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
338 	//     < BANK_I_PFIII_metadata_line_31_____SPEYER_Stadt_20260508 >									
339 	//        < f5g95pkZ404Nrq6DIQc85Wz2DaK000F9LZ7UHbdJlZNFP40zO7a59Q2mgb4dIiqm >									
340 	//        <  u =="0.000000000000000001" : ] 000000329393624.018460000000000000 ; 000000340171107.815745000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000001F69D622070F57 >									
342 	//     < BANK_I_PFIII_metadata_line_32_____BADEN_BADEN_Stadt_20260508 >									
343 	//        < I8wOX2gX62J32lA1vV8zK4qJ38jHpuhdkeYMO9zoL9mJkel35lF4u9HzC8LjwLti >									
344 	//        <  u =="0.000000000000000001" : ] 000000340171107.815745000000000000 ; 000000350896199.507734000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000002070F572176CD4 >									
346 	//     < BANK_I_PFIII_metadata_line_33_____OFFENBURG_Stadt_20260508 >									
347 	//        < u70P6yyXM1iiHhqs0keGy8F1fXJ5HaItqD9A04b5HU0Sgv639V243E8782BXO9JF >									
348 	//        <  u =="0.000000000000000001" : ] 000000350896199.507734000000000000 ; 000000362103332.569001000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000002176CD4228869D >									
350 	//     < BANK_I_PFIII_metadata_line_34_____FREIBURG_AM_BREISGAU_Stadt_20260508 >									
351 	//        < 3UO11hsq0O6mcW1wn194Elz3N3bGHJfFIIAhT9fCnO5sQ7KpF48rg2Ay762Xv9LO >									
352 	//        <  u =="0.000000000000000001" : ] 000000362103332.569001000000000000 ; 000000373235932.565774000000000000 ] >									
353 	//        < 0x00000000000000000000000000000000000000000000000000228869D2398349 >									
354 	//     < BANK_I_PFIII_metadata_line_35_____KEMPTEN_Stadt_20260508 >									
355 	//        < 74gzi03RrfOU03fNwD5p7ayXhJ3Ba449Co28bm4s3GsQAU9V8x8xyuC1st2YCp6w >									
356 	//        <  u =="0.000000000000000001" : ] 000000373235932.565774000000000000 ; 000000384413040.449357000000000000 ] >									
357 	//        < 0x00000000000000000000000000000000000000000000000000239834924A9158 >									
358 	//     < BANK_I_PFIII_metadata_line_36_____ULM_Stadt_20260508 >									
359 	//        < cUi4iPfb3BqyntmX9ul7hAAS6TNN457d5H7gUGvc5q5XkhmeZT1n5vL403Ic7Nex >									
360 	//        <  u =="0.000000000000000001" : ] 000000384413040.449357000000000000 ; 000000395250558.743025000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000024A915825B1AC0 >									
362 	//     < BANK_I_PFIII_metadata_line_37_____RAVENSBURG_Stadt_20260508 >									
363 	//        < a069HWLZZTW0Yd6ll5R1q6241e1Rldbjbxh62w06GiHqt62mMNrMo3c48bagd91R >									
364 	//        <  u =="0.000000000000000001" : ] 000000395250558.743025000000000000 ; 000000405908151.797810000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000025B1AC026B5DDF >									
366 	//     < BANK_I_PFIII_metadata_line_38_____FRIEDRICHSHAFEN_Stadt_20260508 >									
367 	//        < qnifET27s4g5D429e6TKwL4fKJJL4856psU2VtXhr2Hpz939zDxjYJgexoG8t34g >									
368 	//        <  u =="0.000000000000000001" : ] 000000405908151.797810000000000000 ; 000000417101989.896984000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000026B5DDF27C7277 >									
370 	//     < BANK_I_PFIII_metadata_line_39_____KONSTANZ_Stadt_20260508 >									
371 	//        < EMB1UqN91k8Tc6Rf5UVMrr6h0C6krCNVunHoO9stzJPIlED4a4tJwcYa54Z77Qp6 >									
372 	//        <  u =="0.000000000000000001" : ] 000000417101989.896984000000000000 ; 000000427973518.015897000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000027C727728D0928 >									
374 	//     < BANK_I_PFIII_metadata_line_40_____A40_20260508 >									
375 	//        < d19V9852iibF51jHoMGK9oz631q5JKTvF4tR48BrPWy8l0Wa9T698kJ0mkr4X7wX >									
376 	//        <  u =="0.000000000000000001" : ] 000000427973518.015897000000000000 ; 000000439277148.342774000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000028D092829E48A3 >									
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