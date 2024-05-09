1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXIII_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXIII_I_883		"	;
8 		string	public		symbol =	"	RUSS_PFXIII_I_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		598283147326372000000000000					;	
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
92 	//     < RUSS_PFXIII_I_metadata_line_1_____NORILSK_NICKEL_20211101 >									
93 	//        < 6dBkpWcyj5H07cs6v6W29el8x4pL92L92Dat4b4cwlLfK6Eo4PE959uomS9813N6 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000016404288.082848400000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000001907ED >									
96 	//     < RUSS_PFXIII_I_metadata_line_2_____NORNICKEL_ORG_20211101 >									
97 	//        < 5Tc4H4lc5zi89126BXbU7HYg6JqR2RkAhYi3udDJ7eax868714A0y49uc4250676 >									
98 	//        <  u =="0.000000000000000001" : ] 000000016404288.082848400000000000 ; 000000032483306.854348100000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000001907ED3190CB >									
100 	//     < RUSS_PFXIII_I_metadata_line_3_____NORNICKEL_DAO_20211101 >									
101 	//        < R3UZlZ2z2WHJhH9imW2938GRtDnw3oUb11OjfnW6PZIJtQT2b02jv0iu437h2jaD >									
102 	//        <  u =="0.000000000000000001" : ] 000000032483306.854348100000000000 ; 000000045450339.878900800000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000003190CB455A0A >									
104 	//     < RUSS_PFXIII_I_metadata_line_4_____NORNICKEL_DAOPI_20211101 >									
105 	//        < at772YQ3OExLXv0r3k45q0CcmJtT1t30vRsv9R90g74UFU2p2OD82vq00K45j2Zx >									
106 	//        <  u =="0.000000000000000001" : ] 000000045450339.878900800000000000 ; 000000061368648.531532100000000000 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000000000455A0A5DA421 >									
108 	//     < RUSS_PFXIII_I_metadata_line_5_____NORNICKEL_PENSII_20211101 >									
109 	//        < UJFC990BPMp6tAL1kkqHBnasnykdCyFkz43Jsur0FA08fS22ylVRO90l4uo4eS6o >									
110 	//        <  u =="0.000000000000000001" : ] 000000061368648.531532100000000000 ; 000000075960738.411225100000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000005DA42173E82A >									
112 	//     < RUSS_PFXIII_I_metadata_line_6_____NORNICKEL_DAC_20211101 >									
113 	//        < YCLNXcoei4D36B4l86B9889E2VGtmR76EZ9qaG920h248ICgWBk32a6H2p3b09YJ >									
114 	//        <  u =="0.000000000000000001" : ] 000000075960738.411225100000000000 ; 000000090337423.643856100000000000 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000000000073E82A89D80E >									
116 	//     < RUSS_PFXIII_I_metadata_line_7_____NORNICKEL_BIMI_20211101 >									
117 	//        < 0X37b52LboQVw12wtOVSG6762GbRkPSvlSAEV01G8vfs4Y8frpe2AgC3p80G8K7L >									
118 	//        <  u =="0.000000000000000001" : ] 000000090337423.643856100000000000 ; 000000105786599.173532000000000000 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000000000089D80EA16AE4 >									
120 	//     < RUSS_PFXIII_I_metadata_line_8_____NORNICKEL_ALIANS_20211101 >									
121 	//        < kX3Vps5pxG63Gb3k9Hg0qf095k7m3gTnJGzqidLqPq752Bi9ox5K2ygna9Vajkh5 >									
122 	//        <  u =="0.000000000000000001" : ] 000000105786599.173532000000000000 ; 000000122472743.159124000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000A16AE4BAE0EA >									
124 	//     < RUSS_PFXIII_I_metadata_line_9_____NORNICKEL_KOMPLEKS_20211101 >									
125 	//        < i9ypc0J2W4i3mKU7O6Ngo7tk3CsFxg4oC1SrJ72h1OWE2xO2gTSxPJLUskT1kIdM >									
126 	//        <  u =="0.000000000000000001" : ] 000000122472743.159124000000000000 ; 000000136323529.686731000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000000BAE0EAD00361 >									
128 	//     < RUSS_PFXIII_I_metadata_line_10_____NORNICKEL_PRODUKT_20211101 >									
129 	//        < 6au2YN3vA3Zb4Elk3l7Y3eSdqPn3Y53191mN5PKWGq8YgJgxT8Vxg3sEcaYv2vaG >									
130 	//        <  u =="0.000000000000000001" : ] 000000136323529.686731000000000000 ; 000000151993155.636279000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000000D00361E7EC54 >									
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
174 	//     < RUSS_PFXIII_I_metadata_line_11_____YENESEI_RIVER_SHIPPING_CO_20211101 >									
175 	//        < R7847EMl9B565955Z3SDg3Gs58p29Q9kS35Vgql7W2z5qmp09bzxeWi59cmm552R >									
176 	//        <  u =="0.000000000000000001" : ] 000000151993155.636279000000000000 ; 000000166808020.570720000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000000E7EC54FE8762 >									
178 	//     < RUSS_PFXIII_I_metadata_line_12_____YENESEI_PI_PENSII_20211101 >									
179 	//        < Vi42XOk8324q4aBDrx26JwAzJkdzabTv2of0VBS52C4s0Py2X8Lvk6HeA812BXH6 >									
180 	//        <  u =="0.000000000000000001" : ] 000000166808020.570720000000000000 ; 000000180450852.812920000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000000FE8762113589D >									
182 	//     < RUSS_PFXIII_I_metadata_line_13_____YENESEI_PI_ALIANS_20211101 >									
183 	//        < e0l13AM7y13G9i6n2LIEaALRDR57Ej7QYwdmHp57W5y9t49e17hAxqz6Q78U34pW >									
184 	//        <  u =="0.000000000000000001" : ] 000000180450852.812920000000000000 ; 000000197182600.552151000000000000 ] >									
185 	//        < 0x00000000000000000000000000000000000000000000000000113589D12CE074 >									
186 	//     < RUSS_PFXIII_I_metadata_line_14_____YENESEI_PI_KROM_20211101 >									
187 	//        < oRelFv6ddOJG5ys8UJ00Er3bJ06dc02g4erkjkOKH17k94X2fqm3YZp1DtYGd1A8 >									
188 	//        <  u =="0.000000000000000001" : ] 000000197182600.552151000000000000 ; 000000214352528.650492000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000012CE0741471375 >									
190 	//     < RUSS_PFXIII_I_metadata_line_15_____YENESEI_PI_FINANS_20211101 >									
191 	//        < 8SQvvo7P11e4y6SpC36A2YZR2nwdA3uASn6b8Kqq2zTKk7vjJM2rec2A51J0aTf0 >									
192 	//        <  u =="0.000000000000000001" : ] 000000214352528.650492000000000000 ; 000000228433828.424246000000000000 ] >									
193 	//        < 0x00000000000000000000000000000000000000000000000000147137515C8FF7 >									
194 	//     < RUSS_PFXIII_I_metadata_line_16_____YENESEI_PI_KOMPLEKS_20211101 >									
195 	//        < L26weXlaHXDqSOV84FiHH3NR61y5vNaL6yJ5zB0684P3k3u8lmr0jP992DuMWanM >									
196 	//        <  u =="0.000000000000000001" : ] 000000228433828.424246000000000000 ; 000000242391233.705722000000000000 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000000015C8FF7171DC13 >									
198 	//     < RUSS_PFXIII_I_metadata_line_17_____YENESEI_PI_TECH_20211101 >									
199 	//        < iwEe6u7sKHs7dYy5eX301naCE1q25082n460cLnxxQP48rD8ACGsg1ivP9eETl2j >									
200 	//        <  u =="0.000000000000000001" : ] 000000242391233.705722000000000000 ; 000000259220840.247770000000000000 ] >									
201 	//        < 0x00000000000000000000000000000000000000000000000000171DC1318B8A24 >									
202 	//     < RUSS_PFXIII_I_metadata_line_18_____YENESEI_PI_KOMPANIYA_20211101 >									
203 	//        < dwb9yES5SrdJdeOsx06F69yVR4Q6EN4TwXIGwjvZzmxYfn5k65acpccoA5xs9Dx6 >									
204 	//        <  u =="0.000000000000000001" : ] 000000259220840.247770000000000000 ; 000000274616374.295836000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000018B8A241A30805 >									
206 	//     < RUSS_PFXIII_I_metadata_line_19_____YENESEI_PI_MATHS_20211101 >									
207 	//        < ZEs8YR1dDHCLn5rP439u9b4mCNFT3b32Q62Zzu8Y7n6gtiy7UlIIeKtnLeu27ngD >									
208 	//        <  u =="0.000000000000000001" : ] 000000274616374.295836000000000000 ; 000000291094731.214647000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000001A308051BC2CE1 >									
210 	//     < RUSS_PFXIII_I_metadata_line_20_____YENESEI_PI_PRODUKT_20211101 >									
211 	//        < Vafo3P14fvfTkTjh5rx24j2uE2dBKO3TK8J7etoRgCyZy8o5839K8AEyCIL2aLS1 >									
212 	//        <  u =="0.000000000000000001" : ] 000000291094731.214647000000000000 ; 000000306511228.741266000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000001BC2CE11D3B2F3 >									
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
256 	//     < RUSS_PFXIII_I_metadata_line_21_____YENESEI_1_ORG_20211101 >									
257 	//        < JhD504oR55dy9Vu6E08JlJSg5XzJBuii04EOBN3GgHVcrA587PrrqLG0xn2I8dec >									
258 	//        <  u =="0.000000000000000001" : ] 000000306511228.741266000000000000 ; 000000320654305.232810000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000001D3B2F31E94797 >									
260 	//     < RUSS_PFXIII_I_metadata_line_22_____YENESEI_1_DAO_20211101 >									
261 	//        < jkQ4F23MZX6Jk0n0VLhC5Ved4fWkEp8a7kO61JJV1CJ5912Di1Bgg1tke6Ek59ZW >									
262 	//        <  u =="0.000000000000000001" : ] 000000320654305.232810000000000000 ; 000000335700227.207616000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000001E947972003CE7 >									
264 	//     < RUSS_PFXIII_I_metadata_line_23_____YENESEI_1_DAOPI_20211101 >									
265 	//        < 4bkF5ZD55M0RWs1v284dVO6RCoz33nHLs1dRD1oFnhYo7x0Xj8dt4M2O034RYENo >									
266 	//        <  u =="0.000000000000000001" : ] 000000335700227.207616000000000000 ; 000000351213272.171682000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000002003CE7217E8AF >									
268 	//     < RUSS_PFXIII_I_metadata_line_24_____YENESEI_1_DAC_20211101 >									
269 	//        < S0570572Gb5k90LbwIGdMibyfUvcfXY9GTwqX9Rm1yi0v70VTH0FK4UgXn3Rc1Vo >									
270 	//        <  u =="0.000000000000000001" : ] 000000351213272.171682000000000000 ; 000000367707218.528229000000000000 ] >									
271 	//        < 0x00000000000000000000000000000000000000000000000000217E8AF23113A2 >									
272 	//     < RUSS_PFXIII_I_metadata_line_25_____YENESEI_1_BIMI_20211101 >									
273 	//        < dIg9KhDbP1W5plM3n9O44r4chKI47GhCsj3B7ik4cwhGqVYL7OsY173Pi2Tl5d3P >									
274 	//        <  u =="0.000000000000000001" : ] 000000367707218.528229000000000000 ; 000000381252950.191520000000000000 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000000000023113A2245BEEF >									
276 	//     < RUSS_PFXIII_I_metadata_line_26_____YENESEI_2_ORG_20211101 >									
277 	//        < HbEfQ6Jqu6MaRSRD5JMS4KeOU3ZvP673HeJK269Q2hbF9GUyqeDN5SLN72EY80O7 >									
278 	//        <  u =="0.000000000000000001" : ] 000000381252950.191520000000000000 ; 000000396894710.745309000000000000 ] >									
279 	//        < 0x00000000000000000000000000000000000000000000000000245BEEF25D9CFF >									
280 	//     < RUSS_PFXIII_I_metadata_line_27_____YENESEI_2_DAO_20211101 >									
281 	//        < Un4gkWOOSSIZL6LK4s0NvVeVV91j2Z7jgfAISpR34Mk4225t05P330O7tlC9vh0B >									
282 	//        <  u =="0.000000000000000001" : ] 000000396894710.745309000000000000 ; 000000410742057.663116000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000025D9CFF272BE1E >									
284 	//     < RUSS_PFXIII_I_metadata_line_28_____YENESEI_2_DAOPI_20211101 >									
285 	//        < E5j4RQ45nbON5dN3F63Kd1X9COXNgjszswJ3F4OxGHWlR26rXsSAuJ4eefWc6zJ7 >									
286 	//        <  u =="0.000000000000000001" : ] 000000410742057.663116000000000000 ; 000000427038479.904392000000000000 ] >									
287 	//        < 0x00000000000000000000000000000000000000000000000000272BE1E28B9BE8 >									
288 	//     < RUSS_PFXIII_I_metadata_line_29_____YENESEI_2_DAC_20211101 >									
289 	//        < 5K3XWviEtm5eX30LYYr83K6I2hsMLAORcGvA4qki9q1EXNjKGqg38UP0s0j1a2Q6 >									
290 	//        <  u =="0.000000000000000001" : ] 000000427038479.904392000000000000 ; 000000442520312.534295000000000000 ] >									
291 	//        < 0x0000000000000000000000000000000000000000000000000028B9BE82A33B7F >									
292 	//     < RUSS_PFXIII_I_metadata_line_30_____YENESEI_2_BIMI_20211101 >									
293 	//        < z1gdm21BAkb1zWtH0C7o2Fs75k3oxjN3AO17s0CDigmf5Eod9njVhdT7qLKXM6Ah >									
294 	//        <  u =="0.000000000000000001" : ] 000000442520312.534295000000000000 ; 000000457337134.701874000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000002A33B7F2B9D751 >									
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
338 	//     < RUSS_PFXIII_I_metadata_line_31_____NORDAVIA_20211101 >									
339 	//        < 7897y50G4VKxjRyYcwbo27ojLAX0222rMZIxp4urgZ7WX6mDyI8Bl4Udyv0T1Y51 >									
340 	//        <  u =="0.000000000000000001" : ] 000000457337134.701874000000000000 ; 000000470635975.571940000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000002B9D7512CE222E >									
342 	//     < RUSS_PFXIII_I_metadata_line_32_____NORDSTAR_20211101 >									
343 	//        < lZOsYvhzmF16h6m3aziH5FKm1960QMrmw14RbLVwof548ZERd3ixE39GwYDW3U5A >									
344 	//        <  u =="0.000000000000000001" : ] 000000470635975.571940000000000000 ; 000000484644589.090586000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000002CE222E2E3824B >									
346 	//     < RUSS_PFXIII_I_metadata_line_33_____OGK_3_20211101 >									
347 	//        < h431m3dj1bo03H9qg1sP1lFpn69Mr9upfMm80l6810mt0HtXSn1V0o88nwJS5K40 >									
348 	//        <  u =="0.000000000000000001" : ] 000000484644589.090586000000000000 ; 000000499166252.960503000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000002E3824B2F9AAD1 >									
350 	//     < RUSS_PFXIII_I_metadata_line_34_____TAIMYR_ENERGY_CO_20211101 >									
351 	//        < Us1kbNotSk427379oF1W9O3k3PDmV52jZ66qqHo42wMvAP8MGgD02J26w5083BN5 >									
352 	//        <  u =="0.000000000000000001" : ] 000000499166252.960503000000000000 ; 000000513182564.925766000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000002F9AAD130F0DF0 >									
354 	//     < RUSS_PFXIII_I_metadata_line_35_____METAL_TRADE_OVERSEAS_AG_20211101 >									
355 	//        < 7y3423j2gZKnWPjue5AePL1Ho4WFmuP4Nh1t68aIJSpny3sMBht93bHl114620KD >									
356 	//        <  u =="0.000000000000000001" : ] 000000513182564.925766000000000000 ; 000000526390243.724907000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000030F0DF03233530 >									
358 	//     < RUSS_PFXIII_I_metadata_line_36_____KOLSKAYA_GMK_20211101 >									
359 	//        < 6f8UPSGjqMiER0Id05aeM4aj38Pd4S61D16gA78SgIES23d0fc0IyWnPr28cYu0p >									
360 	//        <  u =="0.000000000000000001" : ] 000000526390243.724907000000000000 ; 000000541974522.831866000000000000 ] >									
361 	//        < 0x00000000000000000000000000000000000000000000000000323353033AFCCC >									
362 	//     < RUSS_PFXIII_I_metadata_line_37_____NORNICKEL_MMC_FINANCE_LIMITED_20211101 >									
363 	//        < 5IveX60D8vmQE06NLW51mHXOvg66Qk0qi86Yn29RlkD7FGVk9vz60LnpCByrvg8W >									
364 	//        <  u =="0.000000000000000001" : ] 000000541974522.831866000000000000 ; 000000556428289.736875000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000033AFCCC3510ACD >									
366 	//     < RUSS_PFXIII_I_metadata_line_38_____NORNICKEL_ASIA_LIMITED_20211101 >									
367 	//        < UMBZTJtd34NDWEVjx0yu7zzjBk5G0uFe8Q147fUR3bhV2re974GB8GNyoz2zmD5X >									
368 	//        <  u =="0.000000000000000001" : ] 000000556428289.736875000000000000 ; 000000570030797.281098000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000003510ACD365CC48 >									
370 	//     < RUSS_PFXIII_I_metadata_line_39_____TATI_NICKEL_MINING_CO_20211101 >									
371 	//        < 1uDqH2BGSrDUZQubp923KnYJXOf4X268vMQ3q9xL6XJ732JljUsJeVyq7DVIcTUR >									
372 	//        <  u =="0.000000000000000001" : ] 000000570030797.281098000000000000 ; 000000584190558.896328000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000365CC4837B6770 >									
374 	//     < RUSS_PFXIII_I_metadata_line_40_____TATI_ORG_20211101 >									
375 	//        < VGi1n502631go7p7ozr7R6jT2Hm4DFA0f0Y005wfTJ5m36l9NoVx464w1WQX5wgJ >									
376 	//        <  u =="0.000000000000000001" : ] 000000584190558.896328000000000000 ; 000000598283147.326372000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000037B6770390E85B >									
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