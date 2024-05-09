1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXXX_II_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXXX_II_883		"	;
8 		string	public		symbol =	"	RUSS_PFXXX_II_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		796077025090406000000000000					;	
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
92 	//     < RUSS_PFXXX_II_metadata_line_1_____CANPOTEX_20231101 >									
93 	//        < oju43e603a00XL9rzHSszfRE7h3glIEz8s7bS28QY7UW4hnh6LwE8LKs747M7LpE >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000016979768.242053300000000000 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000000019E8B9 >									
96 	//     < RUSS_PFXXX_II_metadata_line_2_____CANPOTEX_SHIPPING_SERVICES_20231101 >									
97 	//        < F0nBr5z2hz99BK0T0sNWy9t17oStt9GjeeXdA3MqT63w0ycMj18cTA1jzA7Y7x30 >									
98 	//        <  u =="0.000000000000000001" : ] 000000016979768.242053300000000000 ; 000000038364988.464842100000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000019E8B93A8A53 >									
100 	//     < RUSS_PFXXX_II_metadata_line_3_____CANPOTEX_INT_PTE_LIMITED_20231101 >									
101 	//        < s8XA6bp8To6i2858P67Yqjfae8i6hTmkg5b3NiM0rb3fN0fOSHsucGo26s9ISZc8 >									
102 	//        <  u =="0.000000000000000001" : ] 000000038364988.464842100000000000 ; 000000060084410.668212000000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000003A8A535BAE79 >									
104 	//     < RUSS_PFXXX_II_metadata_line_4_____PORTLAND_BULK_TERMINALS_LLC_20231101 >									
105 	//        < eowjc7cgGtU6vf3PPir7l12jmWU0YQ3lciwdjqzL517kC00uHNvd5JZD5zKFuuq1 >									
106 	//        <  u =="0.000000000000000001" : ] 000000060084410.668212000000000000 ; 000000078567091.377297200000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000005BAE7977E245 >									
108 	//     < RUSS_PFXXX_II_metadata_line_5_____CANPOTEX_INT_CANCADA_LTD_20231101 >									
109 	//        < NjbQ223Ati1r36G3YO6Go9Rq63t3m1kk2LVFbAPz4yw44JsAve4m4P9C3YotO4ll >									
110 	//        <  u =="0.000000000000000001" : ] 000000078567091.377297200000000000 ; 000000094890965.801275500000000000 ] >									
111 	//        < 0x000000000000000000000000000000000000000000000000000077E24590CAC9 >									
112 	//     < RUSS_PFXXX_II_metadata_line_6_____CANPOTEX_HK_LIMITED_20231101 >									
113 	//        < VFc3uLuoNArlnqJGYeMAMYN43ah30yVL96o9K7KADLylVm7NMy3F9YFyaPr92d1M >									
114 	//        <  u =="0.000000000000000001" : ] 000000094890965.801275500000000000 ; 000000112029406.292658000000000000 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000000000090CAC9AAF17D >									
116 	//     < RUSS_PFXXX_II_metadata_line_7_____CANPOTEX_ORG_20231101 >									
117 	//        < 9ZhZysLfBP45w3cSqHF3zueVhp1ltg7RZ00PuxELdek2qBQseEcqX9pceBhHTyVZ >									
118 	//        <  u =="0.000000000000000001" : ] 000000112029406.292658000000000000 ; 000000130984169.363765000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000AAF17DC7DDB1 >									
120 	//     < RUSS_PFXXX_II_metadata_line_8_____CANPOTEX_FND_20231101 >									
121 	//        < EHeue3dVSB1B4KqLJ9u46pc98irY5cloHs0kC64jJ8f7ca762qtSjls6TN8n5piA >									
122 	//        <  u =="0.000000000000000001" : ] 000000130984169.363765000000000000 ; 000000148309068.518726000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000C7DDB1E24D3B >									
124 	//     < RUSS_PFXXX_II_metadata_line_9_____CANPOTEX_gbp_20231101 >									
125 	//        < GohStP4NaPpKvoV9L2BYP6MGu5n8uIC6Sr84i9L4mbmyVX8t9jgg62S044M95YaK >									
126 	//        <  u =="0.000000000000000001" : ] 000000148309068.518726000000000000 ; 000000167291581.131645000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000000E24D3BFF4446 >									
128 	//     < RUSS_PFXXX_II_metadata_line_10_____CANPOTEX_SHIPPING_SERVICES_gbp_20231101 >									
129 	//        < YiqAphWQqxI67hXrFRH6s53oMM72p7lmQMQHJH4QgBZc02Nv9y294Its9FYtN638 >									
130 	//        <  u =="0.000000000000000001" : ] 000000167291581.131645000000000000 ; 000000185214381.011149000000000000 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000000000FF444611A9D5E >									
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
174 	//     < RUSS_PFXXX_II_metadata_line_11_____CANPOTEX_INT_PTE_LIMITED_gbp_20231101 >									
175 	//        < p36sLy3Zx7aA5D77kQwdN6lzMFgRQYt42tHaEH10K511zk0X7OfiCO9D5YVluIni >									
176 	//        <  u =="0.000000000000000001" : ] 000000185214381.011149000000000000 ; 000000205086091.519594000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000011A9D5E138EFC1 >									
178 	//     < RUSS_PFXXX_II_metadata_line_12_____PORTLAND_BULK_TERMINALS_LLC_gbp_20231101 >									
179 	//        < dQ66IgB7qwFdHoJK8q6m17lYMBR3w8kYWwyrOh74pP25wqC68DI3Rvu3e9Fd9FPZ >									
180 	//        <  u =="0.000000000000000001" : ] 000000205086091.519594000000000000 ; 000000224285262.093701000000000000 ] >									
181 	//        < 0x00000000000000000000000000000000000000000000000000138EFC11563B6E >									
182 	//     < RUSS_PFXXX_II_metadata_line_13_____CANPOTEX_INT_CANCADA_LTD_gbp_20231101 >									
183 	//        < 1I5KJbpFKv9YoXY4Ujx2ya8sv997SgkdT3r3B8XRQg3XwE6Tew68r1DCAnwL4IOS >									
184 	//        <  u =="0.000000000000000001" : ] 000000224285262.093701000000000000 ; 000000246708419.724455000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001563B6E178727A >									
186 	//     < RUSS_PFXXX_II_metadata_line_14_____CANPOTEX_HK_LIMITED_gbp_20231101 >									
187 	//        < mqXh50fcU7m7z2Efvcz5b98p32M1nlSlyjFkIjSfIo2631klLzd1RZhA0qAF2q9z >									
188 	//        <  u =="0.000000000000000001" : ] 000000246708419.724455000000000000 ; 000000270756130.126162000000000000 ] >									
189 	//        < 0x00000000000000000000000000000000000000000000000000178727A19D241D >									
190 	//     < RUSS_PFXXX_II_metadata_line_15_____CANPOTEX_ORG_gbp_20231101 >									
191 	//        < 9w7WI05AMKBsZVGKt017401Jn0j9BqnvYP78shetBVjA3v2CeFy2e965vQUJqhb5 >									
192 	//        <  u =="0.000000000000000001" : ] 000000270756130.126162000000000000 ; 000000288096482.667216000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000019D241D1B799B0 >									
194 	//     < RUSS_PFXXX_II_metadata_line_16_____CANPOTEX_FND_gbp_20231101 >									
195 	//        < JOdoU9qNBg9Br2e0UJ0G6Ph4V6ni52bW6I647FdH27340O9T6iV7EiWzHW6w4QcI >									
196 	//        <  u =="0.000000000000000001" : ] 000000288096482.667216000000000000 ; 000000308221736.244338000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000001B799B01D64F1E >									
198 	//     < RUSS_PFXXX_II_metadata_line_17_____CANPOTEX_usd_20231101 >									
199 	//        < sP4rtBFt9kZ2Qzx5dOWNb36Rol2l8afrYxU2ul5YB47b2Wy1fHMT496sn6H41dnk >									
200 	//        <  u =="0.000000000000000001" : ] 000000308221736.244338000000000000 ; 000000327706011.821959000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000001D64F1E1F40A29 >									
202 	//     < RUSS_PFXXX_II_metadata_line_18_____CANPOTEX_SHIPPING_SERVICES_usd_20231101 >									
203 	//        < zjdI2dUGyC4um1PXs231OhI7BIwF1tBhRO00AO2908B553B9176s5h17D6QyJo93 >									
204 	//        <  u =="0.000000000000000001" : ] 000000327706011.821959000000000000 ; 000000351233529.412103000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000001F40A29217F099 >									
206 	//     < RUSS_PFXXX_II_metadata_line_19_____CANPOTEX_INT_PTE_LIMITED_usd_20231101 >									
207 	//        < 95JwleoFewesiUxYsW6IXP5BbpfEO7Mx30JpHTY5JXr1Kis5AJeV1D9ZxfhmIOf0 >									
208 	//        <  u =="0.000000000000000001" : ] 000000351233529.412103000000000000 ; 000000371390240.759689000000000000 ] >									
209 	//        < 0x00000000000000000000000000000000000000000000000000217F099236B250 >									
210 	//     < RUSS_PFXXX_II_metadata_line_20_____PORTLAND_BULK_TERMINALS_LLC_usd_20231101 >									
211 	//        < p899e39hfpFpkZ30234h5wVP8hYW0ma1cDJN0q62AYRFzHbgKW7c31jgjf24AW0k >									
212 	//        <  u =="0.000000000000000001" : ] 000000371390240.759689000000000000 ; 000000388475400.375084000000000000 ] >									
213 	//        < 0x00000000000000000000000000000000000000000000000000236B250250C434 >									
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
256 	//     < RUSS_PFXXX_II_metadata_line_21_____CANPOTEX_INT_CANCADA_LTD_usd_20231101 >									
257 	//        < j76q0kvrQMC4vJNvb616YlCKOmH356bmnstU515Q81cxTZzW2e4TL46510q1mxaV >									
258 	//        <  u =="0.000000000000000001" : ] 000000388475400.375084000000000000 ; 000000406911717.244640000000000000 ] >									
259 	//        < 0x00000000000000000000000000000000000000000000000000250C43426CE5E4 >									
260 	//     < RUSS_PFXXX_II_metadata_line_22_____CANPOTEX_HK_LIMITED_usd_20231101 >									
261 	//        < Zw6uy7Dj8Y45QVgyxFqZlJdh5Lj994vkrjFveEeq5hM1afY964G9vVoYGkPSML65 >									
262 	//        <  u =="0.000000000000000001" : ] 000000406911717.244640000000000000 ; 000000427255127.021215000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000026CE5E428BF089 >									
264 	//     < RUSS_PFXXX_II_metadata_line_23_____CANPOTEX_ORG_usd_20231101 >									
265 	//        < F1r4CMEi7P49UyqWXq1H06VFKWIIhCkx29z7dkz3opE05fyYKzttsf8sUQW81UUl >									
266 	//        <  u =="0.000000000000000001" : ] 000000427255127.021215000000000000 ; 000000446881724.472845000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000028BF0892A9E32C >									
268 	//     < RUSS_PFXXX_II_metadata_line_24_____CANPOTEX_FND_usd_20231101 >									
269 	//        < kp3Q1V1ViDp281jde774nJFgml5U0637p6CJ0z038226GiEYTPLJcQCwca46JIV6 >									
270 	//        <  u =="0.000000000000000001" : ] 000000446881724.472845000000000000 ; 000000468936245.218499000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000002A9E32C2CB8A39 >									
272 	//     < RUSS_PFXXX_II_metadata_line_25_____CANPOTEX_chf_20231101 >									
273 	//        < 9bSb268wJb874e58uAu0fibIcksjMO8omjx1Qvi9344q7C1D1uFSs7RAUXiVcnXD >									
274 	//        <  u =="0.000000000000000001" : ] 000000468936245.218499000000000000 ; 000000487538622.022687000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002CB8A392E7ECC6 >									
276 	//     < RUSS_PFXXX_II_metadata_line_26_____CANPOTEX_SHIPPING_SERVICES_chf_20231101 >									
277 	//        < 60LALE6yLsM3WwiOe9US949sp1w7e0661aYe6YjbNkOfN0A6RcTqOLjL0mL3DCd5 >									
278 	//        <  u =="0.000000000000000001" : ] 000000487538622.022687000000000000 ; 000000506672344.226696000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000002E7ECC63051EE2 >									
280 	//     < RUSS_PFXXX_II_metadata_line_27_____CANPOTEX_INT_PTE_LIMITED_chf_20231101 >									
281 	//        < haU7qDNXm7P0Mu0RW9JVf9O9Gxd10vkbyzhDUI56h50grYK5HT7wGbVJM5hL2yK2 >									
282 	//        <  u =="0.000000000000000001" : ] 000000506672344.226696000000000000 ; 000000523950418.069970000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000003051EE231F7C22 >									
284 	//     < RUSS_PFXXX_II_metadata_line_28_____PORTLAND_BULK_TERMINALS_LLC_chf_20231101 >									
285 	//        < cXAs4ak3s4NNi2ZcYU4zfp7E23aw0rc1U68279u2Mj3I1Wo2N4r9hUtaXJm8TncL >									
286 	//        <  u =="0.000000000000000001" : ] 000000523950418.069970000000000000 ; 000000546281792.847544000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000031F7C223418F53 >									
288 	//     < RUSS_PFXXX_II_metadata_line_29_____CANPOTEX_INT_CANCADA_LTD_chf_20231101 >									
289 	//        < Flh9xao12Rr9T27N9rWZBQlqb21Z0YU20x3cnd0Zx3I2hcwfys42RY4T2TV6LhJ0 >									
290 	//        <  u =="0.000000000000000001" : ] 000000546281792.847544000000000000 ; 000000567679153.295709000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000003418F5336235AB >									
292 	//     < RUSS_PFXXX_II_metadata_line_30_____CANPOTEX_HK_LIMITED_chf_20231101 >									
293 	//        < 4ob7Ep10hfK5FXzD4577dHf7SPnVW4GNsnYQ6b6ka09Awug74u02I7F8J9Il0vm1 >									
294 	//        <  u =="0.000000000000000001" : ] 000000567679153.295709000000000000 ; 000000591331894.444568000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000036235AB3864D05 >									
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
338 	//     < RUSS_PFXXX_II_metadata_line_31_____CANPOTEX_ORG_chf_20231101 >									
339 	//        < c6awI0a862gv0i1N7DTFHYA04Xv3wesMM60dO6s9sR1sSUa341lSo657jd29lD16 >									
340 	//        <  u =="0.000000000000000001" : ] 000000591331894.444568000000000000 ; 000000609603881.996833000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000003864D053A22E84 >									
342 	//     < RUSS_PFXXX_II_metadata_line_32_____CANPOTEX_FND_chf_20231101 >									
343 	//        < Kn4D5pu86seVK43ZWt3l9i7BgBQTeZ3D3r59AcCZYj27fw2yf84G0783VGufTynk >									
344 	//        <  u =="0.000000000000000001" : ] 000000609603881.996833000000000000 ; 000000632362254.878915000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000003A22E843C4E881 >									
346 	//     < RUSS_PFXXX_II_metadata_line_33_____CANPOTEX_eur_20231101 >									
347 	//        < Kc8i4Sih12qp4cLQZ3bkct40Z5diPA16kvbwh6r3Wv3auRqLg40wi54Zrphp2btI >									
348 	//        <  u =="0.000000000000000001" : ] 000000632362254.878915000000000000 ; 000000655364871.081235000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000003C4E8813E801E7 >									
350 	//     < RUSS_PFXXX_II_metadata_line_34_____CANPOTEX_SHIPPING_SERVICES_eur_20231101 >									
351 	//        < hVLF5A1F2IzG72jK5hSJ6TZ5Lm30Expi9HD0nrxJTc0skXNf48kNa4XyULTw0llP >									
352 	//        <  u =="0.000000000000000001" : ] 000000655364871.081235000000000000 ; 000000676946599.921874000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000003E801E7408F044 >									
354 	//     < RUSS_PFXXX_II_metadata_line_35_____CANPOTEX_INT_PTE_LIMITED_eur_20231101 >									
355 	//        < tZ5Uj85O8x31WXO176UkPecGd4NCXU0ksLaB5oK676W3TDRWluYzpO944iZ414m8 >									
356 	//        <  u =="0.000000000000000001" : ] 000000676946599.921874000000000000 ; 000000694285168.608272000000000000 ] >									
357 	//        < 0x00000000000000000000000000000000000000000000000000408F0444236525 >									
358 	//     < RUSS_PFXXX_II_metadata_line_36_____PORTLAND_BULK_TERMINALS_LLC_eur_20231101 >									
359 	//        < kWN1x8Th68z5fMSJLdhTlB1hso48GcgNf9UpxBmi85xtGgF8p4uYwdmqBkXN0902 >									
360 	//        <  u =="0.000000000000000001" : ] 000000694285168.608272000000000000 ; 000000715417671.317604000000000000 ] >									
361 	//        < 0x000000000000000000000000000000000000000000000000004236525443A407 >									
362 	//     < RUSS_PFXXX_II_metadata_line_37_____CANPOTEX_INT_CANCADA_LTD_eur_20231101 >									
363 	//        < hc0p0Eg295U46sC5mc0VV5S75i8JmmI3NRiXE4NODEIz8YXggOM573RqmPxsAD08 >									
364 	//        <  u =="0.000000000000000001" : ] 000000715417671.317604000000000000 ; 000000739005083.267993000000000000 ] >									
365 	//        < 0x00000000000000000000000000000000000000000000000000443A407467A1DC >									
366 	//     < RUSS_PFXXX_II_metadata_line_38_____CANPOTEX_HK_LIMITED_eur_20231101 >									
367 	//        < 4xRw7uw9v66PkrDXQAW1A365d2Yfmvbn5LHFhiX0l6990EBT63Gmq9QnI79zM5kb >									
368 	//        <  u =="0.000000000000000001" : ] 000000739005083.267993000000000000 ; 000000757436169.901528000000000000 ] >									
369 	//        < 0x00000000000000000000000000000000000000000000000000467A1DC483C181 >									
370 	//     < RUSS_PFXXX_II_metadata_line_39_____CANPOTEX_ORG_eur_20231101 >									
371 	//        < Eq50sz282To6g0WQqse0U3Z9mH6th2OSMEZPVv1E7JQG1PPLj8U1zEjucPhM7gd8 >									
372 	//        <  u =="0.000000000000000001" : ] 000000757436169.901528000000000000 ; 000000774498728.550001000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000483C18149DCA91 >									
374 	//     < RUSS_PFXXX_II_metadata_line_40_____CANPOTEX_FND_eur_20231101 >									
375 	//        < hza8aPB5W2Ws23z7ae9Raa7Ew516qM30gA7p9uB7dMzJgL8ah6ZiXdG50cL8BcZf >									
376 	//        <  u =="0.000000000000000001" : ] 000000774498728.550001000000000000 ; 000000796077025.090406000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000049DCA914BEB797 >									
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