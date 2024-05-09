1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	NDRV_PFIV_II_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	NDRV_PFIV_II_883		"	;
8 		string	public		symbol =	"	NDRV_PFIV_II_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1173533492794600000000000000					;	
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
92 	//     < NDRV_PFIV_II_metadata_line_1_____gerling beteiligungs_gmbh_20231101 >									
93 	//        < mlEGAMf4As0q7t4hGNNz9ig52W29HheGrRSq2fVZAy65aABwAKZ2zZ3sn2Ky7md0 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000020669414.623124000000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000001F89FD >									
96 	//     < NDRV_PFIV_II_metadata_line_2_____aspecta lebensversicherung ag_20231101 >									
97 	//        < FXaRbv50i5PIyGC928954VuR27jetQ8759dYh7nRa04p6QN6QQZ1Km616Mk708QZ >									
98 	//        <  u =="0.000000000000000001" : ] 000000020669414.623124000000000000 ; 000000064165569.335083400000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000001F89FD61E8AD >									
100 	//     < NDRV_PFIV_II_metadata_line_3_____ampega asset management gmbh_20231101 >									
101 	//        < n6Z7XuL56Q2dGeV9i1e732u8rA17vFT0BFp6bp8ad1mJ5DPfXlKO4vA9cG0HPlPi >									
102 	//        <  u =="0.000000000000000001" : ] 000000064165569.335083400000000000 ; 000000081299717.055406300000000000 ] >									
103 	//        < 0x000000000000000000000000000000000000000000000000000061E8AD7C0DB4 >									
104 	//     < NDRV_PFIV_II_metadata_line_4_____deutschland bancassurance gmbh_20231101 >									
105 	//        < G4KBtY9qRsUAs5CdLwFQQySJF6MM361h64vt3enX4S74mJI44BDP1aAm3I5C30D0 >									
106 	//        <  u =="0.000000000000000001" : ] 000000081299717.055406300000000000 ; 000000102237015.542463000000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000007C0DB49C0056 >									
108 	//     < NDRV_PFIV_II_metadata_line_5_____hdi_gerling assurances sa_20231101 >									
109 	//        < 06c64R75g5F07QzOciU7w26O4F8Y9B3L6u28rpnB7GHsxAZx6xe46VQ3436Mx7Lu >									
110 	//        <  u =="0.000000000000000001" : ] 000000102237015.542463000000000000 ; 000000117987739.556514000000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000009C0056B408F6 >									
112 	//     < NDRV_PFIV_II_metadata_line_6_____hdi_gerling firmen und privat versicherung ag_20231101 >									
113 	//        < 108x96FizY81PhXSX11Rm9d3flDF6QGZzCwsD29vDxFKG90YRxLn5T97DBWBQpkq >									
114 	//        <  u =="0.000000000000000001" : ] 000000117987739.556514000000000000 ; 000000135833885.998880000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000B408F6CF441D >									
116 	//     < NDRV_PFIV_II_metadata_line_7_____ooo strakhovaya kompaniya civ life_20231101 >									
117 	//        < 2x43kmcr51P6Kee32jHUimO3WowTlXSQ5cfWPd00VXVj91LQeHB7N6lYgx21go92 >									
118 	//        <  u =="0.000000000000000001" : ] 000000135833885.998880000000000000 ; 000000154264813.615301000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000CF441DEB63B1 >									
120 	//     < NDRV_PFIV_II_metadata_line_8_____inversiones magallanes sa_20231101 >									
121 	//        < Zj4425p39IMG1G1bvBK4kIbb9YE688vu45OUS5zOosD5c43IG79A3vbHH5KR46Cu >									
122 	//        <  u =="0.000000000000000001" : ] 000000154264813.615301000000000000 ; 000000182615261.957128000000000000 ] >									
123 	//        < 0x000000000000000000000000000000000000000000000000000EB63B1116A616 >									
124 	//     < NDRV_PFIV_II_metadata_line_9_____hdi seguros de vida sa_20231101 >									
125 	//        < nVF86gbkEe4a6GEGREIN2apx1ExVg3C3sZJJLPrBopQyrAM3OggIy9I0222O38rj >									
126 	//        <  u =="0.000000000000000001" : ] 000000182615261.957128000000000000 ; 000000198615525.335799000000000000 ] >									
127 	//        < 0x00000000000000000000000000000000000000000000000000116A61612F1031 >									
128 	//     < NDRV_PFIV_II_metadata_line_10_____winsor verwaltungs_ag_20231101 >									
129 	//        < euTudj1EcvT4KOnpOYK48G6fka2gONHr241CoHJ36wqlTTxU3V4qw000S2gTR7LF >									
130 	//        <  u =="0.000000000000000001" : ] 000000198615525.335799000000000000 ; 000000232198190.987012000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000012F10311624E6B >									
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
174 	//     < NDRV_PFIV_II_metadata_line_11_____gerling_konzern globale rückversicherungs_ag_20231101 >									
175 	//        < YIbsTWnY16e74AFafWkmJBQfchs3U1Qs4gt3SK77Pu46zhi4B72C04JuD2EHw2Wu >									
176 	//        <  u =="0.000000000000000001" : ] 000000232198190.987012000000000000 ; 000000249366956.148127000000000000 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000000001624E6B17C80F8 >									
178 	//     < NDRV_PFIV_II_metadata_line_12_____gerling gfp verwaltungs_ag_20231101 >									
179 	//        < 6DUU11dYqKsaObMY4g7SV297C9n68Jt38ye26WxNJMm1Nx92i5s5tzH6C17CLJYq >									
180 	//        <  u =="0.000000000000000001" : ] 000000249366956.148127000000000000 ; 000000286578401.637402000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000017C80F81B548B0 >									
182 	//     < NDRV_PFIV_II_metadata_line_13_____hdi kundenservice ag_20231101 >									
183 	//        < HE5P48D91NlpJuxk1lk7aHfrVBzpKdRgGDgn9SUWmL4YO9WJtHB9mECWtN6g2az5 >									
184 	//        <  u =="0.000000000000000001" : ] 000000286578401.637402000000000000 ; 000000307731514.082813000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001B548B01D58F9F >									
186 	//     < NDRV_PFIV_II_metadata_line_14_____beteiligungs gmbh co kg_20231101 >									
187 	//        < 3a7ASF324Um67HXiiiULjQj8PAtTaFTtm0J4b8nD86eRL39u4jE162HKX635X9ha >									
188 	//        <  u =="0.000000000000000001" : ] 000000307731514.082813000000000000 ; 000000333260523.924776000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000001D58F9F1FC83E4 >									
190 	//     < NDRV_PFIV_II_metadata_line_15_____talanx reinsurance broker gmbh_20231101 >									
191 	//        < 02804hI3nW7oP1BSq9NJy1Y76cE83CNOgZt96jdql2lyXGf14Sa69D16Yk8NG2Kb >									
192 	//        <  u =="0.000000000000000001" : ] 000000333260523.924776000000000000 ; 000000350458500.884943000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000001FC83E4216C1DA >									
194 	//     < NDRV_PFIV_II_metadata_line_16_____neue leben holding ag_20231101 >									
195 	//        < 99eE129OqwS5540qU9NYDczLYQvWx5Lj4Y2zhp7Y6mtZtAd0JCq9GWH9O24hKq1z >									
196 	//        <  u =="0.000000000000000001" : ] 000000350458500.884943000000000000 ; 000000367853869.184471000000000000 ] >									
197 	//        < 0x00000000000000000000000000000000000000000000000000216C1DA2314CEB >									
198 	//     < NDRV_PFIV_II_metadata_line_17_____neue leben unfallversicherung ag_20231101 >									
199 	//        < 47V1ZiXFpK6UrEAPP2ASR5DIY5F6v1vwyBbjXECcSp57oQyK86X99lExwbweiB0a >									
200 	//        <  u =="0.000000000000000001" : ] 000000367853869.184471000000000000 ; 000000387033416.357964000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000002314CEB24E90EE >									
202 	//     < NDRV_PFIV_II_metadata_line_18_____neue leben lebensversicherung ag_20231101 >									
203 	//        < BdK78ez8IedJl1J0alftddO007lKuRpw6w71066m2sUvMtgivup8k83O9oH8Dtny >									
204 	//        <  u =="0.000000000000000001" : ] 000000387033416.357964000000000000 ; 000000410814343.331630000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000024E90EE272DA5A >									
206 	//     < NDRV_PFIV_II_metadata_line_19_____pb versicherung ag_20231101 >									
207 	//        < 69aFYnykZkb5HxTUB8y9iDoI74BoLwWUCYujt0I3HuHIucGI00QD7r54J621HS2G >									
208 	//        <  u =="0.000000000000000001" : ] 000000410814343.331630000000000000 ; 000000451935705.547642000000000000 ] >									
209 	//        < 0x00000000000000000000000000000000000000000000000000272DA5A2B19963 >									
210 	//     < NDRV_PFIV_II_metadata_line_20_____talanx systeme ag_20231101 >									
211 	//        < 00mOA4K8C5mb3fw875Byu8dCEPsOIg3QE4v7mFeOPo5w9E2XROoi7NEO7VwvwEjt >									
212 	//        <  u =="0.000000000000000001" : ] 000000451935705.547642000000000000 ; 000000491134794.154304000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000002B199632ED6987 >									
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
256 	//     < NDRV_PFIV_II_metadata_line_21_____hdi seguros sa_20231101 >									
257 	//        < zn14rNbYHb70O5X7R716Rj5BLG141kxyKVgX0Q1F5MMkFReqFG0D5kuJ0XZ1e23z >									
258 	//        <  u =="0.000000000000000001" : ] 000000491134794.154304000000000000 ; 000000526272633.116627000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000002ED6987323073F >									
260 	//     < NDRV_PFIV_II_metadata_line_22_____talanx nassau assekuranzkontor gmbh_20231101 >									
261 	//        < C5mkNQ6YcY745d5Bo0LfHW18a29g1K78Q9x1fewzdHZq65u83icDOS6J03Eu57PR >									
262 	//        <  u =="0.000000000000000001" : ] 000000526272633.116627000000000000 ; 000000567621293.327726000000000000 ] >									
263 	//        < 0x00000000000000000000000000000000000000000000000000323073F3621F11 >									
264 	//     < NDRV_PFIV_II_metadata_line_23_____td real assets gmbh co kg_20231101 >									
265 	//        < yL2K4K68n030h20HUTbmD6ic975HQ39oB15dFCQZ17qxVyTfl09mmcHjgP7I9Rq7 >									
266 	//        <  u =="0.000000000000000001" : ] 000000567621293.327726000000000000 ; 000000616626668.271404000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000003621F113ACE5CB >									
268 	//     < NDRV_PFIV_II_metadata_line_24_____partner office ag_20231101 >									
269 	//        < LYJNMqoj9e9dVFI03KVO724oINn9u3764s8gg0rDwW7T1Tc0MJZ26sQ2KpO0CL9c >									
270 	//        <  u =="0.000000000000000001" : ] 000000616626668.271404000000000000 ; 000000654310705.626700000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000003ACE5CB3E6661F >									
272 	//     < NDRV_PFIV_II_metadata_line_25_____hgi alternative investments beteiligungs_gmbh co kg_20231101 >									
273 	//        < QYeTE8ZyHOdN7y783x1tyYkF5aG050rbK2HG9DSaK70596kLZ1426u6qrq7gL2RT >									
274 	//        <  u =="0.000000000000000001" : ] 000000654310705.626700000000000000 ; 000000697796826.862476000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000003E6661F428C0E3 >									
276 	//     < NDRV_PFIV_II_metadata_line_26_____ferme eolienne du mignaudières sarl_20231101 >									
277 	//        < SXG7DO1YUb2vi7UvUZNJaYgVj2L7jAuQHzqEnoSF5E6ySX29202rpIRCgyg59O29 >									
278 	//        <  u =="0.000000000000000001" : ] 000000697796826.862476000000000000 ; 000000737363626.189272000000000000 ] >									
279 	//        < 0x00000000000000000000000000000000000000000000000000428C0E346520AB >									
280 	//     < NDRV_PFIV_II_metadata_line_27_____talanx ag asset management arm_20231101 >									
281 	//        < 16ad8h1K9ekgkF8ytF6YS151832aVAF08GnhVd4lWza78PJe9Vxc4MOlx52TxkK8 >									
282 	//        <  u =="0.000000000000000001" : ] 000000737363626.189272000000000000 ; 000000775591313.969623000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000046520AB49F755B >									
284 	//     < NDRV_PFIV_II_metadata_line_28_____talanx bureau für versicherungswesen robert gerling & co gmbh_20231101 >									
285 	//        < A00VX3zUld1cdTb1D9kD7x9ei25h4gQBRe8V83faUZkSv67Kt59Xy7pCz3LS75UU >									
286 	//        <  u =="0.000000000000000001" : ] 000000775591313.969623000000000000 ; 000000799681332.223189000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000049F755B4C43785 >									
288 	//     < NDRV_PFIV_II_metadata_line_29_____pb pensionskasse aktiengesellschaft_20231101 >									
289 	//        < 87WQbw4g1jH05JYF9p8j8E6WnEdsJa1V28KlXQ3gjy576tTHXdQKMDr1Kpl095P3 >									
290 	//        <  u =="0.000000000000000001" : ] 000000799681332.223189000000000000 ; 000000817982908.570690000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000004C437854E02493 >									
292 	//     < NDRV_PFIV_II_metadata_line_30_____hdi direkt service gmbh_20231101 >									
293 	//        < fvK6mc8xF1HTTYW7ORtyxn19UhGyEoZA0KF1877o1hK2ifbL865D1kq1VguvkfN2 >									
294 	//        <  u =="0.000000000000000001" : ] 000000817982908.570690000000000000 ; 000000859483055.272588000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000004E0249351F7792 >									
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
338 	//     < NDRV_PFIV_II_metadata_line_31_____gerling immo spezial 1_20231101 >									
339 	//        < Y5mZJE7dDaCw3oW1X3UqLkU4a3h8b2Oc60XGg604u7q988zH250IF6KrtUOwvj28 >									
340 	//        <  u =="0.000000000000000001" : ] 000000859483055.272588000000000000 ; 000000903600099.342691000000000000 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000000000051F7792562C8CA >									
342 	//     < NDRV_PFIV_II_metadata_line_32_____gente compania de soluciones profesionales de mexico sa de cv_20231101 >									
343 	//        < a7391Qd9qgoSN311oUPEpah49jBeJdjgPrAq7845OS16RoHQuod0bE69C703eO6H >									
344 	//        <  u =="0.000000000000000001" : ] 000000903600099.342691000000000000 ; 000000922120638.987508000000000000 ] >									
345 	//        < 0x00000000000000000000000000000000000000000000000000562C8CA57F0B60 >									
346 	//     < NDRV_PFIV_II_metadata_line_33_____credit life international versicherung ag_20231101 >									
347 	//        < Bt1dZAc3jq4EEhqxhW7eH2Kju1dwRUG0sDoL7qWfYaO2zdQ53D54c3ih26b90O9A >									
348 	//        <  u =="0.000000000000000001" : ] 000000922120638.987508000000000000 ; 000000962579489.604980000000000000 ] >									
349 	//        < 0x0000000000000000000000000000000000000000000000000057F0B605BCC79D >									
350 	//     < NDRV_PFIV_II_metadata_line_34_____talanx pensionsmanagement ag_20231101 >									
351 	//        < RatG5L2w4ij8y3ft2N4X49e91k6HpamKeQE7u6dxKJ9aNWwDzF29Eg4F9tHcFVgf >									
352 	//        <  u =="0.000000000000000001" : ] 000000962579489.604980000000000000 ; 000001003244995.469020000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000005BCC79D5FAD494 >									
354 	//     < NDRV_PFIV_II_metadata_line_35_____talanx infrastructure portugal 2 gmbh_20231101 >									
355 	//        < 6yAJGcYzQyZ2XeHgj1M2B50id5nASh45w4pKXo9Enc0FmYi85EJ9YW4UKEj356NH >									
356 	//        <  u =="0.000000000000000001" : ] 000001003244995.469020000000000000 ; 000001019272553.505380000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000005FAD4946134957 >									
358 	//     < NDRV_PFIV_II_metadata_line_36_____pnh parque do novo hospital sa_20231101 >									
359 	//        < 0cpCshwjRI3q71sd220k97irkbKSGk1UiUSBWPgjOR5H5hm9H9kpk4M9R9Nuvo7r >									
360 	//        <  u =="0.000000000000000001" : ] 000001019272553.505380000000000000 ; 000001049565612.177240000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000061349576418291 >									
362 	//     < NDRV_PFIV_II_metadata_line_37_____aberdeen infrastructure holdco bv_20231101 >									
363 	//        < 6f6q8l9OQyLe2ccE96Tjokof6Y5fR2Wf3dIqp8N1doqhI8HcJHzvW5LNg0F92V9z >									
364 	//        <  u =="0.000000000000000001" : ] 000001049565612.177240000000000000 ; 000001089654079.232160000000000000 ] >									
365 	//        < 0x00000000000000000000000000000000000000000000000000641829167EAE20 >									
366 	//     < NDRV_PFIV_II_metadata_line_38_____escala vila franca sociedade gestora do edifício sa_20231101 >									
367 	//        < sW7NPnT3mI5IwH7xcDKP4kpVtAFVW9qz1jAImM2vWM555om8932U2O5j5Y02OOcZ >									
368 	//        <  u =="0.000000000000000001" : ] 000001089654079.232160000000000000 ; 000001126750535.712960000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000067EAE206B748EE >									
370 	//     < NDRV_PFIV_II_metadata_line_39_____pnh parque do novo hospital sa_20231101 >									
371 	//        < WgIJX1lofMWbvbF4M38o8S7lD1q4vO62Mr7KC4B6x17sGGVZO4lYy721VofghB90 >									
372 	//        <  u =="0.000000000000000001" : ] 000001126750535.712960000000000000 ; 000001145439933.884130000000000000 ] >									
373 	//        < 0x000000000000000000000000000000000000000000000000006B748EE6D3CD79 >									
374 	//     < NDRV_PFIV_II_metadata_line_40_____tunz warta sa_20231101 >									
375 	//        < B3g0n1n1ZR8d175UPZ1r6zORB1WK4w99Yq767hh73OVrzc2zD65bH7N0kz7QJ58m >									
376 	//        <  u =="0.000000000000000001" : ] 000001145439933.884130000000000000 ; 000001173533492.794600000000000000 ] >									
377 	//        < 0x000000000000000000000000000000000000000000000000006D3CD796FEAB85 >									
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