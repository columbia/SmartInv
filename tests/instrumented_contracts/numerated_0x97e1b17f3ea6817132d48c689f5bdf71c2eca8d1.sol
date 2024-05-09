1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	SHERE_PFII_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	SHERE_PFII_III_883		"	;
8 		string	public		symbol =	"	SHERE_PFII_III_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1908722628701830000000000000					;	
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
92 	//     < SHERE_PFII_III_metadata_line_1_____JSC 121 ARP_20260505 >									
93 	//        < l6YkLFR7nuHS2cQeT9I5QrVH9WaJTs8eVF35Y9645n1nfaei97eR9hx8iWEcD652 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000039961504.442088200000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000003CF9F6 >									
96 	//     < SHERE_PFII_III_metadata_line_2_____JSC 123 ARP_20260505 >									
97 	//        < Hw0tT3gvKgUVKN2LO118myG5dw515Q1l46j5SgZW2Z4EVxYP4A82za7V5Qp3T5Pe >									
98 	//        <  u =="0.000000000000000001" : ] 000000039961504.442088200000000000 ; 000000108135605.565021000000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000003CF9F6A50079 >									
100 	//     < SHERE_PFII_III_metadata_line_3_____JSC 360 ARP_20260505 >									
101 	//        < LOF6DjOIOz3fN9cnfZs43JD3syj6nvB7BYdS0LtCbQA7zYfl37yz1dQBWZSxo1zm >									
102 	//        <  u =="0.000000000000000001" : ] 000000108135605.565021000000000000 ; 000000156494695.833059000000000000 ] >									
103 	//        < 0x0000000000000000000000000000000000000000000000000000A50079EECABE >									
104 	//     < SHERE_PFII_III_metadata_line_4_____JSC “514 ARZ”_20260505 >									
105 	//        < P2BfL1ae1IOk4zMD7NDf56ORPvc465Lhh97jgkAU78wc9LHmXLky1o3va364A46L >									
106 	//        <  u =="0.000000000000000001" : ] 000000156494695.833059000000000000 ; 000000251349535.230808000000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000EECABE17F876A >									
108 	//     < SHERE_PFII_III_metadata_line_5_____JSC “170 RZ SOP”_20260505 >									
109 	//        < jwV8650ifisPj7c565m2EbRuj03KtahRfJtZjkDRC8P1P1o7Fx0XVhpi2MM5NTog >									
110 	//        <  u =="0.000000000000000001" : ] 000000251349535.230808000000000000 ; 000000326637416.330473000000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000017F876A1F268BE >									
112 	//     < SHERE_PFII_III_metadata_line_6_____JSC “31 ZATO”_20260505 >									
113 	//        < 72t06NqI99kUIzR63jGBo2DyOF6056zN7nUEV7186cFTt34b21B1B9EUZ3bVMtCE >									
114 	//        <  u =="0.000000000000000001" : ] 000000326637416.330473000000000000 ; 000000401562637.788764000000000000 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000000001F268BE264BC68 >									
116 	//     < SHERE_PFII_III_metadata_line_7_____JSC “32 RZ SOP”_20260505 >									
117 	//        < bcgeT3b0hQ1901138TJQs1oC9aue50k5TUz80Ei13sZPXh49rG5a48bDrsWJm94I >									
118 	//        <  u =="0.000000000000000001" : ] 000000401562637.788764000000000000 ; 000000475210777.490892000000000000 ] >									
119 	//        < 0x00000000000000000000000000000000000000000000000000264BC682D51D36 >									
120 	//     < SHERE_PFII_III_metadata_line_8_____JSC “680 ARZ”_20260505 >									
121 	//        < i2rDh8U7jtur52xDiC8L3RC6K5523o3c4B1JKlvYI5Yvn2G9n1A7o22JltdV48XC >									
122 	//        <  u =="0.000000000000000001" : ] 000000475210777.490892000000000000 ; 000000557592956.615678000000000000 ] >									
123 	//        < 0x000000000000000000000000000000000000000000000000002D51D36352D1C0 >									
124 	//     < SHERE_PFII_III_metadata_line_9_____JSC “720 RZ SOP”_20260505 >									
125 	//        < Fh8z294P3q95j2G4bo05sqUQ3r0pS71Ejm52qxaw9nnc28zBbV9S7YAoeG78XWq0 >									
126 	//        <  u =="0.000000000000000001" : ] 000000557592956.615678000000000000 ; 000000586802234.012261000000000000 ] >									
127 	//        < 0x00000000000000000000000000000000000000000000000000352D1C037F639F >									
128 	//     < SHERE_PFII_III_metadata_line_10_____JSC “VZ RTO”_20260505 >									
129 	//        < 091s4kKIQB24EoYoK62KT8MK9TDq9dF0kF8s3I0GP3RX1S8yL0c8ahxcIWO3INJN >									
130 	//        <  u =="0.000000000000000001" : ] 000000586802234.012261000000000000 ; 000000621911871.580447000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000037F639F3B4F653 >									
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
174 	//     < SHERE_PFII_III_metadata_line_11_____JSC “20 ARZ”_20260505 >									
175 	//        < RD4Q68993T1VVag5kEWi7pf30LtCbNgeTPwh1e13y4EWuVzO3Yt7PUcQ3M15Hla8 >									
176 	//        <  u =="0.000000000000000001" : ] 000000621911871.580447000000000000 ; 000000707718568.221659000000000000 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000000003B4F653437E491 >									
178 	//     < SHERE_PFII_III_metadata_line_12_____JSC “275 ARZ”_20260505 >									
179 	//        < 88dzD56Z0clkxEnl9Pu3tSC31FhnnK765h7901ZudFoP35Uwv8m4gq8w715rgOl2 >									
180 	//        <  u =="0.000000000000000001" : ] 000000707718568.221659000000000000 ; 000000800117715.598136000000000000 ] >									
181 	//        < 0x00000000000000000000000000000000000000000000000000437E4914C4E1FC >									
182 	//     < SHERE_PFII_III_metadata_line_13_____JSC 308 ARP_20260505 >									
183 	//        < mtt7VZblb3ctVwuS4d86NF8w3eimFt5YMQE0sjt1GeF39Pp4V7VUfDl51Z3ex5p6 >									
184 	//        <  u =="0.000000000000000001" : ] 000000800117715.598136000000000000 ; 000000879054573.224136000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000004C4E1FC53D54B1 >									
186 	//     < SHERE_PFII_III_metadata_line_14_____JSC “322 ARZ”_20260505 >									
187 	//        < QKZXN2OlgPuynA3d1XtI3w3KfVoBJHtVrU1Va3n0l6D09Iz00mB4SQa78T059OXd >									
188 	//        <  u =="0.000000000000000001" : ] 000000879054573.224136000000000000 ; 000000972002321.522835000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000053D54B15CB2868 >									
190 	//     < SHERE_PFII_III_metadata_line_15_____JSC “325 ARZ”_20260505 >									
191 	//        < q9173In75N7pGG2g5WoGh4N2vA8I9eIWi31NmoTFb8laYv2L7yc9nIp6hS3V07eY >									
192 	//        <  u =="0.000000000000000001" : ] 000000972002321.522835000000000000 ; 000001005314354.526430000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000005CB28685FDFCEB >									
194 	//     < SHERE_PFII_III_metadata_line_16_____JSC 121 ARP_INFRA_20260505 >									
195 	//        < p6zfyoXuu6m81gFM0Wb9t744789GU0y4XO2dW52J58Scl0l5NgBClJsvy2zSd80E >									
196 	//        <  u =="0.000000000000000001" : ] 000001005314354.526430000000000000 ; 000001053423863.473680000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000005FDFCEB64765B2 >									
198 	//     < SHERE_PFII_III_metadata_line_17_____JSC 123 ARP_INFRA_20260505 >									
199 	//        < I9Lmp7Ph2LBO1j5T687ZsHh2x3B91Fz9swEkvpDfRzysHZr4m1ch6c4Xar6d63Og >									
200 	//        <  u =="0.000000000000000001" : ] 000001053423863.473680000000000000 ; 000001095716557.449480000000000000 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000000064765B2687EE48 >									
202 	//     < SHERE_PFII_III_metadata_line_18_____JSC 360 ARP_INFRA_20260505 >									
203 	//        < hXM31yIEiNX1447IIT81N1E7UmRup0Sr53IpGO4Hj7704YN5IH0lH3Lq5k4M5QGq >									
204 	//        <  u =="0.000000000000000001" : ] 000001095716557.449480000000000000 ; 000001119944226.215090000000000000 ] >									
205 	//        < 0x00000000000000000000000000000000000000000000000000687EE486ACE637 >									
206 	//     < SHERE_PFII_III_metadata_line_19_____JSC “514 ARZ”_INFRA_20260505 >									
207 	//        < S78S250W150jDmj0OYPVxc4J5mgam9Lqa01xX0ETTOcGUE2E1P851DdF8fs8Ob52 >									
208 	//        <  u =="0.000000000000000001" : ] 000001119944226.215090000000000000 ; 000001167193668.756280000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000006ACE6376F4FF07 >									
210 	//     < SHERE_PFII_III_metadata_line_20_____JSC “170 RZ SOP”_INFRA_20260505 >									
211 	//        < 1T3U9x2QNmAfunt4bqXA73vppFO36K9Q2k87M6X41xdr2OuNP2X6C4VvXUI0By0p >									
212 	//        <  u =="0.000000000000000001" : ] 000001167193668.756280000000000000 ; 000001211103404.567080000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000006F4FF07737FF44 >									
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
256 	//     < SHERE_PFII_III_metadata_line_21_____JSC “31 ZATO”_INFRA_20260505 >									
257 	//        < aj9k6IUnPjfOE69z4WYJ8Q1lv753uD3tQB7lTE6gIQwMlEkSmSx2ISbMBb9nkScL >									
258 	//        <  u =="0.000000000000000001" : ] 000001211103404.567080000000000000 ; 000001241128639.784510000000000000 ] >									
259 	//        < 0x00000000000000000000000000000000000000000000000000737FF44765CFE0 >									
260 	//     < SHERE_PFII_III_metadata_line_22_____JSC “32 RZ SOP”_INFRA_20260505 >									
261 	//        < Aky0S6F6Po2Dt9h3V86Oftkk9ydudA8tMuVpt7WSdLZAojmE29p3aKQl6tcv788q >									
262 	//        <  u =="0.000000000000000001" : ] 000001241128639.784510000000000000 ; 000001264018881.245300000000000000 ] >									
263 	//        < 0x00000000000000000000000000000000000000000000000000765CFE0788BD60 >									
264 	//     < SHERE_PFII_III_metadata_line_23_____JSC “680 ARZ”_INFRA_20260505 >									
265 	//        < o47Wa3E6d8p6lh1A5Q8RL7yM7BDdMp1YS3CSIOC6j3U8XC9f899DjpjRa7FfOfyR >									
266 	//        <  u =="0.000000000000000001" : ] 000001264018881.245300000000000000 ; 000001309510493.363610000000000000 ] >									
267 	//        < 0x00000000000000000000000000000000000000000000000000788BD607CE2789 >									
268 	//     < SHERE_PFII_III_metadata_line_24_____JSC “720 RZ SOP”_INFRA_20260505 >									
269 	//        < 3IwkRS7RlA1020BzYsu35LTX9OnBrf037Y89Ht3e5DW2O6fY6M0n9SC723y76itj >									
270 	//        <  u =="0.000000000000000001" : ] 000001309510493.363610000000000000 ; 000001340655899.200850000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000007CE27897FDADB6 >									
272 	//     < SHERE_PFII_III_metadata_line_25_____JSC “VZ RTO”_INFRA_20260505 >									
273 	//        < o44Lu2wKioe1Z0I97731kinuquh5JK5OnC6x44idpAFdDw1vFg6y4877HC7PnC85 >									
274 	//        <  u =="0.000000000000000001" : ] 000001340655899.200850000000000000 ; 000001392607446.465560000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000007FDADB684CF349 >									
276 	//     < SHERE_PFII_III_metadata_line_26_____JSC “20 ARZ”_INFRA_20260505 >									
277 	//        < urToUAidTw7ONGGkMi4MVgC6EN3fg9n5H9BoI1Du79J0M5dXQCRD5K9n614MTr83 >									
278 	//        <  u =="0.000000000000000001" : ] 000001392607446.465560000000000000 ; 000001423845908.852490000000000000 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000000000084CF34987C9DCF >									
280 	//     < SHERE_PFII_III_metadata_line_27_____JSC “275 ARZ”_INFRA_20260505 >									
281 	//        < QJSLzPGLLnURr3NA1vnk4vn6P8vOKXls84Evxr6b708N85B5oJ88vwVs2VG596kT >									
282 	//        <  u =="0.000000000000000001" : ] 000001423845908.852490000000000000 ; 000001447379975.968350000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000087C9DCF8A086CE >									
284 	//     < SHERE_PFII_III_metadata_line_28_____JSC 308 ARP_INFRA_20260505 >									
285 	//        < k0LFZ2xb0JyvXagoqLlXM43hOjPfgj2459m5F5fIEbx998tp6Z6Ka44lqmd1w3Vk >									
286 	//        <  u =="0.000000000000000001" : ] 000001447379975.968350000000000000 ; 000001467547815.550490000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000008A086CE8BF4CDE >									
288 	//     < SHERE_PFII_III_metadata_line_29_____JSC “322 ARZ”_INFRA_20260505 >									
289 	//        < mo68WO9Lq9GvZT1qi07576iye7gy4o9KS7ww65Ze6waU4e1msaQmsE1SpU291tTl >									
290 	//        <  u =="0.000000000000000001" : ] 000001467547815.550490000000000000 ; 000001493212862.771300000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000008BF4CDE8E67646 >									
292 	//     < SHERE_PFII_III_metadata_line_30_____JSC “325 ARZ”_INFRA_20260505 >									
293 	//        < r15YEgV6ByB9jQEAUrF7f6E59XtpN277iJBt85QI8MrU6U3cM5hYlDb71LT2OKNN >									
294 	//        <  u =="0.000000000000000001" : ] 000001493212862.771300000000000000 ; 000001512840253.712910000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000008E676469046939 >									
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
338 	//     < SHERE_PFII_III_metadata_line_31_____JSC 121 ARP_ORG_20260505 >									
339 	//        < rEwb6psU7JQH48fA9L1x675z0Npb651CtUPXXuNU0Jd6zs6fi3ko8iq24RNg8d0u >									
340 	//        <  u =="0.000000000000000001" : ] 000001512840253.712910000000000000 ; 000001549262427.789750000000000000 ] >									
341 	//        < 0x00000000000000000000000000000000000000000000000000904693993BFCA3 >									
342 	//     < SHERE_PFII_III_metadata_line_32_____JSC 123 ARP_ORG_20260505 >									
343 	//        < 3uyoO169vWwU9k3uz0Qlt1Tui93uG8r8mauU69DC6krb6bdfjbQF3HX6ekD805jx >									
344 	//        <  u =="0.000000000000000001" : ] 000001549262427.789750000000000000 ; 000001580207556.159060000000000000 ] >									
345 	//        < 0x0000000000000000000000000000000000000000000000000093BFCA396B3494 >									
346 	//     < SHERE_PFII_III_metadata_line_33_____JSC 360 ARP_ORG_20260505 >									
347 	//        < TAkp4h27c9uAi27Rhu4b8RzIGd0K7a51lFRS1dIFRq6Hz2vAY23Q4v0HaGW0DFVS >									
348 	//        <  u =="0.000000000000000001" : ] 000001580207556.159060000000000000 ; 000001617275193.234770000000000000 ] >									
349 	//        < 0x0000000000000000000000000000000000000000000000000096B34949A3C41F >									
350 	//     < SHERE_PFII_III_metadata_line_34_____JSC “514 ARZ”_ORG_20260505 >									
351 	//        < y4g24Zhw4aJRw3hML5sl43JhB7L25E5belWrw03ZkcMKM2804r9Y4FbUuia6T8C1 >									
352 	//        <  u =="0.000000000000000001" : ] 000001617275193.234770000000000000 ; 000001641314066.906940000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000009A3C41F9C8724F >									
354 	//     < SHERE_PFII_III_metadata_line_35_____JSC “170 RZ SOP”_ORG_20260505 >									
355 	//        < Nl1iedE484muTugnvjZ2SlpSYVs394OVf5L43h241y59HN94h63b8Oo2t492uo4e >									
356 	//        <  u =="0.000000000000000001" : ] 000001641314066.906940000000000000 ; 000001736313830.078410000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000009C8724FA596797 >									
358 	//     < SHERE_PFII_III_metadata_line_36_____JSC “31 ZATO”_ORG_20260505 >									
359 	//        < cD8A4t2up14wGSszN8CXOYrIfp1J7ui77699UG4zdsIe6uki7EAF28v4e2Xejk8I >									
360 	//        <  u =="0.000000000000000001" : ] 000001736313830.078410000000000000 ; 000001760265744.568670000000000000 ] >									
361 	//        < 0x00000000000000000000000000000000000000000000000000A596797A7DF3CE >									
362 	//     < SHERE_PFII_III_metadata_line_37_____JSC “32 RZ SOP”_ORG_20260505 >									
363 	//        < iphL9h2q4X4x6dEqqvWo7jzaghmhs3Xe28AyW5p2t8gH93VmIJAK14IZ8bU7D8lg >									
364 	//        <  u =="0.000000000000000001" : ] 000001760265744.568670000000000000 ; 000001781418380.056510000000000000 ] >									
365 	//        < 0x00000000000000000000000000000000000000000000000000A7DF3CEA9E3A8E >									
366 	//     < SHERE_PFII_III_metadata_line_38_____JSC “680 ARZ”_ORG_20260505 >									
367 	//        < Cu8F19XVx7rDcx78cn790Na9PoaNq22xrxtA5DvHI1DyJcsCS33fnERtu1h5IaN3 >									
368 	//        <  u =="0.000000000000000001" : ] 000001781418380.056510000000000000 ; 000001824240247.306920000000000000 ] >									
369 	//        < 0x00000000000000000000000000000000000000000000000000A9E3A8EADF91D9 >									
370 	//     < SHERE_PFII_III_metadata_line_39_____JSC “720 RZ SOP”_ORG_20260505 >									
371 	//        < s84TIo3K5D093I7x3EQWPjkK13wUjJuJoE57I9qZDRZV0s78963l5drt4YAVNzs3 >									
372 	//        <  u =="0.000000000000000001" : ] 000001824240247.306920000000000000 ; 000001866025001.452140000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000ADF91D9B1F5404 >									
374 	//     < SHERE_PFII_III_metadata_line_40_____JSC “VZ RTO”_ORG_20260505 >									
375 	//        < 9ixELa2Wp0ul94UJlpL8zKq0U21mRI4Vqanzz5zn3q2S43PJtEZ27r6vRdhr0YNc >									
376 	//        <  u =="0.000000000000000001" : ] 000001866025001.452140000000000000 ; 000001908722628.701830000000000000 ] >									
377 	//        < 0x00000000000000000000000000000000000000000000000000B1F5404B607AC7 >									
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