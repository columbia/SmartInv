1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXXII_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXXII_III_883		"	;
8 		string	public		symbol =	"	RUSS_PFXXII_III_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1096158977593040000000000000					;	
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
92 	//     < RUSS_PFXXII_III_metadata_line_1_____RUSSIAN_FEDERATION_BOND_1_20231101 >									
93 	//        < 30TX7Oz01hffrmGy5XFqqG921jj6j37fTJzvrvPSgVDxzVWWt7MWT06dA8Y3ej7f >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000033430916.896991600000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000003302F4 >									
96 	//     < RUSS_PFXXII_III_metadata_line_2_____RF_BOND_2_20231101 >									
97 	//        < nQ4a572s1qCHt4KOw7fO9Xv5lNVqus65kL193xunnPGj2h5eralIikB9Bl3tK58q >									
98 	//        <  u =="0.000000000000000001" : ] 000000033430916.896991600000000000 ; 000000063965328.404549800000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000003302F4619A75 >									
100 	//     < RUSS_PFXXII_III_metadata_line_3_____RF_BOND_3_20231101 >									
101 	//        < 7XRcXcf01Ftg764hfqShVj4shlkwfs2XB9ZKNqzcqD5l0rvnVbUwHV1Vr6edCGf2 >									
102 	//        <  u =="0.000000000000000001" : ] 000000063965328.404549800000000000 ; 000000086749705.190673700000000000 ] >									
103 	//        < 0x0000000000000000000000000000000000000000000000000000619A75845E9B >									
104 	//     < RUSS_PFXXII_III_metadata_line_4_____RF_BOND_4_20231101 >									
105 	//        < mUSB38hPw8l8284lFw32Tx2AVk324Wa1v7846297TF9yEXYugBMNfZLqaE6Yl5Y0 >									
106 	//        <  u =="0.000000000000000001" : ] 000000086749705.190673700000000000 ; 000000113455671.311931000000000000 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000000000845E9BAD1E9F >									
108 	//     < RUSS_PFXXII_III_metadata_line_5_____RF_BOND_5_20231101 >									
109 	//        < LiwRN0Fv5mMqo4jR5wH3m9LhkrpR8KYZr3sxmdi3rMXZcp2245Vij550O3jpk0u1 >									
110 	//        <  u =="0.000000000000000001" : ] 000000113455671.311931000000000000 ; 000000141789947.455908000000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000AD1E9FD85AB3 >									
112 	//     < RUSS_PFXXII_III_metadata_line_6_____RF_BOND_6_20231101 >									
113 	//        < L7Q95w72KQZ8FMT5lWZz9WCDg6qk3mpU8T9Yy1wI91B91gS8SlannhpJHtq5620w >									
114 	//        <  u =="0.000000000000000001" : ] 000000141789947.455908000000000000 ; 000000168036220.841568000000000000 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000000000D85AB31006726 >									
116 	//     < RUSS_PFXXII_III_metadata_line_7_____RF_BOND_7_20231101 >									
117 	//        < 8TcX9vNQka1FCBCqBneLIQk7Vcvf0TdRX3TqhfYk7u3xZPk0HI52GBqRl4p2hK6u >									
118 	//        <  u =="0.000000000000000001" : ] 000000168036220.841568000000000000 ; 000000192481746.916433000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000001006726125B42F >									
120 	//     < RUSS_PFXXII_III_metadata_line_8_____RF_BOND_8_20231101 >									
121 	//        < Y23srg4G6o3VjvILpGOAXr31hiYLEFG6I9g2hqaLNjz0fMnvqPOza30rn84uxX3p >									
122 	//        <  u =="0.000000000000000001" : ] 000000192481746.916433000000000000 ; 000000225885288.739582000000000000 ] >									
123 	//        < 0x00000000000000000000000000000000000000000000000000125B42F158AC71 >									
124 	//     < RUSS_PFXXII_III_metadata_line_9_____RF_BOND_9_20231101 >									
125 	//        < F421A03dlcVLFXiz72H2Z88S2Z640YkGbj1ln6eOXSSj7jGHB4uEK67eiGyVFB96 >									
126 	//        <  u =="0.000000000000000001" : ] 000000225885288.739582000000000000 ; 000000245952483.007270000000000000 ] >									
127 	//        < 0x00000000000000000000000000000000000000000000000000158AC711774B30 >									
128 	//     < RUSS_PFXXII_III_metadata_line_10_____RF_BOND_10_20231101 >									
129 	//        < 4hZq697CEbIb2J15NQe3WGJfG9581k664N5dM7QZQOOs7ZiEa9R82dx00bONraO7 >									
130 	//        <  u =="0.000000000000000001" : ] 000000245952483.007270000000000000 ; 000000268240444.598512000000000000 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000000001774B301994D6C >									
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
174 	//     < RUSS_PFXXII_III_metadata_line_11_____RUSS_CENTRAL_BANK_BOND_1_20231101 >									
175 	//        < VICwYG3J61U4qsHnZx995Wi0s550fpgX125E33ytl4S17V8ngAi4kn89zsXr1s9Y >									
176 	//        <  u =="0.000000000000000001" : ] 000000268240444.598512000000000000 ; 000000297092286.955353000000000000 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000000001994D6C1C553AD >									
178 	//     < RUSS_PFXXII_III_metadata_line_12_____RCB_BOND_2_20231101 >									
179 	//        < 18C9i6229Y65rH3576RC6a9HS2269cJGPG9opr2672295Jgha3LEFDoP6Xm6VWz1 >									
180 	//        <  u =="0.000000000000000001" : ] 000000297092286.955353000000000000 ; 000000327099637.666621000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000001C553AD1F31D4C >									
182 	//     < RUSS_PFXXII_III_metadata_line_13_____RCB_BOND_3_20231101 >									
183 	//        < 0pNJj0D6Xhqg02gvVESB4106SyxO6cS1N8h24014E44uN1i60l7Awmi0aN4RSFjm >									
184 	//        <  u =="0.000000000000000001" : ] 000000327099637.666621000000000000 ; 000000348061069.415597000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001F31D4C213195B >									
186 	//     < RUSS_PFXXII_III_metadata_line_14_____RCB_BOND_4_20231101 >									
187 	//        < u84cpnECUs0v8I2u6bNq5uNHI4mv8x3cJ1lO0hqE0l521lMI477JU7U25I0R7e7z >									
188 	//        <  u =="0.000000000000000001" : ] 000000348061069.415597000000000000 ; 000000379031523.110246000000000000 ] >									
189 	//        < 0x00000000000000000000000000000000000000000000000000213195B2425B30 >									
190 	//     < RUSS_PFXXII_III_metadata_line_15_____RCB_BOND_5_20231101 >									
191 	//        < MqW1W6t5LMLi0BS3vsFkaniixfjnC3n87SGW5t5EGIcTWTs7JzUoW43yslvy0Y95 >									
192 	//        <  u =="0.000000000000000001" : ] 000000379031523.110246000000000000 ; 000000407109986.594385000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000002425B3026D3357 >									
194 	//     < RUSS_PFXXII_III_metadata_line_16_____ROSSELKHOZBANK_20231101 >									
195 	//        < 95fBWTn47T94Si7FRXu8TFZ7JfyfNOHUqKXoZKnxO9Os7OgJ2817hQiPhVM2cP41 >									
196 	//        <  u =="0.000000000000000001" : ] 000000407109986.594385000000000000 ; 000000427936333.785940000000000000 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000000026D335728CFAA1 >									
198 	//     < RUSS_PFXXII_III_metadata_line_17_____PROMSVYAZBANK_20231101 >									
199 	//        < zgpGWV530U3OO1QA34ngIoJOLUpaIKuX7wc81B20W630r5VqO31bkLzT0U19JwJk >									
200 	//        <  u =="0.000000000000000001" : ] 000000427936333.785940000000000000 ; 000000446687017.184958000000000000 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000000028CFAA12A9971E >									
202 	//     < RUSS_PFXXII_III_metadata_line_18_____BN_BANK_20231101 >									
203 	//        < M9CBF2lVOy5C0eHXp30gA80iUSyE6RIS52R4aBUTiwLDUxY77G0b00x1aU8USij8 >									
204 	//        <  u =="0.000000000000000001" : ] 000000446687017.184958000000000000 ; 000000481009971.646378000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000002A9971E2DDF685 >									
206 	//     < RUSS_PFXXII_III_metadata_line_19_____RUSSIAN_STANDARD_BANK_20231101 >									
207 	//        < 1S0nQOU7dVuAH23859RYjK0Eu8z0xCCm72PnS9KSXjABgK2OlVZL3q4dUNKLfTCy >									
208 	//        <  u =="0.000000000000000001" : ] 000000481009971.646378000000000000 ; 000000511117936.496449000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000002DDF68530BE772 >									
210 	//     < RUSS_PFXXII_III_metadata_line_20_____OTKRITIE_20231101 >									
211 	//        < Ukwg9aBZab64ks4G3Dx7Q929VCx1VVU0z0N546Z4uK5qAm6UbF5FTip59M974bvT >									
212 	//        <  u =="0.000000000000000001" : ] 000000511117936.496449000000000000 ; 000000545585920.017066000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000030BE7723407F80 >									
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
256 	//     < RUSS_PFXXII_III_metadata_line_21_____HOME_CREDIT_FINANCE_BANK_20231101 >									
257 	//        < 4sd95dk4bjF9v2Emg0NW3Ko9yBbfGMg2aOq8SGACe4CDSD571iiXECqRK2Z3Ajut >									
258 	//        <  u =="0.000000000000000001" : ] 000000545585920.017066000000000000 ; 000000565710513.672889000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000003407F8035F34AB >									
260 	//     < RUSS_PFXXII_III_metadata_line_22_____UNICREDIT_BANK_RUSSIA_20231101 >									
261 	//        < 7VCi9dyz15WFO5k6YT0G53v3trfNuZluhxSI5Xo2JcaqCkRlKjos94Vn28oP2F7D >									
262 	//        <  u =="0.000000000000000001" : ] 000000565710513.672889000000000000 ; 000000597175965.965451000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000035F34AB38F37DD >									
264 	//     < RUSS_PFXXII_III_metadata_line_23_____URAL_BANK_RECONSTRUCTION_DEV_20231101 >									
265 	//        < mlrAiHp5j46L1BZg9m492Pcm05E748xAz868Wh33806TbdA40X58s6NHbK8TDV1G >									
266 	//        <  u =="0.000000000000000001" : ] 000000597175965.965451000000000000 ; 000000631045871.413001000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000038F37DD3C2E64B >									
268 	//     < RUSS_PFXXII_III_metadata_line_24_____AK_BARS_BANK_20231101 >									
269 	//        < dZjbg07h6TT5Z4Hp9J69ssfmosFnYK0P97y66diSscHB3khW7wB87U5vjpznrSym >									
270 	//        <  u =="0.000000000000000001" : ] 000000631045871.413001000000000000 ; 000000665622872.815288000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000003C2E64B3F7A8EF >									
272 	//     < RUSS_PFXXII_III_metadata_line_25_____SOVCOMBANK_20231101 >									
273 	//        < 6h30mBt1j43XXL568qFl6CJ4LyBk4wCvSJ5fjE1IPH79IcK314ri7yC94156200l >									
274 	//        <  u =="0.000000000000000001" : ] 000000665622872.815288000000000000 ; 000000689266748.368672000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000003F7A8EF41BBCD3 >									
276 	//     < RUSS_PFXXII_III_metadata_line_26_____MONEYGRAM_RUSS_20231101 >									
277 	//        < Cw4Wkzr76A3nGGx5385AB70WeIaj70d66a0bgi7ucgIQP5YxOwi4NpG1wZ56gZoC >									
278 	//        <  u =="0.000000000000000001" : ] 000000689266748.368672000000000000 ; 000000715171668.908793000000000000 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000000000041BBCD344343EF >									
280 	//     < RUSS_PFXXII_III_metadata_line_27_____VOZROZHDENIE_BANK_20231101 >									
281 	//        < xE042s95K847z5Sv6T07G11h9T6XM18vj8k34r75N5A157RH147AmuK4m09XLy9K >									
282 	//        <  u =="0.000000000000000001" : ] 000000715171668.908793000000000000 ; 000000749415923.189746000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000044343EF4778498 >									
284 	//     < RUSS_PFXXII_III_metadata_line_28_____MTC_BANK_20231101 >									
285 	//        < si0AOuO97mc6X6vsU90Qw5p23fg7uKfCjcjO8metJ8QDFhbtBE2r44D5nlQ3MAnz >									
286 	//        <  u =="0.000000000000000001" : ] 000000749415923.189746000000000000 ; 000000769050100.331286000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000047784984957A32 >									
288 	//     < RUSS_PFXXII_III_metadata_line_29_____ABSOLUT_BANK_20231101 >									
289 	//        < t55z3X2FyDCMs3Ehfcui0PCEkdB7ZBzm8JGeNZPSt7vOtDL0kUNxuIG4se1V7KzQ >									
290 	//        <  u =="0.000000000000000001" : ] 000000769050100.331286000000000000 ; 000000800305226.259323000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000004957A324C52B3B >									
292 	//     < RUSS_PFXXII_III_metadata_line_30_____ROSBANK_20231101 >									
293 	//        < p3XwnO9EiBjrct6L04cn65M889ahD7qDIzMupX75Anr5UlY74wE933567XNvuITV >									
294 	//        <  u =="0.000000000000000001" : ] 000000800305226.259323000000000000 ; 000000836059015.617184000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000004C52B3B4FBB98E >									
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
338 	//     < RUSS_PFXXII_III_metadata_line_31_____ALFA_BANK_20231101 >									
339 	//        < DD80a6csJoA3ek90Tc5P76Ew0NrxB4z5198ZUh2byuszXHJJ15MUjL4H2LoUDA5o >									
340 	//        <  u =="0.000000000000000001" : ] 000000836059015.617184000000000000 ; 000000857599594.511358000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000004FBB98E51C97D7 >									
342 	//     < RUSS_PFXXII_III_metadata_line_32_____SOGAZ_20231101 >									
343 	//        < 6l6fo480CvqbI11D955BdaGox23q49HH90e5G46043YE877GzcP0X77d05zXr3th >									
344 	//        <  u =="0.000000000000000001" : ] 000000857599594.511358000000000000 ; 000000876518354.807783000000000000 ] >									
345 	//        < 0x0000000000000000000000000000000000000000000000000051C97D753975FB >									
346 	//     < RUSS_PFXXII_III_metadata_line_33_____RENAISSANCE_20231101 >									
347 	//        < C2ZYLb7O1e86GG0xCp464N4UpXruLus5m10kDD1Zw42z49H2Dfiii47155HsMQXp >									
348 	//        <  u =="0.000000000000000001" : ] 000000876518354.807783000000000000 ; 000000895033384.839370000000000000 ] >									
349 	//        < 0x0000000000000000000000000000000000000000000000000053975FB555B66A >									
350 	//     < RUSS_PFXXII_III_metadata_line_34_____VTB_BANK_20231101 >									
351 	//        < kX3hKr7iGgy49ylNuUw069Bz07P58n3r8n9lD98BY30ZJiDWT94KyAQDF9oZv66i >									
352 	//        <  u =="0.000000000000000001" : ] 000000895033384.839370000000000000 ; 000000927283009.578010000000000000 ] >									
353 	//        < 0x00000000000000000000000000000000000000000000000000555B66A586EBED >									
354 	//     < RUSS_PFXXII_III_metadata_line_35_____ERGO_RUSS_20231101 >									
355 	//        < z80Pkr4uJVw99wv75e2HHaKd0MovJ08slApFuc4u42x9Ii53XERO57UY1uJyybmN >									
356 	//        <  u =="0.000000000000000001" : ] 000000927283009.578010000000000000 ; 000000960945587.087853000000000000 ] >									
357 	//        < 0x00000000000000000000000000000000000000000000000000586EBED5BA495F >									
358 	//     < RUSS_PFXXII_III_metadata_line_36_____GAZPROMBANK_20231101 >									
359 	//        < 9cwgJo79kTOV2mJ6QmMZ2Ys0r6Q7WV67SPqHT9c2Yj9DDMMx243c9rJM5YmDwz94 >									
360 	//        <  u =="0.000000000000000001" : ] 000000960945587.087853000000000000 ; 000000988407946.091315000000000000 ] >									
361 	//        < 0x000000000000000000000000000000000000000000000000005BA495F5E430DB >									
362 	//     < RUSS_PFXXII_III_metadata_line_37_____SBERBANK_20231101 >									
363 	//        < XF7fl70Lm8k8EKLe68N89aoQdRCtTIm41B7R3kD239eyt58J2D81wKfZ6Y6GnfAG >									
364 	//        <  u =="0.000000000000000001" : ] 000000988407946.091315000000000000 ; 000001014605232.116320000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000005E430DB60C2A2B >									
366 	//     < RUSS_PFXXII_III_metadata_line_38_____TINKOFF_BANK_20231101 >									
367 	//        < MiKCOdS0aRCQc5Tqlp5AAwyFRkKuMujGg7b01Skyn9t3jnAui9CqGfK2RkCJrHEt >									
368 	//        <  u =="0.000000000000000001" : ] 000001014605232.116320000000000000 ; 000001048250354.757030000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000060C2A2B63F80CB >									
370 	//     < RUSS_PFXXII_III_metadata_line_39_____VBANK_20231101 >									
371 	//        < r7IZ0NpxbGYhT7M0s0EkAI1Lb2KprlguT72x2G79D9fP5895D145Gc09gGHsm3cX >									
372 	//        <  u =="0.000000000000000001" : ] 000001048250354.757030000000000000 ; 000001075918222.563670000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000063F80CB669B88E >									
374 	//     < RUSS_PFXXII_III_metadata_line_40_____CREDIT_BANK_MOSCOW_20231101 >									
375 	//        < nX12Y0b61fz5Np80fCZimd4xFjUwI8htpfIeHB8FqtaW1F6yA18PsXIO48jBj54k >									
376 	//        <  u =="0.000000000000000001" : ] 000001075918222.563670000000000000 ; 000001096158977.593040000000000000 ] >									
377 	//        < 0x00000000000000000000000000000000000000000000000000669B88E6889B1A >									
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