1 /* file: openzeppelin-solidity/contracts/ownership/Ownable.sol */
2 pragma solidity ^0.4.24;
3 
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 /* eof (openzeppelin-solidity/contracts/ownership/Ownable.sol) */
68 /* file: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol */
69 pragma solidity ^0.4.24;
70 
71 
72 /**
73  * @title ERC20Basic
74  * @dev Simpler version of ERC20 interface
75  * See https://github.com/ethereum/EIPs/issues/179
76  */
77 contract ERC20Basic {
78   function totalSupply() public view returns (uint256);
79   function balanceOf(address _who) public view returns (uint256);
80   function transfer(address _to, uint256 _value) public returns (bool);
81   event Transfer(address indexed from, address indexed to, uint256 value);
82 }
83 
84 /* eof (openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol) */
85 /* file: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol */
86 pragma solidity ^0.4.24;
87 
88 
89 
90 /**
91  * @title ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/20
93  */
94 contract ERC20 is ERC20Basic {
95   function allowance(address _owner, address _spender)
96     public view returns (uint256);
97 
98   function transferFrom(address _from, address _to, uint256 _value)
99     public returns (bool);
100 
101   function approve(address _spender, uint256 _value) public returns (bool);
102   event Approval(
103     address indexed owner,
104     address indexed spender,
105     uint256 value
106   );
107 }
108 
109 /* eof (openzeppelin-solidity/contracts/token/ERC20/ERC20.sol) */
110 /* file: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol */
111 pragma solidity ^0.4.24;
112 
113 
114 
115 /**
116  * @title SafeERC20
117  * @dev Wrappers around ERC20 operations that throw on failure.
118  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
119  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
120  */
121 library SafeERC20 {
122   function safeTransfer(
123     ERC20Basic _token,
124     address _to,
125     uint256 _value
126   )
127     internal
128   {
129     require(_token.transfer(_to, _value));
130   }
131 
132   function safeTransferFrom(
133     ERC20 _token,
134     address _from,
135     address _to,
136     uint256 _value
137   )
138     internal
139   {
140     require(_token.transferFrom(_from, _to, _value));
141   }
142 
143   function safeApprove(
144     ERC20 _token,
145     address _spender,
146     uint256 _value
147   )
148     internal
149   {
150     require(_token.approve(_spender, _value));
151   }
152 }
153 
154 /* eof (openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol) */
155 /* file: openzeppelin-solidity/contracts/ownership/CanReclaimToken.sol */
156 pragma solidity ^0.4.24;
157 
158 
159 
160 /**
161  * @title Contracts that should be able to recover tokens
162  * @author SylTi
163  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
164  * This will prevent any accidental loss of tokens.
165  */
166 contract CanReclaimToken is Ownable {
167   using SafeERC20 for ERC20Basic;
168 
169   /**
170    * @dev Reclaim all ERC20Basic compatible tokens
171    * @param _token ERC20Basic The address of the token contract
172    */
173   function reclaimToken(ERC20Basic _token) external onlyOwner {
174     uint256 balance = _token.balanceOf(this);
175     _token.safeTransfer(owner, balance);
176   }
177 
178 }
179 
180 /* eof (openzeppelin-solidity/contracts/ownership/CanReclaimToken.sol) */
181 /* file: openzeppelin-solidity/contracts/math/SafeMath.sol */
182 pragma solidity ^0.4.24;
183 
184 
185 /**
186  * @title SafeMath
187  * @dev Math operations with safety checks that throw on error
188  */
189 library SafeMath {
190 
191   /**
192   * @dev Multiplies two numbers, throws on overflow.
193   */
194   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
195     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
196     // benefit is lost if 'b' is also tested.
197     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
198     if (_a == 0) {
199       return 0;
200     }
201 
202     c = _a * _b;
203     assert(c / _a == _b);
204     return c;
205   }
206 
207   /**
208   * @dev Integer division of two numbers, truncating the quotient.
209   */
210   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
211     // assert(_b > 0); // Solidity automatically throws when dividing by 0
212     // uint256 c = _a / _b;
213     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
214     return _a / _b;
215   }
216 
217   /**
218   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
219   */
220   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
221     assert(_b <= _a);
222     return _a - _b;
223   }
224 
225   /**
226   * @dev Adds two numbers, throws on overflow.
227   */
228   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
229     c = _a + _b;
230     assert(c >= _a);
231     return c;
232   }
233 }
234 
235 /* eof (openzeppelin-solidity/contracts/math/SafeMath.sol) */
236 /* file: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol */
237 pragma solidity ^0.4.24;
238 
239 
240 
241 
242 /**
243  * @title Basic token
244  * @dev Basic version of StandardToken, with no allowances.
245  */
246 contract BasicToken is ERC20Basic {
247   using SafeMath for uint256;
248 
249   mapping(address => uint256) internal balances;
250 
251   uint256 internal totalSupply_;
252 
253   /**
254   * @dev Total number of tokens in existence
255   */
256   function totalSupply() public view returns (uint256) {
257     return totalSupply_;
258   }
259 
260   /**
261   * @dev Transfer token for a specified address
262   * @param _to The address to transfer to.
263   * @param _value The amount to be transferred.
264   */
265   function transfer(address _to, uint256 _value) public returns (bool) {
266     require(_value <= balances[msg.sender]);
267     require(_to != address(0));
268 
269     balances[msg.sender] = balances[msg.sender].sub(_value);
270     balances[_to] = balances[_to].add(_value);
271     emit Transfer(msg.sender, _to, _value);
272     return true;
273   }
274 
275   /**
276   * @dev Gets the balance of the specified address.
277   * @param _owner The address to query the the balance of.
278   * @return An uint256 representing the amount owned by the passed address.
279   */
280   function balanceOf(address _owner) public view returns (uint256) {
281     return balances[_owner];
282   }
283 
284 }
285 
286 /* eof (openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol) */
287 /* file: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol */
288 pragma solidity ^0.4.24;
289 
290 
291 
292 /**
293  * @title Burnable Token
294  * @dev Token that can be irreversibly burned (destroyed).
295  */
296 contract BurnableToken is BasicToken {
297 
298   event Burn(address indexed burner, uint256 value);
299 
300   /**
301    * @dev Burns a specific amount of tokens.
302    * @param _value The amount of token to be burned.
303    */
304   function burn(uint256 _value) public {
305     _burn(msg.sender, _value);
306   }
307 
308   function _burn(address _who, uint256 _value) internal {
309     require(_value <= balances[_who]);
310     // no need to require value <= totalSupply, since that would imply the
311     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
312 
313     balances[_who] = balances[_who].sub(_value);
314     totalSupply_ = totalSupply_.sub(_value);
315     emit Burn(_who, _value);
316     emit Transfer(_who, address(0), _value);
317   }
318 }
319 
320 /* eof (openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol) */
321 /* file: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol */
322 pragma solidity ^0.4.24;
323 
324 
325 
326 /**
327  * @title Standard ERC20 token
328  *
329  * @dev Implementation of the basic standard token.
330  * https://github.com/ethereum/EIPs/issues/20
331  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
332  */
333 contract StandardToken is ERC20, BasicToken {
334 
335   mapping (address => mapping (address => uint256)) internal allowed;
336 
337 
338   /**
339    * @dev Transfer tokens from one address to another
340    * @param _from address The address which you want to send tokens from
341    * @param _to address The address which you want to transfer to
342    * @param _value uint256 the amount of tokens to be transferred
343    */
344   function transferFrom(
345     address _from,
346     address _to,
347     uint256 _value
348   )
349     public
350     returns (bool)
351   {
352     require(_value <= balances[_from]);
353     require(_value <= allowed[_from][msg.sender]);
354     require(_to != address(0));
355 
356     balances[_from] = balances[_from].sub(_value);
357     balances[_to] = balances[_to].add(_value);
358     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
359     emit Transfer(_from, _to, _value);
360     return true;
361   }
362 
363   /**
364    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
365    * Beware that changing an allowance with this method brings the risk that someone may use both the old
366    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
367    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
368    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
369    * @param _spender The address which will spend the funds.
370    * @param _value The amount of tokens to be spent.
371    */
372   function approve(address _spender, uint256 _value) public returns (bool) {
373     allowed[msg.sender][_spender] = _value;
374     emit Approval(msg.sender, _spender, _value);
375     return true;
376   }
377 
378   /**
379    * @dev Function to check the amount of tokens that an owner allowed to a spender.
380    * @param _owner address The address which owns the funds.
381    * @param _spender address The address which will spend the funds.
382    * @return A uint256 specifying the amount of tokens still available for the spender.
383    */
384   function allowance(
385     address _owner,
386     address _spender
387    )
388     public
389     view
390     returns (uint256)
391   {
392     return allowed[_owner][_spender];
393   }
394 
395   /**
396    * @dev Increase the amount of tokens that an owner allowed to a spender.
397    * approve should be called when allowed[_spender] == 0. To increment
398    * allowed value is better to use this function to avoid 2 calls (and wait until
399    * the first transaction is mined)
400    * From MonolithDAO Token.sol
401    * @param _spender The address which will spend the funds.
402    * @param _addedValue The amount of tokens to increase the allowance by.
403    */
404   function increaseApproval(
405     address _spender,
406     uint256 _addedValue
407   )
408     public
409     returns (bool)
410   {
411     allowed[msg.sender][_spender] = (
412       allowed[msg.sender][_spender].add(_addedValue));
413     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
414     return true;
415   }
416 
417   /**
418    * @dev Decrease the amount of tokens that an owner allowed to a spender.
419    * approve should be called when allowed[_spender] == 0. To decrement
420    * allowed value is better to use this function to avoid 2 calls (and wait until
421    * the first transaction is mined)
422    * From MonolithDAO Token.sol
423    * @param _spender The address which will spend the funds.
424    * @param _subtractedValue The amount of tokens to decrease the allowance by.
425    */
426   function decreaseApproval(
427     address _spender,
428     uint256 _subtractedValue
429   )
430     public
431     returns (bool)
432   {
433     uint256 oldValue = allowed[msg.sender][_spender];
434     if (_subtractedValue >= oldValue) {
435       allowed[msg.sender][_spender] = 0;
436     } else {
437       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
438     }
439     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
440     return true;
441   }
442 
443 }
444 
445 /* eof (openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol) */
446 /* file: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol */
447 pragma solidity ^0.4.24;
448 
449 
450 
451 /**
452  * @title Mintable token
453  * @dev Simple ERC20 Token example, with mintable token creation
454  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
455  */
456 contract MintableToken is StandardToken, Ownable {
457   event Mint(address indexed to, uint256 amount);
458   event MintFinished();
459 
460   bool public mintingFinished = false;
461 
462 
463   modifier canMint() {
464     require(!mintingFinished);
465     _;
466   }
467 
468   modifier hasMintPermission() {
469     require(msg.sender == owner);
470     _;
471   }
472 
473   /**
474    * @dev Function to mint tokens
475    * @param _to The address that will receive the minted tokens.
476    * @param _amount The amount of tokens to mint.
477    * @return A boolean that indicates if the operation was successful.
478    */
479   function mint(
480     address _to,
481     uint256 _amount
482   )
483     public
484     hasMintPermission
485     canMint
486     returns (bool)
487   {
488     totalSupply_ = totalSupply_.add(_amount);
489     balances[_to] = balances[_to].add(_amount);
490     emit Mint(_to, _amount);
491     emit Transfer(address(0), _to, _amount);
492     return true;
493   }
494 
495   /**
496    * @dev Function to stop minting new tokens.
497    * @return True if the operation was successful.
498    */
499   function finishMinting() public onlyOwner canMint returns (bool) {
500     mintingFinished = true;
501     emit MintFinished();
502     return true;
503   }
504 }
505 
506 /* eof (openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol) */
507 /* file: openzeppelin-solidity/contracts/lifecycle/Pausable.sol */
508 pragma solidity ^0.4.24;
509 
510 
511 
512 
513 /**
514  * @title Pausable
515  * @dev Base contract which allows children to implement an emergency stop mechanism.
516  */
517 contract Pausable is Ownable {
518   event Pause();
519   event Unpause();
520 
521   bool public paused = false;
522 
523 
524   /**
525    * @dev Modifier to make a function callable only when the contract is not paused.
526    */
527   modifier whenNotPaused() {
528     require(!paused);
529     _;
530   }
531 
532   /**
533    * @dev Modifier to make a function callable only when the contract is paused.
534    */
535   modifier whenPaused() {
536     require(paused);
537     _;
538   }
539 
540   /**
541    * @dev called by the owner to pause, triggers stopped state
542    */
543   function pause() public onlyOwner whenNotPaused {
544     paused = true;
545     emit Pause();
546   }
547 
548   /**
549    * @dev called by the owner to unpause, returns to normal state
550    */
551   function unpause() public onlyOwner whenPaused {
552     paused = false;
553     emit Unpause();
554   }
555 }
556 
557 /* eof (openzeppelin-solidity/contracts/lifecycle/Pausable.sol) */
558 /* file: openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol */
559 pragma solidity ^0.4.24;
560 
561 
562 
563 /**
564  * @title Pausable token
565  * @dev StandardToken modified with pausable transfers.
566  **/
567 contract PausableToken is StandardToken, Pausable {
568 
569   function transfer(
570     address _to,
571     uint256 _value
572   )
573     public
574     whenNotPaused
575     returns (bool)
576   {
577     return super.transfer(_to, _value);
578   }
579 
580   function transferFrom(
581     address _from,
582     address _to,
583     uint256 _value
584   )
585     public
586     whenNotPaused
587     returns (bool)
588   {
589     return super.transferFrom(_from, _to, _value);
590   }
591 
592   function approve(
593     address _spender,
594     uint256 _value
595   )
596     public
597     whenNotPaused
598     returns (bool)
599   {
600     return super.approve(_spender, _value);
601   }
602 
603   function increaseApproval(
604     address _spender,
605     uint _addedValue
606   )
607     public
608     whenNotPaused
609     returns (bool success)
610   {
611     return super.increaseApproval(_spender, _addedValue);
612   }
613 
614   function decreaseApproval(
615     address _spender,
616     uint _subtractedValue
617   )
618     public
619     whenNotPaused
620     returns (bool success)
621   {
622     return super.decreaseApproval(_spender, _subtractedValue);
623   }
624 }
625 
626 /* eof (openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol) */
627 /* file: ./contracts/ico/SnapshotToken.sol */
628 /**
629  * @title SnapshotToken
630  * ERC-20 Compatible Token inspired by the MiniMeToken contract for an auditable history of previous balances
631  * @author Validity Labs AG <info@validitylabs.org>
632  */
633 pragma solidity 0.4.24;
634 
635 
636 
637 contract SnapshotToken is BurnableToken, MintableToken, PausableToken {
638     using SafeMath for uint256;
639 
640     /** 
641     * @dev `Checkpoint` is the structure that attaches a block number to a
642     * given value, the block number attached is the one that last changed the value
643     */
644     struct Checkpoint {
645         // `fromBlock` is the block number that the value was generated super.mint(_to, _amount); from
646         uint128 fromBlock;
647         // `value` is the amount of tokens at a specific block number
648         uint128 value;
649     }
650  
651     // Tracks the history of the `totalSupply` of the token
652     Checkpoint[] public totalSupplyHistory;
653 
654     // `balances` is the map that tracks the balance of each address, in this
655     //  contract when the balance changes the block number that the change
656     //  occurred is also included in the map
657     mapping (address => Checkpoint[]) public balances;
658 
659     /**
660     * @notice Send `_amount` tokens to `_to` from `msg.sender`
661     * @param _to The address of the recipient
662     * @param _amount The amount of tokens to be transferred
663     * @return Whether the transfer was successful or not
664     */
665     function transfer(address _to, uint256 _amount) public whenNotPaused returns (bool success) {
666         doTransfer(msg.sender, _to, _amount);
667         return true;
668     }
669 
670     /**
671     * @notice Send `_amount` tokens to `_to` from `_from` on the condition it
672     *  is approved by `_from`
673     * @param _from The address holding the tokens being transferred
674     * @param _to The address of the recipient
675     * @param _amount The amount of tokens to be transferred
676     * @return True if the transfer was successful
677     */
678     function transferFrom(address _from, address _to, uint256 _amount) public whenNotPaused returns (bool success) {
679         // The standard ERC 20 transferFrom functionality
680         require(allowed[_from][msg.sender] >= _amount, "amount > allowance");
681         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
682 
683         doTransfer(_from, _to, _amount);
684         return true;
685     }
686 
687     /**
688     * @param _owner The address that's balance is being requested
689     * @return The balance of `_owner` at the current block
690     */
691     function balanceOf(address _owner) public view returns (uint256 balance) {
692         return balanceOfAt(_owner, block.number);
693     }
694 
695     /**
696     * @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
697     *  its behalf. This is a modified version of the ERC20 approve function
698     *  to be a little bit safer
699     * @param _spender The address of the account able to transfer the tokens
700     * @param _amount The amount of tokens to be approved for transfer
701     * @return True if the approval was successful
702     */
703     function approve(address _spender, uint256 _amount) public whenNotPaused returns (bool success) {
704         // To change the approve amount you first have to reduce the addresses`
705         //  allowance to zero by calling `approve(_spender,0)` if it is not
706         //  already 0 to mitigate the race condition described here:
707         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
708         require((_amount == 0) || (allowed[msg.sender][_spender] == 0), "reset allowance required");
709 
710         allowed[msg.sender][_spender] = _amount;
711         emit Approval(msg.sender, _spender, _amount);
712         return true;
713     }
714 
715     /**
716     * @dev This function makes it easy to get the total number of tokens
717     * @return The total number of tokens
718     */
719     function totalSupply() public view returns (uint256) {
720         return totalSupplyAt(block.number);
721     }
722 
723     /**
724     * @dev Queries the balance of `_owner` at a specific `_blockNumber`
725     * @param _owner The address from which the balance will be retrieved
726     * @param _blockNumber The block number when the balance is queried
727     * @return The balance at `_blockNumber`
728     */
729     function balanceOfAt(address _owner, uint256 _blockNumber) public view returns (uint256) {
730         return balanceAt(_owner, _blockNumber, false);
731     }
732 
733     /**
734     * @notice Total amount of tokens at a specific `_blockNumber`.
735     * @param _blockNumber The block number when the totalSupply is queried
736     * @return The total amount of tokens at `_blockNumber`
737     */
738     function totalSupplyAt(uint256 _blockNumber) public view returns(uint256) {
739         return balanceAt(address(0), _blockNumber, true);
740     }
741 
742     /**
743     * @dev Generates `_amount` tokens that are assigned to `_to`
744     * @param _to The address that will be assigned the new tokens
745     * @param _amount The quantity of tokens generated
746     * @return True if the tokens are generated correctly
747     */
748     function mint(address _to, uint256 _amount) public hasMintPermission canMint returns (bool) {
749         uint256 curTotalSupply = totalSupply();
750 
751         uint256 previousBalanceTo = balanceOf(_to);
752 
753         updateValueAtNow(totalSupplyHistory, curTotalSupply.add(_amount));
754         updateValueAtNow(balances[_to], previousBalanceTo.add(_amount));
755 
756         emit Mint(_to, _amount);
757         emit Transfer(0, _to, _amount);
758         return true;
759     }
760 
761     /**
762     * @notice Burns `_amount` tokens from `msg.sender`
763     * @param _amount The quantity of tokens to burn
764     * @return True if the tokens are burned correctly
765     */
766     function burn(uint256 _amount) public {
767         uint256 curTotalSupply = totalSupply();
768         uint256 previousBalanceFrom = balanceOf(msg.sender);
769 
770         updateValueAtNow(totalSupplyHistory, curTotalSupply.sub(_amount));
771         updateValueAtNow(balances[msg.sender], previousBalanceFrom.sub(_amount));
772 
773         emit Burn(msg.sender, _amount);
774         emit Transfer(msg.sender, 0, _amount);
775     }
776 
777     /*** INTERNAL/PRIVATE ***/
778     /**
779     * @dev This is the actual transfer function in the token contract, it can
780     *      only be called by other functions in this contract.
781     * @param _from The address holding the tokens being transferred
782     * @param _to The address of the recipient
783     * @param _amount The amount of tokens to be transferred
784     * @return True if the transfer was successful
785     */
786     function doTransfer(address _from, address _to, uint256 _amount) internal {
787         if (_amount == 0) {
788             emit Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
789             return;
790         }
791 
792         // Do not allow transfer to 0x0 or the token contract itself
793         require((_to != address(0)) && (_to != address(this)), "cannot transfer to 0x0 or self");
794 
795         // If the amount being transfered is more than the balance of the
796         //  account the transfer throws
797         uint256 previousBalanceFrom = balanceOfAt(_from, block.number);
798         require(previousBalanceFrom >= _amount, "amount > balance");
799 
800         // First update the balance array with the new value for the address
801         //  sending the tokens
802         updateValueAtNow(balances[_from], previousBalanceFrom.sub(_amount));
803 
804         // Then update the balance array with the new value for the address
805         //  receiving the tokens
806         uint256 previousBalanceTo = balanceOfAt(_to, block.number);
807         updateValueAtNow(balances[_to], previousBalanceTo.add(_amount));
808 
809         // An event to make the transfer easy to find on the blockchain
810         emit Transfer(_from, _to, _amount);
811     }
812 
813     /**
814     * @notice this internal function retrieives the historyical balance of either totalSupply or from an address
815     * @param _owner address of a wallet/contract to check
816     * @param _blockNumber uint256 block number to retrieve balance at
817     * @param _isTotalSupply bool marks if totalSupply or wallet/contract balance lookup
818     */
819     function balanceAt(address _owner, uint256 _blockNumber, bool _isTotalSupply) internal view returns (uint256) {
820         Checkpoint[] memory balanceArray;
821 
822         if (_isTotalSupply) {
823             balanceArray = totalSupplyHistory;
824         } else {
825             balanceArray = balances[_owner];
826         }
827 
828         if ((balanceArray.length == 0) || (balanceArray[0].fromBlock > _blockNumber)) {
829             return 0;
830         // This will return the expected totalSupply during normal situations
831         } else {
832             return getValueAt(balanceArray, _blockNumber);
833         }
834     }
835 
836     /**
837     * @dev `getValueAt` retrieves the number of tokens at a given block number
838     * @param checkpoints The history of values being queried
839     * @param _block The block number to retrieve the value at
840     * @return The number of tokens being queried
841     */
842     function getValueAt(Checkpoint[] memory checkpoints, uint256 _block) internal pure returns (uint256) {
843         // Shortcut for the actual value
844         if (_block >= checkpoints[checkpoints.length.sub(1)].fromBlock) {
845             return checkpoints[checkpoints.length.sub(1)].value;
846         }
847 
848         // Binary search of the value in the array
849         uint256 min = 0;
850         uint256 max = checkpoints.length.sub(1);
851         while (max > min) {
852             uint256 mid = (max.add(min).add(1)).div(2);
853             if (checkpoints[mid].fromBlock <= _block) {
854                 min = mid;
855             } else {
856                 max = mid.sub(1);
857             }
858         }
859         return checkpoints[min].value;
860     }
861 
862     /**
863     *@dev `updateValueAtNow` used to update the `balances` map and the
864     *  `totalSupplyHistory`
865     * @param checkpoints The history of data being updated
866     * @param _value The new number of tokens
867     */
868     function updateValueAtNow(Checkpoint[] storage checkpoints, uint256 _value) internal {
869         if ((checkpoints.length == 0) || (checkpoints[checkpoints.length.sub(1)].fromBlock < block.number)) {
870             checkpoints.push(Checkpoint(uint128(block.number), uint128(_value)));
871         } else {
872             checkpoints[checkpoints.length.sub(1)].value = uint128(_value);
873         }
874     }
875 }
876 
877 /* eof (./contracts/ico/SnapshotToken.sol) */
878 /* file: ./contracts/ico/HbeToken.sol */
879 /**
880  * @title HBE token
881  * @author Validity Labs AG <info@validitylabs.org>
882  */
883 pragma solidity 0.4.24;
884 
885 
886 
887 contract HbeToken is CanReclaimToken, SnapshotToken {
888     /* solhint-disable */
889     string public constant name = "healthbank Token";
890     string public constant symbol = "HBE";
891     uint8 public constant decimals = 0;
892     /* solhint-enable */
893 
894     address public hbeMembership;
895     address public hbeMemberVault;
896 
897     bool private _lockContracts;
898 
899     /** MODIFIERS **/
900     modifier onlyHbeMembership() {
901         require(msg.sender == hbeMembership, "not a member");
902         _;
903     }
904 
905     /**
906      * @dev Constructor of HbeToken that instantiates a new Mintable Pauseable Burnable Token
907      */
908     constructor() public {
909         // token should not be transferrable until after all tokens have been issued
910         paused = true;
911     }
912 
913     /** 
914     * @dev allows onlyHbeMembership to release the tokens of an existing member, effective cancelling their membership
915     * @param _address address of the ex HBE member
916     * @param _currentlyLocked amount of HBE tokens locked owned by member
917     */
918     function releaseMembershipFee(address _address, uint256 _currentlyLocked) external onlyHbeMembership {
919         doTransfer(hbeMemberVault, _address, _currentlyLocked);
920     }
921 
922     /**
923     * @dev updates the member's locked HBE balance to reflect the current HBE Membership price
924     * @param _address address of the HBE member
925     * @param _currentlyLocked amount of HBE tokens locked owned by member
926     * @param _currentMemberFee current membership fee pricing
927     * @return bool, bool, uint256 
928     */
929     function updateMemberBalance(address _address, uint256 _currentlyLocked, uint256 _currentMemberFee) 
930         external 
931         onlyHbeMembership 
932         returns (bool, bool, uint256) {
933             uint256 currentBalance = balanceOf(_address);
934             uint256 difference;
935 
936             // balance due from _address
937             if (_currentlyLocked < _currentMemberFee) {
938                 difference = _currentMemberFee.sub(_currentlyLocked);
939 
940                 if (difference <= currentBalance) {
941                     doTransfer(_address, hbeMemberVault, difference);
942                     // mark successful, no refund, N balance chance
943                     return(true, false, difference);
944                 } else {
945                     revert("insufficent HBE funds");
946                 }
947             }
948 
949             // refund due to _address
950             if (_currentlyLocked > _currentMemberFee) {
951                 difference = _currentlyLocked.sub(_currentMemberFee);
952         
953                 doTransfer(hbeMemberVault, _address, difference);
954 
955                 // mark successful, yes refund, N balance change
956                 return(true, true, difference);
957             }
958             // mark successful, no refund, 0 balance change Eg. already an active member
959             return (true, false, 0);
960         }
961 
962     /**
963     * @notice allows onlyOwner to set the address of the HBE membership contracts
964     * @dev onlyOwner to set the contracts once. Afterwards, the contracts' addresses are locked and cannot be updated
965     * @param _membershipContract address of membership management
966     * @param _membershipVault address of the membe HBE token vault
967     */
968     function setMembershipContracts(address _membershipContract, address _membershipVault) external onlyOwner {
969         require(!_lockContracts);
970         require(_membershipContract != address(0), "invalid membership address");
971         require(_membershipVault != address(0), "invalid vault address");
972 
973         _lockContracts = true;
974 
975         hbeMembership = _membershipContract;
976         hbeMemberVault = _membershipVault;
977     }
978 }
979 
980 /* eof (./contracts/ico/HbeToken.sol) */