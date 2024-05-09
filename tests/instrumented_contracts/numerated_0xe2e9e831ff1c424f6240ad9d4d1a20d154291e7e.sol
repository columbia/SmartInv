1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	NDRV_PFIII_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	NDRV_PFIII_I_883		"	;
8 		string	public		symbol =	"	NDRV_PFIII_I_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		773897503952870000000000000					;	
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
92 	//     < NDRV_PFIII_I_metadata_line_1_____talanx_20211101 >									
93 	//        < TuzMJmRn9HxgTPJB88bB4t9CF8XVVHU9p1njmZSGVezuM83Yxgh9SF098LFWpwT8 >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000021148422.606223100000000000 ] >									
95 	//        < 0x000000000000000000000000000000000000000000000000000000000020451A >									
96 	//     < NDRV_PFIII_I_metadata_line_2_____hdi haftpflichtverband der deutsch_indus_versicherungsverein gegenseitigkeit_20211101 >									
97 	//        < jcdux7VSlZT66MMik9T9F6DMv2x33IJ1h1CrWhCdfWzSa52k2j5K030Zl7V847Jn >									
98 	//        <  u =="0.000000000000000001" : ] 000000021148422.606223100000000000 ; 000000045844903.391986100000000000 ] >									
99 	//        < 0x000000000000000000000000000000000000000000000000000020451A45F42A >									
100 	//     < NDRV_PFIII_I_metadata_line_3_____hdi global se_20211101 >									
101 	//        < 759i0KGR2Z5P51q9p95qfmMNftz8ZoPZOc7D2Fn8s5H3vs1V3c872c8M0Tbi7MW6 >									
102 	//        <  u =="0.000000000000000001" : ] 000000045844903.391986100000000000 ; 000000071245089.939213400000000000 ] >									
103 	//        < 0x000000000000000000000000000000000000000000000000000045F42A6CB61D >									
104 	//     < NDRV_PFIII_I_metadata_line_4_____hdi global network ag_20211101 >									
105 	//        < 8qJF5A6IAggD6A1L55925AQ5GsijkHbaK2JbgfhtgrOvTRqR15z74H6EN8Hdi7mJ >									
106 	//        <  u =="0.000000000000000001" : ] 000000071245089.939213400000000000 ; 000000086531749.483337300000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000006CB61D840977 >									
108 	//     < NDRV_PFIII_I_metadata_line_5_____hdi global network ag hdi global seguros sa_20211101 >									
109 	//        < dNtpwXP5vaOPsNX2kOH03mD7jib91q9B544oF9Nj4p9I1d5H1OmPAr1HVg2ngT6b >									
110 	//        <  u =="0.000000000000000001" : ] 000000086531749.483337300000000000 ; 000000105440637.070118000000000000 ] >									
111 	//        < 0x0000000000000000000000000000000000000000000000000000840977A0E3C0 >									
112 	//     < NDRV_PFIII_I_metadata_line_6_____hdi global se hdi-gerling industrial insurance company_20211101 >									
113 	//        < 7ChX283G07h33T03MKImqKCl3QnR46O74i0z3Nf8ZXLb6XH3IzPquTLYEA1Ow0PJ >									
114 	//        <  u =="0.000000000000000001" : ] 000000105440637.070118000000000000 ; 000000124792118.012314000000000000 ] >									
115 	//        < 0x0000000000000000000000000000000000000000000000000000A0E3C0BE6AEC >									
116 	//     < NDRV_PFIII_I_metadata_line_7_____hdi_gerling industrial insurance company uk branch_20211101 >									
117 	//        < 3s5vR8Fsy18T8Cto1TUiW885HPcXNG0xv4903K64d352RKOgiYnWt5Ys3DJpcAG4 >									
118 	//        <  u =="0.000000000000000001" : ] 000000124792118.012314000000000000 ; 000000143534413.199357000000000000 ] >									
119 	//        < 0x0000000000000000000000000000000000000000000000000000BE6AECDB0421 >									
120 	//     < NDRV_PFIII_I_metadata_line_8_____hdi global se hdi_gerling de méxico seguros sa_20211101 >									
121 	//        < 5EsyNqbAyz82hffp66w7208xmSnMuPFiS0Yo929498L1yJZr7aK3HJsGGs2u4FM7 >									
122 	//        <  u =="0.000000000000000001" : ] 000000143534413.199357000000000000 ; 000000156639457.286751000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000DB0421EF034A >									
124 	//     < NDRV_PFIII_I_metadata_line_9_____hdi global se spain branch_20211101 >									
125 	//        < k5lB54b3w721HWj7M6cyUXYTj6iF1Ieb2WFbwc8p6Je8whZa64F8v5WF4wZUy3wI >									
126 	//        <  u =="0.000000000000000001" : ] 000000156639457.286751000000000000 ; 000000177687673.494503000000000000 ] >									
127 	//        < 0x000000000000000000000000000000000000000000000000000EF034A10F213F >									
128 	//     < NDRV_PFIII_I_metadata_line_10_____hdi global se nassau verzekering maatschappij nv_20211101 >									
129 	//        < 5f5smNDs7nVAJ6v7ehdW54inN4337aDaSijdabjFf1i2c7UziIyGFT6JGUPFpBd7 >									
130 	//        <  u =="0.000000000000000001" : ] 000000177687673.494503000000000000 ; 000000198824716.845653000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000010F213F12F61E8 >									
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
174 	//     < NDRV_PFIII_I_metadata_line_11_____hdi_gerling industrie versicherung ag_20211101 >									
175 	//        < FNdC6052hK22eVH2OTAp2m9xMw57vU419GimpA19xeP8O4rVxX6MP2y7h9Z28T90 >									
176 	//        <  u =="0.000000000000000001" : ] 000000198824716.845653000000000000 ; 000000216326892.089863000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000012F61E814A16B1 >									
178 	//     < NDRV_PFIII_I_metadata_line_12_____hdi global se gerling norge as_20211101 >									
179 	//        < uZzVGB8c83d6ScJyl1xXK70r9Oj4MNeq8DOo08OM9AP0yI4M8adBnaQh3VxY7hP9 >									
180 	//        <  u =="0.000000000000000001" : ] 000000216326892.089863000000000000 ; 000000240650317.689174000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000014A16B116F3408 >									
182 	//     < NDRV_PFIII_I_metadata_line_13_____hdi_gerling industrie versicherung ag hellas branch_20211101 >									
183 	//        < T9CUVqXxh14SB58tp2y5P1YXOch4sq6MZ4yd5gQqTiJEMaCeR6O5c032tipbNd0F >									
184 	//        <  u =="0.000000000000000001" : ] 000000240650317.689174000000000000 ; 000000266836821.570656000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000016F34081972922 >									
186 	//     < NDRV_PFIII_I_metadata_line_14_____hdi_gerling verzekeringen nv_20211101 >									
187 	//        < 0W7Du2d812u9j9RR2a49q4BBya3l4j8xbs6yyi4RlwJ4wXjVhhP2GY2FQ56R3RH7 >									
188 	//        <  u =="0.000000000000000001" : ] 000000266836821.570656000000000000 ; 000000284556638.409315000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000019729221B232F0 >									
190 	//     < NDRV_PFIII_I_metadata_line_15_____hdi_gerling verzekeringen nv hj roelofs_assuradeuren bv_20211101 >									
191 	//        < qec3vN9aTV56W9dHtoMt5z36531h8EkZZC04PJB2YKYTYU7mS6xa5P8ja3i5GrOd >									
192 	//        <  u =="0.000000000000000001" : ] 000000284556638.409315000000000000 ; 000000306180182.397314000000000000 ] >									
193 	//        < 0x000000000000000000000000000000000000000000000000001B232F01D331A2 >									
194 	//     < NDRV_PFIII_I_metadata_line_16_____hdi global sa ltd_20211101 >									
195 	//        < 6L3n2MPh43QiJJ1AJTTDIeCq5AhXGEbtlrX5LwWq0n8jWEi0E9oi0ZIIsSrO9u80 >									
196 	//        <  u =="0.000000000000000001" : ] 000000306180182.397314000000000000 ; 000000330320711.742780000000000000 ] >									
197 	//        < 0x000000000000000000000000000000000000000000000000001D331A21F80787 >									
198 	//     < NDRV_PFIII_I_metadata_line_17_____Hannover Re_20211101 >									
199 	//        < bp5g8dbesVe032n966PC0S3Uq5G2P6w9P0CQi48cPJY5jmFPrv3Mvv218499y049 >									
200 	//        <  u =="0.000000000000000001" : ] 000000330320711.742780000000000000 ; 000000352033415.376750000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000001F80787219290E >									
202 	//     < NDRV_PFIII_I_metadata_line_18_____hdi versicherung ag_20211101 >									
203 	//        < 2tDnT2xSOfAfAs087R3cwcLW5ubGoeH3eQG0411P0AjI2y015VA1R1sB7u84hq6i >									
204 	//        <  u =="0.000000000000000001" : ] 000000352033415.376750000000000000 ; 000000372310708.227819000000000000 ] >									
205 	//        < 0x00000000000000000000000000000000000000000000000000219290E23819DF >									
206 	//     < NDRV_PFIII_I_metadata_line_19_____talanx asset management gmbh_20211101 >									
207 	//        < WIrLo75GW28kM3Z3ueV3DLrUhezr3qK0L85vJUZdX27I1VJ8tIUXde0cRV7hjaAN >									
208 	//        <  u =="0.000000000000000001" : ] 000000372310708.227819000000000000 ; 000000388189299.216205000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000000023819DF2505472 >									
210 	//     < NDRV_PFIII_I_metadata_line_20_____talanx immobilien management gmbh_20211101 >									
211 	//        < 3n19td1R1UST6Tbdoe70JRy60hw3sYV31uvzHlb393CwJltoj34tyl7s7taD58pg >									
212 	//        <  u =="0.000000000000000001" : ] 000000388189299.216205000000000000 ; 000000403937255.942329000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000025054722685BFE >									
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
256 	//     < NDRV_PFIII_I_metadata_line_21_____talanx ampega investment gmbh_20211101 >									
257 	//        < g2W714Im4URzI7JO7oeyQGfcj2x7E8tTe85KcgQmXFz62g7QdEj00JS0QySF55a2 >									
258 	//        <  u =="0.000000000000000001" : ] 000000403937255.942329000000000000 ; 000000423484465.599918000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000002685BFE2862F9F >									
260 	//     < NDRV_PFIII_I_metadata_line_22_____talanx hdi pensionskasse ag_20211101 >									
261 	//        < Mr061mJJ4xrxn1RIZpLk8RW8NN7lXqnb7uS55ALV3v1Hv0FI0So4pqW3OF5EZmXP >									
262 	//        <  u =="0.000000000000000001" : ] 000000423484465.599918000000000000 ; 000000445699417.851273000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000002862F9F2A81556 >									
264 	//     < NDRV_PFIII_I_metadata_line_23_____talanx international ag_20211101 >									
265 	//        < 77Vhq7mqq3eu3RtXB8FMswhjXs78zPb6FtV3rRf2UGnF2oQo97Gl2ofw1bQZTZ99 >									
266 	//        <  u =="0.000000000000000001" : ] 000000445699417.851273000000000000 ; 000000459175432.046564000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000002A815562BCA567 >									
268 	//     < NDRV_PFIII_I_metadata_line_24_____talanx targo versicherung ag_20211101 >									
269 	//        < ilg5VS0rR9oE2T6V64cVn1QQplkAoktOEanuw7v5NRs6k59BdrgWpW0BzH4j2lGe >									
270 	//        <  u =="0.000000000000000001" : ] 000000459175432.046564000000000000 ; 000000479700484.424463000000000000 ] >									
271 	//        < 0x000000000000000000000000000000000000000000000000002BCA5672DBF700 >									
272 	//     < NDRV_PFIII_I_metadata_line_25_____talanx pb lebensversicherung ag_20211101 >									
273 	//        < da61Qln6i96Z60MQokbix2K5OOiav8j5HYV3noX4k76AH7641dn6dt4sR6BA5du9 >									
274 	//        <  u =="0.000000000000000001" : ] 000000479700484.424463000000000000 ; 000000504725859.313524000000000000 ] >									
275 	//        < 0x000000000000000000000000000000000000000000000000002DBF700302268A >									
276 	//     < NDRV_PFIII_I_metadata_line_26_____talanx targo lebensversicherung ag_20211101 >									
277 	//        < W4Ccj33B00TQkYXabPIZp2jWT92NV1gC6T9q35gbl03Huu6GwxIoQ4q19pSYe71i >									
278 	//        <  u =="0.000000000000000001" : ] 000000504725859.313524000000000000 ; 000000520527700.320618000000000000 ] >									
279 	//        < 0x00000000000000000000000000000000000000000000000000302268A31A4322 >									
280 	//     < NDRV_PFIII_I_metadata_line_27_____talanx hdi global insurance company_20211101 >									
281 	//        < 855v35x08wOxW4sq4yL021wGZ3wEsr0z4ed791534c8XFR3q9K29HLpUmu6B68pa >									
282 	//        <  u =="0.000000000000000001" : ] 000000520527700.320618000000000000 ; 000000540731337.436540000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000031A4322339172E >									
284 	//     < NDRV_PFIII_I_metadata_line_28_____talanx civ life russia_20211101 >									
285 	//        < cXmRxW3R28wtOgXm5kEJ79W55K444DJmgMIawr1S4Tp8ht5h7G8iWju4gZMJnB17 >									
286 	//        <  u =="0.000000000000000001" : ] 000000540731337.436540000000000000 ; 000000558593530.892629000000000000 ] >									
287 	//        < 0x00000000000000000000000000000000000000000000000000339172E3545899 >									
288 	//     < NDRV_PFIII_I_metadata_line_29_____talanx reinsurance ireland limited_20211101 >									
289 	//        < 00M4IIaxer3q2w7108jI27XZa0Yyh5gq1Xw94ZgD4FXkpReKD41I0WW6fic6539l >									
290 	//        <  u =="0.000000000000000001" : ] 000000558593530.892629000000000000 ; 000000575174453.571328000000000000 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000000000354589936DA585 >									
292 	//     < NDRV_PFIII_I_metadata_line_30_____talanx deutschland ag_20211101 >									
293 	//        < wm10ir5st1yBm6T4Vr4e4Secihe6sucVUz9xz0OToh64B0XFiL44hJ62EvZww222 >									
294 	//        <  u =="0.000000000000000001" : ] 000000575174453.571328000000000000 ; 000000595620802.175970000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000036DA58538CD860 >									
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
338 	//     < NDRV_PFIII_I_metadata_line_31_____talanx service ag_20211101 >									
339 	//        < u5mkQS28ziLvxgIG40tH5Yoa82T458W1M9c9WKri9S85604992H13vQweD0c346J >									
340 	//        <  u =="0.000000000000000001" : ] 000000595620802.175970000000000000 ; 000000609175243.024708000000000000 ] >									
341 	//        < 0x0000000000000000000000000000000000000000000000000038CD8603A18714 >									
342 	//     < NDRV_PFIII_I_metadata_line_32_____talanx service ag hdi risk consulting gmbh_20211101 >									
343 	//        < 3Hs1b4sAAXI2uSoUS82Q45VwxQGt0fx1iWAwB4r9cArFO6vB0cKNV7Kk4mwk7n77 >									
344 	//        <  u =="0.000000000000000001" : ] 000000609175243.024708000000000000 ; 000000623934423.745053000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000003A187143B80C62 >									
346 	//     < NDRV_PFIII_I_metadata_line_33_____talanx deutschland bancassurance kundenservice gmbh_20211101 >									
347 	//        < zKE3366208xJHTu8Ku8Yjn6Fo10H7gZFI11P5di1VW6h93RhwlWiV6PHX64aYIhH >									
348 	//        <  u =="0.000000000000000001" : ] 000000623934423.745053000000000000 ; 000000638615583.539703000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000003B80C623CE7336 >									
350 	//     < NDRV_PFIII_I_metadata_line_34_____magyar posta eletbiztosito zrt_20211101 >									
351 	//        < CTBP8jv03acDMOiiYD5W5arqcfoW3EErcW0Ql3y6H738KG4B9DM2D60m3wh3h9ZE >									
352 	//        <  u =="0.000000000000000001" : ] 000000638615583.539703000000000000 ; 000000653950621.042392000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000003CE73363E5D976 >									
354 	//     < NDRV_PFIII_I_metadata_line_35_____magyar posta biztosito zrt_20211101 >									
355 	//        < QH3U1m91278jZD1QOtLXY2TVE4b30n7Gn3v7s894OQ9LptuNTcu1BZ0cRw3LT58s >									
356 	//        <  u =="0.000000000000000001" : ] 000000653950621.042392000000000000 ; 000000669301477.294780000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000003E5D9763FD45E4 >									
358 	//     < NDRV_PFIII_I_metadata_line_36_____civ hayat sigorta as_20211101 >									
359 	//        < 8BHcS1tawnTvm5GjyE4XB1AVetFe22y7OBg09rWI1Oq68vgqVEuEIIGDU3uw4L1T >									
360 	//        <  u =="0.000000000000000001" : ] 000000669301477.294780000000000000 ; 000000695081584.636501000000000000 ] >									
361 	//        < 0x000000000000000000000000000000000000000000000000003FD45E44249C3E >									
362 	//     < NDRV_PFIII_I_metadata_line_37_____lifestyle protection lebensversicherung ag_20211101 >									
363 	//        < c9AykXuCVpaP6wnKRCtFKiJHC2M0if49lW146Kdq76jzOFwU8U4rB0Te08qX88T8 >									
364 	//        <  u =="0.000000000000000001" : ] 000000695081584.636501000000000000 ; 000000713056381.008263000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000004249C3E44009A6 >									
366 	//     < NDRV_PFIII_I_metadata_line_38_____pbv lebensversicherung ag_20211101 >									
367 	//        < Vb4Ip3F3cQsVu0Zs0f5K9n6bgAaHUrNIipCSm8oLnRlhU189DyAGeJom6CJCuOnJ >									
368 	//        <  u =="0.000000000000000001" : ] 000000713056381.008263000000000000 ; 000000733543358.743836000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000044009A645F4C60 >									
370 	//     < NDRV_PFIII_I_metadata_line_39_____generali colombia seguros generales sa_20211101 >									
371 	//        < f00jS74sq3xtjrzj56L417pto1Tv5kt83ln7iBHYE206CmAq6NQum4bGCQbF4d9t >									
372 	//        <  u =="0.000000000000000001" : ] 000000733543358.743836000000000000 ; 000000753484537.581355000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000045F4C6047DB9E6 >									
374 	//     < NDRV_PFIII_I_metadata_line_40_____generali colombia vida sa_20211101 >									
375 	//        < 4xRYi15H0aeImyv1gXR7S3Z9C6D20ZJ0p33d9F512sN5bqY528EfZXWIG1jVw2W5 >									
376 	//        <  u =="0.000000000000000001" : ] 000000753484537.581355000000000000 ; 000000773897503.952870000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000047DB9E649CDFB6 >									
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