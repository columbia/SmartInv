1 pragma solidity ^0.4.17;
2 
3 library SafeMath {
4   function sub(uint a, uint b) internal pure returns (uint) {
5     assert(b <= a);
6     return a - b;
7   }
8   function add(uint a, uint b) internal pure returns (uint) {
9     uint c = a + b;
10     assert(c >= a);
11     return c;
12   }
13 }
14 
15 contract ERC20Basic {
16   uint public totalSupply;
17   address public owner; //owner
18   address public animator; //animator
19   function balanceOf(address who) constant public returns (uint);
20   function transfer(address to, uint value) public;
21   event Transfer(address indexed from, address indexed to, uint value);
22   function commitDividend(address who) internal; // pays remaining dividend
23 }
24 
25 contract ERC20 is ERC20Basic {
26   function allowance(address owner, address spender) constant public returns (uint);
27   function transferFrom(address from, address to, uint value) public;
28   function approve(address spender, uint value) public;
29   event Approval(address indexed owner, address indexed spender, uint value);
30 }
31 
32 contract BasicToken is ERC20Basic {
33   using SafeMath for uint;
34   mapping(address => uint) balances;
35 
36   modifier onlyPayloadSize(uint size) {
37      assert(msg.data.length >= size + 4);
38      _;
39   }
40   /**
41   * @dev transfer token for a specified address
42   * @param _to The address to transfer to.
43   * @param _value The amount to be transferred.
44   */
45   function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {
46     commitDividend(msg.sender);
47     balances[msg.sender] = balances[msg.sender].sub(_value);
48     if(_to == address(this)) {
49         commitDividend(owner);
50         balances[owner] = balances[owner].add(_value);
51         Transfer(msg.sender, owner, _value);
52     }
53     else {
54         commitDividend(_to);
55         balances[_to] = balances[_to].add(_value);
56         Transfer(msg.sender, _to, _value);
57     }
58   }
59   /**
60   * @dev Gets the balance of the specified address.
61   * @param _owner The address to query the the balance of. 
62   * @return An uint representing the amount owned by the passed address.
63   */
64   function balanceOf(address _owner) constant public returns (uint balance) {
65     return balances[_owner];
66   }
67 }
68 
69 contract StandardToken is BasicToken, ERC20 {
70   mapping (address => mapping (address => uint)) allowed;
71 
72   /**
73    * @dev Transfer tokens from one address to another
74    * @param _from address The address which you want to send tokens from
75    * @param _to address The address which you want to transfer to
76    * @param _value uint the amount of tokens to be transfered
77    */
78   function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {
79     var _allowance = allowed[_from][msg.sender];
80     commitDividend(_from);
81     commitDividend(_to);
82     allowed[_from][msg.sender] = _allowance.sub(_value);
83     balances[_from] = balances[_from].sub(_value);
84     balances[_to] = balances[_to].add(_value);
85     Transfer(_from, _to, _value);
86   }
87   /**
88    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
89    * @param _spender The address which will spend the funds.
90    * @param _value The amount of tokens to be spent.
91    */
92   function approve(address _spender, uint _value) public {
93     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
94     assert(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
95     allowed[msg.sender][_spender] = _value;
96     Approval(msg.sender, _spender, _value);
97   }
98   /**
99    * @dev Function to check the amount of tokens than an owner allowed to a spender.
100    * @param _owner address The address which owns the funds.
101    * @param _spender address The address which will spend the funds.
102    * @return A uint specifing the amount of tokens still avaible for the spender.
103    */
104   function allowance(address _owner, address _spender) constant public returns (uint remaining) {
105     return allowed[_owner][_spender];
106   }
107 }
108 
109 /**
110  * @title SmartBillions contract
111  */
112 contract SmartBillions is StandardToken {
113 
114     // metadata
115     string public constant name = "SmartBillions Token";
116     string public constant symbol = "Smart"; // changed due to conflicts
117     uint public constant decimals = 0;
118 
119     // contract state
120     struct Wallet {
121         uint208 balance; // current balance of user
122     	uint16 lastDividendPeriod; // last processed dividend period of user's tokens
123     	uint32 nextWithdrawTime; // next withdrawal possible after this timestamp
124     }
125     mapping (address => Wallet) wallets;
126     struct Bet {
127         uint192 value; // bet size
128         uint32 betHash; // selected numbers
129         uint32 blockNum; // blocknumber when lottery runs
130     }
131     mapping (address => Bet) bets;
132 
133     uint public walletBalance = 0; // sum of funds in wallets
134 
135     // investment parameters
136     uint public investStart = 1; // investment start block, 0: closed, 1: preparation
137     uint public investBalance = 0; // funding from investors
138     uint public investBalanceGot = 0; // funding collected
139     uint public investBalanceMax = 200000 ether; // maximum funding
140     uint public dividendPeriod = 1;
141     uint[] public dividends; // dividens collected per period, growing array
142 
143     // betting parameters
144     uint public maxWin = 0; // maximum prize won
145     uint public hashFirst = 0; // start time of building hashes database
146     uint public hashLast = 0; // last saved block of hashes
147     uint public hashNext = 0; // next available bet block.number
148     uint public hashBetSum = 0; // used bet volume of next block
149     uint public hashBetMax = 5 ether; // maximum bet size per block
150     uint[] public hashes; // space for storing lottery results
151 
152     // constants
153     uint public constant hashesSize = 16384 ; // 30 days of blocks
154     uint public coldStoreLast = 0 ; // timestamp of last cold store transfer
155 
156     // events
157     event LogBet(address indexed player, uint bethash, uint blocknumber, uint betsize);
158     event LogLoss(address indexed player, uint bethash, uint hash);
159     event LogWin(address indexed player, uint bethash, uint hash, uint prize);
160     event LogInvestment(address indexed investor, address indexed partner, uint amount);
161     event LogRecordWin(address indexed player, uint amount);
162     event LogLate(address indexed player,uint playerBlockNumber,uint currentBlockNumber);
163     event LogDividend(address indexed investor, uint amount, uint period);
164 
165     modifier onlyOwner() {
166         assert(msg.sender == owner);
167         _;
168     }
169 
170     modifier onlyAnimator() {
171         assert(msg.sender == animator);
172         _;
173     }
174 
175     // constructor
176     function SmartBillions() public {
177         owner = msg.sender;
178         animator = msg.sender;
179         wallets[owner].lastDividendPeriod = uint16(dividendPeriod);
180         dividends.push(0); // not used
181         dividends.push(0); // current dividend
182     }
183 
184 /* getters */
185     
186     /**
187      * @dev Show length of allocated swap space
188      */
189     function hashesLength() constant external returns (uint) {
190         return uint(hashes.length);
191     }
192     
193     /**
194      * @dev Show balance of wallet
195      * @param _owner The address of the account.
196      */
197     function walletBalanceOf(address _owner) constant external returns (uint) {
198         return uint(wallets[_owner].balance);
199     }
200     
201     /**
202      * @dev Show last dividend period processed
203      * @param _owner The address of the account.
204      */
205     function walletPeriodOf(address _owner) constant external returns (uint) {
206         return uint(wallets[_owner].lastDividendPeriod);
207     }
208     
209     /**
210      * @dev Show block number when withdraw can continue
211      * @param _owner The address of the account.
212      */
213     function walletTimeOf(address _owner) constant external returns (uint) {
214         return uint(wallets[_owner].nextWithdrawTime);
215     }
216     
217     /**
218      * @dev Show bet size.
219      * @param _owner The address of the player.
220      */
221     function betValueOf(address _owner) constant external returns (uint) {
222         return uint(bets[_owner].value);
223     }
224     
225     /**
226      * @dev Show block number of lottery run for the bet.
227      * @param _owner The address of the player.
228      */
229     function betHashOf(address _owner) constant external returns (uint) {
230         return uint(bets[_owner].betHash);
231     }
232     
233     /**
234      * @dev Show block number of lottery run for the bet.
235      * @param _owner The address of the player.
236      */
237     function betBlockNumberOf(address _owner) constant external returns (uint) {
238         return uint(bets[_owner].blockNum);
239     }
240     
241     /**
242      * @dev Print number of block till next expected dividend payment
243      */
244     function dividendsBlocks() constant external returns (uint) {
245         if(investStart > 0) {
246             return(0);
247         }
248         uint period = (block.number - hashFirst) / (10 * hashesSize);
249         if(period > dividendPeriod) {
250             return(0);
251         }
252         return((10 * hashesSize) - ((block.number - hashFirst) % (10 * hashesSize)));
253     }
254 
255 /* administrative functions */
256 
257     /**
258      * @dev Change owner.
259      * @param _who The address of new owner.
260      */
261     function changeOwner(address _who) external onlyOwner {
262         assert(_who != address(0));
263         commitDividend(msg.sender);
264         commitDividend(_who);
265         owner = _who;
266     }
267 
268     /**
269      * @dev Change animator.
270      * @param _who The address of new animator.
271      */
272     function changeAnimator(address _who) external onlyAnimator {
273         assert(_who != address(0));
274         commitDividend(msg.sender);
275         commitDividend(_who);
276         animator = _who;
277     }
278 
279     /**
280      * @dev Set ICO Start block.
281      * @param _when The block number of the ICO.
282      */
283     function setInvestStart(uint _when) external onlyOwner {
284         require(investStart == 1 && hashFirst > 0 && block.number < _when);
285         investStart = _when;
286     }
287 
288     /**
289      * @dev Set maximum bet size per block
290      * @param _maxsum The maximum bet size in wei.
291      */
292     function setBetMax(uint _maxsum) external onlyOwner {
293         hashBetMax = _maxsum;
294     }
295 
296     /**
297      * @dev Reset bet size accounting, to increase bet volume above safe limits
298      */
299     function resetBet() external onlyOwner {
300         hashNext = block.number + 3;
301         hashBetSum = 0;
302     }
303 
304     /**
305      * @dev Move funds to cold storage
306      * @dev investBalance and walletBalance is protected from withdraw by owner
307      * @dev if funding is > 50% admin can withdraw only 0.25% of balance weekly
308      * @param _amount The amount of wei to move to cold storage
309      */
310     function coldStore(uint _amount) external onlyOwner {
311         houseKeeping();
312         require(_amount > 0 && this.balance >= (investBalance * 9 / 10) + walletBalance + _amount);
313         if(investBalance >= investBalanceGot / 2){ // additional jackpot protection
314             require((_amount <= this.balance / 400) && coldStoreLast + 60 * 60 * 24 * 7 <= block.timestamp);
315         }
316         msg.sender.transfer(_amount);
317         coldStoreLast = block.timestamp;
318     }
319 
320     /**
321      * @dev Move funds to contract jackpot
322      */
323     function hotStore() payable external {
324         walletBalance += msg.value;
325         wallets[msg.sender].balance += uint208(msg.value);
326         houseKeeping();
327     }
328 
329 /* housekeeping functions */
330 
331     /**
332      * @dev Update accounting
333      */
334     function houseKeeping() public {
335         if(investStart > 1 && block.number >= investStart + (hashesSize * 5)){ // ca. 14 days
336             investStart = 0; // start dividend payments
337         }
338         else {
339             if(hashFirst > 0){
340 		        uint period = (block.number - hashFirst) / (10 * hashesSize );
341                 if(period > dividends.length - 2) {
342                     dividends.push(0);
343                 }
344                 if(period > dividendPeriod && investStart == 0 && dividendPeriod < dividends.length - 1) {
345                     dividendPeriod++;
346                 }
347             }
348         }
349     }
350 
351 /* payments */
352 
353     /**
354      * @dev Pay balance from wallet
355      */
356     function payWallet() public {
357         if(wallets[msg.sender].balance > 0 && wallets[msg.sender].nextWithdrawTime <= block.timestamp){
358             uint balance = wallets[msg.sender].balance;
359             wallets[msg.sender].balance = 0;
360             walletBalance -= balance;
361             pay(balance);
362         }
363     }
364 
365     function pay(uint _amount) private {
366         uint maxpay = this.balance / 2;
367         if(maxpay >= _amount) {
368             msg.sender.transfer(_amount);
369             if(_amount > 1 finney) {
370                 houseKeeping();
371             }
372         }
373         else {
374             uint keepbalance = _amount - maxpay;
375             walletBalance += keepbalance;
376             wallets[msg.sender].balance += uint208(keepbalance);
377             wallets[msg.sender].nextWithdrawTime = uint32(block.timestamp + 60 * 60 * 24 * 30); // wait 1 month for more funds
378             msg.sender.transfer(maxpay);
379         }
380     }
381 
382 /* investment functions */
383 
384     /**
385      * @dev Buy tokens
386      */
387     function investDirect() payable external {
388         invest(owner);
389     }
390 
391     /**
392      * @dev Buy tokens with affiliate partner
393      * @param _partner Affiliate partner
394      */
395     function invest(address _partner) payable public {
396         //require(fromUSA()==false); // fromUSA() not yet implemented :-(
397         require(investStart > 1 && block.number < investStart + (hashesSize * 5) && investBalance < investBalanceMax);
398         uint investing = msg.value;
399         if(investing > investBalanceMax - investBalance) {
400             investing = investBalanceMax - investBalance;
401             investBalance = investBalanceMax;
402             investBalanceGot = investBalanceMax;
403             investStart = 0; // close investment round
404             msg.sender.transfer(msg.value.sub(investing)); // send back funds immediately
405         }
406         else{
407             investBalance += investing;
408             investBalanceGot += investing;
409         }
410         if(_partner == address(0) || _partner == owner){
411             walletBalance += investing / 10;
412             wallets[owner].balance += uint208(investing / 10);} // 10% for marketing if no affiliates
413         else{
414             walletBalance += (investing * 5 / 100) * 2;
415             wallets[owner].balance += uint208(investing * 5 / 100); // 5% initial marketing funds
416             wallets[_partner].balance += uint208(investing * 5 / 100);} // 5% for affiliates
417         wallets[msg.sender].lastDividendPeriod = uint16(dividendPeriod); // assert(dividendPeriod == 1);
418         uint senderBalance = investing / 10**15;
419         uint ownerBalance = investing * 16 / 10**17  ;
420         uint animatorBalance = investing * 10 / 10**17  ;
421         balances[msg.sender] += senderBalance;
422         balances[owner] += ownerBalance ; // 13% of shares go to developers
423         balances[animator] += animatorBalance ; // 8% of shares go to animator
424         totalSupply += senderBalance + ownerBalance + animatorBalance;
425         Transfer(address(0),msg.sender,senderBalance); // for etherscan
426         Transfer(address(0),owner,ownerBalance); // for etherscan
427         Transfer(address(0),animator,animatorBalance); // for etherscan
428         LogInvestment(msg.sender,_partner,investing);
429     }
430 
431     /**
432      * @dev Delete all tokens owned by sender and return unpaid dividends and 90% of initial investment
433      */
434     function disinvest() external {
435         require(investStart == 0);
436         commitDividend(msg.sender);
437         uint initialInvestment = balances[msg.sender] * 10**15;
438         Transfer(msg.sender,address(0),balances[msg.sender]); // for etherscan
439         delete balances[msg.sender]; // totalSupply stays the same, investBalance is reduced
440         investBalance -= initialInvestment;
441         wallets[msg.sender].balance += uint208(initialInvestment * 9 / 10);
442         payWallet();
443     }
444 
445     /**
446      * @dev Pay unpaid dividends
447      */
448     function payDividends() external {
449         require(investStart == 0);
450         commitDividend(msg.sender);
451         payWallet();
452     }
453 
454     /**
455      * @dev Commit remaining dividends before transfer of tokens
456      */
457     function commitDividend(address _who) internal {
458         uint last = wallets[_who].lastDividendPeriod;
459         if((balances[_who]==0) || (last==0)){
460             wallets[_who].lastDividendPeriod=uint16(dividendPeriod);
461             return;
462         }
463         if(last==dividendPeriod) {
464             return;
465         }
466         uint share = balances[_who] * 0xffffffff / totalSupply;
467         uint balance = 0;
468         for(;last<dividendPeriod;last++) {
469             balance += share * dividends[last];
470         }
471         balance = (balance / 0xffffffff);
472         walletBalance += balance;
473         wallets[_who].balance += uint208(balance);
474         wallets[_who].lastDividendPeriod = uint16(last);
475         LogDividend(_who,balance,last);
476     }
477 
478 /* lottery functions */
479 
480     function betPrize(Bet _player, uint24 _hash) constant private returns (uint) { // house fee 13.85%
481         uint24 bethash = uint24(_player.betHash);
482         uint24 hit = bethash ^ _hash;
483         uint24 matches =
484             ((hit & 0xF) == 0 ? 1 : 0 ) +
485             ((hit & 0xF0) == 0 ? 1 : 0 ) +
486             ((hit & 0xF00) == 0 ? 1 : 0 ) +
487             ((hit & 0xF000) == 0 ? 1 : 0 ) +
488             ((hit & 0xF0000) == 0 ? 1 : 0 ) +
489             ((hit & 0xF00000) == 0 ? 1 : 0 );
490         if(matches == 6){
491             return(uint(_player.value) * 7000000);
492         }
493         if(matches == 5){
494             return(uint(_player.value) * 20000);
495         }
496         if(matches == 4){
497             return(uint(_player.value) * 500);
498         }
499         if(matches == 3){
500             return(uint(_player.value) * 25);
501         }
502         if(matches == 2){
503             return(uint(_player.value) * 3);
504         }
505         return(0);
506     }
507     
508     /**
509      * @dev Check if won in lottery
510      */
511     function betOf(address _who) constant external returns (uint)  {
512         Bet memory player = bets[_who];
513         if( (player.value==0) ||
514             (player.blockNum<=1) ||
515             (block.number<player.blockNum) ||
516             (block.number>=player.blockNum + (10 * hashesSize))){
517             return(0);
518         }
519         if(block.number<player.blockNum+256){
520             return(betPrize(player,uint24(block.blockhash(player.blockNum))));
521         }
522         if(hashFirst>0){
523             uint32 hash = getHash(player.blockNum);
524             if(hash == 0x1000000) { // load hash failed :-(, return funds
525                 return(uint(player.value));
526             }
527             else{
528                 return(betPrize(player,uint24(hash)));
529             }
530 	}
531         return(0);
532     }
533 
534     /**
535      * @dev Check if won in lottery
536      */
537     function won() public {
538         Bet memory player = bets[msg.sender];
539         if(player.blockNum==0){ // create a new player
540             bets[msg.sender] = Bet({value: 0, betHash: 0, blockNum: 1});
541             return;
542         }
543         if((player.value==0) || (player.blockNum==1)){
544             payWallet();
545             return;
546         }
547         require(block.number>player.blockNum); // if there is an active bet, throw()
548         if(player.blockNum + (10 * hashesSize) <= block.number){ // last bet too long ago, lost !
549             LogLate(msg.sender,player.blockNum,block.number);
550             bets[msg.sender] = Bet({value: 0, betHash: 0, blockNum: 1});
551             return;
552         }
553         uint prize = 0;
554         uint32 hash = 0;
555         if(block.number<player.blockNum+256){
556             hash = uint24(block.blockhash(player.blockNum));
557             prize = betPrize(player,uint24(hash));
558         }
559         else {
560             if(hashFirst>0){ // lottery is open even before swap space (hashes) is ready, but player must collect results within 256 blocks after run
561                 hash = getHash(player.blockNum);
562                 if(hash == 0x1000000) { // load hash failed :-(
563                     //prize = uint(player.value); no refunds anymore
564                     LogLate(msg.sender,player.blockNum,block.number);
565                     bets[msg.sender] = Bet({value: 0, betHash: 0, blockNum: 1});
566                     return();
567                 }
568                 else{
569                     prize = betPrize(player,uint24(hash));
570                 }
571 	    }
572             else{
573                 LogLate(msg.sender,player.blockNum,block.number);
574                 bets[msg.sender] = Bet({value: 0, betHash: 0, blockNum: 1});
575                 return();
576             }
577         }
578         bets[msg.sender] = Bet({value: 0, betHash: 0, blockNum: 1});
579         if(prize>0) {
580             LogWin(msg.sender,uint(player.betHash),uint(hash),prize);
581             if(prize > maxWin){
582                 maxWin = prize;
583                 LogRecordWin(msg.sender,prize);
584             }
585             pay(prize);
586         }
587         else{
588             LogLoss(msg.sender,uint(player.betHash),uint(hash));
589         }
590     }
591 
592     /**
593      * @dev Send ether to buy tokens during ICO
594      * @dev or send less than 1 ether to contract to play
595      * @dev or send 0 to collect prize
596      */
597     function () payable external {
598         if(msg.value > 0){
599             if(investStart>1){ // during ICO payment to the contract is treated as investment
600                 invest(owner);
601             }
602             else{ // if not ICO running payment to contract is treated as play
603                 play();
604             }
605             return;
606         }
607         //check for dividends and other assets
608         if(investStart == 0 && balances[msg.sender]>0){
609             commitDividend(msg.sender);}
610         won(); // will run payWallet() if nothing else available
611     }
612 
613     /**
614      * @dev Play in lottery
615      */
616     function play() payable public returns (uint) {
617         return playSystem(uint(keccak256(msg.sender,block.number)), address(0));
618     }
619 
620     /**
621      * @dev Play in lottery with random numbers
622      * @param _partner Affiliate partner
623      */
624     function playRandom(address _partner) payable public returns (uint) {
625         return playSystem(uint(keccak256(msg.sender,block.number)), _partner);
626     }
627 
628     /**
629      * @dev Play in lottery with own numbers
630      * @param _partner Affiliate partner
631      */
632     function playSystem(uint _hash, address _partner) payable public returns (uint) {
633         won(); // check if player did not win 
634         uint24 bethash = uint24(_hash);
635         require(msg.value <= 1 ether && msg.value < hashBetMax);
636         if(msg.value > 0){
637             if(investStart==0) { // dividends only after investment finished
638                 dividends[dividendPeriod] += msg.value / 20; // 5% dividend
639             }
640             if(_partner != address(0)) {
641                 uint fee = msg.value / 100;
642                 walletBalance += fee;
643                 wallets[_partner].balance += uint208(fee); // 1% for affiliates
644             }
645             if(hashNext < block.number + 3) {
646                 hashNext = block.number + 3;
647                 hashBetSum = msg.value;
648             }
649             else{
650                 if(hashBetSum > hashBetMax) {
651                     hashNext++;
652                     hashBetSum = msg.value;
653                 }
654                 else{
655                     hashBetSum += msg.value;
656                 }
657             }
658             bets[msg.sender] = Bet({value: uint192(msg.value), betHash: uint32(bethash), blockNum: uint32(hashNext)});
659             LogBet(msg.sender,uint(bethash),hashNext,msg.value);
660         }
661         putHashes(25); // players help collecing data, now much more than in last contract
662         return(hashNext);
663     }
664 
665 /* database functions */
666 
667     /**
668      * @dev Create hash data swap space
669      * @param _sadd Number of hashes to add (<=256)
670      */
671     function addHashes(uint _sadd) public returns (uint) {
672         require(hashFirst == 0 && _sadd > 0 && _sadd <= hashesSize);
673         uint n = hashes.length;
674         if(n + _sadd > hashesSize){
675             hashes.length = hashesSize;
676         }
677         else{
678             hashes.length += _sadd;
679         }
680         for(;n<hashes.length;n++){ // make sure to burn gas
681             hashes[n] = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
682         }
683         if(hashes.length>=hashesSize) { // assume block.number > 10
684             hashFirst = block.number - ( block.number % 10);
685             hashLast = hashFirst;
686         }
687         return(hashes.length);
688     }
689 
690     /**
691      * @dev Create hash data swap space, add 128 hashes
692      */
693     function addHashes128() external returns (uint) {
694         return(addHashes(128));
695     }
696 
697     function calcHashes(uint32 _lastb, uint32 _delta) constant private returns (uint) {
698         // assert(!(_lastb % 10)); this is required
699         return( ( uint(block.blockhash(_lastb  )) & 0xFFFFFF )
700             | ( ( uint(block.blockhash(_lastb+1)) & 0xFFFFFF ) << 24 )
701             | ( ( uint(block.blockhash(_lastb+2)) & 0xFFFFFF ) << 48 )
702             | ( ( uint(block.blockhash(_lastb+3)) & 0xFFFFFF ) << 72 )
703             | ( ( uint(block.blockhash(_lastb+4)) & 0xFFFFFF ) << 96 )
704             | ( ( uint(block.blockhash(_lastb+5)) & 0xFFFFFF ) << 120 )
705             | ( ( uint(block.blockhash(_lastb+6)) & 0xFFFFFF ) << 144 )
706             | ( ( uint(block.blockhash(_lastb+7)) & 0xFFFFFF ) << 168 )
707             | ( ( uint(block.blockhash(_lastb+8)) & 0xFFFFFF ) << 192 )
708             | ( ( uint(block.blockhash(_lastb+9)) & 0xFFFFFF ) << 216 )
709             | ( ( uint(_delta) / hashesSize) << 240)); 
710     }
711 
712     function getHash(uint _block) constant private returns (uint32) {
713         uint delta = (_block - hashFirst) / 10;
714         uint hash = hashes[delta % hashesSize];
715         if(delta / hashesSize != hash >> 240) {
716             return(0x1000000); // load failed, incorrect data in hashes
717         }
718         uint slotp = (_block - hashFirst) % 10; 
719         return(uint32((hash >> (24 * slotp)) & 0xFFFFFF));
720     }
721     
722     /**
723      * @dev Fill hash data
724      */
725     function putHash() public returns (bool) {
726         uint lastb = hashLast;
727         if(lastb == 0 || block.number <= lastb + 10) {
728             return(false);
729         }
730         if(lastb < block.number - 245) {
731             uint num = block.number - 245;
732             lastb = num - (num % 10);
733         }
734         uint delta = (lastb - hashFirst) / 10;
735         hashes[delta % hashesSize] = calcHashes(uint32(lastb),uint32(delta));
736         hashLast = lastb + 10;
737         return(true);
738     }
739 
740     /**
741      * @dev Fill hash data many times
742      * @param _num Number of iterations
743      */
744     function putHashes(uint _num) public {
745         uint n=0;
746         for(;n<_num;n++){
747             if(!putHash()){
748                 return;
749             }
750         }
751     }
752     
753 }