1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXVIII_II_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXVIII_II_883		"	;
8 		string	public		symbol =	"	RUSS_PFXVIII_II_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		795130213694249000000000000					;	
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
92 	//     < RUSS_PFXVIII_II_metadata_line_1_____RESO_GARANTIA_20231101 >									
93 	//        < Uf4cnMvFFF45IgYPamE6w3Fmz67dcNz08DJUgcw4a1C2Jatd02pY5y696SRolK7h >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000024462833.462173500000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000002553CB >									
96 	//     < RUSS_PFXVIII_II_metadata_line_2_____RESO_CREDIT_BANK_20231101 >									
97 	//        < 2dZfsPs3oJZ9UBRnwFCUABGNgwsTz3j900KCQ0i5VK6xI2d98HE3pcv2lQWBGa6h >									
98 	//        <  u =="0.000000000000000001" : ] 000000024462833.462173500000000000 ; 000000040080661.239194800000000000 ] >									
99 	//        < 0x0000000000000000000000000000000000000000000000000000000002553CB0 >									
100 	//     < RUSS_PFXVIII_II_metadata_line_3_____RESO_LEASING_20231101 >									
101 	//        < R80W37xB9j1IMW2520f79M1xOoNqjuoeLY32LN7QN773N24sd0axs54T7s3qVJnH >									
102 	//        <  u =="0.000000000000000001" : ] 000000040080661.239194800000000000 ; 000000055700064.774295100000000000 ] >									
103 	//        < 0x000000000000000000000000000000000000000000000000000000000054FDD6 >									
104 	//     < RUSS_PFXVIII_II_metadata_line_4_____OSZH_RESO_GARANTIA_20231101 >									
105 	//        < Ae9bPa07e585FgyX1YQ8Q21T0kghQ4A352rL332FEj0SddlLN0e66DOuQJYA5YeM >									
106 	//        <  u =="0.000000000000000001" : ] 000000055700064.774295100000000000 ; 000000077684777.044720600000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000054FDD676899E >									
108 	//     < RUSS_PFXVIII_II_metadata_line_5_____STRAKHOVOI_SINDIKAT_20231101 >									
109 	//        < 9Yh5Y19rqApEYrF2ftQ40iM9T36jiRA0Cd2j75431npW6dLJ4b9vwf4CS5y9p4TG >									
110 	//        <  u =="0.000000000000000001" : ] 000000077684777.044720600000000000 ; 000000096379150.590942200000000000 ] >									
111 	//        < 0x000000000000000000000000000000000000000000000000000076899E93101B >									
112 	//     < RUSS_PFXVIII_II_metadata_line_6_____RESO_FINANCIAL_MARKETS_20231101 >									
113 	//        < 1lEL4qNnMOoSS88Q8Dbz3EsJR02v8yh1x6crvkB2rAMf2t2P2lVU4ZSIZLbAN64Q >									
114 	//        <  u =="0.000000000000000001" : ] 000000096379150.590942200000000000 ; 000000114999217.607674000000000000 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000000000093101BAF7992 >									
116 	//     < RUSS_PFXVIII_II_metadata_line_7_____LIPETSK_INSURANCE_CO_CHANCE_20231101 >									
117 	//        < pJjwS27gakU4S9ulkkerPJSrnd10STfixCf3G1vB0MFKMj8qxTR0VKBR2sm5N8Nj >									
118 	//        <  u =="0.000000000000000001" : ] 000000114999217.607674000000000000 ; 000000138139765.905924000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000AF7992D2C8D9 >									
120 	//     < RUSS_PFXVIII_II_metadata_line_8_____ALVENA_RESO_GROUP_20231101 >									
121 	//        < ThKC9A6S3LP7i0Sbk4DuZ13mQy2b4M7E3Ax0VS0IvK7yCj4oat79cEf18yN49573 >									
122 	//        <  u =="0.000000000000000001" : ] 000000138139765.905924000000000000 ; 000000153689924.263384000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000D2C8D9EA8320 >									
124 	//     < RUSS_PFXVIII_II_metadata_line_9_____NADEZHNAYA_LIFE_INSURANCE_CO_20231101 >									
125 	//        < c70642450Zz9CG5IFSv6rF4m4z6ni7NW225QL5RJQ756OG2F9Y232F4dtqoJ0k6D >									
126 	//        <  u =="0.000000000000000001" : ] 000000153689924.263384000000000000 ; 000000169096979.663410000000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000000EA83201020582 >									
128 	//     < RUSS_PFXVIII_II_metadata_line_10_____MSK_URALSIB_20231101 >									
129 	//        < 6749nXp51I7NJ5yDA1DhgNXtK56Y0N53Jc09uFz7777y3yt0Qr2L103wJQ0Hv43A >									
130 	//        <  u =="0.000000000000000001" : ] 000000169096979.663410000000000000 ; 000000186953265.657495000000000000 ] >									
131 	//        < 0x00000000000000000000000000000000000000000000000000102058211D449F >									
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
174 	//     < RUSS_PFXVIII_II_metadata_line_11_____RESO_1_ORG_20231101 >									
175 	//        < 81gShu1M6N0QPUxf28PkFu01G6kW9juoAI8qh3p6SB76Z0v4639Ij8YcKBkkhDtw >									
176 	//        <  u =="0.000000000000000001" : ] 000000186953265.657495000000000000 ; 000000207381258.421294000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000011D449F13C704E >									
178 	//     < RUSS_PFXVIII_II_metadata_line_12_____RESO_1_DAO_20231101 >									
179 	//        < JSnb5Pq1E82SdTwR8Wru4Sem440r6r7vMP867X46ccd2f6eNs0h1o9Ab4cUX5T3b >									
180 	//        <  u =="0.000000000000000001" : ] 000000207381258.421294000000000000 ; 000000229601872.848165000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000013C704E15E583B >									
182 	//     < RUSS_PFXVIII_II_metadata_line_13_____RESO_1_DAOPI_20231101 >									
183 	//        < z5U0y9Q26E62C4E98eEjaH6JEAT7CUp0v6fSPP75tJ8vLo968p31uTWEh3m7b99Z >									
184 	//        <  u =="0.000000000000000001" : ] 000000229601872.848165000000000000 ; 000000249158990.298588000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000015E583B17C2FBB >									
186 	//     < RUSS_PFXVIII_II_metadata_line_14_____RESO_1_DAC_20231101 >									
187 	//        < 29TvdI5W3iwFUQI4CJhmG77UikF9vj4S2SUz8qjIxoF4114xLYK9J6v9O1HjpkHv >									
188 	//        <  u =="0.000000000000000001" : ] 000000249158990.298588000000000000 ; 000000267268461.635387000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000017C2FBB197D1BE >									
190 	//     < RUSS_PFXVIII_II_metadata_line_15_____RESO_1_BIMI_20231101 >									
191 	//        < CW24AT2KN85DRRdQ06M22jOBv6V893got70Y59jHgFIsH9BXLc61mr2j2zbF1YmF >									
192 	//        <  u =="0.000000000000000001" : ] 000000267268461.635387000000000000 ; 000000283910483.477486000000000000 ] >									
193 	//        < 0x00000000000000000000000000000000000000000000000000197D1BE1B13688 >									
194 	//     < RUSS_PFXVIII_II_metadata_line_16_____RESO_2_ORG_20231101 >									
195 	//        < hW39Q90yjqEyid3CTy5AvA5Ccg6o2Zc7Prk43r8m0DP6vRaAtj5cm5AfUL70Z4uA >									
196 	//        <  u =="0.000000000000000001" : ] 000000283910483.477486000000000000 ; 000000300730586.033689000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000001B136881CAE0E3 >									
198 	//     < RUSS_PFXVIII_II_metadata_line_17_____RESO_2_DAO_20231101 >									
199 	//        < X2u7HfSG198hg5Pw3v57983igHpw20b3Za2eojQx0AXgc6d90J8KwPOv434hp4lz >									
200 	//        <  u =="0.000000000000000001" : ] 000000300730586.033689000000000000 ; 000000324534186.197758000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000001CAE0E31EF332B >									
202 	//     < RUSS_PFXVIII_II_metadata_line_18_____RESO_2_DAOPI_20231101 >									
203 	//        < fh4dIZs0vV4bos4QJL9sjx8P21c73FGk9662u25PcxhB8IZy7X3a106h5eqaYRpn >									
204 	//        <  u =="0.000000000000000001" : ] 000000324534186.197758000000000000 ; 000000343237910.508852000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000001EF332B20BBD4F >									
206 	//     < RUSS_PFXVIII_II_metadata_line_19_____RESO_2_DAC_20231101 >									
207 	//        < Vi1dNJEJ9G4BO73sb7wJWP63ODxJmjD4iN64F64gd5S58nWq3GRG47NWSdm9Lvd3 >									
208 	//        <  u =="0.000000000000000001" : ] 000000343237910.508852000000000000 ; 000000361146761.234775000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000000020BBD4F22710F4 >									
210 	//     < RUSS_PFXVIII_II_metadata_line_20_____RESO_2_BIMI_20231101 >									
211 	//        < pvhgG4tKX8Vcjt6uka7zy549IWx1HTBiDsntA5etRimdeSP0aE7OYLk3dxqV17f9 >									
212 	//        <  u =="0.000000000000000001" : ] 000000361146761.234775000000000000 ; 000000380963774.997204000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000022710F42454DF9 >									
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
256 	//     < RUSS_PFXVIII_II_metadata_line_21_____RESO_PENSII_1_ORG_20231101 >									
257 	//        < 9or579s3rSsP7Q4IPmKqLbbuSlhNo2EYA0KA5v406K6gJOS8yc6ROmFvZZ8Q01gt >									
258 	//        <  u =="0.000000000000000001" : ] 000000380963774.997204000000000000 ; 000000404006042.134111000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000002454DF926876DC >									
260 	//     < RUSS_PFXVIII_II_metadata_line_22_____RESO_PENSII_1_DAO_20231101 >									
261 	//        < LvOvS7i546d4dT35a18bhTl7F181Q6TpNi7Auh3at6P0r56xk1ioEWjZOeKTxb7O >									
262 	//        <  u =="0.000000000000000001" : ] 000000404006042.134111000000000000 ; 000000423706727.178422000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000026876DC2868671 >									
264 	//     < RUSS_PFXVIII_II_metadata_line_23_____RESO_PENSII_1_DAOPI_20231101 >									
265 	//        < K31ez6qu0ON0dH4M3YwSg4QjNl8YMHY5BiO3STaD68pJI2Yg23Joj38I52YCS83q >									
266 	//        <  u =="0.000000000000000001" : ] 000000423706727.178422000000000000 ; 000000447110774.265731000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000028686712AA3CA5 >									
268 	//     < RUSS_PFXVIII_II_metadata_line_24_____RESO_PENSII_1_DAC_20231101 >									
269 	//        < cQ0V5FvkEr9DSbJ665c699O79Q044T4VHo3upnwg2yU2Ndeq956wPqfz6B3iB283 >									
270 	//        <  u =="0.000000000000000001" : ] 000000447110774.265731000000000000 ; 000000471167178.223785000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000002AA3CA52CEF1AE >									
272 	//     < RUSS_PFXVIII_II_metadata_line_25_____RESO_PENSII_1_BIMI_20231101 >									
273 	//        < Da1CUCrYaRO2plJNN71JpmC0oo3tLVTP22R2r1NaoVM1yiGOkG8lcv2fueV0Ibux >									
274 	//        <  u =="0.000000000000000001" : ] 000000471167178.223785000000000000 ; 000000489170182.050758000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002CEF1AE2EA6A1A >									
276 	//     < RUSS_PFXVIII_II_metadata_line_26_____RESO_PENSII_2_ORG_20231101 >									
277 	//        < 7brcrmg8J83YzyCGO374578m3b079M90Kj7NG6EwD1tJd631xVjbNSHn4Yx43zNi >									
278 	//        <  u =="0.000000000000000001" : ] 000000489170182.050758000000000000 ; 000000510140558.971684000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000002EA6A1A30A69A8 >									
280 	//     < RUSS_PFXVIII_II_metadata_line_27_____RESO_PENSII_2_DAO_20231101 >									
281 	//        < I2teQT5H5D88oz708Q37hfuNOc7LCT4diTEG8mq66x4LBY8zn8YXg2kFW17Lx4Ch >									
282 	//        <  u =="0.000000000000000001" : ] 000000510140558.971684000000000000 ; 000000531862710.646491000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000030A69A832B8EDF >									
284 	//     < RUSS_PFXVIII_II_metadata_line_28_____RESO_PENSII_2_DAOPI_20231101 >									
285 	//        < mr5r36wgXGR3F4uf7gCEgVU6GE3b9w3B4nu0520A1jjsrzFhb12Baq9417IWEQKo >									
286 	//        <  u =="0.000000000000000001" : ] 000000531862710.646491000000000000 ; 000000553304695.022506000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000032B8EDF34C46A6 >									
288 	//     < RUSS_PFXVIII_II_metadata_line_29_____RESO_PENSII_2_DAC_20231101 >									
289 	//        < m6l5a8465WA7jVB0RdlmVKTEZY359W4w4o9e4o1C6e3fAuq231fa893gL4vWjvdE >									
290 	//        <  u =="0.000000000000000001" : ] 000000553304695.022506000000000000 ; 000000573992994.153912000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000034C46A636BD803 >									
292 	//     < RUSS_PFXVIII_II_metadata_line_30_____RESO_PENSII_2_BIMI_20231101 >									
293 	//        < 2l9Xlhm38vETp07QbSNdmuOjLKs4Eqz72gD8vYlJxZX10XXOA3DUAy328KD1vjBW >									
294 	//        <  u =="0.000000000000000001" : ] 000000573992994.153912000000000000 ; 000000596806399.535931000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000036BD80338EA780 >									
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
338 	//     < RUSS_PFXVIII_II_metadata_line_31_____MIKA_ORG_20231101 >									
339 	//        < 9G6XZL8PF2FxTfrn331N46NQ8i5TN8x2bt2290gZscZ4lrE0kDeYInric70WB4Uv >									
340 	//        <  u =="0.000000000000000001" : ] 000000596806399.535931000000000000 ; 000000617777065.796118000000000000 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000000000038EA7803AEA72B >									
342 	//     < RUSS_PFXVIII_II_metadata_line_32_____MIKA_DAO_20231101 >									
343 	//        < 8645Z24957hB3700N9G7p91pW5j86vbZ417o42P7oq7Tux664WbWPwg7cOEb9EwC >									
344 	//        <  u =="0.000000000000000001" : ] 000000617777065.796118000000000000 ; 000000635151121.685211000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000003AEA72B3C929E8 >									
346 	//     < RUSS_PFXVIII_II_metadata_line_33_____MIKA_DAOPI_20231101 >									
347 	//        < X2pX61WCG8102AK0Fb9nuxa4b55N7VyTs7UgrxDhO809uF5xB3anvlcreJJpZ68p >									
348 	//        <  u =="0.000000000000000001" : ] 000000635151121.685211000000000000 ; 000000656901820.437634000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000003C929E83EA5A46 >									
350 	//     < RUSS_PFXVIII_II_metadata_line_34_____MIKA_DAC_20231101 >									
351 	//        < GlM2c1ayEQQ7kGSEEb30Z6bpf0S2nr2iWHb43q666mQ1ay3TS2lpwZ3U1D1NJS30 >									
352 	//        <  u =="0.000000000000000001" : ] 000000656901820.437634000000000000 ; 000000677418672.579403000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000003EA5A46409A8AB >									
354 	//     < RUSS_PFXVIII_II_metadata_line_35_____MIKA_BIMI_20231101 >									
355 	//        < gQD00APcp8QrrOeL6WgdA8dYYJ8a7N8HtHuL531aBK962N1i50h64P6LEC39xGoC >									
356 	//        <  u =="0.000000000000000001" : ] 000000677418672.579403000000000000 ; 000000696036626.747396000000000000 ] >									
357 	//        < 0x00000000000000000000000000000000000000000000000000409A8AB426114F >									
358 	//     < RUSS_PFXVIII_II_metadata_line_36_____MIKA_PENSII_ORG_20231101 >									
359 	//        < W3E2Fs7r9t9X5A3vJX1f3gHKxZhjwI2jBT7U7MJ5x7BsCt54XzJW7PUc39QCwZ2G >									
360 	//        <  u =="0.000000000000000001" : ] 000000696036626.747396000000000000 ; 000000718440989.204176000000000000 ] >									
361 	//        < 0x00000000000000000000000000000000000000000000000000426114F4484103 >									
362 	//     < RUSS_PFXVIII_II_metadata_line_37_____MIKA_PENSII_DAO_20231101 >									
363 	//        < 2fOZLwID7NXE7BN928Pe82435437Dgo0OTiSd01yE90KuyuUSnAgfGkAyvS6m592 >									
364 	//        <  u =="0.000000000000000001" : ] 000000718440989.204176000000000000 ; 000000735581893.426874000000000000 ] >									
365 	//        < 0x00000000000000000000000000000000000000000000000000448410346268AD >									
366 	//     < RUSS_PFXVIII_II_metadata_line_38_____MIKA_PENSII_DAOPI_20231101 >									
367 	//        < SgI5c5c42qlveL5xnpw1vte0A23P09538lxndEtmMTd9CVNUIHx67scB6GhE09R0 >									
368 	//        <  u =="0.000000000000000001" : ] 000000735581893.426874000000000000 ; 000000758572309.773976000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000046268AD4857D4F >									
370 	//     < RUSS_PFXVIII_II_metadata_line_39_____MIKA_PENSII_DAC_20231101 >									
371 	//        < x8igzZ7lQ7q49XwLCeh7e602Gc4V1tl2QAe9QaTohkj1kTA51212HU5N4FaIMdg7 >									
372 	//        <  u =="0.000000000000000001" : ] 000000758572309.773976000000000000 ; 000000774162834.863407000000000000 ] >									
373 	//        < 0x000000000000000000000000000000000000000000000000004857D4F49D475B >									
374 	//     < RUSS_PFXVIII_II_metadata_line_40_____MIKA_PENSII_BIMI_20231101 >									
375 	//        < 440n29RJcD0HxI8xYc49MhNswD6w9jJS7ag1370eXDqO1MYtwdvCd832y6aKZ41u >									
376 	//        <  u =="0.000000000000000001" : ] 000000774162834.863407000000000000 ; 000000795130213.694249000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000049D475B4BD45BD >									
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