1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	NBI_PFII_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	NBI_PFII_III_883		"	;
8 		string	public		symbol =	"	NBI_PFII_III_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1059037558206030000000000000					;	
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
92 	//     < NBI_PFII_III_metadata_line_1_____CRC_CR_Beijing_group_20251101 >									
93 	//        < sDwxK0mI2f1au0jlCe3ry9WGX3scnPH1Y8CvY0NHmcE5YT7NIUr57Q2TJU1YY51W >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000018876926.687186400000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000001CCDCD >									
96 	//     < NBI_PFII_III_metadata_line_2_____CRC_CR_Qingzang_group_20251101 >									
97 	//        < M7i21MFFTSgRF5548mSFWLm8AakTf5z1D0Pw2Z3tMqF2lNH41MZC4k5fmXg1fvx2 >									
98 	//        <  u =="0.000000000000000001" : ] 000000018876926.687186400000000000 ; 000000038636098.197384900000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000001CCDCD3AF43A >									
100 	//     < NBI_PFII_III_metadata_line_3_____Chengdu_railway_bureau_20251101 >									
101 	//        < kS3J8E5BY27tChIpaP4nTcq01xe74h509gPd54pN3vQmx8q3FJS9IV8m69s5XA73 >									
102 	//        <  u =="0.000000000000000001" : ] 000000038636098.197384900000000000 ; 000000059041073.646919100000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000003AF43A5A16EB >									
104 	//     < NBI_PFII_III_metadata_line_4_____Chengdu_railway_bureau_Xianghu_20251101 >									
105 	//        < 3JeDw1B4ry9Ft9qW99kWmj72u8IM33Uz9a4w0Fz2RP7TZV6u2O6QA6ZDRPXxWPjI >									
106 	//        <  u =="0.000000000000000001" : ] 000000059041073.646919100000000000 ; 000000086634253.111281900000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000005A16EB843181 >									
108 	//     < NBI_PFII_III_metadata_line_5_____Chengdu_railway_bureau_Yanglao_jin_20251101 >									
109 	//        < aiW98lVY6an8xWKix6bDTM2YiXt2sUGfCN2K26RX0b5R1P1w49H1amRc18mQ65O3 >									
110 	//        <  u =="0.000000000000000001" : ] 000000086634253.111281900000000000 ; 000000109421966.414495000000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000843181A6F6F5 >									
112 	//     < NBI_PFII_III_metadata_line_6_____cr_Chengdu_group_chengdu_railway_bureau_xichang_railway_branch_20251101 >									
113 	//        < aG8R8IPZrwms3JPPtqPg9Q01muYvG24QhSLKQUgj28FDGm01S96c48C72Ge4gBM1 >									
114 	//        <  u =="0.000000000000000001" : ] 000000109421966.414495000000000000 ; 000000138187553.441702000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000A6F6F5D2DB83 >									
116 	//     < NBI_PFII_III_metadata_line_7_____CRC_CR_Urumqi_group_20251101 >									
117 	//        < 0V8QoYl3f7VdEuT1jdA0J2p515ujx8lGSq1E3AkGefdUT4w1Cm1kI8Ea4QZxksyA >									
118 	//        <  u =="0.000000000000000001" : ] 000000138187553.441702000000000000 ; 000000163858202.189055000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000D2DB83FA071C >									
120 	//     < NBI_PFII_III_metadata_line_8_____CRC_CR_Urumqi_group_Xianghu_20251101 >									
121 	//        < 4a936F0p2bCGSSOSrhygY7C9aQJh26EY9bXRE29qPPwo9X6js500cSG6Z151BHh1 >									
122 	//        <  u =="0.000000000000000001" : ] 000000163858202.189055000000000000 ; 000000185177441.759177000000000000 ] >									
123 	//        < 0x000000000000000000000000000000000000000000000000000FA071C11A8EF0 >									
124 	//     < NBI_PFII_III_metadata_line_9_____CRC_CR_Urumqi_group_Yanglao_jin_20251101 >									
125 	//        < 1VQ0U0v7btepi5CK88w8041b2Py0SF17B9DPp5W5m7E1795g64VzZ40n808JC8h7 >									
126 	//        <  u =="0.000000000000000001" : ] 000000185177441.759177000000000000 ; 000000208727744.725590000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000011A8EF013E7E46 >									
128 	//     < NBI_PFII_III_metadata_line_10_____CRC_CR_Zhengzhou_group_20251101 >									
129 	//        < 9JJ30p1uX2bhyTyiOt23pe47Sn2sGc4yjE46I995355izQ00MOEB8yqq9558460h >									
130 	//        <  u =="0.000000000000000001" : ] 000000208727744.725590000000000000 ; 000000240992274.188184000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000013E7E4616FB99B >									
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
174 	//     < NBI_PFII_III_metadata_line_11_____CRC_CR_Zhengzhou_group_Xianghu_20251101 >									
175 	//        < n34L95xm6yuK0csoVMFgmIYZ7ELO1CNgU9RhthT7998yrxraraCuVX2v4J3W5wE9 >									
176 	//        <  u =="0.000000000000000001" : ] 000000240992274.188184000000000000 ; 000000266461972.114262000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000016FB99B19696B5 >									
178 	//     < NBI_PFII_III_metadata_line_12_____CRC_CR_Zhengzhou_group_Yanglao_jin_20251101 >									
179 	//        < qc4C0H3Inh112b2zNy1VFJO5iEE7T1k71V7EvG5UuKig4c2fj5QoBT09xIIfPE9g >									
180 	//        <  u =="0.000000000000000001" : ] 000000266461972.114262000000000000 ; 000000301877236.979322000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000019696B51CCA0CC >									
182 	//     < NBI_PFII_III_metadata_line_13_____CRC_Shenyang_railways_bureau_20251101 >									
183 	//        < 18nl89oXD0O925iZd4e7256L8ze2O8O6O6UgTSDGx7G49vc76FV7TAFQN6EOg1n6 >									
184 	//        <  u =="0.000000000000000001" : ] 000000301877236.979322000000000000 ; 000000325158552.724442000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001CCA0CC1F0270F >									
186 	//     < NBI_PFII_III_metadata_line_14_____CRC_Shenyang_railways_bureau_Xianghu_20251101 >									
187 	//        < YkGS6UI61NrVc6o171c3stYvd6uHhzgOugqb85s5Ikq8YT2eSV76LokbCTMnbBVl >									
188 	//        <  u =="0.000000000000000001" : ] 000000325158552.724442000000000000 ; 000000353962125.704571000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000001F0270F21C1A75 >									
190 	//     < NBI_PFII_III_metadata_line_15_____CRC_Shenyang_railways_bureau_Yanglao_jin_20251101 >									
191 	//        < 36XORoavDNdBLVoCc3rESw53P2091357J8yA9M43nU3KtWtmx1It6yHFMp2586H2 >									
192 	//        <  u =="0.000000000000000001" : ] 000000353962125.704571000000000000 ; 000000376908228.284040000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000021C1A7523F1DC7 >									
194 	//     < NBI_PFII_III_metadata_line_16_____CRC_CR_Harbin_group_20251101 >									
195 	//        < O1R200wSDg4OuNm7eP5Rsthb7y8mPh0nC6zXkTDEtqZc3cT6d3O27d5nAJP2zEuR >									
196 	//        <  u =="0.000000000000000001" : ] 000000376908228.284040000000000000 ; 000000395493899.992103000000000000 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000000023F1DC725B79CE >									
198 	//     < NBI_PFII_III_metadata_line_17_____CRC_CR_Harbin_group_Xianghu_20251101 >									
199 	//        < s970SklnT1enrl0lon480p2cITWf7B6344oaFpd6RIIrOlh7GI0YY4eO4h6tbc2O >									
200 	//        <  u =="0.000000000000000001" : ] 000000395493899.992103000000000000 ; 000000415869289.878158000000000000 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000000025B79CE27A90F1 >									
202 	//     < NBI_PFII_III_metadata_line_18_____CRC_CR_Harbin_group_Yanglao_jin_20251101 >									
203 	//        < 5Wc1i2Ua8ycl7nwlmmr15xnA03BY1tqzB0fB7yD4ksg8ReudwIqbZrnYd5r6858Q >									
204 	//        <  u =="0.000000000000000001" : ] 000000415869289.878158000000000000 ; 000000450543574.333451000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000027A90F12AF7995 >									
206 	//     < NBI_PFII_III_metadata_line_19_____CRC_CR_Wuhan_group_20251101 >									
207 	//        < BNX04XbjVPj9K1T50I57mokV4zejeuSFq453ic14WW0fnyRMRk8r82E987s8MJL8 >									
208 	//        <  u =="0.000000000000000001" : ] 000000450543574.333451000000000000 ; 000000485856339.505658000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000002AF79952E55BA2 >									
210 	//     < NBI_PFII_III_metadata_line_20_____CRC_CR_Wuhan_group_Xianghu_20251101 >									
211 	//        < TtHfSQ4q529c5B88cIpVIqxEy2q4xJ8WB4nc7Pyc0N177S48TH7Q26141N2OnrnH >									
212 	//        <  u =="0.000000000000000001" : ] 000000485856339.505658000000000000 ; 000000518418203.223150000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000002E55BA23170B1C >									
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
256 	//     < NBI_PFII_III_metadata_line_21_____CRC_CR_Wuhan_group_Yanglao_jin_20251101 >									
257 	//        < 9C63p09anfWDK012WoMeDaz2m2UkhV1VWGxU15742vbT2dF6zq0cb8Eahh7V8P7E >									
258 	//        <  u =="0.000000000000000001" : ] 000000518418203.223150000000000000 ; 000000538454469.456659000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000003170B1C3359DC7 >									
260 	//     < NBI_PFII_III_metadata_line_22_____CRC_CR_Nanchang_group_20251101 >									
261 	//        < umZ3J09n820Q198sBkDa7L0hfx6UMUpt54OL49V28bmS5elqCl55jzgxa3vTYmn9 >									
262 	//        <  u =="0.000000000000000001" : ] 000000538454469.456659000000000000 ; 000000569970038.692980000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000003359DC7365B48C >									
264 	//     < NBI_PFII_III_metadata_line_23_____CRC_CR_Nanchang_group_Xianghu_20251101 >									
265 	//        < Xe8q7005bZEXhklRIyP1H1N3YLW05ymXpOkUxA7611sIpL460kwz74kxk3BjaTQE >									
266 	//        <  u =="0.000000000000000001" : ] 000000569970038.692980000000000000 ; 000000602881939.359929000000000000 ] >									
267 	//        < 0x00000000000000000000000000000000000000000000000000365B48C397ECC2 >									
268 	//     < NBI_PFII_III_metadata_line_24_____CRC_CR_Nanchang_group_Yanglao_jin_20251101 >									
269 	//        < RG3P55AtMfe0jePLNv1ed89r9v0HAK6sL25now8wCTo7MIVzI3Dud2C538QAbTL9 >									
270 	//        <  u =="0.000000000000000001" : ] 000000602881939.359929000000000000 ; 000000638138138.646447000000000000 ] >									
271 	//        < 0x00000000000000000000000000000000000000000000000000397ECC23CDB8B6 >									
272 	//     < NBI_PFII_III_metadata_line_25_____CRC_CR_Xi_an_group_20251101 >									
273 	//        < 8TcByTY3wfF5159Y6H5Y4EtDbPLjbRO5rZmh1GZ6i39jajeuqFSAYr41VIhh8etG >									
274 	//        <  u =="0.000000000000000001" : ] 000000638138138.646447000000000000 ; 000000662470190.110878000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000003CDB8B63F2D96B >									
276 	//     < NBI_PFII_III_metadata_line_26_____CRC_CR_Xi_an_group_Xianghu_20251101 >									
277 	//        < 2ngiFW64kQISSLps07AqQcm693vQsGSO9LbykO1xAv46Kam6O3y0QJbQ1zNXi3J2 >									
278 	//        <  u =="0.000000000000000001" : ] 000000662470190.110878000000000000 ; 000000683024910.672099000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000003F2D96B412369B >									
280 	//     < NBI_PFII_III_metadata_line_27_____CRC_CR_Xi_an_group_Yanglao_jin_20251101 >									
281 	//        < 9Uu2m4S79wyJ3FV7qNL8P9q2zLJ61GHCv8Cq63zsWi4zx1e7Cb6O1f9i1O5fN2j0 >									
282 	//        <  u =="0.000000000000000001" : ] 000000683024910.672099000000000000 ; 000000718369237.307448000000000000 ] >									
283 	//        < 0x00000000000000000000000000000000000000000000000000412369B44824FC >									
284 	//     < NBI_PFII_III_metadata_line_28_____CRC_CR_Taiyuan_group_20251101 >									
285 	//        < y136xi6b1O032Omo1H4OvIu3n274XNZMa3d7CWYPu7LEn3gIo16JdvMf55G7zDnK >									
286 	//        <  u =="0.000000000000000001" : ] 000000718369237.307448000000000000 ; 000000741676642.076521000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000044824FC46BB570 >									
288 	//     < NBI_PFII_III_metadata_line_29_____CRC_CR_Taiyuan_group_Xianghu_20251101 >									
289 	//        < 4sfzvsQ0sv37gho8xyQ3s9LMXmlgIThHhQ0K7lV6Y7t4ZA1Cr2dq0At21XC9P6m4 >									
290 	//        <  u =="0.000000000000000001" : ] 000000741676642.076521000000000000 ; 000000771675180.499817000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000046BB5704997B9E >									
292 	//     < NBI_PFII_III_metadata_line_30_____CRC_CR_Taiyuan_group_Yanglao_jin_20251101 >									
293 	//        < SLadL7b2Uwe0LL9KthCu7mP9WQJeQ7ccq1tq3mU6uWtjqg26rg1gRD052D9pR721 >									
294 	//        <  u =="0.000000000000000001" : ] 000000771675180.499817000000000000 ; 000000794989395.598212000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000004997B9E4BD0EBC >									
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
338 	//     < NBI_PFII_III_metadata_line_31_____CRC_CR_container_transport_corp_ltd_20251101 >									
339 	//        < pyaFVJI6Hbw6AXkXiXsmUKK0P0xACS9bDk56y4GgvK00D84yWVx3rtaIpWSZL3s8 >									
340 	//        <  u =="0.000000000000000001" : ] 000000794989395.598212000000000000 ; 000000814594816.948797000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000004BD0EBC4DAF91A >									
342 	//     < NBI_PFII_III_metadata_line_32_____cr_container_transport_corp_ltd_cr_international_multimodal_transport_co_ltd_20251101 >									
343 	//        < sq4eLq31Jh7JUsk5sF5ux6K6Rv1t736m4q2E7PHOkV3V3U9KBFwA1J7QkBQeop50 >									
344 	//        <  u =="0.000000000000000001" : ] 000000814594816.948797000000000000 ; 000000848648400.363664000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000004DAF91A50EEF48 >									
346 	//     < NBI_PFII_III_metadata_line_33_____cr_container_transport_corp_ltd_lanzhou_pacific_logistics_corp_ltd_20251101 >									
347 	//        < BHm29iMX79C0rk0j67XFMk23U37unDUY43EmUOm0176kp8Q01C11Iyax0XB2fRrl >									
348 	//        <  u =="0.000000000000000001" : ] 000000848648400.363664000000000000 ; 000000875416762.174326000000000000 ] >									
349 	//        < 0x0000000000000000000000000000000000000000000000000050EEF48537C7AC >									
350 	//     < NBI_PFII_III_metadata_line_34_____cr_corporation_china_railway_express_co_ltd_20251101 >									
351 	//        < MiS7IyZaz58IAc3R0H3mtSiyIUVY6Ht8W15HvS1Xd89YCXNOos154JLlW0xc20fE >									
352 	//        <  u =="0.000000000000000001" : ] 000000875416762.174326000000000000 ; 000000900311542.589389000000000000 ] >									
353 	//        < 0x00000000000000000000000000000000000000000000000000537C7AC55DC432 >									
354 	//     < NBI_PFII_III_metadata_line_35_____cr_corporation_china_railway_lanzhou_group_20251101 >									
355 	//        < Au0u9NIggfpcgq8kC8XvM3IeflMG1u9287Nx2ZG97T0SPs3aiFy2S525ic2Oq9mP >									
356 	//        <  u =="0.000000000000000001" : ] 000000900311542.589389000000000000 ; 000000931208442.688640000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000055DC43258CE94C >									
358 	//     < NBI_PFII_III_metadata_line_36_____Kunming_group_20251101 >									
359 	//        < bzgfQrIEevcebzWzSVI6PQb1oO52qQ6Vbfk6EeBb6g1Hc71Y0GrF4ZkUF8A4Nd3o >									
360 	//        <  u =="0.000000000000000001" : ] 000000931208442.688640000000000000 ; 000000952271108.086801000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000058CE94C5AD0CE7 >									
362 	//     < NBI_PFII_III_metadata_line_37_____CRC_china_railway_hohhot_group_20251101 >									
363 	//        < GiY6v9u9aAe6V4fNYTJE2i0un3LiE27E2yXfSlT3abw4JZ7F50672qDqxrcGa07F >									
364 	//        <  u =="0.000000000000000001" : ] 000000952271108.086801000000000000 ; 000000977988577.658646000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000005AD0CE75D44ACA >									
366 	//     < NBI_PFII_III_metadata_line_38_____CRC_china_railway_nanning_group_20251101 >									
367 	//        < ZZY4c3lZ24MQ5rGJlY9iKN0S7D1bLnP8MAEirQteNTtLM6b3e2hhrDP6JM6bx3O8 >									
368 	//        <  u =="0.000000000000000001" : ] 000000977988577.658646000000000000 ; 000001007453294.827300000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000005D44ACA6014071 >									
370 	//     < NBI_PFII_III_metadata_line_39_____CRC_nanning_guangzhou_railway_co_limited_20251101 >									
371 	//        < 89Vldy1Fi81N5ZmTxdksRi5Kf0dDyYnVq4J3t9p1lp3A8Uz9dl37lb99dy4TxZ0X >									
372 	//        <  u =="0.000000000000000001" : ] 000001007453294.827300000000000000 ; 000001040716481.878350000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000601407163401E0 >									
374 	//     < NBI_PFII_III_metadata_line_40_____CRC_high_speed_network_technology_co_20251101 >									
375 	//        < beTjS294178V2sYh45yO456y6YFej58Uh0c6v29mB257S99hQkQX6yb4qknd4np4 >									
376 	//        <  u =="0.000000000000000001" : ] 000001040716481.878350000000000000 ; 000001059037558.206030000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000063401E064FF68C >									
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