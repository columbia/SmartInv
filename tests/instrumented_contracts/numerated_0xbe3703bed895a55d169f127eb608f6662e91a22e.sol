1 /* file: ./node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol */
2 pragma solidity ^0.4.24;
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that revert on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, reverts on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (a == 0) {
18       return 0;
19     }
20 
21     uint256 c = a * b;
22     require(c / a == b);
23 
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     require(b > 0); // Solidity only automatically asserts when dividing by 0
32     uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34 
35     return c;
36   }
37 
38   /**
39   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42     require(b <= a);
43     uint256 c = a - b;
44 
45     return c;
46   }
47 
48   /**
49   * @dev Adds two numbers, reverts on overflow.
50   */
51   function add(uint256 a, uint256 b) internal pure returns (uint256) {
52     uint256 c = a + b;
53     require(c >= a);
54 
55     return c;
56   }
57 
58   /**
59   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
60   * reverts when dividing by zero.
61   */
62   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63     require(b != 0);
64     return a % b;
65   }
66 }
67 
68 /* eof (./node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol) */
69 /* file: ./node_modules/openzeppelin-solidity/contracts/token/ERC20/IERC20.sol */
70 pragma solidity ^0.4.24;
71 
72 /**
73  * @title ERC20 interface
74  * @dev see https://github.com/ethereum/EIPs/issues/20
75  */
76 interface IERC20 {
77   function totalSupply() external view returns (uint256);
78 
79   function balanceOf(address who) external view returns (uint256);
80 
81   function allowance(address owner, address spender)
82     external view returns (uint256);
83 
84   function transfer(address to, uint256 value) external returns (bool);
85 
86   function approve(address spender, uint256 value)
87     external returns (bool);
88 
89   function transferFrom(address from, address to, uint256 value)
90     external returns (bool);
91 
92   event Transfer(
93     address indexed from,
94     address indexed to,
95     uint256 value
96   );
97 
98   event Approval(
99     address indexed owner,
100     address indexed spender,
101     uint256 value
102   );
103 }
104 
105 /* eof (./node_modules/openzeppelin-solidity/contracts/token/ERC20/IERC20.sol) */
106 /* file: ./node_modules/openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol */
107 pragma solidity ^0.4.24;
108 
109 
110 /**
111  * @title SafeERC20
112  * @dev Wrappers around ERC20 operations that throw on failure.
113  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
114  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
115  */
116 library SafeERC20 {
117 
118   using SafeMath for uint256;
119 
120   function safeTransfer(
121     IERC20 token,
122     address to,
123     uint256 value
124   )
125     internal
126   {
127     require(token.transfer(to, value));
128   }
129 
130   function safeTransferFrom(
131     IERC20 token,
132     address from,
133     address to,
134     uint256 value
135   )
136     internal
137   {
138     require(token.transferFrom(from, to, value));
139   }
140 
141   function safeApprove(
142     IERC20 token,
143     address spender,
144     uint256 value
145   )
146     internal
147   {
148     // safeApprove should only be called when setting an initial allowance, 
149     // or when resetting it to zero. To increase and decrease it, use 
150     // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
151     require((value == 0) || (token.allowance(msg.sender, spender) == 0));
152     require(token.approve(spender, value));
153   }
154 
155   function safeIncreaseAllowance(
156     IERC20 token,
157     address spender,
158     uint256 value
159   )
160     internal
161   {
162     uint256 newAllowance = token.allowance(address(this), spender).add(value);
163     require(token.approve(spender, newAllowance));
164   }
165 
166   function safeDecreaseAllowance(
167     IERC20 token,
168     address spender,
169     uint256 value
170   )
171     internal
172   {
173     uint256 newAllowance = token.allowance(address(this), spender).sub(value);
174     require(token.approve(spender, newAllowance));
175   }
176 }
177 
178 /* eof (./node_modules/openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol) */
179 /* file: ./node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol */
180 pragma solidity ^0.4.24;
181 
182 /**
183  * @title Ownable
184  * @dev The Ownable contract has an owner address, and provides basic authorization control
185  * functions, this simplifies the implementation of "user permissions".
186  */
187 contract Ownable {
188   address private _owner;
189 
190   event OwnershipTransferred(
191     address indexed previousOwner,
192     address indexed newOwner
193   );
194 
195   /**
196    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
197    * account.
198    */
199   constructor() internal {
200     _owner = msg.sender;
201     emit OwnershipTransferred(address(0), _owner);
202   }
203 
204   /**
205    * @return the address of the owner.
206    */
207   function owner() public view returns(address) {
208     return _owner;
209   }
210 
211   /**
212    * @dev Throws if called by any account other than the owner.
213    */
214   modifier onlyOwner() {
215     require(isOwner());
216     _;
217   }
218 
219   /**
220    * @return true if `msg.sender` is the owner of the contract.
221    */
222   function isOwner() public view returns(bool) {
223     return msg.sender == _owner;
224   }
225 
226   /**
227    * @dev Allows the current owner to relinquish control of the contract.
228    * @notice Renouncing to ownership will leave the contract without an owner.
229    * It will not be possible to call the functions with the `onlyOwner`
230    * modifier anymore.
231    */
232   function renounceOwnership() public onlyOwner {
233     emit OwnershipTransferred(_owner, address(0));
234     _owner = address(0);
235   }
236 
237   /**
238    * @dev Allows the current owner to transfer control of the contract to a newOwner.
239    * @param newOwner The address to transfer ownership to.
240    */
241   function transferOwnership(address newOwner) public onlyOwner {
242     _transferOwnership(newOwner);
243   }
244 
245   /**
246    * @dev Transfers control of the contract to a newOwner.
247    * @param newOwner The address to transfer ownership to.
248    */
249   function _transferOwnership(address newOwner) internal {
250     require(newOwner != address(0));
251     emit OwnershipTransferred(_owner, newOwner);
252     _owner = newOwner;
253   }
254 }
255 
256 /* eof (./node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol) */
257 /* file: ./node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol */
258 pragma solidity ^0.4.24;
259 
260 
261 /**
262  * @title ERC20Detailed token
263  * @dev The decimals are only for visualization purposes.
264  * All the operations are done using the smallest and indivisible token unit,
265  * just as on Ethereum all the operations are done in wei.
266  */
267 contract ERC20Detailed is IERC20 {
268   string private _name;
269   string private _symbol;
270   uint8 private _decimals;
271 
272   constructor(string name, string symbol, uint8 decimals) public {
273     _name = name;
274     _symbol = symbol;
275     _decimals = decimals;
276   }
277 
278   /**
279    * @return the name of the token.
280    */
281   function name() public view returns(string) {
282     return _name;
283   }
284 
285   /**
286    * @return the symbol of the token.
287    */
288   function symbol() public view returns(string) {
289     return _symbol;
290   }
291 
292   /**
293    * @return the number of decimals of the token.
294    */
295   function decimals() public view returns(uint8) {
296     return _decimals;
297   }
298 }
299 
300 /* eof (./node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol) */
301 /* file: ./node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol */
302 pragma solidity ^0.4.24;
303 
304 
305 /**
306  * @title Standard ERC20 token
307  *
308  * @dev Implementation of the basic standard token.
309  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
310  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
311  */
312 contract ERC20 is IERC20 {
313   using SafeMath for uint256;
314 
315   mapping (address => uint256) private _balances;
316 
317   mapping (address => mapping (address => uint256)) private _allowed;
318 
319   uint256 private _totalSupply;
320 
321   /**
322   * @dev Total number of tokens in existence
323   */
324   function totalSupply() public view returns (uint256) {
325     return _totalSupply;
326   }
327 
328   /**
329   * @dev Gets the balance of the specified address.
330   * @param owner The address to query the balance of.
331   * @return An uint256 representing the amount owned by the passed address.
332   */
333   function balanceOf(address owner) public view returns (uint256) {
334     return _balances[owner];
335   }
336 
337   /**
338    * @dev Function to check the amount of tokens that an owner allowed to a spender.
339    * @param owner address The address which owns the funds.
340    * @param spender address The address which will spend the funds.
341    * @return A uint256 specifying the amount of tokens still available for the spender.
342    */
343   function allowance(
344     address owner,
345     address spender
346    )
347     public
348     view
349     returns (uint256)
350   {
351     return _allowed[owner][spender];
352   }
353 
354   /**
355   * @dev Transfer token for a specified address
356   * @param to The address to transfer to.
357   * @param value The amount to be transferred.
358   */
359   function transfer(address to, uint256 value) public returns (bool) {
360     _transfer(msg.sender, to, value);
361     return true;
362   }
363 
364   /**
365    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
366    * Beware that changing an allowance with this method brings the risk that someone may use both the old
367    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
368    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
369    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
370    * @param spender The address which will spend the funds.
371    * @param value The amount of tokens to be spent.
372    */
373   function approve(address spender, uint256 value) public returns (bool) {
374     require(spender != address(0));
375 
376     _allowed[msg.sender][spender] = value;
377     emit Approval(msg.sender, spender, value);
378     return true;
379   }
380 
381   /**
382    * @dev Transfer tokens from one address to another
383    * @param from address The address which you want to send tokens from
384    * @param to address The address which you want to transfer to
385    * @param value uint256 the amount of tokens to be transferred
386    */
387   function transferFrom(
388     address from,
389     address to,
390     uint256 value
391   )
392     public
393     returns (bool)
394   {
395     require(value <= _allowed[from][msg.sender]);
396 
397     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
398     _transfer(from, to, value);
399     return true;
400   }
401 
402   /**
403    * @dev Increase the amount of tokens that an owner allowed to a spender.
404    * approve should be called when allowed_[_spender] == 0. To increment
405    * allowed value is better to use this function to avoid 2 calls (and wait until
406    * the first transaction is mined)
407    * From MonolithDAO Token.sol
408    * @param spender The address which will spend the funds.
409    * @param addedValue The amount of tokens to increase the allowance by.
410    */
411   function increaseAllowance(
412     address spender,
413     uint256 addedValue
414   )
415     public
416     returns (bool)
417   {
418     require(spender != address(0));
419 
420     _allowed[msg.sender][spender] = (
421       _allowed[msg.sender][spender].add(addedValue));
422     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
423     return true;
424   }
425 
426   /**
427    * @dev Decrease the amount of tokens that an owner allowed to a spender.
428    * approve should be called when allowed_[_spender] == 0. To decrement
429    * allowed value is better to use this function to avoid 2 calls (and wait until
430    * the first transaction is mined)
431    * From MonolithDAO Token.sol
432    * @param spender The address which will spend the funds.
433    * @param subtractedValue The amount of tokens to decrease the allowance by.
434    */
435   function decreaseAllowance(
436     address spender,
437     uint256 subtractedValue
438   )
439     public
440     returns (bool)
441   {
442     require(spender != address(0));
443 
444     _allowed[msg.sender][spender] = (
445       _allowed[msg.sender][spender].sub(subtractedValue));
446     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
447     return true;
448   }
449 
450   /**
451   * @dev Transfer token for a specified addresses
452   * @param from The address to transfer from.
453   * @param to The address to transfer to.
454   * @param value The amount to be transferred.
455   */
456   function _transfer(address from, address to, uint256 value) internal {
457     require(value <= _balances[from]);
458     require(to != address(0));
459 
460     _balances[from] = _balances[from].sub(value);
461     _balances[to] = _balances[to].add(value);
462     emit Transfer(from, to, value);
463   }
464 
465   /**
466    * @dev Internal function that mints an amount of the token and assigns it to
467    * an account. This encapsulates the modification of balances such that the
468    * proper events are emitted.
469    * @param account The account that will receive the created tokens.
470    * @param value The amount that will be created.
471    */
472   function _mint(address account, uint256 value) internal {
473     require(account != 0);
474     _totalSupply = _totalSupply.add(value);
475     _balances[account] = _balances[account].add(value);
476     emit Transfer(address(0), account, value);
477   }
478 
479   /**
480    * @dev Internal function that burns an amount of the token of a given
481    * account.
482    * @param account The account whose tokens will be burnt.
483    * @param value The amount that will be burnt.
484    */
485   function _burn(address account, uint256 value) internal {
486     require(account != 0);
487     require(value <= _balances[account]);
488 
489     _totalSupply = _totalSupply.sub(value);
490     _balances[account] = _balances[account].sub(value);
491     emit Transfer(account, address(0), value);
492   }
493 
494   /**
495    * @dev Internal function that burns an amount of the token of a given
496    * account, deducting from the sender's allowance for said account. Uses the
497    * internal burn function.
498    * @param account The account whose tokens will be burnt.
499    * @param value The amount that will be burnt.
500    */
501   function _burnFrom(address account, uint256 value) internal {
502     require(value <= _allowed[account][msg.sender]);
503 
504     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
505     // this function needs to emit an event with the updated approval.
506     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
507       value);
508     _burn(account, value);
509   }
510 }
511 
512 /* eof (./node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol) */
513 /* file: ./node_modules/openzeppelin-solidity/contracts/access/Roles.sol */
514 pragma solidity ^0.4.24;
515 
516 /**
517  * @title Roles
518  * @dev Library for managing addresses assigned to a Role.
519  */
520 library Roles {
521   struct Role {
522     mapping (address => bool) bearer;
523   }
524 
525   /**
526    * @dev give an account access to this role
527    */
528   function add(Role storage role, address account) internal {
529     require(account != address(0));
530     require(!has(role, account));
531 
532     role.bearer[account] = true;
533   }
534 
535   /**
536    * @dev remove an account's access to this role
537    */
538   function remove(Role storage role, address account) internal {
539     require(account != address(0));
540     require(has(role, account));
541 
542     role.bearer[account] = false;
543   }
544 
545   /**
546    * @dev check if an account has this role
547    * @return bool
548    */
549   function has(Role storage role, address account)
550     internal
551     view
552     returns (bool)
553   {
554     require(account != address(0));
555     return role.bearer[account];
556   }
557 }
558 
559 /* eof (./node_modules/openzeppelin-solidity/contracts/access/Roles.sol) */
560 /* file: ./node_modules/openzeppelin-solidity/contracts/access/roles/PauserRole.sol */
561 pragma solidity ^0.4.24;
562 
563 
564 contract PauserRole {
565   using Roles for Roles.Role;
566 
567   event PauserAdded(address indexed account);
568   event PauserRemoved(address indexed account);
569 
570   Roles.Role private pausers;
571 
572   constructor() internal {
573     _addPauser(msg.sender);
574   }
575 
576   modifier onlyPauser() {
577     require(isPauser(msg.sender));
578     _;
579   }
580 
581   function isPauser(address account) public view returns (bool) {
582     return pausers.has(account);
583   }
584 
585   function addPauser(address account) public onlyPauser {
586     _addPauser(account);
587   }
588 
589   function renouncePauser() public {
590     _removePauser(msg.sender);
591   }
592 
593   function _addPauser(address account) internal {
594     pausers.add(account);
595     emit PauserAdded(account);
596   }
597 
598   function _removePauser(address account) internal {
599     pausers.remove(account);
600     emit PauserRemoved(account);
601   }
602 }
603 
604 /* eof (./node_modules/openzeppelin-solidity/contracts/access/roles/PauserRole.sol) */
605 /* file: ./node_modules/openzeppelin-solidity/contracts/lifecycle/Pausable.sol */
606 pragma solidity ^0.4.24;
607 
608 
609 /**
610  * @title Pausable
611  * @dev Base contract which allows children to implement an emergency stop mechanism.
612  */
613 contract Pausable is PauserRole {
614   event Paused(address account);
615   event Unpaused(address account);
616 
617   bool private _paused;
618 
619   constructor() internal {
620     _paused = false;
621   }
622 
623   /**
624    * @return true if the contract is paused, false otherwise.
625    */
626   function paused() public view returns(bool) {
627     return _paused;
628   }
629 
630   /**
631    * @dev Modifier to make a function callable only when the contract is not paused.
632    */
633   modifier whenNotPaused() {
634     require(!_paused);
635     _;
636   }
637 
638   /**
639    * @dev Modifier to make a function callable only when the contract is paused.
640    */
641   modifier whenPaused() {
642     require(_paused);
643     _;
644   }
645 
646   /**
647    * @dev called by the owner to pause, triggers stopped state
648    */
649   function pause() public onlyPauser whenNotPaused {
650     _paused = true;
651     emit Paused(msg.sender);
652   }
653 
654   /**
655    * @dev called by the owner to unpause, returns to normal state
656    */
657   function unpause() public onlyPauser whenPaused {
658     _paused = false;
659     emit Unpaused(msg.sender);
660   }
661 }
662 
663 /* eof (./node_modules/openzeppelin-solidity/contracts/lifecycle/Pausable.sol) */
664 /* file: ./node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol */
665 pragma solidity ^0.4.24;
666 
667 
668 /**
669  * @title Pausable token
670  * @dev ERC20 modified with pausable transfers.
671  **/
672 contract ERC20Pausable is ERC20, Pausable {
673 
674   function transfer(
675     address to,
676     uint256 value
677   )
678     public
679     whenNotPaused
680     returns (bool)
681   {
682     return super.transfer(to, value);
683   }
684 
685   function transferFrom(
686     address from,
687     address to,
688     uint256 value
689   )
690     public
691     whenNotPaused
692     returns (bool)
693   {
694     return super.transferFrom(from, to, value);
695   }
696 
697   function approve(
698     address spender,
699     uint256 value
700   )
701     public
702     whenNotPaused
703     returns (bool)
704   {
705     return super.approve(spender, value);
706   }
707 
708   function increaseAllowance(
709     address spender,
710     uint addedValue
711   )
712     public
713     whenNotPaused
714     returns (bool success)
715   {
716     return super.increaseAllowance(spender, addedValue);
717   }
718 
719   function decreaseAllowance(
720     address spender,
721     uint subtractedValue
722   )
723     public
724     whenNotPaused
725     returns (bool success)
726   {
727     return super.decreaseAllowance(spender, subtractedValue);
728   }
729 }
730 
731 /* eof (./node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol) */
732 /* file: ./node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol */
733 pragma solidity ^0.4.24;
734 
735 
736 /**
737  * @title Burnable Token
738  * @dev Token that can be irreversibly burned (destroyed).
739  */
740 contract ERC20Burnable is ERC20 {
741 
742   /**
743    * @dev Burns a specific amount of tokens.
744    * @param value The amount of token to be burned.
745    */
746   function burn(uint256 value) public {
747     _burn(msg.sender, value);
748   }
749 
750   /**
751    * @dev Burns a specific amount of tokens from the target address and decrements allowance
752    * @param from address The address which you want to send tokens from
753    * @param value uint256 The amount of token to be burned
754    */
755   function burnFrom(address from, uint256 value) public {
756     _burnFrom(from, value);
757   }
758 }
759 
760 /* eof (./node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol) */
761 /* file: ./node_modules/openzeppelin-solidity/contracts/access/roles/MinterRole.sol */
762 pragma solidity ^0.4.24;
763 
764 
765 contract MinterRole {
766   using Roles for Roles.Role;
767 
768   event MinterAdded(address indexed account);
769   event MinterRemoved(address indexed account);
770 
771   Roles.Role private minters;
772 
773   constructor() internal {
774     _addMinter(msg.sender);
775   }
776 
777   modifier onlyMinter() {
778     require(isMinter(msg.sender));
779     _;
780   }
781 
782   function isMinter(address account) public view returns (bool) {
783     return minters.has(account);
784   }
785 
786   function addMinter(address account) public onlyMinter {
787     _addMinter(account);
788   }
789 
790   function renounceMinter() public {
791     _removeMinter(msg.sender);
792   }
793 
794   function _addMinter(address account) internal {
795     minters.add(account);
796     emit MinterAdded(account);
797   }
798 
799   function _removeMinter(address account) internal {
800     minters.remove(account);
801     emit MinterRemoved(account);
802   }
803 }
804 
805 /* eof (./node_modules/openzeppelin-solidity/contracts/access/roles/MinterRole.sol) */
806 /* file: ./node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol */
807 pragma solidity ^0.4.24;
808 
809 
810 /**
811  * @title ERC20Mintable
812  * @dev ERC20 minting logic
813  */
814 contract ERC20Mintable is ERC20, MinterRole {
815   /**
816    * @dev Function to mint tokens
817    * @param to The address that will receive the minted tokens.
818    * @param value The amount of tokens to mint.
819    * @return A boolean that indicates if the operation was successful.
820    */
821   function mint(
822     address to,
823     uint256 value
824   )
825     public
826     onlyMinter
827     returns (bool)
828   {
829     _mint(to, value);
830     return true;
831   }
832 }
833 
834 /* eof (./node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol) */
835 /* file: ./node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Capped.sol */
836 pragma solidity ^0.4.24;
837 
838 
839 /**
840  * @title Capped token
841  * @dev Mintable token with a token cap.
842  */
843 contract ERC20Capped is ERC20Mintable {
844 
845   uint256 private _cap;
846 
847   constructor(uint256 cap)
848     public
849   {
850     require(cap > 0);
851     _cap = cap;
852   }
853 
854   /**
855    * @return the cap for the token minting.
856    */
857   function cap() public view returns(uint256) {
858     return _cap;
859   }
860 
861   function _mint(address account, uint256 value) internal {
862     require(totalSupply().add(value) <= _cap);
863     super._mint(account, value);
864   }
865 }
866 
867 /* eof (./node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Capped.sol) */
868 /* file: ./contracts/token/SgmToken.sol */
869 pragma solidity 0.4.24;
870 
871 
872 /**
873  * @title Sgame token
874  * @author Validity Labs AG <info@validitylabs.org>
875  */
876 
877 contract SgmToken is Ownable, ERC20Detailed, ERC20Pausable, ERC20Burnable, ERC20Mintable, ERC20Capped {
878     using SafeERC20 for ERC20;
879 
880     /**
881      * @dev Constructor
882      * @param name Name of the token to be created
883      * @param symbol Symbol of the token to be created
884      * @param decimals Decimals of the token to be created
885      * @param newOwner Address which will have privileges to pause/unpause and mint the token
886      */
887     constructor(string name, string symbol, uint8 decimals, uint256 cap, address newOwner)
888         public
889         ERC20Detailed(name, symbol, decimals)
890         ERC20Capped(cap) {
891             roleSetup(newOwner);
892 
893         }
894 
895     /**
896      * @dev Reclaim all ERC20 compatible tokens accidentally sent to the SGM token contract
897      * @param recoveredToken ERC20 The address of the token contract
898      */
899     function reclaimToken(ERC20 recoveredToken) public onlyOwner {
900         uint256 balance = recoveredToken.balanceOf(address(this));
901         recoveredToken.safeTransfer(owner(), balance);
902     }
903 
904     /**
905      * @dev setup roles for new Sgame token
906      * @param newOwner address of the client owner
907      */
908     function roleSetup(address newOwner) internal {
909         addPauser(newOwner);
910         _removePauser(msg.sender);
911 
912         addMinter(newOwner);
913         _removeMinter(msg.sender);
914     }
915 }
916 /* eof (./contracts/token/SgmToken.sol) */
917 /* file: ./contracts/vesting/TokenVesting.sol */
918 pragma solidity 0.4.24;
919 
920 
921 
922 /**
923  * @title TokenVesting
924  * @dev Contract to hold tokens which will be realeased once they have vested
925  * 30% of total balance will be realeased after the start of the vesting period
926  * 70% of total balance will vest continuously until start + duration. By then all
927  * of the balance will have vested
928  * @author Validity Labs AG <info@validitylabs.org>
929  */
930 contract TokenVesting is Ownable {
931     using SafeMath for uint256;
932     using SafeERC20 for ERC20;
933 
934     uint256 private constant DECIMAL_FACTOR = 10**uint256(18);
935     uint256 private constant CLIFF_DURATION = 30 days;  // period after which the tokens will start to vest
936     uint256 private constant DURATION = 420 days;  // vesting period
937     uint256 private constant FIRST_RELEASE_PERCENTAGE = 30;  // 30% of tokens to be released after _start
938     uint256 private constant VESTING_PERCENTAGE = 70;  // 70% of tokens will vest
939     uint256 private constant D_RELEASE = 100;  // denominator to calculate the release percentage
940     uint256 private constant ALLOCATION = 160500000 * DECIMAL_FACTOR;  // SGM tokens allocated to this contract
941 
942     uint256 private _released;  // records the total of SGM tokens released
943     uint256 private _start;
944     uint256 private _cliff;
945     ERC20 private _token;
946 
947     struct Beneficiary {
948         uint256 totalBalance;  // number of tokens to vest
949         uint256 released;  // records the SGM tokens released per beneficiary
950     }
951 
952     mapping(address => Beneficiary) private beneficiaries;
953 
954     /**
955      * @dev Sets the state of the contract
956      * @param accounts Array of beneficiaries that will receive the vested tokens
957      * @param balances Array of total amount of tokens per beneficiary.
958      * @param token Address of the SGM token which will vest
959      * @param start Start time of the vesting period
960      */
961     function setState (address[] accounts, uint256[] balances, address token, uint256 start) public onlyOwner {
962         // Checks to ensure this function is called only once
963         require(_token == address(0));
964         require(accounts.length == balances.length);
965 
966         _start = start;
967         _cliff = start.add(CLIFF_DURATION);
968         _token = ERC20(token);
969 
970         uint256 totalBalance = 0;
971         uint256 length = accounts.length;
972         for (uint256 i = 0; i < length; i = i.add(1)) {
973             beneficiaries[accounts[i]] = Beneficiary(balances[i], 0);
974             totalBalance = totalBalance.add(balances[i]);
975         }
976         require(ALLOCATION == totalBalance);
977     }
978 
979     /**
980      * @return the duration of the token vesting
981      */
982     function duration() public view returns (uint256) {
983         return DURATION;
984     }
985 
986     /**
987      * @return the start time of the token vesting
988      */
989     function start() public view returns (uint256) {
990         return _start;
991     }
992 
993     /**
994      * @return the cliff time of the token vesting
995      */
996     function cliff() public view returns (uint256) {
997         return _cliff;
998     }
999 
1000     /**
1001      * @return the token address of the token vesting.
1002      */
1003     function token() public view returns (ERC20) {
1004         return _token;
1005     }
1006 
1007     /**
1008      * @dev Allows the caller to transfer vested tokens to his/her account
1009      */
1010     function release() public {
1011         releaseFor(msg.sender);
1012     }
1013 
1014     /**
1015      * @dev Allows the caller to transfer vested tokens to a beneficiary's address
1016      * @param beneficiary The address that will receive the vested unreleased tokens
1017      */
1018     function releaseFor(address beneficiary) public {
1019         uint256 unreleased = releasableAmount(beneficiary);
1020         require(unreleased > 0);
1021 
1022         _released = _released.add(unreleased);
1023         beneficiaries[beneficiary].released = beneficiaries[beneficiary].released.add(unreleased);
1024         _token.safeTransfer(beneficiary, unreleased);
1025     }
1026 
1027     /**
1028      * @dev Allows the caller to check the balance that has not been released of the input address
1029      * @param beneficiary The address whose locked balance is checked
1030      */
1031     function getBalanceFor(address beneficiary) public view returns (uint256) {
1032         return beneficiaries[beneficiary].totalBalance.sub(beneficiaries[beneficiary].released);
1033     }
1034 
1035     /**
1036      * @dev Reclaim all ERC20 compatible tokens accidentally sent to the vesting contract
1037      * @param recoveredToken ERC20 The address of the token contract
1038      */
1039     function reclaimToken(ERC20 recoveredToken) public onlyOwner {
1040         uint256 balance = recoveredToken.balanceOf(address(this));
1041         uint256 lockedBalance;
1042         uint256 recoveredBalance;
1043         // if SGM tokens are sent by mistake to this contract
1044         if (recoveredToken == _token) {
1045             lockedBalance = ALLOCATION.sub(_released);
1046         }
1047         recoveredBalance = balance.sub(lockedBalance);
1048         recoveredToken.safeTransfer(owner(), recoveredBalance);
1049     }
1050 
1051     /**
1052      * @dev Calculates the amount that has already vested but hasn't been released yet
1053      * @param beneficiary The address that will receive the unreleased tokens
1054      */
1055     function releasableAmount(address beneficiary) private view returns (uint256) {
1056         return vestedAmount(beneficiary).sub(beneficiaries[beneficiary].released);
1057     }
1058 
1059     /**
1060      * @dev Calculates the amount that has already vested.
1061      * @param beneficiary The address that will receive the vested tokens.
1062      */
1063     function vestedAmount(address beneficiary) private view returns (uint256) {
1064         uint256 vested = 0;
1065 
1066         if (block.timestamp >= _start) {
1067             // after start, release 30% of the beneficiary's totalBalance
1068             vested = beneficiaries[beneficiary].totalBalance.mul(FIRST_RELEASE_PERCENTAGE).div(D_RELEASE);
1069         }
1070         if (block.timestamp >= _cliff && block.timestamp < _start.add(DURATION)) {
1071             // after cliff, continuous vesting of the 70% leftover
1072             uint256 amountToVest = beneficiaries[beneficiary].totalBalance.mul(VESTING_PERCENTAGE).div(D_RELEASE);
1073             vested = vested.add(amountToVest.mul(block.timestamp.sub(_start)).div(DURATION));
1074         }
1075         if (block.timestamp >= _start.add(DURATION)) {
1076             vested = beneficiaries[beneficiary].totalBalance;
1077         }
1078         return vested;
1079     }
1080 }
1081 /* eof (./contracts/vesting/TokenVesting.sol) */