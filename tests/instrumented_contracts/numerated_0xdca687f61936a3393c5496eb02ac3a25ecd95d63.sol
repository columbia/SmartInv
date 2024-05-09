1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	NDRV_PFVI_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	NDRV_PFVI_III_883		"	;
8 		string	public		symbol =	"	NDRV_PFVI_III_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		2024678126180670000000000000					;	
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
92 	//     < NDRV_PFVI_III_metadata_line_1_____Hannover_Re_20251101 >									
93 	//        < k9sJNvK138X2XKfY7s72VZ553t72erWA5znO247FmAl862KzP6s2foAlu6jEdfG8 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000054013008.255193400000000000 ] >									
95 	//        < 0x0000000000000000000000000000000000000000000000000000000000526AD5 >									
96 	//     < NDRV_PFVI_III_metadata_line_2_____International Insurance Company of Hannover SE_20251101 >									
97 	//        < VZepbwM7vk464nsonMLE45iUmk1recCag9Oe0Vj22iX7IKfU8sKzAB1W0LTHY7FT >									
98 	//        <  u =="0.000000000000000001" : ] 000000054013008.255193400000000000 ; 000000082940528.406727100000000000 ] >									
99 	//        < 0x0000000000000000000000000000000000000000000000000000526AD57E8EA5 >									
100 	//     < NDRV_PFVI_III_metadata_line_3_____Hannover Life Reassurance Company of America_20251101 >									
101 	//        < jgCLDH5yJ5l15Po7G2x27hNd5gWZX0i7hZK90brRsO6U0EtCOS3h95AbOl6ozk60 >									
102 	//        <  u =="0.000000000000000001" : ] 000000082940528.406727100000000000 ; 000000108595454.079861000000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000007E8EA5A5B419 >									
104 	//     < NDRV_PFVI_III_metadata_line_4_____Hannover Reinsurance_20251101 >									
105 	//        < CZdl3XQF31mROLw51gzhTuCN5AOGx52vQK0EQMTu531Z1ja7H0FeV7E6jKpC9Qk7 >									
106 	//        <  u =="0.000000000000000001" : ] 000000108595454.079861000000000000 ; 000000168826068.406538000000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000A5B4191019BAF >									
108 	//     < NDRV_PFVI_III_metadata_line_5_____Clarendon Insurance Group Inc_20251101 >									
109 	//        < ebCCycRVY0eZO4OE7c7cZRy0fb1Ul290P5bqd7U6uQO4XO9KHrdDLTr4XmaIx1HI >									
110 	//        <  u =="0.000000000000000001" : ] 000000168826068.406538000000000000 ; 000000226993856.382071000000000000 ] >									
111 	//        < 0x000000000000000000000000000000000000000000000000001019BAF15A5D7A >									
112 	//     < NDRV_PFVI_III_metadata_line_6_____Argenta Holdings plc_20251101 >									
113 	//        < OV9p5bP790WRSpilmdsaiD3SM9B2YMA2Bg2Y6ukD12PY5KtV4pst85lN7icK05tw >									
114 	//        <  u =="0.000000000000000001" : ] 000000226993856.382071000000000000 ; 000000306946230.626298000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000015A5D7A1D45CDF >									
116 	//     < NDRV_PFVI_III_metadata_line_7_____Argenta Syndicate Management Limited_20251101 >									
117 	//        < 8w1xJ056rmP26LrWaCf8qQHg5157wpu1dFE256LO3ZT9saJ2upEvj82V0I79rVrk >									
118 	//        <  u =="0.000000000000000001" : ] 000000306946230.626298000000000000 ; 000000327108977.570565000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000001D45CDF1F320F2 >									
120 	//     < NDRV_PFVI_III_metadata_line_8_____Argenta Private Capital Limited_20251101 >									
121 	//        < 5eR7rvCjESfuYJvTx0CO6L3MOp2u2VdyFMiJF4Ap95wO6ZWvDv3S1PuHcF491JLD >									
122 	//        <  u =="0.000000000000000001" : ] 000000327108977.570565000000000000 ; 000000366012148.781024000000000000 ] >									
123 	//        < 0x000000000000000000000000000000000000000000000000001F320F222E7D7F >									
124 	//     < NDRV_PFVI_III_metadata_line_9_____Argenta Tax & Corporate Services Limited_20251101 >									
125 	//        < xpHXScLa9Pdb4122ot54xcz8H53YU7Od76b2P0bdG6ynOHn4wex4VAm7Muq35Yb0 >									
126 	//        <  u =="0.000000000000000001" : ] 000000366012148.781024000000000000 ; 000000442830571.831166000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000022E7D7F2A3B4B1 >									
128 	//     < NDRV_PFVI_III_metadata_line_10_____Hannover Life Re AG_20251101 >									
129 	//        < e0mBDNhKRH06Yj8RIHeR9rRh7iVsE3tHE37XgEQzw27Z0oO6N8u7E09w3yB834Vs >									
130 	//        <  u =="0.000000000000000001" : ] 000000442830571.831166000000000000 ; 000000502057404.118296000000000000 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000000002A3B4B12FE142C >									
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
174 	//     < NDRV_PFVI_III_metadata_line_11_____Hannover Life Re of Australasia Ltd_20251101 >									
175 	//        < 9885WV136l07HQoDDyyO4v889mbf4z6h29055a5xzrDZ296fY5HdHtx89wXt2AI1 >									
176 	//        <  u =="0.000000000000000001" : ] 000000502057404.118296000000000000 ; 000000546380375.291329000000000000 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000000002FE142C341B5D6 >									
178 	//     < NDRV_PFVI_III_metadata_line_12_____Hannover Life Re of Australasia Ltd New Zealand_20251101 >									
179 	//        < smM4u364bsSl1QR32M9Tlky0jAeFv5YW2wP1Mdcrn0BDQEDS3A6p5cHmj1c2FZzJ >									
180 	//        <  u =="0.000000000000000001" : ] 000000546380375.291329000000000000 ; 000000618653104.368619000000000000 ] >									
181 	//        < 0x00000000000000000000000000000000000000000000000000341B5D63AFFD5E >									
182 	//     < NDRV_PFVI_III_metadata_line_13_____Hannover Re Ireland Designated Activity Company_20251101 >									
183 	//        < 5c70RUhP9y9Riva44gDEJO010z57pOYvvGrO4C178NPKItecG6Cyz2yKuWdt1QAP >									
184 	//        <  u =="0.000000000000000001" : ] 000000618653104.368619000000000000 ; 000000644308234.103061000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000003AFFD5E3D722E7 >									
186 	//     < NDRV_PFVI_III_metadata_line_14_____Hannover Re Guernsey PCC Limited_20251101 >									
187 	//        < iSkEXY2y07Fr0lH876JmZOTqPtT561EgoYf9MbX0ro4JjuLjsr56x9K9IDpytvoO >									
188 	//        <  u =="0.000000000000000001" : ] 000000644308234.103061000000000000 ; 000000734401110.162556000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000003D722E74609B6F >									
190 	//     < NDRV_PFVI_III_metadata_line_15_____Hannover Re Euro RE Holdings GmbH_20251101 >									
191 	//        < JNo7Q8QMe1m3IBHSKxwMsBW3SmZ0RoR0dw8xtASE8As24AzWwy5c6daL4ya7Q79H >									
192 	//        <  u =="0.000000000000000001" : ] 000000734401110.162556000000000000 ; 000000763559915.527303000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000004609B6F48D1998 >									
194 	//     < NDRV_PFVI_III_metadata_line_16_____Skandia Portfolio Management GmbH_20251101 >									
195 	//        < 56muK77N51MB9yRoVHeGf6TxYBwk7B02wBO2Tx74q28H4vNBjHsyLk478W3BefrR >									
196 	//        <  u =="0.000000000000000001" : ] 000000763559915.527303000000000000 ; 000000858513993.754839000000000000 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000000048D199851DFD07 >									
198 	//     < NDRV_PFVI_III_metadata_line_17_____Skandia Lebensversicherung AG_20251101 >									
199 	//        < 1xlL6kzMvDifN3l1mdMKCp65Gog56fGrzKcNU3CR3dJRxNwDk3t9CN7723Gpu2CL >									
200 	//        <  u =="0.000000000000000001" : ] 000000858513993.754839000000000000 ; 000000914557507.374989000000000000 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000000051DFD075738107 >									
202 	//     < NDRV_PFVI_III_metadata_line_18_____Hannover Life Reassurance Bermuda Ltd_20251101 >									
203 	//        < SD8K2JG2j0Co4qx7psRP36DgoOdlS28fguU6boqm3i1o9m7V1SxUQBea2ms0iKps >									
204 	//        <  u =="0.000000000000000001" : ] 000000914557507.374989000000000000 ; 000001005864009.101320000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000057381075FED3A1 >									
206 	//     < NDRV_PFVI_III_metadata_line_19_____Hannover Re Services Japan KK_20251101 >									
207 	//        < f82OaCo479d162Ut2oDFXlEUd1C7o1aqLEo0kNlZ0Oa7D1JvM7tbr18aPl599qXA >									
208 	//        <  u =="0.000000000000000001" : ] 000001005864009.101320000000000000 ; 000001076014632.808100000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000005FED3A1669DE37 >									
210 	//     < NDRV_PFVI_III_metadata_line_20_____Hannover Finance Inc_20251101 >									
211 	//        < 16f4j79xtT82lHRLaQc1R6e3Xd9kuy02902WTvUOef3Uyb6hVjB4CuC1hkzgFuL1 >									
212 	//        <  u =="0.000000000000000001" : ] 000001076014632.808100000000000000 ; 000001109453316.431650000000000000 ] >									
213 	//        < 0x00000000000000000000000000000000000000000000000000669DE3769CE434 >									
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
256 	//     < NDRV_PFVI_III_metadata_line_21_____Atlantic Capital Corp_20251101 >									
257 	//        < 8zsZoEIS3149UZRZvie7a6rrkj5M221Qo2VNcWKi38EZ230W21EK4UR1a85frjAY >									
258 	//        <  u =="0.000000000000000001" : ] 000001109453316.431650000000000000 ; 000001131644868.011680000000000000 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000000069CE4346BEC0C7 >									
260 	//     < NDRV_PFVI_III_metadata_line_22_____Hannover Re Bermuda Ltd_20251101 >									
261 	//        < EC7OfIkFPn4TVxteEuVNIf3Dvl312f7POKDjb7g68o38gd2997wW9q9QDT8fPTZr >									
262 	//        <  u =="0.000000000000000001" : ] 000001131644868.011680000000000000 ; 000001153128084.185960000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000006BEC0C76DF88A8 >									
264 	//     < NDRV_PFVI_III_metadata_line_23_____Hannover Re Consulting Services India Private Limited_20251101 >									
265 	//        < Pc1f21gk12Q88alFGL403sdns4Mzd7j7XJWLnku93l7WB3nR3o339G4RoO4y7rgJ >									
266 	//        <  u =="0.000000000000000001" : ] 000001153128084.185960000000000000 ; 000001215673940.047060000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000006DF88A873EF8A2 >									
268 	//     < NDRV_PFVI_III_metadata_line_24_____HDI Global Specialty SE_20251101 >									
269 	//        < bv2Y83Zryxv9MK96vDbtPM0SaPkZP7r607s546B7OQ6g38h8u46N74C91Q3ggJ17 >									
270 	//        <  u =="0.000000000000000001" : ] 000001215673940.047060000000000000 ; 000001245116558.316310000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000073EF8A276BE5A8 >									
272 	//     < NDRV_PFVI_III_metadata_line_25_____Hannover Services México SA de CV_20251101 >									
273 	//        < 5aWnGrSdc5GntfY0Hcbe0sY4h5E8ZW8L7ok5GrWg8Ukm0VDIFEO72b9uNFOs481W >									
274 	//        <  u =="0.000000000000000001" : ] 000001245116558.316310000000000000 ; 000001315190378.078710000000000000 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000000000076BE5A87D6D23E >									
276 	//     < NDRV_PFVI_III_metadata_line_26_____Hannover Re Real Estate Holdings Inc_20251101 >									
277 	//        < 53MPZ3DumsUoR36eQ923du0Wh92mGWUN04V82IdI8N0wMq8GoRSje2hH6wv4eZm4 >									
278 	//        <  u =="0.000000000000000001" : ] 000001315190378.078710000000000000 ; 000001353839576.366530000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000007D6D23E811CB96 >									
280 	//     < NDRV_PFVI_III_metadata_line_27_____GLL HRE Core Properties LP_20251101 >									
281 	//        < Grhhn2B4J8hT61ZKLF1HeO1HpO9Z7kUn5wM6zYqAd33Y51ZYrXm4699L6BI3vmXO >									
282 	//        <  u =="0.000000000000000001" : ] 000001353839576.366530000000000000 ; 000001392059858.698780000000000000 ] >									
283 	//        < 0x00000000000000000000000000000000000000000000000000811CB9684C1D62 >									
284 	//     < NDRV_PFVI_III_metadata_line_28_____Broadway101 Office Park Inc_20251101 >									
285 	//        < 04Bzqg2322bSgwBWI5sxLkkQVTlEqWOkZT6vWFkKtjOF1vaz0IzGp04hy84l28CU >									
286 	//        <  u =="0.000000000000000001" : ] 000001392059858.698780000000000000 ; 000001440068454.490070000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000084C1D628955EBD >									
288 	//     < NDRV_PFVI_III_metadata_line_29_____Broadway 101 LLC_20251101 >									
289 	//        < MD2NaXtkH2duYNamM89z8gg2S91mprpkzHt0N37EBiCV2F7C3H4mMvW8AXD0m01a >									
290 	//        <  u =="0.000000000000000001" : ] 000001440068454.490070000000000000 ; 000001503377466.777950000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000008955EBD8F5F8D3 >									
292 	//     < NDRV_PFVI_III_metadata_line_30_____5115 Sedge Corporation_20251101 >									
293 	//        < 20fbhKZhQsdR977TcJNj42U9Ldnl0r6598FrRCH5NxvqR5ZE3uXm844X890Lk9fJ >									
294 	//        <  u =="0.000000000000000001" : ] 000001503377466.777950000000000000 ; 000001582555059.305220000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000008F5F8D396EC992 >									
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
338 	//     < NDRV_PFVI_III_metadata_line_31_____Hannover Re Euro Pe Holdings Gmbh & Co Kg_20251101 >									
339 	//        < XofCQ5n34m3GLh49CHq3Q0Mnvn61h12HP3SsdlWO71211X11by6xbU75UeM1ETZm >									
340 	//        <  u =="0.000000000000000001" : ] 000001582555059.305220000000000000 ; 000001645948043.142300000000000000 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000000000096EC9929CF8474 >									
342 	//     < NDRV_PFVI_III_metadata_line_32_____Compass Insurance Company Ltd_20251101 >									
343 	//        < 2237aR3a5tpuJ9Xql9R03m29bNAUpr7Sgu16A4lkpfN8iHututtJG5Zk7gVuHb0n >									
344 	//        <  u =="0.000000000000000001" : ] 000001645948043.142300000000000000 ; 000001681218414.762480000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000009CF8474A0555F1 >									
346 	//     < NDRV_PFVI_III_metadata_line_33_____Commercial & Industrial Acceptances Pty Ltd_20251101 >									
347 	//        < 57EcJsjC0MowNwDscrfaM3S68iX5Bsv1Deo8CEVYl304UWbSoGR22YPjh2s08U6a >									
348 	//        <  u =="0.000000000000000001" : ] 000001681218414.762480000000000000 ; 000001744893175.161380000000000000 ] >									
349 	//        < 0x00000000000000000000000000000000000000000000000000A0555F1A667EE6 >									
350 	//     < NDRV_PFVI_III_metadata_line_34_____Kaith Re Ltd_20251101 >									
351 	//        < Q5WIUaDXNitdLxWlFjOo0WfSDSE1W4e08wE5yt7MZvSlAi9lMUg1B2NwdO48RLq6 >									
352 	//        <  u =="0.000000000000000001" : ] 000001744893175.161380000000000000 ; 000001825944283.976280000000000000 ] >									
353 	//        < 0x00000000000000000000000000000000000000000000000000A667EE6AE22B7C >									
354 	//     < NDRV_PFVI_III_metadata_line_35_____Leine Re_20251101 >									
355 	//        < JZMNAkl58bW93XvJ707UQv0dmYWA4Y3kz8e7ob2MF6I70OkWO91BBrpxrs93iuMH >									
356 	//        <  u =="0.000000000000000001" : ] 000001825944283.976280000000000000 ; 000001854576632.074250000000000000 ] >									
357 	//        < 0x00000000000000000000000000000000000000000000000000AE22B7CB0DDBFF >									
358 	//     < NDRV_PFVI_III_metadata_line_36_____Hannover Re Services Italy Srl_20251101 >									
359 	//        < BnIIsm51oZz9IBOZxPLkX18h8E8c92EZ24SJT3s35Y2x1aHdA8jYLdmEepqWJYNY >									
360 	//        <  u =="0.000000000000000001" : ] 000001854576632.074250000000000000 ; 000001874998331.656590000000000000 ] >									
361 	//        < 0x00000000000000000000000000000000000000000000000000B0DDBFFB2D0539 >									
362 	//     < NDRV_PFVI_III_metadata_line_37_____Hannover Services UK Ltd_20251101 >									
363 	//        < 4zsgA6GjQ503F84r999EHNq8QIDSd35wW9z1ZkP8tYQCmnVr2AP80e4Kz66RR3q6 >									
364 	//        <  u =="0.000000000000000001" : ] 000001874998331.656590000000000000 ; 000001894195536.751120000000000000 ] >									
365 	//        < 0x00000000000000000000000000000000000000000000000000B2D0539B4A5022 >									
366 	//     < NDRV_PFVI_III_metadata_line_38_____Hr Gll Central Europe Holding Gmbh_20251101 >									
367 	//        < 8ZzrH3L7KpXr3P5uRB5J28j12fRUJA430iDpTFuXduun3FXT2WUL088BLcIrX7mj >									
368 	//        <  u =="0.000000000000000001" : ] 000001894195536.751120000000000000 ; 000001919973912.355520000000000000 ] >									
369 	//        < 0x00000000000000000000000000000000000000000000000000B4A5022B71A5CF >									
370 	//     < NDRV_PFVI_III_metadata_line_39_____Hannover Re Risk Management Services India Private Limited_20251101 >									
371 	//        < TtFXp2YmbI3L25DqE7il54o9tFPsn1I8hy39J03S2200uKOVlqDpPtT1QoaFRogZ >									
372 	//        <  u =="0.000000000000000001" : ] 000001919973912.355520000000000000 ; 000001956918480.995410000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000B71A5CFBAA0548 >									
374 	//     < NDRV_PFVI_III_metadata_line_40_____HAPEP II Holding GmbH_20251101 >									
375 	//        < a676nHto6IEy3Wo9e7KU7I985tZP7o4e5QL6gn2QYJsD8h75s5lY2wAgm2dHaR84 >									
376 	//        <  u =="0.000000000000000001" : ] 000001956918480.995410000000000000 ; 000002024678126.180670000000000000 ] >									
377 	//        < 0x00000000000000000000000000000000000000000000000000BAA0548C1169E5 >									
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