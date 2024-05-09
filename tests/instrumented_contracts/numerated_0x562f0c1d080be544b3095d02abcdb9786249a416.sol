1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	SEAPORT_Portfolio_V_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	SEAPORT_Portfolio_V_883		"	;
8 		string	public		symbol =	"	SEAPORT883V		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		926816166179938000000000000					;	
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
92 	//     < SEAPORT_Portfolio_V_metadata_line_1_____Gelendzhgic_Port_Spe_Value_20230515 >									
93 	//        < YXkQDNBZ2zu8UeeGvNs229Bn1iF33hqm5y5tIZFt1g59oEKq265pVfErR1Aox8Yf >									
94 	//        < 1E-018 limites [ 1E-018 ; 19700512,1623823 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000756C9A84 >									
96 	//     < SEAPORT_Portfolio_V_metadata_line_2_____Hatanga Port of Hatanga_Port_Spe_Value_20230515 >									
97 	//        < 5j5h1tnAZC78QQF951I0C0CK5GJ5MEVX7V5rjjIx4Qou6TJHj4v9u46059L7z10s >									
98 	//        < 1E-018 limites [ 19700512,1623823 ; 43633702,1775054 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000756C9A8410413C0DD >									
100 	//     < SEAPORT_Portfolio_V_metadata_line_3_____Igarka Port of Igarka_Port_Spe_Value_20230515 >									
101 	//        < sr3tm7GPzioBdFx7t50tv61m9o2ppn5j9SWc2x17Zmjp8r1f86A9HY2YTsO8kYNb >									
102 	//        < 1E-018 limites [ 43633702,1775054 ; 65764616,6539869 ] >									
103 	//        < 0x000000000000000000000000000000000000000000000010413C0DD187FCD955 >									
104 	//     < SEAPORT_Portfolio_V_metadata_line_4_____Igarka_Port_Authority_20230515 >									
105 	//        < 2t35ZxX6MAf3T5150lY4rySdrtNC7mRA1aTBo4D9yikHFn6FmhkIfKMp9qky7QWf >									
106 	//        < 1E-018 limites [ 65764616,6539869 ; 90138831,533778 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000187FCD95521944F305 >									
108 	//     < SEAPORT_Portfolio_V_metadata_line_5_____Igarka_Port_Authority_20230515 >									
109 	//        < o4Kkuu6ReZRdUhE8MGX4YyxLjlScxVUzTf0WkQ5oaRrBQ3qOAVw8g2y6uno51kF1 >									
110 	//        < 1E-018 limites [ 90138831,533778 ; 109686050,709904 ] >									
111 	//        < 0x000000000000000000000000000000000000000000000021944F30528DC7A382 >									
112 	//     < SEAPORT_Portfolio_V_metadata_line_6_____Irkutsk_Port_Spe_Value_20230515 >									
113 	//        < rjZc9xnDvoe7uz2EBkuMn8dZFfR6ZiBJc34Xg4O2S0D9t1ETd50a1Zsk6I7c7v49 >									
114 	//        < 1E-018 limites [ 109686050,709904 ; 133737440,63301 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000028DC7A38231D2325B3 >									
116 	//     < SEAPORT_Portfolio_V_metadata_line_7_____Irtyshskiy_Port_Spe_Value_20230515 >									
117 	//        < 2rKI9jpPGp412RNJ5P28Fa273bFm23V3IUeWTNv1LaJ67KVChUsBE75fxn90M944 >									
118 	//        < 1E-018 limites [ 133737440,63301 ; 158208227,118916 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000031D2325B33AEFE9AAB >									
120 	//     < SEAPORT_Portfolio_V_metadata_line_8_____Joint_Stock_Company_Nakhodka_Commercial_Sea_Port_20230515 >									
121 	//        < YAqvdHkws2m4q17pfOHheku5L77JaM59qZjIul6JI47u6D2ZU6Nc54Hp1WBFvGo4 >									
122 	//        < 1E-018 limites [ 158208227,118916 ; 183862710,319518 ] >									
123 	//        < 0x00000000000000000000000000000000000000000000003AEFE9AAB447E83D2B >									
124 	//     < SEAPORT_Portfolio_V_metadata_line_9_____Joint_Stock_Company_Nakhodka_Commercial_Sea_Port_20230515 >									
125 	//        < tJ5OM47V05P15J07Gp4gJge1dx2Tlx9RZgD0VMKsH2FMI4VwYIeoJuNazDplxjrm >									
126 	//        < 1E-018 limites [ 183862710,319518 ; 205261373,769363 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000447E83D2B4C7740214 >									
128 	//     < SEAPORT_Portfolio_V_metadata_line_10_____JSC_Arkhangelsk_Sea_Commercial_Port_20230515 >									
129 	//        < gSU3Yy9L15h8V2Zamj3yl4TwwyV6QI73vkc7WS7L5YN56cAKGAICYV28jRF7Qch3 >									
130 	//        < 1E-018 limites [ 205261373,769363 ; 225109272,426007 ] >									
131 	//        < 0x00000000000000000000000000000000000000000000004C774021453DC17F7E >									
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
174 	//     < SEAPORT_Portfolio_V_metadata_line_11_____JSC_Arkhangelsk_Sea_Commercial_Port_20230515 >									
175 	//        < KV1oB572HUY4Xk1E14ELRQtCLUIm3ZuPTSamefuG2qUOyC9uiqCwGQ5T3QDp33T7 >									
176 	//        < 1E-018 limites [ 225109272,426007 ; 251274073,934363 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000053DC17F7E5D9B5D115 >									
178 	//     < SEAPORT_Portfolio_V_metadata_line_12_____JSC_Azov_Sea_Port_20230515 >									
179 	//        < XkbShBP57CXHfK915s2IE8v7f73XPSQ1PJ924o25W48CcbRuGK8aU3A9qwOkZb4L >									
180 	//        < 1E-018 limites [ 251274073,934363 ; 275314628,366666 ] >									
181 	//        < 0x00000000000000000000000000000000000000000000005D9B5D11566900CAA8 >									
182 	//     < SEAPORT_Portfolio_V_metadata_line_13_____JSC_Azov_Sea_Port_20230515 >									
183 	//        < bXwXrUPCCe5M9v7rRND539u7S8e157DYf45iR8HQNYhsT4ol796KzaF6t82gQwI9 >									
184 	//        < 1E-018 limites [ 275314628,366666 ; 291639672,755782 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000066900CAA86CA4ED51F >									
186 	//     < SEAPORT_Portfolio_V_metadata_line_14_____JSC_Novoroslesexport_20230515 >									
187 	//        < kfPEEdsGdZPb9Di9A16ewkSCWW3CH4wtCS5s0yZT3k6uAIGsy42vfS1nGZdB8Izx >									
188 	//        < 1E-018 limites [ 291639672,755782 ; 319651003,135844 ] >									
189 	//        < 0x00000000000000000000000000000000000000000000006CA4ED51F77144BB0D >									
190 	//     < SEAPORT_Portfolio_V_metadata_line_15_____JSC_Novoroslesexport_20230515 >									
191 	//        < 9dZTgYh202Bix5b95QA715fU8La2ZflCkE37i3dFkP8NNQLrYwVG1fgQBvaQ1yeo >									
192 	//        < 1E-018 limites [ 319651003,135844 ; 347486562,186463 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000077144BB0D8172E6C4E >									
194 	//     < SEAPORT_Portfolio_V_metadata_line_16_____JSC_Yeysk_Sea_Port_20230515 >									
195 	//        < K0mcdlW9zI4vb6jbeHBxcCZ4k5p30UeqL3LvW1w4T2oI5wss3sljt1mPkf7pzyUJ >									
196 	//        < 1E-018 limites [ 347486562,186463 ; 372417716,896553 ] >									
197 	//        < 0x00000000000000000000000000000000000000000000008172E6C4E8ABC8589D >									
198 	//     < SEAPORT_Portfolio_V_metadata_line_17_____JSC_Yeysk_Sea_Port_20230515 >									
199 	//        < 4hzv7bE438KBW9O2i80yzCTF85bE1f1mjc5C4G76M59oa73l73seIR14QEd6212h >									
200 	//        < 1E-018 limites [ 372417716,896553 ; 395047810,385356 ] >									
201 	//        < 0x00000000000000000000000000000000000000000000008ABC8589D932AB20E2 >									
202 	//     < SEAPORT_Portfolio_V_metadata_line_18_____Kalach_na_Donu_Port_Spe_Value_20230515 >									
203 	//        < q9H2FNyT0KJIEsivGpTQI6Llqd81E52gG0974k7Q706YB4jFDC6XoLvJP4Y8mcil >									
204 	//        < 1E-018 limites [ 395047810,385356 ; 420592665,428759 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000932AB20E29CAED7BE2 >									
206 	//     < SEAPORT_Portfolio_V_metadata_line_19_____Kaliningrad Port of Kaliningrad_Port_Spe_Value_20230515 >									
207 	//        < 37kmnDOIUM5QAoPc2GD2TEoONOEBfJ6XFQbe12XuONLt0oP5lWnoyZcF09FjA73C >									
208 	//        < 1E-018 limites [ 420592665,428759 ; 439885667,552474 ] >									
209 	//        < 0x00000000000000000000000000000000000000000000009CAED7BE2A3DEC44D7 >									
210 	//     < SEAPORT_Portfolio_V_metadata_line_20_____Kaliningrad_Port_Authorities_20230515 >									
211 	//        < r9FZQn5OZq2Gn4L7gOji52YS072042X587hSR1RBmJsy7oEAP0hvvM0eDe60o6Hu >									
212 	//        < 1E-018 limites [ 439885667,552474 ; 463796200,156979 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000A3DEC44D7ACC70D8A3 >									
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
256 	//     < SEAPORT_Portfolio_V_metadata_line_21_____Kaliningrad_Port_Authorities_20230515 >									
257 	//        < 9D2Rhw5xfZioCO27R3LsK3y3Xyss5OLqB5VvTgq67TM3poamVbVPozWwB6Mi38iB >									
258 	//        < 1E-018 limites [ 463796200,156979 ; 479007571,628296 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000ACC70D8A3B271B8E9E >									
260 	//     < SEAPORT_Portfolio_V_metadata_line_22_____Kaluga_Port_Spe_Value_20230515 >									
261 	//        < qcS0FPy2hoX85Fx4cWiM71K2i8RmPso96Vng94P5OLTqCic0l3R7Kf3gI9NSetWX >									
262 	//        < 1E-018 limites [ 479007571,628296 ; 500834058,449992 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000B271B8E9EBA9342208 >									
264 	//     < SEAPORT_Portfolio_V_metadata_line_23_____Kandalaksha Port of Kandalaksha_Port_Spe_Value_20230515 >									
265 	//        < 9oFcHMc50X9z9QwKKkBd6M7pxlj0GPtTV16tUo9drA3l76qykA6qHnzj8zH1cSLm >									
266 	//        < 1E-018 limites [ 500834058,449992 ; 521437883,921742 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000BA9342208C2403135C >									
268 	//     < SEAPORT_Portfolio_V_metadata_line_24_____Kandalaksha_Port_Spe_Value_20230515 >									
269 	//        < 20uHStHkNs3Ea19TO1o26C0BO4XPVp1J02N8mq9xLPg6psxcYsMZRw86y10qrCMh >									
270 	//        < 1E-018 limites [ 521437883,921742 ; 542573965,901628 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000C2403135CCA1FE2D62 >									
272 	//     < SEAPORT_Portfolio_V_metadata_line_25_____Kasimov_Port_Spe_Value_20230515 >									
273 	//        < 42Jw1A79tJSwOm3l2z13iE7e5P7r5h67SWso6zPZ20x4AT331Kd3GXT45FD0GQ57 >									
274 	//        < 1E-018 limites [ 542573965,901628 ; 558526527,143129 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000000CA1FE2D62D0113DA9E >									
276 	//     < SEAPORT_Portfolio_V_metadata_line_26_____Kazan_Port_Spe_Value_20230515 >									
277 	//        < CO9b9HP9Dff9naRm9OH22M0DltaUCK67r1uLdig9mnS60Vru0FwVYh421liapKpz >									
278 	//        < 1E-018 limites [ 558526527,143129 ; 578673784,685111 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000000D0113DA9ED792A2118 >									
280 	//     < SEAPORT_Portfolio_V_metadata_line_27_____Kerch_Port_Spe_Value_20230515 >									
281 	//        < Ww7Zj77mc61R12Hp6dX31pjRn82ypipj6ftXXulr3RpyYEb4gNHoO495swWtVVvo >									
282 	//        < 1E-018 limites [ 578673784,685111 ; 605692154,529751 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000D792A2118E1A34E3D0 >									
284 	//     < SEAPORT_Portfolio_V_metadata_line_28_____Kerchenskaya_Port_Spe_Value_20230515 >									
285 	//        < pXZJ4sHJ4WWV093KU4TO24b22N0J8a526v55qJdHwSE780xml258xHsa0U7ane1z >									
286 	//        < 1E-018 limites [ 605692154,529751 ; 630564105,210962 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000E1A34E3D0EAE74798D >									
288 	//     < SEAPORT_Portfolio_V_metadata_line_29_____Kerchenskaya_Port_Spe_Value_I_20230515 >									
289 	//        < JC2vK7Lm8ElVNCR3VxLl37Iw4s3U7s70Zx96ph87EVeRWxui1EVegd5gw36VQN53 >									
290 	//        < 1E-018 limites [ 630564105,210962 ; 659488743,286901 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000EAE74798DF5ADBF84C >									
292 	//     < SEAPORT_Portfolio_V_metadata_line_30_____Khanty_Mansiysk_Port_Spe_Value_20230515 >									
293 	//        < 4r084JmA9rT6z1BBZy6mPAy4mnOH4Oss51M0o8xFjNnpV0YP5FGVw99vR1247OFV >									
294 	//        < 1E-018 limites [ 659488743,286901 ; 682317572,146876 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000F5ADBF84CFE2EDFF92 >									
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
338 	//     < SEAPORT_Portfolio_V_metadata_line_31_____Kholmsk Port of Kholmsk_Port_Spe_Value_20230515 >									
339 	//        < 1r002CJdNKXPItWsGa1fhatGKLJA07B6P9Sx7xFu7h0fXxrG8EgwG2uD0u0ZV4Ts >									
340 	//        < 1E-018 limites [ 682317572,146876 ; 706113212,169304 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000FE2EDFF921070C34374 >									
342 	//     < SEAPORT_Portfolio_V_metadata_line_32_____Kholmsk_Port_Spe_Value_20230515 >									
343 	//        < 3XUDiuo89221F5te0rnfhD29cTpKAB83Wf58i2h1ZonF4tEvw88xHgvp506BF6JH >									
344 	//        < 1E-018 limites [ 706113212,169304 ; 734858201,81138 ] >									
345 	//        < 0x000000000000000000000000000000000000000000001070C34374111C18A309 >									
346 	//     < SEAPORT_Portfolio_V_metadata_line_33_____Kolomna_Port_Spe_Value_20230515 >									
347 	//        < 5Sp4Js16d33nOw2SPTX1a0O6615GJ1o7MBJaztQ3A14TdYEnU8Y2y6emu84m7qX4 >									
348 	//        < 1E-018 limites [ 734858201,81138 ; 757553568,878122 ] >									
349 	//        < 0x00000000000000000000000000000000000000000000111C18A30911A35F04CB >									
350 	//     < SEAPORT_Portfolio_V_metadata_line_34_____Kolpashevo_Port_Spe_Value_20230515 >									
351 	//        < 79XmUAcxc80kAhm57jrZ37JwgN5RW8130xog67Av07xM8Fv0eJDhqQkwTHet44aj >									
352 	//        < 1E-018 limites [ 757553568,878122 ; 779877983,505221 ] >									
353 	//        < 0x0000000000000000000000000000000000000000000011A35F04CB12286F5F42 >									
354 	//     < SEAPORT_Portfolio_V_metadata_line_35_____Korsakov Port of Korsakov_Port_Spe_Value_20230515 >									
355 	//        < TolJTfwU9G20q5iQrLayFro93FuiV8BDepL10A0z8HeU6DJLYn3M6fukDFO6RMNl >									
356 	//        < 1E-018 limites [ 779877983,505221 ; 809465030,878833 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000012286F5F4212D8C99FA3 >									
358 	//     < SEAPORT_Portfolio_V_metadata_line_36_____Korsakov_Port_Spe_Value_20230515 >									
359 	//        < 7aqR1m3ecejfZOh6kjeyVq03hP2aZ9W9HQBiIpmuxfrWa6H91RI0qtOq4FTZHW5Q >									
360 	//        < 1E-018 limites [ 809465030,878833 ;  ] >									
361 	//        < 0x0000000000000000000000000000000000000000000012D8C99FA3134175714F >									
362 	//     < SEAPORT_Portfolio_V_metadata_line_37_____Krasnoyarsk_Port_Spe_Value_20230515 >									
363 	//        < 49Puo5T3813ASRt31G7LcBy6Ll4hr46K33mbUXp7hQ84yx7l08Dj97c1492Md112 >									
364 	//        < 1E-018 limites [ 827025938,83848 ; 851416004,493967 ] >									
365 	//        < 0x00000000000000000000000000000000000000000000134175714F13D2D5BAB5 >									
366 	//     < SEAPORT_Portfolio_V_metadata_line_38_____Kronshtadt Port of Kronshtadt_Port_Spe_Value_20230515 >									
367 	//        < X3MS55Qy634Q0H7HSSAp8C4zkg46yal5JYQ388T8zCFlAzDJ0UZ53AyD34W8M75E >									
368 	//        < 1E-018 limites [ 851416004,493967 ; 878206498,187373 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000013D2D5BAB5147284C74E >									
370 	//     < SEAPORT_Portfolio_V_metadata_line_39_____Kronshtadt_Port_Spe_Value_20230515 >									
371 	//        < U35UY2rdGsCb4a3lKNJR186YAoAbCiPdzoT22Qnvsd03L1oQiUi73O2P40awjF4m >									
372 	//        < 1E-018 limites [ 878206498,187373 ; 905499642,938257 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000147284C74E151532CFF9 >									
374 	//     < SEAPORT_Portfolio_V_metadata_line_40_____Labytnangi_Port_Spe_Value_20230515 >									
375 	//        < EhN9RPX63T7r306rI957iKzEiJ2piCNAjQ3i1491S8ap735lAzd09h5tfgefABbU >									
376 	//        < 1E-018 limites [ 905499642,938257 ; 926816166,179938 ] >									
377 	//        < 0x00000000000000000000000000000000000000000000151532CFF91594413EDD >									
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