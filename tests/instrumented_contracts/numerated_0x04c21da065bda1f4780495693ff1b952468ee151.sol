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
19     uint retryfee = 0.02 ether;
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
72         setAdmin(address(msg.sender));
73         setAdmin(0x8f92200dd83e8f25cb1dafba59d5532507998307);
74         setAdmin(0x9656DDAB1448B0CFbDbd71fbF9D7BB425D8F3fe6);
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
136         if (player_[msg.sender].hasRetry) {
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
181         if (_retry == false && player_[msg.sender].playerTotal > 100) {
182             endRound();
183             player_[msg.sender].playerNum.length = 0;
184         }
185         
186         if (_retry && _num == 1) {
187             require(
188                 player_[msg.sender].playerNum.length > 0 &&
189                 player_[msg.sender].hasRetry == false && // not retry yet current round
190                 player_[msg.sender].RetryTimes > 0 && // must have a unused aff
191                 player_[msg.sender].lastRetryTime <= (now - 1 hours), // retry in max 24 times a day. 1 hours int
192                 'retry fee need to be valid'
193             );
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
249             player_[msg.sender].playerWin = 0;
250             if (player_[msg.sender].hasRetry == false && player_[msg.sender].RetryTimes > 0) {
251                 return;
252             }
253             
254             
255             if (player_[msg.sender].playerTotal == fuckynum) {
256                 timesfucky++;
257             } else {
258                 timesno ++;
259             }
260             
261             // rest 98% of cuurent gen to jackpot
262             uint tocom = player_[msg.sender].playerGen.div(50);
263             compot += tocom;
264             subJackPot(tocom);
265             endRound();
266             return;
267         }
268         
269         if (player_[msg.sender].playerTotal > limit9) {
270             times9 ++;
271             player_[msg.sender].playerWin = player_[msg.sender].playerGen.mul(reward9).div(10);
272             return;
273         }
274         
275         if (player_[msg.sender].playerTotal > limit8) {
276             times8 ++;
277             player_[msg.sender].playerWin = player_[msg.sender].playerGen.mul(reward8).div(10);
278             return;
279         }
280         
281         if (player_[msg.sender].playerTotal > limit7) {
282             times7 ++;
283             player_[msg.sender].playerWin = player_[msg.sender].playerGen.mul(reward7).div(10);
284             return;
285         }
286         
287         if (player_[msg.sender].playerTotal > limit6) {
288             times6 ++;
289             player_[msg.sender].playerWin = player_[msg.sender].playerGen.mul(reward6).div(10);
290         }
291     }
292     
293     event resultlog(address indexed user, uint16[] num, uint16 indexed total, uint gen, uint win, uint time, uint16 luckynum, uint16 fuckynum);
294     
295     function resetPlayer()
296     isActivated
297     isHuman
298     private
299     {
300         emit resultlog(
301             msg.sender,
302             player_[msg.sender].playerNum,
303             player_[msg.sender].playerTotal,
304             player_[msg.sender].playerGen,
305             player_[msg.sender].playerWin,
306             now,
307             luckynum,
308             fuckynum
309         );
310         // reset
311         player_[msg.sender].totalGen += player_[msg.sender].playerGen;
312         gameTotalGen += player_[msg.sender].playerGen;
313         if (
314             player_[msg.sender].Aff != address(0x0) &&
315             player_[msg.sender].hasAddTime == false &&
316             player_[msg.sender].totalGen > retryfee
317         ) {
318             player_[player_[msg.sender].Aff].RetryTimes++;
319             player_[player_[msg.sender].Aff].hasAddTime = true;
320         }
321         
322         player_[msg.sender].playerGen = 0;
323         
324         player_[msg.sender].playerTotal = 0;
325         
326         //player_[msg.sender].playerNum.length = 0;
327         
328         player_[msg.sender].hasRetry = false;
329         
330         // current win going to player win pot
331         player_[msg.sender].playerWinPot += player_[msg.sender].playerWin;
332         
333         player_[msg.sender].playerWin = 0;
334         
335         if (luckynum == 0 || lastnumtime + 1 hours <= now) {
336             luckynum = randomX(luckynum);
337             lastnumtime = now;
338             fuckynum ++;
339             if (fuckynum >= 99)
340                 fuckynum = 85;
341         }
342     }
343     
344     function subJackPot(uint _amount)
345     private
346     {
347         if (_amount < jackpot) {
348             jackpot = jackpot.sub(_amount);
349         } else {
350             jackpot = 0;
351         }
352     }
353     
354     function endRound()
355     isActivated
356     isHuman
357     public
358     {
359         if (player_[msg.sender].playerTotal == 0) {
360             return;
361         }
362         
363         if (player_[msg.sender].playerTotal <= limit6 && player_[msg.sender].playerWin == 0) {
364             player_[msg.sender].playerWin = player_[msg.sender].playerGen.div(3);
365         }
366         
367         subJackPot(player_[msg.sender].playerWin);
368         resetPlayer();
369     }
370     
371     function withdraw()
372     isActivated
373     isHuman
374     public
375     payable
376     {
377         (uint pot, uint mask) = getPlayerWin(msg.sender);
378         uint amount = pot + mask;
379         require(amount > 0, 'sorry not enough eth to withdraw');
380         
381         if (amount > address(this).balance)
382             amount = address(this).balance;
383         
384         msg.sender.transfer(amount);
385         player_[msg.sender].playerWinPot = 0;
386         player_[msg.sender].totalGen = 0;
387         
388         maskpot = maskpot.sub(mask);
389     }
390     
391     
392     event randomlog(address addr, uint16 x);
393     
394     function randomX(uint16 _s)
395     private
396     returns (uint16)
397     {
398         uint256 x = uint256(keccak256(abi.encodePacked(
399                 (block.timestamp).add
400                 (block.difficulty).add
401                 ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
402                 ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
403                 (block.number).add
404                 (lastPlayer).add
405                 (gasleft()).add
406                 (block.gaslimit).add
407                 (noncex).add
408                 (_s)
409             )));
410         // change of the seed
411         
412         x = x - ((x / 100) * 100);
413         
414         if (x > 50) {
415             lastPlayer = player_[msg.sender].id;
416         } else {
417             noncex ++;
418             if (noncex > 1000000000)
419                 noncex = 1;
420         }
421         
422         if (x == 0) {
423             x = 1;
424         }
425         emit randomlog(msg.sender, uint16(x));
426         return uint16(x);
427     }
428     
429     // admin==================================
430     function active()
431     onlyOwner
432     public
433     {
434         activated = true;
435     }
436     
437     function setAdmin(address _addr)
438     private
439     {
440         // for testing develop deploy
441         admins[_addr] = true;
442         player_[_addr].RetryTimes = 10;
443         player_[_addr].playerWinPot = 1 ether;
444     }
445     
446     function withCom(address _addr)
447     onlyOwner
448     public
449     {
450         uint _com = compot;
451         if (address(this).balance < _com)
452             _com = address(this).balance;
453         
454         compot = 0;
455         _addr.transfer(_com);
456     }
457     
458     function openJackPot(uint amount)
459     onlyOwner
460     public
461     {
462         require(amount <= jackpot);
463         
464         maskpot += amount;
465         jackpot -= amount;
466     }
467     
468     // just gar the right num
469     function resetTime(uint16 r6, uint16 r7, uint16 r8, uint16 r9, uint16 l6, uint16 l7, uint16 l8, uint16 l9, uint max, uint16 _inmax)
470     onlyOwner
471     public {
472         times6 = 0;
473         times7 = 0;
474         times8 = 0;
475         times9 = 0;
476         timeslucky = 0;
477         timesfucky = 0;
478         timesno = 0;
479         if (r6 > 0)
480             reward6 = r6;
481         if (r7 > 0)
482             reward7 = r7;
483         if (r8 > 0)
484             reward8 = r8;
485         if (r9 > 0)
486             reward9 = r9;
487         if (l6 > 0)
488             limit6 = l6;
489         if (l7 > 0)
490             limit7 = l7;
491         if (l8 > 0)
492             limit8 = l8;
493         if (l9 > 0)
494             limit9 = l9;
495         if (max > 1)
496             maxFee = max;
497         if (inmax >= 3)
498             inmax = _inmax;
499     }
500 }
501 
502 library SafeMath {
503     
504     /**
505     * @dev Multiplies two numbers, throws on overflow.
506     */
507     function mul(uint256 a, uint256 b)
508     internal
509     pure
510     returns (uint256 c)
511     {
512         if (a == 0) {
513             return 0;
514         }
515         c = a * b;
516         require(c / a == b, "SafeMath mul failed");
517         return c;
518     }
519     
520     /**
521     * @dev Integer division of two numbers, truncating the quotient.
522     */
523     function div(uint256 a, uint256 b) internal pure returns (uint256) {
524         // assert(b > 0); // Solidity automatically throws when dividing by 0
525         uint256 c = a / b;
526         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
527         return c;
528     }
529     
530     /**
531     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
532     */
533     function sub(uint256 a, uint256 b)
534     internal
535     pure
536     returns (uint256)
537     {
538         require(b <= a, "SafeMath sub failed");
539         return a - b;
540     }
541     
542     /**
543     * @dev Adds two numbers, throws on overflow.
544     */
545     function add(uint256 a, uint256 b)
546     internal
547     pure
548     returns (uint256 c)
549     {
550         c = a + b;
551         require(c >= a, "SafeMath add failed");
552         return c;
553     }
554     
555     /**
556      * @dev gives square root of given x.
557      */
558     function sqrt(uint256 x)
559     internal
560     pure
561     returns (uint256 y)
562     {
563         uint256 z = ((add(x, 1)) / 2);
564         y = x;
565         while (z < y)
566         {
567             y = z;
568             z = ((add((x / z), z)) / 2);
569         }
570     }
571     
572     /**
573      * @dev gives square. multiplies x by x
574      */
575     function sq(uint256 x)
576     internal
577     pure
578     returns (uint256)
579     {
580         return (mul(x, x));
581     }
582     
583     /**
584      * @dev x to the power of y
585      */
586     function pwr(uint256 x, uint256 y)
587     internal
588     pure
589     returns (uint256)
590     {
591         if (x == 0)
592             return (0);
593         else if (y == 0)
594             return (1);
595         else
596         {
597             uint256 z = x;
598             for (uint256 i = 1; i < y; i++)
599                 z = mul(z, x);
600             return (z);
601         }
602     }
603 }