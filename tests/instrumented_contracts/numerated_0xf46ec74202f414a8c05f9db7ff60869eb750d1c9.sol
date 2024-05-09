1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	SHERE_PFV_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	SHERE_PFV_III_883		"	;
8 		string	public		symbol =	"	SHERE_PFV_III_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		2180230364645770000000000000					;	
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
92 	//     < SHERE_PFV_III_metadata_line_1_____AEROFLOT_20260505 >									
93 	//        < Ro3R1q75P67nG1gIJaTYAc7k6Ka87002DcfkE9bLih7oQeNc8tX5Yjt2y7PT9183 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000022510352.379132400000000000 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000000022591B >									
96 	//     < SHERE_PFV_III_metadata_line_2_____AEROFLOT_ORG_20260505 >									
97 	//        < 53Z6s3rZQ9z1z5Wy1F8MXj02sv3cZC5S3V5kEt2seIL83vq8869aQ099fP8NYpY2 >									
98 	//        <  u =="0.000000000000000001" : ] 000000022510352.379132400000000000 ; 000000093918896.472936900000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000022591B8F4F12 >									
100 	//     < SHERE_PFV_III_metadata_line_3_____AURORA_20260505 >									
101 	//        < Aznx4MUhuqw03UeLnnXVaC8YTqv7DHwi277REU5JnD8b7sqK59RG6VJujlHs4o5S >									
102 	//        <  u =="0.000000000000000001" : ] 000000093918896.472936900000000000 ; 000000135891472.035204000000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000008F4F12CF5A9B >									
104 	//     < SHERE_PFV_III_metadata_line_4_____AURORA_ORG_20260505 >									
105 	//        < IqEi1x81YdLGsMZ548Ex9L4OBjbFx6cuvWNF1n0T87Ezl474aIrC8jn95QU9SAVK >									
106 	//        <  u =="0.000000000000000001" : ] 000000135891472.035204000000000000 ; 000000173757927.690071000000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000CF5A9B1092231 >									
108 	//     < SHERE_PFV_III_metadata_line_5_____RUSSIA _20260505 >									
109 	//        < o197Sz5PKayhuYC4Ef9j7a08m9N3ZvYt7NX6YDFB8NIZH81XzXS516KeV07EGTte >									
110 	//        <  u =="0.000000000000000001" : ] 000000173757927.690071000000000000 ; 000000211634761.397782000000000000 ] >									
111 	//        < 0x000000000000000000000000000000000000000000000000001092231142EDD4 >									
112 	//     < SHERE_PFV_III_metadata_line_6_____RUSSIA _ORG_20260505 >									
113 	//        < 9EE08J3R2IG36PEfX16txs57tWxAWeaVaM1l4jCsRs42yGSxE8i1a728f2MTpIFp >									
114 	//        <  u =="0.000000000000000001" : ] 000000211634761.397782000000000000 ; 000000233277490.998442000000000000 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000000000142EDD4163F405 >									
116 	//     < SHERE_PFV_III_metadata_line_7_____VICTORIA_20260505 >									
117 	//        < A7w9vr2q9r4kc8PD4nqOYl2yOSqtg33J68JbCnPc6q6WV3VvFURbwh1USZsVz2dr >									
118 	//        <  u =="0.000000000000000001" : ] 000000233277490.998442000000000000 ; 000000270422232.235415000000000000 ] >									
119 	//        < 0x00000000000000000000000000000000000000000000000000163F40519CA1AF >									
120 	//     < SHERE_PFV_III_metadata_line_8_____VICTORIA_ORG_20260505 >									
121 	//        < wYDft67SO9b2Aw6cRHDpo92mo9tG14wrIzPjnlU56eNCt36C1YC2J356MT226Mn1 >									
122 	//        <  u =="0.000000000000000001" : ] 000000270422232.235415000000000000 ; 000000290848397.443690000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000019CA1AF1BBCCA8 >									
124 	//     < SHERE_PFV_III_metadata_line_9_____DOBROLET_20260505 >									
125 	//        < mo70Ny0M4e7Zyr10K90LuuiZsM8WtjDD6Sy9670a25Y8W9G2orD04DqQ604CJ65p >									
126 	//        <  u =="0.000000000000000001" : ] 000000290848397.443690000000000000 ; 000000373616188.106494000000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000001BBCCA823A17D3 >									
128 	//     < SHERE_PFV_III_metadata_line_10_____DOBROLET_ORG_20260505 >									
129 	//        < 082f9wKz0EVuDQ1uZ0zVQ2QviJ3k5262Jrc0BL13T6eNr0bmhFeNi4YbLYCc9Z0l >									
130 	//        <  u =="0.000000000000000001" : ] 000000373616188.106494000000000000 ; 000000417679012.380924000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000023A17D327D53DD >									
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
174 	//     < SHERE_PFV_III_metadata_line_11_____AEROFLOT_RUSSIAN_AIRLINES_20260505 >									
175 	//        < BfEX2E99XJz0Ni5AZu153O1e1rBnh0Rlbp8Fcm4fpd1078b6HIIX5N237wk4MxJo >									
176 	//        <  u =="0.000000000000000001" : ] 000000417679012.380924000000000000 ; 000000489640194.340117000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000027D53DD2EB21B3 >									
178 	//     < SHERE_PFV_III_metadata_line_12_____AEROFLOT_RUSSIAN_AIRLINES_ORG_20260505 >									
179 	//        < PDI2j39cvr3vJG48tjY72gg2TfYrPSvFhi1tcmVb5WOHw8xPD771OX3HyS30642s >									
180 	//        <  u =="0.000000000000000001" : ] 000000489640194.340117000000000000 ; 000000568572650.793115000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000002EB21B336392B1 >									
182 	//     < SHERE_PFV_III_metadata_line_13_____OTDELSTROY_INVEST_20260505 >									
183 	//        < xAnod6Qv62zQbi8HIk5x6b1n6wcEUyXBuYTq0JZqVcmCTPc0t4XUI2c533loaal5 >									
184 	//        <  u =="0.000000000000000001" : ] 000000568572650.793115000000000000 ; 000000663635062.541374000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000036392B13F4A072 >									
186 	//     < SHERE_PFV_III_metadata_line_14_____OTDELSTROY_INVEST_ORG_20260505 >									
187 	//        < a9OEQCpH7dw56hoCG1MSEX1OS8L8XyXuH2m4VH841aEvujVU97So098iXd9p5u7a >									
188 	//        <  u =="0.000000000000000001" : ] 000000663635062.541374000000000000 ; 000000683064184.641016000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000003F4A07241245F2 >									
190 	//     < SHERE_PFV_III_metadata_line_15_____POBEDA_AIRLINES_20260505 >									
191 	//        < Tqs62VyW6a15X8OoU5phPwkh70YU82g1mf9f9f583Jc1Sbaf8C930Vld5q4dD5zs >									
192 	//        <  u =="0.000000000000000001" : ] 000000683064184.641016000000000000 ; 000000701682589.867595000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000041245F242EAEC3 >									
194 	//     < SHERE_PFV_III_metadata_line_16_____POBEDA_AIRLINES_ORG_20260505 >									
195 	//        < lDL33lM0qMN15tRQZa9zL596Pyb4fUZRug2dV8a4JRJ8N20tNz7UnsQW60AG055H >									
196 	//        <  u =="0.000000000000000001" : ] 000000701682589.867595000000000000 ; 000000724016270.426867000000000000 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000000042EAEC3450C2DB >									
198 	//     < SHERE_PFV_III_metadata_line_17_____DAROFAN_20260505 >									
199 	//        < 062IuzZIk2QhJ9zRi1k12eE2I387P6jBWmRhi68VR8NXe8p2tQPkPSV8VwZTm4O4 >									
200 	//        <  u =="0.000000000000000001" : ] 000000724016270.426867000000000000 ; 000000793056571.086909000000000000 ] >									
201 	//        < 0x00000000000000000000000000000000000000000000000000450C2DB4BA1BB9 >									
202 	//     < SHERE_PFV_III_metadata_line_18_____DAROFAN_ORG_20260505 >									
203 	//        < MhihHU435vTHzwwogcDfakShpgf6Owz67D7dyQfZJ8F1j9feXiXP2DWIiDwXLwHP >									
204 	//        <  u =="0.000000000000000001" : ] 000000793056571.086909000000000000 ; 000000851135876.800447000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000004BA1BB9512BAF4 >									
206 	//     < SHERE_PFV_III_metadata_line_19_____TERMINAL_20260505 >									
207 	//        < 0T03d5r9BBZ05BNRK4gLsL3Qu5hTcXt5555B2dcOyEHg5x8YmKywHRsr7oWz2c9k >									
208 	//        <  u =="0.000000000000000001" : ] 000000851135876.800447000000000000 ; 000000937055459.328835000000000000 ] >									
209 	//        < 0x00000000000000000000000000000000000000000000000000512BAF4595D54A >									
210 	//     < SHERE_PFV_III_metadata_line_20_____TERMINAL_ORG_20260505 >									
211 	//        < GPHD4o798Z8rhytzXiarm6BTfD92tAN4M9K2v7NIYVfMu2gLN2Ry97lc0IXXs7DD >									
212 	//        <  u =="0.000000000000000001" : ] 000000937055459.328835000000000000 ; 000001031488769.396060000000000000 ] >									
213 	//        < 0x00000000000000000000000000000000000000000000000000595D54A625ED4D >									
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
256 	//     < SHERE_PFV_III_metadata_line_21_____AEROFLOT_FINANCE_20260505 >									
257 	//        < 9N2u2ApWiTg9d92qSf5817Rh5KbOQ2WhQFE6gl6u13ljx648j31m5TyPEd2LRS86 >									
258 	//        <  u =="0.000000000000000001" : ] 000001031488769.396060000000000000 ; 000001096635491.922850000000000000 ] >									
259 	//        < 0x00000000000000000000000000000000000000000000000000625ED4D689553D >									
260 	//     < SHERE_PFV_III_metadata_line_22_____AEROFLOT_FINANCE_ORG_20260505 >									
261 	//        < v3h59MLT37985NNEOjF5o02j9WO9kIxndT54kTCnF975P6w98E26Za0sqiC5OwDB >									
262 	//        <  u =="0.000000000000000001" : ] 000001096635491.922850000000000000 ; 000001130130053.662150000000000000 ] >									
263 	//        < 0x00000000000000000000000000000000000000000000000000689553D6BC710D >									
264 	//     < SHERE_PFV_III_metadata_line_23_____SHEROTEL_20260505 >									
265 	//        < vPw8p044UuyaK5Mnn7b65i83oSeLz0oAqkPN7GTEINkk8CVd8Gsr381Bgw8YEuim >									
266 	//        <  u =="0.000000000000000001" : ] 000001130130053.662150000000000000 ; 000001163330701.288890000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000006BC710D6EF1A0E >									
268 	//     < SHERE_PFV_III_metadata_line_24_____SHEROTEL_ORG_20260505 >									
269 	//        < 9Oww1fRDBFYzaB1q4rlmPNIPOk202Zv7WY5FhJwmq9wYup8PRnazKIYyCCJjY2Pa >									
270 	//        <  u =="0.000000000000000001" : ] 000001163330701.288890000000000000 ; 000001185900234.224180000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000006EF1A0E7118A47 >									
272 	//     < SHERE_PFV_III_metadata_line_25_____DALAVIA_KHABAROVSK_20260505 >									
273 	//        < 0IUfLv88hh0qT4qRX9FDBUQ2dmZjp260miCbagjhM3Iv3JnqbMLnlivAyeR2Gw7T >									
274 	//        <  u =="0.000000000000000001" : ] 000001185900234.224180000000000000 ; 000001258226164.001290000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000007118A4777FE698 >									
276 	//     < SHERE_PFV_III_metadata_line_26_____DALAVIA_KHABAROVSK_ORG_20260505 >									
277 	//        < tyg9DC27UBI5MBvPuw93flIUhw99gg77xSzvpaRFI542OxA42t9FSpOTw766djlE >									
278 	//        <  u =="0.000000000000000001" : ] 000001258226164.001290000000000000 ; 000001289861647.674410000000000000 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000000000077FE6987B02C35 >									
280 	//     < SHERE_PFV_III_metadata_line_27_____AEROFLOT_AVIATION_SCHOOL_20260505 >									
281 	//        < dHJlwuRL524iEl1Rlrn207tpVvEkR6ZqVWnlfc8TIti5j0QwoV7A4d772TQVIyTl >									
282 	//        <  u =="0.000000000000000001" : ] 000001289861647.674410000000000000 ; 000001338920151.563370000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000007B02C357FB07AF >									
284 	//     < SHERE_PFV_III_metadata_line_28_____AEROFLOT_AVIATION_SCHOOL_ORG_20260505 >									
285 	//        < G7qWz5b29I680BjbikHUk89fQ2qVu86y6Z0woN351z92b3Drlw1yt68L7iw6e6bE >									
286 	//        <  u =="0.000000000000000001" : ] 000001338920151.563370000000000000 ; 000001418033719.106940000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000007FB07AF873BF6C >									
288 	//     < SHERE_PFV_III_metadata_line_29_____A_TECHNICS_20260505 >									
289 	//        < ErclExcA3ELf9bszGiJrkplytS1Ku9o0WhT5k1k53hQ68wWdP5Yr8oT7uaFjbjkA >									
290 	//        <  u =="0.000000000000000001" : ] 000001418033719.106940000000000000 ; 000001479431735.454200000000000000 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000000000873BF6C8D16F06 >									
292 	//     < SHERE_PFV_III_metadata_line_30_____A_TECHNICS_ORG_20260505 >									
293 	//        < 179d0g91ji60f5ut86E7F0F1lE1Z3GT489eAF7Lg0cMFm9ytN7oILjx7Hsm20N2b >									
294 	//        <  u =="0.000000000000000001" : ] 000001479431735.454200000000000000 ; 000001562785224.777300000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000008D16F069509EFA >									
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
338 	//     < SHERE_PFV_III_metadata_line_31_____AEROMAR_20260505 >									
339 	//        < uCZ0jOjq3vFK6ZHO7CSqWOO8cJBz4jy71596mjCZ19B3270W0La33ql4PY666EnT >									
340 	//        <  u =="0.000000000000000001" : ] 000001562785224.777300000000000000 ; 000001658088142.550230000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000009509EFA9E20AAE >									
342 	//     < SHERE_PFV_III_metadata_line_32_____AEROMAR_ORG_20260505 >									
343 	//        < 1hEa1xv01P3VrBC169e28J4HFX9vKk2cHQ67jhJ7s1zDiA82uW8o745sN9A3gEa0 >									
344 	//        <  u =="0.000000000000000001" : ] 000001658088142.550230000000000000 ; 000001742184709.360960000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000009E20AAEA625CE7 >									
346 	//     < SHERE_PFV_III_metadata_line_33_____BUDGET_CARRIER_20260505 >									
347 	//        < LaJ360ckGAEC34u9rP7CFR00aS2257bIK73ypV4vWm45Rl3S9LfEj73PzVQIa4t0 >									
348 	//        <  u =="0.000000000000000001" : ] 000001742184709.360960000000000000 ; 000001773856045.346690000000000000 ] >									
349 	//        < 0x00000000000000000000000000000000000000000000000000A625CE7A92B085 >									
350 	//     < SHERE_PFV_III_metadata_line_34_____BUDGET_CARRIER_ORG_20260505 >									
351 	//        < 57xMp3H3K71766C4jbw8oNfE4Mz1s1Uk4o4oJuygu4Ndj2km2Mt5041xlU21X310 >									
352 	//        <  u =="0.000000000000000001" : ] 000001773856045.346690000000000000 ; 000001804878702.967550000000000000 ] >									
353 	//        < 0x00000000000000000000000000000000000000000000000000A92B085AC206BE >									
354 	//     < SHERE_PFV_III_metadata_line_35_____NATUSANA_20260505 >									
355 	//        < x0yWpB0C8Owo8kP0S6J282GGFTcNewZ73Z05DKW02484Ng834271g39g2ptnrBm9 >									
356 	//        <  u =="0.000000000000000001" : ] 000001804878702.967550000000000000 ; 000001862734051.880670000000000000 ] >									
357 	//        < 0x00000000000000000000000000000000000000000000000000AC206BEB1A4E7D >									
358 	//     < SHERE_PFV_III_metadata_line_36_____NATUSANA_ORG_20260505 >									
359 	//        < 7xjM4lhmhJ8z1g6heTBy08Kk46GuyF4ebbCyu3A77nA4c4HG5kPUskJuSzKeu46M >									
360 	//        <  u =="0.000000000000000001" : ] 000001862734051.880670000000000000 ; 000001955223409.232720000000000000 ] >									
361 	//        < 0x00000000000000000000000000000000000000000000000000B1A4E7DBA76F25 >									
362 	//     < SHERE_PFV_III_metadata_line_37_____AEROFLOT_PENSIONS_20260505 >									
363 	//        < v6b5V3ZbG6Ay7ciaO648yDDG09Be50838E8RnCcHmo92838jGvrkjhC7D6y789UW >									
364 	//        <  u =="0.000000000000000001" : ] 000001955223409.232720000000000000 ; 000001985566610.038620000000000000 ] >									
365 	//        < 0x00000000000000000000000000000000000000000000000000BA76F25BD5BBF5 >									
366 	//     < SHERE_PFV_III_metadata_line_38_____AEROFLOT_MUTU_20260505 >									
367 	//        < SpU5zm598nLFMqis0aER0b0Bq2PCC21zC38YQgJX7Jm6n5vW7ziwg1xEMOzxyJr5 >									
368 	//        <  u =="0.000000000000000001" : ] 000001985566610.038620000000000000 ; 000002040627338.794850000000000000 ] >									
369 	//        < 0x00000000000000000000000000000000000000000000000000BD5BBF5C29C00E >									
370 	//     < SHERE_PFV_III_metadata_line_39_____AEROFLOT_CAPITAL_20260505 >									
371 	//        < CLPc0YY8r5Ecqag6oOltmGA2vde1lV0WEFhG2NkTM0T2Gx5m9QVFzrKSszM5vnZU >									
372 	//        <  u =="0.000000000000000001" : ] 000002040627338.794850000000000000 ; 000002104779766.573850000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000C29C00EC8BA399 >									
374 	//     < SHERE_PFV_III_metadata_line_40_____AEROFLOT_HOLDINGS_20260505 >									
375 	//        < QBHxdm388QdQhOS31wALsfq6Bb7z1vq5DlCWf5rWt98Ja2rZar821PYu7raJsgHy >									
376 	//        <  u =="0.000000000000000001" : ] 000002104779766.573850000000000000 ; 000002180230364.645770000000000000 ] >									
377 	//        < 0x00000000000000000000000000000000000000000000000000C8BA399CFEC47C >									
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