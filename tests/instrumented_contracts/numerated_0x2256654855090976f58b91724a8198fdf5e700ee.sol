1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	BANK_II_PFI_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	BANK_II_PFI_883		"	;
8 		string	public		symbol =	"	BANK_II_PFI_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		415792691735944000000000000					;	
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
92 	//     < BANK_II_PFI_metadata_line_1_____GEBR_ALEXANDER_20220508 >									
93 	//        < ipVAO17P0a7e1th97bqNx25kN44hA4nFH7dN3j73vCFLf7EC92v5ED4HLq2oYrw7 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000010407972.526265000000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000000FE19D >									
96 	//     < BANK_II_PFI_metadata_line_2_____SCHOTT _GLASWERKE_AG_20220508 >									
97 	//        < 3dSy72Fti2auk1p23Zl3238IpGvuE0xP3E35s3H4kktJMcVk6nAr4d7HfpX9d71E >									
98 	//        <  u =="0.000000000000000001" : ] 000000010407972.526265000000000000 ; 000000020725349.350659400000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000000FE19D1F9FD7 >									
100 	//     < BANK_II_PFI_metadata_line_3_____MAINZ_HAUPTBAHNHOF_20220508 >									
101 	//        < R22952Gj367hAq8As7Rc45KK6g085Q2G1q75UFwIOT557hjqQlXWWR1d022QASRV >									
102 	//        <  u =="0.000000000000000001" : ] 000000020725349.350659400000000000 ; 000000031059468.567502600000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000001F9FD72F649B >									
104 	//     < BANK_II_PFI_metadata_line_4_____PORT_DOUANIER_ET_FLUVIAL_DE_MAYENCE_20220508 >									
105 	//        < 34z9o2b8t6O7joVced05R8PRlp126OA5w6blqhLcgE2nG5zbxknVL2FC36Fw9d9c >									
106 	//        <  u =="0.000000000000000001" : ] 000000031059468.567502600000000000 ; 000000041362099.400984000000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000002F649B3F1D12 >									
108 	//     < BANK_II_PFI_metadata_line_5_____WERNER_MERTZ_20220508 >									
109 	//        < 30Pw5iFLs7Mt39751Q33L39608C59dz0n7FJl4ry22U7qa90yLajMjZq726PjNd1 >									
110 	//        <  u =="0.000000000000000001" : ] 000000041362099.400984000000000000 ; 000000051687566.265063500000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000003F1D124EDE75 >									
112 	//     < BANK_II_PFI_metadata_line_6_____JF_HILLEBRAND_20220508 >									
113 	//        < c3942bYY3jVqE7gHh3KGB66oa3hJLz70HB185run41Zev2czz15n879ZHY30pWho >									
114 	//        <  u =="0.000000000000000001" : ] 000000051687566.265063500000000000 ; 000000061999649.656468600000000000 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000000000004EDE755E9A9D >									
116 	//     < BANK_II_PFI_metadata_line_7_____TRANS_OCEAN_20220508 >									
117 	//        < 6MxF1CWpql5FmmLL1AF80RK7IBl36iac9BuYvMnC9o6wtRDt06tRk0IxZBTrZ1J6 >									
118 	//        <  u =="0.000000000000000001" : ] 000000061999649.656468600000000000 ; 000000072431399.471723600000000000 ] >									
119 	//        < 0x00000000000000000000000000000000000000000000000000005E9A9D6E8584 >									
120 	//     < BANK_II_PFI_metadata_line_8_____SATELLITE_LOGISTICS_GROUP_20220508 >									
121 	//        < StXF0GHb74M3N0ezW9tTf969XwUIG0rcGS1lYKL6TR8TC343ZKazMYc3X6kkbENl >									
122 	//        <  u =="0.000000000000000001" : ] 000000072431399.471723600000000000 ; 000000082888560.288605800000000000 ] >									
123 	//        < 0x00000000000000000000000000000000000000000000000000006E85847E7A58 >									
124 	//     < BANK_II_PFI_metadata_line_9_____JF_HILLEBRAND_GROUP_20220508 >									
125 	//        < 5w1Av3Bw5hQqb7RimWHVdE5sQia38IWOTsk0pqlVdAcX6Pgpk9lBSG21KL8P0N1c >									
126 	//        <  u =="0.000000000000000001" : ] 000000082888560.288605800000000000 ; 000000093386410.009882900000000000 ] >									
127 	//        < 0x00000000000000000000000000000000000000000000000000007E7A588E7F11 >									
128 	//     < BANK_II_PFI_metadata_line_10_____ARCHER_DANIELS_MIDLAND_20220508 >									
129 	//        < DzvthAc81P3zgg6i9y7g1NrFNK3uJwUVVJ8qg4C2VLsk1SHPVKs4x6f88t69YLEq >									
130 	//        <  u =="0.000000000000000001" : ] 000000093386410.009882900000000000 ; 000000103722709.017709000000000000 ] >									
131 	//        < 0x00000000000000000000000000000000000000000000000000008E7F119E44AF >									
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
174 	//     < BANK_II_PFI_metadata_line_11_____WEPA_20220508 >									
175 	//        < wpfsvkXx2m6uheuxA4K8j06xWae58h6l5JCMoHt4qMI5jG9WnE89wZ0K85gFxGkj >									
176 	//        <  u =="0.000000000000000001" : ] 000000103722709.017709000000000000 ; 000000114241965.883723000000000000 ] >									
177 	//        < 0x00000000000000000000000000000000000000000000000000009E44AFAE51C5 >									
178 	//     < BANK_II_PFI_metadata_line_12_____IBM_CORP_20220508 >									
179 	//        < EsKpo728iLNTquo5CH05si0x848ASoFNn1U2q1rQTB0arwkUty8Jfl2V9c7G2nl0 >									
180 	//        <  u =="0.000000000000000001" : ] 000000114241965.883723000000000000 ; 000000124717846.164978000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000000AE51C5BE4DE9 >									
182 	//     < BANK_II_PFI_metadata_line_13_____NOVO_NORDISK_20220508 >									
183 	//        < TkLWCg2C1YL0o7hEs8H4VcYbfo515X9Ly08iSPls2Fu6vZ0j0aIwSE36vDOy5693 >									
184 	//        <  u =="0.000000000000000001" : ] 000000124717846.164978000000000000 ; 000000135097658.070066000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000000BE4DE9CE2486 >									
186 	//     < BANK_II_PFI_metadata_line_14_____COFACE_20220508 >									
187 	//        < x7bER2SHUcpk0NedL0rdaFMZBQ5C32b1u99924orWVA5T9zxzVgfcKAJj2VBkb3Z >									
188 	//        <  u =="0.000000000000000001" : ] 000000135097658.070066000000000000 ; 000000145405683.185118000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000000CE2486DDDF18 >									
190 	//     < BANK_II_PFI_metadata_line_15_____MOGUNTIA_20220508 >									
191 	//        < w9U87Uv1P33ZPPpjwQx04pK9i5qMBBz59vhZMuW259D3IOKX7EIoeoa8J7T8Cf3G >									
192 	//        <  u =="0.000000000000000001" : ] 000000145405683.185118000000000000 ; 000000155827052.929271000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000000DDDF18EDC5F1 >									
194 	//     < BANK_II_PFI_metadata_line_16_____DITSCH_20220508 >									
195 	//        < k60O9ig9lU7Q25679di8W1AwJ7rwb17UgMuJlh055v7j29o8TmE3pI491y7XEVde >									
196 	//        <  u =="0.000000000000000001" : ] 000000155827052.929271000000000000 ; 000000166148915.765816000000000000 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000000000EDC5F1FD85EC >									
198 	//     < BANK_II_PFI_metadata_line_17_____GRANDS_CHAIS_DE_FRANCE_20220508 >									
199 	//        < jT9gGl9M6z1H1l20f330HzX4O4AlqNVB8p93BN20R29We6Y1Ohg0T4eDlTY3tVmb >									
200 	//        <  u =="0.000000000000000001" : ] 000000166148915.765816000000000000 ; 000000176521818.579602000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000000FD85EC10D59D6 >									
202 	//     < BANK_II_PFI_metadata_line_18_____Zweites Deutsches Fernsehen_ZDF_20220508 >									
203 	//        < L7CGmJupWPCplz2ZUTn4jGpilaguV30UX2eCX2rS0ISh8ZORXGv4l911j4xSjnbN >									
204 	//        <  u =="0.000000000000000001" : ] 000000176521818.579602000000000000 ; 000000186845583.377680000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000010D59D611D1A8E >									
206 	//     < BANK_II_PFI_metadata_line_19_____3SAT_20220508 >									
207 	//        < 4v20BY8Qe2JJG05QMRrCr5Q5eRs5r9n2540yV2KYoFHB8nH8tXy5Dkiz3J1m3ErU >									
208 	//        <  u =="0.000000000000000001" : ] 000000186845583.377680000000000000 ; 000000197202517.552662000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000000011D1A8E12CE83C >									
210 	//     < BANK_II_PFI_metadata_line_20_____Südwestrundfunk_SWR_20220508 >									
211 	//        < J14857N8s22hk2mc2JyYj3394TqB6cKE4b39mzRhCaYkz2u892X8rg2n7PedRBMa >									
212 	//        <  u =="0.000000000000000001" : ] 000000197202517.552662000000000000 ; 000000207527714.415035000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000012CE83C13CA983 >									
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
256 	//     < BANK_II_PFI_metadata_line_21_____SCHOTT_MUSIC_20220508 >									
257 	//        < PSAYDWa2ohBDntS4w1eYHKV6nI76sM3a0tlbJ459wU36MnVYgpBLlHp91P2w0oY9 >									
258 	//        <  u =="0.000000000000000001" : ] 000000207527714.415035000000000000 ; 000000218062422.645870000000000000 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000000013CA98314CBCA2 >									
260 	//     < BANK_II_PFI_metadata_line_22_____Verlagsgruppe Rhein Main_20220508 >									
261 	//        < gc0J5PimDMu4nnvu62k38HLI1g6sL4L68TywjAS2CM4p2u0iN07zkMjT6V8iV6ot >									
262 	//        <  u =="0.000000000000000001" : ] 000000218062422.645870000000000000 ; 000000228594774.832748000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000014CBCA215CCED5 >									
264 	//     < BANK_II_PFI_metadata_line_23_____Philipp von Zabern_20220508 >									
265 	//        < E5kFeQ3q1ir09y9MTQ6F6324ovI3IYbxM2xu0VaZWR69y21D4rTdM1U0s7pzpiWw >									
266 	//        <  u =="0.000000000000000001" : ] 000000228594774.832748000000000000 ; 000000239022686.149482000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000015CCED516CB83D >									
268 	//     < BANK_II_PFI_metadata_line_24_____De Dietrich Process Systems_GMBH_20220508 >									
269 	//        < KlN25vUlDg3LokFau68QFNVHQc06K68c02xD52vsi51I9JjlI3o4DZbRy6Y1rvuI >									
270 	//        <  u =="0.000000000000000001" : ] 000000239022686.149482000000000000 ; 000000249404636.896836000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000016CB83D17C8FB0 >									
272 	//     < BANK_II_PFI_metadata_line_25_____FIRST_SOLAR_GMBH_20220508 >									
273 	//        < 6uOX0fgc3OyVEefCDT5RG623M67GI1isKky9Dm7M6HOYmr9V6LbfF9UonCKi0FJL >									
274 	//        <  u =="0.000000000000000001" : ] 000000249404636.896836000000000000 ; 000000259930773.621864000000000000 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000000000017C8FB018C9F75 >									
276 	//     < BANK_II_PFI_metadata_line_26_____BIONTECH_SE_20220508 >									
277 	//        < Gn7G322O6j1n3thEDC8C3DkAO31y7g0lPybxS9Zk5ZZ3dwzbB1f3543VQO8bz39u >									
278 	//        <  u =="0.000000000000000001" : ] 000000259930773.621864000000000000 ; 000000270233269.806036000000000000 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000000000018C9F7519C57DF >									
280 	//     < BANK_II_PFI_metadata_line_27_____UNI_MAINZ_20220508 >									
281 	//        < Ug4M5YeD7xl292KOquT45bJB2kNeU02jPj2y0x9RmqPG8dHF4YjT8KwlEGM2lhvv >									
282 	//        <  u =="0.000000000000000001" : ] 000000270233269.806036000000000000 ; 000000280640831.325704000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000019C57DF1AC3953 >									
284 	//     < BANK_II_PFI_metadata_line_28_____Mainz Institute of Microtechnology_20220508 >									
285 	//        < 1dMJD4Ths87Jc6GW70WDa99tbOj38uyB27V6AyOCge6Rja0tLjCm8b5v84d1RhZR >									
286 	//        <  u =="0.000000000000000001" : ] 000000280640831.325704000000000000 ; 000000291057454.137153000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000001AC39531BC1E51 >									
288 	//     < BANK_II_PFI_metadata_line_29_____Matthias_Grünewald_Verlag_20220508 >									
289 	//        < N6beju0ss6oS5XzcTI3AXEah5yDcd5v9D2B6iAyQ8L5TVx145uE33191tRs4Ib89 >									
290 	//        <  u =="0.000000000000000001" : ] 000000291057454.137153000000000000 ; 000000301471097.748568000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000001BC1E511CC0226 >									
292 	//     < BANK_II_PFI_metadata_line_30_____PEDIA_PRESS_20220508 >									
293 	//        < OCC1a06yVO1joVUYKk4ZVi7O8s2kRO7F5T2GZueR784XijebXLeNaCM51i9S7R4u >									
294 	//        <  u =="0.000000000000000001" : ] 000000301471097.748568000000000000 ; 000000311893402.187990000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000001CC02261DBE95C >									
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
338 	//     < BANK_II_PFI_metadata_line_31_____Boehringer Ingelheim_20220508 >									
339 	//        < jdbTVv5Bf9qaufbhdiS6t7077Xw36xbRU58f667mjnIONxH9T11Gbiwa2dJ4H5BC >									
340 	//        <  u =="0.000000000000000001" : ] 000000311893402.187990000000000000 ; 000000322243358.539921000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000001DBE95C1EBB450 >									
342 	//     < BANK_II_PFI_metadata_line_32_____MIDAS_PHARMA_20220508 >									
343 	//        < 7w6RUf7I7wK6pQkolw5VDyIu550Gk4877aldIz4yQv15QTvUb1qDX53774K50mbP >									
344 	//        <  u =="0.000000000000000001" : ] 000000322243358.539921000000000000 ; 000000332730627.687958000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000001EBB4501FBB4E7 >									
346 	//     < BANK_II_PFI_metadata_line_33_____MIDAS_PHARMA_POLSKA_20220508 >									
347 	//        < I8SU59o25i063D5rjt6t60SE9a3eXtK1F07FhFn82kMJv7WQpS88RP5oRZDwGt0J >									
348 	//        <  u =="0.000000000000000001" : ] 000000332730627.687958000000000000 ; 000000343232187.993512000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000001FBB4E720BBB13 >									
350 	//     < BANK_II_PFI_metadata_line_34_____CMS_PHARMA_20220508 >									
351 	//        < B05dQJZ3ygW3iR34F23pU2v0143OsR10gE9c9ZFh8w69W1xcIJ483mBcTV495POg >									
352 	//        <  u =="0.000000000000000001" : ] 000000343232187.993512000000000000 ; 000000353750798.833825000000000000 ] >									
353 	//        < 0x0000000000000000000000000000000000000000000000000020BBB1321BC7E8 >									
354 	//     < BANK_II_PFI_metadata_line_35_____CAIGOS_GMBH_20220508 >									
355 	//        < 7ZGeqM1NuKT2Gt04jstMUniTLCd0waMoL2LXb2oH910e6h9c8S7gyt1Y3BCE51At >									
356 	//        <  u =="0.000000000000000001" : ] 000000353750798.833825000000000000 ; 000000364027216.621906000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000021BC7E822B7622 >									
358 	//     < BANK_II_PFI_metadata_line_36_____Altes E_Werk der Rheinhessische Energie_und Wasserversorgungs_GmbH_20220508 >									
359 	//        < 9A1y5of342lLV8J48fAs2RJKRB5ws8D7luJ87g3M0jnc49DwbaF63iDeV57VY9r8 >									
360 	//        <  u =="0.000000000000000001" : ] 000000364027216.621906000000000000 ; 000000374324499.413902000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000022B762223B2C82 >									
362 	//     < BANK_II_PFI_metadata_line_37_____THUEGA_AG_20220508 >									
363 	//        < MtqDEoM1g20rZbbPmoJ4Xnx2h0373g3YZ9A6W5mTqo063Sb2PJbEGxLX8agrs3n6 >									
364 	//        <  u =="0.000000000000000001" : ] 000000374324499.413902000000000000 ; 000000384845098.993350000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000023B2C8224B3A1E >									
366 	//     < BANK_II_PFI_metadata_line_38_____Verbandsgemeinde Heidesheim am Rhein_20220508 >									
367 	//        < LEt74hJw4zpZ8WZO62f1z2T84RrlX0bxj9r575QG93C42NlPOBcgBNVXqZ3J10aF >									
368 	//        <  u =="0.000000000000000001" : ] 000000384845098.993350000000000000 ; 000000395177770.603374000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000024B3A1E25AFE51 >									
370 	//     < BANK_II_PFI_metadata_line_39_____Stadtwerke Ingelheim_AB_20220508 >									
371 	//        < w62iyw3MXLPf1buZb7AB856f1H1BPfuWjRT1Nse2aNwdt3dK8941lZExwE3ehFUf >									
372 	//        <  u =="0.000000000000000001" : ] 000000395177770.603374000000000000 ; 000000405455590.409371000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000025AFE5126AAD17 >									
374 	//     < BANK_II_PFI_metadata_line_40_____rhenag Rheinische Energie AG_KOELN_20220508 >									
375 	//        < 18KK08ixoZOhDJF0N9SYJNtt67bcYS14QUU8994SKImQTlR67hNW34bwIxL91LPT >									
376 	//        <  u =="0.000000000000000001" : ] 000000405455590.409371000000000000 ; 000000415792691.735944000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000026AAD1727A7305 >									
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