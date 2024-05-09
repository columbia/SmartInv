1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFVII_II_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFVII_II_883		"	;
8 		string	public		symbol =	"	RUSS_PFVII_II_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		778043912490154000000000000					;	
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
92 	//     < RUSS_PFVII_II_metadata_line_1_____NOVATEK_20231101 >									
93 	//        < x7Y9T70Qh1V1995PQfUv4dRwjq81CXF26w2hc1PJASW6p3TcPx4IppKhDQqA2ijJ >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000022989268.953012200000000000 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000000023142F >									
96 	//     < RUSS_PFVII_II_metadata_line_2_____NORTHGAS_20231101 >									
97 	//        < 4ek0s83g7lxr4y9zuUu8BdKA24p0iLHB55YR498t7qujo4v6T76aPP8sZOtXMGRK >									
98 	//        <  u =="0.000000000000000001" : ] 000000022989268.953012200000000000 ; 000000041404169.200045700000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000023142F3F2D81 >									
100 	//     < RUSS_PFVII_II_metadata_line_3_____SEVERENERGIA_20231101 >									
101 	//        < e7475G9445N4WzH98NBjvo38L623UI3xW9P4mp2H9UbkqoMvAaI8N95C8mr39WT9 >									
102 	//        <  u =="0.000000000000000001" : ] 000000041404169.200045700000000000 ; 000000057838164.407856300000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000003F2D81584108 >									
104 	//     < RUSS_PFVII_II_metadata_line_4_____NOVATEK_ARCTIC_LNG_1_20231101 >									
105 	//        < O860MX33w9764vdS806J9fL34E1z0dSf56H327AJ0cc03OtrOso1e3uid8PX1ri8 >									
106 	//        <  u =="0.000000000000000001" : ] 000000057838164.407856300000000000 ; 000000076760282.150541000000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000058410875207C >									
108 	//     < RUSS_PFVII_II_metadata_line_5_____NOVATEK_YURKHAROVNEFTEGAS_20231101 >									
109 	//        < 9H7PE804cEKL2KU1W9A82OgPOe50T2MSX5Chkd0yOeMJUU6p47GhTFh7kfeXuzw3 >									
110 	//        <  u =="0.000000000000000001" : ] 000000076760282.150541000000000000 ; 000000097661594.915855300000000000 ] >									
111 	//        < 0x000000000000000000000000000000000000000000000000000075207C95050F >									
112 	//     < RUSS_PFVII_II_metadata_line_6_____NOVATEK_GAS_POWER_GMBH_20231101 >									
113 	//        < W2b31CI3ga01R4435JI5Bo71gcF0xpsE17n4zYdbtH85y3372mh64954Lc6o2klh >									
114 	//        <  u =="0.000000000000000001" : ] 000000097661594.915855300000000000 ; 000000113067670.349603000000000000 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000000000095050FAC870F >									
116 	//     < RUSS_PFVII_II_metadata_line_7_____OOO_CHERNICHNOYE_20231101 >									
117 	//        < N82gGi75HgW2MGB6KU9sSeyEHd0ergDU60l4E7ZXy5XYN7nQh9O75zoLpzYeVdE5 >									
118 	//        <  u =="0.000000000000000001" : ] 000000113067670.349603000000000000 ; 000000129231279.367317000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000AC870FC530F8 >									
120 	//     < RUSS_PFVII_II_metadata_line_8_____OAO_TAMBEYNEFTEGAS_20231101 >									
121 	//        < L6g0P31ip2MVO1jQhsWqW17Scf8656wFLSb6pxYZ8kKqEr6F9EofZG8hDNiCRTJl >									
122 	//        <  u =="0.000000000000000001" : ] 000000129231279.367317000000000000 ; 000000151067129.854981000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000C530F8E68299 >									
124 	//     < RUSS_PFVII_II_metadata_line_9_____NOVATEK_TRANSERVICE_20231101 >									
125 	//        < plD49j3A3JN4TA282et8t8fB6R1dwGF9AQZp5yA0G0gLBTK8yZM8uTE6YBkd4js5 >									
126 	//        <  u =="0.000000000000000001" : ] 000000151067129.854981000000000000 ; 000000173355366.568301000000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000000E6829910884F1 >									
128 	//     < RUSS_PFVII_II_metadata_line_10_____NOVATEK_ARCTIC_LNG_2_20231101 >									
129 	//        < 6nH9m6E37x7dSTb86b8HUto0wb3PMg11Lk90XvT61CCPc06W0b3370Bofq26SOai >									
130 	//        <  u =="0.000000000000000001" : ] 000000173355366.568301000000000000 ; 000000189199316.967184000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000010884F1120B1FC >									
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
174 	//     < RUSS_PFVII_II_metadata_line_11_____YAMAL_LNG_20231101 >									
175 	//        < vyCw0K359Oc7jU7A5N7dc5OTf7Zk19P09jjj6A53sU12S5wlZZaK87W9488tQfFn >									
176 	//        <  u =="0.000000000000000001" : ] 000000189199316.967184000000000000 ; 000000206973387.601886000000000000 ] >									
177 	//        < 0x00000000000000000000000000000000000000000000000000120B1FC13BD0FB >									
178 	//     < RUSS_PFVII_II_metadata_line_12_____OOO_YARGEO_20231101 >									
179 	//        < 7S5r7nI6k4Yw07K4y68Bp6QN9s6zJ5Z630VRDLLVBgwZds48ej6Emxmqu5D4mh6h >									
180 	//        <  u =="0.000000000000000001" : ] 000000206973387.601886000000000000 ; 000000227457734.068768000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000013BD0FB15B12AD >									
182 	//     < RUSS_PFVII_II_metadata_line_13_____NOVATEK_ARCTIC_LNG_3_20231101 >									
183 	//        < Gj62W0OO4cyrbbGZ635bMk9idP8M3dtphHX3Meihqtr62GNV2SbRpC3Fp2YrjToK >									
184 	//        <  u =="0.000000000000000001" : ] 000000227457734.068768000000000000 ; 000000244049279.704095000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000015B12AD17463C0 >									
186 	//     < RUSS_PFVII_II_metadata_line_14_____TERNEFTEGAZ_JSC_20231101 >									
187 	//        < iOSoIkN4qhRY5L3P058kshGkFVrXp2I5fx1Hr8B60Qa057nY0TecDTXFEY62w71E >									
188 	//        <  u =="0.000000000000000001" : ] 000000244049279.704095000000000000 ; 000000260926468.565823000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000017463C018E2467 >									
190 	//     < RUSS_PFVII_II_metadata_line_15_____OOO_UNITEX_20231101 >									
191 	//        < CTU745L4IH94qCY15xrviIB0Fnbt4ltA1gE2fnw196Gg3q8oiznt85Hf84VI44Td >									
192 	//        <  u =="0.000000000000000001" : ] 000000260926468.565823000000000000 ; 000000283404048.607049000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000018E24671B070B5 >									
194 	//     < RUSS_PFVII_II_metadata_line_16_____NOVATEK_FINANCE_DESIGNATED_ACTIVITY_CO_20231101 >									
195 	//        < tbI53RpwpiYU8c117SgGy8W0L46moB37D5X495QFD35AonXd7Z8oR7gLTHR2Ox9E >									
196 	//        <  u =="0.000000000000000001" : ] 000000283404048.607049000000000000 ; 000000302617237.417189000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000001B070B51CDC1DC >									
198 	//     < RUSS_PFVII_II_metadata_line_17_____NOVATEK_EQUITY_CYPRUS_LIMITED_20231101 >									
199 	//        < 1gZ1xS0SPPvX8IxUkVjR2T3F9t7L3V3Z3Tx1B629gAm7ANH4b9lm6t1K7razPq07 >									
200 	//        <  u =="0.000000000000000001" : ] 000000302617237.417189000000000000 ; 000000321900655.505062000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000001CDC1DC1EB2E72 >									
202 	//     < RUSS_PFVII_II_metadata_line_18_____BLUE_GAZ_SP_ZOO_20231101 >									
203 	//        < Ff19P949906NZXSI5IqINRkqFTYF7lc8JPT9LK024K9P06em8cqvSlF3I6h72wVF >									
204 	//        <  u =="0.000000000000000001" : ] 000000321900655.505062000000000000 ; 000000345865943.656815000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000001EB2E7220FBFE2 >									
206 	//     < RUSS_PFVII_II_metadata_line_19_____NOVATEK_OVERSEAS_AG_20231101 >									
207 	//        < Ey9Md24W9QZWd027TzqRR8nygwy7112L264is1j4RjMKB1njoDZtCii7BbLXwAf9 >									
208 	//        <  u =="0.000000000000000001" : ] 000000345865943.656815000000000000 ; 000000361403098.936328000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000000020FBFE22277516 >									
210 	//     < RUSS_PFVII_II_metadata_line_20_____NOVATEK_POLSKA_SP_ZOO_20231101 >									
211 	//        < 2Uh18WP56sD2W1E29PV62kBVYW6SXHKJ55gSTmqQS07Sk1j70BcmJP86waCvDsb0 >									
212 	//        <  u =="0.000000000000000001" : ] 000000361403098.936328000000000000 ; 000000378014756.400302000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000002277516240CE04 >									
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
256 	//     < RUSS_PFVII_II_metadata_line_21_____CRYOGAS_VYSOTSK_CJSC_20231101 >									
257 	//        < Oy8rLNjB48WNsBqCT2v5KGFX3U2nrb4Y9wVHUYYa7iAQnLD1Z1j2kn49PECT6264 >									
258 	//        <  u =="0.000000000000000001" : ] 000000378014756.400302000000000000 ; 000000396189168.243172000000000000 ] >									
259 	//        < 0x00000000000000000000000000000000000000000000000000240CE0425C8965 >									
260 	//     < RUSS_PFVII_II_metadata_line_22_____OOO_PETRA_INVEST_M_20231101 >									
261 	//        < 1RP3B5O9H4Vdw3645ZHz5frXS34Te6BxKrazL8Rvy3Ye6db507BZE1fVxAqCZus7 >									
262 	//        <  u =="0.000000000000000001" : ] 000000396189168.243172000000000000 ; 000000417433387.616672000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000025C896527CF3EB >									
264 	//     < RUSS_PFVII_II_metadata_line_23_____ARCTICGAS_20231101 >									
265 	//        < y7xPyawu13NFC04NM9ZgHWzP5s26M5qq2yG7EFmjjZ38G3780f5lr1XlmY3lD5Lh >									
266 	//        <  u =="0.000000000000000001" : ] 000000417433387.616672000000000000 ; 000000439976522.429150000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000027CF3EB29F59D4 >									
268 	//     < RUSS_PFVII_II_metadata_line_24_____YARSALENEFTEGAZ_LLC_20231101 >									
269 	//        < 8x544796UA95K3Md3Ld1BgAB2fpM1dHT990X2A4p2A4Qa6X5m10Er5ZuA92a36k1 >									
270 	//        <  u =="0.000000000000000001" : ] 000000439976522.429150000000000000 ; 000000455941844.327622000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000029F59D42B7B648 >									
272 	//     < RUSS_PFVII_II_metadata_line_25_____NOVATEK_CHELYABINSK_20231101 >									
273 	//        < x1ViIJ15RcVt0Ii65pN6b41vydbuLxTGDa8bjFXaD0Xjc5J4E6v1R6Tl2i37e1cE >									
274 	//        <  u =="0.000000000000000001" : ] 000000455941844.327622000000000000 ; 000000477481509.074622000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002B7B6482D89437 >									
276 	//     < RUSS_PFVII_II_metadata_line_26_____EVROTEK_ZAO_20231101 >									
277 	//        < fTK1LkX4J019iFNT30JsRfCC20ZMa1RgziiYW1ul0EJK18G0KOy5A19x8b10sxZO >									
278 	//        <  u =="0.000000000000000001" : ] 000000477481509.074622000000000000 ; 000000494433257.824406000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000002D894372F271FE >									
280 	//     < RUSS_PFVII_II_metadata_line_27_____OOO_NOVASIB_20231101 >									
281 	//        < hE2yPfl4AR6GS2FtA9Hct35575r28Ug2A7NM70j90023gZqTCn8CNP0Y4NFvfz3g >									
282 	//        <  u =="0.000000000000000001" : ] 000000494433257.824406000000000000 ; 000000511600414.284012000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000002F271FE30CA3E9 >									
284 	//     < RUSS_PFVII_II_metadata_line_28_____NOVATEK_PERM_OOO_20231101 >									
285 	//        < oo37S0d9GnF1tgW284G97OYk3AFmHaik922R73fMLIV15079FQCOa56FKd75Lx3M >									
286 	//        <  u =="0.000000000000000001" : ] 000000511600414.284012000000000000 ; 000000531538874.774138000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000030CA3E932B105F >									
288 	//     < RUSS_PFVII_II_metadata_line_29_____NOVATEK_AZK_20231101 >									
289 	//        < P11o9SY818UxHO0H107R5xC06q6nO97mGoiGDZ6Myd11YeA0E45D3D1l8lHy0T0N >									
290 	//        <  u =="0.000000000000000001" : ] 000000531538874.774138000000000000 ; 000000548718308.337696000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000032B105F3454717 >									
292 	//     < RUSS_PFVII_II_metadata_line_30_____NOVATEK_NORTH_WEST_20231101 >									
293 	//        < 6X52126ASy92G5cHd74INjdbG6lcQ8g4WB1TMP36F15404qmqvs2LM9XSR986226 >									
294 	//        <  u =="0.000000000000000001" : ] 000000548718308.337696000000000000 ; 000000571499136.300507000000000000 ] >									
295 	//        < 0x00000000000000000000000000000000000000000000000000345471736809DA >									
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
338 	//     < RUSS_PFVII_II_metadata_line_31_____OOO_EKOPROMSTROY_20231101 >									
339 	//        < jrd2T8rVt28h3fLe2fioa6EpbLm4IsQwshkwIP8OXM7zda8n4J3344Py9qa423t6 >									
340 	//        <  u =="0.000000000000000001" : ] 000000571499136.300507000000000000 ; 000000588632564.027359000000000000 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000000000036809DA3822E98 >									
342 	//     < RUSS_PFVII_II_metadata_line_32_____OVERSEAS_EP_20231101 >									
343 	//        < 774yjKw95IAWFPrNwpAPVDW49p2SS1724DRALK2QKk0m3iN9tq0LPBsK89UJZu7R >									
344 	//        <  u =="0.000000000000000001" : ] 000000588632564.027359000000000000 ; 000000611421758.746862000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000003822E983A4F4A0 >									
346 	//     < RUSS_PFVII_II_metadata_line_33_____KOL_SKAYA_VERF_20231101 >									
347 	//        < DCeG2w7CPibK9SvqqGNY2pxj034T2cIuU07742u2Mmui75dVU2NbJ7CLvPjv4992 >									
348 	//        <  u =="0.000000000000000001" : ] 000000611421758.746862000000000000 ; 000000634281293.927036000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000003A4F4A03C7D621 >									
350 	//     < RUSS_PFVII_II_metadata_line_34_____TARKOSELENEFTEGAS_20231101 >									
351 	//        < bu9uQrU6hupXhI438TPa3vY7nGVmc0dRbKA4ugq4vsfegdH83YSnQJx71zMc9E34 >									
352 	//        <  u =="0.000000000000000001" : ] 000000634281293.927036000000000000 ; 000000649713128.577873000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000003C7D6213DF6231 >									
354 	//     < RUSS_PFVII_II_metadata_line_35_____TAMBEYNEFTEGAS_OAO_20231101 >									
355 	//        < 3Ug8Y4eoJHfRdXkOsWalD4S0864aCz33aVCOHT4jj8q3P6o17PgJF3NZE4EcL7hL >									
356 	//        <  u =="0.000000000000000001" : ] 000000649713128.577873000000000000 ; 000000673553326.148233000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000003DF6231403C2C5 >									
358 	//     < RUSS_PFVII_II_metadata_line_36_____OOO_NOVATEK_MOSCOW_REGION_20231101 >									
359 	//        < Nuj7zWUmOj778V2zKM686uJvMA8uGbqBgafbO5pDwxb2QMCw2L26eqX5b5ATp8Xc >									
360 	//        <  u =="0.000000000000000001" : ] 000000673553326.148233000000000000 ; 000000695557140.604008000000000000 ] >									
361 	//        < 0x00000000000000000000000000000000000000000000000000403C2C54255602 >									
362 	//     < RUSS_PFVII_II_metadata_line_37_____OILTECHPRODUKT_INVEST_20231101 >									
363 	//        < 34JnhK2hmLRRHON3i2CC42k44rac7gxzhjfkgtcbERDlQF1I0a8QTfCfZE1i6BYR >									
364 	//        <  u =="0.000000000000000001" : ] 000000695557140.604008000000000000 ; 000000712966419.227084000000000000 ] >									
365 	//        < 0x00000000000000000000000000000000000000000000000000425560243FE682 >									
366 	//     < RUSS_PFVII_II_metadata_line_38_____NOVATEK_UST_LUGA_20231101 >									
367 	//        < ZJc0T905Kz7uiooDVJ1T7o9070o7fsHH21i9blqS088clF1O6H1D4Fx3VNQmDQFb >									
368 	//        <  u =="0.000000000000000001" : ] 000000712966419.227084000000000000 ; 000000733464287.549380000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000043FE68245F2D7D >									
370 	//     < RUSS_PFVII_II_metadata_line_39_____NOVATEK_SCIENTIFIC_TECHNICAL_CENTER_20231101 >									
371 	//        < KhYWV4i18b8wBPsqppE4F0WSpbaFqOqBv2mS6z58i002DQHmJx9bUb6Gc2r83WtC >									
372 	//        <  u =="0.000000000000000001" : ] 000000733464287.549380000000000000 ; 000000757231120.390307000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000045F2D7D4837168 >									
374 	//     < RUSS_PFVII_II_metadata_line_40_____NOVATEK_GAS_POWER_ASIA_PTE_LTD_20231101 >									
375 	//        < 546EMBDOI7sZpu24mGrc55oYh437J4N2WUJHEs0VZEgS557ZxZxQ4AiFmfZR489O >									
376 	//        <  u =="0.000000000000000001" : ] 000000757231120.390307000000000000 ; 000000778043912.490154000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000048371684A33367 >									
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