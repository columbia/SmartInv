1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	NDRV_PFVII_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	NDRV_PFVII_III_883		"	;
8 		string	public		symbol =	"	NDRV_PFVII_III_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		2150247123531500000000000000					;	
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
92 	//     < NDRV_PFVII_III_metadata_line_1_____Hannover Re_20251101 >									
93 	//        < 4pVGJBK25H1exlwJiGRak0K852Ik51ptH7482EHNc6dG9CUj47Qc9STQlT899767 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000028915833.975073400000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000002C1F3F >									
96 	//     < NDRV_PFVII_III_metadata_line_2_____Hannover Reinsurance Ireland Ltd_20251101 >									
97 	//        < 2oWhh65Pw1q2Soat74I8R7648qbPmype2W70as0K156Bqu79c5gx7kZV1d1qZvNY >									
98 	//        <  u =="0.000000000000000001" : ] 000000028915833.975073400000000000 ; 000000069455843.328465000000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000002C1F3F69FB30 >									
100 	//     < NDRV_PFVII_III_metadata_line_3_____975 Carroll Square Llc_20251101 >									
101 	//        < q0E29gXBY6kzEZ3jbA48WJUR545m341COwDA5wS7EP571HYbspWOeM1TSziED3s8 >									
102 	//        <  u =="0.000000000000000001" : ] 000000069455843.328465000000000000 ; 000000150187224.228747000000000000 ] >									
103 	//        < 0x000000000000000000000000000000000000000000000000000069FB30E52AE2 >									
104 	//     < NDRV_PFVII_III_metadata_line_4_____Caroll_Holdings_20251101 >									
105 	//        < lic28Lgj6860Wt56M73Q5BYc64fyrDR3Ts6Z0c86IRFluyyZoP0v1b3zhU04pqK7 >									
106 	//        <  u =="0.000000000000000001" : ] 000000150187224.228747000000000000 ; 000000170201229.365145000000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000E52AE2103B4DB >									
108 	//     < NDRV_PFVII_III_metadata_line_5_____Skandia Versicherung Management & Service Gmbh_20251101 >									
109 	//        < bGq7faaUQ7iHRv5r3bQy1457RaDKV7K990jJnB3sU7ZvBIjVc1KEXPb5uVb4YxBx >									
110 	//        <  u =="0.000000000000000001" : ] 000000170201229.365145000000000000 ; 000000203343436.079184000000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000103B4DB1364708 >									
112 	//     < NDRV_PFVII_III_metadata_line_6_____Skandia PortfolioManagement Gmbh, Asset Management Arm_20251101 >									
113 	//        < 8Tw2uDcTL2NwAaR92Gz9LW6c0lVZo2mAL709Re6Z44S6GdoySdwg8vjOd77HBh6N >									
114 	//        <  u =="0.000000000000000001" : ] 000000203343436.079184000000000000 ; 000000230504870.145462000000000000 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000000000136470815FB8F7 >									
116 	//     < NDRV_PFVII_III_metadata_line_7_____Argenta Underwriting No8 Limited_20251101 >									
117 	//        < SF37DtR7ZIo0tMW97I5O2vcj22pwLry9tvB8qDJk9N6x0oUC99qJQ3rnzY1qITY7 >									
118 	//        <  u =="0.000000000000000001" : ] 000000230504870.145462000000000000 ; 000000290332423.930498000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000015FB8F71BB031A >									
120 	//     < NDRV_PFVII_III_metadata_line_8_____Oval Office Grundstücks GmbH_20251101 >									
121 	//        < JrUhKFvN3q66UiSVrFC9h0fGJQ8Ob0rlt5Cho3t2i6l93POQH8q9Xg2t25I74Ag1 >									
122 	//        <  u =="0.000000000000000001" : ] 000000290332423.930498000000000000 ; 000000360436415.634567000000000000 ] >									
123 	//        < 0x000000000000000000000000000000000000000000000000001BB031A225FB7A >									
124 	//     < NDRV_PFVII_III_metadata_line_9_____Hannover Rückversicherung AG Asset Management Arm_20251101 >									
125 	//        < YbWIXl76yoNppGtXUb741xNxB1277JU81zo3pW59xxdM9tvoJggQwU2nUtxbCcJ5 >									
126 	//        <  u =="0.000000000000000001" : ] 000000360436415.634567000000000000 ; 000000417925192.320195000000000000 ] >									
127 	//        < 0x00000000000000000000000000000000000000000000000000225FB7A27DB407 >									
128 	//     < NDRV_PFVII_III_metadata_line_10_____Hannover Rueckversicherung Ag Korea Branch_20251101 >									
129 	//        < 4G9Hu1tZ8XBr3JR4wuTS1b8Nt7xE6Y7119PyTjC59p776JFrr6wJH82YG5jrc74T >									
130 	//        <  u =="0.000000000000000001" : ] 000000417925192.320195000000000000 ; 000000454120432.111565000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000027DB4072B4EECB >									
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
174 	//     < NDRV_PFVII_III_metadata_line_11_____Nashville West LLC_20251101 >									
175 	//        < 4XAbqx9vaZwQ5dUTDMr4rR49UM3dQGGllPqJ3JQf4BI2gTHoAm89Fl19oGtA8j3I >									
176 	//        <  u =="0.000000000000000001" : ] 000000454120432.111565000000000000 ; 000000511978582.882640000000000000 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000000002B4EECB30D37A2 >									
178 	//     < NDRV_PFVII_III_metadata_line_12_____WRH Offshore High Yield Partners LP_20251101 >									
179 	//        < 9yKdDNF8LMoXYjZn77099zVl3Ixz5ke7hhxFR9Oqnou4PTB71CiXJ0020VPzfze7 >									
180 	//        <  u =="0.000000000000000001" : ] 000000511978582.882640000000000000 ; 000000596698293.911666000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000030D37A238E7D45 >									
182 	//     < NDRV_PFVII_III_metadata_line_13_____111Ord Llc_20251101 >									
183 	//        < utG5z53ZWdTG76rJ6LE442nwJhZb7oPN0a9L4tS1H93gkO9nU8yDNNy0LZDcg4i2 >									
184 	//        <  u =="0.000000000000000001" : ] 000000596698293.911666000000000000 ; 000000661572563.409641000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000038E7D453F17AC8 >									
186 	//     < NDRV_PFVII_III_metadata_line_14_____Hannover Insurance_Linked Securities GmbH & Co KG_20251101 >									
187 	//        < nK16Uai1J6Jt9Q4bXVfU8CWdcQBR42e8gd18M8zA4U229592atW4og5P4E38bquU >									
188 	//        <  u =="0.000000000000000001" : ] 000000661572563.409641000000000000 ; 000000693940382.505975000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000003F17AC8422DE76 >									
190 	//     < NDRV_PFVII_III_metadata_line_15_____Hannover Ruckversicherung AG Hong Kong_20251101 >									
191 	//        < 2oR7R0MQhib3vZGzKpfD1f6HE1XJ66bY85f1VEc8LA7YjbA35Dmvi04HZK2tokcW >									
192 	//        <  u =="0.000000000000000001" : ] 000000693940382.505975000000000000 ; 000000778549520.768611000000000000 ] >									
193 	//        < 0x00000000000000000000000000000000000000000000000000422DE764A3F8E8 >									
194 	//     < NDRV_PFVII_III_metadata_line_16_____Hannover Reinsurance Mauritius Ltd_20251101 >									
195 	//        < 5137pM6epDJJ1o3PeDZ2kTo2ZFYpFORnJU1Tm54Z6Stx3Q04300vae58IWyRxFtW >									
196 	//        <  u =="0.000000000000000001" : ] 000000778549520.768611000000000000 ; 000000840433902.970571000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000004A3F8E8502667E >									
198 	//     < NDRV_PFVII_III_metadata_line_17_____HEPEP II Holding GmbH_20251101 >									
199 	//        < B5T1z39tBA4EgqMhDc9u9P02z604Z0Ij7A73P029i2Sy9zx72qOZakgMW9B5Jpfg >									
200 	//        <  u =="0.000000000000000001" : ] 000000840433902.970571000000000000 ; 000000882847611.706438000000000000 ] >									
201 	//        < 0x00000000000000000000000000000000000000000000000000502667E5431E59 >									
202 	//     < NDRV_PFVII_III_metadata_line_18_____International Insurance Company Of Hannover Limited Sweden_20251101 >									
203 	//        < 62e97vWKtX2yZ21xdbT6WKCf3RLjwZI7a4O26CX2m48VE85X4O7diJ2622j4lE5c >									
204 	//        <  u =="0.000000000000000001" : ] 000000882847611.706438000000000000 ; 000000969578452.798993000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000005431E595C77595 >									
206 	//     < NDRV_PFVII_III_metadata_line_19_____HEPEP III Holding GmbH_20251101 >									
207 	//        < 60Mkjci02gI8idmKRrV2bNLSY980fxhEb1xv4OMPksT3JlLv9pCL6eRh5tMyEe8J >									
208 	//        <  u =="0.000000000000000001" : ] 000000969578452.798993000000000000 ; 000001020685548.062470000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000005C77595615714B >									
210 	//     < NDRV_PFVII_III_metadata_line_20_____Hannover Rueck Beteiligung Verwaltungs_GmbH_20251101 >									
211 	//        < B4FN8H5HD488jKde51YDgw7d7474j4aX53RHfDfCFTuglu9jaV20gWVYkBJPDDDZ >									
212 	//        <  u =="0.000000000000000001" : ] 000001020685548.062470000000000000 ; 000001082200354.840590000000000000 ] >									
213 	//        < 0x00000000000000000000000000000000000000000000000000615714B6734E83 >									
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
256 	//     < NDRV_PFVII_III_metadata_line_21_____EplusS Rückversicherung AG_20251101 >									
257 	//        < 19H63g1jE23x5rDTIbBgGrtUeiZD16z3WnZXomZ9nlGZmw73WP3Y4EPM4B5hnez7 >									
258 	//        <  u =="0.000000000000000001" : ] 000001082200354.840590000000000000 ; 000001122163417.643670000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000006734E836B04916 >									
260 	//     < NDRV_PFVII_III_metadata_line_22_____HILSP Komplementaer GmbH_20251101 >									
261 	//        < v790nUjvDnM5w53rECCaheR6dK8ioGv06ec41rw0w37cN4CBXx6Y6IuQb984OQlO >									
262 	//        <  u =="0.000000000000000001" : ] 000001122163417.643670000000000000 ; 000001162171895.449730000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000006B049166ED5566 >									
264 	//     < NDRV_PFVII_III_metadata_line_23_____Hannover Life Reassurance UK Limited_20251101 >									
265 	//        < ZYhn68SwIsaYY44Jcb2obDVE2nSqsAwRVZC7J793x37A2YOpZzJkr1YX62qu2Yi9 >									
266 	//        <  u =="0.000000000000000001" : ] 000001162171895.449730000000000000 ; 000001188321189.955220000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000006ED55667153BF7 >									
268 	//     < NDRV_PFVII_III_metadata_line_24_____EplusS Reinsurance Ireland Ltd_20251101 >									
269 	//        < iG749beS3On8useRd2TuXI8MB5G3C2pJt3viV08GsCvTW5WiNAQlt7660c2NvW1A >									
270 	//        <  u =="0.000000000000000001" : ] 000001188321189.955220000000000000 ; 000001248336040.487450000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000007153BF7770CF44 >									
272 	//     < NDRV_PFVII_III_metadata_line_25_____Svedea Skadeservice Ab_20251101 >									
273 	//        < 8jT3M41O850N0bR06Adyj9wDklGq7samjD1eeuVHVC7dJh6B5iy6bTlMf8GbybCK >									
274 	//        <  u =="0.000000000000000001" : ] 000001248336040.487450000000000000 ; 000001305076728.899210000000000000 ] >									
275 	//        < 0x00000000000000000000000000000000000000000000000000770CF447C76399 >									
276 	//     < NDRV_PFVII_III_metadata_line_26_____Hannover Finance Luxembourg SA_20251101 >									
277 	//        < 8GVlV0XDsUcK6u0hA1jCIY0Zs7sVFcMxFaBx8xJJ8CxD4S9X7u1Fr7FM64blY9XK >									
278 	//        <  u =="0.000000000000000001" : ] 000001305076728.899210000000000000 ; 000001349593623.215880000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000007C7639980B5102 >									
280 	//     < NDRV_PFVII_III_metadata_line_27_____Hannover Ruckversicherung AG Australia_20251101 >									
281 	//        < 0YI0m6j4EaQrvglacSimbZ311eoTC8P3a6NabjAOKNnCl8tI9mUdHwGX107V7KBC >									
282 	//        <  u =="0.000000000000000001" : ] 000001349593623.215880000000000000 ; 000001425846980.445430000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000080B510287FAB7A >									
284 	//     < NDRV_PFVII_III_metadata_line_28_____Cargo Transit Insurance Pty Limited_20251101 >									
285 	//        < p2xyFD3R9uzy31eO51dk5L1FyVb4TygYgmBfVbvp3r6GghFX43QN59G2bsq4AwKk >									
286 	//        <  u =="0.000000000000000001" : ] 000001425846980.445430000000000000 ; 000001445147594.267070000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000087FAB7A89D1EC7 >									
288 	//     < NDRV_PFVII_III_metadata_line_29_____Hannover Life Re Africa_20251101 >									
289 	//        < LsALDmy4idQMuKI4WNo2ts6NfvSnml9nztX6KEjw27zzx84pz4b5BEK1kwGtNALk >									
290 	//        <  u =="0.000000000000000001" : ] 000001445147594.267070000000000000 ; 000001528333743.004380000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000089D1EC791C0D5E >									
292 	//     < NDRV_PFVII_III_metadata_line_30_____Hannover Re Services USA Inc_20251101 >									
293 	//        < 4s02tK9PQSOiZhZ2Q0HLDUAU4yNOyEER3BEd5VT0eoPfj8nP35GWi4tUhx4qcmUH >									
294 	//        <  u =="0.000000000000000001" : ] 000001528333743.004380000000000000 ; 000001587087262.840730000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000091C0D5E975B3F6 >									
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
338 	//     < NDRV_PFVII_III_metadata_line_31_____Talanx Deutschland AG_20251101 >									
339 	//        < B4W2XAP154A9jI2YINoVx7j4Dmdz3c5vM707j5q7mVIbyAR34EJG4mk4iY3Qdr57 >									
340 	//        <  u =="0.000000000000000001" : ] 000001587087262.840730000000000000 ; 000001651995231.991380000000000000 ] >									
341 	//        < 0x00000000000000000000000000000000000000000000000000975B3F69D8BEA3 >									
342 	//     < NDRV_PFVII_III_metadata_line_32_____HDI Lebensversicherung AG_20251101 >									
343 	//        < qfzyLWeEd9wglzlF865G9gVYLl8184Cbdrm5ocguG6q1No770ecmnFAbIsLY5EQi >									
344 	//        <  u =="0.000000000000000001" : ] 000001651995231.991380000000000000 ; 000001681266320.194790000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000009D8BEA3A0568A8 >									
346 	//     < NDRV_PFVII_III_metadata_line_33_____casa altra development GmbH_20251101 >									
347 	//        < 64cqwV2OjAcNWx6Ly6blp5B71DN56Be5TBo315Bui5H2N4T9m40QH2DOD2ciVjTq >									
348 	//        <  u =="0.000000000000000001" : ] 000001681266320.194790000000000000 ; 000001746206069.291110000000000000 ] >									
349 	//        < 0x00000000000000000000000000000000000000000000000000A0568A8A687FBF >									
350 	//     < NDRV_PFVII_III_metadata_line_34_____Credit Life International Services GmbH_20251101 >									
351 	//        < 4V9L68B11wvL2IpR2774LLfQl043FiqxDlg6EP88go5wRaOGFe8U4XX6v0YAkQPA >									
352 	//        <  u =="0.000000000000000001" : ] 000001746206069.291110000000000000 ; 000001810020940.868950000000000000 ] >									
353 	//        < 0x00000000000000000000000000000000000000000000000000A687FBFAC9DF6E >									
354 	//     < NDRV_PFVII_III_metadata_line_35_____FVB Gesellschaft für Finanz_und Versorgungsberatung mbH_20251101 >									
355 	//        < vxkeRbUQAf6ZrgoCBSYEVo6Qxx080M8UFbohtUj8yxl7HON42n29yQtL8Lgq0J7a >									
356 	//        <  u =="0.000000000000000001" : ] 000001810020940.868950000000000000 ; 000001859643792.639710000000000000 ] >									
357 	//        < 0x00000000000000000000000000000000000000000000000000AC9DF6EB15975B >									
358 	//     < NDRV_PFVII_III_metadata_line_36_____ASPECTA Assurance International AG_20251101 >									
359 	//        < 40Dx6atZ7O4oo8XA3i98RKvIQ6Y3fDLwfxnFiSgrcuMAs9Tj2Q9s7gMo30CT6Xz8 >									
360 	//        <  u =="0.000000000000000001" : ] 000001859643792.639710000000000000 ; 000001938267221.613400000000000000 ] >									
361 	//        < 0x00000000000000000000000000000000000000000000000000B15975BB8D8FA2 >									
362 	//     < NDRV_PFVII_III_metadata_line_37_____Life Re_Holdings_20251101 >									
363 	//        < muMPRLH6LOk66xd6F388wICcmJt6Wdp236MW72h5628vkC5q3p08vI3P46ODldVx >									
364 	//        <  u =="0.000000000000000001" : ] 000001938267221.613400000000000000 ; 000001983864859.664970000000000000 ] >									
365 	//        < 0x00000000000000000000000000000000000000000000000000B8D8FA2BD32336 >									
366 	//     < NDRV_PFVII_III_metadata_line_38_____Credit Life_Pensions_20251101 >									
367 	//        < 92Xqwq71r2p2MUU4X6VJ0O135E8wpgV64IH541xr0sP2dI4d97Iv5rAXHN1QG45i >									
368 	//        <  u =="0.000000000000000001" : ] 000001983864859.664970000000000000 ; 000002027207941.959980000000000000 ] >									
369 	//        < 0x00000000000000000000000000000000000000000000000000BD32336C15461A >									
370 	//     < NDRV_PFVII_III_metadata_line_39_____ASPECTA_org_20251101 >									
371 	//        < tJ8h45eAczPvhQ7FGNIx39983LlOy83n7h7ossKstUP99UfQG863EZ8lkd6IOdqV >									
372 	//        <  u =="0.000000000000000001" : ] 000002027207941.959980000000000000 ; 000002121283515.615840000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000C15461ACA4D260 >									
374 	//     < NDRV_PFVII_III_metadata_line_40_____Cargo Transit_Holdings_20251101 >									
375 	//        < o6VYp145u1ed18Pg5Ll22u1C0cv3s5zoViQl0nMHqSYN0qwq6zEQ7327GUW15658 >									
376 	//        <  u =="0.000000000000000001" : ] 000002121283515.615840000000000000 ; 000002150247123.531500000000000000 ] >									
377 	//        < 0x00000000000000000000000000000000000000000000000000CA4D260CD10448 >									
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