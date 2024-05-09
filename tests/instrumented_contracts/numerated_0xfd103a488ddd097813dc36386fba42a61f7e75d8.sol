1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXXXVIII_II_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXXXVIII_II_883		"	;
8 		string	public		symbol =	"	RUSS_PFXXXVIII_II_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		821170410821043000000000000					;	
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
92 	//     < RUSS_PFXXXVIII_II_metadata_line_1_____AgroCenter_Ukraine_20231101 >									
93 	//        < H0ctP38J3gsZISkxAZrMagEi6FL0lw9KWUp0RVMS4R5Bi9W7QsbMAg4kUxRgo578 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000021030904.691012100000000000 ] >									
95 	//        < 0x0000000000000000000000000000000000000000000000000000000000201732 >									
96 	//     < RUSS_PFXXXVIII_II_metadata_line_2_____Ural_RemStroiService_20231101 >									
97 	//        < aq3wKkrkoG3hsuRQ3B4odHSBlqx98737jF4NPCQarn05plY4P0AyOakA1MZ468DM >									
98 	//        <  u =="0.000000000000000001" : ] 000000021030904.691012100000000000 ; 000000042495746.178993000000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000020173240D7E7 >									
100 	//     < RUSS_PFXXXVIII_II_metadata_line_3_____Kingisepp_RemStroiService_20231101 >									
101 	//        < ybk06fgK1g9gV7P3E336xs4O2n5Kx6Y233VI81PREhHd20R78nZAI7d1h0yiml71 >									
102 	//        <  u =="0.000000000000000001" : ] 000000042495746.178993000000000000 ; 000000064889708.955665200000000000 ] >									
103 	//        < 0x000000000000000000000000000000000000000000000000000040D7E763038B >									
104 	//     < RUSS_PFXXXVIII_II_metadata_line_4_____Novomoskovsk_RemStroiService_20231101 >									
105 	//        < uk7afUftRSkeEMEki60u9R85D4KW2UJUUbQ763djPTmJ49gHU3Eb69Ax0BVRcaF1 >									
106 	//        <  u =="0.000000000000000001" : ] 000000064889708.955665200000000000 ; 000000085595619.287340400000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000063038B829BCA >									
108 	//     < RUSS_PFXXXVIII_II_metadata_line_5_____Nevinnomyssk_RemStroiService_20231101 >									
109 	//        < GTe8v2qYAxrc3f3F3xZ3W2Q95DO0q7KHY2hygK5ywlvLqB15n40bMFAums8A7kyx >									
110 	//        <  u =="0.000000000000000001" : ] 000000085595619.287340400000000000 ; 000000102992727.837550000000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000829BCA9D2789 >									
112 	//     < RUSS_PFXXXVIII_II_metadata_line_6_____Volgograd_RemStroiService_20231101 >									
113 	//        < r8Kp8U0rZ6Qb5vfh033C4FRxjdrXwRI1lgYrAO7v4l8t50OB2Ry6cqiB2RIt4agD >									
114 	//        <  u =="0.000000000000000001" : ] 000000102992727.837550000000000000 ; 000000121088919.007727000000000000 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000000000009D2789B8C45C >									
116 	//     < RUSS_PFXXXVIII_II_metadata_line_7_____Berezniki_Mechanical_Works_20231101 >									
117 	//        < 6Cd1Hq0ukltDeJ51VkCF3u87q06kHcN51Y0ePiB0n3fO8hZCcIAT7mq2ym72g2ud >									
118 	//        <  u =="0.000000000000000001" : ] 000000121088919.007727000000000000 ; 000000145148536.262514000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000B8C45CDD7AA6 >									
120 	//     < RUSS_PFXXXVIII_II_metadata_line_8_____Tulagiprochim_JSC_20231101 >									
121 	//        < 2fR43V5aJKWZha0jEjh0LT43KU3118ZEwt465j1VePeB25Nzp5X1bB5LuUwVwMp8 >									
122 	//        <  u =="0.000000000000000001" : ] 000000145148536.262514000000000000 ; 000000168137141.519079000000000000 ] >									
123 	//        < 0x000000000000000000000000000000000000000000000000000DD7AA61008E92 >									
124 	//     < RUSS_PFXXXVIII_II_metadata_line_9_____TOMS_project_LLC_20231101 >									
125 	//        < Aj1Wbo1Y22FE40TabIB90rx1Q9r81KuCRZ27yB8TK3rU6Wc5rKb638lhlXl53xho >									
126 	//        <  u =="0.000000000000000001" : ] 000000168137141.519079000000000000 ; 000000189021339.274211000000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000001008E921206C76 >									
128 	//     < RUSS_PFXXXVIII_II_metadata_line_10_____Harvester_Shipmanagement_Ltd_20231101 >									
129 	//        < WAWoKtKWMKH4fTB0QG12rCArh52U0vt72yiQPVd1QxlF7ggN9R4uPlj831t75NFH >									
130 	//        <  u =="0.000000000000000001" : ] 000000189021339.274211000000000000 ; 000000213332969.230156000000000000 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000000001206C761458531 >									
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
174 	//     < RUSS_PFXXXVIII_II_metadata_line_11_____EuroChem_Logistics_International_20231101 >									
175 	//        < aZJzM92YxvKm8sixCOn85y6RTiix4RjkS335Jh4d52WlBglBpNtzpETEnJajEW8V >									
176 	//        <  u =="0.000000000000000001" : ] 000000213332969.230156000000000000 ; 000000235647990.739676000000000000 ] >									
177 	//        < 0x00000000000000000000000000000000000000000000000000145853116791FF >									
178 	//     < RUSS_PFXXXVIII_II_metadata_line_12_____EuroChem_Terminal_Sillamäe_Aktsiaselts_Logistics_20231101 >									
179 	//        < wrO1618Vxp13P48cg3cv2XH9Md71ZligHl1708vg87hSQzOAUI82wZgluSvphUXk >									
180 	//        <  u =="0.000000000000000001" : ] 000000235647990.739676000000000000 ; 000000256853398.958347000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000016791FF187ED5C >									
182 	//     < RUSS_PFXXXVIII_II_metadata_line_13_____EuroChem_Terminal_Ust_Luga_20231101 >									
183 	//        < 0dGbykbLjAEyp22k7M4u2W4ZNH45D3g7X60rVw2HlTM6Ws9kiqp6s7TS79Fu38AU >									
184 	//        <  u =="0.000000000000000001" : ] 000000256853398.958347000000000000 ; 000000276011508.457638000000000000 ] >									
185 	//        < 0x00000000000000000000000000000000000000000000000000187ED5C1A528FF >									
186 	//     < RUSS_PFXXXVIII_II_metadata_line_14_____Tuapse_Bulk_Terminal_20231101 >									
187 	//        < c6A2FQBCx13DCR0nN1VFvKJjJvctLL0234EL8yD2pb150LNtrz9kHKIw079lUOQO >									
188 	//        <  u =="0.000000000000000001" : ] 000000276011508.457638000000000000 ; 000000298291405.349352000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000001A528FF1C72815 >									
190 	//     < RUSS_PFXXXVIII_II_metadata_line_15_____Murmansk_Bulkcargo_Terminal_20231101 >									
191 	//        < eJ8fCvJyiOs5E1od1zKFP5A4w7a51ULAfp2A9LUcs97hE7b86uU8JU97qVX21fe1 >									
192 	//        <  u =="0.000000000000000001" : ] 000000298291405.349352000000000000 ; 000000321075850.649663000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000001C728151E9EC41 >									
194 	//     < RUSS_PFXXXVIII_II_metadata_line_16_____Depo_EuroChem_20231101 >									
195 	//        < av80m9Jw4rhMuHncjIeiTZo4GYW6wXb4sLS1Ef8bY8g759wkDe73lK85azdMEdD1 >									
196 	//        <  u =="0.000000000000000001" : ] 000000321075850.649663000000000000 ; 000000338675977.554594000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000001E9EC41204C74E >									
198 	//     < RUSS_PFXXXVIII_II_metadata_line_17_____EuroChem_Energo_20231101 >									
199 	//        < icaHuue3H4d5LSmV1fDIqBrQp125uF2ynTPt9CcfL2zWRabfsX7xDo8c6jhhCvqW >									
200 	//        <  u =="0.000000000000000001" : ] 000000338675977.554594000000000000 ; 000000356241010.157128000000000000 ] >									
201 	//        < 0x00000000000000000000000000000000000000000000000000204C74E21F94A5 >									
202 	//     < RUSS_PFXXXVIII_II_metadata_line_18_____EuroChem_Usolsky_Mining_sarl_20231101 >									
203 	//        < UKNot1s9iAl0B2M11YP0374sIq6wNk0P8ZZkoiD9hQ3jZ7Hjoy0t3O8y1tHXItY5 >									
204 	//        <  u =="0.000000000000000001" : ] 000000356241010.157128000000000000 ; 000000372323482.773939000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000021F94A52381EDC >									
206 	//     < RUSS_PFXXXVIII_II_metadata_line_19_____EuroChem_International_Holding_BV_20231101 >									
207 	//        < j9Os0NYNW7J002nRliw9Ecx8O241FQZrAcbK9f9XwdiVqo3raUVq7Ih47KrN74Tq >									
208 	//        <  u =="0.000000000000000001" : ] 000000372323482.773939000000000000 ; 000000391137730.311323000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000002381EDC254D42D >									
210 	//     < RUSS_PFXXXVIII_II_metadata_line_20_____Severneft_Urengoy_LLC_20231101 >									
211 	//        < YUlx5pL8aGiME44fac416cBjvCn7JktW4hW82ep2ouNKX2FVDnLK3276Q5dR7rpa >									
212 	//        <  u =="0.000000000000000001" : ] 000000391137730.311323000000000000 ; 000000408094392.043982000000000000 ] >									
213 	//        < 0x00000000000000000000000000000000000000000000000000254D42D26EB3DF >									
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
256 	//     < RUSS_PFXXXVIII_II_metadata_line_21_____Agrinos_AS_20231101 >									
257 	//        < 4p905Gt5T15MPKdRn5QZYLcOofzzj92F0e6NGf28t3K1jm6nx3f1L583r2q5Rycn >									
258 	//        <  u =="0.000000000000000001" : ] 000000408094392.043982000000000000 ; 000000424378941.879076000000000000 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000000026EB3DF2878D06 >									
260 	//     < RUSS_PFXXXVIII_II_metadata_line_22_____Hispalense_de_Líquidos_SL_20231101 >									
261 	//        < RU1452yEip4pV5CmagpX5iJ9sOLQx8jgMNy7S7YCc77Vv6T8q18x83FP93GHmJ3f >									
262 	//        <  u =="0.000000000000000001" : ] 000000424378941.879076000000000000 ; 000000448330546.330970000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000002878D062AC191F >									
264 	//     < RUSS_PFXXXVIII_II_metadata_line_23_____Azottech_LLC_20231101 >									
265 	//        < X6lg8I8AcmItA64qZPvZKTUJARKU7hOIx3A6xr14738018Zh29J6yon3M7C3RJ70 >									
266 	//        <  u =="0.000000000000000001" : ] 000000448330546.330970000000000000 ; 000000472386812.036159000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000002AC191F2D0CE19 >									
268 	//     < RUSS_PFXXXVIII_II_metadata_line_24_____EuroChem_Migao_Ltd_20231101 >									
269 	//        < HohRK4MPsz086A1ZjC5G0u0H1l5yY2MF10TlFx6iQAJFA198NfHZ0844g3bwgAiH >									
270 	//        <  u =="0.000000000000000001" : ] 000000472386812.036159000000000000 ; 000000494827736.009935000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000002D0CE192F30C16 >									
272 	//     < RUSS_PFXXXVIII_II_metadata_line_25_____Thyssen_Schachtbau_EuroChem_Drilling_20231101 >									
273 	//        < 4pQ79G0WQ3799lNHIm13i7Cgf64K0VcFpwZDNNJh9rAXcZT55334LzO1ErsKRoEU >									
274 	//        <  u =="0.000000000000000001" : ] 000000494827736.009935000000000000 ; 000000517532666.447238000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002F30C16315B133 >									
276 	//     < RUSS_PFXXXVIII_II_metadata_line_26_____Biochem_Technologies_LLC_20231101 >									
277 	//        < Gl7nO4M7Hm1oLg6qkTe8y2CJP0FCSFeqa3Cj72IwW27bGqo9mmVso29C4qK44nkX >									
278 	//        <  u =="0.000000000000000001" : ] 000000517532666.447238000000000000 ; 000000538083616.187707000000000000 ] >									
279 	//        < 0x00000000000000000000000000000000000000000000000000315B1333350CEA >									
280 	//     < RUSS_PFXXXVIII_II_metadata_line_27_____EuroChem_Agro_Bulgaria_Ead_20231101 >									
281 	//        < 91vDr2MNMB952Zw8U0D2tzZ5R380mJR3JWz90prns06z35MSJhK0ufr780Ro545q >									
282 	//        <  u =="0.000000000000000001" : ] 000000538083616.187707000000000000 ; 000000555448975.219862000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000003350CEA34F8C42 >									
284 	//     < RUSS_PFXXXVIII_II_metadata_line_28_____Emerger_Fertilizantes_SA_20231101 >									
285 	//        < QL34JHu7PIs7qVPDM8VlA0C80i4PWYRxW2b7B6TF4sD81XX7R1F0Cm32Rgt80IVy >									
286 	//        <  u =="0.000000000000000001" : ] 000000555448975.219862000000000000 ; 000000580256255.052675000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000034F8C42375669A >									
288 	//     < RUSS_PFXXXVIII_II_metadata_line_29_____Agrocenter_EuroChem_Srl_20231101 >									
289 	//        < 00gLF641z9w1w96f3d2jQ4DtV2x3NMf2EzFcm383ik41NmJsD25wJ8G1xrN9sF0r >									
290 	//        <  u =="0.000000000000000001" : ] 000000580256255.052675000000000000 ; 000000598899888.802294000000000000 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000000000375669A391D945 >									
292 	//     < RUSS_PFXXXVIII_II_metadata_line_30_____AgroCenter_Ukraine_LLC_20231101 >									
293 	//        < 492YHI16Xz3F7P10tL82kF1nw8v3L2zIbPPrw98rNmqUNgt0g54nq6CO6chT8ePF >									
294 	//        <  u =="0.000000000000000001" : ] 000000598899888.802294000000000000 ; 000000621020720.422880000000000000 ] >									
295 	//        < 0x00000000000000000000000000000000000000000000000000391D9453B39A38 >									
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
338 	//     < RUSS_PFXXXVIII_II_metadata_line_31_____EuroChem_Agro_doo_Beograd_20231101 >									
339 	//        < SBLtKz7eqVbAr4g8nw5jFzN1Skl26FiH1m4a0j464C55hoJ578488pjb2VnDTibE >									
340 	//        <  u =="0.000000000000000001" : ] 000000621020720.422880000000000000 ; 000000639375295.246686000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000003B39A383CF9BFA >									
342 	//     < RUSS_PFXXXVIII_II_metadata_line_32_____TOMS_project_LLC_20231101 >									
343 	//        < Og1FG4nrNEXZZOwl8t17X6rFM6jljyrS17DyInN8YB3j7maP1Em69D3iH50DmFNS >									
344 	//        <  u =="0.000000000000000001" : ] 000000639375295.246686000000000000 ; 000000657817744.250553000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000003CF9BFA3EBC00E >									
346 	//     < RUSS_PFXXXVIII_II_metadata_line_33_____Agrosphere_20231101 >									
347 	//        < ObA1jYmUC51gQZqwKHfW8Y26C1kiNf0h2yB3xi3m8T3YfL5dtgB9q8M3NGOyL6NI >									
348 	//        <  u =="0.000000000000000001" : ] 000000657817744.250553000000000000 ; 000000681498703.573722000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000003EBC00E40FE26E >									
350 	//     < RUSS_PFXXXVIII_II_metadata_line_34_____Bulkcargo_Terminal_LLC_20231101 >									
351 	//        < VBcb0De8C5ABkZj8t9MYT450YWctbl62ZOssx9Z21981DSLq0k54RK3H312dU3a0 >									
352 	//        <  u =="0.000000000000000001" : ] 000000681498703.573722000000000000 ; 000000703709370.977334000000000000 ] >									
353 	//        < 0x0000000000000000000000000000000000000000000000000040FE26E431C679 >									
354 	//     < RUSS_PFXXXVIII_II_metadata_line_35_____AgroCenter_EuroChem_Volgograd_20231101 >									
355 	//        < nYL2moT9tTRSRzQ5vf9pa1l5b03y64h33ZZKoMJV7kYJ9dYXsVGX0Q0GApVRJzXp >									
356 	//        <  u =="0.000000000000000001" : ] 000000703709370.977334000000000000 ; 000000719688798.754498000000000000 ] >									
357 	//        < 0x00000000000000000000000000000000000000000000000000431C67944A2870 >									
358 	//     < RUSS_PFXXXVIII_II_metadata_line_36_____Trading_RUS_LLC_20231101 >									
359 	//        < c0GuU89t7Xe4ztA5Ei3X9uO6We98uF2iS79gu3jXtT71INuy5y35exjgK0vWRRnB >									
360 	//        <  u =="0.000000000000000001" : ] 000000719688798.754498000000000000 ; 000000743483030.265779000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000044A287046E770F >									
362 	//     < RUSS_PFXXXVIII_II_metadata_line_37_____AgroCenter_EuroChem_Krasnodar_LLC_20231101 >									
363 	//        < KATSKKuo6Aa362Xqzu6xMRN4P0RKNqHzoCftg2Clz3dLdRW30fCbL8KjAaV3UifB >									
364 	//        <  u =="0.000000000000000001" : ] 000000743483030.265779000000000000 ; 000000759718072.149314000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000046E770F4873CDF >									
366 	//     < RUSS_PFXXXVIII_II_metadata_line_38_____AgroCenter_EuroChem_Lipetsk_LLC_20231101 >									
367 	//        < V6ola9QEY9mU09j6PG74K4X41ky8pWV33d9obsUz290dgpmcq0j6LOLTa831mK0M >									
368 	//        <  u =="0.000000000000000001" : ] 000000759718072.149314000000000000 ; 000000779013627.162869000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000004873CDF4A4AE33 >									
370 	//     < RUSS_PFXXXVIII_II_metadata_line_39_____AgroCenter_EuroChem_Orel_LLC_20231101 >									
371 	//        < kEHuxgT7KQTr6ldNFMX4fPg1DHIu36L73O15SUxk2S83X215AKiTQ1v61v40542z >									
372 	//        <  u =="0.000000000000000001" : ] 000000779013627.162869000000000000 ; 000000798702917.498653000000000000 ] >									
373 	//        < 0x000000000000000000000000000000000000000000000000004A4AE334C2B954 >									
374 	//     < RUSS_PFXXXVIII_II_metadata_line_40_____AgroCenter_EuroChem_Nevinnomyssk_LLC_20231101 >									
375 	//        < 3okXq7pe3nhR6HVJC9ERA0G1I1In49mF5I664tyb2dAMC2d0fkQN2m227TgzVVJZ >									
376 	//        <  u =="0.000000000000000001" : ] 000000798702917.498653000000000000 ; 000000821170410.821043000000000000 ] >									
377 	//        < 0x000000000000000000000000000000000000000000000000004C2B9544E501B1 >									
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