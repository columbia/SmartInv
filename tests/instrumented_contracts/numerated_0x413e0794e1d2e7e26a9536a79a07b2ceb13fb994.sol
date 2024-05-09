1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	SHERE_PFII_II_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	SHERE_PFII_II_883		"	;
8 		string	public		symbol =	"	SHERE_PFII_II_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1219985648835240000000000000					;	
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
92 	//     < SHERE_PFII_II_metadata_line_1_____JSC 121 ARP_20240505 >									
93 	//        < 0aruj97YAF2e3EoE3s8pmetPHdH2J66gVGUUtcOWWS8345a5x0VZMEEm8tGH37U5 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000025562998.449556700000000000 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000000027018C >									
96 	//     < SHERE_PFII_II_metadata_line_2_____JSC 123 ARP_20240505 >									
97 	//        < 28g2A4f4L76Y9MHR0chQqg3U0whNv3yP41la2826nvV65fn4Z647aQ4IqDFqlq4R >									
98 	//        <  u =="0.000000000000000001" : ] 000000025562998.449556700000000000 ; 000000068933831.349029200000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000027018C692F47 >									
100 	//     < SHERE_PFII_II_metadata_line_3_____JSC 360 ARP_20240505 >									
101 	//        < Qj8862lcO9IBZc04EPKlw63C2chD3ELlWgZqJ6eGc6LOeq8t916fFa778Y3dehb5 >									
102 	//        <  u =="0.000000000000000001" : ] 000000068933831.349029200000000000 ; 000000118728290.796318000000000000 ] >									
103 	//        < 0x0000000000000000000000000000000000000000000000000000692F47B52A3D >									
104 	//     < SHERE_PFII_II_metadata_line_4_____JSC “514 ARZ”_20240505 >									
105 	//        < 4M0QMmn0B69511BY5nJ9D93LK6ehCN9zMeXpw2m77r75Sxw72L7PITm87dJc6vve >									
106 	//        <  u =="0.000000000000000001" : ] 000000118728290.796318000000000000 ; 000000155997644.860726000000000000 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000000000B52A3DEE0894 >									
108 	//     < SHERE_PFII_II_metadata_line_5_____JSC “170 RZ SOP”_20240505 >									
109 	//        < pe4L9SyGp606Qmzki3U20S2p13c1g7Tr1F2n8x0X0SVJVbm1f438A1ZsfU28X5cY >									
110 	//        <  u =="0.000000000000000001" : ] 000000155997644.860726000000000000 ; 000000176385632.848637000000000000 ] >									
111 	//        < 0x000000000000000000000000000000000000000000000000000EE089410D24A3 >									
112 	//     < SHERE_PFII_II_metadata_line_6_____JSC “31 ZATO”_20240505 >									
113 	//        < 0a7X7V43r24360DSmgr33l5N9e8wF68Zng0q28BSFuke1pCdl5pZmc1T5Pz2Axrx >									
114 	//        <  u =="0.000000000000000001" : ] 000000176385632.848637000000000000 ; 000000200192911.645763000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000010D24A3131785B >									
116 	//     < SHERE_PFII_II_metadata_line_7_____JSC “32 RZ SOP”_20240505 >									
117 	//        < QIr6wBDP87s1Xbp8f5t5dFCC9ojF8G0o15Oa0Yjn8S1lyLSUnhWz0fAlzKCvQAZB >									
118 	//        <  u =="0.000000000000000001" : ] 000000200192911.645763000000000000 ; 000000244881080.552978000000000000 ] >									
119 	//        < 0x00000000000000000000000000000000000000000000000000131785B175A8AC >									
120 	//     < SHERE_PFII_II_metadata_line_8_____JSC “680 ARZ”_20240505 >									
121 	//        < T1uoTn4nVa1h4q3KV9j6izvGa6aI8ex3c7uN4J756iAA1db9OxX9T0E2GOMm9QB5 >									
122 	//        <  u =="0.000000000000000001" : ] 000000244881080.552978000000000000 ; 000000262264713.779050000000000000 ] >									
123 	//        < 0x00000000000000000000000000000000000000000000000000175A8AC1902F27 >									
124 	//     < SHERE_PFII_II_metadata_line_9_____JSC “720 RZ SOP”_20240505 >									
125 	//        < PC0b433nclqw8P8IfgXVPzzw82w4gJ2BTJha31e9LZq1akeNG4RfD0ivd0MSN3vT >									
126 	//        <  u =="0.000000000000000001" : ] 000000262264713.779050000000000000 ; 000000306835350.339091000000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000001902F271D4318F >									
128 	//     < SHERE_PFII_II_metadata_line_10_____JSC “VZ RTO”_20240505 >									
129 	//        < 2k8Z3nul03Jd15N3jX4ir6kKKJcDfS2aOV3Kl86eJ84468tk6DZuChPr6wZfx9T3 >									
130 	//        <  u =="0.000000000000000001" : ] 000000306835350.339091000000000000 ; 000000329355956.385448000000000000 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000000001D4318F1F68EAC >									
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
174 	//     < SHERE_PFII_II_metadata_line_11_____JSC “20 ARZ”_20240505 >									
175 	//        < CPq02z214r0XRC795qd3sV49WpPDk0kI9Nv9PW86GuxIM01moswkT4Rm26rmaI3H >									
176 	//        <  u =="0.000000000000000001" : ] 000000329355956.385448000000000000 ; 000000347197797.535396000000000000 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000000001F68EAC211C824 >									
178 	//     < SHERE_PFII_II_metadata_line_12_____JSC “275 ARZ”_20240505 >									
179 	//        < D82erZ8D9h2M3Dc3Tr5ObjGvQfz2v1rjqj0x8JqmVNLb3bnDwxmuIYtf12Ho7BTc >									
180 	//        <  u =="0.000000000000000001" : ] 000000347197797.535396000000000000 ; 000000376284308.159930000000000000 ] >									
181 	//        < 0x00000000000000000000000000000000000000000000000000211C82423E2A0F >									
182 	//     < SHERE_PFII_II_metadata_line_13_____JSC 308 ARP_20240505 >									
183 	//        < TTjP4p5WMkHlH4AQabo6bC86ACVQD7g3ue8hqi3HsVOXLXL51pufDZJ2HUUbCK0h >									
184 	//        <  u =="0.000000000000000001" : ] 000000376284308.159930000000000000 ; 000000420092105.850061000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000023E2A0F281027B >									
186 	//     < SHERE_PFII_II_metadata_line_14_____JSC “322 ARZ”_20240505 >									
187 	//        < 4F6GhV4fUDrDC9QPXu5A6roJ8o97vh3dEQggpfSstrn95A1xg0bOTr56bJe47j3v >									
188 	//        <  u =="0.000000000000000001" : ] 000000420092105.850061000000000000 ; 000000448409942.668014000000000000 ] >									
189 	//        < 0x00000000000000000000000000000000000000000000000000281027B2AC3822 >									
190 	//     < SHERE_PFII_II_metadata_line_15_____JSC “325 ARZ”_20240505 >									
191 	//        < iHA1Lzt9C3S8zp21k5x06g0n29fX9IGv8PHrPG10HX983Y3rTUbFJSzzE29947h1 >									
192 	//        <  u =="0.000000000000000001" : ] 000000448409942.668014000000000000 ; 000000465858902.832961000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000002AC38222C6D822 >									
194 	//     < SHERE_PFII_II_metadata_line_16_____JSC 121 ARP_INFRA_20240505 >									
195 	//        < i1eVb09RuT9O27bm9FN8Ie6r800WNhh5PX476Ih5OPL5fllT6gyKPOLls79WdlZ2 >									
196 	//        <  u =="0.000000000000000001" : ] 000000465858902.832961000000000000 ; 000000498135995.606262000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000002C6D8222F81860 >									
198 	//     < SHERE_PFII_II_metadata_line_17_____JSC 123 ARP_INFRA_20240505 >									
199 	//        < HmC1ePN6f1A706cZDyvfCoCd2KK8KY03fjRTxiUg3j609Wk4p8S2H4urKhvMtz4t >									
200 	//        <  u =="0.000000000000000001" : ] 000000498135995.606262000000000000 ; 000000540306164.223153000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000002F818603387118 >									
202 	//     < SHERE_PFII_II_metadata_line_18_____JSC 360 ARP_INFRA_20240505 >									
203 	//        < wlgWOl7n23Eb3pXjdk61L8GiV7G7hJ2kJl7SntHo223a175t8Tkft1cL8Y0EXA3A >									
204 	//        <  u =="0.000000000000000001" : ] 000000540306164.223153000000000000 ; 000000564099676.499141000000000000 ] >									
205 	//        < 0x00000000000000000000000000000000000000000000000000338711835CBF70 >									
206 	//     < SHERE_PFII_II_metadata_line_19_____JSC “514 ARZ”_INFRA_20240505 >									
207 	//        < o4YdqzT9b9xSvEn1DDu0Rdv03h2V0Y596902B5pM85b96T5cb5rQl4M4YRn4vQ9b >									
208 	//        <  u =="0.000000000000000001" : ] 000000564099676.499141000000000000 ; 000000579655629.058521000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000000035CBF703747BFB >									
210 	//     < SHERE_PFII_II_metadata_line_20_____JSC “170 RZ SOP”_INFRA_20240505 >									
211 	//        < aZa00n382h6l2GXNAbm7Mmhbb7Fd5579APyVF94nT8sR695CEVP2cCSKN6VZ3HN6 >									
212 	//        <  u =="0.000000000000000001" : ] 000000579655629.058521000000000000 ; 000000595179287.397346000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000003747BFB38C2BE9 >									
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
256 	//     < SHERE_PFII_II_metadata_line_21_____JSC “31 ZATO”_INFRA_20240505 >									
257 	//        < SQD9A025Teb2ZMO45Yj4CC74Q4209bzyvNZgXjERkf6y1ZJu7Y8pFbv149g81AQm >									
258 	//        <  u =="0.000000000000000001" : ] 000000595179287.397346000000000000 ; 000000611342338.448374000000000000 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000000038C2BE93A4D59A >									
260 	//     < SHERE_PFII_II_metadata_line_22_____JSC “32 RZ SOP”_INFRA_20240505 >									
261 	//        < VjsL5af9eWa286s0Rwrf9aPI1TACjVUkRR34vwTz2Qx0bH42I8xfsvZOuFt7ZHGw >									
262 	//        <  u =="0.000000000000000001" : ] 000000611342338.448374000000000000 ; 000000649136919.097285000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000003A4D59A3DE811C >									
264 	//     < SHERE_PFII_II_metadata_line_23_____JSC “680 ARZ”_INFRA_20240505 >									
265 	//        < 1WIxuuOEwTVr04cwu8kBjyV2H7By28PLX51IMAbkZH60Ah4pe0UIrwmn9s228Ib1 >									
266 	//        <  u =="0.000000000000000001" : ] 000000649136919.097285000000000000 ; 000000665649979.832571000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000003DE811C3F7B386 >									
268 	//     < SHERE_PFII_II_metadata_line_24_____JSC “720 RZ SOP”_INFRA_20240505 >									
269 	//        < 17t1YW92VqyF1nrQ5Qy08438eTuM040IMHQdu3fRKPLz9IXBQLfflwr3srk8mZ7d >									
270 	//        <  u =="0.000000000000000001" : ] 000000665649979.832571000000000000 ; 000000714124224.905493000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000003F7B386441AAC6 >									
272 	//     < SHERE_PFII_II_metadata_line_25_____JSC “VZ RTO”_INFRA_20240505 >									
273 	//        < RZQ4Cn64bglL4Y9WG0fKF1Lbp9676M3G64I002WrW6GYaj9i96ML8o1dhy2Gzh5g >									
274 	//        <  u =="0.000000000000000001" : ] 000000714124224.905493000000000000 ; 000000750698508.885917000000000000 ] >									
275 	//        < 0x00000000000000000000000000000000000000000000000000441AAC6479799B >									
276 	//     < SHERE_PFII_II_metadata_line_26_____JSC “20 ARZ”_INFRA_20240505 >									
277 	//        < 6KrWTD7u46Dm917gkH085Sx398G6cLB1c2Z1H0Z81x1g1gB1A48S8Uu32cB1Nmra >									
278 	//        <  u =="0.000000000000000001" : ] 000000750698508.885917000000000000 ; 000000787358629.274837000000000000 ] >									
279 	//        < 0x00000000000000000000000000000000000000000000000000479799B4B169F7 >									
280 	//     < SHERE_PFII_II_metadata_line_27_____JSC “275 ARZ”_INFRA_20240505 >									
281 	//        < 0yO4005q20wJJm7zb7UkYi69d1J8L26s9jTj523G12nv4plUhofxc1hUipA6WOM8 >									
282 	//        <  u =="0.000000000000000001" : ] 000000787358629.274837000000000000 ; 000000823056023.085831000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000004B169F74E7E242 >									
284 	//     < SHERE_PFII_II_metadata_line_28_____JSC 308 ARP_INFRA_20240505 >									
285 	//        < 5QV3UrYg5Z605dZ5XDuy31aqPBVtR45k27A7xXg6NhgiDXbB2rg18F2mrHGv0IZK >									
286 	//        <  u =="0.000000000000000001" : ] 000000823056023.085831000000000000 ; 000000856923714.163483000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000004E7E24251B8FD3 >									
288 	//     < SHERE_PFII_II_metadata_line_29_____JSC “322 ARZ”_INFRA_20240505 >									
289 	//        < plwSDwa0Yn1oXCF58A5KnJxxadP1vA5d2P3K9guV942Yy2dNO1L2X39sTFpGhfSn >									
290 	//        <  u =="0.000000000000000001" : ] 000000856923714.163483000000000000 ; 000000882088878.513473000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000051B8FD3541F5F8 >									
292 	//     < SHERE_PFII_II_metadata_line_30_____JSC “325 ARZ”_INFRA_20240505 >									
293 	//        < 6Ks1j2p0o99286sst2fzy3oHlDa8ph522O9815I48z0I389smT7cHNne66bkUofL >									
294 	//        <  u =="0.000000000000000001" : ] 000000882088878.513473000000000000 ; 000000923905062.269043000000000000 ] >									
295 	//        < 0x00000000000000000000000000000000000000000000000000541F5F8581C46A >									
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
338 	//     < SHERE_PFII_II_metadata_line_31_____JSC 121 ARP_ORG_20240505 >									
339 	//        < 5w8tT6233222Bw56Rowwu04ZoGe1vKapOfVk2TPyia3ywHlvl628QPIySp2MArXR >									
340 	//        <  u =="0.000000000000000001" : ] 000000923905062.269043000000000000 ; 000000943213241.901504000000000000 ] >									
341 	//        < 0x00000000000000000000000000000000000000000000000000581C46A59F3AAC >									
342 	//     < SHERE_PFII_II_metadata_line_32_____JSC 123 ARP_ORG_20240505 >									
343 	//        < RZjNHAzCtMqlCta77jQ3u2ERX7VKh3vfRr3bx1uIkQGwg8w546f63AINqU8uQtj3 >									
344 	//        <  u =="0.000000000000000001" : ] 000000943213241.901504000000000000 ; 000000970343802.635927000000000000 ] >									
345 	//        < 0x0000000000000000000000000000000000000000000000000059F3AAC5C8A08C >									
346 	//     < SHERE_PFII_II_metadata_line_33_____JSC 360 ARP_ORG_20240505 >									
347 	//        < ow4D1XQ74415028YthEpKZ5WVJYUrvgRHC5i57mcq5mxEIwiUyRS70bF2U2pX5PC >									
348 	//        <  u =="0.000000000000000001" : ] 000000970343802.635927000000000000 ; 000000997836369.857872000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000005C8A08C5F293D5 >									
350 	//     < SHERE_PFII_II_metadata_line_34_____JSC “514 ARZ”_ORG_20240505 >									
351 	//        < 5i7kcEo798p8zjUFNIJyoWxfL3llsP6h35VqLbQFw554B3O3PLFO6U972mIIQ32k >									
352 	//        <  u =="0.000000000000000001" : ] 000000997836369.857872000000000000 ; 000001032600030.069940000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000005F293D56279F63 >									
354 	//     < SHERE_PFII_II_metadata_line_35_____JSC “170 RZ SOP”_ORG_20240505 >									
355 	//        < z4dOWpyD9jLGph88AK0ztNkv1Y1k4if09cUbfsjITcF33854tB3z3MMD741POF0D >									
356 	//        <  u =="0.000000000000000001" : ] 000001032600030.069940000000000000 ; 000001055640245.948120000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000006279F6364AC779 >									
358 	//     < SHERE_PFII_II_metadata_line_36_____JSC “31 ZATO”_ORG_20240505 >									
359 	//        < 144pdRcKKXr06GMr2buz5UgRv4CyP046pFLkQdr7bYwUuhiZ17GIE089t74WA27a >									
360 	//        <  u =="0.000000000000000001" : ] 000001055640245.948120000000000000 ; 000001091309606.865610000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000064AC77968134D1 >									
362 	//     < SHERE_PFII_II_metadata_line_37_____JSC “32 RZ SOP”_ORG_20240505 >									
363 	//        < 1112373949MK1H2USX3WMoAUPIQKlk22LoA26f5rC4ba1ly6MMK7Te9L0284Eq8f >									
364 	//        <  u =="0.000000000000000001" : ] 000001091309606.865610000000000000 ; 000001128428715.991780000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000068134D16B9D878 >									
366 	//     < SHERE_PFII_II_metadata_line_38_____JSC “680 ARZ”_ORG_20240505 >									
367 	//        < mT2YF6H9M4Yz5M33Da5UC5D2BKGiV25EmsxD5FBcvMsRRftAztX300zX0oHbaEpf >									
368 	//        <  u =="0.000000000000000001" : ] 000001128428715.991780000000000000 ; 000001155285331.771060000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000006B9D8786E2D355 >									
370 	//     < SHERE_PFII_II_metadata_line_39_____JSC “720 RZ SOP”_ORG_20240505 >									
371 	//        < 42K06GZig9GCDUy4998Y7BM69R48uenKSa17M55J0Y6kh80Ry0zQJ2H2n6yUQX21 >									
372 	//        <  u =="0.000000000000000001" : ] 000001155285331.771060000000000000 ; 000001180558684.930330000000000000 ] >									
373 	//        < 0x000000000000000000000000000000000000000000000000006E2D35570963BC >									
374 	//     < SHERE_PFII_II_metadata_line_40_____JSC “VZ RTO”_ORG_20240505 >									
375 	//        < iGIgX28Uu2Yr7T6NquNmOaQjcjPGkj801034CvJaP5kMg81cTgb0hJDZgJ6NnIar >									
376 	//        <  u =="0.000000000000000001" : ] 000001180558684.930330000000000000 ; 000001219985648.835240000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000070963BC7458CE5 >									
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