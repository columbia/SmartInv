1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	BANK_IV_PFII_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	BANK_IV_PFII_883		"	;
8 		string	public		symbol =	"	BANK_IV_PFII_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		426401924563853000000000000					;	
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
92 	//     < BANK_IV_PFII_metadata_line_1_____AGRICULTURAL DEVELOPMENT BANK OF CHINA_20240508 >									
93 	//        < 097f3Why018u0mt9n9KBusKTR8446mRT8c51XSYAe5c8NZ9Wtc5kxisBmTIcFU0Y >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000010811605.769000600000000000 ] >									
95 	//        < 0x0000000000000000000000000000000000000000000000000000000000107F49 >									
96 	//     < BANK_IV_PFII_metadata_line_2_____CHINA DEVELOMENT BANK_20240508 >									
97 	//        < 4GB8j3PAE7AM43PEG2rTTVYmKq9JLQmvXkrj98987uO23s0MvGR0c01mZioJaTOg >									
98 	//        <  u =="0.000000000000000001" : ] 000000010811605.769000600000000000 ; 000000021305333.732310400000000000 ] >									
99 	//        < 0x0000000000000000000000000000000000000000000000000000107F49208265 >									
100 	//     < BANK_IV_PFII_metadata_line_3_____EXIM BANK OF CHINA_20240508 >									
101 	//        < 3Bq8cgT0VEhdJ5YQ4o80R5wgpw4q35d6sgNl3FIL0fA869iJQKA2354AGjPPLJ5j >									
102 	//        <  u =="0.000000000000000001" : ] 000000021305333.732310400000000000 ; 000000031998526.308036900000000000 ] >									
103 	//        < 0x000000000000000000000000000000000000000000000000000020826530D36D >									
104 	//     < BANK_IV_PFII_metadata_line_4_____CHINA MERCHANT BANK_20240508 >									
105 	//        < 0BWJi4H4Y6zHfhw9s7M2Q8vX5i6lZe7ByC6vZ7DKoo3k9Byn1umJPSVqsu7OSG6l >									
106 	//        <  u =="0.000000000000000001" : ] 000000031998526.308036900000000000 ; 000000042719493.166993800000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000030D36D412F4D >									
108 	//     < BANK_IV_PFII_metadata_line_5_____SHANGHAI PUDONG DEVELOPMENT BANK_20240508 >									
109 	//        < X8a9L94INMbvRi3tP1HsuO8eqPWSW27V715uY2gDVf8r6HLa9q6w01WB0GnsgcFP >									
110 	//        <  u =="0.000000000000000001" : ] 000000042719493.166993800000000000 ; 000000053541020.289347400000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000412F4D51B276 >									
112 	//     < BANK_IV_PFII_metadata_line_6_____INDUSTRIAL BANK_20240508 >									
113 	//        < 57To08NLH7Pj4Qn8tpW73Fi8jeujZAV1Ig1Jhb4hoq8c50BkEQ7V7T1wmLxDV611 >									
114 	//        <  u =="0.000000000000000001" : ] 000000053541020.289347400000000000 ; 000000064246047.672038700000000000 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000000000051B27662081D >									
116 	//     < BANK_IV_PFII_metadata_line_7_____CHINA CITIC BANK_20240508 >									
117 	//        < EDgU3Emh0LnPLGpL1rk00L0x3j96D71rXU88xoX148739l9muLhs8s69cg5fTcBH >									
118 	//        <  u =="0.000000000000000001" : ] 000000064246047.672038700000000000 ; 000000075017616.257377800000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000000062081D7277C2 >									
120 	//     < BANK_IV_PFII_metadata_line_8_____CHINA MINSHENG BANK_20240508 >									
121 	//        < LDU62k8jqzwBcYuLLAa3QAmLnHcd0o1ayqVW09lHtnaUSOt4JOCGeS1RfgKy0008 >									
122 	//        <  u =="0.000000000000000001" : ] 000000075017616.257377800000000000 ; 000000085489604.885801900000000000 ] >									
123 	//        < 0x00000000000000000000000000000000000000000000000000007277C2827260 >									
124 	//     < BANK_IV_PFII_metadata_line_9_____CHINA EVERBRIGHT BANK_20240508 >									
125 	//        < 950IIXGf8ta9ZmDjO18c3n0R4xjX13TDU80o7L5uqkIWIx5KL1DMB10Q6KtIBMlp >									
126 	//        <  u =="0.000000000000000001" : ] 000000085489604.885801900000000000 ; 000000095975821.850357900000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000000082726092728E >									
128 	//     < BANK_IV_PFII_metadata_line_10_____PING AN BANK_20240508 >									
129 	//        < yRG6G5DuUA1M31fDmWU7E3v29ZQjnRQ69eW5665aT58T3G5UZS4y99U9CdiQh4Ui >									
130 	//        <  u =="0.000000000000000001" : ] 000000095975821.850357900000000000 ; 000000106848240.592424000000000000 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000000000092728EA30998 >									
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
174 	//     < BANK_IV_PFII_metadata_line_11_____HUAXIA BANK_20240508 >									
175 	//        < 8rL0FpyUMnDA5825a6KYWQe5p8MHXcTJf99ebPG05U6hXYN2ZYU7lKnG0HBnUIpk >									
176 	//        <  u =="0.000000000000000001" : ] 000000106848240.592424000000000000 ; 000000117561535.431945000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000000A30998B3627A >									
178 	//     < BANK_IV_PFII_metadata_line_12_____CHINA GUANGFA BANK_20240508 >									
179 	//        < Q32068LD0X7LjJPAf21pcjcIuRlFA96e6M7x0QyuF34ryGm99G7QIKkPlVeaTYar >									
180 	//        <  u =="0.000000000000000001" : ] 000000117561535.431945000000000000 ; 000000128088436.811144000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000000B3627AC3728C >									
182 	//     < BANK_IV_PFII_metadata_line_13_____CHINA BOHAI BANK_20240508 >									
183 	//        < VF2esu69wa5K4gS4mM4vs88M848W00531TzuJQMi9Hp81VLITk8IOBBhvXfbMrZr >									
184 	//        <  u =="0.000000000000000001" : ] 000000128088436.811144000000000000 ; 000000138865710.364514000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000000C3728CD3E46B >									
186 	//     < BANK_IV_PFII_metadata_line_14_____HENGFENG BANK_EVERGROWING BANK_20240508 >									
187 	//        < 5pc91m4683dtbfMQi5eOn36HO05gD8ojulmn1XT094NRvlrKPtnI679XVxLMg0L4 >									
188 	//        <  u =="0.000000000000000001" : ] 000000138865710.364514000000000000 ; 000000149556508.120338000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000000D3E46BE43483 >									
190 	//     < BANK_IV_PFII_metadata_line_15_____BANK OF BEIJING_20240508 >									
191 	//        < F8D6DM56FuD4sug8vTL0nt1x50tB918T983tBR0xesv1V6G7Vip93tH9M2SOJtW3 >									
192 	//        <  u =="0.000000000000000001" : ] 000000149556508.120338000000000000 ; 000000160317019.700722000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000000E43483F49FD6 >									
194 	//     < BANK_IV_PFII_metadata_line_16_____BANK OF SHANGHAI_20240508 >									
195 	//        < A0F0Lue3Z5Y51FjuvQGFob32xr568pp5kX0gp5zhe0UcOzefDZOgQ4k3DJZhmY0t >									
196 	//        <  u =="0.000000000000000001" : ] 000000160317019.700722000000000000 ; 000000171121306.386258000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000000F49FD61051C43 >									
198 	//     < BANK_IV_PFII_metadata_line_17_____BANK OF JIANGSU_20240508 >									
199 	//        < Pr0PW394l21289M5tjdX5v34OohKRq7pCo3xZEmS5Vhs2rHBAk93Q0v9W7U830V2 >									
200 	//        <  u =="0.000000000000000001" : ] 000000171121306.386258000000000000 ; 000000181899944.840797000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000001051C431158EAA >									
202 	//     < BANK_IV_PFII_metadata_line_18_____BANK OF NINGBO_20240508 >									
203 	//        < 3axqccFVcy3A1H7cT1j48N1aI3foWqQDLK5qdAUEbPKdb04dN975KN161I8l9tmU >									
204 	//        <  u =="0.000000000000000001" : ] 000000181899944.840797000000000000 ; 000000192448218.003346000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000001158EAA125A716 >									
206 	//     < BANK_IV_PFII_metadata_line_19_____BANK OF DALIAN_20240508 >									
207 	//        < B39z46xYEaLSX22LvTFTr2ADt4cplLg76Ym5JHV82xHSl5kFg00ROl9n4kMwks1d >									
208 	//        <  u =="0.000000000000000001" : ] 000000192448218.003346000000000000 ; 000000203095793.051792000000000000 ] >									
209 	//        < 0x00000000000000000000000000000000000000000000000000125A716135E64B >									
210 	//     < BANK_IV_PFII_metadata_line_20_____BANK OF TAIZHOU_20240508 >									
211 	//        < jd53aWYX9penvlU0EqCSf6Bp7849mbhXH0T8sTel600OA38Zm1BoszWpq3SMGD4n >									
212 	//        <  u =="0.000000000000000001" : ] 000000203095793.051792000000000000 ; 000000213618376.320926000000000000 ] >									
213 	//        < 0x00000000000000000000000000000000000000000000000000135E64B145F4AE >									
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
256 	//     < BANK_IV_PFII_metadata_line_21_____BANK OF TIANJIN_20240508 >									
257 	//        < nfMTD3c97bsgNnBE2fy725L1Q28qKhL7zdpfEThfnIqT0kFG2423IK40lR5DMN3k >									
258 	//        <  u =="0.000000000000000001" : ] 000000213618376.320926000000000000 ; 000000224258548.388819000000000000 ] >									
259 	//        < 0x00000000000000000000000000000000000000000000000000145F4AE15630FF >									
260 	//     < BANK_IV_PFII_metadata_line_22_____WIAMEN INTERNATIONAL BANK_20240508 >									
261 	//        < 9E14053zlnec12AH98RQ5sLcn66251f81DHRSw5AF2182eppT8qdLFOMjlC30GI8 >									
262 	//        <  u =="0.000000000000000001" : ] 000000224258548.388819000000000000 ; 000000234956019.476122000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000015630FF16683B2 >									
264 	//     < BANK_IV_PFII_metadata_line_23_____TAI_AN BANK_20240508 >									
265 	//        < 6Hw1UN1KvMBg9Oz659FxHv36k6LH3mL9920nBH8J9O50503M5KuJsewQpe7c9w24 >									
266 	//        <  u =="0.000000000000000001" : ] 000000234956019.476122000000000000 ; 000000245517475.530211000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000016683B2176A144 >									
268 	//     < BANK_IV_PFII_metadata_line_24_____SHENGJING BANK_SHENYANG_20240508 >									
269 	//        < mxnU7o4TzGfK3Dhq8Sr5H7dvj00iuAZI575dUf8J59iAvU9Op3sro5B2Fv0ZV0oe >									
270 	//        <  u =="0.000000000000000001" : ] 000000245517475.530211000000000000 ; 000000255985349.228029000000000000 ] >									
271 	//        < 0x00000000000000000000000000000000000000000000000000176A1441869A47 >									
272 	//     < BANK_IV_PFII_metadata_line_25_____HARBIN BANK_20240508 >									
273 	//        < eI4p0B74ADUinEBZ3q2v63Wj7oD68v86Ihg56uK2n2b3w0h98vn1a2hzFEiUy5lc >									
274 	//        <  u =="0.000000000000000001" : ] 000000255985349.228029000000000000 ; 000000266515395.541486000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000001869A47196AB94 >									
276 	//     < BANK_IV_PFII_metadata_line_26_____BANK OF JILIN_20240508 >									
277 	//        < xSV4V7RxkqGNoPJ0LZe0CqWe3WBQU3215u6nJOqmGhVp8igkt83l83M9Y098p8mM >									
278 	//        <  u =="0.000000000000000001" : ] 000000266515395.541486000000000000 ; 000000277149274.768863000000000000 ] >									
279 	//        < 0x00000000000000000000000000000000000000000000000000196AB941A6E56F >									
280 	//     < BANK_IV_PFII_metadata_line_27_____WEBANK_CHINA_20240508 >									
281 	//        < F93B2wdp0IfVp2Z924U45HArjp3bf5l99Gx6qq89X7jN47Q3J29qu9KU1xnTe02T >									
282 	//        <  u =="0.000000000000000001" : ] 000000277149274.768863000000000000 ; 000000287673215.303212000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000001A6E56F1B6F45A >									
284 	//     < BANK_IV_PFII_metadata_line_28_____MYBANK_HANGZHOU_20240508 >									
285 	//        < 24A5h29nkMTd9mpL6b14IU6S0wPq196z6t0fS1MjtY559Y5w8vLh6QsjMCZprOWB >									
286 	//        <  u =="0.000000000000000001" : ] 000000287673215.303212000000000000 ; 000000298499562.245313000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000001B6F45A1C77964 >									
288 	//     < BANK_IV_PFII_metadata_line_29_____SHANGHAI HUARUI BANK_20240508 >									
289 	//        < aXuFx01fu3Dk51lXHt1bt4z3Y0irbtScyi9YoOfPNWg5fpbCcFVoHYJBnP7g29S6 >									
290 	//        <  u =="0.000000000000000001" : ] 000000298499562.245313000000000000 ; 000000309122894.423969000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000001C779641D7AF21 >									
292 	//     < BANK_IV_PFII_metadata_line_30_____WENZHOU MINSHANG BANK_20240508 >									
293 	//        < 84eJop6Vi5YqoUxcpJk3jXE8vZv6fju3E18yNdQs3e9qShQl04jt9gS871v1z79D >									
294 	//        <  u =="0.000000000000000001" : ] 000000309122894.423969000000000000 ; 000000319945427.131766000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000001D7AF211E832AF >									
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
338 	//     < BANK_IV_PFII_metadata_line_31_____BANK OF KUNLUN_20240508 >									
339 	//        < K6enmxKfh1qoYJacFgirQmgJ5Ct4K6GL7L5Q3rXBFfFgE9CHb5L7ST39zFSq0491 >									
340 	//        <  u =="0.000000000000000001" : ] 000000319945427.131766000000000000 ; 000000330675335.687333000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000001E832AF1F8920E >									
342 	//     < BANK_IV_PFII_metadata_line_32_____SILIBANK_20240508 >									
343 	//        < 8ke118OQ0scN4r0GR84pIRT5ID0AI1j57Yg6Ufg4d00D54DxU052JbcMrh52n49E >									
344 	//        <  u =="0.000000000000000001" : ] 000000330675335.687333000000000000 ; 000000341355936.527916000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000001F8920E208DE2A >									
346 	//     < BANK_IV_PFII_metadata_line_33_____AGRICULTURAL BANK OF CHINA_20240508 >									
347 	//        < d58Uv84GyQ20YIY56McG0FjMvw1AvZ76mr9nlHzCw7CRzmzX9Gk2vQup3aI2bp41 >									
348 	//        <  u =="0.000000000000000001" : ] 000000341355936.527916000000000000 ; 000000352167298.547420000000000000 ] >									
349 	//        < 0x00000000000000000000000000000000000000000000000000208DE2A2195D5A >									
350 	//     < BANK_IV_PFII_metadata_line_34_____CIC_CHINA INVESTMENT CORP_20240508 >									
351 	//        < 1593R2606tblLe7gWAp4aspv5a15RzF9379ZT956XJu63t8CN1wYvNiYhO3l7QF6 >									
352 	//        <  u =="0.000000000000000001" : ] 000000352167298.547420000000000000 ; 000000362717732.715685000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000002195D5A229769D >									
354 	//     < BANK_IV_PFII_metadata_line_35_____BANK OF CHINA_20240508 >									
355 	//        < A8OGh88j0K2M8bz2ytyzv292ll3YXBhbQ18t0spUB85K37f2437eU0eoZJupZtOA >									
356 	//        <  u =="0.000000000000000001" : ] 000000362717732.715685000000000000 ; 000000373325089.664297000000000000 ] >									
357 	//        < 0x00000000000000000000000000000000000000000000000000229769D239A61D >									
358 	//     < BANK_IV_PFII_metadata_line_36_____PEOPLE BANK OF CHINA_20240508 >									
359 	//        < yz39Y70kFK57pS5GSi6s0F1640mWzloG0Et53519sDt7ly5Bcz83T83Mpxcc72eQ >									
360 	//        <  u =="0.000000000000000001" : ] 000000373325089.664297000000000000 ; 000000383955070.915717000000000000 ] >									
361 	//        < 0x00000000000000000000000000000000000000000000000000239A61D249DE73 >									
362 	//     < BANK_IV_PFII_metadata_line_37_____ICBC_INDUSTRIAL AND COMMERCIAL BANK OF CHINA_20240508 >									
363 	//        < Di406IL1VsGl6RjGEy08ERc6E80W2b5S7Z345Cao5ezGr9du4inuWgoO7vCt7ra2 >									
364 	//        <  u =="0.000000000000000001" : ] 000000383955070.915717000000000000 ; 000000394554159.877437000000000000 ] >									
365 	//        < 0x00000000000000000000000000000000000000000000000000249DE7325A0AB8 >									
366 	//     < BANK_IV_PFII_metadata_line_38_____CHINA CONSTRUCTION BANK_20240508 >									
367 	//        < vYup64q5OtcG95wCKqicZGmT8YgvKmY02S4ln8qr7lX45tUah13Tx8G3NaByd6nc >									
368 	//        <  u =="0.000000000000000001" : ] 000000394554159.877437000000000000 ; 000000405023728.564545000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000025A0AB826A0465 >									
370 	//     < BANK_IV_PFII_metadata_line_39_____BANK OF COMMUNICATION_20240508 >									
371 	//        < 2Zc0oY3Yqy1dlszmIOU4Gms9z4B9hWw9xIF6726kJGI87N7HLX76iy24fog8a7vQ >									
372 	//        <  u =="0.000000000000000001" : ] 000000405023728.564545000000000000 ; 000000415867975.736694000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000026A046527A906E >									
374 	//     < BANK_IV_PFII_metadata_line_40_____POSTAL SAVINGS BANK OF CHINA_20240508 >									
375 	//        < WxfG9w6Ys7zrWQVL9Ru8i8NB59438q6Hw9P24Iq3KgUTh6Qt5sr0214jg2Szh8s4 >									
376 	//        <  u =="0.000000000000000001" : ] 000000415867975.736694000000000000 ; 000000426401924.563853000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000027A906E28AA340 >									
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