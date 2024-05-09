1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	NDRV_PFV_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	NDRV_PFV_III_883		"	;
8 		string	public		symbol =	"	NDRV_PFV_III_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1910474611608440000000000000					;	
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
92 	//     < NDRV_PFV_III_metadata_line_1_____talanx primary insurance group_20251101 >									
93 	//        < KG4ctam18oEiuQv35Eqr3UfLmt1iML40Qg78jJ9VcGuVNO68OvW1aMt1Ff8nE4v4 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000042589615.897509700000000000 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000000040FC92 >									
96 	//     < NDRV_PFV_III_metadata_line_2_____primary_pensions_20251101 >									
97 	//        < 59gMV96858yR83S5r6ATEYvfS44d4HVoE9oE05X72ul3gMOS8533S0Kr6L26z68n >									
98 	//        <  u =="0.000000000000000001" : ] 000000042589615.897509700000000000 ; 000000096236947.808051400000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000040FC9292D88F >									
100 	//     < NDRV_PFV_III_metadata_line_3_____hdi rechtsschutz ag_20251101 >									
101 	//        < AnP10u7skfDEVhLk784paZ08dAFW8O2BE82z877ya29i57Ub1WW3y787WFRHOP75 >									
102 	//        <  u =="0.000000000000000001" : ] 000000096236947.808051400000000000 ; 000000190827391.101527000000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000092D88F1232DF3 >									
104 	//     < NDRV_PFV_III_metadata_line_4_____Gerling Insurance Of South Africa Ltd_20251101 >									
105 	//        < 2Ib3sJM30wljWSi7Tnl0BSRnP9T7R6ZICO0IYr45309uN5drTvwp4ia23wCwUUGK >									
106 	//        <  u =="0.000000000000000001" : ] 000000190827391.101527000000000000 ; 000000228946796.230624000000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000001232DF315D5858 >									
108 	//     < NDRV_PFV_III_metadata_line_5_____Gerling Global Life Sweden Reinsurance Co LTd_20251101 >									
109 	//        < nGLwK76kdzfR6IRvj2tl9yt4Akp2U5zR4kSFF36g4rtO6d7711AQOWi3XZQSS9b8 >									
110 	//        <  u =="0.000000000000000001" : ] 000000228946796.230624000000000000 ; 000000272156511.736473000000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000015D585819F4723 >									
112 	//     < NDRV_PFV_III_metadata_line_6_____Amtrust Corporate Member Ltd_20251101 >									
113 	//        < CQ8PlpteRL2lJTbBLM07k27u07LB189f9jq7DSuOgP2u9ZofCe4Yfdcb423dxX8G >									
114 	//        <  u =="0.000000000000000001" : ] 000000272156511.736473000000000000 ; 000000337259852.030440000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000019F47232029E21 >									
116 	//     < NDRV_PFV_III_metadata_line_7_____HDI_Gerling Australia Insurance Company Pty Ltd_20251101 >									
117 	//        < 8hZ75Q2O6qXshTK9bVf4kJKo52ujz13Htj4vC1z06VN1Tm4qnD8Wvo5rgwK69QEj >									
118 	//        <  u =="0.000000000000000001" : ] 000000337259852.030440000000000000 ; 000000376281728.294519000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000002029E2123E290D >									
120 	//     < NDRV_PFV_III_metadata_line_8_____Gerling Institut GIBA_20251101 >									
121 	//        < chBHaZ8BEc5Oa45zIT9UKvt284sfBJ9RjcR5gEjY7XmJyDj83S3mL6HDjsOid3tl >									
122 	//        <  u =="0.000000000000000001" : ] 000000376281728.294519000000000000 ; 000000418554462.571547000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000023E290D27EA9D6 >									
124 	//     < NDRV_PFV_III_metadata_line_9_____Gerling_org_20251101 >									
125 	//        < 3DvCEcze3B9kxGTb88PhsU4C6kMs723BvC5kbY7Li10d7A6lIHM6e75jiFQ2dYl5 >									
126 	//        <  u =="0.000000000000000001" : ] 000000418554462.571547000000000000 ; 000000477565998.718189000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000027EA9D62D8B538 >									
128 	//     < NDRV_PFV_III_metadata_line_10_____Gerling_Holdings_20251101 >									
129 	//        < 8vk3wxzcw6O8eCus6MVmi6xYYeL9K63K63iYJT75Pf9g3MNr99i0eJ6OPWd8Oesr >									
130 	//        <  u =="0.000000000000000001" : ] 000000477565998.718189000000000000 ; 000000511367460.923697000000000000 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000000002D8B53830C48EA >									
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
174 	//     < NDRV_PFV_III_metadata_line_11_____Gerling_Pensions_20251101 >									
175 	//        < fDh55dSYQIWe856se5kr1Fe0IeXiumz31nk5p1208r9zvS6ue6k6eH947u3y8950 >									
176 	//        <  u =="0.000000000000000001" : ] 000000511367460.923697000000000000 ; 000000537837853.353632000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000030C48EA334ACE9 >									
178 	//     < NDRV_PFV_III_metadata_line_12_____talanx international ag_20251101 >									
179 	//        < GDgKm9p7cueqOVj0QSCd5SH6r74nShCs94I010BDhyRwaTPV4ub7N5c42PWkMbpB >									
180 	//        <  u =="0.000000000000000001" : ] 000000537837853.353632000000000000 ; 000000619929590.335821000000000000 ] >									
181 	//        < 0x00000000000000000000000000000000000000000000000000334ACE93B1EFFF >									
182 	//     < NDRV_PFV_III_metadata_line_13_____tuir warta_20251101 >									
183 	//        < AEEU06WNmM4XkK90b9F2UO5Ezhs11N0mtHpI5KYG31ht7q2uFp8fhHglC5dac875 >									
184 	//        <  u =="0.000000000000000001" : ] 000000619929590.335821000000000000 ; 000000658440031.004939000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000003B1EFFF3ECB323 >									
186 	//     < NDRV_PFV_III_metadata_line_14_____tuir warta_org_20251101 >									
187 	//        < 05q6QaXF6D4FzjTTd44dzyPVI388682BL140yPGX2hFzxQ10D463eB6zXnVQ99Qj >									
188 	//        <  u =="0.000000000000000001" : ] 000000658440031.004939000000000000 ; 000000679368771.613549000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000003ECB32340CA26D >									
190 	//     < NDRV_PFV_III_metadata_line_15_____towarzystwo ubezpieczen na zycie warta sa_20251101 >									
191 	//        < cu7oHw07Oz99o3pBYRAY6mLu5cU237HEeBWKFhnEBL32Tr4w8EGpVRruVnjt69ZK >									
192 	//        <  u =="0.000000000000000001" : ] 000000679368771.613549000000000000 ; 000000705567962.630880000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000040CA26D4349C7C >									
194 	//     < NDRV_PFV_III_metadata_line_16_____HDI-Gerling Zycie Towarzystwo Ubezpieczen Spolka Akcyjna_20251101 >									
195 	//        < tx9D4EGi9fb9Fw87Z7sYLXfn3ku24PpAb5Bt9d0zXWIxHm1Zfdp9H38H5MWWu08J >									
196 	//        <  u =="0.000000000000000001" : ] 000000705567962.630880000000000000 ; 000000745911116.028055000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000004349C7C4722B88 >									
198 	//     < NDRV_PFV_III_metadata_line_17_____TUiR Warta SA Asset Management Arm_20251101 >									
199 	//        < 026kq691h6lZ465R8op8BDN15Cb1loWP556UzW0mb7p3i1uHQZ84s6e0I3Rf82IN >									
200 	//        <  u =="0.000000000000000001" : ] 000000745911116.028055000000000000 ; 000000796701379.973674000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000004722B884BFAB7A >									
202 	//     < NDRV_PFV_III_metadata_line_18_____HDI Seguros SA de CV_20251101 >									
203 	//        < 71zAGl1974kfDbgCpQPHvfmXAQCRS7Un00LJtltn3Wu11HH3JR4sYE9iN4Sq6RQK >									
204 	//        <  u =="0.000000000000000001" : ] 000000796701379.973674000000000000 ; 000000816865306.758990000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000004BFAB7A4DE7003 >									
206 	//     < NDRV_PFV_III_metadata_line_19_____Towarzystwo Ubezpieczen Europa SA_20251101 >									
207 	//        < 3eEUYTv2M0i0f5537dKxPt08J1WVw5aO4Nn26EgxP3n4yh802okKBiX3CSlEJe9D >									
208 	//        <  u =="0.000000000000000001" : ] 000000816865306.758990000000000000 ; 000000876266871.284998000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000004DE700353913BF >									
210 	//     < NDRV_PFV_III_metadata_line_20_____Towarzystwo Ubezpieczen Na Zycie EUROPA SA_20251101 >									
211 	//        < 3aduF8R9e9M1S7xa44jLXpWfWc4ZO5vsN63iD7a66rXpFEKHphX7dmTQD850SB5O >									
212 	//        <  u =="0.000000000000000001" : ] 000000876266871.284998000000000000 ; 000000944874879.152858000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000053913BF5A1C3C0 >									
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
256 	//     < NDRV_PFV_III_metadata_line_21_____TU na ycie EUROPA SA_20251101 >									
257 	//        < FdZsUjuT5XUDCJ7wkanK1tG88fl03pX2C4JnHO7hrJiZ28bO1zd7auZ706f1B76p >									
258 	//        <  u =="0.000000000000000001" : ] 000000944874879.152858000000000000 ; 000000980527015.155292000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000005A1C3C05D82A5E >									
260 	//     < NDRV_PFV_III_metadata_line_22_____Liberty Sigorta_20251101 >									
261 	//        < 8ZY0O6xnY3DR7P9971w96mx6h734a62eDU3zy1979266Dj73H7702M8254FEXn92 >									
262 	//        <  u =="0.000000000000000001" : ] 000000980527015.155292000000000000 ; 000001021927867.013220000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000005D82A5E6175693 >									
264 	//     < NDRV_PFV_III_metadata_line_23_____Aspecta Versicherung Ag_20251101 >									
265 	//        < 1D00y1hK2igq18dmkitUN968UvbGNP2fErDsJLcuDo6C012ejD0J1cUpy5P88y1o >									
266 	//        <  u =="0.000000000000000001" : ] 000001021927867.013220000000000000 ; 000001099881605.212380000000000000 ] >									
267 	//        < 0x00000000000000000000000000000000000000000000000000617569368E4941 >									
268 	//     < NDRV_PFV_III_metadata_line_24_____HDI Sigorta AS_20251101 >									
269 	//        < iPkdFYY4YvEfrVUsaXJu86slyXAP5gRDCy4p14RF6WQJHHmIthCVIVGFRz7Jz0mG >									
270 	//        <  u =="0.000000000000000001" : ] 000001099881605.212380000000000000 ; 000001153294261.557370000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000068E49416DFC992 >									
272 	//     < NDRV_PFV_III_metadata_line_25_____HDI Seguros SA_20251101 >									
273 	//        < k33rH0XbCEkdcBLr1W54W35LLid2qF3GuBg39rd37c6Sx10O7g6Phio4IFO9fbtM >									
274 	//        <  u =="0.000000000000000001" : ] 000001153294261.557370000000000000 ; 000001177861658.019410000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000006DFC9927054636 >									
276 	//     < NDRV_PFV_III_metadata_line_26_____Aseguradora Magallanes SA_20251101 >									
277 	//        < hj4N6C370ptnCni0j9n43K2GeE2rMGaMDMzIxj71c0O74PS3WaU79mHQJ83J79H2 >									
278 	//        <  u =="0.000000000000000001" : ] 000001177861658.019410000000000000 ; 000001209418351.920810000000000000 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000000000070546367356D0B >									
280 	//     < NDRV_PFV_III_metadata_line_27_____Asset Management Arm_20251101 >									
281 	//        < d7Q72CMDXmdxBK27v1YIDnmy70CqCyGVGrz36hpTq17Mb8bl4M1eAa5d07sG5OFo >									
282 	//        <  u =="0.000000000000000001" : ] 000001209418351.920810000000000000 ; 000001245079667.036640000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000007356D0B76BD73F >									
284 	//     < NDRV_PFV_III_metadata_line_28_____HDI Assicurazioni SpA_20251101 >									
285 	//        < xW1SPsIFWmrf4ZLi8fc4x7YtrofaBDFn4FkLcpIZZCNq0LfbVOgl6v2bQQ6Q4zjB >									
286 	//        <  u =="0.000000000000000001" : ] 000001245079667.036640000000000000 ; 000001267342897.583190000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000076BD73F78DCFD2 >									
288 	//     < NDRV_PFV_III_metadata_line_29_____InChiaro Assicurazioni SPA_20251101 >									
289 	//        < HQd0gd56aM9EOBg61hd76iry5L97VD70TlwK0gmJ9p6MwsxVDY8NYfhhIh3e4cUj >									
290 	//        <  u =="0.000000000000000001" : ] 000001267342897.583190000000000000 ; 000001326645765.025700000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000078DCFD27E84D01 >									
292 	//     < NDRV_PFV_III_metadata_line_30_____Inlinea SpA_20251101 >									
293 	//        < 3l45F5Vmd3389qo72pY30Wzac0P21dkj99U1v6UKzl3k2333S6tH3C13DK21w1uX >									
294 	//        <  u =="0.000000000000000001" : ] 000001326645765.025700000000000000 ; 000001411627188.905020000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000007E84D01869F8DF >									
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
338 	//     < NDRV_PFV_III_metadata_line_31_____Inversiones HDI Limitada_20251101 >									
339 	//        < 2K3N2w5dDs801F31Gh038wmm0AlTZq8ys47tyy97T1qGmotqT5LN49VAe4R04dIV >									
340 	//        <  u =="0.000000000000000001" : ] 000001411627188.905020000000000000 ; 000001449130190.846340000000000000 ] >									
341 	//        < 0x00000000000000000000000000000000000000000000000000869F8DF8A3327B >									
342 	//     < NDRV_PFV_III_metadata_line_32_____HDI Seguros de Garantía y Crédito SA_20251101 >									
343 	//        < 5gDDVTM9n211pR9W83S9MhXkwOTEAR310erR0HmvVl6KZ0I4Z01dL3W74ilh343K >									
344 	//        <  u =="0.000000000000000001" : ] 000001449130190.846340000000000000 ; 000001478708284.642800000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000008A3327B8D0546C >									
346 	//     < NDRV_PFV_III_metadata_line_33_____HDI Seguros_20251101 >									
347 	//        < Dl39nB1MTeE2xx8wgT7m36IosST6xgvo1n3I8W00scWD7h3W7795AAcN986lWD33 >									
348 	//        <  u =="0.000000000000000001" : ] 000001478708284.642800000000000000 ; 000001552860594.099310000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000008D0546C9417A2B >									
350 	//     < NDRV_PFV_III_metadata_line_34_____HDI Seguros_Holdings_20251101 >									
351 	//        < EAbhx0YDLt6G141N810vMAQzNQZ107tx4a3N2hh1Yh7fd3o4fvzyF6J9u270MPDB >									
352 	//        <  u =="0.000000000000000001" : ] 000001552860594.099310000000000000 ; 000001642778923.482200000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000009417A2B9CAAE84 >									
354 	//     < NDRV_PFV_III_metadata_line_35_____Aseguradora Magallanes Peru SA Compania De Seguros_20251101 >									
355 	//        < u2237173QJOTjR1diUZ85ci8K36oU91vvBLd7UN4jS5uc4CCoCL1aKO49kYE0N7o >									
356 	//        <  u =="0.000000000000000001" : ] 000001642778923.482200000000000000 ; 000001713134891.940710000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000009CAAE84A360951 >									
358 	//     < NDRV_PFV_III_metadata_line_36_____Saint Honoré Iberia SL_20251101 >									
359 	//        < uipanEW36xnmi6dCl1HFZ8o8C0Udd9RbvatJcHXD8x5F9QvODGH47a53Eb2dS3nx >									
360 	//        <  u =="0.000000000000000001" : ] 000001713134891.940710000000000000 ; 000001736782280.405670000000000000 ] >									
361 	//        < 0x00000000000000000000000000000000000000000000000000A360951A5A1E94 >									
362 	//     < NDRV_PFV_III_metadata_line_37_____HDI Seguros SA_20251101 >									
363 	//        < 8sLRCPscTP00F3J0tHyP3cFLd9VYtWWMPSkW1RTK98Kf7LzMRo1SHJU3KOkS2oxz >									
364 	//        <  u =="0.000000000000000001" : ] 000001736782280.405670000000000000 ; 000001828552783.069300000000000000 ] >									
365 	//        < 0x00000000000000000000000000000000000000000000000000A5A1E94AE6266E >									
366 	//     < NDRV_PFV_III_metadata_line_38_____L_UNION de Paris Cia Uruguaya de Seguros SA_20251101 >									
367 	//        < BQAhX6TyCW84M9h1ou0MyL2uSi47M6s650xdb0rN7iK0Bvnflr35wXcztYWAUZbq >									
368 	//        <  u =="0.000000000000000001" : ] 000001828552783.069300000000000000 ; 000001847027743.462680000000000000 ] >									
369 	//        < 0x00000000000000000000000000000000000000000000000000AE6266EB025736 >									
370 	//     < NDRV_PFV_III_metadata_line_39_____L_UNION_org_20251101 >									
371 	//        < 7y45808EitCZriox8Yv1jC543x75s97UDN8167mMqUt56N5jN4DzGr2fal6x31CH >									
372 	//        <  u =="0.000000000000000001" : ] 000001847027743.462680000000000000 ; 000001884532931.974440000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000B025736B3B91AD >									
374 	//     < NDRV_PFV_III_metadata_line_40_____Protecciones Esenciales SA_20251101 >									
375 	//        < 55aIknGuj7RNW5I5H72CUXcIc0QiMfTnHdSTgTdQgu43p6yIkEgnKxHfHEaH27k1 >									
376 	//        <  u =="0.000000000000000001" : ] 000001884532931.974440000000000000 ; 000001910474611.608440000000000000 ] >									
377 	//        < 0x00000000000000000000000000000000000000000000000000B3B91ADB632725 >									
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