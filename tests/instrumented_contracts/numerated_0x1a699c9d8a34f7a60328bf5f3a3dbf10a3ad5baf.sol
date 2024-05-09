1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	SEAPORT_Portfolio_II_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	SEAPORT_Portfolio_II_883		"	;
8 		string	public		symbol =	"	SEAPORT883II		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1237146528101310000000000000					;	
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
92 	//     < SEAPORT_Portfolio_II_metadata_line_1_____Krasnoyarsk_Port_Spe_Value_20250515 >									
93 	//        < h5SSYTs2kmePD4Y24CVf36v656xiVi3EhF981CSxdANmjKPn3uy1DYH6Z7v4zZRZ >									
94 	//        < 1E-018 limites [ 1E-018 ; 37320542,1292223 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000000038F256 >									
96 	//     < SEAPORT_Portfolio_II_metadata_line_2_____Kronshtadt_Port_Spe_Value_20250515 >									
97 	//        < 9gEFYns3mYVmNRZr2Co6eu0a13bJqBLGop717pGgkV7yIJmmfz4gi08Ln76Kvjis >									
98 	//        < 1E-018 limites [ 37320542,1292223 ; 63307677,211098 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000038F256609990 >									
100 	//     < SEAPORT_Portfolio_II_metadata_line_3_____Labytnangi_Port_Spe_Value_20250515 >									
101 	//        < Xru6aEANhlsc2W18Yd5oA995211nPXGW13Fk5393r27k982pl2T2g7DpOOwGP25a >									
102 	//        < 1E-018 limites [ 63307677,211098 ; 89982439,5165861 ] >									
103 	//        < 0x0000000000000000000000000000000000000000000000000000609990894D64 >									
104 	//     < SEAPORT_Portfolio_II_metadata_line_4_____Lazarev_Port_Spe_Value_20250515 >									
105 	//        < awE3old1bF86K0jS5Ico5C4KfbD9IA02C6pq2OY2tEl27PkirKxJ7ohhGYmxyghV >									
106 	//        < 1E-018 limites [ 89982439,5165861 ; 139812199,062043 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000000000894D64D55624 >									
108 	//     < SEAPORT_Portfolio_II_metadata_line_5_____Lomonosov_Port_Authority_20250515 >									
109 	//        < rVH50sWM27pL0ZyOCf0i8I7Z6TQ5gv69k1hK52bl3O6S4t67j72Rv2d7Xcv3Eu80 >									
110 	//        < 1E-018 limites [ 139812199,062043 ; 163481566,546536 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000D55624F973FD >									
112 	//     < SEAPORT_Portfolio_II_metadata_line_6_____Magadan_Port_Authority_20250515 >									
113 	//        < qM8W86q6edy1YXX6gX5cPf1jUPDE5c69f02pAqYrvJGTOHq3o4142qQTxzFUjvXs >									
114 	//        < 1E-018 limites [ 163481566,546536 ; 193865163,448014 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000000000F973FD127D094 >									
116 	//     < SEAPORT_Portfolio_II_metadata_line_7_____Mago_Port_Spe_Value_20250515 >									
117 	//        < Z42Tr58FTcP8MB1uh3OMj74cz26JKnSQmm0mZy0zsa6920885YsyUH8y3J1BYkVj >									
118 	//        < 1E-018 limites [ 193865163,448014 ; 220149891,185153 ] >									
119 	//        < 0x00000000000000000000000000000000000000000000000000127D09414FEC0D >									
120 	//     < SEAPORT_Portfolio_II_metadata_line_8_____Makhachkala_Sea_Trade_Port_20250515 >									
121 	//        < i5I2Cw4qj5lKGV6uIqM5xUvc5AuXi0gkq21nnblN7M1gwS5UW3g7xmNJ3sKQpunp >									
122 	//        < 1E-018 limites [ 220149891,185153 ; 261225008,518097 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000014FEC0D18E9905 >									
124 	//     < SEAPORT_Portfolio_II_metadata_line_9_____Makhachkala_Port_Spe_Value_20250515 >									
125 	//        < Q3ckL8Mj7PL8XLMSnNyfY6856ESL3xS44P4e2I4PxS96WrZ31lOy9O0nFf6GF5bb >									
126 	//        < 1E-018 limites [ 261225008,518097 ; 308090672,705512 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000018E99051D61BEB >									
128 	//     < SEAPORT_Portfolio_II_metadata_line_10_____Mezen_Port_Authority_20250515 >									
129 	//        < 6ULIZVCGDH0Y305xtvU8717ZmQs57a3t8ZW46w1UeD5JWq3aqt16k0JgDvw6S76H >									
130 	//        < 1E-018 limites [ 308090672,705512 ; 339325554,308506 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000000001D61BEB205C50B >									
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
174 	//     < SEAPORT_Portfolio_II_metadata_line_11_____Moscow_Port_Spe_Value_20250515 >									
175 	//        < f63o1699ulpM3g5A35c85S2xoo940ytDaMI2MXnR8316E2tE9akDeQ70SK264a4Z >									
176 	//        < 1E-018 limites [ 339325554,308506 ; 357800137,979412 ] >									
177 	//        < 0x00000000000000000000000000000000000000000000000000205C50B221F5AE >									
178 	//     < SEAPORT_Portfolio_II_metadata_line_12_____Murmansk_Port_Authority_20250515 >									
179 	//        < tw04a2AQVW38tZ1v3fGlZDUjU1aU2In0yz0nLzPHfYdiJUQgizaQuKwlvqAWlI31 >									
180 	//        < 1E-018 limites [ 357800137,979412 ; 406854841,491244 ] >									
181 	//        < 0x00000000000000000000000000000000000000000000000000221F5AE26CCFAC >									
182 	//     < SEAPORT_Portfolio_II_metadata_line_13_____Murom_Port_Spe_Value_20250515 >									
183 	//        < 53jhs8R0au0fxk7K2joi0tr5QO7j2H058V7XECd05o06Y8O19D5Z5Hl52WZLrM22 >									
184 	//        < 1E-018 limites [ 406854841,491244 ; 443427177,101728 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000026CCFAC2A49DBE >									
186 	//     < SEAPORT_Portfolio_II_metadata_line_14_____Commercial_Port_Livadia_Limited_20250515 >									
187 	//        < 0tUWuO1rJ4nzkkyFX35JCaHJIN1hlSFh22546epnsW1BXbmJaH5XQv6rMC8DJd6A >									
188 	//        < 1E-018 limites [ 443427177,101728 ; 463905140,849857 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000002A49DBE2C3DCF2 >									
190 	//     < SEAPORT_Portfolio_II_metadata_line_15_____Joint_Stock_Company_Nakhodka_Commercial_Sea_Port_20250515 >									
191 	//        < AUPJVPHjWUvzuxI8nHdY0wd92g38kBaXFb1yUluN11obw2epg7szE5b5ImI38I79 >									
192 	//        < 1E-018 limites [ 463905140,849857 ; 481984275,352298 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000002C3DCF22DF731C >									
194 	//     < SEAPORT_Portfolio_II_metadata_line_16_____Naryan_Mar_Port_Authority_20250515 >									
195 	//        < dczZPArMGJXa9MCGp7z92pQk5pUq0Wb8cj3PTyTE1d0v6LBV316v1044CtK5jvDd >									
196 	//        < 1E-018 limites [ 481984275,352298 ; 531578837,126971 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000002DF731C32B1FFC >									
198 	//     < SEAPORT_Portfolio_II_metadata_line_17_____Nevelsk_Port_Authority_20250515 >									
199 	//        < 02vb2HVTtjn9QAuJFcaj7ny2bYE3U4FJ7c71J4BDxQL2XB9Yz4G1n9LOWg6yzmWC >									
200 	//        < 1E-018 limites [ 531578837,126971 ; 557174543,429669 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000000032B1FFC3522E4E >									
202 	//     < SEAPORT_Portfolio_II_metadata_line_18_____Nikolaevsk_on_Amur_Sea_Port_20250515 >									
203 	//        < 6hHsg522eEx606SVLV2uFKz1HGX81485dl956a15RPO8S4SQ1p3y0vzQ0782Ad55 >									
204 	//        < 1E-018 limites [ 557174543,429669 ; 575206028,05771 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000003522E4E36DB1DB >									
206 	//     < SEAPORT_Portfolio_II_metadata_line_19_____Nizhnevartovsk_Port_Spe_Value_20250515 >									
207 	//        < 2lr55a96dU44MtSB46JdYQ93IoRJS2nEO75viFqRwD9pVxt875kfRX9ZM3Ut27p8 >									
208 	//        < 1E-018 limites [ 575206028,05771 ; 594874048,878873 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000000036DB1DB38BB4AD >									
210 	//     < SEAPORT_Portfolio_II_metadata_line_20_____Novgorod_Port_Spe_Value_20250515 >									
211 	//        < Jpk37o34i8Tz2W5aAMAUAL2Dm3DYk9UG0Ia4iAroj7U9S7nn5x6o32a30Pn8x9Sh >									
212 	//        < 1E-018 limites [ 594874048,878873 ; 628074436,103043 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000038BB4AD3BE5D94 >									
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
256 	//     < SEAPORT_Portfolio_II_metadata_line_21_____JSC_Novoroslesexport_20250515 >									
257 	//        < 2EIQ603mo52CchA78eht4PMp4k005h7hJVy25r40y341Rn3v2nWq213A8SoTKV7F >									
258 	//        < 1E-018 limites [ 628074436,103043 ; 646358470,451486 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000003BE5D943DA43C7 >									
260 	//     < SEAPORT_Portfolio_II_metadata_line_22_____Novorossiysk_Port_Spe_Value_20250515 >									
261 	//        < V0CszlxzvIIS99KPctnEO58Kn1ooJzuwQ0KFN7Ix4Z72ZUAIm380Miz0f6y1vR1T >									
262 	//        < 1E-018 limites [ 646358470,451486 ; 677653565,992141 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000003DA43C740A046D >									
264 	//     < SEAPORT_Portfolio_II_metadata_line_23_____Novosibirsk_Port_Spe_Value_20250515 >									
265 	//        < aJK7jan1p1qmsFuH1A89U9SBS54767c7f4UFYK6I7JMdsyfG1qK8Cd8F4keiWeXo >									
266 	//        < 1E-018 limites [ 677653565,992141 ; 719692467,807047 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000040A046D44A29DF >									
268 	//     < SEAPORT_Portfolio_II_metadata_line_24_____Olga_Port_Authority_20250515 >									
269 	//        < BSqF34P8HHdyz0aPRbtFUkXCJtDAHeVX6B836ABR25VOc0TD9O5kzN3KQOCTwXqc >									
270 	//        < 1E-018 limites [ 719692467,807047 ; 737548084,916969 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000044A29DF46568B8 >									
272 	//     < SEAPORT_Portfolio_II_metadata_line_25_____Omsk_Port_Spe_Value_20250515 >									
273 	//        < 5w6lhE59DKRkY9P8slXI0Sjs64FIDJ8Cm16QgV7mMuqS8WT52qIaWZXBO4fg86u1 >									
274 	//        < 1E-018 limites [ 737548084,916969 ; 759810912,351829 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000000000046568B84876123 >									
276 	//     < SEAPORT_Portfolio_II_metadata_line_26_____Onega_Port_Authority_20250515 >									
277 	//        < YSG01HIHRUhOp6ed2bf84CnF24C23BQJlmK41c23QVibW109BLyh2c5enFy9D73M >									
278 	//        < 1E-018 limites [ 759810912,351829 ; 780183689,534782 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000000000048761234A67741 >									
280 	//     < SEAPORT_Portfolio_II_metadata_line_27_____Perm_Port_Spe_Value_20250515 >									
281 	//        < PWVDj6Ao78XGuNZsLa4SIAH63k61EdY7MzbR3YIQvt7R73Xv9cmo4MrXX84jjzuD >									
282 	//        < 1E-018 limites [ 780183689,534782 ; 801253812,266948 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000004A677414C69DC5 >									
284 	//     < SEAPORT_Portfolio_II_metadata_line_28_____Petropavlovsk_Kamchatskiy_Port_Spe_Value_20250515 >									
285 	//        < Nu4m0TsLFT6fXc4aB69wcCa8m5Ro8ch916zh8c20ig7w6p2Frv43xD4ADInDk7j6 >									
286 	//        < 1E-018 limites [ 801253812,266948 ; 827411237,378695 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000004C69DC54EE8784 >									
288 	//     < SEAPORT_Portfolio_II_metadata_line_29_____Marine_Administration_of_Chukotka_Ports_20250515 >									
289 	//        < WnWH20C8oUt144TfjX1A9uQJGnX2c7rs2KZ92uDrxCd8QwgyPqRnco8R8tFJxRUh >									
290 	//        < 1E-018 limites [ 827411237,378695 ; 870217680,336145 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000004EE878452FD8C8 >									
292 	//     < SEAPORT_Portfolio_II_metadata_line_30_____Poronaysk_Port_Authority_20250515 >									
293 	//        < 6C2Ok3lsS6SujuvJp2tr7URVi1U8R1ieRa9J2Cr03O1A4vtOIv8qziDQ43oBCkoj >									
294 	//        < 1E-018 limites [ 870217680,336145 ; 918218705,158242 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000052FD8C8579172F >									
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
338 	//     < SEAPORT_Portfolio_II_metadata_line_31_____Marine_Administration_of_Vladivostok_Port_Posyet_Branch_20250515 >									
339 	//        < gn7W7X0nt1cDiNpm70BhSDB78eHim5DO110Z70g2B803pEJy2bM4lyA7K2CxL691 >									
340 	//        < 1E-018 limites [ 918218705,158242 ; 951723027,399514 ] >									
341 	//        < 0x00000000000000000000000000000000000000000000000000579172F5AC36CF >									
342 	//     < SEAPORT_Portfolio_II_metadata_line_32_____Primorsk_Port_Authority_20250515 >									
343 	//        < FHrzkjop8S6IzdqCC4JQAbF43p1KpJqclm2eb7uXy3LKY5HCLdmV4QWLD4yA7y4w >									
344 	//        < 1E-018 limites [ 951723027,399514 ; 996989921,879143 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000005AC36CF5F14930 >									
346 	//     < SEAPORT_Portfolio_II_metadata_line_33_____Marine_Administration_of_Chukotka_Ports_20250515 >									
347 	//        < 4hucRUr8cxdbQb1W4vC3Rrae7E8qf9V2C3KOjTtDN5UCE9h3pUQdos8B5F9ELf4c >									
348 	//        < 1E-018 limites [ 996989921,879143 ; 1027322346,81577 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000005F1493061F91CB >									
350 	//     < SEAPORT_Portfolio_II_metadata_line_34_____Rostov_on_Don_Port_Spe_Value_20250515 >									
351 	//        < 3u87h559hKDY2iIs5lI0695LXY0I89dtCF3w9ucbOuU3o67cuzQg1C7L6i0O5moM >									
352 	//        < 1E-018 limites [ 1027322346,81577 ; 1045446214,78618 ] >									
353 	//        < 0x0000000000000000000000000000000000000000000000000061F91CB63B396D >									
354 	//     < SEAPORT_Portfolio_II_metadata_line_35_____Ryazan_Port_Spe_Value_20250515 >									
355 	//        < 6vnQ3A57fJKBJ3fxscj4L36w1Rd2Cz30M1h60W2MWQOpfp1iii20gCU60YAu96j6 >									
356 	//        < 1E-018 limites [ 1045446214,78618 ; 1089690487,88297 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000063B396D67EBC59 >									
358 	//     < SEAPORT_Portfolio_II_metadata_line_36_____Salekhard_Port_Spe_Value_20250515 >									
359 	//        < bGtQ9J7y2OSWc86V0cOT9ZDxx6RU31p3WFzL0M421J0VO692dHJNPGNuW3PiC049 >									
360 	//        < 1E-018 limites [ 1089690487,88297 ;  ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000067EBC596ACCA4B >									
362 	//     < SEAPORT_Portfolio_II_metadata_line_37_____Samara_Port_Spe_Value_20250515 >									
363 	//        < 4ckNE5Ax1t3cdA62hXuz6GaS8mM6FXCZBl18LygwjHh53j91G09ZPCxgUTIT26Ep >									
364 	//        < 1E-018 limites [ 1119872753,76494 ; 1147835076,7578 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000006ACCA4B6D77514 >									
366 	//     < SEAPORT_Portfolio_II_metadata_line_38_____Saratov_Port_Spe_Value_20250515 >									
367 	//        < f5clcyPy3bdaaT6bU1O2BuW6AvRsXVm5s8D6Y98HBDxzvbu29MpYSt2sh8d67DzM >									
368 	//        < 1E-018 limites [ 1147835076,7578 ; 1186968862,49198 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000006D775147132BB6 >									
370 	//     < SEAPORT_Portfolio_II_metadata_line_39_____Sarepta_Port_Spe_Value_20250515 >									
371 	//        < 408ueC5iaKuug4Aab9184UPd2TGUIl9Y7rN0qqcy82hSjyA4i7t691j9DVU9uKmk >									
372 	//        < 1E-018 limites [ 1186968862,49198 ; 1218380341,25779 ] >									
373 	//        < 0x000000000000000000000000000000000000000000000000007132BB674319D2 >									
374 	//     < SEAPORT_Portfolio_II_metadata_line_40_____Serpukhov_Port_Spe_Value_20250515 >									
375 	//        < 4qkl5vDgV9A0i1a2vHIO8LgU2oTVgUj4f89eJiDw199ZkgEVd8S48sn25pj7O58q >									
376 	//        < 1E-018 limites [ 1218380341,25779 ; 1237146528,10131 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000074319D275FBC5D >									
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