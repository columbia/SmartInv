1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	SEAPORT_Portfolio_VI_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	SEAPORT_Portfolio_VI_883		"	;
8 		string	public		symbol =	"	SEAPORT883VI		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		897688033763432000000000000					;	
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
92 	//     < SEAPORT_Portfolio_VI_metadata_line_1_____Lazarev Port of Lazarev_Port_Spe_Value_20230515 >									
93 	//        < PD8HMPRz8f9Nn9Y75JRiUWHlv2Nb13BXJeTKG4rz66l6sFEE383yz6Y332h83cFr >									
94 	//        < 1E-018 limites [ 1E-018 ; 20532396,7569184 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000007A61F56F >									
96 	//     < SEAPORT_Portfolio_VI_metadata_line_2_____Lazarev_Port_Spe_Value_20230515 >									
97 	//        < L7qjH51lFJQpiKTHAAcn97fkc27WT1546DP27YLI7Pw6tc7o14rxMZ6pJg8XYlTz >									
98 	//        < 1E-018 limites [ 20532396,7569184 ; 40731936,343651 ] >									
99 	//        < 0x0000000000000000000000000000000000000000000000007A61F56FF2C80296 >									
100 	//     < SEAPORT_Portfolio_VI_metadata_line_3_____Lomonosov Port of Lomonosov_Port_Spe_Value_20230515 >									
101 	//        < Do6m66AwvssG7WjUa5hn1w0E851b283W603mCcz5EuPOFNvzyZjJ4MKVDzP116Um >									
102 	//        < 1E-018 limites [ 40731936,343651 ; 67176822,8351274 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000F2C8029619067B45F >									
104 	//     < SEAPORT_Portfolio_VI_metadata_line_4_____Lomonosov_Port_Authority_20230515 >									
105 	//        < PkkNg3Q3JKY5G3DqK6Ohyp3GIGv2Hjr0PYaC05nhHA7F8dbZR6EhJ0XhE4W66SyU >									
106 	//        < 1E-018 limites [ 67176822,8351274 ; 84556181,1374236 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000019067B45F1F7FE8035 >									
108 	//     < SEAPORT_Portfolio_VI_metadata_line_5_____Lomonosov_Port_Authority_20230515 >									
109 	//        < lGrgWI1P4QEpAv1I6R1A77YKAr4c903v6ofkdH81cx24hSDwGpm6mGTNZT5C8JuI >									
110 	//        < 1E-018 limites [ 84556181,1374236 ; 102257108,640016 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000001F7FE80352617FF904 >									
112 	//     < SEAPORT_Portfolio_VI_metadata_line_6_____Magadan Port of Magadan_Port_Spe_Value_20230515 >									
113 	//        < 47YQ9iu0RJQeV2O056w98824IFXwYq1dD9N3deudsX4AR9MVZ09b7Y5Fu5VyOOaT >									
114 	//        < 1E-018 limites [ 102257108,640016 ; 120014173,090999 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000002617FF9042CB571A51 >									
116 	//     < SEAPORT_Portfolio_VI_metadata_line_7_____Magadan_Port_Authority_20230515 >									
117 	//        < 0F94hlL37925Ydm62Ch6c57yZW53nOH56Q6ViE90TQ15bjaZdS8q35VX5nD2Jg62 >									
118 	//        < 1E-018 limites [ 120014173,090999 ; 141679491,296472 ] >									
119 	//        < 0x00000000000000000000000000000000000000000000002CB571A5134C79C13D >									
120 	//     < SEAPORT_Portfolio_VI_metadata_line_8_____Magadan_Port_Authority_20230515 >									
121 	//        < cGag5JW4j14Wq747b3o0f4U5w2B6NpJSHjghO36v9jK2eRG3RhTXOPzwoHag4p6I >									
122 	//        < 1E-018 limites [ 141679491,296472 ; 156875714,936206 ] >									
123 	//        < 0x000000000000000000000000000000000000000000000034C79C13D3A70D5A19 >									
124 	//     < SEAPORT_Portfolio_VI_metadata_line_9_____Mago Port of Mago_Port_Spe_Value_20230515 >									
125 	//        < I3k2ND4zIYv3u367M5H9X68Ay5k31g91dperA80VZgtW7pVt6b89paO3a5ZUciAX >									
126 	//        < 1E-018 limites [ 156875714,936206 ; 183619302,033957 ] >									
127 	//        < 0x00000000000000000000000000000000000000000000003A70D5A1944674D3CF >									
128 	//     < SEAPORT_Portfolio_VI_metadata_line_10_____Mago_Port_Spe_Value_20230515 >									
129 	//        < I2R7459dLjmny74njI3SokVNFr1x73U0aJVY33ew4I9169e19IO59woBX1q5KC18 >									
130 	//        < 1E-018 limites [ 183619302,033957 ; 199605969,514197 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000044674D3CF4A5BE8BCB >									
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
174 	//     < SEAPORT_Portfolio_VI_metadata_line_11_____Makhachkala Port of Makhachkala_Port_Spe_Value_20230515 >									
175 	//        < y8Kt2KqN7TiiasqexF1718dPCaIw9dg7WSPW39Mpmr7E8WfX8uaBsrQ5v00d76fp >									
176 	//        < 1E-018 limites [ 199605969,514197 ; 224120220,607068 ] >									
177 	//        < 0x00000000000000000000000000000000000000000000004A5BE8BCB537DC5320 >									
178 	//     < SEAPORT_Portfolio_VI_metadata_line_12_____Makhachkala_Port_Spe_Value_20230515 >									
179 	//        < 9Ir0ZQ0lqdby37549n79i7NJ5KD09p569Q9Q0T5u9nZMPiSZqkg2BEoqgD8zs2e6 >									
180 	//        < 1E-018 limites [ 224120220,607068 ; 251407023,780672 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000537DC53205DA80AE9E >									
182 	//     < SEAPORT_Portfolio_VI_metadata_line_13_____Makhachkala_Sea_Trade_Port_20230515 >									
183 	//        < 4xI5A1US2Qlk46s3qjp1OQ0P5vWGnsXqyK43vDbnHTdyC6J99CHl92JhG0z1N5PL >									
184 	//        < 1E-018 limites [ 251407023,780672 ; 279869542,404284 ] >									
185 	//        < 0x00000000000000000000000000000000000000000000005DA80AE9E6842709F4 >									
186 	//     < SEAPORT_Portfolio_VI_metadata_line_14_____Makhachkala_Sea_Trade_Port_20230515 >									
187 	//        < zzmr89iUg39k1P2bWEGlXUEoP42OzX5Crnh5DP4AvUs2FOHYvTVboem85NUR24Ho >									
188 	//        < 1E-018 limites [ 279869542,404284 ; 299727968,195181 ] >									
189 	//        < 0x00000000000000000000000000000000000000000000006842709F46FA849787 >									
190 	//     < SEAPORT_Portfolio_VI_metadata_line_15_____Marine_Administration_of_Chukotka_Ports_20230515 >									
191 	//        < 5bTCGbmQ7CLVT6A7j9x0yYoLksXw7nryG123NJI5M10beVK7zDI9sW30ULZUDQ8Y >									
192 	//        < 1E-018 limites [ 299727968,195181 ; 318614495,138317 ] >									
193 	//        < 0x00000000000000000000000000000000000000000000006FA84978776B17251D >									
194 	//     < SEAPORT_Portfolio_VI_metadata_line_16_____Marine_Administration_of_Chukotka_Ports_I_20230515 >									
195 	//        < 1n5FcrZkjA9aWSk1qfC8yZmKbfty9FK9B2SKmq0DGVD89Tp92MMsjcog4i9rIx5w >									
196 	//        < 1E-018 limites [ 318614495,138317 ; 336805404,997074 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000076B17251D7D7844547 >									
198 	//     < SEAPORT_Portfolio_VI_metadata_line_17_____Marine_Administration_of_Vladivostok_Port_Posyet_Branch_20230515 >									
199 	//        < glHj16pG5KvPJBnN0ld0I27o4h79Mh02H47aTiD8WMj49h4mRqSzr41arMaQWMX2 >									
200 	//        < 1E-018 limites [ 336805404,997074 ; 363384885,833866 ] >									
201 	//        < 0x00000000000000000000000000000000000000000000007D7844547875F156FB >									
202 	//     < SEAPORT_Portfolio_VI_metadata_line_18_____Marine_Administration_of_Vladivostok_Port_Posyet_Branch_20230515 >									
203 	//        < L6r32k9Ogy671clrHvY22EvhCnrhC5O2suMi3MUd7SD4Et23TtY9l2a9DoBu0P65 >									
204 	//        < 1E-018 limites [ 363384885,833866 ; 378734314,14678 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000875F156FB8D16EB56A >									
206 	//     < SEAPORT_Portfolio_VI_metadata_line_19_____Maritime_Port_Administration_of_Novorossiysk_20230515 >									
207 	//        < y497KmmXDs1bhg6MEox4drF822B5IGr8g8cW5Md0YikIHI5P5NO1hQ1oPJF4U29C >									
208 	//        < 1E-018 limites [ 378734314,14678 ; 393987869,152679 ] >									
209 	//        < 0x00000000000000000000000000000000000000000000008D16EB56A92C59C957 >									
210 	//     < SEAPORT_Portfolio_VI_metadata_line_20_____Maritime_Port_Administration_of_Novorossiysk_20230515 >									
211 	//        < pQ7g63Ze6ig84FJsPm2jy2cs7s6e7YzKJE4cgjoJ424Tbh76b0dsqM9k4zGc2Lgu >									
212 	//        < 1E-018 limites [ 393987869,152679 ; 421129513,397691 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000092C59C9579CE20A61F >									
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
256 	//     < SEAPORT_Portfolio_VI_metadata_line_21_____0_20230515 >									
257 	//        < KMLX1KTCk3oQ6JVNJLXs5607w7e50Pm7D28r2ji4jqv272RC1DJHDIOUN6Q0b3ga >									
258 	//        < 1E-018 limites [ 421129513,397691 ; 450545884,295621 ] >									
259 	//        < 0x00000000000000000000000000000000000000000000009CE20A61FA7D767801 >									
260 	//     < SEAPORT_Portfolio_VI_metadata_line_22_____Mezen Port of Mezen_Port_Spe_Value_20230515 >									
261 	//        < mvX1MIvGTMH1TT5Fn3G5TNkPnTq5E2A0kO976MYH772CAK0kV9qrWMw8Q3rowh3u >									
262 	//        < 1E-018 limites [ 450545884,295621 ; 467171474,097526 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000A7D767801AE08F1B05 >									
264 	//     < SEAPORT_Portfolio_VI_metadata_line_23_____Mezen_Port_Authority_20230515 >									
265 	//        < ZW995x9Xy5J0lW5811I6zNEDOYRloNpbf8XfF0HNmeMOizc8Vmqby1P9SA9m9yHh >									
266 	//        < 1E-018 limites [ 467171474,097526 ; 496690418,528729 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000AE08F1B05B908170B0 >									
268 	//     < SEAPORT_Portfolio_VI_metadata_line_24_____Mezen_Port_Authority_20230515 >									
269 	//        < p6huN5H4V9uz6m0uN4ZvQN21QJrjZdh1eooiA2fHnBA3p63s46091z7fvdhXBnzK >									
270 	//        < 1E-018 limites [ 496690418,528729 ; 512311320,080516 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000B908170B0BED9D0B5C >									
272 	//     < SEAPORT_Portfolio_VI_metadata_line_25_____Moscow_Port_Spe_Value_20230515 >									
273 	//        < 984L9nD18627PeP0jVqVbM54pdjmJ303pSFNb4CQruc8fWM1qZ4y0l0aLTHRM742 >									
274 	//        < 1E-018 limites [ 512311320,080516 ; 535107340,275707 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000000BED9D0B5CC757D02BF >									
276 	//     < SEAPORT_Portfolio_VI_metadata_line_26_____Murmansk Port of Murmansk_Port_Spe_Value_20230515 >									
277 	//        < G5aBqVP8uqpj3U51Eepp4Bn941RfClw60iPG1pfJ9Yy8Vq2B88W2KU2LStcw9f66 >									
278 	//        < 1E-018 limites [ 535107340,275707 ; 561975331,392672 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000000C757D02BFD15A24FC7 >									
280 	//     < SEAPORT_Portfolio_VI_metadata_line_27_____Murmansk_Port_Authority_20230515 >									
281 	//        < 7Uw3188q29mT248QXMSRE286T7r1i4D651Z912eyFgyqRiPhjd77wJwPb872R08C >									
282 	//        < 1E-018 limites [ 561975331,392672 ; 577376937,201808 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000D15A24FC7D716F4C0C >									
284 	//     < SEAPORT_Portfolio_VI_metadata_line_28_____Murmansk_Port_Authority_20230515 >									
285 	//        < 8R1AUnG2eL969a47563eJA6yN6qhUTv6VmmlNoEWA6DaRj2e4QH4A4sZfFkB6pif >									
286 	//        < 1E-018 limites [ 577376937,201808 ; 602581742,51462 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000D716F4C0CE07AAC71F >									
288 	//     < SEAPORT_Portfolio_VI_metadata_line_29_____Murom_Port_Spe_Value_20230515 >									
289 	//        < xoqE7pBvY4rRk5X47KN8p2jWp9sK3m96dHnHKH4ewDSsnf6VDIM708h4v7uCibOO >									
290 	//        < 1E-018 limites [ 602581742,51462 ; 620757257,508426 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000E07AAC71FE740069AA >									
292 	//     < SEAPORT_Portfolio_VI_metadata_line_30_____Nakhodka Port of Nakhodka_Port_Spe_Value_20230515 >									
293 	//        < A41e5CZ9sx2cTiUa26X2jrCfZ6829unduT5gi8nFC1gIqI7eCbG1392956yC2R2s >									
294 	//        < 1E-018 limites [ 620757257,508426 ; 645761923,903174 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000E740069AAF090A817A >									
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
338 	//     < SEAPORT_Portfolio_VI_metadata_line_31_____Naryan_Mar Port of Naryan_Mar_Port_Spe_Value_20230515 >									
339 	//        < Ub3rxaNfeVOLsH0TgZUOZhSFO5NmZ4dbDqVqv0dE8vQC50a36T068XgdjUDP8eA6 >									
340 	//        < 1E-018 limites [ 645761923,903174 ; 665949256,14032 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000000F090A817AF815DEE22 >									
342 	//     < SEAPORT_Portfolio_VI_metadata_line_32_____Naryan_Mar_Port_Authority_20230515 >									
343 	//        < KmqpiuRssH5y2EUK3Yiu6O9B0lJpEWWgry9RnT42f1Gz1zc0Bg94kWB530Q1vCc5 >									
344 	//        < 1E-018 limites [ 665949256,14032 ; 695750989,476352 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000F815DEE221032FFC437 >									
346 	//     < SEAPORT_Portfolio_VI_metadata_line_33_____Naryan_Mar_Port_Authority_20230515 >									
347 	//        < WxMC4Ida74OzXznY0318d6tmy6K0V78uCX72nZ8kkYcIxWn02Kvnjgzaln17l5V2 >									
348 	//        < 1E-018 limites [ 695750989,476352 ; 714106890,772429 ] >									
349 	//        < 0x000000000000000000000000000000000000000000001032FFC43710A068A629 >									
350 	//     < SEAPORT_Portfolio_VI_metadata_line_34_____Nevelsk Port of Nevelsk_Port_Spe_Value_20230515 >									
351 	//        < Cy1uu8dCG344VBvxujSBv2f6bhn5gkB10G1OZRRWO759i14d6zFNGqtkyYnCn00p >									
352 	//        < 1E-018 limites [ 714106890,772429 ; 741823458,016212 ] >									
353 	//        < 0x0000000000000000000000000000000000000000000010A068A62911459CC63D >									
354 	//     < SEAPORT_Portfolio_VI_metadata_line_35_____Nevelsk_Port_Authority_20230515 >									
355 	//        < Lo6N48Qp5GX0kx801imdXXtG5u5UuOVxiDHylNnv5KFkpGFY11F2lTqtXs4Fv130 >									
356 	//        < 1E-018 limites [ 741823458,016212 ; 768954845,388412 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000011459CC63D11E753FC6E >									
358 	//     < SEAPORT_Portfolio_VI_metadata_line_36_____Nevelsk_Port_Authority_20230515 >									
359 	//        < HtrOl3nI3ul7GEY0t5N27520nV6jiPliPAkQyDKQ3117j31298SMJ1Sjh56IAp9c >									
360 	//        < 1E-018 limites [ 768954845,388412 ;  ] >									
361 	//        < 0x0000000000000000000000000000000000000000000011E753FC6E1295530B52 >									
362 	//     < SEAPORT_Portfolio_VI_metadata_line_37_____Nikolaevsk on Amur Port of Nikolaevsk on Amur_Port_Spe_Value_20230515 >									
363 	//        < V8D747yF47eH722733cn1s1uv182n9KS6HV554IC0Gp5r51cF9N3f24840gN388w >									
364 	//        < 1E-018 limites [ 798146583,987227 ; 826175174,38341 ] >									
365 	//        < 0x000000000000000000000000000000000000000000001295530B52133C634772 >									
366 	//     < SEAPORT_Portfolio_VI_metadata_line_38_____Nikolaevsk_on_Amur_Sea_Port_20230515 >									
367 	//        < FTtY5Nb31fRx94Io6wp7OHK9E9qzqwttX64Gh1AXBPV75Q25eItnv0r4cTeN9FYv >									
368 	//        < 1E-018 limites [ 826175174,38341 ; 849657061,45984 ] >									
369 	//        < 0x00000000000000000000000000000000000000000000133C63477213C859CB95 >									
370 	//     < SEAPORT_Portfolio_VI_metadata_line_39_____Nikolaevsk_on_Amur_Sea_Port_20230515 >									
371 	//        < 3uHQKlk2kC31xp93B7TLrLz7TM59XN1s4zIF65kUxUI2ZL8HZ0hhn665b9Sxu101 >									
372 	//        < 1E-018 limites [ 849657061,45984 ; 875475936,783258 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000013C859CB9514623E45C2 >									
374 	//     < SEAPORT_Portfolio_VI_metadata_line_40_____Nizhnevartovsk_Port_Spe_Value_20230515 >									
375 	//        < 21eM1EJ61d9Xod79KUO2ZYx1SX7q9R1v8yG04X2AJl36G0PbbG7IIwrMYk6GANXG >									
376 	//        < 1E-018 limites [ 875475936,783258 ; 897688033,763432 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000014623E45C214E6A33E24 >									
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