1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXXVIII_II_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXXVIII_II_883		"	;
8 		string	public		symbol =	"	RUSS_PFXXVIII_II_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		813183889037939000000000000					;	
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
92 	//     < RUSS_PFXXVIII_II_metadata_line_1_____SIBUR_GBP_20231101 >									
93 	//        < JIEiiKHoTdsQ1565p6R7U79A3kcVOh3It0uJvnMJ0S7YlBn0j4A7G2OP3STb8lsB >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000018880968.643347600000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000001CCF61 >									
96 	//     < RUSS_PFXXVIII_II_metadata_line_2_____SIBUR_USD_20231101 >									
97 	//        < y9Az6AQSd4X43MQg3NjNiRh2tBpd4DKlM882s03d08B0g2JRUt8Nj2eM2fh8qD60 >									
98 	//        <  u =="0.000000000000000001" : ] 000000018880968.643347600000000000 ; 000000035862860.805272500000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000001CCF6136B8EE >									
100 	//     < RUSS_PFXXVIII_II_metadata_line_3_____SIBUR_FINANCE_CHF_20231101 >									
101 	//        < dC031Jv6y47c0Mtj8L9tGrQF162snwpK8uykEgLtt596C149JCx7th8TO7363Wyc >									
102 	//        <  u =="0.000000000000000001" : ] 000000035862860.805272500000000000 ; 000000054331334.656538800000000000 ] >									
103 	//        < 0x000000000000000000000000000000000000000000000000000036B8EE52E72D >									
104 	//     < RUSS_PFXXVIII_II_metadata_line_4_____SIBUR_FINANS_20231101 >									
105 	//        < N59MdEy65ls4YD4E8Z4Btc6pvyO66600tzf987n0m45iJU0m2z4pqmx07A2W8B0i >									
106 	//        <  u =="0.000000000000000001" : ] 000000054331334.656538800000000000 ; 000000071638991.522174100000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000052E72D6D4FFB >									
108 	//     < RUSS_PFXXVIII_II_metadata_line_5_____SIBUR_SA_20231101 >									
109 	//        < H0NLs6nxn92yy7u9Uag0Yb792IH2o3HnQ2Ry63vuc3L2Z8H70i2tgRt55dV1q419 >									
110 	//        <  u =="0.000000000000000001" : ] 000000071638991.522174100000000000 ; 000000094945627.862312800000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000006D4FFB90E023 >									
112 	//     < RUSS_PFXXVIII_II_metadata_line_6_____VOSTOK_LLC_20231101 >									
113 	//        < 9WGn5xoiyJBc26R8Un6oLrsRhK3tEAkDCubflPbvB6d0IXSEn06Lh1uUnp63gE8G >									
114 	//        <  u =="0.000000000000000001" : ] 000000094945627.862312800000000000 ; 000000117383070.776912000000000000 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000000000090E023B31CC3 >									
116 	//     < RUSS_PFXXVIII_II_metadata_line_7_____BELOZERNYI_GPP_20231101 >									
117 	//        < 3Q23Itg16ZV04jBcgwgL4jcsou53YBa2b4GSD5RVbXPeIY6hE2j3QM75P8mg082W >									
118 	//        <  u =="0.000000000000000001" : ] 000000117383070.776912000000000000 ; 000000141831573.561568000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000B31CC3D86AF5 >									
120 	//     < RUSS_PFXXVIII_II_metadata_line_8_____KRASNOYARSK_SYNTHETIC_RUBBERS_PLANT_20231101 >									
121 	//        < pZpMlqzR217z8L0DIAHpQ55QCsL1yv6oJlw9EzgWJ257YIo4c7Ol8hK1kF25Oy80 >									
122 	//        <  u =="0.000000000000000001" : ] 000000141831573.561568000000000000 ; 000000165267181.488624000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000D86AF5FC2D7E >									
124 	//     < RUSS_PFXXVIII_II_metadata_line_9_____ORTON_20231101 >									
125 	//        < BjeuHcevI93MZAmP6Ays44Zgsp5AeW2Emut99j8Uf7kduFm8d2oqjVW6Egxmj3l4 >									
126 	//        <  u =="0.000000000000000001" : ] 000000165267181.488624000000000000 ; 000000184946654.987961000000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000000FC2D7E11A34C9 >									
128 	//     < RUSS_PFXXVIII_II_metadata_line_10_____PLASTIC_GEOSYNTHETIC_20231101 >									
129 	//        < ESbRxR75eL4r7GxA568vY23pof9439WR3f5ybZ99GibkwnS3YCwJc9ps0Mukn62N >									
130 	//        <  u =="0.000000000000000001" : ] 000000184946654.987961000000000000 ; 000000205997054.371609000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000011A34C913A5399 >									
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
174 	//     < RUSS_PFXXVIII_II_metadata_line_11_____TOBOLSK_COMBINED_HEAT_POWER_PLANT_20231101 >									
175 	//        < 7iJ586H1vFjzo62Z9yQflnd3r46fk4eFuu5R3HDTMAQ2S28h2Q10yKRQm9vqz957 >									
176 	//        <  u =="0.000000000000000001" : ] 000000205997054.371609000000000000 ; 000000225445436.992094000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000013A539915800A0 >									
178 	//     < RUSS_PFXXVIII_II_metadata_line_12_____UGRAGAZPERERABOTKA_20231101 >									
179 	//        < mH1OudMFo6k58M3vXRjaw4rC6q5ovW2vACe04d89AMReU7XGOGha3d3s3lb8wuTU >									
180 	//        <  u =="0.000000000000000001" : ] 000000225445436.992094000000000000 ; 000000243227728.346119000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000015800A017322D5 >									
182 	//     < RUSS_PFXXVIII_II_metadata_line_13_____UGRAGAZPERERABOTKA_GBP_20231101 >									
183 	//        < 1HA0wGjAlo9WvTY36Q7Zv5v4Y6m209e1P55v593RL9pzCCz3A18un45wxnt212qv >									
184 	//        <  u =="0.000000000000000001" : ] 000000243227728.346119000000000000 ; 000000262027797.465509000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000017322D518FD29C >									
186 	//     < RUSS_PFXXVIII_II_metadata_line_14_____UGRAGAZPERERABOTKA_BYR_20231101 >									
187 	//        < 08rT2rE0c8knzLeeQkSi1Gg6cG9iDN8v8U2OMBeUA4ab8SxJ0cAJihGDR035yHp4 >									
188 	//        <  u =="0.000000000000000001" : ] 000000262027797.465509000000000000 ; 000000278670990.193437000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000018FD29C1A937DB >									
190 	//     < RUSS_PFXXVIII_II_metadata_line_15_____RUSTEP_20231101 >									
191 	//        < DmOQFd4E7V5gHKW8cEPeDk9sPkb5rFTf8w4r79hajY68zTDd01BKBys73H0niR7C >									
192 	//        <  u =="0.000000000000000001" : ] 000000278670990.193437000000000000 ; 000000300305298.836667000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000001A937DB1CA3AC2 >									
194 	//     < RUSS_PFXXVIII_II_metadata_line_16_____RUSTEP_RYB_20231101 >									
195 	//        < bzFl37A7D8Fyy9oHlv3G1W5fFn8QGsqZg3ImKLQgo80Z3qX56Y7eMZke83V7k9UC >									
196 	//        <  u =="0.000000000000000001" : ] 000000300305298.836667000000000000 ; 000000322284432.122109000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000001CA3AC21EBC45B >									
198 	//     < RUSS_PFXXVIII_II_metadata_line_17_____BALTIC_BYR_20231101 >									
199 	//        < 75Y52xPy6AIbSxV5CQNG1L12iqVU8TARz89GSA4QcO62km5hyU2ApY4v8O8ZU6R7 >									
200 	//        <  u =="0.000000000000000001" : ] 000000322284432.122109000000000000 ; 000000337748239.460211000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000001EBC45B2035CE8 >									
202 	//     < RUSS_PFXXVIII_II_metadata_line_18_____ARKTIK_BYR_20231101 >									
203 	//        < GKZ6Hh75PM74th0aW6Ht03JWDdZU6d50sbp5H0b5hwPhr6Sby2195ZT3S13hYh9t >									
204 	//        <  u =="0.000000000000000001" : ] 000000337748239.460211000000000000 ; 000000360184187.761386000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000002035CE822598F3 >									
206 	//     < RUSS_PFXXVIII_II_metadata_line_19_____VOSTOK_BYR_20231101 >									
207 	//        < wna9r1OodlI4C1Ruvgt9GWsCBNyHJ093p0ZlGS9bE41Uz75Pu9vSwf93nMFcl3F4 >									
208 	//        <  u =="0.000000000000000001" : ] 000000360184187.761386000000000000 ; 000000378540554.803969000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000000022598F32419B67 >									
210 	//     < RUSS_PFXXVIII_II_metadata_line_20_____VINYL_BYR_20231101 >									
211 	//        < ch7RtoP9ICe927v2GWQ5bEannT01VxAXoMc8X9I7lpj9m56ZT2ibRk4Bn036AnK8 >									
212 	//        <  u =="0.000000000000000001" : ] 000000378540554.803969000000000000 ; 000000402395744.343947000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000002419B6726601D6 >									
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
256 	//     < RUSS_PFXXVIII_II_metadata_line_21_____TOBOLSK_BYR_20231101 >									
257 	//        < 5e4D6JwC1CdfxD0dsQrq38hCxT0i9b4bau5a1E1pqXduUee6fd0q2Kayst3O0Aj7 >									
258 	//        <  u =="0.000000000000000001" : ] 000000402395744.343947000000000000 ; 000000422742219.187415000000000000 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000000026601D62850DAE >									
260 	//     < RUSS_PFXXVIII_II_metadata_line_22_____ACRYLATE_BYR_20231101 >									
261 	//        < rSPjvix5xD53dbCSF5Kc74X5vLj580keABL9yA7Q4ssNK30FhzDc75l29ksfd04J >									
262 	//        <  u =="0.000000000000000001" : ] 000000422742219.187415000000000000 ; 000000445090087.159275000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000002850DAE2A72751 >									
264 	//     < RUSS_PFXXVIII_II_metadata_line_23_____POLIEF_BYR_20231101 >									
265 	//        < 5nEkdRgu7wN1M4t1wz9t79Eu48TaZqRWSMz9cJJL1S0B3PKvA13mYulN0L86r58x >									
266 	//        <  u =="0.000000000000000001" : ] 000000445090087.159275000000000000 ; 000000466232268.845673000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000002A727512C769FB >									
268 	//     < RUSS_PFXXVIII_II_metadata_line_24_____NOVAENG_BYR_20231101 >									
269 	//        < khy0Wt23c4dM4Tyk1G9ng2QUk8oLgFuH8ZDFPWzh1taCo8XznhGXtSGKnBLbcRIU >									
270 	//        <  u =="0.000000000000000001" : ] 000000466232268.845673000000000000 ; 000000482310687.217256000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000002C769FB2DFF29D >									
272 	//     < RUSS_PFXXVIII_II_metadata_line_25_____BIAXP_BYR_20231101 >									
273 	//        < aRyWK9i0U01xEau8O2MudZUMXgvdiCJ1SlKdd9K6Fp0rVD3m1dUgwM7m8JNNnVrf >									
274 	//        <  u =="0.000000000000000001" : ] 000000482310687.217256000000000000 ; 000000505128220.962905000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002DFF29D302C3B6 >									
276 	//     < RUSS_PFXXVIII_II_metadata_line_26_____YUGRAGAZPERERABOTKA_AB_20231101 >									
277 	//        < Q3BzD5UT7568B198AlI560ACnT98gVAKxpcO76i823h0kg594F8WPPReM7wew69R >									
278 	//        <  u =="0.000000000000000001" : ] 000000505128220.962905000000000000 ; 000000528739210.211307000000000000 ] >									
279 	//        < 0x00000000000000000000000000000000000000000000000000302C3B6326CAC1 >									
280 	//     < RUSS_PFXXVIII_II_metadata_line_27_____TOMSKNEFTEKHIM_AB_20231101 >									
281 	//        < D5Kj392vo8RfhwQUcRTKNO8blFnR6Bq0q1P0dt084hNe0fnUHrH8pC6m22UB4A1m >									
282 	//        <  u =="0.000000000000000001" : ] 000000528739210.211307000000000000 ; 000000547454123.231146000000000000 ] >									
283 	//        < 0x00000000000000000000000000000000000000000000000000326CAC13435944 >									
284 	//     < RUSS_PFXXVIII_II_metadata_line_28_____BALTIC_LNG_AB_20231101 >									
285 	//        < Wf863ZDez5O1BfW1mU73dP2kz0wf63K47VFITB20908RZ0r3914kzQ47Zre376D0 >									
286 	//        <  u =="0.000000000000000001" : ] 000000547454123.231146000000000000 ; 000000570688855.072005000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000003435944366CD56 >									
288 	//     < RUSS_PFXXVIII_II_metadata_line_29_____SIBUR_INT_AB_20231101 >									
289 	//        < vOx3eJNl433Dv1z9rHG6nNtvg2td5ak97z593OnWPO52Rh4NyJFpGVICOM1h783N >									
290 	//        <  u =="0.000000000000000001" : ] 000000570688855.072005000000000000 ; 000000589416806.464131000000000000 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000000000366CD5638360F1 >									
292 	//     < RUSS_PFXXVIII_II_metadata_line_30_____TOBOL_SK_POLIMER_AB_20231101 >									
293 	//        < 2AcsFtS8a4Q8ZlH3Kw4B8DmKUVKd721G16RY7T2K52NziG1wKuBQ7hY8Bc4i7z18 >									
294 	//        <  u =="0.000000000000000001" : ] 000000589416806.464131000000000000 ; 000000609943314.889962000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000038360F13A2B31B >									
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
338 	//     < RUSS_PFXXVIII_II_metadata_line_31_____SIBUR_SCIENT_RD_INSTITUTE_GAS_PROCESS_AB_20231101 >									
339 	//        < G4W2sO2xEaGeT3tUG1lPnBrY6nDT44aT6F02GA6dd378GT0JM5W8mlEv96LBO7T5 >									
340 	//        <  u =="0.000000000000000001" : ] 000000609943314.889962000000000000 ; 000000627573949.850765000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000003A2B31B3BD9A13 >									
342 	//     < RUSS_PFXXVIII_II_metadata_line_32_____ZAPSIBNEFTEKHIM_AB_20231101 >									
343 	//        < 53te52cIvQ82959fLY8NrSSqIxQD6kj72u488H6su25w60dC2xQ6hRK3qDs2lM1P >									
344 	//        <  u =="0.000000000000000001" : ] 000000627573949.850765000000000000 ; 000000647649809.110474000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000003BD9A133DC3C35 >									
346 	//     < RUSS_PFXXVIII_II_metadata_line_33_____NEFTEKHIMIA_AB_20231101 >									
347 	//        < 4n0t6Imcxusboc15HaQZIIlM5j03c6VV6bt2Pg3dRAN0efEe7U86fmRAf24f403c >									
348 	//        <  u =="0.000000000000000001" : ] 000000647649809.110474000000000000 ; 000000665864074.776195000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000003DC3C353F80727 >									
350 	//     < RUSS_PFXXVIII_II_metadata_line_34_____OTECHESTVENNYE_POLIMERY_AB_20231101 >									
351 	//        < eakRPobtTWNumPaCw49Yz164V079R2z9bGgi3GZb5A2Z8a6Jizvz4o6HbLu23ycc >									
352 	//        <  u =="0.000000000000000001" : ] 000000665864074.776195000000000000 ; 000000686965515.353715000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000003F8072741839E8 >									
354 	//     < RUSS_PFXXVIII_II_metadata_line_35_____SIBUR_TRANS_AB_20231101 >									
355 	//        < 8CB0OAH40U698Bh2ro8JWG4QZq7SD4hOF7LTenIvi5zLA5HrUx65k28b8WCoo5iM >									
356 	//        <  u =="0.000000000000000001" : ] 000000686965515.353715000000000000 ; 000000708640671.061384000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000041839E84394CC3 >									
358 	//     < RUSS_PFXXVIII_II_metadata_line_36_____TOGLIATTIKAUCHUK_AB_20231101 >									
359 	//        < 329ai6cRJhH70uix0JKktRp305C8bT7y9e0iPx8HhuB4505EhYOmGRo3617sD4Mr >									
360 	//        <  u =="0.000000000000000001" : ] 000000708640671.061384000000000000 ; 000000731983959.294132000000000000 ] >									
361 	//        < 0x000000000000000000000000000000000000000000000000004394CC345CEB3C >									
362 	//     < RUSS_PFXXVIII_II_metadata_line_37_____NPP_NEFTEKHIMIYA_AB_20231101 >									
363 	//        < a9815F0dmCOJJZAIuuUNW7p7QnvIt365AbyLcNOOyEjmt69y51g5v6Mg37Qmgh0y >									
364 	//        <  u =="0.000000000000000001" : ] 000000731983959.294132000000000000 ; 000000753562412.175109000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000045CEB3C47DD851 >									
366 	//     < RUSS_PFXXVIII_II_metadata_line_38_____SIBUR_KHIMPROM_AB_20231101 >									
367 	//        < 1f31Ji1S1K88LEjdB733P74y26SO1ZAPR115m0o2RihBuqkLC76Jc8VJf1img5D7 >									
368 	//        <  u =="0.000000000000000001" : ] 000000753562412.175109000000000000 ; 000000778180158.799397000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000047DD8514A368A0 >									
370 	//     < RUSS_PFXXVIII_II_metadata_line_39_____SIBUR_VOLZHSKY_AB_20231101 >									
371 	//        < lfuS4625BVX315Lb32V5K0yxC9MJj241uvMzKeua2JwIzUzYOm2JNFQ1X88O9N8g >									
372 	//        <  u =="0.000000000000000001" : ] 000000778180158.799397000000000000 ; 000000796172394.935449000000000000 ] >									
373 	//        < 0x000000000000000000000000000000000000000000000000004A368A04BEDCD7 >									
374 	//     < RUSS_PFXXVIII_II_metadata_line_40_____VORONEZHSINTEZKAUCHUK_AB_20231101 >									
375 	//        < 6b5Soj1E6r1iULOq9R5B12ljYMu01Vs7Cupt0HLo7dH08mrEf3o5q3pyvCI2fyA8 >									
376 	//        <  u =="0.000000000000000001" : ] 000000796172394.935449000000000000 ; 000000813183889.037939000000000000 ] >									
377 	//        < 0x000000000000000000000000000000000000000000000000004BEDCD74D8D1F5 >									
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