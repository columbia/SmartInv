1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXXVII_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXXVII_III_883		"	;
8 		string	public		symbol =	"	RUSS_PFXXVII_III_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		977766545891770000000000000					;	
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
92 	//     < RUSS_PFXXVII_III_metadata_line_1_____SIBUR_20251101 >									
93 	//        < eI8PvFr82tEfaZba2ZM4UT0265Np7g3rHXq72B9hlNmJnUc52JU5JvrE17DaaTP5 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000035148812.221975300000000000 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000000035A201 >									
96 	//     < RUSS_PFXXVII_III_metadata_line_2_____SIBURTYUMENGAZ_20251101 >									
97 	//        < 4YnN352a7ij0P1217t8jmBo5Q44W56Ze2Mz2q2mad461x80eftL5SbRtug9UC7h6 >									
98 	//        <  u =="0.000000000000000001" : ] 000000035148812.221975300000000000 ; 000000067074561.638749500000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000035A201665900 >									
100 	//     < RUSS_PFXXVII_III_metadata_line_3_____VOLGOPROMGAZ_GROUP_20251101 >									
101 	//        < 9JE6a3g6F081CIA3587nY0E92R76zM6kwNWNwwi5z0rj3qJl9q0b9991Bimg62eh >									
102 	//        <  u =="0.000000000000000001" : ] 000000067074561.638749500000000000 ; 000000097646210.460877400000000000 ] >									
103 	//        < 0x000000000000000000000000000000000000000000000000000066590094FF0D >									
104 	//     < RUSS_PFXXVII_III_metadata_line_4_____KSTOVO_20251101 >									
105 	//        < 0699Jx54hX2tO1hWPY4zMYp9bPN58VLcs26UZMEQpctRKMF0821leb0XOsy2j1QM >									
106 	//        <  u =="0.000000000000000001" : ] 000000097646210.460877400000000000 ; 000000122926235.130098000000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000094FF0DBB9210 >									
108 	//     < RUSS_PFXXVII_III_metadata_line_5_____SIBUR_MOTORS_20251101 >									
109 	//        < 19MFDD47S86W36Mzq2Ou1cig3r6Nrp8fdod7C5e6PdiFEz5XCW8ZLGzBwmlhGa9l >									
110 	//        <  u =="0.000000000000000001" : ] 000000122926235.130098000000000000 ; 000000141286790.870610000000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000BB9210D79627 >									
112 	//     < RUSS_PFXXVII_III_metadata_line_6_____SIBUR_FINANCE_20251101 >									
113 	//        < VvRL8j1J54ShMt6a4wFwkN376fwuF6D8fVUN5gMClHfXKfB9rfi2e2G9Gv6y5U7e >									
114 	//        <  u =="0.000000000000000001" : ] 000000141286790.870610000000000000 ; 000000169488397.183643000000000000 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000000000D796271029E68 >									
116 	//     < RUSS_PFXXVII_III_metadata_line_7_____AKRILAT_20251101 >									
117 	//        < 06099O4M89rFc3Y18I3jPm3B0RN9mC98e550Ii2T5D6DfOK6X677kX5M657TKW58 >									
118 	//        <  u =="0.000000000000000001" : ] 000000169488397.183643000000000000 ; 000000189760396.757534000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000001029E681218D28 >									
120 	//     < RUSS_PFXXVII_III_metadata_line_8_____SINOPEC_RUBBER_20251101 >									
121 	//        < sRexl8790WW7Qne9aAS6ykH2rOO3xjdGrS3Zz1Hj4J2E79Rz56nIONNdRgL2E8zK >									
122 	//        <  u =="0.000000000000000001" : ] 000000189760396.757534000000000000 ; 000000211879870.088352000000000000 ] >									
123 	//        < 0x000000000000000000000000000000000000000000000000001218D281434D93 >									
124 	//     < RUSS_PFXXVII_III_metadata_line_9_____TOBOLSK_NEFTEKHIM_20251101 >									
125 	//        < uUaCHzAanhCGpVEulGL8j5dfqx8cKTWk0fC54tIp3RbJt6C4550200TJrf0PVbC8 >									
126 	//        <  u =="0.000000000000000001" : ] 000000211879870.088352000000000000 ; 000000230991434.698647000000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000001434D931607707 >									
128 	//     < RUSS_PFXXVII_III_metadata_line_10_____SIBUR_PETF_20251101 >									
129 	//        < ILfxHP52Tu2Z0Ss8yzqz40W1bt0eP622s2DE84HD56NQt0jK4DE3ZI2Sn7QvmuZo >									
130 	//        <  u =="0.000000000000000001" : ] 000000230991434.698647000000000000 ; 000000250016065.875906000000000000 ] >									
131 	//        < 0x00000000000000000000000000000000000000000000000000160770717D7E87 >									
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
174 	//     < RUSS_PFXXVII_III_metadata_line_11_____MURAVLENKOVSKY_GAS_PROCESS_PLANT_20251101 >									
175 	//        < LlG8agWy654eY75qpJaXNc4sk1x4w4q2iifooU11lvaC41QNOQv26hxai6hn702D >									
176 	//        <  u =="0.000000000000000001" : ] 000000250016065.875906000000000000 ; 000000276853204.454416000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000017D7E871A671C8 >									
178 	//     < RUSS_PFXXVII_III_metadata_line_12_____OOO_IT_SERVICE_20251101 >									
179 	//        < Un1IrH72dj89Dpbt1H3snkoEQvz6t89f6H3osJldnSofEH4Gy09YYD9yj40i46W2 >									
180 	//        <  u =="0.000000000000000001" : ] 000000276853204.454416000000000000 ; 000000308097671.529702000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000001A671C81D61EA7 >									
182 	//     < RUSS_PFXXVII_III_metadata_line_13_____ZAO_MIRACLE_20251101 >									
183 	//        < mdLcG2O97lq9Rwg05N8wSeN23H6x78l2eM6vKXK0yhc3riFEDG8MDZR0KrI3840y >									
184 	//        <  u =="0.000000000000000001" : ] 000000308097671.529702000000000000 ; 000000328699161.425356000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001D61EA71F58E1C >									
186 	//     < RUSS_PFXXVII_III_metadata_line_14_____NOVATEK_POLYMER_20251101 >									
187 	//        < YUWk3Ov401i0Mi3l0iz28yn2dTK99d35aBk5Tw5kGKi65HYHuxo80M6mrLw959AS >									
188 	//        <  u =="0.000000000000000001" : ] 000000328699161.425356000000000000 ; 000000348041806.004110000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000001F58E1C21311D5 >									
190 	//     < RUSS_PFXXVII_III_metadata_line_15_____SOUTHWEST_GAS_PIPELINES_20251101 >									
191 	//        < SJZI1D8qt2dZAYD7XA06OvkSBHT78ou023KgVf4Zn4gA23HQ7nJNRUaw9Nsa5v1a >									
192 	//        <  u =="0.000000000000000001" : ] 000000348041806.004110000000000000 ; 000000370247223.437212000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000021311D5234F3D2 >									
194 	//     < RUSS_PFXXVII_III_metadata_line_16_____YUGRAGAZPERERABOTKA_20251101 >									
195 	//        < NvEK4sOs6Wi3D140C235XEqhV5h35ldCPXN7354wPW6n1D3G0271A6M14UnLi1oz >									
196 	//        <  u =="0.000000000000000001" : ] 000000370247223.437212000000000000 ; 000000401413287.535144000000000000 ] >									
197 	//        < 0x00000000000000000000000000000000000000000000000000234F3D22648211 >									
198 	//     < RUSS_PFXXVII_III_metadata_line_17_____TOMSKNEFTEKHIM_20251101 >									
199 	//        < fzxe4jZP5040LxzqL0SFcJtHr0ruUex4V9crm4WTd6qmogy52GYKx357Q12k7211 >									
200 	//        <  u =="0.000000000000000001" : ] 000000401413287.535144000000000000 ; 000000428088173.191310000000000000 ] >									
201 	//        < 0x00000000000000000000000000000000000000000000000000264821128D35F1 >									
202 	//     < RUSS_PFXXVII_III_metadata_line_18_____BALTIC_LNG_20251101 >									
203 	//        < u346tmjsI2q7d8zU6k10UH59fJHFi7o8q0tPGh31fWoYyUo7J6QN6eIrX71fgCM8 >									
204 	//        <  u =="0.000000000000000001" : ] 000000428088173.191310000000000000 ; 000000451470165.029559000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000028D35F12B0E389 >									
206 	//     < RUSS_PFXXVII_III_metadata_line_19_____SIBUR_INT_GMBH_20251101 >									
207 	//        < Z91ucZ9sIb7I64X2rULF763J8vhVYkItC3MczvO1nq0r3Ao8WozB8hvgtPgkVHYc >									
208 	//        <  u =="0.000000000000000001" : ] 000000451470165.029559000000000000 ; 000000486534331.139315000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000002B0E3892E66479 >									
210 	//     < RUSS_PFXXVII_III_metadata_line_20_____TOBOL_SK_POLIMER_20251101 >									
211 	//        < 4l7dlr4jEY5UH06RE8245viJI19MKivue2tlv1eGI823DqAr2Q27r66YFMH57Ni0 >									
212 	//        <  u =="0.000000000000000001" : ] 000000486534331.139315000000000000 ; 000000505918446.675376000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000002E66479303F865 >									
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
256 	//     < RUSS_PFXXVII_III_metadata_line_21_____SIBUR_SCIENT_RD_INSTITUTE_GAS_PROCESS_20251101 >									
257 	//        < 9ngRHUD6Om725FmjbuCdCx5wl50cH0GY7jKJ3Bb6Pv4yN7ynIp3VF77949Xl82cF >									
258 	//        <  u =="0.000000000000000001" : ] 000000505918446.675376000000000000 ; 000000524412861.051729000000000000 ] >									
259 	//        < 0x00000000000000000000000000000000000000000000000000303F86532030C6 >									
260 	//     < RUSS_PFXXVII_III_metadata_line_22_____ZAPSIBNEFTEKHIM_20251101 >									
261 	//        < 5Gl6Xv0auAjBYVHzfg5bj6DmJsU4U2VvqecB456g5uS1Pm9YG19hJard6MQI82p1 >									
262 	//        <  u =="0.000000000000000001" : ] 000000524412861.051729000000000000 ; 000000544545261.489014000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000032030C633EE8FE >									
264 	//     < RUSS_PFXXVII_III_metadata_line_23_____RUSVINYL_20251101 >									
265 	//        < hLUWiQ6418t0jw81H0YPRk8zo3msgNpVVItvTS8KUnfYs8nw45KI5qSVb703yX0s >									
266 	//        <  u =="0.000000000000000001" : ] 000000544545261.489014000000000000 ; 000000578777289.442239000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000033EE8FE37324E1 >									
268 	//     < RUSS_PFXXVII_III_metadata_line_24_____SIBUR_SECURITIES_LIMITED_20251101 >									
269 	//        < 0rN5SBaiVP2Ep1T1Zl6sJvXNBy5L5CWZzOW5y6UeMYIRt7a60Yv7xJI4Z0Ye42V2 >									
270 	//        <  u =="0.000000000000000001" : ] 000000578777289.442239000000000000 ; 000000611656542.684196000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000037324E13A55056 >									
272 	//     < RUSS_PFXXVII_III_metadata_line_25_____ACRYLATE_20251101 >									
273 	//        < W5wvcFE0WoC089EphT57AX5c953htQvTW8Gs26J5t3B9K3LNtVOMp9B7nDXgQ9is >									
274 	//        <  u =="0.000000000000000001" : ] 000000611656542.684196000000000000 ; 000000630474161.311568000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000003A550563C206F8 >									
276 	//     < RUSS_PFXXVII_III_metadata_line_26_____BIAXPLEN_20251101 >									
277 	//        < 7kUKF4Tztk5WF3IBu5y2lN8cKiw0kwaYb6mw7j07W9Vjk9kn021JTx918MdgalyV >									
278 	//        <  u =="0.000000000000000001" : ] 000000630474161.311568000000000000 ; 000000648922568.247624000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000003C206F83DE2D61 >									
280 	//     < RUSS_PFXXVII_III_metadata_line_27_____PORTENERGO_20251101 >									
281 	//        < C6x8ua8814dFZYjq1p1H3bQT8luM7197z5Knka9J9W18IKK3vhacdCUgHSpZW5Ul >									
282 	//        <  u =="0.000000000000000001" : ] 000000648922568.247624000000000000 ; 000000672299082.168602000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000003DE2D61401D8D4 >									
284 	//     < RUSS_PFXXVII_III_metadata_line_28_____POLIEF_20251101 >									
285 	//        < kRH917fvJA6IFcDo8O66009ehHvIR7S5199sD05APZ6HWgv9h7JO4tZW5ojC8431 >									
286 	//        <  u =="0.000000000000000001" : ] 000000672299082.168602000000000000 ; 000000693947836.576159000000000000 ] >									
287 	//        < 0x00000000000000000000000000000000000000000000000000401D8D4422E160 >									
288 	//     < RUSS_PFXXVII_III_metadata_line_29_____RUSPAV_20251101 >									
289 	//        < KM122KB5pSgg15XY8mr516J48WVEWn5bzk1FGeA6cVLkafU0LYAjD91EN2x8Ogv1 >									
290 	//        <  u =="0.000000000000000001" : ] 000000693947836.576159000000000000 ; 000000723384499.214861000000000000 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000000000422E16044FCC12 >									
292 	//     < RUSS_PFXXVII_III_metadata_line_30_____NEFTEKHIMIA_20251101 >									
293 	//        < 6s4xSoXvauOTV7FfZX8H2jK1wH1CQL38iEbRHQ3J6247mkZ04z9h9XUOF9f4rGqG >									
294 	//        <  u =="0.000000000000000001" : ] 000000723384499.214861000000000000 ; 000000754008020.109827000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000044FCC1247E8662 >									
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
338 	//     < RUSS_PFXXVII_III_metadata_line_31_____OTECHESTVENNYE_POLIMERY_20251101 >									
339 	//        < CMC7LnHohGK9QZ2lsd9Z6t7T9MXa4FUM0ekIBR10JpRPOAa3RfzPFbg5BxLjKffx >									
340 	//        <  u =="0.000000000000000001" : ] 000000754008020.109827000000000000 ; 000000773341699.712229000000000000 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000000000047E866249C069A >									
342 	//     < RUSS_PFXXVII_III_metadata_line_32_____SIBUR_TRANS_20251101 >									
343 	//        < k1CLuYuOoRWb96pAz71zg5pF9L8m4980W7xzzDp28GGib8Syv2ur9Ay07rB5tg53 >									
344 	//        <  u =="0.000000000000000001" : ] 000000773341699.712229000000000000 ; 000000793123459.445885000000000000 ] >									
345 	//        < 0x0000000000000000000000000000000000000000000000000049C069A4BA35DA >									
346 	//     < RUSS_PFXXVII_III_metadata_line_33_____TOGLIATTIKAUCHUK_20251101 >									
347 	//        < MxQ2FHq0vnnnGd7JSxTOQnBr8qFjsW0M3pIYw1HIS9Yrw2bnP6UuRvn2H5hoMZWN >									
348 	//        <  u =="0.000000000000000001" : ] 000000793123459.445885000000000000 ; 000000815544296.063335000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000004BA35DA4DC6BFE >									
350 	//     < RUSS_PFXXVII_III_metadata_line_34_____NPP_NEFTEKHIMIYA_OOO_20251101 >									
351 	//        < 0Fj641Pv5gS426oY32QEXU9UnlmTKOVJPHe61b9X01Z1t6M6xMw4vm81Bq7bXCCo >									
352 	//        <  u =="0.000000000000000001" : ] 000000815544296.063335000000000000 ; 000000837301744.448902000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000004DC6BFE4FD9EFE >									
354 	//     < RUSS_PFXXVII_III_metadata_line_35_____SIBUR_KHIMPROM_20251101 >									
355 	//        < 87MF9R2TA78Ynagozb3fPgW1Ohou340KnN5UfKP1n53nD92VT5x2xm4i2H5Rfwh1 >									
356 	//        <  u =="0.000000000000000001" : ] 000000837301744.448902000000000000 ; 000000856370921.552576000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000004FD9EFE51AB7E4 >									
358 	//     < RUSS_PFXXVII_III_metadata_line_36_____SIBUR_VOLZHSKY_20251101 >									
359 	//        < qwi9ICd3STk69mAm5A1sO0ay43Z4Ks6N854hm271eLdZb4A9NKqCnk8hgZyt9rK1 >									
360 	//        <  u =="0.000000000000000001" : ] 000000856370921.552576000000000000 ; 000000880639253.133402000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000051AB7E453FBFB5 >									
362 	//     < RUSS_PFXXVII_III_metadata_line_37_____VORONEZHSINTEZKAUCHUK_20251101 >									
363 	//        < 9768k3gYpdiO37NY9CWq6EPr09njRf9d6wp4bFcdkI48R9J6v5jG92Ll5iN47gpg >									
364 	//        <  u =="0.000000000000000001" : ] 000000880639253.133402000000000000 ; 000000908154021.721867000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000053FBFB5569BBAA >									
366 	//     < RUSS_PFXXVII_III_metadata_line_38_____INFO_TECH_SERVICE_CO_20251101 >									
367 	//        < 16lAYvgO5zlT6ScXHgXgMz3CB8XMe4LIb3N932W62K52v4B4SA5W182Qr361yDA2 >									
368 	//        <  u =="0.000000000000000001" : ] 000000908154021.721867000000000000 ; 000000932915513.188169000000000000 ] >									
369 	//        < 0x00000000000000000000000000000000000000000000000000569BBAA58F841F >									
370 	//     < RUSS_PFXXVII_III_metadata_line_39_____LNG_NOVAENGINEERING_20251101 >									
371 	//        < DI74eCN58o3qzEh8f44Em7Bx877H0agQep78dl1YZ4380pS3D3YuUV8Oq1nb7Sc9 >									
372 	//        <  u =="0.000000000000000001" : ] 000000932915513.188169000000000000 ; 000000955113558.609519000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000058F841F5B1633C >									
374 	//     < RUSS_PFXXVII_III_metadata_line_40_____SIBGAZPOLIMER_20251101 >									
375 	//        < 6068mMjiXQ8iGJDgo08K20754yI5EQ65TQp0KEQkneY1Wx9yN9hhBICSrzVW6os0 >									
376 	//        <  u =="0.000000000000000001" : ] 000000955113558.609519000000000000 ; 000000977766545.891770000000000000 ] >									
377 	//        < 0x000000000000000000000000000000000000000000000000005B1633C5D3F40F >									
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