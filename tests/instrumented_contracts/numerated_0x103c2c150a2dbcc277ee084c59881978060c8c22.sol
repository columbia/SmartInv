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
76    * @param _value uint the amout of tokens to be transfered
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
153     //uint public constant hashesSize = 1024 ; // DEBUG ONLY !!!
154     uint public constant hashesSize = 16384 ; // 30 days of blocks
155     uint public coldStoreLast = 0 ; // block of last cold store transfer
156 
157     // events
158     event LogBet(address indexed player, uint bethash, uint blocknumber, uint betsize);
159     event LogLoss(address indexed player, uint bethash, uint hash);
160     event LogWin(address indexed player, uint bethash, uint hash, uint prize);
161     event LogInvestment(address indexed investor, address indexed partner, uint amount);
162     event LogRecordWin(address indexed player, uint amount);
163     event LogLate(address indexed player,uint playerBlockNumber,uint currentBlockNumber);
164     event LogDividend(address indexed investor, uint amount, uint period);
165 
166     modifier onlyOwner() {
167         assert(msg.sender == owner);
168         _;
169     }
170 
171     modifier onlyAnimator() {
172         assert(msg.sender == animator);
173         _;
174     }
175 
176     // constructor
177     function SmartBillions() public {
178         owner = msg.sender;
179         animator = msg.sender;
180         wallets[owner].lastDividendPeriod = uint16(dividendPeriod);
181         dividends.push(0); // not used
182         dividends.push(0); // current dividend
183     }
184 
185 /* getters */
186     
187     /**
188      * @dev Show length of allocated swap space
189      */
190     function hashesLength() constant external returns (uint) {
191         return uint(hashes.length);
192     }
193     
194     /**
195      * @dev Show balance of wallet
196      * @param _owner The address of the account.
197      */
198     function walletBalanceOf(address _owner) constant external returns (uint) {
199         return uint(wallets[_owner].balance);
200     }
201     
202     /**
203      * @dev Show last dividend period processed
204      * @param _owner The address of the account.
205      */
206     function walletPeriodOf(address _owner) constant external returns (uint) {
207         return uint(wallets[_owner].lastDividendPeriod);
208     }
209     
210     /**
211      * @dev Show block number when withdraw can continue
212      * @param _owner The address of the account.
213      */
214     function walletBlockOf(address _owner) constant external returns (uint) {
215         return uint(wallets[_owner].nextWithdrawBlock);
216     }
217     
218     /**
219      * @dev Show bet size.
220      * @param _owner The address of the player.
221      */
222     function betValueOf(address _owner) constant external returns (uint) {
223         return uint(bets[_owner].value);
224     }
225     
226     /**
227      * @dev Show block number of lottery run for the bet.
228      * @param _owner The address of the player.
229      */
230     function betHashOf(address _owner) constant external returns (uint) {
231         return uint(bets[_owner].betHash);
232     }
233     
234     /**
235      * @dev Show block number of lottery run for the bet.
236      * @param _owner The address of the player.
237      */
238     function betBlockNumberOf(address _owner) constant external returns (uint) {
239         return uint(bets[_owner].blockNum);
240     }
241     
242     /**
243      * @dev Print number of block till next expected dividend payment
244      */
245     function dividendsBlocks() constant external returns (uint) {
246         if(investStart > 0) {
247             return(0);
248         }
249         uint period = (block.number - hashFirst) / (10 * hashesSize);
250         if(period > dividendPeriod) {
251             return(0);
252         }
253         return((10 * hashesSize) - ((block.number - hashFirst) % (10 * hashesSize)));
254     }
255 
256 /* administrative functions */
257 
258     /**
259      * @dev Change owner.
260      * @param _who The address of new owner.
261      */
262     function changeOwner(address _who) external onlyOwner {
263         assert(_who != address(0));
264         commitDividend(msg.sender);
265         commitDividend(_who);
266         owner = _who;
267     }
268 
269     /**
270      * @dev Change animator.
271      * @param _who The address of new animator.
272      */
273     function changeAnimator(address _who) external onlyAnimator {
274         assert(_who != address(0));
275         commitDividend(msg.sender);
276         commitDividend(_who);
277         animator = _who;
278     }
279 
280     /**
281      * @dev Set ICO Start block.
282      * @param _when The block number of the ICO.
283      */
284     function setInvestStart(uint _when) external onlyOwner {
285         require(investStart == 1 && hashFirst > 0 && block.number < _when);
286         investStart = _when;
287     }
288 
289     /**
290      * @dev Set maximum bet size per block
291      * @param _maxsum The maximum bet size in wei.
292      */
293     function setBetMax(uint _maxsum) external onlyOwner {
294         hashBetMax = _maxsum;
295     }
296 
297     /**
298      * @dev Reset bet size accounting, to increase bet volume above safe limits
299      */
300     function resetBet() external onlyOwner {
301         hashNext = block.number + 3;
302         hashBetSum = 0;
303     }
304 
305     /**
306      * @dev Move funds to cold storage
307      * @dev investBalance and walletBalance is protected from withdraw by owner
308      * @dev if funding is > 50% admin can withdraw only 0.25% of balance weakly
309      * @param _amount The amount of wei to move to cold storage
310      */
311     function coldStore(uint _amount) external onlyOwner {
312         houseKeeping();
313         require(_amount > 0 && this.balance >= (investBalance * 9 / 10) + walletBalance + _amount);
314         if(investBalance >= investBalanceGot / 2){ // additional jackpot protection
315             require((_amount <= this.balance / 400) && coldStoreLast + 4 * 60 * 24 * 7 <= block.number);
316         }
317         msg.sender.transfer(_amount);
318         coldStoreLast = block.number;
319     }
320 
321     /**
322      * @dev Move funds to contract jackpot
323      */
324     function hotStore() payable external {
325         walletBalance += msg.value;
326         wallets[msg.sender].balance += uint208(msg.value);
327         houseKeeping();
328     }
329 
330 /* housekeeping functions */
331 
332     /**
333      * @dev Update accounting
334      */
335     function houseKeeping() public {
336         if(investStart > 1 && block.number >= investStart + (hashesSize * 5)){ // ca. 14 days
337             investStart = 0; // start dividend payments
338         }
339         else {
340             if(hashFirst > 0){
341 		        uint period = (block.number - hashFirst) / (10 * hashesSize );
342                 if(period > dividends.length - 2) {
343                     dividends.push(0);
344                 }
345                 if(period > dividendPeriod && investStart == 0 && dividendPeriod < dividends.length - 1) {
346                     dividendPeriod++;
347                 }
348             }
349         }
350     }
351 
352 /* payments */
353 
354     /**
355      * @dev Pay balance from wallet
356      */
357     function payWallet() public {
358         if(wallets[msg.sender].balance > 0 && wallets[msg.sender].nextWithdrawBlock <= block.number){
359             uint balance = wallets[msg.sender].balance;
360             wallets[msg.sender].balance = 0;
361             walletBalance -= balance;
362             pay(balance);
363         }
364     }
365 
366     function pay(uint _amount) private {
367         uint maxpay = this.balance / 2;
368         if(maxpay >= _amount) {
369             msg.sender.transfer(_amount);
370             if(_amount > 1 finney) {
371                 houseKeeping();
372             }
373         }
374         else {
375             uint keepbalance = _amount - maxpay;
376             walletBalance += keepbalance;
377             wallets[msg.sender].balance += uint208(keepbalance);
378             wallets[msg.sender].nextWithdrawBlock = uint32(block.number + 4 * 60 * 24 * 30); // wait 1 month for more funds
379             msg.sender.transfer(maxpay);
380         }
381     }
382 
383 /* investment functions */
384 
385     /**
386      * @dev Buy tokens
387      */
388     function investDirect() payable external {
389         invest(owner);
390     }
391 
392     /**
393      * @dev Buy tokens with affiliate partner
394      * @param _partner Affiliate partner
395      */
396     function invest(address _partner) payable public {
397         //require(fromUSA()==false); // fromUSA() not yet implemented :-(
398         require(investStart > 1 && block.number < investStart + (hashesSize * 5) && investBalance < investBalanceMax);
399         uint investing = msg.value;
400         if(investing > investBalanceMax - investBalance) {
401             investing = investBalanceMax - investBalance;
402             investBalance = investBalanceMax;
403             investBalanceGot = investBalanceMax;
404             investStart = 0; // close investment round
405             msg.sender.transfer(msg.value.sub(investing)); // send back funds immediately
406         }
407         else{
408             investBalance += investing;
409             investBalanceGot += investing;
410         }
411         if(_partner == address(0) || _partner == owner){
412             walletBalance += investing / 10;
413             wallets[owner].balance += uint208(investing / 10);} // 10% for marketing if no affiliates
414         else{
415             walletBalance += (investing * 5 / 100) * 2;
416             wallets[owner].balance += uint208(investing * 5 / 100); // 5% initial marketing funds
417             wallets[_partner].balance += uint208(investing * 5 / 100);} // 5% for affiliates
418         wallets[msg.sender].lastDividendPeriod = uint16(dividendPeriod); // assert(dividendPeriod == 1);
419         uint senderBalance = investing / 10**15;
420         uint ownerBalance = investing * 16 / 10**17  ;
421         uint animatorBalance = investing * 10 / 10**17  ;
422         balances[msg.sender] += senderBalance;
423         balances[owner] += ownerBalance ; // 13% of shares go to developers
424         balances[animator] += animatorBalance ; // 8% of shares go to animator
425         totalSupply += senderBalance + ownerBalance + animatorBalance;
426         Transfer(address(0),msg.sender,senderBalance); // for etherscan
427         Transfer(address(0),owner,ownerBalance); // for etherscan
428         Transfer(address(0),animator,animatorBalance); // for etherscan
429         LogInvestment(msg.sender,_partner,investing);
430     }
431 
432     /**
433      * @dev Delete all tokens owned by sender and return unpaid dividends and 90% of initial investment
434      */
435     function disinvest() external {
436         require(investStart == 0);
437         commitDividend(msg.sender);
438         uint initialInvestment = balances[msg.sender] * 10**15;
439         Transfer(msg.sender,address(0),balances[msg.sender]); // for etherscan
440         delete balances[msg.sender]; // totalSupply stays the same, investBalance is reduced
441         investBalance -= initialInvestment;
442         wallets[msg.sender].balance += uint208(initialInvestment * 9 / 10);
443         payWallet();
444     }
445 
446     /**
447      * @dev Pay unpaid dividends
448      */
449     function payDividends() external {
450         require(investStart == 0);
451         commitDividend(msg.sender);
452         payWallet();
453     }
454 
455     /**
456      * @dev Commit remaining dividends before transfer of tokens
457      */
458     function commitDividend(address _who) internal {
459         uint last = wallets[_who].lastDividendPeriod;
460         if((balances[_who]==0) || (last==0)){
461             wallets[_who].lastDividendPeriod=uint16(dividendPeriod);
462             return;
463         }
464         if(last==dividendPeriod) {
465             return;
466         }
467         uint share = balances[_who] * 0xffffffff / totalSupply;
468         uint balance = 0;
469         for(;last<dividendPeriod;last++) {
470             balance += share * dividends[last];
471         }
472         balance = (balance / 0xffffffff);
473         walletBalance += balance;
474         wallets[_who].balance += uint208(balance);
475         wallets[_who].lastDividendPeriod = uint16(last);
476         LogDividend(_who,balance,last);
477     }
478 
479 /* lottery functions */
480 
481     function betPrize(Bet _player, uint24 _hash) constant private returns (uint) { // house fee 13.85%
482         uint24 bethash = uint24(_player.betHash);
483         uint24 hit = bethash ^ _hash;
484         uint24 matches =
485             ((hit & 0xF) == 0 ? 1 : 0 ) +
486             ((hit & 0xF0) == 0 ? 1 : 0 ) +
487             ((hit & 0xF00) == 0 ? 1 : 0 ) +
488             ((hit & 0xF000) == 0 ? 1 : 0 ) +
489             ((hit & 0xF0000) == 0 ? 1 : 0 ) +
490             ((hit & 0xF00000) == 0 ? 1 : 0 );
491         if(matches == 6){
492             return(uint(_player.value) * 7000000);
493         }
494         if(matches == 5){
495             return(uint(_player.value) * 20000);
496         }
497         if(matches == 4){
498             return(uint(_player.value) * 500);
499         }
500         if(matches == 3){
501             return(uint(_player.value) * 25);
502         }
503         if(matches == 2){
504             return(uint(_player.value) * 3);
505         }
506         return(0);
507     }
508     
509     /**
510      * @dev Check if won in lottery
511      */
512     function betOf(address _who) constant external returns (uint)  {
513         Bet memory player = bets[_who];
514         if( (player.value==0) ||
515             (player.blockNum<=1) ||
516             (block.number<player.blockNum) ||
517             (block.number>=player.blockNum + (10 * hashesSize))){
518             return(0);
519         }
520         if(block.number<player.blockNum+256){
521             return(betPrize(player,uint24(block.blockhash(player.blockNum))));
522         }
523         if(hashFirst>0){
524             uint32 hash = getHash(player.blockNum);
525             if(hash == 0x1000000) { // load hash failed :-(, return funds
526                 return(uint(player.value));
527             }
528             else{
529                 return(betPrize(player,uint24(hash)));
530             }
531 	}
532         return(0);
533     }
534 
535     /**
536      * @dev Check if won in lottery
537      */
538     function won() public {
539         Bet memory player = bets[msg.sender];
540         if(player.blockNum==0){ // create a new player
541             bets[msg.sender] = Bet({value: 0, betHash: 0, blockNum: 1});
542             return;
543         }
544         if((player.value==0) || (player.blockNum==1)){
545             payWallet();
546             return;
547         }
548         require(block.number>player.blockNum); // if there is an active bet, throw()
549         if(player.blockNum + (10 * hashesSize) <= block.number){ // last bet too long ago, lost !
550             LogLate(msg.sender,player.blockNum,block.number);
551             bets[msg.sender] = Bet({value: 0, betHash: 0, blockNum: 1});
552             return;
553         }
554         uint prize = 0;
555         uint32 hash = 0;
556         if(block.number<player.blockNum+256){
557             hash = uint24(block.blockhash(player.blockNum));
558             prize = betPrize(player,uint24(hash));
559         }
560         else {
561             if(hashFirst>0){ // lottery is open even before swap space (hashes) is ready, but player must collect results within 256 blocks after run
562                 hash = getHash(player.blockNum);
563                 if(hash == 0x1000000) { // load hash failed :-(
564                     //prize = uint(player.value); no refunds anymore
565                     LogLate(msg.sender,player.blockNum,block.number);
566                     bets[msg.sender] = Bet({value: 0, betHash: 0, blockNum: 1});
567                     return();
568                 }
569                 else{
570                     prize = betPrize(player,uint24(hash));
571                 }
572 	    }
573             else{
574                 LogLate(msg.sender,player.blockNum,block.number);
575                 bets[msg.sender] = Bet({value: 0, betHash: 0, blockNum: 1});
576                 return();
577             }
578         }
579         bets[msg.sender] = Bet({value: 0, betHash: 0, blockNum: 1});
580         if(prize>0) {
581             LogWin(msg.sender,uint(player.betHash),uint(hash),prize);
582             if(prize > maxWin){
583                 maxWin = prize;
584                 LogRecordWin(msg.sender,prize);
585             }
586             pay(prize);
587         }
588         else{
589             LogLoss(msg.sender,uint(player.betHash),uint(hash));
590         }
591     }
592 
593     /**
594      * @dev Send ether to buy tokens during ICO
595      * @dev or send less than 1 ether to contract to play
596      * @dev or send 0 to collect prize
597      */
598     function () payable external {
599         if(msg.value > 0){
600             if(investStart>1){ // during ICO payment to the contract is treated as investment
601                 invest(owner);
602             }
603             else{ // if not ICO running payment to contract is treated as play
604                 play();
605             }
606             return;
607         }
608         //check for dividends and other assets
609         if(investStart == 0 && balances[msg.sender]>0){
610             commitDividend(msg.sender);}
611         won(); // will run payWallet() if nothing else available
612     }
613 
614     /**
615      * @dev Play in lottery
616      */
617     function play() payable public returns (uint) {
618         return playSystem(uint(keccak256(msg.sender,block.number)), address(0));
619     }
620 
621     /**
622      * @dev Play in lottery with random numbers
623      * @param _partner Affiliate partner
624      */
625     function playRandom(address _partner) payable public returns (uint) {
626         return playSystem(uint(keccak256(msg.sender,block.number)), _partner);
627     }
628 
629     /**
630      * @dev Play in lottery with own numbers
631      * @param _partner Affiliate partner
632      */
633     function playSystem(uint _hash, address _partner) payable public returns (uint) {
634         won(); // check if player did not win 
635         uint24 bethash = uint24(_hash);
636         require(msg.value <= 1 ether && msg.value < hashBetMax);
637         if(msg.value > 0){
638             if(investStart==0) { // dividends only after investment finished
639                 dividends[dividendPeriod] += msg.value / 20; // 5% dividend
640             }
641             if(_partner != address(0)) {
642                 uint fee = msg.value / 100;
643                 walletBalance += fee;
644                 wallets[_partner].balance += uint208(fee); // 1% for affiliates
645             }
646             if(hashNext < block.number + 3) {
647                 hashNext = block.number + 3;
648                 hashBetSum = msg.value;
649             }
650             else{
651                 if(hashBetSum > hashBetMax) {
652                     hashNext++;
653                     hashBetSum = msg.value;
654                 }
655                 else{
656                     hashBetSum += msg.value;
657                 }
658             }
659             bets[msg.sender] = Bet({value: uint192(msg.value), betHash: uint32(bethash), blockNum: uint32(hashNext)});
660             LogBet(msg.sender,uint(bethash),hashNext,msg.value);
661         }
662         putHashes(25); // players help collecing data, now much more than in last contract
663         return(hashNext);
664     }
665 
666 /* database functions */
667 
668     /**
669      * @dev Create hash data swap space
670      * @param _sadd Number of hashes to add (<=256)
671      */
672     function addHashes(uint _sadd) public returns (uint) {
673         require(hashFirst == 0 && _sadd > 0 && _sadd <= hashesSize);
674         uint n = hashes.length;
675         if(n + _sadd > hashesSize){
676             hashes.length = hashesSize;
677         }
678         else{
679             hashes.length += _sadd;
680         }
681         for(;n<hashes.length;n++){ // make sure to burn gas
682             hashes[n] = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
683         }
684         if(hashes.length>=hashesSize) { // assume block.number > 10
685             hashFirst = block.number - ( block.number % 10);
686             hashLast = hashFirst;
687         }
688         return(hashes.length);
689     }
690 
691     /**
692      * @dev Create hash data swap space, add 128 hashes
693      */
694     function addHashes128() external returns (uint) {
695         return(addHashes(128));
696     }
697 
698     function calcHashes(uint32 _lastb, uint32 _delta) constant private returns (uint) {
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
730         uint blockn256;
731         if(block.number<256) { // useless test for testnet :-(
732             blockn256 = 0;
733         }
734         else{
735             blockn256 = block.number - 255;
736         }
737         if(lastb < blockn256) {
738             uint num = blockn256;
739             num += num % 10;
740             lastb = num; 
741         }
742         uint delta = (lastb - hashFirst) / 10;
743         hashes[delta % hashesSize] = calcHashes(uint32(lastb),uint32(delta));
744         hashLast = lastb + 10;
745         return(true);
746     }
747 
748     /**
749      * @dev Fill hash data many times
750      * @param _num Number of iterations
751      */
752     function putHashes(uint _num) public {
753         uint n=0;
754         for(;n<_num;n++){
755             if(!putHash()){
756                 return;
757             }
758         }
759     }
760     
761 }