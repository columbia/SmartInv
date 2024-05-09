1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RE_Portfolio_VI_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RE_Portfolio_VI_883		"	;
8 		string	public		symbol =	"	RE883VI		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1518671758713550000000000000					;	
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
92 	//     < RE_Portfolio_VI_metadata_line_1_____AXIS_Specialty_Limited_Ap_Ap_20250515 >									
93 	//        < 93UIUUPx6sXIljgB6wKnK41815M98i3HjW955tOfBN13X835395AxFju9OaFz4Wm >									
94 	//        < 1E-018 limites [ 1E-018 ; 58476194,9549572 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000015C8B999B >									
96 	//     < RE_Portfolio_VI_metadata_line_2_____Bahrain_National_Insurance_Company_Bpp_20250515 >									
97 	//        < A0Ftit5FRsZMdG0Q4y3UN38RyhZ2HDeZOi890747WXB7yZfAiXlJJC42fHA5uzsh >									
98 	//        < 1E-018 limites [ 58476194,9549572 ; 106810047,899488 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000015C8B999B27CA334E9 >									
100 	//     < RE_Portfolio_VI_metadata_line_3_____Bahrain_National_Insurance_Company_Bpp_20250515 >									
101 	//        < D8X5DEcV2ljt38zeueMRvfbRJkMnpl21bAq94223EwQ7ufn95UU1j7OCbzM82ru1 >									
102 	//        < 1E-018 limites [ 106810047,899488 ; 161992546,978692 ] >									
103 	//        < 0x000000000000000000000000000000000000000000000027CA334E93C58D049D >									
104 	//     < RE_Portfolio_VI_metadata_line_4_____Barbados_BBp_Ocean_International_Reinsurance_Company_Limited_Am_20250515 >									
105 	//        < bkT29z0k6X3wjlNaOCO3iG3FTMq6622sR3KCZHmp2rHpyZ271qJD36KZGLBSG5b8 >									
106 	//        < 1E-018 limites [ 161992546,978692 ; 240256011,960736 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000003C58D049D5980996A0 >									
108 	//     < RE_Portfolio_VI_metadata_line_5_____Barbican_Managing_Agency_Limited_20250515 >									
109 	//        < UXKa8g8Vp56OERa4zq5fj1DmkrwMsojS14171Cup5y3G298nuNiO2W0GYyDdqnXm >									
110 	//        < 1E-018 limites [ 240256011,960736 ; 260014161,993263 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000005980996A060DCE21FB >									
112 	//     < RE_Portfolio_VI_metadata_line_6_____Barbican_Managing_Agency_Limited_20250515 >									
113 	//        < 0Wzzd3oBi3a78e4qxPUn2VXvL7t98C0vj6OP3jYBY7ZPqNMc78ogVT1misV1OXIZ >									
114 	//        < 1E-018 limites [ 260014161,993263 ; 271442165,890077 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000060DCE21FB651EBE201 >									
116 	//     < RE_Portfolio_VI_metadata_line_7_____Barbican_Managing_Agency_Limited_20250515 >									
117 	//        < 4cImKXx249139eAAiyULf5YofF9heUeZMVVSosX3UE2H3uHX863G54xdhtZ0UJZ0 >									
118 	//        < 1E-018 limites [ 271442165,890077 ; 282379409,648774 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000651EBE2016931CCAD8 >									
120 	//     < RE_Portfolio_VI_metadata_line_8_____Barbican_Managing_Agency_Limited_20250515 >									
121 	//        < KHQj1D1JdVUgG9xfjUj8zBlPm31WjLw71nf4adoVhTBj8jjSClSEXRWnJamw3ka0 >									
122 	//        < 1E-018 limites [ 282379409,648774 ; 329416072,370832 ] >									
123 	//        < 0x00000000000000000000000000000000000000000000006931CCAD87AB790B39 >									
124 	//     < RE_Portfolio_VI_metadata_line_9_____Barbican_Managing_Agency_Limited_20250515 >									
125 	//        < aoNb2kvhm2hf4nu4L9W2Qf7D72atkN9D3j25bW5zNUI8cdm5wKjfFjI1m6CABgj1 >									
126 	//        < 1E-018 limites [ 329416072,370832 ; 342667547,849822 ] >									
127 	//        < 0x00000000000000000000000000000000000000000000007AB790B397FA7530D4 >									
128 	//     < RE_Portfolio_VI_metadata_line_10_____Barbican_Managing_Agency_Limited_20250515 >									
129 	//        < 66006KP3THB17gQe10yx9hKeLBJ5H8o33k1gnuw98dLc69SK8g3dnQjy1T1qP2AW >									
130 	//        < 1E-018 limites [ 342667547,849822 ; 369687045,578735 ] >									
131 	//        < 0x00000000000000000000000000000000000000000000007FA7530D489B81AC21 >									
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
174 	//     < RE_Portfolio_VI_metadata_line_11_____Barbican_Managing_Agency_Limited_20250515 >									
175 	//        < fgnIPwESd3JvFfQwGfPT4MO3Bi8cSusebELTFXLh8ie4g6p1wUQMyPnngO278821 >									
176 	//        < 1E-018 limites [ 369687045,578735 ; 421910988,385822 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000089B81AC219D2C915CA >									
178 	//     < RE_Portfolio_VI_metadata_line_12_____Barbican_Managing_Agency_Limited_20250515 >									
179 	//        < 1tV2vmNG34w4J76ua504Vq98iy4qbR4DUzB1OcAZIA6IHK9lDiL3Jj1jG7CI3AK2 >									
180 	//        < 1E-018 limites [ 421910988,385822 ; 452326717,02779 ] >									
181 	//        < 0x00000000000000000000000000000000000000000000009D2C915CAA8813CDCA >									
182 	//     < RE_Portfolio_VI_metadata_line_13_____Barbican_Managing_Agency_Limited_20250515 >									
183 	//        < IYrztLqBVwlA4R73aAlK2Wbv16YcOZV6mf0aT148g14nxvb0YPU0ebr9zLB2og49 >									
184 	//        < 1E-018 limites [ 452326717,02779 ; 476891498,519504 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000A8813CDCAB1A7EAF8F >									
186 	//     < RE_Portfolio_VI_metadata_line_14_____Barbican_Managing_Agency_Limited_20250515 >									
187 	//        < vwtH8E72Nicex9G7tkijWUG4E4ui3QNceow5PU84O26232Yogqa420652J37kGkq >									
188 	//        < 1E-018 limites [ 476891498,519504 ; 529298156,81933 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000B1A7EAF8FC52DCE675 >									
190 	//     < RE_Portfolio_VI_metadata_line_15_____Barbican_Managing_Agency_Limited_20250515 >									
191 	//        < S5c2teDwzwGKBX4QTNY2R4U8ZfX49A9585Y395814b05EeKF1moWo0wxHDkT7pp1 >									
192 	//        < 1E-018 limites [ 529298156,81933 ; 586861651,584666 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000C52DCE675DA9F7D29A >									
194 	//     < RE_Portfolio_VI_metadata_line_16_____Barbican_Managing_Agency_Limited_20250515 >									
195 	//        < Ws9TRPf9KUt25Y0Sc9Vade5lVuY229bZHCo7eN8r1sq1WJV5wRN9lsQrv5Oo2cCC >									
196 	//        < 1E-018 limites [ 586861651,584666 ; 647953651,818747 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000DA9F7D29AF161AD131 >									
198 	//     < RE_Portfolio_VI_metadata_line_17_____BB_Arab_Orient_Insurance_Company__gig_Jordan__Bpp_20250515 >									
199 	//        < ZA6zLJgkFx4V0E7LLo81AnIZQXm66304FAtJe4C2W043hJ8aI2s71PiPl58uSu0A >									
200 	//        < 1E-018 limites [ 647953651,818747 ; 722676815,135166 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000F161AD13110D37D50DD >									
202 	//     < RE_Portfolio_VI_metadata_line_18_____Beaufort_Underwriting_Agency_Limited_20250515 >									
203 	//        < l47nOwhRnbj1GMXx7003Huj0fu1Zj5B86KW8qwq6mmLF8b68C3I4LJqQ25aiAl2r >									
204 	//        < 1E-018 limites [ 722676815,135166 ; 737785773,924694 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000010D37D50DD112D8BC1E4 >									
206 	//     < RE_Portfolio_VI_metadata_line_19_____Beaufort_Underwriting_Agency_Limited_20250515 >									
207 	//        < 49b1Z8f3ImhwBJ57Mprz4B05XP56q8Hsiz35fivnFrTKe22ijuG44f229Rbs4WIE >									
208 	//        < 1E-018 limites [ 737785773,924694 ; 816289199,481009 ] >									
209 	//        < 0x00000000000000000000000000000000000000000000112D8BC1E41301767A80 >									
210 	//     < RE_Portfolio_VI_metadata_line_20_____Beaufort_Underwriting_Agency_Limited_20250515 >									
211 	//        < r39fOmBVMZvFoaO0C9E0208F8b00dsoGty1pVkG8ouCNtE9UFB53AhRTi144B7h8 >									
212 	//        < 1E-018 limites [ 816289199,481009 ; 867562577,72788 ] >									
213 	//        < 0x000000000000000000000000000000000000000000001301767A8014331371E0 >									
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
256 	//     < RE_Portfolio_VI_metadata_line_21_____Beaufort_Underwriting_Agency_Limited_20250515 >									
257 	//        < k7IPE6AH92H6Z0W0f7fXk5rsgSB239q9bV8a735rKRHOA2V0h1xlt7dj6ckml60a >									
258 	//        < 1E-018 limites [ 867562577,72788 ; 913190317,096599 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000014331371E0154309D991 >									
260 	//     < RE_Portfolio_VI_metadata_line_22_____Beaufort_Underwriting_Agency_Limited_20250515 >									
261 	//        < 2t6bqH2y3paeS5aBRrY79DTgEe4w05lsz2EBM9n9T8g4k7Ek83a32ICD2ydv93sx >									
262 	//        < 1E-018 limites [ 913190317,096599 ; 961785546,146919 ] >									
263 	//        < 0x00000000000000000000000000000000000000000000154309D9911664B048EA >									
264 	//     < RE_Portfolio_VI_metadata_line_23_____Beazley_Furlonge_Limited_20250515 >									
265 	//        < X465Ox66wLf09Z96I4mU07x2Jm586MKI3S67P493qQ6UDV26GScs2O1ycVbbJDS3 >									
266 	//        < 1E-018 limites [ 961785546,146919 ; 973625504,348361 ] >									
267 	//        < 0x000000000000000000000000000000000000000000001664B048EA16AB42A096 >									
268 	//     < RE_Portfolio_VI_metadata_line_24_____Beazley_Furlonge_Limited_20250515 >									
269 	//        < d42x39rMK8rSxxZ3J1y9yTK9GP7ge63jQq3DO058E2Xv6C37lZru8xA1t932OAe3 >									
270 	//        < 1E-018 limites [ 973625504,348361 ; 987132117,658167 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000016AB42A09616FBC41569 >									
272 	//     < RE_Portfolio_VI_metadata_line_25_____Beazley_Furlonge_Limited_20250515 >									
273 	//        < 6gvuH8915D5F1xv0GS8go2zBsRf0L3gB8JgK5eflN3jbnAc17w9zemjhL361n0h9 >									
274 	//        < 1E-018 limites [ 987132117,658167 ; 1049031449,41095 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000016FBC41569186CB6F7E1 >									
276 	//     < RE_Portfolio_VI_metadata_line_26_____Beazley_Furlonge_Limited_20250515 >									
277 	//        < 91HE6eya3NSnHAK6Wb41E8HWIy1jqcTr61XT10y5gj93F41kJs0z0v4v1S96h36u >									
278 	//        < 1E-018 limites [ 1049031449,41095 ; 1061078629,80403 ] >									
279 	//        < 0x00000000000000000000000000000000000000000000186CB6F7E118B48581B8 >									
280 	//     < RE_Portfolio_VI_metadata_line_27_____Beazley_Furlonge_Limited_20250515 >									
281 	//        < PY74vbjUfO02hw9GS5K7Ghgpv6j3ocsX3k9pn2Am4I696hX48aZoVb3wo76CGUOI >									
282 	//        < 1E-018 limites [ 1061078629,80403 ; 1127323020,54141 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000018B48581B81A3F5E6CDA >									
284 	//     < RE_Portfolio_VI_metadata_line_28_____Beazley_Furlonge_Limited_20250515 >									
285 	//        < dgveAm8a50n2EUBZd91XOFt4nZRRytvbhF907w4kNmvl9g55iikDIqhfvl86tahv >									
286 	//        < 1E-018 limites [ 1127323020,54141 ; 1144498730,42965 ] >									
287 	//        < 0x000000000000000000000000000000000000000000001A3F5E6CDA1AA5BE7A86 >									
288 	//     < RE_Portfolio_VI_metadata_line_29_____Beazley_Furlonge_Limited_20250515 >									
289 	//        < 549v09673D169bHdGlM7qe5dfYnKNBY7CUQxUOBhnp49FAJ0Du0VB6aD0PV4P0X1 >									
290 	//        < 1E-018 limites [ 1144498730,42965 ; 1162248478,27049 ] >									
291 	//        < 0x000000000000000000000000000000000000000000001AA5BE7A861B0F8A71C7 >									
292 	//     < RE_Portfolio_VI_metadata_line_30_____Beazley_Furlonge_Limited_20250515 >									
293 	//        < l7PYT0xen3e55O8n22lJ8s2k993y5GSVORtaUlOG99VIHA9b3f38tkK84e1WbJIK >									
294 	//        < 1E-018 limites [ 1162248478,27049 ; 1211123828,41166 ] >									
295 	//        < 0x000000000000000000000000000000000000000000001B0F8A71C71C32DC4F6D >									
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
338 	//     < RE_Portfolio_VI_metadata_line_31_____Beazley_Furlonge_Limited_20250515 >									
339 	//        < pfYnBXTSyHOOH8bd6DrqZFga5x8yoUnEs9O320Y3ELm7REu7g8m9S80tpn8W7S4f >									
340 	//        < 1E-018 limites [ 1211123828,41166 ; 1229969630,17424 ] >									
341 	//        < 0x000000000000000000000000000000000000000000001C32DC4F6D1CA330B8BD >									
342 	//     < RE_Portfolio_VI_metadata_line_32_____Beazley_Furlonge_Limited_20250515 >									
343 	//        < CQb7u29014hI4j31iuIIKC10cPqnmYiG8QX5Btjv58x1QpY67Ctnfw28qrlksh7V >									
344 	//        < 1E-018 limites [ 1229969630,17424 ; 1254347214,90725 ] >									
345 	//        < 0x000000000000000000000000000000000000000000001CA330B8BD1D347DF6C6 >									
346 	//     < RE_Portfolio_VI_metadata_line_33_____Beazley_Furlonge_Limited_20250515 >									
347 	//        < e4t3LnjaXFA1NFc9p4fCS69fp6nM551pBG2086AGe8On29brno2ZxXvw5g06HzXJ >									
348 	//        < 1E-018 limites [ 1254347214,90725 ; 1319205031,23991 ] >									
349 	//        < 0x000000000000000000000000000000000000000000001D347DF6C61EB7132347 >									
350 	//     < RE_Portfolio_VI_metadata_line_34_____Beazley_Furlonge_Limited_20250515 >									
351 	//        < B67U0gq8S8T3kKQ2U1Iv72WTN2wVFo9BVxiO33rS495L4gWr263LSLnwDCY6Y962 >									
352 	//        < 1E-018 limites [ 1319205031,23991 ; 1353643044,52268 ] >									
353 	//        < 0x000000000000000000000000000000000000000000001EB71323471F84576038 >									
354 	//     < RE_Portfolio_VI_metadata_line_35_____Beazley_Furlonge_Limited_20250515 >									
355 	//        < bUDby43CVmoa3m46w15ky76r6V59F1eC26Rgk5Uy697tyFO06Ne4A7ey92aX2O32 >									
356 	//        < 1E-018 limites [ 1353643044,52268 ; 1369547932,88141 ] >									
357 	//        < 0x000000000000000000000000000000000000000000001F845760381FE3244F3C >									
358 	//     < RE_Portfolio_VI_metadata_line_36_____Beazley_Furlonge_Limited_20250515 >									
359 	//        < g8X540lhZmq5b54n9ZTZjh1O2xAvwceKPLJFUibe9EBCa654OomIO7zGuOCfgZPb >									
360 	//        < 1E-018 limites [ 1369547932,88141 ;  ] >									
361 	//        < 0x000000000000000000000000000000000000000000001FE3244F3C212273C6CF >									
362 	//     < RE_Portfolio_VI_metadata_line_37_____Belgium_AA_Aviabel_Cie_Belge_d_Assurances_Aviation_SA_Am_20250515 >									
363 	//        < XDqH1E8711jF47Ip2R4G020242t9l4YQ4Kc335Nc347lVXSPtZi585QbqN14PB2A >									
364 	//        < 1E-018 limites [ 1423119331,47459 ; 1439452408,3517 ] >									
365 	//        < 0x00000000000000000000000000000000000000000000212273C6CF2183CE12F7 >									
366 	//     < RE_Portfolio_VI_metadata_line_38_____Belgium_AA_Aviabel_Cie_Belge_d_Assurances_Aviation_SA_Am_20250515 >									
367 	//        < FkPclwS6IU2NEoj9o4Sci3ziI4123s06165lZ5L93Y541C736ek86TZ6uR58B8Gi >									
368 	//        < 1E-018 limites [ 1439452408,3517 ; 1467333157,99716 ] >									
369 	//        < 0x000000000000000000000000000000000000000000002183CE12F72229FCB8CB >									
370 	//     < RE_Portfolio_VI_metadata_line_39_____Berkley_Regional_Insurance_Co_Ap_Ap_20250515 >									
371 	//        < XTMveZ91O2SpwQEbgZ7pr4ru8capXo3TEkFS0DxeOV58DNO1d289NUV1YBTMp194 >									
372 	//        < 1E-018 limites [ 1467333157,99716 ; 1487515326,21528 ] >									
373 	//        < 0x000000000000000000000000000000000000000000002229FCB8CB22A2484441 >									
374 	//     < RE_Portfolio_VI_metadata_line_40_____Berkshire_Hathaway_Incorporated_20250515 >									
375 	//        < 5IgmT65b0y8d8W6XAv68qMoDGMch92ypHef0X2PPnrDrzAi6j1Ur8iO86p2scwY1 >									
376 	//        < 1E-018 limites [ 1487515326,21528 ; 1518671758,71355 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000022A2484441235BFD35B3 >									
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