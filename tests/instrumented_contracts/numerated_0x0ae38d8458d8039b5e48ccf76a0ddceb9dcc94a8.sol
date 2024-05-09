1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXXIV_II_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXXIV_II_883		"	;
8 		string	public		symbol =	"	RUSS_PFXXIV_II_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		792519793159009000000000000					;	
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
92 	//     < RUSS_PFXXIV_II_metadata_line_1_____ALFASTRAKHOVANIE_20231101 >									
93 	//        < Oax03K75o9I283yReBg1f53WnB24i0rW0H5P109tW3Z7ciW0T357uMgxjQ2q29E8 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000016417329.998510900000000000 ] >									
95 	//        < 0x0000000000000000000000000000000000000000000000000000000000190D05 >									
96 	//     < RUSS_PFXXIV_II_metadata_line_2_____ALFA_DAO_20231101 >									
97 	//        < n9wa4e1E0LByq49604edmTMy3U2xetN84QP6u06g3jw097T2L81BC2p091hT1kfE >									
98 	//        <  u =="0.000000000000000001" : ] 000000016417329.998510900000000000 ; 000000038616667.535204200000000000 ] >									
99 	//        < 0x0000000000000000000000000000000000000000000000000000190D053AECA3 >									
100 	//     < RUSS_PFXXIV_II_metadata_line_3_____ALFA_DAOPI_20231101 >									
101 	//        < GWwYmC7V4EP3HXEM3fWU7O2Z7BFt13rRcnFjXEH8ysmPV3NiqG69FOC1e2gAsKGM >									
102 	//        <  u =="0.000000000000000001" : ] 000000038616667.535204200000000000 ; 000000063346097.625443800000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000003AECA360A892 >									
104 	//     < RUSS_PFXXIV_II_metadata_line_4_____ALFA_DAC_20231101 >									
105 	//        < LgUi59zHo4Jq74tT3xWAq1v9CYu85y7r9s39iKNx87vIv236HRtNLSb0Y8o1StOp >									
106 	//        <  u =="0.000000000000000001" : ] 000000063346097.625443800000000000 ; 000000088022201.296572500000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000060A892864FAC >									
108 	//     < RUSS_PFXXIV_II_metadata_line_5_____ALFA_BIMI_20231101 >									
109 	//        < 7TD4tpXzA8Em0ry5AROWoNkJ3kd6y9S9XUD4As1dbLiv2UEAmtPmOFuTciyZ2U3p >									
110 	//        <  u =="0.000000000000000001" : ] 000000088022201.296572500000000000 ; 000000111175552.412070000000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000864FACA9A3F3 >									
112 	//     < RUSS_PFXXIV_II_metadata_line_6_____SMO_SIBERIA_20231101 >									
113 	//        < l4a48d9tk28fn586ReK3j6X8OIdFkB9hTgXUw0iN9fX1iWQzZ6EFA986OfeJIyFx >									
114 	//        <  u =="0.000000000000000001" : ] 000000111175552.412070000000000000 ; 000000127363897.025312000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000A9A3F3C25786 >									
116 	//     < RUSS_PFXXIV_II_metadata_line_7_____SIBERIA_DAO_20231101 >									
117 	//        < QFW7RSxaC125GKyPu4XD463wvVG7I9wUT2F27W3EDkg0S31UeHwFFB7870pBA8Qu >									
118 	//        <  u =="0.000000000000000001" : ] 000000127363897.025312000000000000 ; 000000148540759.931991000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000C25786E2A7BC >									
120 	//     < RUSS_PFXXIV_II_metadata_line_8_____SIBERIA_DAOPI_20231101 >									
121 	//        < 0XhIbP0f8CpYwXre4JFe6ZR6NJ2dVmcjMX91nNf0Vbbv22Vo97DPSm9ZcskauhPL >									
122 	//        <  u =="0.000000000000000001" : ] 000000148540759.931991000000000000 ; 000000165051164.300834000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000E2A7BCFBD91C >									
124 	//     < RUSS_PFXXIV_II_metadata_line_9_____SIBERIA_DAC_20231101 >									
125 	//        < qq4lX1PJVX9F5cD17uG521xRiX9C0loO2lrj2H6JDIB9H75t58opwmJoaQ10NM89 >									
126 	//        <  u =="0.000000000000000001" : ] 000000165051164.300834000000000000 ; 000000182408370.132553000000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000000FBD91C1165545 >									
128 	//     < RUSS_PFXXIV_II_metadata_line_10_____SIBERIA_BIMI_20231101 >									
129 	//        < 54ao2zTb59a0oEm2nnb5o9GP4T9Gg21X4V6K2f5l8A5VNLhNv8FG350Mzf7x5oZ3 >									
130 	//        <  u =="0.000000000000000001" : ] 000000182408370.132553000000000000 ; 000000202861473.420384000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000011655451358AC3 >									
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
174 	//     < RUSS_PFXXIV_II_metadata_line_11_____ALFASTRAKHOVANIE_LIFE_20231101 >									
175 	//        < TVikt5HI60ILr767596T9iZ0ht7VGOlRry8tH0jbGrDYndUT0C2cmfJ3B2e7Hj22 >									
176 	//        <  u =="0.000000000000000001" : ] 000000202861473.420384000000000000 ; 000000221011002.002595000000000000 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000000001358AC31513C6C >									
178 	//     < RUSS_PFXXIV_II_metadata_line_12_____ALFA_LIFE_DAO_20231101 >									
179 	//        < bp6Rq8mY445d7hX2430YYooYiNmxE1H416XTiVeC56h8DvbszJSRsJPYm3hcXQrv >									
180 	//        <  u =="0.000000000000000001" : ] 000000221011002.002595000000000000 ; 000000237634719.103105000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000001513C6C16A9A10 >									
182 	//     < RUSS_PFXXIV_II_metadata_line_13_____ALFA_LIFE_DAOPI_20231101 >									
183 	//        < z3s4MMcW2mR0t0grDoZd4D9VH3L073O2F9znRs52as395ftqO15pT51R19qqGKpm >									
184 	//        <  u =="0.000000000000000001" : ] 000000237634719.103105000000000000 ; 000000256472444.292328000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000016A9A10187588C >									
186 	//     < RUSS_PFXXIV_II_metadata_line_14_____ALFA_LIFE_DAC_20231101 >									
187 	//        < 7fc9MKZuI6Je5WF8Y2zg7021xYpFGcE793k4472Cfxw66XSp1sor51hdGmsnwaCk >									
188 	//        <  u =="0.000000000000000001" : ] 000000256472444.292328000000000000 ; 000000271917447.209354000000000000 ] >									
189 	//        < 0x00000000000000000000000000000000000000000000000000187588C19EE9C1 >									
190 	//     < RUSS_PFXXIV_II_metadata_line_15_____ALFA_LIFE_BIMI_20231101 >									
191 	//        < 3ncCbVcN4z59TDikMKzTIxa4Xu0k4vMQ27e471xoFdnw9OetPxbWStixgxr438Xw >									
192 	//        <  u =="0.000000000000000001" : ] 000000271917447.209354000000000000 ; 000000294372108.734802000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000019EE9C11C12D1B >									
194 	//     < RUSS_PFXXIV_II_metadata_line_16_____ALFASTRAKHOVANIE_AVERS_20231101 >									
195 	//        < aG78Jp3B9Hxw0k1f9x35cGI45F21dSP61za4HeHGO9D8w1lMFFL8Az6vcy7IkvTP >									
196 	//        <  u =="0.000000000000000001" : ] 000000294372108.734802000000000000 ; 000000316364607.375739000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000001C12D1B1E2BBED >									
198 	//     < RUSS_PFXXIV_II_metadata_line_17_____AVERS_DAO_20231101 >									
199 	//        < 47f9DFtZreMqCh4l7N0ITIMvteF7I3So8rm22qCpv3m2Fq9mD4Y3HtO1g9DV084F >									
200 	//        <  u =="0.000000000000000001" : ] 000000316364607.375739000000000000 ; 000000334719915.326089000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000001E2BBED1FEBDF8 >									
202 	//     < RUSS_PFXXIV_II_metadata_line_18_____AVERS_DAOPI_20231101 >									
203 	//        < L5F05N59Ocn1ZIuvfG86r9lNzjynz95OE23f39OAVO7K8x1C3yhex7q22Xb6M4pd >									
204 	//        <  u =="0.000000000000000001" : ] 000000334719915.326089000000000000 ; 000000354918755.561358000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000001FEBDF821D9024 >									
206 	//     < RUSS_PFXXIV_II_metadata_line_19_____AVERS_DAC_20231101 >									
207 	//        < cveep350z7x88W944CSlT2BYx95DVycH0421ek1B0IAsU1TVoT9YJNRtO9E6gpg6 >									
208 	//        <  u =="0.000000000000000001" : ] 000000354918755.561358000000000000 ; 000000372292478.536944000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000000021D902423812C0 >									
210 	//     < RUSS_PFXXIV_II_metadata_line_20_____AVERS_BIMI_20231101 >									
211 	//        < W1UrK91iJeM0xhKCNzZ2WG4xL0VFOb416DSkAOeUjjmM281YQ5zZ21D4105h7f88 >									
212 	//        <  u =="0.000000000000000001" : ] 000000372292478.536944000000000000 ; 000000391535625.832875000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000023812C02556F9B >									
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
256 	//     < RUSS_PFXXIV_II_metadata_line_21_____ALFASTRAKHOVANIE_PLC_20231101 >									
257 	//        < vpuV7Y7GIioBPajBzTS5ie3W9E6o0f3OS3O59ZG1lbJJ22X2wWaLDZFGMbly6652 >									
258 	//        <  u =="0.000000000000000001" : ] 000000391535625.832875000000000000 ; 000000413732501.131512000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000002556F9B2774E42 >									
260 	//     < RUSS_PFXXIV_II_metadata_line_22_____ALFASTRA_DAO_20231101 >									
261 	//        < 008X74owq53Nox4PAS1ufxF5V898fj90vOaX8tqqHA1E30pJOVA0R6YQ986fVkFr >									
262 	//        <  u =="0.000000000000000001" : ] 000000413732501.131512000000000000 ; 000000435565289.492534000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000002774E422989EB1 >									
264 	//     < RUSS_PFXXIV_II_metadata_line_23_____ALFASTRA_DAOPI_20231101 >									
265 	//        < t7uxMwtHmnJVGkr8IciuUU0pVQ7yZ7A7m4xgUVDs2420fmn0x6xVO7LrlG00NxM5 >									
266 	//        <  u =="0.000000000000000001" : ] 000000435565289.492534000000000000 ; 000000458750398.098953000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000002989EB12BBFF60 >									
268 	//     < RUSS_PFXXIV_II_metadata_line_24_____ALFASTRA_DAC_20231101 >									
269 	//        < z9qEUe1V7aC7Jf4C8m49lG1T3gyYV84zg4dJA582yPIturZGOZDKi0763hGTzFCV >									
270 	//        <  u =="0.000000000000000001" : ] 000000458750398.098953000000000000 ; 000000477870797.617751000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000002BBFF602D92C48 >									
272 	//     < RUSS_PFXXIV_II_metadata_line_25_____ALFASTRA_BIMI_20231101 >									
273 	//        < MXSrqJAEIjH9yudwmEuy6gW18PP4B8Dh796JZc4bN8b6Pt65C4101688pY80zR35 >									
274 	//        <  u =="0.000000000000000001" : ] 000000477870797.617751000000000000 ; 000000496481679.660000000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002D92C482F59228 >									
276 	//     < RUSS_PFXXIV_II_metadata_line_26_____MEDITSINSKAYA_STRAKHOVAYA_KOMP_VIRMED_20231101 >									
277 	//        < jTNBOSWx4IydHeG40Iw27mvwx7UbqOtFFv01uQI4wr94f9a4P7ncAsZ2hpX5Io68 >									
278 	//        <  u =="0.000000000000000001" : ] 000000496481679.660000000000000000 ; 000000517178310.921082000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000002F5922831526C7 >									
280 	//     < RUSS_PFXXIV_II_metadata_line_27_____VIRMED_DAO_20231101 >									
281 	//        < 66S5oDc0H633XBZ3Z64oR24ShGKv8yP8sPO1kFa6fUMzXsarblVRl3XRW4Vqj17E >									
282 	//        <  u =="0.000000000000000001" : ] 000000517178310.921082000000000000 ; 000000540706971.570198000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000031526C73390DA9 >									
284 	//     < RUSS_PFXXIV_II_metadata_line_28_____VIRMED_DAOPI_20231101 >									
285 	//        < Qo7xNgUb8NB0lphiH6HW7c9ykAb6E83WZ7HOl3iTzU2S56Inpx5we8pxa0K3N1q1 >									
286 	//        <  u =="0.000000000000000001" : ] 000000540706971.570198000000000000 ; 000000565496131.143225000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000003390DA935EE0ED >									
288 	//     < RUSS_PFXXIV_II_metadata_line_29_____VIRMED_DAC_20231101 >									
289 	//        < eS3K0QY86NGg42Z0G1Kw9NihRp4RVjTg88LV2bm6KpAsNxtVJQZRBZs676l9B0dw >									
290 	//        <  u =="0.000000000000000001" : ] 000000565496131.143225000000000000 ; 000000582945235.705385000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000035EE0ED37980FC >									
292 	//     < RUSS_PFXXIV_II_metadata_line_30_____VIRMED_BIMI_20231101 >									
293 	//        < Vn8ecaGwWW6NF7S8ec4GE9yWI2QLFd6Fg8a0gW1CJYNr3c9ilsL9jpvf8OH81wy9 >									
294 	//        <  u =="0.000000000000000001" : ] 000000582945235.705385000000000000 ; 000000600788952.074354000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000037980FC394BB2F >									
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
338 	//     < RUSS_PFXXIV_II_metadata_line_31_____MSK_ASSTRA_20231101 >									
339 	//        < B4V00YiMano5S4fL9PUHq66D76010iwyFF9y9Lg30L7I2Q8e340g6pRuWj8sT70r >									
340 	//        <  u =="0.000000000000000001" : ] 000000600788952.074354000000000000 ; 000000623817336.095239000000000000 ] >									
341 	//        < 0x00000000000000000000000000000000000000000000000000394BB2F3B7DEA6 >									
342 	//     < RUSS_PFXXIV_II_metadata_line_32_____ASSTRA_DAO_20231101 >									
343 	//        < 70B1SHXgEjyfvu20rAL0l9iaSUQv4222YRiHSUu1fAUbCC8iUjOG7PYeba8mA7V4 >									
344 	//        <  u =="0.000000000000000001" : ] 000000623817336.095239000000000000 ; 000000644171965.656131000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000003B7DEA63D6EDAD >									
346 	//     < RUSS_PFXXIV_II_metadata_line_33_____ASSTRA_DAOPI_20231101 >									
347 	//        < kbfK67fwPp641z8CiXoZNbv63WcBb16MC99O63u5r3mo0IJIiZWN4ZW3or29iB5O >									
348 	//        <  u =="0.000000000000000001" : ] 000000644171965.656131000000000000 ; 000000661997972.263010000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000003D6EDAD3F220F5 >									
350 	//     < RUSS_PFXXIV_II_metadata_line_34_____ASSTRA_DAC_20231101 >									
351 	//        < kk3lV243T1X31Pg9oJvOCIj6l1M9UU3c22m2qd7cnS0xm160QXzVb3NmX1I79K1j >									
352 	//        <  u =="0.000000000000000001" : ] 000000661997972.263010000000000000 ; 000000678217639.871391000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000003F220F540AE0C4 >									
354 	//     < RUSS_PFXXIV_II_metadata_line_35_____ASSTRA_BIMI_20231101 >									
355 	//        < jzU5D4YPi7SWZd7VWk8GpOl4ZAUhgZrz7kGihCC56A7e1GQDIwqyuC1c1dKU5VL4 >									
356 	//        <  u =="0.000000000000000001" : ] 000000678217639.871391000000000000 ; 000000695954696.364195000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000040AE0C4425F14E >									
358 	//     < RUSS_PFXXIV_II_metadata_line_36_____AVICOS_AFES_INSURANCE_GROUP_20231101 >									
359 	//        < ao85q7Mz3e6w0FBtKSR0QheX96QHYN2CjC4P51IPlHW2ZD12eT67InZsmo5305Vc >									
360 	//        <  u =="0.000000000000000001" : ] 000000695954696.364195000000000000 ; 000000712165778.600852000000000000 ] >									
361 	//        < 0x00000000000000000000000000000000000000000000000000425F14E43EADC2 >									
362 	//     < RUSS_PFXXIV_II_metadata_line_37_____AVICOS_DAO_20231101 >									
363 	//        < Pq1gIGk9JIn5Vr7FzirC1EaSj1ha9a8h3nLQL5svkT7ViAqW4mom6yO1Y767Cn60 >									
364 	//        <  u =="0.000000000000000001" : ] 000000712165778.600852000000000000 ; 000000735779088.336977000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000043EADC2462B5B5 >									
366 	//     < RUSS_PFXXIV_II_metadata_line_38_____AVICOS_DAOPI_20231101 >									
367 	//        < 5Y7qH2uxndT3248TB7d940uOYxSiY4rh21sqt5okSDRxGDRmglhb38620lSfu55h >									
368 	//        <  u =="0.000000000000000001" : ] 000000735779088.336977000000000000 ; 000000755794716.555455000000000000 ] >									
369 	//        < 0x00000000000000000000000000000000000000000000000000462B5B54814050 >									
370 	//     < RUSS_PFXXIV_II_metadata_line_39_____AVICOS_DAC_20231101 >									
371 	//        < mY4mKFI62v1M0BF0Z62GW958074189Zurog5e65W474fIFd7F34mCbJbL6423sHQ >									
372 	//        <  u =="0.000000000000000001" : ] 000000755794716.555455000000000000 ; 000000772732021.282954000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000481405049B1872 >									
374 	//     < RUSS_PFXXIV_II_metadata_line_40_____AVICOS_BIMI_20231101 >									
375 	//        < 0SnAnD5oz91x46C9m6jNxc2WYBLFjCLl0222wED82oMYbHh1q3qFOWwh453pxRF1 >									
376 	//        <  u =="0.000000000000000001" : ] 000000772732021.282954000000000000 ; 000000792519793.159009000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000049B18724B94A0B >									
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