1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	AZOV_PFI_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	AZOV_PFI_I_883		"	;
8 		string	public		symbol =	"	AZOV_PFI_I_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		748829927887310000000000000					;	
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
92 	//     < AZOV_PFI_I_metadata_line_1_____Berdyansk_org_20211101 >									
93 	//        < 8MuCwK1oI9bmP8TDQ2gyaPPNHOwp13xIkV8q5fTsXc0bQyDqSSc8e8mo30yzJC47 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000021111514.938209500000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000002036AF >									
96 	//     < AZOV_PFI_I_metadata_line_2_____Zaporizhia_org_20211101 >									
97 	//        < R8HVYyuz2aV5Sl7S9708uU0Mw568PZXuFIwd9A4k6XxSxY13FSZuZ0by0R74NtBG >									
98 	//        <  u =="0.000000000000000001" : ] 000000021111514.938209500000000000 ; 000000038162557.172502400000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000002036AF3A3B40 >									
100 	//     < AZOV_PFI_I_metadata_line_3_____Berdiansk_Commercial_Sea_Port_20211101 >									
101 	//        < N1wH3Q55ywZMw9c861283Fj8JEoJl14po37I0H19HnLjLJm7t3QN1ul90f3R034P >									
102 	//        <  u =="0.000000000000000001" : ] 000000038162557.172502400000000000 ; 000000054589340.591039300000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000003A3B40534BF6 >									
104 	//     < AZOV_PFI_I_metadata_line_4_____Soylu_Group_20211101 >									
105 	//        < 68yX4064s037ZQz2Zb6m5KvYdb0HrN8gOi8c82RM2R1L89d5lKNfNVo6YYIAzMRH >									
106 	//        <  u =="0.000000000000000001" : ] 000000054589340.591039300000000000 ; 000000075152169.353455400000000000 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000000000534BF672AC51 >									
108 	//     < AZOV_PFI_I_metadata_line_5_____Soylu_Group_TRK_20211101 >									
109 	//        < 7hIYW3CGVue4k0n5P49X79itGjYv07aX1ph2gh8R74qSA7Z9Y1S3c3B70m0xy87H >									
110 	//        <  u =="0.000000000000000001" : ] 000000075152169.353455400000000000 ; 000000097200672.756305300000000000 ] >									
111 	//        < 0x000000000000000000000000000000000000000000000000000072AC51945103 >									
112 	//     < AZOV_PFI_I_metadata_line_6_____Ulusoy Holding_20211101 >									
113 	//        < p9apgtg81J33wmRGz8EaF720J9It505hZF2Y31YQbc4QhTi1TPEm7km0fNOTsNor >									
114 	//        <  u =="0.000000000000000001" : ] 000000097200672.756305300000000000 ; 000000119135504.217390000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000945103B5C94E >									
116 	//     < AZOV_PFI_I_metadata_line_7_____Berdyansk_Sea_Trading_Port_20211101 >									
117 	//        < 0bNzFNUysKlmufuFw3wpeq9erlPiXd5sjU2nir5Az4UM1igW476Auv66864Dti99 >									
118 	//        <  u =="0.000000000000000001" : ] 000000119135504.217390000000000000 ; 000000142984189.264301000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000B5C94EDA2D33 >									
120 	//     < AZOV_PFI_I_metadata_line_8_____Marioupol_org_20211101 >									
121 	//        < rm8G4pcfDE3mxsg6TteZ8sh553k11Fp0l5Pg6CgF9g5pO4gAdl72oPFM532n26TX >									
122 	//        <  u =="0.000000000000000001" : ] 000000142984189.264301000000000000 ; 000000156782106.179160000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000DA2D33EF3B03 >									
124 	//     < AZOV_PFI_I_metadata_line_9_____Donetsk_org_20211101 >									
125 	//        < oTrh5Z3rrfIswd5DU1ZJG5c0WiU5wfKVbavF1u67XHqh447u5DIT0skDezyefwne >									
126 	//        <  u =="0.000000000000000001" : ] 000000156782106.179160000000000000 ; 000000175097334.921343000000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000000EF3B0310B2D65 >									
128 	//     < AZOV_PFI_I_metadata_line_10_____Marioupol_Port_Station_20211101 >									
129 	//        < ve1X7O3M2VSdFnEmm81vjt34tfZ41bB6s487Wo654zJa489djUtJ7ZUIM038CVT7 >									
130 	//        <  u =="0.000000000000000001" : ] 000000175097334.921343000000000000 ; 000000196393403.706586000000000000 ] >									
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
174 	//     < AZOV_PFI_I_metadata_line_11_____Yeysk_org_20211101 >									
175 	//        < garJumg0SBjeMOfrMi6yUb25e3Jficq1iJ4pv6U27A2RTP9Ja1os4ndzbSKS965p >									
176 	//        <  u =="0.000000000000000001" : ] 000000196393403.706586000000000000 ; 000000209419937.442413000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000012BAC2C13F8CAA >									
178 	//     < AZOV_PFI_I_metadata_line_12_____Krasnodar_org_20211101 >									
179 	//        < qGJeFZx91mv3008waexSlvrS03bxzCh9IsrdidN11sz16Q5Y2CAJkdW2dYhD8jyM >									
180 	//        <  u =="0.000000000000000001" : ] 000000209419937.442413000000000000 ; 000000230361163.443239000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000013F8CAA15F80D4 >									
182 	//     < AZOV_PFI_I_metadata_line_13_____Yeysk_Airport_20211101 >									
183 	//        < 8x4DHVmeiFNU894Rc0i2062MIhl85B7Ahi8m84tHb06I2Y68BG71f0BIG78obkgr >									
184 	//        <  u =="0.000000000000000001" : ] 000000230361163.443239000000000000 ; 000000246681399.921515000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000015F80D417867EC >									
186 	//     < AZOV_PFI_I_metadata_line_14_____Kerch_infrastructure_org_20211101 >									
187 	//        < U321pemp8o6hVN34ecB0qg5RVIO1RnsmJo1d4imwSPQ5D3s3N6XmTuJFVkc6vOF9 >									
188 	//        <  u =="0.000000000000000001" : ] 000000246681399.921515000000000000 ; 000000266404259.210039000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000017867EC196802A >									
190 	//     < AZOV_PFI_I_metadata_line_15_____Kerch_Seaport_org_20211101 >									
191 	//        < yCc6rr8s0cBVzuph9s6ylNBP21rcPbZm78ErIJMdwYPCb4tzl6R8AFQAugmL72ij >									
192 	//        <  u =="0.000000000000000001" : ] 000000266404259.210039000000000000 ; 000000282106984.206843000000000000 ] >									
193 	//        < 0x00000000000000000000000000000000000000000000000000196802A1AE760A >									
194 	//     < AZOV_PFI_I_metadata_line_16_____Azov_org_20211101 >									
195 	//        < c7nd58VY5rmWdQT4hMaA7gXw2i1UDU022LHU7E5Dtv4dH2oQ4cGasnmv7tuBC7O3 >									
196 	//        <  u =="0.000000000000000001" : ] 000000282106984.206843000000000000 ; 000000307052825.643136000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000001AE760A1D48683 >									
198 	//     < AZOV_PFI_I_metadata_line_17_____Azov_Seaport_org_20211101 >									
199 	//        < v9o9PSYNX7dU03T2r46D8pqsdU5igmZ4i9P17311B3Y40s586gd6y9HNKtg6VV09 >									
200 	//        <  u =="0.000000000000000001" : ] 000000307052825.643136000000000000 ; 000000329265677.709274000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000001D486831F66B68 >									
202 	//     < AZOV_PFI_I_metadata_line_18_____Azovskiy_Portovyy_Elevator_20211101 >									
203 	//        < 2zgN1Pg5TIF8430vOP6wIq2DwiwFI3X4TUiq12sD64HKrqmN1qAh5apFLa88SR57 >									
204 	//        <  u =="0.000000000000000001" : ] 000000329265677.709274000000000000 ; 000000348468911.629219000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000001F66B68213B8AB >									
206 	//     < AZOV_PFI_I_metadata_line_19_____Rostov_SLD_org_20211101 >									
207 	//        < dJqX15tG1E8k91p0j1Q4nZP6l8KXSkq5tkAdQ1t1TJE5La7v3RjN1CFEQ7046ahG >									
208 	//        <  u =="0.000000000000000001" : ] 000000348468911.629219000000000000 ; 000000363687867.924701000000000000 ] >									
209 	//        < 0x00000000000000000000000000000000000000000000000000213B8AB22AF193 >									
210 	//     < AZOV_PFI_I_metadata_line_20_____Rentastroy_20211101 >									
211 	//        < 0hrLLFELUW5Mn4WM9d43D6xn55fj5O7H2JgVU8Jv38lgNsd7kKGSeFM37LNho485 >									
212 	//        <  u =="0.000000000000000001" : ] 000000363687867.924701000000000000 ; 000000381189688.951240000000000000 ] >									
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
256 	//     < AZOV_PFI_I_metadata_line_21_____Moscow_Industrial_Bank_20211101 >									
257 	//        < XoM5UKczwHt8YEV4e6QxgXVw003L0XnnS8EpIu2OX7X37T56vH2SvFyZKMvI14y0 >									
258 	//        <  u =="0.000000000000000001" : ] 000000381189688.951240000000000000 ; 000000395625799.021174000000000000 ] >									
259 	//        < 0x00000000000000000000000000000000000000000000000000245A63925BAD54 >									
260 	//     < AZOV_PFI_I_metadata_line_22_____Donmasloprodukt_20211101 >									
261 	//        < 2rrFYz8I9181tx0R906c5z7SZC6ePzr7jR5A2q4cYhdW9ZrQuOBLnuMb2fRdiz74 >									
262 	//        <  u =="0.000000000000000001" : ] 000000395625799.021174000000000000 ; 000000410359285.380806000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000025BAD542722899 >									
264 	//     < AZOV_PFI_I_metadata_line_23_____Rostovskiy_Portovyy_Elevator_Kovsh_20211101 >									
265 	//        < C8mrLyU34oWpwyP4oNoR8r15z4ag6mbqH6Bf7i6I8t3aoJxsp0T07D7rW7E1KRf5 >									
266 	//        <  u =="0.000000000000000001" : ] 000000410359285.380806000000000000 ; 000000433967105.683431000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000027228992962E67 >									
268 	//     < AZOV_PFI_I_metadata_line_24_____Rostov_Arena_infratructure_org_20211101 >									
269 	//        < ml53tuGw95S0UHcIjGju78a2Nvu6svRQpZaoCsFMj7V6h25de5Ot9b9B7l9DcYkO >									
270 	//        <  u =="0.000000000000000001" : ] 000000433967105.683431000000000000 ; 000000455403714.659337000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000002962E672B6E413 >									
272 	//     < AZOV_PFI_I_metadata_line_25_____Rostov_Glavny_infrastructure_org_20211101 >									
273 	//        < E21DMXAS629s33GAfn5sKXe913MS4Ov75TYQd8D6sOH556T3u07j7YU47SLLO38v >									
274 	//        <  u =="0.000000000000000001" : ] 000000455403714.659337000000000000 ; 000000469436088.495443000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002B6E4132CC4D79 >									
276 	//     < AZOV_PFI_I_metadata_line_26_____Rostov_Heliport_infrastructure_org_20211101 >									
277 	//        < iIbqD9XEcnbd5GrgohDIGAyV5zbj57F1QjB01gV0Glhzr0280TXBdS4AnR5d0h5v >									
278 	//        <  u =="0.000000000000000001" : ] 000000469436088.495443000000000000 ; 000000491836032.818026000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000002CC4D792EE7B73 >									
280 	//     < AZOV_PFI_I_metadata_line_27_____Taganrog_org_20211101 >									
281 	//        < XGbTd6B5Lq0ZOMJZ8v33SdWe3297wF0t6W01E3h7H7239DowC04m6ihKTa11Rc0B >									
282 	//        <  u =="0.000000000000000001" : ] 000000491836032.818026000000000000 ; 000000505151665.920526000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000002EE7B73302CCDF >									
284 	//     < AZOV_PFI_I_metadata_line_28_____Rostov_Airport_org_20211101 >									
285 	//        < N88c0J35O3hSc145mwg3N6RI40BVSI5lZSxfd9u8vuNtnZ3s3Om0Zn1jjVE3g9y7 >									
286 	//        <  u =="0.000000000000000001" : ] 000000505151665.920526000000000000 ; 000000526836175.653769000000000000 ] >									
287 	//        < 0x00000000000000000000000000000000000000000000000000302CCDF323E362 >									
288 	//     < AZOV_PFI_I_metadata_line_29_____Rostov_Airport_infrastructure_org_20211101 >									
289 	//        < 3r5uHHZ1vwH58biOoBHt9olGL7vs3143fw7R2my583HuYTTN4TI4HZMLwi5I5v9I >									
290 	//        <  u =="0.000000000000000001" : ] 000000526836175.653769000000000000 ; 000000546907319.063267000000000000 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000000000323E36234283AC >									
292 	//     < AZOV_PFI_I_metadata_line_30_____Mega_Mall_org_20211101 >									
293 	//        < VE8fF3a9WWtdjD8IbPLddEw5fT3kX4OC0kIZ9sS9A56T5Zvui1J1R20v75K3j8wX >									
294 	//        <  u =="0.000000000000000001" : ] 000000546907319.063267000000000000 ; 000000567394140.009299000000000000 ] >									
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
338 	//     < AZOV_PFI_I_metadata_line_31_____Mir_Remonta_org_20211101 >									
339 	//        < kvvN8iX68lalhRGGbG1610NZee74bbvdUygGZbxwil3BkF4153tii8Yhqh04Hlps >									
340 	//        <  u =="0.000000000000000001" : ] 000000567394140.009299000000000000 ; 000000581443589.353980000000000000 ] >									
341 	//        < 0x00000000000000000000000000000000000000000000000000361C6563773667 >									
342 	//     < AZOV_PFI_I_metadata_line_32_____Zemkombank_org_20211101 >									
343 	//        < 3he7T75s10wowIcln2b5wQ6Sn1hFBTwGP4e4xPlQs84ZDd2Y9C462ec2XW67F5hf >									
344 	//        <  u =="0.000000000000000001" : ] 000000581443589.353980000000000000 ; 000000599504783.478249000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000003773667392C58E >									
346 	//     < AZOV_PFI_I_metadata_line_33_____Telebashnya_tv_infrastrcture_org_20211101 >									
347 	//        < CVcR3iTG6Dv1utGHA9k9tSjchlv1m2S1JW4GznRCX0n00IAM148WUiprVk9j6q1Q >									
348 	//        <  u =="0.000000000000000001" : ] 000000599504783.478249000000000000 ; 000000616613368.180384000000000000 ] >									
349 	//        < 0x00000000000000000000000000000000000000000000000000392C58E3ACE099 >									
350 	//     < AZOV_PFI_I_metadata_line_34_____Taman_Volna_infrastructures_industrielles_org_20211101 >									
351 	//        < z7Y8QkxflyAO5J8j0KZPO2Di89wgoeG64y6LDD9xR88C5n9r6HH9948dElMQ7elS >									
352 	//        <  u =="0.000000000000000001" : ] 000000616613368.180384000000000000 ; 000000640451229.079172000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000003ACE0993D14043 >									
354 	//     < AZOV_PFI_I_metadata_line_35_____Yuzhnoye_Siyaniye_ooo_20211101 >									
355 	//        < PSbqbb5K6b0xE4x9bM6Z83rL49m9ThbHk9L932T426Ove5QcBRV8k74BWnp2cu9d >									
356 	//        <  u =="0.000000000000000001" : ] 000000640451229.079172000000000000 ; 000000655317480.465488000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000003D140433E7EF64 >									
358 	//     < AZOV_PFI_I_metadata_line_36_____Port_Krym_org_20211101 >									
359 	//        < pGL1wTWXcs4cFIzu7Y6GxC9fi59Mp4tl1Vsn5O5Vl2rI0xV4584cJbbR9wb1R2v6 >									
360 	//        <  u =="0.000000000000000001" : ] 000000655317480.465488000000000000 ; 000000675138804.932873000000000000 ] >									
361 	//        < 0x000000000000000000000000000000000000000000000000003E7EF644062E18 >									
362 	//     < AZOV_PFI_I_metadata_line_37_____Kerchenskaya_équipements_maritimes_20211101 >									
363 	//        < x0mvc2eq7cZeTpIR6NoYKz6Jo30j8m3K91lSWfJ8IjB2v7uxka5r3cwiX4938zz3 >									
364 	//        <  u =="0.000000000000000001" : ] 000000675138804.932873000000000000 ; 000000692082994.291000000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000004062E1842008EB >									
366 	//     < AZOV_PFI_I_metadata_line_38_____Kerchenskaya_ferry_20211101 >									
367 	//        < wGgKl0T8W349q73WraE0MZt0JHW9yMEEpXII5o4VzQn6b9unY4O6O9QhUdO0193v >									
368 	//        <  u =="0.000000000000000001" : ] 000000692082994.291000000000000000 ; 000000707693119.744165000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000042008EB437DAA0 >									
370 	//     < AZOV_PFI_I_metadata_line_39_____Kerch_Port_Krym_20211101 >									
371 	//        < ACv0I01O9wQEbaD6C91RS44095yUhKUWAsCHJglAhRCBMlgFgyr40nLJWu7vz7b6 >									
372 	//        <  u =="0.000000000000000001" : ] 000000707693119.744165000000000000 ; 000000724737953.330201000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000437DAA0451DCC3 >									
374 	//     < AZOV_PFI_I_metadata_line_40_____Krym_Station_infrastructure_ferroviaire_org_20211101 >									
375 	//        < Y3SY7nBP6u0T1Oz22F0382oOHq64c2yDeaSmxhE9Ppg8549V25ZdoelOOIQyHXg1 >									
376 	//        <  u =="0.000000000000000001" : ] 000000724737953.330201000000000000 ; 000000748829927.887310000000000000 ] >									
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