1 pragma solidity 		^0.4.25	;						
2 										
3 	contract	CHEMCHINA_PFVII_II_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	CHEMCHINA_PFVII_II_883		"	;
8 		string	public		symbol =	"	CHEMCHINA_PFVII_II_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		639925018567807000000000000					;	
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
92 	//     < CHEMCHINA_PFVII_II_metadata_line_1_____Taizhou_Creating_Chemical_Co_Limited_20240321 >									
93 	//        < 871Q7M0xhk88i2mOV73XqA4H9X00IZlILK89ZUFdWDNf1TL2O4jAtHdSJyapZ0A1 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000015327686.841937000000000000 ] >									
95 	//        < 0x0000000000000000000000000000000000000000000000000000000000176361 >									
96 	//     < CHEMCHINA_PFVII_II_metadata_line_2_____Tetrahedron_Scientific_Inc_20240321 >									
97 	//        < c18s21mF025euL8ya3549hbAee8i65516VP3Nb1OLRYV6Gfb8Ugtosa8P3LuSy3P >									
98 	//        <  u =="0.000000000000000001" : ] 000000015327686.841937000000000000 ; 000000032019790.130029500000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000017636130DBBB >									
100 	//     < CHEMCHINA_PFVII_II_metadata_line_3_____Tianjin_Boai_NKY_International_Limited_20240321 >									
101 	//        < 8BpVzIx8gN1V69vw0D32Xb39mVR1yz92k36KCc1v6EdUMqt68Aq3r3c1Bb8W1dvt >									
102 	//        <  u =="0.000000000000000001" : ] 000000032019790.130029500000000000 ; 000000048706246.550719200000000000 ] >									
103 	//        < 0x000000000000000000000000000000000000000000000000000030DBBB4A51E1 >									
104 	//     < CHEMCHINA_PFVII_II_metadata_line_4_____Tianjin_Boron_PharmaTech_Co__Limited_20240321 >									
105 	//        < 30qC2ceO9m9c80W02d1IPTr1T5847xUsGK7RR5LkM7Xc375V2ByuShsw0t1D4h6a >									
106 	//        <  u =="0.000000000000000001" : ] 000000048706246.550719200000000000 ; 000000065201419.823025500000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000004A51E1637D4E >									
108 	//     < CHEMCHINA_PFVII_II_metadata_line_5_____TianJin_HuiQuan_Chemical_Industry_Co_Limited_20240321 >									
109 	//        < 4w2go3TMny5004i2L3GtchwM8t0ZE6N1mY8iWu8xoyG4lf01JQ735rR4vmW7n8R1 >									
110 	//        <  u =="0.000000000000000001" : ] 000000065201419.823025500000000000 ; 000000080075630.302174300000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000637D4E7A2F8B >									
112 	//     < CHEMCHINA_PFVII_II_metadata_line_6_____Tianjin_McEIT_Co_Limited_20240321 >									
113 	//        < pCikWAyNY0X81M3qAna5TN48krjFhtITKqdo5v7oQ6eOK4lF8ky4NW80S32b15s1 >									
114 	//        <  u =="0.000000000000000001" : ] 000000080075630.302174300000000000 ; 000000095955815.855138800000000000 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000000000007A2F8B926ABE >									
116 	//     < CHEMCHINA_PFVII_II_metadata_line_7_____Tianjin_Norland_Biotech_org_20240321 >									
117 	//        < c8z3lGEPA4Rnbx5F21GS6DD70mk6RFd70qTMnJA03WTi4DE99JlpwLu02NPQr6x1 >									
118 	//        <  u =="0.000000000000000001" : ] 000000095955815.855138800000000000 ; 000000112649972.791570000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000926ABEABE3E5 >									
120 	//     < CHEMCHINA_PFVII_II_metadata_line_8_____Tianjin_Norland_Biotech_Co_Limited_20240321 >									
121 	//        < txIGnp9N95s6w9GasYdDn8GKkDTr21DJ6vSP28UcznM5Ob2E1LBfCLIg41zniwSc >									
122 	//        <  u =="0.000000000000000001" : ] 000000112649972.791570000000000000 ; 000000128149201.816878000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000ABE3E5C38A48 >									
124 	//     < CHEMCHINA_PFVII_II_metadata_line_9_____Tianjin_Tiandingren_Technology_Co_Limited_20240321 >									
125 	//        < Po652JJ1JKHXwGkJLSWZ1TFC8qZ9513g8ovvEMRO7DB7eWDF9C4PPlqPQ8O06VT4 >									
126 	//        <  u =="0.000000000000000001" : ] 000000128149201.816878000000000000 ; 000000143407615.500441000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000000C38A48DAD29A >									
128 	//     < CHEMCHINA_PFVII_II_metadata_line_10_____TOP_FINE_CHEM_20240321 >									
129 	//        < fmkbJX58ry62r38kXbM4Fhbc0xe1mBP1p1Bu8GcR5InCGsLEOe24E1U1tL33mGUv >									
130 	//        <  u =="0.000000000000000001" : ] 000000143407615.500441000000000000 ; 000000160191921.660074000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000000DAD29AF46EF8 >									
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
174 	//     < CHEMCHINA_PFVII_II_metadata_line_11_____Trust_We_Co__Limited_20240321 >									
175 	//        < EogUdY2i86hZ4Bd625uWcfejimoq74e9Zi1f26Mj3Quk0mb7R8l8LhmygqYIUPfz >									
176 	//        <  u =="0.000000000000000001" : ] 000000160191921.660074000000000000 ; 000000175771228.696114000000000000 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000000000F46EF810C34A3 >									
178 	//     < CHEMCHINA_PFVII_II_metadata_line_12_____Unispec_Chemicals_Co__20240321 >									
179 	//        < 5xrc5t7n66j2LwmT3FwI5t8RMX30qJicEh2t8jPT51SB8ASU8684e2vhQ6e8oNZ8 >									
180 	//        <  u =="0.000000000000000001" : ] 000000175771228.696114000000000000 ; 000000191190887.499471000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000010C34A3123BBF1 >									
182 	//     < CHEMCHINA_PFVII_II_metadata_line_13_____Varnor_Chemical_Co_Limited_20240321 >									
183 	//        < gQ376hjnWH83bu3rm59MtNXE148FWVzvpDXuPCaNtcgz923tc620W336g4Ye318D >									
184 	//        <  u =="0.000000000000000001" : ] 000000191190887.499471000000000000 ; 000000206806701.834199000000000000 ] >									
185 	//        < 0x00000000000000000000000000000000000000000000000000123BBF113B8FDE >									
186 	//     < CHEMCHINA_PFVII_II_metadata_line_14_____VEGSCI,_inc__20240321 >									
187 	//        < RiNmv2QQC879Jlh064x2LZZ4xZVzVpLWtz1JWhcWgGkJ3g8mBTefvaSJ9r8eWV2K >									
188 	//        <  u =="0.000000000000000001" : ] 000000206806701.834199000000000000 ; 000000224421460.504361000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000013B8FDE15670A2 >									
190 	//     < CHEMCHINA_PFVII_II_metadata_line_15_____Vesino_Industrial_Co__Limited_20240321 >									
191 	//        < xO1HkH4KiIgp0RuUawEWocgk7uYm1I7erHXEm3o1kQjv47hv5exg8m4ywq005160 >									
192 	//        <  u =="0.000000000000000001" : ] 000000224421460.504361000000000000 ; 000000240190434.549131000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000015670A216E8063 >									
194 	//     < CHEMCHINA_PFVII_II_metadata_line_16_____Volant_Chem_org_20240321 >									
195 	//        < KKeom38OgLsulN38M5K41zkNpI77a0uY4A4i9F6GxEbbgvl9ffn3cxe97ht7fByE >									
196 	//        <  u =="0.000000000000000001" : ] 000000240190434.549131000000000000 ; 000000255350025.652543000000000000 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000000016E8063185A21B >									
198 	//     < CHEMCHINA_PFVII_II_metadata_line_17_____Volant_Chem_Corp__20240321 >									
199 	//        < TMt3VDj0nC1e95emUVKAq8Uq6PT9O5965EYZnM7NFt0NNz12IIqg1355hkPkEj7v >									
200 	//        <  u =="0.000000000000000001" : ] 000000255350025.652543000000000000 ; 000000271310249.285748000000000000 ] >									
201 	//        < 0x00000000000000000000000000000000000000000000000000185A21B19DFC91 >									
202 	//     < CHEMCHINA_PFVII_II_metadata_line_18_____Win_Win_chemical_Co_Limited_20240321 >									
203 	//        < MaqBEgt4jKW064f2k9eY5X8NK4606FRu1Jkz5dpvNtFV06mkiss49CQES065L0a9 >									
204 	//        <  u =="0.000000000000000001" : ] 000000271310249.285748000000000000 ; 000000287027829.692363000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000019DFC911B5F83F >									
206 	//     < CHEMCHINA_PFVII_II_metadata_line_19_____WJF_Chemicals_Co__20240321 >									
207 	//        < 2Z65oYX012wrewEd7Qukm5F8Ut9nQAe0yglsasKGipB3SJ50ev79nLa6EQY6nv10 >									
208 	//        <  u =="0.000000000000000001" : ] 000000287027829.692363000000000000 ; 000000303578027.933420000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000001B5F83F1CF392B >									
210 	//     < CHEMCHINA_PFVII_II_metadata_line_20_____Wuhan_Bright_Chemical_Co__Limited_20240321 >									
211 	//        < XCpvCrdjh0PeQ66zhIAJs0w408L6LrnFv337lZ7rtoeJY4D6OzBJ41Kxs4uqXGtw >									
212 	//        <  u =="0.000000000000000001" : ] 000000303578027.933420000000000000 ; 000000319215986.543088000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000001CF392B1E715BF >									
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
256 	//     < CHEMCHINA_PFVII_II_metadata_line_21_____Wuhan_Yuancheng_Chemical_Manufactory_org_20240321 >									
257 	//        < 7082MxY70D2LZ0B11Aipnrv71aNHO6PqW6i119Za94T36R9kNtU833A5Ai63m4N5 >									
258 	//        <  u =="0.000000000000000001" : ] 000000319215986.543088000000000000 ; 000000336295317.200602000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000001E715BF201255C >									
260 	//     < CHEMCHINA_PFVII_II_metadata_line_22_____Wuhan_Yuancheng_Chemical_Manufactory_20240321 >									
261 	//        < bN0nK6Ok8pQvmk31ItpC9pHQl731WNGCAs8qMMeuvb26a5f7Q3O8umPeMLd5PRj4 >									
262 	//        <  u =="0.000000000000000001" : ] 000000336295317.200602000000000000 ; 000000352632041.236324000000000000 ] >									
263 	//        < 0x00000000000000000000000000000000000000000000000000201255C21A12E4 >									
264 	//     < CHEMCHINA_PFVII_II_metadata_line_23_____Wuhu_Foman_Biopharma_Co_Limited_20240321 >									
265 	//        < 48x6HdYug39Its5pI53wKq9QRtMnkrqmQBjaUuKsPi44a9UQ9sN7L9R9MJG6z7O3 >									
266 	//        <  u =="0.000000000000000001" : ] 000000352632041.236324000000000000 ; 000000369384584.013979000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000021A12E4233A2DA >									
268 	//     < CHEMCHINA_PFVII_II_metadata_line_24_____Xi_an_Caijing_Opto_Electrical_Science___Technology_Co__Limited_20240321 >									
269 	//        < op1nf1h21L23k72Z7o9mt0VKgU7kvX6GoCL7ctTl85TSdSYSm4C1TPcCL5rCUfmc >									
270 	//        <  u =="0.000000000000000001" : ] 000000369384584.013979000000000000 ; 000000385784809.235663000000000000 ] >									
271 	//        < 0x00000000000000000000000000000000000000000000000000233A2DA24CA931 >									
272 	//     < CHEMCHINA_PFVII_II_metadata_line_25_____XIAMEN_EQUATION_CHEMICAL_org_20240321 >									
273 	//        < 27dYD8D4PTy5N798L3sto4ESxVWvSDLN6ZR10B6rQrsL356L478e207qIi7ws6J0 >									
274 	//        <  u =="0.000000000000000001" : ] 000000385784809.235663000000000000 ; 000000402412247.876250000000000000 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000000000024CA9312660849 >									
276 	//     < CHEMCHINA_PFVII_II_metadata_line_26_____XIAMEN_EQUATION_CHEMICAL_Co_Limited_20240321 >									
277 	//        < ThaGPp2h41956c3NK7qQ6d524K1ci92X4o44aQU7QT8bBI571F2af1z893aAG6jL >									
278 	//        <  u =="0.000000000000000001" : ] 000000402412247.876250000000000000 ; 000000418688331.049594000000000000 ] >									
279 	//        < 0x00000000000000000000000000000000000000000000000000266084927EDE21 >									
280 	//     < CHEMCHINA_PFVII_II_metadata_line_27_____Yacoo_Chemical_Reagent_Co_Limited_20240321 >									
281 	//        < 8DsX2gvX97sTl66s3gQ6NnNqNximMerztbXRg7u03lrK7r8YkKcplfqCe47Z6k35 >									
282 	//        <  u =="0.000000000000000001" : ] 000000418688331.049594000000000000 ; 000000434026683.134766000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000027EDE2129645AC >									
284 	//     < CHEMCHINA_PFVII_II_metadata_line_28_____Yantai_Taroke_Bio_engineering_Co_Limited_20240321 >									
285 	//        < 00Z6aWY80sXnEq9jo37CREtI4OjfIS55a6hLaoTFMK0PdGTOhy35Eo1Pj549e54A >									
286 	//        <  u =="0.000000000000000001" : ] 000000434026683.134766000000000000 ; 000000450043614.020663000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000029645AC2AEB649 >									
288 	//     < CHEMCHINA_PFVII_II_metadata_line_29_____Zehao_Industry_Co__Limited_20240321 >									
289 	//        < 53VV4O6q15IMmoFyJQs34QhE5a9uWQZl68731n4lCQJc3j7d50o9Athx5XKY3UO3 >									
290 	//        <  u =="0.000000000000000001" : ] 000000450043614.020663000000000000 ; 000000465132865.960461000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000002AEB6492C5BC87 >									
292 	//     < CHEMCHINA_PFVII_II_metadata_line_30_____Zeroschem_org_20240321 >									
293 	//        < 67oO22Wt30aWjSHywxqlh51644f3SanGY22pBV0HUG7e6ygOBv7y2oN58h18znM0 >									
294 	//        <  u =="0.000000000000000001" : ] 000000465132865.960461000000000000 ; 000000480957705.059898000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000002C5BC872DDE21B >									
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
338 	//     < CHEMCHINA_PFVII_II_metadata_line_31_____Zeroschem_Co_Limited_20240321 >									
339 	//        < 8qVN6G3OJeD7qrcDrjfQi0zwU5SGeV8oGmY7411JbrFncA7mYd02WGr1dPF265ou >									
340 	//        <  u =="0.000000000000000001" : ] 000000480957705.059898000000000000 ; 000000496804898.475490000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000002DDE21B2F6106A >									
342 	//     < CHEMCHINA_PFVII_II_metadata_line_32_____ZHANGJIAGANG_HUACHANG_PHARMACEUTICAL_Co__Limited_20240321 >									
343 	//        < W5s4B3KiVhk8W35nL0JTjJ8q9N13kWi3757afB78Uf4QRr5iC6b51T4Js5S13c2B >									
344 	//        <  u =="0.000000000000000001" : ] 000000496804898.475490000000000000 ; 000000512509236.928547000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000002F6106A30E06EC >									
346 	//     < CHEMCHINA_PFVII_II_metadata_line_33_____Zheda_Panaco_Chemical_Engineering_Co___Ltd___ZhedaChem__20240321 >									
347 	//        < P8G49e56e39G891wwkvoOsylkPtdLEr2P7wj96ZED9ZYRY22eUf2jkz1TqJC8Br2 >									
348 	//        <  u =="0.000000000000000001" : ] 000000512509236.928547000000000000 ; 000000527790541.801412000000000000 ] >									
349 	//        < 0x0000000000000000000000000000000000000000000000000030E06EC325582E >									
350 	//     < CHEMCHINA_PFVII_II_metadata_line_34_____Zhejiang_J_C_Biological_Technology_Co_Limited_20240321 >									
351 	//        < 5R2bA7kC4UiUTR1ZMsbln0Svrgc4oVzQ8ZCP2QrMUc2hpVzDqHW6sl9H7u8rXI8H >									
352 	//        <  u =="0.000000000000000001" : ] 000000527790541.801412000000000000 ; 000000542774071.350047000000000000 ] >									
353 	//        < 0x00000000000000000000000000000000000000000000000000325582E33C351F >									
354 	//     < CHEMCHINA_PFVII_II_metadata_line_35_____Zhengzhou_Meitong_Pharmaceutical_Technology_20240321 >									
355 	//        < 7nzRFr3YfhLg50366g2F92wST1cNMCCIN7k9j9p1SZ0k5mPRDXWLNEJpq8qqA7GM >									
356 	//        <  u =="0.000000000000000001" : ] 000000542774071.350047000000000000 ; 000000557933622.000758000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000033C351F35356D2 >									
358 	//     < CHEMCHINA_PFVII_II_metadata_line_36_____ZHIWE_ChemTech_org_20240321 >									
359 	//        < jke72j7A23q4v71ssn92cBvlyf01GYm2Sy0N1idD6eF9V3O4Yv5kAK6AXR2Vvb1q >									
360 	//        <  u =="0.000000000000000001" : ] 000000557933622.000758000000000000 ; 000000575175870.797473000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000035356D236DA613 >									
362 	//     < CHEMCHINA_PFVII_II_metadata_line_37_____ZHIWE_ChemTech_Co_Limited_20240321 >									
363 	//        < EcgwhJVxm7YtO6ti8K0ghICkV1SK6L7pC294s83zpbsX8EE4fT17e83YI5sMb14e >									
364 	//        <  u =="0.000000000000000001" : ] 000000575175870.797473000000000000 ; 000000592026171.507320000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000036DA6133875C39 >									
366 	//     < CHEMCHINA_PFVII_II_metadata_line_38_____Zhongtian_Kosen_Corporation_Limited_20240321 >									
367 	//        < 1Fh6pI93vd1LdoKAK859DcC2g4l97xC5XNzB44359z90GjP3d65h7gknqW961C2r >									
368 	//        <  u =="0.000000000000000001" : ] 000000592026171.507320000000000000 ; 000000608083326.719452000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000003875C3939FDC8D >									
370 	//     < CHEMCHINA_PFVII_II_metadata_line_39_____Zibo_Honors_chemical_Co_Limited_20240321 >									
371 	//        < Adfjjyc9KE5WzJQF6n5q5kTJciyIf0Mlo6hby847WxOCy1co507a5w00t20FfP4l >									
372 	//        <  u =="0.000000000000000001" : ] 000000608083326.719452000000000000 ; 000000624655621.858327000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000039FDC8D3B9261A >									
374 	//     < CHEMCHINA_PFVII_II_metadata_line_40_____Zouping_Mingxing_Chemical_Co__Limited_20240321 >									
375 	//        < VnD663WDVE7d3aOqUlU7h6x27rs27j031HvbxJyGtYgazvgF38d4R2F44R2DmYiv >									
376 	//        <  u =="0.000000000000000001" : ] 000000624655621.858327000000000000 ; 000000639925018.567807000000000000 ] >									
377 	//        < 0x000000000000000000000000000000000000000000000000003B9261A3D072B6 >									
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