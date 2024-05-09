1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXXXVII_II_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXXXVII_II_883		"	;
8 		string	public		symbol =	"	RUSS_PFXXXVII_II_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		787987220873709000000000000					;	
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
92 	//     < RUSS_PFXXXVII_II_metadata_line_1_____ROSNEFTTRANS_20231101 >									
93 	//        < aE33iS0p9fP3r3565zrxVKL44kkTqxhPTUD463VfN5zo21NT78H2NkY8NLzEI4k0 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000017617027.696599100000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000001AE1A7 >									
96 	//     < RUSS_PFXXXVII_II_metadata_line_2_____ROSNEFT_MARINE_UK_LIMITED_20231101 >									
97 	//        < 47m6RkqD7Vndh7OOxDC5BFeT1c2S3FO3tnP3401Hkhb60mLPPaxJmEpMc651ZLJ2 >									
98 	//        <  u =="0.000000000000000001" : ] 000000017617027.696599100000000000 ; 000000033583938.798878000000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000001AE1A7333EBA >									
100 	//     < RUSS_PFXXXVII_II_metadata_line_3_____MARINE_ORG_20231101 >									
101 	//        < 907H3Rjx61U5SjQ5xH3xTRj8Nkh9MxYhbk01xXczEfI477Uu8pSEspenPXVvT9e1 >									
102 	//        <  u =="0.000000000000000001" : ] 000000033583938.798878000000000000 ; 000000049003835.868415100000000000 ] >									
103 	//        < 0x0000000000000000000000000000000000000000000000000000333EBA4AC620 >									
104 	//     < RUSS_PFXXXVII_II_metadata_line_4_____ORENBURGNEFT_ORG_20231101 >									
105 	//        < aOA43nLGh97yV58KNWom3m02YG6LBp6HCRk0W7VO3jefx6Nnt1VYgJPQ562z6sh8 >									
106 	//        <  u =="0.000000000000000001" : ] 000000049003835.868415100000000000 ; 000000065745459.982608800000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000004AC6206451D2 >									
108 	//     < RUSS_PFXXXVII_II_metadata_line_5_____ORENBURGNEFT_EUR_20231101 >									
109 	//        < sxYMGsc7tv18L37n9VuvI7yb4Q63990XQGkIC92TT09n256mzpSI76Pmqt1WRzpp >									
110 	//        <  u =="0.000000000000000001" : ] 000000065745459.982608800000000000 ; 000000090084930.767089700000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000006451D289756D >									
112 	//     < RUSS_PFXXXVII_II_metadata_line_6_____KUIBYSHEV_ORG_20231101 >									
113 	//        < o34V0nL4Ww9310g7Ef21YZBCrhDoo7rm2GkFU3SzuFDMRF1T3Kd0zn2Eb7C0Zct3 >									
114 	//        <  u =="0.000000000000000001" : ] 000000090084930.767089700000000000 ; 000000109942685.713750000000000000 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000000000089756DA7C25D >									
116 	//     < RUSS_PFXXXVII_II_metadata_line_7_____SAMARA_ORG_20231101 >									
117 	//        < BrfsuDd3BZMW48dHUl9GAiGu1O2A7S7z44tG5gOd4Cv3hjMar55wiW165djB1Yeg >									
118 	//        <  u =="0.000000000000000001" : ] 000000109942685.713750000000000000 ; 000000132161786.789166000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000A7C25DC9A9B3 >									
120 	//     < RUSS_PFXXXVII_II_metadata_line_8_____SARATOV_ORG_20231101 >									
121 	//        < Pk0H7IVN2MbkJ3wSmYRD4N4S37fNIqIwm9Mh8InhzCLrEq7QLzfQT2ugLEfju87t >									
122 	//        <  u =="0.000000000000000001" : ] 000000132161786.789166000000000000 ; 000000157032511.403771000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000C9A9B3EF9CD3 >									
124 	//     < RUSS_PFXXXVII_II_metadata_line_9_____RYAZAN_ORG_20231101 >									
125 	//        < fkGnu34Yh4VOY0g74I9hNm84C7S6pP799GP5677jHm2le9ZU96lE2nt0lyXPMEGI >									
126 	//        <  u =="0.000000000000000001" : ] 000000157032511.403771000000000000 ; 000000177380076.275126000000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000000EF9CD310EA918 >									
128 	//     < RUSS_PFXXXVII_II_metadata_line_10_____NYAGAN_ORG_20231101 >									
129 	//        < ZBa9UbCM7M8RVuisRDm5t7U03b39Q6NbpC4ABaOKCsh6jkb8sBifpa7iEXz442ci >									
130 	//        <  u =="0.000000000000000001" : ] 000000177380076.275126000000000000 ; 000000198772727.884707000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000010EA91812F4D99 >									
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
174 	//     < RUSS_PFXXXVII_II_metadata_line_11_____ROSNEFT_MONGOLIA_20231101 >									
175 	//        < VN61h1vL5xc3wr3GtL6Skh5hW3FhKW5Q7KC8Ek4k05Wwpwu0J24ZAot1Dxq0c449 >									
176 	//        <  u =="0.000000000000000001" : ] 000000198772727.884707000000000000 ; 000000218194994.242294000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000012F4D9914CF06B >									
178 	//     < RUSS_PFXXXVII_II_metadata_line_12_____ORENBURGNEFT_20231101 >									
179 	//        < 557Io7itSTMA3SuKVA4kQz8633e3CZgs81oH87wPByv8PkPEb1fh909927OwNo6A >									
180 	//        <  u =="0.000000000000000001" : ] 000000218194994.242294000000000000 ; 000000240479077.818606000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000014CF06B16EF124 >									
182 	//     < RUSS_PFXXXVII_II_metadata_line_13_____KAMTCHATKA_HOLDING_BV_20231101 >									
183 	//        < 57XTwr61YtNY0hY5rF976X1Vv7171Iq4348g3pewO66d419W9WLzhR2h4DM82l9L >									
184 	//        <  u =="0.000000000000000001" : ] 000000240479077.818606000000000000 ; 000000258615371.969573000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000016EF12418A9DA1 >									
186 	//     < RUSS_PFXXXVII_II_metadata_line_14_____ROSNEFT_SHELL_CASPIAN_VENTURES_LIMITED_20231101 >									
187 	//        < qG2IE0ZfL21oNNZC33FFO0DzkAUINl5Ix19dE9E02SOe6cDs4PwBV94Po6pqCLIP >									
188 	//        <  u =="0.000000000000000001" : ] 000000258615371.969573000000000000 ; 000000274993615.793714000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000018A9DA11A39B62 >									
190 	//     < RUSS_PFXXXVII_II_metadata_line_15_____KUIBYSHEV_REFINERY_20231101 >									
191 	//        < 1PQ18h2n5023u0AxJ7k2R89ErDkUAJa1i3s4vn4uuinH9MU54oILfa7SDn9Ej0sc >									
192 	//        <  u =="0.000000000000000001" : ] 000000274993615.793714000000000000 ; 000000298054687.415768000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000001A39B621C6CB9D >									
194 	//     < RUSS_PFXXXVII_II_metadata_line_16_____SAMARA_TERMINAL_LLC_20231101 >									
195 	//        < li26Sm9e3v7nClM7v6VWqq34rXXKB3crKhPPwcXQENyO2d4KR2aR2K04I5sOS5cA >									
196 	//        <  u =="0.000000000000000001" : ] 000000298054687.415768000000000000 ; 000000317499720.446559000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000001C6CB9D1E47754 >									
198 	//     < RUSS_PFXXXVII_II_metadata_line_17_____ROSNEFT_FINANCE_SA_20231101 >									
199 	//        < bK02B0R97KK4Un2HKzUNLwT7KVG3EK8K80I5znWGfx54jB0qPRch6qOIIrGi86IW >									
200 	//        <  u =="0.000000000000000001" : ] 000000317499720.446559000000000000 ; 000000339616636.194968000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000001E4775420636C0 >									
202 	//     < RUSS_PFXXXVII_II_metadata_line_18_____YUKOS_MOSKVA_20231101 >									
203 	//        < 4z9Ir65i1z98xb7BxthBxMxumI0I8JND4762XR1o6A0056t4J5998jkmKf33NNqh >									
204 	//        <  u =="0.000000000000000001" : ] 000000339616636.194968000000000000 ; 000000360019900.465328000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000020636C022558C6 >									
206 	//     < RUSS_PFXXXVII_II_metadata_line_19_____RN_SEVERNAYA_NEFT_20231101 >									
207 	//        < 19878kvTUe1EY4v3FwZ4AEs133rZyulmq4Ld0Ty94JZspO6t70p8avjD80c9TSab >									
208 	//        <  u =="0.000000000000000001" : ] 000000360019900.465328000000000000 ; 000000377105451.497461000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000000022558C623F6AD1 >									
210 	//     < RUSS_PFXXXVII_II_metadata_line_20_____KARACHAEVO_CHERKESSKNEFTPRODUKT_20231101 >									
211 	//        < srM0S9arOkbhSJ0C8463KyUlTk83t7xJkkZsu51N6FuMFFZLRLW78081pxCF082f >									
212 	//        <  u =="0.000000000000000001" : ] 000000377105451.497461000000000000 ; 000000394437614.428366000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000023F6AD1259DD31 >									
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
256 	//     < RUSS_PFXXXVII_II_metadata_line_21_____RN_BURENIE_LLC_20231101 >									
257 	//        < KSO5gELN7XX07nXhTWH52aX02X31QTqBvEQcpV1Wytf8NUcT10EOwWc55bZ44zR2 >									
258 	//        <  u =="0.000000000000000001" : ] 000000394437614.428366000000000000 ; 000000415118823.434115000000000000 ] >									
259 	//        < 0x00000000000000000000000000000000000000000000000000259DD312796BCA >									
260 	//     < RUSS_PFXXXVII_II_metadata_line_22_____RN_MOSKVA_20231101 >									
261 	//        < aqu35TxvX7b7lgP7qRJVsK599Qc7IX7ww0td8CwVsjPJ0pUsc6547O0E95CoN6x8 >									
262 	//        <  u =="0.000000000000000001" : ] 000000415118823.434115000000000000 ; 000000434604791.372759000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000002796BCA297277F >									
264 	//     < RUSS_PFXXXVII_II_metadata_line_23_____BASHNEFT_AB_20231101 >									
265 	//        < Q66U329gyVFvo56z82xS07MF10l7YRa6EDUsw5V1LPU75F35f2w6MSvVriGT6ALz >									
266 	//        <  u =="0.000000000000000001" : ] 000000434604791.372759000000000000 ; 000000457850549.255884000000000000 ] >									
267 	//        < 0x00000000000000000000000000000000000000000000000000297277F2BA9FDF >									
268 	//     < RUSS_PFXXXVII_II_metadata_line_24_____TNK_BP_AB_20231101 >									
269 	//        < At309d8fClxu5tJgzyw94HoAvoTDWmEBY7G32Vy4X7hs639sg7O8FLXavLvSC26c >									
270 	//        <  u =="0.000000000000000001" : ] 000000457850549.255884000000000000 ; 000000476648683.056472000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000002BA9FDF2D74EE4 >									
272 	//     < RUSS_PFXXXVII_II_metadata_line_25_____IOUGANSKNEFTEGAS_20231101 >									
273 	//        < zb9sU9cgQ57r3ZhXKU9nzLF9qyzHlBLLZNSE55de5q6Oj0JN6mV6jFQbNOlyf5U5 >									
274 	//        <  u =="0.000000000000000001" : ] 000000476648683.056472000000000000 ; 000000500817172.426363000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002D74EE42FC2FB5 >									
276 	//     < RUSS_PFXXXVII_II_metadata_line_26_____RUSS_REGIONAL_DEV_BANK_20231101 >									
277 	//        < H78Wz89v913u5D3Ca5c2vhfCIVYfpS2Wq5xzh6i3xD84r1VMz8Ebf2OW27V4Wv83 >									
278 	//        <  u =="0.000000000000000001" : ] 000000500817172.426363000000000000 ; 000000520911177.915997000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000002FC2FB531AD8EE >									
280 	//     < RUSS_PFXXXVII_II_metadata_line_27_____ANGARSK_PETROCHEM_CO_20231101 >									
281 	//        < 9P7jXtSY47o1gUDz2uZ156U18Bz122U9Ebzx2c7W13E47k3Mot2434O41pY7D0oO >									
282 	//        <  u =="0.000000000000000001" : ] 000000520911177.915997000000000000 ; 000000544584562.603818000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000031AD8EE33EF858 >									
284 	//     < RUSS_PFXXXVII_II_metadata_line_28_____TNK_NYAGAN_20231101 >									
285 	//        < oY2BM1OXKXth2yP5aKcFN15LryP6Obax4N7R5vLdICbBxU7f54dC8rDI76O3Hp6I >									
286 	//        <  u =="0.000000000000000001" : ] 000000544584562.603818000000000000 ; 000000560789589.277211000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000033EF858357B26F >									
288 	//     < RUSS_PFXXXVII_II_metadata_line_29_____VERKHNECHONSKNEFTEGAZ_20231101 >									
289 	//        < T7H7BfNd4TTCUuRJTe7kQJ23HPAV60Dp6Opu0967Re4vnvjibMUNtXk0Zw077tBP >									
290 	//        <  u =="0.000000000000000001" : ] 000000560789589.277211000000000000 ; 000000578860939.564488000000000000 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000000000357B26F373458E >									
292 	//     < RUSS_PFXXXVII_II_metadata_line_30_____VANKORNEFT_20231101 >									
293 	//        < 08VawMe5bBFwaUPVJqZO172DqA951U6paRpP5c8H60y89fNV209WyDZ4nm5fXL1A >									
294 	//        <  u =="0.000000000000000001" : ] 000000578860939.564488000000000000 ; 000000594819465.518831000000000000 ] >									
295 	//        < 0x00000000000000000000000000000000000000000000000000373458E38B9F5B >									
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
338 	//     < RUSS_PFXXXVII_II_metadata_line_31_____ROSNEFT_TRADING_SA_20231101 >									
339 	//        < G1r0VT1laX3HV9192hE56rdJHwjCZ23BOOH3xbhxIepbY0EZWS65Hy6Eg8cI2ABw >									
340 	//        <  u =="0.000000000000000001" : ] 000000594819465.518831000000000000 ; 000000613860941.767223000000000000 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000000000038B9F5B3A8AD6E >									
342 	//     < RUSS_PFXXXVII_II_metadata_line_32_____ROSNEFT_VIETNAM_BV_20231101 >									
343 	//        < XKz3cfmI14dgoVcAU7220v6390815j96J96hF6JcM8kvBTD04gHQhdDEPh23d42Z >									
344 	//        <  u =="0.000000000000000001" : ] 000000613860941.767223000000000000 ; 000000635388944.669271000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000003A8AD6E3C986CE >									
346 	//     < RUSS_PFXXXVII_II_metadata_line_33_____SARATOV_OIL_REFINERY_20231101 >									
347 	//        < 8ZXB8iVvcE65YsBsMJ7JxJ1bYWTA444HN05B0hhW93Dhr2h2KTl3Sa3y87MTR36X >									
348 	//        <  u =="0.000000000000000001" : ] 000000635388944.669271000000000000 ; 000000659031473.949877000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000003C986CE3ED9A2B >									
350 	//     < RUSS_PFXXXVII_II_metadata_line_34_____ITERA_LATVIJA_20231101 >									
351 	//        < P72uQqenKcO4BVr56et5FeBn3X2e3FwOt5r53rxw88v1KXZi3sC7kwl40IWcs3ax >									
352 	//        <  u =="0.000000000000000001" : ] 000000659031473.949877000000000000 ; 000000675298527.980678000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000003ED9A2B4066C7D >									
354 	//     < RUSS_PFXXXVII_II_metadata_line_35_____EP_ITDA_20231101 >									
355 	//        < keP43a6v4k4lvM1S2l1iD4fCc7Kt6A88z40q5192by9D81G56wT5BK9Z4PVFA5hI >									
356 	//        <  u =="0.000000000000000001" : ] 000000675298527.980678000000000000 ; 000000693880538.060790000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000004066C7D422C716 >									
358 	//     < RUSS_PFXXXVII_II_metadata_line_36_____RYAZAN_OIL_REFINERY_20231101 >									
359 	//        < gs60Y1BhOSUtIkck3mnYecKC113nMVU1tpeG3I0R08cFD52Em7z2ol8T1VtnXGNP >									
360 	//        <  u =="0.000000000000000001" : ] 000000693880538.060790000000000000 ; 000000715671053.050527000000000000 ] >									
361 	//        < 0x00000000000000000000000000000000000000000000000000422C7164440701 >									
362 	//     < RUSS_PFXXXVII_II_metadata_line_37_____RN_PURNEFTEGAZ_20231101 >									
363 	//        < XGZrsTkMp8q1ppCwp9dPKMz4nqK7iopw6f5sz8DPbZm87y6fJGowRi5HQq7A25Od >									
364 	//        <  u =="0.000000000000000001" : ] 000000715671053.050527000000000000 ; 000000738069409.318497000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000004440701466345D >									
366 	//     < RUSS_PFXXXVII_II_metadata_line_38_____NOVY_INVESTMENTS_LIMITED_20231101 >									
367 	//        < Cshq4jYsTRKVsF2oovlGuFTCviYeJ1u71z6T0BXzD9D8sP2WdxJq8o60tPmY003c >									
368 	//        <  u =="0.000000000000000001" : ] 000000738069409.318497000000000000 ; 000000754513415.803150000000000000 ] >									
369 	//        < 0x00000000000000000000000000000000000000000000000000466345D47F4BCE >									
370 	//     < RUSS_PFXXXVII_II_metadata_line_39_____ROSNEFT_STS_20231101 >									
371 	//        < KC96Wxshqn2AAbB61UE53g0zt3Sm8AbScUAZnm5yMAoBz4s0X1PI52pT97u6dpbH >									
372 	//        <  u =="0.000000000000000001" : ] 000000754513415.803150000000000000 ; 000000770382054.808722000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000047F4BCE497827D >									
374 	//     < RUSS_PFXXXVII_II_metadata_line_40_____ROSNEFT_INT_HOLDINGS_LIMITED_20231101 >									
375 	//        < mCx82TQA2V1M0qH562YFmdBAnn4V9q0I5J2EifEf8wF89RAv04ZNenD6O3nmS8aX >									
376 	//        <  u =="0.000000000000000001" : ] 000000770382054.808722000000000000 ; 000000787987220.873709000000000000 ] >									
377 	//        < 0x00000000000000000000000000000000000000000000000000497827D4B25F82 >									
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