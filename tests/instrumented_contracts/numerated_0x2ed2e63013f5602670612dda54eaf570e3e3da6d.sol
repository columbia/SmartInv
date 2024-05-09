1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXV_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXV_I_883		"	;
8 		string	public		symbol =	"	RUSS_PFXV_I_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		613997134018603000000000000					;	
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
92 	//     < RUSS_PFXV_I_metadata_line_1_____POLYMETAL_20211101 >									
93 	//        < wQ8fudfviVXn7Tnk8qtXaffgATTj6396DgBWVy8zU2p3z5g8QR57cLv7iDb1tvJ0 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000016424582.865973100000000000 ] >									
95 	//        < 0x0000000000000000000000000000000000000000000000000000000000190FDA >									
96 	//     < RUSS_PFXV_I_metadata_line_2_____POLYMETAL_GBP_20211101 >									
97 	//        < QxWP0uYQp25BVkVJ0WJ3a9NV7du8JxB5rr6rDA6vZkVdbCgSzt2z4v5Kgialz9a5 >									
98 	//        <  u =="0.000000000000000001" : ] 000000016424582.865973100000000000 ; 000000031281695.212333800000000000 ] >									
99 	//        < 0x0000000000000000000000000000000000000000000000000000190FDA2FBB6A >									
100 	//     < RUSS_PFXV_I_metadata_line_3_____POLYMETAL_USD_20211101 >									
101 	//        < FZ8U1XYCJe2N0AWOrvA80DdEF3xp9aiV35tQu1n2JrP21fG21RHP13j4UXZfg98f >									
102 	//        <  u =="0.000000000000000001" : ] 000000031281695.212333800000000000 ; 000000046757277.559557500000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000002FBB6A475890 >									
104 	//     < RUSS_PFXV_I_metadata_line_4_____POLYMETAL_ORG_20211101 >									
105 	//        < 7Mok1CiRH29E5S7Cn40MR8rFdUhu17PoxyI5EnmTYhYfR7c93aG8vKB5ZfchY4zX >									
106 	//        <  u =="0.000000000000000001" : ] 000000046757277.559557500000000000 ; 000000061626945.326917700000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000004758905E0907 >									
108 	//     < RUSS_PFXV_I_metadata_line_5_____POLYMETAL_DAO_20211101 >									
109 	//        < 8Bk749F538kuKS9r48E56UtD7KkcF4qT7EJJdd8tiG7NC4M62DG8Bp592d68Y63b >									
110 	//        <  u =="0.000000000000000001" : ] 000000061626945.326917700000000000 ; 000000076946204.851110200000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000005E090775691C >									
112 	//     < RUSS_PFXV_I_metadata_line_6_____POLYMETAL_DAC_20211101 >									
113 	//        < Jw7T68vx9v4tceCcR6VS39ZNTULd5nZS2Eyxsk1deQjVb2atiy676UxEWf4U0mn7 >									
114 	//        <  u =="0.000000000000000001" : ] 000000076946204.851110200000000000 ; 000000092903348.960087900000000000 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000000000075691C8DC25F >									
116 	//     < RUSS_PFXV_I_metadata_line_7_____PPF_GROUP_RUB_20211101 >									
117 	//        < jHWrwa95x4Tm6grjpNWa00d9e2DOD50Zwb1232CX534DHrRdLVK0mdorurf54nkT >									
118 	//        <  u =="0.000000000000000001" : ] 000000092903348.960087900000000000 ; 000000109288010.662260000000000000 ] >									
119 	//        < 0x00000000000000000000000000000000000000000000000000008DC25FA6C2A1 >									
120 	//     < RUSS_PFXV_I_metadata_line_8_____PPF_GROUP_RUB_AB_20211101 >									
121 	//        < TANowkT3ymhL6ilDJxJ73Oa21w72amZ0vtup3Xu9qpw48gf1ppVD5zMp8HUO0A29 >									
122 	//        <  u =="0.000000000000000001" : ] 000000109288010.662260000000000000 ; 000000125687571.849210000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000A6C2A1BFC8B5 >									
124 	//     < RUSS_PFXV_I_metadata_line_9_____ICT_GROUP_20211101 >									
125 	//        < F7mpOk3USfX1gbRF2w6cORC6jx8M4bt368cb24PYM9cgNv4hqHEbfq1FfYbQsNcP >									
126 	//        <  u =="0.000000000000000001" : ] 000000125687571.849210000000000000 ; 000000141040946.104540000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000000BFC8B5D7361F >									
128 	//     < RUSS_PFXV_I_metadata_line_10_____ICT_GROUP_ORG_20211101 >									
129 	//        < r5ET6owwz3BXZNG721jBzNZ4Pru9a12bQok0kicBc6y7cOmvn109WIc8bkqTrj79 >									
130 	//        <  u =="0.000000000000000001" : ] 000000141040946.104540000000000000 ; 000000155107974.050185000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000000D7361FECAD0D >									
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
174 	//     < RUSS_PFXV_I_metadata_line_11_____ENISEYSKAYA_1_ORG_20211101 >									
175 	//        < 7O46En2rwNVhujeL52FmLyx2dB6lCl1oLs2vVtvZvtj4xq0SH6rysrOoWZ685669 >									
176 	//        <  u =="0.000000000000000001" : ] 000000155107974.050185000000000000 ; 000000169138329.894194000000000000 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000000000ECAD0D10215A9 >									
178 	//     < RUSS_PFXV_I_metadata_line_12_____ENISEYSKAYA_1_DAO_20211101 >									
179 	//        < 96j0h8a3n32Ea8r6Pyfvi1iZd3J2fyBWo09tCb6AwkCWm1dT5P5ORu0g2Ufbboer >									
180 	//        <  u =="0.000000000000000001" : ] 000000169138329.894194000000000000 ; 000000185815284.697002000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000010215A911B8818 >									
182 	//     < RUSS_PFXV_I_metadata_line_13_____ENISEYSKAYA_1_DAOPI_20211101 >									
183 	//        < DV9d0Z6c0Ci8F69mdtc6ZdyT62tG73RQNcm3NPfMsld573qWQs62XofauxmGtX63 >									
184 	//        <  u =="0.000000000000000001" : ] 000000185815284.697002000000000000 ; 000000202231618.806737000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000011B881813494BA >									
186 	//     < RUSS_PFXV_I_metadata_line_14_____ENISEYSKAYA_1_DAC_20211101 >									
187 	//        < n9o56DzCJaerVd6OX2461ILf3PQQvB1j83OtwvZkPxVG60zZN6qU5x5mo8H1C33m >									
188 	//        <  u =="0.000000000000000001" : ] 000000202231618.806737000000000000 ; 000000218445562.627732000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000013494BA14D524C >									
190 	//     < RUSS_PFXV_I_metadata_line_15_____ENISEYSKAYA_1_BIMI_20211101 >									
191 	//        < d0NSmg1QUVS05Svh04ID6h2AIs75Vxbt9sQ3G04zYgiJpp5y4dZG9uGUmbv8T4xN >									
192 	//        <  u =="0.000000000000000001" : ] 000000218445562.627732000000000000 ; 000000233882962.911607000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000014D524C164E088 >									
194 	//     < RUSS_PFXV_I_metadata_line_16_____ENISEYSKAYA_2_ORG_20211101 >									
195 	//        < 1Mwm4Gv7oW31F6kQi4EZs7ke2e7Vjey1OjrXR1OInAKdT85GntfJ03n70Je7nNbx >									
196 	//        <  u =="0.000000000000000001" : ] 000000233882962.911607000000000000 ; 000000250047864.246865000000000000 ] >									
197 	//        < 0x00000000000000000000000000000000000000000000000000164E08817D8AF2 >									
198 	//     < RUSS_PFXV_I_metadata_line_17_____ENISEYSKAYA_2_DAO_20211101 >									
199 	//        < 5sl1mJXfSsXfbvr88zGbV3p3W5EsP7JM4nH489V2dF3e44bNW39g2Q9G63kLNef9 >									
200 	//        <  u =="0.000000000000000001" : ] 000000250047864.246865000000000000 ; 000000263612736.193668000000000000 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000000017D8AF21923DBA >									
202 	//     < RUSS_PFXV_I_metadata_line_18_____ENISEYSKAYA_2_DAOPI_20211101 >									
203 	//        < aK07fRL7AT89Jz5E950oRV4zcH43X98bVha8DoMovAJ07r53tp6rxgGrAPSHGTp6 >									
204 	//        <  u =="0.000000000000000001" : ] 000000263612736.193668000000000000 ; 000000277962074.213674000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000001923DBA1A822EF >									
206 	//     < RUSS_PFXV_I_metadata_line_19_____ENISEYSKAYA_2_DAC_20211101 >									
207 	//        < EoyLhTc5fz4ohaIizR5t81FnaUi8DF8XNxT0BNX8IF4u0Z6oQT1vB0Iw8zABrD2h >									
208 	//        <  u =="0.000000000000000001" : ] 000000277962074.213674000000000000 ; 000000293347164.438231000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000001A822EF1BF9CBC >									
210 	//     < RUSS_PFXV_I_metadata_line_20_____ENISEYSKAYA_2_BIMI_20211101 >									
211 	//        < qhrBDQWXOgD11C8bpKY3tu79o25F74hbq9yZXWEZ4gxu38m1f5ItfdZQ2jwX8b9h >									
212 	//        <  u =="0.000000000000000001" : ] 000000293347164.438231000000000000 ; 000000306563375.135059000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000001BF9CBC1D3C752 >									
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
256 	//     < RUSS_PFXV_I_metadata_line_21_____YENISEISKAYA_GTK_1_ORG_20211101 >									
257 	//        < k927ZM1997qBcssb1N25t2hxJJ3ya4Or5TK34S3Tfn2vwUMm8ObB4vgYD2HRh8VY >									
258 	//        <  u =="0.000000000000000001" : ] 000000306563375.135059000000000000 ; 000000322964715.320743000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000001D3C7521ECCE18 >									
260 	//     < RUSS_PFXV_I_metadata_line_22_____YENISEISKAYA_GTK_1_DAO_20211101 >									
261 	//        < f7mfxYCZ4c17vmOE2r9mF8VqMrRcI39WW16004wLBm4aEN0MHk5z33f9glZ1yRJG >									
262 	//        <  u =="0.000000000000000001" : ] 000000322964715.320743000000000000 ; 000000340113445.947355000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000001ECCE18206F8D1 >									
264 	//     < RUSS_PFXV_I_metadata_line_23_____YENISEISKAYA_GTK_1_DAOPI_20211101 >									
265 	//        < 375LD0QRZmyTOc8hAGhTJd9m3rqyvEa9B99NfmCfStM9Y84V6aY1C67R0p6T81GI >									
266 	//        <  u =="0.000000000000000001" : ] 000000340113445.947355000000000000 ; 000000355663716.767617000000000000 ] >									
267 	//        < 0x00000000000000000000000000000000000000000000000000206F8D121EB324 >									
268 	//     < RUSS_PFXV_I_metadata_line_24_____YENISEISKAYA_GTK_1_DAC_20211101 >									
269 	//        < D8y9FlQn0x25kYqXYi24n38Tt00iEw7FjNNsn48Yzi7bW16HG8ZMK08LuGPHw2Jh >									
270 	//        <  u =="0.000000000000000001" : ] 000000355663716.767617000000000000 ; 000000372372304.601126000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000021EB32423831EE >									
272 	//     < RUSS_PFXV_I_metadata_line_25_____YENISEISKAYA_GTK_1_BIMI_20211101 >									
273 	//        < ekD69F8JXDn6n4uX84ep45S03py5dCj0rk8iMp5DThIXJ9hfYj6TBVrjTKNNCev6 >									
274 	//        <  u =="0.000000000000000001" : ] 000000372372304.601126000000000000 ; 000000389219464.012577000000000000 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000000000023831EE251E6DA >									
276 	//     < RUSS_PFXV_I_metadata_line_26_____YENISEISKAYA_GTK_2_ORG_20211101 >									
277 	//        < m4O6v17P6tot1zO51g3OV3L257LX58LLmFxwWYtF6VKDw25h6vDCK365IHJcV726 >									
278 	//        <  u =="0.000000000000000001" : ] 000000389219464.012577000000000000 ; 000000406063395.063456000000000000 ] >									
279 	//        < 0x00000000000000000000000000000000000000000000000000251E6DA26B9A84 >									
280 	//     < RUSS_PFXV_I_metadata_line_27_____YENISEISKAYA_GTK_2_DAO_20211101 >									
281 	//        < 6vV6c4p7TaF1PxL1A7d54IFhzEartWx33PPC0GpoZ21GiWwRwQ283Hl3AvbPB66Q >									
282 	//        <  u =="0.000000000000000001" : ] 000000406063395.063456000000000000 ; 000000423340524.582415000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000026B9A84285F764 >									
284 	//     < RUSS_PFXV_I_metadata_line_28_____YENISEISKAYA_GTK_2_DAOPI_20211101 >									
285 	//        < RVCye9fU8NDoe6VO4fRN7hS92k4gPg7IdB3489ys8NFUF2GA8hV3G4NQ5a3xsxN5 >									
286 	//        <  u =="0.000000000000000001" : ] 000000423340524.582415000000000000 ; 000000439205940.832589000000000000 ] >									
287 	//        < 0x00000000000000000000000000000000000000000000000000285F76429E2CD2 >									
288 	//     < RUSS_PFXV_I_metadata_line_29_____YENISEISKAYA_GTK_2_DAC_20211101 >									
289 	//        < Y58BH9h9Zjl82U7X55z0TdMB1FUdWFdA7He6RQ4Vt8NlDY7R0C3h74mVd5SUBsz8 >									
290 	//        <  u =="0.000000000000000001" : ] 000000439205940.832589000000000000 ; 000000453420221.106103000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000029E2CD22B3DD46 >									
292 	//     < RUSS_PFXV_I_metadata_line_30_____YENISEISKAYA_GTK_2_BIMI_20211101 >									
293 	//        < p8Ewo81APt9O4uwZ8MDmGDbnL90x0o4g86H6BCmC0T66q03yxMMT2L3jYK4n3aL9 >									
294 	//        <  u =="0.000000000000000001" : ] 000000453420221.106103000000000000 ; 000000467227938.857222000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000002B3DD462C8EEEA >									
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
338 	//     < RUSS_PFXV_I_metadata_line_31_____ZAO_ENISEY_MINING_GEOLOGIC_CO_1_ORG_20211101 >									
339 	//        < Fg2HMod244x67d2Y0Gun46Ymyx9E976B80xrS027nRPFl5R4FRZQo0i5H53Ko63y >									
340 	//        <  u =="0.000000000000000001" : ] 000000467227938.857222000000000000 ; 000000481237441.048791000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000002C8EEEA2DE4F60 >									
342 	//     < RUSS_PFXV_I_metadata_line_32_____ZAO_ENISEY_MINING_GEOLOGIC_CO_1_DAO_20211101 >									
343 	//        < VsJ4OqedBKmcm23T7XhgLwNMExS0sxFN60l6L0aX65Rpwt3gzM71bGD9W5t9Uphs >									
344 	//        <  u =="0.000000000000000001" : ] 000000481237441.048791000000000000 ; 000000494274973.921026000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000002DE4F602F23429 >									
346 	//     < RUSS_PFXV_I_metadata_line_33_____ZAO_ENISEY_MINING_GEOLOGIC_CO_1_DAOPI_20211101 >									
347 	//        < t812PD6Q03OGYSfh5y05b9Gdnvq5EonT7E19Edzo7z4BK47MA5md8317poA5mJ02 >									
348 	//        <  u =="0.000000000000000001" : ] 000000494274973.921026000000000000 ; 000000508349409.730517000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000002F23429307ADFD >									
350 	//     < RUSS_PFXV_I_metadata_line_34_____ZAO_ENISEY_MINING_GEOLOGIC_CO_1_DAC_20211101 >									
351 	//        < C8rnKXp7HMkb3vqWnpoEuH3u8qBSq4lm6tTPKt90u4RiKrxYZ66KwNwU45qAdoE7 >									
352 	//        <  u =="0.000000000000000001" : ] 000000508349409.730517000000000000 ; 000000522736936.438777000000000000 ] >									
353 	//        < 0x00000000000000000000000000000000000000000000000000307ADFD31DA21E >									
354 	//     < RUSS_PFXV_I_metadata_line_35_____ZAO_ENISEY_MINING_GEOLOGIC_CO_1_BIMI_20211101 >									
355 	//        < 03R9Y6E24wQTD571P64PT9j16eM5Co74bCFyKKXta557MH5PzOjsPOZH14eR2bQv >									
356 	//        <  u =="0.000000000000000001" : ] 000000522736936.438777000000000000 ; 000000539027609.148154000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000031DA21E3367DA9 >									
358 	//     < RUSS_PFXV_I_metadata_line_36_____ZAO_ENISEY_MINING_GEOLOGIC_CO_2_ORG_20211101 >									
359 	//        < MWVKGG4cy3d9s78T64nUlrE2wIlOA1R0MMttk4p0H3y21APdkLBL8NKa97bbJcev >									
360 	//        <  u =="0.000000000000000001" : ] 000000539027609.148154000000000000 ; 000000552478932.249207000000000000 ] >									
361 	//        < 0x000000000000000000000000000000000000000000000000003367DA934B0415 >									
362 	//     < RUSS_PFXV_I_metadata_line_37_____ZAO_ENISEY_MINING_GEOLOGIC_CO_2_DAO_20211101 >									
363 	//        < WD7a1TcHetuBuvdg49364u9EA8DsgybbLb47oWoQKcrq3fMcp2DMJxW01ZLcS7A6 >									
364 	//        <  u =="0.000000000000000001" : ] 000000552478932.249207000000000000 ; 000000566235429.267452000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000034B041536001B7 >									
366 	//     < RUSS_PFXV_I_metadata_line_38_____ZAO_ENISEY_MINING_GEOLOGIC_CO_2_DAOPI_20211101 >									
367 	//        < Nj5tYKw1qfzm99ElEFmq9wY10E2aO9W9z45vO30SQyk7hs2uAo4Qr3fIJ9oD3d91 >									
368 	//        <  u =="0.000000000000000001" : ] 000000566235429.267452000000000000 ; 000000582694466.688049000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000036001B73791F07 >									
370 	//     < RUSS_PFXV_I_metadata_line_39_____ZAO_ENISEY_MINING_GEOLOGIC_CO_2_DAC_20211101 >									
371 	//        < 1AZ04l80TRMx048N2Akax9h2ej32QmPLADsbb49UdpyBSDvR4ghOTXK0yGI03HiG >									
372 	//        <  u =="0.000000000000000001" : ] 000000582694466.688049000000000000 ; 000000599761372.605876000000000000 ] >									
373 	//        < 0x000000000000000000000000000000000000000000000000003791F0739329C9 >									
374 	//     < RUSS_PFXV_I_metadata_line_40_____ZAO_ENISEY_MINING_GEOLOGIC_CO_2_BIMI_20211101 >									
375 	//        < M8Z19r1s5u6X277wcA7z6dN75p2ShORCuz40VC5YseXaE93wn6euMsgeeumPEEAm >									
376 	//        <  u =="0.000000000000000001" : ] 000000599761372.605876000000000000 ; 000000613997134.018603000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000039329C93A8E2A1 >									
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