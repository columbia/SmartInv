1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXXIII_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXXIII_III_883		"	;
8 		string	public		symbol =	"	RUSS_PFXXIII_III_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1006586027158770000000000000					;	
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
92 	//     < RUSS_PFXXIII_III_metadata_line_1_____INGOSSTRAKH_20251101 >									
93 	//        < mh058Fy8277SfZncLhEHNU9rEm0jh53JDU2FgXF6qcjbX8wG16DHOvt0m6B1vBE4 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000019611777.094009300000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000001DECDA >									
96 	//     < RUSS_PFXXIII_III_metadata_line_2_____ROSGOSSTRAKH_20251101 >									
97 	//        < r81g31mKXonIGgq472O4Au115s2YD4HW5YV93hXb34zCZ6XEfcQj4IQ7ht739p0o >									
98 	//        <  u =="0.000000000000000001" : ] 000000019611777.094009300000000000 ; 000000046343880.317292700000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000001DECDA46B714 >									
100 	//     < RUSS_PFXXIII_III_metadata_line_3_____TINKOFF_INSURANCE_20251101 >									
101 	//        < BrHcjclActi415rU2h2d9Oc0L05NuEe5SeU4XgQap2228uSCv7I3PE86khhBOR0w >									
102 	//        <  u =="0.000000000000000001" : ] 000000046343880.317292700000000000 ; 000000072496648.616534500000000000 ] >									
103 	//        < 0x000000000000000000000000000000000000000000000000000046B7146E9F01 >									
104 	//     < RUSS_PFXXIII_III_metadata_line_4_____MOSCOW_EXCHANGE_20251101 >									
105 	//        < NHfAlC40z6pDyKNOx8e4B7F83s176g5O6mL6122OlO63uEvjy33K2eF13yoG12Nb >									
106 	//        <  u =="0.000000000000000001" : ] 000000072496648.616534500000000000 ; 000000091746553.868617900000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000006E9F018BFE7F >									
108 	//     < RUSS_PFXXIII_III_metadata_line_5_____YANDEX_20251101 >									
109 	//        < 73nD1jva88iLmlV5MA968784LbZHkQRctnh06YBXKwnsbk6a1317P4lPN2FPcI86 >									
110 	//        <  u =="0.000000000000000001" : ] 000000091746553.868617900000000000 ; 000000114836093.271344000000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000008BFE7FAF39D9 >									
112 	//     < RUSS_PFXXIII_III_metadata_line_6_____UNIPRO_20251101 >									
113 	//        < yl504r0Flo2moHUmAIMq130ps052CP234Jx60Y38FtKYo72UKxi1M4Nmbdbc0z26 >									
114 	//        <  u =="0.000000000000000001" : ] 000000114836093.271344000000000000 ; 000000145076016.480153000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000AF39D9DD5E52 >									
116 	//     < RUSS_PFXXIII_III_metadata_line_7_____DIXY_20251101 >									
117 	//        < v4Q578V0SQ48TU2xoyN2WcQMyS185Bj2TT0gqo0CcdepYCZo2hw11a9YkYE955c3 >									
118 	//        <  u =="0.000000000000000001" : ] 000000145076016.480153000000000000 ; 000000168176819.241449000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000000DD5E521009E12 >									
120 	//     < RUSS_PFXXIII_III_metadata_line_8_____MECHEL_20251101 >									
121 	//        < 9cE0wv6WTF99kltMtbU0JZOCbnK0W97yWPSf6uBOdONCS1eDDM5fvBGAZHb3Lgd6 >									
122 	//        <  u =="0.000000000000000001" : ] 000000168176819.241449000000000000 ; 000000199874890.429468000000000000 ] >									
123 	//        < 0x000000000000000000000000000000000000000000000000001009E12130FC21 >									
124 	//     < RUSS_PFXXIII_III_metadata_line_9_____VSMPO_AVISMA_20251101 >									
125 	//        < 35r0gjaRqJNClOL6YMIim9dA9b7x3f59K1GoU01aYM6G5j73sxp2A9ehR2BkLnG8 >									
126 	//        <  u =="0.000000000000000001" : ] 000000199874890.429468000000000000 ; 000000226450162.836307000000000000 ] >									
127 	//        < 0x00000000000000000000000000000000000000000000000000130FC211598918 >									
128 	//     < RUSS_PFXXIII_III_metadata_line_10_____AGRIUM_20251101 >									
129 	//        < 5QAI356GIDMj11xgnaHGzSz9t21egFDhh4DDSgYdJNTy1T0whJm6T7dAaQQB7Wyu >									
130 	//        <  u =="0.000000000000000001" : ] 000000226450162.836307000000000000 ; 000000244808536.325588000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000015989181758C56 >									
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
174 	//     < RUSS_PFXXIII_III_metadata_line_11_____ONEXIM_20251101 >									
175 	//        < Ee2vJ0YWfF44CtH8Fcj0m5s65H5zhGgc7mePvKg03f5iPVJV4Jn4kaA6BgpCI5Wz >									
176 	//        <  u =="0.000000000000000001" : ] 000000244808536.325588000000000000 ; 000000263390306.281952000000000000 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000000001758C56191E6D7 >									
178 	//     < RUSS_PFXXIII_III_metadata_line_12_____SILOVYE_MACHINY_20251101 >									
179 	//        < 1aUs9B46o73B2CTqsgtBdcGu9gomX6S7IdpS6OB4rYc9JdJ926GGbntEhb95UW68 >									
180 	//        <  u =="0.000000000000000001" : ] 000000263390306.281952000000000000 ; 000000294858735.538297000000000000 ] >									
181 	//        < 0x00000000000000000000000000000000000000000000000000191E6D71C1EB32 >									
182 	//     < RUSS_PFXXIII_III_metadata_line_13_____RPC_UWC_20251101 >									
183 	//        < T9BpXTLjj9c6YD5nXdyZMAK4OkXfDjNx7N0h9K6no0FdqnjqW65R694qMBPOTEd6 >									
184 	//        <  u =="0.000000000000000001" : ] 000000294858735.538297000000000000 ; 000000327844771.334790000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001C1EB321F4405D >									
186 	//     < RUSS_PFXXIII_III_metadata_line_14_____INTERROS_20251101 >									
187 	//        < zt215r71o7Tg1k9j730HIVFa4KJG7A6JKLdJlIHF3eV47160309b32O041D6mmk6 >									
188 	//        <  u =="0.000000000000000001" : ] 000000327844771.334790000000000000 ; 000000356445699.837770000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000001F4405D21FE49A >									
190 	//     < RUSS_PFXXIII_III_metadata_line_15_____PROF_MEDIA_20251101 >									
191 	//        < oQKrdS1NZau7oSr67aI45meBK5025f2EMUShTlgHVO07708QMz2pr49LOVPfbBO6 >									
192 	//        <  u =="0.000000000000000001" : ] 000000356445699.837770000000000000 ; 000000389424590.559964000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000021FE49A25236FB >									
194 	//     < RUSS_PFXXIII_III_metadata_line_16_____ACRON_GROUP_20251101 >									
195 	//        < 1Fk5klfrigg8Gb7k1FT70pcurdK3Cq1PXACY59C376v089FDmKl9nZkpG3E3SQYJ >									
196 	//        <  u =="0.000000000000000001" : ] 000000389424590.559964000000000000 ; 000000417885768.538147000000000000 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000000025236FB27DA4A1 >									
198 	//     < RUSS_PFXXIII_III_metadata_line_17_____RASSVET_20251101 >									
199 	//        < Z08Ue1scTh874lWK7WZ1SyS2OVBTn1QW3JBKbW13K27sAXtgNg68GQmQMSDXAvcm >									
200 	//        <  u =="0.000000000000000001" : ] 000000417885768.538147000000000000 ; 000000452728030.955724000000000000 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000000027DA4A12B2CEE3 >									
202 	//     < RUSS_PFXXIII_III_metadata_line_18_____LUZHSKIY_KOMBIKORMOVIY_ZAVOD_20251101 >									
203 	//        < OnU2z7rp19ILwEUK1Ma927v949X3MUpG1V4Nk7QYgchQ5aBE6uX4tJ9mAfDLmDrY >									
204 	//        <  u =="0.000000000000000001" : ] 000000452728030.955724000000000000 ; 000000478487317.333100000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000002B2CEE32DA1D1C >									
206 	//     < RUSS_PFXXIII_III_metadata_line_19_____LSR GROUP_20251101 >									
207 	//        < H3B2l8Tck6x08idcyU8kbW9pH63i9uv8A1t8KxYuG1STrkKR2Hf9R0e8r0HMKK6F >									
208 	//        <  u =="0.000000000000000001" : ] 000000478487317.333100000000000000 ; 000000504084353.701002000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000002DA1D1C3012BF3 >									
210 	//     < RUSS_PFXXIII_III_metadata_line_20_____MMK_20251101 >									
211 	//        < 2bS9Fl63MIG000vXb85qoZW6QZw69etkFM1009H881796C1r8GpH5bzKTQpgnZ41 >									
212 	//        <  u =="0.000000000000000001" : ] 000000504084353.701002000000000000 ; 000000524766623.322086000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000003012BF3320BAF6 >									
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
256 	//     < RUSS_PFXXIII_III_metadata_line_21_____MOESK_20251101 >									
257 	//        < OdRzAvwO44Z12h96xT4KT2RRV6vWc3dZ5Tf2C1y907K31ivQecTBA5xQUV3ODJ32 >									
258 	//        <  u =="0.000000000000000001" : ] 000000524766623.322086000000000000 ; 000000549615656.027289000000000000 ] >									
259 	//        < 0x00000000000000000000000000000000000000000000000000320BAF6346A59E >									
260 	//     < RUSS_PFXXIII_III_metadata_line_22_____MOSTOTREST_20251101 >									
261 	//        < UCM1l4m78imY65vo94Sv9IEvF4C2R0YpLV33O0W7H8r7b2Yxi35t7jubQnG3i28F >									
262 	//        <  u =="0.000000000000000001" : ] 000000549615656.027289000000000000 ; 000000568729006.169307000000000000 ] >									
263 	//        < 0x00000000000000000000000000000000000000000000000000346A59E363CFC5 >									
264 	//     < RUSS_PFXXIII_III_metadata_line_23_____MVIDEO_20251101 >									
265 	//        < x753W5iS0qWsW62r4NKVwot02KfLK9YiN6I503y0bs6W38g9XOUnJ7WrkOT20yei >									
266 	//        <  u =="0.000000000000000001" : ] 000000568729006.169307000000000000 ; 000000590206243.786195000000000000 ] >									
267 	//        < 0x00000000000000000000000000000000000000000000000000363CFC53849550 >									
268 	//     < RUSS_PFXXIII_III_metadata_line_24_____NCSP_20251101 >									
269 	//        < 1UODwBgX09AFwx0fvScFUmCI9rmKKA3s8g38LMf20NDBij2z6Qtx6V950vFP9ebT >									
270 	//        <  u =="0.000000000000000001" : ] 000000590206243.786195000000000000 ; 000000612715681.251825000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000038495503A6EE10 >									
272 	//     < RUSS_PFXXIII_III_metadata_line_25_____MOSAIC_COMPANY_20251101 >									
273 	//        < 9aWksI2Eic0PA1326528agkSc2DH2jr1HR1oG4ekT6PVoN4Rk88aVtD6gvaM33B9 >									
274 	//        <  u =="0.000000000000000001" : ] 000000612715681.251825000000000000 ; 000000635800835.357967000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000003A6EE103CA27B4 >									
276 	//     < RUSS_PFXXIII_III_metadata_line_26_____METALLOINVEST_20251101 >									
277 	//        < AKe7HWuRlb4g6VE1DqL7m1jy47zc5EMt8D9NDU00fH8TP814u2I5l2a02WP6wytA >									
278 	//        <  u =="0.000000000000000001" : ] 000000635800835.357967000000000000 ; 000000655315492.251635000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000003CA27B43E7EE9D >									
280 	//     < RUSS_PFXXIII_III_metadata_line_27_____TOGLIATTIAZOT_20251101 >									
281 	//        < oUZ31HIr8gaT9i8d2jiBkdVl6V1h7zRK83m0O1STciWlI1WBJ6m8Dh1x54iLLT58 >									
282 	//        <  u =="0.000000000000000001" : ] 000000655315492.251635000000000000 ; 000000680697272.249041000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000003E7EE9D40EA95F >									
284 	//     < RUSS_PFXXIII_III_metadata_line_28_____METAFRAKS_PAO_20251101 >									
285 	//        < 0h4Q4I5j3crKh770CHMYG82X2vr7aN09C34g0XEDUoyh0JrykEEuY2wSURDrMeOc >									
286 	//        <  u =="0.000000000000000001" : ] 000000680697272.249041000000000000 ; 000000705713426.240233000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000040EA95F434D54F >									
288 	//     < RUSS_PFXXIII_III_metadata_line_29_____OGK_2_CHEREPOVETS_GRES_20251101 >									
289 	//        < 7vyA3Xy38J5EkgA65iIF91c4o57w5x8LV6nFSBxFR9HTn2ioYfp7LkZ6bJ57Ro4e >									
290 	//        <  u =="0.000000000000000001" : ] 000000705713426.240233000000000000 ; 000000724394680.246832000000000000 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000000000434D54F45156AC >									
292 	//     < RUSS_PFXXIII_III_metadata_line_30_____OGK_2_GRES_24_20251101 >									
293 	//        < kSHxsPy6LaL2eEYDSD8gu3m1yADxbx8T06z0fwHG4IC9Pg32DHeN7YGicHB4mJ7a >									
294 	//        <  u =="0.000000000000000001" : ] 000000724394680.246832000000000000 ; 000000750902910.695438000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000045156AC479C973 >									
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
338 	//     < RUSS_PFXXIII_III_metadata_line_31_____PHOSAGRO_20251101 >									
339 	//        < 6GgHtdu473OZq6AMTVCDGZlmwuLSxzjenCXCh39QHJnM5IsHh8Ghhmton6P40tEI >									
340 	//        <  u =="0.000000000000000001" : ] 000000750902910.695438000000000000 ; 000000770706201.980248000000000000 ] >									
341 	//        < 0x00000000000000000000000000000000000000000000000000479C973498011C >									
342 	//     < RUSS_PFXXIII_III_metadata_line_32_____BELARUSKALI_20251101 >									
343 	//        < NCVb44d21h9vG5b8q305xL4M9TqvGF3de9CNt7BJEIxQ2Ubz9Hp5m6Tok5O7nx2H >									
344 	//        <  u =="0.000000000000000001" : ] 000000770706201.980248000000000000 ; 000000799812045.922014000000000000 ] >									
345 	//        < 0x00000000000000000000000000000000000000000000000000498011C4C46A95 >									
346 	//     < RUSS_PFXXIII_III_metadata_line_33_____KPLUSS_20251101 >									
347 	//        < SaWrSbl2uB9dbb95F8KZy54vfHElGbJ0R78ZoCoaUQFKpw069rjQ2Sdi931vuA67 >									
348 	//        <  u =="0.000000000000000001" : ] 000000799812045.922014000000000000 ; 000000820765269.443839000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000004C46A954E4636F >									
350 	//     < RUSS_PFXXIII_III_metadata_line_34_____KPLUSS_ORG_20251101 >									
351 	//        < Jh3dIL93LaDtQoJoMG6F70L50v7Zr4I2AQMA5zg52MF8nQ7XPiCc7a0gLq36HAZC >									
352 	//        <  u =="0.000000000000000001" : ] 000000820765269.443839000000000000 ; 000000845757982.187755000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000004E4636F50A8636 >									
354 	//     < RUSS_PFXXIII_III_metadata_line_35_____POTASHCORP_20251101 >									
355 	//        < c6HtPB7GBVhGA42cEqKwx4L21px5yk289kTpbrD2s8yp2VLF1jVyN7eT142XxpbK >									
356 	//        <  u =="0.000000000000000001" : ] 000000845757982.187755000000000000 ; 000000870039278.083073000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000050A863652F9318 >									
358 	//     < RUSS_PFXXIII_III_metadata_line_36_____BANK_URALSIB_20251101 >									
359 	//        < B73un8D3dZ38R9hE8k2swLfZye2iVCQWH6Z75jgGR9x6S0b1RxxIl6qbJ4nKv5o0 >									
360 	//        <  u =="0.000000000000000001" : ] 000000870039278.083073000000000000 ; 000000898455456.347633000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000052F931855AEF2A >									
362 	//     < RUSS_PFXXIII_III_metadata_line_37_____URALSIB_LEASING_CO_20251101 >									
363 	//        < oshos588L2U7gqMe7b0nwzjgYEqk3BH3h3A588HfIJ18Vzan4mEj6emDR5Vltl5R >									
364 	//        <  u =="0.000000000000000001" : ] 000000898455456.347633000000000000 ; 000000933743450.197498000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000055AEF2A590C789 >									
366 	//     < RUSS_PFXXIII_III_metadata_line_38_____BANK_URALSIB_AM_20251101 >									
367 	//        < 63PDcX7d6t0Zl3ZQ5my07XZXI8IpDU2WosEyfl3lc083sDc6OH06yr9wt649HBS7 >									
368 	//        <  u =="0.000000000000000001" : ] 000000933743450.197498000000000000 ; 000000964757081.194233000000000000 ] >									
369 	//        < 0x00000000000000000000000000000000000000000000000000590C7895C01A3C >									
370 	//     < RUSS_PFXXIII_III_metadata_line_39_____BASHKIRSKIY_20251101 >									
371 	//        < w4r7yHJ6CzdVu61wEGssetpB5nH9VUtlW0BFU247mh09I1ZNHlu7VSS4TU7X6I24 >									
372 	//        <  u =="0.000000000000000001" : ] 000000964757081.194233000000000000 ; 000000985734565.155253000000000000 ] >									
373 	//        < 0x000000000000000000000000000000000000000000000000005C01A3C5E01C91 >									
374 	//     < RUSS_PFXXIII_III_metadata_line_40_____URALSIB_INVESTMENT_ARM_20251101 >									
375 	//        < NXJ8JL5PIGYcbC2Trb5UUNlP839HSA9e0IG1O08443Q5CGTka5109KN3476JRwTd >									
376 	//        <  u =="0.000000000000000001" : ] 000000985734565.155253000000000000 ; 000001006586027.158770000000000000 ] >									
377 	//        < 0x000000000000000000000000000000000000000000000000005E01C915FFEDAB >									
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