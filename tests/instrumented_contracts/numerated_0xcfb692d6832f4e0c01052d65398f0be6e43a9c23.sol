1 pragma solidity 		^0.4.25	;						
2 										
3 	contract	CHEMCHINA_PFI_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	CHEMCHINA_PFI_III_883		"	;
8 		string	public		symbol =	"	CHEMCHINA_PFI_III_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1213833938484360000000000000					;	
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
92 	//     < CHEMCHINA_PFI_III_metadata_line_1_____001Chemical_20260321 >									
93 	//        < qN88797t8w14K5V868LKuZqQo00e8jGkx79PR20CglRr809MAGQ7rUTVhK9A7G9n >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000039936607.568704100000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000003CF03D >									
96 	//     < CHEMCHINA_PFI_III_metadata_line_2_____3B_Scientific__Wuhan__Corporation_Limited_20260321 >									
97 	//        < lS8Q2zu8ZlXeE28C0x0pUFQnQ9BiEsFXZK5t9awwRxw2mCJExabs5T14GZCajojC >									
98 	//        <  u =="0.000000000000000001" : ] 000000039936607.568704100000000000 ; 000000072199845.551629700000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000003CF03D6E2B11 >									
100 	//     < CHEMCHINA_PFI_III_metadata_line_3_____3Way_Pharm_inc__20260321 >									
101 	//        < 2EfHfia13lI59K1OfbqS1O4ua82ZPopEeGSXLhYEWz0x2UyFTKk6KA4i7khtV39t >									
102 	//        <  u =="0.000000000000000001" : ] 000000072199845.551629700000000000 ; 000000105359901.315756000000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000006E2B11A0C436 >									
104 	//     < CHEMCHINA_PFI_III_metadata_line_4_____Acemay_Biochemicals_20260321 >									
105 	//        < n8i1LGjYzg6cPZLbE0isa0vV7IWv3QD2E1l5nZ37TR2lo9dHX5b5e30Pub0C17S4 >									
106 	//        <  u =="0.000000000000000001" : ] 000000105359901.315756000000000000 ; 000000130203297.169852000000000000 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000000000A0C436C6ACAA >									
108 	//     < CHEMCHINA_PFI_III_metadata_line_5_____Aemon_Chemical_Technology_Co_Limited_20260321 >									
109 	//        < FUGcqHz94MqU1jD7dd86ENW0t7yj2xqbIi5Qkj007E2Ocg125DYcZdL2ng32TX3v >									
110 	//        <  u =="0.000000000000000001" : ] 000000130203297.169852000000000000 ; 000000153891444.659095000000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000C6ACAAEAD1D8 >									
112 	//     < CHEMCHINA_PFI_III_metadata_line_6_____AgileBioChem_Co_Limited_20260321 >									
113 	//        < FxhiU9QdGppBqf6Ni7Y71h8H7k6NqKeBK104x14eHmql3w3K91G3XaIM6L4uogKW >									
114 	//        <  u =="0.000000000000000001" : ] 000000153891444.659095000000000000 ; 000000185642335.745803000000000000 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000000000EAD1D811B448A >									
116 	//     < CHEMCHINA_PFI_III_metadata_line_7_____Aktin_Chemicals,_inc__20260321 >									
117 	//        < 7XahVIu0VH92PI2oh4ADYwrS8tt4xMln70GgavSvghr8HgSSLC65Vpz8VN7fa08o >									
118 	//        <  u =="0.000000000000000001" : ] 000000185642335.745803000000000000 ; 000000207660696.383510000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000011B448A13CDD76 >									
120 	//     < CHEMCHINA_PFI_III_metadata_line_8_____Aktin_Chemicals,_org_20260321 >									
121 	//        < y71loU45EboWufdRH36n8Bygzq5uA85K08EH3wZT0AjZiV8O4xc0Z9Fe8J9oaBth >									
122 	//        <  u =="0.000000000000000001" : ] 000000207660696.383510000000000000 ; 000000231642861.116831000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000013CDD76161757E >									
124 	//     < CHEMCHINA_PFI_III_metadata_line_9_____Angene_International_Limited_20260321 >									
125 	//        < oq2C33Z20tbX55cRsj0G8j98iLbAmGokNKbrz8i3229ALKgvqSVOkv0E14IPHniB >									
126 	//        <  u =="0.000000000000000001" : ] 000000231642861.116831000000000000 ; 000000257166714.600002000000000000 ] >									
127 	//        < 0x00000000000000000000000000000000000000000000000000161757E18867BF >									
128 	//     < CHEMCHINA_PFI_III_metadata_line_10_____ANSHAN_HIFI_CHEMICALS_Co__Limited_20260321 >									
129 	//        < RVOg32Q8n1C0r4zU21Ve7OaL88UZMlHfrb7l3p5e49D6cJFg5P4R8r0698AkkNzb >									
130 	//        <  u =="0.000000000000000001" : ] 000000257166714.600002000000000000 ; 000000287467068.765277000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000018867BF1B6A3D3 >									
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
174 	//     < CHEMCHINA_PFI_III_metadata_line_11_____Aromalake_Chemical_Corporation_Limited_20260321 >									
175 	//        < 3JPC6tJWmG3T32cVX54V67l62V39Xp4Xj95QFmAFV99H725PCcD9Q8OH5JuY3115 >									
176 	//        <  u =="0.000000000000000001" : ] 000000287467068.765277000000000000 ; 000000325237395.267684000000000000 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000000001B6A3D31F045DC >									
178 	//     < CHEMCHINA_PFI_III_metadata_line_12_____Aromsyn_Co_Limited_20260321 >									
179 	//        < 6vHi4BOEueH11m21xM6LtgnYHlW8NPq57LNWCCV7Jj9uN83k6cEsd60iIBk5eX6y >									
180 	//        <  u =="0.000000000000000001" : ] 000000325237395.267684000000000000 ; 000000359058597.796420000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000001F045DC223E144 >									
182 	//     < CHEMCHINA_PFI_III_metadata_line_13_____Arromax_Pharmatech_Co__Limited_20260321 >									
183 	//        < 62BAqP5wJ2q1XQGfgnL7N3VxOib8813sDCeZjtL2hp7954V0MB6A2D710d8zhC7C >									
184 	//        <  u =="0.000000000000000001" : ] 000000359058597.796420000000000000 ; 000000378065305.470288000000000000 ] >									
185 	//        < 0x00000000000000000000000000000000000000000000000000223E144240E1C3 >									
186 	//     < CHEMCHINA_PFI_III_metadata_line_14_____Asambly_Chemicals_Co_Limited_20260321 >									
187 	//        < Xy814FOh7277x6J4528JWCJdFBsBRzu78CZjklICvUH7058z5pwIaD016QC56GF1 >									
188 	//        <  u =="0.000000000000000001" : ] 000000378065305.470288000000000000 ; 000000419745846.504067000000000000 ] >									
189 	//        < 0x00000000000000000000000000000000000000000000000000240E1C32807B39 >									
190 	//     < CHEMCHINA_PFI_III_metadata_line_15_____Atomax_Chemicals_Co__Limited_20260321 >									
191 	//        < 3mUe9yM8Y1jBdBibwkRhdAW28tVsrh43HqQ0zignXc0p6oMK3v6zSOX951s53AOg >									
192 	//        <  u =="0.000000000000000001" : ] 000000419745846.504067000000000000 ; 000000442158338.315080000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000002807B392A2AE1A >									
194 	//     < CHEMCHINA_PFI_III_metadata_line_16_____Atomax_Chemicals_org_20260321 >									
195 	//        < sjVv1GQt56dlZAo7m05iuk6JX1N7Z3C5avdN7dVPif4Y2d4Fb7h9WpOb9844842X >									
196 	//        <  u =="0.000000000000000001" : ] 000000442158338.315080000000000000 ; 000000464926254.181782000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000002A2AE1A2C56BD1 >									
198 	//     < CHEMCHINA_PFI_III_metadata_line_17_____Beijing_Pure_Chem__Co_Limited_20260321 >									
199 	//        < DvU18vL4d89qPE7H4iy7XBFS3Htx253t4lxN9QRoKNOffrn419seMcBKIcWFZJ9C >									
200 	//        <  u =="0.000000000000000001" : ] 000000464926254.181782000000000000 ; 000000502706555.569137000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000002C56BD12FF11C0 >									
202 	//     < CHEMCHINA_PFI_III_metadata_line_18_____BEIJING_SHLHT_CHEMICAL_TECHNOLOGY_20260321 >									
203 	//        < IE6a5J57l6417SQ8sJl4GsSP4XsDSq73vs1W57C508uY4SBLA89XrFwHt07UWMBg >									
204 	//        <  u =="0.000000000000000001" : ] 000000502706555.569137000000000000 ; 000000529007195.527301000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000002FF11C03273370 >									
206 	//     < CHEMCHINA_PFI_III_metadata_line_19_____Beijing_Smart_Chemicals_Co_Limited_20260321 >									
207 	//        < gY7Kx0s9yCPWP58RxnLaS3XpQ6XTNb53JqkX21dN58KoP7I8E66SzLa0H8Y29X8v >									
208 	//        <  u =="0.000000000000000001" : ] 000000529007195.527301000000000000 ; 000000553404833.212806000000000000 ] >									
209 	//        < 0x00000000000000000000000000000000000000000000000000327337034C6DC3 >									
210 	//     < CHEMCHINA_PFI_III_metadata_line_20_____Beijing_Stable_Chemical_Co_Limited_20260321 >									
211 	//        < DcrKo8BIbNELW9CMd4zWgg6H41l3w1A2ov9OsNLc6O46qYl13OX3YY25vIbCD4i4 >									
212 	//        <  u =="0.000000000000000001" : ] 000000553404833.212806000000000000 ; 000000586002922.926323000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000034C6DC337E2B64 >									
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
256 	//     < CHEMCHINA_PFI_III_metadata_line_21_____Beijing_Sunpu_Biochem___Tech__Co__Limited_20260321 >									
257 	//        < 805L96ahNjR592zUV9kiq6Ub03q9092n504d8uwq59Qpa9T7N70Q542Em41C1562 >									
258 	//        <  u =="0.000000000000000001" : ] 000000586002922.926323000000000000 ; 000000615126727.079090000000000000 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000000037E2B643AA9BE1 >									
260 	//     < CHEMCHINA_PFI_III_metadata_line_22_____Bellen_Chemistry_Co__Limited_20260321 >									
261 	//        < tdJn9caYrS7S2tpkCWn2fl4EI29rbTfn10pWxg4O65AOOi59j3f98Tny3jqDM7aS >									
262 	//        <  u =="0.000000000000000001" : ] 000000615126727.079090000000000000 ; 000000656449717.352935000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000003AA9BE13E9A9AC >									
264 	//     < CHEMCHINA_PFI_III_metadata_line_23_____BEYO_CHEMICAL_Co__Limited_20260321 >									
265 	//        < iJ99RJZA0fl98Hsw0cJGpnyrE87sC6WI94B09RumArQ9a6LqrJ9P9Ah3cW0LMTw0 >									
266 	//        <  u =="0.000000000000000001" : ] 000000656449717.352935000000000000 ; 000000698991865.939052000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000003E9A9AC42A93B3 >									
268 	//     < CHEMCHINA_PFI_III_metadata_line_24_____Beyond_Pharmaceutical_Co_Limited_20260321 >									
269 	//        < 5Qdz84ZhG0sHF8Wa9r95f1SftHJ6ysOU2N6FYHOD5B57K6H4NuG32MB56gU8XZEz >									
270 	//        <  u =="0.000000000000000001" : ] 000000698991865.939052000000000000 ; 000000729712241.686914000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000042A93B345973D8 >									
272 	//     < CHEMCHINA_PFI_III_metadata_line_25_____Binhai_Gaolou_Chemical_Co_Limited_20260321 >									
273 	//        < 22gc3Mma15wjLM1uyYJCaO31lnTnt0Ss0IfJf905Td8G145QvUGyj1KmmetB33a4 >									
274 	//        <  u =="0.000000000000000001" : ] 000000729712241.686914000000000000 ; 000000765402849.838627000000000000 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000000000045973D848FE97D >									
276 	//     < CHEMCHINA_PFI_III_metadata_line_26_____Binhong_Industry_Co__Limited_20260321 >									
277 	//        < TMDQpik0Q3aN9uSUD4Q0JAVbfeiVEP9N5MCArxcWV5UTF38R2cuv2xIHAK27Z881 >									
278 	//        <  u =="0.000000000000000001" : ] 000000765402849.838627000000000000 ; 000000794722131.855516000000000000 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000000000048FE97D4BCA655 >									
280 	//     < CHEMCHINA_PFI_III_metadata_line_27_____BLD_Pharmatech_org_20260321 >									
281 	//        < 91B1X2kHG7L5KWRE0w6AXLN9K5npIpIopkbfnQAo7n2qAFWz2JwB6q1QsXXAo33v >									
282 	//        <  u =="0.000000000000000001" : ] 000000794722131.855516000000000000 ; 000000827257404.827000000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000004BCA6554EE4B6C >									
284 	//     < CHEMCHINA_PFI_III_metadata_line_28_____BLD_Pharmatech_Limited_20260321 >									
285 	//        < BvNa7570168MR5F26eTWNZNta99GaYW3P4eiX2F2b05FLQBroNqzP50D9JCFhc3O >									
286 	//        <  u =="0.000000000000000001" : ] 000000827257404.827000000000000000 ; 000000856531101.304754000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000004EE4B6C51AF676 >									
288 	//     < CHEMCHINA_PFI_III_metadata_line_29_____Bocchem_20260321 >									
289 	//        < B4j5O430C99UrwZKXPZBr59b5ZIrxtyQmj9KN41p56NpW8Y2GkefQ6C7RYZM3hYt >									
290 	//        <  u =="0.000000000000000001" : ] 000000856531101.304754000000000000 ; 000000897351208.739645000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000051AF6765593FD1 >									
292 	//     < CHEMCHINA_PFI_III_metadata_line_30_____Boroncore_LLC_20260321 >									
293 	//        < U24ze7O5IgeBY0ikQn7H20c0U1QWpI5vck8n54PKc0u5IeYQRY0Xk3sb6vHOjejB >									
294 	//        <  u =="0.000000000000000001" : ] 000000897351208.739645000000000000 ; 000000926474696.153416000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000005593FD1585B02E >									
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
338 	//     < CHEMCHINA_PFI_III_metadata_line_31_____BTC_Pharmaceuticals_Co_Limited_20260321 >									
339 	//        < x29R03c06981gtgQEydGtO5qcd35nSycdi3m338qD7Ip51fWHm47IiHN5angP5Cs >									
340 	//        <  u =="0.000000000000000001" : ] 000000926474696.153416000000000000 ; 000000946694123.062598000000000000 ] >									
341 	//        < 0x00000000000000000000000000000000000000000000000000585B02E5A48A64 >									
342 	//     < CHEMCHINA_PFI_III_metadata_line_32_____Cangzhou_Goldlion_Chemicals_Co_Limited_20260321 >									
343 	//        < 0HGtVoYov4eMjCwc9m8x5iEQ97C069HB55qBdYtd24kNG04F1h6KmyA4nvyulg1s >									
344 	//        <  u =="0.000000000000000001" : ] 000000946694123.062598000000000000 ; 000000975968056.825869000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000005A48A645D13586 >									
346 	//     < CHEMCHINA_PFI_III_metadata_line_33_____Capot_Chemical_Co_Limited_20260321 >									
347 	//        < 5p566XUQCbwLB79bD93F2A8xobz27z11m12Tcbk6GLT3i3fIZ1i7viS5YD39hbCy >									
348 	//        <  u =="0.000000000000000001" : ] 000000975968056.825869000000000000 ; 000001009513207.405720000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000005D135866046519 >									
350 	//     < CHEMCHINA_PFI_III_metadata_line_34_____CBS_TECHNOLOGY_LTD_20260321 >									
351 	//        < MztGfrkd9gLL1Srm9UzNayDVN057Ih64Hima039c0bSEBo9pQY9zib9uXK3BDsQc >									
352 	//        <  u =="0.000000000000000001" : ] 000001009513207.405720000000000000 ; 000001040861461.985870000000000000 ] >									
353 	//        < 0x0000000000000000000000000000000000000000000000000060465196343A82 >									
354 	//     < CHEMCHINA_PFI_III_metadata_line_35_____Changzhou_Carbochem_Co_Limited_20260321 >									
355 	//        < E46qcm7nPOV0142qe2IXwt8PgKNsK67C3tiXhXLtl9gu8bM9aM9OR7L2RutFM87Q >									
356 	//        <  u =="0.000000000000000001" : ] 000001040861461.985870000000000000 ; 000001071648909.835650000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000006343A8266334DB >									
358 	//     < CHEMCHINA_PFI_III_metadata_line_36_____Changzhou_Hengda_Biotechnology_Co__org_20260321 >									
359 	//        < c7J5sM0bkyjqr0ny684xz73evPFw7948EABqQF9E3UA2QX4O5kph3i2P7D52418C >									
360 	//        <  u =="0.000000000000000001" : ] 000001071648909.835650000000000000 ; 000001098758947.914410000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000066334DB68C92B7 >									
362 	//     < CHEMCHINA_PFI_III_metadata_line_37_____Changzhou_Hengda_Biotechnology_Co__Limited_20260321 >									
363 	//        < 0XmKxap3l7M06sQHxT7K38GWxE1jXfWwsyo0y1GzWJUmbkVq01RV3Ax9C58z39Y3 >									
364 	//        <  u =="0.000000000000000001" : ] 000001098758947.914410000000000000 ; 000001135198858.872740000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000068C92B76C42D0E >									
366 	//     < CHEMCHINA_PFI_III_metadata_line_38_____Changzhou_LanXu_Chemical_Co_Limited_20260321 >									
367 	//        < 4TDIrhG7Wu9eogrZm3FTih4bgo2Q2cR5z32nbQ3Hz525He850ZSm1s6H1rSD48D6 >									
368 	//        <  u =="0.000000000000000001" : ] 000001135198858.872740000000000000 ; 000001170373068.403370000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000006C42D0E6F9D8FB >									
370 	//     < CHEMCHINA_PFI_III_metadata_line_39_____Changzhou_Standard_Chemicals_Co_Limited_20260321 >									
371 	//        < 0q645Nn89CL338J9p5n26Z2a6K9W3VI8CqE6et4S5zfIPZjE5vJINVe937Uo4x7N >									
372 	//        <  u =="0.000000000000000001" : ] 000001170373068.403370000000000000 ; 000001190483962.162420000000000000 ] >									
373 	//        < 0x000000000000000000000000000000000000000000000000006F9D8FB71888CC >									
374 	//     < CHEMCHINA_PFI_III_metadata_line_40_____CHANGZHOU_WEIJIA_CHEMICAL_Co_Limited_20260321 >									
375 	//        < f0bww70uzj8M1i7bxDFh3x475I5G5pmN7fGnTc79z4o06f9supAYlZP65b03ppKo >									
376 	//        <  u =="0.000000000000000001" : ] 000001190483962.162420000000000000 ; 000001213833938.484360000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000071888CC73C29E2 >									
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