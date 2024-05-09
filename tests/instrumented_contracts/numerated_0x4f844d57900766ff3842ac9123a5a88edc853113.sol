1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXVII_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXVII_III_883		"	;
8 		string	public		symbol =	"	RUSS_PFXVII_III_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1077048819523000000000000000					;	
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
92 	//     < RUSS_PFXVII_III_metadata_line_1_____URALKALI_1_ORG_20251101 >									
93 	//        < fDv111AUcG0rC8ukQSX39xMUuwf8a7IvtzNN96N7d50gQy73riYeA737203lbx9w >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000034765461.101131400000000000 ] >									
95 	//        < 0x0000000000000000000000000000000000000000000000000000000000350C42 >									
96 	//     < RUSS_PFXVII_III_metadata_line_2_____URALKALI_1_DAO_20251101 >									
97 	//        < 7T291QB272s71fNNltXm7rfFV3987Bi2x0B99JU2oRjpKRA18P6LGFD2O44Rxvfz >									
98 	//        <  u =="0.000000000000000001" : ] 000000034765461.101131400000000000 ; 000000056526642.850054900000000000 ] >									
99 	//        < 0x0000000000000000000000000000000000000000000000000000350C425640B8 >									
100 	//     < RUSS_PFXVII_III_metadata_line_3_____URALKALI_1_DAOPI_20251101 >									
101 	//        < WLqGe4VS1E86Z0364134IaGgN7t4m2fnrjS0ZM4t3Dz414RDsq0BQO1P7V044AUn >									
102 	//        <  u =="0.000000000000000001" : ] 000000056526642.850054900000000000 ; 000000087725390.688959200000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000005640B885DBBB >									
104 	//     < RUSS_PFXVII_III_metadata_line_4_____URALKALI_1_DAC_20251101 >									
105 	//        < nU95cI7u8F7qoV2W1z1m4ilP8xrbQD19mP9kqj5M85D72Je8em1T7hAlDj6LpiI4 >									
106 	//        <  u =="0.000000000000000001" : ] 000000087725390.688959200000000000 ; 000000114046076.140663000000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000085DBBBAE0540 >									
108 	//     < RUSS_PFXVII_III_metadata_line_5_____URALKALI_1_BIMI_20251101 >									
109 	//        < 3J2rRgkVs37T67M55g7Y4Gr4pq8UwqPH53ocKf1KRNuIIQ73e4SV483vrJ1U42l5 >									
110 	//        <  u =="0.000000000000000001" : ] 000000114046076.140663000000000000 ; 000000148865002.688591000000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000AE0540E32664 >									
112 	//     < RUSS_PFXVII_III_metadata_line_6_____URALKALI_2_ORG_20251101 >									
113 	//        < 2uA74t1BjU72hVM30JoBPDY3EurHMrnBkuDjFi84pvl6MiOL1G93WHL8c92Dx5IW >									
114 	//        <  u =="0.000000000000000001" : ] 000000148865002.688591000000000000 ; 000000172238944.006173000000000000 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000000000E32664106D0D6 >									
116 	//     < RUSS_PFXVII_III_metadata_line_7_____URALKALI_2_DAO_20251101 >									
117 	//        < EAErhS5XRN5T8VBqvSJniMn70cMGi4wvT5f3U2H0z55lFCzN7OLyb6GsI95ArlKJ >									
118 	//        <  u =="0.000000000000000001" : ] 000000172238944.006173000000000000 ; 000000192535689.802203000000000000 ] >									
119 	//        < 0x00000000000000000000000000000000000000000000000000106D0D6125C941 >									
120 	//     < RUSS_PFXVII_III_metadata_line_8_____URALKALI_2_DAOPI_20251101 >									
121 	//        < 4HXj1wt65C8WEK61a1m1lHNTB970TJ33R0K37UUhf2VTE8z77EIwEc9pkQ23N5wd >									
122 	//        <  u =="0.000000000000000001" : ] 000000192535689.802203000000000000 ; 000000223379508.638902000000000000 ] >									
123 	//        < 0x00000000000000000000000000000000000000000000000000125C941154D99F >									
124 	//     < RUSS_PFXVII_III_metadata_line_9_____URALKALI_2_DAC_20251101 >									
125 	//        < z50SOY3D2QBTz2HFz9ARUCgfyT83vur9D9e1gS8669532Iuha5GOo10KrmKRXk5u >									
126 	//        <  u =="0.000000000000000001" : ] 000000223379508.638902000000000000 ; 000000254790027.714141000000000000 ] >									
127 	//        < 0x00000000000000000000000000000000000000000000000000154D99F184C75B >									
128 	//     < RUSS_PFXVII_III_metadata_line_10_____URALKALI_2_BIMI_20251101 >									
129 	//        < 5inm6y9fe56B9UJyAebu8Ye3pnv8Cm6EJOS1F4z5si8NMb19FS288XSrduyE4F9S >									
130 	//        <  u =="0.000000000000000001" : ] 000000254790027.714141000000000000 ; 000000274713566.100104000000000000 ] >									
131 	//        < 0x00000000000000000000000000000000000000000000000000184C75B1A32DFD >									
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
174 	//     < RUSS_PFXVII_III_metadata_line_11_____KAMA_1_ORG_20251101 >									
175 	//        < 7nT8CGTh0XmjfAeMEaEMgF2EPMk55GyiU6ZQZA83n1hsRRQq7Zrl3Ev9snpJaKmn >									
176 	//        <  u =="0.000000000000000001" : ] 000000274713566.100104000000000000 ; 000000293540835.153724000000000000 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000000001A32DFD1BFE864 >									
178 	//     < RUSS_PFXVII_III_metadata_line_12_____KAMA_1_DAO_20251101 >									
179 	//        < 6cgP6KmYzyPT48p9VBckAk73gf3ltKv1VVH4v3H93vU7M8OTC30y8zs2szUPrp32 >									
180 	//        <  u =="0.000000000000000001" : ] 000000293540835.153724000000000000 ; 000000318107051.900364000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000001BFE8641E56491 >									
182 	//     < RUSS_PFXVII_III_metadata_line_13_____KAMA_1_DAOPI_20251101 >									
183 	//        < 5u880tnzN36eX7Lu5MlHa74aRyBrS5u5GoAVj070qB0Ly3Mh488T2H42WWAv7xD9 >									
184 	//        <  u =="0.000000000000000001" : ] 000000318107051.900364000000000000 ; 000000341430515.003258000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001E56491208FB4C >									
186 	//     < RUSS_PFXVII_III_metadata_line_14_____KAMA_1_DAC_20251101 >									
187 	//        < 07TaI4F6U15A3zG8K55UB57B242xt9650XW1TGI15R30s7tOdG763ui5cZ17v60h >									
188 	//        <  u =="0.000000000000000001" : ] 000000341430515.003258000000000000 ; 000000370809238.386350000000000000 ] >									
189 	//        < 0x00000000000000000000000000000000000000000000000000208FB4C235CF5C >									
190 	//     < RUSS_PFXVII_III_metadata_line_15_____KAMA_1_BIMI_20251101 >									
191 	//        < y19U8wI7Qm2i7ShABatzax5q7ln5A85Gsd06vEdOnz9wl7Zq42NGgv2T0S779r0r >									
192 	//        <  u =="0.000000000000000001" : ] 000000370809238.386350000000000000 ; 000000394724864.427369000000000000 ] >									
193 	//        < 0x00000000000000000000000000000000000000000000000000235CF5C25A4D66 >									
194 	//     < RUSS_PFXVII_III_metadata_line_16_____KAMA_2_ORG_20251101 >									
195 	//        < 4taAlJtM8IhE89X4rPOhl4A4Ow3QjLZ3G5E35c071E38P3p0wiNX5tFoAakrdtOT >									
196 	//        <  u =="0.000000000000000001" : ] 000000394724864.427369000000000000 ; 000000423215240.386634000000000000 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000000025A4D66285C674 >									
198 	//     < RUSS_PFXVII_III_metadata_line_17_____KAMA_2_DAO_20251101 >									
199 	//        < qZL507ca1ThW30LNx70inTJOu25tI160f3zv831X37eYX1ffYdr18E53j3IsaZrs >									
200 	//        <  u =="0.000000000000000001" : ] 000000423215240.386634000000000000 ; 000000441676133.836081000000000000 ] >									
201 	//        < 0x00000000000000000000000000000000000000000000000000285C6742A1F1BD >									
202 	//     < RUSS_PFXVII_III_metadata_line_18_____KAMA_2_DAOPI_20251101 >									
203 	//        < DcP84fJKCeGb4IGF5pyCNoN8ugATTvYh8dPE0ZYAHAB5Cb86m8n2mFK3L95QjHs0 >									
204 	//        <  u =="0.000000000000000001" : ] 000000441676133.836081000000000000 ; 000000466940935.088631000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000002A1F1BD2C87ECE >									
206 	//     < RUSS_PFXVII_III_metadata_line_19_____KAMA_2_DAC_20251101 >									
207 	//        < ERMK3c1tCxR09h85aC2vcrDj0YW33hpwtRbG3mtNtkqdNMWrS3x1BgRz7qM4vlnr >									
208 	//        <  u =="0.000000000000000001" : ] 000000466940935.088631000000000000 ; 000000492890861.163170000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000002C87ECE2F0177E >									
210 	//     < RUSS_PFXVII_III_metadata_line_20_____KAMA_2_BIMI_20251101 >									
211 	//        < 2VP3XB85QS701Teukv36srn21mIiDCnY64Jgw8vr4bRJ0KSkS21r53c9e67HF33s >									
212 	//        <  u =="0.000000000000000001" : ] 000000492890861.163170000000000000 ; 000000517130879.033673000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000002F0177E3151440 >									
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
256 	//     < RUSS_PFXVII_III_metadata_line_21_____KAMA_20251101 >									
257 	//        < e814UnSNQx9J7zehl2iHLrfD2vh766UvWj8le84Z42hLJi1An4YEE1ze8IAX9827 >									
258 	//        <  u =="0.000000000000000001" : ] 000000517130879.033673000000000000 ; 000000550158793.708862000000000000 ] >									
259 	//        < 0x00000000000000000000000000000000000000000000000000315144034779C7 >									
260 	//     < RUSS_PFXVII_III_metadata_line_22_____URALKALI_TRADING_SIA_20251101 >									
261 	//        < lcL9X13UNCkh5G0FsEo18ERf215DS92aLrDjCK7wHVyDoOOaw4t53oY1xc54k2E7 >									
262 	//        <  u =="0.000000000000000001" : ] 000000550158793.708862000000000000 ; 000000585529511.001261000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000034779C737D7277 >									
264 	//     < RUSS_PFXVII_III_metadata_line_23_____BALTIC_BULKER_TERMINAL_20251101 >									
265 	//        < RV1AE14d44gDrPXnAq7XJs8PZsA0iM41dmS7BgBwTrN2MW7Z0H9xC4lbheFpF3M4 >									
266 	//        <  u =="0.000000000000000001" : ] 000000585529511.001261000000000000 ; 000000617533175.270641000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000037D72773AE47E6 >									
268 	//     < RUSS_PFXVII_III_metadata_line_24_____URALKALI_FINANCE_LIMITED_20251101 >									
269 	//        < Nd5c535LtrJ6A3J11sQkMhnLk2k5om1COQb4I0A6Ej7B2Ma1RhTgMWoDl1L5w3ps >									
270 	//        <  u =="0.000000000000000001" : ] 000000617533175.270641000000000000 ; 000000646731951.001023000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000003AE47E63DAD5AB >									
272 	//     < RUSS_PFXVII_III_metadata_line_25_____SOLIKAMSK_CONSTRUCTION_TRUST_20251101 >									
273 	//        < IWEPpa8z5xp25GZ9Isw7K25M10cbNrq4Mb79V3vyHV3W0tOQ6tHc0sHgPlq78KxT >									
274 	//        <  u =="0.000000000000000001" : ] 000000646731951.001023000000000000 ; 000000667025231.204549000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000003DAD5AB3F9CCBB >									
276 	//     < RUSS_PFXVII_III_metadata_line_26_____SILVINIT_CAPITAL_20251101 >									
277 	//        < 8TPTA5SyWB9og0TaeZe5qzM6e6lm0bJ2EJPF7F68gwQqcE0lc2qIqg2K48Gm8rVl >									
278 	//        <  u =="0.000000000000000001" : ] 000000667025231.204549000000000000 ; 000000702425214.719465000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000003F9CCBB42FD0D9 >									
280 	//     < RUSS_PFXVII_III_metadata_line_27_____AUTOMATION_MEASUREMENTS_CENTER_20251101 >									
281 	//        < v0o7J42516oSQZ5s1Wxm2d7io0kqPd00WN44krb4G4VkHWEJYG7pm22R2JR43uXG >									
282 	//        <  u =="0.000000000000000001" : ] 000000702425214.719465000000000000 ; 000000726050328.657567000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000042FD0D9453DD69 >									
284 	//     < RUSS_PFXVII_III_metadata_line_28_____LOVOZERSKAYA_ORE_DRESSING_CO_20251101 >									
285 	//        < 14WLcM6tbpg5h9PLIuKy4t4ZXQaJbrzbNRwTl9zoEO5z8h6hNse7X1Jox3oLqlvJ >									
286 	//        <  u =="0.000000000000000001" : ] 000000726050328.657567000000000000 ; 000000755055248.650687000000000000 ] >									
287 	//        < 0x00000000000000000000000000000000000000000000000000453DD694801F75 >									
288 	//     < RUSS_PFXVII_III_metadata_line_29_____URALKALI_ENGINEERING_20251101 >									
289 	//        < O4NGJPbGb76Wy94Wf6X84v0u16ZtDQB1vwe3o3jK3r1np1BbCfyiHyKsNI37iq45 >									
290 	//        <  u =="0.000000000000000001" : ] 000000755055248.650687000000000000 ; 000000785132423.818624000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000004801F754AE045A >									
292 	//     < RUSS_PFXVII_III_metadata_line_30_____URALKALI_DEPO_20251101 >									
293 	//        < 4B5JI2F86x87419Gr5UMPJv27OnltFr9n527mpe5qsqxhYs0So43dHh9h4m3t6qJ >									
294 	//        <  u =="0.000000000000000001" : ] 000000785132423.818624000000000000 ; 000000803725093.529653000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000004AE045A4CA631D >									
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
338 	//     < RUSS_PFXVII_III_metadata_line_31_____VAGONNOE_DEPO_BALAKHONZI_20251101 >									
339 	//        < 4ldphxbVFUOH1R31Q71qFB7Gk4uP7OKdwR972yD9xmc5d7Noi5Jr0p1ab6B2B57p >									
340 	//        <  u =="0.000000000000000001" : ] 000000803725093.529653000000000000 ; 000000834869830.237081000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000004CA631D4F9E907 >									
342 	//     < RUSS_PFXVII_III_metadata_line_32_____SILVINIT_TRANSPORT_20251101 >									
343 	//        < kQEn3t83e4wPEXn7Us03f9H87L75v97i7uWL918B9H41zWJCkU3NCRF3ZiW7s2MB >									
344 	//        <  u =="0.000000000000000001" : ] 000000834869830.237081000000000000 ; 000000860611034.396167000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000004F9E907521302F >									
346 	//     < RUSS_PFXVII_III_metadata_line_33_____AUTOTRANSKALI_20251101 >									
347 	//        < M66PcZuFjIq6YgJ3Fx9Yy7Q6jQD4A50QfWx6493yxi1wnx6JGTNI20T8Lh2kwn6H >									
348 	//        <  u =="0.000000000000000001" : ] 000000860611034.396167000000000000 ; 000000880364254.615819000000000000 ] >									
349 	//        < 0x00000000000000000000000000000000000000000000000000521302F53F5449 >									
350 	//     < RUSS_PFXVII_III_metadata_line_34_____URALKALI_REMONT_20251101 >									
351 	//        < bV6XgiSeh7I6vd9389j3E0lp80Vqs4NJMOS4hjKo2ufJgH9plW5552B5O3LBMI3s >									
352 	//        <  u =="0.000000000000000001" : ] 000000880364254.615819000000000000 ; 000000914970276.962984000000000000 ] >									
353 	//        < 0x0000000000000000000000000000000000000000000000000053F54495742244 >									
354 	//     < RUSS_PFXVII_III_metadata_line_35_____EN_RESURS_OOO_20251101 >									
355 	//        < J0L5C5gBg7ox1uUH8v4tWjC5FxdrHu9fYTf8c6M9Ly8J3108EVvi8TJ09uf99LE8 >									
356 	//        <  u =="0.000000000000000001" : ] 000000914970276.962984000000000000 ; 000000933636717.545874000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000057422445909DD8 >									
358 	//     < RUSS_PFXVII_III_metadata_line_36_____BSHSU_20251101 >									
359 	//        < 2kW0yebUp9UkmasNhgMzcp4I1200M09d8Ufdp49k9Ymw9kD86y2X39f7u7nYxWO9 >									
360 	//        <  u =="0.000000000000000001" : ] 000000933636717.545874000000000000 ; 000000966414668.417179000000000000 ] >									
361 	//        < 0x000000000000000000000000000000000000000000000000005909DD85C2A1BB >									
362 	//     < RUSS_PFXVII_III_metadata_line_37_____URALKALI_TECHNOLOGY_20251101 >									
363 	//        < 1gJgtEMyeTAD3HD1B3T7t9zKo7F2T9yv76wKI0JfL8exE2B4XrQeD6SlZlv238VQ >									
364 	//        <  u =="0.000000000000000001" : ] 000000966414668.417179000000000000 ; 000001000963664.433320000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000005C2A1BB5F7596E >									
366 	//     < RUSS_PFXVII_III_metadata_line_38_____KAMA_MINERAL_OOO_20251101 >									
367 	//        < N0qOn2Y76TgcG82K1xA7200K6wBH9JmG26Pe3M43JO0R73f3dP6r3kwocPxcz1Eb >									
368 	//        <  u =="0.000000000000000001" : ] 000001000963664.433320000000000000 ; 000001028063734.392100000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000005F7596E620B365 >									
370 	//     < RUSS_PFXVII_III_metadata_line_39_____SOLIKAMSKSTROY_ZAO_20251101 >									
371 	//        < 537Hr6Gy11W696KV04d1zE4tXbSJK1Uk9tnLC6T2522E5vsngnpVtAhRsl045nvk >									
372 	//        <  u =="0.000000000000000001" : ] 000001028063734.392100000000000000 ; 000001057764637.448190000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000620B36564E0550 >									
374 	//     < RUSS_PFXVII_III_metadata_line_40_____NOVAYA_NEDVIZHIMOST_20251101 >									
375 	//        < hBf3J1e72iwodw589aM82793iffreo3122H6M4kZqswIRdGIais4i43YVix4q81G >									
376 	//        <  u =="0.000000000000000001" : ] 000001057764637.448190000000000000 ; 000001077048819.523000000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000064E055066B7232 >									
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