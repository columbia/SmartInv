1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	BCDDDHST_1_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	BCDDDHST_1_883		"	;
8 		string	public		symbol =	"	BCDDDHST_1MTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		777561738866007000000000000					;	
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
92 	//     < BCDDDHST_1_metadata_line_1_____BASF_ABC_Y20,5 >									
93 	//        < BM19h2lFtA2hz3sPCMX5K31Iw5zmAx5cLHbL8758huO4mjm40Szo47Vm6nN7KD77 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000022879696.986540600000000000 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000000022E962 >									
96 	//     < BCDDDHST_1_metadata_line_2_____BASF_RO_Y3K1.00 >									
97 	//        < ShhhXz84Di4YAck7X4Va1qc2oms2XatuAVB4E4N0Xg7KonxHNr9i50GXI9rQH65F >									
98 	//        <  u =="0.000000000000000001" : ] 000000022879696.986540600000000000 ; 000000033995823.969330600000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000022E96233DF9E >									
100 	//     < BCDDDHST_1_metadata_line_3_____BASF_RO_Y3K0.90 >									
101 	//        < zeH08ZRymg0xvC7T7icBz9Yie4oqNAJmd6D54OU44mR5SsxqZ5M652awo9oS8iHO >									
102 	//        <  u =="0.000000000000000001" : ] 000000033995823.969330600000000000 ; 000000045199097.893890600000000000 ] >									
103 	//        < 0x000000000000000000000000000000000000000000000000000033DF9E44F7E6 >									
104 	//     < BCDDDHST_1_metadata_line_4_____BASF_RO_Y7K1.00 >									
105 	//        < y9L06ehXk5epCH7QEq78cm6aaIlqi74dIh0Tq7TjrMoiUNBcx523Fr3W70lsmCWg >									
106 	//        <  u =="0.000000000000000001" : ] 000000045199097.893890600000000000 ; 000000058536585.619186900000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000044F7E65951DB >									
108 	//     < BCDDDHST_1_metadata_line_5_____BASF_RO_Y7K0.90 >									
109 	//        < 3Oys8Ug8ZTg2oW4LC88lZfU0nm1qcxZ0aRik1AjQ9myQ8wIGRX0bf78la9lHP627 >									
110 	//        <  u =="0.000000000000000001" : ] 000000058536585.619186900000000000 ; 000000072172574.950576400000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000005951DB6E2069 >									
112 	//     < BCDDDHST_1_metadata_line_6_____CONTINENTAL_ABC_Y11,5 >									
113 	//        < 9YoDRGig9An531YJTO7QeMY0z3pH918vTt3L5eYW4XSHKgpwK6R6w0KGfV975oeh >									
114 	//        <  u =="0.000000000000000001" : ] 000000072172574.950576400000000000 ; 000000093828616.322146600000000000 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000000000006E20698F2BCE >									
116 	//     < BCDDDHST_1_metadata_line_7_____CONTINENTAL_RO_Y3K1.00 >									
117 	//        < bUiQLY5gI2axwzLOIcqGH2xgqR3O7B5NS4cKXfLm3K80ksUEtNB6o14bID5103Oi >									
118 	//        <  u =="0.000000000000000001" : ] 000000093828616.322146600000000000 ; 000000105129253.035107000000000000 ] >									
119 	//        < 0x00000000000000000000000000000000000000000000000000008F2BCEA06A1D >									
120 	//     < BCDDDHST_1_metadata_line_8_____CONTINENTAL_RO_Y3K0.90 >									
121 	//        < Lg2oA08vE1F65tk9uI4vPD3LQE4biKu10nEy1O00D8ywI7MAhP81a5Ei261zT9CE >									
122 	//        <  u =="0.000000000000000001" : ] 000000105129253.035107000000000000 ; 000000116695583.369837000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000A06A1DB21036 >									
124 	//     < BCDDDHST_1_metadata_line_9_____CONTINENTAL_RO_Y7K1.00 >									
125 	//        < k1Rzo7RzQLyXlO9x1y2adsCKhD43rPcq3TCw7643y4hX18fx4ZvijVkfKcB0TBO6 >									
126 	//        <  u =="0.000000000000000001" : ] 000000116695583.369837000000000000 ; 000000131456049.794058000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000000B21036C89605 >									
128 	//     < BCDDDHST_1_metadata_line_10_____CONTINENTAL_RO_Y7K0.90 >									
129 	//        < v8rUJ0bMZ5nBA467yfG6k8lc771v6AF47F483mKv0mhSN9C6rqhPi26q50x7tRy8 >									
130 	//        <  u =="0.000000000000000001" : ] 000000131456049.794058000000000000 ; 000000147057302.904502000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000000C89605E06442 >									
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
174 	//     < BCDDDHST_1_metadata_line_11_____DAIMLER_ABC_Y22 >									
175 	//        < QGY7yvihr1VGBtT0ty9TX3zpza10R130Tk09aH0594hGa2nY4835v2pkwPtP1mdU >									
176 	//        <  u =="0.000000000000000001" : ] 000000147057302.904502000000000000 ; 000000241023942.596160000000000000 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000000000E0644216FC5FA >									
178 	//     < BCDDDHST_1_metadata_line_12_____DAIMLER_RO_Y3K1.00 >									
179 	//        < m49H09c7laSUkLs202Pdm6oo1LKt9hqRdPVZa62lEdSBOGJ7lJl6UrAlP0e900by >									
180 	//        <  u =="0.000000000000000001" : ] 000000241023942.596160000000000000 ; 000000252600192.596160000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000016FC5FA1816FF3 >									
182 	//     < BCDDDHST_1_metadata_line_13_____DAIMLER_RO_Y3K0.90 >									
183 	//        < 33u300q555Vx5TzZS39NV75knchQd7RTaCY7PZQ0eezT071G99R1Me2r4y4Bw33k >									
184 	//        <  u =="0.000000000000000001" : ] 000000252600192.596160000000000000 ; 000000264706930.699280000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001816FF3193E925 >									
186 	//     < BCDDDHST_1_metadata_line_14_____DAIMLER_RO_Y7K1.00 >									
187 	//        < 3Sn8vQN2NRKc8D5bborj067iSfb9lacVETt4hn2lxf64oH32uv5in5nK22lyr0MV >									
188 	//        <  u =="0.000000000000000001" : ] 000000264706930.699280000000000000 ; 000000281189692.008238000000000000 ] >									
189 	//        < 0x00000000000000000000000000000000000000000000000000193E9251AD0FB9 >									
190 	//     < BCDDDHST_1_metadata_line_15_____DAIMLER_RO_Y7K0.90 >									
191 	//        < 91MhJLW828tB0F0B5AduBHGj2Tosk2e72bnnwxw4GqD3f22G5IXj8IgX0IXCJ9jX >									
192 	//        <  u =="0.000000000000000001" : ] 000000281189692.008238000000000000 ; 000000300467022.154051000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000001AD0FB91CA79EE >									
194 	//     < BCDDDHST_1_metadata_line_16_____DEUTSCHE_LUFTHANSA_ABC_Y22 >									
195 	//        < 4ObRSDK3tp20ilZ1N0D78362gAhL5Znvf6EI0eof746wY7WkumO5S0VqxMKmy1X7 >									
196 	//        <  u =="0.000000000000000001" : ] 000000300467022.154051000000000000 ; 000000361014445.523682000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000001CA79EE226DD45 >									
198 	//     < BCDDDHST_1_metadata_line_17_____DEUTSCHE_LUFTHANSA_RO_Y3K1.00 >									
199 	//        < Fg4N8idAbdjaVx081p6UsDA5LLbrt7aQurARpbpL0fu9QfMRMmC2v386Uidzo480 >									
200 	//        <  u =="0.000000000000000001" : ] 000000361014445.523682000000000000 ; 000000372426106.773682000000000000 ] >									
201 	//        < 0x00000000000000000000000000000000000000000000000000226DD4523846F3 >									
202 	//     < BCDDDHST_1_metadata_line_18_____DEUTSCHE_LUFTHANSA_RO_Y3K0.90 >									
203 	//        < Mzy56PMnY1uM7kLNTSdKVF7o91qI3b4H1rez0hxT9ozpbXab0vc6DR1xHK3xZOwE >									
204 	//        <  u =="0.000000000000000001" : ] 000000372426106.773682000000000000 ; 000000384208635.016962000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000023846F324A4180 >									
206 	//     < BCDDDHST_1_metadata_line_19_____DEUTSCHE_LUFTHANSA_RO_Y7K1.00 >									
207 	//        < i1KEFRq6MR2Fr2U847Af9fW7iduX669t9K9dDNC0829Y8KACaJzP8vj6N6H1MVJE >									
208 	//        <  u =="0.000000000000000001" : ] 000000384208635.016962000000000000 ; 000000399964267.408058000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000000024A41802624C0B >									
210 	//     < BCDDDHST_1_metadata_line_20_____DEUTSCHE_LUFTHANSA_RO_Y7K0.90 >									
211 	//        < 7tu1mqi07zzH7OuAD94Gny2Z3blAKfxv39r01Q4O91abxPqWf7SZLDGI8bQqekLW >									
212 	//        <  u =="0.000000000000000001" : ] 000000399964267.408058000000000000 ; 000000416936580.944613000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000002624C0B27C31DA >									
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
256 	//     < BCDDDHST_1_metadata_line_21_____DEUTSCHE_POST_ABC_Y18 >									
257 	//        < 78VBFccjOopAxmuUgQ2dq7rM9mEkoqj961D9CsTQQk7iD27nQY1fSctNruiWW10q >									
258 	//        <  u =="0.000000000000000001" : ] 000000416936580.944613000000000000 ; 000000434473841.310359000000000000 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000000027C31DA296F458 >									
260 	//     < BCDDDHST_1_metadata_line_22_____DEUTSCHE_POST_RO_Y3K1.00 >									
261 	//        < 0HN69tZ6M2M5TLtBX4S6nb9upA1nJYi11i6OJLX9cGO87n3AG81fFy1wXb2fYn48 >									
262 	//        <  u =="0.000000000000000001" : ] 000000434473841.310359000000000000 ; 000000445532122.128569000000000000 ] >									
263 	//        < 0x00000000000000000000000000000000000000000000000000296F4582A7D3FC >									
264 	//     < BCDDDHST_1_metadata_line_23_____DEUTSCHE_POST_RO_Y3K0.90 >									
265 	//        < 6Sp4NGvGHPxXmt8Vfrcg2rO361p7030I4bK76y7MBQ3V5UqHjesuW4S0jRapfX39 >									
266 	//        <  u =="0.000000000000000001" : ] 000000445532122.128569000000000000 ; 000000456622514.864079000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000002A7D3FC2B8C02B >									
268 	//     < BCDDDHST_1_metadata_line_24_____DEUTSCHE_POST_RO_Y7K1.00 >									
269 	//        < aW3YRyUHTu8NzZ71s5s61QNR0sUnAuktwmny9235AS5w8pmg0a779r02jB1s41yE >									
270 	//        <  u =="0.000000000000000001" : ] 000000456622514.864079000000000000 ; 000000469579462.903388000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000002B8C02B2CC857A >									
272 	//     < BCDDDHST_1_metadata_line_25_____DEUTSCHE_POST_RO_Y7K0.90 >									
273 	//        < 0IwqZYdwWg1v35p5fj6b3a54OPc2e6To43nlaAoukSX7zXX3o13HqN2Cm3fL5L7q >									
274 	//        <  u =="0.000000000000000001" : ] 000000469579462.903388000000000000 ; 000000482676905.117077000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002CC857A2E081AB >									
276 	//     < BCDDDHST_1_metadata_line_26_____HEILDELBERGCEMENT_ABC_Y20,5 >									
277 	//        < QQ20ThkDzX0pp0o0xAVZY0BhmBEJqd7VwGtm16V3K7g929q9OKqmPnmSqOKsE5iv >									
278 	//        <  u =="0.000000000000000001" : ] 000000482676905.117077000000000000 ; 000000520393819.865776000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000002E081AB31A0ED6 >									
280 	//     < BCDDDHST_1_metadata_line_27_____HEILDELBERGCEMENT_RO_Y3K1.00 >									
281 	//        < N21h2m43faSKWqFg2oqQCZq2p27277984t3l8M8b828KnuU0S16S1Zz15Xxe589q >									
282 	//        <  u =="0.000000000000000001" : ] 000000520393819.865776000000000000 ; 000000531674939.075776000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000031A0ED632B4586 >									
284 	//     < BCDDDHST_1_metadata_line_28_____HEILDELBERGCEMENT_RO_Y3K0.90 >									
285 	//        < hUzFy423VMQcn09mJKDRHxtYHH4W0WA057uH9JT59AdU5k6Jc5JJM1kd9N79y4Ii >									
286 	//        <  u =="0.000000000000000001" : ] 000000531674939.075776000000000000 ; 000000543204945.788336000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000032B458633CDD6F >									
288 	//     < BCDDDHST_1_metadata_line_29_____HEILDELBERGCEMENT_RO_Y7K1.00 >									
289 	//        < 01r2T2i5H3DYV0WMtsM4ct5wU6730Gc5boyohg5SBR87940QtlPh8xO8iG0j669f >									
290 	//        <  u =="0.000000000000000001" : ] 000000543204945.788336000000000000 ; 000000557819435.332210000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000033CDD6F3532A38 >									
292 	//     < BCDDDHST_1_metadata_line_30_____HEILDELBERGCEMENT_RO_Y7K0.90 >									
293 	//        < v146YI46SiHKZX7S9TFd7Jve649RjA7w7D0zhHOOYwo3Fml04oTWUOU7537xn43F >									
294 	//        <  u =="0.000000000000000001" : ] 000000557819435.332210000000000000 ; 000000573216867.539046000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000003532A3836AA8D7 >									
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
338 	//     < BCDDDHST_1_metadata_line_31_____SIEMENS_ABC_Y22 >									
339 	//        < d2E3Z0I1L7U8t721ET8S2VLBm9Fp676iJP6W36qEH4sPnxE11ZgM611blUT9Hv9Q >									
340 	//        <  u =="0.000000000000000001" : ] 000000573216867.539046000000000000 ; 000000641022960.166351000000000000 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000000000036AA8D73D21F98 >									
342 	//     < BCDDDHST_1_metadata_line_32_____SIEMENS_RO_Y3K1.00 >									
343 	//        < qi7CAiQ467zfSDTgM9L47CfVt55wu65f0hUyM5Im8RaM6FQ7C8vc92tJWJ3q4Ff1 >									
344 	//        <  u =="0.000000000000000001" : ] 000000641022960.166351000000000000 ; 000000652885991.266911000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000003D21F983E43997 >									
346 	//     < BCDDDHST_1_metadata_line_33_____SIEMENS_RO_Y3K0.90 >									
347 	//        < zwZoW7GEBwFd86H1RlqxEJsrKy85I2S360K95TzB9jWGO4TGptH098hBaSt7xW7r >									
348 	//        <  u =="0.000000000000000001" : ] 000000652885991.266911000000000000 ; 000000664337010.578191000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000003E439973F5B2A5 >									
350 	//     < BCDDDHST_1_metadata_line_34_____SIEMENS_RO_Y7K1.00 >									
351 	//        < OEnwVThaA65543oVz4mgA281xySYuC47r6I9Sk780aG74TEy1D0Bg5XRfeNSAOi3 >									
352 	//        <  u =="0.000000000000000001" : ] 000000664337010.578191000000000000 ; 000000680489610.263922000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000003F5B2A540E5841 >									
354 	//     < BCDDDHST_1_metadata_line_35_____SIEMENS_RO_Y7K0.90 >									
355 	//        < 5a04S5uf70nYLzWqoapH2f3Uy1MmCPJu67t21v9zs6Pb86AxwjiFqdCK66jZ9Y53 >									
356 	//        <  u =="0.000000000000000001" : ] 000000680489610.263922000000000000 ; 000000698009114.755878000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000040E584142913CF >									
358 	//     < BCDDDHST_1_metadata_line_36_____THYSSENKRUPP_ABC_Y19,5 >									
359 	//        < 54wEZTOjJ68PkWhs9g9py32UlT8Fce9it81oK70OY995LK263LntWmqP6cdXomOs >									
360 	//        <  u =="0.000000000000000001" : ] 000000698009114.755878000000000000 ; 000000726468508.822391000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000042913CF45480C3 >									
362 	//     < BCDDDHST_1_metadata_line_37_____THYSSENKRUPP_RO_Y3K1.00 >									
363 	//        < 0uxBL5Xw6H2M9euPaxV8iPg9Ck4slBZLW7Sn3UahKd0hY9792o9OJmp3295JE396 >									
364 	//        <  u =="0.000000000000000001" : ] 000000726468508.822391000000000000 ; 000000737671782.746951000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000045480C3465990A >									
366 	//     < BCDDDHST_1_metadata_line_38_____THYSSENKRUPP_RO_Y3K0.90 >									
367 	//        < 1uTApnjq88t3E3e8gvn0ORUHZ0ZJ1lap2inZd3XETbVS2BacKs2WeUw8AE8kH09a >									
368 	//        <  u =="0.000000000000000001" : ] 000000737671782.746951000000000000 ; 000000749047445.092141000000000000 ] >									
369 	//        < 0x00000000000000000000000000000000000000000000000000465990A476F4A9 >									
370 	//     < BCDDDHST_1_metadata_line_39_____THYSSENKRUPP_RO_Y7K1.00 >									
371 	//        < S44VbGDAob87U0XC3VQpG53GWCOtf4ErYZVB07oIE4cRY024T1ZLM4P27pF3zQ2Y >									
372 	//        <  u =="0.000000000000000001" : ] 000000749047445.092141000000000000 ; 000000763034240.078967000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000476F4A948C4C40 >									
374 	//     < BCDDDHST_1_metadata_line_40_____THYSSENKRUPP_RO_Y7K0.90 >									
375 	//        < q3MG31453zgDkGxxl6aX2GxrvLb58K4PXRAk2RkH1647UH3IFPebxPRrr495y86J >									
376 	//        <  u =="0.000000000000000001" : ] 000000763034240.078967000000000000 ; 000000777561738.866006000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000048C4C404A2770E >									
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