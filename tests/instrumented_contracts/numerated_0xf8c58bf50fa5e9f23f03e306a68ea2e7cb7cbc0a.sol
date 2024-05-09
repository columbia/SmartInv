1 pragma solidity 		^0.4.25	;						
2 										
3 	contract	CHEMCHINA_PFIII_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	CHEMCHINA_PFIII_I_883		"	;
8 		string	public		symbol =	"	CHEMCHINA_PFIII_I_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		566337001572327000000000000					;	
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
92 	//     < CHEMCHINA_PFIII_I_metadata_line_1_____Hangzhou_Hairui_Chemical_Limited_20220321 >									
93 	//        < DPOQ1CSAk25j7ToQ04zsg1Ia89FQP9ZMnPWl90so4ytq0SP4Hwh25LDh6zdB48zX >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000015801786.876325900000000000 ] >									
95 	//        < 0x0000000000000000000000000000000000000000000000000000000000181C93 >									
96 	//     < CHEMCHINA_PFIII_I_metadata_line_2_____Hangzhou_Huajin_Pharmaceutical_Co_Limited_20220321 >									
97 	//        < 2fT2hbm8Frjtd3cBdgBac2Pjwz8HNrO78u4kGVGKH4qx8kf5O9lRTNXN10dkYp0F >									
98 	//        <  u =="0.000000000000000001" : ] 000000015801786.876325900000000000 ; 000000029992243.179108200000000000 ] >									
99 	//        < 0x0000000000000000000000000000000000000000000000000000181C932DC3B8 >									
100 	//     < CHEMCHINA_PFIII_I_metadata_line_3_____Hangzhou_J_H_Chemical_Co__Limited_20220321 >									
101 	//        < 5aWsZMJ7fAC7YXich08DCN8j1BOWuiWZLntLDup7yIX9EQAn0wdM1mZUlKhRU6Ba >									
102 	//        <  u =="0.000000000000000001" : ] 000000029992243.179108200000000000 ; 000000046119291.495105300000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000002DC3B8465F59 >									
104 	//     < CHEMCHINA_PFIII_I_metadata_line_4_____Hangzhou_J_H_Chemical_Co__Limited_20220321 >									
105 	//        < 2Q2gAFZ864bgifk7xOM8AaHMK1nYn29W51By0Tw11aT3jTGd1Hq7PWb1Dm2N3fRS >									
106 	//        <  u =="0.000000000000000001" : ] 000000046119291.495105300000000000 ; 000000061442495.794720100000000000 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000000000465F595DC0FA >									
108 	//     < CHEMCHINA_PFIII_I_metadata_line_5_____HANGZHOU_KEYINGCHEM_Co_Limited_20220321 >									
109 	//        < 4dP6e7oY79YkhlUsZDH3Dly882i3Z42NJe0a53sdk0o2M4fLIL53qz5Gs69ttW63 >									
110 	//        <  u =="0.000000000000000001" : ] 000000061442495.794720100000000000 ; 000000076058539.351318000000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000005DC0FA740E5E >									
112 	//     < CHEMCHINA_PFIII_I_metadata_line_6_____HANGZHOU_MEITE_CHEMICAL_Co_LimitedHANGZHOU_MEITE_INDUSTRY_Co_Limited_20220321 >									
113 	//        < 30V1yO737FuHh3553IbXLAcAbbZ05AL99X8i8Pn1G744qK1u94Dzh6HRqD0fiqG0 >									
114 	//        <  u =="0.000000000000000001" : ] 000000076058539.351318000000000000 ; 000000088341193.756083200000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000740E5E86CC47 >									
116 	//     < CHEMCHINA_PFIII_I_metadata_line_7_____Hangzhou_Ocean_chemical_Co_Limited_20220321 >									
117 	//        < eMWuOR2cPJ7un10v44IR58lRn5uld57iq1nLoKtI4g643bd8BRq3yRdG8ew7Zwx2 >									
118 	//        <  u =="0.000000000000000001" : ] 000000088341193.756083200000000000 ; 000000100695197.779170000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000000086CC4799A610 >									
120 	//     < CHEMCHINA_PFIII_I_metadata_line_8_____Hangzhou_Pharma___Chem_Co_Limited_20220321 >									
121 	//        < tw4Ab1wfeK4cEw5S89o51Xo2SnG0MZLB50xrGIws0hfD66GMv9LRcL53pykS6kG2 >									
122 	//        <  u =="0.000000000000000001" : ] 000000100695197.779170000000000000 ; 000000116281220.622992000000000000 ] >									
123 	//        < 0x000000000000000000000000000000000000000000000000000099A610B16E5A >									
124 	//     < CHEMCHINA_PFIII_I_metadata_line_9_____Hangzhou_Tino_Bio_Tech_Co_Limited_20220321 >									
125 	//        < ML497ue54aNR2Qh078z630UJTf9BKiEF06bsH7OD5T2nMGu4tW83huSU83mwli6n >									
126 	//        <  u =="0.000000000000000001" : ] 000000116281220.622992000000000000 ; 000000131154704.788590000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000000B16E5AC8204E >									
128 	//     < CHEMCHINA_PFIII_I_metadata_line_10_____Hangzhou_Trylead_Chemical_Technology_Co_Limited_20220321 >									
129 	//        < MP95zLuM5L89XW3tAsx95R870NS47z63yRw1ClL6O72j5TXqyW39iE1v28FEUn0S >									
130 	//        <  u =="0.000000000000000001" : ] 000000131154704.788590000000000000 ; 000000143987470.367429000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000000C8204EDBB51B >									
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
174 	//     < CHEMCHINA_PFIII_I_metadata_line_11_____Hangzhou_Verychem_Science_And_Technology_org_20220321 >									
175 	//        < 6De7kUpa0IJ2W98CNUnCcwA8VzwVmavR3Rq8Hg4Kebf73vc1l454WdY5y03J6Xa8 >									
176 	//        <  u =="0.000000000000000001" : ] 000000143987470.367429000000000000 ; 000000158350238.967455000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000000DBB51BF19F90 >									
178 	//     < CHEMCHINA_PFIII_I_metadata_line_12_____Hangzhou_Verychem_Science_And_Technology_Co__Limited_20220321 >									
179 	//        < 7Xa1c3W4zRv43VGHSpE399E4cJA90zuAbBIc7U3e85aDk76jV7gnRcfp48LbMJrS >									
180 	//        <  u =="0.000000000000000001" : ] 000000158350238.967455000000000000 ; 000000174258246.821184000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000000F19F90109E5A1 >									
182 	//     < CHEMCHINA_PFIII_I_metadata_line_13_____Hangzhou_Yuhao_Chemical_Technology_Co_Limited_20220321 >									
183 	//        < c2ZUa61A4o5PM6Su0241L9mJ8vle69P7I61kK0lb2fwalQ20LXBfo1WI6ru5gDS8 >									
184 	//        <  u =="0.000000000000000001" : ] 000000174258246.821184000000000000 ; 000000187071109.518238000000000000 ] >									
185 	//        < 0x00000000000000000000000000000000000000000000000000109E5A111D72A7 >									
186 	//     < CHEMCHINA_PFIII_I_metadata_line_14_____HANGZHOU_ZHIXIN_CHEMICAL_Co__Limited_20220321 >									
187 	//        < pCI6osNtMlU0O8yz3T02p3Gwt0yiPd5yBVCa9bgldN4KpQcAysVVdF3Gd0F8sx1h >									
188 	//        <  u =="0.000000000000000001" : ] 000000187071109.518238000000000000 ; 000000200892105.382823000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000011D72A7132897B >									
190 	//     < CHEMCHINA_PFIII_I_metadata_line_15_____Hangzhou_zhongqi_chem_Co_Limited_20220321 >									
191 	//        < 267w3O7Pd0oN4577NrWPZKeMGEO3PDyl20JDkee3I24q8NqOWX3Ah4YTlWE5i4z8 >									
192 	//        <  u =="0.000000000000000001" : ] 000000200892105.382823000000000000 ; 000000213570087.240359000000000000 ] >									
193 	//        < 0x00000000000000000000000000000000000000000000000000132897B145E1D1 >									
194 	//     < CHEMCHINA_PFIII_I_metadata_line_16_____HEBEI_AOGE_CHEMICAL_Co__Limited_20220321 >									
195 	//        < tdA9ZrCD7S4A30h5n4Zo058ekqCyITU1N36bz4Gy29p0fZFYWRv3341LpksU0Pxt >									
196 	//        <  u =="0.000000000000000001" : ] 000000213570087.240359000000000000 ; 000000226330155.740088000000000000 ] >									
197 	//        < 0x00000000000000000000000000000000000000000000000000145E1D11595A38 >									
198 	//     < CHEMCHINA_PFIII_I_metadata_line_17_____HEBEI_DAPENG_PHARM_CHEM_Co__Limited_20220321 >									
199 	//        < W3TFQatKM8anP3gZQpgJx4FCR16VECDJ4SyfwjU1XS0i2ZzorP9nTK8BydI976S1 >									
200 	//        <  u =="0.000000000000000001" : ] 000000226330155.740088000000000000 ; 000000238894277.046803000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000001595A3816C8614 >									
202 	//     < CHEMCHINA_PFIII_I_metadata_line_18_____Hebei_Guantang_Pharmatech_20220321 >									
203 	//        < L23249cf4w7ITB3pLS34P0FL5C57JyLPPlakcZ3epx5xFTK665Gsh87ANH5ajDe4 >									
204 	//        <  u =="0.000000000000000001" : ] 000000238894277.046803000000000000 ; 000000252520873.767993000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000016C861418150F7 >									
206 	//     < CHEMCHINA_PFIII_I_metadata_line_19_____Hefei_Hirisun_Pharmatech_org_20220321 >									
207 	//        < 7xCS9pXzaqGU83EWNmhkj7D8qKcuH1kAeuAt3D5GV1EjCQtBe426V3d44qU8T5pM >									
208 	//        <  u =="0.000000000000000001" : ] 000000252520873.767993000000000000 ; 000000265311970.616256000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000000018150F7194D57D >									
210 	//     < CHEMCHINA_PFIII_I_metadata_line_20_____Hefei_Hirisun_Pharmatech_Co_Limited_20220321 >									
211 	//        < OfUCX8xSZfJ5GCf1fUZ07m1IE8n6mxnA2tVR6Y6a25Oz4W34o7B78TU0y0FHVR3j >									
212 	//        <  u =="0.000000000000000001" : ] 000000265311970.616256000000000000 ; 000000280868855.382056000000000000 ] >									
213 	//        < 0x00000000000000000000000000000000000000000000000000194D57D1AC9266 >									
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
256 	//     < CHEMCHINA_PFIII_I_metadata_line_21_____HENAN_YUCHEN_FINE_CHEMICAL_Co_Limited_20220321 >									
257 	//        < tNS06kj0e17z1dv3bGfDI6c1LXL3zYEX3uE0ycmn9mmC3EH3r5N0Fv36b7p89i3J >									
258 	//        <  u =="0.000000000000000001" : ] 000000280868855.382056000000000000 ; 000000295147850.920140000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000001AC92661C25C21 >									
260 	//     < CHEMCHINA_PFIII_I_metadata_line_22_____Hi_Tech_Chemistry_Corp_20220321 >									
261 	//        < 4g0f04rP66mAZDLFSoLe443tN62u29lk6uL9GyCNnR906o909NPYXBuc5l6X6zL6 >									
262 	//        <  u =="0.000000000000000001" : ] 000000295147850.920140000000000000 ; 000000307920336.384980000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000001C25C211D5D962 >									
264 	//     < CHEMCHINA_PFIII_I_metadata_line_23_____Hongding_International_Chemical_Industry__Nantong__co___ltd_20220321 >									
265 	//        < u1T5Ow5QEeby81mT90nElZumhu5Evw3XO8kMHV3QeRAXc6iWci86IwVdMBI07D6J >									
266 	//        <  u =="0.000000000000000001" : ] 000000307920336.384980000000000000 ; 000000323819836.583139000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000001D5D9621EE1C20 >									
268 	//     < CHEMCHINA_PFIII_I_metadata_line_24_____Hunan_Chemfish_pharmaceutical_Co_Limited_20220321 >									
269 	//        < 1Z1YDUd83DsTJ94Vw4SH5923SYm3k7s03YT71lySi71NCpb9x2C1D8uc8ZUbYrFK >									
270 	//        <  u =="0.000000000000000001" : ] 000000323819836.583139000000000000 ; 000000336735529.906336000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000001EE1C20201D151 >									
272 	//     < CHEMCHINA_PFIII_I_metadata_line_25_____IFFECT_CHEMPHAR_Co__Limited_20220321 >									
273 	//        < VG97tD0IlFsK7zkXmsft8Y5dzC81RK0uN3X40ckHnZkpj8iU5fi4rQ94yEVJ0CSt >									
274 	//        <  u =="0.000000000000000001" : ] 000000336735529.906336000000000000 ; 000000352520134.683273000000000000 ] >									
275 	//        < 0x00000000000000000000000000000000000000000000000000201D151219E72D >									
276 	//     < CHEMCHINA_PFIII_I_metadata_line_26_____Jiangsu_Guotai_International_Group_Co_Limited_20220321 >									
277 	//        < OJj21yrczwIQcuwz83Ba9EjX9253y580TGh8auj8ZYxhXJ16x35x4KFfAITe42t4 >									
278 	//        <  u =="0.000000000000000001" : ] 000000352520134.683273000000000000 ; 000000365193881.397315000000000000 ] >									
279 	//        < 0x00000000000000000000000000000000000000000000000000219E72D22D3DDC >									
280 	//     < CHEMCHINA_PFIII_I_metadata_line_27_____JIANGXI_TIME_CHEMICAL_Co_Limited_20220321 >									
281 	//        < w960V5gZ16rQQJivUj4a8LUONI8lPi4xLKJB04Jq0Ac3ZPkNl1f0R8Z2jF93da5d >									
282 	//        <  u =="0.000000000000000001" : ] 000000365193881.397315000000000000 ; 000000379763717.819395000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000022D3DDC2437934 >									
284 	//     < CHEMCHINA_PFIII_I_metadata_line_28_____Jianshi_Yuantong_Bioengineering_Co_Limited_20220321 >									
285 	//        < 2UoeqHkE7Ky5PObHHvkF7AX1breXa16zr69yejLIH6x8H916znmtkC114QL37UE7 >									
286 	//        <  u =="0.000000000000000001" : ] 000000379763717.819395000000000000 ; 000000393598133.279803000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000024379342589545 >									
288 	//     < CHEMCHINA_PFIII_I_metadata_line_29_____Jiaxing_Nanyang_Wanshixing_Chemical_Co__Limited_20220321 >									
289 	//        < 7qtE0gu0W61h8fqQuO4fk9REnJD6vE5U1KlU2YW4GbHCeYZB66cnF3oL2QD8aO01 >									
290 	//        <  u =="0.000000000000000001" : ] 000000393598133.279803000000000000 ; 000000407644685.136410000000000000 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000000000258954526E0435 >									
292 	//     < CHEMCHINA_PFIII_I_metadata_line_30_____Jinan_TaiFei_Science_Technology_Co_Limited_20220321 >									
293 	//        < tz4jIE8Tz70i3sd1P44XtQR064JZTfT1MJc89hy8r2g6vClBZr5388I46pJwd9b3 >									
294 	//        <  u =="0.000000000000000001" : ] 000000407644685.136410000000000000 ; 000000423669462.116928000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000026E043528677E2 >									
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
338 	//     < CHEMCHINA_PFIII_I_metadata_line_31_____Jinan_YSPharma_Biotechnology_Co_Limited_20220321 >									
339 	//        < 60DG93X5nd12Xq3f53q2bj5BzFb496e57059su34f9iie63A5w740zCq4X9M4M2a >									
340 	//        <  u =="0.000000000000000001" : ] 000000423669462.116928000000000000 ; 000000437524459.475286000000000000 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000000000028677E229B9BFE >									
342 	//     < CHEMCHINA_PFIII_I_metadata_line_32_____JINCHANG_HOLDING_org_20220321 >									
343 	//        < w42GYgbLblm0oE35otBbse9o9b4aR4FSgiA3202H0Oj7MeyH5N9TBONcw2AM5d89 >									
344 	//        <  u =="0.000000000000000001" : ] 000000437524459.475286000000000000 ; 000000452037750.612669000000000000 ] >									
345 	//        < 0x0000000000000000000000000000000000000000000000000029B9BFE2B1C13F >									
346 	//     < CHEMCHINA_PFIII_I_metadata_line_33_____JINCHANG_HOLDING_LIMITED_20220321 >									
347 	//        < 3eoZ9dO9Xat2KM3wt24P7VLfq6YyYILv56o9l1Skw14VmA5rBHNhvMaaXxbXpQr8 >									
348 	//        <  u =="0.000000000000000001" : ] 000000452037750.612669000000000000 ; 000000466500857.583556000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000002B1C13F2C7D2E6 >									
350 	//     < CHEMCHINA_PFIII_I_metadata_line_34_____Jinhua_huayi_chemical_Co__Limited_20220321 >									
351 	//        < 62jn1O5E3h0is934qaLPsldCIjDEs7fV3959Uz3JCuNIcRJ18q389yPh8BV0BGBs >									
352 	//        <  u =="0.000000000000000001" : ] 000000466500857.583556000000000000 ; 000000481446393.898940000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000002C7D2E62DEA0FF >									
354 	//     < CHEMCHINA_PFIII_I_metadata_line_35_____Jinhua_Qianjiang_Fine_Chemical_Co_Limited_20220321 >									
355 	//        < A65Ua7x3z3WiKS56Nf2RHFRY32ckdHOZlXNDZi3eJ91ryNnTcQ963Jj2Rc276oh9 >									
356 	//        <  u =="0.000000000000000001" : ] 000000481446393.898940000000000000 ; 000000496787354.876029000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000002DEA0FF2F6098F >									
358 	//     < CHEMCHINA_PFIII_I_metadata_line_36_____Jinjiangchem_Corporation_20220321 >									
359 	//        < 1Smio37G7O773cN20we6n7eJIf1c49uYL77547JQrjXJu6ERl0Yc5tc2RpRqc720 >									
360 	//        <  u =="0.000000000000000001" : ] 000000496787354.876029000000000000 ; 000000510272868.953322000000000000 ] >									
361 	//        < 0x000000000000000000000000000000000000000000000000002F6098F30A9D57 >									
362 	//     < CHEMCHINA_PFIII_I_metadata_line_37_____Jiurui_Biology___Chemistry_Co_Limited_20220321 >									
363 	//        < G10af9nLr2cT84FkBWq0zcHatpd5MysiXV537a9GP6IV8UJP9FpP0L64nSBZ4Qqi >									
364 	//        <  u =="0.000000000000000001" : ] 000000510272868.953322000000000000 ; 000000525626384.148300000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000030A9D573220ACE >									
366 	//     < CHEMCHINA_PFIII_I_metadata_line_38_____Jlight_Chemicals_org_20220321 >									
367 	//        < 9xK8x9XB677B5xrp0KHYN4r375m9OHpg429zHnF90lWu67Ip2QjUUxY6h6PhLd8d >									
368 	//        <  u =="0.000000000000000001" : ] 000000525626384.148300000000000000 ; 000000539672413.746840000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000003220ACE3377989 >									
370 	//     < CHEMCHINA_PFIII_I_metadata_line_39_____Jlight_Chemicals_Company_20220321 >									
371 	//        < 3Ilw0OEWoAh0202VN8lM6Hgg5yvrYqKpu590tQ5QrDsZAzFy0K6Vdrcn5sXA0p2Y >									
372 	//        <  u =="0.000000000000000001" : ] 000000539672413.746840000000000000 ; 000000553799492.047420000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000337798934D07ED >									
374 	//     < CHEMCHINA_PFIII_I_metadata_line_40_____JQC_China_Pharmaceutical_Co_Limited_20220321 >									
375 	//        < 55W51GawS35NFz81fn8CU4AB8v4Ns5S9l9f1l471JWs1YOsK64RoElUI8JX98GJ5 >									
376 	//        <  u =="0.000000000000000001" : ] 000000553799492.047420000000000000 ; 000000566337001.572327000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000034D07ED3602964 >									
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