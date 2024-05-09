1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXXIX_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXXIX_I_883		"	;
8 		string	public		symbol =	"	RUSS_PFXXIX_I_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		616531392402038000000000000					;	
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
92 	//     < RUSS_PFXXIX_I_metadata_line_1_____INGOSSTRAKH_ORG_20211101 >									
93 	//        < BH1X1k76Wpp9lqm2KQyMXhGHbD0g1z0xGYmq2hjNjJtpLx4hdu6GiOK9v1dZZxbN >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000014210952.520631200000000000 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000000015AF27 >									
96 	//     < RUSS_PFXXIX_I_metadata_line_2_____INGO_gbp_20211101 >									
97 	//        < 34G0STCwb0Jg5s1QHJP4QBISM8OR42uSI21Ss9mD2sZm2UoXubm9Z01U11M761yn >									
98 	//        <  u =="0.000000000000000001" : ] 000000014210952.520631200000000000 ; 000000029256073.684249200000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000015AF272CA427 >									
100 	//     < RUSS_PFXXIX_I_metadata_line_3_____INGO_usd_20211101 >									
101 	//        < qgHLxOI0k8PuD37u916sJs5myW5NM9bplO5aO031ImI7qd1471ov3iVPAtW7NlxL >									
102 	//        <  u =="0.000000000000000001" : ] 000000029256073.684249200000000000 ; 000000044281600.575053700000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000002CA427439180 >									
104 	//     < RUSS_PFXXIX_I_metadata_line_4_____INGO_chf_20211101 >									
105 	//        < zh1jwYEh8t19MFJp0T2m6GkQiy2FWMR3x0zKl8lEyEpk621kfZRRD8zI1b8ZijoC >									
106 	//        <  u =="0.000000000000000001" : ] 000000044281600.575053700000000000 ; 000000058254878.341270900000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000043918058E3D0 >									
108 	//     < RUSS_PFXXIX_I_metadata_line_5_____INGO_eur_20211101 >									
109 	//        < 6350674lX7t0x4Bp140H95L93tnnIIe3ipPN1O59e6IN80a00FW9Vm6n485Th744 >									
110 	//        <  u =="0.000000000000000001" : ] 000000058254878.341270900000000000 ; 000000073702245.389712800000000000 ] >									
111 	//        < 0x000000000000000000000000000000000000000000000000000058E3D07075F1 >									
112 	//     < RUSS_PFXXIX_I_metadata_line_6_____SIBAL_ORG_20211101 >									
113 	//        < nK9ud65198s2dS6xncf2Izo853cHU9Jq80wuAsQBG8ymNa84mmIW3LvLg92obKE7 >									
114 	//        <  u =="0.000000000000000001" : ] 000000073702245.389712800000000000 ; 000000089077818.879515700000000000 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000000000007075F187EC06 >									
116 	//     < RUSS_PFXXIX_I_metadata_line_7_____SIBAL_DAO_20211101 >									
117 	//        < eIrNB7xcn0lEkk2iQr82egj3Om9Y2uH87y2yft7B5N1w7b97BSLwQKW34r49pZ2r >									
118 	//        <  u =="0.000000000000000001" : ] 000000089077818.879515700000000000 ; 000000105009366.315430000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000000087EC06A03B49 >									
120 	//     < RUSS_PFXXIX_I_metadata_line_8_____SIBAL_DAOPI_20211101 >									
121 	//        < m25dlbmzqThk89UpN67tHvJetAXnOOjmvcQ3BwFCyY8KDDwtF6xzk57AzqEXczqE >									
122 	//        <  u =="0.000000000000000001" : ] 000000105009366.315430000000000000 ; 000000119834480.563417000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000A03B49B6DA58 >									
124 	//     < RUSS_PFXXIX_I_metadata_line_9_____SIBAL_DAC_20211101 >									
125 	//        < u5053n9ki3aoe1DG2rT1NuR6066H1FGHXupasFKcdeAu2R47ozIep53X74gEA2kb >									
126 	//        <  u =="0.000000000000000001" : ] 000000119834480.563417000000000000 ; 000000135625390.478353000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000000B6DA58CEF2AB >									
128 	//     < RUSS_PFXXIX_I_metadata_line_10_____SIBAL_BIMI_20211101 >									
129 	//        < 7C358v36iYon556wxPlm4deznJ9a7ncUQlJ4w9D1fLAM6I2R4tG12bB56H3oU8rI >									
130 	//        <  u =="0.000000000000000001" : ] 000000135625390.478353000000000000 ; 000000151214386.524065000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000000CEF2ABE6BC1F >									
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
174 	//     < RUSS_PFXXIX_I_metadata_line_11_____INGO_ARMENIA_20211101 >									
175 	//        < S6v00srri89SyMCrtrv6swj9v4F9VM8kMjI8EX4MCIBlk3X93EAFtpV5rpeHSz49 >									
176 	//        <  u =="0.000000000000000001" : ] 000000151214386.524065000000000000 ; 000000167808665.985217000000000000 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000000000E6BC1F1000E43 >									
178 	//     < RUSS_PFXXIX_I_metadata_line_12_____INGO_INSURANCE_COMPANY_20211101 >									
179 	//        < mq9YarT8tuc913xrE995qQv16e2W3n355j17QoE7eT95yb27NvBo2W1iDg5ea7us >									
180 	//        <  u =="0.000000000000000001" : ] 000000167808665.985217000000000000 ; 000000182548546.229679000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000001000E431168C07 >									
182 	//     < RUSS_PFXXIX_I_metadata_line_13_____ONDD_CREDIT_INSURANCE_20211101 >									
183 	//        < yP3cJwoM4LROjeAI1aQW9u6mL8qp0t2S62424KUY1V3X6kZ7UTcgC5ahy6h5nTPS >									
184 	//        <  u =="0.000000000000000001" : ] 000000182548546.229679000000000000 ; 000000198020177.355698000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001168C0712E27A2 >									
186 	//     < RUSS_PFXXIX_I_metadata_line_14_____BANK_SOYUZ_INGO_20211101 >									
187 	//        < KcIr5DQrBkh0tDT28o8M0D6Dx8aF2cZ2ZlIS7N46OPnw9X06Tu0L62OD361EY0o3 >									
188 	//        <  u =="0.000000000000000001" : ] 000000198020177.355698000000000000 ; 000000214945777.592554000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000012E27A2147FB32 >									
190 	//     < RUSS_PFXXIX_I_metadata_line_15_____CHREZVYCHAJNAYA_STRAKHOVAYA_KOMP_20211101 >									
191 	//        < B8m85Su1S3LLp6gbe9BL92D5U9YQAS4SM4M6Ld2XJI242N1VzDrR5uhxvT7Pllj6 >									
192 	//        <  u =="0.000000000000000001" : ] 000000214945777.592554000000000000 ; 000000230631935.905319000000000000 ] >									
193 	//        < 0x00000000000000000000000000000000000000000000000000147FB3215FEA9A >									
194 	//     < RUSS_PFXXIX_I_metadata_line_16_____ONDD_ORG_20211101 >									
195 	//        < K1134ZQr29A0C64xTQGq8vN8BG17S23tRKQ4u8XXZ96A7bXqwTR30199oAwd57kZ >									
196 	//        <  u =="0.000000000000000001" : ] 000000230631935.905319000000000000 ; 000000247462518.300801000000000000 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000000015FEA9A179990C >									
198 	//     < RUSS_PFXXIX_I_metadata_line_17_____ONDD_DAO_20211101 >									
199 	//        < Vq8fIGR245GJPUfR3D548Z99p0rYe8C3OP9BOQ66BBiBy26RxN4LbXEKo446bWQH >									
200 	//        <  u =="0.000000000000000001" : ] 000000247462518.300801000000000000 ; 000000261198985.970794000000000000 ] >									
201 	//        < 0x00000000000000000000000000000000000000000000000000179990C18E8EDB >									
202 	//     < RUSS_PFXXIX_I_metadata_line_18_____ONDD_DAOPI_20211101 >									
203 	//        < t3sRpo0WP0TpKxyMZ91Rv18c41FPb909heh3Z24WScY2w7FeWxPPCgGdI5kLuDF8 >									
204 	//        <  u =="0.000000000000000001" : ] 000000261198985.970794000000000000 ; 000000275295995.901124000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000018E8EDB1A41180 >									
206 	//     < RUSS_PFXXIX_I_metadata_line_19_____ONDD_DAC_20211101 >									
207 	//        < E0ioTdzGFIg6CWm0eZWjq51d3B0h5421yw1hSmTWp1yzxyuwe45jeWYITF85Zg7n >									
208 	//        <  u =="0.000000000000000001" : ] 000000275295995.901124000000000000 ; 000000291251657.902224000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000001A411801BC6A2E >									
210 	//     < RUSS_PFXXIX_I_metadata_line_20_____ONDD_BIMI_20211101 >									
211 	//        < 1j90Jb7Z19itHOpX4w8h0LaLl7N0TCcRl52wuIm4BP93kZyHlScE8D9f7DV84Dly >									
212 	//        <  u =="0.000000000000000001" : ] 000000291251657.902224000000000000 ; 000000306969699.111472000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000001BC6A2E1D4660A >									
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
256 	//     < RUSS_PFXXIX_I_metadata_line_21_____SOYUZ_ORG_20211101 >									
257 	//        < Lxj8XZt25Lhb0404PfSqCvaq9zyzKwQ7FbRT0530PzLv9tx38NRztAN0uaz3lwjT >									
258 	//        <  u =="0.000000000000000001" : ] 000000306969699.111472000000000000 ; 000000322494275.791036000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000001D4660A1EC1654 >									
260 	//     < RUSS_PFXXIX_I_metadata_line_22_____SOYUZ_DAO_20211101 >									
261 	//        < cEMXsDCNYk2eiV4M3s7waCy2GF9v8MO7KJ7QdAx11G94Eig3jk3Hete7d94Hlk35 >									
262 	//        <  u =="0.000000000000000001" : ] 000000322494275.791036000000000000 ; 000000335886634.086983000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000001EC165420085B7 >									
264 	//     < RUSS_PFXXIX_I_metadata_line_23_____SOYUZ_DAOPI_20211101 >									
265 	//        < 1uAmOVNHx9X196ecoQmD41PyTeUJezRO8X8V9HrF7Zgs4wdH6nIpC38p3Ri78c5O >									
266 	//        <  u =="0.000000000000000001" : ] 000000335886634.086983000000000000 ; 000000352145251.630674000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000020085B721954BD >									
268 	//     < RUSS_PFXXIX_I_metadata_line_24_____SOYUZ_DAC_20211101 >									
269 	//        < zsGWx842e9x4Pc2Xp4N3fu6cvUcy4B80k6zI9B1g5tBBt6SHVHrz6CEgSbUV0Knp >									
270 	//        <  u =="0.000000000000000001" : ] 000000352145251.630674000000000000 ; 000000365469055.845186000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000021954BD22DA95A >									
272 	//     < RUSS_PFXXIX_I_metadata_line_25_____SOYUZ_BIMI_20211101 >									
273 	//        < K68nm8C64xar6gq2PF7beid9Zd82OF4Ux6sZnU656b4xB888PwiP02mC9B29V45M >									
274 	//        <  u =="0.000000000000000001" : ] 000000365469055.845186000000000000 ; 000000380654149.603055000000000000 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000000000022DA95A244D507 >									
276 	//     < RUSS_PFXXIX_I_metadata_line_26_____PIFAGOR_AM_20211101 >									
277 	//        < upn2QYCuZfhNbVfVqT30T1fcDxt34ASGux8GKaoGqPS3IVB5JN2eMO9WP0Skifc1 >									
278 	//        <  u =="0.000000000000000001" : ] 000000380654149.603055000000000000 ; 000000397275196.557260000000000000 ] >									
279 	//        < 0x00000000000000000000000000000000000000000000000000244D50725E31A0 >									
280 	//     < RUSS_PFXXIX_I_metadata_line_27_____SK_INGO_LMT_20211101 >									
281 	//        < NfvLyIZn4kbiWug4lY34nw1xxvIoZnIs0G52Unw9rU6lR309abk1f2kbBdwoG1HD >									
282 	//        <  u =="0.000000000000000001" : ] 000000397275196.557260000000000000 ; 000000413307745.823477000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000025E31A0276A857 >									
284 	//     < RUSS_PFXXIX_I_metadata_line_28_____AKVAMARIN_20211101 >									
285 	//        < R0cG36EtDEVrD6k433EnC8hi0WBf6w6EhRh53H0ZHK3AK6Su0i069lT6TGuH36jL >									
286 	//        <  u =="0.000000000000000001" : ] 000000413307745.823477000000000000 ; 000000427762198.452989000000000000 ] >									
287 	//        < 0x00000000000000000000000000000000000000000000000000276A85728CB69C >									
288 	//     < RUSS_PFXXIX_I_metadata_line_29_____INVEST_POLIS_20211101 >									
289 	//        < pM34ail462j2L7F0A5PQw2061Qf10RaV2AKV7qrpoE2318YD8aOc0QAfo56YJ16v >									
290 	//        <  u =="0.000000000000000001" : ] 000000427762198.452989000000000000 ; 000000443990974.970767000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000028CB69C2A579F9 >									
292 	//     < RUSS_PFXXIX_I_metadata_line_30_____INGOSSTRAKH_LIFE_INSURANCE_CO_20211101 >									
293 	//        < GgUCa80ZND456554VEBCg85STP7P6CMC28tn682c5q126zVK2f56afNUTvbG0pz4 >									
294 	//        <  u =="0.000000000000000001" : ] 000000443990974.970767000000000000 ; 000000461036994.342674000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000002A579F92BF7C93 >									
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
338 	//     < RUSS_PFXXIX_I_metadata_line_31_____SIBAL_gbp_20211101 >									
339 	//        < H8qxzyV3vxpPSytI0d19k3015ePE33Zz9jeWZJJ9ZQM7Boc29vphh3xaW5K9F1PV >									
340 	//        <  u =="0.000000000000000001" : ] 000000461036994.342674000000000000 ; 000000476925236.189874000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000002BF7C932D7BAEC >									
342 	//     < RUSS_PFXXIX_I_metadata_line_32_____SIBAL_PENSII_20211101 >									
343 	//        < RXc20Kj3J071HyY7es3Jr99R0N67iETbB58ONeT829UCS43V8P6Q2z34B609T7MP >									
344 	//        <  u =="0.000000000000000001" : ] 000000476925236.189874000000000000 ; 000000491285421.027067000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000002D7BAEC2EDA45E >									
346 	//     < RUSS_PFXXIX_I_metadata_line_33_____SOYUZ_gbp_20211101 >									
347 	//        < z1e5JIc796u45oZb8w89T2z7eE2xu08VDK1f3vWmBKO53t2FjDwoQ78017IRjcel >									
348 	//        <  u =="0.000000000000000001" : ] 000000491285421.027067000000000000 ; 000000505983540.213087000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000002EDA45E30411D2 >									
350 	//     < RUSS_PFXXIX_I_metadata_line_34_____SOYUZ_PENSII_20211101 >									
351 	//        < 6XX1XmErI6omNa7B480RB84ZX2r2dwqDIx2ebBctN5dhL5X0Vv9K2a7EC19z0G5q >									
352 	//        <  u =="0.000000000000000001" : ] 000000505983540.213087000000000000 ; 000000522725338.971500000000000000 ] >									
353 	//        < 0x0000000000000000000000000000000000000000000000000030411D231D9D96 >									
354 	//     < RUSS_PFXXIX_I_metadata_line_35_____PIFAGOR_gbp_20211101 >									
355 	//        < TQ6lRXrOID0S24hy8AYJy47a6Fpz87iRq845ZV6Z5sTJy7Ne51qEv14hq53D4UG8 >									
356 	//        <  u =="0.000000000000000001" : ] 000000522725338.971500000000000000 ; 000000538596183.432827000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000031D9D96335D522 >									
358 	//     < RUSS_PFXXIX_I_metadata_line_36_____PIFAGOR_PENSII_20211101 >									
359 	//        < ibgSo1DdOuTaT26h2iv44n1MlkTU8CruscnrpORf9a5Y842U7JVyZCfNa045vFB0 >									
360 	//        <  u =="0.000000000000000001" : ] 000000538596183.432827000000000000 ; 000000554429314.782523000000000000 ] >									
361 	//        < 0x00000000000000000000000000000000000000000000000000335D52234DFDF3 >									
362 	//     < RUSS_PFXXIX_I_metadata_line_37_____AKVAMARIN_gbp_20211101 >									
363 	//        < nOK6xOab048D2Z3ce54fB2a7ZqrX4w8arLJ5OfFcm25fQlsGG813EUT8KK8T54do >									
364 	//        <  u =="0.000000000000000001" : ] 000000554429314.782523000000000000 ; 000000569877700.512522000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000034DFDF3365907A >									
366 	//     < RUSS_PFXXIX_I_metadata_line_38_____AKVAMARIN_PENSII_20211101 >									
367 	//        < 00I0dnW02GSsYbOyM4X90J1z3qxqw6j7M025HSF9id3I8XHNrt2V5UDJdKIzwA8E >									
368 	//        <  u =="0.000000000000000001" : ] 000000569877700.512522000000000000 ; 000000586637059.191222000000000000 ] >									
369 	//        < 0x00000000000000000000000000000000000000000000000000365907A37F231A >									
370 	//     < RUSS_PFXXIX_I_metadata_line_39_____POLIS_gbp_20211101 >									
371 	//        < 1rCRex03pZ2626IQ784tug2ZgO06v9yg2twSpU5DGh906K70f0k1q2We7uYl9G2o >									
372 	//        <  u =="0.000000000000000001" : ] 000000586637059.191222000000000000 ; 000000601743113.152580000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000037F231A3962FE7 >									
374 	//     < RUSS_PFXXIX_I_metadata_line_40_____POLIS_PENSII_20211101 >									
375 	//        < rS454FcPvZGOxzqIyymS7uHEW142c417N3rGlrku531mIK9vqehC3l8ws3N6lV44 >									
376 	//        <  u =="0.000000000000000001" : ] 000000601743113.152580000000000000 ; 000000616531392.402038000000000000 ] >									
377 	//        < 0x000000000000000000000000000000000000000000000000003962FE73ACC093 >									
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