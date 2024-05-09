1 pragma solidity 		^0.4.25	;						
2 										
3 	contract	MELNI_PFX_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	MELNI_PFX_I_883		"	;
8 		string	public		symbol =	"	MELNI_PFX_I_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		540197695684682000000000000					;	
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
92 	//     < MELNI_PFX_I_metadata_line_1_____A_Melnichenko_pp_org_20220316 >									
93 	//        < 4wAlxxRL8YejM9reeJGNnMy8H0048IB48Intd67PXjZiRbxYb96YvCPEw08jG7Za >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000015187159.964075100000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000002036AF >									
96 	//     < MELNI_PFX_I_metadata_line_2_____ASY_admin_org_20220316 >									
97 	//        < vLog9zJVoJfaL2XL52Erxjes1qmmatpVRQ7kGIJ7Ih73uuJFT4K2OBkr4tb501V6 >									
98 	//        <  u =="0.000000000000000001" : ] 000000015187159.964075100000000000 ; 000000026207604.513039600000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000002036AF3A3B40 >									
100 	//     < MELNI_PFX_I_metadata_line_3_____AMY_admin_org_20220316 >									
101 	//        < Gg7YaYu1XUarcXb7uoUt6o0Zy27Y4Pcae2Wc149E8Cu7pl3F7eQ4UG04CQzX2SAU >									
102 	//        <  u =="0.000000000000000001" : ] 000000026207604.513039600000000000 ; 000000037160095.146792500000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000003A3B40534BF6 >									
104 	//     < MELNI_PFX_I_metadata_line_4_____ASY_infra_org_20220316 >									
105 	//        < YTTViiHq6ONK6yl796i67pVVe87Q8177f7aV6sWHvXF6bYxwimM122AuSC0KrVS1 >									
106 	//        <  u =="0.000000000000000001" : ] 000000037160095.146792500000000000 ; 000000052369317.680936300000000000 ] >									
107 	//        < 0x0000000000000000000000000000000000000000000000000000534BF672AC51 >									
108 	//     < MELNI_PFX_I_metadata_line_5_____AMY_infra_org_20220316 >									
109 	//        < e4CPNyuu246FQm76HJHT5r7Mj8kHd4DpPlc4zxb0P0zz63w2PyHU1K7B738nqax3 >									
110 	//        <  u =="0.000000000000000001" : ] 000000052369317.680936300000000000 ; 000000064994749.897202200000000000 ] >									
111 	//        < 0x000000000000000000000000000000000000000000000000000072AC51945103 >									
112 	//     < MELNI_PFX_I_metadata_line_6_____Donalink_Holding_Limited_chy_AB_20220316 >									
113 	//        < 7L2gdkI77reNq3UM41xIf80qR1rUSXRpeVA88WJ973Qz4V2K18Mu1v7fzW9vDGq3 >									
114 	//        <  u =="0.000000000000000001" : ] 000000064994749.897202200000000000 ; 000000078262225.166830200000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000945103B5C94E >									
116 	//     < MELNI_PFX_I_metadata_line_7_____Donalink_Holding_org_russ_PL_20220316 >									
117 	//        < tiRkVHWJkB6JP7x6S0r22k6Uc5mFV2u5faSwX7Oa73H3vsN2q2X7QY5PnBHK0aMD >									
118 	//        <  u =="0.000000000000000001" : ] 000000078262225.166830200000000000 ; 000000090554316.787551300000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000B5C94EDA2D33 >									
120 	//     < MELNI_PFX_I_metadata_line_8_____Russky_Vlad_RSO_admin_org_20220316 >									
121 	//        < 7NC6N7m5lJ65c0Iml8jl1873sGVOpb664MW8XbcC7Q0i9F5R5An5phvWS55rLl5D >									
122 	//        <  u =="0.000000000000000001" : ] 000000090554316.787551300000000000 ; 000000102659530.309909000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000DA2D33EF3B03 >									
124 	//     < MELNI_PFX_I_metadata_line_9_____RVR_ITB_garantia_org_20220316 >									
125 	//        < 3hzvy6w7r0TkA14HzoUGPv5Vc9Dj3gKMX48z520Yh84NPb6m5mhTz2wR597tocbb >									
126 	//        <  u =="0.000000000000000001" : ] 000000102659530.309909000000000000 ; 000000116989886.485003000000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000000EF3B0310B2D65 >									
128 	//     < MELNI_PFX_I_metadata_line_10_____RVR_ITN3_garantia_org_20220316 >									
129 	//        < Gt81vj1AP1K15UZ90d61V0H2wLcua6Pb8Pg4p0uzf8kXD1lFhE348226FS3XbBj0 >									
130 	//        <  u =="0.000000000000000001" : ] 000000116989886.485003000000000000 ; 000000130371825.089112000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000010B2D6512BAC2C >									
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
174 	//     < MELNI_PFX_I_metadata_line_11_____RVR_LeChiffre_garantia_org_20220316 >									
175 	//        < 09M4Og7t2WRnsFM8upLz1uQP8B8abHCV3I7Z5b2yEgJ8A78CNx1o9PlR85694tYT >									
176 	//        <  u =="0.000000000000000001" : ] 000000130371825.089112000000000000 ; 000000145458221.637124000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000012BAC2C13F8CAA >									
178 	//     < MELNI_PFX_I_metadata_line_12_____Far_East_Dev_Corp_20220316 >									
179 	//        < 8XxV2Yr8Oi1u7egQYLnfW6wr8Q6gB0WYp7315t3vioDHXW2snWs057K43utC05b6 >									
180 	//        <  u =="0.000000000000000001" : ] 000000145458221.637124000000000000 ; 000000158951860.043123000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000013F8CAA15F80D4 >									
182 	//     < MELNI_PFX_I_metadata_line_13_____Trans_Baïkal_geo_org_20220316 >									
183 	//        < dA65Wtmh74w063qCD876uGn19Cz4b0rNo8D09Nm4xWT2aV490MxT9WGcWdX97pL6 >									
184 	//        <  u =="0.000000000000000001" : ] 000000158951860.043123000000000000 ; 000000170895725.068378000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000015F80D417867EC >									
186 	//     < MELNI_PFX_I_metadata_line_14_____Khabarovsk_geo_org_20220316 >									
187 	//        < NQpVqO1Wj76N9RLq956hfcg0137ujxN8LscpMPAXT7x4T38yEHsI41bgsKb7eUw6 >									
188 	//        <  u =="0.000000000000000001" : ] 000000170895725.068378000000000000 ; 000000186651187.214700000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000017867EC196802A >									
190 	//     < MELNI_PFX_I_metadata_line_15_____Primorsky_geo_org_20220316 >									
191 	//        < 12FOQOx62Vh760a1G2W6p4QI61ld6VB22c23RA8I9DfP3lqjWt4vPKfH5qkclqRt >									
192 	//        <  u =="0.000000000000000001" : ] 000000186651187.214700000000000000 ; 000000200236482.571237000000000000 ] >									
193 	//        < 0x00000000000000000000000000000000000000000000000000196802A1AE760A >									
194 	//     < MELNI_PFX_I_metadata_line_16_____Vanino_infra_org_20220316 >									
195 	//        < JuS1sYV86Ff4jG2r233zl5XkbfKCkI7x1eXWxST1hqsLdQjx4G2IYdTt8r5LSMda >									
196 	//        <  u =="0.000000000000000001" : ] 000000200236482.571237000000000000 ; 000000214475885.067856000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000001AE760A1D48683 >									
198 	//     < MELNI_PFX_I_metadata_line_17_____Nakhodka_infra_org_20220316 >									
199 	//        < y10M0dD04LBumlyT5g76ksAr1Z7W5sH3143a6fgE5iAqf1qV93uR1IKkZ4DAd49b >									
200 	//        <  u =="0.000000000000000001" : ] 000000214475885.067856000000000000 ; 000000229251916.681239000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000001D486831F66B68 >									
202 	//     < MELNI_PFX_I_metadata_line_18_____Primorsky_meta_infra_org_20220316 >									
203 	//        < 8cS2Hx2g00pD1siw662ksS5EE1o6X55i7pr9vzIX31Tx3MFxwTf2Z4jN58UKz7ko >									
204 	//        <  u =="0.000000000000000001" : ] 000000229251916.681239000000000000 ; 000000240260026.240049000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000001F66B68213B8AB >									
206 	//     < MELNI_PFX_I_metadata_line_19_____Siberian_Coal_Energy_Company_SUEK_20220316 >									
207 	//        < o6M5D1oxs8w0a1ArSPQ3708RS5WEPS9x6oGXOI4fV6G38pMH9xG2W13ziI1u5AIL >									
208 	//        <  u =="0.000000000000000001" : ] 000000240260026.240049000000000000 ; 000000252561106.996743000000000000 ] >									
209 	//        < 0x00000000000000000000000000000000000000000000000000213B8AB22AF193 >									
210 	//     < MELNI_PFX_I_metadata_line_20_____Siberian_Generating_Company_SGC_20220316 >									
211 	//        < c0YO446wg5p0F77Xcu17V19J3T347gYULU6opfaVmfdmN1Btx5C97J3kRKLd3bI8 >									
212 	//        <  u =="0.000000000000000001" : ] 000000252561106.996743000000000000 ; 000000266580211.204870000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000022AF193245A639 >									
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
256 	//     < MELNI_PFX_I_metadata_line_21_____Yenisei_Territorial_Generating_Company_TGC_20220316 >									
257 	//        < DK17YGeBsS9MZg5vZnbRk3avKOd7BBqm771H232hCA01fAB8sYtSfnRHwdb74jN8 >									
258 	//        <  u =="0.000000000000000001" : ] 000000266580211.204870000000000000 ; 000000278745412.452218000000000000 ] >									
259 	//        < 0x00000000000000000000000000000000000000000000000000245A63925BAD54 >									
260 	//     < MELNI_PFX_I_metadata_line_22_____AIM_Capital_SE_20220316 >									
261 	//        < 3aiPMJX14z9sVr8xh15v0DVU36PnHhkRYamPJ8tG66VFFIaPE3U6Tp9p3ly1Z1pL >									
262 	//        <  u =="0.000000000000000001" : ] 000000278745412.452218000000000000 ; 000000292329336.362616000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000025BAD542722899 >									
264 	//     < MELNI_PFX_I_metadata_line_23_____Eurochem_group_evrokhim_20220316 >									
265 	//        < kQPd6Ozb1yPyM56t832D6nd9JIHDgSW37U2xbLZ65JzkOGS1O5XPIp6NE628278w >									
266 	//        <  u =="0.000000000000000001" : ] 000000292329336.362616000000000000 ; 000000304659756.078120000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000027228992962E67 >									
268 	//     < MELNI_PFX_I_metadata_line_24_____Kovdor_org_20220316 >									
269 	//        < Qyi9Id2QPzng14WCGo9f1Rsspc3405l7loLgT5H5z28q09JWFUNm4UA8QFIE5V25 >									
270 	//        <  u =="0.000000000000000001" : ] 000000304659756.078120000000000000 ; 000000319851614.752830000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000002962E672B6E413 >									
272 	//     < MELNI_PFX_I_metadata_line_25_____OJSC_Murmansk_Commercial_Seaport_20220316 >									
273 	//        < EN1VE74GLM71k7E2KKqAseN2gJC7l1k1g61u32iB70Ifjni95dEu8HuBeYBk8Fc4 >									
274 	//        <  u =="0.000000000000000001" : ] 000000319851614.752830000000000000 ; 000000332430118.039620000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002B6E4132CC4D79 >									
276 	//     < MELNI_PFX_I_metadata_line_26_____BASF_Antwerpen_AB_20220316 >									
277 	//        < pX4f7q04E0S7q8WJ70VM35QraO9zp7VbI4eO8OB5keR7P876l932aYoP6dx6CGfT >									
278 	//        <  u =="0.000000000000000001" : ] 000000332430118.039620000000000000 ; 000000347107051.939770000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000002CC4D792EE7B73 >									
280 	//     < MELNI_PFX_I_metadata_line_27_____Eurochem_Antwerpen_20220316 >									
281 	//        < sHRCi0VL2J3wCZ47e6ar7s3h634evX2B7BUxClB2WTuWQbixdw2mD0d3vaATD5na >									
282 	//        <  u =="0.000000000000000001" : ] 000000347107051.939770000000000000 ; 000000363466285.193954000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000002EE7B73302CCDF >									
284 	//     < MELNI_PFX_I_metadata_line_28_____Eurochem_Agro_20220316 >									
285 	//        < m05qevbrW5ZD0WqsqG2pDPYebwm6Vzh7lQ91ydbXHoI3z67e6aYHc6Yvv726YQM7 >									
286 	//        <  u =="0.000000000000000001" : ] 000000363466285.193954000000000000 ; 000000375843462.287740000000000000 ] >									
287 	//        < 0x00000000000000000000000000000000000000000000000000302CCDF323E362 >									
288 	//     < MELNI_PFX_I_metadata_line_29_____Mannheimer_KplusS_AB_20220316 >									
289 	//        < 5tM84EGp4Giht71tY1sCn220VxJ3wz4444dFKwJns4eCPQ3jOFI7rFG0891M2RFO >									
290 	//        <  u =="0.000000000000000001" : ] 000000375843462.287740000000000000 ; 000000389996629.813588000000000000 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000000000323E36234283AC >									
292 	//     < MELNI_PFX_I_metadata_line_30_____Iamali_Severneft_Ourengoi_20220316 >									
293 	//        < 5nElB6ya4J7u3PBQ0Mr96ShPm5jx0XW1I96dO7K55i1l7NcYG5ZapyEcYuOm2586 >									
294 	//        <  u =="0.000000000000000001" : ] 000000389996629.813588000000000000 ; 000000401016376.610176000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000034283AC361C656 >									
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
338 	//     < MELNI_PFX_I_metadata_line_31_____Djambouli_SORL_kazakhe_Sary_Tas_20220316 >									
339 	//        < 4k5YaOtKx7nq4hdF9JD1Hn9Q92z65rs3L34K8C4Mlya4uyYxqq1MBlP9Fmabi016 >									
340 	//        <  u =="0.000000000000000001" : ] 000000401016376.610176000000000000 ; 000000416910681.494338000000000000 ] >									
341 	//        < 0x00000000000000000000000000000000000000000000000000361C6563773667 >									
342 	//     < MELNI_PFX_I_metadata_line_32_____Tyance_org_20220316 >									
343 	//        < NbhC1yqEnvmcFn2eA520i1I8l6qt8Y6Ci6c4PAp9R4i8RbQfLtn3scnCn4c4chUU >									
344 	//        <  u =="0.000000000000000001" : ] 000000416910681.494338000000000000 ; 000000432789657.119058000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000003773667392C58E >									
346 	//     < MELNI_PFX_I_metadata_line_33_____Tyance_Climat_org_20220316 >									
347 	//        < 6O8Pe4b611o0Jy3qnoz9P4q70ZKQsY407Wg9x9Nw877QoS6jq373o3nf44MkPb23 >									
348 	//        <  u =="0.000000000000000001" : ] 000000432789657.119058000000000000 ; 000000444560755.813150000000000000 ] >									
349 	//        < 0x00000000000000000000000000000000000000000000000000392C58E3ACE099 >									
350 	//     < MELNI_PFX_I_metadata_line_34_____Rospotrebnadzor_org_20220316 >									
351 	//        < 0V61ZWWyYn8aV16xW7l68QJNcbli6BncWNCExXyvpk05f17lVU3B4c5yf16R74j7 >									
352 	//        <  u =="0.000000000000000001" : ] 000000444560755.813150000000000000 ; 000000456063099.797014000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000003ACE0993D14043 >									
354 	//     < MELNI_PFX_I_metadata_line_35_____Kinguissepp_Eurochem_infra_org_20220316 >									
355 	//        < Y6th8ZS22kP5p9SHNhqQZvt350XO5u13a1433PwJS82YRk3RCtJOz60KjjPg7g6H >									
356 	//        <  u =="0.000000000000000001" : ] 000000456063099.797014000000000000 ; 000000468786282.362664000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000003D140433E7EF64 >									
358 	//     < MELNI_PFX_I_metadata_line_36_____Louga_EUrochem_infra_org_20220316 >									
359 	//        < cIwX690X6vL44Id1e16X38U3OH3883EcXPj3xo27vBW4J5ZZHZuVU817m249a9wt >									
360 	//        <  u =="0.000000000000000001" : ] 000000468786282.362664000000000000 ; 000000481189273.216838000000000000 ] >									
361 	//        < 0x000000000000000000000000000000000000000000000000003E7EF644062E18 >									
362 	//     < MELNI_PFX_I_metadata_line_37_____Finnish_Environment_Institute_org_20220316 >									
363 	//        < ku5n9fkGKbjP13jPE48IH165FE6fGDaS5GGA776F17c7z4wC0m4clRZymSk6249y >									
364 	//        <  u =="0.000000000000000001" : ] 000000481189273.216838000000000000 ; 000000497191691.985388000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000004062E1842008EB >									
366 	//     < MELNI_PFX_I_metadata_line_38_____Helcom_org_20220316 >									
367 	//        < mE9A548UCD6zeA0YaPEmu6y437oxSH9AlPLnC7i081P0b282Vuo5u8g1aFU8rkBY >									
368 	//        <  u =="0.000000000000000001" : ] 000000497191691.985388000000000000 ; 000000511179643.382399000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000042008EB437DAA0 >									
370 	//     < MELNI_PFX_I_metadata_line_39_____Eurochem_Baltic_geo_org_20220316 >									
371 	//        < dDdVQ43O95W9gX6ys993Gj9GS770733knK9k3fCc0j10MpQMONs1hw7h0haA43R1 >									
372 	//        <  u =="0.000000000000000001" : ] 000000511179643.382399000000000000 ; 000000524783066.538546000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000437DAA0451DCC3 >									
374 	//     < MELNI_PFX_I_metadata_line_40_____John_Nurminen_Stiftung_org_20220316 >									
375 	//        < L049X4xDXlCo26b3W5F1a9GK61eV1iqGh79kC2F0AU8y7ub3Vmf7P3FUaiJ67D02 >									
376 	//        <  u =="0.000000000000000001" : ] 000000524783066.538546000000000000 ; 000000540197695.684683000000000000 ] >									
377 	//        < 0x00000000000000000000000000000000000000000000000000451DCC34769FB1 >									
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