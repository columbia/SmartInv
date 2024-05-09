1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFIV_II_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFIV_II_883		"	;
8 		string	public		symbol =	"	RUSS_PFIV_II_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		730675751330868000000000000					;	
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
92 	//     < RUSS_PFIV_II_metadata_line_1_____NOVOLIPETSK_20231101 >									
93 	//        < FJk86Jh1bX15AG0582sBfk6309m46gkq1w32I9f343dM0uyP47pma0We6YY49g5C >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000015414940.043051200000000000 ] >									
95 	//        < 0x0000000000000000000000000000000000000000000000000000000000178576 >									
96 	//     < RUSS_PFIV_II_metadata_line_2_____FLETCHER_GROUP_HOLDINGS_LIMITED_20231101 >									
97 	//        < mZcKwz90z4hMAIDqXxgX1dvcbsu2NJ8C6OADnK2zv9QyXurI663B5W35WhSGItN2 >									
98 	//        <  u =="0.000000000000000001" : ] 000000015414940.043051200000000000 ; 000000035431556.973579000000000000 ] >									
99 	//        < 0x0000000000000000000000000000000000000000000000000000178576361074 >									
100 	//     < RUSS_PFIV_II_metadata_line_3_____UNIVERSAL_CARGO_LOGISTICS_HOLDINGS_BV_20231101 >									
101 	//        < ThwS829y2kOLspsPosWaBULgdr5NTjhDeSR6F62XPz6yE0Q9NzPdcQ30knN4rFDQ >									
102 	//        <  u =="0.000000000000000001" : ] 000000035431556.973579000000000000 ; 000000055153692.228725600000000000 ] >									
103 	//        < 0x0000000000000000000000000000000000000000000000000000361074542869 >									
104 	//     < RUSS_PFIV_II_metadata_line_4_____STOILENSKY_GOK_20231101 >									
105 	//        < BAD5sr3E38YDsPcx3iUnT87XLn9soch2p8kdIT9wL3b7238u9BTdxdf3eF28NH34 >									
106 	//        <  u =="0.000000000000000001" : ] 000000055153692.228725600000000000 ; 000000075974527.501017300000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000054286973ED8D >									
108 	//     < RUSS_PFIV_II_metadata_line_5_____ALTAI_KOKS_20231101 >									
109 	//        < 314pGof6IK4x4KBX6F35i6apM0PTSdJW8Pd49z6gMfrmzR7GynCTY8V23zjcXeri >									
110 	//        <  u =="0.000000000000000001" : ] 000000075974527.501017300000000000 ; 000000096154822.250900600000000000 ] >									
111 	//        < 0x000000000000000000000000000000000000000000000000000073ED8D92B87A >									
112 	//     < RUSS_PFIV_II_metadata_line_6_____VIZ_STAL_20231101 >									
113 	//        < W01WufMxgb6hJ46k64mRR4YJiuo793Iv5pBIUYoPE5Hd6h66rQNyMBf7yzEK10tM >									
114 	//        <  u =="0.000000000000000001" : ] 000000096154822.250900600000000000 ; 000000112119375.037622000000000000 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000000000092B87AAB14A2 >									
116 	//     < RUSS_PFIV_II_metadata_line_7_____NLMK_PLATE_SALES_SA_20231101 >									
117 	//        < N9STZDO1dOP9T43rxcV50jHd4npP1nZpG1sNbhUGwv0293dIB3wqjwQgflH969SE >									
118 	//        <  u =="0.000000000000000001" : ] 000000112119375.037622000000000000 ; 000000133118240.966023000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000AB14A2CB1F50 >									
120 	//     < RUSS_PFIV_II_metadata_line_8_____NLMK_INDIANA_LLC_20231101 >									
121 	//        < 1bno43AgMaXY0lG8FWbqceast1inJdXW8yYE03v14HS6V4D0Jwfa4Vd52S67xz9i >									
122 	//        <  u =="0.000000000000000001" : ] 000000133118240.966023000000000000 ; 000000153701727.443600000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000CB1F50EA87BD >									
124 	//     < RUSS_PFIV_II_metadata_line_9_____STEEL_FUNDING_DAC_20231101 >									
125 	//        < x92zY9LPs4sL6r366VBBnGE4OBoeBja7nsvQdMB079k1Va0DVF5Y2UV8RE9A1FK3 >									
126 	//        <  u =="0.000000000000000001" : ] 000000153701727.443600000000000000 ; 000000171823037.001792000000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000000EA87BD1062E60 >									
128 	//     < RUSS_PFIV_II_metadata_line_10_____ZAO_URALS_PRECISION_ALLOYS_PLANT_20231101 >									
129 	//        < T25Em50813y91ik8Y3143S9XG3f2b09CRAal8v5hn0tck3WF5k2BKwstG2K3a5yl >									
130 	//        <  u =="0.000000000000000001" : ] 000000171823037.001792000000000000 ; 000000188894292.931306000000000000 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000000001062E601203AD5 >									
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
174 	//     < RUSS_PFIV_II_metadata_line_11_____TOP_GUN_INVESTMENT_CORP_20231101 >									
175 	//        < 5e04KIdBSQ3hx1V5o90A81Y92ealOu5hlgXCK13PV1L1Oz3iG6qWsfc8fMlYG7qd >									
176 	//        <  u =="0.000000000000000001" : ] 000000188894292.931306000000000000 ; 000000204811856.830267000000000000 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000000001203AD513884A2 >									
178 	//     < RUSS_PFIV_II_metadata_line_12_____NLMK_ARKTIKGAZ_20231101 >									
179 	//        < ixbHu8EmvZ9h4SE85RLS3Rmwi2zsJrgXXwyiw5yciw1sx7y1MU8Dwr1laIN9961z >									
180 	//        <  u =="0.000000000000000001" : ] 000000204811856.830267000000000000 ; 000000220594434.777025000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000013884A215099B3 >									
182 	//     < RUSS_PFIV_II_metadata_line_13_____TUSCANY_INTERTRADE_20231101 >									
183 	//        < 221Od354Yys25ybuAvP1NZ91m5RPI591v2158lOTe7Oy45K887XHD08JToXH5oVY >									
184 	//        <  u =="0.000000000000000001" : ] 000000220594434.777025000000000000 ; 000000238446388.879603000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000015099B316BD71F >									
186 	//     < RUSS_PFIV_II_metadata_line_14_____MOORFIELD_COMMODITIES_20231101 >									
187 	//        < ADPDwvg84Td6P1e35c5RPgXMj4BqwkcCmAhsG2k449SCg6cBP9h81mJBzFxqT9SG >									
188 	//        <  u =="0.000000000000000001" : ] 000000238446388.879603000000000000 ; 000000254156306.940616000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000016BD71F183CFCF >									
190 	//     < RUSS_PFIV_II_metadata_line_15_____NLMK_COATING_20231101 >									
191 	//        < 92pAGm67CKI9Nu0nQKX04bEsPUNz7cO29bFaQqUW931X67Ka8J6CSF5wMm9aDn02 >									
192 	//        <  u =="0.000000000000000001" : ] 000000254156306.940616000000000000 ; 000000272135350.124129000000000000 ] >									
193 	//        < 0x00000000000000000000000000000000000000000000000000183CFCF19F3EDF >									
194 	//     < RUSS_PFIV_II_metadata_line_16_____NLMK_MAXI_GROUP_20231101 >									
195 	//        < XEvD3x3TrOpME5665QMKH6Fs4ELOII174roAH9ig6HByc766yW4ElvO6N5SZXIj8 >									
196 	//        <  u =="0.000000000000000001" : ] 000000272135350.124129000000000000 ; 000000291229122.341858000000000000 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000000019F3EDF1BC6160 >									
198 	//     < RUSS_PFIV_II_metadata_line_17_____NLMK_SERVICES_LLC_20231101 >									
199 	//        < qm85c55LnAm63cL909QEA13b2hd88w68hdpNs7INldC83j8krP22WRzeBQ3QGpH5 >									
200 	//        <  u =="0.000000000000000001" : ] 000000291229122.341858000000000000 ; 000000311290890.508093000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000001BC61601DAFE01 >									
202 	//     < RUSS_PFIV_II_metadata_line_18_____STEEL_INVEST_FINANCE_20231101 >									
203 	//        < lz3I7c9o3784J44U6BLn9ic172rW6R7VEzi9XR662BT8Fa4j19sNz7D55tntnJYI >									
204 	//        <  u =="0.000000000000000001" : ] 000000311290890.508093000000000000 ; 000000327255148.888426000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000001DAFE011F35A0B >									
206 	//     < RUSS_PFIV_II_metadata_line_19_____CLABECQ_20231101 >									
207 	//        < N5QqUhTfmphDwYSgxh9ikI1E3HI14KGP0AkSwc2PRecu63SR6Dc5M61oPW9vX608 >									
208 	//        <  u =="0.000000000000000001" : ] 000000327255148.888426000000000000 ; 000000346178529.204376000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000001F35A0B21039FD >									
210 	//     < RUSS_PFIV_II_metadata_line_20_____HOLIDAY_HOTEL_NLMK_20231101 >									
211 	//        < D81DKTviXKN382LGS1QNo5zxfcA6APhHRf10LrG69cckTUoRc8Ut5egk1KCwEw6O >									
212 	//        <  u =="0.000000000000000001" : ] 000000346178529.204376000000000000 ; 000000366705895.372140000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000021039FD22F8C7E >									
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
256 	//     < RUSS_PFIV_II_metadata_line_21_____STEELCO_MED_TRADING_20231101 >									
257 	//        < 33Y6nDLs31pLjfu1fv007jljNCzp8Vd8AK9rq87874nXY1s330K3Ibvvk19bvDa2 >									
258 	//        <  u =="0.000000000000000001" : ] 000000366705895.372140000000000000 ; 000000382798458.529083000000000000 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000000022F8C7E2481AA6 >									
260 	//     < RUSS_PFIV_II_metadata_line_22_____LIPETSKY_GIPROMEZ_20231101 >									
261 	//        < 7gzEa6cgLp74JcR1K7h21gto11KPsum0LBwTDAVR0AGLV56Rd19rur66h1ev9o9q >									
262 	//        <  u =="0.000000000000000001" : ] 000000382798458.529083000000000000 ; 000000403548524.200841000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000002481AA6267C424 >									
264 	//     < RUSS_PFIV_II_metadata_line_23_____NORTH_OIL_GAS_CO_20231101 >									
265 	//        < 78M8HO7bTj4SZx1fQngDa66Lp6wj13nmk0GE4c0YT6m4SFf3gMqO43M25otTR3xl >									
266 	//        <  u =="0.000000000000000001" : ] 000000403548524.200841000000000000 ; 000000422850479.544462000000000000 ] >									
267 	//        < 0x00000000000000000000000000000000000000000000000000267C42428537F8 >									
268 	//     < RUSS_PFIV_II_metadata_line_24_____STOYLENSKY_GOK_20231101 >									
269 	//        < 3aF59ChyZ2SL8Sr00kxp66p9ioygG9Fai063yY1fsV6MT2CZkhLrw92CVi9zGCk5 >									
270 	//        <  u =="0.000000000000000001" : ] 000000422850479.544462000000000000 ; 000000443677113.231462000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000028537F82A4FF5F >									
272 	//     < RUSS_PFIV_II_metadata_line_25_____NLMK_RECORDING_CENTER_OOO_20231101 >									
273 	//        < W3v039JP7xOwrT0k23Fk07p1V1hSZ1U6Bj06Uets79nU90e1Tj5fQOJ1gI9CVNxC >									
274 	//        <  u =="0.000000000000000001" : ] 000000443677113.231462000000000000 ; 000000461459855.481975000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002A4FF5F2C021C2 >									
276 	//     < RUSS_PFIV_II_metadata_line_26_____URAL_ARCHI_CONSTRUCTION_RD_INSTITUTE_20231101 >									
277 	//        < jggXyw2Zh3No1ZnrwMxT6yZ8ieRnID0clb8M340OeLJUhC7sY35YxhOS8lrBy9Zu >									
278 	//        <  u =="0.000000000000000001" : ] 000000461459855.481975000000000000 ; 000000482419935.813270000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000002C021C22E01D4A >									
280 	//     < RUSS_PFIV_II_metadata_line_27_____PO_URALMETALLURGSTROY_ZAO_20231101 >									
281 	//        < 6xOY7XEirM25B8UXrLiJ542687G5OBNc5Rf8c7GZ4539h9k0Fe8WH2EiYk3Pk7Cb >									
282 	//        <  u =="0.000000000000000001" : ] 000000482419935.813270000000000000 ; 000000498809703.381804000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000002E01D4A2F91F8A >									
284 	//     < RUSS_PFIV_II_metadata_line_28_____NLMK_LONG_PRODUCTS_20231101 >									
285 	//        < UD54R8lOl5Nk9w571D8k72pbMkOxFHhVz8lr0h4hAz13d4YkdwZ8Ja79pmJ0A5K4 >									
286 	//        <  u =="0.000000000000000001" : ] 000000498809703.381804000000000000 ; 000000516435560.090676000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000002F91F8A31404A4 >									
288 	//     < RUSS_PFIV_II_metadata_line_29_____USSURIYSKAYA_SCRAP_METAL_20231101 >									
289 	//        < FRMmJPn76UHJbJ47578RMZ765TEm4lZZ1fdjoI6nJJV5E6zZ0ek8fzSJ679lg38f >									
290 	//        <  u =="0.000000000000000001" : ] 000000516435560.090676000000000000 ; 000000534981261.197227000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000031404A4330510E >									
292 	//     < RUSS_PFIV_II_metadata_line_30_____NOVOLIPETSKY_PRINTING_HOUSE_20231101 >									
293 	//        < vS5N6Gp2xssmR4l40mG3aC7fuFF31tiN3PsGM19q3Lj5AUGEyNx84oZe3qYZkkDj >									
294 	//        <  u =="0.000000000000000001" : ] 000000534981261.197227000000000000 ; 000000551841592.534046000000000000 ] >									
295 	//        < 0x00000000000000000000000000000000000000000000000000330510E34A0B1F >									
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
338 	//     < RUSS_PFIV_II_metadata_line_31_____CHUPIT_LIMITED_20231101 >									
339 	//        < nWMKbA0d7abVZkPagZzV2ZtGZ671pH3E1AgU34SgYuXx6W41KHaI309lJG3840hg >									
340 	//        <  u =="0.000000000000000001" : ] 000000551841592.534046000000000000 ; 000000567550579.832675000000000000 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000000000034A0B1F3620372 >									
342 	//     < RUSS_PFIV_II_metadata_line_32_____ZHERNOVSKY_I_MINING_PROCESS_COMPLEX_20231101 >									
343 	//        < 18djWov969ZU7seO61kCebU8PZ949vo02S1Qo7U2W46BB69jO97Moi180bi5fD9r >									
344 	//        <  u =="0.000000000000000001" : ] 000000567550579.832675000000000000 ; 000000586783537.694751000000000000 ] >									
345 	//        < 0x00000000000000000000000000000000000000000000000000362037237F5C52 >									
346 	//     < RUSS_PFIV_II_metadata_line_33_____KSIEMP_20231101 >									
347 	//        < Z8Y2U2T1ftxUFB4SSD2CAi1Yd0g9O0WN5P99SDUL1gn498266gT6Uc72OeU3Pxg6 >									
348 	//        <  u =="0.000000000000000001" : ] 000000586783537.694751000000000000 ; 000000605160186.472480000000000000 ] >									
349 	//        < 0x0000000000000000000000000000000000000000000000000037F5C5239B66B3 >									
350 	//     < RUSS_PFIV_II_metadata_line_34_____STROITELNY_MONTAZHNYI_TREST_20231101 >									
351 	//        < J20d8W1iqJierUq6T1Oi9IVb8uQV808Y4c7Y0mI3vl2a08sxp16aw36i3Yy477M3 >									
352 	//        <  u =="0.000000000000000001" : ] 000000605160186.472480000000000000 ; 000000623534624.133811000000000000 ] >									
353 	//        < 0x0000000000000000000000000000000000000000000000000039B66B33B77036 >									
354 	//     < RUSS_PFIV_II_metadata_line_35_____VTORMETSNAB_20231101 >									
355 	//        < ZDCocO9mq2TX4z8sN4uP3XIR5mH21851DI8vGmIYmH64hGW45MN8ou5SAk9juCM3 >									
356 	//        <  u =="0.000000000000000001" : ] 000000623534624.133811000000000000 ; 000000642083765.060993000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000003B770363D3BDF9 >									
358 	//     < RUSS_PFIV_II_metadata_line_36_____DOLOMIT_20231101 >									
359 	//        < 0k573gBUlm4Ayf4Jd3LsAX1C8kU84sv431v1b008BB270HR5Is229n0SrFGNm7Re >									
360 	//        <  u =="0.000000000000000001" : ] 000000642083765.060993000000000000 ; 000000658720285.824485000000000000 ] >									
361 	//        < 0x000000000000000000000000000000000000000000000000003D3BDF93ED209D >									
362 	//     < RUSS_PFIV_II_metadata_line_37_____KALUGA_ELECTRIC_STEELMAKING_PLANT_20231101 >									
363 	//        < q0z7X1iZn2n05i459vAm07kz80ld7T06cGGb2a1TO10Ht2gcmG41Abdc638q9vG5 >									
364 	//        <  u =="0.000000000000000001" : ] 000000658720285.824485000000000000 ; 000000676961791.964287000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000003ED209D408F633 >									
366 	//     < RUSS_PFIV_II_metadata_line_38_____LIPETSKOMBANK_20231101 >									
367 	//        < EM68QDAQ8V1fSwz0Zbu513CJ9qtmb0d37O53X852i6fT63uo3i0XMuCh8u57MT99 >									
368 	//        <  u =="0.000000000000000001" : ] 000000676961791.964287000000000000 ; 000000692883564.049294000000000000 ] >									
369 	//        < 0x00000000000000000000000000000000000000000000000000408F63342141A4 >									
370 	//     < RUSS_PFIV_II_metadata_line_39_____NIZHNESERGINSKY_HARDWARE_METALL_WORKS_20231101 >									
371 	//        < Q0B55X3Id5229g0Id65hMsOBqtWWZ317CFu273c4k51iLUdAJt9A61Y0xhShFNRu >									
372 	//        <  u =="0.000000000000000001" : ] 000000692883564.049294000000000000 ; 000000712949463.921407000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000042141A443FDFE2 >									
374 	//     < RUSS_PFIV_II_metadata_line_40_____KALUGA_SCIENTIFIC_PROD_ELECTROMETALL_PLANT_20231101 >									
375 	//        < Ik9oOZqM9440au3Pg7422R1d07foj9mN5o0dm1p5kjF7qbR8eMxvN1nO27KGWI71 >									
376 	//        <  u =="0.000000000000000001" : ] 000000712949463.921407000000000000 ; 000000730675751.330868000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000043FDFE245AEC37 >									
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