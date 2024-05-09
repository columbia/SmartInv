1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFVI_II_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFVI_II_883		"	;
8 		string	public		symbol =	"	RUSS_PFVI_II_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		798915299627427000000000000					;	
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
92 	//     < RUSS_PFVI_II_metadata_line_1_____UPRECHISTENKA1_3319C1_MOS_RUS_I_20231101 >									
93 	//        < VnsG1apr7Kw90LCnFys5Xq26Do1p9RTOW8nCYf9q8ny2eXPNe6N7Pakb317Mv3Rc >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000022446769.344987100000000000 ] >									
95 	//        < 0x0000000000000000000000000000000000000000000000000000000000224045 >									
96 	//     < RUSS_PFVI_II_metadata_line_2_____UPRECHISTENKA1_3319C1_MOS_RUS_II_20231101 >									
97 	//        < zCS2jkfBBdg8TZBP74CiDWa9Y78PfFlte28U7yYDhArS2m42frafu18YwlJxBl1z >									
98 	//        <  u =="0.000000000000000001" : ] 000000022446769.344987100000000000 ; 000000038806348.630402300000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000002240453B36BB >									
100 	//     < RUSS_PFVI_II_metadata_line_3_____UPRECHISTENKA1_3319C1_MOS_RUS_III_20231101 >									
101 	//        < 0XiwSJ1Q59qXC5VTPx6rgm86Mou0KWGE73Fv240NiFCWPhTEyNpwahee68VHwt5z >									
102 	//        <  u =="0.000000000000000001" : ] 000000038806348.630402300000000000 ; 000000061356867.029025400000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000003B36BB5D9F87 >									
104 	//     < RUSS_PFVI_II_metadata_line_4_____UPRECHISTENKA1_3319C1_MOS_RUS_IV_20231101 >									
105 	//        < fv06WWd4kIa37x8d4sYY6tTs66BNPV529NXwpd25zm98FnANQtr3vi8hROGeQTUI >									
106 	//        <  u =="0.000000000000000001" : ] 000000061356867.029025400000000000 ; 000000080537618.936690600000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000005D9F877AE402 >									
108 	//     < RUSS_PFVI_II_metadata_line_5_____UPRECHISTENKA1_3319C1_MOS_RUS_V_20231101 >									
109 	//        < 3wa581uZZ36kP5TBsS5lG00uq540H351x3Vj26UvBgEro7fP3O58g1S36GWO895V >									
110 	//        <  u =="0.000000000000000001" : ] 000000080537618.936690600000000000 ; 000000103321583.058244000000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000007AE4029DA7FE >									
112 	//     < RUSS_PFVI_II_metadata_line_6_____UPRECHISTENKA1_3319C1_MOS_RUS_VI_20231101 >									
113 	//        < d60gYtj8znMbK6cL9vt16a2Jd6J7dRD1A20spe98c08wvYRFCyGLLc9KcGTMDuL1 >									
114 	//        <  u =="0.000000000000000001" : ] 000000103321583.058244000000000000 ; 000000118863519.020541000000000000 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000000000009DA7FEB55F10 >									
116 	//     < RUSS_PFVI_II_metadata_line_7_____UPRECHISTENKA1_3319C1_MOS_RUS_VII_20231101 >									
117 	//        < r4F2Mk4Gj31q81M0KLy7MK9KCwN220345uGY89pWWjHy0vYt0UisXbPHs7Nita5Q >									
118 	//        <  u =="0.000000000000000001" : ] 000000118863519.020541000000000000 ; 000000141303473.179551000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000B55F10D79CAB >									
120 	//     < RUSS_PFVI_II_metadata_line_8_____UPRECHISTENKA1_3319C1_MOS_RUS_VIII_20231101 >									
121 	//        < R80T1wG7IRkA1X4v19PWC0GC6AB93N8HdO3v1n4nVTp4g97nk72ko1QUNo3fPt43 >									
122 	//        <  u =="0.000000000000000001" : ] 000000141303473.179551000000000000 ; 000000159665864.078373000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000D79CABF3A17A >									
124 	//     < RUSS_PFVI_II_metadata_line_9_____UPRECHISTENKA1_3319C1_MOS_RUS_IX_20231101 >									
125 	//        < NU98Sj7Fxhz02PQ1q4QskS43RdmEpy2Z9ws33vPf48pl7tS3ei14ZVAEGjaD6fhM >									
126 	//        <  u =="0.000000000000000001" : ] 000000159665864.078373000000000000 ; 000000175940780.832781000000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000000F3A17A10C76DE >									
128 	//     < RUSS_PFVI_II_metadata_line_10_____UPRECHISTENKA1_3319C1_MOS_RUS_X_20231101 >									
129 	//        < wE63LUQGlF34I5Wj7dyjyg9bk6Ma86Fr2lqd07192v7w1gR5W539f9cfFd7Q2Jeg >									
130 	//        <  u =="0.000000000000000001" : ] 000000175940780.832781000000000000 ; 000000196318413.570130000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000010C76DE12B8EE1 >									
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
174 	//     < RUSS_PFVI_II_metadata_line_11_____UPRECHISTENKA2_3319C1_MOS_RUS_I_20231101 >									
175 	//        < 924c81POqSLfriOX5x5dFOp2je2B635i4Wv51Zu5Rgk2u7HOI7ljsw905VEcz71u >									
176 	//        <  u =="0.000000000000000001" : ] 000000196318413.570130000000000000 ; 000000215455929.812996000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000012B8EE1148C279 >									
178 	//     < RUSS_PFVI_II_metadata_line_12_____UPRECHISTENKA2_3319C1_MOS_RUS_II_20231101 >									
179 	//        < qQYcU8qMgJGNX3ep9P3C2Wrr9Upkk7ds4GqDZ2C5x8241l761t3GT8954ygh71CP >									
180 	//        <  u =="0.000000000000000001" : ] 000000215455929.812996000000000000 ; 000000240312392.908691000000000000 ] >									
181 	//        < 0x00000000000000000000000000000000000000000000000000148C27916EB007 >									
182 	//     < RUSS_PFVI_II_metadata_line_13_____UPRECHISTENKA2_3319C1_MOS_RUS_III_20231101 >									
183 	//        < v3Q02xvYJPTpIe7y2yKYK5NXPDB16Zg9Hblm0ModVb3nN2YQLaQ6088Fg5aypel2 >									
184 	//        <  u =="0.000000000000000001" : ] 000000240312392.908691000000000000 ; 000000260298218.707069000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000016EB00718D2EFE >									
186 	//     < RUSS_PFVI_II_metadata_line_14_____UPRECHISTENKA2_3319C1_MOS_RUS_IV_20231101 >									
187 	//        < S4y2bYT6zj891CD8XasIqJf7B3FWereL8ufjkx12Q4N3R6lA758iaif57I8Cl3y3 >									
188 	//        <  u =="0.000000000000000001" : ] 000000260298218.707069000000000000 ; 000000284599753.703762000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000018D2EFE1B243C7 >									
190 	//     < RUSS_PFVI_II_metadata_line_15_____UPRECHISTENKA2_3319C1_MOS_RUS_V_20231101 >									
191 	//        < XN9d0sFfNIpIKPtJ6Eb0PvE50pvcEmWsh8nS3L8mO61hi3KZW76DfHQq8IwB8uzZ >									
192 	//        <  u =="0.000000000000000001" : ] 000000284599753.703762000000000000 ; 000000304508677.217467000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000001B243C71D0A4B4 >									
194 	//     < RUSS_PFVI_II_metadata_line_16_____UPRECHISTENKA2_3319C1_MOS_RUS_VI_20231101 >									
195 	//        < 5O7qZ63QDyZCaThqaDvBSKKwrK092iZrJ9T1164ztyioNH7Uo0O5iqE1aPtY272a >									
196 	//        <  u =="0.000000000000000001" : ] 000000304508677.217467000000000000 ; 000000322350255.372609000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000001D0A4B41EBDE12 >									
198 	//     < RUSS_PFVI_II_metadata_line_17_____UPRECHISTENKA2_3319C1_MOS_RUS_VII_20231101 >									
199 	//        < ERGRIs328DQYCfsAvg2is8UDqJvN9m6gFy4oxdIRURvY2EN0XWOc802d38594sqc >									
200 	//        <  u =="0.000000000000000001" : ] 000000322350255.372609000000000000 ; 000000345129447.761815000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000001EBDE1220EA031 >									
202 	//     < RUSS_PFVI_II_metadata_line_18_____UPRECHISTENKA2_3319C1_MOS_RUS_VIII_20231101 >									
203 	//        < 1b43egtvf89SXM08tAUMHB17351i7655xcRKe9nTH7XZm2TSg2q7ZGm822xJHujv >									
204 	//        <  u =="0.000000000000000001" : ] 000000345129447.761815000000000000 ; 000000363347349.587894000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000020EA03122A6C8F >									
206 	//     < RUSS_PFVI_II_metadata_line_19_____UPRECHISTENKA2_3319C1_MOS_RUS_IX_20231101 >									
207 	//        < 9328lE7aIXv3o6thdg04xDXpH25Yg993dO3s43cNB5l6yp2r0LOO1Gh7q2R4iO05 >									
208 	//        <  u =="0.000000000000000001" : ] 000000363347349.587894000000000000 ; 000000380448600.807730000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000000022A6C8F24484BC >									
210 	//     < RUSS_PFVI_II_metadata_line_20_____UPRECHISTENKA2_3319C1_MOS_RUS_X_20231101 >									
211 	//        < hsXxJ90K60S88HweR87rBasa5M52p7YNFm4LRTnwQew5n233V8satr8a84ilLol9 >									
212 	//        <  u =="0.000000000000000001" : ] 000000380448600.807730000000000000 ; 000000400076963.963727000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000024484BC2627810 >									
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
256 	//     < RUSS_PFVI_II_metadata_line_21_____UPRECHISTENKA2_3319C1_MOS_RUS_I_20231101 >									
257 	//        < scp2046ol8rf3ySpe9dcTDGmK1trH8uuM25hC7ghv4hl2ji7uN0M6I6Z7Hve1TK9 >									
258 	//        <  u =="0.000000000000000001" : ] 000000400076963.963727000000000000 ; 000000416239555.437980000000000000 ] >									
259 	//        < 0x00000000000000000000000000000000000000000000000000262781027B2194 >									
260 	//     < RUSS_PFVI_II_metadata_line_22_____UPRECHISTENKA2_3319C1_MOS_RUS_II_20231101 >									
261 	//        < A0NE4Ra4Jw0B6b8XDD8Md7Ye1ircy7Hpe5Jm4H21Ii0vNzpf5bM5fPI475cn6CTh >									
262 	//        <  u =="0.000000000000000001" : ] 000000416239555.437980000000000000 ; 000000435899176.884680000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000027B2194299211E >									
264 	//     < RUSS_PFVI_II_metadata_line_23_____UPRECHISTENKA2_3319C1_MOS_RUS_III_20231101 >									
265 	//        < E91F23191J57b77oxX5Itpq7l2A8O2YRl1CfolQ3EaspZgumI8Bg5t862tyfkLG0 >									
266 	//        <  u =="0.000000000000000001" : ] 000000435899176.884680000000000000 ; 000000459082266.194224000000000000 ] >									
267 	//        < 0x00000000000000000000000000000000000000000000000000299211E2BC8103 >									
268 	//     < RUSS_PFVI_II_metadata_line_24_____UPRECHISTENKA2_3319C1_MOS_RUS_IV_20231101 >									
269 	//        < z1CHHo5uF0c8ni6DQ7BkDZy4vYb9hGl0AzYpQlD1R9AL12307Uv31olOV2sEp2xB >									
270 	//        <  u =="0.000000000000000001" : ] 000000459082266.194224000000000000 ; 000000474694334.893265000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000002BC81032D45379 >									
272 	//     < RUSS_PFVI_II_metadata_line_25_____UPRECHISTENKA2_3319C1_MOS_RUS_V_20231101 >									
273 	//        < B18qRk6YG7k1NBrUE8NzYNqr2h426yX82G27hj1x7E62NaS3Bgh0056476kHB06b >									
274 	//        <  u =="0.000000000000000001" : ] 000000474694334.893265000000000000 ; 000000495994724.995499000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002D453792F4D3F0 >									
276 	//     < RUSS_PFVI_II_metadata_line_26_____UPRECHISTENKA2_3319C1_MOS_RUS_VI_20231101 >									
277 	//        < drHO2a895k1aUV5H9MJePj5IwG0qlMikhhI4LqR1kONtdX1OLmlry7C3o59aWNE9 >									
278 	//        <  u =="0.000000000000000001" : ] 000000495994724.995499000000000000 ; 000000515872599.296615000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000002F4D3F031328BC >									
280 	//     < RUSS_PFVI_II_metadata_line_27_____UPRECHISTENKA2_3319C1_MOS_RUS_VII_20231101 >									
281 	//        < wOMKukT4Er08dgX7NS44ScB9qB8i86p3bt1rTs3j2IrEUu90ZrMxw37P1kO2nab9 >									
282 	//        <  u =="0.000000000000000001" : ] 000000515872599.296615000000000000 ; 000000531815626.807050000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000031328BC32B7C7B >									
284 	//     < RUSS_PFVI_II_metadata_line_28_____UPRECHISTENKA2_3319C1_MOS_RUS_VIII_20231101 >									
285 	//        < bSq5oaAhRS47c6W61t6L1Isz5Y79Cu1fIFx3G78Hn01dUm631VzB8sHFUN403T75 >									
286 	//        <  u =="0.000000000000000001" : ] 000000531815626.807050000000000000 ; 000000555444065.940756000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000032B7C7B34F8A57 >									
288 	//     < RUSS_PFVI_II_metadata_line_29_____UPRECHISTENKA2_3319C1_MOS_RUS_IX_20231101 >									
289 	//        < CC2486cCGYsbbdU2372z74vPgmbowQ0c7GPz5lCITYW8vYzJ2gVY3vb1761Q7DFw >									
290 	//        <  u =="0.000000000000000001" : ] 000000555444065.940756000000000000 ; 000000574438744.177598000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000034F8A5736C8622 >									
292 	//     < RUSS_PFVI_II_metadata_line_30_____UPRECHISTENKA2_3319C1_MOS_RUS_X_20231101 >									
293 	//        < o9EXe7VWGF8B49mC4Dp8YLPZ2k0536ZK4eGznjBU8Sd9fwao7trCnw79836QtE1V >									
294 	//        <  u =="0.000000000000000001" : ] 000000574438744.177598000000000000 ; 000000591034410.497250000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000036C8622385D8D1 >									
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
338 	//     < RUSS_PFVI_II_metadata_line_31_____UPRECHISTENKA3_3319C1_MOS_RUS_I_20231101 >									
339 	//        < MrZO18BojhQu23U9ShlRPOR0G00NvN5HlZOpmm5Lm52MlW4S33E63w086q6048vT >									
340 	//        <  u =="0.000000000000000001" : ] 000000591034410.497250000000000000 ; 000000615761316.191241000000000000 ] >									
341 	//        < 0x00000000000000000000000000000000000000000000000000385D8D13AB93C4 >									
342 	//     < RUSS_PFVI_II_metadata_line_32_____UPRECHISTENKA3_3319C1_MOS_RUS_II_20231101 >									
343 	//        < tSzr5JrraUeqL9xvBg62g1g92xBSKWr600EM5Mj0t2KRM0l7FnNi9WoP1ZcKejb6 >									
344 	//        <  u =="0.000000000000000001" : ] 000000615761316.191241000000000000 ; 000000634377421.568422000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000003AB93C43C7FBAE >									
346 	//     < RUSS_PFVI_II_metadata_line_33_____UPRECHISTENKA3_3319C1_MOS_RUS_III_20231101 >									
347 	//        < OLMR2I4jxt8AfmAbYlmHWd5QhVktrXWg2U8sBbl6Y0G3eZTex74Sd2I53jTIxMF3 >									
348 	//        <  u =="0.000000000000000001" : ] 000000634377421.568422000000000000 ; 000000650577541.105366000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000003C7FBAE3E0B3DA >									
350 	//     < RUSS_PFVI_II_metadata_line_34_____UPRECHISTENKA3_3319C1_MOS_RUS_IV_20231101 >									
351 	//        < 0rpnimfuQE1Rv5TtIKk3mop7II0A90m78rlB6MbFwMJO5sg2XSoea0wfvG1G4hZy >									
352 	//        <  u =="0.000000000000000001" : ] 000000650577541.105366000000000000 ; 000000674949613.463135000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000003E0B3DA405E431 >									
354 	//     < RUSS_PFVI_II_metadata_line_35_____UPRECHISTENKA3_3319C1_MOS_RUS_V_20231101 >									
355 	//        < FDVzdu71d2IxIb9KeUQ423E9NtC485l0Guk4DiMe2xEi2QVA11hcq8dPvzjKaZdO >									
356 	//        <  u =="0.000000000000000001" : ] 000000674949613.463135000000000000 ; 000000693245907.486132000000000000 ] >									
357 	//        < 0x00000000000000000000000000000000000000000000000000405E431421CF2F >									
358 	//     < RUSS_PFVI_II_metadata_line_36_____UPRECHISTENKA3_3319C1_MOS_RUS_VI_20231101 >									
359 	//        < Sm68oJL8GBo06Yr49W90P1cF10RHc0gym65uh5n0akF9ah6j71j9v2VtPI7vTG3Y >									
360 	//        <  u =="0.000000000000000001" : ] 000000693245907.486132000000000000 ; 000000708695176.251644000000000000 ] >									
361 	//        < 0x00000000000000000000000000000000000000000000000000421CF2F439620E >									
362 	//     < RUSS_PFVI_II_metadata_line_37_____UPRECHISTENKA3_3319C1_MOS_RUS_VII_20231101 >									
363 	//        < coeBz4lN0YSA3kSqBVSeqWVhj6dkg524imOHcmkAtGZXMtu76F6QbOU8hQsAd9q6 >									
364 	//        <  u =="0.000000000000000001" : ] 000000708695176.251644000000000000 ; 000000732825622.523219000000000000 ] >									
365 	//        < 0x00000000000000000000000000000000000000000000000000439620E45E3402 >									
366 	//     < RUSS_PFVI_II_metadata_line_38_____UPRECHISTENKA3_3319C1_MOS_RUS_VIII_20231101 >									
367 	//        < MIlKQ385M8R9nMIPEnq1101zO2zCZV52RK81NoqyL3sei3tOuZhTo1ALT59euFVn >									
368 	//        <  u =="0.000000000000000001" : ] 000000732825622.523219000000000000 ; 000000752653809.966159000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000045E340247C7565 >									
370 	//     < RUSS_PFVI_II_metadata_line_39_____UPRECHISTENKA3_3319C1_MOS_RUS_IX_20231101 >									
371 	//        < Vlkp9o73S9d1ox0OzidMvdZ83EXgWIWZ3L701Gb66l60zv8iU7FsaRuKMo5tIUOK >									
372 	//        <  u =="0.000000000000000001" : ] 000000752653809.966159000000000000 ; 000000776488818.223982000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000047C75654A0D3F2 >									
374 	//     < RUSS_PFVI_II_metadata_line_40_____UPRECHISTENKA3_3319C1_MOS_RUS_X_20231101 >									
375 	//        < ZB07LwGCzwiibeR4AvbG34GL53v9778f47Q1v4lq1o8a7VY8l9T5lmQkk72aK6qt >									
376 	//        <  u =="0.000000000000000001" : ] 000000776488818.223982000000000000 ; 000000798915299.627427000000000000 ] >									
377 	//        < 0x000000000000000000000000000000000000000000000000004A0D3F24C30C4A >									
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