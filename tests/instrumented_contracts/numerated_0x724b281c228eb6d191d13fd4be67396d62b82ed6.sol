1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXII_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXII_I_883		"	;
8 		string	public		symbol =	"	RUSS_PFXII_I_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		608320960998063000000000000					;	
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
92 	//     < RUSS_PFXII_I_metadata_line_1_____TMK_20211101 >									
93 	//        < Mh5Gc2iX95I4672mtR8E97351tR7FaZmDBJ28HyAHA4q52u3u2w5drx29uS2nC1N >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000014240150.533360000000000000 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000000015BA8F >									
96 	//     < RUSS_PFXII_I_metadata_line_2_____TMK_ORG_20211101 >									
97 	//        < 7YSTW2X938DR9jY95iqx7OS4EIfaEV6UGKujS4rFezCe5uKYEUkJ92V331BKjhpx >									
98 	//        <  u =="0.000000000000000001" : ] 000000014240150.533360000000000000 ; 000000028873425.793190300000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000015BA8F2C0EAF >									
100 	//     < RUSS_PFXII_I_metadata_line_3_____TMK_STEEL_LIMITED_20211101 >									
101 	//        < CCiN3D8VnfZ6b2jo7UunD5G002wl10K4JC0wWbfN4YM7s3T7w4t656sG8686ex3K >									
102 	//        <  u =="0.000000000000000001" : ] 000000028873425.793190300000000000 ; 000000045380023.073879900000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000002C0EAF453E92 >									
104 	//     < RUSS_PFXII_I_metadata_line_4_____IPSCO_TUBULARS_INC_20211101 >									
105 	//        < 3W32x2xAyI33PY9D2rCz5xhmoZow01N1s35NWb661ehN7xDKmP2BnW9BOP578F43 >									
106 	//        <  u =="0.000000000000000001" : ] 000000045380023.073879900000000000 ; 000000060222776.900335800000000000 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000000000453E925BE486 >									
108 	//     < RUSS_PFXII_I_metadata_line_5_____VOLZHSKY_PIPE_PLANT_20211101 >									
109 	//        < 2F7KA041uDuwROp3z87DNxD8d73n5KJHx8uKoE04JP3v3V1m6849Eb2x545in4Iy >									
110 	//        <  u =="0.000000000000000001" : ] 000000060222776.900335800000000000 ; 000000075168746.555674200000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000005BE48672B2CB >									
112 	//     < RUSS_PFXII_I_metadata_line_6_____SEVERSKY_PIPE_PLANT_20211101 >									
113 	//        < D1jAoAq3j512XIpyHFEyG7j4C852TbJvT5P1U60FDcHF904T2RLtY1T2IBQXgNYT >									
114 	//        <  u =="0.000000000000000001" : ] 000000075168746.555674200000000000 ; 000000088432753.085307100000000000 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000000000072B2CB86F00B >									
116 	//     < RUSS_PFXII_I_metadata_line_7_____RESITA_WORKS_20211101 >									
117 	//        < UzckNf81Ol27haXZL13LdcLAspivf9ewj13luFJRf68Y4Oki46z79Py1Z4e1q8aW >									
118 	//        <  u =="0.000000000000000001" : ] 000000088432753.085307100000000000 ; 000000103379470.222730000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000000086F00B9DBE9B >									
120 	//     < RUSS_PFXII_I_metadata_line_8_____GULF_INTERNATIONAL_PIPE_INDUSTRY_20211101 >									
121 	//        < 03NG6mIF29A75nApzLWHDwbDZ027I52Axp3162reSF8USh5lFs8vM2nR7t5Q741Q >									
122 	//        <  u =="0.000000000000000001" : ] 000000103379470.222730000000000000 ; 000000120131580.033049000000000000 ] >									
123 	//        < 0x00000000000000000000000000000000000000000000000000009DBE9BB74E66 >									
124 	//     < RUSS_PFXII_I_metadata_line_9_____TMK_PREMIUM_SERVICE_20211101 >									
125 	//        < 4W3ugBo63YZ9mVOiYO9GhqihQxHNN40fIv8941CP6I7RtfGxDYXuN4xuq7SpK7qP >									
126 	//        <  u =="0.000000000000000001" : ] 000000120131580.033049000000000000 ; 000000135575949.827674000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000000B74E66CEDF5B >									
128 	//     < RUSS_PFXII_I_metadata_line_10_____ORSKY_MACHINE_BUILDING_PLANT_20211101 >									
129 	//        < S8kYYaik5xzHRrS5i69HHdI9tuu5iye2aYXr175rzs33fMBwR9KlnV711JjzZ7yO >									
130 	//        <  u =="0.000000000000000001" : ] 000000135575949.827674000000000000 ; 000000148705475.014904000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000000CEDF5BE2E814 >									
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
174 	//     < RUSS_PFXII_I_metadata_line_11_____TMK_CAPITAL_SA_20211101 >									
175 	//        < 1pW2uIwOT74IV0e55squ4n1meUSif40I6K1NcjId6MAhJZuI2l6Qf4k8VoE08CQC >									
176 	//        <  u =="0.000000000000000001" : ] 000000148705475.014904000000000000 ; 000000164904458.214878000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000000E2E814FB9FCE >									
178 	//     < RUSS_PFXII_I_metadata_line_12_____TMK_NSG_LLC_20211101 >									
179 	//        < u7szy0aW2p2mHsVtMG4iGE7eLV2BHPzfYe7q3g5HndIxnhkRWovJhgprWDuGLGmA >									
180 	//        <  u =="0.000000000000000001" : ] 000000164904458.214878000000000000 ; 000000178325075.682662000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000000FB9FCE1101A3C >									
182 	//     < RUSS_PFXII_I_metadata_line_13_____TMK_GLOBAL_AG_20211101 >									
183 	//        < 960gh8KoDp88r7435qnl602SKm1A765Q84JdMIg76Yk74tOJ35P28FzNJs4L0Uhr >									
184 	//        <  u =="0.000000000000000001" : ] 000000178325075.682662000000000000 ; 000000194125470.667404000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001101A3C1283643 >									
186 	//     < RUSS_PFXII_I_metadata_line_14_____TMK_EUROPE_GMBH_20211101 >									
187 	//        < c2vjDv2ntMjIs8kFPO2B75JxnZfgqvS6xsfco6BwIlPvM61j1M16JUmj6y6PFfN9 >									
188 	//        <  u =="0.000000000000000001" : ] 000000194125470.667404000000000000 ; 000000210869686.042589000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000001283643141C2F9 >									
190 	//     < RUSS_PFXII_I_metadata_line_15_____TMK_MIDDLE_EAST_FZCO_20211101 >									
191 	//        < p89XGaLRQ2f4ee4M3d8YRKgEJ7k0AHgiy2qfqbiqE3bd3f9u29rXRus7NmxpJpz6 >									
192 	//        <  u =="0.000000000000000001" : ] 000000210869686.042589000000000000 ; 000000225118461.014831000000000000 ] >									
193 	//        < 0x00000000000000000000000000000000000000000000000000141C2F915780E6 >									
194 	//     < RUSS_PFXII_I_metadata_line_16_____TMK_EUROSINARA_SRL_20211101 >									
195 	//        < E8Hic2Kdnt1Va4Zg4Wn5WaStLC2EF0VwphiVjI7xvAr1ZU40RQn6C14lkl621sM5 >									
196 	//        <  u =="0.000000000000000001" : ] 000000225118461.014831000000000000 ; 000000238769454.429900000000000000 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000000015780E616C5551 >									
198 	//     < RUSS_PFXII_I_metadata_line_17_____TMK_EASTERN_EUROPE_SRL_20211101 >									
199 	//        < 15efgo3mdznRa7U6zhy98eF3hwat8Dog2KO83nS68qu4K9WkLGhLcz8iuL395ESn >									
200 	//        <  u =="0.000000000000000001" : ] 000000238769454.429900000000000000 ; 000000255932623.395731000000000000 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000000016C555118685AE >									
202 	//     < RUSS_PFXII_I_metadata_line_18_____TMK_REAL_ESTATE_SRL_20211101 >									
203 	//        < 5p9L0L8yR0l2H696tfcD6shZ620BRs398v8n7ICkAr638X3Z0nl1bwLmfmGCD0Mv >									
204 	//        <  u =="0.000000000000000001" : ] 000000255932623.395731000000000000 ; 000000272497191.654542000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000018685AE19FCC37 >									
206 	//     < RUSS_PFXII_I_metadata_line_19_____POKROVKA_40_20211101 >									
207 	//        < xrsxo85LSo07tgG38t0DA7dp5OxValoQZ1aYo6yWcL076kan38F38sD7qL94m4aB >									
208 	//        <  u =="0.000000000000000001" : ] 000000272497191.654542000000000000 ; 000000285756227.390008000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000000019FCC371B40787 >									
210 	//     < RUSS_PFXII_I_metadata_line_20_____THREADING_MECHANICAL_KEY_PREMIUM_20211101 >									
211 	//        < G6HJTq3NTEG72sk94T1SA70jXuFas880q59hwd5PW2hknSh00I29re2lAQ7rPwer >									
212 	//        <  u =="0.000000000000000001" : ] 000000285756227.390008000000000000 ; 000000300952770.279426000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000001B407871CB37AD >									
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
256 	//     < RUSS_PFXII_I_metadata_line_21_____TMK_NORTH_AMERICA_INC_20211101 >									
257 	//        < CE2aiiNqcCba6ShO3OI1w147QV3Vcbcg74cL60T5J9HFA924wl4C9FunJ7vpDd04 >									
258 	//        <  u =="0.000000000000000001" : ] 000000300952770.279426000000000000 ; 000000316207442.227362000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000001CB37AD1E27E88 >									
260 	//     < RUSS_PFXII_I_metadata_line_22_____TMK_KAZAKHSTAN_20211101 >									
261 	//        < Yj3PXH9jHJ3oK0FYi2SEjNxcDTMAoMmP45Fja9a00819Ve785MsMGPXAseld9zHS >									
262 	//        <  u =="0.000000000000000001" : ] 000000316207442.227362000000000000 ; 000000333173845.277847000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000001E27E881FC6209 >									
264 	//     < RUSS_PFXII_I_metadata_line_23_____KAZTRUBPROM_20211101 >									
265 	//        < 33q6A7kOSRg226VijJOV7c0VCJ3MZZFaf5tTU12Brf5vOp0Ls7xDaHppOdmR9s5W >									
266 	//        <  u =="0.000000000000000001" : ] 000000333173845.277847000000000000 ; 000000347630985.404761000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000001FC6209212715B >									
268 	//     < RUSS_PFXII_I_metadata_line_24_____PIPE_METALLURGIC_CO_COMPLETIONS_20211101 >									
269 	//        < c3Wm6Mx2ayU2F528MvosgA2K3xr527MxcuHN77WHvH0Lb9iv74k0GM0xZ1H2S1Sr >									
270 	//        <  u =="0.000000000000000001" : ] 000000347630985.404761000000000000 ; 000000363323883.237395000000000000 ] >									
271 	//        < 0x00000000000000000000000000000000000000000000000000212715B22A6364 >									
272 	//     < RUSS_PFXII_I_metadata_line_25_____ZAO_TRADE_HOUSE_TMK_20211101 >									
273 	//        < 6MS0Ne1FZXs8BsRb0HiC6BGgTw3hPz55Ve5wp9PydT5Amt2D85QWj5u7W97JaI2p >									
274 	//        <  u =="0.000000000000000001" : ] 000000363323883.237395000000000000 ; 000000380325303.608395000000000000 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000000000022A63642445492 >									
276 	//     < RUSS_PFXII_I_metadata_line_26_____TMK_ZAO_PIPE_REPAIR_20211101 >									
277 	//        < McyW5174Mv3slNq627q6G9Ou8gr4l5L2rS0lY8D0y0498bB91eQx50rt8vZ3F91z >									
278 	//        <  u =="0.000000000000000001" : ] 000000380325303.608395000000000000 ; 000000396883550.107409000000000000 ] >									
279 	//        < 0x00000000000000000000000000000000000000000000000000244549225D98A3 >									
280 	//     < RUSS_PFXII_I_metadata_line_27_____SINARA_PIPE_WORKS_TRADING_HOUSE_20211101 >									
281 	//        < 62GgSruB0dix2jMfbpTj2W1udoat6duDQZbug60b55Kv7VWg8p7ryYo9kDl60pS0 >									
282 	//        <  u =="0.000000000000000001" : ] 000000396883550.107409000000000000 ; 000000411704216.283444000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000025D98A327435F6 >									
284 	//     < RUSS_PFXII_I_metadata_line_28_____SKLADSKOY_KOMPLEKS_20211101 >									
285 	//        < a49P6IJlxv6Hd35FO4v0tUPd4q816p0TBY0aWa975HM74e12veGVAj3tDtuFUsW1 >									
286 	//        <  u =="0.000000000000000001" : ] 000000411704216.283444000000000000 ; 000000427860336.035075000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000027435F628CDCF2 >									
288 	//     < RUSS_PFXII_I_metadata_line_29_____RUS_RESEARCH_INSTITUTE_TUBE_PIPE_IND_20211101 >									
289 	//        < Ds665I3eOWmo5RTI92P2rDQmb06s8V62H11y5492OLUUHjS197aHdk4wKG5Vo30t >									
290 	//        <  u =="0.000000000000000001" : ] 000000427860336.035075000000000000 ; 000000442755534.961097000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000028CDCF22A39761 >									
292 	//     < RUSS_PFXII_I_metadata_line_30_____TAGANROG_METALLURGICAL_PLANT_20211101 >									
293 	//        < RBNfGYza68VC00xprl6sH5Oqz9Pty76vtZ4lVk2l4qmzVfKOP1rtjzc31Z7DjGO6 >									
294 	//        <  u =="0.000000000000000001" : ] 000000442755534.961097000000000000 ; 000000458278205.580079000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000002A397612BB46ED >									
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
338 	//     < RUSS_PFXII_I_metadata_line_31_____TAGANROG_METALLURGICAL_WORKS_20211101 >									
339 	//        < nQ41mfeHxOmFDb32Sl89Ehyh45W4V422dsicg8C4lrn3MqTQga8l0697Sh7kA839 >									
340 	//        <  u =="0.000000000000000001" : ] 000000458278205.580079000000000000 ; 000000471972675.401917000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000002BB46ED2D02C54 >									
342 	//     < RUSS_PFXII_I_metadata_line_32_____IPSCO_CANADA_LIMITED_20211101 >									
343 	//        < nCc4dVsT4c1h1u4kFM5nyH7MswoN424u952PhU134ul56x9EnU00lmi2CfbTnuau >									
344 	//        <  u =="0.000000000000000001" : ] 000000471972675.401917000000000000 ; 000000485948702.191812000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000002D02C542E57FB6 >									
346 	//     < RUSS_PFXII_I_metadata_line_33_____SINARA_NORTH_AMERICA_INC_20211101 >									
347 	//        < v8xiQ42cAK7i9zG08x9gh9kT3DLinn6dYI9n3aH5Uf2J0Ha50amQ64kesujHZO8t >									
348 	//        <  u =="0.000000000000000001" : ] 000000485948702.191812000000000000 ; 000000502285753.182763000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000002E57FB62FE6D5F >									
350 	//     < RUSS_PFXII_I_metadata_line_34_____PIPE_METALLURGICAL_CO_TRADING_HOUSE_20211101 >									
351 	//        < fh04F2AmCq8MqK4zetudXJ4t7UxkR6jmoNs1aN3C3Zk2ncP19oA72B0B6aT1K7pS >									
352 	//        <  u =="0.000000000000000001" : ] 000000502285753.182763000000000000 ; 000000516475026.411092000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000002FE6D5F314140F >									
354 	//     < RUSS_PFXII_I_metadata_line_35_____TAGANROG_METALLURGICAL_WORKS_20211101 >									
355 	//        < 0h5yCWp4FVG2FuHjC8n5q6qRaK1u172hEt7Qwu48PvkymS9D527E9UJU8Rkt86zO >									
356 	//        <  u =="0.000000000000000001" : ] 000000516475026.411092000000000000 ; 000000532507306.917102000000000000 ] >									
357 	//        < 0x00000000000000000000000000000000000000000000000000314140F32C8AAB >									
358 	//     < RUSS_PFXII_I_metadata_line_36_____SINARSKY_PIPE_PLANT_20211101 >									
359 	//        < 58nh5MY30Hb51bSk0eHNyTvrEw84IGyKlSqPJl39SwUZUzk0yVklpC5g1fsc6iUk >									
360 	//        <  u =="0.000000000000000001" : ] 000000532507306.917102000000000000 ; 000000548440190.093789000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000032C8AAB344DA73 >									
362 	//     < RUSS_PFXII_I_metadata_line_37_____TMK_BONDS_SA_20211101 >									
363 	//        < FxE8T9ySX9ErKB6sZR1fR14Yt0VKDVUODjZxN76m8OG7Gh242jLXwcqLR2XL2YMD >									
364 	//        <  u =="0.000000000000000001" : ] 000000548440190.093789000000000000 ; 000000565671704.201412000000000000 ] >									
365 	//        < 0x00000000000000000000000000000000000000000000000000344DA7335F2582 >									
366 	//     < RUSS_PFXII_I_metadata_line_38_____OOO_CENTRAL_PIPE_YARD_20211101 >									
367 	//        < burRg8xWX0mbX86k93r483kM8dd3YN4y0UQk0D5BtmSlJwi99cDFwhwJCc12t67T >									
368 	//        <  u =="0.000000000000000001" : ] 000000565671704.201412000000000000 ; 000000579461250.586275000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000035F2582374300D >									
370 	//     < RUSS_PFXII_I_metadata_line_39_____SINARA_PIPE_WORKS_20211101 >									
371 	//        < VNcD13Axe2C89ZW0LtqkU81RSu7qf81541SNm3u8s1cL4ftW1k22PVlalo3Y3zB6 >									
372 	//        <  u =="0.000000000000000001" : ] 000000579461250.586275000000000000 ; 000000593387450.150903000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000374300D3896FF9 >									
374 	//     < RUSS_PFXII_I_metadata_line_40_____ZAO_TMK_TRADE_HOUSE_20211101 >									
375 	//        < 4q5K6odNN0R7474jogRMX366VOCY4PZM8bw7xLwV5T1YJ4aW28Zw46sZTvO1N53g >									
376 	//        <  u =="0.000000000000000001" : ] 000000593387450.150903000000000000 ; 000000608320960.998063000000000000 ] >									
377 	//        < 0x000000000000000000000000000000000000000000000000003896FF93A03960 >									
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