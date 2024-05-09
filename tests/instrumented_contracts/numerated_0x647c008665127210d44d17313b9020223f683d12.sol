1 pragma solidity 		^0.4.25	;						
2 										
3 	contract	CHEMCHINA_PFV_II_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	CHEMCHINA_PFV_II_883		"	;
8 		string	public		symbol =	"	CHEMCHINA_PFV_II_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		761071890098368000000000000					;	
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
92 	//     < CHEMCHINA_PFV_II_metadata_line_1_____Psyclo_Peptide,_inc__20240321 >									
93 	//        < H9NLH7be4xv978YbuY0GtZ0WkBtX2921k5WWDq3Bfq9pDb6XHtHk3NB2Kb2IcqNG >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000022143971.113411000000000000 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000000021C9FD >									
96 	//     < CHEMCHINA_PFV_II_metadata_line_2_____Purestar_Chem_Enterprise_Co_Limited_20240321 >									
97 	//        < dcI633eMsLOqn2S2z5nc7Z72Zgof80A89gh6xOIldXL3zLP236Y5Yt1BltCHmj3V >									
98 	//        <  u =="0.000000000000000001" : ] 000000022143971.113411000000000000 ; 000000039697668.106307900000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000021C9FD3C92E7 >									
100 	//     < CHEMCHINA_PFV_II_metadata_line_3_____Puyer_BioPharma_20240321 >									
101 	//        < 21F39mwL0m8a0UiYfyrkxJZ8A41o8C6pp65wp2xhZmuV81BzmTX9MCh6579DWm62 >									
102 	//        <  u =="0.000000000000000001" : ] 000000039697668.106307900000000000 ; 000000056134398.387238800000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000003C92E755A780 >									
104 	//     < CHEMCHINA_PFV_II_metadata_line_4_____Qi_Chem_org_20240321 >									
105 	//        < I9ag27Bi1Cp8E2A15liCyq36Vq7Eq32EvrOa297Esdi1o4461603wi5czV7kjAb1 >									
106 	//        <  u =="0.000000000000000001" : ] 000000056134398.387238800000000000 ; 000000071900266.733177300000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000055A7806DB60B >									
108 	//     < CHEMCHINA_PFV_II_metadata_line_5_____Qi_Chem_Co_Limited_20240321 >									
109 	//        < 0EJ7oCRwYIF28F37lk0fxfk25ZaUySCS1BA41d85xR0fFxo0ceItm8ZGAyNp4rr4 >									
110 	//        <  u =="0.000000000000000001" : ] 000000071900266.733177300000000000 ; 000000093947680.924639600000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000006DB60B8F5A50 >									
112 	//     < CHEMCHINA_PFV_II_metadata_line_6_____Qingdao_Yimingxiang_Fine_Chemical_Technology_Co_Limited_20240321 >									
113 	//        < PGQmZnif03N5haAc8YTluMG7Tbp88jm8dyo1mO1q186siYpb3iF3X0NoHHT9d328 >									
114 	//        <  u =="0.000000000000000001" : ] 000000093947680.924639600000000000 ; 000000109977040.237435000000000000 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000000000008F5A50A7CFC8 >									
116 	//     < CHEMCHINA_PFV_II_metadata_line_7_____Qinmu_fine_chemical_Co_Limited_20240321 >									
117 	//        < 3ZZAC23ORqayHL1PsNc76BG5IhIfa31g9HiW749k1R41WB24HWRtXwbxwInJJUrC >									
118 	//        <  u =="0.000000000000000001" : ] 000000109977040.237435000000000000 ; 000000132331538.286043000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000A7CFC8C9EC02 >									
120 	//     < CHEMCHINA_PFV_II_metadata_line_8_____Quzhou_Ruiyuan_Chemical_Co_Limited_20240321 >									
121 	//        < 8nJ5yzOXFWLwmiuw4iP5SwD4fSnvqfCm6KAB6TGKF0G25rDHE2GMy2tDc8H54Abk >									
122 	//        <  u =="0.000000000000000001" : ] 000000132331538.286043000000000000 ; 000000152007740.376851000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000C9EC02E7F206 >									
124 	//     < CHEMCHINA_PFV_II_metadata_line_9_____RennoTech_Co__Limited_20240321 >									
125 	//        < V9q5Hx27708NGVW848VB9S5dsJK2132uD8rGh9j7c2uE47W4o5yT7N1a515Bt7s9 >									
126 	//        <  u =="0.000000000000000001" : ] 000000152007740.376851000000000000 ; 000000168056767.468498000000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000000E7F2061006F2D >									
128 	//     < CHEMCHINA_PFV_II_metadata_line_10_____Richap_Chem_20240321 >									
129 	//        < Md9B3wV0zsZ2KX19hT9W8XZ1NQa2OYLI3Ldk623G9kn75CA2s7D8h944Oj9ZvYb7 >									
130 	//        <  u =="0.000000000000000001" : ] 000000168056767.468498000000000000 ; 000000187563049.500217000000000000 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000000001006F2D11E32D1 >									
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
174 	//     < CHEMCHINA_PFV_II_metadata_line_11_____Ronas_Chemicals_org_20240321 >									
175 	//        < uaRMCDvijm2Kaco4tPpIL4ZVwpc1L5PY9owxQe1rbOo92774wFpLL39LwE629L3V >									
176 	//        <  u =="0.000000000000000001" : ] 000000187563049.500217000000000000 ; 000000204059085.398294000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000011E32D11375E95 >									
178 	//     < CHEMCHINA_PFV_II_metadata_line_12_____Ronas_Chemicals_Ind_Co_Limited_20240321 >									
179 	//        < ahWkG2zA3dKU8Z44f6m4ZBZd323mL9wTnw4McPm2ZuS8bX2720d5Hw71Sz5F4rt5 >									
180 	//        <  u =="0.000000000000000001" : ] 000000204059085.398294000000000000 ; 000000219821620.430895000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000001375E9514F6BD2 >									
182 	//     < CHEMCHINA_PFV_II_metadata_line_13_____Rudong_Zhenfeng_Yiyang_Chemical_Co__Limited_20240321 >									
183 	//        < HJ46LlxQf019Zr69Ms7N26O9jm7BSzxzsXpX8u7w32agw5hwR9Y2q973XsnDI0K7 >									
184 	//        <  u =="0.000000000000000001" : ] 000000219821620.430895000000000000 ; 000000239541520.130789000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000014F6BD216D82E8 >									
186 	//     < CHEMCHINA_PFV_II_metadata_line_14_____SAGECHEM_LIMITED_20240321 >									
187 	//        < whi0JMM89P65jHGQXi0mkpBNc9oYXjfAiR89I08KvZeh6BZQNsS59N6GFtxi3D6F >									
188 	//        <  u =="0.000000000000000001" : ] 000000239541520.130789000000000000 ; 000000262696236.601152000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000016D82E8190D7B8 >									
190 	//     < CHEMCHINA_PFV_II_metadata_line_15_____Shandong_Changsheng_New_Flame_Retardant_Co__Limited_20240321 >									
191 	//        < h4uid1sekUhm9H15HP52P3SwzDbPR2k03020U5RnPL2f43nlgw0Rpg30439M0L3i >									
192 	//        <  u =="0.000000000000000001" : ] 000000262696236.601152000000000000 ; 000000282314835.520504000000000000 ] >									
193 	//        < 0x00000000000000000000000000000000000000000000000000190D7B81AEC73C >									
194 	//     < CHEMCHINA_PFV_II_metadata_line_16_____Shandong_Shengda_Technology_Co__Limited_20240321 >									
195 	//        < Cdeo01TnY8SIYIOC7s6p7vJJ4sM8nj4IpxKgr6oHZ2R54XnhS0I0lqfR7e0PBN7G >									
196 	//        <  u =="0.000000000000000001" : ] 000000282314835.520504000000000000 ; 000000297885496.686793000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000001AEC73C1C68986 >									
198 	//     < CHEMCHINA_PFV_II_metadata_line_17_____Shangfluoro_20240321 >									
199 	//        < oz4utkAR8I26wMA7205Wf9SZ04fpXp0VfQ8CaChFG7bFADU23Yi8fGtKdtcRG4QC >									
200 	//        <  u =="0.000000000000000001" : ] 000000297885496.686793000000000000 ; 000000318796241.246835000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000001C689861E671C8 >									
202 	//     < CHEMCHINA_PFV_II_metadata_line_18_____Shanghai_Activated_Carbon_Co__Limited_20240321 >									
203 	//        < h7OWhBUOz1d4Zf1w34bmbL2065XZQkgT1m31lCAwha5Z9lllwQFb4Q724iL2VzHa >									
204 	//        <  u =="0.000000000000000001" : ] 000000318796241.246835000000000000 ; 000000339145329.587660000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000001E671C82057EA5 >									
206 	//     < CHEMCHINA_PFV_II_metadata_line_19_____Shanghai_AQ_BioPharma_org_20240321 >									
207 	//        < KHN11gVod92WnLIFKCha5a8BTW2F188T4LwGPCiEO48S2645W2mw9w90V3505pPP >									
208 	//        <  u =="0.000000000000000001" : ] 000000339145329.587660000000000000 ; 000000359509252.250557000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000002057EA5224914D >									
210 	//     < CHEMCHINA_PFV_II_metadata_line_20_____Shanghai_AQ_BioPharma_20240321 >									
211 	//        < 56s223I1wpO8b2J1xHL2IO64n4xi27W5yTcdA2gAybtS517rPo7k3hrXKQQzBl16 >									
212 	//        <  u =="0.000000000000000001" : ] 000000359509252.250557000000000000 ; 000000374958308.586380000000000000 ] >									
213 	//        < 0x00000000000000000000000000000000000000000000000000224914D23C2417 >									
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
256 	//     < CHEMCHINA_PFV_II_metadata_line_21_____SHANGHAI_ARCADIA_BIOTECHNOLOGY_Limited_20240321 >									
257 	//        < 37sDy4N2UyS17WbymD6NiGxBZ1BhafeS694G3BP4Ru54VC7y7U886iiiZBJHd7Ry >									
258 	//        <  u =="0.000000000000000001" : ] 000000374958308.586380000000000000 ; 000000397734448.413791000000000000 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000000023C241725EE505 >									
260 	//     < CHEMCHINA_PFV_II_metadata_line_22_____Shanghai_BenRo_Chemical_Co_Limited_20240321 >									
261 	//        < mJs54W8gJ1bVkE4egO9c7BY438OPLLawBFt83582MF5P94Hf1l5vB6wx9W1i7642 >									
262 	//        <  u =="0.000000000000000001" : ] 000000397734448.413791000000000000 ; 000000417232086.186174000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000025EE50527CA549 >									
264 	//     < CHEMCHINA_PFV_II_metadata_line_23_____Shanghai_Brothchem_Bio_Tech_Co_Limited_20240321 >									
265 	//        < G42Do4q8kaACi50dFXN20P1nv6I8oCsTWoEX8HkC70y5DYg63rv46D3GA5eQu0M9 >									
266 	//        <  u =="0.000000000000000001" : ] 000000417232086.186174000000000000 ; 000000436729185.713357000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000027CA54929A6557 >									
268 	//     < CHEMCHINA_PFV_II_metadata_line_24_____SHANGHAI_CHEMHERE_Co_Limited_20240321 >									
269 	//        < x3j1E2eC2U5235ay3c8h3Tkv61yb2HZEJAs9v0u2Tftx9aGDGhEaY127lhZElpaX >									
270 	//        <  u =="0.000000000000000001" : ] 000000436729185.713357000000000000 ; 000000456032457.713491000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000029A65572B7D9AE >									
272 	//     < CHEMCHINA_PFV_II_metadata_line_25_____Shanghai_ChemVia_Co_Limited_20240321 >									
273 	//        < 5secPe3Zj49J59IVH61l2e66btSFTfXN8O408ir7ft2nx511a585cFYK26Z6769x >									
274 	//        <  u =="0.000000000000000001" : ] 000000456032457.713491000000000000 ; 000000477626565.889791000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002B7D9AE2D8CCE1 >									
276 	//     < CHEMCHINA_PFV_II_metadata_line_26_____Shanghai_Coming_Hi_Technology_Co__Limited_20240321 >									
277 	//        < Z6U2k0zLKKPMHoojW60Qd0n2HsOh6k3f9iXYZvkwba6e4l9F3z641tmJ08hawJKT >									
278 	//        <  u =="0.000000000000000001" : ] 000000477626565.889791000000000000 ; 000000495101278.987175000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000002D8CCE12F376F0 >									
280 	//     < CHEMCHINA_PFV_II_metadata_line_27_____Shanghai_EachChem_org_20240321 >									
281 	//        < 5480dx3Z1aba2Jsv1eg9doDiwq139TLecP2o49Ri51JrudfB1KAI4Zof46b82325 >									
282 	//        <  u =="0.000000000000000001" : ] 000000495101278.987175000000000000 ; 000000510954674.488569000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000002F376F030BA7AB >									
284 	//     < CHEMCHINA_PFV_II_metadata_line_28_____Shanghai_EachChem_Co__Limited_20240321 >									
285 	//        < Rw05C5xlA76DY33Lx0gZS97Esqepg378z7Hf154d5gGdC8e0RS7NPVN6TOuV70gE >									
286 	//        <  u =="0.000000000000000001" : ] 000000510954674.488569000000000000 ; 000000530030268.242221000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000030BA7AB328C313 >									
288 	//     < CHEMCHINA_PFV_II_metadata_line_29_____Shanghai_FChemicals_Technology_Co_Limited_20240321 >									
289 	//        < kGGRv65jHgcs2GAC5t2osS3yQV54CWiSI62Y4Q3ebTfm53y87W25kc0JFWvqv6ik >									
290 	//        <  u =="0.000000000000000001" : ] 000000530030268.242221000000000000 ; 000000547391321.741659000000000000 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000000000328C31334340BC >									
292 	//     < CHEMCHINA_PFV_II_metadata_line_30_____Shanghai_Fuxin_Pharmaceutical_Co__Limited_20240321 >									
293 	//        < eL16E2M9ieSmb3xsem30jrQ3mysdECSfvHS9MhQ6uyWomnftJB8Haw0f4YgtTAlV >									
294 	//        <  u =="0.000000000000000001" : ] 000000547391321.741659000000000000 ; 000000566355604.698612000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000034340BC36030A8 >									
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
338 	//     < CHEMCHINA_PFV_II_metadata_line_31_____Shanghai_Goldenmall_biotechnology_Co__Limited_20240321 >									
339 	//        < w5zydE3Wx22Yeg7y8s38EB6btaG9G0WbshM4Q90718ijudA86305A3G2z3Btl36G >									
340 	//        <  u =="0.000000000000000001" : ] 000000566355604.698612000000000000 ; 000000587389398.728934000000000000 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000000000036030A838048FC >									
342 	//     < CHEMCHINA_PFV_II_metadata_line_32_____Shanghai_Hope_Chem_Co__Limited_20240321 >									
343 	//        < L7SYbXQkYr6WqR51FX248DuY4nHiBL395XecpS5u85L1DsUc4EavJIa5zT6M3ozN >									
344 	//        <  u =="0.000000000000000001" : ] 000000587389398.728934000000000000 ; 000000606155054.413661000000000000 ] >									
345 	//        < 0x0000000000000000000000000000000000000000000000000038048FC39CEB51 >									
346 	//     < CHEMCHINA_PFV_II_metadata_line_33_____SHANGHAI_IMMENSE_CHEMICAL_org_20240321 >									
347 	//        < 5ZpoJ07k6kT71MGquW098ZFe8u46W9c9FycaPfqjYs6lEOGmLuaxsPtvkf0neT3K >									
348 	//        <  u =="0.000000000000000001" : ] 000000606155054.413661000000000000 ; 000000626043903.633975000000000000 ] >									
349 	//        < 0x0000000000000000000000000000000000000000000000000039CEB513BB4466 >									
350 	//     < CHEMCHINA_PFV_II_metadata_line_34_____SHANGHAI_IMMENSE_CHEMICAL_Co_Limited_20240321 >									
351 	//        < Ypm13g51IA3UY50luTIr0vpDcWUVO9M1vWBLRGDYVzldq3XIzoRABlXztqCP4XL7 >									
352 	//        <  u =="0.000000000000000001" : ] 000000626043903.633975000000000000 ; 000000643457625.153250000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000003BB44663D5D6A3 >									
354 	//     < CHEMCHINA_PFV_II_metadata_line_35_____Shanghai_MC_Pharmatech_Co_Limited_20240321 >									
355 	//        < 343lo3x75sL1FQ5sMXxL6jo9SAf643lo2qWAZKQ6R9zQ5D9Ndy20pyLP28GVRQ0x >									
356 	//        <  u =="0.000000000000000001" : ] 000000643457625.153250000000000000 ; 000000661866434.812117000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000003D5D6A33F1ED93 >									
358 	//     < CHEMCHINA_PFV_II_metadata_line_36_____Shanghai_Mintchem_Development_Co_Limited_20240321 >									
359 	//        < xZ6VK8Rzs2253BHJVVEm36j2H5ev378eGdaoMD2oRgvPv97CW4CTIk67IwYzGaBk >									
360 	//        <  u =="0.000000000000000001" : ] 000000661866434.812117000000000000 ; 000000683153598.564640000000000000 ] >									
361 	//        < 0x000000000000000000000000000000000000000000000000003F1ED9341268E0 >									
362 	//     < CHEMCHINA_PFV_II_metadata_line_37_____Shanghai_NuoCheng_Pharmaceutical_Co_Limited_20240321 >									
363 	//        < OZ0u1dV7fKj27TnO5qnQv2QeuLD86hkrOFwX5k75dEDaZIc95YsDI4C559xJa6O5 >									
364 	//        <  u =="0.000000000000000001" : ] 000000683153598.564640000000000000 ; 000000706383417.547105000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000041268E0435DB06 >									
366 	//     < CHEMCHINA_PFV_II_metadata_line_38_____Shanghai_Oripharm_Co_Limited_20240321 >									
367 	//        < nS8erhOYrOMJSArIWwwSnE77PX63FhR2DT0TuT32Rd7r4iSs5067UMv21tv7m4JQ >									
368 	//        <  u =="0.000000000000000001" : ] 000000706383417.547105000000000000 ; 000000723929903.590223000000000000 ] >									
369 	//        < 0x00000000000000000000000000000000000000000000000000435DB06450A11E >									
370 	//     < CHEMCHINA_PFV_II_metadata_line_39_____Shanghai_PI_Chemicals_org_20240321 >									
371 	//        < XK1j5h5kdfzbJh40XI8WaXxV8cuCSl3dG43W8oG72cUZ1Hbe8nD5HcK8LOC4qO1G >									
372 	//        <  u =="0.000000000000000001" : ] 000000723929903.590223000000000000 ; 000000742137319.405950000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000450A11E46C6964 >									
374 	//     < CHEMCHINA_PFV_II_metadata_line_40_____Shanghai_PI_Chemicals_Ltd_20240321 >									
375 	//        < b6j6bjat1L92A1190mf60w2H9YO275a4c77AJ7523Icql21i6aTb3c9r9I0g26V0 >									
376 	//        <  u =="0.000000000000000001" : ] 000000742137319.405950000000000000 ; 000000761071890.098368000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000046C69644894DB5 >									
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