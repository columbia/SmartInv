1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RE_Portfolio_XVIII_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RE_Portfolio_XVIII_883		"	;
8 		string	public		symbol =	"	RE883XVIII		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1495671977653760000000000000					;	
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
92 	//     < RE_Portfolio_XVIII_metadata_line_1_____Sirius_Inter_Ins_Corp_Am_A_20250515 >									
93 	//        < x3YHV01gIBOYqOL7yCZ3hT5Bs7oaarKDn1D27zFD6buyjFD05LP01y0uDr605laY >									
94 	//        < 1E-018 limites [ 1E-018 ; 37910689,45243 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000E1F72105 >									
96 	//     < RE_Portfolio_XVIII_metadata_line_2_____Sirius_International_20250515 >									
97 	//        < Er4o4nq0k411bzblCxrYgXs6TW4A8279b8tNZEH7jwGUp1h4Kp85el0drWPogfeO >									
98 	//        < 1E-018 limites [ 37910689,45243 ; 113948388,745289 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000E1F721052A72F734E >									
100 	//     < RE_Portfolio_XVIII_metadata_line_3_____Sirius_International_Managing_Agency_Limited_20250515 >									
101 	//        < Qr32qWo8P8c599351UA7ahlePyufMPl5HaKJQsoa2DYlu5ro5S1o8KMOB060CCd5 >									
102 	//        < 1E-018 limites [ 113948388,745289 ; 135618188,328164 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000002A72F734E32858F0C4 >									
104 	//     < RE_Portfolio_XVIII_metadata_line_4_____Sirius_International_Managing_Agency_Limited_20250515 >									
105 	//        < DA7A1IbV77F4z9wTGE2y6a36G9Rw3OH3V8hCx1MWoyZ5LSK3fhQIK369jTTMZPyz >									
106 	//        < 1E-018 limites [ 135618188,328164 ; 165055861,16124 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000032858F0C43D7CF43B8 >									
108 	//     < RE_Portfolio_XVIII_metadata_line_5_____SOGECAP_SA_Am_m_20250515 >									
109 	//        < SBU9mONsdr6KYN496VBPM3Iexa9win38hCwX9JoXuCPA1bTj11Uvs8u1Ow6Zfp1H >									
110 	//        < 1E-018 limites [ 165055861,16124 ; 181190672,278281 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000003D7CF43B8437FB084F >									
112 	//     < RE_Portfolio_XVIII_metadata_line_6_____SOMPO_Japan_Insurance_Co_Ap_Ap_20250515 >									
113 	//        < RULv3YQ4EJQbk10C5tN1kjM7sj1aX66TU8D61zA1DXBRNpdHY42nUK2OawuaktY5 >									
114 	//        < 1E-018 limites [ 181190672,278281 ; 226276836,731109 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000437FB084F544B70F4D >									
116 	//     < RE_Portfolio_XVIII_metadata_line_7_____Sompo_Japan_Nipponkoa_20250515 >									
117 	//        < FiKh79CcGI1277p5TR7J23LiV7S87V28Uak5uWei8111aJQ6L03nN62aN0A4zv3R >									
118 	//        < 1E-018 limites [ 226276836,731109 ; 267738596,903903 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000544B70F4D63BD8AF5E >									
120 	//     < RE_Portfolio_XVIII_metadata_line_8_____South_Africa_BBBp_Santam_Limited_BBB_m_20250515 >									
121 	//        < uw86OWJJdPDNLB8uR84Qd52a2kYrSwD0fyf2ZxcYRXe7kNGSwA875tL7dnh0vsH3 >									
122 	//        < 1E-018 limites [ 267738596,903903 ; 302480770,305557 ] >									
123 	//        < 0x000000000000000000000000000000000000000000000063BD8AF5E70AED08DA >									
124 	//     < RE_Portfolio_XVIII_metadata_line_9_____Southern_Africa_Reinsurance_Company_20250515 >									
125 	//        < nMGnVQO9qZ346u7s76a2b2S7jy6U2snK0mFO96B649wolI371VOHc3c1acd16EqB >									
126 	//        < 1E-018 limites [ 302480770,305557 ; 317702125,065442 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000070AED08DA765A6FA8E >									
128 	//     < RE_Portfolio_XVIII_metadata_line_10_____Spain_BBBp_Mapfre_Global_Risks_compania_Intenacional_de_Sguros_y_Reasegrous_SA_A_20250515 >									
129 	//        < o02SNKt5D9mxm08XPysX3s0B8kSqw15F8W2Kps077Wt81Fri38EJuIx67dTEDZF3 >									
130 	//        < 1E-018 limites [ 317702125,065442 ; 329967803,57596 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000765A6FA8E7AEC2EB39 >									
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
174 	//     < RE_Portfolio_XVIII_metadata_line_11_____Sportscover_Underwriting_Limited_20250515 >									
175 	//        < PBdNZ1vn6gQ5161zX6Y6l5DyPUzyq31Oue707ERnmQg9m42L3JUVyncbJwCY18R0 >									
176 	//        < 1E-018 limites [ 329967803,57596 ; 399633261,510476 ] >									
177 	//        < 0x00000000000000000000000000000000000000000000007AEC2EB3994DFFF8BB >									
178 	//     < RE_Portfolio_XVIII_metadata_line_12_____SRI_Re_20250515 >									
179 	//        < PUPj7FKoM03MeLUR54b7WrsZB5N0Wdz93L251vJYvK6pbM5QNs059RBS61ZR1M5G >									
180 	//        < 1E-018 limites [ 399633261,510476 ; 461878143,987474 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000094DFFF8BBAC1021FF2 >									
182 	//     < RE_Portfolio_XVIII_metadata_line_13_____St_Paul_Re_20250515 >									
183 	//        < fnKqub201HEiX08Yg27ABAHLPy7DbTTSsIW3hV5FRCDy1H8xWqC4laWb6mXBVCfN >									
184 	//        < 1E-018 limites [ 461878143,987474 ; 523082850,302061 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000AC1021FF2C2DD1185A >									
186 	//     < RE_Portfolio_XVIII_metadata_line_14_____Starr_Insurance_&_Reinsurance_Limited_A_20250515 >									
187 	//        < 055tX480nd3dSJfejO171qruCefE51cl7wLk2d35CnW1c1iNI4ap9bMk5Q3thQrI >									
188 	//        < 1E-018 limites [ 523082850,302061 ; 580265369,388946 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000C2DD1185AD82A6B1DE >									
190 	//     < RE_Portfolio_XVIII_metadata_line_15_____Starr_International__Europe__Limited_A_20250515 >									
191 	//        < kRm0CnfDkL2e47WVMT39ciIdo5R8Z97t60NTCLi4Ds33VykE6PpoJX3WXW75nT82 >									
192 	//        < 1E-018 limites [ 580265369,388946 ; 611419061,594167 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000D82A6B1DEE3C5774E3 >									
194 	//     < RE_Portfolio_XVIII_metadata_line_16_____Starr_Managing_Agents_Limited_20250515 >									
195 	//        < Mkz7u0ow7Yl12c71EUYj6oH49kT66A8T0X8sO1t744uR60674t5WeIIIUsh81Tt5 >									
196 	//        < 1E-018 limites [ 611419061,594167 ; 622175064,534208 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000E3C5774E3E7C73D089 >									
198 	//     < RE_Portfolio_XVIII_metadata_line_17_____Starr_Managing_Agents_Limited_20250515 >									
199 	//        < 7c8RmV2vh43343R2B0h4o3gmvamdmWmO7dNvw9iZ655wKh8N04Zp4O0nutK3nIq9 >									
200 	//        < 1E-018 limites [ 622175064,534208 ; 679312081,833849 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000E7C73D089FD103FBEB >									
202 	//     < RE_Portfolio_XVIII_metadata_line_18_____Starr_Managing_Agents_Limited_20250515 >									
203 	//        < CT5oX902n9kiM1L5H81a56zga1w2veOHri7tpcJA0dJ20A3pCHi2d1M5XN9x738a >									
204 	//        < 1E-018 limites [ 679312081,833849 ; 704322804,550256 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000FD103FBEB106617517B >									
206 	//     < RE_Portfolio_XVIII_metadata_line_19_____StarStone_Insurance_plc_m_Am_20250515 >									
207 	//        < 933TNR6I6gw46Twi44QQlOw9563B3E4JkwHkFmoNcz2e6zyr9BQfTSK8A47U8k8P >									
208 	//        < 1E-018 limites [ 704322804,550256 ; 753058495,702459 ] >									
209 	//        < 0x00000000000000000000000000000000000000000000106617517B11889414D6 >									
210 	//     < RE_Portfolio_XVIII_metadata_line_20_____StarStone_Underwriting_Limited_20250515 >									
211 	//        < 7s66QO6LEEfFB7NSL6A9H4n38dzra73f98H4G24fq1w956705rJ2W3b3J38YRAbW >									
212 	//        < 1E-018 limites [ 753058495,702459 ; 775779365,801598 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000011889414D612100160B8 >									
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
256 	//     < RE_Portfolio_XVIII_metadata_line_21_____StarStone_Underwriting_Limited_20250515 >									
257 	//        < 8Qx54GTs45K1kpIjYgO554MmsM8g22NI3U53yst5Z42568qCN4TOhDX9v0i6KNRS >									
258 	//        < 1E-018 limites [ 775779365,801598 ; 787779047,752426 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000012100160B8125787707B >									
260 	//     < RE_Portfolio_XVIII_metadata_line_22_____StarStone_Underwriting_Limited_20250515 >									
261 	//        < i7FMT47fDo9SU6KPOAQQ4ziop57UM5xlNl7367O9G1qyiIGDL9R5Ez12xnfzIT1p >									
262 	//        < 1E-018 limites [ 787779047,752426 ; 844006867,846166 ] >									
263 	//        < 0x00000000000000000000000000000000000000000000125787707B13A6AC48B4 >									
264 	//     < RE_Portfolio_XVIII_metadata_line_23_____StarStone_Underwriting_Limited_20250515 >									
265 	//        < KTBrqZ5QJz5z2XFVX95I52GU3RG841s2393PnOjbZDldq7nX2cqiCCu3673j0PBo >									
266 	//        < 1E-018 limites [ 844006867,846166 ; 879149537,223673 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000013A6AC48B4147823BDEE >									
268 	//     < RE_Portfolio_XVIII_metadata_line_24_____State_Automobile_Mutual_Ins_Co_m_Am_20250515 >									
269 	//        < E0qUajzC4rvAtVcRy7YuDLP3y23679uq59oy930w9x454WHXd76LL1w5jFy1e4tP >									
270 	//        < 1E-018 limites [ 879149537,223673 ; 897116485,555558 ] >									
271 	//        < 0x00000000000000000000000000000000000000000000147823BDEE14E33B211F >									
272 	//     < RE_Portfolio_XVIII_metadata_line_25_____Stockton_Reinsurance_20250515 >									
273 	//        < V856NZHHneT58tC2Jb5h3lTVw371Zi8klzgVyiTvDeUlvJmcBEs64Uc5t7iq0q39 >									
274 	//        < 1E-018 limites [ 897116485,555558 ; 917000848,3652 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000014E33B211F1559C04258 >									
276 	//     < RE_Portfolio_XVIII_metadata_line_26_____Stop_Loss_Finders_20250515 >									
277 	//        < C046yg57HOMk37030k1BYu2n6B93F5OqhFu3CJ40ynimIy3udtbejW4251O53xvf >									
278 	//        < 1E-018 limites [ 917000848,3652 ; 961703331,68288 ] >									
279 	//        < 0x000000000000000000000000000000000000000000001559C04258166432D5E4 >									
280 	//     < RE_Portfolio_XVIII_metadata_line_27_____Summit_Reinsurance_Services_20250515 >									
281 	//        < 8As8OcNS98A3Lfb9Iql4xNZV60cWNA40j2myW55zY3e1Kj73sIglsCdBDR4dEX1n >									
282 	//        < 1E-018 limites [ 961703331,68288 ; 974606073,355426 ] >									
283 	//        < 0x00000000000000000000000000000000000000000000166432D5E416B11ADB5B >									
284 	//     < RE_Portfolio_XVIII_metadata_line_28_____Sun_Life_Financial_Incorporated_20250515 >									
285 	//        < dwfNay7Ra20n4m8MXU2fPexHZ2Ot7S1tZiUkeGpX45z31xh20u6ID71uABDpVi88 >									
286 	//        < 1E-018 limites [ 974606073,355426 ; 1038952670,95378 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000016B11ADB5B1830A3F90B >									
288 	//     < RE_Portfolio_XVIII_metadata_line_29_____Swiss_Re_20250515 >									
289 	//        < 2LspTGa2z97fIdsiYlhOb82g87T8hrqr4w6QlnJNJnnlBh5UGl3LUnb14S43vg41 >									
290 	//        < 1E-018 limites [ 1038952670,95378 ; 1067987755,07711 ] >									
291 	//        < 0x000000000000000000000000000000000000000000001830A3F90B18DDB3FEC7 >									
292 	//     < RE_Portfolio_XVIII_metadata_line_30_____Swiss_Re_Co_AAm_Ap_20250515 >									
293 	//        < N4tKM74LRTt8607x68Tn66JW7y2ANLtMF8UsuoRCicHAjQzT9ToyeD775JnGd68c >									
294 	//        < 1E-018 limites [ 1067987755,07711 ; 1106222537,81319 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000018DDB3FEC719C199A4C9 >									
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
338 	//     < RE_Portfolio_XVIII_metadata_line_31_____Swiss_Re_Group_20250515 >									
339 	//        < 30lm40EO14h66T7Y99y3jW1YM9rhkRxuLr1oj4B328jswAmq1RRLMt2Sy09KuVI2 >									
340 	//        < 1E-018 limites [ 1106222537,81319 ; 1179864061,50206 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000019C199A4C91B7889B0FA >									
342 	//     < RE_Portfolio_XVIII_metadata_line_32_____Swiss_Re_Group_20250515 >									
343 	//        < IjL5R7Ldc0G5LGu536YM825UHhHcvGBOYDm28zvLW7n3ke2cM4gPkZShNP4001f7 >									
344 	//        < 1E-018 limites [ 1179864061,50206 ; 1226576738,58686 ] >									
345 	//        < 0x000000000000000000000000000000000000000000001B7889B0FA1C8EF79476 >									
346 	//     < RE_Portfolio_XVIII_metadata_line_33_____Swiss_Re_Limited_20250515 >									
347 	//        < 1p80mtmA3SddD63c9xJ629A99x2EB4gD6oA3E8qtuNblpq1Mw1YLV0CN4BeGCG8E >									
348 	//        < 1E-018 limites [ 1226576738,58686 ; 1241303333,83469 ] >									
349 	//        < 0x000000000000000000000000000000000000000000001C8EF794761CE6BE94BB >									
350 	//     < RE_Portfolio_XVIII_metadata_line_34_____Taiping_Reinsurance_20250515 >									
351 	//        < iLUfX8QD84zaOt5V6Lk5HAa0J5990MKSfJ842Kj8dRIj161470Vux4xi6FcutBSz >									
352 	//        < 1E-018 limites [ 1241303333,83469 ; 1301562260,12121 ] >									
353 	//        < 0x000000000000000000000000000000000000000000001CE6BE94BB1E4DEA67D0 >									
354 	//     < RE_Portfolio_XVIII_metadata_line_35_____Taiwan_AAm_Central_Reinsurance_Corporation_A_A_20250515 >									
355 	//        < JnlTwog2g5tKB6LLZZ8kND24Vem3XKGZ4D4B1oZwA39Ur66mQMDX5I24Luc43jX9 >									
356 	//        < 1E-018 limites [ 1301562260,12121 ; 1376866194,73293 ] >									
357 	//        < 0x000000000000000000000000000000000000000000001E4DEA67D0200EC31745 >									
358 	//     < RE_Portfolio_XVIII_metadata_line_36_____Taiwan_Central_Reinsurance_Corporation_20250515 >									
359 	//        < 3ie9c602O2LqFjg2v2T29ScHkfdM9l9JPgneE9VKB4A6E2Fkt2OilBKnCye26lXO >									
360 	//        < 1E-018 limites [ 1376866194,73293 ;  ] >									
361 	//        < 0x00000000000000000000000000000000000000000000200EC31745205D7C368D >									
362 	//     < RE_Portfolio_XVIII_metadata_line_37_____Takaful_Re_20250515 >									
363 	//        < H4dkX5DcSl0tRuPJxVq4VzvExo3b0ZWQfLnB8R93Zmq8818OP2qOziDHvT39b09P >									
364 	//        < 1E-018 limites [ 1390073744,89508 ; 1422842159,52193 ] >									
365 	//        < 0x00000000000000000000000000000000000000000000205D7C368D2120CCD884 >									
366 	//     < RE_Portfolio_XVIII_metadata_line_38_____Takaful_Re_BBB_20250515 >									
367 	//        < wkPz4A6Qo4489u4nD8MwIHmeZkv52DI1M468Cd7Tte25vl75R76ppRa3IdbHvLvB >									
368 	//        < 1E-018 limites [ 1422842159,52193 ; 1436353877,40291 ] >									
369 	//        < 0x000000000000000000000000000000000000000000002120CCD8842171561750 >									
370 	//     < RE_Portfolio_XVIII_metadata_line_39_____Talbot_Underwriting_Limited_20250515 >									
371 	//        < 8K36CEZqV6LjSgS5FV0n5E3eoX80HHoMd0ZKkZOjZ2U3cRPQb47q9vML67KWCd8Q >									
372 	//        < 1E-018 limites [ 1436353877,40291 ; 1480239919,72621 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000021715617502276EAE098 >									
374 	//     < RE_Portfolio_XVIII_metadata_line_40_____Talbot_Underwriting_Limited_20250515 >									
375 	//        < mjdquvnO4if5e9yynCHzgh2J48PoWVdCG6319q9fIhV7Ht74tfWk108d27CdeSHb >									
376 	//        < 1E-018 limites [ 1480239919,72621 ; 1495671977,65376 ] >									
377 	//        < 0x000000000000000000000000000000000000000000002276EAE09822D2E65439 >									
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