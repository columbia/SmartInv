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
134 contract CryptoTycoonsConstants{
135     /// *** Constants section
136 
137     // Each bet is deducted 1% in favour of the house, but no less than some minimum.
138     // The lower bound is dictated by gas costs of the settleBet transaction, providing
139     // headroom for up to 10 Gwei prices.
140     uint constant HOUSE_EDGE_PERCENT = 1;
141     uint constant RANK_FUNDS_PERCENT = 7;
142     uint constant INVITER_BENEFIT_PERCENT = 7;
143     uint constant HOUSE_EDGE_MINIMUM_AMOUNT = 0.0004 ether;
144 
145     // Bets lower than this amount do not participate in jackpot rolls (and are
146     // not deducted JACKPOT_FEE).
147     uint constant MIN_JACKPOT_BET = 0.1 ether;
148 
149     // Chance to win jackpot (currently 0.1%) and fee deducted into jackpot fund.
150     uint constant JACKPOT_MODULO = 1000;
151     uint constant JACKPOT_FEE = 0.001 ether;
152 
153     // There is minimum and maximum bets.
154     uint constant MIN_BET = 0.01 ether;
155     uint constant MAX_AMOUNT = 10 ether;
156 
157     // Standard contract ownership transfer.
158     address payable public owner;
159     address payable private nextOwner;
160 
161     // Croupier account.
162     mapping (address => bool ) croupierMap;
163 
164     // Adjustable max bet profit. Used to cap bets against dynamic odds.
165     uint public maxProfit;
166 
167     address payable public VIPLibraryAddress;
168 
169     // The address corresponding to a private key used to sign placeBet commits.
170     address public secretSigner;
171 
172     // Events that are issued to make statistic recovery easier.
173     event FailedPayment(address indexed beneficiary, uint amount);
174     event VIPPayback(address indexed beneficiary, uint amount);
175     event WithdrawFunds(address indexed beneficiary, uint amount);
176 
177     constructor (uint _maxProfit) public {
178         owner = msg.sender;
179         secretSigner = owner;
180         maxProfit = _maxProfit;
181         croupierMap[owner] = true;
182     }
183 
184     // Standard modifier on methods invokable only by contract owner.
185     modifier onlyOwner {
186         require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
187         _;
188     }
189 
190     // Standard modifier on methods invokable only by contract owner.
191     modifier onlyCroupier {
192         bool isCroupier = croupierMap[msg.sender];
193         require(isCroupier, "OnlyCroupier methods called by non-croupier.");
194         _;
195     }
196 
197 
198     // Fallback function deliberately left empty. It's primary use case
199     // is to top up the bank roll.
200     function () external payable {
201 
202     }
203 
204     // Standard contract ownership transfer implementation,
205     function approveNextOwner(address payable _nextOwner) external onlyOwner {
206         require (_nextOwner != owner, "Cannot approve current owner.");
207         nextOwner = _nextOwner;
208     }
209 
210     function acceptNextOwner() external {
211         require (msg.sender == nextOwner, "Can only accept preapproved new owner.");
212         owner = nextOwner;
213     }
214 
215     // See comment for "secretSigner" variable.
216     function setSecretSigner(address newSecretSigner) external onlyOwner {
217         secretSigner = newSecretSigner;
218     }
219 
220     function getSecretSigner() external onlyOwner view returns(address){
221         return secretSigner;
222     }
223 
224     function addCroupier(address newCroupier) external onlyOwner {
225         bool isCroupier = croupierMap[newCroupier];
226         if (isCroupier == false) {
227             croupierMap[newCroupier] = true;
228         }
229     }
230     
231     function deleteCroupier(address newCroupier) external onlyOwner {
232         bool isCroupier = croupierMap[newCroupier];
233         if (isCroupier == true) {
234             croupierMap[newCroupier] = false;
235         }
236     }
237 
238     function setVIPLibraryAddress(address payable addr) external onlyOwner{
239         VIPLibraryAddress = addr;
240     }
241 
242     // Change max bet reward. Setting this to zero effectively disables betting.
243     function setMaxProfit(uint _maxProfit) public onlyOwner {
244         require (_maxProfit < MAX_AMOUNT, "maxProfit should be a sane number.");
245         maxProfit = _maxProfit;
246     }
247     
248     // Funds withdrawal to cover costs of AceDice operation.
249     function withdrawFunds(address payable beneficiary, uint withdrawAmount) external onlyOwner {
250         require (withdrawAmount <= address(this).balance, "Increase amount larger than balance.");
251         if (beneficiary.send(withdrawAmount)){
252             emit WithdrawFunds(beneficiary, withdrawAmount);
253         }
254     }
255 
256     function kill() external onlyOwner {
257         // require (lockedInBets == 0, "All bets should be processed (settled or refunded) before self-destruct.");
258         selfdestruct(owner);
259     }
260 
261     function thisBalance() public view returns(uint) {
262         return address(this).balance;
263     }
264 
265     function payTodayReward(address payable to) external onlyOwner {
266         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
267         vipLib.payRankingReward(to);
268     }
269 
270     function getRankingRewardSize() external view returns (uint128) {
271         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
272         return vipLib.getRankingRewardSize();
273     }
274         
275     function handleVIPPaybackAndExp(CryptoTycoonsVIPLib vipLib, address payable gambler, uint amount) internal returns(uint vipPayback) {
276         // CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
277         vipLib.addUserExp(gambler, amount);
278 
279         uint rate = vipLib.getVIPBounusRate(gambler);
280 
281         if (rate <= 0)
282             return 0;
283 
284         vipPayback = amount * rate / 10000;
285         if(vipPayback > 0){
286             emit VIPPayback(gambler, vipPayback);
287         }
288     }
289 
290     function increaseRankingFund(CryptoTycoonsVIPLib vipLib, uint amount) internal{
291         uint rankingFunds = uint128(amount * HOUSE_EDGE_PERCENT / 100 * RANK_FUNDS_PERCENT /100);
292         // uint128 rankingRewardFee = uint128(amount * HOUSE_EDGE_PERCENT / 100 * 9 /100);
293         VIPLibraryAddress.transfer(rankingFunds);
294         vipLib.increaseRankingReward(rankingFunds);
295     }
296 
297     function getMyAccuAmount() external view returns (uint){
298         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
299         return vipLib.getUserExp(msg.sender);
300     }
301 
302     function getJackpotSize() external view returns (uint){
303         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
304         return vipLib.getJackpotSize();
305     }
306    
307     function verifyCommit(uint commit, uint8 v, bytes32 r, bytes32 s) internal view {
308         // Check that commit is valid - it has not expired and its signature is valid.
309         // require (block.number <= commitLastBlock, "Commit has expired.");
310         //bytes32 signatureHash = keccak256(abi.encodePacked(commitLastBlock, commit));
311         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
312         bytes memory message = abi.encodePacked(commit);
313         bytes32 messageHash = keccak256(abi.encodePacked(prefix, keccak256(message)));
314         require (secretSigner == ecrecover(messageHash, v, r, s), "ECDSA signature is not valid.");
315     }
316 
317     function calcHouseEdge(uint amount) public pure returns (uint houseEdge) {
318         // 0.02
319         houseEdge = amount * HOUSE_EDGE_PERCENT / 100;
320         if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
321             houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
322         }
323     }
324 
325     function calcJackpotFee(uint amount) internal pure returns (uint jackpotFee) {
326         // 0.001
327         if (amount >= MIN_JACKPOT_BET) {
328             jackpotFee = JACKPOT_FEE;
329         }
330     }
331 
332     function calcRankFundsFee(uint amount) internal pure returns (uint rankFundsFee) {
333         // 0.01 * 0.07
334         rankFundsFee = amount * RANK_FUNDS_PERCENT / 10000;
335     }
336 
337     function calcInviterBenefit(uint amount) internal pure returns (uint invitationFee) {
338         // 0.01 * 0.07
339         invitationFee = amount * INVITER_BENEFIT_PERCENT / 10000;
340     }
341 
342     function processBet(
343         uint betMask, uint reveal, 
344         uint8 v, bytes32 r, bytes32 s, address payable inviter) 
345     external payable;
346 }
347 contract HalfRoulette is CryptoTycoonsConstants(10 ether) {
348 
349     uint constant BASE_WIN_RATE = 100000;
350 
351     event Payment(address indexed gambler, uint amount, uint8 betMask, uint8 l, uint8 r, uint betAmount);
352     event JackpotPayment(address indexed gambler, uint amount); 
353 
354     function processBet(
355         uint betMask, uint reveal, 
356         uint8 v, bytes32 r, bytes32 s, address payable inviter) 
357         external payable {
358 
359         address payable gambler = msg.sender;
360 
361         // amount checked
362         uint amount = msg.value;
363         // require (modulo > 1 && modulo <= MAX_MODULO, "Modulo should be within range.");
364         require (amount >= MIN_BET && amount <= MAX_AMOUNT, "Amount should be within range.");
365         // allow bet check
366         verifyBetMask(betMask);
367         if (inviter != address(0)){
368             require(gambler != inviter, "cannot invite myself");
369         }
370 
371         uint commit = uint(keccak256(abi.encodePacked(reveal)));
372         verifyCommit(commit, v, r, s);
373 
374         // house balance check
375         uint winAmount = getWinAmount(betMask, amount);
376         require(winAmount <= amount + maxProfit, "maxProfit limit violation.");
377         require(winAmount <= address(this).balance, "Cannot afford to lose this bet.");
378 
379         // The RNG - combine "reveal" and blockhash of placeBet using Keccak256. Miners
380         // are not aware of "reveal" and cannot deduce it from "commit" (as Keccak256
381         // preimage is intractable), and house is unable to alter the "reveal" after
382         // placeBet have been mined (as Keccak256 collision finding is also intractable).
383         bytes32 entropy = keccak256(abi.encodePacked(reveal, blockhash(block.number)));
384 
385         
386         uint payout = 0;
387         payout += transferVIPContractFee(gambler, inviter, amount);
388         // 5. roulette betting reward
389         payout += processRoulette(gambler, betMask, entropy, amount);
390         gambler.transfer(payout);
391         // 7. jacpoet reward
392         processJackpot(gambler, entropy, amount);
393     }
394 
395     function transferVIPContractFee(
396         address payable gambler, address payable inviter, uint amount) 
397             internal returns(uint vipPayback) {
398         uint jackpotFee = calcJackpotFee(amount);
399         uint rankFundFee = calcRankFundsFee(amount);
400 
401         // 1. increate vip exp
402         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
403         vipPayback = handleVIPPaybackAndExp(vipLib, gambler, amount);
404 
405         // 2. process today's ranking fee
406         VIPLibraryAddress.transfer(rankFundFee + jackpotFee);
407         vipLib.increaseRankingReward(rankFundFee);
408         if (jackpotFee > 0) {
409             vipLib.increaseJackpot(jackpotFee);
410         }
411 
412         // 4. inviter profit
413         if(inviter != address(0)){
414             // pay 7% of house edge to inviter
415             inviter.transfer(amount * HOUSE_EDGE_PERCENT / 100 * 7 /100);
416         }
417     }
418 
419 
420     function processJackpot(address payable gambler, bytes32 entropy, uint amount) internal returns (uint benefitAmount) {
421         if (isJackpot(entropy, amount)) {
422             CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
423             uint jackpotSize = vipLib.getJackpotSize();
424             vipLib.payJackpotReward(gambler);
425             benefitAmount = jackpotSize;
426             emit JackpotPayment(gambler, benefitAmount);
427         }
428     }
429 
430     function processRoulette(address gambler, uint betMask, bytes32 entropy, uint amount) internal returns (uint benefitAmount) {
431         uint winAmount = getWinAmount(betMask, amount);
432 
433         (bool isWin, uint l, uint r) = calcBetResult(betMask, entropy);
434         benefitAmount = isWin ? winAmount : 0;
435 
436         emit Payment(gambler, benefitAmount, uint8(betMask), uint8(l), uint8(r), amount);
437     }
438 
439     function verifyBetMask(uint betMask) public pure {
440         bool verify;
441         assembly {
442             switch betMask
443             case 1 /* ODD */{verify := 1}
444             case 2 /* EVEN */{verify := 1}
445             case 4 /* LEFT */{verify := 1}
446             case 8 /* RIGHT */{verify := 1}
447             case 5 /* ODD | LEFT */{verify := 1}
448             case 9 /* ODD | RIGHT */{verify := 1}
449             case 6 /* EVEN | LEFT */{verify := 1}
450             case 10 /* EVEN | RIGHT */{verify := 1}
451             case 16 /* EQUAL */{verify := 1}
452         }
453         require(verify, "invalid betMask");
454     }
455 
456     function getWinRate(uint betMask) public pure returns (uint rate) {
457         // assembly 안에서는 constant 사용 불가
458         uint ODD_EVEN_RATE = 50000;
459         uint LEFT_RIGHT_RATE = 45833;
460         uint MIX_ODD_RATE = 25000;
461         uint MIX_EVEN_RATE = 20833;
462         uint EQUAL_RATE = 8333;
463         assembly {
464             switch betMask
465             case 1 /* ODD */{rate := ODD_EVEN_RATE}
466             case 2 /* EVEN */{rate := ODD_EVEN_RATE}
467             case 4 /* LEFT */{rate := LEFT_RIGHT_RATE}
468             case 8 /* RIGHT */{rate := LEFT_RIGHT_RATE}
469             case 5 /* ODD | LEFT */{rate := MIX_ODD_RATE}
470             case 9 /* ODD | RIGHT */{rate := MIX_ODD_RATE}
471             case 6 /* EVEN | LEFT */{rate := MIX_EVEN_RATE}
472             case 10 /* EVEN | RIGHT */{rate := MIX_EVEN_RATE}
473             case 16 /* EQUAL */{rate := EQUAL_RATE}
474         }
475     }
476 
477     function getWinAmount(uint betMask, uint amount) public pure returns (uint) {
478         uint houseEdge = calcHouseEdge(amount);
479         uint jackpotFee = calcJackpotFee(amount);
480         uint betAmount = amount - houseEdge - jackpotFee;
481         uint rate = getWinRate(betMask);
482         return betAmount * BASE_WIN_RATE / rate;
483     }
484 
485     function calcBetResult(uint betMask, bytes32 entropy) public pure returns (bool isWin, uint l, uint r)  {
486         uint v = uint(entropy);
487         l = (v % 12) + 1;
488         r = ((v >> 4) % 12) + 1;
489         uint mask = getResultMask(l, r);
490         isWin = (betMask & mask) == betMask;
491     }
492 
493     function getResultMask(uint l, uint r) public pure returns (uint mask) {
494         uint v1 = (l + r) % 2;
495         if (v1 == 0) {
496             mask = mask | 2;
497         } else {
498             mask = mask | 1;
499         }
500         if (l == r) {
501             mask = mask | 16;
502         } else if (l > r) {
503             mask = mask | 4;
504         } else {
505             mask = mask | 8;
506         }
507         return mask;
508     }
509 
510     function isJackpot(bytes32 entropy, uint amount) public pure returns (bool jackpot) {
511         return amount >= MIN_JACKPOT_BET && (uint(entropy) % 1000) == 0;
512     }
513 }