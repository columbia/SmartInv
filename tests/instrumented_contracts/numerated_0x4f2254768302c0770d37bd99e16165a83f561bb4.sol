1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	SEAPORT_Portfolio_VII_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	SEAPORT_Portfolio_VII_883		"	;
8 		string	public		symbol =	"	SEAPORT883VII		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		831660039583872000000000000					;	
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
92 	//     < SEAPORT_Portfolio_VII_metadata_line_1_____Novorossiysk Port of Novorossiysk_Port_Spe_Value_20230515 >									
93 	//        < a4767VTR3x9A4bC0FphnCmOyY8JSnYgoKvHDW78uEd6VRKEFw2xmw009r9J0Hy5b >									
94 	//        < 1E-018 limites [ 1E-018 ; 21856728,6061468 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000008246BA90 >									
96 	//     < SEAPORT_Portfolio_VII_metadata_line_2_____Novorossiysk_Port_Spe_Value_20230515 >									
97 	//        < W22SwHleW8b0Izq88BlL1G6p584dc65RuC0M1vz8II311t8Qu7fj0eHL8QEZlMk8 >									
98 	//        < 1E-018 limites [ 21856728,6061468 ; 50306307,7954406 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000008246BA9012BD9576F >									
100 	//     < SEAPORT_Portfolio_VII_metadata_line_3_____Novosibirsk_Port_Spe_Value_20230515 >									
101 	//        < qflz7L412r5bC2h51RVQBuKlM4hIdhSl61FxgJ23IX3n3H9k7GmgtR6W7T713vwE >									
102 	//        < 1E-018 limites [ 50306307,7954406 ; 65899592,0380108 ] >									
103 	//        < 0x000000000000000000000000000000000000000000000012BD9576F188CACE17 >									
104 	//     < SEAPORT_Portfolio_VII_metadata_line_4_____Olga_Port_Authority_20230515 >									
105 	//        < WVhtTL79oeTCzQlXHc6y419k884n0dTa2v0Ks2gC071g8WlNdN3Y7dZFk8C66cK0 >									
106 	//        < 1E-018 limites [ 65899592,0380108 ; 81408748,4855109 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000188CACE171E53BE654 >									
108 	//     < SEAPORT_Portfolio_VII_metadata_line_5_____Olga_Port_Authority_20230515 >									
109 	//        < p2SWS701m7q44sXHYH5XS4W43LXDmsE5124xY0h8y93y1lIiS6o2b51xkd3cVmal >									
110 	//        < 1E-018 limites [ 81408748,4855109 ; 96323880,8191582 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000001E53BE65423E2295E5 >									
112 	//     < SEAPORT_Portfolio_VII_metadata_line_6_____Omsk_Port_Spe_Value_20230515 >									
113 	//        < 8s4AJ0567uy40hX7d2FEF0MKeWUoMw5WZ5F3n5BS5rjljKl93wl7QQU70BF4Dn4u >									
114 	//        < 1E-018 limites [ 96323880,8191582 ; 118094022,026032 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000023E2295E52BFE52F4E >									
116 	//     < SEAPORT_Portfolio_VII_metadata_line_7_____Onega Port of Onega_Port_Spe_Value_20230515 >									
117 	//        < vi4BQiM1x32Lh0PJY6jg9TQ46IYc47DTKnfzn194JQnPuXw98b8LCG7Eh98Uw0w2 >									
118 	//        < 1E-018 limites [ 118094022,026032 ; 138307730,940671 ] >									
119 	//        < 0x00000000000000000000000000000000000000000000002BFE52F4E33860DB5A >									
120 	//     < SEAPORT_Portfolio_VII_metadata_line_8_____Onega_Port_Authority_20230515 >									
121 	//        < Z81nJgH6pRkG7VkaiX61hnb1R5HS759Q2k4DT8nje88z1Jh5MUQjK2iq94s0oYop >									
122 	//        < 1E-018 limites [ 138307730,940671 ; 163089132,802004 ] >									
123 	//        < 0x000000000000000000000000000000000000000000000033860DB5A3CC164674 >									
124 	//     < SEAPORT_Portfolio_VII_metadata_line_9_____Onega_Port_Authority_20230515 >									
125 	//        < 7rt9rb62nIdwgr4s4DVv3mSR6w37hNl9d3Ez6T2f0K7te9Nai0f300K4H2Vt9L9n >									
126 	//        < 1E-018 limites [ 163089132,802004 ; 188060620,049932 ] >									
127 	//        < 0x00000000000000000000000000000000000000000000003CC164674460EDBDA8 >									
128 	//     < SEAPORT_Portfolio_VII_metadata_line_10_____Perm_Port_Spe_Value_20230515 >									
129 	//        < dLAjvq95O8Nwt263Eeo8yiWqFF3i9qS50F45B3Ipm0u77EkYLE6Sq91hTiaNNe1c >									
130 	//        < 1E-018 limites [ 188060620,049932 ; 209312617,242435 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000460EDBDA84DF99B710 >									
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
174 	//     < SEAPORT_Portfolio_VII_metadata_line_11_____Petropavlovsk_Kamchatskiy_Port_Spe_Value_20230515 >									
175 	//        < Z0W1Zn1UpeJlv2J5qZpndoozFPUcNH9w788ruCssIu7dVqa9J8oF54anOd6B58IF >									
176 	//        < 1E-018 limites [ 209312617,242435 ; 232541937,723194 ] >									
177 	//        < 0x00000000000000000000000000000000000000000000004DF99B71056A0ED860 >									
178 	//     < SEAPORT_Portfolio_VII_metadata_line_12_____Petropavlovsk_Kamchatsky Port of Petropavlovsk_Kamchatsky_Port_Spe_Value_20230515 >									
179 	//        < 7Q7tL2tRz7V7rK1jSHMWfof6OKhBt93TJpMOM1k1ci6Hr0gC6wdaoh0DLfpUVQQR >									
180 	//        < 1E-018 limites [ 232541937,723194 ; 250320165,082122 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000056A0ED8605D4064470 >									
182 	//     < SEAPORT_Portfolio_VII_metadata_line_13_____Pevek Port of Pevek_Port_Spe_Value_20230515 >									
183 	//        < lM0URV9T165xq9i399aWCUA2CmFV1xUKhiYw49r8m6R73gc0auTz0frc84grVBk4 >									
184 	//        < 1E-018 limites [ 250320165,082122 ; 266613342,483114 ] >									
185 	//        < 0x00000000000000000000000000000000000000000000005D406447063523AEDC >									
186 	//     < SEAPORT_Portfolio_VII_metadata_line_14_____Poronaysk Port of Poronaysk_Port_Spe_Value_20230515 >									
187 	//        < IGdGhCI30bxSTk8h67qk3TrQOKpPgyvqQf50vV3BW34P1fST0ja9H0jL2bSyCM3l >									
188 	//        < 1E-018 limites [ 266613342,483114 ; 292395631,853538 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000063523AEDC6CED055A5 >									
190 	//     < SEAPORT_Portfolio_VII_metadata_line_15_____Poronaysk_Port_Authority_20230515 >									
191 	//        < w5Ixsp0Fn766S1Dg72s5LZBUx9fRqO2ZAxMqPe3RtF9H22YGvXf7Amw3N15oq5I5 >									
192 	//        < 1E-018 limites [ 292395631,853538 ; 307938190,387152 ] >									
193 	//        < 0x00000000000000000000000000000000000000000000006CED055A572B746592 >									
194 	//     < SEAPORT_Portfolio_VII_metadata_line_16_____Poronaysk_Port_Authority_20230515 >									
195 	//        < 1V0W8K06fgUeSog7P5igR39Vtics3hpqdiNwK271q1636Cq0B8mHMj9KkQ7FQc3H >									
196 	//        < 1E-018 limites [ 307938190,387152 ; 328597011,374162 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000072B7465927A6974185 >									
198 	//     < SEAPORT_Portfolio_VII_metadata_line_17_____Port_Authority_of_St_Petersburg_20230515 >									
199 	//        < 56L5oIjhS92Vo6TG81JY3OsB9N3g43S5kaIRH17QmS060UVX9ndux59F6g9gK3S9 >									
200 	//        < 1E-018 limites [ 328597011,374162 ; 351529374,981334 ] >									
201 	//        < 0x00000000000000000000000000000000000000000000007A697418582F47440E >									
202 	//     < SEAPORT_Portfolio_VII_metadata_line_18_____Port_Authority_of_St_Petersburg_20230515 >									
203 	//        < i6mgr4X98mc9kaw2hYVesiWZAO9DXapfWs9fic2h7puq1t2zi39GT0IG693z5aTD >									
204 	//        < 1E-018 limites [ 351529374,981334 ; 367758983,166911 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000082F47440E89003AEC0 >									
206 	//     < SEAPORT_Portfolio_VII_metadata_line_19_____Posyet Port of Posyet_Port_Spe_Value_20230515 >									
207 	//        < 0IU9pLicZ7700v2ojnJP1ige2K998CHOx4hc237wTn0jQf3I0ETc2y96dg7FY39P >									
208 	//        < 1E-018 limites [ 367758983,166911 ; 394365940,535429 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000089003AEC092E9AAD79 >									
210 	//     < SEAPORT_Portfolio_VII_metadata_line_20_____Primorsk Port of Primorsk_Port_Spe_Value_20230515 >									
211 	//        < b0cOUQ91ytt05KBesDzV6tpTuEL5FBq8n1RI8363V7I6lXlc9wbEXnruAs2Ya6bu >									
212 	//        < 1E-018 limites [ 394365940,535429 ; 413157508,198651 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000092E9AAD7999E9C5597 >									
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
256 	//     < SEAPORT_Portfolio_VII_metadata_line_21_____Primorsk_Port_Authority_20230515 >									
257 	//        < CS5m3U474NTI7Wv4bJAJnxFT78I4Eam3VUDW9M5QQ4e5u6QFS3mHT4Da52OCl2KI >									
258 	//        < 1E-018 limites [ 413157508,198651 ; 430858723,09083 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000099E9C5597A081E3EA9 >									
260 	//     < SEAPORT_Portfolio_VII_metadata_line_22_____Providenija Port of Providenija_Port_Spe_Value_20230515 >									
261 	//        < 0DCU7Gld08JOOs0oxK3hO1344Jjrt2b6N2VA2EZBkHw7ruE4AX3QTOVCgzG97X5I >									
262 	//        < 1E-018 limites [ 430858723,09083 ; 449919869,657276 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000A081E3EA9A79BB3F09 >									
264 	//     < SEAPORT_Portfolio_VII_metadata_line_23_____Rostov_on_Don Port of Rostov_on_Don_Port_Spe_Value_20230515 >									
265 	//        < 1P16E21OHmR4EwGCMojvH0gm56dNYFvmp8FdUoqxuCY7FQ28Yx67QNZ5J2ehx933 >									
266 	//        < 1E-018 limites [ 449919869,657276 ; 468278197,328073 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000A79BB3F09AE727D4C8 >									
268 	//     < SEAPORT_Portfolio_VII_metadata_line_24_____Rostov_on_Don_Port_Spe_Value_20230515 >									
269 	//        < 1k0hmZ6a9G1eqk9QZG0inpM9z70Bb4OUMr796GlTJaPrwvLI95v98vf6QOSmPepV >									
270 	//        < 1E-018 limites [ 468278197,328073 ; 489414703,320786 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000AE727D4C8B65239470 >									
272 	//     < SEAPORT_Portfolio_VII_metadata_line_25_____Ryazan_Port_Spe_Value_20230515 >									
273 	//        < E2oSXi32DF2L21FJ1KiZzHn8FvLI0H4Nymz54DaKs3SPVD7332MAfc1y5X2iKv88 >									
274 	//        < 1E-018 limites [ 489414703,320786 ; 507850330,152042 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000000B65239470BD3061D2B >									
276 	//     < SEAPORT_Portfolio_VII_metadata_line_26_____Saint Petersburg Port of Saint Petersburg_Port_Spe_Value_20230515 >									
277 	//        < bL727R3kzgWeZGQo1PYp2uTDeh1T02hw7lW3bhKSaDExaG95vkx6vbD9kJ0T0Ltu >									
278 	//        < 1E-018 limites [ 507850330,152042 ; 533519909,795645 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000000BD3061D2BC6C06C8B7 >									
280 	//     < SEAPORT_Portfolio_VII_metadata_line_27_____Salekhard_Port_Spe_Value_20230515 >									
281 	//        < Yo3WYvX1B2L6GU56Umi7Jl8E4gH37p4g4C6nks5o7IWWxZ0ul4Pk2czHdLZ0Qo59 >									
282 	//        < 1E-018 limites [ 533519909,795645 ; 560105200,261919 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000C6C06C8B7D0A7CB7CE >									
284 	//     < SEAPORT_Portfolio_VII_metadata_line_28_____Samara_Port_Spe_Value_20230515 >									
285 	//        < 85oN7x8ZxQMwcgbMR08eaF7fX8W6dGOr8069I5r2H23819Gvc0LZqBAk61lM4rM4 >									
286 	//        < 1E-018 limites [ 560105200,261919 ; 588224726,320107 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000D0A7CB7CEDB217B5AC >									
288 	//     < SEAPORT_Portfolio_VII_metadata_line_29_____Saratov_Port_Spe_Value_20230515 >									
289 	//        < V0i2U8Ki1Id9I1wNlPe6fK5hWeLA2BuMkn9407OLS8bN3T243Q2RH01AZ24yTqMF >									
290 	//        < 1E-018 limites [ 588224726,320107 ; 603091217,912931 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000DB217B5ACE0AB42CF3 >									
292 	//     < SEAPORT_Portfolio_VII_metadata_line_30_____Sarepta_Port_Spe_Value_20230515 >									
293 	//        < eDcOD7wpgXcC4t1S7W69r8g838H5BB00Q381zEIAG4h7x9Kf1k48I9radZml0zM5 >									
294 	//        < 1E-018 limites [ 603091217,912931 ; 625771450,288981 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000E0AB42CF3E91E376B8 >									
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
338 	//     < SEAPORT_Portfolio_VII_metadata_line_31_____Sea_Port_Hatanga_20230515 >									
339 	//        < l1AcUyHV15n4eAVB4F0PTH8eY7Z0Yz8myHt5mTD4XX117RfPycEUsQbe8ek2K1it >									
340 	//        < 1E-018 limites [ 625771450,288981 ; 645935703,401499 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000000E91E376B8F0A13AC18 >									
342 	//     < SEAPORT_Portfolio_VII_metadata_line_32_____Sea_Port_Zarubino_20230515 >									
343 	//        < hvvLX226yn2JUB1HH787S9J8U7p11T1Tm2733aMFhe7o210sL6Z5BhP2VQ9CJ3DA >									
344 	//        < 1E-018 limites [ 645935703,401499 ; 667753217,080227 ] >									
345 	//        < 0x0000000000000000000000000000000000000000000000F0A13AC18F8C1E8E60 >									
346 	//     < SEAPORT_Portfolio_VII_metadata_line_33_____Serpukhov_Port_Spe_Value_20230515 >									
347 	//        < 29Adz5FkJSKHTR9K512XHqP048817ksCGbwfm9h5zGNZle4eFhhWd61G96pG8z9W >									
348 	//        < 1E-018 limites [ 667753217,080227 ; 688826896,09959 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000F8C1E8E601009BA703D >									
350 	//     < SEAPORT_Portfolio_VII_metadata_line_34_____Sevastopol_Marine_Trade_Port_20230515 >									
351 	//        < 4f0I7f71sjyS5nrH6zGhcjMF5GFcxcsBxZRJLnwg9GUmHO8I066tPNX2DScztvv2 >									
352 	//        < 1E-018 limites [ 688826896,09959 ; 703823462,631833 ] >									
353 	//        < 0x000000000000000000000000000000000000000000001009BA703D10631D620B >									
354 	//     < SEAPORT_Portfolio_VII_metadata_line_35_____Sevastopol_Port_Spe_Value_20230515 >									
355 	//        < 4h8AG71H0R2s2P1jvGV7x2qMB29rzO80d9Abj098nH80P46Ceb15Op66AwjP483O >									
356 	//        < 1E-018 limites [ 703823462,631833 ; 724799539,220132 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000010631D620B10E02455F6 >									
358 	//     < SEAPORT_Portfolio_VII_metadata_line_36_____Severodvinsk_Port_Spe_Value_20230515 >									
359 	//        < 9995Hf928BXZe5Gh6iufi6UYfiBJPX5H7910dsw21pSrqnHEDO12mwVdz3tlm863 >									
360 	//        < 1E-018 limites [ 724799539,220132 ;  ] >									
361 	//        < 0x0000000000000000000000000000000000000000000010E02455F611808D7743 >									
362 	//     < SEAPORT_Portfolio_VII_metadata_line_37_____Sochi Port of Sochi_Port_Spe_Value_20230515 >									
363 	//        < JZ0TZ4925wdBK91cfXe0Wd7oOS2QXTHeYxQTv4tx779Mfa0Mgho65zNo7qSnIvR1 >									
364 	//        < 1E-018 limites [ 751711982,87324 ; 771591961,494733 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000011808D774311F70BE7E9 >									
366 	//     < SEAPORT_Portfolio_VII_metadata_line_38_____Sochi_Port_Authority_20230515 >									
367 	//        < ID0LIQ7f8Nn3t906Pk9dkXD1Pj9gI1o75ihcWYEp4Aq3uvB6EqB716mSH4Xqt4Kt >									
368 	//        < 1E-018 limites [ 771591961,494733 ; 797186023,890109 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000011F70BE7E9128F995889 >									
370 	//     < SEAPORT_Portfolio_VII_metadata_line_39_____Sochi_Port_Spe_Value_20230515 >									
371 	//        < tXn54eD5tYoIXpWQv43AkY343TQ0k0QwS60J6UO41l42UAeKBW2ZcZxz0OuBTfpV >									
372 	//        < 1E-018 limites [ 797186023,890109 ; 816321780,430821 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000128F9958891301A8316F >									
374 	//     < SEAPORT_Portfolio_VII_metadata_line_40_____Solombala_Port_Spe_Value_20230515 >									
375 	//        < 1YLgFQ0yJ3hz1w3i65gAVG910dHcWcDeBlFdN74mI9MA695AR3cqTCNLMExuu07K >									
376 	//        < 1E-018 limites [ 816321780,430821 ; 831660039,583872 ] >									
377 	//        < 0x000000000000000000000000000000000000000000001301A8316F135D1484EA >									
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