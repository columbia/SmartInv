1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXXVI_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXXVI_I_883		"	;
8 		string	public		symbol =	"	RUSS_PFXXVI_I_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		597398420107890000000000000					;	
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
92 	//     < RUSS_PFXXVI_I_metadata_line_1_____BLUE_STREAM_PIPE_CO_20211101 >									
93 	//        < 2vCxuqyQr19wiw6rc0PS91r1tPweU65LA4xxY4I1X98dU7NFjj2322sUQ6FB2exf >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000015691195.555114700000000000 ] >									
95 	//        < 0x0000000000000000000000000000000000000000000000000000000000000vol >									
96 	//     < RUSS_PFXXVI_I_metadata_line_2_____BLUESTREAM_DAO_20211101 >									
97 	//        < IVbL1rNiFT2rkgLx32hKB5krZ5csP1eJWf77C6BwoQV1bfX6gE5wo7AFED8u4fcr >									
98 	//        <  u =="0.000000000000000001" : ] 000000015691195.555114700000000000 ; 000000030341662.653143500000000000 ] >									
99 	//        < 0x0000000000000000000000000000000000000000000000000000000vol2E4C36 >									
100 	//     < RUSS_PFXXVI_I_metadata_line_3_____BLUESTREAM_DAOPI_20211101 >									
101 	//        < kjFklEr7RW103oa0J91080L8y56460AHBYQv15kd0Uj62nI7s1kV866u7W5aZ72T >									
102 	//        <  u =="0.000000000000000001" : ] 000000030341662.653143500000000000 ; 000000044449381.693938100000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000002E4C3643D30A >									
104 	//     < RUSS_PFXXVI_I_metadata_line_4_____BLUESTREAM_DAC_20211101 >									
105 	//        < 0R9xvJmF2n2CWjdPbUy0bJ5PBxbYrQ30V22yoNpy5ugBXHF6ee5xp4ag99hrhHv4 >									
106 	//        <  u =="0.000000000000000001" : ] 000000044449381.693938100000000000 ; 000000060794362.638626300000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000043D30A5CC3CC >									
108 	//     < RUSS_PFXXVI_I_metadata_line_5_____BLUESTREAM_BIMI_20211101 >									
109 	//        < CfD3ApWqNHiT4qGaihu9G58i29H9DR8b2v1X05AqP38HU1fTq843C4jjNQj7w3b9 >									
110 	//        <  u =="0.000000000000000001" : ] 000000060794362.638626300000000000 ; 000000075210673.963441100000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000005CC3CC72C32B >									
112 	//     < RUSS_PFXXVI_I_metadata_line_6_____PANRUSGAZ_20211101 >									
113 	//        < iZo62CY85qvr2Ri2Lz3VqbpR6HUaJhRo2BrsYsg47Oef36OJ19rQIot2hJ4jNJdU >									
114 	//        <  u =="0.000000000000000001" : ] 000000075210673.963441100000000000 ; 000000090218879.196565600000000000 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000000000072C32B89A9C0 >									
116 	//     < RUSS_PFXXVI_I_metadata_line_7_____OKHRANA_PSC_20211101 >									
117 	//        < BzYEeia492r3NV3QZcC6e9V980k0T694u8spD15KX1xYs2Qs310YzIZu8K6J9qa5 >									
118 	//        <  u =="0.000000000000000001" : ] 000000090218879.196565600000000000 ; 000000107425949.844002000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000000089A9C0A3EB43 >									
120 	//     < RUSS_PFXXVI_I_metadata_line_8_____PROEKTIROVANYE_OOO_20211101 >									
121 	//        < 0I0FkWbC3AN5CIiryl2u7k316o1CtEbmv3mnt8LB2lcjwFqOu35OgmHaFScDq3tl >									
122 	//        <  u =="0.000000000000000001" : ] 000000107425949.844002000000000000 ; 000000121470626.447997000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000A3EB43B95977 >									
124 	//     < RUSS_PFXXVI_I_metadata_line_9_____YUGOROSGAZ_20211101 >									
125 	//        < 7qThTV15f8EP9WErv72S4xQltI4E6H3b04AE8TGxdpEcTvvSzdW888IsaAweJt6s >									
126 	//        <  u =="0.000000000000000001" : ] 000000121470626.447997000000000000 ; 000000134938265.091841000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000000B95977CDE643 >									
128 	//     < RUSS_PFXXVI_I_metadata_line_10_____GAZPROM_FINANCE_BV_20211101 >									
129 	//        < V7oRzSW4kJoZIa4ehF4u9eWg1VN59Cjf20RvkJ6T7It8P9HXcUJ1eDtgGUrUms83 >									
130 	//        <  u =="0.000000000000000001" : ] 000000134938265.091841000000000000 ; 000000148695776.649708000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000000CDE643E2E44A >									
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
174 	//     < RUSS_PFXXVI_I_metadata_line_11_____WINTERSHALL_NOORDZEE_BV_20211101 >									
175 	//        < l57m92KDZMO3tVSHNmwc1fGr7kSSdEVqV04EkX87tpXz9uUpmHOmJP6K7Q4go2KJ >									
176 	//        <  u =="0.000000000000000001" : ] 000000148695776.649708000000000000 ; 000000164741357.401717000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000000E2E44AFB6018 >									
178 	//     < RUSS_PFXXVI_I_metadata_line_12_____WINTERSHALL_DAO_20211101 >									
179 	//        < 48fq5LSn2Z6YaCGZsVKMV649czZWcdg8S5YbS2wKh7617n83LGqD73P7984dg1eB >									
180 	//        <  u =="0.000000000000000001" : ] 000000164741357.401717000000000000 ; 000000177959711.041544000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000000FB601810F8B83 >									
182 	//     < RUSS_PFXXVI_I_metadata_line_13_____WINTERSHALL_DAOPI_20211101 >									
183 	//        < i08IZr599a08LIbGaMH6014DWxIVDn7a9OgIF38kTRHEsqE6IIF70931KpSoA9l6 >									
184 	//        <  u =="0.000000000000000001" : ] 000000177959711.041544000000000000 ; 000000193904204.474186000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000010F8B83127DFD4 >									
186 	//     < RUSS_PFXXVI_I_metadata_line_14_____WINTERSHALL_DAC_20211101 >									
187 	//        < ow07A1o1wN5j86vl40u0u66Ldw6QvQ2psg7657jzy50OrZfy3YxhwDjV8NuF482P >									
188 	//        <  u =="0.000000000000000001" : ] 000000193904204.474186000000000000 ; 000000208038565.858059000000000000 ] >									
189 	//        < 0x00000000000000000000000000000000000000000000000000127DFD413D7111 >									
190 	//     < RUSS_PFXXVI_I_metadata_line_15_____WINTERSHALL_BIMI_20211101 >									
191 	//        < 7R5PVv1Pw7b3KD5C3cSD0bQ6NKJX45meAzwU6DMStVW6l7kn4H7aaze6032D3i9l >									
192 	//        <  u =="0.000000000000000001" : ] 000000208038565.858059000000000000 ; 000000221192908.031351000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000013D7111151837B >									
194 	//     < RUSS_PFXXVI_I_metadata_line_16_____SAKHALIN_HOLDINGS_BV_20211101 >									
195 	//        < 269KC3vmfZf56yFbcD1bXj3Zt1H0M36otMHcdAOIuUJ49f1pbkmQck01u86aA935 >									
196 	//        <  u =="0.000000000000000001" : ] 000000221192908.031351000000000000 ; 000000237956558.696856000000000000 ] >									
197 	//        < 0x00000000000000000000000000000000000000000000000000151837B16B17C8 >									
198 	//     < RUSS_PFXXVI_I_metadata_line_17_____TRANSGAS_KAZAN_20211101 >									
199 	//        < ntcFQ4O8b7y4o7Gg710XrkNS26RCF7nPN4EN6Y3nWhT0oId5r7rjH8hes47ddLBL >									
200 	//        <  u =="0.000000000000000001" : ] 000000237956558.696856000000000000 ; 000000251860326.922263000000000000 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000000016B17C81804EF1 >									
202 	//     < RUSS_PFXXVI_I_metadata_line_18_____SOUTH_STREAM_SERBIA_20211101 >									
203 	//        < X9B9jkHsGUktbLcTf37TXiL78VL8icQ4aqS30S0XNg919pWRpXuA0Du3atI4e331 >									
204 	//        <  u =="0.000000000000000001" : ] 000000251860326.922263000000000000 ; 000000264914118.916926000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000001804EF11943A14 >									
206 	//     < RUSS_PFXXVI_I_metadata_line_19_____WINTERSHALL_ERDGAS_HANDELSHAUS_ZUG_AG_20211101 >									
207 	//        < 5Te60wYiPRj0K590r7fwhWNL330I80uU218CH8rwqq31X49D3pR8Oc9J352ibrHv >									
208 	//        <  u =="0.000000000000000001" : ] 000000264914118.916926000000000000 ; 000000281120837.906509000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000001943A141ACF4D4 >									
210 	//     < RUSS_PFXXVI_I_metadata_line_20_____TRANSGAZ_MOSCOW_OOO_20211101 >									
211 	//        < 0X3S8519HFf4Z4zw2tBGgN6nlM6t3NN8OtiD0FJ70z45c8ObD82Y5GsM1hjeMQew >									
212 	//        <  u =="0.000000000000000001" : ] 000000281120837.906509000000000000 ; 000000294593513.980193000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000001ACF4D41C18397 >									
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
256 	//     < RUSS_PFXXVI_I_metadata_line_21_____PERERABOTKA_20211101 >									
257 	//        < 0AD4MoLgC07O7kZe0y1JByCsY6X25lpzgN8xv8ZBXIa8hG6A87iJPa75V7mlBCdH >									
258 	//        <  u =="0.000000000000000001" : ] 000000294593513.980193000000000000 ; 000000309716809.847577000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000001C183971D89721 >									
260 	//     < RUSS_PFXXVI_I_metadata_line_22_____GAZPROM_EXPORT_20211101 >									
261 	//        < vM5TntB57d4ZLsf456j97v4M255991dsi4p5Ti8Yh4Gv0t0747GU35hle8heiV22 >									
262 	//        <  u =="0.000000000000000001" : ] 000000309716809.847577000000000000 ; 000000325121705.600796000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000001D897211F018AB >									
264 	//     < RUSS_PFXXVI_I_metadata_line_23_____WINGAS_20211101 >									
265 	//        < 70Ex90ZLv3rD09t04BNBgYNG14IYZOZ9R9f7ZcDth3680I4cMf9KbAahuBV5QR47 >									
266 	//        <  u =="0.000000000000000001" : ] 000000325121705.600796000000000000 ; 000000341904207.939949000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000001F018AB209B455 >									
268 	//     < RUSS_PFXXVI_I_metadata_line_24_____DOBYCHA_URENGOY_20211101 >									
269 	//        < Jt7d4ov2VO7ckA6VL4y83wXdYSF35ZdB75CvquaIjU98jP7TGOzhF4sY3t3Sp9Dk >									
270 	//        <  u =="0.000000000000000001" : ] 000000341904207.939949000000000000 ; 000000354920885.654381000000000000 ] >									
271 	//        < 0x00000000000000000000000000000000000000000000000000209B45521D90F9 >									
272 	//     < RUSS_PFXXVI_I_metadata_line_25_____MOSENERGO_20211101 >									
273 	//        < 8Mh9I565QFn183xrfnPZxm3fsc2d2OK2Q6i72rVcj493YsIuk4b4l8611w9e9bWf >									
274 	//        <  u =="0.000000000000000001" : ] 000000354920885.654381000000000000 ; 000000369865272.973153000000000000 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000000000021D90F92345E9F >									
276 	//     < RUSS_PFXXVI_I_metadata_line_26_____OGK_2_AB_20211101 >									
277 	//        < yOqAUjpHMauzKFTO5Hd6958u4ZadmQwNWE7scUiYNCc02o72v73Mhu801xM5C60R >									
278 	//        <  u =="0.000000000000000001" : ] 000000369865272.973153000000000000 ; 000000386148003.825198000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000002345E9F24D3710 >									
280 	//     < RUSS_PFXXVI_I_metadata_line_27_____TGC_1_20211101 >									
281 	//        < RqYP1TU91YsK12yAi150Dk48jL02rJow8cbDTO2M0Azw99hj6j0QS53A6z1Jamo3 >									
282 	//        <  u =="0.000000000000000001" : ] 000000386148003.825198000000000000 ; 000000399511726.253528000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000024D37102619B45 >									
284 	//     < RUSS_PFXXVI_I_metadata_line_28_____GAZPROM_MEDIA_20211101 >									
285 	//        < uKrz9BPAgU89PbxyYxr3za96zxYYc36FCd8Kz8618u7YEMMuuB8b2bHh9kbya4Ee >									
286 	//        <  u =="0.000000000000000001" : ] 000000399511726.253528000000000000 ; 000000414254425.243005000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000002619B452781A23 >									
288 	//     < RUSS_PFXXVI_I_metadata_line_29_____ENERGOHOLDING_LLC_20211101 >									
289 	//        < 9F37rqYO6935Hag4K7nfV60KVgZ4KBI7K1DNCoY6D99CLhg2p63EdpEgfC795VNF >									
290 	//        <  u =="0.000000000000000001" : ] 000000414254425.243005000000000000 ; 000000429062606.863069000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000002781A2328EB295 >									
292 	//     < RUSS_PFXXVI_I_metadata_line_30_____TRANSGAZ_TOMSK_OOO_20211101 >									
293 	//        < pPSyfZyi10pkGsuias3X4W5mj1x97iJrZmoRk59eDThr8qhDS4MI0f5NDku3BVqc >									
294 	//        <  u =="0.000000000000000001" : ] 000000429062606.863069000000000000 ; 000000445807466.511251000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000028EB2952A83F8B >									
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
338 	//     < RUSS_PFXXVI_I_metadata_line_31_____DOBYCHA_YAMBURG_20211101 >									
339 	//        < PbUEMcJcvAft7j57xAkwZzCIa7Jt13u0v9FbRh8XVNO81nn16kBhG1370612x4mJ >									
340 	//        <  u =="0.000000000000000001" : ] 000000445807466.511251000000000000 ; 000000461697961.645928000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000002A83F8B2C07EC4 >									
342 	//     < RUSS_PFXXVI_I_metadata_line_32_____YAMBURG_DAO_20211101 >									
343 	//        < 50XR0Q9D91nG52xNjzQ6mVNy2dH8l0Tj3Xs5MN738WG1I1DHoT5I92nM7MnuZL9m >									
344 	//        <  u =="0.000000000000000001" : ] 000000461697961.645928000000000000 ; 000000478175542.196753000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000002C07EC42D9A352 >									
346 	//     < RUSS_PFXXVI_I_metadata_line_33_____YAMBURG_DAOPI_20211101 >									
347 	//        < eaGTWPxiA1N3v9725z8v6JVBC3hFVWA36F9OvBvGNnY8w3qm949vS703vWytgnM4 >									
348 	//        <  u =="0.000000000000000001" : ] 000000478175542.196753000000000000 ; 000000493301041.364002000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000002D9A3522F0B7B8 >									
350 	//     < RUSS_PFXXVI_I_metadata_line_34_____YAMBURG_DAC_20211101 >									
351 	//        < z1y4X64FyaK6DURcbZt8Z7g0Y4LfKAab2nuvU5JG14CGPid4EiXJXIivVphtxS2S >									
352 	//        <  u =="0.000000000000000001" : ] 000000493301041.364002000000000000 ; 000000507587334.046677000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000002F0B7B8306844D >									
354 	//     < RUSS_PFXXVI_I_metadata_line_35_____YAMBURG_BIMI_20211101 >									
355 	//        < 94isX5XT4U9dn1ScHgUA1uC380KWD5aYPDttL4g2ZO6RhcsBn88vtUY4XJ21iwT9 >									
356 	//        <  u =="0.000000000000000001" : ] 000000507587334.046677000000000000 ; 000000523699925.908685000000000000 ] >									
357 	//        < 0x00000000000000000000000000000000000000000000000000306844D31F1A49 >									
358 	//     < RUSS_PFXXVI_I_metadata_line_36_____EP_INTERNATIONAL_BV_20211101 >									
359 	//        < 4Z0zXFGmGBQbBB3X8B3488rrhkZ2DACV1HA8gsZUr42FJioJ0do1iE4RkNC1G27P >									
360 	//        <  u =="0.000000000000000001" : ] 000000523699925.908685000000000000 ; 000000536724295.265251000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000031F1A49332F9EE >									
362 	//     < RUSS_PFXXVI_I_metadata_line_37_____TRANSGAZ_YUGORSK_20211101 >									
363 	//        < bddmgL2RTu4a4O1jlJhitOxd598d3xY8YQBUs4E14H3z3tyDyXlHQx8e0Mo77qPP >									
364 	//        <  u =="0.000000000000000001" : ] 000000536724295.265251000000000000 ; 000000549768166.277501000000000000 ] >									
365 	//        < 0x00000000000000000000000000000000000000000000000000332F9EE346E131 >									
366 	//     < RUSS_PFXXVI_I_metadata_line_38_____GAZPROM_GERMANIA_20211101 >									
367 	//        < mJ9u665R6whgot5MMIe8V5Kef8Yht7kNsg8WYlqAVU1bhLGuMVxWWt98qIsx615N >									
368 	//        <  u =="0.000000000000000001" : ] 000000549768166.277501000000000000 ; 000000565885325.809461000000000000 ] >									
369 	//        < 0x00000000000000000000000000000000000000000000000000346E13135F78F5 >									
370 	//     < RUSS_PFXXVI_I_metadata_line_39_____GAZPROMENERGO_20211101 >									
371 	//        < 5txjoY1mWWsQHl2OJ23Cf1FiTjBG4EA2wLdz02STkCrL27WhfRrCz8TBDAU7ur41 >									
372 	//        <  u =="0.000000000000000001" : ] 000000565885325.809461000000000000 ; 000000582018303.394599000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000035F78F537816E6 >									
374 	//     < RUSS_PFXXVI_I_metadata_line_40_____INDUSTRIJA_SRBIJE_20211101 >									
375 	//        < 63G35DV03CSyZklAjp5tg6Bo4Ss66QOv28iBfU7SP5hOj7iUg7k7J11PulW135P0 >									
376 	//        <  u =="0.000000000000000001" : ] 000000582018303.394599000000000000 ; 000000597398420.107890000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000037816E638F8EC2 >									
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