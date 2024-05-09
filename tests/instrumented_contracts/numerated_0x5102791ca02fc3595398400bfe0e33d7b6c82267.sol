1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 
35 /**
36  * @title Ownable
37  * @dev The Ownable contract has an owner address, and provides basic authorization control
38  * functions, this simplifies the implementation of "user permissions".
39  */
40 contract Ownable {
41   address public owner;
42 
43 
44   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46 
47   /**
48    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
49    * account.
50    */
51   function Ownable() public {
52     owner = msg.sender;
53   }
54 
55 
56   /**
57    * @dev Throws if called by any account other than the owner.
58    */
59   modifier onlyOwner() {
60     require(msg.sender == owner);
61     _;
62   }
63 
64 
65   /**
66    * @dev Allows the current owner to transfer control of the contract to a newOwner.
67    * @param newOwner The address to transfer ownership to.
68    */
69   function transferOwnership(address newOwner) public onlyOwner {
70     require(newOwner != address(0));
71     OwnershipTransferred(owner, newOwner);
72     owner = newOwner;
73   }
74 
75 }
76 
77 
78 
79 
80 /**
81  * @title Claimable
82  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
83  * This allows the new owner to accept the transfer.
84  */
85 contract Claimable is Ownable {
86     address public pendingOwner;
87 
88     /**
89      * @dev Modifier throws if called by any account other than the pendingOwner.
90      */
91     modifier onlyPendingOwner() {
92         require(msg.sender == pendingOwner);
93         _;
94     }
95 
96     /**
97      * @dev Allows the current owner to set the pendingOwner address.
98      * @param newOwner The address to transfer ownership to.
99      */
100     function transferOwnership(address newOwner) onlyOwner public {
101         pendingOwner = newOwner;
102     }
103 
104     /**
105      * @dev Allows the pendingOwner address to finalize the transfer.
106      */
107     function claimOwnership() onlyPendingOwner public {
108         OwnershipTransferred(owner, pendingOwner);
109         owner = pendingOwner;
110         pendingOwner = address(0);
111     }
112 }
113 
114 
115 /**
116  * @title ERC20Basic
117  * @dev Simpler version of ERC20 interface
118  * @dev see https://github.com/ethereum/EIPs/issues/179
119  */
120 contract ERC20Basic {
121   uint256 public totalSupply;
122   function balanceOf(address who) public view returns (uint256);
123   function transfer(address to, uint256 value) public returns (bool);
124   event Transfer(address indexed from, address indexed to, uint256 value);
125 }
126 
127 
128 
129 
130 /**
131  * @title ERC20 interface
132  * @dev see https://github.com/ethereum/EIPs/issues/20
133  */
134 contract ERC20 is ERC20Basic {
135   function allowance(address owner, address spender) public view returns (uint256);
136   function transferFrom(address from, address to, uint256 value) public returns (bool);
137   function approve(address spender, uint256 value) public returns (bool);
138   event Approval(address indexed owner, address indexed spender, uint256 value);
139 }
140 
141 
142 
143 
144 /**
145  * @title Basic token
146  * @dev Basic version of StandardToken, with no allowances.
147  */
148 contract BasicToken is ERC20Basic {
149   using SafeMath for uint256;
150 
151   mapping(address => uint256) balances;
152 
153   /**
154   * @dev transfer token for a specified address
155   * @param _to The address to transfer to.
156   * @param _value The amount to be transferred.
157   */
158   function transfer(address _to, uint256 _value) public returns (bool) {
159     require(_to != address(0));
160     require(_value <= balances[msg.sender]);
161 
162     // SafeMath.sub will throw if there is not enough balance.
163     balances[msg.sender] = balances[msg.sender].sub(_value);
164     balances[_to] = balances[_to].add(_value);
165     Transfer(msg.sender, _to, _value);
166     return true;
167   }
168 
169   /**
170   * @dev Gets the balance of the specified address.
171   * @param _owner The address to query the the balance of.
172   * @return An uint256 representing the amount owned by the passed address.
173   */
174   function balanceOf(address _owner) public view returns (uint256 balance) {
175     return balances[_owner];
176   }
177 
178 }
179 
180 
181 /**
182  * @title LimitedTransferToken
183  * @dev LimitedTransferToken defines the generic interface and the implementation to limit token
184  * transferability for different events. It is intended to be used as a base class for other token
185  * contracts.
186  * LimitedTransferToken has been designed to allow for different limiting factors,
187  * this can be achieved by recursively calling super.transferableTokens() until the base class is
188  * hit. For example:
189  *     function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
190  *       return min256(unlockedTokens, super.transferableTokens(holder, time));
191  *     }
192  * A working example is VestedToken.sol:
193  * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/VestedToken.sol
194  */
195 
196 contract LimitedTransferToken is ERC20 {
197 
198   /**
199    * @dev Checks whether it can transfer or otherwise throws.
200    */
201   modifier canTransfer(address _sender, uint256 _value) {
202    require(_value <= transferableTokens(_sender, uint64(now)));
203    _;
204   }
205 
206   /**
207    * @dev Checks modifier and allows transfer if tokens are not locked.
208    * @param _to The address that will receive the tokens.
209    * @param _value The amount of tokens to be transferred.
210    */
211   function transfer(address _to, uint256 _value) canTransfer(msg.sender, _value) public returns (bool) {
212     return super.transfer(_to, _value);
213   }
214 
215   /**
216   * @dev Checks modifier and allows transfer if tokens are not locked.
217   * @param _from The address that will send the tokens.
218   * @param _to The address that will receive the tokens.
219   * @param _value The amount of tokens to be transferred.
220   */
221   function transferFrom(address _from, address _to, uint256 _value) canTransfer(_from, _value) public returns (bool) {
222     return super.transferFrom(_from, _to, _value);
223   }
224 
225   /**
226    * @dev Default transferable tokens function returns all tokens for a holder (no limit).
227    * @dev Overwriting transferableTokens(address holder, uint64 time) is the way to provide the
228    * specific logic for limiting token transferability for a holder over time.
229    */
230   function transferableTokens(address holder, uint64 time) public view returns (uint256) {
231     return balanceOf(holder);
232   }
233 }
234 
235 
236 
237 
238 /**
239  * @title Standard ERC20 token
240  *
241  * @dev Implementation of the basic standard token.
242  * @dev https://github.com/ethereum/EIPs/issues/20
243  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
244  */
245 contract StandardToken is ERC20, BasicToken {
246 
247   mapping (address => mapping (address => uint256)) internal allowed;
248 
249 
250   /**
251    * @dev Transfer tokens from one address to another
252    * @param _from address The address which you want to send tokens from
253    * @param _to address The address which you want to transfer to
254    * @param _value uint256 the amount of tokens to be transferred
255    */
256   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
257     require(_to != address(0));
258     require(_value <= balances[_from]);
259     require(_value <= allowed[_from][msg.sender]);
260 
261     balances[_from] = balances[_from].sub(_value);
262     balances[_to] = balances[_to].add(_value);
263     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
264     Transfer(_from, _to, _value);
265     return true;
266   }
267 
268   /**
269    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
270    *
271    * Beware that changing an allowance with this method brings the risk that someone may use both the old
272    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
273    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
274    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
275    * @param _spender The address which will spend the funds.
276    * @param _value The amount of tokens to be spent.
277    */
278   function approve(address _spender, uint256 _value) public returns (bool) {
279     allowed[msg.sender][_spender] = _value;
280     Approval(msg.sender, _spender, _value);
281     return true;
282   }
283 
284   /**
285    * @dev Function to check the amount of tokens that an owner allowed to a spender.
286    * @param _owner address The address which owns the funds.
287    * @param _spender address The address which will spend the funds.
288    * @return A uint256 specifying the amount of tokens still available for the spender.
289    */
290   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
291     return allowed[_owner][_spender];
292   }
293 
294   /**
295    * approve should be called when allowed[_spender] == 0. To increment
296    * allowed value is better to use this function to avoid 2 calls (and wait until
297    * the first transaction is mined)
298    * From MonolithDAO Token.sol
299    */
300   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
301     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
302     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
303     return true;
304   }
305 
306   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
307     uint oldValue = allowed[msg.sender][_spender];
308     if (_subtractedValue > oldValue) {
309       allowed[msg.sender][_spender] = 0;
310     } else {
311       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
312     }
313     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
314     return true;
315   }
316 
317 }
318 
319 
320 
321 
322 /**
323  * @title Mintable token
324  * @dev Simple ERC20 Token example, with mintable token creation
325  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
326  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
327  */
328 
329 contract MintableToken is StandardToken, Claimable {
330   event Mint(address indexed to, uint256 amount);
331   event MintFinished();
332 
333   bool public mintingFinished = false;
334 
335 
336   modifier canMint() {
337     require(!mintingFinished);
338     _;
339   }
340 
341   /**
342    * @dev Function to mint tokens
343    * @param _to The address that will receive the minted tokens.
344    * @param _amount The amount of tokens to mint.
345    * @return A boolean that indicates if the operation was successful.
346    */
347   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
348     totalSupply = totalSupply.add(_amount);
349     balances[_to] = balances[_to].add(_amount);
350     Mint(_to, _amount);
351     Transfer(address(0), _to, _amount);
352     return true;
353   }
354 
355   /**
356    * @dev Function to stop minting new tokens.
357    * @return True if the operation was successful.
358    */
359   function finishMinting() onlyOwner public returns (bool) {
360     mintingFinished = true;
361     MintFinished();
362     return true;
363   }
364 }
365 
366 /*
367     Smart Token interface
368 */
369 contract ISmartToken {
370 
371     // =================================================================================================================
372     //                                      Members
373     // =================================================================================================================
374 
375     bool public transfersEnabled = false;
376 
377     // =================================================================================================================
378     //                                      Event
379     // =================================================================================================================
380 
381     // triggered when a smart token is deployed - the _token address is defined for forward compatibility, in case we want to trigger the event from a factory
382     event NewSmartToken(address _token);
383     // triggered when the total supply is increased
384     event Issuance(uint256 _amount);
385     // triggered when the total supply is decreased
386     event Destruction(uint256 _amount);
387 
388     // =================================================================================================================
389     //                                      Functions
390     // =================================================================================================================
391 
392     function disableTransfers(bool _disable) public;
393     function issue(address _to, uint256 _amount) public;
394     function destroy(address _from, uint256 _amount) public;
395 }
396 
397 
398 /**
399     BancorSmartToken
400 */
401 contract LimitedTransferBancorSmartToken is MintableToken, ISmartToken, LimitedTransferToken {
402 
403     // =================================================================================================================
404     //                                      Modifiers
405     // =================================================================================================================
406 
407     /**
408      * @dev Throws if destroy flag is not enabled.
409      */
410     modifier canDestroy() {
411         require(destroyEnabled);
412         _;
413     }
414 
415     // =================================================================================================================
416     //                                      Members
417     // =================================================================================================================
418 
419     // We add this flag to avoid users and owner from destroy tokens during crowdsale,
420     // This flag is set to false by default and blocks destroy function,
421     // We enable destroy option on finalize, so destroy will be possible after the crowdsale.
422     bool public destroyEnabled = false;
423 
424     // =================================================================================================================
425     //                                      Public Functions
426     // =================================================================================================================
427 
428     function setDestroyEnabled(bool _enable) onlyOwner public {
429         destroyEnabled = _enable;
430     }
431 
432     // =================================================================================================================
433     //                                      Impl ISmartToken
434     // =================================================================================================================
435 
436     //@Override
437     function disableTransfers(bool _disable) onlyOwner public {
438         transfersEnabled = !_disable;
439     }
440 
441     //@Override
442     function issue(address _to, uint256 _amount) onlyOwner public {
443         require(super.mint(_to, _amount));
444         Issuance(_amount);
445     }
446 
447     //@Override
448     function destroy(address _from, uint256 _amount) canDestroy public {
449 
450         require(msg.sender == _from || msg.sender == owner); // validate input
451 
452         balances[_from] = balances[_from].sub(_amount);
453         totalSupply = totalSupply.sub(_amount);
454 
455         Destruction(_amount);
456         Transfer(_from, 0x0, _amount);
457     }
458 
459     // =================================================================================================================
460     //                                      Impl LimitedTransferToken
461     // =================================================================================================================
462 
463 
464     // Enable/Disable token transfer
465     // Tokens will be locked in their wallets until the end of the Crowdsale.
466     // @holder - token`s owner
467     // @time - not used (framework unneeded functionality)
468     //
469     // @Override
470     function transferableTokens(address holder, uint64 time) public constant returns (uint256) {
471         require(transfersEnabled);
472         return super.transferableTokens(holder, time);
473     }
474 }
475 
476 /*
477     We consider every contract to be a 'token holder' since it's currently not possible
478     for a contract to deny receiving tokens.
479 
480     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
481     the owner to send tokens that were sent to the contract by mistake back to their sender.
482 */
483 contract TokenHolder is Ownable {
484     /**
485         @dev constructor
486     */
487     function TokenHolder() {
488     }
489 
490     /**
491         @dev withdraws tokens held by the contract and sends them to an account
492         can only be called by the owner
493 
494         @param _token   ERC20 token contract address
495         @param _to      account to receive the new amount
496         @param _amount  amount to withdraw
497     */
498     function withdrawTokens(StandardToken _token, address _to, uint256 _amount) public onlyOwner {
499         require(_token != address(0));
500         require(_to != address(0));
501         require(_to != address(this));
502         assert(_token.transfer(_to, _amount));
503     }
504 }
505 
506 
507 
508 
509 /**
510   A Token which is 'Bancor' compatible and can mint new tokens and pause token-transfer functionality
511 */
512 contract LeadcoinSmartToken is TokenHolder, LimitedTransferBancorSmartToken {
513 
514     // =================================================================================================================
515     //                                         Members
516     // =================================================================================================================
517 
518     string public name = "LEADCOIN";
519 
520     string public symbol = "LDC";
521 
522     uint8 public decimals = 18;
523 
524     // =================================================================================================================
525     //                                         Constructor
526     // =================================================================================================================
527 
528     function LeadcoinSmartToken() public {
529         //Apart of 'Bancor' computability - triggered when a smart token is deployed
530         NewSmartToken(address(this));
531     }
532 }
533 
534 
535 
536 /**
537  * @title Crowdsale
538  * @dev Crowdsale is a base contract for managing a token crowdsale.
539  * Crowdsales have a start and end timestamps, where investors can make
540  * token purchases and the crowdsale will assign them tokens based
541  * on a token per ETH rate. Funds collected are forwarded to a wallet
542  * as they arrive.
543  */
544 contract Crowdsale {
545     using SafeMath for uint256;
546 
547     // The token being sold
548     LeadcoinSmartToken public token;
549 
550     // start and end timestamps where investments are allowed (both inclusive)
551     uint256 public startTime;
552 
553     uint256 public endTime;
554 
555     // address where funds are collected
556     address public wallet;
557 
558     // how many token units a buyer gets per wei
559     uint256 public rate;
560 
561     // amount of raised money in wei
562     uint256 public weiRaised;
563 
564     /**
565      * event for token purchase logging
566      * @param purchaser who paid for the tokens
567      * @param beneficiary who got the tokens
568      * @param value weis paid for purchase
569      * @param amount amount of tokens purchased
570      */
571     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
572 
573     function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, LeadcoinSmartToken _token) public {
574         require(_startTime >= now);
575         require(_endTime >= _startTime);
576         require(_rate > 0);
577         require(_wallet != address(0));
578         require(_token != address(0));
579 
580         startTime = _startTime;
581         endTime = _endTime;
582         rate = _rate;
583         wallet = _wallet;
584         token = _token;
585     }
586 
587     // fallback function can be used to buy tokens
588     function() external payable {
589         buyTokens(msg.sender);
590     }
591 
592     // low level token purchase function
593     function buyTokens(address beneficiary) public payable {
594         require(beneficiary != address(0));
595         require(validPurchase());
596 
597         uint256 weiAmount = msg.value;
598 
599         // calculate token amount to be created
600         uint256 tokens = weiAmount.mul(rate);
601 
602         // update state
603         weiRaised = weiRaised.add(weiAmount);
604 
605         token.issue(beneficiary, tokens);
606         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
607 
608         forwardFunds();
609     }
610 
611     // send ether to the fund collection wallet
612     // override to create custom fund forwarding mechanisms
613     function forwardFunds() internal {
614         wallet.transfer(msg.value);
615     }
616 
617     // @return true if the transaction can buy tokens
618     function validPurchase() internal view returns (bool) {
619         bool withinPeriod = now >= startTime && now <= endTime;
620         bool nonZeroPurchase = msg.value != 0;
621         return withinPeriod && nonZeroPurchase;
622     }
623 
624     // @return true if crowdsale event has ended
625     function hasEnded() public view returns (bool) {
626         return now > endTime;
627     }
628 
629 }
630 
631 
632 /**
633  * @title FinalizableCrowdsale
634  * @dev Extension of Crowdsale where an owner can do extra work
635  * after finishing.
636  */
637 contract FinalizableCrowdsale is Crowdsale, Claimable {
638   using SafeMath for uint256;
639 
640   bool public isFinalized = false;
641 
642   event Finalized();
643 
644   /**
645    * @dev Must be called after crowdsale ends, to do some extra finalization
646    * work. Calls the contract's finalization function.
647    */
648   function finalize() onlyOwner public {
649     require(!isFinalized);
650     require(hasEnded());
651 
652     finalization();
653     Finalized();
654 
655     isFinalized = true;
656   }
657 
658   /**
659    * @dev Can be overridden to add finalization logic. The overriding function
660    * should call super.finalization() to ensure the chain of finalization is
661    * executed entirely.
662    */
663   function finalization() internal {
664   }
665 }
666 
667 
668 
669 
670 contract LeadcoinCrowdsale is TokenHolder,FinalizableCrowdsale {
671 
672     // =================================================================================================================
673     //                                      Constants
674     // =================================================================================================================
675     // Max amount of known addresses of which will get LDC by 'Grant' method.
676     //
677     // grantees addresses will be LeadcoinLabs wallets addresses.
678     // these wallets will contain LDC tokens that will be used for 2 purposes only -
679     // 1. LDC tokens against raised fiat money
680     // 2. LDC tokens for presale bonus.
681     // we set the value to 10 (and not to 2) because we want to allow some flexibility for cases like fiat money that is raised close to the crowdsale.
682     // we limit the value to 10 (and not larger) to limit the run time of the function that process the grantees array.
683     uint8 public constant MAX_TOKEN_GRANTEES = 10;
684 
685     //we limit the amount of tokens we can mint to a grantee so it won't be exploit.
686     uint256 public constant MAX_GRANTEE_TOKENS_ALLOWED = 250000000 * 10 ** 18;    
687 
688     // LDC to ETH base rate
689     uint256 public constant EXCHANGE_RATE = 15000;
690 
691     // =================================================================================================================
692     //                                      Modifiers
693     // =================================================================================================================
694 
695     /**
696      * @dev Throws if called after crowdsale was finalized
697      */
698     modifier beforeFinzalized() {
699         require(!isFinalized);
700         _;
701     }
702     /**
703      * @dev Throws if called before crowdsale start time
704      */
705     modifier notBeforeSaleStarts() {
706         require(now >= startTime);
707         _;
708     }
709    /**
710      * @dev Throws if called not during the crowdsale time frame
711      */
712     modifier onlyWhileSale() {
713         require(now >= startTime && now < endTime);
714         _;
715     }
716 
717     // =================================================================================================================
718     //                                      Members
719     // =================================================================================================================
720 
721     // wallets address for 50% of LDC allocation
722     address public walletTeam;   //10% of the total number of LDC tokens will be allocated to the team
723     address public walletWebydo;       //10% of the total number of LDC tokens will be allocated to Webydo Ltd.
724     address public walletReserve;   //30% of the total number of LDC tokens will be allocated to Leadcoin reserves
725 
726 
727     // Funds collected outside the crowdsale in wei
728     uint256 public fiatRaisedConvertedToWei;
729 
730     //Grantees - used for non-ether and presale bonus token generation
731     address[] public presaleGranteesMapKeys;
732     mapping (address => uint256) public presaleGranteesMap;  //address=>wei token amount
733 
734     // Hard cap in Wei
735     uint256 public hardCap;
736 
737 
738     // =================================================================================================================
739     //                                      Events
740     // =================================================================================================================
741     event GrantAdded(address indexed _grantee, uint256 _amount);
742 
743     event GrantUpdated(address indexed _grantee, uint256 _oldAmount, uint256 _newAmount);
744 
745     event GrantDeleted(address indexed _grantee, uint256 _hadAmount);
746 
747     event FiatRaisedUpdated(address indexed _address, uint256 _fiatRaised);
748 
749     // =================================================================================================================
750     //                                      Constructors
751     // =================================================================================================================
752 
753     function LeadcoinCrowdsale(uint256 _startTime,
754     uint256 _endTime,
755     address _wallet,
756     address _walletTeam,
757     address _walletWebydo,
758     address _walletReserve,
759     uint256 _cap,
760     LeadcoinSmartToken _leadcoinSmartToken)
761     public
762     Crowdsale(_startTime, _endTime, EXCHANGE_RATE, _wallet, _leadcoinSmartToken) {
763         require(_walletTeam != address(0));
764         require(_walletWebydo != address(0));
765         require(_walletReserve != address(0));
766         require(_leadcoinSmartToken != address(0));
767         require(_cap > 0);
768 
769         walletTeam = _walletTeam;
770         walletWebydo = _walletWebydo;
771         walletReserve = _walletReserve;
772 
773         token = _leadcoinSmartToken;
774 
775         hardCap = _cap;
776 
777     }
778 
779 
780     // =================================================================================================================
781     //                                      Impl FinalizableCrowdsale
782     // =================================================================================================================
783 
784     //@Override
785     function finalization() internal onlyOwner {
786         super.finalization();
787 
788         // granting bonuses for the pre crowdsale grantees:
789         for (uint256 i = 0; i < presaleGranteesMapKeys.length; i++) {
790             token.issue(presaleGranteesMapKeys[i], presaleGranteesMap[presaleGranteesMapKeys[i]]);
791         }
792 
793         // Adding 50% of the total token supply (50% were generated during the crowdsale)
794         // 50 * 2 = 100
795         uint256 newTotalSupply = token.totalSupply().mul(200).div(100);
796 
797         // 10% of the total number of LDC tokens will be allocated to the team
798         token.issue(walletTeam, newTotalSupply.mul(10).div(100));
799 
800         // 10% of the total number of LDC tokens will be allocated to Webydo Ltd.
801         token.issue(walletWebydo, newTotalSupply.mul(10).div(100));
802 
803         // 30% of the total number of LDC tokens will be allocated Leadcoin reserves
804         token.issue(walletReserve, newTotalSupply.mul(30).div(100));
805 
806         // Re-enable transfers after the token sale.
807         token.disableTransfers(false);
808 
809         // Re-enable destroy function after the token sale.
810         token.setDestroyEnabled(true);
811 
812         // transfer token ownership to crowdsale owner
813         token.transferOwnership(owner);
814 
815     }
816 
817     // =================================================================================================================
818     //                                      Public Methods
819     // =================================================================================================================
820     // @return the total funds collected in wei(ETH and none ETH).
821     function getTotalFundsRaised() public view returns (uint256) {
822         return fiatRaisedConvertedToWei.add(weiRaised);
823     }
824 
825      // overriding Crowdsale#hasEnded to add cap logic
826     // @return true if crowdsale event has ended
827     function hasEnded() public view returns (bool) {
828         bool capReached = getTotalFundsRaised() >= hardCap;
829         return capReached || super.hasEnded();
830     }
831 
832     // overriding Crowdsale#validPurchase to add extra cap logic
833     // @return true if investors can buy at the moment
834     function validPurchase() internal view returns (bool) {
835         bool withinCap = getTotalFundsRaised() < hardCap;
836         return withinCap && super.validPurchase();
837     }
838 
839     // =================================================================================================================
840     //                                      External Methods
841     // =================================================================================================================
842     // @dev Adds/Updates address and token allocation for token grants.
843     // Granted tokens are allocated to non-ether, presale, buyers.
844     // @param _grantee address The address of the token grantee.
845     // @param _value uint256 The value of the grant in wei token.
846     function addUpdateGrantee(address _grantee, uint256 _value) external onlyOwner notBeforeSaleStarts beforeFinzalized {
847         require(_grantee != address(0));
848         require(_value > 0 && _value <= MAX_GRANTEE_TOKENS_ALLOWED);
849         
850         // Adding new key if not present:
851         if (presaleGranteesMap[_grantee] == 0) {
852             require(presaleGranteesMapKeys.length < MAX_TOKEN_GRANTEES);
853             presaleGranteesMapKeys.push(_grantee);
854             GrantAdded(_grantee, _value);
855         } else {
856             GrantUpdated(_grantee, presaleGranteesMap[_grantee], _value);
857         }
858 
859         presaleGranteesMap[_grantee] = _value;
860     }
861 
862     // @dev deletes entries from the grants list.
863     // @param _grantee address The address of the token grantee.
864     function deleteGrantee(address _grantee) external onlyOwner notBeforeSaleStarts beforeFinzalized {
865         require(_grantee != address(0));
866         require(presaleGranteesMap[_grantee] != 0);
867 
868         //delete from the map:
869         delete presaleGranteesMap[_grantee];
870 
871         //delete from the array (keys):
872         uint256 index;
873         for (uint256 i = 0; i < presaleGranteesMapKeys.length; i++) {
874             if (presaleGranteesMapKeys[i] == _grantee) {
875                 index = i;
876                 break;
877             }
878         }
879         presaleGranteesMapKeys[index] = presaleGranteesMapKeys[presaleGranteesMapKeys.length - 1];
880         delete presaleGranteesMapKeys[presaleGranteesMapKeys.length - 1];
881         presaleGranteesMapKeys.length--;
882 
883         GrantDeleted(_grantee, presaleGranteesMap[_grantee]);
884     }
885 
886     // @dev Set funds collected outside the crowdsale in wei.
887     //  note: we not to use accumulator to allow flexibility in case of humane mistakes.
888     // funds are converted to wei using the market conversion rate of USD\ETH on the day on the purchase.
889     // @param _fiatRaisedConvertedToWei number of none eth raised.
890     function setFiatRaisedConvertedToWei(uint256 _fiatRaisedConvertedToWei) external onlyOwner onlyWhileSale {
891         fiatRaisedConvertedToWei = _fiatRaisedConvertedToWei;
892         FiatRaisedUpdated(msg.sender, fiatRaisedConvertedToWei);
893     }
894 
895 
896     /// @dev Accepts new ownership on behalf of the LeadcoinCrowdsale contract. This can be used, by the token sale
897     /// contract itself to claim back ownership of the LeadcoinSmartToken contract.
898     function claimTokenOwnership() external onlyOwner {
899         token.claimOwnership();
900     }
901 
902 }