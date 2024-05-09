1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXXV_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXXV_III_883		"	;
8 		string	public		symbol =	"	RUSS_PFXXV_III_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1067985630555170000000000000					;	
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
92 	//     < RUSS_PFXXV_III_metadata_line_1_____GAZPROM_20251101 >									
93 	//        < MIj70sVA0Dq1J9l7AzJSMkc2csC9YtNDpTpMWqn93591CFBcI273pEp7eX2O9jYs >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000019162790.696707700000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000001D3D77 >									
96 	//     < RUSS_PFXXV_III_metadata_line_2_____PROM_DAO_20251101 >									
97 	//        < KwigY9RX50xA4h9AuQwh4Yt5Y51cR0V191oZtAN92Fit7J5MD94o57MjjU2Cl04t >									
98 	//        <  u =="0.000000000000000001" : ] 000000019162790.696707700000000000 ; 000000050450110.990550600000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000001D3D774CFB13 >									
100 	//     < RUSS_PFXXV_III_metadata_line_3_____PROM_DAOPI_20251101 >									
101 	//        < kRL1tWQ51V3rdGwUy5VYXhyY9qlYaCal377H82xZAJCZFss2gBJ2xs012jw4Lnk4 >									
102 	//        <  u =="0.000000000000000001" : ] 000000050450110.990550600000000000 ; 000000071788982.834694400000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000004CFB136D8A92 >									
104 	//     < RUSS_PFXXV_III_metadata_line_4_____PROM_DAC_20251101 >									
105 	//        < q8UT4Tu9YyYW1f7m8g48rkwMo7X9i23D2mi72ng6Wq710YQ7680Obi1Pbum7R8R2 >									
106 	//        <  u =="0.000000000000000001" : ] 000000071788982.834694400000000000 ; 000000095908732.588568500000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000006D8A92925859 >									
108 	//     < RUSS_PFXXV_III_metadata_line_5_____PROM_BIMI_20251101 >									
109 	//        < 3qxarp216N4amXk3ceGQr40vR9x16cLxnDbOW008pN2fwekIXo0E1yLx973SvLf1 >									
110 	//        <  u =="0.000000000000000001" : ] 000000095908732.588568500000000000 ; 000000123695204.878770000000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000925859BCBE70 >									
112 	//     < RUSS_PFXXV_III_metadata_line_6_____GAZPROMNEFT_20251101 >									
113 	//        < C0kz3xzDsX0MPZd7HoiiOzE86GVqxbzK6ZRbtqFtkDf2Z5iM0OR5ArKK0wi2Z858 >									
114 	//        <  u =="0.000000000000000001" : ] 000000123695204.878770000000000000 ; 000000158460238.263226000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000BCBE70F1CA88 >									
116 	//     < RUSS_PFXXV_III_metadata_line_7_____GAZPROMBANK_BD_20251101 >									
117 	//        < xk4reRAG18l20X7qPQ85102ukPwLFFew9F76KLAhRR5rHvbJpq50996Kp61gdBao >									
118 	//        <  u =="0.000000000000000001" : ] 000000158460238.263226000000000000 ; 000000192985755.071795000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000000F1CA881267910 >									
120 	//     < RUSS_PFXXV_III_metadata_line_8_____MEZHEREGIONGAZ_20251101 >									
121 	//        < 442s8HMF05tg8AjOo8g7RD4niIBVcIrem0O40LtM7mL8xoum4zUn7SUL0g6j67Vl >									
122 	//        <  u =="0.000000000000000001" : ] 000000192985755.071795000000000000 ; 000000227777085.119975000000000000 ] >									
123 	//        < 0x00000000000000000000000000000000000000000000000000126791015B8F6D >									
124 	//     < RUSS_PFXXV_III_metadata_line_9_____SALAVATNEFTEORGSINTEZ_20251101 >									
125 	//        < DWdxjHAqw82EP2tQd3vExQ5Lt5MO5C29UqtcolFLd1WP4fuKu9EK7Na017Ln6zZl >									
126 	//        <  u =="0.000000000000000001" : ] 000000227777085.119975000000000000 ; 000000254558161.885468000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000015B8F6D1846CC8 >									
128 	//     < RUSS_PFXXV_III_metadata_line_10_____SAKHALIN_ENERGY_20251101 >									
129 	//        < 4QCKz9B0rtrhuv6Ri1tS9Q6Frsq0TSIn7F1p471Wo6rjKT5d243g9nEd5tO0993F >									
130 	//        <  u =="0.000000000000000001" : ] 000000254558161.885468000000000000 ; 000000289258629.255044000000000000 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000000001846CC81B95FA7 >									
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
174 	//     < RUSS_PFXXV_III_metadata_line_11_____NORDSTREAM_AG_20251101 >									
175 	//        < 9zcBpP5z067nyj1F1178Cnq0u92Q5vhCaF5H30eW7ucnR2u3422GI9s9l57k6RNX >									
176 	//        <  u =="0.000000000000000001" : ] 000000289258629.255044000000000000 ; 000000322034140.170393000000000000 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000000001B95FA71EB6296 >									
178 	//     < RUSS_PFXXV_III_metadata_line_12_____NORDSTREAM_DAO_20251101 >									
179 	//        < 7zA7T41t0UnA1K2qSFc3lhN8oVtcJz0I6s173480KD8hn9022R1Np22BrbmXTN66 >									
180 	//        <  u =="0.000000000000000001" : ] 000000322034140.170393000000000000 ; 000000355109451.141612000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000001EB629621DDAA1 >									
182 	//     < RUSS_PFXXV_III_metadata_line_13_____NORDSTREAM_DAOPI_20251101 >									
183 	//        < ImA1jMl9H13OQAUn20561M6DP04NEEMC6zk4lJ25j50NIbJ7jHqqQq4hU0Xh7j00 >									
184 	//        <  u =="0.000000000000000001" : ] 000000355109451.141612000000000000 ; 000000387198076.259448000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000021DDAA124ED140 >									
186 	//     < RUSS_PFXXV_III_metadata_line_14_____NORDSTREAM_DAC_20251101 >									
187 	//        < 486qM10F33eV8uR33xhvM47T43HtVcn3TR6lDlawm7KtPlr6y2K3m376H9UdXp0t >									
188 	//        <  u =="0.000000000000000001" : ] 000000387198076.259448000000000000 ; 000000415029252.739705000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000024ED14027948CD >									
190 	//     < RUSS_PFXXV_III_metadata_line_15_____NORDSTREAM_BIMI_20251101 >									
191 	//        < 29d773v26V5NH694ePlO4e08cQk4P905MvWKd3tk3thlJXJxvOX4x1M0erG26LLu >									
192 	//        <  u =="0.000000000000000001" : ] 000000415029252.739705000000000000 ; 000000435461862.886281000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000027948CD298764A >									
194 	//     < RUSS_PFXXV_III_metadata_line_16_____GASCAP_ORG_20251101 >									
195 	//        < KPbcBNws73O0EOP7s1a155ojY8Gp34MMO4SpK7MLBX0Cpw75irzFEhtn6U4vl4Rk >									
196 	//        <  u =="0.000000000000000001" : ] 000000435461862.886281000000000000 ; 000000466424474.047841000000000000 ] >									
197 	//        < 0x00000000000000000000000000000000000000000000000000298764A2C7B50F >									
198 	//     < RUSS_PFXXV_III_metadata_line_17_____GASCAP_DAO_20251101 >									
199 	//        < UH89tVx0QYyr0a7QpO35UQZ0Wb3sZ5WjG5oZSy5037f93K79hCbDQi5S0prMT0MV >									
200 	//        <  u =="0.000000000000000001" : ] 000000466424474.047841000000000000 ; 000000488685368.023583000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000002C7B50F2E9ACB9 >									
202 	//     < RUSS_PFXXV_III_metadata_line_18_____GASCAP_DAOPI_20251101 >									
203 	//        < r13G6R6TVOqsGOh7883SazZ5f22iTF70x0Vq9dwcln40fyyM129yLVj4KcHQvOec >									
204 	//        <  u =="0.000000000000000001" : ] 000000488685368.023583000000000000 ; 000000515179598.830706000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000002E9ACB93121A08 >									
206 	//     < RUSS_PFXXV_III_metadata_line_19_____GASCAP_DAC_20251101 >									
207 	//        < VlrL7owb28J96c826d205UrCM741uJTfBj25V38ogoDRzblEi724njFo1DISf1fg >									
208 	//        <  u =="0.000000000000000001" : ] 000000515179598.830706000000000000 ; 000000539103872.670177000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000003121A083369B73 >									
210 	//     < RUSS_PFXXV_III_metadata_line_20_____GASCAP_BIMI_20251101 >									
211 	//        < ATFS5yq8zI5LBrd7u3Mec2g2NF2bcV5AJNliyYIK2IvfE34h9w8Undh0s1Jb06fn >									
212 	//        <  u =="0.000000000000000001" : ] 000000539103872.670177000000000000 ; 000000558326304.359721000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000003369B73353F036 >									
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
256 	//     < RUSS_PFXXV_III_metadata_line_21_____GAZ_CAPITAL_SA_20251101 >									
257 	//        < W8ULNbkOZjM83VFBlZuWo34H5rIH8fxIIG2fBW1Wms58A0QlHfpdW9ikXkZ65z28 >									
258 	//        <  u =="0.000000000000000001" : ] 000000558326304.359721000000000000 ; 000000593473052.417507000000000000 ] >									
259 	//        < 0x00000000000000000000000000000000000000000000000000353F0363899169 >									
260 	//     < RUSS_PFXXV_III_metadata_line_22_____BELTRANSGAZ_20251101 >									
261 	//        < XG3HtJ9qr93AZ219ku0Rm3yPQiH573o74Zme8R8n91t3Y6020R6rw86a7XG54Yb7 >									
262 	//        <  u =="0.000000000000000001" : ] 000000593473052.417507000000000000 ; 000000623421281.803526000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000038991693B743F0 >									
264 	//     < RUSS_PFXXV_III_metadata_line_23_____OVERGAS_20251101 >									
265 	//        < bo267DLUz0K88947V563wNTcI4QQ84SEn7f0CH46tf5S6Nd6mE48axW07ae70710 >									
266 	//        <  u =="0.000000000000000001" : ] 000000623421281.803526000000000000 ; 000000654925146.478292000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000003B743F03E75623 >									
268 	//     < RUSS_PFXXV_III_metadata_line_24_____GAZPROM_MARKETING_TRADING_20251101 >									
269 	//        < 6Y8K89O8Rd6yW5EVy37O7sY8W9Lmxri52S50kkh8r2o2p8u7M2f6ypn6Bp4855PE >									
270 	//        <  u =="0.000000000000000001" : ] 000000654925146.478292000000000000 ; 000000674137314.570937000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000003E75623404A6E3 >									
272 	//     < RUSS_PFXXV_III_metadata_line_25_____ROSUKRENERGO_20251101 >									
273 	//        < 878rBmEjSJx565PykivbmB1UR6uWMVp2c297r9piq1S8HkduNl80ndvp1G1sxWtW >									
274 	//        <  u =="0.000000000000000001" : ] 000000674137314.570937000000000000 ; 000000698627208.812908000000000000 ] >									
275 	//        < 0x00000000000000000000000000000000000000000000000000404A6E342A0541 >									
276 	//     < RUSS_PFXXV_III_metadata_line_26_____TRANSGAZ_VOLGORAD_20251101 >									
277 	//        < B6118V594ygHH2zg0kbE8s3N76x781T4l6Vjcxj724a18K6myw6vF67Fe3i7CGEd >									
278 	//        <  u =="0.000000000000000001" : ] 000000698627208.812908000000000000 ; 000000726217720.097880000000000000 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000000000042A05414541ECC >									
280 	//     < RUSS_PFXXV_III_metadata_line_27_____SPACE_SYSTEMS_20251101 >									
281 	//        < v8HBLF6t0r4VXS827qqWR1eR5Krd2Zz0Dh1WoR353IIsfbXg99tKfZ70UKDMJYf5 >									
282 	//        <  u =="0.000000000000000001" : ] 000000726217720.097880000000000000 ; 000000753544020.590338000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000004541ECC47DD122 >									
284 	//     < RUSS_PFXXV_III_metadata_line_28_____MOLDOVAGAZ_20251101 >									
285 	//        < BB65ga6T2bg2Z08Ze80ti1KRPFcHn5S9ZP2M05M52Po7a4TCUG76DTMN6j69mtFT >									
286 	//        <  u =="0.000000000000000001" : ] 000000753544020.590338000000000000 ; 000000774356241.027675000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000047DD12249D92E8 >									
288 	//     < RUSS_PFXXV_III_metadata_line_29_____VOSTOKGAZPROM_20251101 >									
289 	//        < o4876jIx3v0xcw2tzd0VdbE9M7ivxMe97tJayE536G1M23PGp4cuX6S0SV4chTaF >									
290 	//        <  u =="0.000000000000000001" : ] 000000774356241.027675000000000000 ; 000000794170701.232528000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000049D92E84BBCEEE >									
292 	//     < RUSS_PFXXV_III_metadata_line_30_____GAZPROM_UK_20251101 >									
293 	//        < 0H08IXJh6UsMWc93a9Io3i8L3r4i5PR9CL69qG4C5E0qC038642uHL7uhbSYh52r >									
294 	//        <  u =="0.000000000000000001" : ] 000000794170701.232528000000000000 ; 000000817638491.263247000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000004BBCEEE4DF9E09 >									
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
338 	//     < RUSS_PFXXV_III_metadata_line_31_____SOUTHSTREAM_AG_20251101 >									
339 	//        < e9qAVg1s2DbbhOneVgD2OE8A0b5RvOB86pY8p6UWToqw4DC9TtC5eaoesaZxMNo3 >									
340 	//        <  u =="0.000000000000000001" : ] 000000817638491.263247000000000000 ; 000000849067020.861433000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000004DF9E0950F92CE >									
342 	//     < RUSS_PFXXV_III_metadata_line_32_____SOUTHSTREAM_DAO_20251101 >									
343 	//        < SW5IpR2t023Y96C87ek8m04L1M86Qa487F4V2zH38Y2hVNemhOklMPl9a69RrM0I >									
344 	//        <  u =="0.000000000000000001" : ] 000000849067020.861433000000000000 ; 000000868650895.952162000000000000 ] >									
345 	//        < 0x0000000000000000000000000000000000000000000000000050F92CE52D74C2 >									
346 	//     < RUSS_PFXXV_III_metadata_line_33_____SOUTHSTREAM_DAOPI_20251101 >									
347 	//        < fvRde12436Grk3A6O2BC2229OLi0J027YCYRD65nWxgl61CjN3szyJeC80cafj4W >									
348 	//        <  u =="0.000000000000000001" : ] 000000868650895.952162000000000000 ; 000000898279388.762022000000000000 ] >									
349 	//        < 0x0000000000000000000000000000000000000000000000000052D74C255AAA63 >									
350 	//     < RUSS_PFXXV_III_metadata_line_34_____SOUTHSTREAM_DAC_20251101 >									
351 	//        < G3iOpFVpWtOzNgBg12X7tJ8jV01jQn70eZ6t93LuaCj4nw75wf1r2SQCR94FRtN2 >									
352 	//        <  u =="0.000000000000000001" : ] 000000898279388.762022000000000000 ; 000000918859969.714199000000000000 ] >									
353 	//        < 0x0000000000000000000000000000000000000000000000000055AAA6357A11AD >									
354 	//     < RUSS_PFXXV_III_metadata_line_35_____SOUTHSTREAM_BIMI_20251101 >									
355 	//        < llTfSuXVAGTWb99HY21aL4vC6mE85biuc34pC0qDL3OnqMr6h06CzNPfT4PSH6K5 >									
356 	//        <  u =="0.000000000000000001" : ] 000000918859969.714199000000000000 ; 000000942885996.034889000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000057A11AD59EBAD8 >									
358 	//     < RUSS_PFXXV_III_metadata_line_36_____GAZPROM_ARMENIA_20251101 >									
359 	//        < 9864Aj0X72w2FK64C3e5r7Vn75aA2D7c4P7b2H7o9oX6lOW9Am7yyXsPVbBwiH18 >									
360 	//        <  u =="0.000000000000000001" : ] 000000942885996.034889000000000000 ; 000000965960552.660323000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000059EBAD85C1F057 >									
362 	//     < RUSS_PFXXV_III_metadata_line_37_____CHORNOMORNAFTOGAZ_20251101 >									
363 	//        < VZuf66JAwq44gp02ulzfnOY3t70hYvu8fWoT4NUdt1SyewpC8sfQq7OJCsB4RFif >									
364 	//        <  u =="0.000000000000000001" : ] 000000965960552.660323000000000000 ; 000000985875277.316508000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000005C1F0575E05388 >									
366 	//     < RUSS_PFXXV_III_metadata_line_38_____SHTOKMAN_DEV_AG_20251101 >									
367 	//        < Iz8T16B0025m0VtV5SP37Om3y6pSKjoQ1kREY9DwWpxgbMEjmU3rHSzqD6Z2L7Bu >									
368 	//        <  u =="0.000000000000000001" : ] 000000985875277.316508000000000000 ; 000001019377494.145290000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000005E053886137255 >									
370 	//     < RUSS_PFXXV_III_metadata_line_39_____VEMEX_20251101 >									
371 	//        < f4EpuEVeb6971R2J8Dr59hQe2667Qbqgshnb49hOX0sMC8V3Dj8z00vu8w1OYTER >									
372 	//        <  u =="0.000000000000000001" : ] 000001019377494.145290000000000000 ; 000001038868933.945070000000000000 ] >									
373 	//        < 0x000000000000000000000000000000000000000000000000006137255631302D >									
374 	//     < RUSS_PFXXV_III_metadata_line_40_____BOSPHORUS_GAZ_20251101 >									
375 	//        < TI3czO682c9WAoPHX203Ld447zv1ykNpN5I192ibtb331WDwtM3E37kqyY4HaJ5G >									
376 	//        <  u =="0.000000000000000001" : ] 000001038868933.945070000000000000 ; 000001067985630.555170000000000000 ] >									
377 	//        < 0x00000000000000000000000000000000000000000000000000631302D65D9DE3 >									
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