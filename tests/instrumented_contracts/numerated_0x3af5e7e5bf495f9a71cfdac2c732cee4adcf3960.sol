1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXXII_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXXII_I_883		"	;
8 		string	public		symbol =	"	RUSS_PFXXII_I_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		594213992801177000000000000					;	
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
92 	//     < RUSS_PFXXII_I_metadata_line_1_____RUSSIAN_FEDERATION_BOND_1_20211101 >									
93 	//        < AXu11qOQ1D8b09Sh2ngmtGIo8Xt2876970vTc2t5zrMeSnN7oIw0GM1gds74fEs3 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000015775086.593784600000000000 ] >									
95 	//        < 0x0000000000000000000000000000000000000000000000000000000000181225 >									
96 	//     < RUSS_PFXXII_I_metadata_line_2_____RF_BOND_2_20211101 >									
97 	//        < 69ArHB63wg1636kAXP54hTw910Auk8xErObG6weLCLHzWKe901Bl3LQ7DCc6BH6m >									
98 	//        <  u =="0.000000000000000001" : ] 000000015775086.593784600000000000 ; 000000031344224.776460500000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000001812252FD3D6 >									
100 	//     < RUSS_PFXXII_I_metadata_line_3_____RF_BOND_3_20211101 >									
101 	//        < 3pWmp140VJwmkKY374Xt44Q0Xu7K070t3TJUfw1F32787Xa5TR64YnQPi6U36Wur >									
102 	//        <  u =="0.000000000000000001" : ] 000000031344224.776460500000000000 ; 000000044756238.279317300000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000002FD3D6444AE8 >									
104 	//     < RUSS_PFXXII_I_metadata_line_4_____RF_BOND_4_20211101 >									
105 	//        < MwpHG7x6DE2jo7yMGn7J35iGW1lAB6jbl62RAHUdkA472dG5683P2Ty43cUTC3L5 >									
106 	//        <  u =="0.000000000000000001" : ] 000000044756238.279317300000000000 ; 000000058785595.914810000000000000 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000000000444AE859B320 >									
108 	//     < RUSS_PFXXII_I_metadata_line_5_____RF_BOND_5_20211101 >									
109 	//        < 9mbSq4I0pe875RMrvfjk3J0RFwJO0eu6dS3Rt5005t436Gj0KM81THJE2E2Gh6Iq >									
110 	//        <  u =="0.000000000000000001" : ] 000000058785595.914810000000000000 ; 000000072551512.554126500000000000 ] >									
111 	//        < 0x000000000000000000000000000000000000000000000000000059B3206EB46F >									
112 	//     < RUSS_PFXXII_I_metadata_line_6_____RF_BOND_6_20211101 >									
113 	//        < Sv006CH41jwZ4L2vTkM9rhefSUiZlswt8uaWK34Gdapt74x9dGhVf9a83t457YpA >									
114 	//        <  u =="0.000000000000000001" : ] 000000072551512.554126500000000000 ; 000000086572742.662558200000000000 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000000000006EB46F84197A >									
116 	//     < RUSS_PFXXII_I_metadata_line_7_____RF_BOND_7_20211101 >									
117 	//        < J7ofb39odb9b0x9EwI0u70ZH4YJDRW1b5mCB2Re8ISu6451mrQeZxA32w4Z7lWE9 >									
118 	//        <  u =="0.000000000000000001" : ] 000000086572742.662558200000000000 ; 000000101138262.404971000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000000084197A9A5322 >									
120 	//     < RUSS_PFXXII_I_metadata_line_8_____RF_BOND_8_20211101 >									
121 	//        < YmiIZ5Cg134184TE6dp4xWLGJIm322llV7Ab61x8mG5FAI8xP13Ba8ag8921VDZR >									
122 	//        <  u =="0.000000000000000001" : ] 000000101138262.404971000000000000 ; 000000114377570.259076000000000000 ] >									
123 	//        < 0x00000000000000000000000000000000000000000000000000009A5322AE86BD >									
124 	//     < RUSS_PFXXII_I_metadata_line_9_____RF_BOND_9_20211101 >									
125 	//        < K3w63x3Leh6aIfAJifDmaZ6dZEv811HL7D487Ue2252Iw7Z2OBRyfY6Y3reyrCdQ >									
126 	//        <  u =="0.000000000000000001" : ] 000000114377570.259076000000000000 ; 000000128942652.868124000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000000AE86BDC4C039 >									
128 	//     < RUSS_PFXXII_I_metadata_line_10_____RF_BOND_10_20211101 >									
129 	//        < 3pNdg14HJVCr70Q26R74KO7T4B4X2Qp1Am63dVw9si377L09QkZO5p3TTljf5ML3 >									
130 	//        <  u =="0.000000000000000001" : ] 000000128942652.868124000000000000 ; 000000144411273.972242000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000000C4C039DC5AA7 >									
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
174 	//     < RUSS_PFXXII_I_metadata_line_11_____RUSS_CENTRAL_BANK_BOND_1_20211101 >									
175 	//        < 43A715SPUta6XQ2e4H4bn5mxYJOD9nk60EuSG39mh3JOT9M1pHgE1Io74YGFj2lP >									
176 	//        <  u =="0.000000000000000001" : ] 000000144411273.972242000000000000 ; 000000159468647.148255000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000000DC5AA7F35471 >									
178 	//     < RUSS_PFXXII_I_metadata_line_12_____RCB_BOND_2_20211101 >									
179 	//        < E413o6P4Z6KgY2893hL8byz4Vbl6wsLAOMi4mp3jgAcTy01AaQbhqkkNCbSB0Bep >									
180 	//        <  u =="0.000000000000000001" : ] 000000159468647.148255000000000000 ; 000000174437330.042295000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000000F3547110A2B95 >									
182 	//     < RUSS_PFXXII_I_metadata_line_13_____RCB_BOND_3_20211101 >									
183 	//        < dW7lI9t2fj81r66v98353kq7S53B1GyF3ALQumKgoHh2Q8J5p8stkkKqLw42cANJ >									
184 	//        <  u =="0.000000000000000001" : ] 000000174437330.042295000000000000 ; 000000191626641.285161000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000010A2B951246628 >									
186 	//     < RUSS_PFXXII_I_metadata_line_14_____RCB_BOND_4_20211101 >									
187 	//        < 2ztH1XaDl3ZqS47bgniB4okk6w95yYj9DxAVNio3tX230J1170HWL68kC69N1vAr >									
188 	//        <  u =="0.000000000000000001" : ] 000000191626641.285161000000000000 ; 000000205345305.369340000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000012466281395503 >									
190 	//     < RUSS_PFXXII_I_metadata_line_15_____RCB_BOND_5_20211101 >									
191 	//        < 11KUNHgErNeEAGinigUIBpw6eEGpSOH32HMEw8VBY9diCJC3c97SrU2Q65d55097 >									
192 	//        <  u =="0.000000000000000001" : ] 000000205345305.369340000000000000 ; 000000220065757.944286000000000000 ] >									
193 	//        < 0x00000000000000000000000000000000000000000000000000139550314FCB30 >									
194 	//     < RUSS_PFXXII_I_metadata_line_16_____ROSSELKHOZBANK_20211101 >									
195 	//        < 0U23u7iM84b4XDe42F8M17suTgx8SV9HoJVvPaE8TpFuBF8wGfWV0YRfYSNmi5AR >									
196 	//        <  u =="0.000000000000000001" : ] 000000220065757.944286000000000000 ; 000000235052802.664455000000000000 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000000014FCB30166A980 >									
198 	//     < RUSS_PFXXII_I_metadata_line_17_____PROMSVYAZBANK_20211101 >									
199 	//        < LIv83393y9L83HKB82l2dU00l70cc1t1H0OVj128dKoBjU00mlan7F021akL2NsQ >									
200 	//        <  u =="0.000000000000000001" : ] 000000235052802.664455000000000000 ; 000000251186564.325744000000000000 ] >									
201 	//        < 0x00000000000000000000000000000000000000000000000000166A98017F47C0 >									
202 	//     < RUSS_PFXXII_I_metadata_line_18_____BN_BANK_20211101 >									
203 	//        < dK2c5SFO60l2kkPaLp1knnbKg8Ujm2e8b9PTSHny091HydhRj2k1PwxZxWg8ShJ1 >									
204 	//        <  u =="0.000000000000000001" : ] 000000251186564.325744000000000000 ; 000000265638373.123468000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000017F47C019554FD >									
206 	//     < RUSS_PFXXII_I_metadata_line_19_____RUSSIAN_STANDARD_BANK_20211101 >									
207 	//        < GMMitO8BVID1551J297m7ecvvz8k1LrE5VteH9b3c0KwPJnNbO51lyD63UV5H175 >									
208 	//        <  u =="0.000000000000000001" : ] 000000265638373.123468000000000000 ; 000000280657456.438422000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000000019554FD1AC3FD2 >									
210 	//     < RUSS_PFXXII_I_metadata_line_20_____OTKRITIE_20211101 >									
211 	//        < 4Yqa104qMcp569C73fjPFB7Fhb4h25Fs4564pueso5I1C1Nh8m9q4gA5m8ydqN86 >									
212 	//        <  u =="0.000000000000000001" : ] 000000280657456.438422000000000000 ; 000000296908086.152153000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000001AC3FD21C50BB9 >									
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
256 	//     < RUSS_PFXXII_I_metadata_line_21_____HOME_CREDIT_FINANCE_BANK_20211101 >									
257 	//        < Uxqt6a730HRjBw9H4BOxNI1x8AsXb2H5FKTmwD59Npak4aBF402183JR0A686Vlv >									
258 	//        <  u =="0.000000000000000001" : ] 000000296908086.152153000000000000 ; 000000311796788.460000000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000001C50BB91DBC39F >									
260 	//     < RUSS_PFXXII_I_metadata_line_22_____UNICREDIT_BANK_RUSSIA_20211101 >									
261 	//        < 0327GsJ7pQfNKHiC9L7xewormmw18a2V4aSQt9p36s0Zxx7QRdjaYrmSSy4j1ST0 >									
262 	//        <  u =="0.000000000000000001" : ] 000000311796788.460000000000000000 ; 000000325304708.196480000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000001DBC39F1F06027 >									
264 	//     < RUSS_PFXXII_I_metadata_line_23_____URAL_BANK_RECONSTRUCTION_DEV_20211101 >									
265 	//        < i03AqFS87Uj2HKZ3rS0CxR72b6237484UOEDdCbX4D5Ax2W9mt43P0E09T4K7qd9 >									
266 	//        <  u =="0.000000000000000001" : ] 000000325304708.196480000000000000 ; 000000339571943.516352000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000001F06027206254A >									
268 	//     < RUSS_PFXXII_I_metadata_line_24_____AK_BARS_BANK_20211101 >									
269 	//        < 52EaMP02rM7y49MNn6hLqEcho2ad60P15YRqt80tFT2kr2zIJRt4MYhT4Y4pl7Rd >									
270 	//        <  u =="0.000000000000000001" : ] 000000339571943.516352000000000000 ; 000000354325038.130080000000000000 ] >									
271 	//        < 0x00000000000000000000000000000000000000000000000000206254A21CA838 >									
272 	//     < RUSS_PFXXII_I_metadata_line_25_____SOVCOMBANK_20211101 >									
273 	//        < 4K08rOD0fYl1JKfQc2JeZuV9jc9cu957aYZ99JafDQ455Fs9b1RLk6nMkNnF95nN >									
274 	//        <  u =="0.000000000000000001" : ] 000000354325038.130080000000000000 ; 000000370281905.719430000000000000 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000000000021CA838235015F >									
276 	//     < RUSS_PFXXII_I_metadata_line_26_____MONEYGRAM_RUSS_20211101 >									
277 	//        < qXij5g52YxZ8Mi73yRhL8c81ucKpUS0ELD04hJhF71JGM4Nl9E66DmzByyqv6FIr >									
278 	//        <  u =="0.000000000000000001" : ] 000000370281905.719430000000000000 ; 000000386364193.138803000000000000 ] >									
279 	//        < 0x00000000000000000000000000000000000000000000000000235015F24D8B83 >									
280 	//     < RUSS_PFXXII_I_metadata_line_27_____VOZROZHDENIE_BANK_20211101 >									
281 	//        < 2sNBT7O6e4O0Rb1jaR1RrO5Sy4HVO8DsI5Uf0yl830Pif30m7UDW5IoxUWB3d5Ql >									
282 	//        <  u =="0.000000000000000001" : ] 000000386364193.138803000000000000 ; 000000401513240.332120000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000024D8B83264A91C >									
284 	//     < RUSS_PFXXII_I_metadata_line_28_____MTC_BANK_20211101 >									
285 	//        < G5u6bl662v4C4vSlVlU7U9n16D2591n650aatpUoAQ4F627BuS6cg2r8VPLTofcA >									
286 	//        <  u =="0.000000000000000001" : ] 000000401513240.332120000000000000 ; 000000417001132.565019000000000000 ] >									
287 	//        < 0x00000000000000000000000000000000000000000000000000264A91C27C4B11 >									
288 	//     < RUSS_PFXXII_I_metadata_line_29_____ABSOLUT_BANK_20211101 >									
289 	//        < cS1v0czluP0J3PHe70AGehtraH61fP11g7114dmL3GIO2yZ8z4oep4NFpAOm0CG8 >									
290 	//        <  u =="0.000000000000000001" : ] 000000417001132.565019000000000000 ; 000000432123035.570308000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000027C4B112935E10 >									
292 	//     < RUSS_PFXXII_I_metadata_line_30_____ROSBANK_20211101 >									
293 	//        < dYZ3SfAZK8Ei3eF6F35w4ZWaOqA455U9GkO00cK869KrI11I8ndj297qNJa6EIW3 >									
294 	//        <  u =="0.000000000000000001" : ] 000000432123035.570308000000000000 ; 000000445927718.445316000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000002935E102A86E84 >									
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
338 	//     < RUSS_PFXXII_I_metadata_line_31_____ALFA_BANK_20211101 >									
339 	//        < 2P04h4217U5yB0T8QZcv72D20053d153EirTvU226Lj79Ok090W88qA0b4PTwSZX >									
340 	//        <  u =="0.000000000000000001" : ] 000000445927718.445316000000000000 ; 000000459177917.947749000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000002A86E842BCA660 >									
342 	//     < RUSS_PFXXII_I_metadata_line_32_____SOGAZ_20211101 >									
343 	//        < UWdy6ymj0vqYcaJCJr1Ij253zUNmz85pc26NN46P6MrNqU32nDHUBya6P6U1B12s >									
344 	//        <  u =="0.000000000000000001" : ] 000000459177917.947749000000000000 ; 000000472588885.081050000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000002BCA6602D11D09 >									
346 	//     < RUSS_PFXXII_I_metadata_line_33_____RENAISSANCE_20211101 >									
347 	//        < 8wYL3K4UtGeOVok5I5G363JRw9VY5wVi8GY2St97z3l02uN5SA3DIf0QW1GSbJ38 >									
348 	//        <  u =="0.000000000000000001" : ] 000000472588885.081050000000000000 ; 000000488581140.333450000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000002D11D092E98402 >									
350 	//     < RUSS_PFXXII_I_metadata_line_34_____VTB_BANK_20211101 >									
351 	//        < 3Ari30c897L6Nm2LIS6uWcxwDtXIaw3LVBNcxj05nq23xoAZ497Pou45P2CI27AW >									
352 	//        <  u =="0.000000000000000001" : ] 000000488581140.333450000000000000 ; 000000504742499.485180000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000002E984023022D0A >									
354 	//     < RUSS_PFXXII_I_metadata_line_35_____ERGO_RUSS_20211101 >									
355 	//        < 7ydbMZ989Y06GCCR41iPbo36U3qtsK3s00qpL5II4Zp08q9CNyzX5RNJk4W5gJc9 >									
356 	//        <  u =="0.000000000000000001" : ] 000000504742499.485180000000000000 ; 000000519032117.208634000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000003022D0A317FAEC >									
358 	//     < RUSS_PFXXII_I_metadata_line_36_____GAZPROMBANK_20211101 >									
359 	//        < 3gFSB9Q2PsTmcEJs9WFw53n451n50a44W1a1R5oCcqEz4g50y1931pq1F03M06JY >									
360 	//        <  u =="0.000000000000000001" : ] 000000519032117.208634000000000000 ; 000000533692164.544548000000000000 ] >									
361 	//        < 0x00000000000000000000000000000000000000000000000000317FAEC32E5980 >									
362 	//     < RUSS_PFXXII_I_metadata_line_37_____SBERBANK_20211101 >									
363 	//        < kve9430qzS541a29jKhAONPYI6TVX9Q57q2X8KjQjB8NP1DNBOAwux1gBSkW5CJk >									
364 	//        <  u =="0.000000000000000001" : ] 000000533692164.544548000000000000 ; 000000547329453.282851000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000032E59803432891 >									
366 	//     < RUSS_PFXXII_I_metadata_line_38_____TINKOFF_BANK_20211101 >									
367 	//        < s9qzE1w351JGaN8205wasOZr63PKyBe2b6AOe2v45RuG28UfjaAJD9KFv39dX2wB >									
368 	//        <  u =="0.000000000000000001" : ] 000000547329453.282851000000000000 ; 000000561454042.634051000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000003432891358B5FC >									
370 	//     < RUSS_PFXXII_I_metadata_line_39_____VBANK_20211101 >									
371 	//        < 3a3XGaUp6eRUe58o70p1YibDyk9rNSU52DAfW373mRXgCp0yt42gYMFg38sGNZOx >									
372 	//        <  u =="0.000000000000000001" : ] 000000561454042.634051000000000000 ; 000000578512742.221519000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000358B5FC372BD8A >									
374 	//     < RUSS_PFXXII_I_metadata_line_40_____CREDIT_BANK_MOSCOW_20211101 >									
375 	//        < rzVTEN7Kh1OV9239f3puW0tjJL1331lt8nrxNfZi24impuSz45DX8z0TyPnk9QTo >									
376 	//        <  u =="0.000000000000000001" : ] 000000578512742.221519000000000000 ; 000000594213992.801177000000000000 ] >									
377 	//        < 0x00000000000000000000000000000000000000000000000000372BD8A38AB2D7 >									
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