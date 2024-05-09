1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RE_Portfolio_II_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RE_Portfolio_II_883		"	;
8 		string	public		symbol =	"	RE883II		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1546798683705000000000000000					;	
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
92 	//     < RE_Portfolio_II_metadata_line_1_____Allianz_SE_20250515 >									
93 	//        < aD6659uLmi5A3u43fpHdW3jo6Md642TsTt4rbMDO56c03aI1zCRtFrWlr3b70RVW >									
94 	//        < 1E-018 limites [ 1E-018 ; 78550116,981511 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000001D431F966 >									
96 	//     < RE_Portfolio_II_metadata_line_2_____Allianz_SE_AA_Ap_20250515 >									
97 	//        < 3t3sYFCF153lY8Jj1yjgwmV80Ib4e9SX8dp277Fji7m7Iua73dNzFH4ERqF29fIo >									
98 	//        < 1E-018 limites [ 78550116,981511 ; 93956046,2773862 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000001D431F966230058E87 >									
100 	//     < RE_Portfolio_II_metadata_line_3_____Allianz_Suisse_Versich_AAm_m_20250515 >									
101 	//        < M4R45Sq8qxZq0o98MYjbzQXi9x4ma2VkxwO5T4Ss8lqd9LgPxcqCbsd7Gys4bdn7 >									
102 	//        < 1E-018 limites [ 93956046,2773862 ; 157595717,514915 ] >									
103 	//        < 0x0000000000000000000000000000000000000000000000230058E873AB57FD1B >									
104 	//     < RE_Portfolio_II_metadata_line_4_____Allied_World_Assurance_Co_A_20250515 >									
105 	//        < zXFdwOHE246ISr988J3160nrD5d85Cm8wI80XrRqNZgIF4QVc6Vp2S5T79msP3Iz >									
106 	//        < 1E-018 limites [ 157595717,514915 ; 175387761,620715 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000003AB57FD1B415647E56 >									
108 	//     < RE_Portfolio_II_metadata_line_5_____Allied_World_Assurance_Company_Holdings_AG_20250515 >									
109 	//        < bSF21r77gJ82H2IL2s6l21sI7AC1S8T6e2wg776L3TX1b7x860y8dFnrR264juGr >									
110 	//        < 1E-018 limites [ 175387761,620715 ; 215213125,864114 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000415647E56502C52D3E >									
112 	//     < RE_Portfolio_II_metadata_line_6_____Allied_World_Managing_Agency_Limited_20250515 >									
113 	//        < 8f9BBUe1Eq4ixzn04q6Q8MarKfz4Sl9fA22fFQ5O6AL3V0cvW5ukdEf6rpKeW9pL >									
114 	//        < 1E-018 limites [ 215213125,864114 ; 226148928,258301 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000502C52D3E543F3E30D >									
116 	//     < RE_Portfolio_II_metadata_line_7_____Allied_World_Managing_Agency_Limited_20250515 >									
117 	//        < dG64xI6G4e93eF7SaHMN1eib5eq6w97UgLToPRMzUsl04ekLfQ0A5USWOD9N7G1t >									
118 	//        < 1E-018 limites [ 226148928,258301 ; 301360847,798055 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000543F3E30D704402B1F >									
120 	//     < RE_Portfolio_II_metadata_line_8_____AlmAhleia_Insurance_Co_SAK_Am_A3_20250515 >									
121 	//        < S6hiyVDEP7qY8VhPE8Xu6gqmqsIo9UI71f36YZg9UCTbwH25dVcgM0V5iNpE27L0 >									
122 	//        < 1E-018 limites [ 301360847,798055 ; 329870172,394454 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000704402B1F7AE2DF20B >									
124 	//     < RE_Portfolio_II_metadata_line_9_____Alterra_Capital_Holdings_Limited_20250515 >									
125 	//        < eYkpq8985X5Dmf78T7D4wy73KQ5tOsDZgw9Drgkty4j5ovqT6sfr8yoafo44uece >									
126 	//        < 1E-018 limites [ 329870172,394454 ; 409321953,097704 ] >									
127 	//        < 0x00000000000000000000000000000000000000000000007AE2DF20B987BFBDE1 >									
128 	//     < RE_Portfolio_II_metadata_line_10_____American_Agricultural_insurance_CO_m_Am_20250515 >									
129 	//        < STWYsk8TCAi88T5c0Phq39IZ1C99L5D0m5HaO4LbPf1e31agive1JE1OIVQ0AZG8 >									
130 	//        < 1E-018 limites [ 409321953,097704 ; 430334973,954591 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000987BFBDE1A04FF1127 >									
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
174 	//     < RE_Portfolio_II_metadata_line_11_____American_Agricultural_Insurance_Company_20250515 >									
175 	//        < 7Ld4asiGt25K5JURa1tPGRUM60tWhOJ61tBV401bAPTw7SbXy39B90eTkN20psS3 >									
176 	//        < 1E-018 limites [ 430334973,954591 ; 476302664,431914 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000A04FF1127B16FC323F >									
178 	//     < RE_Portfolio_II_metadata_line_12_____American_Home_Assurance_CO_Ap_A_20250515 >									
179 	//        < AieC7cnSzO4VAL0HQeV7XGfCQdF7mh081VT4w1q00wa014K78Z9B9B3ZWo69NQXG >									
180 	//        < 1E-018 limites [ 476302664,431914 ; 487031305,818764 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000B16FC323FB56EECDC9 >									
182 	//     < RE_Portfolio_II_metadata_line_13_____American_International_Group__Chartis__Am_BBB_20250515 >									
183 	//        < 4Y09lwNUnh1I1vM199OLr52hW0xPKNpq6GYUb1csvV1Q3pjJohHt9NVwW8r5G452 >									
184 	//        < 1E-018 limites [ 487031305,818764 ; 511039276,250391 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000B56EECDC9BE6080F3D >									
186 	//     < RE_Portfolio_II_metadata_line_14_____American_Life_InsurancemDelaware_AAm_20250515 >									
187 	//        < s8Y3JGlD1zFPmyD7J29IApZC5Px6d8emgdqBQLc7SLGRMBUu61xkVoGW9UjqLUa7 >									
188 	//        < 1E-018 limites [ 511039276,250391 ; 539816850,735835 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000BE6080F3DC918F2745 >									
190 	//     < RE_Portfolio_II_metadata_line_15_____American_Re_20250515 >									
191 	//        < vp5FO57Sm9OdrzZqKbNL1lp1v4H7LP34JL4zX852YfkH0K7Ss3Vug7G0WN8cKsT6 >									
192 	//        < 1E-018 limites [ 539816850,735835 ; 554809069,609304 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000C918F2745CEAEB76C4 >									
194 	//     < RE_Portfolio_II_metadata_line_16_____American_Re_20250515 >									
195 	//        < zAr3f7226e8VWqHT0rM0Ab0YBqQJlo986TN10IGrIqhA4lM67W9PbgynQ9zlKv5b >									
196 	//        < 1E-018 limites [ 554809069,609304 ; 604153363,238962 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000CEAEB76C4E1108E177 >									
198 	//     < RE_Portfolio_II_metadata_line_17_____Amlin_AG_A_m_20250515 >									
199 	//        < 9cz8d8VF27PLPb7rF52r2PBmT3iyI6SY47FHqQMdZsd8O90uG4t3OI4K9Ne4dgl8 >									
200 	//        < 1E-018 limites [ 604153363,238962 ; 616365063,076824 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000E1108E177E59D274B7 >									
202 	//     < RE_Portfolio_II_metadata_line_18_____Amlin_Underwriting_Limited_20250515 >									
203 	//        < YB5jC0gD9Bd7gLq1JJhEwX64x9beqLN84zf7RZ6Xj1TRL3qipg3g1uDTok0Jk94y >									
204 	//        < 1E-018 limites [ 616365063,076824 ; 694824910,429081 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000E59D274B7102D7AAE96 >									
206 	//     < RE_Portfolio_II_metadata_line_19_____Amlin_Underwriting_Limited_20250515 >									
207 	//        < dK7jv4pXHQX3YUj36xVJ37giQv0MTMnvMAw2J8VAF8I625mMn94714cS8I27B99e >									
208 	//        < 1E-018 limites [ 694824910,429081 ; 729038041,376321 ] >									
209 	//        < 0x00000000000000000000000000000000000000000000102D7AAE9610F967C6DD >									
210 	//     < RE_Portfolio_II_metadata_line_20_____AmTrust_at_Lloyd_s_Limited_20250515 >									
211 	//        < kqNe40Gywy3hKBuuMh5PISVf9jeNY3GIgp569JvlS9fVVKUL7YJ6H5Il3KhpURex >									
212 	//        < 1E-018 limites [ 729038041,376321 ; 746233257,528246 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000010F967C6DD115FE5982C >									
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
256 	//     < RE_Portfolio_II_metadata_line_21_____AmTrust_at_Lloyd_s_Limited_20250515 >									
257 	//        < AI2lvL0o44Z62Ub7aD7dNZ22s9s6LD08h0M93GPrC5bOQsc3jXdHTsD8Y34uToPN >									
258 	//        < 1E-018 limites [ 746233257,528246 ; 768580992,981868 ] >									
259 	//        < 0x00000000000000000000000000000000000000000000115FE5982C11E5198856 >									
260 	//     < RE_Portfolio_II_metadata_line_22_____AmTrust_at_Lloyd_s_Limited_20250515 >									
261 	//        < 8ioQp28s9WRwx6TmT21qzu9x2MYi7LR26na031Tjgwt90cyTG4OFjR6Ow4aPIACv >									
262 	//        < 1E-018 limites [ 768580992,981868 ; 806646950,959609 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000011E519885612C7FD932B >									
264 	//     < RE_Portfolio_II_metadata_line_23_____AmTrust_Syndicates_Limited_20250515 >									
265 	//        < 6i89KU5mXejg0jj4GW9k84ZS5N1Rx5H8t40uJLUZ40D0rt9sWzzC0BUL0ukP2j4e >									
266 	//        < 1E-018 limites [ 806646950,959609 ; 837377152,317488 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000012C7FD932B137F282413 >									
268 	//     < RE_Portfolio_II_metadata_line_24_____AmTrust_Syndicates_Limited_20250515 >									
269 	//        < 2O1z6Jq919ge54SWslke0jG6lgzHcQoj0i00gd3HZ6ld6Lb8lC51gMjm7yawqF04 >									
270 	//        < 1E-018 limites [ 837377152,317488 ; 912708164,125266 ] >									
271 	//        < 0x00000000000000000000000000000000000000000000137F28241315402A2490 >									
272 	//     < RE_Portfolio_II_metadata_line_25_____AmTrust_Syndicates_Limited_20250515 >									
273 	//        < oTB287DUgl7k2TJ6r2I4ADnoXBgN3046OD2c67MnJJz2APj3Crq75r6I93YN8b7F >									
274 	//        < 1E-018 limites [ 912708164,125266 ; 936043661,281416 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000015402A249015CB414924 >									
276 	//     < RE_Portfolio_II_metadata_line_26_____AmTrust_Syndicates_Limited_20250515 >									
277 	//        < jfrvR6K3F3vk4mCx003JvtU1P0pzfCf8T8hBb7sFh8047A116zCo5y5NCgg2Xdl3 >									
278 	//        < 1E-018 limites [ 936043661,281416 ; 987754411,910278 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000015CB41492416FF79A11B >									
280 	//     < RE_Portfolio_II_metadata_line_27_____AmTrust_Syndicates_Limited_20250515 >									
281 	//        < 910316ef5Q9d69t30iChKQY3O31o0k2cAcfe17i498gPxfGanG0n4TkWsmg95y1n >									
282 	//        < 1E-018 limites [ 987754411,910278 ; 1041530938,58336 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000016FF79A11B18400218D6 >									
284 	//     < RE_Portfolio_II_metadata_line_28_____AmTrust_Syndicates_Limited_20250515 >									
285 	//        < 6PZH4i0bWX4DmS73uYXOXB5c5e5IW636394Ti6rEMc7i7V9xn8SbzHln4iLGC1vH >									
286 	//        < 1E-018 limites [ 1041530938,58336 ; 1119585564,13246 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000018400218D61A114000F1 >									
288 	//     < RE_Portfolio_II_metadata_line_29_____AmTrust_Syndicates_Limited_20250515 >									
289 	//        < 63843qJO3afqH69Su8oX38TVTvV9IquXMnF8VPP31i3jByrPz3vvt5vOUFP8XofK >									
290 	//        < 1E-018 limites [ 1119585564,13246 ; 1139150556,08023 ] >									
291 	//        < 0x000000000000000000000000000000000000000000001A114000F11A85DDCFEC >									
292 	//     < RE_Portfolio_II_metadata_line_30_____AmTrust_Syndicates_Limited_20250515 >									
293 	//        < vKV34Zi6lN0TEjT7vCWPs7NsedOj0W2Sf7uyhHSOpnh3WDVm6SHXtfM9rcjtA0T0 >									
294 	//        < 1E-018 limites [ 1139150556,08023 ; 1199582495,60836 ] >									
295 	//        < 0x000000000000000000000000000000000000000000001A85DDCFEC1BEE11A24C >									
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
338 	//     < RE_Portfolio_II_metadata_line_31_____AmTrust_Syndicates_Limited_20250515 >									
339 	//        < 8Jix206EZ1N8Ji8qphX49V9vI7pDAf0q8ia5vQR1cL6G9f5S28AV2092vdfymtwc >									
340 	//        < 1E-018 limites [ 1199582495,60836 ; 1231768407,83365 ] >									
341 	//        < 0x000000000000000000000000000000000000000000001BEE11A24C1CADE97043 >									
342 	//     < RE_Portfolio_II_metadata_line_32_____AmTrust_Syndicates_Limited_20250515 >									
343 	//        < 1P789e2Gr3Sawjun2VcK6ZDVwx88slnnd2YcKMy6wfZ30wMwViPnkRnYBQ8E1Su0 >									
344 	//        < 1E-018 limites [ 1231768407,83365 ; 1258806268,71458 ] >									
345 	//        < 0x000000000000000000000000000000000000000000001CADE970431D4F11F0AB >									
346 	//     < RE_Portfolio_II_metadata_line_33_____Anadolu_Sigorta_20250515 >									
347 	//        < SrS1GHiwpz61DrSvWPTwrqc5arMO1wyZ0612ujjf6WCL3Wz25kx49TCY21DM6kXa >									
348 	//        < 1E-018 limites [ 1258806268,71458 ; 1283223875,69213 ] >									
349 	//        < 0x000000000000000000000000000000000000000000001D4F11F0AB1DE09C4065 >									
350 	//     < RE_Portfolio_II_metadata_line_34_____Annuity_and_Life_Re_20250515 >									
351 	//        < SIQj8xXKlbjnQJ4UWx27gRQ50Jpd19Kw5nOl8AC0qveG5R202D4K3BYAt234JNr1 >									
352 	//        < 1E-018 limites [ 1283223875,69213 ; 1313911165,01785 ] >									
353 	//        < 0x000000000000000000000000000000000000000000001DE09C40651E978556C9 >									
354 	//     < RE_Portfolio_II_metadata_line_35_____Annuity_and_Life_Re_20250515 >									
355 	//        < y12Igvd1Pg42DjsYd9pYEN53RrmtvbR67euxE621jVb1Uv0mD3OunwV9N0AZGkb9 >									
356 	//        < 1E-018 limites [ 1313911165,01785 ; 1337384016,3828 ] >									
357 	//        < 0x000000000000000000000000000000000000000000001E978556C91F236E115A >									
358 	//     < RE_Portfolio_II_metadata_line_36_____Antares_Managing_Agency_Limited_20250515 >									
359 	//        < Ej1GF562TWmSmvlH33023bcNPtJSo4U351uGXnu5DZyMb3vmg4rC01sr35i69qHy >									
360 	//        < 1E-018 limites [ 1337384016,3828 ;  ] >									
361 	//        < 0x000000000000000000000000000000000000000000001F236E115A21044BE921 >									
362 	//     < RE_Portfolio_II_metadata_line_37_____Antares_Managing_Agency_Limited_20250515 >									
363 	//        < SN01g365LHxIE6FZW6i8M0Qj6aICkAD9XmC2lnywo9cE4020exikAxozmGRS4gVS >									
364 	//        < 1E-018 limites [ 1418060040,13825 ; 1438045892,93654 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000021044BE921217B6BE6E1 >									
366 	//     < RE_Portfolio_II_metadata_line_38_____ANV_Syndicate_Management_Limited_20250515 >									
367 	//        < 40stng5KZW5ytKymrA6awYS7F2qLFCRfZhLJnEG1H25968Xt431ZV2tv3NX0uQkz >									
368 	//        < 1E-018 limites [ 1438045892,93654 ; 1486639903,4223 ] >									
369 	//        < 0x00000000000000000000000000000000000000000000217B6BE6E1229D107A3A >									
370 	//     < RE_Portfolio_II_metadata_line_39_____ANV_Syndicate_Management_Limited_20250515 >									
371 	//        < Wh791C3b8at1Hq9q3IQwF5FOyV9GIs5G6GNYeeV1Xvz8pyMMxr16N51Ta7RZ8W2T >									
372 	//        < 1E-018 limites [ 1486639903,4223 ; 1531557907,00135 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000229D107A3A23A8CBE960 >									
374 	//     < RE_Portfolio_II_metadata_line_40_____ANV_Syndicates_Limited_20250515 >									
375 	//        < 2ZPnzM8g0JK5xeabBzerVPFV8Eyp583qErdPd6l65x7zL1r070Da8D5rhdLks39C >									
376 	//        < 1E-018 limites [ 1531557907,00135 ; 1546798683,705 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000023A8CBE9602403A37DC6 >									
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