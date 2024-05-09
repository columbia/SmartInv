1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFII_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFII_I_883		"	;
8 		string	public		symbol =	"	RUSS_PFII_I_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		607574543126106000000000000					;	
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
92 	//     < RUSS_PFII_I_metadata_line_1_____SISTEMA_20211101 >									
93 	//        < 400532D9C7J2U6qe416Wstn7oGgz1YiJV9g89G35vim3qU828I2J3dqa7920tcto >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000013966814.050344300000000000 ] >									
95 	//        < 0x0000000000000000000000000000000000000000000000000000000000154FC9 >									
96 	//     < RUSS_PFII_I_metadata_line_2_____SISTEMA_usd_20211101 >									
97 	//        < 8z7I4SlJC702uS33JwJxC0FfUL96xlIa9s9717ib3arA7os31e8H8tZ66415jiD5 >									
98 	//        <  u =="0.000000000000000001" : ] 000000013966814.050344300000000000 ; 000000029205115.652946000000000000 ] >									
99 	//        < 0x0000000000000000000000000000000000000000000000000000154FC92C9040 >									
100 	//     < RUSS_PFII_I_metadata_line_3_____SISTEMA_AB_20211101 >									
101 	//        < Kib28jRY9vs6aB2TZ5mAr4Z9Uk21gmM95luXFw3NAmGoSbaNszeDrO1oxZ3qK8tz >									
102 	//        <  u =="0.000000000000000001" : ] 000000029205115.652946000000000000 ; 000000043863296.235502600000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000002C904042EE1A >									
104 	//     < RUSS_PFII_I_metadata_line_4_____RUSAL_20211101 >									
105 	//        < 4G2k7069MPzmpARK9f74nX03n39M93zeL3BON4Ao656Fja8201SRo16jpgeT3L67 >									
106 	//        <  u =="0.000000000000000001" : ] 000000043863296.235502600000000000 ; 000000060274378.135398100000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000042EE1A5BF8AE >									
108 	//     < RUSS_PFII_I_metadata_line_5_____RUSAL_HKD_20211101 >									
109 	//        < wbMsvjw8STJ7g7MX3Lq74Q2v0zDB70I15GEt91EuXaLqGF37O3W9nbzU1P9xRp20 >									
110 	//        <  u =="0.000000000000000001" : ] 000000060274378.135398100000000000 ; 000000076564365.942667500000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000005BF8AE74D3F5 >									
112 	//     < RUSS_PFII_I_metadata_line_6_____RUSAL_GBP_20211101 >									
113 	//        < jjnsBS323vD44f5o132plPd1Zq38VUk6Sx8Z9hfAtS9W7C17wXBu1u3egr5Bkinq >									
114 	//        <  u =="0.000000000000000001" : ] 000000076564365.942667500000000000 ; 000000093254439.051892900000000000 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000000000074D3F58E4B84 >									
116 	//     < RUSS_PFII_I_metadata_line_7_____RUSAL_AB_20211101 >									
117 	//        < txKyqQ5NQLvHwSUX86C804M9K0opjH7Jk9wHhTKkTz5Qs3FSrepLW7U642i3L7aW >									
118 	//        <  u =="0.000000000000000001" : ] 000000093254439.051892900000000000 ; 000000108321671.932877000000000000 ] >									
119 	//        < 0x00000000000000000000000000000000000000000000000000008E4B84A54927 >									
120 	//     < RUSS_PFII_I_metadata_line_8_____EUROSIBENERGO_20211101 >									
121 	//        < yUigUb1YKfjjtNtmS22jS21U4Zg86C4hr2ecYj0ruxAwl2t0p4ExMYV99AzozVf4 >									
122 	//        <  u =="0.000000000000000001" : ] 000000108321671.932877000000000000 ; 000000123739117.118783000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000A54927BCCF98 >									
124 	//     < RUSS_PFII_I_metadata_line_9_____BASEL_20211101 >									
125 	//        < Z4rud34HFuqw8YS3gEw32Fx4yRo2Sj4F6p9pvIagC2A2ka613r34z27g8Ll3C0NR >									
126 	//        <  u =="0.000000000000000001" : ] 000000123739117.118783000000000000 ; 000000137515160.401992000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000000BCCF98D1D4DC >									
128 	//     < RUSS_PFII_I_metadata_line_10_____ENPLUS_20211101 >									
129 	//        < 16Ot29gznKrUybZ8ruC01Naz8UCPszb2zPY4wM4vG3o4c9qn853AB8tCRO8j5tTz >									
130 	//        <  u =="0.000000000000000001" : ] 000000137515160.401992000000000000 ; 000000154164680.420657000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000000D1D4DCEB3C94 >									
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
174 	//     < RUSS_PFII_I_metadata_line_11_____RUSSIAN_MACHINES_20211101 >									
175 	//        < j01G2jx120tEtu37kpLLgylZM4391zJj9ngJub94ejA57rmz477DatK6Yk5Ae8aC >									
176 	//        <  u =="0.000000000000000001" : ] 000000154164680.420657000000000000 ; 000000170904926.034408000000000000 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000000000EB3C94104C7BD >									
178 	//     < RUSS_PFII_I_metadata_line_12_____GAZ_GROUP_20211101 >									
179 	//        < Clv26Ng63Ft5y4tqPQnjfn7ucldjB37rKk624KIUw239m6wos2a5jF47TJ1Qm8s7 >									
180 	//        <  u =="0.000000000000000001" : ] 000000170904926.034408000000000000 ; 000000185766635.171482000000000000 ] >									
181 	//        < 0x00000000000000000000000000000000000000000000000000104C7BD11B7518 >									
182 	//     < RUSS_PFII_I_metadata_line_13_____SMR_20211101 >									
183 	//        < 3240DVCn6pVuMSfxsrdfIv3JxjFgUkrfX0hnA2QJw44Pe11247FFTZDP7jNZbF0n >									
184 	//        <  u =="0.000000000000000001" : ] 000000185766635.171482000000000000 ; 000000200395595.534121000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000011B7518131C788 >									
186 	//     < RUSS_PFII_I_metadata_line_14_____ENPLUS_DOWN_20211101 >									
187 	//        < FAuP69wVE6z3hPMKZm70508RBF5QQzgdW7bSBlH7aL1KK93es53Ku09V3D9J8c0G >									
188 	//        <  u =="0.000000000000000001" : ] 000000200395595.534121000000000000 ; 000000214427448.591680000000000000 ] >									
189 	//        < 0x00000000000000000000000000000000000000000000000000131C78814730B9 >									
190 	//     < RUSS_PFII_I_metadata_line_15_____ENPLUS_COAL_20211101 >									
191 	//        < kXoyWR4p5ykIOZVZ02aDT092xwxshflFlSJ8DPDOi2SigCcg9mb97q3W4RtB4FCr >									
192 	//        <  u =="0.000000000000000001" : ] 000000214427448.591680000000000000 ; 000000230821502.540603000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000014730B916034A6 >									
194 	//     < RUSS_PFII_I_metadata_line_16_____RM_SYSTEMS_20211101 >									
195 	//        < Nc3XT2tH2RGEdV6LC4mcwnbOOrBI1M6uyhP4dFSW2R327riXBiD23qDTa8S2Q2L5 >									
196 	//        <  u =="0.000000000000000001" : ] 000000230821502.540603000000000000 ; 000000245387243.551385000000000000 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000000016034A61766E64 >									
198 	//     < RUSS_PFII_I_metadata_line_17_____RM_RAIL_20211101 >									
199 	//        < tB5Y704z8wJ71FmZrSk368f09IUs6S0G4jjw0Yy3rDj0X3SIHI188Q283qto7qV3 >									
200 	//        <  u =="0.000000000000000001" : ] 000000245387243.551385000000000000 ; 000000259926816.820273000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000001766E6418C9DEA >									
202 	//     < RUSS_PFII_I_metadata_line_18_____AVIAKOR_20211101 >									
203 	//        < HcC1irGy70i0kX941j211Q3CQ9pckk48TsOw3pn5Nq7YnGAd4C88yS2PTmk5OP20 >									
204 	//        <  u =="0.000000000000000001" : ] 000000259926816.820273000000000000 ; 000000274940977.108065000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000018C9DEA1A386D2 >									
206 	//     < RUSS_PFII_I_metadata_line_19_____SOCHI_AIRPORT_20211101 >									
207 	//        < 84YpHEE821Z5oMWJPp444LF861Z6V9hUUS4OAZ6Njt8F7pLGoqjmmn4h9mym256j >									
208 	//        <  u =="0.000000000000000001" : ] 000000274940977.108065000000000000 ; 000000291626927.375832000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000001A386D21BCFCC5 >									
210 	//     < RUSS_PFII_I_metadata_line_20_____KRASNODAR_AIRPORT_20211101 >									
211 	//        < 0lo3g76tuauj8Vi758BUTz99ta2jx47N1Wn6OZs935z11kKfQ2CJVf46X2Do1KqQ >									
212 	//        <  u =="0.000000000000000001" : ] 000000291626927.375832000000000000 ; 000000307307067.201196000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000001BCFCC51D4E9D3 >									
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
256 	//     < RUSS_PFII_I_metadata_line_21_____ANAPA_AIRPORT_20211101 >									
257 	//        < YOw5Nl2FbepoE6eV5w22x2dzTcnOC0Uat3fr625z186LO96t5z64zwKF7WcPMWw4 >									
258 	//        <  u =="0.000000000000000001" : ] 000000307307067.201196000000000000 ; 000000324116923.689032000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000001D4E9D31EE902C >									
260 	//     < RUSS_PFII_I_metadata_line_22_____GLAVMOSSTROY_20211101 >									
261 	//        < BrSC6UIG52uPfn0z52e0RCx89hlw3k158u7syr7lczgiygzsF7JuU6xr24PN7is6 >									
262 	//        <  u =="0.000000000000000001" : ] 000000324116923.689032000000000000 ; 000000338204089.463682000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000001EE902C2040EF9 >									
264 	//     < RUSS_PFII_I_metadata_line_23_____TRANSSTROY_20211101 >									
265 	//        < 7Z0oeUL3MqSmEkps72NqWB764tE7F0A92XgdaBs5r31iAcc9d27jD3NX8S59qQ6u >									
266 	//        <  u =="0.000000000000000001" : ] 000000338204089.463682000000000000 ; 000000353006114.624762000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000002040EF921AA503 >									
268 	//     < RUSS_PFII_I_metadata_line_24_____GLAVSTROY_20211101 >									
269 	//        < 5CQk3X8Xq9O9i60zW3qUxpA2mbn2A97CzzX1vT77FN9aBRjjoowQhj8R8s6W2xhD >									
270 	//        <  u =="0.000000000000000001" : ] 000000353006114.624762000000000000 ; 000000368836133.419768000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000021AA503232CC9D >									
272 	//     < RUSS_PFII_I_metadata_line_25_____GLAVSTROY_SPB_20211101 >									
273 	//        < PF55yqHQXr4R12XIqxu6Jq3Esp35n10X1Kls2bfQh3i7hTbQ9jn56z92x030AmmW >									
274 	//        <  u =="0.000000000000000001" : ] 000000368836133.419768000000000000 ; 000000382664314.614058000000000000 ] >									
275 	//        < 0x00000000000000000000000000000000000000000000000000232CC9D247E63F >									
276 	//     < RUSS_PFII_I_metadata_line_26_____ROGSIBAL_20211101 >									
277 	//        < AdXv06Fp03HAXS9F2720kZ05rT3dx84Z9gp5ElXB29PJAr1wRff29mSs62pzUIPR >									
278 	//        <  u =="0.000000000000000001" : ] 000000382664314.614058000000000000 ; 000000397668457.107775000000000000 ] >									
279 	//        < 0x00000000000000000000000000000000000000000000000000247E63F25ECB3E >									
280 	//     < RUSS_PFII_I_metadata_line_27_____BASEL_CEMENT_20211101 >									
281 	//        < jrR87205f9WHMQzGnfw57miJ7grHYb1k17Xf0EIKIr5z5c5fS7u4XWAz9Bk7T4On >									
282 	//        <  u =="0.000000000000000001" : ] 000000397668457.107775000000000000 ; 000000411502966.431664000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000025ECB3E273E759 >									
284 	//     < RUSS_PFII_I_metadata_line_28_____KUBAN_AGROHOLDING_20211101 >									
285 	//        < Nv66l62jDG768ge8x409yXrMAFbDLhIZ0TzMxdwmq74MytaP253V5VFnar639a25 >									
286 	//        <  u =="0.000000000000000001" : ] 000000411502966.431664000000000000 ; 000000425722674.237141000000000000 ] >									
287 	//        < 0x00000000000000000000000000000000000000000000000000273E75928999EB >									
288 	//     < RUSS_PFII_I_metadata_line_29_____AQUADIN_20211101 >									
289 	//        < 926yMCo9ucMC0eI62v5F7644S3KCtk1Tuxhv5XLOGKOg5QQ2J263UwESm26GU2bV >									
290 	//        <  u =="0.000000000000000001" : ] 000000425722674.237141000000000000 ; 000000441597142.003958000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000028999EB2A1D2E2 >									
292 	//     < RUSS_PFII_I_metadata_line_30_____VASKHOD_STUD_FARM_20211101 >									
293 	//        < J8WNwJ1s0krr9JFvi4RKYOE5gRz3W3rg0hi0hbpS02I3r9ItI856jVwT5n4Z69f8 >									
294 	//        <  u =="0.000000000000000001" : ] 000000441597142.003958000000000000 ; 000000455922651.352335000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000002A1D2E22B7AEC9 >									
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
338 	//     < RUSS_PFII_I_metadata_line_31_____IMERETINSKY_PORT_20211101 >									
339 	//        < qr8FC1rcw3rFN230611vuY4PZi5xY012xn0R664xR9atl6vxkFk4iIlW67s5740D >									
340 	//        <  u =="0.000000000000000001" : ] 000000455922651.352335000000000000 ; 000000472179541.710434000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000002B7AEC92D07D22 >									
342 	//     < RUSS_PFII_I_metadata_line_32_____BASEL_REAL_ESTATE_20211101 >									
343 	//        < 7smUpg6sRBv4L68cqvV6Kt1qoVGX7dNTb8ftZ5x1Fl1k0EdL1873YuNGuxu453oe >									
344 	//        <  u =="0.000000000000000001" : ] 000000472179541.710434000000000000 ; 000000487916490.334400000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000002D07D222E88061 >									
346 	//     < RUSS_PFII_I_metadata_line_33_____UZHURALZOLOTO_20211101 >									
347 	//        < LtoR8AJd2U8Q48B04mRgkRViDk63yq50s1zg81gePDOt8u4zrk2I0EJ8f8Nr9rm3 >									
348 	//        <  u =="0.000000000000000001" : ] 000000487916490.334400000000000000 ; 000000502942343.486384000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000002E880612FF6DDA >									
350 	//     < RUSS_PFII_I_metadata_line_34_____NORILSK_NICKEL_20211101 >									
351 	//        < UqmyMQCFe0I48YlQBn1KQc1p79QbSo42jxBs0e7nCL9jh1lAHg3J0IIojcd51smO >									
352 	//        <  u =="0.000000000000000001" : ] 000000502942343.486384000000000000 ; 000000517897736.140637000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000002FF6DDA3163FCE >									
354 	//     < RUSS_PFII_I_metadata_line_35_____RUSHYDRO_20211101 >									
355 	//        < 2Y2fOD0IVYI75pEbHW4ce20TN3Hy990D76961v38ro1MSf1C3nBeYrdK4uY63rqh >									
356 	//        <  u =="0.000000000000000001" : ] 000000517897736.140637000000000000 ; 000000532380064.861306000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000003163FCE32C58F6 >									
358 	//     < RUSS_PFII_I_metadata_line_36_____INTER_RAO_20211101 >									
359 	//        < 459p7fiv94XDhM2X6Kz4HsG444lDf4vLfWxinAUW8N5bK6JQg0hFRWD8NF5UWU80 >									
360 	//        <  u =="0.000000000000000001" : ] 000000532380064.861306000000000000 ; 000000547801430.414180000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000032C58F6343E0EF >									
362 	//     < RUSS_PFII_I_metadata_line_37_____LUKOIL_20211101 >									
363 	//        < rgZ3zy4Xzb3DB2WCUrULe92jLpc91v7J0TigaZ513of451b2xxv5aO2fvlArP6eu >									
364 	//        <  u =="0.000000000000000001" : ] 000000547801430.414180000000000000 ; 000000563220607.670890000000000000 ] >									
365 	//        < 0x00000000000000000000000000000000000000000000000000343E0EF35B680D >									
366 	//     < RUSS_PFII_I_metadata_line_38_____MAGNITOGORSK_ISW_20211101 >									
367 	//        < V1aOlXiEUaZF73H38pT53mir6KJRq4LawH0bKV03sCmk62qT4I9kuj588YpMtx90 >									
368 	//        <  u =="0.000000000000000001" : ] 000000563220607.670890000000000000 ; 000000578204708.304968000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000035B680D3724537 >									
370 	//     < RUSS_PFII_I_metadata_line_39_____MAGNIT_20211101 >									
371 	//        < nTB3nZ6qwkRd58hNNZ96t7yTWGBvs2OO0a6aAsAO0582vfF5KN9Tai0P5Hb0J9j3 >									
372 	//        <  u =="0.000000000000000001" : ] 000000578204708.304968000000000000 ; 000000592808786.037059000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000037245373888DEF >									
374 	//     < RUSS_PFII_I_metadata_line_40_____IDGC_20211101 >									
375 	//        < QfI4PgmCY2wp9r6K28x9nq3P2ZkANNDFv0b6V084z8N8M8pr5nI4sA009552c171 >									
376 	//        <  u =="0.000000000000000001" : ] 000000592808786.037059000000000000 ; 000000607574543.126106000000000000 ] >									
377 	//        < 0x000000000000000000000000000000000000000000000000003888DEF39F15CE >									
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