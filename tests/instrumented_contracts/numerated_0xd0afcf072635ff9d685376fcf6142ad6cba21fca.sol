1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFX_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFX_I_883		"	;
8 		string	public		symbol =	"	RUSS_PFX_I_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		596238414428471000000000000					;	
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
92 	//     < RUSS_PFX_I_metadata_line_1_____SPAO_RESO_GARANTIA_20211101 >									
93 	//        < a52b3v3MFUuy8j89gTtj5VIkH65G20cXjO8U0P0MRZK8DQsZ8Ku25ECX59QS8Z4t >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000013290222.673802700000000000 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000000014477E >									
96 	//     < RUSS_PFX_I_metadata_line_2_____GLAVSTROYKOMPLEKS_AB_20211101 >									
97 	//        < f5zRVpHb4PcrK4m6Gi5FmR3n3GGkly89zt1Bg1ehR4UL33EV7nvtDfJL4bkDQTVg >									
98 	//        <  u =="0.000000000000000001" : ] 000000013290222.673802700000000000 ; 000000028397632.580158400000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000014477E2B54D3 >									
100 	//     < RUSS_PFX_I_metadata_line_3_____BANK_URALSIB_PAO_20211101 >									
101 	//        < 63e62Fz114nEnE5iv06RiH1h6sREI5x80Z6F6OAI4zu8B9L6nZ5Ww9cVhXAkoOl8 >									
102 	//        <  u =="0.000000000000000001" : ] 000000028397632.580158400000000000 ; 000000043982819.027024000000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000002B54D3431CCA >									
104 	//     < RUSS_PFX_I_metadata_line_4_____STROYMONTAZH_AB_20211101 >									
105 	//        < m3w25T87jv5L2eRBR6FpIX3U17wIM8q0o80hn21Xs3Af5GzqH7hy1E5pb28jM6Vj >									
106 	//        <  u =="0.000000000000000001" : ] 000000043982819.027024000000000000 ; 000000057914569.008840300000000000 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000000000431CCA585EE1 >									
108 	//     < RUSS_PFX_I_metadata_line_5_____INGOSSTRAKH_20211101 >									
109 	//        < iY6OcLw8VYtSVc1DeMXht2OX1129iKiW8i7xooTCDpf3gb1ukGj6UUK5wjrC0G82 >									
110 	//        <  u =="0.000000000000000001" : ] 000000057914569.008840300000000000 ; 000000072510394.833484900000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000585EE16EA45F >									
112 	//     < RUSS_PFX_I_metadata_line_6_____ROSGOSSTRAKH_20211101 >									
113 	//        < SH79i9y12JaWD2hCHO75zV7bXNdqK6I1B3hbEZaxHniYVwF9KmqQQlYT2UEw0t9Z >									
114 	//        <  u =="0.000000000000000001" : ] 000000072510394.833484900000000000 ; 000000089514869.618099000000000000 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000000000006EA45F8896BF >									
116 	//     < RUSS_PFX_I_metadata_line_7_____ALFASTRAKHOVANIE_20211101 >									
117 	//        < Ro98tf8bQyhl3n6cb590a3lC9GA3YNOm7ze30b7OUuLIg3GZw1u3F490nnSwlQ37 >									
118 	//        <  u =="0.000000000000000001" : ] 000000089514869.618099000000000000 ; 000000104113713.921925000000000000 ] >									
119 	//        < 0x00000000000000000000000000000000000000000000000000008896BF9EDD6B >									
120 	//     < RUSS_PFX_I_metadata_line_8_____VSK_20211101 >									
121 	//        < H32E27bUtf4IqA0P8300b33JQfnVZC9773js7E2f6yDBkicPvB5n6QysZN2KxcG4 >									
122 	//        <  u =="0.000000000000000001" : ] 000000104113713.921925000000000000 ; 000000117724133.326128000000000000 ] >									
123 	//        < 0x00000000000000000000000000000000000000000000000000009EDD6BB3A1FD >									
124 	//     < RUSS_PFX_I_metadata_line_9_____SOGAZ_20211101 >									
125 	//        < 98ne03IayqLkNOZ89lFHphr7C44BS7Tvws0BSNuCh8ZB0388Q2Ub5PAS9P4G3L72 >									
126 	//        <  u =="0.000000000000000001" : ] 000000117724133.326128000000000000 ; 000000132581040.993395000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000000B3A1FDCA4D78 >									
128 	//     < RUSS_PFX_I_metadata_line_10_____RENAISSANCE_INSURANCE_20211101 >									
129 	//        < E99X1a91rcUv6XL473nuF63xae41X59cph9NS15AyX5g3hTe9dbtsC8UZ43316L4 >									
130 	//        <  u =="0.000000000000000001" : ] 000000132581040.993395000000000000 ; 000000148424023.711508000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000000CA4D78E27A22 >									
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
174 	//     < RUSS_PFX_I_metadata_line_11_____SOGLASIE_20211101 >									
175 	//        < WCz8y0XW8mpITF9WgyM11p1FFCf4hzEVsteY09GWufbSSjyn5RHnIOz2d8ul3f9l >									
176 	//        <  u =="0.000000000000000001" : ] 000000148424023.711508000000000000 ; 000000163350336.402221000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000000E27A22F940BA >									
178 	//     < RUSS_PFX_I_metadata_line_12_____VTB_INSURANCE_20211101 >									
179 	//        < KOkF92hm859BjrLdm5BVZ6Gz19hVtf2OfJ9myGbaj4rYqDFlG24Akf4vCeyZBe29 >									
180 	//        <  u =="0.000000000000000001" : ] 000000163350336.402221000000000000 ; 000000177935432.411605000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000000F940BA10F8207 >									
182 	//     < RUSS_PFX_I_metadata_line_13_____UGORIA_20211101 >									
183 	//        < iXA7cAA7jT2EQlj0LoWIh36T8dLabhn46nhTdf5I2GvAdzGozvUm4OW0WA4dbQZ6 >									
184 	//        <  u =="0.000000000000000001" : ] 000000177935432.411605000000000000 ; 000000194826663.754419000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000010F8207129482A >									
186 	//     < RUSS_PFX_I_metadata_line_14_____ERGO_20211101 >									
187 	//        < oBp73sn679Q7x43134c1x53H6rwfFk07Lro6bir6760B0Avi36229t1XDcFjAtTI >									
188 	//        <  u =="0.000000000000000001" : ] 000000194826663.754419000000000000 ; 000000208368849.701707000000000000 ] >									
189 	//        < 0x00000000000000000000000000000000000000000000000000129482A13DF215 >									
190 	//     < RUSS_PFX_I_metadata_line_15_____VTB_20211101 >									
191 	//        < rgKKXX2u9zDUW7xD8bY7rwRHaqh9AVGT6Q34q66fIEvuwtG0K37jOS2Tu0Rthvjs >									
192 	//        <  u =="0.000000000000000001" : ] 000000208368849.701707000000000000 ; 000000222577821.365745000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000013DF215153A076 >									
194 	//     < RUSS_PFX_I_metadata_line_16_____SBERBANK_20211101 >									
195 	//        < 12X8HqZ5JGGZm0914uPN6YVLE6tKzXBUdB5t6Tb8g02oa9nX1iv76mLaECw9O3Zr >									
196 	//        <  u =="0.000000000000000001" : ] 000000222577821.365745000000000000 ; 000000237236559.789762000000000000 ] >									
197 	//        < 0x00000000000000000000000000000000000000000000000000153A076169FE88 >									
198 	//     < RUSS_PFX_I_metadata_line_17_____TINKOFF_INSURANCE_20211101 >									
199 	//        < 6Uaj6alU1Qmuu0F033UXa6IA7J98f8nx7V2FDG5u0lCp153PGcWDl0D8g44bKqdF >									
200 	//        <  u =="0.000000000000000001" : ] 000000237236559.789762000000000000 ; 000000250198430.086193000000000000 ] >									
201 	//        < 0x00000000000000000000000000000000000000000000000000169FE8817DC5C3 >									
202 	//     < RUSS_PFX_I_metadata_line_18_____YANDEX_20211101 >									
203 	//        < W2uMP0CYmGk4zhgQN7OzL8G4GC7JGfuSnxmRhdGsT6VL5hxUNDny42cg3pipk4fA >									
204 	//        <  u =="0.000000000000000001" : ] 000000250198430.086193000000000000 ; 000000265526188.425088000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000017DC5C3195292B >									
206 	//     < RUSS_PFX_I_metadata_line_19_____TINKOFF_BANK_20211101 >									
207 	//        < 9sj6dN6tR9942J35hCacRxKyiIjTFvABqS03nxspI8BI8MG5151UBM3WTzM1z3BN >									
208 	//        <  u =="0.000000000000000001" : ] 000000265526188.425088000000000000 ; 000000278878405.232183000000000000 ] >									
209 	//        < 0x00000000000000000000000000000000000000000000000000195292B1A988E1 >									
210 	//     < RUSS_PFX_I_metadata_line_20_____ALFA_BANK_20211101 >									
211 	//        < UN532f2BgD451afdPzUWqLF42Uqw8RxGHfT7S3H7ky2618lsQanaMzvFbQ9w16D8 >									
212 	//        <  u =="0.000000000000000001" : ] 000000278878405.232183000000000000 ; 000000292699835.124263000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000001A988E11BE9FE0 >									
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
256 	//     < RUSS_PFX_I_metadata_line_21_____RENAISSANCE_CREDIT_20211101 >									
257 	//        < R6HOB9ss7uZt4fU2ssdyeY367281o92JcR713lS0Ym50MuUM0Z20o66b42u3HWFd >									
258 	//        <  u =="0.000000000000000001" : ] 000000292699835.124263000000000000 ; 000000309130325.136889000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000001BE9FE01D7B209 >									
260 	//     < RUSS_PFX_I_metadata_line_22_____SURGUTNEFTGAS_20211101 >									
261 	//        < R50i4uRq5zMJbaZdcMjnGp8Jhbyqn43eJaYpqINj1hDEDX3i5mR3j7SkvHAvJ53m >									
262 	//        <  u =="0.000000000000000001" : ] 000000309130325.136889000000000000 ; 000000322864744.347966000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000001D7B2091ECA70A >									
264 	//     < RUSS_PFX_I_metadata_line_23_____ROSSELKHOZBANK_20211101 >									
265 	//        < n8GjN7W8Spwi9POJmx7PP7af0wXv74k50F5lM20174l75lRd77h0w2PI3VeBI24R >									
266 	//        <  u =="0.000000000000000001" : ] 000000322864744.347966000000000000 ; 000000338642414.639376000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000001ECA70A204BA31 >									
268 	//     < RUSS_PFX_I_metadata_line_24_____KINEF_20211101 >									
269 	//        < 7cHbzN6Lc3E63gDucTXs32M2142o5B7uZab4BQWrNLKz5Ed87MGuTpbx1D5gb52u >									
270 	//        <  u =="0.000000000000000001" : ] 000000338642414.639376000000000000 ; 000000352309096.190163000000000000 ] >									
271 	//        < 0x00000000000000000000000000000000000000000000000000204BA3121994BE >									
272 	//     < RUSS_PFX_I_metadata_line_25_____PSKOVNEFTEPRODUCT_20211101 >									
273 	//        < HAL0EGiKtZ47tjHzAEz7aDScv6j9bdVjTXrVJx3UN2o1SWy74ZDiHELLPFQdIeZ1 >									
274 	//        <  u =="0.000000000000000001" : ] 000000352309096.190163000000000000 ; 000000367397091.002577000000000000 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000000000021994BE2309A7D >									
276 	//     < RUSS_PFX_I_metadata_line_26_____NOVGORODNEFTEPRODUKT_20211101 >									
277 	//        < 6X4SVvC82Wm354iEHGm2KFSYcSa8Hx30A4VL0BfNixgEZMVC0dTw424761TTBn04 >									
278 	//        <  u =="0.000000000000000001" : ] 000000367397091.002577000000000000 ; 000000380426686.551192000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000002309A7D2447C2D >									
280 	//     < RUSS_PFX_I_metadata_line_27_____CENTRAL_SURGUT_DEPOSITORY_20211101 >									
281 	//        < Vj3tEt5zrILal8Sm7C3Ra2n9e611ZI0yhjL8WR40pDY1uEu4Q46BGdid7xepRXT9 >									
282 	//        <  u =="0.000000000000000001" : ] 000000380426686.551192000000000000 ; 000000396212223.915802000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000002447C2D25C9266 >									
284 	//     < RUSS_PFX_I_metadata_line_28_____MA_TVERNEFTEPRODUKT_20211101 >									
285 	//        < 0QZpJ3r6n6IjZgW31x41N9weuL4zmwT1cbwn8j8ecBEfn5a9lwGK4m8cCI5P9w3u >									
286 	//        <  u =="0.000000000000000001" : ] 000000396212223.915802000000000000 ; 000000413256426.104002000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000025C9266276944B >									
288 	//     < RUSS_PFX_I_metadata_line_29_____SURGUTNEFTEGAS_INSURANCE_20211101 >									
289 	//        < VADf74HiqRHqeqT1u0R15t516q6IUYaz44rdt9nQ62aYyBFL34EM9hoZ55y0vc1n >									
290 	//        <  u =="0.000000000000000001" : ] 000000413256426.104002000000000000 ; 000000427223772.442356000000000000 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000000000276944B28BE449 >									
292 	//     < RUSS_PFX_I_metadata_line_30_____SURGUTNEFTEGASBANK_20211101 >									
293 	//        < FLmrI8K4ZdqJ7q2Zz419mo08NG6v70GX18x4wo6tCvilIfgT374CHt1mq73E9X7K >									
294 	//        <  u =="0.000000000000000001" : ] 000000427223772.442356000000000000 ; 000000442056888.439043000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000028BE4492A28679 >									
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
338 	//     < RUSS_PFX_I_metadata_line_31_____KIRISHIAVTOSERVIS_20211101 >									
339 	//        < 2Lu8F0yh4f4I43O6l0ua5Cr6BDowHzwUONb7g3Aej1So66zKjYH79S6u8tzfQnKq >									
340 	//        <  u =="0.000000000000000001" : ] 000000442056888.439043000000000000 ; 000000456194083.039882000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000002A286792B818D0 >									
342 	//     < RUSS_PFX_I_metadata_line_32_____SURGUTMEBEL_20211101 >									
343 	//        < I168S9f31IS7TAB2FH32k37OpeyEadX37y50KO3JremE3bxI4nQ9P13E3cDpbwQv >									
344 	//        <  u =="0.000000000000000001" : ] 000000456194083.039882000000000000 ; 000000471146656.185134000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000002B818D02CEE9AA >									
346 	//     < RUSS_PFX_I_metadata_line_33_____SOVKHOZ_CHERVISHEVSKY_20211101 >									
347 	//        < DYrK404w50NRe966iYu6ne6NlGcq5kQlo0B94mjdg5KWezXNj44T88c4x6q9GgQZ >									
348 	//        <  u =="0.000000000000000001" : ] 000000471146656.185134000000000000 ; 000000488168145.277505000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000002CEE9AA2E8E2AF >									
350 	//     < RUSS_PFX_I_metadata_line_34_____SURGUT_MEDIA_INVEST_20211101 >									
351 	//        < 6xHAk9SW1V8z1cOrTyi7y5ePuoyvsH7Lo5no8y3F2EH5K583J0S9fu6yVinAS959 >									
352 	//        <  u =="0.000000000000000001" : ] 000000488168145.277505000000000000 ; 000000504133760.627806000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000002E8E2AF3013F40 >									
354 	//     < RUSS_PFX_I_metadata_line_35_____BANK_RESO_CREDIT_20211101 >									
355 	//        < 8pX7VyK3mSyi83kuF1GMebz1qzx7z5KkVKvH7FZfEq68ICBB716480D3sE49uB09 >									
356 	//        <  u =="0.000000000000000001" : ] 000000504133760.627806000000000000 ; 000000517365612.795399000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000003013F403156FF1 >									
358 	//     < RUSS_PFX_I_metadata_line_36_____RESO_LEASING_20211101 >									
359 	//        < Y56Yv1M78cOOko3wN50v5Ce8q6jFy52WsX0RH6tO0P2a7lkpp2RvzgNsgEBF20N9 >									
360 	//        <  u =="0.000000000000000001" : ] 000000517365612.795399000000000000 ; 000000534075064.499219000000000000 ] >									
361 	//        < 0x000000000000000000000000000000000000000000000000003156FF132EEF12 >									
362 	//     < RUSS_PFX_I_metadata_line_37_____OSZH_RESO_GARANTIA_20211101 >									
363 	//        < qE8CgK3153VTVrX0pR739wgk8Wid446w69842Ng40ZdutrbMa283VUAjV75f138j >									
364 	//        <  u =="0.000000000000000001" : ] 000000534075064.499219000000000000 ; 000000549328760.487037000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000032EEF12346358C >									
366 	//     < RUSS_PFX_I_metadata_line_38_____ROSSETI_20211101 >									
367 	//        < e84G1tNq7Ni8KH9aq3l7kCuPYMI6wYdhxH1VEV2jzWF95AXAs68ZJyzy27xph064 >									
368 	//        <  u =="0.000000000000000001" : ] 000000549328760.487037000000000000 ; 000000566492299.299054000000000000 ] >									
369 	//        < 0x00000000000000000000000000000000000000000000000000346358C360660E >									
370 	//     < RUSS_PFX_I_metadata_line_39_____UNIPRO_20211101 >									
371 	//        < 8RKzYN6C20gF3RC961nKUafIdEIN7CA1JWb5P5rAQRgn2y98727n6N44LsB2OAzK >									
372 	//        <  u =="0.000000000000000001" : ] 000000566492299.299054000000000000 ; 000000579910102.018469000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000360660E374DF62 >									
374 	//     < RUSS_PFX_I_metadata_line_40_____RPC_UWC_20211101 >									
375 	//        < lPd5uQ79kPJlWK78VM13Aol53A5UFoo0f0hg48V75Fs09i1qKQ3l8w1Q64kssMM4 >									
376 	//        <  u =="0.000000000000000001" : ] 000000579910102.018469000000000000 ; 000000596238414.428471000000000000 ] >									
377 	//        < 0x00000000000000000000000000000000000000000000000000374DF6238DC9A1 >									
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