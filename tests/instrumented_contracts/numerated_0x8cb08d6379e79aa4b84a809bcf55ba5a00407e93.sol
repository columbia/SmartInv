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
162     uint constant TEAM_COMMISSION_RATIO = 20;
163 
164     // MODIFIERS
165 
166     modifier checkKingdomCap(address _owner, uint _kingdomType) {
167         if (_kingdomType == 1) {
168             require((rounds[currentRound].nbKingdomsType1[_owner] + 1) < 9);
169         } else if (_kingdomType == 2) {
170             require((rounds[currentRound].nbKingdomsType2[_owner] + 1) < 9);
171         } else if (_kingdomType == 3) {
172             require((rounds[currentRound].nbKingdomsType3[_owner] + 1) < 9);
173         } else if (_kingdomType == 4) {
174             require((rounds[currentRound].nbKingdomsType4[_owner] + 1) < 9);
175         } else if (_kingdomType == 5) {
176             require((rounds[currentRound].nbKingdomsType5[_owner] + 1) < 9);
177         }
178         _;
179     }
180 
181     modifier checkKingdomCreated(string _key) {
182         require(rounds[currentRound].kingdomsCreated[_key] == false);
183         _;
184     }
185 
186     modifier onlyForRemainingKingdoms() {
187         uint remainingKingdoms = getRemainingKingdoms();
188         require(remainingKingdoms > kingdoms.length);
189         _;
190     }
191 
192     modifier checkKingdomExistence(string key) {
193         require(rounds[currentRound].kingdomsCreated[key] == true);
194         _;
195     }
196 
197     modifier checkIsNotLocked(string kingdomKey) {
198         require(kingdoms[rounds[currentRound].kingdomsKeys[kingdomKey]].locked != true);
199         _;
200     }
201 
202     modifier checkIsClosed() {
203         require(now >= rounds[currentRound].endTime);
204         _;
205     }
206 
207     modifier onlyKingdomOwner(string _key, address _sender) {
208         require (kingdoms[rounds[currentRound].kingdomsKeys[_key]].owner == _sender);
209         _;
210     }
211     
212     // ERC20 
213     address public woodAddress;
214     ERC20Basic woodInterface;
215     // ERC20Basic rock;
216     // ERC20Basic 
217 
218     // EVENTS
219 
220     event LandCreatedEvent(string kingdomKey, address monarchAddress);
221     event LandPurchasedEvent(string kingdomKey, address monarchAddress);
222 
223     //
224     //  CONTRACT CONSTRUCTOR
225     //
226     function Map(address _bookerAddress, address _woodAddress, uint _startTime, uint _endTime) {
227         bookerAddress = _bookerAddress;
228         woodAddress = _woodAddress;
229         woodInterface = ERC20Basic(_woodAddress);
230         currentRound = 1;
231         rounds[currentRound] = Round(Jackpot(address(0), 0), Jackpot(address(0), 0), Jackpot(address(0), 0), Jackpot(address(0), 0), Jackpot(address(0), 0), 0, 0);
232         rounds[currentRound].jackpot1 = Jackpot(address(0), 0);
233         rounds[currentRound].jackpot2 = Jackpot(address(0), 0);
234         rounds[currentRound].jackpot3 = Jackpot(address(0), 0);
235         rounds[currentRound].jackpot4 = Jackpot(address(0), 0);
236         rounds[currentRound].jackpot5 = Jackpot(address(0), 0);
237         rounds[currentRound].startTime = _startTime;
238         rounds[currentRound].endTime = _endTime;
239      }
240 
241     function () { }
242 
243     function setWoodAddress (address _woodAddress) public onlyOwner  {
244         woodAddress = _woodAddress;
245         woodInterface = ERC20Basic(_woodAddress);
246     }
247 
248     function getRemainingKingdoms() public view returns (uint nb) {
249         for (uint i = 1; i < 10; i++) {
250             if (now < rounds[currentRound].startTime + (i * 12 hours)) {
251                 uint result = (10 * i);
252                 if (result > 100) { 
253                     return 100; 
254                 } else {
255                     return result;
256                 }
257             }
258         }
259     }
260 
261     //
262     //  This is the main function. It is called to buy a kingdom
263     //
264     function purchaseKingdom(string _key, string _title, bool _locked, address affiliate) public 
265     payable 
266     nonReentrant()
267     checkKingdomExistence(_key)
268     checkIsNotLocked(_key)
269     {
270         require(now < rounds[currentRound].endTime);
271         Round storage round = rounds[currentRound];
272         uint kingdomId = round.kingdomsKeys[_key];
273         Kingdom storage kingdom = kingdoms[kingdomId];
274         require((kingdom.kingdomTier + 1) < 6);
275         uint requiredPrice = kingdom.minimumPrice;
276         if (_locked == true) {
277             requiredPrice = requiredPrice.add(ACTION_TAX);
278         }
279 
280         require (msg.value >= requiredPrice);
281         uint jackpotCommission = (msg.value).sub(kingdom.returnPrice);
282 
283         if(affiliate != address(0)) {
284             uint affiliateValue = jackpotCommission.mul(10).div(100);
285             asyncSend(affiliate, affiliateValue);
286             jackpotCommission = jackpotCommission.sub(affiliateValue);
287         }
288 
289         if (kingdom.returnPrice > 0) {
290             round.nbKingdoms[kingdom.owner]--;
291             if (kingdom.kingdomType == 1) {
292                 round.nbKingdomsType1[kingdom.owner]--;
293             } else if (kingdom.kingdomType == 2) {
294                 round.nbKingdomsType2[kingdom.owner]--;
295             } else if (kingdom.kingdomType == 3) {
296                 round.nbKingdomsType3[kingdom.owner]--;
297             } else if (kingdom.kingdomType == 4) {
298                 round.nbKingdomsType4[kingdom.owner]--;
299             } else if (kingdom.kingdomType == 5) {
300                 round.nbKingdomsType5[kingdom.owner]--;
301             }
302             compensateLatestMonarch(kingdom.lastTransaction, kingdom.returnPrice);
303         }
304         
305         // woodInterface.resetTimer(_key);
306 
307         kingdom.kingdomTier++;
308         kingdom.title = _title;
309 
310         if (kingdom.kingdomTier == 5) {
311             kingdom.returnPrice = 0;
312             kingdom.minimumPrice = 5 ether;
313         } else if (kingdom.kingdomTier == 2) {
314             kingdom.returnPrice = 0.1125 ether;
315             kingdom.minimumPrice = 0.27 ether;
316         } else if (kingdom.kingdomTier == 3) {
317             kingdom.returnPrice = 0.3375 ether;
318             kingdom.minimumPrice = 0.81 ether;
319         } else if (kingdom.kingdomTier == 4) {
320             kingdom.returnPrice = 1.0125 ether;
321             kingdom.minimumPrice = 2.43 ether;
322         }
323         
324         kingdom.owner = msg.sender;
325         kingdom.locked = _locked;
326 
327         uint transactionId = kingdomTransactions.push(Transaction("", msg.sender, msg.value, 0, jackpotCommission, now)) - 1;
328         kingdomTransactions[transactionId].kingdomKey = _key;
329         kingdom.transactionCount++;
330         kingdom.lastTransaction = transactionId;
331         lastTransaction[msg.sender] = now;
332 
333         setNewJackpot(kingdom.kingdomType, jackpotCommission, msg.sender);
334         LandPurchasedEvent(_key, msg.sender);
335     }
336 
337     function setNewJackpot(uint kingdomType, uint jackpotSplitted, address sender) internal {
338         rounds[currentRound].nbTransactions[sender]++;
339         rounds[currentRound].nbKingdoms[sender]++;
340         if (kingdomType == 1) {
341             rounds[currentRound].nbKingdomsType1[sender]++;
342             rounds[currentRound].jackpot1.balance = rounds[currentRound].jackpot1.balance.add(jackpotSplitted);
343         } else if (kingdomType == 2) {
344             rounds[currentRound].nbKingdomsType2[sender]++;
345             rounds[currentRound].jackpot2.balance = rounds[currentRound].jackpot2.balance.add(jackpotSplitted);
346         } else if (kingdomType == 3) {
347             rounds[currentRound].nbKingdomsType3[sender]++;
348             rounds[currentRound].jackpot3.balance = rounds[currentRound].jackpot3.balance.add(jackpotSplitted);
349         } else if (kingdomType == 4) {
350             rounds[currentRound].nbKingdomsType4[sender]++;
351             rounds[currentRound].jackpot4.balance = rounds[currentRound].jackpot4.balance.add(jackpotSplitted);
352         } else if (kingdomType == 5) {
353             rounds[currentRound].nbKingdomsType5[sender]++;
354             rounds[currentRound].jackpot5.balance = rounds[currentRound].jackpot5.balance.add(jackpotSplitted);
355         }
356     }
357 
358     function setLock(string _key, bool _locked) public payable checkKingdomExistence(_key) onlyKingdomOwner(_key, msg.sender) {
359         if (_locked == true) { require(msg.value >= ACTION_TAX); }
360         kingdoms[rounds[currentRound].kingdomsKeys[_key]].locked = _locked;
361         if (msg.value > 0) { asyncSend(bookerAddress, msg.value); }
362     }
363 
364     function giveKingdom(address owner, string _key, string _title, uint _type) onlyOwner() public {
365         require(_type > 0);
366         require(_type < 6);
367         require(rounds[currentRound].kingdomsCreated[_key] == false);
368         uint kingdomId = kingdoms.push(Kingdom("", "", 1, _type, 0, 0, 1, 0.02 ether, address(0), false)) - 1;
369         kingdoms[kingdomId].title = _title;
370         kingdoms[kingdomId].owner = owner;
371         kingdoms[kingdomId].key = _key;
372         kingdoms[kingdomId].minimumPrice = 0.03 ether;
373         kingdoms[kingdomId].locked = false;
374         rounds[currentRound].kingdomsKeys[_key] = kingdomId;
375         rounds[currentRound].kingdomsCreated[_key] = true;
376         uint transactionId = kingdomTransactions.push(Transaction("", msg.sender, 0.01 ether, 0, 0, now)) - 1;
377         kingdomTransactions[transactionId].kingdomKey = _key;
378         kingdoms[kingdomId].lastTransaction = transactionId;
379     }
380 
381     function sendAffiliateValue(uint basePrice, address affiliate) internal returns (uint jackpotValue) {
382         uint result = basePrice;
383         if(affiliate != address(0)) {
384             asyncSend(affiliate, 0.003 ether);
385             result = basePrice - (0.003 ether);
386         }
387         return result;
388     }
389 
390     //
391     //  User can call this function to generate new kingdoms (within the limits of available land)
392     //
393     function createKingdom(string _key, string _title, uint _type, address affiliate, bool _locked) checkKingdomCap(msg.sender, _type) onlyForRemainingKingdoms() public payable {
394         require(now < rounds[currentRound].endTime);
395         require(_type > 0);
396         require(_type < 6);
397         uint basePrice = STARTING_CLAIM_PRICE_WEI;
398         uint requiredPrice = basePrice;
399         if (_locked == true) { requiredPrice = requiredPrice.add(ACTION_TAX); }
400         require(msg.value >= requiredPrice);
401 
402         uint refundPrice = 0.0375 ether; // (STARTING_CLAIM_PRICE_WEI.mul(125)).div(100);
403         uint nextMinimumPrice = 0.09 ether; // STARTING_CLAIM_PRICE_WEI.add(STARTING_CLAIM_PRICE_WEI.mul(2));
404 
405         uint kingdomId = kingdoms.push(Kingdom("", "", 1, 0, 0, 0, 1, refundPrice, address(0), false)) - 1;
406         
407         kingdoms[kingdomId].kingdomType = _type;
408         kingdoms[kingdomId].title = _title;
409         kingdoms[kingdomId].owner = msg.sender;
410         kingdoms[kingdomId].key = _key;
411         kingdoms[kingdomId].minimumPrice = nextMinimumPrice;
412         kingdoms[kingdomId].locked = _locked;
413 
414         rounds[currentRound].kingdomsKeys[_key] = kingdomId;
415         rounds[currentRound].kingdomsCreated[_key] = true;
416         
417         if(_locked == true) {
418             asyncSend(bookerAddress, ACTION_TAX);
419         }
420 
421         uint transactionId = createTransaction(_type, msg.sender, msg.value, basePrice, affiliate);
422         kingdomTransactions[transactionId].kingdomKey = _key;
423         kingdoms[kingdomId].lastTransaction = transactionId;
424         LandCreatedEvent(_key, msg.sender);
425     }
426 
427     function createTransaction(uint _type, address _sender, uint _value, uint _basePrice, address _affiliate) internal returns (uint id) {
428         uint jackpotValue = sendAffiliateValue(_basePrice, _affiliate);
429         uint transactionId = kingdomTransactions.push(Transaction("", _sender, _value, 0, jackpotValue, now)) - 1;
430         lastTransaction[_sender] = now;
431         setNewJackpot(_type, jackpotValue, msg.sender);
432         return transactionId;
433     }
434 
435     //
436     //  Send transaction to compensate the previous owner
437     //
438     function compensateLatestMonarch(uint lastTransaction, uint compensationWei) internal {
439         address compensationAddress = kingdomTransactions[lastTransaction].compensationAddress;
440         kingdomTransactions[lastTransaction].compensation = compensationWei;
441         asyncSend(compensationAddress, compensationWei);
442     }
443 
444     //
445     //  This function may be useful to force withdraw if user never come back to get his money
446     //
447     function forceWithdrawPayments(address payee) public onlyOwner {
448         uint256 payment = payments[payee];
449         require(payment != 0);
450         require(this.balance >= payment);
451         totalPayments = totalPayments.sub(payment);
452         payments[payee] = 0;
453         assert(payee.send(payment));
454     }
455 
456     function getStartTime() public view returns (uint startTime) {
457         return rounds[currentRound].startTime;
458     }
459 
460     function getEndTime() public view returns (uint endTime) {
461         return rounds[currentRound].endTime;
462     }
463 
464     function payJackpot1() internal checkIsClosed() {
465         address winner = getWinner(1);
466         if (rounds[currentRound].jackpot1.balance > 0 && winner != address(0)) {
467             require(this.balance >= rounds[currentRound].jackpot1.balance);
468             rounds[currentRound].jackpot1.winner = winner;
469             uint teamComission = (rounds[currentRound].jackpot1.balance.mul(TEAM_COMMISSION_RATIO)).div(100);
470             bookerAddress.transfer(teamComission);
471             uint jackpot = rounds[currentRound].jackpot1.balance.sub(teamComission);
472             asyncSend(winner, jackpot);
473             rounds[currentRound].jackpot1.balance = 0;
474         }
475     }
476 
477     function payJackpot2() internal checkIsClosed() {
478         address winner = getWinner(2);
479         if (rounds[currentRound].jackpot2.balance > 0 && winner != address(0)) {
480             require(this.balance >= rounds[currentRound].jackpot2.balance);
481             rounds[currentRound].jackpot2.winner = winner;
482             uint teamComission = (rounds[currentRound].jackpot2.balance.mul(TEAM_COMMISSION_RATIO)).div(100);
483             bookerAddress.transfer(teamComission);
484             uint jackpot = rounds[currentRound].jackpot2.balance.sub(teamComission);
485             asyncSend(winner, jackpot);
486             rounds[currentRound].jackpot2.balance = 0;
487         }
488     }
489 
490     function payJackpot3() internal checkIsClosed() {
491         address winner = getWinner(3);
492         if (rounds[currentRound].jackpot3.balance > 0 && winner != address(0)) {
493             require(this.balance >= rounds[currentRound].jackpot3.balance);
494             rounds[currentRound].jackpot3.winner = winner;
495             uint teamComission = (rounds[currentRound].jackpot3.balance.mul(TEAM_COMMISSION_RATIO)).div(100);
496             bookerAddress.transfer(teamComission);
497             uint jackpot = rounds[currentRound].jackpot3.balance.sub(teamComission);
498             asyncSend(winner, jackpot);
499             rounds[currentRound].jackpot3.balance = 0;
500         }
501     }
502 
503     function payJackpot4() internal checkIsClosed() {
504         address winner = getWinner(4);
505         if (rounds[currentRound].jackpot4.balance > 0 && winner != address(0)) {
506             require(this.balance >= rounds[currentRound].jackpot4.balance);
507             rounds[currentRound].jackpot4.winner = winner;
508             uint teamComission = (rounds[currentRound].jackpot4.balance.mul(TEAM_COMMISSION_RATIO)).div(100);
509             bookerAddress.transfer(teamComission);
510             uint jackpot = rounds[currentRound].jackpot4.balance.sub(teamComission);
511             asyncSend(winner, jackpot);
512             rounds[currentRound].jackpot4.balance = 0;
513         }
514     }
515 
516     function payJackpot5() internal checkIsClosed() {
517         address winner = getWinner(5);
518         if (rounds[currentRound].jackpot5.balance > 0 && winner != address(0)) {
519             require(this.balance >= rounds[currentRound].jackpot5.balance);
520             rounds[currentRound].jackpot5.winner = winner;
521             uint teamComission = (rounds[currentRound].jackpot5.balance.mul(TEAM_COMMISSION_RATIO)).div(100);
522             bookerAddress.transfer(teamComission);
523             uint jackpot = rounds[currentRound].jackpot5.balance.sub(teamComission);
524             asyncSend(winner, jackpot);
525             rounds[currentRound].jackpot5.balance = 0;
526         }
527     }
528 
529     //
530     //  After time expiration, owner can call this function to activate the next round of the game
531     //
532     function activateNextRound(uint _startTime) public checkIsClosed() {
533         payJackpot1();
534         payJackpot2();
535         payJackpot3();
536         payJackpot4();
537         payJackpot5();
538 
539         currentRound++;
540         rounds[currentRound] = Round(Jackpot(address(0), 0), Jackpot(address(0), 0), Jackpot(address(0), 0), Jackpot(address(0), 0), Jackpot(address(0), 0), 0, 0);
541         rounds[currentRound].startTime = _startTime;
542         rounds[currentRound].endTime = _startTime + 7 days;
543         delete kingdoms;
544         delete kingdomTransactions;
545     }
546 
547     // GETTER AND SETTER FUNCTIONS
548 
549     function getKingdomCount() public view returns (uint kingdomCount) {
550         return kingdoms.length;
551     }
552 
553     function getJackpot(uint _nb) public view returns (address winner, uint balance) {
554         if (_nb == 1) {
555             return (getWinner(1), rounds[currentRound].jackpot1.balance);
556         } else if (_nb == 2) {
557             return (getWinner(2), rounds[currentRound].jackpot2.balance);
558         } else if (_nb == 3) {
559             return (getWinner(3), rounds[currentRound].jackpot3.balance);
560         } else if (_nb == 4) {
561             return (getWinner(4), rounds[currentRound].jackpot4.balance);
562         } else if (_nb == 5) {
563             return (getWinner(5), rounds[currentRound].jackpot5.balance);
564         }
565     }
566 
567     function getKingdomType(string _kingdomKey) public view returns (uint kingdomType) {
568         return kingdoms[rounds[currentRound].kingdomsKeys[_kingdomKey]].kingdomType;
569     }
570 
571     function getKingdomOwner(string _kingdomKey) public view returns (address owner) {
572         return kingdoms[rounds[currentRound].kingdomsKeys[_kingdomKey]].owner;
573     }
574 
575     function getKingdomInformations(string _kingdomKey) public view returns (string title, uint minimumPrice, uint lastTransaction, uint transactionCount, address currentOwner, uint kingdomType, bool locked) {
576         uint kingdomId = rounds[currentRound].kingdomsKeys[_kingdomKey];
577         Kingdom storage kingdom = kingdoms[kingdomId];
578         return (kingdom.title, kingdom.minimumPrice, kingdom.lastTransaction, kingdom.transactionCount, kingdom.owner, kingdom.kingdomType, kingdom.locked);
579     }
580  
581     // function upgradeTier(string _key) public {
582     //     // require(now < rounds[currentRound].endTime);
583     //     Round storage round = rounds[currentRound];
584     //     uint kingdomId = round.kingdomsKeys[_key];
585     //     Kingdom storage kingdom = kingdoms[kingdomId];
586     //     uint wood = woodInterface.balanceOf(kingdom.owner);
587     //     require(wood >= 1);
588     //     kingdom.kingdomTier++;
589     // }
590 
591     function getWinner(uint _type) public returns (address winner) {
592         require(_type > 0);
593         require(_type < 6);
594 
595         address addr;
596         uint maxPoints = 0;
597         Round storage round = rounds[currentRound];
598 
599         for (uint index = 0; index < kingdoms.length; index++) {
600             if (_type == kingdoms[index].kingdomType) {
601                 address userAddress = kingdoms[index].owner;
602                 if(kingdoms[index].kingdomTier == 1) {
603                     round.scores[msg.sender] = round.scores[msg.sender] + 1;
604                 } else if(kingdoms[index].kingdomTier == 2) {
605                     round.scores[msg.sender] = round.scores[msg.sender] + 3;
606                 } else if (kingdoms[index].kingdomTier == 3) {
607                     round.scores[msg.sender] = round.scores[msg.sender] + 5;
608                 } else if (kingdoms[index].kingdomTier == 4) {
609                     round.scores[msg.sender] = round.scores[msg.sender] + 8;
610                 } else if (kingdoms[index].kingdomTier == 5) {
611                     round.scores[msg.sender] = round.scores[msg.sender] + 13;
612                 }
613                 
614                 if(round.scores[msg.sender] != 0 && round.scores[msg.sender] == maxPoints) {
615                     if(lastTransaction[userAddress] < lastTransaction[addr]) {
616                         addr = userAddress;
617                     }
618                 } else if (round.scores[msg.sender] > maxPoints) {
619                     maxPoints = round.scores[msg.sender];
620                     addr = userAddress;
621                 }
622             }
623         }
624         return addr;
625     }
626 }