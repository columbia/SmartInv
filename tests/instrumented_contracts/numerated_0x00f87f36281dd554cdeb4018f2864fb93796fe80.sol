1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	AZOV_PFI_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	AZOV_PFI_III_883		"	;
8 		string	public		symbol =	"	AZOV_PFI_III_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1940410213986190000000000000					;	
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
92 	//     < AZOV_PFI_III_metadata_line_1_____Berdyansk_org_20251101 >									
93 	//        < s01cIfsUdc426CNHkh9q9cX0mhbC5wDEUxl7fkgZEn632o3raDfHMHAZxciohCN8 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000029546032.913516600000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000002D156B >									
96 	//     < AZOV_PFI_III_metadata_line_2_____Zaporizhia_org_20251101 >									
97 	//        < n7z5KoZK1WbuEHwijXbWV2mjGhp0140X07Xhw896jEcHf96gt7py515xYuW9Dv1W >									
98 	//        <  u =="0.000000000000000001" : ] 000000029546032.913516600000000000 ; 000000104383109.763593000000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000002D156B9F46A7 >									
100 	//     < AZOV_PFI_III_metadata_line_3_____Berdiansk_Commercial_Sea_Port_20251101 >									
101 	//        < rxcS84WMDyu7BV3E2evO3YI674SG5L30A9hpbN3L9m011pAEnIVF9lOexJ78a3U4 >									
102 	//        <  u =="0.000000000000000001" : ] 000000104383109.763593000000000000 ; 000000129361401.056194000000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000009F46A7C563CC >									
104 	//     < AZOV_PFI_III_metadata_line_4_____Soylu_Group_20251101 >									
105 	//        < rMgCYWMQZ97Pz3itT1n3PtXzGB13eqOR2FM670sED143TI8co9Mx229rZ116Xlpb >									
106 	//        <  u =="0.000000000000000001" : ] 000000129361401.056194000000000000 ; 000000191681509.340786000000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000C563CC1247B97 >									
108 	//     < AZOV_PFI_III_metadata_line_5_____Soylu_Group_TRK_20251101 >									
109 	//        < 4QmQ8n3PQ5zuVW0YUxM568C9a78Gv1q6JS3zff1W0P2454CWE9O2J0zXW62Ip2Zf >									
110 	//        <  u =="0.000000000000000001" : ] 000000191681509.340786000000000000 ; 000000225488926.809104000000000000 ] >									
111 	//        < 0x000000000000000000000000000000000000000000000000001247B97158119D >									
112 	//     < AZOV_PFI_III_metadata_line_6_____Ulusoy Holding_20251101 >									
113 	//        < qX2q15E1e14nk00n4cKlNjb8J8Q7zVvDO0GZumWqbL2hpoG0gIL2f8P52073a1je >									
114 	//        <  u =="0.000000000000000001" : ] 000000225488926.809104000000000000 ; 000000302407833.495676000000000000 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000000000158119D1CD700F >									
116 	//     < AZOV_PFI_III_metadata_line_7_____Berdyansk_Sea_Trading_Port_20251101 >									
117 	//        < 9l4KT1T5y34q1cxY8700d2fPKdT7642NkdnIteIuSXQKdsokuDBq3Bd7g0951KUs >									
118 	//        <  u =="0.000000000000000001" : ] 000000302407833.495676000000000000 ; 000000370396971.493908000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000001CD700F2352E51 >									
120 	//     < AZOV_PFI_III_metadata_line_8_____Marioupol_org_20251101 >									
121 	//        < 179H5aEWB9836uUkpHGmNVLAgNJ02AQSna3gMDaPaFeC9S8b7v4my6P9JE0qbShx >									
122 	//        <  u =="0.000000000000000001" : ] 000000370396971.493908000000000000 ; 000000431652318.623388000000000000 ] >									
123 	//        < 0x000000000000000000000000000000000000000000000000002352E51292A630 >									
124 	//     < AZOV_PFI_III_metadata_line_9_____Donetsk_org_20251101 >									
125 	//        < i54WqnmAS8jyn5B4voPwm4859FvvE628y6uuXpy5FrOG0G7rrG9d3e635F64pZfL >									
126 	//        <  u =="0.000000000000000001" : ] 000000431652318.623388000000000000 ; 000000456539292.262227000000000000 ] >									
127 	//        < 0x00000000000000000000000000000000000000000000000000292A6302B89FA9 >									
128 	//     < AZOV_PFI_III_metadata_line_10_____Marioupol_Port_Station_20251101 >									
129 	//        < tnvTXzefjN538O46oDT6l8rd0RktK7e719N02169d17E6v41niih0ApYh6f3BJPR >									
130 	//        <  u =="0.000000000000000001" : ] 000000456539292.262227000000000000 ; 000000540039215.139968000000000000 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000000002B89FA933808D2 >									
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
174 	//     < AZOV_PFI_III_metadata_line_11_____Yeysk_org_20251101 >									
175 	//        < Tut8U2y9R5MWgobB2X2D4D60A3nIAFzf2QUx3rZiN94jFbnFyt0aB4P0U83L6R0l >									
176 	//        <  u =="0.000000000000000001" : ] 000000540039215.139968000000000000 ; 000000558887347.545637000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000033808D2354CB5F >									
178 	//     < AZOV_PFI_III_metadata_line_12_____Krasnodar_org_20251101 >									
179 	//        < eM3lzPqRPmD76Xxa24clxPq7e2W523wi0T871LaW8Q8vP3yf4Kix2fKd3N6xt65O >									
180 	//        <  u =="0.000000000000000001" : ] 000000558887347.545637000000000000 ; 000000639832290.974883000000000000 ] >									
181 	//        < 0x00000000000000000000000000000000000000000000000000354CB5F3D04E7D >									
182 	//     < AZOV_PFI_III_metadata_line_13_____Yeysk_Airport_20251101 >									
183 	//        < VzefA5G1sKs9C4m0wS10W0HHCGNcpc810XMfRkgH3FWb8fz21EP2G912L89n67d2 >									
184 	//        <  u =="0.000000000000000001" : ] 000000639832290.974883000000000000 ; 000000678843010.503554000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000003D04E7D40BD50D >									
186 	//     < AZOV_PFI_III_metadata_line_14_____Kerch_infrastructure_org_20251101 >									
187 	//        < xZ8S9RmrX9qO2xQ4n7hRzvo2Dal9XU1Y5rxL98AszF54yoRDEI70na4kgQ3pq6C0 >									
188 	//        <  u =="0.000000000000000001" : ] 000000678843010.503554000000000000 ; 000000770825890.102032000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000040BD50D4982FDD >									
190 	//     < AZOV_PFI_III_metadata_line_15_____Kerch_Seaport_org_20251101 >									
191 	//        < f1Oxe8ns19S4I9s39n0IArjA9b8qZ1VvQu4Yvcf0048375GndCIIrer5Og4j8OeK >									
192 	//        <  u =="0.000000000000000001" : ] 000000770825890.102032000000000000 ; 000000844277630.933845000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000004982FDD50843F3 >									
194 	//     < AZOV_PFI_III_metadata_line_16_____Azov_org_20251101 >									
195 	//        < 8cAWnb1yO3La2ZCUaboQi8V5UYAIpYVZub8CX5mE03HKGxmnt6j448kRuV35M19r >									
196 	//        <  u =="0.000000000000000001" : ] 000000844277630.933845000000000000 ; 000000877985254.133183000000000000 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000000050843F353BB2FD >									
198 	//     < AZOV_PFI_III_metadata_line_17_____Azov_Seaport_org_20251101 >									
199 	//        < j60mOjgJw3VI0xm7Yx5mRO4ya3Qw3878agbka1Xl2ws05cLQW92KSj9apUQTiHkC >									
200 	//        <  u =="0.000000000000000001" : ] 000000877985254.133183000000000000 ; 000000969492552.868043000000000000 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000000053BB2FD5C75407 >									
202 	//     < AZOV_PFI_III_metadata_line_18_____Azovskiy_Portovyy_Elevator_20251101 >									
203 	//        < 949PrtM926j4AY2JC45F395V072Z7dqp3486psaResgOEU7Wu9tLtw0691G3v5Dk >									
204 	//        <  u =="0.000000000000000001" : ] 000000969492552.868043000000000000 ; 000001018021228.053580000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000005C75407611608B >									
206 	//     < AZOV_PFI_III_metadata_line_19_____Rostov_SLD_org_20251101 >									
207 	//        < XB45buK67T7148y40Mj79g2n0i48zUpF22AIXY86xCNutMH1AxkGhsQ23hq139N2 >									
208 	//        <  u =="0.000000000000000001" : ] 000001018021228.053580000000000000 ; 000001040225377.839440000000000000 ] >									
209 	//        < 0x00000000000000000000000000000000000000000000000000611608B633420A >									
210 	//     < AZOV_PFI_III_metadata_line_20_____Rentastroy_20251101 >									
211 	//        < t4rvI1i1dSIpEsTaOAW2c8FRene3ZUGq2725TB8OD66Z8mnukfe20v42Ix6000QR >									
212 	//        <  u =="0.000000000000000001" : ] 000001040225377.839440000000000000 ; 000001083337580.696900000000000000 ] >									
213 	//        < 0x00000000000000000000000000000000000000000000000000633420A6750ABE >									
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
256 	//     < AZOV_PFI_III_metadata_line_21_____Moscow_Industrial_Bank_20251101 >									
257 	//        < 8066TuQbi09rmw19FpCO4lSqdm8cO7NxxrwhOVx73B8U8Wozx8Q8flQrHGFgvCF3 >									
258 	//        <  u =="0.000000000000000001" : ] 000001083337580.696900000000000000 ; 000001109843685.128860000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000006750ABE69D7CB1 >									
260 	//     < AZOV_PFI_III_metadata_line_22_____Donmasloprodukt_20251101 >									
261 	//        < y49hvb4qndL3Z9IxRXrq472kLuAfQXIkCcc5ip09260csTnlu4kM1VWb8a0tj0cC >									
262 	//        <  u =="0.000000000000000001" : ] 000001109843685.128860000000000000 ; 000001185062369.055810000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000069D7CB171042FD >									
264 	//     < AZOV_PFI_III_metadata_line_23_____Rostovskiy_Portovyy_Elevator_Kovsh_20251101 >									
265 	//        < 7vU2y77rlf51iP00S4u07DYk7NlC81iUUFG0Uy4P71g939ed7w5hh56fsglmGbMV >									
266 	//        <  u =="0.000000000000000001" : ] 000001185062369.055810000000000000 ; 000001239029308.524310000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000071042FD7629BD3 >									
268 	//     < AZOV_PFI_III_metadata_line_24_____Rostov_Arena_infratructure_org_20251101 >									
269 	//        < 8Wb9AX6lXfe2OJj7HX1338xVLbASuNT5D0Ci6J74s6dh0368SpyXQg47KC3r02tT >									
270 	//        <  u =="0.000000000000000001" : ] 000001239029308.524310000000000000 ; 000001259174232.259930000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000007629BD378158EF >									
272 	//     < AZOV_PFI_III_metadata_line_25_____Rostov_Glavny_infrastructure_org_20251101 >									
273 	//        < Eo2QtP1LF4g80m8VH5PZNs4Bu0dB4zb4Byd387MVIHYHm42cKX2Kea5f22Ejv1WM >									
274 	//        <  u =="0.000000000000000001" : ] 000001259174232.259930000000000000 ; 000001336803945.842880000000000000 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000000000078158EF7F7CD0B >									
276 	//     < AZOV_PFI_III_metadata_line_26_____Rostov_Heliport_infrastructure_org_20251101 >									
277 	//        < 4oC250vRZ10kQh5852P51lbVAYrw2hCwtbfT65F0l84ZPw0S11s9qeC4V4LP27Y1 >									
278 	//        <  u =="0.000000000000000001" : ] 000001336803945.842880000000000000 ; 000001358301663.413760000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000007F7CD0B8189A96 >									
280 	//     < AZOV_PFI_III_metadata_line_27_____Taganrog_org_20251101 >									
281 	//        < p10zs63s4y8VqU2U253Xe64aC7Q375u2cDF2dFb672zBXzItWX4k1iTOA59a61Q9 >									
282 	//        <  u =="0.000000000000000001" : ] 000001358301663.413760000000000000 ; 000001379937652.091330000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000008189A968399E25 >									
284 	//     < AZOV_PFI_III_metadata_line_28_____Rostov_Airport_org_20251101 >									
285 	//        < 7V6D11e7gl58T8qxXQ5c23gMs7ok0EPh9eNyRas6Zuw7FwH2uvqvS9IejcWcrzz1 >									
286 	//        <  u =="0.000000000000000001" : ] 000001379937652.091330000000000000 ; 000001434905483.490080000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000008399E2588D7DF4 >									
288 	//     < AZOV_PFI_III_metadata_line_29_____Rostov_Airport_infrastructure_org_20251101 >									
289 	//        < 0B0cgIlFvU7rDjX0SE0Ty3v37BQz8CdhOeCOKEP1UFKRmx7vMxO34HJ21a36zPs4 >									
290 	//        <  u =="0.000000000000000001" : ] 000001434905483.490080000000000000 ; 000001494989470.830320000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000088D7DF48E92C43 >									
292 	//     < AZOV_PFI_III_metadata_line_30_____Mega_Mall_org_20251101 >									
293 	//        < kR4yz7zM2JiHla57xo6G21m20S8chas717C9JGbpKyg55v0hJlWz0wE66yS1Q48I >									
294 	//        <  u =="0.000000000000000001" : ] 000001494989470.830320000000000000 ; 000001530392621.460970000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000008E92C4391F319E >									
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
338 	//     < AZOV_PFI_III_metadata_line_31_____Mir_Remonta_org_20251101 >									
339 	//        < 16bJShv9n7GuKM8XMLy4ze9E20onCxZZRn95r0kaY7k9ZGdJ4EQj75YLsR2K041N >									
340 	//        <  u =="0.000000000000000001" : ] 000001530392621.460970000000000000 ; 000001605508644.664240000000000000 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000000000091F319E991CFD0 >									
342 	//     < AZOV_PFI_III_metadata_line_32_____Zemkombank_org_20251101 >									
343 	//        < 691D21b8aKQ6010jLDFpUH6B75BLCqbP81cq3Ww82MR08qDGTMPoL3Bvm0KJuVq9 >									
344 	//        <  u =="0.000000000000000001" : ] 000001605508644.664240000000000000 ; 000001625284999.843510000000000000 ] >									
345 	//        < 0x00000000000000000000000000000000000000000000000000991CFD09AFFCF4 >									
346 	//     < AZOV_PFI_III_metadata_line_33_____Telebashnya_tv_infrastrcture_org_20251101 >									
347 	//        < jxt3PAzavZh0a9e7r7m6GOVqmi5W3Fe4ZjJtvg73Rk62lr244e84D46f1X7P6g2R >									
348 	//        <  u =="0.000000000000000001" : ] 000001625284999.843510000000000000 ; 000001645435378.619250000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000009AFFCF49CEBC32 >									
350 	//     < AZOV_PFI_III_metadata_line_34_____Taman_Volna_infrastructures_industrielles_org_20251101 >									
351 	//        < 0AKpGhdoWig4Hzl71Uvd3pu2bXOVkZGc66xM4jzEDFx9d562g4giVexd7mw89651 >									
352 	//        <  u =="0.000000000000000001" : ] 000001645435378.619250000000000000 ; 000001727979314.214560000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000009CEBC32A4CAFEB >									
354 	//     < AZOV_PFI_III_metadata_line_35_____Yuzhnoye_Siyaniye_ooo_20251101 >									
355 	//        < zoCInaSH8n1r21FuG0E4AT8myoT45VpnSo81THxIKLiIa83JjGVh3Fuj44K9nZi9 >									
356 	//        <  u =="0.000000000000000001" : ] 000001727979314.214560000000000000 ; 000001753121797.696110000000000000 ] >									
357 	//        < 0x00000000000000000000000000000000000000000000000000A4CAFEBA730D34 >									
358 	//     < AZOV_PFI_III_metadata_line_36_____Port_Krym_org_20251101 >									
359 	//        < XpyhlS1915mi19w994qN0hEvBCkp8P35hSNuvsU4w69676hNn1tKfBuEc912ga93 >									
360 	//        <  u =="0.000000000000000001" : ] 000001753121797.696110000000000000 ; 000001771527560.178160000000000000 ] >									
361 	//        < 0x00000000000000000000000000000000000000000000000000A730D34A8F22F4 >									
362 	//     < AZOV_PFI_III_metadata_line_37_____Kerchenskaya_équipements_maritimes_20251101 >									
363 	//        < l2p14qr1he2ZQ6XDOJmv701TeY8zkvs74P948qEHw9P706F3LPyf9lvmw13773iO >									
364 	//        <  u =="0.000000000000000001" : ] 000001771527560.178160000000000000 ; 000001792698739.077290000000000000 ] >									
365 	//        < 0x00000000000000000000000000000000000000000000000000A8F22F4AAF70F2 >									
366 	//     < AZOV_PFI_III_metadata_line_38_____Kerchenskaya_ferry_20251101 >									
367 	//        < wu3iLYeAq1lTPcv32vaMPk743Y7Pyr954PheFgPG60EqqG626Bfn4An35bA5mx5Y >									
368 	//        <  u =="0.000000000000000001" : ] 000001792698739.077290000000000000 ; 000001821776933.494610000000000000 ] >									
369 	//        < 0x00000000000000000000000000000000000000000000000000AAF70F2ADBCF9D >									
370 	//     < AZOV_PFI_III_metadata_line_39_____Kerch_Port_Krym_20251101 >									
371 	//        < sPunzVuTcGAA61hj30kUQAg3ACErfm7ZX4r9FX2186s2PsRgA0c3G6M3083z3Gt9 >									
372 	//        <  u =="0.000000000000000001" : ] 000001821776933.494610000000000000 ; 000001895821036.142890000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000ADBCF9DB4CCB18 >									
374 	//     < AZOV_PFI_III_metadata_line_40_____Krym_Station_infrastructure_ferroviaire_org_20251101 >									
375 	//        < YfVHYh9BCYpo2M8y8xJ7GcN6Ehc32kwIhCmD8S11DL421a5zSy2I3M35bof3n5Nr >									
376 	//        <  u =="0.000000000000000001" : ] 000001895821036.142890000000000000 ; 000001940410213.986190000000000000 ] >									
377 	//        < 0x00000000000000000000000000000000000000000000000000B4CCB18B90D4BD >									
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