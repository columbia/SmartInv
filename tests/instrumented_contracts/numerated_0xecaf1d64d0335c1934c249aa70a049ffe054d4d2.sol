1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXXXII_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXXXII_III_883		"	;
8 		string	public		symbol =	"	RUSS_PFXXXII_III_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1014664476197950000000000000					;	
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
92 	//     < RUSS_PFXXXII_III_metadata_line_1_____SOLLERS_20251101 >									
93 	//        < QB0WkDoK55Ye8nkH567c62I944krhB1zaS4UDXaac76dgecPnwpTnxfyG0a3Doil >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000020411808.213200000000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000001F255D >									
96 	//     < RUSS_PFXXXII_III_metadata_line_2_____UAZ_20251101 >									
97 	//        < A767aHWm01gL36h0p6vF4X3y5taA95a2et7r3W4Og2BfgO4bm2u0Eab2ksYZVIEA >									
98 	//        <  u =="0.000000000000000001" : ] 000000020411808.213200000000000000 ; 000000054233804.459359100000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000001F255D52C114 >									
100 	//     < RUSS_PFXXXII_III_metadata_line_3_____FORD_SOLLERS_20251101 >									
101 	//        < J53aUw5HWQ2txgH9nM573EaQ33pyb2bwvsKR03A0LWJ9P1DaSEGeScd63wBTjKsF >									
102 	//        <  u =="0.000000000000000001" : ] 000000054233804.459359100000000000 ; 000000079285051.072379400000000000 ] >									
103 	//        < 0x000000000000000000000000000000000000000000000000000052C11478FAB9 >									
104 	//     < RUSS_PFXXXII_III_metadata_line_4_____URALAZ_20251101 >									
105 	//        < 2mo6hOdVaA6RSG3L0RvCvIm2F66UQm9zt6Oe52Ho8W6o73OCqMS6UmLMrI6hHirl >									
106 	//        <  u =="0.000000000000000001" : ] 000000079285051.072379400000000000 ; 000000113072838.467520000000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000078FAB9AC8914 >									
108 	//     < RUSS_PFXXXII_III_metadata_line_5_____ZAVOLZHYE_ENGINE_FACTORY_20251101 >									
109 	//        < YJQgmcHIsntt2BcS0usa1oE8ImDz7n48ECl4ZFXrQFAdsR95NnK82k3zOut6Mus0 >									
110 	//        <  u =="0.000000000000000001" : ] 000000113072838.467520000000000000 ; 000000140151447.655070000000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000AC8914D5DAA9 >									
112 	//     < RUSS_PFXXXII_III_metadata_line_6_____ZMA_20251101 >									
113 	//        < EuUSij5oavIe1StYtHaz93yyct34Zo4z6Y418QY3pdatWF087JU6v675W3M4ia4C >									
114 	//        <  u =="0.000000000000000001" : ] 000000140151447.655070000000000000 ; 000000165634089.976039000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000D5DAA9FCBCD1 >									
116 	//     < RUSS_PFXXXII_III_metadata_line_7_____MAZDA_MOTORS_MANUFACT_RUS_20251101 >									
117 	//        < ZjEn0vAWa3Oo5Juy99BoCP8ug02Ly6n98h7Q420HN3j61v3iXuRw25Vecp1FoHht >									
118 	//        <  u =="0.000000000000000001" : ] 000000165634089.976039000000000000 ; 000000190729925.956328000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000000FCBCD112307E1 >									
120 	//     < RUSS_PFXXXII_III_metadata_line_8_____REMSERVIS_20251101 >									
121 	//        < Av8dg50cA4QVlOJ3MygVI3051V9Y8E2u5I2g99cEg04DOyt23bNzFfl8KGB53N28 >									
122 	//        <  u =="0.000000000000000001" : ] 000000190729925.956328000000000000 ; 000000212756622.539535000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000012307E1144A40E >									
124 	//     < RUSS_PFXXXII_III_metadata_line_9_____MAZDA_SOLLERS_JV_20251101 >									
125 	//        < V8ZN71SS8nO9BPxSumb0YkT759iD530hTkUhlsh8x2FkExV614uYY9I340685763 >									
126 	//        <  u =="0.000000000000000001" : ] 000000212756622.539535000000000000 ; 000000240299437.999191000000000000 ] >									
127 	//        < 0x00000000000000000000000000000000000000000000000000144A40E16EAAF8 >									
128 	//     < RUSS_PFXXXII_III_metadata_line_10_____SEVERSTALAVTO_ZAO_20251101 >									
129 	//        < 6VJl2JXl78WFal3z7NqH50gEPk1eS1uNS1K1V5BjFToYkiBD49B2nH15emK5uOSy >									
130 	//        <  u =="0.000000000000000001" : ] 000000240299437.999191000000000000 ; 000000262491982.127573000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000016EAAF819087EE >									
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
174 	//     < RUSS_PFXXXII_III_metadata_line_11_____SEVERSTALAUTO_KAMA_20251101 >									
175 	//        < oe3OW4446Sxfz53sK72RH2USKn007mV028kt22cvuG932Q58fz9PdF8B7TK83RE9 >									
176 	//        <  u =="0.000000000000000001" : ] 000000262491982.127573000000000000 ; 000000281797085.567755000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000019087EE1ADFCFD >									
178 	//     < RUSS_PFXXXII_III_metadata_line_12_____KAMA_ORG_20251101 >									
179 	//        < Dw6OrEn72t7sTh5DP333maIcymIZit5Jf85q6974pr0geAXBBCYJ584d1KHfU8Pi >									
180 	//        <  u =="0.000000000000000001" : ] 000000281797085.567755000000000000 ; 000000313874133.790690000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000001ADFCFD1DEEF15 >									
182 	//     < RUSS_PFXXXII_III_metadata_line_13_____DALNIY_VOSTOK_20251101 >									
183 	//        < 96UVaKCrJbXp2910J4cML0W5IyPxtL17YPl084AzlO5HxTOkg33OaRYb14u4dt4n >									
184 	//        <  u =="0.000000000000000001" : ] 000000313874133.790690000000000000 ; 000000340370935.188923000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001DEEF152075D66 >									
186 	//     < RUSS_PFXXXII_III_metadata_line_14_____DALNIY_ORG_20251101 >									
187 	//        < 1Qc9iI6PTiHjD0s0g92VeJY4H6JyEVbNrGFA77221r6Y9qd3HtfQR22glUCJQPC0 >									
188 	//        <  u =="0.000000000000000001" : ] 000000340370935.188923000000000000 ; 000000361851469.935255000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000002075D66228243B >									
190 	//     < RUSS_PFXXXII_III_metadata_line_15_____SPECIAL_VEHICLES_OOO_20251101 >									
191 	//        < HqO1Bofo9QoDOp7wVGQ1hsiwgGE621uhXWFm6MlX55Kje296qdBzQFjVsPy6w2cf >									
192 	//        <  u =="0.000000000000000001" : ] 000000361851469.935255000000000000 ; 000000387186195.691127000000000000 ] >									
193 	//        < 0x00000000000000000000000000000000000000000000000000228243B24ECC9C >									
194 	//     < RUSS_PFXXXII_III_metadata_line_16_____MAZDDA_SOLLERS_MANUFACT_RUS_20251101 >									
195 	//        < ZqV0D0yaT1I0XOtbF488bjMUjkQktD0IvkyLpdO26Qal8Ur6XN903PMa6lv8k3J9 >									
196 	//        <  u =="0.000000000000000001" : ] 000000387186195.691127000000000000 ; 000000418169947.955252000000000000 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000000024ECC9C27E13A3 >									
198 	//     < RUSS_PFXXXII_III_metadata_line_17_____TURIN_AUTO_OOO_20251101 >									
199 	//        < ZIQCuOmooKHb7wGw7fdHo8VyQG2ik4R0hR5T53335VX86sgWz90gLPVc51DVLR14 >									
200 	//        <  u =="0.000000000000000001" : ] 000000418169947.955252000000000000 ; 000000443260074.489246000000000000 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000000027E13A32A45C77 >									
202 	//     < RUSS_PFXXXII_III_metadata_line_18_____ZMZ_TRANSSERVICE_20251101 >									
203 	//        < S88s2vVantlXvPF90j72cJ2BFau3o5dC459jfX5OK382SkB9utRQ0t0RMXiJLymY >									
204 	//        <  u =="0.000000000000000001" : ] 000000443260074.489246000000000000 ; 000000465518192.930966000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000002A45C772C6530B >									
206 	//     < RUSS_PFXXXII_III_metadata_line_19_____SAPORT_OOO_20251101 >									
207 	//        < Ph41I4cd76ltP17v39Nxvh3cjApB703O9vOLXHd4Jfb7eKCTm8s03DIgFXwzrAvD >									
208 	//        <  u =="0.000000000000000001" : ] 000000465518192.930966000000000000 ; 000000486773925.534241000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000002C6530B2E6C211 >									
210 	//     < RUSS_PFXXXII_III_metadata_line_20_____TRANSPORTNIK_12_20251101 >									
211 	//        < 2D919eFYDir0bXTl759yzkUmI2I4p7ncR5zGtTU7268Us1OAe9EDyQJSHop9x05E >									
212 	//        <  u =="0.000000000000000001" : ] 000000486773925.534241000000000000 ; 000000512975493.163988000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000002E6C21130EBD0D >									
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
256 	//     < RUSS_PFXXXII_III_metadata_line_21_____OOO_UAZ_TEKHINSTRUMENT_20251101 >									
257 	//        < 1Lp57G2qR6klPM6o04aNs3e3Jw5gW8xV836eORzkBPftVmm235mKZT8Y91az8uK6 >									
258 	//        <  u =="0.000000000000000001" : ] 000000512975493.163988000000000000 ; 000000533965050.951276000000000000 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000000030EBD0D32EC419 >									
260 	//     < RUSS_PFXXXII_III_metadata_line_22_____ZAO_KAPITAL_20251101 >									
261 	//        < u33571P51169GRAm20F5x6FmTuJt3l7AW92BGNfNne0wg68XQOxL71f91KafK93Y >									
262 	//        <  u =="0.000000000000000001" : ] 000000533965050.951276000000000000 ; 000000558300983.333920000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000032EC419353E652 >									
264 	//     < RUSS_PFXXXII_III_metadata_line_23_____OOO_UAZ_DISTRIBUTION_CENTRE_20251101 >									
265 	//        < jnkk1cCE6X8f33xtGy3iCTI03z9SA1B671U78m37N61L34lz4uxNR9kQehGL6KFD >									
266 	//        <  u =="0.000000000000000001" : ] 000000558300983.333920000000000000 ; 000000585420808.298532000000000000 ] >									
267 	//        < 0x00000000000000000000000000000000000000000000000000353E65237D4801 >									
268 	//     < RUSS_PFXXXII_III_metadata_line_24_____SHTAMP_20251101 >									
269 	//        < h1d8ReU9U5Z04pXMMG41PY2F311x4IFN5bycx5PwuD6OA274Ie8j3m40g2jmD6ea >									
270 	//        <  u =="0.000000000000000001" : ] 000000585420808.298532000000000000 ; 000000604499477.168302000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000037D480139A649C >									
272 	//     < RUSS_PFXXXII_III_metadata_line_25_____SOLLERS_FINANS_20251101 >									
273 	//        < 9xp3cd1i8FX49Sdac2AdVLP9htEHAnK8uf04SZ2a6CMT8DqA7lYlQ6qJ18sl3LaG >									
274 	//        <  u =="0.000000000000000001" : ] 000000604499477.168302000000000000 ; 000000626592776.467805000000000000 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000000000039A649C3BC1ACE >									
276 	//     < RUSS_PFXXXII_III_metadata_line_26_____SOLLERS_FINANCE_LLC_20251101 >									
277 	//        < 1i2Yz911JrC16IW51uC0u360tJs410Yci3O7qIs4O555s2m1oyr8ZSM6s3CZfDTr >									
278 	//        <  u =="0.000000000000000001" : ] 000000626592776.467805000000000000 ; 000000660287294.755474000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000003BC1ACE3EF84B9 >									
280 	//     < RUSS_PFXXXII_III_metadata_line_27_____TORGOVIY_DOM_20251101 >									
281 	//        < rQE76S86PDaw3vVTuT01G54FC6WDxzM9gEYc918nnWb9MmvuoIRv5vG5F4r1735A >									
282 	//        <  u =="0.000000000000000001" : ] 000000660287294.755474000000000000 ; 000000690288757.197870000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000003EF84B941D4C0C >									
284 	//     < RUSS_PFXXXII_III_metadata_line_28_____SOLLERS_BUSSAN_20251101 >									
285 	//        < r8U32IbS3nTOR3uOAIg4xkT762583509XmipPQgX0EB105UEozj043bhJ4qowDur >									
286 	//        <  u =="0.000000000000000001" : ] 000000690288757.197870000000000000 ; 000000714348134.106394000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000041D4C0C442023D >									
288 	//     < RUSS_PFXXXII_III_metadata_line_29_____SEVERSTALAUTO_ISUZU_20251101 >									
289 	//        < ow4jGL24yX2xMwuS5HDuhjEDQtqgA11570rvmNj16Q1ZbOz53qkRlet6GrLREN8B >									
290 	//        <  u =="0.000000000000000001" : ] 000000714348134.106394000000000000 ; 000000743327638.713846000000000000 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000000000442023D46E3A5C >									
292 	//     < RUSS_PFXXXII_III_metadata_line_30_____SEVERSTALAUTO_ELABUGA_20251101 >									
293 	//        < f5QFaAgXoZfEVYtK7L6OVyLBr09X2C17tgAfqyjb3p8md79tj5600T6lU1q8IK2F >									
294 	//        <  u =="0.000000000000000001" : ] 000000743327638.713846000000000000 ; 000000765086415.999337000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000046E3A5C48F6DE2 >									
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
338 	//     < RUSS_PFXXXII_III_metadata_line_31_____SOLLERS_DEVELOPMENT_20251101 >									
339 	//        < hm89kcwmX7x7tkIe121iPnBf660Y88S1201t6PrdkIdZTo82uhBviHlWa9K21941 >									
340 	//        <  u =="0.000000000000000001" : ] 000000765086415.999337000000000000 ; 000000783994008.956945000000000000 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000000000048F6DE24AC47A9 >									
342 	//     < RUSS_PFXXXII_III_metadata_line_32_____TRADE_HOUSE_SOLLERS_OOO_20251101 >									
343 	//        < 2NcgjH9FZqT5l7I11ywUHGztL8qsjP7OV07qVghFuFWt6zd98wgyn60nkWUs63dz >									
344 	//        <  u =="0.000000000000000001" : ] 000000783994008.956945000000000000 ; 000000813164258.676340000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000004AC47A94D8CA4A >									
346 	//     < RUSS_PFXXXII_III_metadata_line_33_____SEVERSTALAUTO_ELABUGA_LLC_20251101 >									
347 	//        < o260cQEi3hW4l8RV7pG90s7Q9rqZr2qE904a4Q2JcRtKl1649K0P01Ig5Yew7DFD >									
348 	//        <  u =="0.000000000000000001" : ] 000000813164258.676340000000000000 ; 000000845564889.605658000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000004D8CA4A50A3AC9 >									
350 	//     < RUSS_PFXXXII_III_metadata_line_34_____SOLLERS_PARTNER_20251101 >									
351 	//        < 6HD39Pbj2BVrShl6a7X5260h31k03111Ed6c8j419q0f1AJ7QtWijeuT7300r6t8 >									
352 	//        <  u =="0.000000000000000001" : ] 000000845564889.605658000000000000 ; 000000877838162.557437000000000000 ] >									
353 	//        < 0x0000000000000000000000000000000000000000000000000050A3AC953B7988 >									
354 	//     < RUSS_PFXXXII_III_metadata_line_35_____ULYANOVSK_CAR_PLANT_20251101 >									
355 	//        < zd8b564pHksp05Zer1uvh9nSiQv3pwXgVy9ye2E3a0GKV9EeN27r153xLmc1rPh3 >									
356 	//        <  u =="0.000000000000000001" : ] 000000877838162.557437000000000000 ; 000000901007478.681242000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000053B798855ED40C >									
358 	//     < RUSS_PFXXXII_III_metadata_line_36_____FPT_SOLLERS_OOO_20251101 >									
359 	//        < 4RNz8BkaLpXPch35RRD6lw0bKn4HM6kamfOiLmv4pPU8pLG6YF468n6Cl9Q9t2Z1 >									
360 	//        <  u =="0.000000000000000001" : ] 000000901007478.681242000000000000 ; 000000920764707.665833000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000055ED40C57CF9B7 >									
362 	//     < RUSS_PFXXXII_III_metadata_line_37_____OOO_SPECINSTRUMENT_20251101 >									
363 	//        < 5iZko5iT8rcfv1pn9c8W0Ghk6z8g1Uxs8aVmwshYhCJ9CqoX23WNE4EoTHAHqMIG >									
364 	//        <  u =="0.000000000000000001" : ] 000000920764707.665833000000000000 ; 000000946027326.155457000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000057CF9B75A385ED >									
366 	//     < RUSS_PFXXXII_III_metadata_line_38_____AVTOKOMPO_KOROBKA_PEREDACH_UZLY_TR_20251101 >									
367 	//        < HapG1yYeveeI6x791ZYakQZCnzP2pyGHOrq43Vaq4h837e50AY6e0dMD31DZ3K1h >									
368 	//        <  u =="0.000000000000000001" : ] 000000946027326.155457000000000000 ; 000000975477798.533991000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000005A385ED5D07604 >									
370 	//     < RUSS_PFXXXII_III_metadata_line_39_____KOLOMYAZHSKOM_AUTOCENTRE_OOO_20251101 >									
371 	//        < aU7ZN1gO6a4PXi43SRCkBMtxKcsAd7dIYwY6ZFmRrhCqtmhtr67K68jQqu8z1U79 >									
372 	//        <  u =="0.000000000000000001" : ] 000000975477798.533991000000000000 ; 000000995608251.814218000000000000 ] >									
373 	//        < 0x000000000000000000000000000000000000000000000000005D076045EF2D79 >									
374 	//     < RUSS_PFXXXII_III_metadata_line_40_____ROSALIT_20251101 >									
375 	//        < o7LaVQi75ZOGytYs6Lxs31HHOplNae29X9p8oyiUY4VME1YjsmYMXp0cY5H6bDpn >									
376 	//        <  u =="0.000000000000000001" : ] 000000995608251.814218000000000000 ; 000001014664476.197950000000000000 ] >									
377 	//        < 0x000000000000000000000000000000000000000000000000005EF2D7960C4150 >									
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