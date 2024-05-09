1 pragma solidity 		^0.4.25	;						
2 										
3 	contract	CHEMCHINA_PFV_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	CHEMCHINA_PFV_III_883		"	;
8 		string	public		symbol =	"	CHEMCHINA_PFV_III_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1049417559213730000000000000					;	
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
92 	//     < CHEMCHINA_PFV_III_metadata_line_1_____Psyclo_Peptide,_inc__20260321 >									
93 	//        < D7w7878W2XbaYFd26QHoP4w8GIOfVUTQI90RZToZt010mtFE53gXHg0UV8hfMLe9 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000026753902.786040500000000000 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000000028D2BE >									
96 	//     < CHEMCHINA_PFV_III_metadata_line_2_____Purestar_Chem_Enterprise_Co_Limited_20260321 >									
97 	//        < uY73i2jXsjbdK74ylu5514mwQc4bXEfh4143PTYfzVh4OY1E79HVue5oPe4Kgrz6 >									
98 	//        <  u =="0.000000000000000001" : ] 000000026753902.786040500000000000 ; 000000048488157.744927100000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000028D2BE49FCB0 >									
100 	//     < CHEMCHINA_PFV_III_metadata_line_3_____Puyer_BioPharma_20260321 >									
101 	//        < 7R8t475gdqdPu4Q0MZRAUUZFSgprL1447tQ2K921c9J5awAB9x0ob0HpeH9hpXC3 >									
102 	//        <  u =="0.000000000000000001" : ] 000000048488157.744927100000000000 ; 000000079239609.801618400000000000 ] >									
103 	//        < 0x000000000000000000000000000000000000000000000000000049FCB078E8F9 >									
104 	//     < CHEMCHINA_PFV_III_metadata_line_4_____Qi_Chem_org_20260321 >									
105 	//        < v98GgkW7575Rgw1f08KJ86Nn69i7tHZ71jJzA470s7P3A6LoPG6OL7Nj082JapxF >									
106 	//        <  u =="0.000000000000000001" : ] 000000079239609.801618400000000000 ; 000000112507678.291400000000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000078E8F9ABAC50 >									
108 	//     < CHEMCHINA_PFV_III_metadata_line_5_____Qi_Chem_Co_Limited_20260321 >									
109 	//        < K839UWw356B3W10v1HgaM3ZeE5MDBMu1X80gNLNl2iedplL1Pv2J83KdHmrtsWZm >									
110 	//        <  u =="0.000000000000000001" : ] 000000112507678.291400000000000000 ; 000000136837916.242280000000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000ABAC50D0CC50 >									
112 	//     < CHEMCHINA_PFV_III_metadata_line_6_____Qingdao_Yimingxiang_Fine_Chemical_Technology_Co_Limited_20260321 >									
113 	//        < OXy6qN4cDWCYa2cXcRv7v0DqMV6YLZi66ElsTTySgqJEGjFlw8E26eyi4UuZz59U >									
114 	//        <  u =="0.000000000000000001" : ] 000000136837916.242280000000000000 ; 000000166306299.382079000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000D0CC50FDC366 >									
116 	//     < CHEMCHINA_PFV_III_metadata_line_7_____Qinmu_fine_chemical_Co_Limited_20260321 >									
117 	//        < 60W7QMD7vK4SYiBJuED8Vne2HjIz111zYVTazfAr2qiWvH1f9PoaWWNHf062c1GE >									
118 	//        <  u =="0.000000000000000001" : ] 000000166306299.382079000000000000 ; 000000186847048.676320000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000000FDC36611D1B21 >									
120 	//     < CHEMCHINA_PFV_III_metadata_line_8_____Quzhou_Ruiyuan_Chemical_Co_Limited_20260321 >									
121 	//        < 937Fk487hhGhMfbSh9xT6514rTlF57V4HBzm81PmX5bUquG976Op2EKbo45E9e96 >									
122 	//        <  u =="0.000000000000000001" : ] 000000186847048.676320000000000000 ; 000000209498663.204088000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000011D1B2113FAB6A >									
124 	//     < CHEMCHINA_PFV_III_metadata_line_9_____RennoTech_Co__Limited_20260321 >									
125 	//        < Tvo8mdvBgc9JGW75jyyboq9waNieLF501I2jcXM00Z5Ac0gJe94Ol2i8Y066EAE0 >									
126 	//        <  u =="0.000000000000000001" : ] 000000209498663.204088000000000000 ; 000000231646886.147290000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000013FAB6A1617711 >									
128 	//     < CHEMCHINA_PFV_III_metadata_line_10_____Richap_Chem_20260321 >									
129 	//        < 462ZxevQjKVmxdbxeeO6lg9M0JeluOz3DS9VxbEU26K599Z77qER70XR1CxS5ORy >									
130 	//        <  u =="0.000000000000000001" : ] 000000231646886.147290000000000000 ; 000000260202155.854705000000000000 ] >									
131 	//        < 0x00000000000000000000000000000000000000000000000000161771118D0978 >									
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
174 	//     < CHEMCHINA_PFV_III_metadata_line_11_____Ronas_Chemicals_org_20260321 >									
175 	//        < 3j15fWNnYM9gAImzk2JpBiG87I9cY1iJ3Mmf66mzDE0l1y09DChz0Uim5E3T2iAW >									
176 	//        <  u =="0.000000000000000001" : ] 000000260202155.854705000000000000 ; 000000284620734.806845000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000018D09781B24BF9 >									
178 	//     < CHEMCHINA_PFV_III_metadata_line_12_____Ronas_Chemicals_Ind_Co_Limited_20260321 >									
179 	//        < 6Xf0aP92p59z8H8jnyFYAhx52L2hE7eoAyEwky5c506DV0rWTO96kO2t803jTQyx >									
180 	//        <  u =="0.000000000000000001" : ] 000000284620734.806845000000000000 ; 000000318062836.437625000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000001B24BF91E5534C >									
182 	//     < CHEMCHINA_PFV_III_metadata_line_13_____Rudong_Zhenfeng_Yiyang_Chemical_Co__Limited_20260321 >									
183 	//        < RqkP0KXfkpfW7iV3Fn3m008pA3SDA3Uk64SnjFgQIGfsmDXpl6085asakE0y6zAy >									
184 	//        <  u =="0.000000000000000001" : ] 000000318062836.437625000000000000 ; 000000343696181.851391000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001E5534C20C7052 >									
186 	//     < CHEMCHINA_PFV_III_metadata_line_14_____SAGECHEM_LIMITED_20260321 >									
187 	//        < 30rT0Yh3zmbUMbzd3R88lKWN0KlfpQu7n7au0ZjCsIU3FvZ339P7AHz7O5T8q9PF >									
188 	//        <  u =="0.000000000000000001" : ] 000000343696181.851391000000000000 ; 000000364418077.696269000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000020C705222C0ED0 >									
190 	//     < CHEMCHINA_PFV_III_metadata_line_15_____Shandong_Changsheng_New_Flame_Retardant_Co__Limited_20260321 >									
191 	//        < RFJDcWZ17g4NM61Zg5a90g44yLTqoFVlHfYMR0iZEX0vjsIR1a3BS7AXUp8IiIEJ >									
192 	//        <  u =="0.000000000000000001" : ] 000000364418077.696269000000000000 ; 000000390915640.792181000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000022C0ED02547D6C >									
194 	//     < CHEMCHINA_PFV_III_metadata_line_16_____Shandong_Shengda_Technology_Co__Limited_20260321 >									
195 	//        < w1vS40oXHMiBWir3q7D37XO1bgHv6JhDac0PhM3UnzUTvtr99686XaSP41s7TwZM >									
196 	//        <  u =="0.000000000000000001" : ] 000000390915640.792181000000000000 ; 000000413308360.678012000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000002547D6C276A894 >									
198 	//     < CHEMCHINA_PFV_III_metadata_line_17_____Shangfluoro_20260321 >									
199 	//        < 6q3Uul5AmVpBwd800R4Z1RfwFdhQpG0eEnAx74CeORI2orMo6168cxC6H75uWF9e >									
200 	//        <  u =="0.000000000000000001" : ] 000000413308360.678012000000000000 ; 000000434151751.221942000000000000 ] >									
201 	//        < 0x00000000000000000000000000000000000000000000000000276A8942967687 >									
202 	//     < CHEMCHINA_PFV_III_metadata_line_18_____Shanghai_Activated_Carbon_Co__Limited_20260321 >									
203 	//        < 4I02Eabk4UBQYU45tMddHGL7TEPbXs9ITWA0BuuBRwY6xmF3GF65T61TtWIl7rD4 >									
204 	//        <  u =="0.000000000000000001" : ] 000000434151751.221942000000000000 ; 000000463390507.398979000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000029676872C313EB >									
206 	//     < CHEMCHINA_PFV_III_metadata_line_19_____Shanghai_AQ_BioPharma_org_20260321 >									
207 	//        < TX4qi4497bW2g1fpXPK5C0MQrG97krI4x0KBB9Nt6vSdo6p53pUL48O2glt9Y342 >									
208 	//        <  u =="0.000000000000000001" : ] 000000463390507.398979000000000000 ; 000000484913231.343461000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000002C313EB2E3EB3B >									
210 	//     < CHEMCHINA_PFV_III_metadata_line_20_____Shanghai_AQ_BioPharma_20260321 >									
211 	//        < 58oK11Ni5laqW1o9Edb60hvH76BLrtXfl7sDTnXsWGNmt8UrpsPq96KozFmCr09i >									
212 	//        <  u =="0.000000000000000001" : ] 000000484913231.343461000000000000 ; 000000513498613.547007000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000002E3EB3B30F8965 >									
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
256 	//     < CHEMCHINA_PFV_III_metadata_line_21_____SHANGHAI_ARCADIA_BIOTECHNOLOGY_Limited_20260321 >									
257 	//        < 5PY8fwtUViUY275M3ZY2Whj502KV2aGsX06rLasMlat7s0199kKTKtAItc6V73k0 >									
258 	//        <  u =="0.000000000000000001" : ] 000000513498613.547007000000000000 ; 000000538854753.635520000000000000 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000000030F89653363A23 >									
260 	//     < CHEMCHINA_PFV_III_metadata_line_22_____Shanghai_BenRo_Chemical_Co_Limited_20260321 >									
261 	//        < f8aRbrkG3XiOg0X225893O0PYO1I7p5rBLaH1m12S9DLj8i8yyqqb534M0QboCm7 >									
262 	//        <  u =="0.000000000000000001" : ] 000000538854753.635520000000000000 ; 000000561765006.179058000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000003363A233592F75 >									
264 	//     < CHEMCHINA_PFV_III_metadata_line_23_____Shanghai_Brothchem_Bio_Tech_Co_Limited_20260321 >									
265 	//        < egcM4l9jy9m7F3t137n8G7Rrn72W4JdQvpRG1pRufL6Pj8gZM2Yw1yE4VjBDl609 >									
266 	//        <  u =="0.000000000000000001" : ] 000000561765006.179058000000000000 ; 000000583365805.535326000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000003592F7537A2545 >									
268 	//     < CHEMCHINA_PFV_III_metadata_line_24_____SHANGHAI_CHEMHERE_Co_Limited_20260321 >									
269 	//        < 6DLEnbcQ3W14id5JYu67c0981pYp66s7dam1w82OLWttpo6Q4V2KwJ5g9r38lC3T >									
270 	//        <  u =="0.000000000000000001" : ] 000000583365805.535326000000000000 ; 000000609897021.465080000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000037A25453A2A106 >									
272 	//     < CHEMCHINA_PFV_III_metadata_line_25_____Shanghai_ChemVia_Co_Limited_20260321 >									
273 	//        < rESTz2t78BzU91C2lUu7a5bIQC6KBexwhyvNY7jO4nHG4mirE1418eURR2Ig2tR3 >									
274 	//        <  u =="0.000000000000000001" : ] 000000609897021.465080000000000000 ; 000000633276857.664512000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000003A2A1063C64DC6 >									
276 	//     < CHEMCHINA_PFV_III_metadata_line_26_____Shanghai_Coming_Hi_Technology_Co__Limited_20260321 >									
277 	//        < IyRj0Uk39Fc2Yf648l8hb09903m6du2dAD99Si77jdyoEl9WX47Mvq068Z1Y8ART >									
278 	//        <  u =="0.000000000000000001" : ] 000000633276857.664512000000000000 ; 000000667168082.061572000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000003C64DC63FA0488 >									
280 	//     < CHEMCHINA_PFV_III_metadata_line_27_____Shanghai_EachChem_org_20260321 >									
281 	//        < 9H9o8k1d68iUmSUKlmphFjIf3J6k8fy8sDt2z05M4M08Xqcdno3Mbm41iCQn8A8d >									
282 	//        <  u =="0.000000000000000001" : ] 000000667168082.061572000000000000 ; 000000690063403.197465000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000003FA048841CF404 >									
284 	//     < CHEMCHINA_PFV_III_metadata_line_28_____Shanghai_EachChem_Co__Limited_20260321 >									
285 	//        < 3I0d6lr38vqwCkQ464c5l3poP819J1SVEnDDnrYruk3Z6K9UWX8a65zJ7HM46YG1 >									
286 	//        <  u =="0.000000000000000001" : ] 000000690063403.197465000000000000 ; 000000711576623.998260000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000041CF40443DC79E >									
288 	//     < CHEMCHINA_PFV_III_metadata_line_29_____Shanghai_FChemicals_Technology_Co_Limited_20260321 >									
289 	//        < 781F2HbUMYHffpMUf8Ip4FLln4794jTO6YY1yJQloqu2eUw01ic0RHlFZ6yv3b37 >									
290 	//        <  u =="0.000000000000000001" : ] 000000711576623.998260000000000000 ; 000000734555962.225336000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000043DC79E460D7EC >									
292 	//     < CHEMCHINA_PFV_III_metadata_line_30_____Shanghai_Fuxin_Pharmaceutical_Co__Limited_20260321 >									
293 	//        < f2s1RCsoKElnipPcVqLo7Y1Xi0qwcQ66rSdG6h12rFnToX0gJXz0JkSHXYlAIkgh >									
294 	//        <  u =="0.000000000000000001" : ] 000000734555962.225336000000000000 ; 000000766932431.909562000000000000 ] >									
295 	//        < 0x00000000000000000000000000000000000000000000000000460D7EC4923EFB >									
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
338 	//     < CHEMCHINA_PFV_III_metadata_line_31_____Shanghai_Goldenmall_biotechnology_Co__Limited_20260321 >									
339 	//        < Oxv3T09268V9073ntS19Z8xXrr9hyj2gVmuRY6JXCcgwRYb25R2AmA54vFnztf74 >									
340 	//        <  u =="0.000000000000000001" : ] 000000766932431.909562000000000000 ; 000000794597951.886643000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000004923EFB4BC75D3 >									
342 	//     < CHEMCHINA_PFV_III_metadata_line_32_____Shanghai_Hope_Chem_Co__Limited_20260321 >									
343 	//        < 117ekMHRHF9w30JKwK60781GsEO5jZh649i53U8b7xgSJr5q4dQ4UyV9gnKhgo2v >									
344 	//        <  u =="0.000000000000000001" : ] 000000794597951.886643000000000000 ; 000000828205910.751683000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000004BC75D34EFBDEF >									
346 	//     < CHEMCHINA_PFV_III_metadata_line_33_____SHANGHAI_IMMENSE_CHEMICAL_org_20260321 >									
347 	//        < 1FErQb6wIt14F8ro33iS20OtmBrcD61rdQgb8zdY8dk937V7n755bE3y8747vcIW >									
348 	//        <  u =="0.000000000000000001" : ] 000000828205910.751683000000000000 ; 000000851524207.081024000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000004EFBDEF51352A5 >									
350 	//     < CHEMCHINA_PFV_III_metadata_line_34_____SHANGHAI_IMMENSE_CHEMICAL_Co_Limited_20260321 >									
351 	//        < CER7HKAZ9xmj1BIC99U7qzEJ5HKJk3oaCM62RTVTPVeB0qMnf5xtk7oCn5PmFFFC >									
352 	//        <  u =="0.000000000000000001" : ] 000000851524207.081024000000000000 ; 000000877813159.745108000000000000 ] >									
353 	//        < 0x0000000000000000000000000000000000000000000000000051352A553B6FC4 >									
354 	//     < CHEMCHINA_PFV_III_metadata_line_35_____Shanghai_MC_Pharmatech_Co_Limited_20260321 >									
355 	//        < W0P9j1R1s64K5X3l0ihvQQdPlDmV8UyI5Uju47YGvkI8zHhJ4A63qA0MB8Pjl77y >									
356 	//        <  u =="0.000000000000000001" : ] 000000877813159.745108000000000000 ; 000000905452095.189771000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000053B6FC45659C3A >									
358 	//     < CHEMCHINA_PFV_III_metadata_line_36_____Shanghai_Mintchem_Development_Co_Limited_20260321 >									
359 	//        < M7ROzl625rfDkp7wyJRnK54BJnYm0plr96L4iC2I7OB40uqbmwB0cg4kGp5P01fx >									
360 	//        <  u =="0.000000000000000001" : ] 000000905452095.189771000000000000 ; 000000928198577.404112000000000000 ] >									
361 	//        < 0x000000000000000000000000000000000000000000000000005659C3A5885192 >									
362 	//     < CHEMCHINA_PFV_III_metadata_line_37_____Shanghai_NuoCheng_Pharmaceutical_Co_Limited_20260321 >									
363 	//        < dV9bf4gA795m2gwzu66ZBjs1JiXh2rb3LDIlsrFce4KkoHI967fuZLkJx634JN37 >									
364 	//        <  u =="0.000000000000000001" : ] 000000928198577.404112000000000000 ; 000000956999165.530417000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000058851925B443CD >									
366 	//     < CHEMCHINA_PFV_III_metadata_line_38_____Shanghai_Oripharm_Co_Limited_20260321 >									
367 	//        < 837I0E062FOe30SqSws13Skq543N50Otxr5xGWv3H50pcLjnEvBkee5cwLo5LGK9 >									
368 	//        <  u =="0.000000000000000001" : ] 000000956999165.530417000000000000 ; 000000981311426.116820000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000005B443CD5D95CC7 >									
370 	//     < CHEMCHINA_PFV_III_metadata_line_39_____Shanghai_PI_Chemicals_org_20260321 >									
371 	//        < z7d64P5Gu8Vp4MtDoBNJia21wg6P0ZKU1ugj5R4LDZr1kWWwsaC13SIOMbsLerLh >									
372 	//        <  u =="0.000000000000000001" : ] 000000981311426.116820000000000000 ; 000001016570593.890650000000000000 ] >									
373 	//        < 0x000000000000000000000000000000000000000000000000005D95CC760F29E3 >									
374 	//     < CHEMCHINA_PFV_III_metadata_line_40_____Shanghai_PI_Chemicals_Ltd_20260321 >									
375 	//        < D96mlCDz3aQrU2v09MRtU8kN8WWlE3r2NZd84y8SPh449xO20hA7A0rYse9s1bF8 >									
376 	//        <  u =="0.000000000000000001" : ] 000001016570593.890650000000000000 ; 000001049417559.213730000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000060F29E364148BC >									
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