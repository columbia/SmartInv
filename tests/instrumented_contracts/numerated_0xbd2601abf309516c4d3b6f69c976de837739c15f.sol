1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXXXVI_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXXXVI_III_883		"	;
8 		string	public		symbol =	"	RUSS_PFXXXVI_III_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1038844884363090000000000000					;	
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
92 	//     < RUSS_PFXXXVI_III_metadata_line_1_____ROSNEFT_20251101 >									
93 	//        < u7ibKG9DRUoum6vkaN86Y0P2wOyP89675ZLdF7Y8F5g0jDJ42GCSig8s650us1Tp >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000028612772.667186600000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000002BA8DD >									
96 	//     < RUSS_PFXXXVI_III_metadata_line_2_____ROSNEFT_GBP_20251101 >									
97 	//        < Qr572wj120gf990wbkd560WE0WkVF4y13h4DAJbahsJ8Ue405zspDvMH6TBiOxwo >									
98 	//        <  u =="0.000000000000000001" : ] 000000028612772.667186600000000000 ; 000000061888608.793526800000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000002BA8DD5E6F3D >									
100 	//     < RUSS_PFXXXVI_III_metadata_line_3_____ROSNEFT_USD_20251101 >									
101 	//        < 4T68I4U4At37u4rA347P2YmTifH732s3Mq15w01UOPu3Lmic2hM6iZ8W7coiqrDF >									
102 	//        <  u =="0.000000000000000001" : ] 000000061888608.793526800000000000 ; 000000093026829.080469400000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000005E6F3D8DF29B >									
104 	//     < RUSS_PFXXXVI_III_metadata_line_4_____ROSNEFT_SA_CHF_20251101 >									
105 	//        < qRnQl3SfnL11pgG83d7NwhB9DbKLo0LrnaN3eTwZdT3z3Z98UwmtDYe72I15e69P >									
106 	//        <  u =="0.000000000000000001" : ] 000000093026829.080469400000000000 ; 000000124287620.302420000000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000008DF29BBDA5DA >									
108 	//     < RUSS_PFXXXVI_III_metadata_line_5_____ROSNEFT_GMBH_EUR_20251101 >									
109 	//        < 13nr729e3015qav9Mou6Sp58bjUyyjpTBSPx0XNgYf690hAzpOnFfB9DPpD6t633 >									
110 	//        <  u =="0.000000000000000001" : ] 000000124287620.302420000000000000 ; 000000148255681.261607000000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000BDA5DAE23860 >									
112 	//     < RUSS_PFXXXVI_III_metadata_line_6_____BAIKALFINANSGRUP_20251101 >									
113 	//        < wmwNb6wM8kn57sw18dtzP3Eb19V1W9veZZz4iV1oxDHobXCeJ3Vf0iBpHXHvsH2z >									
114 	//        <  u =="0.000000000000000001" : ] 000000148255681.261607000000000000 ; 000000169804900.410884000000000000 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000000000E238601031A0A >									
116 	//     < RUSS_PFXXXVI_III_metadata_line_7_____BAIKAL_ORG_20251101 >									
117 	//        < 4m6U3MVz5sbHcRC6m2NTo4GkK8TmJ5c9OG1b3Gwe1jTEJz7j52FsFd4P9Vlsu2q3 >									
118 	//        <  u =="0.000000000000000001" : ] 000000169804900.410884000000000000 ; 000000200814621.862343000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000001031A0A1326B36 >									
120 	//     < RUSS_PFXXXVI_III_metadata_line_8_____BAIKAL_AB_20251101 >									
121 	//        < VVB2zaOD5a60p2xr36P184RLc3MGS6E9ZG62Ma543TuLv3GnwDX1XqjUl0105YUQ >									
122 	//        <  u =="0.000000000000000001" : ] 000000200814621.862343000000000000 ; 000000234695857.733732000000000000 ] >									
123 	//        < 0x000000000000000000000000000000000000000000000000001326B361661E12 >									
124 	//     < RUSS_PFXXXVI_III_metadata_line_9_____BAIKAL_CHF_20251101 >									
125 	//        < F8x89X12uKCO25br1945e3OoeX5mX13o1C6D4b39EZWr9Mer27gKA099tQTTM3ju >									
126 	//        <  u =="0.000000000000000001" : ] 000000234695857.733732000000000000 ; 000000253921188.245162000000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000001661E1218373F7 >									
128 	//     < RUSS_PFXXXVI_III_metadata_line_10_____BAIKAL_BYR_20251101 >									
129 	//        < 99984omTN89bsewk0f746K1sipQ2C29dR0V4Qtv5kVTPXRKrCU3tn2h5xI51x9e9 >									
130 	//        <  u =="0.000000000000000001" : ] 000000253921188.245162000000000000 ; 000000272859894.339781000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000018373F71A059E5 >									
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
174 	//     < RUSS_PFXXXVI_III_metadata_line_11_____YUKOS_ABI_20251101 >									
175 	//        < 9AgQ8076xn5fyHTj575810rx18Ou8nf58aQZ2s02zZG3rq00grM6o7AR9HhV5Q15 >									
176 	//        <  u =="0.000000000000000001" : ] 000000272859894.339781000000000000 ; 000000292958201.441655000000000000 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000000001A059E51BF04CC >									
178 	//     < RUSS_PFXXXVI_III_metadata_line_12_____YUKOS_ABII_20251101 >									
179 	//        < y1l3kUtBKmrEBK2DcD358sMYtZA2mFc5WjmF6x38iwP65f9lkKLdVN64O17yD1GU >									
180 	//        <  u =="0.000000000000000001" : ] 000000292958201.441655000000000000 ; 000000314371286.803040000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000001BF04CC1DFB149 >									
182 	//     < RUSS_PFXXXVI_III_metadata_line_13_____YUKOS_ABIII_20251101 >									
183 	//        < w153YhrLfvYYPL7MF9t5h367nLs8UmFzKsh1Snr227HO50fGL01k9KGQv6FyCoNK >									
184 	//        <  u =="0.000000000000000001" : ] 000000314371286.803040000000000000 ; 000000333253398.218041000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001DFB1491FC811C >									
186 	//     < RUSS_PFXXXVI_III_metadata_line_14_____YUKOS_ABIV_20251101 >									
187 	//        < 1Z367tS9sLzVN9Yn3jmOi1LYyx8YA4HxW1ROtofUg7mLRFK61X2VC2L2zW02bwr0 >									
188 	//        <  u =="0.000000000000000001" : ] 000000333253398.218041000000000000 ; 000000363504043.813640000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000001FC811C22AA9C4 >									
190 	//     < RUSS_PFXXXVI_III_metadata_line_15_____YUKOS_ABV_20251101 >									
191 	//        < xnG83gh1M956NLY2Sn2MccSVv3dFSzhNga52czgx7ZcdF3zg4SwPCm8R5Q8HxoM9 >									
192 	//        <  u =="0.000000000000000001" : ] 000000363504043.813640000000000000 ; 000000394472970.183508000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000022AA9C4259EB01 >									
194 	//     < RUSS_PFXXXVI_III_metadata_line_16_____ROSNEFT_TRADE_LIMITED_20251101 >									
195 	//        < 2Qwhndb6iYXl677b1dh8b22k1Sze9aH7MRaqX20xQjp7gEwuKn72cKLvmy6i36qV >									
196 	//        <  u =="0.000000000000000001" : ] 000000394472970.183508000000000000 ; 000000427396042.656004000000000000 ] >									
197 	//        < 0x00000000000000000000000000000000000000000000000000259EB0128C2794 >									
198 	//     < RUSS_PFXXXVI_III_metadata_line_17_____NEFT_AKTIV_20251101 >									
199 	//        < 9Mb6383BbznrVvOfBhotNAU4Gn4Fvv9QTv296moRHzaHaaw1ONr6q447ZV909qhn >									
200 	//        <  u =="0.000000000000000001" : ] 000000427396042.656004000000000000 ; 000000453757100.988328000000000000 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000000028C27942B460DE >									
202 	//     < RUSS_PFXXXVI_III_metadata_line_18_____ACHINSK_OIL_REFINERY_VNK_20251101 >									
203 	//        < Ax9Hcwl5up5GV0iOV9u9aUEhE9D1cUrjV8OT9EZ3e5c58SeyYUvw4t9fPlei0Uss >									
204 	//        <  u =="0.000000000000000001" : ] 000000453757100.988328000000000000 ; 000000489186189.315643000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000002B460DE2EA705B >									
206 	//     < RUSS_PFXXXVI_III_metadata_line_19_____ROSPAN_INT_20251101 >									
207 	//        < 83nv32YgkXfRFD4939B5FHVry9Tf0C6mbeDQt9Be2N7A6atwriqnym2C1wJeP36q >									
208 	//        <  u =="0.000000000000000001" : ] 000000489186189.315643000000000000 ; 000000520574976.450271000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000002EA705B31A559A >									
210 	//     < RUSS_PFXXXVI_III_metadata_line_20_____STROYTRANSGAZ_LIMITED_20251101 >									
211 	//        < T0SvddpM3dXSbB2uT2QEMwn1TZS5Y44P0NDLGXW0Jo1gBae357PnE4UpEW1N959O >									
212 	//        <  u =="0.000000000000000001" : ] 000000520574976.450271000000000000 ; 000000539473715.946206000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000031A559A3372BEC >									
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
256 	//     < RUSS_PFXXXVI_III_metadata_line_21_____ROSNEFT_LIMITED_20251101 >									
257 	//        < eyGjQ6TAE27gWo7RJb3F1D9t4GR5sn7un0Be9s3OF9kecn9TKAqa41QV3pn6R81n >									
258 	//        <  u =="0.000000000000000001" : ] 000000539473715.946206000000000000 ; 000000564564538.581836000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000003372BEC35D7506 >									
260 	//     < RUSS_PFXXXVI_III_metadata_line_22_____TAIHU_LIMITED_20251101 >									
261 	//        < rOT17GG10hXzmnb7MP95rEum81awTE89W1X9BS43TnjPJp4Y6Smwh6wvd2QwN9U2 >									
262 	//        <  u =="0.000000000000000001" : ] 000000564564538.581836000000000000 ; 000000584325346.558466000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000035D750637B9C17 >									
264 	//     < RUSS_PFXXXVI_III_metadata_line_23_____TAIHU_ORG_20251101 >									
265 	//        < QJ555FCZqm8y542y2TTrW2DfeG1Ogr1025A3arC0kMxw2A95dxD4B7mVig7nCWW9 >									
266 	//        <  u =="0.000000000000000001" : ] 000000584325346.558466000000000000 ; 000000604149248.149153000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000037B9C17399DBCD >									
268 	//     < RUSS_PFXXXVI_III_metadata_line_24_____EAST_SIBERIAN_GAS_CO_20251101 >									
269 	//        < d773irhEHMi3F72ZnEf82gQE89UAw713pH9s3uir8IFVYzrC41i4YvJpzA3178Il >									
270 	//        <  u =="0.000000000000000001" : ] 000000604149248.149153000000000000 ; 000000633846971.156365000000000000 ] >									
271 	//        < 0x00000000000000000000000000000000000000000000000000399DBCD3C72C79 >									
272 	//     < RUSS_PFXXXVI_III_metadata_line_25_____RN_TUAPSINSKIY_NPZ_20251101 >									
273 	//        < GBA5pA4WT4p52TQBy1ae8w468s46NgpAnb5Bj6f45L19740J9m0QjoYvyVOW2CX8 >									
274 	//        <  u =="0.000000000000000001" : ] 000000633846971.156365000000000000 ; 000000654359136.286270000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000003C72C793E6790A >									
276 	//     < RUSS_PFXXXVI_III_metadata_line_26_____ROSPAN_ORG_20251101 >									
277 	//        < 4o5FX6mNwBNdH5crEfyD9m4kdX5C80844C3236zqf2cn9JCsKu3a2z179DFvWgC1 >									
278 	//        <  u =="0.000000000000000001" : ] 000000654359136.286270000000000000 ; 000000685797100.474919000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000003E6790A416717E >									
280 	//     < RUSS_PFXXXVI_III_metadata_line_27_____SYSRAN_20251101 >									
281 	//        < NHP12D3NmIRoHO43EUsB8K5v9jR4OJk922wR4fhKN5Fk445642351KNzEUkX1GQI >									
282 	//        <  u =="0.000000000000000001" : ] 000000685797100.474919000000000000 ; 000000710531551.901457000000000000 ] >									
283 	//        < 0x00000000000000000000000000000000000000000000000000416717E43C2F63 >									
284 	//     < RUSS_PFXXXVI_III_metadata_line_28_____SYSRAN_ORG_20251101 >									
285 	//        < KQ3Y7k1034T6CFyE3y9qE039WV8g62JZLT4ch0Kg4Xc90d7Kr6D6dDc7W1XL6OG4 >									
286 	//        <  u =="0.000000000000000001" : ] 000000710531551.901457000000000000 ; 000000737290268.193669000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000043C2F634650403 >									
288 	//     < RUSS_PFXXXVI_III_metadata_line_29_____ARTAG_20251101 >									
289 	//        < sKama0tGpg8bIr022pI3Fq6Py89doblNqEqi3Sv90hSlH22vpW4IA3O2o0PFI8qp >									
290 	//        <  u =="0.000000000000000001" : ] 000000737290268.193669000000000000 ; 000000764631310.690316000000000000 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000000000465040348EBC1B >									
292 	//     < RUSS_PFXXXVI_III_metadata_line_30_____ARTAG_ORG_20251101 >									
293 	//        < 80rqW057Sird1F3iXv9F666Idp37A3kY4S3pWO6va5kTDTJ535a4Wlhhp85xslaq >									
294 	//        <  u =="0.000000000000000001" : ] 000000764631310.690316000000000000 ; 000000788220455.858044000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000048EBC1B4B2BA9E >									
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
338 	//     < RUSS_PFXXXVI_III_metadata_line_31_____RN_TUAPSE_REFINERY_LLC_20251101 >									
339 	//        < Xw9jEV7p9M9l1IM6e7WabTqZ2Z22aS50Z07SBEWzOiVYWXuXcQ61ni11PJ6kmb5g >									
340 	//        <  u =="0.000000000000000001" : ] 000000788220455.858044000000000000 ; 000000823604173.204043000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000004B2BA9E4E8B861 >									
342 	//     < RUSS_PFXXXVI_III_metadata_line_32_____TUAPSE_ORG_20251101 >									
343 	//        < D3c825eZ3MHEuwJ1ahpIjyf6Cgllvk4Sbe6PXs97clmR577Rz4opcmRH1F84vD3S >									
344 	//        <  u =="0.000000000000000001" : ] 000000823604173.204043000000000000 ; 000000845373274.662750000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000004E8B861509EFEF >									
346 	//     < RUSS_PFXXXVI_III_metadata_line_33_____NATIONAL_OIL_CONSORTIUM_20251101 >									
347 	//        < VMVhA3O3PT4ZS4p4gD91I41E98Mz6kK22xy74D9N6Ov1gj3v4Ra2N80BUDrOkjG0 >									
348 	//        <  u =="0.000000000000000001" : ] 000000845373274.662750000000000000 ; 000000873729032.234296000000000000 ] >									
349 	//        < 0x00000000000000000000000000000000000000000000000000509EFEF5353467 >									
350 	//     < RUSS_PFXXXVI_III_metadata_line_34_____RN_ASTRA_20251101 >									
351 	//        < C7Vj0p5G0miBV5EEPX6j73Zfv0A0Y0M1Rh136aV2yjpb7cc9iH4l50N2Vg02Y97h >									
352 	//        <  u =="0.000000000000000001" : ] 000000873729032.234296000000000000 ; 000000893354174.863966000000000000 ] >									
353 	//        < 0x0000000000000000000000000000000000000000000000000053534675532679 >									
354 	//     < RUSS_PFXXXVI_III_metadata_line_35_____ASTRA_ORG_20251101 >									
355 	//        < s77D90smN2Iu5y0zbiYxfXI8d6UTfQqu7wiRn4UdklVZSg5r0QdE0Q2PEu69nvtQ >									
356 	//        <  u =="0.000000000000000001" : ] 000000893354174.863966000000000000 ; 000000914627084.442496000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000055326795739C34 >									
358 	//     < RUSS_PFXXXVI_III_metadata_line_36_____ROSNEFT_DEUTSCHLAND_GMBH_20251101 >									
359 	//        < Q1b2oM736nd4tbI3Kb29VphRdK46H81LqAYDrtUInhQg6OZkSvgSz4r0aVT6iXnt >									
360 	//        <  u =="0.000000000000000001" : ] 000000914627084.442496000000000000 ; 000000941752607.473413000000000000 ] >									
361 	//        < 0x000000000000000000000000000000000000000000000000005739C3459D001D >									
362 	//     < RUSS_PFXXXVI_III_metadata_line_37_____ITERA_GROUP_LIMITED_20251101 >									
363 	//        < P6f2M031Rv7iuptc01WT6s6b575suGgU46m5Y60lnR78E9PI4YpTkk014D1099i5 >									
364 	//        <  u =="0.000000000000000001" : ] 000000941752607.473413000000000000 ; 000000964119408.120088000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000059D001D5BF2125 >									
366 	//     < RUSS_PFXXXVI_III_metadata_line_38_____SAMOTLORNEFTEGAZ_20251101 >									
367 	//        < O7QQKdHmW31Y9st737IRKM25JwdZ7u0gT85b4vMu7UaHCI4K8kh5WztrBcRTr4VO >									
368 	//        <  u =="0.000000000000000001" : ] 000000964119408.120088000000000000 ; 000000989195369.810607000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000005BF21255E56471 >									
370 	//     < RUSS_PFXXXVI_III_metadata_line_39_____KUBANNEFTEPRODUCT_20251101 >									
371 	//        < 9Z5eELrPX12nj8ZZ4w6KMN706Nl95b7nQgd0360TCKTD9A0UMegi330iBwpG3Vpb >									
372 	//        <  u =="0.000000000000000001" : ] 000000989195369.810607000000000000 ; 000001008513503.130520000000000000 ] >									
373 	//        < 0x000000000000000000000000000000000000000000000000005E56471602DE96 >									
374 	//     < RUSS_PFXXXVI_III_metadata_line_40_____KUBAN_ORG_20251101 >									
375 	//        < cMMNnxdx9l5uq5vYW9WjkdnlW6t7N0MR1sKnvdjLcpFl22MQ79FRomco69xx68J9 >									
376 	//        <  u =="0.000000000000000001" : ] 000001008513503.130520000000000000 ; 000001038844884.363090000000000000 ] >									
377 	//        < 0x00000000000000000000000000000000000000000000000000602DE9663126C8 >									
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