1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	FGRE_Portfolio_II_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	FGRE_Portfolio_II_883		"	;
8 		string	public		symbol =	"	FGRE883II		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		27616600125087200000000000000					;	
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
92 	//     < FGRE_Portfolio_II_metadata_line_1_____Caisse_Centrale_de_Reassurance_20580515 >									
93 	//        < qJH456shAVxlEf54A8FO7cJo4E9w0Xc1Rte2EJ1u73Z9Vw3pu1ne03ZgIn2o3E8m >									
94 	//        < 1E-018 limites [ 1E-018 ; 71629097,3929053 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000006D4C1E >									
96 	//     < FGRE_Portfolio_II_metadata_line_2_____CCR_FGRE_Fonds_de_Garantie_des_Risques_liés_a_l_Epandage_des_Boues_d_Epuration_Urbaines_et_Industrielles_i_20580515 >									
97 	//        < 79C907463mh7j2sL5iKHJMsFUzIWeh7K4Pyy71t11aRLJ3cj2Z9wDAn6r2jz05g6 >									
98 	//        < 1E-018 limites [ 71629097,3929053 ; 219337972,168712 ] >									
99 	//        < 0x0000000000000000000000000000000000000000000000000006D4C1E14EAEE5 >									
100 	//     < FGRE_Portfolio_II_metadata_line_3_____CCR_FGRE_Fonds_de_Garantie_des_Risques_liés_a_l_Epandage_des_Boues_d_Epuration_Urbaines_et_Industrielles_ii_20580515 >									
101 	//        < 1DVsuw99psx9wE360Uz9fVsaaF33dLj6FP4Qt5D4g0K6m3Y9e1BmD0R6Z95zkuLZ >									
102 	//        < 1E-018 limites [ 219337972,168712 ; 1435018837,45658 ] >									
103 	//        < 0x0000000000000000000000000000000000000000000000000014EAEE588DAA3C >									
104 	//     < FGRE_Portfolio_II_metadata_line_4_____FGRE__Cap_default_20580515 >									
105 	//        < eop5ro1ow1CAbTF1VGwIZFLLk77c6EuCYQ6zN6r71AW8JjKv5tv99G0i573BFOIM >									
106 	//        < 1E-018 limites [ 1435018837,45658 ; 1526318567,62157 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000000088DAA3C918FA31 >									
108 	//     < FGRE_Portfolio_II_metadata_line_5_____FGRE__Cap_lim_20580515 >									
109 	//        < x3Phom69re0vLi72J8vbk2W5097YkKW8VdPSiGXrKQmgxwpM5w61iF55xru2b5y5 >									
110 	//        < 1E-018 limites [ 1526318567,62157 ; 2825094805,14306 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000918FA3110D6C0A9 >									
112 	//     < FGRE_Portfolio_II_metadata_line_6_____FGRE__Cap_ill_20580515 >									
113 	//        < VTi58x8VQ52xnxT150N4P2z57zS25Gm8BcnMqH58e9i1DXF95hIEw49f9f1S9o94 >									
114 	//        < 1E-018 limites [ 2825094805,14306 ; 3323729939,28347 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000000010D6C0A913CF9C02 >									
116 	//     < FGRE_Portfolio_II_metadata_line_7_____FGRE__Tre_Cap_1_20580515 >									
117 	//        < 6J26UJqpL2eG9J17Id44fw675tiuAJ7090WMK8AVH1N2p9rI34r8An6SKgxo6GQd >									
118 	//        < 1E-018 limites [ 3323729939,28347 ; 3441598939,90094 ] >									
119 	//        < 0x00000000000000000000000000000000000000000000000013CF9C0214837696 >									
120 	//     < FGRE_Portfolio_II_metadata_line_8_____FGRE__Tre_Cap_2_20580515 >									
121 	//        < Q3S67TN6BpQcKXiWjTZEN10un2ftqh5t7tlf22Y8mYVKn78S0b7767C99LOv8Ao5 >									
122 	//        < 1E-018 limites [ 3441598939,90094 ; 3531740815,47801 ] >									
123 	//        < 0x00000000000000000000000000000000000000000000000014837696150D0242 >									
124 	//     < FGRE_Portfolio_II_metadata_line_9_____FGRE__Fac_Cap_1_20580515 >									
125 	//        < YdKJcopsJf3eBYyM9r69S2s3Cv4C23ovzE44g6b1eN01tKzKxeJ5xm9QW14fa1Fu >									
126 	//        < 1E-018 limites [ 3531740815,47801 ; 3635901445,63885 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000150D024215ABF201 >									
128 	//     < FGRE_Portfolio_II_metadata_line_10_____FGRE__Fac_Cap_2_20580515 >									
129 	//        < 6ym5BL1Sexqs8Kx29LGGZ5e77uIz2ACQcJ4I8SMnfWj544H1FD893l257sUhmF8K >									
130 	//        < 1E-018 limites [ 3635901445,63885 ; 4568661469,69768 ] >									
131 	//        < 0x00000000000000000000000000000000000000000000000015ABF2011B3B3963 >									
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
174 	//     < FGRE_Portfolio_II_metadata_line_11_____FGRE__Cap_default_iii_origin_p_C_default_20580515 >									
175 	//        < 0XKML8TV7B9odO4D5Gb1Fd5m4754EsA65x4oxGi8hcCr5t2ij4V9b8in4VzP73sz >									
176 	//        < 1E-018 limites [ 4568661469,69768 ; 5629055858,9209 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000001B3B3963218D41F2 >									
178 	//     < FGRE_Portfolio_II_metadata_line_12_____FGRE__Cap_default_iii_origin_p_iii_default_20580515 >									
179 	//        < 0jkRj2MmTwQAl2A6V5i6xold1kcqdBH6423M38JNV8F8FwFiheyh98pCiMb03431 >									
180 	//        < 1E-018 limites [ 5629055858,9209 ; 6049295441,87584 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000218D41F2240E7E08 >									
182 	//     < FGRE_Portfolio_II_metadata_line_13_____FGRE__Cap_lim_iii_origin_p_C_default_20580515 >									
183 	//        < z09v8iK7s858Oco1v8d45O06GOid4O716s44txbfto66kP2Y6N0D2ywfGI7nWs87 >									
184 	//        < 1E-018 limites [ 6049295441,87584 ; 6895400277,11564 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000240E7E0829198BBC >									
186 	//     < FGRE_Portfolio_II_metadata_line_14_____FGRE__Cap_lim_iii_origin_p_iii_default_20580515 >									
187 	//        < aoj358690I3zh8Tq4FAnpfB5lQSB95r472on527a8OR4dG61WtbBG741DFAqq4Zc >									
188 	//        < 1E-018 limites [ 6895400277,11564 ; 8328045361,08831 ] >									
189 	//        < 0x00000000000000000000000000000000000000000000000029198BBC31A396B8 >									
190 	//     < FGRE_Portfolio_II_metadata_line_15_____FGRE__Cap_ill_iii_origin_p_C_default_20580515 >									
191 	//        < QdX9Km1HXjGJgYqo1xqla46W43FlR199LF09o1WTM6AD89OiPYK4eoLg4DcYE1o2 >									
192 	//        < 1E-018 limites [ 8328045361,08831 ; 9439303492,65989 ] >									
193 	//        < 0x00000000000000000000000000000000000000000000000031A396B838433BED >									
194 	//     < FGRE_Portfolio_II_metadata_line_16_____FGRE__Cap_ill_iii_origin_p_iii_default_20580515 >									
195 	//        < jv0Z4Y251GGad1lh34PRBKwl7lmUwY0MOL8TiV5o7U5X9s4FqAo4j7bh618ZALY3 >									
196 	//        < 1E-018 limites [ 9439303492,65989 ; 10541590279,1838 ] >									
197 	//        < 0x00000000000000000000000000000000000000000000000038433BED3ED530B4 >									
198 	//     < FGRE_Portfolio_II_metadata_line_17_____FGRE__Tre_Cap_3_20580515 >									
199 	//        < FD235ETy6VjNHv8QP8qb5y6Z5FI08g2eZ1o0sOXV7aNmM3d2lA24Y25ZAlXLam74 >									
200 	//        < 1E-018 limites [ 10541590279,1838 ; 10857051123,6721 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000003ED530B440B68B98 >									
202 	//     < FGRE_Portfolio_II_metadata_line_18_____FGRE__Tre_Cap_4_20580515 >									
203 	//        < LN59S23J8jkkrV41l9kpv5vW5PBi9V6tL97lxpC42549LtHbkX54FuNVdw4q63It >									
204 	//        < 1E-018 limites [ 10857051123,6721 ; 11060046599,4754 ] >									
205 	//        < 0x00000000000000000000000000000000000000000000000040B68B9841EC4AB4 >									
206 	//     < FGRE_Portfolio_II_metadata_line_19_____FGRE__Fac_Cap_3_20580515 >									
207 	//        < Uf6R2KE26Q5hwp0XQ92bwb1VQYa97f7atC1KNZA236aF97ImaV27Ty5o4cx2S7bv >									
208 	//        < 1E-018 limites [ 11060046599,4754 ; 11179474573,7217 ] >									
209 	//        < 0x00000000000000000000000000000000000000000000000041EC4AB442A28641 >									
210 	//     < FGRE_Portfolio_II_metadata_line_20_____FGRE__Fac_Cap_4_20580515 >									
211 	//        < 6e0Pzp56Ugq2hyL4S840hL9HKb913bZ9m0dd8kslj9X7pe9vCrUEWVvI1eT55Ynt >									
212 	//        < 1E-018 limites [ 11179474573,7217 ; 12150811562,5234 ] >									
213 	//        < 0x00000000000000000000000000000000000000000000000042A28641486CAAC4 >									
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
256 	//     < FGRE_Portfolio_II_metadata_line_21_____FGRE__C_default_20580515 >									
257 	//        < Ux3NWNppH1RuPk0N75wDL33WBBmsb0ffR64W0h0u005u8ldtjqj07Z7vpK62k9uD >									
258 	//        < 1E-018 limites [ 12150811562,5234 ; 12878870143,632 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000486CAAC44CC398A6 >									
260 	//     < FGRE_Portfolio_II_metadata_line_22_____FGRE__Tre_C_1_20580515 >									
261 	//        < 6N3OVIrL4k076t3085DB79v19XZO2395hw51POg8A21A25UG0ziW5nrrl0wnzZ8m >									
262 	//        < 1E-018 limites [ 12878870143,632 ; 13197987234,1808 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000004CC398A64EAA87C3 >									
264 	//     < FGRE_Portfolio_II_metadata_line_23_____FGRE__Tre_C_2_20580515 >									
265 	//        < 47k50q7V0387qtMgp03OLDR59DABiry3jngMT0nbjbrmLo38UkjgH151gyL8vOtC >									
266 	//        < 1E-018 limites [ 13197987234,1808 ; 13647709269,9694 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000004EAA87C35158C06F >									
268 	//     < FGRE_Portfolio_II_metadata_line_24_____FGRE__Fac_C_1_20580515 >									
269 	//        < awA7jant85id1fKnunDFfi6Q8vZcG65LSegkV4p9ONQow434TU33YOsfxmDi9Xyk >									
270 	//        < 1E-018 limites [ 13647709269,9694 ; 13850646362,7421 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000005158C06F528E68BC >									
272 	//     < FGRE_Portfolio_II_metadata_line_25_____FGRE__Fac_C_2_20580515 >									
273 	//        < ta2ofDGjv9oI2kQw4v9NQNdJnhd6a8J6Hy68M2q79w5smV2BK6Otzs3mwCo2mWph >									
274 	//        < 1E-018 limites [ 13850646362,7421 ; 14018441531,3877 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000528E68BC538E71B9 >									
276 	//     < FGRE_Portfolio_II_metadata_line_26_____FGRE__IV_default_20580515 >									
277 	//        < QFc3Cfb208aATDv3WPF57w5ne7cNZca6i0a1U9sx6z32nKEwb3R0YRKNkF3GP955 >									
278 	//        < 1E-018 limites [ 14018441531,3877 ; 15707235010,5298 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000538E71B95D9F56AD >									
280 	//     < FGRE_Portfolio_II_metadata_line_27_____FGRE__Tre_iv_1_20580515 >									
281 	//        < qG3XDlAlmd69Y6kE5t52MEn6jrnAMvu2Z9zS42p04G20Wtcg28egynj8ozipno91 >									
282 	//        < 1E-018 limites [ 15707235010,5298 ; 15801136464,6251 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000005D9F56AD5E2E9EEE >									
284 	//     < FGRE_Portfolio_II_metadata_line_28_____FGRE__Tre_iv_2_20580515 >									
285 	//        < AD8TthMkjUn13ob1SOgcAp1EfQi92v85DvH1oz6m4uJZ439l2CluEvGHJ45nd1pm >									
286 	//        < 1E-018 limites [ 15801136464,6251 ; 18510047623,3186 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000005E2E9EEE6E54175A >									
288 	//     < FGRE_Portfolio_II_metadata_line_29_____FGRE__Fac_iv_1_20580515 >									
289 	//        < 6j7RiXl20TVGz37sg7vm23k7noG3d93k9cYCW7klrF4ASJ9H3A2C0elD7kqfZBz1 >									
290 	//        < 1E-018 limites [ 18510047623,3186 ; 19462887700,4856 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000006E54175A74020282 >									
292 	//     < FGRE_Portfolio_II_metadata_line_30_____FGRE__Fac_iv_2_20580515 >									
293 	//        < s1q9pe2xpoz2kD94LEuO29W7i9hrT2EGR09Fu7251La3Q96pMp0b9w0ZWui2bJsI >									
294 	//        < 1E-018 limites [ 19462887700,4856 ; 19651486962,9987 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000740202827521CA18 >									
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
338 	//     < FGRE_Portfolio_II_metadata_line_31_____FGRE__Cx_default_20580515 >									
339 	//        < vaJ191Tj2pk8wc60nH8ztlcSYF11GsQ39o9eoLFXPO368JKrTE79Z9S9AQbkhof0 >									
340 	//        < 1E-018 limites [ 19651486962,9987 ; 20586488342,4875 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000000007521CA187AB47D02 >									
342 	//     < FGRE_Portfolio_II_metadata_line_32_____FGRE__Tre_Cx_1_20580515 >									
343 	//        < 0TeI5ECMIJcje19mNR7nLW7oAp04UpS3224waK6VCqaMjH9ZMHQ3YmGMrxV009M3 >									
344 	//        < 1E-018 limites [ 20586488342,4875 ; 20691762282,7993 ] >									
345 	//        < 0x0000000000000000000000000000000000000000000000007AB47D027B551FA4 >									
346 	//     < FGRE_Portfolio_II_metadata_line_33_____FGRE__Tre_Cx_2_20580515 >									
347 	//        < L781lq0mdkA6c7V3M12wB236y2Gjd47o67FKYqD2QZ4Y3u75pI0BN5Gn87bCplaJ >									
348 	//        < 1E-018 limites [ 20691762282,7993 ; 20915421507,0282 ] >									
349 	//        < 0x0000000000000000000000000000000000000000000000007B551FA47CAA6687 >									
350 	//     < FGRE_Portfolio_II_metadata_line_34_____FGRE__Fac_Cx_1_20580515 >									
351 	//        < N8GF9znNSkfZP0m5nX32isqojwVb31EC69Jc3B6K7Z6O1OQz2DTXEfu1tov652e4 >									
352 	//        < 1E-018 limites [ 20915421507,0282 ; 21080512678,7107 ] >									
353 	//        < 0x0000000000000000000000000000000000000000000000007CAA66877DA64F44 >									
354 	//     < FGRE_Portfolio_II_metadata_line_35_____FGRE__Fac_Cx_2_20580515 >									
355 	//        < UW8wwNjDVF6Xh2G55b5k6U4Fr8FFAFC5xrJk3I13KKZQJQHs62yMy6m2n498DV97 >									
356 	//        < 1E-018 limites [ 21080512678,7107 ; 22322567851,328 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000007DA64F44850D8911 >									
358 	//     < FGRE_Portfolio_II_metadata_line_36_____FGRE__VIII_default_20580515 >									
359 	//        < yKz9Wt4X7u5mMNlesqGUJ0s41Ss9u289oDB1Iq5w6U1J4ALx307nw2zE7Fm5SUKU >									
360 	//        < 1E-018 limites [ 22322567851,328 ;  ] >									
361 	//        < 0x000000000000000000000000000000000000000000000000850D89118B15375D >									
362 	//     < FGRE_Portfolio_II_metadata_line_37_____FGRE__Tre_viii_1_20580515 >									
363 	//        < U5H67WN5b3pXnXcnXRJ668qdKjf3q8N12rfn681fyxj1Rcr1P0fPmSUC64VJnWs4 >									
364 	//        < 1E-018 limites [ 23334234534,5793 ; 24872776038,9251 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000008B15375D9440D824 >									
366 	//     < FGRE_Portfolio_II_metadata_line_38_____FGRE__Tre_viii_2_20580515 >									
367 	//        < nG8OlLfN7KxHjEP0eHKYJWXxv5w7f6eWs2gX3X0n4073OFGNB7qz9g1A840Q7O7K >									
368 	//        < 1E-018 limites [ 24872776038,9251 ; 26252611921,4392 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000009440D8249C7A4E88 >									
370 	//     < FGRE_Portfolio_II_metadata_line_39_____FGRE__Fac_viii_1_20580515 >									
371 	//        < 9VkF505j12DzLwmihDcN6xB2WE38qFK1lUt427svq0OJe0kTX7fY2134rMIXKuan >									
372 	//        < 1E-018 limites [ 26252611921,4392 ; 27184179220,2758 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000009C7A4E88A207C402 >									
374 	//     < FGRE_Portfolio_II_metadata_line_40_____FGRE__Fac_viii_2_20580515 >									
375 	//        < b9k1tF01h18x578hIwRE9PeQaOhAaFonbku7tQJ406E7ZDq89yvaSNlX6Vii4922 >									
376 	//        < 1E-018 limites [ 27184179220,2758 ; 27616600125,0872 ] >									
377 	//        < 0x000000000000000000000000000000000000000000000000A207C402A49B966D >									
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