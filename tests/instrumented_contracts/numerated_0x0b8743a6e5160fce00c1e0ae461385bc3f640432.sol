1 pragma solidity 		^0.4.25	;						
2 										
3 	contract	CHEMCHINA_PFIV_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	CHEMCHINA_PFIV_I_883		"	;
8 		string	public		symbol =	"	CHEMCHINA_PFIV_I_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		582378823553285000000000000					;	
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
92 	//     < CHEMCHINA_PFIV_I_metadata_line_1_____Kaifute__Tianjin__Chemical_Co___Ltd__20220321 >									
93 	//        < 09CN5klv7xWP3IFGx2bsyNZ934Fql8BT563a6EfSsRlEUYg367j0MJ87K9Atu8aF >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000013513688.112834700000000000 ] >									
95 	//        < 0x0000000000000000000000000000000000000000000000000000000000149EC9 >									
96 	//     < CHEMCHINA_PFIV_I_metadata_line_2_____Kaiyuan_Chemicals_Co__Limited_20220321 >									
97 	//        < jOGOCe6z1o2k4KwWsD2cxz7EzDWd9Uv3As86vuLowXPj7F6lAwA7kqUH8YBU24Z8 >									
98 	//        <  u =="0.000000000000000001" : ] 000000013513688.112834700000000000 ; 000000029285012.485496900000000000 ] >									
99 	//        < 0x0000000000000000000000000000000000000000000000000000149EC92CAF75 >									
100 	//     < CHEMCHINA_PFIV_I_metadata_line_3_____Kinbester_org_20220321 >									
101 	//        < PHV28HonNIf0sRaAZ4011pL9xnECeHghnz6T0XT8EdS9cX0nNsJUL8ghT4MmVhka >									
102 	//        <  u =="0.000000000000000001" : ] 000000029285012.485496900000000000 ; 000000043894152.627250700000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000002CAF7542FA27 >									
104 	//     < CHEMCHINA_PFIV_I_metadata_line_4_____Kinbester_Co_Limited_20220321 >									
105 	//        < n43cvsIztz2P8EqZmBN5V3F7z04V3p343225Ygq25HXqTTSyCCv2eV000vS44427 >									
106 	//        <  u =="0.000000000000000001" : ] 000000043894152.627250700000000000 ; 000000057566746.703826600000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000042FA2757D703 >									
108 	//     < CHEMCHINA_PFIV_I_metadata_line_5_____Kinfon_Pharmachem_Co_Limited_20220321 >									
109 	//        < 3Rtpe7ZA8SgL29WFY7Mh8FN6K951886oaz4O604M6h24Tfi1Hlnr2099OELHB10P >									
110 	//        <  u =="0.000000000000000001" : ] 000000057566746.703826600000000000 ; 000000072997620.634451000000000000 ] >									
111 	//        < 0x000000000000000000000000000000000000000000000000000057D7036F62B2 >									
112 	//     < CHEMCHINA_PFIV_I_metadata_line_6_____King_Scientific_20220321 >									
113 	//        < 859xVk3X7427kTL13o20is76v2Q4acx4Yfg16Lfe93m9ZR9SvqO4nttGe0y6Xy0M >									
114 	//        <  u =="0.000000000000000001" : ] 000000072997620.634451000000000000 ; 000000086328412.475527800000000000 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000000000006F62B283BA09 >									
116 	//     < CHEMCHINA_PFIV_I_metadata_line_7_____Kingreat_Chemistry_Company_Limited_20220321 >									
117 	//        < rGCC24wV6UAV7bLhrPSn9WhHq3o082oSay8D867aAgeB49Dd971VU0JE14MFq992 >									
118 	//        <  u =="0.000000000000000001" : ] 000000086328412.475527800000000000 ; 000000099416314.580296800000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000000083BA0997B27F >									
120 	//     < CHEMCHINA_PFIV_I_metadata_line_8_____Labseeker_org_20220321 >									
121 	//        < 51aO2YkbU81k78C55eW2Oq7oBA7ne8UrpxvA559keX2TqqZj1Yu7Hp21KP4IGv8T >									
122 	//        <  u =="0.000000000000000001" : ] 000000099416314.580296800000000000 ; 000000113841150.117675000000000000 ] >									
123 	//        < 0x000000000000000000000000000000000000000000000000000097B27FADB533 >									
124 	//     < CHEMCHINA_PFIV_I_metadata_line_9_____Labseeker_20220321 >									
125 	//        < vQuyH6055nPmn6Nxem46G3Trcf0z982rro1RiZ4d24pXeEyMgBDw37X8lp8yXr5t >									
126 	//        <  u =="0.000000000000000001" : ] 000000113841150.117675000000000000 ; 000000129057499.542320000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000000ADB533C4ED16 >									
128 	//     < CHEMCHINA_PFIV_I_metadata_line_10_____Langfang_Beixin_Chemical_Company_Limited_20220321 >									
129 	//        < XcCy47yx5kB8o1GUb64n4exPG2ipk69vXG0XWl55r2u59JAZG8L8ncs303VUH5vK >									
130 	//        <  u =="0.000000000000000001" : ] 000000129057499.542320000000000000 ; 000000143730790.586656000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000000C4ED16DB50D7 >									
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
174 	//     < CHEMCHINA_PFIV_I_metadata_line_11_____Leap_Labchem_Co_Limited_20220321 >									
175 	//        < rj8B03SCZPzOe2Gyn8Ysn1k2Af5716q353FSrLIa7wG3VO76TvBlpDUdaU62YzWY >									
176 	//        <  u =="0.000000000000000001" : ] 000000143730790.586656000000000000 ; 000000157134635.972637000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000000DB50D7EFC4B8 >									
178 	//     < CHEMCHINA_PFIV_I_metadata_line_12_____Leap_Labchem_Co_Limited_20220321 >									
179 	//        < wmyfHLLbn8c0Pd5P9TQY4OBf3sE47yhmV1qOTF2CAYra7w6BEkO9e81PQZSGT320 >									
180 	//        <  u =="0.000000000000000001" : ] 000000157134635.972637000000000000 ; 000000171770495.163879000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000000EFC4B810619DA >									
182 	//     < CHEMCHINA_PFIV_I_metadata_line_13_____LON_CHEMICAL_org_20220321 >									
183 	//        < k7oRAkxt9r5NQ7TM022kG68s73HgSK437Q9xB96xrFML5yy6n8OEfX5gj0p1oM4F >									
184 	//        <  u =="0.000000000000000001" : ] 000000171770495.163879000000000000 ; 000000187848008.645123000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000010619DA11EA221 >									
186 	//     < CHEMCHINA_PFIV_I_metadata_line_14_____LON_CHEMICAL_20220321 >									
187 	//        < dF8z22rUgq0So4I9W5i40YT689bH134yEKvpM6HySt5zJZH0CB872otIjs2lw2X8 >									
188 	//        <  u =="0.000000000000000001" : ] 000000187848008.645123000000000000 ; 000000202348313.957375000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000011EA221134C24F >									
190 	//     < CHEMCHINA_PFIV_I_metadata_line_15_____LVYU_Chemical_Co__Limited_20220321 >									
191 	//        < mkFpszljZ711C8jvTDhg55E5dYX7l408T07N9KF8Zc4OQ8OgW29h77f5QhaLgWtu >									
192 	//        <  u =="0.000000000000000001" : ] 000000202348313.957375000000000000 ; 000000217634968.326150000000000000 ] >									
193 	//        < 0x00000000000000000000000000000000000000000000000000134C24F14C15A9 >									
194 	//     < CHEMCHINA_PFIV_I_metadata_line_16_____MASCOT_I_E__Co_Limited_20220321 >									
195 	//        < 12iRQK4uW60coB2vw12VKbRVsUuGZ551bDY0Bn2qjXm53DJS9zGPAjr01D693YUN >									
196 	//        <  u =="0.000000000000000001" : ] 000000217634968.326150000000000000 ; 000000233113314.720612000000000000 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000000014C15A9163B3E3 >									
198 	//     < CHEMCHINA_PFIV_I_metadata_line_17_____NANCHANG_LONGDING_TECHNOLOGY_DEVELOPMENT_Co_Limited_20220321 >									
199 	//        < 2bh9JEFFXwpy8mys2qN0lvU4RZ8h3CEdE6undHm6KB13mYIKP36C9lrX1bTALGP1 >									
200 	//        <  u =="0.000000000000000001" : ] 000000233113314.720612000000000000 ; 000000246595814.228104000000000000 ] >									
201 	//        < 0x00000000000000000000000000000000000000000000000000163B3E3178467D >									
202 	//     < CHEMCHINA_PFIV_I_metadata_line_18_____Nanjing_BoomKing_Industrial_Co_Limited_20220321 >									
203 	//        < Ta3rJvxMyH76JZnI2W6c9l1XG7JM8fhgM0HTXcWo8kbzmWHk8K8zOHx5c9p9M4Mr >									
204 	//        <  u =="0.000000000000000001" : ] 000000246595814.228104000000000000 ; 000000262776555.736689000000000000 ] >									
205 	//        < 0x00000000000000000000000000000000000000000000000000178467D190F718 >									
206 	//     < CHEMCHINA_PFIV_I_metadata_line_19_____Nanjing_Boyuan_Pharmatech_Co_Limited_20220321 >									
207 	//        < 20JA6UZMhlmzkIH8bPH4mw626Dk44ExB3xjEVq5VcR5OlT4z7r93CMA2V1l8O84f >									
208 	//        <  u =="0.000000000000000001" : ] 000000262776555.736689000000000000 ; 000000277588268.016817000000000000 ] >									
209 	//        < 0x00000000000000000000000000000000000000000000000000190F7181A790EB >									
210 	//     < CHEMCHINA_PFIV_I_metadata_line_20_____Nanjing_Chemlin_Chemical_Industry_org_20220321 >									
211 	//        < 0uY7Ff3T3IQkKu2Tnf5Z6WK3fBcYeknbB9d07Dv2ri03i7crU1V7caJGQxs9pqi0 >									
212 	//        <  u =="0.000000000000000001" : ] 000000277588268.016817000000000000 ; 000000290485086.015711000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000001A790EB1BB3EBD >									
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
256 	//     < CHEMCHINA_PFIV_I_metadata_line_21_____Nanjing_Chemlin_Chemical_Industry_Co_Limited_20220321 >									
257 	//        < u07E5LUy7jEA0DB25aSV9A0LX7sq24K6tedrpQS4R4XwsK7310198IJ5B2G2qrLZ >									
258 	//        <  u =="0.000000000000000001" : ] 000000290485086.015711000000000000 ; 000000306400409.183230000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000001BB3EBD1D387A9 >									
260 	//     < CHEMCHINA_PFIV_I_metadata_line_22_____Nanjing_Chemlin_Chemical_Industry_Co_Limited_20220321 >									
261 	//        < POgGdXbMmrr9ge4Ileq6plXm32Cj9q8w0m0pnVRt5L1Bdx99ctfJ9687877vpSRh >									
262 	//        <  u =="0.000000000000000001" : ] 000000306400409.183230000000000000 ; 000000321488070.126643000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000001D387A91EA8D47 >									
264 	//     < CHEMCHINA_PFIV_I_metadata_line_23_____Nanjing_Fubang_Chemical_Co_Limited_20220321 >									
265 	//        < Zm4wFM76NzubMlch45vGaF01jN005ewu2m0m9ZGF7VZYtEbm1ao0BdLZ437C8YMp >									
266 	//        <  u =="0.000000000000000001" : ] 000000321488070.126643000000000000 ; 000000337346008.085204000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000001EA8D47202BFC9 >									
268 	//     < CHEMCHINA_PFIV_I_metadata_line_24_____Nanjing_Legend_Pharmaceutical___Chemical_Co__Limited_20220321 >									
269 	//        < QRWEBQ6MUF8Su434lnmt2D92V0K0Sr2o9u3mxkwDmw8oYrAQYcbwB39AGGG5dTau >									
270 	//        <  u =="0.000000000000000001" : ] 000000337346008.085204000000000000 ; 000000351136755.734276000000000000 ] >									
271 	//        < 0x00000000000000000000000000000000000000000000000000202BFC9217CACC >									
272 	//     < CHEMCHINA_PFIV_I_metadata_line_25_____Nanjing_Raymon_Biotech_Co_Limited_20220321 >									
273 	//        < WD9H3e39zi180N3DC1OGEqHX6E6Obf9j5ECv2A5NIYv0qUKAa7k85Duypr1g8oaq >									
274 	//        <  u =="0.000000000000000001" : ] 000000351136755.734276000000000000 ; 000000367333338.244561000000000000 ] >									
275 	//        < 0x00000000000000000000000000000000000000000000000000217CACC2308196 >									
276 	//     < CHEMCHINA_PFIV_I_metadata_line_26_____Nantong_Baihua_Bio_Pharmaceutical_Co_Limited_20220321 >									
277 	//        < rw2OHtM1UVdZF8E37dTHt74aT8cACPP1E4pqf9cHy3L83EV8djcBzS35V574Ry3z >									
278 	//        <  u =="0.000000000000000001" : ] 000000367333338.244561000000000000 ; 000000381652814.607694000000000000 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000000000023081962465B21 >									
280 	//     < CHEMCHINA_PFIV_I_metadata_line_27_____Nantong_Qihai_Chemicals_org_20220321 >									
281 	//        < V75f6doHTdy2fyAE9jSa1X9C3RiVQ18e26Z41N5RmF1mK7icBcas2SKXV005393V >									
282 	//        <  u =="0.000000000000000001" : ] 000000381652814.607694000000000000 ; 000000394657347.902426000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000002465B2125A3307 >									
284 	//     < CHEMCHINA_PFIV_I_metadata_line_28_____Nantong_Qihai_Chemicals_Co_Limited_20220321 >									
285 	//        < tjVuWLg2KWt1nS45jlL8J2I65379U2H1DjiCk6M127ZPj0b7e5Cs91g5rFSafGnv >									
286 	//        <  u =="0.000000000000000001" : ] 000000394657347.902426000000000000 ; 000000407429604.167784000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000025A330726DB030 >									
288 	//     < CHEMCHINA_PFIV_I_metadata_line_29_____Nebula_Chemicals_Co_Limited_20220321 >									
289 	//        < 1W19lW3thF0h0CP608B1sOCdq2eBBBDR04BZ59y8OETIcF68T27Ys1EvEPvVT6Fm >									
290 	//        <  u =="0.000000000000000001" : ] 000000407429604.167784000000000000 ; 000000421342660.956319000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000026DB030282EAFA >									
292 	//     < CHEMCHINA_PFIV_I_metadata_line_30_____Neostar_United_Industrial_Co__Limited_20220321 >									
293 	//        < UyQG83f4QfeZDX00vBG875bFWOcL5wE3rcty43s5XLdLavTzGeDS2UqpH61Sf4OB >									
294 	//        <  u =="0.000000000000000001" : ] 000000421342660.956319000000000000 ; 000000437515963.462755000000000000 ] >									
295 	//        < 0x00000000000000000000000000000000000000000000000000282EAFA29B98AC >									
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
338 	//     < CHEMCHINA_PFIV_I_metadata_line_31_____Nextpeptide_inc__20220321 >									
339 	//        < IJMnrhMKc7991Bv6Cy87GQD9vbUx69EZ827nn2U4AoMEWHIjoApI69o0vF5B3TuY >									
340 	//        <  u =="0.000000000000000001" : ] 000000437515963.462755000000000000 ; 000000453779401.513349000000000000 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000000000029B98AC2B46994 >									
342 	//     < CHEMCHINA_PFIV_I_metadata_line_32_____Ningbo_Nuobai_Pharmaceutical_Co_Limited_20220321 >									
343 	//        < y10NY419JJodaAEdE2K2HNIrDvnX6w2x8L61y9j8pV6s7WX5cRA6fN9V248X42ym >									
344 	//        <  u =="0.000000000000000001" : ] 000000453779401.513349000000000000 ; 000000466549625.828026000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000002B469942C7E5F3 >									
346 	//     < CHEMCHINA_PFIV_I_metadata_line_33_____NINGBO_V_P_CHEMISTRY_20220321 >									
347 	//        < h1fO35TyvGW1Yz4Cu8WGYExBPgGt7xiM6q0To8BTM3OM097AJjl7XIJ82KUOtzO8 >									
348 	//        <  u =="0.000000000000000001" : ] 000000466549625.828026000000000000 ; 000000481861439.012530000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000002C7E5F32DF4320 >									
350 	//     < CHEMCHINA_PFIV_I_metadata_line_34_____NovoChemy_Limited_20220321 >									
351 	//        < Fi501pELlYr619W67MbImf3O7qWDwV6kM1733OtNjVE09yjbxMaFxCH7roQ6YTu6 >									
352 	//        <  u =="0.000000000000000001" : ] 000000481861439.012530000000000000 ; 000000497889352.791589000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000002DF43202F7B807 >									
354 	//     < CHEMCHINA_PFIV_I_metadata_line_35_____Novolite_Chemicals_org_20220321 >									
355 	//        < T9h39zfnMXuvW14jT7h2f144we3WSx0g448q9UBveHVSQ28KCzx3yji0BTEG5NNO >									
356 	//        <  u =="0.000000000000000001" : ] 000000497889352.791589000000000000 ; 000000512948243.747656000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000002F7B80730EB268 >									
358 	//     < CHEMCHINA_PFIV_I_metadata_line_36_____Novolite_Chemicals_Co_Limited_20220321 >									
359 	//        < P30842Kn9Rcv26I1Cuc8AVVhXPhn9P3VE70p7JJ9LZdyFnM3COThSnlq0F3fCUt9 >									
360 	//        <  u =="0.000000000000000001" : ] 000000512948243.747656000000000000 ; 000000525822850.112319000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000030EB268322578D >									
362 	//     < CHEMCHINA_PFIV_I_metadata_line_37_____Onichem_Specialities_Co__Limited_20220321 >									
363 	//        < 3DUt3Vap7I6x90Br1wx2xv0s91jhLWCa7tVuCXt3BN2365HS4Uu5sy8zw1YY8g99 >									
364 	//        <  u =="0.000000000000000001" : ] 000000525822850.112319000000000000 ; 000000539467447.115573000000000000 ] >									
365 	//        < 0x00000000000000000000000000000000000000000000000000322578D3372979 >									
366 	//     < CHEMCHINA_PFIV_I_metadata_line_38_____Orichem_international_Limited_20220321 >									
367 	//        < bW0Y96eW68gamW7oVPzQ8rs6hw4M0P6M7opX29Lj3NG2zafV9Otb610817q62371 >									
368 	//        <  u =="0.000000000000000001" : ] 000000539467447.115573000000000000 ; 000000553818756.114362000000000000 ] >									
369 	//        < 0x00000000000000000000000000000000000000000000000000337297934D0F74 >									
370 	//     < CHEMCHINA_PFIV_I_metadata_line_39_____PHARMACORE_Co_Limited_20220321 >									
371 	//        < f9d9HoyJ4EDkVa9AM7IQ8TBvX1Q5wqdS71qPnfBexpsRrzMXoueOE307e7y58mJI >									
372 	//        <  u =="0.000000000000000001" : ] 000000553818756.114362000000000000 ; 000000566666449.343251000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000034D0F74360AA15 >									
374 	//     < CHEMCHINA_PFIV_I_metadata_line_40_____Pharmasi_Chemicals_Company_Limited_20220321 >									
375 	//        < 9vM1qr7XzwmUNWi3aoS9pTg4KzM4YFql1UorzOfoseLIPBx6cOo7Q0v5qQYx9Bw4 >									
376 	//        <  u =="0.000000000000000001" : ] 000000566666449.343251000000000000 ; 000000582378823.553285000000000000 ] >									
377 	//        < 0x00000000000000000000000000000000000000000000000000360AA15378A3BA >									
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