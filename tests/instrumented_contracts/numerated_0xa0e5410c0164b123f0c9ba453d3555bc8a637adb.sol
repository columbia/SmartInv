1 pragma solidity 		^0.4.25	;						
2 									
3 contract	EUROSIBENERGO_PFXXI_II_883				{				
4 									
5 	mapping (address => uint256) public balanceOf;								
6 									
7 	string	public		name =	"	EUROSIBENERGO_PFXXI_II_883		"	;
8 	string	public		symbol =	"	EUROSIBENERGO_PFXXI_II_IMTD		"	;
9 	uint8	public		decimals =		18			;
10 									
11 	uint256 public totalSupply =		1067296706080140000000000000					;	
12 									
13 	event Transfer(address indexed from, address indexed to, uint256 value);								
14 									
15 	function SimpleERC20Token() public {								
16 		balanceOf[msg.sender] = totalSupply;							
17 		emit Transfer(address(0), msg.sender, totalSupply);							
18 	}								
19 									
20 	function transfer(address to, uint256 value) public returns (bool success) {								
21 		require(balanceOf[msg.sender] >= value);							
22 									
23 		balanceOf[msg.sender] -= value;  // deduct from sender's balance							
24 		balanceOf[to] += value;          // add to recipient's balance							
25 		emit Transfer(msg.sender, to, value);							
26 		return true;							
27 	}								
28 									
29 	event Approval(address indexed owner, address indexed spender, uint256 value);								
30 									
31 	mapping(address => mapping(address => uint256)) public allowance;								
32 									
33 	function approve(address spender, uint256 value)								
34 		public							
35 		returns (bool success)							
36 	{								
37 		allowance[msg.sender][spender] = value;							
38 		emit Approval(msg.sender, spender, value);							
39 		return true;							
40 	}								
41 									
42 	function transferFrom(address from, address to, uint256 value)								
43 		public							
44 		returns (bool success)							
45 	{								
46 		require(value <= balanceOf[from]);							
47 		require(value <= allowance[from][msg.sender]);							
48 									
49 		balanceOf[from] -= value;							
50 		balanceOf[to] += value;							
51 		allowance[from][msg.sender] -= value;							
52 		emit Transfer(from, to, value);							
53 		return true;							
54 	}								
55 									
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
80 // Programme d'émission - Lignes 1 à 10									
81 //									
82 //									
83 //									
84 //									
85 //     [ Nom du portefeuille ; Numéro de la ligne ; Nom de la ligne ; Echéance ]									
86 //         [ Adresse exportée ]									
87 //         [ Unité ; Limite basse ; Limite haute ]									
88 //         [ Hex ]									
89 //									
90 //									
91 //									
92 //     < EUROSIBENERGO_PFXXI_II_metadata_line_1_____Irkutskenergo_JSC_20240321 >									
93 //        < 7vorjeG35WPLCWj0Y1440ks0ebqeEQMnzPCI2z5VSs22nmEfj2Sao206G7AJwcKZ >									
94 //        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000032267646.371695600000000000 ] >									
95 //        < 0x0000000000000000000000000000000000000000000000000000000000313C8D >									
96 //     < EUROSIBENERGO_PFXXI_II_metadata_line_2_____Irkutskenergo_PCI_20240321 >									
97 //        < ifB4FzER2JKAua658041XE9uABu0uVI4D36gR0o4g2G399aA0AW34xHp1Tjp9On6 >									
98 //        <  u =="0.000000000000000001" : ] 000000032267646.371695600000000000 ; 000000064967457.696304800000000000 ] >									
99 //        < 0x0000000000000000000000000000000000000000000000000000313C8D6321EA >									
100 //     < EUROSIBENERGO_PFXXI_II_metadata_line_3_____Irkutskenergo_PCI_Bratsk_20240321 >									
101 //        < MZnP4iM5o1AU5nVl2Yf1drWngpXi83y92DB02K1avB94xFPh718JxhpU354aWpwO >									
102 //        <  u =="0.000000000000000001" : ] 000000064967457.696304800000000000 ; 000000091988354.680387900000000000 ] >									
103 //        < 0x00000000000000000000000000000000000000000000000000006321EA8C5CF3 >									
104 //     < EUROSIBENERGO_PFXXI_II_metadata_line_4_____Irkutskenergo_PCI_Ust_Ilimsk_20240321 >									
105 //        < bizk9q4XDyATrJWkTesnJU5GCSc8co6yHO1qMSJukle0De8XmTv8Ces3w5hDC0v5 >									
106 //        <  u =="0.000000000000000001" : ] 000000091988354.680387900000000000 ; 000000120299537.146481000000000000 ] >									
107 //        < 0x00000000000000000000000000000000000000000000000000008C5CF3B79002 >									
108 //     < EUROSIBENERGO_PFXXI_II_metadata_line_5_____Irkutskenergo_Bratsk_org_spe_20240321 >									
109 //        < Pnrog5sWnsDCr6YBX01H76X94PLqz3l4nB5xS30442f84Fe4p3OMjoMK61c6coyx >									
110 //        <  u =="0.000000000000000001" : ] 000000120299537.146481000000000000 ; 000000156044466.906852000000000000 ] >									
111 //        < 0x0000000000000000000000000000000000000000000000000000B79002EE1ADF >									
112 //     < EUROSIBENERGO_PFXXI_II_metadata_line_6_____Irkutskenergo_Ust_Ilimsk_org_spe_20240321 >									
113 //        < l4H6BY5U85poRVG37682Bs73Jl1SK7282lY0J4W1py594SlefS2e15Y0Lcvv2bp9 >									
114 //        <  u =="0.000000000000000001" : ] 000000156044466.906852000000000000 ; 000000183560702.964399000000000000 ] >									
115 //        < 0x000000000000000000000000000000000000000000000000000EE1ADF1181766 >									
116 //     < EUROSIBENERGO_PFXXI_II_metadata_line_7_____Oui_Energo_Limited_s_China_Yangtze_Power_Company_20240321 >									
117 //        < 6Bn8U12hZCX4CMPc2O9MGGxUa0ZS7pv0d39jv9mN49zGZdOf7076Q6b4AgbAB7Am >									
118 //        <  u =="0.000000000000000001" : ] 000000183560702.964399000000000000 ; 000000208545282.267371000000000000 ] >									
119 //        < 0x00000000000000000000000000000000000000000000000000118176613E3700 >									
120 //     < EUROSIBENERGO_PFXXI_II_metadata_line_8_____China_Yangtze_Power_Company_limited_20240321 >									
121 //        < Iq6NGB7NUDB1u7SgF41Uq9Mj9By2xr0bI54l068T7SYdNm28miOY1T05nPh7i57C >									
122 //        <  u =="0.000000000000000001" : ] 000000208545282.267371000000000000 ; 000000242071276.991109000000000000 ] >									
123 //        < 0x0000000000000000000000000000000000000000000000000013E37001715F18 >									
124 //     < EUROSIBENERGO_PFXXI_II_metadata_line_9_____Three_Gorges_Electric_Power_Company_Limited_20240321 >									
125 //        < 4N1G58g5alJjJd9SnLR0SuXh8889H6M3huhSPAm8VplDt5frlsqI59FjOMbKAug5 >									
126 //        <  u =="0.000000000000000001" : ] 000000242071276.991109000000000000 ; 000000266822212.521806000000000000 ] >									
127 //        < 0x000000000000000000000000000000000000000000000000001715F18197236D >									
128 //     < EUROSIBENERGO_PFXXI_II_metadata_line_10_____Beijing_Yangtze_Power_Innovative_Investment_Management_Company_Limited_20240321 >									
129 //        < WAvkqBUS5OXH9HdVTdoq2Q6311zGM89K3Nqv55ccr0ShQW4nX6a0laNYLc84q3Zd >									
130 //        <  u =="0.000000000000000001" : ] 000000266822212.521806000000000000 ; 000000290782450.535679000000000000 ] >									
131 //        < 0x00000000000000000000000000000000000000000000000000197236D1BBB2E5 >									
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
162 // Programme d'émission - Lignes 11 à 20									
163 //									
164 //									
165 //									
166 //									
167 //     [ Nom du portefeuille ; Numéro de la ligne ; Nom de la ligne ; Echéance ]									
168 //         [ Adresse exportée ]									
169 //         [ Unité ; Limite basse ; Limite haute ]									
170 //         [ Hex ]									
171 //									
172 //									
173 //									
174 //     < EUROSIBENERGO_PFXXI_II_metadata_line_11_____Three_Gorges_Jinsha_River_Chuanyun_Hydropower_Development_Company_Limited_20240321 >									
175 //        < q272RaTuvHCdTq42DknG0mmmui97tHlzQax0Q5973J1G039dw6PWkkKL47wWMcaL >									
176 //        <  u =="0.000000000000000001" : ] 000000290782450.535679000000000000 ; 000000318249436.324908000000000000 ] >									
177 //        < 0x000000000000000000000000000000000000000000000000001BBB2E51E59C30 >									
178 //     < EUROSIBENERGO_PFXXI_II_metadata_line_12_____Changdian_Capital_Holding_Company_Limited_20240321 >									
179 //        < GRd82jB0TBr1Pi49L7mz985VKI7lXo32NONNQT4c4TfejL7uBf7lf03NCz33zsTR >									
180 //        <  u =="0.000000000000000001" : ] 000000318249436.324908000000000000 ; 000000346318085.053310000000000000 ] >									
181 //        < 0x000000000000000000000000000000000000000000000000001E59C302107081 >									
182 //     < EUROSIBENERGO_PFXXI_II_metadata_line_13_____Eurosibenergo_OJSC_20240321 >									
183 //        < QDOg062VGuTTHRSCB98rw03DNHvcOtw7nv33IunrXDE5zQQroH973mscdxPnXr74 >									
184 //        <  u =="0.000000000000000001" : ] 000000346318085.053310000000000000 ; 000000365762724.846158000000000000 ] >									
185 //        < 0x00000000000000000000000000000000000000000000000000210708122E1C10 >									
186 //     < EUROSIBENERGO_PFXXI_II_metadata_line_14_____Baikalenergo_JSC_20240321 >									
187 //        < Jm8a8roiQn1O6jm8cP620ZXZL8x91i0yBNK7XkJlfABYj7cbs6W41W583OUAQnPn >									
188 //        <  u =="0.000000000000000001" : ] 000000365762724.846158000000000000 ; 000000395743287.130081000000000000 ] >									
189 //        < 0x0000000000000000000000000000000000000000000000000022E1C1025BDB39 >									
190 //     < EUROSIBENERGO_PFXXI_II_metadata_line_15_____Sayanogorsk_Teploseti_20240321 >									
191 //        < CmF72mknSTO2be8U8wb85UcfLa2vA6Q6BUy1kCx2Z2WYLX1laQLY4MvUNt1ART58 >									
192 //        <  u =="0.000000000000000001" : ] 000000395743287.130081000000000000 ; 000000424487381.941898000000000000 ] >									
193 //        < 0x0000000000000000000000000000000000000000000000000025BDB39287B762 >									
194 //     < EUROSIBENERGO_PFXXI_II_metadata_line_16_____China_Yangtze_Power_International_Hong_Kong_Company_Limited_20240321 >									
195 //        < 4jPw9LT2u72Sz5UnX6ftg7IvrTBbAE8A2Q38dhw5Eod8YGVi2b7dLJoWrW71R6f4 >									
196 //        <  u =="0.000000000000000001" : ] 000000424487381.941898000000000000 ; 000000451710176.837997000000000000 ] >									
197 //        < 0x00000000000000000000000000000000000000000000000000287B7622B1414A >									
198 //     < EUROSIBENERGO_PFXXI_II_metadata_line_17_____Fujian_Electric_Distribution_Sale_COmpany_Limited_20240321 >									
199 //        < L8Y6o2rM5wxb363Y050MHP9wVCcfGX974EOQ5t5g18mF1T0dP4511LEMgwTNKRS7 >									
200 //        <  u =="0.000000000000000001" : ] 000000451710176.837997000000000000 ; 000000486149975.432702000000000000 ] >									
201 //        < 0x000000000000000000000000000000000000000000000000002B1414A2E5CE56 >									
202 //     < EUROSIBENERGO_PFXXI_II_metadata_line_18_____Bohai_Ferry_Group_20240321 >									
203 //        < 7n62N02ZFf1w215lmZ19D4y2S647VG9S32rPYQ0JTMKwx70Wm7vi4q1d6dAcKKA4 >									
204 //        <  u =="0.000000000000000001" : ] 000000486149975.432702000000000000 ; 000000514601124.186520000000000000 ] >									
205 //        < 0x000000000000000000000000000000000000000000000000002E5CE563113810 >									
206 //     < EUROSIBENERGO_PFXXI_II_metadata_line_19_____Eurosibenergo_OJSC_20240321 >									
207 //        < 095b8Wl3XfUH7O1oV323KN1l9k1YIMr6qBH466F48u7EiQ6h66YFN9Vn9yk46AbD >									
208 //        <  u =="0.000000000000000001" : ] 000000514601124.186520000000000000 ; 000000537692528.650708000000000000 ] >									
209 //        < 0x0000000000000000000000000000000000000000000000000031138103347425 >									
210 //     < EUROSIBENERGO_PFXXI_II_metadata_line_20_____Krasnoyarskaya_HPP_20240321 >									
211 //        < oJ54pis6F96hSrrlFKLlaAS43cEVSTYol6ll444myQG6oCxBb5y709QpUGpP1Q52 >									
212 //        <  u =="0.000000000000000001" : ] 000000537692528.650708000000000000 ; 000000561095932.094213000000000000 ] >									
213 //        < 0x0000000000000000000000000000000000000000000000000033474253582A19 >									
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
244 // Programme d'émission - Lignes 21 à 30									
245 //									
246 //									
247 //									
248 //									
249 //     [ Nom du portefeuille ; Numéro de la ligne ; Nom de la ligne ; Echéance ]									
250 //         [ Adresse exportée ]									
251 //         [ Unité ; Limite basse ; Limite haute ]									
252 //         [ Hex ]									
253 //									
254 //									
255 //									
256 //     < EUROSIBENERGO_PFXXI_II_metadata_line_21_____ERA_Group_OJSC_20240321 >									
257 //        < f2lKa31dEYv2cvlikSlw287T90VFy0EnPlKt8N9wxomURz6azjl91C569XoM80bD >									
258 //        <  u =="0.000000000000000001" : ] 000000561095932.094213000000000000 ; 000000591385214.501297000000000000 ] >									
259 //        < 0x000000000000000000000000000000000000000000000000003582A1938661D9 >									
260 //     < EUROSIBENERGO_PFXXI_II_metadata_line_22_____Russky_Kremny_LLC_20240321 >									
261 //        < oBeL3Da4z8bypre1C65EJN4zN99hgwK15zbGYTO7L07TK8r5nWiX6qGt1ZL1B2x2 >									
262 //        <  u =="0.000000000000000001" : ] 000000591385214.501297000000000000 ; 000000615113840.208197000000000000 ] >									
263 //        < 0x0000000000000000000000000000000000000000000000000038661D93AA96D8 >									
264 //     < EUROSIBENERGO_PFXXI_II_metadata_line_23_____Avtozavodskaya_org_spe_20240321 >									
265 //        < P04RdIO20L4ShaA6zFs9sW70RN2ODssMMy5n5dCj3f5ORB50gt8eOjCBw2vXarSb >									
266 //        <  u =="0.000000000000000001" : ] 000000615113840.208197000000000000 ; 000000643585175.579072000000000000 ] >									
267 //        < 0x000000000000000000000000000000000000000000000000003AA96D83D60876 >									
268 //     < EUROSIBENERGO_PFXXI_II_metadata_line_24_____Irkutsk_Electric_Grid_Company_20240321 >									
269 //        < My4ZJdP8aD0n06O2110EqM5H0cu9B47k77NCtlQ35ta50F7Kbj97Alh4gtG5Of3Y >									
270 //        <  u =="0.000000000000000001" : ] 000000643585175.579072000000000000 ; 000000664943486.492450000000000000 ] >									
271 //        < 0x000000000000000000000000000000000000000000000000003D608763F69F8D >									
272 //     < EUROSIBENERGO_PFXXI_II_metadata_line_25_____Eurosibenergo_OJSC_20240321 >									
273 //        < d219ma4n71q0Yx4F37NfPWrCn8S3H41R2vHgeBGDv7Le62r3vz8tyqB36Bv5k2a6 >									
274 //        <  u =="0.000000000000000001" : ] 000000664943486.492450000000000000 ; 000000689531042.887379000000000000 ] >									
275 //        < 0x000000000000000000000000000000000000000000000000003F69F8D41C2410 >									
276 //     < EUROSIBENERGO_PFXXI_II_metadata_line_26_____Eurosibenergo_LLC_distributed_generation_20240321 >									
277 //        < 8vx5626mt2D3tZ3l28C4jy2eUWA8SvsNG7cBBFM4uh0BRO04gAP9e3EG29xcq2Wv >									
278 //        <  u =="0.000000000000000001" : ] 000000689531042.887379000000000000 ; 000000712025453.972248000000000000 ] >									
279 //        < 0x0000000000000000000000000000000000000000000000000041C241043E76F1 >									
280 //     < EUROSIBENERGO_PFXXI_II_metadata_line_27_____Generatsiya_OOO_20240321 >									
281 //        < 4Ypatjj9l3DNZPFqX0rk6n8a4xkPT0871e0laQH88mrD5TPqo6lhRYAB7mY7JDy1 >									
282 //        <  u =="0.000000000000000001" : ] 000000712025453.972248000000000000 ; 000000737465518.593716000000000000 ] >									
283 //        < 0x0000000000000000000000000000000000000000000000000043E76F14654878 >									
284 //     < EUROSIBENERGO_PFXXI_II_metadata_line_28_____Eurosibenergo_LLC_distributed_gen_NIZHEGORODSKIY_20240321 >									
285 //        < pP36dQ076Fp30I41Siiex6T6m3d6r2Bw44Y0Jk1SaUu0JojKuDjV4ij2z71Tx4K2 >									
286 //        <  u =="0.000000000000000001" : ] 000000737465518.593716000000000000 ; 000000768830329.900089000000000000 ] >									
287 //        < 0x0000000000000000000000000000000000000000000000000046548784952459 >									
288 //     < EUROSIBENERGO_PFXXI_II_metadata_line_29_____Angara_Yenisei_org_spe_20240321 >									
289 //        < igkF795N1k25Ng8PfnHYpS3gZ0xYw9ZB269750k85W2y7t1GdWhkq8FtZuCp6O90 >									
290 //        <  u =="0.000000000000000001" : ] 000000768830329.900089000000000000 ; 000000791960217.748539000000000000 ] >									
291 //        < 0x0000000000000000000000000000000000000000000000000049524594B86F76 >									
292 //     < EUROSIBENERGO_PFXXI_II_metadata_line_30_____Yuzhno_Yeniseisk_org_spe_20240321 >									
293 //        < e8z0tGzD27qNxA420ciLFlh0Cqk27wPeVvp2hV7c8dsE3tayr47qZl48Q19ko30Z >									
294 //        <  u =="0.000000000000000001" : ] 000000791960217.748539000000000000 ; 000000829914811.828960000000000000 ] >									
295 //        < 0x000000000000000000000000000000000000000000000000004B86F764F25979 >									
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
326 // Programme d'émission - Lignes 31 à 40									
327 //									
328 //									
329 //									
330 //									
331 //     [ Nom du portefeuille ; Numéro de la ligne ; Nom de la ligne ; Echéance ]									
332 //         [ Adresse exportée ]									
333 //         [ Unité ; Limite basse ; Limite haute ]									
334 //         [ Hex ]									
335 //									
336 //									
337 //									
338 //     < EUROSIBENERGO_PFXXI_II_metadata_line_31_____Teploseti_LLC_20240321 >									
339 //        < kPeEJvN5fQP29406N1Hd9V15NiPw8H1Q086o7X13vmfgA6gXE904OPK69RBxM6x0 >									
340 //        <  u =="0.000000000000000001" : ] 000000829914811.828960000000000000 ; 000000854918985.906999000000000000 ] >									
341 //        < 0x000000000000000000000000000000000000000000000000004F2597951880BB >									
342 //     < EUROSIBENERGO_PFXXI_II_metadata_line_32_____Eurosibenergo_Engineering_LLC_20240321 >									
343 //        < RKsr3DC3smRceq0TLo41Pji65khPiDes2VyKcrZ3eJK6ADenx7q6MOgl6813wKqg >									
344 //        <  u =="0.000000000000000001" : ] 000000854918985.906999000000000000 ; 000000873375690.246058000000000000 ] >									
345 //        < 0x0000000000000000000000000000000000000000000000000051880BB534AA61 >									
346 //     < EUROSIBENERGO_PFXXI_II_metadata_line_33_____EurosibPower_Engineering_20240321 >									
347 //        < Qq7vpk2Mi30V6gGgRBWgcHIJsJ4dT7gC1FYj1p93bsDKiOHfOWjj7Znmh8TLY95p >									
348 //        <  u =="0.000000000000000001" : ] 000000873375690.246058000000000000 ; 000000908653756.427090000000000000 ] >									
349 //        < 0x00000000000000000000000000000000000000000000000000534AA6156A7EE0 >									
350 //     < EUROSIBENERGO_PFXXI_II_metadata_line_34_____Eurosibenergo_hydrogeneration_LLC_20240321 >									
351 //        < Lo1TXDHc9E1tl5duY6TL9Vh48Xy7sQI543O9vv8Ah9RWLzFR11vTsNXq6ITZLcDt >									
352 //        <  u =="0.000000000000000001" : ] 000000908653756.427090000000000000 ; 000000937310600.217824000000000000 ] >									
353 //        < 0x0000000000000000000000000000000000000000000000000056A7EE059638F4 >									
354 //     < EUROSIBENERGO_PFXXI_II_metadata_line_35_____Mostootryad_org_spe_20240321 >									
355 //        < O7814XxhIf942tjDRZM3W8dbsEivYLnwyYayxLH9vV5x7eLTy0bxNMu45A06IYmO >									
356 //        <  u =="0.000000000000000001" : ] 000000937310600.217824000000000000 ; 000000961439038.467975000000000000 ] >									
357 //        < 0x0000000000000000000000000000000000000000000000000059638F45BB0A20 >									
358 //     < EUROSIBENERGO_PFXXI_II_metadata_line_36_____Irkutskenergoremont_CJSC_20240321 >									
359 //        < D4BBVfF3a2KBzIFZjL5v5qP12219zbFajLK1k219548B7JejAkhmA7L8VMJ6uVTp >									
360 //        <  u =="0.000000000000000001" : ] 000000961439038.467975000000000000 ; 000000982639774.409360000000000000 ] >									
361 //        < 0x000000000000000000000000000000000000000000000000005BB0A205DB63A9 >									
362 //     < EUROSIBENERGO_PFXXI_II_metadata_line_37_____Irkutsk_Energy_Retail_20240321 >									
363 //        < DgOv63f5FNyoQPM12rJdLyTLWhO3R71Pr460vt62aS01ZP4hmG695f81kJ63n5Ij >									
364 //        <  u =="0.000000000000000001" : ] 000000982639774.409360000000000000 ; 000001002722560.777030000000000000 ] >									
365 //        < 0x000000000000000000000000000000000000000000000000005DB63A95FA0880 >									
366 //     < EUROSIBENERGO_PFXXI_II_metadata_line_38_____Iirkutskenergo_PCI_Irkutsk_20240321 >									
367 //        < g8G03x63gZkE0P74mw2y3761SKPu930J16TM477QWAEyvpOOh9JWF6q658TSVz0U >									
368 //        <  u =="0.000000000000000001" : ] 000001002722560.777030000000000000 ; 000001027360966.716990000000000000 ] >									
369 //        < 0x000000000000000000000000000000000000000000000000005FA088061FA0E1 >									
370 //     < EUROSIBENERGO_PFXXI_II_metadata_line_39_____Iirkutskenergo_Irkutsk_org_spe_20240321 >									
371 //        < b2O6vQk00s3LPdX19tyr1veLeLqSD8y4Ro5V70Ble6PsCA8dt4YH1FA9Wwy3R56X >									
372 //        <  u =="0.000000000000000001" : ] 000001027360966.716990000000000000 ; 000001045788636.762810000000000000 ] >									
373 //        < 0x0000000000000000000000000000000000000000000000000061FA0E163BBF30 >									
374 //     < EUROSIBENERGO_PFXXI_II_metadata_line_40_____Monchegorskaya_org_spe_20240321 >									
375 //        < o25aR5S2rmXZ6kHOfr2x0KiNViNL6QbUvANy4623WHb8b5yVEhYaeFPqc6Y4bzux >									
376 //        <  u =="0.000000000000000001" : ] 000001045788636.762810000000000000 ; 000001067296706.080140000000000000 ] >									
377 //        < 0x0000000000000000000000000000000000000000000000000063BBF3065C90C7 >									
378 									
379 }