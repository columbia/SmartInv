1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	NBI_PFI_II_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	NBI_PFI_II_883		"	;
8 		string	public		symbol =	"	NBI_PFI_II_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		802036474541232000000000000					;	
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
92 	//     < NBI_PFI_II_metadata_line_1_____CHINA_RAILWAY_CORPORATION_20231101 >									
93 	//        < Mo3wNkh3G2Wp1GkbzdrDd0yG0A28hjo2oV9k215q42MW6fya3ZB9gas1UC7us9nd >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000018518033.105112600000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000001C419B >									
96 	//     < NBI_PFI_II_metadata_line_2_____MoRWPRoC_AB_20231101 >									
97 	//        < xU475Pa7d1lHh5d9Gy7qNQZMeI78P6Am3M2g95bD06V1EOD00FR6DEwLhyBSlr8g >									
98 	//        <  u =="0.000000000000000001" : ] 000000018518033.105112600000000000 ; 000000040750124.411593600000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000001C419B3E2E04 >									
100 	//     < NBI_PFI_II_metadata_line_3_____MoToPRoC_20231101 >									
101 	//        < coT5hmHLyT574G5k57oC57wLx7fq4u71Lw38Af2W6ewlW5U02HSM8cKs4MnUj57G >									
102 	//        <  u =="0.000000000000000001" : ] 000000040750124.411593600000000000 ; 000000058424922.179964900000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000003E2E0459263C >									
104 	//     < NBI_PFI_II_metadata_line_4_____MoFoPRoC_20231101 >									
105 	//        < 33YXfZECJO18WHvNs2P3W9g9M7s4RS83F732HYgVgI0U6jly9E001142bj4TZHA8 >									
106 	//        <  u =="0.000000000000000001" : ] 000000058424922.179964900000000000 ; 000000074398816.082475800000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000059263C71860A >									
108 	//     < NBI_PFI_II_metadata_line_5_____CAE_PRoC_20231101 >									
109 	//        < KM95tZQgSFtNSF0e420yN4M51rWYq0YI7fO41UBj0bPedgmk6C5s4lXLHefC19L0 >									
110 	//        <  u =="0.000000000000000001" : ] 000000074398816.082475800000000000 ; 000000096294717.707244000000000000 ] >									
111 	//        < 0x000000000000000000000000000000000000000000000000000071860A92EF20 >									
112 	//     < NBI_PFI_II_metadata_line_6_____PBoC_20231101 >									
113 	//        < x82TR1l02TZRV3Rsc70tSTTnIt649V6SI7po1D66m044gG4AjgYSj4eO8rJcRcV0 >									
114 	//        <  u =="0.000000000000000001" : ] 000000096294717.707244000000000000 ; 000000112846329.329655000000000000 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000000000092EF20AC3099 >									
116 	//     < NBI_PFI_II_metadata_line_7_____PRoC_20231101 >									
117 	//        < y43b11TrPd3xW31DlgTB3RcZzl2187DN4EOpu8W87NR5dCaKOyuSK35sM82ac2l5 >									
118 	//        <  u =="0.000000000000000001" : ] 000000112846329.329655000000000000 ; 000000134471543.680270000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000AC3099CD2FF2 >									
120 	//     < NBI_PFI_II_metadata_line_8_____guangzhou_railway_group_20231101 >									
121 	//        < mI311M4wn0ZS37406trcab379si7Y7y2j9KvrhydElq7dZkFd42CwD25LYwKCGG6 >									
122 	//        <  u =="0.000000000000000001" : ] 000000134471543.680270000000000000 ; 000000151036118.918111000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000CD2FF2E6767C >									
124 	//     < NBI_PFI_II_metadata_line_9_____guangzhou_railway_group_Xianghu_20231101 >									
125 	//        < n65u67293nn4QkO9dzNNAX2hy44NnGC39mV9Ps2STM8v735n0SyQ9N3hgFeQV05V >									
126 	//        <  u =="0.000000000000000001" : ] 000000151036118.918111000000000000 ; 000000175217243.906776000000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000000E6767C10B5C3C >									
128 	//     < NBI_PFI_II_metadata_line_10_____guangzhou_railway_group_Yanglao_jin_20231101 >									
129 	//        < dtlUT1KT5bM63046pc4Ps50q6dgE13o4j7GBpTav2JoK7nZnpY05GhrQ63V7qPjS >									
130 	//        <  u =="0.000000000000000001" : ] 000000175217243.906776000000000000 ; 000000195498318.000366000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000010B5C3C12A4E88 >									
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
174 	//     < NBI_PFI_II_metadata_line_11_____Guangshen Railway Company_20231101 >									
175 	//        < Vn7RWIW3OP3hLJ07pEaBN6h9q74xfT7iWJBVaDk3gYW7U0sI1H638UtVjZB311b4 >									
176 	//        <  u =="0.000000000000000001" : ] 000000195498318.000366000000000000 ; 000000218689573.542220000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000012A4E8814DB19D >									
178 	//     < NBI_PFI_II_metadata_line_12_____Guangshen Railway Company_Xianghu_20231101 >									
179 	//        < G4IhzAUH89k1L3qKCSzYvvjOZ6vgC01Yo6nJi85I3vjgIL5p990r4xEbALpq6777 >									
180 	//        <  u =="0.000000000000000001" : ] 000000218689573.542220000000000000 ; 000000238835968.559488000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000014DB19D16C6F4D >									
182 	//     < NBI_PFI_II_metadata_line_13_____Guangshen Railway Company_Yanglao_jin_20231101 >									
183 	//        < 36U915P9DL0CqNhx6AuM7r6gsHhpX9HqLDvmU4Fs74GVXH6ku7BvrxLg2Nm7R748 >									
184 	//        <  u =="0.000000000000000001" : ] 000000238835968.559488000000000000 ; 000000257449382.806974000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000016C6F4D188D62A >									
186 	//     < NBI_PFI_II_metadata_line_14_____grc_shenzhen_longgang_pinghu_qun_yi_railway_store_loading_and_unloading_co_20231101 >									
187 	//        < dO3Ww6GSZOPmL2AV93n3aw8GdPHG0CN4BeHkBF39g3nzh157nUZ9j8xq6X1z11Bc >									
188 	//        <  u =="0.000000000000000001" : ] 000000257449382.806974000000000000 ; 000000279969885.468452000000000000 ] >									
189 	//        < 0x00000000000000000000000000000000000000000000000000188D62A1AB333D >									
190 	//     < NBI_PFI_II_metadata_line_15_____grc_shenzhen_railway_property_management_co_limited_20231101 >									
191 	//        < 62l9Jyfs5ffdt0yBiL860fzmA18Co0uoz0iR3823lHeJDaSPNUm0EqEA8rre2g0C >									
192 	//        <  u =="0.000000000000000001" : ] 000000279969885.468452000000000000 ; 000000296415455.143666000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000001AB333D1C44B4A >									
194 	//     < NBI_PFI_II_metadata_line_16_____grc_dongguan_changsheng_enterprise_co_20231101 >									
195 	//        < C9RKFoc2rUMy06977yJo12A3JLDs1cH6P2n69qfyMH15dJf0q7bm25YHKs4ss3lm >									
196 	//        <  u =="0.000000000000000001" : ] 000000296415455.143666000000000000 ; 000000317013115.640786000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000001C44B4A1E3B940 >									
198 	//     < NBI_PFI_II_metadata_line_17_____grc_shenzhen_yuezheng_enterprise_co_ltd_20231101 >									
199 	//        < XYkCQiaRTp1C4P8194r98H3eISI448o4mLZv2lg2BWfC3V8JqT468j733ALwK7dw >									
200 	//        <  u =="0.000000000000000001" : ] 000000317013115.640786000000000000 ; 000000338702566.132256000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000001E3B940204D1B1 >									
202 	//     < NBI_PFI_II_metadata_line_18_____grc_shenzhen_guangshen_railway_economic_trade_enterprise_co_20231101 >									
203 	//        < x8y51ZkVS72r1nVIPjqbR5k4pzXrOq9wIWG096agXh0RPf7lGPD60I7731fE6Fv1 >									
204 	//        <  u =="0.000000000000000001" : ] 000000338702566.132256000000000000 ; 000000360148242.532618000000000000 ] >									
205 	//        < 0x00000000000000000000000000000000000000000000000000204D1B12258AE8 >									
206 	//     < NBI_PFI_II_metadata_line_19_____grc_shenzhen_fu_yuan_enterprise_development_co_20231101 >									
207 	//        < A34J0tjLZnsUotiy68jrMqo7O4Kb9mPkQnr0qaoRxOCPc949vPc9Sv0p0uTY08Ys >									
208 	//        <  u =="0.000000000000000001" : ] 000000360148242.532618000000000000 ; 000000376076634.047930000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000002258AE823DD8EF >									
210 	//     < NBI_PFI_II_metadata_line_20_____grc_shenzhen_guangshen_railway_travel_service_ltd_20231101 >									
211 	//        < 21f2z4IimY9xpz911wrChh6003clyH4U6LsQc2259j19IF21RXa750QCuF289ivg >									
212 	//        <  u =="0.000000000000000001" : ] 000000376076634.047930000000000000 ; 000000397818964.419826000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000023DD8EF25F0608 >									
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
256 	//     < NBI_PFI_II_metadata_line_21_____grc_shenzhen_shenhuasheng_storage_and_transportation_co_limited_20231101 >									
257 	//        < o4aRojdzT6Y45KpItr0g7Or77cBI396H8nzxwC3Qs5GHcpQ5s39Ytz2zDp06R1Vw >									
258 	//        <  u =="0.000000000000000001" : ] 000000397818964.419826000000000000 ; 000000418411110.137987000000000000 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000000025F060827E71D7 >									
260 	//     < NBI_PFI_II_metadata_line_22_____grc_guangzhou_railway_huangpu_service_co_20231101 >									
261 	//        < mZNa8ND7p2VL9fJCs691z5u8Hc94I83EVrsezbbAM89s9n8XX6O9463XU5K0573J >									
262 	//        <  u =="0.000000000000000001" : ] 000000418411110.137987000000000000 ; 000000434849595.789596000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000027E71D72978720 >									
264 	//     < NBI_PFI_II_metadata_line_23_____grc_guangzhou_fu_yuan_industrial_development_co_20231101 >									
265 	//        < QjgyKnO7il6Hxn5Rg0maOIjlKSIVa5x6zH8133SF6S0WN5RUpu6d33afpu5Z2eos >									
266 	//        <  u =="0.000000000000000001" : ] 000000434849595.789596000000000000 ; 000000456485098.448071000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000029787202B88A7E >									
268 	//     < NBI_PFI_II_metadata_line_24_____grc_changsha_railway_co_20231101 >									
269 	//        < zi0Qi0jcS396LPL9VUO5p4j57LkiQrWiRtq9klu4WMvTt6oPpqmj39n653Pc7hV6 >									
270 	//        <  u =="0.000000000000000001" : ] 000000456485098.448071000000000000 ; 000000475500078.011525000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000002B88A7E2D58E38 >									
272 	//     < NBI_PFI_II_metadata_line_25_____grc_shenzhen_nantie_construction_supervision_co_20231101 >									
273 	//        < B8QD2A985Fw07Eza4xOmFIz5K2mEwEBn9M64PcVmJ32W795PoU1pv13wtU0l5TQW >									
274 	//        <  u =="0.000000000000000001" : ] 000000475500078.011525000000000000 ; 000000498797230.056450000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002D58E382F91AAB >									
276 	//     < NBI_PFI_II_metadata_line_26_____grc_shenzhen_railway_station_passenger_services_co_20231101 >									
277 	//        < fU2PHsAOS4FYc648D6QagRC661L24gcy7338Je34j6NAAHf9SkN497LfwzFpIPPi >									
278 	//        <  u =="0.000000000000000001" : ] 000000498797230.056450000000000000 ; 000000518601576.557923000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000002F91AAB31752BE >									
280 	//     < NBI_PFI_II_metadata_line_27_____grc_shenzhen_jing_ming_industrial_commercial_co_ltd__20231101 >									
281 	//        < l6YY0yPMUyHGCmcK0edk3e7rHH1waPThNi0Zj2EX2lp878FLfTqLsewOLMQ31zgP >									
282 	//        <  u =="0.000000000000000001" : ] 000000518601576.557923000000000000 ; 000000542540889.721799000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000031752BE33BDA09 >									
284 	//     < NBI_PFI_II_metadata_line_28_____grc_shenzhen_road_multi_modal_transportation_co_limited_20231101 >									
285 	//        < Op9T16Il0Us1mH8AD30HReL4ZPrQM1913e3r0lbDSPXwe3KH1Np86d06n616de5O >									
286 	//        <  u =="0.000000000000000001" : ] 000000542540889.721799000000000000 ; 000000558845799.501248000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000033BDA09354BB24 >									
288 	//     < NBI_PFI_II_metadata_line_29_____grc_guangzhou_railway_group_yangcheng_railway_enterprise_development_co_20231101 >									
289 	//        < xdqsR253HpqhP6L31GoWG17w82H8uK7XH1dp607fQM8i8Re58y71p7794sexUK1H >									
290 	//        <  u =="0.000000000000000001" : ] 000000558845799.501248000000000000 ; 000000578375853.681286000000000000 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000000000354BB243728811 >									
292 	//     < NBI_PFI_II_metadata_line_30_____grc_guangzhou_dongqun_advertising_company_limited_20231101 >									
293 	//        < p1vbB592t58m6vV5ls4sr9p4kU4YgmAoLq8B87KW3558kp1wC6U1cvMQYVl4mzF2 >									
294 	//        <  u =="0.000000000000000001" : ] 000000578375853.681286000000000000 ; 000000603060084.263004000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000037288113983258 >									
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
338 	//     < NBI_PFI_II_metadata_line_31_____grc_guangzhou_tielian_economy_development_co_ltd_20231101 >									
339 	//        < 8bi0N1yR1L7N5eBNd9onj0M0Pc9w2Rg2342RC8SRpa4sN0j4tFX94UCnmp1lNOQ0 >									
340 	//        <  u =="0.000000000000000001" : ] 000000603060084.263004000000000000 ; 000000622555371.245196000000000000 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000000000039832583B5F1B1 >									
342 	//     < NBI_PFI_II_metadata_line_32_____cr_guangzhou_group_guangzhou_railway_economic_technology_development_group_co_ltd_20231101 >									
343 	//        < 6wEHFtLeUEvB7byaV18lu9MLnFe8c5zOnW6uuMr8JgYhO9Wq42xipK4594KWMwHa >									
344 	//        <  u =="0.000000000000000001" : ] 000000622555371.245196000000000000 ; 000000642011718.123105000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000003B5F1B13D3A1D4 >									
346 	//     < NBI_PFI_II_metadata_line_33_____guangzhou_railway_economic_tech_dev_group_co_ltd_shenzhen_guang_tie_civil_engineering_co_ltd_20231101 >									
347 	//        < 8ZR9B05bt6Ig616Gu71RW6kHhLVtpCGO8fuCbF77ou3DhtyguO60fJ0ulGrLgRIv >									
348 	//        <  u =="0.000000000000000001" : ] 000000642011718.123105000000000000 ; 000000666431574.594372000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000003D3A1D43F8E4D5 >									
350 	//     < NBI_PFI_II_metadata_line_34_____cr_guangzhou_group_guangdong_sanmao_railway_limited_co_20231101 >									
351 	//        < PgJ5kmOOjL1w0859Wr83TtpuKGk2a11Ljw0H2FVMqp72J20Y92EadE4ORA4l0Mth >									
352 	//        <  u =="0.000000000000000001" : ] 000000666431574.594372000000000000 ; 000000689695692.972139000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000003F8E4D541C6461 >									
354 	//     < NBI_PFI_II_metadata_line_35_____cr_guangzhou_group_guangmeishan_railway_limited_co_20231101 >									
355 	//        < 8481HhXRiA7U5aRkvbu44lre0fnMjd5CPGjH228e20DxnUa6l9RSx0Q29ZKnxza7 >									
356 	//        <  u =="0.000000000000000001" : ] 000000689695692.972139000000000000 ; 000000706205526.830633000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000041C64614359589 >									
358 	//     < NBI_PFI_II_metadata_line_36_____cr_guangzhou group guangshen railway enterprise development co._20231101 >									
359 	//        < Gj6tsf7Ahts4ivvw1U4B77370Z1SXCL4y5E0F1K59jtI99dq6324npR82kv23w8G >									
360 	//        <  u =="0.000000000000000001" : ] 000000706205526.830633000000000000 ; 000000725590884.434511000000000000 ] >									
361 	//        < 0x00000000000000000000000000000000000000000000000000435958945329F0 >									
362 	//     < NBI_PFI_II_metadata_line_37_____cr_guangzhou_group_guangzhou_railway_guangshen_railway_enterprise_development_co_20231101 >									
363 	//        < Mz8PdI894OoCe0KX8FmvGRAx36d45pEhbevYWMz8C1G73TRv9171O16E94TE2FYp >									
364 	//        <  u =="0.000000000000000001" : ] 000000725590884.434511000000000000 ; 000000743392282.318454000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000045329F046E539C >									
366 	//     < NBI_PFI_II_metadata_line_38_____CRC_CR_Shanghai_group_20231101 >									
367 	//        < MAVUJ19jt36A47gD9JC6V251l34x0ODdlG17TLVHK3G42arS62qOK3aS50dS6f13 >									
368 	//        <  u =="0.000000000000000001" : ] 000000743392282.318454000000000000 ; 000000762575475.871662000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000046E539C48B990C >									
370 	//     < NBI_PFI_II_metadata_line_39_____CRC_CR_Jinan_group_20231101 >									
371 	//        < BKqQh3GqomVptNKC2Kwx1Fzhw7igRu963317eODSC3f0odF0nl59S2ZsCmA7251D >									
372 	//        <  u =="0.000000000000000001" : ] 000000762575475.871662000000000000 ; 000000786157541.950047000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000048B990C4AF94CA >									
374 	//     < NBI_PFI_II_metadata_line_40_____cr_Jinan_group_sinorailbohai_train_ferry_co_ltd_20231101 >									
375 	//        < d3E2i1v16ZMF5228FNBTq74AlJuUpr2tU2JyFxv3w4F8PhiR32wH5TYjrrKJGUgg >									
376 	//        <  u =="0.000000000000000001" : ] 000000786157541.950047000000000000 ; 000000802036474.541232000000000000 ] >									
377 	//        < 0x000000000000000000000000000000000000000000000000004AF94CA4C7CF7F >									
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