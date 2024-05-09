1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	NDRV_PFV_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	NDRV_PFV_I_883		"	;
8 		string	public		symbol =	"	NDRV_PFV_I_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		778406367995349000000000000					;	
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
92 	//     < NDRV_PFV_I_metadata_line_1_____talanx primary insurance group_20211101 >									
93 	//        < szg21bFPjJHj807bN05h16G9S9Hr8Ci7w9Ruo76110A0bKH88yFLpS5H41bwZpLO >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000019280758.870092100000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000001D6B8C >									
96 	//     < NDRV_PFV_I_metadata_line_2_____primary_pensions_20211101 >									
97 	//        < UpUG78dUA0I9z0I37BgxeEm0h47igd48D2Ks9DlJ1iZ983L9upaV6FZ3xsGN8LVL >									
98 	//        <  u =="0.000000000000000001" : ] 000000019280758.870092100000000000 ; 000000033892468.512457000000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000001D6B8C33B73F >									
100 	//     < NDRV_PFV_I_metadata_line_3_____hdi rechtsschutz ag_20211101 >									
101 	//        < VYJ8mu47xRzQy10b6ElBW8WFXu2b7er498PBm5mFYwK77XrO4ZR181BYgyPElF02 >									
102 	//        <  u =="0.000000000000000001" : ] 000000033892468.512457000000000000 ; 000000058686072.171197900000000000 ] >									
103 	//        < 0x000000000000000000000000000000000000000000000000000033B73F598C3F >									
104 	//     < NDRV_PFV_I_metadata_line_4_____Gerling Insurance Of South Africa Ltd_20211101 >									
105 	//        < fBv41z57uup1q2vk8IV46qrk3Wguts1cN7l5Fd0BaJigq33v1C56L37p11yCPN33 >									
106 	//        <  u =="0.000000000000000001" : ] 000000058686072.171197900000000000 ; 000000072925809.192684400000000000 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000000000598C3F6F46A5 >									
108 	//     < NDRV_PFV_I_metadata_line_5_____Gerling Global Life Sweden Reinsurance Co LTd_20211101 >									
109 	//        < Zh2KANkmRc4oW1JlK1GruX386k60b4TfC16Af92G2aU4P19KiW8m5IEvfbhQ2oyf >									
110 	//        <  u =="0.000000000000000001" : ] 000000072925809.192684400000000000 ; 000000093671680.938182000000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000006F46A58EEE80 >									
112 	//     < NDRV_PFV_I_metadata_line_6_____Amtrust Corporate Member Ltd_20211101 >									
113 	//        < O5E1y1y9fl2G4pyxXLaENgU5f9l2sv091aX22a2lR3v582CPd5EPy28r8Eh2q75I >									
114 	//        <  u =="0.000000000000000001" : ] 000000093671680.938182000000000000 ; 000000113103886.955503000000000000 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000000000008EEE80AC9535 >									
116 	//     < NDRV_PFV_I_metadata_line_7_____HDI_Gerling Australia Insurance Company Pty Ltd_20211101 >									
117 	//        < RsDVxW3kM2515o6vJzipR1DueCwQY60367V0WztMKJtvlVW6emomKFSC8IYbkMV8 >									
118 	//        <  u =="0.000000000000000001" : ] 000000113103886.955503000000000000 ; 000000131928585.030085000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000AC9535C94E9B >									
120 	//     < NDRV_PFV_I_metadata_line_8_____Gerling Institut GIBA_20211101 >									
121 	//        < hH0fIN0Ft7upqYq0Psn0ZTbXxQZFZWThw6oDhFi1A91X5Hwi05t86FQFSnTPWgo1 >									
122 	//        <  u =="0.000000000000000001" : ] 000000131928585.030085000000000000 ; 000000147608772.229534000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000C94E9BE13BAD >									
124 	//     < NDRV_PFV_I_metadata_line_9_____Gerling_org_20211101 >									
125 	//        < Zmps3h5Pv9l3KF9f1nQ4eBgGurm8mVfLpInriCDe00doAxoF53BV1oC67uw40LjJ >									
126 	//        <  u =="0.000000000000000001" : ] 000000147608772.229534000000000000 ; 000000162499691.375182000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000000E13BADF7F471 >									
128 	//     < NDRV_PFV_I_metadata_line_10_____Gerling_Holdings_20211101 >									
129 	//        < 2yDg47Ax94GK27fgFZ9oe7Cj24fZ22sq0aUY211Z2TNmPe6920nO8OH1dVg7sbmV >									
130 	//        <  u =="0.000000000000000001" : ] 000000162499691.375182000000000000 ; 000000184406864.599291000000000000 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000000000F7F47111961EE >									
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
174 	//     < NDRV_PFV_I_metadata_line_11_____Gerling_Pensions_20211101 >									
175 	//        < o163e6UCCtbWhUc1xDxeYUJu541NKJOhubiM543t85P5H09EW90LJzsDNhh62hiR >									
176 	//        <  u =="0.000000000000000001" : ] 000000184406864.599291000000000000 ; 000000205545745.572422000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000011961EE139A34F >									
178 	//     < NDRV_PFV_I_metadata_line_12_____talanx international ag_20211101 >									
179 	//        < jw4p6g4718sPmh644oPfSTNebO74L9531HqYjH825U21uE3gJ6xbdY8ACY29V3RJ >									
180 	//        <  u =="0.000000000000000001" : ] 000000205545745.572422000000000000 ; 000000219199270.568060000000000000 ] >									
181 	//        < 0x00000000000000000000000000000000000000000000000000139A34F14E78B7 >									
182 	//     < NDRV_PFV_I_metadata_line_13_____tuir warta_20211101 >									
183 	//        < 2804JlXz0EiQ6N7lO0IA5Csy6sQQ6HfEgkxx8ug06tIX3fZPu1I29J3RTgAkFS1e >									
184 	//        <  u =="0.000000000000000001" : ] 000000219199270.568060000000000000 ; 000000240203978.286558000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000014E78B716E85AE >									
186 	//     < NDRV_PFV_I_metadata_line_14_____tuir warta_org_20211101 >									
187 	//        < QF9Ktj9E7uKpfPl0q86H619KE590879Ig65J59Fvi7k14RHiwI06hg4aa4eUuh9r >									
188 	//        <  u =="0.000000000000000001" : ] 000000240203978.286558000000000000 ; 000000261787205.201498000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000016E85AE18F74A1 >									
190 	//     < NDRV_PFV_I_metadata_line_15_____towarzystwo ubezpieczen na zycie warta sa_20211101 >									
191 	//        < wy3i4916Jy8Ayh0LTPdO6f95vr059wKknLcmnC60j4111O8IY3K79Q00GMzBxvwC >									
192 	//        <  u =="0.000000000000000001" : ] 000000261787205.201498000000000000 ; 000000279987511.546812000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000018F74A11AB3A1F >									
194 	//     < NDRV_PFV_I_metadata_line_16_____HDI-Gerling Zycie Towarzystwo Ubezpieczen Spolka Akcyjna_20211101 >									
195 	//        < 8jZ4z5KrYaD0KHDlrj3190s6vb4TYUsee4L5xG3Mtg94uXu9HEKpFIJvTXiYtiX5 >									
196 	//        <  u =="0.000000000000000001" : ] 000000279987511.546812000000000000 ; 000000297244812.980823000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000001AB3A1F1C58F41 >									
198 	//     < NDRV_PFV_I_metadata_line_17_____TUiR Warta SA Asset Management Arm_20211101 >									
199 	//        < o1cHS9PJSvRDPqQVN1kLmrW42SkU9t66ij7T6MCO74YFKGwKKw02IMCOcNL86uqS >									
200 	//        <  u =="0.000000000000000001" : ] 000000297244812.980823000000000000 ; 000000318312878.149813000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000001C58F411E5B4F8 >									
202 	//     < NDRV_PFV_I_metadata_line_18_____HDI Seguros SA de CV_20211101 >									
203 	//        < m6h4kK0FKUze4vG2nR4rAb7rYQYIlnjwsQEvd7957VPggSNivFCOCR5OOrBP854j >									
204 	//        <  u =="0.000000000000000001" : ] 000000318312878.149813000000000000 ; 000000333736520.310988000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000001E5B4F81FD3DD4 >									
206 	//     < NDRV_PFV_I_metadata_line_19_____Towarzystwo Ubezpieczen Europa SA_20211101 >									
207 	//        < zyoR25xOVP95tvhHAhHe5mI1FSPyALn067CSBmoN4tKqxtyU49bp1N0gzF62C954 >									
208 	//        <  u =="0.000000000000000001" : ] 000000333736520.310988000000000000 ; 000000356380760.240166000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000001FD3DD421FCB3C >									
210 	//     < NDRV_PFV_I_metadata_line_20_____Towarzystwo Ubezpieczen Na Zycie EUROPA SA_20211101 >									
211 	//        < cAuVZLI56rRYcOO0nHC7BCJHnxi2BrKQ95It8k9476ujzO9Vl99SzWCWWbBd3bB8 >									
212 	//        <  u =="0.000000000000000001" : ] 000000356380760.240166000000000000 ; 000000372690174.897284000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000021FCB3C238AE19 >									
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
256 	//     < NDRV_PFV_I_metadata_line_21_____TU na ycie EUROPA SA_20211101 >									
257 	//        < 5294ETmUiS21r3S5Mw6su42Fm33oV7Rr4G1qk61r4f2TqC31c8cXg2LT0a2pFw64 >									
258 	//        <  u =="0.000000000000000001" : ] 000000372690174.897284000000000000 ; 000000387690222.363416000000000000 ] >									
259 	//        < 0x00000000000000000000000000000000000000000000000000238AE1924F917E >									
260 	//     < NDRV_PFV_I_metadata_line_22_____Liberty Sigorta_20211101 >									
261 	//        < RkcTyhp8957P5nFky422WCpy61UqZfQWy0BYZ37MVbp69d8n2uPhoUT82F4aiRF6 >									
262 	//        <  u =="0.000000000000000001" : ] 000000387690222.363416000000000000 ; 000000409192406.281464000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000024F917E27060C9 >									
264 	//     < NDRV_PFV_I_metadata_line_23_____Aspecta Versicherung Ag_20211101 >									
265 	//        < lW43KjaGy81XRoo64mE4DshpGT47q4vdKbKvyB9ZJE1g45Ab55S4D6whnIxs3kC3 >									
266 	//        <  u =="0.000000000000000001" : ] 000000409192406.281464000000000000 ; 000000434861835.411060000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000027060C92978BE8 >									
268 	//     < NDRV_PFV_I_metadata_line_24_____HDI Sigorta AS_20211101 >									
269 	//        < bS9CjlekG3WG3n1C69r7QIf9P19d7o041jUKTW0wBbX92J3Zh2wYloJmzM78N8K2 >									
270 	//        <  u =="0.000000000000000001" : ] 000000434861835.411060000000000000 ; 000000450201362.261506000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000002978BE82AEF3E8 >									
272 	//     < NDRV_PFV_I_metadata_line_25_____HDI Seguros SA_20211101 >									
273 	//        < 7yoFM5hA94W4gmOwqUzbrEdtl92520Gi991j1CFj9f1i7xliPRS3caEg21af4AV8 >									
274 	//        <  u =="0.000000000000000001" : ] 000000450201362.261506000000000000 ; 000000473151576.704620000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002AEF3E82D1F8D6 >									
276 	//     < NDRV_PFV_I_metadata_line_26_____Aseguradora Magallanes SA_20211101 >									
277 	//        < 4e50ZD0tq1x6OzZUxT3i5dvvYxLBPv14x3t1HPG0u0b77s8bEW1Z2W7t8F8QhT6Y >									
278 	//        <  u =="0.000000000000000001" : ] 000000473151576.704620000000000000 ; 000000499073367.763208000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000002D1F8D62F98689 >									
280 	//     < NDRV_PFV_I_metadata_line_27_____Asset Management Arm_20211101 >									
281 	//        < op1KdkxgZgT5Dm1WH8S5vd80dW9m6IO63NCJk44gmseXz09kQqCL3v7i1FZf2pIr >									
282 	//        <  u =="0.000000000000000001" : ] 000000499073367.763208000000000000 ; 000000521117344.875838000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000002F9868931B2976 >									
284 	//     < NDRV_PFV_I_metadata_line_28_____HDI Assicurazioni SpA_20211101 >									
285 	//        < 160jd5MuAmqL3RKk3S6xF9ERrpzhN2CSkSjf80f9V2U0YJmu6g9FarW8hFILTWR8 >									
286 	//        <  u =="0.000000000000000001" : ] 000000521117344.875838000000000000 ; 000000538355695.997924000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000031B29763357732 >									
288 	//     < NDRV_PFV_I_metadata_line_29_____InChiaro Assicurazioni SPA_20211101 >									
289 	//        < U3u3OcFO3vV63dS73GgamUsRM4eZT3Iq9XcGW6G55X57bF7dy6C4X8t7lCPWWd1b >									
290 	//        <  u =="0.000000000000000001" : ] 000000538355695.997924000000000000 ; 000000560273355.898065000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000003357732356E8C8 >									
292 	//     < NDRV_PFV_I_metadata_line_30_____Inlinea SpA_20211101 >									
293 	//        < 1o33oVHn9wd431Cov3uUh45vj4FLh6FNk2c03L6R7MSbFn44B8fBOeTJ2D3E8KYJ >									
294 	//        <  u =="0.000000000000000001" : ] 000000560273355.898065000000000000 ; 000000584487870.479186000000000000 ] >									
295 	//        < 0x00000000000000000000000000000000000000000000000000356E8C837BDB93 >									
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
338 	//     < NDRV_PFV_I_metadata_line_31_____Inversiones HDI Limitada_20211101 >									
339 	//        < 2DO6zaa9D4wN1Aw1teIqhxbVq79VP48gr2I909LaDz5t8YHc9xY41b7cmhVWkjuT >									
340 	//        <  u =="0.000000000000000001" : ] 000000584487870.479186000000000000 ; 000000610184786.173899000000000000 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000000000037BDB933A3116F >									
342 	//     < NDRV_PFV_I_metadata_line_32_____HDI Seguros de Garantía y Crédito SA_20211101 >									
343 	//        < Y4w3Xtnp3KgH48F2IlhKq6o8hWt9Q06UVx1iDFGJiH6wWf69V1gjE4vqxy55rLOX >									
344 	//        <  u =="0.000000000000000001" : ] 000000610184786.173899000000000000 ; 000000627553502.751778000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000003A3116F3BD9216 >									
346 	//     < NDRV_PFV_I_metadata_line_33_____HDI Seguros_20211101 >									
347 	//        < ahIoIB0SJ16yX9eMy0efn16I3j317RS7488qoUbOTbMWBRpT1Dm51jlpky0v40Tt >									
348 	//        <  u =="0.000000000000000001" : ] 000000627553502.751778000000000000 ; 000000646948991.343119000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000003BD92163DB2A73 >									
350 	//     < NDRV_PFV_I_metadata_line_34_____HDI Seguros_Holdings_20211101 >									
351 	//        < x78s4VBVj1IQFTzxf4PkY2c6aW379FfF17tnm9u4h3raZf82q51U5feAQ8F4Y7VY >									
352 	//        <  u =="0.000000000000000001" : ] 000000646948991.343119000000000000 ; 000000671605962.043706000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000003DB2A73400CA14 >									
354 	//     < NDRV_PFV_I_metadata_line_35_____Aseguradora Magallanes Peru SA Compania De Seguros_20211101 >									
355 	//        < 5c5ccTI546L6p0EY567k1p9387ZQB8SUmJCWQLm7hF25qwAENnOKkf4GXz56QjSn >									
356 	//        <  u =="0.000000000000000001" : ] 000000671605962.043706000000000000 ; 000000691299682.507339000000000000 ] >									
357 	//        < 0x00000000000000000000000000000000000000000000000000400CA1441ED6F0 >									
358 	//     < NDRV_PFV_I_metadata_line_36_____Saint Honoré Iberia SL_20211101 >									
359 	//        < vrVbm8pZXFg9rgYCpqUNJ1id1Z2eNDLYPlWZRIU9ko30GYpjk03C5x2UbVEvv5BM >									
360 	//        <  u =="0.000000000000000001" : ] 000000691299682.507339000000000000 ; 000000708283839.308703000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000041ED6F0438C160 >									
362 	//     < NDRV_PFV_I_metadata_line_37_____HDI Seguros SA_20211101 >									
363 	//        < 559l632DyyNcqAM8CVLpt5c2UWhNJLT3dTAt0WaOcM0GOFjP75Dxq7BPkyH6JTnd >									
364 	//        <  u =="0.000000000000000001" : ] 000000708283839.308703000000000000 ; 000000728264234.018287000000000000 ] >									
365 	//        < 0x00000000000000000000000000000000000000000000000000438C1604573E37 >									
366 	//     < NDRV_PFV_I_metadata_line_38_____L_UNION de Paris Cia Uruguaya de Seguros SA_20211101 >									
367 	//        < sRhkTDxMQ35u66vn16vk0Funa2pQsUDzO5JIUw55VQ21Lb7ugx75Slxw4sZ4dpQd >									
368 	//        <  u =="0.000000000000000001" : ] 000000728264234.018287000000000000 ; 000000742200901.432960000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000004573E3746C823A >									
370 	//     < NDRV_PFV_I_metadata_line_39_____L_UNION_org_20211101 >									
371 	//        < cZzbHRhGFLNt8eRjc6HK4Ufz9g8x72JjheeNoLeIjxe9D6b9N3Ry8hLXQLF09Ke5 >									
372 	//        <  u =="0.000000000000000001" : ] 000000742200901.432960000000000000 ; 000000759216279.272397000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000046C823A48678DC >									
374 	//     < NDRV_PFV_I_metadata_line_40_____Protecciones Esenciales SA_20211101 >									
375 	//        < RCYym8h0zGBs4J9j6TM1Qu49mL2t7X1S6gsk9t8AJ04J826wv3lhWB3f02M6WGH1 >									
376 	//        <  u =="0.000000000000000001" : ] 000000759216279.272397000000000000 ; 000000778406367.995349000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000048678DC4A3C0FD >									
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