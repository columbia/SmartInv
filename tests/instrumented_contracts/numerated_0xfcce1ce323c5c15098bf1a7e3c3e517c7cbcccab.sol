1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXXIV_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXXIV_III_883		"	;
8 		string	public		symbol =	"	RUSS_PFXXIV_III_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1026841485325970000000000000					;	
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
92 	//     < RUSS_PFXXIV_III_metadata_line_1_____ALFASTRAKHOVANIE_20251101 >									
93 	//        < v4yt5CLBMZe24NAoOWa411wbeeUSNe8zkAVxh57Wa3I57AwgAG04L0iEIWN8t66e >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000030832133.667126800000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000002F0BCD >									
96 	//     < RUSS_PFXXIV_III_metadata_line_2_____ALFA_DAO_20251101 >									
97 	//        < 3U8mzo8s4f1YIf0ni028N3XXJ5Q4JDMr0EMjt22gluT1ry7OQTrRf08d9my9li5I >									
98 	//        <  u =="0.000000000000000001" : ] 000000030832133.667126800000000000 ; 000000061026292.034962800000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000002F0BCD5D1E65 >									
100 	//     < RUSS_PFXXIV_III_metadata_line_3_____ALFA_DAOPI_20251101 >									
101 	//        < zTL550hJ6XeO2zghtN18gFU77jh3ATY36a6I6w8b8vDyVTjR8n1rw09znfa9urh4 >									
102 	//        <  u =="0.000000000000000001" : ] 000000061026292.034962800000000000 ; 000000089795196.745507700000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000005D1E65890440 >									
104 	//     < RUSS_PFXXIV_III_metadata_line_4_____ALFA_DAC_20251101 >									
105 	//        < 2xO610BmYfh2Y6s7xCOEGoh7zj9h7ITZup9829XZtx9r6Fg83B09YAdtV922n872 >									
106 	//        <  u =="0.000000000000000001" : ] 000000089795196.745507700000000000 ; 000000110741730.601322000000000000 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000000000890440A8FA7D >									
108 	//     < RUSS_PFXXIV_III_metadata_line_5_____ALFA_BIMI_20251101 >									
109 	//        < gHB50BQu0SRJ2MTFc7zGWzMWFg0VvS7T35ZlswVIcZEpxuNIYZ3dJhWYnpd64zKI >									
110 	//        <  u =="0.000000000000000001" : ] 000000110741730.601322000000000000 ; 000000140992992.670519000000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000A8FA7DD72363 >									
112 	//     < RUSS_PFXXIV_III_metadata_line_6_____SMO_SIBERIA_20251101 >									
113 	//        < yF65w4vLs0FKKkYh6WR8N2JQEF63SV9HSlW5h4RO7pMJ5vH6rPSL36f7542X8jEh >									
114 	//        <  u =="0.000000000000000001" : ] 000000140992992.670519000000000000 ; 000000167916918.029043000000000000 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000000000D72363100388C >									
116 	//     < RUSS_PFXXIV_III_metadata_line_7_____SIBERIA_DAO_20251101 >									
117 	//        < Hr7GQv8gURZ00PTb07p418i9Kn8nv1Mf4BMeln3NfvzO9ACFhMKG92PTFndn4azZ >									
118 	//        <  u =="0.000000000000000001" : ] 000000167916918.029043000000000000 ; 000000203573393.563953000000000000 ] >									
119 	//        < 0x00000000000000000000000000000000000000000000000000100388C136A0DB >									
120 	//     < RUSS_PFXXIV_III_metadata_line_8_____SIBERIA_DAOPI_20251101 >									
121 	//        < Ew1h831308F7KgVpH9jCnBkqM2H2H9Jnm946x7kmnoC4U2r9cs29c9nBATBP6732 >									
122 	//        <  u =="0.000000000000000001" : ] 000000203573393.563953000000000000 ; 000000223853478.600614000000000000 ] >									
123 	//        < 0x00000000000000000000000000000000000000000000000000136A0DB15592C4 >									
124 	//     < RUSS_PFXXIV_III_metadata_line_9_____SIBERIA_DAC_20251101 >									
125 	//        < Hzt854ciC7gmgHiyOFs5I7ugT7AS7rN0t037h2xJ8rm1pq4B05RXF30E36s118ib >									
126 	//        <  u =="0.000000000000000001" : ] 000000223853478.600614000000000000 ; 000000242947711.229605000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000015592C4172B573 >									
128 	//     < RUSS_PFXXIV_III_metadata_line_10_____SIBERIA_BIMI_20251101 >									
129 	//        < DcM806YreC6WlkPM159J0Qah08GM8rz7DgJIfzBnoXix2Y5mvT3Xjq71G33yM687 >									
130 	//        <  u =="0.000000000000000001" : ] 000000242947711.229605000000000000 ; 000000264600301.093972000000000000 ] >									
131 	//        < 0x00000000000000000000000000000000000000000000000000172B573193BF7E >									
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
174 	//     < RUSS_PFXXIV_III_metadata_line_11_____ALFASTRAKHOVANIE_LIFE_20251101 >									
175 	//        < 6JUp0F83x1AmzJV20Sp9w6UWx1RwNXi046k5if6B2PfH2zqHAm0QKItUUq0USDBG >									
176 	//        <  u =="0.000000000000000001" : ] 000000264600301.093972000000000000 ; 000000294017207.339377000000000000 ] >									
177 	//        < 0x00000000000000000000000000000000000000000000000000193BF7E1C0A279 >									
178 	//     < RUSS_PFXXIV_III_metadata_line_12_____ALFA_LIFE_DAO_20251101 >									
179 	//        < WD0hfI57Mk405i109H57RmW2hyeJ1BzAlovyZqZ40W3sZx8o1Anr5CNa9r00bh56 >									
180 	//        <  u =="0.000000000000000001" : ] 000000294017207.339377000000000000 ; 000000322018464.757004000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000001C0A2791EB5C76 >									
182 	//     < RUSS_PFXXIV_III_metadata_line_13_____ALFA_LIFE_DAOPI_20251101 >									
183 	//        < N0H2I6E1qhaCTi3N2D7I1amtp6uyGYMHTv8J23A73ItF378I07pvrr7zkP16XhOS >									
184 	//        <  u =="0.000000000000000001" : ] 000000322018464.757004000000000000 ; 000000346529935.697047000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001EB5C76210C342 >									
186 	//     < RUSS_PFXXIV_III_metadata_line_14_____ALFA_LIFE_DAC_20251101 >									
187 	//        < usfWK9KvUQbO51mQYIg4MvPEgi8Fl4xT13J272kP2PbyxK2a8RNc4jQU6cO3v4eJ >									
188 	//        <  u =="0.000000000000000001" : ] 000000346529935.697047000000000000 ; 000000367309437.906052000000000000 ] >									
189 	//        < 0x00000000000000000000000000000000000000000000000000210C3422307840 >									
190 	//     < RUSS_PFXXIV_III_metadata_line_15_____ALFA_LIFE_BIMI_20251101 >									
191 	//        < 0ZWnlS99ROz9E65GfESbBuOklM81q8O2lLn3l2zy63iytf0Zf0k3UWCxLh0z0NBv >									
192 	//        <  u =="0.000000000000000001" : ] 000000367309437.906052000000000000 ; 000000396333981.592329000000000000 ] >									
193 	//        < 0x00000000000000000000000000000000000000000000000000230784025CC1F6 >									
194 	//     < RUSS_PFXXIV_III_metadata_line_16_____ALFASTRAKHOVANIE_AVERS_20251101 >									
195 	//        < 0EZa7Ob4Je5Ju199RwgOE06l0A1Mc1ROIcF8k444zV30ci2S75snb0u1YL0P5NVC >									
196 	//        <  u =="0.000000000000000001" : ] 000000396333981.592329000000000000 ; 000000422142029.020260000000000000 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000000025CC1F6284233B >									
198 	//     < RUSS_PFXXIV_III_metadata_line_17_____AVERS_DAO_20251101 >									
199 	//        < 0f9Rv0iGEn7JW371W87r1zGat78G174fdg2KOomVVPErLM9VYY6413oE78Ga6y5P >									
200 	//        <  u =="0.000000000000000001" : ] 000000422142029.020260000000000000 ; 000000443008947.660713000000000000 ] >									
201 	//        < 0x00000000000000000000000000000000000000000000000000284233B2A3FA5F >									
202 	//     < RUSS_PFXXIV_III_metadata_line_18_____AVERS_DAOPI_20251101 >									
203 	//        < 8E9RPc335ONCqOZ6dHWIDmHh02Ivoj7leq79hT1pBIkqPx15WH0G1LmPUqA2qbK8 >									
204 	//        <  u =="0.000000000000000001" : ] 000000443008947.660713000000000000 ; 000000465305968.678041000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000002A3FA5F2C60025 >									
206 	//     < RUSS_PFXXIV_III_metadata_line_19_____AVERS_DAC_20251101 >									
207 	//        < pRHCGQy8jW6555Z4UEg9qzNHXUsspkIICf69mp9Xs11u9ebu36su8Sq7bN0Y28i2 >									
208 	//        <  u =="0.000000000000000001" : ] 000000465305968.678041000000000000 ; 000000488714379.832339000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000002C600252E9B80E >									
210 	//     < RUSS_PFXXIV_III_metadata_line_20_____AVERS_BIMI_20251101 >									
211 	//        < tmgximc5DEwKr5ZCy9d5gJoggT6V8Dj0v91H1BL4gfUjL804Yi9tzC81Bi1621A1 >									
212 	//        <  u =="0.000000000000000001" : ] 000000488714379.832339000000000000 ; 000000509222339.179630000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000002E9B80E30902FA >									
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
256 	//     < RUSS_PFXXIV_III_metadata_line_21_____ALFASTRAKHOVANIE_PLC_20251101 >									
257 	//        < D08EBD7OSiH1y8vt8S22jp11MkX8IQps5V3r4fG551K11GzrKrC3slrq2aQ85Hbz >									
258 	//        <  u =="0.000000000000000001" : ] 000000509222339.179630000000000000 ; 000000531788124.252059000000000000 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000000030902FA32B71BC >									
260 	//     < RUSS_PFXXIV_III_metadata_line_22_____ALFASTRA_DAO_20251101 >									
261 	//        < Z9p3ZPbaExyKXn9G4Bh4P0GtCl8Gtte42W368c84WVb9aUa4u38CXjZWptH0p9YS >									
262 	//        <  u =="0.000000000000000001" : ] 000000531788124.252059000000000000 ; 000000556666829.952861000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000032B71BC35167FB >									
264 	//     < RUSS_PFXXIV_III_metadata_line_23_____ALFASTRA_DAOPI_20251101 >									
265 	//        < x3pB2877jY3VKioEuda5P4g1T0qgcN34eaSIL5B1lhsAE6m8aWOKsF7644f49Xq7 >									
266 	//        <  u =="0.000000000000000001" : ] 000000556666829.952861000000000000 ; 000000586863775.244052000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000035167FB37F7BAA >									
268 	//     < RUSS_PFXXIV_III_metadata_line_24_____ALFASTRA_DAC_20251101 >									
269 	//        < L0F30MI0UzkOzkc92JH4RGCU3Yw1a9XeQm9767vv94g9l6M7v30M4ZBIRmb5R4Pm >									
270 	//        <  u =="0.000000000000000001" : ] 000000586863775.244052000000000000 ; 000000611978332.215461000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000037F7BAA3A5CE09 >									
272 	//     < RUSS_PFXXIV_III_metadata_line_25_____ALFASTRA_BIMI_20251101 >									
273 	//        < QkIsSF1t60q8H2294yjPkFoz71914PMK1PDIFpo0z0L0L204F4GW2v6zj1RO4bZ0 >									
274 	//        <  u =="0.000000000000000001" : ] 000000611978332.215461000000000000 ; 000000644150011.193248000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000003A5CE093D6E519 >									
276 	//     < RUSS_PFXXIV_III_metadata_line_26_____MEDITSINSKAYA_STRAKHOVAYA_KOMP_VIRMED_20251101 >									
277 	//        < 8yY2hSlunj1s956DaNob3NF7ukxLJIASc5xJIm8Xo0pa838FBsi34aSk5serI36S >									
278 	//        <  u =="0.000000000000000001" : ] 000000644150011.193248000000000000 ; 000000675365478.699120000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000003D6E51940686A4 >									
280 	//     < RUSS_PFXXIV_III_metadata_line_27_____VIRMED_DAO_20251101 >									
281 	//        < N7tt39UWQjTkc4Kbu0sd6JMAuVrq2778TLY14123N42d74O8X2RXf9IJfl6ylyWI >									
282 	//        <  u =="0.000000000000000001" : ] 000000675365478.699120000000000000 ; 000000703767991.679111000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000040686A4431DD5F >									
284 	//     < RUSS_PFXXIV_III_metadata_line_28_____VIRMED_DAOPI_20251101 >									
285 	//        < 12VQQo0LIKjxyIxzayWZqlYG7Dk18BZ8LI69Y8O1whyJadz5b6rd3Wvxi2nTn401 >									
286 	//        <  u =="0.000000000000000001" : ] 000000703767991.679111000000000000 ; 000000727091874.299966000000000000 ] >									
287 	//        < 0x00000000000000000000000000000000000000000000000000431DD5F4557443 >									
288 	//     < RUSS_PFXXIV_III_metadata_line_29_____VIRMED_DAC_20251101 >									
289 	//        < WBDJ44DItg2RAnV2amwd8PyBQ12GbL3w9vB0Ki46kHRFSyfy8kruT2bX0klTrUZm >									
290 	//        <  u =="0.000000000000000001" : ] 000000727091874.299966000000000000 ; 000000750348218.410340000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000004557443478F0C6 >									
292 	//     < RUSS_PFXXIV_III_metadata_line_30_____VIRMED_BIMI_20251101 >									
293 	//        < XC7g542fkp464k2RNN28959g4UrH1DIhx87D0c4876895335NL1crhRKC1HihXYQ >									
294 	//        <  u =="0.000000000000000001" : ] 000000750348218.410340000000000000 ; 000000771649022.954201000000000000 ] >									
295 	//        < 0x00000000000000000000000000000000000000000000000000478F0C64997166 >									
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
338 	//     < RUSS_PFXXIV_III_metadata_line_31_____MSK_ASSTRA_20251101 >									
339 	//        < kljw08jdhJhrRl484Db0Ve0s12OW8fcn0MnlRV575Nvhh4ntxRMk49jmXA75WhY9 >									
340 	//        <  u =="0.000000000000000001" : ] 000000771649022.954201000000000000 ; 000000791320463.895392000000000000 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000000000049971664B7758E >									
342 	//     < RUSS_PFXXIV_III_metadata_line_32_____ASSTRA_DAO_20251101 >									
343 	//        < wn9zhoOh1R1Uvp8Pjl2BjuVSB606gGdjW067RBHvoBSz9i9T4x577T4irqxSN2Vc >									
344 	//        <  u =="0.000000000000000001" : ] 000000791320463.895392000000000000 ; 000000811582440.666179000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000004B7758E4D66064 >									
346 	//     < RUSS_PFXXIV_III_metadata_line_33_____ASSTRA_DAOPI_20251101 >									
347 	//        < 7pYwd7xs7Lto8027IP7699YCrFy8510f4gtIqXrWFyAPjX535bIRG1K0jm1FX11N >									
348 	//        <  u =="0.000000000000000001" : ] 000000811582440.666179000000000000 ; 000000844578892.736064000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000004D66064508B9A1 >									
350 	//     < RUSS_PFXXIV_III_metadata_line_34_____ASSTRA_DAC_20251101 >									
351 	//        < 6Zhge7O9GTV9yMHh7OG7j7v914jrQPM8bHAnH81x4o40ahuWE9mkPAAtzjglEay9 >									
352 	//        <  u =="0.000000000000000001" : ] 000000844578892.736064000000000000 ; 000000868709037.956733000000000000 ] >									
353 	//        < 0x00000000000000000000000000000000000000000000000000508B9A152D8B78 >									
354 	//     < RUSS_PFXXIV_III_metadata_line_35_____ASSTRA_BIMI_20251101 >									
355 	//        < 3z227Wij176d2irv048cOR78BOZt9zIn1GDuMnu8N56n2E3u677ZNhsLI1d5rLp8 >									
356 	//        <  u =="0.000000000000000001" : ] 000000868709037.956733000000000000 ; 000000892940474.712827000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000052D8B7855284DF >									
358 	//     < RUSS_PFXXIV_III_metadata_line_36_____AVICOS_AFES_INSURANCE_GROUP_20251101 >									
359 	//        < m0bmL1Cm6oR86DZh1p6FdE5J1uJmi7Fjm5644VmukXknrFd6P6p04L6Ky3E0LJ37 >									
360 	//        <  u =="0.000000000000000001" : ] 000000892940474.712827000000000000 ; 000000914895441.097562000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000055284DF5740508 >									
362 	//     < RUSS_PFXXIV_III_metadata_line_37_____AVICOS_DAO_20251101 >									
363 	//        < 7KNPs9p76F95z1kQh9zcK8u2mv6zwhB5hgeUG4lG8L75DQGX8aIy0EZ4T7zD7ij2 >									
364 	//        <  u =="0.000000000000000001" : ] 000000914895441.097562000000000000 ; 000000938155413.236760000000000000 ] >									
365 	//        < 0x00000000000000000000000000000000000000000000000000574050859782F5 >									
366 	//     < RUSS_PFXXIV_III_metadata_line_38_____AVICOS_DAOPI_20251101 >									
367 	//        < 5xeGA3277nj05eo2xGK9mPNvf4FEq09W0MOK9a6TuFA70oITs7474uTV6886wN7p >									
368 	//        <  u =="0.000000000000000001" : ] 000000938155413.236760000000000000 ; 000000969091713.081654000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000059782F55C6B773 >									
370 	//     < RUSS_PFXXIV_III_metadata_line_39_____AVICOS_DAC_20251101 >									
371 	//        < 57E5B8a4dJi6i8RIBL1vt9y5uMKM9W6XqmqVAmI612AIz5a0lnKINOSrQDNi185T >									
372 	//        <  u =="0.000000000000000001" : ] 000000969091713.081654000000000000 ; 000000998746865.445303000000000000 ] >									
373 	//        < 0x000000000000000000000000000000000000000000000000005C6B7735F3F77F >									
374 	//     < RUSS_PFXXIV_III_metadata_line_40_____AVICOS_BIMI_20251101 >									
375 	//        < ll415R0k205rpqN5NnkY84meEtYKq03VUDsX4RM8rNgFzg1mc1VQV14jeJYiTTj2 >									
376 	//        <  u =="0.000000000000000001" : ] 000000998746865.445303000000000000 ; 000001026841485.325970000000000000 ] >									
377 	//        < 0x000000000000000000000000000000000000000000000000005F3F77F61ED5F5 >									
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