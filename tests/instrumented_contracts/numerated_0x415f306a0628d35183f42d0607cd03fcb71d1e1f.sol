1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) { return 0; }
6     uint256 c = a * b;
7     assert(c / a == b);
8     return c;
9   }
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a / b;
12     return c;
13   }
14   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
15     assert(b <= a);
16     return a - b;
17   }
18   function add(uint256 a, uint256 b) internal pure returns (uint256) {
19     uint256 c = a + b;
20     assert(c >= a);
21     return c;
22   }
23 }
24 
25 contract ERC20Basic {
26   function totalSupply() public view returns (uint256);
27   function balanceOf(address who) public view returns (uint256);
28   function transfer(address to, uint256 value) public returns (bool);
29   event Transfer(address indexed from, address indexed to, uint256 value);
30   function resetTimer(string _kingdomKey);
31 }
32 
33 contract PullPayment {
34   using SafeMath for uint256;
35   mapping(address => uint256) public payments;
36   uint256 public totalPayments;
37   function withdrawPayments() public {
38     address payee = msg.sender;
39     uint256 payment = payments[payee];
40     require(payment != 0);
41     require(this.balance >= payment);
42     totalPayments = totalPayments.sub(payment);
43     payments[payee] = 0;
44     assert(payee.send(payment));
45   }
46   function asyncSend(address dest, uint256 amount) internal {
47     payments[dest] = payments[dest].add(amount);
48     totalPayments = totalPayments.add(amount);
49   }
50 }
51 
52 contract Ownable {
53   address public owner;
54   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
55   function Ownable() public {
56     owner = msg.sender;
57   }
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62   function transferOwnership(address newOwner) public onlyOwner {
63     require(newOwner != address(0));
64     OwnershipTransferred(owner, newOwner);
65     owner = newOwner;
66   }
67 }
68 
69 contract Destructible is Ownable {
70   function Destructible() public payable { }
71   function destroy() onlyOwner public {
72     selfdestruct(owner);
73   }
74   function destroyAndSend(address _recipient) onlyOwner public {
75     selfdestruct(_recipient);
76   }
77 }
78 
79 contract ReentrancyGuard {
80   bool private reentrancy_lock = false;
81   modifier nonReentrant() {
82     require(!reentrancy_lock);
83     reentrancy_lock = true;
84     _;
85     reentrancy_lock = false;
86   }
87 }
88 
89 contract Map is PullPayment, Destructible, ReentrancyGuard {
90     using SafeMath for uint256;
91     
92     // STRUCTS
93 
94     struct Transaction {
95         string kingdomKey;
96         address compensationAddress;
97         uint buyingPrice;
98         uint compensation;
99         uint jackpotContribution;
100         uint date;
101     }
102 
103     struct Kingdom {
104         string title;
105         string key;
106         uint kingdomTier;
107         uint kingdomType;
108         uint minimumPrice; 
109         uint lastTransaction;
110         uint transactionCount;
111         uint returnPrice;
112         address owner;
113         bool locked;
114     }
115 
116     struct Jackpot {
117         address winner;
118         uint balance;
119     }
120 
121     // struct RoundPoints {
122     //     mapping(address => uint) points;
123     // }
124 
125     struct Round {
126         Jackpot jackpot1;
127         Jackpot jackpot2;
128         Jackpot jackpot3;
129         Jackpot jackpot4;
130         Jackpot jackpot5;
131 
132         mapping(string => bool) kingdomsCreated;
133         mapping(address => uint) nbKingdoms;
134         mapping(address => uint) nbTransactions;
135         mapping(address => uint) nbKingdomsType1;
136         mapping(address => uint) nbKingdomsType2;
137         mapping(address => uint) nbKingdomsType3;
138         mapping(address => uint) nbKingdomsType4;
139         mapping(address => uint) nbKingdomsType5;
140 
141         uint startTime;
142         uint endTime;
143 
144         mapping(string => uint) kingdomsKeys;
145         mapping(address => uint) scores;
146 
147     }
148 
149 
150     Kingdom[] public kingdoms;
151     Transaction[] public kingdomTransactions;
152     uint public currentRound;
153     address public bookerAddress;
154     
155     mapping(uint => Round) rounds;
156     mapping(address => uint) lastTransaction;
157 
158     uint constant public ACTION_TAX = 0.02 ether;
159     uint constant public STARTING_CLAIM_PRICE_WEI = 0.03 ether;
160     uint constant MAXIMUM_CLAIM_PRICE_WEI = 800 ether;
161     uint constant KINGDOM_MULTIPLIER = 20;
162     uint constant TEAM_COMMISSION_RATIO = 10;
163     uint constant JACKPOT_COMMISSION_RATIO = 10;
164 
165     // MODIFIERS
166 
167     modifier checkKingdomCap(address _owner, uint _kingdomType) {
168         if (_kingdomType == 1) {
169             require((rounds[currentRound].nbKingdomsType1[_owner] + 1) < 9);
170         } else if (_kingdomType == 2) {
171             require((rounds[currentRound].nbKingdomsType2[_owner] + 1) < 9);
172         } else if (_kingdomType == 3) {
173             require((rounds[currentRound].nbKingdomsType3[_owner] + 1) < 9);
174         } else if (_kingdomType == 4) {
175             require((rounds[currentRound].nbKingdomsType4[_owner] + 1) < 9);
176         } else if (_kingdomType == 5) {
177             require((rounds[currentRound].nbKingdomsType5[_owner] + 1) < 9);
178         }
179         _;
180     }
181 
182     modifier onlyForRemainingKingdoms() {
183         uint remainingKingdoms = getRemainingKingdoms();
184         require(remainingKingdoms > kingdoms.length);
185         _;
186     }
187 
188     modifier checkKingdomExistence(string key) {
189         require(rounds[currentRound].kingdomsCreated[key] == true);
190         _;
191     }
192 
193     modifier checkIsNotLocked(string kingdomKey) {
194         require(kingdoms[rounds[currentRound].kingdomsKeys[kingdomKey]].locked != true);
195         _;
196     }
197 
198     modifier checkIsClosed() {
199         require(now >= rounds[currentRound].endTime);
200         _;
201     }
202 
203     modifier onlyKingdomOwner(string _key, address _sender) {
204         require (kingdoms[rounds[currentRound].kingdomsKeys[_key]].owner == _sender);
205         _;
206     }
207     
208     // ERC20 
209     address public woodAddress;
210     ERC20Basic woodInterface;
211     // ERC20Basic rock;
212     // ERC20Basic 
213 
214     // EVENTS
215 
216     event LandCreatedEvent(string kingdomKey, address monarchAddress);
217     event LandPurchasedEvent(string kingdomKey, address monarchAddress);
218 
219     //
220     //  CONTRACT CONSTRUCTOR
221     //
222     function Map(address _bookerAddress, address _woodAddress, uint _startTime, uint _endTime) {
223         bookerAddress = _bookerAddress;
224         woodAddress = _woodAddress;
225         woodInterface = ERC20Basic(_woodAddress);
226         currentRound = 1;
227         rounds[currentRound] = Round(Jackpot(address(0), 0), Jackpot(address(0), 0), Jackpot(address(0), 0), Jackpot(address(0), 0), Jackpot(address(0), 0), 0, 0);
228         rounds[currentRound].jackpot1 = Jackpot(address(0), 0);
229         rounds[currentRound].jackpot2 = Jackpot(address(0), 0);
230         rounds[currentRound].jackpot3 = Jackpot(address(0), 0);
231         rounds[currentRound].jackpot4 = Jackpot(address(0), 0);
232         rounds[currentRound].jackpot5 = Jackpot(address(0), 0);
233         rounds[currentRound].startTime = _startTime;
234         rounds[currentRound].endTime = _endTime;
235      }
236 
237     function () { }
238 
239     function setWoodAddress (address _woodAddress) public onlyOwner  {
240         woodAddress = _woodAddress;
241         woodInterface = ERC20Basic(_woodAddress);
242     }
243 
244     function getRemainingKingdoms() public view returns (uint nb) {
245         for (uint i = 1; i < 8; i++) {
246             if (now < rounds[currentRound].startTime + (i * 12 hours)) {
247                 uint result = (10 * i);
248                 if (result > 100) { 
249                     return 100; 
250                 } else {
251                     return result;
252                 }
253             }
254         }
255     }
256 
257     //
258     //  This is the main function. It is called to buy a kingdom
259     //
260     function purchaseKingdom(string _key, string _title, bool _locked) public 
261     payable 
262     nonReentrant()
263     checkKingdomExistence(_key)
264     checkIsNotLocked(_key)
265     {
266         require(now < rounds[currentRound].endTime);
267         Round storage round = rounds[currentRound];
268         uint kingdomId = round.kingdomsKeys[_key];
269         Kingdom storage kingdom = kingdoms[kingdomId];
270         require((kingdom.kingdomTier + 1) < 6);
271         uint requiredPrice = kingdom.minimumPrice;
272         if (_locked == true) {
273             requiredPrice = requiredPrice.add(ACTION_TAX);
274         }
275 
276         require (msg.value >= requiredPrice);
277         uint jackpotCommission = (msg.value).sub(kingdom.returnPrice);
278 
279         if (kingdom.returnPrice > 0) {
280             round.nbKingdoms[kingdom.owner]--;
281             if (kingdom.kingdomType == 1) {
282                 round.nbKingdomsType1[kingdom.owner]--;
283             } else if (kingdom.kingdomType == 2) {
284                 round.nbKingdomsType2[kingdom.owner]--;
285             } else if (kingdom.kingdomType == 3) {
286                 round.nbKingdomsType3[kingdom.owner]--;
287             } else if (kingdom.kingdomType == 4) {
288                 round.nbKingdomsType4[kingdom.owner]--;
289             } else if (kingdom.kingdomType == 5) {
290                 round.nbKingdomsType5[kingdom.owner]--;
291             }
292             compensateLatestMonarch(kingdom.lastTransaction, kingdom.returnPrice);
293         }
294         
295         
296         // woodInterface.resetTimer(_key);
297 
298         kingdom.kingdomTier++;
299         kingdom.title = _title;
300 
301         if (kingdom.kingdomTier == 5) {
302             kingdom.returnPrice = 0;
303             kingdom.minimumPrice = 5 ether;
304         } else if (kingdom.kingdomTier == 2) {
305             kingdom.returnPrice = 0.1125 ether;
306             kingdom.minimumPrice = 0.27 ether;
307         } else if (kingdom.kingdomTier == 3) {
308             kingdom.returnPrice = 0.3375 ether;
309             kingdom.minimumPrice = 0.81 ether;
310         } else if (kingdom.kingdomTier == 4) {
311             kingdom.returnPrice = 1.0125 ether;
312             kingdom.minimumPrice = 2.43 ether;
313         }
314         
315         kingdom.owner = msg.sender;
316         kingdom.locked = _locked;
317 
318         uint transactionId = kingdomTransactions.push(Transaction("", msg.sender, msg.value, 0, jackpotCommission, now)) - 1;
319         kingdomTransactions[transactionId].kingdomKey = _key;
320         kingdom.transactionCount++;
321         kingdom.lastTransaction = transactionId;
322         lastTransaction[msg.sender] = now;
323 
324         setNewJackpot(kingdom.kingdomType, jackpotCommission, msg.sender);
325         LandPurchasedEvent(_key, msg.sender);
326     }
327 
328     function setNewJackpot(uint kingdomType, uint jackpotSplitted, address sender) internal {
329         rounds[currentRound].nbTransactions[sender]++;
330         rounds[currentRound].nbKingdoms[sender]++;
331         if (kingdomType == 1) {
332             rounds[currentRound].nbKingdomsType1[sender]++;
333             rounds[currentRound].jackpot1.balance = rounds[currentRound].jackpot1.balance.add(jackpotSplitted);
334         } else if (kingdomType == 2) {
335             rounds[currentRound].nbKingdomsType2[sender]++;
336             rounds[currentRound].jackpot2.balance = rounds[currentRound].jackpot2.balance.add(jackpotSplitted);
337         } else if (kingdomType == 3) {
338             rounds[currentRound].nbKingdomsType3[sender]++;
339             rounds[currentRound].jackpot3.balance = rounds[currentRound].jackpot3.balance.add(jackpotSplitted);
340         } else if (kingdomType == 4) {
341             rounds[currentRound].nbKingdomsType4[sender]++;
342             rounds[currentRound].jackpot4.balance = rounds[currentRound].jackpot4.balance.add(jackpotSplitted);
343         } else if (kingdomType == 5) {
344             rounds[currentRound].nbKingdomsType5[sender]++;
345             rounds[currentRound].jackpot5.balance = rounds[currentRound].jackpot5.balance.add(jackpotSplitted);
346         }
347     }
348 
349     function setLock(string _key, bool _locked) public payable checkKingdomExistence(_key) onlyKingdomOwner(_key, msg.sender) {
350         if (_locked == true) { require(msg.value >= ACTION_TAX); }
351         kingdoms[rounds[currentRound].kingdomsKeys[_key]].locked = _locked;
352         if (msg.value > 0) { asyncSend(bookerAddress, msg.value); }
353     }
354 
355     function giveKingdom(address owner, string _key, string _title, uint _type) onlyOwner() public {
356         require(_type > 0);
357         require(_type < 6);
358         require(rounds[currentRound].kingdomsCreated[_key] == false);
359         uint kingdomId = kingdoms.push(Kingdom("", "", 1, _type, 0, 0, 1, 0.02 ether, address(0), false)) - 1;
360         kingdoms[kingdomId].title = _title;
361         kingdoms[kingdomId].owner = owner;
362         kingdoms[kingdomId].key = _key;
363         kingdoms[kingdomId].minimumPrice = 0.03 ether;
364         kingdoms[kingdomId].locked = false;
365         rounds[currentRound].kingdomsKeys[_key] = kingdomId;
366         rounds[currentRound].kingdomsCreated[_key] = true;
367         uint transactionId = kingdomTransactions.push(Transaction("", msg.sender, 0.01 ether, 0, 0, now)) - 1;
368         kingdomTransactions[transactionId].kingdomKey = _key;
369         kingdoms[kingdomId].lastTransaction = transactionId;
370     }
371 
372     //
373     //  User can call this function to generate new kingdoms (within the limits of available land)
374     //
375     function createKingdom(string _key, string _title, uint _type, bool _locked) checkKingdomCap(msg.sender, _type) onlyForRemainingKingdoms() public payable {
376         require(now < rounds[currentRound].endTime);
377         require(_type > 0);
378         require(_type < 6);
379         uint basePrice = STARTING_CLAIM_PRICE_WEI;
380         uint requiredPrice = basePrice;
381         if (_locked == true) { requiredPrice = requiredPrice.add(ACTION_TAX); }
382         require(msg.value >= requiredPrice);
383         Round storage round = rounds[currentRound];
384         require(round.kingdomsCreated[_key] == false);
385 
386         uint refundPrice = 0.0375 ether; // (STARTING_CLAIM_PRICE_WEI.mul(125)).div(100);
387         uint nextMinimumPrice = 0.09 ether; // STARTING_CLAIM_PRICE_WEI.add(STARTING_CLAIM_PRICE_WEI.mul(2));
388 
389         uint kingdomId = kingdoms.push(Kingdom("", "", 1, 0, 0, 0, 1, refundPrice, address(0), false)) - 1;
390         
391         kingdoms[kingdomId].kingdomType = _type;
392         kingdoms[kingdomId].title = _title;
393         kingdoms[kingdomId].owner = msg.sender;
394         kingdoms[kingdomId].key = _key;
395         kingdoms[kingdomId].minimumPrice = nextMinimumPrice;
396         kingdoms[kingdomId].locked = _locked;
397 
398         round.kingdomsKeys[_key] = kingdomId;
399         round.kingdomsCreated[_key] = true;
400         
401         if(_locked == true) {
402             asyncSend(bookerAddress, ACTION_TAX);
403         }
404 
405         uint transactionId = kingdomTransactions.push(Transaction("", msg.sender, msg.value, 0, basePrice, now)) - 1;
406         kingdomTransactions[transactionId].kingdomKey = _key;
407         kingdoms[kingdomId].lastTransaction = transactionId;
408         lastTransaction[msg.sender] = now;
409 
410         setNewJackpot(_type, basePrice, msg.sender);
411         LandCreatedEvent(_key, msg.sender);
412     }
413 
414     //
415     //  Send transaction to compensate the previous owner
416     //
417     function compensateLatestMonarch(uint lastTransaction, uint compensationWei) internal {
418         address compensationAddress = kingdomTransactions[lastTransaction].compensationAddress;
419         kingdomTransactions[lastTransaction].compensation = compensationWei;
420         asyncSend(compensationAddress, compensationWei);
421     }
422 
423     //
424     //  This function may be useful to force withdraw if user never come back to get his money
425     //
426     function forceWithdrawPayments(address payee) public onlyOwner {
427         uint256 payment = payments[payee];
428         require(payment != 0);
429         require(this.balance >= payment);
430         totalPayments = totalPayments.sub(payment);
431         payments[payee] = 0;
432         assert(payee.send(payment));
433     }
434 
435     function getStartTime() public view returns (uint startTime) {
436         return rounds[currentRound].startTime;
437     }
438 
439     function getEndTime() public view returns (uint endTime) {
440         return rounds[currentRound].endTime;
441     }
442 
443     function payJackpot1() internal checkIsClosed() {
444         address winner = getWinner(1);
445         if (rounds[currentRound].jackpot1.balance > 0 && winner != address(0)) {
446             require(this.balance >= rounds[currentRound].jackpot1.balance);
447             rounds[currentRound].jackpot1.winner = winner;
448             uint teamComission = (rounds[currentRound].jackpot1.balance.mul(TEAM_COMMISSION_RATIO)).div(100);
449             bookerAddress.transfer(teamComission);
450             uint jackpot = rounds[currentRound].jackpot1.balance.sub(teamComission);
451             asyncSend(winner, jackpot);
452             rounds[currentRound].jackpot1.balance = 0;
453         }
454     }
455 
456     function payJackpot2() internal checkIsClosed() {
457         address winner = getWinner(2);
458         if (rounds[currentRound].jackpot2.balance > 0 && winner != address(0)) {
459             require(this.balance >= rounds[currentRound].jackpot2.balance);
460             rounds[currentRound].jackpot2.winner = winner;
461             uint teamComission = (rounds[currentRound].jackpot2.balance.mul(TEAM_COMMISSION_RATIO)).div(100);
462             bookerAddress.transfer(teamComission);
463             uint jackpot = rounds[currentRound].jackpot2.balance.sub(teamComission);
464             asyncSend(winner, jackpot);
465             rounds[currentRound].jackpot2.balance = 0;
466         }
467     }
468 
469     function payJackpot3() internal checkIsClosed() {
470         address winner = getWinner(3);
471         if (rounds[currentRound].jackpot3.balance > 0 && winner != address(0)) {
472             require(this.balance >= rounds[currentRound].jackpot3.balance);
473             rounds[currentRound].jackpot3.winner = winner;
474             uint teamComission = (rounds[currentRound].jackpot3.balance.mul(TEAM_COMMISSION_RATIO)).div(100);
475             bookerAddress.transfer(teamComission);
476             uint jackpot = rounds[currentRound].jackpot3.balance.sub(teamComission);
477             asyncSend(winner, jackpot);
478             rounds[currentRound].jackpot3.balance = 0;
479         }
480     }
481 
482     function payJackpot4() internal checkIsClosed() {
483         address winner = getWinner(4);
484         if (rounds[currentRound].jackpot4.balance > 0 && winner != address(0)) {
485             require(this.balance >= rounds[currentRound].jackpot4.balance);
486             rounds[currentRound].jackpot4.winner = winner;
487             uint teamComission = (rounds[currentRound].jackpot4.balance.mul(TEAM_COMMISSION_RATIO)).div(100);
488             bookerAddress.transfer(teamComission);
489             uint jackpot = rounds[currentRound].jackpot4.balance.sub(teamComission);
490             asyncSend(winner, jackpot);
491             rounds[currentRound].jackpot4.balance = 0;
492         }
493     }
494 
495     function payJackpot5() internal checkIsClosed() {
496         address winner = getWinner(5);
497         if (rounds[currentRound].jackpot5.balance > 0 && winner != address(0)) {
498             require(this.balance >= rounds[currentRound].jackpot5.balance);
499             rounds[currentRound].jackpot5.winner = winner;
500             uint teamComission = (rounds[currentRound].jackpot5.balance.mul(TEAM_COMMISSION_RATIO)).div(100);
501             bookerAddress.transfer(teamComission);
502             uint jackpot = rounds[currentRound].jackpot5.balance.sub(teamComission);
503             asyncSend(winner, jackpot);
504             rounds[currentRound].jackpot5.balance = 0;
505         }
506     }
507 
508     //
509     //  After time expiration, owner can call this function to activate the next round of the game
510     //
511     function activateNextRound(uint _startTime) public checkIsClosed() {
512         payJackpot1();
513         payJackpot2();
514         payJackpot3();
515         payJackpot4();
516         payJackpot5();
517 
518         currentRound++;
519         rounds[currentRound] = Round(Jackpot(address(0), 0), Jackpot(address(0), 0), Jackpot(address(0), 0), Jackpot(address(0), 0), Jackpot(address(0), 0), 0, 0);
520         rounds[currentRound].startTime = _startTime;
521         rounds[currentRound].endTime = _startTime + 7 days;
522         delete kingdoms;
523         delete kingdomTransactions;
524     }
525 
526     // GETTER AND SETTER FUNCTIONS
527 
528     function getKingdomCount() public view returns (uint kingdomCount) {
529         return kingdoms.length;
530     }
531 
532     function getJackpot(uint _nb) public view returns (address winner, uint balance) {
533         if (_nb == 1) {
534             return (getWinner(1), rounds[currentRound].jackpot1.balance);
535         } else if (_nb == 2) {
536             return (getWinner(2), rounds[currentRound].jackpot2.balance);
537         } else if (_nb == 3) {
538             return (getWinner(3), rounds[currentRound].jackpot3.balance);
539         } else if (_nb == 4) {
540             return (getWinner(4), rounds[currentRound].jackpot4.balance);
541         } else if (_nb == 5) {
542             return (getWinner(5), rounds[currentRound].jackpot5.balance);
543         }
544     }
545 
546     function getKingdomType(string _kingdomKey) public view returns (uint kingdomType) {
547         return kingdoms[rounds[currentRound].kingdomsKeys[_kingdomKey]].kingdomType;
548     }
549 
550     function getKingdomOwner(string _kingdomKey) public view returns (address owner) {
551         return kingdoms[rounds[currentRound].kingdomsKeys[_kingdomKey]].owner;
552     }
553 
554     function getKingdomInformations(string _kingdomKey) public view returns (string title, uint minimumPrice, uint lastTransaction, uint transactionCount, address currentOwner, uint kingdomType, bool locked) {
555         uint kingdomId = rounds[currentRound].kingdomsKeys[_kingdomKey];
556         Kingdom storage kingdom = kingdoms[kingdomId];
557         return (kingdom.title, kingdom.minimumPrice, kingdom.lastTransaction, kingdom.transactionCount, kingdom.owner, kingdom.kingdomType, kingdom.locked);
558     }
559  
560     // function upgradeTier(string _key) public {
561     //     // require(now < rounds[currentRound].endTime);
562     //     Round storage round = rounds[currentRound];
563     //     uint kingdomId = round.kingdomsKeys[_key];
564     //     Kingdom storage kingdom = kingdoms[kingdomId];
565     //     uint wood = woodInterface.balanceOf(kingdom.owner);
566     //     require(wood >= 1);
567     //     kingdom.kingdomTier++;
568     // }
569 
570     function getWinner(uint _type) public returns (address winner) {
571         require(_type > 0);
572         require(_type < 6);
573 
574         address addr;
575         uint maxPoints = 0;
576         Round storage round = rounds[currentRound];
577 
578         for (uint index = 0; index < kingdoms.length; index++) {
579             if (_type == kingdoms[index].kingdomType) {
580                 address userAddress = kingdoms[index].owner;
581                 if(kingdoms[index].kingdomTier == 1) {
582                     round.scores[msg.sender] = round.scores[msg.sender] + 1;
583                 } else if(kingdoms[index].kingdomTier == 2) {
584                     round.scores[msg.sender] = round.scores[msg.sender] + 3;
585                 } else if (kingdoms[index].kingdomTier == 3) {
586                     round.scores[msg.sender] = round.scores[msg.sender] + 5;
587                 } else if (kingdoms[index].kingdomTier == 4) {
588                     round.scores[msg.sender] = round.scores[msg.sender] + 8;
589                 } else if (kingdoms[index].kingdomTier == 5) {
590                     round.scores[msg.sender] = round.scores[msg.sender] + 13;
591                 }
592                 
593                 if(round.scores[msg.sender] == maxPoints) {
594                     if(lastTransaction[userAddress] < lastTransaction[winner]) {
595                         addr = userAddress;
596                     }
597                 } else if (round.scores[msg.sender] > maxPoints) {
598                     maxPoints = round.scores[msg.sender];
599                     addr = userAddress;
600                 }
601             }
602         }
603         return addr;
604     }
605 }