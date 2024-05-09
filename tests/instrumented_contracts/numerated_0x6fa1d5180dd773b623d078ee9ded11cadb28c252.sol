1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	AZOV_PFI_II_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	AZOV_PFI_II_883		"	;
8 		string	public		symbol =	"	AZOV_PFI_II_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1196625570779760000000000000					;	
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
92 	//     < AZOV_PFI_II_metadata_line_1_____Berdyansk_org_20231101 >									
93 	//        < F1vWQhc778YvW2fa7jdXy9E0MExj3h8zuxtqhZ5ekfy91O2wWV98Snw5sTiyUQ8z >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000026660856.643350300000000000 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000000028AE66 >									
96 	//     < AZOV_PFI_II_metadata_line_2_____Zaporizhia_org_20231101 >									
97 	//        < h9rpz2yt62dIlD9067a1z5O3bJg3E04ym5N3YiiiY6CwyViV5c2oW6a3xH42mEHh >									
98 	//        <  u =="0.000000000000000001" : ] 000000026660856.643350300000000000 ; 000000060463421.198735200000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000028AE665C4286 >									
100 	//     < AZOV_PFI_II_metadata_line_3_____Berdiansk_Commercial_Sea_Port_20231101 >									
101 	//        < XkAf5N8e3L8jO324p6217e6z3N5azJRLoUX92Rp2S5wLl53p21ORhLMR8M9y9IWE >									
102 	//        <  u =="0.000000000000000001" : ] 000000060463421.198735200000000000 ; 000000078311451.964590700000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000005C4286777E69 >									
104 	//     < AZOV_PFI_II_metadata_line_4_____Soylu_Group_20231101 >									
105 	//        < jocL4K756CAE1DzD842j4ku8Eu449RuUt36iG9FiNkwgE46e6ZfB9isu4H83275U >									
106 	//        <  u =="0.000000000000000001" : ] 000000078311451.964590700000000000 ; 000000094473558.912350100000000000 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000000000777E699027BC >									
108 	//     < AZOV_PFI_II_metadata_line_5_____Soylu_Group_TRK_20231101 >									
109 	//        < u097LpW6TiyAv4f2G2uvdw9GV8RH1vSaCGb0nW92Fs5I8I8q69PLcIC4Yb0S5a28 >									
110 	//        <  u =="0.000000000000000001" : ] 000000094473558.912350100000000000 ; 000000111164823.773369000000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000009027BCA99FC2 >									
112 	//     < AZOV_PFI_II_metadata_line_6_____Ulusoy Holding_20231101 >									
113 	//        < h5znc1es55gqQxnQUl4Z5Eg8zf6Q5Dk11EbNd857eSbVj3SePxORouo0dp52FgYM >									
114 	//        <  u =="0.000000000000000001" : ] 000000111164823.773369000000000000 ; 000000150234226.166469000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000A99FC2E53D3F >									
116 	//     < AZOV_PFI_II_metadata_line_7_____Berdyansk_Sea_Trading_Port_20231101 >									
117 	//        < H7gIc339bDC7WG46kNh4XkY9f3504X3pVNjPiBCFXp27dK35Q8jE7d375Uu0KmY3 >									
118 	//        <  u =="0.000000000000000001" : ] 000000150234226.166469000000000000 ; 000000191168366.348439000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000000E53D3F123B325 >									
120 	//     < AZOV_PFI_II_metadata_line_8_____Marioupol_org_20231101 >									
121 	//        < MpQL3zI8I8rfRTQF0XR2jWUJV4MU339k7Zcb1Rv4k6ujR6dw0MQMJ3VtP5Vx4HLp >									
122 	//        <  u =="0.000000000000000001" : ] 000000191168366.348439000000000000 ; 000000230932703.691755000000000000 ] >									
123 	//        < 0x00000000000000000000000000000000000000000000000000123B3251606016 >									
124 	//     < AZOV_PFI_II_metadata_line_9_____Donetsk_org_20231101 >									
125 	//        < FVWrx2tl0zUz9h076xTDX5HICpY5tqB86U534CGI66u4c6J5Ld8Qq13F14resTDa >									
126 	//        <  u =="0.000000000000000001" : ] 000000230932703.691755000000000000 ; 000000248641331.998501000000000000 ] >									
127 	//        < 0x00000000000000000000000000000000000000000000000000160601617B6585 >									
128 	//     < AZOV_PFI_II_metadata_line_10_____Marioupol_Port_Station_20231101 >									
129 	//        < nepLJs7CQF024y0gI3H69MQG1U0701Hi6i6WlYi8c3h5miSH4GDq2L8XJ7s6Kx73 >									
130 	//        <  u =="0.000000000000000001" : ] 000000248641331.998501000000000000 ; 000000285906973.539601000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000017B65851B44269 >									
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
174 	//     < AZOV_PFI_II_metadata_line_11_____Yeysk_org_20231101 >									
175 	//        < Ne5JwDNWx4QB7xC6Y1uUN8UMdiaZ83BE8X7Q2twTB65sE6F9i7HXe4yr99p3m9ho >									
176 	//        <  u =="0.000000000000000001" : ] 000000285906973.539601000000000000 ; 000000331787135.746815000000000000 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000000001B442691FA445A >									
178 	//     < AZOV_PFI_II_metadata_line_12_____Krasnodar_org_20231101 >									
179 	//        < ViQf89EMURz9weJYo7GE3FaTw6LXLxI9IvUcV76V08E76i4z52VF82d1JsPH50n0 >									
180 	//        <  u =="0.000000000000000001" : ] 000000331787135.746815000000000000 ; 000000373416046.962051000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000001FA445A239C9A5 >									
182 	//     < AZOV_PFI_II_metadata_line_13_____Yeysk_Airport_20231101 >									
183 	//        < d941R7tfELr77R1svon389p3G79yE2p2csb1Ut95EO3LL19gI2ztj74wHjMfaOp6 >									
184 	//        <  u =="0.000000000000000001" : ] 000000373416046.962051000000000000 ; 000000391619611.904469000000000000 ] >									
185 	//        < 0x00000000000000000000000000000000000000000000000000239C9A52559069 >									
186 	//     < AZOV_PFI_II_metadata_line_14_____Kerch_infrastructure_org_20231101 >									
187 	//        < 24b4128Vnp3Oku9mt7TvqPyuV2wbB817GZ3OlKR7y3041aB4VAykUq9B9OZ7U7A6 >									
188 	//        <  u =="0.000000000000000001" : ] 000000391619611.904469000000000000 ; 000000409472511.971419000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000002559069270CE33 >									
190 	//     < AZOV_PFI_II_metadata_line_15_____Kerch_Seaport_org_20231101 >									
191 	//        < Nxt08jfeq7S619qTQV4WttJiy1m1CN8eiJBpw3gUb2aD87jIl5nX4xOhV8sUf0M4 >									
192 	//        <  u =="0.000000000000000001" : ] 000000409472511.971419000000000000 ; 000000436801588.525258000000000000 ] >									
193 	//        < 0x00000000000000000000000000000000000000000000000000270CE3329A819F >									
194 	//     < AZOV_PFI_II_metadata_line_16_____Azov_org_20231101 >									
195 	//        < a8ZJpgIwzmStwBKfSN38qHg2BB1NkdlxuN25OzrK4JkfxzeS0dCl0FPVktwkTt5d >									
196 	//        <  u =="0.000000000000000001" : ] 000000436801588.525258000000000000 ; 000000459036598.117234000000000000 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000000029A819F2BC6F2C >									
198 	//     < AZOV_PFI_II_metadata_line_17_____Azov_Seaport_org_20231101 >									
199 	//        < lznY9J3v5a5ZEDl2TNa6Rbako0v4KgHQMdoTQ7Z7xZUfJG4N4521wyrKa9ntisng >									
200 	//        <  u =="0.000000000000000001" : ] 000000459036598.117234000000000000 ; 000000494190127.960242000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000002BC6F2C2F21305 >									
202 	//     < AZOV_PFI_II_metadata_line_18_____Azovskiy_Portovyy_Elevator_20231101 >									
203 	//        < w7v97630Z19DM8smDT6Jcl94M7sjM4I12396WWpS9yri56rQ4PMT2iJ0JbrZHQ7T >									
204 	//        <  u =="0.000000000000000001" : ] 000000494190127.960242000000000000 ; 000000514815488.041138000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000002F213053118BCD >									
206 	//     < AZOV_PFI_II_metadata_line_19_____Rostov_SLD_org_20231101 >									
207 	//        < oiJ2u2Ls3iFV3tLcNVy4iN35SxO4E4v2nf85cVZ88KoKMj9vye6d2238311S4nj9 >									
208 	//        <  u =="0.000000000000000001" : ] 000000514815488.041138000000000000 ; 000000561245628.597165000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000003118BCD3586493 >									
210 	//     < AZOV_PFI_II_metadata_line_20_____Rentastroy_20231101 >									
211 	//        < GG2RvoQS7J2G8xo06rV3Sk3pUm9FsuNA6rA8l00rIgqtv27asV880GJW7s3bS7l8 >									
212 	//        <  u =="0.000000000000000001" : ] 000000561245628.597165000000000000 ; 000000606797746.315023000000000000 ] >									
213 	//        < 0x00000000000000000000000000000000000000000000000000358649339DE65F >									
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
256 	//     < AZOV_PFI_II_metadata_line_21_____Moscow_Industrial_Bank_20231101 >									
257 	//        < 4Q814HT9m0maKTvKaW25j8t0UCFq0BN8ryAvx8er9rR0W36Z9jnEzlxIkKxQs289 >									
258 	//        <  u =="0.000000000000000001" : ] 000000606797746.315023000000000000 ; 000000630897666.893659000000000000 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000000039DE65F3C2AC67 >									
260 	//     < AZOV_PFI_II_metadata_line_22_____Donmasloprodukt_20231101 >									
261 	//        < EEneL1YHpJkYRT3xA8x0F3g55K2X5Y2412tZs10jpYfXQ1lK0Xj59q2V6eG0N49C >									
262 	//        <  u =="0.000000000000000001" : ] 000000630897666.893659000000000000 ; 000000655316431.586701000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000003C2AC673E7EEFB >									
264 	//     < AZOV_PFI_II_metadata_line_23_____Rostovskiy_Portovyy_Elevator_Kovsh_20231101 >									
265 	//        < 1aKidOlw0l4ZVWWf1Z0pEMo446tT1Fx6E6f793OarkF125jh3f9Rqw0g4ao6VZbr >									
266 	//        <  u =="0.000000000000000001" : ] 000000655316431.586701000000000000 ; 000000682138276.195132000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000003E7EEFB410DC44 >									
268 	//     < AZOV_PFI_II_metadata_line_24_____Rostov_Arena_infratructure_org_20231101 >									
269 	//        < fjjoSp3Zdo5aBxv63407B48frUPN913htDnh4Hm8Ozne4uE4n8moB0LT2cHgsGeF >									
270 	//        <  u =="0.000000000000000001" : ] 000000682138276.195132000000000000 ; 000000709960942.959086000000000000 ] >									
271 	//        < 0x00000000000000000000000000000000000000000000000000410DC4443B507E >									
272 	//     < AZOV_PFI_II_metadata_line_25_____Rostov_Glavny_infrastructure_org_20231101 >									
273 	//        < xBv987E20bQgi4EN1tj7AA7J0Q9JXB8WgjtMwXZxDmi5so003NNULsdU09TGd0b2 >									
274 	//        <  u =="0.000000000000000001" : ] 000000709960942.959086000000000000 ; 000000740379075.764757000000000000 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000000000043B507E469BA94 >									
276 	//     < AZOV_PFI_II_metadata_line_26_____Rostov_Heliport_infrastructure_org_20231101 >									
277 	//        < S8P92IYs3xu6074ZOQkYfam4UsKUrM4i9N9rMtoz7G3J0pF64dv0hGMGk0u5mfnR >									
278 	//        <  u =="0.000000000000000001" : ] 000000740379075.764757000000000000 ; 000000777823994.354558000000000000 ] >									
279 	//        < 0x00000000000000000000000000000000000000000000000000469BA944A2DD7F >									
280 	//     < AZOV_PFI_II_metadata_line_27_____Taganrog_org_20231101 >									
281 	//        < b2Jy6Fx6Ge69ZlE9fw3F855V4ycd7648NdMhZk0pi6u4UZQDuL85djAp51Pc13HX >									
282 	//        <  u =="0.000000000000000001" : ] 000000777823994.354558000000000000 ; 000000814680293.665425000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000004A2DD7F4DB1A7D >									
284 	//     < AZOV_PFI_II_metadata_line_28_____Rostov_Airport_org_20231101 >									
285 	//        < BPfKBnk6G2x384nUbbN96Q88iE82n5h4Z50667Nlxr9U4GTeABuvIGo32vjxcIKe >									
286 	//        <  u =="0.000000000000000001" : ] 000000814680293.665425000000000000 ; 000000834230111.413024000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000004DB1A7D4F8EF23 >									
288 	//     < AZOV_PFI_II_metadata_line_29_____Rostov_Airport_infrastructure_org_20231101 >									
289 	//        < G5aS785461ufHr934Oghx766Grlix4N98Vg1HKbMRY68yf89jU4R6o0c122L7T60 >									
290 	//        <  u =="0.000000000000000001" : ] 000000834230111.413024000000000000 ; 000000852085222.331227000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000004F8EF235142DCA >									
292 	//     < AZOV_PFI_II_metadata_line_30_____Mega_Mall_org_20231101 >									
293 	//        < 4g9hEdp47O28EVkO2ZrIf95WM8CZ2a5e07s8l8bUx6YWbeiPiczGR36IEz5iNz70 >									
294 	//        <  u =="0.000000000000000001" : ] 000000852085222.331227000000000000 ; 000000890984096.711427000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000005142DCA54F88AA >									
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
338 	//     < AZOV_PFI_II_metadata_line_31_____Mir_Remonta_org_20231101 >									
339 	//        < RbDdLXP9dY3WWD61Y3Qv7Wdqs15ffsV1OR9IMkn7waPy2rWaRIqCFPTRVDTYRG7m >									
340 	//        <  u =="0.000000000000000001" : ] 000000890984096.711427000000000000 ; 000000913891207.408988000000000000 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000000000054F88AA5727CC1 >									
342 	//     < AZOV_PFI_II_metadata_line_32_____Zemkombank_org_20231101 >									
343 	//        < z7c9l4l6AE9yHXF2mnZfH6PQoquZ737vnf3ue4380Q0pEFKQ0g9Q04J8v3v8SStQ >									
344 	//        <  u =="0.000000000000000001" : ] 000000913891207.408988000000000000 ; 000000929636849.951923000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000005727CC158A8365 >									
346 	//     < AZOV_PFI_II_metadata_line_33_____Telebashnya_tv_infrastrcture_org_20231101 >									
347 	//        < 4gz8Ppm43mX04RS549F6ApgJ7aNtA67zRzQ12iBYY3Sv6Pa8dZ4P4BRsT5h9vp34 >									
348 	//        <  u =="0.000000000000000001" : ] 000000929636849.951923000000000000 ; 000000963103512.721506000000000000 ] >									
349 	//        < 0x0000000000000000000000000000000000000000000000000058A83655BD944F >									
350 	//     < AZOV_PFI_II_metadata_line_34_____Taman_Volna_infrastructures_industrielles_org_20231101 >									
351 	//        < 42G3q5n5RNPAzsxrvZU6THak45eSv2a5GVi2S5Q8EEAQ7728E5W1Yato1853ERo4 >									
352 	//        <  u =="0.000000000000000001" : ] 000000963103512.721506000000000000 ; 000001004575916.512920000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000005BD944F5FCDC78 >									
354 	//     < AZOV_PFI_II_metadata_line_35_____Yuzhnoye_Siyaniye_ooo_20231101 >									
355 	//        < q38cbXAc6eXCRQEK5YFh6Uk6P5c8gnzbZpV88OxZIwIBZSi13YQ0x4gOl14cBSb1 >									
356 	//        <  u =="0.000000000000000001" : ] 000001004575916.512920000000000000 ; 000001038415971.855130000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000005FCDC786307F3D >									
358 	//     < AZOV_PFI_II_metadata_line_36_____Port_Krym_org_20231101 >									
359 	//        < f0QApLWxvLhNo7obC1uXmqMECHhrzfG78hGLiwTrPyPfO8DWlim2QpDLDa03U08C >									
360 	//        <  u =="0.000000000000000001" : ] 000001038415971.855130000000000000 ; 000001084782943.360870000000000000 ] >									
361 	//        < 0x000000000000000000000000000000000000000000000000006307F3D6773F56 >									
362 	//     < AZOV_PFI_II_metadata_line_37_____Kerchenskaya_équipements_maritimes_20231101 >									
363 	//        < 6902C26vKChEz21tuY4OBBxmi6M2vmBF8L3572k5Rt62388y6QjWu8049mn40KOb >									
364 	//        <  u =="0.000000000000000001" : ] 000001084782943.360870000000000000 ; 000001114743490.965960000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000006773F566A4F6AD >									
366 	//     < AZOV_PFI_II_metadata_line_38_____Kerchenskaya_ferry_20231101 >									
367 	//        < D295a92sk6Mq6N3CnuekRml2qYjuG81nVkU1679a365T973Y6W04pwMd0D170283 >									
368 	//        <  u =="0.000000000000000001" : ] 000001114743490.965960000000000000 ; 000001134093372.797600000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000006A4F6AD6C27D39 >									
370 	//     < AZOV_PFI_II_metadata_line_39_____Kerch_Port_Krym_20231101 >									
371 	//        < s133SOmvRf96M15MKP64Qy28t3A3T82U4pABJ52XYfZVU5477P8i3bw709aA42J9 >									
372 	//        <  u =="0.000000000000000001" : ] 000001134093372.797600000000000000 ; 000001173535665.404460000000000000 ] >									
373 	//        < 0x000000000000000000000000000000000000000000000000006C27D396FEAC5F >									
374 	//     < AZOV_PFI_II_metadata_line_40_____Krym_Station_infrastructure_ferroviaire_org_20231101 >									
375 	//        < a7413WGTU0Rx6muOC1Dx30WqK3S8EY8c4G93N1w2CFk12q7klH7y9Y7771Jdz6z5 >									
376 	//        <  u =="0.000000000000000001" : ] 000001173535665.404460000000000000 ; 000001196625570.779760000000000000 ] >									
377 	//        < 0x000000000000000000000000000000000000000000000000006FEAC5F721E7DD >									
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