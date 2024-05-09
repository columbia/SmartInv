1 pragma solidity 		^0.4.25	;						
2 										
3 	contract	CHEMCHINA_PFVI_II_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	CHEMCHINA_PFVI_II_883		"	;
8 		string	public		symbol =	"	CHEMCHINA_PFVI_II_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		739380880358332000000000000					;	
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
92 	//     < CHEMCHINA_PFVI_II_metadata_line_1_____Shanghai_PI_Chemicals_Limited_20240321 >									
93 	//        < PcK5H8CpQ5C93bzth4dy2VmxE7J7TQOqJqLo43S5p9Kax6P4a3lTP11Pc8fEC077 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000020918854.096409200000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000001FEB6D >									
96 	//     < CHEMCHINA_PFVI_II_metadata_line_2_____Shanghai_PI_Chemicals_Limited_20240321 >									
97 	//        < W96MhWw6mu46c72k7436KmnRrUaqcsaQEIVTRE4iOo2D1LzJ8zNI4m5VEu42luVl >									
98 	//        <  u =="0.000000000000000001" : ] 000000020918854.096409200000000000 ; 000000042857487.829008700000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000001FEB6D416535 >									
100 	//     < CHEMCHINA_PFVI_II_metadata_line_3_____Shanghai_Race_Chemical_Co_Limited_20240321 >									
101 	//        < 444Vww3Q44T5RX980P3BIPN6p5GMlCsT9jQ0OYaKy2Xz97qMu76JPl9mNh60N2Sg >									
102 	//        <  u =="0.000000000000000001" : ] 000000042857487.829008700000000000 ; 000000061160806.029958600000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000004165355D52F1 >									
104 	//     < CHEMCHINA_PFVI_II_metadata_line_4_____Shanghai_Sinch_Parmaceuticals_Tech__Co__Limited_20240321 >									
105 	//        < p2WmsXW2xc8Tpw108M446xGA5JiB80UY0DXRRA3FsZ9FB2YVLBm0iWqFH5cuExL1 >									
106 	//        <  u =="0.000000000000000001" : ] 000000061160806.029958600000000000 ; 000000079246127.912675500000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000005D52F178EB85 >									
108 	//     < CHEMCHINA_PFVI_II_metadata_line_5_____Shanghai_Sunway_Pharmaceutical_Technology_Co_Limited_20240321 >									
109 	//        < eClTLI120nftrvSdQ7Y8Ub719T57c65QqZ1o5qViHJYyO4Y885jk680i2Y785BOF >									
110 	//        <  u =="0.000000000000000001" : ] 000000079246127.912675500000000000 ; 000000101055060.454395000000000000 ] >									
111 	//        < 0x000000000000000000000000000000000000000000000000000078EB859A32A2 >									
112 	//     < CHEMCHINA_PFVI_II_metadata_line_6_____Shanghai_Tauto_Biotech_Co_Limited_20240321 >									
113 	//        < Pv837k9A0Mxi2alG5ANIaiX3Yb1Q17Yw3R30x99PmmeOI360TH34M3Na5yaF6Y56 >									
114 	//        <  u =="0.000000000000000001" : ] 000000101055060.454395000000000000 ; 000000115936808.850976000000000000 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000000000009A32A2B0E7D1 >									
116 	//     < CHEMCHINA_PFVI_II_metadata_line_7_____Shanghai_UCHEM_org__20240321 >									
117 	//        < r75B4m9k53cWc986LgS4xKpPoQNm0QLG10O1rX59p9M46mLJzB83f7pPZA4pRWfr >									
118 	//        <  u =="0.000000000000000001" : ] 000000115936808.850976000000000000 ; 000000136622264.722967000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000B0E7D1D07812 >									
120 	//     < CHEMCHINA_PFVI_II_metadata_line_8_____Shanghai_UCHEM_inc__20240321 >									
121 	//        < AF2ZFjs1c9n88E7o5DA8xx2M8i91Zb0IC282833y7VOYfm0G13V6CJNC7bufacHC >									
122 	//        <  u =="0.000000000000000001" : ] 000000136622264.722967000000000000 ; 000000152030761.548287000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000D07812E7FB04 >									
124 	//     < CHEMCHINA_PFVI_II_metadata_line_9_____Shanghai_UDChem_Technology_Co_Limited_20240321 >									
125 	//        < o2eT30b19XcyX3zd6Dgqm03r9JBUXbLRz9j7hR22GKP4898XE3UoIR8XzV2UZC94 >									
126 	//        <  u =="0.000000000000000001" : ] 000000152030761.548287000000000000 ; 000000173652348.118727000000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000000E7FB04108F8F3 >									
128 	//     < CHEMCHINA_PFVI_II_metadata_line_10_____Shanghai_Witofly_Chemical_Co_Limited_20240321 >									
129 	//        < 5p0Z8iE84TpV906m0d69oUhx32GLUxvVejUx7T8x6w2rWD616Fz6e9nLL5z0mV1i >									
130 	//        <  u =="0.000000000000000001" : ] 000000173652348.118727000000000000 ; 000000188969868.635396000000000000 ] >									
131 	//        < 0x00000000000000000000000000000000000000000000000000108F8F3120585B >									
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
174 	//     < CHEMCHINA_PFVI_II_metadata_line_11_____Shanghai_Worldyang_Chemical_Co_Limited_20240321 >									
175 	//        < CEQOu9lD21yx8PSxC58o77oT8IyY71FyBrc3AsRm8kmfOaff1Una94htays15jK7 >									
176 	//        <  u =="0.000000000000000001" : ] 000000188969868.635396000000000000 ; 000000211275321.598978000000000000 ] >									
177 	//        < 0x00000000000000000000000000000000000000000000000000120585B142616C >									
178 	//     < CHEMCHINA_PFVI_II_metadata_line_12_____Shanghai_Yingxuan_Chempharm_Co__Limited_20240321 >									
179 	//        < F8WlYeZ6s8J9d3h0BqOvf1V494n448pLcjbX64mhG54QEh813i6Sar25pukRtYES >									
180 	//        <  u =="0.000000000000000001" : ] 000000211275321.598978000000000000 ; 000000232301005.801800000000000000 ] >									
181 	//        < 0x00000000000000000000000000000000000000000000000000142616C1627695 >									
182 	//     < CHEMCHINA_PFVI_II_metadata_line_13_____SHANXI_WUCHAN_FINE_CHEMICAL_Co_Limited_20240321 >									
183 	//        < m9W67Zq1H9Wf8g1n8s5oC5koJJ9Yj99S5xbTGvb242J4BxpsJx7sp8ZRfKZ33O2H >									
184 	//        <  u =="0.000000000000000001" : ] 000000232301005.801800000000000000 ; 000000249207009.730174000000000000 ] >									
185 	//        < 0x00000000000000000000000000000000000000000000000000162769517C427D >									
186 	//     < CHEMCHINA_PFVI_II_metadata_line_14_____SHENYANG_OLLYCHEM_CO_LTD_20240321 >									
187 	//        < 0U041Kzg24TE7UKk75T7883y57nek6OKPwpO8H096U046aWWPA0B2iZzaKGHi5a7 >									
188 	//        <  u =="0.000000000000000001" : ] 000000249207009.730174000000000000 ; 000000266816234.844019000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000017C427D1972117 >									
190 	//     < CHEMCHINA_PFVI_II_metadata_line_15_____ShenZhen_Cerametek_Materials_org_20240321 >									
191 	//        < LK2674A30XHC3Km8tIv75oo1I42n5b87q74d3Boin427faN944rc09Q3h8a8my2I >									
192 	//        <  u =="0.000000000000000001" : ] 000000266816234.844019000000000000 ; 000000283542492.904478000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000019721171B0A6C9 >									
194 	//     < CHEMCHINA_PFVI_II_metadata_line_16_____ShenZhen_Cerametek_Materials_Co_Limited_20240321 >									
195 	//        < oPWuqb22flg6k9UoS3dWi7lsbCr1btDJn4qcDpDW860Gmqx181hzTlRuUHj5hsp6 >									
196 	//        <  u =="0.000000000000000001" : ] 000000283542492.904478000000000000 ; 000000298192429.392025000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000001B0A6C91C7016B >									
198 	//     < CHEMCHINA_PFVI_II_metadata_line_17_____SHENZHEN_CHEMICAL_Co__Limited_20240321 >									
199 	//        < 20siY63dC5z0iF0Y49eYdW2AS3ZK4o2u7v20cgQM506972Eaopw570bYjS1Fekj0 >									
200 	//        <  u =="0.000000000000000001" : ] 000000298192429.392025000000000000 ; 000000316119118.694185000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000001C7016B1E25C08 >									
202 	//     < CHEMCHINA_PFVI_II_metadata_line_18_____SHOUGUANG_FUKANG_PHARMACEUTICAL_Co_Limited_20240321 >									
203 	//        < 5GnJG2ZAoE1z3XHwxRctY0hO0tq9H30jnEW9exbo58J0oJSVQwJo9aAu97NccTS0 >									
204 	//        <  u =="0.000000000000000001" : ] 000000316119118.694185000000000000 ; 000000336838672.229757000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000001E25C08201F99B >									
206 	//     < CHEMCHINA_PFVI_II_metadata_line_19_____Shouyuan_Chemical_20240321 >									
207 	//        < 9nw049930E7x745S7n5w3SrrFJ2fGs6Of7FjgTaNS6L8NlW5EmGnu9g6wFmg27Kr >									
208 	//        <  u =="0.000000000000000001" : ] 000000336838672.229757000000000000 ; 000000359099586.500980000000000000 ] >									
209 	//        < 0x00000000000000000000000000000000000000000000000000201F99B223F147 >									
210 	//     < CHEMCHINA_PFVI_II_metadata_line_20_____Sichuan_Apothe_Pharmaceuticals_Limited_20240321 >									
211 	//        < 1U4nmoTC6Gwm6qFK7opoptlRq50s4vJE91WsHBdo66T5W278oHebXhwX78A55h95 >									
212 	//        <  u =="0.000000000000000001" : ] 000000359099586.500980000000000000 ; 000000377929650.222483000000000000 ] >									
213 	//        < 0x00000000000000000000000000000000000000000000000000223F147240ACC5 >									
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
256 	//     < CHEMCHINA_PFVI_II_metadata_line_21_____Sichuan_Highlight_Fine_Chemicals_Co__Limited_20240321 >									
257 	//        < 5PSbvP5S8vPEQ7Lsl3A49m41l3D6977HG20i18yggdBM77K0Bd577Kx3mbo8t5c2 >									
258 	//        <  u =="0.000000000000000001" : ] 000000377929650.222483000000000000 ; 000000398745198.006436000000000000 ] >									
259 	//        < 0x00000000000000000000000000000000000000000000000000240ACC52606FD8 >									
260 	//     < CHEMCHINA_PFVI_II_metadata_line_22_____SICHUAN_TONGSHENG_AMINO_ACID_org_20240321 >									
261 	//        < S7GLiKvFFt1ZEE15oFvG31ElX6Rt7puRO7FLTGFftv82PNw5eWO8iP6isacv5NzL >									
262 	//        <  u =="0.000000000000000001" : ] 000000398745198.006436000000000000 ; 000000414705696.363244000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000002606FD8278CA6A >									
264 	//     < CHEMCHINA_PFVI_II_metadata_line_23_____SICHUAN_TONGSHENG_AMINO_ACID_Co_Limited_20240321 >									
265 	//        < 9jlB23u5iB2xpWk093ys4YWI9vb17DiFM0edJioil2jC5qDtJgA8umNTPMV5Go3y >									
266 	//        <  u =="0.000000000000000001" : ] 000000414705696.363244000000000000 ; 000000434655456.520341000000000000 ] >									
267 	//        < 0x00000000000000000000000000000000000000000000000000278CA6A2973B4A >									
268 	//     < CHEMCHINA_PFVI_II_metadata_line_24_____SightChem_Co__Limited_20240321 >									
269 	//        < q8479nU100cWtaad8i7Li483A7d306St1241tn3TA5WI6E5tv8c3e1eNcyL4EgUk >									
270 	//        <  u =="0.000000000000000001" : ] 000000434655456.520341000000000000 ; 000000448881551.030896000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000002973B4A2ACF05B >									
272 	//     < CHEMCHINA_PFVI_II_metadata_line_25_____Simagchem_Corporation_20240321 >									
273 	//        < sg7g8LWAXRPEc5iRskB9x5BDIE9fBGyrnLW9809nG104L3dfRunlok57807PeBIv >									
274 	//        <  u =="0.000000000000000001" : ] 000000448881551.030896000000000000 ; 000000465800594.693344000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002ACF05B2C6C15B >									
276 	//     < CHEMCHINA_PFVI_II_metadata_line_26_____SINO_GREAT_ENTERPRISE_Limited_20240321 >									
277 	//        < VdeG90I6k1dIZ8pqe99iUc6y9x97IXh1GCo0c6WGaM6331b8iBboyF731x9qADm6 >									
278 	//        <  u =="0.000000000000000001" : ] 000000465800594.693344000000000000 ; 000000485037050.097851000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000002C6C15B2E41B99 >									
280 	//     < CHEMCHINA_PFVI_II_metadata_line_27_____SINO_High_Goal_chemical_Techonology_Co_Limited_20240321 >									
281 	//        < Sod6Ga8Jvdi5R6TJS56y8Q294yry2ihw3UILF6Jutqhcb97zLSTcXpZ23HrsGY7j >									
282 	//        <  u =="0.000000000000000001" : ] 000000485037050.097851000000000000 ; 000000499608212.564423000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000002E41B992FA5775 >									
284 	//     < CHEMCHINA_PFVI_II_metadata_line_28_____Sino_Rarechem_Labs_Co_Limited_20240321 >									
285 	//        < Da3GQtYixcGwNhnKabpfwb5hrLq85csAS863NWTUCCF9Tuh5D2jH08027aNB7HHB >									
286 	//        <  u =="0.000000000000000001" : ] 000000499608212.564423000000000000 ; 000000514865801.075801000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000002FA57753119F74 >									
288 	//     < CHEMCHINA_PFVI_II_metadata_line_29_____Sinofi_Ingredients_20240321 >									
289 	//        < 06s6GRH7jxoLvvt0bCsImle99Ck2NNJlXA3b1H7LqpN6mK35OT3etuCew73iDL4P >									
290 	//        <  u =="0.000000000000000001" : ] 000000514865801.075801000000000000 ; 000000533951848.751617000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000003119F7432EBEF1 >									
292 	//     < CHEMCHINA_PFVI_II_metadata_line_30_____Sinoway_20240321 >									
293 	//        < VdHoSZ8Z0W5g4YmsB949FbPFFe1p4497tj4t9S7A1439fAFpCQcg6GVLof2g8gvs >									
294 	//        <  u =="0.000000000000000001" : ] 000000533951848.751617000000000000 ; 000000552295261.326734000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000032EBEF134ABC56 >									
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
338 	//     < CHEMCHINA_PFVI_II_metadata_line_31_____Skyrun_Industrial_Co_Limited_20240321 >									
339 	//        < mZOAMr93tC3aTkJ17ZrYp4qB59YTAXfL026vFTKESO7pt237ppXpze976rejhqHk >									
340 	//        <  u =="0.000000000000000001" : ] 000000552295261.326734000000000000 ; 000000574179824.195739000000000000 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000000000034ABC5636C20FE >									
342 	//     < CHEMCHINA_PFVI_II_metadata_line_32_____Spec_Chem_Industry_org_20240321 >									
343 	//        < 4FMbpvUSOCr2PGIoxwDKVjjnp32p4w4B6nZDBsKl28jq8qN6K7sY10W5G5cACSPa >									
344 	//        <  u =="0.000000000000000001" : ] 000000574179824.195739000000000000 ; 000000595469342.581368000000000000 ] >									
345 	//        < 0x0000000000000000000000000000000000000000000000000036C20FE38C9D36 >									
346 	//     < CHEMCHINA_PFVI_II_metadata_line_33_____Spec_Chem_Industry_inc__20240321 >									
347 	//        < Ug214nQz6IufXAanPuJdmc91VVYVRIq6o8tVZmQlgWj2d3x6nYmk44N0GbMXGdBX >									
348 	//        <  u =="0.000000000000000001" : ] 000000595469342.581368000000000000 ; 000000617401829.353792000000000000 ] >									
349 	//        < 0x0000000000000000000000000000000000000000000000000038C9D363AE1497 >									
350 	//     < CHEMCHINA_PFVI_II_metadata_line_34_____Stone_Lake_Pharma_Tech_Co_Limited_20240321 >									
351 	//        < rbtS767ZoJFvoNNSD3vhky7iZlQ0FM22L305scSE73VOW59LEXtQ76W2YTJiF4jz >									
352 	//        <  u =="0.000000000000000001" : ] 000000617401829.353792000000000000 ; 000000638710205.127782000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000003AE14973CE982D >									
354 	//     < CHEMCHINA_PFVI_II_metadata_line_35_____Suzhou_ChonTech_PharmaChem_Technology_Co__Limited_20240321 >									
355 	//        < 77WUgQe3X7F72JRtz9eNmS2vi5A4nNZ9Kr3BZ9N9u9B8Qm9E7LL38dN75nds8PIq >									
356 	//        <  u =="0.000000000000000001" : ] 000000638710205.127782000000000000 ; 000000652960429.117492000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000003CE982D3E456AB >									
358 	//     < CHEMCHINA_PFVI_II_metadata_line_36_____Suzhou_Credit_International_Trading_Co__Limited_20240321 >									
359 	//        < E8zZy8H9qkP9z7xF2oaA5T79wVBKGxa4sxD15Z5V2w166XKuAGW0dTV2LJ6ry8V3 >									
360 	//        <  u =="0.000000000000000001" : ] 000000652960429.117492000000000000 ; 000000668878219.287168000000000000 ] >									
361 	//        < 0x000000000000000000000000000000000000000000000000003E456AB3FCA08E >									
362 	//     < CHEMCHINA_PFVI_II_metadata_line_37_____Suzhou_KPChemical_Co_Limited_20240321 >									
363 	//        < y10U17h57nM88qc0FRpoBX2GoG9S60ll6J807A0z7QvbY9v844yvy6VmOn7B379i >									
364 	//        <  u =="0.000000000000000001" : ] 000000668878219.287168000000000000 ; 000000687796319.896833000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000003FCA08E4197E70 >									
366 	//     < CHEMCHINA_PFVI_II_metadata_line_38_____Suzhou_Rovathin_Foreign_Trade_Co_Limited_20240321 >									
367 	//        < TUOWfo93Gr5uWNiNQe19wKl031fmi5eH0qKQW7vog50d9Q2ABpxmz80L228oT40J >									
368 	//        <  u =="0.000000000000000001" : ] 000000687796319.896833000000000000 ; 000000706178717.108659000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000004197E704358B10 >									
370 	//     < CHEMCHINA_PFVI_II_metadata_line_39_____SUZHOU_SINOERA_CHEM_org_20240321 >									
371 	//        < gre01rB2jaHtX827vrVU2lM2cF1623wPA1cmY8J9Fj1ZG1HtwP9dMLduB7xUFcpd >									
372 	//        <  u =="0.000000000000000001" : ] 000000706178717.108659000000000000 ; 000000723627293.259724000000000000 ] >									
373 	//        < 0x000000000000000000000000000000000000000000000000004358B104502AE9 >									
374 	//     < CHEMCHINA_PFVI_II_metadata_line_40_____SUZHOU_SINOERA_CHEM_Co__Limited_20240321 >									
375 	//        < F9FO2xiVB19aNgsyR34NLRSr3kdYay9fZ84snGm89Xu96hHXgU9MG0WCZe89UR4Q >									
376 	//        <  u =="0.000000000000000001" : ] 000000723627293.259724000000000000 ; 000000739380880.358332000000000000 ] >									
377 	//        < 0x000000000000000000000000000000000000000000000000004502AE946834A8 >									
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