1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	NBI_PFI_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	NBI_PFI_III_883		"	;
8 		string	public		symbol =	"	NBI_PFI_III_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		990977811237744000000000000					;	
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
92 	//     < NBI_PFI_III_metadata_line_1_____CHINA_RAILWAY_CORPORATION_20251101 >									
93 	//        < zfFrRix2nL5dhe738kysA6Vp92H0392Qf7445T296Y3hRbuj34S4xKPE5NqScp0w >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000021783807.664732200000000000 ] >									
95 	//        < 0x0000000000000000000000000000000000000000000000000000000000213D4D >									
96 	//     < NBI_PFI_III_metadata_line_2_____MoRWPRoC_AB_20251101 >									
97 	//        < 6D1310hRMOO2jG8Llx24H6652e6D7aesMGW3q2a9hv3w5qQb6ww5WVlkGZWvlz8X >									
98 	//        <  u =="0.000000000000000001" : ] 000000021783807.664732200000000000 ; 000000044539850.164443500000000000 ] >									
99 	//        < 0x0000000000000000000000000000000000000000000000000000213D4D43F661 >									
100 	//     < NBI_PFI_III_metadata_line_3_____MoToPRoC_20251101 >									
101 	//        < Z6MI1vWX8eRL88H1uViPV7N4KUNI1g63jm6UA712d2E3ZY6B5DLHexuG8u766VUv >									
102 	//        <  u =="0.000000000000000001" : ] 000000044539850.164443500000000000 ; 000000066955459.780225200000000000 ] >									
103 	//        < 0x000000000000000000000000000000000000000000000000000043F661662A7A >									
104 	//     < NBI_PFI_III_metadata_line_4_____MoFoPRoC_20251101 >									
105 	//        < 5aD34ivn2z842GuGW2gWtdTD9Nt9Ub9cehL92RBi24OP1u4E3qQ7Eg2ZvYPo1028 >									
106 	//        <  u =="0.000000000000000001" : ] 000000066955459.780225200000000000 ; 000000090715578.720353600000000000 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000000000662A7A8A6BC6 >									
108 	//     < NBI_PFI_III_metadata_line_5_____CAE_PRoC_20251101 >									
109 	//        < 1tv685V9J6xHJ52czS9699311poE6S228Gi555EdLrE4R468x6p6pwwauXJYYO3S >									
110 	//        <  u =="0.000000000000000001" : ] 000000090715578.720353600000000000 ; 000000122869177.992962000000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000008A6BC6BB7BC6 >									
112 	//     < NBI_PFI_III_metadata_line_6_____PBoC_20251101 >									
113 	//        < 02VQEPTCg93QvO006A8PK0IlOMzFeP76SqPrwJl7IGQp77zC5549C2s6B4vo51U4 >									
114 	//        <  u =="0.000000000000000001" : ] 000000122869177.992962000000000000 ; 000000145508335.177588000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000BB7BC6DE0732 >									
116 	//     < NBI_PFI_III_metadata_line_7_____PRoC_20251101 >									
117 	//        < 0UNjqhW60d6AD22mpqFiBD5L5TfGIcqwL9SdCfEV4H35Dy2vMx9yc0KQ78PG3S9s >									
118 	//        <  u =="0.000000000000000001" : ] 000000145508335.177588000000000000 ; 000000180900198.250166000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000000DE07321140824 >									
120 	//     < NBI_PFI_III_metadata_line_8_____guangzhou_railway_group_20251101 >									
121 	//        < RVpF0tZ7Y2Vv87A6Fn609J4I6w842Evz68f94472H4E39O8zvzB27IVM94k8GP1w >									
122 	//        <  u =="0.000000000000000001" : ] 000000180900198.250166000000000000 ; 000000204035603.720369000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000011408241375568 >									
124 	//     < NBI_PFI_III_metadata_line_9_____guangzhou_railway_group_Xianghu_20251101 >									
125 	//        < 2mVh8kQ48dMdn98h93l2eWCxXympz0VH0423sd1rBW950Ghqk8gh6pb4q2SlZBfe >									
126 	//        <  u =="0.000000000000000001" : ] 000000204035603.720369000000000000 ; 000000235425219.355292000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000013755681673AFA >									
128 	//     < NBI_PFI_III_metadata_line_10_____guangzhou_railway_group_Yanglao_jin_20251101 >									
129 	//        < DeRgV8Oe8S3IZsHWo11syE32aYn6b6D22ls3kNQbXM69S2fI6LEO5WX7Fy63dSE5 >									
130 	//        <  u =="0.000000000000000001" : ] 000000235425219.355292000000000000 ; 000000254482202.878605000000000000 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000000001673AFA1844F1C >									
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
174 	//     < NBI_PFI_III_metadata_line_11_____Guangshen Railway Company_20251101 >									
175 	//        < LfdoL36W9D2Jp8TyoR3RKrtfzJX49mF5U9ouunGyzZx77S89kJK2VD0nre0651o1 >									
176 	//        <  u =="0.000000000000000001" : ] 000000254482202.878605000000000000 ; 000000273131776.323034000000000000 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000000001844F1C1A0C41A >									
178 	//     < NBI_PFI_III_metadata_line_12_____Guangshen Railway Company_Xianghu_20251101 >									
179 	//        < hOwJPKffzfQrSGC2ziw1ZSVisu5V2sWu9uZXEwfh7127L3k0mEL58W7WTvK4Vl12 >									
180 	//        <  u =="0.000000000000000001" : ] 000000273131776.323034000000000000 ; 000000291844068.318144000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000001A0C41A1BD5197 >									
182 	//     < NBI_PFI_III_metadata_line_13_____Guangshen Railway Company_Yanglao_jin_20251101 >									
183 	//        < R0Aohdcs9CV9h4fG1gSunezl2bqg104qCU2I25px0u5487lh23K6SF944s3k3S61 >									
184 	//        <  u =="0.000000000000000001" : ] 000000291844068.318144000000000000 ; 000000313573639.485155000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001BD51971DE79B4 >									
186 	//     < NBI_PFI_III_metadata_line_14_____grc_shenzhen_longgang_pinghu_qun_yi_railway_store_loading_and_unloading_co_20251101 >									
187 	//        < EGv944696peJ0xXUvVb8c6R8w93XaK5L3se4oWk0XIGCTvs4zTVFq1472iz3hSKe >									
188 	//        <  u =="0.000000000000000001" : ] 000000313573639.485155000000000000 ; 000000335068280.219560000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000001DE79B41FF460C >									
190 	//     < NBI_PFI_III_metadata_line_15_____grc_shenzhen_railway_property_management_co_limited_20251101 >									
191 	//        < Y9p9BDW074phN9bw4LHF0512E25FJ9C117HUyP2G07kP7E15om349C4376J40s37 >									
192 	//        <  u =="0.000000000000000001" : ] 000000335068280.219560000000000000 ; 000000366143833.217129000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000001FF460C22EB0EF >									
194 	//     < NBI_PFI_III_metadata_line_16_____grc_dongguan_changsheng_enterprise_co_20251101 >									
195 	//        < Gw4s9C28ZtOktR121UKd97r42itextfsRCaxqtcKKeNkb9mr582D7u67lr29YeH3 >									
196 	//        <  u =="0.000000000000000001" : ] 000000366143833.217129000000000000 ; 000000396487068.461775000000000000 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000000022EB0EF25CFDC3 >									
198 	//     < NBI_PFI_III_metadata_line_17_____grc_shenzhen_yuezheng_enterprise_co_ltd_20251101 >									
199 	//        < DRV8ko8dPOzqswDnJ2u2LW93XfYTlA266GcIomWRD758MRw8J34233i9P1010383 >									
200 	//        <  u =="0.000000000000000001" : ] 000000396487068.461775000000000000 ; 000000430562930.765094000000000000 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000000025CFDC3290FCA5 >									
202 	//     < NBI_PFI_III_metadata_line_18_____grc_shenzhen_guangshen_railway_economic_trade_enterprise_co_20251101 >									
203 	//        < nb2jc48WK2CQhDXV12169a7ZM2icR58Pt0U2zfjCvNw5grVc0hqzt6ryTeKu8LLl >									
204 	//        <  u =="0.000000000000000001" : ] 000000430562930.765094000000000000 ; 000000451341745.098549000000000000 ] >									
205 	//        < 0x00000000000000000000000000000000000000000000000000290FCA52B0B15F >									
206 	//     < NBI_PFI_III_metadata_line_19_____grc_shenzhen_fu_yuan_enterprise_development_co_20251101 >									
207 	//        < vztM7Vw5Xak8Hl39zMa03S62Y4B2u9DpoZVC37kk6J0JBRg7l2lXr3hxxEAWP7oG >									
208 	//        <  u =="0.000000000000000001" : ] 000000451341745.098549000000000000 ; 000000474181863.827084000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000002B0B15F2D38B4A >									
210 	//     < NBI_PFI_III_metadata_line_20_____grc_shenzhen_guangshen_railway_travel_service_ltd_20251101 >									
211 	//        < JKFwW62HS2V86nLPCMUMiVr0z0ivWeXU7zjx210Zo34TM5R059jxd6HdRwK153qD >									
212 	//        <  u =="0.000000000000000001" : ] 000000474181863.827084000000000000 ; 000000495036282.838827000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000002D38B4A2F35D8C >									
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
256 	//     < NBI_PFI_III_metadata_line_21_____grc_shenzhen_shenhuasheng_storage_and_transportation_co_limited_20251101 >									
257 	//        < M5E5IGny9DElFlnG184VTzmOrLH7Xb4jr31jkzc8l2H6r9xKfljE9p7tkDuCW6sJ >									
258 	//        <  u =="0.000000000000000001" : ] 000000495036282.838827000000000000 ; 000000521749492.532967000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000002F35D8C31C2065 >									
260 	//     < NBI_PFI_III_metadata_line_22_____grc_guangzhou_railway_huangpu_service_co_20251101 >									
261 	//        < C0DpMxoYMh2mj2uL8JrxQWztlm34r8jv4isi5XN2njBKXYXrNc01d82Y1Kn5Bo0F >									
262 	//        <  u =="0.000000000000000001" : ] 000000521749492.532967000000000000 ; 000000547823047.693332000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000031C2065343E961 >									
264 	//     < NBI_PFI_III_metadata_line_23_____grc_guangzhou_fu_yuan_industrial_development_co_20251101 >									
265 	//        < I0tDa1mJi1WaPBNLK2AQ7D43VK04JVnlQ5omSaq41lKd32JOxn0PEOM2843SFq64 >									
266 	//        <  u =="0.000000000000000001" : ] 000000547823047.693332000000000000 ; 000000569866633.781948000000000000 ] >									
267 	//        < 0x00000000000000000000000000000000000000000000000000343E9613658C27 >									
268 	//     < NBI_PFI_III_metadata_line_24_____grc_changsha_railway_co_20251101 >									
269 	//        < CAZ994jqB1Xo4U2R2T23fuKf3G4Owczu3I7t4dmOmlw4dDr1h8s7vxCE5vA0FEel >									
270 	//        <  u =="0.000000000000000001" : ] 000000569866633.781948000000000000 ; 000000590997035.022529000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000003658C27385CA38 >									
272 	//     < NBI_PFI_III_metadata_line_25_____grc_shenzhen_nantie_construction_supervision_co_20251101 >									
273 	//        < br22kqGwx4iaUO3LMuo4TZC579v0V3CTB9X41Hf3m9V88UxxePA8HLdNxRmtu1iH >									
274 	//        <  u =="0.000000000000000001" : ] 000000590997035.022529000000000000 ; 000000612391983.921288000000000000 ] >									
275 	//        < 0x00000000000000000000000000000000000000000000000000385CA383A66F9E >									
276 	//     < NBI_PFI_III_metadata_line_26_____grc_shenzhen_railway_station_passenger_services_co_20251101 >									
277 	//        < pVmd528YjNBaWY1TM6w0XinrN2llOY851LhJ40L8aTOSZ19uY3UW84HYTOb2F08N >									
278 	//        <  u =="0.000000000000000001" : ] 000000612391983.921288000000000000 ; 000000633649474.703632000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000003A66F9E3C6DF53 >									
280 	//     < NBI_PFI_III_metadata_line_27_____grc_shenzhen_jing_ming_industrial_commercial_co_ltd__20251101 >									
281 	//        < tOTg89sIUiILBuixJ6WtDy6enbrd4mrZOroSu3nKwDkcdD4Su3B46KOa3fHev7ne >									
282 	//        <  u =="0.000000000000000001" : ] 000000633649474.703632000000000000 ; 000000652707808.683539000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000003C6DF533E3F3FD >									
284 	//     < NBI_PFI_III_metadata_line_28_____grc_shenzhen_road_multi_modal_transportation_co_limited_20251101 >									
285 	//        < 06g1wIpsY2Z33iFLB8P6igZ2FRSW5ML3wWub33WZ2n3C47I60ED6141zrQ3y1uOs >									
286 	//        <  u =="0.000000000000000001" : ] 000000652707808.683539000000000000 ; 000000680302251.308073000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000003E3F3FD40E0F11 >									
288 	//     < NBI_PFI_III_metadata_line_29_____grc_guangzhou_railway_group_yangcheng_railway_enterprise_development_co_20251101 >									
289 	//        < Jld5N2858h6nlkuKzXzl0z1pFVx05Fs32ATribl80L1w2sg70uA7MTH876hOWg5i >									
290 	//        <  u =="0.000000000000000001" : ] 000000680302251.308073000000000000 ; 000000703534377.700583000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000040E0F11431821E >									
292 	//     < NBI_PFI_III_metadata_line_30_____grc_guangzhou_dongqun_advertising_company_limited_20251101 >									
293 	//        < kncqUXT64RhmXIO5EMM2iwX7H2zS5B4GQ15211r91JQ8xA8LT3C78AKBNM4GUa59 >									
294 	//        <  u =="0.000000000000000001" : ] 000000703534377.700583000000000000 ; 000000727896833.632598000000000000 ] >									
295 	//        < 0x00000000000000000000000000000000000000000000000000431821E456AEB3 >									
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
338 	//     < NBI_PFI_III_metadata_line_31_____grc_guangzhou_tielian_economy_development_co_ltd_20251101 >									
339 	//        < e96r32a4MWD9Kq7EWp732C148M1j809Fci3yL02xerjYrHLlzrqqUfT6RJzlQfut >									
340 	//        <  u =="0.000000000000000001" : ] 000000727896833.632598000000000000 ; 000000761926182.856663000000000000 ] >									
341 	//        < 0x00000000000000000000000000000000000000000000000000456AEB348A9B6A >									
342 	//     < NBI_PFI_III_metadata_line_32_____cr_guangzhou_group_guangzhou_railway_economic_technology_development_group_co_ltd_20251101 >									
343 	//        < U209C80difICrl8TFB2sYim6p8kbEJ67fk3QovZ0339nE3UzZIpn9zqcFM7m6MM1 >									
344 	//        <  u =="0.000000000000000001" : ] 000000761926182.856663000000000000 ; 000000788096241.434723000000000000 ] >									
345 	//        < 0x0000000000000000000000000000000000000000000000000048A9B6A4B28A18 >									
346 	//     < NBI_PFI_III_metadata_line_33_____guangzhou_railway_economic_tech_dev_group_co_ltd_shenzhen_guang_tie_civil_engineering_co_ltd_20251101 >									
347 	//        < 2Hy03QHp5zZ1EnNFARvrSqOkI9m46buOgWr1K9TeRfZ0FY8rU2219R6NyHoyD5lX >									
348 	//        <  u =="0.000000000000000001" : ] 000000788096241.434723000000000000 ; 000000815255971.121302000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000004B28A184DBFB5D >									
350 	//     < NBI_PFI_III_metadata_line_34_____cr_guangzhou_group_guangdong_sanmao_railway_limited_co_20251101 >									
351 	//        < 9e8481UZ85f1FEBm3OM2MiDhnvOy3SdmG5nRjq1DU2L8wigovVQD1nlFRpd6tVU0 >									
352 	//        <  u =="0.000000000000000001" : ] 000000815255971.121302000000000000 ; 000000840242506.534848000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000004DBFB5D5021BBB >									
354 	//     < NBI_PFI_III_metadata_line_35_____cr_guangzhou_group_guangmeishan_railway_limited_co_20251101 >									
355 	//        < Z0xi8YH5H0nR29111Q6oZEc8wJi99j1a5A5yB86utyN3h13gncwM1TJ5Zb4ZySfb >									
356 	//        <  u =="0.000000000000000001" : ] 000000840242506.534848000000000000 ; 000000865349897.269020000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000005021BBB5286B4E >									
358 	//     < NBI_PFI_III_metadata_line_36_____cr_guangzhou group guangshen railway enterprise development co._20251101 >									
359 	//        < k56n00VnA3D87AGNi5Fr23kXt5MK0cypU7Y95S577oRfT5vMHZdhv5SnBJEEfEm1 >									
360 	//        <  u =="0.000000000000000001" : ] 000000865349897.269020000000000000 ; 000000884633054.370914000000000000 ] >									
361 	//        < 0x000000000000000000000000000000000000000000000000005286B4E545D7C9 >									
362 	//     < NBI_PFI_III_metadata_line_37_____cr_guangzhou_group_guangzhou_railway_guangshen_railway_enterprise_development_co_20251101 >									
363 	//        < yIQNh7Up56ce153zK0TJALkiVK9s81M84GPh077Qy8901d2Ok71dMK3348oOCAk2 >									
364 	//        <  u =="0.000000000000000001" : ] 000000884633054.370914000000000000 ; 000000911330394.745720000000000000 ] >									
365 	//        < 0x00000000000000000000000000000000000000000000000000545D7C956E946F >									
366 	//     < NBI_PFI_III_metadata_line_38_____CRC_CR_Shanghai_group_20251101 >									
367 	//        < 6EmQrXB2eoksAFkmisOPA7F1LYs1QbNA7E42717AEy83uE5w4H86jWv5AKdK7BG9 >									
368 	//        <  u =="0.000000000000000001" : ] 000000911330394.745720000000000000 ; 000000939845958.899988000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000056E946F59A1754 >									
370 	//     < NBI_PFI_III_metadata_line_39_____CRC_CR_Jinan_group_20251101 >									
371 	//        < 2axTg1JbicwbHv46is63A68LVcxGLc59pMBH175r6AJ25m9Y71Bt3x5QZ28F0Ni7 >									
372 	//        <  u =="0.000000000000000001" : ] 000000939845958.899988000000000000 ; 000000964460918.626090000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000059A17545BFA68C >									
374 	//     < NBI_PFI_III_metadata_line_40_____cr_Jinan_group_sinorailbohai_train_ferry_co_ltd_20251101 >									
375 	//        < aRL08Gx8adrgb31Z3T65xQwYyhLT034cqs01e97JcsVrthbgj97oFRDQ8Q4XurFY >									
376 	//        <  u =="0.000000000000000001" : ] 000000964460918.626090000000000000 ; 000000990977811.237745000000000000 ] >									
377 	//        < 0x000000000000000000000000000000000000000000000000005BFA68C5E81CB5 >									
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