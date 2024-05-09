1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXII_II_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXII_II_883		"	;
8 		string	public		symbol =	"	RUSS_PFXII_II_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		771267165988295000000000000					;	
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
92 	//     < RUSS_PFXII_II_metadata_line_1_____TMK_20231101 >									
93 	//        < hgE05676RoARsX1qSd30Fwjzc5kc3GTU2lp0oC7a88M1i3T816AP33OYC5aUzVTL >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000018613309.041651500000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000001C66D3 >									
96 	//     < RUSS_PFXII_II_metadata_line_2_____TMK_ORG_20231101 >									
97 	//        < KndK1JeqjQDBTkV1Xz95tAbC87ixgYuJ85Ot87G99rl7d48I65WsWLYFHP5U26xe >									
98 	//        <  u =="0.000000000000000001" : ] 000000018613309.041651500000000000 ; 000000038717214.268966400000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000001C66D33B13E9 >									
100 	//     < RUSS_PFXII_II_metadata_line_3_____TMK_STEEL_LIMITED_20231101 >									
101 	//        < Qd07EsG8ZONzrRUX2P4dLRy4gDjWYuKO8hyv6NlmAK0G4hUQ55GAXzh5UxsZYoGu >									
102 	//        <  u =="0.000000000000000001" : ] 000000038717214.268966400000000000 ; 000000054168081.288761600000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000003B13E952A768 >									
104 	//     < RUSS_PFXII_II_metadata_line_4_____IPSCO_TUBULARS_INC_20231101 >									
105 	//        < NgY66yD7Vm551J35s5o869932600nd3lqJ6OYR2y1vgC0J2FgDCFS77r96gc1hE2 >									
106 	//        <  u =="0.000000000000000001" : ] 000000054168081.288761600000000000 ; 000000072847161.800515000000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000052A7686F27EC >									
108 	//     < RUSS_PFXII_II_metadata_line_5_____VOLZHSKY_PIPE_PLANT_20231101 >									
109 	//        < YrjAxmXi1TCXm7y5gW5EndDrdn74X5cj7EH9509m2No199K95Whr1LHppQ8I31Se >									
110 	//        <  u =="0.000000000000000001" : ] 000000072847161.800515000000000000 ; 000000094063881.032758400000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000006F27EC8F87B4 >									
112 	//     < RUSS_PFXII_II_metadata_line_6_____SEVERSKY_PIPE_PLANT_20231101 >									
113 	//        < 11k22O9qgGEARd2M593NUKM36W6ZJ7Sy854Qb85TrF96NFJ0c78uaWXdcZ8gpo1c >									
114 	//        <  u =="0.000000000000000001" : ] 000000094063881.032758400000000000 ; 000000114122960.551995000000000000 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000000000008F87B4AE2348 >									
116 	//     < RUSS_PFXII_II_metadata_line_7_____RESITA_WORKS_20231101 >									
117 	//        < 1LZHH0cX8iB0Sh0gUUI9lUuf52ynF2Je58Ry4yQ4SSbqGf8CdONZJMKmJC3VNWl9 >									
118 	//        <  u =="0.000000000000000001" : ] 000000114122960.551995000000000000 ; 000000134234323.529141000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000AE2348CCD348 >									
120 	//     < RUSS_PFXII_II_metadata_line_8_____GULF_INTERNATIONAL_PIPE_INDUSTRY_20231101 >									
121 	//        < gc6q80hq1bIWqS2d45txkr72JcJAJozs9khtpdVw6nd129xUdJj3L88rhyy0ShwP >									
122 	//        <  u =="0.000000000000000001" : ] 000000134234323.529141000000000000 ; 000000153389605.387935000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000CCD348EA0DD1 >									
124 	//     < RUSS_PFXII_II_metadata_line_9_____TMK_PREMIUM_SERVICE_20231101 >									
125 	//        < n5ykg86E3Vm2uXXocT6T81Vf5M13VN9wy870v5DpShugWNb4PAe8EK7kA61OiU3e >									
126 	//        <  u =="0.000000000000000001" : ] 000000153389605.387935000000000000 ; 000000170720124.092163000000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000000EA0DD11047F8C >									
128 	//     < RUSS_PFXII_II_metadata_line_10_____ORSKY_MACHINE_BUILDING_PLANT_20231101 >									
129 	//        < 1282TfzK0TQ15s71fO9Xe4BDYWctcB0fSInGuc49ZkEJVMW09I2EN40I21Tw14Fs >									
130 	//        <  u =="0.000000000000000001" : ] 000000170720124.092163000000000000 ; 000000187379052.009477000000000000 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000000001047F8C11DEAF1 >									
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
174 	//     < RUSS_PFXII_II_metadata_line_11_____TMK_CAPITAL_SA_20231101 >									
175 	//        < 9cZ2BmaogS13rL5bvT2oulKlsIoqA8CbjIk69Oy84j44450P05v6qhHIm0aAU9D6 >									
176 	//        <  u =="0.000000000000000001" : ] 000000187379052.009477000000000000 ; 000000204989989.648518000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000011DEAF1138CA37 >									
178 	//     < RUSS_PFXII_II_metadata_line_12_____TMK_NSG_LLC_20231101 >									
179 	//        < L3TmfiK23B4lKPgn1MsJG5r51Z2a0XxcQ7pPCAhf6K7GpEA7nLJrUsG38dR0A66b >									
180 	//        <  u =="0.000000000000000001" : ] 000000204989989.648518000000000000 ; 000000220497463.473259000000000000 ] >									
181 	//        < 0x00000000000000000000000000000000000000000000000000138CA3715073D2 >									
182 	//     < RUSS_PFXII_II_metadata_line_13_____TMK_GLOBAL_AG_20231101 >									
183 	//        < VfP0O6bVYPnH98cPC9SK370sXl3JtjOn6p0x8e9SET4u039NQ1i2tT88bH1DakY5 >									
184 	//        <  u =="0.000000000000000001" : ] 000000220497463.473259000000000000 ; 000000242408305.326265000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000015073D2171E2BF >									
186 	//     < RUSS_PFXII_II_metadata_line_14_____TMK_EUROPE_GMBH_20231101 >									
187 	//        < tMRVTL7wso2U6JX4tg191G0sBm9rPc9z99mbw5gd502D9F7e35aiVpPT8EY2rev8 >									
188 	//        <  u =="0.000000000000000001" : ] 000000242408305.326265000000000000 ; 000000259395831.754933000000000000 ] >									
189 	//        < 0x00000000000000000000000000000000000000000000000000171E2BF18BCE7F >									
190 	//     < RUSS_PFXII_II_metadata_line_15_____TMK_MIDDLE_EAST_FZCO_20231101 >									
191 	//        < x1llnP7190votLm54Zh2IoOA18RG52N2t45v4RYnl1DYOH0FCo5Cz9b451hRppVG >									
192 	//        <  u =="0.000000000000000001" : ] 000000259395831.754933000000000000 ; 000000281599418.632856000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000018BCE7F1ADAFC6 >									
194 	//     < RUSS_PFXII_II_metadata_line_16_____TMK_EUROSINARA_SRL_20231101 >									
195 	//        < 5PY3VN909NA8N8HUFemCK6UWPvTm4303xMUGixGLpS8m04u26uK2nKJL1Ay0A6D2 >									
196 	//        <  u =="0.000000000000000001" : ] 000000281599418.632856000000000000 ; 000000303564100.837930000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000001ADAFC61CF33BA >									
198 	//     < RUSS_PFXII_II_metadata_line_17_____TMK_EASTERN_EUROPE_SRL_20231101 >									
199 	//        < Cuo34boIqt8Y727DB7HBC4P0zfBFEBhrlzik9oGK5071f64iRtl0TQYWcd8GqrQb >									
200 	//        <  u =="0.000000000000000001" : ] 000000303564100.837930000000000000 ; 000000326648075.077173000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000001CF33BA1F26CE8 >									
202 	//     < RUSS_PFXII_II_metadata_line_18_____TMK_REAL_ESTATE_SRL_20231101 >									
203 	//        < mBxp2Cs60NyNeJ9xejdYB0Pbt3R2IFhgZ34XSfNY9u4Pmsk12G21Tc2gw6pWbP3M >									
204 	//        <  u =="0.000000000000000001" : ] 000000326648075.077173000000000000 ; 000000342391782.303527000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000001F26CE820A72CA >									
206 	//     < RUSS_PFXII_II_metadata_line_19_____POKROVKA_40_20231101 >									
207 	//        < 1HP8Zg4lPwWo57jD4v3vhrVE00w34r6B7xe71931cC7SiVG2505iRK7D02bq9kO8 >									
208 	//        <  u =="0.000000000000000001" : ] 000000342391782.303527000000000000 ; 000000364585776.436535000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000000020A72CA22C5052 >									
210 	//     < RUSS_PFXII_II_metadata_line_20_____THREADING_MECHANICAL_KEY_PREMIUM_20231101 >									
211 	//        < HMyw0MVetO8Pv4jg2U6nvaK3O5PqX4gJ93h2q095Ihdq3qK1pCAKQscxGQ5D40pQ >									
212 	//        <  u =="0.000000000000000001" : ] 000000364585776.436535000000000000 ; 000000383098203.962833000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000022C50522488FBC >									
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
256 	//     < RUSS_PFXII_II_metadata_line_21_____TMK_NORTH_AMERICA_INC_20231101 >									
257 	//        < a13V2W4ToVKoc6GteU49zp2KOP1l48MSYJpwK5sZGaK14yOfgHEz55t4hXW862gl >									
258 	//        <  u =="0.000000000000000001" : ] 000000383098203.962833000000000000 ; 000000405974037.653412000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000002488FBC26B779C >									
260 	//     < RUSS_PFXII_II_metadata_line_22_____TMK_KAZAKHSTAN_20231101 >									
261 	//        < o9WmWK68bBCmTtOa0SDTk8f4HvRynz583vHkDFQAs5NVqUx0KM068TgcqjLE65kO >									
262 	//        <  u =="0.000000000000000001" : ] 000000405974037.653412000000000000 ; 000000423976233.204620000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000026B779C286EFB7 >									
264 	//     < RUSS_PFXII_II_metadata_line_23_____KAZTRUBPROM_20231101 >									
265 	//        < RF2Z0k64lRqq53943A8b0d0i2B8n5UOH3AV1qI4H8WD3h5538C0IQl5e5P01n09N >									
266 	//        <  u =="0.000000000000000001" : ] 000000423976233.204620000000000000 ; 000000444659599.985529000000000000 ] >									
267 	//        < 0x00000000000000000000000000000000000000000000000000286EFB72A67F28 >									
268 	//     < RUSS_PFXII_II_metadata_line_24_____PIPE_METALLURGIC_CO_COMPLETIONS_20231101 >									
269 	//        < g0lNrDS4uqMY1k42Z4l11X4RFRI93gI6R0cU0qh84Ss8Awk93gRwvW680LtubeLG >									
270 	//        <  u =="0.000000000000000001" : ] 000000444659599.985529000000000000 ; 000000463467234.615357000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000002A67F282C331E3 >									
272 	//     < RUSS_PFXII_II_metadata_line_25_____ZAO_TRADE_HOUSE_TMK_20231101 >									
273 	//        < tvjPiQF56AQd5yfNB4zbO03tS0scUN92n60Pn4ou1792O20kYH1wgT05DBL7IB7r >									
274 	//        <  u =="0.000000000000000001" : ] 000000463467234.615357000000000000 ; 000000484277291.093159000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002C331E32E2F2D1 >									
276 	//     < RUSS_PFXII_II_metadata_line_26_____TMK_ZAO_PIPE_REPAIR_20231101 >									
277 	//        < 53lG4EKvJi48OCmGRaQprG6jxNNdeXLpZ4a41O7107ji0y29zweqOMXFuh3kf47a >									
278 	//        <  u =="0.000000000000000001" : ] 000000484277291.093159000000000000 ; 000000507533713.819676000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000002E2F2D13066F5B >									
280 	//     < RUSS_PFXII_II_metadata_line_27_____SINARA_PIPE_WORKS_TRADING_HOUSE_20231101 >									
281 	//        < Q389xII5NVn6hGmu3idgc1vZ7eNN4L73E1Xa433hZq0oB6CuG3wbICC92p82ADx3 >									
282 	//        <  u =="0.000000000000000001" : ] 000000507533713.819676000000000000 ; 000000523436328.523965000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000003066F5B31EB351 >									
284 	//     < RUSS_PFXII_II_metadata_line_28_____SKLADSKOY_KOMPLEKS_20231101 >									
285 	//        < qFr0f7dB9PtA6Lg17GG8vODC8f379Il47Lh0pvnIJy37289IM2aq3WE8G45HADMY >									
286 	//        <  u =="0.000000000000000001" : ] 000000523436328.523965000000000000 ; 000000540598249.834114000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000031EB351338E331 >									
288 	//     < RUSS_PFXII_II_metadata_line_29_____RUS_RESEARCH_INSTITUTE_TUBE_PIPE_IND_20231101 >									
289 	//        < k7AuCtS8fwc5DjJR07Hb0i5q208MGR3u9JvcL5AkPMx2DqaQX8V3zXPkllJ2dlkn >									
290 	//        <  u =="0.000000000000000001" : ] 000000540598249.834114000000000000 ; 000000562298721.173643000000000000 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000000000338E331359FFF0 >									
292 	//     < RUSS_PFXII_II_metadata_line_30_____TAGANROG_METALLURGICAL_PLANT_20231101 >									
293 	//        < zAUNVb58qb38pX62276Yf11zKOCB18E3oqcHT4u1t0OohUriZjNfk8qAnH06dr3L >									
294 	//        <  u =="0.000000000000000001" : ] 000000562298721.173643000000000000 ; 000000578220612.946035000000000000 ] >									
295 	//        < 0x00000000000000000000000000000000000000000000000000359FFF03724B6D >									
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
338 	//     < RUSS_PFXII_II_metadata_line_31_____TAGANROG_METALLURGICAL_WORKS_20231101 >									
339 	//        < vKn5EZhNWxsRCF17962YSCP1Qnelaw0IYfzN9MqS33Z1I3a8Gp90CE5SZA2T15oQ >									
340 	//        <  u =="0.000000000000000001" : ] 000000578220612.946035000000000000 ; 000000593851983.104765000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000003724B6D38A256E >									
342 	//     < RUSS_PFXII_II_metadata_line_32_____IPSCO_CANADA_LIMITED_20231101 >									
343 	//        < q3F84N2585jf0zXYKou5SSQFZA2hkB7D1dh15l01g5D4an35fvxqy11o3IcsIVgR >									
344 	//        <  u =="0.000000000000000001" : ] 000000593851983.104765000000000000 ; 000000609723472.663691000000000000 ] >									
345 	//        < 0x0000000000000000000000000000000000000000000000000038A256E3A25D3B >									
346 	//     < RUSS_PFXII_II_metadata_line_33_____SINARA_NORTH_AMERICA_INC_20231101 >									
347 	//        < t3wJ80RIM7ML0X3w7Xkj4R63m2QC2Jx440fu5D2TL4q4s4G4uZTeRbPL8uJ4aP4b >									
348 	//        <  u =="0.000000000000000001" : ] 000000609723472.663691000000000000 ; 000000628445271.417052000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000003A25D3B3BEEE6F >									
350 	//     < RUSS_PFXII_II_metadata_line_34_____PIPE_METALLURGICAL_CO_TRADING_HOUSE_20231101 >									
351 	//        < Xy6DhOY1ED1UFm6Q0d64GikzoIq526VNXS9H29W1942f62c71K529ZUqs4oEnCJM >									
352 	//        <  u =="0.000000000000000001" : ] 000000628445271.417052000000000000 ; 000000651219295.895214000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000003BEEE6F3E1AE8A >									
354 	//     < RUSS_PFXII_II_metadata_line_35_____TAGANROG_METALLURGICAL_WORKS_20231101 >									
355 	//        < VbiHy6PeJreW4F9M9Xo7nE6nf99JJw69df91jcnR3k8V1FW20HXC36JQz8z9UxE1 >									
356 	//        <  u =="0.000000000000000001" : ] 000000651219295.895214000000000000 ; 000000669472332.985249000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000003E1AE8A3FD88A1 >									
358 	//     < RUSS_PFXII_II_metadata_line_36_____SINARSKY_PIPE_PLANT_20231101 >									
359 	//        < 681fe1ZZ8Ty3jK8936h2vxt0CCEdty68TUZmHkSPn1okki1dyujA97hoiTq8YMdy >									
360 	//        <  u =="0.000000000000000001" : ] 000000669472332.985249000000000000 ; 000000691477942.240443000000000000 ] >									
361 	//        < 0x000000000000000000000000000000000000000000000000003FD88A141F1C92 >									
362 	//     < RUSS_PFXII_II_metadata_line_37_____TMK_BONDS_SA_20231101 >									
363 	//        < c63qzA23g4As1ZQdZZaU4JsJBrC8y6mSSz9Kxav51024XEcnJVt41JCG51OXlDww >									
364 	//        <  u =="0.000000000000000001" : ] 000000691477942.240443000000000000 ; 000000708120554.026407000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000041F1C924388197 >									
366 	//     < RUSS_PFXII_II_metadata_line_38_____OOO_CENTRAL_PIPE_YARD_20231101 >									
367 	//        < 8C99tA76wCo8KY6bS90zg6m2879dUt94k0hLXHz7B3J910J7OHTklb7hhl1O2nc5 >									
368 	//        <  u =="0.000000000000000001" : ] 000000708120554.026407000000000000 ; 000000727300469.096228000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000004388197455C5BF >									
370 	//     < RUSS_PFXII_II_metadata_line_39_____SINARA_PIPE_WORKS_20231101 >									
371 	//        < K14ex2bDf8Uvpe7B9n23imxNby171RoX9X8bpvyZrx5LmGTZ1Ysp6wKogFq9978a >									
372 	//        <  u =="0.000000000000000001" : ] 000000727300469.096228000000000000 ; 000000746988422.612878000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000455C5BF473D05A >									
374 	//     < RUSS_PFXII_II_metadata_line_40_____ZAO_TMK_TRADE_HOUSE_20231101 >									
375 	//        < 2eC1U4dn4V5S1d5500pWw98G26W60eh4o57V69mv4hPqB09YnRXI61n207dan1Oq >									
376 	//        <  u =="0.000000000000000001" : ] 000000746988422.612878000000000000 ; 000000771267165.988295000000000000 ] >									
377 	//        < 0x00000000000000000000000000000000000000000000000000473D05A498DC3D >									
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