1 /*! MondoNet.sol | (c) 2018 Develop by MondoNet LLC (mondonet.tech), author @mondonet | License: MIT */
2 
3 pragma solidity >=0.4.22 <0.6.0;
4 
5 library SafeMath {
6     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
7         if(a == 0) {
8             return 0;
9         }
10         uint256 c = a * b;
11         require(c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns(uint256) {
16         require(b > 0);
17         uint256 c = a / b;
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
22         require(b <= a);
23         uint256 c = a - b;
24         return c;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns(uint256) {
28         uint256 c = a + b;
29         require(c >= a);
30         return c;
31     }
32 
33     function mod(uint256 a, uint256 b) internal pure returns(uint256) {
34         require(b != 0);
35         return a % b;
36     }
37 }
38 
39 contract MondoNet {
40     using SafeMath for uint;
41 
42     struct Investor {
43         uint invested;
44         uint payouts;
45         uint first_invest;
46         uint last_payout;
47         address referrer;
48     }
49 
50     uint constant public BACKTOCONTRACT = 10; // 10% of all deposits goes back in to the smart contract.
51     uint constant public DEVWORK = 1000; //developer needs to be paid for his work...fee is charged (0.0051 eth) only when you decide to withdraw all your investment.
52     uint constant public WITHDRAW = 80; 
53     uint constant public REFBONUS = 5; //if you decide to withdraw all of your investment 5% will stay in the contract for the remaining investors.
54     uint constant public CASHBACK = 5; //if you decide to withdraw all of your investment 5% will stay in the contract for the remaining investors.
55     uint constant public MULTIPLICATION = 2; //once you achieve x2 or 200% your address is removed from the contract with the option of a new fresh investment from the same wallet address...no need to create a new address.
56     address payable public contractfunds = 0xd17a5265f8719ea5B01E084Aef3d4D58f452Ca18; // 10% of all deposits goes back in to the smart contract.
57     mapping(address => Investor) public investors;
58 
59     event AddInvestor(address indexed holder);
60     event Payout(address indexed holder, uint amount);
61     event Deposit(address indexed holder, uint amount, address referrer);
62     event RefBonus(address indexed from, address indexed to, uint amount);
63     event CashBack(address indexed holder, uint amount);
64     event Withdraw(address indexed holder, uint amount);
65 
66     function bonusSize() view public returns(uint) {
67         uint b = address(this).balance;
68 
69         if(b >= 205000 ether) return 5;
70         if(b >= 204000 ether) return 2;
71         if(b >= 203000 ether) return 3;
72         if(b >= 202000 ether) return 0;
73         if(b >= 201000 ether) return 5;
74         if(b >= 200000 ether) return 3;
75         if(b >= 199000 ether) return 1;
76         if(b >= 198000 ether) return 3;
77         if(b >= 197000 ether) return 5;
78         if(b >= 196000 ether) return 3;
79 
80         if(b >= 195000 ether) return 4;
81         if(b >= 194000 ether) return 2;
82         if(b >= 193000 ether) return 3;
83         if(b >= 192000 ether) return 0;
84         if(b >= 191000 ether) return 5;
85         if(b >= 190000 ether) return 3;
86         if(b >= 189000 ether) return 1;
87         if(b >= 188000 ether) return 3;
88         if(b >= 187000 ether) return 5;
89         if(b >= 186000 ether) return 7;
90 
91         if(b >= 185000 ether) return 6;
92         if(b >= 184000 ether) return 2;
93         if(b >= 183000 ether) return 3;
94         if(b >= 182000 ether) return 1;
95         if(b >= 181000 ether) return 5;
96         if(b >= 180000 ether) return 3;
97         if(b >= 179000 ether) return 1;
98         if(b >= 178000 ether) return 3;
99         if(b >= 177000 ether) return 5;
100         if(b >= 176000 ether) return 5;
101 
102         if(b >= 175000 ether) return 4;
103         if(b >= 174000 ether) return 2;
104         if(b >= 173000 ether) return 3;
105         if(b >= 172000 ether) return 0;
106         if(b >= 171000 ether) return 5;
107         if(b >= 170000 ether) return 3;
108         if(b >= 169000 ether) return 1;
109         if(b >= 168000 ether) return 3;
110         if(b >= 167000 ether) return 5;
111         if(b >= 166000 ether) return 4;
112 
113         if(b >= 165000 ether) return 5;
114         if(b >= 164000 ether) return 2;
115         if(b >= 163000 ether) return 3;
116         if(b >= 162000 ether) return 0;
117         if(b >= 161000 ether) return 5;
118         if(b >= 160000 ether) return 3;
119         if(b >= 159000 ether) return 1;
120         if(b >= 158000 ether) return 3;
121         if(b >= 157000 ether) return 5;
122         if(b >= 156000 ether) return 4;
123 
124         if(b >= 155000 ether) return 6;
125         if(b >= 154000 ether) return 2;
126         if(b >= 153000 ether) return 3;
127         if(b >= 152000 ether) return 3;
128         if(b >= 151000 ether) return 5;
129         if(b >= 150000 ether) return 3;
130         if(b >= 149000 ether) return 1;
131         if(b >= 148000 ether) return 3;
132         if(b >= 147000 ether) return 4;
133         if(b >= 146000 ether) return 5;
134 
135         if(b >= 145000 ether) return 7;
136         if(b >= 144000 ether) return 2;
137         if(b >= 143000 ether) return 3;
138         if(b >= 142000 ether) return 1;
139         if(b >= 141000 ether) return 5;
140         if(b >= 140000 ether) return 3;
141         if(b >= 139000 ether) return 0;
142         if(b >= 138000 ether) return 3;
143         if(b >= 137000 ether) return 6;
144         if(b >= 136000 ether) return 5;
145 
146         if(b >= 135000 ether) return 6;
147         if(b >= 134000 ether) return 4;
148         if(b >= 133000 ether) return 3;
149         if(b >= 132000 ether) return 2;
150         if(b >= 131000 ether) return 5;
151         if(b >= 130000 ether) return 3;
152         if(b >= 129000 ether) return 1;
153         if(b >= 128000 ether) return 3;
154         if(b >= 127000 ether) return 5;
155         if(b >= 126000 ether) return 6;
156 
157         if(b >= 125000 ether) return 7;
158         if(b >= 124000 ether) return 2;
159         if(b >= 123000 ether) return 3;
160         if(b >= 122000 ether) return 0;
161         if(b >= 121000 ether) return 5;
162         if(b >= 120000 ether) return 3;
163         if(b >= 119000 ether) return 1;
164         if(b >= 118000 ether) return 3;
165         if(b >= 117000 ether) return 5;
166         if(b >= 116000 ether) return 7;
167 
168         if(b >= 115000 ether) return 8;
169         if(b >= 114000 ether) return 2;
170         if(b >= 113000 ether) return 3;
171         if(b >= 112000 ether) return 2;
172         if(b >= 111000 ether) return 5;
173         if(b >= 110000 ether) return 3;
174         if(b >= 109000 ether) return 1;
175         if(b >= 108000 ether) return 3;
176         if(b >= 107000 ether) return 5;
177         if(b >= 106000 ether) return 7;
178 
179         if(b >= 105000 ether) return 9;
180         if(b >= 104000 ether) return 6;
181         if(b >= 103000 ether) return 3;
182         if(b >= 102000 ether) return 2;
183         if(b >= 101000 ether) return 5;
184         if(b >= 100000 ether) return 3;
185         if(b >= 99000 ether) return 0;
186         if(b >= 98000 ether) return 3;
187         if(b >= 97000 ether) return 6;
188         if(b >= 96000 ether) return 5;
189 
190         if(b >= 95000 ether) return 7;
191         if(b >= 94000 ether) return 4;
192         if(b >= 93000 ether) return 3;
193         if(b >= 92000 ether) return 2;
194         if(b >= 91000 ether) return 5;
195         if(b >= 90000 ether) return 3;
196         if(b >= 89000 ether) return 0;
197         if(b >= 88000 ether) return 3;
198         if(b >= 87000 ether) return 5;
199         if(b >= 86000 ether) return 6;
200 
201         if(b >= 85000 ether) return 8;
202         if(b >= 84000 ether) return 5;
203         if(b >= 83000 ether) return 4;
204         if(b >= 82000 ether) return 3;
205         if(b >= 81000 ether) return 5;
206         if(b >= 80000 ether) return 3;
207         if(b >= 79000 ether) return 2;
208         if(b >= 78000 ether) return 3;
209         if(b >= 77000 ether) return 5;
210         if(b >= 76000 ether) return 4;
211 
212         if(b >= 75000 ether) return 7;
213         if(b >= 74000 ether) return 2;
214         if(b >= 73000 ether) return 3;
215         if(b >= 72000 ether) return 0;
216         if(b >= 71000 ether) return 5;
217         if(b >= 70000 ether) return 3;
218         if(b >= 69000 ether) return 1;
219         if(b >= 68000 ether) return 3;
220         if(b >= 67000 ether) return 5;
221         if(b >= 66000 ether) return 7;
222 
223         if(b >= 65000 ether) return 6;
224         if(b >= 64500 ether) return 2;
225         if(b >= 64000 ether) return 1;
226         if(b >= 63500 ether) return 0;
227         if(b >= 63000 ether) return 4;
228         if(b >= 62500 ether) return 3;
229         if(b >= 62000 ether) return 2;
230         if(b >= 61500 ether) return 1;
231         if(b >= 61000 ether) return 3;
232         if(b >= 60500 ether) return 0;
233 
234         if(b >= 59800 ether) return 6;
235         if(b >= 59700 ether) return 2;
236         if(b >= 59600 ether) return 1;
237         if(b >= 59500 ether) return 0;
238         if(b >= 59000 ether) return 4;
239         if(b >= 58500 ether) return 3;
240         if(b >= 58000 ether) return 2;
241         if(b >= 57500 ether) return 1;
242         if(b >= 57000 ether) return 3;
243         if(b >= 56500 ether) return 0;
244 
245         if(b >= 55000 ether) return 6;
246         if(b >= 54500 ether) return 2;
247         if(b >= 54000 ether) return 1;
248         if(b >= 53500 ether) return 0;
249         if(b >= 53000 ether) return 4;
250         if(b >= 52500 ether) return 3;
251         if(b >= 52000 ether) return 2;
252         if(b >= 51500 ether) return 1;
253         if(b >= 51000 ether) return 3;
254         if(b >= 50500 ether) return 0;
255 
256         if(b >= 48000 ether) return 8;
257         if(b >= 46000 ether) return 5;
258         if(b >= 44000 ether) return 3;
259         if(b >= 42000 ether) return 4;
260         if(b >= 40000 ether) return 5;
261         if(b >= 38000 ether) return 3;
262         if(b >= 36000 ether) return 4;
263         if(b >= 34000 ether) return 3;
264         if(b >= 32000 ether) return 5;
265         if(b >= 30000 ether) return 7;
266 
267         if(b >= 27000 ether) return 6;
268         if(b >= 26000 ether) return 2;
269         if(b >= 25000 ether) return 5;
270         if(b >= 24000 ether) return 2;
271         if(b >= 23000 ether) return 4;
272         if(b >= 22000 ether) return 3;
273         if(b >= 21000 ether) return 2;
274         if(b >= 20000 ether) return 4;
275         if(b >= 19000 ether) return 3;
276         if(b >= 18000 ether) return 8;
277 
278         if(b >= 17500 ether) return 7;
279         if(b >= 17000 ether) return 2;
280         if(b >= 16500 ether) return 3;
281         if(b >= 16000 ether) return 0;
282         if(b >= 15500 ether) return 5;
283         if(b >= 15000 ether) return 3;
284         if(b >= 14500 ether) return 4;
285         if(b >= 14000 ether) return 3;
286         if(b >= 13500 ether) return 5;
287         if(b >= 13000 ether) return 7;
288 
289         if(b >= 12500 ether) return 6;
290         if(b >= 12250 ether) return 2;
291         if(b >= 12000 ether) return 3;
292         if(b >= 11750 ether) return 1;
293         if(b >= 11500 ether) return 4;
294         if(b >= 11250 ether) return 5;
295         if(b >= 11000 ether) return 3;
296         if(b >= 10750 ether) return 0;
297         if(b >= 10500 ether) return 3;
298         if(b >= 10250 ether) return 4;
299 
300         if(b >= 10000 ether) return 7;
301         if(b >= 9950 ether) return 2;
302         if(b >= 9900 ether) return 3;
303         if(b >= 9850 ether) return 0;
304         if(b >= 9800 ether) return 5;
305         if(b >= 9750 ether) return 3;
306         if(b >= 9450 ether) return 2;
307         if(b >= 9400 ether) return 4;
308         if(b >= 9100 ether) return 5;
309         if(b >= 9050 ether) return 6;
310 
311         if(b >= 8750 ether) return 7;
312         if(b >= 8700 ether) return 3;
313         if(b >= 8500 ether) return 2;
314         if(b >= 8450 ether) return 0;
315         if(b >= 8250 ether) return 4;
316         if(b >= 8200 ether) return 3;
317         if(b >= 8000 ether) return 2;
318         if(b >= 7950 ether) return 4;
319         if(b >= 7750 ether) return 3;
320         if(b >= 7700 ether) return 5;
321 
322         if(b >= 7500 ether) return 7;
323         if(b >= 7400 ether) return 2;
324         if(b >= 7300 ether) return 3;
325         if(b >= 7200 ether) return 0;
326         if(b >= 7100 ether) return 5;
327         if(b >= 7000 ether) return 3;
328         if(b >= 6900 ether) return 1;
329         if(b >= 6800 ether) return 3;
330         if(b >= 6700 ether) return 5;
331         if(b >= 6600 ether) return 7;
332 
333         if(b >= 6500 ether) return 6;
334         if(b >= 6450 ether) return 2;
335         if(b >= 6400 ether) return 1;
336         if(b >= 6350 ether) return 0;
337         if(b >= 6300 ether) return 4;
338         if(b >= 6250 ether) return 3;
339         if(b >= 6200 ether) return 2;
340         if(b >= 6150 ether) return 0;
341         if(b >= 6100 ether) return 3;
342         if(b >= 6050 ether) return 7;
343 
344         if(b >= 6000 ether) return 5;
345         if(b >= 5970 ether) return 6;
346         if(b >= 5940 ether) return 3;
347         if(b >= 5910 ether) return 2;
348         if(b >= 5880 ether) return 1;
349         if(b >= 5850 ether) return 4;
350         if(b >= 5820 ether) return 3;
351         if(b >= 5790 ether) return 0;
352         if(b >= 5760 ether) return 2;
353         if(b >= 5730 ether) return 4;
354 
355         if(b >= 5700 ether) return 6;
356         if(b >= 5650 ether) return 3;
357         if(b >= 5600 ether) return 5;
358         if(b >= 5550 ether) return 0;
359         if(b >= 5500 ether) return 3;
360         if(b >= 5450 ether) return 1;
361         if(b >= 5400 ether) return 2;
362         if(b >= 5350 ether) return 4;
363         if(b >= 5300 ether) return 0;
364         if(b >= 5250 ether) return 5;
365 
366         if(b >= 5200 ether) return 6;
367         if(b >= 5180 ether) return 4;
368         if(b >= 5160 ether) return 2;
369         if(b >= 5140 ether) return 0;
370         if(b >= 5120 ether) return 2;
371         if(b >= 5100 ether) return 3;
372         if(b >= 5080 ether) return 2;
373         if(b >= 5060 ether) return 0;
374         if(b >= 5040 ether) return 2;
375         if(b >= 5020 ether) return 6;
376 
377         if(b >= 5000 ether) return 5;
378         if(b >= 4950 ether) return 4;
379         if(b >= 4900 ether) return 3;
380         if(b >= 4850 ether) return 2;
381         if(b >= 4800 ether) return 0;
382         if(b >= 4750 ether) return 1;
383         if(b >= 4700 ether) return 3;
384         if(b >= 4650 ether) return 2;
385         if(b >= 4600 ether) return 3;
386         if(b >= 4550 ether) return 2;
387 
388         if(b >= 4500 ether) return 5;
389         if(b >= 4300 ether) return 2;
390         if(b >= 4100 ether) return 3;
391         if(b >= 3900 ether) return 0;
392         if(b >= 3700 ether) return 3;
393         if(b >= 3500 ether) return 2;
394         if(b >= 3300 ether) return 4;
395         if(b >= 3100 ether) return 1;
396         if(b >= 2900 ether) return 0;
397         if(b >= 2700 ether) return 4;
398 
399         if(b >= 2500 ether) return 3;
400         if(b >= 2400 ether) return 4;
401         if(b >= 2300 ether) return 5;
402         if(b >= 2200 ether) return 0;
403         if(b >= 2100 ether) return 2;
404         if(b >= 2000 ether) return 3;
405         if(b >= 1900 ether) return 0;
406         if(b >= 1800 ether) return 3;
407         if(b >= 1700 ether) return 5;
408         if(b >= 1600 ether) return 4;
409 
410         if(b >= 1500 ether) return 5;
411         if(b >= 1450 ether) return 2;
412         if(b >= 1400 ether) return 3;
413         if(b >= 1350 ether) return 2;
414         if(b >= 1300 ether) return 0;
415         if(b >= 1250 ether) return 1;
416         if(b >= 1200 ether) return 2;
417         if(b >= 1150 ether) return 1;
418         if(b >= 1100 ether) return 0;
419         if(b >= 1050 ether) return 5;
420 
421         if(b >= 1000 ether) return 4;
422         if(b >= 990 ether) return 1;
423         if(b >= 980 ether) return 2;
424         if(b >= 970 ether) return 0;
425         if(b >= 960 ether) return 3;
426         if(b >= 950 ether) return 1;
427         if(b >= 940 ether) return 2;
428         if(b >= 930 ether) return 1;
429         if(b >= 920 ether) return 0;
430         if(b >= 910 ether) return 2;
431 
432         if(b >= 900 ether) return 3;
433         if(b >= 880 ether) return 2;
434         if(b >= 860 ether) return 1;
435         if(b >= 840 ether) return 0;
436         if(b >= 820 ether) return 2;
437         if(b >= 800 ether) return 3;
438         if(b >= 780 ether) return 1;
439         if(b >= 760 ether) return 0;
440         if(b >= 740 ether) return 2;
441         if(b >= 720 ether) return 3;
442 
443         if(b >= 700 ether) return 4;
444         if(b >= 680 ether) return 1;
445         if(b >= 660 ether) return 3;
446         if(b >= 640 ether) return 2;
447         if(b >= 620 ether) return 0;
448         if(b >= 600 ether) return 3;
449         if(b >= 580 ether) return 2;
450         if(b >= 560 ether) return 1;
451         if(b >= 540 ether) return 0;
452         if(b >= 520 ether) return 2;
453 
454         if(b >= 500 ether) return 4;
455         if(b >= 490 ether) return 1;
456         if(b >= 480 ether) return 3;
457         if(b >= 470 ether) return 0;
458         if(b >= 460 ether) return 3;
459         if(b >= 450 ether) return 1;
460         if(b >= 440 ether) return 2;
461         if(b >= 430 ether) return 1;
462         if(b >= 420 ether) return 0;
463         if(b >= 410 ether) return 2;
464 
465         if(b >= 400 ether) return 3;
466         if(b >= 390 ether) return 2;
467         if(b >= 380 ether) return 1;
468         if(b >= 370 ether) return 0;
469         if(b >= 360 ether) return 2;
470         if(b >= 350 ether) return 3;
471         if(b >= 340 ether) return 1;
472         if(b >= 330 ether) return 0;
473         if(b >= 320 ether) return 2;
474         if(b >= 310 ether) return 1;
475 
476         if(b >= 300 ether) return 3;
477         if(b >= 290 ether) return 1;
478         if(b >= 280 ether) return 3;
479         if(b >= 270 ether) return 2;
480         if(b >= 260 ether) return 0;
481         if(b >= 250 ether) return 1;
482         if(b >= 240 ether) return 2;
483         if(b >= 230 ether) return 1;
484         if(b >= 220 ether) return 0;
485         if(b >= 210 ether) return 1;
486 
487         if(b >= 200 ether) return 2;
488         if(b >= 190 ether) return 1;
489         if(b >= 180 ether) return 3;
490         if(b >= 170 ether) return 0;
491         if(b >= 160 ether) return 3;
492         if(b >= 150 ether) return 1;
493         if(b >= 140 ether) return 2;
494         if(b >= 130 ether) return 1;
495         if(b >= 120 ether) return 0;
496         if(b >= 110 ether) return 2;
497 
498         if(b >= 100 ether) return 3;
499         if(b >= 99 ether) return 2;
500         if(b >= 98 ether) return 1;
501         if(b >= 97 ether) return 0;
502         if(b >= 96 ether) return 2;
503         if(b >= 95 ether) return 3;
504         if(b >= 94 ether) return 1;
505         if(b >= 93 ether) return 0;
506         if(b >= 92 ether) return 2;
507         if(b >= 91 ether) return 3;
508 
509         if(b >= 90 ether) return 2;
510         if(b >= 89 ether) return 1;
511         if(b >= 88 ether) return 3;
512         if(b >= 87 ether) return 2;
513         if(b >= 86 ether) return 0;
514         if(b >= 85 ether) return 1;
515         if(b >= 84 ether) return 2;
516         if(b >= 83 ether) return 1;
517         if(b >= 82 ether) return 0;
518         if(b >= 81 ether) return 1;
519 
520         if(b >= 80 ether) return 3;
521         if(b >= 79 ether) return 1;
522         if(b >= 78 ether) return 3;
523         if(b >= 77 ether) return 2;
524         if(b >= 76 ether) return 0;
525         if(b >= 75 ether) return 1;
526         if(b >= 74 ether) return 2;
527         if(b >= 73 ether) return 1;
528         if(b >= 72 ether) return 0;
529         if(b >= 71 ether) return 1;
530 
531         if(b >= 70 ether) return 2;
532         if(b >= 69 ether) return 1;
533         if(b >= 68 ether) return 3;
534         if(b >= 67 ether) return 0;
535         if(b >= 66 ether) return 3;
536         if(b >= 65 ether) return 1;
537         if(b >= 64 ether) return 2;
538         if(b >= 63 ether) return 1;
539         if(b >= 62 ether) return 0;
540         if(b >= 61 ether) return 2;
541 
542         if(b >= 60 ether) return 3;
543         if(b >= 59 ether) return 1;
544         if(b >= 58 ether) return 3;
545         if(b >= 57 ether) return 2;
546         if(b >= 56 ether) return 0;
547         if(b >= 55 ether) return 1;
548         if(b >= 54 ether) return 2;
549         if(b >= 53 ether) return 1;
550         if(b >= 52 ether) return 0;
551         if(b >= 51 ether) return 2;
552 
553         if(b >= 50 ether) return 3;
554         if(b >= 49 ether) return 2;
555         if(b >= 48 ether) return 1;
556         if(b >= 47 ether) return 0;
557         if(b >= 46 ether) return 2;
558         if(b >= 45 ether) return 3;
559         if(b >= 44 ether) return 1;
560         if(b >= 43 ether) return 0;
561         if(b >= 42 ether) return 2;
562         if(b >= 41 ether) return 1;
563 
564         if(b >= 40 ether) return 3;
565         if(b >= 39 ether) return 1;
566         if(b >= 38 ether) return 3;
567         if(b >= 37 ether) return 2;
568         if(b >= 36 ether) return 0;
569         if(b >= 35 ether) return 1;
570         if(b >= 34 ether) return 2;
571         if(b >= 33 ether) return 1;
572         if(b >= 32 ether) return 0;
573         if(b >= 31 ether) return 1;
574 
575         if(b >= 30 ether) return 2;
576         if(b >= 29 ether) return 1;
577         if(b >= 28 ether) return 3;
578         if(b >= 27 ether) return 0;
579         if(b >= 26 ether) return 3;
580         if(b >= 25 ether) return 1;
581         if(b >= 24 ether) return 2;
582         if(b >= 23 ether) return 1;
583         if(b >= 22 ether) return 0;
584         if(b >= 21 ether) return 2;
585 
586         if(b >= 20 ether) return 3;
587         if(b >= 19 ether) return 2;
588         if(b >= 18 ether) return 1;
589         if(b >= 17 ether) return 0;
590         if(b >= 16 ether) return 2;
591         if(b >= 15 ether) return 3;
592         if(b >= 14 ether) return 1;
593         if(b >= 13 ether) return 0;
594         if(b >= 12 ether) return 2;
595         if(b >= 11 ether) return 1;
596 
597         if(b >= 10 ether) return 3;
598         if(b >= 9 ether) return 1;
599         if(b >= 8 ether) return 3;
600         if(b >= 7 ether) return 2;
601         if(b >= 6 ether) return 0;
602         if(b >= 5 ether) return 1;
603         if(b >= 4 ether) return 2;
604         if(b >= 3 ether) return 1;
605         if(b >= 2 ether) return 0;
606         if(b >= 1 ether) return 2;
607         return 1;
608 
609             }
610 
611     function payoutSize(address _to) view public returns(uint) {
612         uint max = investors[_to].invested.mul(MULTIPLICATION);
613         if(investors[_to].invested == 0 || investors[_to].payouts >= max) return 0;
614 
615         uint payout = investors[_to].invested.mul(bonusSize()).div(100).mul(block.timestamp.sub(investors[_to].last_payout)).div(1 days);
616         return investors[_to].payouts.add(payout) > max ? max.sub(investors[_to].payouts) : payout;
617 
618         
619 
620 
621     }
622 
623     function withdrawSize(address _to) view public returns(uint) {
624         uint max = investors[_to].invested.div(100).mul(WITHDRAW);
625         if(investors[_to].invested == 0 || investors[_to].payouts >= max) return 0;
626 
627         return max.sub(investors[_to].payouts);
628     }
629 
630     function bytesToAddress(bytes memory bys) pure private returns(address addr) {
631         assembly {
632             addr := mload(add(bys, 20))
633         }
634     }
635 
636     function() payable external {
637         if(investors[msg.sender].invested > 0) {
638             uint payout = payoutSize(msg.sender);
639 
640             require(msg.value > 0 || payout > 0, "No payouts");
641 
642             if(payout > 0) {
643                 investors[msg.sender].last_payout = block.timestamp;
644                 investors[msg.sender].payouts = investors[msg.sender].payouts.add(payout);
645 
646                 msg.sender.transfer(payout);
647 
648                 emit Payout(msg.sender, payout);
649             }
650 
651             if(investors[msg.sender].payouts >= investors[msg.sender].invested.mul(MULTIPLICATION)) {
652                 delete investors[msg.sender];
653 
654                 emit Withdraw(msg.sender, 0);
655                 
656                 
657             }
658         }
659 
660         if(msg.value == 0.00000051 ether) {
661             require(investors[msg.sender].invested > 0, "You have not invested anything yet");
662 
663             uint amount = withdrawSize(msg.sender);
664 
665             require(amount > 0, "You have nothing to withdraw");
666             
667             msg.sender.transfer(amount);
668             contractfunds.transfer(msg.value.mul(DEVWORK).div(1));
669 
670             delete investors[msg.sender];
671             
672             emit Withdraw(msg.sender, amount);
673 
674             
675             
676         }
677         else if(msg.value > 0) {
678             require(msg.value >= 0.05 ether, "Minimum investment amount 0.05 ether");
679 
680             investors[msg.sender].last_payout = block.timestamp;
681             investors[msg.sender].invested = investors[msg.sender].invested.add(msg.value);
682 
683             contractfunds.transfer(msg.value.mul(BACKTOCONTRACT).div(100));
684             
685 
686             if(investors[msg.sender].first_invest == 0) {
687                 investors[msg.sender].first_invest = block.timestamp;
688 
689                 if(msg.data.length > 0) {
690                     address ref = bytesToAddress(msg.data);
691 
692                     if(ref != msg.sender && investors[ref].invested > 0 && msg.value >= 1 ether) {
693                         investors[msg.sender].referrer = ref;
694 
695                         uint ref_bonus = msg.value.mul(REFBONUS).div(100);
696                         msg.sender.transfer(ref_bonus);
697 
698                         emit RefBonus(msg.sender, ref, ref_bonus);
699 
700                         uint cashback_bonus = msg.value.mul(CASHBACK).div(100);
701                         msg.sender.transfer(cashback_bonus);
702 
703                         emit CashBack(msg.sender, cashback_bonus);
704                     }
705                 }
706                 emit AddInvestor(msg.sender);
707             }
708 
709             emit Deposit(msg.sender, msg.value, investors[msg.sender].referrer);
710         }
711     }
712 }