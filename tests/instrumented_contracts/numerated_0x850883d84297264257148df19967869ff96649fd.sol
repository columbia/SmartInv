1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	KHC_LAB_200_3_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	KHC_LAB_200_3_883		"	;
8 		string	public		symbol =	"	KHC_LAB_200_3_1subDT		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		2245008851163130000000000000					;	
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
92 	//     < KHC_LAB_200_3_metadata_line_1_____KHC_LAB_200_3Y_abc_i >									
93 	//        < 3P9BtMSji0u11bU076O6967tg7ikSKz9bp2cQj449c50D6vautGH6Ql541B4OpKL >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000056116884.741228400000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000003D5E13 >									
96 	//     < KHC_LAB_200_3_metadata_line_2_____KHC_LAB_200_3Y_abc_ii >									
97 	//        < i6Af8113W7OA4rubhmI0aRvJr0IWXUcEGfX0dPd7WE4Gy2oT1Ck70858S1uOCR23 >									
98 	//        <  u =="0.000000000000000001" : ] 000000056116884.741228400000000000 ; 000000112232703.704508000000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000003D5E137AB8A4 >									
100 	//     < KHC_LAB_200_3_metadata_line_3_____KHC_LAB_200_3Y_abc_iii >									
101 	//        < KBjRScQm5X6vVGLR9L892GQZ4OXK907e5117Citq4SbF6b1bHq77Q48L423E2cCb >									
102 	//        <  u =="0.000000000000000001" : ] 000000112232703.704508000000000000 ; 000000168365803.197689000000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000007AB8A4B81CF0 >									
104 	//     < KHC_LAB_200_3_metadata_line_4_____KHC_LAB_200_3Y_abc_iv >									
105 	//        < 1zfsMQ6UZ697m8sz20RNegb7Bdtzx0ctNZ6kJvhT9uTF9G2n8H618wPfRx79tNwx >									
106 	//        <  u =="0.000000000000000001" : ] 000000168365803.197689000000000000 ; 000000224498178.768336000000000000 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000000000B81CF0F56F0E >									
108 	//     < KHC_LAB_200_3_metadata_line_5_____KHC_LAB_200_3Y_abc_v >									
109 	//        < RvDDWPamI3137q3u2rv16qpFH5w2vVq7k02vbI28240q63Q4pQ04e0a60aq994sb >									
110 	//        <  u =="0.000000000000000001" : ] 000000224498178.768336000000000000 ; 000000280626120.923019000000000000 ] >									
111 	//        < 0x000000000000000000000000000000000000000000000000000F56F0E132E0DF >									
112 	//     < KHC_LAB_200_3_metadata_line_6_____KHC_LAB_200_3Y_abc_vi >									
113 	//        < 4Fn7StR4ZV8Ep7hI3f6IWuJ4fxTcMtf74d1NcZcTJ1dW5v6r6nD9b9079IUKb1ZZ >									
114 	//        <  u =="0.000000000000000001" : ] 000000280626120.923019000000000000 ; 000000336762403.285576000000000000 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000000000132E0DF170316B >									
116 	//     < KHC_LAB_200_3_metadata_line_7_____KHC_LAB_200_3Y_abc_vii >									
117 	//        < yn3In9AB6t8L4bV95zPWFE9MfKChw2DNyCEqImHCPHj7wkD57046ekQ43KA0tUGW >									
118 	//        <  u =="0.000000000000000001" : ] 000000336762403.285576000000000000 ; 000000392875892.742083000000000000 ] >									
119 	//        < 0x00000000000000000000000000000000000000000000000000170316B1AD9670 >									
120 	//     < KHC_LAB_200_3_metadata_line_8_____KHC_LAB_200_3Y_abc_viii >									
121 	//        < u40Xbhyyiq232RKRueBFyQIrdfZkh3wNSR05ucX17631ZzQ2941fPx04OMOWtdu9 >									
122 	//        <  u =="0.000000000000000001" : ] 000000392875892.742083000000000000 ; 000000449008509.935397000000000000 ] >									
123 	//        < 0x000000000000000000000000000000000000000000000000001AD96701EAEDB5 >									
124 	//     < KHC_LAB_200_3_metadata_line_9_____KHC_LAB_200_3Y_abc_ix >									
125 	//        < b390kK2h31R2QWW5M5jQ6m5Nw96s41ZL94y45GIM7z6qIv1Zl257D51nT8XrrH9Z >									
126 	//        <  u =="0.000000000000000001" : ] 000000449008509.935397000000000000 ; 000000505141824.521944000000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000001EAEDB52283A86 >									
128 	//     < KHC_LAB_200_3_metadata_line_10_____KHC_LAB_200_3Y_abc_x >									
129 	//        < kKJLElp3Cq233r7TkVOXUVQhYq7LvA69uX8cHV1364St0XiepX3V21KSvc79ucpT >									
130 	//        <  u =="0.000000000000000001" : ] 000000505141824.521944000000000000 ; 000000561267655.698453000000000000 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000000002283A86265966F >									
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
174 	//     < KHC_LAB_200_3_metadata_line_11_____KHC_LAB_200_3Y_abc_xi >									
175 	//        < KCYfoN8YppuocLFw75Zw0B5Y3gU2Vim0M99szg71eeew9rgwVPl8Mf6Rs9s5jjz6 >									
176 	//        <  u =="0.000000000000000001" : ] 000000561267655.698453000000000000 ; 000000617383004.776364000000000000 ] >									
177 	//        < 0x00000000000000000000000000000000000000000000000000265966F2A2EC5E >									
178 	//     < KHC_LAB_200_3_metadata_line_12_____KHC_LAB_200_3Y_abc_xii >									
179 	//        < dYr87cb263jmBz6vj0D3n4i46AK21rgsdePyicQjYxU7wew4ocA2CAZC9354862z >									
180 	//        <  u =="0.000000000000000001" : ] 000000617383004.776364000000000000 ; 000000673502609.444078000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000002A2EC5E2E05E9C >									
182 	//     < KHC_LAB_200_3_metadata_line_13_____KHC_LAB_200_3Y_abc_xiii >									
183 	//        < wm5581008k4E7MPup8SxTYF8Ur5j19RxFq52Uf1Vw5FCGU6monKxtY74Z993h2Wv >									
184 	//        <  u =="0.000000000000000001" : ] 000000673502609.444078000000000000 ; 000000729637491.291384000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000002E05E9C31DB5E0 >									
186 	//     < KHC_LAB_200_3_metadata_line_14_____KHC_LAB_200_3Y_abc_xiv >									
187 	//        < 5xdwtgzO97tak2271SFVXMV0K5RllI96q0DB7Gnjx8D06grNr6vJbv5nzyYp9A58 >									
188 	//        <  u =="0.000000000000000001" : ] 000000729637491.291384000000000000 ; 000000785762423.328543000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000031DB5E035B2178 >									
190 	//     < KHC_LAB_200_3_metadata_line_15_____KHC_LAB_200_3Y_abc_xv >									
191 	//        < 0aRJ73d4yuNTy49i3ADK8Pe51Fl7fA4mQDP9Oee4HKnZtc64ma7gGtO1OwIh9UWb >									
192 	//        <  u =="0.000000000000000001" : ] 000000785762423.328543000000000000 ; 000000841892324.912488000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000035B2178398996D >									
194 	//     < KHC_LAB_200_3_metadata_line_16_____KHC_LAB_200_3Y_abc_xvi >									
195 	//        < z1837c16O04k8S4x789n89TSXd3gz5UdEZzI7F83GJ82fi3R90uwUSLNWY487k4L >									
196 	//        <  u =="0.000000000000000001" : ] 000000841892324.912488000000000000 ; 000000898020144.841228000000000000 ] >									
197 	//        < 0x00000000000000000000000000000000000000000000000000398996D3D604AF >									
198 	//     < KHC_LAB_200_3_metadata_line_17_____KHC_LAB_200_3Y_abc_xvii >									
199 	//        < dQ0Cf38ij5CQ0tJ92qr60oW7vtU0Ic61UJH39KDat939985c0HTACFnsbcD9C7X9 >									
200 	//        <  u =="0.000000000000000001" : ] 000000898020144.841228000000000000 ; 000000954145110.039310000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000003D604AF41368D7 >									
202 	//     < KHC_LAB_200_3_metadata_line_18_____KHC_LAB_200_3Y_abc_xviii >									
203 	//        < I3dP37996G7mCjQpElCaB3Ih2570vJtOc44x0OtyjksIb4CmV7K23Pinmcq8sOM3 >									
204 	//        <  u =="0.000000000000000001" : ] 000000954145110.039310000000000000 ; 000001010267512.410320000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000041368D7450CDDB >									
206 	//     < KHC_LAB_200_3_metadata_line_19_____KHC_LAB_200_3Y_abc_xix >									
207 	//        < Fx7q8ZnG9A7KP3hr4mB488Iue82DnB9S6804HNU3N2lV2A2g13tPR9072y4SKeH9 >									
208 	//        <  u =="0.000000000000000001" : ] 000001010267512.410320000000000000 ; 000001066399864.292500000000000000 ] >									
209 	//        < 0x00000000000000000000000000000000000000000000000000450CDDB48E348A >									
210 	//     < KHC_LAB_200_3_metadata_line_20_____KHC_LAB_200_3Y_abc_xx >									
211 	//        < 740I8493j2I77nTvWq1O5Bt9DW89r0AnZA5B7qkbVP81xTGM0norqd47h1XClmTD >									
212 	//        <  u =="0.000000000000000001" : ] 000001066399864.292500000000000000 ; 000001122518962.105530000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000048E348A4CBA7F7 >									
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
256 	//     < KHC_LAB_200_3_metadata_line_21_____KHC_LAB_200_3Y_abc_xxi >									
257 	//        < G67x6R99wBG5P3x5ss5b0c3tH390Zi157TlZKlT87J459y199jSCO8VS55JgoLg6 >									
258 	//        <  u =="0.000000000000000001" : ] 000001122518962.105530000000000000 ; 000001178642582.875540000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000004CBA7F7508EB1F >									
260 	//     < KHC_LAB_200_3_metadata_line_22_____KHC_LAB_200_3Y_abc_xxii >									
261 	//        < T5VHP71a4eu5dD9mQto96ZZij31u06fO916bF5SD0F77Xcnph6HcIOqOEt1kn7Nf >									
262 	//        <  u =="0.000000000000000001" : ] 000001178642582.875540000000000000 ; 000001234765421.063760000000000000 ] >									
263 	//        < 0x00000000000000000000000000000000000000000000000000508EB1F5462EA7 >									
264 	//     < KHC_LAB_200_3_metadata_line_23_____KHC_LAB_200_3Y_abc_xxiii >									
265 	//        < OJME84H6QIIZDXAU72sZf3293silv2u42sJn1cYP097fVb0jq44U1vqCWDMS6f0c >									
266 	//        <  u =="0.000000000000000001" : ] 000001234765421.063760000000000000 ; 000001290893561.243800000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000005462EA758381BA >									
268 	//     < KHC_LAB_200_3_metadata_line_24_____KHC_LAB_200_3Y_abc_xxiv >									
269 	//        < V76cH8K36ncAAhaOe7v2q553uX1heQk47FxR17nbKfMp23sP71ROtdtUQuB8L2a8 >									
270 	//        <  u =="0.000000000000000001" : ] 000001290893561.243800000000000000 ; 000001347017247.387190000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000058381BA5C0F839 >									
272 	//     < KHC_LAB_200_3_metadata_line_25_____KHC_LAB_200_3Y_abc_xxv >									
273 	//        < 8tZa6xrL4uakUET6Fs2w13C8U4t590RmC8PcWVQ5WTiOWMiR26A7f6LnvOx45HII >									
274 	//        <  u =="0.000000000000000001" : ] 000001347017247.387190000000000000 ; 000001403132948.878880000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000005C0F8395FE472C >									
276 	//     < KHC_LAB_200_3_metadata_line_26_____KHC_LAB_200_3Y_abc_xxvi >									
277 	//        < 9qrgTISWd42PlZ4Gm4pY0LR6OSYd2C5UkZGppfg0y0I5L35o8YhyZnUSP8K280uP >									
278 	//        <  u =="0.000000000000000001" : ] 000001403132948.878880000000000000 ; 000001459264582.530150000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000005FE472C63BB336 >									
280 	//     < KHC_LAB_200_3_metadata_line_27_____KHC_LAB_200_3Y_abc_xxvii >									
281 	//        < tZsr5n50kB1NRAa6788CKkT2E8063sP6Kfw0rxuNHYFjezAcX6SJ2f36hq0shX08 >									
282 	//        <  u =="0.000000000000000001" : ] 000001459264582.530150000000000000 ; 000001515390751.952290000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000063BB33667906A0 >									
284 	//     < KHC_LAB_200_3_metadata_line_28_____KHC_LAB_200_3Y_abc_xxviii >									
285 	//        < y8zC1KR3AU76H80l0qwPpi31tVLBVpotmBZ7vqUa64DvERNmo70nGLZtJ1NC47hJ >									
286 	//        <  u =="0.000000000000000001" : ] 000001515390751.952290000000000000 ; 000001571524584.849780000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000067906A06B662B3 >									
288 	//     < KHC_LAB_200_3_metadata_line_29_____KHC_LAB_200_3Y_abc_xxix >									
289 	//        < MDWr3u415rU61cZZisoG6A4sAqJqeKeRNMuA7JYhY9BTTVrtHY65936SN22bDVQG >									
290 	//        <  u =="0.000000000000000001" : ] 000001571524584.849780000000000000 ; 000001627658207.390340000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000006B662B36F3A625 >									
292 	//     < KHC_LAB_200_3_metadata_line_30_____KHC_LAB_200_3Y_abc_xxx >									
293 	//        < q4V1hV50GDtMF1jz942YoJsi1NmyI8rNi0XZ3Q9QR90D5Lc7zHT11x94lg526Idc >									
294 	//        <  u =="0.000000000000000001" : ] 000001627658207.390340000000000000 ; 000001683781930.483930000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000006F3A625730F26D >									
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
338 	//     < KHC_LAB_200_3_metadata_line_31_____KHC_LAB_200_3Y_abc_xxxi >									
339 	//        < 2fW1zK6n1V5rjlbsjLNXm6aJ7NP69xq7pGC1d960StO8e37QkU41t6sSRI4Ik7NG >									
340 	//        <  u =="0.000000000000000001" : ] 000001683781930.483930000000000000 ; 000001739909054.959900000000000000 ] >									
341 	//        < 0x00000000000000000000000000000000000000000000000000730F26D76E5047 >									
342 	//     < KHC_LAB_200_3_metadata_line_32_____KHC_LAB_200_3Y_abc_xxxii >									
343 	//        < iwV0Y06wXIhr2m9Tril9RHGm3KB1yvKJb8d6KA5S8mPwJG8019I2kP2y2m8le0Fc >									
344 	//        <  u =="0.000000000000000001" : ] 000001739909054.959900000000000000 ; 000001796034824.551220000000000000 ] >									
345 	//        < 0x0000000000000000000000000000000000000000000000000076E50477ABA5D6 >									
346 	//     < KHC_LAB_200_3_metadata_line_33_____KHC_LAB_200_3Y_abc_xxxiii >									
347 	//        < 3dRE4yY0OD4WV8r10wuv565F8l6nRJJaaojQiPg8xVN3Gcp45u844038zu5HH6BH >									
348 	//        <  u =="0.000000000000000001" : ] 000001796034824.551220000000000000 ; 000001852152095.817920000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000007ABA5D67E9059E >									
350 	//     < KHC_LAB_200_3_metadata_line_34_____KHC_LAB_200_3Y_abc_xxxiv >									
351 	//        < 9ayZwS708QF90Pp1mJViXU7y10uEXo9T17JdocRtA6SFCOk49URRSUsMq6d03vdH >									
352 	//        <  u =="0.000000000000000001" : ] 000001852152095.817920000000000000 ; 000001908271505.322530000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000007E9059E82657EF >									
354 	//     < KHC_LAB_200_3_metadata_line_35_____KHC_LAB_200_3Y_abc_xxxv >									
355 	//        < A4152VDedKwkG45BGCqjAoVX2mD90h1R9cbUW71TrG2UKnpR2A5dm4k17v3cc53V >									
356 	//        <  u =="0.000000000000000001" : ] 000001908271505.322530000000000000 ; 000001964388023.434620000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000082657EF863ADE0 >									
358 	//     < KHC_LAB_200_3_metadata_line_36_____KHC_LAB_200_3Y_abc_xxxvi >									
359 	//        < 59u6jv9kA5lzviu5QxXNr53KD1HeFij1naERG5s8sm72340v72532aaqe5z14Uir >									
360 	//        <  u =="0.000000000000000001" : ] 000001964388023.434620000000000000 ; 000002020509867.773410000000000000 ] >									
361 	//        < 0x00000000000000000000000000000000000000000000000000863ADE08A0F0D0 >									
362 	//     < KHC_LAB_200_3_metadata_line_37_____KHC_LAB_200_3Y_abc_xxxvii >									
363 	//        < OW89Cc7k22jAUZv6j8Zg6ZJn214KZd5wq3brF22ySE50KUtFoNc6k37i49578Tk2 >									
364 	//        <  u =="0.000000000000000001" : ] 000002020509867.773410000000000000 ; 000002076641269.280100000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000008A0F0D08DE58F4 >									
366 	//     < KHC_LAB_200_3_metadata_line_38_____KHC_LAB_200_3Y_abc_xxxviii >									
367 	//        < 147KgvBjiul12oRA124v5XHAs6JhbDHLUetDyv48O5VQUj398ZrfAb0GWG0y496i >									
368 	//        <  u =="0.000000000000000001" : ] 000002076641269.280100000000000000 ; 000002132766752.737720000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000008DE58F491BAF8C >									
370 	//     < KHC_LAB_200_3_metadata_line_39_____KHC_LAB_200_3Y_abc_xxxix >									
371 	//        < 95m3Nr3T7vo44iV6A53e48ob4XJH6HPpf588idL56wY996Fyh9hCuSO55MDoWmls >									
372 	//        <  u =="0.000000000000000001" : ] 000002132766752.737720000000000000 ; 000002188881589.302530000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000091BAF8C9592943 >									
374 	//     < KHC_LAB_200_3_metadata_line_40_____KHC_LAB_200_3Y_abc_xxxx >									
375 	//        < 5f1S2TZIbgvTT1UuO1Aq6T9P65LxtG7nhQYOwJcbCL0lgq4Uh5pStqjQAX3TdYQ3 >									
376 	//        <  u =="0.000000000000000001" : ] 000002188881589.302530000000000000 ; 000002245008851.163130000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000095929439966D01 >									
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