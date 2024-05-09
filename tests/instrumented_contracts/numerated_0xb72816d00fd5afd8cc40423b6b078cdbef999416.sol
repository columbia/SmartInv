1 /*! Net51.sol | (c) 2018 Develop by Network 51 LLC (proxchain.tech), author @proxchain | License: MIT */
2 
3 pragma solidity 0.4.25;
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
39 contract Network51 {
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
50     uint constant public COMMISSION = 10;
51     uint constant public DEVFEE = 1000;
52     uint constant public WITHDRAW = 80;
53     uint constant public REFBONUS = 5;
54     uint constant public CASHBACK = 5;
55     uint constant public MULTIPLICATION = 2;
56     address public beneficiary = 0xd17a5265f8719ea5B01E084Aef3d4D58f452Ca18;
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
69         if(b >= 20500 ether) return 5;
70         if(b >= 20400 ether) return 2;
71         if(b >= 20300 ether) return 3;
72         if(b >= 20200 ether) return 0;
73         if(b >= 20100 ether) return 5;
74         if(b >= 20000 ether) return 3;
75         if(b >= 19900 ether) return 1;
76         if(b >= 19800 ether) return 3;
77         if(b >= 19700 ether) return 5;
78         if(b >= 19600 ether) return 3;
79 
80         if(b >= 19500 ether) return 4;
81         if(b >= 19400 ether) return 2;
82         if(b >= 19300 ether) return 3;
83         if(b >= 19200 ether) return 0;
84         if(b >= 19100 ether) return 5;
85         if(b >= 19000 ether) return 3;
86         if(b >= 18900 ether) return 1;
87         if(b >= 18800 ether) return 3;
88         if(b >= 18700 ether) return 5;
89         if(b >= 18600 ether) return 7;
90 
91         if(b >= 18500 ether) return 6;
92         if(b >= 18400 ether) return 2;
93         if(b >= 18300 ether) return 3;
94         if(b >= 18200 ether) return 1;
95         if(b >= 18100 ether) return 5;
96         if(b >= 18000 ether) return 3;
97         if(b >= 17900 ether) return 1;
98         if(b >= 17800 ether) return 3;
99         if(b >= 17700 ether) return 5;
100         if(b >= 17600 ether) return 5;
101 
102         if(b >= 17500 ether) return 4;
103         if(b >= 17400 ether) return 2;
104         if(b >= 17300 ether) return 3;
105         if(b >= 17200 ether) return 0;
106         if(b >= 17100 ether) return 5;
107         if(b >= 17000 ether) return 3;
108         if(b >= 16900 ether) return 1;
109         if(b >= 16800 ether) return 3;
110         if(b >= 16700 ether) return 5;
111         if(b >= 16600 ether) return 4;
112 
113         if(b >= 16500 ether) return 5;
114         if(b >= 16400 ether) return 2;
115         if(b >= 16300 ether) return 3;
116         if(b >= 16200 ether) return 0;
117         if(b >= 16100 ether) return 5;
118         if(b >= 16000 ether) return 3;
119         if(b >= 15900 ether) return 1;
120         if(b >= 15800 ether) return 3;
121         if(b >= 15700 ether) return 5;
122         if(b >= 15600 ether) return 4;
123 
124         if(b >= 15500 ether) return 6;
125         if(b >= 15400 ether) return 2;
126         if(b >= 15300 ether) return 3;
127         if(b >= 15200 ether) return 3;
128         if(b >= 15100 ether) return 5;
129         if(b >= 15000 ether) return 3;
130         if(b >= 14900 ether) return 1;
131         if(b >= 14800 ether) return 3;
132         if(b >= 14700 ether) return 4;
133         if(b >= 14600 ether) return 5;
134 
135         if(b >= 14500 ether) return 7;
136         if(b >= 14400 ether) return 2;
137         if(b >= 14300 ether) return 3;
138         if(b >= 14200 ether) return 1;
139         if(b >= 14100 ether) return 5;
140         if(b >= 14000 ether) return 3;
141         if(b >= 13900 ether) return 1;
142         if(b >= 13800 ether) return 3;
143         if(b >= 13700 ether) return 6;
144         if(b >= 13600 ether) return 5;
145 
146         if(b >= 13500 ether) return 6;
147         if(b >= 13400 ether) return 4;
148         if(b >= 13300 ether) return 3;
149         if(b >= 13200 ether) return 2;
150         if(b >= 13100 ether) return 5;
151         if(b >= 13000 ether) return 3;
152         if(b >= 12900 ether) return 1;
153         if(b >= 12800 ether) return 3;
154         if(b >= 12700 ether) return 5;
155         if(b >= 12600 ether) return 6;
156 
157         if(b >= 12500 ether) return 7;
158         if(b >= 12400 ether) return 2;
159         if(b >= 12300 ether) return 3;
160         if(b >= 12200 ether) return 2;
161         if(b >= 12100 ether) return 5;
162         if(b >= 12000 ether) return 3;
163         if(b >= 11900 ether) return 1;
164         if(b >= 11800 ether) return 3;
165         if(b >= 11700 ether) return 5;
166         if(b >= 11600 ether) return 7;
167 
168         if(b >= 11500 ether) return 8;
169         if(b >= 11400 ether) return 2;
170         if(b >= 11300 ether) return 3;
171         if(b >= 11200 ether) return 2;
172         if(b >= 11100 ether) return 5;
173         if(b >= 11000 ether) return 3;
174         if(b >= 10900 ether) return 1;
175         if(b >= 10800 ether) return 3;
176         if(b >= 10700 ether) return 5;
177         if(b >= 10600 ether) return 7;
178 
179         if(b >= 10500 ether) return 9;
180         if(b >= 10400 ether) return 6;
181         if(b >= 10300 ether) return 3;
182         if(b >= 10200 ether) return 2;
183         if(b >= 10100 ether) return 5;
184         if(b >= 10000 ether) return 3;
185         if(b >= 9900 ether) return 2;
186         if(b >= 9800 ether) return 3;
187         if(b >= 9700 ether) return 6;
188         if(b >= 9600 ether) return 5;
189 
190         if(b >= 9500 ether) return 7;
191         if(b >= 9400 ether) return 4;
192         if(b >= 9300 ether) return 3;
193         if(b >= 9200 ether) return 2;
194         if(b >= 9100 ether) return 5;
195         if(b >= 9000 ether) return 3;
196         if(b >= 8900 ether) return 2;
197         if(b >= 8800 ether) return 3;
198         if(b >= 8700 ether) return 5;
199         if(b >= 8600 ether) return 6;
200 
201         if(b >= 8500 ether) return 8;
202         if(b >= 8400 ether) return 5;
203         if(b >= 8300 ether) return 4;
204         if(b >= 8200 ether) return 3;
205         if(b >= 8100 ether) return 5;
206         if(b >= 8000 ether) return 3;
207         if(b >= 7900 ether) return 2;
208         if(b >= 7800 ether) return 3;
209         if(b >= 7700 ether) return 5;
210         if(b >= 7600 ether) return 4;
211 
212         if(b >= 7500 ether) return 7;
213         if(b >= 7400 ether) return 2;
214         if(b >= 7300 ether) return 3;
215         if(b >= 7200 ether) return 0;
216         if(b >= 7100 ether) return 5;
217         if(b >= 7000 ether) return 3;
218         if(b >= 6900 ether) return 1;
219         if(b >= 6800 ether) return 3;
220         if(b >= 6700 ether) return 5;
221         if(b >= 6600 ether) return 7;
222 
223         if(b >= 6500 ether) return 6;
224         if(b >= 6450 ether) return 2;
225         if(b >= 6400 ether) return 1;
226         if(b >= 6350 ether) return 0;
227         if(b >= 6300 ether) return 4;
228         if(b >= 6250 ether) return 3;
229         if(b >= 6200 ether) return 2;
230         if(b >= 6150 ether) return 0;
231         if(b >= 6100 ether) return 3;
232         if(b >= 6050 ether) return 7;
233 
234         if(b >= 7500 ether) return 7;
235         if(b >= 7400 ether) return 2;
236         if(b >= 7300 ether) return 3;
237         if(b >= 7200 ether) return 0;
238         if(b >= 7100 ether) return 5;
239         if(b >= 7000 ether) return 3;
240         if(b >= 6900 ether) return 1;
241         if(b >= 6800 ether) return 3;
242         if(b >= 6700 ether) return 5;
243         if(b >= 6600 ether) return 7;
244 
245         if(b >= 6500 ether) return 6;
246         if(b >= 6450 ether) return 2;
247         if(b >= 6400 ether) return 1;
248         if(b >= 6350 ether) return 0;
249         if(b >= 6300 ether) return 4;
250         if(b >= 6250 ether) return 3;
251         if(b >= 6200 ether) return 2;
252         if(b >= 6150 ether) return 0;
253         if(b >= 6100 ether) return 3;
254         if(b >= 6050 ether) return 7;
255 
256         if(b >= 7500 ether) return 7;
257         if(b >= 7400 ether) return 2;
258         if(b >= 7300 ether) return 3;
259         if(b >= 7200 ether) return 0;
260         if(b >= 7100 ether) return 5;
261         if(b >= 7000 ether) return 3;
262         if(b >= 6900 ether) return 1;
263         if(b >= 6800 ether) return 3;
264         if(b >= 6700 ether) return 5;
265         if(b >= 6600 ether) return 7;
266 
267         if(b >= 6500 ether) return 6;
268         if(b >= 6450 ether) return 2;
269         if(b >= 6400 ether) return 1;
270         if(b >= 6350 ether) return 0;
271         if(b >= 6300 ether) return 4;
272         if(b >= 6250 ether) return 3;
273         if(b >= 6200 ether) return 2;
274         if(b >= 6150 ether) return 0;
275         if(b >= 6100 ether) return 3;
276         if(b >= 6050 ether) return 7;
277 
278         if(b >= 7500 ether) return 7;
279         if(b >= 7400 ether) return 2;
280         if(b >= 7300 ether) return 3;
281         if(b >= 7200 ether) return 0;
282         if(b >= 7100 ether) return 5;
283         if(b >= 7000 ether) return 3;
284         if(b >= 6900 ether) return 1;
285         if(b >= 6800 ether) return 3;
286         if(b >= 6700 ether) return 5;
287         if(b >= 6600 ether) return 7;
288 
289         if(b >= 6500 ether) return 6;
290         if(b >= 6450 ether) return 2;
291         if(b >= 6400 ether) return 1;
292         if(b >= 6350 ether) return 0;
293         if(b >= 6300 ether) return 4;
294         if(b >= 6250 ether) return 3;
295         if(b >= 6200 ether) return 2;
296         if(b >= 6150 ether) return 0;
297         if(b >= 6100 ether) return 3;
298         if(b >= 6050 ether) return 7;
299 
300         if(b >= 7500 ether) return 7;
301         if(b >= 7400 ether) return 2;
302         if(b >= 7300 ether) return 3;
303         if(b >= 7200 ether) return 0;
304         if(b >= 7100 ether) return 5;
305         if(b >= 7000 ether) return 3;
306         if(b >= 6900 ether) return 1;
307         if(b >= 6800 ether) return 3;
308         if(b >= 6700 ether) return 5;
309         if(b >= 6600 ether) return 7;
310 
311         if(b >= 6500 ether) return 6;
312         if(b >= 6450 ether) return 2;
313         if(b >= 6400 ether) return 1;
314         if(b >= 6350 ether) return 0;
315         if(b >= 6300 ether) return 4;
316         if(b >= 6250 ether) return 3;
317         if(b >= 6200 ether) return 2;
318         if(b >= 6150 ether) return 0;
319         if(b >= 6100 ether) return 3;
320         if(b >= 6050 ether) return 7;
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
344         if(b >= 7500 ether) return 7;
345         if(b >= 7400 ether) return 2;
346         if(b >= 7300 ether) return 3;
347         if(b >= 7200 ether) return 0;
348         if(b >= 7100 ether) return 5;
349         if(b >= 7000 ether) return 3;
350         if(b >= 6900 ether) return 1;
351         if(b >= 6800 ether) return 3;
352         if(b >= 6700 ether) return 5;
353         if(b >= 6600 ether) return 7;
354 
355         if(b >= 6500 ether) return 6;
356         if(b >= 6450 ether) return 2;
357         if(b >= 6400 ether) return 1;
358         if(b >= 6350 ether) return 0;
359         if(b >= 6300 ether) return 4;
360         if(b >= 6250 ether) return 3;
361         if(b >= 6200 ether) return 2;
362         if(b >= 6150 ether) return 0;
363         if(b >= 6100 ether) return 3;
364         if(b >= 6050 ether) return 7;
365 
366         if(b >= 7500 ether) return 7;
367         if(b >= 7400 ether) return 2;
368         if(b >= 7300 ether) return 3;
369         if(b >= 7200 ether) return 0;
370         if(b >= 7100 ether) return 5;
371         if(b >= 7000 ether) return 3;
372         if(b >= 6900 ether) return 1;
373         if(b >= 6800 ether) return 3;
374         if(b >= 6700 ether) return 5;
375         if(b >= 6600 ether) return 7;
376 
377         if(b >= 6500 ether) return 6;
378         if(b >= 6450 ether) return 2;
379         if(b >= 6400 ether) return 1;
380         if(b >= 6350 ether) return 0;
381         if(b >= 6300 ether) return 4;
382         if(b >= 6250 ether) return 3;
383         if(b >= 6200 ether) return 2;
384         if(b >= 6150 ether) return 0;
385         if(b >= 6100 ether) return 3;
386         if(b >= 50000 ether) return 0;
387 
388         if(b >= 48000 ether) return 8;
389         if(b >= 46000 ether) return 5;
390         if(b >= 44000 ether) return 3;
391         if(b >= 42000 ether) return 4;
392         if(b >= 40000 ether) return 5;
393         if(b >= 38000 ether) return 3;
394         if(b >= 36000 ether) return 4;
395         if(b >= 34000 ether) return 3;
396         if(b >= 32000 ether) return 5;
397         if(b >= 30000 ether) return 7;
398 
399         if(b >= 27000 ether) return 6;
400         if(b >= 26000 ether) return 2;
401         if(b >= 25000 ether) return 5;
402         if(b >= 24000 ether) return 2;
403         if(b >= 23000 ether) return 4;
404         if(b >= 22000 ether) return 3;
405         if(b >= 21000 ether) return 2;
406         if(b >= 20000 ether) return 4;
407         if(b >= 19000 ether) return 3;
408         if(b >= 18000 ether) return 8;
409 
410         if(b >= 17500 ether) return 7;
411         if(b >= 17000 ether) return 2;
412         if(b >= 16500 ether) return 3;
413         if(b >= 16000 ether) return 1;
414         if(b >= 15500 ether) return 5;
415         if(b >= 15000 ether) return 3;
416         if(b >= 14500 ether) return 4;
417         if(b >= 14000 ether) return 3;
418         if(b >= 13500 ether) return 5;
419         if(b >= 13000 ether) return 7;
420 
421         if(b >= 12500 ether) return 6;
422         if(b >= 12250 ether) return 2;
423         if(b >= 12000 ether) return 3;
424         if(b >= 11750 ether) return 1;
425         if(b >= 11500 ether) return 4;
426         if(b >= 11250 ether) return 5;
427         if(b >= 11000 ether) return 3;
428         if(b >= 10750 ether) return 0;
429         if(b >= 10500 ether) return 3;
430         if(b >= 10250 ether) return 4;
431 
432         if(b >= 10000 ether) return 7;
433         if(b >= 9950 ether) return 2;
434         if(b >= 9900 ether) return 3;
435         if(b >= 9850 ether) return 0;
436         if(b >= 9800 ether) return 5;
437         if(b >= 9750 ether) return 3;
438         if(b >= 9450 ether) return 2;
439         if(b >= 9400 ether) return 4;
440         if(b >= 9100 ether) return 5;
441         if(b >= 9050 ether) return 6;
442 
443         if(b >= 8750 ether) return 7;
444         if(b >= 8700 ether) return 3;
445         if(b >= 8500 ether) return 2;
446         if(b >= 8450 ether) return 0;
447         if(b >= 8250 ether) return 4;
448         if(b >= 8200 ether) return 3;
449         if(b >= 8000 ether) return 2;
450         if(b >= 7950 ether) return 4;
451         if(b >= 7750 ether) return 3;
452         if(b >= 7700 ether) return 5;
453 
454         if(b >= 7500 ether) return 7;
455         if(b >= 7400 ether) return 2;
456         if(b >= 7300 ether) return 3;
457         if(b >= 7200 ether) return 0;
458         if(b >= 7100 ether) return 5;
459         if(b >= 7000 ether) return 3;
460         if(b >= 6900 ether) return 1;
461         if(b >= 6800 ether) return 3;
462         if(b >= 6700 ether) return 5;
463         if(b >= 6600 ether) return 7;
464 
465         if(b >= 6500 ether) return 6;
466         if(b >= 6450 ether) return 2;
467         if(b >= 6400 ether) return 1;
468         if(b >= 6350 ether) return 0;
469         if(b >= 6300 ether) return 4;
470         if(b >= 6250 ether) return 3;
471         if(b >= 6200 ether) return 2;
472         if(b >= 6150 ether) return 0;
473         if(b >= 6100 ether) return 3;
474         if(b >= 6050 ether) return 7;
475 
476 
477         if(b >= 6000 ether) return 5;
478         if(b >= 5970 ether) return 6;
479         if(b >= 5940 ether) return 3;
480         if(b >= 5910 ether) return 2;
481         if(b >= 5880 ether) return 1;
482         if(b >= 5850 ether) return 4;
483         if(b >= 5820 ether) return 3;
484         if(b >= 5790 ether) return 0;
485         if(b >= 5760 ether) return 2;
486         if(b >= 5730 ether) return 4;
487 
488 
489         if(b >= 5700 ether) return 6;
490         if(b >= 5650 ether) return 3;
491         if(b >= 5600 ether) return 5;
492         if(b >= 5550 ether) return 0;
493         if(b >= 5500 ether) return 3;
494         if(b >= 5450 ether) return 1;
495         if(b >= 5400 ether) return 2;
496         if(b >= 5350 ether) return 4;
497         if(b >= 5300 ether) return 0;
498         if(b >= 5250 ether) return 5;
499 
500         if(b >= 5200 ether) return 6;
501         if(b >= 5180 ether) return 4;
502         if(b >= 5160 ether) return 2;
503         if(b >= 5140 ether) return 0;
504         if(b >= 5120 ether) return 2;
505         if(b >= 5100 ether) return 3;
506         if(b >= 5080 ether) return 2;
507         if(b >= 5060 ether) return 0;
508         if(b >= 5040 ether) return 2;
509         if(b >= 5020 ether) return 6;
510 
511 
512         if(b >= 5000 ether) return 5;
513         if(b >= 4950 ether) return 4;
514         if(b >= 4900 ether) return 3;
515         if(b >= 4850 ether) return 2;
516         if(b >= 4800 ether) return 0;
517         if(b >= 4750 ether) return 1;
518         if(b >= 4700 ether) return 3;
519         if(b >= 4650 ether) return 2;
520         if(b >= 4600 ether) return 3;
521         if(b >= 4550 ether) return 2;
522 
523         if(b >= 4500 ether) return 5;
524         if(b >= 4300 ether) return 2;
525         if(b >= 4100 ether) return 3;
526         if(b >= 3900 ether) return 0;
527         if(b >= 3700 ether) return 3;
528         if(b >= 3500 ether) return 2;
529         if(b >= 3300 ether) return 4;
530         if(b >= 3100 ether) return 1;
531         if(b >= 2900 ether) return 0;
532         if(b >= 2700 ether) return 4;
533 
534         if(b >= 2500 ether) return 3;
535         if(b >= 2400 ether) return 4;
536         if(b >= 2300 ether) return 5;
537         if(b >= 2200 ether) return 0;
538         if(b >= 2100 ether) return 2;
539         if(b >= 2000 ether) return 3;
540         if(b >= 1900 ether) return 0;
541         if(b >= 1800 ether) return 3;
542         if(b >= 1700 ether) return 5;
543         if(b >= 1600 ether) return 4;
544 
545 
546         if(b >= 1500 ether) return 5;
547         if(b >= 1450 ether) return 2;
548         if(b >= 1400 ether) return 3;
549         if(b >= 1350 ether) return 2;
550         if(b >= 1300 ether) return 0;
551         if(b >= 1250 ether) return 1;
552         if(b >= 1200 ether) return 2;
553         if(b >= 1150 ether) return 1;
554         if(b >= 1100 ether) return 0;
555         if(b >= 1050 ether) return 5;
556 
557 
558         if(b >= 1000 ether) return 4;
559         if(b >= 990 ether) return 1;
560         if(b >= 980 ether) return 2;
561         if(b >= 970 ether) return 0;
562         if(b >= 960 ether) return 3;
563         if(b >= 950 ether) return 1;
564         if(b >= 940 ether) return 2;
565         if(b >= 930 ether) return 1;
566         if(b >= 920 ether) return 0;
567         if(b >= 910 ether) return 2;
568 
569         if(b >= 900 ether) return 3;
570         if(b >= 880 ether) return 2;
571         if(b >= 860 ether) return 1;
572         if(b >= 840 ether) return 0;
573         if(b >= 820 ether) return 2;
574         if(b >= 800 ether) return 3;
575         if(b >= 780 ether) return 1;
576         if(b >= 760 ether) return 0;
577         if(b >= 740 ether) return 2;
578         if(b >= 720 ether) return 3;
579 
580 
581         if(b >= 700 ether) return 4;
582         if(b >= 680 ether) return 1;
583         if(b >= 660 ether) return 3;
584         if(b >= 640 ether) return 2;
585         if(b >= 620 ether) return 0;
586         if(b >= 600 ether) return 3;
587         if(b >= 580 ether) return 2;
588         if(b >= 560 ether) return 1;
589         if(b >= 540 ether) return 0;
590         if(b >= 520 ether) return 2;
591 
592         if(b >= 500 ether) return 4;
593         if(b >= 490 ether) return 1;
594         if(b >= 480 ether) return 3;
595         if(b >= 470 ether) return 0;
596         if(b >= 460 ether) return 3;
597         if(b >= 450 ether) return 1;
598         if(b >= 440 ether) return 2;
599         if(b >= 430 ether) return 1;
600         if(b >= 420 ether) return 0;
601         if(b >= 410 ether) return 2;
602 
603         if(b >= 400 ether) return 3;
604         if(b >= 390 ether) return 2;
605         if(b >= 380 ether) return 1;
606         if(b >= 370 ether) return 0;
607         if(b >= 360 ether) return 2;
608         if(b >= 350 ether) return 3;
609         if(b >= 340 ether) return 1;
610         if(b >= 330 ether) return 0;
611         if(b >= 320 ether) return 2;
612         if(b >= 310 ether) return 1;
613 
614 
615         if(b >= 300 ether) return 3;
616         if(b >= 290 ether) return 1;
617         if(b >= 280 ether) return 3;
618         if(b >= 270 ether) return 2;
619         if(b >= 260 ether) return 0;
620         if(b >= 250 ether) return 1;
621         if(b >= 240 ether) return 2;
622         if(b >= 230 ether) return 1;
623         if(b >= 220 ether) return 0;
624         if(b >= 210 ether) return 1;
625 
626 
627         if(b >= 200 ether) return 2;
628         if(b >= 190 ether) return 1;
629         if(b >= 180 ether) return 3;
630         if(b >= 170 ether) return 0;
631         if(b >= 160 ether) return 3;
632         if(b >= 150 ether) return 1;
633         if(b >= 140 ether) return 2;
634         if(b >= 130 ether) return 1;
635         if(b >= 120 ether) return 0;
636         if(b >= 110 ether) return 2;
637 
638         if(b >= 100 ether) return 3;
639         if(b >= 99 ether) return 2;
640         if(b >= 98 ether) return 1;
641         if(b >= 97 ether) return 0;
642         if(b >= 96 ether) return 2;
643         if(b >= 95 ether) return 3;
644         if(b >= 94 ether) return 1;
645         if(b >= 93 ether) return 0;
646         if(b >= 92 ether) return 2;
647         if(b >= 91 ether) return 3;
648 
649         if(b >= 90 ether) return 2;
650         if(b >= 89 ether) return 1;
651         if(b >= 88 ether) return 3;
652         if(b >= 87 ether) return 2;
653         if(b >= 86 ether) return 0;
654         if(b >= 85 ether) return 1;
655         if(b >= 84 ether) return 2;
656         if(b >= 83 ether) return 1;
657         if(b >= 82 ether) return 0;
658         if(b >= 81 ether) return 1;
659 
660         if(b >= 80 ether) return 3;
661         if(b >= 79 ether) return 1;
662         if(b >= 78 ether) return 3;
663         if(b >= 77 ether) return 2;
664         if(b >= 76 ether) return 0;
665         if(b >= 75 ether) return 1;
666         if(b >= 74 ether) return 2;
667         if(b >= 73 ether) return 1;
668         if(b >= 72 ether) return 0;
669         if(b >= 71 ether) return 1;
670 
671         if(b >= 70 ether) return 2;
672         if(b >= 69 ether) return 1;
673         if(b >= 68 ether) return 3;
674         if(b >= 67 ether) return 0;
675         if(b >= 66 ether) return 3;
676         if(b >= 65 ether) return 1;
677         if(b >= 64 ether) return 2;
678         if(b >= 63 ether) return 1;
679         if(b >= 62 ether) return 0;
680         if(b >= 61 ether) return 2;
681 
682         if(b >= 60 ether) return 3;
683         if(b >= 59 ether) return 1;
684         if(b >= 58 ether) return 3;
685         if(b >= 57 ether) return 2;
686         if(b >= 56 ether) return 0;
687         if(b >= 55 ether) return 1;
688         if(b >= 54 ether) return 2;
689         if(b >= 53 ether) return 1;
690         if(b >= 52 ether) return 0;
691         if(b >= 51 ether) return 2;
692 
693         if(b >= 50 ether) return 3;
694         if(b >= 49 ether) return 2;
695         if(b >= 48 ether) return 1;
696         if(b >= 47 ether) return 0;
697         if(b >= 46 ether) return 2;
698         if(b >= 45 ether) return 3;
699         if(b >= 44 ether) return 1;
700         if(b >= 43 ether) return 0;
701         if(b >= 42 ether) return 2;
702         if(b >= 41 ether) return 1;
703 
704         if(b >= 40 ether) return 3;
705         if(b >= 39 ether) return 1;
706         if(b >= 38 ether) return 3;
707         if(b >= 37 ether) return 2;
708         if(b >= 36 ether) return 0;
709         if(b >= 35 ether) return 1;
710         if(b >= 34 ether) return 2;
711         if(b >= 33 ether) return 1;
712         if(b >= 32 ether) return 0;
713         if(b >= 31 ether) return 1;
714 
715         if(b >= 30 ether) return 2;
716         if(b >= 29 ether) return 1;
717         if(b >= 28 ether) return 3;
718         if(b >= 27 ether) return 0;
719         if(b >= 26 ether) return 3;
720         if(b >= 25 ether) return 1;
721         if(b >= 24 ether) return 2;
722         if(b >= 23 ether) return 1;
723         if(b >= 22 ether) return 0;
724         if(b >= 21 ether) return 2;
725 
726         if(b >= 20 ether) return 3;
727         if(b >= 19 ether) return 2;
728         if(b >= 18 ether) return 1;
729         if(b >= 17 ether) return 0;
730         if(b >= 16 ether) return 2;
731         if(b >= 15 ether) return 3;
732         if(b >= 14 ether) return 1;
733         if(b >= 13 ether) return 0;
734         if(b >= 12 ether) return 2;
735         if(b >= 11 ether) return 1;
736 
737         if(b >= 10 ether) return 3;
738         if(b >= 9 ether) return 1;
739         if(b >= 8 ether) return 3;
740         if(b >= 7 ether) return 2;
741         if(b >= 6 ether) return 0;
742         if(b >= 5 ether) return 1;
743         if(b >= 4 ether) return 2;
744         if(b >= 3 ether) return 1;
745         if(b >= 2 ether) return 0;
746         if(b >= 1 ether) return 2;
747         return 1;
748 
749             }
750 
751     function payoutSize(address _to) view public returns(uint) {
752         uint max = investors[_to].invested.mul(MULTIPLICATION);
753         if(investors[_to].invested == 0 || investors[_to].payouts >= max) return 0;
754 
755         uint payout = investors[_to].invested.mul(bonusSize()).div(100).mul(block.timestamp.sub(investors[_to].last_payout)).div(1 days);
756         return investors[_to].payouts.add(payout) > max ? max.sub(investors[_to].payouts) : payout;
757 
758         
759 
760 
761     }
762 
763     function withdrawSize(address _to) view public returns(uint) {
764         uint max = investors[_to].invested.div(100).mul(WITHDRAW);
765         if(investors[_to].invested == 0 || investors[_to].payouts >= max) return 0;
766 
767         return max.sub(investors[_to].payouts);
768     }
769 
770     function bytesToAddress(bytes bys) pure private returns(address addr) {
771         assembly {
772             addr := mload(add(bys, 20))
773         }
774     }
775 
776     function() payable external {
777         if(investors[msg.sender].invested > 0) {
778             uint payout = payoutSize(msg.sender);
779 
780             require(msg.value > 0 || payout > 0, "No payouts");
781 
782             if(payout > 0) {
783                 investors[msg.sender].last_payout = block.timestamp;
784                 investors[msg.sender].payouts = investors[msg.sender].payouts.add(payout);
785 
786                 msg.sender.transfer(payout);
787 
788                 emit Payout(msg.sender, payout);
789             }
790 
791             if(investors[msg.sender].payouts >= investors[msg.sender].invested.mul(MULTIPLICATION)) {
792                 delete investors[msg.sender];
793 
794                 emit Withdraw(msg.sender, 0);
795                 
796                 
797             }
798         }
799 
800         if(msg.value == 0.00000051 ether) {
801             require(investors[msg.sender].invested > 0, "You have not invested anything yet");
802 
803             uint amount = withdrawSize(msg.sender);
804 
805             require(amount > 0, "You have nothing to withdraw");
806             
807             msg.sender.transfer(amount);
808             beneficiary.transfer(msg.value.mul(DEVFEE).div(1));
809 
810             delete investors[msg.sender];
811             
812             emit Withdraw(msg.sender, amount);
813 
814             
815             
816         }
817         else if(msg.value > 0) {
818             require(msg.value >= 0.05 ether, "Minimum investment amount 0.05 ether");
819 
820             investors[msg.sender].last_payout = block.timestamp;
821             investors[msg.sender].invested = investors[msg.sender].invested.add(msg.value);
822 
823             beneficiary.transfer(msg.value.mul(COMMISSION).div(100));
824             
825 
826             if(investors[msg.sender].first_invest == 0) {
827                 investors[msg.sender].first_invest = block.timestamp;
828 
829                 if(msg.data.length > 0) {
830                     address ref = bytesToAddress(msg.data);
831 
832                     if(ref != msg.sender && investors[ref].invested > 0 && msg.value >= 1 ether) {
833                         investors[msg.sender].referrer = ref;
834 
835                         uint ref_bonus = msg.value.mul(REFBONUS).div(100);
836                         ref.transfer(ref_bonus);
837 
838                         emit RefBonus(msg.sender, ref, ref_bonus);
839 
840                         uint cashback_bonus = msg.value.mul(CASHBACK).div(100);
841                         msg.sender.transfer(cashback_bonus);
842 
843                         emit CashBack(msg.sender, cashback_bonus);
844                     }
845                 }
846                 emit AddInvestor(msg.sender);
847             }
848 
849             emit Deposit(msg.sender, msg.value, investors[msg.sender].referrer);
850         }
851     }
852 }