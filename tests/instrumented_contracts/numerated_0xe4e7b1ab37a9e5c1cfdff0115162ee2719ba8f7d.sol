1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXIV_II_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXIV_II_883		"	;
8 		string	public		symbol =	"	RUSS_PFXIV_II_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		795614035169367000000000000					;	
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
92 	//     < RUSS_PFXIV_II_metadata_line_1_____NORIMET_LIMITED_20231101 >									
93 	//        < 1U2F5daAm15re7K282ZR6aU0h61QuEo06iSmjY1ewkKFR6XQ8672J8vHKg50xW30 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000018302113.161568100000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000001BED43 >									
96 	//     < RUSS_PFXIV_II_metadata_line_2_____NORNICKEL_AUSTRALIA_PTY_LIMITED_20231101 >									
97 	//        < 3q5O7zNld33a1enA5qg2oKDv3rr1371UUn046mNsUWLyW4On6vadB093hDa0RJ45 >									
98 	//        <  u =="0.000000000000000001" : ] 000000018302113.161568100000000000 ; 000000043182994.963161200000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000001BED4341E45B >									
100 	//     < RUSS_PFXIV_II_metadata_line_3_____NORILSKGAZPROM_20231101 >									
101 	//        < M66W5Q45n8eXNHSjw6rR5EOSDannzgVE9AT4UE1BLDCp96dFYhKcewjY39R4p7Ps >									
102 	//        <  u =="0.000000000000000001" : ] 000000043182994.963161200000000000 ; 000000060024825.897479800000000000 ] >									
103 	//        < 0x000000000000000000000000000000000000000000000000000041E45B5B9733 >									
104 	//     < RUSS_PFXIV_II_metadata_line_4_____NORILSK_NICKEL_USA_INC_20231101 >									
105 	//        < 4A36dHNh4E2XKOy9110sIW43xr7N99r47qp0wV9P0hnZfJ08ybI0465mVPuOlDM5 >									
106 	//        <  u =="0.000000000000000001" : ] 000000060024825.897479800000000000 ; 000000082697463.639882300000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000005B97337E2FB2 >									
108 	//     < RUSS_PFXIV_II_metadata_line_5_____DALRYMPLE_RESOURCES_PTY_LTD_20231101 >									
109 	//        < 4v6548v0l5Qw4iS3v9upsVNzD7UdTK4io4JN8Fh5QAL7aZfZg5WE69qg4FOusJ3V >									
110 	//        <  u =="0.000000000000000001" : ] 000000082697463.639882300000000000 ; 000000107343629.529494000000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000007E2FB2A3CB1B >									
112 	//     < RUSS_PFXIV_II_metadata_line_6_____MPI_NICKEL_PTY_LTD_20231101 >									
113 	//        < zX6awTcsviUqEi13xWQ6955X9oFNu51p4I8d2ap68G74xEtu7xjeZ0p47NqFQp47 >									
114 	//        <  u =="0.000000000000000001" : ] 000000107343629.529494000000000000 ; 000000130754847.489930000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000A3CB1BC7841D >									
116 	//     < RUSS_PFXIV_II_metadata_line_7_____CAWSE_PROPRIETARY_LIMITED_20231101 >									
117 	//        < ZZ3hZmufHQbV0ZYG7Cd73vwFs0H6S2p6rpVTQVtjWXNLUnj8h3uU4W1UaWxDlW5R >									
118 	//        <  u =="0.000000000000000001" : ] 000000130754847.489930000000000000 ; 000000153270986.315656000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000C7841DE9DF7B >									
120 	//     < RUSS_PFXIV_II_metadata_line_8_____NORNICKEL_TERMINAL_20231101 >									
121 	//        < HB56tuas2Y6RwRVUhLQDCwMl2kil9V9zs12mQ1ZhQXWUat73rqr8bEs43m0U1EaB >									
122 	//        <  u =="0.000000000000000001" : ] 000000153270986.315656000000000000 ; 000000176785154.324262000000000000 ] >									
123 	//        < 0x000000000000000000000000000000000000000000000000000E9DF7B10DC0B3 >									
124 	//     < RUSS_PFXIV_II_metadata_line_9_____NORILSKPROMTRANSPORT_20231101 >									
125 	//        < 0m7vx5C10pPZcXC2v1sgfjoxxE4Wj0AJ6i08R1gjunG7ftYB8Vip8ygj3nv5d9vJ >									
126 	//        <  u =="0.000000000000000001" : ] 000000176785154.324262000000000000 ; 000000201295160.252180000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000010DC0B313326EC >									
128 	//     < RUSS_PFXIV_II_metadata_line_10_____NORILSKGEOLOGIYA_OOO_20231101 >									
129 	//        < K83Ef53VmA0F6R9G16eYqSD8G11jW2Arho5SF1N73w15A8K8X2j6Ae9BvmBS95yd >									
130 	//        <  u =="0.000000000000000001" : ] 000000201295160.252180000000000000 ; 000000219365751.984581000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000013326EC14EB9BF >									
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
174 	//     < RUSS_PFXIV_II_metadata_line_11_____NORNICKEL_FINLAND_OY_20231101 >									
175 	//        < 6dE542nLhjB68njMR4HMYVDDY7G3BLSGup2koKkcv9wH1R1jDBGUF9WLf3F4OFvk >									
176 	//        <  u =="0.000000000000000001" : ] 000000219365751.984581000000000000 ; 000000239998988.351648000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000014EB9BF16E359B >									
178 	//     < RUSS_PFXIV_II_metadata_line_12_____CORBIERE_HOLDINGS_LTD_20231101 >									
179 	//        < 1DRu36Z2b9wUzh2LId5R1YvcDKfl32iwv8OBH04GV0K62EYvmLJ40MATF7y90q09 >									
180 	//        <  u =="0.000000000000000001" : ] 000000239998988.351648000000000000 ; 000000256995378.637184000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000016E359B18824D2 >									
182 	//     < RUSS_PFXIV_II_metadata_line_13_____MEDVEZHY_RUCHEY_20231101 >									
183 	//        < Jxq7T5EwF61Q16vzuz3Eo0hkN8Y28Fn3R0hGDD4JY2bh8u3gW94iV64b5J7F9Hh7 >									
184 	//        <  u =="0.000000000000000001" : ] 000000256995378.637184000000000000 ; 000000277365208.828360000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000018824D21A739C9 >									
186 	//     < RUSS_PFXIV_II_metadata_line_14_____NNK_TRADITSIYA_20231101 >									
187 	//        < 2x2Zb64F9N5Kt7575nsXG9WG5k0Auy24FHW824a0VNQgnqk0E701sS9GOmRBvLN9 >									
188 	//        <  u =="0.000000000000000001" : ] 000000277365208.828360000000000000 ; 000000299283325.266470000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000001A739C91C8AB8D >									
190 	//     < RUSS_PFXIV_II_metadata_line_15_____RADIO_SEVERNY_GOROD_20231101 >									
191 	//        < e0UDV7CZPyK9D3ZKhJ8dcdlrwr2zb6x3iXh46ch0oRVF6QlhIpdA5X2wZjn0oS48 >									
192 	//        <  u =="0.000000000000000001" : ] 000000299283325.266470000000000000 ; 000000315034454.157685000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000001C8AB8D1E0B455 >									
194 	//     < RUSS_PFXIV_II_metadata_line_16_____ALYKEL_20231101 >									
195 	//        < vs47slmvlJK7F31uCDf521BCK1TaHECm87uoU9jUTWOW69tSDWckJG36pqZiMU9L >									
196 	//        <  u =="0.000000000000000001" : ] 000000315034454.157685000000000000 ; 000000330693513.460782000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000001E0B4551F89927 >									
198 	//     < RUSS_PFXIV_II_metadata_line_17_____GEOKOMP_OOO_20231101 >									
199 	//        < D6u496p87W8bT9Bt512l9Ukx6Xw42IJQXz9wMd7BJlQwIFgb02706PXJ5vUDKV0Q >									
200 	//        <  u =="0.000000000000000001" : ] 000000330693513.460782000000000000 ; 000000346582786.981683000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000001F89927210D7E7 >									
202 	//     < RUSS_PFXIV_II_metadata_line_18_____LIONORE_SOUTH_AFRICA_20231101 >									
203 	//        < rmBM00Y8H4bdzVg6CvQtg616dlNKGrbtJ03Oy9Do0gA32fW0Ubh9DR3Fpu2rR996 >									
204 	//        <  u =="0.000000000000000001" : ] 000000346582786.981683000000000000 ; 000000368924926.266501000000000000 ] >									
205 	//        < 0x00000000000000000000000000000000000000000000000000210D7E7232EF4D >									
206 	//     < RUSS_PFXIV_II_metadata_line_19_____VESHCHATELNAYA_KORPORATSIYA_TELESFERA_20231101 >									
207 	//        < 83F35Zt1ulwa5O4gg03RhWx6Z3fdB3tJjR9c5YlDv8w2C26zsNKXEa1YZ30kF8Fm >									
208 	//        <  u =="0.000000000000000001" : ] 000000368924926.266501000000000000 ; 000000390676618.411542000000000000 ] >									
209 	//        < 0x00000000000000000000000000000000000000000000000000232EF4D254200E >									
210 	//     < RUSS_PFXIV_II_metadata_line_20_____SRETENSKAYA_COPPER_COMPANY_20231101 >									
211 	//        < E66Wbdge6JfJV1se711tnnRj2G5wd2xxMh0DcTW9op6w4LZlp1eld03Q4RcPm0m2 >									
212 	//        <  u =="0.000000000000000001" : ] 000000390676618.411542000000000000 ; 000000407952485.322903000000000000 ] >									
213 	//        < 0x00000000000000000000000000000000000000000000000000254200E26E7C71 >									
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
256 	//     < RUSS_PFXIV_II_metadata_line_21_____NORILSKNICKELREMONT_20231101 >									
257 	//        < I7np9wG8wy9yh5y22ymDCdgua87A5y066BGm9h9BqMYqwIv1Bx2TKAWdw8N13iwb >									
258 	//        <  u =="0.000000000000000001" : ] 000000407952485.322903000000000000 ; 000000430820521.818804000000000000 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000000026E7C712916144 >									
260 	//     < RUSS_PFXIV_II_metadata_line_22_____NORILSK_NICKEL_INTERGENERATION_20231101 >									
261 	//        < 02RZDQi6BC2G8R7ZxINQ66081yVw411DQpjJq0jTRm740Mxtzq43nmL9ktR7dxlv >									
262 	//        <  u =="0.000000000000000001" : ] 000000430820521.818804000000000000 ; 000000454958525.923392000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000029161442B6362D >									
264 	//     < RUSS_PFXIV_II_metadata_line_23_____PERVAYA_MILYA_OOO_20231101 >									
265 	//        < Qt0jPwTwGP4C5H35H274yR0vi061Ov8XgBbbd31y1B4e9Wpfwb8k00N2G5mvLg1F >									
266 	//        <  u =="0.000000000000000001" : ] 000000454958525.923392000000000000 ; 000000479287503.513851000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000002B6362D2DB55AE >									
268 	//     < RUSS_PFXIV_II_metadata_line_24_____NORILSKNICKELREMONT_OOO_20231101 >									
269 	//        < QB1Ki4RPBQD8l3Xp7yQNN0XG9bXvN66a7Ks06v9E9iTCE3o8sS6PC5jam8T8Wl0r >									
270 	//        <  u =="0.000000000000000001" : ] 000000479287503.513851000000000000 ; 000000497976882.719101000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000002DB55AE2F7DA38 >									
272 	//     < RUSS_PFXIV_II_metadata_line_25_____NORNICKEL_INT_HOLDINS_CANADA_20231101 >									
273 	//        < A28FL8Sd0rym81MkeBaSOG0Kz69AlGAxc53R1q40Ae2E47bo6u4NFmM12rToWeb9 >									
274 	//        <  u =="0.000000000000000001" : ] 000000497976882.719101000000000000 ; 000000514655660.286860000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002F7DA383114D5E >									
276 	//     < RUSS_PFXIV_II_metadata_line_26_____INTERGEOPROYEKT_LLC_20231101 >									
277 	//        < 2g63Cv6r6K3BSKLBnYSN4IxGPrj3IUX9QqE98vse4KbMgtngHuyzi9yH0Y2rJ8hs >									
278 	//        <  u =="0.000000000000000001" : ] 000000514655660.286860000000000000 ; 000000532284738.582108000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000003114D5E32C33BA >									
280 	//     < RUSS_PFXIV_II_metadata_line_27_____WESTERN_MINERALS_TECHNOLOGY_20231101 >									
281 	//        < n6Bab2p8dkwXgYg31or4cMKmkBBLGH2y2Ne74aFq4j6CL3I0IND6J7597UMqk8Y7 >									
282 	//        <  u =="0.000000000000000001" : ] 000000532284738.582108000000000000 ; 000000551111516.618316000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000032C33BA348EDF0 >									
284 	//     < RUSS_PFXIV_II_metadata_line_28_____NORMETIMPEX_20231101 >									
285 	//        < Pf8ZP0e770W7qXFAw7U9WK155M915707UYnJE2oE5j0ejvVR0fV6FK11t4H6PP2x >									
286 	//        <  u =="0.000000000000000001" : ] 000000551111516.618316000000000000 ; 000000575608422.996390000000000000 ] >									
287 	//        < 0x00000000000000000000000000000000000000000000000000348EDF036E4F0A >									
288 	//     < RUSS_PFXIV_II_metadata_line_29_____RAO_NORNICKEL_20231101 >									
289 	//        < 9c1U4A1s4hJ1asMIid5JIx4690z1hZ5HRRqZB0WYE9862Z3SiVDJbAQys0sjLFv7 >									
290 	//        <  u =="0.000000000000000001" : ] 000000575608422.996390000000000000 ; 000000595878641.493135000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000036E4F0A38D3D18 >									
292 	//     < RUSS_PFXIV_II_metadata_line_30_____ZAPOLYARNAYA_STROITELNAYA_KOMPANIYA_20231101 >									
293 	//        < Pp5PC07ZncJWd6izdS3gH2ekU926GUc0RNnPuuPAl4BTVxmDrP9LdzLWFdpc53P0 >									
294 	//        <  u =="0.000000000000000001" : ] 000000595878641.493135000000000000 ; 000000615708850.365732000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000038D3D183AB7F45 >									
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
338 	//     < RUSS_PFXIV_II_metadata_line_31_____NORNICKEL_PROCESSING_TECH_20231101 >									
339 	//        < sfy3454POypvZf7Ctt8feP1DE6msHBN2Tnmf47ECisYklrQ5hL4pYQb0DBfdf424 >									
340 	//        <  u =="0.000000000000000001" : ] 000000615708850.365732000000000000 ; 000000635017208.584079000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000003AB7F453C8F599 >									
342 	//     < RUSS_PFXIV_II_metadata_line_32_____NORNICKEL_KTK_20231101 >									
343 	//        < 2xi7ZD39G6t42277ywvNsb3gBN6IsGs54hi32W2cFDP9Fn5F59jEUNo92OuBhtqW >									
344 	//        <  u =="0.000000000000000001" : ] 000000635017208.584079000000000000 ; 000000652676485.964560000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000003C8F5993E3E7C1 >									
346 	//     < RUSS_PFXIV_II_metadata_line_33_____NORILSKYI_OBESPECHIVAUSHYI_COMPLEX_20231101 >									
347 	//        < 0Uo4Pv6q15c7jM1YGIJI4mknA6x97wAJD7aTm6F30h203z9Q55ZCEyp04QDvTe7o >									
348 	//        <  u =="0.000000000000000001" : ] 000000652676485.964560000000000000 ; 000000670787259.130409000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000003E3E7C13FF8A46 >									
350 	//     < RUSS_PFXIV_II_metadata_line_34_____GRK_BYSTRINSKOYE_20231101 >									
351 	//        < rvZnVd73lf3XR85Iu11n24j1F9wr09236yrhlzYA0UCiDfW3j43nw308LV2VQqhc >									
352 	//        <  u =="0.000000000000000001" : ] 000000670787259.130409000000000000 ; 000000686352635.314784000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000003FF8A464174A80 >									
354 	//     < RUSS_PFXIV_II_metadata_line_35_____NORILSKIY_KOMBINAT_20231101 >									
355 	//        < 293cUrj44J97oE59KbBd4A35042cHOD42HRs74TKR6AzON9u4ZGin1Il5IeYtQ29 >									
356 	//        <  u =="0.000000000000000001" : ] 000000686352635.314784000000000000 ; 000000701841387.125964000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000004174A8042EECCB >									
358 	//     < RUSS_PFXIV_II_metadata_line_36_____HARJAVALTA_OY_20231101 >									
359 	//        < CuWPCjFTjoUbL15rxq57A0C0pAVpO814hfT5V6F46zzNUd58G790t9vkt7iZHzXd >									
360 	//        <  u =="0.000000000000000001" : ] 000000701841387.125964000000000000 ; 000000720058609.500941000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000042EECCB44AB8E5 >									
362 	//     < RUSS_PFXIV_II_metadata_line_37_____ZAPOLYARNYI_TORGOVYI_ALIANS_20231101 >									
363 	//        < 15u6Ajc6RDzSpfsX9l5M754Jar39TBn0xWp52TH58moCL458qDj76F24wNoXhsqV >									
364 	//        <  u =="0.000000000000000001" : ] 000000720058609.500941000000000000 ; 000000735729946.216526000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000044AB8E5462A283 >									
366 	//     < RUSS_PFXIV_II_metadata_line_38_____AVALON_20231101 >									
367 	//        < Tw1y2CMkfuaev15LZuwH1sWk0KilPe7a56gV0P3L7Zi1wS8702gdiqqxF7CDpDYM >									
368 	//        <  u =="0.000000000000000001" : ] 000000735729946.216526000000000000 ; 000000756087375.536758000000000000 ] >									
369 	//        < 0x00000000000000000000000000000000000000000000000000462A283481B2A2 >									
370 	//     < RUSS_PFXIV_II_metadata_line_39_____GUSINOOZERSKAYA_20231101 >									
371 	//        < u7W7P81mLqwy2O8pnTyF760C9r5m7qG216hkhsXQqNV7l21DnXuMiaiF7ZCT3u3j >									
372 	//        <  u =="0.000000000000000001" : ] 000000756087375.536758000000000000 ; 000000773446333.332972000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000481B2A249C2F79 >									
374 	//     < RUSS_PFXIV_II_metadata_line_40_____NORNICKEL_PSMK_OOO_20231101 >									
375 	//        < hiu1533HbIu3zS47us3HgP1636cN73ghy7iAsnmun21izo1OBV26NMzLV2a9JwE1 >									
376 	//        <  u =="0.000000000000000001" : ] 000000773446333.332972000000000000 ; 000000795614035.169367000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000049C2F794BE02BC >									
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