1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	NDRV_PFVII_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	NDRV_PFVII_I_883		"	;
8 		string	public		symbol =	"	NDRV_PFVII_I_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		756107420564358000000000000					;	
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
92 	//     < NDRV_PFVII_I_metadata_line_1_____Hannover Re_20211101 >									
93 	//        < c5br4GhSHgiu46MmLTz19moCb9l58l9fi2T27160scyP1lM70sDiwiSb7sr95F5e >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000023019861.846765200000000000 ] >									
95 	//        < 0x0000000000000000000000000000000000000000000000000000000000232022 >									
96 	//     < NDRV_PFVII_I_metadata_line_2_____Hannover Reinsurance Ireland Ltd_20211101 >									
97 	//        < D7XSB64t0zKokRayXbGA95G51Q57446T4KTW30D9y23wj4449sS1t73zwL2DuG1w >									
98 	//        <  u =="0.000000000000000001" : ] 000000023019861.846765200000000000 ; 000000045530114.468847200000000000 ] >									
99 	//        < 0x0000000000000000000000000000000000000000000000000000232022457933 >									
100 	//     < NDRV_PFVII_I_metadata_line_3_____975 Carroll Square Llc_20211101 >									
101 	//        < GmS11WMhtEWllPT2m3f5SM9092yQ7t7Jq1b4l8tPs669MKSkHf3vIlGy7hSmX7L1 >									
102 	//        <  u =="0.000000000000000001" : ] 000000045530114.468847200000000000 ; 000000063739540.408119500000000000 ] >									
103 	//        < 0x0000000000000000000000000000000000000000000000000000457933614242 >									
104 	//     < NDRV_PFVII_I_metadata_line_4_____Caroll_Holdings_20211101 >									
105 	//        < A0Wyd51Q8Bv401mm84Xqu08OAjOeOZ036HV0dPZH0V9sCu6fTJqQGs0J6wguer8J >									
106 	//        <  u =="0.000000000000000001" : ] 000000063739540.408119500000000000 ; 000000081330605.462984200000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000006142427C19C5 >									
108 	//     < NDRV_PFVII_I_metadata_line_5_____Skandia Versicherung Management & Service Gmbh_20211101 >									
109 	//        < O6N1136Ho75e9jA0db9aecM8h52w6dJfW53q7y9Yhv6p6U921Y6UH7F02zDXWI5A >									
110 	//        <  u =="0.000000000000000001" : ] 000000081330605.462984200000000000 ; 000000098136760.430684600000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000007C19C595BEAC >									
112 	//     < NDRV_PFVII_I_metadata_line_6_____Skandia PortfolioManagement Gmbh, Asset Management Arm_20211101 >									
113 	//        < 3Pz2U7X93Q3XTNR4Rx7md9XIe0S576F2ADT2YdWI4SGAv25Dn72yFRDBrcOuz7Xd >									
114 	//        <  u =="0.000000000000000001" : ] 000000098136760.430684600000000000 ; 000000112695846.638089000000000000 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000000000095BEACABF5D1 >									
116 	//     < NDRV_PFVII_I_metadata_line_7_____Argenta Underwriting No8 Limited_20211101 >									
117 	//        < gMP7Mt41sFhC17T497tgw0v0w9SXcl6rPS756LOn326grh8H0k1PfyYHni8e7ALr >									
118 	//        <  u =="0.000000000000000001" : ] 000000112695846.638089000000000000 ; 000000126038991.328500000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000ABF5D1C051FB >									
120 	//     < NDRV_PFVII_I_metadata_line_8_____Oval Office Grundstücks GmbH_20211101 >									
121 	//        < ueHAuS5R0lxe2a14apOT4D6c9Th0sWGSC2E38jvx90lLa807KPcfWJ043Wnq4i1h >									
122 	//        <  u =="0.000000000000000001" : ] 000000126038991.328500000000000000 ; 000000141702444.004636000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000C051FBD83884 >									
124 	//     < NDRV_PFVII_I_metadata_line_9_____Hannover Rückversicherung AG Asset Management Arm_20211101 >									
125 	//        < I997OG8CI3U9Z0S1lrW45M3uQ4t8dw6ic2iPs8f70mjOstrk9YT040jv50JrhvQ8 >									
126 	//        <  u =="0.000000000000000001" : ] 000000141702444.004636000000000000 ; 000000166092633.790300000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000000D83884FD6FEF >									
128 	//     < NDRV_PFVII_I_metadata_line_10_____Hannover Rueckversicherung Ag Korea Branch_20211101 >									
129 	//        < xkM9cj1r5wGml3RcFjvFRaq87xsjbR92y65U8TL2x59QE2sMP4gsW2K30Rq26MK2 >									
130 	//        <  u =="0.000000000000000001" : ] 000000166092633.790300000000000000 ; 000000183258950.058894000000000000 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000000000FD6FEF117A187 >									
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
174 	//     < NDRV_PFVII_I_metadata_line_11_____Nashville West LLC_20211101 >									
175 	//        < 9ZDMDHQ4560vkWH5GLW4bj0RAwPRfqZ835l6sFP6hknWB8eeP84jatsd404paw98 >									
176 	//        <  u =="0.000000000000000001" : ] 000000183258950.058894000000000000 ; 000000204408536.222121000000000000 ] >									
177 	//        < 0x00000000000000000000000000000000000000000000000000117A187137E716 >									
178 	//     < NDRV_PFVII_I_metadata_line_12_____WRH Offshore High Yield Partners LP_20211101 >									
179 	//        < dqfymKTqOwSyPGyFqOtmD9T1Jo83H571e3n27sN673oP3AdAaV6SLr71430n3PjG >									
180 	//        <  u =="0.000000000000000001" : ] 000000204408536.222121000000000000 ; 000000225974929.832197000000000000 ] >									
181 	//        < 0x00000000000000000000000000000000000000000000000000137E716158CF75 >									
182 	//     < NDRV_PFVII_I_metadata_line_13_____111Ord Llc_20211101 >									
183 	//        < FjgrFORaJOjN566ibUCSv795C9eCQmwQLB0x74ecY4gONt104DTMszkV20GArqwN >									
184 	//        <  u =="0.000000000000000001" : ] 000000225974929.832197000000000000 ; 000000251210492.556194000000000000 ] >									
185 	//        < 0x00000000000000000000000000000000000000000000000000158CF7517F5119 >									
186 	//     < NDRV_PFVII_I_metadata_line_14_____Hannover Insurance_Linked Securities GmbH & Co KG_20211101 >									
187 	//        < HM2dhzj90HR70Zv6rEg0PvNx070af4BH4UoegWmz947MfsOvbCRJdiegWg9b4i4w >									
188 	//        <  u =="0.000000000000000001" : ] 000000251210492.556194000000000000 ; 000000274190158.710934000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000017F51191A26188 >									
190 	//     < NDRV_PFVII_I_metadata_line_15_____Hannover Ruckversicherung AG Hong Kong_20211101 >									
191 	//        < 77AkBn2WvJ4d0q4xvNyLe5tuj77vCSoRCijG7AAl2HfS6x6h2aThfUzM7V23E6qo >									
192 	//        <  u =="0.000000000000000001" : ] 000000274190158.710934000000000000 ; 000000291065536.780856000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000001A261881BC217A >									
194 	//     < NDRV_PFVII_I_metadata_line_16_____Hannover Reinsurance Mauritius Ltd_20211101 >									
195 	//        < XD7QXFR6gwf988XizXbtZndjemwDcpNKMpSvkPLFT2E1cLzp58rTTn8TM3bd1N35 >									
196 	//        <  u =="0.000000000000000001" : ] 000000291065536.780856000000000000 ; 000000310073776.225605000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000001BC217A1D92292 >									
198 	//     < NDRV_PFVII_I_metadata_line_17_____HEPEP II Holding GmbH_20211101 >									
199 	//        < 8cRg5oOx57t0V1moAFbHMYPu5IhXkaX8v4DB9CTs75Vj1q5Z5cusB1n8xnIU21hd >									
200 	//        <  u =="0.000000000000000001" : ] 000000310073776.225605000000000000 ; 000000326249330.366688000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000001D922921F1D125 >									
202 	//     < NDRV_PFVII_I_metadata_line_18_____International Insurance Company Of Hannover Limited Sweden_20211101 >									
203 	//        < wuDt3QCf40g1KGYjsKw2Xdpn3fTEhE1y7BZ6L6yZ9qbqO1436Hc3n29ITpJElFSR >									
204 	//        <  u =="0.000000000000000001" : ] 000000326249330.366688000000000000 ; 000000343960919.520275000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000001F1D12520CD7BC >									
206 	//     < NDRV_PFVII_I_metadata_line_19_____HEPEP III Holding GmbH_20211101 >									
207 	//        < 7M25S2i13pBv2nh1Svvn22YO911Vu7aycSZ998jsHovadZw6261pPyPJ943Dr300 >									
208 	//        <  u =="0.000000000000000001" : ] 000000343960919.520275000000000000 ; 000000361054072.329564000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000000020CD7BC226ECBF >									
210 	//     < NDRV_PFVII_I_metadata_line_20_____Hannover Rueck Beteiligung Verwaltungs_GmbH_20211101 >									
211 	//        < g5b1e98QLGSeDFU0F3EnwAS64ADWkH88AppwCpu7aSvlMeimq8vkM6Cci4F1RQ8U >									
212 	//        <  u =="0.000000000000000001" : ] 000000361054072.329564000000000000 ; 000000378568587.177376000000000000 ] >									
213 	//        < 0x00000000000000000000000000000000000000000000000000226ECBF241A65B >									
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
256 	//     < NDRV_PFVII_I_metadata_line_21_____EplusS Rückversicherung AG_20211101 >									
257 	//        < 3SOiJ5dNkskLz7H9M2zGN1G4Z7rT4W3d0t34a7X57oKqhEhR232VO8G8A8bS1fD8 >									
258 	//        <  u =="0.000000000000000001" : ] 000000378568587.177376000000000000 ; 000000399643168.374624000000000000 ] >									
259 	//        < 0x00000000000000000000000000000000000000000000000000241A65B261CE9D >									
260 	//     < NDRV_PFVII_I_metadata_line_22_____HILSP Komplementaer GmbH_20211101 >									
261 	//        < 9q7b6uqca80aG1y4C7om2YcWMkgJu1auE5b1Pc0G2R823g32mMhT0MuLV7VUuxfC >									
262 	//        <  u =="0.000000000000000001" : ] 000000399643168.374624000000000000 ; 000000415776096.852679000000000000 ] >									
263 	//        < 0x00000000000000000000000000000000000000000000000000261CE9D27A6C8A >									
264 	//     < NDRV_PFVII_I_metadata_line_23_____Hannover Life Reassurance UK Limited_20211101 >									
265 	//        < 8Y1yOl71H33Im2c2Vl7Lv0DfPo91k5fOEbu5QHBYKWFV4xd3lN69o4vITj7po74Y >									
266 	//        <  u =="0.000000000000000001" : ] 000000415776096.852679000000000000 ; 000000432455670.462925000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000027A6C8A293DFFF >									
268 	//     < NDRV_PFVII_I_metadata_line_24_____EplusS Reinsurance Ireland Ltd_20211101 >									
269 	//        < 5XtdefFgov3bVsH8Gk7627aRy1c3JQYV3nViwGfAb75KQS09sJS1V7fS9oFmwhZ6 >									
270 	//        <  u =="0.000000000000000001" : ] 000000432455670.462925000000000000 ; 000000449195382.734069000000000000 ] >									
271 	//        < 0x00000000000000000000000000000000000000000000000000293DFFF2AD6AF2 >									
272 	//     < NDRV_PFVII_I_metadata_line_25_____Svedea Skadeservice Ab_20211101 >									
273 	//        < 8AQ1q8FeUxlj57gN11DRq3zM00CR13k91wG1HrAN4hFCs11O9Q98ennKnBUSVz2S >									
274 	//        <  u =="0.000000000000000001" : ] 000000449195382.734069000000000000 ; 000000468374408.713786000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002AD6AF22CAAEC1 >									
276 	//     < NDRV_PFVII_I_metadata_line_26_____Hannover Finance Luxembourg SA_20211101 >									
277 	//        < 54RB16Ux88HUe6oqTZLHCnqiTY5069mzuo6l732UpxEmaViwevkFe5mIx26xxA8d >									
278 	//        <  u =="0.000000000000000001" : ] 000000468374408.713786000000000000 ; 000000485298279.579397000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000002CAAEC12E481A4 >									
280 	//     < NDRV_PFVII_I_metadata_line_27_____Hannover Ruckversicherung AG Australia_20211101 >									
281 	//        < Gy71u7NJ52hR53d0664Hg3QpnLm8bAlBuZ2uWtY5VsSr7R4HJ06VoOxUWinUSK7Y >									
282 	//        <  u =="0.000000000000000001" : ] 000000485298279.579397000000000000 ; 000000500314648.290489000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000002E481A42FB6B69 >									
284 	//     < NDRV_PFVII_I_metadata_line_28_____Cargo Transit Insurance Pty Limited_20211101 >									
285 	//        < x001s15tfv309q48Iumx11ulhemwLZEk99Ba62LQ9O2apOGogcKk88QRKPZzU90u >									
286 	//        <  u =="0.000000000000000001" : ] 000000500314648.290489000000000000 ; 000000518841937.139793000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000002FB6B69317B0A2 >									
288 	//     < NDRV_PFVII_I_metadata_line_29_____Hannover Life Re Africa_20211101 >									
289 	//        < lYNv19Q1RcWi2Y9M0D2l32QmdagU64J2MrS2Gdt1upq5f213D5wkbPu3T5w9qUdh >									
290 	//        <  u =="0.000000000000000001" : ] 000000518841937.139793000000000000 ; 000000542273687.389949000000000000 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000000000317B0A233B71A9 >									
292 	//     < NDRV_PFVII_I_metadata_line_30_____Hannover Re Services USA Inc_20211101 >									
293 	//        < S6tC8Y0pV89RSK3qsSrKBeBw6YikJL7z9L7A81s9w0CQ4SF5r99hNb4l9EN5fmTg >									
294 	//        <  u =="0.000000000000000001" : ] 000000542273687.389949000000000000 ; 000000556702297.307145000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000033B71A935175D6 >									
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
338 	//     < NDRV_PFVII_I_metadata_line_31_____Talanx Deutschland AG_20211101 >									
339 	//        < Ura6Hu92X7Qx90EheC85e30cLCbjjxvE14OV7pDdjeKmR3q6ZL50gL9U4bME93oA >									
340 	//        <  u =="0.000000000000000001" : ] 000000556702297.307145000000000000 ; 000000571417993.635643000000000000 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000000000035175D6367EA27 >									
342 	//     < NDRV_PFVII_I_metadata_line_32_____HDI Lebensversicherung AG_20211101 >									
343 	//        < FMOQc5zfLkf1K3Cimx51fVB0JYXlm18IRP11U2wNcd0NsL3kXLoaszswoSC6m752 >									
344 	//        <  u =="0.000000000000000001" : ] 000000571417993.635643000000000000 ; 000000591344194.730547000000000000 ] >									
345 	//        < 0x00000000000000000000000000000000000000000000000000367EA2738651D3 >									
346 	//     < NDRV_PFVII_I_metadata_line_33_____casa altra development GmbH_20211101 >									
347 	//        < p4g9b6e1x56sv2dbPX6g0nShzxnk70J6DayTcgma5ba4vj3nWh1HO3nuuY2404dI >									
348 	//        <  u =="0.000000000000000001" : ] 000000591344194.730547000000000000 ; 000000608768240.919799000000000000 ] >									
349 	//        < 0x0000000000000000000000000000000000000000000000000038651D33A0E818 >									
350 	//     < NDRV_PFVII_I_metadata_line_34_____Credit Life International Services GmbH_20211101 >									
351 	//        < tVZR8zJmWN8eSB43N20DDjQUH41NNr3h3CI0ZI48j8f809B3Tb61SJi9cYLqa8P3 >									
352 	//        <  u =="0.000000000000000001" : ] 000000608768240.919799000000000000 ; 000000626799665.107055000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000003A0E8183BC6B9F >									
354 	//     < NDRV_PFVII_I_metadata_line_35_____FVB Gesellschaft für Finanz_und Versorgungsberatung mbH_20211101 >									
355 	//        < GS904r6i23b4c9J19e4m23bj08qi3SFa61HvhLE2mJ0dhZ4ycsIbd3ks9Fk01024 >									
356 	//        <  u =="0.000000000000000001" : ] 000000626799665.107055000000000000 ; 000000647236813.932272000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000003BC6B9F3DB9AE1 >									
358 	//     < NDRV_PFVII_I_metadata_line_36_____ASPECTA Assurance International AG_20211101 >									
359 	//        < JuSvBweO1f65317Lw6T1P9cI1Rc1w0L7e5YO6Z659I2btx36Hk4R20Mf65M0xmVQ >									
360 	//        <  u =="0.000000000000000001" : ] 000000647236813.932272000000000000 ; 000000667176540.330644000000000000 ] >									
361 	//        < 0x000000000000000000000000000000000000000000000000003DB9AE13FA07D6 >									
362 	//     < NDRV_PFVII_I_metadata_line_37_____Life Re_Holdings_20211101 >									
363 	//        < Ty0zM52K39g420wA31jO3uYG30eXd6KLtD8ar0TF9Qfqh93MsP81ACzMa40G4Kx9 >									
364 	//        <  u =="0.000000000000000001" : ] 000000667176540.330644000000000000 ; 000000686148780.604753000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000003FA07D6416FADE >									
366 	//     < NDRV_PFVII_I_metadata_line_38_____Credit Life_Pensions_20211101 >									
367 	//        < rf0V48C5KShG5AtByovExoni6F93FI6zXeQ9myM26gK81i0Hpul53j920W84069I >									
368 	//        <  u =="0.000000000000000001" : ] 000000686148780.604753000000000000 ; 000000711876245.725396000000000000 ] >									
369 	//        < 0x00000000000000000000000000000000000000000000000000416FADE43E3CA9 >									
370 	//     < NDRV_PFVII_I_metadata_line_39_____ASPECTA_org_20211101 >									
371 	//        < kOh5JxEuCiH7495kBZw183qgjOCtiFcG12Og88y0Lq5Us7c47PpY07tefM8D607n >									
372 	//        <  u =="0.000000000000000001" : ] 000000711876245.725396000000000000 ; 000000732652708.351949000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000043E3CA945DF077 >									
374 	//     < NDRV_PFVII_I_metadata_line_40_____Cargo Transit_Holdings_20211101 >									
375 	//        < 2z6135i3Qny0BtCI4Is8P1j02bI5GXE7ZAwhLFi6600i19bdD5BT17M93mH66C8r >									
376 	//        <  u =="0.000000000000000001" : ] 000000732652708.351949000000000000 ; 000000756107420.564358000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000045DF077481BA76 >									
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