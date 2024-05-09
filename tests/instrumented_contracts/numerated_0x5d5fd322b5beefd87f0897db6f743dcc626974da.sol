1 pragma solidity 		^0.4.25	;						
2 										
3 	contract	CHEMCHINA_PFIV_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	CHEMCHINA_PFIV_III_883		"	;
8 		string	public		symbol =	"	CHEMCHINA_PFIV_III_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1177245588806280000000000000					;	
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
92 	//     < CHEMCHINA_PFIV_III_metadata_line_1_____Kaifute__Tianjin__Chemical_Co___Ltd__20260321 >									
93 	//        < 5079p9k42ZewLf2PwLbXiZIdk2EWKK3HYZDt1Wnexzxr483RCjJ4rP57I4lU1417 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000031317092.188835400000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000002FC93D >									
96 	//     < CHEMCHINA_PFIV_III_metadata_line_2_____Kaiyuan_Chemicals_Co__Limited_20260321 >									
97 	//        < FVcJ1HVxcxM1jA7h4qsErtk11vld3SCFXG8thkq9y901n2WE0oCG6S6X8OU4q0O6 >									
98 	//        <  u =="0.000000000000000001" : ] 000000031317092.188835400000000000 ; 000000061259022.129038900000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000002FC93D5D794E >									
100 	//     < CHEMCHINA_PFIV_III_metadata_line_3_____Kinbester_org_20260321 >									
101 	//        < M6bZ1Gq92a1LIhP846AZa2329f0ynBfO84g31uutz7J33fa9N9aeJteYRehcFq6z >									
102 	//        <  u =="0.000000000000000001" : ] 000000061259022.129038900000000000 ; 000000089059601.426070100000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000005D794E87E4E8 >									
104 	//     < CHEMCHINA_PFIV_III_metadata_line_4_____Kinbester_Co_Limited_20260321 >									
105 	//        < F7V59O1A83ZLbH7gJ9bnA19emk19MpXlwoE6pl84qEiSGPGLGFmgqnCjMk48I45D >									
106 	//        <  u =="0.000000000000000001" : ] 000000089059601.426070100000000000 ; 000000109629866.571487000000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000087E4E8A7482B >									
108 	//     < CHEMCHINA_PFIV_III_metadata_line_5_____Kinfon_Pharmachem_Co_Limited_20260321 >									
109 	//        < 10QbL3M5nvj8C2b4Hl9e80023T0AbF8HVzT51o9AV6hy2r3o8LUNM44H5250TPXE >									
110 	//        <  u =="0.000000000000000001" : ] 000000109629866.571487000000000000 ; 000000141192182.596309000000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000A7482BD77132 >									
112 	//     < CHEMCHINA_PFIV_III_metadata_line_6_____King_Scientific_20260321 >									
113 	//        < 6QZowH0RtZZe12l04lyZP3akY9UbhLOI2I9dame32a0874u2O3O54ZO1KsBp1Z9B >									
114 	//        <  u =="0.000000000000000001" : ] 000000141192182.596309000000000000 ; 000000164497394.252964000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000D77132FB00CB >									
116 	//     < CHEMCHINA_PFIV_III_metadata_line_7_____Kingreat_Chemistry_Company_Limited_20260321 >									
117 	//        < k3lGu9iC0B4KtIQv6o06xjeFW6f1S9zPJN6pJ3Oz8X2758viSLpW8VhgzmlqdiLG >									
118 	//        <  u =="0.000000000000000001" : ] 000000164497394.252964000000000000 ; 000000187805803.835986000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000000FB00CB11E91A4 >									
120 	//     < CHEMCHINA_PFIV_III_metadata_line_8_____Labseeker_org_20260321 >									
121 	//        < 9Yk20MO6wZwVI52368iGp9vMX4y653go5Kl61x6BGQROBKMl5K5NO6U995ZJ5GeY >									
122 	//        <  u =="0.000000000000000001" : ] 000000187805803.835986000000000000 ; 000000221135907.659136000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000011E91A41516D37 >									
124 	//     < CHEMCHINA_PFIV_III_metadata_line_9_____Labseeker_20260321 >									
125 	//        < b52Rp3bKGbhi1ZkRe9PMi7y8Z8H112YIz2zzS30cAp28MKZipVqP2IWI0Hdnp0t7 >									
126 	//        <  u =="0.000000000000000001" : ] 000000221135907.659136000000000000 ; 000000249536141.070500000000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000001516D3717CC30E >									
128 	//     < CHEMCHINA_PFIV_III_metadata_line_10_____Langfang_Beixin_Chemical_Company_Limited_20260321 >									
129 	//        < h6692ZBaX7g1k45g9268wmuIFX1clqo3FVdPYerVcM210R3MVPZFn28ih23s54z8 >									
130 	//        <  u =="0.000000000000000001" : ] 000000249536141.070500000000000000 ; 000000269673701.553239000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000017CC30E19B7D4A >									
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
174 	//     < CHEMCHINA_PFIV_III_metadata_line_11_____Leap_Labchem_Co_Limited_20260321 >									
175 	//        < a25fMm93CuPL6iPut30MUGYXHC81t0U8xo82WTBMhhvxmAjG8hRCHU4qPnz64134 >									
176 	//        <  u =="0.000000000000000001" : ] 000000269673701.553239000000000000 ; 000000305301255.421442000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000019B7D4A1D1DA4E >									
178 	//     < CHEMCHINA_PFIV_III_metadata_line_12_____Leap_Labchem_Co_Limited_20260321 >									
179 	//        < ttuDOX6yPd2I57XT1p0Z14BJ98L69ZtrmRX4v38czY04R7pkuIuKu911v8Rz2GkP >									
180 	//        <  u =="0.000000000000000001" : ] 000000305301255.421442000000000000 ; 000000327081162.697980000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000001D1DA4E1F31614 >									
182 	//     < CHEMCHINA_PFIV_III_metadata_line_13_____LON_CHEMICAL_org_20260321 >									
183 	//        < cfod95K55AZ98YlF5wBt1Oe4OCTG1dN3l5z95bPM4d1750Jj5V37Okk5G65oMZB8 >									
184 	//        <  u =="0.000000000000000001" : ] 000000327081162.697980000000000000 ; 000000350656412.666693000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001F316142170F29 >									
186 	//     < CHEMCHINA_PFIV_III_metadata_line_14_____LON_CHEMICAL_20260321 >									
187 	//        < uMTqF3m0uPBMv95arkwFHPwl3bJ4X93wDTwDGBQ7CquJ171v50D5H2zQx36MZETr >									
188 	//        <  u =="0.000000000000000001" : ] 000000350656412.666693000000000000 ; 000000384330603.982530000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000002170F2924A7124 >									
190 	//     < CHEMCHINA_PFIV_III_metadata_line_15_____LVYU_Chemical_Co__Limited_20260321 >									
191 	//        < qD6ZkFO6LhCeGd7aK571ebkI6gD3JyXavpTP87xVK3HhYa3LgYLxyn08Zt8c200W >									
192 	//        <  u =="0.000000000000000001" : ] 000000384330603.982530000000000000 ; 000000417117616.973544000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000024A712427C7892 >									
194 	//     < CHEMCHINA_PFIV_III_metadata_line_16_____MASCOT_I_E__Co_Limited_20260321 >									
195 	//        < w96ftSx816o4tAcBr7Q9BBc0wvOfgTE4aT72Ll54Gw09VKwWBIyYi24soQaLC948 >									
196 	//        <  u =="0.000000000000000001" : ] 000000417117616.973544000000000000 ; 000000444586634.420530000000000000 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000000027C78922A662A7 >									
198 	//     < CHEMCHINA_PFIV_III_metadata_line_17_____NANCHANG_LONGDING_TECHNOLOGY_DEVELOPMENT_Co_Limited_20260321 >									
199 	//        < 98Mo8Rx3xIVMJA7j0471mwS5m9dHN8VEE4zubbODZMf3FCBS3U6e0CpQ7akQ8K3T >									
200 	//        <  u =="0.000000000000000001" : ] 000000444586634.420530000000000000 ; 000000472472249.441561000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000002A662A72D0EF79 >									
202 	//     < CHEMCHINA_PFIV_III_metadata_line_18_____Nanjing_BoomKing_Industrial_Co_Limited_20260321 >									
203 	//        < Y70O4DMr817BG451Wy0js73dIul7f4K93Cdk9rJnYRY61h6GdSGVD4sqtlJRb7d2 >									
204 	//        <  u =="0.000000000000000001" : ] 000000472472249.441561000000000000 ; 000000501689127.523518000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000002D0EF792FD8451 >									
206 	//     < CHEMCHINA_PFIV_III_metadata_line_19_____Nanjing_Boyuan_Pharmatech_Co_Limited_20260321 >									
207 	//        < 58jIza6IhwOXeD5fenJws6ne0z1Uy65wDTLtxy9ORAdT55i8K5t51NO4Ml5Vd7Oc >									
208 	//        <  u =="0.000000000000000001" : ] 000000501689127.523518000000000000 ; 000000523343927.179423000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000002FD845131E8F39 >									
210 	//     < CHEMCHINA_PFIV_III_metadata_line_20_____Nanjing_Chemlin_Chemical_Industry_org_20260321 >									
211 	//        < SK8RA02Mek7lHZs5ofnM2ABZzQH2w6Dqz5gX10KkxR6cq6is071VsJDp7WC7068X >									
212 	//        <  u =="0.000000000000000001" : ] 000000523343927.179423000000000000 ; 000000553667564.944447000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000031E8F3934CD464 >									
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
256 	//     < CHEMCHINA_PFIV_III_metadata_line_21_____Nanjing_Chemlin_Chemical_Industry_Co_Limited_20260321 >									
257 	//        < FpAexQEOmLml1yE3Qid3b5zS6zqUiaZx320iMJLq2R2wE6dxOtM3146hR51sYbtk >									
258 	//        <  u =="0.000000000000000001" : ] 000000553667564.944447000000000000 ; 000000579817176.973679000000000000 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000000034CD464374BB16 >									
260 	//     < CHEMCHINA_PFIV_III_metadata_line_22_____Nanjing_Chemlin_Chemical_Industry_Co_Limited_20260321 >									
261 	//        < 24Gtv6rrnbqS4xzKvg8UQQMjdN3j1u04z5z89wBTVy7JKKSq9bp1YS8e77Ug1Ctq >									
262 	//        <  u =="0.000000000000000001" : ] 000000579817176.973679000000000000 ; 000000615967688.692126000000000000 ] >									
263 	//        < 0x00000000000000000000000000000000000000000000000000374BB163ABE461 >									
264 	//     < CHEMCHINA_PFIV_III_metadata_line_23_____Nanjing_Fubang_Chemical_Co_Limited_20260321 >									
265 	//        < u5o4e0P75776q9Xyd3m5A5U7haV75Wy9tRwP3o4bz5K9EEcy0LKEtIEl9861o5tq >									
266 	//        <  u =="0.000000000000000001" : ] 000000615967688.692126000000000000 ; 000000644827084.933135000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000003ABE4613D7ED94 >									
268 	//     < CHEMCHINA_PFIV_III_metadata_line_24_____Nanjing_Legend_Pharmaceutical___Chemical_Co__Limited_20260321 >									
269 	//        < uH5aNaYWo7O94j36XH15P19Ie5HTLy9W4u2GjzNroeg84ZW5646uD5U2ozMYUL2M >									
270 	//        <  u =="0.000000000000000001" : ] 000000644827084.933135000000000000 ; 000000685277698.853062000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000003D7ED94415A69A >									
272 	//     < CHEMCHINA_PFIV_III_metadata_line_25_____Nanjing_Raymon_Biotech_Co_Limited_20260321 >									
273 	//        < VT28K4zk064ygafZzyTwHyMcr824lWZs4DijsVeL7q0xCRC2KpbM4CfUMcDowiT1 >									
274 	//        <  u =="0.000000000000000001" : ] 000000685277698.853062000000000000 ; 000000725515855.082001000000000000 ] >									
275 	//        < 0x00000000000000000000000000000000000000000000000000415A69A4530CA2 >									
276 	//     < CHEMCHINA_PFIV_III_metadata_line_26_____Nantong_Baihua_Bio_Pharmaceutical_Co_Limited_20260321 >									
277 	//        < SDRIZL21sTk1D5By0mbqT6Us3RWTt2sYP5QsL3g9n292r1TZJ2oHdL5yH89Glcy9 >									
278 	//        <  u =="0.000000000000000001" : ] 000000725515855.082001000000000000 ; 000000759787148.417439000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000004530CA248757DB >									
280 	//     < CHEMCHINA_PFIV_III_metadata_line_27_____Nantong_Qihai_Chemicals_org_20260321 >									
281 	//        < QH6H01NJy0oX8TwxV522T7m8Bga68qpI5OaDB4YG9N6S3j70gD1lSVS89t370DD2 >									
282 	//        <  u =="0.000000000000000001" : ] 000000759787148.417439000000000000 ; 000000786481679.036602000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000048757DB4B01368 >									
284 	//     < CHEMCHINA_PFIV_III_metadata_line_28_____Nantong_Qihai_Chemicals_Co_Limited_20260321 >									
285 	//        < sDR3U17sirTwJ125m39k6E18GxTKBOEjUF7CaQ7a7i6z4blgO4I4A2ZjlmB0qwwR >									
286 	//        <  u =="0.000000000000000001" : ] 000000786481679.036602000000000000 ; 000000817528191.297049000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000004B013684DF72F3 >									
288 	//     < CHEMCHINA_PFIV_III_metadata_line_29_____Nebula_Chemicals_Co_Limited_20260321 >									
289 	//        < ztI1ev52P7Q07Rb72IQ09S3aGKZ8K7M1yyh5Y23g87wbU5E92TwPgbKb4mbP6547 >									
290 	//        <  u =="0.000000000000000001" : ] 000000817528191.297049000000000000 ; 000000855476835.068343000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000004DF72F35195AA4 >									
292 	//     < CHEMCHINA_PFIV_III_metadata_line_30_____Neostar_United_Industrial_Co__Limited_20260321 >									
293 	//        < c7ANl3hf0PO5fEVTMA8oOtZ4eh28zk9Le8167Ua8ZOXNPNIZuceSfedM815gEihA >									
294 	//        <  u =="0.000000000000000001" : ] 000000855476835.068343000000000000 ; 000000880866571.806821000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000005195AA45401881 >									
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
338 	//     < CHEMCHINA_PFIV_III_metadata_line_31_____Nextpeptide_inc__20260321 >									
339 	//        < DB48dfHe1vOlFRgrJW14pyCGugm901nc3vQ79Gp21D352P017rTY268K6NmM4qT9 >									
340 	//        <  u =="0.000000000000000001" : ] 000000880866571.806821000000000000 ; 000000902601880.738128000000000000 ] >									
341 	//        < 0x00000000000000000000000000000000000000000000000000540188156142DC >									
342 	//     < CHEMCHINA_PFIV_III_metadata_line_32_____Ningbo_Nuobai_Pharmaceutical_Co_Limited_20260321 >									
343 	//        < 407s00WROTU7KLZ5C7v5i8962A14HbWwHc5JXh6qs116Tm4mTCb87r11QFimC35v >									
344 	//        <  u =="0.000000000000000001" : ] 000000902601880.738128000000000000 ; 000000933325513.680493000000000000 ] >									
345 	//        < 0x0000000000000000000000000000000000000000000000000056142DC5902447 >									
346 	//     < CHEMCHINA_PFIV_III_metadata_line_33_____NINGBO_V_P_CHEMISTRY_20260321 >									
347 	//        < kWd0ToEWN3aqOjrX5fXbrJgnl96C1zP9L31nTAV8slFSo4AP9ewbqeVsOdxWOsQm >									
348 	//        <  u =="0.000000000000000001" : ] 000000933325513.680493000000000000 ; 000000957294270.626366000000000000 ] >									
349 	//        < 0x0000000000000000000000000000000000000000000000000059024475B4B713 >									
350 	//     < CHEMCHINA_PFIV_III_metadata_line_34_____NovoChemy_Limited_20260321 >									
351 	//        < gnkDvNU15PQ5BE33yIiMKtWUI5yF5CRYq3991UClQAD7qWLg83j8601n8bnVfO60 >									
352 	//        <  u =="0.000000000000000001" : ] 000000957294270.626366000000000000 ; 000000981058493.511684000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000005B4B7135D8F9F9 >									
354 	//     < CHEMCHINA_PFIV_III_metadata_line_35_____Novolite_Chemicals_org_20260321 >									
355 	//        < v93Jd7a0RpSVLR5HGg9J8xi8555L6n5mdPaU15T30odsCsd3TWchS474CkWst68T >									
356 	//        <  u =="0.000000000000000001" : ] 000000981058493.511684000000000000 ; 000001017002919.701070000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000005D8F9F960FD2C4 >									
358 	//     < CHEMCHINA_PFIV_III_metadata_line_36_____Novolite_Chemicals_Co_Limited_20260321 >									
359 	//        < 2UqLl7bfiaFBuPMQfZlAHAz0Y7NrYol7bBLFB306q30LGu3TrG7nO26i76u4l6wT >									
360 	//        <  u =="0.000000000000000001" : ] 000001017002919.701070000000000000 ; 000001054187272.147000000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000060FD2C46488FE7 >									
362 	//     < CHEMCHINA_PFIV_III_metadata_line_37_____Onichem_Specialities_Co__Limited_20260321 >									
363 	//        < 6hU8uR2Q6pYtf4ttWNXUW681n68260sEAVRhsMgSuhh5K467SR7WJEzo6C4703CQ >									
364 	//        <  u =="0.000000000000000001" : ] 000001054187272.147000000000000000 ; 000001075611459.568150000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000006488FE766940BA >									
366 	//     < CHEMCHINA_PFIV_III_metadata_line_38_____Orichem_international_Limited_20260321 >									
367 	//        < sQClRUU1m30sp75zK1rdFIJbN4O3z01o9xMkGn1BdUBM3Q1dpaaU0n5135u5DQr1 >									
368 	//        <  u =="0.000000000000000001" : ] 000001075611459.568150000000000000 ; 000001110149310.723160000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000066940BA69DF413 >									
370 	//     < CHEMCHINA_PFIV_III_metadata_line_39_____PHARMACORE_Co_Limited_20260321 >									
371 	//        < mSs8TkYWLvO933zG42Hdj1tgzr3qeMVgD7JWIkxG05DY6f7408bcU03Wx94F0pUf >									
372 	//        <  u =="0.000000000000000001" : ] 000001110149310.723160000000000000 ; 000001139581781.019570000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000069DF4136CADD22 >									
374 	//     < CHEMCHINA_PFIV_III_metadata_line_40_____Pharmasi_Chemicals_Company_Limited_20260321 >									
375 	//        < iY99Skx4xSLDLHdf5LWRsqL02p5n0JL0gs41W8sT5AGaUtu3NT35V64QG354r5GR >									
376 	//        <  u =="0.000000000000000001" : ] 000001139581781.019570000000000000 ; 000001177245588.806280000000000000 ] >									
377 	//        < 0x000000000000000000000000000000000000000000000000006CADD22704558F >									
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