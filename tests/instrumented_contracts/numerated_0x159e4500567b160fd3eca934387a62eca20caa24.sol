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
505 /// @title Vesting trustee contract for Kin token.
506 contract SirinVestingTrustee is Claimable {
507     using SafeMath for uint256;
508 
509     // The address of the SRN ERC20 token.
510     SirinSmartToken public token;
511 
512     struct Grant {
513     uint256 value;
514     uint256 start;
515     uint256 cliff;
516     uint256 end;
517     uint256 transferred;
518     bool revokable;
519     }
520 
521     // Grants holder.
522     mapping (address => Grant) public grants;
523 
524     // Total tokens available for vesting.
525     uint256 public totalVesting;
526 
527     event NewGrant(address indexed _from, address indexed _to, uint256 _value);
528     event UnlockGrant(address indexed _holder, uint256 _value);
529     event RevokeGrant(address indexed _holder, uint256 _refund);
530 
531     /// @dev Constructor that initializes the address of the SirnSmartToken contract.
532     /// @param _token SirinSmartToken The address of the previously deployed SirnSmartToken smart contract.
533     function SirinVestingTrustee(SirinSmartToken _token) {
534         require(_token != address(0));
535 
536         token = _token;
537     }
538 
539     /// @dev Grant tokens to a specified address.
540     /// @param _to address The address to grant tokens to.
541     /// @param _value uint256 The amount of tokens to be granted.
542     /// @param _start uint256 The beginning of the vesting period.
543     /// @param _cliff uint256 Duration of the cliff period.
544     /// @param _end uint256 The end of the vesting period.
545     /// @param _revokable bool Whether the grant is revokable or not.
546     function grant(address _to, uint256 _value, uint256 _start, uint256 _cliff, uint256 _end, bool _revokable)
547     public onlyOwner {
548         require(_to != address(0));
549         require(_value > 0);
550 
551         // Make sure that a single address can be granted tokens only once.
552         require(grants[_to].value == 0);
553 
554         // Check for date inconsistencies that may cause unexpected behavior.
555         require(_start <= _cliff && _cliff <= _end);
556 
557         // Check that this grant doesn't exceed the total amount of tokens currently available for vesting.
558         require(totalVesting.add(_value) <= token.balanceOf(address(this)));
559 
560         // Assign a new grant.
561         grants[_to] = Grant({
562         value: _value,
563         start: _start,
564         cliff: _cliff,
565         end: _end,
566         transferred: 0,
567         revokable: _revokable
568         });
569 
570         // Tokens granted, reduce the total amount available for vesting.
571         totalVesting = totalVesting.add(_value);
572 
573         NewGrant(msg.sender, _to, _value);
574     }
575 
576     /// @dev Revoke the grant of tokens of a specifed address.
577     /// @param _holder The address which will have its tokens revoked.
578     function revoke(address _holder) public onlyOwner {
579         Grant grant = grants[_holder];
580 
581         require(grant.revokable);
582 
583         // Send the remaining STX back to the owner.
584         uint256 refund = grant.value.sub(grant.transferred);
585 
586         // Remove the grant.
587         delete grants[_holder];
588 
589         totalVesting = totalVesting.sub(refund);
590         token.transfer(msg.sender, refund);
591 
592         RevokeGrant(_holder, refund);
593     }
594 
595     /// @dev Calculate the total amount of vested tokens of a holder at a given time.
596     /// @param _holder address The address of the holder.
597     /// @param _time uint256 The specific time.
598     /// @return a uint256 representing a holder's total amount of vested tokens.
599     function vestedTokens(address _holder, uint256 _time) public constant returns (uint256) {
600         Grant grant = grants[_holder];
601         if (grant.value == 0) {
602             return 0;
603         }
604 
605         return calculateVestedTokens(grant, _time);
606     }
607 
608     /// @dev Calculate amount of vested tokens at a specifc time.
609     /// @param _grant Grant The vesting grant.
610     /// @param _time uint256 The time to be checked
611     /// @return An uint256 representing the amount of vested tokens of a specific grant.
612     ///   |                         _/--------   vestedTokens rect
613     ///   |                       _/
614     ///   |                     _/
615     ///   |                   _/
616     ///   |                 _/
617     ///   |                /
618     ///   |              .|
619     ///   |            .  |
620     ///   |          .    |
621     ///   |        .      |
622     ///   |      .        |
623     ///   |    .          |
624     ///   +===+===========+---------+----------> time
625     ///     Start       Cliff      End
626     function calculateVestedTokens(Grant _grant, uint256 _time) private constant returns (uint256) {
627         // If we're before the cliff, then nothing is vested.
628         if (_time < _grant.cliff) {
629             return 0;
630         }
631 
632         // If we're after the end of the vesting period - everything is vested;
633         if (_time >= _grant.end) {
634             return _grant.value;
635         }
636 
637         // Interpolate all vested tokens: vestedTokens = tokens/// (time - start) / (end - start)
638         return _grant.value.mul(_time.sub(_grant.start)).div(_grant.end.sub(_grant.start));
639     }
640 
641     /// @dev Unlock vested tokens and transfer them to their holder.
642     /// @return a uint256 representing the amount of vested tokens transferred to their holder.
643     function unlockVestedTokens() public {
644         Grant grant = grants[msg.sender];
645         require(grant.value != 0);
646 
647         // Get the total amount of vested tokens, acccording to grant.
648         uint256 vested = calculateVestedTokens(grant, now);
649         if (vested == 0) {
650             return;
651         }
652 
653         // Make sure the holder doesn't transfer more than what he already has.
654         uint256 transferable = vested.sub(grant.transferred);
655         if (transferable == 0) {
656             return;
657         }
658 
659         grant.transferred = grant.transferred.add(transferable);
660         totalVesting = totalVesting.sub(transferable);
661         token.transfer(msg.sender, transferable);
662 
663         UnlockGrant(msg.sender, transferable);
664     }
665 }
666 
667 
668 /**
669  * @title RefundVault
670  * @dev This contract is used for storing TOKENS AND ETHER while a crowdsale is in progress for a period of 60 DAYS.
671  * Investor can ask for a full/part refund for his ether against token. Once tokens are Claimed by the investor, they cannot be refunded.
672  * After 60 days, all ether will be withdrawn from the vault`s wallet, leaving all tokens to be claimed by the their owners.
673  **/
674 contract RefundVault is Claimable {
675     using SafeMath for uint256;
676 
677     // =================================================================================================================
678     //                                      Enums
679     // =================================================================================================================
680 
681     enum State { Active, Refunding, Closed }
682 
683     // =================================================================================================================
684     //                                      Members
685     // =================================================================================================================
686 
687     // Refund time frame
688     uint256 public constant REFUND_TIME_FRAME = 60 days;
689 
690     mapping (address => uint256) public depositedETH;
691     mapping (address => uint256) public depositedToken;
692 
693     address public etherWallet;
694     SirinSmartToken public token;
695     State public state;
696     uint256 public refundStartTime;
697 
698     // =================================================================================================================
699     //                                      Events
700     // =================================================================================================================
701 
702     event Active();
703     event Closed();
704     event Deposit(address indexed beneficiary, uint256 etherWeiAmount, uint256 tokenWeiAmount);
705     event RefundsEnabled();
706     event RefundedETH(address beneficiary, uint256 weiAmount);
707     event TokensClaimed(address indexed beneficiary, uint256 weiAmount);
708 
709     // =================================================================================================================
710     //                                      Modifiers
711     // =================================================================================================================
712 
713     modifier isActiveState() {
714         require(state == State.Active);
715         _;
716     }
717 
718     modifier isRefundingState() {
719         require(state == State.Refunding);
720         _;
721     }
722     
723     modifier isCloseState() {
724         require(state == State.Closed);
725         _;
726     }
727 
728     modifier isRefundingOrCloseState() {
729         require(state == State.Refunding || state == State.Closed);
730         _;
731     }
732 
733     modifier  isInRefundTimeFrame() {
734         require(refundStartTime <= now && refundStartTime + REFUND_TIME_FRAME > now);
735         _;
736     }
737 
738     modifier isRefundTimeFrameExceeded() {
739         require(refundStartTime + REFUND_TIME_FRAME < now);
740         _;
741     }
742     
743 
744     // =================================================================================================================
745     //                                      Ctors
746     // =================================================================================================================
747 
748     function RefundVault(address _etherWallet, SirinSmartToken _token) public {
749         require(_etherWallet != address(0));
750         require(_token != address(0));
751 
752         etherWallet = _etherWallet;
753         token = _token;
754         state = State.Active;
755         Active();
756     }
757 
758     // =================================================================================================================
759     //                                      Public Functions
760     // =================================================================================================================
761 
762     function deposit(address investor, uint256 tokensAmount) isActiveState onlyOwner public payable {
763 
764         depositedETH[investor] = depositedETH[investor].add(msg.value);
765         depositedToken[investor] = depositedToken[investor].add(tokensAmount);
766 
767         Deposit(investor, msg.value, tokensAmount);
768     }
769 
770     function close() isRefundingState onlyOwner isRefundTimeFrameExceeded public {
771         state = State.Closed;
772         Closed();
773         etherWallet.transfer(this.balance);
774     }
775 
776     function enableRefunds() isActiveState onlyOwner public {
777         state = State.Refunding;
778         refundStartTime = now;
779 
780         RefundsEnabled();
781     }
782 
783     //@dev Refund ether back to the investor in returns of proportional amount of SRN
784     //back to the Sirin`s wallet
785     function refundETH(uint256 ETHToRefundAmountWei) isInRefundTimeFrame isRefundingState public {
786         require(ETHToRefundAmountWei != 0);
787 
788         uint256 depositedTokenValue = depositedToken[msg.sender];
789         uint256 depositedETHValue = depositedETH[msg.sender];
790 
791         require(ETHToRefundAmountWei <= depositedETHValue);
792 
793         uint256 refundTokens = ETHToRefundAmountWei.mul(depositedTokenValue).div(depositedETHValue);
794 
795         assert(refundTokens > 0);
796 
797         depositedETH[msg.sender] = depositedETHValue.sub(ETHToRefundAmountWei);
798         depositedToken[msg.sender] = depositedTokenValue.sub(refundTokens);
799 
800         token.destroy(address(this),refundTokens);
801         msg.sender.transfer(ETHToRefundAmountWei);
802 
803         RefundedETH(msg.sender, ETHToRefundAmountWei);
804     }
805 
806     //@dev Transfer tokens from the vault to the investor while releasing proportional amount of ether
807     //to Sirin`s wallet.
808     //Can be triggerd by the investor only
809     function claimTokens(uint256 tokensToClaim) isRefundingOrCloseState public {
810         require(tokensToClaim != 0);
811         
812         address investor = msg.sender;
813         require(depositedToken[investor] > 0);
814         
815         uint256 depositedTokenValue = depositedToken[investor];
816         uint256 depositedETHValue = depositedETH[investor];
817 
818         require(tokensToClaim <= depositedTokenValue);
819 
820         uint256 claimedETH = tokensToClaim.mul(depositedETHValue).div(depositedTokenValue);
821 
822         assert(claimedETH > 0);
823 
824         depositedETH[investor] = depositedETHValue.sub(claimedETH);
825         depositedToken[investor] = depositedTokenValue.sub(tokensToClaim);
826 
827         token.transfer(investor, tokensToClaim);
828         if(state != State.Closed) {
829             etherWallet.transfer(claimedETH);
830         }
831 
832         TokensClaimed(investor, tokensToClaim);
833     }
834     
835     //@dev Transfer tokens from the vault to the investor while releasing proportional amount of ether
836     //to Sirin`s wallet.
837     //Can be triggerd by the owner of the vault (in our case - Sirin`s owner after 60 days)
838     function claimAllInvestorTokensByOwner(address investor) isCloseState onlyOwner public {
839         uint256 depositedTokenValue = depositedToken[investor];
840         require(depositedTokenValue > 0);
841         
842 
843         token.transfer(investor, depositedTokenValue);
844         
845         TokensClaimed(investor, depositedTokenValue);
846     }
847 
848     // @dev investors can claim tokens by calling the function
849     // @param tokenToClaimAmount - amount of the token to claim
850     function claimAllTokens() isRefundingOrCloseState public  {
851         uint256 depositedTokenValue = depositedToken[msg.sender];
852         claimTokens(depositedTokenValue);
853     }
854 
855 
856 }
857 
858 
859 
860 /**
861  * @title Crowdsale
862  * @dev Crowdsale is a base contract for managing a token crowdsale.
863  * Crowdsales have a start and end timestamps, where investors can make
864  * token purchases and the crowdsale will assign them tokens based
865  * on a token per ETH rate. Funds collected are forwarded to a wallet
866  * as they arrive.
867  */
868 contract Crowdsale {
869     using SafeMath for uint256;
870 
871     // The token being sold
872     SirinSmartToken public token;
873 
874     // start and end timestamps where investments are allowed (both inclusive)
875     uint256 public startTime;
876 
877     uint256 public endTime;
878 
879     // address where funds are collected
880     address public wallet;
881 
882     // how many token units a buyer gets per wei
883     uint256 public rate;
884 
885     // amount of raised money in wei
886     uint256 public weiRaised;
887 
888     /**
889      * event for token purchase logging
890      * @param purchaser who paid for the tokens
891      * @param beneficiary who got the tokens
892      * @param value weis paid for purchase
893      * @param amount amount of tokens purchased
894      */
895     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
896 
897     function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, SirinSmartToken _token) public {
898         require(_startTime >= now);
899         require(_endTime >= _startTime);
900         require(_rate > 0);
901         require(_wallet != address(0));
902         require(_token != address(0));
903 
904         startTime = _startTime;
905         endTime = _endTime;
906         rate = _rate;
907         wallet = _wallet;
908         token = _token;
909     }
910 
911     // fallback function can be used to buy tokens
912     function() external payable {
913         buyTokens(msg.sender);
914     }
915 
916     // low level token purchase function
917     function buyTokens(address beneficiary) public payable {
918         require(beneficiary != address(0));
919         require(validPurchase());
920 
921         uint256 weiAmount = msg.value;
922 
923         // calculate token amount to be created
924         uint256 tokens = weiAmount.mul(getRate());
925 
926         // update state
927         weiRaised = weiRaised.add(weiAmount);
928 
929         token.issue(beneficiary, tokens);
930         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
931 
932         forwardFunds();
933     }
934 
935     // send ether to the fund collection wallet
936     // override to create custom fund forwarding mechanisms
937     function forwardFunds() internal {
938         wallet.transfer(msg.value);
939     }
940 
941     // @return true if the transaction can buy tokens
942     function validPurchase() internal view returns (bool) {
943         bool withinPeriod = now >= startTime && now <= endTime;
944         bool nonZeroPurchase = msg.value != 0;
945         return withinPeriod && nonZeroPurchase;
946     }
947 
948     // @return true if crowdsale event has ended
949     function hasEnded() public view returns (bool) {
950         return now > endTime;
951     }
952 
953     // @return the crowdsale rate
954     function getRate() public view returns (uint256) {
955         return rate;
956     }
957 
958 
959 }
960 
961 
962 /**
963  * @title FinalizableCrowdsale
964  * @dev Extension of Crowdsale where an owner can do extra work
965  * after finishing.
966  */
967 contract FinalizableCrowdsale is Crowdsale, Claimable {
968   using SafeMath for uint256;
969 
970   bool public isFinalized = false;
971 
972   event Finalized();
973 
974   /**
975    * @dev Must be called after crowdsale ends, to do some extra finalization
976    * work. Calls the contract's finalization function.
977    */
978   function finalize() onlyOwner public {
979     require(!isFinalized);
980     require(hasEnded());
981 
982     finalization();
983     Finalized();
984 
985     isFinalized = true;
986   }
987 
988   /**
989    * @dev Can be overridden to add finalization logic. The overriding function
990    * should call super.finalization() to ensure the chain of finalization is
991    * executed entirely.
992    */
993   function finalization() internal {
994   }
995 }
996 
997 
998 
999 
1000 contract SirinCrowdsale is FinalizableCrowdsale {
1001 
1002     // =================================================================================================================
1003     //                                      Constants
1004     // =================================================================================================================
1005     // Max amount of known addresses of which will get SRN by 'Grant' method.
1006     //
1007     // grantees addresses will be SirinLabs wallets addresses.
1008     // these wallets will contain SRN tokens that will be used for 2 purposes only -
1009     // 1. SRN tokens against raised fiat money
1010     // 2. SRN tokens for presale bonus.
1011     // we set the value to 10 (and not to 2) because we want to allow some flexibility for cases like fiat money that is raised close to the crowdsale.
1012     // we limit the value to 10 (and not larger) to limit the run time of the function that process the grantees array.
1013     uint8 public constant MAX_TOKEN_GRANTEES = 10;
1014 
1015     // SRN to ETH base rate
1016     uint256 public constant EXCHANGE_RATE = 500;
1017 
1018     // Refund division rate
1019     uint256 public constant REFUND_DIVISION_RATE = 2;
1020 
1021     // =================================================================================================================
1022     //                                      Modifiers
1023     // =================================================================================================================
1024 
1025     /**
1026      * @dev Throws if called not during the crowdsale time frame
1027      */
1028     modifier onlyWhileSale() {
1029         require(isActive());
1030         _;
1031     }
1032 
1033     // =================================================================================================================
1034     //                                      Members
1035     // =================================================================================================================
1036 
1037     // wallets address for 60% of SRN allocation
1038     address public walletTeam;   //10% of the total number of SRN tokens will be allocated to the team
1039     address public walletOEM;       //10% of the total number of SRN tokens will be allocated to OEM’s, Operating System implementation, SDK developers and rebate to device and Shield OS™ users
1040     address public walletBounties;  //5% of the total number of SRN tokens will be allocated to professional fees and Bounties
1041     address public walletReserve;   //35% of the total number of SRN tokens will be allocated to SIRIN LABS and as a reserve for the company to be used for future strategic plans for the created ecosystem
1042 
1043     // Funds collected outside the crowdsale in wei
1044     uint256 public fiatRaisedConvertedToWei;
1045 
1046     //Grantees - used for non-ether and presale bonus token generation
1047     address[] public presaleGranteesMapKeys;
1048     mapping (address => uint256) public presaleGranteesMap;  //address=>wei token amount
1049 
1050     // The refund vault
1051     RefundVault public refundVault;
1052 
1053     // =================================================================================================================
1054     //                                      Events
1055     // =================================================================================================================
1056     event GrantAdded(address indexed _grantee, uint256 _amount);
1057 
1058     event GrantUpdated(address indexed _grantee, uint256 _oldAmount, uint256 _newAmount);
1059 
1060     event GrantDeleted(address indexed _grantee, uint256 _hadAmount);
1061 
1062     event FiatRaisedUpdated(address indexed _address, uint256 _fiatRaised);
1063 
1064     event TokenPurchaseWithGuarantee(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
1065 
1066     // =================================================================================================================
1067     //                                      Constructors
1068     // =================================================================================================================
1069 
1070     function SirinCrowdsale(uint256 _startTime,
1071     uint256 _endTime,
1072     address _wallet,
1073     address _walletTeam,
1074     address _walletOEM,
1075     address _walletBounties,
1076     address _walletReserve,
1077     SirinSmartToken _sirinSmartToken,
1078     RefundVault _refundVault)
1079     public
1080     Crowdsale(_startTime, _endTime, EXCHANGE_RATE, _wallet, _sirinSmartToken) {
1081         require(_walletTeam != address(0));
1082         require(_walletOEM != address(0));
1083         require(_walletBounties != address(0));
1084         require(_walletReserve != address(0));
1085         require(_sirinSmartToken != address(0));
1086         require(_refundVault != address(0));
1087 
1088         walletTeam = _walletTeam;
1089         walletOEM = _walletOEM;
1090         walletBounties = _walletBounties;
1091         walletReserve = _walletReserve;
1092 
1093         token = _sirinSmartToken;
1094         refundVault  = _refundVault;
1095     }
1096 
1097     // =================================================================================================================
1098     //                                      Impl Crowdsale
1099     // =================================================================================================================
1100 
1101     // @return the rate in SRN per 1 ETH according to the time of the tx and the SRN pricing program.
1102     // @Override
1103     function getRate() public view returns (uint256) {
1104         if (now < (startTime.add(24 hours))) {return 1000;}
1105         if (now < (startTime.add(2 days))) {return 950;}
1106         if (now < (startTime.add(3 days))) {return 900;}
1107         if (now < (startTime.add(4 days))) {return 855;}
1108         if (now < (startTime.add(5 days))) {return 810;}
1109         if (now < (startTime.add(6 days))) {return 770;}
1110         if (now < (startTime.add(7 days))) {return 730;}
1111         if (now < (startTime.add(8 days))) {return 690;}
1112         if (now < (startTime.add(9 days))) {return 650;}
1113         if (now < (startTime.add(10 days))) {return 615;}
1114         if (now < (startTime.add(11 days))) {return 580;}
1115         if (now < (startTime.add(12 days))) {return 550;}
1116         if (now < (startTime.add(13 days))) {return 525;}
1117 
1118         return rate;
1119     }
1120 
1121     // =================================================================================================================
1122     //                                      Impl FinalizableCrowdsale
1123     // =================================================================================================================
1124 
1125     //@Override
1126     function finalization() internal onlyOwner {
1127         super.finalization();
1128 
1129         // granting bonuses for the pre crowdsale grantees:
1130         for (uint256 i = 0; i < presaleGranteesMapKeys.length; i++) {
1131             token.issue(presaleGranteesMapKeys[i], presaleGranteesMap[presaleGranteesMapKeys[i]]);
1132         }
1133 
1134         // Adding 60% of the total token supply (40% were generated during the crowdsale)
1135         // 40 * 2.5 = 100
1136         uint256 newTotalSupply = token.totalSupply().mul(250).div(100);
1137 
1138         // 10% of the total number of SRN tokens will be allocated to the team
1139         token.issue(walletTeam, newTotalSupply.mul(10).div(100));
1140 
1141         // 10% of the total number of SRN tokens will be allocated to OEM’s, Operating System implementation,
1142         // SDK developers and rebate to device and Sirin OS™ users
1143         token.issue(walletOEM, newTotalSupply.mul(10).div(100));
1144 
1145         // 5% of the total number of SRN tokens will be allocated to professional fees and Bounties
1146         token.issue(walletBounties, newTotalSupply.mul(5).div(100));
1147 
1148         // 35% of the total number of SRN tokens will be allocated to SIRIN LABS,
1149         // and as a reserve for the company to be used for future strategic plans for the created ecosystem
1150         token.issue(walletReserve, newTotalSupply.mul(35).div(100));
1151 
1152         // Re-enable transfers after the token sale.
1153         token.disableTransfers(false);
1154 
1155         // Re-enable destroy function after the token sale.
1156         token.setDestroyEnabled(true);
1157 
1158         // Enable ETH refunds and token claim.
1159         refundVault.enableRefunds();
1160 
1161         // transfer token ownership to crowdsale owner
1162         token.transferOwnership(owner);
1163 
1164         // transfer refundVault ownership to crowdsale owner
1165         refundVault.transferOwnership(owner);
1166     }
1167 
1168     // =================================================================================================================
1169     //                                      Public Methods
1170     // =================================================================================================================
1171     // @return the total funds collected in wei(ETH and none ETH).
1172     function getTotalFundsRaised() public view returns (uint256) {
1173         return fiatRaisedConvertedToWei.add(weiRaised);
1174     }
1175 
1176     // @return true if the crowdsale is active, hence users can buy tokens
1177     function isActive() public view returns (bool) {
1178         return now >= startTime && now < endTime;
1179     }
1180 
1181     // =================================================================================================================
1182     //                                      External Methods
1183     // =================================================================================================================
1184     // @dev Adds/Updates address and token allocation for token grants.
1185     // Granted tokens are allocated to non-ether, presale, buyers.
1186     // @param _grantee address The address of the token grantee.
1187     // @param _value uint256 The value of the grant in wei token.
1188     function addUpdateGrantee(address _grantee, uint256 _value) external onlyOwner onlyWhileSale{
1189         require(_grantee != address(0));
1190         require(_value > 0);
1191 
1192         // Adding new key if not present:
1193         if (presaleGranteesMap[_grantee] == 0) {
1194             require(presaleGranteesMapKeys.length < MAX_TOKEN_GRANTEES);
1195             presaleGranteesMapKeys.push(_grantee);
1196             GrantAdded(_grantee, _value);
1197         }
1198         else {
1199             GrantUpdated(_grantee, presaleGranteesMap[_grantee], _value);
1200         }
1201 
1202         presaleGranteesMap[_grantee] = _value;
1203     }
1204 
1205     // @dev deletes entries from the grants list.
1206     // @param _grantee address The address of the token grantee.
1207     function deleteGrantee(address _grantee) external onlyOwner onlyWhileSale {
1208         require(_grantee != address(0));
1209         require(presaleGranteesMap[_grantee] != 0);
1210 
1211         //delete from the map:
1212         delete presaleGranteesMap[_grantee];
1213 
1214         //delete from the array (keys):
1215         uint256 index;
1216         for (uint256 i = 0; i < presaleGranteesMapKeys.length; i++) {
1217             if (presaleGranteesMapKeys[i] == _grantee) {
1218                 index = i;
1219                 break;
1220             }
1221         }
1222         presaleGranteesMapKeys[index] = presaleGranteesMapKeys[presaleGranteesMapKeys.length - 1];
1223         delete presaleGranteesMapKeys[presaleGranteesMapKeys.length - 1];
1224         presaleGranteesMapKeys.length--;
1225 
1226         GrantDeleted(_grantee, presaleGranteesMap[_grantee]);
1227     }
1228 
1229     // @dev Set funds collected outside the crowdsale in wei.
1230     //  note: we not to use accumulator to allow flexibility in case of humane mistakes.
1231     // funds are converted to wei using the market conversion rate of USD\ETH on the day on the purchase.
1232     // @param _fiatRaisedConvertedToWei number of none eth raised.
1233     function setFiatRaisedConvertedToWei(uint256 _fiatRaisedConvertedToWei) external onlyOwner onlyWhileSale {
1234         fiatRaisedConvertedToWei = _fiatRaisedConvertedToWei;
1235         FiatRaisedUpdated(msg.sender, fiatRaisedConvertedToWei);
1236     }
1237 
1238     /// @dev Accepts new ownership on behalf of the SirinCrowdsale contract. This can be used, by the token sale
1239     /// contract itself to claim back ownership of the SirinSmartToken contract.
1240     function claimTokenOwnership() external onlyOwner {
1241         token.claimOwnership();
1242     }
1243 
1244     /// @dev Accepts new ownership on behalf of the SirinCrowdsale contract. This can be used, by the token sale
1245     /// contract itself to claim back ownership of the refundVault contract.
1246     function claimRefundVaultOwnership() external onlyOwner {
1247         refundVault.claimOwnership();
1248     }
1249 
1250     // @dev Buy tokes with guarantee
1251     function buyTokensWithGuarantee() public payable {
1252         require(validPurchase());
1253 
1254         uint256 weiAmount = msg.value;
1255 
1256         // calculate token amount to be created
1257         uint256 tokens = weiAmount.mul(getRate());
1258         tokens = tokens.div(REFUND_DIVISION_RATE);
1259 
1260         // update state
1261         weiRaised = weiRaised.add(weiAmount);
1262 
1263         token.issue(address(refundVault), tokens);
1264 
1265         refundVault.deposit.value(msg.value)(msg.sender, tokens);
1266 
1267         TokenPurchaseWithGuarantee(msg.sender, address(refundVault), weiAmount, tokens);
1268     }
1269 }