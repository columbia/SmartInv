1 pragma solidity 		^0.4.21	;						
2 										
3 	contract	BANK_IV_PFI_883				{				
4 										
5 		mapping (address => uint256) public balanceOf;								
6 										
7 		string	public		name =	"	BANK_IV_PFI_883		"	;
8 		string	public		symbol =	"	BANK_IV_PFI_IMTD		"	;
9 		uint8	public		decimals =		18			;
10 										
11 		uint256 public totalSupply =		417212953933922000000000000					;	
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
92 	//     < BANK_IV_PFI_metadata_line_1_____AGRICULTURAL DEVELOPMENT BANK OF CHINA_20220508 >									
93 	//        < 5MixI7JRQ90f0ZqJq15JV1vebVkolE497z5R74tIb3jf2eeQFZTiaXZA3CA49RPi >									
94 	//        <  u =="0.000000000000000001" : ] 000000000000000.000000000000000000 ; 000000010374052.886285400000000000 ] >									
95 	//        < 0x00000000000000000000000000000000000000000000000000000000000FD45D >									
96 	//     < BANK_IV_PFI_metadata_line_2_____CHINA DEVELOMENT BANK_20220508 >									
97 	//        < Tg9H6oKq57v7xkN78h4mRB2xK1WCx069ESb012M22UaKBExGB0X4c70buLAkeLp3 >									
98 	//        <  u =="0.000000000000000001" : ] 000000010374052.886285400000000000 ; 000000020870506.367522900000000000 ] >									
99 	//        < 0x00000000000000000000000000000000000000000000000000000FD45D1FD88B >									
100 	//     < BANK_IV_PFI_metadata_line_3_____EXIM BANK OF CHINA_20220508 >									
101 	//        < Lcm6VeS1tv29eJMb242tE3BF560y0DAsYyX20AE8qWL2M69omzAnUM5nuq9hrlN2 >									
102 	//        <  u =="0.000000000000000001" : ] 000000020870506.367522900000000000 ; 000000031184694.787244400000000000 ] >									
103 	//        < 0x00000000000000000000000000000000000000000000000000001FD88B2F9585 >									
104 	//     < BANK_IV_PFI_metadata_line_4_____CHINA MERCHANT BANK_20220508 >									
105 	//        < cj4c6o8ypWniCC75J0Nw5wWB818YoT6SUYV0dL5Nf669r9r9OwSc2cC213W8862f >									
106 	//        <  u =="0.000000000000000001" : ] 000000031184694.787244400000000000 ; 000000041598198.160617100000000000 ] >									
107 	//        < 0x00000000000000000000000000000000000000000000000000002F95853F794C >									
108 	//     < BANK_IV_PFI_metadata_line_5_____SHANGHAI PUDONG DEVELOPMENT BANK_20220508 >									
109 	//        < 9879143OF2uNa6c8IBC7w18xnAn0S2YN1517lpThA0Rtp2yn5THR2LrWUsyRkZh9 >									
110 	//        <  u =="0.000000000000000001" : ] 000000041598198.160617100000000000 ; 000000052147063.401884200000000000 ] >									
111 	//        < 0x00000000000000000000000000000000000000000000000000003F794C4F91F2 >									
112 	//     < BANK_IV_PFI_metadata_line_6_____INDUSTRIAL BANK_20220508 >									
113 	//        < gCDrpYIVRVE75oGsPtMGyO71L4LlF4O8y55fH6mtsmBBbg9Y2l7Np1Emk01Y31rP >									
114 	//        <  u =="0.000000000000000001" : ] 000000052147063.401884200000000000 ; 000000062595913.850933600000000000 ] >									
115 	//        < 0x00000000000000000000000000000000000000000000000000004F91F25F8387 >									
116 	//     < BANK_IV_PFI_metadata_line_7_____CHINA CITIC BANK_20220508 >									
117 	//        < 72TrB3p48wSbybWhq280GHlV28HPN74E3SYAl788ads6mH437Vx8MeF05b9a4qd4 >									
118 	//        <  u =="0.000000000000000001" : ] 000000062595913.850933600000000000 ; 000000072945288.526597000000000000 ] >									
119 	//        < 0x00000000000000000000000000000000000000000000000000005F83876F4E41 >									
120 	//     < BANK_IV_PFI_metadata_line_8_____CHINA MINSHENG BANK_20220508 >									
121 	//        < OYChWam0eOcY4s5Y2K891cw591t0h8oqP6it3VQ705j563OOVdGKPQZ4y4Kbx7Ad >									
122 	//        <  u =="0.000000000000000001" : ] 000000072945288.526597000000000000 ; 000000083452388.907668200000000000 ] >									
123 	//        < 0x00000000000000000000000000000000000000000000000000006F4E417F5697 >									
124 	//     < BANK_IV_PFI_metadata_line_9_____CHINA EVERBRIGHT BANK_20220508 >									
125 	//        < wKl3KQKO58m2rKl3H363n3lS94djP7yOJZvs2863P773CrbQE98KD4duOR6h953B >									
126 	//        <  u =="0.000000000000000001" : ] 000000083452388.907668200000000000 ; 000000093882122.321613600000000000 ] >									
127 	//        < 0x00000000000000000000000000000000000000000000000000007F56978F40B4 >									
128 	//     < BANK_IV_PFI_metadata_line_10_____PING AN BANK_20220508 >									
129 	//        < s35NdctEaIBwdIKf508AC4l7f9VAC8Ph4TaSZXPoYRX37qP62T9eXjE7v5t0yPKf >									
130 	//        <  u =="0.000000000000000001" : ] 000000093882122.321613600000000000 ; 000000104361971.409608000000000000 ] >									
131 	//        < 0x00000000000000000000000000000000000000000000000000008F40B49F3E65 >									
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
174 	//     < BANK_IV_PFI_metadata_line_11_____HUAXIA BANK_20220508 >									
175 	//        < i5ya2N405YzN4EjeP7W3d42lH8560jkPqnzpNPlGBpy44JaabfTlr11618nZM0vd >									
176 	//        <  u =="0.000000000000000001" : ] 000000104361971.409608000000000000 ; 000000114847617.671870000000000000 ] >									
177 	//        < 0x00000000000000000000000000000000000000000000000000009F3E65AF3E5A >									
178 	//     < BANK_IV_PFI_metadata_line_12_____CHINA GUANGFA BANK_20220508 >									
179 	//        < SC16QNfJx9wt3KoErGomY9cS6KoD2dl1Seti1F4eBq88So9p0Fv93Xs4kSJkJWXx >									
180 	//        <  u =="0.000000000000000001" : ] 000000114847617.671870000000000000 ; 000000125309315.437473000000000000 ] >									
181 	//        < 0x0000000000000000000000000000000000000000000000000000AF3E5ABF34F4 >									
182 	//     < BANK_IV_PFI_metadata_line_13_____CHINA BOHAI BANK_20220508 >									
183 	//        < 731Jie06wl0MqL08100g562KD98861H1vf69JcMfM6U40tPOp2oYZtAhjYC704b5 >									
184 	//        <  u =="0.000000000000000001" : ] 000000125309315.437473000000000000 ; 000000135788053.690898000000000000 ] >									
185 	//        < 0x0000000000000000000000000000000000000000000000000000BF34F4CF3235 >									
186 	//     < BANK_IV_PFI_metadata_line_14_____HENGFENG BANK_EVERGROWING BANK_20220508 >									
187 	//        < 3QvBDH602d971w19y73C5ck6EcrH27fZUR2nL363vKMVwnXpp3DA6jke3hXL3aRR >									
188 	//        <  u =="0.000000000000000001" : ] 000000135788053.690898000000000000 ; 000000146232349.597915000000000000 ] >									
189 	//        < 0x0000000000000000000000000000000000000000000000000000CF3235DF2203 >									
190 	//     < BANK_IV_PFI_metadata_line_15_____BANK OF BEIJING_20220508 >									
191 	//        < 1NnoC36t68qNIraGV1Zkp29UW6ee3Hd9QZ97jV71zvdN2vM84989ZUH6454ZLY1r >									
192 	//        <  u =="0.000000000000000001" : ] 000000146232349.597915000000000000 ; 000000156708863.013677000000000000 ] >									
193 	//        < 0x0000000000000000000000000000000000000000000000000000DF2203EF1E66 >									
194 	//     < BANK_IV_PFI_metadata_line_16_____BANK OF SHANGHAI_20220508 >									
195 	//        < H7T55A1UKBd3D0UFMi0ML624nf0ID7qDFDqbMJhtj12s84hz06v0tDI2EO732464 >									
196 	//        <  u =="0.000000000000000001" : ] 000000156708863.013677000000000000 ; 000000167083421.946494000000000000 ] >									
197 	//        < 0x0000000000000000000000000000000000000000000000000000EF1E66FEF2F6 >									
198 	//     < BANK_IV_PFI_metadata_line_17_____BANK OF JIANGSU_20220508 >									
199 	//        < UWn6rYgvS8NQVd0CEGKACQL7hJDe1eNp92nrck38671x5pkDrD8fenGh2Nh9sZf3 >									
200 	//        <  u =="0.000000000000000001" : ] 000000167083421.946494000000000000 ; 000000177582692.204125000000000000 ] >									
201 	//        < 0x000000000000000000000000000000000000000000000000000FEF2F610EF83D >									
202 	//     < BANK_IV_PFI_metadata_line_18_____BANK OF NINGBO_20220508 >									
203 	//        < zbnxuFtJ89m1og2sUWCc4BtGCl1cdlJ42E30xp8YbokAvg1sn810W7X2lEJmGTjn >									
204 	//        <  u =="0.000000000000000001" : ] 000000177582692.204125000000000000 ; 000000187912042.280712000000000000 ] >									
205 	//        < 0x0000000000000000000000000000000000000000000000000010EF83D11EBB24 >									
206 	//     < BANK_IV_PFI_metadata_line_19_____BANK OF DALIAN_20220508 >									
207 	//        < 7LzdctvjYY7Xo1PjQn9awK090gWLNj1D531414fvp14976go1q6O4QsCQ68BuOBp >									
208 	//        <  u =="0.000000000000000001" : ] 000000187912042.280712000000000000 ; 000000198393432.553404000000000000 ] >									
209 	//        < 0x0000000000000000000000000000000000000000000000000011EBB2412EB96F >									
210 	//     < BANK_IV_PFI_metadata_line_20_____BANK OF TAIZHOU_20220508 >									
211 	//        < v0X722VbVxkKrsbmq40xDTQ0kMeX2d304T43W0GX4Vz3470K9g25F4tV1uxH1ry3 >									
212 	//        <  u =="0.000000000000000001" : ] 000000198393432.553404000000000000 ; 000000208728813.668722000000000000 ] >									
213 	//        < 0x0000000000000000000000000000000000000000000000000012EB96F13E7EB1 >									
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
256 	//     < BANK_IV_PFI_metadata_line_21_____BANK OF TIANJIN_20220508 >									
257 	//        < q28frfqvn9JNXIIMcUukRlmtsipB56t7I4Bbb3192ZKOyIM8KmBLTa8m552TW30E >									
258 	//        <  u =="0.000000000000000001" : ] 000000208728813.668722000000000000 ; 000000219232131.794078000000000000 ] >									
259 	//        < 0x0000000000000000000000000000000000000000000000000013E7EB114E858D >									
260 	//     < BANK_IV_PFI_metadata_line_22_____WIAMEN INTERNATIONAL BANK_20220508 >									
261 	//        < 0k1pazm1HTsS40vL26Jb7sh9D3N1WWzmQ1mj3ygH8zOT97tsC3qM009fQ7YAxy41 >									
262 	//        <  u =="0.000000000000000001" : ] 000000219232131.794078000000000000 ; 000000229680808.944925000000000000 ] >									
263 	//        < 0x0000000000000000000000000000000000000000000000000014E858D15E7711 >									
264 	//     < BANK_IV_PFI_metadata_line_23_____TAI_AN BANK_20220508 >									
265 	//        < RXG2ECN0uvdLJjfERx525lHyCaSK0GNOT0KqMT69NBz0gXOCMgQ3OFF5B329CeT0 >									
266 	//        <  u =="0.000000000000000001" : ] 000000229680808.944925000000000000 ; 000000240144292.545249000000000000 ] >									
267 	//        < 0x0000000000000000000000000000000000000000000000000015E771116E6E5D >									
268 	//     < BANK_IV_PFI_metadata_line_24_____SHENGJING BANK_SHENYANG_20220508 >									
269 	//        < IDhA08gNY46e5uUG113q4jSzyK7i3R7Q3rxf7EKkQq6iVVQkp5kh48W8dh2l7M06 >									
270 	//        <  u =="0.000000000000000001" : ] 000000240144292.545249000000000000 ; 000000250678118.072535000000000000 ] >									
271 	//        < 0x0000000000000000000000000000000000000000000000000016E6E5D17E8124 >									
272 	//     < BANK_IV_PFI_metadata_line_25_____HARBIN BANK_20220508 >									
273 	//        < pUi9LRg8b7jfrBjwtuo9rrH0UX6b3D3j3yDEFKi1cbsSpYVtmOzh8975foMQ302r >									
274 	//        <  u =="0.000000000000000001" : ] 000000250678118.072535000000000000 ; 000000261147517.773991000000000000 ] >									
275 	//        < 0x0000000000000000000000000000000000000000000000000017E812418E7AC0 >									
276 	//     < BANK_IV_PFI_metadata_line_26_____BANK OF JILIN_20220508 >									
277 	//        < E0yQ32KiPF6e4L0VgI1n9inOA65516WTjlijqa1kd0xIcQF8Hl136cT0mxuoM1t5 >									
278 	//        <  u =="0.000000000000000001" : ] 000000261147517.773991000000000000 ; 000000271561444.331049000000000000 ] >									
279 	//        < 0x0000000000000000000000000000000000000000000000000018E7AC019E5EB0 >									
280 	//     < BANK_IV_PFI_metadata_line_27_____WEBANK_CHINA_20220508 >									
281 	//        < 46z4ToIo0X53rEfGrZ77q6Bzi5gL947RT6o55qH0u22C641nKKiBM4PfU7NSB8wI >									
282 	//        <  u =="0.000000000000000001" : ] 000000271561444.331049000000000000 ; 000000282041702.921748000000000000 ] >									
283 	//        < 0x0000000000000000000000000000000000000000000000000019E5EB01AE5C8A >									
284 	//     < BANK_IV_PFI_metadata_line_28_____MYBANK_HANGZHOU_20220508 >									
285 	//        < O1p9l9s3QVj0f7Ooo2k1R1SgIvShJ2Wq94ryJ7V8rEh3369I9jTrhCMC6833Uh7B >									
286 	//        <  u =="0.000000000000000001" : ] 000000282041702.921748000000000000 ; 000000292460059.879918000000000000 ] >									
287 	//        < 0x000000000000000000000000000000000000000000000000001AE5C8A1BE4236 >									
288 	//     < BANK_IV_PFI_metadata_line_29_____SHANGHAI HUARUI BANK_20220508 >									
289 	//        < 0G47V8O9RF1QjVMtg9K8UxkXNSYi91P678z1mFb6Bk7058NiPfVKZ5oHDHR14amf >									
290 	//        <  u =="0.000000000000000001" : ] 000000292460059.879918000000000000 ; 000000302890593.035102000000000000 ] >									
291 	//        < 0x000000000000000000000000000000000000000000000000001BE42361CE2CA3 >									
292 	//     < BANK_IV_PFI_metadata_line_30_____WENZHOU MINSHANG BANK_20220508 >									
293 	//        < 1b3eHx1iSA7xsfoXpRGjPIBKgWha0Rm4UrU541kCvq5Vh3GY82C0r0DUOL1UIyfS >									
294 	//        <  u =="0.000000000000000001" : ] 000000302890593.035102000000000000 ; 000000313205910.032079000000000000 ] >									
295 	//        < 0x000000000000000000000000000000000000000000000000001CE2CA31DDEA0F >									
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
338 	//     < BANK_IV_PFI_metadata_line_31_____BANK OF KUNLUN_20220508 >									
339 	//        < Ms7n4d66SKexJRN7G3q3XilxFqq8560Xq27720JfO4lptP816LLEXQRs3U06dFr0 >									
340 	//        <  u =="0.000000000000000001" : ] 000000313205910.032079000000000000 ; 000000323695150.649529000000000000 ] >									
341 	//        < 0x000000000000000000000000000000000000000000000000001DDEA0F1EDEB6B >									
342 	//     < BANK_IV_PFI_metadata_line_32_____SILIBANK_20220508 >									
343 	//        < SW025lUG7CMOYunHO3IjcpGLH9nG0BBOChsK856Cmm46I6h6l76lE96Y8m3414OK >									
344 	//        <  u =="0.000000000000000001" : ] 000000323695150.649529000000000000 ; 000000334059401.594430000000000000 ] >									
345 	//        < 0x000000000000000000000000000000000000000000000000001EDEB6B1FDBBF4 >									
346 	//     < BANK_IV_PFI_metadata_line_33_____AGRICULTURAL BANK OF CHINA_20220508 >									
347 	//        < j8iPX8QP5CQje0568JlI4415S2DjTuB5os7sPfVpZ5s56Kr006252WE8961sXCUP >									
348 	//        <  u =="0.000000000000000001" : ] 000000334059401.594430000000000000 ; 000000344413999.552061000000000000 ] >									
349 	//        < 0x000000000000000000000000000000000000000000000000001FDBBF420D88B8 >									
350 	//     < BANK_IV_PFI_metadata_line_34_____CIC_CHINA INVESTMENT CORP_20220508 >									
351 	//        < lnGiVaE25Q1jwjwTWgu3Cq696rNTH1Sr94tJl9D5LDdcLTeqH4GQf1h1EH5dn234 >									
352 	//        <  u =="0.000000000000000001" : ] 000000344413999.552061000000000000 ; 000000354874766.142361000000000000 ] >									
353 	//        < 0x0000000000000000000000000000000000000000000000000020D88B821D7EF5 >									
354 	//     < BANK_IV_PFI_metadata_line_35_____BANK OF CHINA_20220508 >									
355 	//        < jTWFRR147513bG0w4J8EeUThLapUo8mt4327O6lAAd274712Cg8OZ699R5jQF1K4 >									
356 	//        <  u =="0.000000000000000001" : ] 000000354874766.142361000000000000 ; 000000365212771.354041000000000000 ] >									
357 	//        < 0x0000000000000000000000000000000000000000000000000021D7EF522D453D >									
358 	//     < BANK_IV_PFI_metadata_line_36_____PEOPLE BANK OF CHINA_20220508 >									
359 	//        < Bk7Mk103a9Dpdwr013K4dR07Au8FSfAY9laBRrAg94v1eg6t6m5TbM37bWuu9K9A >									
360 	//        <  u =="0.000000000000000001" : ] 000000365212771.354041000000000000 ; 000000375515642.111018000000000000 ] >									
361 	//        < 0x0000000000000000000000000000000000000000000000000022D453D23CFDCC >									
362 	//     < BANK_IV_PFI_metadata_line_37_____ICBC_INDUSTRIAL AND COMMERCIAL BANK OF CHINA_20220508 >									
363 	//        < 2kixL1jF3xYO223gX9je066A8084D0OP68alF3K5aQK7PYhO0h54f6q47mIHvtHm >									
364 	//        <  u =="0.000000000000000001" : ] 000000375515642.111018000000000000 ; 000000385890989.353231000000000000 ] >									
365 	//        < 0x0000000000000000000000000000000000000000000000000023CFDCC24CD2AB >									
366 	//     < BANK_IV_PFI_metadata_line_38_____CHINA CONSTRUCTION BANK_20220508 >									
367 	//        < cYtsuOLl95OX9ZS6d5HyYjz5XO57EGVJX5kW2lvX4VTVi4PME8MBb2AS4NY8ZXqi >									
368 	//        <  u =="0.000000000000000001" : ] 000000385890989.353231000000000000 ; 000000396394323.597751000000000000 ] >									
369 	//        < 0x0000000000000000000000000000000000000000000000000024CD2AB25CD988 >									
370 	//     < BANK_IV_PFI_metadata_line_39_____BANK OF COMMUNICATION_20220508 >									
371 	//        < TvK5T62dXJ9XYtPd54TtVz3qLOWe9LNH31Z69IzqlV5N5Oa7P25VBT3nqirx4YaK >									
372 	//        <  u =="0.000000000000000001" : ] 000000396394323.597751000000000000 ; 000000406681297.995441000000000000 ] >									
373 	//        < 0x0000000000000000000000000000000000000000000000000025CD98826C8BE2 >									
374 	//     < BANK_IV_PFI_metadata_line_40_____POSTAL SAVINGS BANK OF CHINA_20220508 >									
375 	//        < 25eyfU1Dt4BJ8I5iGJaG28OQ1983Iw12OM23jADrOoI42NuzKxe2JBWyhc6oV934 >									
376 	//        <  u =="0.000000000000000001" : ] 000000406681297.995441000000000000 ; 000000417212953.933922000000000000 ] >									
377 	//        < 0x0000000000000000000000000000000000000000000000000026C8BE227C9DCF >									
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