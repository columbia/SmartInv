1 pragma solidity 		^0.4.25	;						
2 										
3 	contract	CHEMCHINA_PFIII_II_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	CHEMCHINA_PFIII_II_883		"	;
8 		string	public		symbol =	"	CHEMCHINA_PFIII_II_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		747213157706227000000000000					;	
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
92 	//     < CHEMCHINA_PFIII_II_metadata_line_1_____Hangzhou_Hairui_Chemical_Limited_20240321 >									
93 	//        < V86oparpfoZa4p952sg4B04BA5v5iS12N4NpXYUeWh5opC8tTWFB0zUafC1Eh6vp >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000020069273.643270800000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000001E9F8F >									
96 	//     < CHEMCHINA_PFIII_II_metadata_line_2_____Hangzhou_Huajin_Pharmaceutical_Co_Limited_20240321 >									
97 	//        < K0SN0JdG8C67iTfHZ9ASuf05bH6OY3iJMjt632GyrHO276vLeVHVMqsjwfxFGQxg >									
98 	//        <  u =="0.000000000000000001" : ] 000000020069273.643270800000000000 ; 000000036437888.275046300000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000001E9F8F37998D >									
100 	//     < CHEMCHINA_PFIII_II_metadata_line_3_____Hangzhou_J_H_Chemical_Co__Limited_20240321 >									
101 	//        < 5I5igx24q2ys5P550877PpaFB69x012VX85470Jf1ntO4Y154tnLLJYv4H3dz9E0 >									
102 	//        <  u =="0.000000000000000001" : ] 000000036437888.275046300000000000 ; 000000056368771.329677400000000000 ] >									
103 	//        < 0x000000000000000000000000000000000000000000000000000037998D56030D >									
104 	//     < CHEMCHINA_PFIII_II_metadata_line_4_____Hangzhou_J_H_Chemical_Co__Limited_20240321 >									
105 	//        < W071HvGW4203Z5A1raPd2x6ueJXwynbAoL140x4933Ot8Yv0572nOoY9akOW6gs5 >									
106 	//        <  u =="0.000000000000000001" : ] 000000056368771.329677400000000000 ; 000000071676040.242978400000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000056030D6D5E74 >									
108 	//     < CHEMCHINA_PFIII_II_metadata_line_5_____HANGZHOU_KEYINGCHEM_Co_Limited_20240321 >									
109 	//        < 5784YS6Z51IIf8m93Nt11VSLrG9EBL7kD7qv2B2gq0ZPifnWgK0890tj15cQewGl >									
110 	//        <  u =="0.000000000000000001" : ] 000000071676040.242978400000000000 ; 000000088644813.477184000000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000006D5E748742E1 >									
112 	//     < CHEMCHINA_PFIII_II_metadata_line_6_____HANGZHOU_MEITE_CHEMICAL_Co_LimitedHANGZHOU_MEITE_INDUSTRY_Co_Limited_20240321 >									
113 	//        < t11Y0eK8HO3BLAN4E8ZW29e83Okd9lW7RCv3vg983jUFse92tdC5I1H0pe5ciIq6 >									
114 	//        <  u =="0.000000000000000001" : ] 000000088644813.477184000000000000 ; 000000104832472.276592000000000000 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000000000008742E19FF62F >									
116 	//     < CHEMCHINA_PFIII_II_metadata_line_7_____Hangzhou_Ocean_chemical_Co_Limited_20240321 >									
117 	//        < rO0DiR0f4QETfU0GG98UD4KJPJt37OgoBbx6uHcBIrOD9hZD6DhySK47kf78GBUA >									
118 	//        <  u =="0.000000000000000001" : ] 000000104832472.276592000000000000 ; 000000124086304.800521000000000000 ] >									
119 	//        < 0x00000000000000000000000000000000000000000000000000009FF62FBD5736 >									
120 	//     < CHEMCHINA_PFIII_II_metadata_line_8_____Hangzhou_Pharma___Chem_Co_Limited_20240321 >									
121 	//        < w2szusx4r8S73n25eT8oS3spX41rOU34G4sPx1LprHc6HWL6dy3hj221SX31fL0u >									
122 	//        <  u =="0.000000000000000001" : ] 000000124086304.800521000000000000 ; 000000144037406.421933000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000BD5736DBC89D >									
124 	//     < CHEMCHINA_PFIII_II_metadata_line_9_____Hangzhou_Tino_Bio_Tech_Co_Limited_20240321 >									
125 	//        < eItCoGR10Ccjf03lJT90Qn82OJ2336pm7Wi4l9634JDCCsb99iiiTUIg4qZNEere >									
126 	//        <  u =="0.000000000000000001" : ] 000000144037406.421933000000000000 ; 000000160446719.868704000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000000DBC89DF4D280 >									
128 	//     < CHEMCHINA_PFIII_II_metadata_line_10_____Hangzhou_Trylead_Chemical_Technology_Co_Limited_20240321 >									
129 	//        < hH4DeFSsjgB6QSHOmB71dOsi56b6dF8cHjevTFF06gjZ5zC5OFnZhKVJ2g8Oz32h >									
130 	//        <  u =="0.000000000000000001" : ] 000000160446719.868704000000000000 ; 000000176070669.242659000000000000 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000000000F4D28010CA99B >									
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
174 	//     < CHEMCHINA_PFIII_II_metadata_line_11_____Hangzhou_Verychem_Science_And_Technology_org_20240321 >									
175 	//        < 3uVQjR9w160ViNss9oVMXl4e6C734o9ol53DeB2VeQWw9n9uLyBvt7K3TA3MLSfJ >									
176 	//        <  u =="0.000000000000000001" : ] 000000176070669.242659000000000000 ; 000000192818733.893931000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000010CA99B12637D1 >									
178 	//     < CHEMCHINA_PFIII_II_metadata_line_12_____Hangzhou_Verychem_Science_And_Technology_Co__Limited_20240321 >									
179 	//        < BIOV2z8Tf8rwhtsrkkW89KkvRcU4BsD6HNn1y6i20s2y90ODYIO5TTvzYaq70sFN >									
180 	//        <  u =="0.000000000000000001" : ] 000000192818733.893931000000000000 ; 000000214695897.336704000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000012637D11479996 >									
182 	//     < CHEMCHINA_PFIII_II_metadata_line_13_____Hangzhou_Yuhao_Chemical_Technology_Co_Limited_20240321 >									
183 	//        < 5q29UYs4I7j9CP0oLt38I0GhKPn64q35j7AN7728F5Hjf03GoL7km4HZxp9bOkPM >									
184 	//        <  u =="0.000000000000000001" : ] 000000214695897.336704000000000000 ; 000000231290884.316889000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001479996160EC00 >									
186 	//     < CHEMCHINA_PFIII_II_metadata_line_14_____HANGZHOU_ZHIXIN_CHEMICAL_Co__Limited_20240321 >									
187 	//        < 66R3y1e9P7eV6L7h7j5w19Z5kwWrL5Z1Gd11bWjT78mDzvVX0yI23ouP6vqn00vR >									
188 	//        <  u =="0.000000000000000001" : ] 000000231290884.316889000000000000 ; 000000246546791.045795000000000000 ] >									
189 	//        < 0x00000000000000000000000000000000000000000000000000160EC001783357 >									
190 	//     < CHEMCHINA_PFIII_II_metadata_line_15_____Hangzhou_zhongqi_chem_Co_Limited_20240321 >									
191 	//        < Ed1ZCb1W0jqeuk1d824P8rZTO91z8mIN2QcwP2VchoEop2bAqO18wwGzD8AXuFUk >									
192 	//        <  u =="0.000000000000000001" : ] 000000246546791.045795000000000000 ; 000000263192191.200488000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000017833571919973 >									
194 	//     < CHEMCHINA_PFIII_II_metadata_line_16_____HEBEI_AOGE_CHEMICAL_Co__Limited_20240321 >									
195 	//        < EM99E4WZ0l1Yp7V1RerjBELVFY1xSR8m0e469cF59sYAEJ309w58linq69dPmArp >									
196 	//        <  u =="0.000000000000000001" : ] 000000263192191.200488000000000000 ; 000000282053505.523925000000000000 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000000019199731AE6127 >									
198 	//     < CHEMCHINA_PFIII_II_metadata_line_17_____HEBEI_DAPENG_PHARM_CHEM_Co__Limited_20240321 >									
199 	//        < Dbw6t6Mb094X9dt58VL3Z11bbfMiZPQ018RVJ1AryJePPk1nxRc2l62G87x7XZi8 >									
200 	//        <  u =="0.000000000000000001" : ] 000000282053505.523925000000000000 ; 000000304882413.738365000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000001AE61271D136B1 >									
202 	//     < CHEMCHINA_PFIII_II_metadata_line_18_____Hebei_Guantang_Pharmatech_20240321 >									
203 	//        < FKpWXwa3G9g04CI232Ii882iXqINCb13XJvhs97fwe5d92sXc3r3QHnm1QJL7gF1 >									
204 	//        <  u =="0.000000000000000001" : ] 000000304882413.738365000000000000 ; 000000321757496.762174000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000001D136B11EAF686 >									
206 	//     < CHEMCHINA_PFIII_II_metadata_line_19_____Hefei_Hirisun_Pharmatech_org_20240321 >									
207 	//        < 9y64Y239YVQL0lfOv6nclnyI2OwA8Twk2a8KwQr1ZLb17x4DP67EcpPJ1UM2ryBc >									
208 	//        <  u =="0.000000000000000001" : ] 000000321757496.762174000000000000 ; 000000337643594.958560000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000001EAF6862033407 >									
210 	//     < CHEMCHINA_PFIII_II_metadata_line_20_____Hefei_Hirisun_Pharmatech_Co_Limited_20240321 >									
211 	//        < 9AtrPHO79bc7nC2XF9w102Fh4muy84z2041k8AqdZ6fpAB32xCpvr29dF58A71dR >									
212 	//        <  u =="0.000000000000000001" : ] 000000337643594.958560000000000000 ; 000000354456052.082205000000000000 ] >									
213 	//        < 0x00000000000000000000000000000000000000000000000000203340721CDB65 >									
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
256 	//     < CHEMCHINA_PFIII_II_metadata_line_21_____HENAN_YUCHEN_FINE_CHEMICAL_Co_Limited_20240321 >									
257 	//        < A8MAhg79Gwz1NMSEOVP13ibNYxlCu28LjA4F4vQ2l0fr2UltNiiH4okL0RyZKljo >									
258 	//        <  u =="0.000000000000000001" : ] 000000354456052.082205000000000000 ; 000000370933166.262794000000000000 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000000021CDB65235FFC5 >									
260 	//     < CHEMCHINA_PFIII_II_metadata_line_22_____Hi_Tech_Chemistry_Corp_20240321 >									
261 	//        < e383UEK2HMg8WacQgo0b6J0I89h01Jd3Mi51c1IQ6ZBJ3x7R0qC6IbaaPvfM17Da >									
262 	//        <  u =="0.000000000000000001" : ] 000000370933166.262794000000000000 ; 000000387559595.606314000000000000 ] >									
263 	//        < 0x00000000000000000000000000000000000000000000000000235FFC524F5E78 >									
264 	//     < CHEMCHINA_PFIII_II_metadata_line_23_____Hongding_International_Chemical_Industry__Nantong__co___ltd_20240321 >									
265 	//        < Sy96P17N5pJfwJZ9WHES2XsX1sUHy69TcVp1zl583bpN5uExbZmMzFmsLRQjz8NB >									
266 	//        <  u =="0.000000000000000001" : ] 000000387559595.606314000000000000 ; 000000407801318.961494000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000024F5E7826E4164 >									
268 	//     < CHEMCHINA_PFIII_II_metadata_line_24_____Hunan_Chemfish_pharmaceutical_Co_Limited_20240321 >									
269 	//        < 1m3fh0r654zNdx3fj8YY2ho24dE7235J5srP3rbHD292on7H19uLVwi146Yum0h8 >									
270 	//        <  u =="0.000000000000000001" : ] 000000407801318.961494000000000000 ; 000000423067543.051414000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000026E41642858CC2 >									
272 	//     < CHEMCHINA_PFIII_II_metadata_line_25_____IFFECT_CHEMPHAR_Co__Limited_20240321 >									
273 	//        < DqQQKOY3rJBKnI2Jf5k6O000khhJz3dTh7p37ct439GrZAF12k0pUMN8rJ4wyywD >									
274 	//        <  u =="0.000000000000000001" : ] 000000423067543.051414000000000000 ; 000000445315175.861334000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002858CC22A77F3E >									
276 	//     < CHEMCHINA_PFIII_II_metadata_line_26_____Jiangsu_Guotai_International_Group_Co_Limited_20240321 >									
277 	//        < 6Mm9L18dxZ876oQnRjqE0366llvgiSbo8e2Syp9Wks349aen1kG115CCNY5CACEd >									
278 	//        <  u =="0.000000000000000001" : ] 000000445315175.861334000000000000 ; 000000461260527.188843000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000002A77F3E2BFD3E5 >									
280 	//     < CHEMCHINA_PFIII_II_metadata_line_27_____JIANGXI_TIME_CHEMICAL_Co_Limited_20240321 >									
281 	//        < pdsBPEidkI4htqy70s53iU7TAb11806HNS5h8TSca34z99Pc42t3dlI8ulVL9mUd >									
282 	//        <  u =="0.000000000000000001" : ] 000000461260527.188843000000000000 ; 000000478956228.641951000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000002BFD3E52DAD447 >									
284 	//     < CHEMCHINA_PFIII_II_metadata_line_28_____Jianshi_Yuantong_Bioengineering_Co_Limited_20240321 >									
285 	//        < l9r16K66jGw5zUYoQyZBZ5veG4LNDcM609918C9f7YmsGexFocZiB27kyWd88X82 >									
286 	//        <  u =="0.000000000000000001" : ] 000000478956228.641951000000000000 ; 000000498195179.467902000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000002DAD4472F82F7E >									
288 	//     < CHEMCHINA_PFIII_II_metadata_line_29_____Jiaxing_Nanyang_Wanshixing_Chemical_Co__Limited_20240321 >									
289 	//        < 22IwBD84PxjOy6561j08xyuHJFji214mn33DMkm76y4g3YFtUlq51V6tZ7zZHXD0 >									
290 	//        <  u =="0.000000000000000001" : ] 000000498195179.467902000000000000 ; 000000520654760.763606000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000002F82F7E31A74C4 >									
292 	//     < CHEMCHINA_PFIII_II_metadata_line_30_____Jinan_TaiFei_Science_Technology_Co_Limited_20240321 >									
293 	//        < FyMWWX5h0lh1DVAZ4SvUmgJcBii9Umq61kqlwOiQ0u0Sas4fc59BLI67GJdF8kw2 >									
294 	//        <  u =="0.000000000000000001" : ] 000000520654760.763606000000000000 ; 000000542689254.193936000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000031A74C433C13FD >									
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
338 	//     < CHEMCHINA_PFIII_II_metadata_line_31_____Jinan_YSPharma_Biotechnology_Co_Limited_20240321 >									
339 	//        < 80fJv5OwFRk9ozOD596Pgx42ou8cS3XpEDop5XA2l0vDST8FV75SMKMpQqrM959c >									
340 	//        <  u =="0.000000000000000001" : ] 000000542689254.193936000000000000 ; 000000566251825.295021000000000000 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000000000033C13FD360081F >									
342 	//     < CHEMCHINA_PFIII_II_metadata_line_32_____JINCHANG_HOLDING_org_20240321 >									
343 	//        < 17Ns6N0CN1FEmssoO3vJ6LL59EhOx8jmK2GCbky7DkmLsluDdGRUmkajTw42s2E9 >									
344 	//        <  u =="0.000000000000000001" : ] 000000566251825.295021000000000000 ; 000000584870501.262919000000000000 ] >									
345 	//        < 0x00000000000000000000000000000000000000000000000000360081F37C710A >									
346 	//     < CHEMCHINA_PFIII_II_metadata_line_33_____JINCHANG_HOLDING_LIMITED_20240321 >									
347 	//        < Q2GrrRV04KXET8aR9Ka7veQp3NAOszZ97b3H2rC70vM9yUgL6YPh9kHzC7IhTbhY >									
348 	//        <  u =="0.000000000000000001" : ] 000000584870501.262919000000000000 ; 000000601784757.147180000000000000 ] >									
349 	//        < 0x0000000000000000000000000000000000000000000000000037C710A396402C >									
350 	//     < CHEMCHINA_PFIII_II_metadata_line_34_____Jinhua_huayi_chemical_Co__Limited_20240321 >									
351 	//        < DWJxke1wG40yYx0tZXnA6VN5ey747kTX54E2Ker2d11ZDZg2NiTq1aBCcEmsn3Z1 >									
352 	//        <  u =="0.000000000000000001" : ] 000000601784757.147180000000000000 ; 000000622404319.084943000000000000 ] >									
353 	//        < 0x00000000000000000000000000000000000000000000000000396402C3B5B6B0 >									
354 	//     < CHEMCHINA_PFIII_II_metadata_line_35_____Jinhua_Qianjiang_Fine_Chemical_Co_Limited_20240321 >									
355 	//        < fcCCpf65Gi1I7A0T5efNvVZu4v83t9l9nH56ePRa08y6YJbx647eR4zN4Z0IHqzR >									
356 	//        <  u =="0.000000000000000001" : ] 000000622404319.084943000000000000 ; 000000639092873.789564000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000003B5B6B03CF2DA7 >									
358 	//     < CHEMCHINA_PFIII_II_metadata_line_36_____Jinjiangchem_Corporation_20240321 >									
359 	//        < jmB6Iu1vB57mRxPbBZ6jJ035wyfn171zJSbwYL5Og6rdR2TVpqNF7akdcIJSh8U6 >									
360 	//        <  u =="0.000000000000000001" : ] 000000639092873.789564000000000000 ; 000000662682641.131641000000000000 ] >									
361 	//        < 0x000000000000000000000000000000000000000000000000003CF2DA73F32C68 >									
362 	//     < CHEMCHINA_PFIII_II_metadata_line_37_____Jiurui_Biology___Chemistry_Co_Limited_20240321 >									
363 	//        < 2q7Z39qg3n5w71cD8qqU1GL2yZRRPrb12P8k1JEr2aW1fnsU9456k84u417O4W1L >									
364 	//        <  u =="0.000000000000000001" : ] 000000662682641.131641000000000000 ; 000000685099977.385929000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000003F32C68415612E >									
366 	//     < CHEMCHINA_PFIII_II_metadata_line_38_____Jlight_Chemicals_org_20240321 >									
367 	//        < 3NFnrhKtu18651y4rlhx66MGL8t49H3q21c7Z67LNvpq029PV69285B2wrwX0P9Q >									
368 	//        <  u =="0.000000000000000001" : ] 000000685099977.385929000000000000 ; 000000705409072.714680000000000000 ] >									
369 	//        < 0x00000000000000000000000000000000000000000000000000415612E4345E6B >									
370 	//     < CHEMCHINA_PFIII_II_metadata_line_39_____Jlight_Chemicals_Company_20240321 >									
371 	//        < 9crnEs4u1PwixN81D6EKYjnVQp8cxRNI35CRZbLrlmdZ7WwBReDJk9EUn727atn5 >									
372 	//        <  u =="0.000000000000000001" : ] 000000705409072.714680000000000000 ; 000000723511469.328837000000000000 ] >									
373 	//        < 0x000000000000000000000000000000000000000000000000004345E6B44FFDAB >									
374 	//     < CHEMCHINA_PFIII_II_metadata_line_40_____JQC_China_Pharmaceutical_Co_Limited_20240321 >									
375 	//        < 105sWn7FS7uxMPvw3qp5UCtUq1753nwd451uFmYtowpCiR54oKgJy2BM09vgt2aF >									
376 	//        <  u =="0.000000000000000001" : ] 000000723511469.328837000000000000 ; 000000747213157.706228000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000044FFDAB4742824 >									
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