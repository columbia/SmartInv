1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXV_II_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXV_II_883		"	;
8 		string	public		symbol =	"	RUSS_PFXV_II_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		785792764471279000000000000					;	
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
92 	//     < RUSS_PFXV_II_metadata_line_1_____POLYMETAL_20231101 >									
93 	//        < b0a1pLDdN97SI95r9e8s42dJj74wtilZCbw7NrVPJG9TwwR46IC57oUZkO811O69 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000016881202.771183300000000000 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000000019C238 >									
96 	//     < RUSS_PFXV_II_metadata_line_2_____POLYMETAL_GBP_20231101 >									
97 	//        < 6b71zq92dJ432wYnLae36VN62YIa6Y48iZ2Do4LHH0thCzyCqhzCPD9L1FE41933 >									
98 	//        <  u =="0.000000000000000001" : ] 000000016881202.771183300000000000 ; 000000033616417.015068400000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000019C238334B6A >									
100 	//     < RUSS_PFXV_II_metadata_line_3_____POLYMETAL_USD_20231101 >									
101 	//        < nryj580qaR6F7KgjQxv801Xsm537uU9hpZ561LFx21x3OOoF38wd99e0PfFwzHX2 >									
102 	//        <  u =="0.000000000000000001" : ] 000000033616417.015068400000000000 ; 000000049334084.290695800000000000 ] >									
103 	//        < 0x0000000000000000000000000000000000000000000000000000334B6A4B4720 >									
104 	//     < RUSS_PFXV_II_metadata_line_4_____POLYMETAL_ORG_20231101 >									
105 	//        < kYw45K1zyEZIJShJjVNkC6f3jmx692Y24DG1ours7PT76mT41mr133K0Cl9BrWwU >									
106 	//        <  u =="0.000000000000000001" : ] 000000049334084.290695800000000000 ; 000000067006542.424027800000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000004B4720663E6E >									
108 	//     < RUSS_PFXV_II_metadata_line_5_____POLYMETAL_DAO_20231101 >									
109 	//        < 9BOEu41fVp2zov79H9uo3EDO3MmxNf3oT13sONI2ruz3oe75q22SZWbjPk9eT05a >									
110 	//        <  u =="0.000000000000000001" : ] 000000067006542.424027800000000000 ; 000000090339317.126386800000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000663E6E89D8CC >									
112 	//     < RUSS_PFXV_II_metadata_line_6_____POLYMETAL_DAC_20231101 >									
113 	//        < sdwkD53yC35Qn299M902q24PnlNum34s7qCC5D9077Gc5ll8a21Zc52B4lEbL3at >									
114 	//        <  u =="0.000000000000000001" : ] 000000090339317.126386800000000000 ; 000000112983281.107098000000000000 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000000000089D8CCAC6618 >									
116 	//     < RUSS_PFXV_II_metadata_line_7_____PPF_GROUP_RUB_20231101 >									
117 	//        < nA4vawsh3hZI65AlA2KX9HbaL0wHE466fjg4xQcX1qS54FTT25h5R7rS0H67672F >									
118 	//        <  u =="0.000000000000000001" : ] 000000112983281.107098000000000000 ; 000000133386750.597353000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000AC6618CB8833 >									
120 	//     < RUSS_PFXV_II_metadata_line_8_____PPF_GROUP_RUB_AB_20231101 >									
121 	//        < x8N9v2bo7lWfaa7Tvei3BYg5XCC52i6s276ESF3913Yv150vG3q9bwRD7FixeIf3 >									
122 	//        <  u =="0.000000000000000001" : ] 000000133386750.597353000000000000 ; 000000154161011.702502000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000CB8833EB3B25 >									
124 	//     < RUSS_PFXV_II_metadata_line_9_____ICT_GROUP_20231101 >									
125 	//        < 244J4Uw42XS0R9zA0e3o3KwdP9t5m2Q8X6rYMZ7T4KKLMSG87B1XxJ9k5C43m6um >									
126 	//        <  u =="0.000000000000000001" : ] 000000154161011.702502000000000000 ; 000000174399310.870071000000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000000EB3B2510A1CBB >									
128 	//     < RUSS_PFXV_II_metadata_line_10_____ICT_GROUP_ORG_20231101 >									
129 	//        < 5S0cN7REJEO5UH1oC038V91BVqH7dwZ0WXJ4bc3i9c7UCz1dmhmT1k7FTtZ7Kk71 >									
130 	//        <  u =="0.000000000000000001" : ] 000000174399310.870071000000000000 ; 000000191026800.577587000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000010A1CBB1237BD8 >									
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
174 	//     < RUSS_PFXV_II_metadata_line_11_____ENISEYSKAYA_1_ORG_20231101 >									
175 	//        < C621N36xv6R38x3Luyp8LjMp9h4qFX6QcNqg97lk26mBLQ8416S3C4G9vXT20Ztg >									
176 	//        <  u =="0.000000000000000001" : ] 000000191026800.577587000000000000 ; 000000209191953.870684000000000000 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000000001237BD813F339B >									
178 	//     < RUSS_PFXV_II_metadata_line_12_____ENISEYSKAYA_1_DAO_20231101 >									
179 	//        < 17XNGR8946hGs9pn747T2N4y0KpXqXLa6fLVWIt1z6Mk208vrsPGPx7GWsq91HuY >									
180 	//        <  u =="0.000000000000000001" : ] 000000209191953.870684000000000000 ; 000000229009265.774511000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000013F339B15D70BF >									
182 	//     < RUSS_PFXV_II_metadata_line_13_____ENISEYSKAYA_1_DAOPI_20231101 >									
183 	//        < lnyLv9y2OqC5tVI8Z6uxIm1vF53Z8K0NLs1JXFT1SBUcsOC2S8sZXaH684DH3Tq9 >									
184 	//        <  u =="0.000000000000000001" : ] 000000229009265.774511000000000000 ; 000000249082399.079560000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000015D70BF17C11D0 >									
186 	//     < RUSS_PFXV_II_metadata_line_14_____ENISEYSKAYA_1_DAC_20231101 >									
187 	//        < loH0a1AG8f2ACM32C2LHhj16E51nNpW14o68V7X4F1U07x3JvXOzDa171W1o4V2t >									
188 	//        <  u =="0.000000000000000001" : ] 000000249082399.079560000000000000 ; 000000266211163.588697000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000017C11D019634BC >									
190 	//     < RUSS_PFXV_II_metadata_line_15_____ENISEYSKAYA_1_BIMI_20231101 >									
191 	//        < bFCJjx1FON8i5YUV9LB9DX3ymWG6q5efdWhxt9LOZzh8s03KQYePzN10cpD51F6d >									
192 	//        <  u =="0.000000000000000001" : ] 000000266211163.588697000000000000 ; 000000285050685.443461000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000019634BC1B2F3ED >									
194 	//     < RUSS_PFXV_II_metadata_line_16_____ENISEYSKAYA_2_ORG_20231101 >									
195 	//        < HAd3oA78SfRXFUeOWO03Huh2vtD3DpTexmf0sF7CP8m2jhRU55m9l3QV0iB2LtO7 >									
196 	//        <  u =="0.000000000000000001" : ] 000000285050685.443461000000000000 ; 000000305285727.844157000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000001B2F3ED1D1D43D >									
198 	//     < RUSS_PFXV_II_metadata_line_17_____ENISEYSKAYA_2_DAO_20231101 >									
199 	//        < VR09zN4Vb145uDP9Tc2gv2WfRBqVh4cc6k8OlRfJDftKta8AJ1jCyjP54e2IpUsQ >									
200 	//        <  u =="0.000000000000000001" : ] 000000305285727.844157000000000000 ; 000000328304836.142717000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000001D1D43D1F4F414 >									
202 	//     < RUSS_PFXV_II_metadata_line_18_____ENISEYSKAYA_2_DAOPI_20231101 >									
203 	//        < LdKPIChA0W6I1S9K3h3u86tWpTEoD1V2Nviv7JSaDqeIFt8Vd8AW6zeyaghl5WB3 >									
204 	//        <  u =="0.000000000000000001" : ] 000000328304836.142717000000000000 ; 000000345327104.051000000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000001F4F41420EED66 >									
206 	//     < RUSS_PFXV_II_metadata_line_19_____ENISEYSKAYA_2_DAC_20231101 >									
207 	//        < TXzLUBeBfSr5ol19FKN5jL9McqY0N7jgFSu3AlE9X69oy8TwI5cg82TWi8YfxYix >									
208 	//        <  u =="0.000000000000000001" : ] 000000345327104.051000000000000000 ; 000000369338881.345863000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000000020EED662339100 >									
210 	//     < RUSS_PFXV_II_metadata_line_20_____ENISEYSKAYA_2_BIMI_20231101 >									
211 	//        < 0ipjRkpA9hgaU2QUVnO1en335Wo0i9FS3WdfnsRro1Yu6J6zR0Q1eXYa0g20x4Hd >									
212 	//        <  u =="0.000000000000000001" : ] 000000369338881.345863000000000000 ; 000000385479960.036502000000000000 ] >									
213 	//        < 0x00000000000000000000000000000000000000000000000000233910024C321C >									
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
256 	//     < RUSS_PFXV_II_metadata_line_21_____YENISEISKAYA_GTK_1_ORG_20231101 >									
257 	//        < uQ9l6Njppma75tn39tE5C8iOEO97X7WtZwc0j9nIp3Z291U8unU4MHZ5bJv6Hie6 >									
258 	//        <  u =="0.000000000000000001" : ] 000000385479960.036502000000000000 ; 000000401634898.818414000000000000 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000000024C321C264D8A2 >									
260 	//     < RUSS_PFXV_II_metadata_line_22_____YENISEISKAYA_GTK_1_DAO_20231101 >									
261 	//        < mp5zOG9vOx95R827yOQL9O9wTGDAAnuGD623nq2Opm5R08o17Vy4AvRH13dmH6Z9 >									
262 	//        <  u =="0.000000000000000001" : ] 000000401634898.818414000000000000 ; 000000420861284.027582000000000000 ] >									
263 	//        < 0x00000000000000000000000000000000000000000000000000264D8A22822EF0 >									
264 	//     < RUSS_PFXV_II_metadata_line_23_____YENISEISKAYA_GTK_1_DAOPI_20231101 >									
265 	//        < ifoN6UE6Oo9Kj26hTJJosDYr58ATq78JaoCa7DeD5kt1w3ffKo5y8f18wY9G7kge >									
266 	//        <  u =="0.000000000000000001" : ] 000000420861284.027582000000000000 ; 000000439213570.216807000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000002822EF029E2FCD >									
268 	//     < RUSS_PFXV_II_metadata_line_24_____YENISEISKAYA_GTK_1_DAC_20231101 >									
269 	//        < QY1F9642Pp31GGe8yG0tnY12HroFvbdLZ6w59kaBMFk8v06JHlb3hV7IC5mBHVj2 >									
270 	//        <  u =="0.000000000000000001" : ] 000000439213570.216807000000000000 ; 000000462138747.507577000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000029E2FCD2C12AF3 >									
272 	//     < RUSS_PFXV_II_metadata_line_25_____YENISEISKAYA_GTK_1_BIMI_20231101 >									
273 	//        < TO7k42LR6IaKuNe95z4wWLA8517QU62P5KDc03e28lwW3LJmu2I9n3s398FwiWwS >									
274 	//        <  u =="0.000000000000000001" : ] 000000462138747.507577000000000000 ; 000000482463460.702167000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002C12AF32E02E4A >									
276 	//     < RUSS_PFXV_II_metadata_line_26_____YENISEISKAYA_GTK_2_ORG_20231101 >									
277 	//        < 5ChtE1pHTP8XJ78vOo6eFwtaF0qykl6tpBkGIRyQAuS04EGckW4IFw88x8SBXXEw >									
278 	//        <  u =="0.000000000000000001" : ] 000000482463460.702167000000000000 ; 000000501468259.854923000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000002E02E4A2FD2E0A >									
280 	//     < RUSS_PFXV_II_metadata_line_27_____YENISEISKAYA_GTK_2_DAO_20231101 >									
281 	//        < YECXjqgV8BSt1045sV7iTVN0JtZv7o55450mm1PJrn4audICwyL191bwF1fsUtas >									
282 	//        <  u =="0.000000000000000001" : ] 000000501468259.854923000000000000 ; 000000520769537.436154000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000002FD2E0A31AA19A >									
284 	//     < RUSS_PFXV_II_metadata_line_28_____YENISEISKAYA_GTK_2_DAOPI_20231101 >									
285 	//        < pIeTQi2ek0EE9920rK2yC8njJ53692K62QfiF4yULMl8qKh52IHOs1r8P6Z48m4e >									
286 	//        <  u =="0.000000000000000001" : ] 000000520769537.436154000000000000 ; 000000537358126.520112000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000031AA19A333F185 >									
288 	//     < RUSS_PFXV_II_metadata_line_29_____YENISEISKAYA_GTK_2_DAC_20231101 >									
289 	//        < jxhj2hXM1T14Ft91QhZFm69QzLU8i1boD71d5ig27IX3FR4k4OFRVAKyscQ17Meu >									
290 	//        <  u =="0.000000000000000001" : ] 000000537358126.520112000000000000 ; 000000560227032.280930000000000000 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000000000333F185356D6AF >									
292 	//     < RUSS_PFXV_II_metadata_line_30_____YENISEISKAYA_GTK_2_BIMI_20231101 >									
293 	//        < mEQqO13HFcj0CXs0f7t2xv1Y1kUzgWNeqVa9Z5XM41qgS39TokhH18onj5BD06PZ >									
294 	//        <  u =="0.000000000000000001" : ] 000000560227032.280930000000000000 ; 000000578715546.802892000000000000 ] >									
295 	//        < 0x00000000000000000000000000000000000000000000000000356D6AF3730CC3 >									
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
338 	//     < RUSS_PFXV_II_metadata_line_31_____ZAO_ENISEY_MINING_GEOLOGIC_CO_1_ORG_20231101 >									
339 	//        < sTWP2nA6QvCv5Jv0HQg3XPj679G40A4yzF5La67b6a6gvG36CiRr911r68RNgBLb >									
340 	//        <  u =="0.000000000000000001" : ] 000000578715546.802892000000000000 ; 000000600627883.314454000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000003730CC33947C44 >									
342 	//     < RUSS_PFXV_II_metadata_line_32_____ZAO_ENISEY_MINING_GEOLOGIC_CO_1_DAO_20231101 >									
343 	//        < aPL9tLy0668d8783ll1GiQ79A30lf768T6H39cVe6Jcz1Wt2CfRs12Cbz36Lo9qi >									
344 	//        <  u =="0.000000000000000001" : ] 000000600627883.314454000000000000 ; 000000623495530.248704000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000003947C443B760F1 >									
346 	//     < RUSS_PFXV_II_metadata_line_33_____ZAO_ENISEY_MINING_GEOLOGIC_CO_1_DAOPI_20231101 >									
347 	//        < 6uZTkctd1k28N17vp3xP1Fd0btu7H870vUgf0Bk9jrSa7jOuJyiPZrGxr8dABv4M >									
348 	//        <  u =="0.000000000000000001" : ] 000000623495530.248704000000000000 ; 000000644362842.157114000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000003B760F13D7383C >									
350 	//     < RUSS_PFXV_II_metadata_line_34_____ZAO_ENISEY_MINING_GEOLOGIC_CO_1_DAC_20231101 >									
351 	//        < CNh4Nv3cl4WK88Fk4ZQl96MV68kL1S5Ap6oA00G0e7w2Y1v77cm0aOpT5KH5k40T >									
352 	//        <  u =="0.000000000000000001" : ] 000000644362842.157114000000000000 ; 000000667287848.552025000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000003D7383C3FA3351 >									
354 	//     < RUSS_PFXV_II_metadata_line_35_____ZAO_ENISEY_MINING_GEOLOGIC_CO_1_BIMI_20231101 >									
355 	//        < 4Q70h7G065uJtE5576JvSGj3Wat9cXKUOAYuwM490V4vUxTD25C8N4qSHjZvvxN8 >									
356 	//        <  u =="0.000000000000000001" : ] 000000667287848.552025000000000000 ; 000000683770335.098018000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000003FA335141359CA >									
358 	//     < RUSS_PFXV_II_metadata_line_36_____ZAO_ENISEY_MINING_GEOLOGIC_CO_2_ORG_20231101 >									
359 	//        < H13ovGFAn612d2m9bCf9ft63eDn53c55q0f1XbTFA1Yn0a5xYOWGMzoettUHY3TJ >									
360 	//        <  u =="0.000000000000000001" : ] 000000683770335.098018000000000000 ; 000000702278889.683506000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000041359CA42F97B1 >									
362 	//     < RUSS_PFXV_II_metadata_line_37_____ZAO_ENISEY_MINING_GEOLOGIC_CO_2_DAO_20231101 >									
363 	//        < Tppc951zSjQn69X0xtn185m2NCrQlC7haM8wvv34j3aZnUcmcE3U16dkfpxY8p1A >									
364 	//        <  u =="0.000000000000000001" : ] 000000702278889.683506000000000000 ; 000000719015683.185438000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000042F97B14492180 >									
366 	//     < RUSS_PFXV_II_metadata_line_38_____ZAO_ENISEY_MINING_GEOLOGIC_CO_2_DAOPI_20231101 >									
367 	//        < yu63Fw7847N70jEqh5219995d2LiuAwLU4f6AXi2mvu194axLmU07uLqWrb8w8ZB >									
368 	//        <  u =="0.000000000000000001" : ] 000000719015683.185438000000000000 ; 000000743161013.213599000000000000 ] >									
369 	//        < 0x00000000000000000000000000000000000000000000000000449218046DF945 >									
370 	//     < RUSS_PFXV_II_metadata_line_39_____ZAO_ENISEY_MINING_GEOLOGIC_CO_2_DAC_20231101 >									
371 	//        < qpOAo31dObm5exoIfsn3pywukLjEqt7h3bVI7M8l0bxqd0Su4gERnwZ2ERv9MXNy >									
372 	//        <  u =="0.000000000000000001" : ] 000000743161013.213599000000000000 ; 000000764696841.840932000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000046DF94548ED5B4 >									
374 	//     < RUSS_PFXV_II_metadata_line_40_____ZAO_ENISEY_MINING_GEOLOGIC_CO_2_BIMI_20231101 >									
375 	//        < 4o8FoiD38autlUMwnSqnBB5nwL5PcQkY0vJVJBh65e8XLs5RvfGiFQlgs2nrM28z >									
376 	//        <  u =="0.000000000000000001" : ] 000000764696841.840932000000000000 ; 000000785792764.471279000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000048ED5B44AF064C >									
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