1 pragma solidity 		^0.4.25	;						
2 										
3 	contract	CHEMCHINA_PFII_II_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	CHEMCHINA_PFII_II_883		"	;
8 		string	public		symbol =	"	CHEMCHINA_PFII_II_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		766244968597695000000000000					;	
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
92 	//     < CHEMCHINA_PFII_II_metadata_line_1_____CHANGZHOU_WUJIN_LINCHUAN_CHEMICAL_Co_Limited_20240321 >									
93 	//        < 9KuqH90MivL0s53GFd8GdAUnoiZiXy0AaAee41m142z79F26CdIksK82gPQP5Zrf >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000022716158.769144000000000000 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000000022A980 >									
96 	//     < CHEMCHINA_PFII_II_metadata_line_2_____Chem_Stone_Co__Limited_20240321 >									
97 	//        < 7R9fDkd70mbWhJjh8Okew8z78f47T8u4aWh9jU809RIr57jG3dp0kgBHXC9bh30x >									
98 	//        <  u =="0.000000000000000001" : ] 000000022716158.769144000000000000 ; 000000038958182.762099900000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000022A9803B720A >									
100 	//     < CHEMCHINA_PFII_II_metadata_line_3_____Chemleader_Biomedical_Co_Limited_20240321 >									
101 	//        < mmvQe2798090HygXUNPF1rEk3Fx65oamFi4ChmJ5Y0u1cY9zPaw5rL8c3ZHvT1W3 >									
102 	//        <  u =="0.000000000000000001" : ] 000000038958182.762099900000000000 ; 000000060490949.721340200000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000003B720A5C4D47 >									
104 	//     < CHEMCHINA_PFII_II_metadata_line_4_____Chemner_Pharma_20240321 >									
105 	//        < 3HiLRVHSPcWM0u38L4cf8BR72xMQ2qhv0A2Z2O1jk3IRWCis228jf066mb3HCA1X >									
106 	//        <  u =="0.000000000000000001" : ] 000000060490949.721340200000000000 ; 000000078054810.052456300000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000005C4D47771A29 >									
108 	//     < CHEMCHINA_PFII_II_metadata_line_5_____Chemtour_Biotech__Suzhou__org_20240321 >									
109 	//        < 4880hI5ab7VC2e5l62ehA657S20MekPk6234GS3zS1vthg0WKc5JFv5Uw5kKm75J >									
110 	//        <  u =="0.000000000000000001" : ] 000000078054810.052456300000000000 ; 000000093964423.475318400000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000771A298F60DA >									
112 	//     < CHEMCHINA_PFII_II_metadata_line_6_____Chemtour_Biotech__Suzhou__Co__Ltd_20240321 >									
113 	//        < dvkd4l59D7z98s149M7Bgf0J2eYohn6bE1HY9Ux1p1goI0swyzz64FBM2b752Gu9 >									
114 	//        <  u =="0.000000000000000001" : ] 000000093964423.475318400000000000 ; 000000112335218.709289000000000000 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000000000008F60DAAB68F2 >									
116 	//     < CHEMCHINA_PFII_II_metadata_line_7_____Chemvon_Biotechnology_Co__Limited_20240321 >									
117 	//        < fU1hT8v517G3TYlQCdlOf9hN3y61dyfAdhS7u11mye5zUmphS596XXbZ6YEVn6cd >									
118 	//        <  u =="0.000000000000000001" : ] 000000112335218.709289000000000000 ; 000000132140441.049308000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000AB68F2C9A15C >									
120 	//     < CHEMCHINA_PFII_II_metadata_line_8_____Chengdu_Aslee_Biopharmaceuticals,_inc__20240321 >									
121 	//        < 077E6M3LiZ8KHsIEb8MjGA2m26637L8o4OtsEA1LQjPUn8Ent1Il7RQy54Z2Ful6 >									
122 	//        <  u =="0.000000000000000001" : ] 000000132140441.049308000000000000 ; 000000148576212.971557000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000C9A15CE2B595 >									
124 	//     < CHEMCHINA_PFII_II_metadata_line_9_____Chuxiong_Yunzhi_Phytopharmaceutical_Co_Limited_20240321 >									
125 	//        < 2REknmn245Z5nT0NEE342IN0sd6CY1gS23mQ1k11V9zt6XYu3UfQ2tss3i4KK8zN >									
126 	//        <  u =="0.000000000000000001" : ] 000000148576212.971557000000000000 ; 000000170553457.432960000000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000000E2B5951043E72 >									
128 	//     < CHEMCHINA_PFII_II_metadata_line_10_____Conier_Chem_Pharma__Limited_20240321 >									
129 	//        < 36jGoovq8zpg6N54bf3tvSRK6Vfz3td32iK66xg7IO67rjUO37NVUyidX4u5WM7A >									
130 	//        <  u =="0.000000000000000001" : ] 000000170553457.432960000000000000 ; 000000190524554.030866000000000000 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000000001043E72122B7A7 >									
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
174 	//     < CHEMCHINA_PFII_II_metadata_line_11_____Cool_Pharm_Ltd_20240321 >									
175 	//        < 5VNYlyI4gGo5w0gr56a4QjVMG9DuGS6w2NL3hi6BPEjlNxnQTCRAuYkrpHcffCFy >									
176 	//        <  u =="0.000000000000000001" : ] 000000190524554.030866000000000000 ; 000000212564874.791012000000000000 ] >									
177 	//        < 0x00000000000000000000000000000000000000000000000000122B7A71445927 >									
178 	//     < CHEMCHINA_PFII_II_metadata_line_12_____Coresyn_Pharmatech_Co__Limited_20240321 >									
179 	//        < 67a4a22cP614utDDC1AnmZ9mqZlG149wrp7l9nzOIGI3f4FI2Wvt5Om3Cp99faQp >									
180 	//        <  u =="0.000000000000000001" : ] 000000212564874.791012000000000000 ; 000000235962369.614388000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000014459271680CCD >									
182 	//     < CHEMCHINA_PFII_II_metadata_line_13_____Dalian_Join_King_Fine_Chemical_org_20240321 >									
183 	//        < 2DwE69Kpen7BK9Eq9a64p7Gbz4j6mk9BDM5Yv87H0HyD3a0HJy0U9KHNL89GEcog >									
184 	//        <  u =="0.000000000000000001" : ] 000000235962369.614388000000000000 ; 000000257687024.088296000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001680CCD18932FE >									
186 	//     < CHEMCHINA_PFII_II_metadata_line_14_____Dalian_Join_King_Fine_Chemical_Co_Limited_20240321 >									
187 	//        < ajSsz8Qh6uX6x3fcs0ALp1si4AkFfuMs5fIR5wiAZ85a0gzZXBTnS7lY42log493 >									
188 	//        <  u =="0.000000000000000001" : ] 000000257687024.088296000000000000 ; 000000278233365.681756000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000018932FE1A88CE9 >									
190 	//     < CHEMCHINA_PFII_II_metadata_line_15_____Dalian_Richfortune_Chemicals_Co_Limited_20240321 >									
191 	//        < 0Ypk5GCQCovt9Uo9y8sf2814wgULlGZ97gl3Kqbbi5x6UKW0E136P225g14ueliP >									
192 	//        <  u =="0.000000000000000001" : ] 000000278233365.681756000000000000 ; 000000298607037.208291000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000001A88CE91C7A360 >									
194 	//     < CHEMCHINA_PFII_II_metadata_line_16_____Daming_Changda_Co_Limited__LLBCHEM__20240321 >									
195 	//        < 1cc9JUF2b6ojMS8VCFKRi08fJwN80D8k19VN67fpUqsJccf798csAUT54duyCW9N >									
196 	//        <  u =="0.000000000000000001" : ] 000000298607037.208291000000000000 ; 000000321764806.629812000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000001C7A3601EAF961 >									
198 	//     < CHEMCHINA_PFII_II_metadata_line_17_____DATO_Chemicals_Co_Limited_20240321 >									
199 	//        < e3Ut06iPnWBgLh0iE6D2HJpF8VapiZmCN1cvowUsKA5FDoi86caA8qkwA5sTWkcH >									
200 	//        <  u =="0.000000000000000001" : ] 000000321764806.629812000000000000 ; 000000337817431.534664000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000001EAF96120377EF >									
202 	//     < CHEMCHINA_PFII_II_metadata_line_18_____DC_Chemicals_20240321 >									
203 	//        < hSFfNPcb57L2eTy391srIc01ytIo839vKypokE1KFcpeI25x1WWeUNeOqguP6SAd >									
204 	//        <  u =="0.000000000000000001" : ] 000000337817431.534664000000000000 ; 000000360333577.060211000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000020377EF225D34E >									
206 	//     < CHEMCHINA_PFII_II_metadata_line_19_____Depont_Molecular_Co_Limited_20240321 >									
207 	//        < 7cO2EJqyRA5dsS7ICI5DhepsYVslXI3N20g0NULJ3F7TdR8L2aD26WtdMZ49lWHc >									
208 	//        <  u =="0.000000000000000001" : ] 000000360333577.060211000000000000 ; 000000376021365.408787000000000000 ] >									
209 	//        < 0x00000000000000000000000000000000000000000000000000225D34E23DC359 >									
210 	//     < CHEMCHINA_PFII_II_metadata_line_20_____DSL_Chemicals_Co_Ltd_20240321 >									
211 	//        < L0EVG1Xj15GvVnNdkUAp5RY1p7X558GY6xw17EuoL244wik7iy95d1yDAqw6At06 >									
212 	//        <  u =="0.000000000000000001" : ] 000000376021365.408787000000000000 ; 000000398497757.408562000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000023DC3592600F30 >									
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
256 	//     < CHEMCHINA_PFII_II_metadata_line_21_____Elsa_Biotechnology_org_20240321 >									
257 	//        < q532ap3L8o5DiRdsZ0qVB7cSrF7552QA7q8E6uleZeZ5PQv3PA69J8c489y8bJX2 >									
258 	//        <  u =="0.000000000000000001" : ] 000000398497757.408562000000000000 ; 000000415265965.295213000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000002600F30279A545 >									
260 	//     < CHEMCHINA_PFII_II_metadata_line_22_____Elsa_Biotechnology_Co_Limited_20240321 >									
261 	//        < s98xSmR7w5y88MdDzUhLGS2muqyz02Cxu945Jp5500rsrn7amnXGkDZF6d31an85 >									
262 	//        <  u =="0.000000000000000001" : ] 000000415265965.295213000000000000 ; 000000438219135.673857000000000000 ] >									
263 	//        < 0x00000000000000000000000000000000000000000000000000279A54529CAB5A >									
264 	//     < CHEMCHINA_PFII_II_metadata_line_23_____Enze_Chemicals_Co_Limited_20240321 >									
265 	//        < 5kMeaZc1a8F2guWCk4YYBb4ojz9Je45fb0nFEI91N4zO57G5i2DZ8kR7SF4X1C8i >									
266 	//        <  u =="0.000000000000000001" : ] 000000438219135.673857000000000000 ; 000000455466948.537387000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000029CAB5A2B6FCC7 >									
268 	//     < CHEMCHINA_PFII_II_metadata_line_24_____EOS_Med_Chem_20240321 >									
269 	//        < L52PoeYnT8d4kg4ExAdX1de27oV6mFfFy42BNYsDz6h6SJ7g9r076wYdBOFaL1iV >									
270 	//        <  u =="0.000000000000000001" : ] 000000455466948.537387000000000000 ; 000000472131014.073948000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000002B6FCC72D06A2D >									
272 	//     < CHEMCHINA_PFII_II_metadata_line_25_____EOS_Med_Chem_20240321 >									
273 	//        < y6UjG7P0657f0dT4R19L3ov2Ar0g5v1Ss0v0JETqfc37TqJyg1pu25O2u3kK9DPZ >									
274 	//        <  u =="0.000000000000000001" : ] 000000472131014.073948000000000000 ; 000000489780057.973804000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002D06A2D2EB5856 >									
276 	//     < CHEMCHINA_PFII_II_metadata_line_26_____ETA_ChemTech_Co_Ltd_20240321 >									
277 	//        < tZLU8B689BV3l5rgAA402d99f8rrFhsJ0lluDv9QD80DSC0YbDg7bII48Y9UG7w2 >									
278 	//        <  u =="0.000000000000000001" : ] 000000489780057.973804000000000000 ; 000000506051723.134855000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000002EB58563042C74 >									
280 	//     < CHEMCHINA_PFII_II_metadata_line_27_____FEIMING_CHEMICAL_LIMITED_20240321 >									
281 	//        < 79tO09m95wV5ZeYl5uqQZnu4mbHv9FY2wGNj0rFuVgiU5gCL6ao0UzIKt328GJPs >									
282 	//        <  u =="0.000000000000000001" : ] 000000506051723.134855000000000000 ; 000000524892481.573485000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000003042C74320EC20 >									
284 	//     < CHEMCHINA_PFII_II_metadata_line_28_____FINETECH_INDUSTRY_LIMITED_20240321 >									
285 	//        < 257953Q2570QF8yRA0rxLi5s17LQ13k2n0Db55A355j2Lv36a5AhgN3tNCM20jRd >									
286 	//        <  u =="0.000000000000000001" : ] 000000524892481.573485000000000000 ; 000000543939709.610443000000000000 ] >									
287 	//        < 0x00000000000000000000000000000000000000000000000000320EC2033DFC73 >									
288 	//     < CHEMCHINA_PFII_II_metadata_line_29_____Finetech_Industry_Limited_20240321 >									
289 	//        < P4458zOY2drp5Zh6tz6uvb25Bi0xboJ854SEZGFmx6M5K6h0Xi8VP1a3lKM3q2Gl >									
290 	//        <  u =="0.000000000000000001" : ] 000000543939709.610443000000000000 ; 000000563203655.086787000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000033DFC7335B616E >									
292 	//     < CHEMCHINA_PFII_II_metadata_line_30_____Fluoropharm_org_20240321 >									
293 	//        < P5bA2yUIbozBPUp5pdHQRFcO1M17XZ4Vo8N7RVIq0Ik7Co8M5MqAgsS4bh9w2t88 >									
294 	//        <  u =="0.000000000000000001" : ] 000000563203655.086787000000000000 ; 000000578285089.958733000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000035B616E372649D >									
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
338 	//     < CHEMCHINA_PFII_II_metadata_line_31_____Fluoropharm_Co_Limited_20240321 >									
339 	//        < Lh20y33iYHh1382x3quO5Ok6Akg3WEMOZ1om5LGsNmXpt2mtUw5Qh17sqaR601iR >									
340 	//        <  u =="0.000000000000000001" : ] 000000578285089.958733000000000000 ; 000000596354742.563248000000000000 ] >									
341 	//        < 0x00000000000000000000000000000000000000000000000000372649D38DF712 >									
342 	//     < CHEMCHINA_PFII_II_metadata_line_32_____Fond_Chemical_Co_Limited_20240321 >									
343 	//        < 2FnJB0W1c8cysf1qww6K9D6z5060P1K1ylH8cXNA74pOG9aV0NIU6vK4DX9T56x0 >									
344 	//        <  u =="0.000000000000000001" : ] 000000596354742.563248000000000000 ; 000000613142676.397207000000000000 ] >									
345 	//        < 0x0000000000000000000000000000000000000000000000000038DF7123A794DC >									
346 	//     < CHEMCHINA_PFII_II_metadata_line_33_____Gansu_Research_Institute_of_Chemical_Industry_20240321 >									
347 	//        < 78E9CJvpH91OsY361sH8T0d3Ir54d5Aw68S2sbRy941a2k38Gud41TncfaVSn29d >									
348 	//        <  u =="0.000000000000000001" : ] 000000613142676.397207000000000000 ; 000000635817072.563856000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000003A794DC3CA2E0B >									
350 	//     < CHEMCHINA_PFII_II_metadata_line_34_____GL_Biochem__Shanghai__Ltd__20240321 >									
351 	//        < i72K6lyUhP5Gdd5dGYtATLQCpO7RJUXr6L36lX0hMkEV6P3fHAjO39K7JpvB6c6R >									
352 	//        <  u =="0.000000000000000001" : ] 000000635817072.563856000000000000 ; 000000657194818.473141000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000003CA2E0B3EACCBA >									
354 	//     < CHEMCHINA_PFII_II_metadata_line_35_____Guangzhou_Topwork_Chemical_Co__Limited_20240321 >									
355 	//        < 002s1Mn9zcH6ps7eri93Jfq2gNpvoxZqqDv5BzCM2K267L8T6ht3YgF0kQKuB3pc >									
356 	//        <  u =="0.000000000000000001" : ] 000000657194818.473141000000000000 ; 000000676783312.338124000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000003EACCBA408B07B >									
358 	//     < CHEMCHINA_PFII_II_metadata_line_36_____Hallochem_Pharma_Co_Limited_20240321 >									
359 	//        < if3XSBg3g156iY93a37p8GfSn0Y6B1xIAGAO2aSPi1SB1Ds0sFGOy58GRnNA9PdN >									
360 	//        <  u =="0.000000000000000001" : ] 000000676783312.338124000000000000 ; 000000696742121.826889000000000000 ] >									
361 	//        < 0x00000000000000000000000000000000000000000000000000408B07B42724E4 >									
362 	//     < CHEMCHINA_PFII_II_metadata_line_37_____Hanghzou_Fly_Source_Chemical_Co_Limited_20240321 >									
363 	//        < 1Y5lWCG4LySRixPifG6942m6JwJUbH3z738x8g3PwCD7U0nBkQ0B726jh6e25zW3 >									
364 	//        <  u =="0.000000000000000001" : ] 000000696742121.826889000000000000 ; 000000712102762.457560000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000042724E443E9524 >									
366 	//     < CHEMCHINA_PFII_II_metadata_line_38_____Hangzhou_Best_Chemicals_Co__Limited_20240321 >									
367 	//        < O73X8m8VIpbc2AP65dqRHpkqhrngrd5358mgS7o56UXrWF7viF7qZPNhT03rM117 >									
368 	//        <  u =="0.000000000000000001" : ] 000000712102762.457560000000000000 ; 000000730904021.346897000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000043E952445B4562 >									
370 	//     < CHEMCHINA_PFII_II_metadata_line_39_____Hangzhou_Dayangchem_Co__Limited_20240321 >									
371 	//        < aRsdDAi6s8UyD7Vn7ptU2p3NE7iM83SHrmElGwS122L8zf8sOoOxCBdKsn9MMQK4 >									
372 	//        <  u =="0.000000000000000001" : ] 000000730904021.346897000000000000 ; 000000749786919.657001000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000045B45624781584 >									
374 	//     < CHEMCHINA_PFII_II_metadata_line_40_____Hangzhou_Dayangchem_org_20240321 >									
375 	//        < qoGQ28QGrnKA96rid7Vm2U3ZGX7Ah26FEaIq504vdQq34O7mguNGj03e64VcgWVI >									
376 	//        <  u =="0.000000000000000001" : ] 000000749786919.657001000000000000 ; 000000766244968.597696000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000047815844913271 >									
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