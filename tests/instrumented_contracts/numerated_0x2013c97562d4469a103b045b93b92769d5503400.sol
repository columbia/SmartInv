1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXVII_II_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXVII_II_883		"	;
8 		string	public		symbol =	"	RUSS_PFXVII_II_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		830668887505646000000000000					;	
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
92 	//     < RUSS_PFXVII_II_metadata_line_1_____URALKALI_1_ORG_20231101 >									
93 	//        < EDP31n9cFK1yivYP5zjgSC2cN9O6Ks66I3q2oCZC8Cg8j0c1vk7kq2lVBP7g31b8 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000022166372.847208800000000000 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000000021D2BD >									
96 	//     < RUSS_PFXVII_II_metadata_line_2_____URALKALI_1_DAO_20231101 >									
97 	//        < Yy8xSrLH1c84lES0410qRjxhk40zkeg4QQZN225tQqKQSK6Gj9NVp7J1KaZEb74K >									
98 	//        <  u =="0.000000000000000001" : ] 000000022166372.847208800000000000 ; 000000040938047.056031000000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000021D2BD3E776D >									
100 	//     < RUSS_PFXVII_II_metadata_line_3_____URALKALI_1_DAOPI_20231101 >									
101 	//        < 36wt4Xl9pY3zI9hM8g254ZvWmY4Mi1pzV9Cff0BqINuorq2yyTmN5o2xZcNEixKp >									
102 	//        <  u =="0.000000000000000001" : ] 000000040938047.056031000000000000 ; 000000057023163.232498700000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000003E776D5702AC >									
104 	//     < RUSS_PFXVII_II_metadata_line_4_____URALKALI_1_DAC_20231101 >									
105 	//        < s9T5Rcd0bZqga9Qwow6x3n357C3f4N1gPih579ThtI95D2ZxhvTK67q9VD995ZcN >									
106 	//        <  u =="0.000000000000000001" : ] 000000057023163.232498700000000000 ; 000000077893245.605501500000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000005702AC76DB0D >									
108 	//     < RUSS_PFXVII_II_metadata_line_5_____URALKALI_1_BIMI_20231101 >									
109 	//        < vnB6M589IvvQ1EAnZnptgp0mkOTBUy7tL6BWUM208R38Xu49leqV6IW7DUBxHO1M >									
110 	//        <  u =="0.000000000000000001" : ] 000000077893245.605501500000000000 ; 000000100449495.138056000000000000 ] >									
111 	//        < 0x000000000000000000000000000000000000000000000000000076DB0D994616 >									
112 	//     < RUSS_PFXVII_II_metadata_line_6_____URALKALI_2_ORG_20231101 >									
113 	//        < LxZlDX8f7MQB2Yz0v8WKEi05uRV3uUN6667yQkJz43rA0x9rUee6vVyusZ7uOTAK >									
114 	//        <  u =="0.000000000000000001" : ] 000000100449495.138056000000000000 ; 000000120420865.643806000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000994616B7BF67 >									
116 	//     < RUSS_PFXVII_II_metadata_line_7_____URALKALI_2_DAO_20231101 >									
117 	//        < WXZvH71r4eEMq18b0pUe4g52XTpG4cBeoeJcALe08idSCRCSzu7Bo0zl7107oky4 >									
118 	//        <  u =="0.000000000000000001" : ] 000000120420865.643806000000000000 ; 000000143530440.174996000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000B7BF67DB0294 >									
120 	//     < RUSS_PFXVII_II_metadata_line_8_____URALKALI_2_DAOPI_20231101 >									
121 	//        < O2004190IOF2NmXK0vDA5uXw117fAU33lD66aN4vIN0gK83n7S2RG2YwZP53qeoI >									
122 	//        <  u =="0.000000000000000001" : ] 000000143530440.174996000000000000 ; 000000159400927.652617000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000DB0294F339FD >									
124 	//     < RUSS_PFXVII_II_metadata_line_9_____URALKALI_2_DAC_20231101 >									
125 	//        < FKbErWLGdeaC43g2eH5557x680Dc7124l2fR58HV13OJKAIC6sW065g1PO5qNME8 >									
126 	//        <  u =="0.000000000000000001" : ] 000000159400927.652617000000000000 ; 000000178998414.033886000000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000000F339FD1112141 >									
128 	//     < RUSS_PFXVII_II_metadata_line_10_____URALKALI_2_BIMI_20231101 >									
129 	//        < dYq728L9L01TZIt31z04BB773W5Zhy31WV20736cvAkhReuQ87w3w2VPQ8C69hli >									
130 	//        <  u =="0.000000000000000001" : ] 000000178998414.033886000000000000 ; 000000203127460.240141000000000000 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000000001112141135F2AA >									
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
174 	//     < RUSS_PFXVII_II_metadata_line_11_____KAMA_1_ORG_20231101 >									
175 	//        < 3UpQC8ij9lQ6PI8sqwCvD07H1P76s81GLKNTa0FMlZ3824Kdw7qz3Yf6C6i9PtBu >									
176 	//        <  u =="0.000000000000000001" : ] 000000203127460.240141000000000000 ; 000000220192549.031385000000000000 ] >									
177 	//        < 0x00000000000000000000000000000000000000000000000000135F2AA14FFCB7 >									
178 	//     < RUSS_PFXVII_II_metadata_line_12_____KAMA_1_DAO_20231101 >									
179 	//        < mpqfT6prM11aN0DMNfvmiY61J5W7czs71Oy1FPh2k4fmkP2z03R49K7Q6wJiO1BH >									
180 	//        <  u =="0.000000000000000001" : ] 000000220192549.031385000000000000 ; 000000237620697.903377000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000014FFCB716A9496 >									
182 	//     < RUSS_PFXVII_II_metadata_line_13_____KAMA_1_DAOPI_20231101 >									
183 	//        < 380g37h2obGKLoY7EGLNAi7TPxN34fQs3rbES5H5hN8UKl5hdp9nVd0gJe8DQb43 >									
184 	//        <  u =="0.000000000000000001" : ] 000000237620697.903377000000000000 ; 000000259764055.137544000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000016A949618C5E56 >									
186 	//     < RUSS_PFXVII_II_metadata_line_14_____KAMA_1_DAC_20231101 >									
187 	//        < teDEjk8xnc0toa870kN2f3fSAOZ8NLg43iOiWr7gD7a4NRF2UFCItE8047K34g7m >									
188 	//        <  u =="0.000000000000000001" : ] 000000259764055.137544000000000000 ; 000000278066547.806686000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000018C5E561A84BBF >									
190 	//     < RUSS_PFXVII_II_metadata_line_15_____KAMA_1_BIMI_20231101 >									
191 	//        < l8mYlR7nZGBL4J0kvD82BzU70E2F8p9w8NrvJE62YVm67M7c3bj0Z7BGXZjv1IA6 >									
192 	//        <  u =="0.000000000000000001" : ] 000000278066547.806686000000000000 ; 000000293764614.681944000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000001A84BBF1C03FCD >									
194 	//     < RUSS_PFXVII_II_metadata_line_16_____KAMA_2_ORG_20231101 >									
195 	//        < 53pzXz5m852e5ejxnyjM1vEcG4gkN8yQ69Do1WuKS9kKxzMXw4Y3Pt28y9KGwD8Q >									
196 	//        <  u =="0.000000000000000001" : ] 000000293764614.681944000000000000 ; 000000314407513.626898000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000001C03FCD1DFBF6F >									
198 	//     < RUSS_PFXVII_II_metadata_line_17_____KAMA_2_DAO_20231101 >									
199 	//        < pBiPV2KF8xDqAEPRSwhs014JV35R3GeRR1eCQbC6dttIatMuQ6N2IevCiBGTpgu6 >									
200 	//        <  u =="0.000000000000000001" : ] 000000314407513.626898000000000000 ; 000000336804610.865167000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000001DFBF6F201EC4D >									
202 	//     < RUSS_PFXVII_II_metadata_line_18_____KAMA_2_DAOPI_20231101 >									
203 	//        < 0t9lR2519220u24B7Rqwad8eX1dqN4vIvN8LF8n3m2o4l7HAXv73Z2kKHD2z3QM9 >									
204 	//        <  u =="0.000000000000000001" : ] 000000336804610.865167000000000000 ; 000000354802042.180710000000000000 ] >									
205 	//        < 0x00000000000000000000000000000000000000000000000000201EC4D21D628C >									
206 	//     < RUSS_PFXVII_II_metadata_line_19_____KAMA_2_DAC_20231101 >									
207 	//        < eQ7OJq0Jel7295Hg7IUZ3NMc6r1Y83Zc3I9RDu7IlB3eQxcfloH5QS4UON01l6T3 >									
208 	//        <  u =="0.000000000000000001" : ] 000000354802042.180710000000000000 ; 000000376780723.901477000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000000021D628C23EEBF8 >									
210 	//     < RUSS_PFXVII_II_metadata_line_20_____KAMA_2_BIMI_20231101 >									
211 	//        < pVw123DTJz4f2OUL8pI48y7r2cQLn5Ujakr5b7hG5mU8slFH3R2Cd2smdOYoDA56 >									
212 	//        <  u =="0.000000000000000001" : ] 000000376780723.901477000000000000 ; 000000401010652.756006000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000023EEBF8263E4C9 >									
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
256 	//     < RUSS_PFXVII_II_metadata_line_21_____KAMA_20231101 >									
257 	//        < A7D632h04O64nB9jmx3ep5gxyOq5p277Uod812S09i4bA31uBhvFB9O8C7g4S730 >									
258 	//        <  u =="0.000000000000000001" : ] 000000401010652.756006000000000000 ; 000000418173711.732053000000000000 ] >									
259 	//        < 0x00000000000000000000000000000000000000000000000000263E4C927E151B >									
260 	//     < RUSS_PFXVII_II_metadata_line_22_____URALKALI_TRADING_SIA_20231101 >									
261 	//        < sbY781010FNTYRWE97cKgCg4f4L76J6G1rFSb8jGBuP21Bf00X34SOlv6K0cwkV3 >									
262 	//        <  u =="0.000000000000000001" : ] 000000418173711.732053000000000000 ; 000000436312911.400924000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000027E151B299C2BB >									
264 	//     < RUSS_PFXVII_II_metadata_line_23_____BALTIC_BULKER_TERMINAL_20231101 >									
265 	//        < 10Vjz83Dh7O53t4S1KM9XiB4aR8ay13b8W4MnwR3pNy2n73WepOgfiJ39Bil48CH >									
266 	//        <  u =="0.000000000000000001" : ] 000000436312911.400924000000000000 ; 000000458841870.859729000000000000 ] >									
267 	//        < 0x00000000000000000000000000000000000000000000000000299C2BB2BC231B >									
268 	//     < RUSS_PFXVII_II_metadata_line_24_____URALKALI_FINANCE_LIMITED_20231101 >									
269 	//        < V8Ir45v1ZHNg2m2cPuYisj8BB1bZ8PxA6vxQcV76kIeL5fo8dH4vkxztn02ADAnL >									
270 	//        <  u =="0.000000000000000001" : ] 000000458841870.859729000000000000 ; 000000482602661.835470000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000002BC231B2E064AA >									
272 	//     < RUSS_PFXVII_II_metadata_line_25_____SOLIKAMSK_CONSTRUCTION_TRUST_20231101 >									
273 	//        < gk7K1571o1T5zrdXDUfHuX151ed6r230On8H9QXJz8B6wdYlX59v9LslIu5m5REJ >									
274 	//        <  u =="0.000000000000000001" : ] 000000482602661.835470000000000000 ; 000000504860504.317718000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002E064AA3025B22 >									
276 	//     < RUSS_PFXVII_II_metadata_line_26_____SILVINIT_CAPITAL_20231101 >									
277 	//        < 84GIIS6j0qJRQB5Kk7w9Sq98245Lg0G4J52t1wctUOsGVpJ62hR0rg6gHitO5HTc >									
278 	//        <  u =="0.000000000000000001" : ] 000000504860504.317718000000000000 ; 000000529619941.705992000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000003025B2232822CA >									
280 	//     < RUSS_PFXVII_II_metadata_line_27_____AUTOMATION_MEASUREMENTS_CENTER_20231101 >									
281 	//        < 7smoSds3ly58c8Y9Zfhh0umf6Ek6Pb2Er4A7EanCN3Zf629H67M975y3SdEHKgN1 >									
282 	//        <  u =="0.000000000000000001" : ] 000000529619941.705992000000000000 ; 000000550437210.817112000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000032822CA347E689 >									
284 	//     < RUSS_PFXVII_II_metadata_line_28_____LOVOZERSKAYA_ORE_DRESSING_CO_20231101 >									
285 	//        < 89F8nTz4x7ap9g5Pw341687nUsVn1p3Bt4c4cGO3g0jN6i6rOj1HBc3e98jmblnS >									
286 	//        <  u =="0.000000000000000001" : ] 000000550437210.817112000000000000 ; 000000573435707.906431000000000000 ] >									
287 	//        < 0x00000000000000000000000000000000000000000000000000347E68936AFE53 >									
288 	//     < RUSS_PFXVII_II_metadata_line_29_____URALKALI_ENGINEERING_20231101 >									
289 	//        < D1fr5bH7a7phEgAmV6y86Mz3ogKR257DMtx5g7R1z58jy4MOEa3dQus14KGiwo80 >									
290 	//        <  u =="0.000000000000000001" : ] 000000573435707.906431000000000000 ; 000000597659866.211144000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000036AFE5338FF4E3 >									
292 	//     < RUSS_PFXVII_II_metadata_line_30_____URALKALI_DEPO_20231101 >									
293 	//        < 5nU6U0fc3i8QnEEPL9DM9kTtdlk2kK2854ePKgV35i17xIpu9G9HaWOI844An8y1 >									
294 	//        <  u =="0.000000000000000001" : ] 000000597659866.211144000000000000 ; 000000614592443.795679000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000038FF4E33A9CB2C >									
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
338 	//     < RUSS_PFXVII_II_metadata_line_31_____VAGONNOE_DEPO_BALAKHONZI_20231101 >									
339 	//        < E56Wr5x67BCqsHtaWUC0h1Uc1HZ1pTw4AtR2yMdl8SkRK6ggGyagKZkSK0YWKyDw >									
340 	//        <  u =="0.000000000000000001" : ] 000000614592443.795679000000000000 ; 000000639353457.082344000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000003A9CB2C3CF9372 >									
342 	//     < RUSS_PFXVII_II_metadata_line_32_____SILVINIT_TRANSPORT_20231101 >									
343 	//        < ik1TaAwODyH1v6C61yrls3JQUV08uk4U2O9IyihYVFXT8rT23Fl4sb1oCqJJ25GA >									
344 	//        <  u =="0.000000000000000001" : ] 000000639353457.082344000000000000 ; 000000660562584.920339000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000003CF93723EFF042 >									
346 	//     < RUSS_PFXVII_II_metadata_line_33_____AUTOTRANSKALI_20231101 >									
347 	//        < RM0t6jc14U2632TZ2c49DW7P6bg7c0jT1VjeE3s6u5Gvx8ylQDPe478mRsYYPES4 >									
348 	//        <  u =="0.000000000000000001" : ] 000000660562584.920339000000000000 ; 000000677401526.089099000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000003EFF042409A1F9 >									
350 	//     < RUSS_PFXVII_II_metadata_line_34_____URALKALI_REMONT_20231101 >									
351 	//        < dO8dzxqzL0Nmr8O05Vu13D60vRO909AjV1Z9P1cZ01Ms7VE5JeL202zalP3HEMvw >									
352 	//        <  u =="0.000000000000000001" : ] 000000677401526.089099000000000000 ; 000000699074639.371869000000000000 ] >									
353 	//        < 0x00000000000000000000000000000000000000000000000000409A1F942AB408 >									
354 	//     < RUSS_PFXVII_II_metadata_line_35_____EN_RESURS_OOO_20231101 >									
355 	//        < 3vCVztUu8T5qB81Y28GCp93J0BUw5ra4a4euvU7rd8gZl322Dm2E59gDbdFwyxEX >									
356 	//        <  u =="0.000000000000000001" : ] 000000699074639.371869000000000000 ; 000000720357252.766382000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000042AB40844B2D8D >									
358 	//     < RUSS_PFXVII_II_metadata_line_36_____BSHSU_20231101 >									
359 	//        < iBLM473hes6csIZa8oOUwM4GH47UceIJ50EORd811V459DS7pn2hsykl90xgvrBV >									
360 	//        <  u =="0.000000000000000001" : ] 000000720357252.766382000000000000 ; 000000744531356.188900000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000044B2D8D4701090 >									
362 	//     < RUSS_PFXVII_II_metadata_line_37_____URALKALI_TECHNOLOGY_20231101 >									
363 	//        < 314me1RXF8jI1th6lF82cB46pP9y6ldY06K4526R5qq45qTBAFi0705R083rF4Uy >									
364 	//        <  u =="0.000000000000000001" : ] 000000744531356.188900000000000000 ; 000000767354547.575712000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000004701090492E3DF >									
366 	//     < RUSS_PFXVII_II_metadata_line_38_____KAMA_MINERAL_OOO_20231101 >									
367 	//        < K632KK3GLSK152iXn7aRchv1aCakI65sAmZ9Min948SXWHYjhk5f7010610o80oK >									
368 	//        <  u =="0.000000000000000001" : ] 000000767354547.575712000000000000 ; 000000788668620.361344000000000000 ] >									
369 	//        < 0x00000000000000000000000000000000000000000000000000492E3DF4B369AE >									
370 	//     < RUSS_PFXVII_II_metadata_line_39_____SOLIKAMSKSTROY_ZAO_20231101 >									
371 	//        < 2M0F0jsg8v7IVzTFW9hR2kJM208i3c87K9ltV27eHg0UYu4Lqx9657Jz1wdYiWM5 >									
372 	//        <  u =="0.000000000000000001" : ] 000000788668620.361344000000000000 ; 000000808074717.993874000000000000 ] >									
373 	//        < 0x000000000000000000000000000000000000000000000000004B369AE4D10630 >									
374 	//     < RUSS_PFXVII_II_metadata_line_40_____NOVAYA_NEDVIZHIMOST_20231101 >									
375 	//        < AUu01FF2p29E533FZ4gY717huMTZlyJ93kn24qzgaL92k303zE08FK7g4s4N3dR4 >									
376 	//        <  u =="0.000000000000000001" : ] 000000808074717.993874000000000000 ; 000000830668887.505646000000000000 ] >									
377 	//        < 0x000000000000000000000000000000000000000000000000004D106304F38009 >									
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