1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFIX_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFIX_I_883		"	;
8 		string	public		symbol =	"	RUSS_PFIX_I_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		615632658459955000000000000					;	
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
92 	//     < RUSS_PFIX_I_metadata_line_1_____POLYUS_GOLD_20211101 >									
93 	//        < J7z1CC0c4ern255f73Bg02Pw41j041lJXNSJW2BoV20RErL4a37vLb7Gnm6h2v90 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000015844402.796562900000000000 ] >									
95 	//        < 0x0000000000000000000000000000000000000000000000000000000000182D38 >									
96 	//     < RUSS_PFIX_I_metadata_line_2_____POLYUS_GOLD_GBP_20211101 >									
97 	//        < KL5jv233yIs4A13sa271ZV4rK1ZVpwy1NUS8aobeHVZTrnFRcGkc0T1EqLzRCtKH >									
98 	//        <  u =="0.000000000000000001" : ] 000000015844402.796562900000000000 ; 000000030006234.895564300000000000 ] >									
99 	//        < 0x0000000000000000000000000000000000000000000000000000182D382DC92F >									
100 	//     < RUSS_PFIX_I_metadata_line_3_____POLYUS_GOLD_USD_20211101 >									
101 	//        < VXjxVvIWyI9r0ptxjt1VM9FB2Q43077zeWz1UoH76C1t2G48GYP8DqL48l1k0hH8 >									
102 	//        <  u =="0.000000000000000001" : ] 000000030006234.895564300000000000 ; 000000046920139.993992300000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000002DC92F47982E >									
104 	//     < RUSS_PFIX_I_metadata_line_4_____POLYUS_KRASNOYARSK_20211101 >									
105 	//        < muBDi6XLz7mBF444i6WinkVNMt0623gqC28hsc54ETeawsfAt29XGIQI7Rl47JCj >									
106 	//        <  u =="0.000000000000000001" : ] 000000046920139.993992300000000000 ; 000000063436234.322709300000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000047982E60CBC7 >									
108 	//     < RUSS_PFIX_I_metadata_line_5_____POLYUS_FINANCE_PLC_20211101 >									
109 	//        < wCN0OIfWFcy6jaCpgQ623Fv85yZ2uHJS5OlN2M79MNz933znFq8i8u5Wu5B8Ss0Z >									
110 	//        <  u =="0.000000000000000001" : ] 000000063436234.322709300000000000 ; 000000078618216.243421500000000000 ] >									
111 	//        < 0x000000000000000000000000000000000000000000000000000060CBC777F63E >									
112 	//     < RUSS_PFIX_I_metadata_line_6_____POLYUS_FINANS_FI_20211101 >									
113 	//        < sbKXk6M6n1Y3kTFc6oJ48R47veAdBOA0q9bawbZ1FiEO7EWYMhiNn6KP07FxpdhO >									
114 	//        <  u =="0.000000000000000001" : ] 000000078618216.243421500000000000 ; 000000093115809.497139200000000000 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000000000077F63E8E155D >									
116 	//     < RUSS_PFIX_I_metadata_line_7_____POLYUS_FINANS_FII_20211101 >									
117 	//        < gFfL1T2mlnHe4opP44L8Nsr19p8M7z2FX03PwbU8218Hiba4F7jsa025qh045oSh >									
118 	//        <  u =="0.000000000000000001" : ] 000000093115809.497139200000000000 ; 000000106921585.530960000000000000 ] >									
119 	//        < 0x00000000000000000000000000000000000000000000000000008E155DA3263F >									
120 	//     < RUSS_PFIX_I_metadata_line_8_____POLYUS_FINANS_FIII_20211101 >									
121 	//        < SIsXH0690bR4VkgE00XKZgf0v9dKxKcE87PImN355eC42Hl8i1BYITDstjkKw86x >									
122 	//        <  u =="0.000000000000000001" : ] 000000106921585.530960000000000000 ; 000000121082446.486278000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000A3263FB8C1D5 >									
124 	//     < RUSS_PFIX_I_metadata_line_9_____POLYUS_FINANS_FIV_20211101 >									
125 	//        < YX7k14673m4E27rnJmZ5Cpo1cY0pct3jWd8V6aT2k2r1uGgupmL6mty9KHMb30IC >									
126 	//        <  u =="0.000000000000000001" : ] 000000121082446.486278000000000000 ; 000000137547659.917771000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000000B8C1D5D1E18E >									
128 	//     < RUSS_PFIX_I_metadata_line_10_____POLYUS_FINANS_FV_20211101 >									
129 	//        < zmL0EBmVcY5KJk7pk1HZS8ssWx5idGWqch7m7Eq8dXoF7V0SO735JGG3721omIfc >									
130 	//        <  u =="0.000000000000000001" : ] 000000137547659.917771000000000000 ; 000000154300152.264400000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000000D1E18EEB717F >									
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
174 	//     < RUSS_PFIX_I_metadata_line_11_____POLYUS_FINANS_FVI_20211101 >									
175 	//        < C0RYqDwldJ902iveOj0NK6kNj31yIeR75xFQbe7Sp8R8I4TSz76kctku3l013s7i >									
176 	//        <  u =="0.000000000000000001" : ] 000000154300152.264400000000000000 ; 000000169065961.480563000000000000 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000000000EB717F101F964 >									
178 	//     < RUSS_PFIX_I_metadata_line_12_____POLYUS_FINANS_FVII_20211101 >									
179 	//        < NcIL8yB27P3d3c98TcE50JgS0w36z74k6M8pQpx8HM796Q92171CWmB4yyROyrrb >									
180 	//        <  u =="0.000000000000000001" : ] 000000169065961.480563000000000000 ; 000000185747046.082186000000000000 ] >									
181 	//        < 0x00000000000000000000000000000000000000000000000000101F96411B6D71 >									
182 	//     < RUSS_PFIX_I_metadata_line_13_____POLYUS_FINANS_FVIII_20211101 >									
183 	//        < dB0Df72VTBpm8984awniQ7BWw7h1BPgT504gKz6db4xD766x80hbUNUdwk07JJtY >									
184 	//        <  u =="0.000000000000000001" : ] 000000185747046.082186000000000000 ; 000000199727498.841276000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000011B6D71130C28E >									
186 	//     < RUSS_PFIX_I_metadata_line_14_____POLYUS_FINANS_FIX_20211101 >									
187 	//        < 4EdEUIW6V67es25QRFkeInzwlsPNe1J7g20429M4Fk1124Z9AuxlYI4wf60x256U >									
188 	//        <  u =="0.000000000000000001" : ] 000000199727498.841276000000000000 ; 000000215505687.125840000000000000 ] >									
189 	//        < 0x00000000000000000000000000000000000000000000000000130C28E148D5E9 >									
190 	//     < RUSS_PFIX_I_metadata_line_15_____POLYUS_FINANS_FX_20211101 >									
191 	//        < 9p1wdLv8T744Mh4z98knL8RA284h97FDwwMb8VguxEbQbqG5z98N9O9SGMYEoPiA >									
192 	//        <  u =="0.000000000000000001" : ] 000000215505687.125840000000000000 ; 000000231461718.211558000000000000 ] >									
193 	//        < 0x00000000000000000000000000000000000000000000000000148D5E91612EBC >									
194 	//     < RUSS_PFIX_I_metadata_line_16_____SVETLIY_20211101 >									
195 	//        < 2429Z38892MaUHNqv75D2fFi9UGqk1jsOI80ScI1p9wyr2Jv8LJbxCgh4WVn9TNE >									
196 	//        <  u =="0.000000000000000001" : ] 000000231461718.211558000000000000 ; 000000247603837.226593000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000001612EBC179D040 >									
198 	//     < RUSS_PFIX_I_metadata_line_17_____POLYUS_EXPLORATION_20211101 >									
199 	//        < 6PvLoxBV921D1mMecVy6R4P79TXGwDtdxE4R9p2y1JmmswR33AtiwxpS618Fe1RL >									
200 	//        <  u =="0.000000000000000001" : ] 000000247603837.226593000000000000 ; 000000263154621.856222000000000000 ] >									
201 	//        < 0x00000000000000000000000000000000000000000000000000179D0401918AC6 >									
202 	//     < RUSS_PFIX_I_metadata_line_18_____ZL_ZOLOTO_20211101 >									
203 	//        < s1O6KLj2u3x60aT5a3ec622Xnsn4R7H6J7PP4L251l8WlH2BN1c6PIVPyLeGEx8E >									
204 	//        <  u =="0.000000000000000001" : ] 000000263154621.856222000000000000 ; 000000276243580.380859000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000001918AC61A583A6 >									
206 	//     < RUSS_PFIX_I_metadata_line_19_____SK_FOUNDATION_LUZERN_20211101 >									
207 	//        < 9a02frf5xa68e3WN7UpdUVpMd580PaAx0EF9mHX9sr8Yk2mXL7O3c9AN3sD2MAGF >									
208 	//        <  u =="0.000000000000000001" : ] 000000276243580.380859000000000000 ; 000000292553119.738765000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000001A583A61BE6690 >									
210 	//     < RUSS_PFIX_I_metadata_line_20_____SKFL_AB_20211101 >									
211 	//        < k44iqybU4sXR0GlWx3621cTL93V7vLgoe2gYd39vbV2sXUk7r2pGb9P0xl9q6SiQ >									
212 	//        <  u =="0.000000000000000001" : ] 000000292553119.738765000000000000 ; 000000309617698.470363000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000001BE66901D8706A >									
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
256 	//     < RUSS_PFIX_I_metadata_line_21_____AB_URALKALI_20211101 >									
257 	//        < IdMj2g2mfBvsCH561o8D6BnX4DtutyT8w1Rp2is5kT6NudffVwY9xP1e2178aDha >									
258 	//        <  u =="0.000000000000000001" : ] 000000309617698.470363000000000000 ; 000000325017669.653738000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000001D8706A1EFF007 >									
260 	//     < RUSS_PFIX_I_metadata_line_22_____AB_FK_ANZHI_MAKHA_20211101 >									
261 	//        < YBg38IciEW8YguU3LgJrRXn0O43oEo06dBBjy9N0LQ595880yz5RJf7B3W5a47U9 >									
262 	//        <  u =="0.000000000000000001" : ] 000000325017669.653738000000000000 ; 000000341168539.987585000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000001EFF00720894F6 >									
264 	//     < RUSS_PFIX_I_metadata_line_23_____AB_NAFTA_MOSKVA_20211101 >									
265 	//        < d8Fi55kMo4jM3m3lD9SSuSBvUL24xcBfXi7S83k57F00zxp7y63nagp0n67xV5I5 >									
266 	//        <  u =="0.000000000000000001" : ] 000000341168539.987585000000000000 ; 000000356951050.338223000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000020894F6220AA01 >									
268 	//     < RUSS_PFIX_I_metadata_line_24_____AB_SOYUZNEFTEEXPOR_20211101 >									
269 	//        < EA52wWUpl9xU8VZz5pNCnHwY5f7adUv2Mhx14f9MYeb8iXv14x6v35C3fB8sLplN >									
270 	//        <  u =="0.000000000000000001" : ] 000000356951050.338223000000000000 ; 000000370826176.397159000000000000 ] >									
271 	//        < 0x00000000000000000000000000000000000000000000000000220AA01235D5FA >									
272 	//     < RUSS_PFIX_I_metadata_line_25_____AB_FEDPROMBANK_20211101 >									
273 	//        < 6v7wWzP79Vab0l1Y345RPq1sSxd4hauL3v8XK32c02T4yJ29g9hRfFx641537x5A >									
274 	//        <  u =="0.000000000000000001" : ] 000000370826176.397159000000000000 ; 000000385197134.051317000000000000 ] >									
275 	//        < 0x00000000000000000000000000000000000000000000000000235D5FA24BC3A1 >									
276 	//     < RUSS_PFIX_I_metadata_line_26_____AB_ELTAV_ELEC_20211101 >									
277 	//        < Zp76YEIdE0RZ5BUyzsbHtigR0Tl682OaYixW8y2C4v28mnp16ry356gUFGscO6mE >									
278 	//        <  u =="0.000000000000000001" : ] 000000385197134.051317000000000000 ; 000000402041494.054118000000000000 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000000000024BC3A12657775 >									
280 	//     < RUSS_PFIX_I_metadata_line_27_____AB_SOYUZ_FINANS_20211101 >									
281 	//        < kIm677ffVw5WD1vfzwMTT0IRwMAWK3S0iy54m1TM38I3fY2Ul29LHishiKQY6YR4 >									
282 	//        <  u =="0.000000000000000001" : ] 000000402041494.054118000000000000 ; 000000415512210.917087000000000000 ] >									
283 	//        < 0x00000000000000000000000000000000000000000000000000265777527A0575 >									
284 	//     < RUSS_PFIX_I_metadata_line_28_____AB_VNUKOVO_20211101 >									
285 	//        < k8Q7cs16zGFBVO678aIl78AAgJjH21sTsvH47R2QV9OPw8vMmmCl3G6z7JwdL1V5 >									
286 	//        <  u =="0.000000000000000001" : ] 000000415512210.917087000000000000 ; 000000430025350.922537000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000027A05752902AA7 >									
288 	//     < RUSS_PFIX_I_metadata_line_29_____AB_AVTOBANK_20211101 >									
289 	//        < RkUkC9mTdYs5268oCxq4mSBI9TG004K3qLkeqGn68O49wDZ78n6K6M457hM3ggTM >									
290 	//        <  u =="0.000000000000000001" : ] 000000430025350.922537000000000000 ; 000000444152426.579161000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000002902AA72A5B90B >									
292 	//     < RUSS_PFIX_I_metadata_line_30_____AB_SMOLENSKY_PASSAZH_20211101 >									
293 	//        < mD29y6zvjB13qwA6xYEV83HKTv1m6VjOD1r75PdW9f1T38CkYP0Y3o1wXkTF520b >									
294 	//        <  u =="0.000000000000000001" : ] 000000444152426.579161000000000000 ; 000000459465040.445254000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000002A5B90B2BD1688 >									
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
338 	//     < RUSS_PFIX_I_metadata_line_31_____MAKHA_PORT_20211101 >									
339 	//        < ntAM1ldyFVscuG6z3D4P6YrDIlnOSxZu2Lk2x421YlQyibjMe4Je9FQYz62IouDY >									
340 	//        <  u =="0.000000000000000001" : ] 000000459465040.445254000000000000 ; 000000474948509.184825000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000002BD16882D4B6C3 >									
342 	//     < RUSS_PFIX_I_metadata_line_32_____MAKHA_AIRPORT_AB_20211101 >									
343 	//        < 8H79d2ed41uQlPqaGnqYA3832j1Cw574FkdUO66e844dH72UG171tud9H0V85SOI >									
344 	//        <  u =="0.000000000000000001" : ] 000000474948509.184825000000000000 ; 000000491694980.222395000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000002D4B6C32EE445A >									
346 	//     < RUSS_PFIX_I_metadata_line_33_____DAG_ORG_20211101 >									
347 	//        < B05987FarBBy4h4tJ6HSM3y71z28QU2iR7iqfikhhek577m650mEzTVL6MkkN224 >									
348 	//        <  u =="0.000000000000000001" : ] 000000491694980.222395000000000000 ; 000000506316851.458482000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000002EE445A3049405 >									
350 	//     < RUSS_PFIX_I_metadata_line_34_____DAG_DAO_20211101 >									
351 	//        < NW6l2j3Uc45Qap98XW39ZIg5XBiPC5VrJX9E0gS77wmts7St89ylB1EnSw500V10 >									
352 	//        <  u =="0.000000000000000001" : ] 000000506316851.458482000000000000 ; 000000523077359.787811000000000000 ] >									
353 	//        < 0x00000000000000000000000000000000000000000000000000304940531E2718 >									
354 	//     < RUSS_PFIX_I_metadata_line_35_____DAG_DAOPI_20211101 >									
355 	//        < KRw1RJp3Ww4u592MucLCQBa17Mgov4qAC48LU7S7P6G23y83GswCxt5fZe1Db69J >									
356 	//        <  u =="0.000000000000000001" : ] 000000523077359.787811000000000000 ; 000000540120230.740823000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000031E27183382877 >									
358 	//     < RUSS_PFIX_I_metadata_line_36_____DAG_DAC_20211101 >									
359 	//        < 59W4nD0O7IIhjo1wv55QANry1MHljC9877MU1IIWJ068S9CQu231wVS8D80gD1De >									
360 	//        <  u =="0.000000000000000001" : ] 000000540120230.740823000000000000 ; 000000554475237.147435000000000000 ] >									
361 	//        < 0x00000000000000000000000000000000000000000000000000338287734E0FE4 >									
362 	//     < RUSS_PFIX_I_metadata_line_37_____MAKHA_ORG_20211101 >									
363 	//        < 2Bo3S2e8mrwcRSz91r4xfAmQF7nc618hkk61jhy4SEW36fR5igfJfl56vSAcKmIT >									
364 	//        <  u =="0.000000000000000001" : ] 000000554475237.147435000000000000 ; 000000568422601.604920000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000034E0FE43635814 >									
366 	//     < RUSS_PFIX_I_metadata_line_38_____MAKHA_DAO_20211101 >									
367 	//        < P880Ao3li34JCnxzdntfoANd8USb0RV58VYPUvW35hrjY5C90vWeRMpJohWy9L3E >									
368 	//        <  u =="0.000000000000000001" : ] 000000568422601.604920000000000000 ; 000000583883313.682322000000000000 ] >									
369 	//        < 0x00000000000000000000000000000000000000000000000000363581437AEF6B >									
370 	//     < RUSS_PFIX_I_metadata_line_39_____MAKHA_DAOPI_20211101 >									
371 	//        < zSdsC6Yz2aX8C1f4aWgHkPNKYOnx1d3AqZ5CTO0e32tXJQ1UvZ25dziQ44kfyyvm >									
372 	//        <  u =="0.000000000000000001" : ] 000000583883313.682322000000000000 ; 000000598444229.700738000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000037AEF6B3912747 >									
374 	//     < RUSS_PFIX_I_metadata_line_40_____MAKHA_DAC_20211101 >									
375 	//        < XFDj7Dj3hfU6swNZZa5QgY2409SFlW08p6QXIhs1sDfb1fd908Gusa2C4DOPRp54 >									
376 	//        <  u =="0.000000000000000001" : ] 000000598444229.700738000000000000 ; 000000615632658.459955000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000039127473AB6182 >									
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