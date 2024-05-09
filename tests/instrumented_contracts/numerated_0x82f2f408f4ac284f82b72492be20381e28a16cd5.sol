1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RE_Portfolio_XI_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RE_Portfolio_XI_883		"	;
8 		string	public		symbol =	"	RE883XI		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1453938925589850000000000000					;	
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
92 	//     < RE_Portfolio_XI_metadata_line_1_____Great_West_Lifeco_20250515 >									
93 	//        < XzZ1DK8ngUhgEyXE3ZR66LIPqEAvB37n4csP9MALEudGa8Q56LXe40sBIyL9ZqcZ >									
94 	//        < 1E-018 limites [ 1E-018 ; 19569831,6845323 ] >									
95 	//        < 0x0000000000000000000000000000000000000000000000000000000074A53374 >									
96 	//     < RE_Portfolio_XI_metadata_line_2_____Greenlight_Capital_Re_20250515 >									
97 	//        < dmX04Cfe126MxSKk6eX78Xvrd6LcjLqfaAFFQ6iGjsJ4t4lZdDnohIJo85S5X7tf >									
98 	//        < 1E-018 limites [ 19569831,6845323 ; 65367910,7980701 ] >									
99 	//        < 0x0000000000000000000000000000000000000000000000074A533741859F861B >									
100 	//     < RE_Portfolio_XI_metadata_line_3_____Griffiths_and_Wanklyn_Reinsurance_Brokers_20250515 >									
101 	//        < 75iGCneq5vn4qh7CsZZsTYO4k0qk4fxdXivI00UPHtUXAi4UjIbmhriCp9kOMu7f >									
102 	//        < 1E-018 limites [ 65367910,7980701 ; 131251358,732801 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000001859F861B30E51AFF5 >									
104 	//     < RE_Portfolio_XI_metadata_line_4_____Grinnell_Mutual_Group_20250515 >									
105 	//        < uDlGL8vNI9GBOFyuQ5g0zineaLC77BAFZXUH7WjNfraEWeuOlbOQ3PLoh2z0ehV1 >									
106 	//        < 1E-018 limites [ 131251358,732801 ; 146876548,757537 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000030E51AFF536B73D5CF >									
108 	//     < RE_Portfolio_XI_metadata_line_5_____Guaranty_Fund_Management_Services_20250515 >									
109 	//        < JXi8J6NPS8TmnV91qMlNKwcN9K6Id26Y7uCq76CVfhXNky77bcyT4k2T0s932Wd6 >									
110 	//        < 1E-018 limites [ 146876548,757537 ; 187712386,118772 ] >									
111 	//        < 0x000000000000000000000000000000000000000000000036B73D5CF45EDA60C7 >									
112 	//     < RE_Portfolio_XI_metadata_line_6_____Guernsey_AAp_Jupiter_Insurance_Limited_A_20250515 >									
113 	//        < jgwwz88rIrp2mD1t166mR6R68ewbiHbD5mItO9VONb4eX98ZY0CRqJ051Ls2ckDX >									
114 	//        < 1E-018 limites [ 187712386,118772 ; 227222284,992817 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000045EDA60C754A59B307 >									
116 	//     < RE_Portfolio_XI_metadata_line_7_____Gulf_Ins_And_Reinsuerance_Co_Am_m_20250515 >									
117 	//        < 40LJPs0oS2EzTJPY1704MI2h29nhz17DeHK046Y1a6vcnhbMh1BilN50LMACY3i5 >									
118 	//        < 1E-018 limites [ 227222284,992817 ; 279883619,620244 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000054A59B3076843C84DE >									
120 	//     < RE_Portfolio_XI_metadata_line_8_____Gulf_Reinsurance_limited_Am_20250515 >									
121 	//        < xX7pb6X9I0a08A46fqLxG4G13yS72GXdFwh9dRA4CYr32DOHxB06c2Gx85Ir5Pck >									
122 	//        < 1E-018 limites [ 279883619,620244 ; 291627888,479581 ] >									
123 	//        < 0x00000000000000000000000000000000000000000000006843C84DE6CA3CD9E3 >									
124 	//     < RE_Portfolio_XI_metadata_line_9_____Guy_Carpenter_Reinsurance_20250515 >									
125 	//        < 2r1q1xdVg9k2c0iBUR5puegxcJnqwVEBfS0gwCD4Y6ryXChXwhrHY8G0kC1ctwB0 >									
126 	//        < 1E-018 limites [ 291627888,479581 ; 323838938,886402 ] >									
127 	//        < 0x00000000000000000000000000000000000000000000006CA3CD9E378A3B0374 >									
128 	//     < RE_Portfolio_XI_metadata_line_10_____Hamilton_Underwriting_Limited_20250515 >									
129 	//        < kmgIh2013y1irMRjeLSoQ1tj9piHrcPZvYsTfPTo8g86DnyS6W1058Y7LDin3Tkc >									
130 	//        < 1E-018 limites [ 323838938,886402 ; 336243829,869306 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000078A3B03747D42B5FFE >									
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
174 	//     < RE_Portfolio_XI_metadata_line_11_____Hamilton_Underwriting_Limited_20250515 >									
175 	//        < D594nbS0ToQqtvCH5zBi79azli04hZWY86F8ARtw95F64QEMB2wIrNa7b5M87D62 >									
176 	//        < 1E-018 limites [ 336243829,869306 ; 397167608,586775 ] >									
177 	//        < 0x00000000000000000000000000000000000000000000007D42B5FFE93F4DAF0E >									
178 	//     < RE_Portfolio_XI_metadata_line_12_____Hannover_Life_Re_20250515 >									
179 	//        < MRjWta7M21Egw3NL8Edlr14kd18vWY64w934NV8ygbT78nSwwdA8QElBJROahy6x >									
180 	//        < 1E-018 limites [ 397167608,586775 ; 433692041,918113 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000093F4DAF0EA19018BD3 >									
182 	//     < RE_Portfolio_XI_metadata_line_13_____Hannover_Re_Group_20250515 >									
183 	//        < er8oB6YcQqzGb3uueri195WIAjqad3KjzE8dg91Qkp1s4Ap5lYC7Vsqqe4463nxw >									
184 	//        < 1E-018 limites [ 433692041,918113 ; 446309827,635949 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000A19018BD3A6436C25F >									
186 	//     < RE_Portfolio_XI_metadata_line_14_____Hannover_Re_Group_20250515 >									
187 	//        < lYNa07Um2ZS1Rj8qkqfGYZFv56z4u1SluFbzdHuDyIz2E1m7BI7uN9n6jSjq43qm >									
188 	//        < 1E-018 limites [ 446309827,635949 ; 490892761,227866 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000A6436C25FB6DF2EACE >									
190 	//     < RE_Portfolio_XI_metadata_line_15_____Hannover_Reinsurance_Group_Africa_20250515 >									
191 	//        < p68739A96QEAIr66foGMjnA35ZCn75191CzAf9028Xt6aR1V55J7PbdJHsjt01Im >									
192 	//        < 1E-018 limites [ 490892761,227866 ; 558925993,846774 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000B6DF2EACED0375644C >									
194 	//     < RE_Portfolio_XI_metadata_line_16_____Hannover_ReTakaful_BSC_Ap_m_20250515 >									
195 	//        < CVv4ZWvI2s5D425K8k45pG1yE3B38gY1M14RW3LTq8kiMA97E2v2YGZtxDABbpTi >									
196 	//        < 1E-018 limites [ 558925993,846774 ; 604025094,139495 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000D0375644CE10452859 >									
198 	//     < RE_Portfolio_XI_metadata_line_17_____Hannover_ReTakaful_BSC_Ap_m_20250515 >									
199 	//        < n81066sGJebjWFhtdD1the0f0z8kwDI33Ep9yZVxt5e1aq6ll739wQQG7c6cO276 >									
200 	//        < 1E-018 limites [ 604025094,139495 ; 631006955,172866 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000E10452859EB11835D1 >									
202 	//     < RE_Portfolio_XI_metadata_line_18_____Hannover_Rueck_SE_AAm_20250515 >									
203 	//        < MbfRlcj5j8D41Wtf34q6t7fM2ixp686bd6nYKe3eGj8nJw8q2C4oJOi8m9DQoXqM >									
204 	//        < 1E-018 limites [ 631006955,172866 ; 641615496,058131 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000EB11835D1EF0538F19 >									
206 	//     < RE_Portfolio_XI_metadata_line_19_____Hannover_Rueckversicherung_AG_20250515 >									
207 	//        < 4os04EAg93MxrUaZgu0oqb5j6v3wd1I7Cg1ahTSSM21cl9up88CJ6dzSRAi3a54z >									
208 	//        < 1E-018 limites [ 641615496,058131 ; 697699360,277755 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000EF0538F19103E9CBE8F >									
210 	//     < RE_Portfolio_XI_metadata_line_20_____Hardy__Underwriting_Agencies__Limited_20250515 >									
211 	//        < 922x2wiwk0V3v4kwVQ9rbfRq12JZ5Pp0N8v8rya37C4BTVwIS992hVIUzk9klCjB >									
212 	//        < 1E-018 limites [ 697699360,277755 ; 759840916,352554 ] >									
213 	//        < 0x00000000000000000000000000000000000000000000103E9CBE8F11B1013BE7 >									
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
256 	//     < RE_Portfolio_XI_metadata_line_21_____Hardy__Underwriting_Agencies__Limited_20250515 >									
257 	//        < V93zF15O670Ee3CYHZDlW819GCD6iQBFKcNk6lStxDwXoIvqO2H8H8lhq071WZD1 >									
258 	//        < 1E-018 limites [ 759840916,352554 ; 788560124,817188 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000011B1013BE7125C2F44B5 >									
260 	//     < RE_Portfolio_XI_metadata_line_22_____Hardy_(Underwriting_Agencies)_Limited_20250515 >									
261 	//        < hhso34PeDkJU1M620TeW1AfV7a1L6Pa33KJiTE005UPs7mvdRDJs8O66u7blP61U >									
262 	//        < 1E-018 limites [ 788560124,817188 ; 826897315,451359 ] >									
263 	//        < 0x00000000000000000000000000000000000000000000125C2F44B51340B12DCD >									
264 	//     < RE_Portfolio_XI_metadata_line_23_____HCC_International_Insurance_Co_PLC_AAm_m_20250515 >									
265 	//        < A8BlNrFf44m8r8tWTA1b4l705Jm2827nB23qba3c12Lr80Z9b7QxiqJq0GXj8E2W >									
266 	//        < 1E-018 limites [ 826897315,451359 ; 865840983,603299 ] >									
267 	//        < 0x000000000000000000000000000000000000000000001340B12DCD1428D0802C >									
268 	//     < RE_Portfolio_XI_metadata_line_24_____HCC_Underwriting_Agency_Limited_20250515 >									
269 	//        < 8x57d5e6Y0W262vjN7ZUauZOyAIhG7EqZF7IainY97VNZL6KDR7CkCo95j8NRh88 >									
270 	//        < 1E-018 limites [ 865840983,603299 ; 877311036,88113 ] >									
271 	//        < 0x000000000000000000000000000000000000000000001428D0802C146D2E69BC >									
272 	//     < RE_Portfolio_XI_metadata_line_25_____HCC_Underwriting_Agency_Limited_20250515 >									
273 	//        < VS0IH2BuA70NWJAL7K248Ug7Dugz4iZ75H3YaBIxIBa8ea2jx4XcvH4sWao4sxEf >									
274 	//        < 1E-018 limites [ 877311036,88113 ; 916878075,111654 ] >									
275 	//        < 0x00000000000000000000000000000000000000000000146D2E69BC155904EC0B >									
276 	//     < RE_Portfolio_XI_metadata_line_26_____HDImGerling_Welt_Service_Ag_Ap_m_20250515 >									
277 	//        < I1r4UPmglSrMcE5LiSxxr8yXAwk1sFI41kbJNP8Gn1969EijvgcE9q7G2M26Q824 >									
278 	//        < 1E-018 limites [ 916878075,111654 ; 927646922,32741 ] >									
279 	//        < 0x00000000000000000000000000000000000000000000155904EC0B159934E0FC >									
280 	//     < RE_Portfolio_XI_metadata_line_27_____Helvetia_Schweizerische_Co_A_m_20250515 >									
281 	//        < 96O7N3jo7lcMprlxSFlws4fJxC4iG1gtwtpNZrf54uR8Vzxi4q75bd108YO0FRji >									
282 	//        < 1E-018 limites [ 927646922,32741 ; 970959569,603872 ] >									
283 	//        < 0x00000000000000000000000000000000000000000000159934E0FC169B5EBBD4 >									
284 	//     < RE_Portfolio_XI_metadata_line_28_____Helvetia_Schweizerische_Versicherungs_Gesellschaft_in_Liechtenstein_AG_20250515 >									
285 	//        < 56P9M19o28k1oG05T9kNz1dVjl2vveZ9d13M705GVcHcx4L5N684lFJVI26G3LOb >									
286 	//        < 1E-018 limites [ 970959569,603872 ; 994566143,702659 ] >									
287 	//        < 0x00000000000000000000000000000000000000000000169B5EBBD417281381D6 >									
288 	//     < RE_Portfolio_XI_metadata_line_29_____Helvetia_Schweizerische_VersicherungsmGesellschaft_in_Liechtenstein_AG_A_20250515 >									
289 	//        < BlO59nC63RsN2105DBTOk6XwQEHe1zu7gL99dBtAeJ5z5Gn5R6x4XplheQ0u3Vs1 >									
290 	//        < 1E-018 limites [ 994566143,702659 ; 1019227912,49957 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000017281381D617BB126145 >									
292 	//     < RE_Portfolio_XI_metadata_line_30_____Hiscox_20250515 >									
293 	//        < 8W127Qgnkk128F7UYYrCWRpxhye6Rid6d42Q84yZ4qQ1hqfRXm7hiIwwk48447Oo >									
294 	//        < 1E-018 limites [ 1019227912,49957 ; 1078846253,8967 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000017BB126145191E6CBFE1 >									
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
338 	//     < RE_Portfolio_XI_metadata_line_31_____Hiscox_Ins_Co_Limited_A_A_20250515 >									
339 	//        < A882Gf3stw5cNo8KO2d962zRGtK5P1lj6z04mm3nHpeJ9AZh2Sv6r5Nn14XMke5A >									
340 	//        < 1E-018 limites [ 1078846253,8967 ; 1101825983,47766 ] >									
341 	//        < 0x00000000000000000000000000000000000000000000191E6CBFE119A76508BF >									
342 	//     < RE_Portfolio_XI_metadata_line_32_____Hiscox_Syndicates_Limited_20250515 >									
343 	//        < zfe849X8W6Mwyg5M1fi6h44cB49836hB5I3o68P99N63x50X4h2xD0OpNz0qLuHd >									
344 	//        < 1E-018 limites [ 1101825983,47766 ; 1148451235,99953 ] >									
345 	//        < 0x0000000000000000000000000000000000000000000019A76508BF1ABD4D8603 >									
346 	//     < RE_Portfolio_XI_metadata_line_33_____Hiscox_Syndicates_Limited_20250515 >									
347 	//        < t7pP2Vy9g8h6t1a1NL50M26VZ44fgM0O510r533eBAowJGaC31YwAeIm4p8v7w3s >									
348 	//        < 1E-018 limites [ 1148451235,99953 ; 1164744108,05645 ] >									
349 	//        < 0x000000000000000000000000000000000000000000001ABD4D86031B1E6A7929 >									
350 	//     < RE_Portfolio_XI_metadata_line_34_____Hiscox_Syndicates_Limited_20250515 >									
351 	//        < 0o37Nva4yOpB1rSKYT3jEHB0V7aMc06d7cerpS736y4JL6EG9E96jpK104YxqAQ1 >									
352 	//        < 1E-018 limites [ 1164744108,05645 ; 1223787655,74777 ] >									
353 	//        < 0x000000000000000000000000000000000000000000001B1E6A79291C7E57C6FA >									
354 	//     < RE_Portfolio_XI_metadata_line_35_____Hiscox_Syndicates_Limited_20250515 >									
355 	//        < AR30JyfUBtUMB0hL5qBB7ddoQrFp1DdR31Y2FpqEtI6Jh9nK35m6pB2k2wBJLenU >									
356 	//        < 1E-018 limites [ 1223787655,74777 ; 1249832336,60374 ] >									
357 	//        < 0x000000000000000000000000000000000000000000001C7E57C6FA1D1994CE70 >									
358 	//     < RE_Portfolio_XI_metadata_line_36_____Hiscox_Syndicates_Limited_20250515 >									
359 	//        < ovH75844WVH84zxbT647xdV425yc53WNF8z83kDCVtJ21vOU7eQ5h1uIJ2gi6D2A >									
360 	//        < 1E-018 limites [ 1249832336,60374 ;  ] >									
361 	//        < 0x000000000000000000000000000000000000000000001D1994CE701D5FFA7AF9 >									
362 	//     < RE_Portfolio_XI_metadata_line_37_____Hiscox_Syndicates_Limited_20250515 >									
363 	//        < GoGbBfYy3corIo8VjVvxw3X83vg6F97r8p4k97gu3VKc8mpYuH7HNuwb2Z97icfl >									
364 	//        < 1E-018 limites [ 1261643020,85112 ; 1284495587,87034 ] >									
365 	//        < 0x000000000000000000000000000000000000000000001D5FFA7AF91DE830BAF7 >									
366 	//     < RE_Portfolio_XI_metadata_line_38_____Hiscox_Syndicates_Limited_20250515 >									
367 	//        < u8HWB9j1q9CF7cgwo5Y7OH10f8n0F0L7x4vH6QrPgy71iECvCRVM0DO2S5ccBk0s >									
368 	//        < 1E-018 limites [ 1284495587,87034 ; 1345041522,12734 ] >									
369 	//        < 0x000000000000000000000000000000000000000000001DE830BAF71F51127E88 >									
370 	//     < RE_Portfolio_XI_metadata_line_39_____Hiscox_Syndicates_Limited    _20250515 >									
371 	//        < Y04o3Zi826RQ11rMHEGCm8h8L40auB1EFqvln79UyKRu93EREKv2m9q4N9KeW2Ql >									
372 	//        < 1E-018 limites [ 1345041522,12734 ; 1384825398,98107 ] >									
373 	//        < 0x000000000000000000000000000000000000000000001F51127E88203E33DF6E >									
374 	//     < RE_Portfolio_XI_metadata_line_40_____Hiscox_Syndicates_Limited    _20250515 >									
375 	//        < 5MDwmPS9Ei0w7Z57P02Tqo98sK432RaHA9dzp0Fh958cN706Zb8RdXMa080u2aze >									
376 	//        < 1E-018 limites [ 1384825398,98107 ; 1453938925,58985 ] >									
377 	//        < 0x00000000000000000000000000000000000000000000203E33DF6E21DA26BEC2 >									
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