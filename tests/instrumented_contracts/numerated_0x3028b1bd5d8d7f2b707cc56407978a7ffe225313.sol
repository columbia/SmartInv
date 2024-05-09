1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXXXIV_II_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXXXIV_II_883		"	;
8 		string	public		symbol =	"	RUSS_PFXXXIV_II_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		776605831917922000000000000					;	
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
92 	//     < RUSS_PFXXXIV_II_metadata_line_1_____PHARMSTANDARD_20231101 >									
93 	//        < 35ZqF0w8Q05ZonF1T41SPXiZnjZ1VZWUYT85d4E8NdksMcnXT3V3E293gUW73Aeg >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000016060371.737602900000000000 ] >									
95 	//        < 0x0000000000000000000000000000000000000000000000000000000000188195 >									
96 	//     < RUSS_PFXXXIV_II_metadata_line_2_____PHARM_DAO_20231101 >									
97 	//        < TzcgQ14o4oKN2Uqt05iOnNg2eW18pak4aW4sELP571wm0k36dMcIWKmHOa43q87w >									
98 	//        <  u =="0.000000000000000001" : ] 000000016060371.737602900000000000 ; 000000038919604.660881400000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000001881953B62F8 >									
100 	//     < RUSS_PFXXXIV_II_metadata_line_3_____PHARM_DAOPI_20231101 >									
101 	//        < WnWje40vCT70aWcE1l2m3zPr6tCzwS4yZn8yn24N0iI9ZDhIRqKtlVm7W8C8ciS4 >									
102 	//        <  u =="0.000000000000000001" : ] 000000038919604.660881400000000000 ; 000000057298917.148423000000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000003B62F8576E64 >									
104 	//     < RUSS_PFXXXIV_II_metadata_line_4_____PHARM_DAC_20231101 >									
105 	//        < O9AP8OX9NVkIV05195aL6O5HwtFlYZyDk9lZikk5UOyR2g9cEc1FpO3cfA3P8P6W >									
106 	//        <  u =="0.000000000000000001" : ] 000000057298917.148423000000000000 ; 000000077158102.962823800000000000 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000000000576E6475BBE2 >									
108 	//     < RUSS_PFXXXIV_II_metadata_line_5_____PHARM_BIMI_20231101 >									
109 	//        < x5V9669I29pTaP46W3Hzia3AR2sNlE6i98jk84N29Tq39i1F9xbXLkE376n9mHRD >									
110 	//        <  u =="0.000000000000000001" : ] 000000077158102.962823800000000000 ; 000000097952507.043938400000000000 ] >									
111 	//        < 0x000000000000000000000000000000000000000000000000000075BBE29576B3 >									
112 	//     < RUSS_PFXXXIV_II_metadata_line_6_____GENERIUM_20231101 >									
113 	//        < 5nm8P504mNRf3jR2cERT85q4xCmRL0oe5Wn15sFfah9vF6Y1b5Oy00z06b3K2txI >									
114 	//        <  u =="0.000000000000000001" : ] 000000097952507.043938400000000000 ; 000000117474019.537583000000000000 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000000000009576B3B3404A >									
116 	//     < RUSS_PFXXXIV_II_metadata_line_7_____GENERIUM_DAO_20231101 >									
117 	//        < RM6g8psg29161I41n1f7uZrooVQWsI1Fi323XT1IFC4CMDr3mvp5Gw1FF3E2lkb9 >									
118 	//        <  u =="0.000000000000000001" : ] 000000117474019.537583000000000000 ; 000000137201685.585598000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000B3404AD15A69 >									
120 	//     < RUSS_PFXXXIV_II_metadata_line_8_____GENERIUM_DAOPI_20231101 >									
121 	//        < gt0nzgHCS1df9Eo6RRqeXOxO7R755Oq56s604qDu41wx327yhOb7WgMeQu2SLgem >									
122 	//        <  u =="0.000000000000000001" : ] 000000137201685.585598000000000000 ; 000000159186039.159504000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000D15A69F2E60C >									
124 	//     < RUSS_PFXXXIV_II_metadata_line_9_____GENERIUM_DAC_20231101 >									
125 	//        < QKf0Qf8d228XX3Wa6gkGO4Mz8PDncQ7d4ac0RIeKWEejUJHvL3o38T6lHWXw1yM6 >									
126 	//        <  u =="0.000000000000000001" : ] 000000159186039.159504000000000000 ; 000000175090174.295529000000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000000F2E60C10B2A99 >									
128 	//     < RUSS_PFXXXIV_II_metadata_line_10_____GENERIUM_BIMI_20231101 >									
129 	//        < Z7fmKej9WakG4J78rBZ7DLbeND4a0jRliG0RpBYoRnrJzBv5fFIbJX03DJ6EWIhF >									
130 	//        <  u =="0.000000000000000001" : ] 000000175090174.295529000000000000 ; 000000196494626.670357000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000010B2A9912BD3B7 >									
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
174 	//     < RUSS_PFXXXIV_II_metadata_line_11_____MASTERLEK_20231101 >									
175 	//        < N79ntINWt234kUu97t9r6yywP0T0KkzZjT52P9NTVdxkAp982WkEVu26137Ct670 >									
176 	//        <  u =="0.000000000000000001" : ] 000000196494626.670357000000000000 ; 000000221317411.995422000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000012BD3B7151B41D >									
178 	//     < RUSS_PFXXXIV_II_metadata_line_12_____MASTERLEK_DAO_20231101 >									
179 	//        < 7MJ076RzHYHdxFm00GpiQ2C2l2LW2ChPq6Aa17a3Id28dfvVGL6ABN3q0vK00vsH >									
180 	//        <  u =="0.000000000000000001" : ] 000000221317411.995422000000000000 ; 000000240995099.786267000000000000 ] >									
181 	//        < 0x00000000000000000000000000000000000000000000000000151B41D16FBAB6 >									
182 	//     < RUSS_PFXXXIV_II_metadata_line_13_____MASTERLEK_DAOPI_20231101 >									
183 	//        < 97x2Ezwz39Jjmo57X6HF39YRvCT0wQ9dmLj7sxvej62P686L8U1p05MWbITMXm7B >									
184 	//        <  u =="0.000000000000000001" : ] 000000240995099.786267000000000000 ; 000000259459904.871241000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000016FBAB618BE786 >									
186 	//     < RUSS_PFXXXIV_II_metadata_line_14_____MASTERLEK_DAC_20231101 >									
187 	//        < 9XJ73356x6H51Tt3Z35lYhqezB0OToJ4AG1u6nEtYdum3mzh1xc6t5MTCL9yAjAq >									
188 	//        <  u =="0.000000000000000001" : ] 000000259459904.871241000000000000 ; 000000276670092.419457000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000018BE7861A62A41 >									
190 	//     < RUSS_PFXXXIV_II_metadata_line_15_____MASTERLEK_BIMI_20231101 >									
191 	//        < 9xvoANK75suv4LoR35c67oujIo8vASr7WCFgIR6Sh6IJSeL22FxupnG3b4J0jQWl >									
192 	//        <  u =="0.000000000000000001" : ] 000000276670092.419457000000000000 ; 000000293451698.283441000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000001A62A411BFC592 >									
194 	//     < RUSS_PFXXXIV_II_metadata_line_16_____PHARMSTANDARD_TMK_20231101 >									
195 	//        < g6xkHp7lRfQlk75O4VaysW4Wl8OtI4vb7r2LE1m3Egt94EXJQFE2XKOFmLV67ajZ >									
196 	//        <  u =="0.000000000000000001" : ] 000000293451698.283441000000000000 ; 000000316573105.768337000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000001BFC5921E30D5F >									
198 	//     < RUSS_PFXXXIV_II_metadata_line_17_____PHARMSTANDARD_OCTOBER_20231101 >									
199 	//        < 31pPJ4w1jL34jouI2sbMKS1vteXhhZW51zO6s3qa3CUPq5d65PdCv9lyGv3mj1M9 >									
200 	//        <  u =="0.000000000000000001" : ] 000000316573105.768337000000000000 ; 000000332156108.657582000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000001E30D5F1FAD47B >									
202 	//     < RUSS_PFXXXIV_II_metadata_line_18_____LEKSREDSTVA_20231101 >									
203 	//        < JB44iw13FB6u8cV9r55s47nP86Y7HtO6mLe5xmu3kUyN2BjWYzVf8J1c2but8Fo7 >									
204 	//        <  u =="0.000000000000000001" : ] 000000332156108.657582000000000000 ; 000000353224349.050119000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000001FAD47B21AFA43 >									
206 	//     < RUSS_PFXXXIV_II_metadata_line_19_____TYUMEN_PLANT_MED_EQUIP_TOOLS_20231101 >									
207 	//        < x9zCZEAMxRx9ySA866aLohA5FwE2PUKp0LxrChefnrpW81XyU3ka0bb232zf544F >									
208 	//        <  u =="0.000000000000000001" : ] 000000353224349.050119000000000000 ; 000000372682550.712623000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000000021AFA43238AB1F >									
210 	//     < RUSS_PFXXXIV_II_metadata_line_20_____MASTERPLAZMA_LLC_20231101 >									
211 	//        < 8fG84743eqbxHVOt7v0MhBfE6iKu2KT3m3Lv27rm8siSn4QXhxC65MGw9c3F5D4B >									
212 	//        <  u =="0.000000000000000001" : ] 000000372682550.712623000000000000 ; 000000390987450.319960000000000000 ] >									
213 	//        < 0x00000000000000000000000000000000000000000000000000238AB1F2549979 >									
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
256 	//     < RUSS_PFXXXIV_II_metadata_line_21_____BIGPEARL_TRADING_LIMITED_20231101 >									
257 	//        < OQKPg9eRQfpV5wUmVMv2ApHuu773pNvFQGu7gHIF37eucZ6Lx5kBHiBU2wg66sV1 >									
258 	//        <  u =="0.000000000000000001" : ] 000000390987450.319960000000000000 ; 000000409954101.956049000000000000 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000000025499792718A52 >									
260 	//     < RUSS_PFXXXIV_II_metadata_line_22_____BIGPEARL_DAO_20231101 >									
261 	//        < 5T0kV0X6PZTgC97572wLuVa1ADLn08H190Q9sB21tewUlpzM32AiJF20339ZxoGd >									
262 	//        <  u =="0.000000000000000001" : ] 000000409954101.956049000000000000 ; 000000433729926.919508000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000002718A52295D1C1 >									
264 	//     < RUSS_PFXXXIV_II_metadata_line_23_____BIGPEARL_DAOPI_20231101 >									
265 	//        < 71pkJ57p41b87SbUNoD8Y7a067682D9J9B06506A9Jq7D6C4b8lP4o1xRNCywO67 >									
266 	//        <  u =="0.000000000000000001" : ] 000000433729926.919508000000000000 ; 000000451041091.484938000000000000 ] >									
267 	//        < 0x00000000000000000000000000000000000000000000000000295D1C12B03BED >									
268 	//     < RUSS_PFXXXIV_II_metadata_line_24_____BIGPEARL_DAC_20231101 >									
269 	//        < wMbEGO6ITakybhgOaxQJ4LKahclZ6pez5rsT1I0rLWnO26VZ8nvTY9chn569Uvb9 >									
270 	//        <  u =="0.000000000000000001" : ] 000000451041091.484938000000000000 ; 000000469188555.680082000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000002B03BED2CBECC8 >									
272 	//     < RUSS_PFXXXIV_II_metadata_line_25_____BIGPEARL_BIMI_20231101 >									
273 	//        < E730ZXT3hW8JUx34nP3kOqf2iuKeQz0E216xoAWVhyCVUJ3d3l17M8ho0EpVL8Ao >									
274 	//        <  u =="0.000000000000000001" : ] 000000469188555.680082000000000000 ; 000000485359102.391277000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002CBECC82E49966 >									
276 	//     < RUSS_PFXXXIV_II_metadata_line_26_____UFAVITA_20231101 >									
277 	//        < zb20sVG1NAyz2fhzTiX591Z6Mh83cnLw3341F321DLri6og3WLQ5f8eGbTmrKoJC >									
278 	//        <  u =="0.000000000000000001" : ] 000000485359102.391277000000000000 ; 000000501778890.901233000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000002E499662FDA761 >									
280 	//     < RUSS_PFXXXIV_II_metadata_line_27_____DONELLE_COMPANY_LIMITED_20231101 >									
281 	//        < ayZF4cMl3OgoMpN5Ta6o45ckN0pVFu4d183vCFJbzJq1J7PCIb8uTgIRDg725WiJ >									
282 	//        <  u =="0.000000000000000001" : ] 000000501778890.901233000000000000 ; 000000525356098.659332000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000002FDA761321A13A >									
284 	//     < RUSS_PFXXXIV_II_metadata_line_28_____DONELLE_CHF_20231101 >									
285 	//        < Knz9QSY71mwcDqnchuO97D4G7T6H3qcdky1zdZrw2TmejKxZ3E9OPblLd45m56l3 >									
286 	//        <  u =="0.000000000000000001" : ] 000000525356098.659332000000000000 ; 000000543009447.621953000000000000 ] >									
287 	//        < 0x00000000000000000000000000000000000000000000000000321A13A33C9111 >									
288 	//     < RUSS_PFXXXIV_II_metadata_line_29_____VINDEKSFARM_20231101 >									
289 	//        < xDweJPMF6lndphLQfXtSrj3xSws2zXQ8rT5mpO6Nb6rzDr3HwF1IAO9p3899qnYY >									
290 	//        <  u =="0.000000000000000001" : ] 000000543009447.621953000000000000 ; 000000559765408.561526000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000033C9111356225D >									
292 	//     < RUSS_PFXXXIV_II_metadata_line_30_____TYUMEN_PLANT_CHF_20231101 >									
293 	//        < BpHSCEPxw180joMVn4bwfi25RK4AW467Xgu4A47eM4JGQF63O63I8N27wa26qjMK >									
294 	//        <  u =="0.000000000000000001" : ] 000000559765408.561526000000000000 ; 000000582211523.905246000000000000 ] >									
295 	//        < 0x00000000000000000000000000000000000000000000000000356225D3786260 >									
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
338 	//     < RUSS_PFXXXIV_II_metadata_line_31_____LEKKO_20231101 >									
339 	//        < a068J3HG8eNy2BE11p7z27DPkSAbB7423R6aB680c3z69tIXo5uXF3WKI96JHej0 >									
340 	//        <  u =="0.000000000000000001" : ] 000000582211523.905246000000000000 ; 000000602137176.947716000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000003786260396C9D6 >									
342 	//     < RUSS_PFXXXIV_II_metadata_line_32_____LEKKO_DAO_20231101 >									
343 	//        < p2iFA2dev1W2m867ufHI77wcd794x9qbSWUg4apA2VXg6d6WCY5P2wgTTaQnCQnF >									
344 	//        <  u =="0.000000000000000001" : ] 000000602137176.947716000000000000 ; 000000618405241.234354000000000000 ] >									
345 	//        < 0x00000000000000000000000000000000000000000000000000396C9D63AF9C8C >									
346 	//     < RUSS_PFXXXIV_II_metadata_line_33_____LEKKO_DAOPI_20231101 >									
347 	//        < JH9IIY3CWkvJY24293PEN35tsvjKHE7uWHkDyEJ5wf836QIlHU3YsvgXE1APFeUM >									
348 	//        <  u =="0.000000000000000001" : ] 000000618405241.234354000000000000 ; 000000634768545.096163000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000003AF9C8C3C89477 >									
350 	//     < RUSS_PFXXXIV_II_metadata_line_34_____LEKKO_DAC_20231101 >									
351 	//        < a74v932VHvct7v31aww5BX4n7EQU67sAn0TAhhL429CVzz8k5fK1m7K71qlyWVy2 >									
352 	//        <  u =="0.000000000000000001" : ] 000000634768545.096163000000000000 ; 000000654591420.371627000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000003C894773E6D3C6 >									
354 	//     < RUSS_PFXXXIV_II_metadata_line_35_____LEKKO_BIMI_20231101 >									
355 	//        < 2Kcozl0JUgSa48I9A6ci63pVrU8YTmsY4Ns3UjML50Fcmjn3giqPs2BW88e6FukO >									
356 	//        <  u =="0.000000000000000001" : ] 000000654591420.371627000000000000 ; 000000671444761.196311000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000003E6D3C64008B1C >									
358 	//     < RUSS_PFXXXIV_II_metadata_line_36_____TOMSKHIMPHARM_20231101 >									
359 	//        < 63z6Uf7RDpEAME00N8TTt812sun8LQPOF0n3lc5GX3gArn64x8949P09764K4019 >									
360 	//        <  u =="0.000000000000000001" : ] 000000671444761.196311000000000000 ; 000000691563633.118798000000000000 ] >									
361 	//        < 0x000000000000000000000000000000000000000000000000004008B1C41F3E0B >									
362 	//     < RUSS_PFXXXIV_II_metadata_line_37_____TOMSKHIM_CHF_20231101 >									
363 	//        < q4OTmvvW6kKZwb9438rms5621oEgfEhuMpPuv583bqO2VpGx0QKA07w7lCIumJSa >									
364 	//        <  u =="0.000000000000000001" : ] 000000691563633.118798000000000000 ; 000000707962796.217904000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000041F3E0B43843F8 >									
366 	//     < RUSS_PFXXXIV_II_metadata_line_38_____FF_LEKKO_ZAO_20231101 >									
367 	//        < gT155vu5327SzE2l7E4vfXQa6DO9rix1QuWvc21Qag1Gd0Z9pIsZOBvH89J2e7d8 >									
368 	//        <  u =="0.000000000000000001" : ] 000000707962796.217904000000000000 ; 000000731755338.204019000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000043843F845C91EE >									
370 	//     < RUSS_PFXXXIV_II_metadata_line_39_____PHARMSTANDARD_PLAZMA_OOO_20231101 >									
371 	//        < g0KCTvd84Rfx1Xt60KyG2e6CB5Mac7G1b7hNwPNIWwEq8azoT8Mha3SM09oh81sN >									
372 	//        <  u =="0.000000000000000001" : ] 000000731755338.204019000000000000 ; 000000755545978.713851000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000045C91EE480DF26 >									
374 	//     < RUSS_PFXXXIV_II_metadata_line_40_____FARMSTANDARD_TOMSKKHIMFOARM_OAO_20231101 >									
375 	//        < Vhg7HUKpkvRB0lh8wl157956bkqWf03Ybw6QtiD0An4abPDO021nyTobnL7JwmPl >									
376 	//        <  u =="0.000000000000000001" : ] 000000755545978.713851000000000000 ; 000000776605831.917922000000000000 ] >									
377 	//        < 0x00000000000000000000000000000000000000000000000000480DF264A101A7 >									
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