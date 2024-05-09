1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXXXIV_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXXXIV_III_883		"	;
8 		string	public		symbol =	"	RUSS_PFXXXIV_III_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1041426217057610000000000000					;	
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
92 	//     < RUSS_PFXXXIV_III_metadata_line_1_____PHARMSTANDARD_20251101 >									
93 	//        < 2MQj4da6D297137Z003qF22LeAFJO8DtXlHMs9S0Yo2SL6283lJ5frXrkD46Nu1d >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000018721562.999495800000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000001C911C >									
96 	//     < RUSS_PFXXXIV_III_metadata_line_2_____PHARM_DAO_20251101 >									
97 	//        < 96ez35slToz6Z9kI4RHZE3qJCs22PdZTO86IFpslT7uDsz0494u4DgDBvK6O6euF >									
98 	//        <  u =="0.000000000000000001" : ] 000000018721562.999495800000000000 ; 000000043001947.007095300000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000001C911C419DA3 >									
100 	//     < RUSS_PFXXXIV_III_metadata_line_3_____PHARM_DAOPI_20251101 >									
101 	//        < 54qRD1hg197sKlHU5jNbXMgCK74CYr8RY47Y8MyTdw7nh0w726G8KFFo2Y8Dd5eb >									
102 	//        <  u =="0.000000000000000001" : ] 000000043001947.007095300000000000 ; 000000061381632.879742700000000000 ] >									
103 	//        < 0x0000000000000000000000000000000000000000000000000000419DA35DA933 >									
104 	//     < RUSS_PFXXXIV_III_metadata_line_4_____PHARM_DAC_20251101 >									
105 	//        < 7lZGHiqH8oZFr3DGI67u6D6bk3t9RM2553QkSx1j9C3JntP5G9nQxUEJh313965Z >									
106 	//        <  u =="0.000000000000000001" : ] 000000061381632.879742700000000000 ; 000000083101871.721021400000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000005DA9337ECDAB >									
108 	//     < RUSS_PFXXXIV_III_metadata_line_5_____PHARM_BIMI_20251101 >									
109 	//        < vQbD2v8ubAzHxC31xZETQw66RF4mxU29R3bU0m3ts6oV21b0njhXp7Bc5ftRTF1j >									
110 	//        <  u =="0.000000000000000001" : ] 000000083101871.721021400000000000 ; 000000116494241.833182000000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000007ECDABB1C190 >									
112 	//     < RUSS_PFXXXIV_III_metadata_line_6_____GENERIUM_20251101 >									
113 	//        < 8KSl61q0RJm5AzThExQ9u0D7Xn8aS7eM4X6445xjV1QbXTuR6RayP9rr0eQM23I0 >									
114 	//        <  u =="0.000000000000000001" : ] 000000116494241.833182000000000000 ; 000000150639432.415596000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000B1C190E5DB87 >									
116 	//     < RUSS_PFXXXIV_III_metadata_line_7_____GENERIUM_DAO_20251101 >									
117 	//        < B56J4zp6G85upV8d3WD73g0llre0vpEq2S91Dkb1nd7jxlVft6BzYLTnD30M5F5m >									
118 	//        <  u =="0.000000000000000001" : ] 000000150639432.415596000000000000 ; 000000170493673.417134000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000000E5DB871042717 >									
120 	//     < RUSS_PFXXXIV_III_metadata_line_8_____GENERIUM_DAOPI_20251101 >									
121 	//        < so1648p2lFbneDKr5eg5aNG4d71v2xK9TzW93118yZpKvRfNB4kk9s1YM294id8t >									
122 	//        <  u =="0.000000000000000001" : ] 000000170493673.417134000000000000 ; 000000193542980.359436000000000000 ] >									
123 	//        < 0x00000000000000000000000000000000000000000000000000104271712752BA >									
124 	//     < RUSS_PFXXXIV_III_metadata_line_9_____GENERIUM_DAC_20251101 >									
125 	//        < 3F2Z7V5mydXdtinNIqJs203kfDiwkso3c01Rj0lp2K0b0V1RJjW57q447BLolMIr >									
126 	//        <  u =="0.000000000000000001" : ] 000000193542980.359436000000000000 ; 000000215977406.753886000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000012752BA1498E2D >									
128 	//     < RUSS_PFXXXIV_III_metadata_line_10_____GENERIUM_BIMI_20251101 >									
129 	//        < HNH35ya5mataFsYe2L38Qu5K1e6q4vRYv9FqKlCqiZfNdTxy1w32F87142ap05dP >									
130 	//        <  u =="0.000000000000000001" : ] 000000215977406.753886000000000000 ; 000000235394975.202072000000000000 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000000001498E2D1672F2A >									
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
174 	//     < RUSS_PFXXXIV_III_metadata_line_11_____MASTERLEK_20251101 >									
175 	//        < AxVT29514Y6LbDdc493vGcS2N96F4nRWwY9y6C1HhI69iHPK67CxCev8Z027YDVF >									
176 	//        <  u =="0.000000000000000001" : ] 000000235394975.202072000000000000 ; 000000258569310.382341000000000000 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000000001672F2A18A8BA3 >									
178 	//     < RUSS_PFXXXIV_III_metadata_line_12_____MASTERLEK_DAO_20251101 >									
179 	//        < 4P5oemyB7r0Y4du5OcOp3771ZvcUDBvN3hu91j48moT1L9580N8y9pCuF681X05I >									
180 	//        <  u =="0.000000000000000001" : ] 000000258569310.382341000000000000 ; 000000284722006.872012000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000018A8BA31B27389 >									
182 	//     < RUSS_PFXXXIV_III_metadata_line_13_____MASTERLEK_DAOPI_20251101 >									
183 	//        < z5Uy7LyoJXQ8xbs253yr1h78T96l1pmK4j1D56c4hVW65wLUV55PVnR6TM2wn49P >									
184 	//        <  u =="0.000000000000000001" : ] 000000284722006.872012000000000000 ; 000000307281169.446323000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001B273891D4DFB5 >									
186 	//     < RUSS_PFXXXIV_III_metadata_line_14_____MASTERLEK_DAC_20251101 >									
187 	//        < rG6r9Jfm12sYu52zk81y4oKzzWl2ql2G118xr5y9Jbr1yKFxv8m3DEppuc9E9U7A >									
188 	//        <  u =="0.000000000000000001" : ] 000000307281169.446323000000000000 ; 000000341420554.329072000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000001D4DFB5208F767 >									
190 	//     < RUSS_PFXXXIV_III_metadata_line_15_____MASTERLEK_BIMI_20251101 >									
191 	//        < MBRRdKw7ycJG6IfkMLNy5dyx5FR36vEGJdC368cehZBfx62GYQRs2f9H3Om85Dv9 >									
192 	//        <  u =="0.000000000000000001" : ] 000000341420554.329072000000000000 ; 000000371330500.979320000000000000 ] >									
193 	//        < 0x00000000000000000000000000000000000000000000000000208F7672369AFA >									
194 	//     < RUSS_PFXXXIV_III_metadata_line_16_____PHARMSTANDARD_TMK_20251101 >									
195 	//        < kFTPM7E5AfR85Rhe7zQq3qGIp5KLtt6ZpSeg5Z3s21ORS4ILJdKU9JcFMoA8yA15 >									
196 	//        <  u =="0.000000000000000001" : ] 000000371330500.979320000000000000 ; 000000389774730.397161000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000002369AFA252BFC1 >									
198 	//     < RUSS_PFXXXIV_III_metadata_line_17_____PHARMSTANDARD_OCTOBER_20251101 >									
199 	//        < 9mmY0gmXsK5H9R8dBU1D6M1j7UGo6818ZDeux83V3N401ar11bH88B8QXtc8AHja >									
200 	//        <  u =="0.000000000000000001" : ] 000000389774730.397161000000000000 ; 000000413679138.989941000000000000 ] >									
201 	//        < 0x00000000000000000000000000000000000000000000000000252BFC1277396A >									
202 	//     < RUSS_PFXXXIV_III_metadata_line_18_____LEKSREDSTVA_20251101 >									
203 	//        < aUd0XZcp54n7Z82gN7IUNcNL9AjSySqJ6SRYAi4n30TQOHIQ8890skL4dDzgislZ >									
204 	//        <  u =="0.000000000000000001" : ] 000000413679138.989941000000000000 ; 000000445600982.737665000000000000 ] >									
205 	//        < 0x00000000000000000000000000000000000000000000000000277396A2A7EEE2 >									
206 	//     < RUSS_PFXXXIV_III_metadata_line_19_____TYUMEN_PLANT_MED_EQUIP_TOOLS_20251101 >									
207 	//        < 22F9k173iiNu6a7gZsDBIJEfV09k35mvjwTWtOQX033qo2cckkCQOkYJ3YDl3a5H >									
208 	//        <  u =="0.000000000000000001" : ] 000000445600982.737665000000000000 ; 000000478163568.557095000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000002A7EEE22D99EA5 >									
210 	//     < RUSS_PFXXXIV_III_metadata_line_20_____MASTERPLAZMA_LLC_20251101 >									
211 	//        < rFeeyN0cZLdh2g84vn57r9AUdXFfjb0OQ0qqr95At5QpDX3R6S1ddn0ll3i1g762 >									
212 	//        <  u =="0.000000000000000001" : ] 000000478163568.557095000000000000 ; 000000496598345.651992000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000002D99EA52F5BFBB >									
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
256 	//     < RUSS_PFXXXIV_III_metadata_line_21_____BIGPEARL_TRADING_LIMITED_20251101 >									
257 	//        < IxVQ006wTymG7uylsL60CDH6D9d2D6j799mzU8A9td1qKssK2egzecSK7w74P1kh >									
258 	//        <  u =="0.000000000000000001" : ] 000000496598345.651992000000000000 ; 000000516823019.570457000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000002F5BFBB3149BFE >									
260 	//     < RUSS_PFXXXIV_III_metadata_line_22_____BIGPEARL_DAO_20251101 >									
261 	//        < 9zGd6L361qqxw4uI06K8pC41VNlv7R3Zp0O0inG1l1ngBVP1DSsQB3k3X7Kn6fZV >									
262 	//        <  u =="0.000000000000000001" : ] 000000516823019.570457000000000000 ; 000000548301404.335102000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000003149BFE344A43C >									
264 	//     < RUSS_PFXXXIV_III_metadata_line_23_____BIGPEARL_DAOPI_20251101 >									
265 	//        < 67P9KLr4s3lw9C2BN9M3FMdZZX7ed8Zv3CKV9oMNpquQ9WS7lFaAR0hkc948UsEF >									
266 	//        <  u =="0.000000000000000001" : ] 000000548301404.335102000000000000 ; 000000577544332.704959000000000000 ] >									
267 	//        < 0x00000000000000000000000000000000000000000000000000344A43C3714341 >									
268 	//     < RUSS_PFXXXIV_III_metadata_line_24_____BIGPEARL_DAC_20251101 >									
269 	//        < 3QyFrCI9ZT8sxo6N1pwOJ2m1KdnbSGh87Gg76vDzfjrG97OACQ8a221afQtn86Sj >									
270 	//        <  u =="0.000000000000000001" : ] 000000577544332.704959000000000000 ; 000000604488821.357354000000000000 ] >									
271 	//        < 0x00000000000000000000000000000000000000000000000000371434139A6072 >									
272 	//     < RUSS_PFXXXIV_III_metadata_line_25_____BIGPEARL_BIMI_20251101 >									
273 	//        < 6Wxff472P4YrX6FCCCf8E6b8t72OlitCx5Hd2dKd72kQ4uHpTKCrktB68rS3e3Ds >									
274 	//        <  u =="0.000000000000000001" : ] 000000604488821.357354000000000000 ; 000000639550248.475914000000000000 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000000000039A60723CFE051 >									
276 	//     < RUSS_PFXXXIV_III_metadata_line_26_____UFAVITA_20251101 >									
277 	//        < GpxyYVVvld8sU5ak11tt39NQ57Y5X1fAFR1Ws4sYvTi2miBf4R29O7nb2Z6hfLI6 >									
278 	//        <  u =="0.000000000000000001" : ] 000000639550248.475914000000000000 ; 000000664914380.385425000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000003CFE0513F6942E >									
280 	//     < RUSS_PFXXXIV_III_metadata_line_27_____DONELLE_COMPANY_LIMITED_20251101 >									
281 	//        < 8DYQ5x9PWz0CPkGDHat1m0y6Zh0633jrBUQ8fd0DZ61jCU97d6u5lO5Az5o90aF2 >									
282 	//        <  u =="0.000000000000000001" : ] 000000664914380.385425000000000000 ; 000000697508528.723254000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000003F6942E4285045 >									
284 	//     < RUSS_PFXXXIV_III_metadata_line_28_____DONELLE_CHF_20251101 >									
285 	//        < T0E3YTD7b5B1m30QCkORur46Zz2v8oaWluC0Ku45V60Cxkmnk3nkG045TJ29J586 >									
286 	//        <  u =="0.000000000000000001" : ] 000000697508528.723254000000000000 ; 000000720789923.908375000000000000 ] >									
287 	//        < 0x00000000000000000000000000000000000000000000000000428504544BD690 >									
288 	//     < RUSS_PFXXXIV_III_metadata_line_29_____VINDEKSFARM_20251101 >									
289 	//        < 9I5VW6p4s3jv6xgL5s86B9oXXzX6gj9Q05784iYZ77Oj4ecCdrX8B2rjKQGT4B18 >									
290 	//        <  u =="0.000000000000000001" : ] 000000720789923.908375000000000000 ; 000000747784791.732185000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000044BD690475076F >									
292 	//     < RUSS_PFXXXIV_III_metadata_line_30_____TYUMEN_PLANT_CHF_20251101 >									
293 	//        < hLKy5r4UihDs67uEilA4ABVQCZ0OQj1Y52S7Ns454VCTk0Ka6Wjl1WOVV5k5I45Q >									
294 	//        <  u =="0.000000000000000001" : ] 000000747784791.732185000000000000 ; 000000774482487.810897000000000000 ] >									
295 	//        < 0x00000000000000000000000000000000000000000000000000475076F49DC439 >									
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
338 	//     < RUSS_PFXXXIV_III_metadata_line_31_____LEKKO_20251101 >									
339 	//        < 9EfOIKBC17506Cq74wn528FDBoaVPTb6S2J0CE5NeN5P5XYn7U55x80N7P14sf2f >									
340 	//        <  u =="0.000000000000000001" : ] 000000774482487.810897000000000000 ; 000000808964274.571189000000000000 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000000000049DC4394D261AB >									
342 	//     < RUSS_PFXXXIV_III_metadata_line_32_____LEKKO_DAO_20251101 >									
343 	//        < WMT4u1zKfaa7xDZbjJzkcCl5IMSWQ5g2796l65Vtm2Y9h3C1SFifa419WR2K5YZ6 >									
344 	//        <  u =="0.000000000000000001" : ] 000000808964274.571189000000000000 ; 000000835066033.683266000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000004D261AB4FA35AB >									
346 	//     < RUSS_PFXXXIV_III_metadata_line_33_____LEKKO_DAOPI_20251101 >									
347 	//        < 9DJskl6J9W1HfpvHSd1u42MRg32qX5GS0890v2hZ0XoOJjTw601lhmZIlObsK1zV >									
348 	//        <  u =="0.000000000000000001" : ] 000000835066033.683266000000000000 ; 000000866014148.388723000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000004FA35AB5296EC7 >									
350 	//     < RUSS_PFXXXIV_III_metadata_line_34_____LEKKO_DAC_20251101 >									
351 	//        < qp6mYd8242PKK9274GQzmOPOIp8F00i785ujcB61G701J30r53B4tHGxYyq46x6Z >									
352 	//        <  u =="0.000000000000000001" : ] 000000866014148.388723000000000000 ; 000000885180566.175317000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000005296EC7546ADA9 >									
354 	//     < RUSS_PFXXXIV_III_metadata_line_35_____LEKKO_BIMI_20251101 >									
355 	//        < lTVbXyr8h969XjwV7SDt9VCYQL8OXk33z2SP225Z1Z27Rvl6MYW4XS2r7AV1bm2C >									
356 	//        <  u =="0.000000000000000001" : ] 000000885180566.175317000000000000 ; 000000907023871.891320000000000000 ] >									
357 	//        < 0x00000000000000000000000000000000000000000000000000546ADA95680233 >									
358 	//     < RUSS_PFXXXIV_III_metadata_line_36_____TOMSKHIMPHARM_20251101 >									
359 	//        < SN69PApb2IP6I01vc1ekh83w2E8Fx8HXgChsH45IJe9M45uO8fMP4pb5XfL6m5FU >									
360 	//        <  u =="0.000000000000000001" : ] 000000907023871.891320000000000000 ; 000000929581246.255049000000000000 ] >									
361 	//        < 0x00000000000000000000000000000000000000000000000000568023358A6DAD >									
362 	//     < RUSS_PFXXXIV_III_metadata_line_37_____TOMSKHIM_CHF_20251101 >									
363 	//        < aLP11lQWm42BA6Y04wM1kaX9Fqox1Tiol2b9nA3jkcW602Kk717W3LNj4wE061lv >									
364 	//        <  u =="0.000000000000000001" : ] 000000929581246.255049000000000000 ; 000000948322112.607515000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000058A6DAD5A70653 >									
366 	//     < RUSS_PFXXXIV_III_metadata_line_38_____FF_LEKKO_ZAO_20251101 >									
367 	//        < cJJ3Sk92v8pI30hoT0VIY5eM0ss63Qij7nUbl87M408ueM0VrULnE04mvPIREMVl >									
368 	//        <  u =="0.000000000000000001" : ] 000000948322112.607515000000000000 ; 000000977889546.859344000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000005A706535D4241B >									
370 	//     < RUSS_PFXXXIV_III_metadata_line_39_____PHARMSTANDARD_PLAZMA_OOO_20251101 >									
371 	//        < 07eKnSHAe3Gf4w69680yyW4O9O874wanaUHloORgm419l3c3lj3276025g7w3I60 >									
372 	//        <  u =="0.000000000000000001" : ] 000000977889546.859344000000000000 ; 000001009487859.929260000000000000 ] >									
373 	//        < 0x000000000000000000000000000000000000000000000000005D4241B6045B32 >									
374 	//     < RUSS_PFXXXIV_III_metadata_line_40_____FARMSTANDARD_TOMSKKHIMFOARM_OAO_20251101 >									
375 	//        < cUiQ8Fl00WL50s0VNxfDP1muSe25P8TNb97y1QhjaZ912WSsr18908Yztrp5yC0s >									
376 	//        <  u =="0.000000000000000001" : ] 000001009487859.929260000000000000 ; 000001041426217.057610000000000000 ] >									
377 	//        < 0x000000000000000000000000000000000000000000000000006045B32635171E >									
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