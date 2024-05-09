1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXIX_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXIX_I_883		"	;
8 		string	public		symbol =	"	RUSS_PFXIX_I_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		592718827615176000000000000					;	
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
92 	//     < RUSS_PFXIX_I_metadata_line_1_____Eurochem_20211101 >									
93 	//        < 3l20zn6l4h9LABClV9UXViED79X996a4z215ZS1Wq1FUqaZa696RBaJQKq2k1891 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000013971455.532103900000000000 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000000015519A >									
96 	//     < RUSS_PFXIX_I_metadata_line_2_____Eurochem_Group_AG_Switzerland_20211101 >									
97 	//        < I39CB7bge5asl7LgB9T37l0Uj176lEdIkMs8h1GV78bUE2C1J77LeXZ8l1uqfN3K >									
98 	//        <  u =="0.000000000000000001" : ] 000000013971455.532103900000000000 ; 000000027208746.573885800000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000015519A29846B >									
100 	//     < RUSS_PFXIX_I_metadata_line_3_____Industrial _Group_Phosphorite_20211101 >									
101 	//        < f1VDKuQ5C3yOsnd2S6swkis417h2UprxHb1Y6BcEe6TwdYQ94T2J48dB7Jn5dhH2 >									
102 	//        <  u =="0.000000000000000001" : ] 000000027208746.573885800000000000 ; 000000043801938.239866600000000000 ] >									
103 	//        < 0x000000000000000000000000000000000000000000000000000029846B42D622 >									
104 	//     < RUSS_PFXIX_I_metadata_line_4_____Novomoskovsky_Azot_20211101 >									
105 	//        < kcp9TqPF7l879MWkcWk57yYK5Bc4ebT7QTFHrX6yz07lccaKBshh9c174vgfgY7G >									
106 	//        <  u =="0.000000000000000001" : ] 000000043801938.239866600000000000 ; 000000057114368.672785600000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000042D62257264D >									
108 	//     < RUSS_PFXIX_I_metadata_line_5_____Novomoskovsky_Chlor_20211101 >									
109 	//        < UQjrs28v6TEh20hHnf07VaTQ60Zx7BUqLNQ6JG4M4ce2ZW0BZYiqCoSmrK2o6V44 >									
110 	//        <  u =="0.000000000000000001" : ] 000000057114368.672785600000000000 ; 000000070167974.696827800000000000 ] >									
111 	//        < 0x000000000000000000000000000000000000000000000000000057264D6B115D >									
112 	//     < RUSS_PFXIX_I_metadata_line_6_____Nevinnomyssky_Azot_20211101 >									
113 	//        < xd0I407dHEtv77FzA0DY8fV3lLnkikzGSR9bkI4DQWvv25bp8glPoNmN99Z5wB7V >									
114 	//        <  u =="0.000000000000000001" : ] 000000070167974.696827800000000000 ; 000000084707543.730440300000000000 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000000000006B115D8140E2 >									
116 	//     < RUSS_PFXIX_I_metadata_line_7_____EuroChem_Belorechenskie_Minudobrenia_20211101 >									
117 	//        < 0bgKAZS6XFS9thN2pXlfrHjpd5lfFF2wJba37ENoAIbAen2Lsm2bDu32GQsAn7Or >									
118 	//        <  u =="0.000000000000000001" : ] 000000084707543.730440300000000000 ; 000000099031317.378488000000000000 ] >									
119 	//        < 0x00000000000000000000000000000000000000000000000000008140E2971C1C >									
120 	//     < RUSS_PFXIX_I_metadata_line_8_____Kovdorsky_GOK_20211101 >									
121 	//        < z2e8GE2Mr3iKe3GTj8no2B5Hbt1SJNbGM86WCXRfz963aA01zn5y7626M665s2gN >									
122 	//        <  u =="0.000000000000000001" : ] 000000099031317.378488000000000000 ; 000000112820189.569512000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000971C1CAC2663 >									
124 	//     < RUSS_PFXIX_I_metadata_line_9_____Lifosa_AB_20211101 >									
125 	//        < j0QCPQDn0Ry0rwAoDc7uPov50KnUjEnBVFwh6KaV29izwlJuZzQb7sy0Yu1J63OF >									
126 	//        <  u =="0.000000000000000001" : ] 000000112820189.569512000000000000 ; 000000125795249.051677000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000000AC2663BFF2C5 >									
128 	//     < RUSS_PFXIX_I_metadata_line_10_____EuroChem_Antwerpen_NV_20211101 >									
129 	//        < YVNw518rc7f2Od0714Zx3vxS0F55YLscea3w1dnu7FAOy29HjKyG57IMB022d13d >									
130 	//        <  u =="0.000000000000000001" : ] 000000125795249.051677000000000000 ; 000000141068019.380112000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000000BFF2C5D740B2 >									
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
174 	//     < RUSS_PFXIX_I_metadata_line_11_____EuroChem_VolgaKaliy_20211101 >									
175 	//        < NMs1qZ01FUsIJXwrL9Z5h9YiKtLN8g7OzA6XzE6cWQ51kwblgZ1s27o1IF911FzX >									
176 	//        <  u =="0.000000000000000001" : ] 000000141068019.380112000000000000 ; 000000157960282.146175000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000000D740B2F1073C >									
178 	//     < RUSS_PFXIX_I_metadata_line_12_____EuroChem_Usolsky_potash_complex_20211101 >									
179 	//        < VJLfHpGOG8Q7X6Z1k1AkiTp9Pk7A2Tz0eW3q42Zv57GJBRieWWwnKHY5oTx62l5D >									
180 	//        <  u =="0.000000000000000001" : ] 000000157960282.146175000000000000 ; 000000173136839.184379000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000000F1073C1082F94 >									
182 	//     < RUSS_PFXIX_I_metadata_line_13_____EuroChem_ONGK_20211101 >									
183 	//        < 12b62gmxEVF4kR8B6T8f653b12P50E089I1qov79su0qRxnkW71YKdLES9GYqP5r >									
184 	//        <  u =="0.000000000000000001" : ] 000000173136839.184379000000000000 ; 000000190315404.693409000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001082F9412265F4 >									
186 	//     < RUSS_PFXIX_I_metadata_line_14_____EuroChem_Northwest_20211101 >									
187 	//        < Ju3l626jrBH6q0G2o99s74f5x4P11Zt962tg5l44LN21s5k9OogU1sI6eF49915o >									
188 	//        <  u =="0.000000000000000001" : ] 000000190315404.693409000000000000 ; 000000205246133.661621000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000012265F41392E45 >									
190 	//     < RUSS_PFXIX_I_metadata_line_15_____EuroChem_Fertilizers_20211101 >									
191 	//        < a2EkV1pkK5x7VaMDo4PR2tGujw4w8i0A7SynlymWi9kh4SdqgJ717lnYLQLL7PE1 >									
192 	//        <  u =="0.000000000000000001" : ] 000000205246133.661621000000000000 ; 000000219825309.164864000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000001392E4514F6D43 >									
194 	//     < RUSS_PFXIX_I_metadata_line_16_____Astrakhan_Oil_and_Gas_Company_20211101 >									
195 	//        < zfJb47NY3CHvAx9uDr1sW93CM61c2xWO2Ni7g3e4eyKKpna3s35e45MzwGh5Hm21 >									
196 	//        <  u =="0.000000000000000001" : ] 000000219825309.164864000000000000 ; 000000233088933.978069000000000000 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000000014F6D43163AA5D >									
198 	//     < RUSS_PFXIX_I_metadata_line_17_____Sary_Tas_Fertilizers_20211101 >									
199 	//        < I645x97x5jXc78EPatSwXQKv8c43N5H98lDPCOSc5tIcy1IbMZJ1gSLLc3Z48MOk >									
200 	//        <  u =="0.000000000000000001" : ] 000000233088933.978069000000000000 ; 000000248173593.084223000000000000 ] >									
201 	//        < 0x00000000000000000000000000000000000000000000000000163AA5D17AAECF >									
202 	//     < RUSS_PFXIX_I_metadata_line_18_____EuroChem_Karatau_20211101 >									
203 	//        < kD51V9XKlcBRx18jsd43waCpQB4YPLiBLEg4pa9t2wq150WED2W14xjPixYNr6ru >									
204 	//        <  u =="0.000000000000000001" : ] 000000248173593.084223000000000000 ; 000000263087541.306558000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000017AAECF1917092 >									
206 	//     < RUSS_PFXIX_I_metadata_line_19_____Kamenkovskaya_Oil_Gas_Company_20211101 >									
207 	//        < Wive3T4m1z9Q35xnq977a3V5D28N8Bu4687R0jZGz1cYAVT51V8EHH6cU09Rz4Ll >									
208 	//        <  u =="0.000000000000000001" : ] 000000263087541.306558000000000000 ; 000000277718908.395665000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000000019170921A7C3F3 >									
210 	//     < RUSS_PFXIX_I_metadata_line_20_____EuroChem_Trading_GmbH_Trading_20211101 >									
211 	//        < k2S4Ybm25465Lr1MXJ8han2L9BVS60S6GvaTg7cRyUz1n1JdiigfB81U3butxUR0 >									
212 	//        <  u =="0.000000000000000001" : ] 000000277718908.395665000000000000 ; 000000291586070.320202000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000001A7C3F31BCECCF >									
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
256 	//     < RUSS_PFXIX_I_metadata_line_21_____EuroChem_Trading_USA_Corp_20211101 >									
257 	//        < mB4z62T37B0gS8tlwcUjAAOhM7rPlnuIBxVc31C59xOnJ8M0VZ04N54R266TP36n >									
258 	//        <  u =="0.000000000000000001" : ] 000000291586070.320202000000000000 ; 000000304695733.287555000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000001BCECCF1D0EDC5 >									
260 	//     < RUSS_PFXIX_I_metadata_line_22_____Ben_Trei_Ltd_20211101 >									
261 	//        < 7hf81y8eS2u42c5OVaO21V5ZC0JCxkl6brFy88kAd08FInjdI0J4B3232GRVZ41q >									
262 	//        <  u =="0.000000000000000001" : ] 000000304695733.287555000000000000 ; 000000319235479.048364000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000001D0EDC51E71D5C >									
264 	//     < RUSS_PFXIX_I_metadata_line_23_____EuroChem_Agro_SAS_20211101 >									
265 	//        < 22de32pSMy3GhOqDWsbg3xsYHnkBY4P3h4okECX8bzH5QZDhePXo5BP6IRkTAN70 >									
266 	//        <  u =="0.000000000000000001" : ] 000000319235479.048364000000000000 ; 000000334599887.134484000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000001E71D5C1FE8F15 >									
268 	//     < RUSS_PFXIX_I_metadata_line_24_____EuroChem_Agro_Asia_20211101 >									
269 	//        < Wyp01psvt27IuP0tvVQ3uYWI604O4k9V0h1xd3of2HOCoq1plT925RE1E14I5TDF >									
270 	//        <  u =="0.000000000000000001" : ] 000000334599887.134484000000000000 ; 000000350219238.951943000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000001FE8F152166464 >									
272 	//     < RUSS_PFXIX_I_metadata_line_25_____EuroChem_Agro_Iberia_20211101 >									
273 	//        < nA161JnsayLak5GkRW88vGMAIwTisSvg6mb7c4vtDsR30luSVna5XYPLGW66xDdM >									
274 	//        <  u =="0.000000000000000001" : ] 000000350219238.951943000000000000 ; 000000367024299.004900000000000000 ] >									
275 	//        < 0x00000000000000000000000000000000000000000000000000216646423008DE >									
276 	//     < RUSS_PFXIX_I_metadata_line_26_____EuroChem_Agricultural_Trading_Hellas_20211101 >									
277 	//        < 15HPKa3ny9lcOtCZa43PUHNw6zMzTh2S5SgxA49KOOHwFGtfnd17BanBQ137w3t6 >									
278 	//        <  u =="0.000000000000000001" : ] 000000367024299.004900000000000000 ; 000000383106217.865982000000000000 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000000000023008DE24892DE >									
280 	//     < RUSS_PFXIX_I_metadata_line_27_____EuroChem_Agro_Spa_20211101 >									
281 	//        < 0h5inh1frI36DU082Ucp2rq3446mhBF4DU5zFG03D5NxQL98aO190Vp6pf5y44kO >									
282 	//        <  u =="0.000000000000000001" : ] 000000383106217.865982000000000000 ; 000000397548508.242207000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000024892DE25E9C63 >									
284 	//     < RUSS_PFXIX_I_metadata_line_28_____EuroChem_Agro_GmbH_20211101 >									
285 	//        < 2WGOtIe4UH81wV32zwQ9QO2xtt4Q3F6Fv1ZtM38JOkyrs2VddMFdK82MlM276XBh >									
286 	//        <  u =="0.000000000000000001" : ] 000000397548508.242207000000000000 ; 000000411085700.755757000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000025E9C63273445A >									
288 	//     < RUSS_PFXIX_I_metadata_line_29_____EuroChem_Agro_México_SA_20211101 >									
289 	//        < XkOk6M9d201iQB0t30yk27lQJH7yN9SP6t5h4R9khPAzo6zW2kqJ2PtD65vYRrts >									
290 	//        <  u =="0.000000000000000001" : ] 000000411085700.755757000000000000 ; 000000426289512.546324000000000000 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000000000273445A28A7757 >									
292 	//     < RUSS_PFXIX_I_metadata_line_30_____EuroChem_Agro_Hungary_Kft_20211101 >									
293 	//        < FbE7DSNU984t386v9y751N7whmTKeCyh7pmDj973200Y6H53upt5fIf8h27uLvT0 >									
294 	//        <  u =="0.000000000000000001" : ] 000000426289512.546324000000000000 ; 000000442313360.274946000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000028A77572A2EAA8 >									
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
338 	//     < RUSS_PFXIX_I_metadata_line_31_____Agrocenter_EuroChem_Srl_20211101 >									
339 	//        < M6SC7X2Aak71rhs82r4Kg24991hFTge0kFHQQ4tkBXROTs3u7ft6BG8PdNE44qVv >									
340 	//        <  u =="0.000000000000000001" : ] 000000442313360.274946000000000000 ; 000000458719200.266083000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000002A2EAA82BBF330 >									
342 	//     < RUSS_PFXIX_I_metadata_line_32_____EuroChem_Agro_Bulgaria_Ead_20211101 >									
343 	//        < p5As0rFzgdbB6yB0Ey0H8I9883JR6pRXOE74LlXO994bZh9j5slk6k65k2AyTvI1 >									
344 	//        <  u =="0.000000000000000001" : ] 000000458719200.266083000000000000 ; 000000472416136.000198000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000002BBF3302D0D98E >									
346 	//     < RUSS_PFXIX_I_metadata_line_33_____EuroChem_Agro_doo_Beograd_20211101 >									
347 	//        < 4mDMZdDqKHYG1Yn1N7782GaCKDQmn1GA2N51bSmHIDrEi3nkg65uUJjb6X52UhrE >									
348 	//        <  u =="0.000000000000000001" : ] 000000472416136.000198000000000000 ; 000000485817548.591120000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000002D0D98E2E54C7B >									
350 	//     < RUSS_PFXIX_I_metadata_line_34_____EuroChem_Agro_Turkey_Tarim_Sanayi_ve_Ticaret_20211101 >									
351 	//        < z2j2W879O8k81g9UWRR6l2y4rhG1UVQwtz6YPG24P80mXK595WlII2t9LnMapXWt >									
352 	//        <  u =="0.000000000000000001" : ] 000000485817548.591120000000000000 ; 000000499334214.844985000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000002E54C7B2F9EC6D >									
354 	//     < RUSS_PFXIX_I_metadata_line_35_____Emerger_Fertilizantes_SA_20211101 >									
355 	//        < VJx85gjiD0Utnf4lyy56B63B8vg1i357caX9naIZ5AgVpMIxR013t130sjOC6z55 >									
356 	//        <  u =="0.000000000000000001" : ] 000000499334214.844985000000000000 ; 000000514623507.996935000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000002F9EC6D31140CF >									
358 	//     < RUSS_PFXIX_I_metadata_line_36_____EuroChem_Comercio_Produtos_Quimicos_20211101 >									
359 	//        < pj3zE6E915F6tYO1Sroc5eq9K52UtPvLBR2SDs54tkjzFgWnYNqw678J9DriLADH >									
360 	//        <  u =="0.000000000000000001" : ] 000000514623507.996935000000000000 ; 000000531661320.460459000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000031140CF32B4034 >									
362 	//     < RUSS_PFXIX_I_metadata_line_37_____Fertilizantes_Tocantines_Ltda_20211101 >									
363 	//        < 73KHv6LCE7A5yBHbV9waB6v79tk4BHCGFRu3V7S2V2K7FSA3wK0TS22rMoeqGo6S >									
364 	//        <  u =="0.000000000000000001" : ] 000000531661320.460459000000000000 ; 000000548851000.633491000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000032B40343457AEC >									
366 	//     < RUSS_PFXIX_I_metadata_line_38_____EuroChem_Agro_Trading_Shenzhen_20211101 >									
367 	//        < LYm5OmpR5wbxVWLp33QoA2p6G917MGniV7Lo70ID3rF0smUj98BuKEM2Zi2M744r >									
368 	//        <  u =="0.000000000000000001" : ] 000000548851000.633491000000000000 ; 000000564582543.099929000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000003457AEC35D7C0E >									
370 	//     < RUSS_PFXIX_I_metadata_line_39_____EuroChem_Trading_RUS_20211101 >									
371 	//        < 8jn8fjaeC8RNi43137m84iQs0vWW3Wu9MC2qEnoX4HgE24JhQUmXYn9r56f4qh8M >									
372 	//        <  u =="0.000000000000000001" : ] 000000564582543.099929000000000000 ; 000000577807836.608177000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000035D7C0E371AA30 >									
374 	//     < RUSS_PFXIX_I_metadata_line_40_____AgroCenter_EuroChem_Ukraine_20211101 >									
375 	//        < hfiR516V8SQgSwfk0At26CNSl1h2x26MJ0Y9bhVL6xLWcK8qgFB97T41X65RYDO6 >									
376 	//        <  u =="0.000000000000000001" : ] 000000577807836.608177000000000000 ; 000000592718827.615176000000000000 ] >									
377 	//        < 0x00000000000000000000000000000000000000000000000000371AA303886ACB >									
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