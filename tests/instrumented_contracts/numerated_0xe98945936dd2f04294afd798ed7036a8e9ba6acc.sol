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
143     uint constant public STARTING_CLAIM_PRICE_WEI = 0.01 ether;
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
185     function Map(address _bookerAddress) {
186         bookerAddress = _bookerAddress;
187         currentRound = 1;
188         rounds[currentRound] = Round(Jackpot(address(0), 0), Jackpot(address(0), 0), Jackpot(address(0), 0), Jackpot(address(0), 0), Jackpot(address(0), 0), Jackpot(address(0), 0), 0, 0);
189         rounds[currentRound].jackpot1 = Jackpot(address(0), 0);
190         rounds[currentRound].jackpot2 = Jackpot(address(0), 0);
191         rounds[currentRound].jackpot3 = Jackpot(address(0), 0);
192         rounds[currentRound].jackpot4 = Jackpot(address(0), 0);
193         rounds[currentRound].jackpot5 = Jackpot(address(0), 0);
194         rounds[currentRound].startTime = 1523916000;
195         rounds[currentRound].endTime = rounds[currentRound].startTime + 7 days;
196         rounds[currentRound].globalJackpot = Jackpot(address(0), 0);
197      }
198 
199     function () { }
200 
201     function getRemainingKingdoms() public view returns (uint nb) {
202         for (uint i = 1; i < 8; i++) {
203             if (now < rounds[currentRound].startTime + (i * 24 hours)) {
204                 uint result = (25 * i);
205                 if (result > 125) { 
206                     return 125; 
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
340     function giveKingdom(address owner, string _key, string _title, uint _type) onlyOwner() public {
341         require(_type > 0);
342         require(_type < 6);
343         require(rounds[currentRound].kingdomsCreated[_key] == false);
344         uint kingdomId = kingdoms.push(Kingdom("", "", 1, _type, 0, 0, 1, 0.02 ether, address(0), false)) - 1;
345         kingdoms[kingdomId].title = _title;
346         kingdoms[kingdomId].owner = owner;
347         kingdoms[kingdomId].key = _key;
348         kingdoms[kingdomId].minimumPrice = 0.03 ether;
349         kingdoms[kingdomId].locked = false;
350         rounds[currentRound].kingdomsKeys[_key] = kingdomId;
351         rounds[currentRound].kingdomsCreated[_key] = true;
352         uint transactionId = kingdomTransactions.push(Transaction("", msg.sender, 0.01 ether, 0, 0)) - 1;
353         kingdomTransactions[transactionId].kingdomKey = _key;
354         kingdoms[kingdomId].lastTransaction = transactionId;
355     }
356 
357     //
358     //  User can call this function to generate new kingdoms (within the limits of available land)
359     //
360     function createKingdom(address owner, string _key, string _title, uint _type, bool _locked) onlyForRemainingKingdoms() public payable {
361         require(now < rounds[currentRound].endTime);
362         require(_type > 0);
363         require(_type < 6);
364         uint basePrice = STARTING_CLAIM_PRICE_WEI;
365         uint requiredPrice = basePrice;
366         if (_locked == true) { requiredPrice = requiredPrice.add(ACTION_TAX); }
367         require(msg.value >= requiredPrice);
368         require(rounds[currentRound].kingdomsCreated[_key] == false);
369         uint refundPrice = STARTING_CLAIM_PRICE_WEI.mul(2);
370         uint nextMinimumPrice = STARTING_CLAIM_PRICE_WEI.add(refundPrice);
371         uint kingdomId = kingdoms.push(Kingdom("", "", 1, _type, 0, 0, 1, refundPrice, address(0), false)) - 1;
372         
373         kingdoms[kingdomId].title = _title;
374         kingdoms[kingdomId].owner = owner;
375         kingdoms[kingdomId].key = _key;
376         kingdoms[kingdomId].minimumPrice = nextMinimumPrice;
377         kingdoms[kingdomId].locked = _locked;
378 
379         rounds[currentRound].kingdomsKeys[_key] = kingdomId;
380         rounds[currentRound].kingdomsCreated[_key] = true;
381         
382         asyncSend(bookerAddress, ACTION_TAX);
383 
384         uint jackpotSplitted = basePrice.mul(50).div(100);
385         rounds[currentRound].globalJackpot.balance = rounds[currentRound].globalJackpot.balance.add(jackpotSplitted);
386 
387         uint transactionId = kingdomTransactions.push(Transaction("", msg.sender, msg.value, 0, jackpotSplitted)) - 1;
388         kingdomTransactions[transactionId].kingdomKey = _key;
389         kingdoms[kingdomId].lastTransaction = transactionId;
390        
391         setNewJackpot(_type, jackpotSplitted, msg.sender);
392         LandCreatedEvent(_key, msg.sender);
393     }
394 
395     //
396     //  Send transaction to compensate the previous owner
397     //
398     function compensateLatestMonarch(uint lastTransaction, uint compensationWei) internal {
399         address compensationAddress = kingdomTransactions[lastTransaction].compensationAddress;
400         kingdomTransactions[lastTransaction].compensation = compensationWei;
401         asyncSend(compensationAddress, compensationWei);
402     }
403 
404     //
405     //  This function may be useful to force withdraw if user never come back to get his money
406     //
407     function forceWithdrawPayments(address payee) public onlyOwner {
408         uint256 payment = payments[payee];
409         require(payment != 0);
410         require(this.balance >= payment);
411         totalPayments = totalPayments.sub(payment);
412         payments[payee] = 0;
413         assert(payee.send(payment));
414     }
415 
416     function getStartTime() public view returns (uint startTime) {
417         return rounds[currentRound].startTime;
418     }
419 
420     function getEndTime() public view returns (uint endTime) {
421         return rounds[currentRound].endTime;
422     }
423     
424     function payJackpot(uint _type) public checkIsClosed() {
425         Round storage finishedRound = rounds[currentRound];
426         if (_type == 1 && finishedRound.jackpot1.winner != address(0) && finishedRound.jackpot1.balance > 0) {
427             require(this.balance >= finishedRound.jackpot1.balance);
428             uint jackpot1TeamComission = (finishedRound.jackpot1.balance.mul(TEAM_COMMISSION_RATIO)).div(100);
429             asyncSend(bookerAddress, jackpot1TeamComission);
430             asyncSend(finishedRound.jackpot1.winner, finishedRound.jackpot1.balance.sub(jackpot1TeamComission));
431             finishedRound.jackpot1.balance = 0;
432         } else if (_type == 2 && finishedRound.jackpot2.winner != address(0) && finishedRound.jackpot2.balance > 0) {
433             require(this.balance >= finishedRound.jackpot2.balance);
434             uint jackpot2TeamComission = (finishedRound.jackpot2.balance.mul(TEAM_COMMISSION_RATIO)).div(100);
435             asyncSend(bookerAddress, jackpot2TeamComission);
436             asyncSend(finishedRound.jackpot2.winner, finishedRound.jackpot2.balance.sub(jackpot2TeamComission));
437             finishedRound.jackpot2.balance = 0;
438         } else if (_type == 3 && finishedRound.jackpot3.winner != address(0) && finishedRound.jackpot3.balance > 0) {
439             require(this.balance >= finishedRound.jackpot3.balance);
440             uint jackpot3TeamComission = (finishedRound.jackpot3.balance.mul(TEAM_COMMISSION_RATIO)).div(100);
441             asyncSend(bookerAddress, jackpot3TeamComission);
442             asyncSend(finishedRound.jackpot3.winner, finishedRound.jackpot3.balance.sub(jackpot3TeamComission));
443             finishedRound.jackpot3.balance = 0;
444         } else if (_type == 4 && finishedRound.jackpot4.winner != address(0) && finishedRound.jackpot4.balance > 0) {
445             require(this.balance >= finishedRound.jackpot4.balance);
446             uint jackpot4TeamComission = (finishedRound.jackpot4.balance.mul(TEAM_COMMISSION_RATIO)).div(100);
447             asyncSend(bookerAddress, jackpot4TeamComission);
448             asyncSend(finishedRound.jackpot4.winner, finishedRound.jackpot4.balance.sub(jackpot4TeamComission));
449             finishedRound.jackpot4.balance = 0;
450         } else if (_type == 5 && finishedRound.jackpot5.winner != address(0) && finishedRound.jackpot5.balance > 0) {
451             require(this.balance >= finishedRound.jackpot5.balance);
452             uint jackpot5TeamComission = (finishedRound.jackpot5.balance.mul(TEAM_COMMISSION_RATIO)).div(100);
453             asyncSend(bookerAddress, jackpot5TeamComission);
454             asyncSend(finishedRound.jackpot5.winner, finishedRound.jackpot5.balance.sub(jackpot5TeamComission));
455             finishedRound.jackpot5.balance = 0;
456         }
457 
458         if (finishedRound.globalJackpot.winner != address(0) && finishedRound.globalJackpot.balance > 0) {
459             require(this.balance >= finishedRound.globalJackpot.balance);
460             uint globalTeamComission = (finishedRound.globalJackpot.balance.mul(TEAM_COMMISSION_RATIO)).div(100);
461             asyncSend(bookerAddress, globalTeamComission);
462             asyncSend(finishedRound.globalJackpot.winner, finishedRound.globalJackpot.balance.sub(globalTeamComission));
463             finishedRound.globalJackpot.balance = 0;
464         }
465     }
466 
467     //
468     //  After time expiration, owner can call this function to activate the next round of the game
469     //
470     function activateNextRound(uint _startTime) public checkIsClosed() {
471         Round storage finishedRound = rounds[currentRound];
472         require(finishedRound.globalJackpot.balance == 0);
473         require(finishedRound.jackpot5.balance == 0);
474         require(finishedRound.jackpot4.balance == 0);
475         require(finishedRound.jackpot3.balance == 0);
476         require(finishedRound.jackpot2.balance == 0);
477         require(finishedRound.jackpot1.balance == 0);
478         currentRound++;
479         rounds[currentRound] = Round(Jackpot(address(0), 0), Jackpot(address(0), 0), Jackpot(address(0), 0), Jackpot(address(0), 0), Jackpot(address(0), 0), Jackpot(address(0), 0), 0, 0);
480         rounds[currentRound].startTime = _startTime;
481         rounds[currentRound].endTime = _startTime + 7 days;
482         delete kingdoms;
483         delete kingdomTransactions;
484     }
485 
486     // GETTER AND SETTER FUNCTIONS
487 
488     function setNewWinner(address _sender, uint _type) internal {
489         if (rounds[currentRound].globalJackpot.winner == address(0)) {
490             rounds[currentRound].globalJackpot.winner = _sender;
491         } else {
492             if (rounds[currentRound].nbKingdoms[_sender] == rounds[currentRound].nbKingdoms[rounds[currentRound].globalJackpot.winner]) {
493                 if (rounds[currentRound].nbTransactions[_sender] > rounds[currentRound].nbTransactions[rounds[currentRound].globalJackpot.winner]) {
494                     rounds[currentRound].globalJackpot.winner = _sender;
495                 }
496             } else if (rounds[currentRound].nbKingdoms[_sender] > rounds[currentRound].nbKingdoms[rounds[currentRound].globalJackpot.winner]) {
497                 rounds[currentRound].globalJackpot.winner = _sender;
498             }
499         }
500         setTypedJackpotWinner(_sender, _type);
501     }
502 
503     function getJackpot(uint _nb) public view returns (address winner, uint balance, uint winnerCap) {
504         Round storage round = rounds[currentRound];
505         if (_nb == 1) {
506             return (round.jackpot1.winner, round.jackpot1.balance, round.nbKingdomsType1[round.jackpot1.winner]);
507         } else if (_nb == 2) {
508             return (round.jackpot2.winner, round.jackpot2.balance, round.nbKingdomsType2[round.jackpot2.winner]);
509         } else if (_nb == 3) {
510             return (round.jackpot3.winner, round.jackpot3.balance, round.nbKingdomsType3[round.jackpot3.winner]);
511         } else if (_nb == 4) {
512             return (round.jackpot4.winner, round.jackpot4.balance, round.nbKingdomsType4[round.jackpot4.winner]);
513         } else if (_nb == 5) {
514             return (round.jackpot5.winner, round.jackpot5.balance, round.nbKingdomsType5[round.jackpot5.winner]);
515         } else {
516             return (round.globalJackpot.winner, round.globalJackpot.balance, round.nbKingdoms[round.globalJackpot.winner]);
517         }
518     }
519 
520     function getKingdomCount() public view returns (uint kingdomCount) {
521         return kingdoms.length;
522     }
523 
524     function getKingdomInformations(string kingdomKey) public view returns (string title, uint minimumPrice, uint lastTransaction, uint transactionCount, address currentOwner, bool locked) {
525         uint kingdomId = rounds[currentRound].kingdomsKeys[kingdomKey];
526         Kingdom storage kingdom = kingdoms[kingdomId];
527         return (kingdom.title, kingdom.minimumPrice, kingdom.lastTransaction, kingdom.transactionCount, kingdom.owner, kingdom.locked);
528     }
529 
530 }