1 // Project: BUZcoin.io (original)
2 // v11, 2018-04-17
3 // This code is the property of CryptoB2B.io
4 // Copying in whole or in part is prohibited.
5 // Authors: Ivan Fedorov and Dmitry Borodin
6 // Do you want the same TokenSale platform? www.cryptob2b.io
7 
8 // *.sol in 1 file - https://cryptob2b.io/solidity/buzcoin/
9 
10 pragma solidity ^0.4.21;
11 
12 contract IFinancialStrategy{
13 
14     enum State { Active, Refunding, Closed }
15     State public state = State.Active;
16 
17     event Deposited(address indexed beneficiary, uint256 weiAmount);
18     event Receive(address indexed beneficiary, uint256 weiAmount);
19 
20     function deposit(address _beneficiary) external payable;
21     function setup(address _beneficiary, uint256 _arg1, uint256 _arg2, uint8 _state) external;
22     function calc(uint256 _allValue) external;
23     function getBeneficiaryCash(address _beneficiary) external;
24     function getPartnerCash(uint8 _user, bool _isAdmin, address _msgsender, bool _calc, uint256 _weiTotalRaised) external;
25 }
26 
27 contract Ownable {
28     address public owner;
29 
30 
31     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
32 
33 
34     /**
35      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
36      * account.
37      */
38     function Ownable() public {
39         owner = msg.sender;
40     }
41 
42     /**
43      * @dev Throws if called by any account other than the owner.
44      */
45     modifier onlyOwner() {
46         require(msg.sender == owner);
47         _;
48     }
49 
50     /**
51      * @dev Allows the current owner to transfer control of the contract to a newOwner.
52      * @param newOwner The address to transfer ownership to.
53      */
54     function transferOwnership(address newOwner) public onlyOwner {
55         require(newOwner != address(0));
56         emit OwnershipTransferred(owner, newOwner);
57         owner = newOwner;
58     }
59 
60 }
61 
62 library SafeMath {
63     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
64         if (a == 0) {
65             return 0;
66         }
67         uint256 c = a * b;
68         assert(c / a == b);
69         return c;
70     }
71     function div(uint256 a, uint256 b) internal pure returns (uint256) {
72         uint256 c = a / b;
73         return c;
74     }
75     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
76         assert(b <= a);
77         return a - b;
78     }
79     function add(uint256 a, uint256 b) internal pure returns (uint256) {
80         uint256 c = a + b;
81         assert(c >= a);
82         return c;
83     }
84     function minus(uint256 a, uint256 b) internal pure returns (uint256) {
85         if (b>=a) return 0;
86         return a - b;
87     }
88 }
89 
90 contract MigrationAgent
91 {
92     function migrateFrom(address _from, uint256 _value) public;
93 }
94 
95 contract IToken{
96     function setUnpausedWallet(address _wallet, bool mode) public;
97     function mint(address _to, uint256 _amount) public returns (bool);
98     function totalSupply() public view returns (uint256);
99     function setPause(bool mode) public;
100     function setMigrationAgent(address _migrationAgent) public;
101     function migrateAll(address[] _holders) public;
102     function burn(address _beneficiary, uint256 _value) public;
103     function freezedTokenOf(address _beneficiary) public view returns (uint256 amount);
104     function defrostDate(address _beneficiary) public view returns (uint256 Date);
105     function freezeTokens(address _beneficiary, uint256 _amount, uint256 _when) public;
106 }
107 
108 contract ERC223ReceivingContract {
109     function tokenFallback(address _from, uint _value, bytes memory _data) public;
110 }
111 
112 contract ERC20Basic {
113     function totalSupply() public view returns (uint256);
114     function balanceOf(address who) public view returns (uint256);
115     function transfer(address to, uint256 value) public returns (bool);
116     event Transfer(address indexed from, address indexed to, uint256 value);
117 }
118 
119 contract BasicToken is ERC20Basic {
120     using SafeMath for uint256;
121 
122     mapping(address => uint256) balances;
123 
124     uint256 totalSupply_;
125 
126     /**
127     * @dev total number of tokens in existence
128     */
129     function totalSupply() public view returns (uint256) {
130         return totalSupply_;
131     }
132 
133     /**
134     * @dev transfer token for a specified address
135     * @param _to The address to transfer to.
136     * @param _value The amount to be transferred.
137     */
138     function transfer(address _to, uint256 _value) public returns (bool) {
139         require(_to != address(0));
140         require(_value <= balances[msg.sender]);
141 
142         // SafeMath.sub will throw if there is not enough balance.
143         balances[msg.sender] = balances[msg.sender].sub(_value);
144         balances[_to] = balances[_to].add(_value);
145         emit Transfer(msg.sender, _to, _value);
146         return true;
147     }
148 
149     /**
150     * @dev Gets the balance of the specified address.
151     * @param _owner The address to query the the balance of.
152     * @return An uint256 representing the amount owned by the passed address.
153     */
154     function balanceOf(address _owner) public view returns (uint256 balance) {
155         return balances[_owner];
156     }
157 
158 }
159 
160 contract ERC20 is ERC20Basic {
161     function allowance(address owner, address spender) public view returns (uint256);
162     function transferFrom(address from, address to, uint256 value) public returns (bool);
163     function approve(address spender, uint256 value) public returns (bool);
164     event Approval(address indexed owner, address indexed spender, uint256 value);
165 }
166 
167 contract StandardToken is ERC20, BasicToken {
168 
169     mapping (address => mapping (address => uint256)) internal allowed;
170 
171 
172     /**
173      * @dev Transfer tokens from one address to another
174      * @param _from address The address which you want to send tokens from
175      * @param _to address The address which you want to transfer to
176      * @param _value uint256 the amount of tokens to be transferred
177      */
178     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
179         require(_to != address(0));
180         require(_value <= balances[_from]);
181         require(_value <= allowed[_from][msg.sender]);
182 
183         balances[_from] = balances[_from].sub(_value);
184         balances[_to] = balances[_to].add(_value);
185         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
186         emit Transfer(_from, _to, _value);
187         return true;
188     }
189 
190     /**
191      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
192      *
193      * Beware that changing an allowance with this method brings the risk that someone may use both the old
194      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
195      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
196      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
197      * @param _spender The address which will spend the funds.
198      * @param _value The amount of tokens to be spent.
199      */
200     function approve(address _spender, uint256 _value) public returns (bool) {
201         allowed[msg.sender][_spender] = _value;
202         emit Approval(msg.sender, _spender, _value);
203         return true;
204     }
205 
206     /**
207      * @dev Function to check the amount of tokens that an owner allowed to a spender.
208      * @param _owner address The address which owns the funds.
209      * @param _spender address The address which will spend the funds.
210      * @return A uint256 specifying the amount of tokens still available for the spender.
211      */
212     function allowance(address _owner, address _spender) public view returns (uint256) {
213         return allowed[_owner][_spender];
214     }
215 
216     /**
217      * @dev Increase the amount of tokens that an owner allowed to a spender.
218      *
219      * approve should be called when allowed[_spender] == 0. To increment
220      * allowed value is better to use this function to avoid 2 calls (and wait until
221      * the first transaction is mined)
222      * From MonolithDAO Token.sol
223      * @param _spender The address which will spend the funds.
224      * @param _addedValue The amount of tokens to increase the allowance by.
225      */
226     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
227         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
228         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
229         return true;
230     }
231 
232     /**
233      * @dev Decrease the amount of tokens that an owner allowed to a spender.
234      *
235      * approve should be called when allowed[_spender] == 0. To decrement
236      * allowed value is better to use this function to avoid 2 calls (and wait until
237      * the first transaction is mined)
238      * From MonolithDAO Token.sol
239      * @param _spender The address which will spend the funds.
240      * @param _subtractedValue The amount of tokens to decrease the allowance by.
241      */
242     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
243         uint oldValue = allowed[msg.sender][_spender];
244         if (_subtractedValue > oldValue) {
245             allowed[msg.sender][_spender] = 0;
246         } else {
247             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
248         }
249         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
250         return true;
251     }
252 
253 }
254 
255 contract MintableToken is StandardToken, Ownable {
256     event Mint(address indexed to, uint256 amount);
257     event MintFinished();
258 
259     /**
260      * @dev Function to mint tokens
261      * @param _to The address that will receive the minted tokens.
262      * @param _amount The amount of tokens to mint.
263      * @return A boolean that indicates if the operation was successful.
264      */
265     function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
266         totalSupply_ = totalSupply_.add(_amount);
267         balances[_to] = balances[_to].add(_amount);
268         emit Mint(_to, _amount);
269         emit Transfer(address(0), _to, _amount);
270         return true;
271     }
272 }
273 
274 contract ICreator{
275     function createToken() external returns (IToken);
276     function createFinancialStrategy() external returns(IFinancialStrategy);
277 }
278 
279 contract BuzFinancialStrategy is IFinancialStrategy, Ownable{
280     using SafeMath for uint256;
281 
282                              // Partner 0   Partner 1    Partner 2
283     uint256[3] public percent = [20,        2,           3            ];
284     uint256[3] public cap     = [200 ether, 1800 ether,  9999999 ether]; // QUINTILLIONS
285     uint256[3] public debt1   = [0,0,0];
286     uint256[3] public debt2   = [0,0,0];
287     uint256[3] public total   = [0,0,0];                                 // QUINTILLIONS
288     uint256[3] public took    = [0,0,0];
289     uint256[3] public ready   = [0,0,0];
290 
291     address[3] public wallets= [
292         0x356608b672fdB01C5077d1A2cb6a7b38fDdcd8A5,
293         0xf1F3D1Dc1E5cEA08f127cad3B7Dbd29b299c88C8,
294         0x55ecFbD0111ab365b6De98A01E9305EfD4a78FAA
295     ];
296 
297     uint256 public benTook=0;
298     uint256 public benReady=0;
299     uint256 public newCash=0;
300     uint256 public cashHistory=0;
301     uint256 public prcSum=0;
302 
303     address public benWallet=0;
304 
305     function BuzFinancialStrategy() public {
306         initialize();
307     }
308 
309     function balance() external view returns(uint256){
310         return address(this).balance;
311     }
312 
313     function initialize() internal {
314         for (uint8 i=0; i<percent.length; i++ ) prcSum+=percent[i];
315     }
316     
317     function deposit(address _beneficiary) external onlyOwner payable {
318         require(state == State.Active);
319         newCash = newCash.add(msg.value);
320         cashHistory += msg.value;
321         emit Deposited(_beneficiary,msg.value);
322     }
323 
324 
325     // 0 - destruct
326     // 1 - close
327     // 2 - restart
328     // 3 - refund
329     // 4 - test
330     // 5 - update Exchange                                                                      
331     function setup(address _beneficiary, uint256 _arg1, uint256 _arg2, uint8 _state) external onlyOwner {
332 
333         if (_state == 0)  {
334             
335             // call from Crowdsale.distructVault(true) for exit
336             // arg1 - nothing
337             // arg2 - nothing
338             selfdestruct(_beneficiary);
339 
340         }
341         else if (_state == 1 || _state == 3) {
342             // Call from Crowdsale.finalization()
343             //   [1] - successfull round (goalReach)
344             //   [3] - failed round (not enough money)
345             // arg1 = weiTotalRaised();
346             // arg2 = nothing;
347         
348             require(state == State.Active);
349             //internalCalc(_arg1);
350             state = State.Closed;
351             benWallet=_beneficiary;
352         
353         }
354         else if (_state == 2) {
355             // Call from Crowdsale.initialization()
356             // arg1 = weiTotalRaised();
357             // arg2 = nothing;
358             
359             require(state == State.Closed);
360             state = State.Active;
361             benWallet=_beneficiary;
362         
363         }
364         else if (_state == 4) {
365             // call from Crowdsale.distructVault(false) for test
366             // arg1 = nothing;
367             // arg2 = nothing;
368             benWallet=_beneficiary;
369         
370         }
371         else if (_state == 5) {
372             // arg1 = old ETH/USD (exchange)
373             // arg2 = new ETH/USD (_ETHUSD)
374 
375             for (uint8 user=0; user<cap.length; user++) cap[user]=cap[user].mul(_arg1).div(_arg2);
376             benWallet=_beneficiary;
377 
378         }
379 
380     }
381 
382     function calc(uint256 _allValue) external onlyOwner {
383         internalCalc(_allValue);
384     }
385 
386     function internalCalc(uint256 _allValue) internal {
387 
388         uint256 free=newCash+benReady;
389         uint256 common1=0;
390         uint256 common2=0;
391         uint256 spent=0;
392         uint256 plan=0;
393         uint8   user=0;
394 
395         if (free==0) return;
396 
397         for (user=0; user<percent.length; user++) {
398 
399             plan=_allValue*percent[user]/100;
400             if (total[user]>=plan || total[user]>=cap[user]) {
401                 debt1[user]=0;
402                 debt2[user]=0;
403                 continue;
404             }
405 
406             debt1[user]=plan.minus(total[user]);
407             if (debt1[user]+total[user] > cap[user]) debt1[user]=cap[user].minus(total[user]);
408 
409             common1+=debt1[user];
410 
411             plan=free.mul(percent[user]).div(prcSum);
412             debt2[user]=plan;
413             if (debt2[user]+total[user] > cap[user]) debt2[user]=cap[user].minus(total[user]);
414             
415             common2+=debt2[user];
416 
417         }
418 
419         if (common1>0 && common1<=free) {
420     
421             for (user=0; user<percent.length; user++) {
422 
423                 if (debt1[user]==0) continue;
424                 
425                 plan=free.mul(debt1[user]).div(common1);
426                 
427                 if (plan>debt1[user]) plan=debt1[user];
428                 ready[user]+=plan;
429                 total[user]+=plan;
430                 spent+=plan;
431             }
432         } 
433 
434         if (common2>0 && common1>free) {
435         
436             for (user=0; user<percent.length; user++) {
437                 
438                 if (debt2[user]==0) continue;
439 
440                 plan=free.mul(debt2[user]).div(common2);
441 
442                 if (plan>debt1[user]) plan=debt1[user]; // debt1, not 2
443                 ready[user]+=plan;
444                 total[user]+=plan;
445                 spent+=plan;
446             }
447         }
448 
449         if (spent>newCash+benReady) benReady=0;
450         else benReady=newCash.add(benReady).minus(spent);
451         newCash=0;
452 
453     }
454 
455     // Call from Crowdsale:
456     function getBeneficiaryCash(address _beneficiary) external onlyOwner {
457 
458         uint256 move=benReady;
459         benWallet=_beneficiary;
460         if (move == 0) return;
461 
462         emit Receive(_beneficiary, move);
463         benReady = 0;
464         benTook += move;
465         
466         _beneficiary.transfer(move);
467     
468     }
469 
470 
471     // Call from Crowdsale:
472     function getPartnerCash(uint8 _user, bool _isAdmin, address _msgsender, bool _calc, uint256 _weiTotalRaised) external onlyOwner {
473 
474         require(_user<percent.length && _user<wallets.length);
475 
476         if (!_isAdmin) {
477             for (uint8 i=0; i<wallets.length; i++) {
478                 if (wallets[i]==_msgsender) break;
479             }
480             if (i>=wallets.length) {
481                 return;
482             }
483         }
484 
485         if (_calc) internalCalc(_weiTotalRaised);
486 
487         uint256 move=ready[_user];
488         if (move==0) return;
489 
490         emit Receive(wallets[_user], move);
491         ready[_user]=0;
492         took[_user]+=move;
493 
494         wallets[_user].transfer(move);
495     
496     }
497 }
498 
499 contract ICrowdsale {
500     //              0             1         2        3        4        5      6       
501     enum Roles {beneficiary, accountant, manager, observer, bounty, company, team}
502     address[8] public wallets;
503 }
504 
505 contract Crowdsale is ICrowdsale{
506 // (A1)
507 // The main contract for the sale and management of rounds.
508 // 0000000000000000000000000000000000000000000000000000000000000000
509 
510     uint256 constant USER_UNPAUSE_TOKEN_TIMEOUT =  90 days;
511     uint256 constant FORCED_REFUND_TIMEOUT1     = 300 days;
512     uint256 constant FORCED_REFUND_TIMEOUT2     = 400 days;
513     uint256 constant ROUND_PROLONGATE           =  90 days;
514     uint256 constant BURN_TOKENS_TIME           =  60 days;
515 
516     using SafeMath for uint256;
517 
518     enum TokenSaleType {round1, round2}
519 
520     TokenSaleType public TokenSale = TokenSaleType.round1;
521 
522     ICreator public creator;
523     bool isBegin=false;
524 
525     IToken public token;
526     //Allocation public allocation;
527     IFinancialStrategy public financialStrategy;
528     bool public isFinalized;
529     bool public isInitialized;
530     bool public isPausedCrowdsale;
531     bool public chargeBonuses;
532     bool public canFirstMint=true;
533 
534     struct Bonus {
535         uint256 value;
536         uint256 procent;
537         uint256 freezeTime;
538     }
539 
540     struct Profit {
541         uint256 percent;
542         uint256 duration;
543     }
544 
545     struct Freezed {
546         uint256 value;
547         uint256 dateTo;
548     }
549 
550     Bonus[] public bonuses;
551     Profit[] public profits;
552 
553 
554     uint256 public startTime= 1524009600;
555     uint256 public endTime  = 1526601599;
556     uint256 public renewal;
557 
558     // How many tokens (excluding the bonus) are transferred to the investor in exchange for 1 ETH
559     // **THOUSANDS** 10^18 for human, *10**18 for Solidity, 1e18 for MyEtherWallet (MEW).
560     // Example: if 1ETH = 40.5 Token ==> use 40500 finney
561     uint256 public rate = 5000 ether; // $0.1 (ETH/USD=$500)
562 
563     // ETH/USD rate in US$
564     // **QUINTILLIONS** 10^18 / *10**18 / 1e18. Example: ETH/USD=$1000 ==> use 1000*10**18 (Solidity) or 1000 ether or 1000e18 (MEW)
565     uint256 public exchange  = 500 ether;
566 
567     // If the round does not attain this value before the closing date, the round is recognized as a
568     // failure and investors take the money back (the founders will not interfere in any way).
569     // **QUINTILLIONS** 10^18 / *10**18 / 1e18. Example: softcap=15ETH ==> use 15*10**18 (Solidity) or 15e18 (MEW)
570     uint256 public softCap = 0;
571 
572     // The maximum possible amount of income
573     // **QUINTILLIONS** 10^18 / *10**18 / 1e18. Example: hardcap=123.45ETH ==> use 123450*10**15 (Solidity) or 12345e15 (MEW)
574     uint256 public hardCap = 62000 ether; // $31M (ETH/USD=$500)
575 
576     // If the last payment is slightly higher than the hardcap, then the usual contracts do
577     // not accept it, because it goes beyond the hardcap. However it is more reasonable to accept the
578     // last payment, very slightly raising the hardcap. The value indicates by how many ETH the
579     // last payment can exceed the hardcap to allow it to be paid. Immediately after this payment, the
580     // round closes. The funders should write here a small number, not more than 1% of the CAP.
581     // Can be equal to zero, to cancel.
582     // **QUINTILLIONS** 10^18 / *10**18 / 1e18
583     uint256 public overLimit = 20 ether;
584 
585     // The minimum possible payment from an investor in ETH. Payments below this value will be rejected.
586     // **QUINTILLIONS** 10^18 / *10**18 / 1e18. Example: minPay=0.1ETH ==> use 100*10**15 (Solidity) or 100e15 (MEW)
587     uint256 public minPay = 20 finney;
588 
589     uint256 public maxAllProfit = 38; // max time bonus=30%, max value bonus=8%, maxAll=38%
590 
591     uint256 public ethWeiRaised;
592     uint256 public nonEthWeiRaised;
593     uint256 public weiRound1;
594     uint256 public tokenReserved;
595 
596     uint256 public totalSaledToken;
597 
598     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
599 
600     event Finalized();
601     event Initialized();
602 
603     function Crowdsale(ICreator _creator) public
604     {
605         creator=_creator;
606         // Initially, all next 7+ roles/wallets are given to the Manager. The Manager is an employee of the company
607         // with knowledge of IT, who publishes the contract and sets it up. However, money and tokens require
608         // a Beneficiary and other roles (Accountant, Team, etc.). The Manager will not have the right
609         // to receive them. To enable this, the Manager must either enter specific wallets here, or perform
610         // this via method changeWallet. In the finalization methods it is written which wallet and
611         // what percentage of tokens are received.
612         wallets = [
613 
614         // Beneficiary
615         // Receives all the money (when finalizing Round1 & Round2)
616         0x55d36E21b7ee114dA69a9d79D37a894d80d8Ed09,
617 
618         // Accountant
619         // Receives all the tokens for non-ETH investors (when finalizing Round1 & Round2)
620         0xaebC3c0a722A30981F8d19BDA33eFA51a89E4C6C,
621 
622         // Manager
623         // All rights except the rights to receive tokens or money. Has the right to change any other
624         // wallets (Beneficiary, Accountant, ...), but only if the round has not started. Once the
625         // round is initialized, the Manager has lost all rights to change the wallets.
626         // If the TokenSale is conducted by one person, then nothing needs to be changed. Permit all 7 roles
627         // point to a single wallet.
628         msg.sender,
629 
630         // Observer
631         // Has only the right to call paymentsInOtherCurrency (please read the document)
632         0x8a91aC199440Da0B45B2E278f3fE616b1bCcC494,
633 
634         // Bounty - 2% tokens
635         0x1f85AE08D0e1313C95D6D63e9A95c4eEeaC9D9a3,
636 
637         // Company - 10% tokens
638         0x8A6d301742133C89f08153BC9F52B585F824A18b,
639 
640         // Team - 13% tokens, no freeze
641         0xE9B02195F38938f1462c59D7c1c2F15350ad1543
642 
643         ];
644     }
645 
646     function onlyAdmin(bool forObserver) internal view {
647         require(wallets[uint8(Roles.manager)] == msg.sender || wallets[uint8(Roles.beneficiary)] == msg.sender ||
648         forObserver==true && wallets[uint8(Roles.observer)] == msg.sender);
649     }
650 
651     // Setting the current rate ETH/USD         
652     function changeExchange(uint256 _ETHUSD) public {
653 
654         require(wallets[uint8(Roles.manager)] == msg.sender || wallets[uint8(Roles.observer)] == msg.sender);
655         require(_ETHUSD >= 1 ether);
656 
657         softCap=softCap.mul(exchange).div(_ETHUSD);             // QUINTILLIONS
658         hardCap=hardCap.mul(exchange).div(_ETHUSD);             // QUINTILLIONS
659         minPay=minPay.mul(exchange).div(_ETHUSD);               // QUINTILLIONS
660 
661         rate=rate.mul(_ETHUSD).div(exchange);                   // QUINTILLIONS
662 
663         for (uint16 i = 0; i < bonuses.length; i++) {
664             bonuses[i].value=bonuses[i].value.mul(exchange).div(_ETHUSD);   // QUINTILLIONS
665         }
666 
667         financialStrategy.setup(wallets[uint8(Roles.beneficiary)], exchange, _ETHUSD, 5);
668 
669         exchange=_ETHUSD;
670 
671     }
672 
673     // Setting of basic parameters, analog of class constructor
674     // @ Do I have to use the function      see your scenario
675     // @ When it is possible to call        before Round 1/2
676     // @ When it is launched automatically  -
677     // @ Who can call the function          admins
678     function begin() public
679     {
680         onlyAdmin(true);
681         if (isBegin) return;
682         isBegin=true;
683 
684         token = creator.createToken();
685 
686         financialStrategy = creator.createFinancialStrategy();
687 
688         token.setUnpausedWallet(wallets[uint8(Roles.accountant)], true);
689         token.setUnpausedWallet(wallets[uint8(Roles.manager)], true);
690         token.setUnpausedWallet(wallets[uint8(Roles.bounty)], true);
691         token.setUnpausedWallet(wallets[uint8(Roles.company)], true);
692         token.setUnpausedWallet(wallets[uint8(Roles.observer)], true);
693 
694         bonuses.push(Bonus(20 ether, 2,0));
695         bonuses.push(Bonus(100 ether, 5,0));
696         bonuses.push(Bonus(400 ether, 8,0));
697 
698         profits.push(Profit(30,900 days));
699     }
700 
701 
702 
703     // Issue of tokens for the zero round, it is usually called: private pre-sale (Round 0)
704     // @ Do I have to use the function      may be
705     // @ When it is possible to call        before Round 1/2
706     // @ When it is launched automatically  -
707     // @ Who can call the function          admins
708     function firstMintRound0(uint256 _amount /* QUINTILLIONS! */) public {
709         onlyAdmin(false);
710         require(canFirstMint);
711         begin();
712         token.mint(wallets[uint8(Roles.manager)],_amount);
713     }
714 
715     // info
716     function totalSupply() external view returns (uint256){
717         return token.totalSupply();
718     }
719 
720     // Returns the name of the current round in plain text. Constant.
721     function getTokenSaleType() external view returns(string){
722         return (TokenSale == TokenSaleType.round1)?'round1':'round2';
723     }
724 
725     // Transfers the funds of the investor to the contract of return of funds. Internal.
726     function forwardFunds() internal {
727         financialStrategy.deposit.value(msg.value)(msg.sender);
728     }
729 
730     // Check for the possibility of buying tokens. Inside. Constant.
731     function validPurchase() internal view returns (bool) {
732 
733         // The round started and did not end
734         bool withinPeriod = (now > startTime && now < endTime.add(renewal));
735 
736         // Rate is greater than or equal to the minimum
737         bool nonZeroPurchase = msg.value >= minPay;
738 
739         // hardCap is not reached, and in the event of a transaction, it will not be exceeded by more than OverLimit
740         bool withinCap = msg.value <= hardCap.sub(weiRaised()).add(overLimit);
741 
742         // round is initialized and no "Pause of trading" is set
743         return withinPeriod && nonZeroPurchase && withinCap && isInitialized && !isPausedCrowdsale;
744     }
745 
746     // Check for the ability to finalize the round. Constant.
747     function hasEnded() public view returns (bool) {
748 
749         bool timeReached = now > endTime.add(renewal);
750 
751         bool capReached = weiRaised() >= hardCap;
752 
753         return (timeReached || capReached) && isInitialized;
754     }
755 
756     // Finalize. Only available to the Manager and the Beneficiary. If the round failed, then
757     // anyone can call the finalization to unlock the return of funds to investors
758     // You must call a function to finalize each round (after the Round1 & after the Round2)
759     // @ Do I have to use the function      yes
760     // @ When it is possible to call        after end of Round1 & Round2
761     // @ When it is launched automatically  no
762     // @ Who can call the function          admins or anybody (if round is failed)
763     function finalize() public {
764 
765         require(wallets[uint8(Roles.manager)] == msg.sender || wallets[uint8(Roles.beneficiary)] == msg.sender || !goalReached());
766         require(!isFinalized);
767         require(hasEnded() || ((wallets[uint8(Roles.manager)] == msg.sender || wallets[uint8(Roles.beneficiary)] == msg.sender) && goalReached()));
768 
769         isFinalized = true;
770         finalization();
771         emit Finalized();
772     }
773 
774     // The logic of finalization. Internal
775     // @ Do I have to use the function      no
776     // @ When it is possible to call        -
777     // @ When it is launched automatically  after end of round
778     // @ Who can call the function          -
779     function finalization() internal {
780 
781         // If the goal of the achievement
782         if (goalReached()) {
783 
784             financialStrategy.setup(wallets[uint8(Roles.beneficiary)], weiRaised(), 0, 1);//Р”Р»СЏ РєРѕРЅС‚СЂР°РєС‚Р° Buz РґРµРЅСЊРіРё РЅРµ РІРѕР·РІСЂР°С‰Р°РµС‚.
785 
786             // if there is anything to give
787             if (tokenReserved > 0) {
788 
789                 token.mint(wallets[uint8(Roles.accountant)],tokenReserved);
790 
791                 // Reset the counter
792                 tokenReserved = 0;
793             }
794 
795             // If the finalization is Round 1
796             if (TokenSale == TokenSaleType.round1) {
797 
798                 // Reset settings
799                 isInitialized = false;
800                 isFinalized = false;
801 
802                 // Switch to the second round (to Round2)
803                 TokenSale = TokenSaleType.round2;
804 
805                 // Reset the collection counter
806                 weiRound1 = weiRaised();
807                 ethWeiRaised = 0;
808                 nonEthWeiRaised = 0;
809 
810 
811 
812             }
813             else // If the second round is finalized
814             {
815 
816                 // Permission to collect tokens to those who can pick them up
817                 chargeBonuses = true;
818 
819                 totalSaledToken = token.totalSupply();
820                 //partners = true;
821 
822             }
823 
824         }
825         else // If they failed round
826         {
827             financialStrategy.setup(wallets[uint8(Roles.beneficiary)], weiRaised(), 0, 3);
828         }
829     }
830 
831     // The Manager freezes the tokens for the Team.
832     // You must call a function to finalize Round 2 (only after the Round2)
833     // @ Do I have to use the function      yes
834     // @ When it is possible to call        Round2
835     // @ When it is launched automatically  -
836     // @ Who can call the function          admins
837     function finalize2() public {
838 
839         onlyAdmin(false);
840         require(chargeBonuses);
841         chargeBonuses = false;
842 
843         //allocation = creator.createAllocation(token, now + 1 years /* stage N1 */, now + 2 years /* stage N2 */);
844         //token.setUnpausedWallet(allocation, true);
845         // Team = %, Founders = %, Fund = %    TOTAL = %
846         //allocation.addShare(wallets[uint8(Roles.team)],       6,  50); // only 50% - first year, stage N1  (and +50 for stage N2)
847         //allocation.addShare(wallets[uint8(Roles.founders)],  10,  50); // only 50% - first year, stage N1  (and +50 for stage N2)
848 
849         // 2% - bounty wallet
850         token.mint(wallets[uint8(Roles.bounty)], totalSaledToken.mul(2).div(75));
851 
852         // 10% - company
853         token.mint(wallets[uint8(Roles.company)], totalSaledToken.mul(10).div(75));
854 
855         // 13% - team
856         token.mint(wallets[uint8(Roles.team)], totalSaledToken.mul(13).div(75));
857 
858 
859     }
860 
861     function changeCrowdsale(address _newCrowdsale) external {
862         //onlyAdmin(false);
863         require(wallets[uint8(Roles.manager)] == msg.sender);
864         Ownable(token).transferOwnership(_newCrowdsale);
865     }
866 
867 
868 
869     // Initializing the round. Available to the manager. After calling the function,
870     // the Manager loses all rights: Manager can not change the settings (setup), change
871     // wallets, prevent the beginning of the round, etc. You must call a function after setup
872     // for the initial round (before the Round1 and before the Round2)
873     // @ Do I have to use the function      yes
874     // @ When it is possible to call        before each round
875     // @ When it is launched automatically  -
876     // @ Who can call the function          admins
877     function initialize() public {
878 
879         onlyAdmin(false);
880         // If not yet initialized
881         require(!isInitialized);
882         begin();
883 
884 
885         // And the specified start time has not yet come
886         // If initialization return an error, check the start date!
887         require(now <= startTime);
888 
889         initialization();
890 
891         emit Initialized();
892 
893         renewal = 0;
894 
895         isInitialized = true;
896 
897         canFirstMint = false;
898     }
899 
900     function initialization() internal {
901         if (financialStrategy.state() != IFinancialStrategy.State.Active){
902             financialStrategy.setup(wallets[uint8(Roles.beneficiary)], weiRaised(), 0, 2);
903         }
904     }
905 
906     // 
907     // @ Do I have to use the function      
908     // @ When it is possible to call        
909     // @ When it is launched automatically  
910     // @ Who can call the function          
911     function getPartnerCash(uint8 _user, bool _calc) external {
912         bool isAdmin=false;
913         for (uint8 i=0; i<wallets.length; i++) {
914             if (wallets[i]==msg.sender) {
915                 isAdmin=true;
916                 break;
917             }
918         }
919         financialStrategy.getPartnerCash(_user, isAdmin, msg.sender, _calc, weiTotalRaised());
920     }
921 
922     function getBeneficiaryCash() external {
923         onlyAdmin(false);
924         // financialStrategy.calc(weiTotalRaised());
925         financialStrategy.getBeneficiaryCash(wallets[uint8(Roles.beneficiary)]);
926     }
927 
928     function calcFin() external {
929         onlyAdmin(true);
930         financialStrategy.calc(weiTotalRaised());
931     }
932 
933     function calcAndGet() public {
934         onlyAdmin(true);
935         
936         financialStrategy.calc(weiTotalRaised());
937         financialStrategy.getBeneficiaryCash(wallets[uint8(Roles.beneficiary)]);
938         
939         for (uint8 i=0; i<3; i++) { // <-- TODO check financialStrategy.wallets.length
940             financialStrategy.getPartnerCash(i, true, msg.sender, false, weiTotalRaised());
941         }
942     }
943 
944     // We check whether we collected the necessary minimum funds. Constant.
945     function goalReached() public view returns (bool) {
946         return weiRaised() >= softCap;
947     }
948 
949 
950     // Customize. The arguments are described in the constructor above.
951     // @ Do I have to use the function      yes
952     // @ When it is possible to call        before each rond
953     // @ When it is launched automatically  -
954     // @ Who can call the function          admins
955     function setup(uint256 _startTime, uint256 _endTime, uint256 _softCap, uint256 _hardCap,
956         uint256 _rate, uint256 _exchange,
957         uint256 _maxAllProfit, uint256 _overLimit, uint256 _minPay,
958         uint256[] _durationTB , uint256[] _percentTB, uint256[] _valueVB, uint256[] _percentVB, uint256[] _freezeTimeVB) public
959     {
960 
961         onlyAdmin(false);
962         require(!isInitialized);
963 
964         begin();
965 
966         // Date and time are correct
967         require(now <= _startTime);
968         require(_startTime < _endTime);
969 
970         startTime = _startTime;
971         endTime = _endTime;
972 
973         // The parameters are correct
974         require(_softCap <= _hardCap);
975 
976         softCap = _softCap;
977         hardCap = _hardCap;
978 
979         require(_rate > 0);
980 
981         rate = _rate;
982 
983         overLimit = _overLimit;
984         minPay = _minPay;
985         exchange = _exchange;
986 
987         maxAllProfit = _maxAllProfit;
988 
989         require(_valueVB.length == _percentVB.length && _valueVB.length == _freezeTimeVB.length);
990         bonuses.length = _valueVB.length;
991         for(uint256 i = 0; i < _valueVB.length; i++){
992             bonuses[i] = Bonus(_valueVB[i],_percentVB[i],_freezeTimeVB[i]);
993         }
994 
995         require(_percentTB.length == _durationTB.length);
996         profits.length = _percentTB.length;
997         for( i = 0; i < _percentTB.length; i++){
998             profits[i] = Profit(_percentTB[i],_durationTB[i]);
999         }
1000 
1001     }
1002 
1003     // Collected funds for the current round. Constant.
1004     function weiRaised() public constant returns(uint256){
1005         return ethWeiRaised.add(nonEthWeiRaised);
1006     }
1007 
1008     // Returns the amount of fees for both phases. Constant.
1009     function weiTotalRaised() public constant returns(uint256){
1010         return weiRound1.add(weiRaised());
1011     }
1012 
1013     // Returns the percentage of the bonus on the current date. Constant.
1014     function getProfitPercent() public constant returns (uint256){
1015         return getProfitPercentForData(now);
1016     }
1017 
1018     // Returns the percentage of the bonus on the given date. Constant.
1019     function getProfitPercentForData(uint256 _timeNow) public constant returns (uint256){
1020         uint256 allDuration;
1021         for(uint8 i = 0; i < profits.length; i++){
1022             allDuration = allDuration.add(profits[i].duration);
1023             if(_timeNow < startTime.add(allDuration)){
1024                 return profits[i].percent;
1025             }
1026         }
1027         return 0;
1028     }
1029 
1030     function getBonuses(uint256 _value) public constant returns (uint256,uint256,uint256){
1031         if(bonuses.length == 0 || bonuses[0].value > _value){
1032             return (0,0,0);
1033         }
1034         uint16 i = 1;
1035         for(i; i < bonuses.length; i++){
1036             if(bonuses[i].value > _value){
1037                 break;
1038             }
1039         }
1040         return (bonuses[i-1].value,bonuses[i-1].procent,bonuses[i-1].freezeTime);
1041     }
1042 
1043     // The ability to quickly check Round1 (only for Round1, only 1 time). Completes the Round1 by
1044     // transferring the specified number of tokens to the Accountant's wallet. Available to the Manager.
1045     // Use only if this is provided by the script and white paper. In the normal scenario, it
1046     // does not call and the funds are raised normally. We recommend that you delete this
1047     // function entirely, so as not to confuse the auditors. Initialize & Finalize not needed.
1048     // ** QUINTILIONS **  10^18 / 1**18 / 1e18
1049     // @ Do I have to use the function      no, see your scenario
1050     // @ When it is possible to call        after Round0 and before Round2
1051     // @ When it is launched automatically  -
1052     // @ Who can call the function          admins
1053     //    function fastTokenSale(uint256 _totalSupply) external {
1054     //      onlyAdmin(false);
1055     //        require(TokenSale == TokenSaleType.round1 && !isInitialized);
1056     //        token.mint(wallets[uint8(Roles.accountant)], _totalSupply);
1057     //        TokenSale = TokenSaleType.round2;
1058     //    }
1059 
1060 
1061     // Remove the "Pause of exchange". Available to the manager at any time. If the
1062     // manager refuses to remove the pause, then 30-120 days after the successful
1063     // completion of the TokenSale, anyone can remove a pause and allow the exchange to continue.
1064     // The manager does not interfere and will not be able to delay the term.
1065     // He can only cancel the pause before the appointed time.
1066     // @ Do I have to use the function      YES YES YES
1067     // @ When it is possible to call        after end of ICO
1068     // @ When it is launched automatically  -
1069     // @ Who can call the function          admins or anybody
1070     function tokenUnpause() external {
1071 
1072         require(wallets[uint8(Roles.manager)] == msg.sender
1073         || (now > endTime.add(renewal).add(USER_UNPAUSE_TOKEN_TIMEOUT) && TokenSale == TokenSaleType.round2 && isFinalized && goalReached()));
1074         token.setPause(false);
1075     }
1076 
1077     // Enable the "Pause of exchange". Available to the manager until the TokenSale is completed.
1078     // The manager cannot turn on the pause, for example, 3 years after the end of the TokenSale.
1079     // @ Do I have to use the function      no
1080     // @ When it is possible to call        while Round2 not ended
1081     // @ When it is launched automatically  before any rounds
1082     // @ Who can call the function          admins
1083     function tokenPause() public {
1084         onlyAdmin(false);
1085         require(!isFinalized);
1086         token.setPause(true);
1087     }
1088 
1089     // Pause of sale. Available to the manager.
1090     // @ Do I have to use the function      no
1091     // @ When it is possible to call        during active rounds
1092     // @ When it is launched automatically  -
1093     // @ Who can call the function          admins
1094     function setCrowdsalePause(bool mode) public {
1095         onlyAdmin(false);
1096         isPausedCrowdsale = mode;
1097     }
1098 
1099     // For example - After 5 years of the project's existence, all of us suddenly decided collectively
1100     // (company + investors) that it would be more profitable for everyone to switch to another smart
1101     // contract responsible for tokens. The company then prepares a new token, investors
1102     // disassemble, study, discuss, etc. After a general agreement, the manager allows any investor:
1103     //      - to burn the tokens of the previous contract
1104     //      - generate new tokens for a new contract
1105     // It is understood that after a general solution through this function all investors
1106     // will collectively (and voluntarily) move to a new token.
1107     // @ Do I have to use the function      no
1108     // @ When it is possible to call        only after ICO!
1109     // @ When it is launched automatically  -
1110     // @ Who can call the function          admins
1111     function moveTokens(address _migrationAgent) public {
1112         onlyAdmin(false);
1113         token.setMigrationAgent(_migrationAgent);
1114     }
1115 
1116     // @ Do I have to use the function      no
1117     // @ When it is possible to call        only after ICO!
1118     // @ When it is launched automatically  -
1119     // @ Who can call the function          admins
1120     function migrateAll(address[] _holders) public {
1121         onlyAdmin(false);
1122         token.migrateAll(_holders);
1123     }
1124 
1125     // Change the address for the specified role.
1126     // Available to any wallet owner except the observer.
1127     // Available to the manager until the round is initialized.
1128     // The Observer's wallet or his own manager can change at any time.
1129     // @ Do I have to use the function      no
1130     // @ When it is possible to call        depend...
1131     // @ When it is launched automatically  -
1132     // @ Who can call the function          staff (all 7+ roles)
1133     function changeWallet(Roles _role, address _wallet) external
1134     {
1135         require(
1136             (msg.sender == wallets[uint8(_role)] /*&& _role != Roles.observer*/)
1137             ||
1138             (msg.sender == wallets[uint8(Roles.manager)] && (!isInitialized || _role == Roles.observer))
1139         );
1140 
1141         wallets[uint8(_role)] = _wallet;
1142     }
1143 
1144 
1145     // The beneficiary at any time can take rights in all roles and prescribe his wallet in all the
1146     // rollers. Thus, he will become the recipient of tokens for the role of Accountant,
1147     // Team, etc. Works at any time.
1148     // @ Do I have to use the function      no
1149     // @ When it is possible to call        any time
1150     // @ When it is launched automatically  -
1151     // @ Who can call the function          only Beneficiary
1152 //    function resetAllWallets() external{
1153 //        address _beneficiary = wallets[uint8(Roles.beneficiary)];
1154 //        require(msg.sender == _beneficiary);
1155 //        for(uint8 i = 0; i < wallets.length; i++){
1156 //            wallets[i] = _beneficiary;
1157 //        }
1158 //        token.setUnpausedWallet(_beneficiary, true);
1159 //    }
1160 
1161 
1162     // Burn the investor tokens, if provided by the ICO scenario. Limited time available - BURN_TOKENS_TIME
1163     // For people who ignore the KYC/AML procedure during 30 days after payment: money back and burning tokens.
1164     // ***CHECK***SCENARIO***
1165     // @ Do I have to use the function      no
1166     // @ When it is possible to call        any time
1167     // @ When it is launched automatically  -
1168     // @ Who can call the function          admin
1169     function massBurnTokens(address[] _beneficiary, uint256[] _value) external {
1170         onlyAdmin(false);
1171         require(endTime.add(renewal).add(BURN_TOKENS_TIME) > now);
1172         require(_beneficiary.length == _value.length);
1173         for(uint16 i; i<_beneficiary.length; i++) {
1174             token.burn(_beneficiary[i],_value[i]);
1175         }
1176     }
1177 
1178     // Extend the round time, if provided by the script. Extend the round only for
1179     // a limited number of days - ROUND_PROLONGATE
1180     // ***CHECK***SCENARIO***
1181     // @ Do I have to use the function      no
1182     // @ When it is possible to call        during active round
1183     // @ When it is launched automatically  -
1184     // @ Who can call the function          admins
1185     function prolongate(uint256 _duration) external {
1186         onlyAdmin(false);
1187         require(now > startTime && now < endTime.add(renewal) && isInitialized);
1188         renewal = renewal.add(_duration);
1189         require(renewal <= ROUND_PROLONGATE);
1190 
1191     }
1192     // If a little more than a year has elapsed (Round2 start date + 400 days), a smart contract
1193     // will allow you to send all the money to the Beneficiary, if any money is present. This is
1194     // possible if you mistakenly launch the Round2 for 30 years (not 30 days), investors will transfer
1195     // money there and you will not be able to pick them up within a reasonable time. It is also
1196     // possible that in our checked script someone will make unforeseen mistakes, spoiling the
1197     // finalization. Without finalization, money cannot be returned. This is a rescue option to
1198     // get around this problem, but available only after a year (400 days).
1199 
1200     // Another reason - the TokenSale was a failure, but not all ETH investors took their money during the year after.
1201     // Some investors may have lost a wallet key, for example.
1202 
1203     // The method works equally with the Round1 and Round2. When the Round1 starts, the time for unlocking
1204     // the distructVault begins. If the TokenSale is then started, then the term starts anew from the first day of the TokenSale.
1205 
1206     // Next, act independently, in accordance with obligations to investors.
1207 
1208     // Within 400 days (FORCED_REFUND_TIMEOUT1) of the start of the Round, if it fails only investors can take money. After
1209     // the deadline this can also include the company as well as investors, depending on who is the first to use the method.
1210     // @ Do I have to use the function      no
1211     // @ When it is possible to call        -
1212     // @ When it is launched automatically  -
1213     // @ Who can call the function          beneficiary & manager
1214     function distructVault(bool mode) public {
1215         if(mode){
1216             if (wallets[uint8(Roles.beneficiary)] == msg.sender && (now > startTime.add(FORCED_REFUND_TIMEOUT1))) {
1217                 financialStrategy.setup(wallets[uint8(Roles.beneficiary)], weiRaised(), 0, 0);
1218             }
1219             if (wallets[uint8(Roles.manager)] == msg.sender && (now > startTime.add(FORCED_REFUND_TIMEOUT2))) {
1220                 financialStrategy.setup(wallets[uint8(Roles.manager)], weiRaised(), 0, 0);
1221             }
1222         } else {
1223             onlyAdmin(false);
1224             financialStrategy.setup(wallets[uint8(Roles.beneficiary)], 0, 0, 4);
1225         }
1226     }
1227 
1228 
1229     // We accept payments other than Ethereum (ETH) and other currencies, for example, Bitcoin (BTC).
1230     // Perhaps other types of cryptocurrency - see the original terms in the white paper and on the TokenSale website.
1231 
1232     // We release tokens on Ethereum. During the Round1 and Round2 with a smart contract, you directly transfer
1233     // the tokens there and immediately, with the same transaction, receive tokens in your wallet.
1234 
1235     // When paying in any other currency, for example in BTC, we accept your money via one common wallet.
1236     // Our manager fixes the amount received for the bitcoin wallet and calls the method of the smart
1237     // contract paymentsInOtherCurrency to inform him how much foreign currency has been received - on a daily basis.
1238     // The smart contract pins the number of accepted ETH directly and the number of BTC. Smart contract
1239     // monitors softcap and hardcap, so as not to go beyond this framework.
1240 
1241     // In theory, it is possible that when approaching hardcap, we will receive a transfer (one or several
1242     // transfers) to the wallet of BTC, that together with previously received money will exceed the hardcap in total.
1243     // In this case, we will refund all the amounts above, in order not to exceed the hardcap.
1244 
1245     // Collection of money in BTC will be carried out via one common wallet. The wallet's address will be published
1246     // everywhere (in a white paper, on the TokenSale website, on Telegram, on Bitcointalk, in this code, etc.)
1247     // Anyone interested can check that the administrator of the smart contract writes down exactly the amount
1248     // in ETH (in equivalent for BTC) there. In theory, the ability to bypass a smart contract to accept money in
1249     // BTC and not register them in ETH creates a possibility for manipulation by the company. Thanks to
1250     // paymentsInOtherCurrency however, this threat is leveled.
1251 
1252     // Any user can check the amounts in BTC and the variable of the smart contract that accounts for this
1253     // (paymentsInOtherCurrency method). Any user can easily check the incoming transactions in a smart contract
1254     // on a daily basis. Any hypothetical tricks on the part of the company can be exposed and panic during the TokenSale,
1255     // simply pointing out the incompatibility of paymentsInOtherCurrency (ie, the amount of ETH + BTC collection)
1256     // and the actual transactions in BTC. The company strictly adheres to the described principles of openness.
1257 
1258     // The company administrator is required to synchronize paymentsInOtherCurrency every working day (but you
1259     // cannot synchronize if there are no new BTC payments). In the case of unforeseen problems, such as
1260     // brakes on the Ethereum network, this operation may be difficult. You should only worry if the
1261     // administrator does not synchronize the amount for more than 96 hours in a row, and the BTC wallet
1262     // receives significant amounts.
1263 
1264     // This scenario ensures that for the sum of all fees in all currencies this value does not exceed hardcap.
1265 
1266     // ** QUINTILLIONS ** 10^18 / 1**18 / 1e18
1267 
1268     // @ Do I have to use the function      no
1269     // @ When it is possible to call        during active rounds
1270     // @ When it is launched automatically  every day from cryptob2b token software
1271     // @ Who can call the function          admins + observer
1272     function paymentsInOtherCurrency(uint256 _token, uint256 _value) public {
1273 
1274         // For audit:
1275         // BTC  13vL9G4Gt2BX58qQQfauf9JbFFjC5pEnQy
1276         // XRP  rHG2nJCKYEe326zhTtXWVEeDob81VKkK3q
1277         // DASH XcMZbRJzPghTcZPyScF21mL3eKhYAGo4Ab
1278         // LTC  LcKTi2ZduMvHo7WbXye2RhLy9xMZjdXWZS
1279 
1280         require(wallets[uint8(Roles.observer)] == msg.sender || wallets[uint8(Roles.manager)] == msg.sender);
1281         //onlyAdmin(true);
1282         bool withinPeriod = (now >= startTime && now <= endTime.add(renewal));
1283 
1284         bool withinCap = _value.add(ethWeiRaised) <= hardCap.add(overLimit);
1285         require(withinPeriod && withinCap && isInitialized);
1286 
1287         nonEthWeiRaised = _value;
1288         tokenReserved = _token;
1289 
1290     }
1291 
1292     function lokedMint(address _beneficiary, uint256 _value, uint256 _freezeTime) internal {
1293         if(_freezeTime > 0){
1294 
1295             uint256 totalBloked = token.freezedTokenOf(_beneficiary).add(_value);
1296             uint256 pastDateUnfreeze = token.defrostDate(_beneficiary);
1297             uint256 newDateUnfreeze = _freezeTime.add(now);
1298             newDateUnfreeze = (pastDateUnfreeze > newDateUnfreeze ) ? pastDateUnfreeze : newDateUnfreeze;
1299 
1300             token.freezeTokens(_beneficiary,totalBloked,newDateUnfreeze);
1301         }
1302         token.mint(_beneficiary,_value);
1303     }
1304 
1305 
1306     // The function for obtaining smart contract funds in ETH. If all the checks are true, the token is
1307     // transferred to the buyer, taking into account the current bonus.
1308     function buyTokens(address beneficiary) public payable {
1309         require(beneficiary != 0x0);
1310         require(validPurchase());
1311 
1312         uint256 weiAmount = msg.value;
1313 
1314         uint256 ProfitProcent = getProfitPercent();
1315 
1316         uint256 value;
1317         uint256 percent;
1318         uint256 freezeTime;
1319 
1320         (value,
1321         percent,
1322         freezeTime) = getBonuses(weiAmount);
1323 
1324         Bonus memory curBonus = Bonus(value,percent,freezeTime);
1325 
1326         uint256 bonus = curBonus.procent;
1327 
1328         // --------------------------------------------------------------------------------------------
1329         // *** Scenario 1 - select max from all bonuses + check maxAllProfit
1330         //uint256 totalProfit = (ProfitProcent < bonus) ? bonus : ProfitProcent;
1331         // *** Scenario 2 - sum both bonuses + check maxAllProfit
1332         uint256 totalProfit = bonus.add(ProfitProcent);
1333         // --------------------------------------------------------------------------------------------
1334         totalProfit = (totalProfit > maxAllProfit) ? maxAllProfit : totalProfit;
1335 
1336         // calculate token amount to be created
1337         uint256 tokens = weiAmount.mul(rate).mul(totalProfit.add(100)).div(100 ether);
1338 
1339         // update state
1340         ethWeiRaised = ethWeiRaised.add(weiAmount);
1341 
1342         lokedMint(beneficiary, tokens, curBonus.freezeTime);
1343 
1344         emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
1345 
1346         forwardFunds();
1347     }
1348 
1349     // buyTokens alias
1350     function () public payable {
1351         buyTokens(msg.sender);
1352     }
1353 }
1354 
1355 contract MigratableToken is BasicToken,Ownable {
1356 
1357     uint256 public totalMigrated;
1358     address public migrationAgent;
1359 
1360     event Migrate(address indexed _from, address indexed _to, uint256 _value);
1361 
1362     function setMigrationAgent(address _migrationAgent) public onlyOwner {
1363         require(migrationAgent == 0x0);
1364         migrationAgent = _migrationAgent;
1365     }
1366 
1367 
1368     function migrateInternal(address _holder) internal{
1369         require(migrationAgent != 0x0);
1370 
1371         uint256 value = balances[_holder];
1372         balances[_holder] = 0;
1373 
1374         totalSupply_ = totalSupply_.sub(value);
1375         totalMigrated = totalMigrated.add(value);
1376 
1377         MigrationAgent(migrationAgent).migrateFrom(_holder, value);
1378         emit Migrate(_holder,migrationAgent,value);
1379     }
1380 
1381     function migrateAll(address[] _holders) public onlyOwner {
1382         for(uint i = 0; i < _holders.length; i++){
1383             migrateInternal(_holders[i]);
1384         }
1385     }
1386 
1387     // Reissue your tokens.
1388     function migrate() public
1389     {
1390         require(balances[msg.sender] > 0);
1391         migrateInternal(msg.sender);
1392     }
1393 
1394 }
1395 
1396 contract BurnableToken is BasicToken, Ownable {
1397 
1398     event Burn(address indexed burner, uint256 value);
1399 
1400     /**
1401      * @dev Burns a specific amount of tokens.
1402      * @param _value The amount of token to be burned.
1403      */
1404     function burn(address _beneficiary, uint256 _value) public onlyOwner {
1405         require(_value <= balances[_beneficiary]);
1406         // no need to require value <= totalSupply, since that would imply the
1407         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
1408 
1409         balances[_beneficiary] = balances[_beneficiary].sub(_value);
1410         totalSupply_ = totalSupply_.sub(_value);
1411         emit Burn(_beneficiary, _value);
1412         emit Transfer(_beneficiary, address(0), _value);
1413     }
1414 }
1415 
1416 contract Pausable is Ownable {
1417 
1418     mapping (address => bool) public unpausedWallet;
1419 
1420     event Pause();
1421     event Unpause();
1422 
1423     bool public paused = true;
1424 
1425 
1426     /**
1427      * @dev Modifier to make a function callable only when the contract is not paused.
1428      */
1429     modifier whenNotPaused(address _to) {
1430         require(!paused||unpausedWallet[msg.sender]||unpausedWallet[_to]);
1431         _;
1432     }
1433 
1434     function onlyAdmin() internal view {
1435         require(owner == msg.sender || msg.sender == ICrowdsale(owner).wallets(uint8(ICrowdsale.Roles.manager)));
1436     }
1437 
1438     // Add a wallet ignoring the "Exchange pause". Available to the owner of the contract.
1439     function setUnpausedWallet(address _wallet, bool mode) public {
1440         onlyAdmin();
1441         unpausedWallet[_wallet] = mode;
1442     }
1443 
1444     /**
1445      * @dev called by the owner to pause, triggers stopped state
1446      */
1447     function setPause(bool mode) onlyOwner public {
1448 
1449         if (!paused && mode) {
1450             paused = true;
1451             emit Pause();
1452         }
1453         if (paused && !mode) {
1454             paused = false;
1455             emit Unpause();
1456         }
1457     }
1458 
1459 }
1460 
1461 contract PausableToken is StandardToken, Pausable {
1462 
1463     function transfer(address _to, uint256 _value) public whenNotPaused(_to) returns (bool) {
1464         return super.transfer(_to, _value);
1465     }
1466 
1467     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused(_to) returns (bool) {
1468         return super.transferFrom(_from, _to, _value);
1469     }
1470 }
1471 
1472 contract FreezingToken is PausableToken {
1473     struct freeze {
1474     uint256 amount;
1475     uint256 when;
1476     }
1477 
1478 
1479     mapping (address => freeze) freezedTokens;
1480 
1481     function freezedTokenOf(address _beneficiary) public view returns (uint256 amount){
1482         freeze storage _freeze = freezedTokens[_beneficiary];
1483         if(_freeze.when < now) return 0;
1484         return _freeze.amount;
1485     }
1486 
1487     function defrostDate(address _beneficiary) public view returns (uint256 Date) {
1488         freeze storage _freeze = freezedTokens[_beneficiary];
1489         if(_freeze.when < now) return 0;
1490         return _freeze.when;
1491     }
1492 
1493     function freezeTokens(address _beneficiary, uint256 _amount, uint256 _when) public {
1494         onlyAdmin();
1495         freeze storage _freeze = freezedTokens[_beneficiary];
1496         _freeze.amount = _amount;
1497         _freeze.when = _when;
1498     }
1499 
1500     function masFreezedTokens(address[] _beneficiary, uint256[] _amount, uint256[] _when) public {
1501         onlyAdmin();
1502         require(_beneficiary.length == _amount.length && _beneficiary.length == _when.length);
1503         for(uint16 i = 0; i < _beneficiary.length; i++){
1504             freeze storage _freeze = freezedTokens[_beneficiary[i]];
1505             _freeze.amount = _amount[i];
1506             _freeze.when = _when[i];
1507         }
1508     }
1509 
1510 
1511     function transferAndFreeze(address _to, uint256 _value, uint256 _when) external {
1512         require(unpausedWallet[msg.sender]);
1513         if(_when > 0){
1514             freeze storage _freeze = freezedTokens[_to];
1515             _freeze.amount = _freeze.amount.add(_value);
1516             _freeze.when = (_freeze.when > _when)? _freeze.when: _when;
1517         }
1518         transfer(_to,_value);
1519     }
1520 
1521     function transfer(address _to, uint256 _value) public returns (bool) {
1522         require(balanceOf(msg.sender) >= freezedTokenOf(msg.sender).add(_value));
1523         return super.transfer(_to,_value);
1524     }
1525 
1526     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
1527         require(balanceOf(_from) >= freezedTokenOf(_from).add(_value));
1528         return super.transferFrom( _from,_to,_value);
1529     }
1530 
1531 
1532 
1533 }
1534 
1535 contract Token is IToken, FreezingToken, MintableToken, MigratableToken, BurnableToken{
1536     string public constant name = "BUZcoin";
1537     string public constant symbol = "BUZ";
1538     uint8 public constant decimals = 18;
1539 }
1540 
1541 contract Creator is ICreator{
1542     IToken public token = new Token();
1543     IFinancialStrategy public financialStrategy = new BuzFinancialStrategy();
1544 
1545     function createToken() external returns (IToken) {
1546         Token(token).transferOwnership(msg.sender);
1547         return token;
1548     }
1549 
1550     function createFinancialStrategy() external returns(IFinancialStrategy) {
1551         BuzFinancialStrategy(financialStrategy).transferOwnership(msg.sender);
1552         return financialStrategy;
1553     }
1554 }