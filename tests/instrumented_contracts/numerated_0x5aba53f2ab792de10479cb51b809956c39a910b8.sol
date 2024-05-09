1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	SHERE_PFIV_III_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	SHERE_PFIV_III_883		"	;
8 		string	public		symbol =	"	SHERE_PFIV_III_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		1827925061033140000000000000					;	
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
92 	//     < SHERE_PFIV_III_metadata_line_1_____SHEREMETYEVO_AIRPORT_20260505 >									
93 	//        < v5o8wZZSlhyF861E0mGi0COWpQb5s2aNS2e0ha7MF8SrKqe4FAU9h1GR1Z1BczBm >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000031788649.320781500000000000 ] >									
95 	//        < 0x0000000000000000000000000000000000000000000000000000000000308171 >									
96 	//     < SHERE_PFIV_III_metadata_line_2_____SHEREMETYEVO_INTERNATIONAL_AIRPORT_20260505 >									
97 	//        < v818GDEP0589fXqXK2W2ks6nAfy5LlhwH4BrVCfGccjE4cBZl358lLTLc74UQ5eE >									
98 	//        <  u =="0.000000000000000001" : ] 000000031788649.320781500000000000 ; 000000086093216.053513200000000000 ] >									
99 	//        < 0x0000000000000000000000000000000000000000000000000000308171835E2A >									
100 	//     < SHERE_PFIV_III_metadata_line_3_____SHEREMETYEVO_HOLDING_LLC_20260505 >									
101 	//        < Qf9kc0X3XI5sVJr5f50o8u46zzv6nl28y7fOtHoP4w90LhTYC1oc83YkmNTO0CR8 >									
102 	//        <  u =="0.000000000000000001" : ] 000000086093216.053513200000000000 ; 000000124279893.613134000000000000 ] >									
103 	//        < 0x0000000000000000000000000000000000000000000000000000835E2ABDA2D5 >									
104 	//     < SHERE_PFIV_III_metadata_line_4_____TPS_AVIA_PONOMARENKO_ORG_20260505 >									
105 	//        < kVMK36K9BGL7941PpSxVSfPZ0p8bp24361U71vkubAC71UW45To9GGQud7r3AFq7 >									
106 	//        <  u =="0.000000000000000001" : ] 000000124279893.613134000000000000 ; 000000191601968.141649000000000000 ] >									
107 	//        < 0x000000000000000000000000000000000000000000000000000BDA2D51245C85 >									
108 	//     < SHERE_PFIV_III_metadata_line_5_____TPS_AVIA_SKOROBOGATKO_ORG_20260505 >									
109 	//        < 88K4Y74GvkXh0BgxY9pNhlk6HB30496SDK10i0ofWd283S9pO9o0VRew2n1B51af >									
110 	//        <  u =="0.000000000000000001" : ] 000000191601968.141649000000000000 ; 000000241540007.597447000000000000 ] >									
111 	//        < 0x000000000000000000000000000000000000000000000000001245C851708F91 >									
112 	//     < SHERE_PFIV_III_metadata_line_6_____TPS_AVIA_ROTENBERG_ORG_20260505 >									
113 	//        < MDy6FNj02dtm7fWSBX0qtyYE2bvu2GI9hPl399HQCI1y7ypbN3qJg9aKq8YBE9f2 >									
114 	//        <  u =="0.000000000000000001" : ] 000000241540007.597447000000000000 ; 000000272462457.093749000000000000 ] >									
115 	//        < 0x000000000000000000000000000000000000000000000000001708F9119FBEA6 >									
116 	//     < SHERE_PFIV_III_metadata_line_7_____ROSIMUSHCHESTVO_20260505 >									
117 	//        < Ic7wxM2Qt1CAeW3H65A1AXy96gtsnJKnHB8vr4Mq9p59FyzPc8GRTbcV6AOcvaUz >									
118 	//        <  u =="0.000000000000000001" : ] 000000272462457.093749000000000000 ; 000000323993390.611867000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000019FBEA61EE5FEB >									
120 	//     < SHERE_PFIV_III_metadata_line_8_____VEB_CAPITAL_LLC_20260505 >									
121 	//        < C831P7285E9aEpDV4tc0l3sZwPNyiyS7WZQUUu3rSWh9qjE873E6t06eVvXL2j6Q >									
122 	//        <  u =="0.000000000000000001" : ] 000000323993390.611867000000000000 ; 000000349376721.344945000000000000 ] >									
123 	//        < 0x000000000000000000000000000000000000000000000000001EE5FEB2151B48 >									
124 	//     < SHERE_PFIV_III_metadata_line_9_____FRAPORT_20260505 >									
125 	//        < mIKV38x94m4u63Sw91agfU5yN0JNh0NZLZ360Zgq9sXD220PTI9JAisC812779C2 >									
126 	//        <  u =="0.000000000000000001" : ] 000000349376721.344945000000000000 ; 000000369440833.302454000000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000002151B48233B8D3 >									
128 	//     < SHERE_PFIV_III_metadata_line_10_____CHANGI_20260505 >									
129 	//        < 665jM33z9tO8YSgXixJT89595XFKP5Zx68eMfJ2DeKtSgSFE05zu9uGgSJ8dR0h1 >									
130 	//        <  u =="0.000000000000000001" : ] 000000369440833.302454000000000000 ; 000000397544405.056692000000000000 ] >									
131 	//        < 0x00000000000000000000000000000000000000000000000000233B8D325E9AC9 >									
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
174 	//     < SHERE_PFIV_III_metadata_line_11_____NORTHERN_CAPITAL_GATEWAY_20260505 >									
175 	//        < 4hLLdaEO23e0VBI088k16BsZlQnoh2fwLtTcG7oJV86fP0G8B17yea69NPYNSTbM >									
176 	//        <  u =="0.000000000000000001" : ] 000000397544405.056692000000000000 ; 000000420748531.367677000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000025E9AC928202E5 >									
178 	//     < SHERE_PFIV_III_metadata_line_12_____BASEL_AERO_20260505 >									
179 	//        < sETVli270rcuMFRJ81RzZS9Q1G6775UAmwJc79j6Hc930n7Fa9aY04xp2TII680y >									
180 	//        <  u =="0.000000000000000001" : ] 000000420748531.367677000000000000 ; 000000486357557.145890000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000028202E52E61F6C >									
182 	//     < SHERE_PFIV_III_metadata_line_13_____SOGAZ_20260505 >									
183 	//        < 7tIhunH1u8YU41dLDKTO7Vg3slEKa1ZUNF47kwpY36122Nyqv4Z5X9ELWvojap0U >									
184 	//        <  u =="0.000000000000000001" : ] 000000486357557.145890000000000000 ; 000000523075745.596949000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000002E61F6C31E2677 >									
186 	//     < SHERE_PFIV_III_metadata_line_14_____NOVI_SAD_20260505 >									
187 	//        < 35AFSP4Q7BKSM2W2xvpF8Fv4D40H7KmlA4kvMc324jm6TKaU4L0hbc4FEU23Kd8r >									
188 	//        <  u =="0.000000000000000001" : ] 000000523075745.596949000000000000 ; 000000572825750.979551000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000031E267736A100F >									
190 	//     < SHERE_PFIV_III_metadata_line_15_____INSURANCE_COMPANY_ALROSA_20260505 >									
191 	//        < MhV4k7n48ak4p31XKd100wiBOK217r56oXL8Vtn63iZvsi0m9mXG8O04Y080V2Q0 >									
192 	//        <  u =="0.000000000000000001" : ] 000000572825750.979551000000000000 ; 000000621107157.786066000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000036A100F3B3BBFC >									
194 	//     < SHERE_PFIV_III_metadata_line_16_____IC_AL_SO_20260505 >									
195 	//        < 5JpFkL6qP0u9wUf66X88k4OC3J9Aw2aCVAcl2LDhcEV6uYcqP736997Y17afY6mV >									
196 	//        <  u =="0.000000000000000001" : ] 000000621107157.786066000000000000 ; 000000639398503.773530000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000003B3BBFC3CFA50A >									
198 	//     < SHERE_PFIV_III_metadata_line_17_____PIPELINE_INSURANCE_COMPANY_20260505 >									
199 	//        < 1rPM4YGo4q74Fr3h81b6ePQrAx75k238gliS36X3xuvb4C6376c0s52vrw1xDZ1J >									
200 	//        <  u =="0.000000000000000001" : ] 000000639398503.773530000000000000 ; 000000704599959.434800000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000003CFA50A433225C >									
202 	//     < SHERE_PFIV_III_metadata_line_18_____SOGAZ_MED_20260505 >									
203 	//        < Ixj7DyWk87gnCCX5vp1l0JdqmrcHxlz631P7M7F2eks37Qq2tmn1s5WZdwIhdEA2 >									
204 	//        <  u =="0.000000000000000001" : ] 000000704599959.434800000000000000 ; 000000732463815.728719000000000000 ] >									
205 	//        < 0x00000000000000000000000000000000000000000000000000433225C45DA6AE >									
206 	//     < SHERE_PFIV_III_metadata_line_19_____IC_TRANSNEFT_20260505 >									
207 	//        < lohw75G147ktIxS2J2C85dN97aUoTRT8B3dr7sH7l274yWcdUUODZ7oO3lsbdWwl >									
208 	//        <  u =="0.000000000000000001" : ] 000000732463815.728719000000000000 ; 000000753608805.268278000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000000045DA6AE47DEA71 >									
210 	//     < SHERE_PFIV_III_metadata_line_20_____SHEKSNA_20260505 >									
211 	//        < 1MSCeC5eu3de41u682yZ0G74U6XKl4iC1AK8zXce51GXuD22Od2D8tyBPEpCXVOY >									
212 	//        <  u =="0.000000000000000001" : ] 000000753608805.268278000000000000 ; 000000842793473.315053000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000047DEA715060033 >									
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
256 	//     < SHERE_PFIV_III_metadata_line_21_____Akcionarsko Drustvo Zaosiguranje_20260505 >									
257 	//        < in5ko6ZA2Ux157PyYM6V6BSpMIw7r79GK4CYFp94OK6J0S066H5o2Dy210j0VV57 >									
258 	//        <  u =="0.000000000000000001" : ] 000000842793473.315053000000000000 ; 000000867760599.713769000000000000 ] >									
259 	//        < 0x00000000000000000000000000000000000000000000000000506003352C18FC >									
260 	//     < SHERE_PFIV_III_metadata_line_22_____SOGAZ_LIFE_20260505 >									
261 	//        < 3O44NRA4O7Rn6B7w4ghaMpHMRXD4t7gj3VLLfM82zV7QQkc805yD03uSJx39LJIy >									
262 	//        <  u =="0.000000000000000001" : ] 000000867760599.713769000000000000 ; 000000895067630.698074000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000052C18FC555C3CB >									
264 	//     < SHERE_PFIV_III_metadata_line_23_____SOGAZ_SERBIA_20260505 >									
265 	//        < 1TkYIce92rC6o22190kVSAHEqZx7ND6viq4I3Z9gB6CsuUSx24Q727nJa3yKlbg6 >									
266 	//        <  u =="0.000000000000000001" : ] 000000895067630.698074000000000000 ; 000000921868940.914353000000000000 ] >									
267 	//        < 0x00000000000000000000000000000000000000000000000000555C3CB57EA90E >									
268 	//     < SHERE_PFIV_III_metadata_line_24_____ZHASO_20260505 >									
269 	//        < HNGQ4US9T66gnphrG76Q7fz0fe18AJy265wk15BQO5FDevhjM8Hf948F0anylPi7 >									
270 	//        <  u =="0.000000000000000001" : ] 000000921868940.914353000000000000 ; 000000968489918.742412000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000057EA90E5C5CC60 >									
272 	//     < SHERE_PFIV_III_metadata_line_25_____VTB_INSURANCE_ORG_20260505 >									
273 	//        < qRPA2BLvsK1257t4WHsFpwQ8IZaLF1oYnxGNxBZ9o2ObRmCgxN0T8jELvrwmD47u >									
274 	//        <  u =="0.000000000000000001" : ] 000000968489918.742412000000000000 ; 000001019095073.648170000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000005C5CC606130403 >									
276 	//     < SHERE_PFIV_III_metadata_line_26_____Vympel_Vostok_20260505 >									
277 	//        < I767XtllA21aX6fjpOyOvNs7xjBo5UgA9Op2JlblZ8GagSbRc2UG0vlVGMefANvl >									
278 	//        <  u =="0.000000000000000001" : ] 000001019095073.648170000000000000 ; 000001064159202.064700000000000000 ] >									
279 	//        < 0x000000000000000000000000000000000000000000000000006130403657C730 >									
280 	//     < SHERE_PFIV_III_metadata_line_27_____Oblatsnaya_Meditsinskaya_Strakho__20260505 >									
281 	//        < lQYXVIHGz2AC22uU6RQZO1EBheX8PA51npUHKTakSmMj9Kyvlf99Vk00Un383fWW >									
282 	//        <  u =="0.000000000000000001" : ] 000001064159202.064700000000000000 ; 000001109210927.186800000000000000 ] >									
283 	//        < 0x00000000000000000000000000000000000000000000000000657C73069C8585 >									
284 	//     < SHERE_PFIV_III_metadata_line_28_____Medika_Tomsk_20260505 >									
285 	//        < h28DN4p446nGNB2fT9Ak07BxV3rC87t2B56lC9C7d3jmge2S4y1D9Q4xeKVv2mhJ >									
286 	//        <  u =="0.000000000000000001" : ] 000001109210927.186800000000000000 ; 000001174423511.605880000000000000 ] >									
287 	//        < 0x0000000000000000000000000000000000000000000000000069C8585700072F >									
288 	//     < SHERE_PFIV_III_metadata_line_29_____Medical_Insurance_Company_20260505 >									
289 	//        < gi2G2c4hhPU55XT7A4zIH6043HJDhZ9kvT41K6IiSLc3oIYKpfFLZjqG39aXw154 >									
290 	//        <  u =="0.000000000000000001" : ] 000001174423511.605880000000000000 ; 000001237383469.046330000000000000 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000000000700072F76018EB >									
292 	//     < SHERE_PFIV_III_metadata_line_30_____MSK_MED_20260505 >									
293 	//        < S5nB3lnOUQXpZsJO3snM382R1ceb66S0ve36wa421au06O649ekrCDvsm4yaup9L >									
294 	//        <  u =="0.000000000000000001" : ] 000001237383469.046330000000000000 ; 000001261881997.143200000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000076018EB7857AA8 >									
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
338 	//     < SHERE_PFIV_III_metadata_line_31_____SG_MSK_20260505 >									
339 	//        < E2MmmdS77cD1Ruuo3n2O4Q2iePZA8XTz6IJdWYt31064UQKkX9y8K6n3I2Ms6L50 >									
340 	//        <  u =="0.000000000000000001" : ] 000001261881997.143200000000000000 ; 000001353531853.971640000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000007857AA88115361 >									
342 	//     < SHERE_PFIV_III_metadata_line_32_____ROSNO_MS_20260505 >									
343 	//        < h83R41k5649lL2dKfGij6mSscDhtHC5EOfdsl188sROAwi535DiOjJbNxreO0m7M >									
344 	//        <  u =="0.000000000000000001" : ] 000001353531853.971640000000000000 ; 000001410432493.469590000000000000 ] >									
345 	//        < 0x0000000000000000000000000000000000000000000000000081153618682631 >									
346 	//     < SHERE_PFIV_III_metadata_line_33_____VTB_Life_Insurance_20260505 >									
347 	//        < uGIMjPOkye88ZPzgUabyWT1yCZy0M0np9qmHJFb9VWwr7KtpF3350uvJu18FaP95 >									
348 	//        <  u =="0.000000000000000001" : ] 000001410432493.469590000000000000 ; 000001489195467.548820000000000000 ] >									
349 	//        < 0x0000000000000000000000000000000000000000000000000086826318E054FB >									
350 	//     < SHERE_PFIV_III_metadata_line_34_____Company_Moskovsko__20260505 >									
351 	//        < 93809G9ua0d120XD2YzvVDOsj4nZhLe759Hj7lgi52LA2h5Mux2Ez036GdoeKqe1 >									
352 	//        <  u =="0.000000000000000001" : ] 000001489195467.548820000000000000 ; 000001514933573.801260000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000008E054FB9079AED >									
354 	//     < SHERE_PFIV_III_metadata_line_35_____VTB_Meditsinskoye_Strakho__20260505 >									
355 	//        < J3t7VR4uPzeuGakKcqUlDJ82nmX01VDSB08RtBG0D49YPw2v6rRVJNpVxfr63Ro3 >									
356 	//        <  u =="0.000000000000000001" : ] 000001514933573.801260000000000000 ; 000001545029520.479650000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000009079AED9358728 >									
358 	//     < SHERE_PFIV_III_metadata_line_36_____SPASSKIYE_VOROTA_INSURANCE_GROUP_20260505 >									
359 	//        < UL74X0mpAcrlk721vo7p9Z1ym8Tk0Ut4ru4YZ072jYHIK0Tbs8C8BT2gLm02DlXb >									
360 	//        <  u =="0.000000000000000001" : ] 000001545029520.479650000000000000 ; 000001630146138.876820000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000093587289B767D6 >									
362 	//     < SHERE_PFIV_III_metadata_line_37_____CASCO_MED_INS_20260505 >									
363 	//        < C3tluI6rm8h94JFuhQFeb0fcZ6rPJEK56N2em8YM1XE6DnE30LCKTPIEEK6Jjfw0 >									
364 	//        <  u =="0.000000000000000001" : ] 000001630146138.876820000000000000 ; 000001666378577.855020000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000009B767D69EEB122 >									
366 	//     < SHERE_PFIV_III_metadata_line_38_____SMK_NOVOLIPETSKAYA_20260505 >									
367 	//        < p3PW820vPcTo5v9i6Ts26Uk156r3uEOgFZWcwYU0u2J88Oz7EuoC3pk369b83SV6 >									
368 	//        <  u =="0.000000000000000001" : ] 000001666378577.855020000000000000 ; 000001740943441.103290000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000009EEB122A607808 >									
370 	//     < SHERE_PFIV_III_metadata_line_39_____MOSKOVSKOE_PERETRAKHOVOCHNOE_OBSHESTVO_20260505 >									
371 	//        < 5vtbs2L6lYp0G0dvPbAJcN47a863K1K22WtvDUIiWX3t8KEh3yv7D39oBKr3T78M >									
372 	//        <  u =="0.000000000000000001" : ] 000001740943441.103290000000000000 ; 000001767569670.438950000000000000 ] >									
373 	//        < 0x00000000000000000000000000000000000000000000000000A607808A8918E7 >									
374 	//     < SHERE_PFIV_III_metadata_line_40_____RESO_20260505 >									
375 	//        < m6W7I8QLEyhSTzypB3Eqdz9bAU0817cwnCZ40QfAPk2O0Ijm8w1oKrELq0W4bq8b >									
376 	//        <  u =="0.000000000000000001" : ] 000001767569670.438950000000000000 ; 000001827925061.033140000000000000 ] >									
377 	//        < 0x00000000000000000000000000000000000000000000000000A8918E7AE5313A >									
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