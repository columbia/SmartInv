1 // solium-disable linebreak-style
2 pragma solidity ^0.5.0;
3 
4 contract CryptoTycoonsVIPLib{
5     
6     address payable public owner;
7     
8     // Accumulated jackpot fund.
9     uint128 public jackpotSize;
10     uint128 public rankingRewardSize;
11     
12     mapping (address => uint) userExpPool;
13     mapping (address => bool) public callerMap;
14 
15     event RankingRewardPayment(address indexed beneficiary, uint amount);
16 
17     modifier onlyOwner {
18         require(msg.sender == owner, "OnlyOwner methods called by non-owner.");
19         _;
20     }
21 
22     modifier onlyCaller {
23         bool isCaller = callerMap[msg.sender];
24         require(isCaller, "onlyCaller methods called by non-caller.");
25         _;
26     }
27 
28     constructor() public{
29         owner = msg.sender;
30         callerMap[owner] = true;
31     }
32 
33     // Fallback function deliberately left empty. It's primary use case
34     // is to top up the bank roll.
35     function () external payable {
36     }
37 
38     function kill() external onlyOwner {
39         selfdestruct(owner);
40     }
41 
42     function addCaller(address caller) public onlyOwner{
43         bool isCaller = callerMap[caller];
44         if (isCaller == false){
45             callerMap[caller] = true;
46         }
47     }
48 
49     function deleteCaller(address caller) external onlyOwner {
50         bool isCaller = callerMap[caller];
51         if (isCaller == true) {
52             callerMap[caller] = false;
53         }
54     }
55 
56     function addUserExp(address addr, uint256 amount) public onlyCaller{
57         uint exp = userExpPool[addr];
58         exp = exp + amount;
59         userExpPool[addr] = exp;
60     }
61 
62     function getUserExp(address addr) public view returns(uint256 exp){
63         return userExpPool[addr];
64     }
65 
66     function getVIPLevel(address user) public view returns (uint256 level) {
67         uint exp = userExpPool[user];
68 
69         if(exp >= 25 ether && exp < 125 ether){
70             level = 1;
71         } else if(exp >= 125 ether && exp < 250 ether){
72             level = 2;
73         } else if(exp >= 250 ether && exp < 1250 ether){
74             level = 3;
75         } else if(exp >= 1250 ether && exp < 2500 ether){
76             level = 4;
77         } else if(exp >= 2500 ether && exp < 12500 ether){
78             level = 5;
79         } else if(exp >= 12500 ether && exp < 25000 ether){
80             level = 6;
81         } else if(exp >= 25000 ether && exp < 125000 ether){
82             level = 7;
83         } else if(exp >= 125000 ether && exp < 250000 ether){
84             level = 8;
85         } else if(exp >= 250000 ether && exp < 1250000 ether){
86             level = 9;
87         } else if(exp >= 1250000 ether){
88             level = 10;
89         } else{
90             level = 0;
91         }
92 
93         return level;
94     }
95 
96     function getVIPBounusRate(address user) public view returns (uint256 rate){
97         uint level = getVIPLevel(user);
98         return level;
99     }
100 
101     // This function is used to bump up the jackpot fund. Cannot be used to lower it.
102     function increaseJackpot(uint increaseAmount) external onlyCaller {
103         require (increaseAmount <= address(this).balance, "Increase amount larger than balance.");
104         require (jackpotSize + increaseAmount <= address(this).balance, "Not enough funds.");
105         jackpotSize += uint128(increaseAmount);
106     }
107 
108     function payJackpotReward(address payable to) external onlyCaller{
109         to.transfer(jackpotSize);
110         jackpotSize = 0;
111     }
112 
113     function getJackpotSize() external view returns (uint256){
114         return jackpotSize;
115     }
116 
117     function increaseRankingReward(uint amount) public onlyCaller{
118         require (amount <= address(this).balance, "Increase amount larger than balance.");
119         require (rankingRewardSize + amount <= address(this).balance, "Not enough funds.");
120         rankingRewardSize += uint128(amount);
121     }
122 
123     function payRankingReward(address payable to) external onlyCaller {
124         uint128 prize = rankingRewardSize / 2;
125         rankingRewardSize = rankingRewardSize - prize;
126         if(to.send(prize)){
127             emit RankingRewardPayment(to, prize);
128         }
129     }
130 
131     function getRankingRewardSize() external view returns (uint128){
132         return rankingRewardSize;
133     }
134 }
135 contract CryptoTycoonsConstants{
136     /// *** Constants section
137 
138     // Each bet is deducted 1% in favour of the house, but no less than some minimum.
139     // The lower bound is dictated by gas costs of the settleBet transaction, providing
140     // headroom for up to 10 Gwei prices.
141     uint constant HOUSE_EDGE_PERCENT = 1;
142     uint constant RANK_FUNDS_PERCENT = 7;
143     uint constant INVITER_BENEFIT_PERCENT = 7;
144     uint constant HOUSE_EDGE_MINIMUM_AMOUNT = 0.0004 ether;
145 
146     // Bets lower than this amount do not participate in jackpot rolls (and are
147     // not deducted JACKPOT_FEE).
148     uint constant MIN_JACKPOT_BET = 0.1 ether;
149 
150     // Chance to win jackpot (currently 0.1%) and fee deducted into jackpot fund.
151     uint constant JACKPOT_MODULO = 1000;
152     uint constant JACKPOT_FEE = 0.001 ether;
153 
154     // There is minimum and maximum bets.
155     uint constant MIN_BET = 0.01 ether;
156     uint constant MAX_AMOUNT = 10 ether;
157 
158     // Standard contract ownership transfer.
159     address payable public owner;
160     address payable private nextOwner;
161 
162     // Croupier account.
163     mapping (address => bool ) croupierMap;
164 
165     // Adjustable max bet profit. Used to cap bets against dynamic odds.
166     uint public maxProfit;
167 
168     address payable public VIPLibraryAddress;
169 
170     // The address corresponding to a private key used to sign placeBet commits.
171     address public secretSigner;
172 
173     // Events that are issued to make statistic recovery easier.
174     event FailedPayment(address indexed beneficiary, uint amount);
175     event VIPPayback(address indexed beneficiary, uint amount);
176     event WithdrawFunds(address indexed beneficiary, uint amount);
177 
178     constructor (uint _maxProfit) public {
179         owner = msg.sender;
180         secretSigner = owner;
181         maxProfit = _maxProfit;
182         croupierMap[owner] = true;
183     }
184 
185     // Standard modifier on methods invokable only by contract owner.
186     modifier onlyOwner {
187         require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
188         _;
189     }
190 
191     // Standard modifier on methods invokable only by contract owner.
192     modifier onlyCroupier {
193         bool isCroupier = croupierMap[msg.sender];
194         require(isCroupier, "OnlyCroupier methods called by non-croupier.");
195         _;
196     }
197 
198 
199     // Fallback function deliberately left empty. It's primary use case
200     // is to top up the bank roll.
201     function () external payable {
202 
203     }
204 
205     // Standard contract ownership transfer implementation,
206     function approveNextOwner(address payable _nextOwner) external onlyOwner {
207         require (_nextOwner != owner, "Cannot approve current owner.");
208         nextOwner = _nextOwner;
209     }
210 
211     function acceptNextOwner() external {
212         require (msg.sender == nextOwner, "Can only accept preapproved new owner.");
213         owner = nextOwner;
214     }
215 
216     // See comment for "secretSigner" variable.
217     function setSecretSigner(address newSecretSigner) external onlyOwner {
218         secretSigner = newSecretSigner;
219     }
220 
221     function getSecretSigner() external onlyOwner view returns(address){
222         return secretSigner;
223     }
224 
225     function addCroupier(address newCroupier) external onlyOwner {
226         bool isCroupier = croupierMap[newCroupier];
227         if (isCroupier == false) {
228             croupierMap[newCroupier] = true;
229         }
230     }
231     
232     function deleteCroupier(address newCroupier) external onlyOwner {
233         bool isCroupier = croupierMap[newCroupier];
234         if (isCroupier == true) {
235             croupierMap[newCroupier] = false;
236         }
237     }
238 
239     function setVIPLibraryAddress(address payable addr) external onlyOwner{
240         VIPLibraryAddress = addr;
241     }
242 
243     // Change max bet reward. Setting this to zero effectively disables betting.
244     function setMaxProfit(uint _maxProfit) public onlyOwner {
245         require (_maxProfit < MAX_AMOUNT, "maxProfit should be a sane number.");
246         maxProfit = _maxProfit;
247     }
248     
249     // Funds withdrawal to cover costs of AceDice operation.
250     function withdrawFunds(address payable beneficiary, uint withdrawAmount) external onlyOwner {
251         require (withdrawAmount <= address(this).balance, "Increase amount larger than balance.");
252         if (beneficiary.send(withdrawAmount)){
253             emit WithdrawFunds(beneficiary, withdrawAmount);
254         }
255     }
256 
257     function kill() external onlyOwner {
258         // require (lockedInBets == 0, "All bets should be processed (settled or refunded) before self-destruct.");
259         selfdestruct(owner);
260     }
261 
262     function thisBalance() public view returns(uint) {
263         return address(this).balance;
264     }
265 
266     function payTodayReward(address payable to) external onlyOwner {
267         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
268         vipLib.payRankingReward(to);
269     }
270 
271     function getRankingRewardSize() external view returns (uint128) {
272         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
273         return vipLib.getRankingRewardSize();
274     }
275         
276     function handleVIPPaybackAndExp(CryptoTycoonsVIPLib vipLib, address payable gambler, uint amount) internal returns(uint vipPayback) {
277         // CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
278         vipLib.addUserExp(gambler, amount);
279 
280         uint rate = vipLib.getVIPBounusRate(gambler);
281 
282         if (rate <= 0)
283             return 0;
284 
285         vipPayback = amount * rate / 10000;
286         if(vipPayback > 0){
287             emit VIPPayback(gambler, vipPayback);
288         }
289     }
290 
291     function increaseRankingFund(CryptoTycoonsVIPLib vipLib, uint amount) internal{
292         uint rankingFunds = uint128(amount * HOUSE_EDGE_PERCENT / 100 * RANK_FUNDS_PERCENT /100);
293         // uint128 rankingRewardFee = uint128(amount * HOUSE_EDGE_PERCENT / 100 * 9 /100);
294         VIPLibraryAddress.transfer(rankingFunds);
295         vipLib.increaseRankingReward(rankingFunds);
296     }
297 
298     function getMyAccuAmount() external view returns (uint){
299         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
300         return vipLib.getUserExp(msg.sender);
301     }
302 
303     function getJackpotSize() external view returns (uint){
304         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
305         return vipLib.getJackpotSize();
306     }
307    
308     function verifyCommit(uint commit, uint8 v, bytes32 r, bytes32 s) internal view {
309         // Check that commit is valid - it has not expired and its signature is valid.
310         // require (block.number <= commitLastBlock, "Commit has expired.");
311         //bytes32 signatureHash = keccak256(abi.encodePacked(commitLastBlock, commit));
312         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
313         bytes memory message = abi.encodePacked(commit);
314         bytes32 messageHash = keccak256(abi.encodePacked(prefix, keccak256(message)));
315         require (secretSigner == ecrecover(messageHash, v, r, s), "ECDSA signature is not valid.");
316     }
317 
318     function calcHouseEdge(uint amount) public pure returns (uint houseEdge) {
319         // 0.02
320         houseEdge = amount * HOUSE_EDGE_PERCENT / 100;
321         if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
322             houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
323         }
324     }
325 
326     function calcJackpotFee(uint amount) internal pure returns (uint jackpotFee) {
327         // 0.001
328         if (amount >= MIN_JACKPOT_BET) {
329             jackpotFee = JACKPOT_FEE;
330         }
331     }
332 
333     function calcRankFundsFee(uint amount) internal pure returns (uint rankFundsFee) {
334         // 0.01 * 0.07
335         rankFundsFee = amount * RANK_FUNDS_PERCENT / 10000;
336     }
337 
338     function calcInviterBenefit(uint amount) internal pure returns (uint invitationFee) {
339         // 0.01 * 0.07
340         invitationFee = amount * INVITER_BENEFIT_PERCENT / 10000;
341     }
342 
343     function processBet(
344         uint betMask, uint reveal, 
345         uint8 v, bytes32 r, bytes32 s, address payable inviter) 
346     external payable;
347 }
348 
349 contract AceDice is CryptoTycoonsConstants(10 ether) {
350     
351     event Payment(address indexed beneficiary, uint amount, uint dice, uint rollUnder, uint betAmount);
352     event JackpotPayment(address indexed beneficiary, uint amount, uint dice, uint rollUnder, uint betAmount);
353 
354     function processBet(
355         uint betMask, uint reveal, 
356         uint8 v, bytes32 r, bytes32 s, address payable inviter) 
357         external payable {
358 
359         address payable gambler = msg.sender;
360 
361         // Validate input data ranges.
362         uint amount = msg.value;
363         // require (modulo > 1 && modulo <= MAX_MODULO, "Modulo should be within range.");
364         require (amount >= MIN_BET && amount <= MAX_AMOUNT, "Amount should be within range.");
365         require (betMask > 0 && betMask <= 96, "Mask should be within range.");
366         if (inviter != address(0)){
367             require(gambler != inviter, "cannot invite myself");
368         }
369 
370         uint commit = uint(keccak256(abi.encodePacked(reveal)));
371         verifyCommit(commit, v, r, s);
372 
373         require (betMask > 0 && betMask <= 100, "High modulo range, betMask larger than modulo.");
374       
375         uint possibleWinAmount;
376         uint jackpotFee;
377 
378         (possibleWinAmount, jackpotFee) = getDiceWinAmount(amount, betMask);
379 
380         require (possibleWinAmount <= amount + maxProfit, "maxProfit limit violation. ");
381 
382         require (possibleWinAmount <= address(this).balance, "Cannot afford to lose this bet.");
383 
384 
385         bytes32 entropy = keccak256(abi.encodePacked(reveal, blockhash(block.number)));
386 
387         processReward(gambler, amount, betMask, entropy, inviter);
388     }
389 
390     function processReward(
391         address payable gambler, uint amount, 
392         uint betMask, bytes32 entropy, address payable inviter) internal{
393 
394         uint dice = uint(entropy) % 100;
395 
396         CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
397         // 1. increate vip exp
398         uint payAmount = handleVIPPaybackAndExp(vipLib, msg.sender, amount);
399 
400         uint diceWinAmount;
401         uint _jackpotFee;
402         (diceWinAmount, _jackpotFee) = getDiceWinAmount(amount, betMask);
403 
404         uint jackpotWin = 0;
405        
406         // Roll for a jackpot (if eligible).
407         if (amount >= MIN_JACKPOT_BET) {
408                         
409             VIPLibraryAddress.transfer(_jackpotFee);
410             vipLib.increaseJackpot(_jackpotFee);
411 
412             // The second modulo, statistically independent from the "main" dice roll.
413             // Effectively you are playing two games at once!
414             // uint jackpotRng = (uint(entropy) / modulo) % JACKPOT_MODULO;
415 
416             // Bingo!
417             if ((uint(entropy) / 100) % JACKPOT_MODULO == 0) {
418                 jackpotWin = vipLib.getJackpotSize();
419                 vipLib.payJackpotReward(gambler);
420             }
421         }
422 
423         // Log jackpot win.
424         if (jackpotWin > 0) {
425             emit JackpotPayment(gambler, jackpotWin, dice, betMask, amount);
426         }
427 
428         if(inviter != address(0)){
429             // pay 10% of house edge to inviter
430             inviter.transfer(amount * HOUSE_EDGE_PERCENT / 100 * INVITER_BENEFIT_PERCENT /100);
431         }
432 
433         increaseRankingFund(vipLib, amount);
434 
435         if (dice < betMask) {
436             payAmount += diceWinAmount;
437         }
438         
439         if(payAmount > 0){
440             if (gambler.send(payAmount)) {
441                 emit Payment(gambler, payAmount, dice, betMask, amount);
442             } else {
443                 emit FailedPayment(gambler, amount);
444             }
445         } else {
446             emit Payment(gambler, payAmount, dice, betMask, amount);
447         }
448         
449         // Send the funds to gambler.
450         // sendFunds(gambler, diceWin == 0 ? 1 wei : diceWin, diceWin, dice, betMask, amount);
451     }
452 
453     // Get the expected win amount after house edge is subtracted.
454     function getDiceWinAmount(uint amount, uint rollUnder) private pure returns (uint winAmount, uint jackpotFee) {
455         require (0 < rollUnder && rollUnder <= 100, "Win probability out of range.");
456 
457         jackpotFee = amount >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;
458 
459         uint houseEdge = amount * HOUSE_EDGE_PERCENT / 100;
460 
461         if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
462             houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
463         }
464 
465         require (houseEdge + jackpotFee <= amount, "Bet doesn't even cover house edge.");
466         winAmount = (amount - houseEdge - jackpotFee) * 100 / rollUnder;
467     }
468 
469         
470     // Helper routine to process the payment.
471     // function sendFunds(address payable beneficiary, uint amount, uint successLogAmount, uint dice, uint rollUnder, uint betAmount) internal {
472         
473     // }
474 
475 }