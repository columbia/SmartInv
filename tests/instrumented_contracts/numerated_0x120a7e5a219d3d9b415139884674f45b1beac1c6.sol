1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXVI_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXVI_I_883		"	;
8 		string	public		symbol =	"	RUSS_PFXVI_I_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		601718865595943000000000000					;	
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
92 	//     < RUSS_PFXVI_I_metadata_line_1_____KYZYL_GOLD_20211101 >									
93 	//        < lhwuaLHd06uI2f8278h1BIQ5e3039953V3DmXkiWP612ZSy0h8Gm0zAAh3776939 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000017275151.685507300000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000001A5C1B >									
96 	//     < RUSS_PFXVI_I_metadata_line_2_____SEREBRO_MAGADANA_20211101 >									
97 	//        < 822zOa20x1h0Hp1uUtIX7XV9C2jLQ3NSqFiCpsk2ta0e76ec660OV57SXS5Xi0Bx >									
98 	//        <  u =="0.000000000000000001" : ] 000000017275151.685507300000000000 ; 000000033014214.652327800000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000001A5C1B32602D >									
100 	//     < RUSS_PFXVI_I_metadata_line_3_____OMOLON_GOLD_MINING_CO_20211101 >									
101 	//        < 00pDkQAqWhchFQ9MM9JcJt1nIa842QODPSEptsVG89Y886EMiWDJ5pB74Eb0Y2A2 >									
102 	//        <  u =="0.000000000000000001" : ] 000000033014214.652327800000000000 ; 000000049266590.599018200000000000 ] >									
103 	//        < 0x000000000000000000000000000000000000000000000000000032602D4B2CC3 >									
104 	//     < RUSS_PFXVI_I_metadata_line_4_____AMUR_CHEMICAL_METALL_PLANT_20211101 >									
105 	//        < 99eg4EK4kxu85aD94YPp3bTf0TArmbb6Bj8KXDwGH5xufc51A02O1c0Zm59skI1Z >									
106 	//        <  u =="0.000000000000000001" : ] 000000049266590.599018200000000000 ; 000000063618150.754077000000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000004B2CC36112D7 >									
108 	//     < RUSS_PFXVI_I_metadata_line_5_____AMUR_CHEMICAL_METALL_PLANT_ORG_20211101 >									
109 	//        < x9T6GHWdOzqQ390nanu01jQXZ1gE9OoHA9u4mIcRfC2hx3216d1Rrpf644o6kesP >									
110 	//        <  u =="0.000000000000000001" : ] 000000063618150.754077000000000000 ; 000000077943703.182237900000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000006112D776EEC2 >									
112 	//     < RUSS_PFXVI_I_metadata_line_6_____KAPAN_MINING_PROCESS_CO_20211101 >									
113 	//        < DDYBDT1A3373wF2688Bf3u6Xg0VoLWXTPOKKhVHSu64w2tWKypg8EU8y13yeNk5I >									
114 	//        <  u =="0.000000000000000001" : ] 000000077943703.182237900000000000 ; 000000094579238.269087800000000000 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000000000076EEC2905104 >									
116 	//     < RUSS_PFXVI_I_metadata_line_7_____VARVARINSKOYE_20211101 >									
117 	//        < 3XSRia3wisomFfXJDyG0Ao3ZhMbIKc8wS192i96k03W4AEgX4x8E17LSphVp466u >									
118 	//        <  u =="0.000000000000000001" : ] 000000094579238.269087800000000000 ; 000000108862863.528485000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000905104A61C8E >									
120 	//     < RUSS_PFXVI_I_metadata_line_8_____KAPAN_MPC_20211101 >									
121 	//        < 0U98Gb4M4ImmnSUR549uf5x2rDEuPy5uUtW1Iq86444538xwRBirIFaEnsWH3Sy9 >									
122 	//        <  u =="0.000000000000000001" : ] 000000108862863.528485000000000000 ; 000000125338324.363156000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000A61C8EBF4048 >									
124 	//     < RUSS_PFXVI_I_metadata_line_9_____ORION_MINERALS_LLP_20211101 >									
125 	//        < 9dL90OJ1CTK4C2xXkX7E9U2h232M6NFC7QwOD6G592QS66M99Lf1u46Luc6elQd7 >									
126 	//        <  u =="0.000000000000000001" : ] 000000125338324.363156000000000000 ; 000000138368603.481528000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000000BF4048D3223C >									
128 	//     < RUSS_PFXVI_I_metadata_line_10_____IMITZOLOTO_LIMITED_20211101 >									
129 	//        < kvO9UOJVPKZ11oPOvR353QFS0GzX6828uk6BUCTQfwWJKD3g2GFfeCGwPgF6WY3Q >									
130 	//        <  u =="0.000000000000000001" : ] 000000138368603.481528000000000000 ; 000000153700229.474332000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000000D3223CEA8727 >									
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
174 	//     < RUSS_PFXVI_I_metadata_line_11_____ZAO_ZOLOTO_SEVERNOGO_URALA_20211101 >									
175 	//        < H5KeCZIybuRY77gl7347QSS0aeYV8trIc10109J6A09O7Zk1MoFAc24EyE3DbGkD >									
176 	//        <  u =="0.000000000000000001" : ] 000000153700229.474332000000000000 ; 000000167263039.180982000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000000EA8727FF3920 >									
178 	//     < RUSS_PFXVI_I_metadata_line_12_____OKHOTSKAYA_GGC_20211101 >									
179 	//        < QloD5nHpVrv6agp897MmP8Y1REDJ5206wwr7t8E38425oQ36Lz0e9i2s8Zwef8im >									
180 	//        <  u =="0.000000000000000001" : ] 000000167263039.180982000000000000 ; 000000182697409.443974000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000000FF3920116C62D >									
182 	//     < RUSS_PFXVI_I_metadata_line_13_____INTER_GOLD_CAPITAL_20211101 >									
183 	//        < D6czw3SL6sPSmZ1x7cENeS3tRF9At57Fcrj12wMf1n24py3G33o4eE86iw3yrIX9 >									
184 	//        <  u =="0.000000000000000001" : ] 000000182697409.443974000000000000 ; 000000197467930.446776000000000000 ] >									
185 	//        < 0x00000000000000000000000000000000000000000000000000116C62D12D4FE9 >									
186 	//     < RUSS_PFXVI_I_metadata_line_14_____POLYMETAL_AURUM_20211101 >									
187 	//        < 6sB02HcD08GuEcfgTc2Lp7y50mRTIsP8HTfurDqF458Ols5qKe1692q25Lulpoly >									
188 	//        <  u =="0.000000000000000001" : ] 000000197467930.446776000000000000 ; 000000210952386.279435000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000012D4FE9141E347 >									
190 	//     < RUSS_PFXVI_I_metadata_line_15_____KIRANKAN_OOO_20211101 >									
191 	//        < Bp5Aui8lB47gaoz8X29Q0ur498Dwr9t7SJZw7af36OD1Q5P99I8putCu4k9t98C6 >									
192 	//        <  u =="0.000000000000000001" : ] 000000210952386.279435000000000000 ; 000000225558286.390600000000000000 ] >									
193 	//        < 0x00000000000000000000000000000000000000000000000000141E3471582CB5 >									
194 	//     < RUSS_PFXVI_I_metadata_line_16_____OKHOTSK_MINING_GEOLOGICAL_CO_20211101 >									
195 	//        < 27qZ46F8oNhB14KOHN6z6oI1fU7BbUTp1P8a4nNG9BWPb31007Fr30d6bRg2rb77 >									
196 	//        <  u =="0.000000000000000001" : ] 000000225558286.390600000000000000 ; 000000240304109.967268000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000001582CB516EACCB >									
198 	//     < RUSS_PFXVI_I_metadata_line_17_____AYAX_PROSPECTORS_ARTEL_CO_20211101 >									
199 	//        < MB9Q5GX06IcKQUB0GHc7QODAuEa99B3Wfoibml4U57c0Rl344Jk3KzgK5n3qLb7m >									
200 	//        <  u =="0.000000000000000001" : ] 000000240304109.967268000000000000 ; 000000254600075.128677000000000000 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000000016EACCB1847D28 >									
202 	//     < RUSS_PFXVI_I_metadata_line_18_____POLYMETAL_INDUSTRIA_20211101 >									
203 	//        < 149bvi1f323Cb2tg28q4JABB85fof6E1s4rR6D3hO94sWqj388s4Q66G5NTXQgfW >									
204 	//        <  u =="0.000000000000000001" : ] 000000254600075.128677000000000000 ; 000000270876620.479893000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000001847D2819D532E >									
206 	//     < RUSS_PFXVI_I_metadata_line_19_____ASHANTI_POLYMET_STRATE_ALL_MANCO_20211101 >									
207 	//        < 4H39M7yhE6Zumo7wAWffLkwYzBmcRP3S6QIK7Y0e878e32tBe8C0FMeVYoeZmznq >									
208 	//        <  u =="0.000000000000000001" : ] 000000270876620.479893000000000000 ; 000000284332899.057164000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000000019D532E1B1DB8A >									
210 	//     < RUSS_PFXVI_I_metadata_line_20_____RUDNIK_AVLAYAKAN_20211101 >									
211 	//        < 563pdfM0u8E005956jTkWwLtyf054VsYZKtZFUxHOc6BjXecm196mvw4tTCSjVrD >									
212 	//        <  u =="0.000000000000000001" : ] 000000284332899.057164000000000000 ; 000000298008668.665221000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000001B1DB8A1C6B9A3 >									
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
256 	//     < RUSS_PFXVI_I_metadata_line_21_____OLYMP_OOO_20211101 >									
257 	//        < 09C87liyiMz8L3p10GUsSv90kM2ATX1eqKZH97WSLSQz8Jj7vcTTvlIDhZHZV0jY >									
258 	//        <  u =="0.000000000000000001" : ] 000000298008668.665221000000000000 ; 000000314875823.703410000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000001C6B9A31E0765E >									
260 	//     < RUSS_PFXVI_I_metadata_line_22_____SEMCHENSKOYE_ZOLOTO_20211101 >									
261 	//        < f64Uiu8ztjavJvszRHmj6rR2pvk7fhi2HEFW823Q2uB1Rd9d7acSaOe8WIv0Dcfz >									
262 	//        <  u =="0.000000000000000001" : ] 000000314875823.703410000000000000 ; 000000328355937.284932000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000001E0765E1F5080A >									
264 	//     < RUSS_PFXVI_I_metadata_line_23_____MAYSKOYE_20211101 >									
265 	//        < 20EtY2VQ8xc7n0oLA7ti2CLv9HmJl41dYz2RtAdwbERi0o7kcV8RT6i3w0t24W8X >									
266 	//        <  u =="0.000000000000000001" : ] 000000328355937.284932000000000000 ; 000000344874196.315213000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000001F5080A20E3C7C >									
268 	//     < RUSS_PFXVI_I_metadata_line_24_____FIANO_INVESTMENTS_20211101 >									
269 	//        < 1TQq1KhQ60JHkuT6Z4qoiw40nMl6Dk8Iu67T689R7q7b8xUV03N356JxL5m840qJ >									
270 	//        <  u =="0.000000000000000001" : ] 000000344874196.315213000000000000 ; 000000359566022.872497000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000020E3C7C224A77A >									
272 	//     < RUSS_PFXVI_I_metadata_line_25_____URAL_POLYMETAL_20211101 >									
273 	//        < PI3mU92d4EvYHj707EXYaFEzr5O04RAhIwl8CGoj4zk90260Qc3YzAQJO9Dfjsll >									
274 	//        <  u =="0.000000000000000001" : ] 000000359566022.872497000000000000 ; 000000376215933.135652000000000000 ] >									
275 	//        < 0x00000000000000000000000000000000000000000000000000224A77A23E0F59 >									
276 	//     < RUSS_PFXVI_I_metadata_line_26_____POLYMETAL_PDRUS_LLC_20211101 >									
277 	//        < JO8C96gojWk1bOdBweHIuwe02HU0O96FiY9ai6BtqAlH81ZzF1145cQ729xzXdtL >									
278 	//        <  u =="0.000000000000000001" : ] 000000376215933.135652000000000000 ; 000000391693253.510770000000000000 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000000000023E0F59255AD2D >									
280 	//     < RUSS_PFXVI_I_metadata_line_27_____VOSTOCHNY_BASIS_20211101 >									
281 	//        < 7amWjlGl4uadmiUx3aqprB0l1nXYgYz238m2Re3ox3aBF1b6RBePK78JrYGTRmj2 >									
282 	//        <  u =="0.000000000000000001" : ] 000000391693253.510770000000000000 ; 000000408955674.051511000000000000 ] >									
283 	//        < 0x00000000000000000000000000000000000000000000000000255AD2D270044F >									
284 	//     < RUSS_PFXVI_I_metadata_line_28_____SAUM_MINING_CO_20211101 >									
285 	//        < 1Hm2qcBBAI3f90q28tIbyGAk318KFacMZrTN3LQExC0ZOrgBlZUprZhsOE2M5QEg >									
286 	//        <  u =="0.000000000000000001" : ] 000000408955674.051511000000000000 ; 000000424033267.962039000000000000 ] >									
287 	//        < 0x00000000000000000000000000000000000000000000000000270044F28705FF >									
288 	//     < RUSS_PFXVI_I_metadata_line_29_____ALBAZINO_RESOURCES_20211101 >									
289 	//        < h774nrpmG2H68b15GwfmPrCKb896LeqQw9Lh5Cyk8J47qZk9643768mWsvGJL7E6 >									
290 	//        <  u =="0.000000000000000001" : ] 000000424033267.962039000000000000 ; 000000437380812.724830000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000028705FF29B63E1 >									
292 	//     < RUSS_PFXVI_I_metadata_line_30_____POLYMETAL_INDUSTRIYA_20211101 >									
293 	//        < oD2XCBMblBcKOgCYa8Df8x1dNG648u226f65MWK10fv6Db5Taxg6mi7fEvB6xIhX >									
294 	//        <  u =="0.000000000000000001" : ] 000000437380812.724830000000000000 ; 000000450891474.004395000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000029B63E12B0017B >									
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
338 	//     < RUSS_PFXVI_I_metadata_line_31_____AS_APK_HOLDINGS_LIMITED_20211101 >									
339 	//        < J8H76BJrWbl69wbMcuNH23zWvh5X9pb8BIJ012PMJP71Xs586Cw2CFG8p7BO4XoM >									
340 	//        <  u =="0.000000000000000001" : ] 000000450891474.004395000000000000 ; 000000467755125.680552000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000002B0017B2C9BCD9 >									
342 	//     < RUSS_PFXVI_I_metadata_line_32_____POLAR_SILVER_RESOURCES_20211101 >									
343 	//        < 3xzPQQkE0iyV2dYvwAlI3FBDsKkuvUCt05z3mur8z04bzz2eQcD52U0u56Hyp5mo >									
344 	//        <  u =="0.000000000000000001" : ] 000000467755125.680552000000000000 ; 000000483684835.367231000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000002C9BCD92E20B64 >									
346 	//     < RUSS_PFXVI_I_metadata_line_33_____PMTL_HOLDING_LIMITED_20211101 >									
347 	//        < DSgTv17z2x99Jm9qI56R031tTUCOl9tYv9h8rd95Im2mgdhrJr1yrKaz5epLWg9C >									
348 	//        <  u =="0.000000000000000001" : ] 000000483684835.367231000000000000 ; 000000500550651.827518000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000002E20B642FBC799 >									
350 	//     < RUSS_PFXVI_I_metadata_line_34_____ALBAZINO_RESOURCES_LIMITED_20211101 >									
351 	//        < yzzM8nr3vlZ4gF45O4YSo02i24fVZ7M67JRQR88r16n5CM94j9n3mUO80Kmq0Rs3 >									
352 	//        <  u =="0.000000000000000001" : ] 000000500550651.827518000000000000 ; 000000514835667.073618000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000002FBC79931193AF >									
354 	//     < RUSS_PFXVI_I_metadata_line_35_____RUDNIK_KVARTSEVYI_20211101 >									
355 	//        < 4GNy8So78Q6zoJf33pc072S9TELH2Wxe7a2AwQLO1MWn3il5HU8VV054s6s41Wz0 >									
356 	//        <  u =="0.000000000000000001" : ] 000000514835667.073618000000000000 ; 000000530457479.734098000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000031193AF32969F4 >									
358 	//     < RUSS_PFXVI_I_metadata_line_36_____NEVYANSK_GROUP_20211101 >									
359 	//        < vMdLJJzZpkW412p9ZXh8FA4Xt1AWCTINPSRQ3y6JvS1J8WY56BrYj5M2tf9M6oKI >									
360 	//        <  u =="0.000000000000000001" : ] 000000530457479.734098000000000000 ; 000000543530032.656885000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000032969F433D5C6B >									
362 	//     < RUSS_PFXVI_I_metadata_line_37_____AMURSK_HYDROMETALL_PLANT_20211101 >									
363 	//        < A5N2q9fm4P1Xa3sjDa9Te12HU6ox6Pz9337x3znmFJnDh25nF8W6GH24XnW226HF >									
364 	//        <  u =="0.000000000000000001" : ] 000000543530032.656885000000000000 ; 000000557330037.062591000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000033D5C6B3526B0C >									
366 	//     < RUSS_PFXVI_I_metadata_line_38_____AMURSK_HYDROMETALL_PLANT_ORG_20211101 >									
367 	//        < Rxu1VZ4uD2nD824a8dy5cN8P791IF8382g3FnKv17rV8y14RZf1ov86zKOnPsE8A >									
368 	//        <  u =="0.000000000000000001" : ] 000000557330037.062591000000000000 ; 000000571182511.920873000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000003526B0C3678E2B >									
370 	//     < RUSS_PFXVI_I_metadata_line_39_____OKHOTSKAYA_MINING_GEO_COMPANY_20211101 >									
371 	//        < afum541TctdtnqX88B3W3hH3SDg5K048c6rKDKXS36i1qmbL1AmY2GY3qyEh075E >									
372 	//        <  u =="0.000000000000000001" : ] 000000571182511.920873000000000000 ; 000000585529587.965165000000000000 ] >									
373 	//        < 0x000000000000000000000000000000000000000000000000003678E2B37D727F >									
374 	//     < RUSS_PFXVI_I_metadata_line_40_____DUNDEE_PRECIOUS_METALS_KAPAN_20211101 >									
375 	//        < mzwQA974Di1Q6Q9ef0HA036n9o61B0uesF7nl5B8P442kb2G4lhF3Aix2f39Sp7g >									
376 	//        <  u =="0.000000000000000001" : ] 000000585529587.965165000000000000 ; 000000601718865.595943000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000037D727F396266F >									
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