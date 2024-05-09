1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	ASFGGGGN_1_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	ASFGGGGN_1_883		"	;
8 		string	public		symbol =	"	ASFGGGGN_1_1MTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		668342310604717000000000000					;	
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
92 	//     < ASFGGGGN_1_metadata_line_1_____AEROFLOT_ABC_Y8,65 >									
93 	//        < 5DA7kamqbrOF690pzrrFPip9zJ2442EGDmlM9j3CL6oW3exMHpmE3aTJvAynX077 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000017027272.786027500000000000 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000000019FB47 >									
96 	//     < ASFGGGGN_1_metadata_line_2_____AEROFLOT_RO_Y3K1.00 >									
97 	//        < 8pcf3I26p1vv91M1633ue3y3G796R34NRVkFSF9GCj4Ox6tVm2Og2n8R8775oPEe >									
98 	//        <  u =="0.000000000000000001" : ] 000000017027272.786027500000000000 ; 000000028285649.994297500000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000019FB472B2915 >									
100 	//     < ASFGGGGN_1_metadata_line_3_____AEROFLOT_RO_Y3K0.90 >									
101 	//        < MurCvi9Ah7oQSdE2c2LeXlgJwk3jhf8H4g9PSe8r8N166m014Q9RzHFaY3APJtE2 >									
102 	//        <  u =="0.000000000000000001" : ] 000000028285649.994297500000000000 ; 000000039769536.734777500000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000002B29153CAEFA >									
104 	//     < ASFGGGGN_1_metadata_line_4_____AEROFLOT_RO_Y7K1.00 >									
105 	//        < ZOtw2r3uKjQ1je17U4212Q53gt58dvAm3WEU1oM4HF1nUeB9bESuQU68p9CVTh61 >									
106 	//        <  u =="0.000000000000000001" : ] 000000039769536.734777500000000000 ; 000000054191316.539385100000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000003CAEFA52B07C >									
108 	//     < ASFGGGGN_1_metadata_line_5_____AEROFLOT_RO_Y7K0.90 >									
109 	//        < Po34UKRs7UR6BxQQUHLdtRg5xH3wQ2Q63p0sO63CSEU6W5mJHTzour9C4Vnq4eLf >									
110 	//        <  u =="0.000000000000000001" : ] 000000054191316.539385100000000000 ; 000000069317213.787936200000000000 ] >									
111 	//        < 0x000000000000000000000000000000000000000000000000000052B07C69C509 >									
112 	//     < ASFGGGGN_1_metadata_line_6_____SEVERSTAL_ABC_Y8,65 >									
113 	//        < MnLdemxFhfk4i3Rq5F6pZ4Di705HZgPk8EDBj8mnBfT8Jvjxt9rP54aT686ow1BC >									
114 	//        <  u =="0.000000000000000001" : ] 000000069317213.787936200000000000 ; 000000085209920.531197600000000000 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000000000069C509820520 >									
116 	//     < ASFGGGGN_1_metadata_line_7_____SEVERSTAL_RO_Y3K1.00 >									
117 	//        < 4WGa0DUcTX6h0B0vhqZ7KsMliBbFYRqW7wOzC9KcpfM9yRa0DwJV3Yt2rK16qD24 >									
118 	//        <  u =="0.000000000000000001" : ] 000000085209920.531197600000000000 ; 000000096413194.455757600000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000820520931D67 >									
120 	//     < ASFGGGGN_1_metadata_line_8_____SEVERSTAL_RO_Y3K0.90 >									
121 	//        < 9h1r5mTJE430e67Mjg80hdilm33lsP98eBE0574vEP13ZH25RjKOndbk609OiGyw >									
122 	//        <  u =="0.000000000000000001" : ] 000000096413194.455757600000000000 ; 000000107788856.800948000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000931D67A47906 >									
124 	//     < ASFGGGGN_1_metadata_line_9_____SEVERSTAL_RO_Y7K1.00 >									
125 	//        < Pt8KvetaFWTat9i9NWap6R36UC8GDAm5i4PYOkJgx1HEjCC2Fx31uZP8DdCd8Mlz >									
126 	//        <  u =="0.000000000000000001" : ] 000000107788856.800948000000000000 ; 000000121766321.926772000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000000A47906B9CCF8 >									
128 	//     < ASFGGGGN_1_metadata_line_10_____SEVERSTAL_RO_Y7K0.90 >									
129 	//        < IxciVZhr0PWf627ceCZ8k7HCu5G21J0zQLkkT5nqTA2308fMTOL5H4a029v2Y4Qs >									
130 	//        <  u =="0.000000000000000001" : ] 000000121766321.926772000000000000 ; 000000136546346.036053000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000000B9CCF8D05A6B >									
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
174 	//     < ASFGGGGN_1_metadata_line_11_____FEDERAL_GRID_ABC_Y8,65 >									
175 	//        < 9Uzkb2H0p07OB2ZywlS6wj9wC7o4MXqtf2Ol81If9U1MX2VoMqeG66b30w5DO0eG >									
176 	//        <  u =="0.000000000000000001" : ] 000000136546346.036053000000000000 ; 000000156256214.062058000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000000D05A6BEE6D95 >									
178 	//     < ASFGGGGN_1_metadata_line_12_____FEDERAL_GRID_RO_Y3K1.00 >									
179 	//        < 8p7lVGVUujLXB32GgFFu705xAqGyic0o7k6xt9O2yiaw6qOvTtV3FXMNG71HV87l >									
180 	//        <  u =="0.000000000000000001" : ] 000000156256214.062058000000000000 ; 000000167641686.770938000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000000EE6D95FFCD09 >									
182 	//     < ASFGGGGN_1_metadata_line_13_____FEDERAL_GRID_RO_Y3K0.90 >									
183 	//        < gqHhCqEohroSxL7GdFJ8UcCJt7t2uY7m20Itq1aZ235u7ug7LekupPp5JIjQIBcR >									
184 	//        <  u =="0.000000000000000001" : ] 000000167641686.770938000000000000 ; 000000179374086.144168000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000000FFCD09111B401 >									
186 	//     < ASFGGGGN_1_metadata_line_14_____FEDERAL_GRID_RO_Y7K1.00 >									
187 	//        < vC8jNP1UJUTT5Q34J7Snk4640ZNEY7VKMX3WKUmKz5WKe1f8hFtWMzd32jp0e2Rl >									
188 	//        <  u =="0.000000000000000001" : ] 000000179374086.144168000000000000 ; 000000194883335.496551000000000000 ] >									
189 	//        < 0x00000000000000000000000000000000000000000000000000111B4011295E4E >									
190 	//     < ASFGGGGN_1_metadata_line_15_____FEDERAL_GRID_RO_Y7K0.90 >									
191 	//        < J6jCKdB5Tm97Sw2Y1792gSyGAyFBri3H4exhBceaZDZlkhSinebOQDfQGu1lKZ9F >									
192 	//        <  u =="0.000000000000000001" : ] 000000194883335.496551000000000000 ; 000000211517087.606913000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000001295E4E142BFDD >									
194 	//     < ASFGGGGN_1_metadata_line_16_____GAZPROM_USD_ABC_Y12,85 >									
195 	//        < rfcbTY9b4ciY8mn1u5YFVAjI0ToCw2uH47tZlD9Y1DiJsx80oSn4Wgg6tmqmA170 >									
196 	//        <  u =="0.000000000000000001" : ] 000000211517087.606913000000000000 ; 000000225354727.200592000000000000 ] >									
197 	//        < 0x00000000000000000000000000000000000000000000000000142BFDD157DD31 >									
198 	//     < ASFGGGGN_1_metadata_line_17_____GAZPROM_USD_RO_Y3K1.00 >									
199 	//        < MPIjMwICUam73NTr890UnMTxn6m8WYi3gC6iC0GGSXaC49FM1l2r335DViv0jo2z >									
200 	//        <  u =="0.000000000000000001" : ] 000000225354727.200592000000000000 ; 000000236377756.570592000000000000 ] >									
201 	//        < 0x00000000000000000000000000000000000000000000000000157DD31168AF10 >									
202 	//     < ASFGGGGN_1_metadata_line_18_____GAZPROM_USD_RO_Y3K0.90 >									
203 	//        < 3UqDHn1zPtbmBDIYv3tJ98fna6H0akd4nZLY0fvL24UD0gV0WLi80VfNpUxag2wV >									
204 	//        <  u =="0.000000000000000001" : ] 000000236377756.570592000000000000 ; 000000247394384.646112000000000000 ] >									
205 	//        < 0x00000000000000000000000000000000000000000000000000168AF101797E6E >									
206 	//     < ASFGGGGN_1_metadata_line_19_____GAZPROM_USD_RO_Y7K1.00 >									
207 	//        < qCe3957q08VCVvTx1ai2qB71HlCcc6P134qF4E67wP0a1b4Vj37O2dnMy5kb0A5P >									
208 	//        <  u =="0.000000000000000001" : ] 000000247394384.646112000000000000 ; 000000260117177.273778000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000001797E6E18CE846 >									
210 	//     < ASFGGGGN_1_metadata_line_20_____GAZPROM_USD_RO_Y7K0.90 >									
211 	//        < 2pKCjPA09dm2t208q0w50P3UhgRe751sHlSPr1ms31gdy614ZQj2n4Y2139peU3V >									
212 	//        <  u =="0.000000000000000001" : ] 000000260117177.273778000000000000 ; 000000272900325.763209000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000018CE8461A069B1 >									
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
256 	//     < ASFGGGGN_1_metadata_line_21_____GAZPROM_USD_ABC_Y5 >									
257 	//        < Y149H067tA44X4YIDlPpUG5hxJ5g7JxTw823An7tpFqKSgEF56WNJAZtcKqe11OZ >									
258 	//        <  u =="0.000000000000000001" : ] 000000272900325.763209000000000000 ; 000000285300257.478259000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000001A069B11B3556A >									
260 	//     < ASFGGGGN_1_metadata_line_22_____GAZPROM_USD_RO_Y3K1.00 >									
261 	//        < kzbR11cdx84DQf2K51w497164Jfa7Gz9edv1Fo55w60f1CUhGmyG03JU4C6dLDg7 >									
262 	//        <  u =="0.000000000000000001" : ] 000000285300257.478259000000000000 ; 000000296432488.563699000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000001B3556A1C451F1 >									
264 	//     < ASFGGGGN_1_metadata_line_23_____GAZPROM_USD_RO_Y3K0.90 >									
265 	//        < 4t41Uuj0MGgUDuOY46NF3i8I9My3B61FMPiSTvzsY6uGMXMVWEzLI869AtasKvm6 >									
266 	//        <  u =="0.000000000000000001" : ] 000000296432488.563699000000000000 ; 000000307668154.355059000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000001C451F11D576DF >									
268 	//     < ASFGGGGN_1_metadata_line_24_____GAZPROM_USD_RO_Y7K1.00 >									
269 	//        < z66TYr1Lv5CxWB5Hyr6MwvuU9KrmEE8zn64cf6B5yzXSI01l2viC1rIV59N4SEr1 >									
270 	//        <  u =="0.000000000000000001" : ] 000000307668154.355059000000000000 ; 000000321131587.766162000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000001D576DF1EA0207 >									
272 	//     < ASFGGGGN_1_metadata_line_25_____GAZPROM_USD_RO_Y7K0.90 >									
273 	//        < 843lJ0k3MZo1892P03q45ZvFc5tFH1R204dc3YX25l3scx9lXBiC05QDxYW1QICq >									
274 	//        <  u =="0.000000000000000001" : ] 000000321131587.766162000000000000 ; 000000334932796.271411000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000001EA02071FF1120 >									
276 	//     < ASFGGGGN_1_metadata_line_26_____GAZPROM_ABC_Y8,65 >									
277 	//        < K8TQ5qNC1I99N6hKY5wQC3u1uU0qW363os0GJNO0JR02Yz5OfRo46L0O0HAtSBFR >									
278 	//        <  u =="0.000000000000000001" : ] 000000334932796.271411000000000000 ; 000000347123227.781412000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000001FF1120211AB03 >									
280 	//     < ASFGGGGN_1_metadata_line_27_____GAZPROM_RO_Y3K1.00 >									
281 	//        < AfCHfP7Ei08AK7k8UCUR2aio80t99v6o0mJkBb7vH9Z05kPSXwxYb2S3l2QaWr99 >									
282 	//        <  u =="0.000000000000000001" : ] 000000347123227.781412000000000000 ; 000000358130258.562662000000000000 ] >									
283 	//        < 0x00000000000000000000000000000000000000000000000000211AB0322276A2 >									
284 	//     < ASFGGGGN_1_metadata_line_28_____GAZPROM_RO_Y3K0.90 >									
285 	//        < xf2YQ7j9tfW426Fi9K2NhQvmQ6544BUP4fKn9K5Pjh0E62Fk0VWX4c6p3rqnGJ2c >									
286 	//        <  u =="0.000000000000000001" : ] 000000358130258.562662000000000000 ; 000000369121306.242662000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000022276A22333C03 >									
288 	//     < ASFGGGGN_1_metadata_line_29_____GAZPROM_RO_Y7K1.00 >									
289 	//        < L7vvk91522u2pIV9QSC8Siz00l1vM8Jko30m5TOpYeuQbgVGb66q2C48n3vno8FL >									
290 	//        <  u =="0.000000000000000001" : ] 000000369121306.242662000000000000 ; 000000381758300.010363000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000002333C032468456 >									
292 	//     < ASFGGGGN_1_metadata_line_30_____GAZPROM_RO_Y7K0.90 >									
293 	//        < d522FInxN4eh13x05Gie7xHB4KyPih7r4h5vrxwxnYDS2BJie5gGRWLL0CvnaRbq >									
294 	//        <  u =="0.000000000000000001" : ] 000000381758300.010363000000000000 ; 000000394420981.202291000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000002468456259D6B2 >									
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
338 	//     < ASFGGGGN_1_metadata_line_31_____GAZPROM_ABC_Y5 >									
339 	//        < u6QgeUOxZ4aC7uVsW9PF1QeH4Ai438iwah09NLA9HR1Qei8KrtePJpC0W1pF8u48 >									
340 	//        <  u =="0.000000000000000001" : ] 000000394420981.202291000000000000 ; 000000404779978.026586000000000000 ] >									
341 	//        < 0x00000000000000000000000000000000000000000000000000259D6B2269A52E >									
342 	//     < ASFGGGGN_1_metadata_line_32_____GAZPROM_RO_Y3K1.00 >									
343 	//        < kbm7aXzhX8uN3BvR3i5zzli17IvM1hd4H1aN1UnlDGEj5iO1PlGG59nqstrKa5gk >									
344 	//        <  u =="0.000000000000000001" : ] 000000404779978.026586000000000000 ; 000000415697702.707316000000000000 ] >									
345 	//        < 0x00000000000000000000000000000000000000000000000000269A52E27A4DEA >									
346 	//     < ASFGGGGN_1_metadata_line_33_____GAZPROM_RO_Y3K0.90 >									
347 	//        < kflXIKHr3ezeQOC0Qh8h103i869Hjf12414pl0JflT5Xr5La8cdLp5oou09EU6i3 >									
348 	//        <  u =="0.000000000000000001" : ] 000000415697702.707316000000000000 ; 000000426510795.504756000000000000 ] >									
349 	//        < 0x0000000000000000000000000000000000000000000000000027A4DEA28ACDC8 >									
350 	//     < ASFGGGGN_1_metadata_line_34_____GAZPROM_RO_Y7K1.00 >									
351 	//        < CFJ29T3YiI9h65rn80U65vwK3wRs74nS9k2f09J4D06hCxH9T7tY3b40281od0Vn >									
352 	//        <  u =="0.000000000000000001" : ] 000000426510795.504756000000000000 ; 000000438635078.434396000000000000 ] >									
353 	//        < 0x0000000000000000000000000000000000000000000000000028ACDC829D4DD4 >									
354 	//     < ASFGGGGN_1_metadata_line_35_____GAZPROM_RO_Y7K0.90 >									
355 	//        < D4fj26CJ4mvztAQ0C4eT4LYcqns33qof3BD4zm42iDc5601fQHrv77p5mkE4PpkF >									
356 	//        <  u =="0.000000000000000001" : ] 000000438635078.434396000000000000 ; 000000450578877.503079000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000029D4DD42AF8760 >									
358 	//     < ASFGGGGN_1_metadata_line_36_____NORILSK_NICKEL_USD_ABC_Y14 >									
359 	//        < Zu5L30S96RccgY4V6xX44uE5fVRy9fOA1pjm5sA81KeJb7wU758G49y8MOCB964g >									
360 	//        <  u =="0.000000000000000001" : ] 000000450578877.503079000000000000 ; 000000576780354.185417000000000000 ] >									
361 	//        < 0x000000000000000000000000000000000000000000000000002AF876037018D3 >									
362 	//     < ASFGGGGN_1_metadata_line_37_____NORILSK_NICKEL_USD_RO_Y3K1.00 >									
363 	//        < 01a15aM955cs6iY9dJRYR4496LARp5tI11mk6XwmfQ0bE67JuS24Pb3KwVqz5z5B >									
364 	//        <  u =="0.000000000000000001" : ] 000000576780354.185417000000000000 ; 000000589175608.570297000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000037018D338302B9 >									
366 	//     < ASFGGGGN_1_metadata_line_38_____NORILSK_NICKEL_USD_RO_Y3K0.90 >									
367 	//        < nWVzkO1JtC82moMC3mFeT1f9BDZ4gDx510aEnid40k0GJcQHwE190EZvUngZU9Y5 >									
368 	//        <  u =="0.000000000000000001" : ] 000000589175608.570297000000000000 ; 000000602892618.176607000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000038302B9397F0EE >									
370 	//     < ASFGGGGN_1_metadata_line_39_____NORILSK_NICKEL_USD_RO_Y7K1.00 >									
371 	//        < w3vdrSk1fNt5dEE1EbbISfcjIa0lUJynB207091GF73E16EEj4p8QM2jetu4IA07 >									
372 	//        <  u =="0.000000000000000001" : ] 000000602892618.176607000000000000 ; 000000632405862.437160000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000397F0EE3C4F98A >									
374 	//     < ASFGGGGN_1_metadata_line_40_____NORILSK_NICKEL_USD_RO_Y7K0.90 >									
375 	//        < 5FCjQ03h7j69dWZ85DCmJZCwlZct1EC7Ih9AuDhWxY111AcuVn5oBta5w499J1aw >									
376 	//        <  u =="0.000000000000000001" : ] 000000632405862.437160000000000000 ; 000000668342310.604717000000000000 ] >									
377 	//        < 0x000000000000000000000000000000000000000000000000003C4F98A3FBCF37 >									
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