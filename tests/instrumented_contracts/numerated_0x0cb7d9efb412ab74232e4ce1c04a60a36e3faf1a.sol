1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXI_II_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXI_II_883		"	;
8 		string	public		symbol =	"	RUSS_PFXI_II_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		781414319750896000000000000					;	
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
92 	//     < RUSS_PFXI_II_metadata_line_1_____STRAKHOVOI_SINDIKAT_20231101 >									
93 	//        < k7s29F1Ym80O31V24GyL5aU3LhqoXf17423Otc7x7XZaE1SC2e7808rHZi36p9Wk >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000020737465.608736500000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000001FA493 >									
96 	//     < RUSS_PFXI_II_metadata_line_2_____MIKA_RG_20231101 >									
97 	//        < qppCpLl416AAlx1MtkH49s5phN34Pza5h8SZeM8EVP2n4en0QTBENgtM04jHa53D >									
98 	//        <  u =="0.000000000000000001" : ] 000000020737465.608736500000000000 ; 000000039416205.711292700000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000001FA4933C24F5 >									
100 	//     < RUSS_PFXI_II_metadata_line_3_____RESO_FINANCIAL_MARKETS_20231101 >									
101 	//        < p8M3mb96HQzxl9SESanPSm9q255TZ5GoyIxD5k55WCL1B3mnG6p0h7m8o6CTo83H >									
102 	//        <  u =="0.000000000000000001" : ] 000000039416205.711292700000000000 ; 000000061776491.138781200000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000003C24F55E4371 >									
104 	//     < RUSS_PFXI_II_metadata_line_4_____LIPETSK_INSURANCE_CHANCE_20231101 >									
105 	//        < DhMMth64maHJ476M5135x32bLi383Ow6Ze279O7m2c1mto9d5s8soCVqvj4cU800 >									
106 	//        <  u =="0.000000000000000001" : ] 000000061776491.138781200000000000 ; 000000083906265.293335800000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000005E43718007E3 >									
108 	//     < RUSS_PFXI_II_metadata_line_5_____ALVENA_RESO_GROUP_20231101 >									
109 	//        < lsZ15W2OLZ8sDTmVL23H72xPuYTiz3CDjfBQ6X2N6jiRV7cjqDI76Uxfe5v0Op23 >									
110 	//        <  u =="0.000000000000000001" : ] 000000083906265.293335800000000000 ; 000000099532861.357230000000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000008007E397E006 >									
112 	//     < RUSS_PFXI_II_metadata_line_6_____NADEZHNAYA_LIFE_INSURANCE_20231101 >									
113 	//        < 2nzZ4dg3V4pFOaRYH3jcV9OQwZDUG9J2T993TsnzX5m6C8VKf986Mo3Q849Y3MtS >									
114 	//        <  u =="0.000000000000000001" : ] 000000099532861.357230000000000000 ; 000000118223618.517885000000000000 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000000000097E006B4651A >									
116 	//     < RUSS_PFXI_II_metadata_line_7_____MSK_URALSIB_20231101 >									
117 	//        < A2m0yoeZdLI9oAaMGWvn0RWg3rTVfITu87w5h1HAgX52P4XKYmupxoHF4S9u6hQc >									
118 	//        <  u =="0.000000000000000001" : ] 000000118223618.517885000000000000 ; 000000137502964.987871000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000B4651AD1D018 >									
120 	//     < RUSS_PFXI_II_metadata_line_8_____SMO_SIBERIA_20231101 >									
121 	//        < qotwu46ZuTW38c2EPCS82YeJSOZ7L7Yq1MVUA7k5gmS9025Z72jNwVkd1T7P24Cm >									
122 	//        <  u =="0.000000000000000001" : ] 000000137502964.987871000000000000 ; 000000160020254.292031000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000D1D018F42BE9 >									
124 	//     < RUSS_PFXI_II_metadata_line_9_____ALFASTRAKHOVANIE_LIFE_20231101 >									
125 	//        < 4KzWU1fe5m73ydcCRMP39Nq7WR0Pl9e3sI160A5PGjI8ck3NMfPr6YpB5at39Wz0 >									
126 	//        <  u =="0.000000000000000001" : ] 000000160020254.292031000000000000 ; 000000179474302.898036000000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000000F42BE9111DB26 >									
128 	//     < RUSS_PFXI_II_metadata_line_10_____AVERS_OOO_20231101 >									
129 	//        < d710AzTP2qxxA65RnXjG9z1q78pj5L072Mgy7M6ZJFu5C02fCTe2Ns5WJ692RM1h >									
130 	//        <  u =="0.000000000000000001" : ] 000000179474302.898036000000000000 ; 000000202953484.919966000000000000 ] >									
131 	//        < 0x00000000000000000000000000000000000000000000000000111DB26135AEB4 >									
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
174 	//     < RUSS_PFXI_II_metadata_line_11_____ALFASTRAKHOVANIE_PLC_20231101 >									
175 	//        < Z1r3y3HVHiaV870b1H83y88Mo6ql8sn6M49Q9V7SXWd4O64f4e009y4xMss1PPa8 >									
176 	//        <  u =="0.000000000000000001" : ] 000000202953484.919966000000000000 ; 000000224685295.639775000000000000 ] >									
177 	//        < 0x00000000000000000000000000000000000000000000000000135AEB4156D7B2 >									
178 	//     < RUSS_PFXI_II_metadata_line_12_____MIDITSINSKAYA_STRAKHOVAYA_KOMP_VIRMED_20231101 >									
179 	//        < p0u0HB47tMQ2LwWBH46Ks91k7fCC61Q9A0EjB5zaKbRU7cT9Nrn3d7u461e43Bi6 >									
180 	//        <  u =="0.000000000000000001" : ] 000000224685295.639775000000000000 ; 000000242943063.609943000000000000 ] >									
181 	//        < 0x00000000000000000000000000000000000000000000000000156D7B2172B3A2 >									
182 	//     < RUSS_PFXI_II_metadata_line_13_____MSK_ASSTRA_20231101 >									
183 	//        < 54Nd905B29Y6edd4x18M5zD5u9iY5ptNGXhz8Jg38UccW05iK98Jnla6VFPyMu0o >									
184 	//        <  u =="0.000000000000000001" : ] 000000242943063.609943000000000000 ; 000000259946986.495280000000000000 ] >									
185 	//        < 0x00000000000000000000000000000000000000000000000000172B3A218CA5CB >									
186 	//     < RUSS_PFXI_II_metadata_line_14_____AVICOS_AFES_INSURANCE_20231101 >									
187 	//        < VW5kY50Ak459tE64606KEC5L7v5peNSZT0rVUS77178fK25WbXzl1vMwu9s4a9Av >									
188 	//        <  u =="0.000000000000000001" : ] 000000259946986.495280000000000000 ; 000000278049143.572314000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000018CA5CB1A844F2 >									
190 	//     < RUSS_PFXI_II_metadata_line_15_____RUSSIA_AGRICULTURAL_BANK_20231101 >									
191 	//        < BuH4435zL6Hu6NTrWt80Va3HG5v0l2l6LFu1kQPtMHS60vta00Bh0kaVuFj7P3kj >									
192 	//        <  u =="0.000000000000000001" : ] 000000278049143.572314000000000000 ; 000000299242971.124817000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000001A844F21C89BC9 >									
194 	//     < RUSS_PFXI_II_metadata_line_16_____BELOGLINSKI_ELEVATOR_20231101 >									
195 	//        < TIXEE10dR1TTYF4sEex3WFwypc7zQN9eiw29GJNSLeQn28N3c3ibywJ33P1zY8VW >									
196 	//        <  u =="0.000000000000000001" : ] 000000299242971.124817000000000000 ; 000000318816659.925792000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000001C89BC91E679C2 >									
198 	//     < RUSS_PFXI_II_metadata_line_17_____RSHB_CAPITAL_20231101 >									
199 	//        < 2rpPkFPJos8Hx66eEOyf4f04zpT35F7vNEHiq6sKYM3k7020IC59m1bYsa7v7f58 >									
200 	//        <  u =="0.000000000000000001" : ] 000000318816659.925792000000000000 ; 000000336689058.964772000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000001E679C2201BF2A >									
202 	//     < RUSS_PFXI_II_metadata_line_18_____ALBASHSKIY_ELEVATOR_20231101 >									
203 	//        < uX6OWNhAuQzopKIHEC1S204lORo6uj5tnK6iEHfn6sDw9EbaKXMiYz8h98p8r971 >									
204 	//        <  u =="0.000000000000000001" : ] 000000336689058.964772000000000000 ; 000000353317986.858622000000000000 ] >									
205 	//        < 0x00000000000000000000000000000000000000000000000000201BF2A21B1ED7 >									
206 	//     < RUSS_PFXI_II_metadata_line_19_____AGROTORG_TRADING_CO_20231101 >									
207 	//        < WY0Qh92312YJwPydDiCB1Fx2K0g84u84nL86vKzR8wRLvhKEe36Y2Ei4WqP246m0 >									
208 	//        <  u =="0.000000000000000001" : ] 000000353317986.858622000000000000 ; 000000370502853.379319000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000000021B1ED723557AD >									
210 	//     < RUSS_PFXI_II_metadata_line_20_____HOMIAKOVSKIY_COLD_STORAGE_COMPLEX_20231101 >									
211 	//        < xtTVDX4uhV0tUl357k6I884eV3QZlW4AHXAecj9Ej5C2Z9Hk76k1C39D5yut8S3R >									
212 	//        <  u =="0.000000000000000001" : ] 000000370502853.379319000000000000 ; 000000386862867.806161000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000023557AD24E4E4F >									
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
256 	//     < RUSS_PFXI_II_metadata_line_21_____AGROCREDIT_INFORM_20231101 >									
257 	//        < 7SFGuH09qigNvL7YY12782DpU9c9pnih544PRgkV1AV92piBjtiP9xkUt991T4nM >									
258 	//        <  u =="0.000000000000000001" : ] 000000386862867.806161000000000000 ; 000000409050467.672135000000000000 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000000024E4E4F2702957 >									
260 	//     < RUSS_PFXI_II_metadata_line_22_____LADOSHSKIY_ELEVATOR_20231101 >									
261 	//        < 35ApgQ2FW8TEx1w2E0TJUV9LY9h5QNbi0944WA4u3A7BzkPQXrIl6p9D7TkgnjW6 >									
262 	//        <  u =="0.000000000000000001" : ] 000000409050467.672135000000000000 ; 000000425761986.988834000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000002702957289A947 >									
264 	//     < RUSS_PFXI_II_metadata_line_23_____VELICHKOVSKIY_ELEVATOR_20231101 >									
265 	//        < SwkeZV3F7lU8P07KE130imo57NAJH0tVkYCBeEfRj9P90SNIe87Q6s67w95o5aSU >									
266 	//        <  u =="0.000000000000000001" : ] 000000425761986.988834000000000000 ; 000000443307289.207365000000000000 ] >									
267 	//        < 0x00000000000000000000000000000000000000000000000000289A9472A46EE9 >									
268 	//     < RUSS_PFXI_II_metadata_line_24_____UMANSKIY_ELEVATOR_20231101 >									
269 	//        < R0pow955GJQVWuc04QHq741Te09i1E1tUaL6rxh21xF8hf6br2qloNwI1auS8Spx >									
270 	//        <  u =="0.000000000000000001" : ] 000000443307289.207365000000000000 ; 000000462390827.155040000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000002A46EE92C18D6B >									
272 	//     < RUSS_PFXI_II_metadata_line_25_____MALOROSSIYSKIY_ELEVATOR_20231101 >									
273 	//        < h1vdKx1y945nH6516gy2i99T8tul9wVXP8jtB96XAobS13S4L5uNicHU5JAAudLQ >									
274 	//        <  u =="0.000000000000000001" : ] 000000462390827.155040000000000000 ; 000000482253438.557762000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002C18D6B2DFDC40 >									
276 	//     < RUSS_PFXI_II_metadata_line_26_____ROSSELKHOZBANK_DOMINANT_20231101 >									
277 	//        < E3atn5snOMaOtxG4H2g1Pemj186Or1IL40us0qMCsx31368hjn32n79E8Vh9caKE >									
278 	//        <  u =="0.000000000000000001" : ] 000000482253438.557762000000000000 ; 000000505211129.834329000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000002DFDC40302E419 >									
280 	//     < RUSS_PFXI_II_metadata_line_27_____RAEVSAKHAR_20231101 >									
281 	//        < rW383Xq6f3I7NJ69658370obsKd68GR6Odf5yb5CdRVcKr83vv2e8OnFOsZkwc9x >									
282 	//        <  u =="0.000000000000000001" : ] 000000505211129.834329000000000000 ; 000000521223904.565231000000000000 ] >									
283 	//        < 0x00000000000000000000000000000000000000000000000000302E41931B5316 >									
284 	//     < RUSS_PFXI_II_metadata_line_28_____OPTOVYE_TEKHNOLOGII_20231101 >									
285 	//        < E25q0H945U35VA82S8oX51wQGmxnAXsHf64795j2967wT4Ev7YehXGgKWtTA6085 >									
286 	//        <  u =="0.000000000000000001" : ] 000000521223904.565231000000000000 ; 000000538567690.099945000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000031B5316335CA01 >									
288 	//     < RUSS_PFXI_II_metadata_line_29_____EYANSKI_ELEVATOR_20231101 >									
289 	//        < K22M2L9B1chde2wyrPG6762y1K94qIlBZV3Mr33XBgbKWA67K1Kyfhq0nzIIhoHT >									
290 	//        <  u =="0.000000000000000001" : ] 000000538567690.099945000000000000 ; 000000556743423.633663000000000000 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000000000335CA0135185E6 >									
292 	//     < RUSS_PFXI_II_metadata_line_30_____RUSSIAN_AGRARIAN_FUEL_CO_20231101 >									
293 	//        < qb9WK17L715xivf2R4kyPV5993i1Wi90IUR6ro8tn92W47IB1pOK50cv80v6ZaxN >									
294 	//        <  u =="0.000000000000000001" : ] 000000556743423.633663000000000000 ; 000000576169658.160185000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000035185E636F2A46 >									
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
338 	//     < RUSS_PFXI_II_metadata_line_31_____KHOMYAKOVSKY_KHLADOKOMBINAT_20231101 >									
339 	//        < pwBBouU7a132u23Ndpqlq7tIrqam55c6LibQUEyO39QGmU71Ri454j8H8fKC5Li4 >									
340 	//        <  u =="0.000000000000000001" : ] 000000576169658.160185000000000000 ; 000000597733735.199822000000000000 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000000000036F2A4639011BE >									
342 	//     < RUSS_PFXI_II_metadata_line_32_____STEPNYANSKIY_ELEVATOR_20231101 >									
343 	//        < 390B30x689t3Hij7C7AO800GEK2507ntZsw4iCPG2O5dq781ey6ho65f5kupPl83 >									
344 	//        <  u =="0.000000000000000001" : ] 000000597733735.199822000000000000 ; 000000620750642.901849000000000000 ] >									
345 	//        < 0x0000000000000000000000000000000000000000000000000039011BE3B330B8 >									
346 	//     < RUSS_PFXI_II_metadata_line_33_____ROVNENSKIY_ELEVATOR_20231101 >									
347 	//        < 6ekM0aoaEF238OD4lizYq5bl85T56nHj0W4N4nRd17eBfi97ACl7XQh75R1uFXQ7 >									
348 	//        <  u =="0.000000000000000001" : ] 000000620750642.901849000000000000 ; 000000645444872.829188000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000003B330B83D8DEE7 >									
350 	//     < RUSS_PFXI_II_metadata_line_34_____KHOMYAKOVSKIY_COLD_STORAGE_FACILITY_20231101 >									
351 	//        < Bo1K888re8R8K7K9CD8K3IxiU5U2zNp6Z8qwqB95W1vFNET9i9WUG26QVhaUoRMr >									
352 	//        <  u =="0.000000000000000001" : ] 000000645444872.829188000000000000 ; 000000666819654.019824000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000003D8DEE73F97C6D >									
354 	//     < RUSS_PFXI_II_metadata_line_35_____BRIGANTINA_OOO_20231101 >									
355 	//        < phs2V7229ZEVGs36G9EbmjS0W3M4805YrbYjv42VZOh045Y0eV9g04n5tJ5mFqe2 >									
356 	//        <  u =="0.000000000000000001" : ] 000000666819654.019824000000000000 ; 000000684104766.771969000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000003F97C6D413DC6D >									
358 	//     < RUSS_PFXI_II_metadata_line_36_____RUS_AGRICULTURAL_BANK_AM_ARM_20231101 >									
359 	//        < oQ3t5O3nHPR1HOM5qmIiqk7hWVMFRnzxit1CV5ipZ4wky3W4BcV42ZkdqMoOQcI8 >									
360 	//        <  u =="0.000000000000000001" : ] 000000684104766.771969000000000000 ; 000000705315854.531033000000000000 ] >									
361 	//        < 0x00000000000000000000000000000000000000000000000000413DC6D4343A01 >									
362 	//     < RUSS_PFXI_II_metadata_line_37_____LUZHSKIY_FEEDSTUFF_PLANT_20231101 >									
363 	//        < KmqTbYlQ8UVl1pWPbS4itV7a56K8dho8CC6mK6VWoC2IUlXk2Y4HuBKRktJYT7C4 >									
364 	//        <  u =="0.000000000000000001" : ] 000000705315854.531033000000000000 ; 000000720737221.562994000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000004343A0144BC1FA >									
366 	//     < RUSS_PFXI_II_metadata_line_38_____LUZHSKIY_MYASOKOMBINAT_20231101 >									
367 	//        < 5G6A6VE6cB5Mu7xs0237C9eY76nfCV83mN3E7HBCYS2Jsk94g7F4qRJs1v29PDCw >									
368 	//        <  u =="0.000000000000000001" : ] 000000720737221.562994000000000000 ; 000000742110217.103215000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000044BC1FA46C5ECE >									
370 	//     < RUSS_PFXI_II_metadata_line_39_____LUGA_FODDER_PLANT_20231101 >									
371 	//        < 52MsR6e04tvmYWkc2ObJEISqEYt0557yYqL0bfRAYhx7xCGrpFGQ56u49BqxYFbk >									
372 	//        <  u =="0.000000000000000001" : ] 000000742110217.103215000000000000 ; 000000762091958.318148000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000046C5ECE48ADC2C >									
374 	//     < RUSS_PFXI_II_metadata_line_40_____KRILOVSKIY_ELEVATOR_20231101 >									
375 	//        < uDQ4fzjCc763QfKkYAUHRh19V4q2CsCF4aVa3nrXg30vk3O3618xskts4AKEBwXw >									
376 	//        <  u =="0.000000000000000001" : ] 000000762091958.318148000000000000 ; 000000781414319.750896000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000048ADC2C4A857F8 >									
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