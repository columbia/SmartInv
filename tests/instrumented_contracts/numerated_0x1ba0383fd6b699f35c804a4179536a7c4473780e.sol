1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	VEKSELBERG_Portfolio_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	VEKSELBERG_Portfolio_I_883		"	;
8 		string	public		symbol =	"	VEK883		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1248388771473920000000000000					;	
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
92 	//     < VEKSELBERG_Portfolio_I_metadata_line_1_____Octo_Telematics_20250515 >									
93 	//        < EKRSqS2yGRKDo97T05k3986AGvdb0cuGqseOzpqD07IgSzF7ouXqs1NCFZ80cpBe >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000023042028.993840800000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000037A0ED4 >									
96 	//     < VEKSELBERG_Portfolio_I_metadata_line_2_____Hevel_LLC_20250515 >									
97 	//        < s0ObBpti17J5WccIyF43X8F052pT036j93bDvxUA93mmAGoO6Y2IPutMHPM8HOkz >									
98 	//        <  u =="0.000000000000000001" : ] 000000023042028.993840800000000000 ; 000000052775685.551625400000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000037A0ED456471373 >									
100 	//     < VEKSELBERG_Portfolio_I_metadata_line_3_____Big_Pension_Fund_20250515 >									
101 	//        < RnJNF7P9op2hTh08s75v5Bq9U857D88T1Wny2c0AJKks6vI4R0C3k5Q071wl6p3f >									
102 	//        <  u =="0.000000000000000001" : ] 000000052775685.551625400000000000 ; 000000080573727.454863400000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000564713732B64E852B >									
104 	//     < VEKSELBERG_Portfolio_I_metadata_line_4_____Airports_Regions_20250515 >									
105 	//        < G9SzEctYK0xxHh8855259gU1ZIh523io7PXFoz1JHU9P2v976q6Mi57Jc3p94WsM >									
106 	//        <  u =="0.000000000000000001" : ] 000000080573727.454863400000000000 ; 000000120250863.429500000000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000002B64E852B4E34C5460 >									
108 	//     < VEKSELBERG_Portfolio_I_metadata_line_5_____Zoloto_Kamchatki_20250515 >									
109 	//        < oe66Ec43e69T6qs7JYUq56JF2DShp1b63KINtrVBE2zrpHtRsGjvjVC7M5NQ1YXz >									
110 	//        <  u =="0.000000000000000001" : ] 000000120250863.429500000000000000 ; 000000147530690.473885000000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000004E34C54604ECBCF485 >									
112 	//     < VEKSELBERG_Portfolio_I_metadata_line_6_____Ekaterinburg_non_Ferrous_Metals_Processing_Plant_20250515 >									
113 	//        < G3BfPZr3O1J6K45vh2qyJV8cv0nCy2rEscPukD888PI648RBxtlHN7NTr4CqH7cH >									
114 	//        <  u =="0.000000000000000001" : ] 000000147530690.473885000000000000 ; 000000176512024.769395000000000000 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000004ECBCF48550ED00309 >									
116 	//     < VEKSELBERG_Portfolio_I_metadata_line_7_____Rotec_20250515 >									
117 	//        < o3f7Qb5l187PpC8ZasDh8R7iPFU1D129GQDT85WOVw5i8f9sA1qpU1ueweFv4NDp >									
118 	//        <  u =="0.000000000000000001" : ] 000000176512024.769395000000000000 ; 000000211362058.583589000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000050ED00309816B8E20D >									
120 	//     < VEKSELBERG_Portfolio_I_metadata_line_8_____Ural_Turbine_Works_20250515 >									
121 	//        < l83YqZiQ9S6oO061lE1OuOU7v3R4cZ0A93P6AU67St9Cy9pyqr5GwwbT908dLEIe >									
122 	//        <  u =="0.000000000000000001" : ] 000000211362058.583589000000000000 ; 000000250124829.957700000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000816B8E20DBFD699807 >									
124 	//     < VEKSELBERG_Portfolio_I_metadata_line_9_____Invetsment_Fund_New_Europe_Real_Estate_Limited_20250515 >									
125 	//        < atITlU00O8Oc88G1ngL00C1G3zxX09YQ2U68UYUQ4fPhuUzIgUBKShM0566iO416 >									
126 	//        <  u =="0.000000000000000001" : ] 000000250124829.957700000000000000 ; 000000289836954.309925000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000BFD699807C00CC925C >									
128 	//     < VEKSELBERG_Portfolio_I_metadata_line_10_____Kamensk_Uralsky_non_Ferrous_Metals_Working_Plant_20250515 >									
129 	//        < PDdWzd4eadV6VBNiG2DFh76hDsOlQ78SvSSIe4q44N0MgR8CQ51BqF36bwQHZt63 >									
130 	//        <  u =="0.000000000000000001" : ] 000000289836954.309925000000000000 ; 000000314241946.682258000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000C00CC925CC8B19E052 >									
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
174 	//     < VEKSELBERG_Portfolio_I_metadata_line_11_____Renova_Management_20250515 >									
175 	//        < 4i7rfOM3r1FPPs4WEp0L3FI07kl7zQNMUtkJpfjep3JJ2fSe9NuIq1is0R8l2Wd6 >									
176 	//        <  u =="0.000000000000000001" : ] 000000314241946.682258000000000000 ; 000000341440588.392048000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000C8B19E052C95A3ECBC >									
178 	//     < VEKSELBERG_Portfolio_I_metadata_line_12_____Oerlikon_20250515 >									
179 	//        < xnR1X1x65V8ny3i0uTbe15YH791T6TxNrt81h7kXY9d0U61p9DI0M47ZpdN04IE2 >									
180 	//        <  u =="0.000000000000000001" : ] 000000341440588.392048000000000000 ; 000000379744181.328077000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000C95A3ECBCCA5EAC970 >									
182 	//     < VEKSELBERG_Portfolio_I_metadata_line_13_____Sulzer_20250515 >									
183 	//        < lG8xa5QK97iN837vZjHKCD9N30SHsyujt349K11vf8O67kUVGChwNfPC3z3WSwz6 >									
184 	//        <  u =="0.000000000000000001" : ] 000000379744181.328077000000000000 ; 000000404968043.601462000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000CA5EAC970CFBA12F64 >									
186 	//     < VEKSELBERG_Portfolio_I_metadata_line_14_____Akado_20250515 >									
187 	//        < q0t03rXWc09kJE187kGm4ht1aYfBIQ3zB7bYbHE74uT6U0SCevFQhAqV7wivG13m >									
188 	//        <  u =="0.000000000000000001" : ] 000000404968043.601462000000000000 ; 000000443413207.517843000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000CFBA12F64D359422C8 >									
190 	//     < VEKSELBERG_Portfolio_I_metadata_line_15_____Akado_Telecom_20250515 >									
191 	//        < BHWzvc1GqoDemvGkUFEs1wCXEa368MDxUqcTWBhuzsZmR3nHF075Tsl47852Y119 >									
192 	//        <  u =="0.000000000000000001" : ] 000000443413207.517843000000000000 ; 000000479267729.497339000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000D359422C81191394DA5 >									
194 	//     < VEKSELBERG_Portfolio_I_metadata_line_16_____Orgsyntes_Group_20250515 >									
195 	//        < v6qRni01Ku0L6pC01A2u6P5B13O06O0rR6oTT6dJH0H2zWnMvP5EwlbinNP76FNe >									
196 	//        <  u =="0.000000000000000001" : ] 000000479267729.497339000000000000 ; 000000513810214.854941000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000001191394DA5119E78BA38 >									
198 	//     < VEKSELBERG_Portfolio_I_metadata_line_17_____Khimprom_Novocheboksarsk_20250515 >									
199 	//        < M2fUsdLXvIj3PutiUw3Rj5uB8iROZx0G3mcP3L4H8UZ28m58u8u316czB8xRqlh4 >									
200 	//        <  u =="0.000000000000000001" : ] 000000513810214.854941000000000000 ; 000000541921460.861913000000000000 ] >									
201 	//        < 0x00000000000000000000000000000000000000000000119E78BA3811A5A651C7 >									
202 	//     < VEKSELBERG_Portfolio_I_metadata_line_18_____Percarbonate_20250515 >									
203 	//        < n02txCFf6yf6o2YH0Xy2q7G2B4HzHo6Vm74gOEfeqd0u01t4yYWk31M5Duxd723y >									
204 	//        <  u =="0.000000000000000001" : ] 000000541921460.861913000000000000 ; 000000565570928.010199000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000011A5A651C711A7337AA6 >									
206 	//     < VEKSELBERG_Portfolio_I_metadata_line_19_____Kortros_20250515 >									
207 	//        < 0d6xgPE0HkY6Fg4Q7cV1Na1RB51ivlpdk7V66AJVaBc5wM6oesZDIQFfe0LfC72r >									
208 	//        <  u =="0.000000000000000001" : ] 000000565570928.010199000000000000 ; 000000589235868.702825000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000011A7337AA611A80D764A >									
210 	//     < VEKSELBERG_Portfolio_I_metadata_line_20_____Academia_City_20250515 >									
211 	//        < olmhpjEKJl5qk1CSVkBy2wB45UULhes4n6g3OAr0Cz8HDv29RO6a3jC2A14rf9F5 >									
212 	//        <  u =="0.000000000000000001" : ] 000000589235868.702825000000000000 ; 000000623079382.960559000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000011A80D764A11A9E0DEC1 >									
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
256 	//     < VEKSELBERG_Portfolio_I_metadata_line_21_____Energoprom_Group_20250515 >									
257 	//        < 2ftJL48ky9S2ig80MFR5GeH92a66iccBj1MdRWU28bR8i8819RE81eUTim0QR5h4 >									
258 	//        <  u =="0.000000000000000001" : ] 000000623079382.960559000000000000 ; 000000655160100.266606000000000000 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000011A9E0DEC11337C233DB >									
260 	//     < VEKSELBERG_Portfolio_I_metadata_line_22_____Novocherkassk_Electrode_Plant_20250515 >									
261 	//        < 584t7Eoo72PukQUp608h5J2vZJm13Q89k4pO9C3tpU6P7pX600dx0EZ3n9e962rz >									
262 	//        <  u =="0.000000000000000001" : ] 000000655160100.266606000000000000 ; 000000678795138.435003000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000001337C233DB16FC133A49 >									
264 	//     < VEKSELBERG_Portfolio_I_metadata_line_23_____Novosibirsk_Electrode_Plant_20250515 >									
265 	//        < 8SVVxy322965mRt5I768r0A8412Q55Fdl836Uu6tmjquhZz6qS9i597qCNx8V92C >									
266 	//        <  u =="0.000000000000000001" : ] 000000678795138.435003000000000000 ; 000000718084387.936806000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000016FC133A4916FCE8C776 >									
268 	//     < VEKSELBERG_Portfolio_I_metadata_line_24_____Chelyabinsk_Electrode_Plant_20250515 >									
269 	//        < h1D21a1cOQ1gJyAZ97ETT2a7BkE07GPkA98b7ujAJ1R8OIG1G6B60pWSI0mxaqKl >									
270 	//        <  u =="0.000000000000000001" : ] 000000718084387.936806000000000000 ; 000000751142944.299394000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000016FCE8C77616FE4B3578 >									
272 	//     < VEKSELBERG_Portfolio_I_metadata_line_25_____Columbus_Nova_20250515 >									
273 	//        < lUtolol1xKrSOD4qYCXZwla520072i5flx6C10SFi48BKad65surUBT1TZ6kfsmC >									
274 	//        <  u =="0.000000000000000001" : ] 000000751142944.299394000000000000 ; 000000779727170.939986000000000000 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000016FE4B357817094B7C8A >									
276 	//     < VEKSELBERG_Portfolio_I_metadata_line_26_____Irkutskcable_Kirscable_20250515 >									
277 	//        < 60fPi84eH99S8rmSnH84064hX4qoRO090Pb3dRl0B34AIfDr0WpNU36BqKs7dHtV >									
278 	//        <  u =="0.000000000000000001" : ] 000000779727170.939986000000000000 ; 000000802191417.439658000000000000 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000017094B7C8A170A9FCB93 >									
280 	//     < VEKSELBERG_Portfolio_I_metadata_line_27_____Kamensk_Uralsky_Metallurgical_Works_20250515 >									
281 	//        < aJCdZhjnMcCpWQ9u3q9GKowac415c4103e8Rp58kDABKktO57TBBo3c2043Dhk88 >									
282 	//        <  u =="0.000000000000000001" : ] 000000802191417.439658000000000000 ; 000000832978406.470545000000000000 ] >									
283 	//        < 0x00000000000000000000000000000000000000000000170A9FCB931710216274 >									
284 	//     < VEKSELBERG_Portfolio_I_metadata_line_28_____United_Manganese_Kalahari_20250515 >									
285 	//        < EJ3TXbzt6dECQmY0TYZ5MF0dng3r0M25yh0xp98tM67g9C1O40vNZWn9Tmvd2Rw2 >									
286 	//        <  u =="0.000000000000000001" : ] 000000832978406.470545000000000000 ; 000000856794111.031656000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000017102162741710DAFC71 >									
288 	//     < VEKSELBERG_Portfolio_I_metadata_line_29_____Bank_Cyprus_Group_20250515 >									
289 	//        < dgKGtjpB1O456W07rY0KGMqNQQmV06P7QY4AGBjnsO4P1O4u9AqvfmHRMlI25A8m >									
290 	//        <  u =="0.000000000000000001" : ] 000000856794111.031656000000000000 ; 000000896058416.182399000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000001710DAFC71171F5B98B4 >									
292 	//     < VEKSELBERG_Portfolio_I_metadata_line_30_____Skolkovo_Foundation_20250515 >									
293 	//        < 4RP21423cu16GNKtLwmY9n9l7T9rNA232959oko1Pb4kZMyvRI56A6GPLhsJqb3w >									
294 	//        <  u =="0.000000000000000001" : ] 000000896058416.182399000000000000 ; 000000934008155.568507000000000000 ] >									
295 	//        < 0x00000000000000000000000000000000000000000000171F5B98B41B22EC3D9C >									
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
338 	//     < VEKSELBERG_Portfolio_I_metadata_line_31_____Ascometal_SAS_20250515 >									
339 	//        < 40Oo3UTarPPlhoanLXf4UNpl81pYgu52ehXkiWhNfpt4YwT15ABO8985eU1UdDH5 >									
340 	//        <  u =="0.000000000000000001" : ] 000000934008155.568507000000000000 ; 000000966287331.905784000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000001B22EC3D9C1E0D333C03 >									
342 	//     < VEKSELBERG_Portfolio_I_metadata_line_32_____Ascometal_gmbh_20250515 >									
343 	//        < Vk07wp2L3GDCkXX53DRXlL3z2h4KiOCWzoDK74jlGh8Xxw4eA36ibZsw3jCK8hK2 >									
344 	//        <  u =="0.000000000000000001" : ] 000000966287331.905784000000000000 ; 000000989734609.846814000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000001E0D333C031E29356C3E >									
346 	//     < VEKSELBERG_Portfolio_I_metadata_line_33_____Schmolz_Bickenbach_20250515 >									
347 	//        < L8bI4Hlk73H8ezT04mp01aVi60QnSvV967H288TV67k2WR773XwaNOTI96T493We >									
348 	//        <  u =="0.000000000000000001" : ] 000000989734609.846814000000000000 ; 000001015241645.880770000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000001E29356C3E1E2A15F705 >									
350 	//     < VEKSELBERG_Portfolio_I_metadata_line_34_____Deutsche_Edelstahlwerke_GmbH_20250515 >									
351 	//        < 1AS7n652WZ78qnEbmHZGSPWMwyO3U1A121S95OTeDmRvhHnS8B9sGFB17074e85R >									
352 	//        <  u =="0.000000000000000001" : ] 000001015241645.880770000000000000 ; 000001043255370.431440000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000001E2A15F7051E37D2E629 >									
354 	//     < VEKSELBERG_Portfolio_I_metadata_line_35_____A_Finkl_Sons_Steel_20250515 >									
355 	//        < 8nb511JJ1JNOE9ACrR2DhPjAwv67c5wJOiDDJ8Go4Bty03Y7DbFU6Om9Oz5pTR0C >									
356 	//        <  u =="0.000000000000000001" : ] 000001043255370.431440000000000000 ; 000001073611986.757450000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000001E37D2E62921F0EF1D76 >									
358 	//     < VEKSELBERG_Portfolio_I_metadata_line_36_____dr._wilhelm_mertens_gmbh_20250515 >									
359 	//        < A85B453pTrw5yeEeUyv05A185e92Ywd7103RrvOot9YTs9jVa5s1CypZtaPxgK3I >									
360 	//        <  u =="0.000000000000000001" : ] 000001073611986.757450000000000000 ; 000001107231909.406060000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000021F0EF1D7623C829D434 >									
362 	//     < VEKSELBERG_Portfolio_I_metadata_line_37_____stemcor_flachstahl_gmbh_20250515 >									
363 	//        < cvPGEhq5TR3R90sQo1rDoTPWwhNyg8eniC61hQ3y72PLZBuNOtV6fp3YiYPIDqi2 >									
364 	//        <  u =="0.000000000000000001" : ] 000001107231909.406060000000000000 ; 000001146506892.993330000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000023C829D43423C95BAE77 >									
366 	//     < VEKSELBERG_Portfolio_I_metadata_line_38_____dk_automotive_ag_20250515 >									
367 	//        < pE0YvaeM29u3rcnZfcLT2ezX1IRu3tBBxtC2Wu4h18Q1n0f0y5DoNM9op6O9nd2u >									
368 	//        <  u =="0.000000000000000001" : ] 000001146506892.993330000000000000 ; 000001182514322.750160000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000023C95BAE7724A65522E8 >									
370 	//     < VEKSELBERG_Portfolio_I_metadata_line_39_____deutsche_edelstahlwerke_härterei_technik_gmbh_20250515 >									
371 	//        < T1HkhBTC8b4teSRFVG59x5S5BK7LI6IDOoVTM4oZXNJ5P1W0W834dcXo7E9Yv9nN >									
372 	//        <  u =="0.000000000000000001" : ] 000001182514322.750160000000000000 ; 000001219191805.625200000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000024A65522E824C0198909 >									
374 	//     < VEKSELBERG_Portfolio_I_metadata_line_40_____schmolz_bickenbach_polska_spzoo_20250515 >									
375 	//        < 2RYC8w4jiUGR2u3YzcqcubQZ2X88b6B76hP6MLuE68WUxsPAbpIknzraqW15lk40 >									
376 	//        <  u =="0.000000000000000001" : ] 000001219191805.625200000000000000 ; 000001248388771.473920000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000024C019890924C8475D18 >									
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