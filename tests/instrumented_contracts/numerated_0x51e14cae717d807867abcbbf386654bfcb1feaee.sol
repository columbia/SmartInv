1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXXXVIII_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXXXVIII_III_883		"	;
8 		string	public		symbol =	"	RUSS_PFXXXVIII_III_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1014443586386180000000000000					;	
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
92 	//     < RUSS_PFXXXVIII_III_metadata_line_1_____AgroCenter_Ukraine_20251101 >									
93 	//        < R6403QLaG18Pg9fN8E7l0lgGC2is2TzXPwE4fbS3DKi2A6c07M1L504vf974DdjX >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000018300232.307800600000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000001BEC87 >									
96 	//     < RUSS_PFXXXVIII_III_metadata_line_2_____Ural_RemStroiService_20251101 >									
97 	//        < knrm36d58yzmNOsVRb1Sun2C0JjYVoJiD810ndD004JE5686PXn8gshE10Q63P37 >									
98 	//        <  u =="0.000000000000000001" : ] 000000018300232.307800600000000000 ; 000000040770878.452519100000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000001BEC873E3620 >									
100 	//     < RUSS_PFXXXVIII_III_metadata_line_3_____Kingisepp_RemStroiService_20251101 >									
101 	//        < 7BuhML4O3CbB9V0961e3E57rKUR21WxVqXSd53p26Yk9B6vX7bs4DX3t4KfnwQVL >									
102 	//        <  u =="0.000000000000000001" : ] 000000040770878.452519100000000000 ; 000000064037634.604005600000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000003E362061B6B3 >									
104 	//     < RUSS_PFXXXVIII_III_metadata_line_4_____Novomoskovsk_RemStroiService_20251101 >									
105 	//        < HTofWBPG1Vhk6TE48clUCu5Nd3265Ec0Z0Ay4dUgoj4Rx3Q2RwsT2e994FBG14B3 >									
106 	//        <  u =="0.000000000000000001" : ] 000000064037634.604005600000000000 ; 000000084669819.457299500000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000061B6B3813226 >									
108 	//     < RUSS_PFXXXVIII_III_metadata_line_5_____Nevinnomyssk_RemStroiService_20251101 >									
109 	//        < 7EfF8hGg0qS8ETFDo7N46HRYQ5f48H7EBrnoIOE6Q8ydV4E13D6W70QVxV74p7G1 >									
110 	//        <  u =="0.000000000000000001" : ] 000000084669819.457299500000000000 ; 000000103394247.572648000000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000008132269DC461 >									
112 	//     < RUSS_PFXXXVIII_III_metadata_line_6_____Volgograd_RemStroiService_20251101 >									
113 	//        < 2SrL7I6iNYQa3cd3ud63HxoLY9aMFIxVyq42v0rR300h96d6tNzsR1v8c3EA91ei >									
114 	//        <  u =="0.000000000000000001" : ] 000000103394247.572648000000000000 ; 000000126533589.611217000000000000 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000000000009DC461C1132F >									
116 	//     < RUSS_PFXXXVIII_III_metadata_line_7_____Berezniki_Mechanical_Works_20251101 >									
117 	//        < 7w6l0EgTq53E4b2K8im3RN9E10XL6PruEREAe4Y20m68E8DFb23Yb1BW4iYcpAXd >									
118 	//        <  u =="0.000000000000000001" : ] 000000126533589.611217000000000000 ; 000000150559320.642654000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000C1132FE5BC3C >									
120 	//     < RUSS_PFXXXVIII_III_metadata_line_8_____Tulagiprochim_JSC_20251101 >									
121 	//        < Lariy7GzG9F66K50kOzDiH72s2b2bWZ3qO4hF4bh9TYrbacez0X3yph2133RI3OC >									
122 	//        <  u =="0.000000000000000001" : ] 000000150559320.642654000000000000 ; 000000180904225.300376000000000000 ] >									
123 	//        < 0x000000000000000000000000000000000000000000000000000E5BC3C11409B7 >									
124 	//     < RUSS_PFXXXVIII_III_metadata_line_9_____TOMS_project_LLC_20251101 >									
125 	//        < d9N44HBP4NPa1Mb572dZ52iZWn183WVFX7yTFrB265RgGvx8UnnJu728l49Tn45q >									
126 	//        <  u =="0.000000000000000001" : ] 000000180904225.300376000000000000 ; 000000200845044.501444000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000011409B71327718 >									
128 	//     < RUSS_PFXXXVIII_III_metadata_line_10_____Harvester_Shipmanagement_Ltd_20251101 >									
129 	//        < vecb0Q2yKL7xDle72f120TbBwCKghC34RwyJsj4gQkTIE2J1r48kPOC60hn24TXK >									
130 	//        <  u =="0.000000000000000001" : ] 000000200845044.501444000000000000 ; 000000224611548.925615000000000000 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000000001327718156BAE3 >									
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
174 	//     < RUSS_PFXXXVIII_III_metadata_line_11_____EuroChem_Logistics_International_20251101 >									
175 	//        < pq4f43O17DF93NZgAvdr4K5G5Mh4VMTJbvgz9us3q94zCa2C4Iyr18Ng3sC7zmFo >									
176 	//        <  u =="0.000000000000000001" : ] 000000224611548.925615000000000000 ; 000000246192473.077246000000000000 ] >									
177 	//        < 0x00000000000000000000000000000000000000000000000000156BAE3177A8EF >									
178 	//     < RUSS_PFXXXVIII_III_metadata_line_12_____EuroChem_Terminal_Sillamäe_Aktsiaselts_Logistics_20251101 >									
179 	//        < zNohBDY5uv9550uo92PYh1pN11g1zS2ArCpmKKz113WDBg5SaxFv7cn8I8A2Jy3N >									
180 	//        <  u =="0.000000000000000001" : ] 000000246192473.077246000000000000 ; 000000266021804.203665000000000000 ] >									
181 	//        < 0x00000000000000000000000000000000000000000000000000177A8EF195EAC4 >									
182 	//     < RUSS_PFXXXVIII_III_metadata_line_13_____EuroChem_Terminal_Ust_Luga_20251101 >									
183 	//        < ESu3Mt6l8i08N6oMO31L8J5y063O1W2OYONj0if4D8bkCD4gIZ7Sp3Jvfl258B7Q >									
184 	//        <  u =="0.000000000000000001" : ] 000000266021804.203665000000000000 ; 000000297708283.938315000000000000 ] >									
185 	//        < 0x00000000000000000000000000000000000000000000000000195EAC41C6444C >									
186 	//     < RUSS_PFXXXVIII_III_metadata_line_14_____Tuapse_Bulk_Terminal_20251101 >									
187 	//        < V3cE6j6Kaen3uO9ukCe882Sh2NS0MIH544VCwRMZ49nTn0FcM409EWi2e1RS0vdH >									
188 	//        <  u =="0.000000000000000001" : ] 000000297708283.938315000000000000 ; 000000325978724.885702000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000001C6444C1F16770 >									
190 	//     < RUSS_PFXXXVIII_III_metadata_line_15_____Murmansk_Bulkcargo_Terminal_20251101 >									
191 	//        < 9f0Zy5O6EV3BVTRJgEjT06e6yFtrmmP1MELVKWSXPD506euEs7kV60tDw04xSnk3 >									
192 	//        <  u =="0.000000000000000001" : ] 000000325978724.885702000000000000 ; 000000356078392.149240000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000001F1677021F551F >									
194 	//     < RUSS_PFXXXVIII_III_metadata_line_16_____Depo_EuroChem_20251101 >									
195 	//        < HTOQfzK67gPeuj9J87mOXLY32p8L5l13oIHR1W61643no9LJZwtywB8JnVH234DJ >									
196 	//        <  u =="0.000000000000000001" : ] 000000356078392.149240000000000000 ; 000000387326734.641449000000000000 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000000021F551F24F0381 >									
198 	//     < RUSS_PFXXXVIII_III_metadata_line_17_____EuroChem_Energo_20251101 >									
199 	//        < AQT06TpF7LsG6Yy272I9ueIQ5T3S6D5Ah4fWExw1I5Iq32fx76RB4LOu0I3630sp >									
200 	//        <  u =="0.000000000000000001" : ] 000000387326734.641449000000000000 ; 000000407476893.915111000000000000 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000000024F038126DC2A9 >									
202 	//     < RUSS_PFXXXVIII_III_metadata_line_18_____EuroChem_Usolsky_Mining_sarl_20251101 >									
203 	//        < 5ThwXsCVhko655950SIX227497OuT4GKSQ2taAkM0w94b3QWFWLmYu864OI3zDwz >									
204 	//        <  u =="0.000000000000000001" : ] 000000407476893.915111000000000000 ; 000000434122886.677578000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000026DC2A92966B41 >									
206 	//     < RUSS_PFXXXVIII_III_metadata_line_19_____EuroChem_International_Holding_BV_20251101 >									
207 	//        < OYJRW45DRWpa0W5VN4JOWQpbNxj58t3FOwT3IKEA3E1g08sdkMU9c093O9dhaAIS >									
208 	//        <  u =="0.000000000000000001" : ] 000000434122886.677578000000000000 ; 000000465362413.890661000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000002966B412C61631 >									
210 	//     < RUSS_PFXXXVIII_III_metadata_line_20_____Severneft_Urengoy_LLC_20251101 >									
211 	//        < RQcX69IKyupUAdkwRDH7Qqc1ncancsKLgI8DtXk3mNlBU0pMh2zKAPbDw28t1C96 >									
212 	//        <  u =="0.000000000000000001" : ] 000000465362413.890661000000000000 ; 000000486714440.193668000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000002C616312E6AAD4 >									
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
256 	//     < RUSS_PFXXXVIII_III_metadata_line_21_____Agrinos_AS_20251101 >									
257 	//        < 96s8Wdk00J77Ii8r4nemM54E2tL1e3odugkVU8ENT6cRt521KwoxbMS6nEK72ijS >									
258 	//        <  u =="0.000000000000000001" : ] 000000486714440.193668000000000000 ; 000000507803957.278543000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000002E6AAD4306D8EC >									
260 	//     < RUSS_PFXXXVIII_III_metadata_line_22_____Hispalense_de_Líquidos_SL_20251101 >									
261 	//        < ABLaZlj7JSEtxGk7iWWeT29Rw7q2a0kglVMAKCnY14X1ep7y7e27H522wjzeu5xN >									
262 	//        <  u =="0.000000000000000001" : ] 000000507803957.278543000000000000 ; 000000537944504.918649000000000000 ] >									
263 	//        < 0x00000000000000000000000000000000000000000000000000306D8EC334D692 >									
264 	//     < RUSS_PFXXXVIII_III_metadata_line_23_____Azottech_LLC_20251101 >									
265 	//        < hIpovdtvA2BL4HLrLq0P82D8X3GEEnVI7hPvE4PiHEE7UhJ258hzE7o6pA1j0Tll >									
266 	//        <  u =="0.000000000000000001" : ] 000000537944504.918649000000000000 ; 000000563705935.176902000000000000 ] >									
267 	//        < 0x00000000000000000000000000000000000000000000000000334D69235C25A2 >									
268 	//     < RUSS_PFXXXVIII_III_metadata_line_24_____EuroChem_Migao_Ltd_20251101 >									
269 	//        < sDI1eYV2LELHO6ceQQj73LSyk2HAsfHQ1PJYe607n1Kio2odUH3Rbk2nxdkcR4b7 >									
270 	//        <  u =="0.000000000000000001" : ] 000000563705935.176902000000000000 ; 000000590221539.208861000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000035C25A23849B4A >									
272 	//     < RUSS_PFXXXVIII_III_metadata_line_25_____Thyssen_Schachtbau_EuroChem_Drilling_20251101 >									
273 	//        < 97DCicY3XZI66CqOLb8Hx5a3VGNds1J6N57KBlFlO292a45Dh5pEoBC9Q2QPf28o >									
274 	//        <  u =="0.000000000000000001" : ] 000000590221539.208861000000000000 ; 000000625414043.963730000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000003849B4A3BA4E5C >									
276 	//     < RUSS_PFXXXVIII_III_metadata_line_26_____Biochem_Technologies_LLC_20251101 >									
277 	//        < 0NYvuM15ePwOS4dicl7277TaN2VV954bIG1gSMe8n9d54KlM5qay9wM4nsDfkvVi >									
278 	//        <  u =="0.000000000000000001" : ] 000000625414043.963730000000000000 ; 000000654959339.870036000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000003BA4E5C3E7637E >									
280 	//     < RUSS_PFXXXVIII_III_metadata_line_27_____EuroChem_Agro_Bulgaria_Ead_20251101 >									
281 	//        < A9kaWZm26vBB8O3ly71fRQ2P2dK8U7KFLEMuSTautEO3q6N5K6zli61LjDK9bb8p >									
282 	//        <  u =="0.000000000000000001" : ] 000000654959339.870036000000000000 ; 000000680129595.797486000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000003E7637E40DCBA0 >									
284 	//     < RUSS_PFXXXVIII_III_metadata_line_28_____Emerger_Fertilizantes_SA_20251101 >									
285 	//        < 044730y7f7QB9Yr9gjPz7H4vkqmnwk8vNKx3J7CufT58yZFNGAF145m6eObBsBv1 >									
286 	//        <  u =="0.000000000000000001" : ] 000000680129595.797486000000000000 ; 000000700610223.923581000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000040DCBA042D0BDE >									
288 	//     < RUSS_PFXXXVIII_III_metadata_line_29_____Agrocenter_EuroChem_Srl_20251101 >									
289 	//        < Wd3pc7JV4Tff586g9cxIX486ue3V8K803J8r86c430O5ST9BJEDuHBJJLt5j20a0 >									
290 	//        <  u =="0.000000000000000001" : ] 000000700610223.923581000000000000 ; 000000730480790.601615000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000042D0BDE45AA00F >									
292 	//     < RUSS_PFXXXVIII_III_metadata_line_30_____AgroCenter_Ukraine_LLC_20251101 >									
293 	//        < r7GU1iNm37ulRQTafum1va5qAFbrGl5J1nA8hC4yOjDB1erK9lW6tIV7oi07Wo8G >									
294 	//        <  u =="0.000000000000000001" : ] 000000730480790.601615000000000000 ; 000000750288038.997981000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000045AA00F478D944 >									
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
338 	//     < RUSS_PFXXXVIII_III_metadata_line_31_____EuroChem_Agro_doo_Beograd_20251101 >									
339 	//        < yk3Z9c0uE11989b0N5sX3Sw7TEC3sMb2b2R95rIt6LpP3K6B9SCZGXjyJ5igXQuP >									
340 	//        <  u =="0.000000000000000001" : ] 000000750288038.997981000000000000 ; 000000769276320.972471000000000000 ] >									
341 	//        < 0x00000000000000000000000000000000000000000000000000478D944495D290 >									
342 	//     < RUSS_PFXXXVIII_III_metadata_line_32_____TOMS_project_LLC_20251101 >									
343 	//        < OOyPf55b9WcGSA5kvZwj94vlKoaw4ag26isw2O5Ev0O4gqn85033d8Sg1GD16VrO >									
344 	//        <  u =="0.000000000000000001" : ] 000000769276320.972471000000000000 ; 000000797285250.690125000000000000 ] >									
345 	//        < 0x00000000000000000000000000000000000000000000000000495D2904C08F8D >									
346 	//     < RUSS_PFXXXVIII_III_metadata_line_33_____Agrosphere_20251101 >									
347 	//        < 039T69eBk6wOwWb55WDkcNe4Pk8FXZyT090Z5qxYiY38mD59F6377veBURm77bSO >									
348 	//        <  u =="0.000000000000000001" : ] 000000797285250.690125000000000000 ; 000000826778882.019355000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000004C08F8D4ED9080 >									
350 	//     < RUSS_PFXXXVIII_III_metadata_line_34_____Bulkcargo_Terminal_LLC_20251101 >									
351 	//        < 2ycGFKab1A25eC7fh69i6j2oheYDM3sydD9511Mq6aXnoM7lEOnUz0rux2xZC1e8 >									
352 	//        <  u =="0.000000000000000001" : ] 000000826778882.019355000000000000 ; 000000846550314.792749000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000004ED908050BBBB7 >									
354 	//     < RUSS_PFXXXVIII_III_metadata_line_35_____AgroCenter_EuroChem_Volgograd_20251101 >									
355 	//        < 2e3bY2E93nCuny8l8B09xiA7Tk5c7tO15CpW0M6J4Eirar1lwF663Yt4JRB3P3kf >									
356 	//        <  u =="0.000000000000000001" : ] 000000846550314.792749000000000000 ; 000000878539452.688056000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000050BBBB753C8B79 >									
358 	//     < RUSS_PFXXXVIII_III_metadata_line_36_____Trading_RUS_LLC_20251101 >									
359 	//        < 9tp6j5bX49z8J17pK5051j72ra857Z6qB90RZQWEV0KIYtxaE3t3MdMHBp6iK9qr >									
360 	//        <  u =="0.000000000000000001" : ] 000000878539452.688056000000000000 ; 000000897811629.288034000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000053C8B79559F3AB >									
362 	//     < RUSS_PFXXXVIII_III_metadata_line_37_____AgroCenter_EuroChem_Krasnodar_LLC_20251101 >									
363 	//        < lP94Sm1IQvpA4Uehi0clPhqI2eo277DiEa6GMfVXeNKjJ9f5Mam4NBdw8IonHE72 >									
364 	//        <  u =="0.000000000000000001" : ] 000000897811629.288034000000000000 ; 000000926813515.165664000000000000 ] >									
365 	//        < 0x00000000000000000000000000000000000000000000000000559F3AB5863488 >									
366 	//     < RUSS_PFXXXVIII_III_metadata_line_38_____AgroCenter_EuroChem_Lipetsk_LLC_20251101 >									
367 	//        < 6sR9LaVa27u66D3t86Co4IjwWfH0I6tz4OmKC4UEIb91bf2elc3c52dQLKQm5uRT >									
368 	//        <  u =="0.000000000000000001" : ] 000000926813515.165664000000000000 ; 000000954487608.394134000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000058634885B06EB9 >									
370 	//     < RUSS_PFXXXVIII_III_metadata_line_39_____AgroCenter_EuroChem_Orel_LLC_20251101 >									
371 	//        < VohwMlF5ug4A48018NsyWrxsoIQ1bZx5uZ5TUD973Y691N8iSwss3tw5YKLzcOWT >									
372 	//        <  u =="0.000000000000000001" : ] 000000954487608.394134000000000000 ; 000000979759897.953180000000000000 ] >									
373 	//        < 0x000000000000000000000000000000000000000000000000005B06EB95D6FEB6 >									
374 	//     < RUSS_PFXXXVIII_III_metadata_line_40_____AgroCenter_EuroChem_Nevinnomyssk_LLC_20251101 >									
375 	//        < cCzJ6124hppD4yv8O9y3mCs3dpcLv75TZdFo4hS04pUqD3803926t3I4Iv85A7Rr >									
376 	//        <  u =="0.000000000000000001" : ] 000000979759897.953180000000000000 ; 000001014443586.386180000000000000 ] >									
377 	//        < 0x000000000000000000000000000000000000000000000000005D6FEB660BEB07 >									
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