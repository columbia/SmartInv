1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	BANK_I_PFII_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	BANK_I_PFII_883		"	;
8 		string	public		symbol =	"	BANK_I_PFII_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		426336036009428000000000000					;	
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
92 	//     < BANK_I_PFII_metadata_line_1_____HEIDELBERG_Stadt_20240508 >									
93 	//        < 43Dd3gs43X8Yr4UNrM4Zy87ps421st85goKMXXJR5YPFfJ2sC0G54YJ8IQcO551l >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000010499987.643315000000000000 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000000010058F >									
96 	//     < BANK_I_PFII_metadata_line_2_____SAARBRUECKEN_Stadt_20240508 >									
97 	//        < Ohk8Sd0WMZt6P64aLth1Xq2gFEebF3bc5v6HmWz9S5rmzaL8vrc7M5W9n6t1T5dS >									
98 	//        <  u =="0.000000000000000001" : ] 000000010499987.643315000000000000 ; 000000020978969.380980900000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000010058F2002E9 >									
100 	//     < BANK_I_PFII_metadata_line_3_____KAISERSLAUTERN_Stadt_20240508 >									
101 	//        < F97L212iuq90ZymJlH3G63018G4DyOhHm5r8F3R4Fq591e896i1u59y63032A5IM >									
102 	//        <  u =="0.000000000000000001" : ] 000000020978969.380980900000000000 ; 000000031604219.774978300000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000002002E9303966 >									
104 	//     < BANK_I_PFII_metadata_line_4_____KOBLENZ_Stadt_20240508 >									
105 	//        < iidb8ak6o4pPxhj5C258db24r300a6r0mXB2N0qT37tkosfhAwn8gwoLRU5Wdjk9 >									
106 	//        <  u =="0.000000000000000001" : ] 000000031604219.774978300000000000 ; 000000042154092.914003200000000000 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000000000303966405271 >									
108 	//     < BANK_I_PFII_metadata_line_5_____MAINZ_Stadt_20240508 >									
109 	//        < E8mP1krZGZW34y8A45VbNt0wFFEl08jyCz0A0F0PW23B7fi82l1j1J5cpWl6XsC2 >									
110 	//        <  u =="0.000000000000000001" : ] 000000042154092.914003200000000000 ; 000000052651728.214053600000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000405271505715 >									
112 	//     < BANK_I_PFII_metadata_line_6_____RUESSELSHEIM_AM_MAIN_Stadt_20240508 >									
113 	//        < XJ48Cf662x76Ewbg98pNEdW8hO71NuD86q1M5shqERN3ATJIr6y61E5v2E5g6IJT >									
114 	//        <  u =="0.000000000000000001" : ] 000000052651728.214053600000000000 ; 000000063396074.301782300000000000 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000000000050571560BC17 >									
116 	//     < BANK_I_PFII_metadata_line_7_____INGELHEIM_AM_RHEIN_Stadt_20240508 >									
117 	//        < 9zHGa7QlAseT77X8f8H2cjbtP7HbcK1FTqrZPPKs61eWg25Kpe1n56V5x583cg4N >									
118 	//        <  u =="0.000000000000000001" : ] 000000063396074.301782300000000000 ; 000000074135343.412316600000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000000060BC17711F1E >									
120 	//     < BANK_I_PFII_metadata_line_8_____WIESBADEN_Stadt_20240508 >									
121 	//        < vZzMmvv2LqjaRiR3h2XsP9633bQVk4Guo36hoQEswjI6T3rz7CpF9005Dup5i1X7 >									
122 	//        <  u =="0.000000000000000001" : ] 000000074135343.412316600000000000 ; 000000085006769.968463900000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000711F1E81B5C5 >									
124 	//     < BANK_I_PFII_metadata_line_9_____FRANKFURT_AM_MAIN_Stadt_20240508 >									
125 	//        < C3pBb57IYvG6BV6Ww4zjsXxj4085a3IL2yOij8B2ZVVTnJ7q8wreD9fJe39d70Pi >									
126 	//        <  u =="0.000000000000000001" : ] 000000085006769.968463900000000000 ; 000000095723059.210729000000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000000081B5C5920FD2 >									
128 	//     < BANK_I_PFII_metadata_line_10_____DARMSTADT_Stadt_20240508 >									
129 	//        < 5mF8l94SqsqWM8w0x1c3ngLXwmYF9Jsnl3V957I8azVK19Jxj5279MZ6y65ePhh1 >									
130 	//        <  u =="0.000000000000000001" : ] 000000095723059.210729000000000000 ; 000000106599573.624526000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000000920FD2A2A875 >									
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
174 	//     < BANK_I_PFII_metadata_line_11_____LUDWIGSHAFEN_Stadt_20240508 >									
175 	//        < VqXgtV1ow9UyYuRpOu0p4F6l0MOFDOcuCrh00vq9OCoigCL385mNh3565xsj4u4k >									
176 	//        <  u =="0.000000000000000001" : ] 000000106599573.624526000000000000 ; 000000117102485.519344000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000000A2A875B2AF29 >									
178 	//     < BANK_I_PFII_metadata_line_12_____MANNHEIM_Stadt_20240508 >									
179 	//        < 8K800ohS7h6GhF4c1NlUX86V4Oq2c8R19bbfWMllv2YT7mtYBB91D47OwF0kICZ6 >									
180 	//        <  u =="0.000000000000000001" : ] 000000117102485.519344000000000000 ; 000000127952236.265406000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000000B2AF29C33D58 >									
182 	//     < BANK_I_PFII_metadata_line_13_____KARLSRUHE_Stadt_20240508 >									
183 	//        < ttcWT13aA543r4k71V2x3f832V9GEt0kMIlHF60QEWn7XEL5HvRv7n2eGXz9GrkB >									
184 	//        <  u =="0.000000000000000001" : ] 000000127952236.265406000000000000 ; 000000138460062.202967000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000000C33D58D345F6 >									
186 	//     < BANK_I_PFII_metadata_line_14_____STUTTGART_Stadt_20240508 >									
187 	//        < 1QmeKFIndjPRI4hb0w5O0TDN9Pg5K5y8N3IcSjipd2u2Kw9y6yzU1Kd3jQuJGt9Z >									
188 	//        <  u =="0.000000000000000001" : ] 000000138460062.202967000000000000 ; 000000149116545.731953000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000000D345F6E388A7 >									
190 	//     < BANK_I_PFII_metadata_line_15_____AUGSBURG_Stadt_20240508 >									
191 	//        < 8839A523gwSvCN22WIJRrz62BbPsy6vb1esUL1mTWRg2i9B7G4J9gitr7Grqd0q8 >									
192 	//        <  u =="0.000000000000000001" : ] 000000149116545.731953000000000000 ; 000000159674085.377698000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000000E388A7F3A4B1 >									
194 	//     < BANK_I_PFII_metadata_line_16_____INGOLSTADT_Stadt_20240508 >									
195 	//        < olzphLa7o69JLrxkg64iDE5rR6DANJh6l3N3rM42z3G5lQ99q42Y7W6RcEab21Xo >									
196 	//        <  u =="0.000000000000000001" : ] 000000159674085.377698000000000000 ; 000000170453554.732433000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000000F3A4B1104176B >									
198 	//     < BANK_I_PFII_metadata_line_17_____NUERNBERG_Stadt_20240508 >									
199 	//        < b2Sjl3sof7w0I67u0uNeQU82650dCPHHCmf941lN5x9s0n6EdJ3dL5iBsXlwb4JS >									
200 	//        <  u =="0.000000000000000001" : ] 000000170453554.732433000000000000 ; 000000181123200.198803000000000000 ] >									
201 	//        < 0x00000000000000000000000000000000000000000000000000104176B1145F40 >									
202 	//     < BANK_I_PFII_metadata_line_18_____REGENSBURG_Stadt_20240508 >									
203 	//        < FW0aYnb4Mia509X3up79AlnHnOuw875cQPi0M810p5p76Gx6a7E4MjG5U0aH2Vgk >									
204 	//        <  u =="0.000000000000000001" : ] 000000181123200.198803000000000000 ; 000000191642320.628372000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000001145F401246C48 >									
206 	//     < BANK_I_PFII_metadata_line_19_____HANNOVER_Stadt_20240508 >									
207 	//        < 09iB1EFbYsEUSSI6G46EfNlkOphr28tQXc9ZkOcmAB1c9yhPo155g3ksSVO170Z3 >									
208 	//        <  u =="0.000000000000000001" : ] 000000191642320.628372000000000000 ; 000000202494884.854692000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000001246C48134FB90 >									
210 	//     < BANK_I_PFII_metadata_line_20_____AACHEN_Stadt_20240508 >									
211 	//        < iW78kAtS4rfGn95v5gQ69FsisFESLYW3j195IVgt1P1Q4i40TCXoP3Q9jU312410 >									
212 	//        <  u =="0.000000000000000001" : ] 000000202494884.854692000000000000 ; 000000213377646.206647000000000000 ] >									
213 	//        < 0x00000000000000000000000000000000000000000000000000134FB9014596A5 >									
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
256 	//     < BANK_I_PFII_metadata_line_21_____KOELN_Stadt_20240508 >									
257 	//        < 3l2Od05nKS9dgpv9F2eDZPLby665X8UqmQ9voB7YKg7C4eZD2Exg3WaMyCrwg32N >									
258 	//        <  u =="0.000000000000000001" : ] 000000213377646.206647000000000000 ; 000000223995726.360233000000000000 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000000014596A5155CA55 >									
260 	//     < BANK_I_PFII_metadata_line_22_____DUESSELDORF_Stadt_20240508 >									
261 	//        < cNY36E4rd128Z3h76lh4E9S7Zwoy9ex8WGM51cg6uLlwc29Yoi2U84wXFVLK5su7 >									
262 	//        <  u =="0.000000000000000001" : ] 000000223995726.360233000000000000 ; 000000234653404.170055000000000000 ] >									
263 	//        < 0x00000000000000000000000000000000000000000000000000155CA551660D7C >									
264 	//     < BANK_I_PFII_metadata_line_23_____BONN_Stadt_20240508 >									
265 	//        < MPJ5sTd8CDVRSJmL52Iqd1P388gnJ390RR2Amxz95vpJ8V3Z4G421F3U8ZpSqf0i >									
266 	//        <  u =="0.000000000000000001" : ] 000000234653404.170055000000000000 ; 000000245125246.499932000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000001660D7C176080D >									
268 	//     < BANK_I_PFII_metadata_line_24_____DUISBURG_Stadt_20240508 >									
269 	//        < 0j8VEAMj7n8ERJOZB5GzP83CR17B69uUyS7goBqiknc58915AkNWRZ969i41NpV4 >									
270 	//        <  u =="0.000000000000000001" : ] 000000245125246.499932000000000000 ; 000000255852465.415043000000000000 ] >									
271 	//        < 0x00000000000000000000000000000000000000000000000000176080D186665F >									
272 	//     < BANK_I_PFII_metadata_line_25_____WUPPERTAL_Stadt_20240508 >									
273 	//        < 903XzrUzsses6ie5Zh54grJ655GW4hSTAzj8ZxIiCMvLmShXx38Ai7p6k91I5422 >									
274 	//        <  u =="0.000000000000000001" : ] 000000255852465.415043000000000000 ; 000000266371573.348798000000000000 ] >									
275 	//        < 0x00000000000000000000000000000000000000000000000000186665F1967365 >									
276 	//     < BANK_I_PFII_metadata_line_26_____ESSEN_Stadt_20240508 >									
277 	//        < yvD3O0lSQ69V2ihjiB3m7n9t1z9S3a49OB3o8yBJKI66q5bn26MCHZZXSgGJ1VAV >									
278 	//        <  u =="0.000000000000000001" : ] 000000266371573.348798000000000000 ; 000000277248841.265313000000000000 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000000000019673651A70C54 >									
280 	//     < BANK_I_PFII_metadata_line_27_____DORTMUND_Stadt_20240508 >									
281 	//        < Y6Q3oULnHy7822961fiq52wMmbtmlXneAs718ZQ99T2gmS2cnjI23SmpwxfftO02 >									
282 	//        <  u =="0.000000000000000001" : ] 000000277248841.265313000000000000 ; 000000287773351.101088000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000001A70C541B71B77 >									
284 	//     < BANK_I_PFII_metadata_line_28_____MUENSTER_Stadt_20240508 >									
285 	//        < h7L451c8OWrJk1Z6XQ75XFreiQrA87fFxG0OmXT8soEEN3H3nClc7MrQGoN97z8w >									
286 	//        <  u =="0.000000000000000001" : ] 000000287773351.101088000000000000 ; 000000298259963.820819000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000001B71B771C71BCC >									
288 	//     < BANK_I_PFII_metadata_line_29_____MOENCHENGLADBACH_Stadt_20240508 >									
289 	//        < Q1BBLSby75gTN5GegHq98HK1PbbyI2RJGKCFE5L0aTS6e2lQFAPgXWV674i2wBzL >									
290 	//        <  u =="0.000000000000000001" : ] 000000298259963.820819000000000000 ; 000000308904701.230223000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000001C71BCC1D759E6 >									
292 	//     < BANK_I_PFII_metadata_line_30_____WORMS_Stadt_20240508 >									
293 	//        < ki98rEmxf6j54e1lh8mHieh3Bq8n68r1aDi9j5991d7mnN9cN9z713wkzVGYyhpL >									
294 	//        <  u =="0.000000000000000001" : ] 000000308904701.230223000000000000 ; 000000319633332.337666000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000001D759E61E7B8C5 >									
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
338 	//     < BANK_I_PFII_metadata_line_31_____SPEYER_Stadt_20240508 >									
339 	//        < wpDs0290r5MtqhD2O1ZF7DTlsP67oDDms6CsxNY9LrfXyUzrAS30BZ3Xs9hIv9tY >									
340 	//        <  u =="0.000000000000000001" : ] 000000319633332.337666000000000000 ; 000000330103506.357197000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000001E7B8C51F7B2AF >									
342 	//     < BANK_I_PFII_metadata_line_32_____BADEN_BADEN_Stadt_20240508 >									
343 	//        < vTD17nI7N607E4XscR2Bh1ZJJBL8rsL4LL5x3P5g3Q1Ece9a3F361E18W1d7J2LY >									
344 	//        <  u =="0.000000000000000001" : ] 000000330103506.357197000000000000 ; 000000340688890.812936000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000001F7B2AF207D999 >									
346 	//     < BANK_I_PFII_metadata_line_33_____OFFENBURG_Stadt_20240508 >									
347 	//        < 4e5tWGTERdvb92R9fe4r09GbCyEl3L7Gj5Eiw6BiJ114AulM9274G6oIriI68mW6 >									
348 	//        <  u =="0.000000000000000001" : ] 000000340688890.812936000000000000 ; 000000351341378.751619000000000000 ] >									
349 	//        < 0x00000000000000000000000000000000000000000000000000207D9992181ABA >									
350 	//     < BANK_I_PFII_metadata_line_34_____FREIBURG_AM_BREISGAU_Stadt_20240508 >									
351 	//        < 01A74Yh46g7BuMd7U39IkzhUZa1RExwpk5X05328303nEe8m94p9Yx3GwCSIw3zS >									
352 	//        <  u =="0.000000000000000001" : ] 000000351341378.751619000000000000 ; 000000361955879.170145000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000002181ABA2284D04 >									
354 	//     < BANK_I_PFII_metadata_line_35_____KEMPTEN_Stadt_20240508 >									
355 	//        < D1bN9jeqLIEE9ejAUfmmj04m9k1cJ8a1po19q92kla1KWo57XZi1ER0zCG3Rje0A >									
356 	//        <  u =="0.000000000000000001" : ] 000000361955879.170145000000000000 ; 000000372547479.575543000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000002284D04238765C >									
358 	//     < BANK_I_PFII_metadata_line_36_____ULM_Stadt_20240508 >									
359 	//        < xDiJhGfdTvbkNpSWe52G4Ghvb2F3t9QF6w0hfK2i008Nb66osJy11M32a6SK33LP >									
360 	//        <  u =="0.000000000000000001" : ] 000000372547479.575543000000000000 ; 000000383347154.764285000000000000 ] >									
361 	//        < 0x00000000000000000000000000000000000000000000000000238765C248F0FB >									
362 	//     < BANK_I_PFII_metadata_line_37_____RAVENSBURG_Stadt_20240508 >									
363 	//        < 1KCo8u3QJUk6sy85nwA07YhSsS2XZ0y30snbs42ycX2mXni4T81RNk961NlT7gFO >									
364 	//        <  u =="0.000000000000000001" : ] 000000383347154.764285000000000000 ; 000000393971393.271722000000000000 ] >									
365 	//        < 0x00000000000000000000000000000000000000000000000000248F0FB2592713 >									
366 	//     < BANK_I_PFII_metadata_line_38_____FRIEDRICHSHAFEN_Stadt_20240508 >									
367 	//        < 2N8LN2599AbF6LOvK6F8uggy7Z2k17H2XmxEqV3Z978NxPwE0Xy1lW359H6AvqUK >									
368 	//        <  u =="0.000000000000000001" : ] 000000393971393.271722000000000000 ; 000000404882772.362140000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000002592713269CD55 >									
370 	//     < BANK_I_PFII_metadata_line_39_____KONSTANZ_Stadt_20240508 >									
371 	//        < Ml8F35I9I1mad8r26WM6Lr71X2Wpjj9s8i886z2imH57My97PnX4G4Q4bE9MTHcU >									
372 	//        <  u =="0.000000000000000001" : ] 000000404882772.362140000000000000 ; 000000415741552.225652000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000269CD5527A5F0B >									
374 	//     < BANK_I_PFII_metadata_line_40_____A40_20240508 >									
375 	//        < xgwb4ZjwEles913xJKK3l6Rf87WMUJ6YU1aTG3RuLz3njgg023M3zTqq3qupi8NG >									
376 	//        <  u =="0.000000000000000001" : ] 000000415741552.225652000000000000 ; 000000426336036.009428000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000027A5F0B28A8984 >									
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