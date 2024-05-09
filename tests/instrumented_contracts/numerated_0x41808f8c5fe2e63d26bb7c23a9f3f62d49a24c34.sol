1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFVI_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFVI_I_883		"	;
8 		string	public		symbol =	"	RUSS_PFVI_I_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		608977150836653000000000000					;	
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
92 	//     < RUSS_PFVI_I_metadata_line_1_____UPRECHISTENKA1_3319C1_MOS_RUS_I_20211101 >									
93 	//        < M06WwQ9GwHa8cz4RWEuBcHGGRT30f35TGu0IN7c53WpXyPRCHzC8czxjB3511c07 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000015978024.622414400000000000 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000000018616A >									
96 	//     < RUSS_PFVI_I_metadata_line_2_____UPRECHISTENKA1_3319C1_MOS_RUS_II_20211101 >									
97 	//        < 6d7al54Hei11M7nNt2IX8p90P382qD4newuikQaDYxD2RsPAN8X4VXH9116Je6K1 >									
98 	//        <  u =="0.000000000000000001" : ] 000000015978024.622414400000000000 ; 000000032982302.805799800000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000018616A3253B6 >									
100 	//     < RUSS_PFVI_I_metadata_line_3_____UPRECHISTENKA1_3319C1_MOS_RUS_III_20211101 >									
101 	//        < 3CU653Fh4j5PcXTaT2BbeU705BMve6tFo91EEgk8f12LCdc3ZKZ3Bi90DtIu1sit >									
102 	//        <  u =="0.000000000000000001" : ] 000000032982302.805799800000000000 ; 000000047434219.360019100000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000003253B64860FE >									
104 	//     < RUSS_PFVI_I_metadata_line_4_____UPRECHISTENKA1_3319C1_MOS_RUS_IV_20211101 >									
105 	//        < MlJHhB3tPCbEKsx678F3Y4748pBjqjJNfNf38Z1AH6f0D6MQW1ZVKJ1rok2G6rpS >									
106 	//        <  u =="0.000000000000000001" : ] 000000047434219.360019100000000000 ; 000000062565321.422385300000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000004860FE5F7794 >									
108 	//     < RUSS_PFVI_I_metadata_line_5_____UPRECHISTENKA1_3319C1_MOS_RUS_V_20211101 >									
109 	//        < dySEK2hEBshSLD50Zg0faVN2zo941ngLG62DpCUdXGmn8v4bxx51o8gjm595ANUK >									
110 	//        <  u =="0.000000000000000001" : ] 000000062565321.422385300000000000 ; 000000075702115.555311900000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000005F7794738324 >									
112 	//     < RUSS_PFVI_I_metadata_line_6_____UPRECHISTENKA1_3319C1_MOS_RUS_VI_20211101 >									
113 	//        < 9QZgNW8Tz9Dnna6ezNV19E6Qz17s27e68vI33WYkCO4g2X0HdjA4e0xTxMa2EMN5 >									
114 	//        <  u =="0.000000000000000001" : ] 000000075702115.555311900000000000 ; 000000092479067.607412100000000000 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000000000007383248D1CA3 >									
116 	//     < RUSS_PFVI_I_metadata_line_7_____UPRECHISTENKA1_3319C1_MOS_RUS_VII_20211101 >									
117 	//        < QjdigSi4xVemtlZD2zmk8ux0W3NB9781Qa39A4Ll90fD2570J7RJ8xGFpAVfb6sY >									
118 	//        <  u =="0.000000000000000001" : ] 000000092479067.607412100000000000 ; 000000106227108.111923000000000000 ] >									
119 	//        < 0x00000000000000000000000000000000000000000000000000008D1CA3A216F7 >									
120 	//     < RUSS_PFVI_I_metadata_line_8_____UPRECHISTENKA1_3319C1_MOS_RUS_VIII_20211101 >									
121 	//        < BWF314Y1N6y9zcSDQ230UrN0eQiN5h8KuRv7J4193l8EAwBgSDCr2J2r16wcCNUP >									
122 	//        <  u =="0.000000000000000001" : ] 000000106227108.111923000000000000 ; 000000121578377.957438000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000A216F7B9838E >									
124 	//     < RUSS_PFVI_I_metadata_line_9_____UPRECHISTENKA1_3319C1_MOS_RUS_IX_20211101 >									
125 	//        < iH4L6SBZ7OMv4MCX8ITWaa2UssS9AhI7Um8FfFCZ23ME0W4566RDKp9VExVe21H9 >									
126 	//        <  u =="0.000000000000000001" : ] 000000121578377.957438000000000000 ; 000000134786752.319081000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000000B9838ECDAB13 >									
128 	//     < RUSS_PFVI_I_metadata_line_10_____UPRECHISTENKA1_3319C1_MOS_RUS_X_20211101 >									
129 	//        < WT7CX448jo930DC7t2Ns95cnIH5xfIRW7bqRf3B52406HSNmeF1b9C81Bav69rwF >									
130 	//        <  u =="0.000000000000000001" : ] 000000134786752.319081000000000000 ; 000000149005685.491154000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000000CDAB13E35D59 >									
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
174 	//     < RUSS_PFVI_I_metadata_line_11_____UPRECHISTENKA2_3319C1_MOS_RUS_I_20211101 >									
175 	//        < mYIFDSAWh95BET61PT530xzVnY225SptR6tGoy7XhAp8NpuPG3z5hRiYZA5CcI3Q >									
176 	//        <  u =="0.000000000000000001" : ] 000000149005685.491154000000000000 ; 000000164355630.747045000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000000E35D59FAC96B >									
178 	//     < RUSS_PFVI_I_metadata_line_12_____UPRECHISTENKA2_3319C1_MOS_RUS_II_20211101 >									
179 	//        < 8p508rlcK5v9jJ7N2UVnjVQvnR3bov5t5b3AE2dbJB5n3AcTKV8TwiL8OEDc7ZM2 >									
180 	//        <  u =="0.000000000000000001" : ] 000000164355630.747045000000000000 ; 000000180375077.136172000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000000FAC96B1133B04 >									
182 	//     < RUSS_PFVI_I_metadata_line_13_____UPRECHISTENKA2_3319C1_MOS_RUS_III_20211101 >									
183 	//        < B2b9sIF6h9uO2IsNftlG5OB1JsCU34bLL8Fa0WKC05zmEILo1F8A2p2Es09j55Rk >									
184 	//        <  u =="0.000000000000000001" : ] 000000180375077.136172000000000000 ; 000000196271203.152651000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001133B0412B7C70 >									
186 	//     < RUSS_PFVI_I_metadata_line_14_____UPRECHISTENKA2_3319C1_MOS_RUS_IV_20211101 >									
187 	//        < boMjrR01b2x8Yx906H5avyJ07zv6nwP66I89csH59p1bXE6eiO88EZXqNARsB73Z >									
188 	//        <  u =="0.000000000000000001" : ] 000000196271203.152651000000000000 ; 000000210442757.079127000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000012B7C701411C34 >									
190 	//     < RUSS_PFVI_I_metadata_line_15_____UPRECHISTENKA2_3319C1_MOS_RUS_V_20211101 >									
191 	//        < Z38133ndGWmfpGSnp2HOLUK20cI1Uawvkoa8e0Ywq2GFU4F83IgVN07N5D2XNIwm >									
192 	//        <  u =="0.000000000000000001" : ] 000000210442757.079127000000000000 ; 000000225203507.035794000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000001411C34157A21F >									
194 	//     < RUSS_PFVI_I_metadata_line_16_____UPRECHISTENKA2_3319C1_MOS_RUS_VI_20211101 >									
195 	//        < 75UgJl1s00UHo1fi90D57G4k2SyQ45e2u24W9eg1ckjxy5r14HfAIrI06tdgQDsP >									
196 	//        <  u =="0.000000000000000001" : ] 000000225203507.035794000000000000 ; 000000239807116.743309000000000000 ] >									
197 	//        < 0x00000000000000000000000000000000000000000000000000157A21F16DEAA8 >									
198 	//     < RUSS_PFVI_I_metadata_line_17_____UPRECHISTENKA2_3319C1_MOS_RUS_VII_20211101 >									
199 	//        < VkD6qiA8N0HUHUGa7Y7nJ5xt840D7jC96sQ9evg8bSUPo4UQ4KegCg00ekdgpHV7 >									
200 	//        <  u =="0.000000000000000001" : ] 000000239807116.743309000000000000 ; 000000254710636.963116000000000000 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000000016DEAA8184A858 >									
202 	//     < RUSS_PFVI_I_metadata_line_18_____UPRECHISTENKA2_3319C1_MOS_RUS_VIII_20211101 >									
203 	//        < Hm4Zq4sO0DUPT05nUa55w11j6qZqhqnTuk9lrHz8u44FMoafC48t52f1A236uHhM >									
204 	//        <  u =="0.000000000000000001" : ] 000000254710636.963116000000000000 ; 000000269838066.466455000000000000 ] >									
205 	//        < 0x00000000000000000000000000000000000000000000000000184A85819BBD7F >									
206 	//     < RUSS_PFVI_I_metadata_line_19_____UPRECHISTENKA2_3319C1_MOS_RUS_IX_20211101 >									
207 	//        < Q9T6zL6fz1197qMja18m433J3My8xM776xU27RwhQ0MD2FlD4XurD8k72w1t7uWw >									
208 	//        <  u =="0.000000000000000001" : ] 000000269838066.466455000000000000 ; 000000285211450.000160000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000000019BBD7F1B332B9 >									
210 	//     < RUSS_PFVI_I_metadata_line_20_____UPRECHISTENKA2_3319C1_MOS_RUS_X_20211101 >									
211 	//        < g546lrTwFHYQmucedCM822o7AdPYed2s3fmIfJPrf0lsgfGre3HEag0D5Si3ZkHD >									
212 	//        <  u =="0.000000000000000001" : ] 000000285211450.000160000000000000 ; 000000300361522.108105000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000001B332B91CA50B8 >									
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
256 	//     < RUSS_PFVI_I_metadata_line_21_____UPRECHISTENKA2_3319C1_MOS_RUS_I_20211101 >									
257 	//        < Kd0W578Pl1k41L69vM8TjCI2hJS56KFRz97V2409SEBR3V0DA4ATtNQ599f8yA7m >									
258 	//        <  u =="0.000000000000000001" : ] 000000300361522.108105000000000000 ; 000000314892441.345543000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000001CA50B81E07CDC >									
260 	//     < RUSS_PFVI_I_metadata_line_22_____UPRECHISTENKA2_3319C1_MOS_RUS_II_20211101 >									
261 	//        < 0F3ya0K8V94v2R2WNhqO7kBM9S48Jmm8EfyjKVBG1SKJ71aE2nyl8Vb28De8qX69 >									
262 	//        <  u =="0.000000000000000001" : ] 000000314892441.345543000000000000 ; 000000328709903.909305000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000001E07CDC1F5924E >									
264 	//     < RUSS_PFVI_I_metadata_line_23_____UPRECHISTENKA2_3319C1_MOS_RUS_III_20211101 >									
265 	//        < qmCwX3777cZIXgcxZo8684qviHQ07IA9804O84iycQc328VXc24nB0COS2PZ4nfd >									
266 	//        <  u =="0.000000000000000001" : ] 000000328709903.909305000000000000 ; 000000344273491.521433000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000001F5924E20D51D5 >									
268 	//     < RUSS_PFVI_I_metadata_line_24_____UPRECHISTENKA2_3319C1_MOS_RUS_IV_20211101 >									
269 	//        < 8rQqFVj7Jn0YcjlIQ7g1YQ5xZz7z5Fvv5oSn60e60tn3m5B2GlyQfMCL9RFE1N09 >									
270 	//        <  u =="0.000000000000000001" : ] 000000344273491.521433000000000000 ; 000000360202948.738353000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000020D51D5225A047 >									
272 	//     < RUSS_PFVI_I_metadata_line_25_____UPRECHISTENKA2_3319C1_MOS_RUS_V_20211101 >									
273 	//        < n2ieezB7hJ0Xl6zzbM1uM6Y4510ydcmApqO8ia7a79IHY7bioH587Pn9Gnk32BAM >									
274 	//        <  u =="0.000000000000000001" : ] 000000360202948.738353000000000000 ; 000000377087539.810240000000000000 ] >									
275 	//        < 0x00000000000000000000000000000000000000000000000000225A04723F63D2 >									
276 	//     < RUSS_PFVI_I_metadata_line_26_____UPRECHISTENKA2_3319C1_MOS_RUS_VI_20211101 >									
277 	//        < uFsZMj6h433I775LBu69tQVw6n76XQQ2ugkTi4sXstRGvLZ8Z901LnhR9TuENXp0 >									
278 	//        <  u =="0.000000000000000001" : ] 000000377087539.810240000000000000 ; 000000391987678.776099000000000000 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000000000023F63D22562030 >									
280 	//     < RUSS_PFVI_I_metadata_line_27_____UPRECHISTENKA2_3319C1_MOS_RUS_VII_20211101 >									
281 	//        < qrUJe06a8teSqe6PEXRa43vvoo1G5bu6ULD2IVTZ4178U0z4lQakLd4La2j99CX1 >									
282 	//        <  u =="0.000000000000000001" : ] 000000391987678.776099000000000000 ; 000000407835298.366159000000000000 ] >									
283 	//        < 0x00000000000000000000000000000000000000000000000000256203026E4EAA >									
284 	//     < RUSS_PFVI_I_metadata_line_28_____UPRECHISTENKA2_3319C1_MOS_RUS_VIII_20211101 >									
285 	//        < 77P91C3F34p5a861bRmQkp6j7N6lQ9QW5w2w42YXbN0kA4TzL5nUCnG6z32xiUtp >									
286 	//        <  u =="0.000000000000000001" : ] 000000407835298.366159000000000000 ; 000000424567947.982681000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000026E4EAA287D6DB >									
288 	//     < RUSS_PFVI_I_metadata_line_29_____UPRECHISTENKA2_3319C1_MOS_RUS_IX_20211101 >									
289 	//        < EXs1VJvrZSaoFU5NX51P1199J0UyqvSs5xxq44Q20H9I2Dp6hYVMUeAWSm2e2l1y >									
290 	//        <  u =="0.000000000000000001" : ] 000000424567947.982681000000000000 ; 000000440346593.281607000000000000 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000000000287D6DB29FEA63 >									
292 	//     < RUSS_PFVI_I_metadata_line_30_____UPRECHISTENKA2_3319C1_MOS_RUS_X_20211101 >									
293 	//        < ASi872i027366MTORFh8Q8f4vt7s8AWeCj19lf8WZvl3JGsl8RL40aZHwB88LN2J >									
294 	//        <  u =="0.000000000000000001" : ] 000000440346593.281607000000000000 ; 000000456851628.116457000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000029FEA632B919AB >									
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
338 	//     < RUSS_PFVI_I_metadata_line_31_____UPRECHISTENKA3_3319C1_MOS_RUS_I_20211101 >									
339 	//        < TulWOt4tVHI53E3RxxbL0YYbxPM709tY2XI8G34XHQVa11T9nVDGcEgGg1lCs8ZK >									
340 	//        <  u =="0.000000000000000001" : ] 000000456851628.116457000000000000 ; 000000473178871.873356000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000002B919AB2D2037F >									
342 	//     < RUSS_PFVI_I_metadata_line_32_____UPRECHISTENKA3_3319C1_MOS_RUS_II_20211101 >									
343 	//        < 91lcqooe8b2nhzE1iB54Ka3YPr1JD6jx1h1VL8H0c2C7ebJfs6yb3WaqCc2j4iod >									
344 	//        <  u =="0.000000000000000001" : ] 000000473178871.873356000000000000 ; 000000486229537.001495000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000002D2037F2E5ED6A >									
346 	//     < RUSS_PFVI_I_metadata_line_33_____UPRECHISTENKA3_3319C1_MOS_RUS_III_20211101 >									
347 	//        < d1JWeSHN0Vng32s52fBRmZGNVa7d22K3vVQ3Z0ZA65B43qnRvCTvq653K3aA2unI >									
348 	//        <  u =="0.000000000000000001" : ] 000000486229537.001495000000000000 ; 000000500750980.049652000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000002E5ED6A2FC15DA >									
350 	//     < RUSS_PFVI_I_metadata_line_34_____UPRECHISTENKA3_3319C1_MOS_RUS_IV_20211101 >									
351 	//        < D9LSGD750sZLUqwI9P0kmsGqam8C7zS103TPP43d38msct52mC6sVBUVu15440xp >									
352 	//        <  u =="0.000000000000000001" : ] 000000500750980.049652000000000000 ; 000000517097936.286066000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000002FC15DA3150762 >									
354 	//     < RUSS_PFVI_I_metadata_line_35_____UPRECHISTENKA3_3319C1_MOS_RUS_V_20211101 >									
355 	//        < FC1ECY9XgqO8O3dq32Yf3oEZyoAqb8y0G4ABHQi4wIrFW0U1ca0cmWP0R4pkSVAm >									
356 	//        <  u =="0.000000000000000001" : ] 000000517097936.286066000000000000 ; 000000534279329.072216000000000000 ] >									
357 	//        < 0x00000000000000000000000000000000000000000000000000315076232F3EDD >									
358 	//     < RUSS_PFVI_I_metadata_line_36_____UPRECHISTENKA3_3319C1_MOS_RUS_VI_20211101 >									
359 	//        < cS50D91G3AZZ83052ll0jN1c286RieFiZbfmLusK6o60UDb2JCVxL0464KbVRtGE >									
360 	//        <  u =="0.000000000000000001" : ] 000000534279329.072216000000000000 ; 000000549105308.467278000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000032F3EDD345DE43 >									
362 	//     < RUSS_PFVI_I_metadata_line_37_____UPRECHISTENKA3_3319C1_MOS_RUS_VII_20211101 >									
363 	//        < V2F1jZKk391UlFuE8075ixU8SVIPb497wLwhRLyur8HVLhh1IrLfdYFH8PQGwuEx >									
364 	//        <  u =="0.000000000000000001" : ] 000000549105308.467278000000000000 ; 000000564206564.148881000000000000 ] >									
365 	//        < 0x00000000000000000000000000000000000000000000000000345DE4335CE930 >									
366 	//     < RUSS_PFVI_I_metadata_line_38_____UPRECHISTENKA3_3319C1_MOS_RUS_VIII_20211101 >									
367 	//        < y2UbYL4Z6783jW9SECKgR4qJK14GJExYr5E2id303ua919qCZz43lPhISm247v36 >									
368 	//        <  u =="0.000000000000000001" : ] 000000564206564.148881000000000000 ; 000000578278886.012927000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000035CE9303726231 >									
370 	//     < RUSS_PFVI_I_metadata_line_39_____UPRECHISTENKA3_3319C1_MOS_RUS_IX_20211101 >									
371 	//        < v8xKFbhN2GPS4je8Kkwm3Id9JIT0Bb1fiCWW9rh7TF4z4iEz72M8AK51h9nvgOW9 >									
372 	//        <  u =="0.000000000000000001" : ] 000000578278886.012927000000000000 ; 000000594991496.060338000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000372623138BE28E >									
374 	//     < RUSS_PFVI_I_metadata_line_40_____UPRECHISTENKA3_3319C1_MOS_RUS_X_20211101 >									
375 	//        < qs8jeWntq3spt0rkB25T7k0voDTL84zDO0BMUxr30x3x1r15F4c690Uog0Yr99yp >									
376 	//        <  u =="0.000000000000000001" : ] 000000594991496.060338000000000000 ; 000000608977150.836653000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000038BE28E3A139B3 >									
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