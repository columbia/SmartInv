1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	AZOV_PFII_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	AZOV_PFII_I_883		"	;
8 		string	public		symbol =	"	AZOV_PFII_I_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		805185563730986000000000000					;	
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
92 	//     < AZOV_PFII_I_metadata_line_1_____Td_Yug_Rusi_20211101 >									
93 	//        < 0QlzYD69674p36j15g56S1p2IcPsy45x85ANQo78DUpHUh7S4K9b59e7335ow2Ki >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000024734931.266157000000000000 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000000025BE15 >									
96 	//     < AZOV_PFII_I_metadata_line_2_____LLC_MEZ_Yug_Rusi_20211101 >									
97 	//        < 4N1F141tr67ya33tJgpKAtCqPQ78520Z7G9v5C1tt44tpHY009gOkenF2nP1LplB >									
98 	//        <  u =="0.000000000000000001" : ] 000000024734931.266157000000000000 ; 000000049426857.978467100000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000025BE154B6B5E >									
100 	//     < AZOV_PFII_I_metadata_line_3_____savola_foods_cis_20211101 >									
101 	//        < 55zvO2Z11BWo5xKwVH33Lv1W7qao817270cjRrqersAYc09IZOlo4JJyy51N3S1W >									
102 	//        <  u =="0.000000000000000001" : ] 000000049426857.978467100000000000 ; 000000066970121.748416000000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000004B6B5E663034 >									
104 	//     < AZOV_PFII_I_metadata_line_4_____labinsky_cannery_20211101 >									
105 	//        < 39wPDXKj5z7qABzArec74lj667Jd9lK54PgsDSncyGAWhEk1Fg8IM0YNdN74JT6r >									
106 	//        <  u =="0.000000000000000001" : ] 000000066970121.748416000000000000 ; 000000088283148.705335800000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000066303486B59B >									
108 	//     < AZOV_PFII_I_metadata_line_5_____jsc_chernyansky_vegetable_oil_plant_20211101 >									
109 	//        < 2h6O9K8L85qZha7f1U7l5SgSUcogQ7jH94KIZi142sRFutMQdYqVt53kZpJLf677 >									
110 	//        <  u =="0.000000000000000001" : ] 000000088283148.705335800000000000 ; 000000101244939.827303000000000000 ] >									
111 	//        < 0x000000000000000000000000000000000000000000000000000086B59B9A7CCE >									
112 	//     < AZOV_PFII_I_metadata_line_6_____urazovsky_elevator_jsc_20211101 >									
113 	//        < YlMr5TwcrVw407cCnBxfS4Rjgp5N7mVMwa1AAxKYFGtFzFZ8t3re5o7E025P8Ubt >									
114 	//        <  u =="0.000000000000000001" : ] 000000101244939.827303000000000000 ; 000000127097143.502009000000000000 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000000000009A7CCEC1EF52 >									
116 	//     < AZOV_PFII_I_metadata_line_7_____ooo_orskmelprom_20211101 >									
117 	//        < Qh2qL9L71SX62b4K33R14HwWFR0l7drqP1am241DTF1FznAlMlObEIpMj8gCOG74 >									
118 	//        <  u =="0.000000000000000001" : ] 000000127097143.502009000000000000 ; 000000149238888.167364000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000C1EF52E3B871 >									
120 	//     < AZOV_PFII_I_metadata_line_8_____zolotaya_semechka_ooo_20211101 >									
121 	//        < jG31sNcH4hfDUgk1NZsKkMJ0S9vZqBCVed27F9Xw0m04N6PMNY137roYh8uljvDG >									
122 	//        <  u =="0.000000000000000001" : ] 000000149238888.167364000000000000 ; 000000166471850.687895000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000E3B871FE0411 >									
124 	//     < AZOV_PFII_I_metadata_line_9_____ooo_grain_union_20211101 >									
125 	//        < Rm4bz0MZNkC47238P7vf4l91MR2Qx0nzugocH0fpl4n6QzsNKo7WwpK9j5C0ud2M >									
126 	//        <  u =="0.000000000000000001" : ] 000000166471850.687895000000000000 ; 000000190132151.931367000000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000000FE04111221E5F >									
128 	//     < AZOV_PFII_I_metadata_line_10_____valuysky_vegetable_oil_plant_20211101 >									
129 	//        < 3o5skmpbxV5W33Om8cH3yY5mC3shGD02Wy7mrCavUygmhk9Shh3mY80BGIbZg8M1 >									
130 	//        <  u =="0.000000000000000001" : ] 000000190132151.931367000000000000 ; 000000213633480.013637000000000000 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000000001221E5F145FA94 >									
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
174 	//     < AZOV_PFII_I_metadata_line_11_____ooo_yugagro_leasing_20211101 >									
175 	//        < kpL5Z51Ef5D1vxx0N9DXcSi8jU0S9Ue5W14PQ9R24ati2j2xn3GK90p57E33T6kq >									
176 	//        <  u =="0.000000000000000001" : ] 000000213633480.013637000000000000 ; 000000238519482.920000000000000000 ] >									
177 	//        < 0x00000000000000000000000000000000000000000000000000145FA9416BF3AC >									
178 	//     < AZOV_PFII_I_metadata_line_12_____torgovy_dom_yug_rusi_ooo_20211101 >									
179 	//        < 62AJqgwpy1Jr22KwatUZ24kwz57cDARfNZ9e37Ad7hCVz11Q04dgbUDaK59l7oxO >									
180 	//        <  u =="0.000000000000000001" : ] 000000238519482.920000000000000000 ; 000000262707093.760388000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000016BF3AC190DBF5 >									
182 	//     < AZOV_PFII_I_metadata_line_13_____trading_house_wj_cis_20211101 >									
183 	//        < QANwr2i36iQd0cdW80FT4tTT1HdezCk2NZXDiQg096HUi4hoU9Ed46WeM2m7Xt25 >									
184 	//        <  u =="0.000000000000000001" : ] 000000262707093.760388000000000000 ; 000000282191553.518457000000000000 ] >									
185 	//        < 0x00000000000000000000000000000000000000000000000000190DBF51AE9713 >									
186 	//     < AZOV_PFII_I_metadata_line_14_____ojsc_tselinkhlebprodukt_20211101 >									
187 	//        < RuNqul876DZAmPEJ3ejN3PP1xtV2H3R6vRK41wR1n922tW0vab61i6yo54u08kl9 >									
188 	//        <  u =="0.000000000000000001" : ] 000000282191553.518457000000000000 ; 000000297603001.120459000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000001AE97131C61B2C >									
190 	//     < AZOV_PFII_I_metadata_line_15_____ooo_orskaya_pasta_factory_20211101 >									
191 	//        < 5F86y3Y36L6F6wSo8P07EP8kFwRv0y4Z1KKI8F93vU4EV0LZhrci0MuhhV3SctaH >									
192 	//        <  u =="0.000000000000000001" : ] 000000297603001.120459000000000000 ; 000000313343704.061238000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000001C61B2C1DE1FE2 >									
194 	//     < AZOV_PFII_I_metadata_line_16_____Azs Yug Rusi_20211101 >									
195 	//        < BvGEm7CsfW388Dq68RS3T881o9yTt98f7V6UNt301tV7T30m08Ye6pCH0echNUrW >									
196 	//        <  u =="0.000000000000000001" : ] 000000313343704.061238000000000000 ; 000000329456623.305375000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000001DE1FE21F6B5FE >									
198 	//     < AZOV_PFII_I_metadata_line_17_____Bina_grup_20211101 >									
199 	//        < VfDBulV8VO062ism3bBwKzl3KYoz1zDto03z34Uo3CNSSPx81ezQ8074SeOQFOgq >									
200 	//        <  u =="0.000000000000000001" : ] 000000329456623.305375000000000000 ; 000000343811248.719089000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000001F6B5FE20C9D45 >									
202 	//     < AZOV_PFII_I_metadata_line_18_____BINA_INTEGRATED_TECHNOLOGY_SDN_BHD_20211101 >									
203 	//        < peBp1NoHN0gHxkq8qlbPs0hioV53S4BZrexe6pcRgTg737P2Nqt3ExdnkfWjEi1L >									
204 	//        <  u =="0.000000000000000001" : ] 000000343811248.719089000000000000 ; 000000362703653.575107000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000020C9D45229711D >									
206 	//     < AZOV_PFII_I_metadata_line_19_____BINA_INTEGRATED_INDUSTRIES_SDN_BHD_20211101 >									
207 	//        < 2VtDhV32582sxf9j86081eAZ90240lY6d7W54Z96Z7tb3jRsWipgCFg3j8U3hL25 >									
208 	//        <  u =="0.000000000000000001" : ] 000000362703653.575107000000000000 ; 000000386787210.955550000000000000 ] >									
209 	//        < 0x00000000000000000000000000000000000000000000000000229711D24E30C1 >									
210 	//     < AZOV_PFII_I_metadata_line_20_____BINA_PAINT_MARKETING_SDN_BHD_20211101 >									
211 	//        < 1jgn88CEJwNGODyPeXofM4tCVH0kb3n34Ay12G389qdft138UHhP3u90l453w4yd >									
212 	//        <  u =="0.000000000000000001" : ] 000000386787210.955550000000000000 ; 000000410441778.339486000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000024E30C127248D2 >									
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
256 	//     < AZOV_PFII_I_metadata_line_21_____Yevroplast_20211101 >									
257 	//        < C481IDt54xb1NmH94OfjT9PLlM3f1498ZIHZDGOB8SC4tgKA40tXUtaAFs3fm5k6 >									
258 	//        <  u =="0.000000000000000001" : ] 000000410441778.339486000000000000 ; 000000424697068.764348000000000000 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000000027248D2288094B >									
260 	//     < AZOV_PFII_I_metadata_line_22_____Grain_export_infrastructure_org_20211101 >									
261 	//        < BYGfnjwNDRJ97VGN4291y4j684vZvo09Epbp8eiT2kjy7YHTykKb9j4m70fpiEh2 >									
262 	//        <  u =="0.000000000000000001" : ] 000000424697068.764348000000000000 ; 000000440744867.487203000000000000 ] >									
263 	//        < 0x00000000000000000000000000000000000000000000000000288094B2A085F7 >									
264 	//     < AZOV_PFII_I_metadata_line_23_____Kherson_Port_org_20211101 >									
265 	//        < 02R4ur9u888yNqB207jnY8cDQ7ysF6M7TC4uJ94M96y3Y3GKUyYflQv846RR5WOy >									
266 	//        <  u =="0.000000000000000001" : ] 000000440744867.487203000000000000 ; 000000460967225.611508000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000002A085F72BF6153 >									
268 	//     < AZOV_PFII_I_metadata_line_24_____Donskoy_Tabak_20211101 >									
269 	//        < DXy5o0dwm4fIUG8O0YUJ1hvoA54TOUgFequKL2MKsXvOFUy138w747fDOF3Sjl8p >									
270 	//        <  u =="0.000000000000000001" : ] 000000460967225.611508000000000000 ; 000000479369149.411271000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000002BF61532DB7593 >									
272 	//     < AZOV_PFII_I_metadata_line_25_____Japan_Tobacco_International_20211101 >									
273 	//        < 2PnegISMg3F3JnZQDYV0or7iaq70jr6a3cmoiar1P1Ncm11392iauV638KwinV1O >									
274 	//        <  u =="0.000000000000000001" : ] 000000479369149.411271000000000000 ; 000000504145586.061400000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002DB759330143DF >									
276 	//     < AZOV_PFII_I_metadata_line_26_____Akhra_2006_20211101 >									
277 	//        < hNp5ma2hZL84tcbPrGR6Sc81cRv6uyh80w8oHL1tYe4yIMwO95GiZ7YS5H4SJEkF >									
278 	//        <  u =="0.000000000000000001" : ] 000000504145586.061400000000000000 ; 000000528496214.191541000000000000 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000000000030143DF3266BD5 >									
280 	//     < AZOV_PFII_I_metadata_line_27_____Sekap_SA_20211101 >									
281 	//        < l68ggH19k58HaZS5xhO806Mx9qEFBB5hSQdlnKtB4xx5Lr2gl3OCJ1VyMKuvh1fP >									
282 	//        <  u =="0.000000000000000001" : ] 000000528496214.191541000000000000 ; 000000545121484.017047000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000003266BD533FCA14 >									
284 	//     < AZOV_PFII_I_metadata_line_28_____jt_international_korea_inc_20211101 >									
285 	//        < kUn0grU301057b4H52LoO7KRiV1BpHS9lvEM017A1J5Q61K5E3KBlY3m1z1AtpI4 >									
286 	//        <  u =="0.000000000000000001" : ] 000000545121484.017047000000000000 ; 000000570932488.350807000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000033FCA143672C81 >									
288 	//     < AZOV_PFII_I_metadata_line_29_____tanzania_cigarette_company_20211101 >									
289 	//        < A6VArYa1SNaEXAH9GVg05s5rav2D1F4o67Z70312o8YS7PyVhI0UR9kq5KHnYGSu >									
290 	//        <  u =="0.000000000000000001" : ] 000000570932488.350807000000000000 ; 000000592244261.303952000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000003672C81387B16A >									
292 	//     < AZOV_PFII_I_metadata_line_30_____jt_international_holding_bv_20211101 >									
293 	//        < La9IFbYcUR8S8h3sp5U69XvGwRjERg4qeQB78ASfImIIhsqGG7lp51uua4na5mul >									
294 	//        <  u =="0.000000000000000001" : ] 000000592244261.303952000000000000 ; 000000613892246.135326000000000000 ] >									
295 	//        < 0x00000000000000000000000000000000000000000000000000387B16A3A8B9A9 >									
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
338 	//     < AZOV_PFII_I_metadata_line_31_____kannenberg_barker_hail_cotton_tabacos_ltda_20211101 >									
339 	//        < JyC1prL55HMouz03KtSX3cvhN84rrICCkaL66iW9mr14FkQrG0DT6H5Yz0qT7kg1 >									
340 	//        <  u =="0.000000000000000001" : ] 000000613892246.135326000000000000 ; 000000629397266.866346000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000003A8B9A93C0624F >									
342 	//     < AZOV_PFII_I_metadata_line_32_____jt_international_iberia_sl_20211101 >									
343 	//        < 4luZWs2Pe415avGvuMKECf8p2gGH3DZX24r79gipWH4sNj5Qi3S4PX7I5kXwzb5w >									
344 	//        <  u =="0.000000000000000001" : ] 000000629397266.866346000000000000 ; 000000644754783.829534000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000003C0624F3D7D156 >									
346 	//     < AZOV_PFII_I_metadata_line_33_____jt_international_company_netherlands_bv_20211101 >									
347 	//        < 92O7aJT0F5DZdL749nKgm9hae789l94l0ApJ18x2OEI1m0r0M91l1eNu84F8frZI >									
348 	//        <  u =="0.000000000000000001" : ] 000000644754783.829534000000000000 ; 000000660508446.975832000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000003D7D1563EFDB1D >									
350 	//     < AZOV_PFII_I_metadata_line_34_____Gryson_nv_20211101 >									
351 	//        < 1z6CUv6c75v9X0Y34g7RJj3YH5h7NFNGh2GFeaWM6t8r3tUYkup7479z2k2760oo >									
352 	//        <  u =="0.000000000000000001" : ] 000000660508446.975832000000000000 ; 000000685161979.296545000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000003EFDB1D4157966 >									
354 	//     < AZOV_PFII_I_metadata_line_35_____duvanska_industrija_senta_20211101 >									
355 	//        < 7S95F3E3cchQunhDka3a0NtSS82K6M7x53psiZX5Ps08rW654E7MDsh5ogKQaJY8 >									
356 	//        <  u =="0.000000000000000001" : ] 000000685161979.296545000000000000 ; 000000710351665.666279000000000000 ] >									
357 	//        < 0x00000000000000000000000000000000000000000000000000415796643BE91F >									
358 	//     < AZOV_PFII_I_metadata_line_36_____kannenberg_cia_ltda_20211101 >									
359 	//        < f7JomfdXF3jo0VP77OCQa8qWceycTW9d1VSt839A9bZlebSff44N2s72STuw2uhb >									
360 	//        <  u =="0.000000000000000001" : ] 000000710351665.666279000000000000 ; 000000732807329.622129000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000043BE91F45E2CDD >									
362 	//     < AZOV_PFII_I_metadata_line_37_____jti_leaf_services_us_llc_20211101 >									
363 	//        < zd99ehqqv1j12j0pymu09DfP05SBt334Kq6obsfm52S50tySC76xyklReW0Iptwo >									
364 	//        <  u =="0.000000000000000001" : ] 000000732807329.622129000000000000 ; 000000756093825.124011000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000045E2CDD481B527 >									
366 	//     < AZOV_PFII_I_metadata_line_38_____cigarros_la_tabacalera_mexicana_sa_cv_20211101 >									
367 	//        < 27a9S5hfZ44HRRA33UYi9FA4T3jhmQqEcVlwAiWWmbM3pmmmLVliNnD65nV7cuiM >									
368 	//        <  u =="0.000000000000000001" : ] 000000756093825.124011000000000000 ; 000000773887308.031796000000000000 ] >									
369 	//        < 0x00000000000000000000000000000000000000000000000000481B52749CDBBB >									
370 	//     < AZOV_PFII_I_metadata_line_39_____jti_pars_pjsco_20211101 >									
371 	//        < WuX10M84b9YrV95P1AywFZpK07aha57Rm70cRl9Uyz9VaGESN6CddqdxDX51B55x >									
372 	//        <  u =="0.000000000000000001" : ] 000000773887308.031796000000000000 ; 000000788695494.718646000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000049CDBBB4B3742D >									
374 	//     < AZOV_PFII_I_metadata_line_40_____jti_uk_finance_limited_20211101 >									
375 	//        < n654V65h0HOKKkx1w9y8dY5rVEOf7KfDtSAfx015e5cFJG6u6Sew79DxNw0xs8cz >									
376 	//        <  u =="0.000000000000000001" : ] 000000788695494.718646000000000000 ; 000000805185563.730986000000000000 ] >									
377 	//        < 0x000000000000000000000000000000000000000000000000004B3742D4CC9D9C >									
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