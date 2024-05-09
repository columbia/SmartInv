1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	FGRE_Portfolio_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	FGRE_Portfolio_III_883		"	;
8 		string	public		symbol =	"	FGRE883III		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		26619797430723400000000000000					;	
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
92 	//     < FGRE_Portfolio_III_metadata_line_1_____Caisse_Centrale_de_Reassurance_20580515 >									
93 	//        < VMuKyB9YtJi0Q9l1ME3eR2YuzummH9UmNvqq7p9Zwm3puu9Ia562JTGUD7zMQ8AA >									
94 	//        < 1E-018 limites [ 1E-018 ; 1798005141,81932 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000000AB789C2 >									
96 	//     < FGRE_Portfolio_III_metadata_line_2_____CCR_FGRE_Fonds_de_Garantie_des_Risques_liés_a_l_Epandage_des_Boues_d_Epuration_Urbaines_et_Industrielles_20580515 >									
97 	//        < m0XE20rXgPDVF8039lWgGKnb9Kl7vD1asuK5bS8T2fWb584P6EyKzl0QNqh9r9lD >									
98 	//        < 1E-018 limites [ 1798005141,81932 ; 2064548711,07528 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000AB789C2C4E4057 >									
100 	//     < FGRE_Portfolio_III_metadata_line_3_____CCR_FGRE_IDX_ZONE_57410_57410_57412_10_01_20580515 >									
101 	//        < J6XxmZ3LF8biukPV0mDV6AD6Y9t59VlI489m92t6x6ldf50x5YFCQTVUyiLB98eB >									
102 	//        < 1E-018 limites [ 2064548711,07528 ; 2240313178,26478 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000C4E4057D5A7256 >									
104 	//     < FGRE_Portfolio_III_metadata_line_4_____CCR_FGRE_IDX_ZONE_57410_57410_57412_10_02_20580515 >									
105 	//        < WAkfxtQXI1R6TR37lwl8A9WXVYb7SJ0hYTVz92YohZacQcwmy73y23MN6BW1K3fK >									
106 	//        < 1E-018 limites [ 2240313178,26478 ; 4002480171,36732 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000000D5A725617DB4CD1 >									
108 	//     < FGRE_Portfolio_III_metadata_line_5_____CCR_FGRE_IDX_ZONE_57410_57410_57412_10_03_20580515 >									
109 	//        < V9m1C22jY1lntBTIMQxrQKv9bLBvF1ZoGQ9Je5Bv3I4Lsoe5XB6M9Kj0wn88M025 >									
110 	//        < 1E-018 limites [ 4002480171,36732 ; 4082875147,90688 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000017DB4CD11855F91B >									
112 	//     < FGRE_Portfolio_III_metadata_line_6_____CCR_FGRE_IDX_ZONE_57410_57410_57412_10_04_20580515 >									
113 	//        < wr475Vj0LlYY2ZxK6Btw4j978VgHrWrEC13g790vy6qBFj8jR5BA1wks99k1k8hV >									
114 	//        < 1E-018 limites [ 4082875147,90688 ; 4354066048,28292 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000001855F91B19F3C70D >									
116 	//     < FGRE_Portfolio_III_metadata_line_7_____CCR_FGRE_IDX_ZONE_57410_57410_57412_10_05_20580515 >									
117 	//        < Ha89YKhucEB55qOnG4s20Cd7rQA0VtZgx8VSRHP5w2FB7WzZMLU1zW5hvo9V31S3 >									
118 	//        < 1E-018 limites [ 4354066048,28292 ; 4533966252,41138 ] >									
119 	//        < 0x00000000000000000000000000000000000000000000000019F3C70D1B064891 >									
120 	//     < FGRE_Portfolio_III_metadata_line_8_____CCR_FGRE_IDX_ZONE_57410_57410_57412_10_06_20580515 >									
121 	//        < vPRIZEA0GQVwWhlSHyEJIBKClLr21D99YA607ZtKAhT02geM26H946uBc7CKcT60 >									
122 	//        < 1E-018 limites [ 4533966252,41138 ; 4827440063,51674 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000001B0648911CC616C6 >									
124 	//     < FGRE_Portfolio_III_metadata_line_9_____CCR_FGRE_IDX_ZONE_57410_57410_57412_10_07_20580515 >									
125 	//        < H6e4KpJeQbkgg5Y8L297903S34yUnVJ9VD9p19750ocwPn1LyRF464CY3dx2SGd6 >									
126 	//        < 1E-018 limites [ 4827440063,51674 ; 4951027942,36309 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000001CC616C61D82AB4A >									
128 	//     < FGRE_Portfolio_III_metadata_line_10_____CCR_FGRE_IDX_ZONE_57410_57410_57412_10_08_20580515 >									
129 	//        < 1U34yk2HwJb1f16xyd2z6sgt5E1y5XYlRJUKwfWKxN61g5aLAqHuB93mkS93NfTd >									
130 	//        < 1E-018 limites [ 4951027942,36309 ; 5420463977,60449 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000001D82AB4A204EF8BE >									
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
174 	//     < FGRE_Portfolio_III_metadata_line_11_____CCR_FGRE_IDX_ZONE_57410_57410_57412_10_09_20580515 >									
175 	//        < 5Ij16Xs9SDhNdEj6H6nAZWtq5OqyChd3p6KfXC42L44m290S6032QJ1633iTxAAX >									
176 	//        < 1E-018 limites [ 5420463977,60449 ; 5668663249,8329 ] >									
177 	//        < 0x000000000000000000000000000000000000000000000000204EF8BE21C9B195 >									
178 	//     < FGRE_Portfolio_III_metadata_line_12_____CCR_FGRE_IDX_ZONE_57410_57410_57412_10_10_20580515 >									
179 	//        < 6s4Lc4aW1z0w29w2MPF9WY065M0WG6bIT583q53301A9C5EYm5Vlj4w9V690brq3 >									
180 	//        < 1E-018 limites [ 5668663249,8329 ; 6827545815,83845 ] >									
181 	//        < 0x00000000000000000000000000000000000000000000000021C9B19528B20216 >									
182 	//     < FGRE_Portfolio_III_metadata_line_13_____CCR_FGRE_IDX_ZONE_57410_57410_57412_10_11_20580515 >									
183 	//        < 0Xf5IT0I2h53013423Zn9bt8Y108XHj450xdZCch2NWM27SP55xhBu0AZH8vBqwN >									
184 	//        < 1E-018 limites [ 6827545815,83845 ; 7344128542,76922 ] >									
185 	//        < 0x00000000000000000000000000000000000000000000000028B202162BC64036 >									
186 	//     < FGRE_Portfolio_III_metadata_line_14_____CCR_FGRE_IDX_ZONE_57410_57410_57412_10_12_20580515 >									
187 	//        < KfcF5QBUqCDY065TNNuuS7092Ya1iC8lHDq4MR8Vidw1gSQ5I1v2m87cWmQhjXIc >									
188 	//        < 1E-018 limites [ 7344128542,76922 ; 7918577398,25259 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000002BC640362F32CA4C >									
190 	//     < FGRE_Portfolio_III_metadata_line_15_____CCR_FGRE_IDX_ZONE_57410_57410_57412_10_13_20580515 >									
191 	//        < KDWZ8qFGgSJ8A9Op13W13FspTRN9R3Cwh1Ft2NmVS50D7K9CkWtV5K4jFUlUNS5D >									
192 	//        < 1E-018 limites [ 7918577398,25259 ; 8019770428,18954 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000002F32CA4C2FCD32D3 >									
194 	//     < FGRE_Portfolio_III_metadata_line_16_____CCR_FGRE_IDX_ZONE_57410_57410_57412_10_14_20580515 >									
195 	//        < Ua394KR92F59H93RZaiwI95yF19tFJ849Cth0283nlTPgu272nm7Qg75Xi96CinQ >									
196 	//        < 1E-018 limites [ 8019770428,18954 ; 8108368732,11049 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000002FCD32D330546389 >									
198 	//     < FGRE_Portfolio_III_metadata_line_17_____CCR_FGRE_IDX_ZONE_57410_57410_57412_10_15_20580515 >									
199 	//        < 78lbR9j895ZC5a3y2Z04Kj6Wr8s9Ei7236CxET485ODpmvSyIA7Q27SnM2S8PHa2 >									
200 	//        < 1E-018 limites [ 8108368732,11049 ; 8321175819,89188 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000003054638931991B4E >									
202 	//     < FGRE_Portfolio_III_metadata_line_18_____CCR_FGRE_IDX_ZONE_57410_57410_57412_10_16_20580515 >									
203 	//        < NNR1l77QKQ3a5tEaUxAK26A78Kzfp7AJ2Nqo51u3ak7M83H27shgv32myO5Rb96c >									
204 	//        < 1E-018 limites [ 8321175819,89188 ; 9867062217,39601 ] >									
205 	//        < 0x00000000000000000000000000000000000000000000000031991B4E3ACFF12E >									
206 	//     < FGRE_Portfolio_III_metadata_line_19_____CCR_FGRE_IDX_ZONE_57410_57410_57412_10_17_20580515 >									
207 	//        < M66hG0YE17b5Lh9nNXF2lKHCbI731UT0LPcjN9AsYlyKrg8qKCj6xQ4wN9pMUPC3 >									
208 	//        < 1E-018 limites [ 9867062217,39601 ; 12054254264,0458 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000003ACFF12E47D95512 >									
210 	//     < FGRE_Portfolio_III_metadata_line_20_____CCR_FGRE_IDX_ZONE_57410_57410_57412_10_18_20580515 >									
211 	//        < F6dTcYF54mvh2956T5EIH2Ky6Ih06T32zb875MYdnfshf8fqZqym7mhu5WnENwWp >									
212 	//        < 1E-018 limites [ 12054254264,0458 ; 12141416461,2354 ] >									
213 	//        < 0x00000000000000000000000000000000000000000000000047D95512485E54CE >									
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
256 	//     < FGRE_Portfolio_III_metadata_line_21_____CCR_FGRE_IDX_ZONE_57410_57410_57412_10_19_20580515 >									
257 	//        < eOyuDPM281HA1XhXx1yCqc0Y6OhBs054QLI2955sTi5E7ptbM694FiR7x5t2c2I8 >									
258 	//        < 1E-018 limites [ 12141416461,2354 ; 12645420577,3433 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000485E54CE4B5F616A >									
260 	//     < FGRE_Portfolio_III_metadata_line_22_____CCR_FGRE_IDX_ZONE_57410_57410_57412_10_20_20580515 >									
261 	//        < TYwWeH83E6rxuvUocRf9E5q8VTdgY4x4ocOHHO1bnH0C7dgZ5w932hmoY8suSgy6 >									
262 	//        < 1E-018 limites [ 12645420577,3433 ; 14734424601,0189 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000004B5F616A57D2F29C >									
264 	//     < FGRE_Portfolio_III_metadata_line_23_____CCR_FGRE_IDX_ZONE_57410_57410_57412_10_21_20580515 >									
265 	//        < W53PMp8Y93v30g45ALoI4DpK7ba7BJl8Tzm1gOfswHV626i1X2PR623d2L2o3186 >									
266 	//        < 1E-018 limites [ 14734424601,0189 ; 15323220564,2654 ] >									
267 	//        < 0x00000000000000000000000000000000000000000000000057D2F29C5B556108 >									
268 	//     < FGRE_Portfolio_III_metadata_line_24_____CCR_FGRE_IDX_ZONE_57410_57410_57412_10_22_20580515 >									
269 	//        < cKo9tYddqTANR67KA7ceZ4YnxG4LCC1zznaPGhOSWDIKVtnLpmytl2qe0lubYWBy >									
270 	//        < 1E-018 limites [ 15323220564,2654 ; 18048476167,4493 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000005B5561086B93CA01 >									
272 	//     < FGRE_Portfolio_III_metadata_line_25_____CCR_FGRE_IDX_ZONE_57410_57410_57412_10_23_20580515 >									
273 	//        < ARq6s5h04o64kC8F20tt6z62Pne12SLrc5LW813VYnDR18j1xZ8BhZQ8G3886tW0 >									
274 	//        < 1E-018 limites [ 18048476167,4493 ; 18161194680,6008 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000000006B93CA016C3FC8AC >									
276 	//     < FGRE_Portfolio_III_metadata_line_26_____CCR_FGRE_IDX_ZONE_57510_57510_6_67_20580515 >									
277 	//        < 39VR81X7YG5uQQHaLWOFo1QpGsi6vbay2m219Z0fl7lWmUD4JaJ7KMw9O3BA3I99 >									
278 	//        < 1E-018 limites [ 18161194680,6008 ; 18263154726,7917 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000000006C3FC8AC6CDB5CD1 >									
280 	//     < FGRE_Portfolio_III_metadata_line_27_____CCR_FGRE_IDX_ZONE_57510_57510_6_68_20580515 >									
281 	//        < DwiiqfzKVLCMlNSFtt26R4mu5e6FRQ1kPh0CX4utPH6CwiWhkRw8GGDQZ2M2LysC >									
282 	//        < 1E-018 limites [ 18263154726,7917 ; 18474505984,281 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000006CDB5CD16E1DDBE6 >									
284 	//     < FGRE_Portfolio_III_metadata_line_28_____CCR_FGRE_IDX_ZONE_57510_57510_6_70_20580515 >									
285 	//        < 25I3IDj6Sw2ziN6zs8Fkh48jgre195Ha1YUfLREcUV8d77yDJ43qD1K5AyJJ07wa >									
286 	//        < 1E-018 limites [ 18474505984,281 ; 20395406096,4228 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000006E1DDBE67990EB82 >									
288 	//     < FGRE_Portfolio_III_metadata_line_29_____CCR_FGRE_IDX_ZONE_57510_57510_6_77_20580515 >									
289 	//        < 8fetqrf8O8BZwYwEhaW0SFx64h4MV811AbYktPUDkrmtJo7s72Z05od280IpX42s >									
290 	//        < 1E-018 limites [ 20395406096,4228 ; 20507443966,6689 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000007990EB827A3BE04D >									
292 	//     < FGRE_Portfolio_III_metadata_line_30_____CCR_FGRE_IDX_ZONE_57510_57510_6_78_20580515 >									
293 	//        < QuxbipSjNe1AHeop98u6bB7ySu7Bf4Tu3sQy1vzeCWaJV7Gu0783vPytIHJl7qnK >									
294 	//        < 1E-018 limites [ 20507443966,6689 ; 21459120893,5742 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000007A3BE04D7FE80519 >									
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
338 	//     < FGRE_Portfolio_III_metadata_line_31_____CCR_FGRE_IDX_ZONE_57510_57510_6_79_20580515 >									
339 	//        < QD63EYIo8YVSCyYR1504fwbeBrTU99I8EcT02CmP8LXqv2947UgVe86m3F7g9jkf >									
340 	//        < 1E-018 limites [ 21459120893,5742 ; 21868767891,7741 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000000007FE8051982591775 >									
342 	//     < FGRE_Portfolio_III_metadata_line_32_____CCR_FGRE_IDX_ZONE_57660_18_1_20580515 >									
343 	//        < d53R50s9udA8Lto1ksfNh488Cf0jng90ok9T37o973P79vZID0M6EPZ7wR3AApTh >									
344 	//        < 1E-018 limites [ 21868767891,7741 ; 21968088546,7113 ] >									
345 	//        < 0x0000000000000000000000000000000000000000000000008259177582F0A497 >									
346 	//     < FGRE_Portfolio_III_metadata_line_33_____CCR_FGRE_IDX_ZONE_57660_18_2_20580515 >									
347 	//        < 7V3ZpPmgRV0oS55b5Y28W4JhHA0GA1WnvW5RDJD38Z02KmK1BHjLW6P28619ocBf >									
348 	//        < 1E-018 limites [ 21968088546,7113 ; 22099500120,6173 ] >									
349 	//        < 0x00000000000000000000000000000000000000000000000082F0A49783B9293C >									
350 	//     < FGRE_Portfolio_III_metadata_line_34_____CCR_FGRE_IDX_ZONE_57660_18_3_20580515 >									
351 	//        < U5NPRanjKsma2s827aC0Al9Kh84j8JtYy0b1o9Pw7s6WzKv4VT4BoB5O6Y460Fs1 >									
352 	//        < 1E-018 limites [ 22099500120,6173 ; 22403905409,0278 ] >									
353 	//        < 0x00000000000000000000000000000000000000000000000083B9293C8589A58D >									
354 	//     < FGRE_Portfolio_III_metadata_line_35_____CCR_FGRE_IDX_ZONE_57660_18_4_20580515 >									
355 	//        < ym0gBvmaqSVxiozdJ8q78t05xWlKkKAnDY4oq3ZgwUCsUW1kWYhtB4HjiCFJiO0W >									
356 	//        < 1E-018 limites [ 22403905409,0278 ; 22808944800,977 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000008589A58D87F3B010 >									
358 	//     < FGRE_Portfolio_III_metadata_line_36_____CCR_FGRE_IDX_ZONE_57660_18_5_20580515 >									
359 	//        < qOyZmtkLL6825CQ04j0D5cpxpnj35PWmsbckSt5WBaMKWOY8IvGdFhT2924WpBUX >									
360 	//        < 1E-018 limites [ 22808944800,977 ;  ] >									
361 	//        < 0x00000000000000000000000000000000000000000000000087F3B01089601547 >									
362 	//     < FGRE_Portfolio_III_metadata_line_37_____CCR_FGRE_IDX_ZONE_57660_18_6_20580515 >									
363 	//        < F0R0Y97S6kvz6cKruL7XkSd46Bz0qU4zN52I0oNOM3f6R38869O183Bg93DsS564 >									
364 	//        < 1E-018 limites [ 23047754952,0116 ; 24522859198,0236 ] >									
365 	//        < 0x00000000000000000000000000000000000000000000000089601547922AE9E0 >									
366 	//     < FGRE_Portfolio_III_metadata_line_38_____CCR_FGRE_IDX_ZONE_57660_18_7_20580515 >									
367 	//        < d238QoI3394Fy3vTv44z4ZtUc7qXofu1KZjr83BM35O5K383oHU5cgtJdIM28y2c >									
368 	//        < 1E-018 limites [ 24522859198,0236 ; 24692011003,9209 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000922AE9E0932D04CC >									
370 	//     < FGRE_Portfolio_III_metadata_line_39_____CCR_FGRE_IDX_ZONE_57660_18_8_20580515 >									
371 	//        < 146U40SOT2N2Ugw4eLVL48x6f69DZGS7Q5K60VziHRZCP29Dd5Hgt4Xxm2RL3sNr >									
372 	//        < 1E-018 limites [ 24692011003,9209 ; 25027901043,2037 ] >									
373 	//        < 0x000000000000000000000000000000000000000000000000932D04CC952D8BD8 >									
374 	//     < FGRE_Portfolio_III_metadata_line_40_____CCR_FGRE_IDX_ZONE_57660_18_9_20580515 >									
375 	//        < 11aq120KCKs0uySj8xLopPr7g1J9kbYTNy77Ebq0LNINB06S4jhExrRi2DR0E6DB >									
376 	//        < 1E-018 limites [ 25027901043,2037 ; 26619797430,7234 ] >									
377 	//        < 0x000000000000000000000000000000000000000000000000952D8BD89EAA965F >									
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