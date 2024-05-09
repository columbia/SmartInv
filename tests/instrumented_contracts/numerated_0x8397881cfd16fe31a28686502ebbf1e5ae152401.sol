1 //File: node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
2 pragma solidity ^0.4.24;
3 
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
17 //File: node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol
18 pragma solidity ^0.4.24;
19 
20 
21 /**
22  * @title SafeMath
23  * @dev Math operations with safety checks that throw on error
24  */
25 library SafeMath {
26 
27   /**
28   * @dev Multiplies two numbers, throws on overflow.
29   */
30   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
31     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
32     // benefit is lost if 'b' is also tested.
33     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
34     if (_a == 0) {
35       return 0;
36     }
37 
38     c = _a * _b;
39     assert(c / _a == _b);
40     return c;
41   }
42 
43   /**
44   * @dev Integer division of two numbers, truncating the quotient.
45   */
46   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
47     // assert(_b > 0); // Solidity automatically throws when dividing by 0
48     // uint256 c = _a / _b;
49     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
50     return _a / _b;
51   }
52 
53   /**
54   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
55   */
56   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
57     assert(_b <= _a);
58     return _a - _b;
59   }
60 
61   /**
62   * @dev Adds two numbers, throws on overflow.
63   */
64   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
65     c = _a + _b;
66     assert(c >= _a);
67     return c;
68   }
69 }
70 
71 //File: node_modules/openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
72 pragma solidity ^0.4.24;
73 
74 
75 
76 
77 
78 
79 /**
80  * @title Basic token
81  * @dev Basic version of StandardToken, with no allowances.
82  */
83 contract BasicToken is ERC20Basic {
84   using SafeMath for uint256;
85 
86   mapping(address => uint256) internal balances;
87 
88   uint256 internal totalSupply_;
89 
90   /**
91   * @dev Total number of tokens in existence
92   */
93   function totalSupply() public view returns (uint256) {
94     return totalSupply_;
95   }
96 
97   /**
98   * @dev Transfer token for a specified address
99   * @param _to The address to transfer to.
100   * @param _value The amount to be transferred.
101   */
102   function transfer(address _to, uint256 _value) public returns (bool) {
103     require(_value <= balances[msg.sender]);
104     require(_to != address(0));
105 
106     balances[msg.sender] = balances[msg.sender].sub(_value);
107     balances[_to] = balances[_to].add(_value);
108     emit Transfer(msg.sender, _to, _value);
109     return true;
110   }
111 
112   /**
113   * @dev Gets the balance of the specified address.
114   * @param _owner The address to query the the balance of.
115   * @return An uint256 representing the amount owned by the passed address.
116   */
117   function balanceOf(address _owner) public view returns (uint256) {
118     return balances[_owner];
119   }
120 
121 }
122 
123 //File: node_modules/openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
124 pragma solidity ^0.4.24;
125 
126 
127 
128 
129 /**
130  * @title Burnable Token
131  * @dev Token that can be irreversibly burned (destroyed).
132  */
133 contract BurnableToken is BasicToken {
134 
135   event Burn(address indexed burner, uint256 value);
136 
137   /**
138    * @dev Burns a specific amount of tokens.
139    * @param _value The amount of token to be burned.
140    */
141   function burn(uint256 _value) public {
142     _burn(msg.sender, _value);
143   }
144 
145   function _burn(address _who, uint256 _value) internal {
146     require(_value <= balances[_who]);
147     // no need to require value <= totalSupply, since that would imply the
148     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
149 
150     balances[_who] = balances[_who].sub(_value);
151     totalSupply_ = totalSupply_.sub(_value);
152     emit Burn(_who, _value);
153     emit Transfer(_who, address(0), _value);
154   }
155 }
156 
157 //File: node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
158 pragma solidity ^0.4.24;
159 
160 
161 
162 
163 /**
164  * @title ERC20 interface
165  * @dev see https://github.com/ethereum/EIPs/issues/20
166  */
167 contract ERC20 is ERC20Basic {
168   function allowance(address _owner, address _spender)
169     public view returns (uint256);
170 
171   function transferFrom(address _from, address _to, uint256 _value)
172     public returns (bool);
173 
174   function approve(address _spender, uint256 _value) public returns (bool);
175   event Approval(
176     address indexed owner,
177     address indexed spender,
178     uint256 value
179   );
180 }
181 
182 //File: node_modules/openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
183 pragma solidity ^0.4.24;
184 
185 
186 
187 
188 
189 /**
190  * @title Standard ERC20 token
191  *
192  * @dev Implementation of the basic standard token.
193  * https://github.com/ethereum/EIPs/issues/20
194  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
195  */
196 contract StandardToken is ERC20, BasicToken {
197 
198   mapping (address => mapping (address => uint256)) internal allowed;
199 
200 
201   /**
202    * @dev Transfer tokens from one address to another
203    * @param _from address The address which you want to send tokens from
204    * @param _to address The address which you want to transfer to
205    * @param _value uint256 the amount of tokens to be transferred
206    */
207   function transferFrom(
208     address _from,
209     address _to,
210     uint256 _value
211   )
212     public
213     returns (bool)
214   {
215     require(_value <= balances[_from]);
216     require(_value <= allowed[_from][msg.sender]);
217     require(_to != address(0));
218 
219     balances[_from] = balances[_from].sub(_value);
220     balances[_to] = balances[_to].add(_value);
221     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
222     emit Transfer(_from, _to, _value);
223     return true;
224   }
225 
226   /**
227    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
228    * Beware that changing an allowance with this method brings the risk that someone may use both the old
229    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
230    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
231    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
232    * @param _spender The address which will spend the funds.
233    * @param _value The amount of tokens to be spent.
234    */
235   function approve(address _spender, uint256 _value) public returns (bool) {
236     allowed[msg.sender][_spender] = _value;
237     emit Approval(msg.sender, _spender, _value);
238     return true;
239   }
240 
241   /**
242    * @dev Function to check the amount of tokens that an owner allowed to a spender.
243    * @param _owner address The address which owns the funds.
244    * @param _spender address The address which will spend the funds.
245    * @return A uint256 specifying the amount of tokens still available for the spender.
246    */
247   function allowance(
248     address _owner,
249     address _spender
250    )
251     public
252     view
253     returns (uint256)
254   {
255     return allowed[_owner][_spender];
256   }
257 
258   /**
259    * @dev Increase the amount of tokens that an owner allowed to a spender.
260    * approve should be called when allowed[_spender] == 0. To increment
261    * allowed value is better to use this function to avoid 2 calls (and wait until
262    * the first transaction is mined)
263    * From MonolithDAO Token.sol
264    * @param _spender The address which will spend the funds.
265    * @param _addedValue The amount of tokens to increase the allowance by.
266    */
267   function increaseApproval(
268     address _spender,
269     uint256 _addedValue
270   )
271     public
272     returns (bool)
273   {
274     allowed[msg.sender][_spender] = (
275       allowed[msg.sender][_spender].add(_addedValue));
276     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
277     return true;
278   }
279 
280   /**
281    * @dev Decrease the amount of tokens that an owner allowed to a spender.
282    * approve should be called when allowed[_spender] == 0. To decrement
283    * allowed value is better to use this function to avoid 2 calls (and wait until
284    * the first transaction is mined)
285    * From MonolithDAO Token.sol
286    * @param _spender The address which will spend the funds.
287    * @param _subtractedValue The amount of tokens to decrease the allowance by.
288    */
289   function decreaseApproval(
290     address _spender,
291     uint256 _subtractedValue
292   )
293     public
294     returns (bool)
295   {
296     uint256 oldValue = allowed[msg.sender][_spender];
297     if (_subtractedValue >= oldValue) {
298       allowed[msg.sender][_spender] = 0;
299     } else {
300       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
301     }
302     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
303     return true;
304   }
305 
306 }
307 
308 //File: node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol
309 pragma solidity ^0.4.24;
310 
311 
312 /**
313  * @title Ownable
314  * @dev The Ownable contract has an owner address, and provides basic authorization control
315  * functions, this simplifies the implementation of "user permissions".
316  */
317 contract Ownable {
318   address public owner;
319 
320 
321   event OwnershipRenounced(address indexed previousOwner);
322   event OwnershipTransferred(
323     address indexed previousOwner,
324     address indexed newOwner
325   );
326 
327 
328   /**
329    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
330    * account.
331    */
332   constructor() public {
333     owner = msg.sender;
334   }
335 
336   /**
337    * @dev Throws if called by any account other than the owner.
338    */
339   modifier onlyOwner() {
340     require(msg.sender == owner);
341     _;
342   }
343 
344   /**
345    * @dev Allows the current owner to relinquish control of the contract.
346    * @notice Renouncing to ownership will leave the contract without an owner.
347    * It will not be possible to call the functions with the `onlyOwner`
348    * modifier anymore.
349    */
350   function renounceOwnership() public onlyOwner {
351     emit OwnershipRenounced(owner);
352     owner = address(0);
353   }
354 
355   /**
356    * @dev Allows the current owner to transfer control of the contract to a newOwner.
357    * @param _newOwner The address to transfer ownership to.
358    */
359   function transferOwnership(address _newOwner) public onlyOwner {
360     _transferOwnership(_newOwner);
361   }
362 
363   /**
364    * @dev Transfers control of the contract to a newOwner.
365    * @param _newOwner The address to transfer ownership to.
366    */
367   function _transferOwnership(address _newOwner) internal {
368     require(_newOwner != address(0));
369     emit OwnershipTransferred(owner, _newOwner);
370     owner = _newOwner;
371   }
372 }
373 
374 //File: node_modules/openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
375 pragma solidity ^0.4.24;
376 
377 
378 
379 
380 
381 /**
382  * @title Mintable token
383  * @dev Simple ERC20 Token example, with mintable token creation
384  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
385  */
386 contract MintableToken is StandardToken, Ownable {
387   event Mint(address indexed to, uint256 amount);
388   event MintFinished();
389 
390   bool public mintingFinished = false;
391 
392 
393   modifier canMint() {
394     require(!mintingFinished);
395     _;
396   }
397 
398   modifier hasMintPermission() {
399     require(msg.sender == owner);
400     _;
401   }
402 
403   /**
404    * @dev Function to mint tokens
405    * @param _to The address that will receive the minted tokens.
406    * @param _amount The amount of tokens to mint.
407    * @return A boolean that indicates if the operation was successful.
408    */
409   function mint(
410     address _to,
411     uint256 _amount
412   )
413     public
414     hasMintPermission
415     canMint
416     returns (bool)
417   {
418     totalSupply_ = totalSupply_.add(_amount);
419     balances[_to] = balances[_to].add(_amount);
420     emit Mint(_to, _amount);
421     emit Transfer(address(0), _to, _amount);
422     return true;
423   }
424 
425   /**
426    * @dev Function to stop minting new tokens.
427    * @return True if the operation was successful.
428    */
429   function finishMinting() public onlyOwner canMint returns (bool) {
430     mintingFinished = true;
431     emit MintFinished();
432     return true;
433   }
434 }
435 
436 //File: node_modules/openzeppelin-solidity/contracts/lifecycle/Pausable.sol
437 pragma solidity ^0.4.24;
438 
439 
440 
441 
442 
443 /**
444  * @title Pausable
445  * @dev Base contract which allows children to implement an emergency stop mechanism.
446  */
447 contract Pausable is Ownable {
448   event Pause();
449   event Unpause();
450 
451   bool public paused = false;
452 
453 
454   /**
455    * @dev Modifier to make a function callable only when the contract is not paused.
456    */
457   modifier whenNotPaused() {
458     require(!paused);
459     _;
460   }
461 
462   /**
463    * @dev Modifier to make a function callable only when the contract is paused.
464    */
465   modifier whenPaused() {
466     require(paused);
467     _;
468   }
469 
470   /**
471    * @dev called by the owner to pause, triggers stopped state
472    */
473   function pause() public onlyOwner whenNotPaused {
474     paused = true;
475     emit Pause();
476   }
477 
478   /**
479    * @dev called by the owner to unpause, returns to normal state
480    */
481   function unpause() public onlyOwner whenPaused {
482     paused = false;
483     emit Unpause();
484   }
485 }
486 
487 //File: node_modules/openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol
488 pragma solidity ^0.4.24;
489 
490 
491 
492 
493 
494 /**
495  * @title Pausable token
496  * @dev StandardToken modified with pausable transfers.
497  **/
498 contract PausableToken is StandardToken, Pausable {
499 
500   function transfer(
501     address _to,
502     uint256 _value
503   )
504     public
505     whenNotPaused
506     returns (bool)
507   {
508     return super.transfer(_to, _value);
509   }
510 
511   function transferFrom(
512     address _from,
513     address _to,
514     uint256 _value
515   )
516     public
517     whenNotPaused
518     returns (bool)
519   {
520     return super.transferFrom(_from, _to, _value);
521   }
522 
523   function approve(
524     address _spender,
525     uint256 _value
526   )
527     public
528     whenNotPaused
529     returns (bool)
530   {
531     return super.approve(_spender, _value);
532   }
533 
534   function increaseApproval(
535     address _spender,
536     uint _addedValue
537   )
538     public
539     whenNotPaused
540     returns (bool success)
541   {
542     return super.increaseApproval(_spender, _addedValue);
543   }
544 
545   function decreaseApproval(
546     address _spender,
547     uint _subtractedValue
548   )
549     public
550     whenNotPaused
551     returns (bool success)
552   {
553     return super.decreaseApproval(_spender, _subtractedValue);
554   }
555 }
556 
557 //File: contracts/ico/MftToken.sol
558 /**
559  * @title MFT token
560  *
561  * @version 1.0
562  * @author Validity Labs AG <info@validitylabs.org>
563  */
564 pragma solidity 0.4.24;
565 
566 
567 
568 
569 
570 
571 contract MftToken is BurnableToken, MintableToken, PausableToken {
572     /* solhint-disable */
573     string public constant name = "MindFire Token";
574     string public constant symbol = "MFT";
575     uint8 public constant decimals = 18;
576     /* solhint-enable */
577 
578     /** 
579     * @dev `Checkpoint` is the structure that attaches a block number to a
580     * given value, the block number attached is the one that last changed the value
581     */
582     struct Checkpoint {
583         // `fromBlock` is the block number that the value was generatedsuper.mint(_to, _value); from
584         uint128 fromBlock;
585         // `value` is the amount of tokens at a specific block number
586         uint128 value;
587     }
588 
589     // Tracks the history of the `totalSupply` of the token
590     Checkpoint[] public totalSupplyHistory;
591 
592     /** 
593     * `balances` is the map that tracks the balance of each address, in this
594     * contract when the balance changes the block number that the change
595     * occurred is also included in the map
596     */
597     mapping (address => Checkpoint[]) public balances;
598 
599     /**
600      * @dev Constructor of MftToken that instantiates a new Mintable Pauseable Token
601      */
602     constructor() public {
603         paused = true;  // token should not be transferrable until after all tokens have been issued
604     }
605 
606     /**
607     * @dev allows batch minting through the mint function call
608     * @param _to address[]
609     * @param _value uint256[]
610     */
611     function batchMint(address[] _to, uint256[] _value) external {
612         require(_to.length == _value.length, "[] len !=");
613 
614         for (uint256 i; i < _to.length; i = i.add(1)) {
615             mint(_to[i], _value[i]);
616         }
617     }
618 
619     /**
620     * @dev Send `_value` tokens to `_to` from `msg.sender`
621     * @param _to The address of the recipient
622     * @param _value The amount of tokens to be transferred
623     * @return Whether the transfer was successful or not
624     */
625     function transfer(address _to, uint256 _value) public returns (bool success) {
626         require(!paused, "token is paused");
627 
628         doTransfer(msg.sender, _to, _value);
629         return true;
630     }
631 
632     /**
633     * @dev Send `_value` tokens to `_to` from `_from` on the condition it is approved by `_from`
634     * @param _from The address holding the tokens being transferred
635     * @param _to The address of the recipient
636     * @param _value The amount of tokens to be transferred
637     * @return True if the transfer was successful
638     */
639     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
640         require(!paused, "token is paused");
641 
642         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
643         doTransfer(_from, _to, _value);
644 
645         return true;
646     }
647 
648     /**
649     * @param _owner The address that's balance is being requested
650     * @return The balance of `_owner` at the current block
651     */
652     function balanceOf(address _owner) public constant returns (uint256 balance) {
653         return balanceOfAt(_owner, block.number);
654     }
655 
656     /**
657     * @dev `msg.sender` approves `_spender` to spend `_value` tokens on
658     *  its behalf. This is a modified version of the ERC20 approve function
659     *  to be a little bit safer
660     * @param _spender The address of the account able to transfer the tokens
661     * @param _value The amount of tokens to be approved for transfer
662     * @return True if the approval was successful
663     */
664     function approve(address _spender, uint256 _value) public returns (bool success) {
665         require(!paused, "token is paused");
666 
667         // To change the approve amount you first have to reduce the addresses`
668         //  allowance to zero by calling `approve(_spender,0)` if it is not
669         //  already 0 to mitigate the race condition described here:
670         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
671         require((_value == 0) || (allowed[msg.sender][_spender] == 0), "allowed not 0");
672 
673         allowed[msg.sender][_spender] = _value;
674         emit Approval(msg.sender, _spender, _value);
675         return true;
676     }
677 
678     /**
679     * @dev This function makes it easy to read the `allowed[]` map
680     * @param _owner The address of the account that owns the token
681     * @param _spender The address of the account able to transfer the tokens
682     * @return Amount of remaining tokens of _owner that _spender is allowed
683     *  to spend
684     */
685     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
686         return allowed[_owner][_spender];
687     }
688 
689     /**
690     *  @dev This function makes it easy to get the total number of tokens
691     * @return The total number of tokens
692     */
693     function totalSupply() public constant returns (uint256) {
694         return totalSupplyAt(block.number);
695     }
696 
697     /**
698     * @dev Queries the balance of `_owner` at a specific `_blockNumber`
699     * @param _owner The address from which the balance will be retrieved
700     * @param _blockNumber The block number when the balance is queried
701     * @return The balance at `_blockNumber`
702     */
703     function balanceOfAt(address _owner, uint256 _blockNumber) public constant returns (uint256) {
704 
705         // These next few lines are used when the balance of the token is
706         //  requested before a check point was ever created for this token, it
707         //  requires that the `parentToken.balanceOfAt` be queried at the
708         //  genesis block for that token as this contains initial balance of
709         //  this token
710         if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
711             return 0;
712         } else {    // This will return the expected balance during normal situations
713             return getValueAt(balances[_owner], _blockNumber);
714         }
715     }
716 
717     /**
718     * @dev Total amount of tokens at a specific `_blockNumber`.
719     * @param _blockNumber The block number when the totalSupply is queried
720     * @return The total amount of tokens at `_blockNumber`
721     */
722     function totalSupplyAt(uint256 _blockNumber) public constant returns(uint256) {
723 
724         // These next few lines are used when the totalSupply of the token is
725         //  requested before a check point was ever created for this token, it
726         //  requires that the `parentToken.totalSupplyAt` be queried at the
727         //  genesis block for this token as that contains totalSupply of this
728         //  token at this block number.
729         if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
730             return 0;
731         // This will return the expected totalSupply during normal situations
732         } else {
733             return getValueAt(totalSupplyHistory, _blockNumber);
734         }
735     }
736 
737     /**
738     * @dev Generates `_value` tokens that are assigned to `_owner`
739     * @param _to The address that will be assigned the new tokens
740     * @param _value The quantity of tokens generated
741     * @return True if the tokens are generated correctly
742     */
743     function mint(address _to, uint256 _value) public hasMintPermission canMint returns (bool) {
744         uint256 curTotalSupply = totalSupply();
745         uint256 previousBalanceTo = balanceOf(_to);
746 
747         updateValueAtNow(totalSupplyHistory, curTotalSupply.add(_value));
748         updateValueAtNow(balances[_to], previousBalanceTo.add(_value));
749 
750         emit Mint(_to, _value);
751         emit Transfer(0, _to, _value);
752         return true;
753     }
754 
755     /**
756     * @dev called to burn _value of tokens by the msg.sender
757     * @param _value uint256 the amount of tokens to burn
758     */
759     function burn(uint256 _value) public {
760         uint256 curTotalSupply = totalSupply();
761         uint256 previousBalanceFrom = balanceOf(msg.sender);
762 
763         updateValueAtNow(totalSupplyHistory, curTotalSupply.sub(_value));
764         updateValueAtNow(balances[msg.sender], previousBalanceFrom.sub(_value));
765 
766         emit Burn(msg.sender, _value);
767         emit Transfer(msg.sender, 0, _value);
768     }
769 
770     /*** INTERNAL FUNCTIONS ***/
771     /**
772     * @dev This is the actual transfer function
773     * @param _from The address holding the tokens being transferred
774     * @param _to The address of the recipient
775     * @param _value The amount of tokens to be transferred
776     * @return True if the transfer was successful
777     */
778     function doTransfer(address _from, address _to, uint256 _value) internal {
779         if (_value == 0) {
780             emit Transfer(_from, _to, _value);    // Follow the spec to louch the event when transfer 0
781             return;
782         }
783 
784         // Do not allow transfer to 0x0 or the token contract itself
785         require((_to != address(0)) && (_to != address(this)), "cannot transfer to 0x0 or token contract");
786 
787         
788         uint256 previousBalanceFrom = balanceOfAt(_from, block.number);
789         // First update the balance array with the new value for the address
790         //  sending the tokens
791         updateValueAtNow(balances[_from], previousBalanceFrom.sub(_value));
792 
793         // Then update the balance array with the new value for the address
794         //  receiving the tokens
795         uint256 previousBalanceTo = balanceOfAt(_to, block.number);
796         updateValueAtNow(balances[_to], previousBalanceTo.add(_value));
797 
798         // An event to make the transfer easy to find on the blockchain
799         emit Transfer(_from, _to, _value);
800     }
801 
802     /**
803     * @dev `getValueAt` retrieves the number of tokens at a given block number
804     * @param checkpoints The history of values being queried
805     * @param _block The block number to retrieve the value at
806     * @return The number of tokens being queried
807     */
808     function getValueAt(Checkpoint[] storage checkpoints, uint _block) internal view returns (uint) {
809         if (checkpoints.length == 0) return 0;
810 
811         // Shortcut for the actual value
812         if (_block >= checkpoints[checkpoints.length.sub(1)].fromBlock) {
813             return checkpoints[checkpoints.length.sub(1)].value;
814         }
815 
816         if (_block < checkpoints[0].fromBlock) {
817             return 0;
818         } 
819 
820         // Binary search of the value in the array
821         uint min = 0;
822         uint max = checkpoints.length.sub(1);
823 
824         while (max > min) {
825             uint mid = (max.add(min).add(1)).div(2);
826             if (checkpoints[mid].fromBlock <= _block) {
827                 min = mid;
828             } else {
829                 max = mid.sub(1);
830             }
831         }
832 
833         return checkpoints[min].value;
834     }
835 
836     /**
837     * @dev `updateValueAtNow` used to update the `_CheckpointBalances` map and the `_CheckpointTotalSupply`
838     * @param checkpoints The history of data being updated
839     * @param _value The new number of tokens
840     */
841     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value) internal {
842         if ((checkpoints.length == 0) || (checkpoints[checkpoints.length.sub(1)].fromBlock < block.number)) {
843             checkpoints.push(Checkpoint(uint128(block.number), uint128(_value)));
844         } else {
845             checkpoints[checkpoints.length.sub(1)].value = uint128(_value);
846         }
847     }
848 }