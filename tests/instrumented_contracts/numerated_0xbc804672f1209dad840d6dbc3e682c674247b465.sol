1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	RUSS_PFXXXI_I_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	RUSS_PFXXXI_I_883		"	;
8 		string	public		symbol =	"	RUSS_PFXXXI_I_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		607381777821507000000000000					;	
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
92 	//     < RUSS_PFXXXI_I_metadata_line_1_____MEGAFON_20211101 >									
93 	//        < EEuFsxt76ngh0lNdiNc2FVIM16RZO3hrr66L2K08So1WIJ20Z6v8bvuytfHs69fo >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000013145652.962213800000000000 ] >									
95 	//        < 0x0000000000000000000000000000000000000000000000000000000000140F05 >									
96 	//     < RUSS_PFXXXI_I_metadata_line_2_____EUROSET_20211101 >									
97 	//        < W6i60M8PjQGltwZTKH6bK9ZLGQ3NsYiZjrV78RNxfPvOh9gB60h2SEZf86UqPu2h >									
98 	//        <  u =="0.000000000000000001" : ] 000000013145652.962213800000000000 ; 000000028110910.212819700000000000 ] >									
99 	//        < 0x0000000000000000000000000000000000000000000000000000140F052AE4D3 >									
100 	//     < RUSS_PFXXXI_I_metadata_line_3_____OSTELECOM_20211101 >									
101 	//        < Qp7b2vIxX8xW6jl1ar1fxWAFmjgxfa28GLjnYCF0BvQ1r57F25rTyTXc91cvN50R >									
102 	//        <  u =="0.000000000000000001" : ] 000000028110910.212819700000000000 ; 000000044083890.910105800000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000002AE4D3434445 >									
104 	//     < RUSS_PFXXXI_I_metadata_line_4_____GARS_TELECOM_20211101 >									
105 	//        < ZMeZ3lxKxE44741p1Zbx7Nk0Qr177811KwpQ4WeO337L1hWal1pcO81XqTJaga44 >									
106 	//        <  u =="0.000000000000000001" : ] 000000044083890.910105800000000000 ; 000000060218280.675985700000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000004344455BE2C4 >									
108 	//     < RUSS_PFXXXI_I_metadata_line_5_____MEGAFON_INVESTMENT_CYPRUS_LIMITED_20211101 >									
109 	//        < 91a83300KIC30uvpZ72GhRX6ElMfa8Aa99K4AMA7l86nU2q6W8F5e40N53kzJBk9 >									
110 	//        <  u =="0.000000000000000001" : ] 000000060218280.675985700000000000 ; 000000075613975.921312400000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000005BE2C47360B6 >									
112 	//     < RUSS_PFXXXI_I_metadata_line_6_____YOTA_20211101 >									
113 	//        < t04CKhViz35VTL09Agwt9oVFmht5BbFo1jC0v1Brae45bNX6SHdPbDp9DLLIyYSH >									
114 	//        <  u =="0.000000000000000001" : ] 000000075613975.921312400000000000 ; 000000090794501.543672700000000000 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000000000007360B68A8A9A >									
116 	//     < RUSS_PFXXXI_I_metadata_line_7_____YOTA_DAO_20211101 >									
117 	//        < fF8uxjn7BJXA7ZGUyhn7JyU4Kw2v41sEo83tmjw30Niagh4Gzvxd3MKF4x4P4L3Z >									
118 	//        <  u =="0.000000000000000001" : ] 000000090794501.543672700000000000 ; 000000105783323.745065000000000000 ] >									
119 	//        < 0x00000000000000000000000000000000000000000000000000008A8A9AA1699C >									
120 	//     < RUSS_PFXXXI_I_metadata_line_8_____YOTA_DAOPI_20211101 >									
121 	//        < 4ZbcJYbQ274NvL55b2thgAiq42D56drWYK105P9sCRO9Ya6yXkvw307eB8FfFnyh >									
122 	//        <  u =="0.000000000000000001" : ] 000000105783323.745065000000000000 ; 000000120304298.227635000000000000 ] >									
123 	//        < 0x0000000000000000000000000000000000000000000000000000A1699CB791DE >									
124 	//     < RUSS_PFXXXI_I_metadata_line_9_____YOTA_DAC_20211101 >									
125 	//        < wZT82wT4fT5NVNigz4FSEt4S3Exxc9vSzi0LxrA5HjRuJspTH4585c3VNW2JRWqZ >									
126 	//        <  u =="0.000000000000000001" : ] 000000120304298.227635000000000000 ; 000000135107584.704163000000000000 ] >									
127 	//        < 0x0000000000000000000000000000000000000000000000000000B791DECE2866 >									
128 	//     < RUSS_PFXXXI_I_metadata_line_10_____YOTA_BIMI_20211101 >									
129 	//        < qOVe51pz4Wvp1uG7Xdy8G9P6foSLY80LwUctPZ1hjhZV02Y3e5995PnRP3z2pgKz >									
130 	//        <  u =="0.000000000000000001" : ] 000000135107584.704163000000000000 ; 000000148533030.717695000000000000 ] >									
131 	//        < 0x0000000000000000000000000000000000000000000000000000CE2866E2A4B7 >									
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
174 	//     < RUSS_PFXXXI_I_metadata_line_11_____KAVKAZ_20211101 >									
175 	//        < Xj9j23jx8bQE8rhQzD4n15fN4pLJ6Yp8o5245MyLRB3XMwwF7SdY5BZkyjNg2M7i >									
176 	//        <  u =="0.000000000000000001" : ] 000000148533030.717695000000000000 ; 000000165554048.510317000000000000 ] >									
177 	//        < 0x0000000000000000000000000000000000000000000000000000E2A4B7FC9D8D >									
178 	//     < RUSS_PFXXXI_I_metadata_line_12_____KAVKAZ_KZT_20211101 >									
179 	//        < 1e0t70RHizslgD4KNYaEIsw21tLD53Cd8M9OxT4I66x2zj4FD7V54336nrGJbZLm >									
180 	//        <  u =="0.000000000000000001" : ] 000000165554048.510317000000000000 ; 000000180426661.772939000000000000 ] >									
181 	//        < 0x000000000000000000000000000000000000000000000000000FC9D8D1134F2A >									
182 	//     < RUSS_PFXXXI_I_metadata_line_13_____KAVKAZ_CHF_20211101 >									
183 	//        < t4DJb0uIL1NT2OFe84jw2oKYjuz4f9Gb3Jk35fJL19UuNDC4m5Og1chRlEk2DaY7 >									
184 	//        <  u =="0.000000000000000001" : ] 000000180426661.772939000000000000 ; 000000193723878.829377000000000000 ] >									
185 	//        < 0x000000000000000000000000000000000000000000000000001134F2A1279964 >									
186 	//     < RUSS_PFXXXI_I_metadata_line_14_____KAVKAZ_USD_20211101 >									
187 	//        < 83wG7R7P4fosVEZ6bp7B7lO47Wi011s45WObd5obYn2qVQda0h8ydlQ7wE46ymJs >									
188 	//        <  u =="0.000000000000000001" : ] 000000193723878.829377000000000000 ; 000000210658714.172506000000000000 ] >									
189 	//        < 0x000000000000000000000000000000000000000000000000001279964141708F >									
190 	//     < RUSS_PFXXXI_I_metadata_line_15_____PETERSTAR_20211101 >									
191 	//        < 9mK3VPLdItvdLwN374o3Mih8K8mb9Tl33YSObZk85TlrV8uysj4eB73tQ3lWvt37 >									
192 	//        <  u =="0.000000000000000001" : ] 000000210658714.172506000000000000 ; 000000227796678.178675000000000000 ] >									
193 	//        < 0x00000000000000000000000000000000000000000000000000141708F15B9714 >									
194 	//     < RUSS_PFXXXI_I_metadata_line_16_____MEGAFON_FINANCE_LLC_20211101 >									
195 	//        < 67W36Lv4mVxfemKtPXnO5lt58H9u4ulrV4N5aT5qe0Om2j9r91IOOvnwdpRLW8Oz >									
196 	//        <  u =="0.000000000000000001" : ] 000000227796678.178675000000000000 ; 000000242162875.344402000000000000 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000000015B971417182E0 >									
198 	//     < RUSS_PFXXXI_I_metadata_line_17_____LEFBORD_INVESTMENTS_LIMITED_20211101 >									
199 	//        < p6M76ai6J1d03P4c56a3Ta7WLEyU1j6cN6GGwZNQVY71JCJO5a30EpwEZ4Rvbmek >									
200 	//        <  u =="0.000000000000000001" : ] 000000242162875.344402000000000000 ; 000000257001237.674439000000000000 ] >									
201 	//        < 0x0000000000000000000000000000000000000000000000000017182E0188271C >									
202 	//     < RUSS_PFXXXI_I_metadata_line_18_____TT_MOBILE_20211101 >									
203 	//        < 1s6mW7W32tRSa9DsuC3J2R0xTYd0l85dwF16Vgoll8YrGUJ7iJDoiV4dumzl7ICd >									
204 	//        <  u =="0.000000000000000001" : ] 000000257001237.674439000000000000 ; 000000273275928.801633000000000000 ] >									
205 	//        < 0x00000000000000000000000000000000000000000000000000188271C1A0FC69 >									
206 	//     < RUSS_PFXXXI_I_metadata_line_19_____SMARTS_SAMARA_20211101 >									
207 	//        < 48BNEeo1W5n74P25hvZGnhHhcb2R2F336VJ8XH96k6LwYsINxDntn2KOKsMXjN2Q >									
208 	//        <  u =="0.000000000000000001" : ] 000000273275928.801633000000000000 ; 000000288612641.129162000000000000 ] >									
209 	//        < 0x000000000000000000000000000000000000000000000000001A0FC691B86350 >									
210 	//     < RUSS_PFXXXI_I_metadata_line_20_____MEGAFON_NORTH_WEST_20211101 >									
211 	//        < bcwqeTVu7Gg7cCTt5i1Imz3x16717FwZn55xFMDl5kz8qpi9Nhokq7bKAhv2ZseW >									
212 	//        <  u =="0.000000000000000001" : ] 000000288612641.129162000000000000 ; 000000304283911.939833000000000000 ] >									
213 	//        < 0x000000000000000000000000000000000000000000000000001B863501D04CE7 >									
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
256 	//     < RUSS_PFXXXI_I_metadata_line_21_____GARS_HOLDING_LIMITED_20211101 >									
257 	//        < 511xBt2iGJ354vy5xsguLC7p9AE58W7eMwW7I4tQWtI3LZ76APnIu8dT8A1RCPI3 >									
258 	//        <  u =="0.000000000000000001" : ] 000000304283911.939833000000000000 ; 000000318364665.227888000000000000 ] >									
259 	//        < 0x000000000000000000000000000000000000000000000000001D04CE71E5C933 >									
260 	//     < RUSS_PFXXXI_I_metadata_line_22_____SMARTS_CHEBOKSARY_20211101 >									
261 	//        < 8DLfwg4GG3h8xFyXphgic8sUOQ875j5LJri9Dd73ZPD8w74BrcQpDf5I8x9J5AQl >									
262 	//        <  u =="0.000000000000000001" : ] 000000318364665.227888000000000000 ; 000000333776330.176106000000000000 ] >									
263 	//        < 0x000000000000000000000000000000000000000000000000001E5C9331FD4D61 >									
264 	//     < RUSS_PFXXXI_I_metadata_line_23_____MEGAFON_ORG_20211101 >									
265 	//        < 6Fbx162bhoSA9UMGH64mH2e4ux5V3v3Bpff9GJGmql9t1cjV0gx332q0jc2lkNOT >									
266 	//        <  u =="0.000000000000000001" : ] 000000333776330.176106000000000000 ; 000000348956094.597671000000000000 ] >									
267 	//        < 0x000000000000000000000000000000000000000000000000001FD4D6121476F9 >									
268 	//     < RUSS_PFXXXI_I_metadata_line_24_____NAKHODKA_TELECOM_20211101 >									
269 	//        < sL58C4932lT5n2O36rG99k8VOXo27RT0vGG9HnL6H884DvEBlYns3M6Cr2Ms8B1U >									
270 	//        <  u =="0.000000000000000001" : ] 000000348956094.597671000000000000 ; 000000364556463.441861000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000021476F922C44DE >									
272 	//     < RUSS_PFXXXI_I_metadata_line_25_____NEOSPRINT_20211101 >									
273 	//        < b98GG0qRB378XiyIB8B9W9KB888d57mFfGi3n278vh4XkBnt8uG747h0AA4NUzdW >									
274 	//        <  u =="0.000000000000000001" : ] 000000364556463.441861000000000000 ; 000000379134565.501800000000000000 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000000000022C44DE2428371 >									
276 	//     < RUSS_PFXXXI_I_metadata_line_26_____SMARTS_PENZA_20211101 >									
277 	//        < e2Ftn20lrMgPBDEvHqTQGxN6lZxkC57kta38H0hM5Hh5551470QMWH1F17h9JKw4 >									
278 	//        <  u =="0.000000000000000001" : ] 000000379134565.501800000000000000 ; 000000396332468.978377000000000000 ] >									
279 	//        < 0x00000000000000000000000000000000000000000000000000242837125CC15F >									
280 	//     < RUSS_PFXXXI_I_metadata_line_27_____MEGAFON_RETAIL_20211101 >									
281 	//        < NzX24heM0DjWI3qPT72T526Jm02k6PCLHKuA6uW139uCx5EQYUiRPX48aV25X66r >									
282 	//        <  u =="0.000000000000000001" : ] 000000396332468.978377000000000000 ; 000000410323246.002712000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000025CC15F2721A85 >									
284 	//     < RUSS_PFXXXI_I_metadata_line_28_____FIRST_TOWER_COMPANY_20211101 >									
285 	//        < hLTw46NVJ4Cvmg7Yn07uySlZ1GAnZDcXVor8RgU5cTu96Y0ymtOF5imZnV8J42wS >									
286 	//        <  u =="0.000000000000000001" : ] 000000410323246.002712000000000000 ; 000000425015283.474329000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000002721A852888598 >									
288 	//     < RUSS_PFXXXI_I_metadata_line_29_____MEGAFON_SA_20211101 >									
289 	//        < nn0JHz6L4dA2U5r0wWtGm7MNDV3SOWH4Jx066S7hkGS679f1gEIqXoTo29LtLVWR >									
290 	//        <  u =="0.000000000000000001" : ] 000000425015283.474329000000000000 ; 000000438684839.598157000000000000 ] >									
291 	//        < 0x00000000000000000000000000000000000000000000000000288859829D6144 >									
292 	//     < RUSS_PFXXXI_I_metadata_line_30_____MOBICOM_KHABAROVSK_20211101 >									
293 	//        < 6BeAqu8vzyXa3ior267t2dhE0TMn8ieSj2h0GX3CodL6tre00y9E7y8k8H3XKsY2 >									
294 	//        <  u =="0.000000000000000001" : ] 000000438684839.598157000000000000 ; 000000454166471.084865000000000000 ] >									
295 	//        < 0x0000000000000000000000000000000000000000000000000029D61442B500C7 >									
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
338 	//     < RUSS_PFXXXI_I_metadata_line_31_____AQUAFON_GSM_20211101 >									
339 	//        < 37OKbos3RjxYejf95h29F4B3Z678e4Tn3bm7Hf0Itof5s1XUz678fh3C0E6120xw >									
340 	//        <  u =="0.000000000000000001" : ] 000000454166471.084865000000000000 ; 000000470328680.098599000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000002B500C72CDAA24 >									
342 	//     < RUSS_PFXXXI_I_metadata_line_32_____DIGITAL_BUSINESS_SOLUTIONS_20211101 >									
343 	//        < 8Uq2yAAQmC0267XfP4LK988Cb5ON5CGo7L0bU4HfQNwI63lSVN93x0CZ2o70qJLm >									
344 	//        <  u =="0.000000000000000001" : ] 000000470328680.098599000000000000 ; 000000486447139.122727000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000002CDAA242E6426A >									
346 	//     < RUSS_PFXXXI_I_metadata_line_33_____KOMBELL_OOO_20211101 >									
347 	//        < 147ShHXreDo513OBh3XaP7EZb5r3S9n6Z9jM8sujJOjNqmGTVPe2g0Fs6Ob0F52p >									
348 	//        <  u =="0.000000000000000001" : ] 000000486447139.122727000000000000 ; 000000502879866.978420000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000002E6426A2FF5573 >									
350 	//     < RUSS_PFXXXI_I_metadata_line_34_____URALSKI_GSM_ZAO_20211101 >									
351 	//        < 067JGsqlwTR52wDaL16bw7dQAhEOpIsx9M8dEM8ukdVp89c56v1qjx7782e85MPB >									
352 	//        <  u =="0.000000000000000001" : ] 000000502879866.978420000000000000 ; 000000516009347.201804000000000000 ] >									
353 	//        < 0x000000000000000000000000000000000000000000000000002FF55733135E27 >									
354 	//     < RUSS_PFXXXI_I_metadata_line_35_____INCORE_20211101 >									
355 	//        < fh5hbrr4TxzLl1im2OV2NJQXVNc1F4SX2dc93vipntx8Vl2c5taI6btGjQ7GHX5q >									
356 	//        <  u =="0.000000000000000001" : ] 000000516009347.201804000000000000 ; 000000531431240.138984000000000000 ] >									
357 	//        < 0x000000000000000000000000000000000000000000000000003135E2732AE654 >									
358 	//     < RUSS_PFXXXI_I_metadata_line_36_____MEGALABS_20211101 >									
359 	//        < nt2RZ8HZNY7KsKYpjdoqFe46ix9i68G94aD3CnhDO21a3J2es05nU6ulqU6bnB3G >									
360 	//        <  u =="0.000000000000000001" : ] 000000531431240.138984000000000000 ; 000000546109696.755618000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000032AE6543414C1A >									
362 	//     < RUSS_PFXXXI_I_metadata_line_37_____AQUAPHONE_GSM_20211101 >									
363 	//        < 4Oh0lm3vQsgj1K8lwf5AGhlR242GneDv9BXN98aDWW72tgqtFvkI70Z4PGq2z5ZQ >									
364 	//        <  u =="0.000000000000000001" : ] 000000546109696.755618000000000000 ; 000000560612893.970560000000000000 ] >									
365 	//        < 0x000000000000000000000000000000000000000000000000003414C1A3576D69 >									
366 	//     < RUSS_PFXXXI_I_metadata_line_38_____TC_COMET_20211101 >									
367 	//        < A80pH9FZYL5zG2xPL6Duj7O67lJ8uiJLUa1p7U6VHQD9xvPqT2c9Kogy3f02e9Mq >									
368 	//        <  u =="0.000000000000000001" : ] 000000560612893.970560000000000000 ; 000000573866763.598489000000000000 ] >									
369 	//        < 0x000000000000000000000000000000000000000000000000003576D6936BA6B4 >									
370 	//     < RUSS_PFXXXI_I_metadata_line_39_____DEBTON_INVESTMENTS_LIMITED_20211101 >									
371 	//        < hqS9jMd8F3Mt0ACsFsgXB9vvZb9zmwv7K8Nfa2R58eAfm5S88B3bHXMHK7EYA54n >									
372 	//        <  u =="0.000000000000000001" : ] 000000573866763.598489000000000000 ; 000000590621037.523896000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000036BA6B43853758 >									
374 	//     < RUSS_PFXXXI_I_metadata_line_40_____NETBYNET_HOLDING_20211101 >									
375 	//        < 9m945OGTBhQ33eK53RC99tXd2p8013CgnBVCQ0kS1723vV9bawX5xnKPt9fRwFeA >									
376 	//        <  u =="0.000000000000000001" : ] 000000590621037.523896000000000000 ; 000000607381777.821507000000000000 ] >									
377 	//        < 0x00000000000000000000000000000000000000000000000000385375839ECA82 >									
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