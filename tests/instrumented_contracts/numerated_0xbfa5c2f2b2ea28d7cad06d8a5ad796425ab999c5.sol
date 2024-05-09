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
284         uint MIX_ODD_RATE = 25000;
285         uint MIX_EVEN_RATE = 20833;
286         uint EQUAL_RATE = 8333;
287         assembly {
288             switch betMask
289             case 1 /* ODD */{rate := ODD_EVEN_RATE}
290             case 2 /* EVEN */{rate := ODD_EVEN_RATE}
291             case 4 /* LEFT */{rate := LEFT_RIGHT_RATE}
292             case 8 /* RIGHT */{rate := LEFT_RIGHT_RATE}
293             case 5 /* ODD | LEFT */{rate := MIX_ODD_RATE}
294             case 9 /* ODD | RIGHT */{rate := MIX_ODD_RATE}
295             case 6 /* EVEN | LEFT */{rate := MIX_EVEN_RATE}
296             case 10 /* EVEN | RIGHT */{rate := MIX_EVEN_RATE}
297             case 16 /* EQUAL */{rate := EQUAL_RATE}
298         }
299     }
300 
301     function calcHouseEdge(uint amount) public pure returns (uint houseEdge) {
302         // 0.02
303         houseEdge = amount * HOUSE_EDGE_PERCENT / 100;
304         if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
305             houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
306         }
307     }
308 
309     function calcJackpotFee(uint amount) public pure returns (uint jackpotFee) {
310         // 0.001
311         if (amount >= MIN_JACKPOT_BET) {
312             jackpotFee = JACKPOT_FEE;
313         }
314     }
315 
316     function calcRankFundsFee(uint houseEdge) public pure returns (uint rankFundsFee) {
317         // 0.07
318         rankFundsFee = houseEdge * RANK_FUNDS_PERCENT / 100;
319     }
320 
321     function calcInviterBenefit(uint houseEdge) public pure returns (uint invitationFee) {
322         // 0.07
323         invitationFee = houseEdge * INVITER_BENEFIT_PERCENT / 100;
324     }
325 
326     function getWinAmount(uint betMask, uint amount) public pure returns (uint) {
327         uint houseEdge = calcHouseEdge(amount);
328         uint jackpotFee = calcJackpotFee(amount);
329         uint betAmount = amount - houseEdge - jackpotFee;
330         uint rate = getWinRate(betMask);
331         return betAmount * BASE_WIN_RATE / rate;
332     }
333 
334     function calcBetResult(uint betMask, bytes32 entropy) public pure returns (bool isWin, uint l, uint r)  {
335         uint v = uint(entropy);
336         l = (v % 12) + 1;
337         r = ((v >> 4) % 12) + 1;
338         uint mask = getResultMask(l, r);
339         isWin = (betMask & mask) == betMask;
340     }
341 
342     function getResultMask(uint l, uint r) public pure returns (uint mask) {
343         uint v1 = (l + r) % 2;
344         if (v1 == 0) {
345             mask = mask | 2;
346         } else {
347             mask = mask | 1;
348         }
349         if (l == r) {
350             mask = mask | 16;
351         } else if (l > r) {
352             mask = mask | 4;
353         } else {
354             mask = mask | 8;
355         }
356         return mask;
357     }
358 
359     function isJackpot(bytes32 entropy, uint amount) public pure returns (bool jackpot) {
360         return amount >= MIN_JACKPOT_BET && (uint(entropy) % 1000) == 0;
361     }
362 
363     function verifyCommit(address signer, uint40 commitLastBlock, uint commit, uint8 v, bytes32 r, bytes32 s) internal pure {
364         address recoverSigner = getRecoverSigner(commitLastBlock, commit, v, r, s);
365         require(recoverSigner == signer, "failed different signer");
366     }
367 
368     function startOfDay(uint timestamp) internal pure returns (uint64) {
369         return uint64(timestamp - (timestamp % 1 days));
370     }
371 
372 }
373 
374 contract HalfRoulette is CryptoTycoonsDApp, HalfRouletteEvents, HalfRouletteStruct, HalfRouletteConstant, HalfRoulettePure {
375     uint128 public lockedInBets;
376 
377     // Adjustable max bet profit. Used to cap bets against dynamic odds.
378     uint public maxProfit = 10 ether;
379 
380     // global variable
381     mapping(uint => Bet) public bets;
382     mapping(address => address payable) public inviterMap;
383 
384     function () external payable {}
385 
386     function kill() external onlyOwner {
387         require(lockedInBets == 0, "All bets should be processed (settled or refunded) before self-destruct.");
388         selfdestruct(address(owner));
389     }
390 
391     function setMaxProfit(uint _maxProfit) external onlyOwner {
392         require(_maxProfit < MAX_BET, "maxProfit should be a sane number.");
393         maxProfit = _maxProfit;
394     }
395 
396     function placeBet(uint8 betMask, uint commitLastBlock, uint commit, uint8 v, bytes32 r, bytes32 s) public payable {
397         Bet storage bet = bets[commit];
398         require(bet.gambler == address(0), "Bet should be in a 'clean' state.");
399 
400         // amount checked
401         uint amount = msg.value;
402         require(amount >= MIN_BET, 'failed amount >= MIN_BET');
403         require(amount <= MAX_BET, "failed amount <= MAX_BET");
404         // allow bet check
405         verifyBetMask(betMask);
406         // rand seed check
407         verifyCommit(secretSigner, uint40(commitLastBlock), commit, v, r, s);
408 
409         // house balance check
410         uint winAmount = getWinAmount(betMask, amount);
411         require(winAmount <= amount + maxProfit, "maxProfit limit violation.");
412         lockedInBets += uint128(winAmount);
413         require(lockedInBets <= address(this).balance, "Cannot afford to lose this bet.");
414 
415         // save
416         emit Commit(commit);
417         bet.gambler = msg.sender;
418         bet.amount = amount;
419         bet.betMask = betMask;
420         bet.placeBlockNumber = uint40(block.number);
421     }
422 
423     function placeBetWithInviter(uint8 betMask, uint commitLastBlock, uint commit, uint8 v, bytes32 r, bytes32 s, address payable inviter) external payable {
424         require(inviter != address(0), "inviter != address (0)");
425         address preInviter = inviterMap[msg.sender];
426         if (preInviter == address(0)) {
427             inviterMap[msg.sender] = inviter;
428         }
429         placeBet(betMask, commitLastBlock, commit, v, r, s);
430     }
431 
432     function settleBet(uint reveal, bytes32 blockHash) external onlyCroupier {
433         uint commit = uint(keccak256(abi.encodePacked(reveal)));
434 
435         Bet storage bet = bets[commit];
436         uint placeBlockNumber = bet.placeBlockNumber;
437 
438         // Check that bet has not expired yet (see comment to BET_EXPIRATION_BLOCKS).
439         require(block.number > placeBlockNumber, "settleBet in the same block as placeBet, or before.");
440         require(block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
441         require(blockhash(placeBlockNumber) == blockHash);
442 
443         // Settle bet using reveal and blockHash as entropy sources.
444         settleBetCommon(bet, reveal, blockHash);
445     }
446 
447     function processVIPBenefit(address gambler, uint amount) internal returns (uint benefitAmount) {
448         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
449         uint rate = vipLib.getVIPBounusRate(gambler);
450         if (rate > 0) {
451             benefitAmount = amount * rate / 10000;
452             emit VIPBenefit(gambler, benefitAmount);
453         }
454         vipLib.addUserExp(gambler, amount);
455     }
456 
457     function processJackpot(address payable gambler, bytes32 entropy, uint amount) internal returns (uint benefitAmount) {
458         if (isJackpot(entropy, amount)) {
459             CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
460             uint jackpotSize = vipLib.getJackpotSize();
461             vipLib.payJackpotReward(gambler);
462             benefitAmount = jackpotSize;
463             emit JackpotPayment(gambler, benefitAmount);
464         }
465     }
466 
467     function processRoulette(address gambler, uint betMask, bytes32 entropy, uint amount) internal returns (uint benefitAmount) {
468         uint winAmount = getWinAmount(betMask, amount);
469         lockedInBets -= uint128(winAmount);
470 
471         (bool isWin, uint l, uint r) = calcBetResult(betMask, entropy);
472         benefitAmount = isWin ? winAmount : 0;
473 
474         emit Payment(gambler, benefitAmount, uint8(betMask), uint8(l), uint8(r), amount);
475     }
476 
477     function processInviterBenefit(address gambler, uint betAmount) internal {
478         address payable inviter = inviterMap[gambler];
479         if (inviter != address(0)) {
480             uint houseEdge = calcHouseEdge(betAmount);
481             uint inviterBenefit = calcInviterBenefit(houseEdge);
482             if (inviter.send(inviterBenefit)) {
483                 emit InviterBenefit(inviter, gambler, inviterBenefit, betAmount);
484             }
485         }
486     }
487 
488     function transferCryptoTycoonsFee(uint amount) internal {
489         uint houseEdge = calcHouseEdge(amount);
490         uint jackpotFee = calcJackpotFee(amount);
491         uint rankFundFee = calcRankFundsFee(houseEdge);
492 
493         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
494         VIPLibraryAddress.transfer(rankFundFee + jackpotFee);
495         vipLib.increaseRankingReward(rankFundFee);
496         if (jackpotFee > 0) {
497             vipLib.increaseJackpot(jackpotFee);
498         }
499     }
500 
501     function settleBetCommon(Bet storage bet, uint reveal, bytes32 entropyBlockHash) internal {
502         uint amount = bet.amount;
503 
504         // Check that bet is in 'active' state.
505         require(amount != 0, "Bet should be in an 'active' state");
506         bet.amount = 0;
507 
508         // The RNG - combine "reveal" and blockhash of placeBet using Keccak256. Miners
509         // are not aware of "reveal" and cannot deduce it from "commit" (as Keccak256
510         // preimage is intractable), and house is unable to alter the "reveal" after
511         // placeBet have been mined (as Keccak256 collision finding is also intractable).
512         bytes32 entropy = keccak256(abi.encodePacked(reveal, entropyBlockHash));
513 
514         transferCryptoTycoonsFee(amount);
515 
516         uint payout = 0;
517         payout += processVIPBenefit(bet.gambler, amount);
518         payout += processRoulette(bet.gambler, bet.betMask, entropy, amount);
519         processJackpot(bet.gambler, entropy, amount);
520         processInviterBenefit(bet.gambler, amount);
521 
522         bet.gambler.transfer(payout);
523     }
524 
525     // Refund transaction - return the bet amount of a roll that was not processed in a due timeframe.
526     // Processing such blocks is not possible due to EVM limitations (see BET_EXPIRATION_BLOCKS comment above for details).
527     // In case you ever find yourself in a situation like this, just contact the {} support, however nothing precludes you from invoking this method yourself.
528     function refundBet(uint commit) external {
529         // Check that bet is in 'active' state.
530         Bet storage bet = bets[commit];
531         uint amount = bet.amount;
532 
533         require(amount != 0, "Bet should be in an 'active' state");
534 
535         // Check that bet has already expired.
536         require(block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
537 
538         // Move bet into 'processed' state, release funds.
539         bet.amount = 0;
540 
541         uint winAmount = getWinAmount(bet.betMask, amount);
542         lockedInBets -= uint128(winAmount);
543 
544         // Send the refund.
545         bet.gambler.transfer(amount);
546 
547         emit Refund(bet.gambler, amount);
548     }
549 
550     // Funds withdrawal to cover costs of HalfRoulette operation.
551     function withdrawFunds(address payable beneficiary, uint withdrawAmount) external onlyOwner {
552         require(withdrawAmount <= address(this).balance, "Increase amount larger than balance.");
553         require(lockedInBets + withdrawAmount <= address(this).balance, "Not enough funds.");
554         beneficiary.transfer(withdrawAmount);
555     }
556 
557 }