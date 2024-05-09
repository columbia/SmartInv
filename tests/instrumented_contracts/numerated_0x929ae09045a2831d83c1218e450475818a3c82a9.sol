1 pragma solidity 		^0.4.25	;						
2 										
3 	contract	KHC_LAB_210_3_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	KHC_LAB_210_3_883		"	;
8 		string	public		symbol =	"	KHC_LAB_210_3_1subDT		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		2244975293548960000000000000					;	
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
92 	//     < KHC_LAB_210_3_metadata_line_1_____KHC_LAB_210_3Y_abc_i >									
93 	//        < SPy1j1Zbn4HzG20D5T3BNL1aBVNalOSH2LHNSu23G6yBn9089sQ3l0Sw7V38YCCC >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000056127806.663920400000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000003D5E13 >									
96 	//     < KHC_LAB_210_3_metadata_line_2_____KHC_LAB_210_3Y_abc_ii >									
97 	//        < 034Py4puG634e1e96W92w7GnhGbeH0z52emil28bTKzRLAgqP125WbY0J728PGBF >									
98 	//        <  u =="0.000000000000000001" : ] 000000056127806.663920400000000000 ; 000000112263407.717434000000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000003D5E137AB8A4 >									
100 	//     < KHC_LAB_210_3_metadata_line_3_____KHC_LAB_210_3Y_abc_iii >									
101 	//        < Liq5YN768P34brbi9ewi15z2QTbA67Ss3p24YjGxHz2vgBI90cCsgs5mGh6EG6UE >									
102 	//        <  u =="0.000000000000000001" : ] 000000112263407.717434000000000000 ; 000000168392178.928740000000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000007AB8A4B81CF0 >									
104 	//     < KHC_LAB_210_3_metadata_line_4_____KHC_LAB_210_3Y_abc_iv >									
105 	//        < 7SyzJ1QMoeQwDA3849W1JGK0tB25uT2wJ6AXLcl6okdpp2QC4dnqQ7tCed9sBNUl >									
106 	//        <  u =="0.000000000000000001" : ] 000000168392178.928740000000000000 ; 000000224512630.571654000000000000 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000000000B81CF0F56F0E >									
108 	//     < KHC_LAB_210_3_metadata_line_5_____KHC_LAB_210_3Y_abc_v >									
109 	//        < II1oRwf6ow0w5w9IEkaxl1G95wrOWK9GYWUr1o54ynn1t1jRb9BjVWn0I29U3V49 >									
110 	//        <  u =="0.000000000000000001" : ] 000000224512630.571654000000000000 ; 000000280636753.486351000000000000 ] >									
111 	//        < 0x000000000000000000000000000000000000000000000000000F56F0E132E0DF >									
112 	//     < KHC_LAB_210_3_metadata_line_6_____KHC_LAB_210_3Y_abc_vi >									
113 	//        < GNaz8bp5d586E30kbZDDCOuNzej6GwOch9g6o9m3Y6hoedY1ejD90Vr6PT1djHBW >									
114 	//        <  u =="0.000000000000000001" : ] 000000280636753.486351000000000000 ; 000000336772630.284586000000000000 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000000000132E0DF170316B >									
116 	//     < KHC_LAB_210_3_metadata_line_7_____KHC_LAB_210_3Y_abc_vii >									
117 	//        < U5e4H8QOWDPhaSRoUa3m5FXHEZFk81aMt73IVjNglx9jGZlXHSv75c8n3ng5lG4q >									
118 	//        <  u =="0.000000000000000001" : ] 000000336772630.284586000000000000 ; 000000392895912.819199000000000000 ] >									
119 	//        < 0x00000000000000000000000000000000000000000000000000170316B1AD9670 >									
120 	//     < KHC_LAB_210_3_metadata_line_8_____KHC_LAB_210_3Y_abc_viii >									
121 	//        < SgQxUETZuS055xCLlLhA554y0KKua4nS3g19hS6WN2IiaZ10ow4ocAmdWoB3218D >									
122 	//        <  u =="0.000000000000000001" : ] 000000392895912.819199000000000000 ; 000000449018679.002680000000000000 ] >									
123 	//        < 0x000000000000000000000000000000000000000000000000001AD96701EAEDB5 >									
124 	//     < KHC_LAB_210_3_metadata_line_9_____KHC_LAB_210_3Y_abc_ix >									
125 	//        < I0VllTVzOEUJ9Njilb0W1FvnMD26X5a15230MLo7yonE2QJdOk5Z1RXNKfat53i7 >									
126 	//        <  u =="0.000000000000000001" : ] 000000449018679.002680000000000000 ; 000000505139444.237007000000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000001EAEDB52283A86 >									
128 	//     < KHC_LAB_210_3_metadata_line_10_____KHC_LAB_210_3Y_abc_x >									
129 	//        < 5z95Zxn0e6wsp9Aej4GyGNfTOs8XE12o2os1jN9BbIZsnthA81135v0Mwi964GCc >									
130 	//        <  u =="0.000000000000000001" : ] 000000505139444.237007000000000000 ; 000000561257946.144415000000000000 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000000002283A86265966F >									
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
174 	//     < KHC_LAB_210_3_metadata_line_11_____KHC_LAB_210_3Y_abc_xi >									
175 	//        < 2A4nVF6j6F448W0LxEQa5oC39coI9ES7R4SbDft3kdqI83rvd3t50N54Ta62H98u >									
176 	//        <  u =="0.000000000000000001" : ] 000000561257946.144415000000000000 ; 000000617392328.625543000000000000 ] >									
177 	//        < 0x00000000000000000000000000000000000000000000000000265966F2A2EC5E >									
178 	//     < KHC_LAB_210_3_metadata_line_12_____KHC_LAB_210_3Y_abc_xii >									
179 	//        < SNsyphkHSGF72dN58dS9E4uIcQcvR2V9mGgjVf3d2GS3XDq60195E06stTgB52ah >									
180 	//        <  u =="0.000000000000000001" : ] 000000617392328.625543000000000000 ; 000000673513810.103249000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000002A2EC5E2E05E9C >									
182 	//     < KHC_LAB_210_3_metadata_line_13_____KHC_LAB_210_3Y_abc_xiii >									
183 	//        < c6q8l8xdXy0RUi7mQ9CEP7iZ7cSmk1OGlmZ5iA8EN8352A5hg100nf6dDUv41ifL >									
184 	//        <  u =="0.000000000000000001" : ] 000000673513810.103249000000000000 ; 000000729643342.158845000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000002E05E9C31DB5E0 >									
186 	//     < KHC_LAB_210_3_metadata_line_14_____KHC_LAB_210_3Y_abc_xiv >									
187 	//        < J4yla43mak86U58Aepek9EzIVvrsqNO3gKT0f4t3Fb036KL3ZyD857lG5YJ9Jo73 >									
188 	//        <  u =="0.000000000000000001" : ] 000000729643342.158845000000000000 ; 000000785758704.499613000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000031DB5E035B2178 >									
190 	//     < KHC_LAB_210_3_metadata_line_15_____KHC_LAB_210_3Y_abc_xv >									
191 	//        < 5KVGAm1qe5j7Z1C528TUapOCwm749kT8152GGe4HSG0E23Pn08GdN4vZ0zIo2M3r >									
192 	//        <  u =="0.000000000000000001" : ] 000000785758704.499613000000000000 ; 000000841890009.358552000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000035B2178398996D >									
194 	//     < KHC_LAB_210_3_metadata_line_16_____KHC_LAB_210_3Y_abc_xvi >									
195 	//        < 5XwBHCQRl3lg4HB6in5H9WMPG8zb2oCfS31lowm249yi5DpaC46DMf6jWQ0QKLGg >									
196 	//        <  u =="0.000000000000000001" : ] 000000841890009.358552000000000000 ; 000000898017182.155993000000000000 ] >									
197 	//        < 0x00000000000000000000000000000000000000000000000000398996D3D604AF >									
198 	//     < KHC_LAB_210_3_metadata_line_17_____KHC_LAB_210_3Y_abc_xvii >									
199 	//        < YB5oYU03egqZn8KOMxDXm21A0gpPOzAdUlrJN6gr2PWT3bIk5wulqGC4YO5QgQ96 >									
200 	//        <  u =="0.000000000000000001" : ] 000000898017182.155993000000000000 ; 000000954138670.265611000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000003D604AF41368D7 >									
202 	//     < KHC_LAB_210_3_metadata_line_18_____KHC_LAB_210_3Y_abc_xviii >									
203 	//        < WD8pteCs1Td7xS9VN5u9clSnRQe9sUFlFY5PUmvTvoS5kD3X871IrsY77rnEUv47 >									
204 	//        <  u =="0.000000000000000001" : ] 000000954138670.265611000000000000 ; 000001010265830.745810000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000041368D7450CDDB >									
206 	//     < KHC_LAB_210_3_metadata_line_19_____KHC_LAB_210_3Y_abc_xix >									
207 	//        < vZ41b8sGJOB573IE9sza00CNoyzvGLy4292440fVJ5SyNx0b7wD5SP1Nf13t9m90 >									
208 	//        <  u =="0.000000000000000001" : ] 000001010265830.745810000000000000 ; 000001066384116.650320000000000000 ] >									
209 	//        < 0x00000000000000000000000000000000000000000000000000450CDDB48E348A >									
210 	//     < KHC_LAB_210_3_metadata_line_20_____KHC_LAB_210_3Y_abc_xx >									
211 	//        < aLrLJk9ynT4v8aK059ZosO1Y5rFY1oAY8FOg1g5RPH1SA0a46Z6VX6bw4Hw5O7vc >									
212 	//        <  u =="0.000000000000000001" : ] 000001066384116.650320000000000000 ; 000001122502523.819540000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000048E348A4CBA7F7 >									
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
256 	//     < KHC_LAB_210_3_metadata_line_21_____KHC_LAB_210_3Y_abc_xxi >									
257 	//        < 679RwSj5ddn101q4K8K0gmc3U2DPJ3y3Fjtc53sibrMo8Mc3cA24OXybh8T6xsl2 >									
258 	//        <  u =="0.000000000000000001" : ] 000001122502523.819540000000000000 ; 000001178638256.586060000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000004CBA7F7508EB1F >									
260 	//     < KHC_LAB_210_3_metadata_line_22_____KHC_LAB_210_3Y_abc_xxii >									
261 	//        < 0bBF31vEk4u1JIOF8iPzxCxHdoO5fCc7cKrmp2kXon1ECj61085Y6x0ZKVo56g8V >									
262 	//        <  u =="0.000000000000000001" : ] 000001178638256.586060000000000000 ; 000001234752063.397360000000000000 ] >									
263 	//        < 0x00000000000000000000000000000000000000000000000000508EB1F5462EA7 >									
264 	//     < KHC_LAB_210_3_metadata_line_23_____KHC_LAB_210_3Y_abc_xxiii >									
265 	//        < Ma44QbHI3lGPLu8HlJGvw5kg6VCL4q4crBSVm0ucBnPf0reCIN3LK541Vik5UvMn >									
266 	//        <  u =="0.000000000000000001" : ] 000001234752063.397360000000000000 ; 000001290875656.691610000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000005462EA758381BA >									
268 	//     < KHC_LAB_210_3_metadata_line_24_____KHC_LAB_210_3Y_abc_xxiv >									
269 	//        < 6xH5rbd7oVyqrkK1ZRbVxgdrELPLcSVGs3DtV5T39C70pa635Pcl5N22jPUM31W4 >									
270 	//        <  u =="0.000000000000000001" : ] 000001290875656.691610000000000000 ; 000001346994001.333690000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000058381BA5C0F839 >									
272 	//     < KHC_LAB_210_3_metadata_line_25_____KHC_LAB_210_3Y_abc_xxv >									
273 	//        < 9JwfKiIEP93Edp7CGpMAl698bCF84914q7K3vZQVL66iJ8o56h3j7Vp63HqYmqV0 >									
274 	//        <  u =="0.000000000000000001" : ] 000001346994001.333690000000000000 ; 000001403115272.485330000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000005C0F8395FE472C >									
276 	//     < KHC_LAB_210_3_metadata_line_26_____KHC_LAB_210_3Y_abc_xxvi >									
277 	//        < r2CuIn1px57JI23eGIbSs6K57b01K74l9MDdXbtxnh3Z6C2r9527kyYRN1NhAnhV >									
278 	//        <  u =="0.000000000000000001" : ] 000001403115272.485330000000000000 ; 000001459244954.247090000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000005FE472C63BB336 >									
280 	//     < KHC_LAB_210_3_metadata_line_27_____KHC_LAB_210_3Y_abc_xxvii >									
281 	//        < KtfkuTNutEzYvMKY432wldS9M6o756w9QK9MqmnUT5jPseF8cPLB4Z9pMc26qQbr >									
282 	//        <  u =="0.000000000000000001" : ] 000001459244954.247090000000000000 ; 000001515373174.963880000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000063BB33667906A0 >									
284 	//     < KHC_LAB_210_3_metadata_line_28_____KHC_LAB_210_3Y_abc_xxviii >									
285 	//        < J26ZFhX1k5t2134585gr5PF8oP0F68SO48j7XzA2039dHK9n629uziiJ52xShd7B >									
286 	//        <  u =="0.000000000000000001" : ] 000001515373174.963880000000000000 ; 000001571502531.730960000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000067906A06B662B3 >									
288 	//     < KHC_LAB_210_3_metadata_line_29_____KHC_LAB_210_3Y_abc_xxix >									
289 	//        < nzpyOPnRCM7KlKmB3Q2QwY6DML5aTg109SVR0JegAu681N57hkGAVOta009p7SdK >									
290 	//        <  u =="0.000000000000000001" : ] 000001571502531.730960000000000000 ; 000001627615667.835620000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000006B662B36F3A625 >									
292 	//     < KHC_LAB_210_3_metadata_line_30_____KHC_LAB_210_3Y_abc_xxx >									
293 	//        < X7pP80lA70TSkp8ENdApNI2Ji9Nh73ejt54KxSJ62fK702961PvNt80lE89Uv9X9 >									
294 	//        <  u =="0.000000000000000001" : ] 000001627615667.835620000000000000 ; 000001683730385.035530000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000006F3A625730F26D >									
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
338 	//     < KHC_LAB_210_3_metadata_line_31_____KHC_LAB_210_3Y_abc_xxxi >									
339 	//        < p588Z4318sVT0FO8EaN3RjLVZZMS4CzzuE82VY34SF8ft6F11W0X544vJ183Oz9T >									
340 	//        <  u =="0.000000000000000001" : ] 000001683730385.035530000000000000 ; 000001739865382.486050000000000000 ] >									
341 	//        < 0x00000000000000000000000000000000000000000000000000730F26D76E5047 >									
342 	//     < KHC_LAB_210_3_metadata_line_32_____KHC_LAB_210_3Y_abc_xxxii >									
343 	//        < tRcr47f8DbfvvDDjQH8a6rNQU6bg0R073Tr20gi62H40369mO75uhpuF992Du0ql >									
344 	//        <  u =="0.000000000000000001" : ] 000001739865382.486050000000000000 ; 000001795980183.999240000000000000 ] >									
345 	//        < 0x0000000000000000000000000000000000000000000000000076E50477ABA5D6 >									
346 	//     < KHC_LAB_210_3_metadata_line_33_____KHC_LAB_210_3Y_abc_xxxiii >									
347 	//        < 6fI07if1GGVrRFd2G889x8zX04kLNp3f2yi8wkpvrk1NjlrV0s7SfAzm1fQVf6cK >									
348 	//        <  u =="0.000000000000000001" : ] 000001795980183.999240000000000000 ; 000001852095259.294350000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000007ABA5D67E9059E >									
350 	//     < KHC_LAB_210_3_metadata_line_34_____KHC_LAB_210_3Y_abc_xxxiv >									
351 	//        < 106CId2R4D1g4sUB4XN99UY3P5TnODjoBJoh1fH4Ica11C29Af7sp67zp76syQaW >									
352 	//        <  u =="0.000000000000000001" : ] 000001852095259.294350000000000000 ; 000001908221128.369460000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000007E9059E82657EF >									
354 	//     < KHC_LAB_210_3_metadata_line_35_____KHC_LAB_210_3Y_abc_xxxv >									
355 	//        < o2Z0zcU25l0n1G71bY2vG0Fb0Pov0a1815QvXDNI89BKF0QYvGFunMr5dXHq0Nhc >									
356 	//        <  u =="0.000000000000000001" : ] 000001908221128.369460000000000000 ; 000001964354865.563960000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000082657EF863ADE0 >									
358 	//     < KHC_LAB_210_3_metadata_line_36_____KHC_LAB_210_3Y_abc_xxxvi >									
359 	//        < wH96vYo6eVyl0WJrejcvIW06tf5x3tzLyE27ZuD3vx9Kdm1Q86G5X35ZVV89A2to >									
360 	//        <  u =="0.000000000000000001" : ] 000001964354865.563960000000000000 ; 000002020480990.455080000000000000 ] >									
361 	//        < 0x00000000000000000000000000000000000000000000000000863ADE08A0F0D0 >									
362 	//     < KHC_LAB_210_3_metadata_line_37_____KHC_LAB_210_3Y_abc_xxxvii >									
363 	//        < 091kpBBS4Q7La9FcgI006S79617SzhPfNfaU9VNlzOG92330MOK830owkFe18d77 >									
364 	//        <  u =="0.000000000000000001" : ] 000002020480990.455080000000000000 ; 000002076596955.310730000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000008A0F0D08DE58F4 >									
366 	//     < KHC_LAB_210_3_metadata_line_38_____KHC_LAB_210_3Y_abc_xxxviii >									
367 	//        < 57c4PDknxSJI3D0MT484304JgNl6iiEdjWVRYmU7E2KDDWIxvQgt5C3NbBV878xV >									
368 	//        <  u =="0.000000000000000001" : ] 000002076596955.310730000000000000 ; 000002132732968.560290000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000008DE58F491BAF8C >									
370 	//     < KHC_LAB_210_3_metadata_line_39_____KHC_LAB_210_3Y_abc_xxxix >									
371 	//        < HJm68c78fIfI456EfKclEakEE8y831YaI73KFe3zP712my9f6v6J3XYpR53MN465 >									
372 	//        <  u =="0.000000000000000001" : ] 000002132732968.560290000000000000 ; 000002188861180.749660000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000091BAF8C9592943 >									
374 	//     < KHC_LAB_210_3_metadata_line_40_____KHC_LAB_210_3Y_abc_xxxx >									
375 	//        < 74PKoP714W1Z5vlHq4PS94o2Uqf8p3QmQb6UJd6RKT0mY05dGYAk2gwXIq56611p >									
376 	//        <  u =="0.000000000000000001" : ] 000002188861180.749660000000000000 ; 000002244975293.548960000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000095929439966D01 >									
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