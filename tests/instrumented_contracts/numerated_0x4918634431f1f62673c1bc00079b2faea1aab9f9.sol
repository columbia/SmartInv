1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RE_Portfolio_V_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RE_Portfolio_V_883		"	;
8 		string	public		symbol =	"	RE883V		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1438753004438170000000000000					;	
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
92 	//     < RE_Portfolio_V_metadata_line_1_____Asta_Managing_Agency_Limited_20250515 >									
93 	//        < WP4JqCa29fLy9G8T2bN9Lf77jXpG978g1h7Y930GCs7DsRTNsOBQuj35gqAOzV9E >									
94 	//        < 1E-018 limites [ 1E-018 ; 18469005,8688919 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000006E15795E >									
96 	//     < RE_Portfolio_V_metadata_line_2_____Asta_Managing_Agency_Limited_20250515 >									
97 	//        < Jd5MBwk29Y97136p864xEf42rRc5n9hK7CL5p71BhXEJR82GW2VmEbv938Z80ftS >									
98 	//        < 1E-018 limites [ 18469005,8688919 ; 98537245,7608129 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000006E15795E24B53E994 >									
100 	//     < RE_Portfolio_V_metadata_line_3_____Asta_Managing_Agency_Limited_20250515 >									
101 	//        < Q87uMQ7YWUCx1GCMs6p38u7tkv5KR9Azz81A16A178OYT15SaR73thHY89T5dB1D >									
102 	//        < 1E-018 limites [ 98537245,7608129 ; 132591827,66541 ] >									
103 	//        < 0x000000000000000000000000000000000000000000000024B53E9943164F14A2 >									
104 	//     < RE_Portfolio_V_metadata_line_4_____Asta_Managing_Agency_Limited_20250515 >									
105 	//        < ID37fMPIys9lj1R59UBg77gwJjR96XSud8Ids1h7659PXG9b31EpfzPiXbjyixqg >									
106 	//        < 1E-018 limites [ 132591827,66541 ; 156430209,772614 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000003164F14A23A46590A5 >									
108 	//     < RE_Portfolio_V_metadata_line_5_____Asta_Managing_Agency_Limited_20250515 >									
109 	//        < 5N6o6G0k2cmANWKpg85105N084B4uzd9H9Yx194DupvlUGn00uJGKwx86Z9V0kzW >									
110 	//        < 1E-018 limites [ 156430209,772614 ; 202545345,493554 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000003A46590A54B743AD89 >									
112 	//     < RE_Portfolio_V_metadata_line_6_____Asta_Managing_Agency_Limited_20250515 >									
113 	//        < wCvk39Bb5XFVCwdESZm9CJ87YjSPbrlHC26Q657bpM5LyiY0Hni3J6i337sjDQK5 >									
114 	//        < 1E-018 limites [ 202545345,493554 ; 219179688,780864 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000004B743AD8951A69ABE2 >									
116 	//     < RE_Portfolio_V_metadata_line_7_____Asta_Managing_Agency_Limited_20250515 >									
117 	//        < bZebU6K7XNlzmDK59IcwUwmloW09Xse2GIN5OTPmT41ES3RHyN43zw3ACzaMsimk >									
118 	//        < 1E-018 limites [ 219179688,780864 ; 260636152,826453 ] >									
119 	//        < 0x000000000000000000000000000000000000000000000051A69ABE2611833726 >									
120 	//     < RE_Portfolio_V_metadata_line_8_____Asta_Managing_Agency_Limited_20250515 >									
121 	//        < F8LwO4h78saV8PGG2Qa1QKHMxNRaWUdfWO5jK4un8xS378VM5jx76WsQmB220V4t >									
122 	//        < 1E-018 limites [ 260636152,826453 ; 275150257,949163 ] >									
123 	//        < 0x000000000000000000000000000000000000000000000061183372666805FB76 >									
124 	//     < RE_Portfolio_V_metadata_line_9_____Asta_Managing_Agency_Limited_20250515 >									
125 	//        < LN2l9jh3RmsG5ME3ezJ7K7vGOZREck1C758Lmu25CTNjss686rIVyVP5tl1xhMPj >									
126 	//        < 1E-018 limites [ 275150257,949163 ; 286015822,041262 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000066805FB766A8C98470 >									
128 	//     < RE_Portfolio_V_metadata_line_10_____Asta_Managing_Agency_Limited_20250515 >									
129 	//        < 76U3oaS270j936Ss61AfVwYUPKj59b75zdsMUYgrjAzRGy41VBvhn0XQ72N59J8d >									
130 	//        < 1E-018 limites [ 286015822,041262 ; 307343770,416015 ] >									
131 	//        < 0x00000000000000000000000000000000000000000000006A8C98470727E96245 >									
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
174 	//     < RE_Portfolio_V_metadata_line_11_____Atradius_ReinsLimited_A_20250515 >									
175 	//        < Uve10lUiBCZMml39ZRQ7UphDQ5keCIXBf9bd65tFlbtKFDS4CfII93FsBZXrgWT8 >									
176 	//        < 1E-018 limites [ 307343770,416015 ; 325080364,120425 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000727E96245791A14730 >									
178 	//     < RE_Portfolio_V_metadata_line_12_____Atrium_Underwriters_Limited_20250515 >									
179 	//        < 17CpC1mGLLl6X1n8VvNPxIQwZCKM5iu7jL2pd1fh6bXBrOiRG9oEb0gxE11Dwc0O >									
180 	//        < 1E-018 limites [ 325080364,120425 ; 361572162,824439 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000791A1473086B23580E >									
182 	//     < RE_Portfolio_V_metadata_line_13_____Atrium_Underwriters_Limited_20250515 >									
183 	//        < 7alSbD975ydyTph2a362o3029OFEDn3D0tr4WuCqxMh0a85Vz5gc9gd5MshffAgG >									
184 	//        < 1E-018 limites [ 361572162,824439 ; 415192252,059023 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000086B23580E9AABD1B69 >									
186 	//     < RE_Portfolio_V_metadata_line_14_____Atrium_Underwriters_Limited_20250515 >									
187 	//        < NPqBhcq7t4m67aI5246M54Uy1VFtpG1N8y1ggv4fmx60Q0UuR2tk9vj47cMkwr37 >									
188 	//        < 1E-018 limites [ 415192252,059023 ; 445973126,511267 ] >									
189 	//        < 0x00000000000000000000000000000000000000000000009AABD1B69A6234FE7F >									
190 	//     < RE_Portfolio_V_metadata_line_15_____Atrium_Underwriters_Limited_20250515 >									
191 	//        < 8Pc7axGoi3te0uRB5Jrn5KgSd4N7BVFKTB199vUfIc58Nea4w0EJYhD8Jl58iz5i >									
192 	//        < 1E-018 limites [ 445973126,511267 ; 503241109,214056 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000A6234FE7FBB78D003D >									
194 	//     < RE_Portfolio_V_metadata_line_16_____Australia_AAA_QBE_Insurance__International__Limited_Ap_A_20250515 >									
195 	//        < T1Hy0TabPD7d519ngJZN0Z7G27sR6B37nW6pb8Ark53pd55YNdijmQEbR4BX49OD >									
196 	//        < 1E-018 limites [ 503241109,214056 ; 551457233,853145 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000BB78D003DCD6F0F7ED >									
198 	//     < RE_Portfolio_V_metadata_line_17_____Australia_AAA_QBE_Insurance__International__Limited_Ap_A_20250515 >									
199 	//        < 3L657Ky7e6kFm9Xy4pd540ajSePWsPSq8m9Tck9Kus56cj7DT2qP2w44GxhQTiNT >									
200 	//        < 1E-018 limites [ 551457233,853145 ; 569681071,392991 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000CD6F0F7EDD43905677 >									
202 	//     < RE_Portfolio_V_metadata_line_18_____Aviva_Insurance_Limited_Ap_A_20250515 >									
203 	//        < UKIKqlSf7GgT1b5d6D0JdJ1L4YQs7tqB1sd57Bbil5R9E6EFdF81qHU15oECha37 >									
204 	//        < 1E-018 limites [ 569681071,392991 ; 607680471,231113 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000D43905677E260ED207 >									
206 	//     < RE_Portfolio_V_metadata_line_19_____Aviva_Re_Limited_Ap_m_20250515 >									
207 	//        < Z0LSj2vtCAQz2C0902CQ1MvDDa4fWL1n69wux1F2243YvLU5XD24P7E6G9q0mV96 >									
208 	//        < 1E-018 limites [ 607680471,231113 ; 655868639,043572 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000E260ED207F45482114 >									
210 	//     < RE_Portfolio_V_metadata_line_20_____AWP_Health_&_Life_SA_Ap_20250515 >									
211 	//        < n2P6YegPl43V9d4S85ybQ88DPoEZximtoNmQwToX1qq4kv3191l93JSp9OP1Rd7m >									
212 	//        < 1E-018 limites [ 655868639,043572 ; 734988668,91077 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000F45482114111CDFB6BF >									
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
256 	//     < RE_Portfolio_V_metadata_line_21_____AXA_Corporate_Solutions_Assurance_AAm_20250515 >									
257 	//        < 7TlSQ1ulkQ7x5Ge9QG6V1XKxOF5LxPAww5N83iKL8IH2SEoUG6V57gjYw1u2Dfai >									
258 	//        < 1E-018 limites [ 734988668,91077 ; 752087800,446 ] >									
259 	//        < 0x00000000000000000000000000000000000000000000111CDFB6BF1182CAEB00 >									
260 	//     < RE_Portfolio_V_metadata_line_22_____AXA_Corporate_Solutions_Assurance_AAm_m_20250515 >									
261 	//        < 3bBRZsMPY88eBP795f9mk2kn6X6wGAdUxH0NLs8mMrzR8O7j85F83TpP5K2AXa71 >									
262 	//        < 1E-018 limites [ 752087800,446 ; 824467231,792289 ] >									
263 	//        < 0x000000000000000000000000000000000000000000001182CAEB001332352A5F >									
264 	//     < RE_Portfolio_V_metadata_line_23_____AXA_France_IARD_AAm_m_20250515 >									
265 	//        < beAlDu8tUh6o6QU97iz5RC407kBWQi7L435Q968oGi2hp4h7u4JWShi70H2wl1i3 >									
266 	//        < 1E-018 limites [ 824467231,792289 ; 888860762,047968 ] >									
267 	//        < 0x000000000000000000000000000000000000000000001332352A5F14B205E520 >									
268 	//     < RE_Portfolio_V_metadata_line_24_____AXA_France_Vie_AAm_20250515 >									
269 	//        < 8LgL7XRURFWC78TXpbnZw7P4NmV3qwM1RkNT2Z7J33Y6Om6Hj0jVvo13Nla6n8Sq >									
270 	//        < 1E-018 limites [ 888860762,047968 ; 952890111,711953 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000014B205E520162FAAEDD7 >									
272 	//     < RE_Portfolio_V_metadata_line_25_____AXA_Global_P&C_A_Ap_20250515 >									
273 	//        < HvaqAhzVlkQ11kpkqpdy2qp60X1FDDGsjHf40fZ74v1H5Bjs1ycbQ7p6NQcvBwvO >									
274 	//        < 1E-018 limites [ 952890111,711953 ; 973331769,147193 ] >									
275 	//        < 0x00000000000000000000000000000000000000000000162FAAEDD716A9826C46 >									
276 	//     < RE_Portfolio_V_metadata_line_26_____AXA_Reassurance_20250515 >									
277 	//        < zS844I4KKb7ElSp2763ayRwe4mj7eu2U36W8238qR72Paa57AmBdQ7Fgi4JE4uJs >									
278 	//        < 1E-018 limites [ 973331769,147193 ; 991932373,293938 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000016A9826C46171860B145 >									
280 	//     < RE_Portfolio_V_metadata_line_27_____AXA_Reassurance_20250515 >									
281 	//        < 2Yu6SN9QDhgS805K7tYln92862flO43095SiredjuJJAKUAntV0pjohxM5w3M0M6 >									
282 	//        < 1E-018 limites [ 991932373,293938 ; 1020948753,88637 ] >									
283 	//        < 0x00000000000000000000000000000000000000000000171860B14517C5542CF0 >									
284 	//     < RE_Portfolio_V_metadata_line_28_____AXAmPPP_HEALTHCARE_LIMITED_AAm_m_20250515 >									
285 	//        < F10g08XO7W2W36TOZPjjotz25CK6fvqzZQ9pYgwOe1A0rmjw8Q5NB4b38aJ35b0k >									
286 	//        < 1E-018 limites [ 1020948753,88637 ; 1038742948,79752 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000017C5542CF0182F63F653 >									
288 	//     < RE_Portfolio_V_metadata_line_29_____Axis_Capital_20250515 >									
289 	//        < DdobipY6P391GUtI0q7KO116Bwsyr110DCdP9Xj3Cy72W70keH4U0TsZ070dh785 >									
290 	//        < 1E-018 limites [ 1038742948,79752 ; 1057547175,56601 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000182F63F653189F78EF68 >									
292 	//     < RE_Portfolio_V_metadata_line_30_____Axis_Capital_20250515 >									
293 	//        < n99X173H9vkCvi3Vv4jr7p46Ly721ySXZJR3tC56ICMG3H627Km1ueUYk2WIZO1L >									
294 	//        < 1E-018 limites [ 1057547175,56601 ; 1108289461,6947 ] >									
295 	//        < 0x00000000000000000000000000000000000000000000189F78EF6819CDEB84ED >									
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
338 	//     < RE_Portfolio_V_metadata_line_31_____Axis_Capital_Holdings_Limited_20250515 >									
339 	//        < 754M3359NcyCU50W7Sl88kM5NMn9HM75fz5oyZ1JchPYOB3zVR0941nLp9l288NQ >									
340 	//        < 1E-018 limites [ 1108289461,6947 ; 1151435005,60256 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000019CDEB84ED1ACF166504 >									
342 	//     < RE_Portfolio_V_metadata_line_32_____Axis_Management_Group_20250515 >									
343 	//        < 8F2Ir93d0PVWzc0FNALD0ShZW1Dj5U6R45Ra6XhoK5bTTs3aj1795Sh3h04q9wYP >									
344 	//        < 1E-018 limites [ 1151435005,60256 ; 1178154672,23737 ] >									
345 	//        < 0x000000000000000000000000000000000000000000001ACF1665041B6E595ECB >									
346 	//     < RE_Portfolio_V_metadata_line_33_____Axis_Management_Group_20250515 >									
347 	//        < 8DB1596KpMZl3zY3pPe3x1yxiZARc93X0X5jbJz188rxg6lL0a4A3ojF2qt5Yr58 >									
348 	//        < 1E-018 limites [ 1178154672,23737 ; 1213908739,07236 ] >									
349 	//        < 0x000000000000000000000000000000000000000000001B6E595ECB1C4375BF27 >									
350 	//     < RE_Portfolio_V_metadata_line_34_____Axis_Managing_Agency_Limited_20250515 >									
351 	//        < psh5aa6N8Cl7BNp6t676fCc5hLNp9v6Rn29fpoa77PsGxKvAg43YCUFTnJt7AM9y >									
352 	//        < 1E-018 limites [ 1213908739,07236 ; 1225059997,9036 ] >									
353 	//        < 0x000000000000000000000000000000000000000000001C4375BF271C85ED37A2 >									
354 	//     < RE_Portfolio_V_metadata_line_35_____Axis_Managing_Agency_Limited_20250515 >									
355 	//        < jcefa1we6dU2BmcPDUpE15285n4QaN2rx2p7Txj16l34JEmHx0uKpSE9FgzPV7EV >									
356 	//        < 1E-018 limites [ 1225059997,9036 ; 1262133215,03445 ] >									
357 	//        < 0x000000000000000000000000000000000000000000001C85ED37A21D62E67513 >									
358 	//     < RE_Portfolio_V_metadata_line_36_____Axis_Managing_Agency_Limited_20250515 >									
359 	//        < PWIXLE9z0o8M3lEyp86Aj5H309rwl5GP46ZqbdM24zh9GBEQAH6hd8937x8nWq9A >									
360 	//        < 1E-018 limites [ 1262133215,03445 ;  ] >									
361 	//        < 0x000000000000000000000000000000000000000000001D62E675131EDAF64895 >									
362 	//     < RE_Portfolio_V_metadata_line_37_____Axis_Managing_Agency_Limited_20250515 >									
363 	//        < XY5zH3bQ5I9QJOch8zETUp4812PJa21ym0u7l42fI2kExZ5859pg64cuWO55CJXx >									
364 	//        < 1E-018 limites [ 1325225919,05019 ; 1339253251,61118 ] >									
365 	//        < 0x000000000000000000000000000000000000000000001EDAF648951F2E924B5D >									
366 	//     < RE_Portfolio_V_metadata_line_38_____Axis_Managing_Agency_Limited_20250515 >									
367 	//        < 3tMxMx0ptz73A6al9S3EawHF187E5u832l49lA812uvYlplKL9ySS4W84T3Glq5N >									
368 	//        < 1E-018 limites [ 1339253251,61118 ; 1385190157,24825 ] >									
369 	//        < 0x000000000000000000000000000000000000000000001F2E924B5D2040607320 >									
370 	//     < RE_Portfolio_V_metadata_line_39_____Axis_Managing_Agency_Limited_20250515 >									
371 	//        < Ask6YMag5gS7DD8RsqC3eKZI35ku0m1X607PjL922PYyd2Q6Ude0CV7yEDzaXQz7 >									
372 	//        < 1E-018 limites [ 1385190157,24825 ; 1405087030,92401 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000204060732020B6F8AB68 >									
374 	//     < RE_Portfolio_V_metadata_line_40_____Axis_Managing_Agency_Limited_20250515 >									
375 	//        < 0G24P2t9By89Oz3h3X893rX2b69EFQLp8Scx4Vz2DCzOZ7MolstyCpq1ksmIo4N3 >									
376 	//        < 1E-018 limites [ 1405087030,92401 ; 1438753004,43817 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000020B6F8AB68217FA2DE4F >									
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