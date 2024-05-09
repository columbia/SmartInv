1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFX_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFX_III_883		"	;
8 		string	public		symbol =	"	RUSS_PFX_III_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1039676271990040000000000000					;	
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
92 	//     < RUSS_PFX_III_metadata_line_1_____SPAO_RESO_GARANTIA_20251101 >									
93 	//        < zd92DuGw3P7VFJ9BxZpB5vv24xYhC19i5E7nZm12ppcK109fvjO48TP02bL8f7eS >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000020759933.550722900000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000001FAD59 >									
96 	//     < RUSS_PFX_III_metadata_line_2_____GLAVSTROYKOMPLEKS_AB_20251101 >									
97 	//        < YX809q2Quo6DKHpb3oTVS2HNC6XEPc7S1RC0b271AK1rSC6NWA36i7PwAk66dHqD >									
98 	//        <  u =="0.000000000000000001" : ] 000000020759933.550722900000000000 ; 000000053616580.842135800000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000001FAD5951CFFA >									
100 	//     < RUSS_PFX_III_metadata_line_3_____BANK_URALSIB_PAO_20251101 >									
101 	//        < V44Wz3hFa07LOVomoPNxtbJnQqqBg2vtL7k5SHnTm565XkqV8EuBDfck7KX5vb8m >									
102 	//        <  u =="0.000000000000000001" : ] 000000053616580.842135800000000000 ; 000000074493849.266990900000000000 ] >									
103 	//        < 0x000000000000000000000000000000000000000000000000000051CFFA71AB29 >									
104 	//     < RUSS_PFX_III_metadata_line_4_____STROYMONTAZH_AB_20251101 >									
105 	//        < hZR7P0v6u261ITipa7re9gegfv9cEyQ2MV6X176pG6wAW87T2Y2W6GPsRUJqhpTu >									
106 	//        <  u =="0.000000000000000001" : ] 000000074493849.266990900000000000 ; 000000098483178.217220900000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000071AB299645FE >									
108 	//     < RUSS_PFX_III_metadata_line_5_____INGOSSTRAKH_20251101 >									
109 	//        < 004v11Fi4qq3k1763sC2c3lR74nh8HUliuJ1LbhS0neqCEKzDbNN34pI9vw3VM8V >									
110 	//        <  u =="0.000000000000000001" : ] 000000098483178.217220900000000000 ; 000000122442573.371886000000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000009645FEBAD521 >									
112 	//     < RUSS_PFX_III_metadata_line_6_____ROSGOSSTRAKH_20251101 >									
113 	//        < 9j29adP1w3OcN9IsRw2Wa7kojpkXDi9VYGg9Naz6IPwOr7cu82E18Uhoi5jg47KL >									
114 	//        <  u =="0.000000000000000001" : ] 000000122442573.371886000000000000 ; 000000152177760.108539000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000BAD521E83470 >									
116 	//     < RUSS_PFX_III_metadata_line_7_____ALFASTRAKHOVANIE_20251101 >									
117 	//        < Yh5leWh49eFaZH2oo08ddx0Wo9WMY38OpB7g13nYeE7dGXTfS7Q2Z2c3VnP562x0 >									
118 	//        <  u =="0.000000000000000001" : ] 000000152177760.108539000000000000 ; 000000173303779.365626000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000000E8347010870CA >									
120 	//     < RUSS_PFX_III_metadata_line_8_____VSK_20251101 >									
121 	//        < 20WVaBvk0zt864Pr8mhb05iWBdd9Bdctw1QeNOBF604m3PivnVXg9d0IjFAig0jV >									
122 	//        <  u =="0.000000000000000001" : ] 000000173303779.365626000000000000 ; 000000194810196.673224000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000010870CA12941BC >									
124 	//     < RUSS_PFX_III_metadata_line_9_____SOGAZ_20251101 >									
125 	//        < 344t664DNUza0wL71Ll34yULByFY58N7105D67W8GBfqzE1lCFHi8UX4MfFv9X3k >									
126 	//        <  u =="0.000000000000000001" : ] 000000194810196.673224000000000000 ; 000000216242645.257614000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000012941BC149F5C9 >									
128 	//     < RUSS_PFX_III_metadata_line_10_____RENAISSANCE_INSURANCE_20251101 >									
129 	//        < 5FWaTJbc3mD9u6OOlovCAvycSgnu02Ok8F3sW12na43CF3lrDFQ53zu8Opy7uZhm >									
130 	//        <  u =="0.000000000000000001" : ] 000000216242645.257614000000000000 ; 000000237994840.058597000000000000 ] >									
131 	//        < 0x00000000000000000000000000000000000000000000000000149F5C916B26BC >									
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
174 	//     < RUSS_PFX_III_metadata_line_11_____SOGLASIE_20251101 >									
175 	//        < 1TQ97wvc1wz8rSWcOY8SZ6z0u557bb4hPOu46uQOnxs57tfKO851oL1WJDrh3ir9 >									
176 	//        <  u =="0.000000000000000001" : ] 000000237994840.058597000000000000 ; 000000262620853.809783000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000016B26BC190BA45 >									
178 	//     < RUSS_PFX_III_metadata_line_12_____VTB_INSURANCE_20251101 >									
179 	//        < FbwuX88HUbNPtZ972mSMuuB0qq8zcu7W5HB0eWeUWnko181zL1Du8oPZaWho40yn >									
180 	//        <  u =="0.000000000000000001" : ] 000000262620853.809783000000000000 ; 000000282364970.011103000000000000 ] >									
181 	//        < 0x00000000000000000000000000000000000000000000000000190BA451AEDAD1 >									
182 	//     < RUSS_PFX_III_metadata_line_13_____UGORIA_20251101 >									
183 	//        < f148ERiO85s209D807i9wl805iQcBG24RfUr04QMp7yH8jIQDE317fdI8Sz0b2S1 >									
184 	//        <  u =="0.000000000000000001" : ] 000000282364970.011103000000000000 ; 000000301359814.369394000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001AEDAD11CBD6AD >									
186 	//     < RUSS_PFX_III_metadata_line_14_____ERGO_20251101 >									
187 	//        < ro8S89Y7h1lguYZguqCMGrpIKqFQbkJw8R8875NyySJ45w4T67e35pgs0X0u7Y6M >									
188 	//        <  u =="0.000000000000000001" : ] 000000301359814.369394000000000000 ; 000000326075643.514021000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000001CBD6AD1F18D4C >									
190 	//     < RUSS_PFX_III_metadata_line_15_____VTB_20251101 >									
191 	//        < dRf5rr2s2vz2BtUkk7ugGayIu2r34Q21k4bH31oE1W1F3J77CdbL9dKZUeAb6b0A >									
192 	//        <  u =="0.000000000000000001" : ] 000000326075643.514021000000000000 ; 000000360114562.626441000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000001F18D4C2257DC0 >									
194 	//     < RUSS_PFX_III_metadata_line_16_____SBERBANK_20251101 >									
195 	//        < WUV8C7pqz8T376rq9tQxNj3XGb1RXZ836nqJWRZ7jY66QwIAkl9aH8egeIu6Cn0J >									
196 	//        <  u =="0.000000000000000001" : ] 000000360114562.626441000000000000 ; 000000389649519.061924000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000002257DC02528ED8 >									
198 	//     < RUSS_PFX_III_metadata_line_17_____TINKOFF_INSURANCE_20251101 >									
199 	//        < ME31HnujZZHZ6AZ9U979jHG1jQ18nzuTN979E8TlWoCiZe6yGqemds0L82BZhqa4 >									
200 	//        <  u =="0.000000000000000001" : ] 000000389649519.061924000000000000 ; 000000420884502.861969000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000002528ED82823802 >									
202 	//     < RUSS_PFX_III_metadata_line_18_____YANDEX_20251101 >									
203 	//        < OYeTouJqh4i0WdkMKyZ302091dxO618953cn38kGK644D6BGIx1NTLmL46Kk4V7H >									
204 	//        <  u =="0.000000000000000001" : ] 000000420884502.861969000000000000 ; 000000452796403.485613000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000028238022B2E998 >									
206 	//     < RUSS_PFX_III_metadata_line_19_____TINKOFF_BANK_20251101 >									
207 	//        < 5lIB4885Cg6p729UVB0KkF7Cl7yA7PQ2jDR8A08IGEkDt79f2tdUDO73j6AwjUXS >									
208 	//        <  u =="0.000000000000000001" : ] 000000452796403.485613000000000000 ; 000000473815609.533882000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000002B2E9982D2FC39 >									
210 	//     < RUSS_PFX_III_metadata_line_20_____ALFA_BANK_20251101 >									
211 	//        < 2mebpd3OF0297k2a9eHOmuX6x3OjDui6XK3aUUjeZZ5alX70PVKe3j34Qd12v8n5 >									
212 	//        <  u =="0.000000000000000001" : ] 000000473815609.533882000000000000 ; 000000498494263.568625000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000002D2FC392F8A452 >									
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
256 	//     < RUSS_PFX_III_metadata_line_21_____RENAISSANCE_CREDIT_20251101 >									
257 	//        < z487J5QgWa83E88pfLboo8nZ3H8mP2Xjk5eEhCRGG1ovIg9xo7Wr93C57f1AcRMK >									
258 	//        <  u =="0.000000000000000001" : ] 000000498494263.568625000000000000 ; 000000528895205.343719000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000002F8A45232707B1 >									
260 	//     < RUSS_PFX_III_metadata_line_22_____SURGUTNEFTGAS_20251101 >									
261 	//        < 6ZJENc2s8z192l7r50S1o7MV3jsKg1cR35qJGSSA67apSel0VO1sOK6GmfHXZ44u >									
262 	//        <  u =="0.000000000000000001" : ] 000000528895205.343719000000000000 ; 000000549315215.203787000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000032707B13463042 >									
264 	//     < RUSS_PFX_III_metadata_line_23_____ROSSELKHOZBANK_20251101 >									
265 	//        < QwTdRq6N4CH5BW2cgFZ9T11xp0JIk0o012owxxHR7N6nQp9FZ50QM46jE06X97t2 >									
266 	//        <  u =="0.000000000000000001" : ] 000000549315215.203787000000000000 ; 000000574157578.797516000000000000 ] >									
267 	//        < 0x00000000000000000000000000000000000000000000000000346304236C184E >									
268 	//     < RUSS_PFX_III_metadata_line_24_____KINEF_20251101 >									
269 	//        < W9e4OYNPEc30RUynR7K8NCI4FHTDjvNun9PpvaXlLFBA037P4Z3kLZ4335c3dO6y >									
270 	//        <  u =="0.000000000000000001" : ] 000000574157578.797516000000000000 ; 000000605732174.994706000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000036C184E39C4621 >									
272 	//     < RUSS_PFX_III_metadata_line_25_____PSKOVNEFTEPRODUCT_20251101 >									
273 	//        < 1R2atyu2o4de01N1K9EbSZ1kKuEjC6JtLHBvo78rmGjh0gV8vkKTscj7L7kSqtUt >									
274 	//        <  u =="0.000000000000000001" : ] 000000605732174.994706000000000000 ; 000000632681721.021670000000000000 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000000000039C46213C5654C >									
276 	//     < RUSS_PFX_III_metadata_line_26_____NOVGORODNEFTEPRODUKT_20251101 >									
277 	//        < a34Rd14iF6T32be5k45nUFuqVLf9wnM5K803VuWD650yjpQR061FOKcti0xoy4Yu >									
278 	//        <  u =="0.000000000000000001" : ] 000000632681721.021670000000000000 ; 000000651928916.912906000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000003C5654C3E2C3BC >									
280 	//     < RUSS_PFX_III_metadata_line_27_____CENTRAL_SURGUT_DEPOSITORY_20251101 >									
281 	//        < GZ77L3uhgu7y50Q7XxKp5hCGWU3K5ODR729TG2a832tVmJ6T2wR08GQvWh0vx368 >									
282 	//        <  u =="0.000000000000000001" : ] 000000651928916.912906000000000000 ; 000000684492710.117436000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000003E2C3BC41473F7 >									
284 	//     < RUSS_PFX_III_metadata_line_28_____MA_TVERNEFTEPRODUKT_20251101 >									
285 	//        < kGogEv9MiT9T3VBD13I0pYF5H31U55ickc2zx5WmsBHGo3KCW6tpxrd2O159sE9t >									
286 	//        <  u =="0.000000000000000001" : ] 000000684492710.117436000000000000 ; 000000716274778.627543000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000041473F7444F2D6 >									
288 	//     < RUSS_PFX_III_metadata_line_29_____SURGUTNEFTEGAS_INSURANCE_20251101 >									
289 	//        < jzDjkB7VB2Rn3qzcd0gVqBTrY7wfSEiJgXPtIqaMkq9XiGr56vM0i2TL7u9wt7SD >									
290 	//        <  u =="0.000000000000000001" : ] 000000716274778.627543000000000000 ; 000000735158302.295799000000000000 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000000000444F2D6461C336 >									
292 	//     < RUSS_PFX_III_metadata_line_30_____SURGUTNEFTEGASBANK_20251101 >									
293 	//        < B4ZzWunzNQ87A51vXgvB4c1y77U4u7I8Dk6qH368F0rq3gHIel88vi84RkJ0EE0F >									
294 	//        <  u =="0.000000000000000001" : ] 000000735158302.295799000000000000 ; 000000754923574.751959000000000000 ] >									
295 	//        < 0x00000000000000000000000000000000000000000000000000461C33647FEC05 >									
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
338 	//     < RUSS_PFX_III_metadata_line_31_____KIRISHIAVTOSERVIS_20251101 >									
339 	//        < P6a3ibk5LMB9W858MJOPH4y24JS5MRscqiVp05nWWbubz1MJ7i9iu4W71a5ej4SS >									
340 	//        <  u =="0.000000000000000001" : ] 000000754923574.751959000000000000 ; 000000789423343.562787000000000000 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000000000047FEC054B4907E >									
342 	//     < RUSS_PFX_III_metadata_line_32_____SURGUTMEBEL_20251101 >									
343 	//        < HUKmQhW663SXO1VAk2XD392oA0Sd9ZrzelqtJ5Z35dvDOaI82etJXF70V8X5VA5V >									
344 	//        <  u =="0.000000000000000001" : ] 000000789423343.562787000000000000 ; 000000823978865.472750000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000004B4907E4E94ABF >									
346 	//     < RUSS_PFX_III_metadata_line_33_____SOVKHOZ_CHERVISHEVSKY_20251101 >									
347 	//        < xNR1m0Ptd9FoYhBz0ECf33cgf59u3ZoEwhgpL0BSCK9zJJhDa08528802l5e8uW3 >									
348 	//        <  u =="0.000000000000000001" : ] 000000823978865.472750000000000000 ; 000000856658000.882960000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000004E94ABF51B2808 >									
350 	//     < RUSS_PFX_III_metadata_line_34_____SURGUT_MEDIA_INVEST_20251101 >									
351 	//        < avirxtZ01l1V8ZiaarIO8UBU9tNsw7l9PNZQOej12JM5W25525eVCDRppa0ir5Km >									
352 	//        <  u =="0.000000000000000001" : ] 000000856658000.882960000000000000 ; 000000882364848.452055000000000000 ] >									
353 	//        < 0x0000000000000000000000000000000000000000000000000051B280854261C5 >									
354 	//     < RUSS_PFX_III_metadata_line_35_____BANK_RESO_CREDIT_20251101 >									
355 	//        < hyxh1CkM1G0g2y8CtO12m8we6jY7S5976NeV93boqURp2f8c1M5KyjdpExm9ao86 >									
356 	//        <  u =="0.000000000000000001" : ] 000000882364848.452055000000000000 ; 000000914599753.814571000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000054261C55739187 >									
358 	//     < RUSS_PFX_III_metadata_line_36_____RESO_LEASING_20251101 >									
359 	//        < dacDw8G43Gl5GndseJPDeI7hj8F4oY51dR78S2Icy1b639YOU5JP25FygLV534G4 >									
360 	//        <  u =="0.000000000000000001" : ] 000000914599753.814571000000000000 ; 000000938176618.566319000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000057391875978B3E >									
362 	//     < RUSS_PFX_III_metadata_line_37_____OSZH_RESO_GARANTIA_20251101 >									
363 	//        < 6kd6wadFtfoaiex0v4lVQsi1o84VUJDom7mcej6OT6A7GSUs8WNAd8NyMAlAleEF >									
364 	//        <  u =="0.000000000000000001" : ] 000000938176618.566319000000000000 ; 000000962067525.214789000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000005978B3E5BBFFA1 >									
366 	//     < RUSS_PFX_III_metadata_line_38_____ROSSETI_20251101 >									
367 	//        < B33DHnTnX2QGA00uDxao721508jaYpQ8xrHP0Ljd2JknEMgp7tR41AQ22qfP6iWQ >									
368 	//        <  u =="0.000000000000000001" : ] 000000962067525.214789000000000000 ; 000000994727014.306313000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000005BBFFA15EDD53D >									
370 	//     < RUSS_PFX_III_metadata_line_39_____UNIPRO_20251101 >									
371 	//        < yTJiwJePoK8AMZO7tIF423p26w9MFjhBvHp7N69Ag8iZWXq7cTdE5VN1W691f69E >									
372 	//        <  u =="0.000000000000000001" : ] 000000994727014.306313000000000000 ; 000001020246662.536430000000000000 ] >									
373 	//        < 0x000000000000000000000000000000000000000000000000005EDD53D614C5DA >									
374 	//     < RUSS_PFX_III_metadata_line_40_____RPC_UWC_20251101 >									
375 	//        < Y4UC3N58CN1S4hURn67asd1hOcz8FZD94Ae9CwgjMtSUGfPZGu26l31sZFUN470d >									
376 	//        <  u =="0.000000000000000001" : ] 000001020246662.536430000000000000 ; 000001039676271.990040000000000000 ] >									
377 	//        < 0x00000000000000000000000000000000000000000000000000614C5DA6326B8B >									
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