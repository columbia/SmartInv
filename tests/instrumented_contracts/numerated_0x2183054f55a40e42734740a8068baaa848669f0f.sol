1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	SEAPORT_Portfolio_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	SEAPORT_Portfolio_I_883		"	;
8 		string	public		symbol =	"	SEAPORT883I		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1315013459513460000000000000					;	
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
92 	//     < SEAPORT_Portfolio_I_metadata_line_1_____Abakan_Spe_Value_20250515 >									
93 	//        < l8YQ7L17zYAReUoWyFSW82OGRtoAtms9Sm6wWMSAEYO7R1Qnp1lGYO68ZR077Aw0 >									
94 	//        < 1E-018 limites [ 1E-018 ; 34589487,3823024 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000000034C785 >									
96 	//     < SEAPORT_Portfolio_I_metadata_line_2_____Aleksandrovsk_Sakhalinsky_Sea_Port_20250515 >									
97 	//        < 99vOJKum36hA7nr46w0sOvlrco1T997yAO28gY6bFQY5GHLbRgPOolQN8L99IsV5 >									
98 	//        < 1E-018 limites [ 34589487,3823024 ; 69065378,9771162 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000034C7856962AA >									
100 	//     < SEAPORT_Portfolio_I_metadata_line_3_____Amderma_Maritime_Trade_Port_20250515 >									
101 	//        < HSCt9niAXx0R3vM21bfFT8onp7a89so8EFvVsA4s72aeRu1xpiVj6ne62MLCT3nN >									
102 	//        < 1E-018 limites [ 69065378,9771162 ; 118259276,627101 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000006962AAB47308 >									
104 	//     < SEAPORT_Portfolio_I_metadata_line_4_____Anadyr_Sea_Port_Ltd_20250515 >									
105 	//        < 76fr6XwcV6tP58xd3HmtcB81MBz94D1Y1E6E64tefjl0FT5EPs0w4ga49gmOtf48 >									
106 	//        < 1E-018 limites [ 118259276,627101 ; 154060140,389963 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000000000B47308EB13BE >									
108 	//     < SEAPORT_Portfolio_I_metadata_line_5_____Anadyr_Port_Spe_Value_20250515 >									
109 	//        < TawG6s5F520LBQT3tIDt3908YmHPn7JikvtE5LYOwW800E31J5b8qS04xNDg2j5Y >									
110 	//        < 1E-018 limites [ 154060140,389963 ; 182741903,899121 ] >									
111 	//        < 0x000000000000000000000000000000000000000000000000000EB13BE116D78E >									
112 	//     < SEAPORT_Portfolio_I_metadata_line_6_____Maritime_Port_Administration_of_Novorossiysk_20250515 >									
113 	//        < 5Z511kCtrwC5v948l83E72907BtRIkQ3Ye5Kr8d1GgYz0t097cBp4i0tzl3hJ3LN >									
114 	//        < 1E-018 limites [ 182741903,899121 ; 212691228,411382 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000000000116D78E1448A83 >									
116 	//     < SEAPORT_Portfolio_I_metadata_line_7_____Anapa_Port_Spe_Value_20250515 >									
117 	//        < N8Gidl5Q4rS9l4mM45LWHSgS1bjkl5z14kLl8fGgOA0D4U214lgaGsQFH8vB13R5 >									
118 	//        < 1E-018 limites [ 212691228,411382 ; 254199183,730671 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000001448A83183E08E >									
120 	//     < SEAPORT_Portfolio_I_metadata_line_8_____JSC_Arkhangelsk_Sea_Commercial_Port_20250515 >									
121 	//        < ax291UBF4355AmJug6KPBHM2t8mF5oYcrVtxgxZZapr724r6tZUs7D2Z54InHWPn >									
122 	//        < 1E-018 limites [ 254199183,730671 ; 286081042,088676 ] >									
123 	//        < 0x00000000000000000000000000000000000000000000000000183E08E1B48668 >									
124 	//     < SEAPORT_Portfolio_I_metadata_line_9_____Arkhangelsk_Port_Spe_Value_20250515 >									
125 	//        < 6H3ACuiVfIaE252T1q66Tr7x1jmHl5PrVz5659G8MwZbGJnEYBWtw3Tdb8T7CQ7C >									
126 	//        < 1E-018 limites [ 286081042,088676 ; 325388661,988454 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000001B486681F080F2 >									
128 	//     < SEAPORT_Portfolio_I_metadata_line_10_____Astrakhan_Sea_Commercial_Port_20250515 >									
129 	//        < TX6s7B5H15O4RDd5Aj8iru2Mc339vS9XQ3y2gY9S4u6M9206p62g75grb6PyIQeC >									
130 	//        < 1E-018 limites [ 325388661,988454 ; 352732232,607 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000000001F080F221A3A07 >									
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
174 	//     < SEAPORT_Portfolio_I_metadata_line_11_____Astrakhan_Port_Spe_Value_20250515 >									
175 	//        < 1KKEj55zo5m5HwWOAdbd25Yho2d1s85sxR0xFl4k3TA5MRn5S9bZdL591E0XBOC5 >									
176 	//        < 1E-018 limites [ 352732232,607 ; 371968714,510636 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000021A3A072379447 >									
178 	//     < SEAPORT_Portfolio_I_metadata_line_12_____JSC_Azov_Sea_Port_20250515 >									
179 	//        < 5zEm7mDZKQ5cRGpPCUfR26mgY0sC65bNG5b87LaynVztpDUaV2VYuX830YD649v7 >									
180 	//        < 1E-018 limites [ 371968714,510636 ; 390095899,323935 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000023794472533D36 >									
182 	//     < SEAPORT_Portfolio_I_metadata_line_13_____Barnaul_Port_Spe_Value_20250515 >									
183 	//        < 0HBCfiC5U8mtwx5v318AOPiTy75DbwI7QmseRH670M98KyhTwq5u8hb7I9HVDi5l >									
184 	//        < 1E-018 limites [ 390095899,323935 ; 408387567,146848 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000002533D3626F2665 >									
186 	//     < SEAPORT_Portfolio_I_metadata_line_14_____Beringovsky_Port_Spe_Value_20250515 >									
187 	//        < Dq336GQ7NL2i0lU75Vzy5e39bTn8PUueFF0QP2DH9nEyOXofnDrDGEFG5Vh5fV8m >									
188 	//        < 1E-018 limites [ 408387567,146848 ; 436319523,963194 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000026F2665299C550 >									
190 	//     < SEAPORT_Portfolio_I_metadata_line_15_____Beryozovo_Port_Spe_Value_20250515 >									
191 	//        < 50hLrz6Af99y11Iq0qn38zj7pL7eCan4A61oppYy0E6TSU3JxmtVbtAjr097vb5Z >									
192 	//        < 1E-018 limites [ 436319523,963194 ; 472346127,958446 ] >									
193 	//        < 0x00000000000000000000000000000000000000000000000000299C5502D0BE35 >									
194 	//     < SEAPORT_Portfolio_I_metadata_line_16_____Bratsk_Port_Spe_Value_20250515 >									
195 	//        < 13T59NVB20n165oZmQsdsX6i96JKsj1MwCO2EEVv33icRSrG19Euj4g5O1L00v4M >									
196 	//        < 1E-018 limites [ 472346127,958446 ; 501700566,632217 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000002D0BE352FD88C9 >									
198 	//     < SEAPORT_Portfolio_I_metadata_line_17_____Bukhta_Nagayeva_Port_Spe_Value_20250515 >									
199 	//        < wP6mNJM5h62v2FQ0OTmlsgSz7mu9W1C99K4Qrkc905vlS8i40wi8Mgk73D6mUX5I >									
200 	//        < 1E-018 limites [ 501700566,632217 ; 528541201,703527 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000002FD88C93267D68 >									
202 	//     < SEAPORT_Portfolio_I_metadata_line_18_____Cherepovets_Port_Spe_Value_20250515 >									
203 	//        < VmPzX5kQsq7t20o4AvhTqorkY1gUak6i1m2CES2yZ3slUETVHMg4r14Q4KvDed33 >									
204 	//        < 1E-018 limites [ 528541201,703527 ; 561756129,119174 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000003267D683592BFD >									
206 	//     < SEAPORT_Portfolio_I_metadata_line_19_____De_Kastri_Port_Spe_Value_20250515 >									
207 	//        < 93GJzjI0H8d4SctOG3633P5Hr06G3PkfK5GCfgNGbbnj017K6kwbhoWqlQUUlCUq >									
208 	//        < 1E-018 limites [ 561756129,119174 ; 602361587,711232 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000003592BFD397217F >									
210 	//     < SEAPORT_Portfolio_I_metadata_line_20_____State_Enterprise_Dikson_Sea_Trade_Port_20250515 >									
211 	//        < hf5Dsjz6k77aXPfilv9B2m7B3IbY44xT63UJUomVs77EoN1H7z1mhX09XMXi7f8F >									
212 	//        < 1E-018 limites [ 602361587,711232 ; 628215907,434235 ] >									
213 	//        < 0x00000000000000000000000000000000000000000000000000397217F3BE94D7 >									
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
256 	//     < SEAPORT_Portfolio_I_metadata_line_21_____Dudinka_Port_Spe_Value_20250515 >									
257 	//        < 9bpj7CY2y0274f9fj8CV752f955nQTbgBk79p4AV5j3UyNN2Xni9H203mLoNAm85 >									
258 	//        < 1E-018 limites [ 628215907,434235 ; 664249187,620668 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000003BE94D73F59057 >									
260 	//     < SEAPORT_Portfolio_I_metadata_line_22_____Dzerzhinsk_Port_Spe_Value_20250515 >									
261 	//        < z1kx9i5Ec3auS028Txg3B9z2r2XGnZynHoW6B2066rH2UqaCC8Io26JSTj1Tiho3 >									
262 	//        < 1E-018 limites [ 664249187,620668 ; 709092707,967714 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000003F59057439FD57 >									
264 	//     < SEAPORT_Portfolio_I_metadata_line_23_____Egvekinot_Port_Spe_Value_20250515 >									
265 	//        < H4brHcn9VTt216yq5mLlrVspa4H90L0f1U9TWINFm505xdf1ZvJLl60cryq3Y36O >									
266 	//        < 1E-018 limites [ 709092707,967714 ; 734455461,126257 ] >									
267 	//        < 0x00000000000000000000000000000000000000000000000000439FD57460B0AA >									
268 	//     < SEAPORT_Portfolio_I_metadata_line_24_____Ekonomiya_Port_Spe_Value_20250515 >									
269 	//        < 0Lrmw70Xq5f4UEWN8ze56PKle190J68mbx3rfNq1WZa82GitKcuG85wmQf6gc9Hv >									
270 	//        < 1E-018 limites [ 734455461,126257 ; 769322600,101612 ] >									
271 	//        < 0x00000000000000000000000000000000000000000000000000460B0AA495E4A4 >									
272 	//     < SEAPORT_Portfolio_I_metadata_line_25_____Gelendzhgic_Port_Spe_Value_20250515 >									
273 	//        < 4Md4s1egr5OgL4r3TJ02n919UOdQQJf1j4unwj67zUJ1RcQ266RRSoc763O0B04z >									
274 	//        < 1E-018 limites [ 769322600,101612 ; 799897605,711594 ] >									
275 	//        < 0x00000000000000000000000000000000000000000000000000495E4A44C48C01 >									
276 	//     < SEAPORT_Portfolio_I_metadata_line_26_____Sea_Port_Hatanga_20250515 >									
277 	//        < fNL7U5kU53G8YytTe0f4S9VMIWva0v5HldliI6kG7VLe046TD1O79qhg98rdP2zC >									
278 	//        < 1E-018 limites [ 799897605,711594 ; 845683113,73383 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000004C48C0150A68F7 >									
280 	//     < SEAPORT_Portfolio_I_metadata_line_27_____Igarka_Port_Authority_20250515 >									
281 	//        < y2s06Irb11CbWc9b5yq9867C97mpRy4unmLl56hD6d0w847N1E8Eal73RHGq4uZx >									
282 	//        < 1E-018 limites [ 845683113,73383 ; 880610166,209277 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000050A68F753FB459 >									
284 	//     < SEAPORT_Portfolio_I_metadata_line_28_____Irkutsk_Port_Spe_Value_20250515 >									
285 	//        < jjuk201RzNZ39TpfhAC3iKc6Xf4337cSdNl2fSP1cCe6Z93q3CCNufVoBs0mtXKF >									
286 	//        < 1E-018 limites [ 880610166,209277 ; 899978409,57312 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000053FB45955D4211 >									
288 	//     < SEAPORT_Portfolio_I_metadata_line_29_____Irtyshskiy_Port_Spe_Value_20250515 >									
289 	//        < 016gO3zpw4iaVH37NYs5H1kO30J9tG51fC3rXD8xxO6Xjlo9Bv2C5Yiv247hh433 >									
290 	//        < 1E-018 limites [ 899978409,57312 ; 922757793,000955 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000055D42115800443 >									
292 	//     < SEAPORT_Portfolio_I_metadata_line_30_____Kalach_na_Donu_Port_Spe_Value_20250515 >									
293 	//        < 8uOX13TDkG1W0SaP3KrXZ0YwPbJrs7C79wGR1YPQ9Sd69lfbVx6gHR4TpDf09z48 >									
294 	//        < 1E-018 limites [ 922757793,000955 ; 960657936,34675 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000058004435B9D902 >									
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
338 	//     < SEAPORT_Portfolio_I_metadata_line_31_____Kaliningrad_Port_Authorities_20250515 >									
339 	//        < V0bag60js6I6SfqW538onKUtPT69346npmtomHVbXj458mH8CS3NggBAWlBw9UuZ >									
340 	//        < 1E-018 limites [ 960657936,34675 ; 987430053,976926 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000005B9D9025E2B2DD >									
342 	//     < SEAPORT_Portfolio_I_metadata_line_32_____Kaluga_Port_Spe_Value_20250515 >									
343 	//        < f6trg3dDr8aae88MkTQkF559XvalvRRtOEZT5BBw6rwX1lNlxmonh9H9x29iFAWd >									
344 	//        < 1E-018 limites [ 987430053,976926 ; 1027805808,79615 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000005E2B2DD6204EA5 >									
346 	//     < SEAPORT_Portfolio_I_metadata_line_33_____Kandalaksha_Port_Spe_Value_20250515 >									
347 	//        < sWXO0xaK7fkAh82s9TmSwyozNR6AOgi4SrMPV2DyG3WfqfSRiTW02Wm5oK89YUNu >									
348 	//        < 1E-018 limites [ 1027805808,79615 ; 1075420583,15064 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000006204EA5668F62A >									
350 	//     < SEAPORT_Portfolio_I_metadata_line_34_____Kasimov_Port_Spe_Value_20250515 >									
351 	//        < pSdS0irYA991G0InokXYp87282239ml7uD7ZXVUpuatwtCIU045xKvI93ipM1Gaj >									
352 	//        < 1E-018 limites [ 1075420583,15064 ; 1095498326,97416 ] >									
353 	//        < 0x00000000000000000000000000000000000000000000000000668F62A6879909 >									
354 	//     < SEAPORT_Portfolio_I_metadata_line_35_____Kazan_Port_Spe_Value_20250515 >									
355 	//        < v8eX7831F2sDQbEpTruxMj4vBzX9P02bR15r30slOP22wXtrK31MSwa9dp0tI2ug >									
356 	//        < 1E-018 limites [ 1095498326,97416 ; 1115140726,87138 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000068799096A591D9 >									
358 	//     < SEAPORT_Portfolio_I_metadata_line_36_____Khanty_Mansiysk_Port_Spe_Value_20250515 >									
359 	//        < 1U066GFeMWa0JF0777z10wvNPIl5yRRxMAV67kiSoLC2KiWSvmRi4f0nuKjOBuMu >									
360 	//        < 1E-018 limites [ 1115140726,87138 ;  ] >									
361 	//        < 0x000000000000000000000000000000000000000000000000006A591D96EADB9D >									
362 	//     < SEAPORT_Portfolio_I_metadata_line_37_____Kholmsk_Port_Spe_Value_20250515 >									
363 	//        < zK26UZ019yJyP4ywHuI42YcUWatO34jvezs5en80nec3zpA4FgovHs14sOF0TfOh >									
364 	//        < 1E-018 limites [ 1160549414,78432 ; 1202640357,68869 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000006EADB9D72B1564 >									
366 	//     < SEAPORT_Portfolio_I_metadata_line_38_____Kolomna_Port_Spe_Value_20250515 >									
367 	//        < g7gc35EouNCtH8qx54qc8tTvI8S2D109iK4CK0q433IIPKJ03mU9Idx70wqRM6Hw >									
368 	//        < 1E-018 limites [ 1202640357,68869 ; 1247570179,81282 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000072B156476FA41A >									
370 	//     < SEAPORT_Portfolio_I_metadata_line_39_____Kolpashevo_Port_Spe_Value_20250515 >									
371 	//        < 4M6NAlTi73GRY35vIv7bvB95X8C0UN39C090nZv409lP0g26HDJ2DDN8yC1Vt5rH >									
372 	//        < 1E-018 limites [ 1247570179,81282 ; 1284416486,51369 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000076FA41A7A7DD31 >									
374 	//     < SEAPORT_Portfolio_I_metadata_line_40_____Korsakov_Port_Spe_Value_20250515 >									
375 	//        < h2Teu64dtajTo08bR9a86DDzlu3KOwLEPf7h7627zWDy9Eqf8k0PVc8IL5q1uM56 >									
376 	//        < 1E-018 limites [ 1284416486,51369 ; 1315013459,51346 ] >									
377 	//        < 0x000000000000000000000000000000000000000000000000007A7DD317D68D22 >									
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