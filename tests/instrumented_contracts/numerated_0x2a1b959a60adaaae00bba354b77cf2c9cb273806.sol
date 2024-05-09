1 pragma solidity 		^0.4.25	;						
2 										
3 	contract	MELNI_PFX_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	MELNI_PFX_III_883		"	;
8 		string	public		symbol =	"	MELNI_PFX_III_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		857331240466805000000000000					;	
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
92 	//     < MELNI_PFX_III_metadata_line_1_____A_Melnichenko_pp_org_20260316 >									
93 	//        < 57Dt1DIql2U09EgvNK291XsjMr26M08DI50X6miMsId6HcG4mIe4BoiOBu8d0U1r >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000012950938.956561700000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000002036AF >									
96 	//     < MELNI_PFX_III_metadata_line_2_____ASY_admin_org_20260316 >									
97 	//        < y8LqvBDVh6Td0aN0R7Z2AKfi9Pw63iuxAh541q3jyP2oOl14gTH4pf1t4eOeFF6r >									
98 	//        <  u =="0.000000000000000001" : ] 000000012950938.956561700000000000 ; 000000037301358.989025400000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000002036AF3A3B40 >									
100 	//     < MELNI_PFX_III_metadata_line_3_____AMY_admin_org_20260316 >									
101 	//        < xMM5B7s0JE7W4AqcXGB15be0yLr5x66fj4QgsA1T9DD7yDWqCgtJxNySlKP58CgP >									
102 	//        <  u =="0.000000000000000001" : ] 000000037301358.989025400000000000 ; 000000057928652.669008700000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000003A3B40534BF6 >									
104 	//     < MELNI_PFX_III_metadata_line_4_____ASY_infra_org_20260316 >									
105 	//        < 60x92FjNAL1xYR21i7HYndhfYIiq98LkCNPwSCZ1Kt0vueoM9dGBmUTw6KzNJq3y >									
106 	//        <  u =="0.000000000000000001" : ] 000000057928652.669008700000000000 ; 000000080686193.435066000000000000 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000000000534BF672AC51 >									
108 	//     < MELNI_PFX_III_metadata_line_5_____AMY_infra_org_20260316 >									
109 	//        < AZyh4VXXP28Yvwrg4us0J5y6T2wyMYX192LW1Qv498720ZaXosG6xZ4u6T1uf75H >									
110 	//        <  u =="0.000000000000000001" : ] 000000080686193.435066000000000000 ; 000000107119107.095044000000000000 ] >									
111 	//        < 0x000000000000000000000000000000000000000000000000000072AC51945103 >									
112 	//     < MELNI_PFX_III_metadata_line_6_____Donalink_Holding_Limited_chy_AB_20260316 >									
113 	//        < oqnNeNFX47g8mcOzM3aLeYZMDiNMS8zyXEGci3u82Q73Ng3DGmMC5fr8Wzsmmz71 >									
114 	//        <  u =="0.000000000000000001" : ] 000000107119107.095044000000000000 ; 000000121526227.355796000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000945103B5C94E >									
116 	//     < MELNI_PFX_III_metadata_line_7_____Donalink_Holding_org_russ_PL_20260316 >									
117 	//        < fMImn73SVjyfLLd9g2gZos22ZGdY2177YwE3ewuk7TQRIn9132BhcK1WS1dz6k4O >									
118 	//        <  u =="0.000000000000000001" : ] 000000121526227.355796000000000000 ; 000000141913889.136849000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000B5C94EDA2D33 >									
120 	//     < MELNI_PFX_III_metadata_line_8_____Russky_Vlad_RSO_admin_org_20260316 >									
121 	//        < 6XCuNDAAgUQGDH42wVHMF02SxqrQ09qzDMKJS0dWP1j257fy304Tqjr9dMDPHulX >									
122 	//        <  u =="0.000000000000000001" : ] 000000141913889.136849000000000000 ; 000000161629464.641447000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000DA2D33EF3B03 >									
124 	//     < MELNI_PFX_III_metadata_line_9_____RVR_ITB_garantia_org_20260316 >									
125 	//        < q4076r3xCFKB8PDCjH3aSFg78GoIypYO0OQMzpvlQid2hmHQ0b5rQemYy2O5XYTi >									
126 	//        <  u =="0.000000000000000001" : ] 000000161629464.641447000000000000 ; 000000188178157.746438000000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000000EF3B0310B2D65 >									
128 	//     < MELNI_PFX_III_metadata_line_10_____RVR_ITN3_garantia_org_20260316 >									
129 	//        < qBq6F9677JnMZ28s11u5Qt52hgQr8IZHcd56KhNsYIFu1C8b2uIfOjOjtVeHqBA3 >									
130 	//        <  u =="0.000000000000000001" : ] 000000188178157.746438000000000000 ; 000000211460999.184006000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000010B2D6512BAC2C >									
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
174 	//     < MELNI_PFX_III_metadata_line_11_____RVR_LeChiffre_garantia_org_20260316 >									
175 	//        < afi29aVDCDS181111EnnE9MvrC6pvtq0N2d6TIdj7yXRu7g9o5YNdn5tr5JNDSX8 >									
176 	//        <  u =="0.000000000000000001" : ] 000000211460999.184006000000000000 ; 000000224698872.758559000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000012BAC2C13F8CAA >									
178 	//     < MELNI_PFX_III_metadata_line_12_____Far_East_Dev_Corp_20260316 >									
179 	//        < 88ajaV1NRzq97ewUgG6oencwxrb90Q492q765Tx2lOhFyKAoMS714wAJ8HUQHG8h >									
180 	//        <  u =="0.000000000000000001" : ] 000000224698872.758559000000000000 ; 000000246566286.235368000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000013F8CAA15F80D4 >									
182 	//     < MELNI_PFX_III_metadata_line_13_____Trans_Baïkal_geo_org_20260316 >									
183 	//        < 2BeF9Gn0NE072x9s6HzG0Aglh3rzHht9j5Mr7466nhLB9Xhf6i14840iseIAYh8L >									
184 	//        <  u =="0.000000000000000001" : ] 000000246566286.235368000000000000 ; 000000264164477.485319000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000015F80D417867EC >									
186 	//     < MELNI_PFX_III_metadata_line_14_____Khabarovsk_geo_org_20260316 >									
187 	//        < pd5GA9p5q8X8qglm8jg28W2x3Hc1thl8kGl6Q55UnD3dnj6xI5mpaMepAoK0TTsz >									
188 	//        <  u =="0.000000000000000001" : ] 000000264164477.485319000000000000 ; 000000288623061.658563000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000017867EC196802A >									
190 	//     < MELNI_PFX_III_metadata_line_15_____Primorsky_geo_org_20260316 >									
191 	//        < ept6HGL7WHN7Fy1PshPoJ8HOJyurOzj72dScs2WlsBSiSgM9r5IGd75b28OyVx51 >									
192 	//        <  u =="0.000000000000000001" : ] 000000288623061.658563000000000000 ; 000000316857399.442054000000000000 ] >									
193 	//        < 0x00000000000000000000000000000000000000000000000000196802A1AE760A >									
194 	//     < MELNI_PFX_III_metadata_line_16_____Vanino_infra_org_20260316 >									
195 	//        < 0a51AxMkEBLLSmk7PpL8RUZDGb2DYrh8QEZXK3ukm22URaVf49848qkd5PtlWu87 >									
196 	//        <  u =="0.000000000000000001" : ] 000000316857399.442054000000000000 ; 000000334005727.348600000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000001AE760A1D48683 >									
198 	//     < MELNI_PFX_III_metadata_line_17_____Nakhodka_infra_org_20260316 >									
199 	//        < HrQZrfuoX9sqw64j1OOd3F6CV2WLa7y2x2Sr3v32wAK2tw3j9AcLi6F5e1744Oji >									
200 	//        <  u =="0.000000000000000001" : ] 000000334005727.348600000000000000 ; 000000362249338.163160000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000001D486831F66B68 >									
202 	//     < MELNI_PFX_III_metadata_line_18_____Primorsky_meta_infra_org_20260316 >									
203 	//        < ZgsR9QCZz98faB2tsyq029m7h8A11W2z3vQrE3jmd251t33h760gIlerP04pB77e >									
204 	//        <  u =="0.000000000000000001" : ] 000000362249338.163160000000000000 ; 000000379426318.210664000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000001F66B68213B8AB >									
206 	//     < MELNI_PFX_III_metadata_line_19_____Siberian_Coal_Energy_Company_SUEK_20260316 >									
207 	//        < 7V63x0uSlpLwTP3En8lVr69NHH1IxNJ139pbW19LquG5n6NdWVI76wl32vSRC5ym >									
208 	//        <  u =="0.000000000000000001" : ] 000000379426318.210664000000000000 ; 000000402929494.141762000000000000 ] >									
209 	//        < 0x00000000000000000000000000000000000000000000000000213B8AB22AF193 >									
210 	//     < MELNI_PFX_III_metadata_line_20_____Siberian_Generating_Company_SGC_20260316 >									
211 	//        < 2Pea2Hsl853N1H1T0K93201huBv5fe448oT61lT80up72tTf7lQrmjLxe0t536LJ >									
212 	//        <  u =="0.000000000000000001" : ] 000000402929494.141762000000000000 ; 000000422499733.965454000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000022AF193245A639 >									
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
256 	//     < MELNI_PFX_III_metadata_line_21_____Yenisei_Territorial_Generating_Company_TGC_20260316 >									
257 	//        < 7bs1B0ijK3bBbNjeRU07rKho7wqCaCOS3mE3wYa06w2H857p5ynl93r46455r826 >									
258 	//        <  u =="0.000000000000000001" : ] 000000422499733.965454000000000000 ; 000000441567276.402357000000000000 ] >									
259 	//        < 0x00000000000000000000000000000000000000000000000000245A63925BAD54 >									
260 	//     < MELNI_PFX_III_metadata_line_22_____AIM_Capital_SE_20260316 >									
261 	//        < 0tlWYjT5eDcEH8kV9Cb1O5HVIL4gl9T35epxI5JIUXEa3aK9Gtcw04N12igG6Zn9 >									
262 	//        <  u =="0.000000000000000001" : ] 000000441567276.402357000000000000 ; 000000461945258.194061000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000025BAD542722899 >									
264 	//     < MELNI_PFX_III_metadata_line_23_____Eurochem_group_evrokhim_20260316 >									
265 	//        < k2f6kFVdaaB6s7nvKe48S5YuT0e9GD43B99XALSC3t7NheD4XAm96sA0dpK3hmB4 >									
266 	//        <  u =="0.000000000000000001" : ] 000000461945258.194061000000000000 ; 000000489171396.606914000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000027228992962E67 >									
268 	//     < MELNI_PFX_III_metadata_line_24_____Kovdor_org_20260316 >									
269 	//        < XB87dR9zD44Vv9090cu7WbO9pZPegIc0hJ3OX67kSLR6Rb89fwn1ur6g8p43ox2l >									
270 	//        <  u =="0.000000000000000001" : ] 000000489171396.606914000000000000 ; 000000514558103.641743000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000002962E672B6E413 >									
272 	//     < MELNI_PFX_III_metadata_line_25_____OJSC_Murmansk_Commercial_Seaport_20260316 >									
273 	//        < w77I4G3BcG8mblWC2g70O8uOK1y7m6O6zHf3Mj7Ykf1B9W5r8of3OqE9EfAAxl91 >									
274 	//        <  u =="0.000000000000000001" : ] 000000514558103.641743000000000000 ; 000000534957216.986615000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002B6E4132CC4D79 >									
276 	//     < MELNI_PFX_III_metadata_line_26_____BASF_Antwerpen_AB_20260316 >									
277 	//        < 2f53nYFHTW7ISU8Q7zP2PasH6lzsO6412EpFPy52h39cyck2DtW4cr62ZlA7r2my >									
278 	//        <  u =="0.000000000000000001" : ] 000000534957216.986615000000000000 ; 000000551132883.315576000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000002CC4D792EE7B73 >									
280 	//     < MELNI_PFX_III_metadata_line_27_____Eurochem_Antwerpen_20260316 >									
281 	//        < VmalQd6cBD976YaEy4x42L3KcYuc8k8Ob42527JSQa7E4j1H4326H4FjA3M6zO81 >									
282 	//        <  u =="0.000000000000000001" : ] 000000551132883.315576000000000000 ; 000000573952943.899082000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000002EE7B73302CCDF >									
284 	//     < MELNI_PFX_III_metadata_line_28_____Eurochem_Agro_20260316 >									
285 	//        < PP2R5ur7rQnmgm9fBQC72Vkm5igYKN5hG9Qq8O22T4JalMD2rPPi525aPc64JWaY >									
286 	//        <  u =="0.000000000000000001" : ] 000000573952943.899082000000000000 ; 000000588461801.205037000000000000 ] >									
287 	//        < 0x00000000000000000000000000000000000000000000000000302CCDF323E362 >									
288 	//     < MELNI_PFX_III_metadata_line_29_____Mannheimer_KplusS_AB_20260316 >									
289 	//        < t7cBlKEMUfWK7t6332y477F68WU0izyw2yot3O58lRjUU968BOGHeRl6sriGXhq2 >									
290 	//        <  u =="0.000000000000000001" : ] 000000588461801.205037000000000000 ; 000000617412801.436101000000000000 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000000000323E36234283AC >									
292 	//     < MELNI_PFX_III_metadata_line_30_____Iamali_Severneft_Ourengoi_20260316 >									
293 	//        < hvQGcotz7ZX5l65H0PCOSI2w58FEeYs5T6G7Spn9qhiqbWJI80y7r43KE9Q6vPK6 >									
294 	//        <  u =="0.000000000000000001" : ] 000000617412801.436101000000000000 ; 000000643995731.857002000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000034283AC361C656 >									
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
338 	//     < MELNI_PFX_III_metadata_line_31_____Djambouli_SORL_kazakhe_Sary_Tas_20260316 >									
339 	//        < 9oNEftgA0Ojo28xf1Yo0m1c2610h7Z75M837SNu1y98BrhiR5tWvX0VIHwXY3Q6c >									
340 	//        <  u =="0.000000000000000001" : ] 000000643995731.857002000000000000 ; 000000661118225.735858000000000000 ] >									
341 	//        < 0x00000000000000000000000000000000000000000000000000361C6563773667 >									
342 	//     < MELNI_PFX_III_metadata_line_32_____Tyance_org_20260316 >									
343 	//        < 35vj33i1ZcSP7fkRfFdzVnsi3znJu1b9H0YiQ37pg1V2vrun1eAC4OO5vP081T1k >									
344 	//        <  u =="0.000000000000000001" : ] 000000661118225.735858000000000000 ; 000000680494727.346817000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000003773667392C58E >									
346 	//     < MELNI_PFX_III_metadata_line_33_____Tyance_Climat_org_20260316 >									
347 	//        < WBgCzxg1bRSLAd838N7y29Vl22nlmT8ST6c94qDuda4X4v6MqvH2h2m0PPL39zEK >									
348 	//        <  u =="0.000000000000000001" : ] 000000680494727.346817000000000000 ; 000000697477864.479661000000000000 ] >									
349 	//        < 0x00000000000000000000000000000000000000000000000000392C58E3ACE099 >									
350 	//     < MELNI_PFX_III_metadata_line_34_____Rospotrebnadzor_org_20260316 >									
351 	//        < mgMnr1HUnxd5Vc782Vu8A26RRZ64X09WoksyF50c9Fq56hID9147vOGBOd79AobS >									
352 	//        <  u =="0.000000000000000001" : ] 000000697477864.479661000000000000 ; 000000719338689.861269000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000003ACE0993D14043 >									
354 	//     < MELNI_PFX_III_metadata_line_35_____Kinguissepp_Eurochem_infra_org_20260316 >									
355 	//        < BvCSzc99HBd6DaBhlEmHbAp2D9AA753gkt6omSuYyMS5TxYoF9a8F295IZLHUmc6 >									
356 	//        <  u =="0.000000000000000001" : ] 000000719338689.861269000000000000 ; 000000741140572.700446000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000003D140433E7EF64 >									
358 	//     < MELNI_PFX_III_metadata_line_36_____Louga_EUrochem_infra_org_20260316 >									
359 	//        < Q7OXIvW5ihbadOH0QMDu5jmq5C5651H0gqlcExOSCt3qz0Khs7E5Rk0zCP3X7oNd >									
360 	//        <  u =="0.000000000000000001" : ] 000000741140572.700446000000000000 ; 000000761163702.168767000000000000 ] >									
361 	//        < 0x000000000000000000000000000000000000000000000000003E7EF644062E18 >									
362 	//     < MELNI_PFX_III_metadata_line_37_____Finnish_Environment_Institute_org_20260316 >									
363 	//        < 6H4h5820G5Yt8967gVIvIPpxeJt1kOsL2t5uI4EZWTX09W5SY39Plj8v0g422M8Z >									
364 	//        <  u =="0.000000000000000001" : ] 000000761163702.168767000000000000 ; 000000781590316.366926000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000004062E1842008EB >									
366 	//     < MELNI_PFX_III_metadata_line_38_____Helcom_org_20260316 >									
367 	//        < jbl665i0v7m9593H5bjV2R2Jub5KO9Qh5cSO4fA0u0xW7Bil2fRE1LU1QQ3Wi7Tk >									
368 	//        <  u =="0.000000000000000001" : ] 000000781590316.366926000000000000 ; 000000808941354.398375000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000042008EB437DAA0 >									
370 	//     < MELNI_PFX_III_metadata_line_39_____Eurochem_Baltic_geo_org_20260316 >									
371 	//        < Jgm6yuhiJqP88jX4awwO86Bze0JEc96Jl5Zv0t04XXYaQ1JmaC1EhaMvL6Jz9O4s >									
372 	//        <  u =="0.000000000000000001" : ] 000000808941354.398375000000000000 ; 000000832295302.848697000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000437DAA0451DCC3 >									
374 	//     < MELNI_PFX_III_metadata_line_40_____John_Nurminen_Stiftung_org_20260316 >									
375 	//        < 0jc7Xwk7xsJiSqQwFdamLWlBo0P76uYrl85koPcDd9H18h6530UN65UFwoOUc7kI >									
376 	//        <  u =="0.000000000000000001" : ] 000000832295302.848697000000000000 ; 000000857331240.466805000000000000 ] >									
377 	//        < 0x00000000000000000000000000000000000000000000000000451DCC34769FB1 >									
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