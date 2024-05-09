1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	BANK_II_PFII_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	BANK_II_PFII_883		"	;
8 		string	public		symbol =	"	BANK_II_PFII_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		427084638464841000000000000					;	
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
92 	//     < BANK_II_PFII_metadata_line_1_____GEBR_ALEXANDER_20240508 >									
93 	//        < oZcZNAV46a9aNA3t8D6kGLXy6HJ2aRY96A6B7YM6cgTnjgp1B6k4EdcyAtS6a2A5 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000010579626.473694500000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000001024AB >									
96 	//     < BANK_II_PFII_metadata_line_2_____SCHOTT _GLASWERKE_AG_20240508 >									
97 	//        < tcj44yAnFx1x0t0n3J8K15BixvRK7X1SWirfx4phMm0ar71pI4Xub8VnQ7TBC4S4 >									
98 	//        <  u =="0.000000000000000001" : ] 000000010579626.473694500000000000 ; 000000021128613.496086700000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000001024AB203D5D >									
100 	//     < BANK_II_PFII_metadata_line_3_____MAINZ_HAUPTBAHNHOF_20240508 >									
101 	//        < joPh3ymyBzAdf805vi9hCYcO24NK343POs6p476FOluycqRj8C4KG77Q6Jztr46X >									
102 	//        <  u =="0.000000000000000001" : ] 000000021128613.496086700000000000 ; 000000031630929.984611700000000000 ] >									
103 	//        < 0x0000000000000000000000000000000000000000000000000000203D5D3043D5 >									
104 	//     < BANK_II_PFII_metadata_line_4_____PORT_DOUANIER_ET_FLUVIAL_DE_MAYENCE_20240508 >									
105 	//        < hc0Cio4PO2y51aHfc7t4Ag1YEjEq96oGLJt9Xn4jOPOra7GH8sXfxIXvQ883irjD >									
106 	//        <  u =="0.000000000000000001" : ] 000000031630929.984611700000000000 ; 000000042109872.273076800000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000003043D540412B >									
108 	//     < BANK_II_PFII_metadata_line_5_____WERNER_MERTZ_20240508 >									
109 	//        < 21GcKfr2poOWHjSQU430O512I3wk11XqtjELIfAzH5394Q74ImUJVe1mrm6286g0 >									
110 	//        <  u =="0.000000000000000001" : ] 000000042109872.273076800000000000 ; 000000052954738.312379500000000000 ] >									
111 	//        < 0x000000000000000000000000000000000000000000000000000040412B50CD72 >									
112 	//     < BANK_II_PFII_metadata_line_6_____JF_HILLEBRAND_20240508 >									
113 	//        < 5UEKQm0Tzj4X3mptRv61sE4tSB0z8q9II4r2gyaXFjhM3xUyC4BZ92itzhQJts4F >									
114 	//        <  u =="0.000000000000000001" : ] 000000052954738.312379500000000000 ; 000000063633690.135356000000000000 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000000000050CD726118E9 >									
116 	//     < BANK_II_PFII_metadata_line_7_____TRANS_OCEAN_20240508 >									
117 	//        < 9o70L6Y549wW45o1n7gI5jKDE2Lt957ZdOTWr705fAS1dXB57oyux5oV1A9VMh74 >									
118 	//        <  u =="0.000000000000000001" : ] 000000063633690.135356000000000000 ; 000000074518012.733878300000000000 ] >									
119 	//        < 0x00000000000000000000000000000000000000000000000000006118E971B499 >									
120 	//     < BANK_II_PFII_metadata_line_8_____SATELLITE_LOGISTICS_GROUP_20240508 >									
121 	//        < DXm428kim42AVix10BbA26KuesW374Ruqo0vciO93j4AJXx99ljOIJJ4i87HWjCA >									
122 	//        <  u =="0.000000000000000001" : ] 000000074518012.733878300000000000 ; 000000085240312.351783700000000000 ] >									
123 	//        < 0x000000000000000000000000000000000000000000000000000071B4998210FF >									
124 	//     < BANK_II_PFII_metadata_line_9_____JF_HILLEBRAND_GROUP_20240508 >									
125 	//        < 10MAJJHngGM6ZMcU5TPgDHlnAnU8IJtoN3I63Gi99m4iQEoBL4DKE9Cs98587Jv0 >									
126 	//        <  u =="0.000000000000000001" : ] 000000085240312.351783700000000000 ; 000000095788622.563125200000000000 ] >									
127 	//        < 0x00000000000000000000000000000000000000000000000000008210FF92296E >									
128 	//     < BANK_II_PFII_metadata_line_10_____ARCHER_DANIELS_MIDLAND_20240508 >									
129 	//        < wJZ90K7jFT8H063Q7uhp5PBhtlvG5or230A4n12JK2ns55pYu94t5Xmi96zdc4bl >									
130 	//        <  u =="0.000000000000000001" : ] 000000095788622.563125200000000000 ; 000000106426559.567259000000000000 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000000000092296EA264E0 >									
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
174 	//     < BANK_II_PFII_metadata_line_11_____WEPA_20240508 >									
175 	//        < E520k24TPHQR03Vr6ut0Rw7OcwBD1GKAM1EDShZ3ca41MSmavFz959WqaK99eFiL >									
176 	//        <  u =="0.000000000000000001" : ] 000000106426559.567259000000000000 ; 000000117136712.773849000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000000A264E0B2BC87 >									
178 	//     < BANK_II_PFII_metadata_line_12_____IBM_CORP_20240508 >									
179 	//        < 03h2LIL9Z8D7yo7jbgfnJ75k6j58bH59ie1Ji8F49fd2MrCk810E79fC9N478Oo2 >									
180 	//        <  u =="0.000000000000000001" : ] 000000117136712.773849000000000000 ; 000000127649887.058313000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000000B2BC87C2C73D >									
182 	//     < BANK_II_PFII_metadata_line_13_____NOVO_NORDISK_20240508 >									
183 	//        < 8H78788FW240nU5svs28B3hgsV7xC4f85i3Gf4Gm1sr4fwXpfbT3aT443psL6z4H >									
184 	//        <  u =="0.000000000000000001" : ] 000000127649887.058313000000000000 ; 000000138122254.929238000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000000C2C73DD2C201 >									
186 	//     < BANK_II_PFII_metadata_line_14_____COFACE_20240508 >									
187 	//        < 31a4hKO94L0gX3SF5A372Ln1E9ET6BfMY75k72c7UQKf6tQRw1GI6D6CVI75fa2n >									
188 	//        <  u =="0.000000000000000001" : ] 000000138122254.929238000000000000 ; 000000148949945.100015000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000000D2C201E34793 >									
190 	//     < BANK_II_PFII_metadata_line_15_____MOGUNTIA_20240508 >									
191 	//        < 1jiC8XdHnn348y0SyBTtrY9LD3bdMh0pH4NI284ualhN01OLR6Rfc856B04r639X >									
192 	//        <  u =="0.000000000000000001" : ] 000000148949945.100015000000000000 ; 000000159611767.421113000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000000E34793F38C59 >									
194 	//     < BANK_II_PFII_metadata_line_16_____DITSCH_20240508 >									
195 	//        < o8vX74Rlyh6G1W4416DzwX67Tw1zvL5goWf8K7J3d0pGYEks6J6jmwzmudktotO9 >									
196 	//        <  u =="0.000000000000000001" : ] 000000159611767.421113000000000000 ; 000000170454238.174689000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000000F38C5910417B0 >									
198 	//     < BANK_II_PFII_metadata_line_17_____GRANDS_CHAIS_DE_FRANCE_20240508 >									
199 	//        < 1S1vb65dKab85KZaLk615hdmXOhnP8occbI1CrL707aJKGMmL7Jooy0J780isX7B >									
200 	//        <  u =="0.000000000000000001" : ] 000000170454238.174689000000000000 ; 000000181355442.013944000000000000 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000000010417B0114B9F8 >									
202 	//     < BANK_II_PFII_metadata_line_18_____Zweites Deutsches Fernsehen_ZDF_20240508 >									
203 	//        < paA5FhfoZ6G3FtIcHZa9HNhW6zzzQQd60270D6jT5nP58bA2U1j1Yn9i4Z2KmsW7 >									
204 	//        <  u =="0.000000000000000001" : ] 000000181355442.013944000000000000 ; 000000192144391.503728000000000000 ] >									
205 	//        < 0x00000000000000000000000000000000000000000000000000114B9F81253067 >									
206 	//     < BANK_II_PFII_metadata_line_19_____3SAT_20240508 >									
207 	//        < FINdOlkg1CRXcwR10nEs2TfPH7d24S7ldnbKci6ZY79U5YQAggb2MZUYI8i2Z7vp >									
208 	//        <  u =="0.000000000000000001" : ] 000000192144391.503728000000000000 ; 000000202798414.730836000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000000012530671357221 >									
210 	//     < BANK_II_PFII_metadata_line_20_____Südwestrundfunk_SWR_20240508 >									
211 	//        < H3w84m3P3y62fwuihn4IKa7JfolJW59gLLb7v342W269bw8nusjDa7197gYc896T >									
212 	//        <  u =="0.000000000000000001" : ] 000000202798414.730836000000000000 ; 000000213484200.578919000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000001357221145C044 >									
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
256 	//     < BANK_II_PFII_metadata_line_21_____SCHOTT_MUSIC_20240508 >									
257 	//        < tHrhVPHm8J7gXJaFwC32c89tHPx2mPSmlmQcK2kO1q1C8v0j6QKp81bAR0aXn5SN >									
258 	//        <  u =="0.000000000000000001" : ] 000000213484200.578919000000000000 ; 000000224061956.221901000000000000 ] >									
259 	//        < 0x00000000000000000000000000000000000000000000000000145C044155E434 >									
260 	//     < BANK_II_PFII_metadata_line_22_____Verlagsgruppe Rhein Main_20240508 >									
261 	//        < 2oPVbG38KwXuTC3q6911l6Cb646LaY3iCq7vyTpPCe0REeJ6Z8dO3pie5dJAjJ3G >									
262 	//        <  u =="0.000000000000000001" : ] 000000224061956.221901000000000000 ; 000000234550144.290312000000000000 ] >									
263 	//        < 0x00000000000000000000000000000000000000000000000000155E434165E526 >									
264 	//     < BANK_II_PFII_metadata_line_23_____Philipp von Zabern_20240508 >									
265 	//        < OE343Yl052jw5LqFt11q7U59LaQjWB7aSkVFbn6Ot2Vhi11Q91Nw1Tl6xgqRKREF >									
266 	//        <  u =="0.000000000000000001" : ] 000000234550144.290312000000000000 ; 000000245376886.567906000000000000 ] >									
267 	//        < 0x00000000000000000000000000000000000000000000000000165E5261766A59 >									
268 	//     < BANK_II_PFII_metadata_line_24_____De Dietrich Process Systems_GMBH_20240508 >									
269 	//        < 65cAi21fBHB19ViVfxndWK5Yl64UbbX1HqJA764wrV58r1ja30a8zy1au6vMbaHs >									
270 	//        <  u =="0.000000000000000001" : ] 000000245376886.567906000000000000 ; 000000255851366.672951000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000001766A5918665F1 >									
272 	//     < BANK_II_PFII_metadata_line_25_____FIRST_SOLAR_GMBH_20240508 >									
273 	//        < RV8uz2q1drpI8B1p5LBM392AhT1c89mz5974IVKs9HuTA7IKSTaoi342c24Wl18r >									
274 	//        <  u =="0.000000000000000001" : ] 000000255851366.672951000000000000 ; 000000266662458.870083000000000000 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000000000018665F1196E506 >									
276 	//     < BANK_II_PFII_metadata_line_26_____BIONTECH_SE_20240508 >									
277 	//        < 55c511chLC0jdwzyiIQC3VdIi6HICM66YD6slmJ9m2wq09T22E4456mRHX97MAeu >									
278 	//        <  u =="0.000000000000000001" : ] 000000266662458.870083000000000000 ; 000000277254690.140822000000000000 ] >									
279 	//        < 0x00000000000000000000000000000000000000000000000000196E5061A70E9D >									
280 	//     < BANK_II_PFII_metadata_line_27_____UNI_MAINZ_20240508 >									
281 	//        < AZ57vOuAhmK2888Rv62J32D8zh38F02207Ep2Kp8mxUq658xdRw84445y0613Z6z >									
282 	//        <  u =="0.000000000000000001" : ] 000000277254690.140822000000000000 ; 000000288013859.862400000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000001A70E9D1B7796A >									
284 	//     < BANK_II_PFII_metadata_line_28_____Mainz Institute of Microtechnology_20240508 >									
285 	//        < ewzzO4JTmTqwoThciyJ7wjzZIAxs0998cW8KS8f16B9fTwExR0l3R4h157qDVfIH >									
286 	//        <  u =="0.000000000000000001" : ] 000000288013859.862400000000000000 ; 000000298581781.393457000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000001B7796A1C79982 >									
288 	//     < BANK_II_PFII_metadata_line_29_____Matthias_Grünewald_Verlag_20240508 >									
289 	//        < Qy7Tvtz45J4edw8u38yp07XDnXTVWidqj9qe5y41Iy0tXKP4TMaabo9LhgzCGxEr >									
290 	//        <  u =="0.000000000000000001" : ] 000000298581781.393457000000000000 ; 000000309374759.395449000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000001C799821D81184 >									
292 	//     < BANK_II_PFII_metadata_line_30_____PEDIA_PRESS_20240508 >									
293 	//        < 0acXJipvOT2EcdD2tA6b8ZC6mOJ7yM86bx61T1gTW5776yOvQS57Pomv9LBJ5EMA >									
294 	//        <  u =="0.000000000000000001" : ] 000000309374759.395449000000000000 ; 000000320222247.931052000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000001D811841E89ED1 >									
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
338 	//     < BANK_II_PFII_metadata_line_31_____Boehringer Ingelheim_20240508 >									
339 	//        < 42uq92082wvtp9xZ8Fj3xed2QnNka76kaD7a0pwy7o5I38q0XPt35Rwxr3G4714d >									
340 	//        <  u =="0.000000000000000001" : ] 000000320222247.931052000000000000 ; 000000330725163.986010000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000001E89ED11F8A584 >									
342 	//     < BANK_II_PFII_metadata_line_32_____MIDAS_PHARMA_20240508 >									
343 	//        < nypwmxz4N4bT49Z6QeIZ44nIhiNAQexB7XFQzOGAkwMUOhn23lzB1H2vjiOU0A2Y >									
344 	//        <  u =="0.000000000000000001" : ] 000000330725163.986010000000000000 ; 000000341553780.268315000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000001F8A5842092B72 >									
346 	//     < BANK_II_PFII_metadata_line_33_____MIDAS_PHARMA_POLSKA_20240508 >									
347 	//        < Ko181eDP01COIufbM5XI1XJFL1W5A98bzczVkF1AM8chE4V7yzJfcjloGmlL2gca >									
348 	//        <  u =="0.000000000000000001" : ] 000000341553780.268315000000000000 ; 000000352380863.545366000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000002092B72219B0C6 >									
350 	//     < BANK_II_PFII_metadata_line_34_____CMS_PHARMA_20240508 >									
351 	//        < nM9yQE65v27BP0R4M4feiZR57Kg24jH24mFH6qIji2WpCEDbFHhXk0QQZSLdEAj2 >									
352 	//        <  u =="0.000000000000000001" : ] 000000352380863.545366000000000000 ; 000000362983326.882763000000000000 ] >									
353 	//        < 0x00000000000000000000000000000000000000000000000000219B0C6229DE5D >									
354 	//     < BANK_II_PFII_metadata_line_35_____CAIGOS_GMBH_20240508 >									
355 	//        < 79VUm0zP7YS3rdkXHutgjTmN9A9tm0a72JWDb38HdQi7O2y8r0KqncJ988VP18hA >									
356 	//        <  u =="0.000000000000000001" : ] 000000362983326.882763000000000000 ; 000000373885195.584688000000000000 ] >									
357 	//        < 0x00000000000000000000000000000000000000000000000000229DE5D23A80E8 >									
358 	//     < BANK_II_PFII_metadata_line_36_____Altes E_Werk der Rheinhessische Energie_und Wasserversorgungs_GmbH_20240508 >									
359 	//        < V0HW4I9cm8Ouh2QpOiINL15Y4YU7FQr3O2k33AJp2jKH691SAtNL90r0qqOt8Nyx >									
360 	//        <  u =="0.000000000000000001" : ] 000000373885195.584688000000000000 ; 000000384509720.120705000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000023A80E824AB71C >									
362 	//     < BANK_II_PFII_metadata_line_37_____THUEGA_AG_20240508 >									
363 	//        < hBi641Qu9RDd33DSek2J5GM6tN1n57JIJdE16fmJ9x292WjgGYV18Dm5E0iH4Jlp >									
364 	//        <  u =="0.000000000000000001" : ] 000000384509720.120705000000000000 ; 000000395216717.116941000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000024AB71C25B0D88 >									
366 	//     < BANK_II_PFII_metadata_line_38_____Verbandsgemeinde Heidesheim am Rhein_20240508 >									
367 	//        < hhV05yoz1I4guvl7Ffs57KL4rBTHnR2Yk8L6avek5MKN0Zn0u6r2DNp6ChwbQIVI >									
368 	//        <  u =="0.000000000000000001" : ] 000000395216717.116941000000000000 ; 000000405688350.896395000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000025B0D8826B0803 >									
370 	//     < BANK_II_PFII_metadata_line_39_____Stadtwerke Ingelheim_AB_20240508 >									
371 	//        < Y5NCg6A3X49YYG811dPGW5M96425WpvO79s73O2IbtxHkNRMck93ts68YYH5Ebsq >									
372 	//        <  u =="0.000000000000000001" : ] 000000405688350.896395000000000000 ; 000000416427857.690942000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000026B080327B6B22 >									
374 	//     < BANK_II_PFII_metadata_line_40_____rhenag Rheinische Energie AG_KOELN_20240508 >									
375 	//        < I2zMz83icTqO15RaK5pmkl88t9GQ5ok0KeP9Rzge3ivb2pib2301G0a9znZ1nNkf >									
376 	//        <  u =="0.000000000000000001" : ] 000000416427857.690942000000000000 ; 000000427084638.464842000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000027B6B2228BADF0 >									
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