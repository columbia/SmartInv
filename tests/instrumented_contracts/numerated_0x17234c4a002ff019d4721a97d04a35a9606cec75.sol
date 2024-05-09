1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXXXI_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXXXI_III_883		"	;
8 		string	public		symbol =	"	RUSS_PFXXXI_III_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1064147230230680000000000000					;	
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
92 	//     < RUSS_PFXXXI_III_metadata_line_1_____MEGAFON_20251101 >									
93 	//        < mLQJo5evhTve7yNnx1C2nlBm8aP3shjbcu8pTe6FC42xXW4kWeMICmp29tOKie3o >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000024621740.134977200000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000002591DE >									
96 	//     < RUSS_PFXXXI_III_metadata_line_2_____EUROSET_20251101 >									
97 	//        < 4tvZiZSYTuleQpvO5x4wAYmfSbCyYVA4C0H4WijMouuX4YhsHq9b546JU57F19Va >									
98 	//        <  u =="0.000000000000000001" : ] 000000024621740.134977200000000000 ; 000000054004562.896780700000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000002591DE526788 >									
100 	//     < RUSS_PFXXXI_III_metadata_line_3_____OSTELECOM_20251101 >									
101 	//        < hbKDW4zAdmO4onmQ16ae1cxuW300ggY1FnGxA52lO1Y5vQ44O3Ohus50V3jOICnO >									
102 	//        <  u =="0.000000000000000001" : ] 000000054004562.896780700000000000 ; 000000086855715.031473200000000000 ] >									
103 	//        < 0x0000000000000000000000000000000000000000000000000000526788848804 >									
104 	//     < RUSS_PFXXXI_III_metadata_line_4_____GARS_TELECOM_20251101 >									
105 	//        < oE2wjTGyFJZEut89V4mh5oLMAN3BPjF7lxEYX6x811y0fMQTr24Jk1fj82ni42R3 >									
106 	//        <  u =="0.000000000000000001" : ] 000000086855715.031473200000000000 ; 000000118348350.425549000000000000 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000000000848804B495D3 >									
108 	//     < RUSS_PFXXXI_III_metadata_line_5_____MEGAFON_INVESTMENT_CYPRUS_LIMITED_20251101 >									
109 	//        < H2P4FF3t9pDv723V19NH6IOvZ9F8LHsThpqWj8q5wR6x0bXckzX2q5JDPpur900r >									
110 	//        <  u =="0.000000000000000001" : ] 000000118348350.425549000000000000 ; 000000147597295.658691000000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000B495D3E13732 >									
112 	//     < RUSS_PFXXXI_III_metadata_line_6_____YOTA_20251101 >									
113 	//        < jmWaXGDn7ijc31h8FY95s5zNi5GO17BV492ebQ4A9or30140f0rKr0mq99YhW95R >									
114 	//        <  u =="0.000000000000000001" : ] 000000147597295.658691000000000000 ; 000000166029047.042928000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000E13732FD5719 >									
116 	//     < RUSS_PFXXXI_III_metadata_line_7_____YOTA_DAO_20251101 >									
117 	//        < 6nCG4my1u9hIhn2XJppX13rO8v9CAlUIzdij590BxtImS8t8a9uuJgmARhlK8T8g >									
118 	//        <  u =="0.000000000000000001" : ] 000000166029047.042928000000000000 ; 000000187997789.588179000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000000FD571911EDCA3 >									
120 	//     < RUSS_PFXXXI_III_metadata_line_8_____YOTA_DAOPI_20251101 >									
121 	//        < Qkvyv80r7aoA7NOFYrC056e526y6Bt2azz1MkbJ41N5749id0X92T9q2iaKFcJ2T >									
122 	//        <  u =="0.000000000000000001" : ] 000000187997789.588179000000000000 ; 000000220465800.806494000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000011EDCA31506774 >									
124 	//     < RUSS_PFXXXI_III_metadata_line_9_____YOTA_DAC_20251101 >									
125 	//        < 7nQ423E9gX8j9265230149IG6mIlhJeu70o29kXbVMK5TpgjV6D924os2B7SUC2A >									
126 	//        <  u =="0.000000000000000001" : ] 000000220465800.806494000000000000 ; 000000239831260.100111000000000000 ] >									
127 	//        < 0x00000000000000000000000000000000000000000000000000150677416DF416 >									
128 	//     < RUSS_PFXXXI_III_metadata_line_10_____YOTA_BIMI_20251101 >									
129 	//        < iyA8mguC4f592fztS3AHjO161SccPwhG8ZWYRM934CrH3640y77tLYtBJQZqNrA1 >									
130 	//        <  u =="0.000000000000000001" : ] 000000239831260.100111000000000000 ; 000000259643912.739484000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000016DF41618C2F67 >									
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
174 	//     < RUSS_PFXXXI_III_metadata_line_11_____KAVKAZ_20251101 >									
175 	//        < R49sb9zLm7rTh48119VaShZi8eS3XG2KmMcwu0Oq8VPeEe4eB45Hq7kuiPI1JMg9 >									
176 	//        <  u =="0.000000000000000001" : ] 000000259643912.739484000000000000 ; 000000284078803.542672000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000018C2F671B17848 >									
178 	//     < RUSS_PFXXXI_III_metadata_line_12_____KAVKAZ_KZT_20251101 >									
179 	//        < K551xNIfVx5XmDa7W80Su96D5quJusOGHIISFpq2AhF52mLf1z8595Gk0sTv52KG >									
180 	//        <  u =="0.000000000000000001" : ] 000000284078803.542672000000000000 ; 000000304768665.547643000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000001B178481D10A43 >									
182 	//     < RUSS_PFXXXI_III_metadata_line_13_____KAVKAZ_CHF_20251101 >									
183 	//        < 32Cm9tZN98NjorPgXaQ2lRh52EhbLgnxr4CTqfkpr0UcrDjuMzmKLn7Y1VRG77WT >									
184 	//        <  u =="0.000000000000000001" : ] 000000304768665.547643000000000000 ; 000000335590205.344696000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001D10A4320011ED >									
186 	//     < RUSS_PFXXXI_III_metadata_line_14_____KAVKAZ_USD_20251101 >									
187 	//        < z7g67zutk3WJVwwnL6Il5dFJD9o6QN5bKW720TGUA9YA0C14RyeXeP6onUU5hHvK >									
188 	//        <  u =="0.000000000000000001" : ] 000000335590205.344696000000000000 ; 000000355331777.128289000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000020011ED21E317A >									
190 	//     < RUSS_PFXXXI_III_metadata_line_15_____PETERSTAR_20251101 >									
191 	//        < LnZ84z2VX3oA2769g7QD16t080q0J96a9xeKAS3pblnNK7R33468Za1K6IvC5oY1 >									
192 	//        <  u =="0.000000000000000001" : ] 000000355331777.128289000000000000 ; 000000390935923.346225000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000021E317A2548558 >									
194 	//     < RUSS_PFXXXI_III_metadata_line_16_____MEGAFON_FINANCE_LLC_20251101 >									
195 	//        < 9Z9D94HfaIwZaTR8YLpTaj94Uc35KGOW6T0Phx1jG3L8VK5uNSjCWg25Aw3zhsl1 >									
196 	//        <  u =="0.000000000000000001" : ] 000000390935923.346225000000000000 ; 000000419613996.126049000000000000 ] >									
197 	//        < 0x00000000000000000000000000000000000000000000000000254855828047B8 >									
198 	//     < RUSS_PFXXXI_III_metadata_line_17_____LEFBORD_INVESTMENTS_LIMITED_20251101 >									
199 	//        < P0Ue3LC1kKJ8Vl926O1OZ5wXtZ42dagtOf5bNZw53OWu3CEco6C8YbNbdhZ85HZj >									
200 	//        <  u =="0.000000000000000001" : ] 000000419613996.126049000000000000 ; 000000441082738.153009000000000000 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000000028047B82A109F2 >									
202 	//     < RUSS_PFXXXI_III_metadata_line_18_____TT_MOBILE_20251101 >									
203 	//        < g9BTndOalfeS0A277maU7p9KIWbri444oTD3n1gH188vE7PPqgiQ4in5279ghqFd >									
204 	//        <  u =="0.000000000000000001" : ] 000000441082738.153009000000000000 ; 000000475643982.485799000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000002A109F22D5C66E >									
206 	//     < RUSS_PFXXXI_III_metadata_line_19_____SMARTS_SAMARA_20251101 >									
207 	//        < f7Q0yRwF5hfE7ymTOd0uRgAxmd9r09IGx9h4mk68lk0D9Pbul8HT3U95045I778t >									
208 	//        <  u =="0.000000000000000001" : ] 000000475643982.485799000000000000 ; 000000497081417.877395000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000002D5C66E2F67C6E >									
210 	//     < RUSS_PFXXXI_III_metadata_line_20_____MEGAFON_NORTH_WEST_20251101 >									
211 	//        < F1b4tV6aH9tKCK3EVF11IpADXYSfqJkqR9FS7pp3M4zB25j6QW4HlhN7Ds2v04yD >									
212 	//        <  u =="0.000000000000000001" : ] 000000497081417.877395000000000000 ; 000000524872524.577966000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000002F67C6E320E454 >									
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
256 	//     < RUSS_PFXXXI_III_metadata_line_21_____GARS_HOLDING_LIMITED_20251101 >									
257 	//        < j2zmDz7KP2Za476xV9XXL645q0h76q0kffN8c7Sh33Uk1cwD5091PH9W54Jg5xFt >									
258 	//        <  u =="0.000000000000000001" : ] 000000524872524.577966000000000000 ; 000000546785702.257845000000000000 ] >									
259 	//        < 0x00000000000000000000000000000000000000000000000000320E454342542A >									
260 	//     < RUSS_PFXXXI_III_metadata_line_22_____SMARTS_CHEBOKSARY_20251101 >									
261 	//        < 7H0niee078ZtzSw7rG6p6pKQ5OVZoyC5Xly5z1qB2yFJtJHCq7zM2232wMahhiAx >									
262 	//        <  u =="0.000000000000000001" : ] 000000546785702.257845000000000000 ; 000000567826091.335569000000000000 ] >									
263 	//        < 0x00000000000000000000000000000000000000000000000000342542A3626F11 >									
264 	//     < RUSS_PFXXXI_III_metadata_line_23_____MEGAFON_ORG_20251101 >									
265 	//        < M1J9KowYU5MWWGFkF0kif8VVuPHF724EJs0SI82BAIGak2JFC63RDdvAuGaTL115 >									
266 	//        <  u =="0.000000000000000001" : ] 000000567826091.335569000000000000 ; 000000597359335.158389000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000003626F1138F7F7E >									
268 	//     < RUSS_PFXXXI_III_metadata_line_24_____NAKHODKA_TELECOM_20251101 >									
269 	//        < 2kYk899LQik6IwsL1l91YBOG5um8ywD2SYG65wpKr97zUj6dJWIUgy1GqR100EWn >									
270 	//        <  u =="0.000000000000000001" : ] 000000597359335.158389000000000000 ; 000000623777473.093808000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000038F7F7E3B7CF13 >									
272 	//     < RUSS_PFXXXI_III_metadata_line_25_____NEOSPRINT_20251101 >									
273 	//        < yZT6344tJPTqk9OocSI9u0wZuVa5pvLtj89H30LzgoMe37T3dARi83b8I7zRAb4L >									
274 	//        <  u =="0.000000000000000001" : ] 000000623777473.093808000000000000 ; 000000648919708.188235000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000003B7CF133DE2C43 >									
276 	//     < RUSS_PFXXXI_III_metadata_line_26_____SMARTS_PENZA_20251101 >									
277 	//        < U8s8981pQ8au6LwDUYcrX1jLrI10D5M80OpJWV8P2vu04GH48oOV87kS0qnaTrGu >									
278 	//        <  u =="0.000000000000000001" : ] 000000648919708.188235000000000000 ; 000000668657107.183544000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000003DE2C433FC4A2F >									
280 	//     < RUSS_PFXXXI_III_metadata_line_27_____MEGAFON_RETAIL_20251101 >									
281 	//        < kv8fyuJhvlOr0X96AD67zlZkd67ER6o4sT2b244ZckAZPMp73Gmpbg4Ej6kn80mV >									
282 	//        <  u =="0.000000000000000001" : ] 000000668657107.183544000000000000 ; 000000696627872.593231000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000003FC4A2F426F843 >									
284 	//     < RUSS_PFXXXI_III_metadata_line_28_____FIRST_TOWER_COMPANY_20251101 >									
285 	//        < 3J1TeTN9LVXG3z07EZUD105RGmSvKcQCuRxmZzKvhdTCl0KSe8JpiZzlqEs4nJ0t >									
286 	//        <  u =="0.000000000000000001" : ] 000000696627872.593231000000000000 ; 000000717928922.062344000000000000 ] >									
287 	//        < 0x00000000000000000000000000000000000000000000000000426F84344778FC >									
288 	//     < RUSS_PFXXXI_III_metadata_line_29_____MEGAFON_SA_20251101 >									
289 	//        < 2LJpTQ3t1S974dUrGrWnsa9JwC2iQ91ml2TkkGTY0ma8HVfE050ld5rq3o41L661 >									
290 	//        <  u =="0.000000000000000001" : ] 000000717928922.062344000000000000 ; 000000750944356.171165000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000044778FC479D9A4 >									
292 	//     < RUSS_PFXXXI_III_metadata_line_30_____MOBICOM_KHABAROVSK_20251101 >									
293 	//        < h16xJvwn182ABlM5ub1MwZhVduo007bfWJW48jeJtIi22H3362Zg1m1MfU860LO7 >									
294 	//        <  u =="0.000000000000000001" : ] 000000750944356.171165000000000000 ; 000000771928896.347809000000000000 ] >									
295 	//        < 0x00000000000000000000000000000000000000000000000000479D9A4499DEBA >									
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
338 	//     < RUSS_PFXXXI_III_metadata_line_31_____AQUAFON_GSM_20251101 >									
339 	//        < 3ZUB5S2tm4j1M6T7JN2My7LCCV3ifTM7c7o2UDCQ5gf6VYSE30BWw1H10TVQhe4e >									
340 	//        <  u =="0.000000000000000001" : ] 000000771928896.347809000000000000 ; 000000796450857.461330000000000000 ] >									
341 	//        < 0x00000000000000000000000000000000000000000000000000499DEBA4BF499E >									
342 	//     < RUSS_PFXXXI_III_metadata_line_32_____DIGITAL_BUSINESS_SOLUTIONS_20251101 >									
343 	//        < BD1455fIYF30L5i1CYxVc0W93fM2c71Cf0IxX9q107018Y28QFe1wURzCVJ3zN21 >									
344 	//        <  u =="0.000000000000000001" : ] 000000796450857.461330000000000000 ; 000000828768163.393180000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000004BF499E4F09990 >									
346 	//     < RUSS_PFXXXI_III_metadata_line_33_____KOMBELL_OOO_20251101 >									
347 	//        < 779cOVLV1FfSu5u8Fkqz8GEckD3t1Gf4yrNTiWahJJ05SAU891P190V8w3yKMj4P >									
348 	//        <  u =="0.000000000000000001" : ] 000000828768163.393180000000000000 ; 000000855951947.487877000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000004F0999051A143B >									
350 	//     < RUSS_PFXXXI_III_metadata_line_34_____URALSKI_GSM_ZAO_20251101 >									
351 	//        < 899p3Pc7n1u4kpxA7rvm6z38G7sZsDj0R5hBIA49kWYE975GHTKeP8MJVZ95U58Q >									
352 	//        <  u =="0.000000000000000001" : ] 000000855951947.487877000000000000 ; 000000878940449.750962000000000000 ] >									
353 	//        < 0x0000000000000000000000000000000000000000000000000051A143B53D281D >									
354 	//     < RUSS_PFXXXI_III_metadata_line_35_____INCORE_20251101 >									
355 	//        < m196szyPi3crjrjKyyeNasfzSwvq629X7lziUUL958okyAS69d6ONYtP75dsm9GO >									
356 	//        <  u =="0.000000000000000001" : ] 000000878940449.750962000000000000 ; 000000911440573.540710000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000053D281D56EBF79 >									
358 	//     < RUSS_PFXXXI_III_metadata_line_36_____MEGALABS_20251101 >									
359 	//        < 3m5485m702OW5fre1w9S36h99b6Y1QVBeVwQEc9v3S1pr5J4y5PuKGne5lX0Ja3o >									
360 	//        <  u =="0.000000000000000001" : ] 000000911440573.540710000000000000 ; 000000946002371.111112000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000056EBF795A37C2D >									
362 	//     < RUSS_PFXXXI_III_metadata_line_37_____AQUAPHONE_GSM_20251101 >									
363 	//        < 3BL5OA288Rxe69RTn3aGl5ihrJwgaGz8U2Ex8ue9xDG6PMMqK7T7tsCuVo627pSP >									
364 	//        <  u =="0.000000000000000001" : ] 000000946002371.111112000000000000 ; 000000976860747.499742000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000005A37C2D5D2923B >									
366 	//     < RUSS_PFXXXI_III_metadata_line_38_____TC_COMET_20251101 >									
367 	//        < L0TtNijUgu85rP2d018nrG8wU245TwVrOh3FzURP2u4D9RsW77lJ2JtC4CQb3vE8 >									
368 	//        <  u =="0.000000000000000001" : ] 000000976860747.499742000000000000 ; 000001002617616.090640000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000005D2923B5F9DF82 >									
370 	//     < RUSS_PFXXXI_III_metadata_line_39_____DEBTON_INVESTMENTS_LIMITED_20251101 >									
371 	//        < DPTO6t8vAW9Tt73LB2P79sFNRS6hEF5z6XqkURs5cS1f0k1D9aSiyoBLh66Y3BL1 >									
372 	//        <  u =="0.000000000000000001" : ] 000001002617616.090640000000000000 ; 000001029622448.382140000000000000 ] >									
373 	//        < 0x000000000000000000000000000000000000000000000000005F9DF826231445 >									
374 	//     < RUSS_PFXXXI_III_metadata_line_40_____NETBYNET_HOLDING_20251101 >									
375 	//        < a16fpXn0603u7pwP18qhF26qbwJ1M6Yc8b8x6zx2KMPzYFJuJGJEKb7mxDLH22ll >									
376 	//        <  u =="0.000000000000000001" : ] 000001029622448.382140000000000000 ; 000001064147230.230680000000000000 ] >									
377 	//        < 0x000000000000000000000000000000000000000000000000006231445657C283 >									
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