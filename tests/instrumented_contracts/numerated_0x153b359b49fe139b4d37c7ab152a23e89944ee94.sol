1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	BANK_III_PFIII_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	BANK_III_PFIII_883		"	;
8 		string	public		symbol =	"	BANK_III_PFIII_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		439201543085926000000000000					;	
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
92 	//     < BANK_III_PFIII_metadata_line_1_____PITTSBURG BANK_20260508 >									
93 	//        < DU98SbaXwv7u6xOeFiVX2kzfno7F29gh5PW7wW34R0FD386CIxanhac5065DZ2fp >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000010832852.905601300000000000 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000000010913E >									
96 	//     < BANK_III_PFIII_metadata_line_2_____BANK OF AMERICA_20260508 >									
97 	//        < 6yL3RY6KIrciA6swhEUQ7153k9Y1v51704cy6Ip8PRh4WI0TMJ3V1lS97l7alnRV >									
98 	//        <  u =="0.000000000000000001" : ] 000000010832852.905601300000000000 ; 000000021654261.089122400000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000010913E20A656 >									
100 	//     < BANK_III_PFIII_metadata_line_3_____WELLS FARGO_20260508 >									
101 	//        < nUN8Oh5y0K4Y9deyr928SU17T93bS397ikL77T3aev202NP8BG4JfwYuYo43IM3p >									
102 	//        <  u =="0.000000000000000001" : ] 000000021654261.089122400000000000 ; 000000032759731.698903400000000000 ] >									
103 	//        < 0x000000000000000000000000000000000000000000000000000020A656310103 >									
104 	//     < BANK_III_PFIII_metadata_line_4_____MORGAN STANLEY_20260508 >									
105 	//        < W6023y8323R3srrx467UK49726Xht679uQ58iqGYHh133s5gByBhu8ySfiul32e9 >									
106 	//        <  u =="0.000000000000000001" : ] 000000032759731.698903400000000000 ; 000000043600607.257665900000000000 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000000000310103415496 >									
108 	//     < BANK_III_PFIII_metadata_line_5_____LEHAN BROTHERS AB_20260508 >									
109 	//        < F8um08mD15w4PAPy24dW9QA7L7WkDBqDh3pu038va6bzhjkzhpYo24P475DqCvg3 >									
110 	//        <  u =="0.000000000000000001" : ] 000000043600607.257665900000000000 ; 000000054710909.594309000000000000 ] >									
111 	//        < 0x000000000000000000000000000000000000000000000000000041549651AA21 >									
112 	//     < BANK_III_PFIII_metadata_line_6_____BARCLAYS_20260508 >									
113 	//        < Vsr0rkZn95ettGCGTP8dHXHKODN7Odpd8isl6qa9IMU33LR8z9i3p5Vx0hn7rd84 >									
114 	//        <  u =="0.000000000000000001" : ] 000000054710909.594309000000000000 ; 000000065884331.732601100000000000 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000000000051AA216230A3 >									
116 	//     < BANK_III_PFIII_metadata_line_7_____GLDMAN SACHS_20260508 >									
117 	//        < 4PQ280jOj8K89Lo3j74Ol57Jo9LG49EZ41O73y0jqIfMIL8hfpQJ92NK1nfx3Xsf >									
118 	//        <  u =="0.000000000000000001" : ] 000000065884331.732601100000000000 ; 000000076875649.076077400000000000 ] >									
119 	//        < 0x00000000000000000000000000000000000000000000000000006230A372CBC1 >									
120 	//     < BANK_III_PFIII_metadata_line_8_____JPMORGAN_20260508 >									
121 	//        < Fp39247w9gl1N73S18ybRrC33K1ce2sJJKaQK0E8EfWbalcr15TjmL8K04fTwHTA >									
122 	//        <  u =="0.000000000000000001" : ] 000000076875649.076077400000000000 ; 000000088127672.256142800000000000 ] >									
123 	//        < 0x000000000000000000000000000000000000000000000000000072CBC182F810 >									
124 	//     < BANK_III_PFIII_metadata_line_9_____WACHOVIA_20260508 >									
125 	//        < eP6R25WUiAtN20EadndYi3C2KHZ2O7HRN00XbT778QIIJ2cFq9cjmh4mYLfV82lv >									
126 	//        <  u =="0.000000000000000001" : ] 000000088127672.256142800000000000 ; 000000099067180.805202900000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000000082F810931564 >									
128 	//     < BANK_III_PFIII_metadata_line_10_____CITIBANK_20260508 >									
129 	//        < S5u5VNDN526UB3lW962xn2By3o5A924P2dobz95g0O99a290R68x0KW6fhBVZk6d >									
130 	//        <  u =="0.000000000000000001" : ] 000000099067180.805202900000000000 ; 000000109985119.122206000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000000931564A37735 >									
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
174 	//     < BANK_III_PFIII_metadata_line_11_____WASHINGTON MUTUAL_20260508 >									
175 	//        < lze8e4s0WuHY58tUrB7G6sl7P7T9q2RsZwNeIzV4ot0cpaidnwY6wWZR4xl78ZNz >									
176 	//        <  u =="0.000000000000000001" : ] 000000109985119.122206000000000000 ; 000000121307214.546719000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000000A37735B42111 >									
178 	//     < BANK_III_PFIII_metadata_line_12_____SUN TRUST BANKS_20260508 >									
179 	//        < 24UXPIoeK0vDI06r51M16dd0LJrz1gg1TRco17z2929Mu2Ly0xbIsCkQGus9RsH9 >									
180 	//        <  u =="0.000000000000000001" : ] 000000121307214.546719000000000000 ; 000000132418287.613854000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000000B42111C4B87F >									
182 	//     < BANK_III_PFIII_metadata_line_13_____US BANCORP_20260508 >									
183 	//        < lt026c1AG6n020y761adL03i5jL8P645On4IBvy2Jbj59K56ofMmmD17xbaqk6nC >									
184 	//        <  u =="0.000000000000000001" : ] 000000132418287.613854000000000000 ; 000000143672041.095432000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000000C4B87FD52CC0 >									
186 	//     < BANK_III_PFIII_metadata_line_14_____REGIONS BANK_20260508 >									
187 	//        < 0bi1nEF91Ror3M3Y9JSW8ETOFZDF41Iw23CDpvaJZ4lgTJi8TOv60pwnHFlLf7eO >									
188 	//        <  u =="0.000000000000000001" : ] 000000143672041.095432000000000000 ; 000000154332378.640904000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000000D52CC0E5A08B >									
190 	//     < BANK_III_PFIII_metadata_line_15_____FEDERAL RESERVE BANK_20260508 >									
191 	//        < 04lN3xJ27Hzb3TpZ469kRAT26NH4a7G1YLo9iN10dalbSlUOlFfxs7LtoXQ9HbZx >									
192 	//        <  u =="0.000000000000000001" : ] 000000154332378.640904000000000000 ; 000000165392796.161006000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000000E5A08BF630B6 >									
194 	//     < BANK_III_PFIII_metadata_line_16_____BRANCH BANKING AND TRUST COMPANY_20260508 >									
195 	//        < IGXc9Id2LI3nIgDw8368S6mfF4H2yh4LWXQvEmawEwKRA0BWhoMgUjJCj85k1IoJ >									
196 	//        <  u =="0.000000000000000001" : ] 000000165392796.161006000000000000 ; 000000176258309.894472000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000000F630B61069785 >									
198 	//     < BANK_III_PFIII_metadata_line_17_____NATIONAL CITI BANK_20260508 >									
199 	//        < WBHIcGYdnql52e6ag4207EU3YBIPtQ0f95ONFsMCDbhV4YfSEL5Az2Pfcn7b8Z9M >									
200 	//        <  u =="0.000000000000000001" : ] 000000176258309.894472000000000000 ; 000000187381227.018648000000000000 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000000010697851171D5C >									
202 	//     < BANK_III_PFIII_metadata_line_18_____HSBC BANK USA_20260508 >									
203 	//        < hlag92hxELe55OZC0XgXlsuyjy3C68W6OPg0E1KQxRnv15Yu9o3Y8WUega942j9Q >									
204 	//        <  u =="0.000000000000000001" : ] 000000187381227.018648000000000000 ; 000000198226342.435245000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000001171D5C1276624 >									
206 	//     < BANK_III_PFIII_metadata_line_19_____WORLD SAVINGS BANKS_FSB_20260508 >									
207 	//        < o94jjRVxXMSWUSUp66v93V4OA7QZHF7TCxI9X7L2F8t50P7GkOfUUNvbS6hS5dj0 >									
208 	//        <  u =="0.000000000000000001" : ] 000000198226342.435245000000000000 ; 000000209140622.360158000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000001276624137A762 >									
210 	//     < BANK_III_PFIII_metadata_line_20_____COUNTRYWIDE BANK_20260508 >									
211 	//        < cv253Z69y1LD1NoMyEeS8KC3P9JZzsYV7ej06chh8Qt0Zr9AHT9ZGyvfystyO5II >									
212 	//        <  u =="0.000000000000000001" : ] 000000209140622.360158000000000000 ; 000000220080413.658264000000000000 ] >									
213 	//        < 0x00000000000000000000000000000000000000000000000000137A7621484A90 >									
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
256 	//     < BANK_III_PFIII_metadata_line_21_____PNC BANK_PITTSBURG_II_20260508 >									
257 	//        < 194pQs820jg11nxAW5ivxRwSeUT6egd9Iz25sIun4EHSNzep6ym4xfa7cXcZuJoM >									
258 	//        <  u =="0.000000000000000001" : ] 000000220080413.658264000000000000 ; 000000231187153.302760000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000001484A901589541 >									
260 	//     < BANK_III_PFIII_metadata_line_22_____KEYBANK_20260508 >									
261 	//        < 45VcV6Vrz2w1C1xk90g7r30D1xtZOWQn6mNmhCU6uet6459uQU0OLB0lt3O1Iks6 >									
262 	//        <  u =="0.000000000000000001" : ] 000000231187153.302760000000000000 ; 000000241845515.227048000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000001589541168DEF8 >									
264 	//     < BANK_III_PFIII_metadata_line_23_____ING BANK_FSB_20260508 >									
265 	//        < H919izxWj3gTyszE0pWP409lC7TJi92341gtLblKcWKzovch0Pwvpgi7t9BfyAp5 >									
266 	//        <  u =="0.000000000000000001" : ] 000000241845515.227048000000000000 ; 000000253000709.532030000000000000 ] >									
267 	//        < 0x00000000000000000000000000000000000000000000000000168DEF81796FE2 >									
268 	//     < BANK_III_PFIII_metadata_line_24_____MERRILL LYNCH BANK USA_20260508 >									
269 	//        < o8RJ9r84iIWH1e33HG3XzY5S26i20fz05Oxb4VQEz99l3GXUW9Kv556a9WTZxz4G >									
270 	//        <  u =="0.000000000000000001" : ] 000000253000709.532030000000000000 ; 000000263760290.312798000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000001796FE2189E9BF >									
272 	//     < BANK_III_PFIII_metadata_line_25_____SOVEREIGN BANK_20260508 >									
273 	//        < 8341dQo35fYEby9Pv9vXq8Eg5IAJGuHbW9QL5mlUdRNtr0904BmK807t144uCUl2 >									
274 	//        <  u =="0.000000000000000001" : ] 000000263760290.312798000000000000 ; 000000274833492.538875000000000000 ] >									
275 	//        < 0x00000000000000000000000000000000000000000000000000189E9BF19A16C0 >									
276 	//     < BANK_III_PFIII_metadata_line_26_____COMERICA BANK_20260508 >									
277 	//        < ukDuQlGYaS3QC0KULx0B9Xk4l73gn6gCSQKz1u2tfcQ7dv2SQpj0rA0e2X7f3wd0 >									
278 	//        <  u =="0.000000000000000001" : ] 000000274833492.538875000000000000 ; 000000285742145.813909000000000000 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000000000019A16C01AA44E0 >									
280 	//     < BANK_III_PFIII_metadata_line_27_____UNION BANK OF CALIFORNIA_20260508 >									
281 	//        < tR9kNb55ByVA60GG75F4H8gd949I4t268hfjzgrE8QwpN76D6Y86470665CDj6uH >									
282 	//        <  u =="0.000000000000000001" : ] 000000285742145.813909000000000000 ; 000000296593380.804750000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000001AA44E01BA907B >									
284 	//     < BANK_III_PFIII_metadata_line_28_____ING BANK_20260508 >									
285 	//        < Y68HrvU3yLfs3tKxnivh69kT48JSgjQo58FB8tR4C9IDjC2qyIT80161P786jTVI >									
286 	//        <  u =="0.000000000000000001" : ] 000000296593380.804750000000000000 ; 000000307455562.293656000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000001BA907B1CB0D5C >									
288 	//     < BANK_III_PFIII_metadata_line_29_____DEKA BANK_20260508 >									
289 	//        < rB132027Dn884e3E00N80961dEjhq71a5S50GbfkVZxzVUji2pWW9qOIV3Q87t84 >									
290 	//        <  u =="0.000000000000000001" : ] 000000307455562.293656000000000000 ; 000000318568850.508379000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000001CB0D5C1DB3618 >									
292 	//     < BANK_III_PFIII_metadata_line_30_____BNPPARIBAS_20260508 >									
293 	//        < QzNUXH5w6yMH4aOeSq9pK03qwqBTW22V1q0phGcU726DFY0klV97uF3S0h0tdaj0 >									
294 	//        <  u =="0.000000000000000001" : ] 000000318568850.508379000000000000 ; 000000329364837.660600000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000001DB36181EB8866 >									
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
338 	//     < BANK_III_PFIII_metadata_line_31_____SOCIETE GENERALE  _20260508 >									
339 	//        < nXK7QN0EHGwCeor8AAePAgdBN4jf1fXmt5v771MqZ3Z4L5CoNyLhm1YQU8C06j5D >									
340 	//        <  u =="0.000000000000000001" : ] 000000329364837.660600000000000000 ; 000000340625134.889432000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000001EB88661FBDAFC >									
342 	//     < BANK_III_PFIII_metadata_line_32_____CREDIT_AGRICOLE_SA_20260508 >									
343 	//        < 3iU0pHBMa56VD08288WIuiYCiw84l2zM2VKd4KI64hYh74NXrT8OO4Tds10d6VD9 >									
344 	//        <  u =="0.000000000000000001" : ] 000000340625134.889432000000000000 ; 000000351415110.622187000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000001FBDAFC20C1905 >									
346 	//     < BANK_III_PFIII_metadata_line_33_____CREDIT_MUTUEL_20260508 >									
347 	//        < 4T8Z8577gicb9vcF1RI8E1p9OM9GqzyGm1pOpbXZrCCad1fNvA60HfDrZ3EP75Q6 >									
348 	//        <  u =="0.000000000000000001" : ] 000000351415110.622187000000000000 ; 000000362647803.871323000000000000 ] >									
349 	//        < 0x0000000000000000000000000000000000000000000000000020C190521C6953 >									
350 	//     < BANK_III_PFIII_metadata_line_34_____DEXIA_20260508 >									
351 	//        < 8F7z9mTgM5lYYHZj9WC416f6aD83a95B5MEFD7zAhErTVRGzNaWfvbaw41lea0S7 >									
352 	//        <  u =="0.000000000000000001" : ] 000000362647803.871323000000000000 ; 000000373410232.898122000000000000 ] >									
353 	//        < 0x0000000000000000000000000000000000000000000000000021C695322CFE3E >									
354 	//     < BANK_III_PFIII_metadata_line_35_____CREDIT_INDUSTRIEL_COMMERCIAL_20260508 >									
355 	//        < Xf0Wm7cB16vQohVHEM14SPNV80tY8R19M4gRMlbXVt6PaiG8oVkM28r97nZ8Sx97 >									
356 	//        <  u =="0.000000000000000001" : ] 000000373410232.898122000000000000 ; 000000384308555.880306000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000022CFE3E23DA8C0 >									
358 	//     < BANK_III_PFIII_metadata_line_36_____SANTANDER_20260508 >									
359 	//        < l30I5WJZtEX5GzBT96TRjqi1uQe4pTxlcfSY1i6HVhliXy6lT3W0U20tj2lVH48j >									
360 	//        <  u =="0.000000000000000001" : ] 000000384308555.880306000000000000 ; 000000395359785.155537000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000023DA8C024DEC3C >									
362 	//     < BANK_III_PFIII_metadata_line_37_____CREDIT_LYONNAIS_20260508 >									
363 	//        < zRwKvHirQOnrL88Tt0g7Q2KL93VUF4M1VycxSWH7RgAjbqr12wH56hV8L9dTSv7M >									
364 	//        <  u =="0.000000000000000001" : ] 000000395359785.155537000000000000 ; 000000406642878.440244000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000024DEC3C25E7918 >									
366 	//     < BANK_III_PFIII_metadata_line_38_____BANQUES_POPULAIRES_20260508 >									
367 	//        < 5hOJzbJ293jp563j683e2WKrd61KbffulSCHY8k37179k52soLqJbM8343wm2Soj >									
368 	//        <  u =="0.000000000000000001" : ] 000000406642878.440244000000000000 ; 000000417436730.925981000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000025E791826E8F68 >									
370 	//     < BANK_III_PFIII_metadata_line_39_____CAISSES_D_EPARGNE_20260508 >									
371 	//        < 411Ai2kpMChk7MJ77o9jhpJaqM2308oXoQ5BUkx4OwfKSwF7Bc2pm7Fk20Ml7hpH >									
372 	//        <  u =="0.000000000000000001" : ] 000000417436730.925981000000000000 ; 000000428379573.136908000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000026E8F6827EC730 >									
374 	//     < BANK_III_PFIII_metadata_line_40_____LAZARD_20260508 >									
375 	//        < Vv6gZ82Ufiey7Bx0b4NqheoS12r6h60hZZ1t9Ixr67yp9yH89EE953wS4AT2X2nr >									
376 	//        <  u =="0.000000000000000001" : ] 000000428379573.136908000000000000 ; 000000439201543.085926000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000027EC73028F0A40 >									
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