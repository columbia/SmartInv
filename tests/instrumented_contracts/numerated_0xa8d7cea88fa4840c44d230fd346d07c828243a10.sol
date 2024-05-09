1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	FGRE_Portfolio_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	FGRE_Portfolio_I_883		"	;
8 		string	public		symbol =	"	FGRE883I		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1579789427442530000000000000000					;	
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
92 	//     < FGRE_Portfolio_I_metadata_line_1_____Caisse_Centrale_de_Reassurance_20580515 >									
93 	//        < YUDQk3wcl09JG5imzMAar9iaS2FvL2ziH9c5dl88vkoYU89zP2rR8K9T174WA03Y >									
94 	//        < 1E-018 limites [ 1E-018 ; 583308360,349711 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000037A0ED4 >									
96 	//     < FGRE_Portfolio_I_metadata_line_2_____CCR_FGRE_Fonds_de_Garantie_des_Risques_lies_a_l_Epandage_des_Boues_d_Epuration_Urbaines_et_Industrielles_20580515 >									
97 	//        < 3KnAoRDyNvOU3QdAHz24Fsr2T5sn9X2k0bYK58f2dCc45W2xN8t2L7UFOHUVowmn >									
98 	//        < 1E-018 limites [ 583308360,349711 ; 14474986111,6764 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000037A0ED456471373 >									
100 	//     < FGRE_Portfolio_I_metadata_line_3_____SYDEME_20580515 >									
101 	//        < ae9c4lfy8FZavqKMr6qOMN8Z8hw9szxRxuToWQyf8Sg3Cz3kWm7Uxrq5VjzYh50t >									
102 	//        < 1E-018 limites [ 14474986111,6764 ; 116485338032,792 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000564713732B64E852B >									
104 	//     < FGRE_Portfolio_I_metadata_line_4_____REGIE_ECOTRI_MOSELLE_EST_20580515 >									
105 	//        < iCMccCB5rSSDuVuG3sv6W8T3tUhR1591nCUp9sZi7R1SDGfnLYR5mE18U91qQbB1 >									
106 	//        < 1E-018 limites [ 116485338032,792 ; 209932995521,122 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000002B64E852B4E34C5460 >									
108 	//     < FGRE_Portfolio_I_metadata_line_5_____REGIE_CSM_CONFECTION_DES_SACS_MULTI_FLUX_20580515 >									
109 	//        < m2ZNyF0u7U949W71xRD4kG6lzhCb0cwCNXK85o5P0vGDv71ywZ3iG41bBIkc6kR2 >									
110 	//        < 1E-018 limites [ 209932995521,122 ; 211516755249,413 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000004E34C54604ECBCF485 >									
112 	//     < FGRE_Portfolio_I_metadata_line_6_____REGIE_DSM_DISTRIBUTION_DES_SACS_MULTI_FLUX_20580515 >									
113 	//        < 6B9jOLkxcovb71r03VmOan1jh1ZNdnm83LW2AbGz9gbhYQl6VXZ0EKDa4J5fu70Q >									
114 	//        < 1E-018 limites [ 211516755249,413 ; 217233497687,824 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000004ECBCF48550ED00309 >									
116 	//     < FGRE_Portfolio_I_metadata_line_7_____SEM_SYDEME_DEVELOPPEMENT_20580515 >									
117 	//        < 0weKjfou5o7in70W6kpYO1j5EmM1lTP98FKDx075X1VlKO413q4mYM6sp50LNvBz >									
118 	//        < 1E-018 limites [ 217233497687,824 ; 347409536125,431 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000050ED00309816B8E20D >									
120 	//     < FGRE_Portfolio_I_metadata_line_8_____METHAVOS_SAS_20580515 >									
121 	//        < hLWzVc3i6jrVK7VcG7xsHH6N9p9f4kB75KgF8v7WplglwKmMc5vyQ6M2XWk4C200 >									
122 	//        < 1E-018 limites [ 347409536125,431 ; 514961961032,884 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000816B8E20DBFD699807 >									
124 	//     < FGRE_Portfolio_I_metadata_line_9_____SPIRAL_TRANS_SAS_20580515 >									
125 	//        < EEw3tE0MUhhID9WJ808VL18h8vs62bly8OB60p7V4F2E8H11zxP3bW20Rd5G6k9N >									
126 	//        < 1E-018 limites [ 514961961032,884 ; 515530143640,136 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000BFD699807C00CC925C >									
128 	//     < FGRE_Portfolio_I_metadata_line_10_____GROUPE_LINGENHELD_SA_20580515 >									
129 	//        < S3au6E564xtyD00H7h4N3KflaT0Rva82U3gnEE482DvGjlpgijHm90YkfR94wLUV >									
130 	//        < 1E-018 limites [ 515530143640,136 ; 538733364022,892 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000C00CC925CC8B19E052 >									
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
174 	//     < FGRE_Portfolio_I_metadata_line_11_____SYDEME_OBS_DAO_20580515 >									
175 	//        < 7316yu1I56G6rcGTWV0IYWXU7U7h7Mz8D9Pal6bJwawwNL8pk9MzZN2w90yGVPcX >									
176 	//        < 1E-018 limites [ 538733364022,892 ; 540501557075,614 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000C8B19E052C95A3ECBC >									
178 	//     < FGRE_Portfolio_I_metadata_line_12_____REGIE_ECOTRI_MOSELLE_EST_OBS_DAO_20580515 >									
179 	//        < InjbgG1SKvS7bHM4wlkDhspVhZYxCn2bRgFGk4SRU587YYpi03L7y90Y1D3GWjkb >									
180 	//        < 1E-018 limites [ 540501557075,614 ; 543232351839,997 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000C95A3ECBCCA5EAC970 >									
182 	//     < FGRE_Portfolio_I_metadata_line_13_____REGIE_CSM_CONFECTION_DES_SACS_MULTI_FLUX_OBS_DAO_20580515 >									
183 	//        < AXUg7FexC2j8Pd6YRv8z38ReZiXzCz33aaW7Eoq8Z41Uptp6Useby4iYecEcZC91 >									
184 	//        < 1E-018 limites [ 543232351839,997 ; 557612521960,628 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000CA5EAC970CFBA12F64 >									
186 	//     < FGRE_Portfolio_I_metadata_line_14_____REGIE_DSM_DISTRIBUTION_DES_SACS_MULTI_FLUX_OBS_DAO_20580515 >									
187 	//        < bg6C5eTONElqCGOWZ6Fj66tAnMhl10FiYhlJS6BD6U2wADwvMNXq8VrUc80WM346 >									
188 	//        < 1E-018 limites [ 557612521960,628 ; 567334755277,977 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000CFBA12F64D359422C8 >									
190 	//     < FGRE_Portfolio_I_metadata_line_15_____SEM_SYDEME_DEVELOPPEMENT_OBS_DAM_20580515 >									
191 	//        < 267E5tRWxASCKcDOslbWk74Q7lHdqQ9LcQH23j0xwq8XfNKU3rl69l8Xly0yU104 >									
192 	//        < 1E-018 limites [ 567334755277,977 ; 754508957813,064 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000D359422C81191394DA5 >									
194 	//     < FGRE_Portfolio_I_metadata_line_16_____METHAVOS_SAS_OBS_DAC_20580515 >									
195 	//        < j7HCt0sEKK5N0wr1uc3T3M43E8Fx9oqaiQZ8HCDY4h5Cj0PX0EOd9E13scqT8EL3 >									
196 	//        < 1E-018 limites [ 754508957813,064 ; 756731561518,271 ] >									
197 	//        < 0x000000000000000000000000000000000000000000001191394DA5119E78BA38 >									
198 	//     < FGRE_Portfolio_I_metadata_line_17_____SPIRAL_TRANS_SAS_OBS_DAC_20580515 >									
199 	//        < uBU1p3C5b826j9H2pGi8XmmMFZUPjpHV9vA33H07Hm7LyRh6Wes8Tl9eto6T06c3 >									
200 	//        < 1E-018 limites [ 756731561518,271 ; 757935845830,361 ] >									
201 	//        < 0x00000000000000000000000000000000000000000000119E78BA3811A5A651C7 >									
202 	//     < FGRE_Portfolio_I_metadata_line_18_____GROUPE_LINGENHELD_SA_OBS_DAC_20580515 >									
203 	//        < A3nAM1av1Wgnx569k0au9kdPVLjP5Aaa8BxCh2776L1aS2neSG47q3n77Gk5nCSq >									
204 	//        < 1E-018 limites [ 757935845830,361 ; 758196128380,951 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000011A5A651C711A7337AA6 >									
206 	//     < FGRE_Portfolio_I_metadata_line_19_____SAGILOR_SARL_20580515 >									
207 	//        < 71slAjTF2942Vh35iZ9Jxo9MXJ94aYHK9E4hPi3RJIxfDHJeL2pTh6694PKzzaeP >									
208 	//        < 1E-018 limites [ 758196128380,951 ; 758338985697,514 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000011A7337AA611A80D764A >									
210 	//     < FGRE_Portfolio_I_metadata_line_20_____SAGILOR_SARL_OBS_DAC_20580515 >									
211 	//        < qvP5169oWl81FGIg7u1HGCORI0Z87zlU4mSvVAKvhE15Q7720BkFh7g46kLAyv42 >									
212 	//        < 1E-018 limites [ 758338985697,514 ; 758645306252,734 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000011A80D764A11A9E0DEC1 >									
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
256 	//     < FGRE_Portfolio_I_metadata_line_21_____CCR_FGRE_IDX_SYDEME_20580515 >									
257 	//        < A5sC9ZEFtA2yA8X0vfi3b6165rpOnG7vKYIy83LOGRjLCv26279bNej0kbTPFPDp >									
258 	//        < 1E-018 limites [ 758645306252,734 ; 825398527634,891 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000011A9E0DEC11337C233DB >									
260 	//     < FGRE_Portfolio_I_metadata_line_22_____CCR_FGRE_IDX_REGIE_ECOTRI_MOSELLE_EST_20580515 >									
261 	//        < B8Bj5D75Fk7u0j2cb88IWAbCG6Lf8GUzP4v0vqD52ja34Igf748ePEtLDj2350l5 >									
262 	//        < 1E-018 limites [ 825398527634,891 ; 987183990485,361 ] >									
263 	//        < 0x000000000000000000000000000000000000000000001337C233DB16FC133A49 >									
264 	//     < FGRE_Portfolio_I_metadata_line_23_____CCR_FGRE_IDX_REGIE_CSM_CONFECTION_DES_SACS_MULTI_FLUX_20580515 >									
265 	//        < 9bz3xtA0z6rY2D9NpnldS4RsZ9Lv64g8UV3h45N6PQ7V0g55l9443O49z9e5IWmX >									
266 	//        < 1E-018 limites [ 987183990485,361 ; 987323943581,669 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000016FC133A4916FCE8C776 >									
268 	//     < FGRE_Portfolio_I_metadata_line_24_____CCR_FGRE_IDX_REGIE_DSM_DISTRIBUTION_DES_SACS_MULTI_FLUX_20580515 >									
269 	//        < 74sM8JazkSLqowDd8sEknEj510pnZNNnVIpgJ6XK39k5e4rHBc9Opj5uPKElpSaN >									
270 	//        < 1E-018 limites [ 987323943581,669 ; 987556222640,921 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000016FCE8C77616FE4B3578 >									
272 	//     < FGRE_Portfolio_I_metadata_line_25_____CCR_FGRE_IDX_SEM_SYDEME_DEVELOPPEMENT_20580515 >									
273 	//        < 0O78pcYigL75snN3u016Pl48sX55gqaTQg5HNO36W1zlJxB2X1Flsbn0zOvgcT1g >									
274 	//        < 1E-018 limites [ 987556222640,921 ; 989401898343,835 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000016FE4B357817094B7C8A >									
276 	//     < FGRE_Portfolio_I_metadata_line_26_____CCR_FGRE_IDX_METHAVOS_SAS_20580515 >									
277 	//        < lo6gVeyQZ5dgodhOa9wF8Xve9to4LJ1JrQ2KF1XX7sPBV8Myio176sL97DN0hP1M >									
278 	//        < 1E-018 limites [ 989401898343,835 ; 989624923072,177 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000017094B7C8A170A9FCB93 >									
280 	//     < FGRE_Portfolio_I_metadata_line_27_____CCR_FGRE_IDX_SPIRAL_TRANS_SAS_20580515 >									
281 	//        < i00oRb2v67686W4Oxrtobl39RtpERLm78HJ4aokF46idHvPpY8O548vhBcKWzG43 >									
282 	//        < 1E-018 limites [ 989624923072,177 ; 990548711561,624 ] >									
283 	//        < 0x00000000000000000000000000000000000000000000170A9FCB931710216274 >									
284 	//     < FGRE_Portfolio_I_metadata_line_28_____CCR_FGRE_IDX_GROUPE_LINGENHELD_SA_20580515 >									
285 	//        < 3Vu28fIPS64W1lVs02q8PYKowcZ5AUA07RN6rWhgmBBrnE78h4xnC27HPvIx579Y >									
286 	//        < 1E-018 limites [ 990548711561,624 ; 990670347370,608 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000017102162741710DAFC71 >									
288 	//     < FGRE_Portfolio_I_metadata_line_29_____CCR_FGRE_IDX_SAGILOR_SARL_20580515 >									
289 	//        < 1Z8CF5B65D7WP5D5reszn9o64tXC65DSq8HaL3xN09A8SF4daQuMWS4DpY49v1H4 >									
290 	//        < 1E-018 limites [ 990670347370,608 ; 993103443723,149 ] >									
291 	//        < 0x000000000000000000000000000000000000000000001710DAFC71171F5B98B4 >									
292 	//     < FGRE_Portfolio_I_metadata_line_30_____SOCIETE_DU_NOUVEAU_PORT_DE_METZ_20580515 >									
293 	//        < Trw0tlfPepnte2du5k22e0rm94BGLohz4rpg3a46kFgpusmAdel2w5DM3ba90xp7 >									
294 	//        < 1E-018 limites [ 993103443723,149 ; 1165500246040,28 ] >									
295 	//        < 0x00000000000000000000000000000000000000000000171F5B98B41B22EC3D9C >									
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
338 	//     < FGRE_Portfolio_I_metadata_line_31_____Fonds_de_garantie_des_risques_lies_a_l_epandage_des_boues_issues_de_l_industre_de_methanisation_20580515 >									
339 	//        < s1D0h1pdtqF7h3C85KJo4QYDMkVN0Ff7zv7HLHhTh3IzY0jcXzfXuvx26UyL93Vx >									
340 	//        < 1E-018 limites [ 1165500246040,28 ; 1290704803866,65 ] >									
341 	//        < 0x000000000000000000000000000000000000000000001B22EC3D9C1E0D333C03 >									
342 	//     < FGRE_Portfolio_I_metadata_line_32_____SHS_Sociéte_Holding_du_Syndicat_DMME_sociéte_de_gestion_du_fonds_de_garantie_des_risques_lies_a_la_epandage_des_boues_issues_de_l_industrie_de_methanisation_20580515 >									
343 	//        < S4dwaEQBX7J515883oyQ7L90qCcIn7vj125639gWR33mO72eIJ166Kqp0xWRQGXm >									
344 	//        < 1E-018 limites [ 1290704803866,65 ; 1295403858538,79 ] >									
345 	//        < 0x000000000000000000000000000000000000000000001E0D333C031E29356C3E >									
346 	//     < FGRE_Portfolio_I_metadata_line_33_____SFS_Sociéte_Financiere_du_Syndicat_DMME_societe_de_gestion_des_cotisations_et_provisions_pour_l'indemnisation_des_exploitants_agricoles_sylvicoles_et_forestiers_20580515 >									
347 	//        < N2fUc2Tn9184W8qE0OeT6SLLDT4Qk956rNxoO71SzL671Qxcehr6z47HrFwRHfg3 >									
348 	//        < 1E-018 limites [ 1295403858538,79 ; 1295551014450,21 ] >									
349 	//        < 0x000000000000000000000000000000000000000000001E29356C3E1E2A15F705 >									
350 	//     < FGRE_Portfolio_I_metadata_line_34_____GRDF_20580515 >									
351 	//        < 0TZhJCc9aZL638b40FdWi6Fa7x37m0M32xBwDy5TJW3y3dErlP8E923zgQ2jgxi7 >									
352 	//        < 1E-018 limites [ 1295551014450,21 ; 1297855872414,5 ] >									
353 	//        < 0x000000000000000000000000000000000000000000001E2A15F7051E37D2E629 >									
354 	//     < FGRE_Portfolio_I_metadata_line_35_____METHAVALOR_20580515 >									
355 	//        < 95Io3eoe8fjFCr0g4r6u9g6NK04uD16HmZDQy6P7pk7zLZ2YjB19A6LPNFzsW8JI >									
356 	//        < 1E-018 limites [ 1297855872414,5 ; 1457761232536,92 ] >									
357 	//        < 0x000000000000000000000000000000000000000000001E37D2E62921F0EF1D76 >									
358 	//     < FGRE_Portfolio_I_metadata_line_36_____LEGRAS_20580515 >									
359 	//        < 8y25S9831k844lYjQ009718yQR0L9knIOV32LzR972iEEHPwmHZlxmmJEC07424O >									
360 	//        < 1E-018 limites [ 1457761232536,92 ;  ] >									
361 	//        < 0x0000000000000000000000000000000000000000000021F0EF1D7623C829D434 >									
362 	//     < FGRE_Portfolio_I_metadata_line_37_____CCR_FGRE_IDX_GRDF_20580515 >									
363 	//        < 8op9iKEgfw97VA98QQ2lZ3mIBo52R4tL1G1026rast7kyZGCf1AT5U0g2N1I7AkO >									
364 	//        < 1E-018 limites [ 1536820398604,73 ; 1537020842150,07 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000023C829D43423C95BAE77 >									
366 	//     < FGRE_Portfolio_I_metadata_line_38_____CCR_FGRE_IDX_METHAVALOR_20580515 >									
367 	//        < U8jUWH0M46faUoLC4dk5IA3zYKXw4zOxzRtUBc32IuS3nCz3g5hGbk62ql28pD6r >									
368 	//        < 1E-018 limites [ 1537020842150,07 ; 1574094200080,45 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000023C95BAE7724A65522E8 >									
370 	//     < FGRE_Portfolio_I_metadata_line_39_____CCR_FGRE_IDX_LEGRAS_20580515 >									
371 	//        < FB5mewmtfXrafBx6vWbXU81f98wIP6n3vxzY7XJUOHhUXeO5b15Dt4V2f6P95cnM >									
372 	//        < 1E-018 limites [ 1574094200080,45 ; 1578417216092,89 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000024A65522E824C0198909 >									
374 	//     < FGRE_Portfolio_I_metadata_line_40_____SPIRAL_TRANS_AB_AB_20580515 >									
375 	//        < QN7lvataPm5A2698jqaB8eRZBfO1lp9CAL1peRlB68iDGz0qc96m44aIm9N5Rh1z >									
376 	//        < 1E-018 limites [ 1578417216092,89 ; 1579789427442,53 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000024C019890924C8475D18 >									
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