1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXXXI_II_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXXXI_II_883		"	;
8 		string	public		symbol =	"	RUSS_PFXXXI_II_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		799361044451549000000000000					;	
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
92 	//     < RUSS_PFXXXI_II_metadata_line_1_____MEGAFON_20231101 >									
93 	//        < Gj50Igyj7AgJ254Qd2dqDO9nJu9JxbPi12cHevlnmDCE9fo0XCFRF0QA9A4k2rPX >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000022235580.019941900000000000 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000000021EDC6 >									
96 	//     < RUSS_PFXXXI_II_metadata_line_2_____EUROSET_20231101 >									
97 	//        < 45kxjDgdY2Jj1pssK9rpmFW5zDLCH8mMjeYeA2GTc0K0H5Xmrtm07BKkB0f551J8 >									
98 	//        <  u =="0.000000000000000001" : ] 000000022235580.019941900000000000 ; 000000040009691.845733000000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000021EDC63D0CC9 >									
100 	//     < RUSS_PFXXXI_II_metadata_line_3_____OSTELECOM_20231101 >									
101 	//        < RV86PC3ySD86FVf9V3MXAVxD0ntIX4118D54KLrvPw2AM6EvNv4JOIO056v2y1R0 >									
102 	//        <  u =="0.000000000000000001" : ] 000000040009691.845733000000000000 ; 000000058349304.466849000000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000003D0CC95908B2 >									
104 	//     < RUSS_PFXXXI_II_metadata_line_4_____GARS_TELECOM_20231101 >									
105 	//        < 5wVTksmi98N5z1J9zsWaN1ilkdXgmG2tVA2318oxVN6n9Q4L6OvSpGE0KsC8YLqN >									
106 	//        <  u =="0.000000000000000001" : ] 000000058349304.466849000000000000 ; 000000077240181.682029000000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000005908B275DBF2 >									
108 	//     < RUSS_PFXXXI_II_metadata_line_5_____MEGAFON_INVESTMENT_CYPRUS_LIMITED_20231101 >									
109 	//        < iTqJU5LM063lk7vB3GG48L4mLNd27UxNk7T3G9dB9EE30kJ92PPr44sJ1T4AC408 >									
110 	//        <  u =="0.000000000000000001" : ] 000000077240181.682029000000000000 ; 000000102086990.573193000000000000 ] >									
111 	//        < 0x000000000000000000000000000000000000000000000000000075DBF29BC5BB >									
112 	//     < RUSS_PFXXXI_II_metadata_line_6_____YOTA_20231101 >									
113 	//        < Aon6yK0xZpc5rM1tGhIIvM8KV1QRtnLYr8fz1ebO9Dayk9o1SchJ39395Z9KjioV >									
114 	//        <  u =="0.000000000000000001" : ] 000000102086990.573193000000000000 ; 000000120407680.229163000000000000 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000000000009BC5BBB7BA40 >									
116 	//     < RUSS_PFXXXI_II_metadata_line_7_____YOTA_DAO_20231101 >									
117 	//        < 900ed6T6508XjikLPnj2zytOe0A4D1yb212e248Flx34TKIClz3jE5BOFPU1dON6 >									
118 	//        <  u =="0.000000000000000001" : ] 000000120407680.229163000000000000 ; 000000137430763.107904000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000B7BA40D1B3E4 >									
120 	//     < RUSS_PFXXXI_II_metadata_line_8_____YOTA_DAOPI_20231101 >									
121 	//        < xDb8p9Amcu3KhrpE1NFCNyZqo690l45ab3q9XMohu9rA7P6daDDn73pJ61G97JS9 >									
122 	//        <  u =="0.000000000000000001" : ] 000000137430763.107904000000000000 ; 000000155984032.985441000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000D1B3E4EE0343 >									
124 	//     < RUSS_PFXXXI_II_metadata_line_9_____YOTA_DAC_20231101 >									
125 	//        < GA9tAMI2P5i5QBLB0194Wiby4ycej5XDp34bj472ImrT0nu2va8Kx6Ma35nO988O >									
126 	//        <  u =="0.000000000000000001" : ] 000000155984032.985441000000000000 ; 000000173929236.001575000000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000000EE0343109651C >									
128 	//     < RUSS_PFXXXI_II_metadata_line_10_____YOTA_BIMI_20231101 >									
129 	//        < 4vU8ub6zRnB9Ton9JuwH3ZB97oWKW40kUV0AGeYvTBQiSA7rSGhuzy2qBF3Ww7MN >									
130 	//        <  u =="0.000000000000000001" : ] 000000173929236.001575000000000000 ; 000000198098653.208605000000000000 ] >									
131 	//        < 0x00000000000000000000000000000000000000000000000000109651C12E4649 >									
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
174 	//     < RUSS_PFXXXI_II_metadata_line_11_____KAVKAZ_20231101 >									
175 	//        < 84HJJp2O1sl7Bn1L9c150aanj4SPf26sIN3FMAp8ynqQ5T36W897GQ49QszM8c2j >									
176 	//        <  u =="0.000000000000000001" : ] 000000198098653.208605000000000000 ; 000000214678865.937489000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000012E464914792EF >									
178 	//     < RUSS_PFXXXI_II_metadata_line_12_____KAVKAZ_KZT_20231101 >									
179 	//        < 1SKyauiMvwL1g5gIeM8KLidw1O8U65L49AcFMB8i960kZkfr3B250V678vhN76xr >									
180 	//        <  u =="0.000000000000000001" : ] 000000214678865.937489000000000000 ; 000000239002502.077128000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000014792EF16CB05A >									
182 	//     < RUSS_PFXXXI_II_metadata_line_13_____KAVKAZ_CHF_20231101 >									
183 	//        < q67eD0S040751o6FsVqHIITtRfhk3LvNuQag39oXnJo3jIifC0sUkO9hYmE9a331 >									
184 	//        <  u =="0.000000000000000001" : ] 000000239002502.077128000000000000 ; 000000257321980.098189000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000016CB05A188A466 >									
186 	//     < RUSS_PFXXXI_II_metadata_line_14_____KAVKAZ_USD_20231101 >									
187 	//        < P5tsI9L1T3Ou65338nYgv4Yxia2DDSDOjs4ae0qLVLht39AJCfO3c2kO4VgG5nin >									
188 	//        <  u =="0.000000000000000001" : ] 000000257321980.098189000000000000 ; 000000278269905.899461000000000000 ] >									
189 	//        < 0x00000000000000000000000000000000000000000000000000188A4661A89B2F >									
190 	//     < RUSS_PFXXXI_II_metadata_line_15_____PETERSTAR_20231101 >									
191 	//        < d0763cPmNV83T82Sh8ZWMIDC5qGoZ9Cxb91tkWP12TLCVmUY4vqAZex4TIroZ8C2 >									
192 	//        <  u =="0.000000000000000001" : ] 000000278269905.899461000000000000 ; 000000293745992.835777000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000001A89B2F1C03887 >									
194 	//     < RUSS_PFXXXI_II_metadata_line_16_____MEGAFON_FINANCE_LLC_20231101 >									
195 	//        < 28Y21G5C36UDB2o5cJRj7Ah5p9Q3r8139uf6gd4ytuuJRa7djt4KX07Q55uFht0M >									
196 	//        <  u =="0.000000000000000001" : ] 000000293745992.835777000000000000 ; 000000310852301.527820000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000001C038871DA52AE >									
198 	//     < RUSS_PFXXXI_II_metadata_line_17_____LEFBORD_INVESTMENTS_LIMITED_20231101 >									
199 	//        < 8U7P60d4g0v4cMmNT6lenmUDX77314m4IyrylYZyjsYJdYTBCIpTx5Zb3yFF5Ti8 >									
200 	//        <  u =="0.000000000000000001" : ] 000000310852301.527820000000000000 ; 000000328743174.991446000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000001DA52AE1F59F4D >									
202 	//     < RUSS_PFXXXI_II_metadata_line_18_____TT_MOBILE_20231101 >									
203 	//        < ZqrAC8cJEBtRdsFU797s267zb189hl8Yg8w0v6oGakoM5Jfi8iuj41Z59LC8l49H >									
204 	//        <  u =="0.000000000000000001" : ] 000000328743174.991446000000000000 ; 000000349118482.883723000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000001F59F4D214B668 >									
206 	//     < RUSS_PFXXXI_II_metadata_line_19_____SMARTS_SAMARA_20231101 >									
207 	//        < Ror57BTBSFzlQim1tp2uS984TC0TI3L2B2oD0cY6233uwVqsipTpWE94r7aXQ2NZ >									
208 	//        <  u =="0.000000000000000001" : ] 000000349118482.883723000000000000 ; 000000369637759.863067000000000000 ] >									
209 	//        < 0x00000000000000000000000000000000000000000000000000214B66823405C0 >									
210 	//     < RUSS_PFXXXI_II_metadata_line_20_____MEGAFON_NORTH_WEST_20231101 >									
211 	//        < D8AQQfV583SUYZ27hsVQ02M80Qb8aeG3IFRA7d09Do4Nw6cjYbX5UhQKI32cFk2c >									
212 	//        <  u =="0.000000000000000001" : ] 000000369637759.863067000000000000 ; 000000385108258.590554000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000023405C024BA0EA >									
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
256 	//     < RUSS_PFXXXI_II_metadata_line_21_____GARS_HOLDING_LIMITED_20231101 >									
257 	//        < m6gzp5uZ11pUE9g821F8sLbxIV41458a2Om5ZpKExCvPxMFs7nV6fE52HJ4UXS9U >									
258 	//        <  u =="0.000000000000000001" : ] 000000385108258.590554000000000000 ; 000000404710135.813941000000000000 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000000024BA0EA26989E6 >									
260 	//     < RUSS_PFXXXI_II_metadata_line_22_____SMARTS_CHEBOKSARY_20231101 >									
261 	//        < wK0bz188G5h05079w40As93N72565My286H53V8e7w9v93alO3eIH6SmkZZ1WG0w >									
262 	//        <  u =="0.000000000000000001" : ] 000000404710135.813941000000000000 ; 000000421737424.895583000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000026989E6283852E >									
264 	//     < RUSS_PFXXXI_II_metadata_line_23_____MEGAFON_ORG_20231101 >									
265 	//        < w8W8cpoPKcRfc58FY86Np2wT52vwW1mm15XN49G4c32Dfdl24ULM7j4ZJyb5vQTL >									
266 	//        <  u =="0.000000000000000001" : ] 000000421737424.895583000000000000 ; 000000441336653.471569000000000000 ] >									
267 	//        < 0x00000000000000000000000000000000000000000000000000283852E2A16D21 >									
268 	//     < RUSS_PFXXXI_II_metadata_line_24_____NAKHODKA_TELECOM_20231101 >									
269 	//        < GbZoET8X73wPkJ82sXc50Sz08HLie4F5C5O4whA0Kw742ZhR2V3UiKuQxgBkBErS >									
270 	//        <  u =="0.000000000000000001" : ] 000000441336653.471569000000000000 ; 000000461238156.808575000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000002A16D212BFCB28 >									
272 	//     < RUSS_PFXXXI_II_metadata_line_25_____NEOSPRINT_20231101 >									
273 	//        < imR7RoW12Hf5Snk66i2CrUntstFc3l4lzGTjHvMDxGm04wimS8tLbe4IL6Jj3tQ4 >									
274 	//        <  u =="0.000000000000000001" : ] 000000461238156.808575000000000000 ; 000000479485478.659509000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002BFCB282DBA304 >									
276 	//     < RUSS_PFXXXI_II_metadata_line_26_____SMARTS_PENZA_20231101 >									
277 	//        < 8oa7SJz4hy7Km0i9ToO9qejDV86304x6L67oGloZ8uC8S6o7aDc87F9OOZUxbm6u >									
278 	//        <  u =="0.000000000000000001" : ] 000000479485478.659509000000000000 ; 000000502172777.123001000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000002DBA3042FE413E >									
280 	//     < RUSS_PFXXXI_II_metadata_line_27_____MEGAFON_RETAIL_20231101 >									
281 	//        < 82CI14NSYKJQ4hFg3xpRP20K68c0k5ytOZcN3T7tQS1PW42Wg5blqeNTIbY2A1Ev >									
282 	//        <  u =="0.000000000000000001" : ] 000000502172777.123001000000000000 ; 000000524422236.741445000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000002FE413E3203470 >									
284 	//     < RUSS_PFXXXI_II_metadata_line_28_____FIRST_TOWER_COMPANY_20231101 >									
285 	//        < k860K3rDBBtuRs0l19l6Lh3JOGquPCPwmnKKYGM4F6I9fxO6hu7d66E98469xEQL >									
286 	//        <  u =="0.000000000000000001" : ] 000000524422236.741445000000000000 ; 000000547159477.366241000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000003203470342E62C >									
288 	//     < RUSS_PFXXXI_II_metadata_line_29_____MEGAFON_SA_20231101 >									
289 	//        < HxIlIe1joa73z00A963Ihsnw0QyyOm89LqG4UT4bB1TkMoXqDpS7HMCd7oe5xb6p >									
290 	//        <  u =="0.000000000000000001" : ] 000000547159477.366241000000000000 ; 000000570721286.206245000000000000 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000000000342E62C366DA01 >									
292 	//     < RUSS_PFXXXI_II_metadata_line_30_____MOBICOM_KHABAROVSK_20231101 >									
293 	//        < 5iVGu5w5lI3jM7M87Mg5r8oolX2jx7U8t9620fl96e14N9D2O8gCL0hvK7U0cjZ2 >									
294 	//        <  u =="0.000000000000000001" : ] 000000570721286.206245000000000000 ; 000000594519744.451555000000000000 ] >									
295 	//        < 0x00000000000000000000000000000000000000000000000000366DA0138B2A46 >									
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
338 	//     < RUSS_PFXXXI_II_metadata_line_31_____AQUAFON_GSM_20231101 >									
339 	//        < 2o4A87ggH0K80P95WVqS76AD8D86qvc1sLKpvTvZvU60o3yP023Q877vS0AYwIA6 >									
340 	//        <  u =="0.000000000000000001" : ] 000000594519744.451555000000000000 ; 000000619133572.810140000000000000 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000000000038B2A463B0B90D >									
342 	//     < RUSS_PFXXXI_II_metadata_line_32_____DIGITAL_BUSINESS_SOLUTIONS_20231101 >									
343 	//        < czBN3X928vt4fQs6LZ6ee4oF3j9r9855hUu8Z2UdkhwC0z91FGa6BrY1OrB4Qj5R >									
344 	//        <  u =="0.000000000000000001" : ] 000000619133572.810140000000000000 ; 000000637133389.318110000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000003B0B90D3CC303B >									
346 	//     < RUSS_PFXXXI_II_metadata_line_33_____KOMBELL_OOO_20231101 >									
347 	//        < l05R7kzP143WK7tMgfAYiv6QqxfV1NB4iYl7l95GKDk65EbUq57VeWTu9LCZtSvZ >									
348 	//        <  u =="0.000000000000000001" : ] 000000637133389.318110000000000000 ; 000000656878922.686170000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000003CC303B3EA5154 >									
350 	//     < RUSS_PFXXXI_II_metadata_line_34_____URALSKI_GSM_ZAO_20231101 >									
351 	//        < y2F0DDzfr1RFZw7CUx6V45B2VYhhCW556r7mc8vrX5rx23ATh7OSNyjUGaoy63Jz >									
352 	//        <  u =="0.000000000000000001" : ] 000000656878922.686170000000000000 ; 000000678208485.226699000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000003EA515440ADD31 >									
354 	//     < RUSS_PFXXXI_II_metadata_line_35_____INCORE_20231101 >									
355 	//        < 201453O1FL8t28GZ0KPkV6jwkAicgIlNSqpQR3IR4e1Nui7CM9vZ3pjYtuexNZ22 >									
356 	//        <  u =="0.000000000000000001" : ] 000000678208485.226699000000000000 ; 000000699805389.881233000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000040ADD3142BD17B >									
358 	//     < RUSS_PFXXXI_II_metadata_line_36_____MEGALABS_20231101 >									
359 	//        < 2eMa3CvKAZbjTVq4gKa34AZwrgp9t5QqEMZl67FFR8Sa1E0x51zooHdkqVLM1t42 >									
360 	//        <  u =="0.000000000000000001" : ] 000000699805389.881233000000000000 ; 000000719118882.797284000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000042BD17B44949D0 >									
362 	//     < RUSS_PFXXXI_II_metadata_line_37_____AQUAPHONE_GSM_20231101 >									
363 	//        < jC5j16LB7QTk8WrGghiDB2si644AY6CsS7q50Ka9S1xrYuFBJNe6vQhnRr6JwdE6 >									
364 	//        <  u =="0.000000000000000001" : ] 000000719118882.797284000000000000 ; 000000738830412.802175000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000044949D04675DA1 >									
366 	//     < RUSS_PFXXXI_II_metadata_line_38_____TC_COMET_20231101 >									
367 	//        < zoh7lK2XAmgvx99j5lDmT6I4ka7AC82nPZrbXxx3SRy62O4iyy6b3QhoOs1218I5 >									
368 	//        <  u =="0.000000000000000001" : ] 000000738830412.802175000000000000 ; 000000760006936.709037000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000004675DA1487ADB6 >									
370 	//     < RUSS_PFXXXI_II_metadata_line_39_____DEBTON_INVESTMENTS_LIMITED_20231101 >									
371 	//        < j6HrcGl1wtugYb54xk7u6fgHrDknH72qS9K965o5LE6hZVDti0GkFR4723dpKbzj >									
372 	//        <  u =="0.000000000000000001" : ] 000000760006936.709037000000000000 ; 000000780315253.864151000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000487ADB64A6AAA5 >									
374 	//     < RUSS_PFXXXI_II_metadata_line_40_____NETBYNET_HOLDING_20231101 >									
375 	//        < 52W9FTuJ8xkBhbDsE4t8aAd3v76LC0c2E36Ax474N0LS8nQ1o6hgtIaD5OEc65Q6 >									
376 	//        <  u =="0.000000000000000001" : ] 000000780315253.864151000000000000 ; 000000799361044.451549000000000000 ] >									
377 	//        < 0x000000000000000000000000000000000000000000000000004A6AAA54C3BA68 >									
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