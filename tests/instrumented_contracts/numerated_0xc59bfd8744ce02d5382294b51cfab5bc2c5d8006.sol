1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFIX_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFIX_III_883		"	;
8 		string	public		symbol =	"	RUSS_PFIX_III_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1056649107163550000000000000					;	
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
92 	//     < RUSS_PFIX_III_metadata_line_1_____POLYUS_GOLD_20251101 >									
93 	//        < 7FAvAz1dlcsMsUfOz9bA3YAuH180N8uWVGhMr5x77JVfdi0TcM4sV6fiTG60MzOX >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000020931579.115583100000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000001FF066 >									
96 	//     < RUSS_PFIX_III_metadata_line_2_____POLYUS_GOLD_GBP_20251101 >									
97 	//        < cQCW8kIV9g4ghl60ACQVi1y5Ga9W1CrRKEm6m6XDKej7GG9ur5trmcX91wU5ocof >									
98 	//        <  u =="0.000000000000000001" : ] 000000020931579.115583100000000000 ; 000000055037451.881143100000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000001FF06653FB01 >									
100 	//     < RUSS_PFIX_III_metadata_line_3_____POLYUS_GOLD_USD_20251101 >									
101 	//        < W850b6x73s93Mp6I23S7HaDct58GK7C3C4T6QhJmkM58EbC3z9A53m1FVt6HTcYn >									
102 	//        <  u =="0.000000000000000001" : ] 000000055037451.881143100000000000 ; 000000086668074.228881500000000000 ] >									
103 	//        < 0x000000000000000000000000000000000000000000000000000053FB01843EB7 >									
104 	//     < RUSS_PFIX_III_metadata_line_4_____POLYUS_KRASNOYARSK_20251101 >									
105 	//        < 44T7ZLqKN5Mw7oZ4b6CZqxcUZsca8KGkKM39vHUVxd6zUO3oT2tdT5fZhV9csbC5 >									
106 	//        <  u =="0.000000000000000001" : ] 000000086668074.228881500000000000 ; 000000110761956.974495000000000000 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000000000843EB7A90264 >									
108 	//     < RUSS_PFIX_III_metadata_line_5_____POLYUS_FINANCE_PLC_20251101 >									
109 	//        < uZXxGXPGeZ8rz0YIeeB0n471UyK2rSWXB6vj5b95Ois14VsVMf9FhVX2XcoTHgu5 >									
110 	//        <  u =="0.000000000000000001" : ] 000000110761956.974495000000000000 ; 000000137776879.942687000000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000A90264D23B18 >									
112 	//     < RUSS_PFIX_III_metadata_line_6_____POLYUS_FINANS_FI_20251101 >									
113 	//        < 68Lf6QqKJ24G3i48FF232S1LFNxx5i8zqYhHG396BjHRCg1cMQ1S38yX435WmUi1 >									
114 	//        <  u =="0.000000000000000001" : ] 000000137776879.942687000000000000 ; 000000166551054.487248000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000D23B18FE2301 >									
116 	//     < RUSS_PFIX_III_metadata_line_7_____POLYUS_FINANS_FII_20251101 >									
117 	//        < 2N8mB1xupHuxt7YPzR1Nkfwx9469N4mNg8MjXU5FfMN2d4t1A07E4ucMHJ0gjN8P >									
118 	//        <  u =="0.000000000000000001" : ] 000000166551054.487248000000000000 ; 000000192728830.767712000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000000FE230112614B3 >									
120 	//     < RUSS_PFIX_III_metadata_line_8_____POLYUS_FINANS_FIII_20251101 >									
121 	//        < mmV7Kl5DxuZ5TJlF0WROkG2RB7715KE7PFt7M0FlxoJArU0B8S64I26ghXMBPgfy >									
122 	//        <  u =="0.000000000000000001" : ] 000000192728830.767712000000000000 ; 000000219473801.731417000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000012614B314EE3F4 >									
124 	//     < RUSS_PFIX_III_metadata_line_9_____POLYUS_FINANS_FIV_20251101 >									
125 	//        < vuQi2RbT1luG5jLDbGE20aWOH33156C2AxX6hKqE11aW5drT7pRvSt4okW1267jy >									
126 	//        <  u =="0.000000000000000001" : ] 000000219473801.731417000000000000 ; 000000250235109.924257000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000014EE3F417DD417 >									
128 	//     < RUSS_PFIX_III_metadata_line_10_____POLYUS_FINANS_FV_20251101 >									
129 	//        < czRWVED1R7D68M7tHO1lYU518L7HVBun6ua65HIZ8l63WfjWhQQBNcCd26TwITPE >									
130 	//        <  u =="0.000000000000000001" : ] 000000250235109.924257000000000000 ; 000000270171624.156869000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000017DD41719C3FCA >									
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
174 	//     < RUSS_PFIX_III_metadata_line_11_____POLYUS_FINANS_FVI_20251101 >									
175 	//        < 5g1Z2P54ev5I9T92MUkpv8QIawxNCw4mJc9spvaI8HWQRygKk431uH61lhMW6o2U >									
176 	//        <  u =="0.000000000000000001" : ] 000000270171624.156869000000000000 ; 000000289734488.388797000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000019C3FCA1BA1989 >									
178 	//     < RUSS_PFIX_III_metadata_line_12_____POLYUS_FINANS_FVII_20251101 >									
179 	//        < T77FFopHV80lQOo52j90TA5lW0L5DH2xB6KDIZco17e2J6PyVH4x4s506qRVDn4H >									
180 	//        <  u =="0.000000000000000001" : ] 000000289734488.388797000000000000 ; 000000317262495.316675000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000001BA19891E41AAA >									
182 	//     < RUSS_PFIX_III_metadata_line_13_____POLYUS_FINANS_FVIII_20251101 >									
183 	//        < eaOhro0FX5yL1762AvXcneL768biMv0SsfjHOSB9061NL2yGmCI9210T0dS90SPO >									
184 	//        <  u =="0.000000000000000001" : ] 000000317262495.316675000000000000 ; 000000352241627.038582000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001E41AAA2197A63 >									
186 	//     < RUSS_PFIX_III_metadata_line_14_____POLYUS_FINANS_FIX_20251101 >									
187 	//        < VDwDbYQX3WbIOr24S62vu76SEpuHC3jNykSo49yAnmf2XJ9Wm0H7W85wxPrMM6i7 >									
188 	//        <  u =="0.000000000000000001" : ] 000000352241627.038582000000000000 ; 000000374782466.213340000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000002197A6323BDF67 >									
190 	//     < RUSS_PFIX_III_metadata_line_15_____POLYUS_FINANS_FX_20251101 >									
191 	//        < 5HE2t86Z4jMJqwHq0lnicU03pSNILyntb1M1oIJ35go9w5hsFP8kRG9MHM3WQe1H >									
192 	//        <  u =="0.000000000000000001" : ] 000000374782466.213340000000000000 ; 000000394231224.350087000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000023BDF672598C92 >									
194 	//     < RUSS_PFIX_III_metadata_line_16_____SVETLIY_20251101 >									
195 	//        < v26iSr1N1Y0Ofq3cHXSy7r561y6F6etlD750y2X67oyY8hP6URh65SYl7HBq9sPI >									
196 	//        <  u =="0.000000000000000001" : ] 000000394231224.350087000000000000 ; 000000429911137.019477000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000002598C9228FFE0A >									
198 	//     < RUSS_PFIX_III_metadata_line_17_____POLYUS_EXPLORATION_20251101 >									
199 	//        < 07INTk4W8NWYEytPfp9sq73LSlIkelrUc76C74wbXF521OV9ct0Y97c9byzRohO3 >									
200 	//        <  u =="0.000000000000000001" : ] 000000429911137.019477000000000000 ; 000000448552978.985361000000000000 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000000028FFE0A2AC7002 >									
202 	//     < RUSS_PFIX_III_metadata_line_18_____ZL_ZOLOTO_20251101 >									
203 	//        < wDEU9H2N8w2oPo23e13G0v5KO9u8rbcsmU9q66jQ7TF2uGuQC21I89ZaGa07a6xt >									
204 	//        <  u =="0.000000000000000001" : ] 000000448552978.985361000000000000 ; 000000476420690.450888000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000002AC70022D6F5D5 >									
206 	//     < RUSS_PFIX_III_metadata_line_19_____SK_FOUNDATION_LUZERN_20251101 >									
207 	//        < am8Pq4YKF72X2DsseOZ58ja5WY8n52v87hs1eNygmJQalH9ayjI0kStuNQ1EO6s5 >									
208 	//        <  u =="0.000000000000000001" : ] 000000476420690.450888000000000000 ; 000000494905282.010972000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000002D6F5D52F32A60 >									
210 	//     < RUSS_PFIX_III_metadata_line_20_____SKFL_AB_20251101 >									
211 	//        < 5xPgyVJ7K25hPFnm6Y0hF39ATG3u08Nam0r8S56y9CtLnA9G0AUDi552PonQ9Y5x >									
212 	//        <  u =="0.000000000000000001" : ] 000000494905282.010972000000000000 ; 000000513853994.396595000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000002F32A603101437 >									
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
256 	//     < RUSS_PFIX_III_metadata_line_21_____AB_URALKALI_20251101 >									
257 	//        < vnmW5QdHScAGx8BTh6ewoL09lEevMW4F9Vmr6SCnEAP4Y136sfWg66TUeXg8nh2J >									
258 	//        <  u =="0.000000000000000001" : ] 000000513853994.396595000000000000 ; 000000534921916.151287000000000000 ] >									
259 	//        < 0x00000000000000000000000000000000000000000000000000310143733039E0 >									
260 	//     < RUSS_PFIX_III_metadata_line_22_____AB_FK_ANZHI_MAKHA_20251101 >									
261 	//        < q08Y4yqANors0SQJt53f1nRr9a61n86hZnUO8t80is30Nx2hn0U30kBXB17Be79A >									
262 	//        <  u =="0.000000000000000001" : ] 000000534921916.151287000000000000 ; 000000554903565.879158000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000033039E034EB735 >									
264 	//     < RUSS_PFIX_III_metadata_line_23_____AB_NAFTA_MOSKVA_20251101 >									
265 	//        < 4ZXpvLfxS6aO2Ola4cWc1Cy1J1B434zg2JoSss1F977yKhq89kR7jLbAcw9iCow9 >									
266 	//        <  u =="0.000000000000000001" : ] 000000554903565.879158000000000000 ; 000000585173741.382743000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000034EB73537CE77E >									
268 	//     < RUSS_PFIX_III_metadata_line_24_____AB_SOYUZNEFTEEXPOR_20251101 >									
269 	//        < QVGca4Vu5DjpKGgdQvpdjPptogyCXORbPSJ4353LkMRQO46GCAGGy083MJl0U511 >									
270 	//        <  u =="0.000000000000000001" : ] 000000585173741.382743000000000000 ; 000000610118563.084978000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000037CE77E3A2F790 >									
272 	//     < RUSS_PFIX_III_metadata_line_25_____AB_FEDPROMBANK_20251101 >									
273 	//        < n52cXJrn33zwV72cQKhvG07I0Ez1hu24Yv7LN5Vz8wCs38cmNo1LD5yKnnPEX9Pv >									
274 	//        <  u =="0.000000000000000001" : ] 000000610118563.084978000000000000 ; 000000641776396.803725000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000003A2F7903D345E8 >									
276 	//     < RUSS_PFIX_III_metadata_line_26_____AB_ELTAV_ELEC_20251101 >									
277 	//        < VmUG4yQng0WdHshin8co7csmzscTwTmyNSJ3we5DrArKq68Vb2ixxiqAPOxu17Pl >									
278 	//        <  u =="0.000000000000000001" : ] 000000641776396.803725000000000000 ; 000000669841617.443422000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000003D345E83FE18E2 >									
280 	//     < RUSS_PFIX_III_metadata_line_27_____AB_SOYUZ_FINANS_20251101 >									
281 	//        < nh0qs0c8uWxj80Fd6MRF27ZPRc2zvc4F0JL0dS6nmFAxI28N8x0EX7tURKq0E9B9 >									
282 	//        <  u =="0.000000000000000001" : ] 000000669841617.443422000000000000 ; 000000690443337.551817000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000003FE18E241D886E >									
284 	//     < RUSS_PFIX_III_metadata_line_28_____AB_VNUKOVO_20251101 >									
285 	//        < nAm9Ytd1oFIs3JPi0lM9ELp2G000s58Z70274EESI3IaDhFPGVRgtaH7y77A4Q3v >									
286 	//        <  u =="0.000000000000000001" : ] 000000690443337.551817000000000000 ; 000000720712545.347270000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000041D886E44BB857 >									
288 	//     < RUSS_PFIX_III_metadata_line_29_____AB_AVTOBANK_20251101 >									
289 	//        < 7ppMB33S76Zbl0zhg0pmh5PdYY3qW2MF2IdZZwXH8wJMr00JCcb9TdD6swJrO1Ef >									
290 	//        <  u =="0.000000000000000001" : ] 000000720712545.347270000000000000 ; 000000753181847.384444000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000044BB85747D43A9 >									
292 	//     < RUSS_PFIX_III_metadata_line_30_____AB_SMOLENSKY_PASSAZH_20251101 >									
293 	//        < 51WLhq4KsKpo3TSIc8D5BpLnRPLi35hf8Av0djnMg7C7ny3evT17q131j7DmDsk3 >									
294 	//        <  u =="0.000000000000000001" : ] 000000753181847.384444000000000000 ; 000000783121444.219346000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000047D43A94AAF2D0 >									
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
338 	//     < RUSS_PFIX_III_metadata_line_31_____MAKHA_PORT_20251101 >									
339 	//        < Ed70A56x2LUSiW44Sbu72qScRvWPaFsw5476tQAycM8OEb0SYsVj49KBs82Qn3NT >									
340 	//        <  u =="0.000000000000000001" : ] 000000783121444.219346000000000000 ; 000000813943568.196401000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000004AAF2D04D9FAB5 >									
342 	//     < RUSS_PFIX_III_metadata_line_32_____MAKHA_AIRPORT_AB_20251101 >									
343 	//        < dkuM5X8ZP9Lv409gBvY57z13bhz93CFeE50oxCTZtXtjIklijtheJkoK2q6wQe25 >									
344 	//        <  u =="0.000000000000000001" : ] 000000813943568.196401000000000000 ; 000000833939469.872086000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000004D9FAB54F87D9B >									
346 	//     < RUSS_PFIX_III_metadata_line_33_____DAG_ORG_20251101 >									
347 	//        < Of0s21v0j6A0zJquCHtVdFK154nigdN65c32r8h12veCMlZLpBLPr1VU0dvZgWfR >									
348 	//        <  u =="0.000000000000000001" : ] 000000833939469.872086000000000000 ; 000000853493595.130085000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000004F87D9B51653F0 >									
350 	//     < RUSS_PFIX_III_metadata_line_34_____DAG_DAO_20251101 >									
351 	//        < 5LVOPjtJbALHVFqMnoVyb092oo2yzMJ3PGb3228lIv613WFW3l0496MDRl1ex3mI >									
352 	//        <  u =="0.000000000000000001" : ] 000000853493595.130085000000000000 ; 000000887426059.602530000000000000 ] >									
353 	//        < 0x0000000000000000000000000000000000000000000000000051653F054A1ACE >									
354 	//     < RUSS_PFIX_III_metadata_line_35_____DAG_DAOPI_20251101 >									
355 	//        < 3JMGm65wvYYH7N0D8140O0cOO297YJoF4q4J24ICa4bTpqv7M0u0E8wjP9jlf1f1 >									
356 	//        <  u =="0.000000000000000001" : ] 000000887426059.602530000000000000 ; 000000922341314.894016000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000054A1ACE57F6193 >									
358 	//     < RUSS_PFIX_III_metadata_line_36_____DAG_DAC_20251101 >									
359 	//        < vxBCjI44687guRXJ4rQkfSeokiExQ5M6MBLC3fA3j6me907mSTgyuHqB1mb2w829 >									
360 	//        <  u =="0.000000000000000001" : ] 000000922341314.894016000000000000 ; 000000947125083.251276000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000057F61935A532BC >									
362 	//     < RUSS_PFIX_III_metadata_line_37_____MAKHA_ORG_20251101 >									
363 	//        < 51u95MXuo91Cu8Cl91z29e3QF1nBPscj718G27iGyEdgda73ADVfmZdfg4lo7bI6 >									
364 	//        <  u =="0.000000000000000001" : ] 000000947125083.251276000000000000 ; 000000970828131.930115000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000005A532BC5C95DBD >									
366 	//     < RUSS_PFIX_III_metadata_line_38_____MAKHA_DAO_20251101 >									
367 	//        < 392Y3aXcCE6IWCBkEZ94T3YE6S7u9w76W6sUj15T3FZU4722TXa0YlD9MYrk08m5 >									
368 	//        <  u =="0.000000000000000001" : ] 000000970828131.930115000000000000 ; 000000996177267.351476000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000005C95DBD5F00BBF >									
370 	//     < RUSS_PFIX_III_metadata_line_39_____MAKHA_DAOPI_20251101 >									
371 	//        < 6Ees8FEe164HSm3VoyofrY0xTHk39DVcRKU9C0t1WIJ5B9v8Fk51J2gpm12688Hn >									
372 	//        <  u =="0.000000000000000001" : ] 000000996177267.351476000000000000 ; 000001025384422.052440000000000000 ] >									
373 	//        < 0x000000000000000000000000000000000000000000000000005F00BBF61C9CCA >									
374 	//     < RUSS_PFIX_III_metadata_line_40_____MAKHA_DAC_20251101 >									
375 	//        < tpPB22jdfqz3QQQ1FPZ55u7kEm3FZ3YZG5OXw6aNYEJjgz76662u56fm3279LrOV >									
376 	//        <  u =="0.000000000000000001" : ] 000001025384422.052440000000000000 ; 000001056649107.163550000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000061C9CCA64C518F >									
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