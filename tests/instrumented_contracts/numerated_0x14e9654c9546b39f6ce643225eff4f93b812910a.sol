1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXVI_II_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXVI_II_883		"	;
8 		string	public		symbol =	"	RUSS_PFXVI_II_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		765536332851386000000000000					;	
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
92 	//     < RUSS_PFXVI_II_metadata_line_1_____KYZYL_GOLD_20231101 >									
93 	//        < Ppj09084TbKtMz1pQPZ6fpq3Gag65DSxhtjVxZtuM45Qa159WtfR09HDFB0PxZNJ >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000020010580.733756100000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000001E88A2 >									
96 	//     < RUSS_PFXVI_II_metadata_line_2_____SEREBRO_MAGADANA_20231101 >									
97 	//        < tV7a32sJ8ZHd76h5GRLr4k6SD2n7Kst41da7Hm16p7Ued2R2YAe68RYVn12eBts4 >									
98 	//        <  u =="0.000000000000000001" : ] 000000020010580.733756100000000000 ; 000000040062716.133866900000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000001E88A23D2180 >									
100 	//     < RUSS_PFXVI_II_metadata_line_3_____OMOLON_GOLD_MINING_CO_20231101 >									
101 	//        < 5v1B1oEuRgCTcful2g05cZx2MmyZPjkDW7kLiNuI39XJsRMBizHJbvauYc4qKbaQ >									
102 	//        <  u =="0.000000000000000001" : ] 000000040062716.133866900000000000 ; 000000060311310.355414500000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000003D21805C071B >									
104 	//     < RUSS_PFXVI_II_metadata_line_4_____AMUR_CHEMICAL_METALL_PLANT_20231101 >									
105 	//        < 9S6o3a1BaxXqpLG06MQffQ2oNmTxJluR9qsvlvcW4b7C931C3k90FDueSJm9j58K >									
106 	//        <  u =="0.000000000000000001" : ] 000000060311310.355414500000000000 ; 000000078993603.156666800000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000005C071B7888E0 >									
108 	//     < RUSS_PFXVI_II_metadata_line_5_____AMUR_CHEMICAL_METALL_PLANT_ORG_20231101 >									
109 	//        < yHH4d90D2b15Vdc7FGK9IBtmPRn97NqQm35HBGo7l673jhs0t2nEq5xrVhzQe8F5 >									
110 	//        <  u =="0.000000000000000001" : ] 000000078993603.156666800000000000 ; 000000096059486.321301800000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000007888E092933D >									
112 	//     < RUSS_PFXVI_II_metadata_line_6_____KAPAN_MINING_PROCESS_CO_20231101 >									
113 	//        < 2SXg2727xg43ci2qzCV6y378KodUluWyd12mG8Ns3M6eqn82xge8WbTk768xWW8M >									
114 	//        <  u =="0.000000000000000001" : ] 000000096059486.321301800000000000 ; 000000116976857.812344000000000000 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000000000092933DB27E16 >									
116 	//     < RUSS_PFXVI_II_metadata_line_7_____VARVARINSKOYE_20231101 >									
117 	//        < I39thN0gaTVM3zvLsvp8e319p1Zt6JXdW8Oc3yU9Gsbf3LW4lH1t1HsZ68Vo4fih >									
118 	//        <  u =="0.000000000000000001" : ] 000000116976857.812344000000000000 ; 000000132442769.204929000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000B27E16CA1775 >									
120 	//     < RUSS_PFXVI_II_metadata_line_8_____KAPAN_MPC_20231101 >									
121 	//        < XFF5C0RfN1ISw80J13nzhCN69yvbp2atMt1tYbUcJs1h9YlioYo068535d55uoku >									
122 	//        <  u =="0.000000000000000001" : ] 000000132442769.204929000000000000 ; 000000155981736.243818000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000CA1775EE025E >									
124 	//     < RUSS_PFXVI_II_metadata_line_9_____ORION_MINERALS_LLP_20231101 >									
125 	//        < 4xZWDXeESk06g418kEMkt78bUEfds8AqvtnPgi19M976FchFp8URcTToWDNHQ3eH >									
126 	//        <  u =="0.000000000000000001" : ] 000000155981736.243818000000000000 ; 000000177852620.631621000000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000000EE025E10F61AE >									
128 	//     < RUSS_PFXVI_II_metadata_line_10_____IMITZOLOTO_LIMITED_20231101 >									
129 	//        < q0T5sn12A5hDw45p5e1Hg7Cb9WWGSQuvrPoKiD7Vvfv8li9f2upd69gK10XTRZK4 >									
130 	//        <  u =="0.000000000000000001" : ] 000000177852620.631621000000000000 ; 000000198253755.843012000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000010F61AE12E82E0 >									
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
174 	//     < RUSS_PFXVI_II_metadata_line_11_____ZAO_ZOLOTO_SEVERNOGO_URALA_20231101 >									
175 	//        < uqNkDp99z21ST9We219wCcUr0dyz87rAtyxE3YzDKV3p5beQfB8s4Duy1303rVbX >									
176 	//        <  u =="0.000000000000000001" : ] 000000198253755.843012000000000000 ; 000000218616908.366991000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000012E82E014D953B >									
178 	//     < RUSS_PFXVI_II_metadata_line_12_____OKHOTSKAYA_GGC_20231101 >									
179 	//        < Th597M14NUaM9395F04Y3Zk0xioT2rxZD1MT5clIq9IpvKW1oG9YDyFEs09UO7v3 >									
180 	//        <  u =="0.000000000000000001" : ] 000000218616908.366991000000000000 ; 000000239075181.925248000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000014D953B16CCCBE >									
182 	//     < RUSS_PFXVI_II_metadata_line_13_____INTER_GOLD_CAPITAL_20231101 >									
183 	//        < P08j2E6YJdZv8wKvrSxWHtdh9o39nw868KueO0S83C1W89972h3L6P4gcaaHBAw0 >									
184 	//        <  u =="0.000000000000000001" : ] 000000239075181.925248000000000000 ; 000000255488687.579891000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000016CCCBE185D845 >									
186 	//     < RUSS_PFXVI_II_metadata_line_14_____POLYMETAL_AURUM_20231101 >									
187 	//        < 0d6R2551qg8FFo1yKgug0yWGxy6N8ifsH2652650J66w8Mk9m0yBjycj80N8UCU3 >									
188 	//        <  u =="0.000000000000000001" : ] 000000255488687.579891000000000000 ; 000000276644489.713922000000000000 ] >									
189 	//        < 0x00000000000000000000000000000000000000000000000000185D8451A62041 >									
190 	//     < RUSS_PFXVI_II_metadata_line_15_____KIRANKAN_OOO_20231101 >									
191 	//        < KNLU18x18c6YQ9eD8Akb52z20jHS3TXzZelyD8f790ssoQ1X6uhfbntdQXXH9vim >									
192 	//        <  u =="0.000000000000000001" : ] 000000276644489.713922000000000000 ; 000000293589299.224178000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000001A620411BFFB52 >									
194 	//     < RUSS_PFXVI_II_metadata_line_16_____OKHOTSK_MINING_GEOLOGICAL_CO_20231101 >									
195 	//        < Q9YTSMAbE8zL8x572rUp54v648j1KoH2No8FUueJ5hd968qKb5epYPB1Cp8rB1tw >									
196 	//        <  u =="0.000000000000000001" : ] 000000293589299.224178000000000000 ; 000000309869172.244152000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000001BFFB521D8D2A5 >									
198 	//     < RUSS_PFXVI_II_metadata_line_17_____AYAX_PROSPECTORS_ARTEL_CO_20231101 >									
199 	//        < kKp5s3F2003Dsy07HYZ8w05hQ4780F2Y217Yr0F5l0x43x0gSuqobsNW498PFoMI >									
200 	//        <  u =="0.000000000000000001" : ] 000000309869172.244152000000000000 ; 000000325656855.605076000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000001D8D2A51F0E9B6 >									
202 	//     < RUSS_PFXVI_II_metadata_line_18_____POLYMETAL_INDUSTRIA_20231101 >									
203 	//        < 6bo027pM82JeY4kMGnBXvCShhD3KGa3A6J0en4GoZf0cwcxQmhCqajbwHgM8nTO6 >									
204 	//        <  u =="0.000000000000000001" : ] 000000325656855.605076000000000000 ; 000000341077435.673515000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000001F0E9B62087160 >									
206 	//     < RUSS_PFXVI_II_metadata_line_19_____ASHANTI_POLYMET_STRATE_ALL_MANCO_20231101 >									
207 	//        < 46wNY592mTIfq643LM14db7yDukU11f5L2CWhq5zk18g8RvJt0Pf5W58FkzL76t0 >									
208 	//        <  u =="0.000000000000000001" : ] 000000341077435.673515000000000000 ; 000000356608072.766447000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000000020871602202407 >									
210 	//     < RUSS_PFXVI_II_metadata_line_20_____RUDNIK_AVLAYAKAN_20231101 >									
211 	//        < 5mg7c0MojTwZm4Ia4but2xNMP12kfkayg8L219QV4bVkL95YUm249N9pw6c0eidI >									
212 	//        <  u =="0.000000000000000001" : ] 000000356608072.766447000000000000 ; 000000376028691.155326000000000000 ] >									
213 	//        < 0x00000000000000000000000000000000000000000000000000220240723DC635 >									
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
256 	//     < RUSS_PFXVI_II_metadata_line_21_____OLYMP_OOO_20231101 >									
257 	//        < BcK2Ou45o3N4Mj92e7qyz4pEZ1QelE6nF9boIh08MO6QtbNLrD7Bl53O8b08x2wd >									
258 	//        <  u =="0.000000000000000001" : ] 000000376028691.155326000000000000 ; 000000394242013.339997000000000000 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000000023DC63525990C9 >									
260 	//     < RUSS_PFXVI_II_metadata_line_22_____SEMCHENSKOYE_ZOLOTO_20231101 >									
261 	//        < 03slUlEgh55Gvfnj3lr32rV0rm70DKy4vJqO0I1QR2D1iI0tcC3wPVs6i5L885Uv >									
262 	//        <  u =="0.000000000000000001" : ] 000000394242013.339997000000000000 ; 000000414101235.511458000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000025990C9277DE4C >									
264 	//     < RUSS_PFXVI_II_metadata_line_23_____MAYSKOYE_20231101 >									
265 	//        < gtvsK01HI2FeRbPT3mYgvMWPVoWzCy40k9519EOHg6MWYWEAnH6a14mQWAURr9u7 >									
266 	//        <  u =="0.000000000000000001" : ] 000000414101235.511458000000000000 ; 000000430426649.182435000000000000 ] >									
267 	//        < 0x00000000000000000000000000000000000000000000000000277DE4C290C769 >									
268 	//     < RUSS_PFXVI_II_metadata_line_24_____FIANO_INVESTMENTS_20231101 >									
269 	//        < vWoRxF8dS0X6y8u497MhV126TfvPox8MA6EH1JCyqdpr61n9y5o619E800a0bfLd >									
270 	//        <  u =="0.000000000000000001" : ] 000000430426649.182435000000000000 ; 000000454607916.037733000000000000 ] >									
271 	//        < 0x00000000000000000000000000000000000000000000000000290C7692B5AD38 >									
272 	//     < RUSS_PFXVI_II_metadata_line_25_____URAL_POLYMETAL_20231101 >									
273 	//        < G14v9661sOb693sHl979csHtBS6800z6xlwGfht88n54N5QQd9m4gW29mM69bU7p >									
274 	//        <  u =="0.000000000000000001" : ] 000000454607916.037733000000000000 ; 000000477071344.160923000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002B5AD382D7F3FE >									
276 	//     < RUSS_PFXVI_II_metadata_line_26_____POLYMETAL_PDRUS_LLC_20231101 >									
277 	//        < 5102j08t11TD7zv03895j6boq833qoeFG9E2bpm2P1Dde6TVG6u8n2CA2lx960Cz >									
278 	//        <  u =="0.000000000000000001" : ] 000000477071344.160923000000000000 ; 000000496170712.152229000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000002D7F3FE2F518AF >									
280 	//     < RUSS_PFXVI_II_metadata_line_27_____VOSTOCHNY_BASIS_20231101 >									
281 	//        < ARS6HU1F6Z3GUs09cH0D88T1E2S7cdL2qdgD23Tf71yQh96DF9fd5j3m3ToFTM55 >									
282 	//        <  u =="0.000000000000000001" : ] 000000496170712.152229000000000000 ; 000000520049568.461858000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000002F518AF319885D >									
284 	//     < RUSS_PFXVI_II_metadata_line_28_____SAUM_MINING_CO_20231101 >									
285 	//        < xMhuqC4HrVr55f4uXqrxEHn42KkFUdstoYXn8U5VcoIt1pAI19lclim092giOG16 >									
286 	//        <  u =="0.000000000000000001" : ] 000000520049568.461858000000000000 ; 000000536236745.808849000000000000 ] >									
287 	//        < 0x00000000000000000000000000000000000000000000000000319885D3323B7B >									
288 	//     < RUSS_PFXVI_II_metadata_line_29_____ALBAZINO_RESOURCES_20231101 >									
289 	//        < 48yfyFA12vW9zJ5vFLcegCqs24bT77C3EcK82HtabEZQ36HbKnteH5V35B7w5og3 >									
290 	//        <  u =="0.000000000000000001" : ] 000000536236745.808849000000000000 ; 000000551638052.832288000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000003323B7B349BB9D >									
292 	//     < RUSS_PFXVI_II_metadata_line_30_____POLYMETAL_INDUSTRIYA_20231101 >									
293 	//        < B68PR99cAh55unKbwl3elXNXcQEz8C1uJ0sPTUgCOio5tWwrK346o726rt2724ys >									
294 	//        <  u =="0.000000000000000001" : ] 000000551638052.832288000000000000 ; 000000575299732.633624000000000000 ] >									
295 	//        < 0x00000000000000000000000000000000000000000000000000349BB9D36DD675 >									
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
338 	//     < RUSS_PFXVI_II_metadata_line_31_____AS_APK_HOLDINGS_LIMITED_20231101 >									
339 	//        < dt7p7HKIO94t77QDr8S9f27baQJ44k95uTXzR1dx5Z2n32bDxEzj703K1XRuY1g9 >									
340 	//        <  u =="0.000000000000000001" : ] 000000575299732.633624000000000000 ; 000000593887997.328932000000000000 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000000000036DD67538A3380 >									
342 	//     < RUSS_PFXVI_II_metadata_line_32_____POLAR_SILVER_RESOURCES_20231101 >									
343 	//        < wpk89k7spk1215ZmTOax1Na5d2K5DKv58IB30Q8VWUR3P4gE3M7K314cId52nV76 >									
344 	//        <  u =="0.000000000000000001" : ] 000000593887997.328932000000000000 ; 000000614548746.382771000000000000 ] >									
345 	//        < 0x0000000000000000000000000000000000000000000000000038A33803A9BA1B >									
346 	//     < RUSS_PFXVI_II_metadata_line_33_____PMTL_HOLDING_LIMITED_20231101 >									
347 	//        < 0oDsDh39x02BWKMpxKg45gTUy23qnBS6u95ve52b9ZjvBAPqFT93JaI2Ltc803cP >									
348 	//        <  u =="0.000000000000000001" : ] 000000614548746.382771000000000000 ; 000000631264523.329106000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000003A9BA1B3C33BB4 >									
350 	//     < RUSS_PFXVI_II_metadata_line_34_____ALBAZINO_RESOURCES_LIMITED_20231101 >									
351 	//        < 54pZFiVQwJ3miP5Wl22Fj9v538V2voc0tohp9Aq2W9x3MzGFT63PgVY9x8FExpW8 >									
352 	//        <  u =="0.000000000000000001" : ] 000000631264523.329106000000000000 ; 000000648686963.414261000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000003C33BB43DDD158 >									
354 	//     < RUSS_PFXVI_II_metadata_line_35_____RUDNIK_KVARTSEVYI_20231101 >									
355 	//        < RkS7g4oUnM255WcK4K1IsSvd6VWce1Bxpdip92zp2NJFr88KvFyxLV18fZL6GN58 >									
356 	//        <  u =="0.000000000000000001" : ] 000000648686963.414261000000000000 ; 000000668380306.776045000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000003DDD1583FBDE0F >									
358 	//     < RUSS_PFXVI_II_metadata_line_36_____NEVYANSK_GROUP_20231101 >									
359 	//        < 71aQ3COyp06eB2y3P64Z356Ge24kKOko1avLP1t12wp9F4a0YaPkne4ctpRS3FJe >									
360 	//        <  u =="0.000000000000000001" : ] 000000668380306.776045000000000000 ; 000000685300085.300022000000000000 ] >									
361 	//        < 0x000000000000000000000000000000000000000000000000003FBDE0F415AF59 >									
362 	//     < RUSS_PFXVI_II_metadata_line_37_____AMURSK_HYDROMETALL_PLANT_20231101 >									
363 	//        < S1Xh3vJqcSYZt3Uh3hn22m77Jjx053pZf2ZCrL5T620hULlq0yU2bJ98xV5U7P11 >									
364 	//        <  u =="0.000000000000000001" : ] 000000685300085.300022000000000000 ; 000000705636381.450369000000000000 ] >									
365 	//        < 0x00000000000000000000000000000000000000000000000000415AF59434B736 >									
366 	//     < RUSS_PFXVI_II_metadata_line_38_____AMURSK_HYDROMETALL_PLANT_ORG_20231101 >									
367 	//        < iY7D9v1x16mjdHOdwE2cIasZ76ejxJMb4r1FwA8Hj4zV89aV79VkK7WmEi1o6ZE9 >									
368 	//        <  u =="0.000000000000000001" : ] 000000705636381.450369000000000000 ; 000000728606180.887268000000000000 ] >									
369 	//        < 0x00000000000000000000000000000000000000000000000000434B736457C3CA >									
370 	//     < RUSS_PFXVI_II_metadata_line_39_____OKHOTSKAYA_MINING_GEO_COMPANY_20231101 >									
371 	//        < ujNFSu3LkhI4F4sex9bAKdIoZk6jYG8MU88b8S2x1gK3yBNV719Au1v857z4QY2M >									
372 	//        <  u =="0.000000000000000001" : ] 000000728606180.887268000000000000 ; 000000748397332.236107000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000457C3CA475F6B5 >									
374 	//     < RUSS_PFXVI_II_metadata_line_40_____DUNDEE_PRECIOUS_METALS_KAPAN_20231101 >									
375 	//        < psp771aEa6m9GB6LLA7IKDAqNo037y9i9S1zxTbGKrY4ARutA3QJMQ5u1KUQ8853 >									
376 	//        <  u =="0.000000000000000001" : ] 000000748397332.236107000000000000 ; 000000765536332.851386000000000000 ] >									
377 	//        < 0x00000000000000000000000000000000000000000000000000475F6B54901DA1 >									
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