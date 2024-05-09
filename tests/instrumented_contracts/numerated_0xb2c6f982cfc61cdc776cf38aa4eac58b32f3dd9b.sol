1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFV_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFV_III_883		"	;
8 		string	public		symbol =	"	RUSS_PFV_III_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1040488033833410000000000000					;	
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
92 	//     < RUSS_PFV_III_metadata_line_1_____SIRIUS_ORG_20251101 >									
93 	//        < 102HY4LPuoYMrTr4VAibopMXIEuCq35lv87GY0691bMzb17WlKgYDzkmbtFVUEwX >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000031842467.509232100000000000 ] >									
95 	//        < 0x0000000000000000000000000000000000000000000000000000000000309677 >									
96 	//     < RUSS_PFV_III_metadata_line_2_____SIRIUS_DAO_20251101 >									
97 	//        < RAzQbpYTLef9g7II8P9s7Zv3RK8rksR5rC7VofPgl78i2Mp63Q43QFEiyG3S91Px >									
98 	//        <  u =="0.000000000000000001" : ] 000000031842467.509232100000000000 ; 000000054035690.917497200000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000003096775273B1 >									
100 	//     < RUSS_PFV_III_metadata_line_3_____SIRIUS_DAOPI_20251101 >									
101 	//        < tKA4518dVCJOtHi9tC42OG3adGT22nSkLK678gdKKTLL50Xm8t315mw1qh005K8s >									
102 	//        <  u =="0.000000000000000001" : ] 000000054035690.917497200000000000 ; 000000079424043.044966900000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000005273B1793104 >									
104 	//     < RUSS_PFV_III_metadata_line_4_____SIRIUS_BIMI_20251101 >									
105 	//        < 7VAvxt9eEP0sja87Li0Hg2Znv064LCiP6x8LU5292lA19c8taaTEOs12ruZ626UD >									
106 	//        <  u =="0.000000000000000001" : ] 000000079424043.044966900000000000 ; 000000108829757.282133000000000000 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000000000793104A60FA0 >									
108 	//     < RUSS_PFV_III_metadata_line_5_____EDUCATIONAL_CENTER_SIRIUS_ORG_20251101 >									
109 	//        < iJY5f80I842a711C1DrZ906oWbYR8sVneg7GcSjlawS2I7DBmwS089RfWW3E0rvb >									
110 	//        <  u =="0.000000000000000001" : ] 000000108829757.282133000000000000 ; 000000131366670.068908000000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000A60FA0C8731B >									
112 	//     < RUSS_PFV_III_metadata_line_6_____EDUCATIONAL_CENTER_SIRIUS_DAO_20251101 >									
113 	//        < 4GwV8023THzjtmBhDkyECJfd5H2D1JCl51jXYEEqu8A47D0bL70gZ1ZsKZi9Hsj3 >									
114 	//        <  u =="0.000000000000000001" : ] 000000131366670.068908000000000000 ; 000000165128929.537305000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000C8731BFBF77D >									
116 	//     < RUSS_PFV_III_metadata_line_7_____EDUCATIONAL_CENTER_SIRIUS_DAOPI_20251101 >									
117 	//        < hP7BxpQCQ7r2q7t7hWoL2yk1Z1pKioF6151LqhI2cjppxB97h5wKOt4D266dq0eL >									
118 	//        <  u =="0.000000000000000001" : ] 000000165128929.537305000000000000 ; 000000188090238.831709000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000000FBF77D11F00C0 >									
120 	//     < RUSS_PFV_III_metadata_line_8_____EDUCATIONAL_CENTER_SIRIUS_DAC_20251101 >									
121 	//        < Cg6Sn7MEtYdUz372Vxi19TVH11wWiLP636Ex9PcpqV6SIu5s7cD9AAz6CL134qpf >									
122 	//        <  u =="0.000000000000000001" : ] 000000188090238.831709000000000000 ; 000000221849217.110841000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000011F00C015283DA >									
124 	//     < RUSS_PFV_III_metadata_line_9_____SOCHI_PARK_HOTEL_20251101 >									
125 	//        < 14sq5doY52RG1MZc8tC0HWn96lz5740e4KiU7S7g3X7olr9x5y07mHQz9nkEb9th >									
126 	//        <  u =="0.000000000000000001" : ] 000000221849217.110841000000000000 ; 000000241042366.600985000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000015283DA16FCD2D >									
128 	//     < RUSS_PFV_III_metadata_line_10_____GOSTINICHNYY_KOMPLEKS_BOGATYR_20251101 >									
129 	//        < 30Nk3ziFtrdhfnAu433hw42Nsm0p15299u1X2p30GGOmh8Y83412Bsnzyhaf3mH0 >									
130 	//        <  u =="0.000000000000000001" : ] 000000241042366.600985000000000000 ; 000000275452983.825188000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000016FCD2D1A44ED2 >									
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
174 	//     < RUSS_PFV_III_metadata_line_11_____SIRIUS_IKAISA_BIMI_I_20251101 >									
175 	//        < P7yiUI7Kly3dQo3743uvY647VrNz2cRxdKisTzBOzaV5jAJa0XS7nWMCs16q99kA >									
176 	//        <  u =="0.000000000000000001" : ] 000000275452983.825188000000000000 ; 000000305690817.885477000000000000 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000000001A44ED21D2727A >									
178 	//     < RUSS_PFV_III_metadata_line_12_____SIRIUS_IKAISA_BIMI_II_20251101 >									
179 	//        < b0aeKHSkXbtwd0Mt4iKE53W8h76kawrQqR62DvAgLlD94sg6aFFh26CSn6rrR9Js >									
180 	//        <  u =="0.000000000000000001" : ] 000000305690817.885477000000000000 ; 000000325885657.397527000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000001D2727A1F14316 >									
182 	//     < RUSS_PFV_III_metadata_line_13_____SIRIUS_IKAISA_BIMI_III_20251101 >									
183 	//        < AviL0z9Q8K6Tv1YSeCnK0MjHCvj88z00NaT9AHm99Ia1DLrfJbnzSqw9VXo01L0J >									
184 	//        <  u =="0.000000000000000001" : ] 000000325885657.397527000000000000 ; 000000347163279.926510000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001F14316211BAA8 >									
186 	//     < RUSS_PFV_III_metadata_line_14_____SIRIUS_IKAISA_BIMI_IV_20251101 >									
187 	//        < ep5A0r09MXT5QSxb0gpAKrGAqPkoe4txL3jC0sV3184IX86JXfOZxXJg03309oQ9 >									
188 	//        <  u =="0.000000000000000001" : ] 000000347163279.926510000000000000 ; 000000372055329.872605000000000000 ] >									
189 	//        < 0x00000000000000000000000000000000000000000000000000211BAA8237B61D >									
190 	//     < RUSS_PFV_III_metadata_line_15_____SIRIUS_IKAISA_BIMI_V_20251101 >									
191 	//        < Oq14k81QVQ1gPL3S0oIEr2J90DmA19wlX7I3rW6IL6oyii3nC56aB7L1N59oHU0Y >									
192 	//        <  u =="0.000000000000000001" : ] 000000372055329.872605000000000000 ; 000000404125913.400101000000000000 ] >									
193 	//        < 0x00000000000000000000000000000000000000000000000000237B61D268A5AF >									
194 	//     < RUSS_PFV_III_metadata_line_16_____SIRIUS_IKAISA_BIMI_VI_20251101 >									
195 	//        < T358tH5j2xl460xti03c5skeEIulumfPCsvPvnCb2UnEWXUdn93VeKpR9482947S >									
196 	//        <  u =="0.000000000000000001" : ] 000000404125913.400101000000000000 ; 000000422447286.134571000000000000 ] >									
197 	//        < 0x00000000000000000000000000000000000000000000000000268A5AF2849A79 >									
198 	//     < RUSS_PFV_III_metadata_line_17_____SIRIUS_IKAISA_BIMI_VII_20251101 >									
199 	//        < 40ObNO6u51454hzrmP2jIC2JaWe8M2Javirdl8F9641h5e0l9HJOjuT3VatytdbE >									
200 	//        <  u =="0.000000000000000001" : ] 000000422447286.134571000000000000 ; 000000449132986.351541000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000002849A792AD5293 >									
202 	//     < RUSS_PFV_III_metadata_line_18_____SIRIUS_IKAISA_BIMI_VIII_20251101 >									
203 	//        < 654PqqVpbvg2gcsd4NFLfc0XWUt27STeztAPqb3uh1oQxS09khnB1r4FR2Q8XVzX >									
204 	//        <  u =="0.000000000000000001" : ] 000000449132986.351541000000000000 ; 000000483948040.184955000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000002AD52932E27234 >									
206 	//     < RUSS_PFV_III_metadata_line_19_____SIRIUS_IKAISA_BIMI_IX_20251101 >									
207 	//        < Vm2FvQZ126xP8cVwSG3NK7X71jz8vmKXNts9gAxSsDRG381f56D31G033NL0A026 >									
208 	//        <  u =="0.000000000000000001" : ] 000000483948040.184955000000000000 ; 000000507128460.188606000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000002E27234305D10E >									
210 	//     < RUSS_PFV_III_metadata_line_20_____SIRIUS_IKAISA_BIMI_X_20251101 >									
211 	//        < zV69CY85uyw0n3885cO5qOo9V4EnVw9luUV7DiHaqVLNb6OGyCO3wnc9dmq05PHp >									
212 	//        <  u =="0.000000000000000001" : ] 000000507128460.188606000000000000 ; 000000529561238.367854000000000000 ] >									
213 	//        < 0x00000000000000000000000000000000000000000000000000305D10E3280BDC >									
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
256 	//     < RUSS_PFV_III_metadata_line_21_____SOCHI_INFRA_FUND_I_20251101 >									
257 	//        < 30EL9m8BaG700HqNd05gUNrVSJ1NP2Yu82i9zS4Pt98yv2Gx3wliOF9etzdAJQ8J >									
258 	//        <  u =="0.000000000000000001" : ] 000000529561238.367854000000000000 ; 000000558255887.215622000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000003280BDC353D4B5 >									
260 	//     < RUSS_PFV_III_metadata_line_22_____SOCHI_INFRA_FUND_II_20251101 >									
261 	//        < eGpffe4tuc3s7u0P51N335g50ox894qVedo1MpzQ83TJ4Mm2hPLVQ3lxtt1whbmm >									
262 	//        <  u =="0.000000000000000001" : ] 000000558255887.215622000000000000 ; 000000593604318.781841000000000000 ] >									
263 	//        < 0x00000000000000000000000000000000000000000000000000353D4B5389C4B0 >									
264 	//     < RUSS_PFV_III_metadata_line_23_____SOCHI_INFRA_FUND_III_20251101 >									
265 	//        < v68Gc1X9ysGl9G7y7TUfPrM7C1H7IPiOkQIcGSJ6jO9fj96SLT837P4DkSYtjP26 >									
266 	//        <  u =="0.000000000000000001" : ] 000000593604318.781841000000000000 ; 000000616875943.146094000000000000 ] >									
267 	//        < 0x00000000000000000000000000000000000000000000000000389C4B03AD472A >									
268 	//     < RUSS_PFV_III_metadata_line_24_____SOCHI_INFRA_FUND_IV_20251101 >									
269 	//        < 9eDDZqDVIkjMpXP7hZc9Mkp9xmfE8c3fsD0FajN3xX1EqOcrB6TXSGwo2bahD0FV >									
270 	//        <  u =="0.000000000000000001" : ] 000000616875943.146094000000000000 ; 000000637814157.718163000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000003AD472A3CD3A28 >									
272 	//     < RUSS_PFV_III_metadata_line_25_____SOCHI_INFRA_FUND_V_20251101 >									
273 	//        < NpgE6Jz4104V68aODjMJ07YDd9tBMhr9p0x0riko0CSWcLzBcEw6JkRpD3NkuYD3 >									
274 	//        <  u =="0.000000000000000001" : ] 000000637814157.718163000000000000 ; 000000670092598.231752000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000003CD3A283FE7AEC >									
276 	//     < RUSS_PFV_III_metadata_line_26_____LIPNITSK_ORG_20251101 >									
277 	//        < 5nL5xJhX10NLUZhJV9fAT6UBFF57V2bK1OAh3BDodwo9K7MDiIROdTyH8AC02YMI >									
278 	//        <  u =="0.000000000000000001" : ] 000000670092598.231752000000000000 ; 000000690688251.605501000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000003FE7AEC41DE819 >									
280 	//     < RUSS_PFV_III_metadata_line_27_____LIPNITSK_DAO_20251101 >									
281 	//        < iVH1JFUlklQmtjtx4RKRP8frm6889ZmQ332OTVbGscrq0san9bUWpYenybzIK0wV >									
282 	//        <  u =="0.000000000000000001" : ] 000000690688251.605501000000000000 ; 000000723885234.178188000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000041DE8194508FAB >									
284 	//     < RUSS_PFV_III_metadata_line_28_____LIPNITSK_DAC_20251101 >									
285 	//        < 6Sd9h94p2Efjjo4bTMfMaAgdKapFbXV4iYA4vQ9po10FGZoc8BUx497Zct31G37R >									
286 	//        <  u =="0.000000000000000001" : ] 000000723885234.178188000000000000 ; 000000746155623.084131000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000004508FAB4728B0A >									
288 	//     < RUSS_PFV_III_metadata_line_29_____LIPNITSK_ADIDAS_AB_20251101 >									
289 	//        < B00Q0HHSe3M5389IO82n8szys29Gq7T8Yo0fe9mC3lBzA29hNI2F33nf78lysK7b >									
290 	//        <  u =="0.000000000000000001" : ] 000000746155623.084131000000000000 ; 000000767346407.946645000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000004728B0A492E0B1 >									
292 	//     < RUSS_PFV_III_metadata_line_30_____LIPNITSK_ALL_AB_M_ADIDAS_20251101 >									
293 	//        < 7xkfsXq8XeibJO5I2HMo8PfYp76J17A51CY0Mi19Zk26CJOWXl70rW0Kh82Y11AI >									
294 	//        <  u =="0.000000000000000001" : ] 000000767346407.946645000000000000 ; 000000794274372.893344000000000000 ] >									
295 	//        < 0x00000000000000000000000000000000000000000000000000492E0B14BBF76D >									
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
338 	//     < RUSS_PFV_III_metadata_line_31_____ANADYR_ORG_20251101 >									
339 	//        < SQEiXCf8KkoK7edk22j5aq6lzQ8bWatW603QgiZ6voip3QrZnF1354ftB6a2y04v >									
340 	//        <  u =="0.000000000000000001" : ] 000000794274372.893344000000000000 ; 000000822627990.929257000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000004BBF76D4E73B0F >									
342 	//     < RUSS_PFV_III_metadata_line_32_____ANADYR_DAO_20251101 >									
343 	//        < 85siXa0AG83XG18XVmvT75Y01Smqf3hlbIsXMrkJ3u016VOupC2B1fQ68qi405c4 >									
344 	//        <  u =="0.000000000000000001" : ] 000000822627990.929257000000000000 ; 000000843557994.520662000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000004E73B0F5072AD7 >									
346 	//     < RUSS_PFV_III_metadata_line_33_____ANADYR_DAOPI_20251101 >									
347 	//        < ZS7R4p6zy4b5rHc3QUSisK6A8qK354KlQVFClaRKAAFpMa90sU1loMi1dFbql9Vl >									
348 	//        <  u =="0.000000000000000001" : ] 000000843557994.520662000000000000 ; 000000868311564.343631000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000005072AD752CF034 >									
350 	//     < RUSS_PFV_III_metadata_line_34_____CHUKOTKA_ORG_20251101 >									
351 	//        < 1qU5XF3fa76m1w4g8XE9uaUs1QxNc2BHehq6cliY42un4fO5741I06I7dQrUMiMN >									
352 	//        <  u =="0.000000000000000001" : ] 000000868311564.343631000000000000 ; 000000889884829.105852000000000000 ] >									
353 	//        < 0x0000000000000000000000000000000000000000000000000052CF03454DDB43 >									
354 	//     < RUSS_PFV_III_metadata_line_35_____CHUKOTKA_DAO_20251101 >									
355 	//        < Oby0hAvujY9vbUhiipdF4Rvc1b5K4byZmMpn81y95Fr46u2EO7GpCqbDEhT4PFu2 >									
356 	//        <  u =="0.000000000000000001" : ] 000000889884829.105852000000000000 ; 000000919480669.516474000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000054DDB4357B0423 >									
358 	//     < RUSS_PFV_III_metadata_line_36_____CHUKOTKA_DAOPI_20251101 >									
359 	//        < XqA2lwg9j5qfChpb9Z8a9Mm6i7x2PAkSdmVfy8AxeyMd771829Dx941pBX7f8HV6 >									
360 	//        <  u =="0.000000000000000001" : ] 000000919480669.516474000000000000 ; 000000945748847.751205000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000057B04235A31925 >									
362 	//     < RUSS_PFV_III_metadata_line_37_____ANADYR_PORT_ORG_20251101 >									
363 	//        < D04SrXHKVIm5rW2Eb3Jy1gd1J83DyYOq28uWFW1ic7y103Q6WGtA8ZaV78ull77r >									
364 	//        <  u =="0.000000000000000001" : ] 000000945748847.751205000000000000 ; 000000975595748.451960000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000005A319255D0A417 >									
366 	//     < RUSS_PFV_III_metadata_line_38_____INDUSTRIAL_PARK_ANADYR_ORG_20251101 >									
367 	//        < 57X7otb0j30fJm5W65jIi10FHrW9vrPZBDOCrx003GZQBT1rxtQ4x43NmT8d60si >									
368 	//        <  u =="0.000000000000000001" : ] 000000975595748.451960000000000000 ; 000000995896498.479891000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000005D0A4175EF9E12 >									
370 	//     < RUSS_PFV_III_metadata_line_39_____POLE_COLD_SERVICE_20251101 >									
371 	//        < 2brAycmvfk98eX0Q9gWjXG8pe780DK73606XFbYHYb9h6Rc1Iox6579oLtJJy80g >									
372 	//        <  u =="0.000000000000000001" : ] 000000995896498.479891000000000000 ; 000001022150335.914460000000000000 ] >									
373 	//        < 0x000000000000000000000000000000000000000000000000005EF9E12617AD7A >									
374 	//     < RUSS_PFV_III_metadata_line_40_____RED_OCTOBER_CO_20251101 >									
375 	//        < kVM9SXO38IfnvUE83sMatC9a58yT8lFzjDRXe6up06n2hnh093Xn88P1P5R3whjN >									
376 	//        <  u =="0.000000000000000001" : ] 000001022150335.914460000000000000 ; 000001040488033.833410000000000000 ] >									
377 	//        < 0x00000000000000000000000000000000000000000000000000617AD7A633A8A3 >									
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