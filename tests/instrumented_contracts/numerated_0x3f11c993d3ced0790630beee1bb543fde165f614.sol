1 /*! Net51.sol | (c) 2018 Develop by Network 51 LLC (proxchain.tech), author @proxchain | License: MIT */
2 
3 pragma solidity 0.4.24;
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
56 
57     address public beneficiary = 0xd17a5265f8719ea5b01e084aef3d4d58f452ca18;
58 
59     mapping(address => Investor) public investors;
60 
61     event AddInvestor(address indexed holder);
62 
63     event Payout(address indexed holder, uint amount);
64     event Deposit(address indexed holder, uint amount, address referrer);
65     event RefBonus(address indexed from, address indexed to, uint amount);
66     event CashBack(address indexed holder, uint amount);
67     event Withdraw(address indexed holder, uint amount);
68 
69     function bonusSize() view public returns(uint) {
70         uint b = address(this).balance;
71 
72         if(b >= 20500 ether) return 5;
73         if(b >= 20400 ether) return 2;
74         if(b >= 20300 ether) return 3;
75         if(b >= 20200 ether) return 0;
76         if(b >= 20100 ether) return 5;
77         if(b >= 20000 ether) return 3;
78         if(b >= 19900 ether) return 1;
79         if(b >= 19800 ether) return 3;
80         if(b >= 19700 ether) return 5;
81         if(b >= 19600 ether) return 3;
82 
83         if(b >= 19500 ether) return 4;
84         if(b >= 19400 ether) return 2;
85         if(b >= 19300 ether) return 3;
86         if(b >= 19200 ether) return 0;
87         if(b >= 19100 ether) return 5;
88         if(b >= 19000 ether) return 3;
89         if(b >= 18900 ether) return 1;
90         if(b >= 18800 ether) return 3;
91         if(b >= 18700 ether) return 5;
92         if(b >= 18600 ether) return 7;
93 
94         if(b >= 18500 ether) return 6;
95         if(b >= 18400 ether) return 2;
96         if(b >= 18300 ether) return 3;
97         if(b >= 18200 ether) return 1;
98         if(b >= 18100 ether) return 5;
99         if(b >= 18000 ether) return 3;
100         if(b >= 17900 ether) return 1;
101         if(b >= 17800 ether) return 3;
102         if(b >= 17700 ether) return 5;
103         if(b >= 17600 ether) return 5;
104 
105         if(b >= 17500 ether) return 4;
106         if(b >= 17400 ether) return 2;
107         if(b >= 17300 ether) return 3;
108         if(b >= 17200 ether) return 0;
109         if(b >= 17100 ether) return 5;
110         if(b >= 17000 ether) return 3;
111         if(b >= 16900 ether) return 1;
112         if(b >= 16800 ether) return 3;
113         if(b >= 16700 ether) return 5;
114         if(b >= 16600 ether) return 4;
115 
116         if(b >= 16500 ether) return 5;
117         if(b >= 16400 ether) return 2;
118         if(b >= 16300 ether) return 3;
119         if(b >= 16200 ether) return 0;
120         if(b >= 16100 ether) return 5;
121         if(b >= 16000 ether) return 3;
122         if(b >= 15900 ether) return 1;
123         if(b >= 15800 ether) return 3;
124         if(b >= 15700 ether) return 5;
125         if(b >= 15600 ether) return 4;
126 
127         if(b >= 15500 ether) return 6;
128         if(b >= 15400 ether) return 2;
129         if(b >= 15300 ether) return 3;
130         if(b >= 15200 ether) return 3;
131         if(b >= 15100 ether) return 5;
132         if(b >= 15000 ether) return 3;
133         if(b >= 14900 ether) return 1;
134         if(b >= 14800 ether) return 3;
135         if(b >= 14700 ether) return 4;
136         if(b >= 14600 ether) return 5;
137 
138         if(b >= 14500 ether) return 7;
139         if(b >= 14400 ether) return 2;
140         if(b >= 14300 ether) return 3;
141         if(b >= 14200 ether) return 1;
142         if(b >= 14100 ether) return 5;
143         if(b >= 14000 ether) return 3;
144         if(b >= 13900 ether) return 1;
145         if(b >= 13800 ether) return 3;
146         if(b >= 13700 ether) return 6;
147         if(b >= 13600 ether) return 5;
148 
149         if(b >= 13500 ether) return 6;
150         if(b >= 13400 ether) return 4;
151         if(b >= 13300 ether) return 3;
152         if(b >= 13200 ether) return 2;
153         if(b >= 13100 ether) return 5;
154         if(b >= 13000 ether) return 3;
155         if(b >= 12900 ether) return 1;
156         if(b >= 12800 ether) return 3;
157         if(b >= 12700 ether) return 5;
158         if(b >= 12600 ether) return 6;
159 
160         if(b >= 12500 ether) return 7;
161         if(b >= 12400 ether) return 2;
162         if(b >= 12300 ether) return 3;
163         if(b >= 12200 ether) return 2;
164         if(b >= 12100 ether) return 5;
165         if(b >= 12000 ether) return 3;
166         if(b >= 11900 ether) return 1;
167         if(b >= 11800 ether) return 3;
168         if(b >= 11700 ether) return 5;
169         if(b >= 11600 ether) return 7;
170 
171         if(b >= 11500 ether) return 8;
172         if(b >= 11400 ether) return 2;
173         if(b >= 11300 ether) return 3;
174         if(b >= 11200 ether) return 2;
175         if(b >= 11100 ether) return 5;
176         if(b >= 11000 ether) return 3;
177         if(b >= 10900 ether) return 1;
178         if(b >= 10800 ether) return 3;
179         if(b >= 10700 ether) return 5;
180         if(b >= 10600 ether) return 7;
181 
182         if(b >= 10500 ether) return 9;
183         if(b >= 10400 ether) return 6;
184         if(b >= 10300 ether) return 3;
185         if(b >= 10200 ether) return 2;
186         if(b >= 10100 ether) return 5;
187         if(b >= 10000 ether) return 3;
188         if(b >= 9900 ether) return 2;
189         if(b >= 9800 ether) return 3;
190         if(b >= 9700 ether) return 6;
191         if(b >= 9600 ether) return 5;
192 
193         if(b >= 9500 ether) return 7;
194         if(b >= 9400 ether) return 4;
195         if(b >= 9300 ether) return 3;
196         if(b >= 9200 ether) return 2;
197         if(b >= 9100 ether) return 5;
198         if(b >= 9000 ether) return 3;
199         if(b >= 8900 ether) return 2;
200         if(b >= 8800 ether) return 3;
201         if(b >= 8700 ether) return 5;
202         if(b >= 8600 ether) return 6;
203 
204         if(b >= 8500 ether) return 8;
205         if(b >= 8400 ether) return 5;
206         if(b >= 8300 ether) return 4;
207         if(b >= 8200 ether) return 3;
208         if(b >= 8100 ether) return 5;
209         if(b >= 8000 ether) return 3;
210         if(b >= 7900 ether) return 2;
211         if(b >= 7800 ether) return 3;
212         if(b >= 7700 ether) return 5;
213         if(b >= 7600 ether) return 4;
214 
215         if(b >= 7500 ether) return 7;
216         if(b >= 7400 ether) return 2;
217         if(b >= 7300 ether) return 3;
218         if(b >= 7200 ether) return 0;
219         if(b >= 7100 ether) return 5;
220         if(b >= 7000 ether) return 3;
221         if(b >= 6900 ether) return 1;
222         if(b >= 6800 ether) return 3;
223         if(b >= 6700 ether) return 5;
224         if(b >= 6600 ether) return 7;
225 
226         if(b >= 6500 ether) return 6;
227         if(b >= 6450 ether) return 2;
228         if(b >= 6400 ether) return 1;
229         if(b >= 6350 ether) return 0;
230         if(b >= 6300 ether) return 4;
231         if(b >= 6250 ether) return 3;
232         if(b >= 6200 ether) return 2;
233         if(b >= 6150 ether) return 0;
234         if(b >= 6100 ether) return 3;
235         if(b >= 6050 ether) return 7;
236 
237         if(b >= 7500 ether) return 7;
238         if(b >= 7400 ether) return 2;
239         if(b >= 7300 ether) return 3;
240         if(b >= 7200 ether) return 0;
241         if(b >= 7100 ether) return 5;
242         if(b >= 7000 ether) return 3;
243         if(b >= 6900 ether) return 1;
244         if(b >= 6800 ether) return 3;
245         if(b >= 6700 ether) return 5;
246         if(b >= 6600 ether) return 7;
247 
248         if(b >= 6500 ether) return 6;
249         if(b >= 6450 ether) return 2;
250         if(b >= 6400 ether) return 1;
251         if(b >= 6350 ether) return 0;
252         if(b >= 6300 ether) return 4;
253         if(b >= 6250 ether) return 3;
254         if(b >= 6200 ether) return 2;
255         if(b >= 6150 ether) return 0;
256         if(b >= 6100 ether) return 3;
257         if(b >= 6050 ether) return 7;
258 
259         if(b >= 7500 ether) return 7;
260         if(b >= 7400 ether) return 2;
261         if(b >= 7300 ether) return 3;
262         if(b >= 7200 ether) return 0;
263         if(b >= 7100 ether) return 5;
264         if(b >= 7000 ether) return 3;
265         if(b >= 6900 ether) return 1;
266         if(b >= 6800 ether) return 3;
267         if(b >= 6700 ether) return 5;
268         if(b >= 6600 ether) return 7;
269 
270         if(b >= 6500 ether) return 6;
271         if(b >= 6450 ether) return 2;
272         if(b >= 6400 ether) return 1;
273         if(b >= 6350 ether) return 0;
274         if(b >= 6300 ether) return 4;
275         if(b >= 6250 ether) return 3;
276         if(b >= 6200 ether) return 2;
277         if(b >= 6150 ether) return 0;
278         if(b >= 6100 ether) return 3;
279         if(b >= 6050 ether) return 7;
280 
281         if(b >= 7500 ether) return 7;
282         if(b >= 7400 ether) return 2;
283         if(b >= 7300 ether) return 3;
284         if(b >= 7200 ether) return 0;
285         if(b >= 7100 ether) return 5;
286         if(b >= 7000 ether) return 3;
287         if(b >= 6900 ether) return 1;
288         if(b >= 6800 ether) return 3;
289         if(b >= 6700 ether) return 5;
290         if(b >= 6600 ether) return 7;
291 
292         if(b >= 6500 ether) return 6;
293         if(b >= 6450 ether) return 2;
294         if(b >= 6400 ether) return 1;
295         if(b >= 6350 ether) return 0;
296         if(b >= 6300 ether) return 4;
297         if(b >= 6250 ether) return 3;
298         if(b >= 6200 ether) return 2;
299         if(b >= 6150 ether) return 0;
300         if(b >= 6100 ether) return 3;
301         if(b >= 6050 ether) return 7;
302 
303         if(b >= 7500 ether) return 7;
304         if(b >= 7400 ether) return 2;
305         if(b >= 7300 ether) return 3;
306         if(b >= 7200 ether) return 0;
307         if(b >= 7100 ether) return 5;
308         if(b >= 7000 ether) return 3;
309         if(b >= 6900 ether) return 1;
310         if(b >= 6800 ether) return 3;
311         if(b >= 6700 ether) return 5;
312         if(b >= 6600 ether) return 7;
313 
314         if(b >= 6500 ether) return 6;
315         if(b >= 6450 ether) return 2;
316         if(b >= 6400 ether) return 1;
317         if(b >= 6350 ether) return 0;
318         if(b >= 6300 ether) return 4;
319         if(b >= 6250 ether) return 3;
320         if(b >= 6200 ether) return 2;
321         if(b >= 6150 ether) return 0;
322         if(b >= 6100 ether) return 3;
323         if(b >= 6050 ether) return 7;
324 
325         if(b >= 7500 ether) return 7;
326         if(b >= 7400 ether) return 2;
327         if(b >= 7300 ether) return 3;
328         if(b >= 7200 ether) return 0;
329         if(b >= 7100 ether) return 5;
330         if(b >= 7000 ether) return 3;
331         if(b >= 6900 ether) return 1;
332         if(b >= 6800 ether) return 3;
333         if(b >= 6700 ether) return 5;
334         if(b >= 6600 ether) return 7;
335 
336         if(b >= 6500 ether) return 6;
337         if(b >= 6450 ether) return 2;
338         if(b >= 6400 ether) return 1;
339         if(b >= 6350 ether) return 0;
340         if(b >= 6300 ether) return 4;
341         if(b >= 6250 ether) return 3;
342         if(b >= 6200 ether) return 2;
343         if(b >= 6150 ether) return 0;
344         if(b >= 6100 ether) return 3;
345         if(b >= 6050 ether) return 7;
346 
347         if(b >= 7500 ether) return 7;
348         if(b >= 7400 ether) return 2;
349         if(b >= 7300 ether) return 3;
350         if(b >= 7200 ether) return 0;
351         if(b >= 7100 ether) return 5;
352         if(b >= 7000 ether) return 3;
353         if(b >= 6900 ether) return 1;
354         if(b >= 6800 ether) return 3;
355         if(b >= 6700 ether) return 5;
356         if(b >= 6600 ether) return 7;
357 
358         if(b >= 6500 ether) return 6;
359         if(b >= 6450 ether) return 2;
360         if(b >= 6400 ether) return 1;
361         if(b >= 6350 ether) return 0;
362         if(b >= 6300 ether) return 4;
363         if(b >= 6250 ether) return 3;
364         if(b >= 6200 ether) return 2;
365         if(b >= 6150 ether) return 0;
366         if(b >= 6100 ether) return 3;
367         if(b >= 6050 ether) return 7;
368 
369         if(b >= 7500 ether) return 7;
370         if(b >= 7400 ether) return 2;
371         if(b >= 7300 ether) return 3;
372         if(b >= 7200 ether) return 0;
373         if(b >= 7100 ether) return 5;
374         if(b >= 7000 ether) return 3;
375         if(b >= 6900 ether) return 1;
376         if(b >= 6800 ether) return 3;
377         if(b >= 6700 ether) return 5;
378         if(b >= 6600 ether) return 7;
379 
380         if(b >= 6500 ether) return 6;
381         if(b >= 6450 ether) return 2;
382         if(b >= 6400 ether) return 1;
383         if(b >= 6350 ether) return 0;
384         if(b >= 6300 ether) return 4;
385         if(b >= 6250 ether) return 3;
386         if(b >= 6200 ether) return 2;
387         if(b >= 6150 ether) return 0;
388         if(b >= 6100 ether) return 3;
389         if(b >= 50000 ether) return 0;
390 
391         if(b >= 48000 ether) return 8;
392         if(b >= 46000 ether) return 5;
393         if(b >= 44000 ether) return 3;
394         if(b >= 42000 ether) return 4;
395         if(b >= 40000 ether) return 5;
396         if(b >= 38000 ether) return 3;
397         if(b >= 36000 ether) return 4;
398         if(b >= 34000 ether) return 3;
399         if(b >= 32000 ether) return 5;
400         if(b >= 30000 ether) return 7;
401 
402         if(b >= 27000 ether) return 6;
403         if(b >= 26000 ether) return 2;
404         if(b >= 25000 ether) return 5;
405         if(b >= 24000 ether) return 2;
406         if(b >= 23000 ether) return 4;
407         if(b >= 22000 ether) return 3;
408         if(b >= 21000 ether) return 2;
409         if(b >= 20000 ether) return 4;
410         if(b >= 19000 ether) return 3;
411         if(b >= 18000 ether) return 8;
412 
413         if(b >= 17500 ether) return 7;
414         if(b >= 17000 ether) return 2;
415         if(b >= 16500 ether) return 3;
416         if(b >= 16000 ether) return 1;
417         if(b >= 15500 ether) return 5;
418         if(b >= 15000 ether) return 3;
419         if(b >= 14500 ether) return 4;
420         if(b >= 14000 ether) return 3;
421         if(b >= 13500 ether) return 5;
422         if(b >= 13000 ether) return 7;
423 
424         if(b >= 12500 ether) return 6;
425         if(b >= 12250 ether) return 2;
426         if(b >= 12000 ether) return 3;
427         if(b >= 11750 ether) return 1;
428         if(b >= 11500 ether) return 4;
429         if(b >= 11250 ether) return 5;
430         if(b >= 11000 ether) return 3;
431         if(b >= 10750 ether) return 0;
432         if(b >= 10500 ether) return 3;
433         if(b >= 10250 ether) return 4;
434 
435         if(b >= 10000 ether) return 7;
436         if(b >= 9950 ether) return 2;
437         if(b >= 9900 ether) return 3;
438         if(b >= 9850 ether) return 0;
439         if(b >= 9800 ether) return 5;
440         if(b >= 9750 ether) return 3;
441         if(b >= 9450 ether) return 2;
442         if(b >= 9400 ether) return 4;
443         if(b >= 9100 ether) return 5;
444         if(b >= 9050 ether) return 6;
445 
446         if(b >= 8750 ether) return 7;
447         if(b >= 8700 ether) return 3;
448         if(b >= 8500 ether) return 2;
449         if(b >= 8450 ether) return 0;
450         if(b >= 8250 ether) return 4;
451         if(b >= 8200 ether) return 3;
452         if(b >= 8000 ether) return 2;
453         if(b >= 7950 ether) return 4;
454         if(b >= 7750 ether) return 3;
455         if(b >= 7700 ether) return 5;
456 
457         if(b >= 7500 ether) return 7;
458         if(b >= 7400 ether) return 2;
459         if(b >= 7300 ether) return 3;
460         if(b >= 7200 ether) return 0;
461         if(b >= 7100 ether) return 5;
462         if(b >= 7000 ether) return 3;
463         if(b >= 6900 ether) return 1;
464         if(b >= 6800 ether) return 3;
465         if(b >= 6700 ether) return 5;
466         if(b >= 6600 ether) return 7;
467 
468         if(b >= 6500 ether) return 6;
469         if(b >= 6450 ether) return 2;
470         if(b >= 6400 ether) return 1;
471         if(b >= 6350 ether) return 0;
472         if(b >= 6300 ether) return 4;
473         if(b >= 6250 ether) return 3;
474         if(b >= 6200 ether) return 2;
475         if(b >= 6150 ether) return 0;
476         if(b >= 6100 ether) return 3;
477         if(b >= 6050 ether) return 7;
478 
479 
480         if(b >= 6000 ether) return 5;
481         if(b >= 5970 ether) return 6;
482         if(b >= 5940 ether) return 3;
483         if(b >= 5910 ether) return 2;
484         if(b >= 5880 ether) return 1;
485         if(b >= 5850 ether) return 4;
486         if(b >= 5820 ether) return 3;
487         if(b >= 5790 ether) return 0;
488         if(b >= 5760 ether) return 2;
489         if(b >= 5730 ether) return 4;
490 
491 
492         if(b >= 5700 ether) return 6;
493         if(b >= 5650 ether) return 3;
494         if(b >= 5600 ether) return 5;
495         if(b >= 5550 ether) return 0;
496         if(b >= 5500 ether) return 3;
497         if(b >= 5450 ether) return 1;
498         if(b >= 5400 ether) return 2;
499         if(b >= 5350 ether) return 4;
500         if(b >= 5300 ether) return 0;
501         if(b >= 5250 ether) return 5;
502 
503         if(b >= 5200 ether) return 6;
504         if(b >= 5180 ether) return 4;
505         if(b >= 5160 ether) return 2;
506         if(b >= 5140 ether) return 0;
507         if(b >= 5120 ether) return 2;
508         if(b >= 5100 ether) return 3;
509         if(b >= 5080 ether) return 2;
510         if(b >= 5060 ether) return 0;
511         if(b >= 5040 ether) return 2;
512         if(b >= 5020 ether) return 6;
513 
514 
515         if(b >= 5000 ether) return 5;
516         if(b >= 4950 ether) return 4;
517         if(b >= 4900 ether) return 3;
518         if(b >= 4850 ether) return 2;
519         if(b >= 4800 ether) return 0;
520         if(b >= 4750 ether) return 1;
521         if(b >= 4700 ether) return 3;
522         if(b >= 4650 ether) return 2;
523         if(b >= 4600 ether) return 3;
524         if(b >= 4550 ether) return 2;
525 
526         if(b >= 4500 ether) return 5;
527         if(b >= 4300 ether) return 2;
528         if(b >= 4100 ether) return 3;
529         if(b >= 3900 ether) return 0;
530         if(b >= 3700 ether) return 3;
531         if(b >= 3500 ether) return 2;
532         if(b >= 3300 ether) return 4;
533         if(b >= 3100 ether) return 1;
534         if(b >= 2900 ether) return 0;
535         if(b >= 2700 ether) return 4;
536 
537         if(b >= 2500 ether) return 3;
538         if(b >= 2400 ether) return 4;
539         if(b >= 2300 ether) return 5;
540         if(b >= 2200 ether) return 0;
541         if(b >= 2100 ether) return 2;
542         if(b >= 2000 ether) return 3;
543         if(b >= 1900 ether) return 0;
544         if(b >= 1800 ether) return 3;
545         if(b >= 1700 ether) return 5;
546         if(b >= 1600 ether) return 4;
547 
548 
549         if(b >= 1500 ether) return 5;
550         if(b >= 1450 ether) return 2;
551         if(b >= 1400 ether) return 3;
552         if(b >= 1350 ether) return 2;
553         if(b >= 1300 ether) return 0;
554         if(b >= 1250 ether) return 1;
555         if(b >= 1200 ether) return 2;
556         if(b >= 1150 ether) return 1;
557         if(b >= 1100 ether) return 0;
558         if(b >= 1050 ether) return 5;
559 
560 
561         if(b >= 1000 ether) return 4;
562         if(b >= 990 ether) return 1;
563         if(b >= 980 ether) return 2;
564         if(b >= 970 ether) return 0;
565         if(b >= 960 ether) return 3;
566         if(b >= 950 ether) return 1;
567         if(b >= 940 ether) return 2;
568         if(b >= 930 ether) return 1;
569         if(b >= 920 ether) return 0;
570         if(b >= 910 ether) return 2;
571 
572         if(b >= 900 ether) return 3;
573         if(b >= 880 ether) return 2;
574         if(b >= 860 ether) return 1;
575         if(b >= 840 ether) return 0;
576         if(b >= 820 ether) return 2;
577         if(b >= 800 ether) return 3;
578         if(b >= 780 ether) return 1;
579         if(b >= 760 ether) return 0;
580         if(b >= 740 ether) return 2;
581         if(b >= 720 ether) return 3;
582 
583 
584         if(b >= 700 ether) return 4;
585         if(b >= 680 ether) return 1;
586         if(b >= 660 ether) return 3;
587         if(b >= 640 ether) return 2;
588         if(b >= 620 ether) return 0;
589         if(b >= 600 ether) return 3;
590         if(b >= 580 ether) return 2;
591         if(b >= 560 ether) return 1;
592         if(b >= 540 ether) return 0;
593         if(b >= 520 ether) return 2;
594 
595         if(b >= 500 ether) return 4;
596         if(b >= 490 ether) return 1;
597         if(b >= 480 ether) return 3;
598         if(b >= 470 ether) return 0;
599         if(b >= 460 ether) return 3;
600         if(b >= 450 ether) return 1;
601         if(b >= 440 ether) return 2;
602         if(b >= 430 ether) return 1;
603         if(b >= 420 ether) return 0;
604         if(b >= 410 ether) return 2;
605 
606         if(b >= 400 ether) return 3;
607         if(b >= 390 ether) return 2;
608         if(b >= 380 ether) return 1;
609         if(b >= 370 ether) return 0;
610         if(b >= 360 ether) return 2;
611         if(b >= 350 ether) return 3;
612         if(b >= 340 ether) return 1;
613         if(b >= 330 ether) return 0;
614         if(b >= 320 ether) return 2;
615         if(b >= 310 ether) return 1;
616 
617 
618         if(b >= 300 ether) return 3;
619         if(b >= 290 ether) return 1;
620         if(b >= 280 ether) return 3;
621         if(b >= 270 ether) return 2;
622         if(b >= 260 ether) return 0;
623         if(b >= 250 ether) return 1;
624         if(b >= 240 ether) return 2;
625         if(b >= 230 ether) return 1;
626         if(b >= 220 ether) return 0;
627         if(b >= 210 ether) return 1;
628 
629 
630         if(b >= 200 ether) return 2;
631         if(b >= 190 ether) return 1;
632         if(b >= 180 ether) return 3;
633         if(b >= 170 ether) return 0;
634         if(b >= 160 ether) return 3;
635         if(b >= 150 ether) return 1;
636         if(b >= 140 ether) return 2;
637         if(b >= 130 ether) return 1;
638         if(b >= 120 ether) return 0;
639         if(b >= 110 ether) return 2;
640 
641         if(b >= 100 ether) return 3;
642         if(b >= 99 ether) return 2;
643         if(b >= 98 ether) return 1;
644         if(b >= 97 ether) return 0;
645         if(b >= 96 ether) return 2;
646         if(b >= 95 ether) return 3;
647         if(b >= 94 ether) return 1;
648         if(b >= 93 ether) return 0;
649         if(b >= 92 ether) return 2;
650         if(b >= 91 ether) return 3;
651 
652         if(b >= 90 ether) return 2;
653         if(b >= 89 ether) return 1;
654         if(b >= 88 ether) return 3;
655         if(b >= 87 ether) return 2;
656         if(b >= 86 ether) return 0;
657         if(b >= 85 ether) return 1;
658         if(b >= 84 ether) return 2;
659         if(b >= 83 ether) return 1;
660         if(b >= 82 ether) return 0;
661         if(b >= 81 ether) return 1;
662 
663         if(b >= 80 ether) return 3;
664         if(b >= 79 ether) return 1;
665         if(b >= 78 ether) return 3;
666         if(b >= 77 ether) return 2;
667         if(b >= 76 ether) return 0;
668         if(b >= 75 ether) return 1;
669         if(b >= 74 ether) return 2;
670         if(b >= 73 ether) return 1;
671         if(b >= 72 ether) return 0;
672         if(b >= 71 ether) return 1;
673 
674         if(b >= 70 ether) return 2;
675         if(b >= 69 ether) return 1;
676         if(b >= 68 ether) return 3;
677         if(b >= 67 ether) return 0;
678         if(b >= 66 ether) return 3;
679         if(b >= 65 ether) return 1;
680         if(b >= 64 ether) return 2;
681         if(b >= 63 ether) return 1;
682         if(b >= 62 ether) return 0;
683         if(b >= 61 ether) return 2;
684 
685         if(b >= 60 ether) return 3;
686         if(b >= 59 ether) return 1;
687         if(b >= 58 ether) return 3;
688         if(b >= 57 ether) return 2;
689         if(b >= 56 ether) return 0;
690         if(b >= 55 ether) return 1;
691         if(b >= 54 ether) return 2;
692         if(b >= 53 ether) return 1;
693         if(b >= 52 ether) return 0;
694         if(b >= 51 ether) return 2;
695 
696         if(b >= 50 ether) return 3;
697         if(b >= 49 ether) return 2;
698         if(b >= 48 ether) return 1;
699         if(b >= 47 ether) return 0;
700         if(b >= 46 ether) return 2;
701         if(b >= 45 ether) return 3;
702         if(b >= 44 ether) return 1;
703         if(b >= 43 ether) return 0;
704         if(b >= 42 ether) return 2;
705         if(b >= 41 ether) return 1;
706 
707         if(b >= 40 ether) return 3;
708         if(b >= 39 ether) return 1;
709         if(b >= 38 ether) return 3;
710         if(b >= 37 ether) return 2;
711         if(b >= 36 ether) return 0;
712         if(b >= 35 ether) return 1;
713         if(b >= 34 ether) return 2;
714         if(b >= 33 ether) return 1;
715         if(b >= 32 ether) return 0;
716         if(b >= 31 ether) return 1;
717 
718         if(b >= 30 ether) return 2;
719         if(b >= 29 ether) return 1;
720         if(b >= 28 ether) return 3;
721         if(b >= 27 ether) return 0;
722         if(b >= 26 ether) return 3;
723         if(b >= 25 ether) return 1;
724         if(b >= 24 ether) return 2;
725         if(b >= 23 ether) return 1;
726         if(b >= 22 ether) return 0;
727         if(b >= 21 ether) return 2;
728 
729         if(b >= 20 ether) return 3;
730         if(b >= 19 ether) return 2;
731         if(b >= 18 ether) return 1;
732         if(b >= 17 ether) return 0;
733         if(b >= 16 ether) return 2;
734         if(b >= 15 ether) return 3;
735         if(b >= 14 ether) return 1;
736         if(b >= 13 ether) return 0;
737         if(b >= 12 ether) return 2;
738         if(b >= 11 ether) return 1;
739 
740         if(b >= 10 ether) return 3;
741         if(b >= 9 ether) return 1;
742         if(b >= 8 ether) return 3;
743         if(b >= 7 ether) return 2;
744         if(b >= 6 ether) return 0;
745         if(b >= 5 ether) return 1;
746         if(b >= 4 ether) return 2;
747         if(b >= 3 ether) return 1;
748         if(b >= 2 ether) return 0;
749         if(b >= 1 ether) return 2;
750         return 1;
751 
752             }
753 
754     function payoutSize(address _to) view public returns(uint) {
755         uint max = investors[_to].invested.mul(MULTIPLICATION);
756         if(investors[_to].invested == 0 || investors[_to].payouts >= max) return 0;
757 
758         uint payout = investors[_to].invested.mul(bonusSize()).div(100).mul(block.timestamp.sub(investors[_to].last_payout)).div(1 days);
759         return investors[_to].payouts.add(payout) > max ? max.sub(investors[_to].payouts) : payout;
760 
761         
762 
763 
764     }
765 
766     function withdrawSize(address _to) view public returns(uint) {
767         uint max = investors[_to].invested.div(100).mul(WITHDRAW);
768         if(investors[_to].invested == 0 || investors[_to].payouts >= max) return 0;
769 
770         return max.sub(investors[_to].payouts);
771     }
772 
773     function bytesToAddress(bytes bys) pure private returns(address addr) {
774         assembly {
775             addr := mload(add(bys, 20))
776         }
777     }
778 
779     function() payable external {
780         if(investors[msg.sender].invested > 0) {
781             uint payout = payoutSize(msg.sender);
782 
783             require(msg.value > 0 || payout > 0, "No payouts");
784 
785             if(payout > 0) {
786                 investors[msg.sender].last_payout = block.timestamp;
787                 investors[msg.sender].payouts = investors[msg.sender].payouts.add(payout);
788 
789                 msg.sender.transfer(payout);
790 
791                 emit Payout(msg.sender, payout);
792             }
793 
794             if(investors[msg.sender].payouts >= investors[msg.sender].invested.mul(MULTIPLICATION)) {
795                 delete investors[msg.sender];
796 
797                 emit Withdraw(msg.sender, 0);
798                 
799                 
800             }
801         }
802 
803         if(msg.value == 0.00000051 ether) {
804             require(investors[msg.sender].invested > 0, "You have not invested anything yet");
805 
806             uint amount = withdrawSize(msg.sender);
807 
808             require(amount > 0, "You have nothing to withdraw");
809             
810             msg.sender.transfer(amount);
811             beneficiary.transfer(msg.value.mul(DEVFEE).div(1));
812 
813             delete investors[msg.sender];
814             
815             emit Withdraw(msg.sender, amount);
816 
817             
818             
819         }
820         else if(msg.value > 0) {
821             require(msg.value >= 0.05 ether, "Minimum investment amount 0.05 ether");
822 
823             investors[msg.sender].last_payout = block.timestamp;
824             investors[msg.sender].invested = investors[msg.sender].invested.add(msg.value);
825 
826             beneficiary.transfer(msg.value.mul(COMMISSION).div(100));
827             
828 
829             if(investors[msg.sender].first_invest == 0) {
830                 investors[msg.sender].first_invest = block.timestamp;
831 
832                 if(msg.data.length > 0) {
833                     address ref = bytesToAddress(msg.data);
834 
835                     if(ref != msg.sender && investors[ref].invested > 0 && msg.value >= 1 ether) {
836                         investors[msg.sender].referrer = ref;
837 
838                         uint ref_bonus = msg.value.mul(REFBONUS).div(100);
839                         ref.transfer(ref_bonus);
840 
841                         emit RefBonus(msg.sender, ref, ref_bonus);
842 
843                         uint cashback_bonus = msg.value.mul(CASHBACK).div(100);
844                         msg.sender.transfer(cashback_bonus);
845 
846                         emit CashBack(msg.sender, cashback_bonus);
847                     }
848                 }
849                 emit AddInvestor(msg.sender);
850             }
851 
852             emit Deposit(msg.sender, msg.value, investors[msg.sender].referrer);
853         }
854     }
855 }