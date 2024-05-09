1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXXXV_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXXXV_III_883		"	;
8 		string	public		symbol =	"	RUSS_PFXXXV_III_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1025639573146450000000000000					;	
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
92 	//     < RUSS_PFXXXV_III_metadata_line_1_____ALROSA_20251101 >									
93 	//        < VvWqZ70Oth5t4CDcq18KY2sUX093BiFjPqOeB2JmoH5uG4p756lU011nGyAq4fLP >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000035789551.124190900000000000 ] >									
95 	//        < 0x0000000000000000000000000000000000000000000000000000000000369C4B >									
96 	//     < RUSS_PFXXXV_III_metadata_line_2_____ARCOS_HK_LIMITED_20251101 >									
97 	//        < DRhWy55zHTLuwggBV0M79l48Mt0sJLjNKMT9OveR2pOv98K197uA92w26p0Bc6s1 >									
98 	//        <  u =="0.000000000000000001" : ] 000000035789551.124190900000000000 ; 000000060513645.891902800000000000 ] >									
99 	//        < 0x0000000000000000000000000000000000000000000000000000369C4B5C5625 >									
100 	//     < RUSS_PFXXXV_III_metadata_line_3_____ARCOS_ORG_20251101 >									
101 	//        < v61qKU7lvNL2w472Y786py7P0eAt6Cr2ygyNpdnkLPUT5K6BWsNbHsjQRiGKb88N >									
102 	//        <  u =="0.000000000000000001" : ] 000000060513645.891902800000000000 ; 000000087266328.332871600000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000005C5625852869 >									
104 	//     < RUSS_PFXXXV_III_metadata_line_4_____SUNLAND_HOLDINGS_SA_20251101 >									
105 	//        < O3Ik9oFJ0dXtY5SJ3rdLbdop4iTdPE7hf9aUp2p3205XB5oLYX030rTgoaeiSP3D >									
106 	//        <  u =="0.000000000000000001" : ] 000000087266328.332871600000000000 ; 000000114063530.522672000000000000 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000000000852869AE0C11 >									
108 	//     < RUSS_PFXXXV_III_metadata_line_5_____ARCOS_BELGIUM_NV_20251101 >									
109 	//        < AiDb27vEJU9Z41Lg5aipp2r4lFOLyV9QA3l6z8ekuDPu9ek1nHk20zzkjZZC25Mn >									
110 	//        <  u =="0.000000000000000001" : ] 000000114063530.522672000000000000 ; 000000132792885.694508000000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000AE0C11CAA039 >									
112 	//     < RUSS_PFXXXV_III_metadata_line_6_____MEDIAGROUP_SITIM_20251101 >									
113 	//        < lfdxH1kPIYa2Rd52Xc4VBHq5HV1RLPtKtJYBuarY8E1Avr7Mh0r9S66ibfFE401w >									
114 	//        <  u =="0.000000000000000001" : ] 000000132792885.694508000000000000 ; 000000163256003.572272000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000CAA039F91BE0 >									
116 	//     < RUSS_PFXXXV_III_metadata_line_7_____ALROSA_FINANCE_BV_20251101 >									
117 	//        < 5d5uc4PDK0o3jGHq38clD7A1zx0S4SDZSso33mym70efs1EHv6oT4Rpr19aE4M4d >									
118 	//        <  u =="0.000000000000000001" : ] 000000163256003.572272000000000000 ; 000000184904607.342137000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000000F91BE011A245D >									
120 	//     < RUSS_PFXXXV_III_metadata_line_8_____SHIPPING_CO_ALROSA_LENA_20251101 >									
121 	//        < 0kbnpK7Wma5fo3hv2qCUPtCo1602oT15osiYcyfpmxsSYG6wGczB7mX34675h85Q >									
122 	//        <  u =="0.000000000000000001" : ] 000000184904607.342137000000000000 ; 000000207110322.972608000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000011A245D13C0678 >									
124 	//     < RUSS_PFXXXV_III_metadata_line_9_____LENA_ORG_20251101 >									
125 	//        < Ymz75u36W850Q474s7n21pT3mc6RmJamdSs36WqzS9x9c99QEf5v5Eb9k7r1Yc29 >									
126 	//        <  u =="0.000000000000000001" : ] 000000207110322.972608000000000000 ; 000000227906513.123918000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000013C067815BC1FB >									
128 	//     < RUSS_PFXXXV_III_metadata_line_10_____ALROSA_AFRICA_20251101 >									
129 	//        < 8q3QUVpVSa9S98V819JCVPbI9Ns7cUrDk8Njhnks1E8kN4Tkiet2Nf5LIUS7x8JF >									
130 	//        <  u =="0.000000000000000001" : ] 000000227906513.123918000000000000 ; 000000247761382.917879000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000015BC1FB17A0DCA >									
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
174 	//     < RUSS_PFXXXV_III_metadata_line_11_____INVESTMENT_GROUP_ALROSA_20251101 >									
175 	//        < bf68H4p8n12F2TUy47rJX5gV7sbEAf8n0l2a0bXLh047vvnJ8s5lzd58B29q0Dh1 >									
176 	//        <  u =="0.000000000000000001" : ] 000000247761382.917879000000000000 ; 000000266683604.919027000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000017A0DCA196ED48 >									
178 	//     < RUSS_PFXXXV_III_metadata_line_12_____INVESTITSIONNAYA_GRUPPA_ALROSA_20251101 >									
179 	//        < QdArYgA17I3De00X6496Wr5lDtU16GLgDJJhLG0O94916W126xV63Hy2HY3W25I4 >									
180 	//        <  u =="0.000000000000000001" : ] 000000266683604.919027000000000000 ; 000000288820696.833906000000000000 ] >									
181 	//        < 0x00000000000000000000000000000000000000000000000000196ED481B8B496 >									
182 	//     < RUSS_PFXXXV_III_metadata_line_13_____VILYUISKAYA_GES_3_20251101 >									
183 	//        < L42Bd10J8l1EQeRf4XJiSlM2364C1vRMwVaHW6FzM8te3C3Eaz2RdyL5fU5z8c9W >									
184 	//        <  u =="0.000000000000000001" : ] 000000288820696.833906000000000000 ; 000000310132625.827567000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001B8B4961D9398F >									
186 	//     < RUSS_PFXXXV_III_metadata_line_14_____NPP_BUREVESTNIK_20251101 >									
187 	//        < pqfI191kE77QQ2dUVT2nZigy43P3M606p16EvywU05GAJEe04De8PQ3gDOJDK37U >									
188 	//        <  u =="0.000000000000000001" : ] 000000310132625.827567000000000000 ; 000000332392456.531638000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000001D9398F1FB30CE >									
190 	//     < RUSS_PFXXXV_III_metadata_line_15_____NARNAUL_KRISTALL_FACTORY_20251101 >									
191 	//        < pf8XGQ351Uwr9jUTc7Y8dI7deqj9wrM15Q67Kfj09WAfIjB5cmdG2F156VjXxiiq >									
192 	//        <  u =="0.000000000000000001" : ] 000000332392456.531638000000000000 ; 000000354299281.786558000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000001FB30CE21C9E28 >									
194 	//     < RUSS_PFXXXV_III_metadata_line_16_____NARNAUL_ORG_20251101 >									
195 	//        < E96W2r6Wf7MtTIt5d9kmTpAxqmQd597bcDSA61T0GuoEb2Vw7P7QAG1Xg5tp2C3r >									
196 	//        <  u =="0.000000000000000001" : ] 000000354299281.786558000000000000 ; 000000378475889.388452000000000000 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000000021C9E282418225 >									
198 	//     < RUSS_PFXXXV_III_metadata_line_17_____HIDROELECTRICA_CHICAPA_SARL_20251101 >									
199 	//        < q5wYB8IOnX1x3v764yv09AAC9X5UGIi8cz649USXg8G8Fy68lZ45ZWrjz2DtnfMc >									
200 	//        <  u =="0.000000000000000001" : ] 000000378475889.388452000000000000 ; 000000398258641.497143000000000000 ] >									
201 	//        < 0x00000000000000000000000000000000000000000000000000241822525FB1C8 >									
202 	//     < RUSS_PFXXXV_III_metadata_line_18_____CHICAPA_ORG_20251101 >									
203 	//        < i070tMwjisW8n2Uj2879c5l385Dd422W9esFe6mxlzmOyii41R2B6toGJhifvMW0 >									
204 	//        <  u =="0.000000000000000001" : ] 000000398258641.497143000000000000 ; 000000430450841.934595000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000025FB1C8290D0DC >									
206 	//     < RUSS_PFXXXV_III_metadata_line_19_____ALROSA_VGS_LLC_20251101 >									
207 	//        < qCCQ016Gn1W41VA15326u14W747B30q47RvDk61UV5VEm4fL9B46442m7FEboA3J >									
208 	//        <  u =="0.000000000000000001" : ] 000000430450841.934595000000000000 ; 000000451337794.658309000000000000 ] >									
209 	//        < 0x00000000000000000000000000000000000000000000000000290D0DC2B0AFD3 >									
210 	//     < RUSS_PFXXXV_III_metadata_line_20_____ARCOS_DIAMOND_ISRAEL_20251101 >									
211 	//        < y6qr264uU4h0L874qs5cdfw8KvExgYA1HKLTD776zPqM7h9iBk5f5t7vI68741j8 >									
212 	//        <  u =="0.000000000000000001" : ] 000000451337794.658309000000000000 ; 000000478375492.986565000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000002B0AFD32D9F16D >									
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
256 	//     < RUSS_PFXXXV_III_metadata_line_21_____ALMAZY_ANABARA_20251101 >									
257 	//        < Q5glH2KUMEJr4rwwMu0Wcy0YUOWHw5k9G4l89L5Jyxx86oO7kiw60Idn6qH9SbhC >									
258 	//        <  u =="0.000000000000000001" : ] 000000478375492.986565000000000000 ; 000000502538751.768340000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000002D9F16D2FED033 >									
260 	//     < RUSS_PFXXXV_III_metadata_line_22_____ALMAZY_ORG_20251101 >									
261 	//        < Mdr2E8v2mxYBWeYoBSUl4kkmkPsl2Au8VaIH89LGjhDFOG07bEPQzV6IM3pNvr5h >									
262 	//        <  u =="0.000000000000000001" : ] 000000502538751.768340000000000000 ; 000000522910597.568887000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000002FED03331DE5F4 >									
264 	//     < RUSS_PFXXXV_III_metadata_line_23_____ALROSA_ORG_20251101 >									
265 	//        < ufUkL3E608Ir8Az64y49pEfMopS9aypoa3LB5urmK4OG34Qp3Oz7Ho510ZXDB0Kj >									
266 	//        <  u =="0.000000000000000001" : ] 000000522910597.568887000000000000 ; 000000550929747.408203000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000031DE5F4348A6EF >									
268 	//     < RUSS_PFXXXV_III_metadata_line_24_____SEVERALMAZ_20251101 >									
269 	//        < G0PxR601Ci8kqYZ06uLC8z7YTB3Is6lh3xnn2X805Q1mOMkE73uRccnCExd2F6N6 >									
270 	//        <  u =="0.000000000000000001" : ] 000000550929747.408203000000000000 ; 000000580855708.908755000000000000 ] >									
271 	//        < 0x00000000000000000000000000000000000000000000000000348A6EF37650C3 >									
272 	//     < RUSS_PFXXXV_III_metadata_line_25_____ARCOS_USA_20251101 >									
273 	//        < 3ZigB22exXe8AiRBYrdz6pLidUX7cQ0jSrRd03rPEHjAMeac8VI8M1m5132X9cNh >									
274 	//        <  u =="0.000000000000000001" : ] 000000580855708.908755000000000000 ; 000000604604060.304202000000000000 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000000000037650C339A8D76 >									
276 	//     < RUSS_PFXXXV_III_metadata_line_26_____NYURBA_20251101 >									
277 	//        < 8K5A0Ph12iy4io595uJiIRNz9X30LeBi63ctcl7GLtK1Fk2qpX0qx6ecaLexsYNa >									
278 	//        <  u =="0.000000000000000001" : ] 000000604604060.304202000000000000 ; 000000636823088.031862000000000000 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000000000039A8D763CBB705 >									
280 	//     < RUSS_PFXXXV_III_metadata_line_27_____NYURBA_ORG_20251101 >									
281 	//        < 77m60N0XaFDmlE8s3q1Gn3d44cAMQqFxu5Rk6PjVAWCv79867MRXSnffSX54o6v6 >									
282 	//        <  u =="0.000000000000000001" : ] 000000636823088.031862000000000000 ; 000000662542185.678580000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000003CBB7053F2F58B >									
284 	//     < RUSS_PFXXXV_III_metadata_line_28_____EAST_DMCC_20251101 >									
285 	//        < 1q3MDlrp3U70u8umRwagsqX993Y9C232Ho14A4gS1Z6kE1mIHOCeN3WCT74BeeVp >									
286 	//        <  u =="0.000000000000000001" : ] 000000662542185.678580000000000000 ; 000000686668607.686575000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000003F2F58B417C5ED >									
288 	//     < RUSS_PFXXXV_III_metadata_line_29_____ALROSA_FINANCE_SA_20251101 >									
289 	//        < 6y3Tuq2bbYwdkh4eOuWP7wzg7AzcmWSGNvl7h7Zwh7cVDd1FYWgWGJAtsK3d6jXe >									
290 	//        <  u =="0.000000000000000001" : ] 000000686668607.686575000000000000 ; 000000711335225.193994000000000000 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000000000417C5ED43D6953 >									
292 	//     < RUSS_PFXXXV_III_metadata_line_30_____ALROSA_OVERSEAS_SA_20251101 >									
293 	//        < 7ty9AwV2XiZhvt54ggHlz49O7Ttly407fysihvdar08lhDPf6barsQUJa4061HjE >									
294 	//        <  u =="0.000000000000000001" : ] 000000711335225.193994000000000000 ; 000000744041245.381759000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000043D695346F511D >									
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
338 	//     < RUSS_PFXXXV_III_metadata_line_31_____ARCOS_EAST_DMCC_20251101 >									
339 	//        < 2L0d7MYj15j5w4Slv442rqQCZ7HPYlvAs99aXAdLb3G9WKrM3T7f96TPh5JV4zBX >									
340 	//        <  u =="0.000000000000000001" : ] 000000744041245.381759000000000000 ; 000000768853176.879993000000000000 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000000000046F511D4952D46 >									
342 	//     < RUSS_PFXXXV_III_metadata_line_32_____HIDROCHICAPA_SARL_20251101 >									
343 	//        < nbx975T3UNtoZyf1q3HS4mxoQU9Zuk9gcX48lte4h85Jpc9d7yzJgNR3AwSTGuJa >									
344 	//        <  u =="0.000000000000000001" : ] 000000768853176.879993000000000000 ; 000000799647406.756539000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000004952D464C42A45 >									
346 	//     < RUSS_PFXXXV_III_metadata_line_33_____ALROSA_GAZ_20251101 >									
347 	//        < N7qH3Lmrc1G6iP1Jj0UgG3e5CA49iFfX1JOTEaCQynf7uzt8x89Su673OTe1bUPR >									
348 	//        <  u =="0.000000000000000001" : ] 000000799647406.756539000000000000 ; 000000826593714.267386000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000004C42A454ED482B >									
350 	//     < RUSS_PFXXXV_III_metadata_line_34_____SUNLAND_TRADING_SA_20251101 >									
351 	//        < iMvjcaeV4ml1uPp2bS2SasHcthZomw3aUbJmOW36lAgLYyXbeUKY0oj8H9WaXBC9 >									
352 	//        <  u =="0.000000000000000001" : ] 000000826593714.267386000000000000 ; 000000858101736.517802000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000004ED482B51D5BFE >									
354 	//     < RUSS_PFXXXV_III_metadata_line_35_____ORYOL_ALROSA_20251101 >									
355 	//        < SMJvbe52sC5g2386085DKdbxWNeC5622K99yuUThqBih9EgEoh5feQuphIYFRpjb >									
356 	//        <  u =="0.000000000000000001" : ] 000000858101736.517802000000000000 ; 000000885792919.396686000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000051D5BFE5479CDC >									
358 	//     < RUSS_PFXXXV_III_metadata_line_36_____GOLUBAYA_VOLNA_HEALTH_RESORT_20251101 >									
359 	//        < 9NY8qMP87jWx0N1u13zw1yg9s6D0hlA2W9xsw8jK6eiOtLimpPpx6L1sgaB9f176 >									
360 	//        <  u =="0.000000000000000001" : ] 000000885792919.396686000000000000 ; 000000904470131.292612000000000000 ] >									
361 	//        < 0x000000000000000000000000000000000000000000000000005479CDC5641CA5 >									
362 	//     < RUSS_PFXXXV_III_metadata_line_37_____GOLUBAYA_ORG_20251101 >									
363 	//        < 4trg4D03Y5r97H5Tv6H0JUWDnEWThJ4lS1i7BSPuqlx50PfJ6Oz3ED9P5YpADdL7 >									
364 	//        <  u =="0.000000000000000001" : ] 000000904470131.292612000000000000 ; 000000928679953.395557000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000005641CA55890D9B >									
366 	//     < RUSS_PFXXXV_III_metadata_line_38_____SEVERNAYA_GORNO_GEOLOGIC_KOM_TERRA_20251101 >									
367 	//        < g6iH7HhugM55Qzg4pGa53uKbfzA2gc32Jo7h43w66Fah46lTLFaX19SqQ5458rVM >									
368 	//        <  u =="0.000000000000000001" : ] 000000928679953.395557000000000000 ; 000000963895746.914430000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000005890D9B5BEC9C7 >									
370 	//     < RUSS_PFXXXV_III_metadata_line_39_____SEVERNAYA_ORG_20251101 >									
371 	//        < vQ553BYcc5RsfjNBX1iK5vP6P98hJcXCPFmsGt8SrFa8N39JruF3XONEHVA9R2Y7 >									
372 	//        <  u =="0.000000000000000001" : ] 000000963895746.914430000000000000 ; 000000996113246.208171000000000000 ] >									
373 	//        < 0x000000000000000000000000000000000000000000000000005BEC9C75EFF2BD >									
374 	//     < RUSS_PFXXXV_III_metadata_line_40_____ALROSA_NEVA_20251101 >									
375 	//        < SD795cw54qaQ349O8pYpv8Qa4dli3lqzk8wq83SMM1R736cKqHIos4XMMd4p2r01 >									
376 	//        <  u =="0.000000000000000001" : ] 000000996113246.208171000000000000 ; 000001025639573.146450000000000000 ] >									
377 	//        < 0x000000000000000000000000000000000000000000000000005EFF2BD61D0075 >									
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