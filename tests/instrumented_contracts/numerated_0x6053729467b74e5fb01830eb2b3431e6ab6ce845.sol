1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	BANK_I_PFI_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	BANK_I_PFI_883		"	;
8 		string	public		symbol =	"	BANK_I_PFI_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		416988875961585000000000000					;	
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
92 	//     < BANK_I_PFI_metadata_line_1_____HEIDELBERG_Stadt_20220508 >									
93 	//        < 0HF6WOBLc2RWp2SJE2Dba2W2D4fv744stok77OCU8dvVA6I2145fB37xNZw95MMt >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000010537397.332960500000000000 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000000010142C >									
96 	//     < BANK_I_PFI_metadata_line_2_____SAARBRUECKEN_Stadt_20220508 >									
97 	//        < 3JC401P2236l01x71q9W70331C16MGWtwaEa6oSSDLr9zzbgaQFWPxQ63e07g534 >									
98 	//        <  u =="0.000000000000000001" : ] 000000010537397.332960500000000000 ; 000000021065079.156408600000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000010142C20248C >									
100 	//     < BANK_I_PFI_metadata_line_3_____KAISERSLAUTERN_Stadt_20220508 >									
101 	//        < ytDhb3DeY413O1fNy4NwX1ZjeoY92aQEr0iIu2nMinJqM4MG5Bm5oEx3vGz80mQE >									
102 	//        <  u =="0.000000000000000001" : ] 000000021065079.156408600000000000 ; 000000031456670.641244200000000000 ] >									
103 	//        < 0x000000000000000000000000000000000000000000000000000020248C2FFFC3 >									
104 	//     < BANK_I_PFI_metadata_line_4_____KOBLENZ_Stadt_20220508 >									
105 	//        < S0D9p9oVZg5Yk88vJgTjeHts1lqK14q3p5A4lZLq7J4w4j6x7GH0zv0es6LuMt23 >									
106 	//        <  u =="0.000000000000000001" : ] 000000031456670.641244200000000000 ; 000000041777444.559076400000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000002FFFC33FBF50 >									
108 	//     < BANK_I_PFI_metadata_line_5_____MAINZ_Stadt_20220508 >									
109 	//        < va35EP5c32Tw9WX7vm4Qa69hQ95hWjLOQ4clfV8xU7rI9aQS4f4XFVV7V5DjGmr7 >									
110 	//        <  u =="0.000000000000000001" : ] 000000041777444.559076400000000000 ; 000000052285008.173856900000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000003FBF504FC7D5 >									
112 	//     < BANK_I_PFI_metadata_line_6_____RUESSELSHEIM_AM_MAIN_Stadt_20220508 >									
113 	//        < t7Wn79L9xi4r2Z2UDL8y19Kvk0Jl4q3VIK7oU45TflwKr8wEu993Czg08V727Dw1 >									
114 	//        <  u =="0.000000000000000001" : ] 000000052285008.173856900000000000 ; 000000062750803.519889500000000000 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000000000004FC7D55FC008 >									
116 	//     < BANK_I_PFI_metadata_line_7_____INGELHEIM_AM_RHEIN_Stadt_20220508 >									
117 	//        < 0svYzM4l4SLwRg1TZ85DoqUJ34fbWDRV29cBrCEMJzK0cadWLz2RiDlrZ82ko4l0 >									
118 	//        <  u =="0.000000000000000001" : ] 000000062750803.519889500000000000 ; 000000073024664.152861700000000000 ] >									
119 	//        < 0x00000000000000000000000000000000000000000000000000005FC0086F6D42 >									
120 	//     < BANK_I_PFI_metadata_line_8_____WIESBADEN_Stadt_20220508 >									
121 	//        < e20d9FS0BhdaV5qvYw7Oeh5q9I31GtsJcOKA3Ufts8Oq85Ftpuv4N0VQiT4cHo0R >									
122 	//        <  u =="0.000000000000000001" : ] 000000073024664.152861700000000000 ; 000000083352549.902785400000000000 ] >									
123 	//        < 0x00000000000000000000000000000000000000000000000000006F6D427F2F97 >									
124 	//     < BANK_I_PFI_metadata_line_9_____FRANKFURT_AM_MAIN_Stadt_20220508 >									
125 	//        < wOp5h8M04N6K6pv10J601WmTmJcJPmEIbOxaYqGXBo7FDk90Mmj1ov64V2N58jyH >									
126 	//        <  u =="0.000000000000000001" : ] 000000083352549.902785400000000000 ; 000000093856729.496546700000000000 ] >									
127 	//        < 0x00000000000000000000000000000000000000000000000000007F2F978F36C9 >									
128 	//     < BANK_I_PFI_metadata_line_10_____DARMSTADT_Stadt_20220508 >									
129 	//        < 6x2foolTI12LYv5Q2VTqdkbNP0e53w91C27JEgA4ByT9lysp42bHj43pSt431CJ8 >									
130 	//        <  u =="0.000000000000000001" : ] 000000093856729.496546700000000000 ; 000000104271499.989456000000000000 ] >									
131 	//        < 0x00000000000000000000000000000000000000000000000000008F36C99F1B0E >									
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
174 	//     < BANK_I_PFI_metadata_line_11_____LUDWIGSHAFEN_Stadt_20220508 >									
175 	//        < cR66273acZ3hO9zhC71MDBkU5KNUC3yc0Ctp5Ln3MOPRUGY321WRVuWk1ul7hTXY >									
176 	//        <  u =="0.000000000000000001" : ] 000000104271499.989456000000000000 ; 000000114568767.791547000000000000 ] >									
177 	//        < 0x00000000000000000000000000000000000000000000000000009F1B0EAED16D >									
178 	//     < BANK_I_PFI_metadata_line_12_____MANNHEIM_Stadt_20220508 >									
179 	//        < V16h18sHOTPpUj6b4t4nYI6pS0z086KSd5KWVH6P3JNN9bkv05Vra62724DfaM4T >									
180 	//        <  u =="0.000000000000000001" : ] 000000114568767.791547000000000000 ; 000000124863796.448770000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000000AED16DBE86EC >									
182 	//     < BANK_I_PFI_metadata_line_13_____KARLSRUHE_Stadt_20220508 >									
183 	//        < b11PJkE3dU5HGX1qi50IilYpq99wFU5zF5zEgvxJMFWQ055yYADmR9y4FpTNKd5e >									
184 	//        <  u =="0.000000000000000001" : ] 000000124863796.448770000000000000 ; 000000135410523.606948000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000000BE86ECCE9EBC >									
186 	//     < BANK_I_PFI_metadata_line_14_____STUTTGART_Stadt_20220508 >									
187 	//        < z7s5nf3PMU6QYHGVNsa73zk3y7cxke6o2AMZR52B179PJ563dV489aI3z40G2fNr >									
188 	//        <  u =="0.000000000000000001" : ] 000000135410523.606948000000000000 ; 000000145710861.278035000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000000CE9EBCDE564E >									
190 	//     < BANK_I_PFI_metadata_line_15_____AUGSBURG_Stadt_20220508 >									
191 	//        < uB4TOc076mwmIqHgu94ldSrU5lu2pyp7dCvlt2gJrNKNK8GSoETIk4HN2t8Eut6W >									
192 	//        <  u =="0.000000000000000001" : ] 000000145710861.278035000000000000 ; 000000156164381.923785000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000000DE564EEE49B6 >									
194 	//     < BANK_I_PFI_metadata_line_16_____INGOLSTADT_Stadt_20220508 >									
195 	//        < kdb4T2Vi0n6iwJ0g76SnxYPpB9p8r0620iC57XujNYq7MLt89CM7l2wSa64P11oP >									
196 	//        <  u =="0.000000000000000001" : ] 000000156164381.923785000000000000 ; 000000166686513.335254000000000000 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000000000EE49B6FE57EB >									
198 	//     < BANK_I_PFI_metadata_line_17_____NUERNBERG_Stadt_20220508 >									
199 	//        < 3Hn360y11okkCM6q2jNePiEr85DxPK7uDk1t0mF205ooS3Yo56ke3NRof4a1mKcN >									
200 	//        <  u =="0.000000000000000001" : ] 000000166686513.335254000000000000 ; 000000177189443.365729000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000000FE57EB10E5EA0 >									
202 	//     < BANK_I_PFI_metadata_line_18_____REGENSBURG_Stadt_20220508 >									
203 	//        < Sfr56K1YS12q0o207a3q31s5Ehg09o9Qf6pkjPaMrr0br0v14c88EE5kVW31gpD9 >									
204 	//        <  u =="0.000000000000000001" : ] 000000177189443.365729000000000000 ; 000000187583062.647532000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000010E5EA011E3AA2 >									
206 	//     < BANK_I_PFI_metadata_line_19_____HANNOVER_Stadt_20220508 >									
207 	//        < nI7qW6kdgG2dc1K26l9QYbLQYTQWHud7JKvoFGLi2d5kwGk7y0P04hef33fkdpOH >									
208 	//        <  u =="0.000000000000000001" : ] 000000187583062.647532000000000000 ; 000000198085176.841987000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000000011E3AA212E4106 >									
210 	//     < BANK_I_PFI_metadata_line_20_____AACHEN_Stadt_20220508 >									
211 	//        < L565YhFz2SB0rp8AKC3OVo4ZPxQ5Z07V71MEsqv6AC14L48ro147FDIi01xDdfI1 >									
212 	//        <  u =="0.000000000000000001" : ] 000000198085176.841987000000000000 ; 000000208557945.047009000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000012E410613E3BF3 >									
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
256 	//     < BANK_I_PFI_metadata_line_21_____KOELN_Stadt_20220508 >									
257 	//        < 8mA6iufuLl9WlK3k5Gctrm0c69XC1mrn4JdauF5dLS9xoxGsJ9XOI57Ze3AJnxB1 >									
258 	//        <  u =="0.000000000000000001" : ] 000000208557945.047009000000000000 ; 000000218849258.419003000000000000 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000000013E3BF314DEFFE >									
260 	//     < BANK_I_PFI_metadata_line_22_____DUESSELDORF_Stadt_20220508 >									
261 	//        < uq9iW7MWh1D7o545Fsz70Vj3UKOuw7aJ31Zx708t5b8u8UZ6p14jbSh5xs281oI2 >									
262 	//        <  u =="0.000000000000000001" : ] 000000218849258.419003000000000000 ; 000000229147654.481549000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000014DEFFE15DA6CD >									
264 	//     < BANK_I_PFI_metadata_line_23_____BONN_Stadt_20220508 >									
265 	//        < AT2K760l4yM111D196uBYjyamx2dvRdhY24TW8vhk3tx4DajowNp2kwlJJn4gdWP >									
266 	//        <  u =="0.000000000000000001" : ] 000000229147654.481549000000000000 ; 000000239662427.258351000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000015DA6CD16DB223 >									
268 	//     < BANK_I_PFI_metadata_line_24_____DUISBURG_Stadt_20220508 >									
269 	//        < 7Ra0uJLSujYaK724KW77I4x3Cj8vu2e9LO8H6i5Y3j51G70o80PoEq8m4aIbK29y >									
270 	//        <  u =="0.000000000000000001" : ] 000000239662427.258351000000000000 ; 000000250060485.959884000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000016DB22317D8FE1 >									
272 	//     < BANK_I_PFI_metadata_line_25_____WUPPERTAL_Stadt_20220508 >									
273 	//        < 5isJ0342TXu1hL14KQXo4DV5PQe3i1D0D0wJy4lneA1MAqf174lxJ0l25DL2sA1W >									
274 	//        <  u =="0.000000000000000001" : ] 000000250060485.959884000000000000 ; 000000260540528.809734000000000000 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000000000017D8FE118D8DA5 >									
276 	//     < BANK_I_PFI_metadata_line_26_____ESSEN_Stadt_20220508 >									
277 	//        < 6uOqo7D02h9IfGkUOE2pA5cMYnYiZUp1XizgnsA397Oz0KEIZY77mM2h9X8aGxHs >									
278 	//        <  u =="0.000000000000000001" : ] 000000260540528.809734000000000000 ; 000000271037998.627430000000000000 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000000000018D8DA519D9238 >									
280 	//     < BANK_I_PFI_metadata_line_27_____DORTMUND_Stadt_20220508 >									
281 	//        < vYgxV9In1oS10Zh6yMpnv3R74tF0cggGoSdK09lA7J2QozqG2bI7l53YVfiSOvyG >									
282 	//        <  u =="0.000000000000000001" : ] 000000271037998.627430000000000000 ; 000000281487594.805757000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000019D92381AD8417 >									
284 	//     < BANK_I_PFI_metadata_line_28_____MUENSTER_Stadt_20220508 >									
285 	//        < TN9b863zi9v5E25ew4ly9jRXde8FcwgOr7N7EFeK46L862Jqd0lKgQ741d49oWDU >									
286 	//        <  u =="0.000000000000000001" : ] 000000281487594.805757000000000000 ; 000000291812901.078016000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000001AD84171BD456A >									
288 	//     < BANK_I_PFI_metadata_line_29_____MOENCHENGLADBACH_Stadt_20220508 >									
289 	//        < 56hm84xajkpGG16fTyF4mud6e6R90P9VH7309K72mk4LAUkbZMItl1jihvbBVGPN >									
290 	//        <  u =="0.000000000000000001" : ] 000000291812901.078016000000000000 ; 000000302261925.445013000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000001BD456A1CD3711 >									
292 	//     < BANK_I_PFI_metadata_line_30_____WORMS_Stadt_20220508 >									
293 	//        < O6jIorMGUfufYgSj4jV0l3S2rLAvKQk0ls63rf22wLR0TWMMC0bvenOiK4VNdGnA >									
294 	//        <  u =="0.000000000000000001" : ] 000000302261925.445013000000000000 ; 000000312734390.767601000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000001CD37111DD31DF >									
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
338 	//     < BANK_I_PFI_metadata_line_31_____SPEYER_Stadt_20220508 >									
339 	//        < Hv7F2A1rkde31v2GHMQy8HW8kr3c2t376v77Cp6SZE20CUpYa4wo76j57H5yYrDa >									
340 	//        <  u =="0.000000000000000001" : ] 000000312734390.767601000000000000 ; 000000323259513.342044000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000001DD31DF1ED413F >									
342 	//     < BANK_I_PFI_metadata_line_32_____BADEN_BADEN_Stadt_20220508 >									
343 	//        < IMh6sBc1qZM1f90JBFp3S7Vxo03fS7ph8ZClOO8QzPbNOc8mJRa5fFhv57qeO645 >									
344 	//        <  u =="0.000000000000000001" : ] 000000323259513.342044000000000000 ; 000000333643550.312598000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000001ED413F1FD1983 >									
346 	//     < BANK_I_PFI_metadata_line_33_____OFFENBURG_Stadt_20220508 >									
347 	//        < 2R9LXc96Gv1116579U8dKRIiZ2rjYo4z6QDUj451pTit2N8Kuc28FtvIBhgWPCf1 >									
348 	//        <  u =="0.000000000000000001" : ] 000000333643550.312598000000000000 ; 000000344176641.326491000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000001FD198320D2C00 >									
350 	//     < BANK_I_PFI_metadata_line_34_____FREIBURG_AM_BREISGAU_Stadt_20220508 >									
351 	//        < 4GVvHQyC7K7blK40Pxvna4Iq3h8JQEh9yg0oFx6s8E8r7L76TU7W67hzNX9Bvk8d >									
352 	//        <  u =="0.000000000000000001" : ] 000000344176641.326491000000000000 ; 000000354505341.527816000000000000 ] >									
353 	//        < 0x0000000000000000000000000000000000000000000000000020D2C0021CEEA6 >									
354 	//     < BANK_I_PFI_metadata_line_35_____KEMPTEN_Stadt_20220508 >									
355 	//        < WxR3m02ps6kAiBMPmfc98Um92pRIbZDzIX7naGUIndD838k7SnqpT9GMp4dL168S >									
356 	//        <  u =="0.000000000000000001" : ] 000000354505341.527816000000000000 ; 000000364855098.664682000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000021CEEA622CB986 >									
358 	//     < BANK_I_PFI_metadata_line_36_____ULM_Stadt_20220508 >									
359 	//        < 5OLPg8DNU98BkL3o6UE5PW4Pp1J9kzq0QT5CRu510T72iJ63Og951wtvC1sY12J4 >									
360 	//        <  u =="0.000000000000000001" : ] 000000364855098.664682000000000000 ; 000000375222874.068949000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000022CB98623C8B6F >									
362 	//     < BANK_I_PFI_metadata_line_37_____RAVENSBURG_Stadt_20220508 >									
363 	//        < T58g7nfGf243e2vcqfT42sxch1V42mMO417hla8aDo7GKS3wodJ6GAdiq0mZ68s5 >									
364 	//        <  u =="0.000000000000000001" : ] 000000375222874.068949000000000000 ; 000000385640788.300436000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000023C8B6F24C70EF >									
366 	//     < BANK_I_PFI_metadata_line_38_____FRIEDRICHSHAFEN_Stadt_20220508 >									
367 	//        < 8SQO0q8Vji9F5J4s92GOPT5EeyBw9jPPi8z33J14zT5hs2ntBz9rW2aZNf6R6k70 >									
368 	//        <  u =="0.000000000000000001" : ] 000000385640788.300436000000000000 ; 000000396051193.196656000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000024C70EF25C537F >									
370 	//     < BANK_I_PFI_metadata_line_39_____KONSTANZ_Stadt_20220508 >									
371 	//        < wZ4ZLk9S3IoA89u41pS5MFMmVDujbhKt0C77uZ46gzUV9Jc9ob6qs75E6p1jsevY >									
372 	//        <  u =="0.000000000000000001" : ] 000000396051193.196656000000000000 ; 000000406439694.552951000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000025C537F26C2D81 >									
374 	//     < BANK_I_PFI_metadata_line_40_____A40_20220508 >									
375 	//        < 2z4nA92666cy4yMR6odN3a2VS3s4Scn9gvqbtJ7i7FV7y0k56G43JMTM5AB2XwoU >									
376 	//        <  u =="0.000000000000000001" : ] 000000406439694.552951000000000000 ; 000000416988875.961585000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000026C2D8127C4648 >									
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