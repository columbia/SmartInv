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
43   event OwnershipRenounced(address indexed previousOwner);
44   event OwnershipTransferred(
45     address indexed previousOwner,
46     address indexed newOwner
47   );
48 
49 
50   /**
51    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
52    * account.
53    */
54   function Ownable() public {
55     owner = msg.sender;
56   }
57 
58   /**
59    * @dev Throws if called by any account other than the owner.
60    */
61   modifier onlyOwner() {
62     require(msg.sender == owner);
63     _;
64   }
65 
66   /**
67    * @dev Allows the current owner to relinquish control of the contract.
68    * @notice Renouncing to ownership will leave the contract without an owner.
69    * It will not be possible to call the functions with the `onlyOwner`
70    * modifier anymore.
71    */
72   function renounceOwnership() public onlyOwner {
73      OwnershipRenounced(owner);
74     owner = address(0);
75   }
76 
77   /**
78    * @dev Allows the current owner to transfer control of the contract to a newOwner.
79    * @param _newOwner The address to transfer ownership to.
80    */
81   function transferOwnership(address _newOwner) public onlyOwner {
82     _transferOwnership(_newOwner);
83   }
84 
85   /**
86    * @dev Transfers control of the contract to a newOwner.
87    * @param _newOwner The address to transfer ownership to.
88    */
89   function _transferOwnership(address _newOwner) internal {
90     require(_newOwner != address(0));
91      OwnershipTransferred(owner, _newOwner);
92     owner = _newOwner;
93   }
94 }
95 
96 
97 
98 
99 /**
100  * @title Claimable
101  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
102  * This allows the new owner to accept the transfer.
103  */
104 contract Claimable is Ownable {
105     address public pendingOwner;
106 
107     /**
108      * @dev Modifier throws if called by any account other than the pendingOwner.
109      */
110     modifier onlyPendingOwner() {
111         require(msg.sender == pendingOwner);
112         _;
113     }
114 
115     /**
116      * @dev Allows the current owner to set the pendingOwner address.
117      * @param newOwner The address to transfer ownership to.
118      */
119     function transferOwnership(address newOwner) public onlyOwner {
120         pendingOwner = newOwner;
121     }
122 
123     /**
124      * @dev Allows the pendingOwner address to finalize the transfer.
125      */
126     function claimOwnership() public onlyPendingOwner {
127          OwnershipTransferred(owner, pendingOwner);
128         owner = pendingOwner;
129         pendingOwner = address(0);
130     }
131 }
132 
133 
134 /**
135  * @title ERC20Basic
136  * @dev Simpler version of ERC20 interface
137  * @dev see https://github.com/ethereum/EIPs/issues/179
138  */
139 contract ERC20Basic {
140 
141   uint256 internal totalSupply_;
142 
143   /**
144   * @dev Total number of tokens in existence
145   */
146   function totalSupply() public view returns (uint256) {
147     return totalSupply_;
148   }
149 
150   function balanceOf(address who) public view returns (uint256);
151   function transfer(address to, uint256 value) public returns (bool);
152 
153   event Transfer(address indexed from, address indexed to, uint256 value);
154   event Approval(
155     address indexed owner,
156     address indexed spender,
157     uint256 value
158   );
159 }
160 
161 
162 
163 
164 /**
165  * @title ERC20 interface
166  * @dev see https://github.com/ethereum/EIPs/issues/20
167  */
168 contract ERC20 is ERC20Basic {
169   function allowance(address owner, address spender) public view returns (uint256);
170   function transferFrom(address from, address to, uint256 value) public returns (bool);
171   function approve(address spender, uint256 value) public returns (bool);
172 
173   event Transfer(
174     address indexed from,
175     address indexed to,
176     uint256 value
177   );
178 
179   event Approval(
180     address indexed owner,
181     address indexed spender,
182     uint256 value
183   );
184 }
185 
186 
187 
188 
189 /**
190  * @title Basic token
191  * @dev Basic version of StandardToken, with no allowances.
192  */
193 contract BasicToken is ERC20Basic {
194   using SafeMath for uint256;
195 
196   mapping(address => uint256) balances;
197 
198   /**
199   * @dev transfer token for a specified address
200   * @param _to The address to transfer to.
201   * @param _value The amount to be transferred.
202   */
203   function transfer(address _to, uint256 _value) public returns (bool) {
204     require(_to != address(0));
205     require(_value <= balances[msg.sender]);
206 
207     // SafeMath.sub will throw if there is not enough balance.
208     balances[msg.sender] = balances[msg.sender].sub(_value);
209     balances[_to] = balances[_to].add(_value);
210      Transfer(msg.sender, _to, _value);
211     return true;
212   }
213 
214   /**
215   * @dev Gets the balance of the specified address.
216   * @param _owner The address to query the the balance of.
217   * @return An uint256 representing the amount owned by the passed address.
218   */
219   function balanceOf(address _owner) public view returns (uint256 balance) {
220     return balances[_owner];
221   }
222 
223 }
224 
225 
226 /**
227  * @title LimitedTransferToken
228  * @dev LimitedTransferToken defines the generic interface and the implementation to limit token
229  * transferability for different events. It is intended to be used as a base class for other token
230  * contracts.
231  * LimitedTransferToken has been designed to allow for different limiting factors,
232  * this can be achieved by recursively calling super.transferableTokens() until the base class is
233  * hit. For example:
234  *     function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
235  *       return min256(unlockedTokens, super.transferableTokens(holder, time));
236  *     }
237  * A working example is VestedToken.sol:
238  * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/VestedToken.sol
239  */
240 
241 contract LimitedTransferToken is ERC20 {
242 
243   /**
244    * @dev Checks whether it can transfer or otherwise throws.
245    */
246   modifier canTransfer(address _sender, uint256 _value) {
247    require(_value <= transferableTokens(_sender, uint64(block.timestamp)));
248    _;
249   }
250 
251   /**
252    * @dev Checks modifier and allows transfer if tokens are not locked.
253    * @param _to The address that will receive the tokens.
254    * @param _value The amount of tokens to be transferred.
255    */
256   function transfer(address _to, uint256 _value) canTransfer(msg.sender, _value) public returns (bool) {
257     return super.transfer(_to, _value);
258   }
259 
260   /**
261   * @dev Checks modifier and allows transfer if tokens are not locked.
262   * @param _from The address that will send the tokens.
263   * @param _to The address that will receive the tokens.
264   * @param _value The amount of tokens to be transferred.
265   */
266   function transferFrom(address _from, address _to, uint256 _value) canTransfer(_from, _value) public returns (bool) {
267     return super.transferFrom(_from, _to, _value);
268   }
269 
270   /**
271    * @dev Default transferable tokens function returns all tokens for a holder (no limit).
272    * @dev Overwriting transferableTokens(address holder, uint64 time) is the way to provide the
273    * specific logic for limiting token transferability for a holder over time.
274    */
275   function transferableTokens(address holder, uint64 time) public view returns (uint256) {
276     return balanceOf(holder);
277   }
278 }
279 
280 
281 
282 /**
283  * @title Standard ERC20 token
284  *
285  * @dev Implementation of the basic standard token.
286  * https://github.com/ethereum/EIPs/issues/20
287  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
288  */
289 contract StandardToken is ERC20 {
290   using SafeMath for uint256;
291 
292   mapping(address => uint256) balances;
293 
294   mapping (address => mapping (address => uint256)) internal allowed;
295 
296 
297 
298 
299   /**
300   * @dev Gets the balance of the specified address.
301   * @param _owner The address to query the the balance of.
302   * @return An uint256 representing the amount owned by the passed address.
303   */
304   function balanceOf(address _owner) public view returns (uint256) {
305     return balances[_owner];
306   }
307 
308   /**
309    * @dev Function to check the amount of tokens that an owner allowed to a spender.
310    * @param _owner address The address which owns the funds.
311    * @param _spender address The address which will spend the funds.
312    * @return A uint256 specifying the amount of tokens still available for the spender.
313    */
314   function allowance(
315     address _owner,
316     address _spender
317   )
318   public
319   view
320   returns (uint256)
321   {
322     return allowed[_owner][_spender];
323   }
324 
325   /**
326   * @dev Transfer token for a specified address
327   * @param _to The address to transfer to.
328   * @param _value The amount to be transferred.
329   */
330   function transfer(address _to, uint256 _value) public returns (bool) {
331     require(_value <= balances[msg.sender]);
332     require(_to != address(0));
333 
334     balances[msg.sender] = balances[msg.sender].sub(_value);
335     balances[_to] = balances[_to].add(_value);
336      Transfer(msg.sender, _to, _value);
337     return true;
338   }
339 
340   /**
341    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
342    * Beware that changing an allowance with this method brings the risk that someone may use both the old
343    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
344    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
345    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
346    * @param _spender The address which will spend the funds.
347    * @param _value The amount of tokens to be spent.
348    */
349   function approve(address _spender, uint256 _value) public returns (bool) {
350     allowed[msg.sender][_spender] = _value;
351      Approval(msg.sender, _spender, _value);
352     return true;
353   }
354 
355   /**
356    * @dev Transfer tokens from one address to another
357    * @param _from address The address which you want to send tokens from
358    * @param _to address The address which you want to transfer to
359    * @param _value uint256 the amount of tokens to be transferred
360    */
361   function transferFrom(
362     address _from,
363     address _to,
364     uint256 _value
365   )
366   public
367   returns (bool)
368   {
369     require(_value <= balances[_from]);
370     require(_value <= allowed[_from][msg.sender]);
371     require(_to != address(0));
372 
373     balances[_from] = balances[_from].sub(_value);
374     balances[_to] = balances[_to].add(_value);
375     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
376      Transfer(_from, _to, _value);
377     return true;
378   }
379 
380   /**
381    * @dev Increase the amount of tokens that an owner allowed to a spender.
382    * approve should be called when allowed[_spender] == 0. To increment
383    * allowed value is better to use this function to avoid 2 calls (and wait until
384    * the first transaction is mined)
385    * From MonolithDAO Token.sol
386    * @param _spender The address which will spend the funds.
387    * @param _addedValue The amount of tokens to increase the allowance by.
388    */
389   function increaseApproval(
390     address _spender,
391     uint256 _addedValue
392   )
393   public
394   returns (bool)
395   {
396     allowed[msg.sender][_spender] = (
397     allowed[msg.sender][_spender].add(_addedValue));
398      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
399     return true;
400   }
401 
402   /**
403    * @dev Decrease the amount of tokens that an owner allowed to a spender.
404    * approve should be called when allowed[_spender] == 0. To decrement
405    * allowed value is better to use this function to avoid 2 calls (and wait until
406    * the first transaction is mined)
407    * From MonolithDAO Token.sol
408    * @param _spender The address which will spend the funds.
409    * @param _subtractedValue The amount of tokens to decrease the allowance by.
410    */
411   function decreaseApproval(
412     address _spender,
413     uint256 _subtractedValue
414   )
415   public
416   returns (bool)
417   {
418     uint256 oldValue = allowed[msg.sender][_spender];
419     if (_subtractedValue >= oldValue) {
420       allowed[msg.sender][_spender] = 0;
421     } else {
422       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
423     }
424      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
425     return true;
426   }
427 
428 }
429 
430 
431 
432 
433 /**
434  * @title Mintable token
435  * @dev Simple ERC20 Token example, with mintable token creation
436  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
437  */
438 contract MintableToken is StandardToken, Claimable {
439   event Mint(address indexed to, uint256 amount);
440   event MintFinished();
441 
442   bool public mintingFinished = false;
443 
444 
445   modifier canMint() {
446     require(!mintingFinished);
447     _;
448   }
449 
450   modifier hasMintPermission() {
451     require(msg.sender == owner);
452     _;
453   }
454 
455   /**
456    * @dev Function to mint tokens
457    * @param _to The address that will receive the minted tokens.
458    * @param _amount The amount of tokens to mint.
459    * @return A boolean that indicates if the operation was successful.
460    */
461   function mint(
462     address _to,
463     uint256 _amount
464   )
465   public
466   hasMintPermission
467   canMint
468   returns (bool)
469   {
470     totalSupply_ = totalSupply_.add(_amount);
471     balances[_to] = balances[_to].add(_amount);
472      Mint(_to, _amount);
473      Transfer(address(0), _to, _amount);
474     return true;
475   }
476 
477   /**
478    * @dev Function to stop minting new tokens.
479    * @return True if the operation was successful.
480    */
481   function finishMinting() public onlyOwner canMint returns (bool) {
482     mintingFinished = true;
483      MintFinished();
484     return true;
485   }
486 }
487 
488 /*
489     Smart Token interface
490 */
491 contract ISmartToken {
492 
493     // =================================================================================================================
494     //                                      Members
495     // =================================================================================================================
496 
497     bool public transfersEnabled = false;
498 
499     // =================================================================================================================
500     //                                      Event
501     // =================================================================================================================
502 
503     // triggered when a smart token is deployed - the _token address is defined for forward compatibility, in case we want to trigger the event from a factory
504     event NewSmartToken(address _token);
505     // triggered when the total supply is increased
506     event Issuance(uint256 _amount);
507     // triggered when the total supply is decreased
508     event Destruction(uint256 _amount);
509 
510     // =================================================================================================================
511     //                                      Functions
512     // =================================================================================================================
513 
514     function disableTransfers(bool _disable) public;
515     function issue(address _to, uint256 _amount) public;
516     function destroy(address _from, uint256 _amount) public;
517 }
518 
519 
520 /**
521     BancorSmartToken
522 */
523 contract LimitedTransferBancorSmartToken is MintableToken, ISmartToken, LimitedTransferToken {
524 
525     // =================================================================================================================
526     //                                      Modifiers
527     // =================================================================================================================
528 
529     /**
530      * @dev Throws if destroy flag is not enabled.
531      */
532     modifier canDestroy() {
533         require(destroyEnabled);
534         _;
535     }
536 
537     // =================================================================================================================
538     //                                      Members
539     // =================================================================================================================
540 
541     // We add this flag to avoid users and owner from destroy tokens during crowdsale,
542     // This flag is set to false by default and blocks destroy function,
543     // We enable destroy option on finalize, so destroy will be possible after the crowdsale.
544     bool public destroyEnabled = false;
545 
546     // =================================================================================================================
547     //                                      Public Functions
548     // =================================================================================================================
549 
550     function setDestroyEnabled(bool _enable) onlyOwner public {
551         destroyEnabled = _enable;
552     }
553 
554     // =================================================================================================================
555     //                                      Impl ISmartToken
556     // =================================================================================================================
557 
558     //@Override
559     function disableTransfers(bool _disable) onlyOwner public {
560         transfersEnabled = !_disable;
561     }
562 
563     //@Override
564     function issue(address _to, uint256 _amount) onlyOwner public {
565         require(super.mint(_to, _amount));
566          Issuance(_amount);
567     }
568 
569     //@Override
570     function destroy(address _from, uint256 _amount) canDestroy public {
571 
572         require(msg.sender == _from || msg.sender == owner); // validate input
573 
574         balances[_from] = balances[_from].sub(_amount);
575         totalSupply_ = totalSupply_.sub(_amount);
576 
577          Destruction(_amount);
578          Transfer(_from, 0x0, _amount);
579     }
580 
581     // =================================================================================================================
582     //                                      Impl LimitedTransferToken
583     // =================================================================================================================
584 
585 
586     // Enable/Disable token transfer
587     // Tokens will be locked in their wallets until the end of the Crowdsale.
588     // @holder - token`s owner
589     // @time - not used (framework unneeded functionality)
590     //
591     // @Override
592     function transferableTokens(address holder, uint64 time) public constant returns (uint256) {
593         require(transfersEnabled);
594         return super.transferableTokens(holder, time);
595     }
596 }
597 
598 
599 
600 
601 /**
602   A Token which is 'Bancor' compatible and can mint new tokens and pause token-transfer functionality
603 */
604 contract BitMEDSmartToken is LimitedTransferBancorSmartToken {
605 
606     // =================================================================================================================
607     //                                         Members
608     // =================================================================================================================
609 
610     string public constant name = "BitMED";
611 
612     string public constant symbol = "BXM";
613 
614     uint8 public constant decimals = 18;
615 
616     // =================================================================================================================
617     //                                         Constructor
618     // =================================================================================================================
619 
620     function BitMEDSmartToken() public {
621         //Apart of 'Bancor' computability - triggered when a smart token is deployed
622          NewSmartToken(address(this));
623     }
624 }
625 
626 
627 /**
628  * @title Vault
629  * @dev This wallet is used to
630  */
631 contract Vault is Claimable {
632     using SafeMath for uint256;
633 
634     // =================================================================================================================
635     //                                      Enums
636     // =================================================================================================================
637 
638     enum State { KycPending, KycComplete }
639 
640     // =================================================================================================================
641     //                                      Members
642     // =================================================================================================================
643     mapping (address => uint256) public depositedETH;
644     mapping (address => uint256) public depositedToken;
645 
646     BitMEDSmartToken public token;
647     State public state;
648 
649     // =================================================================================================================
650     //                                      Events
651     // =================================================================================================================
652 
653     event KycPending();
654     event KycComplete();
655     event Deposit(address indexed beneficiary, uint256 etherWeiAmount, uint256 tokenWeiAmount);
656     event RemoveSupporter(address beneficiary);
657     event TokensClaimed(address indexed beneficiary, uint256 weiAmount);
658     // =================================================================================================================
659     //                                      Modifiers
660     // =================================================================================================================
661 
662     modifier isKycPending() {
663         require(state == State.KycPending);
664         _;
665     }
666 
667     modifier isKycComplete() {
668         require(state == State.KycComplete);
669         _;
670     }
671 
672 
673     // =================================================================================================================
674     //                                      Ctors
675     // =================================================================================================================
676 
677     function Vault(BitMEDSmartToken _token) public {
678         require(_token != address(0));
679 
680         token = _token;
681         state = State.KycPending;
682          KycPending();
683     }
684 
685     // =================================================================================================================
686     //                                      Public Functions
687     // =================================================================================================================
688 
689     function deposit(address supporter, uint256 tokensAmount, uint256 value) isKycPending onlyOwner public{
690 
691         depositedETH[supporter] = depositedETH[supporter].add(value);
692         depositedToken[supporter] = depositedToken[supporter].add(tokensAmount);
693 
694          Deposit(supporter, value, tokensAmount);
695     }
696 
697     function kycComplete() isKycPending onlyOwner public {
698         state = State.KycComplete;
699          KycComplete();
700     }
701 
702     //@dev Remove a supporter and refund ether back to the supporter in returns of proportional amount of BXM back to the BitMED`s wallet
703     function removeSupporter(address supporter) isKycPending onlyOwner public {
704         require(supporter != address(0));
705         require(depositedETH[supporter] > 0);
706         require(depositedToken[supporter] > 0);
707 
708         uint256 depositedTokenValue = depositedToken[supporter];
709         uint256 depositedETHValue = depositedETH[supporter];
710 
711         //zero out the user
712         depositedETH[supporter] = 0;
713         depositedToken[supporter] = 0;
714 
715         token.destroy(address(this),depositedTokenValue);
716         // We will manually refund the money. Checking against OFAC sanction list
717         // https://sanctionssearch.ofac.treas.gov/
718         //supporter.transfer(depositedETHValue - 21000);
719 
720          RemoveSupporter(supporter);
721     }
722 
723     //@dev Transfer tokens from the vault to the supporter while releasing proportional amount of ether to BitMED`s wallet.
724     //Can be triggerd by the supporter only
725     function claimTokens(uint256 tokensToClaim) isKycComplete public {
726         require(tokensToClaim != 0);
727 
728         address supporter = msg.sender;
729         require(depositedToken[supporter] > 0);
730 
731         uint256 depositedTokenValue = depositedToken[supporter];
732         uint256 depositedETHValue = depositedETH[supporter];
733 
734         require(tokensToClaim <= depositedTokenValue);
735 
736         uint256 claimedETH = tokensToClaim.mul(depositedETHValue).div(depositedTokenValue);
737 
738         assert(claimedETH > 0);
739 
740         depositedETH[supporter] = depositedETHValue.sub(claimedETH);
741         depositedToken[supporter] = depositedTokenValue.sub(tokensToClaim);
742 
743         token.transfer(supporter, tokensToClaim);
744 
745          TokensClaimed(supporter, tokensToClaim);
746     }
747 
748     //@dev Transfer tokens from the vault to the supporter
749     //Can be triggerd by the owner of the vault
750     function claimAllSupporterTokensByOwner(address supporter) isKycComplete onlyOwner public {
751         uint256 depositedTokenValue = depositedToken[supporter];
752         require(depositedTokenValue > 0);
753         token.transfer(supporter, depositedTokenValue);
754          TokensClaimed(supporter, depositedTokenValue);
755     }
756 
757     // @dev supporter can claim tokens by calling the function
758     // @param tokenToClaimAmount - amount of the token to claim
759     function claimAllTokens() isKycComplete public  {
760         uint256 depositedTokenValue = depositedToken[msg.sender];
761         claimTokens(depositedTokenValue);
762     }
763 
764 
765 }
766 
767 
768 /**
769  * @title RefundVault
770  * @dev This contract is used for storing TOKENS AND ETHER while a crowd sale is in progress for a period of 3 DAYS.
771  * Supporter can ask for a full/part refund for his/her ether against token. Once tokens are Claimed by the supporter, they cannot be refunded.
772  * After 3 days, all ether will be withdrawn from the vault`s wallet, leaving all tokens to be claimed by the their owners.
773  **/
774 contract RefundVault is Claimable {
775     using SafeMath for uint256;
776 
777     // =================================================================================================================
778     //                                      Enums
779     // =================================================================================================================
780 
781     enum State { Active, Refunding, Closed }
782 
783     // =================================================================================================================
784     //                                      Members
785     // =================================================================================================================
786 
787     // Refund time frame
788     uint256 public constant REFUND_TIME_FRAME = 3 days;
789 
790     mapping (address => uint256) public depositedETH;
791     mapping (address => uint256) public depositedToken;
792 
793     address public etherWallet;
794     BitMEDSmartToken public token;
795     State public state;
796     uint256 public refundStartTime;
797 
798     // =================================================================================================================
799     //                                      Events
800     // =================================================================================================================
801 
802     event Active();
803     event Closed();
804     event Deposit(address indexed beneficiary, uint256 etherWeiAmount, uint256 tokenWeiAmount);
805     event RefundsEnabled();
806     event RefundedETH(address beneficiary, uint256 weiAmount);
807     event TokensClaimed(address indexed beneficiary, uint256 weiAmount);
808 
809     // =================================================================================================================
810     //                                      Modifiers
811     // =================================================================================================================
812 
813     modifier isActiveState() {
814         require(state == State.Active);
815         _;
816     }
817 
818     modifier isRefundingState() {
819         require(state == State.Refunding);
820         _;
821     }
822 
823     modifier isCloseState() {
824         require(state == State.Closed);
825         _;
826     }
827 
828     modifier isRefundingOrCloseState() {
829         require(state == State.Refunding || state == State.Closed);
830         _;
831     }
832 
833     modifier  isInRefundTimeFrame() {
834         require(refundStartTime <= block.timestamp && refundStartTime + REFUND_TIME_FRAME > block.timestamp);
835         _;
836     }
837 
838     modifier isRefundTimeFrameExceeded() {
839         require(refundStartTime + REFUND_TIME_FRAME < block.timestamp);
840         _;
841     }
842 
843 
844     // =================================================================================================================
845     //                                      Ctors
846     // =================================================================================================================
847 
848     function RefundVault(address _etherWallet, BitMEDSmartToken _token) public {
849         require(_etherWallet != address(0));
850         require(_token != address(0));
851 
852         etherWallet = _etherWallet;
853         token = _token;
854         state = State.Active;
855          Active();
856     }
857 
858     // =================================================================================================================
859     //                                      Public Functions
860     // =================================================================================================================
861 
862     function deposit(address supporter, uint256 tokensAmount) isActiveState onlyOwner public payable {
863 
864         depositedETH[supporter] = depositedETH[supporter].add(msg.value);
865         depositedToken[supporter] = depositedToken[supporter].add(tokensAmount);
866 
867          Deposit(supporter, msg.value, tokensAmount);
868     }
869 
870     function close() isRefundingState onlyOwner isRefundTimeFrameExceeded public {
871         state = State.Closed;
872          Closed();
873         etherWallet.transfer(address(this).balance);
874     }
875 
876     function enableRefunds() isActiveState onlyOwner public {
877         state = State.Refunding;
878         refundStartTime = block.timestamp;
879 
880          RefundsEnabled();
881     }
882 
883     //@dev Refund ether back to the supporter in returns of proportional amount of BXM back to the BitMED`s wallet
884     function refundETH(uint256 ETHToRefundAmountWei) isInRefundTimeFrame isRefundingState public {
885         require(ETHToRefundAmountWei != 0);
886 
887         uint256 depositedTokenValue = depositedToken[msg.sender];
888         uint256 depositedETHValue = depositedETH[msg.sender];
889 
890         require(ETHToRefundAmountWei <= depositedETHValue);
891 
892         uint256 refundTokens = ETHToRefundAmountWei.mul(depositedTokenValue).div(depositedETHValue);
893 
894         assert(refundTokens > 0);
895 
896         depositedETH[msg.sender] = depositedETHValue.sub(ETHToRefundAmountWei);
897         depositedToken[msg.sender] = depositedTokenValue.sub(refundTokens);
898 
899         token.destroy(address(this),refundTokens);
900         msg.sender.transfer(ETHToRefundAmountWei);
901 
902          RefundedETH(msg.sender, ETHToRefundAmountWei);
903     }
904 
905     //@dev Transfer tokens from the vault to the supporter while releasing proportional amount of ether to BitMED`s wallet.
906     //Can be triggerd by the supporter only
907     function claimTokens(uint256 tokensToClaim) isRefundingOrCloseState public {
908         require(tokensToClaim != 0);
909 
910         address supporter = msg.sender;
911         require(depositedToken[supporter] > 0);
912 
913         uint256 depositedTokenValue = depositedToken[supporter];
914         uint256 depositedETHValue = depositedETH[supporter];
915 
916         require(tokensToClaim <= depositedTokenValue);
917 
918         uint256 claimedETH = tokensToClaim.mul(depositedETHValue).div(depositedTokenValue);
919 
920         assert(claimedETH > 0);
921 
922         depositedETH[supporter] = depositedETHValue.sub(claimedETH);
923         depositedToken[supporter] = depositedTokenValue.sub(tokensToClaim);
924 
925         token.transfer(supporter, tokensToClaim);
926         if(state != State.Closed) {
927             etherWallet.transfer(claimedETH);
928         }
929 
930          TokensClaimed(supporter, tokensToClaim);
931     }
932 
933     //@dev Transfer tokens from the vault to the supporter while releasing proportional amount of ether to BitMED`s wallet.
934     //Can be triggerd by the owner of the vault (in our case - BitMED`s owner after 3 days)
935     function claimAllSupporterTokensByOwner(address supporter) isCloseState onlyOwner public {
936         uint256 depositedTokenValue = depositedToken[supporter];
937         require(depositedTokenValue > 0);
938 
939 
940         token.transfer(supporter, depositedTokenValue);
941 
942          TokensClaimed(supporter, depositedTokenValue);
943     }
944 
945     // @dev supporter can claim tokens by calling the function
946     // @param tokenToClaimAmount - amount of the token to claim
947     function claimAllTokens() isRefundingOrCloseState public  {
948         uint256 depositedTokenValue = depositedToken[msg.sender];
949         claimTokens(depositedTokenValue);
950     }
951 
952 
953 }
954 
955 
956 /**
957  * @title Crowdsale
958  * @dev Crowdsale is a base contract for managing a token crowdsale.
959  * Crowdsales have a start and end timestamps, where investors can make
960  * token purchases and the crowdsale will assign them tokens based
961  * on a token per ETH rate. Funds collected are forwarded to a wallet
962  * as they arrive.
963  */
964 contract Crowdsale {
965     using SafeMath for uint256;
966 
967     // The token being sold
968     BitMEDSmartToken public token;
969 
970     // start and end timestamps where investments are allowed (both inclusive)
971     uint256 public startTime;
972 
973     uint256 public endTime;
974 
975     // address where funds are collected
976     address public wallet;
977 
978     // how many token units a buyer gets per wei
979     uint256 public rate;
980 
981     // amount of raised money in wei
982     uint256 public weiRaised;
983 
984     // holding vault for all tokens pending KYC
985     Vault public vault;
986 
987     /**
988      * event for token purchase logging
989      * @param purchaser who paid for the tokens
990      * @param beneficiary who got the tokens
991      * @param value weis paid for purchase
992      * @param amount amount of tokens purchased
993      */
994     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
995 
996     function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, BitMEDSmartToken _token, Vault _vault) public {
997         require(_startTime >= block.timestamp);
998         require(_endTime >= _startTime);
999         require(_rate > 0);
1000         require(_wallet != address(0));
1001         require(_token != address(0));
1002         require(_vault != address(0));
1003 
1004         startTime = _startTime;
1005         endTime = _endTime;
1006         rate = _rate;
1007         wallet = _wallet;
1008         token = _token;
1009         vault = _vault;
1010     }
1011 
1012     // fallback function can be used to buy tokens
1013     function() external payable {
1014         buyTokens(msg.sender);
1015     }
1016 
1017     // low level token purchase function
1018     function buyTokens(address beneficiary) public payable {
1019         require(beneficiary != address(0));
1020         require(validPurchase());
1021 
1022         uint256 weiAmount = msg.value;
1023 
1024         require(weiAmount>500000000000000000);
1025 
1026         // calculate token amount to be created
1027         uint256 tokens = weiAmount.mul(getRate());
1028 
1029         // update state
1030         weiRaised = weiRaised.add(weiAmount);
1031 
1032         //send tokens to KYC Vault
1033         token.issue(address(vault), tokens);
1034 
1035         // Updating arrays in the Vault
1036         vault.deposit(beneficiary, tokens, msg.value);
1037 
1038          TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
1039 
1040         // Transferring funds to wallet
1041         forwardFunds();
1042     }
1043 
1044     // send ether to the fund collection wallet
1045     // override to create custom fund forwarding mechanisms
1046     function forwardFunds() internal {
1047         wallet.transfer(msg.value);
1048     }
1049 
1050     // @return true if the transaction can buy tokens
1051     function validPurchase() internal view returns (bool) {
1052         bool withinPeriod = block.timestamp >= startTime && block.timestamp <= endTime;
1053         bool nonZeroPurchase = msg.value != 0;
1054         return withinPeriod && nonZeroPurchase;
1055     }
1056 
1057     // @return true if crowdsale event has ended
1058     function hasEnded() public view returns (bool) {
1059         return block.timestamp > endTime;
1060     }
1061 
1062     // @return the crowdsale rate
1063     function getRate() public view returns (uint256) {
1064         return rate;
1065     }
1066 }
1067 
1068 
1069 /**
1070  * @title FinalizableCrowdsale
1071  * @dev Extension of Crowdsale where an owner can do extra work
1072  * after finishing.
1073  */
1074 contract FinalizableCrowdsale is Crowdsale, Claimable {
1075   using SafeMath for uint256;
1076 
1077   bool public isFinalized = false;
1078 
1079   event Finalized();
1080 
1081   /**
1082    * @dev Must be called after crowdsale ends, to do some extra finalization
1083    * work. Calls the contract's finalization function.
1084    */
1085   function finalize() public onlyOwner  {
1086     require(!isFinalized);
1087     require(hasEnded());
1088 
1089     finalization();
1090      Finalized();
1091 
1092     isFinalized = true;
1093   }
1094 
1095   /**
1096    * @dev Can be overridden to add finalization logic. The overriding function
1097    * should call super.finalization() to ensure the chain of finalization is
1098    * executed entirely.
1099    */
1100   function finalization() internal {
1101   }
1102 }
1103 
1104 
1105 
1106 contract BitMEDCrowdsale is FinalizableCrowdsale {
1107 
1108     // =================================================================================================================
1109     //                                      Constants
1110     // =================================================================================================================
1111     // Max amount of known addresses of which will get BXM by 'Grant' method.
1112     //
1113     // grantees addresses will be BitMED wallets addresses.
1114     // these wallets will contain BXM tokens that will be used for one purposes only -
1115     // 1. BXM tokens against raised fiat money
1116     // we set the value to 10 (and not to 2) because we want to allow some flexibility for cases like fiat money that is raised close
1117     // to the crowdsale. we limit the value to 10 (and not larger) to limit the run time of the function that process the grantees array.
1118     uint8 public constant MAX_TOKEN_GRANTEES = 10;
1119 
1120     // BXM to ETH base rate
1121     uint256 public constant EXCHANGE_RATE = 210;
1122 
1123     // Refund division rate
1124     uint256 public constant REFUND_DIVISION_RATE = 2;
1125 
1126     // The min BXM tokens that should be minted for the public sale
1127     uint256 public constant MIN_TOKEN_SALE = 125000000000000000000000000;
1128 
1129 
1130     // =================================================================================================================
1131     //                                      Modifiers
1132     // =================================================================================================================
1133 
1134     /**
1135      * @dev Throws if called not during the crowdsale time frame
1136      */
1137     modifier onlyWhileSale() {
1138         require(isActive());
1139         _;
1140     }
1141 
1142     // =================================================================================================================
1143     //                                      Members
1144     // =================================================================================================================
1145 
1146     // wallets address for 75% of BXM allocation
1147     address public walletTeam;      //10% of the total number of BXM tokens will be allocated to the team
1148     address public walletReserve;   //35% of the total number of BXM tokens will be allocated to BitMED  and as a reserve for the company to be used for future strategic plans for the created ecosystem
1149     address public walletCommunity; //30% of the total number of BXM tokens will be allocated to Community
1150 
1151     // Funds collected outside the crowdsale in wei
1152     uint256 public fiatRaisedConvertedToWei;
1153 
1154     //Grantees - used for non-ether and presale bonus token generation
1155     address[] public presaleGranteesMapKeys;
1156     mapping (address => uint256) public presaleGranteesMap;  //address=>wei token amount
1157 
1158     // The refund vault
1159     RefundVault public refundVault;
1160 
1161     // =================================================================================================================
1162     //                                      Events
1163     // =================================================================================================================
1164     event GrantAdded(address indexed _grantee, uint256 _amount);
1165 
1166     event GrantUpdated(address indexed _grantee, uint256 _oldAmount, uint256 _newAmount);
1167 
1168     event GrantDeleted(address indexed _grantee, uint256 _hadAmount);
1169 
1170     event FiatRaisedUpdated(address indexed _address, uint256 _fiatRaised);
1171 
1172     event TokenPurchaseWithGuarantee(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
1173 
1174     // =================================================================================================================
1175     //                                      Constructors
1176     // =================================================================================================================
1177 
1178     function BitMEDCrowdsale(uint256 _startTime,
1179     uint256 _endTime,
1180     address _wallet,
1181     address _walletTeam,
1182     address _walletCommunity,
1183     address _walletReserve,
1184     BitMEDSmartToken _BitMEDSmartToken,
1185     RefundVault _refundVault,
1186     Vault _vault)
1187 
1188     public Crowdsale(_startTime, _endTime, EXCHANGE_RATE, _wallet, _BitMEDSmartToken, _vault) {
1189         require(_walletTeam != address(0));
1190         require(_walletCommunity != address(0));
1191         require(_walletReserve != address(0));
1192         require(_BitMEDSmartToken != address(0));
1193         require(_refundVault != address(0));
1194         require(_vault != address(0));
1195 
1196         walletTeam = _walletTeam;
1197         walletCommunity = _walletCommunity;
1198         walletReserve = _walletReserve;
1199 
1200         token = _BitMEDSmartToken;
1201         refundVault  = _refundVault;
1202 
1203         vault = _vault;
1204 
1205     }
1206 
1207     // =================================================================================================================
1208     //                                      Impl Crowdsale
1209     // =================================================================================================================
1210 
1211     // @return the rate in BXM per 1 ETH according to the time of the tx and the BXM pricing program.
1212     // @Override
1213     function getRate() public view returns (uint256) {
1214         if (block.timestamp < (startTime.add(24 hours))) {return 700;}
1215         if (block.timestamp < (startTime.add(3 days))) {return 600;}
1216         if (block.timestamp < (startTime.add(5 days))) {return 500;}
1217         if (block.timestamp < (startTime.add(7 days))) {return 400;}
1218         if (block.timestamp < (startTime.add(10 days))) {return 350;}
1219         if (block.timestamp < (startTime.add(13 days))) {return 300;}
1220         if (block.timestamp < (startTime.add(16 days))) {return 285;}
1221         if (block.timestamp < (startTime.add(19 days))) {return 270;}
1222         if (block.timestamp < (startTime.add(22 days))) {return 260;}
1223         if (block.timestamp < (startTime.add(25 days))) {return 250;}
1224         if (block.timestamp < (startTime.add(28 days))) {return 240;}
1225         if (block.timestamp < (startTime.add(31 days))) {return 230;}
1226         if (block.timestamp < (startTime.add(34 days))) {return 225;}
1227         if (block.timestamp < (startTime.add(37 days))) {return 220;}
1228         if (block.timestamp < (startTime.add(40 days))) {return 215;}
1229 
1230         return rate;
1231     }
1232 
1233     // =================================================================================================================
1234     //                                      Impl FinalizableCrowdsale
1235     // =================================================================================================================
1236 
1237     //@Override
1238     function finalization() internal {
1239 
1240         super.finalization();
1241 
1242         // granting bonuses for the pre crowdsale grantees:
1243         for (uint256 i = 0; i < presaleGranteesMapKeys.length; i++) {
1244             token.issue(presaleGranteesMapKeys[i], presaleGranteesMap[presaleGranteesMapKeys[i]]);
1245         }
1246 
1247         //we want to make sure a min of 125M tokens are generated which equals the 25% of the crowdsale
1248         if(token.totalSupply() <= MIN_TOKEN_SALE){
1249             uint256 missingTokens = MIN_TOKEN_SALE - token.totalSupply();
1250             token.issue(walletCommunity, missingTokens);
1251         }
1252 
1253         // Adding 75% of the total token supply (25% were generated during the crowdsale)
1254         // 25 * 4 = 100
1255         uint256 newTotalSupply = token.totalSupply().mul(400).div(100);
1256 
1257         // 10% of the total number of BXM tokens will be allocated to the team
1258         token.issue(walletTeam, newTotalSupply.mul(10).div(100));
1259 
1260         // 30% of the total number of BXM tokens will be allocated to community
1261         token.issue(walletCommunity, newTotalSupply.mul(30).div(100));
1262 
1263         // 35% of the total number of BXM tokens will be allocated to BitMED ,
1264         // and as a reserve for the company to be used for future strategic plans for the created ecosystem
1265         token.issue(walletReserve, newTotalSupply.mul(35).div(100));
1266 
1267         // Re-enable transfers after the token sale.
1268         token.disableTransfers(false);
1269 
1270         // Re-enable destroy function after the token sale.
1271         token.setDestroyEnabled(true);
1272 
1273         // Enable ETH refunds and token claim.
1274         refundVault.enableRefunds();
1275 
1276         // transfer token ownership to crowdsale owner
1277         token.transferOwnership(owner);
1278 
1279         // transfer refundVault ownership to crowdsale owner
1280         refundVault.transferOwnership(owner);
1281 
1282         vault.transferOwnership(owner);
1283 
1284     }
1285 
1286     // =================================================================================================================
1287     //                                      Public Methods
1288     // =================================================================================================================
1289     // @return the total funds collected in wei(ETH and none ETH).
1290     function getTotalFundsRaised() public view returns (uint256) {
1291         return fiatRaisedConvertedToWei.add(weiRaised);
1292     }
1293 
1294     // @return true if the crowdsale is active, hence users can buy tokens
1295     function isActive() public view returns (bool) {
1296         return block.timestamp >= startTime && block.timestamp < endTime;
1297     }
1298 
1299     // =================================================================================================================
1300     //                                      External Methods
1301     // =================================================================================================================
1302     // @dev Adds/Updates address and token allocation for token grants.
1303     // Granted tokens are allocated to non-ether, presale, buyers.
1304     // @param _grantee address The address of the token grantee.
1305     // @param _value uint256 The value of the grant in wei token.
1306     function addUpdateGrantee(address _grantee, uint256 _value) external onlyOwner onlyWhileSale{
1307         require(_grantee != address(0));
1308         require(_value > 0);
1309 
1310         // Adding new key if not present:
1311         if (presaleGranteesMap[_grantee] == 0) {
1312             require(presaleGranteesMapKeys.length < MAX_TOKEN_GRANTEES);
1313             presaleGranteesMapKeys.push(_grantee);
1314             GrantAdded(_grantee, _value);
1315         }
1316         else {
1317             GrantUpdated(_grantee, presaleGranteesMap[_grantee], _value);
1318         }
1319 
1320         presaleGranteesMap[_grantee] = _value;
1321     }
1322 
1323     // @dev deletes entries from the grants list.
1324     // @param _grantee address The address of the token grantee.
1325     function deleteGrantee(address _grantee) external onlyOwner onlyWhileSale {
1326     require(_grantee != address(0));
1327         require(presaleGranteesMap[_grantee] != 0);
1328 
1329         //delete from the map:
1330         delete presaleGranteesMap[_grantee];
1331 
1332         //delete from the array (keys):
1333         uint256 index;
1334         for (uint256 i = 0; i < presaleGranteesMapKeys.length; i++) {
1335             if (presaleGranteesMapKeys[i] == _grantee) {
1336                 index = i;
1337                 break;
1338             }
1339         }
1340         presaleGranteesMapKeys[index] = presaleGranteesMapKeys[presaleGranteesMapKeys.length - 1];
1341         delete presaleGranteesMapKeys[presaleGranteesMapKeys.length - 1];
1342         presaleGranteesMapKeys.length--;
1343 
1344         GrantDeleted(_grantee, presaleGranteesMap[_grantee]);
1345     }
1346 
1347     // @dev Set funds collected outside the crowdsale in wei.
1348     //  note: we not to use accumulator to allow flexibility in case of humane mistakes.
1349     // funds are converted to wei using the market conversion rate of USD\ETH on the day on the purchase.
1350     // @param _fiatRaisedConvertedToWei number of none eth raised.
1351     function setFiatRaisedConvertedToWei(uint256 _fiatRaisedConvertedToWei) external onlyOwner onlyWhileSale {
1352         fiatRaisedConvertedToWei = _fiatRaisedConvertedToWei;
1353         FiatRaisedUpdated(msg.sender, fiatRaisedConvertedToWei);
1354     }
1355 
1356     /// @dev Accepts new ownership on behalf of the BitMEDCrowdsale contract. This can be used, by the token sale
1357     /// contract itself to claim back ownership of the BitMEDSmartToken contract.
1358     function claimTokenOwnership() external onlyOwner {
1359         token.claimOwnership();
1360     }
1361 
1362     /// @dev Accepts new ownership on behalf of the BitMEDCrowdsale contract. This can be used, by the token sale
1363     /// contract itself to claim back ownership of the refundVault contract.
1364     function claimRefundVaultOwnership() external onlyOwner {
1365         refundVault.claimOwnership();
1366     }
1367 
1368     /// @dev Accepts new ownership on behalf of the BitMEDCrowdsale contract. This can be used, by the token sale
1369     /// contract itself to claim back ownership of the refundVault contract.
1370     function claimVaultOwnership() external onlyOwner {
1371         vault.claimOwnership();
1372     }
1373 
1374     // @dev Buy tokes with guarantee
1375     function buyTokensWithGuarantee() public payable {
1376         require(validPurchase());
1377 
1378         uint256 weiAmount = msg.value;
1379 
1380         require(weiAmount>500000000000000000);
1381 
1382         // calculate token amount to be created
1383         uint256 tokens = weiAmount.mul(getRate());
1384         tokens = tokens.div(REFUND_DIVISION_RATE);
1385 
1386         // update state
1387         weiRaised = weiRaised.add(weiAmount);
1388 
1389         token.issue(address(refundVault), tokens);
1390         refundVault.deposit.value(msg.value)(msg.sender, tokens);
1391 
1392         TokenPurchaseWithGuarantee(msg.sender, address(refundVault), weiAmount, tokens);
1393     }
1394 }