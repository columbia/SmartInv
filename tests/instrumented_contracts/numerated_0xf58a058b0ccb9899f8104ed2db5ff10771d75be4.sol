1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RE_Portfolio_XX_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RE_Portfolio_XX_883		"	;
8 		string	public		symbol =	"	RE883XX		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1401819335116930000000000000					;	
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
92 	//     < RE_Portfolio_XX_metadata_line_1_____Trust_International_Insurance_&_Reinsurance_Company_BSC__c__Trust_Re_Am_Am_20250515 >									
93 	//        < 1BXPW0595SF9QK83Y2IU7l4Dfj45M15NVKNaskZ5EN6UeS4qfNG25218BP82PYng >									
94 	//        < 1E-018 limites [ 1E-018 ; 17455979,3632816 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000680BB7E4 >									
96 	//     < RE_Portfolio_XX_metadata_line_2_____Trust_International_Insurance_&_Reinsurance_Company_BSC__c__Trust_Re_Am_Am_20250515 >									
97 	//        < 1ingNjC0JwHS7gaw9aTpab05xlRKQz3E8ujh1G5R3Ug1T6U89P31ae71jgeKGvjk >									
98 	//        < 1E-018 limites [ 17455979,3632816 ; 54341746,4883302 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000680BB7E4143E6EEAC >									
100 	//     < RE_Portfolio_XX_metadata_line_3_____TT_Club_Mutual_Insurance_Limited_Am_20250515 >									
101 	//        < 55SDgre763R03433OU853ZDymgB6D26J1ZHIteJ1mAAm7BIRrkFeQzQI7VXds7At >									
102 	//        < 1E-018 limites [ 54341746,4883302 ; 79055470,0719512 ] >									
103 	//        < 0x0000000000000000000000000000000000000000000000143E6EEAC1D73514F3 >									
104 	//     < RE_Portfolio_XX_metadata_line_4_____Tunis_BBm_Societe_Tunisienne_de_Reassurance__Tunis_Re___Tunisia__m_Bp_20250515 >									
105 	//        < gPryyk021QEC23t3YEeev95461988LE2Lo5EMTZrOW6R2Rw9j4xiwAtAN3Tma6x8 >									
106 	//        < 1E-018 limites [ 79055470,0719512 ; 107112337,418376 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000001D73514F327E7076C1 >									
108 	//     < RE_Portfolio_XX_metadata_line_5_____Tunis_Societe_Tunisienne_de_Reassurance_20250515 >									
109 	//        < AknNk9EkaiA2B82u0uUVM89p25zXVe9AElkps06Jaex4t0ZvX95L3pg3a8ARwCjG >									
110 	//        < 1E-018 limites [ 107112337,418376 ; 119668944,053987 ] >									
111 	//        < 0x000000000000000000000000000000000000000000000027E7076C12C9485339 >									
112 	//     < RE_Portfolio_XX_metadata_line_6_____UnipolSai_Assicurazioni_SpA_Am_BBB_20250515 >									
113 	//        < VP9p0Ml8wPAkfA3EYROh3Dt345gKtQO4wt0pvo71sA9zC2npYhJ93f9f3L285XZD >									
114 	//        < 1E-018 limites [ 119668944,053987 ; 137075938,136415 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000002C9485339331094A49 >									
116 	//     < RE_Portfolio_XX_metadata_line_7_____Uniqa_Insurance_Group_Am_20250515 >									
117 	//        < a3AE039K0t779Og8kc4F01mwGg931XC0UobnjC7sRe10kz1g2F6iK2OH7QkF98sG >									
118 	//        < 1E-018 limites [ 137075938,136415 ; 175332817,47607 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000331094A4941510A7C7 >									
120 	//     < RE_Portfolio_XX_metadata_line_8_____Uniqa_Insurance_Group_Am_20250515 >									
121 	//        < tQ7XKXQO68d5c2AQ6y5Zv0fSCOyf33nD71gv614dD9QnZY3EZRk7stpmz966jR35 >									
122 	//        < 1E-018 limites [ 175332817,47607 ; 189214925,284186 ] >									
123 	//        < 0x000000000000000000000000000000000000000000000041510A7C7467CF1224 >									
124 	//     < RE_Portfolio_XX_metadata_line_9_____Unity_Reinsurance_Company_Limited_Bp_20250515 >									
125 	//        < fPHtj1Y5yp2q4Ak0BTTd87g3253hz4RmZ753FjSG4a57S8v6y3hCSgjrUYAl5O6h >									
126 	//        < 1E-018 limites [ 189214925,284186 ; 230888000,299187 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000467CF1224560332311 >									
128 	//     < RE_Portfolio_XX_metadata_line_10_____US_Re_Companies_20250515 >									
129 	//        < VPn79qupSCM2H6xBB7qk5Bn1VdEAn3GT8sjY5iCxCRUvq0mc9376RbO8lD8em4Y7 >									
130 	//        < 1E-018 limites [ 230888000,299187 ; 242557494,555415 ] >									
131 	//        < 0x00000000000000000000000000000000000000000000005603323115A5C15F43 >									
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
174 	//     < RE_Portfolio_XX_metadata_line_11_____Validus_Holdings_Limited_20250515 >									
175 	//        < qpU50owrp5uj0255k5w1FTHO25mhOtjrA1ujmF87M22wl589sS87DgcrqRF13j4u >									
176 	//        < 1E-018 limites [ 242557494,555415 ; 269895374,280715 ] >									
177 	//        < 0x00000000000000000000000000000000000000000000005A5C15F43648B3AA88 >									
178 	//     < RE_Portfolio_XX_metadata_line_12_____VHV_Allgemeine_Versicherung_AG_A_m_20250515 >									
179 	//        < Ef83dHS9Kw3XolItU6E2qz3J36deNjdQIwqJ8jP74JoTfWZQES8IV3XeuEZNjSix >									
180 	//        < 1E-018 limites [ 269895374,280715 ; 314645335,085268 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000648B3AA887536EAFF8 >									
182 	//     < RE_Portfolio_XX_metadata_line_13_____Vibe_Syndicate_Management_Limited_20250515 >									
183 	//        < 3qi3yaX8otX417xNpMgoNoJKqv9O435OtWkLJAZf6z089BCPFAYDqr4r11yo0SEp >									
184 	//        < 1E-018 limites [ 314645335,085268 ; 370345979,752079 ] >									
185 	//        < 0x00000000000000000000000000000000000000000000007536EAFF889F6F204B >									
186 	//     < RE_Portfolio_XX_metadata_line_14_____Vibe_Syndicate_Management_Limited_20250515 >									
187 	//        < f0aaSG0GnX0FmxdMz2j3vWWy7Cfw07b0sGcuiDNHmqQaND3d0sm88D5r8FRiyN6B >									
188 	//        < 1E-018 limites [ 370345979,752079 ; 415432882,292015 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000089F6F204B9AC2C4799 >									
190 	//     < RE_Portfolio_XX_metadata_line_15_____Vibe_Syndicate_Management_Limited_20250515 >									
191 	//        < 07LFpeC7XTQ8nyJzCSSI1IBx4uL55A7fC72GG6W98Xv0EhQYCm8n0z1wPqP4Yb7o >									
192 	//        < 1E-018 limites [ 415432882,292015 ; 464547414,233616 ] >									
193 	//        < 0x00000000000000000000000000000000000000000000009AC2C4799AD0EB1BA3 >									
194 	//     < RE_Portfolio_XX_metadata_line_16_____Vienna_Insurance_Group_AG_Wiener_Versicherung_Ap_20250515 >									
195 	//        < t20f60vSo13SU5mA6A972y7mlDeUp098D3AOIrslCyZ686oaz3B722H2Crp8BPn9 >									
196 	//        < 1E-018 limites [ 464547414,233616 ; 504507491,180122 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000AD0EB1BA3BBF1958B2 >									
198 	//     < RE_Portfolio_XX_metadata_line_17_____Vienna_Insurance_Group_AG_Wiener_Versicherung_Ap_20250515 >									
199 	//        < p98c9D2PPYKELgY5p185UDeojeXs0x37l91pBP2PjY9o81Z325G50Cm89oTDXhg4 >									
200 	//        < 1E-018 limites [ 504507491,180122 ; 578394547,253117 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000BBF1958B2D77800BF9 >									
202 	//     < RE_Portfolio_XX_metadata_line_18_____Vietnam_BBm_PetroVietnam_Insurance_Corporation__PVI__Bpp_20250515 >									
203 	//        < U0P3yG4HiJRofgQRN4f7m9E1iF2YU98HM2W3vIuje9HTkRPv1hFe9k6y8iMK3VnZ >									
204 	//        < 1E-018 limites [ 578394547,253117 ; 606058777,838682 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000D77800BF9E1C64500B >									
206 	//     < RE_Portfolio_XX_metadata_line_19_____W_R_Berkley_Syndicate_Management_Limited_20250515 >									
207 	//        < 7BX859YYk608E34W2y2Q7686L3L9yEbM41fxvPT3Z8FBLfCeWY76Tc5OPTliXP1S >									
208 	//        < 1E-018 limites [ 606058777,838682 ; 658462063,040519 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000E1C64500BF54BD6154 >									
210 	//     < RE_Portfolio_XX_metadata_line_20_____W_R_Berkley_Syndicate_Management_Limited_20250515 >									
211 	//        < fFM1LLTCdN0EfMw2VsXt4mFao8Poy8Uf744m624nLJnThAh1pFkl6wh625Cc334v >									
212 	//        < 1E-018 limites [ 658462063,040519 ; 697328045,164976 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000F54BD6154103C662998 >									
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
256 	//     < RE_Portfolio_XX_metadata_line_21_____Watkins_Syndicate_20250515 >									
257 	//        < R76T1XsU2Sa9tCKgfvi7dA1UZB9VvL4Moz55h7yXMAFMt68h61mZ6csNuab7Pi7Q >									
258 	//        < 1E-018 limites [ 697328045,164976 ; 726790798,707558 ] >									
259 	//        < 0x00000000000000000000000000000000000000000000103C66299810EC02C1B2 >									
260 	//     < RE_Portfolio_XX_metadata_line_22_____White_Mountains_Insurance_Group_Limited_20250515 >									
261 	//        < vQT91gs7w10dCb58w7oMTJwPTk0JSBPtFfy81x9cax8tJp9ExNoRLHjrlN8kaPK2 >									
262 	//        < 1E-018 limites [ 726790798,707558 ; 749819874,592732 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000010EC02C1B21175465677 >									
264 	//     < RE_Portfolio_XX_metadata_line_23_____White_Mountains_Re_Group_Limited_20250515 >									
265 	//        < 9K7n1NYdNNx1u5wcP20QzAHQp8tf79xPVtJ0m9UU45W4t0ogP6X5xvC9t109f2if >									
266 	//        < 1E-018 limites [ 749819874,592732 ; 780070079,081868 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000011754656771229947C98 >									
268 	//     < RE_Portfolio_XX_metadata_line_24_____Willis_Re_20250515 >									
269 	//        < 7BuEjBPDQQ6pOjOnAQDOfX70T2qCw05uMwRsr55m5j6CWa26QR3JQ83cfaV5XRGa >									
270 	//        < 1E-018 limites [ 780070079,081868 ; 841937668,853115 ] >									
271 	//        < 0x000000000000000000000000000000000000000000001229947C98139A56EFD9 >									
272 	//     < RE_Portfolio_XX_metadata_line_25_____Wisconsin_Reinsurance_Corporation_20250515 >									
273 	//        < 360rm1902417F0PBeXYG0byJZ82uIH5706LDAUxj5azpNSdOSDFJS5nf0725DB5C >									
274 	//        < 1E-018 limites [ 841937668,853115 ; 898960342,172433 ] >									
275 	//        < 0x00000000000000000000000000000000000000000000139A56EFD914EE38A19D >									
276 	//     < RE_Portfolio_XX_metadata_line_26_____Workers_Compensation_Reinsurance_Assoc_20250515 >									
277 	//        < 3vtfLRQ02ZlJ0n354Qel18fuE8jhTRKvud2mam6TW8m39481JFqVZD4W4WL2H1Wd >									
278 	//        < 1E-018 limites [ 898960342,172433 ; 952359715,146174 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000014EE38A19D162C819BAE >									
280 	//     < RE_Portfolio_XX_metadata_line_27_____WR_Berkley_Corporation_20250515 >									
281 	//        < h8395M3gZQwnpRqeKPZKS2Gh93SlA96WrvXxXPpNVlZe1af0Zlw005kAWnk41byA >									
282 	//        < 1E-018 limites [ 952359715,146174 ; 1002150075,78951 ] >									
283 	//        < 0x00000000000000000000000000000000000000000000162C819BAE175547AB4E >									
284 	//     < RE_Portfolio_XX_metadata_line_28_____Wuerttembergische_versicherung_AG_Am_m_20250515 >									
285 	//        < S5H6sdl9g54fy47aXNk8XoIjGMGiY102k8rPPm4fHw7vAHrH01Qewknm0rzpymo7 >									
286 	//        < 1E-018 limites [ 1002150075,78951 ; 1025242796,34135 ] >									
287 	//        < 0x00000000000000000000000000000000000000000000175547AB4E17DEEC5D46 >									
288 	//     < RE_Portfolio_XX_metadata_line_29_____XL_Bermuda_Limited_A_A2_20250515 >									
289 	//        < 0Y987jO3Rs7U4dhjV173BC6Q5V30KA28d699A0r47Cvn8K4Y770CrQ8Q8UPVClm6 >									
290 	//        < 1E-018 limites [ 1025242796,34135 ; 1098510309,58296 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000017DEEC5D461993A1B7A2 >									
292 	//     < RE_Portfolio_XX_metadata_line_30_____XL_Group_Plc_20250515 >									
293 	//        < 810TUXd563gkI86a3B7YQ7GEXY4g7Uk834ZN2K5Ocbm5BUd9clww45pfcDjiAz67 >									
294 	//        < 1E-018 limites [ 1098510309,58296 ; 1119428835,35238 ] >									
295 	//        < 0x000000000000000000000000000000000000000000001993A1B7A21A1050DAC3 >									
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
338 	//     < RE_Portfolio_XX_metadata_line_31_____XL_insurance_company_SE_Ap_20250515 >									
339 	//        < vNGuW3kv8WNAL54CSN67Lqzl9z2dg6y0U0sBfX1rD3k4Mepp5RsVw7l6MoB983s8 >									
340 	//        < 1E-018 limites [ 1119428835,35238 ; 1138969919,95358 ] >									
341 	//        < 0x000000000000000000000000000000000000000000001A1050DAC31A84CA2EEF >									
342 	//     < RE_Portfolio_XX_metadata_line_32_____XL_London_Market_Limited_20250515 >									
343 	//        < 3P5voUT3pF4Te862GdLB0VJpHj23PV1C63BV1K3yXY8WusLtF925tQD26G80mHZf >									
344 	//        < 1E-018 limites [ 1138969919,95358 ; 1173586864,52707 ] >									
345 	//        < 0x000000000000000000000000000000000000000000001A84CA2EEF1B531F72E8 >									
346 	//     < RE_Portfolio_XX_metadata_line_33_____XL_Re_20250515 >									
347 	//        < RNbm1ZLoS9KVLu5VOW8Ug3BER83kZ5Ue5vz1rl03n7zTE6r2DKnATs2F9mkLe1Eb >									
348 	//        < 1E-018 limites [ 1173586864,52707 ; 1214068413,78663 ] >									
349 	//        < 0x000000000000000000000000000000000000000000001B531F72E81C44696416 >									
350 	//     < RE_Portfolio_XX_metadata_line_34_____XL_Re_Limited_m_A2_20250515 >									
351 	//        < H40s33wAB2ojx52isC26L684sm0oYpEA14016Oy3s099Je8XxsF7UtzRg358VGAK >									
352 	//        < 1E-018 limites [ 1214068413,78663 ; 1235703534,37391 ] >									
353 	//        < 0x000000000000000000000000000000000000000000001C446964161CC55DF711 >									
354 	//     < RE_Portfolio_XX_metadata_line_35_____XL_Reinsurance_20250515 >									
355 	//        < 7XNH3Vj6d0QA5Tpf41gT76Y506D5f0n4Txv7QEBXoqVZydHVfY85B00PecRlRjsp >									
356 	//        < 1E-018 limites [ 1235703534,37391 ; 1252742672,52579 ] >									
357 	//        < 0x000000000000000000000000000000000000000000001CC55DF7111D2AEDA068 >									
358 	//     < RE_Portfolio_XX_metadata_line_36_____ZEPmRE__PTA_Reinsurance_Company__Bp_20250515 >									
359 	//        < Tqzmk6D8pnfom0368z5989tVe21cSI2uxE34Dcn26uP1xB2iVB4Uflq842vR5616 >									
360 	//        < 1E-018 limites [ 1252742672,52579 ;  ] >									
361 	//        < 0x000000000000000000000000000000000000000000001D2AEDA0681EFAA6C21B >									
362 	//     < RE_Portfolio_XX_metadata_line_37_____Zurich_American_Insurance_Company_Ap_20250515 >									
363 	//        < 6qY6f82zQeVmj0DFzfbjC9Jg9WRQ4H8xRdM5pp0y7z9ZV34HO8l43f5FjD8JUuOH >									
364 	//        < 1E-018 limites [ 1330542510,47962 ; 1350126058,04154 ] >									
365 	//        < 0x000000000000000000000000000000000000000000001EFAA6C21B1F6F60E160 >									
366 	//     < RE_Portfolio_XX_metadata_line_38_____Zurich_Insurance_Co_Limited_20250515 >									
367 	//        < 04c4Afib79398Z8R4cYsE6mh81tFa4Y886YDNi23Eia6gGMm9nGfiYMThKKal7n8 >									
368 	//        < 1E-018 limites [ 1350126058,04154 ; 1365165733,05921 ] >									
369 	//        < 0x000000000000000000000000000000000000000000001F6F60E1601FC9059A6D >									
370 	//     < RE_Portfolio_XX_metadata_line_39_____Zurich_Insurance_Co_Limited_AAm_Ap_20250515 >									
371 	//        < 0kuQKPEPfh1FFo1l4T88DCNhE1fS41b6cC602h61N1yWp5Na30fZ2d7GD91HEN9u >									
372 	//        < 1E-018 limites [ 1365165733,05921 ; 1388842492,31882 ] >									
373 	//        < 0x000000000000000000000000000000000000000000001FC9059A6D2056257883 >									
374 	//     < RE_Portfolio_XX_metadata_line_40_____Zurich_Insurance_plc_AAm_Ap_20250515 >									
375 	//        < dKDRhqay9Ke447gf6Y1eezTQ25d8rmI6k9lVnWBzbjC7f1zk0YE9MFdUf0pNhj1B >									
376 	//        < 1E-018 limites [ 1388842492,31882 ; 1401819335,11693 ] >									
377 	//        < 0x00000000000000000000000000000000000000000000205625788320A37E8FBB >									
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