1 pragma solidity 		^0.4.25	;						
2 										
3 	contract	CHEMCHINA_PFIII_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	CHEMCHINA_PFIII_III_883		"	;
8 		string	public		symbol =	"	CHEMCHINA_PFIII_III_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		960045161637506000000000000					;	
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
92 	//     < CHEMCHINA_PFIII_III_metadata_line_1_____Hangzhou_Hairui_Chemical_Limited_20260321 >									
93 	//        < 2AVduU6Zs1S36tyi0A173BaKb70mCH77K9Vw7SzNFcGOsG5R8XnF1AooRwP2qs32 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000023316870.287486200000000000 ] >									
95 	//        < 0x0000000000000000000000000000000000000000000000000000000000239427 >									
96 	//     < CHEMCHINA_PFIII_III_metadata_line_2_____Hangzhou_Huajin_Pharmaceutical_Co_Limited_20260321 >									
97 	//        < 1Q7g768eufHwbK9L5Dc3e2cVUz30vXYwuY9t694RT38zV50G88M5lmi6CKLwdpZl >									
98 	//        <  u =="0.000000000000000001" : ] 000000023316870.287486200000000000 ; 000000043785242.665289400000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000023942742CF9C >									
100 	//     < CHEMCHINA_PFIII_III_metadata_line_3_____Hangzhou_J_H_Chemical_Co__Limited_20260321 >									
101 	//        < l1E9N67XOw0QoEB51kSty9j7I0zu6M3Qz7WZy3AXiH0zKd44Q3094T7hbYHMkiRI >									
102 	//        <  u =="0.000000000000000001" : ] 000000043785242.665289400000000000 ; 000000063806282.945332400000000000 ] >									
103 	//        < 0x000000000000000000000000000000000000000000000000000042CF9C615C54 >									
104 	//     < CHEMCHINA_PFIII_III_metadata_line_4_____Hangzhou_J_H_Chemical_Co__Limited_20260321 >									
105 	//        < FsN8Sq4KOkdDO1fOJ9kASvd5zAxM39VC64jHRMg0yPy44HUwYd7ry50IOCOs59zC >									
106 	//        <  u =="0.000000000000000001" : ] 000000063806282.945332400000000000 ; 000000092509037.984074700000000000 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000000000615C548D2858 >									
108 	//     < CHEMCHINA_PFIII_III_metadata_line_5_____HANGZHOU_KEYINGCHEM_Co_Limited_20260321 >									
109 	//        < C5gRb6DNjAwCwmKV02Qk7A5VC2lnIAf1CZ83Oyx90CR2XF4zp35x13C4hDXK68Uo >									
110 	//        <  u =="0.000000000000000001" : ] 000000092509037.984074700000000000 ; 000000123247945.950195000000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000008D2858BC0FBB >									
112 	//     < CHEMCHINA_PFIII_III_metadata_line_6_____HANGZHOU_MEITE_CHEMICAL_Co_LimitedHANGZHOU_MEITE_INDUSTRY_Co_Limited_20260321 >									
113 	//        < 1IHL88eRqA4SMy0E18LV7Q92u09rChqix0ppFK29AWBS8jz4j5767j1xE3O2nLG0 >									
114 	//        <  u =="0.000000000000000001" : ] 000000123247945.950195000000000000 ; 000000155919048.974928000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000BC0FBBEDE9E1 >									
116 	//     < CHEMCHINA_PFIII_III_metadata_line_7_____Hangzhou_Ocean_chemical_Co_Limited_20260321 >									
117 	//        < 2Jz77WMTcU8WWs7a1vG0CJ11t797s64rMDV9g5787Cy888o0T6P4uzuSs8GFMLV3 >									
118 	//        <  u =="0.000000000000000001" : ] 000000155919048.974928000000000000 ; 000000176141121.644129000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000000EDE9E110CC520 >									
120 	//     < CHEMCHINA_PFIII_III_metadata_line_8_____Hangzhou_Pharma___Chem_Co_Limited_20260321 >									
121 	//        < g2beeKl69aTp0h7f0GV8hHo00vp8PV4mO8JeW0J7nUypvK8yrV6ID8o8L92n8Qc3 >									
122 	//        <  u =="0.000000000000000001" : ] 000000176141121.644129000000000000 ; 000000197685235.750600000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000010CC52012DA4CC >									
124 	//     < CHEMCHINA_PFIII_III_metadata_line_9_____Hangzhou_Tino_Bio_Tech_Co_Limited_20260321 >									
125 	//        < Rj3QpzRFXN0e8rpjjqSba6fHsBRBvv8sF66XqoRu04OOZ12cW70654cLa8j1J5Am >									
126 	//        <  u =="0.000000000000000001" : ] 000000197685235.750600000000000000 ; 000000215732560.344367000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000012DA4CC1492E88 >									
128 	//     < CHEMCHINA_PFIII_III_metadata_line_10_____Hangzhou_Trylead_Chemical_Technology_Co_Limited_20260321 >									
129 	//        < L671FJhjw5HuUU9yu0kuicBDzgH6jJlhH5Wet6zIjO81lkaQQp7428x2l3gc4ZJz >									
130 	//        <  u =="0.000000000000000001" : ] 000000215732560.344367000000000000 ; 000000237143508.157440000000000000 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000000001492E88169DA2F >									
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
174 	//     < CHEMCHINA_PFIII_III_metadata_line_11_____Hangzhou_Verychem_Science_And_Technology_org_20260321 >									
175 	//        < 1W654EDDPnJqDpG7oNZ666uhTmh30cR18rbjc0ina11FnNR00b7h4lh3dimDFmqP >									
176 	//        <  u =="0.000000000000000001" : ] 000000237143508.157440000000000000 ; 000000265914525.551244000000000000 ] >									
177 	//        < 0x00000000000000000000000000000000000000000000000000169DA2F195C0DD >									
178 	//     < CHEMCHINA_PFIII_III_metadata_line_12_____Hangzhou_Verychem_Science_And_Technology_Co__Limited_20260321 >									
179 	//        < vda9lbDaQVIx067l8ww3jT72CMDXZjhx1l8vMyan7001C690mD2GuR00a8690o0H >									
180 	//        <  u =="0.000000000000000001" : ] 000000265914525.551244000000000000 ; 000000290182390.168211000000000000 ] >									
181 	//        < 0x00000000000000000000000000000000000000000000000000195C0DD1BAC87F >									
182 	//     < CHEMCHINA_PFIII_III_metadata_line_13_____Hangzhou_Yuhao_Chemical_Technology_Co_Limited_20260321 >									
183 	//        < 5fB7buKPP76aAU4a8yu4f1t2G6q3F0vcgLeFu7l4XIj0i16DHj9L8IA3hTv0d6yh >									
184 	//        <  u =="0.000000000000000001" : ] 000000290182390.168211000000000000 ; 000000315375869.898505000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001BAC87F1E139B3 >									
186 	//     < CHEMCHINA_PFIII_III_metadata_line_14_____HANGZHOU_ZHIXIN_CHEMICAL_Co__Limited_20260321 >									
187 	//        < kVQWe4bFBK2Wvm66CWW9yE863WjFw63166ijws169wWJftCmQBA8I46zscue79b3 >									
188 	//        <  u =="0.000000000000000001" : ] 000000315375869.898505000000000000 ; 000000338968725.533752000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000001E139B320539A9 >									
190 	//     < CHEMCHINA_PFIII_III_metadata_line_15_____Hangzhou_zhongqi_chem_Co_Limited_20260321 >									
191 	//        < IzvLlK721s4wZ0hl475Bcil42Ez3LLCekomS8znlOv0w51sUDbzp66Vxbico65U3 >									
192 	//        <  u =="0.000000000000000001" : ] 000000338968725.533752000000000000 ; 000000357686921.813433000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000020539A9221C974 >									
194 	//     < CHEMCHINA_PFIII_III_metadata_line_16_____HEBEI_AOGE_CHEMICAL_Co__Limited_20260321 >									
195 	//        < SDwQ23XssX9To526Uwv2l1G18n3JMb3l9zHv75lC3o2351W4icHKcik35j3lIPrD >									
196 	//        <  u =="0.000000000000000001" : ] 000000357686921.813433000000000000 ; 000000377885423.503384000000000000 ] >									
197 	//        < 0x00000000000000000000000000000000000000000000000000221C9742409B7E >									
198 	//     < CHEMCHINA_PFIII_III_metadata_line_17_____HEBEI_DAPENG_PHARM_CHEM_Co__Limited_20260321 >									
199 	//        < 2ipid1e2pGTR23JJREZapNv33EJYcIrJhpTiNgP2zxC9qGoYq9f1qdSvsPaSh7gj >									
200 	//        <  u =="0.000000000000000001" : ] 000000377885423.503384000000000000 ; 000000396434055.124420000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000002409B7E25CE90E >									
202 	//     < CHEMCHINA_PFIII_III_metadata_line_18_____Hebei_Guantang_Pharmatech_20260321 >									
203 	//        < N01p6SrIu5INlY6r9t5bI1BcKRwy84OWCVZ9qT6In8w4yrP1g0L8p8BJfL6w7lhF >									
204 	//        <  u =="0.000000000000000001" : ] 000000396434055.124420000000000000 ; 000000419278725.282249000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000025CE90E27FC4C1 >									
206 	//     < CHEMCHINA_PFIII_III_metadata_line_19_____Hefei_Hirisun_Pharmatech_org_20260321 >									
207 	//        < AlzEk4e71j6qe707gTUcZJVPlv222utj24vVt1os4180JzmR5A11t5m5cm1661iw >									
208 	//        <  u =="0.000000000000000001" : ] 000000419278725.282249000000000000 ; 000000443290652.417251000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000000027FC4C12A46869 >									
210 	//     < CHEMCHINA_PFIII_III_metadata_line_20_____Hefei_Hirisun_Pharmatech_Co_Limited_20260321 >									
211 	//        < qP7gB0iBaMdFis9pR9L70udz11McJnIh7VYVYPVKLw4UigIRzWzBpqsX4y5WV62G >									
212 	//        <  u =="0.000000000000000001" : ] 000000443290652.417251000000000000 ; 000000461578994.058316000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000002A468692C0504B >									
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
256 	//     < CHEMCHINA_PFIII_III_metadata_line_21_____HENAN_YUCHEN_FINE_CHEMICAL_Co_Limited_20260321 >									
257 	//        < r3C13OtHjEmL7Y8w63EZw97ikQaGWY6Zz3iFTymU7lbM36lX625moIihCPC22Ef3 >									
258 	//        <  u =="0.000000000000000001" : ] 000000461578994.058316000000000000 ; 000000482355362.333413000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000002C0504B2E00410 >									
260 	//     < CHEMCHINA_PFIII_III_metadata_line_22_____Hi_Tech_Chemistry_Corp_20260321 >									
261 	//        < fCn2z30D8k0EDi061PXR6RFpn6wajnJ04TJdRV29U0t0x0zrA6S2OAJjtqn8318C >									
262 	//        <  u =="0.000000000000000001" : ] 000000482355362.333413000000000000 ; 000000512337588.891164000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000002E0041030DC3DF >									
264 	//     < CHEMCHINA_PFIII_III_metadata_line_23_____Hongding_International_Chemical_Industry__Nantong__co___ltd_20260321 >									
265 	//        < rFbhre6P7k4wV2250e2KPZwy1u51wbuLz27lwOPESolx3V3jv9maSFX90J743Ag8 >									
266 	//        <  u =="0.000000000000000001" : ] 000000512337588.891164000000000000 ; 000000539337527.113399000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000030DC3DF336F6B9 >									
268 	//     < CHEMCHINA_PFIII_III_metadata_line_24_____Hunan_Chemfish_pharmaceutical_Co_Limited_20260321 >									
269 	//        < fBS2u6U5PQO7ptFtHcRSiF0c9wu5PNa59lZ4RU8gMA55B798C75aZqJ5arcuhdA1 >									
270 	//        <  u =="0.000000000000000001" : ] 000000539337527.113399000000000000 ; 000000567564491.078816000000000000 ] >									
271 	//        < 0x00000000000000000000000000000000000000000000000000336F6B936208E1 >									
272 	//     < CHEMCHINA_PFIII_III_metadata_line_25_____IFFECT_CHEMPHAR_Co__Limited_20260321 >									
273 	//        < 04D8ox2D5Ng28V4d63d19b81by9h628qSLitIlTaLHN1OufQOVUE93j6Smt4Eqwz >									
274 	//        <  u =="0.000000000000000001" : ] 000000567564491.078816000000000000 ; 000000591633783.405589000000000000 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000000000036208E1386C2F2 >									
276 	//     < CHEMCHINA_PFIII_III_metadata_line_26_____Jiangsu_Guotai_International_Group_Co_Limited_20260321 >									
277 	//        < sjl264W1TCGsZ6xA43pwRa78tWIHrx325N2I9Ko5zz3OXHMz00dcM345RpOB40qN >									
278 	//        <  u =="0.000000000000000001" : ] 000000591633783.405589000000000000 ; 000000624611073.968743000000000000 ] >									
279 	//        < 0x00000000000000000000000000000000000000000000000000386C2F23B914B3 >									
280 	//     < CHEMCHINA_PFIII_III_metadata_line_27_____JIANGXI_TIME_CHEMICAL_Co_Limited_20260321 >									
281 	//        < P31mhk7B7S3sN886vU72D3Xn13XUOGTruwVyP34AVlh7GDZPWn7rZwd6vW51a6Xd >									
282 	//        <  u =="0.000000000000000001" : ] 000000624611073.968743000000000000 ; 000000646419055.828692000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000003B914B33DA5B72 >									
284 	//     < CHEMCHINA_PFIII_III_metadata_line_28_____Jianshi_Yuantong_Bioengineering_Co_Limited_20260321 >									
285 	//        < 0ULfYoFA0fxj92E6u5ew9WA9Zf8yHyl5HI5VU3EYoSmAT9rdU7mKbO5Ez0mZh3C8 >									
286 	//        <  u =="0.000000000000000001" : ] 000000646419055.828692000000000000 ; 000000675548805.072676000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000003DA5B72406CE41 >									
288 	//     < CHEMCHINA_PFIII_III_metadata_line_29_____Jiaxing_Nanyang_Wanshixing_Chemical_Co__Limited_20260321 >									
289 	//        < P1ZV6Fbc0ho8e6VdJ2etrE5XLo63094aks1NKTB7vfosVL4clkApe4fB1N71Cd0S >									
290 	//        <  u =="0.000000000000000001" : ] 000000675548805.072676000000000000 ; 000000702273970.831498000000000000 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000000000406CE4142F95C5 >									
292 	//     < CHEMCHINA_PFIII_III_metadata_line_30_____Jinan_TaiFei_Science_Technology_Co_Limited_20260321 >									
293 	//        < k6Yw8VYIeCDiei8fyra039YdEkh218LxuynO2hvy97D6U26dZUfo2R5agFBknZud >									
294 	//        <  u =="0.000000000000000001" : ] 000000702273970.831498000000000000 ; 000000732013914.201187000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000042F95C545CF6EF >									
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
338 	//     < CHEMCHINA_PFIII_III_metadata_line_31_____Jinan_YSPharma_Biotechnology_Co_Limited_20260321 >									
339 	//        < k8JIDFcw8bAGp9B2x67b38B9QN5bodL1TgEn238c4hghH8jX3Bg7pX2C4ilO7bWs >									
340 	//        <  u =="0.000000000000000001" : ] 000000732013914.201187000000000000 ; 000000750548907.180150000000000000 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000000000045CF6EF4793F2B >									
342 	//     < CHEMCHINA_PFIII_III_metadata_line_32_____JINCHANG_HOLDING_org_20260321 >									
343 	//        < 1zR3a540jxD56844n2GnyfO31wb49Qknj37Tz9h65t5VAL480hT3Oom9rPoy4plq >									
344 	//        <  u =="0.000000000000000001" : ] 000000750548907.180150000000000000 ; 000000772666489.519947000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000004793F2B49AFED9 >									
346 	//     < CHEMCHINA_PFIII_III_metadata_line_33_____JINCHANG_HOLDING_LIMITED_20260321 >									
347 	//        < Fy3Q1gfNEMunKc67KU19W0Tn9m8xXgVUTMnTDwAVaupVzr2L9613Ra1XMAeuNU7L >									
348 	//        <  u =="0.000000000000000001" : ] 000000772666489.519947000000000000 ; 000000795561481.757490000000000000 ] >									
349 	//        < 0x0000000000000000000000000000000000000000000000000049AFED94BDEE34 >									
350 	//     < CHEMCHINA_PFIII_III_metadata_line_34_____Jinhua_huayi_chemical_Co__Limited_20260321 >									
351 	//        < P7qXcU6a45Da2JcJ6H09YVKZYSh0XVtyk17us5X2S84l21h7k5Z20j5m8reU5b4H >									
352 	//        <  u =="0.000000000000000001" : ] 000000795561481.757490000000000000 ; 000000819229712.446765000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000004BDEE344E20B9B >									
354 	//     < CHEMCHINA_PFIII_III_metadata_line_35_____Jinhua_Qianjiang_Fine_Chemical_Co_Limited_20260321 >									
355 	//        < p6PoRgWkAw62XrgL1nImN9SJ889R37B5MP79Gd99fgpm8mS6CK5YiN7vLAmSRaEi >									
356 	//        <  u =="0.000000000000000001" : ] 000000819229712.446765000000000000 ; 000000845645650.084142000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000004E20B9B50A5A55 >									
358 	//     < CHEMCHINA_PFIII_III_metadata_line_36_____Jinjiangchem_Corporation_20260321 >									
359 	//        < HzGXhLz2UyIcSxqw51W9Op3626av8Bg62KVgFkWEcIc0NI6b397RC5p9D7FrQEAb >									
360 	//        <  u =="0.000000000000000001" : ] 000000845645650.084142000000000000 ; 000000865714725.218171000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000050A5A55528F9D1 >									
362 	//     < CHEMCHINA_PFIII_III_metadata_line_37_____Jiurui_Biology___Chemistry_Co_Limited_20260321 >									
363 	//        < M5PbzV2U6h93L326sGvkUGGAM64HKM3wNI7JdVp0kyjdMvgyQ02U2J6F001w3wg4 >									
364 	//        <  u =="0.000000000000000001" : ] 000000865714725.218171000000000000 ; 000000892204234.956589000000000000 ] >									
365 	//        < 0x00000000000000000000000000000000000000000000000000528F9D15516547 >									
366 	//     < CHEMCHINA_PFIII_III_metadata_line_38_____Jlight_Chemicals_org_20260321 >									
367 	//        < 7cO9HtcJz2Tb4mu6y18M8UE25eolK2WoWE3hAY4ZEAlanPxTn0f43CW5zO134H6a >									
368 	//        <  u =="0.000000000000000001" : ] 000000892204234.956589000000000000 ; 000000913719157.931334000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000005516547572398C >									
370 	//     < CHEMCHINA_PFIII_III_metadata_line_39_____Jlight_Chemicals_Company_20260321 >									
371 	//        < 2JTr1Gg6yxR9phtVPPG699s83bPBBI2FiR7Twtv1918xuzitli5kW376345f74TF >									
372 	//        <  u =="0.000000000000000001" : ] 000000913719157.931334000000000000 ; 000000937207709.745002000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000572398C59610C3 >									
374 	//     < CHEMCHINA_PFIII_III_metadata_line_40_____JQC_China_Pharmaceutical_Co_Limited_20260321 >									
375 	//        < 4l580514jn9KHMwe5FV19vjgmX090dLxoe337MCeo2V470m85HTHqre5771J61FA >									
376 	//        <  u =="0.000000000000000001" : ] 000000937207709.745002000000000000 ; 000000960045161.637506000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000059610C35B8E9A4 >									
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