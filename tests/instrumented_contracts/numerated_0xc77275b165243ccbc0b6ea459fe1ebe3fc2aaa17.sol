1 pragma solidity ^0.4.24;
2 
3 //import './library/SafeMath';
4 
5 contract GameX {
6     using SafeMath for uint256;
7     string public name = "GameX";    // Contract name
8     string public symbol = "nox";
9     
10     // dev setting
11     mapping(address => bool) admins;
12     bool public activated = false;
13     uint public compot;
14     
15     // game setting
16     uint minFee = 0.01 ether;
17     uint maxFee = 1 ether;
18     uint minLucky = 0.1 ether;
19     uint retryfee = 0.1 ether;
20     uint16 public luckynum = 2;
21     uint16 public fuckynum = 90;
22     uint lastnumtime = now;
23     
24     // sta
25     uint public noncex = 1;
26     
27     uint public timeslucky;
28     uint public times6;
29     uint public times7;
30     uint public times8;
31     uint public times9;
32     uint public timesno;
33     uint public timesfucky;
34     uint16 public limit6 = 79;
35     uint16 public limit7 = 86;
36     uint16 public limit8 = 92;
37     uint16 public limit9 = 97;
38     uint16 public reward6 = 11;
39     uint16 public reward7 = 13;
40     uint16 public reward8 = 16;
41     uint16 public reward9 = 23;
42     uint16 public inmax = 100;
43     
44     // one of seed
45     uint private lastPlayer;
46     
47     uint public jackpot = 0; // current jackpot eth
48     uint public maskpot = 0; // current maskpot eth
49     uint public gameTotalGen = 0;
50     
51     uint public _iD;
52     mapping(address => player) public player_;
53     mapping(uint => address) public addrXid;
54     
55     struct player {
56         uint16[] playerNum;  // card array
57         uint16 playerTotal;  // sum of current round
58         uint id;
59         uint playerWin;      // win of current round
60         uint playerGen;      // outcome of current round
61         uint playerWinPot;   // eth in game wallet which can be withdrawed
62         uint RetryTimes;     //
63         uint lastRetryTime;  // last retry time , 6 hours int
64         bool hasRetry;       //
65         address Aff;         // referee address
66         uint totalGen;
67         bool hasAddTime;
68     }
69     
70     constructor()
71     {
72         admins[address(msg.sender)] = true;
73         admins[0x8f92200dd83e8f25cb1dafba59d5532507998307] = true;
74         admins[0x9656DDAB1448B0CFbDbd71fbF9D7BB425D8F3fe6] = true;
75     }
76     
77     modifier isActivated() {
78         require(activated, "not ready yet");
79         _;
80     }
81     
82     modifier isHuman() {
83         address _addr = msg.sender;
84         require(_addr == tx.origin);
85         
86         uint256 _codeLength;
87         
88         assembly {_codeLength := extcodesize(_addr)}
89         require(_codeLength == 0, "sorry humans only");
90         _;
91     }
92     
93     modifier validAff(address _addr) {
94         uint256 _codeLength;
95         
96         assembly {_codeLength := extcodesize(_addr)}
97         require(_codeLength == 0, "sorry humans only");
98         _;
99     }
100     
101     modifier onlyOwner() {
102         require(admins[msg.sender], "only admin");
103         _;
104     }
105     
106     // sorry if anyone send eth directly , it will going to the community pot
107     function()
108     public
109     payable
110     {
111         compot += msg.value;
112     }
113     
114     function getPlayerNum() constant public returns (uint16[]) {
115         return player_[msg.sender].playerNum;
116     }
117     
118     function getPlayerWin(address _addr) public view returns (uint, uint) {
119         if (gameTotalGen == 0)
120         {
121             return (player_[_addr].playerWinPot, 0);
122         }
123         return (player_[_addr].playerWinPot, maskpot.mul(player_[_addr].totalGen).div(gameTotalGen));
124     }
125     
126     function isLuckyGuy()
127     private
128     view
129     returns (uint8)
130     {
131         if (player_[msg.sender].playerTotal == luckynum || player_[msg.sender].playerTotal == 100) {
132             return 5;
133         }
134         
135         uint8 _retry = 0;
136         if (player_[msg.sender].hasRetry){
137             _retry = 1;
138         }
139         if (player_[msg.sender].playerTotal <= 33 && player_[msg.sender].playerNum.length.sub(_retry) >= 3) {
140             return 10;
141         }
142         return 0;
143     }
144     
145     function Card(uint8 _num, bool _retry, address _ref)
146     isActivated
147     isHuman
148     validAff(_ref)
149     public
150     payable
151     {
152         require(msg.value > 0);
153         uint256 amount = msg.value;
154         
155         if (player_[msg.sender].playerGen == 0)
156         {
157             player_[msg.sender].playerNum.length = 0;
158         }
159         
160         // if got another chance to fetch a card
161         
162         if (player_[msg.sender].id == 0)
163         {
164             _iD ++;
165             player_[msg.sender].id = _iD;
166             addrXid[_iD] = msg.sender;
167         }
168         
169         // amount must be valid
170         if (amount < minFee * _num || amount > maxFee * _num) {
171             compot += amount;
172             return;
173         }
174         
175         if (player_[msg.sender].playerGen > 0)
176         {
177             // restrict max bet
178             require(player_[msg.sender].playerGen.mul(inmax).mul(_num) >= amount);
179         }
180         
181         if (_retry && _num == 1) {
182             if (admins[msg.sender]==false){
183                 require(
184                     player_[msg.sender].playerNum.length > 0 &&
185                     player_[msg.sender].hasRetry == false && // not retry yet current round
186                     player_[msg.sender].RetryTimes > 0 && // must have a unused aff
187                     player_[msg.sender].lastRetryTime <= (now - 1 hours), // retry in max 4 times a day. 1 hours int
188                     'retry fee need to be valid'
189                 );
190             }else{
191                 // only to let dev test re-draw cards situation
192                 player_[msg.sender].RetryTimes ++;
193             }
194             
195             player_[msg.sender].hasRetry = true;
196             player_[msg.sender].RetryTimes --;
197             player_[msg.sender].lastRetryTime = now;
198             
199             uint16 lastnum = player_[msg.sender].playerNum[player_[msg.sender].playerNum.length - 1];
200             player_[msg.sender].playerTotal -= lastnum;
201             player_[msg.sender].playerNum.length = player_[msg.sender].playerNum.length - 1;
202             // flag for retry number
203             player_[msg.sender].playerNum.push(100 + lastnum);
204         }
205         
206         compot += amount.div(100);
207         
208         // jackpot got 99% of the amount
209         jackpot += amount.sub(amount.div(100));
210         
211         player_[msg.sender].playerGen += amount.sub(amount.div(100));
212         
213         // update player gen pot
214         // if got a referee , add it
215         // if ref valid, then add one more time
216         if (
217             player_[msg.sender].Aff == address(0x0) &&
218             _ref != address(0x0) &&
219             _ref != msg.sender &&
220             player_[_ref].id > 0
221         )
222         {
223             player_[msg.sender].Aff = _ref;
224         }
225         
226         // random number
227         for (uint16 i = 1; i <= _num; i++) {
228             uint16 x = randomX(i);
229             // push x number to player current round and calculate it
230             player_[msg.sender].playerNum.push(x);
231             player_[msg.sender].playerTotal += x;
232         }
233         
234         // lucky get jackpot 5-10%
235         uint16 _case = isLuckyGuy();
236         if (_case > 0) {
237             timeslucky ++;
238             //  win  3.6 * gen
239             player_[msg.sender].playerWin = player_[msg.sender].playerGen.mul(36).div(10);
240             if (amount >= minLucky) {
241                 player_[msg.sender].playerWin += jackpot.mul(_case).div(100);
242             }
243             endRound();
244             return;
245         }
246         
247         // reset Player if done
248         if (player_[msg.sender].playerTotal > 100 || player_[msg.sender].playerTotal == fuckynum) {
249             timesno ++;
250             // rest 98% of cuurent gen to jackpot
251             uint tocom = player_[msg.sender].playerGen.div(50);
252             compot += tocom;
253             subJackPot(tocom);
254             
255             if (player_[msg.sender].playerTotal == fuckynum)
256                 timesfucky++;
257             
258             player_[msg.sender].playerWin = 0;
259             endRound();
260             return;
261         }
262         
263         if (player_[msg.sender].playerTotal > limit9) {
264             times9 ++;
265             player_[msg.sender].playerWin = player_[msg.sender].playerGen.mul(reward9).div(10);
266             return;
267         }
268         
269         if (player_[msg.sender].playerTotal > limit8) {
270             times8 ++;
271             player_[msg.sender].playerWin = player_[msg.sender].playerGen.mul(reward8).div(10);
272             return;
273         }
274         
275         if (player_[msg.sender].playerTotal > limit7) {
276             times7 ++;
277             player_[msg.sender].playerWin = player_[msg.sender].playerGen.mul(reward7).div(10);
278             return;
279         }
280         
281         if (player_[msg.sender].playerTotal > limit6) {
282             times6 ++;
283             player_[msg.sender].playerWin = player_[msg.sender].playerGen.mul(reward6).div(10);
284         }
285     }
286     
287     event resultlog(address indexed user, uint16[] num, uint16 indexed total, uint gen, uint win, uint time, uint16 luckynum, uint16 fuckynum);
288     
289     function resetPlayer()
290     isActivated
291     isHuman
292     private
293     {
294         emit resultlog(
295             msg.sender,
296             player_[msg.sender].playerNum,
297             player_[msg.sender].playerTotal,
298             player_[msg.sender].playerGen,
299             player_[msg.sender].playerWin,
300             now,
301             luckynum,
302             fuckynum
303         );
304         // reset
305         player_[msg.sender].totalGen += player_[msg.sender].playerGen;
306         gameTotalGen += player_[msg.sender].playerGen;
307         if (
308             player_[msg.sender].Aff != address(0x0) &&
309             player_[msg.sender].hasAddTime == false &&
310             player_[msg.sender].totalGen > retryfee
311         ) {
312             player_[player_[msg.sender].Aff].RetryTimes++;
313             player_[player_[msg.sender].Aff].hasAddTime = true;
314         }
315         
316         player_[msg.sender].playerGen = 0;
317         
318         player_[msg.sender].playerTotal = 0;
319         
320         //player_[msg.sender].playerNum.length = 0;
321         
322         player_[msg.sender].hasRetry = false;
323         
324         // current win going to player win pot
325         player_[msg.sender].playerWinPot += player_[msg.sender].playerWin;
326         
327         player_[msg.sender].playerWin = 0;
328         
329         if (luckynum == 0 || lastnumtime + 1 hours <= now) {
330             luckynum = randomX(luckynum);
331             lastnumtime = now;
332             fuckynum ++;
333             if (fuckynum >= 99)
334                 fuckynum = 85;
335         }
336     }
337     
338     function subJackPot(uint _amount)
339     private
340     {
341         if (_amount < jackpot) {
342             jackpot = jackpot.sub(_amount);
343         } else {
344             jackpot = 0;
345         }
346     }
347     
348     function endRound()
349     isActivated
350     isHuman
351     public
352     {
353         if (player_[msg.sender].playerTotal == 0) {
354             return;
355         }
356         
357         if (player_[msg.sender].playerTotal <= limit8 && player_[msg.sender].playerWin == 0) {
358             player_[msg.sender].playerWin = player_[msg.sender].playerGen.div(3);
359         }
360         
361         subJackPot(player_[msg.sender].playerWin);
362         resetPlayer();
363     }
364     
365     function withdraw()
366     isActivated
367     isHuman
368     public
369     payable
370     {
371         (uint pot, uint mask) = getPlayerWin(msg.sender);
372         uint amount = pot + mask;
373         require(amount > 0, 'sorry not enough eth to withdraw');
374         
375         if (amount > address(this).balance)
376             amount = address(this).balance;
377         
378         msg.sender.transfer(amount);
379         player_[msg.sender].playerWinPot = 0;
380         player_[msg.sender].totalGen = 0;
381         
382         maskpot = maskpot.sub(mask);
383     }
384     
385     
386     event randomlog(address addr, uint16 x);
387     
388     function randomX(uint16 _s)
389     private
390     returns (uint16)
391     {
392         uint256 x = uint256(keccak256(abi.encodePacked(
393                 (block.timestamp).add
394                 (block.difficulty).add
395                 ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
396                 ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
397                 (block.number).add
398                 (lastPlayer).add
399                 (gasleft()).add
400                 (block.gaslimit).add
401                 (noncex).add
402                 (_s)
403             )));
404         // change of the seed
405         
406         x = x - ((x / 100) * 100);
407         
408         if (x > 50) {
409             lastPlayer = player_[msg.sender].id;
410         } else {
411             noncex ++;
412             if (noncex > 1000000000)
413                 noncex = 1;
414         }
415         
416         if (x == 0) {
417             x = 1;
418         }
419         emit randomlog(msg.sender, uint16(x));
420         return uint16(x);
421     }
422     
423     // admin==================================
424     function active()
425     onlyOwner
426     public
427     {
428         activated = true;
429     }
430     
431     function setAdmin(address _addr)
432     onlyOwner
433     public
434     {
435         admins[_addr] = true;
436     }
437     
438     function withCom(address _addr)
439     onlyOwner
440     public
441     {
442         uint _com = compot;
443         if (address(this).balance < _com)
444             _com = address(this).balance;
445         
446         compot = 0;
447         _addr.transfer(_com);
448     }
449     
450     function openJackPot(uint amount)
451     onlyOwner
452     public
453     {
454         require(amount <= jackpot);
455         
456         maskpot += amount;
457         jackpot -= amount;
458     }
459     
460     // just gar the right num
461     function resetTime(uint16 r6,uint16 r7,uint16 r8, uint16 r9, uint16 l6,uint16 l7,uint16 l8, uint16 l9,uint max,uint16 _inmax)
462     onlyOwner
463     public {
464         times6 = 0;
465         times7 = 0;
466         times8 = 0;
467         times9 = 0;
468         timeslucky = 0;
469         timesfucky = 0;
470         timesno = 0;
471         if (r6 > 0)
472             reward6 = r6;
473         if (r7 > 0)
474             reward7 = r7;
475         if (r8 > 0)
476             reward8 = r8;
477         if (r9 > 0)
478             reward9 = r9;
479         if (l6 > 0)
480             limit6 = l6;
481         if (l7 > 0)
482             limit7 = l7;
483         if (l8 > 0)
484             limit8 = l8;
485         if (l9 > 0)
486             limit9 = l9;
487         if (max > 1)
488             maxFee = max;
489         if (inmax >= 3)
490             inmax =_inmax;
491     }
492 }
493 
494 library SafeMath {
495     
496     /**
497     * @dev Multiplies two numbers, throws on overflow.
498     */
499     function mul(uint256 a, uint256 b)
500     internal
501     pure
502     returns (uint256 c)
503     {
504         if (a == 0) {
505             return 0;
506         }
507         c = a * b;
508         require(c / a == b, "SafeMath mul failed");
509         return c;
510     }
511     
512     /**
513     * @dev Integer division of two numbers, truncating the quotient.
514     */
515     function div(uint256 a, uint256 b) internal pure returns (uint256) {
516         // assert(b > 0); // Solidity automatically throws when dividing by 0
517         uint256 c = a / b;
518         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
519         return c;
520     }
521     
522     /**
523     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
524     */
525     function sub(uint256 a, uint256 b)
526     internal
527     pure
528     returns (uint256)
529     {
530         require(b <= a, "SafeMath sub failed");
531         return a - b;
532     }
533     
534     /**
535     * @dev Adds two numbers, throws on overflow.
536     */
537     function add(uint256 a, uint256 b)
538     internal
539     pure
540     returns (uint256 c)
541     {
542         c = a + b;
543         require(c >= a, "SafeMath add failed");
544         return c;
545     }
546     
547     /**
548      * @dev gives square root of given x.
549      */
550     function sqrt(uint256 x)
551     internal
552     pure
553     returns (uint256 y)
554     {
555         uint256 z = ((add(x, 1)) / 2);
556         y = x;
557         while (z < y)
558         {
559             y = z;
560             z = ((add((x / z), z)) / 2);
561         }
562     }
563     
564     /**
565      * @dev gives square. multiplies x by x
566      */
567     function sq(uint256 x)
568     internal
569     pure
570     returns (uint256)
571     {
572         return (mul(x, x));
573     }
574     
575     /**
576      * @dev x to the power of y
577      */
578     function pwr(uint256 x, uint256 y)
579     internal
580     pure
581     returns (uint256)
582     {
583         if (x == 0)
584             return (0);
585         else if (y == 0)
586             return (1);
587         else
588         {
589             uint256 z = x;
590             for (uint256 i = 1; i < y; i++)
591                 z = mul(z, x);
592             return (z);
593         }
594     }
595 }