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
70 
71 
72 /**
73  * @title ERC20 interface
74  * @dev see https://github.com/ethereum/EIPs/issues/20
75  */
76 contract ERC20 is ERC20Basic {
77   function allowance(address _owner, address _spender)
78     public view returns (uint256);
79 
80   function transferFrom(address _from, address _to, uint256 _value)
81     public returns (bool);
82 
83   function approve(address _spender, uint256 _value) public returns (bool);
84   event Approval(
85     address indexed owner,
86     address indexed spender,
87     uint256 value
88   );
89 }
90 
91 
92 
93 
94 
95 
96 
97 /**
98  * @title Basic token
99  * @dev Basic version of StandardToken, with no allowances.
100  */
101 contract BasicToken is ERC20Basic {
102   using SafeMath for uint256;
103 
104   mapping(address => uint256) internal balances;
105 
106   uint256 internal totalSupply_;
107 
108   /**
109   * @dev Total number of tokens in existence
110   */
111   function totalSupply() public view returns (uint256) {
112     return totalSupply_;
113   }
114 
115   /**
116   * @dev Transfer token for a specified address
117   * @param _to The address to transfer to.
118   * @param _value The amount to be transferred.
119   */
120   function transfer(address _to, uint256 _value) public returns (bool) {
121     require(_value <= balances[msg.sender]);
122     require(_to != address(0));
123 
124     balances[msg.sender] = balances[msg.sender].sub(_value);
125     balances[_to] = balances[_to].add(_value);
126     emit Transfer(msg.sender, _to, _value);
127     return true;
128   }
129 
130   /**
131   * @dev Gets the balance of the specified address.
132   * @param _owner The address to query the the balance of.
133   * @return An uint256 representing the amount owned by the passed address.
134   */
135   function balanceOf(address _owner) public view returns (uint256) {
136     return balances[_owner];
137   }
138 
139 }
140 
141 
142 
143 
144 
145 
146 /**
147  * @title Standard ERC20 token
148  *
149  * @dev Implementation of the basic standard token.
150  * https://github.com/ethereum/EIPs/issues/20
151  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
152  */
153 contract StandardToken is ERC20, BasicToken {
154 
155   mapping (address => mapping (address => uint256)) internal allowed;
156 
157 
158   /**
159    * @dev Transfer tokens from one address to another
160    * @param _from address The address which you want to send tokens from
161    * @param _to address The address which you want to transfer to
162    * @param _value uint256 the amount of tokens to be transferred
163    */
164   function transferFrom(
165     address _from,
166     address _to,
167     uint256 _value
168   )
169     public
170     returns (bool)
171   {
172     require(_value <= balances[_from]);
173     require(_value <= allowed[_from][msg.sender]);
174     require(_to != address(0));
175 
176     balances[_from] = balances[_from].sub(_value);
177     balances[_to] = balances[_to].add(_value);
178     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
179     emit Transfer(_from, _to, _value);
180     return true;
181   }
182 
183   /**
184    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
185    * Beware that changing an allowance with this method brings the risk that someone may use both the old
186    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
187    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
188    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
189    * @param _spender The address which will spend the funds.
190    * @param _value The amount of tokens to be spent.
191    */
192   function approve(address _spender, uint256 _value) public returns (bool) {
193     allowed[msg.sender][_spender] = _value;
194     emit Approval(msg.sender, _spender, _value);
195     return true;
196   }
197 
198   /**
199    * @dev Function to check the amount of tokens that an owner allowed to a spender.
200    * @param _owner address The address which owns the funds.
201    * @param _spender address The address which will spend the funds.
202    * @return A uint256 specifying the amount of tokens still available for the spender.
203    */
204   function allowance(
205     address _owner,
206     address _spender
207    )
208     public
209     view
210     returns (uint256)
211   {
212     return allowed[_owner][_spender];
213   }
214 
215   /**
216    * @dev Increase the amount of tokens that an owner allowed to a spender.
217    * approve should be called when allowed[_spender] == 0. To increment
218    * allowed value is better to use this function to avoid 2 calls (and wait until
219    * the first transaction is mined)
220    * From MonolithDAO Token.sol
221    * @param _spender The address which will spend the funds.
222    * @param _addedValue The amount of tokens to increase the allowance by.
223    */
224   function increaseApproval(
225     address _spender,
226     uint256 _addedValue
227   )
228     public
229     returns (bool)
230   {
231     allowed[msg.sender][_spender] = (
232       allowed[msg.sender][_spender].add(_addedValue));
233     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
234     return true;
235   }
236 
237   /**
238    * @dev Decrease the amount of tokens that an owner allowed to a spender.
239    * approve should be called when allowed[_spender] == 0. To decrement
240    * allowed value is better to use this function to avoid 2 calls (and wait until
241    * the first transaction is mined)
242    * From MonolithDAO Token.sol
243    * @param _spender The address which will spend the funds.
244    * @param _subtractedValue The amount of tokens to decrease the allowance by.
245    */
246   function decreaseApproval(
247     address _spender,
248     uint256 _subtractedValue
249   )
250     public
251     returns (bool)
252   {
253     uint256 oldValue = allowed[msg.sender][_spender];
254     if (_subtractedValue >= oldValue) {
255       allowed[msg.sender][_spender] = 0;
256     } else {
257       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
258     }
259     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
260     return true;
261   }
262 
263 }
264 
265 
266 
267 /**
268  * @title Ownable
269  * @dev The Ownable contract has an owner address, and provides basic authorization control
270  * functions, this simplifies the implementation of "user permissions".
271  */
272 contract Ownable {
273   address public owner;
274 
275 
276   event OwnershipRenounced(address indexed previousOwner);
277   event OwnershipTransferred(
278     address indexed previousOwner,
279     address indexed newOwner
280   );
281 
282 
283   /**
284    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
285    * account.
286    */
287   constructor() public {
288     owner = msg.sender;
289   }
290 
291   /**
292    * @dev Throws if called by any account other than the owner.
293    */
294   modifier onlyOwner() {
295     require(msg.sender == owner);
296     _;
297   }
298 
299   /**
300    * @dev Allows the current owner to relinquish control of the contract.
301    * @notice Renouncing to ownership will leave the contract without an owner.
302    * It will not be possible to call the functions with the `onlyOwner`
303    * modifier anymore.
304    */
305   function renounceOwnership() public onlyOwner {
306     emit OwnershipRenounced(owner);
307     owner = address(0);
308   }
309 
310   /**
311    * @dev Allows the current owner to transfer control of the contract to a newOwner.
312    * @param _newOwner The address to transfer ownership to.
313    */
314   function transferOwnership(address _newOwner) public onlyOwner {
315     _transferOwnership(_newOwner);
316   }
317 
318   /**
319    * @dev Transfers control of the contract to a newOwner.
320    * @param _newOwner The address to transfer ownership to.
321    */
322   function _transferOwnership(address _newOwner) internal {
323     require(_newOwner != address(0));
324     emit OwnershipTransferred(owner, _newOwner);
325     owner = _newOwner;
326   }
327 }
328 
329 
330 
331 
332 
333 
334 /**
335  * @title SafeERC20
336  * @dev Wrappers around ERC20 operations that throw on failure.
337  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
338  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
339  */
340 library SafeERC20 {
341   function safeTransfer(
342     ERC20Basic _token,
343     address _to,
344     uint256 _value
345   )
346     internal
347   {
348     require(_token.transfer(_to, _value));
349   }
350 
351   function safeTransferFrom(
352     ERC20 _token,
353     address _from,
354     address _to,
355     uint256 _value
356   )
357     internal
358   {
359     require(_token.transferFrom(_from, _to, _value));
360   }
361 
362   function safeApprove(
363     ERC20 _token,
364     address _spender,
365     uint256 _value
366   )
367     internal
368   {
369     require(_token.approve(_spender, _value));
370   }
371 }
372 
373 
374 
375 
376 
377 
378 contract IToken is ERC20 {
379     // note: we use external visibility for all non-standard functions 
380     // (which are not used internally) 
381 
382     function reclaimToken(ERC20Basic _token, address _to) external;
383 
384     function setMaxTransferGasPrice(uint newGasPrice) external;
385 
386     // TAP whitelisting functions
387     function whitelist(address TAP) external;
388     function deWhitelist(address TAP) external;
389 
390     function setTransferFeeNumerator(uint newTransferFeeNumerator) external;
391 
392     // transfer blacklist functions
393     function blacklist(address a) external;
394     function deBlacklist(address a) external;
395 
396     // seizing function
397     function seize(address a) external;
398 
399     // rebalance functions
400     function rebalance(bool deducts, uint tokensAmount) external;
401 
402     // transfer fee functions
403     function disableFee(address a) external;
404     function enableFee(address a) external;
405     function computeFee(uint amount) public view returns(uint);
406 
407     // to disable
408     function renounceOwnership() public;
409 
410     // mintable
411     event Mint(address indexed to, uint amount);
412     function mint(address _to, uint _amount) public returns(bool);
413     // to disable
414     function finishMinting() public returns (bool);
415 
416     // burnable
417     event Burn(address indexed burner, uint value);
418     // burn is only available through the transfer function
419     function burn(uint _value) public;
420 
421     // pausable
422     function pause() public;
423     function unpause() public;
424 
425     // ownable
426     function transferOwnership(address newOwner) public;
427     function transferSuperownership(address newOwner) external; // external for consistency reasons
428 
429     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool);
430     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool);
431 }
432 
433 
434 
435 
436 
437 
438 
439 /**
440  * @title Burnable Token
441  * @dev Token that can be irreversibly burned (destroyed).
442  */
443 contract BurnableToken is BasicToken {
444 
445   event Burn(address indexed burner, uint256 value);
446 
447   /**
448    * @dev Burns a specific amount of tokens.
449    * @param _value The amount of token to be burned.
450    */
451   function burn(uint256 _value) public {
452     _burn(msg.sender, _value);
453   }
454 
455   function _burn(address _who, uint256 _value) internal {
456     require(_value <= balances[_who]);
457     // no need to require value <= totalSupply, since that would imply the
458     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
459 
460     balances[_who] = balances[_who].sub(_value);
461     totalSupply_ = totalSupply_.sub(_value);
462     emit Burn(_who, _value);
463     emit Transfer(_who, address(0), _value);
464   }
465 }
466 
467 
468 
469 
470 
471 
472 /**
473  * @title DetailedERC20 token
474  * @dev The decimals are only for visualization purposes.
475  * All the operations are done using the smallest and indivisible token unit,
476  * just as on Ethereum all the operations are done in wei.
477  */
478 contract DetailedERC20 is ERC20 {
479   string public name;
480   string public symbol;
481   uint8 public decimals;
482 
483   constructor(string _name, string _symbol, uint8 _decimals) public {
484     name = _name;
485     symbol = _symbol;
486     decimals = _decimals;
487   }
488 }
489 
490 
491 
492 
493 
494 
495 
496 
497 /**
498  * @title Mintable token
499  * @dev Simple ERC20 Token example, with mintable token creation
500  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
501  */
502 contract MintableToken is StandardToken, Ownable {
503   event Mint(address indexed to, uint256 amount);
504   event MintFinished();
505 
506   bool public mintingFinished = false;
507 
508 
509   modifier canMint() {
510     require(!mintingFinished);
511     _;
512   }
513 
514   modifier hasMintPermission() {
515     require(msg.sender == owner);
516     _;
517   }
518 
519   /**
520    * @dev Function to mint tokens
521    * @param _to The address that will receive the minted tokens.
522    * @param _amount The amount of tokens to mint.
523    * @return A boolean that indicates if the operation was successful.
524    */
525   function mint(
526     address _to,
527     uint256 _amount
528   )
529     public
530     hasMintPermission
531     canMint
532     returns (bool)
533   {
534     totalSupply_ = totalSupply_.add(_amount);
535     balances[_to] = balances[_to].add(_amount);
536     emit Mint(_to, _amount);
537     emit Transfer(address(0), _to, _amount);
538     return true;
539   }
540 
541   /**
542    * @dev Function to stop minting new tokens.
543    * @return True if the operation was successful.
544    */
545   function finishMinting() public onlyOwner canMint returns (bool) {
546     mintingFinished = true;
547     emit MintFinished();
548     return true;
549   }
550 }
551 
552 
553 
554 
555 
556 
557 
558 
559 
560 
561 /**
562  * @title Pausable
563  * @dev Base contract which allows children to implement an emergency stop mechanism.
564  */
565 contract Pausable is Ownable {
566   event Pause();
567   event Unpause();
568 
569   bool public paused = false;
570 
571 
572   /**
573    * @dev Modifier to make a function callable only when the contract is not paused.
574    */
575   modifier whenNotPaused() {
576     require(!paused);
577     _;
578   }
579 
580   /**
581    * @dev Modifier to make a function callable only when the contract is paused.
582    */
583   modifier whenPaused() {
584     require(paused);
585     _;
586   }
587 
588   /**
589    * @dev called by the owner to pause, triggers stopped state
590    */
591   function pause() public onlyOwner whenNotPaused {
592     paused = true;
593     emit Pause();
594   }
595 
596   /**
597    * @dev called by the owner to unpause, returns to normal state
598    */
599   function unpause() public onlyOwner whenPaused {
600     paused = false;
601     emit Unpause();
602   }
603 }
604 
605 
606 
607 /**
608  * @title Pausable token
609  * @dev StandardToken modified with pausable transfers.
610  **/
611 contract PausableToken is StandardToken, Pausable {
612 
613   function transfer(
614     address _to,
615     uint256 _value
616   )
617     public
618     whenNotPaused
619     returns (bool)
620   {
621     return super.transfer(_to, _value);
622   }
623 
624   function transferFrom(
625     address _from,
626     address _to,
627     uint256 _value
628   )
629     public
630     whenNotPaused
631     returns (bool)
632   {
633     return super.transferFrom(_from, _to, _value);
634   }
635 
636   function approve(
637     address _spender,
638     uint256 _value
639   )
640     public
641     whenNotPaused
642     returns (bool)
643   {
644     return super.approve(_spender, _value);
645   }
646 
647   function increaseApproval(
648     address _spender,
649     uint _addedValue
650   )
651     public
652     whenNotPaused
653     returns (bool success)
654   {
655     return super.increaseApproval(_spender, _addedValue);
656   }
657 
658   function decreaseApproval(
659     address _spender,
660     uint _subtractedValue
661   )
662     public
663     whenNotPaused
664     returns (bool success)
665   {
666     return super.decreaseApproval(_spender, _subtractedValue);
667   }
668 }
669 
670 
671 
672 contract Token is IToken, PausableToken, BurnableToken, MintableToken, DetailedERC20 {
673     using SafeMath for uint;
674     using SafeERC20 for ERC20Basic;
675 
676     // scaling factor
677     uint public scaleFactor = 10 ** 18;
678     mapping(address => uint) internal lastScalingFactor;
679 
680     // maximum percent of scaling of balances
681     uint constant internal MAX_REBALANCE_PERCENT = 5;
682 
683     // gas price
684     // deactivate the limit at deployment: set it to the maximum integer
685     uint public maxTransferGasPrice = uint(-1);
686     event TransferGasPrice(uint oldGasPrice, uint newGasPrice);
687 
688     // transfer fee is computed as:
689     // regular transfer amount * transferFeeNumerator / TRANSFER_FEE_DENOMINATOR
690     uint public transferFeeNumerator = 0;
691     uint constant internal MAX_NUM_DISABLED_FEES = 100;
692     uint constant internal MAX_FEE_PERCENT = 5;
693     uint constant internal TRANSFER_FEE_DENOMINATOR = 10 ** 18;
694     mapping(address => bool) public avoidsFees;
695     address[] public avoidsFeesArray;
696     event TransferFeeNumerator(uint oldNumerator, uint newNumerator);
697     event TransferFeeDisabled(address indexed account);
698     event TransferFeeEnabled(address indexed account);
699     event TransferFee(
700         address indexed to,
701         AccountClassification
702         fromAccountClassification,
703         uint amount
704     );
705 
706     // whitelisted TAPs
707     mapping(address => bool) public TAPwhiteListed;
708     event TAPWhiteListed(address indexed TAP);
709     event TAPDeWhiteListed(address indexed TAP);
710 
711     // blacklisted Accounts
712     mapping(address => bool) public transferBlacklisted;
713     event TransferBlacklisted(address indexed account);
714     event TransferDeBlacklisted(address indexed account);
715 
716     // seized funds
717     event FundsSeized(
718         address indexed account,
719         AccountClassification fromAccountClassification,
720         uint amount
721     );
722 
723     // extended transfer event
724     enum AccountClassification {Zero, Owner, Superowner, TAP, Other} // Enum
725     // block accounts with classification Other
726     bool public blockOtherAccounts;
727     event TransferExtd(
728         address indexed from,
729         AccountClassification fromAccountClassification,
730         address indexed to,
731         AccountClassification toAccountClassification,
732         uint amount
733     );
734     event BlockOtherAccounts(bool isEnabled);
735 
736     // rebalancing event
737     event Rebalance(
738         bool deducts,
739         uint amount,
740         uint oldScaleFactor,
741         uint newScaleFactor,
742         uint oldTotalSupply,
743         uint newTotalSupply
744     );
745 
746     // additional owner
747     address public superowner;
748     event SuperownershipTransferred(address indexed previousOwner,
749       address indexed newOwner);
750     mapping(address => bool) public usedOwners;
751 
752     constructor(
753       string name,
754       string symbol,
755       uint8 decimals,
756       address _superowner
757     )
758     public DetailedERC20(name, symbol, decimals)
759     {
760         require(_superowner != address(0), "superowner is not the zero address");
761         superowner = _superowner;
762         usedOwners[owner] = true;
763         usedOwners[superowner] = true;
764     }
765 
766     modifier onlyOwner() {
767         require(isOwner(msg.sender),  "sender is owner or superowner");
768         _;
769     }
770 
771     modifier hasMintPermission() {
772         require(isOwner(msg.sender),  "sender is owner or superowner");
773         _;
774     }
775 
776     modifier nonZeroAddress(address account) {
777         require(account != address(0), "account is not the zero address");
778         _;
779     }
780 
781     modifier limitGasPrice() {
782         require(tx.gasprice <= maxTransferGasPrice, "gasprice is less than its upper bound");
783         _;
784     }
785 
786     /**
787      * @dev Reclaim all ERC20Basic compatible tokens that have been sent by mistake to this
788      * contract
789      * @param _token ERC20Basic The address of the token contract
790      * @param _to The address of the recipient of the tokens
791      */
792     function reclaimToken(ERC20Basic _token, address _to) external onlyOwner {
793         uint256 balance = _token.balanceOf(address(this));
794         _token.safeTransfer(_to, balance);
795     }
796 
797     /**
798      * @notice Setter of max transfer gas price
799      * @param newGasPrice the new gas price
800      */
801     function setMaxTransferGasPrice(uint newGasPrice) external onlyOwner {
802         require(newGasPrice != 0, "gas price limit cannot be null");
803         emit TransferGasPrice(maxTransferGasPrice, newGasPrice);
804         maxTransferGasPrice = newGasPrice;
805     }
806 
807     /**
808      * @notice Whitelist an address as a TAP to which tokens can be minted
809      * @param TAP The address to whitelist
810      */
811     function whitelist(address TAP) external nonZeroAddress(TAP) onlyOwner {
812         require(!isOwner(TAP), "TAP is not owner or superowner");
813         require(!TAPwhiteListed[TAP], "TAP cannot be whitlisted");
814         emit TAPWhiteListed(TAP);
815         TAPwhiteListed[TAP] = true;
816     }
817 
818     /**
819      * @notice Dewhitelist an address as a TAP
820      * @param TAP The address to dewhitelist
821      */
822     function deWhitelist(address TAP) external nonZeroAddress(TAP) onlyOwner {
823         require(TAPwhiteListed[TAP], "TAP is whitlisted");
824         emit TAPDeWhiteListed(TAP);
825         TAPwhiteListed[TAP] = false;
826     }
827 
828     /**
829      * @notice Change the transfer fee numerator
830      * @param newTransferFeeNumerator The new transfer fee numerator
831      */
832     function setTransferFeeNumerator(uint newTransferFeeNumerator) external onlyOwner {
833         require(newTransferFeeNumerator <= TRANSFER_FEE_DENOMINATOR.mul(MAX_FEE_PERCENT).div(100),
834             "transfer fee numerator is less than its upper bound");
835         emit TransferFeeNumerator(transferFeeNumerator, newTransferFeeNumerator);
836         transferFeeNumerator = newTransferFeeNumerator;
837     }
838 
839     /**
840      * @notice Blacklist an account to prevent their transfers
841      * @dev this function can be called while the contract is paused, to prevent blacklisting and
842      * front-running (by first pausing, then blacklisting)
843      * @param account The address to blacklist
844      */
845     function blacklist(address account) external nonZeroAddress(account) onlyOwner {
846         require(!transferBlacklisted[account], "account is not blacklisted");
847         emit TransferBlacklisted(account);
848         transferBlacklisted[account] = true;
849     }
850 
851     /**
852      * @notice Deblacklist an account to allow their transfers once again
853      * @param account The address to deblacklist
854      */
855     function deBlacklist(address account) external nonZeroAddress(account) onlyOwner {
856         require(transferBlacklisted[account], "account is blacklisted");
857         emit TransferDeBlacklisted(account);
858         transferBlacklisted[account] = false;
859     }
860 
861     /**
862      * @notice Seize all funds from a blacklisted account
863      * @param account The address to be seized
864      */
865     function seize(address account) external nonZeroAddress(account) onlyOwner {
866         require(transferBlacklisted[account], "account has been blacklisted");
867         updateBalanceAndScaling(account);
868         uint balance = balanceOf(account);
869         emit FundsSeized(account, getAccountClassification(account), balance);
870         super._burn(account, balance);
871     }
872 
873     /**
874      * @notice disable future transfer fees for an account
875      * @dev The fees owed before this function are paid here, via updateBalanceAndScaling.
876      * @param account The address which will avoid future transfer fees
877      */
878     function disableFee(address account) external nonZeroAddress(account) onlyOwner {
879         require(!avoidsFees[account], "account has fees");
880         require(avoidsFeesArray.length < MAX_NUM_DISABLED_FEES, "array is not full");
881         emit TransferFeeDisabled(account);
882         avoidsFees[account] = true;
883         avoidsFeesArray.push(account);
884     }
885 
886     /**
887      * @notice enable future transfer fees for an account
888      * @param account The address which will pay future transfer fees
889      */
890     function enableFee(address account) external nonZeroAddress(account) onlyOwner {
891         require(avoidsFees[account], "account avoids fees");
892         emit TransferFeeEnabled(account);
893         avoidsFees[account] = false;
894         uint len = avoidsFeesArray.length;
895         assert(len != 0);
896         for (uint i = 0; i < len; i++) {
897             if (avoidsFeesArray[i] == account) {
898                 avoidsFeesArray[i] = avoidsFeesArray[len.sub(1)];
899                 avoidsFeesArray.length--;
900                 return;
901             }
902         }
903         assert(false);
904     }
905 
906     /**
907      * @notice rebalance changes the total supply by the given amount (either deducts or adds)
908      * by scaling all balance amounts proportionally (also those exempt from fees)
909      * @dev this uses the current total supply (which is the sum of all token balances excluding
910      * the inventory, i.e., the balances of owner and superowner) to compute the new scale factor
911      * @param deducts indication if we deduct or add token from total supply
912      * @param tokensAmount the number of tokens to add/deduct
913      */
914     function rebalance(bool deducts, uint tokensAmount) external onlyOwner {
915         uint oldTotalSupply = totalSupply();
916         uint oldScaleFactor = scaleFactor;
917 
918         require(
919             tokensAmount <= oldTotalSupply.mul(MAX_REBALANCE_PERCENT).div(100),
920             "tokensAmount is within limits"
921         );
922 
923         // new scale factor and total supply
924         uint newScaleFactor;
925         if (deducts) {
926             newScaleFactor = oldScaleFactor.mul(
927                 oldTotalSupply.sub(tokensAmount)).div(oldTotalSupply
928             );
929         } else {
930             newScaleFactor = oldScaleFactor.mul(
931                 oldTotalSupply.add(tokensAmount)).div(oldTotalSupply
932             );
933         }
934         // update scaleFactor
935         scaleFactor = newScaleFactor;
936 
937         // update total supply
938         uint newTotalSupply = oldTotalSupply.mul(scaleFactor).div(oldScaleFactor);
939         totalSupply_ = newTotalSupply;
940 
941         emit Rebalance(
942             deducts,
943             tokensAmount,
944             oldScaleFactor,
945             newScaleFactor,
946             oldTotalSupply,
947             newTotalSupply
948         );
949 
950         if (deducts) {
951             require(newTotalSupply < oldTotalSupply, "totalSupply shrinks");
952             // avoid overly large rounding errors
953             assert(oldTotalSupply.sub(tokensAmount.mul(9).div(10)) >= newTotalSupply);
954             assert(oldTotalSupply.sub(tokensAmount.mul(11).div(10)) <= newTotalSupply);
955         } else {
956            require(newTotalSupply > oldTotalSupply, "totalSupply grows");
957            // avoid overly large rounding errors
958            assert(oldTotalSupply.add(tokensAmount.mul(9).div(10)) <= newTotalSupply);
959            assert(oldTotalSupply.add(tokensAmount.mul(11).div(10)) >= newTotalSupply);
960         }
961     }
962 
963     /**
964      * @notice enable change of superowner
965      * @param _newSuperowner the address of the new owner
966      */
967     function transferSuperownership(
968         address _newSuperowner
969     )
970     external nonZeroAddress(_newSuperowner)
971     {
972         require(msg.sender == superowner, "only superowner");
973         require(!usedOwners[_newSuperowner], "owner was not used before");
974         usedOwners[_newSuperowner] = true;
975         uint value = balanceOf(superowner);
976         if (value > 0) {
977             super._burn(superowner, value);
978             emit TransferExtd(
979                 superowner,
980                 AccountClassification.Superowner,
981                 address(0),
982                 AccountClassification.Zero,
983                 value
984             );
985         }
986         emit SuperownershipTransferred(superowner, _newSuperowner);
987         superowner = _newSuperowner;
988     }
989 
990     /**
991      * @notice Compute the regular amount of tokens of an account.
992      * @dev Gets the balance of the specified address.
993      * @param account The address to query the the balance of.
994      * @return An uint256 representing the amount owned by the passed address.
995      */
996     function balanceOf(address account) public view returns (uint) {
997         uint amount = balances[account];
998         uint oldScaleFactor = lastScalingFactor[account];
999         if (oldScaleFactor == 0) {
1000             return 0;
1001         } else if (oldScaleFactor == scaleFactor) {
1002             return amount;
1003         } else {
1004             return amount.mul(scaleFactor).div(oldScaleFactor);
1005         }
1006     }
1007 
1008     /**
1009      * @notice Compute the fee corresponding to a transfer not exempt from fees.
1010      * @param amount The amount of the transfer
1011      * @return the number of tokens to be paid as a fee
1012      */
1013     function computeFee(uint amount) public view returns (uint) {
1014         return amount.mul(transferFeeNumerator).div(TRANSFER_FEE_DENOMINATOR);
1015     }
1016 
1017     /**
1018      * @notice Compute the total outstanding of tokens (excluding those held by owner
1019      * and superowner, i.e., the inventory accounts).
1020      * @dev function to get the total supply excluding inventory
1021      * @return The uint total supply excluding inventory
1022      */
1023     function totalSupply() public view returns(uint) {
1024         uint inventory = balanceOf(owner);
1025         if (owner != superowner) {
1026             inventory = inventory.add(balanceOf(superowner));
1027         }
1028         return (super.totalSupply().sub(inventory));
1029     }
1030 
1031     /**
1032      * @notice enable change of owner
1033      * @param _newOwner the address of the new owner
1034      */
1035     function transferOwnership(address _newOwner) public onlyOwner {
1036         require(!usedOwners[_newOwner], "owner was not used before");
1037         usedOwners[_newOwner] = true;
1038         uint value = balanceOf(owner);
1039         if (value > 0) {
1040             super._burn(owner, value);
1041             emit TransferExtd(
1042                 owner,
1043                 AccountClassification.Owner,
1044                 address(0),
1045                 AccountClassification.Zero,
1046                 value
1047             );
1048         }
1049         super.transferOwnership(_newOwner);
1050     }
1051 
1052     /**
1053      * @notice Wrapper around OZ's increaseApproval
1054      * @dev Update the corresponding balance and scaling before increasing approval
1055      * @param _spender The address which will spend the funds.
1056      * @param _addedValue The amount of tokens to increase the allowance by.
1057      * @return true in case of success
1058      */
1059     function increaseApproval(
1060         address _spender,
1061         uint256 _addedValue
1062     )
1063     public whenNotPaused returns (bool)
1064     {
1065         updateBalanceAndScaling(msg.sender);
1066         updateBalanceAndScaling(_spender);
1067         return super.increaseApproval(_spender, _addedValue);
1068     }
1069 
1070     /**
1071      * @notice Wrapper around OZ's decreaseApproval
1072      * @dev Update the corresponding balance and scaling before decreasing approval
1073      * @param _spender The address which will spend the funds.
1074      * @param _subtractedValue The amount of tokens to decrease the allowance by.
1075      * @return true in case of success
1076      */
1077     function decreaseApproval(
1078         address _spender,
1079         uint256 _subtractedValue
1080     )
1081     public whenNotPaused returns (bool)
1082     {
1083         updateBalanceAndScaling(msg.sender);
1084         updateBalanceAndScaling(_spender);
1085         return super.decreaseApproval(_spender, _subtractedValue);
1086     }
1087 
1088     /**
1089      * @dev Transfer token for a specified address
1090      * @param _to The address to transfer to.
1091      * @param _value The amount to be transferred, from which the transfer fee will be deducted
1092      * @return true in case of success
1093      */
1094     function transfer(
1095         address _to,
1096         uint _value
1097     )
1098     public whenNotPaused limitGasPrice returns (bool)
1099     {
1100         require(!transferBlacklisted[msg.sender], "sender is not blacklisted");
1101         require(!transferBlacklisted[_to], "to address is not blacklisted");
1102         require(!blockOtherAccounts ||
1103             (getAccountClassification(msg.sender) != AccountClassification.Other &&
1104             getAccountClassification(_to) != AccountClassification.Other),
1105             "addresses are not blocked");
1106 
1107         emit TransferExtd(
1108             msg.sender,
1109             getAccountClassification(msg.sender),
1110             _to,
1111             getAccountClassification(_to),
1112             _value
1113         );
1114 
1115         updateBalanceAndScaling(msg.sender);
1116 
1117         if (_to == address(0)) {
1118             // burn tokens
1119             super.burn(_value);
1120             return true;
1121         }
1122 
1123         updateBalanceAndScaling(_to);
1124 
1125         require(super.transfer(_to, _value), "transfer succeeds");
1126 
1127         if (!avoidsFees[msg.sender] && !avoidsFees[_to]) {
1128             computeAndBurnFee(_to, _value);
1129         }
1130 
1131         return true;
1132     }
1133 
1134     /**
1135      * @dev Transfer tokens from one address to another
1136      * @param _from address The address which you want to send tokens from
1137      * @param _to address The address which you want to transfer to
1138      * @param _value uint256 the amount of tokens to be transferred, from which the transfer fee
1139      * will be deducted
1140      * @return true in case of success
1141      */
1142     function transferFrom(
1143         address _from,
1144         address _to,
1145         uint _value
1146     )
1147     public whenNotPaused limitGasPrice returns (bool)
1148     {
1149         require(!transferBlacklisted[msg.sender], "sender is not blacklisted");
1150         require(!transferBlacklisted[_from], "from address is not blacklisted");
1151         require(!transferBlacklisted[_to], "to address is not blacklisted");
1152         require(!blockOtherAccounts ||
1153             (getAccountClassification(_from) != AccountClassification.Other &&
1154             getAccountClassification(_to) != AccountClassification.Other),
1155             "addresses are not blocked");
1156 
1157         emit TransferExtd(
1158             _from,
1159             getAccountClassification(_from),
1160             _to,
1161             getAccountClassification(_to),
1162             _value
1163         );
1164 
1165         updateBalanceAndScaling(_from);
1166 
1167         if (_to == address(0)) {
1168             // burn tokens
1169             super.transferFrom(_from, msg.sender, _value);
1170             super.burn(_value);
1171             return true;
1172         }
1173 
1174         updateBalanceAndScaling(_to);
1175 
1176         require(super.transferFrom(_from, _to, _value), "transfer succeeds");
1177 
1178         if (!avoidsFees[msg.sender] && !avoidsFees[_from] && !avoidsFees[_to]) {
1179             computeAndBurnFee(_to, _value);
1180         }
1181 
1182         return true;
1183     }
1184 
1185     /**
1186      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
1187      * msg.sender. Beware that changing an allowance with this method brings the risk that someone
1188      * may use both the old and the new allowance by unfortunate transaction ordering. One
1189      * possible solution to mitigate this race condition is to first reduce the spender's
1190      * allowance to 0 and set the desired value afterwards:
1191      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1192      * @param _spender The address which will spend the funds.
1193      * @param _value Amount of tokens to be spent, from which the transfer fee will be deducted.
1194      * @return true in case of success
1195      */
1196     function approve(address _spender, uint _value) public whenNotPaused returns (bool) {
1197         updateBalanceAndScaling(_spender);
1198         return super.approve(_spender, _value);
1199     }
1200 
1201     /**
1202      * @dev Function for TAPs to mint tokens
1203      * @param _to The address that will receive the minted tokens.
1204      * @param _amount The amount of tokens to mint.
1205      * @return true in case of success
1206      */
1207     function mint(address _to, uint _amount) public returns(bool) {
1208         require(!transferBlacklisted[_to], "to address is not blacklisted");
1209         require(!blockOtherAccounts || getAccountClassification(_to) != AccountClassification.Other,
1210             "to address is not blocked");
1211         updateBalanceAndScaling(_to);
1212         emit TransferExtd(
1213             address(0),
1214             AccountClassification.Zero,
1215             _to,
1216             getAccountClassification(_to),
1217             _amount
1218         );
1219         return super.mint(_to, _amount);
1220     }
1221 
1222     /**
1223      * @notice toggle allowOthterAccounts variable
1224      */
1225     function toggleBlockOtherAccounts() public onlyOwner {
1226         blockOtherAccounts = !blockOtherAccounts;
1227         emit BlockOtherAccounts(blockOtherAccounts);
1228     }
1229 
1230     // get AccountClassification of an account
1231     function getAccountClassification(
1232         address account
1233     )
1234     internal view returns(AccountClassification)
1235     {
1236         if (account == address(0)) {
1237             return AccountClassification.Zero;
1238         } else if (account == owner) {
1239             return AccountClassification.Owner;
1240         } else if (account == superowner) {
1241             return AccountClassification.Superowner;
1242         } else if (TAPwhiteListed[account]) {
1243             return AccountClassification.TAP;
1244         } else {
1245             return AccountClassification.Other;
1246         }
1247     }
1248 
1249     // check if account is an owner
1250     function isOwner(address account) internal view returns (bool) {
1251         return account == owner || account == superowner;
1252     }
1253 
1254     // update balance and scaleFactor
1255     function updateBalanceAndScaling(address account) internal {
1256         uint oldBalance = balances[account];
1257         uint newBalance = balanceOf(account);
1258         if (lastScalingFactor[account] != scaleFactor) {
1259             lastScalingFactor[account] = scaleFactor;
1260         }
1261         if (oldBalance != newBalance) {
1262             balances[account] = newBalance;
1263         }
1264     }
1265 
1266     // compute and burn a transfer fee
1267     function computeAndBurnFee(address _to, uint _value) internal {
1268         uint fee = computeFee(_value);
1269         if (fee > 0) {
1270             _burn(_to, fee);
1271             emit TransferFee(_to, getAccountClassification(_to), fee);
1272         }
1273     }
1274 
1275     // disabled
1276     function finishMinting() public returns (bool) {
1277         require(false, "is disabled");
1278         return false;
1279     }
1280 
1281     // disabled
1282     function burn(uint /* _value */) public {
1283         // burn is only available through the transfer function
1284         require(false, "is disabled");
1285     }
1286 
1287     // disabled
1288     function renounceOwnership() public {
1289         require(false, "is disabled");
1290     }
1291 }