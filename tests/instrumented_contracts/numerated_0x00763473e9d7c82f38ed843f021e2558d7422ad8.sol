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
115 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
116 
117 /**
118  * @title Burnable Token
119  * @dev Token that can be irreversibly burned (destroyed).
120  */
121 contract BurnableToken is BasicToken {
122 
123   event Burn(address indexed burner, uint256 value);
124 
125   /**
126    * @dev Burns a specific amount of tokens.
127    * @param _value The amount of token to be burned.
128    */
129   function burn(uint256 _value) public {
130     _burn(msg.sender, _value);
131   }
132 
133   function _burn(address _who, uint256 _value) internal {
134     require(_value <= balances[_who]);
135     // no need to require value <= totalSupply, since that would imply the
136     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
137 
138     balances[_who] = balances[_who].sub(_value);
139     totalSupply_ = totalSupply_.sub(_value);
140     emit Burn(_who, _value);
141     emit Transfer(_who, address(0), _value);
142   }
143 }
144 
145 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
146 
147 /**
148  * @title ERC20 interface
149  * @dev see https://github.com/ethereum/EIPs/issues/20
150  */
151 contract ERC20 is ERC20Basic {
152   function allowance(address _owner, address _spender)
153     public view returns (uint256);
154 
155   function transferFrom(address _from, address _to, uint256 _value)
156     public returns (bool);
157 
158   function approve(address _spender, uint256 _value) public returns (bool);
159   event Approval(
160     address indexed owner,
161     address indexed spender,
162     uint256 value
163   );
164 }
165 
166 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
167 
168 /**
169  * @title Standard ERC20 token
170  *
171  * @dev Implementation of the basic standard token.
172  * https://github.com/ethereum/EIPs/issues/20
173  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
174  */
175 contract StandardToken is ERC20, BasicToken {
176 
177   mapping (address => mapping (address => uint256)) internal allowed;
178 
179 
180   /**
181    * @dev Transfer tokens from one address to another
182    * @param _from address The address which you want to send tokens from
183    * @param _to address The address which you want to transfer to
184    * @param _value uint256 the amount of tokens to be transferred
185    */
186   function transferFrom(
187     address _from,
188     address _to,
189     uint256 _value
190   )
191     public
192     returns (bool)
193   {
194     require(_value <= balances[_from]);
195     require(_value <= allowed[_from][msg.sender]);
196     require(_to != address(0));
197 
198     balances[_from] = balances[_from].sub(_value);
199     balances[_to] = balances[_to].add(_value);
200     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
201     emit Transfer(_from, _to, _value);
202     return true;
203   }
204 
205   /**
206    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
207    * Beware that changing an allowance with this method brings the risk that someone may use both the old
208    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
209    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
210    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
211    * @param _spender The address which will spend the funds.
212    * @param _value The amount of tokens to be spent.
213    */
214   function approve(address _spender, uint256 _value) public returns (bool) {
215     allowed[msg.sender][_spender] = _value;
216     emit Approval(msg.sender, _spender, _value);
217     return true;
218   }
219 
220   /**
221    * @dev Function to check the amount of tokens that an owner allowed to a spender.
222    * @param _owner address The address which owns the funds.
223    * @param _spender address The address which will spend the funds.
224    * @return A uint256 specifying the amount of tokens still available for the spender.
225    */
226   function allowance(
227     address _owner,
228     address _spender
229    )
230     public
231     view
232     returns (uint256)
233   {
234     return allowed[_owner][_spender];
235   }
236 
237   /**
238    * @dev Increase the amount of tokens that an owner allowed to a spender.
239    * approve should be called when allowed[_spender] == 0. To increment
240    * allowed value is better to use this function to avoid 2 calls (and wait until
241    * the first transaction is mined)
242    * From MonolithDAO Token.sol
243    * @param _spender The address which will spend the funds.
244    * @param _addedValue The amount of tokens to increase the allowance by.
245    */
246   function increaseApproval(
247     address _spender,
248     uint256 _addedValue
249   )
250     public
251     returns (bool)
252   {
253     allowed[msg.sender][_spender] = (
254       allowed[msg.sender][_spender].add(_addedValue));
255     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
256     return true;
257   }
258 
259   /**
260    * @dev Decrease the amount of tokens that an owner allowed to a spender.
261    * approve should be called when allowed[_spender] == 0. To decrement
262    * allowed value is better to use this function to avoid 2 calls (and wait until
263    * the first transaction is mined)
264    * From MonolithDAO Token.sol
265    * @param _spender The address which will spend the funds.
266    * @param _subtractedValue The amount of tokens to decrease the allowance by.
267    */
268   function decreaseApproval(
269     address _spender,
270     uint256 _subtractedValue
271   )
272     public
273     returns (bool)
274   {
275     uint256 oldValue = allowed[msg.sender][_spender];
276     if (_subtractedValue >= oldValue) {
277       allowed[msg.sender][_spender] = 0;
278     } else {
279       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
280     }
281     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
282     return true;
283   }
284 
285 }
286 
287 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
288 
289 /**
290  * @title Ownable
291  * @dev The Ownable contract has an owner address, and provides basic authorization control
292  * functions, this simplifies the implementation of "user permissions".
293  */
294 contract Ownable {
295   address public owner;
296 
297 
298   event OwnershipRenounced(address indexed previousOwner);
299   event OwnershipTransferred(
300     address indexed previousOwner,
301     address indexed newOwner
302   );
303 
304 
305   /**
306    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
307    * account.
308    */
309   constructor() public {
310     owner = msg.sender;
311   }
312 
313   /**
314    * @dev Throws if called by any account other than the owner.
315    */
316   modifier onlyOwner() {
317     require(msg.sender == owner);
318     _;
319   }
320 
321   /**
322    * @dev Allows the current owner to relinquish control of the contract.
323    * @notice Renouncing to ownership will leave the contract without an owner.
324    * It will not be possible to call the functions with the `onlyOwner`
325    * modifier anymore.
326    */
327   function renounceOwnership() public onlyOwner {
328     emit OwnershipRenounced(owner);
329     owner = address(0);
330   }
331 
332   /**
333    * @dev Allows the current owner to transfer control of the contract to a newOwner.
334    * @param _newOwner The address to transfer ownership to.
335    */
336   function transferOwnership(address _newOwner) public onlyOwner {
337     _transferOwnership(_newOwner);
338   }
339 
340   /**
341    * @dev Transfers control of the contract to a newOwner.
342    * @param _newOwner The address to transfer ownership to.
343    */
344   function _transferOwnership(address _newOwner) internal {
345     require(_newOwner != address(0));
346     emit OwnershipTransferred(owner, _newOwner);
347     owner = _newOwner;
348   }
349 }
350 
351 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
352 
353 /**
354  * @title Pausable
355  * @dev Base contract which allows children to implement an emergency stop mechanism.
356  */
357 contract Pausable is Ownable {
358   event Pause();
359   event Unpause();
360 
361   bool public paused = false;
362 
363 
364   /**
365    * @dev Modifier to make a function callable only when the contract is not paused.
366    */
367   modifier whenNotPaused() {
368     require(!paused);
369     _;
370   }
371 
372   /**
373    * @dev Modifier to make a function callable only when the contract is paused.
374    */
375   modifier whenPaused() {
376     require(paused);
377     _;
378   }
379 
380   /**
381    * @dev called by the owner to pause, triggers stopped state
382    */
383   function pause() public onlyOwner whenNotPaused {
384     paused = true;
385     emit Pause();
386   }
387 
388   /**
389    * @dev called by the owner to unpause, returns to normal state
390    */
391   function unpause() public onlyOwner whenPaused {
392     paused = false;
393     emit Unpause();
394   }
395 }
396 
397 // File: openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol
398 
399 /**
400  * @title Pausable token
401  * @dev StandardToken modified with pausable transfers.
402  **/
403 contract PausableToken is StandardToken, Pausable {
404 
405   function transfer(
406     address _to,
407     uint256 _value
408   )
409     public
410     whenNotPaused
411     returns (bool)
412   {
413     return super.transfer(_to, _value);
414   }
415 
416   function transferFrom(
417     address _from,
418     address _to,
419     uint256 _value
420   )
421     public
422     whenNotPaused
423     returns (bool)
424   {
425     return super.transferFrom(_from, _to, _value);
426   }
427 
428   function approve(
429     address _spender,
430     uint256 _value
431   )
432     public
433     whenNotPaused
434     returns (bool)
435   {
436     return super.approve(_spender, _value);
437   }
438 
439   function increaseApproval(
440     address _spender,
441     uint _addedValue
442   )
443     public
444     whenNotPaused
445     returns (bool success)
446   {
447     return super.increaseApproval(_spender, _addedValue);
448   }
449 
450   function decreaseApproval(
451     address _spender,
452     uint _subtractedValue
453   )
454     public
455     whenNotPaused
456     returns (bool success)
457   {
458     return super.decreaseApproval(_spender, _subtractedValue);
459   }
460 }
461 
462 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
463 
464 /**
465  * @title Mintable token
466  * @dev Simple ERC20 Token example, with mintable token creation
467  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
468  */
469 contract MintableToken is StandardToken, Ownable {
470   event Mint(address indexed to, uint256 amount);
471   event MintFinished();
472 
473   bool public mintingFinished = false;
474 
475 
476   modifier canMint() {
477     require(!mintingFinished);
478     _;
479   }
480 
481   modifier hasMintPermission() {
482     require(msg.sender == owner);
483     _;
484   }
485 
486   /**
487    * @dev Function to mint tokens
488    * @param _to The address that will receive the minted tokens.
489    * @param _amount The amount of tokens to mint.
490    * @return A boolean that indicates if the operation was successful.
491    */
492   function mint(
493     address _to,
494     uint256 _amount
495   )
496     public
497     hasMintPermission
498     canMint
499     returns (bool)
500   {
501     totalSupply_ = totalSupply_.add(_amount);
502     balances[_to] = balances[_to].add(_amount);
503     emit Mint(_to, _amount);
504     emit Transfer(address(0), _to, _amount);
505     return true;
506   }
507 
508   /**
509    * @dev Function to stop minting new tokens.
510    * @return True if the operation was successful.
511    */
512   function finishMinting() public onlyOwner canMint returns (bool) {
513     mintingFinished = true;
514     emit MintFinished();
515     return true;
516   }
517 }
518 
519 // File: openzeppelin-solidity/contracts/token/ERC20/CappedToken.sol
520 
521 /**
522  * @title Capped token
523  * @dev Mintable token with a token cap.
524  */
525 contract CappedToken is MintableToken {
526 
527   uint256 public cap;
528 
529   constructor(uint256 _cap) public {
530     require(_cap > 0);
531     cap = _cap;
532   }
533 
534   /**
535    * @dev Function to mint tokens
536    * @param _to The address that will receive the minted tokens.
537    * @param _amount The amount of tokens to mint.
538    * @return A boolean that indicates if the operation was successful.
539    */
540   function mint(
541     address _to,
542     uint256 _amount
543   )
544     public
545     returns (bool)
546   {
547     require(totalSupply_.add(_amount) <= cap);
548 
549     return super.mint(_to, _amount);
550   }
551 
552 }
553 
554 // File: contracts/SmartToken.sol
555 
556 interface IERC223Receiver {
557   function tokenFallback(address _from, uint256 _value, bytes _data) external;
558 }
559 
560 
561 /// @title Smart token implementation compatible with ERC20, ERC223, Mintable, Burnable and Pausable tokens
562 /// @author Aler Denisov <aler.zampillo@gmail.com>
563 contract SmartToken is BurnableToken, CappedToken, PausableToken {
564   constructor(uint256 _cap) public CappedToken(_cap) {}
565 
566   event Transfer(address indexed from, address indexed to, uint256 value, bytes data);
567 
568   function transferFrom(
569     address _from,
570     address _to,
571     uint256 _value
572   ) public returns (bool) 
573   {
574     bytes memory empty;
575     return transferFrom(
576       _from, 
577       _to, 
578       _value, 
579       empty
580     );
581   }
582 
583   function transferFrom(
584     address _from,
585     address _to,
586     uint256 _value,
587     bytes _data
588   ) public returns (bool)
589   {
590     require(_value <= allowed[_from][msg.sender], "Used didn't allow sender to interact with balance");
591     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
592     if (isContract(_to)) {
593       return transferToContract(
594         _from, 
595         _to, 
596         _value, 
597         _data
598       ); 
599     } else {
600       return transferToAddress(
601         _from, 
602         _to, 
603         _value, 
604         _data
605       );
606     }
607   }
608 
609   function transfer(address _to, uint256 _value, bytes _data) public returns (bool success) {
610     if (isContract(_to)) {
611       return transferToContract(
612         msg.sender,
613         _to,
614         _value,
615         _data
616       );
617     } else {
618       return transferToAddress(
619         msg.sender,
620         _to,
621         _value,
622         _data
623       );
624     }
625   }
626 
627   function transfer(address _to, uint256 _value) public returns (bool success) {
628     bytes memory empty;
629     return transfer(_to, _value, empty);
630   }
631 
632   function isContract(address _addr) internal view returns (bool) {
633     uint256 length;
634     // solium-disable-next-line security/no-inline-assembly
635     assembly {
636       //retrieve the size of the code on target address, this needs assembly
637       length := extcodesize(_addr)
638     } 
639     return (length>0);
640   }
641 
642   function moveTokens(address _from, address _to, uint256 _value) internal returns (bool success) {
643     require(balanceOf(_from) >= _value, "Balance isn't enough");
644     balances[_from] = balanceOf(_from).sub(_value);
645     balances[_to] = balanceOf(_to).add(_value);
646 
647     return true;
648   }
649 
650   function transferToAddress(
651     address _from,
652     address _to,
653     uint256 _value,
654     bytes _data
655   ) internal returns (bool success) 
656   {
657     require(moveTokens(_from, _to, _value), "Tokens movement was failed");
658     emit Transfer(_from, _to, _value);
659     emit Transfer(
660       _from,
661       _to,
662       _value,
663       _data
664     );
665     return true;
666   }
667   
668   //function that is called when transaction target is a contract
669   function transferToContract(
670     address _from,
671     address _to,
672     uint256 _value,
673     bytes _data
674   ) internal returns (bool success) 
675   {
676     require(moveTokens(_from, _to, _value), "Tokens movement was failed");
677     IERC223Receiver(_to).tokenFallback(_from, _value, _data);
678     emit Transfer(_from, _to, _value);
679     emit Transfer(
680       _from,
681       _to,
682       _value,
683       _data
684     );
685     return true;
686   }
687 }
688 
689 // File: contracts/SmartMultichainToken.sol
690 
691 contract SmartMultichainToken is SmartToken {
692   event BlockchainExchange(
693     address indexed from, 
694     uint256 value, 
695     uint256 indexed newNetwork, 
696     bytes32 adr
697   );
698 
699   constructor(uint256 _cap) public SmartToken(_cap) {}
700   /// @dev Function to burn tokens and rise event for burn tokens in another network
701   /// @param _amount The amount of tokens that will burn
702   /// @param _network The index of target network.
703   /// @param _adr The address in new network
704   function blockchainExchange(
705     uint256 _amount, 
706     uint256 _network, 
707     bytes32 _adr
708   ) public 
709   {
710     burn(_amount);
711     cap.sub(_amount);
712     emit BlockchainExchange(
713       msg.sender, 
714       _amount, 
715       _network, 
716       _adr
717     );
718   }
719 
720   /// @dev Function to burn allowed tokens from special address and rise event for burn tokens in another network
721   /// @param _from The address of holder
722   /// @param _amount The amount of tokens that will burn
723   /// @param _network The index of target network.
724   /// @param _adr The address in new network
725   function blockchainExchangeFrom(
726     address _from,
727     uint256 _amount, 
728     uint256 _network, 
729     bytes32 _adr
730   ) public 
731   {
732     require(_amount <= allowed[_from][msg.sender], "Used didn't allow sender to interact with balance");
733     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
734     _burn(_from, _amount);
735     emit BlockchainExchange(
736       msg.sender, 
737       _amount, 
738       _network,
739       _adr
740     );
741   }
742 }
743 
744 // File: contracts/Blacklist.sol
745 
746 contract Blacklist is BurnableToken, Ownable {
747   mapping (address => bool) public blacklist;
748 
749   event DestroyedBlackFunds(address _blackListedUser, uint _balance);
750   event AddedBlackList(address _user);
751   event RemovedBlackList(address _user);
752 
753   function isBlacklisted(address _maker) public view returns (bool) {
754     return blacklist[_maker];
755   }
756 
757   function addBlackList(address _evilUser) public onlyOwner {
758     blacklist[_evilUser] = true;
759     emit AddedBlackList(_evilUser);
760   }
761 
762   function removeBlackList(address _clearedUser) public onlyOwner {
763     blacklist[_clearedUser] = false;
764     emit RemovedBlackList(_clearedUser);
765   }
766 
767   function destroyBlackFunds(address _blackListedUser) public onlyOwner {
768     require(blacklist[_blackListedUser], "User isn't blacklisted");
769     uint dirtyFunds = balanceOf(_blackListedUser);
770     _burn(_blackListedUser, dirtyFunds);
771     emit DestroyedBlackFunds(_blackListedUser, dirtyFunds);
772   }
773 }
774 
775 // File: contracts/TransferTokenPolicy.sol
776 
777 contract TransferTokenPolicy is SmartToken {
778   modifier isTransferAllowed(address _from, address _to, uint256 _value) {
779     require(_allowTransfer(_from, _to, _value), "Transfer isn't allowed");
780     _;
781   }
782 
783   function transferFrom(
784     address _from,
785     address _to,
786     uint256 _value
787   ) public isTransferAllowed(_from, _to, _value) returns (bool)
788   {
789     return super.transferFrom(_from, _to, _value);
790   }
791 
792   function transferFrom(
793     address _from,
794     address _to,
795     uint256 _value,
796     bytes _data
797   ) public isTransferAllowed(_from, _to, _value) returns (bool)
798   {
799     return super.transferFrom(
800       _from,
801       _to,
802       _value,
803       _data
804     );
805   }
806 
807   function transfer(address _to, uint256 _value, bytes _data) public isTransferAllowed(msg.sender, _to, _value) returns (bool success) {
808     return super.transfer(_to, _value, _data);
809   }
810 
811   function transfer(address _to, uint256 _value) public isTransferAllowed(msg.sender, _to, _value) returns (bool success) {
812     return super.transfer(_to, _value);
813   }
814 
815   function burn(uint256 _amount) public isTransferAllowed(msg.sender, address(0x0), _amount) {
816     super.burn(_amount);
817   }
818 
819   function _allowTransfer(address, address, uint256) internal returns(bool);
820 }
821 
822 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
823 
824 /**
825  * @title DetailedERC20 token
826  * @dev The decimals are only for visualization purposes.
827  * All the operations are done using the smallest and indivisible token unit,
828  * just as on Ethereum all the operations are done in wei.
829  */
830 contract DetailedERC20 is ERC20 {
831   string public name;
832   string public symbol;
833   uint8 public decimals;
834 
835   constructor(string _name, string _symbol, uint8 _decimals) public {
836     name = _name;
837     symbol = _symbol;
838     decimals = _decimals;
839   }
840 }
841 
842 // File: contracts/DucatToken.sol
843 
844 contract DucatToken is TransferTokenPolicy, SmartMultichainToken, Blacklist, DetailedERC20 {
845   uint256 private precision = 4; 
846   constructor() public
847     DetailedERC20(
848       "Ducat",
849       "DUCAT",
850       uint8(precision)
851     )
852     SmartMultichainToken(
853       7 * 10 ** (9 + precision) // 7 billion with decimals
854     ) {
855   }
856 
857   function _allowTransfer(address _from, address _to, uint256) internal returns(bool) {
858     return !isBlacklisted(_from) && !isBlacklisted(_to);
859   }
860 }