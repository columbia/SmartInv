1 pragma solidity ^0.4.24;
2 
3 // SafeMath library
4 library SafeMath {
5     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
6         uint256 c = _a + _b;
7         assert(c >= _a);
8         return c;
9     }
10 
11     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
12         assert(_a >= _b);
13         return _a - _b;
14     }
15 
16     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
17         if (_a == 0) {
18             return 0;
19         }
20         uint256 c = _a * _b;
21         assert(c / _a == _b);
22         return c;
23     }
24 
25     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
26         return _a / _b;
27     }
28 }
29 
30 // Contract must have an owner
31 contract Ownable {
32     address public owner;
33 
34     constructor() public {
35         owner = msg.sender;
36     }
37 
38     modifier onlyOwner() {
39         require(msg.sender == owner, "sender must be owner");
40         _;
41     }
42 
43     function setOwner(address _owner) onlyOwner public {
44         owner = _owner;
45     }
46 }
47 
48 // SaleBook Contract
49 contract SaleBook is Ownable {
50     using SafeMath for uint256;
51 
52     // admins info
53     mapping (uint256 => address) public admins;
54     mapping (address => uint256) public adminId;
55     uint256 public adminCount = 0;
56 
57     // investor data
58     struct InvestorData {
59         uint256 id;
60         address addr;
61         uint256 ref;
62         address ref1;
63         address ref2;
64         uint256 reffed;
65         uint256 topref;
66         uint256 topreffed;
67     }
68 
69     mapping (uint256 => InvestorData) public investors;
70     mapping (address => uint256) public investorId;
71     uint256 public investorCount = 0;
72 
73     event AdminAdded(address indexed _addr, uint256 _id, address indexed _adder);
74     event AdminRemoved(address indexed _addr, uint256 _id, address indexed _remover);
75     event InvestorAdded(address indexed _addr, uint256 _id, address _ref1, address _ref2, address indexed _adder);
76 
77     // check the address is human or contract
78     function isHuman(address _addr) public view returns (bool) {
79         uint256 _codeLength;
80         assembly {_codeLength := extcodesize(_addr)}
81         return (_codeLength == 0);
82     }
83 
84     modifier validAddress(address _addr) {
85         require(_addr != 0x0);
86         _;
87     }
88 
89     modifier onlyAdmin() {
90         require(adminId[msg.sender] != 0);
91         _;
92     }
93 
94     constructor() public {
95         adminId[address(0x0)] = 0;
96         admins[0] = address(0x0);
97 
98         investorId[address(0x0)] = 0;
99         investors[0] = InvestorData({id: 0, addr: address(0x0), ref: 0, ref1: address(0x0), ref2: address(0x0), reffed: 0, topref: 0, topreffed: 0});
100 
101 
102         // first admin is owner
103         addAdmin(owner);
104     }
105 
106     // owner may add or remove admins
107     function addAdmin(address _admin) onlyOwner validAddress(_admin) public {
108         require(isHuman(_admin));
109 
110         uint256 id = adminId[_admin];
111         if (id == 0) {
112             id = adminCount.add(1);
113             adminId[_admin] = id;
114             admins[id] = _admin;
115             adminCount = id;
116             emit AdminAdded(_admin, id, msg.sender);
117         }
118     }
119 
120     function removeAdmin(address _admin) onlyOwner validAddress(_admin) public {
121         require(adminId[_admin] != 0);
122 
123         uint256 aid = adminId[_admin];
124         adminId[_admin] = 0;
125         for (uint256 i = aid; i < adminCount; i++){
126             admins[i] = admins[i + 1];
127             adminId[admins[i]] = i;
128         }
129         delete admins[adminCount];
130         adminCount--;
131         emit AdminRemoved(_admin, aid, msg.sender);
132     }
133 
134     // admins may batch add investors, and investors cannot be removed
135     function addInvestor(address _addr, address _ref1, address _ref2) validAddress(_addr) internal returns (uint256) {
136         require(investorId[_addr] == 0 && isHuman(_addr));
137         if (investorId[_ref1] == 0) _ref1 = address(0x0);
138         if (investorId[_ref2] == 0) _ref2 = address(0x0);
139 
140         investorCount++;
141         investorId[_addr] = investorCount;
142 
143         investors[investorCount] = InvestorData({id: investorCount, addr: _addr, ref: 0, ref1: _ref1, ref2: _ref2, reffed: 0, topref: 0, topreffed: 0});
144 
145         emit InvestorAdded(_addr, investorCount, _ref1, _ref2, msg.sender);
146         return investorCount;
147     }
148 
149 }
150 
151 interface ERC20Token {
152     function transfer(address _to, uint256 _value) external returns (bool);
153     function balanceOf(address _addr) external view returns (uint256);
154     function decimals() external view returns (uint8);
155 }
156 
157 contract CNTOSale is SaleBook {
158     using SafeMath for uint256;
159 
160     string constant name = "CNTO Sale";
161     string constant version = "1.8";
162     uint256 constant keybase = 1000000000000000000;
163     uint256 constant DAY_IN_SECONDS = 86400;
164     uint256 private rseed = 0;
165 
166     // various token related stuff
167     struct TokenInfo {
168         ERC20Token token;
169         address addr;
170         uint8 decimals;
171         address payaddr;
172         uint256 bought;
173         uint256 vaulted;
174         uint256 price;
175         uint256 buypercent;
176         uint256 lockperiod;
177     }
178 
179     TokenInfo public tokenInfo;
180 
181     // Investor's time-locked vaults to store tokens
182     struct InvestorTokenVault {
183         mapping (uint256 => uint256) lockValue;
184         mapping (uint256 => uint256) lockTime;
185         uint256 totalToken;
186         uint256 locks;
187         uint256 withdraws;
188         uint256 withdrawn;
189     }
190 
191     mapping(uint256 => InvestorTokenVault) public investorVaults;
192 
193 
194     // Round related data
195     struct RoundData {
196         uint256 startTime;
197         uint256 endTime;
198         bool ended;
199         uint256 keys;
200         uint256 shares;
201         uint256 ethers;
202         uint256 pot;
203         uint256 divie;
204         uint256 currentInvestor;
205     }
206 
207     bool public saleActive;
208     uint256 public saleEndTime;
209     uint256 public roundNum = 0; // current Round number
210     uint256 public endNum = 0; // end Round number
211     mapping (uint256 => RoundData) public rounds; // all rounds data for the game
212 
213     // investor related info
214     struct InvestorInfo {
215         address addr;
216         uint256 lastRound;
217         uint256 invested;
218         uint256 keys;
219         uint256 prevEther;
220         uint256 lastEther;
221         uint256 potEther;
222         uint256 candyEther;
223         uint256 refEther;
224         uint256 withdrawn;
225     }
226 
227     mapping (uint256 => InvestorInfo) public investorInfo; // all investor info for the sale
228 
229     // Investor keys and shares in each round
230     struct InvestorRoundData {
231         uint256 keys;
232         uint256 shares;
233     }
234 
235     mapping (uint256 => mapping (uint256 => InvestorRoundData)) public investorAtRound; // round number => id => investor keys and shares
236 
237     // attributes of the entire Game
238     uint256 public roundTimeLimit;
239     uint256 public keyTime;
240     uint256 public keyprice;
241     uint256 public stepped;
242     uint256 public potpercent;
243     uint256 public diviepercent;
244     uint256 public tokenpercent;
245     uint256 public candypercent;
246     uint256 public candyvalue;
247     uint256 public candythreshold;
248     uint256 public candyprob;
249     uint256 public ref1percent;
250     uint256 public ref2percent;
251     uint256 public oppercent;
252     address public opaddress;
253     address public defaddress;
254     uint256 public defid;
255 
256     // Round related events
257     event KeyBought(uint256 _round, uint256 _id, uint256 _keys, uint256 _shares);
258     event NewRoundCreated(uint256 _round, uint256 _id, uint256 _startTime, uint256 _endTime);
259     event RoundExtended(uint256 _round, uint256 _id, uint256 _endTime);
260     event PotWon(uint256 _round, uint256 _id, uint256 _pot);
261     event CandyWon(uint256 _round, uint256 _id, uint256 _candy);
262     event EtherWithdrawn(uint256 _round, uint256 _id, uint256 _value);
263     event EndingSale(address indexed _ender, uint256 _round, uint256 _time);
264     event SaleEnded(uint256 _round, uint256 _time);
265     event EtherReturned(address indexed _sender, uint256 _value, uint256 _time);
266 
267     // Token related events
268     event TokenBought(uint256 _id, uint256 _amount);
269     event TokenLocked(uint256 _id, uint256 _amount, uint256 _locktime);
270     event TokenFundPaid(address indexed _paddr, uint256 _value);
271     event TokenWithdrawn(uint256 _id, uint256 _amount);
272 
273     // Safety measure events
274     event WrongTokenEmptied(address indexed _token, address indexed _addr, uint256 _amount, address indexed _target);
275     event InactiveTokenEmptied(address indexed _addr, uint256 _amount, address indexed _target);
276     event InactiveEtherEmptied(address indexed _addr, uint256 _amount, address indexed _target);
277     event ForgottenTokenEmptied(address indexed _addr, uint256 _amount, address indexed _target);
278     event ForgottenEtherEmptied(address indexed _addr, uint256 _amount, address indexed _target);
279 
280     constructor(address _tokenAddress, address _payAddress, uint256 _price, uint256 _buypercent, uint256 _lockperiod, uint256 _candythreshold,
281     uint256 _candyprob, address _defaddress) public {
282         tokenInfo.token = ERC20Token(_tokenAddress);
283         tokenInfo.addr = _tokenAddress;
284         tokenInfo.decimals = tokenInfo.token.decimals();
285         tokenInfo.payaddr = _payAddress;
286         tokenInfo.bought = 0;
287         tokenInfo.vaulted = 0;
288         tokenInfo.price = _price;
289         tokenInfo.buypercent = _buypercent;
290         tokenInfo.lockperiod = _lockperiod;
291         candythreshold = _candythreshold;
292         candyprob = _candyprob;
293         defaddress = _defaddress;
294 
295         defid = addInvestor(defaddress, address(0x0), address(0x0));
296     }
297 
298     function initRound(uint256 _roundTimeLimit, uint256 _keyTime, uint256 _keyprice, uint256 _stepped, uint256 _potpercent, uint256 _diviepercent, uint256 _tokenpercent,
299     uint256 _candypercent, uint256 _ref1percent, uint256 _ref2percent, uint256 _oppercent, address _opaddress) onlyAdmin public {
300         require(roundNum == 0, "already initialized");
301         require(!((_potpercent + _diviepercent + _tokenpercent + _candypercent + _ref1percent + _ref2percent + _oppercent) > 100), "the sum cannot be greater than 100");
302         roundTimeLimit = _roundTimeLimit;
303         keyTime = _keyTime;
304         keyprice = _keyprice;
305         stepped = _stepped;
306         potpercent = _potpercent;
307         diviepercent = _diviepercent;
308         tokenpercent = _tokenpercent;
309         candypercent = _candypercent;
310         ref1percent = _ref1percent;
311         ref2percent = _ref2percent;
312         oppercent = _oppercent;
313         opaddress = _opaddress;
314 
315         candyvalue = 0;
316         saleActive = true;
317         roundNum = 1;
318 
319         rounds[roundNum] = RoundData({startTime: now, endTime: now.add(roundTimeLimit), ended: false, keys: 0, shares: 0, ethers: 0, pot: 0, divie: 0, currentInvestor: 0});
320         emit NewRoundCreated(roundNum, 0, rounds[roundNum].startTime, rounds[roundNum].endTime);
321     }
322 
323     function saleState() public view returns (uint8 _status) {
324         if (roundNum == 0) return 0;
325         if (!saleActive && roundNum >= endNum) return 2;
326         return 1;
327     }
328 
329     function roundStatus(uint256 _round) public view returns (uint8 _status) {
330         require(_round <= roundNum);
331         if (rounds[_round].ended) return 0;
332         return 1;
333     }
334 
335     function getCurrentRoundInfo() public view returns (uint256 _divie, uint256 _startTime, uint256 _endTime,
336     uint256 _ethers, uint256 _keyTime, uint256 _keys, uint256 _pot, uint256 _candy, uint256 _roundNum,
337     uint8 _status, uint256 _tokenprice, uint256 _keyprice, uint8 _activityStatus, uint256 _activityStartTime) {
338         if(saleState() == 2) {
339             return (rounds[roundNum - 1].divie, rounds[roundNum - 1].startTime, rounds[roundNum - 1].endTime, rounds[roundNum - 1].ethers, keyTime, rounds[roundNum - 1].keys,
340             rounds[roundNum - 1].pot, candyvalue, roundNum - 1, roundStatus(roundNum - 1), tokenInfo.price, keyprice, saleState(), rounds[1].startTime);
341         }
342         return (rounds[roundNum].divie, rounds[roundNum].startTime, rounds[roundNum].endTime, rounds[roundNum].ethers, keyTime, rounds[roundNum].keys,
343         rounds[roundNum].pot, candyvalue, roundNum, roundStatus(roundNum), tokenInfo.price, keyprice, saleState(), rounds[1].startTime);
344     }
345 
346     function getRoundInfo(uint256 _round) public view returns (uint256 _divie, uint256 _startTime, uint256 _endTime,
347     uint256 _ethers, uint256 _keys, uint256 _pot, uint8 _status) {
348         require(_round <= roundNum);
349         return (rounds[_round].divie, rounds[_round].startTime, rounds[_round].endTime,
350         rounds[_round].ethers, rounds[_round].keys, rounds[_round].pot, roundStatus(_round));
351     }
352 
353     function getAllRoundsInfo() external view returns (uint256[] _divies, uint256[] _startTimes, uint256[] _endTimes,
354     uint256[] _ethers, uint256[] _keys, uint256[] _pots, uint8[] _status) {
355         uint256 i = 0;
356 
357         _divies = new uint256[](roundNum);
358         _startTimes = new uint256[](roundNum);
359         _endTimes = new uint256[](roundNum);
360         _ethers = new uint256[](roundNum);
361         _keys = new uint256[](roundNum);
362         _pots = new uint256[](roundNum);
363         _status = new uint8[](roundNum);
364 
365         while (i < roundNum) {
366             (_divies[i], _startTimes[i], _endTimes[i], _ethers[i], _keys[i], _pots[i], _status[i]) = getRoundInfo(i + 1);
367             i++;
368         }
369         return (_divies, _startTimes, _endTimes, _ethers, _keys, _pots, _status);
370     }
371 
372     function tokenBalance() public view returns (uint256 _balance) {
373         return tokenInfo.token.balanceOf(address(this)).sub(tokenInfo.vaulted);
374     }
375 
376     function tokenBuyable(uint256 _eth) public view returns (bool _buyable) {
377         if (!saleActive && roundNum >= endNum) return false;
378         uint256 buyAmount = (_eth).mul(tokenInfo.buypercent).div(100).mul(uint256(10)**tokenInfo.decimals).div(tokenInfo.price);
379         return (tokenBalance() >= buyAmount);
380     }
381 
382     // Handles the buying of Tokens
383     function buyToken(uint256 _id, uint256 _eth) internal {
384         require(_id <= investorCount, "invalid investor id");
385         require(tokenBuyable(_eth), "not enough token in reserve");
386 
387         uint256 buyAmount = (_eth).mul(tokenInfo.buypercent).div(100).mul(uint256(10)**tokenInfo.decimals).div(tokenInfo.price);
388         assert(tokenBalance() >= buyAmount);
389 
390         tokenInfo.bought = tokenInfo.bought.add(buyAmount);
391         tokenInfo.vaulted = tokenInfo.vaulted.add(buyAmount);
392 
393         emit TokenBought(_id, buyAmount);
394 
395         uint256 lockStartTime = rounds[roundNum].startTime;
396         tokenTimeLock(_id, buyAmount, lockStartTime);
397 
398         tokenInfo.payaddr.transfer(_eth);
399 
400         emit TokenFundPaid(tokenInfo.payaddr, _eth);
401     }
402 
403     // lock the Tokens allocated to investors with a timelock
404     function tokenTimeLock(uint256 _id, uint256 _amount, uint256 _start) private {
405         uint256 lockTime;
406         uint256 lockNum;
407         uint256 withdrawNum;
408 
409         for (uint256 i = 0; i < 10; i++) {
410             lockTime = _start + tokenInfo.lockperiod.div(10).mul(i.add(1));
411             lockNum = investorVaults[_id].locks;
412             withdrawNum = investorVaults[_id].withdraws;
413             if (lockNum >= 10 && lockNum >= withdrawNum.add(10)) {
414                 if (investorVaults[_id].lockTime[lockNum.sub(10).add(i)] == lockTime) {
415                     investorVaults[_id].lockValue[lockNum.sub(10).add(i)] = investorVaults[_id].lockValue[lockNum.sub(10).add(i)].add(_amount.div(10));
416                 } else {
417                     investorVaults[_id].lockTime[lockNum] = lockTime;
418                     investorVaults[_id].lockValue[lockNum] = _amount.div(10);
419                     investorVaults[_id].locks++;
420                 }
421             } else {
422                 investorVaults[_id].lockTime[lockNum] = lockTime;
423                 investorVaults[_id].lockValue[lockNum] = _amount.div(10);
424                 investorVaults[_id].locks++;
425             }
426             emit TokenLocked(_id, _amount.div(10), lockTime);
427         }
428 
429         investorVaults[_id].totalToken = investorVaults[_id].totalToken.add(_amount);
430     }
431 
432     function showInvestorVaultByAddress(address _addr) public view returns (uint256 _total, uint256 _locked, uint256 _unlocked, uint256 _withdrawable, uint256 _withdrawn) {
433         uint256 id = investorId[_addr];
434         if (id == 0) {
435             return (0, 0, 0, 0, 0);
436         }
437         return showInvestorVaultById(id);
438     }
439 
440     function showInvestorVaultById(uint256 _id) public view returns (uint256 _total, uint256 _locked, uint256 _unlocked, uint256 _withdrawable, uint256 _withdrawn) {
441         require(_id <= investorCount && _id > 0, "invalid investor id");
442         uint256 locked = 0;
443         uint256 unlocked = 0;
444         uint256 withdrawable = 0;
445         uint256 withdraws = investorVaults[_id].withdraws;
446         uint256 locks = investorVaults[_id].locks;
447         uint256 withdrawn = investorVaults[_id].withdrawn;
448         for (uint256 i = withdraws; i < locks; i++) {
449             if (investorVaults[_id].lockTime[i] < now) {
450                 unlocked = unlocked.add(investorVaults[_id].lockValue[i]);
451                 if (i - withdraws < 50) withdrawable = withdrawable.add(investorVaults[_id].lockValue[i]);
452             } else {
453                 locked = locked.add(investorVaults[_id].lockValue[i]);
454             }
455         }
456         return (investorVaults[_id].totalToken, locked, unlocked, withdrawable, withdrawn);
457     }
458 
459     function showInvestorVaultTime(uint256 _id, uint256 _count) public view returns (uint256 _time) {
460         return investorVaults[_id].lockTime[_count];
461     }
462 
463     function showInvestorVaultValue(uint256 _id, uint256 _count) public view returns (uint256 _value) {
464         return investorVaults[_id].lockValue[_count];
465     }
466 
467     // investors may withdraw tokens after the timelock period
468     function withdrawToken() public {
469         uint256 id = investorId[msg.sender];
470         require(id > 0, "withdraw need valid investor");
471         uint256 withdrawable = 0;
472         uint256 i = investorVaults[id].withdraws;
473         uint256 count = 0;
474         uint256 locks = investorVaults[id].locks;
475         for (; (i < locks) && (count < 50); i++) {
476             if (investorVaults[id].lockTime[i] < now) {
477                 withdrawable = withdrawable.add(investorVaults[id].lockValue[i]);
478                 investorVaults[id].withdraws = i + 1;
479             }
480             count++;
481         }
482 
483         assert((tokenInfo.token.balanceOf(address(this)) >= withdrawable) && (tokenInfo.vaulted >= withdrawable));
484         tokenInfo.vaulted = tokenInfo.vaulted.sub(withdrawable);
485         investorVaults[id].withdrawn = investorVaults[id].withdrawn.add(withdrawable);
486         require(tokenInfo.token.transfer(msg.sender, withdrawable), "token withdraw transfer failed");
487 
488         emit TokenWithdrawn(id, withdrawable);
489     }
490 
491     modifier isPaid() {
492         // paymnent must be greater than 1GWei and less than 100k ETH
493         require((msg.value > 1000000000) && (msg.value < 100000000000000000000000), "payment invalid");
494         _;
495     }
496 
497     function buyKey(address _ref1, address _ref2, address _node) isPaid public payable returns (bool _success) {
498         require(roundNum > 0, "uninitialized");
499         require(!rounds[roundNum].ended, "cannot buy key from ended round");
500 
501         if (_ref1 == address(0x0)) {
502             _ref1 = defaddress;
503         }
504         if (_ref2 == address(0x0)) {
505             _ref2 = defaddress;
506         }
507         if (_node == address(0x0)) {
508             _node = defaddress;
509         }
510 
511         uint256 id = investorId[msg.sender];
512         if (id == 0) {
513             if (investorId[_node] == 0) {
514                 _node = defaddress;
515             }
516             if (investorId[_ref1] == 0) {
517                 _ref1 = _node;
518             }
519             if (investorId[_ref2] == 0) {
520                 _ref2 = _node;
521             }
522             id = addInvestor(msg.sender, _ref1, _ref2);
523         }
524         investorInfo[id].addr = msg.sender;
525         if (rounds[roundNum].ethers == 0) {
526             rounds[roundNum].startTime = now;
527             rounds[roundNum].endTime = now.add(roundTimeLimit);
528         }
529         uint256 topot = msg.value.mul(potpercent).div(100);
530         uint256 todivie = msg.value.mul(diviepercent).div(100);
531         uint256 totoken = msg.value.mul(tokenpercent).div(100);
532         uint256 tocandy = msg.value.mul(candypercent).div(100);
533         uint256 toref1 = msg.value.mul(ref1percent).div(100);
534         uint256 toref2 = msg.value.mul(ref2percent).div(100);
535         uint256 toop = msg.value.mul(oppercent).div(100);
536 
537 
538         if (now > rounds[roundNum].endTime) {
539             // current round ended, pot goes to winner
540             investorInfo[rounds[roundNum].currentInvestor].potEther = investorInfo[rounds[roundNum].currentInvestor].potEther.add(rounds[roundNum].pot);
541             emit PotWon(roundNum, rounds[roundNum].currentInvestor, rounds[roundNum].pot);
542 
543             // start a new round
544             startNewRound(id, msg.value, topot, todivie);
545         } else {
546             processCurrentRound(id, msg.value, topot, todivie);
547         }
548 
549         if (rounds[roundNum].ended) {
550             msg.sender.transfer(msg.value);
551             emit EtherReturned(msg.sender, msg.value, now);
552             return false;
553         }
554 
555         uint256 cn = tryRandom();
556 
557         candyvalue = candyvalue.add(tocandy);
558         if ((cn % candyprob == 0) && (msg.value >= candythreshold)) {
559             investorInfo[id].candyEther = investorInfo[id].candyEther.add(candyvalue);
560             candyvalue = 0;
561         }
562 
563         toRef(id, toref1, toref2);
564 
565         investorInfo[id].invested = investorInfo[id].invested.add(msg.value);
566 
567         opaddress.transfer(toop);
568         buyToken(id, totoken);
569         return true;
570     }
571 
572     function toRef(uint256 _id, uint256 _toref1, uint256 _toref2) private {
573         uint256 ref1 = investorId[investors[_id].ref1];
574         uint256 ref2 = investorId[investors[_id].ref2];
575         if (ref1 == 0 || ref1 > investorCount) {
576             ref1 = defid;
577         }
578         if (ref2 == 0 || ref2 > investorCount) {
579             ref2 = defid;
580         }
581         investorInfo[ref1].refEther = investorInfo[ref1].refEther.add(_toref1);
582         investorInfo[ref2].refEther = investorInfo[ref2].refEther.add(_toref2);
583     }
584 
585     function tryRandom() private returns (uint256) {
586         uint256 bn = block.number;
587         rseed++;
588         uint256 bm1 = uint256(blockhash(bn - 1)) % 250 + 1;
589         uint256 bm2 = uint256(keccak256(abi.encodePacked(now))) % 250 + 2;
590         uint256 bm3 = uint256(keccak256(abi.encodePacked(block.difficulty))) % 250 + 3;
591         uint256 bm4 = uint256(keccak256(abi.encodePacked(uint256(msg.sender) + gasleft() + block.gaslimit))) % 250 + 4;
592         uint256 bm5 = uint256(keccak256(abi.encodePacked(uint256(keccak256(msg.data)) + msg.value + uint256(block.coinbase)))) % 250 + 5;
593         uint256 cn = uint256(keccak256(abi.encodePacked((bn + rseed) ^ uint256(blockhash(bn - bm1)) ^ uint256(blockhash(bn - bm2)) ^ uint256(blockhash(bn - bm3))
594         ^ uint256(blockhash(bn - bm4)) ^ uint256(blockhash(bn - bm5)))));
595         return cn;
596     }
597 
598     function startNewRound(uint256 _id, uint256 _eth, uint256 _topot, uint256 _todivie) private {
599         processLastEther(_id);
600         investorInfo[_id].prevEther = investorInfo[_id].prevEther.add(investorInfo[_id].lastEther);
601         investorInfo[_id].lastEther = 0;
602         rounds[roundNum].ended = true;
603         roundNum++;
604         if (!saleActive) {
605             rounds[roundNum].ended = true;
606             saleEndTime = now;
607             emit SaleEnded(roundNum.sub(1), now);
608             return;
609         }
610         rounds[roundNum] = RoundData({startTime: now, endTime: now.add(roundTimeLimit), ended: false, keys: 0, shares: 0, ethers: _eth, pot: _topot, divie: _todivie, currentInvestor: _id});
611         uint256 boughtkeys = _eth.mul(keybase).div(keyprice);
612         uint256 denominator = uint256(1).add(rounds[roundNum].keys.div(stepped).div(keybase));
613         rounds[roundNum].keys = boughtkeys;
614         investorAtRound[roundNum][_id].keys = boughtkeys;
615         investorInfo[_id].keys = investorInfo[_id].keys.add(boughtkeys);
616         uint256 boughtshares = boughtkeys.div(denominator);
617         rounds[roundNum].shares = boughtshares;
618         investorAtRound[roundNum][_id].shares = boughtshares;
619         investorInfo[_id].lastRound = roundNum;
620         investorInfo[_id].lastEther = rounds[roundNum].divie.mul(investorAtRound[roundNum][_id].shares).div(rounds[roundNum].shares);
621 
622         emit NewRoundCreated(roundNum, _id, rounds[roundNum].startTime, rounds[roundNum].endTime);
623         emit KeyBought(roundNum, _id, boughtkeys, boughtshares);
624     }
625 
626     function processCurrentRound(uint256 _id, uint256 _eth, uint256 _topot, uint256 _todivie) private {
627         processLastEther(_id);
628         rounds[roundNum].ethers = rounds[roundNum].ethers.add(_eth);
629         rounds[roundNum].pot = rounds[roundNum].pot.add(_topot);
630         rounds[roundNum].divie = rounds[roundNum].divie.add(_todivie);
631         uint256 boughtkeys = _eth.mul(keybase).div(keyprice);
632         uint256 denominator = uint256(1).add(rounds[roundNum].keys.div(stepped).div(keybase));
633         rounds[roundNum].keys = rounds[roundNum].keys.add(boughtkeys);
634         investorAtRound[roundNum][_id].keys = investorAtRound[roundNum][_id].keys.add(boughtkeys);
635         investorInfo[_id].keys = investorInfo[_id].keys.add(boughtkeys);
636         uint256 boughtshares = boughtkeys.div(denominator);
637         rounds[roundNum].shares = rounds[roundNum].shares.add(boughtshares);
638         investorAtRound[roundNum][_id].shares = investorAtRound[roundNum][_id].shares.add(boughtshares);
639         investorInfo[_id].lastRound = roundNum;
640         investorInfo[_id].lastEther = rounds[roundNum].divie.mul(investorAtRound[roundNum][_id].shares).div(rounds[roundNum].shares);
641 
642         rounds[roundNum].endTime = rounds[roundNum].endTime.add(boughtkeys.div(keybase).mul(keyTime));
643         if (rounds[roundNum].endTime > now.add(roundTimeLimit)) {
644             rounds[roundNum].endTime = now.add(roundTimeLimit);
645         }
646 
647         rounds[roundNum].currentInvestor = _id;
648 
649         emit RoundExtended(roundNum, _id, rounds[roundNum].endTime);
650         emit KeyBought(roundNum, _id, boughtkeys, boughtshares);
651     }
652 
653     function processLastEther(uint256 _id) private {
654         uint256 pround = investorInfo[_id].lastRound;
655         assert(pround <= roundNum);
656         if (pround < roundNum && rounds[pround].shares > 0) {
657             investorInfo[_id].prevEther = investorInfo[_id].prevEther.add(rounds[pround].divie.mul(investorAtRound[pround][_id].shares).div(rounds[pround].shares));
658         }
659         if (rounds[roundNum].shares > 0) {
660             investorInfo[_id].lastEther = rounds[roundNum].divie.mul(investorAtRound[roundNum][_id].shares).div(rounds[roundNum].shares);
661         } else {
662             investorInfo[_id].lastEther = 0;
663         }
664         investorInfo[_id].lastRound = roundNum;
665     }
666 
667     function showInvestorExtraByAddress(address _addr) public view returns (uint256 _invested, uint256 _lastRound, uint256 _keys, uint8 _activityStatus, uint256 _roundNum, uint256 _startTime) {
668         uint256 id = investorId[_addr];
669         if (id == 0) {
670             return (0, 0, 0, 0, 0, 0);
671         }
672         return showInvestorExtraById(id);
673     }
674 
675     function showInvestorExtraById(uint256 _id ) public view returns (uint256 _invested, uint256 _lastRound, uint256 _keys, uint8 _activityStatus, uint256 _roundNum, uint256 _startTime) {
676         require(_id <= investorCount && _id > 0, "invalid investor id");
677         uint256 pinvested = investorInfo[_id].invested;
678         uint256 plastRound = investorInfo[_id].lastRound;
679         uint256 pkeys = investorInfo[_id].keys;
680         return (pinvested, plastRound, pkeys, saleState(), (saleState() == 2) ? roundNum - 1 : roundNum, rounds[1].startTime);
681     }
682 
683     // show Investor's ether info
684     function showInvestorEtherByAddress(address _addr) public view returns (uint256 _divie, uint256 _pot, uint256 _candy, uint256 _ref, uint256 _withdrawable, uint256 _withdrawn) {
685         uint256 id = investorId[_addr];
686         if (id == 0) {
687             return (0, 0, 0, 0, 0, 0);
688         }
689         return showInvestorEtherById(id);
690     }
691 
692     function showInvestorEtherById(uint256 _id) public view returns (uint256 _divie, uint256 _pot, uint256 _candy, uint256 _ref, uint256 _withdrawable, uint256 _withdrawn) {
693         require(_id <= investorCount && _id > 0, "invalid investor id");
694         uint256 pdivie;
695         uint256 ppot;
696         uint256 pcandy;
697         uint256 pref;
698         (pdivie, ppot, pcandy, pref) = investorInfoById(_id);
699         uint256 pwithdrawn = investorInfo[_id].withdrawn;
700         uint256 pwithdrawable = pdivie.add(ppot).add(pcandy).add(pref).sub(pwithdrawn);
701         return (pdivie, ppot, pcandy, pref, pwithdrawable, pwithdrawn);
702     }
703 
704     function investorInfoById(uint256 _id) private view returns (uint256 _divie, uint256 _pot, uint256 _candy, uint256 _ref) {
705         require(_id <= investorCount && _id > 0, "invalid investor id");
706 
707         uint256 pdivie = investorInfo[_id].prevEther;
708         if (investorInfo[_id].lastRound > 0) {
709             uint256 pround = investorInfo[_id].lastRound;
710             assert(pround <= roundNum);
711             pdivie = pdivie.add(rounds[pround].divie.mul(investorAtRound[pround][_id].shares).div(rounds[pround].shares));
712         }
713         uint256 ppot = investorInfo[_id].potEther;
714         uint256 pcandy = investorInfo[_id].candyEther;
715         uint256 pref = investorInfo[_id].refEther;
716 
717         return (pdivie, ppot, pcandy, pref);
718     }
719 
720     // investor withdraw ether
721     function withdraw() public {
722         require(roundNum > 0, "uninitialized");
723         if (now > rounds[roundNum].endTime) {
724             // current round ended, pot goes to winner
725             investorInfo[rounds[roundNum].currentInvestor].potEther = investorInfo[rounds[roundNum].currentInvestor].potEther.add(rounds[roundNum].pot);
726             emit PotWon(roundNum, rounds[roundNum].currentInvestor, rounds[roundNum].pot);
727 
728             // start a new round
729             startNewRoundFromWithdrawal();
730         }
731         uint256 pdivie;
732         uint256 ppot;
733         uint256 pcandy;
734         uint256 pref;
735         uint256 withdrawable;
736         uint256 withdrawn;
737         uint256 id = investorId[msg.sender];
738         (pdivie, ppot, pcandy, pref, withdrawable, withdrawn) = showInvestorEtherById(id);
739         require(withdrawable > 0, "no ether to withdraw");
740         require(address(this).balance >= withdrawable, "something wrong, not enough ether in reserve");
741         investorInfo[id].withdrawn = investorInfo[id].withdrawn.add(withdrawable);
742         msg.sender.transfer(withdrawable);
743 
744         emit EtherWithdrawn(roundNum, id, withdrawable);
745     }
746 
747     function startNewRoundFromWithdrawal() private {
748         rounds[roundNum].ended = true;
749         roundNum++;
750         if (!saleActive) {
751             rounds[roundNum].ended = true;
752             saleEndTime = now;
753             emit SaleEnded(roundNum.sub(1), now);
754             return;
755         }
756         rounds[roundNum] = RoundData({startTime: now, endTime: now.add(roundTimeLimit), ended: false, keys: 0, shares: 0, ethers: 0, pot: 0, divie: 0, currentInvestor: 0});
757 
758         emit NewRoundCreated(roundNum, 0, rounds[roundNum].startTime, rounds[roundNum].endTime);
759     }
760 
761     // end the whole Sale after the current round
762     function endSale() onlyAdmin public {
763         saleActive = false;
764         endNum = roundNum.add(1);
765         emit EndingSale(msg.sender, roundNum, now);
766     }
767 
768     // admin can empty wrongly sent Tokens
769     function emptyWrongToken(address _addr, address _target) onlyAdmin public {
770         require(_addr != tokenInfo.addr, "this is not a wrong token");
771         ERC20Token wrongToken = ERC20Token(_addr);
772         uint256 amount = wrongToken.balanceOf(address(this));
773         require(amount > 0, "no wrong token sent here");
774         require(wrongToken.transfer(_target, amount), "token transfer failed");
775 
776         emit WrongTokenEmptied(_addr, msg.sender, amount, _target);
777     }
778 
779     // admins can empty unsold tokens after sale ended
780     function emptyInactiveToken(address _target) onlyAdmin public {
781         require(!saleActive && roundNum >= endNum, "sale still active");
782         uint256 amount = tokenInfo.token.balanceOf(address(this)).sub(tokenInfo.vaulted);
783         require(tokenInfo.token.transfer(_target, amount), "inactive token transfer failed");
784 
785         emit InactiveTokenEmptied(msg.sender, amount, _target);
786     }
787 
788     // admins can empty unclaimed candy ethers after sale ended
789     function emptyInactiveEther(address _target) onlyAdmin public {
790         require(!saleActive && roundNum >= endNum, "sale still active");
791         require(candyvalue > 0, "no inactive ether");
792         uint256 amount = candyvalue;
793         _target.transfer(amount);
794         candyvalue = 0;
795 
796         emit InactiveEtherEmptied(msg.sender, amount, _target);
797     }
798 
799 
800     // Emoty tokens and ethers after a long time?
801     function emptyForgottenToken(address _target) onlyAdmin public {
802         require(!saleActive && roundNum >= endNum, "sale still active");
803         require(now > saleEndTime.add(tokenInfo.lockperiod).add(180 * DAY_IN_SECONDS), "still in waiting period");
804         uint256 amount = tokenInfo.token.balanceOf(address(this));
805         require(tokenInfo.token.transfer(_target, amount), "forgotten token transfer failed");
806 
807         emit ForgottenTokenEmptied(msg.sender, amount, _target);
808     }
809 
810     function emptyForgottenEther(address _target) onlyAdmin public {
811         require(!saleActive && roundNum >= endNum, "sale still active");
812         require(now > saleEndTime.add(tokenInfo.lockperiod).add(180 * DAY_IN_SECONDS), "still in waiting period");
813         uint256 amount = address(this).balance;
814         _target.transfer(amount);
815 
816         emit ForgottenEtherEmptied(msg.sender, amount, _target);
817     }
818 
819 
820     function () public payable {
821         revert();
822     }
823 }