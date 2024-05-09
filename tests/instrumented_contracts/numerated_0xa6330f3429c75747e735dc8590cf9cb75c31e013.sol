1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * See https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address _who) public view returns (uint256);
13   function transfer(address _to, uint256 _value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24 
25   /**
26   * @dev Multiplies two numbers, throws on overflow.
27   */
28   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
29     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
30     // benefit is lost if 'b' is also tested.
31     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
32     if (_a == 0) {
33       return 0;
34     }
35 
36     c = _a * _b;
37     assert(c / _a == _b);
38     return c;
39   }
40 
41   /**
42   * @dev Integer division of two numbers, truncating the quotient.
43   */
44   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
45     // assert(_b > 0); // Solidity automatically throws when dividing by 0
46     // uint256 c = _a / _b;
47     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
48     return _a / _b;
49   }
50 
51   /**
52   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53   */
54   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
55     assert(_b <= _a);
56     return _a - _b;
57   }
58 
59   /**
60   * @dev Adds two numbers, throws on overflow.
61   */
62   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
63     c = _a + _b;
64     assert(c >= _a);
65     return c;
66   }
67 }
68 
69 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) internal balances;
79 
80   uint256 internal totalSupply_;
81 
82   /**
83   * @dev Total number of tokens in existence
84   */
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   /**
90   * @dev Transfer token for a specified address
91   * @param _to The address to transfer to.
92   * @param _value The amount to be transferred.
93   */
94   function transfer(address _to, uint256 _value) public returns (bool) {
95     require(_value <= balances[msg.sender]);
96     require(_to != address(0));
97 
98     balances[msg.sender] = balances[msg.sender].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     emit Transfer(msg.sender, _to, _value);
101     return true;
102   }
103 
104   /**
105   * @dev Gets the balance of the specified address.
106   * @param _owner The address to query the the balance of.
107   * @return An uint256 representing the amount owned by the passed address.
108   */
109   function balanceOf(address _owner) public view returns (uint256) {
110     return balances[_owner];
111   }
112 
113 }
114 
115 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
116 
117 /**
118  * @title ERC20 interface
119  * @dev see https://github.com/ethereum/EIPs/issues/20
120  */
121 contract ERC20 is ERC20Basic {
122   function allowance(address _owner, address _spender)
123     public view returns (uint256);
124 
125   function transferFrom(address _from, address _to, uint256 _value)
126     public returns (bool);
127 
128   function approve(address _spender, uint256 _value) public returns (bool);
129   event Approval(
130     address indexed owner,
131     address indexed spender,
132     uint256 value
133   );
134 }
135 
136 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
137 
138 /**
139  * @title Standard ERC20 token
140  *
141  * @dev Implementation of the basic standard token.
142  * https://github.com/ethereum/EIPs/issues/20
143  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
144  */
145 contract StandardToken is ERC20, BasicToken {
146 
147   mapping (address => mapping (address => uint256)) internal allowed;
148 
149 
150   /**
151    * @dev Transfer tokens from one address to another
152    * @param _from address The address which you want to send tokens from
153    * @param _to address The address which you want to transfer to
154    * @param _value uint256 the amount of tokens to be transferred
155    */
156   function transferFrom(
157     address _from,
158     address _to,
159     uint256 _value
160   )
161     public
162     returns (bool)
163   {
164     require(_value <= balances[_from]);
165     require(_value <= allowed[_from][msg.sender]);
166     require(_to != address(0));
167 
168     balances[_from] = balances[_from].sub(_value);
169     balances[_to] = balances[_to].add(_value);
170     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
171     emit Transfer(_from, _to, _value);
172     return true;
173   }
174 
175   /**
176    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
177    * Beware that changing an allowance with this method brings the risk that someone may use both the old
178    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
179    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
180    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181    * @param _spender The address which will spend the funds.
182    * @param _value The amount of tokens to be spent.
183    */
184   function approve(address _spender, uint256 _value) public returns (bool) {
185     allowed[msg.sender][_spender] = _value;
186     emit Approval(msg.sender, _spender, _value);
187     return true;
188   }
189 
190   /**
191    * @dev Function to check the amount of tokens that an owner allowed to a spender.
192    * @param _owner address The address which owns the funds.
193    * @param _spender address The address which will spend the funds.
194    * @return A uint256 specifying the amount of tokens still available for the spender.
195    */
196   function allowance(
197     address _owner,
198     address _spender
199    )
200     public
201     view
202     returns (uint256)
203   {
204     return allowed[_owner][_spender];
205   }
206 
207   /**
208    * @dev Increase the amount of tokens that an owner allowed to a spender.
209    * approve should be called when allowed[_spender] == 0. To increment
210    * allowed value is better to use this function to avoid 2 calls (and wait until
211    * the first transaction is mined)
212    * From MonolithDAO Token.sol
213    * @param _spender The address which will spend the funds.
214    * @param _addedValue The amount of tokens to increase the allowance by.
215    */
216   function increaseApproval(
217     address _spender,
218     uint256 _addedValue
219   )
220     public
221     returns (bool)
222   {
223     allowed[msg.sender][_spender] = (
224       allowed[msg.sender][_spender].add(_addedValue));
225     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229   /**
230    * @dev Decrease the amount of tokens that an owner allowed to a spender.
231    * approve should be called when allowed[_spender] == 0. To decrement
232    * allowed value is better to use this function to avoid 2 calls (and wait until
233    * the first transaction is mined)
234    * From MonolithDAO Token.sol
235    * @param _spender The address which will spend the funds.
236    * @param _subtractedValue The amount of tokens to decrease the allowance by.
237    */
238   function decreaseApproval(
239     address _spender,
240     uint256 _subtractedValue
241   )
242     public
243     returns (bool)
244   {
245     uint256 oldValue = allowed[msg.sender][_spender];
246     if (_subtractedValue >= oldValue) {
247       allowed[msg.sender][_spender] = 0;
248     } else {
249       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
250     }
251     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252     return true;
253   }
254 
255 }
256 
257 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
258 
259 /**
260  * @title Ownable
261  * @dev The Ownable contract has an owner address, and provides basic authorization control
262  * functions, this simplifies the implementation of "user permissions".
263  */
264 contract Ownable {
265   address public owner;
266 
267 
268   event OwnershipRenounced(address indexed previousOwner);
269   event OwnershipTransferred(
270     address indexed previousOwner,
271     address indexed newOwner
272   );
273 
274 
275   /**
276    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
277    * account.
278    */
279   constructor() public {
280     owner = msg.sender;
281   }
282 
283   /**
284    * @dev Throws if called by any account other than the owner.
285    */
286   modifier onlyOwner() {
287     require(msg.sender == owner);
288     _;
289   }
290 
291   /**
292    * @dev Allows the current owner to relinquish control of the contract.
293    * @notice Renouncing to ownership will leave the contract without an owner.
294    * It will not be possible to call the functions with the `onlyOwner`
295    * modifier anymore.
296    */
297   function renounceOwnership() public onlyOwner {
298     emit OwnershipRenounced(owner);
299     owner = address(0);
300   }
301 
302   /**
303    * @dev Allows the current owner to transfer control of the contract to a newOwner.
304    * @param _newOwner The address to transfer ownership to.
305    */
306   function transferOwnership(address _newOwner) public onlyOwner {
307     _transferOwnership(_newOwner);
308   }
309 
310   /**
311    * @dev Transfers control of the contract to a newOwner.
312    * @param _newOwner The address to transfer ownership to.
313    */
314   function _transferOwnership(address _newOwner) internal {
315     require(_newOwner != address(0));
316     emit OwnershipTransferred(owner, _newOwner);
317     owner = _newOwner;
318   }
319 }
320 
321 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
322 
323 /**
324  * @title Mintable token
325  * @dev Simple ERC20 Token example, with mintable token creation
326  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
327  */
328 contract MintableToken is StandardToken, Ownable {
329   event Mint(address indexed to, uint256 amount);
330   event MintFinished();
331 
332   bool public mintingFinished = false;
333 
334 
335   modifier canMint() {
336     require(!mintingFinished);
337     _;
338   }
339 
340   modifier hasMintPermission() {
341     require(msg.sender == owner);
342     _;
343   }
344 
345   /**
346    * @dev Function to mint tokens
347    * @param _to The address that will receive the minted tokens.
348    * @param _amount The amount of tokens to mint.
349    * @return A boolean that indicates if the operation was successful.
350    */
351   function mint(
352     address _to,
353     uint256 _amount
354   )
355     public
356     hasMintPermission
357     canMint
358     returns (bool)
359   {
360     totalSupply_ = totalSupply_.add(_amount);
361     balances[_to] = balances[_to].add(_amount);
362     emit Mint(_to, _amount);
363     emit Transfer(address(0), _to, _amount);
364     return true;
365   }
366 
367   /**
368    * @dev Function to stop minting new tokens.
369    * @return True if the operation was successful.
370    */
371   function finishMinting() public onlyOwner canMint returns (bool) {
372     mintingFinished = true;
373     emit MintFinished();
374     return true;
375   }
376 }
377 
378 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
379 
380 /**
381  * @title Pausable
382  * @dev Base contract which allows children to implement an emergency stop mechanism.
383  */
384 contract Pausable is Ownable {
385   event Pause();
386   event Unpause();
387 
388   bool public paused = false;
389 
390 
391   /**
392    * @dev Modifier to make a function callable only when the contract is not paused.
393    */
394   modifier whenNotPaused() {
395     require(!paused);
396     _;
397   }
398 
399   /**
400    * @dev Modifier to make a function callable only when the contract is paused.
401    */
402   modifier whenPaused() {
403     require(paused);
404     _;
405   }
406 
407   /**
408    * @dev called by the owner to pause, triggers stopped state
409    */
410   function pause() public onlyOwner whenNotPaused {
411     paused = true;
412     emit Pause();
413   }
414 
415   /**
416    * @dev called by the owner to unpause, returns to normal state
417    */
418   function unpause() public onlyOwner whenPaused {
419     paused = false;
420     emit Unpause();
421   }
422 }
423 
424 // File: openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol
425 
426 /**
427  * @title Pausable token
428  * @dev StandardToken modified with pausable transfers.
429  **/
430 contract PausableToken is StandardToken, Pausable {
431 
432   function transfer(
433     address _to,
434     uint256 _value
435   )
436     public
437     whenNotPaused
438     returns (bool)
439   {
440     return super.transfer(_to, _value);
441   }
442 
443   function transferFrom(
444     address _from,
445     address _to,
446     uint256 _value
447   )
448     public
449     whenNotPaused
450     returns (bool)
451   {
452     return super.transferFrom(_from, _to, _value);
453   }
454 
455   function approve(
456     address _spender,
457     uint256 _value
458   )
459     public
460     whenNotPaused
461     returns (bool)
462   {
463     return super.approve(_spender, _value);
464   }
465 
466   function increaseApproval(
467     address _spender,
468     uint _addedValue
469   )
470     public
471     whenNotPaused
472     returns (bool success)
473   {
474     return super.increaseApproval(_spender, _addedValue);
475   }
476 
477   function decreaseApproval(
478     address _spender,
479     uint _subtractedValue
480   )
481     public
482     whenNotPaused
483     returns (bool success)
484   {
485     return super.decreaseApproval(_spender, _subtractedValue);
486   }
487 }
488 
489 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
490 
491 /**
492  * @title DetailedERC20 token
493  * @dev The decimals are only for visualization purposes.
494  * All the operations are done using the smallest and indivisible token unit,
495  * just as on Ethereum all the operations are done in wei.
496  */
497 contract DetailedERC20 is ERC20 {
498   string public name;
499   string public symbol;
500   uint8 public decimals;
501 
502   constructor(string _name, string _symbol, uint8 _decimals) public {
503     name = _name;
504     symbol = _symbol;
505     decimals = _decimals;
506   }
507 }
508 
509 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
510 
511 /**
512  * @title Burnable Token
513  * @dev Token that can be irreversibly burned (destroyed).
514  */
515 contract BurnableToken is BasicToken {
516 
517   event Burn(address indexed burner, uint256 value);
518 
519   /**
520    * @dev Burns a specific amount of tokens.
521    * @param _value The amount of token to be burned.
522    */
523   function burn(uint256 _value) public {
524     _burn(msg.sender, _value);
525   }
526 
527   function _burn(address _who, uint256 _value) internal {
528     require(_value <= balances[_who]);
529     // no need to require value <= totalSupply, since that would imply the
530     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
531 
532     balances[_who] = balances[_who].sub(_value);
533     totalSupply_ = totalSupply_.sub(_value);
534     emit Burn(_who, _value);
535     emit Transfer(_who, address(0), _value);
536   }
537 }
538 
539 // File: openzeppelin-solidity/contracts/token/ERC20/StandardBurnableToken.sol
540 
541 /**
542  * @title Standard Burnable Token
543  * @dev Adds burnFrom method to ERC20 implementations
544  */
545 contract StandardBurnableToken is BurnableToken, StandardToken {
546 
547   /**
548    * @dev Burns a specific amount of tokens from the target address and decrements allowance
549    * @param _from address The address which you want to send tokens from
550    * @param _value uint256 The amount of token to be burned
551    */
552   function burnFrom(address _from, uint256 _value) public {
553     require(_value <= allowed[_from][msg.sender]);
554     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
555     // this function needs to emit an event with the updated approval.
556     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
557     _burn(_from, _value);
558   }
559 }
560 
561 // File: contracts/RemeCoin.sol
562 
563 /**
564  * @title RemeCoin
565  * @author https://bit-sentinel.com
566  */
567 contract RemeCoin is MintableToken, PausableToken, StandardBurnableToken, DetailedERC20 {
568     event EnabledFees();
569     event DisabledFees();
570     event FeeChanged(uint256 fee);
571     event FeeThresholdChanged(uint256 feeThreshold);
572     event FeeBeneficiaryChanged(address indexed feeBeneficiary);
573     event EnabledWhitelist();
574     event DisabledWhitelist();
575     event ChangedWhitelistManager(address indexed whitelistManager);
576     event AddedRecipientToWhitelist(address indexed recipient);
577     event AddedSenderToWhitelist(address indexed sender);
578     event RemovedRecipientFromWhitelist(address indexed recipient);
579     event RemovedSenderFromWhitelist(address indexed sender);
580 
581     // If the token whitelist feature is enabled or not.
582     bool public whitelist = true;
583 
584     // Address of the whitelist manager.
585     address public whitelistManager;
586 
587     // Addresses that can receive tokens.
588     mapping(address => bool) public whitelistedRecipients;
589 
590     // Addresses that can send tokens.
591     mapping(address => bool) public whitelistedSenders;
592 
593     // Fee taken from transfers.
594     uint256 public fee;
595 
596     // If the fee mechanism is enabled.
597     bool public feesEnabled;
598 
599     // Address of the fee beneficiary.
600     address public feeBeneficiary;
601 
602     // Value from which the fee mechanism applies.
603     uint256 public feeThreshold;
604 
605     /**
606      * @dev Initialize the RemeCoin and transfer the initialBalance to the
607      *      initialAccount.
608      * @param _initialAccount The account that will receive the initial balance.
609      * @param _initialBalance The initial balance of tokens.
610      * @param _fee uint256 The fee percentage to be applied. Has 4 decimals.
611      * @param _feeBeneficiary address The beneficiary of the fees.
612      * @param _feeThreshold uint256 The amount of when the transfers fees will be applied.
613      */
614     constructor(
615         address _initialAccount,
616         uint256 _initialBalance,
617         uint256 _fee,
618         address _feeBeneficiary,
619         uint256 _feeThreshold
620     )
621         DetailedERC20("REME Coin", "REME", 18)
622         public
623     {
624         require(_fee != uint256(0) && _fee <= uint256(100 * (10 ** 4)));
625         require(_feeBeneficiary != address(0));
626         require(_feeThreshold != uint256(0));
627 
628         fee = _fee;
629         feeBeneficiary = _feeBeneficiary;
630         feeThreshold = _feeThreshold;
631 
632         totalSupply_ = _initialBalance;
633         balances[_initialAccount] = _initialBalance;
634         emit Transfer(address(0), _initialAccount, _initialBalance);
635     }
636 
637     /**
638      * @dev Throws if called by any account other than the whitelistManager.
639      */
640     modifier onlyWhitelistManager() {
641         require(msg.sender == whitelistManager);
642         _;
643     }
644 
645     /**
646      * @dev Modifier to make a function callable only when the contract has transfer fees enabled.
647      */
648     modifier whenFeesEnabled() {
649         require(feesEnabled);
650         _;
651     }
652 
653     /**
654      * @dev Modifier to make a function callable only when the contract has transfer fees disabled.
655      */
656     modifier whenFeesDisabled() {
657         require(!feesEnabled);
658         _;
659     }
660 
661     /**
662      * @dev Enable the whitelist feature.
663      */
664     function enableWhitelist() external onlyOwner {
665         require(
666             !whitelist,
667             'Whitelist is already enabled'
668         );
669 
670         whitelist = true;
671         emit EnabledWhitelist();
672     }
673     
674     /**
675      * @dev Enable the whitelist feature.
676      */
677     function disableWhitelist() external onlyOwner {
678         require(
679             whitelist,
680             'Whitelist is already disabled'
681         );
682 
683         whitelist = false;
684         emit DisabledWhitelist();
685     }
686 
687     /**
688      * @dev Change the whitelist manager address.
689      * @param _whitelistManager address
690      */
691     function changeWhitelistManager(address _whitelistManager) external onlyOwner
692     {
693         require(_whitelistManager != address(0));
694 
695         whitelistManager = _whitelistManager;
696 
697         emit ChangedWhitelistManager(whitelistManager);
698     }
699 
700     /**
701      * @dev Add recipient to the whitelist.
702      * @param _recipient address of the recipient
703      */
704     function addRecipientToWhitelist(address _recipient) external onlyWhitelistManager
705     {
706         require(
707             !whitelistedRecipients[_recipient],
708             'Recipient already whitelisted'
709         );
710 
711         whitelistedRecipients[_recipient] = true;
712 
713         emit AddedRecipientToWhitelist(_recipient);
714     }
715 
716     /**
717      * @dev Add sender to the whitelist.
718      * @param _sender address of the sender
719      */
720     function addSenderToWhitelist(address _sender) external onlyWhitelistManager
721     {
722         require(
723             !whitelistedSenders[_sender],
724             'Sender already whitelisted'
725         );
726 
727         whitelistedSenders[_sender] = true;
728 
729         emit AddedSenderToWhitelist(_sender);
730     }
731 
732     /**
733      * @dev Remove recipient from the whitelist.
734      * @param _recipient address of the recipient
735      */
736     function removeRecipientFromWhitelist(address _recipient) external onlyWhitelistManager
737     {
738         require(
739             whitelistedRecipients[_recipient],
740             'Recipient not whitelisted'
741         );
742 
743         whitelistedRecipients[_recipient] = false;
744 
745         emit RemovedRecipientFromWhitelist(_recipient);
746     }
747 
748     /**
749      * @dev Remove sender from the whitelist.
750      * @param _sender address of the sender
751      */
752     function removeSenderFromWhitelist(address _sender) external onlyWhitelistManager
753     {
754         require(
755             whitelistedSenders[_sender],
756             'Sender not whitelisted'
757         );
758 
759         whitelistedSenders[_sender] = false;
760 
761         emit RemovedSenderFromWhitelist(_sender);
762     }
763 
764     /**
765      * @dev Called by owner to enable fee take
766      */
767     function enableFees()
768         external
769         onlyOwner
770         whenFeesDisabled
771     {
772         feesEnabled = true;
773         emit EnabledFees();
774     }
775 
776     /**
777      * @dev Called by owner to disable fee take
778      */
779     function disableFees()
780         external
781         onlyOwner
782         whenFeesEnabled
783     {
784         feesEnabled = false;
785         emit DisabledFees();
786     }
787 
788     /**
789      * @dev Called by owner to set fee percentage.
790      * @param _fee uint256 The new fee percentage.
791      */
792     function setFee(uint256 _fee)
793         external
794         onlyOwner
795     {
796         require(_fee != uint256(0) && _fee <= 100 * (10 ** 4));
797         fee = _fee;
798         emit FeeChanged(fee);
799     }
800 
801     /**
802      * @dev Called by owner to set fee beeneficiary.
803      * @param _feeBeneficiary address The new fee beneficiary.
804      */
805     function setFeeBeneficiary(address _feeBeneficiary)
806         external
807         onlyOwner
808     {
809         require(_feeBeneficiary != address(0));
810         feeBeneficiary = _feeBeneficiary;
811         emit FeeBeneficiaryChanged(feeBeneficiary);
812     }
813 
814     /**
815      * @dev Called by owner to set fee threshold.
816      * @param _feeThreshold uint256 The new fee threshold.
817      */
818     function setFeeThreshold(uint256 _feeThreshold)
819         external
820         onlyOwner
821     {
822         require(_feeThreshold != uint256(0));
823         feeThreshold = _feeThreshold;
824         emit FeeThresholdChanged(feeThreshold);
825     }
826 
827     /**
828      * @dev transfer token for a specified address
829      * @param _to The address to transfer to.
830      * @param _value The amount to be transferred.
831      */
832     function transfer(address _to, uint256 _value) public returns (bool)
833     {
834         if (whitelist) {
835             require (
836                 whitelistedSenders[msg.sender]
837                 || whitelistedRecipients[_to]
838                 || msg.sender == owner
839                 || _to == owner,
840                 'Sender or recipient not whitelisted'
841             );
842         }
843 
844         uint256 _feeTaken;
845 
846         if (msg.sender != owner && msg.sender != feeBeneficiary) {
847             (_feeTaken, _value) = applyFees(_value);
848         }
849 
850         if (_feeTaken > 0) {
851             require (super.transfer(feeBeneficiary, _feeTaken) && super.transfer(_to, _value));
852 
853             return true;
854         }
855 
856         return super.transfer(_to, _value);
857     }
858 
859     /**
860      * @dev Transfer tokens from one address to another
861      * @param _from address The address which you want to send tokens from
862      * @param _to address The address which you want to transfer to
863      * @param _value uint256 the amount of tokens to be transferred
864      */
865     function transferFrom(address _from, address _to, uint256 _value) public returns (bool)
866     {
867         if (whitelist) {
868             require (
869                 whitelistedSenders[_from]
870                 || whitelistedRecipients[_to]
871                 || _from == owner
872                 || _to == owner,
873                 'Sender or recipient not whitelisted'
874             );
875         }
876 
877         uint256 _feeTaken;
878         (_feeTaken, _value) = applyFees(_value);
879         
880         if (_feeTaken > 0) {
881             require (super.transferFrom(_from, feeBeneficiary, _feeTaken) && super.transferFrom(_from, _to, _value));
882             
883             return true;
884         }
885 
886         return super.transferFrom(_from, _to, _value);
887     }
888 
889     /**
890      * @dev Called internally for applying fees to the transfer value.
891      * @param _value uint256
892      */
893     function applyFees(uint256 _value)
894         internal
895         view
896         returns (uint256 _feeTaken, uint256 _revisedValue)
897     {
898         _revisedValue = _value;
899 
900         if (feesEnabled && _revisedValue >= feeThreshold) {
901             _feeTaken = _revisedValue.mul(fee).div(uint256(100 * (10 ** 4)));
902             _revisedValue = _revisedValue.sub(_feeTaken);
903         }
904     }
905 }