1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RE_Portfolio_VII_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RE_Portfolio_VII_883		"	;
8 		string	public		symbol =	"	RE883VII		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1592025577783000000000000000					;	
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
92 	//     < RE_Portfolio_VII_metadata_line_1_____Berkshire_Hathaway_International_Insurance_Limited_AAp_m_20250515 >									
93 	//        < b2Kw7N8NLpexUO9DEYi3BzwDFFOzXE40G65XdI97oPS6RUMggy8x8Rtkb5HJJDh1 >									
94 	//        < 1E-018 limites [ 1E-018 ; 28861009,3216454 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000AC0669B8 >									
96 	//     < RE_Portfolio_VII_metadata_line_2_____Berkshire_Hathaway_Reinsurance_Group_20250515 >									
97 	//        < q8N3AiSQHotWCy8QaoMidG5VNk6nk7UD4284UfEWO19c4ie4rk4wxO53DcC5z2zA >									
98 	//        < 1E-018 limites [ 28861009,3216454 ; 107464025,849827 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000AC0669B828089190C >									
100 	//     < RE_Portfolio_VII_metadata_line_3_____Berkshire_Hathaway_Reinsurance_Group_20250515 >									
101 	//        < ItB1QMaSI43svE614VC54wE43pTHK4GcSjbbq21s95VP18Poh2t06U96MUubV83j >									
102 	//        < 1E-018 limites [ 107464025,849827 ; 156578902,884003 ] >									
103 	//        < 0x000000000000000000000000000000000000000000000028089190C3A54873E4 >									
104 	//     < RE_Portfolio_VII_metadata_line_4_____BMA_Reinsurance_20250515 >									
105 	//        < 90n5m1q50K17iUBt7rUP29etVnJ4ctxfYFrB4Ub3ls4KmnQ30XAM7W8436h6LIbO >									
106 	//        < 1E-018 limites [ 156578902,884003 ; 225896638,136609 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000003A54873E454272EC39 >									
108 	//     < RE_Portfolio_VII_metadata_line_5_____BMS_Group_20250515 >									
109 	//        < LrA09QyS6bkUkdaknm7PZDX1X588y9N8p13SS2RWISX7H8Cm3UmoM95Js53821FT >									
110 	//        < 1E-018 limites [ 225896638,136609 ; 268843872,939129 ] >									
111 	//        < 0x000000000000000000000000000000000000000000000054272EC396426F33D1 >									
112 	//     < RE_Portfolio_VII_metadata_line_6_____Brazil_BBBm_IRB_Brasil_Resseguros_SA_Am_20250515 >									
113 	//        < iAqv2Ie5kCO6C5y6Y4O9Y61E3K45JC0H913yvt70MrM4lTTNIkSzC8PNy53ZjeT8 >									
114 	//        < 1E-018 limites [ 268843872,939129 ; 308603123,761401 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000006426F33D172F6B012C >									
116 	//     < RE_Portfolio_VII_metadata_line_7_____Brit_Syndicates_Limited_20250515 >									
117 	//        < S7A2xFrB261sM3Ov9trH9pikH5q6MvIZ92ie38mpWIxIYoLc1D1yR8l2b6FI3I9A >									
118 	//        < 1E-018 limites [ 308603123,761401 ; 343931584,044248 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000072F6B012C801FDF4F8 >									
120 	//     < RE_Portfolio_VII_metadata_line_8_____Brit_Syndicates_Limited_20250515 >									
121 	//        < m115VJCWvGd95ZU2sU1LSZ3yS5o9L3K9I36sKGjwIkKBftNtffo7vLcjO6BN5U5D >									
122 	//        < 1E-018 limites [ 343931584,044248 ; 358777504,407766 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000801FDF4F885A7B089C >									
124 	//     < RE_Portfolio_VII_metadata_line_9_____Brit_Syndicates_Limited_20250515 >									
125 	//        < 3IsEaM4aUW6EOzlM229lwPP2O79e85Tf0Ta0nZh6Wtn5MfA1KWespDC134GH8819 >									
126 	//        < 1E-018 limites [ 358777504,407766 ; 372565099,747833 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000085A7B089C8ACA93C0A >									
128 	//     < RE_Portfolio_VII_metadata_line_10_____Brit_Syndicates_Limited_20250515 >									
129 	//        < AGuXVF6ZY4O21cq4ty4XPN99LYigVghLBc1L09Vj7870B26u4blzi8g5V18MA38X >									
130 	//        < 1E-018 limites [ 372565099,747833 ; 385953922,720421 ] >									
131 	//        < 0x00000000000000000000000000000000000000000000008ACA93C0A8FC76F504 >									
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
174 	//     < RE_Portfolio_VII_metadata_line_11_____Brit_Syndicates_Limited_20250515 >									
175 	//        < U6Xx2H39v5l6Y9Z73Y54l7q51QOFyAo50A3NGJA39AZ0k7aJ2iU6nDTyAEeQWYjr >									
176 	//        < 1E-018 limites [ 385953922,720421 ; 412504411,61062 ] >									
177 	//        < 0x00000000000000000000000000000000000000000000008FC76F50499AB7C9BD >									
178 	//     < RE_Portfolio_VII_metadata_line_12_____Brokers_and_Reinsurance_Markets_Association_20250515 >									
179 	//        < nm1PPphX6q44Elqew1o14Sh43mMjmu29vT42bSvH3X7p9cd59gEPEFg3qtGz8Nyh >									
180 	//        < 1E-018 limites [ 412504411,61062 ; 470029652,520769 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000099AB7C9BDAF19856F8 >									
182 	//     < RE_Portfolio_VII_metadata_line_13_____Bupa_Insurance_Limited_m_m_Ap_20250515 >									
183 	//        < K710Q7qakg8G04VxjM119Ag7zyUnFVCvAp3750pxn0q1lJ8RUDj4n16FgjO09Ipf >									
184 	//        < 1E-018 limites [ 470029652,520769 ; 529445170,584736 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000AF19856F8C53BD39B6 >									
186 	//     < RE_Portfolio_VII_metadata_line_14_____Caisse_Centrale_de_Reassurance_20250515 >									
187 	//        < plW6bPISG5QOtNj1q80KTU7DxRVfuGnRAKLbVHvYSAJhh477OUn8bB0eU2aFIjpN >									
188 	//        < 1E-018 limites [ 529445170,584736 ; 570996370,239225 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000C53BD39B6D4B675313 >									
190 	//     < RE_Portfolio_VII_metadata_line_15_____Caisse_Centrale_De_Reassurances_AA_Ap_20250515 >									
191 	//        < Tb5iztS43oSmPHuBRLGBb8B13w6MheR601cCN72yf2L0h5JJSG5VaS8b4YA54D8Y >									
192 	//        < 1E-018 limites [ 570996370,239225 ; 610567161,106495 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000D4B675313E37438F42 >									
194 	//     < RE_Portfolio_VII_metadata_line_16_____Canopius_Managing_Agents_Limited_20250515 >									
195 	//        < 18id6wj89rSlBWm6zh5w9T2dJckc5IIK61r3V2Le82wIkV4z7sIW98Maukbd5NfD >									
196 	//        < 1E-018 limites [ 610567161,106495 ; 634621545,227274 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000E37438F42EC6A3A30E >									
198 	//     < RE_Portfolio_VII_metadata_line_17_____Canopius_Managing_Agents_Limited_20250515 >									
199 	//        < 8Wdt3IQq7L9gyiSK9ratR9W53KhsZO39NRyK52R7Y06l66rvLurgvSH9mlryDY2Q >									
200 	//        < 1E-018 limites [ 634621545,227274 ; 709240475,887454 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000EC6A3A30E10836716D8 >									
202 	//     < RE_Portfolio_VII_metadata_line_18_____Canopius_Managing_Agents_Limited_20250515 >									
203 	//        < 743Asq989tw5Pg25SOe98z8D8Qr2txb7z6ttvk7zm87I8LhRI8htp0FJurB9jHb0 >									
204 	//        < 1E-018 limites [ 709240475,887454 ; 728455638,269099 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000010836716D810F5EF19A6 >									
206 	//     < RE_Portfolio_VII_metadata_line_19_____Canopius_Managing_Agents_Limited_20250515 >									
207 	//        < GH980xvE51LE4Ck4l67w0DNSN4sBWenVAKtZmEgcYSj7jGo9NCv5K4sXo7OKlYz4 >									
208 	//        < 1E-018 limites [ 728455638,269099 ; 796646250,67732 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000010F5EF19A6128C61B79F >									
210 	//     < RE_Portfolio_VII_metadata_line_20_____Canopius_Managing_Agents_Limited_20250515 >									
211 	//        < 3NjghNjmTp8wIYy65BawvhZQ5841nAXSq8Fgf9OoAZfCEk87jlv7cIQAnk9yk8F8 >									
212 	//        < 1E-018 limites [ 796646250,67732 ; 866150965,247675 ] >									
213 	//        < 0x00000000000000000000000000000000000000000000128C61B79F142AA97EC0 >									
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
256 	//     < RE_Portfolio_VII_metadata_line_21_____Canopius_Managing_Agents_Limited_20250515 >									
257 	//        < oB2qV58TLsEIplhD773ezluCTpT233XtMp2z8CAJ90G1m80Ewk8fpq74v7YB81dP >									
258 	//        < 1E-018 limites [ 866150965,247675 ; 911550225,474008 ] >									
259 	//        < 0x00000000000000000000000000000000000000000000142AA97EC015394344C7 >									
260 	//     < RE_Portfolio_VII_metadata_line_22_____Capita_Managing_Agency_Limited_20250515 >									
261 	//        < Y4HxliqD4Bkba3qZ64pJe959ka7O705i9BqzEKtf956XZ2N5335o882J5c98J904 >									
262 	//        < 1E-018 limites [ 911550225,474008 ; 928785290,209167 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000015394344C7159FFDE3F0 >									
264 	//     < RE_Portfolio_VII_metadata_line_23_____Capita_Managing_Agency_Limited_20250515 >									
265 	//        < tRKSkJh254Ct15siHPIxstOy6ixDaq87LT7ULR43tfg8Q84MRNMH0gok4kXjE8c0 >									
266 	//        < 1E-018 limites [ 928785290,209167 ; 963046935,558646 ] >									
267 	//        < 0x00000000000000000000000000000000000000000000159FFDE3F0166C350327 >									
268 	//     < RE_Portfolio_VII_metadata_line_24_____Capita_Managing_Agency_Limited_20250515 >									
269 	//        < 71dDpv6l1PN84VUr6Vg3gDu6L2P4rnL611q1XLzLVu0j4gow6n5N8L1spP7mz0Ow >									
270 	//        < 1E-018 limites [ 963046935,558646 ; 991939291,134446 ] >									
271 	//        < 0x00000000000000000000000000000000000000000000166C35032717186B3F8D >									
272 	//     < RE_Portfolio_VII_metadata_line_25_____Capita_Syndicate_Management_Limited_20250515 >									
273 	//        < kbJS4Q0zWqi939zCwx819gt29981vLVh06N79a20e1nNSLiSueN523Pl2yQqv7lQ >									
274 	//        < 1E-018 limites [ 991939291,134446 ; 1037908231,48745 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000017186B3F8D182A6A48E0 >									
276 	//     < RE_Portfolio_VII_metadata_line_26_____CATEX_20250515 >									
277 	//        < 3L349am55q947sNG4cQtrjo9x67Nq4fZ5wyq7OKXq4RV1c0g54E9jVhHbgLMaQc9 >									
278 	//        < 1E-018 limites [ 1037908231,48745 ; 1078340115,43145 ] >									
279 	//        < 0x00000000000000000000000000000000000000000000182A6A48E0191B68718B >									
280 	//     < RE_Portfolio_VII_metadata_line_27_____Cathedral_Underwriting_Limited_20250515 >									
281 	//        < 9p32f1X77t66v3bd030ZTxzhkr4dPdi8tR0Gax41G5z1KU9KZ1drJGr04K1hnNFD >									
282 	//        < 1E-018 limites [ 1078340115,43145 ; 1101365908,94578 ] >									
283 	//        < 0x00000000000000000000000000000000000000000000191B68718B19A4A70422 >									
284 	//     < RE_Portfolio_VII_metadata_line_28_____Cathedral_Underwriting_Limited_20250515 >									
285 	//        < kQdG979c3vqaJE0xU0NOcAaVc11p8DPdR9Xr8oxFpx90Q1fdLmwrv267082c8Vg7 >									
286 	//        < 1E-018 limites [ 1101365908,94578 ; 1112971320,90702 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000019A4A7042219E9D3782E >									
288 	//     < RE_Portfolio_VII_metadata_line_29_____Cathedral_Underwriting_Limited_20250515 >									
289 	//        < X9O45WNjJS7Mnsus4Z1mt6jT9GuTyKtRw4sp5wqVf2go6qfS6Bz8W25MK65Z5WOu >									
290 	//        < 1E-018 limites [ 1112971320,90702 ; 1154178273,69648 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000019E9D3782E1ADF704A1D >									
292 	//     < RE_Portfolio_VII_metadata_line_30_____Cathedral_Underwriting_Limited_20250515 >									
293 	//        < P36TQxq24OSV4ws8fnK2DA3r3m4W5110u3OABNq428mrc396x2jJGPDoos5nE7QE >									
294 	//        < 1E-018 limites [ 1154178273,69648 ; 1231472431,73042 ] >									
295 	//        < 0x000000000000000000000000000000000000000000001ADF704A1D1CAC25D099 >									
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
338 	//     < RE_Portfolio_VII_metadata_line_31_____Catlin_Group_Limited_20250515 >									
339 	//        < 61GVGIQYL8Q9kT5hodT5hWFoMyt4DD904h9Tm654761W5Si3rete9g5gq2n1dhM6 >									
340 	//        < 1E-018 limites [ 1231472431,73042 ; 1284605995,8667 ] >									
341 	//        < 0x000000000000000000000000000000000000000000001CAC25D0991DE8D93316 >									
342 	//     < RE_Portfolio_VII_metadata_line_32_____Catlin_Insurance_Co__UK__Limited_Ap_A_20250515 >									
343 	//        < 2xVmTVG1tECxk5VMvw255OiyL2B1I326Xjm4x9t29Ny1bLAZ168EwcHZ32zV0hry >									
344 	//        < 1E-018 limites [ 1284605995,8667 ; 1336052033,84697 ] >									
345 	//        < 0x000000000000000000000000000000000000000000001DE8D933161F1B7D9FAC >									
346 	//     < RE_Portfolio_VII_metadata_line_33_____Catlin_Underwriting_Agencies_Limited_20250515 >									
347 	//        < E3bp6E00FJ99x188Tx4Z3tlW1TCtc2G673b23tu4gqo94sCW8s8c14GnlVWI31PE >									
348 	//        < 1E-018 limites [ 1336052033,84697 ; 1370206406,98323 ] >									
349 	//        < 0x000000000000000000000000000000000000000000001F1B7D9FAC1FE7110FAE >									
350 	//     < RE_Portfolio_VII_metadata_line_34_____Catlin_Underwriting_Agencies_Limited_20250515 >									
351 	//        < 88lH0RC20NtFHzc6J3lANBl62ZvM4jF3i25aGyr2GWvFqoEQGNv51UqnLubTS152 >									
352 	//        < 1E-018 limites [ 1370206406,98323 ; 1420776102,95507 ] >									
353 	//        < 0x000000000000000000000000000000000000000000001FE7110FAE21147C4B2B >									
354 	//     < RE_Portfolio_VII_metadata_line_35_____Catlin_Underwriting_Agencies_Limited_20250515 >									
355 	//        < Em9G1QTC4bY8YdArAG5elayZC8ZcZ4Xclj88QuCElSjw73xf24s8SBS0zST45mCy >									
356 	//        < 1E-018 limites [ 1420776102,95507 ; 1437757599,24907 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000021147C4B2B2179B40028 >									
358 	//     < RE_Portfolio_VII_metadata_line_36_____Catlin_Underwriting_Agencies_Limited_20250515 >									
359 	//        < r9ot7qP0606n0aMHjz4646u5CL3e45x37apcQVVNEY6Yf2RQGNv8rq1kF6ID12OL >									
360 	//        < 1E-018 limites [ 1437757599,24907 ;  ] >									
361 	//        < 0x000000000000000000000000000000000000000000002179B4002821BF0C8EA6 >									
362 	//     < RE_Portfolio_VII_metadata_line_37_____Catlin_Underwriting_Agencies_Limited_20250515 >									
363 	//        < kq1DM5qMxzs1H8XNfzh45Zd57PBCCZdWux227wuG9y7R2Wdt3IalFgCMxMK6nR69 >									
364 	//        < 1E-018 limites [ 1449391914,74149 ; 1481978387,72403 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000021BF0C8EA622814791A8 >									
366 	//     < RE_Portfolio_VII_metadata_line_38_____Catlin_Underwriting_Agencies_Limited_20250515 >									
367 	//        < z0gO77HGAoF8sEX1xC6J0GQ6r008lKzr7Z6J6UEl0dxbwe3C6E18L998TYW2vJlh >									
368 	//        < 1E-018 limites [ 1481978387,72403 ; 1499789073,80768 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000022814791A822EB7084E8 >									
370 	//     < RE_Portfolio_VII_metadata_line_39_____Catlin_Underwriting_Agencies_Limited_20250515 >									
371 	//        < 3taHI79Yi7Hu789aeRe83J72k532iwuAl602g83C2oDbqn65duAhpAiupY809JUM >									
372 	//        < 1E-018 limites [ 1499789073,80768 ; 1556004519,32335 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000022EB7084E8243A827B50 >									
374 	//     < RE_Portfolio_VII_metadata_line_40_____Catlin_Underwriting_Agencies_Limited_20250515 >									
375 	//        < 5Q1rUNRh1I6y20uLrt7V3ano8Akgo5374EyJtn2s4HpJ7cMPJA3BXK60pi2PT55p >									
376 	//        < 1E-018 limites [ 1556004519,32335 ; 1592025577,783 ] >									
377 	//        < 0x00000000000000000000000000000000000000000000243A827B502511364146 >									
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