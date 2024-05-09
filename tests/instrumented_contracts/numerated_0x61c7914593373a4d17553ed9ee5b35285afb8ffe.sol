1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXXIX_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXXIX_III_883		"	;
8 		string	public		symbol =	"	RUSS_PFXXIX_III_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1062738178999180000000000000					;	
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
92 	//     < RUSS_PFXXIX_III_metadata_line_1_____INGOSSTRAKH_ORG_20251101 >									
93 	//        < oP54iBdbiY5x8rTv3ke7CdCL22CODU93FpGNbi3DL8536f73BM6LgyFk8l32wWNl >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000021589251.983080200000000000 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000000020F14D >									
96 	//     < RUSS_PFXXIX_III_metadata_line_2_____INGO_gbp_20251101 >									
97 	//        < I3yh35Sd4PEd9V7genN16wUIC36Xec57v4mbk2QiLQAg4sj0zNM3ry4HeDX3vHhm >									
98 	//        <  u =="0.000000000000000001" : ] 000000021589251.983080200000000000 ; 000000040342024.352102400000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000020F14D3D8E9A >									
100 	//     < RUSS_PFXXIX_III_metadata_line_3_____INGO_usd_20251101 >									
101 	//        < qK2oA04mhtSbhlzh62cDe0Y63PMcA08hgsUonwv8ogg99S29WVJONfX3FeC435W7 >									
102 	//        <  u =="0.000000000000000001" : ] 000000040342024.352102400000000000 ; 000000072140159.337467100000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000003D8E9A6E13C0 >									
104 	//     < RUSS_PFXXIX_III_metadata_line_4_____INGO_chf_20251101 >									
105 	//        < MBGK36yD7ZW1Xz3dFKQ44j9XWA2M3E76rUHm121gFv4Ks2a3IrJB3mKgvQ6LfnlC >									
106 	//        <  u =="0.000000000000000001" : ] 000000072140159.337467100000000000 ; 000000097745586.351242100000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000006E13C09525DF >									
108 	//     < RUSS_PFXXIX_III_metadata_line_5_____INGO_eur_20251101 >									
109 	//        < jGNBGRjP52n8ws8VuPj8vnZ73ylDSQedze73T4i3wH94WIsm9823UMqUj19z10f2 >									
110 	//        <  u =="0.000000000000000001" : ] 000000097745586.351242100000000000 ; 000000121221269.853584000000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000009525DFB8F80F >									
112 	//     < RUSS_PFXXIX_III_metadata_line_6_____SIBAL_ORG_20251101 >									
113 	//        < 8v663miH6k8Hb4EQnu8pJv98CoCh2JIgjs8bqG4JOb00cjc7AUn9uD8uECZ7xD8z >									
114 	//        <  u =="0.000000000000000001" : ] 000000121221269.853584000000000000 ; 000000152445704.714074000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000B8F80FE89D1A >									
116 	//     < RUSS_PFXXIX_III_metadata_line_7_____SIBAL_DAO_20251101 >									
117 	//        < 5nUnNckN5t76h67Z1VZU38C7f1Nv6v44En3XEnDV6878C4Zj8zsf7X8PB36dO44g >									
118 	//        <  u =="0.000000000000000001" : ] 000000152445704.714074000000000000 ; 000000176592443.577200000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000000E89D1A10D756C >									
120 	//     < RUSS_PFXXIX_III_metadata_line_8_____SIBAL_DAOPI_20251101 >									
121 	//        < U13ArF2QN1b8kdMU7ja650ov0Bp907Ip2dYAyzNNxGuDq0L8ZKaFINnY84231WE3 >									
122 	//        <  u =="0.000000000000000001" : ] 000000176592443.577200000000000000 ; 000000196429089.096809000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000010D756C12BBA1D >									
124 	//     < RUSS_PFXXIX_III_metadata_line_9_____SIBAL_DAC_20251101 >									
125 	//        < vAykz08j2W9bPA7jK6IgGFpICM6zUL1JL705uaRd360VbjpJxUv2FSee5UGgUDzp >									
126 	//        <  u =="0.000000000000000001" : ] 000000196429089.096809000000000000 ; 000000225326749.528079000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000012BBA1D157D243 >									
128 	//     < RUSS_PFXXIX_III_metadata_line_10_____SIBAL_BIMI_20251101 >									
129 	//        < t3Rd06LlYhz98u3TP6EDtmA4x5R8My1JDKheFkmoJ6C1hDQwj6Uf9fW6jp4qHDm6 >									
130 	//        <  u =="0.000000000000000001" : ] 000000225326749.528079000000000000 ; 000000252441127.633128000000000000 ] >									
131 	//        < 0x00000000000000000000000000000000000000000000000000157D24318131D1 >									
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
174 	//     < RUSS_PFXXIX_III_metadata_line_11_____INGO_ARMENIA_20251101 >									
175 	//        < 8QNs34UrS7yOrGg46vpdMo56IO4Ih8Ge8cV804m6PPdiQApi7Hyc9Uk702zj2xSy >									
176 	//        <  u =="0.000000000000000001" : ] 000000252441127.633128000000000000 ; 000000277006341.659856000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000018131D11A6AD9A >									
178 	//     < RUSS_PFXXIX_III_metadata_line_12_____INGO_INSURANCE_COMPANY_20251101 >									
179 	//        < TF683AA18xB7te9DPHRNRJf9CLs4Vs0YQ8A6g88nDEqrpxPm8f6SYXKndJei3t5x >									
180 	//        <  u =="0.000000000000000001" : ] 000000277006341.659856000000000000 ; 000000297977595.488732000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000001A6AD9A1C6AD80 >									
182 	//     < RUSS_PFXXIX_III_metadata_line_13_____ONDD_CREDIT_INSURANCE_20251101 >									
183 	//        < EE1nn3TIV328TY6wO3HFM897uy0CTl99PbQn630yG6n4m7i6Wcrb70qTsIk8o107 >									
184 	//        <  u =="0.000000000000000001" : ] 000000297977595.488732000000000000 ; 000000325933885.900514000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001C6AD801F155ED >									
186 	//     < RUSS_PFXXIX_III_metadata_line_14_____BANK_SOYUZ_INGO_20251101 >									
187 	//        < qdKu0JrL5Z8Tiv26hpcH39ZE26pVyKsJD1Zjt05gnSPo8ApdMi429fTu03uOF3wu >									
188 	//        <  u =="0.000000000000000001" : ] 000000325933885.900514000000000000 ; 000000360299508.354960000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000001F155ED225C5FF >									
190 	//     < RUSS_PFXXIX_III_metadata_line_15_____CHREZVYCHAJNAYA_STRAKHOVAYA_KOMP_20251101 >									
191 	//        < oyQI28KCiKpAap2WyxDJhi9ajC3M22f82w3UED1c692B4g50w1R638D420B24GER >									
192 	//        <  u =="0.000000000000000001" : ] 000000360299508.354960000000000000 ; 000000382090389.814067000000000000 ] >									
193 	//        < 0x00000000000000000000000000000000000000000000000000225C5FF247060F >									
194 	//     < RUSS_PFXXIX_III_metadata_line_16_____ONDD_ORG_20251101 >									
195 	//        < RXTwtK90Zg2Uec18RGbipQi1hpRj11w93z62u1O37229uL48H5FMHf9eLriBd7Kq >									
196 	//        <  u =="0.000000000000000001" : ] 000000382090389.814067000000000000 ; 000000416207857.037586000000000000 ] >									
197 	//        < 0x00000000000000000000000000000000000000000000000000247060F27B1532 >									
198 	//     < RUSS_PFXXIX_III_metadata_line_17_____ONDD_DAO_20251101 >									
199 	//        < 905l9UEvEfWn95HViC7Jluhi1dfuNG6mJoDb7TC821LBOCz4VQIVVaKQp8E939X5 >									
200 	//        <  u =="0.000000000000000001" : ] 000000416207857.037586000000000000 ; 000000439701594.841927000000000000 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000000027B153229EEE6F >									
202 	//     < RUSS_PFXXIX_III_metadata_line_18_____ONDD_DAOPI_20251101 >									
203 	//        < Q6n272VKhFk086xi2c8PB5Pe4c33VHXnH1HPa9233akZ0Ea6VF9Do68yo5IIy0QY >									
204 	//        <  u =="0.000000000000000001" : ] 000000439701594.841927000000000000 ; 000000460323170.962053000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000029EEE6F2BE65BD >									
206 	//     < RUSS_PFXXIX_III_metadata_line_19_____ONDD_DAC_20251101 >									
207 	//        < 7SWKI153e0E7RvNv2gHhA2Rd589YOTuv1KIiCAn3mF2n7C93AZUzR706b7rx5o7j >									
208 	//        <  u =="0.000000000000000001" : ] 000000460323170.962053000000000000 ; 000000480700720.281028000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000002BE65BD2DD7DB8 >									
210 	//     < RUSS_PFXXIX_III_metadata_line_20_____ONDD_BIMI_20251101 >									
211 	//        < 8dIATp0h9M7H798Q185jNk5KW9uc1LO8NBDcZ1Y09NKRpm1523xSho9OS697n2Ey >									
212 	//        <  u =="0.000000000000000001" : ] 000000480700720.281028000000000000 ; 000000510944836.617959000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000002DD7DB830BA3D4 >									
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
256 	//     < RUSS_PFXXIX_III_metadata_line_21_____SOYUZ_ORG_20251101 >									
257 	//        < 9UK8XBgq4Q48dar1hwuGq17P0rpJ9m07Lm4kDtKBGizMbw3gFPxJJAJg47848NyW >									
258 	//        <  u =="0.000000000000000001" : ] 000000510944836.617959000000000000 ; 000000544052438.330435000000000000 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000000030BA3D433E287C >									
260 	//     < RUSS_PFXXIX_III_metadata_line_22_____SOYUZ_DAO_20251101 >									
261 	//        < YG5sR340JrQ7NweWZfFx6aa5AKHk1wHvVF4j81xBCk4h6r9DvxeKyrfB9soBj79I >									
262 	//        <  u =="0.000000000000000001" : ] 000000544052438.330435000000000000 ; 000000565588411.113473000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000033E287C35F04F9 >									
264 	//     < RUSS_PFXXIX_III_metadata_line_23_____SOYUZ_DAOPI_20251101 >									
265 	//        < VG2Nr29I86QKbDH624Oap4I7M2mE76I0l86k7Y1T5Y5L2p9O2UpLx4yOnwfF4wlE >									
266 	//        <  u =="0.000000000000000001" : ] 000000565588411.113473000000000000 ; 000000592995273.189449000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000035F04F9388D6C7 >									
268 	//     < RUSS_PFXXIX_III_metadata_line_24_____SOYUZ_DAC_20251101 >									
269 	//        < 5P58qa3MS3eui1Bkb3gend1Cu3N3920DXEKhWqH60q9t0xWn1dyLT28x0a6446gs >									
270 	//        <  u =="0.000000000000000001" : ] 000000592995273.189449000000000000 ; 000000620453981.536793000000000000 ] >									
271 	//        < 0x00000000000000000000000000000000000000000000000000388D6C73B2BCD6 >									
272 	//     < RUSS_PFXXIX_III_metadata_line_25_____SOYUZ_BIMI_20251101 >									
273 	//        < J2s9E1F919q7B73u5yBS4cf0FZ6qqYs8Iue51fq2UnMwwjriQ30V1Td82EmXqzV6 >									
274 	//        <  u =="0.000000000000000001" : ] 000000620453981.536793000000000000 ; 000000647245398.207369000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000003B2BCD63DB9E3C >									
276 	//     < RUSS_PFXXIX_III_metadata_line_26_____PIFAGOR_AM_20251101 >									
277 	//        < 1S8b5862KpA14fsMlTtG2i0W06ISX0iqWeV2KDg7M9TehK41y5f6sk7e7t8Ez60O >									
278 	//        <  u =="0.000000000000000001" : ] 000000647245398.207369000000000000 ; 000000676805896.304523000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000003DB9E3C408B94E >									
280 	//     < RUSS_PFXXIX_III_metadata_line_27_____SK_INGO_LMT_20251101 >									
281 	//        < pz20R8c5qB1m6jFMA3q19mcLiHZ0SWyh7n49u00eR61a3q37a30dPha3U0LlCs58 >									
282 	//        <  u =="0.000000000000000001" : ] 000000676805896.304523000000000000 ; 000000705968597.784051000000000000 ] >									
283 	//        < 0x00000000000000000000000000000000000000000000000000408B94E43538FC >									
284 	//     < RUSS_PFXXIX_III_metadata_line_28_____AKVAMARIN_20251101 >									
285 	//        < 6rxPhFMO7lPP7oA4N2g7RLfNT6qy64AseM49E88784CeWYq9o68F936c2CwzZDBg >									
286 	//        <  u =="0.000000000000000001" : ] 000000705968597.784051000000000000 ; 000000725145315.702916000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000043538FC4527BE4 >									
288 	//     < RUSS_PFXXIX_III_metadata_line_29_____INVEST_POLIS_20251101 >									
289 	//        < R00ulStGibjt8q4YqSHvXL0xN8uHfz050w4256h1IS7GGyfnjOvtD6DN3Ist4ZFW >									
290 	//        <  u =="0.000000000000000001" : ] 000000725145315.702916000000000000 ; 000000753770774.713067000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000004527BE447E29B5 >									
292 	//     < RUSS_PFXXIX_III_metadata_line_30_____INGOSSTRAKH_LIFE_INSURANCE_CO_20251101 >									
293 	//        < 11qF64XPdCQz7935TiG6T77YJ8mDnCmK4TZ22ojOQqPy3mzFC7x04B1vA9m8rHu7 >									
294 	//        <  u =="0.000000000000000001" : ] 000000753770774.713067000000000000 ; 000000778008605.198574000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000047E29B54A3259D >									
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
338 	//     < RUSS_PFXXIX_III_metadata_line_31_____SIBAL_gbp_20251101 >									
339 	//        < z6C5r6pm12S137kYlbI0m6goR4Bp4tf308D6N7Bbb8b36z97T8zcE6013n99OILE >									
340 	//        <  u =="0.000000000000000001" : ] 000000778008605.198574000000000000 ; 000000810535749.131085000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000004A3259D4D4C787 >									
342 	//     < RUSS_PFXXIX_III_metadata_line_32_____SIBAL_PENSII_20251101 >									
343 	//        < dsw7wxs85IED2FWI3WJX0XD4eNdmjE1P2EYYPEYFm9upr064uCg5zUaCbePt39xj >									
344 	//        <  u =="0.000000000000000001" : ] 000000810535749.131085000000000000 ; 000000843586355.113046000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000004D4C78750735EC >									
346 	//     < RUSS_PFXXIX_III_metadata_line_33_____SOYUZ_gbp_20251101 >									
347 	//        < SX3XkwSEUP753clkD6s21FZ30j56WSodH94848e0h6c0vg3Lqd3p5FatC81ow696 >									
348 	//        <  u =="0.000000000000000001" : ] 000000843586355.113046000000000000 ; 000000868447424.200800000000000000 ] >									
349 	//        < 0x0000000000000000000000000000000000000000000000000050735EC52D2546 >									
350 	//     < RUSS_PFXXIX_III_metadata_line_34_____SOYUZ_PENSII_20251101 >									
351 	//        < 192pMVYJ17PRoW9mf9ZK63nU4L3CWn47PVi3nJ3xVpKAHw3RDF3pHk773Ko8KNlm >									
352 	//        <  u =="0.000000000000000001" : ] 000000868447424.200800000000000000 ; 000000892352618.798944000000000000 ] >									
353 	//        < 0x0000000000000000000000000000000000000000000000000052D25465519F3E >									
354 	//     < RUSS_PFXXIX_III_metadata_line_35_____PIFAGOR_gbp_20251101 >									
355 	//        < 0Y7LlOTgKmZ97sTItHH6p22AFavV1Jue1R7LrKWX7c9v1D6A3CB8i34Jo52NLyRr >									
356 	//        <  u =="0.000000000000000001" : ] 000000892352618.798944000000000000 ; 000000914925863.558319000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000005519F3E57410EA >									
358 	//     < RUSS_PFXXIX_III_metadata_line_36_____PIFAGOR_PENSII_20251101 >									
359 	//        < 2P40B13j73fDNNv8GDxY175ABQ0u2TN8pZcHe37HP84uSI31A56TUnzmh3BlLPVU >									
360 	//        <  u =="0.000000000000000001" : ] 000000914925863.558319000000000000 ; 000000950443138.291033000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000057410EA5AA42DA >									
362 	//     < RUSS_PFXXIX_III_metadata_line_37_____AKVAMARIN_gbp_20251101 >									
363 	//        < 6IM2lUoimWx1MEG3tVhya21a6m3eQ7s7875q9WC5DXw82x491UXI2MI5coaGkafg >									
364 	//        <  u =="0.000000000000000001" : ] 000000950443138.291033000000000000 ; 000000972358615.737720000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000005AA42DA5CBB396 >									
366 	//     < RUSS_PFXXIX_III_metadata_line_38_____AKVAMARIN_PENSII_20251101 >									
367 	//        < 5lF6oe81oFY6XY7830kzANrBa15m438GR2fl2Q2r53X70SM5c6BUi86H4nlhy6sE >									
368 	//        <  u =="0.000000000000000001" : ] 000000972358615.737720000000000000 ; 000001006701893.757880000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000005CBB3966001AED >									
370 	//     < RUSS_PFXXIX_III_metadata_line_39_____POLIS_gbp_20251101 >									
371 	//        < W0GPF4WPgZVVR5r8Jy6ghx91nfdnOOync98OlT16fb4KRYol4eT41sJc96093J9F >									
372 	//        <  u =="0.000000000000000001" : ] 000001006701893.757880000000000000 ; 000001033585234.484540000000000000 ] >									
373 	//        < 0x000000000000000000000000000000000000000000000000006001AED629203B >									
374 	//     < RUSS_PFXXIX_III_metadata_line_40_____POLIS_PENSII_20251101 >									
375 	//        < JL41751CLvK2jjvI3S53LoPi0WptB8jKfrQfkY0STeqKn18378Qm9D2ep815hcw2 >									
376 	//        <  u =="0.000000000000000001" : ] 000001033585234.484540000000000000 ; 000001062738178.999180000000000000 ] >									
377 	//        < 0x00000000000000000000000000000000000000000000000000629203B6559C1A >									
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