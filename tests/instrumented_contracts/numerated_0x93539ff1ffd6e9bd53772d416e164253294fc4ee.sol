1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	BANK_II_PFIII_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	BANK_II_PFIII_883		"	;
8 		string	public		symbol =	"	BANK_II_PFIII_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		439095964093327000000000000					;	
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
92 	//     < BANK_II_PFIII_metadata_line_1_____GEBR_ALEXANDER_20260508 >									
93 	//        < C9tb9c71ba7Y5cmJEVu76J3420d1n78Vz93f33oh83z80aV5RS6W2mbQW35hH917 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000010729874.909194700000000000 ] >									
95 	//        < 0x0000000000000000000000000000000000000000000000000000000000105F5B >									
96 	//     < BANK_II_PFIII_metadata_line_2_____SCHOTT _GLASWERKE_AG_20260508 >									
97 	//        < Vd7M6J4Yoqptyy4U48Ar4P5LXZzRKdxQN3i07K4NW0wH8qxr3c81Mnh0BtXXp00P >									
98 	//        <  u =="0.000000000000000001" : ] 000000010729874.909194700000000000 ; 000000021863238.519883400000000000 ] >									
99 	//        < 0x0000000000000000000000000000000000000000000000000000105F5B215C54 >									
100 	//     < BANK_II_PFIII_metadata_line_3_____MAINZ_HAUPTBAHNHOF_20260508 >									
101 	//        < 83A9b1i0oRfDsZG4vRMl3Dknq6J1XTOSuI7QGKfEz4xP98c2BRY436SNM4sU6R1H >									
102 	//        <  u =="0.000000000000000001" : ] 000000021863238.519883400000000000 ; 000000032910883.225757900000000000 ] >									
103 	//        < 0x0000000000000000000000000000000000000000000000000000215C543237D0 >									
104 	//     < BANK_II_PFIII_metadata_line_4_____PORT_DOUANIER_ET_FLUVIAL_DE_MAYENCE_20260508 >									
105 	//        < PjMxpu8yFDsYZT7isLQSQYb4X31926C45369034ixYYw0dBR9SVy2z4DdcnSh7yC >									
106 	//        <  u =="0.000000000000000001" : ] 000000032910883.225757900000000000 ; 000000044220541.513087900000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000003237D04379A6 >									
108 	//     < BANK_II_PFIII_metadata_line_5_____WERNER_MERTZ_20260508 >									
109 	//        < Jx0pQCaqeiV5F7b7PtdkPF7LbWIvYhGF932eD98fpG32g1Ujb2MSHwUXh179B3Xe >									
110 	//        <  u =="0.000000000000000001" : ] 000000044220541.513087900000000000 ; 000000055111170.666548400000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000004379A65417CD >									
112 	//     < BANK_II_PFIII_metadata_line_6_____JF_HILLEBRAND_20260508 >									
113 	//        < getKoC9C6sckSaw3d9zkqFfwBma3QPGkUY5ZuAlF7ayottI6hlEJH9J3W2ju7416 >									
114 	//        <  u =="0.000000000000000001" : ] 000000055111170.666548400000000000 ; 000000065972179.239507600000000000 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000000000005417CD64AA62 >									
116 	//     < BANK_II_PFIII_metadata_line_7_____TRANS_OCEAN_20260508 >									
117 	//        < QoH6hm508q5dP2v99tyd6cNJyfK6VQK3H234r12j9DqM6J3vmArx69A0F2ihK7Hw >									
118 	//        <  u =="0.000000000000000001" : ] 000000065972179.239507600000000000 ; 000000077047239.446817000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000000064AA62759094 >									
120 	//     < BANK_II_PFIII_metadata_line_8_____SATELLITE_LOGISTICS_GROUP_20260508 >									
121 	//        < 3QNNRJUe6faR55Ck0vGFI0s013oy3B9lQfCrY6HXDMPEHyEdX4T13hJMc91MOqJ1 >									
122 	//        <  u =="0.000000000000000001" : ] 000000077047239.446817000000000000 ; 000000087745404.141002700000000000 ] >									
123 	//        < 0x000000000000000000000000000000000000000000000000000075909485E38C >									
124 	//     < BANK_II_PFIII_metadata_line_9_____JF_HILLEBRAND_GROUP_20260508 >									
125 	//        < zugLG33326pjmImUP9UgVFS7D2bU41E303IPM03u5i4mPhWEQW4F9o06sw6oTlp1 >									
126 	//        <  u =="0.000000000000000001" : ] 000000087745404.141002700000000000 ; 000000098785158.073178900000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000000085E38C96BBF4 >									
128 	//     < BANK_II_PFIII_metadata_line_10_____ARCHER_DANIELS_MIDLAND_20260508 >									
129 	//        < Lbs0biLk1dRJlM4Tw2oEHk1R27aQuu8J1IgMvqXPXG0WXzqdGVz8ny5yX848I6Xg >									
130 	//        <  u =="0.000000000000000001" : ] 000000098785158.073178900000000000 ; 000000109789711.366605000000000000 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000000000096BBF4A7869B >									
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
174 	//     < BANK_II_PFIII_metadata_line_11_____WEPA_20260508 >									
175 	//        < 8Nlv0BztC18WV013t82EpILRAml1v6wv7l3T4qx8py14bAD0xm0s5olc22YHOmJ1 >									
176 	//        <  u =="0.000000000000000001" : ] 000000109789711.366605000000000000 ; 000000120629831.538021000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000000A7869BB81107 >									
178 	//     < BANK_II_PFIII_metadata_line_12_____IBM_CORP_20260508 >									
179 	//        < 0esbCWwgjL9BM9LqV5avvYqW262fne7xhp5HvY553TeAse49RzT6O6QAvc55AV32 >									
180 	//        <  u =="0.000000000000000001" : ] 000000120629831.538021000000000000 ; 000000131582156.268063000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000000B81107C8C748 >									
182 	//     < BANK_II_PFIII_metadata_line_13_____NOVO_NORDISK_20260508 >									
183 	//        < rE4A0bWHfdX4C8Ce2Gn3k11b8YKyF2ot9kewbOW0EO53J1XFsq11G2582rkp344A >									
184 	//        <  u =="0.000000000000000001" : ] 000000131582156.268063000000000000 ; 000000142271667.742138000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000000C8C748D916DF >									
186 	//     < BANK_II_PFIII_metadata_line_14_____COFACE_20260508 >									
187 	//        < 2kMhH3M3281t1RFgg73J180WsJWN65A7HlQfcoTei4vVc0r1O2LU5EuFh9F6k600 >									
188 	//        <  u =="0.000000000000000001" : ] 000000142271667.742138000000000000 ; 000000153559039.202774000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000000D916DFEA5000 >									
190 	//     < BANK_II_PFIII_metadata_line_15_____MOGUNTIA_20260508 >									
191 	//        < q7KE6F3ojqFAeRQvNy3Duq25icYN10AiQ3MSQGZ9wL5AwwB2K2aWZdQKc65Dc4mR >									
192 	//        <  u =="0.000000000000000001" : ] 000000153559039.202774000000000000 ; 000000164410829.777966000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000000EA5000FADEFB >									
194 	//     < BANK_II_PFIII_metadata_line_16_____DITSCH_20260508 >									
195 	//        < 0BqP1Mze668kuEF49MzJxDTlMo7619BNChn0zWx9VX7Q60Pg9dZ7nHn5GEvDbGFP >									
196 	//        <  u =="0.000000000000000001" : ] 000000164410829.777966000000000000 ; 000000175295840.476115000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000000FADEFB10B7AF0 >									
198 	//     < BANK_II_PFIII_metadata_line_17_____GRANDS_CHAIS_DE_FRANCE_20260508 >									
199 	//        < 0i5cje5DYzDAE8dkjLzjkAw477J99U2LacNL8n1MhAn4AHw9T3H2hSg9HWJYa9X3 >									
200 	//        <  u =="0.000000000000000001" : ] 000000175295840.476115000000000000 ; 000000186064460.199121000000000000 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000000010B7AF011BE96E >									
202 	//     < BANK_II_PFIII_metadata_line_18_____Zweites Deutsches Fernsehen_ZDF_20260508 >									
203 	//        < YP4oL8rHl3Il2t75Y4oQuGXBzbBtgfsic0i2AR7xQW23E9hl7I8O7BNwGo326I4B >									
204 	//        <  u =="0.000000000000000001" : ] 000000186064460.199121000000000000 ; 000000197122527.395693000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000011BE96E12CC8FD >									
206 	//     < BANK_II_PFIII_metadata_line_19_____3SAT_20260508 >									
207 	//        < nC8gbj3On4SQ00gwJa1T33hEcQ3p1yug1j4e9et5jI9M2A7007YVweIzSt67NuBO >									
208 	//        <  u =="0.000000000000000001" : ] 000000197122527.395693000000000000 ; 000000208087873.586923000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000000012CC8FD13D8453 >									
210 	//     < BANK_II_PFIII_metadata_line_20_____Südwestrundfunk_SWR_20260508 >									
211 	//        < sMRdP5R1aVXfX0p10H7Mv0Zt62D3f2UfdK734C03cqE97Vk2nkxaQwYI45COog2l >									
212 	//        <  u =="0.000000000000000001" : ] 000000208087873.586923000000000000 ; 000000219313737.712080000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000013D845314EA56E >									
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
256 	//     < BANK_II_PFIII_metadata_line_21_____SCHOTT_MUSIC_20260508 >									
257 	//        < L06xWX2pAb7It5L5k5BNIPI6jwaO1B0K79L8J317lN26hn9pjWlA4dNMmz3kL0B7 >									
258 	//        <  u =="0.000000000000000001" : ] 000000219313737.712080000000000000 ; 000000230236109.313353000000000000 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000000014EA56E15F4FFB >									
260 	//     < BANK_II_PFIII_metadata_line_22_____Verlagsgruppe Rhein Main_20260508 >									
261 	//        < u63Q9OoNIpPS0Wr37x802V3KLEKNgT25PsKmlbfwPsvV6DXyDD64s0Ya0BG48i5p >									
262 	//        <  u =="0.000000000000000001" : ] 000000230236109.313353000000000000 ; 000000241135819.684068000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000015F4FFB16FF1AE >									
264 	//     < BANK_II_PFIII_metadata_line_23_____Philipp von Zabern_20260508 >									
265 	//        < QUQYE698w1XyVOX9hiaT8p61g65FL40z2pYDf2MsrM27bvKDb5jhf838Whp9AzBI >									
266 	//        <  u =="0.000000000000000001" : ] 000000241135819.684068000000000000 ; 000000252091396.643792000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000016FF1AE180A934 >									
268 	//     < BANK_II_PFIII_metadata_line_24_____De Dietrich Process Systems_GMBH_20260508 >									
269 	//        < 73ZU396zU1GbK1GXQ0k371G0kZVQf49jvHzP0feXR866ZGDYin1f2eU475Q8SMv1 >									
270 	//        <  u =="0.000000000000000001" : ] 000000252091396.643792000000000000 ; 000000263303575.362326000000000000 ] >									
271 	//        < 0x00000000000000000000000000000000000000000000000000180A934191C4F6 >									
272 	//     < BANK_II_PFIII_metadata_line_25_____FIRST_SOLAR_GMBH_20260508 >									
273 	//        < qtcS1srZ9alTff960NUHvskQJL3Plkl345sDyT05CR4mALXuY8mxfwZ4MhVmn3hn >									
274 	//        <  u =="0.000000000000000001" : ] 000000263303575.362326000000000000 ; 000000274509742.127549000000000000 ] >									
275 	//        < 0x00000000000000000000000000000000000000000000000000191C4F61A2DE5E >									
276 	//     < BANK_II_PFIII_metadata_line_26_____BIONTECH_SE_20260508 >									
277 	//        < iyRQ6aKVUAhu6Se64o7ij5m1Qx8A9G1rrPRc9JTD6o02egVFRZ6g2X71tILp7FNu >									
278 	//        <  u =="0.000000000000000001" : ] 000000274509742.127549000000000000 ; 000000285751602.649494000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000001A2DE5E1B405B8 >									
280 	//     < BANK_II_PFIII_metadata_line_27_____UNI_MAINZ_20260508 >									
281 	//        < 5JJ6N4h0vf4ExrPB2Wh6pTR70519Fa0WHM8oU52KjRl9l0psrB6P3BR0HPwGe5Wo >									
282 	//        <  u =="0.000000000000000001" : ] 000000285751602.649494000000000000 ; 000000296469964.209311000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000001B405B81C46094 >									
284 	//     < BANK_II_PFIII_metadata_line_28_____Mainz Institute of Microtechnology_20260508 >									
285 	//        < r4SHJ6Id3oG1dc01UVeoGrrj5sHmKY1lFg7SUPYOYBK9ic7ByAngs1tKuPgc8Z2m >									
286 	//        <  u =="0.000000000000000001" : ] 000000296469964.209311000000000000 ; 000000307165268.547102000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000001C460941D4B26F >									
288 	//     < BANK_II_PFIII_metadata_line_29_____Matthias_Grünewald_Verlag_20260508 >									
289 	//        < 2nPzV6M3f3SytM2H27uMXx3z3Yqi32s65jwZyu5Ti36KX8Z92t1Lnc9e9nfwlsVJ >									
290 	//        <  u =="0.000000000000000001" : ] 000000307165268.547102000000000000 ; 000000318140329.270543000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000001D4B26F1E57191 >									
292 	//     < BANK_II_PFIII_metadata_line_30_____PEDIA_PRESS_20260508 >									
293 	//        < ucP8mVC15TKz8ww7gQF4LNLXdSOu57xVIcN4J2Qr1q6qxn73EyO6ynLqdk7bc0Dd >									
294 	//        <  u =="0.000000000000000001" : ] 000000318140329.270543000000000000 ; 000000328968660.148232000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000001E571911F5F762 >									
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
338 	//     < BANK_II_PFIII_metadata_line_31_____Boehringer Ingelheim_20260508 >									
339 	//        < t4Q79Rx563Fj69A2Lmb6H8pp1qw1k165I06Ab7G1C19alhmCf1lUWp5LS236h838 >									
340 	//        <  u =="0.000000000000000001" : ] 000000328968660.148232000000000000 ; 000000340288533.601374000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000001F5F7622073D35 >									
342 	//     < BANK_II_PFIII_metadata_line_32_____MIDAS_PHARMA_20260508 >									
343 	//        < GeFRl9PCo6RR625LgWT1UpVK6a8m524QYrG9WyKa7dmp9U8k2oDl7qhrK6tI72o4 >									
344 	//        <  u =="0.000000000000000001" : ] 000000340288533.601374000000000000 ; 000000351232079.100075000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000002073D35217F008 >									
346 	//     < BANK_II_PFIII_metadata_line_33_____MIDAS_PHARMA_POLSKA_20260508 >									
347 	//        < c9Ga4Ec7pj7617SWUW83CHLeINn9Qqt9T8Y31w91BFvV03OnA4yum5vZQsIwnjR6 >									
348 	//        <  u =="0.000000000000000001" : ] 000000351232079.100075000000000000 ; 000000361928976.316670000000000000 ] >									
349 	//        < 0x00000000000000000000000000000000000000000000000000217F0082284282 >									
350 	//     < BANK_II_PFIII_metadata_line_34_____CMS_PHARMA_20260508 >									
351 	//        < watmOIIvILM5CH2e0v59fCv71emswA7Zp6i6mpCh7Yn0v7IZIL8226Svhoo7vOrL >									
352 	//        <  u =="0.000000000000000001" : ] 000000361928976.316670000000000000 ; 000000373162102.642842000000000000 ] >									
353 	//        < 0x0000000000000000000000000000000000000000000000000022842822396672 >									
354 	//     < BANK_II_PFIII_metadata_line_35_____CAIGOS_GMBH_20260508 >									
355 	//        < D9ajEj7KsKOUMq599F0xub70m38t0qUl31g6JiJ0yP9e8HXNYJ2mS8PpS8pJfJ5T >									
356 	//        <  u =="0.000000000000000001" : ] 000000373162102.642842000000000000 ; 000000384041826.192125000000000000 ] >									
357 	//        < 0x00000000000000000000000000000000000000000000000000239667224A0057 >									
358 	//     < BANK_II_PFIII_metadata_line_36_____Altes E_Werk der Rheinhessische Energie_und Wasserversorgungs_GmbH_20260508 >									
359 	//        < 2jeSd87cyu4vh4fZg53fYsst9fpuv8J6Zl0u0gPbf136NpY3PP5GH8FavW9cT1PY >									
360 	//        <  u =="0.000000000000000001" : ] 000000384041826.192125000000000000 ; 000000395126002.933732000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000024A005725AEA18 >									
362 	//     < BANK_II_PFIII_metadata_line_37_____THUEGA_AG_20260508 >									
363 	//        < 9UU69375n7728T1qr1ir8FzBe8d794fP9HB6K3pq79n3621p3F0TUb2D8F8693p0 >									
364 	//        <  u =="0.000000000000000001" : ] 000000395126002.933732000000000000 ; 000000405824549.602227000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000025AEA1826B3D37 >									
366 	//     < BANK_II_PFIII_metadata_line_38_____Verbandsgemeinde Heidesheim am Rhein_20260508 >									
367 	//        < 54J81B8brZTJUygCPoevJpKc8wJ6sf5vU3ymzU8062D5jZS3F80a4qpt6cERgHzz >									
368 	//        <  u =="0.000000000000000001" : ] 000000405824549.602227000000000000 ; 000000416944060.797144000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000026B3D3727C34C6 >									
370 	//     < BANK_II_PFIII_metadata_line_39_____Stadtwerke Ingelheim_AB_20260508 >									
371 	//        < KJLbY0N11j9Urg43ErIqTE767A7ZuDBja8hAa2z9wqh66PX2ATLBBaUwKDwJVDX6 >									
372 	//        <  u =="0.000000000000000001" : ] 000000416944060.797144000000000000 ; 000000428031099.627910000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000027C34C628D1FA6 >									
374 	//     < BANK_II_PFIII_metadata_line_40_____rhenag Rheinische Energie AG_KOELN_20260508 >									
375 	//        < cLscj98RgT21kPF733p23h5eQ03v2zr7qHDn9KC1l9krbJ3EMa3V9I03Dp60jabs >									
376 	//        <  u =="0.000000000000000001" : ] 000000428031099.627910000000000000 ; 000000439095964.093327000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000028D1FA629E01DC >									
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