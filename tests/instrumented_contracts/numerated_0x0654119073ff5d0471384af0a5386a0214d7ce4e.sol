1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFVIII_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFVIII_I_883		"	;
8 		string	public		symbol =	"	RUSS_PFVIII_I_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		598947743475382000000000000					;	
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
92 	//     < RUSS_PFVIII_I_metadata_line_1_____NOVOLIPETSK_ORG_20211101 >									
93 	//        < MFObbtJD2ciuEPQ3Sr6AI5pFI7Hqc3Fogor8xL16M3Mcl2H94P309OfvlGK6682Z >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000015997621.666406900000000000 ] >									
95 	//        < 0x0000000000000000000000000000000000000000000000000000000000186912 >									
96 	//     < RUSS_PFVIII_I_metadata_line_2_____LLC_NTK_20211101 >									
97 	//        < JKwe5i9thuu8C3Rvs784AvpW1xxw0L3z7p800ON8d34zzEr6jAYlUx1A47g66uIG >									
98 	//        <  u =="0.000000000000000001" : ] 000000015997621.666406900000000000 ; 000000032263725.924507700000000000 ] >									
99 	//        < 0x0000000000000000000000000000000000000000000000000000186912313B05 >									
100 	//     < RUSS_PFVIII_I_metadata_line_3_____NATIONAL_LAMINATIONS_GROUP_20211101 >									
101 	//        < AofhCSF3Qn656W7qh6L5Fb03659VLh6sq5h2o6GR003nL5YU1E733ooo8MAm1poz >									
102 	//        <  u =="0.000000000000000001" : ] 000000032263725.924507700000000000 ; 000000046213606.784518200000000000 ] >									
103 	//        < 0x0000000000000000000000000000000000000000000000000000313B05468431 >									
104 	//     < RUSS_PFVIII_I_metadata_line_4_____DOLOMITE_OJSC_20211101 >									
105 	//        < ZP81LzFiG0UW9i5YNx7T82yMFMz276F8f1aB128YwJYQ9e54TGyha8k8jH2eoWc7 >									
106 	//        <  u =="0.000000000000000001" : ] 000000046213606.784518200000000000 ; 000000060572811.049138000000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000004684315C6D41 >									
108 	//     < RUSS_PFVIII_I_metadata_line_5_____LLC_TRADE_HOUSE_NLMK_20211101 >									
109 	//        < 0P30o7u4OPE869t7No5o70bc6H3cir2J9L206R8O4s774x45ebURm0X9v65a8qGs >									
110 	//        <  u =="0.000000000000000001" : ] 000000060572811.049138000000000000 ; 000000074634974.537277000000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000005C6D4171E249 >									
112 	//     < RUSS_PFVIII_I_metadata_line_6_____STUDENOVSK_MINING_CO_20211101 >									
113 	//        < FO26Pr6S29KRg42N5UMxtQ8EeWmvhy5KaR1cYzEI712mLo6P0ceg66ZH6s8DdVUo >									
114 	//        <  u =="0.000000000000000001" : ] 000000074634974.537277000000000000 ; 000000090225940.960993700000000000 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000000000071E24989AC82 >									
116 	//     < RUSS_PFVIII_I_metadata_line_7_____VMI_RECYCLING_GROUP_20211101 >									
117 	//        < 6Q6vV0l09Mgt0Hz6X334Id9O6sDXuoGxpRfe1k9BU7AOZNdjQ4V7EcVM86376Z59 >									
118 	//        <  u =="0.000000000000000001" : ] 000000090225940.960993700000000000 ; 000000107442192.809775000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000000089AC82A3F19B >									
120 	//     < RUSS_PFVIII_I_metadata_line_8_____VTORCHERMET_20211101 >									
121 	//        < G2ojr3hPD00I500uZFR2bL7Ss031Ow6a1qIe75WKzyWPiEHh57SVZVQ1L9h6q8I9 >									
122 	//        <  u =="0.000000000000000001" : ] 000000107442192.809775000000000000 ; 000000121795474.113010000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000A3F19BB9D85B >									
124 	//     < RUSS_PFVIII_I_metadata_line_9_____KALUGA_RESEARCH_PROD_ELECTROMETALL_20211101 >									
125 	//        < KnpvXfDQaz8KI83S2ur69W964TL0bMnnvDA4i9Dk8x58K25d0eOs12mW56sM4S0w >									
126 	//        <  u =="0.000000000000000001" : ] 000000121795474.113010000000000000 ; 000000138210451.440644000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000000B9D85BD2E475 >									
128 	//     < RUSS_PFVIII_I_metadata_line_10_____DANSTEEL_AS_20211101 >									
129 	//        < MJYJ394Ty30Ay4zZZE2U07e1952d6f39Q105524Z7r0sQ7BZqFKN5IFcH82k9CQH >									
130 	//        <  u =="0.000000000000000001" : ] 000000138210451.440644000000000000 ; 000000151881295.341330000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000000D2E475E7C0A2 >									
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
174 	//     < RUSS_PFVIII_I_metadata_line_11_____NOVATEK_ORG_20211101 >									
175 	//        < VqDa285YGF47dqclgzztU3l73jnff7cIu00RwTy6jS8fze28u5k9It9XCE4mY73J >									
176 	//        <  u =="0.000000000000000001" : ] 000000151881295.341330000000000000 ; 000000166052283.038886000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000000E7C0A2FD602C >									
178 	//     < RUSS_PFVIII_I_metadata_line_12_____NOVATEK_AB_20211101 >									
179 	//        < rVZgReV4IFpi2MuO9mY8G9cuXEW63mKKuoRbqM7kypp2ly4P55Io2dK1Rg2H6dy3 >									
180 	//        <  u =="0.000000000000000001" : ] 000000166052283.038886000000000000 ; 000000183050912.148769000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000000FD602C1175043 >									
182 	//     < RUSS_PFVIII_I_metadata_line_13_____NOVATEK_DAC_20211101 >									
183 	//        < gH7F7Szs3v6wx0E0Dl15vj7jhkY1Y62fGKBZg70R1Y423lONU1Pbn6V6jgD7k68F >									
184 	//        <  u =="0.000000000000000001" : ] 000000183050912.148769000000000000 ; 000000198204339.493630000000000000 ] >									
185 	//        < 0x00000000000000000000000000000000000000000000000000117504312E6F92 >									
186 	//     < RUSS_PFVIII_I_metadata_line_14_____PUROVSKY_ZPK_20211101 >									
187 	//        < 9ao6vUZnlD2A6YEz68UD4G8vt2V6R64Tnuz7JaGIE3yYSmUh0fsIBVSQ2m1Y85fk >									
188 	//        <  u =="0.000000000000000001" : ] 000000198204339.493630000000000000 ; 000000214167515.392787000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000012E6F92146CB30 >									
190 	//     < RUSS_PFVIII_I_metadata_line_15_____KOSTROMA_OOO_20211101 >									
191 	//        < tvaF9yleIg6T823E3722O5fNXyUnk7rH96QldUXvGS52H6kx5ufbnd73aRLNgs90 >									
192 	//        <  u =="0.000000000000000001" : ] 000000214167515.392787000000000000 ; 000000228953401.498360000000000000 ] >									
193 	//        < 0x00000000000000000000000000000000000000000000000000146CB3015D5AEC >									
194 	//     < RUSS_PFVIII_I_metadata_line_16_____SHERWOOD_PREMIER_LLC_20211101 >									
195 	//        < TkUcIUb3pus0L3o59V9rv4ajK1DUqzatOscmrpPca0C3gXd0GQ5BMIU11n1vOJEA >									
196 	//        <  u =="0.000000000000000001" : ] 000000228953401.498360000000000000 ; 000000243283670.350749000000000000 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000000015D5AEC17338AF >									
198 	//     < RUSS_PFVIII_I_metadata_line_17_____GEOTRANSGAZ_JSC_20211101 >									
199 	//        < myAf5dFe98MEjMzzT4tA71ZjIm3bk18xfkI7sYhfnj73Ha7xka1287RWyaeBC4Uo >									
200 	//        <  u =="0.000000000000000001" : ] 000000243283670.350749000000000000 ; 000000259341721.928311000000000000 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000000017338AF18BB95C >									
202 	//     < RUSS_PFVIII_I_metadata_line_18_____TAILIKSNEFTEGAS_20211101 >									
203 	//        < 59Peg6v5b0I10WsDAKF0FqHZz8C36uJ5a6TPTQ47ZmZDI7NMWDf0iYrz798IXXhW >									
204 	//        <  u =="0.000000000000000001" : ] 000000259341721.928311000000000000 ; 000000276019526.853635000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000018BB95C1A52C21 >									
206 	//     < RUSS_PFVIII_I_metadata_line_19_____URENGOYSKAYA_GAZOVAYA_KOMPANIYA_20211101 >									
207 	//        < Eu55U5i0V2g7BhwHsvSr8rb19MkcLzH9JAQW5S1G0b72M30P5G5rNf0wMv3hQVzt >									
208 	//        <  u =="0.000000000000000001" : ] 000000276019526.853635000000000000 ; 000000291381354.621064000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000001A52C211BC9CD7 >									
210 	//     < RUSS_PFVIII_I_metadata_line_20_____PURNEFTEGAZGEOLOGIYA_20211101 >									
211 	//        < 9840Oc6f3Tjgx43I2JVaz0gvTbq8BMa4i8weABl8X7RnRnFyu87T7Ir52lV40JWw >									
212 	//        <  u =="0.000000000000000001" : ] 000000291381354.621064000000000000 ; 000000306610461.417288000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000001BC9CD71D3D9B6 >									
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
256 	//     < RUSS_PFVIII_I_metadata_line_21_____OGK_2_20211101 >									
257 	//        < mxT3Wi2yLB3M7N19YUm455ZAskSz44lDOj9KztrkX8501XETUIiAC0scoq9X2CjP >									
258 	//        <  u =="0.000000000000000001" : ] 000000306610461.417288000000000000 ; 000000321244478.337174000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000001D3D9B61EA2E20 >									
260 	//     < RUSS_PFVIII_I_metadata_line_22_____RYAZANSKAYA_GRES_OAO_20211101 >									
261 	//        < ndg0m0dKr4nUwuI68G1PP5Y4AV0sQ3wcxFx31YHlHso5e1p5n7u65M273Tq266DB >									
262 	//        <  u =="0.000000000000000001" : ] 000000321244478.337174000000000000 ; 000000335934272.621178000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000001EA2E202009853 >									
264 	//     < RUSS_PFVIII_I_metadata_line_23_____GAZPROM_INVESTPROJECT_20211101 >									
265 	//        < LD0hTmuU3EhJ9PFksekGjeL9KEHoe5x2FAUQc8EhlfPi7SZ3iTD9O88x75898PBe >									
266 	//        <  u =="0.000000000000000001" : ] 000000335934272.621178000000000000 ; 000000348990047.695650000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000002009853214843D >									
268 	//     < RUSS_PFVIII_I_metadata_line_24_____TROITSKAYA_GRES_JSC_20211101 >									
269 	//        < 59c8Nm219OgZS36si633bLh2764oME0Z6p42e4Q9vC4U268Gv7Wy4ShD26sJv9gp >									
270 	//        <  u =="0.000000000000000001" : ] 000000348990047.695650000000000000 ; 000000363419970.028621000000000000 ] >									
271 	//        < 0x00000000000000000000000000000000000000000000000000214843D22A88ED >									
272 	//     < RUSS_PFVIII_I_metadata_line_25_____SURGUTSKAYA_TPP_1_20211101 >									
273 	//        < qKfp6Y0M91d26Sj8EUig8kK9QwMr1fy9H9IkQhofugp22N8ps57a8w0X68i790Le >									
274 	//        <  u =="0.000000000000000001" : ] 000000363419970.028621000000000000 ; 000000377008511.668245000000000000 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000000000022A88ED23F44F3 >									
276 	//     < RUSS_PFVIII_I_metadata_line_26_____NOVOCHERKASSKAYA_TPP_20211101 >									
277 	//        < 8QbG7TAJ9nGlzUxYG29CkIrh6eM9x6R16K25Owb062NewO7IDYRpCs9L7qm5aMiH >									
278 	//        <  u =="0.000000000000000001" : ] 000000377008511.668245000000000000 ; 000000394048460.139705000000000000 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000000000023F44F3259452E >									
280 	//     < RUSS_PFVIII_I_metadata_line_27_____KIRISHSKAYA_GRES_OGK_6_20211101 >									
281 	//        < ziJvejr305NOu5p1at16YZleeQhx1NW09NYyVl9m3HY538Cfe00p6h372Lx8xAP9 >									
282 	//        <  u =="0.000000000000000001" : ] 000000394048460.139705000000000000 ; 000000409098460.271646000000000000 ] >									
283 	//        < 0x00000000000000000000000000000000000000000000000000259452E2703C16 >									
284 	//     < RUSS_PFVIII_I_metadata_line_28_____KRASNOYARSKAYA_GRES_2_20211101 >									
285 	//        < 6LJ4CtXr7lAEVCtXz2b08A75bPPsPTS5v4GTU44qjQ54WRYtlti8kXqyhTNyfjEf >									
286 	//        <  u =="0.000000000000000001" : ] 000000409098460.271646000000000000 ; 000000425424926.590873000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000002703C16289259D >									
288 	//     < RUSS_PFVIII_I_metadata_line_29_____CHEREPOVETSKAYA_GRES_20211101 >									
289 	//        < A5Ft256FLQ5rAB6R5G9HaG4BI8zbFB93Bvbv9OTBPFtktB26PvuxQ2qb03jyn1YF >									
290 	//        <  u =="0.000000000000000001" : ] 000000425424926.590873000000000000 ; 000000439955190.015791000000000000 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000000000289259D29F517F >									
292 	//     < RUSS_PFVIII_I_metadata_line_30_____STAVROPOLSKAYA_GRES_20211101 >									
293 	//        < 7gZ1P7dNR7JO2G8S0014hQNW6Yql20WNs2cp558p8GA593cZs6l8V3AZrGUFFVqS >									
294 	//        <  u =="0.000000000000000001" : ] 000000439955190.015791000000000000 ; 000000453077164.514723000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000029F517F2B35744 >									
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
338 	//     < RUSS_PFVIII_I_metadata_line_31_____OGK_2_ORG_20211101 >									
339 	//        < 56h0z1k8385R1hHPdpGJ2de09G0afzIKeD5vN13p9JCxxq121Z4x1NkX1b6t8PBp >									
340 	//        <  u =="0.000000000000000001" : ] 000000453077164.514723000000000000 ; 000000466110288.041011000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000002B357442C73A55 >									
342 	//     < RUSS_PFVIII_I_metadata_line_32_____OGK_2_PSKOV_GRES_20211101 >									
343 	//        < 6rRc5s1GGkPXqmNhv69cwIThURHHAJF4F3IuxhaOg0F2tbm944u0wV4Qho0Mo4HN >									
344 	//        <  u =="0.000000000000000001" : ] 000000466110288.041011000000000000 ; 000000482610755.518448000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000002C73A552E067D4 >									
346 	//     < RUSS_PFVIII_I_metadata_line_33_____OGK_2_SEROV_GRES_20211101 >									
347 	//        < 2qiyz4IjMlO6rTJS8bVqwpB11Gj1yM0MFG1648O4aNuzKhzW3XQJ9kAFJ1cH2gh8 >									
348 	//        <  u =="0.000000000000000001" : ] 000000482610755.518448000000000000 ; 000000495876795.698782000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000002E067D42F4A5E0 >									
350 	//     < RUSS_PFVIII_I_metadata_line_34_____OGK_2_STAVROPOL_GRES_20211101 >									
351 	//        < In38IzJuo056cEH2Q58kCS92a5pj638xT7KQbS7fRip8M8NBE3oAxH2v7GWraHad >									
352 	//        <  u =="0.000000000000000001" : ] 000000495876795.698782000000000000 ; 000000511379690.148449000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000002F4A5E030C4DB1 >									
354 	//     < RUSS_PFVIII_I_metadata_line_35_____OGK_2_SURGUT_GRES_20211101 >									
355 	//        < p02a4K8WM84T7boKsxaOM8zoCyo4IK5e2Zk6rZOc7HM6GTjED8m13Y7206xK9Jv3 >									
356 	//        <  u =="0.000000000000000001" : ] 000000511379690.148449000000000000 ; 000000524658654.932574000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000030C4DB132090C9 >									
358 	//     < RUSS_PFVIII_I_metadata_line_36_____OGK_2_TROITSK_GRES_20211101 >									
359 	//        < BwQB1iyb347jkQK1Vf3N1miZCyHYrhB4vJ6k3EMw8alRrw2XNkjp8lQoi0bin5Rs >									
360 	//        <  u =="0.000000000000000001" : ] 000000524658654.932574000000000000 ; 000000538188031.516506000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000032090C933535B3 >									
362 	//     < RUSS_PFVIII_I_metadata_line_37_____OGK_2_NOVOCHERKASSK_GRES_20211101 >									
363 	//        < MXBVnUB5nQpd8Q2r91Q842Kot5l90X88l2P4OgeCC1axZDPods206RzV08lEKYEl >									
364 	//        <  u =="0.000000000000000001" : ] 000000538188031.516506000000000000 ; 000000552576311.822452000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000033535B334B2A1F >									
366 	//     < RUSS_PFVIII_I_metadata_line_38_____OGK_2_KIRISHI_GRES_20211101 >									
367 	//        < qN7W7K90ZnQ1UKUP1UvL636Lr7sWkE6wx43sFb2q4IWLWBnH2Br4zt4pmFd4DKHP >									
368 	//        <  u =="0.000000000000000001" : ] 000000552576311.822452000000000000 ; 000000568166052.437758000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000034B2A1F362F3DD >									
370 	//     < RUSS_PFVIII_I_metadata_line_39_____OGK_2_RYAZAN_GRES_20211101 >									
371 	//        < 44844I310b4a0Km8FHk2n7L7Y89pLmBsE5cLGM0pE770AUA7V67j6dGbqJv9Oazy >									
372 	//        <  u =="0.000000000000000001" : ] 000000568166052.437758000000000000 ; 000000584058091.009368000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000362F3DD37B33B1 >									
374 	//     < RUSS_PFVIII_I_metadata_line_40_____OGK_2_KRASNOYARSK_GRES_20211101 >									
375 	//        < b5Q4Dj1C1A2A9wNVecmwf71st6S549pOWKFBY5xdx85I6Uc7f3a2j8fdx5Lk0771 >									
376 	//        <  u =="0.000000000000000001" : ] 000000584058091.009368000000000000 ; 000000598947743.475382000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000037B33B1391EBF6 >									
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