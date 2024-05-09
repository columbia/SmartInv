1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	NISSAN_usd_31_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	NISSAN_usd_31_883		"	;
8 		string	public		symbol =	"	NISSAN_usd_31_1subDT		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1143826793595050000000000000					;	
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
92 	//     < NISSAN_usd_31_metadata_line_1_____NISSAN_usd_31Y_abc_i >									
93 	//        < 96YOuS49yTd3RbDejf6I3831J0EGL7j70u67m2Dk3WF7G6IdWDplWhV765GZ4IjM >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000028767841.219959000000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000002BE570 >									
96 	//     < NISSAN_usd_31_metadata_line_2_____NISSAN_usd_31Y_abc_ii >									
97 	//        < 984YU567ky87Nyyq5hmTM1IYT6EXZxL8FrNgP5c49zsWb9jEiF7K3bi1MUbe1DKq >									
98 	//        <  u =="0.000000000000000001" : ] 000000028767841.219959000000000000 ; 000000057616018.039047800000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000002BE57057EA42 >									
100 	//     < NISSAN_usd_31_metadata_line_3_____NISSAN_usd_31Y_abc_iii >									
101 	//        < 9nCNB3Ib35kC42zaVdomS6BIS3Bk1G5Z5eApf83R2e18N20aTEM2jZVKJ4ssAAA2 >									
102 	//        <  u =="0.000000000000000001" : ] 000000057616018.039047800000000000 ; 000000085462347.503067200000000000 ] >									
103 	//        < 0x000000000000000000000000000000000000000000000000000057EA428267BB >									
104 	//     < NISSAN_usd_31_metadata_line_4_____NISSAN_usd_31Y_abc_iv >									
105 	//        < 0uo5wMEi0XfLnp84jyD3wiH1pGlVW93pTPjwbE5284Hswp451q38ZNd3lJQ8rTY9 >									
106 	//        <  u =="0.000000000000000001" : ] 000000085462347.503067200000000000 ; 000000114532829.475137000000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000008267BBAEC363 >									
108 	//     < NISSAN_usd_31_metadata_line_5_____NISSAN_usd_31Y_abc_v >									
109 	//        < 1SdN5tWLEMOKYy23p875uRgE1S1WeVIsiv6FWKL8O7601C2kSpp99kB1zoy39t7R >									
110 	//        <  u =="0.000000000000000001" : ] 000000114532829.475137000000000000 ; 000000142952170.950203000000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000AEC363DA20B1 >									
112 	//     < NISSAN_usd_31_metadata_line_6_____NISSAN_usd_31Y_abc_vi >									
113 	//        < hm3zb2Brsh13jq545FlabT3UfYYSn77VDmZlYSgnd66xRetaR70wd134Z1daKL2A >									
114 	//        <  u =="0.000000000000000001" : ] 000000142952170.950203000000000000 ; 000000171199856.685922000000000000 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000000000DA20B11053AF2 >									
116 	//     < NISSAN_usd_31_metadata_line_7_____NISSAN_usd_31Y_abc_vii >									
117 	//        < fp40hDO6rKgG7JzJ9ZXUFau1Gr82e5lSBC6WHGcffOmuOMaiiqEuLO53Qb0BDp5A >									
118 	//        <  u =="0.000000000000000001" : ] 000000171199856.685922000000000000 ; 000000199971585.406257000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000001053AF213121E7 >									
120 	//     < NISSAN_usd_31_metadata_line_8_____NISSAN_usd_31Y_abc_viii >									
121 	//        < EPHT7I8G6ilvRanH8hz09Y46LLG8J39ub9Ac8xB0TfQy9cp3uKaN648Ug8Rc1bCH >									
122 	//        <  u =="0.000000000000000001" : ] 000000199971585.406257000000000000 ; 000000228035387.641908000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000013121E715BF453 >									
124 	//     < NISSAN_usd_31_metadata_line_9_____NISSAN_usd_31Y_abc_ix >									
125 	//        < 5JfNf3I0IHrqs0sIK4e3s27zUrT8lsd34130p3pzeSM1gBj2o3qVL4P2mTN3Tw0V >									
126 	//        <  u =="0.000000000000000001" : ] 000000228035387.641908000000000000 ; 000000257137588.192373000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000015BF4531885C5F >									
128 	//     < NISSAN_usd_31_metadata_line_10_____NISSAN_usd_31Y_abc_x >									
129 	//        < y3LfkWQ1btSy5VmddeW1OK7cz5LY5A6CXlNgI8HVvJB8RuN9VY6vx59060do9sDK >									
130 	//        <  u =="0.000000000000000001" : ] 000000257137588.192373000000000000 ; 000000285691790.355958000000000000 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000000001885C5F1B3EE5B >									
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
174 	//     < NISSAN_usd_31_metadata_line_11_____NISSAN_usd_31Y_abc_xi >									
175 	//        < n96LYHu2CFFkK8F4DcMrfT8622Utj7FETcHMnN881hMGPJht7Sy2ZXifg1w1yzWo >									
176 	//        <  u =="0.000000000000000001" : ] 000000285691790.355958000000000000 ; 000000314744010.792358000000000000 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000000001B3EE5B1E042E1 >									
178 	//     < NISSAN_usd_31_metadata_line_12_____NISSAN_usd_31Y_abc_xii >									
179 	//        < rg8R8sPf219Z0XKtKZKT8EjzOjpp5703i8KTg4iEv0qqRF26j59Kudt8w2v0m8I6 >									
180 	//        <  u =="0.000000000000000001" : ] 000000314744010.792358000000000000 ; 000000343189395.137307000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000001E042E120BAA5C >									
182 	//     < NISSAN_usd_31_metadata_line_13_____NISSAN_usd_31Y_abc_xiii >									
183 	//        < KJk521PBgH572QwaXxz6jd3c3arV467H42j8aEj6aL4ItPs10frfxt5jVb5iKu6y >									
184 	//        <  u =="0.000000000000000001" : ] 000000343189395.137307000000000000 ; 000000371969202.174499000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000020BAA5C2379478 >									
186 	//     < NISSAN_usd_31_metadata_line_14_____NISSAN_usd_31Y_abc_xiv >									
187 	//        < iByhHKbvOuqhqw114r8cTgCd67F2dhCJ3y7y68onBc67F71RNbxXUbr3yI96j9ro >									
188 	//        <  u =="0.000000000000000001" : ] 000000371969202.174499000000000000 ; 000000400528616.145221000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000002379478263287E >									
190 	//     < NISSAN_usd_31_metadata_line_15_____NISSAN_usd_31Y_abc_xv >									
191 	//        < Q772ZRUKc38Hmx5rEezHqqVvLH3Mgr53ob0z1iv8E86thQYsMPDQX69Hh0pp61vo >									
192 	//        <  u =="0.000000000000000001" : ] 000000400528616.145221000000000000 ; 000000428430823.508686000000000000 ] >									
193 	//        < 0x00000000000000000000000000000000000000000000000000263287E28DBBCA >									
194 	//     < NISSAN_usd_31_metadata_line_16_____NISSAN_usd_31Y_abc_xvi >									
195 	//        < xpA1EczviPgGhNgw8mU5kTF241K1eeVAZ7Z3591512TC1cx2li5lOZvZafW136bF >									
196 	//        <  u =="0.000000000000000001" : ] 000000428430823.508686000000000000 ; 000000457481538.603809000000000000 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000000028DBBCA2BA0FBA >									
198 	//     < NISSAN_usd_31_metadata_line_17_____NISSAN_usd_31Y_abc_xvii >									
199 	//        < P9MJ59AVPb7ArVAX9T10f7Y3e03v95841UUy4kd25sj6ek693ea6B2Sulub8tkFG >									
200 	//        <  u =="0.000000000000000001" : ] 000000457481538.603809000000000000 ; 000000486523701.660850000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000002BA0FBA2E66052 >									
202 	//     < NISSAN_usd_31_metadata_line_18_____NISSAN_usd_31Y_abc_xviii >									
203 	//        < NNY82S2ntTuLuTlAkZvDllg3CuV0n6qBfc57O4j2V5JFm88U1PD254dzEq0cDd3z >									
204 	//        <  u =="0.000000000000000001" : ] 000000486523701.660850000000000000 ; 000000515114825.637636000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000002E6605231200BB >									
206 	//     < NISSAN_usd_31_metadata_line_19_____NISSAN_usd_31Y_abc_xix >									
207 	//        < 6s27Jx5A1hc7GrS0HluaRO3LXQrvM4bLK9241n6kr6GEeM885SJ4AO3tr98aD46Q >									
208 	//        <  u =="0.000000000000000001" : ] 000000515114825.637636000000000000 ; 000000543845231.531160000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000000031200BB33DD78B >									
210 	//     < NISSAN_usd_31_metadata_line_20_____NISSAN_usd_31Y_abc_xx >									
211 	//        < e2l22pXI8eGbgI91fJ9VXy3FNAIQLXyjyX2pP7Vw91vfpgdG00W158u3ZyyG0kWs >									
212 	//        <  u =="0.000000000000000001" : ] 000000543845231.531160000000000000 ; 000000573018036.794185000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000033DD78B36A5B2C >									
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
256 	//     < NISSAN_usd_31_metadata_line_21_____NISSAN_usd_31Y_abc_xxi >									
257 	//        < zNbC8iS4wCMNttF3j26cZU3LcAxc90QM78X313k6BuO86ATWLhb7oX0DJV73A0qe >									
258 	//        <  u =="0.000000000000000001" : ] 000000573018036.794185000000000000 ; 000000602204378.030663000000000000 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000000036A5B2C396E416 >									
260 	//     < NISSAN_usd_31_metadata_line_22_____NISSAN_usd_31Y_abc_xxii >									
261 	//        < rZ2hxAkIY89Yzx491naed7tL405M3t7JNtBZ38ekW9W8aqil9Q0DsDiSlsBzm4mb >									
262 	//        <  u =="0.000000000000000001" : ] 000000602204378.030663000000000000 ; 000000630873770.699938000000000000 ] >									
263 	//        < 0x00000000000000000000000000000000000000000000000000396E4163C2A311 >									
264 	//     < NISSAN_usd_31_metadata_line_23_____NISSAN_usd_31Y_abc_xxiii >									
265 	//        < UJo6sUHgbBs32e3Hw4UmuI9cdr6HibyMIPfp0Yl09HAV31hT7zyMa0JkDCm63479 >									
266 	//        <  u =="0.000000000000000001" : ] 000000630873770.699938000000000000 ; 000000658726941.136062000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000003C2A3113ED2336 >									
268 	//     < NISSAN_usd_31_metadata_line_24_____NISSAN_usd_31Y_abc_xxiv >									
269 	//        < 4ELw5F7BXd2NX4rOO0Iuyd2wAd1IliIlIWLHvsQ1R40zzr2MBxGYn6knHFUv5nya >									
270 	//        <  u =="0.000000000000000001" : ] 000000658726941.136062000000000000 ; 000000687711608.757786000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000003ED23364195D59 >									
272 	//     < NISSAN_usd_31_metadata_line_25_____NISSAN_usd_31Y_abc_xxv >									
273 	//        < h1CtpEhWM0Fu2u2WCkQMUutm9Nb8swboE92M4r71xk44RqZosORd7cgF3n3oSm9Q >									
274 	//        <  u =="0.000000000000000001" : ] 000000687711608.757786000000000000 ; 000000715949320.529132000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000004195D5944473B4 >									
276 	//     < NISSAN_usd_31_metadata_line_26_____NISSAN_usd_31Y_abc_xxvi >									
277 	//        < D2Yt8mQVM82400b7Dj702g7846ZSkpU312d6DGhDY185IjtfATzS3FeMo594lJhU >									
278 	//        <  u =="0.000000000000000001" : ] 000000715949320.529132000000000000 ; 000000744957265.035860000000000000 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000000000044473B4470B6EF >									
280 	//     < NISSAN_usd_31_metadata_line_27_____NISSAN_usd_31Y_abc_xxvii >									
281 	//        < 5l9sy3kJOvogDe4MdzhN52Cm12kj7D3RbW4F9c7vQC34R33dWAT46XRZVEx7MmZ7 >									
282 	//        <  u =="0.000000000000000001" : ] 000000744957265.035860000000000000 ; 000000773985713.381517000000000000 ] >									
283 	//        < 0x00000000000000000000000000000000000000000000000000470B6EF49D022B >									
284 	//     < NISSAN_usd_31_metadata_line_28_____NISSAN_usd_31Y_abc_xxviii >									
285 	//        < wK8Y7sZzFp0y4rXbuG9Mp2JEWruGg432KE7eU9631W8tO6zWwzt1mPpQSD0i5v5g >									
286 	//        <  u =="0.000000000000000001" : ] 000000773985713.381517000000000000 ; 000000801937166.949711000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000049D022B4C7A8B5 >									
288 	//     < NISSAN_usd_31_metadata_line_29_____NISSAN_usd_31Y_abc_xxix >									
289 	//        < HkLvbGXf7RGRE47NZpy8oFQqTCZWjTl6r59688pgFP3H1v65qB7p1m267R30m41N >									
290 	//        <  u =="0.000000000000000001" : ] 000000801937166.949711000000000000 ; 000000829891965.270429000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000004C7A8B54F2508D >									
292 	//     < NISSAN_usd_31_metadata_line_30_____NISSAN_usd_31Y_abc_xxx >									
293 	//        < R94ram5M4J0cSm5gGd5214w525ibg1BzHo559dna71G4eTh85lZ1C47Utf4yLL9T >									
294 	//        <  u =="0.000000000000000001" : ] 000000829891965.270429000000000000 ; 000000858607775.048074000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000004F2508D51E21AA >									
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
338 	//     < NISSAN_usd_31_metadata_line_31_____NISSAN_usd_31Y_abc_xxxi >									
339 	//        < C5L64K3J2aNSc8K4RM9s3Ck7Db6vjep4zhpq674FTn6nIz840TZIx5a66Ak9chSU >									
340 	//        <  u =="0.000000000000000001" : ] 000000858607775.048074000000000000 ; 000000887787841.268889000000000000 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000000000051E21AA54AA820 >									
342 	//     < NISSAN_usd_31_metadata_line_32_____NISSAN_usd_31Y_abc_xxxii >									
343 	//        < K352BVy4tdv39sQqMU4c9iKHYQ8If5Uzt08V6O2xxpKl1TvROV6Ywz301Y2QYo7D >									
344 	//        <  u =="0.000000000000000001" : ] 000000887787841.268889000000000000 ; 000000915689621.864420000000000000 ] >									
345 	//        < 0x0000000000000000000000000000000000000000000000000054AA8205753B42 >									
346 	//     < NISSAN_usd_31_metadata_line_33_____NISSAN_usd_31Y_abc_xxxiii >									
347 	//        < 6i771A2mu4W8n2YpH3lm448B7253x0v3529h62lP020CT36g6YG4FN4n4dX6017A >									
348 	//        <  u =="0.000000000000000001" : ] 000000915689621.864420000000000000 ; 000000944546805.490515000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000005753B425A14399 >									
350 	//     < NISSAN_usd_31_metadata_line_34_____NISSAN_usd_31Y_abc_xxxiv >									
351 	//        < 4y9CxAa69iOLM87mf1WeLCf47D22R4CaWZ03h2b2RY6irC6bjzZ3Y3aqoPNFos1q >									
352 	//        <  u =="0.000000000000000001" : ] 000000944546805.490515000000000000 ; 000000972735239.406166000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000005A143995CC46B4 >									
354 	//     < NISSAN_usd_31_metadata_line_35_____NISSAN_usd_31Y_abc_xxxv >									
355 	//        < nmfy7r0g9dbhcSla1Xm7fRVN3761qbK6qYP9oG4McxdX292LmM6H004KF1fsQiM4 >									
356 	//        <  u =="0.000000000000000001" : ] 000000972735239.406166000000000000 ; 000001001267688.582230000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000005CC46B45F7D031 >									
358 	//     < NISSAN_usd_31_metadata_line_36_____NISSAN_usd_31Y_abc_xxxvi >									
359 	//        < EtZ9g1JNa4SuGWQrwsPZN89hgwdZB2Gh9F439h35apLsdAgkPIQ59AQLvYMM04k5 >									
360 	//        <  u =="0.000000000000000001" : ] 000001001267688.582230000000000000 ; 000001029850374.355630000000000000 ] >									
361 	//        < 0x000000000000000000000000000000000000000000000000005F7D0316236D4D >									
362 	//     < NISSAN_usd_31_metadata_line_37_____NISSAN_usd_31Y_abc_xxxvii >									
363 	//        < FD37Fl81tWUA014mcY2fNN34rBJx8wKC9r1lw65M4VffoC7omj0JOXciUP5MwrZh >									
364 	//        <  u =="0.000000000000000001" : ] 000001029850374.355630000000000000 ; 000001057643159.926470000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000006236D4D64DD5DC >									
366 	//     < NISSAN_usd_31_metadata_line_38_____NISSAN_usd_31Y_abc_xxxviii >									
367 	//        < uE7qrXRrjOf7L66J0Ny0zl8vdt6XXGrU90woxxmL35qK3KF3MhMF2e06423d57Q3 >									
368 	//        <  u =="0.000000000000000001" : ] 000001057643159.926470000000000000 ; 000001086536934.649170000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000064DD5DC679EC7D >									
370 	//     < NISSAN_usd_31_metadata_line_39_____NISSAN_usd_31Y_abc_xxxix >									
371 	//        < mIYEM49Q6ed8DcI3GANRTIxh4HJJLN7kC8O90mfbc6UTDpnek42Y5w1eG5WbRX7X >									
372 	//        <  u =="0.000000000000000001" : ] 000001086536934.649170000000000000 ; 000001114969013.452850000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000679EC7D6A54EC5 >									
374 	//     < NISSAN_usd_31_metadata_line_40_____NISSAN_usd_31Y_abc_xxxx >									
375 	//        < MYEs6x0tpDp8wLS3XL6f2grncFHM336JDqv969kW1JGJufvW5K1wD7Dhp3C366Oy >									
376 	//        <  u =="0.000000000000000001" : ] 000001114969013.452850000000000000 ; 000001143826793.595050000000000000 ] >									
377 	//        < 0x000000000000000000000000000000000000000000000000006A54EC56D15757 >									
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