1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	SHERE_PFI_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	SHERE_PFI_I_883		"	;
8 		string	public		symbol =	"	SHERE_PFI_I_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		760409854824080000000000000					;	
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
92 	//     < SHERE_PFI_I_metadata_line_1_____UNITED_AIRCRAFT_CORPORATION_20220505 >									
93 	//        < Z9SVqAIv0XB98LuNOaOlujd4LlIInRhP3y08DyipKiKvWBB2D97L6387xaKh4iZ1 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000016314620.208489600000000000 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000000018E4E6 >									
96 	//     < SHERE_PFI_I_metadata_line_2_____China_Russia Commercial Aircraft International Corporation Co_20220505 >									
97 	//        < jws3An69Sw8159ivTJc567G6MW34Ow48PSi7mbpc8JUYov8H6ArTNsg78e2B7Irc >									
98 	//        <  u =="0.000000000000000001" : ] 000000016314620.208489600000000000 ; 000000031599101.034061800000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000018E4E6303766 >									
100 	//     < SHERE_PFI_I_metadata_line_3_____CHINA_RUSSIA_ORG_20220505 >									
101 	//        < qHw3FcXjibOAlHV958R9U4B3X9WZ3PrdEn02FGNC48No68LWDc9674mw0xixJE09 >									
102 	//        <  u =="0.000000000000000001" : ] 000000031599101.034061800000000000 ; 000000052408392.273994500000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000003037664FF807 >									
104 	//     < SHERE_PFI_I_metadata_line_4_____Mutilrole Transport Aircraft Limited_20220505 >									
105 	//        < OM0MLLgT7tEMI66KNCfh2066Bh530lXglRjjRyHqOH0J9Dg9J9dmZGY21fzFtFK4 >									
106 	//        <  u =="0.000000000000000001" : ] 000000052408392.273994500000000000 ; 000000073178514.260795200000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000004FF8076FA95B >									
108 	//     < SHERE_PFI_I_metadata_line_5_____SuperJet International_20220505 >									
109 	//        < B54Ri9619PS93l2Qaaq1lssbAjuiFrUsGHTQHX09Jr4Y3351823su97E9cuL5gCv >									
110 	//        <  u =="0.000000000000000001" : ] 000000073178514.260795200000000000 ; 000000097531356.785904100000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000006FA95B94D230 >									
112 	//     < SHERE_PFI_I_metadata_line_6_____SUPERJET_ORG_20220505 >									
113 	//        < 166gCQ737Z7JY8P9GXO337TE2NkZfU4443xkjJ7iG0qhkm9q78FbC3L6jBwp5lVC >									
114 	//        <  u =="0.000000000000000001" : ] 000000097531356.785904100000000000 ; 000000123309338.877607000000000000 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000000000094D230BC27B6 >									
116 	//     < SHERE_PFI_I_metadata_line_7_____JSC KAPO-Composit_20220505 >									
117 	//        < uc1InvOVgd10M9HgXv8LQ0DOGQsc7X57s5tPs9y4K51h043E3z9Zz88l4lK2z4oD >									
118 	//        <  u =="0.000000000000000001" : ] 000000123309338.877607000000000000 ; 000000147656344.877140000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000BC27B6E14E42 >									
120 	//     < SHERE_PFI_I_metadata_line_8_____JSC Aviastar_SP_20220505 >									
121 	//        < gr40tl08Ivd35yo2ssy0y2Xk5GDwI471018X30wvx35IB404c0aoc3vrslBBXJwg >									
122 	//        <  u =="0.000000000000000001" : ] 000000147656344.877140000000000000 ; 000000161193191.200320000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000E14E42F5F617 >									
124 	//     < SHERE_PFI_I_metadata_line_9_____JSC AeroKompozit_20220505 >									
125 	//        < 1hZC50ISj6EY67J4ElR9sv25p1H52K7nP44Y8HlCNR33JGNd5QEwn13rh6gQYFe5 >									
126 	//        <  u =="0.000000000000000001" : ] 000000161193191.200320000000000000 ; 000000183768814.349172000000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000000F5F61711868B1 >									
128 	//     < SHERE_PFI_I_metadata_line_10_____JSC AeroComposit_Ulyanovsk_20220505 >									
129 	//        < 30Xg75lL5vzDMi2IxJm8Nh2uEFBJM7094zHB10f959E51AKQR8WJqFnoj5phF9Nq >									
130 	//        <  u =="0.000000000000000001" : ] 000000183768814.349172000000000000 ; 000000201732110.019320000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000011868B1133D19B >									
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
174 	//     < SHERE_PFI_I_metadata_line_11_____JSC Sukhoi Civil Aircraft_20220505 >									
175 	//        < DYfF3Sdp9f2F8tYZS6Q9RIzy541B16RUm1lBwH5387BLnf08x8p44omcn8D2OF9n >									
176 	//        <  u =="0.000000000000000001" : ] 000000201732110.019320000000000000 ; 000000219671530.046855000000000000 ] >									
177 	//        < 0x00000000000000000000000000000000000000000000000000133D19B14F3131 >									
178 	//     < SHERE_PFI_I_metadata_line_12_____SUKHOIL_CIVIL_ORG_20220505 >									
179 	//        < NeAs2gpawHzJlj3zxBPvSUtL448P2Y59I3FGhiX0N8CRHXIE1ottEru55E3442G0 >									
180 	//        <  u =="0.000000000000000001" : ] 000000219671530.046855000000000000 ; 000000233656591.292098000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000014F3131164881B >									
182 	//     < SHERE_PFI_I_metadata_line_13_____JSC Flight Research Institute_20220505 >									
183 	//        < jn0Z5SbCJZmnYR2CO4afIowZ2T71Ys2DD0i3RFDG68FPO9gXizSU59nDtbG7t8oG >									
184 	//        <  u =="0.000000000000000001" : ] 000000233656591.292098000000000000 ; 000000255056942.393019000000000000 ] >									
185 	//        < 0x00000000000000000000000000000000000000000000000000164881B1852F9E >									
186 	//     < SHERE_PFI_I_metadata_line_14_____JSC UAC_Transport Aircraft_20220505 >									
187 	//        < 2DbqaKu5ZMD58WiBjQpjdQeouLIY85vvn7A3hQ6UMT8HGGv7sw0W5Bf5O60012dn >									
188 	//        <  u =="0.000000000000000001" : ] 000000255056942.393019000000000000 ; 000000273063798.287001000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000001852F9E1A0A98C >									
190 	//     < SHERE_PFI_I_metadata_line_15_____JSC Russian Aircraft Corporation MiG_20220505 >									
191 	//        < 1I8dT2pvW9D8iAB17XPK09W8Ma3xT4j20ysm7d1VpK04esSQ8cZL3aHXI7Pi9jpS >									
192 	//        <  u =="0.000000000000000001" : ] 000000273063798.287001000000000000 ; 000000295922237.773931000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000001A0A98C1C38AA0 >									
194 	//     < SHERE_PFI_I_metadata_line_16_____MIG_ORG_20220505 >									
195 	//        < ed78Fj6KjiT8y3EvXF5wTSl3AnRL6HkzFpKSxlANJL8Dj77ibEEj5o6Dgpg0lOR9 >									
196 	//        <  u =="0.000000000000000001" : ] 000000295922237.773931000000000000 ; 000000319140014.286075000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000001C38AA01E6F811 >									
198 	//     < SHERE_PFI_I_metadata_line_17_____OJSC Experimental Machine-Building Plant_20220505 >									
199 	//        < 7h03TCR37h6OofvBsNEhK9pO175SHsn86BXFwAtz548QK979w048867L2PL8fmLO >									
200 	//        <  u =="0.000000000000000001" : ] 000000319140014.286075000000000000 ; 000000332886601.942977000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000001E6F8111FBF1D4 >									
202 	//     < SHERE_PFI_I_metadata_line_18_____Irkutsk Aviation Plant_20220505 >									
203 	//        < WT7sN4z4T3z80EbwsgTYanmc9fffydFplYcM64A6C7Yku4KIw3oM3lTw0M3Vi7be >									
204 	//        <  u =="0.000000000000000001" : ] 000000332886601.942977000000000000 ; 000000352592629.455048000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000001FBF1D421A037F >									
206 	//     < SHERE_PFI_I_metadata_line_19_____Gorbunov Kazan Aviation Plant_20220505 >									
207 	//        < 8VZ70a98c68KeW59u4Y9SaidJBkiNynkCJ4eY118DS066pA6O9U8O313p07cUwnx >									
208 	//        <  u =="0.000000000000000001" : ] 000000352592629.455048000000000000 ; 000000366317936.493846000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000000021A037F22EF4F2 >									
210 	//     < SHERE_PFI_I_metadata_line_20_____Komsomolsk_on_Amur Aircraft Plant_20220505 >									
211 	//        < hEh47I0SsWZ6tS2z13PgfE1Ps30R69z9K0f40EN2j4QUN7l0m8sr5bQIM0Y9vr06 >									
212 	//        <  u =="0.000000000000000001" : ] 000000366317936.493846000000000000 ; 000000384617391.131204000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000022EF4F224AE12B >									
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
256 	//     < SHERE_PFI_I_metadata_line_21_____Nizhny Novgorod aircraft building plant Sokol_20220505 >									
257 	//        < T3493ecqWmX0L33u93NR2q885Pvt5N6B950P65OQ0DR0IKis0IIF8L6oF9XYa3l0 >									
258 	//        <  u =="0.000000000000000001" : ] 000000384617391.131204000000000000 ; 000000401384896.700640000000000000 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000000024AE12B26476FA >									
260 	//     < SHERE_PFI_I_metadata_line_22_____NIZHNY_ORG_20220505 >									
261 	//        < 8e7n289Ld519d56c3U79U8631G5OF8UEkNz4N1xIVXFkYid1WunylY9M5k589wFF >									
262 	//        <  u =="0.000000000000000001" : ] 000000401384896.700640000000000000 ; 000000427184112.283439000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000026476FA28BD4CB >									
264 	//     < SHERE_PFI_I_metadata_line_23_____Novosibirsk Aircraft Plant_20220505 >									
265 	//        < TI858WrtGQy8kQ2Ea0p2z7ucfrT8X63y58C4U6j3SPDVoxW3183ZiSOfL6g5p8A0 >									
266 	//        <  u =="0.000000000000000001" : ] 000000427184112.283439000000000000 ; 000000447653726.085796000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000028BD4CB2AB10BD >									
268 	//     < SHERE_PFI_I_metadata_line_24_____NOVO_ORG_20220505 >									
269 	//        < cG2KifXzKyqI4pB8IU6688PcU2jj4T4e2ipwFJz5vP1D2lZS6qWdf7L3ak2l1G90 >									
270 	//        <  u =="0.000000000000000001" : ] 000000447653726.085796000000000000 ; 000000471441857.117643000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000002AB10BD2CF5CFA >									
272 	//     < SHERE_PFI_I_metadata_line_25_____UAC Health_20220505 >									
273 	//        < sH9X9XoOoFhEK3908ZR19i9KB92kmNG9wSt1I4kYADP9m7i67Q9oKSe8KNHVaY0E >									
274 	//        <  u =="0.000000000000000001" : ] 000000471441857.117643000000000000 ; 000000492863523.213590000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002CF5CFA2F00CD0 >									
276 	//     < SHERE_PFI_I_metadata_line_26_____UAC_HEALTH_ORG_20220505 >									
277 	//        < DT236ml1f9PdE1N7g7C9UK7G1y4LW795VAHqJz0bB84R9iWNN5v8EV9JTnRr4de1 >									
278 	//        <  u =="0.000000000000000001" : ] 000000492863523.213590000000000000 ; 000000505873886.617085000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000002F00CD0303E6FD >									
280 	//     < SHERE_PFI_I_metadata_line_27_____JSC Ilyushin Finance Co_20220505 >									
281 	//        < o270CxuL378MMV7j9SeG0s5Walrvk40KOy5s8lvyz7jWdukgn2BU9n2tIUy8DH2G >									
282 	//        <  u =="0.000000000000000001" : ] 000000505873886.617085000000000000 ; 000000521624318.487517000000000000 ] >									
283 	//        < 0x00000000000000000000000000000000000000000000000000303E6FD31BEF80 >									
284 	//     < SHERE_PFI_I_metadata_line_28_____OJSC Experimental Design Bureau_20220505 >									
285 	//        < AJP5JoxbW1is23hK1TEvM2ZE58LLL64vnsm4NHJ6HuQmby93TpQ6893HVx9mP3L4 >									
286 	//        <  u =="0.000000000000000001" : ] 000000521624318.487517000000000000 ; 000000543420459.847022000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000031BEF8033D319E >									
288 	//     < SHERE_PFI_I_metadata_line_29_____LLC UAC_I_20220505 >									
289 	//        < NVgBhh88JwZ2VrM604rTxMUZq19pqVOSVy4b48AY6Ely6e008ZxUR4ZNpiY2VBPl >									
290 	//        <  u =="0.000000000000000001" : ] 000000543420459.847022000000000000 ; 000000557496350.412038000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000033D319E352AC03 >									
292 	//     < SHERE_PFI_I_metadata_line_30_____LLC UAC_II_20220505 >									
293 	//        < o94ScS4xD3g6JX2v0gOZQR4S0392r4VRV0rJN0uhu7cq2qQi8Pm1NhVm6aQ6vbJG >									
294 	//        <  u =="0.000000000000000001" : ] 000000557496350.412038000000000000 ; 000000579533798.094798000000000000 ] >									
295 	//        < 0x00000000000000000000000000000000000000000000000000352AC033744C64 >									
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
338 	//     < SHERE_PFI_I_metadata_line_31_____LLC UAC_III_20220505 >									
339 	//        < z6eFJi204ZTaP45tFRTg5YYIsk1ad296dd7ddU0M05W90NXK2Vz7X85n9oA8Tq4M >									
340 	//        <  u =="0.000000000000000001" : ] 000000579533798.094798000000000000 ; 000000599112081.736126000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000003744C643922C28 >									
342 	//     < SHERE_PFI_I_metadata_line_32_____JSC Ilyushin Aviation Complex_20220505 >									
343 	//        < v80IJzXALqNS2w4G657Io9iWBNpw112LPEbLIx7Oajq1Zd2lNyoE9hXFaffh7df8 >									
344 	//        <  u =="0.000000000000000001" : ] 000000599112081.736126000000000000 ; 000000612467254.005769000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000003922C283A68D05 >									
346 	//     < SHERE_PFI_I_metadata_line_33_____PJSC Voronezh Aircraft Manufacturing Company_20220505 >									
347 	//        < Fs2yoTjXZ1OGt32pL4jkP0J5fW1Ttv4Ha9zlFh71Dnsi56PPy068UkASH1d8Bsp3 >									
348 	//        <  u =="0.000000000000000001" : ] 000000612467254.005769000000000000 ; 000000635895557.973699000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000003A68D053CA4CB4 >									
350 	//     < SHERE_PFI_I_metadata_line_34_____JSC Aviation Holding Company Sukhoi_20220505 >									
351 	//        < 11w6ro4WElo9Ri0y69S8RmHTH4KfqaiaKNUtZHikkTfFqHi37E8Q3j6p21Iu3JSK >									
352 	//        <  u =="0.000000000000000001" : ] 000000635895557.973699000000000000 ; 000000653503711.374216000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000003CA4CB43E52AE3 >									
354 	//     < SHERE_PFI_I_metadata_line_35_____SUKHOI_ORG_20220505 >									
355 	//        < 1eArzm23x0cofyc1cGNUW5ic2ljHDdm45Au5B9OciCyF9i9ZC9uX9VOW1DsCRPHh >									
356 	//        <  u =="0.000000000000000001" : ] 000000653503711.374216000000000000 ; 000000667471262.009799000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000003E52AE33FA7AF6 >									
358 	//     < SHERE_PFI_I_metadata_line_36_____PJSC Scientific and Production Corporation Irkut_20220505 >									
359 	//        < PQyCczJB0Iujrr1948AncV5Hd6304ui7j3TGni20F1Q4G6bL0y5yW3jH31F4jcxo >									
360 	//        <  u =="0.000000000000000001" : ] 000000667471262.009799000000000000 ; 000000685822852.130394000000000000 ] >									
361 	//        < 0x000000000000000000000000000000000000000000000000003FA7AF64167B8D >									
362 	//     < SHERE_PFI_I_metadata_line_37_____PJSC Taganrog Aviation Scientific_Technical Complex_20220505 >									
363 	//        < yFVW9G51FX25n6zg5iCzt2n08w6J4l36Y4m3VwsCBxkeqFbCLRrQ05A9aHB3Oo48 >									
364 	//        <  u =="0.000000000000000001" : ] 000000685822852.130394000000000000 ; 000000701364013.975384000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000004167B8D42E3251 >									
366 	//     < SHERE_PFI_I_metadata_line_38_____PJSC Tupolev_20220505 >									
367 	//        < lSIdKk9nviEUbX9aT8nNK44847kM1yaEreBT3233PY1YyLV0P8Qv18927CToWHv7 >									
368 	//        <  u =="0.000000000000000001" : ] 000000701364013.975384000000000000 ; 000000723139500.306681000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000042E325144F6C5E >									
370 	//     < SHERE_PFI_I_metadata_line_39_____TUPOLEV_ORG_20220505 >									
371 	//        < kSq60J5ntwy8r1k9Z60lV1Ar57o9Fi9In6c5I66ZhQ0GNko98fo5cEc9U6Hp5816 >									
372 	//        <  u =="0.000000000000000001" : ] 000000723139500.306681000000000000 ; 000000747375419.731354000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000044F6C5E4746786 >									
374 	//     < SHERE_PFI_I_metadata_line_40_____The industrial complex N1_20220505 >									
375 	//        < gc41fxXy4hQA0EK7Aa76id78v2yKD9TC9T6hAL9L91qt6QkA4825t51R1Yb5jzzB >									
376 	//        <  u =="0.000000000000000001" : ] 000000747375419.731354000000000000 ; 000000760409854.824080000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000047467864884B19 >									
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