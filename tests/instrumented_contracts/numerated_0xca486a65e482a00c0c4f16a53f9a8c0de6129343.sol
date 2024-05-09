1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXXVIII_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXXVIII_III_883		"	;
8 		string	public		symbol =	"	RUSS_PFXXVIII_III_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1096063256603100000000000000					;	
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
92 	//     < RUSS_PFXXVIII_III_metadata_line_1_____SIBUR_GBP_20251101 >									
93 	//        < ls3FG6tXXpn0CYZ947Xz6734SzITZ1euf9wlr7v6Htq37Ue71L73roAYj2uZ0dD6 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000034614903.152719100000000000 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000000034D172 >									
96 	//     < RUSS_PFXXVIII_III_metadata_line_2_____SIBUR_USD_20251101 >									
97 	//        < U9576TCrS7t3sjW8kNvR2R7EWQ1AwJHDdjyuR8aS893sG3V4pbUzy3k1YVGhO9hp >									
98 	//        <  u =="0.000000000000000001" : ] 000000034614903.152719100000000000 ; 000000062635282.059273500000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000034D1725F92E8 >									
100 	//     < RUSS_PFXXVIII_III_metadata_line_3_____SIBUR_FINANCE_CHF_20251101 >									
101 	//        < T2DGj4NBHu5avxyQ7LU2yfzsW404sc90P2a755UvhY9gQINv66c2x42q4rgvbFem >									
102 	//        <  u =="0.000000000000000001" : ] 000000062635282.059273500000000000 ; 000000081380776.892829800000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000005F92E87C2D5E >									
104 	//     < RUSS_PFXXVIII_III_metadata_line_4_____SIBUR_FINANS_20251101 >									
105 	//        < k21FF0PnA4A41e3EdpddaK6YE69cYnEs42Mq6C9KeXZ827jxn368ZrGNyeykGc10 >									
106 	//        <  u =="0.000000000000000001" : ] 000000081380776.892829800000000000 ; 000000114678631.728210000000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000007C2D5EAEFC57 >									
108 	//     < RUSS_PFXXVIII_III_metadata_line_5_____SIBUR_SA_20251101 >									
109 	//        < uFQJdVVaGi17CsFJ2ycRFP6kHNAGCFBt70Z35DN26215VMOX8N1SVA1186216gyH >									
110 	//        <  u =="0.000000000000000001" : ] 000000114678631.728210000000000000 ; 000000143214419.334007000000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000AEFC57DA8722 >									
112 	//     < RUSS_PFXXVIII_III_metadata_line_6_____VOSTOK_LLC_20251101 >									
113 	//        < g4zytZArTP1vAVw9vB9hdZP7u01510ER9G6buvd674KE95y8IsQ7DDdXivR3p7p1 >									
114 	//        <  u =="0.000000000000000001" : ] 000000143214419.334007000000000000 ; 000000162937888.599849000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000DA8722F89F9D >									
116 	//     < RUSS_PFXXVIII_III_metadata_line_7_____BELOZERNYI_GPP_20251101 >									
117 	//        < o91hIcf28Op79gmTx3fT3ak7N21mBEVtwJy8OU0LE4Xx9hqi2d7c0HJbgeQ1AJNm >									
118 	//        <  u =="0.000000000000000001" : ] 000000162937888.599849000000000000 ; 000000195459573.104516000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000000F89F9D12A3F65 >									
120 	//     < RUSS_PFXXVIII_III_metadata_line_8_____KRASNOYARSK_SYNTHETIC_RUBBERS_PLANT_20251101 >									
121 	//        < r0wtjSe6W68Dk0733k3uhCIlBcIm2CZGFSa0eTHdKBqaWFaf46nBQVdnhM2R947A >									
122 	//        <  u =="0.000000000000000001" : ] 000000195459573.104516000000000000 ; 000000227239506.732921000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000012A3F6515ABD6F >									
124 	//     < RUSS_PFXXVIII_III_metadata_line_9_____ORTON_20251101 >									
125 	//        < 4EY43fNF666j58i2AK7rqgl9QL63254W96v2d7nxsnVdG7XUq46S7h9h7zxpngYe >									
126 	//        <  u =="0.000000000000000001" : ] 000000227239506.732921000000000000 ; 000000253091731.252027000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000015ABD6F1822FF5 >									
128 	//     < RUSS_PFXXVIII_III_metadata_line_10_____PLASTIC_GEOSYNTHETIC_20251101 >									
129 	//        < JCbC91WdGUPvrT6eGUF86P11Vns8Uaf21cbAK4BuH9aB5v5Tk3l0ROI6tKV5Rk3f >									
130 	//        <  u =="0.000000000000000001" : ] 000000253091731.252027000000000000 ; 000000283059563.389634000000000000 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000000001822FF51AFEA24 >									
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
174 	//     < RUSS_PFXXVIII_III_metadata_line_11_____TOBOLSK_COMBINED_HEAT_POWER_PLANT_20251101 >									
175 	//        < JhWb0C2uo0jfO07SSgQ7K145Zp6pF1O272Fb999q2AB01Hcz9kblrp5x1Fb63ahI >									
176 	//        <  u =="0.000000000000000001" : ] 000000283059563.389634000000000000 ; 000000302244705.432703000000000000 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000000001AFEA241CD3057 >									
178 	//     < RUSS_PFXXVIII_III_metadata_line_12_____UGRAGAZPERERABOTKA_20251101 >									
179 	//        < Efy2z96pN0fmrg90jqf19ZB1zXhu4gu64MMRG14GfM0ex535Racw9Z79R6762dkG >									
180 	//        <  u =="0.000000000000000001" : ] 000000302244705.432703000000000000 ; 000000333277947.776662000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000001CD30571FC8AB3 >									
182 	//     < RUSS_PFXXVIII_III_metadata_line_13_____UGRAGAZPERERABOTKA_GBP_20251101 >									
183 	//        < z9cy8AbcvpXB1z90tUR6k421CkhsHJU9oXo4MAwL5vcRJjNR70d1J571wEtuh3GY >									
184 	//        <  u =="0.000000000000000001" : ] 000000333277947.776662000000000000 ; 000000360932974.942781000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001FC8AB3226BD71 >									
186 	//     < RUSS_PFXXVIII_III_metadata_line_14_____UGRAGAZPERERABOTKA_BYR_20251101 >									
187 	//        < b62vFH4wC850z61bT0G7832r343zQi4spT48x9898RFJ39t3hk0N7Ysk5Znh1nY6 >									
188 	//        <  u =="0.000000000000000001" : ] 000000360932974.942781000000000000 ; 000000395683869.738726000000000000 ] >									
189 	//        < 0x00000000000000000000000000000000000000000000000000226BD7125BC403 >									
190 	//     < RUSS_PFXXVIII_III_metadata_line_15_____RUSTEP_20251101 >									
191 	//        < bYvYfx4Dintg74H3bv18T2nQDcJS45h0fAKslMXtdpa229C5k4TtT7V41iwX4w7s >									
192 	//        <  u =="0.000000000000000001" : ] 000000395683869.738726000000000000 ; 000000420400822.418885000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000025BC4032817B12 >									
194 	//     < RUSS_PFXXVIII_III_metadata_line_16_____RUSTEP_RYB_20251101 >									
195 	//        < e33Yce54NVEI9T1A62hh5p0rwjJJ592i47gDS861Xi33sXVyPSWsX2z13974zngW >									
196 	//        <  u =="0.000000000000000001" : ] 000000420400822.418885000000000000 ; 000000450734437.868044000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000002817B122AFC424 >									
198 	//     < RUSS_PFXXVIII_III_metadata_line_17_____BALTIC_BYR_20251101 >									
199 	//        < m7uj64152Ef1Hn3KScwDfJvP0s25KDiY5rqpsk54rGH1v2wi3D1vbBJp310kCRcc >									
200 	//        <  u =="0.000000000000000001" : ] 000000450734437.868044000000000000 ; 000000471145308.008337000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000002AFC4242CEE923 >									
202 	//     < RUSS_PFXXVIII_III_metadata_line_18_____ARKTIK_BYR_20251101 >									
203 	//        < 42Lic22k26Tj590GyQ934RclAU3Qz1GyKekeCLGFj3fE6e8n3iI8SM381YHHqa2w >									
204 	//        <  u =="0.000000000000000001" : ] 000000471145308.008337000000000000 ; 000000495942626.988662000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000002CEE9232F4BF97 >									
206 	//     < RUSS_PFXXVIII_III_metadata_line_19_____VOSTOK_BYR_20251101 >									
207 	//        < 4018g986gA2tTa8VE2OZfF67U6l42jsr13CFye0f5NNdPZa8MvT6ZRFMK4Xj2L60 >									
208 	//        <  u =="0.000000000000000001" : ] 000000495942626.988662000000000000 ; 000000522477214.739798000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000002F4BF9731D3CA9 >									
210 	//     < RUSS_PFXXVIII_III_metadata_line_20_____VINYL_BYR_20251101 >									
211 	//        < 9U4q99HZ0X0ypjv0HQ4Ds45NKbQkw2pr7VYAN9m8I3BJz8TkX2O5cXcK0kc85n4n >									
212 	//        <  u =="0.000000000000000001" : ] 000000522477214.739798000000000000 ; 000000547321539.048822000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000031D3CA9343257A >									
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
256 	//     < RUSS_PFXXVIII_III_metadata_line_21_____TOBOLSK_BYR_20251101 >									
257 	//        < pR33KFyQBdq5P8B0VwGl73HyNumbV33QpK3RB6Ji7vj514b3fkiTUpmPfdd1dKuD >									
258 	//        <  u =="0.000000000000000001" : ] 000000547321539.048822000000000000 ; 000000569964265.553246000000000000 ] >									
259 	//        < 0x00000000000000000000000000000000000000000000000000343257A365B24B >									
260 	//     < RUSS_PFXXVIII_III_metadata_line_22_____ACRYLATE_BYR_20251101 >									
261 	//        < UE21hOhyaJv8Wgh0wXVO437KSBu1c7A1T5pux0Clo4KXQxXHT0Zjy1tGU6BfW1T0 >									
262 	//        <  u =="0.000000000000000001" : ] 000000569964265.553246000000000000 ; 000000589157740.639807000000000000 ] >									
263 	//        < 0x00000000000000000000000000000000000000000000000000365B24B382FBBE >									
264 	//     < RUSS_PFXXVIII_III_metadata_line_23_____POLIEF_BYR_20251101 >									
265 	//        < mlGOMO6Mh1urmRFjocFATZ9jGXKd9Kj3l87yHY3K261504Zc49D16aGB0h1ploW2 >									
266 	//        <  u =="0.000000000000000001" : ] 000000589157740.639807000000000000 ; 000000615334735.959140000000000000 ] >									
267 	//        < 0x00000000000000000000000000000000000000000000000000382FBBE3AAED22 >									
268 	//     < RUSS_PFXXVIII_III_metadata_line_24_____NOVAENG_BYR_20251101 >									
269 	//        < G56dhTvO0a69WnSZCAJq9NQOz4l8SLNaSCnaEH2IgIx5He3AWJ0C2kfC4zf0DfTH >									
270 	//        <  u =="0.000000000000000001" : ] 000000615334735.959140000000000000 ; 000000649412448.225848000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000003AAED223DEECBD >									
272 	//     < RUSS_PFXXVIII_III_metadata_line_25_____BIAXP_BYR_20251101 >									
273 	//        < TBsm3Ea1ODmX2ia3WJE28F4v88sjaI3gE8uVWhNF1BLy6IV46t7586vo08H8on60 >									
274 	//        <  u =="0.000000000000000001" : ] 000000649412448.225848000000000000 ; 000000681610934.114153000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000003DEECBD4100E45 >									
276 	//     < RUSS_PFXXVIII_III_metadata_line_26_____YUGRAGAZPERERABOTKA_AB_20251101 >									
277 	//        < 99H4kH6AyGL0GLPT2784R8DCR79w79iAaiER7p1Ym7aD0U7Q4s7NO1zX23J7RIl5 >									
278 	//        <  u =="0.000000000000000001" : ] 000000681610934.114153000000000000 ; 000000705913332.908093000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000004100E454352365 >									
280 	//     < RUSS_PFXXVIII_III_metadata_line_27_____TOMSKNEFTEKHIM_AB_20251101 >									
281 	//        < 6Xp3ggqhpS34XY3U6EC504P2ZGmMyNlTSu60TvG82vhJhfAW2FTjzEqYeMnt2moC >									
282 	//        <  u =="0.000000000000000001" : ] 000000705913332.908093000000000000 ; 000000737668539.536531000000000000 ] >									
283 	//        < 0x00000000000000000000000000000000000000000000000000435236546597C6 >									
284 	//     < RUSS_PFXXVIII_III_metadata_line_28_____BALTIC_LNG_AB_20251101 >									
285 	//        < o67l5X7FoX2I5mmVkTg0V869MV180h289OK18245TaJc1FPnxlJ8JRoi9760geCc >									
286 	//        <  u =="0.000000000000000001" : ] 000000737668539.536531000000000000 ; 000000767523542.209878000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000046597C649325E2 >									
288 	//     < RUSS_PFXXVIII_III_metadata_line_29_____SIBUR_INT_AB_20251101 >									
289 	//        < I48hjPD0b4w8vW9uN0kd8AEbef25Sga35796S76Spog1F6gwfyI1GDummt34u0CY >									
290 	//        <  u =="0.000000000000000001" : ] 000000767523542.209878000000000000 ; 000000802118042.914061000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000049325E24C7EF5C >									
292 	//     < RUSS_PFXXVIII_III_metadata_line_30_____TOBOL_SK_POLIMER_AB_20251101 >									
293 	//        < Q2a6A4OKFp0WaY28VJc1blQ95IS68VRxEm0x40IDbYXDis9iIot038997f1ft452 >									
294 	//        <  u =="0.000000000000000001" : ] 000000802118042.914061000000000000 ; 000000834554868.877842000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000004C7EF5C4F96DFF >									
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
338 	//     < RUSS_PFXXVIII_III_metadata_line_31_____SIBUR_SCIENT_RD_INSTITUTE_GAS_PROCESS_AB_20251101 >									
339 	//        < eGuiWPv45ejTq5g3W0TOu1ls8Vy6nPS2PKe64p4xSztp13iq3e9yO723cNrg202Y >									
340 	//        <  u =="0.000000000000000001" : ] 000000834554868.877842000000000000 ; 000000855976035.555451000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000004F96DFF51A1DA4 >									
342 	//     < RUSS_PFXXVIII_III_metadata_line_32_____ZAPSIBNEFTEKHIM_AB_20251101 >									
343 	//        < 44GOof3U4ObNlw0482rl28bsE2728KojjtR2Z8nmh7AkJ6tGjKbm1BVG7WDm4Cc2 >									
344 	//        <  u =="0.000000000000000001" : ] 000000855976035.555451000000000000 ; 000000876900854.478369000000000000 ] >									
345 	//        < 0x0000000000000000000000000000000000000000000000000051A1DA453A0B65 >									
346 	//     < RUSS_PFXXVIII_III_metadata_line_33_____NEFTEKHIMIA_AB_20251101 >									
347 	//        < 51b2911O2v1K8FWHB1YxSLuyt4wp8UpLK7L41wxaK4g9hN8C82PFw73yrNMRacv7 >									
348 	//        <  u =="0.000000000000000001" : ] 000000876900854.478369000000000000 ; 000000908972570.815035000000000000 ] >									
349 	//        < 0x0000000000000000000000000000000000000000000000000053A0B6556AFB69 >									
350 	//     < RUSS_PFXXVIII_III_metadata_line_34_____OTECHESTVENNYE_POLIMERY_AB_20251101 >									
351 	//        < 3j9H2g80TO0oF7qP4nLIV58SNp5cM10Q9UE4cURQKY0J7sPRrhxzc7C1rF0hE81e >									
352 	//        <  u =="0.000000000000000001" : ] 000000908972570.815035000000000000 ; 000000936846606.897790000000000000 ] >									
353 	//        < 0x0000000000000000000000000000000000000000000000000056AFB6959583B5 >									
354 	//     < RUSS_PFXXVIII_III_metadata_line_35_____SIBUR_TRANS_AB_20251101 >									
355 	//        < d6g0i0seLpx89Sme9a6109ocUMzL4WD7eYdJ89Mg74t42umjs3W8Pnxl4rnfO896 >									
356 	//        <  u =="0.000000000000000001" : ] 000000936846606.897790000000000000 ; 000000958875872.428238000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000059583B55B720E3 >									
358 	//     < RUSS_PFXXVIII_III_metadata_line_36_____TOGLIATTIKAUCHUK_AB_20251101 >									
359 	//        < DF20s8TgCnFf9qGJ99Ck2FK8133iD7PZ20W2GpqFCMl1RPS6l1L7Qr6uPuSKa7Yp >									
360 	//        <  u =="0.000000000000000001" : ] 000000958875872.428238000000000000 ; 000000992944221.641723000000000000 ] >									
361 	//        < 0x000000000000000000000000000000000000000000000000005B720E35EB1CD6 >									
362 	//     < RUSS_PFXXVIII_III_metadata_line_37_____NPP_NEFTEKHIMIYA_AB_20251101 >									
363 	//        < 0JP7e22pyWu27GiLlEebe390Lz3c286iw896seIX7b4oGi15IVA6Aq6a9xoL7z19 >									
364 	//        <  u =="0.000000000000000001" : ] 000000992944221.641723000000000000 ; 000001020710231.109300000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000005EB1CD66157AEF >									
366 	//     < RUSS_PFXXVIII_III_metadata_line_38_____SIBUR_KHIMPROM_AB_20251101 >									
367 	//        < M75kc5LH6R9q5o9RTDEL2rHZci558BGfjGQ8571RCJ2rwjwNOhoj8ugJ03b3SUaK >									
368 	//        <  u =="0.000000000000000001" : ] 000001020710231.109300000000000000 ; 000001039186731.631560000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000006157AEF631AC51 >									
370 	//     < RUSS_PFXXVIII_III_metadata_line_39_____SIBUR_VOLZHSKY_AB_20251101 >									
371 	//        < md19b0Dc8MkAi0Dd31P9w38QwtP75vUmX0S57d8Zc2bnKCud2qI8GKm40Il9Z4N6 >									
372 	//        <  u =="0.000000000000000001" : ] 000001039186731.631560000000000000 ; 000001071425882.854170000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000631AC51662DDBC >									
374 	//     < RUSS_PFXXVIII_III_metadata_line_40_____VORONEZHSINTEZKAUCHUK_AB_20251101 >									
375 	//        < O48k56sk717VlHP4mqjLWJS870N5EdiTw193tES1C6S2fNw4q0DYQ9hqGo70p5l4 >									
376 	//        <  u =="0.000000000000000001" : ] 000001071425882.854170000000000000 ; 000001096063256.603100000000000000 ] >									
377 	//        < 0x00000000000000000000000000000000000000000000000000662DDBC68875B6 >									
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