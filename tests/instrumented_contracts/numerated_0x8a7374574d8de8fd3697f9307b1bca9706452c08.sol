1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFV_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFV_I_883		"	;
8 		string	public		symbol =	"	RUSS_PFV_I_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		601150973675601000000000000					;	
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
92 	//     < RUSS_PFV_I_metadata_line_1_____SIRIUS_ORG_20211101 >									
93 	//        < yLgOg3Ypa1TxcG477fOJwe52sK9ZoO3kQR588CBzYY9KXl4pu0S63RpNCURmv2Sy >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000013784239.282422200000000000 ] >									
95 	//        < 0x0000000000000000000000000000000000000000000000000000000000150878 >									
96 	//     < RUSS_PFV_I_metadata_line_2_____SIRIUS_DAO_20211101 >									
97 	//        < 9QhZvCLxyrP1GT66t9uB27v33OT3vS0b779EM9IA5TJTJZe269b3w9acYHvKv7Tu >									
98 	//        <  u =="0.000000000000000001" : ] 000000013784239.282422200000000000 ; 000000027708949.906841700000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000001508782A47CF >									
100 	//     < RUSS_PFV_I_metadata_line_3_____SIRIUS_DAOPI_20211101 >									
101 	//        < 4m1u8nPy6iNYtayavVOvs9k4Qs67D2jXJSoFVNlw1nFC77U6KwYLKOHFP0FOCs59 >									
102 	//        <  u =="0.000000000000000001" : ] 000000027708949.906841700000000000 ; 000000040913001.775763100000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000002A47CF3E6DA4 >									
104 	//     < RUSS_PFV_I_metadata_line_4_____SIRIUS_BIMI_20211101 >									
105 	//        < s18s4R5YJof6uOtEW7apx9wS7MTmbqNO5lL8H60Z70lc2FQH1FDL9L01uSm2n0tA >									
106 	//        <  u =="0.000000000000000001" : ] 000000040913001.775763100000000000 ; 000000057709914.222625500000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000003E6DA4580EEF >									
108 	//     < RUSS_PFV_I_metadata_line_5_____EDUCATIONAL_CENTER_SIRIUS_ORG_20211101 >									
109 	//        < r22A4O2v7qsfa4as32J88DgmI3hr12u56R3993s6F5pL6LvwVxcSe6l5475YMIT4 >									
110 	//        <  u =="0.000000000000000001" : ] 000000057709914.222625500000000000 ; 000000071791726.952027700000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000580EEF6D8BA5 >									
112 	//     < RUSS_PFV_I_metadata_line_6_____EDUCATIONAL_CENTER_SIRIUS_DAO_20211101 >									
113 	//        < 805ovx85K20Q9udu4K53D6OAI0lOeZZ1Vq0g2RhDwnd9Olv3JlZgBT9nZ16lN4K7 >									
114 	//        <  u =="0.000000000000000001" : ] 000000071791726.952027700000000000 ; 000000087764558.844433200000000000 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000000000006D8BA585EB08 >									
116 	//     < RUSS_PFV_I_metadata_line_7_____EDUCATIONAL_CENTER_SIRIUS_DAOPI_20211101 >									
117 	//        < x0S0j467xT709nJDrUSHQD8pVwOoXAEq0e6nAj1EM95Rl46JOqUPq7cJ42PuC04X >									
118 	//        <  u =="0.000000000000000001" : ] 000000087764558.844433200000000000 ; 000000102999260.328998000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000000085EB089D2A16 >									
120 	//     < RUSS_PFV_I_metadata_line_8_____EDUCATIONAL_CENTER_SIRIUS_DAC_20211101 >									
121 	//        < Xxy05bGu37hhIDb46W345PHsticmwod613MRlnWTwQRt56zQ6OZnHUti60d9s2k3 >									
122 	//        <  u =="0.000000000000000001" : ] 000000102999260.328998000000000000 ; 000000118509147.604150000000000000 ] >									
123 	//        < 0x00000000000000000000000000000000000000000000000000009D2A16B4D4A3 >									
124 	//     < RUSS_PFV_I_metadata_line_9_____SOCHI_PARK_HOTEL_20211101 >									
125 	//        < uv95I4lbMbU6jQ2nWOJXDRRMnK4FrmW3wbd865F83p45WIwP2hWnXj529V1Kw1KK >									
126 	//        <  u =="0.000000000000000001" : ] 000000118509147.604150000000000000 ; 000000133084225.174826000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000000B4D4A3CB1207 >									
128 	//     < RUSS_PFV_I_metadata_line_10_____GOSTINICHNYY_KOMPLEKS_BOGATYR_20211101 >									
129 	//        < LdoZqyq0CJ6N64PawjSs8H0mnqcx56f1f995w2oek79rFVnAy25YIijDd22EpuDy >									
130 	//        <  u =="0.000000000000000001" : ] 000000133084225.174826000000000000 ; 000000147741322.245952000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000000CB1207E16F74 >									
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
174 	//     < RUSS_PFV_I_metadata_line_11_____SIRIUS_IKAISA_BIMI_I_20211101 >									
175 	//        < tax5oz5SXR4OIX18z21l5Hxu5Eu5j4001qzVtI84L7236QVwTlGNVA6CJ1012ApG >									
176 	//        <  u =="0.000000000000000001" : ] 000000147741322.245952000000000000 ; 000000162694984.392885000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000000E16F74F840BA >									
178 	//     < RUSS_PFV_I_metadata_line_12_____SIRIUS_IKAISA_BIMI_II_20211101 >									
179 	//        < OAa3WJa56o0YxQE847Sf1LeabP05E5VBx9c60wmADGG4MN5CV6Ei8MJc2yUC23D3 >									
180 	//        <  u =="0.000000000000000001" : ] 000000162694984.392885000000000000 ; 000000176281883.873433000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000000F840BA10CFC1C >									
182 	//     < RUSS_PFV_I_metadata_line_13_____SIRIUS_IKAISA_BIMI_III_20211101 >									
183 	//        < llIZKwwsZc69G6Op5LDrjNy577UdMb8NBatzYItx049gcl15eFV2lZD372746Nv4 >									
184 	//        <  u =="0.000000000000000001" : ] 000000176281883.873433000000000000 ; 000000192497216.853430000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000010CFC1C125BA3A >									
186 	//     < RUSS_PFV_I_metadata_line_14_____SIRIUS_IKAISA_BIMI_IV_20211101 >									
187 	//        < b2TQnjVvqA0rOgf30z5PhiVWl74HcjqtCjdVR175vUR53Qo162ogX6eiI9PTApk3 >									
188 	//        <  u =="0.000000000000000001" : ] 000000192497216.853430000000000000 ; 000000209281376.212930000000000000 ] >									
189 	//        < 0x00000000000000000000000000000000000000000000000000125BA3A13F568A >									
190 	//     < RUSS_PFV_I_metadata_line_15_____SIRIUS_IKAISA_BIMI_V_20211101 >									
191 	//        < X2zPPZ09U4L8uLJ2M5MOMpemdO27cQOv5EHHmb71Z505wlOaeG7ib4A20CURlay0 >									
192 	//        <  u =="0.000000000000000001" : ] 000000209281376.212930000000000000 ; 000000224315463.414662000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000013F568A156473A >									
194 	//     < RUSS_PFV_I_metadata_line_16_____SIRIUS_IKAISA_BIMI_VI_20211101 >									
195 	//        < R2abx1dfGoAm6I226Sk9TsG1pzjUgz242aiP4opnze6NUCd8erQ81pNFPVXQIQpX >									
196 	//        <  u =="0.000000000000000001" : ] 000000224315463.414662000000000000 ; 000000238131932.311190000000000000 ] >									
197 	//        < 0x00000000000000000000000000000000000000000000000000156473A16B5C49 >									
198 	//     < RUSS_PFV_I_metadata_line_17_____SIRIUS_IKAISA_BIMI_VII_20211101 >									
199 	//        < uvl7cX87Og4603wLFh93CLFDo4z3rCK51Q4XYY7jeW8K443DQGwmx6Y19E8545lZ >									
200 	//        <  u =="0.000000000000000001" : ] 000000238131932.311190000000000000 ; 000000253785003.140310000000000000 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000000016B5C491833EC4 >									
202 	//     < RUSS_PFV_I_metadata_line_18_____SIRIUS_IKAISA_BIMI_VIII_20211101 >									
203 	//        < nptGspw26KWyd736LeKeFSao1D33NWf1JqcE640NIX8cKlB6MJTO3b5Xgzla4ik4 >									
204 	//        <  u =="0.000000000000000001" : ] 000000253785003.140310000000000000 ; 000000267049857.874407000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000001833EC41977C5A >									
206 	//     < RUSS_PFV_I_metadata_line_19_____SIRIUS_IKAISA_BIMI_IX_20211101 >									
207 	//        < PJ1l3qd6Af2NHICLon1vbEklCr1Y1NCR4t1p0JbA0XIa3T352kBHfq6QriN4E372 >									
208 	//        <  u =="0.000000000000000001" : ] 000000267049857.874407000000000000 ; 000000282428793.431384000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000001977C5A1AEF3BF >									
210 	//     < RUSS_PFV_I_metadata_line_20_____SIRIUS_IKAISA_BIMI_X_20211101 >									
211 	//        < c67cDN6mUNXZYO6o9Ok6Xb848ZK5m6B7Pu491qOL07sL4sBxTs8zjS6MAdzY31W0 >									
212 	//        <  u =="0.000000000000000001" : ] 000000282428793.431384000000000000 ; 000000298866747.193170000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000001AEF3BF1C808D3 >									
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
256 	//     < RUSS_PFV_I_metadata_line_21_____SOCHI_INFRA_FUND_I_20211101 >									
257 	//        < kt4hUu34luY7A76NXJg5OXttpme5KwqEMpGXQm3O4PGaezBAla4QheZbdABYO00Z >									
258 	//        <  u =="0.000000000000000001" : ] 000000298866747.193170000000000000 ; 000000315556221.333945000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000001C808D31E18026 >									
260 	//     < RUSS_PFV_I_metadata_line_22_____SOCHI_INFRA_FUND_II_20211101 >									
261 	//        < 2p5NAAiNa4v2fI72w27aZJOcw8B7ORpOOM6iZ3q8NKvKC5E5tM1UEwIIoz44yA3d >									
262 	//        <  u =="0.000000000000000001" : ] 000000315556221.333945000000000000 ; 000000331791215.171801000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000001E180261FA45F2 >									
264 	//     < RUSS_PFV_I_metadata_line_23_____SOCHI_INFRA_FUND_III_20211101 >									
265 	//        < 6w3lP3M2U92UoM49o8Z45V7O7f9InSp1hKwaNK36Pl9sl7VNx2WSt0yd2rf3YQVP >									
266 	//        <  u =="0.000000000000000001" : ] 000000331791215.171801000000000000 ; 000000348291133.885715000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000001FA45F22137339 >									
268 	//     < RUSS_PFV_I_metadata_line_24_____SOCHI_INFRA_FUND_IV_20211101 >									
269 	//        < uCxX7CTj60i3hSjQ0ZW273dzs4Ah0U57oU197rdF0Lft3Mcm9ZHsGW6A6CRAi8ek >									
270 	//        <  u =="0.000000000000000001" : ] 000000348291133.885715000000000000 ; 000000362179977.457557000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000002137339228A48E >									
272 	//     < RUSS_PFV_I_metadata_line_25_____SOCHI_INFRA_FUND_V_20211101 >									
273 	//        < bwomQ3ExLW6wlnOFG7RcpI663paQrgC4A69Fxk73AvV2EsZ6kH548syOCYQ3ZgKc >									
274 	//        <  u =="0.000000000000000001" : ] 000000362179977.457557000000000000 ; 000000378976315.088269000000000000 ] >									
275 	//        < 0x00000000000000000000000000000000000000000000000000228A48E24245A0 >									
276 	//     < RUSS_PFV_I_metadata_line_26_____LIPNITSK_ORG_20211101 >									
277 	//        < hwCdzps14el6ZhfB27Xk4xy0B4v1L728XS1yI7yPPWnba0xSK758I9N5qzn8IBjy >									
278 	//        <  u =="0.000000000000000001" : ] 000000378976315.088269000000000000 ; 000000393035188.915378000000000000 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000000000024245A0257B95F >									
280 	//     < RUSS_PFV_I_metadata_line_27_____LIPNITSK_DAO_20211101 >									
281 	//        < w3M861WfB9q692u68mo3nkJWC0iraLhaiv61vc4551rw0m5F2h4yMvvq9Tox526p >									
282 	//        <  u =="0.000000000000000001" : ] 000000393035188.915378000000000000 ; 000000406233349.702331000000000000 ] >									
283 	//        < 0x00000000000000000000000000000000000000000000000000257B95F26BDCE7 >									
284 	//     < RUSS_PFV_I_metadata_line_28_____LIPNITSK_DAC_20211101 >									
285 	//        < kp7ygVPj37Kc18rL5TcVxiG4Aj2PpQJ8E4UPZaW5z3lerC8C8SWr9CM90AYQh18z >									
286 	//        <  u =="0.000000000000000001" : ] 000000406233349.702331000000000000 ; 000000423056314.312295000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000026BDCE7285885F >									
288 	//     < RUSS_PFV_I_metadata_line_29_____LIPNITSK_ADIDAS_AB_20211101 >									
289 	//        < TL9RAf434aidtB020m3ff1qnPtTRUTi6Za6z9076vL6N83kG6BifBd6jGdl2pZhq >									
290 	//        <  u =="0.000000000000000001" : ] 000000423056314.312295000000000000 ; 000000439251423.093717000000000000 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000000000285885F29E3E96 >									
292 	//     < RUSS_PFV_I_metadata_line_30_____LIPNITSK_ALL_AB_M_ADIDAS_20211101 >									
293 	//        < 1Fl4YtELp8nP8v42mktb2xWrfOOZ9HlEiwP2q7qY7716F0Axdj5qd31mvRxczjqk >									
294 	//        <  u =="0.000000000000000001" : ] 000000439251423.093717000000000000 ; 000000454257978.291203000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000029E3E962B52486 >									
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
338 	//     < RUSS_PFV_I_metadata_line_31_____ANADYR_ORG_20211101 >									
339 	//        < LG24O3WIHDnv34EHUFczekXTGTWeZye2EOgD4j16r7Qw9M80Cm3MUcuQ5W7qix6B >									
340 	//        <  u =="0.000000000000000001" : ] 000000454257978.291203000000000000 ; 000000468458444.678600000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000002B524862CACF94 >									
342 	//     < RUSS_PFV_I_metadata_line_32_____ANADYR_DAO_20211101 >									
343 	//        < Bxfzk9lZf554pblkvn80jV67e3cSVV3V08RxQQ7y1CZaJ539f10vi268Z0CcRn3b >									
344 	//        <  u =="0.000000000000000001" : ] 000000468458444.678600000000000000 ; 000000483468185.623138000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000002CACF942E1B6C3 >									
346 	//     < RUSS_PFV_I_metadata_line_33_____ANADYR_DAOPI_20211101 >									
347 	//        < xcLM5GFHD4atT68E6W2s23CL2Eo39pe929oxIHR4ByHRDU14GbS4dxz594305E7O >									
348 	//        <  u =="0.000000000000000001" : ] 000000483468185.623138000000000000 ; 000000500017870.034778000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000002E1B6C32FAF77B >									
350 	//     < RUSS_PFV_I_metadata_line_34_____CHUKOTKA_ORG_20211101 >									
351 	//        < h4zvf6rC574050bLM75gp78OmWp86YdIzumOdB2cYbP8dcS0BIlNF983uoVS1aAY >									
352 	//        <  u =="0.000000000000000001" : ] 000000500017870.034778000000000000 ; 000000515154833.054137000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000002FAF77B312105B >									
354 	//     < RUSS_PFV_I_metadata_line_35_____CHUKOTKA_DAO_20211101 >									
355 	//        < wx4gXG8Ye2SNNN91Qp173tw8i7pJOm2qf186yDvU1xuw2MZh39CzPznN6Bf54mr9 >									
356 	//        <  u =="0.000000000000000001" : ] 000000515154833.054137000000000000 ; 000000529327045.202839000000000000 ] >									
357 	//        < 0x00000000000000000000000000000000000000000000000000312105B327B061 >									
358 	//     < RUSS_PFV_I_metadata_line_36_____CHUKOTKA_DAOPI_20211101 >									
359 	//        < 5QA4TArwX31Fy58RHs2VDH0v6gAWDX8EP2rcqw00mE5Rj8s0a8B91CH3L2X90g24 >									
360 	//        <  u =="0.000000000000000001" : ] 000000529327045.202839000000000000 ; 000000543464654.351163000000000000 ] >									
361 	//        < 0x00000000000000000000000000000000000000000000000000327B06133D42E1 >									
362 	//     < RUSS_PFV_I_metadata_line_37_____ANADYR_PORT_ORG_20211101 >									
363 	//        < lK4wu5GrDb4hmEoLM5iPji6KGZ00BG5C9N57ip7qy7Z4x5ybNZavM54qRF8Xlr01 >									
364 	//        <  u =="0.000000000000000001" : ] 000000543464654.351163000000000000 ; 000000556868281.280467000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000033D42E1351B6AC >									
366 	//     < RUSS_PFV_I_metadata_line_38_____INDUSTRIAL_PARK_ANADYR_ORG_20211101 >									
367 	//        < 517EGezx2a6HTQY2dR2lMAl0wd475a27Ou6WmKJe0lv0b62X9EJkBYRRmjx0tJ1a >									
368 	//        <  u =="0.000000000000000001" : ] 000000556868281.280467000000000000 ; 000000572977325.000526000000000000 ] >									
369 	//        < 0x00000000000000000000000000000000000000000000000000351B6AC36A4B45 >									
370 	//     < RUSS_PFV_I_metadata_line_39_____POLE_COLD_SERVICE_20211101 >									
371 	//        < 79dX8P5nXwumaiY85D5bf2Og0wpp2oP6WOC7J5PfM8r7WLH1fbtl74fR2gq6bZ6u >									
372 	//        <  u =="0.000000000000000001" : ] 000000572977325.000526000000000000 ; 000000587711028.499682000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000036A4B45380C69F >									
374 	//     < RUSS_PFV_I_metadata_line_40_____RED_OCTOBER_CO_20211101 >									
375 	//        < 8Yv94T1dkbEs1MKAB9w65ftMpAd98tTiG3w6540oQp05c02W0RtGb810H3VpWkDZ >									
376 	//        <  u =="0.000000000000000001" : ] 000000587711028.499682000000000000 ; 000000601150973.675601000000000000 ] >									
377 	//        < 0x00000000000000000000000000000000000000000000000000380C69F3954899 >									
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