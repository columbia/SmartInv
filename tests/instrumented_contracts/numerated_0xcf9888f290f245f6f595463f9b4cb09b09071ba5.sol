1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RE_Portfolio_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RE_Portfolio_III_883		"	;
8 		string	public		symbol =	"	RE883III		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1428500225823590000000000000					;	
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
92 	//     < RE_Portfolio_III_metadata_line_1_____ANV_Syndicates_Limited_20250515 >									
93 	//        < 7N6Dk8Gio8xncEOjU86Uh11II00P5puMq3Fc36i86mddphNuIBIYN1u7S7mYRC22 >									
94 	//        < 1E-018 limites [ 1E-018 ; 10463953,2355295 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000003E5EBBAF >									
96 	//     < RE_Portfolio_III_metadata_line_2_____ANV_Syndicates_Limited_20250515 >									
97 	//        < nbo4oQhdGFkzUwtbC65s53AIcjk8BE677J6872Sr3YBDz938pjo2K4MRHU4jTU29 >									
98 	//        < 1E-018 limites [ 10463953,2355295 ; 28638065,381621 ] >									
99 	//        < 0x0000000000000000000000000000000000000000000000003E5EBBAFAAB23A3E >									
100 	//     < RE_Portfolio_III_metadata_line_3_____ANV_Syndicates_Limited_20250515 >									
101 	//        < XV6v2q487c1c4O7hF1BvciLwL45c6hv7JMD72ALctXWuBfmSRuKx05lUcwcSPHDj >									
102 	//        < 1E-018 limites [ 28638065,381621 ; 43938346,0765835 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000AAB23A3E105E49A63 >									
104 	//     < RE_Portfolio_III_metadata_line_4_____ANV_Syndicates_Limited_20250515 >									
105 	//        < 4a183zPqOO1nTg3YG0zSt69Uz0W3v8Q80hW4T9oY47z7mH33JdXo4874WF84zcir >									
106 	//        < 1E-018 limites [ 43938346,0765835 ; 85458105,4915343 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000105E49A631FD5EBA69 >									
108 	//     < RE_Portfolio_III_metadata_line_5_____ANV_Syndicates_Limited_20250515 >									
109 	//        < LCQZr9IBe7bOhNXvsM14B8uyjXqVOhbgrV92LN4D9E3rXeegVre9pMU2w2S7ams1 >									
110 	//        < 1E-018 limites [ 85458105,4915343 ; 96433837,1604093 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000001FD5EBA6923ECA5D98 >									
112 	//     < RE_Portfolio_III_metadata_line_6_____Aon_20250515 >									
113 	//        < kqy3XBkLGp2E6f3YzuMPm5Fsj2Z3ShebHjsk88L3Z2Wfzl6IZu0I3f4A94snERB3 >									
114 	//        < 1E-018 limites [ 96433837,1604093 ; 112019961,47251 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000023ECA5D9829BB0E767 >									
116 	//     < RE_Portfolio_III_metadata_line_7_____Aon_20250515 >									
117 	//        < 2ahuAkXqEH62rCeS1FpWVJa3Vjlmb55fzx7iS35wpaPfnudvwl69BBE9k3fsI6pi >									
118 	//        < 1E-018 limites [ 112019961,47251 ; 145922665,927234 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000029BB0E767365C45354 >									
120 	//     < RE_Portfolio_III_metadata_line_8_____Apollo_Syndicate_Management_Limited_20250515 >									
121 	//        < 5YXy8Vbn0pg4023N37zzA6ILG56Q5o14ldgH5EKU7NIchAzUjFmCPC0FJd3H4ATA >									
122 	//        < 1E-018 limites [ 145922665,927234 ; 159786968,037229 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000365C453543B8679257 >									
124 	//     < RE_Portfolio_III_metadata_line_9_____Apollo_Syndicate_Management_Limited_20250515 >									
125 	//        < UPkDPODz4MH84pxD2d14Mj69hE5933rniI2FZ70v77s4447iJ8cuPAAm9TeMUrlF >									
126 	//        < 1E-018 limites [ 159786968,037229 ; 228331531,58341 ] >									
127 	//        < 0x00000000000000000000000000000000000000000000003B8679257550F6467A >									
128 	//     < RE_Portfolio_III_metadata_line_10_____Apollo_Syndicate_Management_Limited_20250515 >									
129 	//        < c8UPHsc3E90OCtAYzSrY05mh0mJ01OGl731DqbzMG98Il8yj9gW90xmNQ94E3w08 >									
130 	//        < 1E-018 limites [ 228331531,58341 ; 276044721,837841 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000550F6467A66D5AD36B >									
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
174 	//     < RE_Portfolio_III_metadata_line_11_____Applied_Insurance_Research_20250515 >									
175 	//        < g6K6qjv40hKUQyt9p9lBsMkpiq0PwX1bvPIyn6N3E7TWdtmR03E5u3d7U9fmUsJi >									
176 	//        < 1E-018 limites [ 276044721,837841 ; 337326932,494631 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000066D5AD36B7DAA00EF5 >									
178 	//     < RE_Portfolio_III_metadata_line_12_____Applied_Insurance_Research_20250515 >									
179 	//        < 42HRRiPC0Dx5iSL9gWuAirUAE4A0Je29OcourgzWy9bCOo65620ov4C39r2d7WdE >									
180 	//        < 1E-018 limites [ 337326932,494631 ; 371203835,410037 ] >									
181 	//        < 0x00000000000000000000000000000000000000000000007DAA00EF58A48C1C29 >									
182 	//     < RE_Portfolio_III_metadata_line_13_____Arab_Insurance_Group___ARIG___m_Bpp_20250515 >									
183 	//        < 10NM84q1670n21bK82K9MP71n3FW1KSKw9EH8kpK0eRlfsFY5oQSqBvf4813bIc3 >									
184 	//        < 1E-018 limites [ 371203835,410037 ; 396159335,174049 ] >									
185 	//        < 0x00000000000000000000000000000000000000000000008A48C1C299394B2E41 >									
186 	//     < RE_Portfolio_III_metadata_line_14_____Arab_Insurance_Group___ARIG___m_Bpp_20250515 >									
187 	//        < HBiSqP8v3guclVL7e7QVD5mm1Ak9eb9V75bcEnGa897gfB2BK50Kv01hOSL3yaQw >									
188 	//        < 1E-018 limites [ 396159335,174049 ; 418274267,871409 ] >									
189 	//        < 0x00000000000000000000000000000000000000000000009394B2E419BD1BE3D7 >									
190 	//     < RE_Portfolio_III_metadata_line_15_____Arab_Reinsurance_Company_20250515 >									
191 	//        < 57Lobqn3rNyOLk1ez5fZxw15SZplJBv6Tl46p7y92pHNe9fzI3b1xUfL7gB4X6Y0 >									
192 	//        < 1E-018 limites [ 418274267,871409 ; 449471538,13906 ] >									
193 	//        < 0x00000000000000000000000000000000000000000000009BD1BE3D7A770F2589 >									
194 	//     < RE_Portfolio_III_metadata_line_16_____Arab_Reinsurance_Company_20250515 >									
195 	//        < 66d7FA8SR7H9r4tm7io5YD8t6uGiE06K11gYH2bzQ773J9RZcHssKzLhq4LT5Irs >									
196 	//        < 1E-018 limites [ 449471538,13906 ; 526891354,690947 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000A770F2589C44846961 >									
198 	//     < RE_Portfolio_III_metadata_line_17_____Arch_Capital_Group_Limited_20250515 >									
199 	//        < 4MC2JPkO5UhW0ohNg5LYQ8ZvWUD9vqi3W6CFTCAP5881NGeIUgBqP0DIL6iZRt3L >									
200 	//        < 1E-018 limites [ 526891354,690947 ; 543746402,677441 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000C44846961CA8FB2C7F >									
202 	//     < RE_Portfolio_III_metadata_line_18_____Arch_Insurance_Co__Europe__Limited_Ap_Ap_20250515 >									
203 	//        < bCZZBsPc2ZfslYwJkUGL2Glp6qjoJo8V6t6wjTCrC7MMyoqDq1L6wQjPIf21orm1 >									
204 	//        < 1E-018 limites [ 543746402,677441 ; 557500027,866389 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000CA8FB2C7FCFAF58A56 >									
206 	//     < RE_Portfolio_III_metadata_line_19_____Arch_Re_Ap_Ap_20250515 >									
207 	//        < sf0UnuHn93zCWF97d1m1qF3XT8Hv8ejL7pKaV1K0vSnAn7uRI730QR5AeCeZdOR7 >									
208 	//        < 1E-018 limites [ 557500027,866389 ; 591344873,705104 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000CFAF58A56DC4B0AD3E >									
210 	//     < RE_Portfolio_III_metadata_line_20_____Arch_Underwriting_at_Lloyd_s_Limited_20250515 >									
211 	//        < 7PC71jged0eJzSi2sf85y5pvY44I27ks2r2vnN1ZI32c1y6Yz7O6f92uOoS30nkj >									
212 	//        < 1E-018 limites [ 591344873,705104 ; 602495811,294365 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000DC4B0AD3EE0727A83D >									
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
256 	//     < RE_Portfolio_III_metadata_line_21_____Arch_Underwriting_at_Lloyd_s_Limited_20250515 >									
257 	//        < Ev7k356sA0k7OcaKvtmFnLG5TfNOE993V51i2Gt4sQi61JGr1a9Jgw8O0gxlw6AP >									
258 	//        < 1E-018 limites [ 602495811,294365 ; 621583020,855492 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000E0727A83DE78EC6D79 >									
260 	//     < RE_Portfolio_III_metadata_line_22_____ARDAF_Insurance_Reinsurance_20250515 >									
261 	//        < 3ug4QW2p5182G6V26DF8PeEnMtPUg78M9IxcLtXn8N9f2X525d2CDM0xj73QT0or >									
262 	//        < 1E-018 limites [ 621583020,855492 ; 694894265,326738 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000E78EC6D79102DE48258 >									
264 	//     < RE_Portfolio_III_metadata_line_23_____ARDAF_Insurance_Reinsurance_20250515 >									
265 	//        < u69u9LK7m9Bs3K8gbT01XEJd2vqbWt8eE2By2k3yRTr7RaC514Ul6os4FFxTdRtf >									
266 	//        < 1E-018 limites [ 694894265,326738 ; 768158672,301927 ] >									
267 	//        < 0x00000000000000000000000000000000000000000000102DE4825811E2951F52 >									
268 	//     < RE_Portfolio_III_metadata_line_24_____Argenta_Syndicate_Management_Limited_20250515 >									
269 	//        < C8w9smg406552BYuZcwe9L1n75Y0dEN2L4ItHGZ7no0Vv216991KOH0QvICnc1aT >									
270 	//        < 1E-018 limites [ 768158672,301927 ; 797316207,671731 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000011E2951F5212905FFD93 >									
272 	//     < RE_Portfolio_III_metadata_line_25_____Argenta_Syndicate_Management_Limited_20250515 >									
273 	//        < vyBX7ps63JuQ5F4A64FfCX00UDr80654X5iLMtP90HGVy1Uy2gjOV8ND32vSTS3Z >									
274 	//        < 1E-018 limites [ 797316207,671731 ; 818134317,195205 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000012905FFD93130C75E79B >									
276 	//     < RE_Portfolio_III_metadata_line_26_____Argenta_Syndicate_Management_Limited_20250515 >									
277 	//        < Jh8x2qlgHLPv9vWelF2XA3y579VtUq3lf1AXB44011HceYymJCiw0jqDp9zMxe9k >									
278 	//        < 1E-018 limites [ 818134317,195205 ; 886687234,532951 ] >									
279 	//        < 0x00000000000000000000000000000000000000000000130C75E79B14A5115AF1 >									
280 	//     < RE_Portfolio_III_metadata_line_27_____Argenta_Syndicate_Management_Limited_20250515 >									
281 	//        < HQrDeJYRbXDZCuKCvNKpEv4v8u2FUFxC2bd0RYn06drp4v6w6tjhpbE3J59FUvDA >									
282 	//        < 1E-018 limites [ 886687234,532951 ; 913940297,46038 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000014A5115AF11547823AA6 >									
284 	//     < RE_Portfolio_III_metadata_line_28_____Argenta_Syndicate_Management_Limited_20250515 >									
285 	//        < J3IV0Ol36067gCFCfwdd1hwIrJEHH0VRwW1NbnNw3W5ijvG68uvn9Ga4Btlj5ksp >									
286 	//        < 1E-018 limites [ 913940297,46038 ; 952946516,39597 ] >									
287 	//        < 0x000000000000000000000000000000000000000000001547823AA6163000FEEB >									
288 	//     < RE_Portfolio_III_metadata_line_29_____Argo_Group_20250515 >									
289 	//        < t76lq12xousmR1r12y5l08DrI94577J1243KT26t5b4eA16W5ZI49n77gK8jfr1f >									
290 	//        < 1E-018 limites [ 952946516,39597 ; 983798390,983051 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000163000FEEB16E7E5386E >									
292 	//     < RE_Portfolio_III_metadata_line_30_____Argo_Group_20250515 >									
293 	//        < Eb1Y1dr9mVntdpg4PP596g3FX6eIXKJnflcp24543hOfOIQ5J7rwRnSezPyW7W8M >									
294 	//        < 1E-018 limites [ 983798390,983051 ; 1003707831,53188 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000016E7E5386E175E909DA5 >									
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
338 	//     < RE_Portfolio_III_metadata_line_31_____Argo_Managing_Agency_Limited_20250515 >									
339 	//        < 52f1BD52Yp3217Hfxjm8r2IYUKv7isWMZ0WO69n8qK890uBlNorNmC6WnYv2oU8k >									
340 	//        < 1E-018 limites [ 1003707831,53188 ; 1082977078,00083 ] >									
341 	//        < 0x00000000000000000000000000000000000000000000175E909DA519370BE30C >									
342 	//     < RE_Portfolio_III_metadata_line_32_____Argo_Managing_Agency_Limited_20250515 >									
343 	//        < xc48kg1d5D7WN9m3Koo3nB34Yan50ozU820s7xne1pW67cqGEYI6ed2me0L59Ao1 >									
344 	//        < 1E-018 limites [ 1082977078,00083 ; 1096814000,41496 ] >									
345 	//        < 0x0000000000000000000000000000000000000000000019370BE30C1989855ADD >									
346 	//     < RE_Portfolio_III_metadata_line_33_____Argo_Managing_Agency_Limited_20250515 >									
347 	//        < alo8qHM7WJRuuvUX2fafD0mCZw09r5mk7m8Ou49rM7YMO61R52L8oHbk2GRG6h6Z >									
348 	//        < 1E-018 limites [ 1096814000,41496 ; 1129321741,74424 ] >									
349 	//        < 0x000000000000000000000000000000000000000000001989855ADD1A4B483B52 >									
350 	//     < RE_Portfolio_III_metadata_line_34_____Argo_Managing_Agency_Limited_20250515 >									
351 	//        < foG0k01Kc1Y3p3zZLz1I4IwFs217JGgIV2Goa7dlw9M8U6H6v7i78o26O514Yq30 >									
352 	//        < 1E-018 limites [ 1129321741,74424 ; 1166709573,14631 ] >									
353 	//        < 0x000000000000000000000000000000000000000000001A4B483B521B2A2188F6 >									
354 	//     < RE_Portfolio_III_metadata_line_35_____Argo_Managing_Agency_Limited_20250515 >									
355 	//        < 0e9UKluyPFJJw6mP4x58o32vhpG8wBhIuC9T0B79827YJ88dp48v0sgu22zt6VJ4 >									
356 	//        < 1E-018 limites [ 1166709573,14631 ; 1206307260,38694 ] >									
357 	//        < 0x000000000000000000000000000000000000000000001B2A2188F61C1626CF8A >									
358 	//     < RE_Portfolio_III_metadata_line_36_____Argo_Managing_Agency_Limited_20250515 >									
359 	//        < l1es6lnp8T39ZGKPir1gQl6C76ijMR9pmHD75GW0zwK1b6rr1o23124N6bww0b81 >									
360 	//        < 1E-018 limites [ 1206307260,38694 ;  ] >									
361 	//        < 0x000000000000000000000000000000000000000000001C1626CF8A1CC15D1BF3 >									
362 	//     < RE_Portfolio_III_metadata_line_37_____Argo_Managing_Agency_Limited_20250515 >									
363 	//        < uolxrKbwmd68mp4O4N8zikmZ9vS0w465HuxFz2yAqwMA316aRX8U2Pxj7d1hP372 >									
364 	//        < 1E-018 limites [ 1235031884,79536 ; 1297786088,4799 ] >									
365 	//        < 0x000000000000000000000000000000000000000000001CC15D1BF31E37686CC3 >									
366 	//     < RE_Portfolio_III_metadata_line_38_____Argo_Re_A_20250515 >									
367 	//        < E2Ai7Hzu521HCzc72Owo1Czmm4w2K49r3tBvs2tAn7TusxX9HK9TCheg36dNSlpS >									
368 	//        < 1E-018 limites [ 1297786088,4799 ; 1356690476,39651 ] >									
369 	//        < 0x000000000000000000000000000000000000000000001E37686CC31F9681634B >									
370 	//     < RE_Portfolio_III_metadata_line_39_____Ariel_Holdings_Limited_20250515 >									
371 	//        < o4oQ3hnehguFadXz9jlme9o9IFi49L5cbu1Q0xjzsg60d4KRtbu4v5NTV089253v >									
372 	//        < 1E-018 limites [ 1356690476,39651 ; 1413422403,06593 ] >									
373 	//        < 0x000000000000000000000000000000000000000000001F9681634B20E8A77026 >									
374 	//     < RE_Portfolio_III_metadata_line_40_____Ark_Syndicate_Management_Limited_20250515 >									
375 	//        < 7lVi6KD7A454148Yw40v71HaC8RFO72kJ702KIAn3PPLAhfPf9IW6X4Bv398POyk >									
376 	//        < 1E-018 limites [ 1413422403,06593 ; 1428500225,82359 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000020E8A770262142865EAA >									
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