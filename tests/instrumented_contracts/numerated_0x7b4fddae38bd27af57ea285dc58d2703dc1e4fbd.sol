1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXXXV_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXXXV_I_883		"	;
8 		string	public		symbol =	"	RUSS_PFXXXV_I_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		609163517964717000000000000					;	
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
92 	//     < RUSS_PFXXXV_I_metadata_line_1_____ALROSA_20211101 >									
93 	//        < 034fwi6jkd3IFspeO6j6245R56z6MdJ9Abbc0tOgg1VYuO97dlv2pbIM79b5mK12 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000016086611.296269000000000000 ] >									
95 	//        < 0x0000000000000000000000000000000000000000000000000000000000188BD5 >									
96 	//     < RUSS_PFXXXV_I_metadata_line_2_____ARCOS_HK_LIMITED_20211101 >									
97 	//        < DDml7X6053RhX4lRvxHl9pG1B33B949OW2zuNCc4XW55olk5qDULMC9yu1iUL3Jf >									
98 	//        <  u =="0.000000000000000001" : ] 000000016086611.296269000000000000 ; 000000031051618.523242900000000000 ] >									
99 	//        < 0x0000000000000000000000000000000000000000000000000000188BD52F618A >									
100 	//     < RUSS_PFXXXV_I_metadata_line_3_____ARCOS_ORG_20211101 >									
101 	//        < XIm5f8uur4fFaI480FuH0ujtM9KK11LSx79HuZ7T4o337A8f2wdxXT68NPwoBAI8 >									
102 	//        <  u =="0.000000000000000001" : ] 000000031051618.523242900000000000 ; 000000046882482.859321100000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000002F618A478978 >									
104 	//     < RUSS_PFXXXV_I_metadata_line_4_____SUNLAND_HOLDINGS_SA_20211101 >									
105 	//        < 72TZD3p7NPFR7JAtY9415S52b6Qr4d84Kgl5wc06VMWp71J81DtTTrU262My6sOf >									
106 	//        <  u =="0.000000000000000001" : ] 000000046882482.859321100000000000 ; 000000062717945.428371800000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000004789785FB333 >									
108 	//     < RUSS_PFXXXV_I_metadata_line_5_____ARCOS_BELGIUM_NV_20211101 >									
109 	//        < Et0bc92fHsPdgO6vPr1SmL8dOrlMoBL7v6JYE5278cci6y3BgVnjum2zEOY35O21 >									
110 	//        <  u =="0.000000000000000001" : ] 000000062717945.428371800000000000 ; 000000075770223.551683000000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000005FB333739DBE >									
112 	//     < RUSS_PFXXXV_I_metadata_line_6_____MEDIAGROUP_SITIM_20211101 >									
113 	//        < 4Bu2cZMU7Biw7up90HDG4gzt64J9SsX9EUQ1ChImto3glwaNbk68P0yu8xLWufmC >									
114 	//        <  u =="0.000000000000000001" : ] 000000075770223.551683000000000000 ; 000000091491540.279097300000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000739DBE8B9AE2 >									
116 	//     < RUSS_PFXXXV_I_metadata_line_7_____ALROSA_FINANCE_BV_20211101 >									
117 	//        < WM832Wi19ruYjgNrA5ru4B19GRVRfJjyNiJX6gd6x0I9ZzVG0RV53CjU3Num7G5A >									
118 	//        <  u =="0.000000000000000001" : ] 000000091491540.279097300000000000 ; 000000108400271.929440000000000000 ] >									
119 	//        < 0x00000000000000000000000000000000000000000000000000008B9AE2A567DB >									
120 	//     < RUSS_PFXXXV_I_metadata_line_8_____SHIPPING_CO_ALROSA_LENA_20211101 >									
121 	//        < 7l7r4d3lyRd9SZfxW0L6affVEi24YWk7A30417717TrZs41JtMj3ltwfqB4p8Op2 >									
122 	//        <  u =="0.000000000000000001" : ] 000000108400271.929440000000000000 ; 000000122963911.366629000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000A567DBBBA0C7 >									
124 	//     < RUSS_PFXXXV_I_metadata_line_9_____LENA_ORG_20211101 >									
125 	//        < fWrXyF748jRq84rpRfPiljx8k5zTxzaoM215340l0FwViC36w61vl4ZV1gA23Aq3 >									
126 	//        <  u =="0.000000000000000001" : ] 000000122963911.366629000000000000 ; 000000138975325.284652000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000000BBA0C7D40F3D >									
128 	//     < RUSS_PFXXXV_I_metadata_line_10_____ALROSA_AFRICA_20211101 >									
129 	//        < 69Yr87A0j5EmkfU1Wuwa97i1TK9Yi9I1NgJL1Pr5yMl4vO4N3TY6e80Se4uLXu96 >									
130 	//        <  u =="0.000000000000000001" : ] 000000138975325.284652000000000000 ; 000000154424908.153007000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000000D40F3DEBA23B >									
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
174 	//     < RUSS_PFXXXV_I_metadata_line_11_____INVESTMENT_GROUP_ALROSA_20211101 >									
175 	//        < f96RRb66w8riePRa1tM908kC6Q9Y0dE69u8VPm5T16ge8nhR63AatMuVaRgld4wp >									
176 	//        <  u =="0.000000000000000001" : ] 000000154424908.153007000000000000 ; 000000169941514.523430000000000000 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000000000EBA23B1034F67 >									
178 	//     < RUSS_PFXXXV_I_metadata_line_12_____INVESTITSIONNAYA_GRUPPA_ALROSA_20211101 >									
179 	//        < 23HHBShMaLo8tS34hNsE2TUsjz4B0V15bZTQ4eEbsUk93S3mIbxH1Uft19iPm647 >									
180 	//        <  u =="0.000000000000000001" : ] 000000169941514.523430000000000000 ; 000000183291056.365387000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000001034F67117AE12 >									
182 	//     < RUSS_PFXXXV_I_metadata_line_13_____VILYUISKAYA_GES_3_20211101 >									
183 	//        < 8uv1ny9iz23WVYd8Q0ZePle6vrcOQ6z5Up09y5v4SSj74dvw575huE5y1Pv1Hi9H >									
184 	//        <  u =="0.000000000000000001" : ] 000000183291056.365387000000000000 ; 000000199791985.902766000000000000 ] >									
185 	//        < 0x00000000000000000000000000000000000000000000000000117AE12130DBBF >									
186 	//     < RUSS_PFXXXV_I_metadata_line_14_____NPP_BUREVESTNIK_20211101 >									
187 	//        < QL5z0a6fl4i272x41jYMdOz23ob1Uk1qg0Yaa07sRRY9NkQjO5L4a72a5t2uAql8 >									
188 	//        <  u =="0.000000000000000001" : ] 000000199791985.902766000000000000 ; 000000216652191.648589000000000000 ] >									
189 	//        < 0x00000000000000000000000000000000000000000000000000130DBBF14A95C3 >									
190 	//     < RUSS_PFXXXV_I_metadata_line_15_____NARNAUL_KRISTALL_FACTORY_20211101 >									
191 	//        < R1J5Tnrz1c8Sz6E2cE49tref79u469sfn97DD598KeJ16rRYqWhGuU48eGhg77o0 >									
192 	//        <  u =="0.000000000000000001" : ] 000000216652191.648589000000000000 ; 000000231555530.639939000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000014A95C31615361 >									
194 	//     < RUSS_PFXXXV_I_metadata_line_16_____NARNAUL_ORG_20211101 >									
195 	//        < AEu4eJ6Xl21Tjsr0SNXudw5Q5rSE13DN94F9Gw2og1TkX6I3yk023672JeN6O36G >									
196 	//        <  u =="0.000000000000000001" : ] 000000231555530.639939000000000000 ; 000000248633127.109067000000000000 ] >									
197 	//        < 0x00000000000000000000000000000000000000000000000000161536117B6251 >									
198 	//     < RUSS_PFXXXV_I_metadata_line_17_____HIDROELECTRICA_CHICAPA_SARL_20211101 >									
199 	//        < dAnXFR5xEpP4Tf59fp9I39b976H7Qb324zIyG7KiL1V2AtBl6r3airV8oeMIW83a >									
200 	//        <  u =="0.000000000000000001" : ] 000000248633127.109067000000000000 ; 000000263061166.652039000000000000 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000000017B62511916645 >									
202 	//     < RUSS_PFXXXV_I_metadata_line_18_____CHICAPA_ORG_20211101 >									
203 	//        < eJEhXmh5PR7g8nIDCW729W5DHujGr3ndu3e7993Z5CVieft8W8Qee1Oj3Lgb2DOz >									
204 	//        <  u =="0.000000000000000001" : ] 000000263061166.652039000000000000 ; 000000279402798.498408000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000019166451AA55B8 >									
206 	//     < RUSS_PFXXXV_I_metadata_line_19_____ALROSA_VGS_LLC_20211101 >									
207 	//        < MS9ubC87vglJJprb4Nlt59xdVrCupH4m464jMxGf0kSv7SEUQ5LQ7OHoF5E918Vg >									
208 	//        <  u =="0.000000000000000001" : ] 000000279402798.498408000000000000 ; 000000294522018.390423000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000001AA55B81C167AA >									
210 	//     < RUSS_PFXXXV_I_metadata_line_20_____ARCOS_DIAMOND_ISRAEL_20211101 >									
211 	//        < 2v9MV5sVvVI3tGUQ9A2N4ZU2C3ZLJfS5Ob9fBQ3t7X24WM9SK85h0FO2sFsVPB9o >									
212 	//        <  u =="0.000000000000000001" : ] 000000294522018.390423000000000000 ; 000000308743706.911977000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000001C167AA1D71B03 >									
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
256 	//     < RUSS_PFXXXV_I_metadata_line_21_____ALMAZY_ANABARA_20211101 >									
257 	//        < z5ujhC91tR27fi70eb2KI89cTpUSPI4P57M95fhuXY0v0sj1whg14l92zz3Z8Q8V >									
258 	//        <  u =="0.000000000000000001" : ] 000000308743706.911977000000000000 ; 000000323927629.916064000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000001D71B031EE463B >									
260 	//     < RUSS_PFXXXV_I_metadata_line_22_____ALMAZY_ORG_20211101 >									
261 	//        < A99PsS7AI6hK7iOO53DGW4gW93Ng8JSRhZ315xz1kT4i7YAi63fQ04Op36xV9kKD >									
262 	//        <  u =="0.000000000000000001" : ] 000000323927629.916064000000000000 ; 000000339710420.055066000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000001EE463B2065B62 >									
264 	//     < RUSS_PFXXXV_I_metadata_line_23_____ALROSA_ORG_20211101 >									
265 	//        < ot4weY8uO0qvLyl9t4nJGe8N7t92me09p1A4TKj6IBu2I5e3VW44ysumJj3HYH2h >									
266 	//        <  u =="0.000000000000000001" : ] 000000339710420.055066000000000000 ; 000000353420174.789605000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000002065B6221B46C1 >									
268 	//     < RUSS_PFXXXV_I_metadata_line_24_____SEVERALMAZ_20211101 >									
269 	//        < gH97b631LQaAKfDuA7q7oEoYYbVs421Z7FvL7N3h9D6b4h1drwwzM6e3glx1oo1w >									
270 	//        <  u =="0.000000000000000001" : ] 000000353420174.789605000000000000 ; 000000367594450.686049000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000021B46C1230E795 >									
272 	//     < RUSS_PFXXXV_I_metadata_line_25_____ARCOS_USA_20211101 >									
273 	//        < 07d2dZq0Hf9rI6R5DG46j3c40A35uFa1C9UaDTm5A4F61mzzQe82gdb7Oh55dRv5 >									
274 	//        <  u =="0.000000000000000001" : ] 000000367594450.686049000000000000 ; 000000384127130.933510000000000000 ] >									
275 	//        < 0x00000000000000000000000000000000000000000000000000230E79524A21A9 >									
276 	//     < RUSS_PFXXXV_I_metadata_line_26_____NYURBA_20211101 >									
277 	//        < eS38S95VvhT79954SOnDE3Ryt4x31BnU7p35JHM1t8OGQf0M9DBi45AvsvJEFY1M >									
278 	//        <  u =="0.000000000000000001" : ] 000000384127130.933510000000000000 ; 000000399985012.185506000000000000 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000000000024A21A92625425 >									
280 	//     < RUSS_PFXXXV_I_metadata_line_27_____NYURBA_ORG_20211101 >									
281 	//        < EB53ZDth0hN7yecuf3537r85ysk1cpZkMUSZ62H0PX2p47Vvz4HR6y4u5Kv5B5A5 >									
282 	//        <  u =="0.000000000000000001" : ] 000000399985012.185506000000000000 ; 000000414491494.582439000000000000 ] >									
283 	//        < 0x00000000000000000000000000000000000000000000000000262542527876BD >									
284 	//     < RUSS_PFXXXV_I_metadata_line_28_____EAST_DMCC_20211101 >									
285 	//        < 57zW7y2S8e0Jize1wP681L49c1229qzggR8bnNS1tVh68os4sC48kebfC7vRwu6f >									
286 	//        <  u =="0.000000000000000001" : ] 000000414491494.582439000000000000 ; 000000428722908.769532000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000027876BD28E2DE3 >									
288 	//     < RUSS_PFXXXV_I_metadata_line_29_____ALROSA_FINANCE_SA_20211101 >									
289 	//        < R9dV4p82qLzm5Hen2a1Qn1v42LL24Yv0myFhuyy8oik9Kq72Lf21v7cwdZealTZB >									
290 	//        <  u =="0.000000000000000001" : ] 000000428722908.769532000000000000 ; 000000444049519.341692000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000028E2DE32A590D8 >									
292 	//     < RUSS_PFXXXV_I_metadata_line_30_____ALROSA_OVERSEAS_SA_20211101 >									
293 	//        < it8bd4529Eo11z62rdn72X5n592RLStHyMIDNQQ6TG3p39q0gboyfCi1zlCmG867 >									
294 	//        <  u =="0.000000000000000001" : ] 000000444049519.341692000000000000 ; 000000457157433.438598000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000002A590D82B9911F >									
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
338 	//     < RUSS_PFXXXV_I_metadata_line_31_____ARCOS_EAST_DMCC_20211101 >									
339 	//        < 6N892ck4or776pFTW28dwFVt73E90AlZ01bF47kzp08951G97qJdh7u49Wuv4HTs >									
340 	//        <  u =="0.000000000000000001" : ] 000000457157433.438598000000000000 ; 000000474086165.930988000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000002B9911F2D365E9 >									
342 	//     < RUSS_PFXXXV_I_metadata_line_32_____HIDROCHICAPA_SARL_20211101 >									
343 	//        < aVNKO3tQR3OZ4PIZw4AojioTwIR5F3l6t7Lh863sGCqLh42Tqa4Cx4sSw24vIIbB >									
344 	//        <  u =="0.000000000000000001" : ] 000000474086165.930988000000000000 ; 000000487495429.364214000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000002D365E92E7DBE7 >									
346 	//     < RUSS_PFXXXV_I_metadata_line_33_____ALROSA_GAZ_20211101 >									
347 	//        < jIDC01OaP1h924A6YN9A7g4x58W056woi0wp212NMgOeA2qKo5vX7S10GKU8HqTb >									
348 	//        <  u =="0.000000000000000001" : ] 000000487495429.364214000000000000 ; 000000504095363.014267000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000002E7DBE73013040 >									
350 	//     < RUSS_PFXXXV_I_metadata_line_34_____SUNLAND_TRADING_SA_20211101 >									
351 	//        < 8OeE23Ldz2WBU0XdNwyL7Jj2xpoeELowVe69i64wQhHz6NmRW4Fko1c7zA13JPlm >									
352 	//        <  u =="0.000000000000000001" : ] 000000504095363.014267000000000000 ; 000000517743574.156170000000000000 ] >									
353 	//        < 0x0000000000000000000000000000000000000000000000000030130403160395 >									
354 	//     < RUSS_PFXXXV_I_metadata_line_35_____ORYOL_ALROSA_20211101 >									
355 	//        < tLFgJ5pe6oC887futVf0ku90J1U7n5r716xK4iD1xbphe96728kQSf6RZ8vH38v4 >									
356 	//        <  u =="0.000000000000000001" : ] 000000517743574.156170000000000000 ; 000000531955109.517475000000000000 ] >									
357 	//        < 0x00000000000000000000000000000000000000000000000000316039532BB2F7 >									
358 	//     < RUSS_PFXXXV_I_metadata_line_36_____GOLUBAYA_VOLNA_HEALTH_RESORT_20211101 >									
359 	//        < 02uUX08gg3BcDQ4u0nt5cSTdzvgq29UFr735QCo38d05NDB5Fn4Y7vB8E49EWN0a >									
360 	//        <  u =="0.000000000000000001" : ] 000000531955109.517475000000000000 ; 000000546395351.604759000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000032BB2F7341BBAF >									
362 	//     < RUSS_PFXXXV_I_metadata_line_37_____GOLUBAYA_ORG_20211101 >									
363 	//        < 5A447xnU7vLlu2XfhCDWDGUdDeO32hnofE6UwTU1E94F23cL6r0LWP9nk10h0lcz >									
364 	//        <  u =="0.000000000000000001" : ] 000000546395351.604759000000000000 ; 000000563522273.927722000000000000 ] >									
365 	//        < 0x00000000000000000000000000000000000000000000000000341BBAF35BDDE3 >									
366 	//     < RUSS_PFXXXV_I_metadata_line_38_____SEVERNAYA_GORNO_GEOLOGIC_KOM_TERRA_20211101 >									
367 	//        < O13c99IN29ODuOReoBI9aBa5hg4f941Fp968Q7107n9P7WE0C6hImOpO9YQ6op82 >									
368 	//        <  u =="0.000000000000000001" : ] 000000563522273.927722000000000000 ; 000000580116892.309645000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000035BDDE33753029 >									
370 	//     < RUSS_PFXXXV_I_metadata_line_39_____SEVERNAYA_ORG_20211101 >									
371 	//        < VKZmE05gDdh477gfoxY2Nku726ajz7DDmOK88VHjGvm6WyHu27ELoN90UyFdi9M2 >									
372 	//        <  u =="0.000000000000000001" : ] 000000580116892.309645000000000000 ; 000000593445902.588076000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000375302938986CE >									
374 	//     < RUSS_PFXXXV_I_metadata_line_40_____ALROSA_NEVA_20211101 >									
375 	//        < ujITbwz99fmen7S9GlQpvIb02662xf3dwW9C5agJZdPq9BN6kj1v411M4T05nR69 >									
376 	//        <  u =="0.000000000000000001" : ] 000000593445902.588076000000000000 ; 000000609163517.964717000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000038986CE3A18280 >									
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