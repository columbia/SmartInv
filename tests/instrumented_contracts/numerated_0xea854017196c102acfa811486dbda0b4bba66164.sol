1 pragma solidity 		^0.4.25	;						
2 										
3 	contract	CHEMCHINA_PFVI_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	CHEMCHINA_PFVI_III_883		"	;
8 		string	public		symbol =	"	CHEMCHINA_PFVI_III_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		935185536382745000000000000					;	
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
92 	//     < CHEMCHINA_PFVI_III_metadata_line_1_____Shanghai_PI_Chemicals_Limited_20260321 >									
93 	//        < 1tx9V5HlT3D9sBcrLO9274xVH26cMHPN95pa8ohQU627W17pToaXioP2oVyW359Q >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000023646194.024831300000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000002414CB >									
96 	//     < CHEMCHINA_PFVI_III_metadata_line_2_____Shanghai_PI_Chemicals_Limited_20260321 >									
97 	//        < 37DVU7EVdv73Qz2657jxLj57Y4uouW37Fe7FUbAa7qouJP5KGA5nslT8sbg7lrb8 >									
98 	//        <  u =="0.000000000000000001" : ] 000000023646194.024831300000000000 ; 000000045218513.027662900000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000002414CB44FF7B >									
100 	//     < CHEMCHINA_PFVI_III_metadata_line_3_____Shanghai_Race_Chemical_Co_Limited_20260321 >									
101 	//        < uOgMuUkQxNF3zgC7WX4SgoW7RIiuxPTEql1h10mQxrwjGnyOa39iV768B04eU068 >									
102 	//        <  u =="0.000000000000000001" : ] 000000045218513.027662900000000000 ; 000000067857362.802325600000000000 ] >									
103 	//        < 0x000000000000000000000000000000000000000000000000000044FF7B678AC8 >									
104 	//     < CHEMCHINA_PFVI_III_metadata_line_4_____Shanghai_Sinch_Parmaceuticals_Tech__Co__Limited_20260321 >									
105 	//        < 4vX3LUv385SZMvv5w7Q3Tp2a9OHEh6398vWdA9Qgm2k6qlXI7i9hM6T7l6p9Crn4 >									
106 	//        <  u =="0.000000000000000001" : ] 000000067857362.802325600000000000 ; 000000089104465.302578400000000000 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000000000678AC887F66F >									
108 	//     < CHEMCHINA_PFVI_III_metadata_line_5_____Shanghai_Sunway_Pharmaceutical_Technology_Co_Limited_20260321 >									
109 	//        < 36PAyOt2W0HMs6G96N74d1Hw7R9P79hIO15a24p77Us8zMFYF6RBn2c4HZ8tLB2r >									
110 	//        <  u =="0.000000000000000001" : ] 000000089104465.302578400000000000 ; 000000111391312.426690000000000000 ] >									
111 	//        < 0x000000000000000000000000000000000000000000000000000087F66FA9F83B >									
112 	//     < CHEMCHINA_PFVI_III_metadata_line_6_____Shanghai_Tauto_Biotech_Co_Limited_20260321 >									
113 	//        < ZD8BM0ZZf7b506It42MKaz4D17RLvT2vvKy5kog5q1NQ41r85Kd75o4j6Y7755x6 >									
114 	//        <  u =="0.000000000000000001" : ] 000000111391312.426690000000000000 ; 000000135541918.783628000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000A9F83BCED210 >									
116 	//     < CHEMCHINA_PFVI_III_metadata_line_7_____Shanghai_UCHEM_org__20260321 >									
117 	//        < 2G9EbaP00S36yZ4JZ7bL7yBrD9f615WDNc7UOT23YwCkv7wC3O5nR9pyauxilEXw >									
118 	//        <  u =="0.000000000000000001" : ] 000000135541918.783628000000000000 ; 000000161237807.018316000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000CED210F60785 >									
120 	//     < CHEMCHINA_PFVI_III_metadata_line_8_____Shanghai_UCHEM_inc__20260321 >									
121 	//        < Dk8C73676tKY3H266y2EkXi788GfH8r8Ak3RvS1mknFx9z9ao9ZlV4FyDFZ1pS5U >									
122 	//        <  u =="0.000000000000000001" : ] 000000161237807.018316000000000000 ; 000000183297801.344068000000000000 ] >									
123 	//        < 0x000000000000000000000000000000000000000000000000000F60785117B0B4 >									
124 	//     < CHEMCHINA_PFVI_III_metadata_line_9_____Shanghai_UDChem_Technology_Co_Limited_20260321 >									
125 	//        < QP6wpu6m8Gy7J40T5q6d430K13Q6fB87H1dQdz7n7EKr92z965AO17dqXx6ZOqm5 >									
126 	//        <  u =="0.000000000000000001" : ] 000000183297801.344068000000000000 ; 000000207884437.041848000000000000 ] >									
127 	//        < 0x00000000000000000000000000000000000000000000000000117B0B413D34DC >									
128 	//     < CHEMCHINA_PFVI_III_metadata_line_10_____Shanghai_Witofly_Chemical_Co_Limited_20260321 >									
129 	//        < 3qnDHRlZoQBVw8r722hE4kn2VQ7O2s48R0hcCmEaIg80cR1s2Zz92uSx5RV38Myn >									
130 	//        <  u =="0.000000000000000001" : ] 000000207884437.041848000000000000 ; 000000228727158.916596000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000013D34DC15D028C >									
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
174 	//     < CHEMCHINA_PFVI_III_metadata_line_11_____Shanghai_Worldyang_Chemical_Co_Limited_20260321 >									
175 	//        < 61E6i1u2Jexsk57ji1Y172u5o1d57D6TNQAm9o4HH3By54OmSeI207r2lNzqA9i6 >									
176 	//        <  u =="0.000000000000000001" : ] 000000228727158.916596000000000000 ; 000000251289334.450669000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000015D028C17F6FE5 >									
178 	//     < CHEMCHINA_PFVI_III_metadata_line_12_____Shanghai_Yingxuan_Chempharm_Co__Limited_20260321 >									
179 	//        < 2gk3789MYb3Ye9QPH3C673aqIIiErcf9Hs9Z9eYS7pdD8zW06Y98zIg4T6v8zA94 >									
180 	//        <  u =="0.000000000000000001" : ] 000000251289334.450669000000000000 ; 000000276710905.519900000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000017F6FE51A63A33 >									
182 	//     < CHEMCHINA_PFVI_III_metadata_line_13_____SHANXI_WUCHAN_FINE_CHEMICAL_Co_Limited_20260321 >									
183 	//        < 2tYtyZEUO696hbjqhY0o8aPwub98c5rYL1hSQUE2JC23ia2ICdT05Zel26JiWc99 >									
184 	//        <  u =="0.000000000000000001" : ] 000000276710905.519900000000000000 ; 000000300031527.643790000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001A63A331C9CFD1 >									
186 	//     < CHEMCHINA_PFVI_III_metadata_line_14_____SHENYANG_OLLYCHEM_CO_LTD_20260321 >									
187 	//        < OY3VDPG4Dom6HDvtPa37Kj3arsEx2ZA0LHP4Lnjmd20lKp6pZHmd2uFVH8s47ssp >									
188 	//        <  u =="0.000000000000000001" : ] 000000300031527.643790000000000000 ; 000000322365755.980303000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000001C9CFD11EBE420 >									
190 	//     < CHEMCHINA_PFVI_III_metadata_line_15_____ShenZhen_Cerametek_Materials_org_20260321 >									
191 	//        < K73On09yB2f28LJ31FWPuGh291xX5ocL0W16xl89vD2T2Hqoz7oc2bkFs85E4VTq >									
192 	//        <  u =="0.000000000000000001" : ] 000000322365755.980303000000000000 ; 000000348764754.813935000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000001EBE4202142C3B >									
194 	//     < CHEMCHINA_PFVI_III_metadata_line_16_____ShenZhen_Cerametek_Materials_Co_Limited_20260321 >									
195 	//        < 8h857148R2c4xCRIqa9BwDDPe3XWC1G3t40CrhN2oUxe1tQj2qrtiXO397l4v2Wb >									
196 	//        <  u =="0.000000000000000001" : ] 000000348764754.813935000000000000 ; 000000375077357.615539000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000002142C3B23C5298 >									
198 	//     < CHEMCHINA_PFVI_III_metadata_line_17_____SHENZHEN_CHEMICAL_Co__Limited_20260321 >									
199 	//        < 480266Q3xI1c7HN21zz1dSFqbhpOy6VvgBMW0GfW22N4L5Kv4Q8375Bc5X33uMYK >									
200 	//        <  u =="0.000000000000000001" : ] 000000375077357.615539000000000000 ; 000000395961991.546560000000000000 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000000023C529825C30A7 >									
202 	//     < CHEMCHINA_PFVI_III_metadata_line_18_____SHOUGUANG_FUKANG_PHARMACEUTICAL_Co_Limited_20260321 >									
203 	//        < Jx3DU9qt6ERLE4ujLqhG5q5g4lV21O8X29iiobyWBGz86HvVct2EJ6yBUno3t3ef >									
204 	//        <  u =="0.000000000000000001" : ] 000000395961991.546560000000000000 ; 000000418492467.449589000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000025C30A727E919F >									
206 	//     < CHEMCHINA_PFVI_III_metadata_line_19_____Shouyuan_Chemical_20260321 >									
207 	//        < jbBb6AY121u8Pi4KwsM13Ac4Ok6Cs3vll9gi1gfgmHo4R1zaJjVsJ3LT85gLTR36 >									
208 	//        <  u =="0.000000000000000001" : ] 000000418492467.449589000000000000 ; 000000442974219.021736000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000000027E919F2A3ECCE >									
210 	//     < CHEMCHINA_PFVI_III_metadata_line_20_____Sichuan_Apothe_Pharmaceuticals_Limited_20260321 >									
211 	//        < 5yol6P8ng564I8gz37s39RQ1v1Pmb5e599z2RSNrHmI7wmUmiMr9EqXgbHB8Eb24 >									
212 	//        <  u =="0.000000000000000001" : ] 000000442974219.021736000000000000 ; 000000465150925.733444000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000002A3ECCE2C5C395 >									
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
256 	//     < CHEMCHINA_PFVI_III_metadata_line_21_____Sichuan_Highlight_Fine_Chemicals_Co__Limited_20260321 >									
257 	//        < 6sIBM7w5Iba513ps5Q2gyyt05l5E1D0v9U9YQ8kCQvhg4xBGRRO2XlV5rPCKRK1U >									
258 	//        <  u =="0.000000000000000001" : ] 000000465150925.733444000000000000 ; 000000485984176.551037000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000002C5C3952E58D92 >									
260 	//     < CHEMCHINA_PFVI_III_metadata_line_22_____SICHUAN_TONGSHENG_AMINO_ACID_org_20260321 >									
261 	//        < 5Hx1OH90f4q1Pb8zU9h6fCfZ6264q5yxQ90Um286KjktsTaxI7x1I1QuyMMLS9ZY >									
262 	//        <  u =="0.000000000000000001" : ] 000000485984176.551037000000000000 ; 000000511919792.055125000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000002E58D9230D20AB >									
264 	//     < CHEMCHINA_PFVI_III_metadata_line_23_____SICHUAN_TONGSHENG_AMINO_ACID_Co_Limited_20260321 >									
265 	//        < 0X50xUg5gW1DO00V1pm8x1c7Ss8l6466tVDpVj2D51672SM9tkFzAnUx3ZP1G2V1 >									
266 	//        <  u =="0.000000000000000001" : ] 000000511919792.055125000000000000 ; 000000533466551.139076000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000030D20AB32E015F >									
268 	//     < CHEMCHINA_PFVI_III_metadata_line_24_____SightChem_Co__Limited_20260321 >									
269 	//        < cqQB62jnCKoK5eIvf2I7dGO61NvbgBJ68G4r54V1Y775X2412CVG8sY2tXRhkE7m >									
270 	//        <  u =="0.000000000000000001" : ] 000000533466551.139076000000000000 ; 000000554542559.139097000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000032E015F34E2A30 >									
272 	//     < CHEMCHINA_PFVI_III_metadata_line_25_____Simagchem_Corporation_20260321 >									
273 	//        < M41c23zB9g9fSV3eIHNcFYUV8DMV07520pEn405vz107b8xpB3A7xaQiH8e9AKOs >									
274 	//        <  u =="0.000000000000000001" : ] 000000554542559.139097000000000000 ; 000000577180734.880584000000000000 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000000000034E2A30370B539 >									
276 	//     < CHEMCHINA_PFVI_III_metadata_line_26_____SINO_GREAT_ENTERPRISE_Limited_20260321 >									
277 	//        < nz7kJhdl7mimCZzVL6tm2jND4xeohCiJ6vx9MG3uxC60au90qDj1jgyG6ALW5Zwo >									
278 	//        <  u =="0.000000000000000001" : ] 000000577180734.880584000000000000 ; 000000600462787.260077000000000000 ] >									
279 	//        < 0x00000000000000000000000000000000000000000000000000370B5393943BC7 >									
280 	//     < CHEMCHINA_PFVI_III_metadata_line_27_____SINO_High_Goal_chemical_Techonology_Co_Limited_20260321 >									
281 	//        < QhmlXw8OSo1g8GZ6VpLt3cru8IXE1Z748ec70as6Lzeowm8B51Tn2Bx4tl3H8158 >									
282 	//        <  u =="0.000000000000000001" : ] 000000600462787.260077000000000000 ; 000000623533762.157751000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000003943BC73B76FE0 >									
284 	//     < CHEMCHINA_PFVI_III_metadata_line_28_____Sino_Rarechem_Labs_Co_Limited_20260321 >									
285 	//        < yNX4zzVQ55g2Q6rK47l1oIf560q6JBT81fs7M41r200zJk1Wfx99F1428sboD4ed >									
286 	//        <  u =="0.000000000000000001" : ] 000000623533762.157751000000000000 ; 000000646488332.457867000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000003B76FE03DA7681 >									
288 	//     < CHEMCHINA_PFVI_III_metadata_line_29_____Sinofi_Ingredients_20260321 >									
289 	//        < MHnPA75J13ip5NSE01qaeZhVa9wHR043Fwb9lKXcfRFLurSv2RVr94VM49kWue8g >									
290 	//        <  u =="0.000000000000000001" : ] 000000646488332.457867000000000000 ; 000000669664117.857185000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000003DA76813FDD38C >									
292 	//     < CHEMCHINA_PFVI_III_metadata_line_30_____Sinoway_20260321 >									
293 	//        < MD5wu3c5I00S5lqi7Yo6777oaCya11O0PJ0cL6r2NwUskQ0jsJS3D9kl9ZZmwgQg >									
294 	//        <  u =="0.000000000000000001" : ] 000000669664117.857185000000000000 ; 000000694744274.398119000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000003FDD38C424187B >									
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
338 	//     < CHEMCHINA_PFVI_III_metadata_line_31_____Skyrun_Industrial_Co_Limited_20260321 >									
339 	//        < SF26o76u0633244ty3PbZD7d687dpcAhwZx0V3BMGf78hhnYNpLB798IJua3h1AV >									
340 	//        <  u =="0.000000000000000001" : ] 000000694744274.398119000000000000 ; 000000718844577.775298000000000000 ] >									
341 	//        < 0x00000000000000000000000000000000000000000000000000424187B448DEAA >									
342 	//     < CHEMCHINA_PFVI_III_metadata_line_32_____Spec_Chem_Industry_org_20260321 >									
343 	//        < 4wmD0sN587LU1BE685dO4wZXQ8E4NtMlEp51c2pR72N6MI2912z34AG1QxrCI2JI >									
344 	//        <  u =="0.000000000000000001" : ] 000000718844577.775298000000000000 ; 000000741574406.047041000000000000 ] >									
345 	//        < 0x00000000000000000000000000000000000000000000000000448DEAA46B8D81 >									
346 	//     < CHEMCHINA_PFVI_III_metadata_line_33_____Spec_Chem_Industry_inc__20260321 >									
347 	//        < 1Ab97ksPzl6KeQ48H2qS5Fgzr90KmLuGPt8XqKt5o96dsxX2h7q2YKkFJB8gWp1p >									
348 	//        <  u =="0.000000000000000001" : ] 000000741574406.047041000000000000 ; 000000767088068.559047000000000000 ] >									
349 	//        < 0x0000000000000000000000000000000000000000000000000046B8D814927BC7 >									
350 	//     < CHEMCHINA_PFVI_III_metadata_line_34_____Stone_Lake_Pharma_Tech_Co_Limited_20260321 >									
351 	//        < dk32tiRZXyyq9hRq63Q8Hv2UmiorCN0Y7TY6Ggbo8FGp4M4g7oCvAL1hftGj2XOW >									
352 	//        <  u =="0.000000000000000001" : ] 000000767088068.559047000000000000 ; 000000792515027.340330000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000004927BC74B9482F >									
354 	//     < CHEMCHINA_PFVI_III_metadata_line_35_____Suzhou_ChonTech_PharmaChem_Technology_Co__Limited_20260321 >									
355 	//        < dFMfS0516lv7chfu6z3r7H4BE5qcT9j3dzYU0gjdS9LGBKCVn8tuq17cG7qMVD5h >									
356 	//        <  u =="0.000000000000000001" : ] 000000792515027.340330000000000000 ; 000000814298963.254644000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000004B9482F4DA8588 >									
358 	//     < CHEMCHINA_PFVI_III_metadata_line_36_____Suzhou_Credit_International_Trading_Co__Limited_20260321 >									
359 	//        < odM928865uQ7JpoqU92InKIv5bUQLIG2Ds34wmAM7uG2pa8ofF5i2SnTXwzE9Kg8 >									
360 	//        <  u =="0.000000000000000001" : ] 000000814298963.254644000000000000 ; 000000839221947.520822000000000000 ] >									
361 	//        < 0x000000000000000000000000000000000000000000000000004DA85885008D13 >									
362 	//     < CHEMCHINA_PFVI_III_metadata_line_37_____Suzhou_KPChemical_Co_Limited_20260321 >									
363 	//        < V3j7Y9ty91xQn80Ra5lT3p9u6LcaVMF2dxhauz8dZWZhWXEAZx6024QKp9971dtq >									
364 	//        <  u =="0.000000000000000001" : ] 000000839221947.520822000000000000 ; 000000862476933.770626000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000005008D13524090D >									
366 	//     < CHEMCHINA_PFVI_III_metadata_line_38_____Suzhou_Rovathin_Foreign_Trade_Co_Limited_20260321 >									
367 	//        < J9l5tfl0I32NRW35f017PE6UjP633Xu1S9RZpW9C5r93LzbE29nb69vQ73jB29XO >									
368 	//        <  u =="0.000000000000000001" : ] 000000862476933.770626000000000000 ; 000000887574804.597463000000000000 ] >									
369 	//        < 0x00000000000000000000000000000000000000000000000000524090D54A54E8 >									
370 	//     < CHEMCHINA_PFVI_III_metadata_line_39_____SUZHOU_SINOERA_CHEM_org_20260321 >									
371 	//        < vRDUH6n2R9hIDe7IAJ9FG2Yp4b926S7xqic66Oah9ZITp4brATssx1GJ2Q3d7y5B >									
372 	//        <  u =="0.000000000000000001" : ] 000000887574804.597463000000000000 ; 000000909969776.509183000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000054A54E856C80F2 >									
374 	//     < CHEMCHINA_PFVI_III_metadata_line_40_____SUZHOU_SINOERA_CHEM_Co__Limited_20260321 >									
375 	//        < Zo8pVC8R4iXBP2P54c6gOg8Bcx70QleNL9OCw890VuN3zTXZiOpI9Pe7nEd0w3lX >									
376 	//        <  u =="0.000000000000000001" : ] 000000909969776.509183000000000000 ; 000000935185536.382745000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000056C80F2592FADA >									
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