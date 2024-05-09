1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXXV_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXXV_I_883		"	;
8 		string	public		symbol =	"	RUSS_PFXXV_I_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		596441802286079000000000000					;	
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
92 	//     < RUSS_PFXXV_I_metadata_line_1_____GAZPROM_20211101 >									
93 	//        < 3f7B3cky9m8eExCpw6KPV8kEExeeX7UhQa542UKSXbQ98fz16ApvJm23kN620jsJ >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000015866682.586014000000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000001835EC >									
96 	//     < RUSS_PFXXV_I_metadata_line_2_____PROM_DAO_20211101 >									
97 	//        < w2iS8Co6V46xR6hk6M369BSr19npF0uhc7X998l7cH22Dy5jEeaTcKk1Groz83x9 >									
98 	//        <  u =="0.000000000000000001" : ] 000000015866682.586014000000000000 ; 000000030248296.129152100000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000001835EC2E27BE >									
100 	//     < RUSS_PFXXV_I_metadata_line_3_____PROM_DAOPI_20211101 >									
101 	//        < 2pO3ao29WcRe8T9g7Qgew92bRxfqJkw93Vdy6ihv5h7e6zPwDG5WURS9J1XVk9SD >									
102 	//        <  u =="0.000000000000000001" : ] 000000030248296.129152100000000000 ; 000000045560327.316280800000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000002E27BE458501 >									
104 	//     < RUSS_PFXXV_I_metadata_line_4_____PROM_DAC_20211101 >									
105 	//        < lJ2DuQgf1rTwt1D4FMWUFuZsw2ULlN80k2CxNSqWGqep7iyh2y0hhDSqn47kkBY5 >									
106 	//        <  u =="0.000000000000000001" : ] 000000045560327.316280800000000000 ; 000000059725682.690168400000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000004585015B2258 >									
108 	//     < RUSS_PFXXV_I_metadata_line_5_____PROM_BIMI_20211101 >									
109 	//        < w6XI8S8HO86cUN4TFBE804Z4tzqoK6lT6927F1iYRrJcIJBgtcqTG1dxXG839twa >									
110 	//        <  u =="0.000000000000000001" : ] 000000059725682.690168400000000000 ; 000000074195533.011233800000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000005B22587136A1 >									
112 	//     < RUSS_PFXXV_I_metadata_line_6_____GAZPROMNEFT_20211101 >									
113 	//        < 8Uk9G26Gx4A7HPKDROQHlP6q8B5ilvE3jsN40p165q5dV2d472aAm8TvlcnC4Z5z >									
114 	//        <  u =="0.000000000000000001" : ] 000000074195533.011233800000000000 ; 000000088527811.138290700000000000 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000000000007136A187152D >									
116 	//     < RUSS_PFXXV_I_metadata_line_7_____GAZPROMBANK_BD_20211101 >									
117 	//        < sXmaLOwpJ1745S1k55houl7VY51vwgH76GkJ9B8HBUcmtDz4hvsXIr5265cKE58P >									
118 	//        <  u =="0.000000000000000001" : ] 000000088527811.138290700000000000 ; 000000104660723.109786000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000000087152D9FB318 >									
120 	//     < RUSS_PFXXV_I_metadata_line_8_____MEZHEREGIONGAZ_20211101 >									
121 	//        < resX90X562nmneG93myW976eV1b35ZDa7u83542b07p1YGTv3pbw1V57D2ubDSNe >									
122 	//        <  u =="0.000000000000000001" : ] 000000104660723.109786000000000000 ; 000000118816683.247653000000000000 ] >									
123 	//        < 0x00000000000000000000000000000000000000000000000000009FB318B54CC4 >									
124 	//     < RUSS_PFXXV_I_metadata_line_9_____SALAVATNEFTEORGSINTEZ_20211101 >									
125 	//        < Fxdhp3cOTkCtYDk41kDj4Btlq658apOu9Fu61oU4UIOMEC9k7v2pcf8E0SGflcoI >									
126 	//        <  u =="0.000000000000000001" : ] 000000118816683.247653000000000000 ; 000000134359340.063529000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000000B54CC4CD041E >									
128 	//     < RUSS_PFXXV_I_metadata_line_10_____SAKHALIN_ENERGY_20211101 >									
129 	//        < numzUBR9Jsqz56hz7QbRbUHt6h4X03tC51Z7Z45TUZl6YxJAW75PDd6NfJ40H48S >									
130 	//        <  u =="0.000000000000000001" : ] 000000134359340.063529000000000000 ; 000000147654241.709127000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000000CD041EE14D70 >									
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
174 	//     < RUSS_PFXXV_I_metadata_line_11_____NORDSTREAM_AG_20211101 >									
175 	//        < 5QzKR7DXs0cs937pSdwz4i6lCWFZn0u1Xb1Co6in7Ycvy7FAkwy9aL8J00K2Ew5n >									
176 	//        <  u =="0.000000000000000001" : ] 000000147654241.709127000000000000 ; 000000160778473.378789000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000000E14D70F55417 >									
178 	//     < RUSS_PFXXV_I_metadata_line_12_____NORDSTREAM_DAO_20211101 >									
179 	//        < 5iD0n3B2A13jbPv1680TnNyWPeRtDzsp9Z44P628Ukkpm8z19Vm9NrnrCFGy30qt >									
180 	//        <  u =="0.000000000000000001" : ] 000000160778473.378789000000000000 ; 000000177731301.909452000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000000F5541710F324A >									
182 	//     < RUSS_PFXXV_I_metadata_line_13_____NORDSTREAM_DAOPI_20211101 >									
183 	//        < 4RrKWDOZ4W7IWGLS1ao15CoD84upls7GgwYwfg51SB7y007IpZxv125pvZ3nE5ZA >									
184 	//        <  u =="0.000000000000000001" : ] 000000177731301.909452000000000000 ; 000000190974195.753674000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000010F324A123674C >									
186 	//     < RUSS_PFXXV_I_metadata_line_14_____NORDSTREAM_DAC_20211101 >									
187 	//        < jzGgJsTd7T4Jq6ceDse3cqtK07e0m69vVFakG22iH8uoFto17uRWxrnP2W3o2U4i >									
188 	//        <  u =="0.000000000000000001" : ] 000000190974195.753674000000000000 ; 000000204609397.580780000000000000 ] >									
189 	//        < 0x00000000000000000000000000000000000000000000000000123674C138358C >									
190 	//     < RUSS_PFXXV_I_metadata_line_15_____NORDSTREAM_BIMI_20211101 >									
191 	//        < tjVJHWd324BM6NsRnV2MBUcg1wAuS04aP3f9hauSl3l3l4WRLIYa8i5MVk7JXu99 >									
192 	//        <  u =="0.000000000000000001" : ] 000000204609397.580780000000000000 ; 000000221078434.254257000000000000 ] >									
193 	//        < 0x00000000000000000000000000000000000000000000000000138358C15156C3 >									
194 	//     < RUSS_PFXXV_I_metadata_line_16_____GASCAP_ORG_20211101 >									
195 	//        < 379m0jbXgC01vu8597t4nvpHe54cl05XsSj34kzOLCgNQ7Z9FUdZv9smV4M2QDVO >									
196 	//        <  u =="0.000000000000000001" : ] 000000221078434.254257000000000000 ; 000000234532830.528585000000000000 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000000015156C3165DE63 >									
198 	//     < RUSS_PFXXV_I_metadata_line_17_____GASCAP_DAO_20211101 >									
199 	//        < YJ4z520HDLqOa2KDUCV21lGryYZ973IqeuEVrxX00O30ZWjZ35QWeT2wnQA15jEF >									
200 	//        <  u =="0.000000000000000001" : ] 000000234532830.528585000000000000 ; 000000248181143.917963000000000000 ] >									
201 	//        < 0x00000000000000000000000000000000000000000000000000165DE6317AB1C2 >									
202 	//     < RUSS_PFXXV_I_metadata_line_18_____GASCAP_DAOPI_20211101 >									
203 	//        < 997u2shm37V0DfCWL9HDB4Upmb6bhTvmKA3atx663y6TblbCG4A447QwYB80nl7E >									
204 	//        <  u =="0.000000000000000001" : ] 000000248181143.917963000000000000 ; 000000264386611.241142000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000017AB1C21936C05 >									
206 	//     < RUSS_PFXXV_I_metadata_line_19_____GASCAP_DAC_20211101 >									
207 	//        < 9Niy5Vq783k3Bt31cSfSZ6xRJom19vm3yNBbIyj3MiiXIO3M2YDwLYyoH2GvQ6dZ >									
208 	//        <  u =="0.000000000000000001" : ] 000000264386611.241142000000000000 ; 000000280656308.245198000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000001936C051AC3F5F >									
210 	//     < RUSS_PFXXV_I_metadata_line_20_____GASCAP_BIMI_20211101 >									
211 	//        < Z9o7qvxUv8Rcp6FpGab0LxaAQSOv1DMR6DR6QrFsDj6DNa7z042gLvVB84trQ2Fx >									
212 	//        <  u =="0.000000000000000001" : ] 000000280656308.245198000000000000 ; 000000296439994.705233000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000001AC3F5F1C454DF >									
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
256 	//     < RUSS_PFXXV_I_metadata_line_21_____GAZ_CAPITAL_SA_20211101 >									
257 	//        < MoYXwMt3G5mP9O66Q5Fa8pSKkvyfU5B3uMNRU8LDf5A7o7Ad47yj96i2183Wcr9V >									
258 	//        <  u =="0.000000000000000001" : ] 000000296439994.705233000000000000 ; 000000310901388.255898000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000001C454DF1DA65DB >									
260 	//     < RUSS_PFXXV_I_metadata_line_22_____BELTRANSGAZ_20211101 >									
261 	//        < R9M7cC3crBYSgyHB0eg94a762olCcq6HGCGYu0NY1Qf1P2yu7Q18wKu0wlCHNBUq >									
262 	//        <  u =="0.000000000000000001" : ] 000000310901388.255898000000000000 ; 000000324056512.361406000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000001DA65DB1EE7893 >									
264 	//     < RUSS_PFXXV_I_metadata_line_23_____OVERGAS_20211101 >									
265 	//        < 8hDbHWab6Cbl2PCC26L8zAJRBDdtArJcAz9fwDKcj8a1QVUN8LVsn9JcL1DxavU8 >									
266 	//        <  u =="0.000000000000000001" : ] 000000324056512.361406000000000000 ; 000000338077453.467057000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000001EE7893203DD81 >									
268 	//     < RUSS_PFXXV_I_metadata_line_24_____GAZPROM_MARKETING_TRADING_20211101 >									
269 	//        < z27BIFvaLB3fBw7uTSD44QEpM3SLmRiB2fNU8x33k8qqMR567ckO5q9k5Gj7SJFA >									
270 	//        <  u =="0.000000000000000001" : ] 000000338077453.467057000000000000 ; 000000351134144.538491000000000000 ] >									
271 	//        < 0x00000000000000000000000000000000000000000000000000203DD81217C9C6 >									
272 	//     < RUSS_PFXXV_I_metadata_line_25_____ROSUKRENERGO_20211101 >									
273 	//        < HmfNhZW3cR4S51U7o72iz09BAPR10mFzspmU89gAqS1ag1bx25y0VoN581DoPezQ >									
274 	//        <  u =="0.000000000000000001" : ] 000000351134144.538491000000000000 ; 000000365798833.893935000000000000 ] >									
275 	//        < 0x00000000000000000000000000000000000000000000000000217C9C622E2A2B >									
276 	//     < RUSS_PFXXV_I_metadata_line_26_____TRANSGAZ_VOLGORAD_20211101 >									
277 	//        < 6875oVCq5Z7HrIJVWR52D7lAq4Ly7985kUW7vmam4MYq4S51yPWFIXMBzOBdaBQ8 >									
278 	//        <  u =="0.000000000000000001" : ] 000000365798833.893935000000000000 ; 000000380046929.282338000000000000 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000000000022E2A2B243E7D5 >									
280 	//     < RUSS_PFXXV_I_metadata_line_27_____SPACE_SYSTEMS_20211101 >									
281 	//        < yYImal31X3HeJv7y2Fyk9jbxo3H4udS4A15DIM742M84i2O73f2BBg8Phk7w4mML >									
282 	//        <  u =="0.000000000000000001" : ] 000000380046929.282338000000000000 ; 000000396585482.568826000000000000 ] >									
283 	//        < 0x00000000000000000000000000000000000000000000000000243E7D525D2434 >									
284 	//     < RUSS_PFXXV_I_metadata_line_28_____MOLDOVAGAZ_20211101 >									
285 	//        < L43pQ964JTHx7ku57G11sCJ4Gz7ps2R0fgGUrZ7UuObf32fuUBEh6F9q91MP73cd >									
286 	//        <  u =="0.000000000000000001" : ] 000000396585482.568826000000000000 ; 000000411862810.071007000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000025D243427473E9 >									
288 	//     < RUSS_PFXXV_I_metadata_line_29_____VOSTOKGAZPROM_20211101 >									
289 	//        < c1GF6l3ffmM6I8os8I12cyTvxM623zhvm26S63Pw9Z9RVW08r7WjB56ELc9i4Hf4 >									
290 	//        <  u =="0.000000000000000001" : ] 000000411862810.071007000000000000 ; 000000429028604.629720000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000027473E928EA54C >									
292 	//     < RUSS_PFXXV_I_metadata_line_30_____GAZPROM_UK_20211101 >									
293 	//        < VVAm5eo2Q59uSODl8X01ay351021gRtwN3oOTnQ70H04Wc9203tbvwT2D98e7w26 >									
294 	//        <  u =="0.000000000000000001" : ] 000000429028604.629720000000000000 ; 000000445003646.144161000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000028EA54C2A7058D >									
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
338 	//     < RUSS_PFXXV_I_metadata_line_31_____SOUTHSTREAM_AG_20211101 >									
339 	//        < 0pR72o3f4z39RwS4q66qu8Yu5X0i1B14K8qwcy1oL75638HL8DZhv7DQR8U7L1mP >									
340 	//        <  u =="0.000000000000000001" : ] 000000445003646.144161000000000000 ; 000000459433497.989266000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000002A7058D2BD0A36 >									
342 	//     < RUSS_PFXXV_I_metadata_line_32_____SOUTHSTREAM_DAO_20211101 >									
343 	//        < mRUf159YkpHx9QUKgB9I9tEiz1aRzUnxROv7IVEj7ACbwz0B1TvrMgc4u0A1n5E2 >									
344 	//        <  u =="0.000000000000000001" : ] 000000459433497.989266000000000000 ; 000000474084457.718789000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000002BD0A362D3653E >									
346 	//     < RUSS_PFXXV_I_metadata_line_33_____SOUTHSTREAM_DAOPI_20211101 >									
347 	//        < 4XA3ttk57Dq4jT445wW6QKnc6WPmqPW9577r7u61K7Q51AIOIO2h248Zo2fnebpk >									
348 	//        <  u =="0.000000000000000001" : ] 000000474084457.718789000000000000 ; 000000490511003.489901000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000002D3653E2EC75DC >									
350 	//     < RUSS_PFXXV_I_metadata_line_34_____SOUTHSTREAM_DAC_20211101 >									
351 	//        < 6uhxd7v3N2Br34G7L1jkR98MK2W3S7WKwAr8TMCJTM93lxMUl1iwwR2sY1RNGj3y >									
352 	//        <  u =="0.000000000000000001" : ] 000000490511003.489901000000000000 ; 000000504674100.374332000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000002EC75DC3021252 >									
354 	//     < RUSS_PFXXV_I_metadata_line_35_____SOUTHSTREAM_BIMI_20211101 >									
355 	//        < qFlUf45B1frE6Hts8LmzAhK2zh1lpskd0a4ZQziIogiG56cN7C2u6wF40ZCWx616 >									
356 	//        <  u =="0.000000000000000001" : ] 000000504674100.374332000000000000 ; 000000519632633.076998000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000003021252318E57F >									
358 	//     < RUSS_PFXXV_I_metadata_line_36_____GAZPROM_ARMENIA_20211101 >									
359 	//        < 5f8869j47dJ93xD1Th6K1BL2RyMBYyYZun3WVFWi9nZf36p1u0U968n7it9SwSgm >									
360 	//        <  u =="0.000000000000000001" : ] 000000519632633.076998000000000000 ; 000000535829398.464982000000000000 ] >									
361 	//        < 0x00000000000000000000000000000000000000000000000000318E57F3319C5C >									
362 	//     < RUSS_PFXXV_I_metadata_line_37_____CHORNOMORNAFTOGAZ_20211101 >									
363 	//        < 947Xc8V5iO1SJN2tZ52N5b9q4L69jV32ClS1BKey3pr4wR7DO0e0AZ355LljOHM9 >									
364 	//        <  u =="0.000000000000000001" : ] 000000535829398.464982000000000000 ; 000000552551938.171334000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000003319C5C34B209A >									
366 	//     < RUSS_PFXXV_I_metadata_line_38_____SHTOKMAN_DEV_AG_20211101 >									
367 	//        < Y1p18363zjs5Cy5eX5nIF20uy8oxhgG3LtxlV82z6SV0LuAKzc74SuVRH19U9UH8 >									
368 	//        <  u =="0.000000000000000001" : ] 000000552551938.171334000000000000 ; 000000568829181.331705000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000034B209A363F6E6 >									
370 	//     < RUSS_PFXXV_I_metadata_line_39_____VEMEX_20211101 >									
371 	//        < RHKIx4be41ZIN633m2kW6g3bd1G5ym4pYb8M16JmnN5uLNlDxLcq2lQc31jmk5MB >									
372 	//        <  u =="0.000000000000000001" : ] 000000568829181.331705000000000000 ; 000000582056811.082134000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000363F6E637825F1 >									
374 	//     < RUSS_PFXXV_I_metadata_line_40_____BOSPHORUS_GAZ_20211101 >									
375 	//        < 9Oso6524T34h6qZ2Sa4Thd8djv3sqcX1QbIY8Cw85sXuet5hayX4X2p4VMm2p2By >									
376 	//        <  u =="0.000000000000000001" : ] 000000582056811.082134000000000000 ; 000000596441802.286079000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000037825F138E1914 >									
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