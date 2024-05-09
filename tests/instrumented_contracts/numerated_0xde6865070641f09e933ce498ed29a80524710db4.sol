1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXI_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXI_III_883		"	;
8 		string	public		symbol =	"	RUSS_PFXI_III_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1054250897049520000000000000					;	
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
92 	//     < RUSS_PFXI_III_metadata_line_1_____STRAKHOVOI_SINDIKAT_20251101 >									
93 	//        < Z427SCGN33dB199Xhe260jf91XrZOD8D01ONCCainQ7I4u0F7L0XH8k47sS2C0A4 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000018791631.614103000000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000001CAC7B >									
96 	//     < RUSS_PFXI_III_metadata_line_2_____MIKA_RG_20251101 >									
97 	//        < 8k0T2m75Vp4LzDQ1FRZbrZ7Y3S91UMXXZxoU1GO1UXSso9yDM1H0wBz5B826sOC5 >									
98 	//        <  u =="0.000000000000000001" : ] 000000018791631.614103000000000000 ; 000000042994918.488799100000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000001CAC7B419AE4 >									
100 	//     < RUSS_PFXI_III_metadata_line_3_____RESO_FINANCIAL_MARKETS_20251101 >									
101 	//        < 237Ll9Bn19222L3KqyIkxn1OjR1NsyHYA15mx1iDi19515N8wgAYtGi9ECoycqtL >									
102 	//        <  u =="0.000000000000000001" : ] 000000042994918.488799100000000000 ; 000000064355983.038429800000000000 ] >									
103 	//        < 0x0000000000000000000000000000000000000000000000000000419AE462330E >									
104 	//     < RUSS_PFXI_III_metadata_line_4_____LIPETSK_INSURANCE_CHANCE_20251101 >									
105 	//        < zCdRv27K6YyyPi3I608hC7M9fQ1Qg6585TqiE5QvVl9dnkHS39vplPSgYGY10CEv >									
106 	//        <  u =="0.000000000000000001" : ] 000000064355983.038429800000000000 ; 000000095895714.541865400000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000062330E925343 >									
108 	//     < RUSS_PFXI_III_metadata_line_5_____ALVENA_RESO_GROUP_20251101 >									
109 	//        < 8ArAIs71429r5RcFwHGieaV357bP7ElxG3B7LE7B025mj084r33JV45Vr2B5dEoR >									
110 	//        <  u =="0.000000000000000001" : ] 000000095895714.541865400000000000 ; 000000117704289.101458000000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000925343B39A3D >									
112 	//     < RUSS_PFXI_III_metadata_line_6_____NADEZHNAYA_LIFE_INSURANCE_20251101 >									
113 	//        < cq4nLUzi5wbysHgwJcJ68x1ahb6U1d6s7iqMWE20831462M5K1y8C9X6J9Qg6O67 >									
114 	//        <  u =="0.000000000000000001" : ] 000000117704289.101458000000000000 ; 000000141238516.574863000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000B39A3DD7834C >									
116 	//     < RUSS_PFXI_III_metadata_line_7_____MSK_URALSIB_20251101 >									
117 	//        < zpiytj6N9u5G1E9CH5uKTmYf290H3Qw4kdx0o65b1O92n471P049rmz50BWSmx2Y >									
118 	//        <  u =="0.000000000000000001" : ] 000000141238516.574863000000000000 ; 000000160400421.065045000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000D7834CF4C06A >									
120 	//     < RUSS_PFXI_III_metadata_line_8_____SMO_SIBERIA_20251101 >									
121 	//        < 340LN455Is0NOUEyOEOFc952jH32MjnOhZqPmfL3z3gsfy0Z0YUq0kR8YtD4LGZZ >									
122 	//        <  u =="0.000000000000000001" : ] 000000160400421.065045000000000000 ; 000000195907563.337607000000000000 ] >									
123 	//        < 0x000000000000000000000000000000000000000000000000000F4C06A12AEE64 >									
124 	//     < RUSS_PFXI_III_metadata_line_9_____ALFASTRAKHOVANIE_LIFE_20251101 >									
125 	//        < pHb0xqEG6W12Jc42fN344TIx38dkTZxAHU3IJmEm6nSa6IcVZz2e32UU9Y9N08ER >									
126 	//        <  u =="0.000000000000000001" : ] 000000195907563.337607000000000000 ; 000000222561990.829425000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000012AEE641539A47 >									
128 	//     < RUSS_PFXI_III_metadata_line_10_____AVERS_OOO_20251101 >									
129 	//        < GazrC35qA10DvDaosQSZShK8246dGE93555fh3pPQ3tL58FZRFtT8Zzg7Jmx6Ulz >									
130 	//        <  u =="0.000000000000000001" : ] 000000222561990.829425000000000000 ; 000000252259030.529030000000000000 ] >									
131 	//        < 0x000000000000000000000000000000000000000000000000001539A47180EAAF >									
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
174 	//     < RUSS_PFXI_III_metadata_line_11_____ALFASTRAKHOVANIE_PLC_20251101 >									
175 	//        < vLKOQ4Z0iz8vUXB55GO6CKZ6iddHK3plX3KKbf0t7Vq9Gb2Z21y2dp7pB5DGSt95 >									
176 	//        <  u =="0.000000000000000001" : ] 000000252259030.529030000000000000 ; 000000287597924.492162000000000000 ] >									
177 	//        < 0x00000000000000000000000000000000000000000000000000180EAAF1B6D6F0 >									
178 	//     < RUSS_PFXI_III_metadata_line_12_____MIDITSINSKAYA_STRAKHOVAYA_KOMP_VIRMED_20251101 >									
179 	//        < 6lk1E6AI9akKPoL15927F2svkZPwoCjeG8ms8Ow0p29NoQul23xq6IV0NrrD64G9 >									
180 	//        <  u =="0.000000000000000001" : ] 000000287597924.492162000000000000 ; 000000316688305.351477000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000001B6D6F01E33A5F >									
182 	//     < RUSS_PFXI_III_metadata_line_13_____MSK_ASSTRA_20251101 >									
183 	//        < gCTSHB4oxf3Nnjv1NXcf2xK6d9796Ar1U1oVvt7wM98JS31zsq7x7u90T57I35M1 >									
184 	//        <  u =="0.000000000000000001" : ] 000000316688305.351477000000000000 ; 000000350943858.541571000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001E33A5F2177F72 >									
186 	//     < RUSS_PFXI_III_metadata_line_14_____AVICOS_AFES_INSURANCE_20251101 >									
187 	//        < y0MVPr2h4omcWygz2KLuVGIZ6d7y551hWvdg80XSPxFpq99gMcFeVLNcqPL01poC >									
188 	//        <  u =="0.000000000000000001" : ] 000000350943858.541571000000000000 ; 000000375297816.316844000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000002177F7223CA8B6 >									
190 	//     < RUSS_PFXI_III_metadata_line_15_____RUSSIA_AGRICULTURAL_BANK_20251101 >									
191 	//        < Vz1IiLFF6lVf68YkO1q295Lk680E4IisFUEL9dIBRHX2mF1tzTuc7fU1sf8jaE7c >									
192 	//        <  u =="0.000000000000000001" : ] 000000375297816.316844000000000000 ; 000000400462653.990943000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000023CA8B62630EB9 >									
194 	//     < RUSS_PFXI_III_metadata_line_16_____BELOGLINSKI_ELEVATOR_20251101 >									
195 	//        < 6r6p48GRy5WNiR5h3t767q9Qi707QBU126dJFHva7o3Pz3E4wkzRuJDe785ZE0Zg >									
196 	//        <  u =="0.000000000000000001" : ] 000000400462653.990943000000000000 ; 000000422276122.264311000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000002630EB9284579C >									
198 	//     < RUSS_PFXI_III_metadata_line_17_____RSHB_CAPITAL_20251101 >									
199 	//        < GIqC0k4Z7V6roVi28J5QOVN8Gn8BRm3S3edZRqQdsbpbSpQ2Jgrp3v7QvhWJv1um >									
200 	//        <  u =="0.000000000000000001" : ] 000000422276122.264311000000000000 ; 000000455422137.440102000000000000 ] >									
201 	//        < 0x00000000000000000000000000000000000000000000000000284579C2B6EB46 >									
202 	//     < RUSS_PFXI_III_metadata_line_18_____ALBASHSKIY_ELEVATOR_20251101 >									
203 	//        < 08OSh68aD8N2t9QK4g7QDl2bBjF3qs0KFJRTEnTo6rMI9iukP2GCkD61DDZ4ZQvz >									
204 	//        <  u =="0.000000000000000001" : ] 000000455422137.440102000000000000 ; 000000473736129.457419000000000000 ] >									
205 	//        < 0x000000000000000000000000000000000000000000000000002B6EB462D2DD2D >									
206 	//     < RUSS_PFXI_III_metadata_line_19_____AGROTORG_TRADING_CO_20251101 >									
207 	//        < 2z3k1e3mekfB8ZTV89IT5oqSk301bdHC9YG5n1TGenG427EKz18mHw9vDl3A5b4V >									
208 	//        <  u =="0.000000000000000001" : ] 000000473736129.457419000000000000 ; 000000496443541.109804000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000002D2DD2D2F58342 >									
210 	//     < RUSS_PFXI_III_metadata_line_20_____HOMIAKOVSKIY_COLD_STORAGE_COMPLEX_20251101 >									
211 	//        < Asf85fYPC7391gLlgSR76m9IR5iq023x5p6BalTHV7B7BZ59DDsJ02UCsMkzDqr7 >									
212 	//        <  u =="0.000000000000000001" : ] 000000496443541.109804000000000000 ; 000000517482204.626121000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000002F583423159D7C >									
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
256 	//     < RUSS_PFXI_III_metadata_line_21_____AGROCREDIT_INFORM_20251101 >									
257 	//        < 2Zc07b2Es0OwzdtGPP3LfuFB9j3suhDPZGchk0DX1313x39l00424FVImS87jvpX >									
258 	//        <  u =="0.000000000000000001" : ] 000000517482204.626121000000000000 ; 000000549407666.262706000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000003159D7C346545F >									
260 	//     < RUSS_PFXI_III_metadata_line_22_____LADOSHSKIY_ELEVATOR_20251101 >									
261 	//        < lEKsPy40z1dQf02hQ0INuJC3ENzvr2Dceo9c7lO85gvny225kDwJWTO4jw2k8G6x >									
262 	//        <  u =="0.000000000000000001" : ] 000000549407666.262706000000000000 ; 000000574414498.927685000000000000 ] >									
263 	//        < 0x00000000000000000000000000000000000000000000000000346545F36C7CAA >									
264 	//     < RUSS_PFXI_III_metadata_line_23_____VELICHKOVSKIY_ELEVATOR_20251101 >									
265 	//        < q38556g8r4Emj28CjYlAXiNXC03dr0skinxNoyBFXkxshG41tI960rsWSK284Q05 >									
266 	//        <  u =="0.000000000000000001" : ] 000000574414498.927685000000000000 ; 000000609994799.835445000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000036C7CAA3A2C738 >									
268 	//     < RUSS_PFXI_III_metadata_line_24_____UMANSKIY_ELEVATOR_20251101 >									
269 	//        < 6tIS2r3Vp58656KA305ep54H7kxTDoKJoYMULrxBVwILQ5km17jcSO9rc099d1Ru >									
270 	//        <  u =="0.000000000000000001" : ] 000000609994799.835445000000000000 ; 000000629128161.610083000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000003A2C7383BFF930 >									
272 	//     < RUSS_PFXI_III_metadata_line_25_____MALOROSSIYSKIY_ELEVATOR_20251101 >									
273 	//        < 1L3iOu2lI5k9Zbw1B0p0U0PNrPJ8yflI1p51b1jaHry08Q798cQ2tqTaZSAb22fS >									
274 	//        <  u =="0.000000000000000001" : ] 000000629128161.610083000000000000 ; 000000652428381.957122000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000003BFF9303E386D6 >									
276 	//     < RUSS_PFXI_III_metadata_line_26_____ROSSELKHOZBANK_DOMINANT_20251101 >									
277 	//        < 1k82e4k96cF390pbgHEcE2u2UlA0IO5Ox51Z03Jcio08ns211ZV7W0DBDxtwEam4 >									
278 	//        <  u =="0.000000000000000001" : ] 000000652428381.957122000000000000 ; 000000685136930.450852000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000003E386D64156F9D >									
280 	//     < RUSS_PFXI_III_metadata_line_27_____RAEVSAKHAR_20251101 >									
281 	//        < UG6PALkiCH9WbzTNsMlu009lrAPq8176wl71pYtaUKZY61743QDU7dGl1qT1uIGt >									
282 	//        <  u =="0.000000000000000001" : ] 000000685136930.450852000000000000 ; 000000720122764.131123000000000000 ] >									
283 	//        < 0x000000000000000000000000000000000000000000000000004156F9D44AD1F4 >									
284 	//     < RUSS_PFXI_III_metadata_line_28_____OPTOVYE_TEKHNOLOGII_20251101 >									
285 	//        < c0gvTbVQaob3f0DYJR9WjT300Iz2pKm78cs4Y9o0XDInF7v57ggUF5iDf68ics0X >									
286 	//        <  u =="0.000000000000000001" : ] 000000720122764.131123000000000000 ; 000000744886673.783332000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000044AD1F44709B5B >									
288 	//     < RUSS_PFXI_III_metadata_line_29_____EYANSKI_ELEVATOR_20251101 >									
289 	//        < 2K3kwJeLb5ig6WKCP9742zQv9xdkq3Y0K9NxLInDUhfjSoaoWOCD47r8N5swlz9y >									
290 	//        <  u =="0.000000000000000001" : ] 000000744886673.783332000000000000 ; 000000770280082.387970000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000004709B5B4975AA8 >									
292 	//     < RUSS_PFXI_III_metadata_line_30_____RUSSIAN_AGRARIAN_FUEL_CO_20251101 >									
293 	//        < V92Nujt1yuqAV8aqfMraX0uusQ8xJk3DLfMpx78LXBZw0cu086wD9gQgKLgW7050 >									
294 	//        <  u =="0.000000000000000001" : ] 000000770280082.387970000000000000 ; 000000803029634.844571000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000004975AA84C95373 >									
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
338 	//     < RUSS_PFXI_III_metadata_line_31_____KHOMYAKOVSKY_KHLADOKOMBINAT_20251101 >									
339 	//        < 38n4riQy77n5zls0fP9A4WPM832hd6boy18XZID3TD9u81zvsx9VKwwm8DC4DdF5 >									
340 	//        <  u =="0.000000000000000001" : ] 000000803029634.844571000000000000 ; 000000830521961.912672000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000004C953734F346A4 >									
342 	//     < RUSS_PFXI_III_metadata_line_32_____STEPNYANSKIY_ELEVATOR_20251101 >									
343 	//        < q195JyzhF0b2o7vYvEunO92W8BE4XrTnWF0q8wciNsDPal96D8B69GoSb0UjfckW >									
344 	//        <  u =="0.000000000000000001" : ] 000000830521961.912672000000000000 ; 000000851579802.792898000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000004F346A4513685C >									
346 	//     < RUSS_PFXI_III_metadata_line_33_____ROVNENSKIY_ELEVATOR_20251101 >									
347 	//        < 1440IQkYBq7Zr40a5XAY1pZos78a72Yq0wF7KCjCi0wq3o069u8Zkj0v28q7z4OW >									
348 	//        <  u =="0.000000000000000001" : ] 000000851579802.792898000000000000 ; 000000872833769.326588000000000000 ] >									
349 	//        < 0x00000000000000000000000000000000000000000000000000513685C533D6B1 >									
350 	//     < RUSS_PFXI_III_metadata_line_34_____KHOMYAKOVSKIY_COLD_STORAGE_FACILITY_20251101 >									
351 	//        < 497ej61xW0q30Vtz2L3gD9DIDRq80T9K40McuGiKoxc3q5984LW90U2GsnXnM99s >									
352 	//        <  u =="0.000000000000000001" : ] 000000872833769.326588000000000000 ; 000000898330901.199223000000000000 ] >									
353 	//        < 0x00000000000000000000000000000000000000000000000000533D6B155ABE82 >									
354 	//     < RUSS_PFXI_III_metadata_line_35_____BRIGANTINA_OOO_20251101 >									
355 	//        < 4kpq7rio1mKlD1I45aVXtx7J3uO1gzWV25A6OwS4a7nJ1Pgsl1zPr0c1P2iV5ODQ >									
356 	//        <  u =="0.000000000000000001" : ] 000000898330901.199223000000000000 ; 000000918538119.473603000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000055ABE8257993F4 >									
358 	//     < RUSS_PFXI_III_metadata_line_36_____RUS_AGRICULTURAL_BANK_AM_ARM_20251101 >									
359 	//        < rqgFaP720cm0C6h1r1J743E5Z14829Q7Rp9007mlKU13i42f2SnID118Lh47f6Mf >									
360 	//        <  u =="0.000000000000000001" : ] 000000918538119.473603000000000000 ; 000000949110249.902403000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000057993F45A83A31 >									
362 	//     < RUSS_PFXI_III_metadata_line_37_____LUZHSKIY_FEEDSTUFF_PLANT_20251101 >									
363 	//        < M3b1F53DRgT6y1YNpvDB2VxTKPSHH0v06WFSl5iwM96ihza6SFuo0xEZQR0i6Y5Z >									
364 	//        <  u =="0.000000000000000001" : ] 000000949110249.902403000000000000 ; 000000976006371.995578000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000005A83A315D1447D >									
366 	//     < RUSS_PFXI_III_metadata_line_38_____LUZHSKIY_MYASOKOMBINAT_20251101 >									
367 	//        < r5IIrHLz4Zpd52WkC1hDAxNB2KPKU6kBoumD0K2ZslCZ8gFt59hG8R2K955oi9Bi >									
368 	//        <  u =="0.000000000000000001" : ] 000000976006371.995578000000000000 ; 000001007007298.976190000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000005D1447D600923A >									
370 	//     < RUSS_PFXI_III_metadata_line_39_____LUGA_FODDER_PLANT_20251101 >									
371 	//        < k2SdL7Z3w21Z9Ygg3dSw51L4D5iFJ8aLWz1vYfXJyVgvcRcOjq9pi398qN9f67X3 >									
372 	//        <  u =="0.000000000000000001" : ] 000001007007298.976190000000000000 ; 000001029145041.049190000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000600923A62259C8 >									
374 	//     < RUSS_PFXI_III_metadata_line_40_____KRILOVSKIY_ELEVATOR_20251101 >									
375 	//        < 3tXTO6vwxVeediWEj2rzPJ84Bni09K25r2I3T7tsf3HIF18Y7DkybxuraGH1grD0 >									
376 	//        <  u =="0.000000000000000001" : ] 000001029145041.049190000000000000 ; 000001054250897.049520000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000062259C8648A8C2 >									
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