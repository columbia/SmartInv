1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXXXII_II_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXXXII_II_883		"	;
8 		string	public		symbol =	"	RUSS_PFXXXII_II_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		805054958985656000000000000					;	
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
92 	//     < RUSS_PFXXXII_II_metadata_line_1_____SOLLERS_20231101 >									
93 	//        < 3YU2n3m9y55ay2o763436Q247bior1a000B37S5GsDr059s7vrdFshyDZ00461vQ >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000024449551.666655900000000000 ] >									
95 	//        < 0x0000000000000000000000000000000000000000000000000000000000254E9B >									
96 	//     < RUSS_PFXXXII_II_metadata_line_2_____UAZ_20231101 >									
97 	//        < 16Jql59s7im9EWfUI9k3y96ZPOIgfcfyqD2Q266fICh4NiwQ5011sDvR51z1CUuR >									
98 	//        <  u =="0.000000000000000001" : ] 000000024449551.666655900000000000 ; 000000049283318.010454700000000000 ] >									
99 	//        < 0x0000000000000000000000000000000000000000000000000000254E9B4B334C >									
100 	//     < RUSS_PFXXXII_II_metadata_line_3_____FORD_SOLLERS_20231101 >									
101 	//        < 638D8x8P314Gucrqqq5zQaxaB5IEnFf25tpIll0LX8rQj5m123GPBBNVnRkOA1qo >									
102 	//        <  u =="0.000000000000000001" : ] 000000049283318.010454700000000000 ; 000000071273602.885158800000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000004B334C6CC140 >									
104 	//     < RUSS_PFXXXII_II_metadata_line_4_____URALAZ_20231101 >									
105 	//        < 3n42t1qEumQ13Qh125kSND52FWY25OPBr72lCV84z1eE6p7tqV2Lp65362NBql0x >									
106 	//        <  u =="0.000000000000000001" : ] 000000071273602.885158800000000000 ; 000000091547116.119433000000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000006CC1408BB098 >									
108 	//     < RUSS_PFXXXII_II_metadata_line_5_____ZAVOLZHYE_ENGINE_FACTORY_20231101 >									
109 	//        < B70NBL8g8mDKLFS12xWA3AhfCd3HCW73O9AJ5Ov8cO12jL94NZ7b0r62i9JdnN11 >									
110 	//        <  u =="0.000000000000000001" : ] 000000091547116.119433000000000000 ; 000000107248562.066637000000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000008BB098A3A5F8 >									
112 	//     < RUSS_PFXXXII_II_metadata_line_6_____ZMA_20231101 >									
113 	//        < Yf82A9A66VUxkb02uz3fI7T38BCY0A2JAP0gF3I59y03tqLgr2pZ3awffB44jNq3 >									
114 	//        <  u =="0.000000000000000001" : ] 000000107248562.066637000000000000 ; 000000130768765.329529000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000A3A5F8C7898D >									
116 	//     < RUSS_PFXXXII_II_metadata_line_7_____MAZDA_MOTORS_MANUFACT_RUS_20231101 >									
117 	//        < Xwh47W1xYnD5Vp78w16wwVjxnjcu6GiE24mNDDu0j5LYbbtQ76Pk5dnbVk8mv8Jc >									
118 	//        <  u =="0.000000000000000001" : ] 000000130768765.329529000000000000 ; 000000149716118.999891000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000C7898DE472DC >									
120 	//     < RUSS_PFXXXII_II_metadata_line_8_____REMSERVIS_20231101 >									
121 	//        < 5Iq6v5yC7B0G82NNy7jA822m75T12ssrluihu0UxwTq37BFA8U5KI2G8W52itG36 >									
122 	//        <  u =="0.000000000000000001" : ] 000000149716118.999891000000000000 ; 000000173299001.497678000000000000 ] >									
123 	//        < 0x000000000000000000000000000000000000000000000000000E472DC1086EEC >									
124 	//     < RUSS_PFXXXII_II_metadata_line_9_____MAZDA_SOLLERS_JV_20231101 >									
125 	//        < nYN30VlCAj3MAKCaAyoo68mujB4aAwqT6VeVNj1ddvfE19vF8a2rnwPJr96roHJW >									
126 	//        <  u =="0.000000000000000001" : ] 000000173299001.497678000000000000 ; 000000198102443.397413000000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000001086EEC12E47C4 >									
128 	//     < RUSS_PFXXXII_II_metadata_line_10_____SEVERSTALAVTO_ZAO_20231101 >									
129 	//        < 00UD7CNg6xt4Pd63bAD926TJ49ic9g7q7s7FzX9yF6C10560VY7G8uLkYsH3kSXe >									
130 	//        <  u =="0.000000000000000001" : ] 000000198102443.397413000000000000 ; 000000218982324.731038000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000012E47C414E23F8 >									
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
174 	//     < RUSS_PFXXXII_II_metadata_line_11_____SEVERSTALAUTO_KAMA_20231101 >									
175 	//        < o6sdnxZJ65KWKAg2zgyqs5Y7lbeYUvx5c3g8GiAZkHA9btX7J1w4B6w9zt7DvD78 >									
176 	//        <  u =="0.000000000000000001" : ] 000000218982324.731038000000000000 ; 000000235553127.186240000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000014E23F81676CF1 >									
178 	//     < RUSS_PFXXXII_II_metadata_line_12_____KAMA_ORG_20231101 >									
179 	//        < 56akqf2yM3w9ss470A8c0bc9IN8xE42oy311g9MyB6D1X955Fn40lzF3337KjnPS >									
180 	//        <  u =="0.000000000000000001" : ] 000000235553127.186240000000000000 ; 000000260036390.019909000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000001676CF118CC8B7 >									
182 	//     < RUSS_PFXXXII_II_metadata_line_13_____DALNIY_VOSTOK_20231101 >									
183 	//        < qenDFc2DuEFkTmzOd19s19OzfOlI22KHlfZJ53oJmKQjTjcg4W3hJd1P6Nfcy3Qy >									
184 	//        <  u =="0.000000000000000001" : ] 000000260036390.019909000000000000 ; 000000283613247.239266000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000018CC8B71B0C26D >									
186 	//     < RUSS_PFXXXII_II_metadata_line_14_____DALNIY_ORG_20231101 >									
187 	//        < 0f7N1X1wNbStt53tj0c370RZ98d1RD9NWkLU0u925rc7fTRIpBa8GItG6ALmr7i3 >									
188 	//        <  u =="0.000000000000000001" : ] 000000283613247.239266000000000000 ; 000000303221608.518033000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000001B0C26D1CEADF1 >									
190 	//     < RUSS_PFXXXII_II_metadata_line_15_____SPECIAL_VEHICLES_OOO_20231101 >									
191 	//        < YzPns87839fzrkNj4e5un35TL9rU5RRImiUaA79w7PXGIpe03U3QydxizPz7d9oE >									
192 	//        <  u =="0.000000000000000001" : ] 000000303221608.518033000000000000 ; 000000318678427.843762000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000001CEADF11E643C3 >									
194 	//     < RUSS_PFXXXII_II_metadata_line_16_____MAZDDA_SOLLERS_MANUFACT_RUS_20231101 >									
195 	//        < tn1R7youI3DAW71LCKAwIgnTORcPVzM7n2POb9Ih8l4ir55OZcImtn2W7P8840Rx >									
196 	//        <  u =="0.000000000000000001" : ] 000000318678427.843762000000000000 ; 000000336855194.430389000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000001E643C3202000F >									
198 	//     < RUSS_PFXXXII_II_metadata_line_17_____TURIN_AUTO_OOO_20231101 >									
199 	//        < bqmQ3K9ulVb9DNN1YSo6hcg3jo9rO6aN6if64J89yT6hWm0Sg0r3wzTJA8QquFJF >									
200 	//        <  u =="0.000000000000000001" : ] 000000336855194.430389000000000000 ; 000000353176000.327161000000000000 ] >									
201 	//        < 0x00000000000000000000000000000000000000000000000000202000F21AE760 >									
202 	//     < RUSS_PFXXXII_II_metadata_line_18_____ZMZ_TRANSSERVICE_20231101 >									
203 	//        < UX53Jp9428098mGKB10Wxi10Og11mo9djunoMHiVSXm4siFsjb84D1x2E28O619w >									
204 	//        <  u =="0.000000000000000001" : ] 000000353176000.327161000000000000 ; 000000375583481.248401000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000021AE76023D184C >									
206 	//     < RUSS_PFXXXII_II_metadata_line_19_____SAPORT_OOO_20231101 >									
207 	//        < Jf8DrO58fL7cTiA48YPRaCxUC8W3m294VDcgJAJST8w6K8694kqe6gxy7m4OLu4W >									
208 	//        <  u =="0.000000000000000001" : ] 000000375583481.248401000000000000 ; 000000398947171.056680000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000000023D184C260BEBD >									
210 	//     < RUSS_PFXXXII_II_metadata_line_20_____TRANSPORTNIK_12_20231101 >									
211 	//        < D3k1LUCnNlMhL58WbqHIUGAqkqwY2r1JdT1jU3IO7DFFduoNvjW8G4y9m6I5cBa1 >									
212 	//        <  u =="0.000000000000000001" : ] 000000398947171.056680000000000000 ; 000000414772540.716246000000000000 ] >									
213 	//        < 0x00000000000000000000000000000000000000000000000000260BEBD278E486 >									
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
256 	//     < RUSS_PFXXXII_II_metadata_line_21_____OOO_UAZ_TEKHINSTRUMENT_20231101 >									
257 	//        < I2zvGv0hETXwa6vx4rU94f8Nq79pdcwsJl8l0idR9db80Qw167X845Mt4mI7U6wG >									
258 	//        <  u =="0.000000000000000001" : ] 000000414772540.716246000000000000 ; 000000430886648.409896000000000000 ] >									
259 	//        < 0x00000000000000000000000000000000000000000000000000278E4862917B19 >									
260 	//     < RUSS_PFXXXII_II_metadata_line_22_____ZAO_KAPITAL_20231101 >									
261 	//        < i3fS7QV0NM840URn98jx0wsS67547I72YE762xPmj3NdWwZ8Wy62E79Gdrmk2tI6 >									
262 	//        <  u =="0.000000000000000001" : ] 000000430886648.409896000000000000 ; 000000447914268.910757000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000002917B192AB7683 >									
264 	//     < RUSS_PFXXXII_II_metadata_line_23_____OOO_UAZ_DISTRIBUTION_CENTRE_20231101 >									
265 	//        < B7vaqXJD01Vk69UMk1868IKHXQ5Mjd12Ir2YhVb0Hf58m14767MoR0Hl6Dk6QMV4 >									
266 	//        <  u =="0.000000000000000001" : ] 000000447914268.910757000000000000 ; 000000472610018.857414000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000002AB76832D1254A >									
268 	//     < RUSS_PFXXXII_II_metadata_line_24_____SHTAMP_20231101 >									
269 	//        < wisB6ua00F6KSr4bfbPCU3EUQuJu0E1NpGgcC2ZKt4qz2LPy3hwTOPl4AXL3ZpJO >									
270 	//        <  u =="0.000000000000000001" : ] 000000472610018.857414000000000000 ; 000000492988199.479686000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000002D1254A2F03D84 >									
272 	//     < RUSS_PFXXXII_II_metadata_line_25_____SOLLERS_FINANS_20231101 >									
273 	//        < 9gBlHyATuv44q58jDAFNHy2RC03frcvs9NcGp3kZk2aEsnbJdbfkHWgkuBpJvZ0G >									
274 	//        <  u =="0.000000000000000001" : ] 000000492988199.479686000000000000 ; 000000514060316.321885000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002F03D8431064D0 >									
276 	//     < RUSS_PFXXXII_II_metadata_line_26_____SOLLERS_FINANCE_LLC_20231101 >									
277 	//        < P227CQ9cgwcl07907i0ytj7BzKM4664lpI18ar8TiVLO2A8cK1Xvs5EZ9P5tEl4f >									
278 	//        <  u =="0.000000000000000001" : ] 000000514060316.321885000000000000 ; 000000530068273.529148000000000000 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000000000031064D0328D1EB >									
280 	//     < RUSS_PFXXXII_II_metadata_line_27_____TORGOVIY_DOM_20231101 >									
281 	//        < S4gI93RRjattW9xHi6B0Sf8r7pS2rijh5Uqt99t7V71Dxfw2h2T89cU6dE5c0qwW >									
282 	//        <  u =="0.000000000000000001" : ] 000000530068273.529148000000000000 ; 000000552961248.166516000000000000 ] >									
283 	//        < 0x00000000000000000000000000000000000000000000000000328D1EB34BC07D >									
284 	//     < RUSS_PFXXXII_II_metadata_line_28_____SOLLERS_BUSSAN_20231101 >									
285 	//        < oM5rmCto9SgVbe10x9y0sB8b1z597ARs9eW64CK0z44H79tp9hzLE8220264b5oe >									
286 	//        <  u =="0.000000000000000001" : ] 000000552961248.166516000000000000 ; 000000577615487.795056000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000034BC07D3715F0D >									
288 	//     < RUSS_PFXXXII_II_metadata_line_29_____SEVERSTALAUTO_ISUZU_20231101 >									
289 	//        < 0LlvVbOnJJjSRZ4ybwC6T1nb9B87SMz5epZiB26V760q6J90IXc6c15K2SFwFhPu >									
290 	//        <  u =="0.000000000000000001" : ] 000000577615487.795056000000000000 ; 000000593290142.386744000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000003715F0D38949F6 >									
292 	//     < RUSS_PFXXXII_II_metadata_line_30_____SEVERSTALAUTO_ELABUGA_20231101 >									
293 	//        < 2GRk89OG498Njnuu0A2MwHO97VqyPMhG4Y1NpzAuw7SpX430wheqT37U39LdCx2d >									
294 	//        <  u =="0.000000000000000001" : ] 000000593290142.386744000000000000 ; 000000612727857.297763000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000038949F63A6F2D2 >									
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
338 	//     < RUSS_PFXXXII_II_metadata_line_31_____SOLLERS_DEVELOPMENT_20231101 >									
339 	//        < qO4uLgQFLG05ZfB357GF2lU2LxKe871V802ezJb0z45E6xJoQ1O6L3t53xReld40 >									
340 	//        <  u =="0.000000000000000001" : ] 000000612727857.297763000000000000 ; 000000628881091.390766000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000003A6F2D23BF98AD >									
342 	//     < RUSS_PFXXXII_II_metadata_line_32_____TRADE_HOUSE_SOLLERS_OOO_20231101 >									
343 	//        < 1by7r3O7Fb994jJiVj5928G28yXvTTTuDNu1v7IIAU6VrBm10VOwjSP8k7KrAHbh >									
344 	//        <  u =="0.000000000000000001" : ] 000000628881091.390766000000000000 ; 000000646097698.798608000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000003BF98AD3D9DDEA >									
346 	//     < RUSS_PFXXXII_II_metadata_line_33_____SEVERSTALAUTO_ELABUGA_LLC_20231101 >									
347 	//        < ispLF970q1F7sLKC586qim4xN0Xq70CCpMFeme24tBM44SVaP36lbq23euHb828V >									
348 	//        <  u =="0.000000000000000001" : ] 000000646097698.798608000000000000 ; 000000662447662.117510000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000003D9DDEA3F2D09E >									
350 	//     < RUSS_PFXXXII_II_metadata_line_34_____SOLLERS_PARTNER_20231101 >									
351 	//        < 8037BGG1sUOLyb73ZJ7KuRH4dJWUVyw4S3bnNeGK9EXW1CxbODmpw7R9ia35Pg2k >									
352 	//        <  u =="0.000000000000000001" : ] 000000662447662.117510000000000000 ; 000000684476511.909012000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000003F2D09E4146DA3 >									
354 	//     < RUSS_PFXXXII_II_metadata_line_35_____ULYANOVSK_CAR_PLANT_20231101 >									
355 	//        < MRx5O5M5wSkxsx0Q0zBRVnp8CPvHR3VREZu49p83fK2Jx6a4vK75US38Q9ZMxset >									
356 	//        <  u =="0.000000000000000001" : ] 000000684476511.909012000000000000 ; 000000703881153.864926000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000004146DA34320993 >									
358 	//     < RUSS_PFXXXII_II_metadata_line_36_____FPT_SOLLERS_OOO_20231101 >									
359 	//        < 0GQsJw7F729G4i6e6LWiYL0P7EgO5FE8rok80Rbm6osLOC50A5ui7aNHNK04NrwO >									
360 	//        <  u =="0.000000000000000001" : ] 000000703881153.864926000000000000 ; 000000726277021.673872000000000000 ] >									
361 	//        < 0x00000000000000000000000000000000000000000000000000432099345435F6 >									
362 	//     < RUSS_PFXXXII_II_metadata_line_37_____OOO_SPECINSTRUMENT_20231101 >									
363 	//        < GtKG490KVt92H90CT8k4XO0265w05X2R5A8Sa7BFE5qnz73nEkXGbnWvj9C8gh6O >									
364 	//        <  u =="0.000000000000000001" : ] 000000726277021.673872000000000000 ; 000000746266389.725212000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000045435F6472B64F >									
366 	//     < RUSS_PFXXXII_II_metadata_line_38_____AVTOKOMPO_KOROBKA_PEREDACH_UZLY_TR_20231101 >									
367 	//        < 538dCZq2Ks1LAzk2L8k4o668RMMS8IR6l2Z9w5oT52H7y3w0f9bhi2b9qQ4RL8p8 >									
368 	//        <  u =="0.000000000000000001" : ] 000000746266389.725212000000000000 ; 000000762532723.545830000000000000 ] >									
369 	//        < 0x00000000000000000000000000000000000000000000000000472B64F48B8858 >									
370 	//     < RUSS_PFXXXII_II_metadata_line_39_____KOLOMYAZHSKOM_AUTOCENTRE_OOO_20231101 >									
371 	//        < Pnt52f6uJ7CzMQ01anj2R9JS629WZ51xBtAs36bE17W40dusDNEsxaoWj9AS608T >									
372 	//        <  u =="0.000000000000000001" : ] 000000762532723.545830000000000000 ; 000000786185704.629903000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000048B88584AF9FCA >									
374 	//     < RUSS_PFXXXII_II_metadata_line_40_____ROSALIT_20231101 >									
375 	//        < 43Rsmm5mfXsO5wR8Hee5owsYkltEN4ll8h4EFV75NjYrnthIUt7PrRf8m3qjfBSz >									
376 	//        <  u =="0.000000000000000001" : ] 000000786185704.629903000000000000 ; 000000805054958.985656000000000000 ] >									
377 	//        < 0x000000000000000000000000000000000000000000000000004AF9FCA4CC6A98 >									
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