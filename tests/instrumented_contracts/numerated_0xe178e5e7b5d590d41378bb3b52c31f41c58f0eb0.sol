1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXXIX_II_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXXIX_II_883		"	;
8 		string	public		symbol =	"	RUSS_PFXXIX_II_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		782267825938682000000000000					;	
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
92 	//     < RUSS_PFXXIX_II_metadata_line_1_____INGOSSTRAKH_ORG_20231101 >									
93 	//        < t0N3cqw6Lefjs8AA3LOS34lJbB9Cu0nP1Ej3b942QOyVbIdu18JOet3nkJI7k06A >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000017506807.124516100000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000001AB699 >									
96 	//     < RUSS_PFXXIX_II_metadata_line_2_____INGO_gbp_20231101 >									
97 	//        < Q9JiXO5hP5L6nJV23pOi13IlDm1yGOPzwUqe384N5nM2867cx31tdR4ttjf61dOx >									
98 	//        <  u =="0.000000000000000001" : ] 000000017506807.124516100000000000 ; 000000037533338.597393300000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000001AB699394576 >									
100 	//     < RUSS_PFXXIX_II_metadata_line_3_____INGO_usd_20231101 >									
101 	//        < UGSTJ5M8vEs7Fe5CoDpV29PORF62Xfx4EZU73M4XLf23A59Mn02aMf538E4Aqu82 >									
102 	//        <  u =="0.000000000000000001" : ] 000000037533338.597393300000000000 ; 000000055062769.629000000000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000003945765404E5 >									
104 	//     < RUSS_PFXXIX_II_metadata_line_4_____INGO_chf_20231101 >									
105 	//        < wnrI36dcjgV5GrZqA0hW7tw949pS775mddUg714eA3qmZF6kAccGim0k1Z0Nfl4H >									
106 	//        <  u =="0.000000000000000001" : ] 000000055062769.629000000000000000 ; 000000074344014.861770600000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000005404E57170A1 >									
108 	//     < RUSS_PFXXIX_II_metadata_line_5_____INGO_eur_20231101 >									
109 	//        < cuV6607dNdS03Gg8fhv89424EWmo4NR1ks09ZDOIEb71l1KQxL0V3F2WHa3TUS5l >									
110 	//        <  u =="0.000000000000000001" : ] 000000074344014.861770600000000000 ; 000000091387790.074334300000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000007170A18B725B >									
112 	//     < RUSS_PFXXIX_II_metadata_line_6_____SIBAL_ORG_20231101 >									
113 	//        < 0avj1k9s7MUVQ2ZCr11s9gWP6OV365C4Y0m8FGu31A35PpZ9E896AV99KjJ03qSk >									
114 	//        <  u =="0.000000000000000001" : ] 000000091387790.074334300000000000 ; 000000109215622.131519000000000000 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000000000008B725BA6A65A >									
116 	//     < RUSS_PFXXIX_II_metadata_line_7_____SIBAL_DAO_20231101 >									
117 	//        < Z34xhvHQ1PGss2Ch0OzAg189D3c2lTSPKljtlAbrnAq9qoH2hau0q81lCo0A8JD8 >									
118 	//        <  u =="0.000000000000000001" : ] 000000109215622.131519000000000000 ; 000000128300468.157142000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000A6A65AC3C55F >									
120 	//     < RUSS_PFXXIX_II_metadata_line_8_____SIBAL_DAOPI_20231101 >									
121 	//        < 8QVHqTzPNzthp46JrsrEaCQd0v4IHbOCdz8T02QwiNlLH2c2TkLtZH34lx6sc9fv >									
122 	//        <  u =="0.000000000000000001" : ] 000000128300468.157142000000000000 ; 000000147400699.541261000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000C3C55FE0EA66 >									
124 	//     < RUSS_PFXXIX_II_metadata_line_9_____SIBAL_DAC_20231101 >									
125 	//        < aSmwF4vjvZRJ4n9w0ie4I9ZkQwD5Pb2Fw3NnYJxBM2qfT3e2Sj0jxMmtKDGMLahX >									
126 	//        <  u =="0.000000000000000001" : ] 000000147400699.541261000000000000 ; 000000171412035.488932000000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000000E0EA661058DD4 >									
128 	//     < RUSS_PFXXIX_II_metadata_line_10_____SIBAL_BIMI_20231101 >									
129 	//        < mEyTfOqPs8q0ZtuGvIq3ANRqaqWsMd5C4LPHS1x6x14Et4990lvDje7m7DNh1g8K >									
130 	//        <  u =="0.000000000000000001" : ] 000000171412035.488932000000000000 ; 000000190149219.698355000000000000 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000000001058DD4122250A >									
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
174 	//     < RUSS_PFXXIX_II_metadata_line_11_____INGO_ARMENIA_20231101 >									
175 	//        < QDV1Xv58pg8HB8lE4wvyAa3v015dga7j48ZJs9YN110cRCRNl9hO7Nha9svrEelG >									
176 	//        <  u =="0.000000000000000001" : ] 000000190149219.698355000000000000 ; 000000214562638.407983000000000000 ] >									
177 	//        < 0x00000000000000000000000000000000000000000000000000122250A1476588 >									
178 	//     < RUSS_PFXXIX_II_metadata_line_12_____INGO_INSURANCE_COMPANY_20231101 >									
179 	//        < 8FDgt5HnWhn92HI6g05ru5b9E4LW0wJkkt51YW55H26KJywhZsJ3YPZi99E3c0fI >									
180 	//        <  u =="0.000000000000000001" : ] 000000214562638.407983000000000000 ; 000000231658747.350237000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000014765881617BB3 >									
182 	//     < RUSS_PFXXIX_II_metadata_line_13_____ONDD_CREDIT_INSURANCE_20231101 >									
183 	//        < 0f516LRxMfxhRF119d5LJ7m4sm6Sht3n4FhJ3h80c3vR7y36cFyNx7eou3Sa10qG >									
184 	//        <  u =="0.000000000000000001" : ] 000000231658747.350237000000000000 ; 000000248144164.867947000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001617BB317AA350 >									
186 	//     < RUSS_PFXXIX_II_metadata_line_14_____BANK_SOYUZ_INGO_20231101 >									
187 	//        < 1hr0mmCOau7oui0e809NaNk6TKv14E25FbpJ28RnzbEXL5ZiZgonvB4OYJtZuKc8 >									
188 	//        <  u =="0.000000000000000001" : ] 000000248144164.867947000000000000 ; 000000270265285.247087000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000017AA35019C6461 >									
190 	//     < RUSS_PFXXIX_II_metadata_line_15_____CHREZVYCHAJNAYA_STRAKHOVAYA_KOMP_20231101 >									
191 	//        < s6EKgwv2y9S3qCO054D371sr6WGK7kI2Fn15Uo7fmeHrzYdVFnHHf5874T7Ipk8u >									
192 	//        <  u =="0.000000000000000001" : ] 000000270265285.247087000000000000 ; 000000286290243.021838000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000019C64611B4D820 >									
194 	//     < RUSS_PFXXIX_II_metadata_line_16_____ONDD_ORG_20231101 >									
195 	//        < H9XFd7b8242Z730L3X1Q6D7R0h1EHM66RaipXWu7lI81Ygr6kN2C423d55cX8aCT >									
196 	//        <  u =="0.000000000000000001" : ] 000000286290243.021838000000000000 ; 000000303525473.833681000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000001B4D8201CF24A3 >									
198 	//     < RUSS_PFXXIX_II_metadata_line_17_____ONDD_DAO_20231101 >									
199 	//        < Xr3Z9v2XYDyXeMLW4swx36Zn12ulSmEYdio4uTNABz237011ge91o3Xi392Do1fb >									
200 	//        <  u =="0.000000000000000001" : ] 000000303525473.833681000000000000 ; 000000327568839.408535000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000001CF24A31F3D494 >									
202 	//     < RUSS_PFXXIX_II_metadata_line_18_____ONDD_DAOPI_20231101 >									
203 	//        < D708Q0XWuSvld4b5JCB3YsaB4845B485ewJFM6U6j7W7gFQkXmXm414VTBZw9IfD >									
204 	//        <  u =="0.000000000000000001" : ] 000000327568839.408535000000000000 ; 000000344079007.805216000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000001F3D49420D05DD >									
206 	//     < RUSS_PFXXIX_II_metadata_line_19_____ONDD_DAC_20231101 >									
207 	//        < ILX6nCDqn3dnxXM6TAeu1Q7d5twc6zl4CHBZiO4g98Igo0jycS9epPiPh5XyT5MZ >									
208 	//        <  u =="0.000000000000000001" : ] 000000344079007.805216000000000000 ; 000000360415039.521968000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000000020D05DD225F320 >									
210 	//     < RUSS_PFXXIX_II_metadata_line_20_____ONDD_BIMI_20231101 >									
211 	//        < 4q0Jy7eC23rJl0XKxJfd4AtZK5dk8cDB43n33Qd9CRKu9G1DTf3movr0A7snGsqd >									
212 	//        <  u =="0.000000000000000001" : ] 000000360415039.521968000000000000 ; 000000380687681.509945000000000000 ] >									
213 	//        < 0x00000000000000000000000000000000000000000000000000225F320244E220 >									
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
256 	//     < RUSS_PFXXIX_II_metadata_line_21_____SOYUZ_ORG_20231101 >									
257 	//        < cU30sf16t7Wgz4nJWhbs66qiYV6ez2I3x355WE3lZ747Yd2lLjv3y4R9TBqBJn4S >									
258 	//        <  u =="0.000000000000000001" : ] 000000380687681.509945000000000000 ; 000000399822126.341626000000000000 ] >									
259 	//        < 0x00000000000000000000000000000000000000000000000000244E2202621485 >									
260 	//     < RUSS_PFXXIX_II_metadata_line_22_____SOYUZ_DAO_20231101 >									
261 	//        < c4rH3G597oM7s6WlPcpanrRahW3lyS7v1EEA31Qb2Cq041WR1h80jMnXL05Y1qcI >									
262 	//        <  u =="0.000000000000000001" : ] 000000399822126.341626000000000000 ; 000000423498460.143981000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000026214852863516 >									
264 	//     < RUSS_PFXXIX_II_metadata_line_23_____SOYUZ_DAOPI_20231101 >									
265 	//        < vC6J2gKJMw0at4UOCthFYXrWOZc52o52g658L4HiKDcW4D607WPKSUFz8Nd93O3k >									
266 	//        <  u =="0.000000000000000001" : ] 000000423498460.143981000000000000 ; 000000440933648.429810000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000028635162A0CFB5 >									
268 	//     < RUSS_PFXXIX_II_metadata_line_24_____SOYUZ_DAC_20231101 >									
269 	//        < gbProkq184gf4kxqs21EvNi823y97mOPN8pa8DJ383RLirtTz48p12F2rC846e6f >									
270 	//        <  u =="0.000000000000000001" : ] 000000440933648.429810000000000000 ; 000000462108218.615891000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000002A0CFB52C11F06 >									
272 	//     < RUSS_PFXXIX_II_metadata_line_25_____SOYUZ_BIMI_20231101 >									
273 	//        < 2c5HozP0035HpT1C8As7Ut4SJN6qP37jy0g1R5Z64T5NZQmZ36589az02NtgWGmJ >									
274 	//        <  u =="0.000000000000000001" : ] 000000462108218.615891000000000000 ; 000000480944202.041773000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002C11F062DDDCD4 >									
276 	//     < RUSS_PFXXIX_II_metadata_line_26_____PIFAGOR_AM_20231101 >									
277 	//        < GW03p1B0du0K9t9RoZtoeQfQw8ELnE5zqEFXi7eDT82dS1GJiP4OY9DMzEV47062 >									
278 	//        <  u =="0.000000000000000001" : ] 000000480944202.041773000000000000 ; 000000499670397.495828000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000002DDDCD42FA6FC0 >									
280 	//     < RUSS_PFXXIX_II_metadata_line_27_____SK_INGO_LMT_20231101 >									
281 	//        < IKMf8a32PclrK0T173Z9p3e6l4OKBm5T2u2h0Qh23ROc7621ce1wcE0tgHQ0n8O2 >									
282 	//        <  u =="0.000000000000000001" : ] 000000499670397.495828000000000000 ; 000000520859290.415336000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000002FA6FC031AC4A9 >									
284 	//     < RUSS_PFXXIX_II_metadata_line_28_____AKVAMARIN_20231101 >									
285 	//        < i9VUR3R79QK20mYnGZV1a0T2OP922am7f6W1FM7PPP1m99336KOzF9w3T3o22XY2 >									
286 	//        <  u =="0.000000000000000001" : ] 000000520859290.415336000000000000 ; 000000540928407.798900000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000031AC4A93396429 >									
288 	//     < RUSS_PFXXIX_II_metadata_line_29_____INVEST_POLIS_20231101 >									
289 	//        < ccS1m3rZ657U04WZoRj5oDyz9SW4ewPkhv0Rl02RsbD6ZV77e1h6wlTxq8ypbyR3 >									
290 	//        <  u =="0.000000000000000001" : ] 000000540928407.798900000000000000 ; 000000560375429.247088000000000000 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000000000339642935710A7 >									
292 	//     < RUSS_PFXXIX_II_metadata_line_30_____INGOSSTRAKH_LIFE_INSURANCE_CO_20231101 >									
293 	//        < N10ZiZjtzW4Mpx41H4bRe48r45l0wrTSkj1jI6Tjm8zfZ6c833v781TfsjW8XA22 >									
294 	//        <  u =="0.000000000000000001" : ] 000000560375429.247088000000000000 ; 000000581932213.090491000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000035710A7377F545 >									
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
338 	//     < RUSS_PFXXIX_II_metadata_line_31_____SIBAL_gbp_20231101 >									
339 	//        < 0ejjf8qkg16NknIYd7N54C2Hc0KH6iLtdyG7bV9TM3U4796bNT3C56pNPHhj18LX >									
340 	//        <  u =="0.000000000000000001" : ] 000000581932213.090491000000000000 ; 000000603900391.690201000000000000 ] >									
341 	//        < 0x00000000000000000000000000000000000000000000000000377F5453997A97 >									
342 	//     < RUSS_PFXXIX_II_metadata_line_32_____SIBAL_PENSII_20231101 >									
343 	//        < 7d1WRUk57u9Z1uPSX065T3uJ9E38cT86o7E5MU131fw1F2jKl75L7IgxuDOOJ6nz >									
344 	//        <  u =="0.000000000000000001" : ] 000000603900391.690201000000000000 ; 000000622392177.290188000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000003997A973B5B1F2 >									
346 	//     < RUSS_PFXXIX_II_metadata_line_33_____SOYUZ_gbp_20231101 >									
347 	//        < 1NvwlNt4zCZRwU79bwf9539jYpYMXD7Ezw5vCP14L74gp5f6tsYDy27nqm4OMR7F >									
348 	//        <  u =="0.000000000000000001" : ] 000000622392177.290188000000000000 ; 000000640286797.646426000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000003B5B1F23D10008 >									
350 	//     < RUSS_PFXXIX_II_metadata_line_34_____SOYUZ_PENSII_20231101 >									
351 	//        < 2582Mq40y99KFq7UBRzONhgww6dD245piD264790vW0k19hapKS4O5n661t380o2 >									
352 	//        <  u =="0.000000000000000001" : ] 000000640286797.646426000000000000 ; 000000661337025.619083000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000003D100083F11EC7 >									
354 	//     < RUSS_PFXXIX_II_metadata_line_35_____PIFAGOR_gbp_20231101 >									
355 	//        < 72Es5q10l06eDV9tM2H6eXNp5WR8xZ7H196E68UKwj23cJ3akzFtDgOw5D33hK80 >									
356 	//        <  u =="0.000000000000000001" : ] 000000661337025.619083000000000000 ; 000000679496302.771914000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000003F11EC740CD43E >									
358 	//     < RUSS_PFXXIX_II_metadata_line_36_____PIFAGOR_PENSII_20231101 >									
359 	//        < NpR5u2bQq3hwmWa7s6r8346kcCgWj820U0xU5i9VhmE5EW27Tazz3w5yBvWO9bJ8 >									
360 	//        <  u =="0.000000000000000001" : ] 000000679496302.771914000000000000 ; 000000699168201.221526000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000040CD43E42AD894 >									
362 	//     < RUSS_PFXXIX_II_metadata_line_37_____AKVAMARIN_gbp_20231101 >									
363 	//        < 7xMf6lk64XWIn07367R2pjt029BDmy2Kb93F71S20oNa0sAgk54O0nn0x0c1y9uZ >									
364 	//        <  u =="0.000000000000000001" : ] 000000699168201.221526000000000000 ; 000000718588698.015494000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000042AD8944487AB6 >									
366 	//     < RUSS_PFXXIX_II_metadata_line_38_____AKVAMARIN_PENSII_20231101 >									
367 	//        < 1ipu3A94775kjFR8w51FjVfN2FhgS3wvY81s972Y043Xbf008870k90IugC52W07 >									
368 	//        <  u =="0.000000000000000001" : ] 000000718588698.015494000000000000 ; 000000738192335.736993000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000004487AB64666462 >									
370 	//     < RUSS_PFXXIX_II_metadata_line_39_____POLIS_gbp_20231101 >									
371 	//        < R22056MVArzx8vV49Q567a3i2Ynbv5nzAIfD16cI37gbq25l8HN5xt41l4gH5oav >									
372 	//        <  u =="0.000000000000000001" : ] 000000738192335.736993000000000000 ; 000000758731138.832714000000000000 ] >									
373 	//        < 0x000000000000000000000000000000000000000000000000004666462485BB5A >									
374 	//     < RUSS_PFXXIX_II_metadata_line_40_____POLIS_PENSII_20231101 >									
375 	//        < 07c0w5z5h96B9gj0vU4l6x0O5VRc724i13e70X1i8ChHqk2KAoa7nq1T8ahUbLnd >									
376 	//        <  u =="0.000000000000000001" : ] 000000758731138.832714000000000000 ; 000000782267825.938682000000000000 ] >									
377 	//        < 0x00000000000000000000000000000000000000000000000000485BB5A4A9A55F >									
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