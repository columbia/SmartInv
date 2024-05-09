1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address private _owner;
10 
11   event OwnershipTransferred(
12     address indexed previousOwner,
13     address indexed newOwner
14   );
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   constructor() internal {
21     _owner = msg.sender;
22     emit OwnershipTransferred(address(0), _owner);
23   }
24 
25   /**
26    * @return the address of the owner.
27    */
28   function owner() public view returns(address) {
29     return _owner;
30   }
31 
32   /**
33    * @dev Throws if called by any account other than the owner.
34    */
35   modifier onlyOwner() {
36     require(isOwner());
37     _;
38   }
39 
40   /**
41    * @return true if `msg.sender` is the owner of the contract.
42    */
43   function isOwner() public view returns(bool) {
44     return msg.sender == _owner;
45   }
46 
47   /**
48    * @dev Allows the current owner to relinquish control of the contract.
49    * @notice Renouncing to ownership will leave the contract without an owner.
50    * It will not be possible to call the functions with the `onlyOwner`
51    * modifier anymore.
52    */
53   function renounceOwnership() public onlyOwner {
54     emit OwnershipTransferred(_owner, address(0));
55     _owner = address(0);
56   }
57 
58   /**
59    * @dev Allows the current owner to transfer control of the contract to a newOwner.
60    * @param newOwner The address to transfer ownership to.
61    */
62   function transferOwnership(address newOwner) public onlyOwner {
63     _transferOwnership(newOwner);
64   }
65 
66   /**
67    * @dev Transfers control of the contract to a newOwner.
68    * @param newOwner The address to transfer ownership to.
69    */
70   function _transferOwnership(address newOwner) internal {
71     require(newOwner != address(0));
72     emit OwnershipTransferred(_owner, newOwner);
73     _owner = newOwner;
74   }
75 }
76 
77 /**
78  * @title ERC20 interface
79  * @dev see https://github.com/ethereum/EIPs/issues/20
80  */
81 interface IERC20 {
82   function totalSupply() external view returns (uint256);
83 
84   function balanceOf(address who) external view returns (uint256);
85 
86   function allowance(address owner, address spender)
87     external view returns (uint256);
88 
89   function transfer(address to, uint256 value) external returns (bool);
90 
91   function approve(address spender, uint256 value)
92     external returns (bool);
93 
94   function transferFrom(address from, address to, uint256 value)
95     external returns (bool);
96 
97   event Transfer(
98     address indexed from,
99     address indexed to,
100     uint256 value
101   );
102 
103   event Approval(
104     address indexed owner,
105     address indexed spender,
106     uint256 value
107   );
108 }
109 
110 /**
111  * @title ERC20Detailed token
112  * @dev The decimals are only for visualization purposes.
113  * All the operations are done using the smallest and indivisible token unit,
114  * just as on Ethereum all the operations are done in wei.
115  */
116 contract ERC20Detailed is IERC20 {
117   string private _name;
118   string private _symbol;
119   uint8 private _decimals;
120 
121   constructor(string name, string symbol, uint8 decimals) public {
122     _name = name;
123     _symbol = symbol;
124     _decimals = decimals;
125   }
126 
127   /**
128    * @return the name of the token.
129    */
130   function name() public view returns(string) {
131     return _name;
132   }
133 
134   /**
135    * @return the symbol of the token.
136    */
137   function symbol() public view returns(string) {
138     return _symbol;
139   }
140 
141   /**
142    * @return the number of decimals of the token.
143    */
144   function decimals() public view returns(uint8) {
145     return _decimals;
146   }
147 }
148 
149 /**
150  * @title SafeMath
151  * @dev Math operations with safety checks that revert on error
152  */
153 library SafeMath {
154 
155   /**
156   * @dev Multiplies two numbers, reverts on overflow.
157   */
158   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
159     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
160     // benefit is lost if 'b' is also tested.
161     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
162     if (a == 0) {
163       return 0;
164     }
165 
166     uint256 c = a * b;
167     require(c / a == b);
168 
169     return c;
170   }
171 
172   /**
173   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
174   */
175   function div(uint256 a, uint256 b) internal pure returns (uint256) {
176     require(b > 0); // Solidity only automatically asserts when dividing by 0
177     uint256 c = a / b;
178     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
179 
180     return c;
181   }
182 
183   /**
184   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
185   */
186   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
187     require(b <= a);
188     uint256 c = a - b;
189 
190     return c;
191   }
192 
193   /**
194   * @dev Adds two numbers, reverts on overflow.
195   */
196   function add(uint256 a, uint256 b) internal pure returns (uint256) {
197     uint256 c = a + b;
198     require(c >= a);
199 
200     return c;
201   }
202 
203   /**
204   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
205   * reverts when dividing by zero.
206   */
207   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
208     require(b != 0);
209     return a % b;
210   }
211 }
212 
213 /**
214  * @title Standard ERC20 token
215  *
216  * @dev Implementation of the basic standard token.
217  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
218  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
219  */
220 contract ERC20 is IERC20 {
221   using SafeMath for uint256;
222 
223   mapping (address => uint256) private _balances;
224 
225   mapping (address => mapping (address => uint256)) private _allowed;
226 
227   uint256 private _totalSupply;
228 
229   /**
230   * @dev Total number of tokens in existence
231   */
232   function totalSupply() public view returns (uint256) {
233     return _totalSupply;
234   }
235 
236   /**
237   * @dev Gets the balance of the specified address.
238   * @param owner The address to query the balance of.
239   * @return An uint256 representing the amount owned by the passed address.
240   */
241   function balanceOf(address owner) public view returns (uint256) {
242     return _balances[owner];
243   }
244 
245   /**
246    * @dev Function to check the amount of tokens that an owner allowed to a spender.
247    * @param owner address The address which owns the funds.
248    * @param spender address The address which will spend the funds.
249    * @return A uint256 specifying the amount of tokens still available for the spender.
250    */
251   function allowance(
252     address owner,
253     address spender
254    )
255     public
256     view
257     returns (uint256)
258   {
259     return _allowed[owner][spender];
260   }
261 
262   /**
263   * @dev Transfer token for a specified address
264   * @param to The address to transfer to.
265   * @param value The amount to be transferred.
266   */
267   function transfer(address to, uint256 value) public returns (bool) {
268     _transfer(msg.sender, to, value);
269     return true;
270   }
271 
272   /**
273    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
274    * Beware that changing an allowance with this method brings the risk that someone may use both the old
275    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
276    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
277    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
278    * @param spender The address which will spend the funds.
279    * @param value The amount of tokens to be spent.
280    */
281   function approve(address spender, uint256 value) public returns (bool) {
282     require(spender != address(0));
283 
284     _allowed[msg.sender][spender] = value;
285     emit Approval(msg.sender, spender, value);
286     return true;
287   }
288 
289   /**
290    * @dev Transfer tokens from one address to another
291    * @param from address The address which you want to send tokens from
292    * @param to address The address which you want to transfer to
293    * @param value uint256 the amount of tokens to be transferred
294    */
295   function transferFrom(
296     address from,
297     address to,
298     uint256 value
299   )
300     public
301     returns (bool)
302   {
303     require(value <= _allowed[from][msg.sender]);
304 
305     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
306     _transfer(from, to, value);
307     return true;
308   }
309 
310   /**
311    * @dev Increase the amount of tokens that an owner allowed to a spender.
312    * approve should be called when allowed_[_spender] == 0. To increment
313    * allowed value is better to use this function to avoid 2 calls (and wait until
314    * the first transaction is mined)
315    * From MonolithDAO Token.sol
316    * @param spender The address which will spend the funds.
317    * @param addedValue The amount of tokens to increase the allowance by.
318    */
319   function increaseAllowance(
320     address spender,
321     uint256 addedValue
322   )
323     public
324     returns (bool)
325   {
326     require(spender != address(0));
327 
328     _allowed[msg.sender][spender] = (
329       _allowed[msg.sender][spender].add(addedValue));
330     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
331     return true;
332   }
333 
334   /**
335    * @dev Decrease the amount of tokens that an owner allowed to a spender.
336    * approve should be called when allowed_[_spender] == 0. To decrement
337    * allowed value is better to use this function to avoid 2 calls (and wait until
338    * the first transaction is mined)
339    * From MonolithDAO Token.sol
340    * @param spender The address which will spend the funds.
341    * @param subtractedValue The amount of tokens to decrease the allowance by.
342    */
343   function decreaseAllowance(
344     address spender,
345     uint256 subtractedValue
346   )
347     public
348     returns (bool)
349   {
350     require(spender != address(0));
351 
352     _allowed[msg.sender][spender] = (
353       _allowed[msg.sender][spender].sub(subtractedValue));
354     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
355     return true;
356   }
357 
358   /**
359   * @dev Transfer token for a specified addresses
360   * @param from The address to transfer from.
361   * @param to The address to transfer to.
362   * @param value The amount to be transferred.
363   */
364   function _transfer(address from, address to, uint256 value) internal {
365     require(value <= _balances[from]);
366     require(to != address(0));
367 
368     _balances[from] = _balances[from].sub(value);
369     _balances[to] = _balances[to].add(value);
370     emit Transfer(from, to, value);
371   }
372 
373   /**
374    * @dev Internal function that mints an amount of the token and assigns it to
375    * an account. This encapsulates the modification of balances such that the
376    * proper events are emitted.
377    * @param account The account that will receive the created tokens.
378    * @param value The amount that will be created.
379    */
380   function _mint(address account, uint256 value) internal {
381     require(account != 0);
382     _totalSupply = _totalSupply.add(value);
383     _balances[account] = _balances[account].add(value);
384     emit Transfer(address(0), account, value);
385   }
386 
387   /**
388    * @dev Internal function that burns an amount of the token of a given
389    * account.
390    * @param account The account whose tokens will be burnt.
391    * @param value The amount that will be burnt.
392    */
393   function _burn(address account, uint256 value) internal {
394     require(account != 0);
395     require(value <= _balances[account]);
396 
397     _totalSupply = _totalSupply.sub(value);
398     _balances[account] = _balances[account].sub(value);
399     emit Transfer(account, address(0), value);
400   }
401 
402   /**
403    * @dev Internal function that burns an amount of the token of a given
404    * account, deducting from the sender's allowance for said account. Uses the
405    * internal burn function.
406    * @param account The account whose tokens will be burnt.
407    * @param value The amount that will be burnt.
408    */
409   function _burnFrom(address account, uint256 value) internal {
410     require(value <= _allowed[account][msg.sender]);
411 
412     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
413     // this function needs to emit an event with the updated approval.
414     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
415       value);
416     _burn(account, value);
417   }
418 }
419 
420 /**
421  * @title Roles
422  * @dev Library for managing addresses assigned to a Role.
423  */
424 library Roles {
425   struct Role {
426     mapping (address => bool) bearer;
427   }
428 
429   /**
430    * @dev give an account access to this role
431    */
432   function add(Role storage role, address account) internal {
433     require(account != address(0));
434     require(!has(role, account));
435 
436     role.bearer[account] = true;
437   }
438 
439   /**
440    * @dev remove an account's access to this role
441    */
442   function remove(Role storage role, address account) internal {
443     require(account != address(0));
444     require(has(role, account));
445 
446     role.bearer[account] = false;
447   }
448 
449   /**
450    * @dev check if an account has this role
451    * @return bool
452    */
453   function has(Role storage role, address account)
454     internal
455     view
456     returns (bool)
457   {
458     require(account != address(0));
459     return role.bearer[account];
460   }
461 }
462 
463 contract MinterRole {
464   using Roles for Roles.Role;
465 
466   event MinterAdded(address indexed account);
467   event MinterRemoved(address indexed account);
468 
469   Roles.Role private minters;
470 
471   constructor() internal {
472     _addMinter(msg.sender);
473   }
474 
475   modifier onlyMinter() {
476     require(isMinter(msg.sender));
477     _;
478   }
479 
480   function isMinter(address account) public view returns (bool) {
481     return minters.has(account);
482   }
483 
484   function addMinter(address account) public onlyMinter {
485     _addMinter(account);
486   }
487 
488   function renounceMinter() public {
489     _removeMinter(msg.sender);
490   }
491 
492   function _addMinter(address account) internal {
493     minters.add(account);
494     emit MinterAdded(account);
495   }
496 
497   function _removeMinter(address account) internal {
498     minters.remove(account);
499     emit MinterRemoved(account);
500   }
501 }
502 
503 /**
504  * @title ERC20Mintable
505  * @dev ERC20 minting logic
506  */
507 contract ERC20Mintable is ERC20, MinterRole {
508   /**
509    * @dev Function to mint tokens
510    * @param to The address that will receive the minted tokens.
511    * @param value The amount of tokens to mint.
512    * @return A boolean that indicates if the operation was successful.
513    */
514   function mint(
515     address to,
516     uint256 value
517   )
518     public
519     onlyMinter
520     returns (bool)
521   {
522     _mint(to, value);
523     return true;
524   }
525 }
526 
527 /**
528  * @title Capped token
529  * @dev Mintable token with a token cap.
530  */
531 contract ERC20Capped is ERC20Mintable {
532 
533   uint256 private _cap;
534 
535   constructor(uint256 cap)
536     public
537   {
538     require(cap > 0);
539     _cap = cap;
540   }
541 
542   /**
543    * @return the cap for the token minting.
544    */
545   function cap() public view returns(uint256) {
546     return _cap;
547   }
548 
549   function _mint(address account, uint256 value) internal {
550     require(totalSupply().add(value) <= _cap);
551     super._mint(account, value);
552   }
553 }
554 
555 /**
556  * @title Burnable Token
557  * @dev Token that can be irreversibly burned (destroyed).
558  */
559 contract ERC20Burnable is ERC20 {
560 
561   /**
562    * @dev Burns a specific amount of tokens.
563    * @param value The amount of token to be burned.
564    */
565   function burn(uint256 value) public {
566     _burn(msg.sender, value);
567   }
568 
569   /**
570    * @dev Burns a specific amount of tokens from the target address and decrements allowance
571    * @param from address The address which you want to send tokens from
572    * @param value uint256 The amount of token to be burned
573    */
574   function burnFrom(address from, uint256 value) public {
575     _burnFrom(from, value);
576   }
577 }
578 
579 contract BurnerRole {
580   using Roles for Roles.Role;
581 
582   event BurnerAdded(address indexed account);
583   event BurnerRemoved(address indexed account);
584 
585   Roles.Role private burners;
586 
587   constructor() internal {
588     _addBurner(msg.sender);
589   }
590 
591   modifier onlyBurner() {
592     require(isBurner(msg.sender));
593     _;
594   }
595 
596   function isBurner(address account) public view returns (bool) {
597     return burners.has(account);
598   }
599 
600   function addBurner(address account) public onlyBurner {
601     _addBurner(account);
602   }
603 
604   function renounceBurner() public {
605     _removeBurner(msg.sender);
606   }
607 
608   function _addBurner(address account) internal {
609     burners.add(account);
610     emit BurnerAdded(account);
611   }
612 
613   function _removeBurner(address account) internal {
614     burners.remove(account);
615     emit BurnerRemoved(account);
616   }
617 }
618 
619 /**
620  * @title Burnable Token
621  * @dev Token that can be irreversibly burned (destroyed).
622  */
623 contract ERC20SafeBurnable is ERC20Burnable, BurnerRole {
624 
625   /**
626    * @dev Burns a specific amount of tokens.
627    * @param value The amount of token to be burned.
628    */
629   function burn(uint256 value) public onlyBurner {
630     super._burn(msg.sender, value);
631   }
632 
633   /**
634    * @dev Burns a specific amount of tokens from the target address and decrements allowance
635    * @param from address The address which you want to send tokens from
636    * @param value uint256 The amount of token to be burned
637    */
638   function burnFrom(address from, uint256 value) public onlyBurner {
639     super._burnFrom(from, value);
640   }
641 }
642 
643 contract PauserRole {
644   using Roles for Roles.Role;
645 
646   event PauserAdded(address indexed account);
647   event PauserRemoved(address indexed account);
648 
649   Roles.Role private pausers;
650 
651   constructor() internal {
652     _addPauser(msg.sender);
653   }
654 
655   modifier onlyPauser() {
656     require(isPauser(msg.sender));
657     _;
658   }
659 
660   function isPauser(address account) public view returns (bool) {
661     return pausers.has(account);
662   }
663 
664   function addPauser(address account) public onlyPauser {
665     _addPauser(account);
666   }
667 
668   function renouncePauser() public {
669     _removePauser(msg.sender);
670   }
671 
672   function _addPauser(address account) internal {
673     pausers.add(account);
674     emit PauserAdded(account);
675   }
676 
677   function _removePauser(address account) internal {
678     pausers.remove(account);
679     emit PauserRemoved(account);
680   }
681 }
682 
683 /**
684  * @title Pausable
685  * @dev Base contract which allows children to implement an emergency stop mechanism.
686  */
687 contract Pausable is PauserRole {
688   event Paused(address account);
689   event Unpaused(address account);
690 
691   bool private _paused;
692 
693   constructor() internal {
694     _paused = false;
695   }
696 
697   /**
698    * @return true if the contract is paused, false otherwise.
699    */
700   function paused() public view returns(bool) {
701     return _paused;
702   }
703 
704   /**
705    * @dev Modifier to make a function callable only when the contract is not paused.
706    */
707   modifier whenNotPaused() {
708     require(!_paused);
709     _;
710   }
711 
712   /**
713    * @dev Modifier to make a function callable only when the contract is paused.
714    */
715   modifier whenPaused() {
716     require(_paused);
717     _;
718   }
719 
720   /**
721    * @dev called by the owner to pause, triggers stopped state
722    */
723   function pause() public onlyPauser whenNotPaused {
724     _paused = true;
725     emit Paused(msg.sender);
726   }
727 
728   /**
729    * @dev called by the owner to unpause, returns to normal state
730    */
731   function unpause() public onlyPauser whenPaused {
732     _paused = false;
733     emit Unpaused(msg.sender);
734   }
735 }
736 
737 /**
738  * @title Pausable token
739  * @dev ERC20 modified with pausable transfers.
740  **/
741 contract ERC20Pausable is ERC20, Pausable {
742 
743   function transfer(
744     address to,
745     uint256 value
746   )
747     public
748     whenNotPaused
749     returns (bool)
750   {
751     return super.transfer(to, value);
752   }
753 
754   function transferFrom(
755     address from,
756     address to,
757     uint256 value
758   )
759     public
760     whenNotPaused
761     returns (bool)
762   {
763     return super.transferFrom(from, to, value);
764   }
765 
766   function approve(
767     address spender,
768     uint256 value
769   )
770     public
771     whenNotPaused
772     returns (bool)
773   {
774     return super.approve(spender, value);
775   }
776 
777   function increaseAllowance(
778     address spender,
779     uint addedValue
780   )
781     public
782     whenNotPaused
783     returns (bool success)
784   {
785     return super.increaseAllowance(spender, addedValue);
786   }
787 
788   function decreaseAllowance(
789     address spender,
790     uint subtractedValue
791   )
792     public
793     whenNotPaused
794     returns (bool success)
795   {
796     return super.decreaseAllowance(spender, subtractedValue);
797   }
798 }
799 
800 contract TENA is Ownable, ERC20Detailed, ERC20Capped, ERC20SafeBurnable, ERC20Pausable {
801     using SafeMath for uint;
802     
803     // token variables
804     string private constant NAME = "TENA";
805     string private constant SYMBOL = "TENA";
806     uint8 private constant DECIMALS = 18;
807     uint private constant TOTAL_SUPPLY = 100000000;  // 100,000,000 TENA
808     
809     // initial lock
810     bool isTransferable = false;
811     
812     // freeze address
813     mapping (address => bool) freezed;
814     
815     constructor () public
816         ERC20Detailed(NAME, SYMBOL, DECIMALS)
817         ERC20Capped(TOTAL_SUPPLY.mul(10 ** uint(DECIMALS))) {
818     }
819     
820     function unlock() external onlyOwner {
821         isTransferable = true;
822     }
823     
824     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
825         if (!isOwner()) {
826             require(isTransferable);
827             require(!(freezed[_from] || freezed[_to]));
828         }
829         return super.transferFrom(_from, _to, _value);
830     }
831 
832     function transfer(address _to, uint256 _value) public returns (bool) {
833         if (!isOwner()) {
834             require(isTransferable);
835             require(!(freezed[msg.sender] || freezed[_to]));
836         }
837         return super.transfer(_to, _value);
838     }
839     
840     function freeze(address at) external onlyOwner {
841         setFreezed(at, true);
842     }
843     
844     function unfreeze(address at) external onlyOwner {
845         setFreezed(at, false);
846     }
847     
848     function setFreezed(address at, bool freezing) public onlyOwner {
849         freezed[at] = freezing;
850     }
851 
852     function isFreezed(address at) public view returns (bool) {
853         return freezed[at];
854     }
855     
856     // overload mint
857     function mint(uint256 value) public onlyMinter returns (bool) {
858         _mint(msg.sender, value);
859         return true;
860     }
861 }