1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFVI_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFVI_III_883		"	;
8 		string	public		symbol =	"	RUSS_PFVI_III_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1055519864651380000000000000					;	
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
92 	//     < RUSS_PFVI_III_metadata_line_1_____UPRECHISTENKA1_3319C1_MOS_RUS_I_20251101 >									
93 	//        < V7KWi267b2F7Bu7TsWkSQiU34ZkWsLiO5ktha84RtEaHTzfH4zM9ykv335pOg7IB >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000029160644.751826900000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000002C7EE0 >									
96 	//     < RUSS_PFVI_III_metadata_line_2_____UPRECHISTENKA1_3319C1_MOS_RUS_II_20251101 >									
97 	//        < 55zzsyI69F0omOU8iPc6P2UZbAeyTI8h349sdwqDCltc3zrQO3o0JCV6QCUYZdtu >									
98 	//        <  u =="0.000000000000000001" : ] 000000029160644.751826900000000000 ; 000000055380094.841484500000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000002C7EE05480D9 >									
100 	//     < RUSS_PFVI_III_metadata_line_3_____UPRECHISTENKA1_3319C1_MOS_RUS_III_20251101 >									
101 	//        < 51f333NXM393Z7B6J18OpfbXHFzE423vt50478U6X96p8tLOp8rC33h4fINjL4Ln >									
102 	//        <  u =="0.000000000000000001" : ] 000000055380094.841484500000000000 ; 000000075587636.772327500000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000005480D973566C >									
104 	//     < RUSS_PFVI_III_metadata_line_4_____UPRECHISTENKA1_3319C1_MOS_RUS_IV_20251101 >									
105 	//        < zlF77waXBs1H1mSyvq7g6E67P1H3f1ydj2vr9wvMO0n6pLKN3yc6M4t1VV5Bg2Xc >									
106 	//        <  u =="0.000000000000000001" : ] 000000075587636.772327500000000000 ; 000000095027241.766801000000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000073566C910004 >									
108 	//     < RUSS_PFVI_III_metadata_line_5_____UPRECHISTENKA1_3319C1_MOS_RUS_V_20251101 >									
109 	//        < f66Lghv0gHcP6EN26S69M3HCP94uaxmZmXy5i6zm6jo49uV2t14zFurv2yT73tsF >									
110 	//        <  u =="0.000000000000000001" : ] 000000095027241.766801000000000000 ; 000000114039652.789693000000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000910004AE02BD >									
112 	//     < RUSS_PFVI_III_metadata_line_6_____UPRECHISTENKA1_3319C1_MOS_RUS_VI_20251101 >									
113 	//        < my3Sy33Y5EX14O8I2ylUJdAXrvB03QKrtY38jVrO3Ec4a0JD1Z45Vk4nLbZKYzzC >									
114 	//        <  u =="0.000000000000000001" : ] 000000114039652.789693000000000000 ; 000000147972334.701886000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000AE02BDE1C9B1 >									
116 	//     < RUSS_PFVI_III_metadata_line_7_____UPRECHISTENKA1_3319C1_MOS_RUS_VII_20251101 >									
117 	//        < rU05yV7vBwiU030iNHrEJH4m6ELLXg8jAk17h6r29AuLH37l7uiGR6YAu806fM49 >									
118 	//        <  u =="0.000000000000000001" : ] 000000147972334.701886000000000000 ; 000000175007154.837223000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000000E1C9B110B0A2B >									
120 	//     < RUSS_PFVI_III_metadata_line_8_____UPRECHISTENKA1_3319C1_MOS_RUS_VIII_20251101 >									
121 	//        < 1Csp8X6MUKBTMZ3X5ZJfeIDl79A8m4teY5516KfHJOvJjCy326j6IDNfrBro98G1 >									
122 	//        <  u =="0.000000000000000001" : ] 000000175007154.837223000000000000 ; 000000204863580.420812000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000010B0A2B13898D6 >									
124 	//     < RUSS_PFVI_III_metadata_line_9_____UPRECHISTENKA1_3319C1_MOS_RUS_IX_20251101 >									
125 	//        < 34A0w6XsddlI3L9152C2rz8yTLWxrZ5fem564U74wCHed5CnQ1xC45tF5IeaLm2y >									
126 	//        <  u =="0.000000000000000001" : ] 000000204863580.420812000000000000 ; 000000231040971.807916000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000013898D61608A61 >									
128 	//     < RUSS_PFVI_III_metadata_line_10_____UPRECHISTENKA1_3319C1_MOS_RUS_X_20251101 >									
129 	//        < VZCNpP6xS7Gtif6y2B91c1J406o1M7VAl598rp7NjP7L5cmj6kSG3G1evS64dkV6 >									
130 	//        <  u =="0.000000000000000001" : ] 000000231040971.807916000000000000 ; 000000251243965.046076000000000000 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000000001608A6117F5E2D >									
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
174 	//     < RUSS_PFVI_III_metadata_line_11_____UPRECHISTENKA2_3319C1_MOS_RUS_I_20251101 >									
175 	//        < svv06T8nnEgA0794AoQle0TGYlh3468MQCbcuST7E435QPS77Kn2o6LGdr76pJI7 >									
176 	//        <  u =="0.000000000000000001" : ] 000000251243965.046076000000000000 ; 000000286499568.599493000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000017F5E2D1B529E5 >									
178 	//     < RUSS_PFVI_III_metadata_line_12_____UPRECHISTENKA2_3319C1_MOS_RUS_II_20251101 >									
179 	//        < 47oQl84cmi9qS75Sp1QFj8z50Fgfwg2Lafj26NxdPoSA19AXTZwPM56co2MCi9T9 >									
180 	//        <  u =="0.000000000000000001" : ] 000000286499568.599493000000000000 ; 000000312581742.045375000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000001B529E51DCF63E >									
182 	//     < RUSS_PFVI_III_metadata_line_13_____UPRECHISTENKA2_3319C1_MOS_RUS_III_20251101 >									
183 	//        < mp4sxn0Isk97J6wwQ3h0PJkq9KZLy7G81u80a29Xm8Xf5cDnS61A87lt5wx2uov6 >									
184 	//        <  u =="0.000000000000000001" : ] 000000312581742.045375000000000000 ; 000000331909978.121275000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001DCF63E1FA7456 >									
186 	//     < RUSS_PFVI_III_metadata_line_14_____UPRECHISTENKA2_3319C1_MOS_RUS_IV_20251101 >									
187 	//        < Pl0P6hQeADn0uGi1mbz4R162NuzTwm1O8Bg366rL8X5xbE9cV4nC9t3AJ9rB7x1A >									
188 	//        <  u =="0.000000000000000001" : ] 000000331909978.121275000000000000 ; 000000357809262.840640000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000001FA7456221F93E >									
190 	//     < RUSS_PFVI_III_metadata_line_15_____UPRECHISTENKA2_3319C1_MOS_RUS_V_20251101 >									
191 	//        < TAM93xDYrH45df20Y57FUu2osX1qNqK93Gcf8jR4071inT5x74INl1lZ57wr52Lh >									
192 	//        <  u =="0.000000000000000001" : ] 000000357809262.840640000000000000 ; 000000381063687.784302000000000000 ] >									
193 	//        < 0x00000000000000000000000000000000000000000000000000221F93E2457501 >									
194 	//     < RUSS_PFVI_III_metadata_line_16_____UPRECHISTENKA2_3319C1_MOS_RUS_VI_20251101 >									
195 	//        < unOv3830ps6f9Le0qzFQnWzuf1C95Bgo8Kxx643EH16TiXR5vSp36YUTzGZM1XYu >									
196 	//        <  u =="0.000000000000000001" : ] 000000381063687.784302000000000000 ; 000000406853776.605066000000000000 ] >									
197 	//        < 0x00000000000000000000000000000000000000000000000000245750126CCF42 >									
198 	//     < RUSS_PFVI_III_metadata_line_17_____UPRECHISTENKA2_3319C1_MOS_RUS_VII_20251101 >									
199 	//        < HZvwtr0V9h0FL1OJOi0piWw22kcy8724r4s21SBV2Kl4Cks8j98JSyWTj61m3x3E >									
200 	//        <  u =="0.000000000000000001" : ] 000000406853776.605066000000000000 ; 000000436641079.554104000000000000 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000000026CCF4229A42EC >									
202 	//     < RUSS_PFVI_III_metadata_line_18_____UPRECHISTENKA2_3319C1_MOS_RUS_VIII_20251101 >									
203 	//        < WiVr5dBH4eO7Lz1BsXhB84eaxh4iA6eK5H9wHnKr2YI9E88w5u9OT9xQylReI30Q >									
204 	//        <  u =="0.000000000000000001" : ] 000000436641079.554104000000000000 ; 000000459579863.672500000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000029A42EC2BD4362 >									
206 	//     < RUSS_PFVI_III_metadata_line_19_____UPRECHISTENKA2_3319C1_MOS_RUS_IX_20251101 >									
207 	//        < ep5oG8M9GiFrg01c11aS4Bp6rI3l60Yg8Yak8z4W1YElN4wr0ZDfx6QRb3wV7rTi >									
208 	//        <  u =="0.000000000000000001" : ] 000000459579863.672500000000000000 ; 000000490730928.875990000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000002BD43622ECCBC5 >									
210 	//     < RUSS_PFVI_III_metadata_line_20_____UPRECHISTENKA2_3319C1_MOS_RUS_X_20251101 >									
211 	//        < 4tb8um3S9yP7Ld55Y480l3BO6h2TBdIE611Lmbp2924lL58k5ek3VW1VqY56R24Y >									
212 	//        <  u =="0.000000000000000001" : ] 000000490730928.875990000000000000 ; 000000520849939.812340000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000002ECCBC531AC102 >									
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
256 	//     < RUSS_PFVI_III_metadata_line_21_____UPRECHISTENKA2_3319C1_MOS_RUS_I_20251101 >									
257 	//        < 454btYbA388u6JJHeV10wrR5uY3ZXVaJ2962W8fLalR08X2ToX4C1hZMA17vCOGh >									
258 	//        <  u =="0.000000000000000001" : ] 000000520849939.812340000000000000 ; 000000555069315.186369000000000000 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000000031AC10234EF7F4 >									
260 	//     < RUSS_PFVI_III_metadata_line_22_____UPRECHISTENKA2_3319C1_MOS_RUS_II_20251101 >									
261 	//        < Bj1ew6iX3RhKmR3RjhjBW597JJGOLOn3nO8fM1Y7sk1y1Jzi32732kXpJ7S194z8 >									
262 	//        <  u =="0.000000000000000001" : ] 000000555069315.186369000000000000 ; 000000578968731.980281000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000034EF7F43736FA9 >									
264 	//     < RUSS_PFVI_III_metadata_line_23_____UPRECHISTENKA2_3319C1_MOS_RUS_III_20251101 >									
265 	//        < bkf24uYBlxjrzR1xquVR14BT3YAUp2YgeMu0PDsr2ZGrFdb4lpjrwM6m67948Je7 >									
266 	//        <  u =="0.000000000000000001" : ] 000000578968731.980281000000000000 ; 000000606570669.371933000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000003736FA939D8DAB >									
268 	//     < RUSS_PFVI_III_metadata_line_24_____UPRECHISTENKA2_3319C1_MOS_RUS_IV_20251101 >									
269 	//        < 9KnYICaoO58rsKQRGI9W3w9mdeg2y6lPCnBlZ3qJjq4h6NMV62mhs0oqY7HufdX8 >									
270 	//        <  u =="0.000000000000000001" : ] 000000606570669.371933000000000000 ; 000000632795351.078438000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000039D8DAB3C591AF >									
272 	//     < RUSS_PFVI_III_metadata_line_25_____UPRECHISTENKA2_3319C1_MOS_RUS_V_20251101 >									
273 	//        < e9XFHEzA4fwAoU8lg2027B1K886YDNiv5Bv4Cq5g19T0cx44x3i7RJzS4yhRL7Ij >									
274 	//        <  u =="0.000000000000000001" : ] 000000632795351.078438000000000000 ; 000000663314026.420242000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000003C591AF3F4230B >									
276 	//     < RUSS_PFVI_III_metadata_line_26_____UPRECHISTENKA2_3319C1_MOS_RUS_VI_20251101 >									
277 	//        < gCc17tfRi5DDs14IRMFydJKv5P5HxF74sh5zs73c1r2f8pb5l09v742NVTOGAF2U >									
278 	//        <  u =="0.000000000000000001" : ] 000000663314026.420242000000000000 ; 000000694891015.749432000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000003F4230B42451CE >									
280 	//     < RUSS_PFVI_III_metadata_line_27_____UPRECHISTENKA2_3319C1_MOS_RUS_VII_20251101 >									
281 	//        < 16Hl8CPMhxXhfhB04PULbUGOvj2djZZ7WQEn7i36iCTliKn71nRSc72B58evxziq >									
282 	//        <  u =="0.000000000000000001" : ] 000000694891015.749432000000000000 ; 000000719268188.810041000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000042451CE4498423 >									
284 	//     < RUSS_PFVI_III_metadata_line_28_____UPRECHISTENKA2_3319C1_MOS_RUS_VIII_20251101 >									
285 	//        < 8hFM0Rz594s6VgvSLh04KxziA66aM1Wl05G7sHr5Wtt00s53l1He9xaQLJDB4IKA >									
286 	//        <  u =="0.000000000000000001" : ] 000000719268188.810041000000000000 ; 000000741004120.068633000000000000 ] >									
287 	//        < 0x00000000000000000000000000000000000000000000000000449842346AAEBC >									
288 	//     < RUSS_PFVI_III_metadata_line_29_____UPRECHISTENKA2_3319C1_MOS_RUS_IX_20251101 >									
289 	//        < 752xFB6l94MBJoMIq4loqgDSRrzXUmB9p00G7d6fCSH8W6jx6ixjt01RDbk11n0w >									
290 	//        <  u =="0.000000000000000001" : ] 000000741004120.068633000000000000 ; 000000760490599.107436000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000046AAEBC4886AA4 >									
292 	//     < RUSS_PFVI_III_metadata_line_30_____UPRECHISTENKA2_3319C1_MOS_RUS_X_20251101 >									
293 	//        < si7dWja257G95l9NswT78Br1pcOqqCP8A710YA6PQCT472m802Imr11v5q436Jzd >									
294 	//        <  u =="0.000000000000000001" : ] 000000760490599.107436000000000000 ; 000000787749804.064849000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000004886AA44B202C4 >									
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
338 	//     < RUSS_PFVI_III_metadata_line_31_____UPRECHISTENKA3_3319C1_MOS_RUS_I_20251101 >									
339 	//        < 3i9wC8KaO2SU25urukl5q5kY4CaYEk3fmC42dfT5qM121HpCl43yg8j3JFcyS96m >									
340 	//        <  u =="0.000000000000000001" : ] 000000787749804.064849000000000000 ; 000000806417218.748316000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000004B202C44CE7EBA >									
342 	//     < RUSS_PFVI_III_metadata_line_32_____UPRECHISTENKA3_3319C1_MOS_RUS_II_20251101 >									
343 	//        < opO2Fey9G7X8uj9K4Ni2WAI773Coo8QKCNwF5Ahk49lNAFEu8NQ3dnT5O2i9sJCe >									
344 	//        <  u =="0.000000000000000001" : ] 000000806417218.748316000000000000 ; 000000832997091.020978000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000004CE7EBA4F70D7D >									
346 	//     < RUSS_PFVI_III_metadata_line_33_____UPRECHISTENKA3_3319C1_MOS_RUS_III_20251101 >									
347 	//        < 4a3tVEFGSwZmquv4703B989i5p7662089KJr0jl65cll4is79o15b14FRv0qRzJL >									
348 	//        <  u =="0.000000000000000001" : ] 000000832997091.020978000000000000 ; 000000854234335.559068000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000004F70D7D517754A >									
350 	//     < RUSS_PFVI_III_metadata_line_34_____UPRECHISTENKA3_3319C1_MOS_RUS_IV_20251101 >									
351 	//        < FX9xf6HSN8Z0vKxOFdS210M38774Ne4ND0WAZQq5c4fEb8E0F44N4mm6ZOZL41NT >									
352 	//        <  u =="0.000000000000000001" : ] 000000854234335.559068000000000000 ; 000000887758991.619172000000000000 ] >									
353 	//        < 0x00000000000000000000000000000000000000000000000000517754A54A9CDB >									
354 	//     < RUSS_PFVI_III_metadata_line_35_____UPRECHISTENKA3_3319C1_MOS_RUS_V_20251101 >									
355 	//        < 39r9p206WhPwR0lHys14VT4x94uz737P6sZIabn207x0QYy0w4tnjCkvv7UwAwlP >									
356 	//        <  u =="0.000000000000000001" : ] 000000887758991.619172000000000000 ; 000000916196469.627678000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000054A9CDB576013F >									
358 	//     < RUSS_PFVI_III_metadata_line_36_____UPRECHISTENKA3_3319C1_MOS_RUS_VI_20251101 >									
359 	//        < LgaFM39hDn8TntKxjbmgD3VRk0o4UPcG93XQwWBO57E829N2Qwhwra9yPca53A70 >									
360 	//        <  u =="0.000000000000000001" : ] 000000916196469.627678000000000000 ; 000000947391432.702391000000000000 ] >									
361 	//        < 0x00000000000000000000000000000000000000000000000000576013F5A59AC7 >									
362 	//     < RUSS_PFVI_III_metadata_line_37_____UPRECHISTENKA3_3319C1_MOS_RUS_VII_20251101 >									
363 	//        < ur151Hhi1347Pq9S9rc2w6tyJ81it3Id8kU04L7U9fIBxl40VE8OV3JTUZM0og3I >									
364 	//        <  u =="0.000000000000000001" : ] 000000947391432.702391000000000000 ; 000000972437073.902059000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000005A59AC75CBD23B >									
366 	//     < RUSS_PFVI_III_metadata_line_38_____UPRECHISTENKA3_3319C1_MOS_RUS_VIII_20251101 >									
367 	//        < 8aNYsCPD1V7BD7RkTIA9Xu40YydvCLfop113gd02j2NO6Pp1690MSAEZ1hWB1gb5 >									
368 	//        <  u =="0.000000000000000001" : ] 000000972437073.902059000000000000 ; 000001000714257.270370000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000005CBD23B5F6F802 >									
370 	//     < RUSS_PFVI_III_metadata_line_39_____UPRECHISTENKA3_3319C1_MOS_RUS_IX_20251101 >									
371 	//        < k490o12e4B4USZj5Lms58UBV31DyQd92IRu095oep7091F7zu1s19yEwkeUmPlQn >									
372 	//        <  u =="0.000000000000000001" : ] 000001000714257.270370000000000000 ; 000001033299834.285560000000000000 ] >									
373 	//        < 0x000000000000000000000000000000000000000000000000005F6F802628B0BF >									
374 	//     < RUSS_PFVI_III_metadata_line_40_____UPRECHISTENKA3_3319C1_MOS_RUS_X_20251101 >									
375 	//        < 5xn4a6cjPrTpJ0RL26mTJ3mVcVY73Sw6c148dP0C49ot166KW44a7FiQphZYHtPs >									
376 	//        <  u =="0.000000000000000001" : ] 000001033299834.285560000000000000 ; 000001055519864.651380000000000000 ] >									
377 	//        < 0x00000000000000000000000000000000000000000000000000628B0BF64A9872 >									
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