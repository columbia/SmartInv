1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (_a == 0) {
18       return 0;
19     }
20 
21     c = _a * _b;
22     assert(c / _a == _b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
30     // assert(_b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = _a / _b;
32     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
33     return _a / _b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
40     assert(_b <= _a);
41     return _a - _b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
48     c = _a + _b;
49     assert(c >= _a);
50     return c;
51   }
52 }
53 
54 
55 
56 /**
57  * @title ERC20Basic
58  * @dev Simpler version of ERC20 interface
59  * See https://github.com/ethereum/EIPs/issues/179
60  */
61 contract ERC20Basic {
62   function totalSupply() public view returns (uint256);
63   function balanceOf(address _who) public view returns (uint256);
64   function transfer(address _to, uint256 _value) public returns (bool);
65   event Transfer(address indexed from, address indexed to, uint256 value);
66 }
67 
68 
69 
70 /**
71  * @title Ownable
72  * @dev The Ownable contract has an owner address, and provides basic authorization control
73  * functions, this simplifies the implementation of "user permissions".
74  */
75 contract Ownable {
76   address public owner;
77 
78 
79   event OwnershipRenounced(address indexed previousOwner);
80   event OwnershipTransferred(
81     address indexed previousOwner,
82     address indexed newOwner
83   );
84 
85 
86   /**
87    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
88    * account.
89    */
90   constructor() public {
91     owner = msg.sender;
92   }
93 
94   /**
95    * @dev Throws if called by any account other than the owner.
96    */
97   modifier onlyOwner() {
98     require(msg.sender == owner);
99     _;
100   }
101 
102   /**
103    * @dev Allows the current owner to relinquish control of the contract.
104    * @notice Renouncing to ownership will leave the contract without an owner.
105    * It will not be possible to call the functions with the `onlyOwner`
106    * modifier anymore.
107    */
108   function renounceOwnership() public onlyOwner {
109     emit OwnershipRenounced(owner);
110     owner = address(0);
111   }
112 
113   /**
114    * @dev Allows the current owner to transfer control of the contract to a newOwner.
115    * @param _newOwner The address to transfer ownership to.
116    */
117   function transferOwnership(address _newOwner) public onlyOwner {
118     _transferOwnership(_newOwner);
119   }
120 
121   /**
122    * @dev Transfers control of the contract to a newOwner.
123    * @param _newOwner The address to transfer ownership to.
124    */
125   function _transferOwnership(address _newOwner) internal {
126     require(_newOwner != address(0));
127     emit OwnershipTransferred(owner, _newOwner);
128     owner = _newOwner;
129   }
130 }
131 
132 
133 library SafeMath16 {
134   function mul(uint16 a, uint16 b) internal pure returns (uint16) {
135     if (a == 0) {
136       return 0;
137     }
138     uint16 c = a * b;
139     assert(c / a == b);
140     return c;
141   }
142   function div(uint16 a, uint16 b) internal pure returns (uint16) {
143     // assert(b > 0); // Solidity automatically throws when dividing by 0
144     uint16 c = a / b;
145     // assert(a == b * c + a % b); // There is no case in which this doesn’t hold
146     return c;
147   }
148   function sub(uint16 a, uint16 b) internal pure returns (uint16) {
149     assert(b <= a);
150     return a - b;
151   }
152   function add(uint16 a, uint16 b) internal pure returns (uint16) {
153     uint16 c = a + b;
154     assert(c >= a);
155     return c;
156   }
157 }
158 
159 
160 
161 
162 
163 
164 
165 
166 /**
167  * @title ERC20 interface
168  * @dev see https://github.com/ethereum/EIPs/issues/20
169  */
170 contract ERC20 is ERC20Basic {
171   function allowance(address _owner, address _spender)
172     public view returns (uint256);
173 
174   function transferFrom(address _from, address _to, uint256 _value)
175     public returns (bool);
176 
177   function approve(address _spender, uint256 _value) public returns (bool);
178   event Approval(
179     address indexed owner,
180     address indexed spender,
181     uint256 value
182   );
183 }
184 
185 
186 
187 /**
188  * @title SafeERC20
189  * @dev Wrappers around ERC20 operations that throw on failure.
190  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
191  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
192  */
193 library SafeERC20 {
194   function safeTransfer(
195     ERC20Basic _token,
196     address _to,
197     uint256 _value
198   )
199     internal
200   {
201     require(_token.transfer(_to, _value));
202   }
203 
204   function safeTransferFrom(
205     ERC20 _token,
206     address _from,
207     address _to,
208     uint256 _value
209   )
210     internal
211   {
212     require(_token.transferFrom(_from, _to, _value));
213   }
214 
215   function safeApprove(
216     ERC20 _token,
217     address _spender,
218     uint256 _value
219   )
220     internal
221   {
222     require(_token.approve(_spender, _value));
223   }
224 }
225 
226 
227 
228 
229 
230 
231 
232 
233 /**
234  * @title Escrow
235  * @dev Base escrow contract, holds funds destinated to a payee until they
236  * withdraw them. The contract that uses the escrow as its payment method
237  * should be its owner, and provide public methods redirecting to the escrow's
238  * deposit and withdraw.
239  */
240 contract Escrow is Ownable {
241   using SafeMath for uint256;
242 
243   event Deposited(address indexed payee, uint256 weiAmount);
244   event Withdrawn(address indexed payee, uint256 weiAmount);
245 
246   mapping(address => uint256) private deposits;
247 
248   function depositsOf(address _payee) public view returns (uint256) {
249     return deposits[_payee];
250   }
251 
252   /**
253   * @dev Stores the sent amount as credit to be withdrawn.
254   * @param _payee The destination address of the funds.
255   */
256   function deposit(address _payee) public onlyOwner payable {
257     uint256 amount = msg.value;
258     deposits[_payee] = deposits[_payee].add(amount);
259 
260     emit Deposited(_payee, amount);
261   }
262 
263   /**
264   * @dev Withdraw accumulated balance for a payee.
265   * @param _payee The address whose funds will be withdrawn and transferred to.
266   */
267   function withdraw(address _payee) public onlyOwner {
268     uint256 payment = deposits[_payee];
269     assert(address(this).balance >= payment);
270 
271     deposits[_payee] = 0;
272 
273     _payee.transfer(payment);
274 
275     emit Withdrawn(_payee, payment);
276   }
277 }
278 
279 
280 
281 /**
282  * @title PullPayment
283  * @dev Base contract supporting async send for pull payments. Inherit from this
284  * contract and use asyncTransfer instead of send or transfer.
285  */
286 contract PullPayment {
287   Escrow private escrow;
288 
289   constructor() public {
290     escrow = new Escrow();
291   }
292 
293   /**
294   * @dev Withdraw accumulated balance, called by payee.
295   */
296   function withdrawPayments() public {
297     address payee = msg.sender;
298     escrow.withdraw(payee);
299   }
300 
301   /**
302   * @dev Returns the credit owed to an address.
303   * @param _dest The creditor's address.
304   */
305   function payments(address _dest) public view returns (uint256) {
306     return escrow.depositsOf(_dest);
307   }
308 
309   /**
310   * @dev Called by the payer to store the sent amount as credit to be pulled.
311   * @param _dest The destination address of the funds.
312   * @param _amount The amount to transfer.
313   */
314   function asyncTransfer(address _dest, uint256 _amount) internal {
315     escrow.deposit.value(_amount)(_dest);
316   }
317 }
318 /***************************************************************
319  * Modified Crowdsale.sol from the zeppelin-solidity framework *
320  * to support zero decimal token. The end time has been        *
321  * removed.                                                    *
322  * https://github.com/OpenZeppelin/zeppelin-solidity           *
323  ***************************************************************/
324 
325 
326 
327 
328 
329 
330 
331 /*****************************************************************
332  * Core contract of the Million Dollar Decentralized Application *
333  *****************************************************************/
334 
335 
336 
337 
338 
339 
340 
341 
342 
343 
344 /**
345  * @title Contracts that should not own Ether
346  * @author Remco Bloemen <remco@2π.com>
347  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
348  * in the contract, it will allow the owner to reclaim this Ether.
349  * @notice Ether can still be sent to this contract by:
350  * calling functions labeled `payable`
351  * `selfdestruct(contract_address)`
352  * mining directly to the contract address
353  */
354 contract HasNoEther is Ownable {
355 
356   /**
357   * @dev Constructor that rejects incoming Ether
358   * The `payable` flag is added so we can access `msg.value` without compiler warning. If we
359   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
360   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
361   * we could use assembly to access msg.value.
362   */
363   constructor() public payable {
364     require(msg.value == 0);
365   }
366 
367   /**
368    * @dev Disallows direct send by setting a default function without the `payable` flag.
369    */
370   function() external {
371   }
372 
373   /**
374    * @dev Transfer all Ether held by the contract to the owner.
375    */
376   function reclaimEther() external onlyOwner {
377     owner.transfer(address(this).balance);
378   }
379 }
380 
381 
382 
383 
384 
385 
386 
387 
388 /**
389  * @title Contracts that should be able to recover tokens
390  * @author SylTi
391  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
392  * This will prevent any accidental loss of tokens.
393  */
394 contract CanReclaimToken is Ownable {
395   using SafeERC20 for ERC20Basic;
396 
397   /**
398    * @dev Reclaim all ERC20Basic compatible tokens
399    * @param _token ERC20Basic The address of the token contract
400    */
401   function reclaimToken(ERC20Basic _token) external onlyOwner {
402     uint256 balance = _token.balanceOf(this);
403     _token.safeTransfer(owner, balance);
404   }
405 
406 }
407 
408 
409 
410 
411 
412 
413 
414 
415 
416 
417 
418 
419 
420 
421 
422 /**
423  * @title Basic token
424  * @dev Basic version of StandardToken, with no allowances.
425  */
426 contract BasicToken is ERC20Basic {
427   using SafeMath for uint256;
428 
429   mapping(address => uint256) internal balances;
430 
431   uint256 internal totalSupply_;
432 
433   /**
434   * @dev Total number of tokens in existence
435   */
436   function totalSupply() public view returns (uint256) {
437     return totalSupply_;
438   }
439 
440   /**
441   * @dev Transfer token for a specified address
442   * @param _to The address to transfer to.
443   * @param _value The amount to be transferred.
444   */
445   function transfer(address _to, uint256 _value) public returns (bool) {
446     require(_value <= balances[msg.sender]);
447     require(_to != address(0));
448 
449     balances[msg.sender] = balances[msg.sender].sub(_value);
450     balances[_to] = balances[_to].add(_value);
451     emit Transfer(msg.sender, _to, _value);
452     return true;
453   }
454 
455   /**
456   * @dev Gets the balance of the specified address.
457   * @param _owner The address to query the the balance of.
458   * @return An uint256 representing the amount owned by the passed address.
459   */
460   function balanceOf(address _owner) public view returns (uint256) {
461     return balances[_owner];
462   }
463 
464 }
465 
466 
467 
468 
469 /**
470  * @title Standard ERC20 token
471  *
472  * @dev Implementation of the basic standard token.
473  * https://github.com/ethereum/EIPs/issues/20
474  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
475  */
476 contract StandardToken is ERC20, BasicToken {
477 
478   mapping (address => mapping (address => uint256)) internal allowed;
479 
480 
481   /**
482    * @dev Transfer tokens from one address to another
483    * @param _from address The address which you want to send tokens from
484    * @param _to address The address which you want to transfer to
485    * @param _value uint256 the amount of tokens to be transferred
486    */
487   function transferFrom(
488     address _from,
489     address _to,
490     uint256 _value
491   )
492     public
493     returns (bool)
494   {
495     require(_value <= balances[_from]);
496     require(_value <= allowed[_from][msg.sender]);
497     require(_to != address(0));
498 
499     balances[_from] = balances[_from].sub(_value);
500     balances[_to] = balances[_to].add(_value);
501     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
502     emit Transfer(_from, _to, _value);
503     return true;
504   }
505 
506   /**
507    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
508    * Beware that changing an allowance with this method brings the risk that someone may use both the old
509    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
510    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
511    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
512    * @param _spender The address which will spend the funds.
513    * @param _value The amount of tokens to be spent.
514    */
515   function approve(address _spender, uint256 _value) public returns (bool) {
516     allowed[msg.sender][_spender] = _value;
517     emit Approval(msg.sender, _spender, _value);
518     return true;
519   }
520 
521   /**
522    * @dev Function to check the amount of tokens that an owner allowed to a spender.
523    * @param _owner address The address which owns the funds.
524    * @param _spender address The address which will spend the funds.
525    * @return A uint256 specifying the amount of tokens still available for the spender.
526    */
527   function allowance(
528     address _owner,
529     address _spender
530    )
531     public
532     view
533     returns (uint256)
534   {
535     return allowed[_owner][_spender];
536   }
537 
538   /**
539    * @dev Increase the amount of tokens that an owner allowed to a spender.
540    * approve should be called when allowed[_spender] == 0. To increment
541    * allowed value is better to use this function to avoid 2 calls (and wait until
542    * the first transaction is mined)
543    * From MonolithDAO Token.sol
544    * @param _spender The address which will spend the funds.
545    * @param _addedValue The amount of tokens to increase the allowance by.
546    */
547   function increaseApproval(
548     address _spender,
549     uint256 _addedValue
550   )
551     public
552     returns (bool)
553   {
554     allowed[msg.sender][_spender] = (
555       allowed[msg.sender][_spender].add(_addedValue));
556     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
557     return true;
558   }
559 
560   /**
561    * @dev Decrease the amount of tokens that an owner allowed to a spender.
562    * approve should be called when allowed[_spender] == 0. To decrement
563    * allowed value is better to use this function to avoid 2 calls (and wait until
564    * the first transaction is mined)
565    * From MonolithDAO Token.sol
566    * @param _spender The address which will spend the funds.
567    * @param _subtractedValue The amount of tokens to decrease the allowance by.
568    */
569   function decreaseApproval(
570     address _spender,
571     uint256 _subtractedValue
572   )
573     public
574     returns (bool)
575   {
576     uint256 oldValue = allowed[msg.sender][_spender];
577     if (_subtractedValue >= oldValue) {
578       allowed[msg.sender][_spender] = 0;
579     } else {
580       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
581     }
582     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
583     return true;
584   }
585 
586 }
587 
588 
589 
590 
591 /**
592  * @title Mintable token
593  * @dev Simple ERC20 Token example, with mintable token creation
594  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
595  */
596 contract MintableToken is StandardToken, Ownable {
597   event Mint(address indexed to, uint256 amount);
598   event MintFinished();
599 
600   bool public mintingFinished = false;
601 
602 
603   modifier canMint() {
604     require(!mintingFinished);
605     _;
606   }
607 
608   modifier hasMintPermission() {
609     require(msg.sender == owner);
610     _;
611   }
612 
613   /**
614    * @dev Function to mint tokens
615    * @param _to The address that will receive the minted tokens.
616    * @param _amount The amount of tokens to mint.
617    * @return A boolean that indicates if the operation was successful.
618    */
619   function mint(
620     address _to,
621     uint256 _amount
622   )
623     public
624     hasMintPermission
625     canMint
626     returns (bool)
627   {
628     totalSupply_ = totalSupply_.add(_amount);
629     balances[_to] = balances[_to].add(_amount);
630     emit Mint(_to, _amount);
631     emit Transfer(address(0), _to, _amount);
632     return true;
633   }
634 
635   /**
636    * @dev Function to stop minting new tokens.
637    * @return True if the operation was successful.
638    */
639   function finishMinting() public onlyOwner canMint returns (bool) {
640     mintingFinished = true;
641     emit MintFinished();
642     return true;
643   }
644 }
645 
646 
647 
648 
649 /**
650  * @title MDAPPToken
651  * @dev Token for the Million Dollar Decentralized Application (MDAPP).
652  * Once a holder uses it to claim pixels the appropriate tokens are burned (1 Token <=> 10x10 pixel).
653  * If one releases his pixels new tokens are generated and credited to ones balance. Therefore, supply will
654  * vary between 0 and 10,000 tokens.
655  * Tokens are transferable once minting has finished.
656  * @dev Owned by MDAPP.sol
657  */
658 contract MDAPPToken is MintableToken {
659   using SafeMath16 for uint16;
660   using SafeMath for uint256;
661 
662   string public constant name = "MillionDollarDapp";
663   string public constant symbol = "MDAPP";
664   uint8 public constant decimals = 0;
665 
666   mapping (address => uint16) locked;
667 
668   bool public forceTransferEnable = false;
669 
670   /*********************************************************
671    *                                                       *
672    *                       Events                          *
673    *                                                       *
674    *********************************************************/
675 
676   // Emitted when owner force-allows transfers of tokens.
677   event AllowTransfer();
678 
679   /*********************************************************
680    *                                                       *
681    *                      Modifiers                        *
682    *                                                       *
683    *********************************************************/
684 
685   modifier hasLocked(address _account, uint16 _value) {
686     require(_value <= locked[_account], "Not enough locked tokens available.");
687     _;
688   }
689 
690   modifier hasUnlocked(address _account, uint16 _value) {
691     require(balanceOf(_account).sub(uint256(locked[_account])) >= _value, "Not enough unlocked tokens available.");
692     _;
693   }
694 
695   /**
696    * @dev Checks whether it can transfer or otherwise throws.
697    */
698   modifier canTransfer(address _sender, uint256 _value) {
699     require(_value <= transferableTokensOf(_sender), "Not enough unlocked tokens available.");
700     _;
701   }
702 
703 
704   /*********************************************************
705    *                                                       *
706    *                Limited Transfer Logic                 *
707    *            Taken from openzeppelin 1.3.0              *
708    *                                                       *
709    *********************************************************/
710 
711   function lockToken(address _account, uint16 _value) onlyOwner hasUnlocked(_account, _value) public {
712     locked[_account] = locked[_account].add(_value);
713   }
714 
715   function unlockToken(address _account, uint16 _value) onlyOwner hasLocked(_account, _value) public {
716     locked[_account] = locked[_account].sub(_value);
717   }
718 
719   /**
720    * @dev Checks modifier and allows transfer if tokens are not locked.
721    * @param _to The address that will receive the tokens.
722    * @param _value The amount of tokens to be transferred.
723    */
724   function transfer(address _to, uint256 _value) canTransfer(msg.sender, _value) public returns (bool) {
725     return super.transfer(_to, _value);
726   }
727 
728   /**
729   * @dev Checks modifier and allows transfer if tokens are not locked.
730   * @param _from The address that will send the tokens.
731   * @param _to The address that will receive the tokens.
732   * @param _value The amount of tokens to be transferred.
733   */
734   function transferFrom(address _from, address _to, uint256 _value) canTransfer(_from, _value) public returns (bool) {
735     return super.transferFrom(_from, _to, _value);
736   }
737 
738   /**
739    * @dev Allow the holder to transfer his tokens only if every token in
740    * existence has already been distributed / minting is finished.
741    * Tokens which are locked for a claimed space cannot be transferred.
742    */
743   function transferableTokensOf(address _holder) public view returns (uint16) {
744     if (!mintingFinished && !forceTransferEnable) return 0;
745 
746     return uint16(balanceOf(_holder)).sub(locked[_holder]);
747   }
748 
749   /**
750    * @dev Get the number of pixel-locked tokens.
751    */
752   function lockedTokensOf(address _holder) public view returns (uint16) {
753     return locked[_holder];
754   }
755 
756   /**
757    * @dev Get the number of unlocked tokens usable for claiming pixels.
758    */
759   function unlockedTokensOf(address _holder) public view returns (uint256) {
760     return balanceOf(_holder).sub(uint256(locked[_holder]));
761   }
762 
763   // Allow transfer of tokens even if minting is not yet finished.
764   function allowTransfer() onlyOwner public {
765     require(forceTransferEnable == false, 'Transfer already force-allowed.');
766 
767     forceTransferEnable = true;
768     emit AllowTransfer();
769   }
770 }
771 
772 
773 
774 
775 /**
776  * @title MDAPP
777  */
778 contract MDAPP is Ownable, HasNoEther, CanReclaimToken {
779   using SafeMath for uint256;
780   using SafeMath16 for uint16;
781 
782   // The tokens contract.
783   MDAPPToken public token;
784 
785   // The sales contracts address. Only it is allowed to to call the public mint function.
786   address public sale;
787 
788   // When are presale participants allowed to place ads?
789   uint256 public presaleAdStart;
790 
791   // When are all token owners allowed to place ads?
792   uint256 public allAdStart;
793 
794   // Quantity of tokens bought during presale.
795   mapping (address => uint16) presales;
796 
797   // Indicates whether a 10x10px block is claimed or not.
798   bool[80][125] grid;
799 
800   // Struct that represents an ad.
801   struct Ad {
802     address owner;
803     Rect rect;
804   }
805 
806   // Struct describing an rectangle area.
807   struct Rect {
808     uint16 x;
809     uint16 y;
810     uint16 width;
811     uint16 height;
812   }
813 
814   // Don't store ad details on blockchain. Use events as storage as they are significantly cheaper.
815   // ads are stored in an array, the id of an ad is its index in this array.
816   Ad[] ads;
817 
818   // The following holds a list of currently active ads (without holes between the indexes)
819   uint256[] adIds;
820 
821   // Holds the mapping from adID to its index in the above adIds array. If an ad gets released, we know which index to
822   // delete and being filled with the last element instead.
823   mapping (uint256 => uint256) adIdToIndex;
824 
825 
826   /*********************************************************
827    *                                                       *
828    *                       Events                          *
829    *                                                       *
830    *********************************************************/
831 
832   /*
833    * Event for claiming pixel blocks.
834    * @param id ID of the new ad
835    * @param owner Who owns the used tokens
836    * @param x Upper left corner x coordinate
837    * @param y Upper left corner y coordinate
838    * @param width Width of the claimed area
839    * @param height Height of the claimed area
840    */
841   event Claim(uint256 indexed id, address indexed owner, uint16 x, uint16 y, uint16 width, uint16 height);
842 
843   /*
844    * Event for releasing pixel blocks.
845    * @param id ID the fading ad
846    * @param owner Who owns the claimed blocks
847    */
848   event Release(uint256 indexed id, address indexed owner);
849 
850   /*
851    * Event for editing an ad.
852    * @param id ID of the ad
853    * @param owner Who owns the ad
854    * @param link A link
855    * @param title Title of the ad
856    * @param text Description of the ad
857    * @param NSFW Whether the ad is safe for work
858    * @param digest IPFS hash digest
859    * @param hashFunction IPFS hash function
860    * @param size IPFS length of digest
861    * @param storageEngine e.g. ipfs or swrm (swarm)
862    */
863   event EditAd(uint256 indexed id, address indexed owner, string link, string title, string text, string contact, bool NSFW, bytes32 indexed digest, bytes2 hashFunction, uint8 size, bytes4 storageEngine);
864 
865   event ForceNSFW(uint256 indexed id);
866 
867 
868   /*********************************************************
869    *                                                       *
870    *                      Modifiers                        *
871    *                                                       *
872    *********************************************************/
873 
874   modifier coordsValid(uint16 _x, uint16 _y, uint16 _width, uint16 _height) {
875     require((_x + _width - 1) < 125, "Invalid coordinates.");
876     require((_y + _height - 1) < 80, "Invalid coordinates.");
877 
878     _;
879   }
880 
881   modifier onlyAdOwner(uint256 _id) {
882     require(ads[_id].owner == msg.sender, "Access denied.");
883 
884     _;
885   }
886 
887   modifier enoughTokens(uint16 _width, uint16 _height) {
888     require(uint16(token.unlockedTokensOf(msg.sender)) >= _width.mul(_height), "Not enough unlocked tokens available.");
889 
890     _;
891   }
892 
893   modifier claimAllowed(uint16 _width, uint16 _height) {
894     require(_width > 0 &&_width <= 125 && _height > 0 && _height <= 80, "Invalid dimensions.");
895     require(now >= presaleAdStart, "Claim period not yet started.");
896 
897     if (now < allAdStart) {
898       // Sender needs enough presale tokens to claim at this point.
899       uint16 tokens = _width.mul(_height);
900       require(presales[msg.sender] >= tokens, "Not enough unlocked presale tokens available.");
901 
902       presales[msg.sender] = presales[msg.sender].sub(tokens);
903     }
904 
905     _;
906   }
907 
908   modifier onlySale() {
909     require(msg.sender == sale);
910     _;
911   }
912 
913   modifier adExists(uint256 _id) {
914     uint256 index = adIdToIndex[_id];
915     require(adIds[index] == _id, "Ad does not exist.");
916 
917     _;
918   }
919 
920   /*********************************************************
921    *                                                       *
922    *                   Initialization                      *
923    *                                                       *
924    *********************************************************/
925 
926   constructor(uint256 _presaleAdStart, uint256 _allAdStart, address _token) public {
927     require(_presaleAdStart >= now);
928     require(_allAdStart > _presaleAdStart);
929 
930     presaleAdStart = _presaleAdStart;
931     allAdStart = _allAdStart;
932     token = MDAPPToken(_token);
933   }
934 
935   function setMDAPPSale(address _mdappSale) onlyOwner external {
936     require(sale == address(0));
937     sale = _mdappSale;
938   }
939 
940   /*********************************************************
941    *                                                       *
942    *                       Logic                           *
943    *                                                       *
944    *********************************************************/
945 
946   // Proxy function to pass minting from sale contract to token contract.
947   function mint(address _beneficiary, uint256 _tokenAmount, bool isPresale) onlySale external {
948     if (isPresale) {
949       presales[_beneficiary] = presales[_beneficiary].add(uint16(_tokenAmount));
950     }
951     token.mint(_beneficiary, _tokenAmount);
952   }
953 
954   // Proxy function to pass finishMinting() from sale contract to token contract.
955   function finishMinting() onlySale external {
956     token.finishMinting();
957   }
958 
959 
960   // Public function proxy to forward single parameters as a struct.
961   function claim(uint16 _x, uint16 _y, uint16 _width, uint16 _height)
962     claimAllowed(_width, _height)
963     coordsValid(_x, _y, _width, _height)
964     external returns (uint)
965   {
966     Rect memory rect = Rect(_x, _y, _width, _height);
967     return claimShortParams(rect);
968   }
969 
970   // Claims pixels and requires to have the sender enough unlocked tokens.
971   // Has a modifier to take some of the "stack burden" from the proxy function.
972   function claimShortParams(Rect _rect)
973     enoughTokens(_rect.width, _rect.height)
974     internal returns (uint id)
975   {
976     token.lockToken(msg.sender, _rect.width.mul(_rect.height));
977 
978     // Check affected pixelblocks.
979     for (uint16 i = 0; i < _rect.width; i++) {
980       for (uint16 j = 0; j < _rect.height; j++) {
981         uint16 x = _rect.x.add(i);
982         uint16 y = _rect.y.add(j);
983 
984         if (grid[x][y]) {
985           revert("Already claimed.");
986         }
987 
988         // Mark block as claimed.
989         grid[x][y] = true;
990       }
991     }
992 
993     // Create placeholder ad.
994     id = createPlaceholderAd(_rect);
995 
996     emit Claim(id, msg.sender, _rect.x, _rect.y, _rect.width, _rect.height);
997     return id;
998   }
999 
1000   // Delete an ad, unclaim pixelblocks and unlock tokens.
1001   function release(uint256 _id) adExists(_id) onlyAdOwner(_id) external {
1002     uint16 tokens = ads[_id].rect.width.mul(ads[_id].rect.height);
1003 
1004     // Mark blocks as unclaimed.
1005     for (uint16 i = 0; i < ads[_id].rect.width; i++) {
1006       for (uint16 j = 0; j < ads[_id].rect.height; j++) {
1007         uint16 x = ads[_id].rect.x.add(i);
1008         uint16 y = ads[_id].rect.y.add(j);
1009 
1010         // Mark block as unclaimed.
1011         grid[x][y] = false;
1012       }
1013     }
1014 
1015     // Delete ad
1016     delete ads[_id];
1017     // Reorganize index array and map
1018     uint256 key = adIdToIndex[_id];
1019     // Fill gap with last element of adIds
1020     adIds[key] = adIds[adIds.length - 1];
1021     // Update adIdToIndex
1022     adIdToIndex[adIds[key]] = key;
1023     // Decrease length of adIds array by 1
1024     adIds.length--;
1025 
1026     // Unlock tokens
1027     if (now < allAdStart) {
1028       // The ad must have locked presale tokens.
1029       presales[msg.sender] = presales[msg.sender].add(tokens);
1030     }
1031     token.unlockToken(msg.sender, tokens);
1032 
1033     emit Release(_id, msg.sender);
1034   }
1035 
1036   // The image must be an URL either of bzz, ipfs or http(s).
1037   function editAd(uint _id, string _link, string _title, string _text, string _contact, bool _NSFW, bytes32 _digest, bytes2 _hashFunction, uint8 _size, bytes4 _storageEnginge) adExists(_id) onlyAdOwner(_id) public {
1038     emit EditAd(_id, msg.sender, _link, _title, _text, _contact, _NSFW, _digest, _hashFunction, _size,  _storageEnginge);
1039   }
1040 
1041   // Allows contract owner to set the NSFW flag for a given ad.
1042   function forceNSFW(uint256 _id) onlyOwner adExists(_id) external {
1043     emit ForceNSFW(_id);
1044   }
1045 
1046   // Helper function for claim() to avoid a deep stack.
1047   function createPlaceholderAd(Rect _rect) internal returns (uint id) {
1048     Ad memory ad = Ad(msg.sender, _rect);
1049     id = ads.push(ad) - 1;
1050     uint256 key = adIds.push(id) - 1;
1051     adIdToIndex[id] = key;
1052     return id;
1053   }
1054 
1055   // Returns remaining balance of tokens purchased during presale period qualifying for earlier claims.
1056   function presaleBalanceOf(address _holder) public view returns (uint16) {
1057     return presales[_holder];
1058   }
1059 
1060   // Returns all currently active adIds.
1061   function getAdIds() external view returns (uint256[]) {
1062     return adIds;
1063   }
1064 
1065   /*********************************************************
1066    *                                                       *
1067    *                       Other                           *
1068    *                                                       *
1069    *********************************************************/
1070 
1071   // Allow transfer of tokens even if minting is not yet finished.
1072   function allowTransfer() onlyOwner external {
1073     token.allowTransfer();
1074   }
1075 }
1076 
1077 
1078 // <ORACLIZE_API>
1079 /*
1080 Copyright (c) 2015-2016 Oraclize SRL
1081 Copyright (c) 2016 Oraclize LTD
1082 
1083 
1084 
1085 Permission is hereby granted, free of charge, to any person obtaining a copy
1086 of this software and associated documentation files (the "Software"), to deal
1087 in the Software without restriction, including without limitation the rights
1088 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
1089 copies of the Software, and to permit persons to whom the Software is
1090 furnished to do so, subject to the following conditions:
1091 
1092 
1093 
1094 The above copyright notice and this permission notice shall be included in
1095 all copies or substantial portions of the Software.
1096 
1097 
1098 
1099 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
1100 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
1101 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
1102 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
1103 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
1104 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
1105 THE SOFTWARE.
1106 */
1107 
1108 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
1109 
1110 
1111 contract OraclizeI {
1112     address public cbAddress;
1113     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
1114     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
1115     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
1116     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
1117     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
1118     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
1119     function getPrice(string _datasource) public returns (uint _dsprice);
1120     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
1121     function setProofType(byte _proofType) external;
1122     function setCustomGasPrice(uint _gasPrice) external;
1123     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
1124 }
1125 contract OraclizeAddrResolverI {
1126     function getAddress() public returns (address _addr);
1127 }
1128 contract usingOraclize {
1129     uint constant day = 60*60*24;
1130     uint constant week = 60*60*24*7;
1131     uint constant month = 60*60*24*30;
1132     byte constant proofType_NONE = 0x00;
1133     byte constant proofType_TLSNotary = 0x10;
1134     byte constant proofType_Android = 0x20;
1135     byte constant proofType_Ledger = 0x30;
1136     byte constant proofType_Native = 0xF0;
1137     byte constant proofStorage_IPFS = 0x01;
1138     uint8 constant networkID_auto = 0;
1139     uint8 constant networkID_mainnet = 1;
1140     uint8 constant networkID_testnet = 2;
1141     uint8 constant networkID_morden = 2;
1142     uint8 constant networkID_consensys = 161;
1143 
1144     OraclizeAddrResolverI OAR;
1145 
1146     OraclizeI oraclize;
1147     modifier oraclizeAPI {
1148         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
1149             oraclize_setNetwork(networkID_auto);
1150 
1151         if(address(oraclize) != OAR.getAddress())
1152             oraclize = OraclizeI(OAR.getAddress());
1153 
1154         _;
1155     }
1156     modifier coupon(string code){
1157         oraclize = OraclizeI(OAR.getAddress());
1158         _;
1159     }
1160 
1161     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
1162       return oraclize_setNetwork();
1163       networkID; // silence the warning and remain backwards compatible
1164     }
1165     function oraclize_setNetwork() internal returns(bool){
1166         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
1167             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
1168             oraclize_setNetworkName("eth_mainnet");
1169             return true;
1170         }
1171         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
1172             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
1173             oraclize_setNetworkName("eth_ropsten3");
1174             return true;
1175         }
1176         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
1177             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
1178             oraclize_setNetworkName("eth_kovan");
1179             return true;
1180         }
1181         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
1182             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
1183             oraclize_setNetworkName("eth_rinkeby");
1184             return true;
1185         }
1186         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
1187             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
1188             return true;
1189         }
1190         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
1191             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
1192             return true;
1193         }
1194         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
1195             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
1196             return true;
1197         }
1198         return false;
1199     }
1200 
1201     function __callback(bytes32 myid, string result) public {
1202         __callback(myid, result, new bytes(0));
1203     }
1204     function __callback(bytes32 myid, string result, bytes proof) public {
1205       return;
1206       myid; result; proof; // Silence compiler warnings
1207     }
1208 
1209     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
1210         return oraclize.getPrice(datasource);
1211     }
1212 
1213     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
1214         return oraclize.getPrice(datasource, gaslimit);
1215     }
1216 
1217     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
1218         uint price = oraclize.getPrice(datasource);
1219         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1220         return oraclize.query.value(price)(0, datasource, arg);
1221     }
1222     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
1223         uint price = oraclize.getPrice(datasource);
1224         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1225         return oraclize.query.value(price)(timestamp, datasource, arg);
1226     }
1227     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1228         uint price = oraclize.getPrice(datasource, gaslimit);
1229         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1230         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
1231     }
1232     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1233         uint price = oraclize.getPrice(datasource, gaslimit);
1234         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1235         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
1236     }
1237     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
1238         uint price = oraclize.getPrice(datasource);
1239         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1240         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
1241     }
1242     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
1243         uint price = oraclize.getPrice(datasource);
1244         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1245         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
1246     }
1247     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1248         uint price = oraclize.getPrice(datasource, gaslimit);
1249         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1250         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
1251     }
1252     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1253         uint price = oraclize.getPrice(datasource, gaslimit);
1254         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1255         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
1256     }
1257     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
1258         uint price = oraclize.getPrice(datasource);
1259         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1260         bytes memory args = stra2cbor(argN);
1261         return oraclize.queryN.value(price)(0, datasource, args);
1262     }
1263     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
1264         uint price = oraclize.getPrice(datasource);
1265         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1266         bytes memory args = stra2cbor(argN);
1267         return oraclize.queryN.value(price)(timestamp, datasource, args);
1268     }
1269     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1270         uint price = oraclize.getPrice(datasource, gaslimit);
1271         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1272         bytes memory args = stra2cbor(argN);
1273         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
1274     }
1275     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1276         uint price = oraclize.getPrice(datasource, gaslimit);
1277         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1278         bytes memory args = stra2cbor(argN);
1279         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
1280     }
1281     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
1282         string[] memory dynargs = new string[](1);
1283         dynargs[0] = args[0];
1284         return oraclize_query(datasource, dynargs);
1285     }
1286     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
1287         string[] memory dynargs = new string[](1);
1288         dynargs[0] = args[0];
1289         return oraclize_query(timestamp, datasource, dynargs);
1290     }
1291     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1292         string[] memory dynargs = new string[](1);
1293         dynargs[0] = args[0];
1294         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1295     }
1296     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1297         string[] memory dynargs = new string[](1);
1298         dynargs[0] = args[0];
1299         return oraclize_query(datasource, dynargs, gaslimit);
1300     }
1301 
1302     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
1303         string[] memory dynargs = new string[](2);
1304         dynargs[0] = args[0];
1305         dynargs[1] = args[1];
1306         return oraclize_query(datasource, dynargs);
1307     }
1308     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
1309         string[] memory dynargs = new string[](2);
1310         dynargs[0] = args[0];
1311         dynargs[1] = args[1];
1312         return oraclize_query(timestamp, datasource, dynargs);
1313     }
1314     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1315         string[] memory dynargs = new string[](2);
1316         dynargs[0] = args[0];
1317         dynargs[1] = args[1];
1318         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1319     }
1320     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1321         string[] memory dynargs = new string[](2);
1322         dynargs[0] = args[0];
1323         dynargs[1] = args[1];
1324         return oraclize_query(datasource, dynargs, gaslimit);
1325     }
1326     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
1327         string[] memory dynargs = new string[](3);
1328         dynargs[0] = args[0];
1329         dynargs[1] = args[1];
1330         dynargs[2] = args[2];
1331         return oraclize_query(datasource, dynargs);
1332     }
1333     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
1334         string[] memory dynargs = new string[](3);
1335         dynargs[0] = args[0];
1336         dynargs[1] = args[1];
1337         dynargs[2] = args[2];
1338         return oraclize_query(timestamp, datasource, dynargs);
1339     }
1340     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1341         string[] memory dynargs = new string[](3);
1342         dynargs[0] = args[0];
1343         dynargs[1] = args[1];
1344         dynargs[2] = args[2];
1345         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1346     }
1347     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1348         string[] memory dynargs = new string[](3);
1349         dynargs[0] = args[0];
1350         dynargs[1] = args[1];
1351         dynargs[2] = args[2];
1352         return oraclize_query(datasource, dynargs, gaslimit);
1353     }
1354 
1355     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
1356         string[] memory dynargs = new string[](4);
1357         dynargs[0] = args[0];
1358         dynargs[1] = args[1];
1359         dynargs[2] = args[2];
1360         dynargs[3] = args[3];
1361         return oraclize_query(datasource, dynargs);
1362     }
1363     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
1364         string[] memory dynargs = new string[](4);
1365         dynargs[0] = args[0];
1366         dynargs[1] = args[1];
1367         dynargs[2] = args[2];
1368         dynargs[3] = args[3];
1369         return oraclize_query(timestamp, datasource, dynargs);
1370     }
1371     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1372         string[] memory dynargs = new string[](4);
1373         dynargs[0] = args[0];
1374         dynargs[1] = args[1];
1375         dynargs[2] = args[2];
1376         dynargs[3] = args[3];
1377         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1378     }
1379     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1380         string[] memory dynargs = new string[](4);
1381         dynargs[0] = args[0];
1382         dynargs[1] = args[1];
1383         dynargs[2] = args[2];
1384         dynargs[3] = args[3];
1385         return oraclize_query(datasource, dynargs, gaslimit);
1386     }
1387     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
1388         string[] memory dynargs = new string[](5);
1389         dynargs[0] = args[0];
1390         dynargs[1] = args[1];
1391         dynargs[2] = args[2];
1392         dynargs[3] = args[3];
1393         dynargs[4] = args[4];
1394         return oraclize_query(datasource, dynargs);
1395     }
1396     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
1397         string[] memory dynargs = new string[](5);
1398         dynargs[0] = args[0];
1399         dynargs[1] = args[1];
1400         dynargs[2] = args[2];
1401         dynargs[3] = args[3];
1402         dynargs[4] = args[4];
1403         return oraclize_query(timestamp, datasource, dynargs);
1404     }
1405     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1406         string[] memory dynargs = new string[](5);
1407         dynargs[0] = args[0];
1408         dynargs[1] = args[1];
1409         dynargs[2] = args[2];
1410         dynargs[3] = args[3];
1411         dynargs[4] = args[4];
1412         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1413     }
1414     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1415         string[] memory dynargs = new string[](5);
1416         dynargs[0] = args[0];
1417         dynargs[1] = args[1];
1418         dynargs[2] = args[2];
1419         dynargs[3] = args[3];
1420         dynargs[4] = args[4];
1421         return oraclize_query(datasource, dynargs, gaslimit);
1422     }
1423     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
1424         uint price = oraclize.getPrice(datasource);
1425         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1426         bytes memory args = ba2cbor(argN);
1427         return oraclize.queryN.value(price)(0, datasource, args);
1428     }
1429     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
1430         uint price = oraclize.getPrice(datasource);
1431         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1432         bytes memory args = ba2cbor(argN);
1433         return oraclize.queryN.value(price)(timestamp, datasource, args);
1434     }
1435     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1436         uint price = oraclize.getPrice(datasource, gaslimit);
1437         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1438         bytes memory args = ba2cbor(argN);
1439         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
1440     }
1441     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1442         uint price = oraclize.getPrice(datasource, gaslimit);
1443         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1444         bytes memory args = ba2cbor(argN);
1445         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
1446     }
1447     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
1448         bytes[] memory dynargs = new bytes[](1);
1449         dynargs[0] = args[0];
1450         return oraclize_query(datasource, dynargs);
1451     }
1452     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
1453         bytes[] memory dynargs = new bytes[](1);
1454         dynargs[0] = args[0];
1455         return oraclize_query(timestamp, datasource, dynargs);
1456     }
1457     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1458         bytes[] memory dynargs = new bytes[](1);
1459         dynargs[0] = args[0];
1460         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1461     }
1462     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1463         bytes[] memory dynargs = new bytes[](1);
1464         dynargs[0] = args[0];
1465         return oraclize_query(datasource, dynargs, gaslimit);
1466     }
1467 
1468     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
1469         bytes[] memory dynargs = new bytes[](2);
1470         dynargs[0] = args[0];
1471         dynargs[1] = args[1];
1472         return oraclize_query(datasource, dynargs);
1473     }
1474     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
1475         bytes[] memory dynargs = new bytes[](2);
1476         dynargs[0] = args[0];
1477         dynargs[1] = args[1];
1478         return oraclize_query(timestamp, datasource, dynargs);
1479     }
1480     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1481         bytes[] memory dynargs = new bytes[](2);
1482         dynargs[0] = args[0];
1483         dynargs[1] = args[1];
1484         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1485     }
1486     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1487         bytes[] memory dynargs = new bytes[](2);
1488         dynargs[0] = args[0];
1489         dynargs[1] = args[1];
1490         return oraclize_query(datasource, dynargs, gaslimit);
1491     }
1492     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
1493         bytes[] memory dynargs = new bytes[](3);
1494         dynargs[0] = args[0];
1495         dynargs[1] = args[1];
1496         dynargs[2] = args[2];
1497         return oraclize_query(datasource, dynargs);
1498     }
1499     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
1500         bytes[] memory dynargs = new bytes[](3);
1501         dynargs[0] = args[0];
1502         dynargs[1] = args[1];
1503         dynargs[2] = args[2];
1504         return oraclize_query(timestamp, datasource, dynargs);
1505     }
1506     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1507         bytes[] memory dynargs = new bytes[](3);
1508         dynargs[0] = args[0];
1509         dynargs[1] = args[1];
1510         dynargs[2] = args[2];
1511         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1512     }
1513     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1514         bytes[] memory dynargs = new bytes[](3);
1515         dynargs[0] = args[0];
1516         dynargs[1] = args[1];
1517         dynargs[2] = args[2];
1518         return oraclize_query(datasource, dynargs, gaslimit);
1519     }
1520 
1521     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
1522         bytes[] memory dynargs = new bytes[](4);
1523         dynargs[0] = args[0];
1524         dynargs[1] = args[1];
1525         dynargs[2] = args[2];
1526         dynargs[3] = args[3];
1527         return oraclize_query(datasource, dynargs);
1528     }
1529     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
1530         bytes[] memory dynargs = new bytes[](4);
1531         dynargs[0] = args[0];
1532         dynargs[1] = args[1];
1533         dynargs[2] = args[2];
1534         dynargs[3] = args[3];
1535         return oraclize_query(timestamp, datasource, dynargs);
1536     }
1537     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1538         bytes[] memory dynargs = new bytes[](4);
1539         dynargs[0] = args[0];
1540         dynargs[1] = args[1];
1541         dynargs[2] = args[2];
1542         dynargs[3] = args[3];
1543         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1544     }
1545     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1546         bytes[] memory dynargs = new bytes[](4);
1547         dynargs[0] = args[0];
1548         dynargs[1] = args[1];
1549         dynargs[2] = args[2];
1550         dynargs[3] = args[3];
1551         return oraclize_query(datasource, dynargs, gaslimit);
1552     }
1553     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
1554         bytes[] memory dynargs = new bytes[](5);
1555         dynargs[0] = args[0];
1556         dynargs[1] = args[1];
1557         dynargs[2] = args[2];
1558         dynargs[3] = args[3];
1559         dynargs[4] = args[4];
1560         return oraclize_query(datasource, dynargs);
1561     }
1562     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
1563         bytes[] memory dynargs = new bytes[](5);
1564         dynargs[0] = args[0];
1565         dynargs[1] = args[1];
1566         dynargs[2] = args[2];
1567         dynargs[3] = args[3];
1568         dynargs[4] = args[4];
1569         return oraclize_query(timestamp, datasource, dynargs);
1570     }
1571     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1572         bytes[] memory dynargs = new bytes[](5);
1573         dynargs[0] = args[0];
1574         dynargs[1] = args[1];
1575         dynargs[2] = args[2];
1576         dynargs[3] = args[3];
1577         dynargs[4] = args[4];
1578         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1579     }
1580     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1581         bytes[] memory dynargs = new bytes[](5);
1582         dynargs[0] = args[0];
1583         dynargs[1] = args[1];
1584         dynargs[2] = args[2];
1585         dynargs[3] = args[3];
1586         dynargs[4] = args[4];
1587         return oraclize_query(datasource, dynargs, gaslimit);
1588     }
1589 
1590     function oraclize_cbAddress() oraclizeAPI internal returns (address){
1591         return oraclize.cbAddress();
1592     }
1593     function oraclize_setProof(byte proofP) oraclizeAPI internal {
1594         return oraclize.setProofType(proofP);
1595     }
1596     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
1597         return oraclize.setCustomGasPrice(gasPrice);
1598     }
1599 
1600     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
1601         return oraclize.randomDS_getSessionPubKeyHash();
1602     }
1603 
1604     function getCodeSize(address _addr) constant internal returns(uint _size) {
1605         assembly {
1606             _size := extcodesize(_addr)
1607         }
1608     }
1609 
1610     function parseAddr(string _a) internal pure returns (address){
1611         bytes memory tmp = bytes(_a);
1612         uint160 iaddr = 0;
1613         uint160 b1;
1614         uint160 b2;
1615         for (uint i=2; i<2+2*20; i+=2){
1616             iaddr *= 256;
1617             b1 = uint160(tmp[i]);
1618             b2 = uint160(tmp[i+1]);
1619             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
1620             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
1621             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
1622             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
1623             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
1624             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
1625             iaddr += (b1*16+b2);
1626         }
1627         return address(iaddr);
1628     }
1629 
1630     function strCompare(string _a, string _b) internal pure returns (int) {
1631         bytes memory a = bytes(_a);
1632         bytes memory b = bytes(_b);
1633         uint minLength = a.length;
1634         if (b.length < minLength) minLength = b.length;
1635         for (uint i = 0; i < minLength; i ++)
1636             if (a[i] < b[i])
1637                 return -1;
1638             else if (a[i] > b[i])
1639                 return 1;
1640         if (a.length < b.length)
1641             return -1;
1642         else if (a.length > b.length)
1643             return 1;
1644         else
1645             return 0;
1646     }
1647 
1648     function indexOf(string _haystack, string _needle) internal pure returns (int) {
1649         bytes memory h = bytes(_haystack);
1650         bytes memory n = bytes(_needle);
1651         if(h.length < 1 || n.length < 1 || (n.length > h.length))
1652             return -1;
1653         else if(h.length > (2**128 -1))
1654             return -1;
1655         else
1656         {
1657             uint subindex = 0;
1658             for (uint i = 0; i < h.length; i ++)
1659             {
1660                 if (h[i] == n[0])
1661                 {
1662                     subindex = 1;
1663                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
1664                     {
1665                         subindex++;
1666                     }
1667                     if(subindex == n.length)
1668                         return int(i);
1669                 }
1670             }
1671             return -1;
1672         }
1673     }
1674 
1675     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
1676         bytes memory _ba = bytes(_a);
1677         bytes memory _bb = bytes(_b);
1678         bytes memory _bc = bytes(_c);
1679         bytes memory _bd = bytes(_d);
1680         bytes memory _be = bytes(_e);
1681         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1682         bytes memory babcde = bytes(abcde);
1683         uint k = 0;
1684         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1685         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1686         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1687         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1688         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1689         return string(babcde);
1690     }
1691 
1692     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
1693         return strConcat(_a, _b, _c, _d, "");
1694     }
1695 
1696     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
1697         return strConcat(_a, _b, _c, "", "");
1698     }
1699 
1700     function strConcat(string _a, string _b) internal pure returns (string) {
1701         return strConcat(_a, _b, "", "", "");
1702     }
1703 
1704     // parseInt
1705     function parseInt(string _a) internal pure returns (uint) {
1706         return parseInt(_a, 0);
1707     }
1708 
1709     // parseInt(parseFloat*10^_b)
1710     function parseInt(string _a, uint _b) internal pure returns (uint) {
1711         bytes memory bresult = bytes(_a);
1712         uint mint = 0;
1713         bool decimals = false;
1714         for (uint i=0; i<bresult.length; i++){
1715             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
1716                 if (decimals){
1717                    if (_b == 0) break;
1718                     else _b--;
1719                 }
1720                 mint *= 10;
1721                 mint += uint(bresult[i]) - 48;
1722             } else if (bresult[i] == 46) decimals = true;
1723         }
1724         if (_b > 0) mint *= 10**_b;
1725         return mint;
1726     }
1727 
1728     function uint2str(uint i) internal pure returns (string){
1729         if (i == 0) return "0";
1730         uint j = i;
1731         uint len;
1732         while (j != 0){
1733             len++;
1734             j /= 10;
1735         }
1736         bytes memory bstr = new bytes(len);
1737         uint k = len - 1;
1738         while (i != 0){
1739             bstr[k--] = byte(48 + i % 10);
1740             i /= 10;
1741         }
1742         return string(bstr);
1743     }
1744 
1745     function stra2cbor(string[] arr) internal pure returns (bytes) {
1746             uint arrlen = arr.length;
1747 
1748             // get correct cbor output length
1749             uint outputlen = 0;
1750             bytes[] memory elemArray = new bytes[](arrlen);
1751             for (uint i = 0; i < arrlen; i++) {
1752                 elemArray[i] = (bytes(arr[i]));
1753                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
1754             }
1755             uint ctr = 0;
1756             uint cborlen = arrlen + 0x80;
1757             outputlen += byte(cborlen).length;
1758             bytes memory res = new bytes(outputlen);
1759 
1760             while (byte(cborlen).length > ctr) {
1761                 res[ctr] = byte(cborlen)[ctr];
1762                 ctr++;
1763             }
1764             for (i = 0; i < arrlen; i++) {
1765                 res[ctr] = 0x5F;
1766                 ctr++;
1767                 for (uint x = 0; x < elemArray[i].length; x++) {
1768                     // if there's a bug with larger strings, this may be the culprit
1769                     if (x % 23 == 0) {
1770                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
1771                         elemcborlen += 0x40;
1772                         uint lctr = ctr;
1773                         while (byte(elemcborlen).length > ctr - lctr) {
1774                             res[ctr] = byte(elemcborlen)[ctr - lctr];
1775                             ctr++;
1776                         }
1777                     }
1778                     res[ctr] = elemArray[i][x];
1779                     ctr++;
1780                 }
1781                 res[ctr] = 0xFF;
1782                 ctr++;
1783             }
1784             return res;
1785         }
1786 
1787     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
1788             uint arrlen = arr.length;
1789 
1790             // get correct cbor output length
1791             uint outputlen = 0;
1792             bytes[] memory elemArray = new bytes[](arrlen);
1793             for (uint i = 0; i < arrlen; i++) {
1794                 elemArray[i] = (bytes(arr[i]));
1795                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
1796             }
1797             uint ctr = 0;
1798             uint cborlen = arrlen + 0x80;
1799             outputlen += byte(cborlen).length;
1800             bytes memory res = new bytes(outputlen);
1801 
1802             while (byte(cborlen).length > ctr) {
1803                 res[ctr] = byte(cborlen)[ctr];
1804                 ctr++;
1805             }
1806             for (i = 0; i < arrlen; i++) {
1807                 res[ctr] = 0x5F;
1808                 ctr++;
1809                 for (uint x = 0; x < elemArray[i].length; x++) {
1810                     // if there's a bug with larger strings, this may be the culprit
1811                     if (x % 23 == 0) {
1812                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
1813                         elemcborlen += 0x40;
1814                         uint lctr = ctr;
1815                         while (byte(elemcborlen).length > ctr - lctr) {
1816                             res[ctr] = byte(elemcborlen)[ctr - lctr];
1817                             ctr++;
1818                         }
1819                     }
1820                     res[ctr] = elemArray[i][x];
1821                     ctr++;
1822                 }
1823                 res[ctr] = 0xFF;
1824                 ctr++;
1825             }
1826             return res;
1827         }
1828 
1829 
1830     string oraclize_network_name;
1831     function oraclize_setNetworkName(string _network_name) internal {
1832         oraclize_network_name = _network_name;
1833     }
1834 
1835     function oraclize_getNetworkName() internal view returns (string) {
1836         return oraclize_network_name;
1837     }
1838 
1839     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
1840         require((_nbytes > 0) && (_nbytes <= 32));
1841         // Convert from seconds to ledger timer ticks
1842         _delay *= 10; 
1843         bytes memory nbytes = new bytes(1);
1844         nbytes[0] = byte(_nbytes);
1845         bytes memory unonce = new bytes(32);
1846         bytes memory sessionKeyHash = new bytes(32);
1847         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1848         assembly {
1849             mstore(unonce, 0x20)
1850             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1851             mstore(sessionKeyHash, 0x20)
1852             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1853         }
1854         bytes memory delay = new bytes(32);
1855         assembly { 
1856             mstore(add(delay, 0x20), _delay) 
1857         }
1858         
1859         bytes memory delay_bytes8 = new bytes(8);
1860         copyBytes(delay, 24, 8, delay_bytes8, 0);
1861 
1862         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1863         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1864         
1865         bytes memory delay_bytes8_left = new bytes(8);
1866         
1867         assembly {
1868             let x := mload(add(delay_bytes8, 0x20))
1869             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1870             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1871             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1872             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1873             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1874             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1875             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1876             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1877 
1878         }
1879         
1880         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
1881         return queryId;
1882     }
1883     
1884     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1885         oraclize_randomDS_args[queryId] = commitment;
1886     }
1887 
1888     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1889     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1890 
1891     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1892         bool sigok;
1893         address signer;
1894 
1895         bytes32 sigr;
1896         bytes32 sigs;
1897 
1898         bytes memory sigr_ = new bytes(32);
1899         uint offset = 4+(uint(dersig[3]) - 0x20);
1900         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1901         bytes memory sigs_ = new bytes(32);
1902         offset += 32 + 2;
1903         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1904 
1905         assembly {
1906             sigr := mload(add(sigr_, 32))
1907             sigs := mload(add(sigs_, 32))
1908         }
1909 
1910 
1911         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1912         if (address(keccak256(pubkey)) == signer) return true;
1913         else {
1914             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1915             return (address(keccak256(pubkey)) == signer);
1916         }
1917     }
1918 
1919     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1920         bool sigok;
1921 
1922         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1923         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1924         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1925 
1926         bytes memory appkey1_pubkey = new bytes(64);
1927         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1928 
1929         bytes memory tosign2 = new bytes(1+65+32);
1930         tosign2[0] = byte(1); //role
1931         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1932         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1933         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1934         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1935 
1936         if (sigok == false) return false;
1937 
1938 
1939         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1940         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1941 
1942         bytes memory tosign3 = new bytes(1+65);
1943         tosign3[0] = 0xFE;
1944         copyBytes(proof, 3, 65, tosign3, 1);
1945 
1946         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1947         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1948 
1949         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1950 
1951         return sigok;
1952     }
1953 
1954     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1955         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1956         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1957 
1958         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1959         require(proofVerified);
1960 
1961         _;
1962     }
1963 
1964     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1965         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1966         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1967 
1968         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1969         if (proofVerified == false) return 2;
1970 
1971         return 0;
1972     }
1973 
1974     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1975         bool match_ = true;
1976         
1977         require(prefix.length == n_random_bytes);
1978 
1979         for (uint256 i=0; i< n_random_bytes; i++) {
1980             if (content[i] != prefix[i]) match_ = false;
1981         }
1982 
1983         return match_;
1984     }
1985 
1986     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1987 
1988         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1989         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1990         bytes memory keyhash = new bytes(32);
1991         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1992         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1993 
1994         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1995         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1996 
1997         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1998         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1999 
2000         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
2001         // This is to verify that the computed args match with the ones specified in the query.
2002         bytes memory commitmentSlice1 = new bytes(8+1+32);
2003         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
2004 
2005         bytes memory sessionPubkey = new bytes(64);
2006         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
2007         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
2008 
2009         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
2010         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
2011             delete oraclize_randomDS_args[queryId];
2012         } else return false;
2013 
2014 
2015         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
2016         bytes memory tosign1 = new bytes(32+8+1+32);
2017         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
2018         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
2019 
2020         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
2021         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
2022             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
2023         }
2024 
2025         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
2026     }
2027 
2028     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
2029     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
2030         uint minLength = length + toOffset;
2031 
2032         // Buffer too small
2033         require(to.length >= minLength); // Should be a better way?
2034 
2035         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
2036         uint i = 32 + fromOffset;
2037         uint j = 32 + toOffset;
2038 
2039         while (i < (32 + fromOffset + length)) {
2040             assembly {
2041                 let tmp := mload(add(from, i))
2042                 mstore(add(to, j), tmp)
2043             }
2044             i += 32;
2045             j += 32;
2046         }
2047 
2048         return to;
2049     }
2050 
2051     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
2052     // Duplicate Solidity's ecrecover, but catching the CALL return value
2053     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
2054         // We do our own memory management here. Solidity uses memory offset
2055         // 0x40 to store the current end of memory. We write past it (as
2056         // writes are memory extensions), but don't update the offset so
2057         // Solidity will reuse it. The memory used here is only needed for
2058         // this context.
2059 
2060         // FIXME: inline assembly can't access return values
2061         bool ret;
2062         address addr;
2063 
2064         assembly {
2065             let size := mload(0x40)
2066             mstore(size, hash)
2067             mstore(add(size, 32), v)
2068             mstore(add(size, 64), r)
2069             mstore(add(size, 96), s)
2070 
2071             // NOTE: we can reuse the request memory because we deal with
2072             //       the return code
2073             ret := call(3000, 1, 0, size, 128, size, 32)
2074             addr := mload(size)
2075         }
2076 
2077         return (ret, addr);
2078     }
2079 
2080     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
2081     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
2082         bytes32 r;
2083         bytes32 s;
2084         uint8 v;
2085 
2086         if (sig.length != 65)
2087           return (false, 0);
2088 
2089         // The signature format is a compact form of:
2090         //   {bytes32 r}{bytes32 s}{uint8 v}
2091         // Compact means, uint8 is not padded to 32 bytes.
2092         assembly {
2093             r := mload(add(sig, 32))
2094             s := mload(add(sig, 64))
2095 
2096             // Here we are loading the last 32 bytes. We exploit the fact that
2097             // 'mload' will pad with zeroes if we overread.
2098             // There is no 'mload8' to do this, but that would be nicer.
2099             v := byte(0, mload(add(sig, 96)))
2100 
2101             // Alternative solution:
2102             // 'byte' is not working due to the Solidity parser, so lets
2103             // use the second best option, 'and'
2104             // v := and(mload(add(sig, 65)), 255)
2105         }
2106 
2107         // albeit non-transactional signatures are not specified by the YP, one would expect it
2108         // to match the YP range of [27, 28]
2109         //
2110         // geth uses [0, 1] and some clients have followed. This might change, see:
2111         //  https://github.com/ethereum/go-ethereum/issues/2053
2112         if (v < 27)
2113           v += 27;
2114 
2115         if (v != 27 && v != 28)
2116             return (false, 0);
2117 
2118         return safer_ecrecover(hash, v, r, s);
2119     }
2120 
2121 }
2122 // </ORACLIZE_API>
2123 
2124 
2125 
2126 
2127 /*
2128  * @title MDAPPSale
2129  * @dev MDAPPSale is a base contract for managing the token sale.
2130  * MDAPPSale has got a start timestamp, from where buyers can make
2131  * token purchases and the contract will assign them tokens based
2132  * on a ETH per token rate. Funds collected are forwarded to a wallet
2133  * as they arrive.
2134  */
2135 contract MDAPPSale is Ownable, PullPayment, usingOraclize {
2136 //contract MDAPPSale is Ownable, PullPayment {
2137   using SafeMath for uint256;
2138   using SafeMath16 for uint16;
2139 
2140   // The MDAPP core contract
2141   MDAPP public mdapp;
2142 
2143   // Start timestamp for presale (inclusive)
2144   uint256 public startTimePresale;
2145 
2146   // End timestamp for presale
2147   uint256 public endTimePresale;
2148 
2149   // Start timestamp sale
2150   uint256 public startTimeSale;
2151 
2152   // Address where funds are collected
2153   address public wallet;
2154 
2155   // Amount of raised money in wei. Only for stats. Don't use for calculations.
2156   uint256 public weiRaised;
2157 
2158   // Sold out / sale active?
2159   bool public soldOut = false;
2160 
2161   // Max supply
2162   uint16 public constant maxSupply = 10000;
2163 
2164   // Initial supply
2165   uint16 public supply = 0;
2166 
2167   // Oracle active?
2168   bool public oracleActive = false;
2169 
2170   // Delay between autonomous oraclize requests
2171   uint256 public oracleInterval;
2172 
2173   // Gas price for oraclize callback transaction
2174   uint256 public oracleGasPrice = 7000000000;
2175 
2176   // Gas limit for oraclize callback transaction
2177   // Unused gas is returned to oraclize.
2178   uint256 public oracleGasLimit = 105000;
2179 
2180   // When was the ethusd rate updated the last time?
2181   uint256 public oracleLastUpdate = 1;
2182 
2183   // Alternative: json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0
2184   string public oracleQueryString = 'json(https://api.gdax.com/products/ETH-USD/ticker).price';
2185 
2186   // USD Cent value of 1 ether
2187   uint256 public ethusd;
2188   uint256 ethusdLast;
2189 
2190 
2191   /*********************************************************
2192    *                                                       *
2193    *                       Events                          *
2194    *                                                       *
2195    *********************************************************/
2196 
2197   /*
2198    * Event for token purchase logging.
2199    * @param purchaser who paid for the tokens
2200    * @param beneficiary who got the tokens
2201    * @param value weis paid for purchase
2202    * @param tokens amount of tokens purchased
2203    */
2204   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint16 tokens);
2205 
2206   event Recruited(address indexed purchaser, address indexed beneficiary, address indexed recruiter, uint256 value, uint256 share, uint16 tokens);
2207 
2208   // Received ETH via fallback function
2209   event Receive(address sender, uint256 value);
2210 
2211   event BountyGranted(address indexed beneficiary, uint16 tokens, string reason);
2212 
2213   event LogPriceUpdated(uint256 price);
2214   event OracleFundsWithdraw(uint256 value);
2215   event OracleGasPriceChange(uint256 value);
2216   event OracleGasLimitChange(uint256 value);
2217   event OracleIntervalChange(uint256 value);
2218   event OracleQueryStringChange(string value);
2219   event ETHUSDSet(uint256 value);
2220 
2221   /*********************************************************
2222    *                                                       *
2223    *                  Initial deployment                   *
2224    *                                                       *
2225    *********************************************************/
2226 
2227 
2228   constructor(uint256 _startTimePre, uint256 _endTimePre, uint256 _startTimeSale, address _wallet, uint256 _ethusd, uint _oracleInterval, address _mdapp) public {
2229     require(_startTimePre >= now);
2230     require(_endTimePre > _startTimePre);
2231     require(_startTimeSale >= _endTimePre);
2232     require(_wallet != 0x0);
2233     require(_ethusd > 0);
2234     require(_mdapp != 0x0);
2235 
2236     ethusd = _ethusd;
2237     ethusdLast = ethusd;
2238     oracleInterval = _oracleInterval;
2239     startTimePresale = _startTimePre;
2240     endTimePresale = _endTimePre;
2241     startTimeSale = _startTimeSale;
2242     wallet = _wallet;
2243     mdapp = MDAPP(_mdapp);
2244 
2245     oraclize_setCustomGasPrice(oracleGasPrice);
2246   }
2247 
2248   /*********************************************************
2249    *                                                       *
2250    *         Price calculation and oracle handling         *
2251    *                                                       *
2252    *********************************************************/
2253 
2254   /**
2255    * @dev Request ETHUSD rate from oraclize
2256    * @param _delay in seconds when the request should be scheduled from now on
2257    */
2258   function requestEthUsd(uint _delay) internal {              // Internal call:
2259     if (oracleActive && !soldOut) {
2260       if (oraclize_getPrice("URL") > address(this).balance) {
2261         oracleActive = false;
2262       } else {
2263         if (_delay == 0) {
2264           oraclize_query("URL", oracleQueryString, oracleGasLimit);
2265         } else {
2266           oraclize_query(_delay, "URL", oracleQueryString, oracleGasLimit);
2267         }
2268       }
2269     }
2270   }
2271 
2272   /**
2273    * @dev Called by oraclize.
2274    */
2275   function __callback(bytes32 myid, string result) public {
2276     if (msg.sender != oraclize_cbAddress()) revert();
2277     ethusdLast = ethusd;
2278     ethusd = parseInt(result, 2);
2279     oracleLastUpdate = now;
2280     emit LogPriceUpdated(ethusd);
2281     requestEthUsd(oracleInterval);
2282   }
2283 
2284   // Activate ethusd oracle
2285   function activateOracle() onlyOwner external payable {
2286     oracleActive = true;
2287     requestEthUsd(0);
2288   }
2289 
2290   function setOracleGasPrice(uint256 _gasPrice) onlyOwner external {
2291     require(_gasPrice > 0, "Gas price must be a positive number.");
2292     oraclize_setCustomGasPrice(_gasPrice);
2293     oracleGasPrice = _gasPrice;
2294     emit OracleGasPriceChange(_gasPrice);
2295   }
2296 
2297   function setOracleGasLimit(uint256 _gasLimit) onlyOwner external {
2298     require(_gasLimit > 0, "Gas limit must be a positive number.");
2299     oracleGasLimit = _gasLimit;
2300     emit OracleGasLimitChange(_gasLimit);
2301   }
2302 
2303   function setOracleInterval(uint256 _interval) onlyOwner external {
2304     require(_interval > 0, "Interval must be > 0");
2305     oracleInterval = _interval;
2306     emit OracleIntervalChange(_interval);
2307   }
2308 
2309   function setOracleQueryString(string _queryString) onlyOwner external {
2310     oracleQueryString = _queryString;
2311     emit OracleQueryStringChange(_queryString);
2312   }
2313 
2314   /**
2315    * Only needed to be independent from Oraclize - just for the worst case they stop their service.
2316    */
2317   function setEthUsd(uint256 _ethusd) onlyOwner external {
2318     require(_ethusd > 0, "ETHUSD must be > 0");
2319     ethusd = _ethusd;
2320     emit ETHUSDSet(_ethusd);
2321   }
2322 
2323   /**
2324    * @dev Withdraw remaining oracle funds.
2325    */
2326   function withdrawOracleFunds() onlyOwner external {
2327     oracleActive = false;
2328     emit OracleFundsWithdraw(address(this).balance);
2329     owner.transfer(address(this).balance);
2330   }
2331 
2332   /*********************************************************
2333    *                                                       *
2334    *              Token and pixel purchase                 *
2335    *                                                       *
2336    *********************************************************/
2337 
2338 
2339   // Primary token purchase function.
2340   function buyTokens(address _beneficiary, uint16 _tokenAmount, address _recruiter) external payable {
2341     require(_beneficiary != address(0), "Invalid beneficiary.");
2342     require(_tokenAmount > 0, "Token amount bust be a positive integer.");
2343     require(validPurchase(), "Either no active sale or zero ETH sent.");
2344     require(_recruiter != _beneficiary && _recruiter != msg.sender, "Recruiter must not be purchaser or beneficiary.");
2345     assert(ethusd > 0);
2346 
2347     // Each pixel costs $1 and 1 token represents 10x10 pixel => x100. ETHUSD comes in Cent => x100 once more
2348     // 10**18 * 10**2 * 10**2 = 10**22
2349     uint256 rate = uint256(10 ** 22).div(ethusd);
2350     // Calculate how much the tokens cost.
2351     // Overpayed purchases don't receive a return.
2352     uint256 cost = uint256(_tokenAmount).mul(rate);
2353 
2354     // Accept previous exchange rate if it changed within the last 2 minutes to improve UX during high network load.
2355     if (cost > msg.value) {
2356       if (now - oracleLastUpdate <= 120) {
2357         assert(ethusdLast > 0);
2358         rate = uint256(10 ** 22).div(ethusdLast);
2359         cost = uint256(_tokenAmount).mul(rate);
2360       }
2361     }
2362 
2363     require(msg.value >= cost, "Not enough ETH sent.");
2364 
2365     // Update supply.
2366     supply += _tokenAmount;
2367     require(supply <= maxSupply, "Not enough tokens available.");
2368 
2369     if (_recruiter == address(0)) {
2370       weiRaised = weiRaised.add(msg.value);
2371       asyncTransfer(wallet, msg.value);
2372     } else {
2373       // Purchaser has been recruited. Grant the recruiter 10%.
2374       uint256 tenPercent = msg.value.div(10);
2375       uint256 ninetyPercent = msg.value.sub(tenPercent);
2376       weiRaised = weiRaised.add(ninetyPercent);
2377       asyncTransfer(wallet, ninetyPercent);
2378       asyncTransfer(_recruiter, tenPercent);
2379       emit Recruited(msg.sender, _beneficiary, _recruiter, msg.value, tenPercent, _tokenAmount);
2380     }
2381 
2382     // Mint tokens.
2383     bool isPresale = endTimePresale >= now ? true : false;
2384     mdapp.mint(_beneficiary, _tokenAmount, isPresale);
2385     emit TokenPurchase(msg.sender, _beneficiary, msg.value, _tokenAmount);
2386 
2387     // Stop minting once we reach max supply.
2388     if (supply == maxSupply) {
2389       soldOut = true;
2390       mdapp.finishMinting();
2391     }
2392   }
2393 
2394   function grantBounty(address _beneficiary, uint16 _tokenAmount, string _reason) onlyOwner external {
2395     require(_beneficiary != address(0), "Invalid beneficiary.");
2396     require(_tokenAmount > 0, "Token amount bust be a positive integer.");
2397 
2398     // Update supply.
2399     supply += _tokenAmount;
2400     require(supply <= maxSupply, "Not enough tokens available.");
2401 
2402     // Mint tokens.
2403     bool isPresale = endTimePresale >= now ? true : false;
2404     mdapp.mint(_beneficiary, _tokenAmount, isPresale);
2405 
2406     // Stop minting once we reach max supply.
2407     if (supply == maxSupply) {
2408       soldOut = true;
2409       mdapp.finishMinting();
2410     }
2411 
2412     emit BountyGranted(_beneficiary, _tokenAmount, _reason);
2413   }
2414 
2415   // Fallback function. Load contract with ETH to use oraclize.
2416   function() public payable {
2417     emit Receive(msg.sender, msg.value);
2418   }
2419 
2420   /*********************************************************
2421    *                                                       *
2422    *                       Helpers                         *
2423    *                                                       *
2424    *********************************************************/
2425 
2426   // @return true if the transaction can buy tokens
2427   function validPurchase() internal view returns (bool) {
2428     bool withinPeriod = (now >= startTimeSale) || ((now >= startTimePresale) && (now < endTimePresale));
2429     bool nonZeroPurchase = msg.value > 0;
2430     return withinPeriod && nonZeroPurchase && !soldOut;
2431   }
2432 }