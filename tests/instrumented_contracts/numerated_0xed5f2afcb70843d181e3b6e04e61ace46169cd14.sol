1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXX_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXX_III_883		"	;
8 		string	public		symbol =	"	RUSS_PFXX_III_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1035654325322250000000000000					;	
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
92 	//     < RUSS_PFXX_III_metadata_line_1_____Eurochem_20251101 >									
93 	//        < JHq8PwPB085sL0KOYZRpZ09o401Y35mWV722i2Az94u302ZS3qr1j6u3sd50woW3 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000028609915.069590000000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000002BA7C0 >									
96 	//     < RUSS_PFXX_III_metadata_line_2_____Eurochem_Group_AG_Switzerland_20251101 >									
97 	//        < 6G9YMiPJEeHv6g9riuX3K41m5r4cYloYFzvZ1K5uw1my4AVXwjz6ngj8t0fM767Y >									
98 	//        <  u =="0.000000000000000001" : ] 000000028609915.069590000000000000 ; 000000056340552.576814100000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000002BA7C055F807 >									
100 	//     < RUSS_PFXX_III_metadata_line_3_____Industrial _Group_Phosphorite_20251101 >									
101 	//        < kBPmjTYxfx3Rvc7hxV80Xd2a6qdl2g3b7Bt9bdloZl871R7Ehob3BK7lpneg02tU >									
102 	//        <  u =="0.000000000000000001" : ] 000000056340552.576814100000000000 ; 000000076230586.277943400000000000 ] >									
103 	//        < 0x000000000000000000000000000000000000000000000000000055F807745193 >									
104 	//     < RUSS_PFXX_III_metadata_line_4_____Novomoskovsky_Azot_20251101 >									
105 	//        < 8V4693ds25aax5g6ZQqDZe9hPBXy0XBLr902M4zY67EzL02ACeb60k4Pg6q8r832 >									
106 	//        <  u =="0.000000000000000001" : ] 000000076230586.277943400000000000 ; 000000109730311.092117000000000000 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000000000745193A76F67 >									
108 	//     < RUSS_PFXX_III_metadata_line_5_____Novomoskovsky_Chlor_20251101 >									
109 	//        < TSR6Jc6x72C997D42RvR2vET7Y2NmYo5hU8ZEQKxQVz2Mf8nX5C82ob0Bgsgn9r1 >									
110 	//        <  u =="0.000000000000000001" : ] 000000109730311.092117000000000000 ; 000000134719622.689228000000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000A76F67CD90DA >									
112 	//     < RUSS_PFXX_III_metadata_line_6_____Nevinnomyssky_Azot_20251101 >									
113 	//        < H7UNNu6h33q0A7IuUY3t1523OG4o31lz75uRxth22X0P301W7Tq7LcKHCXH0zS7E >									
114 	//        <  u =="0.000000000000000001" : ] 000000134719622.689228000000000000 ; 000000155823030.701342000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000CD90DAEDC45F >									
116 	//     < RUSS_PFXX_III_metadata_line_7_____EuroChem_Belorechenskie_Minudobrenia_20251101 >									
117 	//        < g4ZsNRiZ5LGb2Ss9ihCnikMZa8U420GplQ09g9dZV6A5q9xc45wa2t8O9e0nvB8Z >									
118 	//        <  u =="0.000000000000000001" : ] 000000155823030.701342000000000000 ; 000000178154782.284357000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000000EDC45F10FD7B6 >									
120 	//     < RUSS_PFXX_III_metadata_line_8_____Kovdorsky_GOK_20251101 >									
121 	//        < hTbS2J4vRYfA4xn6636cLvac23Ri8OB50zFiczrfN0c8SYKT5xa7UL8UTPr22NUZ >									
122 	//        <  u =="0.000000000000000001" : ] 000000178154782.284357000000000000 ; 000000197535497.113035000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000010FD7B612D6A4E >									
124 	//     < RUSS_PFXX_III_metadata_line_9_____Lifosa_AB_20251101 >									
125 	//        < ociJ0KHgR5E3o44WMn3o9L72VDHPONH0SbdSQx4daKspezu8H75FMU06O4nEQ1M1 >									
126 	//        <  u =="0.000000000000000001" : ] 000000197535497.113035000000000000 ; 000000220655345.827623000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000012D6A4E150B17F >									
128 	//     < RUSS_PFXX_III_metadata_line_10_____EuroChem_Antwerpen_NV_20251101 >									
129 	//        < b1Gf4GgM355y5A8tHk33h88XsC0nbQCO0PFtKba37wOAed86x1xV57r2U0r37bHY >									
130 	//        <  u =="0.000000000000000001" : ] 000000220655345.827623000000000000 ; 000000241372315.550080000000000000 ] >									
131 	//        < 0x00000000000000000000000000000000000000000000000000150B17F1704E10 >									
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
174 	//     < RUSS_PFXX_III_metadata_line_11_____EuroChem_VolgaKaliy_20251101 >									
175 	//        < vCX701U9w64hg30M2hjH2l00QilOD0xgB75YY8yVGDW5ZM2hPJI9XFT6b7gddO8m >									
176 	//        <  u =="0.000000000000000001" : ] 000000241372315.550080000000000000 ; 000000271088227.677032000000000000 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000000001704E1019DA5D7 >									
178 	//     < RUSS_PFXX_III_metadata_line_12_____EuroChem_Usolsky_potash_complex_20251101 >									
179 	//        < 0wZ98491wCR48I7JF0q7P2CJsG6Jw29uhLxM0ZQ7SL1EH6s359Ftmw5Xwhj5Cd88 >									
180 	//        <  u =="0.000000000000000001" : ] 000000271088227.677032000000000000 ; 000000305368010.188075000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000019DA5D71D1F461 >									
182 	//     < RUSS_PFXX_III_metadata_line_13_____EuroChem_ONGK_20251101 >									
183 	//        < fB62b0A89Vdb2229Rz6R68Lw371VOI9JO5Pjn86lr43YCLreHBQCYr9pI6dBMRQd >									
184 	//        <  u =="0.000000000000000001" : ] 000000305368010.188075000000000000 ; 000000324245434.054165000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001D1F4611EEC25F >									
186 	//     < RUSS_PFXX_III_metadata_line_14_____EuroChem_Northwest_20251101 >									
187 	//        < zE6G0mSc5Saf0O91s3a4Zom8c5U1632uu51jZfrVUp7dKOPuf84vGsn8CVo40bfx >									
188 	//        <  u =="0.000000000000000001" : ] 000000324245434.054165000000000000 ; 000000359107395.197993000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000001EEC25F223F454 >									
190 	//     < RUSS_PFXX_III_metadata_line_15_____EuroChem_Fertilizers_20251101 >									
191 	//        < 6Lak84w5WVy0XUQ6IF3eb2Z51sn92dS20wfy48z9FrSjTOUHYp7GfmU9S47F2uQa >									
192 	//        <  u =="0.000000000000000001" : ] 000000359107395.197993000000000000 ; 000000379074425.615034000000000000 ] >									
193 	//        < 0x00000000000000000000000000000000000000000000000000223F4542426BF3 >									
194 	//     < RUSS_PFXX_III_metadata_line_16_____Astrakhan_Oil_and_Gas_Company_20251101 >									
195 	//        < n3314o3mJunUvff8fkq942vYWA6DwA9csm094Fu8y6eq6Cg7sk8xHyA7k2zuRsRQ >									
196 	//        <  u =="0.000000000000000001" : ] 000000379074425.615034000000000000 ; 000000411823018.275793000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000002426BF3274645E >									
198 	//     < RUSS_PFXX_III_metadata_line_17_____Sary_Tas_Fertilizers_20251101 >									
199 	//        < Ji791a0fMG4bmb4F6qd2h12C5rBeF2L3qnpkBxusl5SkVUVgU6f5buNzRWNMpovX >									
200 	//        <  u =="0.000000000000000001" : ] 000000411823018.275793000000000000 ; 000000430895087.772033000000000000 ] >									
201 	//        < 0x00000000000000000000000000000000000000000000000000274645E2917E65 >									
202 	//     < RUSS_PFXX_III_metadata_line_18_____EuroChem_Karatau_20251101 >									
203 	//        < 6bFVM568507P3EuK55niwa33l4W2TrTMV0ccPkP57rGM4s76I8krRW5f5nqRZuC0 >									
204 	//        <  u =="0.000000000000000001" : ] 000000430895087.772033000000000000 ; 000000453754618.363619000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000002917E652B45FE6 >									
206 	//     < RUSS_PFXX_III_metadata_line_19_____Kamenkovskaya_Oil_Gas_Company_20251101 >									
207 	//        < 6018nsvV0U1wdp9FbgcO59mrEJPd4641xn9VK6TinnhUadmtDD8BE330Kl03iHH2 >									
208 	//        <  u =="0.000000000000000001" : ] 000000453754618.363619000000000000 ; 000000480961129.755284000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000002B45FE62DDE371 >									
210 	//     < RUSS_PFXX_III_metadata_line_20_____EuroChem_Trading_GmbH_Trading_20251101 >									
211 	//        < A3FMn5aL2y0J72U41CZ4Z7fXVCVFx67g89I9P1xSbZwJqhVh1KxSX4FDnoXAbV9c >									
212 	//        <  u =="0.000000000000000001" : ] 000000480961129.755284000000000000 ; 000000512984135.884633000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000002DDE37130EC06E >									
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
256 	//     < RUSS_PFXX_III_metadata_line_21_____EuroChem_Trading_USA_Corp_20251101 >									
257 	//        < 1lVy71z9H6hRS0e3z89AB1VXfJtF4Z1KqVZP1zw2er8BMy0qS0ekPksvwWJGO213 >									
258 	//        <  u =="0.000000000000000001" : ] 000000512984135.884633000000000000 ; 000000535810401.909225000000000000 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000000030EC06E33194F0 >									
260 	//     < RUSS_PFXX_III_metadata_line_22_____Ben_Trei_Ltd_20251101 >									
261 	//        < 7Y8Oo7nmiUgwd9UC0SeO29k80W3Vcc49YEd8r6875TT568Jp93998qy97H0GUFlt >									
262 	//        <  u =="0.000000000000000001" : ] 000000535810401.909225000000000000 ; 000000562583082.869878000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000033194F035A6F04 >									
264 	//     < RUSS_PFXX_III_metadata_line_23_____EuroChem_Agro_SAS_20251101 >									
265 	//        < Bk6MxE01aktuy165395F1EHr2fDYanDBY8VnsoXrXTa4K9NdHam102iBy6NX956h >									
266 	//        <  u =="0.000000000000000001" : ] 000000562583082.869878000000000000 ; 000000583167306.594547000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000035A6F04379D7BB >									
268 	//     < RUSS_PFXX_III_metadata_line_24_____EuroChem_Agro_Asia_20251101 >									
269 	//        < 672obwe62GqrQgXshVzfA0MwBf1CjH4ptCf1WnET4KFlr3XZ67ijl8rk0M6Y6Gul >									
270 	//        <  u =="0.000000000000000001" : ] 000000583167306.594547000000000000 ; 000000610685215.481437000000000000 ] >									
271 	//        < 0x00000000000000000000000000000000000000000000000000379D7BB3A3D4EA >									
272 	//     < RUSS_PFXX_III_metadata_line_25_____EuroChem_Agro_Iberia_20251101 >									
273 	//        < Jowb5D2H4o0yx98WL29UHia173NguwC5W3iqIwwGvDreIBdCDz58WKoGWwP545zb >									
274 	//        <  u =="0.000000000000000001" : ] 000000610685215.481437000000000000 ; 000000632144099.013530000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000003A3D4EA3C4934A >									
276 	//     < RUSS_PFXX_III_metadata_line_26_____EuroChem_Agricultural_Trading_Hellas_20251101 >									
277 	//        < K386W35w37LnQ6b8ufOBz1wREdRt63aOvIddt2q9A4i4CE65R18WDIB8gSohZ7UD >									
278 	//        <  u =="0.000000000000000001" : ] 000000632144099.013530000000000000 ; 000000664539451.677905000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000003C4934A3F601B9 >									
280 	//     < RUSS_PFXX_III_metadata_line_27_____EuroChem_Agro_Spa_20251101 >									
281 	//        < s0F0SE5IhawtgtfCqj2N31D21c4S0919xAHeazj7w7w56D4VDw71wSSpp1Tp4rIa >									
282 	//        <  u =="0.000000000000000001" : ] 000000664539451.677905000000000000 ; 000000694714813.098824000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000003F601B94240CF9 >									
284 	//     < RUSS_PFXX_III_metadata_line_28_____EuroChem_Agro_GmbH_20251101 >									
285 	//        < 7x7p6uC8IZ9mfnEf8DtshvH1omxXZi62qERI310vUtPNFQ10rQQr6381K8xkBh1t >									
286 	//        <  u =="0.000000000000000001" : ] 000000694714813.098824000000000000 ; 000000723898753.092230000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000004240CF945094F3 >									
288 	//     < RUSS_PFXX_III_metadata_line_29_____EuroChem_Agro_México_SA_20251101 >									
289 	//        < c7E31394vZFeMiaImh8Q1T4ad7THL036m1o35fSu44uPqun4uo1AN36le0LU3ROc >									
290 	//        <  u =="0.000000000000000001" : ] 000000723898753.092230000000000000 ; 000000749146894.150687000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000045094F34771B81 >									
292 	//     < RUSS_PFXX_III_metadata_line_30_____EuroChem_Agro_Hungary_Kft_20251101 >									
293 	//        < An0802va9r85iIl555rzs1Gp6E70WzIMKv1g1YRE5pce8n1267wzErO267q4wuG3 >									
294 	//        <  u =="0.000000000000000001" : ] 000000749146894.150687000000000000 ; 000000784496160.387966000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000004771B814AD0BD0 >									
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
338 	//     < RUSS_PFXX_III_metadata_line_31_____Agrocenter_EuroChem_Srl_20251101 >									
339 	//        < 5JEsZ80s86492980MV4d6Y9SZx3QXae8rPHFHkej92cTSyH4Dbl667thOoG8ZFYH >									
340 	//        <  u =="0.000000000000000001" : ] 000000784496160.387966000000000000 ; 000000806073831.044258000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000004AD0BD04CDF897 >									
342 	//     < RUSS_PFXX_III_metadata_line_32_____EuroChem_Agro_Bulgaria_Ead_20251101 >									
343 	//        < xc3c4M7X16ivuB43r9PVsJ5p0EnNA6WL5ec816J0r2Wa33lZZ0qkTe2rvbi3PTl1 >									
344 	//        <  u =="0.000000000000000001" : ] 000000806073831.044258000000000000 ; 000000836728245.516386000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000004CDF8974FCBEF9 >									
346 	//     < RUSS_PFXX_III_metadata_line_33_____EuroChem_Agro_doo_Beograd_20251101 >									
347 	//        < 5DB519IQ4693bG5eIhTxa945HgG0947L9av0XBl83zM4R3pMJ52qwY0Hya36kyJf >									
348 	//        <  u =="0.000000000000000001" : ] 000000836728245.516386000000000000 ; 000000861100071.884501000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000004FCBEF9521EF37 >									
350 	//     < RUSS_PFXX_III_metadata_line_34_____EuroChem_Agro_Turkey_Tarim_Sanayi_ve_Ticaret_20251101 >									
351 	//        < 06bw67TY6E8Ck975I40i4Lb3zzWiA0Ng2FbUJw1iq2xcB6Q0mSPFc1n7DTQg3aGb >									
352 	//        <  u =="0.000000000000000001" : ] 000000861100071.884501000000000000 ; 000000889040865.200113000000000000 ] >									
353 	//        < 0x00000000000000000000000000000000000000000000000000521EF3754C9197 >									
354 	//     < RUSS_PFXX_III_metadata_line_35_____Emerger_Fertilizantes_SA_20251101 >									
355 	//        < ep065rIC33e15r5qEpL9ZE5y995X37RqDe902OkHj0068XCaZOtFK71oKRY8jO83 >									
356 	//        <  u =="0.000000000000000001" : ] 000000889040865.200113000000000000 ; 000000908931681.376031000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000054C919756AEB70 >									
358 	//     < RUSS_PFXX_III_metadata_line_36_____EuroChem_Comercio_Produtos_Quimicos_20251101 >									
359 	//        < T3k9FnVucDnnkWOT3kFmQWby40CUfUV5Yb5bBxH5oiSFn8Wc66A3Rj0v97XY1xs3 >									
360 	//        <  u =="0.000000000000000001" : ] 000000908931681.376031000000000000 ; 000000938498174.299412000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000056AEB7059808D9 >									
362 	//     < RUSS_PFXX_III_metadata_line_37_____Fertilizantes_Tocantines_Ltda_20251101 >									
363 	//        < Rmw1LYxHAQngAT609cp5A03GH1rRC8H5Vd1IO23Mxv60r89Dm2LL3E3AnLBm1AxN >									
364 	//        <  u =="0.000000000000000001" : ] 000000938498174.299412000000000000 ; 000000964831283.071365000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000059808D95C03738 >									
366 	//     < RUSS_PFXX_III_metadata_line_38_____EuroChem_Agro_Trading_Shenzhen_20251101 >									
367 	//        < nkZP5g5l5u576P4FQ2Z9M7Y86530g4chEno392g9CcyhzBpFpxnx7ysWo9JV789b >									
368 	//        <  u =="0.000000000000000001" : ] 000000964831283.071365000000000000 ; 000000991188512.976932000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000005C037385E86F03 >									
370 	//     < RUSS_PFXX_III_metadata_line_39_____EuroChem_Trading_RUS_20251101 >									
371 	//        < xwcl7L0x94LjPK9nAvDbB1nWPM1BWvEZiu9Mh5Qj2E2Ut8l1HD0FQrzGznQksimE >									
372 	//        <  u =="0.000000000000000001" : ] 000000991188512.976932000000000000 ; 000001017329176.570180000000000000 ] >									
373 	//        < 0x000000000000000000000000000000000000000000000000005E86F036105236 >									
374 	//     < RUSS_PFXX_III_metadata_line_40_____AgroCenter_EuroChem_Ukraine_20251101 >									
375 	//        < q0XZ1k2f70WUvJxLDBrj6683apKps71cun8E64r23451M6YUeIO2bzCjhdaQeRis >									
376 	//        <  u =="0.000000000000000001" : ] 000001017329176.570180000000000000 ; 000001035654325.322250000000000000 ] >									
377 	//        < 0x00000000000000000000000000000000000000000000000000610523662C4879 >									
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