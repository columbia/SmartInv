1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXXXIII_II_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXXXIII_II_883		"	;
8 		string	public		symbol =	"	RUSS_PFXXXIII_II_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		850141716087447000000000000					;	
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
92 	//     < RUSS_PFXXXIII_II_metadata_line_1_____PIK_GROUP_20231101 >									
93 	//        < AJS9Ht7YSuMdpu470ML42tb941FQCzchYFr9t311WB64qs6CuiTQfSVy5h6Wdi0H >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000024031304.835845900000000000 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000000024AB3A >									
96 	//     < RUSS_PFXXXIII_II_metadata_line_2_____PIK_INDUSTRIYA_20231101 >									
97 	//        < 4I3PwR4QRjAA93kmf4Tyf6B622TN7sQYw374swgD6c61nMZRibkN83YU5o69IW50 >									
98 	//        <  u =="0.000000000000000001" : ] 000000024031304.835845900000000000 ; 000000047761914.895965300000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000024AB3A48E0FF >									
100 	//     < RUSS_PFXXXIII_II_metadata_line_3_____STROYINVEST_20231101 >									
101 	//        < Nu7Z15DU57SLsV85H03eH1FvCX5oEjc9if7G140at9NMQAQprlEirBQ4TA6x4QhE >									
102 	//        <  u =="0.000000000000000001" : ] 000000047761914.895965300000000000 ; 000000072057302.575564500000000000 ] >									
103 	//        < 0x000000000000000000000000000000000000000000000000000048E0FF6DF362 >									
104 	//     < RUSS_PFXXXIII_II_metadata_line_4_____PIK_TECHNOLOGY_20231101 >									
105 	//        < Am4lkhRvj60y06p0nmi6DHQ2V8e8TJ42Y0907eULFZCVCeiTBik5HN3ylU7bR875 >									
106 	//        <  u =="0.000000000000000001" : ] 000000072057302.575564500000000000 ; 000000094052198.333697100000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000006DF3628F8324 >									
108 	//     < RUSS_PFXXXIII_II_metadata_line_5_____PIK_REGION_20231101 >									
109 	//        < B0S00RE21OY30k0nm80nNpv1n095TGGcWUY5hK1N1iXkG2p05Y1Xz4s9IA3JKg5m >									
110 	//        <  u =="0.000000000000000001" : ] 000000094052198.333697100000000000 ; 000000113793642.515855000000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000008F8324ADA2A4 >									
112 	//     < RUSS_PFXXXIII_II_metadata_line_6_____PIK_NERUD_OOO_20231101 >									
113 	//        < 67KX8Pdf49SEBJ5w77d2RZQOQ63W23i2ky0Cnw96dc3NNT15eP73LPl60i0J9Npp >									
114 	//        <  u =="0.000000000000000001" : ] 000000113793642.515855000000000000 ; 000000137911004.151375000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000ADA2A4D26F7C >									
116 	//     < RUSS_PFXXXIII_II_metadata_line_7_____PIK_MFS_OOO_20231101 >									
117 	//        < S8U12depbCrxHq2w5O5YHilxXfz828ZgU5MT35fbtALtBbqNWfG83225hd5s8EeJ >									
118 	//        <  u =="0.000000000000000001" : ] 000000137911004.151375000000000000 ; 000000155965717.835746000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000D26F7CEDFC1C >									
120 	//     < RUSS_PFXXXIII_II_metadata_line_8_____PIK_COMFORT_20231101 >									
121 	//        < 18Av61zH9wZp3j06444p91P25je53Wvgi5Wm3BPA9gQVEn466VXmpbaxvj9rb2p7 >									
122 	//        <  u =="0.000000000000000001" : ] 000000155965717.835746000000000000 ; 000000177721265.656182000000000000 ] >									
123 	//        < 0x000000000000000000000000000000000000000000000000000EDFC1C10F2E5F >									
124 	//     < RUSS_PFXXXIII_II_metadata_line_9_____TRADING_HOUSE_OSNOVA_20231101 >									
125 	//        < y8OQYF5uzX6LLJlOl9hhtxqC0MopWk34LY640eHMPO4e1Je4K4jZgqW06quH910O >									
126 	//        <  u =="0.000000000000000001" : ] 000000177721265.656182000000000000 ; 000000196867824.472999000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000010F2E5F12C657E >									
128 	//     < RUSS_PFXXXIII_II_metadata_line_10_____KHROMTSOVSKY_KARIER_20231101 >									
129 	//        < ADXSa1r88Adcr2V4cGf9MZq3mafBldN8139QeCen19LXk6qIuOUnY2U21sY2D60T >									
130 	//        <  u =="0.000000000000000001" : ] 000000196867824.472999000000000000 ; 000000219992524.855608000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000012C657E14FAE94 >									
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
174 	//     < RUSS_PFXXXIII_II_metadata_line_11_____480_KZHI_20231101 >									
175 	//        < hdD04Aj47Z1ZZz4rTfjx7Q0S5R0CAZcOt8hHc9Zm75r19cm58q45p07BDNEjIx6v >									
176 	//        <  u =="0.000000000000000001" : ] 000000219992524.855608000000000000 ; 000000239667401.148768000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000014FAE9416DB414 >									
178 	//     < RUSS_PFXXXIII_II_metadata_line_12_____PIK_YUG_OOO_20231101 >									
179 	//        < 0hMT2sG3sudI7IVq385zyuSwg2VO5XDsJ9Ymra5QM5U1L17482zl6oj38ZD59W7Z >									
180 	//        <  u =="0.000000000000000001" : ] 000000239667401.148768000000000000 ; 000000261663988.728656000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000016DB41418F447F >									
182 	//     < RUSS_PFXXXIII_II_metadata_line_13_____YUGOOO_ORG_20231101 >									
183 	//        < jDxq7bwUec6XCBM529NFtyvXrb2hhfs6PdB352A1T550SRmKRRZC0iV266QijTLw >									
184 	//        <  u =="0.000000000000000001" : ] 000000261663988.728656000000000000 ; 000000283424675.195652000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000018F447F1B078C4 >									
186 	//     < RUSS_PFXXXIII_II_metadata_line_14_____KRASNAYA_PRESNYA_SUGAR_REFINERY_20231101 >									
187 	//        < qyoa5p90SRHlP2r2P567Fv50U0rM76SpR5L4i2KTw1NJ8kXFQhTN5O73ksFuiAkt >									
188 	//        <  u =="0.000000000000000001" : ] 000000283424675.195652000000000000 ; 000000300749956.185414000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000001B078C41CAE874 >									
190 	//     < RUSS_PFXXXIII_II_metadata_line_15_____NOVOROSGRAGDANPROEKT_20231101 >									
191 	//        < g3b5F45363GN308De58rx7187K26awXQo82n5mW7vuO3LsxwR36j3khDd1aS36B3 >									
192 	//        <  u =="0.000000000000000001" : ] 000000300749956.185414000000000000 ; 000000320833355.709948000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000001CAE8741E98D88 >									
194 	//     < RUSS_PFXXXIII_II_metadata_line_16_____STATUS_LAND_OOO_20231101 >									
195 	//        < n136TW9vY4KJBJyv2Ti3cI2l0fCmjC8XrbZ2r2QEQDrUVb8yV8D065Qgd58yod98 >									
196 	//        <  u =="0.000000000000000001" : ] 000000320833355.709948000000000000 ; 000000343960734.292808000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000001E98D8820CD7A9 >									
198 	//     < RUSS_PFXXXIII_II_metadata_line_17_____PIK_PODYOM_20231101 >									
199 	//        < opDhC1ogX2bjDv0ud430lHqiOPAMUwidqmvMU8c3ps980287600odK232OCna1ZY >									
200 	//        <  u =="0.000000000000000001" : ] 000000343960734.292808000000000000 ; 000000367928925.150128000000000000 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000000020CD7A92316A3D >									
202 	//     < RUSS_PFXXXIII_II_metadata_line_18_____PODYOM_ORG_20231101 >									
203 	//        < 8bfi91bqyTs1UvD5M65Tf6u4nJB7YF2d48oGy08BSTy267z14facr4384PDNgLC0 >									
204 	//        <  u =="0.000000000000000001" : ] 000000367928925.150128000000000000 ; 000000385137500.120647000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000002316A3D24BAC56 >									
206 	//     < RUSS_PFXXXIII_II_metadata_line_19_____PIK_COMFORT_OOO_20231101 >									
207 	//        < I1gDxN48af4KJDGr6SSln4pAv8gh1v3n24H1C5G3g02gTOaRE4CkRjXsAR91TgW5 >									
208 	//        <  u =="0.000000000000000001" : ] 000000385137500.120647000000000000 ; 000000402464572.409060000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000000024BAC562661CB9 >									
210 	//     < RUSS_PFXXXIII_II_metadata_line_20_____PIK_KUBAN_20231101 >									
211 	//        < JpQtRd4azBVE2HxF5gpSuThHNeNela9LcA4P247F3HYzJ4JdzGSe2Sjad4e7TRRy >									
212 	//        <  u =="0.000000000000000001" : ] 000000402464572.409060000000000000 ; 000000425183845.752503000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000002661CB9288C771 >									
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
256 	//     < RUSS_PFXXXIII_II_metadata_line_21_____KUBAN_ORG_20231101 >									
257 	//        < qaDBC4348g9GcGy37md1Y83kJZ3u6CI0rV4ffcAS4du4NUTwQ6M1FjyWXCz6t0Nb >									
258 	//        <  u =="0.000000000000000001" : ] 000000425183845.752503000000000000 ; 000000448713533.507244000000000000 ] >									
259 	//        < 0x00000000000000000000000000000000000000000000000000288C7712ACAEB9 >									
260 	//     < RUSS_PFXXXIII_II_metadata_line_22_____MORTON_OOO_20231101 >									
261 	//        < G3UCD8kR7af77x2FQ15jOrI267HmwoDVZe8Wf925nAPTny3J6Rpdq48k548iS2ni >									
262 	//        <  u =="0.000000000000000001" : ] 000000448713533.507244000000000000 ; 000000468175676.843743000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000002ACAEB92CA6120 >									
264 	//     < RUSS_PFXXXIII_II_metadata_line_23_____ZAO_PIK_REGION_20231101 >									
265 	//        < K0WGY8KTTlSER40cHT4P1M4Dq5Txz0M6AW6RBox14Z82bB0D9kSRsZVq03EHO4Cq >									
266 	//        <  u =="0.000000000000000001" : ] 000000468175676.843743000000000000 ; 000000490076324.229684000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000002CA61202EBCC10 >									
268 	//     < RUSS_PFXXXIII_II_metadata_line_24_____ZAO_MONETTSCHIK_20231101 >									
269 	//        < 3u6b8OQrVW863AydjJWM5z1JwNbZ2244Q4qH2AKThniw3AzlvD4H7oZOn8047W66 >									
270 	//        <  u =="0.000000000000000001" : ] 000000490076324.229684000000000000 ; 000000513397617.570006000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000002EBCC1030F61F2 >									
272 	//     < RUSS_PFXXXIII_II_metadata_line_25_____STROYFORMAT_OOO_20231101 >									
273 	//        < dyIYK4dFFVib9fZr01q6kiA1geN26256VLBwJJbS5Y2zxpFZ503p989L9nga8ATL >									
274 	//        <  u =="0.000000000000000001" : ] 000000513397617.570006000000000000 ; 000000530534239.298511000000000000 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000000000030F61F232987F0 >									
276 	//     < RUSS_PFXXXIII_II_metadata_line_26_____VOLGA_FORM_REINFORCED_CONCRETE_PLANT_20231101 >									
277 	//        < 0dk4Z0338q9jodknV6NWiYX97g1qiK4mme3gQ1gfE49epQL80cZ32wg994zqy4Jr >									
278 	//        <  u =="0.000000000000000001" : ] 000000530534239.298511000000000000 ; 000000549444391.760011000000000000 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000000000032987F034662B7 >									
280 	//     < RUSS_PFXXXIII_II_metadata_line_27_____ZARECHYE_SPORT_20231101 >									
281 	//        < c86C50ukQ39M47vShugavmLw8WRem4Wg8XqLQtb55H4FnQdgpqQpTGCM33p7F7uj >									
282 	//        <  u =="0.000000000000000001" : ] 000000549444391.760011000000000000 ; 000000568144565.062235000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000034662B7362EB79 >									
284 	//     < RUSS_PFXXXIII_II_metadata_line_28_____PIK_PROFILE_OOO_20231101 >									
285 	//        < 771aX8PY3ZR6mfQ9oQ91t96d5Nd6PZpykvdic3UyMxUYY4IVz6bn2Rq8dTBQDGB6 >									
286 	//        <  u =="0.000000000000000001" : ] 000000568144565.062235000000000000 ; 000000589106681.790431000000000000 ] >									
287 	//        < 0x00000000000000000000000000000000000000000000000000362EB79382E7CC >									
288 	//     < RUSS_PFXXXIII_II_metadata_line_29_____FENTROUMA_HOLDINGS_LIMITED_20231101 >									
289 	//        < Z7c2ED3UH38t7FnCKpUAYIlC7af2f16L8Pcd0z3Hle026MhRG3GfcxIV5c3VUi0M >									
290 	//        <  u =="0.000000000000000001" : ] 000000589106681.790431000000000000 ; 000000610714043.637257000000000000 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000000000382E7CC3A3E02C >									
292 	//     < RUSS_PFXXXIII_II_metadata_line_30_____PODMOKOVYE_20231101 >									
293 	//        < K81T9LQ608rfV2zGZUKn6k83p37niQdH1h4j6JCBJPU1IZBPgN38Ln281a9eqo33 >									
294 	//        <  u =="0.000000000000000001" : ] 000000610714043.637257000000000000 ; 000000627783467.337205000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000003A3E02C3BDEBEB >									
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
338 	//     < RUSS_PFXXXIII_II_metadata_line_31_____STROYINVESTREGION_20231101 >									
339 	//        < 17rt6X6z5E9FxZa6uRf1z8B35fEBD3EX6e4v0H6EtyhSZcD2TdFZZ0jwPOiN711j >									
340 	//        <  u =="0.000000000000000001" : ] 000000627783467.337205000000000000 ; 000000651465806.883615000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000003BDEBEB3E20ED5 >									
342 	//     < RUSS_PFXXXIII_II_metadata_line_32_____PIK_DEVELOPMENT_20231101 >									
343 	//        < 6ty1E4KuBdL9bPcvM9mp0p26I7xKNsAKEK7ejOXSdiL6c96qj6q8atic98AVo9Jn >									
344 	//        <  u =="0.000000000000000001" : ] 000000651465806.883615000000000000 ; 000000675683431.769070000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000003E20ED540702D7 >									
346 	//     < RUSS_PFXXXIII_II_metadata_line_33_____TAKSOMOTORNIY_PARK_20231101 >									
347 	//        < 30JpJw48Dbz2s2Y4ag8gY18oVaBfm8A05C4t9Fvvh04s080f9WG892uPkBwl1CYP >									
348 	//        <  u =="0.000000000000000001" : ] 000000675683431.769070000000000000 ; 000000698782477.424879000000000000 ] >									
349 	//        < 0x0000000000000000000000000000000000000000000000000040702D742A41E8 >									
350 	//     < RUSS_PFXXXIII_II_metadata_line_34_____KALTENBERG_LIMITED_20231101 >									
351 	//        < fIV97Ei0z04HUcu1T3tL7xhT5wV5eAMGIUTLBoyIQ6mSwZYIJLJqYySJtYzBz1W6 >									
352 	//        <  u =="0.000000000000000001" : ] 000000698782477.424879000000000000 ; 000000719047054.326598000000000000 ] >									
353 	//        < 0x0000000000000000000000000000000000000000000000000042A41E84492DC1 >									
354 	//     < RUSS_PFXXXIII_II_metadata_line_35_____MAYAK_OOO_20231101 >									
355 	//        < 897wIiQ5FvCIYYj1S6llG3g3VsYl6MYKb39gi5dVCwk70zNMww58m086P0T50qZU >									
356 	//        <  u =="0.000000000000000001" : ] 000000719047054.326598000000000000 ; 000000742085345.820161000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000004492DC146C5517 >									
358 	//     < RUSS_PFXXXIII_II_metadata_line_36_____MAYAK_ORG_20231101 >									
359 	//        < dlSf2OgPE6445d0brZHKfumtn61k7mye5n1D9rMC8AE50F47VzinkMYu90KKYZXw >									
360 	//        <  u =="0.000000000000000001" : ] 000000742085345.820161000000000000 ; 000000766456765.559561000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000046C5517491852D >									
362 	//     < RUSS_PFXXXIII_II_metadata_line_37_____UDSK_OOO_20231101 >									
363 	//        < vK4g3bN6Ql7FC2DuOv0szLaPQk87R2NNR6QoQz4Nn10AhfR7awV2aO10UgB6cV6I >									
364 	//        <  u =="0.000000000000000001" : ] 000000766456765.559561000000000000 ; 000000791080017.306021000000000000 ] >									
365 	//        < 0x00000000000000000000000000000000000000000000000000491852D4B717A2 >									
366 	//     < RUSS_PFXXXIII_II_metadata_line_38_____ROSTOVSKOYE_MORE_OOO_20231101 >									
367 	//        < 4gM4Wi9PlyWCnZ61P3Q305ekItPYUatx7P2n204Q64bzSb016K106ujXL8YkaU02 >									
368 	//        <  u =="0.000000000000000001" : ] 000000791080017.306021000000000000 ; 000000809490084.875371000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000004B717A24D32F10 >									
370 	//     < RUSS_PFXXXIII_II_metadata_line_39_____MONETCHIK_20231101 >									
371 	//        < oqhLYhJ8b4ba5sfvseuh32MxvU79Ce3B339wz9NyrbH86z3bBaID1yp8eJ12r4gQ >									
372 	//        <  u =="0.000000000000000001" : ] 000000809490084.875371000000000000 ; 000000826943684.961840000000000000 ] >									
373 	//        < 0x000000000000000000000000000000000000000000000000004D32F104EDD0E0 >									
374 	//     < RUSS_PFXXXIII_II_metadata_line_40_____KUSKOVSKOGO_ORDENA_ZNAK_POCHETA_CHEM_PLANT_20231101 >									
375 	//        < 9LRhw1A8Q4Lv0UHdo7h05i2J8WEInFP6fymDki0dsIm1n0qCjt5v32FQ34CN65Y7 >									
376 	//        <  u =="0.000000000000000001" : ] 000000826943684.961840000000000000 ; 000000850141716.087447000000000000 ] >									
377 	//        < 0x000000000000000000000000000000000000000000000000004EDD0E0511369C >									
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