1 pragma solidity 		^0.4.25	;						
2 										
3 	contract	CHEMCHINA_PFII_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	CHEMCHINA_PFII_III_883		"	;
8 		string	public		symbol =	"	CHEMCHINA_PFII_III_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1233471162710430000000000000					;	
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
92 	//     < CHEMCHINA_PFII_III_metadata_line_1_____CHANGZHOU_WUJIN_LINCHUAN_CHEMICAL_Co_Limited_20260321 >									
93 	//        < 90inv6k06vpKywSfuJ99VU5qD48l2Rt0V19c4i60Ccb3GartvDo2Dr67zGy1P59u >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000028828776.266181900000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000002BFD3E >									
96 	//     < CHEMCHINA_PFII_III_metadata_line_2_____Chem_Stone_Co__Limited_20260321 >									
97 	//        < C639QNO430wzv1R1A2QHquo3pd0woH47o771XIYLl7BH733y7jgCwb9lFp5sOdm1 >									
98 	//        <  u =="0.000000000000000001" : ] 000000028828776.266181900000000000 ; 000000054710198.219915200000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000002BFD3E537B2C >									
100 	//     < CHEMCHINA_PFII_III_metadata_line_3_____Chemleader_Biomedical_Co_Limited_20260321 >									
101 	//        < saGKT78eLnH1JavPkwVZ0K1L41oC8bD620fPrY2r17EeyZ6MLWc3CJoEF3vHgQja >									
102 	//        <  u =="0.000000000000000001" : ] 000000054710198.219915200000000000 ; 000000078410385.399819100000000000 ] >									
103 	//        < 0x0000000000000000000000000000000000000000000000000000537B2C77A50F >									
104 	//     < CHEMCHINA_PFII_III_metadata_line_4_____Chemner_Pharma_20260321 >									
105 	//        < lB355RS4uh4VZ5Zk9F6rMz1AAqS9z6HoRm5T0w5ALaOGPa98b3qTNX84vsRgHnfs >									
106 	//        <  u =="0.000000000000000001" : ] 000000078410385.399819100000000000 ; 000000098703985.305163400000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000077A50F969C3F >									
108 	//     < CHEMCHINA_PFII_III_metadata_line_5_____Chemtour_Biotech__Suzhou__org_20260321 >									
109 	//        < ax8iAxb4Gu0YMwy80o5WxquC8EG1RvNZ08Zk32tM5jxzxXUh2raCJl8y84g5dEho >									
110 	//        <  u =="0.000000000000000001" : ] 000000098703985.305163400000000000 ; 000000123580423.736262000000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000969C3FBC919A >									
112 	//     < CHEMCHINA_PFII_III_metadata_line_6_____Chemtour_Biotech__Suzhou__Co__Ltd_20260321 >									
113 	//        < BOZo1vY3wqHj72Mp6wzyL4D70856MCk88UpR9lwQ99jK7tyZ0O0X3d537p5dDtBH >									
114 	//        <  u =="0.000000000000000001" : ] 000000123580423.736262000000000000 ; 000000152628942.944829000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000BC919AE8E4AE >									
116 	//     < CHEMCHINA_PFII_III_metadata_line_7_____Chemvon_Biotechnology_Co__Limited_20260321 >									
117 	//        < lsQwJjD8b61I9hJKx3WoWc59QMp559Z4BLWudv0s3TKhp2Yh1uLbDKnJh6XO7720 >									
118 	//        <  u =="0.000000000000000001" : ] 000000152628942.944829000000000000 ; 000000173214715.957492000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000000E8E4AE1084E00 >									
120 	//     < CHEMCHINA_PFII_III_metadata_line_8_____Chengdu_Aslee_Biopharmaceuticals,_inc__20260321 >									
121 	//        < i66DKrWqI0DV550V34B5Zp8hImO1b00CA5HGcKoKajj13YS6Sxj2R4ZMZyxrUK13 >									
122 	//        <  u =="0.000000000000000001" : ] 000000173214715.957492000000000000 ; 000000213990912.771307000000000000 ] >									
123 	//        < 0x000000000000000000000000000000000000000000000000001084E001468633 >									
124 	//     < CHEMCHINA_PFII_III_metadata_line_9_____Chuxiong_Yunzhi_Phytopharmaceutical_Co_Limited_20260321 >									
125 	//        < CL39PRRUp8H09ZQPB1k231Zv5jdADczo7Uq93VxoHYs9oUD1J1sMrzJ2n8sb7ihG >									
126 	//        <  u =="0.000000000000000001" : ] 000000213990912.771307000000000000 ; 000000236255451.388892000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000014686331687F49 >									
128 	//     < CHEMCHINA_PFII_III_metadata_line_10_____Conier_Chem_Pharma__Limited_20260321 >									
129 	//        < 2y2l4Zyq16KrL68zFarA8EBFWlKPzub9srnV2Wjx624bg5wuvpkPoAeT5iU3tXG6 >									
130 	//        <  u =="0.000000000000000001" : ] 000000236255451.388892000000000000 ; 000000271522148.537003000000000000 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000000001687F4919E4F57 >									
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
174 	//     < CHEMCHINA_PFII_III_metadata_line_11_____Cool_Pharm_Ltd_20260321 >									
175 	//        < I33LL2449666bDpPTHqA0ZoyNiTNqEMtzObaREfvu0TT1lEE5XvzOWB1lTh0V5E6 >									
176 	//        <  u =="0.000000000000000001" : ] 000000271522148.537003000000000000 ; 000000298389822.405030000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000019E4F571C74E86 >									
178 	//     < CHEMCHINA_PFII_III_metadata_line_12_____Coresyn_Pharmatech_Co__Limited_20260321 >									
179 	//        < G11iqs5klLAsr14s69MycBxYgXn8fVYoGO7WD1D2w1W7h6LV353756yyefY7zhJs >									
180 	//        <  u =="0.000000000000000001" : ] 000000298389822.405030000000000000 ; 000000337805610.142901000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000001C74E862037351 >									
182 	//     < CHEMCHINA_PFII_III_metadata_line_13_____Dalian_Join_King_Fine_Chemical_org_20260321 >									
183 	//        < 2fFU3I4LyVo9z5s6m8Olk9dF8AVhrD9g0GTRQRaCo87525SlqSM70J37OeP0WuMw >									
184 	//        <  u =="0.000000000000000001" : ] 000000337805610.142901000000000000 ; 000000371937024.847605000000000000 ] >									
185 	//        < 0x00000000000000000000000000000000000000000000000000203735123787E6 >									
186 	//     < CHEMCHINA_PFII_III_metadata_line_14_____Dalian_Join_King_Fine_Chemical_Co_Limited_20260321 >									
187 	//        < 2p5aZi203bJm7Lf8AKhFFB75f664L7dV22lMHh45QL09161RzMv6Vfv5Utk8o9k2 >									
188 	//        <  u =="0.000000000000000001" : ] 000000371937024.847605000000000000 ; 000000396838562.938544000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000023787E625D8710 >									
190 	//     < CHEMCHINA_PFII_III_metadata_line_15_____Dalian_Richfortune_Chemicals_Co_Limited_20260321 >									
191 	//        < x32Kl53H0wLHUC8Z55hsNqO88pgSN34SQlW7ctGmb52Jr7515q6uCtlChd6768FP >									
192 	//        <  u =="0.000000000000000001" : ] 000000396838562.938544000000000000 ; 000000430224959.851389000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000025D871029078A0 >									
194 	//     < CHEMCHINA_PFII_III_metadata_line_16_____Daming_Changda_Co_Limited__LLBCHEM__20260321 >									
195 	//        < 478mLl5Atzw0PlH2pobeHZ1I0550K2Pv0pm7rKAtzDnRjgmSSjKttC89x3cYF1pp >									
196 	//        <  u =="0.000000000000000001" : ] 000000430224959.851389000000000000 ; 000000463983042.405403000000000000 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000000029078A02C3FB60 >									
198 	//     < CHEMCHINA_PFII_III_metadata_line_17_____DATO_Chemicals_Co_Limited_20260321 >									
199 	//        < G17MZ6J8k3E7hOWdLFcKmn87jIGTJ9c84oiA9UF59I1vSGpE47gTXZ8drLLw5a9m >									
200 	//        <  u =="0.000000000000000001" : ] 000000463983042.405403000000000000 ; 000000494576450.282974000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000002C3FB602F2A9ED >									
202 	//     < CHEMCHINA_PFII_III_metadata_line_18_____DC_Chemicals_20260321 >									
203 	//        < 5VAiDN5t7X9lj9Z6JD5M9FgK2xk5lM6uc7F50R3E551X9PFa91c2BzjQYh3iUxB9 >									
204 	//        <  u =="0.000000000000000001" : ] 000000494576450.282974000000000000 ; 000000531483843.462587000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000002F2A9ED32AFAE0 >									
206 	//     < CHEMCHINA_PFII_III_metadata_line_19_____Depont_Molecular_Co_Limited_20260321 >									
207 	//        < 5GW1Z5Gs45u3EUOZ1qg1AI66OZA86z4yC2eab3J18Vh0hcbV2xjq8SC4ZKw1Tmu2 >									
208 	//        <  u =="0.000000000000000001" : ] 000000531483843.462587000000000000 ; 000000571035765.002583000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000000032AFAE036754D9 >									
210 	//     < CHEMCHINA_PFII_III_metadata_line_20_____DSL_Chemicals_Co_Ltd_20260321 >									
211 	//        < 8hyfD6bZ9ng9vr2X3A9pOHjqdqZOEh21A6WO06W1JwhGgNH9CwrdOb136O4mN8XR >									
212 	//        <  u =="0.000000000000000001" : ] 000000571035765.002583000000000000 ; 000000610557638.515528000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000036754D93A3A314 >									
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
256 	//     < CHEMCHINA_PFII_III_metadata_line_21_____Elsa_Biotechnology_org_20260321 >									
257 	//        < 3GyBK5S56PGPxzWWp3P9rU696dR43z9I153072Nwk6z2k0Yagx89G62dMY1B85I1 >									
258 	//        <  u =="0.000000000000000001" : ] 000000610557638.515528000000000000 ; 000000647436682.130835000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000003A3A3143DBE8F4 >									
260 	//     < CHEMCHINA_PFII_III_metadata_line_22_____Elsa_Biotechnology_Co_Limited_20260321 >									
261 	//        < 7gy21U9bN7XTnZDgAOXHq2G22aCR6d4h961NKc874mSDtFK7r2yTTX9N5C1s30Uv >									
262 	//        <  u =="0.000000000000000001" : ] 000000647436682.130835000000000000 ; 000000683536687.913348000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000003DBE8F4412FE85 >									
264 	//     < CHEMCHINA_PFII_III_metadata_line_23_____Enze_Chemicals_Co_Limited_20260321 >									
265 	//        < 5d1LA685AcPBYH7r3g7Bl8D4s2VU84D9i9cS3KLa4x6W0Xj3chah0f4jiENc33aW >									
266 	//        <  u =="0.000000000000000001" : ] 000000683536687.913348000000000000 ; 000000714103411.586029000000000000 ] >									
267 	//        < 0x00000000000000000000000000000000000000000000000000412FE85441A2A5 >									
268 	//     < CHEMCHINA_PFII_III_metadata_line_24_____EOS_Med_Chem_20260321 >									
269 	//        < WYr2JWGnOIleMs6q09tzK7hcz6z6G83gfZ3e8963M4PwR7AOtO9qaitchSHU9D0f >									
270 	//        <  u =="0.000000000000000001" : ] 000000714103411.586029000000000000 ; 000000740748556.299094000000000000 ] >									
271 	//        < 0x00000000000000000000000000000000000000000000000000441A2A546A4AE8 >									
272 	//     < CHEMCHINA_PFII_III_metadata_line_25_____EOS_Med_Chem_20260321 >									
273 	//        < 377MLWVf6Rp604899QJ26uFfw9Sh0lRbIIYgW17bh3l7c9mG23l888xAG4IcKZw9 >									
274 	//        <  u =="0.000000000000000001" : ] 000000740748556.299094000000000000 ; 000000761416331.716395000000000000 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000000000046A4AE8489D441 >									
276 	//     < CHEMCHINA_PFII_III_metadata_line_26_____ETA_ChemTech_Co_Ltd_20260321 >									
277 	//        < 1hK731zrr8pM3X52cXELrD3i2E8UmbvzJmmq2YWA5Z92w919CQiNJXO7pu5FE0S8 >									
278 	//        <  u =="0.000000000000000001" : ] 000000761416331.716395000000000000 ; 000000790456256.116042000000000000 ] >									
279 	//        < 0x00000000000000000000000000000000000000000000000000489D4414B623FA >									
280 	//     < CHEMCHINA_PFII_III_metadata_line_27_____FEIMING_CHEMICAL_LIMITED_20260321 >									
281 	//        < D79H04w6nkGWVAkJ7zv4WX656b97V3vvl2CRBZkShqi0aHQ4ak8kkKrPXCJaaOk1 >									
282 	//        <  u =="0.000000000000000001" : ] 000000790456256.116042000000000000 ; 000000828709478.825214000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000004B623FA4F082A4 >									
284 	//     < CHEMCHINA_PFII_III_metadata_line_28_____FINETECH_INDUSTRY_LIMITED_20260321 >									
285 	//        < 8Q90Xf2liNgk4En7m39Od3AA895tCuLr8FTP9MxkDV5Yjsz06zKX6IlapPfy7Y8W >									
286 	//        <  u =="0.000000000000000001" : ] 000000828709478.825214000000000000 ; 000000869525017.163127000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000004F082A452ECA36 >									
288 	//     < CHEMCHINA_PFII_III_metadata_line_29_____Finetech_Industry_Limited_20260321 >									
289 	//        < Yp9Ab562I2wr9lq8Ttm7XtJ48KeD98R97KI93Qb8S0OeoO5v99Favd2FOYiD5St5 >									
290 	//        <  u =="0.000000000000000001" : ] 000000869525017.163127000000000000 ; 000000906849388.298491000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000052ECA36567BE0B >									
292 	//     < CHEMCHINA_PFII_III_metadata_line_30_____Fluoropharm_org_20260321 >									
293 	//        < uXI2tJI7xf6hZ82LHm3199T35Tqvq8zw18n3EAhl742918xqhHZ377kO5OVZ7We8 >									
294 	//        <  u =="0.000000000000000001" : ] 000000906849388.298491000000000000 ; 000000942093128.459681000000000000 ] >									
295 	//        < 0x00000000000000000000000000000000000000000000000000567BE0B59D8521 >									
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
338 	//     < CHEMCHINA_PFII_III_metadata_line_31_____Fluoropharm_Co_Limited_20260321 >									
339 	//        < 96Czi3gK1g831N4hX0VreSJt0mmZ4OTi6Qn7i7LU714w1Z344PrXDMPHne3Mf7C0 >									
340 	//        <  u =="0.000000000000000001" : ] 000000942093128.459681000000000000 ; 000000966362793.623932000000000000 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000000000059D85215C28D77 >									
342 	//     < CHEMCHINA_PFII_III_metadata_line_32_____Fond_Chemical_Co_Limited_20260321 >									
343 	//        < 7k2f1h2i6TSUmiu6XqHyq9HND90hTsYk0d670N2I9IAL4z2l3A2gCRLGdAp72EUO >									
344 	//        <  u =="0.000000000000000001" : ] 000000966362793.623932000000000000 ; 000000986269415.126458000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000005C28D775E0ED7E >									
346 	//     < CHEMCHINA_PFII_III_metadata_line_33_____Gansu_Research_Institute_of_Chemical_Industry_20260321 >									
347 	//        < N5ak837JewyNyKVNSCJB9472s262m52r7JIW3vOyKEyq29R8GCBnMcdXi5TFe7P7 >									
348 	//        <  u =="0.000000000000000001" : ] 000000986269415.126458000000000000 ; 000001012621491.947880000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000005E0ED7E6092345 >									
350 	//     < CHEMCHINA_PFII_III_metadata_line_34_____GL_Biochem__Shanghai__Ltd__20260321 >									
351 	//        < 2BjwD9FYALI1ec44oA29XnS32oW9l8G1qWUb5s72944Br1dja81mSArMo42s1uul >									
352 	//        <  u =="0.000000000000000001" : ] 000001012621491.947880000000000000 ; 000001050963779.238490000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000006092345643A4BA >									
354 	//     < CHEMCHINA_PFII_III_metadata_line_35_____Guangzhou_Topwork_Chemical_Co__Limited_20260321 >									
355 	//        < AuPqPNpdMo0gCtE7Ph9E3325b0nP6NfP55vpRO6is4i8xxQG0W558Xzgg9w00Ru8 >									
356 	//        <  u =="0.000000000000000001" : ] 000001050963779.238490000000000000 ; 000001070951039.987690000000000000 ] >									
357 	//        < 0x00000000000000000000000000000000000000000000000000643A4BA6622440 >									
358 	//     < CHEMCHINA_PFII_III_metadata_line_36_____Hallochem_Pharma_Co_Limited_20260321 >									
359 	//        < nF5RqErwV05huis3PVaVutw9DB71SVi245ZmNjIfy9KI92Mv3QP7pY0IcA9c6B77 >									
360 	//        <  u =="0.000000000000000001" : ] 000001070951039.987690000000000000 ; 000001101778732.521560000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000066224406912E51 >									
362 	//     < CHEMCHINA_PFII_III_metadata_line_37_____Hanghzou_Fly_Source_Chemical_Co_Limited_20260321 >									
363 	//        < Z9dDUR2Urz0I5rqgPnR0NdxooqCq2VIPUg92LAv4qg6Z182bT7lb427z42fiAFmG >									
364 	//        <  u =="0.000000000000000001" : ] 000001101778732.521560000000000000 ; 000001132446349.283150000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000006912E516BFF9DB >									
366 	//     < CHEMCHINA_PFII_III_metadata_line_38_____Hangzhou_Best_Chemicals_Co__Limited_20260321 >									
367 	//        < kT5AmrOHPr7pBIQ5jTW78EBzI1iq1395Jp9MA4x3Y0AJSsAk7gWt3sxX1a8rS451 >									
368 	//        <  u =="0.000000000000000001" : ] 000001132446349.283150000000000000 ; 000001162839467.026950000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000006BFF9DB6EE5A2B >									
370 	//     < CHEMCHINA_PFII_III_metadata_line_39_____Hangzhou_Dayangchem_Co__Limited_20260321 >									
371 	//        < 780934dZ775p8uTOiMs9pM0p1z321p2FZ010ciPM8S6N79KY8k64MOZqT9ew7gA6 >									
372 	//        <  u =="0.000000000000000001" : ] 000001162839467.026950000000000000 ; 000001197409918.788960000000000000 ] >									
373 	//        < 0x000000000000000000000000000000000000000000000000006EE5A2B7231A40 >									
374 	//     < CHEMCHINA_PFII_III_metadata_line_40_____Hangzhou_Dayangchem_org_20260321 >									
375 	//        < 6U019BV0D221vlyYwZt00y237lsir091Orb1h91l9Fp0o1awG4f8kETOw4e0ehFY >									
376 	//        <  u =="0.000000000000000001" : ] 000001197409918.788960000000000000 ; 000001233471162.710430000000000000 ] >									
377 	//        < 0x000000000000000000000000000000000000000000000000007231A4075A20AC >									
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