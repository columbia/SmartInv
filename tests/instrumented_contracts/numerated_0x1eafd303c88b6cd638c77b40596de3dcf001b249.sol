1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * See https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address _who) public view returns (uint256);
12   function transfer(address _to, uint256 _value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipRenounced(address indexed previousOwner);
28   event OwnershipTransferred(
29     address indexed previousOwner,
30     address indexed newOwner
31   );
32 
33 
34   /**
35    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
36    * account.
37    */
38   constructor() public {
39     owner = msg.sender;
40   }
41 
42   /**
43    * @dev Throws if called by any account other than the owner.
44    */
45   modifier onlyOwner() {
46     require(msg.sender == owner);
47     _;
48   }
49 
50   /**
51    * @dev Allows the current owner to relinquish control of the contract.
52    * @notice Renouncing to ownership will leave the contract without an owner.
53    * It will not be possible to call the functions with the `onlyOwner`
54    * modifier anymore.
55    */
56   function renounceOwnership() public onlyOwner {
57     emit OwnershipRenounced(owner);
58     owner = address(0);
59   }
60 
61   /**
62    * @dev Allows the current owner to transfer control of the contract to a newOwner.
63    * @param _newOwner The address to transfer ownership to.
64    */
65   function transferOwnership(address _newOwner) public onlyOwner {
66     _transferOwnership(_newOwner);
67   }
68 
69   /**
70    * @dev Transfers control of the contract to a newOwner.
71    * @param _newOwner The address to transfer ownership to.
72    */
73   function _transferOwnership(address _newOwner) internal {
74     require(_newOwner != address(0));
75     emit OwnershipTransferred(owner, _newOwner);
76     owner = _newOwner;
77   }
78 }
79 
80 
81 
82 
83 
84 
85 /**
86  * @title SafeERC20
87  * @dev Wrappers around ERC20 operations that throw on failure.
88  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
89  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
90  */
91 library SafeERC20 {
92   function safeTransfer(
93     ERC20Basic _token,
94     address _to,
95     uint256 _value
96   )
97     internal
98   {
99     require(_token.transfer(_to, _value));
100   }
101 
102   function safeTransferFrom(
103     ERC20 _token,
104     address _from,
105     address _to,
106     uint256 _value
107   )
108     internal
109   {
110     require(_token.transferFrom(_from, _to, _value));
111   }
112 
113   function safeApprove(
114     ERC20 _token,
115     address _spender,
116     uint256 _value
117   )
118     internal
119   {
120     require(_token.approve(_spender, _value));
121   }
122 }
123 
124 
125 library Attribute {
126   enum AttributeType {
127     ROLE_MANAGER,                   // 0
128     ROLE_OPERATOR,                  // 1
129     IS_BLACKLISTED,                 // 2
130     HAS_PASSED_KYC_AML,             // 3
131     NO_FEES,                        // 4
132     /* Additional user-defined later */
133     USER_DEFINED
134   }
135 
136   function toUint256(AttributeType _type) internal pure returns (uint256) {
137     return uint256(_type);
138   }
139 }
140 
141 
142 
143 /**
144  * @title SafeMath
145  * @dev Math operations with safety checks that throw on error
146  */
147 library SafeMath {
148 
149   /**
150   * @dev Multiplies two numbers, throws on overflow.
151   */
152   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
153     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
154     // benefit is lost if 'b' is also tested.
155     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
156     if (_a == 0) {
157       return 0;
158     }
159 
160     c = _a * _b;
161     assert(c / _a == _b);
162     return c;
163   }
164 
165   /**
166   * @dev Integer division of two numbers, truncating the quotient.
167   */
168   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
169     // assert(_b > 0); // Solidity automatically throws when dividing by 0
170     // uint256 c = _a / _b;
171     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
172     return _a / _b;
173   }
174 
175   /**
176   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
177   */
178   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
179     assert(_b <= _a);
180     return _a - _b;
181   }
182 
183   /**
184   * @dev Adds two numbers, throws on overflow.
185   */
186   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
187     c = _a + _b;
188     assert(c >= _a);
189     return c;
190   }
191 }
192 
193 
194 library BitManipulation {
195   uint256 constant internal ONE = uint256(1);
196 
197   function setBit(uint256 _num, uint256 _pos) internal pure returns (uint256) {
198     return _num | (ONE << _pos);
199   }
200 
201   function clearBit(uint256 _num, uint256 _pos) internal pure returns (uint256) {
202     return _num & ~(ONE << _pos);
203   }
204 
205   function toggleBit(uint256 _num, uint256 _pos) internal pure returns (uint256) {
206     return _num ^ (ONE << _pos);
207   }
208 
209   function checkBit(uint256 _num, uint256 _pos) internal pure returns (bool) {
210     return (_num >> _pos & ONE == ONE);
211   }
212 }
213 
214 
215 
216 
217 
218 
219 
220 
221 /**
222  * @title ERC20 interface
223  * @dev see https://github.com/ethereum/EIPs/issues/20
224  */
225 contract ERC20 is ERC20Basic {
226   function allowance(address _owner, address _spender)
227     public view returns (uint256);
228 
229   function transferFrom(address _from, address _to, uint256 _value)
230     public returns (bool);
231 
232   function approve(address _spender, uint256 _value) public returns (bool);
233   event Approval(
234     address indexed owner,
235     address indexed spender,
236     uint256 value
237   );
238 }
239 
240 
241 
242 
243 
244 
245 
246 
247 
248 
249 /**
250  * @title Claimable
251  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
252  * This allows the new owner to accept the transfer.
253  */
254 contract Claimable is Ownable {
255   address public pendingOwner;
256 
257   /**
258    * @dev Modifier throws if called by any account other than the pendingOwner.
259    */
260   modifier onlyPendingOwner() {
261     require(msg.sender == pendingOwner);
262     _;
263   }
264 
265   /**
266    * @dev Allows the current owner to set the pendingOwner address.
267    * @param newOwner The address to transfer ownership to.
268    */
269   function transferOwnership(address newOwner) public onlyOwner {
270     pendingOwner = newOwner;
271   }
272 
273   /**
274    * @dev Allows the pendingOwner address to finalize the transfer.
275    */
276   function claimOwnership() public onlyPendingOwner {
277     emit OwnershipTransferred(owner, pendingOwner);
278     owner = pendingOwner;
279     pendingOwner = address(0);
280   }
281 }
282 
283 
284 
285 /**
286  * @title Claimable Ex
287  * @dev Extension for the Claimable contract, where the ownership transfer can be canceled.
288  */
289 contract ClaimableEx is Claimable {
290   /*
291    * @dev Cancels the ownership transfer.
292    */
293   function cancelOwnershipTransfer() onlyOwner public {
294     pendingOwner = owner;
295   }
296 }
297 
298 
299 
300 
301 
302 
303 
304 
305 
306 
307 /**
308  * @title Contracts that should not own Ether
309  * @author Remco Bloemen <remco@2π.com>
310  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
311  * in the contract, it will allow the owner to reclaim this Ether.
312  * @notice Ether can still be sent to this contract by:
313  * calling functions labeled `payable`
314  * `selfdestruct(contract_address)`
315  * mining directly to the contract address
316  */
317 contract HasNoEther is Ownable {
318 
319   /**
320   * @dev Constructor that rejects incoming Ether
321   * The `payable` flag is added so we can access `msg.value` without compiler warning. If we
322   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
323   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
324   * we could use assembly to access msg.value.
325   */
326   constructor() public payable {
327     require(msg.value == 0);
328   }
329 
330   /**
331    * @dev Disallows direct send by setting a default function without the `payable` flag.
332    */
333   function() external {
334   }
335 
336   /**
337    * @dev Transfer all Ether held by the contract to the owner.
338    */
339   function reclaimEther() external onlyOwner {
340     owner.transfer(address(this).balance);
341   }
342 }
343 
344 
345 
346 
347 
348 
349 
350 
351 
352 
353 /**
354  * @title Contracts that should be able to recover tokens
355  * @author SylTi
356  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
357  * This will prevent any accidental loss of tokens.
358  */
359 contract CanReclaimToken is Ownable {
360   using SafeERC20 for ERC20Basic;
361 
362   /**
363    * @dev Reclaim all ERC20Basic compatible tokens
364    * @param _token ERC20Basic The address of the token contract
365    */
366   function reclaimToken(ERC20Basic _token) external onlyOwner {
367     uint256 balance = _token.balanceOf(this);
368     _token.safeTransfer(owner, balance);
369   }
370 
371 }
372 
373 
374 
375 /**
376  * @title Contracts that should not own Tokens
377  * @author Remco Bloemen <remco@2π.com>
378  * @dev This blocks incoming ERC223 tokens to prevent accidental loss of tokens.
379  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
380  * owner to reclaim the tokens.
381  */
382 contract HasNoTokens is CanReclaimToken {
383 
384  /**
385   * @dev Reject all ERC223 compatible tokens
386   * @param _from address The address that is transferring the tokens
387   * @param _value uint256 the amount of the specified token
388   * @param _data Bytes The data passed from the caller.
389   */
390   function tokenFallback(
391     address _from,
392     uint256 _value,
393     bytes _data
394   )
395     external
396     pure
397   {
398     _from;
399     _value;
400     _data;
401     revert();
402   }
403 
404 }
405 
406 
407 
408 
409 
410 
411 /**
412  * @title Contracts that should not own Contracts
413  * @author Remco Bloemen <remco@2π.com>
414  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
415  * of this contract to reclaim ownership of the contracts.
416  */
417 contract HasNoContracts is Ownable {
418 
419   /**
420    * @dev Reclaim ownership of Ownable contracts
421    * @param _contractAddr The address of the Ownable to be reclaimed.
422    */
423   function reclaimContract(address _contractAddr) external onlyOwner {
424     Ownable contractInst = Ownable(_contractAddr);
425     contractInst.transferOwnership(owner);
426   }
427 }
428 
429 
430 
431 /**
432  * @title Base contract for contracts that should not own things.
433  * @author Remco Bloemen <remco@2π.com>
434  * @dev Solves a class of errors where a contract accidentally becomes owner of Ether, Tokens or
435  * Owned contracts. See respective base contracts for details.
436  */
437 contract NoOwner is HasNoEther, HasNoTokens, HasNoContracts {
438 }
439 
440 
441 
442 /**
443  * @title NoOwner Ex
444  * @dev Extension for the NoOwner contract, to support a case where
445  * this contract's owner can't own ether or tokens.
446  * Note that we *do* inherit reclaimContract from NoOwner: This contract
447  * does have to own contracts, but it also has to be able to relinquish them
448  **/
449 contract NoOwnerEx is NoOwner {
450   function reclaimEther(address _to) external onlyOwner {
451     _to.transfer(address(this).balance);
452   }
453 
454   function reclaimToken(ERC20Basic token, address _to) external onlyOwner {
455     uint256 balance = token.balanceOf(this);
456     token.safeTransfer(_to, balance);
457   }
458 }
459 
460 
461 
462 
463 
464 
465 
466 
467 
468 
469 
470 /**
471  * @title Address Set.
472  * @dev This contract allows to store addresses in a set and
473  * owner can run a loop through all elements.
474  **/
475 contract AddressSet is Ownable {
476   mapping(address => bool) exist;
477   address[] elements;
478 
479   /**
480    * @dev Adds a new address to the set.
481    * @param _addr Address to add.
482    * @return True if succeed, otherwise false.
483    */
484   function add(address _addr) onlyOwner public returns (bool) {
485     if (contains(_addr)) {
486       return false;
487     }
488 
489     exist[_addr] = true;
490     elements.push(_addr);
491     return true;
492   }
493 
494   /**
495    * @dev Checks whether the set contains a specified address or not.
496    * @param _addr Address to check.
497    * @return True if the address exists in the set, otherwise false.
498    */
499   function contains(address _addr) public view returns (bool) {
500     return exist[_addr];
501   }
502 
503   /**
504    * @dev Gets an element at a specified index in the set.
505    * @param _index Index.
506    * @return A relevant address.
507    */
508   function elementAt(uint256 _index) onlyOwner public view returns (address) {
509     require(_index < elements.length);
510 
511     return elements[_index];
512   }
513 
514   /**
515    * @dev Gets the number of elements in the set.
516    * @return The number of elements.
517    */
518   function getTheNumberOfElements() onlyOwner public view returns (uint256) {
519     return elements.length;
520   }
521 }
522 
523 
524 
525 // A wrapper around the balances mapping.
526 contract BalanceSheet is ClaimableEx {
527   using SafeMath for uint256;
528 
529   mapping (address => uint256) private balances;
530 
531   AddressSet private holderSet;
532 
533   constructor() public {
534     holderSet = new AddressSet();
535   }
536 
537   /**
538   * @dev Gets the balance of the specified address.
539   * @param _owner The address to query the the balance of.
540   * @return An uint256 representing the amount owned by the passed address.
541   */
542   function balanceOf(address _owner) public view returns (uint256) {
543     return balances[_owner];
544   }
545 
546   function addBalance(address _addr, uint256 _value) public onlyOwner {
547     balances[_addr] = balances[_addr].add(_value);
548 
549     _checkHolderSet(_addr);
550   }
551 
552   function subBalance(address _addr, uint256 _value) public onlyOwner {
553     balances[_addr] = balances[_addr].sub(_value);
554   }
555 
556   function setBalance(address _addr, uint256 _value) public onlyOwner {
557     balances[_addr] = _value;
558 
559     _checkHolderSet(_addr);
560   }
561 
562   function setBalanceBatch(
563     address[] _addrs,
564     uint256[] _values
565   )
566     public
567     onlyOwner
568   {
569     uint256 _count = _addrs.length;
570     require(_count == _values.length);
571 
572     for(uint256 _i = 0; _i < _count; _i++) {
573       setBalance(_addrs[_i], _values[_i]);
574     }
575   }
576 
577   function getTheNumberOfHolders() public view returns (uint256) {
578     return holderSet.getTheNumberOfElements();
579   }
580 
581   function getHolder(uint256 _index) public view returns (address) {
582     return holderSet.elementAt(_index);
583   }
584 
585   function _checkHolderSet(address _addr) internal {
586     if (!holderSet.contains(_addr)) {
587       holderSet.add(_addr);
588     }
589   }
590 }
591 
592 
593 
594 /**
595  * @title Standard ERC20 token
596  *
597  * @dev Implementation of the basic standard token.
598  * A version of OpenZeppelin's StandardToken whose balances mapping has been replaced
599  * with a separate BalanceSheet contract. Most useful in combination with e.g.
600  * HasNoContracts because then it can relinquish its balance sheet to a new
601  * version of the token, removing the need to copy over balances.
602  **/
603 contract StandardToken is ClaimableEx, NoOwnerEx, ERC20 {
604   using SafeMath for uint256;
605 
606   uint256 totalSupply_;
607 
608   BalanceSheet private balances;
609   event BalanceSheetSet(address indexed sheet);
610 
611   mapping (address => mapping (address => uint256)) private allowed;
612 
613   constructor() public {
614     totalSupply_ = 0;
615   }
616 
617   /**
618    * @dev Total number of tokens in existence
619    */
620   function totalSupply() public view returns (uint256) {
621     return totalSupply_;
622   }
623 
624   /**
625    * @dev Gets the balance of the specified address.
626    * @param _owner The address to query the the balance of.
627    * @return An uint256 representing the amount owned by the passed address.
628    */
629   function balanceOf(address _owner) public view returns (uint256 balance) {
630     return balances.balanceOf(_owner);
631   }
632 
633   /**
634    * @dev Claim ownership of the BalanceSheet contract
635    * @param _sheet The address of the BalanceSheet to claim.
636    */
637   function setBalanceSheet(address _sheet) public onlyOwner returns (bool) {
638     balances = BalanceSheet(_sheet);
639     balances.claimOwnership();
640     emit BalanceSheetSet(_sheet);
641     return true;
642   }
643 
644   function getTheNumberOfHolders() public view returns (uint256) {
645     return balances.getTheNumberOfHolders();
646   }
647 
648   function getHolder(uint256 _index) public view returns (address) {
649     return balances.getHolder(_index);
650   }
651 
652   /**
653    * @dev Transfer token for a specified address
654    * @param _to The address to transfer to.
655    * @param _value The amount to be transferred.
656    */
657   function transfer(address _to, uint256 _value) public returns (bool) {
658     _transfer(msg.sender, _to, _value);
659     return true;
660   }
661 
662   /**
663    * @dev Transfer tokens from one address to another
664    * @param _from The address which you want to send tokens from
665    * @param _to The address which you want to transfer to
666    * @param _value The amount of tokens to be transferred
667    */
668   function transferFrom(
669     address _from,
670     address _to,
671     uint256 _value
672   )
673     public
674     returns (bool)
675   {
676     _transferFrom(_from, _to, _value, msg.sender);
677     return true;
678   }
679 
680   /**
681    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
682    *
683    * Beware that changing an allowance with this method brings the risk that someone may use both the old
684    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
685    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
686    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
687    * @param _spender The address which will spend the funds.
688    * @param _value The amount of tokens to be spent.
689    */
690   function approve(address _spender, uint256 _value) public returns (bool) {
691     _approve(_spender, _value, msg.sender);
692     return true;
693   }
694 
695   /**
696    * @dev Function to check the amount of tokens that an owner allowed to a spender.
697    * @param _owner address The address which owns the funds.
698    * @param _spender address The address which will spend the funds.
699    * @return A uint256 specifying the amount of tokens still available for the spender.
700    */
701   function allowance(
702     address _owner,
703     address _spender
704   )
705     public
706     view
707     returns (uint256)
708   {
709     return allowed[_owner][_spender];
710   }
711 
712   /**
713    * @dev Increase the amount of tokens that an owner allowed to a spender.
714    *
715    * approve should be called when allowed[_spender] == 0. To increment
716    * allowed value is better to use this function to avoid 2 calls (and wait until
717    * the first transaction is mined)
718    * @param _spender The address which will spend the funds.
719    * @param _addedValue The amount of tokens to increase the allowance by.
720    */
721   function increaseApproval(
722     address _spender,
723     uint _addedValue
724   )
725     public
726     returns (bool)
727   {
728     _increaseApproval(_spender, _addedValue, msg.sender);
729     return true;
730   }
731 
732   /**
733    * @dev Decrease the amount of tokens that an owner allowed to a spender.
734    *
735    * approve should be called when allowed[_spender] == 0. To decrement
736    * allowed value is better to use this function to avoid 2 calls (and wait until
737    * the first transaction is mined)
738    * @param _spender The address which will spend the funds.
739    * @param _subtractedValue The amount of tokens to decrease the allowance by.
740    */
741   function decreaseApproval(
742     address _spender,
743     uint _subtractedValue
744   )
745     public
746     returns (bool)
747   {
748     _decreaseApproval(_spender, _subtractedValue, msg.sender);
749     return true;
750   }
751 
752   function _approve(
753     address _spender,
754     uint256 _value,
755     address _tokenHolder
756   )
757     internal
758   {
759     allowed[_tokenHolder][_spender] = _value;
760 
761     emit Approval(_tokenHolder, _spender, _value);
762   }
763 
764   /**
765    * @dev Internal function that burns an amount of the token of a given
766    * account.
767    * @param _burner The account whose tokens will be burnt.
768    * @param _value The amount that will be burnt.
769    */
770   function _burn(address _burner, uint256 _value) internal {
771     require(_burner != 0);
772     require(_value <= balanceOf(_burner), "not enough balance to burn");
773 
774     // no need to require value <= totalSupply, since that would imply the
775     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
776     balances.subBalance(_burner, _value);
777     totalSupply_ = totalSupply_.sub(_value);
778 
779     emit Transfer(_burner, address(0), _value);
780   }
781 
782   function _decreaseApproval(
783     address _spender,
784     uint256 _subtractedValue,
785     address _tokenHolder
786   )
787     internal
788   {
789     uint256 _oldValue = allowed[_tokenHolder][_spender];
790     if (_subtractedValue >= _oldValue) {
791       allowed[_tokenHolder][_spender] = 0;
792     } else {
793       allowed[_tokenHolder][_spender] = _oldValue.sub(_subtractedValue);
794     }
795 
796     emit Approval(_tokenHolder, _spender, allowed[_tokenHolder][_spender]);
797   }
798 
799   function _increaseApproval(
800     address _spender,
801     uint256 _addedValue,
802     address _tokenHolder
803   )
804     internal
805   {
806     allowed[_tokenHolder][_spender] = (
807       allowed[_tokenHolder][_spender].add(_addedValue));
808 
809     emit Approval(_tokenHolder, _spender, allowed[_tokenHolder][_spender]);
810   }
811 
812   /**
813    * @dev Internal function that mints an amount of the token and assigns it to
814    * an account. This encapsulates the modification of balances such that the
815    * proper events are emitted.
816    * @param _account The account that will receive the created tokens.
817    * @param _amount The amount that will be created.
818    */
819   function _mint(address _account, uint256 _amount) internal {
820     require(_account != 0);
821 
822     totalSupply_ = totalSupply_.add(_amount);
823     balances.addBalance(_account, _amount);
824 
825     emit Transfer(address(0), _account, _amount);
826   }
827 
828   function _transfer(address _from, address _to, uint256 _value) internal {
829     require(_to != address(0), "to address cannot be 0x0");
830     require(_from != address(0),"from address cannot be 0x0");
831     require(_value <= balanceOf(_from), "not enough balance to transfer");
832 
833     // SafeMath.sub will throw if there is not enough balance.
834     balances.subBalance(_from, _value);
835     balances.addBalance(_to, _value);
836 
837     emit Transfer(_from, _to, _value);
838   }
839 
840   function _transferFrom(
841     address _from,
842     address _to,
843     uint256 _value,
844     address _spender
845   )
846     internal
847   {
848     uint256 _allowed = allowed[_from][_spender];
849     require(_value <= _allowed, "not enough allowance to transfer");
850 
851     allowed[_from][_spender] = allowed[_from][_spender].sub(_value);
852     _transfer(_from, _to, _value);
853   }
854 }
855 
856 
857 
858 
859 
860 /**
861  * @title Burnable Token
862  * @dev Token that can be irreversibly burned (destroyed).
863  **/
864 contract BurnableToken is StandardToken {
865   event Burn(address indexed burner, uint256 value, string note);
866 
867   /**
868    * @dev Burns a specific amount of tokens.
869    * @param _value The amount of token to be burned.
870    * @param _note a note that burner can attach.
871    */
872   function burn(uint256 _value, string _note) public returns (bool) {
873     _burn(msg.sender, _value, _note);
874 
875     return true;
876   }
877 
878   /**
879    * @dev Burns a specific amount of tokens of an user.
880    * @param _burner Who has tokens to be burned.
881    * @param _value The amount of tokens to be burned.
882    * @param _note a note that the manager can attach.
883    */
884   function _burn(
885     address _burner,
886     uint256 _value,
887     string _note
888   )
889     internal
890   {
891     _burn(_burner, _value);
892 
893     emit Burn(_burner, _value, _note);
894   }
895 }
896 
897 
898 
899 
900 
901 
902 
903 
904 
905 
906 
907 
908 
909 
910 
911 
912 
913 
914 
915 
916 // Interface for logic governing write access to a Registry.
917 contract RegistryAccessManager {
918   // Called when _admin attempts to write _value for _who's _attribute.
919   // Returns true if the write is allowed to proceed.
920   function confirmWrite(
921     address _who,
922     Attribute.AttributeType _attribute,
923     address _admin
924   )
925     public returns (bool);
926 }
927 
928 
929 
930 contract DefaultRegistryAccessManager is RegistryAccessManager {
931   function confirmWrite(
932     address /*_who*/,
933     Attribute.AttributeType _attribute,
934     address _operator
935   )
936     public
937     returns (bool)
938   {
939     Registry _client = Registry(msg.sender);
940     if (_operator == _client.owner()) {
941       return true;
942     } else if (_client.hasAttribute(_operator, Attribute.AttributeType.ROLE_MANAGER)) {
943       return (_attribute == Attribute.AttributeType.ROLE_OPERATOR);
944     } else if (_client.hasAttribute(_operator, Attribute.AttributeType.ROLE_OPERATOR)) {
945       return (_attribute != Attribute.AttributeType.ROLE_OPERATOR &&
946               _attribute != Attribute.AttributeType.ROLE_MANAGER);
947     }
948   }
949 }
950 
951 
952 
953 
954 contract Registry is ClaimableEx {
955   using BitManipulation for uint256;
956 
957   struct AttributeData {
958     uint256 value;
959   }
960 
961   // Stores arbitrary attributes for users. An example use case is an ERC20
962   // token that requires its users to go through a KYC/AML check - in this case
963   // a validator can set an account's "hasPassedKYC/AML" attribute to 1 to indicate
964   // that account can use the token. This mapping stores that value (1, in the
965   // example) as well as which validator last set the value and at what time,
966   // so that e.g. the check can be renewed at appropriate intervals.
967   mapping(address => AttributeData) private attributes;
968 
969   // The logic governing who is allowed to set what attributes is abstracted as
970   // this accessManager, so that it may be replaced by the owner as needed.
971   RegistryAccessManager public accessManager;
972 
973   event SetAttribute(
974     address indexed who,
975     Attribute.AttributeType attribute,
976     bool enable,
977     string notes,
978     address indexed adminAddr
979   );
980 
981   event SetManager(
982     address indexed oldManager,
983     address indexed newManager
984   );
985 
986   constructor() public {
987     accessManager = new DefaultRegistryAccessManager();
988   }
989 
990   // Writes are allowed only if the accessManager approves
991   function setAttribute(
992     address _who,
993     Attribute.AttributeType _attribute,
994     string _notes
995   )
996     public
997   {
998     bool _canWrite = accessManager.confirmWrite(
999       _who,
1000       _attribute,
1001       msg.sender
1002     );
1003     require(_canWrite);
1004 
1005     // Get value of previous attribute before setting new attribute
1006     uint256 _tempVal = attributes[_who].value;
1007 
1008     attributes[_who] = AttributeData(
1009       _tempVal.setBit(Attribute.toUint256(_attribute))
1010     );
1011 
1012     emit SetAttribute(_who, _attribute, true, _notes, msg.sender);
1013   }
1014 
1015   function clearAttribute(
1016     address _who,
1017     Attribute.AttributeType _attribute,
1018     string _notes
1019   )
1020     public
1021   {
1022     bool _canWrite = accessManager.confirmWrite(
1023       _who,
1024       _attribute,
1025       msg.sender
1026     );
1027     require(_canWrite);
1028 
1029     // Get value of previous attribute before setting new attribute
1030     uint256 _tempVal = attributes[_who].value;
1031 
1032     attributes[_who] = AttributeData(
1033       _tempVal.clearBit(Attribute.toUint256(_attribute))
1034     );
1035 
1036     emit SetAttribute(_who, _attribute, false, _notes, msg.sender);
1037   }
1038 
1039   // Returns true if the uint256 value stored for this attribute is non-zero
1040   function hasAttribute(
1041     address _who,
1042     Attribute.AttributeType _attribute
1043   )
1044     public
1045     view
1046     returns (bool)
1047   {
1048     return attributes[_who].value.checkBit(Attribute.toUint256(_attribute));
1049   }
1050 
1051   // Returns the exact value of the attribute, as well as its metadata
1052   function getAttributes(
1053     address _who
1054   )
1055     public
1056     view
1057     returns (uint256)
1058   {
1059     AttributeData memory _data = attributes[_who];
1060     return _data.value;
1061   }
1062 
1063   function setManager(RegistryAccessManager _accessManager) public onlyOwner {
1064     emit SetManager(accessManager, _accessManager);
1065     accessManager = _accessManager;
1066   }
1067 }
1068 
1069 
1070 
1071 // Superclass for contracts that have a registry that can be set by their owners
1072 contract HasRegistry is Ownable {
1073   Registry public registry;
1074 
1075   event SetRegistry(address indexed registry);
1076 
1077   function setRegistry(Registry _registry) public onlyOwner {
1078     registry = _registry;
1079     emit SetRegistry(registry);
1080   }
1081 }
1082 
1083 
1084 
1085 /**
1086  * @title Manageable
1087  * @dev The Manageable contract provides basic authorization control functions
1088  * for managers. This simplifies the implementation of "manager permissions".
1089  */
1090 contract Manageable is HasRegistry {
1091   /**
1092    * @dev Throws if called by any account that is not in the managers list.
1093    */
1094   modifier onlyManager() {
1095     require(
1096       registry.hasAttribute(
1097         msg.sender,
1098         Attribute.AttributeType.ROLE_MANAGER
1099       )
1100     );
1101     _;
1102   }
1103 
1104   /**
1105    * @dev Getter to determine if address is a manager
1106    */
1107   function isManager(address _operator) public view returns (bool) {
1108     return registry.hasAttribute(
1109       _operator,
1110       Attribute.AttributeType.ROLE_MANAGER
1111     );
1112   }
1113 }
1114 
1115 
1116 
1117 // Interface implemented by tokens that are the *target* of a BurnableToken's
1118 // delegation. That is, if we want to replace BurnableToken X by
1119 // Y but for convenience we'd like users of X
1120 // to be able to keep using it and it will just forward calls to Y,
1121 // then X should extend CanDelegate and Y should extend DelegateBurnable.
1122 // Most ERC20 calls use the value of msg.sender to figure out e.g. whose
1123 // balance to update; since X becomes the msg.sender of all such calls
1124 // that it forwards to Y, we add the origSender parameter to those calls.
1125 // Delegation is intended as a convenience for legacy users of X since
1126 // we do not expect all regular users to learn about Y and change accordingly,
1127 // but we do require the *owner* of X to now use Y instead so ownerOnly
1128 // functions are not delegated and should be disabled instead.
1129 // This delegation system is intended to work with the modified versions of
1130 // the standard ERC20 token contracts, allowing the balances
1131 // to be moved over to a new contract.
1132 // NOTE: To maintain backwards compatibility, these function signatures
1133 // cannot be changed
1134 contract DelegateBurnable {
1135   function delegateTotalSupply() public view returns (uint256);
1136 
1137   function delegateBalanceOf(address _who) public view returns (uint256);
1138 
1139   function delegateTransfer(address _to, uint256 _value, address _origSender)
1140     public returns (bool);
1141 
1142   function delegateAllowance(address _owner, address _spender)
1143     public view returns (uint256);
1144 
1145   function delegateTransferFrom(
1146     address _from,
1147     address _to,
1148     uint256 _value,
1149     address _origSender
1150   )
1151     public returns (bool);
1152 
1153   function delegateApprove(
1154     address _spender,
1155     uint256 _value,
1156     address _origSender
1157   )
1158     public returns (bool);
1159 
1160   function delegateIncreaseApproval(
1161     address _spender,
1162     uint256 _addedValue,
1163     address _origSender
1164   )
1165     public returns (bool);
1166 
1167   function delegateDecreaseApproval(
1168     address _spender,
1169     uint256 _subtractedValue,
1170     address _origSender
1171   )
1172     public returns (bool);
1173 
1174   function delegateBurn(
1175     address _origSender,
1176     uint256 _value,
1177     string _note
1178   )
1179     public;
1180 
1181   function delegateGetTheNumberOfHolders() public view returns (uint256);
1182 
1183   function delegateGetHolder(uint256 _index) public view returns (address);
1184 }
1185 
1186 
1187 
1188 
1189 
1190 
1191 
1192 /**
1193  * @title Contactable token
1194  * @dev Basic version of a contactable contract, allowing the owner to provide a string with their
1195  * contact information.
1196  */
1197 contract Contactable is Ownable {
1198 
1199   string public contactInformation;
1200 
1201   /**
1202     * @dev Allows the owner to set a string with their contact information.
1203     * @param _info The contact information to attach to the contract.
1204     */
1205   function setContactInformation(string _info) public onlyOwner {
1206     contactInformation = _info;
1207   }
1208 }
1209 
1210 
1211 
1212 
1213 
1214 
1215 
1216 
1217 
1218 
1219 /**
1220  * @title Pausable
1221  * @dev Base contract which allows children to implement an emergency stop mechanism.
1222  */
1223 contract Pausable is Ownable {
1224   event Pause();
1225   event Unpause();
1226 
1227   bool public paused = false;
1228 
1229 
1230   /**
1231    * @dev Modifier to make a function callable only when the contract is not paused.
1232    */
1233   modifier whenNotPaused() {
1234     require(!paused);
1235     _;
1236   }
1237 
1238   /**
1239    * @dev Modifier to make a function callable only when the contract is paused.
1240    */
1241   modifier whenPaused() {
1242     require(paused);
1243     _;
1244   }
1245 
1246   /**
1247    * @dev called by the owner to pause, triggers stopped state
1248    */
1249   function pause() public onlyOwner whenNotPaused {
1250     paused = true;
1251     emit Pause();
1252   }
1253 
1254   /**
1255    * @dev called by the owner to unpause, returns to normal state
1256    */
1257   function unpause() public onlyOwner whenPaused {
1258     paused = false;
1259     emit Unpause();
1260   }
1261 }
1262 
1263 
1264 
1265 
1266 
1267 /**
1268  * @title Pausable token
1269  * @dev StandardToken modified with pausable transfers.
1270  **/
1271 contract PausableToken is StandardToken, Pausable {
1272 
1273   function _transfer(
1274     address _from,
1275     address _to,
1276     uint256 _value
1277   )
1278     internal
1279     whenNotPaused
1280   {
1281     super._transfer(_from, _to, _value);
1282   }
1283 
1284   function _transferFrom(
1285     address _from,
1286     address _to,
1287     uint256 _value,
1288     address _spender
1289   )
1290     internal
1291     whenNotPaused
1292   {
1293     super._transferFrom(_from, _to, _value, _spender);
1294   }
1295 
1296   function _approve(
1297     address _spender,
1298     uint256 _value,
1299     address _tokenHolder
1300   )
1301     internal
1302     whenNotPaused
1303   {
1304     super._approve(_spender, _value, _tokenHolder);
1305   }
1306 
1307   function _increaseApproval(
1308     address _spender,
1309     uint256 _addedValue,
1310     address _tokenHolder
1311   )
1312     internal
1313     whenNotPaused
1314   {
1315     super._increaseApproval(_spender, _addedValue, _tokenHolder);
1316   }
1317 
1318   function _decreaseApproval(
1319     address _spender,
1320     uint256 _subtractedValue,
1321     address _tokenHolder
1322   )
1323     internal
1324     whenNotPaused
1325   {
1326     super._decreaseApproval(_spender, _subtractedValue, _tokenHolder);
1327   }
1328 
1329   function _burn(
1330     address _burner,
1331     uint256 _value
1332   )
1333     internal
1334     whenNotPaused
1335   {
1336     super._burn(_burner, _value);
1337   }
1338 }
1339 
1340 
1341 
1342 
1343 
1344 
1345 
1346 // See DelegateBurnable.sol for more on the delegation system.
1347 contract CanDelegateToken is BurnableToken {
1348   // If this contract needs to be upgraded, the new contract will be stored
1349   // in 'delegate' and any BurnableToken calls to this contract will be delegated to that one.
1350   DelegateBurnable public delegate;
1351 
1352   event DelegateToNewContract(address indexed newContract);
1353 
1354   // Can undelegate by passing in _newContract = address(0)
1355   function delegateToNewContract(
1356     DelegateBurnable _newContract
1357   )
1358     public
1359     onlyOwner
1360   {
1361     delegate = _newContract;
1362     emit DelegateToNewContract(delegate);
1363   }
1364 
1365   // If a delegate has been designated, all ERC20 calls are forwarded to it
1366   function _transfer(address _from, address _to, uint256 _value) internal {
1367     if (!_hasDelegate()) {
1368       super._transfer(_from, _to, _value);
1369     } else {
1370       require(delegate.delegateTransfer(_to, _value, _from));
1371     }
1372   }
1373 
1374   function _transferFrom(
1375     address _from,
1376     address _to,
1377     uint256 _value,
1378     address _spender
1379   )
1380     internal
1381   {
1382     if (!_hasDelegate()) {
1383       super._transferFrom(_from, _to, _value, _spender);
1384     } else {
1385       require(delegate.delegateTransferFrom(_from, _to, _value, _spender));
1386     }
1387   }
1388 
1389   function totalSupply() public view returns (uint256) {
1390     if (!_hasDelegate()) {
1391       return super.totalSupply();
1392     } else {
1393       return delegate.delegateTotalSupply();
1394     }
1395   }
1396 
1397   function balanceOf(address _who) public view returns (uint256) {
1398     if (!_hasDelegate()) {
1399       return super.balanceOf(_who);
1400     } else {
1401       return delegate.delegateBalanceOf(_who);
1402     }
1403   }
1404 
1405   function getTheNumberOfHolders() public view returns (uint256) {
1406     if (!_hasDelegate()) {
1407       return super.getTheNumberOfHolders();
1408     } else {
1409       return delegate.delegateGetTheNumberOfHolders();
1410     }
1411   }
1412 
1413   function getHolder(uint256 _index) public view returns (address) {
1414     if (!_hasDelegate()) {
1415       return super.getHolder(_index);
1416     } else {
1417       return delegate.delegateGetHolder(_index);
1418     }
1419   }
1420 
1421   function _approve(
1422     address _spender,
1423     uint256 _value,
1424     address _tokenHolder
1425   )
1426     internal
1427   {
1428     if (!_hasDelegate()) {
1429       super._approve(_spender, _value, _tokenHolder);
1430     } else {
1431       require(delegate.delegateApprove(_spender, _value, _tokenHolder));
1432     }
1433   }
1434 
1435   function allowance(
1436     address _owner,
1437     address _spender
1438   )
1439     public
1440     view
1441     returns (uint256)
1442   {
1443     if (!_hasDelegate()) {
1444       return super.allowance(_owner, _spender);
1445     } else {
1446       return delegate.delegateAllowance(_owner, _spender);
1447     }
1448   }
1449 
1450   function _increaseApproval(
1451     address _spender,
1452     uint256 _addedValue,
1453     address _tokenHolder
1454   )
1455     internal
1456   {
1457     if (!_hasDelegate()) {
1458       super._increaseApproval(_spender, _addedValue, _tokenHolder);
1459     } else {
1460       require(
1461         delegate.delegateIncreaseApproval(_spender, _addedValue, _tokenHolder)
1462       );
1463     }
1464   }
1465 
1466   function _decreaseApproval(
1467     address _spender,
1468     uint256 _subtractedValue,
1469     address _tokenHolder
1470   )
1471     internal
1472   {
1473     if (!_hasDelegate()) {
1474       super._decreaseApproval(_spender, _subtractedValue, _tokenHolder);
1475     } else {
1476       require(
1477         delegate.delegateDecreaseApproval(
1478           _spender,
1479           _subtractedValue,
1480           _tokenHolder)
1481       );
1482     }
1483   }
1484 
1485   function _burn(address _burner, uint256 _value, string _note) internal {
1486     if (!_hasDelegate()) {
1487       super._burn(_burner, _value, _note);
1488     } else {
1489       delegate.delegateBurn(_burner, _value , _note);
1490     }
1491   }
1492 
1493   function _hasDelegate() internal view returns (bool) {
1494     return !(delegate == address(0));
1495   }
1496 }
1497 
1498 
1499 
1500 
1501 
1502 
1503 
1504 // Treats all delegate functions exactly like the corresponding normal functions,
1505 // e.g. delegateTransfer is just like transfer. See DelegateBurnable.sol for more on
1506 // the delegation system.
1507 contract DelegateToken is DelegateBurnable, BurnableToken {
1508   address public delegatedFrom;
1509 
1510   event DelegatedFromSet(address addr);
1511 
1512   // Only calls from appointed address will be processed
1513   modifier onlyMandator() {
1514     require(msg.sender == delegatedFrom);
1515     _;
1516   }
1517 
1518   function setDelegatedFrom(address _addr) public onlyOwner {
1519     delegatedFrom = _addr;
1520     emit DelegatedFromSet(_addr);
1521   }
1522 
1523   // each function delegateX is simply forwarded to function X
1524   function delegateTotalSupply(
1525   )
1526     public
1527     onlyMandator
1528     view
1529     returns (uint256)
1530   {
1531     return totalSupply();
1532   }
1533 
1534   function delegateBalanceOf(
1535     address _who
1536   )
1537     public
1538     onlyMandator
1539     view
1540     returns (uint256)
1541   {
1542     return balanceOf(_who);
1543   }
1544 
1545   function delegateTransfer(
1546     address _to,
1547     uint256 _value,
1548     address _origSender
1549   )
1550     public
1551     onlyMandator
1552     returns (bool)
1553   {
1554     _transfer(_origSender, _to, _value);
1555     return true;
1556   }
1557 
1558   function delegateAllowance(
1559     address _owner,
1560     address _spender
1561   )
1562     public
1563     onlyMandator
1564     view
1565     returns (uint256)
1566   {
1567     return allowance(_owner, _spender);
1568   }
1569 
1570   function delegateTransferFrom(
1571     address _from,
1572     address _to,
1573     uint256 _value,
1574     address _origSender
1575   )
1576     public
1577     onlyMandator
1578     returns (bool)
1579   {
1580     _transferFrom(_from, _to, _value, _origSender);
1581     return true;
1582   }
1583 
1584   function delegateApprove(
1585     address _spender,
1586     uint256 _value,
1587     address _origSender
1588   )
1589     public
1590     onlyMandator
1591     returns (bool)
1592   {
1593     _approve(_spender, _value, _origSender);
1594     return true;
1595   }
1596 
1597   function delegateIncreaseApproval(
1598     address _spender,
1599     uint256 _addedValue,
1600     address _origSender
1601   )
1602     public
1603     onlyMandator
1604     returns (bool)
1605   {
1606     _increaseApproval(_spender, _addedValue, _origSender);
1607     return true;
1608   }
1609 
1610   function delegateDecreaseApproval(
1611     address _spender,
1612     uint256 _subtractedValue,
1613     address _origSender
1614   )
1615     public
1616     onlyMandator
1617     returns (bool)
1618   {
1619     _decreaseApproval(_spender, _subtractedValue, _origSender);
1620     return true;
1621   }
1622 
1623   function delegateBurn(
1624     address _origSender,
1625     uint256 _value,
1626     string _note
1627   )
1628     public
1629     onlyMandator
1630   {
1631     _burn(_origSender, _value , _note);
1632   }
1633 
1634   function delegateGetTheNumberOfHolders() public view returns (uint256) {
1635     return getTheNumberOfHolders();
1636   }
1637 
1638   function delegateGetHolder(uint256 _index) public view returns (address) {
1639     return getHolder(_index);
1640   }
1641 }
1642 
1643 
1644 
1645 
1646 
1647 
1648 /**
1649  * @title Asset information.
1650  * @dev Stores information about a specified real asset.
1651  */
1652 contract AssetInfo is Manageable {
1653   string public publicDocument;
1654 
1655   /**
1656    * Event for updated running documents logging.
1657    * @param newLink New link.
1658    */
1659   event UpdateDocument(
1660     string newLink
1661   );
1662 
1663   /**
1664    * @param _publicDocument A link to a zip file containing running documents of the asset.
1665    */
1666   constructor(string _publicDocument) public {
1667     publicDocument = _publicDocument;
1668   }
1669 
1670   /**
1671    * @dev Updates information about where to find new running documents of this asset.
1672    * @param _link A link to a zip file containing running documents of the asset.
1673    */
1674   function setPublicDocument(string _link) public onlyManager {
1675     publicDocument = _link;
1676 
1677     emit UpdateDocument(publicDocument);
1678   }
1679 }
1680 
1681 
1682 
1683 
1684 
1685 
1686 
1687 /**
1688  * @title BurnableExToken.
1689  * @dev Extension for the BurnableToken contract, to support
1690  * some manager to enforce burning all tokens of all holders.
1691  **/
1692 contract BurnableExToken is Manageable, BurnableToken {
1693 
1694   /**
1695    * @dev Burns all remaining tokens of all holders.
1696    * @param _note a note that the manager can attach.
1697    */
1698   function burnAll(string _note) external onlyManager {
1699     uint256 _holdersCount = getTheNumberOfHolders();
1700     for (uint256 _i = 0; _i < _holdersCount; ++_i) {
1701       address _holder = getHolder(_i);
1702       uint256 _balance = balanceOf(_holder);
1703       if (_balance == 0) continue;
1704 
1705       _burn(_holder, _balance, _note);
1706     }
1707   }
1708 }
1709 
1710 
1711 
1712 
1713 
1714 
1715 
1716 
1717 /**
1718  * @title Mintable token
1719  * @dev Simple ERC20 Token example, with mintable token creation
1720  **/
1721 contract MintableToken is StandardToken {
1722   event Mint(address indexed to, uint256 value);
1723   event MintFinished();
1724 
1725   bool public mintingFinished = false;
1726 
1727   modifier canMint() {
1728     require(!mintingFinished);
1729     _;
1730   }
1731 
1732   modifier hasMintPermission() {
1733     require(msg.sender == owner);
1734     _;
1735   }
1736 
1737   /**
1738    * @dev Function to mint tokens
1739    * @param _to The address that will receive the minted tokens.
1740    * @param _value The amount of tokens to mint.
1741    * @return A boolean that indicates if the operation was successful.
1742    */
1743   function mint(
1744     address _to,
1745     uint256 _value
1746   )
1747     public
1748     hasMintPermission
1749     canMint
1750     returns (bool)
1751   {
1752     _mint(_to, _value);
1753 
1754     emit Mint(_to, _value);
1755     return true;
1756   }
1757 
1758   /**
1759    * @dev Function to stop minting new tokens.
1760    * @return True if the operation was successful.
1761    */
1762   function finishMinting() public onlyOwner canMint returns (bool) {
1763     mintingFinished = true;
1764     emit MintFinished();
1765     return true;
1766   }
1767 }
1768 
1769 
1770 
1771 
1772 contract CompliantToken is HasRegistry, MintableToken {
1773   // Addresses can also be blacklisted, preventing them from sending or receiving
1774   // PAT tokens. This can be used to prevent the use of PAT by bad actors in
1775   // accordance with law enforcement.
1776 
1777   modifier onlyIfNotBlacklisted(address _addr) {
1778     require(
1779       !registry.hasAttribute(
1780         _addr,
1781         Attribute.AttributeType.IS_BLACKLISTED
1782       )
1783     );
1784     _;
1785   }
1786 
1787   modifier onlyIfBlacklisted(address _addr) {
1788     require(
1789       registry.hasAttribute(
1790         _addr,
1791         Attribute.AttributeType.IS_BLACKLISTED
1792       )
1793     );
1794     _;
1795   }
1796 
1797   modifier onlyIfPassedKYC_AML(address _addr) {
1798     require(
1799       registry.hasAttribute(
1800         _addr,
1801         Attribute.AttributeType.HAS_PASSED_KYC_AML
1802       )
1803     );
1804     _;
1805   }
1806 
1807   function _mint(
1808     address _to,
1809     uint256 _value
1810   )
1811     internal
1812     onlyIfPassedKYC_AML(_to)
1813     onlyIfNotBlacklisted(_to)
1814   {
1815     super._mint(_to, _value);
1816   }
1817 
1818   // transfer and transferFrom both call this function, so check blacklist here.
1819   function _transfer(
1820     address _from,
1821     address _to,
1822     uint256 _value
1823   )
1824     internal
1825     onlyIfNotBlacklisted(_from)
1826     onlyIfNotBlacklisted(_to)
1827     onlyIfPassedKYC_AML(_to)
1828   {
1829     super._transfer(_from, _to, _value);
1830   }
1831 }
1832 
1833 
1834 
1835 
1836 
1837 
1838 
1839 /**
1840  * @title TokenWithFees.
1841  * @dev This contract allows for transaction fees to be assessed on transfer.
1842  **/
1843 contract TokenWithFees is Manageable, StandardToken {
1844   uint8 public transferFeeNumerator = 0;
1845   uint8 public transferFeeDenominator = 100;
1846   // All transaction fees are paid to this address.
1847   address public beneficiary;
1848 
1849   event ChangeWallet(address indexed addr);
1850   event ChangeFees(uint8 transferFeeNumerator,
1851                    uint8 transferFeeDenominator);
1852 
1853   constructor(address _wallet) public {
1854     beneficiary = _wallet;
1855   }
1856 
1857   // transfer and transferFrom both call this function, so pay fee here.
1858   // E.g. if A transfers 1000 tokens to B, B will receive 999 tokens,
1859   // and the system wallet will receive 1 token.
1860   function _transfer(address _from, address _to, uint256 _value) internal {
1861     uint256 _fee = _payFee(_from, _value, _to);
1862     uint256 _remaining = _value.sub(_fee);
1863     super._transfer(_from, _to, _remaining);
1864   }
1865 
1866   function _payFee(
1867     address _payer,
1868     uint256 _value,
1869     address _otherParticipant
1870   )
1871     internal
1872     returns (uint256)
1873   {
1874     // This check allows accounts to be whitelisted and not have to pay transaction fees.
1875     bool _shouldBeFree = (
1876       registry.hasAttribute(_payer, Attribute.AttributeType.NO_FEES) ||
1877       registry.hasAttribute(_otherParticipant, Attribute.AttributeType.NO_FEES)
1878     );
1879     if (_shouldBeFree) {
1880       return 0;
1881     }
1882 
1883     uint256 _fee = _value.mul(transferFeeNumerator).div(transferFeeDenominator);
1884     if (_fee > 0) {
1885       super._transfer(_payer, beneficiary, _fee);
1886     }
1887     return _fee;
1888   }
1889 
1890   function checkTransferFee(uint256 _value) public view returns (uint256) {
1891     return _value.mul(transferFeeNumerator).div(transferFeeDenominator);
1892   }
1893 
1894   function changeFees(
1895     uint8 _transferFeeNumerator,
1896     uint8 _transferFeeDenominator
1897   )
1898     public
1899     onlyManager
1900   {
1901     require(_transferFeeNumerator < _transferFeeDenominator);
1902     transferFeeNumerator = _transferFeeNumerator;
1903     transferFeeDenominator = _transferFeeDenominator;
1904 
1905     emit ChangeFees(transferFeeNumerator, transferFeeDenominator);
1906   }
1907 
1908   /**
1909    * @dev Change address of the wallet where the fees will be sent to.
1910    * @param _beneficiary The new wallet address.
1911    */
1912   function changeWallet(address _beneficiary) public onlyManager {
1913     require(_beneficiary != address(0), "new wallet cannot be 0x0");
1914     beneficiary = _beneficiary;
1915 
1916     emit ChangeWallet(_beneficiary);
1917   }
1918 }
1919 
1920 
1921 
1922 
1923 
1924 
1925 // This allows a token to treat transfer(redeemAddress, value) as burn(value).
1926 // This is useful for users of standard wallet programs which have transfer
1927 // functionality built in but not the ability to burn.
1928 contract WithdrawalToken is BurnableToken {
1929   address public constant redeemAddress = 0xfacecafe01facecafe02facecafe03facecafe04;
1930 
1931   function _transfer(address _from, address _to, uint256 _value) internal {
1932     if (_to == redeemAddress) {
1933       burn(_value, '');
1934     } else {
1935       super._transfer(_from, _to, _value);
1936     }
1937   }
1938 
1939   // StandardToken's transferFrom doesn't have to check for _to != redeemAddress,
1940   // but we do because we redirect redeemAddress transfers to burns, but
1941   // we do not redirect transferFrom
1942   function _transferFrom(
1943     address _from,
1944     address _to,
1945     uint256 _value,
1946     address _spender
1947   ) internal {
1948     require(_to != redeemAddress, "_to is redeem address");
1949 
1950     super._transferFrom(_from, _to, _value, _spender);
1951   }
1952 }
1953 
1954 
1955 
1956 /**
1957  * @title PAT token.
1958  * @dev PAT is a ERC20 token that:
1959  *  - has no tokens limit.
1960  *  - mints new tokens for each new property (real asset).
1961  *  - can pause and unpause token transfer (and authorization) actions.
1962  *  - token holders can be distributed profit from asset manager.
1963  *  - contains real asset information.
1964  *  - can delegate to a new contract.
1965  *  - can enforce burning all tokens.
1966  *  - transferring tokens to 0x0 address is treated as burning.
1967  *  - transferring tokens with fees are sent to the system wallet.
1968  *  - attempts to check KYC/AML and Blacklist using Registry.
1969  *  - attempts to reject ERC20 token transfers to itself and allows token transfer out.
1970  *  - attempts to reject ether sent and allows any ether held to be transferred out.
1971  *  - allows the new owner to accept the ownership transfer, the owner can cancel the transfer if needed.
1972  **/
1973 contract PATToken is Contactable, AssetInfo, BurnableExToken, CanDelegateToken, DelegateToken, TokenWithFees, CompliantToken, WithdrawalToken, PausableToken {
1974   string public name = "RAX Mt.Fuji";
1975   string public symbol = "FUJI";
1976   uint8 public constant decimals = 18;
1977 
1978   event ChangeTokenName(string newName, string newSymbol);
1979 
1980   /**
1981    * @param _name Name of this token.
1982    * @param _symbol Symbol of this token.
1983    */
1984   constructor(
1985     string _name,
1986     string _symbol,
1987     string _publicDocument,
1988     address _wallet
1989   )
1990     public
1991     AssetInfo(_publicDocument)
1992     TokenWithFees(_wallet)
1993   {
1994     name = _name;
1995     symbol = _symbol;
1996     contactInformation = 'https://rax.exchange/';
1997   }
1998 
1999   function changeTokenName(string _name, string _symbol) public onlyOwner {
2000     name = _name;
2001     symbol = _symbol;
2002     emit ChangeTokenName(_name, _symbol);
2003   }
2004 
2005   /**
2006    * @dev Allows the current owner to transfer control of the contract to a new owner.
2007    * @param _newOwner The address to transfer ownership to.
2008    */
2009   function transferOwnership(address _newOwner) onlyOwner public {
2010     // do not allow self ownership
2011     require(_newOwner != address(this));
2012     super.transferOwnership(_newOwner);
2013   }
2014 }