1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXIV_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXIV_III_883		"	;
8 		string	public		symbol =	"	RUSS_PFXIV_III_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1060016423393420000000000000					;	
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
92 	//     < RUSS_PFXIV_III_metadata_line_1_____NORIMET_LIMITED_20251101 >									
93 	//        < 68V59z3ttOa9M07fg64fn5fz8g4c3Y2gls5jKZg2KgZN58gkp7yE187DmC3jrF18 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000026365647.288762200000000000 ] >									
95 	//        < 0x0000000000000000000000000000000000000000000000000000000000283B15 >									
96 	//     < RUSS_PFXIV_III_metadata_line_2_____NORNICKEL_AUSTRALIA_PTY_LIMITED_20251101 >									
97 	//        < N233W2p84t8vRWgNd5wn35N96fDMfgFQSkXH6TSt1EDU66ZKz94EW2z335rdZszl >									
98 	//        <  u =="0.000000000000000001" : ] 000000026365647.288762200000000000 ; 000000059407645.457685200000000000 ] >									
99 	//        < 0x0000000000000000000000000000000000000000000000000000283B155AA61D >									
100 	//     < RUSS_PFXIV_III_metadata_line_3_____NORILSKGAZPROM_20251101 >									
101 	//        < 1Era11u9srMzFa0Ot1k4hI04IoGUrn4az20VzfH8a47y5s2f6Gz7J4Pn3Mad4LDx >									
102 	//        <  u =="0.000000000000000001" : ] 000000059407645.457685200000000000 ; 000000083721006.341165500000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000005AA61D7FBF85 >									
104 	//     < RUSS_PFXIV_III_metadata_line_4_____NORILSK_NICKEL_USA_INC_20251101 >									
105 	//        < BqzDHJNRw7BuN7Z2V4V5Lgtb50d19W4i6DOCHslw063M7T3hUZEVonM7Pz6nu54x >									
106 	//        <  u =="0.000000000000000001" : ] 000000083721006.341165500000000000 ; 000000111087264.418532000000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000007FBF85A98176 >									
108 	//     < RUSS_PFXIV_III_metadata_line_5_____DALRYMPLE_RESOURCES_PTY_LTD_20251101 >									
109 	//        < RohPG24Ce1a40r8Uhs94LKL651IJoKncSW49HA41v3UBb0X8bLqC8m5DYXM7n236 >									
110 	//        <  u =="0.000000000000000001" : ] 000000111087264.418532000000000000 ; 000000142584144.077325000000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000A98176D990EE >									
112 	//     < RUSS_PFXIV_III_metadata_line_6_____MPI_NICKEL_PTY_LTD_20251101 >									
113 	//        < nYcFyd5W1Y67eqIR3rdTV9n8v746J69MW2RqTaw9go5sJ5NtcZw3OOsO9xMO2gE5 >									
114 	//        <  u =="0.000000000000000001" : ] 000000142584144.077325000000000000 ; 000000162065165.049514000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000D990EEF74AB5 >									
116 	//     < RUSS_PFXIV_III_metadata_line_7_____CAWSE_PROPRIETARY_LIMITED_20251101 >									
117 	//        < gd4vuk2y06Fz9LhBizEv0HFGSPYJ4DrMemCf41em0XVtd4jhx3swWsflJ4u0Zq5T >									
118 	//        <  u =="0.000000000000000001" : ] 000000162065165.049514000000000000 ; 000000189330933.287412000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000000F74AB5120E565 >									
120 	//     < RUSS_PFXIV_III_metadata_line_8_____NORNICKEL_TERMINAL_20251101 >									
121 	//        < fn4oYmWgWd9vE8w8y1igO1Rp75j5886OofjOj9u5us6MNFy4531Q543JdcX4cOlT >									
122 	//        <  u =="0.000000000000000001" : ] 000000189330933.287412000000000000 ; 000000208099806.174049000000000000 ] >									
123 	//        < 0x00000000000000000000000000000000000000000000000000120E56513D88FD >									
124 	//     < RUSS_PFXIV_III_metadata_line_9_____NORILSKPROMTRANSPORT_20251101 >									
125 	//        < gbV3SSV1vC3ts4PXl9h2vLf16zYz6TAtV02T4CQzq2qwv0d144GM7mnOD2RG87Fu >									
126 	//        <  u =="0.000000000000000001" : ] 000000208099806.174049000000000000 ; 000000229194195.141578000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000013D88FD15DB8FC >									
128 	//     < RUSS_PFXIV_III_metadata_line_10_____NORILSKGEOLOGIYA_OOO_20251101 >									
129 	//        < PrWbwd56158A4ugGuLsS5Fkpi5n6IqAqWn4C78P2qKsK0XcB2E810XO6g54KZ9xL >									
130 	//        <  u =="0.000000000000000001" : ] 000000229194195.141578000000000000 ; 000000248946515.837471000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000015DB8FC17BDCBC >									
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
174 	//     < RUSS_PFXIV_III_metadata_line_11_____NORNICKEL_FINLAND_OY_20251101 >									
175 	//        < 1mAdP9VXCV4Cr805Ni7aq0877Ux45BVPNU0DoBF7KxlbTapZ4hG4fz0KiC2XF8or >									
176 	//        <  u =="0.000000000000000001" : ] 000000248946515.837471000000000000 ; 000000284673388.260645000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000017BDCBC1B2608B >									
178 	//     < RUSS_PFXIV_III_metadata_line_12_____CORBIERE_HOLDINGS_LTD_20251101 >									
179 	//        < hIROsl2U4Qrex1JcOz78QW7zhCnQFfhr78232z6k7EQ2h76N14Eu6fvgtJO4eS5M >									
180 	//        <  u =="0.000000000000000001" : ] 000000284673388.260645000000000000 ; 000000303776293.119609000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000001B2608B1CF869D >									
182 	//     < RUSS_PFXIV_III_metadata_line_13_____MEDVEZHY_RUCHEY_20251101 >									
183 	//        < hf19hg98e0K76TWH03I4yFaGdZAMnQ46xP55Md1yn0Ioa835f2B610j7mUaYx5ia >									
184 	//        <  u =="0.000000000000000001" : ] 000000303776293.119609000000000000 ; 000000338736807.242257000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001CF869D204DF11 >									
186 	//     < RUSS_PFXIV_III_metadata_line_14_____NNK_TRADITSIYA_20251101 >									
187 	//        < xcoPS4u43Cvg1IAjXiRUPyVrG3YCs5qt6XoRfgMl440zN6O4fS4Md6pRboRi7h8G >									
188 	//        <  u =="0.000000000000000001" : ] 000000338736807.242257000000000000 ; 000000368151403.138410000000000000 ] >									
189 	//        < 0x00000000000000000000000000000000000000000000000000204DF11231C124 >									
190 	//     < RUSS_PFXIV_III_metadata_line_15_____RADIO_SEVERNY_GOROD_20251101 >									
191 	//        < OWJP5X9AW254idf0AyLeeBH3VHROlZi8b0TtvZjonurOWG536XCoilIZXgZ2Lk0v >									
192 	//        <  u =="0.000000000000000001" : ] 000000368151403.138410000000000000 ; 000000395245518.077479000000000000 ] >									
193 	//        < 0x00000000000000000000000000000000000000000000000000231C12425B18C8 >									
194 	//     < RUSS_PFXIV_III_metadata_line_16_____ALYKEL_20251101 >									
195 	//        < z460WLxTGNRq7YUWd2g93tBCyCy6198rx3O13dCZxI631Ju79aCV61VzSe0397dx >									
196 	//        <  u =="0.000000000000000001" : ] 000000395245518.077479000000000000 ; 000000415546906.430723000000000000 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000000025B18C827A1303 >									
198 	//     < RUSS_PFXIV_III_metadata_line_17_____GEOKOMP_OOO_20251101 >									
199 	//        < g1j6bSw79fIc0i10AL6H62dClKx8So3f4CX921bVVt9WCO6rsIFE35Pa09OpF8Pu >									
200 	//        <  u =="0.000000000000000001" : ] 000000415546906.430723000000000000 ; 000000446904621.552299000000000000 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000000027A13032A9EC1E >									
202 	//     < RUSS_PFXIV_III_metadata_line_18_____LIONORE_SOUTH_AFRICA_20251101 >									
203 	//        < C3GK07X536GQ9l27bXrJA6aJv0J4kvbFQ1H62IeeqwXXbkm1YkPd0vki4G8WOYb5 >									
204 	//        <  u =="0.000000000000000001" : ] 000000446904621.552299000000000000 ; 000000470038545.929545000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000002A9EC1E2CD38CF >									
206 	//     < RUSS_PFXIV_III_metadata_line_19_____VESHCHATELNAYA_KORPORATSIYA_TELESFERA_20251101 >									
207 	//        < FQ11H9YKY2S3ADjC5DF7l57s2Sq46nhj1vW6yp17UD0bIb6dgF0Iw16u0pJEg9mq >									
208 	//        <  u =="0.000000000000000001" : ] 000000470038545.929545000000000000 ; 000000491379893.675923000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000002CD38CF2EDC945 >									
210 	//     < RUSS_PFXIV_III_metadata_line_20_____SRETENSKAYA_COPPER_COMPANY_20251101 >									
211 	//        < acRQ9L53vf0J5grPJ3uZ7JXu3WZFN2au4ITO18tR8T669u8s4R1G54IHe5u6OR2m >									
212 	//        <  u =="0.000000000000000001" : ] 000000491379893.675923000000000000 ; 000000510588940.488856000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000002EDC94530B18CE >									
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
256 	//     < RUSS_PFXIV_III_metadata_line_21_____NORILSKNICKELREMONT_20251101 >									
257 	//        < 0k89UH3J6vA4sMQwN4ZzW1512gl12ZbaF4KUW5880j9K9ge16LjcwaOe77l3891o >									
258 	//        <  u =="0.000000000000000001" : ] 000000510588940.488856000000000000 ; 000000531606761.183270000000000000 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000000030B18CE32B2AE4 >									
260 	//     < RUSS_PFXIV_III_metadata_line_22_____NORILSK_NICKEL_INTERGENERATION_20251101 >									
261 	//        < 9s7405579WLw6uReAD697IC6yY1hW8CVhO9wHcN76V97KO7w9vIScWy6aFl2qGr5 >									
262 	//        <  u =="0.000000000000000001" : ] 000000531606761.183270000000000000 ; 000000565900747.323132000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000032B2AE435F7EFB >									
264 	//     < RUSS_PFXIV_III_metadata_line_23_____PERVAYA_MILYA_OOO_20251101 >									
265 	//        < 30gSfYJDG7kDPR1dCrbd9s6rj66DQaVpW2Jm5312oUx1MFt4RFd62wJX5EHD4q76 >									
266 	//        <  u =="0.000000000000000001" : ] 000000565900747.323132000000000000 ; 000000590087255.029266000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000035F7EFB38466D6 >									
268 	//     < RUSS_PFXIV_III_metadata_line_24_____NORILSKNICKELREMONT_OOO_20251101 >									
269 	//        < 05B5qiGElEZ1FCmS6pMZg8Sy5716xcQ2lk0Y3VenG8kaq4xpoQ626kk6xjjO0YAy >									
270 	//        <  u =="0.000000000000000001" : ] 000000590087255.029266000000000000 ; 000000623404440.728514000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000038466D63B73D5C >									
272 	//     < RUSS_PFXIV_III_metadata_line_25_____NORNICKEL_INT_HOLDINS_CANADA_20251101 >									
273 	//        < 61d83W5f43NvCMBZMiA15183bc7ZawH9nNu3fU32oVO7X6mSsBGq34g82m3iRgA7 >									
274 	//        <  u =="0.000000000000000001" : ] 000000623404440.728514000000000000 ; 000000648994119.398273000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000003B73D5C3DE4954 >									
276 	//     < RUSS_PFXIV_III_metadata_line_26_____INTERGEOPROYEKT_LLC_20251101 >									
277 	//        < Z9JNf0x98qtF8zZlUaARD6XHSCKaI1eRr6N8rSWAKLFqq21LZ296s28TX723i252 >									
278 	//        <  u =="0.000000000000000001" : ] 000000648994119.398273000000000000 ; 000000683139315.997395000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000003DE4954412634C >									
280 	//     < RUSS_PFXIV_III_metadata_line_27_____WESTERN_MINERALS_TECHNOLOGY_20251101 >									
281 	//        < d9Qy5163tlFcIK9JKSJO5t6FaKi8jwdN3800sR96cm8jp7XJKr8d79mW81pY2pAV >									
282 	//        <  u =="0.000000000000000001" : ] 000000683139315.997395000000000000 ; 000000706220865.459831000000000000 ] >									
283 	//        < 0x00000000000000000000000000000000000000000000000000412634C4359B87 >									
284 	//     < RUSS_PFXIV_III_metadata_line_28_____NORMETIMPEX_20251101 >									
285 	//        < HV2N2qNTckl9vVVan6ozbl570yX9t2U20567348bmNcP8L0GyY6tM9h575P6f07v >									
286 	//        <  u =="0.000000000000000001" : ] 000000706220865.459831000000000000 ; 000000737972640.343625000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000004359B874660E90 >									
288 	//     < RUSS_PFXIV_III_metadata_line_29_____RAO_NORNICKEL_20251101 >									
289 	//        < Lbd97tn4pb5kn39h1xR003zAIu0oU280GOk2sd63O6j5mi9pg1dT07fsp8slo350 >									
290 	//        <  u =="0.000000000000000001" : ] 000000737972640.343625000000000000 ; 000000765703222.478686000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000004660E904905ED2 >									
292 	//     < RUSS_PFXIV_III_metadata_line_30_____ZAPOLYARNAYA_STROITELNAYA_KOMPANIYA_20251101 >									
293 	//        < 7f0g292ZSOJs0enw6Dir22W9Y313pN0qAm0jR07C2M5048G5t8tpIrJvrQeFk7S6 >									
294 	//        <  u =="0.000000000000000001" : ] 000000765703222.478686000000000000 ; 000000796177257.888003000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000004905ED24BEDEBE >									
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
338 	//     < RUSS_PFXIV_III_metadata_line_31_____NORNICKEL_PROCESSING_TECH_20251101 >									
339 	//        < 6zRc8Kra60DlkCheXl3a8RBfjHL6f50wzX81HKx2Brs8seuYg292H9Rj90F3CBUE >									
340 	//        <  u =="0.000000000000000001" : ] 000000796177257.888003000000000000 ; 000000816425307.262803000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000004BEDEBE4DDC423 >									
342 	//     < RUSS_PFXIV_III_metadata_line_32_____NORNICKEL_KTK_20251101 >									
343 	//        < 42hWT4ow9FlPl7r4h9Vs1ZZe1Ma5wcnbe68c6tl0u3rhz9KC2iW73x2LAi0S3Br3 >									
344 	//        <  u =="0.000000000000000001" : ] 000000816425307.262803000000000000 ; 000000838654451.123280000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000004DDC4234FFAF65 >									
346 	//     < RUSS_PFXIV_III_metadata_line_33_____NORILSKYI_OBESPECHIVAUSHYI_COMPLEX_20251101 >									
347 	//        < lrPQJi88XLlROvLijV1GWT3RP8TE4118U0YVYX79bP314M37852mMj0XYUC0oCvA >									
348 	//        <  u =="0.000000000000000001" : ] 000000838654451.123280000000000000 ; 000000870781026.162720000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000004FFAF65530B4D7 >									
350 	//     < RUSS_PFXIV_III_metadata_line_34_____GRK_BYSTRINSKOYE_20251101 >									
351 	//        < c9y5V9qL4scXA17Y9fSv5oCxc0vB444Ba17eT4JxpacIUi4GD9wAC0B932v85Jca >									
352 	//        <  u =="0.000000000000000001" : ] 000000870781026.162720000000000000 ; 000000894389336.745214000000000000 ] >									
353 	//        < 0x00000000000000000000000000000000000000000000000000530B4D7554BAD6 >									
354 	//     < RUSS_PFXIV_III_metadata_line_35_____NORILSKIY_KOMBINAT_20251101 >									
355 	//        < mppKGEJuCqNt5qQc3XKJBjTX143hp10CuR67zD9q1E14edVYgDte667o80PPJWEd >									
356 	//        <  u =="0.000000000000000001" : ] 000000894389336.745214000000000000 ; 000000919175674.507840000000000000 ] >									
357 	//        < 0x00000000000000000000000000000000000000000000000000554BAD657A8CFF >									
358 	//     < RUSS_PFXIV_III_metadata_line_36_____HARJAVALTA_OY_20251101 >									
359 	//        < Lb1A8FDK3g3L3y95w3ZB2u63pw54M5Jc56w9171r036WligeLLV7P36g8K1884Pe >									
360 	//        <  u =="0.000000000000000001" : ] 000000919175674.507840000000000000 ; 000000950767536.247876000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000057A8CFF5AAC192 >									
362 	//     < RUSS_PFXIV_III_metadata_line_37_____ZAPOLYARNYI_TORGOVYI_ALIANS_20251101 >									
363 	//        < EplMCSS15v759E2fGN8waKa64753NE743X3n5X40V13eR7H99IIpznH4BF43cLI3 >									
364 	//        <  u =="0.000000000000000001" : ] 000000950767536.247876000000000000 ; 000000980190136.959205000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000005AAC1925D7A6C6 >									
366 	//     < RUSS_PFXIV_III_metadata_line_38_____AVALON_20251101 >									
367 	//        < dFY38Dh8ib69dmc20YJarS7N9b7WqB816O5bDi9P4p44yHgYtKxM868xTvgzJoW3 >									
368 	//        <  u =="0.000000000000000001" : ] 000000980190136.959205000000000000 ; 000000999447427.124305000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000005D7A6C65F50927 >									
370 	//     < RUSS_PFXIV_III_metadata_line_39_____GUSINOOZERSKAYA_20251101 >									
371 	//        < PNNtTxX4ogL8MhiOM86LtDwTv89qzUW0B9EBH4Suc4z07JE69DK186l75gOu6Ekv >									
372 	//        <  u =="0.000000000000000001" : ] 000000999447427.124305000000000000 ; 000001030215516.076700000000000000 ] >									
373 	//        < 0x000000000000000000000000000000000000000000000000005F50927623FBF0 >									
374 	//     < RUSS_PFXIV_III_metadata_line_40_____NORNICKEL_PSMK_OOO_20251101 >									
375 	//        < 6dD5OjK1V55WbA1mS22QpA7vGz8LK2yZJZ4i38DZ1GW9q9M2dVf9AN71oF9147c4 >									
376 	//        <  u =="0.000000000000000001" : ] 000001030215516.076700000000000000 ; 000001060016423.393420000000000000 ] >									
377 	//        < 0x00000000000000000000000000000000000000000000000000623FBF065174EA >									
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