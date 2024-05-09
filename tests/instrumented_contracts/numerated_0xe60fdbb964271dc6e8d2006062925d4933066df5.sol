1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXXI_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXXI_III_883		"	;
8 		string	public		symbol =	"	RUSS_PFXXI_III_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1009564619510650000000000000					;	
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
92 	//     < RUSS_PFXXI_III_metadata_line_1_____EUROCHEM_20251101 >									
93 	//        < wazpFvHBNRk4XI8K78ek03YTS2hp5FUS5Poei12ZsBmfd7lz1P76j2JDMmlNLvLO >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000025520157.642010100000000000 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000000026F0D0 >									
96 	//     < RUSS_PFXXI_III_metadata_line_2_____Eurochem_Org_20251101 >									
97 	//        < avkya1fO8U2F1q25A3qbeP3g39wg310BUmS2i7onkD9wcn3S30bC2ywzv3cPB3y1 >									
98 	//        <  u =="0.000000000000000001" : ] 000000025520157.642010100000000000 ; 000000048969513.712779600000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000026F0D04AB8B7 >									
100 	//     < RUSS_PFXXI_III_metadata_line_3_____Hispalense_Líquidos_SL_20251101 >									
101 	//        < 4673j5rHsF55S62Roj6MKQbg4ptgAY8zfX6z2GR6uygBAwhC8qoZBTwqdLnIjl5u >									
102 	//        <  u =="0.000000000000000001" : ] 000000048969513.712779600000000000 ; 000000067909034.230230100000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000004AB8B7679EF7 >									
104 	//     < RUSS_PFXXI_III_metadata_line_4_____Azottech_LLC_20251101 >									
105 	//        < eDe432xr4a4juaO577TquS0wZLkQjJ119889VGwru9v53w6M9vYVar0LN0DQeovB >									
106 	//        <  u =="0.000000000000000001" : ] 000000067909034.230230100000000000 ; 000000092079928.658506200000000000 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000000000679EF78C80B9 >									
108 	//     < RUSS_PFXXI_III_metadata_line_5_____Biochem_Technologies_LLC_20251101 >									
109 	//        < 8TV8H3mDC2bFy2JO08nn3RDQZTsCxBek64iYJ9Pfiz9BOBR2SA2ZN6Y0U93hHcU6 >									
110 	//        <  u =="0.000000000000000001" : ] 000000092079928.658506200000000000 ; 000000126001570.529632000000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000008C80B9C0435D >									
112 	//     < RUSS_PFXXI_III_metadata_line_6_____Eurochem_1_Org_20251101 >									
113 	//        < NOwl79V8lyCf3BCXr85O1RH5u545W0mh57BQ6449MSYu5gSPz3CaK3IZm4c6It5t >									
114 	//        <  u =="0.000000000000000001" : ] 000000126001570.529632000000000000 ; 000000145825143.670516000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000C0435DDE82F2 >									
116 	//     < RUSS_PFXXI_III_metadata_line_7_____Eurochem_1_Dao_20251101 >									
117 	//        < difxDxqFGeJTgg6FxVz5aUy64hks47P363OWK6oKi1P94gsaobVyig68Rl5c7Z48 >									
118 	//        <  u =="0.000000000000000001" : ] 000000145825143.670516000000000000 ; 000000171724121.385748000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000000DE82F210607BC >									
120 	//     < RUSS_PFXXI_III_metadata_line_8_____Eurochem_1_Daopi_20251101 >									
121 	//        < 9AjPftoJNI2vn1jJuSrweBTF4b7Pn2tjPsu7a1fqJvIxeBlkejunMOOi86Aw20HV >									
122 	//        <  u =="0.000000000000000001" : ] 000000171724121.385748000000000000 ; 000000193389050.821121000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000010607BC1271699 >									
124 	//     < RUSS_PFXXI_III_metadata_line_9_____Eurochem_1_Dac_20251101 >									
125 	//        < 4KtaSm3fOVED0cmyc13aDGk95vpC9YcD1qQq8iw8M4zldBa2IX4gD0l9x2eg7gwn >									
126 	//        <  u =="0.000000000000000001" : ] 000000193389050.821121000000000000 ; 000000215463871.326537000000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000001271699148C593 >									
128 	//     < RUSS_PFXXI_III_metadata_line_10_____Eurochem_1_Bimi_20251101 >									
129 	//        < oyk41OfX3wn0yLXx6L9UJAiD1637b1Nk8Rw0DZ6PT7882p1m8BRLSNxvt77nmTjg >									
130 	//        <  u =="0.000000000000000001" : ] 000000215463871.326537000000000000 ; 000000246897429.913246000000000000 ] >									
131 	//        < 0x00000000000000000000000000000000000000000000000000148C593178BC4F >									
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
174 	//     < RUSS_PFXXI_III_metadata_line_11_____Eurochem_2_Org_20251101 >									
175 	//        < cC09Z4sSSWF278p5edlEox7SY0XCc4yEpagR84E3596qI8IZrtzKv9tUjTer23Df >									
176 	//        <  u =="0.000000000000000001" : ] 000000246897429.913246000000000000 ; 000000275251677.310583000000000000 ] >									
177 	//        < 0x00000000000000000000000000000000000000000000000000178BC4F1A40030 >									
178 	//     < RUSS_PFXXI_III_metadata_line_12_____Eurochem_2_Dao_20251101 >									
179 	//        < 515PV9143Iv55o34I8q2T7Tf3pkv8E406khQ54SS4e2dH1UDdEg3ypk708t8V0Ni >									
180 	//        <  u =="0.000000000000000001" : ] 000000275251677.310583000000000000 ; 000000301509544.864735000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000001A400301CC112A >									
182 	//     < RUSS_PFXXI_III_metadata_line_13_____Eurochem_2_Daopi_20251101 >									
183 	//        < 3Eng2jW95YfPzPk1244WpYM9vH8fZca9AkEkpFiVi0B6QN3u6l583cLme9Jl4An5 >									
184 	//        <  u =="0.000000000000000001" : ] 000000301509544.864735000000000000 ; 000000324369941.409403000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001CC112A1EEF302 >									
186 	//     < RUSS_PFXXI_III_metadata_line_14_____Eurochem_2_Dac_20251101 >									
187 	//        < Sg1O066LQ4Q8141oe8pM10x10ryH20D2p92e63c977ieBVaDDD1EfSB3z81N08ob >									
188 	//        <  u =="0.000000000000000001" : ] 000000324369941.409403000000000000 ; 000000357921030.256581000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000001EEF30222224E7 >									
190 	//     < RUSS_PFXXI_III_metadata_line_15_____Eurochem_2_Bimi_20251101 >									
191 	//        < cvgLLGYDFv11Z2x0Wd0WiVsW9J634JNu4K1Dcr8iz486iN84GbXesXDpk0a5CPo6 >									
192 	//        <  u =="0.000000000000000001" : ] 000000357921030.256581000000000000 ; 000000380023024.113991000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000022224E7243DE7E >									
194 	//     < RUSS_PFXXI_III_metadata_line_16_____Melni_1_Org_20251101 >									
195 	//        < sE762x4kK1n2JU1tpoSkwCiOQJ3C09Eo496V3xNWi72uK740mLeXQ7ur69jhfuT2 >									
196 	//        <  u =="0.000000000000000001" : ] 000000380023024.113991000000000000 ; 000000399232061.127672000000000000 ] >									
197 	//        < 0x00000000000000000000000000000000000000000000000000243DE7E2612E06 >									
198 	//     < RUSS_PFXXI_III_metadata_line_17_____Melni_1_Dao_20251101 >									
199 	//        < CWBP368uqn9J3GyJyK0OpCxOu5EVn0a3ms1rmU5e32j639L471iN2aKqu9727JUa >									
200 	//        <  u =="0.000000000000000001" : ] 000000399232061.127672000000000000 ; 000000421256890.047730000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000002612E06282C979 >									
202 	//     < RUSS_PFXXI_III_metadata_line_18_____Melni_1_Daopi_20251101 >									
203 	//        < XYDlwgUN64Krs59P19AzVUSN017foV6Wc93tjLL4fB1UgJ87j481jwgTF15xWCU7 >									
204 	//        <  u =="0.000000000000000001" : ] 000000421256890.047730000000000000 ; 000000448970032.990698000000000000 ] >									
205 	//        < 0x00000000000000000000000000000000000000000000000000282C9792AD12EB >									
206 	//     < RUSS_PFXXI_III_metadata_line_19_____Melni_1_Dac_20251101 >									
207 	//        < UaJ388FD0Xp9t7idb153qM8XoVe3293V7aM7NWrh0SAU78RE36Jjd7X763kVq4Lz >									
208 	//        <  u =="0.000000000000000001" : ] 000000448970032.990698000000000000 ; 000000476607969.557281000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000002AD12EB2D73EFD >									
210 	//     < RUSS_PFXXI_III_metadata_line_20_____Melni_1_Bimi_20251101 >									
211 	//        < 1ivKM90PfvQnHL27u8FblhtNQCm7049c0me3hF2w6bJ6pf9ICPUk8GBQ605S96M4 >									
212 	//        <  u =="0.000000000000000001" : ] 000000476607969.557281000000000000 ; 000000510758746.041450000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000002D73EFD30B5B23 >									
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
256 	//     < RUSS_PFXXI_III_metadata_line_21_____Melni_2_Org_20251101 >									
257 	//        < IS6163kpXZ3GB9BEI8C92YI0OXp6yl9H4ycv4B821d1D9M81WftNtw5ZAvCOeIum >									
258 	//        <  u =="0.000000000000000001" : ] 000000510758746.041450000000000000 ; 000000545301855.274717000000000000 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000000030B5B23340108A >									
260 	//     < RUSS_PFXXI_III_metadata_line_22_____Melni_2_Dao_20251101 >									
261 	//        < F4w03XA0shkTmu60fZsdZ606O0G743xYPat4PS1PPBxOkCKnj2YPZTWlxZiJmlcn >									
262 	//        <  u =="0.000000000000000001" : ] 000000545301855.274717000000000000 ; 000000570185986.018594000000000000 ] >									
263 	//        < 0x00000000000000000000000000000000000000000000000000340108A36608E7 >									
264 	//     < RUSS_PFXXI_III_metadata_line_23_____Melni_2_Daopi_20251101 >									
265 	//        < 2Eb6J5LBIzvmAEinq5UPaUZn735IKGPhTJJ8ge6JTj2yEVpNEB1vkEwu5x06M4Qm >									
266 	//        <  u =="0.000000000000000001" : ] 000000570185986.018594000000000000 ; 000000597505573.244446000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000036608E738FB89D >									
268 	//     < RUSS_PFXXI_III_metadata_line_24_____Melni_2_Dac_20251101 >									
269 	//        < rjHm35bwoWBL57Jt2er706Yapu9410e2fYtkBhkTq5Ub70Vuy8kDwSNJG6dT3X96 >									
270 	//        <  u =="0.000000000000000001" : ] 000000597505573.244446000000000000 ; 000000616930905.720497000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000038FB89D3AD5CA3 >									
272 	//     < RUSS_PFXXI_III_metadata_line_25_____Melni_2_Bimi_20251101 >									
273 	//        < 5IMt2LM3207I9jmbNU1iAPMIPRIq9zFLP43BsU2B2aqaP732v3ALH736IvKT2885 >									
274 	//        <  u =="0.000000000000000001" : ] 000000616930905.720497000000000000 ; 000000639826251.061190000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000003AD5CA33D04C21 >									
276 	//     < RUSS_PFXXI_III_metadata_line_26_____Lifosa_Ab_Org_20251101 >									
277 	//        < 0HfGN023IzKPS1ISlO5V656PO58CX33fsm1t1ev6o5KOZhR96A6cFYC3iN0rYbL1 >									
278 	//        <  u =="0.000000000000000001" : ] 000000639826251.061190000000000000 ; 000000660753988.449232000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000003D04C213F03B07 >									
280 	//     < RUSS_PFXXI_III_metadata_line_27_____Lifosa_Ab_Dao_20251101 >									
281 	//        < 13j14ag2ddpC47t9lcB3812OiSlQ7BJxfT89yxw52065NZwVd1rR06lGDmMUDt13 >									
282 	//        <  u =="0.000000000000000001" : ] 000000660753988.449232000000000000 ; 000000688451349.283336000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000003F03B0741A7E4F >									
284 	//     < RUSS_PFXXI_III_metadata_line_28_____Lifosa_Ab_Daopi_20251101 >									
285 	//        < DuJrhm300sYj6BDg4N9N2H99BbY47T2Hwhcw4hU8x9v580K425953E5rXDR81qJQ >									
286 	//        <  u =="0.000000000000000001" : ] 000000688451349.283336000000000000 ; 000000710994950.626438000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000041A7E4F43CE467 >									
288 	//     < RUSS_PFXXI_III_metadata_line_29_____Lifosa_Ab_Dac_20251101 >									
289 	//        < 3E46s7I95QjXhJ7xoo3H5deNpmnBjxyUd6FnkEn8DYzOPgn6791duLharGHqcm7K >									
290 	//        <  u =="0.000000000000000001" : ] 000000710994950.626438000000000000 ; 000000741469238.914017000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000043CE46746B646C >									
292 	//     < RUSS_PFXXI_III_metadata_line_30_____Lifosa_Ab_Bimi_20251101 >									
293 	//        < C28Ci27Quv3B5w1l6xX8Ip126Wcz6QFS8bu52Zh3oK33749sDIFmhe8rd9E7p9m5 >									
294 	//        <  u =="0.000000000000000001" : ] 000000741469238.914017000000000000 ; 000000761089960.424349000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000046B646C48954C4 >									
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
338 	//     < RUSS_PFXXI_III_metadata_line_31_____Azot_Ab_1_Org_20251101 >									
339 	//        < Dn6xbEiwQtof2AgXoeK8v6uW17NjQF1SM151QwJH6fdR280p98Vw2gGcPo9861cn >									
340 	//        <  u =="0.000000000000000001" : ] 000000761089960.424349000000000000 ; 000000781282525.427408000000000000 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000000000048954C44A8247D >									
342 	//     < RUSS_PFXXI_III_metadata_line_32_____Azot_Ab_1_Dao_20251101 >									
343 	//        < PU79njoysVsvP2RdP7600BE69NPb54W5YgM4nivYf5OdpaHPM6XCfLaP7Gtt8Po9 >									
344 	//        <  u =="0.000000000000000001" : ] 000000781282525.427408000000000000 ; 000000805989124.689845000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000004A8247D4CDD780 >									
346 	//     < RUSS_PFXXI_III_metadata_line_33_____Azot_Ab_1_Daopi_20251101 >									
347 	//        < jM4Jq9p4I5qo4Z0K68SGBL7B030rQ71b867b6Y8B7KCL59Ilh69zZFjixsEx7nBR >									
348 	//        <  u =="0.000000000000000001" : ] 000000805989124.689845000000000000 ; 000000834003985.006448000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000004CDD7804F896CF >									
350 	//     < RUSS_PFXXI_III_metadata_line_34_____Azot_Ab_1_Dac_20251101 >									
351 	//        < 0PoJ74RshbrQ1X1mUloZwcpdr92u5iG4Zci6vnLAfXw6t4D3J1JB7nr2Riuk2W4w >									
352 	//        <  u =="0.000000000000000001" : ] 000000834003985.006448000000000000 ; 000000865227827.299622000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000004F896CF5283B9F >									
354 	//     < RUSS_PFXXI_III_metadata_line_35_____Azot_Ab_1_Bimi_20251101 >									
355 	//        < 8e05iWABWyKz40lxY6CVy24z52MFnV9XJuOyE89T8fSP0h17o03rphX4WxBG8Vp7 >									
356 	//        <  u =="0.000000000000000001" : ] 000000865227827.299622000000000000 ; 000000886087260.904487000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000005283B9F5480FD6 >									
358 	//     < RUSS_PFXXI_III_metadata_line_36_____Azot_Ab_2_Org_20251101 >									
359 	//        < 6Hwdos46ibTqTL03c4H8NZKY4HmFtkOfmM2ZEZ7jwAA3vi5pz7wJq3MH52WMWv76 >									
360 	//        <  u =="0.000000000000000001" : ] 000000886087260.904487000000000000 ; 000000918139456.286980000000000000 ] >									
361 	//        < 0x000000000000000000000000000000000000000000000000005480FD6578F83A >									
362 	//     < RUSS_PFXXI_III_metadata_line_37_____Azot_Ab_2_Dao_20251101 >									
363 	//        < QiFVuErOO22l7uzmTD08T676IRQKLe4kXHNcmKQohgD3HYn5x4BXTmtT2YIsDrxq >									
364 	//        <  u =="0.000000000000000001" : ] 000000918139456.286980000000000000 ; 000000939297996.791603000000000000 ] >									
365 	//        < 0x00000000000000000000000000000000000000000000000000578F83A5994148 >									
366 	//     < RUSS_PFXXI_III_metadata_line_38_____Azot_Ab_2_Daopi_20251101 >									
367 	//        < ZqPJuRdtxH9st0096oP9xRBE5mxOI2EA1DQrmZEr2Wt8z0DBH1r68YVn9dx2TaAK >									
368 	//        <  u =="0.000000000000000001" : ] 000000939297996.791603000000000000 ; 000000961517456.803041000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000059941485BB28C2 >									
370 	//     < RUSS_PFXXI_III_metadata_line_39_____Azot_Ab_2_Dac_20251101 >									
371 	//        < 34oP56Ns7A4h17mK8h4ez5g035pDa6sK1j4hv788BI3a8jyW50747qa4xy98v5E8 >									
372 	//        <  u =="0.000000000000000001" : ] 000000961517456.803041000000000000 ; 000000986020480.123090000000000000 ] >									
373 	//        < 0x000000000000000000000000000000000000000000000000005BB28C25E08C40 >									
374 	//     < RUSS_PFXXI_III_metadata_line_40_____Azot_Ab_2_Bimi_20251101 >									
375 	//        < FU8ZrK60GZqD09Fg39L23HK79xXbwT6FW53XXE0I80T1hYA3B8ON6Qnf92SjE8x0 >									
376 	//        <  u =="0.000000000000000001" : ] 000000986020480.123090000000000000 ; 000001009564619.510650000000000000 ] >									
377 	//        < 0x000000000000000000000000000000000000000000000000005E08C40604792E >									
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