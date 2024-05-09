1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	DUBAI_Portfolio_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	DUBAI_Portfolio_I_883		"	;
8 		string	public		symbol =	"	DUBAI883I		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		728002043355369000000000000					;	
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
92 	//     < DUBAI_Portfolio_I_metadata_line_1_____AJMAN_BANK_20250515 >									
93 	//        < hU1zJfAXIWjwRzQjUIScl4o8bq7axH6HuBDtiGTA019b7oj61f5kl4696PW83S71 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000015884741.083761000000000000 ] >									
95 	//        < 0x0000000000000000000000000000000000000000000000000000000000183CFA >									
96 	//     < DUBAI_Portfolio_I_metadata_line_2_____AL_SALAM_BANK_SUDAN_20250515 >									
97 	//        < 17aFYFQ9CA4SOK0902m34ul7ucv4VLQA7cAR72zAxTdG265k7AnJ5mep6RUfDuBJ >									
98 	//        <  u =="0.000000000000000001" : ] 000000015884741.083761000000000000 ; 000000032229705.695558200000000000 ] >									
99 	//        < 0x0000000000000000000000000000000000000000000000000000183CFA312DBB >									
100 	//     < DUBAI_Portfolio_I_metadata_line_3_____Amlak_Finance_20250515 >									
101 	//        < V83Tsv22iNFkOrBA3D5U7jIA6cJKFb2e1qMTHct8247Wh5x6Y2t3wL8CjA5fQQdR >									
102 	//        <  u =="0.000000000000000001" : ] 000000032229705.695558200000000000 ; 000000049089220.940360200000000000 ] >									
103 	//        < 0x0000000000000000000000000000000000000000000000000000312DBB4AE77A >									
104 	//     < DUBAI_Portfolio_I_metadata_line_4_____Commercial_Bank_Dubai_20250515 >									
105 	//        < qUju69Sx8gMl6OkjbtMkUItcls3LKlv685Dfa6ulBiQciq6U16poLhbAC3gZ611Y >									
106 	//        <  u =="0.000000000000000001" : ] 000000049089220.940360200000000000 ; 000000068091782.527806200000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000004AE77A67E65A >									
108 	//     < DUBAI_Portfolio_I_metadata_line_5_____Dubai_Islamic_Bank_20250515 >									
109 	//        < C7KoV79oZ8H6SAQEo25AofOM0UL4Wn90au54EN7gqZ49lB6Zm1ry6a6c2AE4ZONG >									
110 	//        <  u =="0.000000000000000001" : ] 000000068091782.527806200000000000 ; 000000087470978.004263900000000000 ] >									
111 	//        < 0x000000000000000000000000000000000000000000000000000067E65A85785A >									
112 	//     < DUBAI_Portfolio_I_metadata_line_6_____Emirates_Islamic_Bank_20250515 >									
113 	//        < 7rN94JK4sOb7NGC86JU49Xuh7En2gss8bD2J45V1KsuZeEf4iU1cCCbsWgv3GhmH >									
114 	//        <  u =="0.000000000000000001" : ] 000000087470978.004263900000000000 ; 000000106997977.181169000000000000 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000000000085785AA34416 >									
116 	//     < DUBAI_Portfolio_I_metadata_line_7_____Emirates_Investment_Bank_20250515 >									
117 	//        < Jgp0QI6C7OKSGJ8Z6N1fmQ2Z9Vse0rP274ezlcf0Aw4r9xPLxdBsWlq50Ev9p5hl >									
118 	//        <  u =="0.000000000000000001" : ] 000000106997977.181169000000000000 ; 000000128630093.592656000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000A34416C44621 >									
120 	//     < DUBAI_Portfolio_I_metadata_line_8_____Emirates_NBD_20250515 >									
121 	//        < dc0Y668z2toyy6N8eT2QhKGmjh3P9YALc88654xY56D1mTvAY1y6SDKxZpbb3CNi >									
122 	//        <  u =="0.000000000000000001" : ] 000000128630093.592656000000000000 ; 000000148482651.177864000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000C44621E29109 >									
124 	//     < DUBAI_Portfolio_I_metadata_line_9_____Gulf_Finance_House_BSC_20250515 >									
125 	//        < NV9L14h25w61rSg9X9zQDFwy3e7gOu6msP2r2949VmDhJ61fzo9ggNu70wgodwgJ >									
126 	//        <  u =="0.000000000000000001" : ] 000000148482651.177864000000000000 ; 000000166024168.285934000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000000E29109FD5531 >									
128 	//     < DUBAI_Portfolio_I_metadata_line_10_____Mashreqbank_20250515 >									
129 	//        < b1qf4nM067k5B0WSoo7wshTv2h1grIOR8ra5A8xKb8ba8Ftoo4uO5zO5bcG5BH3Z >									
130 	//        <  u =="0.000000000000000001" : ] 000000166024168.285934000000000000 ; 000000181090929.627096000000000000 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000000000FD553111452A5 >									
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
174 	//     < DUBAI_Portfolio_I_metadata_line_11_____Al_Salam_Bank_Bahrain_20250515 >									
175 	//        < 9qcbUt0742le3FI3SDqDZc281rNM6nRV9Tgn6uOyNz9mP1sOm7U6mdHY1s42dUSd >									
176 	//        <  u =="0.000000000000000001" : ] 000000181090929.627096000000000000 ; 000000201064086.828041000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000011452A5132CCA9 >									
178 	//     < DUBAI_Portfolio_I_metadata_line_12_____Almadina_Finance_Investment_20250515 >									
179 	//        < 3H6E0f64Nrl2wS84a41EU74v4M6e50Mm8O3KhW9zKMWtQVfVXlbaH0ZD02uiY3qj >									
180 	//        <  u =="0.000000000000000001" : ] 000000201064086.828041000000000000 ; 000000219910587.516598000000000000 ] >									
181 	//        < 0x00000000000000000000000000000000000000000000000000132CCA914F8E93 >									
182 	//     < DUBAI_Portfolio_I_metadata_line_13_____Al_Salam_Group_Holding_20250515 >									
183 	//        < 11T8O4S7kL062mgfNaHVj1Jul8Aep7d6pgFGRfoH7H8zq2MBzk503lJ7JTpp4pgT >									
184 	//        <  u =="0.000000000000000001" : ] 000000219910587.516598000000000000 ; 000000236706596.542813000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000014F8E931692F84 >									
186 	//     < DUBAI_Portfolio_I_metadata_line_14_____Dubai_Financial_Market_20250515 >									
187 	//        < uAFlkA36REFbTmSIiAdy3506KdOr51okG3tGVZjDm0r8PawduO933AFNYY1c9wn2 >									
188 	//        <  u =="0.000000000000000001" : ] 000000236706596.542813000000000000 ; 000000254619021.069807000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000001692F84184848E >									
190 	//     < DUBAI_Portfolio_I_metadata_line_15_____Dubai_Investments_20250515 >									
191 	//        < 6j92OsXVYJ1l6U92UvJgrT5085Km60aNuDmNrGUo2wmJ2fGzzodsd0R1lKLYd95o >									
192 	//        <  u =="0.000000000000000001" : ] 000000254619021.069807000000000000 ; 000000273019373.496874000000000000 ] >									
193 	//        < 0x00000000000000000000000000000000000000000000000000184848E1A09831 >									
194 	//     < DUBAI_Portfolio_I_metadata_line_16_____Ekttitab_Holding_Company_KSCC_20250515 >									
195 	//        < K8Uz43p03ZRnsM1I1El5l3FOWnAU2UL50ofgWD9Evb1cen5H0cUmLc39dX9rj026 >									
196 	//        <  u =="0.000000000000000001" : ] 000000273019373.496874000000000000 ; 000000289417875.000936000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000001A098311B99DDC >									
198 	//     < DUBAI_Portfolio_I_metadata_line_17_____Gulf_General_Investments_Company_20250515 >									
199 	//        < lzt1mh1llK1Q9o9vqKWGwq40eMl57QjE92hs9V143a0GSW1E05C48hBvXeShZe6J >									
200 	//        <  u =="0.000000000000000001" : ] 000000289417875.000936000000000000 ; 000000307179615.891649000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000001B99DDC1D4B80A >									
202 	//     < DUBAI_Portfolio_I_metadata_line_18_____International_Financial_Advisors_KSCC_20250515 >									
203 	//        < tP1j5nLD1kSaQT5q80bu54TH699s4Jlr9oVDz6Y283K7MoY9P3q048QfAUBot3sJ >									
204 	//        <  u =="0.000000000000000001" : ] 000000307179615.891649000000000000 ; 000000323823077.061058000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000001D4B80A1EE1D64 >									
206 	//     < DUBAI_Portfolio_I_metadata_line_19_____SHUAA_Capital_20250515 >									
207 	//        < S5toJup3HvP9lOX9U8vDvbI52NVjMFj8ZBaZ0fb4v48CxvsikOWQ7gFR8jozIFU1 >									
208 	//        <  u =="0.000000000000000001" : ] 000000323823077.061058000000000000 ; 000000340399977.520851000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000001EE1D6420768BE >									
210 	//     < DUBAI_Portfolio_I_metadata_line_20_____Alliance_Insurance_20250515 >									
211 	//        < 16tFUCxP9z56o56qEP4d9DpOo12O5v43dOuDdZOIF9y2DV2wz12EYSRRSac0yD4u >									
212 	//        <  u =="0.000000000000000001" : ] 000000340399977.520851000000000000 ; 000000357401143.902088000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000020768BE22159D2 >									
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
256 	//     < DUBAI_Portfolio_I_metadata_line_21_____Dubai_Islamic_Insurance_Reinsurance_Co_20250515 >									
257 	//        < Ni1yj387aR192u9HPN00pvqzg4enG5LZ0oNst39961slyNHKscdK470agBRt3iCM >									
258 	//        <  u =="0.000000000000000001" : ] 000000357401143.902088000000000000 ; 000000375154906.591838000000000000 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000000022159D223C70E3 >									
260 	//     < DUBAI_Portfolio_I_metadata_line_22_____Arab_Insurance_Group_20250515 >									
261 	//        < Bv985pP18xveBi1B932C9wtp2WoN0gNU5nM7x84lXw956S7X7U3t9BLCtjWzyExF >									
262 	//        <  u =="0.000000000000000001" : ] 000000375154906.591838000000000000 ; 000000392325538.991759000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000023C70E3256A42A >									
264 	//     < DUBAI_Portfolio_I_metadata_line_23_____Arabian_Scandinavian_Insurance_20250515 >									
265 	//        < qR6ygvkxcKIMgf1nv2OjY5443PwX398dMscw07K17J9df3j7D7EAnTV52b7af8P4 >									
266 	//        <  u =="0.000000000000000001" : ] 000000392325538.991759000000000000 ; 000000408068775.109931000000000000 ] >									
267 	//        < 0x00000000000000000000000000000000000000000000000000256A42A26EA9DE >									
268 	//     < DUBAI_Portfolio_I_metadata_line_24_____Al_Sagr_National_Insurance_Company_20250515 >									
269 	//        < n2wn10DZWnFK7x51f67xoOH08Q9oP7jChMEeM6LUa7ScseH8zv9xFuZAQ5Z5H3p8 >									
270 	//        <  u =="0.000000000000000001" : ] 000000408068775.109931000000000000 ; 000000427466309.604087000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000026EA9DE28C4307 >									
272 	//     < DUBAI_Portfolio_I_metadata_line_25_____Takaful_House_20250515 >									
273 	//        < 6IGcy1yy61hb6zPZa15c18ZM7eYHFe4xR9ZKoL3779fl3qHmF3n113kPgI5DCf7X >									
274 	//        <  u =="0.000000000000000001" : ] 000000427466309.604087000000000000 ; 000000446074474.416661000000000000 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000000000028C43072A8A7D7 >									
276 	//     < DUBAI_Portfolio_I_metadata_line_26_____Dubai_Insurance_Co_20250515 >									
277 	//        < 119X5jFvluZlpeZbBncK0LlpeL5gzbVpU1W7Y0LS8IH91FrG91vQ8ylH1Yb8oD8K >									
278 	//        <  u =="0.000000000000000001" : ] 000000446074474.416661000000000000 ; 000000467318875.367803000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000002A8A7D72C91270 >									
280 	//     < DUBAI_Portfolio_I_metadata_line_27_____Dubai_National_Insurance_Reinsurance_20250515 >									
281 	//        < QS08Q002ksrpV138t16vm9PPqjP685d2uV6qI37ubxd9C04ZCU59pVJ1724VWRd0 >									
282 	//        <  u =="0.000000000000000001" : ] 000000467318875.367803000000000000 ; 000000487222689.531227000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000002C912702E7715D >									
284 	//     < DUBAI_Portfolio_I_metadata_line_28_____National_General_Insurance_Company_20250515 >									
285 	//        < Zd7z6d719i7nP8Ojfi5Hv9MG4yNDDuT5J92k2oCR6ApxRj5gX9vj0X686KLG91uG >									
286 	//        <  u =="0.000000000000000001" : ] 000000487222689.531227000000000000 ; 000000505364361.034325000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000002E7715D3031FF4 >									
288 	//     < DUBAI_Portfolio_I_metadata_line_29_____Oman_Insurance_Company_20250515 >									
289 	//        < JAjRd29ZC9NJdJs2BAybBuwjK9S5Sl8R84ZLN7TG5T00GAPc70iu52Ch9f4FN1gc >									
290 	//        <  u =="0.000000000000000001" : ] 000000505364361.034325000000000000 ; 000000527065625.946488000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000003031FF43243D03 >									
292 	//     < DUBAI_Portfolio_I_metadata_line_30_____ORIENT_Insurance_20250515 >									
293 	//        < 3rm72307dFqy6I9rsdy9v2D64Jsc2YN8NY1kiEqw1aqSCW9AXUx8R47iaxK2y4pP >									
294 	//        <  u =="0.000000000000000001" : ] 000000527065625.946488000000000000 ; 000000547998796.510605000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000003243D033442E08 >									
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
338 	//     < DUBAI_Portfolio_I_metadata_line_31_____Islamic_Arab_Insurance_Company_20250515 >									
339 	//        < R87R6f1o3Ao0dMab8CRn1x667z1y32Al3735wQIW8ob6GRn8ZwgTt436F91hkkrS >									
340 	//        <  u =="0.000000000000000001" : ] 000000547998796.510605000000000000 ; 000000566661310.057538000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000003442E08360A813 >									
342 	//     < DUBAI_Portfolio_I_metadata_line_32_____Takaful_Emarat_20250515 >									
343 	//        < 20Q0BmypqM20e2D7tAvz0me07Dd088s5Lhrt45dvA5miuAkV7ZZZF4ER03Q6Yg6I >									
344 	//        <  u =="0.000000000000000001" : ] 000000566661310.057538000000000000 ; 000000583724083.698779000000000000 ] >									
345 	//        < 0x00000000000000000000000000000000000000000000000000360A81337AB138 >									
346 	//     < DUBAI_Portfolio_I_metadata_line_33_____Arabtec_Holding_20250515 >									
347 	//        < 6mx3P53haYX3py1lC65ju35E6TuSEj96O2zsyx368CEU3j8tkRjR976WA0w752TI >									
348 	//        <  u =="0.000000000000000001" : ] 000000583724083.698779000000000000 ; 000000605437993.596515000000000000 ] >									
349 	//        < 0x0000000000000000000000000000000000000000000000000037AB13839BD337 >									
350 	//     < DUBAI_Portfolio_I_metadata_line_34_____Dubai_Development_Company_20250515 >									
351 	//        < HOv8F7Kx6y6s42u5L2b3RlXf1bfDe8IW2Z36aH4C17kpvYr1o3C24em55214cE14 >									
352 	//        <  u =="0.000000000000000001" : ] 000000605437993.596515000000000000 ; 000000622248632.363165000000000000 ] >									
353 	//        < 0x0000000000000000000000000000000000000000000000000039BD3373B579DF >									
354 	//     < DUBAI_Portfolio_I_metadata_line_35_____Deyaar_Development_20250515 >									
355 	//        < 6eY3I7FrI7496yR67IiI1c4S4JnXj0CE5KXVwb2DQUy7vbB3m9lw9E05nt3oI4K6 >									
356 	//        <  u =="0.000000000000000001" : ] 000000622248632.363165000000000000 ; 000000642389976.238936000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000003B579DF3D43596 >									
358 	//     < DUBAI_Portfolio_I_metadata_line_36_____Drake_Scull_International_20250515 >									
359 	//        < ryl7cMN94yiZD5RONLr9cwcI4ptcugDl9q3LLwAkqL5Cv2NonDWc20e3xyRGuwRb >									
360 	//        <  u =="0.000000000000000001" : ] 000000642389976.238936000000000000 ; 000000663059955.883481000000000000 ] >									
361 	//        < 0x000000000000000000000000000000000000000000000000003D435963F3BFCC >									
362 	//     < DUBAI_Portfolio_I_metadata_line_37_____Emaar_Properties_20250515 >									
363 	//        < 88IJsHJ6RyK04JocbkkS24CvpC8Nyi9h7ZMAmR76dDPEhQA7Gr8K25pei6p19YaD >									
364 	//        <  u =="0.000000000000000001" : ] 000000663059955.883481000000000000 ; 000000680245417.088088000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000003F3BFCC40DF8DE >									
366 	//     < DUBAI_Portfolio_I_metadata_line_38_____EMAAR_MALLS_GROUP_20250515 >									
367 	//        < fISYneH515HPPH71N3i7g3XGP47758P8Tot55WA3MFEiwS1E71n84ZPfR3A3X954 >									
368 	//        <  u =="0.000000000000000001" : ] 000000680245417.088088000000000000 ; 000000695833300.726203000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000040DF8DE425C1E2 >									
370 	//     < DUBAI_Portfolio_I_metadata_line_39_____Al_Mazaya_Holding_Company_20250515 >									
371 	//        < MC478Yn9L57xXd7Rl7AWtji1z9PuaiFju9o6hpl513N5x9SoTAiG8ZEaU0whdHG5 >									
372 	//        <  u =="0.000000000000000001" : ] 000000695833300.726203000000000000 ; 000000711411867.403057000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000425C1E243D8743 >									
374 	//     < DUBAI_Portfolio_I_metadata_line_40_____Union_Properties_20250515 >									
375 	//        < qU6WF5UZ2tC2JO47760v32G7qX8sJjV3xB6TYZ00yn11VfJ317iK4MM1tRzOZR8f >									
376 	//        <  u =="0.000000000000000001" : ] 000000711411867.403057000000000000 ; 000000728002043.355369000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000043D8743456D7CC >									
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