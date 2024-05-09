1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RE_Portfolio_XVI_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RE_Portfolio_XVI_883		"	;
8 		string	public		symbol =	"	RE883XVI		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1518764476488520000000000000					;	
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
92 	//     < RE_Portfolio_XVI_metadata_line_1_____Provider_Risk_20250515 >									
93 	//        < 24hVSNw6R0B3SOE6kGgYW4BYrvsU09QWWc058rDnFt6P9eR84qE4jD30Yp6ggeeH >									
94 	//        < 1E-018 limites [ 1E-018 ; 10610077,0219288 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000003F3DB34A >									
96 	//     < RE_Portfolio_XVI_metadata_line_2_____Prudential_Ins_Co_of_America_AAm_Ap_20250515 >									
97 	//        < wDSn10jI3qqfyMDfEPQ6daDJTGQ3w0rcLOduS27NvynS124USFwcy3xpx03xHC5j >									
98 	//        < 1E-018 limites [ 10610077,0219288 ; 42558100,173885 ] >									
99 	//        < 0x0000000000000000000000000000000000000000000000003F3DB34AFDAA83D5 >									
100 	//     < RE_Portfolio_XVI_metadata_line_3_____PTA_Reinsurance_20250515 >									
101 	//        < DJtm4EX1G3v8S3Sad4j1QEWT5mGsXbq679w0m7LOEkSh66lB6X81o0tXj2w526f6 >									
102 	//        < 1E-018 limites [ 42558100,173885 ; 53446628,327494 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000FDAA83D513E911724 >									
104 	//     < RE_Portfolio_XVI_metadata_line_4_____PXRE_Reinsurance_Company_20250515 >									
105 	//        < 5g5T6H2e0MJ1c92n3oN1uNTmmE200v3jV9cqRkT09t6Xya4X8kv97c37ma778NFS >									
106 	//        < 1E-018 limites [ 53446628,327494 ; 89413898,8703253 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000013E911724214F2CA33 >									
108 	//     < RE_Portfolio_XVI_metadata_line_5_____Qatar_General_Insurance_and_Reinsurance_Company_SAQ_m_Am_20250515 >									
109 	//        < jYyUzkcxoyC62Bdyh8E68Nkg82YuaN24i7ERUvbCwaReN932jCAE4fN0ueh5o5i6 >									
110 	//        < 1E-018 limites [ 89413898,8703253 ; 121272137,742799 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000214F2CA332D2D69AC2 >									
112 	//     < RE_Portfolio_XVI_metadata_line_6_____Qatar_Insurance_Co_SAQ_A_A_20250515 >									
113 	//        < wLzMSZ2IE37Iu7cUSdkshkLhkSqmzMz0Xk253l4eq4H4Cuk3XwGbAm7nGh6M9ET7 >									
114 	//        < 1E-018 limites [ 121272137,742799 ; 145669503,291727 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000002D2D69AC23644207AD >									
116 	//     < RE_Portfolio_XVI_metadata_line_7_____Qatar_Reinsurance_20250515 >									
117 	//        < sy9n16U8t713ewMCpnTonS9HJc6hu78vl41WcQz8V4k4f8M3Jy35CY8FXJujIFD3 >									
118 	//        < 1E-018 limites [ 145669503,291727 ; 196247332,457158 ] >									
119 	//        < 0x00000000000000000000000000000000000000000000003644207AD491B9AC31 >									
120 	//     < RE_Portfolio_XVI_metadata_line_8_____Qatar_Reinsurance_Company_Limited_A_20250515 >									
121 	//        < BVqenG95Szq4b30y0TJ98XUZ50K93awdRPQnVC1N4MDH0Z4r683QCXYwea3m7cJt >									
122 	//        < 1E-018 limites [ 196247332,457158 ; 272679244,427854 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000491B9AC316594B83CE >									
124 	//     < RE_Portfolio_XVI_metadata_line_9_____Qatar_Reinsurance_Company_Limited_A_m_20250515 >									
125 	//        < 72dwX50Y1a4W6hW1En6m033HCzn13j3aHvdEq56v7THHqRx2Y89z4iYRD7LmPU3x >									
126 	//        < 1E-018 limites [ 272679244,427854 ; 354091750,960496 ] >									
127 	//        < 0x00000000000000000000000000000000000000000000006594B83CE83E8D242C >									
128 	//     < RE_Portfolio_XVI_metadata_line_10_____QBE Underwriting_Limited_20250515 >									
129 	//        < LDq1359FY7413VyOfWqR16kwVx4qQ0m48u13fl5dNgoAw14KgB73T2a5ouKaqGv7 >									
130 	//        < 1E-018 limites [ 354091750,960496 ; 393495530,392016 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000083E8D242C9296A8983 >									
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
174 	//     < RE_Portfolio_XVI_metadata_line_11_____QBE_Insurance__Europe__Limited_Ap_A_20250515 >									
175 	//        < 9aKin7bTm4f5bCW3iBjrH954zOh9a25nJg2U86469Q30GLBN6qiLOx3N9uM8x15H >									
176 	//        < 1E-018 limites [ 393495530,392016 ; 414796047,185251 ] >									
177 	//        < 0x00000000000000000000000000000000000000000000009296A89839A8608BE2 >									
178 	//     < RE_Portfolio_XVI_metadata_line_12_____QBE_Insurance_Group_Limited_20250515 >									
179 	//        < 4TG1fy8Iv63QhWxd67H98khBT6cmUgoS7Z2lC74Iz7j605p9VQ61v8sDKFNcSETM >									
180 	//        < 1E-018 limites [ 414796047,185251 ; 427418413,988585 ] >									
181 	//        < 0x00000000000000000000000000000000000000000000009A8608BE29F39CBFEA >									
182 	//     < RE_Portfolio_XVI_metadata_line_13_____QBE_Insurance_Group_Limited_20250515 >									
183 	//        < HXTxOFOui5vWqwP93udKcXmfyAspps9amB3qNH05ANVnt767nZPBGzG14U1ggCc7 >									
184 	//        < 1E-018 limites [ 427418413,988585 ; 448896235,243965 ] >									
185 	//        < 0x00000000000000000000000000000000000000000000009F39CBFEAA73A14DD8 >									
186 	//     < RE_Portfolio_XVI_metadata_line_14_____QBE_Insurance_Group_Limited_20250515 >									
187 	//        < nX8U913JAMD57zhg7bc7k6KYj0yEQf53w8wRMc4vAZA7tcdQ87bw6IeQ8Z3xDypc >									
188 	//        < 1E-018 limites [ 448896235,243965 ; 515995848,11175 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000A73A14DD8C0393301F >									
190 	//     < RE_Portfolio_XVI_metadata_line_15_____QBE_Re__Europe__Limited_Ap_A_20250515 >									
191 	//        < km5jkPGAUCuH1yAcfiwR81Q2iQ5O87eevr7vHChX3561r7Kta8VYv91Gf9kQu8LS >									
192 	//        < 1E-018 limites [ 515995848,11175 ; 549754145,161276 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000C0393301FCCCCA42E8 >									
194 	//     < RE_Portfolio_XVI_metadata_line_16_____QBE_Underwriting_Limited_20250515 >									
195 	//        < bDH3xZ3Bs15HA73h7cq393q5XwwOZltm6bO76diM6iyX6uNsL41r7o0TVOl5yX5E >									
196 	//        < 1E-018 limites [ 549754145,161276 ; 607961740,947483 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000CCCCA42E8E27BC0102 >									
198 	//     < RE_Portfolio_XVI_metadata_line_17_____QBE_Underwriting_Limited_20250515 >									
199 	//        < bzBAPX4nNEMo354TP2D81c6eVFzn78E902t29w555S51t3EaVBNnvVPrM5dNlWjv >									
200 	//        < 1E-018 limites [ 607961740,947483 ; 675220039,982088 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000E27BC0102FB8A00612 >									
202 	//     < RE_Portfolio_XVI_metadata_line_18_____QBE_Underwriting_Limited_20250515 >									
203 	//        < 0JqwcwTwVe6Wv0K0KFRTbYBHwtBQ9NXiIfGP3gqc683uwxrUgC3v33FrxYvJF56i >									
204 	//        < 1E-018 limites [ 675220039,982088 ; 714932159,768788 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000FB8A0061210A553E8DC >									
206 	//     < RE_Portfolio_XVI_metadata_line_19_____QBE_Underwriting_Limited_20250515 >									
207 	//        < EgI5eayP1L39Xgpsd7qVOCLKTG2CM80gS5FvhMJ914DW077RAmfl9D825hCZip3l >									
208 	//        < 1E-018 limites [ 714932159,768788 ; 763820373,710236 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000010A553E8DC11C8B9676F >									
210 	//     < RE_Portfolio_XVI_metadata_line_20_____QBE_Underwriting_Limited_20250515 >									
211 	//        < 964za98ZC5a3oMRizLkENph27Qw98WF6OdR44EzBN0AsscYCvuSo6pMF8KmpOih7 >									
212 	//        < 1E-018 limites [ 763820373,710236 ; 796123601,236996 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000011C8B9676F12894437AF >									
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
256 	//     < RE_Portfolio_XVI_metadata_line_21_____QBE_Underwriting_Limited_20250515 >									
257 	//        < 7atz2Hwm3437gXZ1413kQW21A5db2K593IiIzH7wR2F9i0fuXbCn1b151Zx4R691 >									
258 	//        < 1E-018 limites [ 796123601,236996 ; 840719500,617993 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000012894437AF13931428E1 >									
260 	//     < RE_Portfolio_XVI_metadata_line_22_____QBE_Underwriting_Limited_20250515 >									
261 	//        < Q7n9RM15dOMlX5BTq4vG55XeX54f6Z26ky21YsUxm34rbnc12h2M7kqRzCfFr6R1 >									
262 	//        < 1E-018 limites [ 840719500,617993 ; 855758886,63015 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000013931428E113ECB8710B >									
264 	//     < RE_Portfolio_XVI_metadata_line_23_____QBE_Underwriting_Limited_20250515 >									
265 	//        < CPg5DZ6eZvU7bDY86mP0p0m6UF01H5jW1Wo9GG15cHJoYRuJn73m4dRMxM7W2U7R >									
266 	//        < 1E-018 limites [ 855758886,63015 ; 875002577,280056 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000013ECB8710B145F6BFBB4 >									
268 	//     < RE_Portfolio_XVI_metadata_line_24_____R_J_Kiln_and_Co_Limited_20250515 >									
269 	//        < OB8G5l3eY10mJp85G4i9ozEc4TfPymDt2Y30ILy3fR48s34zxpLnv8I45g5fVd76 >									
270 	//        < 1E-018 limites [ 875002577,280056 ; 890839652,912361 ] >									
271 	//        < 0x00000000000000000000000000000000000000000000145F6BFBB414BDD1715F >									
272 	//     < RE_Portfolio_XVI_metadata_line_25_____R_J_Kiln_and_Co_Limited_20250515 >									
273 	//        < SfEj85wBHRC4DBHwRb2Ha1IM540k3xNQ6YQF7210tQ7w2LPK2aKbZiG89Uq0A2e8 >									
274 	//        < 1E-018 limites [ 890839652,912361 ; 906489267,563774 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000014BDD1715F151B18DC18 >									
276 	//     < RE_Portfolio_XVI_metadata_line_26_____R_J_Kiln_and_Co_Limited_20250515 >									
277 	//        < RMG9sQwufaRhYoTSODbr0lmmbe5W1lCmoxVfqg08O3AIM5yvdqb3jTp5aeWu2O2Z >									
278 	//        < 1E-018 limites [ 906489267,563774 ; 960590931,886529 ] >									
279 	//        < 0x00000000000000000000000000000000000000000000151B18DC18165D9172B8 >									
280 	//     < RE_Portfolio_XVI_metadata_line_27_____R_J_Kiln_and_Co_Limited        _20250515 >									
281 	//        < I59st9WAk84j82W5A7WTV176r8HPX9285zk04Y7815JR07ciU0e29eI6m2Gsh427 >									
282 	//        < 1E-018 limites [ 960590931,886529 ; 1041700687,55752 ] >									
283 	//        < 0x00000000000000000000000000000000000000000000165D9172B81841051D07 >									
284 	//     < RE_Portfolio_XVI_metadata_line_28_____R_p_V_Versicherung_AG_AAm_m_20250515 >									
285 	//        < 8p023EZh4q92maVlW7j2AraOTdFVvo1tQuLxPs155vxouDpeaML7yfASC6Qw4qnk >									
286 	//        < 1E-018 limites [ 1041700687,55752 ; 1077004986,2118 ] >									
287 	//        < 0x000000000000000000000000000000000000000000001841051D0719137332B1 >									
288 	//     < RE_Portfolio_XVI_metadata_line_29_____RandQ_Managing_Agency_Limited_20250515 >									
289 	//        < F5o4UEt490Jp44loI6W058y7EZEg5ONHCI2Uc8h96tDs1ofNB4HCl521fzB1S63e >									
290 	//        < 1E-018 limites [ 1077004986,2118 ; 1090803126,34613 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000019137332B11965B17D2E >									
292 	//     < RE_Portfolio_XVI_metadata_line_30_____RandQ_Managing_Agency_Limited_20250515 >									
293 	//        < bncLhihB8M2x2NS9wc9Sn86flL5qY1V6m6lMwG8101IY7FCROWO3Hda5dwr3BQBi >									
294 	//        < 1E-018 limites [ 1090803126,34613 ; 1108634722,3514 ] >									
295 	//        < 0x000000000000000000000000000000000000000000001965B17D2E19CFFA585F >									
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
338 	//     < RE_Portfolio_XVI_metadata_line_31_____RandQ_Managing_Agency_Limited_20250515 >									
339 	//        < iPr15LjOImu3Gu33H7D9JJEpz9E0GedI1qCe8ufjKUqv2gw3BT5L42o9lBFWpXuO >									
340 	//        < 1E-018 limites [ 1108634722,3514 ; 1175243299,9734 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000019CFFA585F1B5CFEF801 >									
342 	//     < RE_Portfolio_XVI_metadata_line_32_____RandQ_Managing_Agency_Limited_ex_Cavell_Managing_Agency_Limited_20250515 >									
343 	//        < NN4c8C9Od62aI4bDi9oUH0OE9Be9U04wwcUXnN66z4hnRMG4nlN2ARMhQNUy1SM4 >									
344 	//        < 1E-018 limites [ 1175243299,9734 ; 1205830031,2785 ] >									
345 	//        < 0x000000000000000000000000000000000000000000001B5CFEF8011C134E9DEB >									
346 	//     < RE_Portfolio_XVI_metadata_line_33_____RBC_Insurance_20250515 >									
347 	//        < DH0Db3SB1T8P98Xm0wYL4XoNx4Hz23DI5gBH68ya9o4R0WLY2dGLuku2N4odAo0Q >									
348 	//        < 1E-018 limites [ 1205830031,2785 ; 1225866086,69567 ] >									
349 	//        < 0x000000000000000000000000000000000000000000001C134E9DEB1C8ABB3611 >									
350 	//     < RE_Portfolio_XVI_metadata_line_34_____Reinsurance_Association_of_America_20250515 >									
351 	//        < yZASI86g7jJEs7ads9roKb0H1fA57g3Ae8dXK3052cay6G9mll7w5POoOrQQ0R42 >									
352 	//        < 1E-018 limites [ 1225866086,69567 ; 1278050752,98377 ] >									
353 	//        < 0x000000000000000000000000000000000000000000001C8ABB36111DC1C6B156 >									
354 	//     < RE_Portfolio_XVI_metadata_line_35_____Reinsurance_Australia_Corporation_20250515 >									
355 	//        < vswj03v6b7ggoAs2qpb93v2GI8GZkzv065257fiRQwHhCUD30fIT7c48g59jqjTV >									
356 	//        < 1E-018 limites [ 1278050752,98377 ; 1301097996,47127 ] >									
357 	//        < 0x000000000000000000000000000000000000000000001DC1C6B1561E4B25FED3 >									
358 	//     < RE_Portfolio_XVI_metadata_line_36_____Reinsurance_Directions_Consulting_20250515 >									
359 	//        < N006AGE4O3ZZ7l21YhvX9qY4nhloM7iO966Q5YB6MdjHp9Sf1z19632L2D1m26Jj >									
360 	//        < 1E-018 limites [ 1301097996,47127 ;  ] >									
361 	//        < 0x000000000000000000000000000000000000000000001E4B25FED31F29E0C9E1 >									
362 	//     < RE_Portfolio_XVI_metadata_line_37_____Reinsurance_Group_of_America_20250515 >									
363 	//        < QTlt6JLCHV95l8p3I253qEYtm4h32vEopdyO18QDy5FTc7Yu47k2o0R88lNrJ353 >									
364 	//        < 1E-018 limites [ 1338465832,77278 ; 1379691558,86544 ] >									
365 	//        < 0x000000000000000000000000000000000000000000001F29E0C9E1201F9A4122 >									
366 	//     < RE_Portfolio_XVI_metadata_line_38_____Reinsurance_Group_of_America_Incorporated_20250515 >									
367 	//        < YP1sMV208CC4u6UaEirvdMYFmKdf6flQ00S16dsx9JhX7siBjsWOJi12l69uOOc0 >									
368 	//        < 1E-018 limites [ 1379691558,86544 ; 1396672068,80612 ] >									
369 	//        < 0x00000000000000000000000000000000000000000000201F9A41222084D074D4 >									
370 	//     < RE_Portfolio_XVI_metadata_line_39_____Reinsurance_Magazine_Online_20250515 >									
371 	//        < DCa8xqCEl8096z6KVqA2s7A02SC836Gh600DyQ9DR95qWWtDCF0P8Jlf436S8989 >									
372 	//        < 1E-018 limites [ 1396672068,80612 ; 1471747029,05055 ] >									
373 	//        < 0x000000000000000000000000000000000000000000002084D074D422444BC12D >									
374 	//     < RE_Portfolio_XVI_metadata_line_40_____Reinsurance_News_Network_20250515 >									
375 	//        < K1G2Cwn6ILEC13bdp8630i95KaZk5bSrXlYjg9zrCBYOT5hjKGiyR4TvTpJIFkSY >									
376 	//        < 1E-018 limites [ 1471747029,05055 ; 1518764476,48852 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000022444BC12D235C8AAF94 >									
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