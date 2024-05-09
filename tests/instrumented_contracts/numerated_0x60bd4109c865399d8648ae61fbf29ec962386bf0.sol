1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	NDRV_PFVII_II_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	NDRV_PFVII_II_883		"	;
8 		string	public		symbol =	"	NDRV_PFVII_II_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1198949438910400000000000000					;	
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
92 	//     < NDRV_PFVII_II_metadata_line_1_____Hannover Re_20231101 >									
93 	//        < 9Xh91q1p63l77loE4R8Rw9mI23eNeooS0E3xgL2691hk4AZZ8b2Zj6092J4MvWu5 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000021941814.608398500000000000 ] >									
95 	//        < 0x0000000000000000000000000000000000000000000000000000000000217B05 >									
96 	//     < NDRV_PFVII_II_metadata_line_2_____Hannover Reinsurance Ireland Ltd_20231101 >									
97 	//        < 0Pg2Uz4j32Dr4Pt4ciZapg24592m26bEt71A5XyrDIOs07sILAPA9azlh20A88PP >									
98 	//        <  u =="0.000000000000000001" : ] 000000021941814.608398500000000000 ; 000000039244505.208834400000000000 ] >									
99 	//        < 0x0000000000000000000000000000000000000000000000000000217B053BE1E3 >									
100 	//     < NDRV_PFVII_II_metadata_line_3_____975 Carroll Square Llc_20231101 >									
101 	//        < FZZacHJw5T4zx787pj89B67op8fZ29vo1ThQsA6gnnph6CDRobE8P7Z00B861pQP >									
102 	//        <  u =="0.000000000000000001" : ] 000000039244505.208834400000000000 ; 000000062351276.159486500000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000003BE1E35F23F8 >									
104 	//     < NDRV_PFVII_II_metadata_line_4_____Caroll_Holdings_20231101 >									
105 	//        < 8XMSSxaV5nWiQ7o2s2EUjsnCHII3aA3P4tb50YZ8IOUlrV6U0Wk9K12B1QM85tDE >									
106 	//        <  u =="0.000000000000000001" : ] 000000062351276.159486500000000000 ; 000000086301355.111389700000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000005F23F883AF78 >									
108 	//     < NDRV_PFVII_II_metadata_line_5_____Skandia Versicherung Management & Service Gmbh_20231101 >									
109 	//        < UUG3u5S2x49946Kox8M0oEamoLRrBlv4l082uBqgSYyFIR06B255f45QFWMT0l5Q >									
110 	//        <  u =="0.000000000000000001" : ] 000000086301355.111389700000000000 ; 000000107708401.375062000000000000 ] >									
111 	//        < 0x000000000000000000000000000000000000000000000000000083AF78A45998 >									
112 	//     < NDRV_PFVII_II_metadata_line_6_____Skandia PortfolioManagement Gmbh, Asset Management Arm_20231101 >									
113 	//        < 3NX7g8E1hthRk1l90HfY6o8pQfIWKc5gisK96wK7n92zaDwYLEeoRO83x76rIsPx >									
114 	//        <  u =="0.000000000000000001" : ] 000000107708401.375062000000000000 ; 000000139913851.258111000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000A45998D57DD9 >									
116 	//     < NDRV_PFVII_II_metadata_line_7_____Argenta Underwriting No8 Limited_20231101 >									
117 	//        < XRfs5i4FbHY7IzZ269K12SJOOO7XVI9Y5SZMP4zWNWR3w4bf37Ge2PYA05R7PhAo >									
118 	//        <  u =="0.000000000000000001" : ] 000000139913851.258111000000000000 ; 000000158125704.178147000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000D57DD9F147DA >									
120 	//     < NDRV_PFVII_II_metadata_line_8_____Oval Office Grundstücks GmbH_20231101 >									
121 	//        < SdY6NCI2UFzTnRs60y5yQqkBp8U162Nx69FewJucszIl9z7b00kBN7qZE65zH4EQ >									
122 	//        <  u =="0.000000000000000001" : ] 000000158125704.178147000000000000 ; 000000189251520.210466000000000000 ] >									
123 	//        < 0x000000000000000000000000000000000000000000000000000F147DA120C660 >									
124 	//     < NDRV_PFVII_II_metadata_line_9_____Hannover Rückversicherung AG Asset Management Arm_20231101 >									
125 	//        < Yx74Vc68O01QLn11t9YibK3QT3fDYmxW4MO53NIl9A8K7o12Sb98Z55Vf3ToCPtO >									
126 	//        <  u =="0.000000000000000001" : ] 000000189251520.210466000000000000 ; 000000210117499.230351000000000000 ] >									
127 	//        < 0x00000000000000000000000000000000000000000000000000120C6601409D26 >									
128 	//     < NDRV_PFVII_II_metadata_line_10_____Hannover Rueckversicherung Ag Korea Branch_20231101 >									
129 	//        < szOQ5aBIRo35I2Idq25EEMAyN0549qBm5nVf440788T26sGCdGek44zG4k04R537 >									
130 	//        <  u =="0.000000000000000001" : ] 000000210117499.230351000000000000 ; 000000242219011.642811000000000000 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000000001409D2617198CD >									
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
174 	//     < NDRV_PFVII_II_metadata_line_11_____Nashville West LLC_20231101 >									
175 	//        < H1yv8mE7l7FueVqf60NFSDF8UQ0tg491U6vzUYMmm1YOM1dJk21v8BZiiU11No9m >									
176 	//        <  u =="0.000000000000000001" : ] 000000242219011.642811000000000000 ; 000000283061660.936021000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000017198CD1AFEAF6 >									
178 	//     < NDRV_PFVII_II_metadata_line_12_____WRH Offshore High Yield Partners LP_20231101 >									
179 	//        < Q5elT7ujX01HcLCBkktw1GAPao9Pjmm7Invkx5z8b4Ok9l0h94ZI1E1179lCt2o1 >									
180 	//        <  u =="0.000000000000000001" : ] 000000283061660.936021000000000000 ; 000000310497770.112726000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000001AFEAF61D9C831 >									
182 	//     < NDRV_PFVII_II_metadata_line_13_____111Ord Llc_20231101 >									
183 	//        < GQbv3jAfDYYQVR9524HqLlr73QpsmbI590fMFvtW4TPOTT3C5aIi0h9ch3hB3Oe4 >									
184 	//        <  u =="0.000000000000000001" : ] 000000310497770.112726000000000000 ; 000000345900040.746659000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001D9C83120FCD34 >									
186 	//     < NDRV_PFVII_II_metadata_line_14_____Hannover Insurance_Linked Securities GmbH & Co KG_20231101 >									
187 	//        < yPo1F804yNPd6J5trqbq3CUi92n14KAyg1S3pUWs0i79IrtzTmIsSFM8J2PZh1p7 >									
188 	//        <  u =="0.000000000000000001" : ] 000000345900040.746659000000000000 ; 000000369996854.878187000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000020FCD342349205 >									
190 	//     < NDRV_PFVII_II_metadata_line_15_____Hannover Ruckversicherung AG Hong Kong_20231101 >									
191 	//        < FICySSxQg5aPT4p2X33245tNbq5A6wQ3R3jcLO7Co3UMDEb4t510B8FVv2Qa9SV7 >									
192 	//        <  u =="0.000000000000000001" : ] 000000369996854.878187000000000000 ; 000000399234795.527658000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000023492052612F18 >									
194 	//     < NDRV_PFVII_II_metadata_line_16_____Hannover Reinsurance Mauritius Ltd_20231101 >									
195 	//        < IrF50MjffOpMmSA1m0FhJZ59oS4GXiUOiR8pJMq2CuUknCC4jdl3V93N3YDpx4S0 >									
196 	//        <  u =="0.000000000000000001" : ] 000000399234795.527658000000000000 ; 000000425340521.846731000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000002612F1828904A4 >									
198 	//     < NDRV_PFVII_II_metadata_line_17_____HEPEP II Holding GmbH_20231101 >									
199 	//        < v4tVuq1g2NM48FCVBH8fz9v5S89n2M8umSW06wovwfP18bVd755Ki6S0Seb0192R >									
200 	//        <  u =="0.000000000000000001" : ] 000000425340521.846731000000000000 ; 000000464382177.984535000000000000 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000000028904A42C4974A >									
202 	//     < NDRV_PFVII_II_metadata_line_18_____International Insurance Company Of Hannover Limited Sweden_20231101 >									
203 	//        < GL59U14Ca86PPZq2aTtU5WxX7C379V1vx72E40Xb7UiIT04YetFj1Vmw1MS28Tep >									
204 	//        <  u =="0.000000000000000001" : ] 000000464382177.984535000000000000 ; 000000506165425.597722000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000002C4974A30458DF >									
206 	//     < NDRV_PFVII_II_metadata_line_19_____HEPEP III Holding GmbH_20231101 >									
207 	//        < UbSO8221i8D8TtQ9oG8W3Q862339zhg7s36o5VBot2280P41fVNzeiVOd9uWy8e6 >									
208 	//        <  u =="0.000000000000000001" : ] 000000506165425.597722000000000000 ; 000000531705551.344579000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000000030458DF32B517B >									
210 	//     < NDRV_PFVII_II_metadata_line_20_____Hannover Rueck Beteiligung Verwaltungs_GmbH_20231101 >									
211 	//        < risi3875K0Y9DV3j6IR7jjAXcb388gm1Q5A8Pdtl7xX3VG2y92z29cb7IeOI6O17 >									
212 	//        <  u =="0.000000000000000001" : ] 000000531705551.344579000000000000 ; 000000568039369.036535000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000032B517B362C261 >									
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
256 	//     < NDRV_PFVII_II_metadata_line_21_____EplusS Rückversicherung AG_20231101 >									
257 	//        < i6XGrIiim6SmoFK12Istg5RPLz2M7723Gb5JNUIr58W4Ms1k4ebhJH83X993Da29 >									
258 	//        <  u =="0.000000000000000001" : ] 000000568039369.036535000000000000 ; 000000604124551.493776000000000000 ] >									
259 	//        < 0x00000000000000000000000000000000000000000000000000362C261399D227 >									
260 	//     < NDRV_PFVII_II_metadata_line_22_____HILSP Komplementaer GmbH_20231101 >									
261 	//        < B8uj4d3toNy94Z5613xNlNl16K56yh1076Q3jh033CQh215k4Ow30uUvEwV48naY >									
262 	//        <  u =="0.000000000000000001" : ] 000000604124551.493776000000000000 ; 000000620931834.429592000000000000 ] >									
263 	//        < 0x00000000000000000000000000000000000000000000000000399D2273B3777F >									
264 	//     < NDRV_PFVII_II_metadata_line_23_____Hannover Life Reassurance UK Limited_20231101 >									
265 	//        < AAkqwgRiEF7934CmOZnCEhCWVHAPHha28EUxle9xXj88q765iAATDKzH4Dm3nth3 >									
266 	//        <  u =="0.000000000000000001" : ] 000000620931834.429592000000000000 ; 000000660082408.342747000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000003B3777F3EF34B1 >									
268 	//     < NDRV_PFVII_II_metadata_line_24_____EplusS Reinsurance Ireland Ltd_20231101 >									
269 	//        < IYY8gy604lo25NSJUelEF71Dz8IrgLy1Y044J4k30GrL1fC7ec6H0193pyqLWX21 >									
270 	//        <  u =="0.000000000000000001" : ] 000000660082408.342747000000000000 ; 000000680102918.652329000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000003EF34B140DC134 >									
272 	//     < NDRV_PFVII_II_metadata_line_25_____Svedea Skadeservice Ab_20231101 >									
273 	//        < o9mD8i8KCXx84ea9711264DZK71p0n5QWVP1S4S3tC7rFqLIshcT73l8ujPIaWc5 >									
274 	//        <  u =="0.000000000000000001" : ] 000000680102918.652329000000000000 ; 000000728461471.389698000000000000 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000000000040DC1344578B43 >									
276 	//     < NDRV_PFVII_II_metadata_line_26_____Hannover Finance Luxembourg SA_20231101 >									
277 	//        < GGqGQA5CIqM21eV8y8cXP30Pv5HiafNWDjo719AKeXzVp8CALv5W99NG2Usi5Sru >									
278 	//        <  u =="0.000000000000000001" : ] 000000728461471.389698000000000000 ; 000000764939597.623054000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000004578B4348F3488 >									
280 	//     < NDRV_PFVII_II_metadata_line_27_____Hannover Ruckversicherung AG Australia_20231101 >									
281 	//        < M0H1s0MD9U24WMnQp2Ti3HV5qNjr5Z4dejvWt88z0Pwr6015Xf286lm4DHFM6vnz >									
282 	//        <  u =="0.000000000000000001" : ] 000000764939597.623054000000000000 ; 000000792708680.564779000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000048F34884B993D4 >									
284 	//     < NDRV_PFVII_II_metadata_line_28_____Cargo Transit Insurance Pty Limited_20231101 >									
285 	//        < 1JXZs6YR9H2gS6d13x3nbc3PXW9T25bJ5Bg45eIwjSW3b9344ugb8p3RZ6yw9amw >									
286 	//        <  u =="0.000000000000000001" : ] 000000792708680.564779000000000000 ; 000000819818750.680660000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000004B993D44E2F1B3 >									
288 	//     < NDRV_PFVII_II_metadata_line_29_____Hannover Life Re Africa_20231101 >									
289 	//        < mio8ZkLkrOT5WEQS0WZWm86AiC4Z2Eiz3FZo6W77D1H8p4hw17xP1J1wUpzWLG0Z >									
290 	//        <  u =="0.000000000000000001" : ] 000000819818750.680660000000000000 ; 000000867700053.363777000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000004E2F1B352C0155 >									
292 	//     < NDRV_PFVII_II_metadata_line_30_____Hannover Re Services USA Inc_20231101 >									
293 	//        < 4jD98s5fLhD6rd490096Dbr58AA8vRCjS126L14KCvD5Wj7lPKjAke4yXV548CR9 >									
294 	//        <  u =="0.000000000000000001" : ] 000000867700053.363777000000000000 ; 000000893513319.634518000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000052C015555364A4 >									
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
338 	//     < NDRV_PFVII_II_metadata_line_31_____Talanx Deutschland AG_20231101 >									
339 	//        < 44lXT82x6Okbo44Se5VPj5j67cpc144MQb458n9zO6gr2vAF0Zfqm5H89nb9eZF2 >									
340 	//        <  u =="0.000000000000000001" : ] 000000893513319.634518000000000000 ; 000000931909737.331271000000000000 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000000000055364A458DFB3E >									
342 	//     < NDRV_PFVII_II_metadata_line_32_____HDI Lebensversicherung AG_20231101 >									
343 	//        < fs2HEzriG5JK3hjDvQMv0VCCRN30ft6w48wyep5C5AlS484W399yum5wBd1xR7a8 >									
344 	//        <  u =="0.000000000000000001" : ] 000000931909737.331271000000000000 ; 000000951018341.636865000000000000 ] >									
345 	//        < 0x0000000000000000000000000000000000000000000000000058DFB3E5AB238A >									
346 	//     < NDRV_PFVII_II_metadata_line_33_____casa altra development GmbH_20231101 >									
347 	//        < GRFJ6Q8OB9q9XehK5YI881RtiQqJE8ECUnK1xJ0h8v2t00RO671281U4eOf5jNRF >									
348 	//        <  u =="0.000000000000000001" : ] 000000951018341.636865000000000000 ; 000000975094900.981676000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000005AB238A5CFE072 >									
350 	//     < NDRV_PFVII_II_metadata_line_34_____Credit Life International Services GmbH_20231101 >									
351 	//        < sIML9scTSv2Aa2dCmP85thaSL111BjmPW8nBj4G219fnkL5K20vL4HS6p2gBPD8O >									
352 	//        <  u =="0.000000000000000001" : ] 000000975094900.981676000000000000 ; 000001016671437.963270000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000005CFE07260F5148 >									
354 	//     < NDRV_PFVII_II_metadata_line_35_____FVB Gesellschaft für Finanz_und Versorgungsberatung mbH_20231101 >									
355 	//        < 9QvX7RTmu7u0k0sa6A91D1PQITV76VoIM6UTYa4e0J0ENx3w6ZV0SSnfB0lEoeX1 >									
356 	//        <  u =="0.000000000000000001" : ] 000001016671437.963270000000000000 ; 000001045189124.861270000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000060F514863AD500 >									
358 	//     < NDRV_PFVII_II_metadata_line_36_____ASPECTA Assurance International AG_20231101 >									
359 	//        < Hf2F6y15tCD2F5JH4xH99eJtP8r2b0CykwB5TH5Lc46Xiy7e3ElPnVCL7KU4FD84 >									
360 	//        <  u =="0.000000000000000001" : ] 000001045189124.861270000000000000 ; 000001087169358.893450000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000063AD50067AE388 >									
362 	//     < NDRV_PFVII_II_metadata_line_37_____Life Re_Holdings_20231101 >									
363 	//        < swabiQ85iFxUItcqW7WWdYp0080oJuM2RC6uv84SJ7n8J7h79x174CBtdkF7plCk >									
364 	//        <  u =="0.000000000000000001" : ] 000001087169358.893450000000000000 ; 000001113862251.105810000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000067AE3886A39E71 >									
366 	//     < NDRV_PFVII_II_metadata_line_38_____Credit Life_Pensions_20231101 >									
367 	//        < SBM9s2C4b1421ZSp6Btm0b8XO3D94XfA87n73e6UYL5Pi9wwtUIj4FKkxYvoOndU >									
368 	//        <  u =="0.000000000000000001" : ] 000001113862251.105810000000000000 ; 000001132716428.578140000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000006A39E716C0635B >									
370 	//     < NDRV_PFVII_II_metadata_line_39_____ASPECTA_org_20231101 >									
371 	//        < 896r4dbh6ClaE297o685al7525qUHL9F3Y1PVcMz3Rf989474WS7WnR0r7M1Ri1D >									
372 	//        <  u =="0.000000000000000001" : ] 000001132716428.578140000000000000 ; 000001182398662.309500000000000000 ] >									
373 	//        < 0x000000000000000000000000000000000000000000000000006C0635B70C327A >									
374 	//     < NDRV_PFVII_II_metadata_line_40_____Cargo Transit_Holdings_20231101 >									
375 	//        < 0nFurw5wRMSC9q9bMxAu387SsAaZR4FD6XWqRDi0F7Xk8aGwJaZ8ZPvosfycNEf0 >									
376 	//        <  u =="0.000000000000000001" : ] 000001182398662.309500000000000000 ; 000001198949438.910400000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000070C327A72573A0 >									
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