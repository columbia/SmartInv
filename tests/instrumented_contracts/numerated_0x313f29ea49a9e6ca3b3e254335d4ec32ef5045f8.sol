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
476 
477 
478 
479 /**
480   A Token which is 'Bancor' compatible and can mint new tokens and pause token-transfer functionality
481 */
482 contract SirinSmartToken is LimitedTransferBancorSmartToken {
483 
484     // =================================================================================================================
485     //                                         Members
486     // =================================================================================================================
487 
488     string public name = "SIRIN";
489 
490     string public symbol = "SRN";
491 
492     uint8 public decimals = 18;
493 
494     // =================================================================================================================
495     //                                         Constructor
496     // =================================================================================================================
497 
498     function SirinSmartToken() public {
499         //Apart of 'Bancor' computability - triggered when a smart token is deployed
500         NewSmartToken(address(this));
501     }
502 }
503 
504 
505 /**
506  * @title RefundVault
507  * @dev This contract is used for storing TOKENS AND ETHER while a crowdsale is in progress for a period of 60 DAYS.
508  * Investor can ask for a full/part refund for his ether against token. Once tokens are Claimed by the investor, they cannot be refunded.
509  * After 60 days, all ether will be withdrawn from the vault`s wallet, leaving all tokens to be claimed by the their owners.
510  **/
511 contract RefundVault is Claimable {
512     using SafeMath for uint256;
513 
514     // =================================================================================================================
515     //                                      Enums
516     // =================================================================================================================
517 
518     enum State { Active, Refunding, Closed }
519 
520     // =================================================================================================================
521     //                                      Members
522     // =================================================================================================================
523 
524     // Refund time frame
525     uint256 public constant REFUND_TIME_FRAME = 60 days;
526 
527     mapping (address => uint256) public depositedETH;
528     mapping (address => uint256) public depositedToken;
529 
530     address public etherWallet;
531     SirinSmartToken public token;
532     State public state;
533     uint256 public refundStartTime;
534 
535     // =================================================================================================================
536     //                                      Events
537     // =================================================================================================================
538 
539     event Active();
540     event Closed();
541     event Deposit(address indexed beneficiary, uint256 etherWeiAmount, uint256 tokenWeiAmount);
542     event RefundsEnabled();
543     event RefundedETH(address beneficiary, uint256 weiAmount);
544     event TokensClaimed(address indexed beneficiary, uint256 weiAmount);
545 
546     // =================================================================================================================
547     //                                      Modifiers
548     // =================================================================================================================
549 
550     modifier isActiveState() {
551         require(state == State.Active);
552         _;
553     }
554 
555     modifier isRefundingState() {
556         require(state == State.Refunding);
557         _;
558     }
559     
560     modifier isCloseState() {
561         require(state == State.Closed);
562         _;
563     }
564 
565     modifier isRefundingOrCloseState() {
566         require(state == State.Refunding || state == State.Closed);
567         _;
568     }
569 
570     modifier  isInRefundTimeFrame() {
571         require(refundStartTime <= now && refundStartTime + REFUND_TIME_FRAME > now);
572         _;
573     }
574 
575     modifier isRefundTimeFrameExceeded() {
576         require(refundStartTime + REFUND_TIME_FRAME < now);
577         _;
578     }
579     
580 
581     // =================================================================================================================
582     //                                      Ctors
583     // =================================================================================================================
584 
585     function RefundVault(address _etherWallet, SirinSmartToken _token) public {
586         require(_etherWallet != address(0));
587         require(_token != address(0));
588 
589         etherWallet = _etherWallet;
590         token = _token;
591         state = State.Active;
592         Active();
593     }
594 
595     // =================================================================================================================
596     //                                      Public Functions
597     // =================================================================================================================
598 
599     function deposit(address investor, uint256 tokensAmount) isActiveState onlyOwner public payable {
600 
601         depositedETH[investor] = depositedETH[investor].add(msg.value);
602         depositedToken[investor] = depositedToken[investor].add(tokensAmount);
603 
604         Deposit(investor, msg.value, tokensAmount);
605     }
606 
607     function close() isRefundingState onlyOwner isRefundTimeFrameExceeded public {
608         state = State.Closed;
609         Closed();
610         etherWallet.transfer(this.balance);
611     }
612 
613     function enableRefunds() isActiveState onlyOwner public {
614         state = State.Refunding;
615         refundStartTime = now;
616 
617         RefundsEnabled();
618     }
619 
620     //@dev Refund ether back to the investor in returns of proportional amount of SRN
621     //back to the Sirin`s wallet
622     function refundETH(uint256 ETHToRefundAmountWei) isInRefundTimeFrame isRefundingState public {
623         require(ETHToRefundAmountWei != 0);
624 
625         uint256 depositedTokenValue = depositedToken[msg.sender];
626         uint256 depositedETHValue = depositedETH[msg.sender];
627 
628         require(ETHToRefundAmountWei <= depositedETHValue);
629 
630         uint256 refundTokens = ETHToRefundAmountWei.mul(depositedTokenValue).div(depositedETHValue);
631 
632         assert(refundTokens > 0);
633 
634         depositedETH[msg.sender] = depositedETHValue.sub(ETHToRefundAmountWei);
635         depositedToken[msg.sender] = depositedTokenValue.sub(refundTokens);
636 
637         token.destroy(address(this),refundTokens);
638         msg.sender.transfer(ETHToRefundAmountWei);
639 
640         RefundedETH(msg.sender, ETHToRefundAmountWei);
641     }
642 
643     //@dev Transfer tokens from the vault to the investor while releasing proportional amount of ether
644     //to Sirin`s wallet.
645     //Can be triggerd by the investor only
646     function claimTokens(uint256 tokensToClaim) isRefundingOrCloseState public {
647         require(tokensToClaim != 0);
648         
649         address investor = msg.sender;
650         require(depositedToken[investor] > 0);
651         
652         uint256 depositedTokenValue = depositedToken[investor];
653         uint256 depositedETHValue = depositedETH[investor];
654 
655         require(tokensToClaim <= depositedTokenValue);
656 
657         uint256 claimedETH = tokensToClaim.mul(depositedETHValue).div(depositedTokenValue);
658 
659         assert(claimedETH > 0);
660 
661         depositedETH[investor] = depositedETHValue.sub(claimedETH);
662         depositedToken[investor] = depositedTokenValue.sub(tokensToClaim);
663 
664         token.transfer(investor, tokensToClaim);
665         if(state != State.Closed) {
666             etherWallet.transfer(claimedETH);
667         }
668 
669         TokensClaimed(investor, tokensToClaim);
670     }
671     
672     //@dev Transfer tokens from the vault to the investor while releasing proportional amount of ether
673     //to Sirin`s wallet.
674     //Can be triggerd by the owner of the vault (in our case - Sirin`s owner after 60 days)
675     function claimAllInvestorTokensByOwner(address investor) isCloseState onlyOwner public {
676         uint256 depositedTokenValue = depositedToken[investor];
677         require(depositedTokenValue > 0);
678         
679 
680         token.transfer(investor, depositedTokenValue);
681         
682         TokensClaimed(investor, depositedTokenValue);
683     }
684 
685     // @dev investors can claim tokens by calling the function
686     // @param tokenToClaimAmount - amount of the token to claim
687     function claimAllTokens() isRefundingOrCloseState public  {
688         uint256 depositedTokenValue = depositedToken[msg.sender];
689         claimTokens(depositedTokenValue);
690     }
691 
692 
693 }
694 
695 
696 
697 /**
698  * @title Crowdsale
699  * @dev Crowdsale is a base contract for managing a token crowdsale.
700  * Crowdsales have a start and end timestamps, where investors can make
701  * token purchases and the crowdsale will assign them tokens based
702  * on a token per ETH rate. Funds collected are forwarded to a wallet
703  * as they arrive.
704  */
705 contract Crowdsale {
706     using SafeMath for uint256;
707 
708     // The token being sold
709     SirinSmartToken public token;
710 
711     // start and end timestamps where investments are allowed (both inclusive)
712     uint256 public startTime;
713 
714     uint256 public endTime;
715 
716     // address where funds are collected
717     address public wallet;
718 
719     // how many token units a buyer gets per wei
720     uint256 public rate;
721 
722     // amount of raised money in wei
723     uint256 public weiRaised;
724 
725     /**
726      * event for token purchase logging
727      * @param purchaser who paid for the tokens
728      * @param beneficiary who got the tokens
729      * @param value weis paid for purchase
730      * @param amount amount of tokens purchased
731      */
732     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
733 
734     function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, SirinSmartToken _token) public {
735         require(_startTime >= now);
736         require(_endTime >= _startTime);
737         require(_rate > 0);
738         require(_wallet != address(0));
739         require(_token != address(0));
740 
741         startTime = _startTime;
742         endTime = _endTime;
743         rate = _rate;
744         wallet = _wallet;
745         token = _token;
746     }
747 
748     // fallback function can be used to buy tokens
749     function() external payable {
750         buyTokens(msg.sender);
751     }
752 
753     // low level token purchase function
754     function buyTokens(address beneficiary) public payable {
755         require(beneficiary != address(0));
756         require(validPurchase());
757 
758         uint256 weiAmount = msg.value;
759 
760         // calculate token amount to be created
761         uint256 tokens = weiAmount.mul(getRate());
762 
763         // update state
764         weiRaised = weiRaised.add(weiAmount);
765 
766         token.issue(beneficiary, tokens);
767         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
768 
769         forwardFunds();
770     }
771 
772     // send ether to the fund collection wallet
773     // override to create custom fund forwarding mechanisms
774     function forwardFunds() internal {
775         wallet.transfer(msg.value);
776     }
777 
778     // @return true if the transaction can buy tokens
779     function validPurchase() internal view returns (bool) {
780         bool withinPeriod = now >= startTime && now <= endTime;
781         bool nonZeroPurchase = msg.value != 0;
782         return withinPeriod && nonZeroPurchase;
783     }
784 
785     // @return true if crowdsale event has ended
786     function hasEnded() public view returns (bool) {
787         return now > endTime;
788     }
789 
790     // @return the crowdsale rate
791     function getRate() public view returns (uint256) {
792         return rate;
793     }
794 
795 
796 }
797 
798 
799 /**
800  * @title FinalizableCrowdsale
801  * @dev Extension of Crowdsale where an owner can do extra work
802  * after finishing.
803  */
804 contract FinalizableCrowdsale is Crowdsale, Claimable {
805   using SafeMath for uint256;
806 
807   bool public isFinalized = false;
808 
809   event Finalized();
810 
811   /**
812    * @dev Must be called after crowdsale ends, to do some extra finalization
813    * work. Calls the contract's finalization function.
814    */
815   function finalize() onlyOwner public {
816     require(!isFinalized);
817     require(hasEnded());
818 
819     finalization();
820     Finalized();
821 
822     isFinalized = true;
823   }
824 
825   /**
826    * @dev Can be overridden to add finalization logic. The overriding function
827    * should call super.finalization() to ensure the chain of finalization is
828    * executed entirely.
829    */
830   function finalization() internal {
831   }
832 }
833 
834 
835 
836 
837 contract SirinCrowdsale is FinalizableCrowdsale {
838 
839     // =================================================================================================================
840     //                                      Constants
841     // =================================================================================================================
842     // Max amount of known addresses of which will get SRN by 'Grant' method.
843     //
844     // grantees addresses will be SirinLabs wallets addresses.
845     // these wallets will contain SRN tokens that will be used for 2 purposes only -
846     // 1. SRN tokens against raised fiat money
847     // 2. SRN tokens for presale bonus.
848     // we set the value to 10 (and not to 2) because we want to allow some flexibility for cases like fiat money that is raised close to the crowdsale.
849     // we limit the value to 10 (and not larger) to limit the run time of the function that process the grantees array.
850     uint8 public constant MAX_TOKEN_GRANTEES = 10;
851 
852     // SRN to ETH base rate
853     uint256 public constant EXCHANGE_RATE = 500;
854 
855     // Refund division rate
856     uint256 public constant REFUND_DIVISION_RATE = 2;
857 
858     // =================================================================================================================
859     //                                      Modifiers
860     // =================================================================================================================
861 
862     /**
863      * @dev Throws if called not during the crowdsale time frame
864      */
865     modifier onlyWhileSale() {
866         require(isActive());
867         _;
868     }
869 
870     // =================================================================================================================
871     //                                      Members
872     // =================================================================================================================
873 
874     // wallets address for 60% of SRN allocation
875     address public walletTeam;   //10% of the total number of SRN tokens will be allocated to the team
876     address public walletOEM;       //10% of the total number of SRN tokens will be allocated to OEM’s, Operating System implementation, SDK developers and rebate to device and Shield OS™ users
877     address public walletBounties;  //5% of the total number of SRN tokens will be allocated to professional fees and Bounties
878     address public walletReserve;   //35% of the total number of SRN tokens will be allocated to SIRIN LABS and as a reserve for the company to be used for future strategic plans for the created ecosystem
879 
880     // Funds collected outside the crowdsale in wei
881     uint256 public fiatRaisedConvertedToWei;
882 
883     //Grantees - used for non-ether and presale bonus token generation
884     address[] public presaleGranteesMapKeys;
885     mapping (address => uint256) public presaleGranteesMap;  //address=>wei token amount
886 
887     // The refund vault
888     RefundVault public refundVault;
889 
890     // =================================================================================================================
891     //                                      Events
892     // =================================================================================================================
893     event GrantAdded(address indexed _grantee, uint256 _amount);
894 
895     event GrantUpdated(address indexed _grantee, uint256 _oldAmount, uint256 _newAmount);
896 
897     event GrantDeleted(address indexed _grantee, uint256 _hadAmount);
898 
899     event FiatRaisedUpdated(address indexed _address, uint256 _fiatRaised);
900 
901     event TokenPurchaseWithGuarantee(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
902 
903     // =================================================================================================================
904     //                                      Constructors
905     // =================================================================================================================
906 
907     function SirinCrowdsale(uint256 _startTime,
908     uint256 _endTime,
909     address _wallet,
910     address _walletTeam,
911     address _walletOEM,
912     address _walletBounties,
913     address _walletReserve,
914     SirinSmartToken _sirinSmartToken,
915     RefundVault _refundVault)
916     public
917     Crowdsale(_startTime, _endTime, EXCHANGE_RATE, _wallet, _sirinSmartToken) {
918         require(_walletTeam != address(0));
919         require(_walletOEM != address(0));
920         require(_walletBounties != address(0));
921         require(_walletReserve != address(0));
922         require(_sirinSmartToken != address(0));
923         require(_refundVault != address(0));
924 
925         walletTeam = _walletTeam;
926         walletOEM = _walletOEM;
927         walletBounties = _walletBounties;
928         walletReserve = _walletReserve;
929 
930         token = _sirinSmartToken;
931         refundVault  = _refundVault;
932     }
933 
934     // =================================================================================================================
935     //                                      Impl Crowdsale
936     // =================================================================================================================
937 
938     // @return the rate in SRN per 1 ETH according to the time of the tx and the SRN pricing program.
939     // @Override
940     function getRate() public view returns (uint256) {
941         if (now < (startTime.add(24 hours))) {return 1000;}
942         if (now < (startTime.add(2 days))) {return 950;}
943         if (now < (startTime.add(3 days))) {return 900;}
944         if (now < (startTime.add(4 days))) {return 855;}
945         if (now < (startTime.add(5 days))) {return 810;}
946         if (now < (startTime.add(6 days))) {return 770;}
947         if (now < (startTime.add(7 days))) {return 730;}
948         if (now < (startTime.add(8 days))) {return 690;}
949         if (now < (startTime.add(9 days))) {return 650;}
950         if (now < (startTime.add(10 days))) {return 615;}
951         if (now < (startTime.add(11 days))) {return 580;}
952         if (now < (startTime.add(12 days))) {return 550;}
953         if (now < (startTime.add(13 days))) {return 525;}
954 
955         return rate;
956     }
957 
958     // =================================================================================================================
959     //                                      Impl FinalizableCrowdsale
960     // =================================================================================================================
961 
962     //@Override
963     function finalization() internal onlyOwner {
964         super.finalization();
965 
966         // granting bonuses for the pre crowdsale grantees:
967         for (uint256 i = 0; i < presaleGranteesMapKeys.length; i++) {
968             token.issue(presaleGranteesMapKeys[i], presaleGranteesMap[presaleGranteesMapKeys[i]]);
969         }
970 
971         // Adding 60% of the total token supply (40% were generated during the crowdsale)
972         // 40 * 2.5 = 100
973         uint256 newTotalSupply = token.totalSupply().mul(250).div(100);
974 
975         // 10% of the total number of SRN tokens will be allocated to the team
976         token.issue(walletTeam, newTotalSupply.mul(10).div(100));
977 
978         // 10% of the total number of SRN tokens will be allocated to OEM’s, Operating System implementation,
979         // SDK developers and rebate to device and Sirin OS™ users
980         token.issue(walletOEM, newTotalSupply.mul(10).div(100));
981 
982         // 5% of the total number of SRN tokens will be allocated to professional fees and Bounties
983         token.issue(walletBounties, newTotalSupply.mul(5).div(100));
984 
985         // 35% of the total number of SRN tokens will be allocated to SIRIN LABS,
986         // and as a reserve for the company to be used for future strategic plans for the created ecosystem
987         token.issue(walletReserve, newTotalSupply.mul(35).div(100));
988 
989         // Re-enable transfers after the token sale.
990         token.disableTransfers(false);
991 
992         // Re-enable destroy function after the token sale.
993         token.setDestroyEnabled(true);
994 
995         // Enable ETH refunds and token claim.
996         refundVault.enableRefunds();
997 
998         // transfer token ownership to crowdsale owner
999         token.transferOwnership(owner);
1000 
1001         // transfer refundVault ownership to crowdsale owner
1002         refundVault.transferOwnership(owner);
1003     }
1004 
1005     // =================================================================================================================
1006     //                                      Public Methods
1007     // =================================================================================================================
1008     // @return the total funds collected in wei(ETH and none ETH).
1009     function getTotalFundsRaised() public view returns (uint256) {
1010         return fiatRaisedConvertedToWei.add(weiRaised);
1011     }
1012 
1013     // @return true if the crowdsale is active, hence users can buy tokens
1014     function isActive() public view returns (bool) {
1015         return now >= startTime && now < endTime;
1016     }
1017 
1018     // =================================================================================================================
1019     //                                      External Methods
1020     // =================================================================================================================
1021     // @dev Adds/Updates address and token allocation for token grants.
1022     // Granted tokens are allocated to non-ether, presale, buyers.
1023     // @param _grantee address The address of the token grantee.
1024     // @param _value uint256 The value of the grant in wei token.
1025     function addUpdateGrantee(address _grantee, uint256 _value) external onlyOwner onlyWhileSale{
1026         require(_grantee != address(0));
1027         require(_value > 0);
1028 
1029         // Adding new key if not present:
1030         if (presaleGranteesMap[_grantee] == 0) {
1031             require(presaleGranteesMapKeys.length < MAX_TOKEN_GRANTEES);
1032             presaleGranteesMapKeys.push(_grantee);
1033             GrantAdded(_grantee, _value);
1034         }
1035         else {
1036             GrantUpdated(_grantee, presaleGranteesMap[_grantee], _value);
1037         }
1038 
1039         presaleGranteesMap[_grantee] = _value;
1040     }
1041 
1042     // @dev deletes entries from the grants list.
1043     // @param _grantee address The address of the token grantee.
1044     function deleteGrantee(address _grantee) external onlyOwner onlyWhileSale {
1045         require(_grantee != address(0));
1046         require(presaleGranteesMap[_grantee] != 0);
1047 
1048         //delete from the map:
1049         delete presaleGranteesMap[_grantee];
1050 
1051         //delete from the array (keys):
1052         uint256 index;
1053         for (uint256 i = 0; i < presaleGranteesMapKeys.length; i++) {
1054             if (presaleGranteesMapKeys[i] == _grantee) {
1055                 index = i;
1056                 break;
1057             }
1058         }
1059         presaleGranteesMapKeys[index] = presaleGranteesMapKeys[presaleGranteesMapKeys.length - 1];
1060         delete presaleGranteesMapKeys[presaleGranteesMapKeys.length - 1];
1061         presaleGranteesMapKeys.length--;
1062 
1063         GrantDeleted(_grantee, presaleGranteesMap[_grantee]);
1064     }
1065 
1066     // @dev Set funds collected outside the crowdsale in wei.
1067     //  note: we not to use accumulator to allow flexibility in case of humane mistakes.
1068     // funds are converted to wei using the market conversion rate of USD\ETH on the day on the purchase.
1069     // @param _fiatRaisedConvertedToWei number of none eth raised.
1070     function setFiatRaisedConvertedToWei(uint256 _fiatRaisedConvertedToWei) external onlyOwner onlyWhileSale {
1071         fiatRaisedConvertedToWei = _fiatRaisedConvertedToWei;
1072         FiatRaisedUpdated(msg.sender, fiatRaisedConvertedToWei);
1073     }
1074 
1075     /// @dev Accepts new ownership on behalf of the SirinCrowdsale contract. This can be used, by the token sale
1076     /// contract itself to claim back ownership of the SirinSmartToken contract.
1077     function claimTokenOwnership() external onlyOwner {
1078         token.claimOwnership();
1079     }
1080 
1081     /// @dev Accepts new ownership on behalf of the SirinCrowdsale contract. This can be used, by the token sale
1082     /// contract itself to claim back ownership of the refundVault contract.
1083     function claimRefundVaultOwnership() external onlyOwner {
1084         refundVault.claimOwnership();
1085     }
1086 
1087     // @dev Buy tokes with guarantee
1088     function buyTokensWithGuarantee() public payable {
1089         require(validPurchase());
1090 
1091         uint256 weiAmount = msg.value;
1092 
1093         // calculate token amount to be created
1094         uint256 tokens = weiAmount.mul(getRate());
1095         tokens = tokens.div(REFUND_DIVISION_RATE);
1096 
1097         // update state
1098         weiRaised = weiRaised.add(weiAmount);
1099 
1100         token.issue(address(refundVault), tokens);
1101 
1102         refundVault.deposit.value(msg.value)(msg.sender, tokens);
1103 
1104         TokenPurchaseWithGuarantee(msg.sender, address(refundVault), weiAmount, tokens);
1105     }
1106 }