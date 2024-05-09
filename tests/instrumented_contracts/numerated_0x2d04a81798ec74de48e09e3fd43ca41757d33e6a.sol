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
25 contract PullPayment {
26   using SafeMath for uint256;
27   mapping(address => uint256) public payments;
28   uint256 public totalPayments;
29   function withdrawPayments() public {
30     address payee = msg.sender;
31     uint256 payment = payments[payee];
32     require(payment != 0);
33     require(this.balance >= payment);
34     totalPayments = totalPayments.sub(payment);
35     payments[payee] = 0;
36     assert(payee.send(payment));
37   }
38   function asyncSend(address dest, uint256 amount) internal {
39     payments[dest] = payments[dest].add(amount);
40     totalPayments = totalPayments.add(amount);
41   }
42 }
43 
44 contract Ownable {
45   address public owner;
46   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47   function Ownable() public {
48     owner = msg.sender;
49   }
50   modifier onlyOwner() {
51     require(msg.sender == owner);
52     _;
53   }
54   function transferOwnership(address newOwner) public onlyOwner {
55     require(newOwner != address(0));
56     OwnershipTransferred(owner, newOwner);
57     owner = newOwner;
58   }
59 }
60 
61 contract Destructible is Ownable {
62   function Destructible() public payable { }
63   function destroy() onlyOwner public {
64     selfdestruct(owner);
65   }
66   function destroyAndSend(address _recipient) onlyOwner public {
67     selfdestruct(_recipient);
68   }
69 }
70 
71 contract ReentrancyGuard {
72   bool private reentrancy_lock = false;
73   modifier nonReentrant() {
74     require(!reentrancy_lock);
75     reentrancy_lock = true;
76     _;
77     reentrancy_lock = false;
78   }
79 }
80 
81 contract Map is PullPayment, Destructible, ReentrancyGuard {
82     using SafeMath for uint256;
83     
84     // STRUCTS
85 
86     struct Transaction {
87         string kingdomKey;
88         address compensationAddress;
89         uint buyingPrice;
90         uint compensation;
91         uint jackpotContribution;
92     }
93 
94     struct Kingdom {
95         string title;
96         string key;
97         uint kingdomTier;
98         uint kingdomType;
99         uint minimumPrice; 
100         uint lastTransaction;
101         uint transactionCount;
102         uint returnPrice;
103         address owner;
104         bool locked;
105     }
106 
107     struct Jackpot {
108         address winner;
109         uint balance;
110     }
111 
112     struct Round {
113         Jackpot globalJackpot;
114         Jackpot jackpot1;
115         Jackpot jackpot2;
116         Jackpot jackpot3;
117         Jackpot jackpot4;
118         Jackpot jackpot5;
119 
120         mapping(string => bool) kingdomsCreated;
121         mapping(address => uint) nbKingdoms;
122         mapping(address => uint) nbTransactions;
123         mapping(address => uint) nbKingdomsType1;
124         mapping(address => uint) nbKingdomsType2;
125         mapping(address => uint) nbKingdomsType3;
126         mapping(address => uint) nbKingdomsType4;
127         mapping(address => uint) nbKingdomsType5;
128 
129         uint startTime;
130         uint endTime;
131 
132         mapping(string => uint) kingdomsKeys;
133     }
134 
135     Kingdom[] public kingdoms;
136     Transaction[] public kingdomTransactions;
137     uint public currentRound;
138     address public bookerAddress;
139     
140     mapping(uint => Round) rounds;
141 
142     uint constant public ACTION_TAX = 0.02 ether;
143     uint constant public STARTING_CLAIM_PRICE_WEI = 0.05 ether;
144     uint constant MAXIMUM_CLAIM_PRICE_WEI = 800 ether;
145     uint constant KINGDOM_MULTIPLIER = 20;
146     uint constant TEAM_COMMISSION_RATIO = 10;
147     uint constant JACKPOT_COMMISSION_RATIO = 10;
148 
149     // MODIFIERS
150 
151     modifier onlyForRemainingKingdoms() {
152         uint remainingKingdoms = getRemainingKingdoms();
153         require(remainingKingdoms > kingdoms.length);
154         _;
155     }
156 
157     modifier checkKingdomExistence(string key) {
158         require(rounds[currentRound].kingdomsCreated[key] == true);
159         _;
160     }
161 
162     modifier checkIsNotLocked(string kingdomKey) {
163         require(kingdoms[rounds[currentRound].kingdomsKeys[kingdomKey]].locked != true);
164         _;
165     }
166 
167     modifier checkIsClosed() {
168         require(now >= rounds[currentRound].endTime);
169         _;
170     }
171 
172     modifier onlyKingdomOwner(string _key, address _sender) {
173         require (kingdoms[rounds[currentRound].kingdomsKeys[_key]].owner == _sender);
174         _;
175     }
176     
177     // EVENTS
178 
179     event LandCreatedEvent(string kingdomKey, address monarchAddress);
180     event LandPurchasedEvent(string kingdomKey, address monarchAddress);
181 
182     //
183     //  CONTRACT CONSTRUCTOR
184     //
185     function Map(address _bookerAddress, uint _startTime) {
186         bookerAddress = _bookerAddress;
187         currentRound = 1;
188         rounds[currentRound] = Round(Jackpot(address(0), 0), Jackpot(address(0), 0), Jackpot(address(0), 0), Jackpot(address(0), 0), Jackpot(address(0), 0), Jackpot(address(0), 0), 0, 0);
189         rounds[currentRound].jackpot1 = Jackpot(address(0), 0);
190         rounds[currentRound].jackpot2 = Jackpot(address(0), 0);
191         rounds[currentRound].jackpot3 = Jackpot(address(0), 0);
192         rounds[currentRound].jackpot4 = Jackpot(address(0), 0);
193         rounds[currentRound].jackpot5 = Jackpot(address(0), 0);
194         rounds[currentRound].startTime = _startTime;
195         rounds[currentRound].endTime = _startTime + 7 days;
196         rounds[currentRound].globalJackpot = Jackpot(address(0), 0);
197      }
198 
199     function () { }
200 
201     function getRemainingKingdoms() public view returns (uint nb) {
202         for (uint i = 1; i < 8; i++) {
203             if (now < rounds[currentRound].startTime + (i * 1 days)) {
204                 uint result = (10 * i);
205                 if (result > 70) { 
206                     return 70; 
207                 } else {
208                     return result;
209                 }
210             }
211         }
212     }
213 
214     function setTypedJackpotWinner(address _user, uint _type) internal {
215         if (_type == 1) {
216             if (rounds[currentRound].jackpot1.winner == address(0)) {
217                 rounds[currentRound].jackpot1.winner = _user;
218             } else if (rounds[currentRound].nbKingdomsType1[_user] >= rounds[currentRound].nbKingdomsType1[rounds[currentRound].jackpot1.winner]) {
219                 rounds[currentRound].jackpot1.winner = _user;
220             }
221         } else if (_type == 2) {
222             if (rounds[currentRound].jackpot2.winner == address(0)) {
223                 rounds[currentRound].jackpot2.winner = _user;
224             } else if (rounds[currentRound].nbKingdomsType2[_user] >= rounds[currentRound].nbKingdomsType2[rounds[currentRound].jackpot2.winner]) {
225                 rounds[currentRound].jackpot2.winner = _user;
226             }
227         } else if (_type == 3) {
228             if (rounds[currentRound].jackpot3.winner == address(0)) {
229                 rounds[currentRound].jackpot3.winner = _user;
230             } else if (rounds[currentRound].nbKingdomsType3[_user] >= rounds[currentRound].nbKingdomsType3[rounds[currentRound].jackpot3.winner]) {
231                 rounds[currentRound].jackpot3.winner = _user;
232             }
233         } else if (_type == 4) {
234             if (rounds[currentRound].jackpot4.winner == address(0)) {
235                 rounds[currentRound].jackpot4.winner = _user;
236             } else if (rounds[currentRound].nbKingdomsType4[_user] >= rounds[currentRound].nbKingdomsType4[rounds[currentRound].jackpot4.winner]) {
237                 rounds[currentRound].jackpot4.winner = _user;
238             }
239         } else if (_type == 5) {
240             if (rounds[currentRound].jackpot5.winner == address(0)) {
241                 rounds[currentRound].jackpot5.winner = _user;
242             } else if (rounds[currentRound].nbKingdomsType5[_user] >= rounds[currentRound].nbKingdomsType5[rounds[currentRound].jackpot5.winner]) {
243                 rounds[currentRound].jackpot5.winner = _user;
244             }
245         }
246     }
247 
248     //
249     //  This is the main function. It is called to buy a kingdom
250     //
251     function purchaseKingdom(string _key, string _title, bool _locked) public 
252     payable 
253     nonReentrant()
254     checkKingdomExistence(_key)
255     checkIsNotLocked(_key)
256     {
257         require(now < rounds[currentRound].endTime);
258         Round storage round = rounds[currentRound];
259         uint kingdomId = round.kingdomsKeys[_key];
260         Kingdom storage kingdom = kingdoms[kingdomId];
261         require((kingdom.kingdomTier + 1) < 6);
262         uint requiredPrice = kingdom.minimumPrice;
263         if (_locked == true) {
264             requiredPrice = requiredPrice.add(ACTION_TAX);
265         }
266 
267         require (msg.value >= requiredPrice);
268         uint jackpotCommission = (msg.value).sub(kingdom.returnPrice);
269 
270         if (kingdom.returnPrice > 0) {
271             round.nbKingdoms[kingdom.owner]--;
272             if (kingdom.kingdomType == 1) {
273                 round.nbKingdomsType1[kingdom.owner]--;
274             } else if (kingdom.kingdomType == 2) {
275                 round.nbKingdomsType2[kingdom.owner]--;
276             } else if (kingdom.kingdomType == 3) {
277                 round.nbKingdomsType3[kingdom.owner]--;
278             } else if (kingdom.kingdomType == 4) {
279                 round.nbKingdomsType4[kingdom.owner]--;
280             } else if (kingdom.kingdomType == 5) {
281                 round.nbKingdomsType5[kingdom.owner]--;
282             }
283             
284             compensateLatestMonarch(kingdom.lastTransaction, kingdom.returnPrice);
285         }
286         
287         uint jackpotSplitted = jackpotCommission.mul(50).div(100);
288         round.globalJackpot.balance = round.globalJackpot.balance.add(jackpotSplitted);
289 
290         kingdom.kingdomTier++;
291         kingdom.title = _title;
292 
293         if (kingdom.kingdomTier == 5) {
294             kingdom.returnPrice = 0;
295         } else {
296             kingdom.returnPrice = kingdom.minimumPrice.mul(2);
297             kingdom.minimumPrice = kingdom.minimumPrice.add(kingdom.minimumPrice.mul(2));
298         }
299 
300         kingdom.owner = msg.sender;
301         kingdom.locked = _locked;
302 
303         uint transactionId = kingdomTransactions.push(Transaction("", msg.sender, msg.value, 0, jackpotSplitted)) - 1;
304         kingdomTransactions[transactionId].kingdomKey = _key;
305         kingdom.transactionCount++;
306         kingdom.lastTransaction = transactionId;
307         
308         setNewJackpot(kingdom.kingdomType, jackpotSplitted, msg.sender);
309         LandPurchasedEvent(_key, msg.sender);
310     }
311 
312     function setNewJackpot(uint kingdomType, uint jackpotSplitted, address sender) internal {
313         rounds[currentRound].nbTransactions[sender]++;
314         rounds[currentRound].nbKingdoms[sender]++;
315         if (kingdomType == 1) {
316             rounds[currentRound].nbKingdomsType1[sender]++;
317             rounds[currentRound].jackpot1.balance = rounds[currentRound].jackpot1.balance.add(jackpotSplitted);
318         } else if (kingdomType == 2) {
319             rounds[currentRound].nbKingdomsType2[sender]++;
320             rounds[currentRound].jackpot2.balance = rounds[currentRound].jackpot2.balance.add(jackpotSplitted);
321         } else if (kingdomType == 3) {
322             rounds[currentRound].nbKingdomsType3[sender]++;
323             rounds[currentRound].jackpot3.balance = rounds[currentRound].jackpot3.balance.add(jackpotSplitted);
324         } else if (kingdomType == 4) {
325             rounds[currentRound].nbKingdomsType4[sender]++;
326             rounds[currentRound].jackpot4.balance = rounds[currentRound].jackpot4.balance.add(jackpotSplitted);
327         } else if (kingdomType == 5) {
328             rounds[currentRound].nbKingdomsType5[sender]++;
329             rounds[currentRound].jackpot5.balance = rounds[currentRound].jackpot5.balance.add(jackpotSplitted);
330         }
331         setNewWinner(msg.sender, kingdomType);
332     }
333 
334     function setLock(string _key, bool _locked) public payable checkKingdomExistence(_key) onlyKingdomOwner(_key, msg.sender) {
335         if (_locked == true) { require(msg.value >= ACTION_TAX); }
336         kingdoms[rounds[currentRound].kingdomsKeys[_key]].locked = _locked;
337         if (msg.value > 0) { asyncSend(bookerAddress, msg.value); }
338     }
339 
340     // function setNbKingdomsType(uint kingdomType, address sender, bool increment) internal {
341     //     if (kingdomType == 1) {
342     //         if (increment == true) {
343     //             rounds[currentRound].nbKingdomsType1[sender]++;
344     //         } else {
345     //             rounds[currentRound].nbKingdomsType1[sender]--;
346     //         }
347     //     } else if (kingdomType == 2) {
348     //         if (increment == true) {
349     //             rounds[currentRound].nbKingdomsType2[sender]++;
350     //         } else {
351     //             rounds[currentRound].nbKingdomsType2[sender]--;
352     //         }
353     //     } else if (kingdomType == 3) {
354     //         if (increment == true) {
355     //             rounds[currentRound].nbKingdomsType3[sender]++;
356     //         } else {
357     //             rounds[currentRound].nbKingdomsType3[sender]--;
358     //         }
359     //     } else if (kingdomType == 4) {
360     //         if (increment == true) {
361     //             rounds[currentRound].nbKingdomsType4[sender]++;
362     //         } else {
363     //             rounds[currentRound].nbKingdomsType4[sender]--;
364     //         }
365     //     } else if (kingdomType == 5) {
366     //         if (increment == true) {
367     //             rounds[currentRound].nbKingdomsType5[sender]++;
368     //         } else {
369     //             rounds[currentRound].nbKingdomsType5[sender]--;
370     //         }
371     //     }
372     // }
373 
374     // function upgradeKingdomType(string _key, uint _type) public payable checkKingdomExistence(_key) onlyKingdomOwner(_key, msg.sender) {
375     //     require(msg.value >= ACTION_TAX);
376     //     require(_type > 0);
377     //     require(_type < 6);
378     //     require(kingdoms[rounds[currentRound].kingdomsKeys[_key]].owner == msg.sender);
379     //     uint kingdomType = kingdoms[rounds[currentRound].kingdomsKeys[_key]].kingdomType;
380     //     setNbKingdomsType(kingdomType, msg.sender, false);
381 
382         
383     //     setNbKingdomsType(_type, msg.sender, true);
384     //     setTypedJackpotWinner(msg.sender, _type);
385 
386     //     kingdoms[rounds[currentRound].kingdomsKeys[_key]].kingdomType = _type;
387     //     asyncSend(bookerAddress, msg.value);
388     // }
389 
390     //
391     //  User can call this function to generate new kingdoms (within the limits of available land)
392     //
393     function createKingdom(address owner, string _key, string _title, uint _type, bool _locked) onlyForRemainingKingdoms() public payable {
394         require(now < rounds[currentRound].endTime);
395         require(_type > 0);
396         require(_type < 6);
397         uint basePrice = STARTING_CLAIM_PRICE_WEI;
398         uint requiredPrice = basePrice;
399         if (_locked == true) { requiredPrice = requiredPrice.add(ACTION_TAX); }
400         require(msg.value >= requiredPrice);
401         require(rounds[currentRound].kingdomsCreated[_key] == false);
402         uint refundPrice = STARTING_CLAIM_PRICE_WEI.mul(2);
403         uint nextMinimumPrice = STARTING_CLAIM_PRICE_WEI.add(refundPrice);
404         uint kingdomId = kingdoms.push(Kingdom("", "", 1, _type, 0, 0, 1, refundPrice, address(0), false)) - 1;
405         
406         kingdoms[kingdomId].title = _title;
407         kingdoms[kingdomId].owner = owner;
408         kingdoms[kingdomId].key = _key;
409         kingdoms[kingdomId].minimumPrice = nextMinimumPrice;
410         kingdoms[kingdomId].locked = _locked;
411 
412         rounds[currentRound].kingdomsKeys[_key] = kingdomId;
413         rounds[currentRound].kingdomsCreated[_key] = true;
414         
415         uint jackpotSplitted = requiredPrice.mul(50).div(100);
416         rounds[currentRound].globalJackpot.balance = rounds[currentRound].globalJackpot.balance.add(jackpotSplitted);
417 
418         uint transactionId = kingdomTransactions.push(Transaction("", msg.sender, msg.value, 0, jackpotSplitted)) - 1;
419         kingdomTransactions[transactionId].kingdomKey = _key;
420         kingdoms[kingdomId].lastTransaction = transactionId;
421        
422         setNewJackpot(_type, jackpotSplitted, msg.sender);
423         LandCreatedEvent(_key, msg.sender);
424     }
425 
426     //
427     //  Send transaction to compensate the previous owner
428     //
429     function compensateLatestMonarch(uint lastTransaction, uint compensationWei) internal {
430         address compensationAddress = kingdomTransactions[lastTransaction].compensationAddress;
431         kingdomTransactions[lastTransaction].compensation = compensationWei;
432         asyncSend(compensationAddress, compensationWei);
433     }
434 
435     //
436     //  This function may be useful to force withdraw if user never come back to get his money
437     //
438     function forceWithdrawPayments(address payee) public onlyOwner {
439         uint256 payment = payments[payee];
440         require(payment != 0);
441         require(this.balance >= payment);
442         totalPayments = totalPayments.sub(payment);
443         payments[payee] = 0;
444         assert(payee.send(payment));
445     }
446 
447     function getStartTime() public view returns (uint startTime) {
448         return rounds[currentRound].startTime;
449     }
450 
451     function getEndTime() public view returns (uint endTime) {
452         return rounds[currentRound].endTime;
453     }
454 
455     function payJackpot(uint _type) public checkIsClosed() {
456         Round storage finishedRound = rounds[currentRound];
457         if (_type == 1 && finishedRound.jackpot1.winner != address(0) && finishedRound.jackpot1.balance > 0) {
458             require(this.balance >= finishedRound.jackpot1.balance);
459             uint jackpot1TeamComission = (finishedRound.jackpot1.balance.mul(TEAM_COMMISSION_RATIO)).div(100);
460             asyncSend(bookerAddress, jackpot1TeamComission);
461             asyncSend(finishedRound.jackpot1.winner, finishedRound.jackpot1.balance.sub(jackpot1TeamComission));
462             finishedRound.jackpot1.balance = 0;
463         } else if (_type == 2 && finishedRound.jackpot2.winner != address(0) && finishedRound.jackpot2.balance > 0) {
464             require(this.balance >= finishedRound.jackpot2.balance);
465             uint jackpot2TeamComission = (finishedRound.jackpot2.balance.mul(TEAM_COMMISSION_RATIO)).div(100);
466             asyncSend(bookerAddress, jackpot2TeamComission);
467             asyncSend(finishedRound.jackpot2.winner, finishedRound.jackpot2.balance.sub(jackpot2TeamComission));
468             finishedRound.jackpot2.balance = 0;
469         } else if (_type == 3 && finishedRound.jackpot3.winner != address(0) && finishedRound.jackpot3.balance > 0) {
470             require(this.balance >= finishedRound.jackpot3.balance);
471             uint jackpot3TeamComission = (finishedRound.jackpot3.balance.mul(TEAM_COMMISSION_RATIO)).div(100);
472             asyncSend(bookerAddress, jackpot3TeamComission);
473             asyncSend(finishedRound.jackpot3.winner, finishedRound.jackpot3.balance.sub(jackpot3TeamComission));
474             finishedRound.jackpot3.balance = 0;
475         } else if (_type == 4 && finishedRound.jackpot4.winner != address(0) && finishedRound.jackpot4.balance > 0) {
476             require(this.balance >= finishedRound.jackpot4.balance);
477             uint jackpot4TeamComission = (finishedRound.jackpot4.balance.mul(TEAM_COMMISSION_RATIO)).div(100);
478             asyncSend(bookerAddress, jackpot4TeamComission);
479             asyncSend(finishedRound.jackpot4.winner, finishedRound.jackpot4.balance.sub(jackpot4TeamComission));
480             finishedRound.jackpot4.balance = 0;
481         } else if (_type == 5 && finishedRound.jackpot5.winner != address(0) && finishedRound.jackpot5.balance > 0) {
482             require(this.balance >= finishedRound.jackpot5.balance);
483             uint jackpot5TeamComission = (finishedRound.jackpot5.balance.mul(TEAM_COMMISSION_RATIO)).div(100);
484             asyncSend(bookerAddress, jackpot5TeamComission);
485             asyncSend(finishedRound.jackpot5.winner, finishedRound.jackpot5.balance.sub(jackpot5TeamComission));
486             finishedRound.jackpot5.balance = 0;
487         }
488 
489         if (finishedRound.globalJackpot.winner != address(0) && finishedRound.globalJackpot.balance > 0) {
490             require(this.balance >= finishedRound.globalJackpot.balance);
491             uint globalTeamComission = (finishedRound.globalJackpot.balance.mul(TEAM_COMMISSION_RATIO)).div(100);
492             asyncSend(bookerAddress, globalTeamComission);
493             asyncSend(finishedRound.globalJackpot.winner, finishedRound.globalJackpot.balance.sub(globalTeamComission));
494             finishedRound.globalJackpot.balance = 0;
495         }
496     }
497 
498     //
499     //  After time expiration, owner can call this function to activate the next round of the game
500     //
501     function activateNextRound() public checkIsClosed() {
502         Round storage finishedRound = rounds[currentRound];
503         require(finishedRound.globalJackpot.balance == 0);
504         require(finishedRound.jackpot5.balance == 0);
505         require(finishedRound.jackpot4.balance == 0);
506         require(finishedRound.jackpot3.balance == 0);
507         require(finishedRound.jackpot2.balance == 0);
508         require(finishedRound.jackpot1.balance == 0);
509         currentRound++;
510         rounds[currentRound] = Round(Jackpot(address(0), 0), Jackpot(address(0), 0), Jackpot(address(0), 0), Jackpot(address(0), 0), Jackpot(address(0), 0), Jackpot(address(0), 0), 0, 0);
511         rounds[currentRound].startTime = now;
512         rounds[currentRound].endTime = now + 7 days;
513         delete kingdoms;
514         delete kingdomTransactions;
515     }
516 
517     // GETTER AND SETTER FUNCTIONS
518 
519     function setNewWinner(address _sender, uint _type) internal {
520         if (rounds[currentRound].globalJackpot.winner == address(0)) {
521             rounds[currentRound].globalJackpot.winner = _sender;
522         } else {
523             if (rounds[currentRound].nbKingdoms[_sender] == rounds[currentRound].nbKingdoms[rounds[currentRound].globalJackpot.winner]) {
524                 if (rounds[currentRound].nbTransactions[_sender] > rounds[currentRound].nbTransactions[rounds[currentRound].globalJackpot.winner]) {
525                     rounds[currentRound].globalJackpot.winner = _sender;
526                 }
527             } else if (rounds[currentRound].nbKingdoms[_sender] > rounds[currentRound].nbKingdoms[rounds[currentRound].globalJackpot.winner]) {
528                 rounds[currentRound].globalJackpot.winner = _sender;
529             }
530         }
531         setTypedJackpotWinner(_sender, _type);
532     }
533 
534     function getJackpot(uint _nb) public view returns (address winner, uint balance, uint winnerCap) {
535         Round storage round = rounds[currentRound];
536         if (_nb == 1) {
537             return (round.jackpot1.winner, round.jackpot1.balance, round.nbKingdomsType1[round.jackpot1.winner]);
538         } else if (_nb == 2) {
539             return (round.jackpot2.winner, round.jackpot2.balance, round.nbKingdomsType2[round.jackpot2.winner]);
540         } else if (_nb == 3) {
541             return (round.jackpot3.winner, round.jackpot3.balance, round.nbKingdomsType3[round.jackpot3.winner]);
542         } else if (_nb == 4) {
543             return (round.jackpot4.winner, round.jackpot4.balance, round.nbKingdomsType4[round.jackpot4.winner]);
544         } else if (_nb == 5) {
545             return (round.jackpot5.winner, round.jackpot5.balance, round.nbKingdomsType5[round.jackpot5.winner]);
546         } else {
547             return (round.globalJackpot.winner, round.globalJackpot.balance, round.nbKingdoms[round.globalJackpot.winner]);
548         }
549     }
550 
551     function getKingdomCount() public view returns (uint kingdomCount) {
552         return kingdoms.length;
553     }
554 
555     function getKingdomInformations(string kingdomKey) public view returns (string title, uint minimumPrice, uint lastTransaction, uint transactionCount, address currentOwner, bool locked) {
556         uint kingdomId = rounds[currentRound].kingdomsKeys[kingdomKey];
557         Kingdom storage kingdom = kingdoms[kingdomId];
558         return (kingdom.title, kingdom.minimumPrice, kingdom.lastTransaction, kingdom.transactionCount, kingdom.owner, kingdom.locked);
559     }
560 
561 }