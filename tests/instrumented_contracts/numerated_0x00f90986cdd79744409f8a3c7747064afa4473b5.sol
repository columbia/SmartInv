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
163     //event LogWithdraw(address indexed who, uint amount);
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
180         //wallets[animator].lastDividendPeriod = uint16(dividendPeriod);
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
314         if(investBalance >= investBalanceMax / 2){ // additional jackpot protection
315             require((_amount <= this.balance / 400) && coldStoreLast + 4 * 60 * 24 * 7 <= block.number);
316         }
317         msg.sender.transfer(_amount);
318         coldStoreLast = block.number;
319     }
320 
321     /**
322      * @dev Move funds to contract
323      */
324     function hotStore() payable external { // not needed because jackpot is protected
325         houseKeeping();
326     }
327 
328 /* housekeeping functions */
329 
330     /**
331      * @dev Update accounting
332      */
333     function houseKeeping() public {
334         if(investStart > 1 && block.number >= investStart + (hashesSize * 5)){ // ca. 14 days
335             investStart = 0; // start dividend payments
336         }
337         else {
338             if(hashFirst > 0){
339 		        uint period = (block.number - hashFirst) / (10 * hashesSize );
340                 if(period > dividends.length - 2) {
341                     dividends.push(0);
342                 }
343                 if(period > dividendPeriod && investStart == 0 && dividendPeriod < dividends.length - 1) {
344                     dividendPeriod++;
345                 }
346             }
347         }
348     }
349 
350 /* payments */
351 
352     /**
353      * @dev Pay balance from wallet
354      */
355     function payWallet() public {
356         if(wallets[msg.sender].balance > 0 && wallets[msg.sender].nextWithdrawBlock <= block.number){
357             uint balance = wallets[msg.sender].balance;
358             wallets[msg.sender].balance = 0;
359             walletBalance -= balance;
360             pay(balance);
361             //LogWithdraw(msg.sender,balance);
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
377             wallets[msg.sender].nextWithdrawBlock = uint32(block.number + 4 * 60 * 24 * 30); // wait 1 month for more funds
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
402             investStart = 0; // close investment round
403             msg.sender.transfer(msg.value.sub(investing)); // send back funds immediately
404         }
405         else{
406             investBalance += investing;
407         }
408         if(_partner == address(0) || _partner == owner){
409             walletBalance += investing / 10;
410             wallets[owner].balance += uint208(investing / 10);} // 10% for marketing if no affiliates
411         else{
412             walletBalance += (investing * 5 / 100) * 2;
413             wallets[owner].balance += uint208(investing * 5 / 100); // 5% initial marketing funds
414             //wallets[_partner].lastDividendPeriod = uint16(dividendPeriod); // assert(dividendPeriod == 1);
415             wallets[_partner].balance += uint208(investing * 5 / 100);} // 5% for affiliates
416         wallets[msg.sender].lastDividendPeriod = uint16(dividendPeriod); // assert(dividendPeriod == 1);
417         uint senderBalance = investing / 10**15;
418         uint ownerBalance = investing * 16 / 10**17  ;
419         uint animatorBalance = investing * 10 / 10**17  ;
420         balances[msg.sender] += senderBalance;
421         balances[owner] += ownerBalance ; // 13% of shares go to developers
422         balances[animator] += animatorBalance ; // 8% of shares go to animator
423         totalSupply += senderBalance + ownerBalance + animatorBalance;
424         Transfer(address(0),msg.sender,senderBalance); // for etherscan
425         Transfer(address(0),owner,ownerBalance); // for etherscan
426         Transfer(address(0),animator,animatorBalance); // for etherscan
427         LogInvestment(msg.sender,_partner,investing);
428     }
429 
430     /**
431      * @dev Delete all tokens owned by sender and return unpaid dividends and 90% of initial investment
432      */
433     function disinvest() external {
434         require(investStart == 0);
435         commitDividend(msg.sender);
436         uint initialInvestment = balances[msg.sender] * 10**15;
437         Transfer(msg.sender,address(0),balances[msg.sender]); // for etherscan
438         delete balances[msg.sender]; // totalSupply stays the same, investBalance is reduced
439         investBalance -= initialInvestment;
440         wallets[msg.sender].balance += uint208(initialInvestment * 9 / 10);
441         payWallet();
442     }
443 
444     /**
445      * @dev Pay unpaid dividends
446      */
447     function payDividends() external {
448         require(investStart == 0);
449         commitDividend(msg.sender);
450         payWallet();
451     }
452 
453     /**
454      * @dev Commit remaining dividends before transfer of tokens
455      */
456     function commitDividend(address _who) internal {
457         uint last = wallets[_who].lastDividendPeriod;
458         if((balances[_who]==0) || (last==0)){
459             wallets[_who].lastDividendPeriod=uint16(dividendPeriod);
460             return;
461         }
462         if(last==dividendPeriod) {
463             return;
464         }
465         uint share = balances[_who] * 0xffffffff / totalSupply;
466         uint balance = 0;
467         for(;last<dividendPeriod;last++) {
468             balance += share * dividends[last];
469         }
470         balance = (balance / 0xffffffff);
471         walletBalance += balance;
472         wallets[_who].balance += uint208(balance);
473         wallets[_who].lastDividendPeriod = uint16(last);
474     }
475 
476 /* lottery functions */
477 
478     function betPrize(Bet _player, uint24 _hash) constant private returns (uint) { // house fee 13.85%
479         uint24 bethash = uint24(_player.betHash);
480         uint24 hit = bethash ^ _hash;
481         uint24 matches =
482             ((hit & 0xF) == 0 ? 1 : 0 ) +
483             ((hit & 0xF0) == 0 ? 1 : 0 ) +
484             ((hit & 0xF00) == 0 ? 1 : 0 ) +
485             ((hit & 0xF000) == 0 ? 1 : 0 ) +
486             ((hit & 0xF0000) == 0 ? 1 : 0 ) +
487             ((hit & 0xF00000) == 0 ? 1 : 0 );
488         if(matches == 6){
489             return(uint(_player.value) * 7000000);
490         }
491         if(matches == 5){
492             return(uint(_player.value) * 20000);
493         }
494         if(matches == 4){
495             return(uint(_player.value) * 500);
496         }
497         if(matches == 3){
498             return(uint(_player.value) * 25);
499         }
500         if(matches == 2){
501             return(uint(_player.value) * 3);
502         }
503         return(0);
504     }
505     
506     /**
507      * @dev Check if won in lottery
508      */
509     function betOf(address _who) constant external returns (uint)  {
510         Bet memory player = bets[_who];
511         if( (player.value==0) ||
512             (player.blockNum<=1) ||
513             (block.number<player.blockNum) ||
514             (block.number>=player.blockNum + (10 * hashesSize))){
515             return(0);
516         }
517         if(block.number<player.blockNum+256){
518             return(betPrize(player,uint24(block.blockhash(player.blockNum))));
519         }
520         if(hashFirst>0){
521             uint32 hash = getHash(player.blockNum);
522             if(hash == 0x1000000) { // load hash failed :-(, return funds
523                 return(uint(player.value));
524             }
525             else{
526                 return(betPrize(player,uint24(hash)));
527             }
528 	}
529         return(0);
530     }
531 
532     /**
533      * @dev Check if won in lottery
534      */
535     function won() public {
536         Bet memory player = bets[msg.sender];
537         if(player.blockNum==0){ // create a new player
538             bets[msg.sender] = Bet({value: 0, betHash: 0, blockNum: 1});
539             return;
540         }
541         if((player.value==0) || (player.blockNum==1)){
542             payWallet();
543             return;
544         }
545         require(block.number>player.blockNum); // if there is an active bet, throw()
546         if(player.blockNum + (10 * hashesSize) <= block.number){ // last bet too long ago, lost !
547             LogLate(msg.sender,player.blockNum,block.number);
548             bets[msg.sender] = Bet({value: 0, betHash: 0, blockNum: 1});
549             return;
550         }
551         uint prize = 0;
552         uint32 hash = 0;
553         if(block.number<player.blockNum+256){
554             hash = uint24(block.blockhash(player.blockNum));
555             prize = betPrize(player,uint24(hash));
556         }
557         else {
558             if(hashFirst>0){ // lottery is open even before swap space (hashes) is ready, but player must collect results within 256 blocks after run
559                 hash = getHash(player.blockNum);
560                 if(hash == 0x1000000) { // load hash failed :-(, return funds
561                     prize = uint(player.value);
562                 }
563                 else{
564                     prize = betPrize(player,uint24(hash));
565                 }
566 	    }
567             else{
568                 LogLate(msg.sender,player.blockNum,block.number);
569                 bets[msg.sender] = Bet({value: 0, betHash: 0, blockNum: 1});
570                 return();
571             }
572         }
573         bets[msg.sender] = Bet({value: 0, betHash: 0, blockNum: 1});
574         if(prize>0) {
575             LogWin(msg.sender,uint(player.betHash),uint(hash),prize);
576             if(prize > maxWin){
577                 maxWin = prize;
578                 LogRecordWin(msg.sender,prize);
579             }
580             pay(prize);
581         }
582         else{
583             LogLoss(msg.sender,uint(player.betHash),uint(hash));
584         }
585     }
586 
587     /**
588      * @dev Send less than 1 ether to contract to play or send 0 to retrieve funds
589      */
590     function () payable external {
591         if(msg.value > 0){
592             play();
593             return;
594         }
595         //check for dividends and other assets
596         if(investStart == 0 && balances[msg.sender]>0){
597             commitDividend(msg.sender);}
598         won(); // will run payWallet() if nothing else available
599     }
600 
601     /**
602      * @dev Play in lottery
603      */
604     function play() payable public returns (uint) {
605         return playSystem(uint(sha3(msg.sender,block.number)), address(0));
606     }
607 
608     /**
609      * @dev Play in lottery with random numbers
610      * @param _partner Affiliate partner
611      */
612     function playRandom(address _partner) payable public returns (uint) {
613         return playSystem(uint(sha3(msg.sender,block.number)), _partner);
614     }
615 
616     //function playSystem(uint8 num1, uint8 num2, uint8 num3, address _partner) payable public returns (uint) {
617     //    return playHash(uint24(num1)|(uint24(num2)<<8)|(uint24(num3)<<16), _partner);
618     //}
619     
620     /**
621      * @dev Play in lottery with own numbers
622      * @param _partner Affiliate partner
623      */
624     function playSystem(uint _hash, address _partner) payable public returns (uint) {
625         won(); // check if player did not win 
626         uint24 bethash = uint24(_hash);
627         require(msg.value <= 1 ether && msg.value < hashBetMax);
628         if(msg.value > 0){
629             if(investStart==0) { // dividends only after investment finished
630                 dividends[dividendPeriod] += msg.value / 34; // 3% dividend
631             }
632             if(_partner != address(0)) {
633                 uint fee = msg.value / 100;
634                 walletBalance += fee;
635                 wallets[_partner].balance += uint208(fee); // 1% for affiliates
636             }
637             if(hashNext < block.number + 3) {
638                 hashNext = block.number + 3;
639                 hashBetSum = msg.value;
640             }
641             else{
642                 if(hashBetSum > hashBetMax) {
643                     hashNext++;
644                     hashBetSum = msg.value;
645                 }
646                 else{
647                     hashBetSum += msg.value;
648                 }
649             }
650             bets[msg.sender] = Bet({value: uint192(msg.value), betHash: uint32(bethash), blockNum: uint32(hashNext)});
651             LogBet(msg.sender,uint(bethash),hashNext,msg.value);
652         }
653         putHash(); // players help collecing data
654         return(hashNext);
655     }
656 
657 /* database functions */
658 
659     /**
660      * @dev Create hash data swap space
661      * @param _sadd Number of hashes to add (<=256)
662      */
663     function addHashes(uint _sadd) public returns (uint) {
664         require(hashes.length + _sadd<=hashesSize);
665         uint n = hashes.length;
666         hashes.length += _sadd;
667         for(;n<hashes.length;n++){ // make sure to burn gas
668             hashes[n] = 1;
669         }
670         if(hashes.length>=hashesSize) { // assume block.number > 10
671             hashFirst = block.number - ( block.number % 10);
672             hashLast = hashFirst;
673         }
674         return(hashes.length);
675     }
676 
677     /**
678      * @dev Create hash data swap space, add 128 hashes
679      */
680     function addHashes128() external returns (uint) {
681         return(addHashes(128));
682     }
683 
684     function calcHashes(uint32 _lastb, uint32 _delta) constant private returns (uint) {
685         return( ( uint(block.blockhash(_lastb  )) & 0xFFFFFF )
686             | ( ( uint(block.blockhash(_lastb+1)) & 0xFFFFFF ) << 24 )
687             | ( ( uint(block.blockhash(_lastb+2)) & 0xFFFFFF ) << 48 )
688             | ( ( uint(block.blockhash(_lastb+3)) & 0xFFFFFF ) << 72 )
689             | ( ( uint(block.blockhash(_lastb+4)) & 0xFFFFFF ) << 96 )
690             | ( ( uint(block.blockhash(_lastb+5)) & 0xFFFFFF ) << 120 )
691             | ( ( uint(block.blockhash(_lastb+6)) & 0xFFFFFF ) << 144 )
692             | ( ( uint(block.blockhash(_lastb+7)) & 0xFFFFFF ) << 168 )
693             | ( ( uint(block.blockhash(_lastb+8)) & 0xFFFFFF ) << 192 )
694             | ( ( uint(block.blockhash(_lastb+9)) & 0xFFFFFF ) << 216 )
695             | ( ( uint(_delta) / hashesSize) << 240)); 
696     }
697 
698     function getHash(uint _block) constant private returns (uint32) {
699         uint delta = (_block - hashFirst) / 10;
700         uint hash = hashes[delta % hashesSize];
701         if(delta / hashesSize != hash >> 240) {
702             return(0x1000000); // load failed, incorrect data in hashes
703         }
704         uint slotp = (_block - hashFirst) % 10; 
705         return(uint32((hash >> (24 * slotp)) & 0xFFFFFF));
706     }
707     
708     /**
709      * @dev Fill hash data
710      */
711     function putHash() public returns (bool) {
712         uint lastb = hashLast;
713         if(lastb == 0 || block.number <= lastb + 10) {
714             return(false);
715         }
716         uint blockn256;
717         if(block.number<256) { // useless test for testnet :-(
718             blockn256 = 0;
719         }
720         else{
721             blockn256 = block.number - 256;
722         }
723         if(lastb < blockn256) {
724             uint num = blockn256;
725             num += num % 10;
726             lastb = num; 
727         }
728         uint delta = (lastb - hashFirst) / 10;
729         hashes[delta % hashesSize] = calcHashes(uint32(lastb),uint32(delta));
730         hashLast = lastb + 10;
731         return(true);
732     }
733 
734     /**
735      * @dev Fill hash data many times
736      * @param _num Number of iterations
737      */
738     function putHashes(uint _num) external {
739         uint n=0;
740         for(;n<_num;n++){
741             if(!putHash()){
742                 return;
743             }
744         }
745     }
746     
747 }