1 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.4.24;
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 interface IERC20 {
10   function totalSupply() external view returns (uint256);
11 
12   function balanceOf(address who) external view returns (uint256);
13 
14   function allowance(address owner, address spender)
15     external view returns (uint256);
16 
17   function transfer(address to, uint256 value) external returns (bool);
18 
19   function approve(address spender, uint256 value)
20     external returns (bool);
21 
22   function transferFrom(address from, address to, uint256 value)
23     external returns (bool);
24 
25   event Transfer(
26     address indexed from,
27     address indexed to,
28     uint256 value
29   );
30 
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
39 
40 pragma solidity ^0.4.24;
41 
42 
43 /**
44  * @title ERC20Detailed token
45  * @dev The decimals are only for visualization purposes.
46  * All the operations are done using the smallest and indivisible token unit,
47  * just as on Ethereum all the operations are done in wei.
48  */
49 contract ERC20Detailed is IERC20 {
50   string private _name;
51   string private _symbol;
52   uint8 private _decimals;
53 
54   constructor(string name, string symbol, uint8 decimals) public {
55     _name = name;
56     _symbol = symbol;
57     _decimals = decimals;
58   }
59 
60   /**
61    * @return the name of the token.
62    */
63   function name() public view returns(string) {
64     return _name;
65   }
66 
67   /**
68    * @return the symbol of the token.
69    */
70   function symbol() public view returns(string) {
71     return _symbol;
72   }
73 
74   /**
75    * @return the number of decimals of the token.
76    */
77   function decimals() public view returns(uint8) {
78     return _decimals;
79   }
80 }
81 
82 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
83 
84 pragma solidity ^0.4.24;
85 
86 /**
87  * @title SafeMath
88  * @dev Math operations with safety checks that revert on error
89  */
90 library SafeMath {
91 
92   /**
93   * @dev Multiplies two numbers, reverts on overflow.
94   */
95   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
96     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
97     // benefit is lost if 'b' is also tested.
98     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
99     if (a == 0) {
100       return 0;
101     }
102 
103     uint256 c = a * b;
104     require(c / a == b);
105 
106     return c;
107   }
108 
109   /**
110   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
111   */
112   function div(uint256 a, uint256 b) internal pure returns (uint256) {
113     require(b > 0); // Solidity only automatically asserts when dividing by 0
114     uint256 c = a / b;
115     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
116 
117     return c;
118   }
119 
120   /**
121   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
122   */
123   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
124     require(b <= a);
125     uint256 c = a - b;
126 
127     return c;
128   }
129 
130   /**
131   * @dev Adds two numbers, reverts on overflow.
132   */
133   function add(uint256 a, uint256 b) internal pure returns (uint256) {
134     uint256 c = a + b;
135     require(c >= a);
136 
137     return c;
138   }
139 
140   /**
141   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
142   * reverts when dividing by zero.
143   */
144   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
145     require(b != 0);
146     return a % b;
147   }
148 }
149 
150 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
151 
152 pragma solidity ^0.4.24;
153 
154 
155 
156 /**
157  * @title Standard ERC20 token
158  *
159  * @dev Implementation of the basic standard token.
160  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
161  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
162  */
163 contract ERC20 is IERC20 {
164   using SafeMath for uint256;
165 
166   mapping (address => uint256) private _balances;
167 
168   mapping (address => mapping (address => uint256)) private _allowed;
169 
170   uint256 private _totalSupply;
171 
172   /**
173   * @dev Total number of tokens in existence
174   */
175   function totalSupply() public view returns (uint256) {
176     return _totalSupply;
177   }
178 
179   /**
180   * @dev Gets the balance of the specified address.
181   * @param owner The address to query the balance of.
182   * @return An uint256 representing the amount owned by the passed address.
183   */
184   function balanceOf(address owner) public view returns (uint256) {
185     return _balances[owner];
186   }
187 
188   /**
189    * @dev Function to check the amount of tokens that an owner allowed to a spender.
190    * @param owner address The address which owns the funds.
191    * @param spender address The address which will spend the funds.
192    * @return A uint256 specifying the amount of tokens still available for the spender.
193    */
194   function allowance(
195     address owner,
196     address spender
197    )
198     public
199     view
200     returns (uint256)
201   {
202     return _allowed[owner][spender];
203   }
204 
205   /**
206   * @dev Transfer token for a specified address
207   * @param to The address to transfer to.
208   * @param value The amount to be transferred.
209   */
210   function transfer(address to, uint256 value) public returns (bool) {
211     _transfer(msg.sender, to, value);
212     return true;
213   }
214 
215   /**
216    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
217    * Beware that changing an allowance with this method brings the risk that someone may use both the old
218    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
219    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
220    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
221    * @param spender The address which will spend the funds.
222    * @param value The amount of tokens to be spent.
223    */
224   function approve(address spender, uint256 value) public returns (bool) {
225     require(spender != address(0));
226 
227     _allowed[msg.sender][spender] = value;
228     emit Approval(msg.sender, spender, value);
229     return true;
230   }
231 
232   /**
233    * @dev Transfer tokens from one address to another
234    * @param from address The address which you want to send tokens from
235    * @param to address The address which you want to transfer to
236    * @param value uint256 the amount of tokens to be transferred
237    */
238   function transferFrom(
239     address from,
240     address to,
241     uint256 value
242   )
243     public
244     returns (bool)
245   {
246     require(value <= _allowed[from][msg.sender]);
247 
248     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
249     _transfer(from, to, value);
250     return true;
251   }
252 
253   /**
254    * @dev Increase the amount of tokens that an owner allowed to a spender.
255    * approve should be called when allowed_[_spender] == 0. To increment
256    * allowed value is better to use this function to avoid 2 calls (and wait until
257    * the first transaction is mined)
258    * From MonolithDAO Token.sol
259    * @param spender The address which will spend the funds.
260    * @param addedValue The amount of tokens to increase the allowance by.
261    */
262   function increaseAllowance(
263     address spender,
264     uint256 addedValue
265   )
266     public
267     returns (bool)
268   {
269     require(spender != address(0));
270 
271     _allowed[msg.sender][spender] = (
272       _allowed[msg.sender][spender].add(addedValue));
273     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
274     return true;
275   }
276 
277   /**
278    * @dev Decrease the amount of tokens that an owner allowed to a spender.
279    * approve should be called when allowed_[_spender] == 0. To decrement
280    * allowed value is better to use this function to avoid 2 calls (and wait until
281    * the first transaction is mined)
282    * From MonolithDAO Token.sol
283    * @param spender The address which will spend the funds.
284    * @param subtractedValue The amount of tokens to decrease the allowance by.
285    */
286   function decreaseAllowance(
287     address spender,
288     uint256 subtractedValue
289   )
290     public
291     returns (bool)
292   {
293     require(spender != address(0));
294 
295     _allowed[msg.sender][spender] = (
296       _allowed[msg.sender][spender].sub(subtractedValue));
297     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
298     return true;
299   }
300 
301   /**
302   * @dev Transfer token for a specified addresses
303   * @param from The address to transfer from.
304   * @param to The address to transfer to.
305   * @param value The amount to be transferred.
306   */
307   function _transfer(address from, address to, uint256 value) internal {
308     require(value <= _balances[from]);
309     require(to != address(0));
310 
311     _balances[from] = _balances[from].sub(value);
312     _balances[to] = _balances[to].add(value);
313     emit Transfer(from, to, value);
314   }
315 
316   /**
317    * @dev Internal function that mints an amount of the token and assigns it to
318    * an account. This encapsulates the modification of balances such that the
319    * proper events are emitted.
320    * @param account The account that will receive the created tokens.
321    * @param value The amount that will be created.
322    */
323   function _mint(address account, uint256 value) internal {
324     require(account != 0);
325     _totalSupply = _totalSupply.add(value);
326     _balances[account] = _balances[account].add(value);
327     emit Transfer(address(0), account, value);
328   }
329 
330   /**
331    * @dev Internal function that burns an amount of the token of a given
332    * account.
333    * @param account The account whose tokens will be burnt.
334    * @param value The amount that will be burnt.
335    */
336   function _burn(address account, uint256 value) internal {
337     require(account != 0);
338     require(value <= _balances[account]);
339 
340     _totalSupply = _totalSupply.sub(value);
341     _balances[account] = _balances[account].sub(value);
342     emit Transfer(account, address(0), value);
343   }
344 
345   /**
346    * @dev Internal function that burns an amount of the token of a given
347    * account, deducting from the sender's allowance for said account. Uses the
348    * internal burn function.
349    * @param account The account whose tokens will be burnt.
350    * @param value The amount that will be burnt.
351    */
352   function _burnFrom(address account, uint256 value) internal {
353     require(value <= _allowed[account][msg.sender]);
354 
355     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
356     // this function needs to emit an event with the updated approval.
357     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
358       value);
359     _burn(account, value);
360   }
361 }
362 
363 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
364 
365 pragma solidity ^0.4.24;
366 
367 
368 /**
369  * @title Burnable Token
370  * @dev Token that can be irreversibly burned (destroyed).
371  */
372 contract ERC20Burnable is ERC20 {
373 
374   /**
375    * @dev Burns a specific amount of tokens.
376    * @param value The amount of token to be burned.
377    */
378   function burn(uint256 value) public {
379     _burn(msg.sender, value);
380   }
381 
382   /**
383    * @dev Burns a specific amount of tokens from the target address and decrements allowance
384    * @param from address The address which you want to send tokens from
385    * @param value uint256 The amount of token to be burned
386    */
387   function burnFrom(address from, uint256 value) public {
388     _burnFrom(from, value);
389   }
390 }
391 
392 // File: contracts/interfaces/ERC677/ERC677.sol
393 
394 pragma solidity 0.4.25;
395 
396 
397 
398 contract ERC677 is ERC20 {
399     event Transfer(
400         address indexed from,
401         address indexed to,
402         uint value,
403         bytes data
404     );
405 
406     function transferAndCall(address, uint, bytes) external returns (bool);
407 }
408 
409 // File: contracts/interfaces/ERC677/IBurnableMintableERC677Token.sol
410 
411 pragma solidity 0.4.25;
412 
413 
414 
415 contract IBurnableMintableERC677Token is ERC677 {
416     function mint(address, uint256) public returns (bool);
417     function burn(uint256 _value) public;
418     function claimTokens(address _token, address _to) public;
419 }
420 
421 // File: contracts/interfaces/ERC677/ERC677Receiver.sol
422 
423 pragma solidity 0.4.25;
424 
425 
426 contract ERC677Receiver {
427     function onTokenTransfer(
428         address _from,
429         uint _value,
430         bytes _data
431     ) external returns(bool);
432 }
433 
434 // File: contracts/RealTradeTokenConfig.sol
435 
436 pragma solidity 0.4.25;
437 
438 
439 contract RealTradeTokenConfig {
440     string public constant NAME = "Realtrade Coin";
441     string public constant SYMBOL = "RTC";
442     uint8 public constant DECIMALS = 18;
443     uint256 public constant INITIAL_SUPPLY = 520000000 * 10 ** uint256(DECIMALS);
444 }
445 
446 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
447 
448 pragma solidity ^0.4.24;
449 
450 /**
451  * @title Ownable
452  * @dev The Ownable contract has an owner address, and provides basic authorization control
453  * functions, this simplifies the implementation of "user permissions".
454  */
455 contract Ownable {
456   address private _owner;
457 
458   event OwnershipTransferred(
459     address indexed previousOwner,
460     address indexed newOwner
461   );
462 
463   /**
464    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
465    * account.
466    */
467   constructor() internal {
468     _owner = msg.sender;
469     emit OwnershipTransferred(address(0), _owner);
470   }
471 
472   /**
473    * @return the address of the owner.
474    */
475   function owner() public view returns(address) {
476     return _owner;
477   }
478 
479   /**
480    * @dev Throws if called by any account other than the owner.
481    */
482   modifier onlyOwner() {
483     require(isOwner());
484     _;
485   }
486 
487   /**
488    * @return true if `msg.sender` is the owner of the contract.
489    */
490   function isOwner() public view returns(bool) {
491     return msg.sender == _owner;
492   }
493 
494   /**
495    * @dev Allows the current owner to relinquish control of the contract.
496    * @notice Renouncing to ownership will leave the contract without an owner.
497    * It will not be possible to call the functions with the `onlyOwner`
498    * modifier anymore.
499    */
500   function renounceOwnership() public onlyOwner {
501     emit OwnershipTransferred(_owner, address(0));
502     _owner = address(0);
503   }
504 
505   /**
506    * @dev Allows the current owner to transfer control of the contract to a newOwner.
507    * @param newOwner The address to transfer ownership to.
508    */
509   function transferOwnership(address newOwner) public onlyOwner {
510     _transferOwnership(newOwner);
511   }
512 
513   /**
514    * @dev Transfers control of the contract to a newOwner.
515    * @param newOwner The address to transfer ownership to.
516    */
517   function _transferOwnership(address newOwner) internal {
518     require(newOwner != address(0));
519     emit OwnershipTransferred(_owner, newOwner);
520     _owner = newOwner;
521   }
522 }
523 
524 // File: openzeppelin-solidity/contracts/access/Roles.sol
525 
526 pragma solidity ^0.4.24;
527 
528 /**
529  * @title Roles
530  * @dev Library for managing addresses assigned to a Role.
531  */
532 library Roles {
533   struct Role {
534     mapping (address => bool) bearer;
535   }
536 
537   /**
538    * @dev give an account access to this role
539    */
540   function add(Role storage role, address account) internal {
541     require(account != address(0));
542     require(!has(role, account));
543 
544     role.bearer[account] = true;
545   }
546 
547   /**
548    * @dev remove an account's access to this role
549    */
550   function remove(Role storage role, address account) internal {
551     require(account != address(0));
552     require(has(role, account));
553 
554     role.bearer[account] = false;
555   }
556 
557   /**
558    * @dev check if an account has this role
559    * @return bool
560    */
561   function has(Role storage role, address account)
562     internal
563     view
564     returns (bool)
565   {
566     require(account != address(0));
567     return role.bearer[account];
568   }
569 }
570 
571 // File: contracts/MinterRole.sol
572 
573 pragma solidity ^0.4.24;
574 
575 
576 
577 
578 contract MinterRole is Ownable {
579     using Roles for Roles.Role;
580 
581     event MinterAdded(address indexed account);
582     event MinterRemoved(address indexed account);
583 
584     Roles.Role private minters;
585 
586     constructor() internal {
587         addMinter(msg.sender);
588     }
589 
590     modifier onlyMinter() {
591         require(isMinter(msg.sender));
592         _;
593     }
594 
595     function isMinter(address account) public view returns (bool) {
596         return minters.has(account);
597     }
598 
599     function addMinter(address account) public onlyOwner {
600         _addMinter(account);
601     }
602 
603     function renounceMinter() public {
604         _removeMinter(msg.sender);
605     }
606 
607     function _addMinter(address account) internal {
608         minters.add(account);
609         emit MinterAdded(account);
610     }
611 
612     function _removeMinter(address account) internal {
613         minters.remove(account);
614         emit MinterRemoved(account);
615     }
616 }
617 
618 // File: contracts/ERC20Mintable.sol
619 
620 pragma solidity ^0.4.24;
621 
622 
623 
624 
625 /**
626  * @title ERC20Mintable
627  * @dev ERC20 minting logic
628  */
629 contract ERC20Mintable is ERC20, MinterRole {
630     /**
631      * @dev Function to mint tokens
632      * @param to The address that will receive the minted tokens.
633      * @param value The amount of tokens to mint.
634      * @return A boolean that indicates if the operation was successful.
635      */
636     function mint(
637         address to,
638         uint256 value
639     )
640         public
641         onlyMinter
642         returns (bool)
643     {
644         _mint(to, value);
645         return true;
646     }
647 }
648 
649 // File: contracts/RealTradeToken.sol
650 
651 pragma solidity 0.4.25;
652 
653 
654 
655 
656 
657 
658 
659 
660 
661 contract RealTradeToken is
662     IBurnableMintableERC677Token,
663     ERC20Detailed,
664     ERC20Burnable,
665     ERC20Mintable,
666     RealTradeTokenConfig {
667 
668     event ContractFallbackCallFailed(address from, address to, uint value);
669 
670     modifier validRecipient(address _recipient) {
671         require(_recipient != address(0));
672         require(_recipient != address(this));
673         _;
674     }
675 
676     constructor(address _operator)
677         public
678         ERC20Detailed(NAME, SYMBOL, DECIMALS)
679     {
680         require(_operator != address(0));
681         mint(_operator, INITIAL_SUPPLY);
682     }
683 
684     function transferAndCall(address _to, uint _value, bytes _data)
685         external
686         validRecipient(_to)
687         returns(bool)
688     {
689         require(_superTransfer(_to, _value));
690         emit Transfer(msg.sender, _to, _value, _data);
691 
692         if (_isContract(_to)) {
693             require(_contractFallback(_to, _value, _data));
694         }
695         return true;
696     }
697 
698     function transfer(address _to, uint256 _value) public returns (bool)
699     {
700         require(_superTransfer(_to, _value));
701         if (_isContract(_to) && !_contractFallback(_to, _value, new bytes(0))) {
702             emit ContractFallbackCallFailed(msg.sender, _to, _value);
703         }
704         return true;
705     }
706 
707     function claimTokens(address _token, address _to) public onlyMinter {
708         require(_token != address(0));
709         require(_to != address(0));
710 
711         IERC20 token = IERC20(_token);
712         uint256 balance = token.balanceOf(address(this));
713         require(token.transfer(_to, balance));
714     }
715 
716     function _contractFallback(address _to, uint _value, bytes _data)
717         private
718         returns(bool)
719     {
720         return _to.call(
721             abi.encodeWithSignature(
722                 "onTokenTransfer(address,uint256,bytes)",
723                 msg.sender,
724                 _value,
725                 _data
726             )
727         );
728     }
729 
730     function _isContract(address _addr)
731         private
732         view
733         returns (bool)
734     {
735         uint length;
736         assembly { length := extcodesize(_addr) }
737         return length > 0;
738     }
739 
740     function _superTransfer(address _to, uint256 _value)
741         private
742         returns(bool)
743     {
744         return super.transfer(_to, _value);
745     }
746 }