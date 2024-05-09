1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXXVI_II_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXXVI_II_883		"	;
8 		string	public		symbol =	"	RUSS_PFXXVI_II_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		769120423719425000000000000					;	
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
92 	//     < RUSS_PFXXVI_II_metadata_line_1_____BLUE_STREAM_PIPE_CO_20231101 >									
93 	//        < FWb0oPDiu4dQUgyCeS8TknZ6KSdlWc7j6v2I0ZUDw77H2MO106B10fEVe3qJNN95 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000017868734.624426400000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000001B43F9 >									
96 	//     < RUSS_PFXXVI_II_metadata_line_2_____BLUESTREAM_DAO_20231101 >									
97 	//        < IEse27L0Im2PM04Bp56zq1TS405Hr85VO53gMz3v0M3itEUz4rv9eV71s2gKF20B >									
98 	//        <  u =="0.000000000000000001" : ] 000000017868734.624426400000000000 ; 000000040175797.792688400000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000001B43F93D4DAC >									
100 	//     < RUSS_PFXXVI_II_metadata_line_3_____BLUESTREAM_DAOPI_20231101 >									
101 	//        < 3f6A7QQpB6fN546n7nHJP1J5x8QQxdA29xk47srwg8siN1W626488K28r1k63ba8 >									
102 	//        <  u =="0.000000000000000001" : ] 000000040175797.792688400000000000 ; 000000055594972.295531200000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000003D4DAC54D4C9 >									
104 	//     < RUSS_PFXXVI_II_metadata_line_4_____BLUESTREAM_DAC_20231101 >									
105 	//        < r4o9P9yWkaw5WDlu4S31478FSZjsA4nwwhcm1O9JV2DsUV4lx2Y11yx201uFyRfL >									
106 	//        <  u =="0.000000000000000001" : ] 000000055594972.295531200000000000 ; 000000076714935.008278300000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000054D4C9750EC6 >									
108 	//     < RUSS_PFXXVI_II_metadata_line_5_____BLUESTREAM_BIMI_20231101 >									
109 	//        < tC8Bf28d5fHUQa0a972aPc3vR5flC6IaMBF3Sg5JjcFvu05Pxa6IUJb6tEsvS3k2 >									
110 	//        <  u =="0.000000000000000001" : ] 000000076714935.008278300000000000 ; 000000092223027.458686200000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000750EC68CB89F >									
112 	//     < RUSS_PFXXVI_II_metadata_line_6_____PANRUSGAZ_20231101 >									
113 	//        < 10OxFe0Io9TBYhQi3wKj4Sxukk4TYBaHfBKw6vmpq5S243TI94ozPN902gc3RJKu >									
114 	//        <  u =="0.000000000000000001" : ] 000000092223027.458686200000000000 ; 000000109568515.711387000000000000 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000000000008CB89FA73034 >									
116 	//     < RUSS_PFXXVI_II_metadata_line_7_____OKHRANA_PSC_20231101 >									
117 	//        < SXh0DlJMf9jHkn7094K535Ng7Ee0C8191sLbI5y4Mdlog0W5izUQrVznzu40RxuZ >									
118 	//        <  u =="0.000000000000000001" : ] 000000109568515.711387000000000000 ; 000000127258827.416919000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000A73034C22E7B >									
120 	//     < RUSS_PFXXVI_II_metadata_line_8_____PROEKTIROVANYE_OOO_20231101 >									
121 	//        < 8911DGQ6d1t0IUJhA57DvcwmQKIA3uD9Pr0tR7H5aA5ga1hNw7LlRVKmG7Hfi4O1 >									
122 	//        <  u =="0.000000000000000001" : ] 000000127258827.416919000000000000 ; 000000151832734.790328000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000C22E7BE7ADA9 >									
124 	//     < RUSS_PFXXVI_II_metadata_line_9_____YUGOROSGAZ_20231101 >									
125 	//        < i91D9hg43X1iSxF43qnTdk525zyaaT0tB9t9DRD60J6aeS5qic4N9uWUbhHvieU7 >									
126 	//        <  u =="0.000000000000000001" : ] 000000151832734.790328000000000000 ; 000000170262842.874408000000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000000E7ADA9103CCEC >									
128 	//     < RUSS_PFXXVI_II_metadata_line_10_____GAZPROM_FINANCE_BV_20231101 >									
129 	//        < Uh5Z1B2mRLR3V3X8tE9P2Dk0na6T24u547f7N6336neh0z46INQgrU4i0m5HFd4S >									
130 	//        <  u =="0.000000000000000001" : ] 000000170262842.874408000000000000 ; 000000193568625.196509000000000000 ] >									
131 	//        < 0x00000000000000000000000000000000000000000000000000103CCEC1275CBF >									
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
174 	//     < RUSS_PFXXVI_II_metadata_line_11_____WINTERSHALL_NOORDZEE_BV_20231101 >									
175 	//        < Bc1cxsiD91Q6vbTd76v1TXpE0nQ4Znr8rBcmBJN1ChalKmC617uNj2axgN79KxKR >									
176 	//        <  u =="0.000000000000000001" : ] 000000193568625.196509000000000000 ; 000000211463275.020702000000000000 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000000001275CBF142AAD8 >									
178 	//     < RUSS_PFXXVI_II_metadata_line_12_____WINTERSHALL_DAO_20231101 >									
179 	//        < v35bArdg0w9kXn545YVV319Ak3KkDVk19xOPChsKjw5a0YpeY8nb496bOw473D42 >									
180 	//        <  u =="0.000000000000000001" : ] 000000211463275.020702000000000000 ; 000000230153411.225504000000000000 ] >									
181 	//        < 0x00000000000000000000000000000000000000000000000000142AAD815F2FAD >									
182 	//     < RUSS_PFXXVI_II_metadata_line_13_____WINTERSHALL_DAOPI_20231101 >									
183 	//        < TKxfIEgmqilF6m33PZVk4KOTVW8M0rNm8J33fW6zhm9zMkDmhOV0j9M1tZBf6678 >									
184 	//        <  u =="0.000000000000000001" : ] 000000230153411.225504000000000000 ; 000000245816517.278960000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000015F2FAD1771614 >									
186 	//     < RUSS_PFXXVI_II_metadata_line_14_____WINTERSHALL_DAC_20231101 >									
187 	//        < c35hvZpU40L2tK0fEK09vtz716UZg5lXKVR3qMdVa1KbnL7fj1MVqvm5fiWue8MM >									
188 	//        <  u =="0.000000000000000001" : ] 000000245816517.278960000000000000 ; 000000264741701.625890000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000001771614193F6BA >									
190 	//     < RUSS_PFXXVI_II_metadata_line_15_____WINTERSHALL_BIMI_20231101 >									
191 	//        < 52SMpWbd8U6OH8S80EEyM5LimgskILTc8hYDU8umsi4f69rGFokw81m2p4l93P6U >									
192 	//        <  u =="0.000000000000000001" : ] 000000264741701.625890000000000000 ; 000000281814523.780066000000000000 ] >									
193 	//        < 0x00000000000000000000000000000000000000000000000000193F6BA1AE03CC >									
194 	//     < RUSS_PFXXVI_II_metadata_line_16_____SAKHALIN_HOLDINGS_BV_20231101 >									
195 	//        < r2N6VcOl95MFQD9z0OA3wk5CLc9Dt30SL5UddS8EEL6a9Oo105PNd3e591X34G4d >									
196 	//        <  u =="0.000000000000000001" : ] 000000281814523.780066000000000000 ; 000000302615412.989228000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000001AE03CC1CDC125 >									
198 	//     < RUSS_PFXXVI_II_metadata_line_17_____TRANSGAS_KAZAN_20231101 >									
199 	//        < Ozbf1nZ574dKn9HjN7V57ro1x2crQ16AS8dCun0E6gdxOB5S95qcVoC1LtJkvBl5 >									
200 	//        <  u =="0.000000000000000001" : ] 000000302615412.989228000000000000 ; 000000321166661.335245000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000001CDC1251EA0FBA >									
202 	//     < RUSS_PFXXVI_II_metadata_line_18_____SOUTH_STREAM_SERBIA_20231101 >									
203 	//        < iv2GO2eQ5blV3m093phI4Tb117RYa9BGcIk0YlL58iWe7e3Ge63h6NC7dWshf9X1 >									
204 	//        <  u =="0.000000000000000001" : ] 000000321166661.335245000000000000 ; 000000341718490.098023000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000001EA0FBA2096BC9 >									
206 	//     < RUSS_PFXXVI_II_metadata_line_19_____WINTERSHALL_ERDGAS_HANDELSHAUS_ZUG_AG_20231101 >									
207 	//        < DledGw7a7Nz3E2prTumKpJFg5I0AFOX5O3wIcoy8473376VdHO40Ko42r13SBSeK >									
208 	//        <  u =="0.000000000000000001" : ] 000000341718490.098023000000000000 ; 000000359293367.070677000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000002096BC92243CF9 >									
210 	//     < RUSS_PFXXVI_II_metadata_line_20_____TRANSGAZ_MOSCOW_OOO_20231101 >									
211 	//        < 8a1Y3wYH45B7lwX0mei6NIFa16W5IxDo9QEn33e9JPcaFA5R775uNGyJDNf0Z0rI >									
212 	//        <  u =="0.000000000000000001" : ] 000000359293367.070677000000000000 ; 000000378301264.438315000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000002243CF92413DEE >									
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
256 	//     < RUSS_PFXXVI_II_metadata_line_21_____PERERABOTKA_20231101 >									
257 	//        < B9L60Vyv5I1qe0TsvkUF0CEIObT9aUb7Y1IhCCE6Uu76DBoI4657z56j5YMRd86e >									
258 	//        <  u =="0.000000000000000001" : ] 000000378301264.438315000000000000 ; 000000398829675.934494000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000002413DEE26090D8 >									
260 	//     < RUSS_PFXXVI_II_metadata_line_22_____GAZPROM_EXPORT_20231101 >									
261 	//        < Sycd2C15Udvq7ppQ4CKb3AFT6C4fS0ppcWfkrB54X77g818Knc8pzACpR9DL01Dq >									
262 	//        <  u =="0.000000000000000001" : ] 000000398829675.934494000000000000 ; 000000419436425.739025000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000026090D8280025B >									
264 	//     < RUSS_PFXXVI_II_metadata_line_23_____WINGAS_20231101 >									
265 	//        < 11jK80i600SgVYi7C2jyV51huGrZIAU00pb4Ul2x72z71MUo4xuK0B9Y9pMgUc2v >									
266 	//        <  u =="0.000000000000000001" : ] 000000419436425.739025000000000000 ; 000000434854115.600797000000000000 ] >									
267 	//        < 0x00000000000000000000000000000000000000000000000000280025B29788E4 >									
268 	//     < RUSS_PFXXVI_II_metadata_line_24_____DOBYCHA_URENGOY_20231101 >									
269 	//        < n34YJ6hQ3A0R9f5Km8Wo902nq6wJJ3cMPqUAu5IeG1mWJHPd0EdS5dXt19p4k1i8 >									
270 	//        <  u =="0.000000000000000001" : ] 000000434854115.600797000000000000 ; 000000458795822.279469000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000029788E42BC111E >									
272 	//     < RUSS_PFXXVI_II_metadata_line_25_____MOSENERGO_20231101 >									
273 	//        < Cu1zd9d7ms5s3xB944dy802perDBXMg8Wdo5y03MG2v8gAwM3C65V5VO842t2G1W >									
274 	//        <  u =="0.000000000000000001" : ] 000000458795822.279469000000000000 ; 000000475143362.866011000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002BC111E2D502E0 >									
276 	//     < RUSS_PFXXVI_II_metadata_line_26_____OGK_2_AB_20231101 >									
277 	//        < 6IJH833Y0u6Z3EU6N590qq5uZ8vwn3w89Arcc57S87Lhg9g31bQD18iXl9oMbx7Q >									
278 	//        <  u =="0.000000000000000001" : ] 000000475143362.866011000000000000 ; 000000495122880.677946000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000002D502E02F37F60 >									
280 	//     < RUSS_PFXXVI_II_metadata_line_27_____TGC_1_20231101 >									
281 	//        < 00dn6XH65IdEl8VhAjpjiY3MtMo3gFCg7Z5E9d9IDhBY1KckC8r1X8mqX4Z3Xki8 >									
282 	//        <  u =="0.000000000000000001" : ] 000000495122880.677946000000000000 ; 000000511220999.595797000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000002F37F6030C0FB4 >									
284 	//     < RUSS_PFXXVI_II_metadata_line_28_____GAZPROM_MEDIA_20231101 >									
285 	//        < vhphUS9gcQ8nF5130E7cjSp1U308E63oOsdyMsxZozEUxE6ZMy9E0Tfj2gA3HBP6 >									
286 	//        <  u =="0.000000000000000001" : ] 000000511220999.595797000000000000 ; 000000529085912.922383000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000030C0FB4327522F >									
288 	//     < RUSS_PFXXVI_II_metadata_line_29_____ENERGOHOLDING_LLC_20231101 >									
289 	//        < Ax4Yt9C3Rs0B1904U6DM6A9Z0EqVs9f8850xz70u3soA04DalCzs7HD4delYhWX1 >									
290 	//        <  u =="0.000000000000000001" : ] 000000529085912.922383000000000000 ; 000000551931448.827089000000000000 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000000000327522F34A2E39 >									
292 	//     < RUSS_PFXXVI_II_metadata_line_30_____TRANSGAZ_TOMSK_OOO_20231101 >									
293 	//        < NsLYMU511476v8xcr9M7y873IzsuI44Yi0TS852k5MB3wiApXb860F08lYlrKwzx >									
294 	//        <  u =="0.000000000000000001" : ] 000000551931448.827089000000000000 ; 000000575690060.595997000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000034A2E3936E6EEE >									
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
338 	//     < RUSS_PFXXVI_II_metadata_line_31_____DOBYCHA_YAMBURG_20231101 >									
339 	//        < 6Zqf0R0pm0WZQycBsi34GcHBeTTpOap0e4FHpPTkQ7tUEEq3FT5UU3d11zNE28kd >									
340 	//        <  u =="0.000000000000000001" : ] 000000575690060.595997000000000000 ; 000000595126654.026952000000000000 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000000000036E6EEE38C1759 >									
342 	//     < RUSS_PFXXVI_II_metadata_line_32_____YAMBURG_DAO_20231101 >									
343 	//        < CXqu854wexIU5ZR8241Oni2hdZRQ2XpM5k2f41lKxN14Vl25Nked32XMKOYwlj2D >									
344 	//        <  u =="0.000000000000000001" : ] 000000595126654.026952000000000000 ; 000000611654503.160962000000000000 ] >									
345 	//        < 0x0000000000000000000000000000000000000000000000000038C17593A54F8A >									
346 	//     < RUSS_PFXXVI_II_metadata_line_33_____YAMBURG_DAOPI_20231101 >									
347 	//        < BuRVjpTrYooEUwH7U05CFt7K0J375uxN27U24l6YS2FbWueDob67116tRCMWZpQ2 >									
348 	//        <  u =="0.000000000000000001" : ] 000000611654503.160962000000000000 ; 000000632459019.178094000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000003A54F8A3C50E4E >									
350 	//     < RUSS_PFXXVI_II_metadata_line_34_____YAMBURG_DAC_20231101 >									
351 	//        < n4y57Gmyd66ZWlEdDb386sbKbPGvTt3C831r2ENBkZrUASb7Z6Yr4BB4IOcKRDhh >									
352 	//        <  u =="0.000000000000000001" : ] 000000632459019.178094000000000000 ; 000000655049095.568018000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000003C50E4E3E7868E >									
354 	//     < RUSS_PFXXVI_II_metadata_line_35_____YAMBURG_BIMI_20231101 >									
355 	//        < I88p4yaYsZ89B8TMTPQ4qWw64fGX21FFDk67wZi7Bqqw5HXAUdOjDKQq5ns7XO6p >									
356 	//        <  u =="0.000000000000000001" : ] 000000655049095.568018000000000000 ; 000000679273789.677686000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000003E7868E40C7D53 >									
358 	//     < RUSS_PFXXVI_II_metadata_line_36_____EP_INTERNATIONAL_BV_20231101 >									
359 	//        < 1H979gIQQM8Fn1ll02BKb66m33p05tKf89Altd7XbX5xWWWCDp3Dxql76771C7PQ >									
360 	//        <  u =="0.000000000000000001" : ] 000000679273789.677686000000000000 ; 000000695758234.633372000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000040C7D53425A48F >									
362 	//     < RUSS_PFXXVI_II_metadata_line_37_____TRANSGAZ_YUGORSK_20231101 >									
363 	//        < FGri4hWkTr0XXe1Ce5RSQ56s4N4J9OljTiIi333G3tSBQeq1k68xwAdcRl10BJ0S >									
364 	//        <  u =="0.000000000000000001" : ] 000000695758234.633372000000000000 ; 000000714900660.911152000000000000 ] >									
365 	//        < 0x00000000000000000000000000000000000000000000000000425A48F442DA12 >									
366 	//     < RUSS_PFXXVI_II_metadata_line_38_____GAZPROM_GERMANIA_20231101 >									
367 	//        < kpBWjknE7E4U7H00F3V114HL2pMj7cmGMG16ZOUgyh4V9bZywwd6T4Zqi4qSuYi1 >									
368 	//        <  u =="0.000000000000000001" : ] 000000714900660.911152000000000000 ; 000000734524058.293910000000000000 ] >									
369 	//        < 0x00000000000000000000000000000000000000000000000000442DA12460CB76 >									
370 	//     < RUSS_PFXXVI_II_metadata_line_39_____GAZPROMENERGO_20231101 >									
371 	//        < 5rP1PS7YFp981X0IlZ23860o5fgfz60F8WrTxgzTM9spM63uObx58sKl38a5z8SD >									
372 	//        <  u =="0.000000000000000001" : ] 000000734524058.293910000000000000 ; 000000752779715.616834000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000460CB7647CA694 >									
374 	//     < RUSS_PFXXVI_II_metadata_line_40_____INDUSTRIJA_SRBIJE_20231101 >									
375 	//        < 99AtRNS3XQXO6ftABBoJsTo80l598bjAiCAA24iPwk9YuFlk73U4Tlp99v5X1xQM >									
376 	//        <  u =="0.000000000000000001" : ] 000000752779715.616834000000000000 ; 000000769120423.719425000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000047CA69449595AA >									
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