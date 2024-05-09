1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	NDRV_PFVI_II_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	NDRV_PFVI_II_883		"	;
8 		string	public		symbol =	"	NDRV_PFVI_II_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1274498274054920000000000000					;	
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
92 	//     < NDRV_PFVI_II_metadata_line_1_____Hannover_Re_20231101 >									
93 	//        < tn9aU5a6zp4nQlRg3c7y778RO39DOE2e7SWV61X0MF9MN14f577m90d10yjl0nvz >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000025433720.664619600000000000 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000000026CF0C >									
96 	//     < NDRV_PFVI_II_metadata_line_2_____International Insurance Company of Hannover SE_20231101 >									
97 	//        < TS6PMK94gx0G0xCV0B5oYfvN42Yr744Jz4LOGVso2ugQ1Tyr0BN6Vk3j3zPP0X8r >									
98 	//        <  u =="0.000000000000000001" : ] 000000025433720.664619600000000000 ; 000000074571948.730056500000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000026CF0C71C9AB >									
100 	//     < NDRV_PFVI_II_metadata_line_3_____Hannover Life Reassurance Company of America_20231101 >									
101 	//        < 6Vn6GD9B6zx76E4JndbB6BK1Do6ykq8T9zK5PcoDkydp3M6YZ43olbaqy0Py84a8 >									
102 	//        <  u =="0.000000000000000001" : ] 000000074571948.730056500000000000 ; 000000123201359.286665000000000000 ] >									
103 	//        < 0x000000000000000000000000000000000000000000000000000071C9ABBBFD88 >									
104 	//     < NDRV_PFVI_II_metadata_line_4_____Hannover Reinsurance_20231101 >									
105 	//        < 3qzYt7b9ZgC2a0E6VxGte86kIN43qIV2HhJhKqtHj0sNe8Dwr2BoDm146GL45WgU >									
106 	//        <  u =="0.000000000000000001" : ] 000000123201359.286665000000000000 ; 000000138937873.290096000000000000 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000000000BBFD88D4009B >									
108 	//     < NDRV_PFVI_II_metadata_line_5_____Clarendon Insurance Group Inc_20231101 >									
109 	//        < iVJ1sKfssPLZxDt751797RbzoSEW4vy13MFrg7o8Kwp0i09q8NqAa2RQ9P9UWM0V >									
110 	//        <  u =="0.000000000000000001" : ] 000000138937873.290096000000000000 ; 000000167164960.005847000000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000D4009BFF12D0 >									
112 	//     < NDRV_PFVI_II_metadata_line_6_____Argenta Holdings plc_20231101 >									
113 	//        < 9maMZYe17n2X35y285qKZVL4LI6u53S6l6wq2Ik6gI45K8250LXTL9uZQLF1r1nz >									
114 	//        <  u =="0.000000000000000001" : ] 000000167164960.005847000000000000 ; 000000189795911.672160000000000000 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000000000FF12D01219B07 >									
116 	//     < NDRV_PFVI_II_metadata_line_7_____Argenta Syndicate Management Limited_20231101 >									
117 	//        < 78oQE4rv48DtBc47LdQDOTpFASS8u7EO6K7Os2dII3duiSWv2uT6b09K77hXMb04 >									
118 	//        <  u =="0.000000000000000001" : ] 000000189795911.672160000000000000 ; 000000211704230.771506000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000001219B0714308F7 >									
120 	//     < NDRV_PFVI_II_metadata_line_8_____Argenta Private Capital Limited_20231101 >									
121 	//        < tO736L3E3e1feO3X64CFH5jAJGMY46oEHu7jH3564JQx4F4CsXZwoN4n1vBOAGkw >									
122 	//        <  u =="0.000000000000000001" : ] 000000211704230.771506000000000000 ; 000000239144204.452319000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000014308F716CE7B4 >									
124 	//     < NDRV_PFVI_II_metadata_line_9_____Argenta Tax & Corporate Services Limited_20231101 >									
125 	//        < 3Beb2dChs4TF4KGf7GXLx9wA6qrjry61d6WKsu37G0J8BCafxtD34ZfuJ26W73O6 >									
126 	//        <  u =="0.000000000000000001" : ] 000000239144204.452319000000000000 ; 000000286039333.405268000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000016CE7B41B4761D >									
128 	//     < NDRV_PFVI_II_metadata_line_10_____Hannover Life Re AG_20231101 >									
129 	//        < r7EKs9QbO1j2367O28mu38qT6j712F7J0ZkTwSLdB5HuxIDRZ44fbcBzu6dgP8JU >									
130 	//        <  u =="0.000000000000000001" : ] 000000286039333.405268000000000000 ; 000000324103539.038494000000000000 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000000001B4761D1EE8AF2 >									
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
174 	//     < NDRV_PFVI_II_metadata_line_11_____Hannover Life Re of Australasia Ltd_20231101 >									
175 	//        < 4tnHq3A4g7S8az6D1r3YWmQ1pGE7082KX7Jpr0D3glv6HwN3RUtrx5OEW8A3rg8z >									
176 	//        <  u =="0.000000000000000001" : ] 000000324103539.038494000000000000 ; 000000357023935.223395000000000000 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000000001EE8AF2220C67A >									
178 	//     < NDRV_PFVI_II_metadata_line_12_____Hannover Life Re of Australasia Ltd New Zealand_20231101 >									
179 	//        < cPgG2dWR44h9t73dLUt20MEmcFHVXWXL42pW7q3H7hhThy33gJ4h3uCmrO7vG1XS >									
180 	//        <  u =="0.000000000000000001" : ] 000000357023935.223395000000000000 ; 000000397988641.218852000000000000 ] >									
181 	//        < 0x00000000000000000000000000000000000000000000000000220C67A25F4850 >									
182 	//     < NDRV_PFVI_II_metadata_line_13_____Hannover Re Ireland Designated Activity Company_20231101 >									
183 	//        < q2yv8GDrE7mVFWq780zLR2vgdpV4lWM5kt435zq75eNZgKdZBTrz890Z5369156h >									
184 	//        <  u =="0.000000000000000001" : ] 000000397988641.218852000000000000 ; 000000418133565.196136000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000025F485027E056D >									
186 	//     < NDRV_PFVI_II_metadata_line_14_____Hannover Re Guernsey PCC Limited_20231101 >									
187 	//        < znzbG4mg3uND9XwYjP0m8Dmqf8KXV49B67QnnIh9Q6oGZKkzV6bcXPg8s06uFf52 >									
188 	//        <  u =="0.000000000000000001" : ] 000000418133565.196136000000000000 ; 000000439245713.320340000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000027E056D29E3C5B >									
190 	//     < NDRV_PFVI_II_metadata_line_15_____Hannover Re Euro RE Holdings GmbH_20231101 >									
191 	//        < aN768iakK3F4ci0WFM7pxziE5XT2PB2CmLY08YT4wRI0x6zeDLEUGL8D8K4X0IF3 >									
192 	//        <  u =="0.000000000000000001" : ] 000000439245713.320340000000000000 ; 000000458233697.896871000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000029E3C5B2BB358A >									
194 	//     < NDRV_PFVI_II_metadata_line_16_____Skandia Portfolio Management GmbH_20231101 >									
195 	//        < Zn42j4VRjEBYKr1WHOdq2lVTfyN2oFB4w6Zwb5r4Q6981o02WZH0KDD9XPThI3oF >									
196 	//        <  u =="0.000000000000000001" : ] 000000458233697.896871000000000000 ; 000000495005517.946178000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000002BB358A2F35188 >									
198 	//     < NDRV_PFVI_II_metadata_line_17_____Skandia Lebensversicherung AG_20231101 >									
199 	//        < aSIUa4QvrxwfBte49M9U706Yu5Jdz9NpUnc9FgzgUv4UADek77HHf28x8A4r8JGD >									
200 	//        <  u =="0.000000000000000001" : ] 000000495005517.946178000000000000 ; 000000543309817.566424000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000002F3518833D0666 >									
202 	//     < NDRV_PFVI_II_metadata_line_18_____Hannover Life Reassurance Bermuda Ltd_20231101 >									
203 	//        < SL1RYX7G0K54vVC3L3Cw5VE9n276sugaUV1zhPumN820o9pAnV99VUn46mCDLOvO >									
204 	//        <  u =="0.000000000000000001" : ] 000000543309817.566424000000000000 ; 000000568482518.512763000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000033D06663636F7C >									
206 	//     < NDRV_PFVI_II_metadata_line_19_____Hannover Re Services Japan KK_20231101 >									
207 	//        < k0ElW7b4lMqCHXR5WH4IFBbS9PI5tiycmLdHjbVjFkpSiDtReS6tWfrxQSJM6f4s >									
208 	//        <  u =="0.000000000000000001" : ] 000000568482518.512763000000000000 ; 000000597124589.687602000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000003636F7C38F23CB >									
210 	//     < NDRV_PFVI_II_metadata_line_20_____Hannover Finance Inc_20231101 >									
211 	//        < Z3hUhJGPrr6rLCW5GQ947xoA4J09T55HtaStXR63D991ivCZ25BYbE9R30NffFyW >									
212 	//        <  u =="0.000000000000000001" : ] 000000597124589.687602000000000000 ; 000000637319897.120010000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000038F23CB3CC7916 >									
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
256 	//     < NDRV_PFVI_II_metadata_line_21_____Atlantic Capital Corp_20231101 >									
257 	//        < 79CpBm026Q925a04mK141xR9p1QYCD27g9n6y55009x2WmShU1pNupv4pXknC26Z >									
258 	//        <  u =="0.000000000000000001" : ] 000000637319897.120010000000000000 ; 000000669891191.164780000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000003CC79163FE2C3F >									
260 	//     < NDRV_PFVI_II_metadata_line_22_____Hannover Re Bermuda Ltd_20231101 >									
261 	//        < Dtrs4OuKk0RmDqW2h0DkL1VdvhY2Ou7sEV68gWR3hnKSRvCizj7b4vsLZSeFt5a9 >									
262 	//        <  u =="0.000000000000000001" : ] 000000669891191.164780000000000000 ; 000000714547567.601513000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000003FE2C3F4425025 >									
264 	//     < NDRV_PFVI_II_metadata_line_23_____Hannover Re Consulting Services India Private Limited_20231101 >									
265 	//        < DejI8ahak2KYCx5UNcwLV493q1wsM8p2kaMA854g2OIm7VENXG46IDd4cYa5J71w >									
266 	//        <  u =="0.000000000000000001" : ] 000000714547567.601513000000000000 ; 000000731257486.195501000000000000 ] >									
267 	//        < 0x00000000000000000000000000000000000000000000000000442502545BCF75 >									
268 	//     < NDRV_PFVI_II_metadata_line_24_____HDI Global Specialty SE_20231101 >									
269 	//        < xsE1AoVgAArlEOm3t980FQ28yPHC4l0uyhe3B41dDIaGHiFJx9rK4zyzD248Yxa5 >									
270 	//        <  u =="0.000000000000000001" : ] 000000731257486.195501000000000000 ; 000000769625867.757029000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000045BCF754965B1B >									
272 	//     < NDRV_PFVI_II_metadata_line_25_____Hannover Services México SA de CV_20231101 >									
273 	//        < F3vPK273D637qK0t8B6TxSGeT6f9Z9sNd6C5mJ093VA9H3S4Am8P42sEbY0Nl3c1 >									
274 	//        <  u =="0.000000000000000001" : ] 000000769625867.757029000000000000 ; 000000800484800.649248000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000004965B1B4C57160 >									
276 	//     < NDRV_PFVI_II_metadata_line_26_____Hannover Re Real Estate Holdings Inc_20231101 >									
277 	//        < WHwkEZqO2iesKuhf9ALPnrUo75KqNE334h8dlhpQCRJ9R5Rp0HR6KI27KP91n23h >									
278 	//        <  u =="0.000000000000000001" : ] 000000800484800.649248000000000000 ; 000000823311859.574919000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000004C571604E84632 >									
280 	//     < NDRV_PFVI_II_metadata_line_27_____GLL HRE Core Properties LP_20231101 >									
281 	//        < 82DPcaoAswECR92lXYS2QIVjlyk5y80HK3k7om4D14CrH95b19sZkWvyR639ZI1u >									
282 	//        <  u =="0.000000000000000001" : ] 000000823311859.574919000000000000 ; 000000846861665.404849000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000004E8463250C3557 >									
284 	//     < NDRV_PFVI_II_metadata_line_28_____Broadway101 Office Park Inc_20231101 >									
285 	//        < 3653kcttotkf82J8d4T7aOv7Ewp8Oi6OFVvjWNoo7jvk6Osxza0iH8SzW1843Zn1 >									
286 	//        <  u =="0.000000000000000001" : ] 000000846861665.404849000000000000 ; 000000885496756.271504000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000050C3557547292C >									
288 	//     < NDRV_PFVI_II_metadata_line_29_____Broadway 101 LLC_20231101 >									
289 	//        < GR51T8Meqy994q2599I9jg2P5fnFbFeyc8cpj3RO15koSpM2aPDGjtf039h2C3nT >									
290 	//        <  u =="0.000000000000000001" : ] 000000885496756.271504000000000000 ; 000000934369763.091898000000000000 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000000000547292C591BC30 >									
292 	//     < NDRV_PFVI_II_metadata_line_30_____5115 Sedge Corporation_20231101 >									
293 	//        < ETGsJ2Wm1MHi6TkkpX6OEtar6o92K2f97ghuuUR8hESXN646d936s5zNle0FjQp3 >									
294 	//        <  u =="0.000000000000000001" : ] 000000934369763.091898000000000000 ; 000000967708825.924947000000000000 ] >									
295 	//        < 0x00000000000000000000000000000000000000000000000000591BC305C49B43 >									
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
338 	//     < NDRV_PFVI_II_metadata_line_31_____Hannover Re Euro Pe Holdings Gmbh & Co Kg_20231101 >									
339 	//        < 1Q0JUI4v5T9b4EGu5Yp72M5XdvjwzY6x53bF7bI8VXz7h2cVTPNf6NRIE6M800a2 >									
340 	//        <  u =="0.000000000000000001" : ] 000000967708825.924947000000000000 ; 000001005173993.895090000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000005C49B435FDC617 >									
342 	//     < NDRV_PFVI_II_metadata_line_32_____Compass Insurance Company Ltd_20231101 >									
343 	//        < y9hdU4BuB290XHM7134L3NU6X8H3bNBEG0YH71ykG3d9noId6QTOSuQzUUXf41do >									
344 	//        <  u =="0.000000000000000001" : ] 000001005173993.895090000000000000 ; 000001022393493.374710000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000005FDC6176180C75 >									
346 	//     < NDRV_PFVI_II_metadata_line_33_____Commercial & Industrial Acceptances Pty Ltd_20231101 >									
347 	//        < AsciOda5BkyPFrI2Q9LLsR434cjX77Wua864d0YA8JP2A4OPt3i21y7bq49X99B3 >									
348 	//        <  u =="0.000000000000000001" : ] 000001022393493.374710000000000000 ; 000001055020769.058550000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000006180C75649D57D >									
350 	//     < NDRV_PFVI_II_metadata_line_34_____Kaith Re Ltd_20231101 >									
351 	//        < BAWb9yPq9LBH7Y0adju28fd068OH7Kad6va8NR0X896WA01bcJV7D0zoammCj859 >									
352 	//        <  u =="0.000000000000000001" : ] 000001055020769.058550000000000000 ; 000001082610977.486770000000000000 ] >									
353 	//        < 0x00000000000000000000000000000000000000000000000000649D57D673EEEA >									
354 	//     < NDRV_PFVI_II_metadata_line_35_____Leine Re_20231101 >									
355 	//        < 1ObA011PHK0Ua81qOu7XI4RULBrT9sC0ftz248ABH0L6Xt7s5w591D4bS20s0Opx >									
356 	//        <  u =="0.000000000000000001" : ] 000001082610977.486770000000000000 ; 000001104990301.858880000000000000 ] >									
357 	//        < 0x00000000000000000000000000000000000000000000000000673EEEA69614D6 >									
358 	//     < NDRV_PFVI_II_metadata_line_36_____Hannover Re Services Italy Srl_20231101 >									
359 	//        < q0m5Z9g2sqv7ZQr01mc83zYORnEm0qA35TZ7PIoDgz4T7N36xMP8VQ1B70o93cGE >									
360 	//        <  u =="0.000000000000000001" : ] 000001104990301.858880000000000000 ; 000001148001684.195450000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000069614D66D7B628 >									
362 	//     < NDRV_PFVI_II_metadata_line_37_____Hannover Services UK Ltd_20231101 >									
363 	//        < 0JSsqslMf093kZd74YCInSzeTu1NMXhszT755t8ay8h0byDmL3bSzPJ7m7XgxG4V >									
364 	//        <  u =="0.000000000000000001" : ] 000001148001684.195450000000000000 ; 000001196832629.155840000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000006D7B62872238BF >									
366 	//     < NDRV_PFVI_II_metadata_line_38_____Hr Gll Central Europe Holding Gmbh_20231101 >									
367 	//        < g5peQ43R9WWDGX3n3y34piXX7JrSauMT2L9M9BZ9OpSQH79n06yyQQ7t2H41SG3d >									
368 	//        <  u =="0.000000000000000001" : ] 000001196832629.155840000000000000 ; 000001239630576.701040000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000072238BF76386B2 >									
370 	//     < NDRV_PFVI_II_metadata_line_39_____Hannover Re Risk Management Services India Private Limited_20231101 >									
371 	//        < ydfa8wl25D25pyh6M8flaJLXtu5Y1mFq7193464TviXT4NK1kOGzpobd27jOXT6k >									
372 	//        <  u =="0.000000000000000001" : ] 000001239630576.701040000000000000 ; 000001256946501.573010000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000076386B277DF2BA >									
374 	//     < NDRV_PFVI_II_metadata_line_40_____HAPEP II Holding GmbH_20231101 >									
375 	//        < 9xWC4P5kI7YLoLqJS7CR6XdnDe2qCXo3dM4gsfQd41KGR9ks036Gi6N0484o47jX >									
376 	//        <  u =="0.000000000000000001" : ] 000001256946501.573010000000000000 ; 000001274498274.054920000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000077DF2BA798BAE3 >									
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