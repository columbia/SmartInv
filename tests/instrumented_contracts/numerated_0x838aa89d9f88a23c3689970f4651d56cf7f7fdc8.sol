1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RE_Portfolio_XII_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RE_Portfolio_XII_883		"	;
8 		string	public		symbol =	"	RE883XII		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1344165245303120000000000000					;	
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
92 	//     < RE_Portfolio_XII_metadata_line_1_____Holland_AAp_Nationale_Borg_Reinsurance_NV_Am_20250515 >									
93 	//        < nv4yc6tXpx94z0R5bmvD8WuVpgaOJ26yzWzBES61Fs1wcm4R6WvAb54z5ySwg4oD >									
94 	//        < 1E-018 limites [ 1E-018 ; 38855000,2732126 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000E798086F >									
96 	//     < RE_Portfolio_XII_metadata_line_2_____Houston_Casuality_m_App_20250515 >									
97 	//        < Z53jGK0Efnca8K20At0Nht678QA2FCgNQrGij9qLp95I7U198n0NpOt9qu0NfTva >									
98 	//        < 1E-018 limites [ 38855000,2732126 ; 100606255,461729 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000E798086F257A8F87E >									
100 	//     < RE_Portfolio_XII_metadata_line_3_____Huatai_Insurance_Co,_Limited_Am_20250515 >									
101 	//        < LrljJpleRfS529fi3hur6a9rCEeH9GAdW9uDu6tkQ262i5430d0w9bMe14t66RwP >									
102 	//        < 1E-018 limites [ 100606255,461729 ; 123902825,057492 ] >									
103 	//        < 0x0000000000000000000000000000000000000000000000257A8F87E2E284B6FD >									
104 	//     < RE_Portfolio_XII_metadata_line_4_____ICICI_Lombard_General_Insurance_Co_Limited_20250515 >									
105 	//        < mk9rsTp9o5W842qNBYCGs17E8eG3ZBwtPLty62RkZp9G118ax5F2F4oo74HSjNeH >									
106 	//        < 1E-018 limites [ 123902825,057492 ; 147344007,577643 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000002E284B6FD36E3D1EE9 >									
108 	//     < RE_Portfolio_XII_metadata_line_5_____IF_P&C_Insurance_Limited__Publ__Ap_A2_20250515 >									
109 	//        < 4P7mI2taS8v6MO7T81NxHnoL0qDRkw0gd0F3DNxYmhEEMv5F1c70DjV5liyf91pN >									
110 	//        < 1E-018 limites [ 147344007,577643 ; 210249352,179246 ] >									
111 	//        < 0x000000000000000000000000000000000000000000000036E3D1EE94E52F0F25 >									
112 	//     < RE_Portfolio_XII_metadata_line_6_____India_International_Insurance_Pte_Limited_Am_20250515 >									
113 	//        < G0c0bbO24509PXW525J7ZT1MjX4yx5yh9PVKod1f3Cr97dx37e7LO8TT87P6xl88 >									
114 	//        < 1E-018 limites [ 210249352,179246 ; 228191686,623336 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000004E52F0F2555020E38A >									
116 	//     < RE_Portfolio_XII_metadata_line_7_____India_International_Insurance_Pte_Limited_Am_20250515 >									
117 	//        < woaA9eAF646EN65X9kg1w6y732p2eIcJN3YtN9Gp805ru6GXfF24h6XkoBQ2S54g >									
118 	//        < 1E-018 limites [ 228191686,623336 ; 240589715,957431 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000055020E38A59A06C7BF >									
120 	//     < RE_Portfolio_XII_metadata_line_8_____ING_Reinsurance_20250515 >									
121 	//        < 7e5M8L22H61iVo339jvE3t0vT9G4HD3Y14N8iFa2q7m8e3649cOrzWMEflgafD2M >									
122 	//        < 1E-018 limites [ 240589715,957431 ; 266846286,514168 ] >									
123 	//        < 0x000000000000000000000000000000000000000000000059A06C7BF63687209F >									
124 	//     < RE_Portfolio_XII_metadata_line_9_____ING_USA_20250515 >									
125 	//        < 400w78zskOwZV9hVbZhIYWHE0aDg0s2g6A83F0R1LbN8oY02UoKKJttuKFv4W1eF >									
126 	//        < 1E-018 limites [ 266846286,514168 ; 291379206,9308 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000063687209F6C8C164A9 >									
128 	//     < RE_Portfolio_XII_metadata_line_10_____Ingosstrakh_Ins_Co_BBp_m_20250515 >									
129 	//        < 6x30kpVVnSAF8p067BIr4lTCp92DlAJOM1nVk6g0pdVfJ7bOOARL2LGm7nZMe9Il >									
130 	//        < 1E-018 limites [ 291379206,9308 ; 363574584,99288 ] >									
131 	//        < 0x00000000000000000000000000000000000000000000006C8C164A987712CC37 >									
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
174 	//     < RE_Portfolio_XII_metadata_line_11_____Inrerlink_Reinsurance_20250515 >									
175 	//        < C54k0VEw30zaQVQX72N6649kwF288N64hElk1BvJ79vK67v2Ht3QG41v2W0iyXa2 >									
176 	//        < 1E-018 limites [ 363574584,99288 ; 377489411,804432 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000087712CC378CA032370 >									
178 	//     < RE_Portfolio_XII_metadata_line_12_____Intermediaries_and_Reinsurance_Underwriters_Assoc_20250515 >									
179 	//        < 547nmuo8FkbmMF12zzK8GLdw7D8B681v0js1fto9MIqe148zo879f55gkgNyHz9Q >									
180 	//        < 1E-018 limites [ 377489411,804432 ; 390721861,095138 ] >									
181 	//        < 0x00000000000000000000000000000000000000000000008CA032370918E240F1 >									
182 	//     < RE_Portfolio_XII_metadata_line_13_____International_General_Insurance_Company_Limited_Am_Am_20250515 >									
183 	//        < 3ZKrDZAPKvw5NWP2ic5d275Cc6nTmMYO8Jx911eKr2s5je9kM21dQEx9472bck32 >									
184 	//        < 1E-018 limites [ 390721861,095138 ; 408222693,38801 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000918E240F198132678E >									
186 	//     < RE_Portfolio_XII_metadata_line_14_____International_Insurance_Co_of_Hannover_SE_AAm_20250515 >									
187 	//        < Wc7XxZJJJywcgZ83jqu5wtTyX8L9w85fTh9bGPRAgG752k930cJuWDF30C5HZ3IU >									
188 	//        < 1E-018 limites [ 408222693,38801 ; 442982730,968393 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000098132678EA5062033C >									
190 	//     < RE_Portfolio_XII_metadata_line_15_____International_Insurance_Co_of_Hannover_SE_AAm_Ap_20250515 >									
191 	//        < mEid30E9PyP601cqWtA24Loz1Z8xWGEx5CA6uFE0no1OmjPmLXG49629d2MMs6fI >									
192 	//        < 1E-018 limites [ 442982730,968393 ; 457941981,547481 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000A5062033CAA98C047E >									
194 	//     < RE_Portfolio_XII_metadata_line_16_____Investors_Guaranty_Fund_20250515 >									
195 	//        < Iqc2PUNaEWFo8qXQ0Sc9YOcM6N0xlafOtRm1G8U26yhrEwgIOGnhA99OHu67IXOL >									
196 	//        < 1E-018 limites [ 457941981,547481 ; 486148923,435821 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000AA98C047EB51AC652B >									
198 	//     < RE_Portfolio_XII_metadata_line_17_____IRB_Brasil_Resseguros_SA_20250515 >									
199 	//        < ktxvUHb3dj9rUC7cFo6cjR5P6A1Mk8x35R1V9z2221lwF90m1Rv4R4UyYW68gqWg >									
200 	//        < 1E-018 limites [ 486148923,435821 ; 501254894,24612 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000B51AC652BBABB64704 >									
202 	//     < RE_Portfolio_XII_metadata_line_18_____IRB_Brazil_Re_20250515 >									
203 	//        < htiFLVtUzw38uSOUJJG9rJ1WEo35Mx25Qh8MWm9Tau5RQN207V0kGwtKwEe3tJIX >									
204 	//        < 1E-018 limites [ 501254894,24612 ; 513223636,19488 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000BABB64704BF30D20D7 >									
206 	//     < RE_Portfolio_XII_metadata_line_19_____Ironshore_Insurance_Limited_m_A_20250515 >									
207 	//        < yX1gAdEJpt7Ch64amzirfX8T4LNuZ7Ac15qKbXW92L301jrbiGb1p8MFZSk0c8LK >									
208 	//        < 1E-018 limites [ 513223636,19488 ; 535454451,534138 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000BF30D20D7C778EA915 >									
210 	//     < RE_Portfolio_XII_metadata_line_20_____Jordan_Insurance_co_Bpp_20250515 >									
211 	//        < MXh9674b21NSXXc6OjZxR02Ch4AC7Wnzq6mX6qE0Y4syn9ziF3gYUsT3NIGyCDf3 >									
212 	//        < 1E-018 limites [ 535454451,534138 ; 599537026,921147 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000C778EA915DF584E918 >									
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
256 	//     < RE_Portfolio_XII_metadata_line_21_____JTW_Reinsurance_Consultants_20250515 >									
257 	//        < olL637924GLPv9kSr01irls9JY21ww377eoMHtLK56A8STL0B0dB14Vh7ob7i462 >									
258 	//        < 1E-018 limites [ 599537026,921147 ; 634349215,713688 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000DF584E918EC5041857 >									
260 	//     < RE_Portfolio_XII_metadata_line_22_____Kazakhstan_BBBp_Eurasia_Insurance_Co_JSC_BBp_Bpp_20250515 >									
261 	//        < 201c9VIuD2MU6S21YBF51dUlEY8d568jIvaJp2h8NMTUEuAF6l20lwFp1IbZ4XFh >									
262 	//        < 1E-018 limites [ 634349215,713688 ; 673026363,731846 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000EC5041857FAB8CBD49 >									
264 	//     < RE_Portfolio_XII_metadata_line_23_____Kenya_Re_Bp_20250515 >									
265 	//        < 9A4rw5WtanVrf99j76ArwQ4300is0OU92Y0U7aP13BzIrp80mdGK2m8ci8r6SmAs >									
266 	//        < 1E-018 limites [ 673026363,731846 ; 683731689,978009 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000FAB8CBD49FEB5BC559 >									
268 	//     < RE_Portfolio_XII_metadata_line_24_____Korean_Re_20250515 >									
269 	//        < Abvao6S465TOU6DU4j62mOPOI5bT90cxH9JcEMTeuqFqD16u41GdXSF1ECEJ9r0N >									
270 	//        < 1E-018 limites [ 683731689,978009 ; 751996302,38762 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000FEB5BC55911823F4D92 >									
272 	//     < RE_Portfolio_XII_metadata_line_25_____Korean_Re_20250515 >									
273 	//        < 7572rcsX9ka7KEK4LC1MAXtun5pA2dcX0FMLA8vq2EPzI43j8640aIyI3j28wg29 >									
274 	//        < 1E-018 limites [ 751996302,38762 ; 784815775,723991 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000011823F4D921245DDD858 >									
276 	//     < RE_Portfolio_XII_metadata_line_26_____Korean_Re_A_20250515 >									
277 	//        < onZG122P61qRkm6Nt38u8vQ3aYFo7TCu4J8rv8T91490H5g1m8vNbfmtZRek7K9D >									
278 	//        < 1E-018 limites [ 784815775,723991 ; 801223849,211753 ] >									
279 	//        < 0x000000000000000000000000000000000000000000001245DDD85812A7AA940D >									
280 	//     < RE_Portfolio_XII_metadata_line_27_____Korean_Reinsurance_Company_20250515 >									
281 	//        < 6LgpFz6t3Trx5G7k4JG0V2u7rsi2Y31iL3ZiFXWmn11Iy5I07a74ZyY5B1m7FO8p >									
282 	//        < 1E-018 limites [ 801223849,211753 ; 850293555,968376 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000012A7AA940D13CC250240 >									
284 	//     < RE_Portfolio_XII_metadata_line_28_____Korean_Reinsurance_Company_20250515 >									
285 	//        < dzsbp50PA636xUI786NG48Ovy9xV8GZy4DDHnkrF2ZeWmuWE01od0vqDhKHpl10B >									
286 	//        < 1E-018 limites [ 850293555,968376 ; 867540116,268735 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000013CC2502401432F12BDE >									
288 	//     < RE_Portfolio_XII_metadata_line_29_____Kuwait_Reins_Co_A_20250515 >									
289 	//        < DrCjPZ8w57h0Xg64d12bQa9FA5stz1y5I8wmjPYPoFZiW1Nz6lx0iVFX53v4r2CY >									
290 	//        < 1E-018 limites [ 867540116,268735 ; 933909612,153269 ] >									
291 	//        < 0x000000000000000000000000000000000000000000001432F12BDE15BE88FC33 >									
292 	//     < RE_Portfolio_XII_metadata_line_30_____Labuan_Re_Am_20250515 >									
293 	//        < 11i8ZI5Z1KiVtj9RqYEiPB41m511IfgTdMY1f5B15qSz2e25rRLrf8553yJtzkV5 >									
294 	//        < 1E-018 limites [ 933909612,153269 ; 949023008,483127 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000015BE88FC3316189E32A4 >									
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
338 	//     < RE_Portfolio_XII_metadata_line_31_____Labuan_Reinsurance_20250515 >									
339 	//        < OO2RuQjBfhA0iU29S1Bkty94h9033i90VDWF2SFo49TY9eew351CXf8JNe216OJZ >									
340 	//        < 1E-018 limites [ 949023008,483127 ; 989885392,080596 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000016189E32A4170C2D3F3C >									
342 	//     < RE_Portfolio_XII_metadata_line_32_____Lancashire_Insurance_Co_Limited_Am_A_20250515 >									
343 	//        < 4L5I8E48Tcvt3R2FQOKe9pK5oRP1Rer8Ae2ak0boBhvB1lh21Bb586Q4ZbjCzFIs >									
344 	//        < 1E-018 limites [ 989885392,080596 ; 1024352742,77984 ] >									
345 	//        < 0x00000000000000000000000000000000000000000000170C2D3F3C17D99E4019 >									
346 	//     < RE_Portfolio_XII_metadata_line_33_____Lansforsakringar_Sak_Forsakrings_AB_A_20250515 >									
347 	//        < oDFfdsD6plJdq4MI8wcc1AlX8p1c19Rf3LbfB1yOW3gf95k9F4CN9227itt79Ca4 >									
348 	//        < 1E-018 limites [ 1024352742,77984 ; 1039505072,73667 ] >									
349 	//        < 0x0000000000000000000000000000000000000000000017D99E40191833EEDEFD >									
350 	//     < RE_Portfolio_XII_metadata_line_34_____LaSalle_Re_Limited_20250515 >									
351 	//        < xNQ2jMTVAWyLM325AmnhHkijgdIatN2J007j2yaCI4IeK23xM9ftjSuUPi98vs72 >									
352 	//        < 1E-018 limites [ 1039505072,73667 ; 1108377962,4577 ] >									
353 	//        < 0x000000000000000000000000000000000000000000001833EEDEFD19CE728F89 >									
354 	//     < RE_Portfolio_XII_metadata_line_35_____Lebanon_B_Arab_Re_Co_Bp_20250515 >									
355 	//        < A9w0Q65of6ui89Jp4z3Z6GLq8p1i5esGl3YxF5fGh1XoA3vX23h2z90qxaBL30Z7 >									
356 	//        < 1E-018 limites [ 1108377962,4577 ; 1177702873,59844 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000019CE728F891B6BA7FAF3 >									
358 	//     < RE_Portfolio_XII_metadata_line_36_____Legal_&_General_Assurance_Society_Limited_AAm_Ap_20250515 >									
359 	//        < XFL0ADikYvGHNqc6G3rL7dIeomAk88iqh3SU2v525wvBWzW16T36eoM0t1OQLLzr >									
360 	//        < 1E-018 limites [ 1177702873,59844 ;  ] >									
361 	//        < 0x000000000000000000000000000000000000000000001B6BA7FAF31BCCE82895 >									
362 	//     < RE_Portfolio_XII_metadata_line_37_____Liberty_Managing_Agency_Limited_20250515 >									
363 	//        < 5xU9mANVxlJ6i0TENja9Eq3028INN04j2Ajw9uAAf6PU5D48QvH93e86blYvlNfE >									
364 	//        < 1E-018 limites [ 1194018832,97407 ; 1226652347,86245 ] >									
365 	//        < 0x000000000000000000000000000000000000000000001BCCE828951C8F6AF356 >									
366 	//     < RE_Portfolio_XII_metadata_line_38_____Liberty_Managing_Agency_Limited_20250515 >									
367 	//        < qI2zGKBZ2k44b2f080hc0zbcnL6Za1ck7E8nz02r2e6ffpTfWmsirP36ox5c8uf4 >									
368 	//        < 1E-018 limites [ 1226652347,86245 ; 1237807252,34683 ] >									
369 	//        < 0x000000000000000000000000000000000000000000001C8F6AF3561CD1E7FBE6 >									
370 	//     < RE_Portfolio_XII_metadata_line_39_____Liberty_Managing_Agency_Limited_20250515 >									
371 	//        < 25w08lsSUnT3KX4nGb7isEZ9V23Yl0i36qSvvR8ar6j5Mb3hXPhzarsUHQzoIFM8 >									
372 	//        < 1E-018 limites [ 1237807252,34683 ; 1295936303,25949 ] >									
373 	//        < 0x000000000000000000000000000000000000000000001CD1E7FBE61E2C61E069 >									
374 	//     < RE_Portfolio_XII_metadata_line_40_____Liberty_Mutual_Ins_Co_A_A_20250515 >									
375 	//        < wIK48ILH5JcQLPLU1ha4jP6718H9ekvMk1gz0KrBB52H8swH0p9wfPkzMZfwdHzr >									
376 	//        < 1E-018 limites [ 1295936303,25949 ; 1344165245,30312 ] >									
377 	//        < 0x000000000000000000000000000000000000000000001E2C61E0691F4BD966E6 >									
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