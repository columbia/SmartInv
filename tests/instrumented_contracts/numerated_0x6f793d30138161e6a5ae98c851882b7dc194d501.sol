1 pragma solidity 		^0.4.25	;						
2 										
3 	contract	EUROSIBENERGO_PFXXI_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	EUROSIBENERGO_PFXXI_I_883		"	;
8 		string	public		symbol =	"	EUROSIBENERGO_PFXXI_I_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		597902679176595000000000000					;	
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
92 	//     < EUROSIBENERGO_PFXXI_I_metadata_line_1_____Irkutskenergo_JSC_20220321 >									
93 	//        < 9d4J1uuTPV0NLcg01HmE35nX8oY45Dc0WFu18N3g3TmxY77KJ13oicrMUiHcS5vn >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000015917430.145098400000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000001849BF >									
96 	//     < EUROSIBENERGO_PFXXI_I_metadata_line_2_____Irkutskenergo_PCI_20220321 >									
97 	//        < 8hc5XM6t2b9sgP2yy26Tw2zL7dplRgx9512HEM5sW2DvNa94J5q0nm4v9yAjIIjI >									
98 	//        <  u =="0.000000000000000001" : ] 000000015917430.145098400000000000 ; 000000031554741.996618700000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000001849BF302612 >									
100 	//     < EUROSIBENERGO_PFXXI_I_metadata_line_3_____Irkutskenergo_PCI_Bratsk_20220321 >									
101 	//        < 6qYcu04Vayg4qCFuaRL004Jmyd7FGlImG3Kb1y4bpq276OWtotFeA5DKaW3q0z3s >									
102 	//        <  u =="0.000000000000000001" : ] 000000031554741.996618700000000000 ; 000000046245219.370264600000000000 ] >									
103 	//        < 0x000000000000000000000000000000000000000000000000000030261246908A >									
104 	//     < EUROSIBENERGO_PFXXI_I_metadata_line_4_____Irkutskenergo_PCI_Ust_Ilimsk_20220321 >									
105 	//        < Ze8Cto3hzexJSEQOu8Q7j4qK19UQ1p5fB9S2zm2Y3Y1F9aEj89jC6z3YOMR91yWm >									
106 	//        <  u =="0.000000000000000001" : ] 000000046245219.370264600000000000 ; 000000058695111.883866400000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000046908A598FC7 >									
108 	//     < EUROSIBENERGO_PFXXI_I_metadata_line_5_____Irkutskenergo_Bratsk_org_spe_20220321 >									
109 	//        < TIM2KRIowSDOyifm2jiqxaPSbmWC4ETNy38355Qp3g0G7qDo2Qo7F88qEPrb0835 >									
110 	//        <  u =="0.000000000000000001" : ] 000000058695111.883866400000000000 ; 000000073183801.956631900000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000598FC76FAB6C >									
112 	//     < EUROSIBENERGO_PFXXI_I_metadata_line_6_____Irkutskenergo_Ust_Ilimsk_org_spe_20220321 >									
113 	//        < qA853yddUlk8ALvAS78d15ilxVkjWl4wV53RKb81428LL7ndhag9a1HZ2ccq3QYu >									
114 	//        <  u =="0.000000000000000001" : ] 000000073183801.956631900000000000 ; 000000086063518.377191000000000000 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000000000006FAB6C835290 >									
116 	//     < EUROSIBENERGO_PFXXI_I_metadata_line_7_____Oui_Energo_Limited_s_China_Yangtze_Power_Company_20220321 >									
117 	//        < V5xYuQg329y3e71mI2fY6rFBWeUs6o229mq7Lw45Wsav2fcBEnu3zqN5aKD66D6V >									
118 	//        <  u =="0.000000000000000001" : ] 000000086063518.377191000000000000 ; 000000100498919.928642000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000835290995964 >									
120 	//     < EUROSIBENERGO_PFXXI_I_metadata_line_8_____China_Yangtze_Power_Company_limited_20220321 >									
121 	//        < b8ya6w4ODy4scNtR10NG7AJuVr02d7Ph1C55hCgp1u42ElNHoNyehbi0QSUeEoX7 >									
122 	//        <  u =="0.000000000000000001" : ] 000000100498919.928642000000000000 ; 000000115342118.378487000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000995964AFFF84 >									
124 	//     < EUROSIBENERGO_PFXXI_I_metadata_line_9_____Three_Gorges_Electric_Power_Company_Limited_20220321 >									
125 	//        < y7z7WZYSfN27B83K2czI9jj4s8WcRyysF40MFG4Rxf49g11iSi7MeRhj7EHvmSS6 >									
126 	//        <  u =="0.000000000000000001" : ] 000000115342118.378487000000000000 ; 000000129777732.598005000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000000AFFF84C6066D >									
128 	//     < EUROSIBENERGO_PFXXI_I_metadata_line_10_____Beijing_Yangtze_Power_Innovative_Investment_Management_Company_Limited_20220321 >									
129 	//        < 1mG6Uwv9I8Rat2XbriDnkxwrYWR4901l6xzO7i3txm582Xvmq2O5YJCq6x45c9rJ >									
130 	//        <  u =="0.000000000000000001" : ] 000000129777732.598005000000000000 ; 000000146859268.387679000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000000C6066DE016E7 >									
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
174 	//     < EUROSIBENERGO_PFXXI_I_metadata_line_11_____Three_Gorges_Jinsha_River_Chuanyun_Hydropower_Development_Company_Limited_20220321 >									
175 	//        < vaRwhJ9F1kfMz2OA4T07qXa8MZ5eqy9khb1Po52520Blk38mipO1ZWbM5e650Q1S >									
176 	//        <  u =="0.000000000000000001" : ] 000000146859268.387679000000000000 ; 000000160616605.533210000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000000E016E7F514DD >									
178 	//     < EUROSIBENERGO_PFXXI_I_metadata_line_12_____Changdian_Capital_Holding_Company_Limited_20220321 >									
179 	//        < 1NCzV6zO20W3COW1KUXStp24x220A1Q50EKKcr428Tal71TcTv8ioQ3337KjfXU2 >									
180 	//        <  u =="0.000000000000000001" : ] 000000160616605.533210000000000000 ; 000000177250853.914666000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000000F514DD10E769D >									
182 	//     < EUROSIBENERGO_PFXXI_I_metadata_line_13_____Eurosibenergo_OJSC_20220321 >									
183 	//        < 9Z01U7up543N3E303atMNM7185lk6DOE4QkNC6pyxudbt7Mic3hOrOOq0br66780 >									
184 	//        <  u =="0.000000000000000001" : ] 000000177250853.914666000000000000 ; 000000191557392.920394000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000010E769D1244B1B >									
186 	//     < EUROSIBENERGO_PFXXI_I_metadata_line_14_____Baikalenergo_JSC_20220321 >									
187 	//        < 78CBmqJ9L0HmW2lKv9ZgS235Y3Y3LqhTWr8kk2c4274KBk6JgJGcCLmCzc4hled0 >									
188 	//        <  u =="0.000000000000000001" : ] 000000191557392.920394000000000000 ; 000000206462008.762096000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000001244B1B13B0939 >									
190 	//     < EUROSIBENERGO_PFXXI_I_metadata_line_15_____Sayanogorsk_Teploseti_20220321 >									
191 	//        < 7lmPVawpdPDwjsJmz0q2bUH55wjxN9X6V52F91rF3Ljzm6OERTx6hRkBPN3Gjk0z >									
192 	//        <  u =="0.000000000000000001" : ] 000000206462008.762096000000000000 ; 000000219415957.860617000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000013B093914ECD5C >									
194 	//     < EUROSIBENERGO_PFXXI_I_metadata_line_16_____China_Yangtze_Power_International_Hong_Kong_Company_Limited_20220321 >									
195 	//        < 6JBBmNrvoAidY69KhCP6h2Z4e23E53ov4T310COUy1TpZwWhFUtuuA2km9ju8m25 >									
196 	//        <  u =="0.000000000000000001" : ] 000000219415957.860617000000000000 ; 000000235045971.965548000000000000 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000000014ECD5C166A6D5 >									
198 	//     < EUROSIBENERGO_PFXXI_I_metadata_line_17_____Fujian_Electric_Distribution_Sale_COmpany_Limited_20220321 >									
199 	//        < 5gyALP61FqVo3kZ26sk8544dzsK28HsSBo0f4iau2d3QTL2JdMDgBe98f066J27r >									
200 	//        <  u =="0.000000000000000001" : ] 000000235045971.965548000000000000 ; 000000247533658.336166000000000000 ] >									
201 	//        < 0x00000000000000000000000000000000000000000000000000166A6D5179B4D6 >									
202 	//     < EUROSIBENERGO_PFXXI_I_metadata_line_18_____Bohai_Ferry_Group_20220321 >									
203 	//        < 06Vf8px6y7f427Dw9iJg38W2YT4rc13Hna1kvLKzJa81UriN7JSgjBnvuKU2UUGw >									
204 	//        <  u =="0.000000000000000001" : ] 000000247533658.336166000000000000 ; 000000263081382.423645000000000000 ] >									
205 	//        < 0x00000000000000000000000000000000000000000000000000179B4D61916E2A >									
206 	//     < EUROSIBENERGO_PFXXI_I_metadata_line_19_____Eurosibenergo_OJSC_20220321 >									
207 	//        < DAKP1s9RrPHxDeAXL7lZuXyCZA1L4wVdg4sQD481c74vdu2P88azdHM90hMKd0Z2 >									
208 	//        <  u =="0.000000000000000001" : ] 000000263081382.423645000000000000 ; 000000279417885.783541000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000001916E2A1AA5B9D >									
210 	//     < EUROSIBENERGO_PFXXI_I_metadata_line_20_____Krasnoyarskaya_HPP_20220321 >									
211 	//        < o57t055k5mtfcT3c83dV1AX3eDCseud941I5rkLxgfCu6BqPbbu3ODamDx1zY1Mk >									
212 	//        <  u =="0.000000000000000001" : ] 000000279417885.783541000000000000 ; 000000295806732.726728000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000001AA5B9D1C35D81 >									
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
256 	//     < EUROSIBENERGO_PFXXI_I_metadata_line_21_____ERA_Group_OJSC_20220321 >									
257 	//        < 2SB2MwNtYkrcWKyTIc54qVtvl6aQ78gbnEz9V8e4L7E9eejmTL71gGQQm92uDABs >									
258 	//        <  u =="0.000000000000000001" : ] 000000295806732.726728000000000000 ; 000000311217258.931558000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000001C35D811DAE13E >									
260 	//     < EUROSIBENERGO_PFXXI_I_metadata_line_22_____Russky_Kremny_LLC_20220321 >									
261 	//        < 5801BlPh6xR3YkdKXgv342K5fV2Ni2Z4Ml2F8a8yMm496Tn4ma7imVZT990991Ug >									
262 	//        <  u =="0.000000000000000001" : ] 000000311217258.931558000000000000 ; 000000328884934.697418000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000001DAE13E1F5D6AD >									
264 	//     < EUROSIBENERGO_PFXXI_I_metadata_line_23_____Avtozavodskaya_org_spe_20220321 >									
265 	//        < 3vjZnWE63L0p8q63i1jW7h8766x3M3YCo8t0dHC3pVvKWgCBthVZl11JD5K0bl6o >									
266 	//        <  u =="0.000000000000000001" : ] 000000328884934.697418000000000000 ; 000000346582534.906910000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000001F5D6AD210D7CD >									
268 	//     < EUROSIBENERGO_PFXXI_I_metadata_line_24_____Irkutsk_Electric_Grid_Company_20220321 >									
269 	//        < 3bB17D3xdRUZ238Uz4mz70BVE2zlW5D47eB7w9rn90aSD1cq3WOS2890TO3Z1OJ0 >									
270 	//        <  u =="0.000000000000000001" : ] 000000346582534.906910000000000000 ; 000000359198286.827691000000000000 ] >									
271 	//        < 0x00000000000000000000000000000000000000000000000000210D7CD22417D5 >									
272 	//     < EUROSIBENERGO_PFXXI_I_metadata_line_25_____Eurosibenergo_OJSC_20220321 >									
273 	//        < mkvaN8825uwKEGa6itOt4e28O7XHES0B45Z0upIWuurfF58Xzm4C4B8X144rOl70 >									
274 	//        <  u =="0.000000000000000001" : ] 000000359198286.827691000000000000 ; 000000374283459.694493000000000000 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000000000022417D523B1C7A >									
276 	//     < EUROSIBENERGO_PFXXI_I_metadata_line_26_____Eurosibenergo_LLC_distributed_generation_20220321 >									
277 	//        < uo5E6VX9Oou0Ylm43N4pv8UKMKuJuG948Mn2dru6D26RuV3Dp9e9CTZ866JgQUn9 >									
278 	//        <  u =="0.000000000000000001" : ] 000000374283459.694493000000000000 ; 000000386553440.093710000000000000 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000000000023B1C7A24DD570 >									
280 	//     < EUROSIBENERGO_PFXXI_I_metadata_line_27_____Generatsiya_OOO_20220321 >									
281 	//        < 8AulUBc6d4PhM61t5W9Y2zRF0jA1G9urO5RFWf1m1o8K4LtNQ7F0fnXy4A034X3h >									
282 	//        <  u =="0.000000000000000001" : ] 000000386553440.093710000000000000 ; 000000401619289.865238000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000024DD570264D289 >									
284 	//     < EUROSIBENERGO_PFXXI_I_metadata_line_28_____Eurosibenergo_LLC_distributed_gen_NIZHEGORODSKIY_20220321 >									
285 	//        < b4I8Maslo4C6Dd7yLnWPGF30EfE8Uj2PcBq93u1Jo38M3QHp5116t7JbT2aG2eTu >									
286 	//        <  u =="0.000000000000000001" : ] 000000401619289.865238000000000000 ; 000000415088296.142031000000000000 ] >									
287 	//        < 0x00000000000000000000000000000000000000000000000000264D2892795FDE >									
288 	//     < EUROSIBENERGO_PFXXI_I_metadata_line_29_____Angara_Yenisei_org_spe_20220321 >									
289 	//        < wT6kf6CB9A36sMw69D1U53Z9N5DVZrleGzTM1jN9T166629j1j85aE83704AM89G >									
290 	//        <  u =="0.000000000000000001" : ] 000000415088296.142031000000000000 ; 000000430986878.067614000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000002795FDE291A240 >									
292 	//     < EUROSIBENERGO_PFXXI_I_metadata_line_30_____Yuzhno_Yeniseisk_org_spe_20220321 >									
293 	//        < 1ki7U1Isi6d18L16kUzDac1BUqYCp731uSI7gDJ26N7O0N59j9zXw0VzX5oFgZyg >									
294 	//        <  u =="0.000000000000000001" : ] 000000430986878.067614000000000000 ; 000000448099795.716108000000000000 ] >									
295 	//        < 0x00000000000000000000000000000000000000000000000000291A2402ABBEFC >									
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
338 	//     < EUROSIBENERGO_PFXXI_I_metadata_line_31_____Teploseti_LLC_20220321 >									
339 	//        < BrX0sQBcRmFhsH89qA3XnJ6HE6T1p3lS4ksN5vQQ042o2969aLme7HU9n6NwJBbW >									
340 	//        <  u =="0.000000000000000001" : ] 000000448099795.716108000000000000 ; 000000463079494.690487000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000002ABBEFC2C29A6D >									
342 	//     < EUROSIBENERGO_PFXXI_I_metadata_line_32_____Eurosibenergo_Engineering_LLC_20220321 >									
343 	//        < Lt8GLz71J90fYk0RJDmskCU5Yz619gH5mEP15822vs318469gizeVC2U49zZ2Ptk >									
344 	//        <  u =="0.000000000000000001" : ] 000000463079494.690487000000000000 ; 000000479751711.696986000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000002C29A6D2DC0B03 >									
346 	//     < EUROSIBENERGO_PFXXI_I_metadata_line_33_____EurosibPower_Engineering_20220321 >									
347 	//        < ThxbWz9HkVBd5rjX1wpQsimS06dYzfHhCDo01z65J036JXreDUHKMN8X909Nxg5A >									
348 	//        <  u =="0.000000000000000001" : ] 000000479751711.696986000000000000 ; 000000494158229.361846000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000002DC0B032F2068F >									
350 	//     < EUROSIBENERGO_PFXXI_I_metadata_line_34_____Eurosibenergo_hydrogeneration_LLC_20220321 >									
351 	//        < pyHyK92M401zZdCSfxx0Hi1E8f7Jj2oPzDKLk40Mjc1w57EE22u2b8c797D3pbB6 >									
352 	//        <  u =="0.000000000000000001" : ] 000000494158229.361846000000000000 ; 000000507581908.388285000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000002F2068F306822F >									
354 	//     < EUROSIBENERGO_PFXXI_I_metadata_line_35_____Mostootryad_org_spe_20220321 >									
355 	//        < 445gRD40buY2171mUin049QbbVAEsBozbNW7NqdoVWNn5gJ1VPsEZb0X2N6ry837 >									
356 	//        <  u =="0.000000000000000001" : ] 000000507581908.388285000000000000 ; 000000522127437.653289000000000000 ] >									
357 	//        < 0x00000000000000000000000000000000000000000000000000306822F31CB408 >									
358 	//     < EUROSIBENERGO_PFXXI_I_metadata_line_36_____Irkutskenergoremont_CJSC_20220321 >									
359 	//        < F4dmw6LneLly217exrnqlIwaDwtKZ7f91i79ON6U45hk13u7o30YST90R8F5d409 >									
360 	//        <  u =="0.000000000000000001" : ] 000000522127437.653289000000000000 ; 000000538724992.140041000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000031CB4083360773 >									
362 	//     < EUROSIBENERGO_PFXXI_I_metadata_line_37_____Irkutsk_Energy_Retail_20220321 >									
363 	//        < 1CZ4IAS5OZHNL5yq4ePG7r7Emyql0KArRw7CM2c9UiV328G7h10zxZ99GK0VoW2X >									
364 	//        <  u =="0.000000000000000001" : ] 000000538724992.140041000000000000 ; 000000551156017.568457000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000003360773348FF52 >									
366 	//     < EUROSIBENERGO_PFXXI_I_metadata_line_38_____Iirkutskenergo_PCI_Irkutsk_20220321 >									
367 	//        < 86L7hfd4W5LC91X48Dv77a1YWW9L0Ud2b6wa9885onmLAmy31e8TnJewsa5SpE6p >									
368 	//        <  u =="0.000000000000000001" : ] 000000551156017.568457000000000000 ; 000000566404518.412285000000000000 ] >									
369 	//        < 0x00000000000000000000000000000000000000000000000000348FF5236043C4 >									
370 	//     < EUROSIBENERGO_PFXXI_I_metadata_line_39_____Iirkutskenergo_Irkutsk_org_spe_20220321 >									
371 	//        < E2Ro2O9km7SbzKVb3d4N9t4QrCc7q7MOj2uzrPdL6Ls7J6qlrX2t6lL5gtja7N3t >									
372 	//        <  u =="0.000000000000000001" : ] 000000566404518.412285000000000000 ; 000000581565235.348535000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000036043C437765EC >									
374 	//     < EUROSIBENERGO_PFXXI_I_metadata_line_40_____Monchegorskaya_org_spe_20220321 >									
375 	//        < 116rNY8OCG6mzWWkXt2xWolAcJM3BkG9Jt076Q6wfR8wcn40714kTFC1u5ij57PY >									
376 	//        <  u =="0.000000000000000001" : ] 000000581565235.348535000000000000 ; 000000597902679.176595000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000037765EC39053BC >									
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