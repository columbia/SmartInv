1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXXV_II_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXXV_II_883		"	;
8 		string	public		symbol =	"	RUSS_PFXXV_II_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		816564412560058000000000000					;	
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
92 	//     < RUSS_PFXXV_II_metadata_line_1_____GAZPROM_20231101 >									
93 	//        < x8DQGw7XWdEk7R4z9BfI70tq744WpKU0nSx5RLp0C460SpMCizq0n57Pa8sQzkWP >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000019012568.437366600000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000001D02C9 >									
96 	//     < RUSS_PFXXV_II_metadata_line_2_____PROM_DAO_20231101 >									
97 	//        < 563A6w31nLgaN4tRw0b86deI1gUlAq5r61JI6Thi93KJ51NfM143B756gW8ZD0lQ >									
98 	//        <  u =="0.000000000000000001" : ] 000000019012568.437366600000000000 ; 000000042336835.805236600000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000001D02C94099D4 >									
100 	//     < RUSS_PFXXV_II_metadata_line_3_____PROM_DAOPI_20231101 >									
101 	//        < Nb63Z4qm86o4WUNaxBb6Pv4elp91rgMKSz48mKDvz9NRu34Q4Cg74cg49DG3n920 >									
102 	//        <  u =="0.000000000000000001" : ] 000000042336835.805236600000000000 ; 000000066051867.073407900000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000004099D464C983 >									
104 	//     < RUSS_PFXXV_II_metadata_line_4_____PROM_DAC_20231101 >									
105 	//        < f5nvO9a292Enaqq5c0gCQTg6icljCp44u0WCl1R2D004V391p9y5RtaI8L9lIDVp >									
106 	//        <  u =="0.000000000000000001" : ] 000000066051867.073407900000000000 ; 000000089919556.016221300000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000064C9838934D4 >									
108 	//     < RUSS_PFXXV_II_metadata_line_5_____PROM_BIMI_20231101 >									
109 	//        < 180CmVHq8cjT53m82jJ7Jh2l8COlzOM8JKDm9Q5v47JRf3A4uNrEI6IIA7C1wqJM >									
110 	//        <  u =="0.000000000000000001" : ] 000000089919556.016221300000000000 ; 000000113096910.545363000000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000008934D4AC927B >									
112 	//     < RUSS_PFXXV_II_metadata_line_6_____GAZPROMNEFT_20231101 >									
113 	//        < 4zir17M9153cewsa258VsGM7wlsVpHgXEZsK92h1oZk1aNcAhv4p0vQ8h30jZ1i2 >									
114 	//        <  u =="0.000000000000000001" : ] 000000113096910.545363000000000000 ; 000000130364166.384828000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000AC927BC6EB81 >									
116 	//     < RUSS_PFXXV_II_metadata_line_7_____GAZPROMBANK_BD_20231101 >									
117 	//        < 27Dj9mP9UIQmjSdH6vFp101TY71LjVe8q580w93x3oV835mZ0uImsXGsu6uijNyw >									
118 	//        <  u =="0.000000000000000001" : ] 000000130364166.384828000000000000 ; 000000153726312.420151000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000C6EB81EA9157 >									
120 	//     < RUSS_PFXXV_II_metadata_line_8_____MEZHEREGIONGAZ_20231101 >									
121 	//        < 62OYHg3Y3ZebEhqKbH3PS8vN21rij4V5BhlC8t0O7g43J47hr3U4zmXY3Fn821uv >									
122 	//        <  u =="0.000000000000000001" : ] 000000153726312.420151000000000000 ; 000000176922018.517804000000000000 ] >									
123 	//        < 0x000000000000000000000000000000000000000000000000000EA915710DF62A >									
124 	//     < RUSS_PFXXV_II_metadata_line_9_____SALAVATNEFTEORGSINTEZ_20231101 >									
125 	//        < X8c9XmYCq6LqVNTlxcufODpCHH94w95Nl0FQ552yY3rXjKu97xGC5LY1Gf7810v5 >									
126 	//        <  u =="0.000000000000000001" : ] 000000176922018.517804000000000000 ; 000000199972462.893281000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000010DF62A131223E >									
128 	//     < RUSS_PFXXV_II_metadata_line_10_____SAKHALIN_ENERGY_20231101 >									
129 	//        < 1pvSbb9M52R7k5ePRZJ4YB60v9O1m7KocEZL900qqRoMOryW3acwf18dzO4w2Sh8 >									
130 	//        <  u =="0.000000000000000001" : ] 000000199972462.893281000000000000 ; 000000219553077.640998000000000000 ] >									
131 	//        < 0x00000000000000000000000000000000000000000000000000131223E14F02EC >									
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
174 	//     < RUSS_PFXXV_II_metadata_line_11_____NORDSTREAM_AG_20231101 >									
175 	//        < 09vEh1Q7e42P4o2EzDorQKfYzbr2egdIVd5Mt0WL9WuepCTU1o44TxxjY5EjW70J >									
176 	//        <  u =="0.000000000000000001" : ] 000000219553077.640998000000000000 ; 000000242779917.516117000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000014F02EC17273E8 >									
178 	//     < RUSS_PFXXV_II_metadata_line_12_____NORDSTREAM_DAO_20231101 >									
179 	//        < vT23x16VvNa1evion6wU7d2FJYF1kNpHbWR6c3VIXKw5H2q4gEhsuhzYJ948E5BS >									
180 	//        <  u =="0.000000000000000001" : ] 000000242779917.516117000000000000 ; 000000259499970.309359000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000017273E818BF72D >									
182 	//     < RUSS_PFXXV_II_metadata_line_13_____NORDSTREAM_DAOPI_20231101 >									
183 	//        < 8qkJL1OkEsITxVURLA3TjPks21dDtmy7Y6Gw329WmSpGv5fW1Y6HOhDA5pM9EZ09 >									
184 	//        <  u =="0.000000000000000001" : ] 000000259499970.309359000000000000 ; 000000278741267.422085000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000018BF72D1A9534F >									
186 	//     < RUSS_PFXXV_II_metadata_line_14_____NORDSTREAM_DAC_20231101 >									
187 	//        < P5ToE369Wknn0eXKyc1y5bD3xyvgb76dq6qxJEJT08L26oUNTf7F7eOr1UNj28E9 >									
188 	//        <  u =="0.000000000000000001" : ] 000000278741267.422085000000000000 ; 000000296415931.129853000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000001A9534F1C44B79 >									
190 	//     < RUSS_PFXXV_II_metadata_line_15_____NORDSTREAM_BIMI_20231101 >									
191 	//        < yGKgP5QXfG4Ol48ZEs17R3u0Gq29vhG9V8mIDxQ4SiW9opYhNGCE141rkWTXV3GP >									
192 	//        <  u =="0.000000000000000001" : ] 000000296415931.129853000000000000 ; 000000316210970.954154000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000001C44B791E27FE9 >									
194 	//     < RUSS_PFXXV_II_metadata_line_16_____GASCAP_ORG_20231101 >									
195 	//        < Jic74I3uFiuxsI6nK5475e5V1pzer1QH8ukDN3R2OM0byqHnhyGR57rSD4mSozTu >									
196 	//        <  u =="0.000000000000000001" : ] 000000316210970.954154000000000000 ; 000000339756680.646515000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000001E27FE92066D74 >									
198 	//     < RUSS_PFXXV_II_metadata_line_17_____GASCAP_DAO_20231101 >									
199 	//        < duRKuQvqb390qvgUZ233ZKdXb5t8Quob61jr2OvKV6Ix6oKJ59f1lX5M3hTFDCGj >									
200 	//        <  u =="0.000000000000000001" : ] 000000339756680.646515000000000000 ; 000000357326953.926262000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000002066D742213CD7 >									
202 	//     < RUSS_PFXXV_II_metadata_line_18_____GASCAP_DAOPI_20231101 >									
203 	//        < 8a1eGBQKkv2IRF7O4B7Sgsx9u72fz0S3NKdzhGXRQTi8mbZpj68q3VObh1b8Tx83 >									
204 	//        <  u =="0.000000000000000001" : ] 000000357326953.926262000000000000 ; 000000380535404.877852000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000002213CD7244A6A4 >									
206 	//     < RUSS_PFXXV_II_metadata_line_19_____GASCAP_DAC_20231101 >									
207 	//        < y1Urvgi88FhYgws9yG65Ac0GUoijmReko6CJMv04i0Hqs42941xa94lXy0eB9962 >									
208 	//        <  u =="0.000000000000000001" : ] 000000380535404.877852000000000000 ; 000000399087282.781701000000000000 ] >									
209 	//        < 0x00000000000000000000000000000000000000000000000000244A6A4260F578 >									
210 	//     < RUSS_PFXXV_II_metadata_line_20_____GASCAP_BIMI_20231101 >									
211 	//        < 6D6P6P6vDVna1BWI6bCQB08Sb7hJkGunFSstoF99569FsxQ1PKH8mclu6oO0p3pA >									
212 	//        <  u =="0.000000000000000001" : ] 000000399087282.781701000000000000 ; 000000415819055.078920000000000000 ] >									
213 	//        < 0x00000000000000000000000000000000000000000000000000260F57827A7D52 >									
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
256 	//     < RUSS_PFXXV_II_metadata_line_21_____GAZ_CAPITAL_SA_20231101 >									
257 	//        < 89SJCjo49vKGu82W1MM8FWF8XUr49OgyS3eSPvX63RI2G8TWiCsjTzTkzFQRht0U >									
258 	//        <  u =="0.000000000000000001" : ] 000000415819055.078920000000000000 ; 000000435165366.082324000000000000 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000000027A7D522980279 >									
260 	//     < RUSS_PFXXV_II_metadata_line_22_____BELTRANSGAZ_20231101 >									
261 	//        < q8rigoYC5oXZob9WAyPT6a5pR7qDL4L4gmpn9lfbic44bePppg15j209968r532Z >									
262 	//        <  u =="0.000000000000000001" : ] 000000435165366.082324000000000000 ; 000000454501905.784145000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000029802792B583CF >									
264 	//     < RUSS_PFXXV_II_metadata_line_23_____OVERGAS_20231101 >									
265 	//        < w0dFQqBik0H52O11KgnRy6tXWR517F2ECOJ3Gkz5j4U958L3h80092hM7Uw6pQ8Q >									
266 	//        <  u =="0.000000000000000001" : ] 000000454501905.784145000000000000 ; 000000475670137.394515000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000002B583CF2D5D0A6 >									
268 	//     < RUSS_PFXXV_II_metadata_line_24_____GAZPROM_MARKETING_TRADING_20231101 >									
269 	//        < C1x2m3OQL4jh48o1g7QNgqIW3tKKd413FRua20oWdqXx0gog65a2133sdh3iD7cV >									
270 	//        <  u =="0.000000000000000001" : ] 000000475670137.394515000000000000 ; 000000498438047.562029000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000002D5D0A62F88E5D >									
272 	//     < RUSS_PFXXV_II_metadata_line_25_____ROSUKRENERGO_20231101 >									
273 	//        < KP8V18ikqCW9B25QrGxfUo36cB9tjIvPW7676ccyIYW428mX9F1lFkFk7v8sN7mn >									
274 	//        <  u =="0.000000000000000001" : ] 000000498438047.562029000000000000 ; 000000521902703.955507000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002F88E5D31C5C3E >									
276 	//     < RUSS_PFXXV_II_metadata_line_26_____TRANSGAZ_VOLGORAD_20231101 >									
277 	//        < 6I1J702J3SCY3bSr21p653YP2BupJ201V68458iUx81dm9NG76Zf4Vbav73HdrEV >									
278 	//        <  u =="0.000000000000000001" : ] 000000521902703.955507000000000000 ; 000000546415062.886037000000000000 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000000000031C5C3E341C362 >									
280 	//     < RUSS_PFXXV_II_metadata_line_27_____SPACE_SYSTEMS_20231101 >									
281 	//        < H8hsGC8j2Pjtz9lbL2zaRZu5qqE90zZh015Bdv7UpIywwICDFdQ2P3iahr3RXbGj >									
282 	//        <  u =="0.000000000000000001" : ] 000000546415062.886037000000000000 ; 000000563002995.348956000000000000 ] >									
283 	//        < 0x00000000000000000000000000000000000000000000000000341C36235B130C >									
284 	//     < RUSS_PFXXV_II_metadata_line_28_____MOLDOVAGAZ_20231101 >									
285 	//        < ba7thoM9Xq5f77G398XM8c730uUT9cZXy1swoEwiYY0zCEpneO9siA33RmY1KiX5 >									
286 	//        <  u =="0.000000000000000001" : ] 000000563002995.348956000000000000 ; 000000580312165.969735000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000035B130C3757C71 >									
288 	//     < RUSS_PFXXV_II_metadata_line_29_____VOSTOKGAZPROM_20231101 >									
289 	//        < Hi12q9I863Ge1tn0IP8c71QJ1Oc10Hc8uLG33X12qu5nUOCkqlU7bM5MAmQo2xh9 >									
290 	//        <  u =="0.000000000000000001" : ] 000000580312165.969735000000000000 ; 000000604305135.338205000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000003757C7139A18B2 >									
292 	//     < RUSS_PFXXV_II_metadata_line_30_____GAZPROM_UK_20231101 >									
293 	//        < 148Ses7QTgUmOy3vL97hBz906e31L2o1Br8t1mwJdh9uZxk7czmqtF0JPmnmKD0n >									
294 	//        <  u =="0.000000000000000001" : ] 000000604305135.338205000000000000 ; 000000621909432.771217000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000039A18B23B4F55F >									
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
338 	//     < RUSS_PFXXV_II_metadata_line_31_____SOUTHSTREAM_AG_20231101 >									
339 	//        < 6rZG536ZHKI5x65jFex8OUkHOFyt5LJk9X3Afly2d0Cc56z25t9r5AO5gk9215Q9 >									
340 	//        <  u =="0.000000000000000001" : ] 000000621909432.771217000000000000 ; 000000640938098.686648000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000003B4F55F3D1FE72 >									
342 	//     < RUSS_PFXXV_II_metadata_line_32_____SOUTHSTREAM_DAO_20231101 >									
343 	//        < uB5zYTyvKRyam72MdV90o9I7KQTf04HWZ6rQ0m3Ae6kGOmC7203pJl0L07gfdieI >									
344 	//        <  u =="0.000000000000000001" : ] 000000640938098.686648000000000000 ; 000000656403314.135563000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000003D1FE723E9978B >									
346 	//     < RUSS_PFXXV_II_metadata_line_33_____SOUTHSTREAM_DAOPI_20231101 >									
347 	//        < 68JdI757Yq2Z7FIkeS9XosMQ11U3rb7nsxs6cqv368TL1sPKy5458At50655T31J >									
348 	//        <  u =="0.000000000000000001" : ] 000000656403314.135563000000000000 ; 000000676309669.476572000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000003E9978B407F777 >									
350 	//     < RUSS_PFXXV_II_metadata_line_34_____SOUTHSTREAM_DAC_20231101 >									
351 	//        < I62s6mjtdq8Mmj0h97DKHFCWW5j6k6myPdk4u4b0t39PJZM5M75p54JriT9QY1Zh >									
352 	//        <  u =="0.000000000000000001" : ] 000000676309669.476572000000000000 ; 000000699834104.102285000000000000 ] >									
353 	//        < 0x00000000000000000000000000000000000000000000000000407F77742BDCB2 >									
354 	//     < RUSS_PFXXV_II_metadata_line_35_____SOUTHSTREAM_BIMI_20231101 >									
355 	//        < BC14in15wpldkxJI7X0km93mDYPp9JClb992Db1XQpd8OUcdIjLV18d3poiurM3s >									
356 	//        <  u =="0.000000000000000001" : ] 000000699834104.102285000000000000 ; 000000716886543.647929000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000042BDCB2445E1CE >									
358 	//     < RUSS_PFXXV_II_metadata_line_36_____GAZPROM_ARMENIA_20231101 >									
359 	//        < 85b18o10NJXMWQrqiH05UgV8iOpm3bHJf6Ug0jy5H4hA8731xl1OPZ211D51V9HY >									
360 	//        <  u =="0.000000000000000001" : ] 000000716886543.647929000000000000 ; 000000738579173.949683000000000000 ] >									
361 	//        < 0x00000000000000000000000000000000000000000000000000445E1CE466FB7D >									
362 	//     < RUSS_PFXXV_II_metadata_line_37_____CHORNOMORNAFTOGAZ_20231101 >									
363 	//        < p0419070Hok3QF8t3o3XD4e7W13qXr9bUsLYMu7TYka2214H8yO59F8UuQ33JEAu >									
364 	//        <  u =="0.000000000000000001" : ] 000000738579173.949683000000000000 ; 000000756031754.480233000000000000 ] >									
365 	//        < 0x00000000000000000000000000000000000000000000000000466FB7D4819CE7 >									
366 	//     < RUSS_PFXXV_II_metadata_line_38_____SHTOKMAN_DEV_AG_20231101 >									
367 	//        < gNmH39S3n4FM083B26a39GmhdoK8R7ePaB34WIKZJD7W938WO3w6qxGGXnuqh1CX >									
368 	//        <  u =="0.000000000000000001" : ] 000000756031754.480233000000000000 ; 000000774678802.241599000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000004819CE749E10E8 >									
370 	//     < RUSS_PFXXV_II_metadata_line_39_____VEMEX_20231101 >									
371 	//        < OhFyy5plHG0gt903vD5RLRM8JLn3ULtD3Ic2DGs0p1e31b0H3tewZNsd14pWYyqy >									
372 	//        <  u =="0.000000000000000001" : ] 000000774678802.241599000000000000 ; 000000791742806.868253000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000049E10E84B81A89 >									
374 	//     < RUSS_PFXXV_II_metadata_line_40_____BOSPHORUS_GAZ_20231101 >									
375 	//        < 459MqIEk3TyW3684LxluBIV63KfRC6Sd6BF7MKZS130BJSu9Z4EsoB75xilQ8wge >									
376 	//        <  u =="0.000000000000000001" : ] 000000791742806.868253000000000000 ; 000000816564412.560058000000000000 ] >									
377 	//        < 0x000000000000000000000000000000000000000000000000004B81A894DDFA79 >									
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