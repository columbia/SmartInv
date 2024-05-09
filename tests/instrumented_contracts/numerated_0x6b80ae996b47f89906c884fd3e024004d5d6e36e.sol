1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXIX_II_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXIX_II_883		"	;
8 		string	public		symbol =	"	RUSS_PFXIX_II_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		799779819675914000000000000					;	
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
92 	//     < RUSS_PFXIX_II_metadata_line_1_____Eurochem_20231101 >									
93 	//        < 6G2jon10G9oGCw2qdFSqST3rT41O6TZ26xg8IqXdt4h1WNKA88ERNhI2emuqB7Ef >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000016248074.394150700000000000 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000000018CAE7 >									
96 	//     < RUSS_PFXIX_II_metadata_line_2_____Eurochem_Group_AG_Switzerland_20231101 >									
97 	//        < C0icXx9hf4i9h9rDW94kMUHFRfad7vRRHtQmNHnUCQfdGEdekxEihA1n5cv3zT5V >									
98 	//        <  u =="0.000000000000000001" : ] 000000016248074.394150700000000000 ; 000000035666879.126349700000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000018CAE7366C60 >									
100 	//     < RUSS_PFXIX_II_metadata_line_3_____Industrial _Group_Phosphorite_20231101 >									
101 	//        < owZE82wXDUfwO8kO00s55JqLYXN83ewUSHl1283P18sXJTf9O73J6zEosLB8mQ51 >									
102 	//        <  u =="0.000000000000000001" : ] 000000035666879.126349700000000000 ; 000000057186104.114267400000000000 ] >									
103 	//        < 0x0000000000000000000000000000000000000000000000000000366C60574252 >									
104 	//     < RUSS_PFXIX_II_metadata_line_4_____Novomoskovsky_Azot_20231101 >									
105 	//        < 0TxxD1EsKIWn4OeKqR6n9OxRe9dNoDER452rX5x2XyeebS0BLGexhmiPQL3Wm6u4 >									
106 	//        <  u =="0.000000000000000001" : ] 000000057186104.114267400000000000 ; 000000080321377.937928200000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000005742527A8F8A >									
108 	//     < RUSS_PFXIX_II_metadata_line_5_____Novomoskovsky_Chlor_20231101 >									
109 	//        < Tg6qVZsnfYSN3vGBUDDsfAdk0U4nlS09smI8pzI3Kq0X6PI5ru91Z2bp8v58ky0F >									
110 	//        <  u =="0.000000000000000001" : ] 000000080321377.937928200000000000 ; 000000095780241.047186100000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000007A8F8A922628 >									
112 	//     < RUSS_PFXIX_II_metadata_line_6_____Nevinnomyssky_Azot_20231101 >									
113 	//        < 6XhHW9wtP62s043i5j2U74Ly64OZOR844zvc2Yn4sPvUP5970Pq1t208Z4Rs9TCA >									
114 	//        <  u =="0.000000000000000001" : ] 000000095780241.047186100000000000 ; 000000117539260.467352000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000922628B359C6 >									
116 	//     < RUSS_PFXIX_II_metadata_line_7_____EuroChem_Belorechenskie_Minudobrenia_20231101 >									
117 	//        < 5Y2rMAstbHh1nB1imi78DZ1Nim55d45q8Af06Kx65Wg5e7b2UtLlDaX0LSlm27Sf >									
118 	//        <  u =="0.000000000000000001" : ] 000000117539260.467352000000000000 ; 000000137405765.512090000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000B359C6D1AA21 >									
120 	//     < RUSS_PFXIX_II_metadata_line_8_____Kovdorsky_GOK_20231101 >									
121 	//        < 7zXQq9VK2McpY26d02Pl28wF75E0O15tbs6fEA8Y9TR6g3Kl6Ul5GlU1RROod6jP >									
122 	//        <  u =="0.000000000000000001" : ] 000000137405765.512090000000000000 ; 000000155365259.022083000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000D1AA21ED118E >									
124 	//     < RUSS_PFXIX_II_metadata_line_9_____Lifosa_AB_20231101 >									
125 	//        < VaH5U3EteLbVN0fSLoe2Wff28G7RjJzdoucO5UixpuJuRNu97GT4US8h7YxoNm4h >									
126 	//        <  u =="0.000000000000000001" : ] 000000155365259.022083000000000000 ; 000000176791300.173900000000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000000ED118E10DC31A >									
128 	//     < RUSS_PFXIX_II_metadata_line_10_____EuroChem_Antwerpen_NV_20231101 >									
129 	//        < HMHPC86rsa1rkPW58jW1s74F7OffPQyDru53WJO9Tv8E8woHR2BA8xca74DfUOj9 >									
130 	//        <  u =="0.000000000000000001" : ] 000000176791300.173900000000000000 ; 000000198147914.615496000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000010DC31A12E5987 >									
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
174 	//     < RUSS_PFXIX_II_metadata_line_11_____EuroChem_VolgaKaliy_20231101 >									
175 	//        < lLAWsJZsPqcriuz15n0fxCi47WcSFGrkzBjVG3rn1hfntcmryw655J7ispqg0By9 >									
176 	//        <  u =="0.000000000000000001" : ] 000000198147914.615496000000000000 ; 000000218025475.319694000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000012E598714CAE34 >									
178 	//     < RUSS_PFXIX_II_metadata_line_12_____EuroChem_Usolsky_potash_complex_20231101 >									
179 	//        < 76mDO3O6BXLOt9oMEg9Ue8ApmM9fLHEICt60fyXe8hjaxpW6yv1M3KCUcV03rMIU >									
180 	//        <  u =="0.000000000000000001" : ] 000000218025475.319694000000000000 ; 000000238162016.009803000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000014CAE3416B680A >									
182 	//     < RUSS_PFXIX_II_metadata_line_13_____EuroChem_ONGK_20231101 >									
183 	//        < yRBFYH32izFt87pW9n4NdihetQMXf67W34uR589ZYFLvkGH7U60IJ6y264RyjV1M >									
184 	//        <  u =="0.000000000000000001" : ] 000000238162016.009803000000000000 ; 000000258529806.500169000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000016B680A18A7C35 >									
186 	//     < RUSS_PFXIX_II_metadata_line_14_____EuroChem_Northwest_20231101 >									
187 	//        < 1102C53YzXlo3XVDVks6SPNuk2y7cG4a3z35b16SLuLpbKv7B0uL1vl3nPEVUon6 >									
188 	//        <  u =="0.000000000000000001" : ] 000000258529806.500169000000000000 ; 000000276074391.399132000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000018A7C351A5418F >									
190 	//     < RUSS_PFXIX_II_metadata_line_15_____EuroChem_Fertilizers_20231101 >									
191 	//        < M4n8261vqS5FN1TyOZRrl80957sq2nY5Tl7DikQzNLx9KNaRvow923YBpR9N0Pe0 >									
192 	//        <  u =="0.000000000000000001" : ] 000000276074391.399132000000000000 ; 000000300736000.701019000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000001A5418F1CAE300 >									
194 	//     < RUSS_PFXIX_II_metadata_line_16_____Astrakhan_Oil_and_Gas_Company_20231101 >									
195 	//        < 51Y8Jfd1Oca9h3sGb6p8K38p5d5C2f22ePbtg672b01k50g9WzNGiFrXQl1QjIZZ >									
196 	//        <  u =="0.000000000000000001" : ] 000000300736000.701019000000000000 ; 000000321990400.596184000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000001CAE3001EB5180 >									
198 	//     < RUSS_PFXIX_II_metadata_line_17_____Sary_Tas_Fertilizers_20231101 >									
199 	//        < OjV8dypG9A01lx1CWBZpl203J455InzNlGaSu89s21z5TTQ0p3o98cKAci018eQE >									
200 	//        <  u =="0.000000000000000001" : ] 000000321990400.596184000000000000 ; 000000343065524.779996000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000001EB518020B79F8 >									
202 	//     < RUSS_PFXIX_II_metadata_line_18_____EuroChem_Karatau_20231101 >									
203 	//        < 9nT3c195f2eta34KTD30iUa77RS02e1J2PMEir8gk7949EnU6619w7G373Ypubvn >									
204 	//        <  u =="0.000000000000000001" : ] 000000343065524.779996000000000000 ; 000000361932830.643408000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000020B79F82284403 >									
206 	//     < RUSS_PFXIX_II_metadata_line_19_____Kamenkovskaya_Oil_Gas_Company_20231101 >									
207 	//        < VAyg6imJUStpGQ2RjD9P23qA3iTJ5Rw60JW8kAl12N8MK52O31sP7lKViHs3Uo75 >									
208 	//        <  u =="0.000000000000000001" : ] 000000361932830.643408000000000000 ; 000000385461474.438773000000000000 ] >									
209 	//        < 0x00000000000000000000000000000000000000000000000000228440324C2AE3 >									
210 	//     < RUSS_PFXIX_II_metadata_line_20_____EuroChem_Trading_GmbH_Trading_20231101 >									
211 	//        < Yv2M1YY3U5inMqp87Vhf67mMVdjF3laTd8Ss2WpGl9mu6dVfY54EoMc8f1CE66a3 >									
212 	//        <  u =="0.000000000000000001" : ] 000000385461474.438773000000000000 ; 000000408196116.472465000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000024C2AE326EDB9C >									
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
256 	//     < RUSS_PFXIX_II_metadata_line_21_____EuroChem_Trading_USA_Corp_20231101 >									
257 	//        < 423PhRNkQGqaCFgDbKr2K24BOG0J6nc2bn1A353Bs83c2twAr67novV0m0JpSgTu >									
258 	//        <  u =="0.000000000000000001" : ] 000000408196116.472465000000000000 ; 000000424064809.736016000000000000 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000000026EDB9C2871251 >									
260 	//     < RUSS_PFXIX_II_metadata_line_22_____Ben_Trei_Ltd_20231101 >									
261 	//        < 849qWSDXrSN99XM9n6b54dzkOujo5C94CNSmxTpvKHWJ1x4T3YsGBy1QEG426X6L >									
262 	//        <  u =="0.000000000000000001" : ] 000000424064809.736016000000000000 ; 000000445001255.768114000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000028712512A7049E >									
264 	//     < RUSS_PFXIX_II_metadata_line_23_____EuroChem_Agro_SAS_20231101 >									
265 	//        < AgGABcb34zvBjQW0iZgsFAw8tAaLoHKxq6W5Wg93qmkvQZ4QNrg7gN10Ip3jGDF6 >									
266 	//        <  u =="0.000000000000000001" : ] 000000445001255.768114000000000000 ; 000000466634960.934564000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000002A7049E2C80748 >									
268 	//     < RUSS_PFXIX_II_metadata_line_24_____EuroChem_Agro_Asia_20231101 >									
269 	//        < uQElR5VYs0sbojPBhB3tCnDoMmg1Sfi8qIi8F2dv8ZNK3jDT7t8A688LF14ZLt9j >									
270 	//        <  u =="0.000000000000000001" : ] 000000466634960.934564000000000000 ; 000000487746551.806516000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000002C807482E83DFF >									
272 	//     < RUSS_PFXIX_II_metadata_line_25_____EuroChem_Agro_Iberia_20231101 >									
273 	//        < JH23rpVyAlR1BQ476O2k2143kA4Q3R1knVC0s7bGQfZuJ1rYQ2n4dJ6TF62XQ6hq >									
274 	//        <  u =="0.000000000000000001" : ] 000000487746551.806516000000000000 ; 000000507029406.793290000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002E83DFF305AA5D >									
276 	//     < RUSS_PFXIX_II_metadata_line_26_____EuroChem_Agricultural_Trading_Hellas_20231101 >									
277 	//        < UIY5A233kvN0kFvpMkhYguds8sNpHzTCIvi0tC1aIa86NTpd89v6j27tR728crvo >									
278 	//        <  u =="0.000000000000000001" : ] 000000507029406.793290000000000000 ; 000000527188154.930884000000000000 ] >									
279 	//        < 0x00000000000000000000000000000000000000000000000000305AA5D3246CDF >									
280 	//     < RUSS_PFXIX_II_metadata_line_27_____EuroChem_Agro_Spa_20231101 >									
281 	//        < 8KH45555TGK6ZBi2Zj3QTgC1pCRMNy5sb17CV9C6g04KZov5ajh3cBlmhUbfMM46 >									
282 	//        <  u =="0.000000000000000001" : ] 000000527188154.930884000000000000 ; 000000546272286.535815000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000003246CDF3418B9D >									
284 	//     < RUSS_PFXIX_II_metadata_line_28_____EuroChem_Agro_GmbH_20231101 >									
285 	//        < jbATacuB0io59CHIT8CGfYUpQt4c3ecGZ49QJ5EP9Unx13h6YnC89469Y3Y5ik6z >									
286 	//        <  u =="0.000000000000000001" : ] 000000546272286.535815000000000000 ; 000000564111631.346470000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000003418B9D35CC41B >									
288 	//     < RUSS_PFXIX_II_metadata_line_29_____EuroChem_Agro_México_SA_20231101 >									
289 	//        < kAKjh686J6FUEY1vrOmI4v5CdM48292KNo9FSlwwMVUO7EsJyapfxQCit7hoF1rv >									
290 	//        <  u =="0.000000000000000001" : ] 000000564111631.346470000000000000 ; 000000587514980.495516000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000035CC41B3807A0A >									
292 	//     < RUSS_PFXIX_II_metadata_line_30_____EuroChem_Agro_Hungary_Kft_20231101 >									
293 	//        < 1lFz5LardO06WIS61cdT69IPs4ub6mo0NxH0Y4yRGEMv0Cu6G5399GfC8tSJ8O5p >									
294 	//        <  u =="0.000000000000000001" : ] 000000587514980.495516000000000000 ; 000000607821351.880292000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000003807A0A39F7637 >									
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
338 	//     < RUSS_PFXIX_II_metadata_line_31_____Agrocenter_EuroChem_Srl_20231101 >									
339 	//        < wt541lnrNejtd9IrwA9xxXbBU1y6k9n2PuVqQqnygK6FwQgG9ggAH8pfwy8BkSX6 >									
340 	//        <  u =="0.000000000000000001" : ] 000000607821351.880292000000000000 ; 000000623707193.031572000000000000 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000000000039F76373B7B39F >									
342 	//     < RUSS_PFXIX_II_metadata_line_32_____EuroChem_Agro_Bulgaria_Ead_20231101 >									
343 	//        < 4464uL8YkhBZfS3w78119c3aSpl7j9Ns9egHn0ai79Nt0z350ByAGL4L2UddU19P >									
344 	//        <  u =="0.000000000000000001" : ] 000000623707193.031572000000000000 ; 000000641099691.584319000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000003B7B39F3D23D91 >									
346 	//     < RUSS_PFXIX_II_metadata_line_33_____EuroChem_Agro_doo_Beograd_20231101 >									
347 	//        < 596PM8ocJy7at35b9K91ShRo1d1xmxC93quDRxe8311bnXE5jfLq3Y3KV9SHT80v >									
348 	//        <  u =="0.000000000000000001" : ] 000000641099691.584319000000000000 ; 000000664745715.337665000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000003D23D913F6524C >									
350 	//     < RUSS_PFXIX_II_metadata_line_34_____EuroChem_Agro_Turkey_Tarim_Sanayi_ve_Ticaret_20231101 >									
351 	//        < 4o47EW0gw9ui4yT4zKnl983izugr6NkoMrv43JMIrfc18YqjTMFy4HCheVltk3Fs >									
352 	//        <  u =="0.000000000000000001" : ] 000000664745715.337665000000000000 ; 000000681978110.694123000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000003F6524C4109DB3 >									
354 	//     < RUSS_PFXIX_II_metadata_line_35_____Emerger_Fertilizantes_SA_20231101 >									
355 	//        < YTu279L6QE11045GJHrx8qpDZH4j5cRP1LT3Jyq99Zm3yc6deJlh407My8vbD17m >									
356 	//        <  u =="0.000000000000000001" : ] 000000681978110.694123000000000000 ; 000000700649850.842244000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000004109DB342D1B59 >									
358 	//     < RUSS_PFXIX_II_metadata_line_36_____EuroChem_Comercio_Produtos_Quimicos_20231101 >									
359 	//        < 6ifwB4D0KcyGGSo872acpkCS7dwKRkCiq9O0rv64FwFycMOsO1K9YiGzr85kS64t >									
360 	//        <  u =="0.000000000000000001" : ] 000000700649850.842244000000000000 ; 000000720782307.704790000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000042D1B5944BD397 >									
362 	//     < RUSS_PFXIX_II_metadata_line_37_____Fertilizantes_Tocantines_Ltda_20231101 >									
363 	//        < AMQC7AI37Mi7yZky1obb6i24965bszx8Eq2204Vv12vDEZ6842O9Zj9U3zW3DSJn >									
364 	//        <  u =="0.000000000000000001" : ] 000000720782307.704790000000000000 ; 000000739987346.518404000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000044BD397469218F >									
366 	//     < RUSS_PFXIX_II_metadata_line_38_____EuroChem_Agro_Trading_Shenzhen_20231101 >									
367 	//        < QdoRnxDif1yK3pk9jY3LjTr6O9k9vT0J5enwU90E5HqWnnkC60489HFLHlgEY0Ba >									
368 	//        <  u =="0.000000000000000001" : ] 000000739987346.518404000000000000 ; 000000759546008.317442000000000000 ] >									
369 	//        < 0x00000000000000000000000000000000000000000000000000469218F486F9A9 >									
370 	//     < RUSS_PFXIX_II_metadata_line_39_____EuroChem_Trading_RUS_20231101 >									
371 	//        < r7nd5CQguaz83223bb83dBw8X7s7jH3F62av6Y0g91u489qCtI9q2GSr552FhYyD >									
372 	//        <  u =="0.000000000000000001" : ] 000000759546008.317442000000000000 ; 000000783554558.284806000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000486F9A94AB9C00 >									
374 	//     < RUSS_PFXIX_II_metadata_line_40_____AgroCenter_EuroChem_Ukraine_20231101 >									
375 	//        < EXnd8uy31vds7644Ah770Oi08SWyfIYb0bw8urn1u1YEP1JVX8MKSLuLfB7oTffa >									
376 	//        <  u =="0.000000000000000001" : ] 000000783554558.284806000000000000 ; 000000799779819.675914000000000000 ] >									
377 	//        < 0x000000000000000000000000000000000000000000000000004AB9C004C45DFE >									
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