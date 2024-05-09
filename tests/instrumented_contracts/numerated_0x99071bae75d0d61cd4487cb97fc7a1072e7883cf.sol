1 pragma solidity 		^0.4.25	;						
2 										
3 	contract	CHEMCHINA_PFI_II_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	CHEMCHINA_PFI_II_883		"	;
8 		string	public		symbol =	"	CHEMCHINA_PFI_II_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		776042573866005000000000000					;	
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
92 	//     < CHEMCHINA_PFI_II_metadata_line_1_____001Chemical_20240321 >									
93 	//        < 77D4H96OKTYVU801VFFYy2j6Nb7a3rT5IG2Bi5MWRZDh081sy1CYp9GCP5Qz9IYJ >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000017787298.482249200000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000001B242A >									
96 	//     < CHEMCHINA_PFI_II_metadata_line_2_____3B_Scientific__Wuhan__Corporation_Limited_20240321 >									
97 	//        < QH8T4D89xia4X82Xr3K01bexK6LbsHMtZB5W28678fBF1t5t62ucqW2ASpf75pdz >									
98 	//        <  u =="0.000000000000000001" : ] 000000017787298.482249200000000000 ; 000000039588242.991193400000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000001B242A3C6828 >									
100 	//     < CHEMCHINA_PFI_II_metadata_line_3_____3Way_Pharm_inc__20240321 >									
101 	//        < 296fCDt906E5u6q5I94sWSy38EnCtz95A38on7J0H5oaH363n0y0jefhDgU637q9 >									
102 	//        <  u =="0.000000000000000001" : ] 000000039588242.991193400000000000 ; 000000062663702.508600400000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000003C68285F9E02 >									
104 	//     < CHEMCHINA_PFI_II_metadata_line_4_____Acemay_Biochemicals_20240321 >									
105 	//        < 154W6q89X5nq003IgHdpVQmEpeD430MAlIy7Xu48g55CynOK2HofxiuxyU74Mm7z >									
106 	//        <  u =="0.000000000000000001" : ] 000000062663702.508600400000000000 ; 000000087323683.331561800000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000005F9E02853ED0 >									
108 	//     < CHEMCHINA_PFI_II_metadata_line_5_____Aemon_Chemical_Technology_Co_Limited_20240321 >									
109 	//        < v8Uw5V3ggwjaCCzC4bpmwPeR5W45L4V11VxPuBOX287243P47mu95yv7T6Rmyazi >									
110 	//        <  u =="0.000000000000000001" : ] 000000087323683.331561800000000000 ; 000000106681321.576833000000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000853ED0A2C864 >									
112 	//     < CHEMCHINA_PFI_II_metadata_line_6_____AgileBioChem_Co_Limited_20240321 >									
113 	//        < zBqBKX16k0gj14PPPm0gzWn3H67Lz020oh7Y4992XfS1atZrN4WBTc77tBWs1l4T >									
114 	//        <  u =="0.000000000000000001" : ] 000000106681321.576833000000000000 ; 000000131371157.781113000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000A2C864C874DC >									
116 	//     < CHEMCHINA_PFI_II_metadata_line_7_____Aktin_Chemicals,_inc__20240321 >									
117 	//        < RVeB91FFhJ5d3HT0zJ0d3V96Z5Lw31b6hvsPx0p4uE26S95H80dAwZY9Rwr33ZpZ >									
118 	//        <  u =="0.000000000000000001" : ] 000000131371157.781113000000000000 ; 000000147274166.713922000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000C874DCE0B8F9 >									
120 	//     < CHEMCHINA_PFI_II_metadata_line_8_____Aktin_Chemicals,_org_20240321 >									
121 	//        < 04qXT35MSDAS7aL40QIX735N24V9ooAG8uoi5BLICD0iByRYFePZwCyiNCekBE2X >									
122 	//        <  u =="0.000000000000000001" : ] 000000147274166.713922000000000000 ; 000000164261289.772290000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000E0B8F9FAA491 >									
124 	//     < CHEMCHINA_PFI_II_metadata_line_9_____Angene_International_Limited_20240321 >									
125 	//        < qUO3f7rve8YEBvEOC79vNmReaLXd919ervKnO8Zc02Bk7QXD0KwAHH85X4aG2K97 >									
126 	//        <  u =="0.000000000000000001" : ] 000000164261289.772290000000000000 ; 000000188883952.408209000000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000000FAA49112036CB >									
128 	//     < CHEMCHINA_PFI_II_metadata_line_10_____ANSHAN_HIFI_CHEMICALS_Co__Limited_20240321 >									
129 	//        < rOm6KH4vbRp6i4En4aPesblV17ARal1c5wcLDc3c7KYkOff0RJdzg8Q001csEO34 >									
130 	//        <  u =="0.000000000000000001" : ] 000000188883952.408209000000000000 ; 000000203931865.293463000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000012036CB1372CE3 >									
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
174 	//     < CHEMCHINA_PFI_II_metadata_line_11_____Aromalake_Chemical_Corporation_Limited_20240321 >									
175 	//        < Aa1G7cR4M6gbbJ1TjXifb2fjPuEXC5y6C6Ip4MEPgA4qi0Y8NWAv6c0ulYd707R1 >									
176 	//        <  u =="0.000000000000000001" : ] 000000203931865.293463000000000000 ; 000000220931218.918753000000000000 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000000001372CE31511D42 >									
178 	//     < CHEMCHINA_PFI_II_metadata_line_12_____Aromsyn_Co_Limited_20240321 >									
179 	//        < 3ILle0BKSCdsb8yODzs62h9qETMWxh7b1F247owcY480Yoba9v0b6i10y6SzLJP7 >									
180 	//        <  u =="0.000000000000000001" : ] 000000220931218.918753000000000000 ; 000000241776358.803609000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000001511D42170EBE4 >									
182 	//     < CHEMCHINA_PFI_II_metadata_line_13_____Arromax_Pharmatech_Co__Limited_20240321 >									
183 	//        < DIUirhDV4Ntj4m4x19dd3LzL5GB9W0X1uWNttcJ6K3fdi1i01qsk1N351eWS897U >									
184 	//        <  u =="0.000000000000000001" : ] 000000241776358.803609000000000000 ; 000000260419073.291749000000000000 ] >									
185 	//        < 0x00000000000000000000000000000000000000000000000000170EBE418D5E33 >									
186 	//     < CHEMCHINA_PFI_II_metadata_line_14_____Asambly_Chemicals_Co_Limited_20240321 >									
187 	//        < 3izT1jvHAd4MgEHp25QF8M5Vq054UqHQL2NGFGj8xhaR111vW5xr5Q657XyX45xg >									
188 	//        <  u =="0.000000000000000001" : ] 000000260419073.291749000000000000 ; 000000275746866.383811000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000018D5E331A4C19F >									
190 	//     < CHEMCHINA_PFI_II_metadata_line_15_____Atomax_Chemicals_Co__Limited_20240321 >									
191 	//        < UUL769SjJ9yPmYwAa6zmIfEqA0C7bOQ59BHb958MK7Twdp5KCf363faoWNJTVw2G >									
192 	//        <  u =="0.000000000000000001" : ] 000000275746866.383811000000000000 ; 000000293101698.661451000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000001A4C19F1BF3CDA >									
194 	//     < CHEMCHINA_PFI_II_metadata_line_16_____Atomax_Chemicals_org_20240321 >									
195 	//        < Lm8tK4dtvB9t82TYDd035RpeuexxGkZPV2KuKSYbmpg0p9Ii9kjEyk9AVN129fc0 >									
196 	//        <  u =="0.000000000000000001" : ] 000000293101698.661451000000000000 ; 000000308476089.516944000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000001BF3CDA1D6B279 >									
198 	//     < CHEMCHINA_PFI_II_metadata_line_17_____Beijing_Pure_Chem__Co_Limited_20240321 >									
199 	//        < kz9Zi4F4s1CtE0T3sKd7350fwvyCSo47i69PKA16Yh6Ec4TbIBWLNsF750W7bne6 >									
200 	//        <  u =="0.000000000000000001" : ] 000000308476089.516944000000000000 ; 000000328366732.825269000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000001D6B2791F50C41 >									
202 	//     < CHEMCHINA_PFI_II_metadata_line_18_____BEIJING_SHLHT_CHEMICAL_TECHNOLOGY_20240321 >									
203 	//        < Tq7Dj5ymuP6nPHILvLgN3I9ccVa471cpG6OpuzLR422N5LS4z0k70t2LSS21kYb0 >									
204 	//        <  u =="0.000000000000000001" : ] 000000328366732.825269000000000000 ; 000000343996682.068568000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000001F50C4120CE5B4 >									
206 	//     < CHEMCHINA_PFI_II_metadata_line_19_____Beijing_Smart_Chemicals_Co_Limited_20240321 >									
207 	//        < 5F2Awa8L0Xoz34xXON1IiTsgZ0nN1qb2C9RkUhMK41YLR5Cyut1UjKKvfEh7Cnz1 >									
208 	//        <  u =="0.000000000000000001" : ] 000000343996682.068568000000000000 ; 000000361151699.341443000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000000020CE5B422712E2 >									
210 	//     < CHEMCHINA_PFI_II_metadata_line_20_____Beijing_Stable_Chemical_Co_Limited_20240321 >									
211 	//        < gzCvQ7l6R1S9ntG3lNJ0679N01yk4toli687E2igxYc5srkp949N5BGkBBXpvWS4 >									
212 	//        <  u =="0.000000000000000001" : ] 000000361151699.341443000000000000 ; 000000380727506.026307000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000022712E2244F1AF >									
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
256 	//     < CHEMCHINA_PFI_II_metadata_line_21_____Beijing_Sunpu_Biochem___Tech__Co__Limited_20240321 >									
257 	//        < 1iV4480kEd9SCfEF8U6um35I9We28ZZ0kn7L2c3GNn2lkxD929669eNnljw4wX6T >									
258 	//        <  u =="0.000000000000000001" : ] 000000380727506.026307000000000000 ; 000000396088163.573415000000000000 ] >									
259 	//        < 0x00000000000000000000000000000000000000000000000000244F1AF25C61F0 >									
260 	//     < CHEMCHINA_PFI_II_metadata_line_22_____Bellen_Chemistry_Co__Limited_20240321 >									
261 	//        < Y98L6Yk7s8ZDHo9ZnYeny5flLEDj9ll04on1BH1O8HoKO0YMF19Dpj1cBMJ33Yc3 >									
262 	//        <  u =="0.000000000000000001" : ] 000000396088163.573415000000000000 ; 000000411976343.595722000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000025C61F0274A042 >									
264 	//     < CHEMCHINA_PFI_II_metadata_line_23_____BEYO_CHEMICAL_Co__Limited_20240321 >									
265 	//        < 79y9A30C3xdCBnfjna51OG89p1RP2VDLcEcL1xO3RjhM5dv6AUpBPYTqImhGxCRx >									
266 	//        <  u =="0.000000000000000001" : ] 000000411976343.595722000000000000 ; 000000433031313.443965000000000000 ] >									
267 	//        < 0x00000000000000000000000000000000000000000000000000274A042294C0DB >									
268 	//     < CHEMCHINA_PFI_II_metadata_line_24_____Beyond_Pharmaceutical_Co_Limited_20240321 >									
269 	//        < tAjLWlEggegIupL5VlXu1zhp10AO8pOhHs4llJ0rT0bIb670Rmz357pe839KA1Fa >									
270 	//        <  u =="0.000000000000000001" : ] 000000433031313.443965000000000000 ; 000000454630857.476907000000000000 ] >									
271 	//        < 0x00000000000000000000000000000000000000000000000000294C0DB2B5B62E >									
272 	//     < CHEMCHINA_PFI_II_metadata_line_25_____Binhai_Gaolou_Chemical_Co_Limited_20240321 >									
273 	//        < 48T2wD0Vkev2c2wclZgU9TDE81053C31Uj6xK6ROwQS0f2Ty38MKa76E3BrFHs31 >									
274 	//        <  u =="0.000000000000000001" : ] 000000454630857.476907000000000000 ; 000000479172909.258922000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002B5B62E2DB28EB >									
276 	//     < CHEMCHINA_PFI_II_metadata_line_26_____Binhong_Industry_Co__Limited_20240321 >									
277 	//        < OnnzFI8qzXHhL04RNwueO4v4X5o19O3o0k8LRbdSrkVrixG6A6re1X67aSN8Ih3t >									
278 	//        <  u =="0.000000000000000001" : ] 000000479172909.258922000000000000 ; 000000501197717.034730000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000002DB28EB2FCC45C >									
280 	//     < CHEMCHINA_PFI_II_metadata_line_27_____BLD_Pharmatech_org_20240321 >									
281 	//        < E4VTpNSKNC5jOXoJ4CT5p6na3jb4722QE7gmEz52IO321GOMwaBeK0Dl0iaUWC2E >									
282 	//        <  u =="0.000000000000000001" : ] 000000501197717.034730000000000000 ; 000000519035646.159058000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000002FCC45C317FC4D >									
284 	//     < CHEMCHINA_PFI_II_metadata_line_28_____BLD_Pharmatech_Limited_20240321 >									
285 	//        < pdwWY8Z4m7b3Z5qTvkYJcP1z2QG0y4k7YBd5b60uDjKJl867xHmgTyIGUadeuSs2 >									
286 	//        <  u =="0.000000000000000001" : ] 000000519035646.159058000000000000 ; 000000538863012.281188000000000000 ] >									
287 	//        < 0x00000000000000000000000000000000000000000000000000317FC4D3363D5D >									
288 	//     < CHEMCHINA_PFI_II_metadata_line_29_____Bocchem_20240321 >									
289 	//        < b47VIQos0qBljdZz6sZ10oty2tJeQo466kW35Z6w4dGic4HG5AOc08V3J5bDtB0c >									
290 	//        <  u =="0.000000000000000001" : ] 000000538863012.281188000000000000 ; 000000554804938.977869000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000003363D5D34E90AE >									
292 	//     < CHEMCHINA_PFI_II_metadata_line_30_____Boroncore_LLC_20240321 >									
293 	//        < J4EX7kLK964s5758wr6MTE03175409sSKCO0a0UlVL4KuKPcV5P4d21oGWDByk4D >									
294 	//        <  u =="0.000000000000000001" : ] 000000554804938.977869000000000000 ; 000000572119886.416164000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000034E90AE368FC55 >									
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
338 	//     < CHEMCHINA_PFI_II_metadata_line_31_____BTC_Pharmaceuticals_Co_Limited_20240321 >									
339 	//        < F5E9fNCjq0jy65ITgYG29eIgqbRXwAk0f5pC7P974ECH800f9DH7v6uaY1Wi0pNK >									
340 	//        <  u =="0.000000000000000001" : ] 000000572119886.416164000000000000 ; 000000591577235.609597000000000000 ] >									
341 	//        < 0x00000000000000000000000000000000000000000000000000368FC55386ACDC >									
342 	//     < CHEMCHINA_PFI_II_metadata_line_32_____Cangzhou_Goldlion_Chemicals_Co_Limited_20240321 >									
343 	//        < EKH2VERJ6N5GOq9MBlF3P4Rtl9RnVz217SL74Is92Od4t29hYxl0105w2yj1b8Ap >									
344 	//        <  u =="0.000000000000000001" : ] 000000591577235.609597000000000000 ; 000000609490609.411813000000000000 ] >									
345 	//        < 0x00000000000000000000000000000000000000000000000000386ACDC3A20245 >									
346 	//     < CHEMCHINA_PFI_II_metadata_line_33_____Capot_Chemical_Co_Limited_20240321 >									
347 	//        < 8DqDCKpFXO21Sg3HG8x6A9310Oq24nYpZ17unnhn80D90wEv38aEb0Jm9M7q12w3 >									
348 	//        <  u =="0.000000000000000001" : ] 000000609490609.411813000000000000 ; 000000633817221.619603000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000003A202453C720DA >									
350 	//     < CHEMCHINA_PFI_II_metadata_line_34_____CBS_TECHNOLOGY_LTD_20240321 >									
351 	//        < 9U5Bj5Z53lw5TH09Co2WrUMPCgC9P437UG8VF1x2dpkWm323Q4iyNqBCIjs59440 >									
352 	//        <  u =="0.000000000000000001" : ] 000000633817221.619603000000000000 ; 000000655828586.298937000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000003C720DA3E8B70B >									
354 	//     < CHEMCHINA_PFI_II_metadata_line_35_____Changzhou_Carbochem_Co_Limited_20240321 >									
355 	//        < 0fs7p8xc0iPIW5x135s1NlKy4SAQ7Px4qS61K6Vo1AQODFG58hj77t0D3J9fCfZx >									
356 	//        <  u =="0.000000000000000001" : ] 000000655828586.298937000000000000 ; 000000672683939.685669000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000003E8B70B4026F2A >									
358 	//     < CHEMCHINA_PFI_II_metadata_line_36_____Changzhou_Hengda_Biotechnology_Co__org_20240321 >									
359 	//        < pc1r95enM8kA6w4Y3WFj71EyTz1caWz60v1y47Jh85zBMgyBJh0M4j336ZJFNk8D >									
360 	//        <  u =="0.000000000000000001" : ] 000000672683939.685669000000000000 ; 000000696226259.012877000000000000 ] >									
361 	//        < 0x000000000000000000000000000000000000000000000000004026F2A4265B62 >									
362 	//     < CHEMCHINA_PFI_II_metadata_line_37_____Changzhou_Hengda_Biotechnology_Co__Limited_20240321 >									
363 	//        < 7qPJbeplbzSLO29ocwbP0OTAFhJ9r0NR1gNnJ24caKZJ0mC8g9jN9k0lC0492b31 >									
364 	//        <  u =="0.000000000000000001" : ] 000000696226259.012877000000000000 ; 000000718747177.130707000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000004265B62448B89E >									
366 	//     < CHEMCHINA_PFI_II_metadata_line_38_____Changzhou_LanXu_Chemical_Co_Limited_20240321 >									
367 	//        < jwTiGeUQTd9T9Lnvqfqvn3OrfIPQ1zcZfIqR539sBYh8rc388Cy7M75g5JC5fj2m >									
368 	//        <  u =="0.000000000000000001" : ] 000000718747177.130707000000000000 ; 000000737285968.994078000000000000 ] >									
369 	//        < 0x00000000000000000000000000000000000000000000000000448B89E4650255 >									
370 	//     < CHEMCHINA_PFI_II_metadata_line_39_____Changzhou_Standard_Chemicals_Co_Limited_20240321 >									
371 	//        < uIZ0Rh0C7UGZvP14JPQU8kHF059Hrs6oQ276zLzBiMr2y72PC3L74m0yI8altDcL >									
372 	//        <  u =="0.000000000000000001" : ] 000000737285968.994078000000000000 ; 000000757840354.032104000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000046502554845F63 >									
374 	//     < CHEMCHINA_PFI_II_metadata_line_40_____CHANGZHOU_WEIJIA_CHEMICAL_Co_Limited_20240321 >									
375 	//        < Uj0rj3pJWh6PnfgPSzzCNp05Y16f4HnMs64Bx3nmZeQ90m7EXR8ILH3Gt05TT8Rp >									
376 	//        <  u =="0.000000000000000001" : ] 000000757840354.032104000000000000 ; 000000776042573.866005000000000000 ] >									
377 	//        < 0x000000000000000000000000000000000000000000000000004845F634A025A1 >									
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