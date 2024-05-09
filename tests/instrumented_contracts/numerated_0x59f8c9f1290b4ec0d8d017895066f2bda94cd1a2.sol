1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	TEHRAN_Portfolio_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	TEHRAN_Portfolio_I_883		"	;
8 		string	public		symbol =	"	TEHRAN883		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		2140354551050680000000000000					;	
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
92 	//     < TEHRAN_Portfolio_I_metadata_line_1_____Asan_Pardakht_Pers_20250515 >									
93 	//        < CJO0TdiK0uiWB0lIp8R4jD9W3NpZiV2O7ibv5Fe8AybOjP320HioFP404o3y9Nt8 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000061210881.473286600000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000037A0ED4 >									
96 	//     < TEHRAN_Portfolio_I_metadata_line_2_____Bank_Melli_Inv_20250515 >									
97 	//        < 757g2ap9JV3eU0k18t4IjG867qIE0rdcwu8N6u48FiFWUY46jYT16LEt481wAn3f >									
98 	//        <  u =="0.000000000000000001" : ] 000000061210881.473286600000000000 ; 000000116460677.664409000000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000037A0ED456471373 >									
100 	//     < TEHRAN_Portfolio_I_metadata_line_3_____Fajr_Petrochemical_20250515 >									
101 	//        < z1G01Kjfz6uI2KwkOM56ZgChx2CgjyKk8sTj279r591zck24pcKTXC0F6AJ41q3y >									
102 	//        <  u =="0.000000000000000001" : ] 000000116460677.664409000000000000 ; 000000171382463.440255000000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000564713732B64E852B >									
104 	//     < TEHRAN_Portfolio_I_metadata_line_4_____Mellat_Bank_20250515 >									
105 	//        < pvk5r3SRcL08r8v1XQh80R8B2gm5eASP39SiXaiC99i5WqLBpCDEwZtI0EAc0q45 >									
106 	//        <  u =="0.000000000000000001" : ] 000000171382463.440255000000000000 ; 000000208353305.657455000000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000002B64E852B4E34C5460 >									
108 	//     < TEHRAN_Portfolio_I_metadata_line_5_____Chadormalu_20250515 >									
109 	//        < li2TG8666iOSDrgJ878M2N3A3A19aN23Rt6xbvAarkDiHC30LsA226spOk3g1X06 >									
110 	//        <  u =="0.000000000000000001" : ] 000000208353305.657455000000000000 ; 000000252385082.637906000000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000004E34C54604ECBCF485 >									
112 	//     < TEHRAN_Portfolio_I_metadata_line_6_____Khouz_Steel_20250515 >									
113 	//        < MVG84bw9wR083X7q9lFvMNerqu7gRE3ZSZZ5avTX2654d8e5v3C5UHT37zJAffaL >									
114 	//        <  u =="0.000000000000000001" : ] 000000252385082.637906000000000000 ; 000000291751435.337723000000000000 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000004ECBCF48550ED00309 >									
116 	//     < TEHRAN_Portfolio_I_metadata_line_7_____Mobarakeh_Steel_20250515 >									
117 	//        < UxJ0h6Ub5rOFq3R8166mHcLevX5eXq2UfoutUTXo79ZCgSgp5H2YM5195ya512od >									
118 	//        <  u =="0.000000000000000001" : ] 000000291751435.337723000000000000 ; 000000343072100.951209000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000050ED00309816B8E20D >									
120 	//     < TEHRAN_Portfolio_I_metadata_line_8_____Ghadir_Inv_20250515 >									
121 	//        < 02muY5Ca7HZ7hB90ueT1yqyrE7CrihUYBS4RQIxtZCf1WJ1AKMcdBE490Q1GS84C >									
122 	//        <  u =="0.000000000000000001" : ] 000000343072100.951209000000000000 ; 000000397620165.608982000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000816B8E20DBFD699807 >									
124 	//     < TEHRAN_Portfolio_I_metadata_line_9_____Gol_E_Gohar_20250515 >									
125 	//        < c634eWNMtsB8lomjYCSBKrwg8B7rWBSS63Hb6Rs2suA5M79kGfMwImJD2eCIxnru >									
126 	//        <  u =="0.000000000000000001" : ] 000000397620165.608982000000000000 ; 000000476761514.460519000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000BFD699807C00CC925C >									
128 	//     < TEHRAN_Portfolio_I_metadata_line_10_____Iran_Mobil_Tele_20250515 >									
129 	//        < GHy2nJ8217UvQ686c3uN387nhYv6U0isPL0A6OCzz15k87aEhgULivrKHn9YXPIh >									
130 	//        <  u =="0.000000000000000001" : ] 000000476761514.460519000000000000 ; 000000541506851.333809000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000C00CC925CC8B19E052 >									
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
174 	//     < TEHRAN_Portfolio_I_metadata_line_11_____Iran_Khodro_20250515 >									
175 	//        < iX1B36lIfohy6nr8J15kvXJ3Y829npAH73PTQ3s5Jdqyt37fxLY08h0m3Izr4Rmo >									
176 	//        <  u =="0.000000000000000001" : ] 000000541506851.333809000000000000 ; 000000616108313.583000000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000C8B19E052C95A3ECBC >									
178 	//     < TEHRAN_Portfolio_I_metadata_line_12_____IRI_Marine_Co_20250515 >									
179 	//        < T2F2XmuSgNzql7yJb6XT21H1v3rlG73J0vXdve2vQ7w6d7ic8cbT8n2D1t5Tj32G >									
180 	//        <  u =="0.000000000000000001" : ] 000000616108313.583000000000000000 ; 000000652705135.584955000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000C95A3ECBCCA5EAC970 >									
182 	//     < TEHRAN_Portfolio_I_metadata_line_13_____Metals_Min_20250515 >									
183 	//        < H15yBY3c0C1ju5t0en19sux3msBqmf3842TQGL6nEyFFIGf609149v3lZ7dD83lM >									
184 	//        <  u =="0.000000000000000001" : ] 000000652705135.584955000000000000 ; 000000718182786.421577000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000CA5EAC970CFBA12F64 >									
186 	//     < TEHRAN_Portfolio_I_metadata_line_14_____MAPNA_20250515 >									
187 	//        < 8I82SG1yNK9kIuE30orKF7CJo33QZMiA176mkv66Mp26clRtE59npC78J3XoTE3a >									
188 	//        <  u =="0.000000000000000001" : ] 000000718182786.421577000000000000 ; 000000764558559.723822000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000CFBA12F64D359422C8 >									
190 	//     < TEHRAN_Portfolio_I_metadata_line_15_____Iran_Tele_Co_20250515 >									
191 	//        < i9Icd0eLY2D3iOvbZ5T5ZUZdBKrjxV4UI67M6yN05X2tdrWf2v4U9o7EP1jzrVXH >									
192 	//        <  u =="0.000000000000000001" : ] 000000764558559.723822000000000000 ; 000000841393243.264593000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000D359422C81191394DA5 >									
194 	//     < TEHRAN_Portfolio_I_metadata_line_16_____Mobin_Petr_20250515 >									
195 	//        < Ob9Ay7W1Ke7ngjrgl3zjBA12b4TCb408XF5zVG9me0e8qS2cMte82S1EBUO7u6g9 >									
196 	//        <  u =="0.000000000000000001" : ] 000000841393243.264593000000000000 ; 000000886895158.844619000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000001191394DA5119E78BA38 >									
198 	//     < TEHRAN_Portfolio_I_metadata_line_17_____I_N_C_Ind_20250515 >									
199 	//        < Uo1SlsPKjGhB5uH6t1f267811O3h36hElju09LS1B0927L2pK1XVg9q6XnuZ46Wp >									
200 	//        <  u =="0.000000000000000001" : ] 000000886895158.844619000000000000 ; 000000938814504.253922000000000000 ] >									
201 	//        < 0x00000000000000000000000000000000000000000000119E78BA3811A5A651C7 >									
202 	//     < TEHRAN_Portfolio_I_metadata_line_18_____Omid_Inv_Mng_20250515 >									
203 	//        < 0tu1Zf8X0xz03k3gWV0wtmLy885VT72o3buu8O33Uqqe7MGG0r2EDm20qNdiJ6ED >									
204 	//        <  u =="0.000000000000000001" : ] 000000938814504.253922000000000000 ; 000001006010100.736080000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000011A5A651C711A7337AA6 >									
206 	//     < TEHRAN_Portfolio_I_metadata_line_19_____Parsian_Oil_Gas_20250515 >									
207 	//        < gCJ4N8Sh229LFUkIGHD0Edfr94uYcASk8ISn8Y6YvraP0Hv9LJw5Gkoi916dYwj5 >									
208 	//        <  u =="0.000000000000000001" : ] 000001006010100.736080000000000000 ; 000001059393442.681370000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000011A7337AA611A80D764A >									
210 	//     < TEHRAN_Portfolio_I_metadata_line_20_____Fanavaran_Petr_20250515 >									
211 	//        < 5pO3wh9sB877u026945fUftWNnb18k228zyn7zQ1h3ej2yecR7sV45fufUQAiOdv >									
212 	//        <  u =="0.000000000000000001" : ] 000001059393442.681370000000000000 ; 000001103775973.755440000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000011A80D764A11A9E0DEC1 >									
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
256 	//     < TEHRAN_Portfolio_I_metadata_line_21_____Jam_Petr_20250515 >									
257 	//        < 1726okLV3BR36B6jG51TCfy1752d70ao1784LGFmKmazeSr8QPzqc5HCR423hTfE >									
258 	//        <  u =="0.000000000000000001" : ] 000001103775973.755440000000000000 ; 000001158796138.464220000000000000 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000011A9E0DEC11337C233DB >									
260 	//     < TEHRAN_Portfolio_I_metadata_line_22_____Khark_Petr_20250515 >									
261 	//        < QAo66E5QD3A49PdgO3b9nlA723XfFF66FT4WQBQ061P310a4byPSW8I2WROKI34Y >									
262 	//        <  u =="0.000000000000000001" : ] 000001158796138.464220000000000000 ; 000001238453992.454110000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000001337C233DB16FC133A49 >									
264 	//     < TEHRAN_Portfolio_I_metadata_line_23_____Khalij_Fars_20250515 >									
265 	//        < x6EWsrz1C66G4K0qBT7Rq0o3QQO95heFL95pAAv0J1Nmh3GM36Oqc7SR8G3LCwHE >									
266 	//        <  u =="0.000000000000000001" : ] 000001238453992.454110000000000000 ; 000001295153126.350380000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000016FC133A4916FCE8C776 >									
268 	//     < TEHRAN_Portfolio_I_metadata_line_24_____BA_Oil_Refinie_20250515 >									
269 	//        < BJ5571Q2TAEe0yKf6095R51u1Chuz5gTkGUkDJNi8kXGmn5me2R36Z387x880n7x >									
270 	//        <  u =="0.000000000000000001" : ] 000001295153126.350380000000000000 ; 000001331882490.001130000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000016FCE8C77616FE4B3578 >									
272 	//     < TEHRAN_Portfolio_I_metadata_line_25_____Isf_Oil_Ref_Co_20250515 >									
273 	//        < 4wkB3H1Ejh5q96FEr1h68EX4qHYV1898VzqMf7hw4eZ4jA6YNs50VK3Kp8GFlRW5 >									
274 	//        <  u =="0.000000000000000001" : ] 000001331882490.001130000000000000 ; 000001372467359.378910000000000000 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000016FE4B357817094B7C8A >									
276 	//     < TEHRAN_Portfolio_I_metadata_line_26_____Pardis_Petr_20250515 >									
277 	//        < 6976Bf6rB8xqvt53nWO02IblZ6i6IBlKYEvSi5q5KgDS7JoWns3TpY7DM22Zg2t0 >									
278 	//        <  u =="0.000000000000000001" : ] 000001372467359.378910000000000000 ; 000001442005160.931830000000000000 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000017094B7C8A170A9FCB93 >									
280 	//     < TEHRAN_Portfolio_I_metadata_line_27_____Tamin_Petro_20250515 >									
281 	//        < UE9Plj5Xu1xts7r9TFR8J8S9WKjr74p6C4ns1l92ax9IUqLGwxWq636nr52H2V63 >									
282 	//        <  u =="0.000000000000000001" : ] 000001442005160.931830000000000000 ; 000001483346707.538130000000000000 ] >									
283 	//        < 0x00000000000000000000000000000000000000000000170A9FCB931710216274 >									
284 	//     < TEHRAN_Portfolio_I_metadata_line_28_____Palayesh_Tehran_20250515 >									
285 	//        < wh6Be2p87jY5L256U64dUkul4K3Sm3l53w90vrY3hIq5xh9NCEWBROZhs3Z8vIyU >									
286 	//        <  u =="0.000000000000000001" : ] 000001483346707.538130000000000000 ; 000001536886446.281760000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000017102162741710DAFC71 >									
288 	//     < TEHRAN_Portfolio_I_metadata_line_29_____Pension_Fund_20250515 >									
289 	//        < zyCBwuXC1p4RKGez6gucHmUFrb33bRDe6sdpRSmyH8n17SQ2KpQCAI7bkLN8Kb7q >									
290 	//        <  u =="0.000000000000000001" : ] 000001536886446.281760000000000000 ; 000001609848020.489690000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000001710DAFC71171F5B98B4 >									
292 	//     < TEHRAN_Portfolio_I_metadata_line_30_____Saipa_20250515 >									
293 	//        < 3eHX0wKcN8iu78t3Pw18C16cTZnE6Y3e438G7AbLOw6kvv9lT0wr9864e2ehLVaL >									
294 	//        <  u =="0.000000000000000001" : ] 000001609848020.489690000000000000 ; 000001670977351.576980000000000000 ] >									
295 	//        < 0x00000000000000000000000000000000000000000000171F5B98B41B22EC3D9C >									
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
338 	//     < TEHRAN_Portfolio_I_metadata_line_31_____Hegmatan_Sugar_20250515 >									
339 	//        < eL4Rp6K62TfJG0hFW59g8fQ3Y3QwIHU8asGPgzHz12LeM1fXAT392JR8z7qTx54F >									
340 	//        <  u =="0.000000000000000001" : ] 000001670977351.576980000000000000 ; 000001719124820.482130000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000001B22EC3D9C1E0D333C03 >									
342 	//     < TEHRAN_Portfolio_I_metadata_line_32_____F_Kh_Cement_20250515 >									
343 	//        < mo2Z231Z1R1ea7LN4v27p68qZGskf5V8f1480pM70GL0j8AcGSuoE1pmh5M0G7DU >									
344 	//        <  u =="0.000000000000000001" : ] 000001719124820.482130000000000000 ; 000001776529382.001640000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000001E0D333C031E29356C3E >									
346 	//     < TEHRAN_Portfolio_I_metadata_line_33_____Iran_Aluminium_20250515 >									
347 	//        < L5hatOCJ2sTdQL9yx94tnOXPn2vYG0Vz3R0YXbvgoq3hwp7ErDFCYMeSY96J39T8 >									
348 	//        <  u =="0.000000000000000001" : ] 000001776529382.001640000000000000 ; 000001820306550.556860000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000001E29356C3E1E2A15F705 >									
350 	//     < TEHRAN_Portfolio_I_metadata_line_34_____Margarin_20250515 >									
351 	//        < bphJ456D5Z23iI03dD0VKnq3u5m40GBHl6jX90E7U4QlKcsnruL030C052L91oJw >									
352 	//        <  u =="0.000000000000000001" : ] 000001820306550.556860000000000000 ; 000001870624899.426850000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000001E2A15F7051E37D2E629 >									
354 	//     < TEHRAN_Portfolio_I_metadata_line_35_____Qayen_Cement_20250515 >									
355 	//        < P0470BCzNVwuvg1I8b0y9Vb5Mwu38Wg3O01kQc5Q6371xfrn99FS2Ejy2Nk74IM7 >									
356 	//        <  u =="0.000000000000000001" : ] 000001870624899.426850000000000000 ; 000001916006437.994380000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000001E37D2E62921F0EF1D76 >									
358 	//     < TEHRAN_Portfolio_I_metadata_line_36_____Isfahan_Cement_20250515 >									
359 	//        < yva9qPHPK9KRQxI2tvQ014Rzdy16z8Wu2aO0n2m28oBCgBPgU5YfBZRmElB6Gj2D >									
360 	//        <  u =="0.000000000000000001" : ] 000001916006437.994380000000000000 ; 000001974212601.827640000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000021F0EF1D7623C829D434 >									
362 	//     < TEHRAN_Portfolio_I_metadata_line_37_____Mazandaran_Cement_20250515 >									
363 	//        < v63MfSre8ZYIHEe9Y4KC5p7TkZ1yGRn5m1tcyY9xRHJuEXKy9e9D1x5QlBZ3QCsg >									
364 	//        <  u =="0.000000000000000001" : ] 000001974212601.827640000000000000 ; 000002022950243.758070000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000023C829D43423C95BAE77 >									
366 	//     < TEHRAN_Portfolio_I_metadata_line_38_____Tejarat_Bank_20250515 >									
367 	//        < GqHPds8351RtcMFWlC7Br4YizCVYqNs0cqebOof6c9AvePio0cuz494TQjtJa49j >									
368 	//        <  u =="0.000000000000000001" : ] 000002022950243.758070000000000000 ; 000002061752131.332030000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000023C95BAE7724A65522E8 >									
370 	//     < TEHRAN_Portfolio_I_metadata_line_39_____Ghazvin_Sugar_20250515 >									
371 	//        < 1BM3s10ziD4aeqRO5eS5H91Kk9810r9CD5P0do8T05NB4f43Z2rK8Gfs9Md6Q7rS >									
372 	//        <  u =="0.000000000000000001" : ] 000002061752131.332030000000000000 ; 000002103894666.113420000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000024A65522E824C0198909 >									
374 	//     < TEHRAN_Portfolio_I_metadata_line_40_____Mashad_Wheel_20250515 >									
375 	//        < mKRtx4cQf930aNdKWa2CNyN23F8gLJZcqmBpp4K9R8DtA38hhu7x68B9KU1KK36I >									
376 	//        <  u =="0.000000000000000001" : ] 000002103894666.113420000000000000 ; 000002140354551.050680000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000024C019890924C8475D18 >									
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