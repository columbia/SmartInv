1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RE_Portfolio_XV_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RE_Portfolio_XV_883		"	;
8 		string	public		symbol =	"	RE883XV		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1350709237915270000000000000					;	
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
92 	//     < RE_Portfolio_XV_metadata_line_1_____Odyssey_Reinsurance_Company_Am_A_20250515 >									
93 	//        < 342MsJd9BY87Vs2VkTdNIBv6OgDHA3qhoF9xc9pQNvgH7lJz7HZ433Z72588Ukf8 >									
94 	//        < 1E-018 limites [ 1E-018 ; 46084375,177347 ] >									
95 	//        < 0x0000000000000000000000000000000000000000000000000000000112AF2F01 >									
96 	//     < RE_Portfolio_XV_metadata_line_2_____OJSC_INSURANCE_COMPANY_OF_GAZ_INDUSTRY_SOGAZ_Bpp_20250515 >									
97 	//        < TuNFST6Jrjb57jy7Y41dDpZ3BGKfH884NDx6pe90xd4GV7Q96YlOJb5s0Ttm362P >									
98 	//        < 1E-018 limites [ 46084375,177347 ; 95545612,671014 ] >									
99 	//        < 0x0000000000000000000000000000000000000000000000112AF2F012397F0AE7 >									
100 	//     < RE_Portfolio_XV_metadata_line_3_____Oman_A_Oman_Reinsurance_Co_m_m_20250515 >									
101 	//        < bZX9vp15O5S6uyH1096WoTb9CRxe3OHbDVUDnq8FYv4EE98c2QHR11Ldk6B044FZ >									
102 	//        < 1E-018 limites [ 95545612,671014 ; 108173857,245528 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000002397F0AE7284C436F0 >									
104 	//     < RE_Portfolio_XV_metadata_line_4_____Oman_Insurance_Company_PSC_Am_A_20250515 >									
105 	//        < o8mB5h5vH12Ke8zsBN3QpRSDaFw69N2FAMo5aA1jDk5shJCb2Hu9u97lNFRyRSVO >									
106 	//        < 1E-018 limites [ 108173857,245528 ; 127454227,24716 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000284C436F02F7AFB978 >									
108 	//     < RE_Portfolio_XV_metadata_line_5_____Omnium_Reinsurance_Co_20250515 >									
109 	//        < kfVIfGplBzrZ3F02jTSxtu8FIDGHz7Oid37d7En2h3R0KxHRyRUxvXM5XzR1Rydg >									
110 	//        < 1E-018 limites [ 127454227,24716 ; 175503708,90955 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000002F7AFB978416156A3E >									
112 	//     < RE_Portfolio_XV_metadata_line_6_____Omnium_Reinsurance_Co_SA_Ap_20250515 >									
113 	//        < MUXSQAWjvCCg2DUY1cXIRbHmi353ecqnJ8fC95Zwj3jG29N3r48n2E9S13VMCp47 >									
114 	//        < 1E-018 limites [ 175503708,90955 ; 235362949,111934 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000416156A3E57ADF5DF3 >									
116 	//     < RE_Portfolio_XV_metadata_line_7_____Optimum_Reinsurance_Company_20250515 >									
117 	//        < 4bL39WZDm9u7zcNl3a35fKV6Hobptp1tiRgQA3P33cT9yIqNPekGXl7RWAYA3eMN >									
118 	//        < 1E-018 limites [ 235362949,111934 ; 252608961,057728 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000057ADF5DF35E1AAB15D >									
120 	//     < RE_Portfolio_XV_metadata_line_8_____Orient_Insurance_PJSC_A_A_20250515 >									
121 	//        < 5hgI2IdEnbtgICY49u32be2YQ07hcBd55ox2NCon5Xtzx4r28aB84vWMAp497nuE >									
122 	//        < 1E-018 limites [ 252608961,057728 ; 300168226,004988 ] >									
123 	//        < 0x00000000000000000000000000000000000000000000005E1AAB15D6FD245F3C >									
124 	//     < RE_Portfolio_XV_metadata_line_9_____Oriental_Insurance_and_Reinsurance_20250515 >									
125 	//        < uCW0s3KSR8Bn8pz282x7zu3bObQm210C8iw6ha4RT0mI1iOsF5hXW51n3G4rWvpU >									
126 	//        < 1E-018 limites [ 300168226,004988 ; 329544840,823364 ] >									
127 	//        < 0x00000000000000000000000000000000000000000000006FD245F3C7AC3D8766 >									
128 	//     < RE_Portfolio_XV_metadata_line_10_____Overseas_Partners_Limited_20250515 >									
129 	//        < m36vLM3kBCegv6yM9T3eBDXWOo2GsZs062oeXN09ZBQSHR954T2U1j5pPb2hRN77 >									
130 	//        < 1E-018 limites [ 329544840,823364 ; 358379439,38619 ] >									
131 	//        < 0x00000000000000000000000000000000000000000000007AC3D87668581BA276 >									
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
174 	//     < RE_Portfolio_XV_metadata_line_11_____Pacific_LifeCorp_20250515 >									
175 	//        < WjgwSZIo8l3H73FETr1sFnqg8p2II28D72T0v3dAe0Qj80R4b35ELeoJv5z80pm3 >									
176 	//        < 1E-018 limites [ 358379439,38619 ; 384780653,396014 ] >									
177 	//        < 0x00000000000000000000000000000000000000000000008581BA2768F578B0AF >									
178 	//     < RE_Portfolio_XV_metadata_line_12_____PACRE_AB_20250515 >									
179 	//        < 50reG8eQGIPfbKUeUYJR8g3o228Kqa049dADf5Z4lp3883E2bkz8s15H09e80zf5 >									
180 	//        < 1E-018 limites [ 384780653,396014 ; 406647887,37271 ] >									
181 	//        < 0x00000000000000000000000000000000000000000000008F578B0AF977CF70F5 >									
182 	//     < RE_Portfolio_XV_metadata_line_13_____Panama_BBB_Barents_Reinsurance_Am_20250515 >									
183 	//        < zPg99slKuA8E75JfUS2v53b4FFKaXr5OCTnvSEMa098F53JJJ2TpGjFuE05V5Y3j >									
184 	//        < 1E-018 limites [ 406647887,37271 ; 446419362,72082 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000977CF70F5A64DDE584 >									
186 	//     < RE_Portfolio_XV_metadata_line_14_____Paris_Re_20250515 >									
187 	//        < cD4Du5BKZgJUDEiqccxK1p5W08LluAm9Mr8qNLakSXDXJyq0Wvph1j1NMhU6Dzkj >									
188 	//        < 1E-018 limites [ 446419362,72082 ; 457005135,789622 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000A64DDE584AA3F6811E >									
190 	//     < RE_Portfolio_XV_metadata_line_15_____Paris_Re_20250515 >									
191 	//        < Y8V07i4Iu435W56SJD6B2Z4KkUKXiTo24hHh6bBXS7W7Q7O9K5bqc9C1Oyol1d7p >									
192 	//        < 1E-018 limites [ 457005135,789622 ; 523885012,11154 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000AA3F6811EC329918CF >									
194 	//     < RE_Portfolio_XV_metadata_line_16_____Partner_Re_Limited_20250515 >									
195 	//        < Pc75yI7j8AwxBUn8z09S572n49CLB0uPWvM6qZZZDN6RWVI4GN5WjRjr82n6N5H3 >									
196 	//        < 1E-018 limites [ 523885012,11154 ; 537324242,912967 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000C329918CFC82B3BC57 >									
198 	//     < RE_Portfolio_XV_metadata_line_17_____Partner_Re_Limited_20250515 >									
199 	//        < 7m6n01H7nvrwlUX61vbdgkr33f55KWIqhHwN130061uugZp96x1v7gp3hnMpFNN0 >									
200 	//        < 1E-018 limites [ 537324242,912967 ; 551023930,400859 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000C82B3BC57CD45BCCC4 >									
202 	//     < RE_Portfolio_XV_metadata_line_18_____Partner_Re_Services_20250515 >									
203 	//        < fg68H6k53JdpmNx704YE4JJ14NvJw73x5f36vb031419jhihMQ4u5i5hG16RygI1 >									
204 	//        < 1E-018 limites [ 551023930,400859 ; 565728715,753078 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000CD45BCCC4D2C01858B >									
206 	//     < RE_Portfolio_XV_metadata_line_19_____Partner_Reinsurance_Co_Limited_Ap_A_20250515 >									
207 	//        < 1mwN0kCgXu6lHBUe7EBj8hVJixltcJgZ0RGhql6p9J063uvIJ0A45u8V6e6dSqNQ >									
208 	//        < 1E-018 limites [ 565728715,753078 ; 590266733,615009 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000D2C01858BDBE4390C5 >									
210 	//     < RE_Portfolio_XV_metadata_line_20_____partner_reinsurance_company_Limited_Ap_20250515 >									
211 	//        < Qh1mVDUeySdV7Qe60stA5TDRU40lbO5Q7b8547794gpjmXLu09xeuCXC566sUOP2 >									
212 	//        < 1E-018 limites [ 590266733,615009 ; 606495147,827913 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000DBE4390C5E1EFE2912 >									
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
256 	//     < RE_Portfolio_XV_metadata_line_21_____PartnerRe_Limited_20250515 >									
257 	//        < oseiT5kQ6dq3R7HS379Bm771koQ7c0aM1Anm67y6QZ33957ftDrVWOxA2O1C5dIP >									
258 	//        < 1E-018 limites [ 606495147,827913 ; 621285303,715882 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000E1EFE2912E772625B7 >									
260 	//     < RE_Portfolio_XV_metadata_line_22_____Peak_Reinsurance_Company_20250515 >									
261 	//        < zm4ok5G2VUB435bd5k0BP7KP0Oi75UY9V3oooQ5HD0J7C5F6885b641YN6o87x0B >									
262 	//        < 1E-018 limites [ 621285303,715882 ; 697308544,052076 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000E772625B7103C4867F9 >									
264 	//     < RE_Portfolio_XV_metadata_line_23_____Peak_Reinsurance_Company_Limited__Peak_Re__Am_20250515 >									
265 	//        < g3wSkrIWRnWc6099VG173I52i7gk59zlQ04ebusYeScTXhHMRUh5fp9X3D1zIWew >									
266 	//        < 1E-018 limites [ 697308544,052076 ; 732529226,758741 ] >									
267 	//        < 0x00000000000000000000000000000000000000000000103C4867F9110E36E727 >									
268 	//     < RE_Portfolio_XV_metadata_line_24_____Pembroke_Managing_Agency_Limited_20250515 >									
269 	//        < bwH70O2B2MXZpch1WR34PeN0fHBH0Ea8AkNs6gcF8ZyAn1D6lu14YlH4ygyd77Yx >									
270 	//        < 1E-018 limites [ 732529226,758741 ; 811292196,732394 ] >									
271 	//        < 0x00000000000000000000000000000000000000000000110E36E72712E3ADA84D >									
272 	//     < RE_Portfolio_XV_metadata_line_25_____Pembroke_Managing_Agency_Limited_20250515 >									
273 	//        < GsyvsW26a1Y6t3YLyAqd32PZnsawddNjjDSx5ga5cN2M3OJM3c3TBo0O9OXcMSTg >									
274 	//        < 1E-018 limites [ 811292196,732394 ; 886236796,761977 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000012E3ADA84D14A2620AB0 >									
276 	//     < RE_Portfolio_XV_metadata_line_26_____Pembroke_Managing_Agency_Limited_20250515 >									
277 	//        < UF1d4807S9eVJNI8AiEUxnNnfbrz6pR2R37I1cnLmdZn7w7wuPAYuvoZh39N37e1 >									
278 	//        < 1E-018 limites [ 886236796,761977 ; 904319281,796364 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000014A2620AB0150E29B967 >									
280 	//     < RE_Portfolio_XV_metadata_line_27_____Pembroke_Managing_Agency_Limited_20250515 >									
281 	//        < XV9bL5W6w96O4rp3zdORR4UC3sR0nQ9P4iTw2aih0Ke906BJLWiUyXaCXzTpl7w4 >									
282 	//        < 1E-018 limites [ 904319281,796364 ; 980830244,554802 ] >									
283 	//        < 0x00000000000000000000000000000000000000000000150E29B96716D634303B >									
284 	//     < RE_Portfolio_XV_metadata_line_28_____Pembroke_Managing_Agency_Limited_20250515 >									
285 	//        < JB85i74Buf8s36I29Qu8R97Yim6D14vY299g54DCQ1t6RUv5414g98F66Of9z8HK >									
286 	//        < 1E-018 limites [ 980830244,554802 ; 1026640384,27562 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000016D634303B17E740EA0F >									
288 	//     < RE_Portfolio_XV_metadata_line_29_____Pembroke_Managing_Agency_Limited_20250515 >									
289 	//        < H71V5A4quEp2790kPxoLYpM78I5Jwf3vzI375m0M7g66DCDGJMnDt9bdf8g2HxAB >									
290 	//        < 1E-018 limites [ 1026640384,27562 ; 1078613883,31291 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000017E740EA0F191D0A2E1F >									
292 	//     < RE_Portfolio_XV_metadata_line_30_____Pembroke_Managing_Agency_Limited_20250515 >									
293 	//        < EYnR7oGr76Sl9FZ7o4e4yqUKQ61C60H24r4BfbMJ5gsVYQIVu05wyi0C0260JW7X >									
294 	//        < 1E-018 limites [ 1078613883,31291 ; 1132591625,57541 ] >									
295 	//        < 0x00000000000000000000000000000000000000000000191D0A2E1F1A5EC5ADB1 >									
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
338 	//     < RE_Portfolio_XV_metadata_line_31_____Pembroke_Managing_Agency_Limited_20250515 >									
339 	//        < H7rL8jdXqzJB2psuZOQ6RUg71Kt2351VkL0IF7z4l08PmK4RRBYrS6St22gc0Pzu >									
340 	//        < 1E-018 limites [ 1132591625,57541 ; 1189242854,37023 ] >									
341 	//        < 0x000000000000000000000000000000000000000000001A5EC5ADB11BB07097F1 >									
342 	//     < RE_Portfolio_XV_metadata_line_32_____Pembroke_Managing_Agency_Limited_20250515 >									
343 	//        < 17jKWfdEU4j1Qc74Wwm3ijXKQL908fXTL8L500JFD3Hoe57rhBkIOxFEEz4SPUqS >									
344 	//        < 1E-018 limites [ 1189242854,37023 ; 1201920241,16011 ] >									
345 	//        < 0x000000000000000000000000000000000000000000001BB07097F11BFC00C028 >									
346 	//     < RE_Portfolio_XV_metadata_line_33_____Pembroke_Managing_Agency_Limited            _20250515 >									
347 	//        < k5h37rYWg5A6M00DjZe94c98Uo5pWOtpfy5XPzhs6Xh9c5l9TgNTCZGj7hI65dt8 >									
348 	//        < 1E-018 limites [ 1201920241,16011 ; 1213323527,15815 ] >									
349 	//        < 0x000000000000000000000000000000000000000000001BFC00C0281C3FF8C8BF >									
350 	//     < RE_Portfolio_XV_metadata_line_34_____Ping_An_Property_&_Casualty_Insurance_Co_of_China_Limited_Am_20250515 >									
351 	//        < ZmrE5z9vfn1m3PK70u09PjnDLFm4Y37VabpFzvOWwrgpb227ao1WNiFPLH1X42na >									
352 	//        < 1E-018 limites [ 1213323527,15815 ; 1232791090,83204 ] >									
353 	//        < 0x000000000000000000000000000000000000000000001C3FF8C8BF1CB401EDCF >									
354 	//     < RE_Portfolio_XV_metadata_line_35_____Platinum_Underwriters_Holdings_Limited_20250515 >									
355 	//        < g2Wf84zg3G31fVIE86I1FbpXOSi4k37r4rZq3Izt8y1t2g92ghWO3E9356W09Vg8 >									
356 	//        < 1E-018 limites [ 1232791090,83204 ; 1244652056,32338 ] >									
357 	//        < 0x000000000000000000000000000000000000000000001CB401EDCF1CFAB45374 >									
358 	//     < RE_Portfolio_XV_metadata_line_36_____Platinum_Underwriters_Holdings_Limited_20250515 >									
359 	//        < 4011Wy1U85vSZ7lmnTnpFh2Kof7E84GDf161zaOn8SG8t971vIUJUX3MS4zE17M8 >									
360 	//        < 1E-018 limites [ 1244652056,32338 ;  ] >									
361 	//        < 0x000000000000000000000000000000000000000000001CFAB453741D48DB4F49 >									
362 	//     < RE_Portfolio_XV_metadata_line_37_____Platinum_Underwriters_Holdings_Limited_20250515 >									
363 	//        < Ir4UoPbEziw4aiQWH7ojKyDGKlpQsxq2GNE4pbLLt6cbeI07ZuVi2V9gbwoz8ycy >									
364 	//        < 1E-018 limites [ 1257763833,17499 ; 1298796065,51769 ] >									
365 	//        < 0x000000000000000000000000000000000000000000001D48DB4F491E3D6D870B >									
366 	//     < RE_Portfolio_XV_metadata_line_38_____PMA_Re_Management_Company_20250515 >									
367 	//        < 6l29nMNmCCZxv4sY87WczaxVqW696wO0gnPEejb07EYobQyedY8EsbhU5E3tS54y >									
368 	//        < 1E-018 limites [ 1298796065,51769 ; 1313347030,1582 ] >									
369 	//        < 0x000000000000000000000000000000000000000000001E3D6D870B1E9428899B >									
370 	//     < RE_Portfolio_XV_metadata_line_39_____Pozavarovalnica_Sava,_dd__Sava_Re__Am_Am_20250515 >									
371 	//        < OD6II9X00HsmRBBo7R8F4gwBWsZ5uFJfZ3A535L3j3592CmtCCG1O0JhiCOmL3gz >									
372 	//        < 1E-018 limites [ 1313347030,1582 ; 1324231558,33625 ] >									
373 	//        < 0x000000000000000000000000000000000000000000001E9428899B1ED509026D >									
374 	//     < RE_Portfolio_XV_metadata_line_40_____ProSight_Specialty_Managing_Agency_Limited_20250515 >									
375 	//        < O6QFc5aMhH4fA5hCg6BBcx521NEKsuy1dd7wF66A1XRSR3XpDM1TW4I4vz61R8en >									
376 	//        < 1E-018 limites [ 1324231558,33625 ; 1350709237,91527 ] >									
377 	//        < 0x000000000000000000000000000000000000000000001ED509026D1F72DABE03 >									
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