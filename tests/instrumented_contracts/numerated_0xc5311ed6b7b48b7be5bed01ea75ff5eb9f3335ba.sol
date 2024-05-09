1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFX_II_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFX_II_883		"	;
8 		string	public		symbol =	"	RUSS_PFX_II_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		795027641621674000000000000					;	
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
92 	//     < RUSS_PFX_II_metadata_line_1_____SPAO_RESO_GARANTIA_20231101 >									
93 	//        < vUV5j7u5MOJARTq7fS5YarF5Igh55gQRayLtaS9EX8O3VdT6D4nglysHWNonPfOk >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000021500984.990521800000000000 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000000020CED2 >									
96 	//     < RUSS_PFX_II_metadata_line_2_____GLAVSTROYKOMPLEKS_AB_20231101 >									
97 	//        < b6957CuZK3OViH9Fj25iyZ2sz37FXaJ6KfyU9tH6KqvKzg6EgwydHQ2z72T59RbO >									
98 	//        <  u =="0.000000000000000001" : ] 000000021500984.990521800000000000 ; 000000043042102.857914500000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000020CED241AD52 >									
100 	//     < RUSS_PFX_II_metadata_line_3_____BANK_URALSIB_PAO_20231101 >									
101 	//        < OCMTgHLC0evNZoX1yT10ag37jAm8ZErF2MG0F57y42Ns1s8S3M33nKR573cfh8jr >									
102 	//        <  u =="0.000000000000000001" : ] 000000043042102.857914500000000000 ; 000000063929610.052507200000000000 ] >									
103 	//        < 0x000000000000000000000000000000000000000000000000000041AD52618C81 >									
104 	//     < RUSS_PFX_II_metadata_line_4_____STROYMONTAZH_AB_20231101 >									
105 	//        < NExR6PkRzy34rVT3Z2c2d69whmwkrcI8gGUFYvYvjY10y95Wi2Cn5SB0Ie72D96M >									
106 	//        <  u =="0.000000000000000001" : ] 000000063929610.052507200000000000 ; 000000079795289.691064000000000000 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000000000618C8179C209 >									
108 	//     < RUSS_PFX_II_metadata_line_5_____INGOSSTRAKH_20231101 >									
109 	//        < 136mvtR63MIp4L07BVPE303T8noXmdJgudh6o3OQmw38PVDrfiTE2Sli4n17n9O5 >									
110 	//        <  u =="0.000000000000000001" : ] 000000079795289.691064000000000000 ; 000000095231980.982802200000000000 ] >									
111 	//        < 0x000000000000000000000000000000000000000000000000000079C209914FFE >									
112 	//     < RUSS_PFX_II_metadata_line_6_____ROSGOSSTRAKH_20231101 >									
113 	//        < p76NK4j3u63t8Ys52ZbfG72vxy614gH07xv9Vo0hC29XZbn2c0z496OY6hQ7W33j >									
114 	//        <  u =="0.000000000000000001" : ] 000000095231980.982802200000000000 ; 000000117117618.852805000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000914FFEB2B512 >									
116 	//     < RUSS_PFX_II_metadata_line_7_____ALFASTRAKHOVANIE_20231101 >									
117 	//        < KS47Ea9k8ItI6PRn7ke5Vw71N3nH7q6UtARY8Nn4l3QiEXwDrr0xInK5kX6YHdU3 >									
118 	//        <  u =="0.000000000000000001" : ] 000000117117618.852805000000000000 ; 000000140118245.034154000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000B2B512D5CDB1 >									
120 	//     < RUSS_PFX_II_metadata_line_8_____VSK_20231101 >									
121 	//        < U13nzy3vgnG479j2O6iW5Qjy0yt2y2dN3BL8X976Od6xM5lCK7fEFHEGkc7634aS >									
122 	//        <  u =="0.000000000000000001" : ] 000000140118245.034154000000000000 ; 000000156480273.685965000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000D5CDB1EEC51B >									
124 	//     < RUSS_PFX_II_metadata_line_9_____SOGAZ_20231101 >									
125 	//        < FbB20d8Bpb4burrE1OQ7yNUs71fyc62Zvidi6c3x0WwanKFxt38vs2b8Z8JZ0Ux4 >									
126 	//        <  u =="0.000000000000000001" : ] 000000156480273.685965000000000000 ; 000000177740379.156869000000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000000EEC51B10F35D6 >									
128 	//     < RUSS_PFX_II_metadata_line_10_____RENAISSANCE_INSURANCE_20231101 >									
129 	//        < LFj4T2J3iE0GJeTpH0s3hfpIPPa9uP9rV4g02nHT92K59Sxrxq57VA2NF9gGOHVt >									
130 	//        <  u =="0.000000000000000001" : ] 000000177740379.156869000000000000 ; 000000195416904.802649000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000010F35D612A2EBA >									
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
174 	//     < RUSS_PFX_II_metadata_line_11_____SOGLASIE_20231101 >									
175 	//        < 585KCgf4G9C6h9D8WTL80k4oOkik86I3i1y9WTPcTmDXn157h4Q7IGH6bz78f1rd >									
176 	//        <  u =="0.000000000000000001" : ] 000000195416904.802649000000000000 ; 000000211015325.334408000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000012A2EBA141FBDD >									
178 	//     < RUSS_PFX_II_metadata_line_12_____VTB_INSURANCE_20231101 >									
179 	//        < 826O8KND3llXm41UmkU5AVHNLV754AECH80QwLK88M9QZIVDkNjy5455Vl9JLqnZ >									
180 	//        <  u =="0.000000000000000001" : ] 000000211015325.334408000000000000 ; 000000227756630.041089000000000000 ] >									
181 	//        < 0x00000000000000000000000000000000000000000000000000141FBDD15B876F >									
182 	//     < RUSS_PFX_II_metadata_line_13_____UGORIA_20231101 >									
183 	//        < 5UoVR76HYS8jn0UL86oFB916OPuBH7Z2pLij1ibq707r6i77m69v1T07YMqUHr2e >									
184 	//        <  u =="0.000000000000000001" : ] 000000227756630.041089000000000000 ; 000000246341610.012013000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000015B876F177E331 >									
186 	//     < RUSS_PFX_II_metadata_line_14_____ERGO_20231101 >									
187 	//        < 43OJ2cAPD64p27SX83eqfoVV8zOp5uQ3cQ1B5g053x02i3Kak2zgDRE1D2zJXEZb >									
188 	//        <  u =="0.000000000000000001" : ] 000000246341610.012013000000000000 ; 000000265119214.067658000000000000 ] >									
189 	//        < 0x00000000000000000000000000000000000000000000000000177E3311948A31 >									
190 	//     < RUSS_PFX_II_metadata_line_15_____VTB_20231101 >									
191 	//        < GS2J5nfD1hJSkMkYO1258H3zoT0kT4lU2X7wZ8VX45Et82Na2eU9WWttSsQaYcu9 >									
192 	//        <  u =="0.000000000000000001" : ] 000000265119214.067658000000000000 ; 000000281787433.502163000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000001948A311ADF937 >									
194 	//     < RUSS_PFX_II_metadata_line_16_____SBERBANK_20231101 >									
195 	//        < w3CK9iogfVYDjY7GTUz2u94HDLxY5qEWpv1WRx31d4LNkw051ZdzFCX42fAu183H >									
196 	//        <  u =="0.000000000000000001" : ] 000000281787433.502163000000000000 ; 000000304685313.398706000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000001ADF9371D0E9B3 >									
198 	//     < RUSS_PFX_II_metadata_line_17_____TINKOFF_INSURANCE_20231101 >									
199 	//        < t9Hz9EA99trgf2lBgXWg331ghOpLp310Yh5jLNdJ1Xc135S344oY99NKMe37Z6hJ >									
200 	//        <  u =="0.000000000000000001" : ] 000000304685313.398706000000000000 ; 000000328014824.693467000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000001D0E9B31F482CA >									
202 	//     < RUSS_PFX_II_metadata_line_18_____YANDEX_20231101 >									
203 	//        < dQXi532IyKu9h5VvtDEr4SZ9cSGhjp6Qd64c2WFj6Q6OqEy7z0ox5Z2M0Q8i0IB5 >									
204 	//        <  u =="0.000000000000000001" : ] 000000328014824.693467000000000000 ; 000000349944767.038952000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000001F482CA215F92D >									
206 	//     < RUSS_PFX_II_metadata_line_19_____TINKOFF_BANK_20231101 >									
207 	//        < XA86Ow75261j64Mdhwtpe4dfhBM4Dfk990Qah3baVJmtjdkmdTvivPh02PA7w44Y >									
208 	//        <  u =="0.000000000000000001" : ] 000000349944767.038952000000000000 ; 000000373379554.722134000000000000 ] >									
209 	//        < 0x00000000000000000000000000000000000000000000000000215F92D239BB63 >									
210 	//     < RUSS_PFX_II_metadata_line_20_____ALFA_BANK_20231101 >									
211 	//        < mYPI41EF7q261skXU0i8vp2t91lTVilTcimpscJ9SlA1N0KtdIV52K3LMH44NfG9 >									
212 	//        <  u =="0.000000000000000001" : ] 000000373379554.722134000000000000 ; 000000389191861.583563000000000000 ] >									
213 	//        < 0x00000000000000000000000000000000000000000000000000239BB63251DC12 >									
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
256 	//     < RUSS_PFX_II_metadata_line_21_____RENAISSANCE_CREDIT_20231101 >									
257 	//        < XIFHsSXU1xXpVO4B3Me5EWg72Ti7C400EbkDLA3y8z6O9TZ5wd2SC8rIMAnB46O6 >									
258 	//        <  u =="0.000000000000000001" : ] 000000389191861.583563000000000000 ; 000000412575116.860057000000000000 ] >									
259 	//        < 0x00000000000000000000000000000000000000000000000000251DC122758A28 >									
260 	//     < RUSS_PFX_II_metadata_line_22_____SURGUTNEFTGAS_20231101 >									
261 	//        < 1PTD6h7JCtXZ0nIHKk4J6sHn0XljtS403QL8ZkGu6CzrdW8q2q9pz6z3hsAyrkB6 >									
262 	//        <  u =="0.000000000000000001" : ] 000000412575116.860057000000000000 ; 000000433190867.311803000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000002758A28294FF2F >									
264 	//     < RUSS_PFX_II_metadata_line_23_____ROSSELKHOZBANK_20231101 >									
265 	//        < 63048pAxYG6Nk8wAGdc3pw1Zocb7a46Kh1kOR8lec93p2JD0u2G4jzUzP1XLwb2W >									
266 	//        <  u =="0.000000000000000001" : ] 000000433190867.311803000000000000 ; 000000453555778.294902000000000000 ] >									
267 	//        < 0x00000000000000000000000000000000000000000000000000294FF2F2B4123A >									
268 	//     < RUSS_PFX_II_metadata_line_24_____KINEF_20231101 >									
269 	//        < oHzBt04wB8L3S6sq4cBzs2Pw573c9zZph52Hhcy7Qiok3PP906724S2sQrnwVBij >									
270 	//        <  u =="0.000000000000000001" : ] 000000453555778.294902000000000000 ; 000000477919153.621962000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000002B4123A2D93F2B >									
272 	//     < RUSS_PFX_II_metadata_line_25_____PSKOVNEFTEPRODUCT_20231101 >									
273 	//        < Mb3Z6A854y0v6pVk89x4uFkIIaCqq06ycNbTkXw7SyH6GjFBGam6tQqwXc5f95Xd >									
274 	//        <  u =="0.000000000000000001" : ] 000000477919153.621962000000000000 ; 000000497676162.902048000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002D93F2B2F764C0 >									
276 	//     < RUSS_PFX_II_metadata_line_26_____NOVGORODNEFTEPRODUKT_20231101 >									
277 	//        < BVn40g45XOby5Z48i1Sc7q3hH5H2096lj8ho42ySgdcZus2VYrCu9i8UcWsHY1s5 >									
278 	//        <  u =="0.000000000000000001" : ] 000000497676162.902048000000000000 ; 000000516743980.180336000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000002F764C03147D1E >									
280 	//     < RUSS_PFX_II_metadata_line_27_____CENTRAL_SURGUT_DEPOSITORY_20231101 >									
281 	//        < ZNlOcx5k0LPTNGfr20i92hcswi8D79651WEO8V37yGOhd3Dr6Zi44Eiyznjs54pe >									
282 	//        <  u =="0.000000000000000001" : ] 000000516743980.180336000000000000 ; 000000532821577.566299000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000003147D1E32D056E >									
284 	//     < RUSS_PFX_II_metadata_line_28_____MA_TVERNEFTEPRODUKT_20231101 >									
285 	//        < 9DkE4NFa89DGgLGU1l7T2RsI5hISJ7D68rlcM8SVftPJ3H9fmXy40CA8YCeNp42q >									
286 	//        <  u =="0.000000000000000001" : ] 000000532821577.566299000000000000 ; 000000553670186.633656000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000032D056E34CD56B >									
288 	//     < RUSS_PFX_II_metadata_line_29_____SURGUTNEFTEGAS_INSURANCE_20231101 >									
289 	//        < Y07236SjxDw3ustvNlO12UaYSQPU8cnm5QS0NVJNidsDp77AZhRc1Bj601046qpE >									
290 	//        <  u =="0.000000000000000001" : ] 000000553670186.633656000000000000 ; 000000577851566.982739000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000034CD56B371BB45 >									
292 	//     < RUSS_PFX_II_metadata_line_30_____SURGUTNEFTEGASBANK_20231101 >									
293 	//        < vAUUAoB1r3w22qh9t29J8lDWSpDbp1D7u7MLqm2ISJPc6VuMqQwF7Bm0eJrcS4Q0 >									
294 	//        <  u =="0.000000000000000001" : ] 000000577851566.982739000000000000 ; 000000593894346.159595000000000000 ] >									
295 	//        < 0x00000000000000000000000000000000000000000000000000371BB4538A35FB >									
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
338 	//     < RUSS_PFX_II_metadata_line_31_____KIRISHIAVTOSERVIS_20231101 >									
339 	//        < A6f4aUpg6Q5M1WlOkdMTy1MAN8U60bRlWLg2k8tajMA0gzmTd1N1ndJ3ECIcW3Kn >									
340 	//        <  u =="0.000000000000000001" : ] 000000593894346.159595000000000000 ; 000000614773561.620345000000000000 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000000000038A35FB3AA11EC >									
342 	//     < RUSS_PFX_II_metadata_line_32_____SURGUTMEBEL_20231101 >									
343 	//        < 24jHoPCZA7iwl3073z8Pm1m50TYALob5ku5EQaajc4ppr2nNEr8y1Q89j85ck5uW >									
344 	//        <  u =="0.000000000000000001" : ] 000000614773561.620345000000000000 ; 000000636000204.317066000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000003AA11EC3CA7594 >									
346 	//     < RUSS_PFX_II_metadata_line_33_____SOVKHOZ_CHERVISHEVSKY_20231101 >									
347 	//        < ZfgagWAb737P865CY59K6eef7a1A075orU7b2AvwGTgg4pXVW6CB0zX885hN36DW >									
348 	//        <  u =="0.000000000000000001" : ] 000000636000204.317066000000000000 ; 000000656686349.733480000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000003CA75943EA061B >									
350 	//     < RUSS_PFX_II_metadata_line_34_____SURGUT_MEDIA_INVEST_20231101 >									
351 	//        < K8wbWZRb3xmoN561AFgtICgKbYL1QeCe3PSo86ePokNpgaxQzYTxHaptJr92SM00 >									
352 	//        <  u =="0.000000000000000001" : ] 000000656686349.733480000000000000 ; 000000672518228.033194000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000003EA061B4022E6F >									
354 	//     < RUSS_PFX_II_metadata_line_35_____BANK_RESO_CREDIT_20231101 >									
355 	//        < gpVT40qSRLhx2bb9Wqj7Mhz15Wf9o4S68asO4P3vBM7h9jV2A87i4b7pI7YxNJUc >									
356 	//        <  u =="0.000000000000000001" : ] 000000672518228.033194000000000000 ; 000000694419352.848943000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000004022E6F423998F >									
358 	//     < RUSS_PFX_II_metadata_line_36_____RESO_LEASING_20231101 >									
359 	//        < zb7GMN5MU0zyWb358nQ5j9Urco1J95T99M83O93RtDLEZsWIK13fvEa8z9i01b0E >									
360 	//        <  u =="0.000000000000000001" : ] 000000694419352.848943000000000000 ; 000000713893545.757028000000000000 ] >									
361 	//        < 0x00000000000000000000000000000000000000000000000000423998F44150AB >									
362 	//     < RUSS_PFX_II_metadata_line_37_____OSZH_RESO_GARANTIA_20231101 >									
363 	//        < 7iJ6IBKU3h7PXe27097htx3N1A632jnx61gAkuJdxbRxbtYKTIXfwdO8tPEkW43Y >									
364 	//        <  u =="0.000000000000000001" : ] 000000713893545.757028000000000000 ; 000000734790777.307267000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000044150AB46133A6 >									
366 	//     < RUSS_PFX_II_metadata_line_38_____ROSSETI_20231101 >									
367 	//        < S2p914dCuQVr5l2As4agFgfV5IX2iv26c57ehoZ96fquaMyi71b066xeCk0768F0 >									
368 	//        <  u =="0.000000000000000001" : ] 000000734790777.307267000000000000 ; 000000757877399.608095000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000046133A64846DDC >									
370 	//     < RUSS_PFX_II_metadata_line_39_____UNIPRO_20231101 >									
371 	//        < GyF3wVAu6b8QwA9nn1556RKxaNfm3Q553VRM0NkEp760MfFUS2U36My1o95TO88i >									
372 	//        <  u =="0.000000000000000001" : ] 000000757877399.608095000000000000 ; 000000779564044.038660000000000000 ] >									
373 	//        < 0x000000000000000000000000000000000000000000000000004846DDC4A58534 >									
374 	//     < RUSS_PFX_II_metadata_line_40_____RPC_UWC_20231101 >									
375 	//        < Zj8391i76B2C42TZzedzhBbfaoHW25GDsBnKCMvmFfPvFy6sVxn9ARPJl6s8ApNW >									
376 	//        <  u =="0.000000000000000001" : ] 000000779564044.038660000000000000 ; 000000795027641.621674000000000000 ] >									
377 	//        < 0x000000000000000000000000000000000000000000000000004A585344BD1DAC >									
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