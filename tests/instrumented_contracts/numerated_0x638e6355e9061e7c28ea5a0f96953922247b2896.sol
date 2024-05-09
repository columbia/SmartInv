1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RE_Portfolio_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RE_Portfolio_I_883		"	;
8 		string	public		symbol =	"	RE883I		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1591676265575320000000000000					;	
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
92 	//     < RE_Portfolio_I_metadata_line_1_____AA_Euler_Hermes_SA_AAm_20250515 >									
93 	//        < MGR3m39Pcxxd38Tw15eOSc39puzA1XdnMjO1JHMf02oDPoLqwPr22COs40XkOvAt >									
94 	//        < 1E-018 limites [ 1E-018 ; 23466777,8761341 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000008BDF780F >									
96 	//     < RE_Portfolio_I_metadata_line_2_____AA_Euler_Hermes_SA_AAm_20250515 >									
97 	//        < 14uzr4et42wJvn10409D50cNoG5ATiJYs1gG2UdU9Pk0rzU7se3540s6BZVu2h41 >									
98 	//        < 1E-018 limites [ 23466777,8761341 ; 37807926,3543451 ] >									
99 	//        < 0x0000000000000000000000000000000000000000000000008BDF780FE15A532F >									
100 	//     < RE_Portfolio_I_metadata_line_3_____Abu_Dhabi_National_Insurance_Co__PSC__Am_m_20250515 >									
101 	//        < 54ARHxYNL41UCnnZb6B3h2bVq2qJXGuHo3EtaO78elTemh7NFet0oNmsmiEUQ8FK >									
102 	//        < 1E-018 limites [ 37807926,3543451 ; 73081950,0897789 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000E15A532F1B39A36B4 >									
104 	//     < RE_Portfolio_I_metadata_line_7_____Ace_Group_of_Companies_20250515 >									
105 	//        < MGR3m39Pcxxd38Tw15eOSc39puzA1XdnMjO1JHMf02oDPoLqwPr22COs40XkOvAt >									
106 	//        < 1E-018 limites [ 73081950,0897789 ; 134176053,834668 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000001B39A36B431FC06AFB >									
108 	//     < RE_Portfolio_I_metadata_line_8_____Ace_Group_of_Companies_20250515 >									
109 	//        < I69v5ClJ4b14E3l6RfmXqI8035jUy46Qc7lNQhL7B80LQ8ZZ5phVPAxe4laZyyn0 >									
110 	//        < 1E-018 limites [ 277969870,344396 ; 294602007,09604 ] >									
111 	//        < 0x000000000000000000000000000000000000000000000031FC06AFB44E3A6C93 >									
112 	//     < RE_Portfolio_I_metadata_line_6_____ACE_European_Group_Limited_AA_App_20250515 >									
113 	//        < uirf25wA9t6VuCEU796GMdLF8wIQfnoe58yp6cWocsg4Ajphu3RK3wZFT6qnY6Xu >									
114 	//        < 1E-018 limites [ 294602007,09604 ; 328167666,886427 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000044E3A6C9361C5B96C1 >									
116 	//     < RE_Portfolio_I_metadata_line_10_____ACE_Tembest_Reinsurance_Limited__Chubb_Tembest_Reinsurance_Limited___m_App_20250515 >									
117 	//        < 89SsNu3CC9Qm4FTp1kDah1Aq0MU9WAADyG9ZuC0LsgMp3oD2Q8r6HVHs4Yzkd8Cy >									
118 	//        < 1E-018 limites [ 328167666,886427 ; 388131600,02045 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000061C5B96C1678D45E8E >									
120 	//     < RE_Portfolio_I_metadata_line_8_____Ace_Group_of_Companies_20250515 >									
121 	//        < 5yuBsTtVr0Z2CDm4BcxDFZjk4BOT71d5dqd37aFqodjtHwXa59Nk7GB84GYKBB3B >									
122 	//        < 1E-018 limites [ 277969870,344396 ; 294602007,09604 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000678D45E8E6DBF6FEF9 >									
124 	//     < RE_Portfolio_I_metadata_line_9_____ACE_Limited_20250515 >									
125 	//        < h42QuYHXTu84f30rMj56ozR6nz0dHs3MkU2L12v1jcN21XEYEPeg1q42YcP38H88 >									
126 	//        < 1E-018 limites [ 294602007,09604 ; 328167666,886427 ] >									
127 	//        < 0x00000000000000000000000000000000000000000000006DBF6FEF97A40820D4 >									
128 	//     < RE_Portfolio_I_metadata_line_10_____ACE_Tembest_Reinsurance_Limited__Chubb_Tembest_Reinsurance_Limited___m_App_20250515 >									
129 	//        < SACtV58n2y34TUl56K58ISbV82AS3hJO5CLtS2N0lGk9ep2v28YvGl4O3cltv91h >									
130 	//        < 1E-018 limites [ 328167666,886427 ; 388131600,02045 ] >									
131 	//        < 0x00000000000000000000000000000000000000000000007A40820D490971D436 >									
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
174 	//     < RE_Portfolio_I_metadata_line_11_____ACE_Tempest_Reinsurance_Limited_20250515 >									
175 	//        < 5VbH9L78M031ns1O5VbtzcQ8hrUI7q68arlr6O1m3y4eh0K5hghs0a3PW31jk74F >									
176 	//        < 1E-018 limites [ 388131600,02045 ; 415184250,130549 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000090971D4369AAB0E5A9 >									
178 	//     < RE_Portfolio_I_metadata_line_12_____ACE_Tempest_Reinsurance_Limited_20250515 >									
179 	//        < efrCS1gj7F73u81xfD3x49jzpV4pd7AmARTQ7j222sWEO5tq6QH0vPaqAErZT4R1 >									
180 	//        < 1E-018 limites [ 415184250,130549 ; 451109181,358069 ] >									
181 	//        < 0x00000000000000000000000000000000000000000000009AAB0E5A9A80D1FDEB >									
182 	//     < RE_Portfolio_I_metadata_line_13_____Ace_Underwriting_Agencies_Limited_20250515 >									
183 	//        < QQ2HA8Vmr4fVf6W1ZR8cH8w95rM7FsVZq6844bB0RLhJr016n58zAJ84qx3Q30oa >									
184 	//        < 1E-018 limites [ 451109181,358069 ; 507141771,80459 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000A80D1FDEBBCECCF090 >									
186 	//     < RE_Portfolio_I_metadata_line_14_____ACR_Capital_20250515 >									
187 	//        < vfzNTP9749Iq8S01v0q140rptXqFa70NT563p8W838zbYyDiBzLzw83i49ZRZ7j1 >									
188 	//        < 1E-018 limites [ 507141771,80459 ; 574494906,22049 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000BCECCF090D6041AAB2 >									
190 	//     < RE_Portfolio_I_metadata_line_15_____ACR_Capital_Holdings_Pte_Limited_20250515 >									
191 	//        < JU10vasbp22K1TMryZwfd9810molwwdIt7GrdQjx1r7dQz4iGMbD369w8G3Ci1LI >									
192 	//        < 1E-018 limites [ 574494906,22049 ; 599550539,492484 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000D6041AAB2DF5998771 >									
194 	//     < RE_Portfolio_I_metadata_line_16_____ACR_ReTakaful_Berhad__ACR_ReTakaful__Bpp_20250515 >									
195 	//        < D6e0O4LsHeJGWTeNANkfM7Di30n4S6kCwD0boHWoqIoc9ur23Iqa7v8j2P7G472m >									
196 	//        < 1E-018 limites [ 599550539,492484 ; 626047205,336318 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000DF5998771E93883B89 >									
198 	//     < RE_Portfolio_I_metadata_line_17_____Advent_Underwriting_Limited_20250515 >									
199 	//        < ykd44EaA2mXrY45V868yDyE4z68ukFIj6cu2pYIfF0Z59tOa1zNyslM61y4D5qpg >									
200 	//        < 1E-018 limites [ 626047205,336318 ; 675225782,0429 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000E93883B89FB8A8C910 >									
202 	//     < RE_Portfolio_I_metadata_line_18_____Advent_Underwriting_Limited_20250515 >									
203 	//        < 6558YU905Wq4Ai14FyhWIdYdRf2DgnHAafQbML2xkRRp2MklQMkQku8UiC5lz804 >									
204 	//        < 1E-018 limites [ 675225782,0429 ; 756137595,825876 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000FB8A8C910119AEE6A52 >									
206 	//     < RE_Portfolio_I_metadata_line_19_____Aegis_Managing_Agency_Limited_20250515 >									
207 	//        < Yg1Nz8XWGKZ5A865VzDjR1rn0T46L00wx5CJ2J579rkIb8UK5mHY7rj8DWOpmbxo >									
208 	//        < 1E-018 limites [ 756137595,825876 ; 798741625,876159 ] >									
209 	//        < 0x00000000000000000000000000000000000000000000119AEE6A521298DF018F >									
210 	//     < RE_Portfolio_I_metadata_line_20_____AEGIS_Managing_Agency_Limited_20250515 >									
211 	//        < XA5RmDhQe1gg0tlXspwGq80o98Q6X5HkBVJ03FH1m8kBDx4sAT378Eyv05b8s6I7 >									
212 	//        < 1E-018 limites [ 798741625,876159 ; 868138618,229641 ] >									
213 	//        < 0x000000000000000000000000000000000000000000001298DF018F14368269B2 >									
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
256 	//     < RE_Portfolio_I_metadata_line_21_____AEGON_NV_20250515 >									
257 	//        < m26v9Tz0FsLszrDM10eJ68FKp0s61s3H0HJn3J3n5aEbu8HoLU6Xu7TgJZTbaFw8 >									
258 	//        < 1E-018 limites [ 868138618,229641 ; 882720794,826364 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000014368269B2148D6D0C6E >									
260 	//     < RE_Portfolio_I_metadata_line_22_____Aegon_NV_Am_20250515 >									
261 	//        < ElLDG106wbX8SH8pJvGpxOnMJxGlET4yu2NkKJKOgz2szohj20o2JVxe9cQlX8cA >									
262 	//        < 1E-018 limites [ 882720794,826364 ; 898758885,078411 ] >									
263 	//        < 0x00000000000000000000000000000000000000000000148D6D0C6E14ED053B6F >									
264 	//     < RE_Portfolio_I_metadata_line_23_____Africa_Re_20250515 >									
265 	//        < P6WH9g794sj698L00i7dFACuGrd0f0Vur67mtDd466pt35Cd7Es9BhATik6Ees75 >									
266 	//        < 1E-018 limites [ 898758885,078411 ; 946122877,964643 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000014ED053B6F160754F328 >									
268 	//     < RE_Portfolio_I_metadata_line_24_____African_Re_Am_A_20250515 >									
269 	//        < p7YRryw12T9tC0Z39N7nq559f3I5yNBo2rWc75c06bOy19vM7Bc67UO07s9OafJV >									
270 	//        < 1E-018 limites [ 946122877,964643 ; 965358372,633065 ] >									
271 	//        < 0x00000000000000000000000000000000000000000000160754F3281679FBFC43 >									
272 	//     < RE_Portfolio_I_metadata_line_25_____AIG_Europe_Limited_Ap_A_20250515 >									
273 	//        < uKX10f6Yo1w9sA8I8u83ufyC972m828A370ROe6iG22Tee5G5H5gkIwHJX84vk8T >									
274 	//        < 1E-018 limites [ 965358372,633065 ; 989910438,093553 ] >									
275 	//        < 0x000000000000000000000000000000000000000000001679FBFC43170C5376D5 >									
276 	//     < RE_Portfolio_I_metadata_line_26_____AIOI_Nissay_Dowa_Insurance_co_Limited_Ap_Ap_20250515 >									
277 	//        < av00w72qCa3REFpUA56Rv3pSuZnA9LBzIgz012vbKv08SpDXREi92KuX7l36OK9P >									
278 	//        < 1E-018 limites [ 989910438,093553 ; 1005036319,37359 ] >									
279 	//        < 0x00000000000000000000000000000000000000000000170C5376D517667BBA35 >									
280 	//     < RE_Portfolio_I_metadata_line_27_____Al_Ain_Ahlia_Co_m_m_A3_20250515 >									
281 	//        < 9H6UlMINa2H1soX0iBPX1s2M007cFciXmeKA4k422edw9PDUX91IGZhy25fbT7mb >									
282 	//        < 1E-018 limites [ 1005036319,37359 ; 1074144145,91984 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000017667BBA35190265E6F3 >									
284 	//     < RE_Portfolio_I_metadata_line_28_____Al_Buhaira_National_Insurance_Co__PSC__BBp_m_20250515 >									
285 	//        < 7KR2BZYnxCj3W4pMj9p03Xkgw7eH7WDX1mqVBeNBSBShhI16h5WjWjHTYs4uLk6E >									
286 	//        < 1E-018 limites [ 1074144145,91984 ; 1155256692,99988 ] >									
287 	//        < 0x00000000000000000000000000000000000000000000190265E6F31AE5DDD3A7 >									
288 	//     < RE_Portfolio_I_metadata_line_29_____Al_Dhafra_Ins_Co_20250515 >									
289 	//        < buBigs1y460UNH9V4K49q57e9686068EMdXNv6MEd2QB1qt59WOVm12jms0MJyXI >									
290 	//        < 1E-018 limites [ 1155256692,99988 ; 1183878672,65548 ] >									
291 	//        < 0x000000000000000000000000000000000000000000001AE5DDD3A71B90778075 >									
292 	//     < RE_Portfolio_I_metadata_line_30_____Al_Koot_Insurance_&_Reinsurance_Company_SAQ_Am_20250515 >									
293 	//        < 4BRouiCWCQ68P1KeR5ua8AT4ph3q8GwJqvfrH0F39XR6y8B1zYU4U9Ir80qG006x >									
294 	//        < 1E-018 limites [ 1183878672,65548 ; 1233858401,84714 ] >									
295 	//        < 0x000000000000000000000000000000000000000000001B907780751CBA5E842C >									
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
338 	//     < RE_Portfolio_I_metadata_line_31_____Alamance_Reinsurance_Marketplace_20250515 >									
339 	//        < Vn3Es8zT3ND7qxXzjb6upKBmuqW4JGiiLV6KvP9DxFJq15GpPmqBfJft6Rs60u8A >									
340 	//        < 1E-018 limites [ 1233858401,84714 ; 1264820467,11963 ] >									
341 	//        < 0x000000000000000000000000000000000000000000001CBA5E842C1D72EAE0EB >									
342 	//     < RE_Portfolio_I_metadata_line_32_____Alamance_Reinsurance_Marketplace_20250515 >									
343 	//        < e8GxjzejB6y9r32WQL9Iab17d6Kvj4I1wB51og5TXDxH0CLsEACDc3FM3uqf0YKH >									
344 	//        < 1E-018 limites [ 1264820467,11963 ; 1283756862,01428 ] >									
345 	//        < 0x000000000000000000000000000000000000000000001D72EAE0EB1DE3C9862D >									
346 	//     < RE_Portfolio_I_metadata_line_33_____Alfa_Strakhovanie_Plc_20250515 >									
347 	//        < 0WViis0N2O930PuZ3fpzQLdS7q009KOBuFdv9r88ixdb5WIN2qtyUkk910ympbCp >									
348 	//        < 1E-018 limites [ 1283756862,01428 ; 1349863972,00733 ] >									
349 	//        < 0x000000000000000000000000000000000000000000001DE3C9862D1F6DD0F804 >									
350 	//     < RE_Portfolio_I_metadata_line_34_____Algeria_BBBm_Compagnie_Centrale_De_Reassurance__CCR__Bp_20250515 >									
351 	//        < w3Q7dSK50A5rjkYs5Y3GN4i6cYkV23tMwhcGG9cYVt7cXs0RML8g72gv686253s5 >									
352 	//        < 1E-018 limites [ 1349863972,00733 ; 1423344515,98195 ] >									
353 	//        < 0x000000000000000000000000000000000000000000001F6DD0F8042123CB6182 >									
354 	//     < RE_Portfolio_I_metadata_line_35_____Algeria_BBBm_Compagnie_Centrale_De_Reassurance__CCR__Bp_20250515 >									
355 	//        < 1L09VSpqd5352A9I09tvNfc05DlKBaQ3Qb8ymoHrP52VU5s5447e1R1lRKg40PEl >									
356 	//        < 1E-018 limites [ 1423344515,98195 ; 1437217512,29135 ] >									
357 	//        < 0x000000000000000000000000000000000000000000002123CB618221767BE4B1 >									
358 	//     < RE_Portfolio_I_metadata_line_36_____Alliance_Insurance__PSC__Am_20250515 >									
359 	//        < sgH7pJ29ja0Nx2u457YV0ts6NB51vINil960fDYno6ynS0zrL17Ow51dS40h1L8l >									
360 	//        < 1E-018 limites [ 1437217512,29135 ;  ] >									
361 	//        < 0x0000000000000000000000000000000000000000000021767BE4B122D2D1D670 >									
362 	//     < RE_Portfolio_I_metadata_line_37_____Allianz_Global_Corporate_&_Specialty_SE_AA_Ap_20250515 >									
363 	//        < n56b380a50AH7M1YM4TlPYc632KL80uEP7zA295H8e1c9vpgJcTAmqoqYE4s7168 >									
364 	//        < 1E-018 limites [ 1495658548,44372 ; 1537055049,94057 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000022D2D1D67023C98FE2D6 >									
366 	//     < RE_Portfolio_I_metadata_line_38_____Allianz_Global_Risks_US_Insurance_Co_AA_20250515 >									
367 	//        < jjo6iUwbdK1qCqdn85DX6b99SYZ21UN6z0yvWII49iXv1LUvgClG1O4JE10HkCSg >									
368 	//        < 1E-018 limites [ 1537055049,94057 ; 1548694914,34345 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000023C98FE2D6240EF0E8DE >									
370 	//     < RE_Portfolio_I_metadata_line_39_____Allianz_Private_KrankenversicherungsmAG_AA_20250515 >									
371 	//        < 77Fbsr5HRr252IN58Wpy5V9AOXAimYkpYS6OX60jzp4bRVjB7rZPswdo8r64jrPt >									
372 	//        < 1E-018 limites [ 1548694914,34345 ; 1578492143,45902 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000240EF0E8DE24C08BDF7D >									
374 	//     < RE_Portfolio_I_metadata_line_40_____Allianz_Risk_Transfer_AG_AAm_20250515 >									
375 	//        < 8gw9ZNBr5JvL1m8vcB9Me21T8y6R4lrmzDes8wxmE7F9pxuWp49T2b2GyHoi9EM9 >									
376 	//        < 1E-018 limites [ 1578492143,45902 ; 1591676265,57532 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000024C08BDF7D250F213F31 >									
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