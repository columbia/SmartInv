1 pragma solidity ^0.5.0;
2 
3 contract CryptoTycoonsVIPLib{
4     
5     address payable public owner;
6     
7     // Accumulated jackpot fund.
8     uint128 public jackpotSize;
9     uint128 public rankingRewardSize;
10     
11     mapping (address => uint) userExpPool;
12     mapping (address => bool) public callerMap;
13 
14     event RankingRewardPayment(address indexed beneficiary, uint amount);
15 
16     modifier onlyOwner {
17         require(msg.sender == owner, "OnlyOwner methods called by non-owner.");
18         _;
19     }
20 
21     modifier onlyCaller {
22         bool isCaller = callerMap[msg.sender];
23         require(isCaller, "onlyCaller methods called by non-caller.");
24         _;
25     }
26 
27     constructor() public{
28         owner = msg.sender;
29         callerMap[owner] = true;
30     }
31 
32     // Fallback function deliberately left empty. It's primary use case
33     // is to top up the bank roll.
34     function () external payable {
35     }
36 
37     function kill() external onlyOwner {
38         selfdestruct(owner);
39     }
40 
41     function addCaller(address caller) public onlyOwner{
42         bool isCaller = callerMap[caller];
43         if (isCaller == false){
44             callerMap[caller] = true;
45         }
46     }
47 
48     function deleteCaller(address caller) external onlyOwner {
49         bool isCaller = callerMap[caller];
50         if (isCaller == true) {
51             callerMap[caller] = false;
52         }
53     }
54 
55     function addUserExp(address addr, uint256 amount) public onlyCaller{
56         uint exp = userExpPool[addr];
57         exp = exp + amount;
58         userExpPool[addr] = exp;
59     }
60 
61     function getUserExp(address addr) public view returns(uint256 exp){
62         return userExpPool[addr];
63     }
64 
65     function getVIPLevel(address user) public view returns (uint256 level) {
66         uint exp = userExpPool[user];
67 
68         if(exp >= 25 ether && exp < 125 ether){
69             level = 1;
70         } else if(exp >= 125 ether && exp < 250 ether){
71             level = 2;
72         } else if(exp >= 250 ether && exp < 1250 ether){
73             level = 3;
74         } else if(exp >= 1250 ether && exp < 2500 ether){
75             level = 4;
76         } else if(exp >= 2500 ether && exp < 12500 ether){
77             level = 5;
78         } else if(exp >= 12500 ether && exp < 25000 ether){
79             level = 6;
80         } else if(exp >= 25000 ether && exp < 125000 ether){
81             level = 7;
82         } else if(exp >= 125000 ether && exp < 250000 ether){
83             level = 8;
84         } else if(exp >= 250000 ether && exp < 1250000 ether){
85             level = 9;
86         } else if(exp >= 1250000 ether){
87             level = 10;
88         } else{
89             level = 0;
90         }
91 
92         return level;
93     }
94 
95     function getVIPBounusRate(address user) public view returns (uint256 rate){
96         uint level = getVIPLevel(user);
97         return level;
98     }
99 
100     // This function is used to bump up the jackpot fund. Cannot be used to lower it.
101     function increaseJackpot(uint increaseAmount) external onlyCaller {
102         require (increaseAmount <= address(this).balance, "Increase amount larger than balance.");
103         require (jackpotSize + increaseAmount <= address(this).balance, "Not enough funds.");
104         jackpotSize += uint128(increaseAmount);
105     }
106 
107     function payJackpotReward(address payable to) external onlyCaller{
108         to.transfer(jackpotSize);
109         jackpotSize = 0;
110     }
111 
112     function getJackpotSize() external view returns (uint256){
113         return jackpotSize;
114     }
115 
116     function increaseRankingReward(uint amount) public onlyCaller{
117         require (amount <= address(this).balance, "Increase amount larger than balance.");
118         require (rankingRewardSize + amount <= address(this).balance, "Not enough funds.");
119         rankingRewardSize += uint128(amount);
120     }
121 
122     function payRankingReward(address payable to) external onlyCaller {
123         uint128 prize = rankingRewardSize / 2;
124         rankingRewardSize = rankingRewardSize - prize;
125         if(to.send(prize)){
126             emit RankingRewardPayment(to, prize);
127         }
128     }
129 
130     function getRankingRewardSize() external view returns (uint128){
131         return rankingRewardSize;
132     }
133 }
134 
135 contract HalfRouletteEvents {
136     event Commit(uint commit); // 배팅
137     event Payment(address indexed gambler, uint amount, uint8 betMask, uint8 l, uint8 r, uint betAmount); // 결과 처리
138     event Refund(address indexed gambler, uint amount); // 결과 처리
139     event JackpotPayment(address indexed gambler, uint amount); // 잭팟
140     event VIPBenefit(address indexed gambler, uint amount); // VIP 보상
141     event InviterBenefit(address indexed inviter, address gambler, uint amount, uint betAmount); // 초대자 보상
142 }
143 
144 contract CryptoTycoonsDApp {
145     address payable public owner; // 게시자
146     address payable nextOwner;
147     address secretSigner;
148 
149     mapping(address => bool) public croupierMap; // 하우스 운영
150 
151     address payable public VIPLibraryAddress; // vip pool address
152 
153     modifier onlyOwner {
154         require(msg.sender == owner, "OnlyOwner methods called by non-owner.");
155         _;
156     }
157 
158     modifier onlyCroupier {
159         bool isCroupier = croupierMap[msg.sender];
160         require(isCroupier, "OnlyCroupier methods called by non-croupier.");
161         _;
162     }
163 
164     constructor() public {
165         owner = msg.sender;
166         croupierMap[msg.sender] = true;
167         secretSigner = msg.sender;
168     }
169 
170     function () external payable {}
171 
172     function approveNextOwner(address payable _nextOwner) external onlyOwner {
173         require(_nextOwner != owner, "Cannot approve current owner.");
174         nextOwner = _nextOwner;
175     }
176 
177     function acceptNextOwner() external {
178         require(msg.sender == nextOwner, "Can only accept preapproved new owner.");
179         owner = nextOwner;
180     }
181 
182     function setSecretSigner(address newSecretSigner) external onlyOwner {
183         secretSigner = newSecretSigner;
184     }
185 
186     function addCroupier(address newCroupier) external onlyOwner {
187         bool isCroupier = croupierMap[newCroupier];
188         if (isCroupier == false) {
189             croupierMap[newCroupier] = true;
190         }
191     }
192 
193     function deleteCroupier(address newCroupier) external onlyOwner {
194         bool isCroupier = croupierMap[newCroupier];
195         if (isCroupier == true) {
196             croupierMap[newCroupier] = false;
197         }
198     }
199 
200     function setVIPLibraryAddress(address payable addr) external onlyOwner {
201         VIPLibraryAddress = addr;
202     }
203 
204     function getMyAccuAmount() external view returns (uint) {
205         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
206         return vipLib.getUserExp(msg.sender);
207     }
208 
209     function getJackpotSize() external view returns (uint) {
210         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
211         return vipLib.getJackpotSize();
212     }
213 
214     function getRankingRewardSize() external view returns (uint128) {
215         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
216         return vipLib.getRankingRewardSize();
217     }
218 
219 }
220 
221 contract HalfRouletteStruct {
222     struct Bet {
223         uint amount; // 배팅 금액
224         uint8 betMask; // 배팅 정보
225         uint40 placeBlockNumber; // Block number of placeBet tx.
226         address payable gambler; // Address of a gambler, used to pay out winning bets.
227     }
228 }
229 
230 contract HalfRouletteConstant {
231     //    constant
232     // EVM BLOCKHASH opcode can query no further than 256 blocks into the
233     // past. Given that settleBet uses block hash of placeBet as one of
234     // complementary entropy sources, we cannot process bets older than this
235     // threshold. On rare occasions AceDice croupier may fail to invoke
236     // settleBet in this timespan due to technical issues or extreme Ethereum
237     // congestion; such bets can be refunded via invoking refundBet.
238     uint constant BET_EXPIRATION_BLOCKS = 250;
239 
240     uint constant HOUSE_EDGE_PERCENT = 1; // amount * 0.01
241     uint constant HOUSE_EDGE_MINIMUM_AMOUNT = 0.0004 ether; // 최소 houseEdge
242 
243     uint constant RANK_FUNDS_PERCENT = 7; // houseEdge * 0.12
244     uint constant INVITER_BENEFIT_PERCENT = 7; // houseEdge * 0.09
245 
246     uint constant MIN_BET = 0.01 ether; // 최소 배팅 금액
247     uint constant MAX_BET = 300000 ether; // 최대 배팅 금액
248     uint constant MIN_JACKPOT_BET = 0.1 ether;
249     uint constant JACKPOT_FEE = 0.001 ether;
250 
251     uint constant BASE_WIN_RATE = 100000;
252 }
253 
254 contract HalfRoulettePure is HalfRouletteConstant {
255 
256     function verifyBetMask(uint betMask) public pure {
257         bool verify;
258         assembly {
259             switch betMask
260             case 1 /* ODD */{verify := 1}
261             case 2 /* EVEN */{verify := 1}
262             case 4 /* LEFT */{verify := 1}
263             case 8 /* RIGHT */{verify := 1}
264             case 5 /* ODD | LEFT */{verify := 1}
265             case 9 /* ODD | RIGHT */{verify := 1}
266             case 6 /* EVEN | LEFT */{verify := 1}
267             case 10 /* EVEN | RIGHT */{verify := 1}
268             case 16 /* EQUAL */{verify := 1}
269         }
270         require(verify, "invalid betMask");
271     }
272 
273     function getRecoverSigner(uint40 commitLastBlock, uint commit, uint8 v, bytes32 r, bytes32 s) public pure returns (address) {
274         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
275         bytes memory message = abi.encodePacked(commitLastBlock, commit);
276         bytes32 messageHash = keccak256(abi.encodePacked(prefix, keccak256(message)));
277         return ecrecover(messageHash, v, r, s);
278     }
279 
280     function getWinRate(uint betMask) public pure returns (uint rate) {
281         // assembly 안에서는 constant 사용 불가
282         uint ODD_EVEN_RATE = 50000;
283         uint LEFT_RIGHT_RATE = 45833;
284         uint MIX_RATE = 22916;
285         uint EQUAL_RATE = 8333;
286         assembly {
287             switch betMask
288             case 1 /* ODD */{rate := ODD_EVEN_RATE}
289             case 2 /* EVEN */{rate := ODD_EVEN_RATE}
290             case 4 /* LEFT */{rate := LEFT_RIGHT_RATE}
291             case 8 /* RIGHT */{rate := LEFT_RIGHT_RATE}
292             case 5 /* ODD | LEFT */{rate := MIX_RATE}
293             case 9 /* ODD | RIGHT */{rate := MIX_RATE}
294             case 6 /* EVEN | LEFT */{rate := MIX_RATE}
295             case 10 /* EVEN | RIGHT */{rate := MIX_RATE}
296             case 16 /* EQUAL */{rate := EQUAL_RATE}
297         }
298     }
299 
300     function calcHouseEdge(uint amount) public pure returns (uint houseEdge) {
301         // 0.02
302         houseEdge = amount * HOUSE_EDGE_PERCENT / 100;
303         if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
304             houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
305         }
306     }
307 
308     function calcJackpotFee(uint amount) public pure returns (uint jackpotFee) {
309         // 0.001
310         if (amount >= MIN_JACKPOT_BET) {
311             jackpotFee = JACKPOT_FEE;
312         }
313     }
314 
315     function calcRankFundsFee(uint houseEdge) public pure returns (uint rankFundsFee) {
316         // 0.07
317         rankFundsFee = houseEdge * RANK_FUNDS_PERCENT / 100;
318     }
319 
320     function calcInviterBenefit(uint houseEdge) public pure returns (uint invitationFee) {
321         // 0.07
322         invitationFee = houseEdge * INVITER_BENEFIT_PERCENT / 100;
323     }
324 
325     function getWinAmount(uint betMask, uint amount) public pure returns (uint) {
326         uint houseEdge = calcHouseEdge(amount);
327         uint jackpotFee = calcJackpotFee(amount);
328         uint betAmount = amount - houseEdge - jackpotFee;
329         uint rate = getWinRate(betMask);
330         return betAmount * BASE_WIN_RATE / rate;
331     }
332 
333     function calcBetResult(uint betMask, bytes32 entropy) public pure returns (bool isWin, uint l, uint r)  {
334         uint v = uint(entropy);
335         l = (v % 12) + 1;
336         r = ((v >> 4) % 12) + 1;
337         uint mask = getResultMask(l, r);
338         isWin = (betMask & mask) == betMask;
339     }
340 
341     function getResultMask(uint l, uint r) public pure returns (uint mask) {
342         uint v1 = (l + r) % 2;
343         if (v1 == 0) {
344             mask = mask | 2;
345         } else {
346             mask = mask | 1;
347         }
348         if (l == r) {
349             mask = mask | 16;
350         } else if (l > r) {
351             mask = mask | 4;
352         } else {
353             mask = mask | 8;
354         }
355         return mask;
356     }
357 
358     function isJackpot(bytes32 entropy, uint amount) public pure returns (bool jackpot) {
359         return amount >= MIN_JACKPOT_BET && (uint(entropy) % 1000) == 0;
360     }
361 
362     function verifyCommit(address signer, uint40 commitLastBlock, uint commit, uint8 v, bytes32 r, bytes32 s) internal pure {
363         address recoverSigner = getRecoverSigner(commitLastBlock, commit, v, r, s);
364         require(recoverSigner == signer, "failed different signer");
365     }
366 
367     function startOfDay(uint timestamp) internal pure returns (uint64) {
368         return uint64(timestamp - (timestamp % 1 days));
369     }
370 
371 }
372 
373 contract HalfRoulette is CryptoTycoonsDApp, HalfRouletteEvents, HalfRouletteStruct, HalfRouletteConstant, HalfRoulettePure {
374     uint128 public lockedInBets;
375 
376     // Adjustable max bet profit. Used to cap bets against dynamic odds.
377     uint public maxProfit = 10 ether;
378 
379     // global variable
380     mapping(uint => Bet) public bets;
381     mapping(address => address payable) public inviterMap;
382 
383     function () external payable {}
384 
385     function kill() external onlyOwner {
386         require(lockedInBets == 0, "All bets should be processed (settled or refunded) before self-destruct.");
387         selfdestruct(address(owner));
388     }
389 
390     function setMaxProfit(uint _maxProfit) external onlyOwner {
391         require(_maxProfit < MAX_BET, "maxProfit should be a sane number.");
392         maxProfit = _maxProfit;
393     }
394 
395     function placeBet(uint8 betMask, uint commitLastBlock, uint commit, uint8 v, bytes32 r, bytes32 s) public payable {
396         Bet storage bet = bets[commit];
397         require(bet.gambler == address(0), "Bet should be in a 'clean' state.");
398 
399         // amount checked
400         uint amount = msg.value;
401         require(amount >= MIN_BET, 'failed amount >= MIN_BET');
402         require(amount <= MAX_BET, "failed amount <= MAX_BET");
403         // allow bet check
404         verifyBetMask(betMask);
405         // rand seed check
406         verifyCommit(secretSigner, uint40(commitLastBlock), commit, v, r, s);
407 
408         // house balance check
409         uint winAmount = getWinAmount(betMask, amount);
410         require(winAmount <= amount + maxProfit, "maxProfit limit violation.");
411         lockedInBets += uint128(winAmount);
412         require(lockedInBets <= address(this).balance, "Cannot afford to lose this bet.");
413 
414         // save
415         emit Commit(commit);
416         bet.gambler = msg.sender;
417         bet.amount = amount;
418         bet.betMask = betMask;
419         bet.placeBlockNumber = uint40(block.number);
420     }
421 
422     function placeBetWithInviter(uint8 betMask, uint commitLastBlock, uint commit, uint8 v, bytes32 r, bytes32 s, address payable inviter) external payable {
423         require(inviter != address(0), "inviter != address (0)");
424         address preInviter = inviterMap[msg.sender];
425         if (preInviter == address(0)) {
426             inviterMap[msg.sender] = inviter;
427         }
428         placeBet(betMask, commitLastBlock, commit, v, r, s);
429     }
430 
431     function settleBet(uint reveal, bytes32 blockHash) external onlyCroupier {
432         uint commit = uint(keccak256(abi.encodePacked(reveal)));
433 
434         Bet storage bet = bets[commit];
435         uint placeBlockNumber = bet.placeBlockNumber;
436 
437         // Check that bet has not expired yet (see comment to BET_EXPIRATION_BLOCKS).
438         require(block.number > placeBlockNumber, "settleBet in the same block as placeBet, or before.");
439         require(block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
440         require(blockhash(placeBlockNumber) == blockHash);
441 
442         // Settle bet using reveal and blockHash as entropy sources.
443         settleBetCommon(bet, reveal, blockHash);
444     }
445 
446     function processVIPBenefit(address gambler, uint amount) internal returns (uint benefitAmount) {
447         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
448         uint rate = vipLib.getVIPBounusRate(gambler);
449         if (rate > 0) {
450             benefitAmount = amount * rate / 10000;
451             emit VIPBenefit(gambler, benefitAmount);
452         }
453         vipLib.addUserExp(gambler, amount);
454     }
455 
456     function processJackpot(address payable gambler, bytes32 entropy, uint amount) internal returns (uint benefitAmount) {
457         if (isJackpot(entropy, amount)) {
458             CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
459             uint jackpotSize = vipLib.getJackpotSize();
460             vipLib.payJackpotReward(gambler);
461             benefitAmount = jackpotSize;
462             emit JackpotPayment(gambler, benefitAmount);
463         }
464     }
465 
466     function processRoulette(address gambler, uint betMask, bytes32 entropy, uint amount) internal returns (uint benefitAmount) {
467         uint winAmount = getWinAmount(betMask, amount);
468         lockedInBets -= uint128(winAmount);
469 
470         (bool isWin, uint l, uint r) = calcBetResult(betMask, entropy);
471         benefitAmount = isWin ? winAmount : 0;
472 
473         emit Payment(gambler, benefitAmount, uint8(betMask), uint8(l), uint8(r), amount);
474     }
475 
476     function processInviterBenefit(address gambler, uint betAmount) internal {
477         address payable inviter = inviterMap[gambler];
478         if (inviter != address(0)) {
479             uint houseEdge = calcHouseEdge(betAmount);
480             uint inviterBenefit = calcInviterBenefit(houseEdge);
481             if (inviter.send(inviterBenefit)) {
482                 emit InviterBenefit(inviter, gambler, inviterBenefit, betAmount);
483             }
484         }
485     }
486 
487     function transferCryptoTycoonsFee(uint amount) internal {
488         uint houseEdge = calcHouseEdge(amount);
489         uint jackpotFee = calcJackpotFee(amount);
490         uint rankFundFee = calcRankFundsFee(houseEdge);
491 
492         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
493         VIPLibraryAddress.transfer(rankFundFee + jackpotFee);
494         vipLib.increaseRankingReward(rankFundFee);
495         if (jackpotFee > 0) {
496             vipLib.increaseJackpot(jackpotFee);
497         }
498     }
499 
500     function settleBetCommon(Bet storage bet, uint reveal, bytes32 entropyBlockHash) internal {
501         uint amount = bet.amount;
502 
503         // Check that bet is in 'active' state.
504         require(amount != 0, "Bet should be in an 'active' state");
505         bet.amount = 0;
506 
507         // The RNG - combine "reveal" and blockhash of placeBet using Keccak256. Miners
508         // are not aware of "reveal" and cannot deduce it from "commit" (as Keccak256
509         // preimage is intractable), and house is unable to alter the "reveal" after
510         // placeBet have been mined (as Keccak256 collision finding is also intractable).
511         bytes32 entropy = keccak256(abi.encodePacked(reveal, entropyBlockHash));
512 
513         transferCryptoTycoonsFee(amount);
514 
515         uint payout = 0;
516         payout += processVIPBenefit(bet.gambler, amount);
517         payout += processRoulette(bet.gambler, bet.betMask, entropy, amount);
518         processJackpot(bet.gambler, entropy, amount);
519         processInviterBenefit(bet.gambler, amount);
520 
521         bet.gambler.transfer(payout);
522     }
523 
524     // Refund transaction - return the bet amount of a roll that was not processed in a due timeframe.
525     // Processing such blocks is not possible due to EVM limitations (see BET_EXPIRATION_BLOCKS comment above for details).
526     // In case you ever find yourself in a situation like this, just contact the {} support, however nothing precludes you from invoking this method yourself.
527     function refundBet(uint commit) external {
528         // Check that bet is in 'active' state.
529         Bet storage bet = bets[commit];
530         uint amount = bet.amount;
531 
532         require(amount != 0, "Bet should be in an 'active' state");
533 
534         // Check that bet has already expired.
535         require(block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
536 
537         // Move bet into 'processed' state, release funds.
538         bet.amount = 0;
539 
540         uint winAmount = getWinAmount(bet.betMask, amount);
541         lockedInBets -= uint128(winAmount);
542 
543         // Send the refund.
544         bet.gambler.transfer(amount);
545 
546         emit Refund(bet.gambler, amount);
547     }
548 
549     // Funds withdrawal to cover costs of HalfRoulette operation.
550     function withdrawFunds(address payable beneficiary, uint withdrawAmount) external onlyOwner {
551         require(withdrawAmount <= address(this).balance, "Increase amount larger than balance.");
552         require(lockedInBets + withdrawAmount <= address(this).balance, "Not enough funds.");
553         beneficiary.transfer(withdrawAmount);
554     }
555 
556 }