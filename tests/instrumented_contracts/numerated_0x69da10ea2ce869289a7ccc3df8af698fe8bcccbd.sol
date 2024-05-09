1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXXI_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXXI_I_883		"	;
8 		string	public		symbol =	"	RUSS_PFXXI_I_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		605069603335981000000000000					;	
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
92 	//     < RUSS_PFXXI_I_metadata_line_1_____EUROCHEM_20211101 >									
93 	//        < nDRWM59pPXG9sWKoG6IDiAeI07B2W368h6yTrhD63GnB2nqBdABzH3BGT1BtF1ss >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000016110595.504242200000000000 ] >									
95 	//        < 0x0000000000000000000000000000000000000000000000000000000000189534 >									
96 	//     < RUSS_PFXXI_I_metadata_line_2_____Eurochem_Org_20211101 >									
97 	//        < G2CV9lH337oBbcWD2V9Z459D8IY50INe0Mf13B1V8Wh1h1lb4Y40xZCw35iTGqTu >									
98 	//        <  u =="0.000000000000000001" : ] 000000016110595.504242200000000000 ; 000000029472245.923642500000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000001895342CF899 >									
100 	//     < RUSS_PFXXI_I_metadata_line_3_____Hispalense_Líquidos_SL_20211101 >									
101 	//        < 1veW3AM85DXa13y87ZgXcx9lUcN6rMzbpAB28B373H0Teo17FXqsk8DEh39Hx32Z >									
102 	//        <  u =="0.000000000000000001" : ] 000000029472245.923642500000000000 ; 000000046404661.686044600000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000002CF89946CED2 >									
104 	//     < RUSS_PFXXI_I_metadata_line_4_____Azottech_LLC_20211101 >									
105 	//        < 3IA9002lV6xV1elxqq9FcZWDkWimqEdiIKU3foDJpSc8E0fgq923mI3z0O5P8qwr >									
106 	//        <  u =="0.000000000000000001" : ] 000000046404661.686044600000000000 ; 000000063423651.107270200000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000046CED260C6DD >									
108 	//     < RUSS_PFXXI_I_metadata_line_5_____Biochem_Technologies_LLC_20211101 >									
109 	//        < 4RLhpg6u1UQ19k5Ix5o9i904MnD9Gaszdq6z1G3Qq07LL9FoS6wICf2oJ81723HK >									
110 	//        <  u =="0.000000000000000001" : ] 000000063423651.107270200000000000 ; 000000078301868.763730900000000000 ] >									
111 	//        < 0x000000000000000000000000000000000000000000000000000060C6DD777AAB >									
112 	//     < RUSS_PFXXI_I_metadata_line_6_____Eurochem_1_Org_20211101 >									
113 	//        < k27E5s1nP5188P4xCV5dXwu16zOq4m42699k8LlD8Z5e1gylJY7vat1xD59955qP >									
114 	//        <  u =="0.000000000000000001" : ] 000000078301868.763730900000000000 ; 000000095512653.033391500000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000777AAB91BDA1 >									
116 	//     < RUSS_PFXXI_I_metadata_line_7_____Eurochem_1_Dao_20211101 >									
117 	//        < j7606eKMgBL9f5E6nGZ7dz4ynz1REPK3Rpk642IJG8E1002961oOi1Ib5sql2MyH >									
118 	//        <  u =="0.000000000000000001" : ] 000000095512653.033391500000000000 ; 000000110450067.245517000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000000091BDA1A8888F >									
120 	//     < RUSS_PFXXI_I_metadata_line_8_____Eurochem_1_Daopi_20211101 >									
121 	//        < kzEDlId1jT7Ia694QRXu25Q754n1giXi6u74mFrQ8asmz1XFC5cRx0CsmziR48N6 >									
122 	//        <  u =="0.000000000000000001" : ] 000000110450067.245517000000000000 ; 000000127601563.844301000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000A8888FC2B45C >									
124 	//     < RUSS_PFXXI_I_metadata_line_9_____Eurochem_1_Dac_20211101 >									
125 	//        < I9hOMw8U03xzervN2V43EsYy3xabk5p4Z9ph2N0DXdFyn0tj0v7wZm9nu5meABk6 >									
126 	//        <  u =="0.000000000000000001" : ] 000000127601563.844301000000000000 ; 000000143068432.325246000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000000C2B45CDA4E1B >									
128 	//     < RUSS_PFXXI_I_metadata_line_10_____Eurochem_1_Bimi_20211101 >									
129 	//        < 92IW77TiXr21QG133Qy2e473VsM5WH6u5Mm34J3m7wQUeEHI112sgb1h5H9VrZ3x >									
130 	//        <  u =="0.000000000000000001" : ] 000000143068432.325246000000000000 ; 000000157681714.641320000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000000DA4E1BF09A6B >									
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
174 	//     < RUSS_PFXXI_I_metadata_line_11_____Eurochem_2_Org_20211101 >									
175 	//        < R2AwBNqPWBP83251465ckV0G280pQAZ6KEiUkw8988ZQ8AbqBswWlvwsET6kXZRu >									
176 	//        <  u =="0.000000000000000001" : ] 000000157681714.641320000000000000 ; 000000174367170.281268000000000000 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000000000F09A6B10A102D >									
178 	//     < RUSS_PFXXI_I_metadata_line_12_____Eurochem_2_Dao_20211101 >									
179 	//        < 50qet3KNHHqlAV5AZ4RrOR097ArFq0ewHNeyUH1KT866lv29Z484vn18UGGBs30n >									
180 	//        <  u =="0.000000000000000001" : ] 000000174367170.281268000000000000 ; 000000187371296.831050000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000010A102D11DE7EA >									
182 	//     < RUSS_PFXXI_I_metadata_line_13_____Eurochem_2_Daopi_20211101 >									
183 	//        < Yi3IFD88yT3FR0iNR8v7Zk9BNed1KmA9ji3hi7fap1F8E0RkuakmmxrAGi4qG5OL >									
184 	//        <  u =="0.000000000000000001" : ] 000000187371296.831050000000000000 ; 000000201069733.346227000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000011DE7EA132CEDD >									
186 	//     < RUSS_PFXXI_I_metadata_line_14_____Eurochem_2_Dac_20211101 >									
187 	//        < 3LS8mRfAPSz7jvJ732yEAia62yA8z45A4756RJ3SHDSOhgQt61y1gn900Dtr0Cj5 >									
188 	//        <  u =="0.000000000000000001" : ] 000000201069733.346227000000000000 ; 000000216677313.608643000000000000 ] >									
189 	//        < 0x00000000000000000000000000000000000000000000000000132CEDD14A9F93 >									
190 	//     < RUSS_PFXXI_I_metadata_line_15_____Eurochem_2_Bimi_20211101 >									
191 	//        < 591zlJ0x9BsQtW88OaPewBF45KYCC7zz79UaTFdcbRvlR82BT836fYYawTecK17L >									
192 	//        <  u =="0.000000000000000001" : ] 000000216677313.608643000000000000 ; 000000232505926.630920000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000014A9F93162C6A1 >									
194 	//     < RUSS_PFXXI_I_metadata_line_16_____Melni_1_Org_20211101 >									
195 	//        < 5MkcQJ1dFUs88fWpfobytcMolUJXG6Gku5959YMf6iiV8rmgoBYG22u8yxT57456 >									
196 	//        <  u =="0.000000000000000001" : ] 000000232505926.630920000000000000 ; 000000247596467.849797000000000000 ] >									
197 	//        < 0x00000000000000000000000000000000000000000000000000162C6A1179CD5F >									
198 	//     < RUSS_PFXXI_I_metadata_line_17_____Melni_1_Dao_20211101 >									
199 	//        < 680925ESf9CEGczQqhF4cOYPU5GG74JYM7J2545Uh0II770138d3E5k4lDd08uJ1 >									
200 	//        <  u =="0.000000000000000001" : ] 000000247596467.849797000000000000 ; 000000262136169.717443000000000000 ] >									
201 	//        < 0x00000000000000000000000000000000000000000000000000179CD5F18FFCF1 >									
202 	//     < RUSS_PFXXI_I_metadata_line_18_____Melni_1_Daopi_20211101 >									
203 	//        < 4239Phac0H4C0S1ZtkUBj8g5G7tbYeGpW63aK9C68ONA9aL8DA2G8gIz0sgNEP3x >									
204 	//        <  u =="0.000000000000000001" : ] 000000262136169.717443000000000000 ; 000000278394737.484621000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000018FFCF11A8CBF2 >									
206 	//     < RUSS_PFXXI_I_metadata_line_19_____Melni_1_Dac_20211101 >									
207 	//        < L179HbLMX9PaMk06AMBc4YiwUGQ7gmohJEoA77Tb07I1SC389Nh9jKXwpT0U11F3 >									
208 	//        <  u =="0.000000000000000001" : ] 000000278394737.484621000000000000 ; 000000293129197.298558000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000001A8CBF21BF4798 >									
210 	//     < RUSS_PFXXI_I_metadata_line_20_____Melni_1_Bimi_20211101 >									
211 	//        < 3V5M16D9WkXPl9X0f50mvW55dxeOQpa13kmdE6d7e9fSoU71BGbN9074r08WCXwd >									
212 	//        <  u =="0.000000000000000001" : ] 000000293129197.298558000000000000 ; 000000306295399.283295000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000001BF47981D35EA4 >									
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
256 	//     < RUSS_PFXXI_I_metadata_line_21_____Melni_2_Org_20211101 >									
257 	//        < w7jkLZ11u552z4hxz6Kqt1V1D3SCOvJ5Pq5UE3IRC1Ni7pYeZTWKM18TJvZsT7Uu >									
258 	//        <  u =="0.000000000000000001" : ] 000000306295399.283295000000000000 ; 000000319827145.948163000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000001D35EA41E8047B >									
260 	//     < RUSS_PFXXI_I_metadata_line_22_____Melni_2_Dao_20211101 >									
261 	//        < 59Ol6H5B6QFv06005mB4rFkuQcz559S50qe5yClh4gS4AfM1cJI2jHl9494862Ce >									
262 	//        <  u =="0.000000000000000001" : ] 000000319827145.948163000000000000 ; 000000335540551.268178000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000001E8047B1FFFE87 >									
264 	//     < RUSS_PFXXI_I_metadata_line_23_____Melni_2_Daopi_20211101 >									
265 	//        < 3lh61Vn5O9LhsaV34ar5Ul17dOwf7i9W17fnoq4MJ0M55bBNRkTnvy24W3gtCr5Y >									
266 	//        <  u =="0.000000000000000001" : ] 000000335540551.268178000000000000 ; 000000352099021.567141000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000001FFFE8721942AE >									
268 	//     < RUSS_PFXXI_I_metadata_line_24_____Melni_2_Dac_20211101 >									
269 	//        < At98I29s29FRFClNq7hnDc1Ib7Nchd3V2TEvtFI3a0ronUEQgt77nPWNY4uowm25 >									
270 	//        <  u =="0.000000000000000001" : ] 000000352099021.567141000000000000 ; 000000366335133.392957000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000021942AE22EFBA9 >									
272 	//     < RUSS_PFXXI_I_metadata_line_25_____Melni_2_Bimi_20211101 >									
273 	//        < k9f395G9PlVb52XCF2rx3BFH9uUjyY558tpop86E5fezV0WLuB2DtbR699J8DoIp >									
274 	//        <  u =="0.000000000000000001" : ] 000000366335133.392957000000000000 ; 000000380731405.900228000000000000 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000000000022EFBA9244F335 >									
276 	//     < RUSS_PFXXI_I_metadata_line_26_____Lifosa_Ab_Org_20211101 >									
277 	//        < 2050H0r9PjSQ9tjRfj74jC6JOYkr2U2b5xxuR0JDv4CE4ZFdBDDw591r0ozN53Yu >									
278 	//        <  u =="0.000000000000000001" : ] 000000380731405.900228000000000000 ; 000000397136904.120959000000000000 ] >									
279 	//        < 0x00000000000000000000000000000000000000000000000000244F33525DFB9A >									
280 	//     < RUSS_PFXXI_I_metadata_line_27_____Lifosa_Ab_Dao_20211101 >									
281 	//        < IOeGgf6NclxyfbIBMg05q1849yd74500W174ipDyFj50q96B1jo374gPiXFfFG3j >									
282 	//        <  u =="0.000000000000000001" : ] 000000397136904.120959000000000000 ; 000000412911489.050695000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000025DFB9A2760D8D >									
284 	//     < RUSS_PFXXI_I_metadata_line_28_____Lifosa_Ab_Daopi_20211101 >									
285 	//        < o2m7yK0cXf7ZrucWYT33WV6xKmKR6KhVwAMuX247gr42TxfQE1803gy8NmjQduk7 >									
286 	//        <  u =="0.000000000000000001" : ] 000000412911489.050695000000000000 ; 000000429992672.891664000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000002760D8D2901DE3 >									
288 	//     < RUSS_PFXXI_I_metadata_line_29_____Lifosa_Ab_Dac_20211101 >									
289 	//        < 13O0VOpDIn2915zb7554Nk7P6btciyvK3732Q0eov1FRs4n1mN8616BzKrF1262u >									
290 	//        <  u =="0.000000000000000001" : ] 000000429992672.891664000000000000 ; 000000445021188.653083000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000002901DE32A70C67 >									
292 	//     < RUSS_PFXXI_I_metadata_line_30_____Lifosa_Ab_Bimi_20211101 >									
293 	//        < w5Oq7s7KR1g22VQB79akkRjtCo2K9X2L789Ro40XFOn19J7PD3X7kqv9k619Ef77 >									
294 	//        <  u =="0.000000000000000001" : ] 000000445021188.653083000000000000 ; 000000460016789.675259000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000002A70C672BDEE0F >									
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
338 	//     < RUSS_PFXXI_I_metadata_line_31_____Azot_Ab_1_Org_20211101 >									
339 	//        < Hq9gHOzYLv2Kk0C3243CHNwlzwZ5M2YDAyIqJS9uiC04Olt591U7aw6VfvIOq58B >									
340 	//        <  u =="0.000000000000000001" : ] 000000460016789.675259000000000000 ; 000000476197344.292022000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000002BDEE0F2D69E96 >									
342 	//     < RUSS_PFXXI_I_metadata_line_32_____Azot_Ab_1_Dao_20211101 >									
343 	//        < uK7qmtu6VTYk5nQ0W3sjY647A0uqj1tr2yyh4hw4pl461N62Jl1FWmvt9t38OBth >									
344 	//        <  u =="0.000000000000000001" : ] 000000476197344.292022000000000000 ; 000000490486857.731439000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000002D69E962EC6C6E >									
346 	//     < RUSS_PFXXI_I_metadata_line_33_____Azot_Ab_1_Daopi_20211101 >									
347 	//        < 4rD0nlf9UHH51P6bpnGalF6S0mhXfn7k8U3OQ238U0a6s246Y55TByGm8T79Fstg >									
348 	//        <  u =="0.000000000000000001" : ] 000000490486857.731439000000000000 ; 000000504145362.624490000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000002EC6C6E30143C8 >									
350 	//     < RUSS_PFXXI_I_metadata_line_34_____Azot_Ab_1_Dac_20211101 >									
351 	//        < KB1gQmQ96fOcGcBIFm303S79JJXx4CXHGM4HRRrjd4g9fHTYcEMYi5WI9T1tb9EB >									
352 	//        <  u =="0.000000000000000001" : ] 000000504145362.624490000000000000 ; 000000517834317.495934000000000000 ] >									
353 	//        < 0x0000000000000000000000000000000000000000000000000030143C83162708 >									
354 	//     < RUSS_PFXXI_I_metadata_line_35_____Azot_Ab_1_Bimi_20211101 >									
355 	//        < nQvL7iZIVW1FDfqZibRUnt5bYhUG55Ivo6L539oyL4tPFGCDSW187v7gqL3T3mIa >									
356 	//        <  u =="0.000000000000000001" : ] 000000517834317.495934000000000000 ; 000000531198093.428824000000000000 ] >									
357 	//        < 0x00000000000000000000000000000000000000000000000000316270832A8B41 >									
358 	//     < RUSS_PFXXI_I_metadata_line_36_____Azot_Ab_2_Org_20211101 >									
359 	//        < Of65J8BJAIAZk8xkiO1OKFu2224G4MfFNQ968EB8324b3981J2a6FvdR2a1455GZ >									
360 	//        <  u =="0.000000000000000001" : ] 000000531198093.428824000000000000 ; 000000548080219.943078000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000032A8B413444DD6 >									
362 	//     < RUSS_PFXXI_I_metadata_line_37_____Azot_Ab_2_Dao_20211101 >									
363 	//        < p905URomDVcT8H4bPJ1lbpGtib0A4S8m9rH2Dk5lN8W18P0yX39ros5hOcH7riOQ >									
364 	//        <  u =="0.000000000000000001" : ] 000000548080219.943078000000000000 ; 000000562772172.505926000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000003444DD635AB8E1 >									
366 	//     < RUSS_PFXXI_I_metadata_line_38_____Azot_Ab_2_Daopi_20211101 >									
367 	//        < 8VT7a6LDU3VJ045w6p7n1ObtWf7W872HSVw53Z3FVmb5s9pQPSM20OQBI295CE0b >									
368 	//        <  u =="0.000000000000000001" : ] 000000562772172.505926000000000000 ; 000000576226434.597916000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000035AB8E136F4073 >									
370 	//     < RUSS_PFXXI_I_metadata_line_39_____Azot_Ab_2_Dac_20211101 >									
371 	//        < 3gUyBTTmg1a21HW60mS8H9H58yW7dHsCk8fe9tCEAS745Rjc9H3OW716Ie6Q7d19 >									
372 	//        <  u =="0.000000000000000001" : ] 000000576226434.597916000000000000 ; 000000591103107.152590000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000036F4073385F3A7 >									
374 	//     < RUSS_PFXXI_I_metadata_line_40_____Azot_Ab_2_Bimi_20211101 >									
375 	//        < K7IP90f9q8J9ZMQ590cWlY9pa9o2W677qzP70MjV5ByK3g323A3MaX75Gfzpf29H >									
376 	//        <  u =="0.000000000000000001" : ] 000000591103107.152590000000000000 ; 000000605069603.335981000000000000 ] >									
377 	//        < 0x00000000000000000000000000000000000000000000000000385F3A739B4350 >									
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