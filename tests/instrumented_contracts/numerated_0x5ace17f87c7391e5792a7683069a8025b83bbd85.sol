1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function sub(uint a, uint b) internal returns (uint) {
5     assert(b <= a);
6     return a - b;
7   }
8   function add(uint a, uint b) internal returns (uint) {
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
19   function balanceOf(address who) constant returns (uint);
20   function transfer(address to, uint value);
21   event Transfer(address indexed from, address indexed to, uint value);
22   function commitDividend(address who) internal; // pays remaining dividend
23 }
24 
25 contract ERC20 is ERC20Basic {
26   function allowance(address owner, address spender) constant returns (uint);
27   function transferFrom(address from, address to, uint value);
28   function approve(address spender, uint value);
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
45   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
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
64   function balanceOf(address _owner) constant returns (uint balance) {
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
76    * @param _value uint the amout of tokens to be transfered
77    */
78   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
79     var _allowance = allowed[_from][msg.sender];
80     commitDividend(_from);
81     commitDividend(_to);
82     balances[_to] = balances[_to].add(_value);
83     balances[_from] = balances[_from].sub(_value);
84     allowed[_from][msg.sender] = _allowance.sub(_value);
85     Transfer(_from, _to, _value);
86   }
87   /**
88    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
89    * @param _spender The address which will spend the funds.
90    * @param _value The amount of tokens to be spent.
91    */
92   function approve(address _spender, uint _value) {
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
104   function allowance(address _owner, address _spender) constant returns (uint remaining) {
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
116     string public constant symbol = "PLAY";
117     uint public constant decimals = 0;
118 
119     // contract state
120     struct Wallet {
121         uint208 balance; // current balance of user
122     	uint16 lastDividendPeriod; // last processed dividend period of user's tokens
123     	uint32 nextWithdrawBlock; // next withdrawal possible after this block number
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
138     uint public investBalanceMax = 200000 ether; // maximum funding
139     uint public dividendPeriod = 1;
140     uint[] public dividends; // dividens collected per period, growing array
141 
142     // betting parameters
143     uint public maxWin = 0; // maximum prize won
144     uint public hashFirst = 0; // start time of building hashes database
145     uint public hashLast = 0; // last saved block of hashes
146     uint public hashNext = 0; // next available bet block.number
147     uint public hashBetSum = 0; // used bet volume of next block
148     uint public hashBetMax = 5 ether; // maximum bet size per block
149     uint[] public hashes; // space for storing lottery results
150 
151     // constants
152     //uint public constant hashesSize = 1024 ; // DEBUG ONLY !!!
153     uint public constant hashesSize = 16384 ; // 30 days of blocks
154     uint public coldStoreLast = 0 ; // block of last cold store transfer
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
176     function SmartBillions() {
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
213     function walletBlockOf(address _owner) constant external returns (uint) {
214         return uint(wallets[_owner].nextWithdrawBlock);
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
307      * @dev if funding is > 50% admin can withdraw only 0.25% of balance weakly
308      * @param _amount The amount of wei to move to cold storage
309      */
310     function coldStore(uint _amount) external onlyOwner {
311         houseKeeping();
312         require(_amount > 0 && this.balance >= (investBalance * 9 / 10) + walletBalance + _amount);
313         if(investBalance >= investBalanceMax / 2){ // additional jackpot protection
314             require((_amount <= this.balance / 400) && coldStoreLast + 4 * 60 * 24 * 7 <= block.number);
315         }
316         msg.sender.transfer(_amount);
317         coldStoreLast = block.number;
318     }
319 
320     /**
321      * @dev Move funds to contract jackpot
322      */
323     function hotStore() payable external {
324         houseKeeping();
325     }
326 
327 /* housekeeping functions */
328 
329     /**
330      * @dev Update accounting
331      */
332     function houseKeeping() public {
333         if(investStart > 1 && block.number >= investStart + (hashesSize * 5)){ // ca. 14 days
334             investStart = 0; // start dividend payments
335         }
336         else {
337             if(hashFirst > 0){
338 		        uint period = (block.number - hashFirst) / (10 * hashesSize );
339                 if(period > dividends.length - 2) {
340                     dividends.push(0);
341                 }
342                 if(period > dividendPeriod && investStart == 0 && dividendPeriod < dividends.length - 1) {
343                     dividendPeriod++;
344                 }
345             }
346         }
347     }
348 
349 /* payments */
350 
351     /**
352      * @dev Pay balance from wallet
353      */
354     function payWallet() public {
355         if(wallets[msg.sender].balance > 0 && wallets[msg.sender].nextWithdrawBlock <= block.number){
356             uint balance = wallets[msg.sender].balance;
357             wallets[msg.sender].balance = 0;
358             walletBalance -= balance;
359             pay(balance);
360         }
361     }
362 
363     function pay(uint _amount) private {
364         uint maxpay = this.balance / 2;
365         if(maxpay >= _amount) {
366             msg.sender.transfer(_amount);
367             if(_amount > 1 finney) {
368                 houseKeeping();
369             }
370         }
371         else {
372             uint keepbalance = _amount - maxpay;
373             walletBalance += keepbalance;
374             wallets[msg.sender].balance += uint208(keepbalance);
375             wallets[msg.sender].nextWithdrawBlock = uint32(block.number + 4 * 60 * 24 * 30); // wait 1 month for more funds
376             msg.sender.transfer(maxpay);
377         }
378     }
379 
380 /* investment functions */
381 
382     /**
383      * @dev Buy tokens
384      */
385     function investDirect() payable external {
386         invest(owner);
387     }
388 
389     /**
390      * @dev Buy tokens with affiliate partner
391      * @param _partner Affiliate partner
392      */
393     function invest(address _partner) payable public {
394         //require(fromUSA()==false); // fromUSA() not yet implemented :-(
395         require(investStart > 1 && block.number < investStart + (hashesSize * 5) && investBalance < investBalanceMax);
396         uint investing = msg.value;
397         if(investing > investBalanceMax - investBalance) {
398             investing = investBalanceMax - investBalance;
399             investBalance = investBalanceMax;
400             investStart = 0; // close investment round
401             msg.sender.transfer(msg.value.sub(investing)); // send back funds immediately
402         }
403         else{
404             investBalance += investing;
405         }
406         if(_partner == address(0) || _partner == owner){
407             walletBalance += investing / 10;
408             wallets[owner].balance += uint208(investing / 10);} // 10% for marketing if no affiliates
409         else{
410             walletBalance += (investing * 5 / 100) * 2;
411             wallets[owner].balance += uint208(investing * 5 / 100); // 5% initial marketing funds
412             wallets[_partner].balance += uint208(investing * 5 / 100);} // 5% for affiliates
413         wallets[msg.sender].lastDividendPeriod = uint16(dividendPeriod); // assert(dividendPeriod == 1);
414         uint senderBalance = investing / 10**15;
415         uint ownerBalance = investing * 16 / 10**17  ;
416         uint animatorBalance = investing * 10 / 10**17  ;
417         balances[msg.sender] += senderBalance;
418         balances[owner] += ownerBalance ; // 13% of shares go to developers
419         balances[animator] += animatorBalance ; // 8% of shares go to animator
420         totalSupply += senderBalance + ownerBalance + animatorBalance;
421         Transfer(address(0),msg.sender,senderBalance); // for etherscan
422         Transfer(address(0),owner,ownerBalance); // for etherscan
423         Transfer(address(0),animator,animatorBalance); // for etherscan
424         LogInvestment(msg.sender,_partner,investing);
425     }
426 
427     /**
428      * @dev Delete all tokens owned by sender and return unpaid dividends and 90% of initial investment
429      */
430     function disinvest() external {
431         require(investStart == 0);
432         commitDividend(msg.sender);
433         uint initialInvestment = balances[msg.sender] * 10**15;
434         Transfer(msg.sender,address(0),balances[msg.sender]); // for etherscan
435         delete balances[msg.sender]; // totalSupply stays the same, investBalance is reduced
436         investBalance -= initialInvestment;
437         wallets[msg.sender].balance += uint208(initialInvestment * 9 / 10);
438         payWallet();
439     }
440 
441     /**
442      * @dev Pay unpaid dividends
443      */
444     function payDividends() external {
445         require(investStart == 0);
446         commitDividend(msg.sender);
447         payWallet();
448     }
449 
450     /**
451      * @dev Commit remaining dividends before transfer of tokens
452      */
453     function commitDividend(address _who) internal {
454         uint last = wallets[_who].lastDividendPeriod;
455         if((balances[_who]==0) || (last==0)){
456             wallets[_who].lastDividendPeriod=uint16(dividendPeriod);
457             return;
458         }
459         if(last==dividendPeriod) {
460             return;
461         }
462         uint share = balances[_who] * 0xffffffff / totalSupply;
463         uint balance = 0;
464         for(;last<dividendPeriod;last++) {
465             balance += share * dividends[last];
466         }
467         balance = (balance / 0xffffffff);
468         walletBalance += balance;
469         wallets[_who].balance += uint208(balance);
470         wallets[_who].lastDividendPeriod = uint16(last);
471         LogDividend(_who,balance,last);
472     }
473 
474 /* lottery functions */
475 
476     function betPrize(Bet _player, uint24 _hash) constant private returns (uint) { // house fee 13.85%
477         uint24 bethash = uint24(_player.betHash);
478         uint24 hit = bethash ^ _hash;
479         uint24 matches =
480             ((hit & 0xF) == 0 ? 1 : 0 ) +
481             ((hit & 0xF0) == 0 ? 1 : 0 ) +
482             ((hit & 0xF00) == 0 ? 1 : 0 ) +
483             ((hit & 0xF000) == 0 ? 1 : 0 ) +
484             ((hit & 0xF0000) == 0 ? 1 : 0 ) +
485             ((hit & 0xF00000) == 0 ? 1 : 0 );
486         if(matches == 6){
487             return(uint(_player.value) * 7000000);
488         }
489         if(matches == 5){
490             return(uint(_player.value) * 20000);
491         }
492         if(matches == 4){
493             return(uint(_player.value) * 500);
494         }
495         if(matches == 3){
496             return(uint(_player.value) * 25);
497         }
498         if(matches == 2){
499             return(uint(_player.value) * 3);
500         }
501         return(0);
502     }
503     
504     /**
505      * @dev Check if won in lottery
506      */
507     function betOf(address _who) constant external returns (uint)  {
508         Bet memory player = bets[_who];
509         if( (player.value==0) ||
510             (player.blockNum<=1) ||
511             (block.number<player.blockNum) ||
512             (block.number>=player.blockNum + (10 * hashesSize))){
513             return(0);
514         }
515         if(block.number<player.blockNum+256){
516             return(betPrize(player,uint24(block.blockhash(player.blockNum))));
517         }
518         if(hashFirst>0){
519             uint32 hash = getHash(player.blockNum);
520             if(hash == 0x1000000) { // load hash failed :-(, return funds
521                 return(uint(player.value));
522             }
523             else{
524                 return(betPrize(player,uint24(hash)));
525             }
526 	}
527         return(0);
528     }
529 
530     /**
531      * @dev Check if won in lottery
532      */
533     function won() public {
534         Bet memory player = bets[msg.sender];
535         if(player.blockNum==0){ // create a new player
536             bets[msg.sender] = Bet({value: 0, betHash: 0, blockNum: 1});
537             return;
538         }
539         if((player.value==0) || (player.blockNum==1)){
540             payWallet();
541             return;
542         }
543         require(block.number>player.blockNum); // if there is an active bet, throw()
544         if(player.blockNum + (10 * hashesSize) <= block.number){ // last bet too long ago, lost !
545             LogLate(msg.sender,player.blockNum,block.number);
546             bets[msg.sender] = Bet({value: 0, betHash: 0, blockNum: 1});
547             return;
548         }
549         uint prize = 0;
550         uint32 hash = 0;
551         if(block.number<player.blockNum+256){
552             hash = uint24(block.blockhash(player.blockNum));
553             prize = betPrize(player,uint24(hash));
554         }
555         else {
556             if(hashFirst>0){ // lottery is open even before swap space (hashes) is ready, but player must collect results within 256 blocks after run
557                 hash = getHash(player.blockNum);
558                 if(hash == 0x1000000) { // load hash failed :-(, return funds
559                     prize = uint(player.value);
560                 }
561                 else{
562                     prize = betPrize(player,uint24(hash));
563                 }
564 	    }
565             else{
566                 LogLate(msg.sender,player.blockNum,block.number);
567                 bets[msg.sender] = Bet({value: 0, betHash: 0, blockNum: 1});
568                 return();
569             }
570         }
571         bets[msg.sender] = Bet({value: 0, betHash: 0, blockNum: 1});
572         if(prize>0) {
573             LogWin(msg.sender,uint(player.betHash),uint(hash),prize);
574             if(prize > maxWin){
575                 maxWin = prize;
576                 LogRecordWin(msg.sender,prize);
577             }
578             pay(prize);
579         }
580         else{
581             LogLoss(msg.sender,uint(player.betHash),uint(hash));
582         }
583     }
584 
585     /**
586      * @dev Send ether to buy tokens during ICO
587      * @dev or send less than 1 ether to contract to play
588      * @dev or send 0 to collect prize
589      */
590     function () payable external {
591         if(msg.value > 0){
592             if(investStart>1){ // during ICO payment to the contract is treated as investment
593                 invest(owner);
594             }
595             else{ // if not ICO running payment to contract is treated as play
596                 play();
597             }
598             return;
599         }
600         //check for dividends and other assets
601         if(investStart == 0 && balances[msg.sender]>0){
602             commitDividend(msg.sender);}
603         won(); // will run payWallet() if nothing else available
604     }
605 
606     /**
607      * @dev Play in lottery
608      */
609     function play() payable public returns (uint) {
610         return playSystem(uint(sha3(msg.sender,block.number)), address(0));
611     }
612 
613     /**
614      * @dev Play in lottery with random numbers
615      * @param _partner Affiliate partner
616      */
617     function playRandom(address _partner) payable public returns (uint) {
618         return playSystem(uint(sha3(msg.sender,block.number)), _partner);
619     }
620 
621     /**
622      * @dev Play in lottery with own numbers
623      * @param _partner Affiliate partner
624      */
625     function playSystem(uint _hash, address _partner) payable public returns (uint) {
626         won(); // check if player did not win 
627         uint24 bethash = uint24(_hash);
628         require(msg.value <= 1 ether && msg.value < hashBetMax);
629         if(msg.value > 0){
630             if(investStart==0) { // dividends only after investment finished
631                 dividends[dividendPeriod] += msg.value / 20; // 5% dividend
632             }
633             if(_partner != address(0)) {
634                 uint fee = msg.value / 100;
635                 walletBalance += fee;
636                 wallets[_partner].balance += uint208(fee); // 1% for affiliates
637             }
638             if(hashNext < block.number + 3) {
639                 hashNext = block.number + 3;
640                 hashBetSum = msg.value;
641             }
642             else{
643                 if(hashBetSum > hashBetMax) {
644                     hashNext++;
645                     hashBetSum = msg.value;
646                 }
647                 else{
648                     hashBetSum += msg.value;
649                 }
650             }
651             bets[msg.sender] = Bet({value: uint192(msg.value), betHash: uint32(bethash), blockNum: uint32(hashNext)});
652             LogBet(msg.sender,uint(bethash),hashNext,msg.value);
653         }
654         putHash(); // players help collecing data
655         return(hashNext);
656     }
657 
658 /* database functions */
659 
660     /**
661      * @dev Create hash data swap space
662      * @param _sadd Number of hashes to add (<=256)
663      */
664     function addHashes(uint _sadd) public returns (uint) {
665         require(hashFirst == 0 && _sadd > 0 && _sadd <= hashesSize);
666         uint n = hashes.length;
667         if(n + _sadd > hashesSize){
668             hashes.length = hashesSize;
669         }
670         else{
671             hashes.length += _sadd;
672         }
673         for(;n<hashes.length;n++){ // make sure to burn gas
674             hashes[n] = 1;
675         }
676         if(hashes.length>=hashesSize) { // assume block.number > 10
677             hashFirst = block.number - ( block.number % 10);
678             hashLast = hashFirst;
679         }
680         return(hashes.length);
681     }
682 
683     /**
684      * @dev Create hash data swap space, add 128 hashes
685      */
686     function addHashes128() external returns (uint) {
687         return(addHashes(128));
688     }
689 
690     function calcHashes(uint32 _lastb, uint32 _delta) constant private returns (uint) {
691         return( ( uint(block.blockhash(_lastb  )) & 0xFFFFFF )
692             | ( ( uint(block.blockhash(_lastb+1)) & 0xFFFFFF ) << 24 )
693             | ( ( uint(block.blockhash(_lastb+2)) & 0xFFFFFF ) << 48 )
694             | ( ( uint(block.blockhash(_lastb+3)) & 0xFFFFFF ) << 72 )
695             | ( ( uint(block.blockhash(_lastb+4)) & 0xFFFFFF ) << 96 )
696             | ( ( uint(block.blockhash(_lastb+5)) & 0xFFFFFF ) << 120 )
697             | ( ( uint(block.blockhash(_lastb+6)) & 0xFFFFFF ) << 144 )
698             | ( ( uint(block.blockhash(_lastb+7)) & 0xFFFFFF ) << 168 )
699             | ( ( uint(block.blockhash(_lastb+8)) & 0xFFFFFF ) << 192 )
700             | ( ( uint(block.blockhash(_lastb+9)) & 0xFFFFFF ) << 216 )
701             | ( ( uint(_delta) / hashesSize) << 240)); 
702     }
703 
704     function getHash(uint _block) constant private returns (uint32) {
705         uint delta = (_block - hashFirst) / 10;
706         uint hash = hashes[delta % hashesSize];
707         if(delta / hashesSize != hash >> 240) {
708             return(0x1000000); // load failed, incorrect data in hashes
709         }
710         uint slotp = (_block - hashFirst) % 10; 
711         return(uint32((hash >> (24 * slotp)) & 0xFFFFFF));
712     }
713     
714     /**
715      * @dev Fill hash data
716      */
717     function putHash() public returns (bool) {
718         uint lastb = hashLast;
719         if(lastb == 0 || block.number <= lastb + 10) {
720             return(false);
721         }
722         uint blockn256;
723         if(block.number<256) { // useless test for testnet :-(
724             blockn256 = 0;
725         }
726         else{
727             blockn256 = block.number - 256;
728         }
729         if(lastb < blockn256) {
730             uint num = blockn256;
731             num += num % 10;
732             lastb = num; 
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
744     function putHashes(uint _num) external {
745         uint n=0;
746         for(;n<_num;n++){
747             if(!putHash()){
748                 return;
749             }
750         }
751     }
752     
753 }