1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	SHERE_PFII_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	SHERE_PFII_I_883		"	;
8 		string	public		symbol =	"	SHERE_PFII_I_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		784153853994009000000000000					;	
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
92 	//     < SHERE_PFII_I_metadata_line_1_____JSC 121 ARP_20220505 >									
93 	//        < 6gQ9FeZBw3zsj30x7np1pCMHtwfYFH5G3Tb4LSJI3s986X08B32EcE85Soda3WU0 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000022541545.509583000000000000 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000000022654B >									
96 	//     < SHERE_PFII_I_metadata_line_2_____JSC 123 ARP_20220505 >									
97 	//        < 0zoPA7057zFe3vAC65tSG77092vlj8418iu20DKR6G8c0uDCJn788j8kOrD8m5LW >									
98 	//        <  u =="0.000000000000000001" : ] 000000022541545.509583000000000000 ; 000000044993460.402634400000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000022654B44A792 >									
100 	//     < SHERE_PFII_I_metadata_line_3_____JSC 360 ARP_20220505 >									
101 	//        < 9UM0Rs6087nPf69pw2cx0Jl3AO9JW8d392VP1Umy423eOn4S79io1wz0OW8A5G7q >									
102 	//        <  u =="0.000000000000000001" : ] 000000044993460.402634400000000000 ; 000000067205381.422201600000000000 ] >									
103 	//        < 0x000000000000000000000000000000000000000000000000000044A792668C1A >									
104 	//     < SHERE_PFII_I_metadata_line_4_____JSC “514 ARZ”_20220505 >									
105 	//        < iCRAOILMHt0v5f5a2tgtjQwuY5a4v06iwF7VY9073o92ST687BtK5ps0IIPo3P8X >									
106 	//        <  u =="0.000000000000000001" : ] 000000067205381.422201600000000000 ; 000000089661964.188445300000000000 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000000000668C1A88D034 >									
108 	//     < SHERE_PFII_I_metadata_line_5_____JSC “170 RZ SOP”_20220505 >									
109 	//        < 4mN6f88LHM2g7lQnCsd74qZld54W8B74UwSY7y1i96d6eQD6X8647ue6mUh777fw >									
110 	//        <  u =="0.000000000000000001" : ] 000000089661964.188445300000000000 ; 000000108109907.235307000000000000 ] >									
111 	//        < 0x000000000000000000000000000000000000000000000000000088D034A4F66F >									
112 	//     < SHERE_PFII_I_metadata_line_6_____JSC “31 ZATO”_20220505 >									
113 	//        < 5H9Ldj13ppUFReuQGyO0l05T1U5l9T8v99Emyi9kW17q7atSqdTB82Ju51tyVd19 >									
114 	//        <  u =="0.000000000000000001" : ] 000000108109907.235307000000000000 ; 000000121819739.348556000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000A4F66FB9E1D6 >									
116 	//     < SHERE_PFII_I_metadata_line_7_____JSC “32 RZ SOP”_20220505 >									
117 	//        < G93A67QE7Wl6fzmSMU22mYatPh3v2vuMV434Ila53CX4GAYigx4l6s20k3y5z0U2 >									
118 	//        <  u =="0.000000000000000001" : ] 000000121819739.348556000000000000 ; 000000141567687.897182000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000B9E1D6D803E1 >									
120 	//     < SHERE_PFII_I_metadata_line_8_____JSC “680 ARZ”_20220505 >									
121 	//        < Mhn978KS9gKIoSHdVh7DEPX0GKaIsIGWEMYdr4a10Y2N22r5gr5UCqzFR7g7T9zU >									
122 	//        <  u =="0.000000000000000001" : ] 000000141567687.897182000000000000 ; 000000165300417.662883000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000D803E1FC3A7A >									
124 	//     < SHERE_PFII_I_metadata_line_9_____JSC “720 RZ SOP”_20220505 >									
125 	//        < 6SBF7gw4p59WO41RL58Zf1dRyj9Pm37EKePz86E690ZZ78Kp7OooH49FJ8653fJC >									
126 	//        <  u =="0.000000000000000001" : ] 000000165300417.662883000000000000 ; 000000188324904.412943000000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000000FC3A7A11F5C6A >									
128 	//     < SHERE_PFII_I_metadata_line_10_____JSC “VZ RTO”_20220505 >									
129 	//        < h89t4UL4Yb2s680W89c74p6Z4I7Q3YF9sIu8dffmu4T8059Mw25u4tHLtgDYt8nP >									
130 	//        <  u =="0.000000000000000001" : ] 000000188324904.412943000000000000 ; 000000203313064.953711000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000011F5C6A1363B2A >									
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
174 	//     < SHERE_PFII_I_metadata_line_11_____JSC “20 ARZ”_20220505 >									
175 	//        < MtL2L2m9LuoR2h35O9H8WMqIX2tt7563YbcatWA8yoa7GkVk02LL6u02a2y7U7U9 >									
176 	//        <  u =="0.000000000000000001" : ] 000000203313064.953711000000000000 ; 000000225185976.874503000000000000 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000000001363B2A1579B46 >									
178 	//     < SHERE_PFII_I_metadata_line_12_____JSC “275 ARZ”_20220505 >									
179 	//        < 6fmKXkTR5h0Y17utxSn092u4uDtQbbvz8DVC0g1i6O94qix5571CzPIwqNdDaiOX >									
180 	//        <  u =="0.000000000000000001" : ] 000000225185976.874503000000000000 ; 000000245276380.789978000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000001579B461764316 >									
182 	//     < SHERE_PFII_I_metadata_line_13_____JSC 308 ARP_20220505 >									
183 	//        < iQr0W273Zc75zQ0yxzkOUFD66djMn28So4wXbXlKuisurfGimvZ9FKK6mXkH2T34 >									
184 	//        <  u =="0.000000000000000001" : ] 000000245276380.789978000000000000 ; 000000264488286.928765000000000000 ] >									
185 	//        < 0x00000000000000000000000000000000000000000000000000176431619393BD >									
186 	//     < SHERE_PFII_I_metadata_line_14_____JSC “322 ARZ”_20220505 >									
187 	//        < Qd4plFGkO0CIsLB961ExB3v2Wgt14g40R9j1W7s17IFu44c6CA51hRY732i56j1B >									
188 	//        <  u =="0.000000000000000001" : ] 000000264488286.928765000000000000 ; 000000278253297.755577000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000019393BD1A894B2 >									
190 	//     < SHERE_PFII_I_metadata_line_15_____JSC “325 ARZ”_20220505 >									
191 	//        < uf5H82fdrHGa247OD2Sns3NO95OfHI64Fui5nD78z57galETSWks4UAB3y22gfzX >									
192 	//        <  u =="0.000000000000000001" : ] 000000278253297.755577000000000000 ; 000000301283813.187650000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000001A894B21CBB8FD >									
194 	//     < SHERE_PFII_I_metadata_line_16_____JSC 121 ARP_INFRA_20220505 >									
195 	//        < 08rI7yFl82f02ABywP69ii2Ri2NgbpZ31NKFp6z9wl75AUesHZxz5ffn50k2h8Nv >									
196 	//        <  u =="0.000000000000000001" : ] 000000301283813.187650000000000000 ; 000000323400521.606373000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000001CBB8FD1ED7854 >									
198 	//     < SHERE_PFII_I_metadata_line_17_____JSC 123 ARP_INFRA_20220505 >									
199 	//        < 7Q4H4a936xvy6212XVXC31Q8vbic5X5Lq29VSOc9zjWCfO0I9ZpKoY70YVli30rH >									
200 	//        <  u =="0.000000000000000001" : ] 000000323400521.606373000000000000 ; 000000348908052.643655000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000001ED78542146435 >									
202 	//     < SHERE_PFII_I_metadata_line_18_____JSC 360 ARP_INFRA_20220505 >									
203 	//        < 8uu1s6Kp6J2jWpAw03f8UXYNrbe27oRw8yE4fjt98VW5broxnmBvDXDtNT4m04Oq >									
204 	//        <  u =="0.000000000000000001" : ] 000000348908052.643655000000000000 ; 000000367613237.455516000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000002146435230EEEC >									
206 	//     < SHERE_PFII_I_metadata_line_19_____JSC “514 ARZ”_INFRA_20220505 >									
207 	//        < S80XzvF9Cnl0D9p0DlkGl56e3t2El5117Q31suu90Axjh1CPwEI50xAruxT89784 >									
208 	//        <  u =="0.000000000000000001" : ] 000000367613237.455516000000000000 ; 000000381385128.255118000000000000 ] >									
209 	//        < 0x00000000000000000000000000000000000000000000000000230EEEC245F291 >									
210 	//     < SHERE_PFII_I_metadata_line_20_____JSC “170 RZ SOP”_INFRA_20220505 >									
211 	//        < b98m7jM59b6eP7t2J666C5n2Nx0XM24dBrv1N53Kf8bpTy1524420AJ9KiLkfpmJ >									
212 	//        <  u =="0.000000000000000001" : ] 000000381385128.255118000000000000 ; 000000402137077.507218000000000000 ] >									
213 	//        < 0x00000000000000000000000000000000000000000000000000245F2912659CCC >									
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
256 	//     < SHERE_PFII_I_metadata_line_21_____JSC “31 ZATO”_INFRA_20220505 >									
257 	//        < 630B46kv00120K5R52C3K798n3r7434YkZvI1T96bF3l4lI4S6hZCE5a9mZiq6Ph >									
258 	//        <  u =="0.000000000000000001" : ] 000000402137077.507218000000000000 ; 000000416993605.507556000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000002659CCC27C4821 >									
260 	//     < SHERE_PFII_I_metadata_line_22_____JSC “32 RZ SOP”_INFRA_20220505 >									
261 	//        < 4ArxuLc5YGsm61bPKBGNPg5Eqx0o8xC9633JZWtf5ZzhfPW48B8R971OV709WuWH >									
262 	//        <  u =="0.000000000000000001" : ] 000000416993605.507556000000000000 ; 000000434735313.303663000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000027C48212975A7B >									
264 	//     < SHERE_PFII_I_metadata_line_23_____JSC “680 ARZ”_INFRA_20220505 >									
265 	//        < A7OUakIl7pqd180haPKnwY4I8e094lZN3GCR4qu3Mqqm55r7Q0P2IHotmGKB9awn >									
266 	//        <  u =="0.000000000000000001" : ] 000000434735313.303663000000000000 ; 000000451049148.991877000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000002975A7B2B03F13 >									
268 	//     < SHERE_PFII_I_metadata_line_24_____JSC “720 RZ SOP”_INFRA_20220505 >									
269 	//        < sEfvM5rRyh08EtC4pP5Gp1NwHOENET377aJMRIpq2lm7j906JMR9NcWi5v0Ul3V7 >									
270 	//        <  u =="0.000000000000000001" : ] 000000451049148.991877000000000000 ; 000000475453249.498864000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000002B03F132D57BED >									
272 	//     < SHERE_PFII_I_metadata_line_25_____JSC “VZ RTO”_INFRA_20220505 >									
273 	//        < 5bKb6pxQz73Ed7jJRUI1G8X01i33G1KGpdRQ3k2194P9xE5MKghQO9W48JHCRN73 >									
274 	//        <  u =="0.000000000000000001" : ] 000000475453249.498864000000000000 ; 000000499904643.876729000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002D57BED2FACB40 >									
276 	//     < SHERE_PFII_I_metadata_line_26_____JSC “20 ARZ”_INFRA_20220505 >									
277 	//        < L1d87xt9RWYvHb90N9i8b7GJ336i4fH43o63XaLC4I9DWgAGYVCNf77l25m5rl2a >									
278 	//        <  u =="0.000000000000000001" : ] 000000499904643.876729000000000000 ; 000000517421160.452644000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000002FACB4031585A4 >									
280 	//     < SHERE_PFII_I_metadata_line_27_____JSC “275 ARZ”_INFRA_20220505 >									
281 	//        < gkXqek4aDvUyy4SYQii38NWy7Q1lHTr2B139RQ93GKB1l7dp7E1Y5SwcJ63056E7 >									
282 	//        <  u =="0.000000000000000001" : ] 000000517421160.452644000000000000 ; 000000535025786.037945000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000031585A43306273 >									
284 	//     < SHERE_PFII_I_metadata_line_28_____JSC 308 ARP_INFRA_20220505 >									
285 	//        < J7dKIF0FH04MdwzRt0l08lYJEn2de7KXW64Vv94LY1W14741092HX8wQ9430TO0m >									
286 	//        <  u =="0.000000000000000001" : ] 000000535025786.037945000000000000 ; 000000548889975.626223000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000033062733458A26 >									
288 	//     < SHERE_PFII_I_metadata_line_29_____JSC “322 ARZ”_INFRA_20220505 >									
289 	//        < Z04iP5Vyg5LV0oUd345Q9tgPcT65GzfQUzYpM4L9Ao46Mo8386i0wsve77omgmd9 >									
290 	//        <  u =="0.000000000000000001" : ] 000000548889975.626223000000000000 ; 000000574918984.671003000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000003458A2636D41BA >									
292 	//     < SHERE_PFII_I_metadata_line_30_____JSC “325 ARZ”_INFRA_20220505 >									
293 	//        < vWL8cA9ZG10E83Q6405T9e2839wMX4C22SPSAp9kzP1qOze7Z5tmVYeaadlyZTuE >									
294 	//        <  u =="0.000000000000000001" : ] 000000574918984.671003000000000000 ; 000000589438119.996435000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000036D41BA3836944 >									
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
338 	//     < SHERE_PFII_I_metadata_line_31_____JSC 121 ARP_ORG_20220505 >									
339 	//        < RcX7cn41gx8D3d31vLKr5MU318DRQ4355Eh07z27Wh8w94eC583cs9DLX3K2yEmp >									
340 	//        <  u =="0.000000000000000001" : ] 000000589438119.996435000000000000 ; 000000605592880.407330000000000000 ] >									
341 	//        < 0x00000000000000000000000000000000000000000000000000383694439C0FB8 >									
342 	//     < SHERE_PFII_I_metadata_line_32_____JSC 123 ARP_ORG_20220505 >									
343 	//        < LEI03I806o44QCeO4iof33N7eb2WsMrYaxwkYqfx2Zd8Cu8l9QeGD9kjBSLJj5so >									
344 	//        <  u =="0.000000000000000001" : ] 000000605592880.407330000000000000 ; 000000626973396.411725000000000000 ] >									
345 	//        < 0x0000000000000000000000000000000000000000000000000039C0FB83BCAF7C >									
346 	//     < SHERE_PFII_I_metadata_line_33_____JSC 360 ARP_ORG_20220505 >									
347 	//        < Nl8viJ78JAFZ1x4Rn0sCA62s91dXfACH61Xd53pqpYs6mQa7SMXb59T1dY00axBW >									
348 	//        <  u =="0.000000000000000001" : ] 000000626973396.411725000000000000 ; 000000649540492.287903000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000003BCAF7C3DF1EC1 >									
350 	//     < SHERE_PFII_I_metadata_line_34_____JSC “514 ARZ”_ORG_20220505 >									
351 	//        < BkwKdBlVNoAvrD65Mda5xj0O7ICAPl95T46iiiC94Z5n3dY449byBLM2QsN47N7G >									
352 	//        <  u =="0.000000000000000001" : ] 000000649540492.287903000000000000 ; 000000674069707.628240000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000003DF1EC14048C7B >									
354 	//     < SHERE_PFII_I_metadata_line_35_____JSC “170 RZ SOP”_ORG_20220505 >									
355 	//        < 45tu8M2rb80Eost0uvOLh1XHuK1k3pEh071hA2j3e0r20yKt6unCWe5j28MdxB4h >									
356 	//        <  u =="0.000000000000000001" : ] 000000674069707.628240000000000000 ; 000000690548503.592895000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000004048C7B41DB182 >									
358 	//     < SHERE_PFII_I_metadata_line_36_____JSC “31 ZATO”_ORG_20220505 >									
359 	//        < KsIza5CtFeW5BQ6wr0C6E8A9m0R8EMfshzJz6MkVV5I501G527PwoVyNjUdaN5uh >									
360 	//        <  u =="0.000000000000000001" : ] 000000690548503.592895000000000000 ; 000000713437624.555419000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000041DB1824409E92 >									
362 	//     < SHERE_PFII_I_metadata_line_37_____JSC “32 RZ SOP”_ORG_20220505 >									
363 	//        < XrN02WGM90QLRu7vuST1A4utvoxrL034EcnG9R0Fx8t07e3Q60OnYF180EQzhjZW >									
364 	//        <  u =="0.000000000000000001" : ] 000000713437624.555419000000000000 ; 000000726499666.607466000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000004409E924548CEF >									
366 	//     < SHERE_PFII_I_metadata_line_38_____JSC “680 ARZ”_ORG_20220505 >									
367 	//        < yoF1Xu9qX16SRyQ9y08l5OMQzTeb3ETELTMj0kmFS2773f5mpPZV4131SZRA2qTv >									
368 	//        <  u =="0.000000000000000001" : ] 000000726499666.607466000000000000 ; 000000741002668.941287000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000004548CEF46AAE2B >									
370 	//     < SHERE_PFII_I_metadata_line_39_____JSC “720 RZ SOP”_ORG_20220505 >									
371 	//        < 73C524eVv8QSNAdRf0J5j9co0UwZdn0Nr8K090e5aC8CHthYjgeZ9mZmUD51r4M8 >									
372 	//        <  u =="0.000000000000000001" : ] 000000741002668.941287000000000000 ; 000000762238923.381034000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000046AAE2B48B1594 >									
374 	//     < SHERE_PFII_I_metadata_line_40_____JSC “VZ RTO”_ORG_20220505 >									
375 	//        < 6l45w3IzBk9j1p55hDWVr228GUNNVzP4Mj1PSY1Neqy9g0S36YvwfGt9auvndnBI >									
376 	//        <  u =="0.000000000000000001" : ] 000000762238923.381034000000000000 ; 000000784153853.994009000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000048B15944AC8619 >									
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