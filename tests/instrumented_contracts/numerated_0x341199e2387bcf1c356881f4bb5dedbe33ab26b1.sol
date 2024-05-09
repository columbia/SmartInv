1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	SHERE_PFIII_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	SHERE_PFIII_I_883		"	;
8 		string	public		symbol =	"	SHERE_PFIII_I_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		744212612048926000000000000					;	
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
92 	//     < SHERE_PFIII_I_metadata_line_1_____RUSSIAN_REINSURANCE_COMPANY_20220505 >									
93 	//        < fg784FDDrEQKV7Ig3TT9McllYCw3oym78V56FfvMqZ0B1i7nC2Q1CJ8x1aLfo6To >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000019914842.003451200000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000001E633C >									
96 	//     < SHERE_PFIII_I_metadata_line_2_____ERGO_20220505 >									
97 	//        < Q1Sag8z6XxQbf4NMdmO9lxot5Pb1j4A27t7Nr79Xs8UiiJWf778QvM7aK3efvN67 >									
98 	//        <  u =="0.000000000000000001" : ] 000000019914842.003451200000000000 ; 000000036505884.709393300000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000001E633C37B41C >									
100 	//     < SHERE_PFIII_I_metadata_line_3_____AIG_20220505 >									
101 	//        < 1HssB2j3yMlrS7x1HKenB8ZvVNPxda26WgcuR9I6oUa21qe1wZO3ePO3a4vIfhI5 >									
102 	//        <  u =="0.000000000000000001" : ] 000000036505884.709393300000000000 ; 000000059784079.000631600000000000 ] >									
103 	//        < 0x000000000000000000000000000000000000000000000000000037B41C5B3928 >									
104 	//     < SHERE_PFIII_I_metadata_line_4_____MARSH_MCLENNAN_RISK_CAPITAL_HOLDINGS_20220505 >									
105 	//        < QgfSWFg240uxw46aobzrBBJwPrbE6r20wpYH1U3Xm692B7tPBh679ix5W3y5YToz >									
106 	//        <  u =="0.000000000000000001" : ] 000000059784079.000631600000000000 ; 000000082670055.088522600000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000005B39287E24FE >									
108 	//     < SHERE_PFIII_I_metadata_line_5_____RUSSIAN_NATIONAL_REINSURANCE_COMPANY_RNRC_20220505 >									
109 	//        < D0odn7sD9zfE3lR7XE40TC56u8Es58ZE09bw04lwN14TcL3uDnhFe48r0Su32fSm >									
110 	//        <  u =="0.000000000000000001" : ] 000000082670055.088522600000000000 ; 000000098613169.961168600000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000007E24FE9678C5 >									
112 	//     < SHERE_PFIII_I_metadata_line_6_____ALFASTRAKHOVANIE_GROUP_20220505 >									
113 	//        < B2b4ZyCy9F8Pg269EqydddiFUzeVf9Vu6e15k6kVb2Tv3V0v6D1YDL2a0W9w8d42 >									
114 	//        <  u =="0.000000000000000001" : ] 000000098613169.961168600000000000 ; 000000113951512.148369000000000000 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000000000009678C5ADE04F >									
116 	//     < SHERE_PFIII_I_metadata_line_7_____ALFA_GROUP_20220505 >									
117 	//        < m1zc17V8i0IyHG57ldeRYfg88pDsbZo4brI71g0nNC2GKgb5ZULAdvT4D6N1kHzj >									
118 	//        <  u =="0.000000000000000001" : ] 000000113951512.148369000000000000 ; 000000135375279.112545000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000ADE04FCE90F8 >									
120 	//     < SHERE_PFIII_I_metadata_line_8_____INGOSSTRAKH_20220505 >									
121 	//        < 89r390jtOk15H5M1iP16l15p7V781YqyLo85o56IaNfvAIvf7MtcivufqWnRJbnA >									
122 	//        <  u =="0.000000000000000001" : ] 000000135375279.112545000000000000 ; 000000153994390.528716000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000CE90F8EAFA0F >									
124 	//     < SHERE_PFIII_I_metadata_line_9_____ROSGOSSTRAKH_INSURANCE_COMPANY_20220505 >									
125 	//        < 2HS26QSukB3KEUDag12akfr2B2Ia7SZuVJt0KoE909nDV1Qqb512l8A24ea3p0jr >									
126 	//        <  u =="0.000000000000000001" : ] 000000153994390.528716000000000000 ; 000000168261680.217553000000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000000EAFA0F100BF38 >									
128 	//     < SHERE_PFIII_I_metadata_line_10_____SCOR_SE_20220505 >									
129 	//        < 32HM8VpJcr7zVlVHX9SPM2CVRscZB77039C2w6OPM538I7x30u18Rr3H8EmES5b1 >									
130 	//        <  u =="0.000000000000000001" : ] 000000168261680.217553000000000000 ; 000000190114898.007584000000000000 ] >									
131 	//        < 0x00000000000000000000000000000000000000000000000000100BF3812217A2 >									
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
174 	//     < SHERE_PFIII_I_metadata_line_11_____HANNOVERRE_20220505 >									
175 	//        < 5DW8fm70YEnOqUnj8T416uE9igF1in8xjbNd32u54ExLpb59WRp72gG08WFyTc6k >									
176 	//        <  u =="0.000000000000000001" : ] 000000190114898.007584000000000000 ; 000000207852851.800972000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000012217A213D2885 >									
178 	//     < SHERE_PFIII_I_metadata_line_12_____SWISS_RE_20220505 >									
179 	//        < 0PJg4C2H3o4RHEJy0U370fpbm2X2fxOEHtWs50S3Q0gEBgqiCUnAMcR8Oce98z62 >									
180 	//        <  u =="0.000000000000000001" : ] 000000207852851.800972000000000000 ; 000000227852374.160804000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000013D288515BACD5 >									
182 	//     < SHERE_PFIII_I_metadata_line_13_____MUNICH_RE_20220505 >									
183 	//        < uTB8CCrw6TSFsIehEVu0jGwiG2K70N50ROkQW3Y93kv33fD5xnP45y1Xr3clrbiN >									
184 	//        <  u =="0.000000000000000001" : ] 000000227852374.160804000000000000 ; 000000247303630.338527000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000015BACD51795AFB >									
186 	//     < SHERE_PFIII_I_metadata_line_14_____GEN_RE_20220505 >									
187 	//        < 7ihGYY6U1yiPS64554XteZ8C4S2YLJtfO92O0wa7Z9jgR05KQwyFB0rZael227iM >									
188 	//        <  u =="0.000000000000000001" : ] 000000247303630.338527000000000000 ; 000000261678175.288574000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000001795AFB18F4A0A >									
190 	//     < SHERE_PFIII_I_metadata_line_15_____PARTNER_RE_20220505 >									
191 	//        < jWRNdw5oNQveow16I2kB8kkq1Vx9s98MB549wBQxCRkMXoCD183ngV2mgRTG78pD >									
192 	//        <  u =="0.000000000000000001" : ] 000000261678175.288574000000000000 ; 000000283797602.728746000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000018F4A0A1B10A70 >									
194 	//     < SHERE_PFIII_I_metadata_line_16_____EXOR_20220505 >									
195 	//        < nNqqaGEDs5t6Z95boJFFzp6uwZ1WNHou78oS1Z90EbM1jrZlipYWz6Ou176cvd1I >									
196 	//        <  u =="0.000000000000000001" : ] 000000283797602.728746000000000000 ; 000000298468425.899750000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000001B10A701C76D3B >									
198 	//     < SHERE_PFIII_I_metadata_line_17_____XL_CATLIN_RE_20220505 >									
199 	//        < URZ5H2I9Udoql5C4D85p4VM5cyXb2NWbvBnRsmAXA3e7Oh9Dnf11O0NSke7O0pNb >									
200 	//        <  u =="0.000000000000000001" : ] 000000298468425.899750000000000000 ; 000000312138934.268574000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000001C76D3B1DC4945 >									
202 	//     < SHERE_PFIII_I_metadata_line_18_____SOGAZ_20220505 >									
203 	//        < WTUy96koLNVb874A85NPBsnv776m8y6wbTQ4k8621ccKp4YY9ljaGJP8u8P89Lzy >									
204 	//        <  u =="0.000000000000000001" : ] 000000312138934.268574000000000000 ; 000000326377261.081123000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000001DC49451F2031E >									
206 	//     < SHERE_PFIII_I_metadata_line_19_____GAZPROM_20220505 >									
207 	//        < buubJ0941X1j9c7eWYFQC7UT9cIv9c7sa7wy0hK8wSE8E374ec5BN0V363Ki77CC >									
208 	//        <  u =="0.000000000000000001" : ] 000000326377261.081123000000000000 ; 000000346147336.242262000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000001F2031E2102DCE >									
210 	//     < SHERE_PFIII_I_metadata_line_20_____VTB INSURANCE_20220505 >									
211 	//        < ey4dQ0c61ZWrBMbHfj89VrFyGFT9z64mgCIq0T61EmFKfa6VJ7pYF98S9P9mhY5a >									
212 	//        <  u =="0.000000000000000001" : ] 000000346147336.242262000000000000 ; 000000369854468.200117000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000002102DCE2345A67 >									
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
256 	//     < SHERE_PFIII_I_metadata_line_21_____WILLIS_LIMITED_20220505 >									
257 	//        < Uekuac5850WOAF4ZtwwKEqj44Qd4GQx76q9923j91mulA5X048gRf1b78bSbUfA9 >									
258 	//        <  u =="0.000000000000000001" : ] 000000369854468.200117000000000000 ; 000000387755133.953239000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000002345A6724FAAD9 >									
260 	//     < SHERE_PFIII_I_metadata_line_22_____GUY_CARPENTER_LIMITED_20220505 >									
261 	//        < uItw9g482KOuP6Ev3ICA23ioFAdRKs15o23QS5SdYmU75is2xoPGc8F53ZJBCVSc >									
262 	//        <  u =="0.000000000000000001" : ] 000000387755133.953239000000000000 ; 000000404458616.900050000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000024FAAD926927A6 >									
264 	//     < SHERE_PFIII_I_metadata_line_23_____AON_BENFIELD_20220505 >									
265 	//        < H0r40G2R9g2zyB3m38ObAIzV6remTLYWzBq8if57PyQcadiX6RIlxC334CvMlQ6j >									
266 	//        <  u =="0.000000000000000001" : ] 000000404458616.900050000000000000 ; 000000424659221.183536000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000026927A6287FA82 >									
268 	//     < SHERE_PFIII_I_metadata_line_24_____WILLIS_CIS_20220505 >									
269 	//        < wF3I4aWEZv9kN4eIjqCB38uT4L7OK4gT3h4FS1FCWLr1z3ydRP5H3xQU34Tnmn35 >									
270 	//        <  u =="0.000000000000000001" : ] 000000424659221.183536000000000000 ; 000000446270958.845048000000000000 ] >									
271 	//        < 0x00000000000000000000000000000000000000000000000000287FA822A8F498 >									
272 	//     < SHERE_PFIII_I_metadata_line_25_____POLISH_RE_20220505 >									
273 	//        < R4X0HE2Zl6T4G9b6gjReC31MNdM8jCPXCihAVLSq3zPvfiBg27PCtm3SI67y3Hxb >									
274 	//        <  u =="0.000000000000000001" : ] 000000446270958.845048000000000000 ; 000000467133021.548829000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002A8F4982C8C9D6 >									
276 	//     < SHERE_PFIII_I_metadata_line_26_____TRUST_RE_20220505 >									
277 	//        < 0475XRiCcmRBQ5GV0FVh0EApO1I4B3LsXMKxRHf8Z25jz4Bn6g0f689FZt78wabb >									
278 	//        <  u =="0.000000000000000001" : ] 000000467133021.548829000000000000 ; 000000482112953.428983000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000002C8C9D62DFA55F >									
280 	//     < SHERE_PFIII_I_metadata_line_27_____MALAKUT_20220505 >									
281 	//        < kqjti4DV17k6L155L05z7Rq1FOF15LAbrg1STEgt0zig4O3fLwLfwZ98Z7g4m5BE >									
282 	//        <  u =="0.000000000000000001" : ] 000000482112953.428983000000000000 ; 000000502082907.085517000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000002DFA55F2FE1E23 >									
284 	//     < SHERE_PFIII_I_metadata_line_28_____SCOR_RUS_20220505 >									
285 	//        < 6cgR4J9pmUP07LmKGiSV9H4WF3nfh4930KSCZN2hf0wiasJ71hxB1r3dSzXZ4kXf >									
286 	//        <  u =="0.000000000000000001" : ] 000000502082907.085517000000000000 ; 000000516571067.454619000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000002FE1E233143993 >									
288 	//     < SHERE_PFIII_I_metadata_line_29_____AFM_20220505 >									
289 	//        < 41k15c3w253KhIT37g2H9ws1ZoyO214o87jI9Y0P19k2yWBWKIe6LzS3hY3rftHh >									
290 	//        <  u =="0.000000000000000001" : ] 000000516571067.454619000000000000 ; 000000536449739.347302000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000031439933328EAE >									
292 	//     < SHERE_PFIII_I_metadata_line_30_____SBERBANK_INSURANCE_20220505 >									
293 	//        < t3v950MG7QGybp96lO268jw3Y4CiTVgTQWbqYmY2b4r2BL9611vDhUJmdED5yreQ >									
294 	//        <  u =="0.000000000000000001" : ] 000000536449739.347302000000000000 ; 000000554097610.411286000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000003328EAE34D7C61 >									
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
338 	//     < SHERE_PFIII_I_metadata_line_31_____Societe_Financiere_Sberbank_20220505 >									
339 	//        < 2YVbIvLwtFp25ABt01v06cgU73IO0jo7FSpuI0QZ6afo87p4hpSx4NlhkfLvuU5n >									
340 	//        <  u =="0.000000000000000001" : ] 000000554097610.411286000000000000 ; 000000569585365.702428000000000000 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000000000034D7C613651E49 >									
342 	//     < SHERE_PFIII_I_metadata_line_32_____ENERGOGARANT_20220505 >									
343 	//        < c2l7unE0egb355MwmR7I4r74TYpOdYzfkovRD7rN2sG0QLs12pE76i7zZipB4FPF >									
344 	//        <  u =="0.000000000000000001" : ] 000000569585365.702428000000000000 ; 000000588132344.095385000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000003651E493816B32 >									
346 	//     < SHERE_PFIII_I_metadata_line_33_____RSHB_INSURANCE_20220505 >									
347 	//        < 4D7rpJ02d5RLjkE2pEjw0BY2YtbBxWV5mB9hxkCHYA4ssX4e28D05HISsCgvSCUt >									
348 	//        <  u =="0.000000000000000001" : ] 000000588132344.095385000000000000 ; 000000610245033.720655000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000003816B323A328F7 >									
350 	//     < SHERE_PFIII_I_metadata_line_34_____EURASIA_20220505 >									
351 	//        < fWvUr6B6012C7Gxa8180ZiHIw781131h9P2ukHY0C5x52DWP2RUF9qKTM2XpqVAC >									
352 	//        <  u =="0.000000000000000001" : ] 000000610245033.720655000000000000 ; 000000625359886.772743000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000003A328F73BA3935 >									
354 	//     < SHERE_PFIII_I_metadata_line_35_____BELARUS_RE_20220505 >									
355 	//        < y1VPMm7t9n0Qrw95Zp8WAm6PKUg7XyScsDCgOq7ZH0Q8C6Yl6d7lU9H4pr78A76h >									
356 	//        <  u =="0.000000000000000001" : ] 000000625359886.772743000000000000 ; 000000642463706.765206000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000003BA39353D45263 >									
358 	//     < SHERE_PFIII_I_metadata_line_36_____RT_INSURANCE_20220505 >									
359 	//        < ASi5EHxzHL9EvQ0rE0sfv8fMmlT4oszGeipGTeuZP5CtxpG2Q6dJ249R5hPI3Zc5 >									
360 	//        <  u =="0.000000000000000001" : ] 000000642463706.765206000000000000 ; 000000657299776.306346000000000000 ] >									
361 	//        < 0x000000000000000000000000000000000000000000000000003D452633EAF5BA >									
362 	//     < SHERE_PFIII_I_metadata_line_37_____ASPEN_20220505 >									
363 	//        < 9dc607N7UKVdX0KHdG8KfAAc4598823hs6nlDLaGOLNnHS69AduAZVW1zyyy33iO >									
364 	//        <  u =="0.000000000000000001" : ] 000000657299776.306346000000000000 ; 000000676185182.994161000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000003EAF5BA407C6D6 >									
366 	//     < SHERE_PFIII_I_metadata_line_38_____LOL_I_20220505 >									
367 	//        < aO55U79VIGMx189svy8i9Z7tENqhCmkQ6p926qAsd65ItYdc8aZAqUR3dR1x2PIv >									
368 	//        <  u =="0.000000000000000001" : ] 000000676185182.994161000000000000 ; 000000701082185.056905000000000000 ] >									
369 	//        < 0x00000000000000000000000000000000000000000000000000407C6D642DC43B >									
370 	//     < SHERE_PFIII_I_metadata_line_39_____LOL_4472_20220505 >									
371 	//        < TfebqF0tM6GO7D6Y7SYP9d6JYY611ql8LJjN48Y6vr9L48Pr9TYrewFNL75jIF75 >									
372 	//        <  u =="0.000000000000000001" : ] 000000701082185.056905000000000000 ; 000000726153021.827196000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000042DC43B4540586 >									
374 	//     < SHERE_PFIII_I_metadata_line_40_____LOL_1183_20220505 >									
375 	//        < xAe5BfiGGrZ9vKDQdoLz68B04adqBP3Pb4jJ4sootxd5Zq5ZB3h00ibDQ2jX5Y44 >									
376 	//        <  u =="0.000000000000000001" : ] 000000726153021.827196000000000000 ; 000000744212612.048926000000000000 ] >									
377 	//        < 0x00000000000000000000000000000000000000000000000000454058646F940D >									
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