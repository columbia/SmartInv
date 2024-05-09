1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFII_II_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFII_II_883		"	;
8 		string	public		symbol =	"	RUSS_PFII_II_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		804418858970009000000000000					;	
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
92 	//     < RUSS_PFII_II_metadata_line_1_____SISTEMA_20231101 >									
93 	//        < 922XZW1f1Dkv4X8Zl9IEMhFC9nfhkuF7EYQ03Q5th874VeHS8YnW0vOnIn9A08bc >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000017451345.573337400000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000001AA0EF >									
96 	//     < RUSS_PFII_II_metadata_line_2_____SISTEMA_usd_20231101 >									
97 	//        < xOZOhSs08l5tkly6Yt5F24G34dp9E318I7FL4m1s0Kv8uh9t03ATXnxjqL6jxYEF >									
98 	//        <  u =="0.000000000000000001" : ] 000000017451345.573337400000000000 ; 000000037630096.284907700000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000001AA0EF396B42 >									
100 	//     < RUSS_PFII_II_metadata_line_3_____SISTEMA_AB_20231101 >									
101 	//        < AG7z7ljGR18V5eJTIAk2m6YTLx8cSiQJVYqOsx85p3FsI5Q8V1r7XLl63P9WIT87 >									
102 	//        <  u =="0.000000000000000001" : ] 000000037630096.284907700000000000 ; 000000056544824.828423300000000000 ] >									
103 	//        < 0x0000000000000000000000000000000000000000000000000000396B425647D2 >									
104 	//     < RUSS_PFII_II_metadata_line_4_____RUSAL_20231101 >									
105 	//        < H9svpA7AYrix7ivBVRyF5d72sO70Kl9Ub1RV03WZ7xJyprJUGKywXFsF9Bx3P2dF >									
106 	//        <  u =="0.000000000000000001" : ] 000000056544824.828423300000000000 ; 000000079377774.605930700000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000005647D2791EF1 >									
108 	//     < RUSS_PFII_II_metadata_line_5_____RUSAL_HKD_20231101 >									
109 	//        < K2x6n8f35Nhhq4l1y3gDVqRK6nPeXOGb74pmwdgzP9M4iUKbpBJMu5fqXgYSIJ1D >									
110 	//        <  u =="0.000000000000000001" : ] 000000079377774.605930700000000000 ; 000000101930615.985985000000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000791EF19B88A6 >									
112 	//     < RUSS_PFII_II_metadata_line_6_____RUSAL_GBP_20231101 >									
113 	//        < S0mV4F4a07D11WwNZLiRcI2p9cXg40y070oI95S4rkC61W0yj0BXL6CkbLQ360aM >									
114 	//        <  u =="0.000000000000000001" : ] 000000101930615.985985000000000000 ; 000000125414165.017916000000000000 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000000000009B88A6BF5DE9 >									
116 	//     < RUSS_PFII_II_metadata_line_7_____RUSAL_AB_20231101 >									
117 	//        < nkWK1H47zKYbAdfUQ86WWFgpITznNN0QG1K66sTwQwx09edDJ14qqt389Gf94802 >									
118 	//        <  u =="0.000000000000000001" : ] 000000125414165.017916000000000000 ; 000000145216778.072324000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000BF5DE9DD954E >									
120 	//     < RUSS_PFII_II_metadata_line_8_____EUROSIBENERGO_20231101 >									
121 	//        < 0W3tFEaxAs18ixI5q1xf7DVqidZ0aaMCjJU6jeCj8e94zNsSEUdnPyycA2eU57sb >									
122 	//        <  u =="0.000000000000000001" : ] 000000145216778.072324000000000000 ; 000000165792449.768738000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000DD954EFCFAAD >									
124 	//     < RUSS_PFII_II_metadata_line_9_____BASEL_20231101 >									
125 	//        < Bs5QAA08389SuO879hvL3f9DAYhCjiwq6KzJRO73w5bZmXiw66CImJf41n2df3X3 >									
126 	//        <  u =="0.000000000000000001" : ] 000000165792449.768738000000000000 ; 000000182848331.048629000000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000000FCFAAD1170121 >									
128 	//     < RUSS_PFII_II_metadata_line_10_____ENPLUS_20231101 >									
129 	//        < iZc2Molh7URSFIHA21v5s725PwZ34G18373lIN3Q021h91lgxkz68czX8ctu2lIs >									
130 	//        <  u =="0.000000000000000001" : ] 000000182848331.048629000000000000 ; 000000206236857.632158000000000000 ] >									
131 	//        < 0x00000000000000000000000000000000000000000000000000117012113AB146 >									
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
174 	//     < RUSS_PFII_II_metadata_line_11_____RUSSIAN_MACHINES_20231101 >									
175 	//        < 0r1gItZnav8Qqd4O3XUbv8PqH7bQk6M7yG348sx83XeCcIbE8h1VcXFh5b26Us46 >									
176 	//        <  u =="0.000000000000000001" : ] 000000206236857.632158000000000000 ; 000000229838182.132957000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000013AB14615EB48A >									
178 	//     < RUSS_PFII_II_metadata_line_12_____GAZ_GROUP_20231101 >									
179 	//        < 0J9o315b28C5S1e2yUAFSjX5KTR0SkrUaVZ6b1I1m0JB021HF8s70b8H414egk5y >									
180 	//        <  u =="0.000000000000000001" : ] 000000229838182.132957000000000000 ; 000000249192651.200791000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000015EB48A17C3CE1 >									
182 	//     < RUSS_PFII_II_metadata_line_13_____SMR_20231101 >									
183 	//        < 7h8cdfHmS19rm64NfuDWFjLG21mUEg6X17roNyD7JL8IxxS8T3ze5EL82DR2051T >									
184 	//        <  u =="0.000000000000000001" : ] 000000249192651.200791000000000000 ; 000000268044579.181637000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000017C3CE119900EA >									
186 	//     < RUSS_PFII_II_metadata_line_14_____ENPLUS_DOWN_20231101 >									
187 	//        < nHh3Ydp2Br7CYU72t64N2fzx8F68g8a71I0bNuD9F1Q37fPJAECo65576ocI7iGO >									
188 	//        <  u =="0.000000000000000001" : ] 000000268044579.181637000000000000 ; 000000285631577.152451000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000019900EA1B3D6D6 >									
190 	//     < RUSS_PFII_II_metadata_line_15_____ENPLUS_COAL_20231101 >									
191 	//        < h9Amta4Wv2SfJUQSRUHIxwxa23ZcAr0XgM0aPBj8uhJW44I2v2T4i6sd78g68631 >									
192 	//        <  u =="0.000000000000000001" : ] 000000285631577.152451000000000000 ; 000000308425055.241931000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000001B3D6D61D69E8A >									
194 	//     < RUSS_PFII_II_metadata_line_16_____RM_SYSTEMS_20231101 >									
195 	//        < 2VnJmi6CM3TH1KYDg04F4Xq7J20z9VPjBs9l76c5Lw0133Ylib29Z4D8Ks2yb0J7 >									
196 	//        <  u =="0.000000000000000001" : ] 000000308425055.241931000000000000 ; 000000327141397.256366000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000001D69E8A1F32D9C >									
198 	//     < RUSS_PFII_II_metadata_line_17_____RM_RAIL_20231101 >									
199 	//        < 315b3rXU9e4C38HKK3l8GEfgb7f4QqGT27C7V1lC7Czu850pUMbqPg5SwCf7p50m >									
200 	//        <  u =="0.000000000000000001" : ] 000000327141397.256366000000000000 ; 000000345801732.158348000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000001F32D9C20FA6CD >									
202 	//     < RUSS_PFII_II_metadata_line_18_____AVIAKOR_20231101 >									
203 	//        < sOTvVLu369O928jLy6P3I99eMuf46WZmvf1u529Snl3C6fnXsU3HXtMVIQsZ72OF >									
204 	//        <  u =="0.000000000000000001" : ] 000000345801732.158348000000000000 ; 000000365488227.722253000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000020FA6CD22DB0D7 >									
206 	//     < RUSS_PFII_II_metadata_line_19_____SOCHI_AIRPORT_20231101 >									
207 	//        < fT6zDZ4qLcQ4Vfp07A9G5j6umu6TNoHQ256L8gNMkY4IKABZIE9hc9jE538K3zG1 >									
208 	//        <  u =="0.000000000000000001" : ] 000000365488227.722253000000000000 ; 000000388962109.233406000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000000022DB0D72518253 >									
210 	//     < RUSS_PFII_II_metadata_line_20_____KRASNODAR_AIRPORT_20231101 >									
211 	//        < Hh6WT5mMO842a4o8XIrcg44zPcj31X9Phu4SU7D3lG6E6q4bC83vGGw91wjF0W74 >									
212 	//        <  u =="0.000000000000000001" : ] 000000388962109.233406000000000000 ; 000000410125400.960028000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000002518253271CD3C >									
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
256 	//     < RUSS_PFII_II_metadata_line_21_____ANAPA_AIRPORT_20231101 >									
257 	//        < 9IJ0511umzaRFI5t0Wy3t9rvPyrDtVnSM1ou13CKH9G5Mj7OB7mRRndpp8pnQk12 >									
258 	//        <  u =="0.000000000000000001" : ] 000000410125400.960028000000000000 ; 000000433890520.848336000000000000 ] >									
259 	//        < 0x00000000000000000000000000000000000000000000000000271CD3C296107C >									
260 	//     < RUSS_PFII_II_metadata_line_22_____GLAVMOSSTROY_20231101 >									
261 	//        < XLCS2ct0JV2slUWeHz56Ub5u18d54XSEG65nPk659sXoHHZ631qBz6X79HHtIg94 >									
262 	//        <  u =="0.000000000000000001" : ] 000000433890520.848336000000000000 ; 000000451593215.382244000000000000 ] >									
263 	//        < 0x00000000000000000000000000000000000000000000000000296107C2B1139A >									
264 	//     < RUSS_PFII_II_metadata_line_23_____TRANSSTROY_20231101 >									
265 	//        < 3R6H103619uFkT149e899QGz6E27VF5E943wSs6OVO1RFHc0RRY2Zo9Bw6iIWO7B >									
266 	//        <  u =="0.000000000000000001" : ] 000000451593215.382244000000000000 ; 000000470818313.435904000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000002B1139A2CE6967 >									
268 	//     < RUSS_PFII_II_metadata_line_24_____GLAVSTROY_20231101 >									
269 	//        < na3SF9t7eBhI89G10K43L4d926eX4GJnHEy3WOEcZd389gXkRrHLJ5C56o57544Z >									
270 	//        <  u =="0.000000000000000001" : ] 000000470818313.435904000000000000 ; 000000492319827.910449000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000002CE69672EF386F >									
272 	//     < RUSS_PFII_II_metadata_line_25_____GLAVSTROY_SPB_20231101 >									
273 	//        < Z3vH6AKF22n6O3T9aVtRGChlhhJdyrC54pT28P1OP6xY7sZO60aJW353mCbw1piL >									
274 	//        <  u =="0.000000000000000001" : ] 000000492319827.910449000000000000 ; 000000509483429.937191000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002EF386F30968F7 >									
276 	//     < RUSS_PFII_II_metadata_line_26_____ROGSIBAL_20231101 >									
277 	//        < P2oo7Tu6L0AzN5cwAVD31jGe639g9J877bTNaPx8qpAnj475cBBK8ELrqcmGc0Aa >									
278 	//        <  u =="0.000000000000000001" : ] 000000509483429.937191000000000000 ; 000000529148038.230523000000000000 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000000000030968F73276A74 >									
280 	//     < RUSS_PFII_II_metadata_line_27_____BASEL_CEMENT_20231101 >									
281 	//        < vWlqau2xdhc24M9vQLvPOwbC1oR8dgf661X368GG2eHDUl6J37biOnrBs1fGO2qj >									
282 	//        <  u =="0.000000000000000001" : ] 000000529148038.230523000000000000 ; 000000546324733.093281000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000003276A74341A019 >									
284 	//     < RUSS_PFII_II_metadata_line_28_____KUBAN_AGROHOLDING_20231101 >									
285 	//        < 46Ock5ilM1khYi09k5S4DBWCE112ws00RgGn65w1mBwC7PhXvY4L5Xpb7GOP8Mzk >									
286 	//        <  u =="0.000000000000000001" : ] 000000546324733.093281000000000000 ; 000000564305896.478938000000000000 ] >									
287 	//        < 0x00000000000000000000000000000000000000000000000000341A01935D0FFE >									
288 	//     < RUSS_PFII_II_metadata_line_29_____AQUADIN_20231101 >									
289 	//        < 94874p615j03nsUJIi9rc3ldiQcEe2DW9Xs0FifD0EydM4y36ku0OH285S4d1DlE >									
290 	//        <  u =="0.000000000000000001" : ] 000000564305896.478938000000000000 ; 000000585908128.295622000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000035D0FFE37E065D >									
292 	//     < RUSS_PFII_II_metadata_line_30_____VASKHOD_STUD_FARM_20231101 >									
293 	//        < bYD0V5NfzW0ZW6Ko39629LJ70yZyNn9Po5jgRlabK4t9x8jJMvccFB7WB3fs89vG >									
294 	//        <  u =="0.000000000000000001" : ] 000000585908128.295622000000000000 ; 000000604112825.257725000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000037E065D399CD93 >									
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
338 	//     < RUSS_PFII_II_metadata_line_31_____IMERETINSKY_PORT_20231101 >									
339 	//        < 41a19epqY18VdAb2M7TOAtVypWU5NSBVlgpi3T42bZ2hBI54IwALLU3b8A6XW124 >									
340 	//        <  u =="0.000000000000000001" : ] 000000604112825.257725000000000000 ; 000000626589348.197658000000000000 ] >									
341 	//        < 0x00000000000000000000000000000000000000000000000000399CD933BC1977 >									
342 	//     < RUSS_PFII_II_metadata_line_32_____BASEL_REAL_ESTATE_20231101 >									
343 	//        < 61e3214Q0LLx5O9YF7jd5NWz9ql6i1yACml505IaRMjW44eFt5f5OIW0Qv6hejBr >									
344 	//        <  u =="0.000000000000000001" : ] 000000626589348.197658000000000000 ; 000000647880584.416373000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000003BC19773DC965A >									
346 	//     < RUSS_PFII_II_metadata_line_33_____UZHURALZOLOTO_20231101 >									
347 	//        < yk1H6x6rb4w8jrevUN6gN8K8o8R2gtRKCjPJ67ttoe9bi1q6Go25TU1SrirQDSUN >									
348 	//        <  u =="0.000000000000000001" : ] 000000647880584.416373000000000000 ; 000000667592639.326294000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000003DC965A3FAAA60 >									
350 	//     < RUSS_PFII_II_metadata_line_34_____NORILSK_NICKEL_20231101 >									
351 	//        < 384Xz6W0y9iwD19QfmdleyPB15A5Vq1atBkBmBy8TDo8YDj7zfUEBTGndY8KjIDr >									
352 	//        <  u =="0.000000000000000001" : ] 000000667592639.326294000000000000 ; 000000687150876.120440000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000003FAAA604188250 >									
354 	//     < RUSS_PFII_II_metadata_line_35_____RUSHYDRO_20231101 >									
355 	//        < SxiI1SMfpA9ZddmQi6PElMU2ASn46ht1b5nT3e6M0u2b252q8XA4iu4TD3ouyJwc >									
356 	//        <  u =="0.000000000000000001" : ] 000000687150876.120440000000000000 ; 000000705688924.084725000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000004188250434CBBC >									
358 	//     < RUSS_PFII_II_metadata_line_36_____INTER_RAO_20231101 >									
359 	//        < M16sHHVG7BaNI2WC74PmDCV8n9yGE09B8F8WH929401igD77kuk8l8p495944qPB >									
360 	//        <  u =="0.000000000000000001" : ] 000000705688924.084725000000000000 ; 000000726273316.532171000000000000 ] >									
361 	//        < 0x00000000000000000000000000000000000000000000000000434CBBC4543484 >									
362 	//     < RUSS_PFII_II_metadata_line_37_____LUKOIL_20231101 >									
363 	//        < o7BDz8eZ0620NuZ525oeJFmXUUjWHj5wfRUO6JdyG0QwfZDRoRQ5Kct2o3zAu824 >									
364 	//        <  u =="0.000000000000000001" : ] 000000726273316.532171000000000000 ; 000000746852840.991303000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000045434844739B64 >									
366 	//     < RUSS_PFII_II_metadata_line_38_____MAGNITOGORSK_ISW_20231101 >									
367 	//        < MmU473tg3u7DSS5UQ1tFDxC788CO1sp27lyGrg8tI286293E81BoYv1N9u93m10K >									
368 	//        <  u =="0.000000000000000001" : ] 000000746852840.991303000000000000 ; 000000766473690.279096000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000004739B644918BC9 >									
370 	//     < RUSS_PFII_II_metadata_line_39_____MAGNIT_20231101 >									
371 	//        < 4Ks75b80Z8tGPdQC0JJ7x25i5KWX355fJ2ooY4w5BA2w7Xb8j3r4gpFNr7DONL7B >									
372 	//        <  u =="0.000000000000000001" : ] 000000766473690.279096000000000000 ; 000000785272205.994272000000000000 ] >									
373 	//        < 0x000000000000000000000000000000000000000000000000004918BC94AE3AF5 >									
374 	//     < RUSS_PFII_II_metadata_line_40_____IDGC_20231101 >									
375 	//        < Njn48GJDl725365suVz7WY4nZ25pp7F0rcgdGoZsRSmLouj01M3jq6Z1q39g1e8J >									
376 	//        <  u =="0.000000000000000001" : ] 000000785272205.994272000000000000 ; 000000804418858.970009000000000000 ] >									
377 	//        < 0x000000000000000000000000000000000000000000000000004AE3AF54CB721E >									
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