1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXXVIII_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXXVIII_I_883		"	;
8 		string	public		symbol =	"	RUSS_PFXXVIII_I_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		600347546880994000000000000					;	
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
92 	//     < RUSS_PFXXVIII_I_metadata_line_1_____SIBUR_GBP_20211101 >									
93 	//        < Tevy0hs7uCau56G6QV3EXYS2n28yWu35esoLS9c642xo3Wk274fBl7hzed1x2fH9 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000013140366.627436200000000000 ] >									
95 	//        < 0x0000000000000000000000000000000000000000000000000000000000140CF5 >									
96 	//     < RUSS_PFXXVIII_I_metadata_line_2_____SIBUR_USD_20211101 >									
97 	//        < qCnVS9w6w4IhhYLiNsFwJtUGN3vvwu3AQVP4X1m39MlZ47qpj3812hDt3b7WQ5fg >									
98 	//        <  u =="0.000000000000000001" : ] 000000013140366.627436200000000000 ; 000000027249274.394538200000000000 ] >									
99 	//        < 0x0000000000000000000000000000000000000000000000000000140CF529943F >									
100 	//     < RUSS_PFXXVIII_I_metadata_line_3_____SIBUR_FINANCE_CHF_20211101 >									
101 	//        < 109BU110B7PIA3iS8uoN3ydBwI0rYdTj0e1Kc50sA1766F51yimn909Lo2rq1vVq >									
102 	//        <  u =="0.000000000000000001" : ] 000000027249274.394538200000000000 ; 000000041672934.546601200000000000 ] >									
103 	//        < 0x000000000000000000000000000000000000000000000000000029943F3F967D >									
104 	//     < RUSS_PFXXVIII_I_metadata_line_4_____SIBUR_FINANS_20211101 >									
105 	//        < C9L20bmGG0xarh2NDObHXC9s434ALLks9gIy7e0SHJXcUT4KY01bJikRaQ0qAdW9 >									
106 	//        <  u =="0.000000000000000001" : ] 000000041672934.546601200000000000 ; 000000058175788.239569800000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000003F967D58C4EB >									
108 	//     < RUSS_PFXXVIII_I_metadata_line_5_____SIBUR_SA_20211101 >									
109 	//        < XTe557Z25xW80DC9D5LIpvgI9b1jxg65j28aMs68xlzII5NlNQVPwjpgHTp7C5KE >									
110 	//        <  u =="0.000000000000000001" : ] 000000058175788.239569800000000000 ; 000000072576801.478886200000000000 ] >									
111 	//        < 0x000000000000000000000000000000000000000000000000000058C4EB6EBE50 >									
112 	//     < RUSS_PFXXVIII_I_metadata_line_6_____VOSTOK_LLC_20211101 >									
113 	//        < 4OWnR1NI6134xdgN839B5g1mutd685mr9kOScvURiJREkY1c7B6ftsiON6t9cxN5 >									
114 	//        <  u =="0.000000000000000001" : ] 000000072576801.478886200000000000 ; 000000088859595.443651500000000000 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000000000006EBE508796C8 >									
116 	//     < RUSS_PFXXVIII_I_metadata_line_7_____BELOZERNYI_GPP_20211101 >									
117 	//        < 41kFX2nU23qA34rw167EpKF9W235Tpvl85es0C8A95311ZYbacTw98QoqdZo1e98 >									
118 	//        <  u =="0.000000000000000001" : ] 000000088859595.443651500000000000 ; 000000105684499.401988000000000000 ] >									
119 	//        < 0x00000000000000000000000000000000000000000000000000008796C8A14302 >									
120 	//     < RUSS_PFXXVIII_I_metadata_line_8_____KRASNOYARSK_SYNTHETIC_RUBBERS_PLANT_20211101 >									
121 	//        < 99UEIhy2cCfyL92e91iw3WSwUSl29OL69iTz4brUA2l2YrG7xZ34XzI2j8s58ikz >									
122 	//        <  u =="0.000000000000000001" : ] 000000105684499.401988000000000000 ; 000000122535278.414528000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000A14302BAF958 >									
124 	//     < RUSS_PFXXVIII_I_metadata_line_9_____ORTON_20211101 >									
125 	//        < 051gO0Go7ht9eWo1dU1KNmElW91c4pV68m2R7pcAf6Q1v0wEkxT05VLCRM40rj67 >									
126 	//        <  u =="0.000000000000000001" : ] 000000122535278.414528000000000000 ; 000000137627496.345089000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000000BAF958D200BE >									
128 	//     < RUSS_PFXXVIII_I_metadata_line_10_____PLASTIC_GEOSYNTHETIC_20211101 >									
129 	//        < UiI5g8E0MN4h90M496E054LX086bTQUL6gL1vMei5RIa9OFTupZysVT3yz51UAY1 >									
130 	//        <  u =="0.000000000000000001" : ] 000000137627496.345089000000000000 ; 000000151168088.298990000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000000D200BEE6AA09 >									
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
174 	//     < RUSS_PFXXVIII_I_metadata_line_11_____TOBOLSK_COMBINED_HEAT_POWER_PLANT_20211101 >									
175 	//        < VYI7xKvrgDK34sYQNT88zz1nGo2mH7jMrKKA8x2G3SGfuW7afkr03ONb8chwg6aB >									
176 	//        <  u =="0.000000000000000001" : ] 000000151168088.298990000000000000 ; 000000166574459.066705000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000000E6AA09FE2C26 >									
178 	//     < RUSS_PFXXVIII_I_metadata_line_12_____UGRAGAZPERERABOTKA_20211101 >									
179 	//        < LKJJ28wy7tk67uWnRyvfb270g1S2lq8g52MjIVuKcBMml3a7064UyEvq9wxL2gVP >									
180 	//        <  u =="0.000000000000000001" : ] 000000166574459.066705000000000000 ; 000000183095215.451831000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000000FE2C261176192 >									
182 	//     < RUSS_PFXXVIII_I_metadata_line_13_____UGRAGAZPERERABOTKA_GBP_20211101 >									
183 	//        < tQhS4Zkf30Vzd2oC1I5i7nCQoMnQ36Luuyurz04824lTizM4TWg6Wuig0Uz098gh >									
184 	//        <  u =="0.000000000000000001" : ] 000000183095215.451831000000000000 ; 000000196712502.292632000000000000 ] >									
185 	//        < 0x00000000000000000000000000000000000000000000000000117619212C28D2 >									
186 	//     < RUSS_PFXXVIII_I_metadata_line_14_____UGRAGAZPERERABOTKA_BYR_20211101 >									
187 	//        < K3yuAnF4OE35H6qY48Sw7Bv3y78mWkc0807RQus5wBcnIv1nnJuzon1jT08475RI >									
188 	//        <  u =="0.000000000000000001" : ] 000000196712502.292632000000000000 ; 000000213970924.240587000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000012C28D21467E64 >									
190 	//     < RUSS_PFXXVIII_I_metadata_line_15_____RUSTEP_20211101 >									
191 	//        < 556wX6euScRkl524nN8ueKI91U9OC21nH7yt6zuS3yiJVIQp8T866j8q82lE3eyl >									
192 	//        <  u =="0.000000000000000001" : ] 000000213970924.240587000000000000 ; 000000229849713.671147000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000001467E6415EB90B >									
194 	//     < RUSS_PFXXVIII_I_metadata_line_16_____RUSTEP_RYB_20211101 >									
195 	//        < 8tZmjek27mtefq35l63LPc8Bs0GfbLQa064bJmZiAbkHEeNh17y5yMYQZ0Dl7ajw >									
196 	//        <  u =="0.000000000000000001" : ] 000000229849713.671147000000000000 ; 000000244780404.625091000000000000 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000000015EB90B1758158 >									
198 	//     < RUSS_PFXXVIII_I_metadata_line_17_____BALTIC_BYR_20211101 >									
199 	//        < 2foypzW2d1REBe5Ad8opi0ZPSB0v8oOxdb0a51YJnZ3055h72mZl24I98350u8cC >									
200 	//        <  u =="0.000000000000000001" : ] 000000244780404.625091000000000000 ; 000000259270530.609266000000000000 ] >									
201 	//        < 0x00000000000000000000000000000000000000000000000000175815818B9D8D >									
202 	//     < RUSS_PFXXVIII_I_metadata_line_18_____ARKTIK_BYR_20211101 >									
203 	//        < saci4omh1Jtik84x6KtU9prk5iMMjJ0tDOP4OYy5s3ES8pV62726Bt14ta6Lhfa0 >									
204 	//        <  u =="0.000000000000000001" : ] 000000259270530.609266000000000000 ; 000000275290782.857669000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000018B9D8D1A40F76 >									
206 	//     < RUSS_PFXXVIII_I_metadata_line_19_____VOSTOK_BYR_20211101 >									
207 	//        < 5k5i7td7UDIYkbFxfL259lbM4P8el469VUw0b48BpCKLf8ZyO00wwPuLU21dJa77 >									
208 	//        <  u =="0.000000000000000001" : ] 000000275290782.857669000000000000 ; 000000289574788.994132000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000001A40F761B9DB27 >									
210 	//     < RUSS_PFXXVIII_I_metadata_line_20_____VINYL_BYR_20211101 >									
211 	//        < 30HkW9yS2a07M01v17OHJ56ZqXS5b25Wjq4QP2bkbMISg47X5R23PyD8gc3A6F36 >									
212 	//        <  u =="0.000000000000000001" : ] 000000289574788.994132000000000000 ; 000000306683075.017726000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000001B9DB271D3F614 >									
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
256 	//     < RUSS_PFXXVIII_I_metadata_line_21_____TOBOLSK_BYR_20211101 >									
257 	//        < 04UFJfNl2B1ck4F5WVSoZqO3vLV04u3W6asPzL6NKL5DBIr2967Kb3TcJ6xgVq2G >									
258 	//        <  u =="0.000000000000000001" : ] 000000306683075.017726000000000000 ; 000000319784877.734233000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000001D3F6141E7F3F8 >									
260 	//     < RUSS_PFXXVIII_I_metadata_line_22_____ACRYLATE_BYR_20211101 >									
261 	//        < eY76wEniS5P3XsX8IH8RyOX4Tb6F83Z3mvnIJG5Y6Z1Ny1Hq782BPoPm4fbg2k7E >									
262 	//        <  u =="0.000000000000000001" : ] 000000319784877.734233000000000000 ; 000000334633798.526030000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000001E7F3F81FE9C54 >									
264 	//     < RUSS_PFXXVIII_I_metadata_line_23_____POLIEF_BYR_20211101 >									
265 	//        < bu2RGe3G0Ec1zhCN61zB8tkixd48HO6m33bXZuS3PHYgdh40XOqV9IKx096F85mr >									
266 	//        <  u =="0.000000000000000001" : ] 000000334633798.526030000000000000 ; 000000347729660.177329000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000001FE9C5421297E6 >									
268 	//     < RUSS_PFXXVIII_I_metadata_line_24_____NOVAENG_BYR_20211101 >									
269 	//        < ub3iW3J7UZ81Gp7p9xuzyc19Xaed93m757KuR85jJIy5PQvc3OG3KuqssW00zsFK >									
270 	//        <  u =="0.000000000000000001" : ] 000000347729660.177329000000000000 ; 000000363551263.099863000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000021297E622ABC36 >									
272 	//     < RUSS_PFXXVIII_I_metadata_line_25_____BIAXP_BYR_20211101 >									
273 	//        < K08amv0aw78tW68D15mYS4vPzX1Zh5WRP5ax7rZ1xGST951QlYj3GXJ474j52TJh >									
274 	//        <  u =="0.000000000000000001" : ] 000000363551263.099863000000000000 ; 000000376843116.633902000000000000 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000000000022ABC3623F0458 >									
276 	//     < RUSS_PFXXVIII_I_metadata_line_26_____YUGRAGAZPERERABOTKA_AB_20211101 >									
277 	//        < lZMN611fmoz6QuzGQ6m3o0J5ft6zyE4VgCOF434L0485XVtDli8Mrb7efnbUGCq4 >									
278 	//        <  u =="0.000000000000000001" : ] 000000376843116.633902000000000000 ; 000000392354317.584224000000000000 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000000000023F0458256AF68 >									
280 	//     < RUSS_PFXXVIII_I_metadata_line_27_____TOMSKNEFTEKHIM_AB_20211101 >									
281 	//        < 2maETw8UUnvtady32UYHZRAI2pKKAeugra3ax37BQj8ZABuy8x7j2NG9X51lHR9O >									
282 	//        <  u =="0.000000000000000001" : ] 000000392354317.584224000000000000 ; 000000406230640.914896000000000000 ] >									
283 	//        < 0x00000000000000000000000000000000000000000000000000256AF6826BDBD8 >									
284 	//     < RUSS_PFXXVIII_I_metadata_line_28_____BALTIC_LNG_AB_20211101 >									
285 	//        < Bj0f2W6Q4j3cHNBP99TLSK8hs9YT3JU52Z938VHGUCMfUl7STkXFxov609XW46A5 >									
286 	//        <  u =="0.000000000000000001" : ] 000000406230640.914896000000000000 ; 000000422963220.341962000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000026BDBD82856402 >									
288 	//     < RUSS_PFXXVIII_I_metadata_line_29_____SIBUR_INT_AB_20211101 >									
289 	//        < X3A5Svbp7B8BjZeQvY3EVuBS2L5otxkg7117IQL6w2XAo6Un3WLl497nIH9l8l54 >									
290 	//        <  u =="0.000000000000000001" : ] 000000422963220.341962000000000000 ; 000000436869684.362799000000000000 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000000000285640229A9C38 >									
292 	//     < RUSS_PFXXVIII_I_metadata_line_30_____TOBOL_SK_POLIMER_AB_20211101 >									
293 	//        < L2c43690cUwhi2S160AUg96634KQPU5p8yDLx6z5JXL272F2Y642DXEK4ELET20E >									
294 	//        <  u =="0.000000000000000001" : ] 000000436869684.362799000000000000 ; 000000452033045.367786000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000029A9C382B1BF69 >									
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
338 	//     < RUSS_PFXXVIII_I_metadata_line_31_____SIBUR_SCIENT_RD_INSTITUTE_GAS_PROCESS_AB_20211101 >									
339 	//        < 41a5uIW4R9DQc2TWDdw9xt1XEcKw64b5JgJU4tVxZT00VOBgp3q1Dv4fi290cgE5 >									
340 	//        <  u =="0.000000000000000001" : ] 000000452033045.367786000000000000 ; 000000466609111.000264000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000002B1BF692C7FD2F >									
342 	//     < RUSS_PFXXVIII_I_metadata_line_32_____ZAPSIBNEFTEKHIM_AB_20211101 >									
343 	//        < wKdxru2jMh216242Sv73a0N0r46RMmVtBJ1U32I0v3IY9ZBt2XOXmV8U3b0338aq >									
344 	//        <  u =="0.000000000000000001" : ] 000000466609111.000264000000000000 ; 000000481305516.868457000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000002C7FD2F2DE69F8 >									
346 	//     < RUSS_PFXXVIII_I_metadata_line_33_____NEFTEKHIMIA_AB_20211101 >									
347 	//        < y50Gi2JP82Vt4GYY55912ekBk84lNAVBgJvFpktiXqmkH61JmE4Pel3J5k9cMtkm >									
348 	//        <  u =="0.000000000000000001" : ] 000000481305516.868457000000000000 ; 000000494544695.952957000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000002DE69F82F29D86 >									
350 	//     < RUSS_PFXXVIII_I_metadata_line_34_____OTECHESTVENNYE_POLIMERY_AB_20211101 >									
351 	//        < 04kDcqzk4jc6MrUmP77041iKthpDjQ9WT3Y6o47Js745zooWqV6zYgH1gfZ0tecc >									
352 	//        <  u =="0.000000000000000001" : ] 000000494544695.952957000000000000 ; 000000511427972.195611000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000002F29D8630C608D >									
354 	//     < RUSS_PFXXVIII_I_metadata_line_35_____SIBUR_TRANS_AB_20211101 >									
355 	//        < Vhi53q6VOUAsdOd8F1aNOod8VgBQicRgK54Xckl18319JcvL28S8MQbHaZoPv7V4 >									
356 	//        <  u =="0.000000000000000001" : ] 000000511427972.195611000000000000 ; 000000526835726.425206000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000030C608D323E335 >									
358 	//     < RUSS_PFXXVIII_I_metadata_line_36_____TOGLIATTIKAUCHUK_AB_20211101 >									
359 	//        < W0V2uAwly8fXUS84Mv3Xz6NKXbF72u7p8tWtxzO4f41Cz38wyfweeiULN7l7X0h1 >									
360 	//        <  u =="0.000000000000000001" : ] 000000526835726.425206000000000000 ; 000000544104435.973094000000000000 ] >									
361 	//        < 0x00000000000000000000000000000000000000000000000000323E33533E3CCC >									
362 	//     < RUSS_PFXXVIII_I_metadata_line_37_____NPP_NEFTEKHIMIYA_AB_20211101 >									
363 	//        < lKjhFqp06tLK37v9z5f1T077hqos4QwPsIKC0JRa3rb0yvwIOk725ou79vsJ95Uw >									
364 	//        <  u =="0.000000000000000001" : ] 000000544104435.973094000000000000 ; 000000557072623.433306000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000033E3CCC352067E >									
366 	//     < RUSS_PFXXVIII_I_metadata_line_38_____SIBUR_KHIMPROM_AB_20211101 >									
367 	//        < 040Ps992b4n6GfW0K9i1T6X6XvO6yJNX9vR5x0f104YvOSG6oYTsVi6cC6IVGKRR >									
368 	//        <  u =="0.000000000000000001" : ] 000000557072623.433306000000000000 ; 000000571418190.226687000000000000 ] >									
369 	//        < 0x00000000000000000000000000000000000000000000000000352067E367EA3B >									
370 	//     < RUSS_PFXXVIII_I_metadata_line_39_____SIBUR_VOLZHSKY_AB_20211101 >									
371 	//        < a0yXREtMuJBN9kPP7G7q36P3F3J70552oT6Ql90jO076iLI102eO0dT6Se132n97 >									
372 	//        <  u =="0.000000000000000001" : ] 000000571418190.226687000000000000 ; 000000585222665.560538000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000367EA3B37CFA9B >									
374 	//     < RUSS_PFXXVIII_I_metadata_line_40_____VORONEZHSINTEZKAUCHUK_AB_20211101 >									
375 	//        < L7vWnjEP4U2VXek459jt3YUB1HnVMVPgGY6Cwlk5gT3VYr8l2844LxRE1t6P2WS2 >									
376 	//        <  u =="0.000000000000000001" : ] 000000585222665.560538000000000000 ; 000000600347546.880994000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000037CFA9B3940EC3 >									
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