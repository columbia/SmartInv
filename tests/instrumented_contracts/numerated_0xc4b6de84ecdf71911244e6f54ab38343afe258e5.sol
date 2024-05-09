1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXXXVIII_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXXXVIII_I_883		"	;
8 		string	public		symbol =	"	RUSS_PFXXXVIII_I_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		610955832914656000000000000					;	
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
92 	//     < RUSS_PFXXXVIII_I_metadata_line_1_____AgroCenter_Ukraine_20211101 >									
93 	//        < cCuG4ze5ux1mXh51ko54T031gg1963W77a3vF1P77Y79MKjZJfCd6g6Efkoik6I8 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000017007031.165926900000000000 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000000019F35F >									
96 	//     < RUSS_PFXXXVIII_I_metadata_line_2_____Ural_RemStroiService_20211101 >									
97 	//        < 1cG33OLLVxKAWmA7OW0kiEu5CPD6592i0QaJw71lXhtt7P94Q95r9T9xsG5d6Sv9 >									
98 	//        <  u =="0.000000000000000001" : ] 000000017007031.165926900000000000 ; 000000030776290.003159100000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000019F35F2EF5FD >									
100 	//     < RUSS_PFXXXVIII_I_metadata_line_3_____Kingisepp_RemStroiService_20211101 >									
101 	//        < 1ATpnPJ14v5C6cVt2xOmdPJ3TVgpv1bZtDA7q0B1V5sobth6SjRnZob141xzLeCG >									
102 	//        <  u =="0.000000000000000001" : ] 000000030776290.003159100000000000 ; 000000046375860.674936900000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000002EF5FD46C392 >									
104 	//     < RUSS_PFXXXVIII_I_metadata_line_4_____Novomoskovsk_RemStroiService_20211101 >									
105 	//        < O1A42Rs7gPbMy78RbE89j76KKTJL9cVGlz6df322pg0Te8wS0f45nwh00FGSoVHU >									
106 	//        <  u =="0.000000000000000001" : ] 000000046375860.674936900000000000 ; 000000063555202.901192100000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000046C39260FA40 >									
108 	//     < RUSS_PFXXXVIII_I_metadata_line_5_____Nevinnomyssk_RemStroiService_20211101 >									
109 	//        < 42dxUE6clQq486PZZX169LY5eaY876666T3K7Fa5fId6CWS2ifVPSgICxP76pZ3V >									
110 	//        <  u =="0.000000000000000001" : ] 000000063555202.901192100000000000 ; 000000077908738.819311100000000000 ] >									
111 	//        < 0x000000000000000000000000000000000000000000000000000060FA4076E11A >									
112 	//     < RUSS_PFXXXVIII_I_metadata_line_6_____Volgograd_RemStroiService_20211101 >									
113 	//        < O8FdYK9UI1adw28c4F9nGpYUwoLWVYq63129KXa102pjAF662BmGcRN8bC96aU6N >									
114 	//        <  u =="0.000000000000000001" : ] 000000077908738.819311100000000000 ; 000000091237829.760619000000000000 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000000000076E11A8B37C7 >									
116 	//     < RUSS_PFXXXVIII_I_metadata_line_7_____Berezniki_Mechanical_Works_20211101 >									
117 	//        < n1DqvIxj3mrSVDOHAujSY900G5M0P0xfnJxsc3czRc4B1FYN5BA18UuiY8Yaxtvc >									
118 	//        <  u =="0.000000000000000001" : ] 000000091237829.760619000000000000 ; 000000107829709.576066000000000000 ] >									
119 	//        < 0x00000000000000000000000000000000000000000000000000008B37C7A488FB >									
120 	//     < RUSS_PFXXXVIII_I_metadata_line_8_____Tulagiprochim_JSC_20211101 >									
121 	//        < 4HTO5U0AS2o7hhF46OivEn10Q05L89vu293Y68w141GV4dl9fPr4u1k5OnyD9vyX >									
122 	//        <  u =="0.000000000000000001" : ] 000000107829709.576066000000000000 ; 000000121057188.219731000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000A488FBB8B7F7 >									
124 	//     < RUSS_PFXXXVIII_I_metadata_line_9_____TOMS_project_LLC_20211101 >									
125 	//        < qcOF8d9RO8u5t0X0DiIi9twN4Cr3xOoRxk815bgtXSNa55OB5121X6nP57EKmTsJ >									
126 	//        <  u =="0.000000000000000001" : ] 000000121057188.219731000000000000 ; 000000137858743.338727000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000000B8B7F7D25B12 >									
128 	//     < RUSS_PFXXXVIII_I_metadata_line_10_____Harvester_Shipmanagement_Ltd_20211101 >									
129 	//        < OBx34BI1X8qXIndqgYsIr7D2052b63WIT0x2Ad2CD83g5n288uCKi1QTGn5s36tZ >									
130 	//        <  u =="0.000000000000000001" : ] 000000137858743.338727000000000000 ; 000000154436918.452417000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000000D25B12EBA6EC >									
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
174 	//     < RUSS_PFXXXVIII_I_metadata_line_11_____EuroChem_Logistics_International_20211101 >									
175 	//        < Hgdr4m5B1rEs7YmE9Pa6OujpafQWvLfyj778B0fuWQvH8eFLv3sc06pi0s3SoKrN >									
176 	//        <  u =="0.000000000000000001" : ] 000000154436918.452417000000000000 ; 000000171305017.636570000000000000 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000000000EBA6EC1056406 >									
178 	//     < RUSS_PFXXXVIII_I_metadata_line_12_____EuroChem_Terminal_Sillamäe_Aktsiaselts_Logistics_20211101 >									
179 	//        < 3gG2IY8k3s6N5WGsLNED1WA9l84mKgqPikv2PvLwabw81N2u18I84LrkKduilFjd >									
180 	//        <  u =="0.000000000000000001" : ] 000000171305017.636570000000000000 ; 000000187013204.211598000000000000 ] >									
181 	//        < 0x00000000000000000000000000000000000000000000000000105640611D5C08 >									
182 	//     < RUSS_PFXXXVIII_I_metadata_line_13_____EuroChem_Terminal_Ust_Luga_20211101 >									
183 	//        < UxbR4b2vy5ZecDkSH8iAl1zA5Qt7627813dOrd5uznAC74G5N9459jbP855446Rh >									
184 	//        <  u =="0.000000000000000001" : ] 000000187013204.211598000000000000 ; 000000203771707.459052000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000011D5C08136EE53 >									
186 	//     < RUSS_PFXXXVIII_I_metadata_line_14_____Tuapse_Bulk_Terminal_20211101 >									
187 	//        < yCEwIHb71DsV939ea9g9xRaH84Z9W3N3V9il7fo18opcU4LZ6waXeS91G2JAlZfQ >									
188 	//        <  u =="0.000000000000000001" : ] 000000203771707.459052000000000000 ; 000000220566089.287018000000000000 ] >									
189 	//        < 0x00000000000000000000000000000000000000000000000000136EE531508EA1 >									
190 	//     < RUSS_PFXXXVIII_I_metadata_line_15_____Murmansk_Bulkcargo_Terminal_20211101 >									
191 	//        < l40R7RWk3RsKKo68badWzng1732otqi88VWq97LxEmvC50R70O8s31Xf4P0I5DD1 >									
192 	//        <  u =="0.000000000000000001" : ] 000000220566089.287018000000000000 ; 000000237784254.566414000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000001508EA116AD479 >									
194 	//     < RUSS_PFXXXVIII_I_metadata_line_16_____Depo_EuroChem_20211101 >									
195 	//        < v0R3TY0DR777mfRdlfausOQuEE1oo4Au3gPnnWGot7WWbG2040UJ4538BY3lF5W8 >									
196 	//        <  u =="0.000000000000000001" : ] 000000237784254.566414000000000000 ; 000000254946482.168659000000000000 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000000016AD4791850478 >									
198 	//     < RUSS_PFXXXVIII_I_metadata_line_17_____EuroChem_Energo_20211101 >									
199 	//        < 6M7gD5x1XHb8SvHt4l6s9iEgM5XwveN1lKAoXFm8kH2qzvTz8Zy74B8MkJpq5V5K >									
200 	//        <  u =="0.000000000000000001" : ] 000000254946482.168659000000000000 ; 000000270189341.238293000000000000 ] >									
201 	//        < 0x00000000000000000000000000000000000000000000000000185047819C46B6 >									
202 	//     < RUSS_PFXXXVIII_I_metadata_line_18_____EuroChem_Usolsky_Mining_sarl_20211101 >									
203 	//        < 2UV4j3hpn1udV4IWSez3RG6E2aV59ErS1vj9ArsLs1nItP2WAsb6rG6M38QLpX74 >									
204 	//        <  u =="0.000000000000000001" : ] 000000270189341.238293000000000000 ; 000000285440908.942603000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000019C46B61B38C5B >									
206 	//     < RUSS_PFXXXVIII_I_metadata_line_19_____EuroChem_International_Holding_BV_20211101 >									
207 	//        < 8ApjSIpaf9ZP884A8en8dIJPq38r276FAP0TqEFogG1XM4bUOd810GA4Inh3S654 >									
208 	//        <  u =="0.000000000000000001" : ] 000000285440908.942603000000000000 ; 000000302324187.312069000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000001B38C5B1CD4F63 >									
210 	//     < RUSS_PFXXXVIII_I_metadata_line_20_____Severneft_Urengoy_LLC_20211101 >									
211 	//        < dH1K739064Cvi2b30XYJTlQ29lsk9G0mdGfUkPH4id1x79WKPLO812fZDSuRr9Nt >									
212 	//        <  u =="0.000000000000000001" : ] 000000302324187.312069000000000000 ; 000000317875480.930161000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000001CD4F631E50A1C >									
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
256 	//     < RUSS_PFXXXVIII_I_metadata_line_21_____Agrinos_AS_20211101 >									
257 	//        < VP3vb9r1BYLBOL56yq544iMVSW5TDbI6CC09yM2D5C8zdbv35M98mcRvutKej515 >									
258 	//        <  u =="0.000000000000000001" : ] 000000317875480.930161000000000000 ; 000000330872158.542324000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000001E50A1C1F8DEF0 >									
260 	//     < RUSS_PFXXXVIII_I_metadata_line_22_____Hispalense_de_Líquidos_SL_20211101 >									
261 	//        < F6PYU1K3dHFI7358P6XhFSVYZ6hXGOfO2w255n8tbKk1VDPsOHiYWAX395Ki4j7S >									
262 	//        <  u =="0.000000000000000001" : ] 000000330872158.542324000000000000 ; 000000345542507.615846000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000001F8DEF020F418B >									
264 	//     < RUSS_PFXXXVIII_I_metadata_line_23_____Azottech_LLC_20211101 >									
265 	//        < 9G42AC097QO98Ny9R4p4q2REcZDDQrKb1BDVwn4k93tUw4wTMnUM7mes52OuCqL4 >									
266 	//        <  u =="0.000000000000000001" : ] 000000345542507.615846000000000000 ; 000000359841090.714820000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000020F418B22512ED >									
268 	//     < RUSS_PFXXXVIII_I_metadata_line_24_____EuroChem_Migao_Ltd_20211101 >									
269 	//        < PD5p392545trXM964aDTwt3wKq162GrA2n6rFBVUqL1576V9739YtDs6t3t89UDJ >									
270 	//        <  u =="0.000000000000000001" : ] 000000359841090.714820000000000000 ; 000000374673439.611105000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000022512ED23BB4D0 >									
272 	//     < RUSS_PFXXXVIII_I_metadata_line_25_____Thyssen_Schachtbau_EuroChem_Drilling_20211101 >									
273 	//        < 5CuavXrxpHFddn67nD4xk7WEZgm6CjaIefFYf9q9eRql91m4mfUAPbKw2gN1nNie >									
274 	//        <  u =="0.000000000000000001" : ] 000000374673439.611105000000000000 ; 000000388389270.015533000000000000 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000000000023BB4D0250A28F >									
276 	//     < RUSS_PFXXXVIII_I_metadata_line_26_____Biochem_Technologies_LLC_20211101 >									
277 	//        < PQ09lk1lR0Z7VV9R31SsZ816I2v6uR61zEl0OGhO83Ks4167uFl2Sc5tk4Ve1Dfu >									
278 	//        <  u =="0.000000000000000001" : ] 000000388389270.015533000000000000 ; 000000403635238.902788000000000000 ] >									
279 	//        < 0x00000000000000000000000000000000000000000000000000250A28F267E604 >									
280 	//     < RUSS_PFXXXVIII_I_metadata_line_27_____EuroChem_Agro_Bulgaria_Ead_20211101 >									
281 	//        < 0wX3hY7L9VdfbJVay294s57889NlhtkW5Kj43Iap3BpAEsmTM6g27UdIBPCpW17G >									
282 	//        <  u =="0.000000000000000001" : ] 000000403635238.902788000000000000 ; 000000420058703.400409000000000000 ] >									
283 	//        < 0x00000000000000000000000000000000000000000000000000267E604280F56E >									
284 	//     < RUSS_PFXXXVIII_I_metadata_line_28_____Emerger_Fertilizantes_SA_20211101 >									
285 	//        < J0v8XIuU9Eq1bJIK0Tpn8SYmSY1XpINPhTDy0iVgs4vUcCVQEk58MLi0m5HO01x2 >									
286 	//        <  u =="0.000000000000000001" : ] 000000420058703.400409000000000000 ; 000000434255779.011074000000000000 ] >									
287 	//        < 0x00000000000000000000000000000000000000000000000000280F56E2969F2A >									
288 	//     < RUSS_PFXXXVIII_I_metadata_line_29_____Agrocenter_EuroChem_Srl_20211101 >									
289 	//        < z37UAs0nLI45PAnQh9ZVxP46G28Slg99478b592GcP87E1Kah4wTE6577n2pyGAF >									
290 	//        <  u =="0.000000000000000001" : ] 000000434255779.011074000000000000 ; 000000447758518.397967000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000002969F2A2AB39AC >									
292 	//     < RUSS_PFXXXVIII_I_metadata_line_30_____AgroCenter_Ukraine_LLC_20211101 >									
293 	//        < 587H5gMy5plcPty9Z1nY68QxxQRcnGKp5tK4g7QDEMq5S5iyjTh5rEr55ggYH966 >									
294 	//        <  u =="0.000000000000000001" : ] 000000447758518.397967000000000000 ; 000000464944800.910828000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000002AB39AC2C57310 >									
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
338 	//     < RUSS_PFXXXVIII_I_metadata_line_31_____EuroChem_Agro_doo_Beograd_20211101 >									
339 	//        < 813d08sHU3J1W1mxwYqT870AcJP50NZAP7n59z2CXP041h3q7qRvmoii6jiOQkKD >									
340 	//        <  u =="0.000000000000000001" : ] 000000464944800.910828000000000000 ; 000000478644428.582492000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000002C573102DA5A7B >									
342 	//     < RUSS_PFXXXVIII_I_metadata_line_32_____TOMS_project_LLC_20211101 >									
343 	//        < ATS9U1yber3a2gZixijwiKegkG8Oxv7ABdblmlbB7Hx576LSs9rLxy1r1B1iba95 >									
344 	//        <  u =="0.000000000000000001" : ] 000000478644428.582492000000000000 ; 000000493669596.552099000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000002DA5A7B2F147B0 >									
346 	//     < RUSS_PFXXXVIII_I_metadata_line_33_____Agrosphere_20211101 >									
347 	//        < Eh9dIpAOu1xf2lQTUaO7hXIE4s5lClNSfMP34dPGk0Tkgq6hss8Ay1VAZTBLPgA5 >									
348 	//        <  u =="0.000000000000000001" : ] 000000493669596.552099000000000000 ; 000000508930587.208917000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000002F147B03089103 >									
350 	//     < RUSS_PFXXXVIII_I_metadata_line_34_____Bulkcargo_Terminal_LLC_20211101 >									
351 	//        < FGp1243exG4BqJW4NE69abqPHdb263PRnEL0iT62r9l330H24Ngb05kYObwEmKCV >									
352 	//        <  u =="0.000000000000000001" : ] 000000508930587.208917000000000000 ; 000000522221875.348460000000000000 ] >									
353 	//        < 0x00000000000000000000000000000000000000000000000000308910331CD8EC >									
354 	//     < RUSS_PFXXXVIII_I_metadata_line_35_____AgroCenter_EuroChem_Volgograd_20211101 >									
355 	//        < 6U78eOJQ596mcXXvGYm6v6FJuS9kpdCF55lST86NxdG1S9iUKYn66HotAS1WR3tV >									
356 	//        <  u =="0.000000000000000001" : ] 000000522221875.348460000000000000 ; 000000537837008.025478000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000031CD8EC334AC95 >									
358 	//     < RUSS_PFXXXVIII_I_metadata_line_36_____Trading_RUS_LLC_20211101 >									
359 	//        < P9Xu34lgB4mwcTEfUYJ6Bz0MjgkyL569D69Pf22905PRjAqkIieiBvmZSVaih2Kd >									
360 	//        <  u =="0.000000000000000001" : ] 000000537837008.025478000000000000 ; 000000551051529.389480000000000000 ] >									
361 	//        < 0x00000000000000000000000000000000000000000000000000334AC95348D681 >									
362 	//     < RUSS_PFXXXVIII_I_metadata_line_37_____AgroCenter_EuroChem_Krasnodar_LLC_20211101 >									
363 	//        < URhA6Nm7dcMHpa8ngz7eJ5CFFCJ5HWbG26ICh0j2BvrVnL98bFdnm1MnPEFL4IyA >									
364 	//        <  u =="0.000000000000000001" : ] 000000551051529.389480000000000000 ; 000000565482037.470179000000000000 ] >									
365 	//        < 0x00000000000000000000000000000000000000000000000000348D68135EDB6C >									
366 	//     < RUSS_PFXXXVIII_I_metadata_line_38_____AgroCenter_EuroChem_Lipetsk_LLC_20211101 >									
367 	//        < T6K3Trq82SrHAZ968rZ4zz61Mo89Ioc9tM6f2ZTt59KJcS8E8NcnOUoCG533R2Mz >									
368 	//        <  u =="0.000000000000000001" : ] 000000565482037.470179000000000000 ; 000000581384492.154951000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000035EDB6C3771F51 >									
370 	//     < RUSS_PFXXXVIII_I_metadata_line_39_____AgroCenter_EuroChem_Orel_LLC_20211101 >									
371 	//        < T9VDtb8X2WIz55Q207mM44Cg1P1eX362kYvnDTZ17YZ75ZBGDE89Stxj7x1uui5e >									
372 	//        <  u =="0.000000000000000001" : ] 000000581384492.154951000000000000 ; 000000594790504.730559000000000000 ] >									
373 	//        < 0x000000000000000000000000000000000000000000000000003771F5138B940A >									
374 	//     < RUSS_PFXXXVIII_I_metadata_line_40_____AgroCenter_EuroChem_Nevinnomyssk_LLC_20211101 >									
375 	//        < NwD4B5HMJPpJTsHTKleri6r8I4iMW88hwOoOgsCoO9z8dPUYz8k9Aypl56Yw2j7k >									
376 	//        <  u =="0.000000000000000001" : ] 000000594790504.730559000000000000 ; 000000610955832.914656000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000038B940A3A43E9F >									
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