1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	AZOV_PFII_II_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	AZOV_PFII_II_883		"	;
8 		string	public		symbol =	"	AZOV_PFII_II_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1111554565905540000000000000					;	
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
92 	//     < AZOV_PFII_II_metadata_line_1_____Td_Yug_Rusi_20231101 >									
93 	//        < Y7ylR6COm2MgQ0H7542JG8V6zaXiPU9zpyi5G187CNIf0I3Wur7sD5R03rWf20qS >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000024232775.969419900000000000 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000000024F9EE >									
96 	//     < AZOV_PFII_II_metadata_line_2_____LLC_MEZ_Yug_Rusi_20231101 >									
97 	//        < KQy6oX22982IUbkX7OR6T46sq54m3dd2h1RXgmKe7rbH1fY5S4CXnMWmwulx2nXv >									
98 	//        <  u =="0.000000000000000001" : ] 000000024232775.969419900000000000 ; 000000051122495.647172400000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000024F9EE4E01BA >									
100 	//     < AZOV_PFII_II_metadata_line_3_____savola_foods_cis_20231101 >									
101 	//        < 3t5c6FoIJ3qhnQD2kHqvVDIW2BuZDa4756ojX5w99z6Eb4DFeSiyIxLtPcO80lbp >									
102 	//        <  u =="0.000000000000000001" : ] 000000051122495.647172400000000000 ; 000000070037722.060565600000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000004E01BA6ADE7C >									
104 	//     < AZOV_PFII_II_metadata_line_4_____labinsky_cannery_20231101 >									
105 	//        < 0vY479B1821uZsh72vpLPArdsjG68cfDvEWNSfp38023kp975Mmwg9TsqCLijHLM >									
106 	//        <  u =="0.000000000000000001" : ] 000000070037722.060565600000000000 ; 000000099705006.618981900000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000006ADE7C982345 >									
108 	//     < AZOV_PFII_II_metadata_line_5_____jsc_chernyansky_vegetable_oil_plant_20231101 >									
109 	//        < 56GK59rRWDCr5gRhR5L28sP0C93EMErDIX2h0oP8HA4AoG89mFm9s8796dYpG07B >									
110 	//        <  u =="0.000000000000000001" : ] 000000099705006.618981900000000000 ; 000000121779170.746487000000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000982345B9D1FD >									
112 	//     < AZOV_PFII_II_metadata_line_6_____urazovsky_elevator_jsc_20231101 >									
113 	//        < 5damdpE9u7afsDXEu3QcN21oZ512MqG6fZYslGp7T77227t8KzH4Lgn9391NgAj1 >									
114 	//        <  u =="0.000000000000000001" : ] 000000121779170.746487000000000000 ; 000000166898839.740828000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000B9D1FDFEAADC >									
116 	//     < AZOV_PFII_II_metadata_line_7_____ooo_orskmelprom_20231101 >									
117 	//        < my6KzLbr1hVL736Lm152siHrE351o9sMfHB1N8RcR0Il04WnFQ1BS2XK2eNa48Tk >									
118 	//        <  u =="0.000000000000000001" : ] 000000166898839.740828000000000000 ; 000000189092641.806765000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000000FEAADC1208850 >									
120 	//     < AZOV_PFII_II_metadata_line_8_____zolotaya_semechka_ooo_20231101 >									
121 	//        < 2Qx8hG3Bai64j96xak3GX3i8fD0zh46JtcpuyttPKV9y7ord767fFFa22P3g3Szn >									
122 	//        <  u =="0.000000000000000001" : ] 000000189092641.806765000000000000 ; 000000231393161.966597000000000000 ] >									
123 	//        < 0x00000000000000000000000000000000000000000000000000120885016113F4 >									
124 	//     < AZOV_PFII_II_metadata_line_9_____ooo_grain_union_20231101 >									
125 	//        < 4NBLzJUe34Hd1PBJdb0767UL7u3ROcnSB7nQBvuNI5B0pp021iizAo6G0pqo4wBh >									
126 	//        <  u =="0.000000000000000001" : ] 000000231393161.966597000000000000 ; 000000263324892.516756000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000016113F4191CD49 >									
128 	//     < AZOV_PFII_II_metadata_line_10_____valuysky_vegetable_oil_plant_20231101 >									
129 	//        < 8JWCAmm4U1zp7j8nj1qf8T01wdH7vDV9sFRid9FmKOO6Dmy9zEe0gXwV82WUhthv >									
130 	//        <  u =="0.000000000000000001" : ] 000000263324892.516756000000000000 ; 000000285085961.767028000000000000 ] >									
131 	//        < 0x00000000000000000000000000000000000000000000000000191CD491B301B4 >									
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
174 	//     < AZOV_PFII_II_metadata_line_11_____ooo_yugagro_leasing_20231101 >									
175 	//        < 1U0K9Hdwe1DjOg7A88J46NDFVHiMe8l8vSJ57zGaHB989Y7S8Gdj893KWYowpznf >									
176 	//        <  u =="0.000000000000000001" : ] 000000285085961.767028000000000000 ; 000000318913690.571486000000000000 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000000001B301B41E69FA9 >									
178 	//     < AZOV_PFII_II_metadata_line_12_____torgovy_dom_yug_rusi_ooo_20231101 >									
179 	//        < j3gW9VA1WQ43Vm96Hmec8bzHZH2l68YGH59Hu8bPiigCl488jOX47mQhc2j1wMAn >									
180 	//        <  u =="0.000000000000000001" : ] 000000318913690.571486000000000000 ; 000000343595476.674746000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000001E69FA920C48FC >									
182 	//     < AZOV_PFII_II_metadata_line_13_____trading_house_wj_cis_20231101 >									
183 	//        < LYmas41AqxZA1wG94rSd5GFd6IzR1EGdxie766eRl67Dh6eZ4uJp4P4M51sf13NJ >									
184 	//        <  u =="0.000000000000000001" : ] 000000343595476.674746000000000000 ; 000000385654612.006987000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000020C48FC24C7655 >									
186 	//     < AZOV_PFII_II_metadata_line_14_____ojsc_tselinkhlebprodukt_20231101 >									
187 	//        < WWCPf8z64NeEETNVd5gqTA8Bn65fcOL1L1jLS9R4g6JlA4z9B8m043MqGLGUAHTD >									
188 	//        <  u =="0.000000000000000001" : ] 000000385654612.006987000000000000 ; 000000407054220.126794000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000024C765526D1D8E >									
190 	//     < AZOV_PFII_II_metadata_line_15_____ooo_orskaya_pasta_factory_20231101 >									
191 	//        < l77oKlF2oL45M2G4R8ULWqacI239Y9hH96936367N93gvN2KAod812eGt6Ntvyhj >									
192 	//        <  u =="0.000000000000000001" : ] 000000407054220.126794000000000000 ; 000000433589794.900725000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000026D1D8E2959B03 >									
194 	//     < AZOV_PFII_II_metadata_line_16_____Azs Yug Rusi_20231101 >									
195 	//        < 4Cv9VlSxni9Qv02VcW1XV35Dim77rJZ78xpBnxpl86X3ZX131c27Ng4M2lm175wx >									
196 	//        <  u =="0.000000000000000001" : ] 000000433589794.900725000000000000 ; 000000475377999.349242000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000002959B032D55E88 >									
198 	//     < AZOV_PFII_II_metadata_line_17_____Bina_grup_20231101 >									
199 	//        < ho95Jr6Y5AqvDl0UEp7r2Devdyg8lS7qfE6Ih04Ki6e65AcmXj6JTQY2s8Yn98Hn >									
200 	//        <  u =="0.000000000000000001" : ] 000000475377999.349242000000000000 ; 000000522031435.931234000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000002D55E8831C8E88 >									
202 	//     < AZOV_PFII_II_metadata_line_18_____BINA_INTEGRATED_TECHNOLOGY_SDN_BHD_20231101 >									
203 	//        < cGorZawlYkAB7Z9agU9wUSea1aG498k76JqKToU0lMX6B4B2M82OKPhm7m7iX80v >									
204 	//        <  u =="0.000000000000000001" : ] 000000522031435.931234000000000000 ; 000000544901026.850364000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000031C8E8833F73F7 >									
206 	//     < AZOV_PFII_II_metadata_line_19_____BINA_INTEGRATED_INDUSTRIES_SDN_BHD_20231101 >									
207 	//        < topVDAa4al60cFD5u84OolD4zJq3R3e5S1h1YdFb3b5o8O43242Ru8DygF9vipS1 >									
208 	//        <  u =="0.000000000000000001" : ] 000000544901026.850364000000000000 ; 000000575515523.514171000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000000033F73F736E2AC0 >									
210 	//     < AZOV_PFII_II_metadata_line_20_____BINA_PAINT_MARKETING_SDN_BHD_20231101 >									
211 	//        < M36u7YNDJ22XmkRIyLg7d282DTIjuOM1OmMm566SKX8Y247PuPCUeQH97OB27J35 >									
212 	//        <  u =="0.000000000000000001" : ] 000000575515523.514171000000000000 ; 000000612463795.257609000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000036E2AC03A68BAC >									
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
256 	//     < AZOV_PFII_II_metadata_line_21_____Yevroplast_20231101 >									
257 	//        < 4DY65l6Gh6968o1uCVc1mX7VdsU2NX35A6XqLE2grRw737w8jq3W6d7F3sTIQ8q9 >									
258 	//        <  u =="0.000000000000000001" : ] 000000612463795.257609000000000000 ; 000000632891629.531270000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000003A68BAC3C5B74B >									
260 	//     < AZOV_PFII_II_metadata_line_22_____Grain_export_infrastructure_org_20231101 >									
261 	//        < oC7q7RoVbr7nnk46K3KalpCE5gn61lH65u1KuObewtwP0G116s0K872TMO5dkeoe >									
262 	//        <  u =="0.000000000000000001" : ] 000000632891629.531270000000000000 ; 000000664604067.477923000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000003C5B74B3F61AF7 >									
264 	//     < AZOV_PFII_II_metadata_line_23_____Kherson_Port_org_20231101 >									
265 	//        < OpypFV3JuzW274p06Of656zJ4B4Yo91KEpkAb6f01224t87zXQ9Z4NYm3Ot5a9I7 >									
266 	//        <  u =="0.000000000000000001" : ] 000000664604067.477923000000000000 ; 000000705493307.142781000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000003F61AF74347F53 >									
268 	//     < AZOV_PFII_II_metadata_line_24_____Donskoy_Tabak_20231101 >									
269 	//        < v1ecNw8NN19l087DaAV9m8WeIeX8Ppt1wdVY9eW7Snjq6OY3LDfqdHdc71Isel1y >									
270 	//        <  u =="0.000000000000000001" : ] 000000705493307.142781000000000000 ; 000000725393040.752823000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000004347F53452DCA8 >									
272 	//     < AZOV_PFII_II_metadata_line_25_____Japan_Tobacco_International_20231101 >									
273 	//        < lfpeAmu6lnOn1ZftiIcIw660E4wuGv52d1B962t250t29206Hnlwv20G50R2lxjt >									
274 	//        <  u =="0.000000000000000001" : ] 000000725393040.752823000000000000 ; 000000744296703.140597000000000000 ] >									
275 	//        < 0x00000000000000000000000000000000000000000000000000452DCA846FB4E6 >									
276 	//     < AZOV_PFII_II_metadata_line_26_____Akhra_2006_20231101 >									
277 	//        < 5R0RjcvtNXrd3b8uR45fmFWfM28M4wA01p4Rry563F6V52kClSLcQr0JRtH6766v >									
278 	//        <  u =="0.000000000000000001" : ] 000000744296703.140597000000000000 ; 000000791120657.435997000000000000 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000000000046FB4E64B72782 >									
280 	//     < AZOV_PFII_II_metadata_line_27_____Sekap_SA_20231101 >									
281 	//        < l38Yyi032BE3h8cW6wQL1Cu3iUY5EyoZXH7m1iZ3RI4S6H336T2HBpvlXd8s38zE >									
282 	//        <  u =="0.000000000000000001" : ] 000000791120657.435997000000000000 ; 000000823741678.953094000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000004B727824E8EE18 >									
284 	//     < AZOV_PFII_II_metadata_line_28_____jt_international_korea_inc_20231101 >									
285 	//        < Gc8DKgjNe1V76WK7oWs6DQ60ecYOmrH04WpzYPyxD6ZR160W7QX6DdZj3v0ImUNz >									
286 	//        <  u =="0.000000000000000001" : ] 000000823741678.953094000000000000 ; 000000852975481.869905000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000004E8EE18515898C >									
288 	//     < AZOV_PFII_II_metadata_line_29_____tanzania_cigarette_company_20231101 >									
289 	//        < 2p923g9u392215IG44C8gC2tQId88W0NdW6HQzA9N2v4ZL341hZ7iR73yJxHbhPf >									
290 	//        <  u =="0.000000000000000001" : ] 000000852975481.869905000000000000 ; 000000876090337.917131000000000000 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000000000515898C538CECA >									
292 	//     < AZOV_PFII_II_metadata_line_30_____jt_international_holding_bv_20231101 >									
293 	//        < kd1wCTzlJqWTatQ3r3W282fhEiLZ71i88zC42xe409a6916aPg2EC5V2Ouoa52cq >									
294 	//        <  u =="0.000000000000000001" : ] 000000876090337.917131000000000000 ; 000000897433997.953125000000000000 ] >									
295 	//        < 0x00000000000000000000000000000000000000000000000000538CECA5596028 >									
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
338 	//     < AZOV_PFII_II_metadata_line_31_____kannenberg_barker_hail_cotton_tabacos_ltda_20231101 >									
339 	//        < Vi8z6a325Wh0NIuvNap3kwkLY822CxvM2vVkvozgLf0oO47X915b68J4uw9L2CGJ >									
340 	//        <  u =="0.000000000000000001" : ] 000000897433997.953125000000000000 ; 000000922425833.339983000000000000 ] >									
341 	//        < 0x00000000000000000000000000000000000000000000000000559602857F8297 >									
342 	//     < AZOV_PFII_II_metadata_line_32_____jt_international_iberia_sl_20231101 >									
343 	//        < axty1cGqPD4s3JUzI5o372dXlnxXz4r6j18pL1R8j5gmS7tbA5ofxg3mCwlI0e9Z >									
344 	//        <  u =="0.000000000000000001" : ] 000000922425833.339983000000000000 ; 000000947727031.708146000000000000 ] >									
345 	//        < 0x0000000000000000000000000000000000000000000000000057F82975A61DDF >									
346 	//     < AZOV_PFII_II_metadata_line_33_____jt_international_company_netherlands_bv_20231101 >									
347 	//        < 6ud5vA7538Lv2ISAtyzqf5515f7F3EMKnZTtzz22N44N1kI8BjKVi9fzB0VGnBI3 >									
348 	//        <  u =="0.000000000000000001" : ] 000000947727031.708146000000000000 ; 000000965158615.773311000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000005A61DDF5C0B716 >									
350 	//     < AZOV_PFII_II_metadata_line_34_____Gryson_nv_20231101 >									
351 	//        < TQhw0QV0mXK9L88jfT9AhJW7Ylx2qU0A8H4Ua9eL25qhDjm48EvCVYS30O0e56o4 >									
352 	//        <  u =="0.000000000000000001" : ] 000000965158615.773311000000000000 ; 000000981904477.217685000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000005C0B7165DA4470 >									
354 	//     < AZOV_PFII_II_metadata_line_35_____duvanska_industrija_senta_20231101 >									
355 	//        < KC76vTnJl401Zc9ugtBU30gSsHldzd0V89A483dSqi8AZqrrbgk14c00Hc82Ao1r >									
356 	//        <  u =="0.000000000000000001" : ] 000000981904477.217685000000000000 ; 000001001442559.993730000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000005DA44705F81480 >									
358 	//     < AZOV_PFII_II_metadata_line_36_____kannenberg_cia_ltda_20231101 >									
359 	//        < TLQ11ZX72S1sKUO04VU032NXOoLVD80a2Hj78nlCu825WxiWDSiB9TWQI7n0VJqZ >									
360 	//        <  u =="0.000000000000000001" : ] 000001001442559.993730000000000000 ; 000001017985328.534820000000000000 ] >									
361 	//        < 0x000000000000000000000000000000000000000000000000005F814806115285 >									
362 	//     < AZOV_PFII_II_metadata_line_37_____jti_leaf_services_us_llc_20231101 >									
363 	//        < r1VY88TNRvXli0498B5T0KlY1942kk609q24ppEY1mD63IwLe6QnfxH6veJv8Ylw >									
364 	//        <  u =="0.000000000000000001" : ] 000001017985328.534820000000000000 ; 000001034115658.327840000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000006115285629EF6E >									
366 	//     < AZOV_PFII_II_metadata_line_38_____cigarros_la_tabacalera_mexicana_sa_cv_20231101 >									
367 	//        < gelwsktRiPYw7My5sdsRuHZFo6JWK7KcZer76WP9S2j7tF421j9h0d0Yq7l58EqS >									
368 	//        <  u =="0.000000000000000001" : ] 000001034115658.327840000000000000 ; 000001050497903.964440000000000000 ] >									
369 	//        < 0x00000000000000000000000000000000000000000000000000629EF6E642EEBE >									
370 	//     < AZOV_PFII_II_metadata_line_39_____jti_pars_pjsco_20231101 >									
371 	//        < pk6Ql060FNiR40QV0w9TAg0d8WU1IYR360b6Bb829lD4zMfNthyn9a9A58wx0Joz >									
372 	//        <  u =="0.000000000000000001" : ] 000001050497903.964440000000000000 ; 000001080725506.560070000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000642EEBE6710E67 >									
374 	//     < AZOV_PFII_II_metadata_line_40_____jti_uk_finance_limited_20231101 >									
375 	//        < 43iMZvXBdp25M9k03R0gGGKI63vtSP7HgzaXF7NMnVeVee9f3L855hsOF21Xvkl6 >									
376 	//        <  u =="0.000000000000000001" : ] 000001080725506.560070000000000000 ; 000001111554565.905540000000000000 ] >									
377 	//        < 0x000000000000000000000000000000000000000000000000006710E676A01901 >									
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