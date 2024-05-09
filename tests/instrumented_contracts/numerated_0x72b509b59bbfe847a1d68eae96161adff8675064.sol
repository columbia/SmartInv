1 /* file: ./node_modules/openzeppelin-solidity/contracts/token/ERC20/IERC20.sol */
2 pragma solidity ^0.4.24;
3 
4 /**
5  * @title ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/20
7  */
8 interface IERC20 {
9   function totalSupply() external view returns (uint256);
10 
11   function balanceOf(address who) external view returns (uint256);
12 
13   function allowance(address owner, address spender)
14     external view returns (uint256);
15 
16   function transfer(address to, uint256 value) external returns (bool);
17 
18   function approve(address spender, uint256 value)
19     external returns (bool);
20 
21   function transferFrom(address from, address to, uint256 value)
22     external returns (bool);
23 
24   event Transfer(
25     address indexed from,
26     address indexed to,
27     uint256 value
28   );
29 
30   event Approval(
31     address indexed owner,
32     address indexed spender,
33     uint256 value
34   );
35 }
36 
37 /* eof (./node_modules/openzeppelin-solidity/contracts/token/ERC20/IERC20.sol) */
38 /* file: ./node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol */
39 pragma solidity ^0.4.24;
40 
41 /**
42  * @title SafeMath
43  * @dev Math operations with safety checks that revert on error
44  */
45 library SafeMath {
46 
47   /**
48   * @dev Multiplies two numbers, reverts on overflow.
49   */
50   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
51     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
52     // benefit is lost if 'b' is also tested.
53     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
54     if (a == 0) {
55       return 0;
56     }
57 
58     uint256 c = a * b;
59     require(c / a == b);
60 
61     return c;
62   }
63 
64   /**
65   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
66   */
67   function div(uint256 a, uint256 b) internal pure returns (uint256) {
68     require(b > 0); // Solidity only automatically asserts when dividing by 0
69     uint256 c = a / b;
70     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
71 
72     return c;
73   }
74 
75   /**
76   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
77   */
78   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79     require(b <= a);
80     uint256 c = a - b;
81 
82     return c;
83   }
84 
85   /**
86   * @dev Adds two numbers, reverts on overflow.
87   */
88   function add(uint256 a, uint256 b) internal pure returns (uint256) {
89     uint256 c = a + b;
90     require(c >= a);
91 
92     return c;
93   }
94 
95   /**
96   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
97   * reverts when dividing by zero.
98   */
99   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
100     require(b != 0);
101     return a % b;
102   }
103 }
104 
105 /* eof (./node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol) */
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
179 /* file: ./node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol */
180 pragma solidity ^0.4.24;
181 
182 
183 /**
184  * @title ERC20Detailed token
185  * @dev The decimals are only for visualization purposes.
186  * All the operations are done using the smallest and indivisible token unit,
187  * just as on Ethereum all the operations are done in wei.
188  */
189 contract ERC20Detailed is IERC20 {
190   string private _name;
191   string private _symbol;
192   uint8 private _decimals;
193 
194   constructor(string name, string symbol, uint8 decimals) public {
195     _name = name;
196     _symbol = symbol;
197     _decimals = decimals;
198   }
199 
200   /**
201    * @return the name of the token.
202    */
203   function name() public view returns(string) {
204     return _name;
205   }
206 
207   /**
208    * @return the symbol of the token.
209    */
210   function symbol() public view returns(string) {
211     return _symbol;
212   }
213 
214   /**
215    * @return the number of decimals of the token.
216    */
217   function decimals() public view returns(uint8) {
218     return _decimals;
219   }
220 }
221 
222 /* eof (./node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol) */
223 /* file: ./node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol */
224 pragma solidity ^0.4.24;
225 
226 
227 /**
228  * @title Standard ERC20 token
229  *
230  * @dev Implementation of the basic standard token.
231  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
232  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
233  */
234 contract ERC20 is IERC20 {
235   using SafeMath for uint256;
236 
237   mapping (address => uint256) private _balances;
238 
239   mapping (address => mapping (address => uint256)) private _allowed;
240 
241   uint256 private _totalSupply;
242 
243   /**
244   * @dev Total number of tokens in existence
245   */
246   function totalSupply() public view returns (uint256) {
247     return _totalSupply;
248   }
249 
250   /**
251   * @dev Gets the balance of the specified address.
252   * @param owner The address to query the balance of.
253   * @return An uint256 representing the amount owned by the passed address.
254   */
255   function balanceOf(address owner) public view returns (uint256) {
256     return _balances[owner];
257   }
258 
259   /**
260    * @dev Function to check the amount of tokens that an owner allowed to a spender.
261    * @param owner address The address which owns the funds.
262    * @param spender address The address which will spend the funds.
263    * @return A uint256 specifying the amount of tokens still available for the spender.
264    */
265   function allowance(
266     address owner,
267     address spender
268    )
269     public
270     view
271     returns (uint256)
272   {
273     return _allowed[owner][spender];
274   }
275 
276   /**
277   * @dev Transfer token for a specified address
278   * @param to The address to transfer to.
279   * @param value The amount to be transferred.
280   */
281   function transfer(address to, uint256 value) public returns (bool) {
282     _transfer(msg.sender, to, value);
283     return true;
284   }
285 
286   /**
287    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
288    * Beware that changing an allowance with this method brings the risk that someone may use both the old
289    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
290    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
291    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
292    * @param spender The address which will spend the funds.
293    * @param value The amount of tokens to be spent.
294    */
295   function approve(address spender, uint256 value) public returns (bool) {
296     require(spender != address(0));
297 
298     _allowed[msg.sender][spender] = value;
299     emit Approval(msg.sender, spender, value);
300     return true;
301   }
302 
303   /**
304    * @dev Transfer tokens from one address to another
305    * @param from address The address which you want to send tokens from
306    * @param to address The address which you want to transfer to
307    * @param value uint256 the amount of tokens to be transferred
308    */
309   function transferFrom(
310     address from,
311     address to,
312     uint256 value
313   )
314     public
315     returns (bool)
316   {
317     require(value <= _allowed[from][msg.sender]);
318 
319     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
320     _transfer(from, to, value);
321     return true;
322   }
323 
324   /**
325    * @dev Increase the amount of tokens that an owner allowed to a spender.
326    * approve should be called when allowed_[_spender] == 0. To increment
327    * allowed value is better to use this function to avoid 2 calls (and wait until
328    * the first transaction is mined)
329    * From MonolithDAO Token.sol
330    * @param spender The address which will spend the funds.
331    * @param addedValue The amount of tokens to increase the allowance by.
332    */
333   function increaseAllowance(
334     address spender,
335     uint256 addedValue
336   )
337     public
338     returns (bool)
339   {
340     require(spender != address(0));
341 
342     _allowed[msg.sender][spender] = (
343       _allowed[msg.sender][spender].add(addedValue));
344     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
345     return true;
346   }
347 
348   /**
349    * @dev Decrease the amount of tokens that an owner allowed to a spender.
350    * approve should be called when allowed_[_spender] == 0. To decrement
351    * allowed value is better to use this function to avoid 2 calls (and wait until
352    * the first transaction is mined)
353    * From MonolithDAO Token.sol
354    * @param spender The address which will spend the funds.
355    * @param subtractedValue The amount of tokens to decrease the allowance by.
356    */
357   function decreaseAllowance(
358     address spender,
359     uint256 subtractedValue
360   )
361     public
362     returns (bool)
363   {
364     require(spender != address(0));
365 
366     _allowed[msg.sender][spender] = (
367       _allowed[msg.sender][spender].sub(subtractedValue));
368     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
369     return true;
370   }
371 
372   /**
373   * @dev Transfer token for a specified addresses
374   * @param from The address to transfer from.
375   * @param to The address to transfer to.
376   * @param value The amount to be transferred.
377   */
378   function _transfer(address from, address to, uint256 value) internal {
379     require(value <= _balances[from]);
380     require(to != address(0));
381 
382     _balances[from] = _balances[from].sub(value);
383     _balances[to] = _balances[to].add(value);
384     emit Transfer(from, to, value);
385   }
386 
387   /**
388    * @dev Internal function that mints an amount of the token and assigns it to
389    * an account. This encapsulates the modification of balances such that the
390    * proper events are emitted.
391    * @param account The account that will receive the created tokens.
392    * @param value The amount that will be created.
393    */
394   function _mint(address account, uint256 value) internal {
395     require(account != 0);
396     _totalSupply = _totalSupply.add(value);
397     _balances[account] = _balances[account].add(value);
398     emit Transfer(address(0), account, value);
399   }
400 
401   /**
402    * @dev Internal function that burns an amount of the token of a given
403    * account.
404    * @param account The account whose tokens will be burnt.
405    * @param value The amount that will be burnt.
406    */
407   function _burn(address account, uint256 value) internal {
408     require(account != 0);
409     require(value <= _balances[account]);
410 
411     _totalSupply = _totalSupply.sub(value);
412     _balances[account] = _balances[account].sub(value);
413     emit Transfer(account, address(0), value);
414   }
415 
416   /**
417    * @dev Internal function that burns an amount of the token of a given
418    * account, deducting from the sender's allowance for said account. Uses the
419    * internal burn function.
420    * @param account The account whose tokens will be burnt.
421    * @param value The amount that will be burnt.
422    */
423   function _burnFrom(address account, uint256 value) internal {
424     require(value <= _allowed[account][msg.sender]);
425 
426     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
427     // this function needs to emit an event with the updated approval.
428     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
429       value);
430     _burn(account, value);
431   }
432 }
433 
434 /* eof (./node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol) */
435 /* file: ./node_modules/openzeppelin-solidity/contracts/access/Roles.sol */
436 pragma solidity ^0.4.24;
437 
438 /**
439  * @title Roles
440  * @dev Library for managing addresses assigned to a Role.
441  */
442 library Roles {
443   struct Role {
444     mapping (address => bool) bearer;
445   }
446 
447   /**
448    * @dev give an account access to this role
449    */
450   function add(Role storage role, address account) internal {
451     require(account != address(0));
452     require(!has(role, account));
453 
454     role.bearer[account] = true;
455   }
456 
457   /**
458    * @dev remove an account's access to this role
459    */
460   function remove(Role storage role, address account) internal {
461     require(account != address(0));
462     require(has(role, account));
463 
464     role.bearer[account] = false;
465   }
466 
467   /**
468    * @dev check if an account has this role
469    * @return bool
470    */
471   function has(Role storage role, address account)
472     internal
473     view
474     returns (bool)
475   {
476     require(account != address(0));
477     return role.bearer[account];
478   }
479 }
480 
481 /* eof (./node_modules/openzeppelin-solidity/contracts/access/Roles.sol) */
482 /* file: ./node_modules/openzeppelin-solidity/contracts/access/roles/PauserRole.sol */
483 pragma solidity ^0.4.24;
484 
485 
486 contract PauserRole {
487   using Roles for Roles.Role;
488 
489   event PauserAdded(address indexed account);
490   event PauserRemoved(address indexed account);
491 
492   Roles.Role private pausers;
493 
494   constructor() internal {
495     _addPauser(msg.sender);
496   }
497 
498   modifier onlyPauser() {
499     require(isPauser(msg.sender));
500     _;
501   }
502 
503   function isPauser(address account) public view returns (bool) {
504     return pausers.has(account);
505   }
506 
507   function addPauser(address account) public onlyPauser {
508     _addPauser(account);
509   }
510 
511   function renouncePauser() public {
512     _removePauser(msg.sender);
513   }
514 
515   function _addPauser(address account) internal {
516     pausers.add(account);
517     emit PauserAdded(account);
518   }
519 
520   function _removePauser(address account) internal {
521     pausers.remove(account);
522     emit PauserRemoved(account);
523   }
524 }
525 
526 /* eof (./node_modules/openzeppelin-solidity/contracts/access/roles/PauserRole.sol) */
527 /* file: ./node_modules/openzeppelin-solidity/contracts/lifecycle/Pausable.sol */
528 pragma solidity ^0.4.24;
529 
530 
531 /**
532  * @title Pausable
533  * @dev Base contract which allows children to implement an emergency stop mechanism.
534  */
535 contract Pausable is PauserRole {
536   event Paused(address account);
537   event Unpaused(address account);
538 
539   bool private _paused;
540 
541   constructor() internal {
542     _paused = false;
543   }
544 
545   /**
546    * @return true if the contract is paused, false otherwise.
547    */
548   function paused() public view returns(bool) {
549     return _paused;
550   }
551 
552   /**
553    * @dev Modifier to make a function callable only when the contract is not paused.
554    */
555   modifier whenNotPaused() {
556     require(!_paused);
557     _;
558   }
559 
560   /**
561    * @dev Modifier to make a function callable only when the contract is paused.
562    */
563   modifier whenPaused() {
564     require(_paused);
565     _;
566   }
567 
568   /**
569    * @dev called by the owner to pause, triggers stopped state
570    */
571   function pause() public onlyPauser whenNotPaused {
572     _paused = true;
573     emit Paused(msg.sender);
574   }
575 
576   /**
577    * @dev called by the owner to unpause, returns to normal state
578    */
579   function unpause() public onlyPauser whenPaused {
580     _paused = false;
581     emit Unpaused(msg.sender);
582   }
583 }
584 
585 /* eof (./node_modules/openzeppelin-solidity/contracts/lifecycle/Pausable.sol) */
586 /* file: ./node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol */
587 pragma solidity ^0.4.24;
588 
589 
590 /**
591  * @title Pausable token
592  * @dev ERC20 modified with pausable transfers.
593  **/
594 contract ERC20Pausable is ERC20, Pausable {
595 
596   function transfer(
597     address to,
598     uint256 value
599   )
600     public
601     whenNotPaused
602     returns (bool)
603   {
604     return super.transfer(to, value);
605   }
606 
607   function transferFrom(
608     address from,
609     address to,
610     uint256 value
611   )
612     public
613     whenNotPaused
614     returns (bool)
615   {
616     return super.transferFrom(from, to, value);
617   }
618 
619   function approve(
620     address spender,
621     uint256 value
622   )
623     public
624     whenNotPaused
625     returns (bool)
626   {
627     return super.approve(spender, value);
628   }
629 
630   function increaseAllowance(
631     address spender,
632     uint addedValue
633   )
634     public
635     whenNotPaused
636     returns (bool success)
637   {
638     return super.increaseAllowance(spender, addedValue);
639   }
640 
641   function decreaseAllowance(
642     address spender,
643     uint subtractedValue
644   )
645     public
646     whenNotPaused
647     returns (bool success)
648   {
649     return super.decreaseAllowance(spender, subtractedValue);
650   }
651 }
652 
653 /* eof (./node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol) */
654 /* file: ./node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol */
655 pragma solidity ^0.4.24;
656 
657 
658 /**
659  * @title Burnable Token
660  * @dev Token that can be irreversibly burned (destroyed).
661  */
662 contract ERC20Burnable is ERC20 {
663 
664   /**
665    * @dev Burns a specific amount of tokens.
666    * @param value The amount of token to be burned.
667    */
668   function burn(uint256 value) public {
669     _burn(msg.sender, value);
670   }
671 
672   /**
673    * @dev Burns a specific amount of tokens from the target address and decrements allowance
674    * @param from address The address which you want to send tokens from
675    * @param value uint256 The amount of token to be burned
676    */
677   function burnFrom(address from, uint256 value) public {
678     _burnFrom(from, value);
679   }
680 }
681 
682 /* eof (./node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol) */
683 /* file: ./node_modules/openzeppelin-solidity/contracts/access/roles/MinterRole.sol */
684 pragma solidity ^0.4.24;
685 
686 
687 contract MinterRole {
688   using Roles for Roles.Role;
689 
690   event MinterAdded(address indexed account);
691   event MinterRemoved(address indexed account);
692 
693   Roles.Role private minters;
694 
695   constructor() internal {
696     _addMinter(msg.sender);
697   }
698 
699   modifier onlyMinter() {
700     require(isMinter(msg.sender));
701     _;
702   }
703 
704   function isMinter(address account) public view returns (bool) {
705     return minters.has(account);
706   }
707 
708   function addMinter(address account) public onlyMinter {
709     _addMinter(account);
710   }
711 
712   function renounceMinter() public {
713     _removeMinter(msg.sender);
714   }
715 
716   function _addMinter(address account) internal {
717     minters.add(account);
718     emit MinterAdded(account);
719   }
720 
721   function _removeMinter(address account) internal {
722     minters.remove(account);
723     emit MinterRemoved(account);
724   }
725 }
726 
727 /* eof (./node_modules/openzeppelin-solidity/contracts/access/roles/MinterRole.sol) */
728 /* file: ./node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol */
729 pragma solidity ^0.4.24;
730 
731 
732 /**
733  * @title ERC20Mintable
734  * @dev ERC20 minting logic
735  */
736 contract ERC20Mintable is ERC20, MinterRole {
737   /**
738    * @dev Function to mint tokens
739    * @param to The address that will receive the minted tokens.
740    * @param value The amount of tokens to mint.
741    * @return A boolean that indicates if the operation was successful.
742    */
743   function mint(
744     address to,
745     uint256 value
746   )
747     public
748     onlyMinter
749     returns (bool)
750   {
751     _mint(to, value);
752     return true;
753   }
754 }
755 
756 /* eof (./node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol) */
757 /* file: ./node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Capped.sol */
758 pragma solidity ^0.4.24;
759 
760 
761 /**
762  * @title Capped token
763  * @dev Mintable token with a token cap.
764  */
765 contract ERC20Capped is ERC20Mintable {
766 
767   uint256 private _cap;
768 
769   constructor(uint256 cap)
770     public
771   {
772     require(cap > 0);
773     _cap = cap;
774   }
775 
776   /**
777    * @return the cap for the token minting.
778    */
779   function cap() public view returns(uint256) {
780     return _cap;
781   }
782 
783   function _mint(address account, uint256 value) internal {
784     require(totalSupply().add(value) <= _cap);
785     super._mint(account, value);
786   }
787 }
788 
789 /* eof (./node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Capped.sol) */
790 /* file: ./node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol */
791 pragma solidity ^0.4.24;
792 
793 /**
794  * @title Ownable
795  * @dev The Ownable contract has an owner address, and provides basic authorization control
796  * functions, this simplifies the implementation of "user permissions".
797  */
798 contract Ownable {
799   address private _owner;
800 
801   event OwnershipTransferred(
802     address indexed previousOwner,
803     address indexed newOwner
804   );
805 
806   /**
807    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
808    * account.
809    */
810   constructor() internal {
811     _owner = msg.sender;
812     emit OwnershipTransferred(address(0), _owner);
813   }
814 
815   /**
816    * @return the address of the owner.
817    */
818   function owner() public view returns(address) {
819     return _owner;
820   }
821 
822   /**
823    * @dev Throws if called by any account other than the owner.
824    */
825   modifier onlyOwner() {
826     require(isOwner());
827     _;
828   }
829 
830   /**
831    * @return true if `msg.sender` is the owner of the contract.
832    */
833   function isOwner() public view returns(bool) {
834     return msg.sender == _owner;
835   }
836 
837   /**
838    * @dev Allows the current owner to relinquish control of the contract.
839    * @notice Renouncing to ownership will leave the contract without an owner.
840    * It will not be possible to call the functions with the `onlyOwner`
841    * modifier anymore.
842    */
843   function renounceOwnership() public onlyOwner {
844     emit OwnershipTransferred(_owner, address(0));
845     _owner = address(0);
846   }
847 
848   /**
849    * @dev Allows the current owner to transfer control of the contract to a newOwner.
850    * @param newOwner The address to transfer ownership to.
851    */
852   function transferOwnership(address newOwner) public onlyOwner {
853     _transferOwnership(newOwner);
854   }
855 
856   /**
857    * @dev Transfers control of the contract to a newOwner.
858    * @param newOwner The address to transfer ownership to.
859    */
860   function _transferOwnership(address newOwner) internal {
861     require(newOwner != address(0));
862     emit OwnershipTransferred(_owner, newOwner);
863     _owner = newOwner;
864   }
865 }
866 
867 /* eof (./node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol) */
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