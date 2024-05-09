1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXXXIV_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXXXIV_I_883		"	;
8 		string	public		symbol =	"	RUSS_PFXXXIV_I_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		612358508633320000000000000					;	
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
92 	//     < RUSS_PFXXXIV_I_metadata_line_1_____PHARMSTANDARD_20211101 >									
93 	//        < ZV19PdLX3KmN47U3O5Fhd81wV919Vaw5cms4uvExkiKw9SI6Dlplk3oNQxlI9YnI >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000014853431.925197200000000000 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000000016AA1F >									
96 	//     < RUSS_PFXXXIV_I_metadata_line_2_____PHARM_DAO_20211101 >									
97 	//        < wJ1cMNx3k9LI3u6FDPJc3N9C0ZP222636aq7k9k3aTk9qVSpusY6vf053JxACM81 >									
98 	//        <  u =="0.000000000000000001" : ] 000000014853431.925197200000000000 ; 000000031872441.873093400000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000016AA1F30A22C >									
100 	//     < RUSS_PFXXXIV_I_metadata_line_3_____PHARM_DAOPI_20211101 >									
101 	//        < b6LLUn8NwK2ig799fSB6tRM9mAXO4el8QLxh5A3qkgQse34PyvOQwBhC9Xj11xbI >									
102 	//        <  u =="0.000000000000000001" : ] 000000031872441.873093400000000000 ; 000000045025769.849747800000000000 ] >									
103 	//        < 0x000000000000000000000000000000000000000000000000000030A22C44B431 >									
104 	//     < RUSS_PFXXXIV_I_metadata_line_4_____PHARM_DAC_20211101 >									
105 	//        < 19V6T21UhtpLsJ820E6xfw8GlFiTae03I5n7RukTR9Z98raaR3FSguKYFZqZwi0o >									
106 	//        <  u =="0.000000000000000001" : ] 000000045025769.849747800000000000 ; 000000061364778.430482300000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000044B4315DA29E >									
108 	//     < RUSS_PFXXXIV_I_metadata_line_5_____PHARM_BIMI_20211101 >									
109 	//        < 92MlQCyAg8RS5VNcQk0RTHYnpUZcd7j8M3Y0HtpZiRfUzTUH7bP4IK9Wz59n7hZy >									
110 	//        <  u =="0.000000000000000001" : ] 000000061364778.430482300000000000 ; 000000078012306.021574200000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000005DA29E77098F >									
112 	//     < RUSS_PFXXXIV_I_metadata_line_6_____GENERIUM_20211101 >									
113 	//        < W01eHS6ed7TXi0kEG2ZLkyeA1Agr7KJ495ZM9c18bw78J5jrGEat8MFtaNLYGt5K >									
114 	//        <  u =="0.000000000000000001" : ] 000000078012306.021574200000000000 ; 000000093972832.121620400000000000 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000000000077098F8F6423 >									
116 	//     < RUSS_PFXXXIV_I_metadata_line_7_____GENERIUM_DAO_20211101 >									
117 	//        < M3N72k75L4ONyCwZGx09bLOj1CqKsJp5o3PRpmj09s45HloHVTwlBsNVN2vRhLoB >									
118 	//        <  u =="0.000000000000000001" : ] 000000093972832.121620400000000000 ; 000000108823150.439228000000000000 ] >									
119 	//        < 0x00000000000000000000000000000000000000000000000000008F6423A60D0B >									
120 	//     < RUSS_PFXXXIV_I_metadata_line_8_____GENERIUM_DAOPI_20211101 >									
121 	//        < 2HDSsJk9ykK6qW96R1sw7liPjx1T0Gu1h49bWF38202fnpe72GeJg3S264XBEF8F >									
122 	//        <  u =="0.000000000000000001" : ] 000000108823150.439228000000000000 ; 000000125308910.236396000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000A60D0BBF34CB >									
124 	//     < RUSS_PFXXXIV_I_metadata_line_9_____GENERIUM_DAC_20211101 >									
125 	//        < L18RYrhYl8B9HvGdR8xiCD3FetC5MjWWD3B1qs97yj5UxoGg85Tzjp7jGKs4F3sj >									
126 	//        <  u =="0.000000000000000001" : ] 000000125308910.236396000000000000 ; 000000139047753.943815000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000000BF34CBD42B87 >									
128 	//     < RUSS_PFXXXIV_I_metadata_line_10_____GENERIUM_BIMI_20211101 >									
129 	//        < VBD8oDkUn1eINLV9VhgowBG4pVRSzjv17Rn75w4vabL39l22MD5PQ0e6bbOrP8hV >									
130 	//        <  u =="0.000000000000000001" : ] 000000139047753.943815000000000000 ; 000000156138989.730097000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000000D42B87EE3FCB >									
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
174 	//     < RUSS_PFXXXIV_I_metadata_line_11_____MASTERLEK_20211101 >									
175 	//        < bptX8c9vr6wix1kQYoiAuOcNEIc74nz3j64IrBhxztexGM458444NJlew1eLCxWJ >									
176 	//        <  u =="0.000000000000000001" : ] 000000156138989.730097000000000000 ; 000000172506261.359860000000000000 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000000000EE3FCB1073942 >									
178 	//     < RUSS_PFXXXIV_I_metadata_line_12_____MASTERLEK_DAO_20211101 >									
179 	//        < 963zKT05cu1vYgGZ6aPb7I4Wci8mmpJf3G8II9Z6r9S8V7I02rkQmPm7Z6v4La8Y >									
180 	//        <  u =="0.000000000000000001" : ] 000000172506261.359860000000000000 ; 000000186520125.204117000000000000 ] >									
181 	//        < 0x00000000000000000000000000000000000000000000000000107394211C9B6D >									
182 	//     < RUSS_PFXXXIV_I_metadata_line_13_____MASTERLEK_DAOPI_20211101 >									
183 	//        < kvgeZcgtL1rV02rjAsiN2O9QiuEbxG09wW2mE3ZBx4Awg50jCn8jyUbi7u7spZh1 >									
184 	//        <  u =="0.000000000000000001" : ] 000000186520125.204117000000000000 ; 000000201204601.262499000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000011C9B6D133038C >									
186 	//     < RUSS_PFXXXIV_I_metadata_line_14_____MASTERLEK_DAC_20211101 >									
187 	//        < E716m6YUAN00EI8262w3x2LHj94J544DE697TB0c7GJNAtt400s32L1eOnv0ILok >									
188 	//        <  u =="0.000000000000000001" : ] 000000201204601.262499000000000000 ; 000000217967224.476750000000000000 ] >									
189 	//        < 0x00000000000000000000000000000000000000000000000000133038C14C9772 >									
190 	//     < RUSS_PFXXXIV_I_metadata_line_15_____MASTERLEK_BIMI_20211101 >									
191 	//        < WV34e1b10aCdUyx4V0LtdVguYY25PuOO6DQkM1vOhD0b7KUD1HqhZ0LIhitKZ466 >									
192 	//        <  u =="0.000000000000000001" : ] 000000217967224.476750000000000000 ; 000000231889804.754476000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000014C9772161D5F4 >									
194 	//     < RUSS_PFXXXIV_I_metadata_line_16_____PHARMSTANDARD_TMK_20211101 >									
195 	//        < 0gb3he52HB4NRkc541Sd3hV1g9EU9QF5ug73ju0Sh5wF2jQF41HituSt910T35L9 >									
196 	//        <  u =="0.000000000000000001" : ] 000000231889804.754476000000000000 ; 000000247732672.500096000000000000 ] >									
197 	//        < 0x00000000000000000000000000000000000000000000000000161D5F417A0293 >									
198 	//     < RUSS_PFXXXIV_I_metadata_line_17_____PHARMSTANDARD_OCTOBER_20211101 >									
199 	//        < vu2A3K5lM35gfT13tx8dx0T6hPCib2VX6mU12WS1r1VTT1Uwx7C7ceda6fHTC0Dv >									
200 	//        <  u =="0.000000000000000001" : ] 000000247732672.500096000000000000 ; 000000261703299.455510000000000000 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000000017A029318F53DA >									
202 	//     < RUSS_PFXXXIV_I_metadata_line_18_____LEKSREDSTVA_20211101 >									
203 	//        < tw20w94kUfaSN05vTz7PfY8248OTO92ylj3Xq1tHnO4VZ3YZTK0lP1vWvbdTmh7J >									
204 	//        <  u =="0.000000000000000001" : ] 000000261703299.455510000000000000 ; 000000274957921.289468000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000018F53DA1A38D70 >									
206 	//     < RUSS_PFXXXIV_I_metadata_line_19_____TYUMEN_PLANT_MED_EQUIP_TOOLS_20211101 >									
207 	//        < T68bUCJ6pbx7St82tnQPcDH5PE9clxvB6qt3pYJsJGZ94pQ277s1iE34A3iWWoMt >									
208 	//        <  u =="0.000000000000000001" : ] 000000274957921.289468000000000000 ; 000000290948005.944984000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000001A38D701BBF391 >									
210 	//     < RUSS_PFXXXIV_I_metadata_line_20_____MASTERPLAZMA_LLC_20211101 >									
211 	//        < vxAIRdb9jWMlCk8t2o1Sb9h9bzzkQjq7d7FR7rTNEEQsSe88GXYqj19vArgSN77P >									
212 	//        <  u =="0.000000000000000001" : ] 000000290948005.944984000000000000 ; 000000305802253.736215000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000001BBF3911D29E01 >									
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
256 	//     < RUSS_PFXXXIV_I_metadata_line_21_____BIGPEARL_TRADING_LIMITED_20211101 >									
257 	//        < XorXc7EVXw21g8Ei5fzkS3K3eDkFeadoQzZ9FLrvPs27q9Y7yd603Gs7ZjPSRuYD >									
258 	//        <  u =="0.000000000000000001" : ] 000000305802253.736215000000000000 ; 000000323059683.362161000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000001D29E011ECF330 >									
260 	//     < RUSS_PFXXXIV_I_metadata_line_22_____BIGPEARL_DAO_20211101 >									
261 	//        < lhSyR7M78aqeQ9348ECxZ2EhQslsao4Bx2Mil62mQ9BtbK8HN7dZpSHNGc1pJm8Y >									
262 	//        <  u =="0.000000000000000001" : ] 000000323059683.362161000000000000 ; 000000339777675.254774000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000001ECF33020675A8 >									
264 	//     < RUSS_PFXXXIV_I_metadata_line_23_____BIGPEARL_DAOPI_20211101 >									
265 	//        < Z0hZDK810jZDh4gm65cOoaa3VaGh559q6MYuvJ1VPo46M0DHyfCE616FxFK48y54 >									
266 	//        <  u =="0.000000000000000001" : ] 000000339777675.254774000000000000 ; 000000354581644.048266000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000020675A821D0C74 >									
268 	//     < RUSS_PFXXXIV_I_metadata_line_24_____BIGPEARL_DAC_20211101 >									
269 	//        < Y39fchv0H7330s8DP97xA3r5D7d3w57Lx2yuIqjR9J73ln8KKdKoF07NH2xdddAr >									
270 	//        <  u =="0.000000000000000001" : ] 000000354581644.048266000000000000 ; 000000369454672.822745000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000021D0C74233BE3B >									
272 	//     < RUSS_PFXXXIV_I_metadata_line_25_____BIGPEARL_BIMI_20211101 >									
273 	//        < 172kUp04uPE4nSk470p6yNijes9XSB3XDly1st86nZ9M4XyefxC468pWJuD10D20 >									
274 	//        <  u =="0.000000000000000001" : ] 000000369454672.822745000000000000 ; 000000386618659.757840000000000000 ] >									
275 	//        < 0x00000000000000000000000000000000000000000000000000233BE3B24DEEEA >									
276 	//     < RUSS_PFXXXIV_I_metadata_line_26_____UFAVITA_20211101 >									
277 	//        < LBvPW75Gx54H01iZp3w23KmZtGd4uyvnJf17VI9zP03xiw5Cb720IiRdwEDa2QI0 >									
278 	//        <  u =="0.000000000000000001" : ] 000000386618659.757840000000000000 ; 000000401993544.268231000000000000 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000000000024DEEEA26564BA >									
280 	//     < RUSS_PFXXXIV_I_metadata_line_27_____DONELLE_COMPANY_LIMITED_20211101 >									
281 	//        < 7r113cf67vA840PjStD7zi45sNn6i630JPmgi61cWl93bYwBC6y4APvlRPBu5k5E >									
282 	//        <  u =="0.000000000000000001" : ] 000000401993544.268231000000000000 ; 000000415893618.253927000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000026564BA27A9A72 >									
284 	//     < RUSS_PFXXXIV_I_metadata_line_28_____DONELLE_CHF_20211101 >									
285 	//        < uNASgYv0J2iFnqW30V4V41NN5msspyO67vgx1Zu35hJhMlNk2PUO0s0X20963kbS >									
286 	//        <  u =="0.000000000000000001" : ] 000000415893618.253927000000000000 ; 000000431379734.322525000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000027A9A722923BB5 >									
288 	//     < RUSS_PFXXXIV_I_metadata_line_29_____VINDEKSFARM_20211101 >									
289 	//        < oTfW0aauT4vqk07PoD2k3k06gQfQap0xnPf93J6MMeZvvxK6u2bZa1hDMKcbKy5G >									
290 	//        <  u =="0.000000000000000001" : ] 000000431379734.322525000000000000 ; 000000444416959.292249000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000002923BB52A62060 >									
292 	//     < RUSS_PFXXXIV_I_metadata_line_30_____TYUMEN_PLANT_CHF_20211101 >									
293 	//        < IIJRY7C5bY7DvCIP5D8b77GU56zmAMe1KPfN5U34f4MkM72tQKGIrg5yrGMz7QJ8 >									
294 	//        <  u =="0.000000000000000001" : ] 000000444416959.292249000000000000 ; 000000459622101.533059000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000002A620602BD53E2 >									
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
338 	//     < RUSS_PFXXXIV_I_metadata_line_31_____LEKKO_20211101 >									
339 	//        < zThJ8o0hNJpOu204RA2hWvlboGg97E0W6GuMqp75mmKJYLz8003oi5xhe5946SK0 >									
340 	//        <  u =="0.000000000000000001" : ] 000000459622101.533059000000000000 ; 000000473496695.783591000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000002BD53E22D27FA6 >									
342 	//     < RUSS_PFXXXIV_I_metadata_line_32_____LEKKO_DAO_20211101 >									
343 	//        < 7aG4DVa1BG6I5Pe4WT52El0wMXo26IM93248pT493U9jcR0x2v3aOBKB7c2G97ux >									
344 	//        <  u =="0.000000000000000001" : ] 000000473496695.783591000000000000 ; 000000487641601.462500000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000002D27FA62E81500 >									
346 	//     < RUSS_PFXXXIV_I_metadata_line_33_____LEKKO_DAOPI_20211101 >									
347 	//        < w8v9i1784P47Aas0AoX36M608cKc417KTSHX6z8BrSaYNUtk0jbp8RAGi3GkO9km >									
348 	//        <  u =="0.000000000000000001" : ] 000000487641601.462500000000000000 ; 000000501288124.672039000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000002E815002FCE7AC >									
350 	//     < RUSS_PFXXXIV_I_metadata_line_34_____LEKKO_DAC_20211101 >									
351 	//        < TR42QRKr8PScvxS7L7Dem05H9qK7JKcgKbOMN60bp7u9XzFhD2ODFV7G8z582Sg7 >									
352 	//        <  u =="0.000000000000000001" : ] 000000501288124.672039000000000000 ; 000000517410618.711822000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000002FCE7AC3158186 >									
354 	//     < RUSS_PFXXXIV_I_metadata_line_35_____LEKKO_BIMI_20211101 >									
355 	//        < 7z2xG8TQb9qC41dw8w9JcT0jts8DX7g3X4R0d5V3B0w9RA5dMCasDXdWBREqmYF3 >									
356 	//        <  u =="0.000000000000000001" : ] 000000517410618.711822000000000000 ; 000000532688028.986038000000000000 ] >									
357 	//        < 0x00000000000000000000000000000000000000000000000000315818632CD143 >									
358 	//     < RUSS_PFXXXIV_I_metadata_line_36_____TOMSKHIMPHARM_20211101 >									
359 	//        < L6I8SLwKd182LJqH6vTT8Q24y40Ly43O7l8KO5xbFsafMhiVv093O7VLt1713134 >									
360 	//        <  u =="0.000000000000000001" : ] 000000532688028.986038000000000000 ; 000000547229052.307609000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000032CD1433430159 >									
362 	//     < RUSS_PFXXXIV_I_metadata_line_37_____TOMSKHIM_CHF_20211101 >									
363 	//        < 3jdZ171sSBq74Fu095c7E7gYTRpocq7n7M04t0Iec0VV2DG8cxsD5v77z2AF704t >									
364 	//        <  u =="0.000000000000000001" : ] 000000547229052.307609000000000000 ; 000000564089209.181378000000000000 ] >									
365 	//        < 0x00000000000000000000000000000000000000000000000000343015935CBB59 >									
366 	//     < RUSS_PFXXXIV_I_metadata_line_38_____FF_LEKKO_ZAO_20211101 >									
367 	//        < i0u4IjJ5GAv3gz5I76ndBDN0UV8HWnEbkpgc8ejynJQMQxhmp5BiD6r6LI13p9d7 >									
368 	//        <  u =="0.000000000000000001" : ] 000000564089209.181378000000000000 ; 000000580621451.104200000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000035CBB59375F541 >									
370 	//     < RUSS_PFXXXIV_I_metadata_line_39_____PHARMSTANDARD_PLAZMA_OOO_20211101 >									
371 	//        < Nkuxk7lmaJ0CzajqH0Lxr9nZoP563744M8ug6HM1ovSLB0l8t48w4R1T842Ki9BG >									
372 	//        <  u =="0.000000000000000001" : ] 000000580621451.104200000000000000 ; 000000595191176.871077000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000375F54138C308E >									
374 	//     < RUSS_PFXXXIV_I_metadata_line_40_____FARMSTANDARD_TOMSKKHIMFOARM_OAO_20211101 >									
375 	//        < 8euSni2PM9a3R4k7ph6VGT02S7IIZne5z8NChoMjX5PeNgT4xViPmRlnK59UE7bF >									
376 	//        <  u =="0.000000000000000001" : ] 000000595191176.871077000000000000 ; 000000612358508.633321000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000038C308E3A6628B >									
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