1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	SHERE_PFIV_II_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	SHERE_PFIV_II_883		"	;
8 		string	public		symbol =	"	SHERE_PFIV_II_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1228348805354070000000000000					;	
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
92 	//     < SHERE_PFIV_II_metadata_line_1_____SHEREMETYEVO_AIRPORT_20240505 >									
93 	//        < gg47A2Bcevgsnx4f9Xjm241lvd3W4Lup9yz4eNS3x8UUTQRlR00eT6mKEGys6sRh >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000046969314.909960700000000000 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000000047AB63 >									
96 	//     < SHERE_PFIV_II_metadata_line_2_____SHEREMETYEVO_INTERNATIONAL_AIRPORT_20240505 >									
97 	//        < A2L56xP51123YD4yMN0usR2lSt5q2qg31MfrgzenTo2YMCdj612D5XtKYV5p9Al3 >									
98 	//        <  u =="0.000000000000000001" : ] 000000046969314.909960700000000000 ; 000000079333464.485620100000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000047AB63790DA2 >									
100 	//     < SHERE_PFIV_II_metadata_line_3_____SHEREMETYEVO_HOLDING_LLC_20240505 >									
101 	//        < FyZMjA30UBt6B5bw4Ow3dCQmHo8O38haf42x82suWu9S94hpRVuLrAyUtQy37Jn9 >									
102 	//        <  u =="0.000000000000000001" : ] 000000079333464.485620100000000000 ; 000000103151059.089750000000000000 ] >									
103 	//        < 0x0000000000000000000000000000000000000000000000000000790DA29D6562 >									
104 	//     < SHERE_PFIV_II_metadata_line_4_____TPS_AVIA_PONOMARENKO_ORG_20240505 >									
105 	//        < dIaIW1Oi7c0jbZz2XfLL9Dq57q35ttqcY7WRon45CRh143xguE4MJa0l0vV343sM >									
106 	//        <  u =="0.000000000000000001" : ] 000000103151059.089750000000000000 ; 000000123285901.751355000000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000009D6562BC1E8E >									
108 	//     < SHERE_PFIV_II_metadata_line_5_____TPS_AVIA_SKOROBOGATKO_ORG_20240505 >									
109 	//        < 76I540MLeSH6H3Ms6dP0kalzzGoZ3xdHF2Oqtd34SLA6Ch45qDz2zX64pCF0adbS >									
110 	//        <  u =="0.000000000000000001" : ] 000000123285901.751355000000000000 ; 000000143835730.515110000000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000BC1E8EDB79D5 >									
112 	//     < SHERE_PFIV_II_metadata_line_6_____TPS_AVIA_ROTENBERG_ORG_20240505 >									
113 	//        < Su6zS8oo48xnOo39DxIKhN91vVwvkd4dxS99091Vf9cuUhBT5O6vokyS1QHaaqI4 >									
114 	//        <  u =="0.000000000000000001" : ] 000000143835730.515110000000000000 ; 000000176647133.447510000000000000 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000000000DB79D510D8AC9 >									
116 	//     < SHERE_PFIV_II_metadata_line_7_____ROSIMUSHCHESTVO_20240505 >									
117 	//        < 3Bwo1G7nohLUNsK0jsXumogB6ibLJYvUnL9h8Vc5A1XPS19NJ30q5bHRoTRB8eV5 >									
118 	//        <  u =="0.000000000000000001" : ] 000000176647133.447510000000000000 ; 000000196434097.426043000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000010D8AC912BBC12 >									
120 	//     < SHERE_PFIV_II_metadata_line_8_____VEB_CAPITAL_LLC_20240505 >									
121 	//        < 9hKwSXdVHLs8PPSVL2Y8zb63aif7a41015a30VOU35xjf41ctHPZ4GaI4KrYO7VV >									
122 	//        <  u =="0.000000000000000001" : ] 000000196434097.426043000000000000 ; 000000246187841.558713000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000012BBC12177A720 >									
124 	//     < SHERE_PFIV_II_metadata_line_9_____FRAPORT_20240505 >									
125 	//        < v60ju6V17gvvXsts2R8SgK6Ji9dM62Kbfp3BVc1505aBDG747TfAGJ7hhVEfC7GR >									
126 	//        <  u =="0.000000000000000001" : ] 000000246187841.558713000000000000 ; 000000262365788.995681000000000000 ] >									
127 	//        < 0x00000000000000000000000000000000000000000000000000177A72019056A3 >									
128 	//     < SHERE_PFIV_II_metadata_line_10_____CHANGI_20240505 >									
129 	//        < bU2sQNwIN41Ueu97t6SnyLW7lc4JV0OIRiGFNpHEb3qc6T3D2qBF4Ch3a1z8T01r >									
130 	//        <  u =="0.000000000000000001" : ] 000000262365788.995681000000000000 ; 000000282173294.362289000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000019056A31AE8FF1 >									
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
174 	//     < SHERE_PFIV_II_metadata_line_11_____NORTHERN_CAPITAL_GATEWAY_20240505 >									
175 	//        < q02qQHJHxqpo5L7mMxanFC4RzfGURyQz463VBr2kKNWZ21ZrU1A58038hXHdg5Xt >									
176 	//        <  u =="0.000000000000000001" : ] 000000282173294.362289000000000000 ; 000000322771383.967883000000000000 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000000001AE8FF11EC8292 >									
178 	//     < SHERE_PFIV_II_metadata_line_12_____BASEL_AERO_20240505 >									
179 	//        < D8rd5BZb3edWuVC2X1QBE2Xh3tOH54OB3W2lYycwHf6UEWjNJZre0S8tmEF2G9JZ >									
180 	//        <  u =="0.000000000000000001" : ] 000000322771383.967883000000000000 ; 000000345516830.909469000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000001EC829220F3783 >									
182 	//     < SHERE_PFIV_II_metadata_line_13_____SOGAZ_20240505 >									
183 	//        < R0Be09oWR04x36chInObQoTA5TZx0YXs76fQ63or5yjaTV9sgcfA1SEuJqc1dIC8 >									
184 	//        <  u =="0.000000000000000001" : ] 000000345516830.909469000000000000 ; 000000369400226.974245000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000020F3783233A8F7 >									
186 	//     < SHERE_PFIV_II_metadata_line_14_____NOVI_SAD_20240505 >									
187 	//        < f6t6DuW3i5D7EYL0C3odj8L18lNXlz031o1ndmebjSt6080keKkLihF56b4dR0KB >									
188 	//        <  u =="0.000000000000000001" : ] 000000369400226.974245000000000000 ; 000000400050888.199267000000000000 ] >									
189 	//        < 0x00000000000000000000000000000000000000000000000000233A8F72626DE1 >									
190 	//     < SHERE_PFIV_II_metadata_line_15_____INSURANCE_COMPANY_ALROSA_20240505 >									
191 	//        < vy6YDm3v2a57twpn8PA96mA1QkB3193blvlb5zxIM7xh653Cig556TLzD2akxI6s >									
192 	//        <  u =="0.000000000000000001" : ] 000000400050888.199267000000000000 ; 000000430279142.541815000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000002626DE12908DCA >									
194 	//     < SHERE_PFIV_II_metadata_line_16_____IC_AL_SO_20240505 >									
195 	//        < JNEQTFaRZbXlKXn6Ni7C3QOF4cp9PH2RIuHQR5LOY6y87ijvr4cI6iY2u11MmF2c >									
196 	//        <  u =="0.000000000000000001" : ] 000000430279142.541815000000000000 ; 000000474768044.166242000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000002908DCA2D47044 >									
198 	//     < SHERE_PFIV_II_metadata_line_17_____PIPELINE_INSURANCE_COMPANY_20240505 >									
199 	//        < 7ja6bd6LXtn69zToFeWNR8guP3wWs97Kf52dulUrCscq6fk8rwMINk2Gvyb5D8NL >									
200 	//        <  u =="0.000000000000000001" : ] 000000474768044.166242000000000000 ; 000000511813795.716410000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000002D4704430CF744 >									
202 	//     < SHERE_PFIV_II_metadata_line_18_____SOGAZ_MED_20240505 >									
203 	//        < h0AG881r23i8Z0Qx5c080XxWUQaWKFBYTa6tgxyRNMVS3W22zAheA745B0kzEy5V >									
204 	//        <  u =="0.000000000000000001" : ] 000000511813795.716410000000000000 ; 000000556899685.428691000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000030CF744351C2F1 >									
206 	//     < SHERE_PFIV_II_metadata_line_19_____IC_TRANSNEFT_20240505 >									
207 	//        < U77MB716ZnbTlbAM1Uz24567WKB2TgLgj3C592XXi1H2AOQO03J22B9Dx81QbfeN >									
208 	//        <  u =="0.000000000000000001" : ] 000000556899685.428691000000000000 ; 000000605584566.868246000000000000 ] >									
209 	//        < 0x00000000000000000000000000000000000000000000000000351C2F139C0C79 >									
210 	//     < SHERE_PFIV_II_metadata_line_20_____SHEKSNA_20240505 >									
211 	//        < nDuH6Izw9gzaOn9s4tYr4T365B728krhYBSXI7D2M69k64kmx86JiqNSmP55HMb3 >									
212 	//        <  u =="0.000000000000000001" : ] 000000605584566.868246000000000000 ; 000000624222965.344876000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000039C0C793B87D19 >									
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
256 	//     < SHERE_PFIV_II_metadata_line_21_____Akcionarsko Drustvo Zaosiguranje_20240505 >									
257 	//        < HB6FEC731hn6MQ6Ut6c3WAeb3H8Nk0ew9hDXlpj1PKiaDfOw69e6qQmbVu91rc5k >									
258 	//        <  u =="0.000000000000000001" : ] 000000624222965.344876000000000000 ; 000000644298140.905239000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000003B87D193D71EF6 >									
260 	//     < SHERE_PFIV_II_metadata_line_22_____SOGAZ_LIFE_20240505 >									
261 	//        < TvW1N12IUaSrnh3IXgLDlN6dWF0lk4K6415kwl5k8w4MQ1x0qpwCYmrmH5m8wySj >									
262 	//        <  u =="0.000000000000000001" : ] 000000644298140.905239000000000000 ; 000000693375393.741346000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000003D71EF642201C3 >									
264 	//     < SHERE_PFIV_II_metadata_line_23_____SOGAZ_SERBIA_20240505 >									
265 	//        < 8F29f5kJmHfc063s79yQzyyZaWphMu3xxb4xVA67VrOvJSrEHSP0ibZEjmq6dah4 >									
266 	//        <  u =="0.000000000000000001" : ] 000000693375393.741346000000000000 ; 000000722807579.228789000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000042201C344EEAB6 >									
268 	//     < SHERE_PFIV_II_metadata_line_24_____ZHASO_20240505 >									
269 	//        < j4BI3Q01s6S2t9U6wdfrL1qUid738nIKnkaK7PGi6UqB9J48BiqgdRHQq4bR6BMz >									
270 	//        <  u =="0.000000000000000001" : ] 000000722807579.228789000000000000 ; 000000743383258.940060000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000044EEAB646E5016 >									
272 	//     < SHERE_PFIV_II_metadata_line_25_____VTB_INSURANCE_ORG_20240505 >									
273 	//        < 22n0J5QnTQ125f0YL24ipUgs65eP7elQy68XcKdq4UccSaciP0vW64ole0sewDNl >									
274 	//        <  u =="0.000000000000000001" : ] 000000743383258.940060000000000000 ; 000000776533017.412679000000000000 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000000000046E50164A0E536 >									
276 	//     < SHERE_PFIV_II_metadata_line_26_____Vympel_Vostok_20240505 >									
277 	//        < bB3BCOIZ6E1rK2kXg8C31L89LH8918BbxY4bXt031twBy8uOVQ89fX3PQ9X17jbe >									
278 	//        <  u =="0.000000000000000001" : ] 000000776533017.412679000000000000 ; 000000823301352.211158000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000004A0E5364E84217 >									
280 	//     < SHERE_PFIV_II_metadata_line_27_____Oblatsnaya_Meditsinskaya_Strakho__20240505 >									
281 	//        < 272ag603c7lFDMJ08Qm3y4r9Lwf21iCKVI8b1MhFiNpGEynyVUf297vgKloai56E >									
282 	//        <  u =="0.000000000000000001" : ] 000000823301352.211158000000000000 ; 000000861703406.095370000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000004E84217522DAE5 >									
284 	//     < SHERE_PFIV_II_metadata_line_28_____Medika_Tomsk_20240505 >									
285 	//        < GF6NWy1d3jA8w2W3Z1U6l07Ee6YcDQ5yy29WA3m1L5AewLl9gvJ64s41SeAyNvSl >									
286 	//        <  u =="0.000000000000000001" : ] 000000861703406.095370000000000000 ; 000000882736405.253825000000000000 ] >									
287 	//        < 0x00000000000000000000000000000000000000000000000000522DAE5542F2E9 >									
288 	//     < SHERE_PFIV_II_metadata_line_29_____Medical_Insurance_Company_20240505 >									
289 	//        < ctXVpdH3u5uxS33U4Jw8X3GHv51E9FRhToqPl3hEAOLlVpT7945N3SwW48pl19i0 >									
290 	//        <  u =="0.000000000000000001" : ] 000000882736405.253825000000000000 ; 000000904174931.867310000000000000 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000000000542F2E9563A955 >									
292 	//     < SHERE_PFIV_II_metadata_line_30_____MSK_MED_20240505 >									
293 	//        < VXu3tMsz3T19Z6YG7g00ic9iKMu7Z1C4jTiJ3aYFZuTkzU8MtiBGqGV41qFh74W4 >									
294 	//        <  u =="0.000000000000000001" : ] 000000904174931.867310000000000000 ; 000000920788917.993543000000000000 ] >									
295 	//        < 0x00000000000000000000000000000000000000000000000000563A95557D032C >									
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
338 	//     < SHERE_PFIV_II_metadata_line_31_____SG_MSK_20240505 >									
339 	//        < eagRG6gWqFHLf250zSm39G411t2J9s0JA62n46OE40zARCiS21sx8xM5uCZH1oN2 >									
340 	//        <  u =="0.000000000000000001" : ] 000000920788917.993543000000000000 ; 000000958290955.953617000000000000 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000000000057D032C5B63C68 >									
342 	//     < SHERE_PFIV_II_metadata_line_32_____ROSNO_MS_20240505 >									
343 	//        < 48OB1dG0rt1j7lEroR4q6w00sLdCg6hg1DXo5bdHb2g0rraRWW9st007427A3Lnd >									
344 	//        <  u =="0.000000000000000001" : ] 000000958290955.953617000000000000 ; 000000975446601.544421000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000005B63C685D069D4 >									
346 	//     < SHERE_PFIV_II_metadata_line_33_____VTB_Life_Insurance_20240505 >									
347 	//        < 39V8gPv98hlOdd1smY393hvlW1oP7oDbdxV3swA0VbK9CYq1oyL9567XF8Kh1Pp0 >									
348 	//        <  u =="0.000000000000000001" : ] 000000975446601.544421000000000000 ; 000001016858820.105760000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000005D069D460F9A7A >									
350 	//     < SHERE_PFIV_II_metadata_line_34_____Company_Moskovsko__20240505 >									
351 	//        < 0TyZ62oE6wd7e3DUamsL6Pvjh9Ak08jn1mb6PAZRHXh30WdwxrR6BRe84xZj2974 >									
352 	//        <  u =="0.000000000000000001" : ] 000001016858820.105760000000000000 ; 000001065033604.070430000000000000 ] >									
353 	//        < 0x0000000000000000000000000000000000000000000000000060F9A7A6591CC0 >									
354 	//     < SHERE_PFIV_II_metadata_line_35_____VTB_Meditsinskoye_Strakho__20240505 >									
355 	//        < 2eVn964k8AC1UrxN3bGNL2yn4183kADDRQ9g468j9rQ94L71SFc54VmYAoa43iop >									
356 	//        <  u =="0.000000000000000001" : ] 000001065033604.070430000000000000 ; 000001098126943.468200000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000006591CC068B9BD6 >									
358 	//     < SHERE_PFIV_II_metadata_line_36_____SPASSKIYE_VOROTA_INSURANCE_GROUP_20240505 >									
359 	//        < ZDVQu7yv1Mxs184XM0Y98Z5LrQIDUO9jeTaMebsTmH12SUynwy41gZ0G0G7zk5Tq >									
360 	//        <  u =="0.000000000000000001" : ] 000001098126943.468200000000000000 ; 000001116006509.980820000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000068B9BD66A6E40B >									
362 	//     < SHERE_PFIV_II_metadata_line_37_____CASCO_MED_INS_20240505 >									
363 	//        < 952zM8tBsVN03f9uyc41ZaQww7jlz68c9DrHImhWHdJyuM23vsfzIn994TBuLfRx >									
364 	//        <  u =="0.000000000000000001" : ] 000001116006509.980820000000000000 ; 000001152557517.853900000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000006A6E40B6DEA9C8 >									
366 	//     < SHERE_PFIV_II_metadata_line_38_____SMK_NOVOLIPETSKAYA_20240505 >									
367 	//        < 8HPt05990oITJrwCJE0L2t7564F1rpn39z6PmSeCelA1u935D8x1VK61jSJns489 >									
368 	//        <  u =="0.000000000000000001" : ] 000001152557517.853900000000000000 ; 000001178414314.271110000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000006DEA9C87061E17 >									
370 	//     < SHERE_PFIV_II_metadata_line_39_____MOSKOVSKOE_PERETRAKHOVOCHNOE_OBSHESTVO_20240505 >									
371 	//        < c7u7x6h13oWut24WQ2kF583dmiXQAIJQCUn06CQPS1XONIrncBeTn9F83JL7RS5O >									
372 	//        <  u =="0.000000000000000001" : ] 000001178414314.271110000000000000 ; 000001194029002.340090000000000000 ] >									
373 	//        < 0x000000000000000000000000000000000000000000000000007061E1771DF194 >									
374 	//     < SHERE_PFIV_II_metadata_line_40_____RESO_20240505 >									
375 	//        < 3vQnhhMYxe6m1Gckgqn84yU4Y0QcNdXqT12seUE0C8ZDYGqzK052IhEgGC7LvC5e >									
376 	//        <  u =="0.000000000000000001" : ] 000001194029002.340090000000000000 ; 000001228348805.354070000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000071DF1947524FC1 >									
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