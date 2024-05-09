1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	SHERE_PFI_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	SHERE_PFI_III_883		"	;
8 		string	public		symbol =	"	SHERE_PFI_III_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1657456069112910000000000000					;	
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
92 	//     < SHERE_PFI_III_metadata_line_1_____UNITED_AIRCRAFT_CORPORATION_20220505 >									
93 	//        < 0CL4X9Al7NFE0ip51nPowvQW9k0bAU7C0ElaXKm9rO6YGfkpC9Xds5j27Yr8dnLE >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000036450010.251685700000000000 ] >									
95 	//        < 0x0000000000000000000000000000000000000000000000000000000000379E49 >									
96 	//     < SHERE_PFI_III_metadata_line_2_____China_Russia Commercial Aircraft International Corporation Co_20220505 >									
97 	//        < 2Nu6Pa9isuql593zs686zwn0VR3W9G7SEzBcnh1J8o1Ctj8aMip5PvE088T6l8aF >									
98 	//        <  u =="0.000000000000000001" : ] 000000036450010.251685700000000000 ; 000000075812461.555480500000000000 ] >									
99 	//        < 0x0000000000000000000000000000000000000000000000000000379E4973AE3E >									
100 	//     < SHERE_PFI_III_metadata_line_3_____CHINA_RUSSIA_ORG_20220505 >									
101 	//        < an42oH53KnrJOE3Cvi1w7LZagodEhkB045X5E6LK11w0dbP6kHn9hB700vRQH767 >									
102 	//        <  u =="0.000000000000000001" : ] 000000075812461.555480500000000000 ; 000000118915259.999796000000000000 ] >									
103 	//        < 0x000000000000000000000000000000000000000000000000000073AE3EB57346 >									
104 	//     < SHERE_PFI_III_metadata_line_4_____Mutilrole Transport Aircraft Limited_20220505 >									
105 	//        < ju8yIOldq8Hv70a7RzamQIt1NFZVN5kL3CRwUPpkdcRgDvzDDAWpsg05wTYhm25m >									
106 	//        <  u =="0.000000000000000001" : ] 000000118915259.999796000000000000 ; 000000175457854.941766000000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000B5734610BBA39 >									
108 	//     < SHERE_PFI_III_metadata_line_5_____SuperJet International_20220505 >									
109 	//        < k401h5f6LXc3zO3RxdL41Ptq1hrzqdXf008N0e8cV368t67bZPf01MLOyPsJbc3h >									
110 	//        <  u =="0.000000000000000001" : ] 000000175457854.941766000000000000 ; 000000202447364.641750000000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000010BBA39134E900 >									
112 	//     < SHERE_PFI_III_metadata_line_6_____SUPERJET_ORG_20220505 >									
113 	//        < xY34zkyc2yIDFx00G479S21G1A6Kt2F1z3vz06G33U3Ad9H0H97LkS1xw00zQ1c8 >									
114 	//        <  u =="0.000000000000000001" : ] 000000202447364.641750000000000000 ; 000000264630887.389494000000000000 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000000000134E900193CB71 >									
116 	//     < SHERE_PFI_III_metadata_line_7_____JSC KAPO-Composit_20220505 >									
117 	//        < gN8Q1t34z8Z21020aMCHTc48JWd40bj4WMhC6mYC9bsDVDqYBHaSxCwZ95Kd6n5u >									
118 	//        <  u =="0.000000000000000001" : ] 000000264630887.389494000000000000 ; 000000354172287.633427000000000000 ] >									
119 	//        < 0x00000000000000000000000000000000000000000000000000193CB7121C6C8D >									
120 	//     < SHERE_PFI_III_metadata_line_8_____JSC Aviastar_SP_20220505 >									
121 	//        < C1Uu0OfPG9DRF1079vgo4m6zH3DQHV4WC21Q65cvG1csG787RU66F687tt7S16ad >									
122 	//        <  u =="0.000000000000000001" : ] 000000354172287.633427000000000000 ; 000000373144140.639515000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000021C6C8D2395F6E >									
124 	//     < SHERE_PFI_III_metadata_line_9_____JSC AeroKompozit_20220505 >									
125 	//        < wY00i77uNk2Cw6kIw793a8bOUadxb1ccLOa6JNYB401CkuN039gu0AJ188bFO2nu >									
126 	//        <  u =="0.000000000000000001" : ] 000000373144140.639515000000000000 ; 000000422749869.247176000000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000002395F6E28510AB >									
128 	//     < SHERE_PFI_III_metadata_line_10_____JSC AeroComposit_Ulyanovsk_20220505 >									
129 	//        < MwDQhzs1uk987wCtE4FU5i3ZZjr259i6sTrVYj914c4P0NO9ydnrP5O60axK6sBp >									
130 	//        <  u =="0.000000000000000001" : ] 000000422749869.247176000000000000 ; 000000476902998.472096000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000028510AB2D7B23C >									
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
174 	//     < SHERE_PFI_III_metadata_line_11_____JSC Sukhoi Civil Aircraft_20220505 >									
175 	//        < 0x6tY5x0CS0YpXWVXSy39GP0J2LEJZy39s5smJ4287vPyw3KKZ1F7uX52soRZGTi >									
176 	//        <  u =="0.000000000000000001" : ] 000000476902998.472096000000000000 ; 000000500711154.832426000000000000 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000000002D7B23C2FC064B >									
178 	//     < SHERE_PFI_III_metadata_line_12_____SUKHOIL_CIVIL_ORG_20220505 >									
179 	//        < j0yyku8N8miaqcMWwBy79yCiO0rAS7XOwGriZQ4N5f4s974MEtAOf66cJj7z7DvZ >									
180 	//        <  u =="0.000000000000000001" : ] 000000500711154.832426000000000000 ; 000000548284014.771504000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000002FC064B3449D71 >									
182 	//     < SHERE_PFI_III_metadata_line_13_____JSC Flight Research Institute_20220505 >									
183 	//        < FJUz6rZo485u594fl2ezYvcPv1GbExnOjy68cDzP2s50w3Z0e3y9yJ1EOrcf5EOz >									
184 	//        <  u =="0.000000000000000001" : ] 000000548284014.771504000000000000 ; 000000579936561.353230000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000003449D71374E9B8 >									
186 	//     < SHERE_PFI_III_metadata_line_14_____JSC UAC_Transport Aircraft_20220505 >									
187 	//        < TPbdWgTMg49s19H9905bUR0s9ZD9nVnS8981J73qwcVC9U72zVA2Dt5J3iI5CFWJ >									
188 	//        <  u =="0.000000000000000001" : ] 000000579936561.353230000000000000 ; 000000618922849.946245000000000000 ] >									
189 	//        < 0x00000000000000000000000000000000000000000000000000374E9B83B066BD >									
190 	//     < SHERE_PFI_III_metadata_line_15_____JSC Russian Aircraft Corporation MiG_20220505 >									
191 	//        < op7Cnbk2EgXSqkQYe3pYrXnW3942GH3AT3807Ke61B4OUhos6w3FakXO296o0o7e >									
192 	//        <  u =="0.000000000000000001" : ] 000000618922849.946245000000000000 ; 000000640170431.892057000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000003B066BD3D0D293 >									
194 	//     < SHERE_PFI_III_metadata_line_16_____MIG_ORG_20220505 >									
195 	//        < 9yTEW3zJ37H813xU28ew3XY4kFn76TFg2mYIH5MS44H69nDbUrZkrC4X51P27cS7 >									
196 	//        <  u =="0.000000000000000001" : ] 000000640170431.892057000000000000 ; 000000702533934.398100000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000003D0D29342FFB51 >									
198 	//     < SHERE_PFI_III_metadata_line_17_____OJSC Experimental Machine-Building Plant_20220505 >									
199 	//        < edAfPRhLj9R939eJ610K1o319c50cC1f1Zv45VC6M2616mN40JqdzXrKywxzcj34 >									
200 	//        <  u =="0.000000000000000001" : ] 000000702533934.398100000000000000 ; 000000778124861.148335000000000000 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000000042FFB514A35306 >									
202 	//     < SHERE_PFI_III_metadata_line_18_____Irkutsk Aviation Plant_20220505 >									
203 	//        < 3b8X7d0Df7Dlw575Mt7C7EC2AFG9NrFT7auQp4kzmur737H7A3mell8iZNV8a5NE >									
204 	//        <  u =="0.000000000000000001" : ] 000000778124861.148335000000000000 ; 000000823204574.142722000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000004A353064E81C49 >									
206 	//     < SHERE_PFI_III_metadata_line_19_____Gorbunov Kazan Aviation Plant_20220505 >									
207 	//        < u5Qt98P92MpqCxCISou1c04v9oNirskg8b9ie3YR6TGHcoyH37waZWVkHZqS6I41 >									
208 	//        <  u =="0.000000000000000001" : ] 000000823204574.142722000000000000 ; 000000843295653.530397000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000004E81C49506C45D >									
210 	//     < SHERE_PFI_III_metadata_line_20_____Komsomolsk_on_Amur Aircraft Plant_20220505 >									
211 	//        < 6EA47re2B4a8s6EDlG1e2fJe3rC3H3E5GYwm9HPlfk0f6FVfR8dpWy1q7xCBf5FV >									
212 	//        <  u =="0.000000000000000001" : ] 000000843295653.530397000000000000 ; 000000861623708.270357000000000000 ] >									
213 	//        < 0x00000000000000000000000000000000000000000000000000506C45D522BBC3 >									
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
256 	//     < SHERE_PFI_III_metadata_line_21_____Nizhny Novgorod aircraft building plant Sokol_20220505 >									
257 	//        < GFzchx5FQLUJ4U1KNZ9plX31P092giQjvck8yxLSe1eZFPE335yl78qvPGSQenu8 >									
258 	//        <  u =="0.000000000000000001" : ] 000000861623708.270357000000000000 ; 000000903028229.497633000000000000 ] >									
259 	//        < 0x00000000000000000000000000000000000000000000000000522BBC3561E967 >									
260 	//     < SHERE_PFI_III_metadata_line_22_____NIZHNY_ORG_20220505 >									
261 	//        < 3d7Z16jtNIsNrh9p5lBPGMWHKm3P1GqC7o9s2kRH2Mb85WED2GK18H7ChO8ljWNI >									
262 	//        <  u =="0.000000000000000001" : ] 000000903028229.497633000000000000 ; 000000922204977.995006000000000000 ] >									
263 	//        < 0x00000000000000000000000000000000000000000000000000561E96757F2C52 >									
264 	//     < SHERE_PFI_III_metadata_line_23_____Novosibirsk Aircraft Plant_20220505 >									
265 	//        < 06a9AAHNgmT8sB3u211M81656gtMFSEZ4qP8MdxPS28No6290e2eIAj93euhZcc8 >									
266 	//        <  u =="0.000000000000000001" : ] 000000922204977.995006000000000000 ; 000000956062590.579998000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000057F2C525B2D5F3 >									
268 	//     < SHERE_PFI_III_metadata_line_24_____NOVO_ORG_20220505 >									
269 	//        < K6k7bXrsMGzxsacqn2IWk2UtwS0y97h7e1i8U1g5vNAEz7niRTq527UM8692139B >									
270 	//        <  u =="0.000000000000000001" : ] 000000956062590.579998000000000000 ; 000001017363212.637110000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000005B2D5F36105F81 >									
272 	//     < SHERE_PFI_III_metadata_line_25_____UAC Health_20220505 >									
273 	//        < 4I9i8LbJ2y433y5Spp3021qv8wkDPrrsH5XdL1pxr132Bygl5nM8nPvoY53dY8aF >									
274 	//        <  u =="0.000000000000000001" : ] 000001017363212.637110000000000000 ; 000001053242438.358550000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000006105F816471ED4 >									
276 	//     < SHERE_PFI_III_metadata_line_26_____UAC_HEALTH_ORG_20220505 >									
277 	//        < SO6INkIF9z57CS4v7Lmzh1y46JUa4s5RCS8dBhT850U5L9y96210K302157H2ds8 >									
278 	//        <  u =="0.000000000000000001" : ] 000001053242438.358550000000000000 ; 000001072083872.337130000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000006471ED4663DEC3 >									
280 	//     < SHERE_PFI_III_metadata_line_27_____JSC Ilyushin Finance Co_20220505 >									
281 	//        < 9Ye5OTe78ylEG2Q90eU8Y644Q42bGlKUID3F14QXpop6eodEHq16cg2jflgs8uAR >									
282 	//        <  u =="0.000000000000000001" : ] 000001072083872.337130000000000000 ; 000001117550438.227370000000000000 ] >									
283 	//        < 0x00000000000000000000000000000000000000000000000000663DEC36A93F24 >									
284 	//     < SHERE_PFI_III_metadata_line_28_____OJSC Experimental Design Bureau_20220505 >									
285 	//        < jl6e49T7cc4R67SSP6E65j8OoupZ05ejc5H22gyPN5amJa9gDjmvU4UYt6KYnDGb >									
286 	//        <  u =="0.000000000000000001" : ] 000001117550438.227370000000000000 ; 000001168218079.398330000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000006A93F246F68F30 >									
288 	//     < SHERE_PFI_III_metadata_line_29_____LLC UAC_I_20220505 >									
289 	//        < g6e0ci56tq3pvj35efo37YR96sHK3lu1rzWXhV8P93OhnC11ncA8s7VFoRj59cOy >									
290 	//        <  u =="0.000000000000000001" : ] 000001168218079.398330000000000000 ; 000001202575759.008660000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000006F68F3072AFC28 >									
292 	//     < SHERE_PFI_III_metadata_line_30_____LLC UAC_II_20220505 >									
293 	//        < k4MFA1kVYRPrI9kLZnqaiRp7fK7sC272Gg77s69HDTJyga5OvrCEU21f10P6682k >									
294 	//        <  u =="0.000000000000000001" : ] 000001202575759.008660000000000000 ; 000001248980826.358780000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000072AFC28771CB23 >									
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
338 	//     < SHERE_PFI_III_metadata_line_31_____LLC UAC_III_20220505 >									
339 	//        < 1Zyc7eu2RbP2Hgh59mFr3szZW4Tv807U3J9Qr7RCP466U528VeZW0YielE425tKg >									
340 	//        <  u =="0.000000000000000001" : ] 000001248980826.358780000000000000 ; 000001293418697.356040000000000000 ] >									
341 	//        < 0x00000000000000000000000000000000000000000000000000771CB237B599AE >									
342 	//     < SHERE_PFI_III_metadata_line_32_____JSC Ilyushin Aviation Complex_20220505 >									
343 	//        < g3m2HUuH09KP24gK69F0K6g7w66R4gSKP4V30D8F3SY2FwmHe8q2Z3GZ6Cb3A3z7 >									
344 	//        <  u =="0.000000000000000001" : ] 000001293418697.356040000000000000 ; 000001329926860.161190000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000007B599AE7ED4EAE >									
346 	//     < SHERE_PFI_III_metadata_line_33_____PJSC Voronezh Aircraft Manufacturing Company_20220505 >									
347 	//        < KKmgs6h05ti8ww65281WhEbrOd7stwnn0FtKkkH4WMa4V0Kywcn9P4R4I2MfJ2QF >									
348 	//        <  u =="0.000000000000000001" : ] 000001329926860.161190000000000000 ; 000001378021859.968020000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000007ED4EAE836B1CA >									
350 	//     < SHERE_PFI_III_metadata_line_34_____JSC Aviation Holding Company Sukhoi_20220505 >									
351 	//        < Xp8uClmosTKy88A31rxa376M5o9SyQk7dwK3Uk28kaRDxy1ajkx3T02SRTRGnx9h >									
352 	//        <  u =="0.000000000000000001" : ] 000001378021859.968020000000000000 ; 000001401266313.202510000000000000 ] >									
353 	//        < 0x00000000000000000000000000000000000000000000000000836B1CA85A29A7 >									
354 	//     < SHERE_PFI_III_metadata_line_35_____SUKHOI_ORG_20220505 >									
355 	//        < odz3Q7zvxX37N3560k75z4TFAT85xl24rPIVO8TF8C6OQaC98OVrPfL8LeJk05uD >									
356 	//        <  u =="0.000000000000000001" : ] 000001401266313.202510000000000000 ; 000001484940062.833540000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000085A29A78D9D6B6 >									
358 	//     < SHERE_PFI_III_metadata_line_36_____PJSC Scientific and Production Corporation Irkut_20220505 >									
359 	//        < 8q04RmR5VEq6K985qQBI5OWaF41hk51q6QkTF6YH6lNC5l1i829C6DH713IzkE1o >									
360 	//        <  u =="0.000000000000000001" : ] 000001484940062.833540000000000000 ; 000001506440702.467060000000000000 ] >									
361 	//        < 0x000000000000000000000000000000000000000000000000008D9D6B68FAA566 >									
362 	//     < SHERE_PFI_III_metadata_line_37_____PJSC Taganrog Aviation Scientific_Technical Complex_20220505 >									
363 	//        < RbrMFG0eSI1wJ0mw2rlo02Rtezq4AN7pUB6A9UzG4a9Z0EmsP09V0N5Ug64zoMPi >									
364 	//        <  u =="0.000000000000000001" : ] 000001506440702.467060000000000000 ; 000001525376935.223760000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000008FAA5669178A5E >									
366 	//     < SHERE_PFI_III_metadata_line_38_____PJSC Tupolev_20220505 >									
367 	//        < 3LMM8596XsL5eHUWdLafjy8wH1Us79rXxk42kzGf4w249V32T64qKj1QLcPsMpLC >									
368 	//        <  u =="0.000000000000000001" : ] 000001525376935.223760000000000000 ; 000001602401106.245780000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000009178A5E98D11EF >									
370 	//     < SHERE_PFI_III_metadata_line_39_____TUPOLEV_ORG_20220505 >									
371 	//        < Qovp6856LV6u96i8I7K7OrDFx387Ev5mwnIv00J5yLfZ3sbCMk7dVb7bcg8T59r5 >									
372 	//        <  u =="0.000000000000000001" : ] 000001602401106.245780000000000000 ; 000001621658223.327960000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000098D11EF9AA743E >									
374 	//     < SHERE_PFI_III_metadata_line_40_____The industrial complex N1_20220505 >									
375 	//        < u7coP3GqasTq5952XaCe74QJ0V7WcYBv4E14sA54201f1RrUWUaGiI4FCsbi116j >									
376 	//        <  u =="0.000000000000000001" : ] 000001621658223.327960000000000000 ; 000001657456069.112910000000000000 ] >									
377 	//        < 0x000000000000000000000000000000000000000000000000009AA743E9E113C7 >									
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