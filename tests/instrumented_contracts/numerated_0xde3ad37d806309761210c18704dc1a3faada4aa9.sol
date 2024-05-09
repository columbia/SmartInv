1 pragma solidity 		^0.4.21	;						
2 									
3 contract	DUBAI_Portfolio_Ib_883				{				
4 									
5 	mapping (address => uint256) public balanceOf;								
6 									
7 	string	public		name =	"	DUBAI_Portfolio_Ib_883		"	;
8 	string	public		symbol =	"	DUBAI883I		"	;
9 	uint8	public		decimals =		18			;
10 									
11 	uint256 public totalSupply =		728002043355369000000000000					;	
12 									
13 	event Transfer(address indexed from, address indexed to, uint256 value);								
14 									
15 	function SimpleERC20Token() public {								
16 		balanceOf[msg.sender] = totalSupply;							
17 		emit Transfer(address(0), msg.sender, totalSupply);							
18 	}								
19 									
20 	function transfer(address to, uint256 value) public returns (bool success) {								
21 		require(balanceOf[msg.sender] >= value);							
22 									
23 		balanceOf[msg.sender] -= value;  // deduct from sender's balance							
24 		balanceOf[to] += value;          // add to recipient's balance							
25 		emit Transfer(msg.sender, to, value);							
26 		return true;							
27 	}								
28 									
29 	event Approval(address indexed owner, address indexed spender, uint256 value);								
30 									
31 	mapping(address => mapping(address => uint256)) public allowance;								
32 									
33 	function approve(address spender, uint256 value)								
34 		public							
35 		returns (bool success)							
36 	{								
37 		allowance[msg.sender][spender] = value;							
38 		emit Approval(msg.sender, spender, value);							
39 		return true;							
40 	}								
41 									
42 	function transferFrom(address from, address to, uint256 value)								
43 		public							
44 		returns (bool success)							
45 	{								
46 		require(value <= balanceOf[from]);							
47 		require(value <= allowance[from][msg.sender]);							
48 									
49 		balanceOf[from] -= value;							
50 		balanceOf[to] += value;							
51 		allowance[from][msg.sender] -= value;							
52 		emit Transfer(from, to, value);							
53 		return true;							
54 	}								
55 //}									
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
80 // Programme d'émission - Lignes 1 à 10									
81 //									
82 //									
83 //									
84 //									
85 //     [ Nom du portefeuille ; Numéro de la ligne ; Nom de la ligne ; Echéance ]									
86 //         [ Adresse exportée ]									
87 //         [ Unité ; Limite basse ; Limite haute ]									
88 //         [ Hex ]									
89 //									
90 //									
91 //									
92 //     < DUBAI_Portfolio_Ib_metadata_line_1_____AJMAN_BANK_20250515 >									
93 //        < L6ZuGdiGpSqAsRUnN56E6LKKU97imk8mfmeZzx1g3R7gId211fww634GQ0PJS42q >									
94 //        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000015884741.083761000000000000 ] >									
95 //        < 0x0000000000000000000000000000000000000000000000000000000000183CFA >									
96 //     < DUBAI_Portfolio_Ib_metadata_line_2_____AL_SALAM_BANK_SUDAN_20250515 >									
97 //        < acBz1cP0SiCn715k2T3ScluavLtO1oiuQ24cGq53p9l40qGoj9Y0WLM06USE5V06 >									
98 //        <  u =="0.000000000000000001" : ] 000000015884741.083761000000000000 ; 000000032229705.695558200000000000 ] >									
99 //        < 0x0000000000000000000000000000000000000000000000000000183CFA312DBB >									
100 //     < DUBAI_Portfolio_Ib_metadata_line_3_____Amlak_Finance_20250515 >									
101 //        < b13M9olAjl42ZeNb6IUPD0dPvuq3T6YDEu6F22d8kdS5t8JnLAiuRhcVPWQ60IrV >									
102 //        <  u =="0.000000000000000001" : ] 000000032229705.695558200000000000 ; 000000049089220.940360200000000000 ] >									
103 //        < 0x0000000000000000000000000000000000000000000000000000312DBB4AE77A >									
104 //     < DUBAI_Portfolio_Ib_metadata_line_4_____Commercial_Bank_Dubai_20250515 >									
105 //        < 9Q96dbdpvCDkEy8Kd3KnkSgzVc5ZCRY64p7y4zwVA91AkGnTY8iQ2fN0kHAhPRUP >									
106 //        <  u =="0.000000000000000001" : ] 000000049089220.940360200000000000 ; 000000068091782.527806200000000000 ] >									
107 //        < 0x00000000000000000000000000000000000000000000000000004AE77A67E65A >									
108 //     < DUBAI_Portfolio_Ib_metadata_line_5_____Dubai_Islamic_Bank_20250515 >									
109 //        < h1w9qAml7o12Z4WO9gFUIT26NHfvE3wm5e9VS9rU8hVnAHQeJ4Uhnr1vPzAutfJv >									
110 //        <  u =="0.000000000000000001" : ] 000000068091782.527806200000000000 ; 000000087470978.004263900000000000 ] >									
111 //        < 0x000000000000000000000000000000000000000000000000000067E65A85785A >									
112 //     < DUBAI_Portfolio_Ib_metadata_line_6_____Emirates_Islamic_Bank_20250515 >									
113 //        < anZ957Tk1xTUQY68zG3t6E57tTQA2fzxre9Q3gCHh1LV5j2B3446sTt2Rl7pISY4 >									
114 //        <  u =="0.000000000000000001" : ] 000000087470978.004263900000000000 ; 000000106997977.181169000000000000 ] >									
115 //        < 0x000000000000000000000000000000000000000000000000000085785AA34416 >									
116 //     < DUBAI_Portfolio_Ib_metadata_line_7_____Emirates_Investment_Bank_20250515 >									
117 //        < H8CXH4mU8q2uqT180Gu6yiqs25uas01DszW3e37b20KPOoQND3b6ImLpuI7H2nk7 >									
118 //        <  u =="0.000000000000000001" : ] 000000106997977.181169000000000000 ; 000000128630093.592656000000000000 ] >									
119 //        < 0x0000000000000000000000000000000000000000000000000000A34416C44621 >									
120 //     < DUBAI_Portfolio_Ib_metadata_line_8_____Emirates_NBD_20250515 >									
121 //        < S38niN1ZJ8xK4yTUo5q9b13HB7a2x9m72o1td8XdcMnp084G2ws778P352D1qY2O >									
122 //        <  u =="0.000000000000000001" : ] 000000128630093.592656000000000000 ; 000000148482651.177864000000000000 ] >									
123 //        < 0x0000000000000000000000000000000000000000000000000000C44621E29109 >									
124 //     < DUBAI_Portfolio_Ib_metadata_line_9_____Gulf_Finance_House_BSC_20250515 >									
125 //        < ht6vJF1n3YcPxFFU9qzpPc9ieOfB1hGF4c0pPa37R4KfKasVXYemlh7o8MxTx0g1 >									
126 //        <  u =="0.000000000000000001" : ] 000000148482651.177864000000000000 ; 000000166024168.285934000000000000 ] >									
127 //        < 0x0000000000000000000000000000000000000000000000000000E29109FD5531 >									
128 //     < DUBAI_Portfolio_Ib_metadata_line_10_____Mashreqbank_20250515 >									
129 //        < NmEa7LIktdZ3S5HnCtAXX66JM988VYjq37iVxquPT9HG4VXR41TY504M8726c17W >									
130 //        <  u =="0.000000000000000001" : ] 000000166024168.285934000000000000 ; 000000181090929.627096000000000000 ] >									
131 //        < 0x000000000000000000000000000000000000000000000000000FD553111452A5 >									
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
162 // Programme d'émission - Lignes 11 à 20									
163 //									
164 //									
165 //									
166 //									
167 //     [ Nom du portefeuille ; Numéro de la ligne ; Nom de la ligne ; Echéance ]									
168 //         [ Adresse exportée ]									
169 //         [ Unité ; Limite basse ; Limite haute ]									
170 //         [ Hex ]									
171 //									
172 //									
173 //									
174 //     < DUBAI_Portfolio_Ib_metadata_line_11_____Al_Salam_Bank_Bahrain_20250515 >									
175 //        < e537dm6ht75up5j50fiHG4DF62r6D7849FtH4Bjn483oUPnz1855404MSz45Yxw8 >									
176 //        <  u =="0.000000000000000001" : ] 000000181090929.627096000000000000 ; 000000201064086.828041000000000000 ] >									
177 //        < 0x0000000000000000000000000000000000000000000000000011452A5132CCA9 >									
178 //     < DUBAI_Portfolio_Ib_metadata_line_12_____Almadina_Finance_Investment_20250515 >									
179 //        < OU4nOtt06jkWQED49M0dcG6956B4jPcEJ2x43x92Co2Qp8pW9nGl2u9lp4n74cK6 >									
180 //        <  u =="0.000000000000000001" : ] 000000201064086.828041000000000000 ; 000000219910587.516598000000000000 ] >									
181 //        < 0x00000000000000000000000000000000000000000000000000132CCA914F8E93 >									
182 //     < DUBAI_Portfolio_Ib_metadata_line_13_____Al_Salam_Group_Holding_20250515 >									
183 //        < BY8PEgOv1UQ6Teki5YPdJDKf7F9Yk1rn78nu9bm3l76BWf9O1P14IZiuIDy3BH1e >									
184 //        <  u =="0.000000000000000001" : ] 000000219910587.516598000000000000 ; 000000236706596.542813000000000000 ] >									
185 //        < 0x0000000000000000000000000000000000000000000000000014F8E931692F84 >									
186 //     < DUBAI_Portfolio_Ib_metadata_line_14_____Dubai_Financial_Market_20250515 >									
187 //        < T968NPS1C52qHjnoks2cgu5T82JvBdmJ9iv59M03ljLrjhD949FIkK5bn4JUx45Z >									
188 //        <  u =="0.000000000000000001" : ] 000000236706596.542813000000000000 ; 000000254619021.069807000000000000 ] >									
189 //        < 0x000000000000000000000000000000000000000000000000001692F84184848E >									
190 //     < DUBAI_Portfolio_Ib_metadata_line_15_____Dubai_Investments_20250515 >									
191 //        < y98l8JWQt5meyoO8uvoxG8P21NTlDQzw7KwDlEET1mk71z6EAFR2k4i2lg6ZYH87 >									
192 //        <  u =="0.000000000000000001" : ] 000000254619021.069807000000000000 ; 000000273019373.496874000000000000 ] >									
193 //        < 0x00000000000000000000000000000000000000000000000000184848E1A09831 >									
194 //     < DUBAI_Portfolio_Ib_metadata_line_16_____Ekttitab_Holding_Company_KSCC_20250515 >									
195 //        < b0gBCj7fPwYW8P9YX17718TJ3ZJOBcEB54mQyoB3x7VBe6GPMXLcYl66hllWh182 >									
196 //        <  u =="0.000000000000000001" : ] 000000273019373.496874000000000000 ; 000000289417875.000936000000000000 ] >									
197 //        < 0x000000000000000000000000000000000000000000000000001A098311B99DDC >									
198 //     < DUBAI_Portfolio_Ib_metadata_line_17_____Gulf_General_Investments_Company_20250515 >									
199 //        < 0KZvniv9PPb0Ssq313EY3Fl02Sp97ZM7QiR43l72LL8Q4725pKAyMG4BFMYJq9eJ >									
200 //        <  u =="0.000000000000000001" : ] 000000289417875.000936000000000000 ; 000000307179615.891649000000000000 ] >									
201 //        < 0x000000000000000000000000000000000000000000000000001B99DDC1D4B80A >									
202 //     < DUBAI_Portfolio_Ib_metadata_line_18_____International_Financial_Advisors_KSCC_20250515 >									
203 //        < 7Fdt4rv6R3c770d7wRih97F6B5SMmXar7X0w9P0OOg5e896Qs2b92IRgYZ2Enmq7 >									
204 //        <  u =="0.000000000000000001" : ] 000000307179615.891649000000000000 ; 000000323823077.061058000000000000 ] >									
205 //        < 0x000000000000000000000000000000000000000000000000001D4B80A1EE1D64 >									
206 //     < DUBAI_Portfolio_Ib_metadata_line_19_____SHUAA_Capital_20250515 >									
207 //        < nX1ueI2sEHg871nR4GoT88JKLsJAXtm9g271IxE36479pfEYMUnhi32eflZQR6RQ >									
208 //        <  u =="0.000000000000000001" : ] 000000323823077.061058000000000000 ; 000000340399977.520851000000000000 ] >									
209 //        < 0x000000000000000000000000000000000000000000000000001EE1D6420768BE >									
210 //     < DUBAI_Portfolio_Ib_metadata_line_20_____Alliance_Insurance_20250515 >									
211 //        < 1zR4zmwdqL5Dq2aCp7yNVzZXvN7RW4qu9yotkFzihDx7CfY9x4jrE53B9vSs5yNc >									
212 //        <  u =="0.000000000000000001" : ] 000000340399977.520851000000000000 ; 000000357401143.902088000000000000 ] >									
213 //        < 0x0000000000000000000000000000000000000000000000000020768BE22159D2 >									
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
244 // Programme d'émission - Lignes 21 à 30									
245 //									
246 //									
247 //									
248 //									
249 //     [ Nom du portefeuille ; Numéro de la ligne ; Nom de la ligne ; Echéance ]									
250 //         [ Adresse exportée ]									
251 //         [ Unité ; Limite basse ; Limite haute ]									
252 //         [ Hex ]									
253 //									
254 //									
255 //									
256 //     < DUBAI_Portfolio_Ib_metadata_line_21_____Dubai_Islamic_Insurance_Reinsurance_Co_20250515 >									
257 //        < PrKhqhF10vpRzf049wL67Am6uo0Z37Wl5118SAi6bHrth5XYgzAeE314EX4bCsWw >									
258 //        <  u =="0.000000000000000001" : ] 000000357401143.902088000000000000 ; 000000375154906.591838000000000000 ] >									
259 //        < 0x0000000000000000000000000000000000000000000000000022159D223C70E3 >									
260 //     < DUBAI_Portfolio_Ib_metadata_line_22_____Arab_Insurance_Group_20250515 >									
261 //        < 3cs4xz9Dpe3cOeR6CcKe3wQ18HS09gRJld413lmYw4aTYgQO05ALdER2efllA9kI >									
262 //        <  u =="0.000000000000000001" : ] 000000375154906.591838000000000000 ; 000000392325538.991759000000000000 ] >									
263 //        < 0x0000000000000000000000000000000000000000000000000023C70E3256A42A >									
264 //     < DUBAI_Portfolio_Ib_metadata_line_23_____Arabian_Scandinavian_Insurance_20250515 >									
265 //        < 4GhKLfD860Px8NI8kUew56s396WYcVXS4Pa585c06M92TyW5vv5FVn65c0iZde2h >									
266 //        <  u =="0.000000000000000001" : ] 000000392325538.991759000000000000 ; 000000408068775.109931000000000000 ] >									
267 //        < 0x00000000000000000000000000000000000000000000000000256A42A26EA9DE >									
268 //     < DUBAI_Portfolio_Ib_metadata_line_24_____Al_Sagr_National_Insurance_Company_20250515 >									
269 //        < O1dX4914CHG2Nfd566r5Za5Gscdj8gw9RRXC66JH9FxC4dJ42Hujbs0647Anp1o2 >									
270 //        <  u =="0.000000000000000001" : ] 000000408068775.109931000000000000 ; 000000427466309.604087000000000000 ] >									
271 //        < 0x0000000000000000000000000000000000000000000000000026EA9DE28C4307 >									
272 //     < DUBAI_Portfolio_Ib_metadata_line_25_____Takaful_House_20250515 >									
273 //        < Lm1JVFRfj1K3LO7fhKWJEm6T7X8ezrp7sAXfVi1iUE6v2alVDZ8JuX29mM4W1q72 >									
274 //        <  u =="0.000000000000000001" : ] 000000427466309.604087000000000000 ; 000000446074474.416661000000000000 ] >									
275 //        < 0x0000000000000000000000000000000000000000000000000028C43072A8A7D7 >									
276 //     < DUBAI_Portfolio_Ib_metadata_line_26_____Dubai_Insurance_Co_20250515 >									
277 //        < 5Wa1yAG9M1Cfwcu73Eor93uraZ8g0Whhx91m41O7t4gwl3H6U6zY5cGvy4OxRFts >									
278 //        <  u =="0.000000000000000001" : ] 000000446074474.416661000000000000 ; 000000467318875.367803000000000000 ] >									
279 //        < 0x000000000000000000000000000000000000000000000000002A8A7D72C91270 >									
280 //     < DUBAI_Portfolio_Ib_metadata_line_27_____Dubai_National_Insurance_Reinsurance_20250515 >									
281 //        < r586jJb8Rq1nU22Hk1nUT5b6p6b2w7xFETi7qbr5TrIHE00PZlfkpekYC6u8XI4p >									
282 //        <  u =="0.000000000000000001" : ] 000000467318875.367803000000000000 ; 000000487222689.531227000000000000 ] >									
283 //        < 0x000000000000000000000000000000000000000000000000002C912702E7715D >									
284 //     < DUBAI_Portfolio_Ib_metadata_line_28_____National_General_Insurance_Company_20250515 >									
285 //        < 9t4hbYXLYQKF9C53D0EUdsgGX4uqP4LoY1WkFI6ah57vPTq78tDt7OS6yGMpmnD7 >									
286 //        <  u =="0.000000000000000001" : ] 000000487222689.531227000000000000 ; 000000505364361.034325000000000000 ] >									
287 //        < 0x000000000000000000000000000000000000000000000000002E7715D3031FF4 >									
288 //     < DUBAI_Portfolio_Ib_metadata_line_29_____Oman_Insurance_Company_20250515 >									
289 //        < FB57FP6BA63R6A3uIdJWlIZ0wQL74e52n3Dc8fe5lff5Z03Z86x83LFlaJ3m64H0 >									
290 //        <  u =="0.000000000000000001" : ] 000000505364361.034325000000000000 ; 000000527065625.946488000000000000 ] >									
291 //        < 0x000000000000000000000000000000000000000000000000003031FF43243D03 >									
292 //     < DUBAI_Portfolio_Ib_metadata_line_30_____ORIENT_Insurance_20250515 >									
293 //        < CRrto07e68fb6me4G2Z77AB7cbxfocb1nTe6b3IdY4A9oviFwLB8c8874N0WsfSS >									
294 //        <  u =="0.000000000000000001" : ] 000000527065625.946488000000000000 ; 000000547998796.510605000000000000 ] >									
295 //        < 0x000000000000000000000000000000000000000000000000003243D033442E08 >									
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
326 // Programme d'émission - Lignes 31 à 40									
327 //									
328 //									
329 //									
330 //									
331 //     [ Nom du portefeuille ; Numéro de la ligne ; Nom de la ligne ; Echéance ]									
332 //         [ Adresse exportée ]									
333 //         [ Unité ; Limite basse ; Limite haute ]									
334 //         [ Hex ]									
335 //									
336 //									
337 //									
338 //     < DUBAI_Portfolio_Ib_metadata_line_31_____Islamic_Arab_Insurance_Company_20250515 >									
339 //        < 2UKS2SWt3pF4O3Q76FfQ66j9W5oYCDdc2Vqv98HQJOljS85738bfN3Os336p50ju >									
340 //        <  u =="0.000000000000000001" : ] 000000547998796.510605000000000000 ; 000000566661310.057538000000000000 ] >									
341 //        < 0x000000000000000000000000000000000000000000000000003442E08360A813 >									
342 //     < DUBAI_Portfolio_Ib_metadata_line_32_____Takaful_Emarat_20250515 >									
343 //        < n9k2H50Pwn0TGM942712tmMM2eyj5WG4b0m3297Wq4MdLVrU50VHt6C1Eh0zH430 >									
344 //        <  u =="0.000000000000000001" : ] 000000566661310.057538000000000000 ; 000000583724083.698779000000000000 ] >									
345 //        < 0x00000000000000000000000000000000000000000000000000360A81337AB138 >									
346 //     < DUBAI_Portfolio_Ib_metadata_line_33_____Arabtec_Holding_20250515 >									
347 //        < O88c2zVDlgCdQJKj8v1L87nGL9E795ftS08YD9ACJbl2k81cD25q59LZ7V365424 >									
348 //        <  u =="0.000000000000000001" : ] 000000583724083.698779000000000000 ; 000000605437993.596515000000000000 ] >									
349 //        < 0x0000000000000000000000000000000000000000000000000037AB13839BD337 >									
350 //     < DUBAI_Portfolio_Ib_metadata_line_34_____Dubai_Development_Company_20250515 >									
351 //        < tVDvGTqz8vqY1Z93c1071erwxHExZ549rQ0sEZqQ133X3kHN5n45PCSPIk14OZWr >									
352 //        <  u =="0.000000000000000001" : ] 000000605437993.596515000000000000 ; 000000622248632.363165000000000000 ] >									
353 //        < 0x0000000000000000000000000000000000000000000000000039BD3373B579DF >									
354 //     < DUBAI_Portfolio_Ib_metadata_line_35_____Deyaar_Development_20250515 >									
355 //        < nmd29bX25ZMW54v5HqQh91G5yQ2Q049iJYYpakj561Vs3k9MFJ309b4tNq5j82c1 >									
356 //        <  u =="0.000000000000000001" : ] 000000622248632.363165000000000000 ; 000000642389976.238936000000000000 ] >									
357 //        < 0x000000000000000000000000000000000000000000000000003B579DF3D43596 >									
358 //     < DUBAI_Portfolio_Ib_metadata_line_36_____Drake_Scull_International_20250515 >									
359 //        < Cm502Spxr8UliMS2sJCHmZMiI817V82da3fHZ6Tcdbo2JJq164E6YZE549eXy7me >									
360 //        <  u =="0.000000000000000001" : ] 000000642389976.238936000000000000 ; 000000663059955.883481000000000000 ] >									
361 //        < 0x000000000000000000000000000000000000000000000000003D435963F3BFCC >									
362 //     < DUBAI_Portfolio_Ib_metadata_line_37_____Emaar_Properties_20250515 >									
363 //        < d01DpppPcKcoWJp8x9eY13H0Rz3NNfg8oVkTKYYEm3xT99QVT9gR4YzP8wSKkzjW >									
364 //        <  u =="0.000000000000000001" : ] 000000663059955.883481000000000000 ; 000000680245417.088088000000000000 ] >									
365 //        < 0x000000000000000000000000000000000000000000000000003F3BFCC40DF8DE >									
366 //     < DUBAI_Portfolio_Ib_metadata_line_38_____EMAAR_MALLS_GROUP_20250515 >									
367 //        < 3JV88Hh40Mmxy6V26cLlWVw3A0f27vx88ojqeNg50Dl6ZdG55DL5TPN5m8mb9yj7 >									
368 //        <  u =="0.000000000000000001" : ] 000000680245417.088088000000000000 ; 000000695833300.726203000000000000 ] >									
369 //        < 0x0000000000000000000000000000000000000000000000000040DF8DE425C1E2 >									
370 //     < DUBAI_Portfolio_Ib_metadata_line_39_____Al_Mazaya_Holding_Company_20250515 >									
371 //        < 9AEgr4t3ISQ3qHw7ptdL9B5849DjHi18m95A0a3z60ecZ46VZr0U71xZHojtoava >									
372 //        <  u =="0.000000000000000001" : ] 000000695833300.726203000000000000 ; 000000711411867.403057000000000000 ] >									
373 //        < 0x00000000000000000000000000000000000000000000000000425C1E243D8743 >									
374 //     < DUBAI_Portfolio_Ib_metadata_line_40_____Union_Properties_20250515 >									
375 //        < hn6AbgKsZfCC6rfdMeV9Zifc3NEOUSe6yMy9S18fTXQQT8hk3RFAusn917sbFI65 >									
376 //        <  u =="0.000000000000000001" : ] 000000711411867.403057000000000000 ; 000000728002043.355369000000000000 ] >									
377 //        < 0x0000000000000000000000000000000000000000000000000043D8743456D7CC >									
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
407 }