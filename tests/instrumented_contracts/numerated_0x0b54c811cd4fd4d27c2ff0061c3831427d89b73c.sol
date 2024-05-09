1 pragma solidity ^0.5.0;
2 
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
68 
69 /**
70  * @title Roles
71  * @dev Library for managing addresses assigned to a Role.
72  */
73 library Roles {
74   struct Role {
75     mapping (address => bool) bearer;
76   }
77 
78   /**
79    * @dev give an account access to this role
80    */
81   function add(Role storage role, address account) internal {
82     require(account != address(0));
83     require(!has(role, account));
84 
85     role.bearer[account] = true;
86   }
87 
88   /**
89    * @dev remove an account's access to this role
90    */
91   function remove(Role storage role, address account) internal {
92     require(account != address(0));
93     require(has(role, account));
94 
95     role.bearer[account] = false;
96   }
97 
98   /**
99    * @dev check if an account has this role
100    * @return bool
101    */
102   function has(Role storage role, address account)
103     internal
104     view
105     returns (bool)
106   {
107     require(account != address(0));
108     return role.bearer[account];
109   }
110 }
111 
112 
113 contract CapperRole {
114   using Roles for Roles.Role;
115 
116   event CapperAdded(address indexed account);
117   event CapperRemoved(address indexed account);
118 
119   Roles.Role private cappers;
120 
121   constructor(address account) internal {
122     _addCapper(account);
123   }
124 
125   modifier onlyCapper() {
126     require(isCapper(msg.sender));
127     _;
128   }
129 
130   function isCapper(address account) public view returns (bool) {
131     return cappers.has(account);
132   }
133 
134   function addCapper(address account) public onlyCapper {
135     _addCapper(account);
136   }
137 
138   function renounceCapper() public {
139     _removeCapper(msg.sender);
140   }
141 
142   function _addCapper(address account) internal {
143     cappers.add(account);
144     emit CapperAdded(account);
145   }
146 
147   function _removeCapper(address account) internal {
148     cappers.remove(account);
149     emit CapperRemoved(account);
150   }
151 }
152 
153 
154 contract PauserRole {
155   using Roles for Roles.Role;
156 
157   event PauserAdded(address indexed account);
158   event PauserRemoved(address indexed account);
159 
160   Roles.Role private pausers;
161 
162   constructor() internal {
163     _addPauser(msg.sender);
164   }
165 
166   modifier onlyPauser() {
167     require(isPauser(msg.sender));
168     _;
169   }
170 
171   function isPauser(address account) public view returns (bool) {
172     return pausers.has(account);
173   }
174 
175   function addPauser(address account) public onlyPauser {
176     _addPauser(account);
177   }
178 
179   function renouncePauser() public {
180     _removePauser(msg.sender);
181   }
182 
183   function _addPauser(address account) internal {
184     pausers.add(account);
185     emit PauserAdded(account);
186   }
187 
188   function _removePauser(address account) internal {
189     pausers.remove(account);
190     emit PauserRemoved(account);
191   }
192 }
193 
194 
195 /**
196  * @title Pausable
197  * @dev Base contract which allows children to implement an emergency stop mechanism.
198  */
199 contract Pausable is PauserRole {
200   event Paused(address account);
201   event Unpaused(address account);
202 
203   bool private _paused;
204 
205   constructor() internal {
206     _paused = false;
207   }
208 
209   /**
210    * @return true if the contract is paused, false otherwise.
211    */
212   function paused() public view returns(bool) {
213     return _paused;
214   }
215 
216   /**
217    * @dev Modifier to make a function callable only when the contract is not paused.
218    */
219   modifier whenNotPaused() {
220     require(!_paused);
221     _;
222   }
223 
224   /**
225    * @dev Modifier to make a function callable only when the contract is paused.
226    */
227   modifier whenPaused() {
228     require(_paused);
229     _;
230   }
231 
232   /**
233    * @dev called by the owner to pause, triggers stopped state
234    */
235   function pause() public onlyPauser whenNotPaused {
236     _paused = true;
237     emit Paused(msg.sender);
238   }
239 
240   /**
241    * @dev called by the owner to unpause, returns to normal state
242    */
243   function unpause() public onlyPauser whenPaused {
244     _paused = false;
245     emit Unpaused(msg.sender);
246   }
247 }
248 
249 
250 contract MinterRole {
251   using Roles for Roles.Role;
252 
253   event MinterAdded(address indexed account);
254   event MinterRemoved(address indexed account);
255 
256   Roles.Role private minters;
257 
258   constructor() internal {
259     _addMinter(msg.sender);
260   }
261 
262   modifier onlyMinter() {
263     require(isMinter(msg.sender));
264     _;
265   }
266 
267   function isMinter(address account) public view returns (bool) {
268     return minters.has(account);
269   }
270 
271   function addMinter(address account) public onlyMinter {
272     _addMinter(account);
273   }
274 
275   function renounceMinter() public {
276     _removeMinter(msg.sender);
277   }
278 
279   function _addMinter(address account) internal {
280     minters.add(account);
281     emit MinterAdded(account);
282   }
283 
284   function _removeMinter(address account) internal {
285     minters.remove(account);
286     emit MinterRemoved(account);
287   }
288 }
289 
290 
291 /**
292  * @title ERC20 interface
293  * @dev see https://github.com/ethereum/EIPs/issues/20
294  */
295 interface IERC20 {
296   function totalSupply() external view returns (uint256);
297 
298   function balanceOf(address who) external view returns (uint256);
299 
300   function allowance(address owner, address spender)
301     external view returns (uint256);
302 
303   function transfer(address to, uint256 value) external returns (bool);
304 
305   function approve(address spender, uint256 value)
306     external returns (bool);
307 
308   function transferFrom(address from, address to, uint256 value)
309     external returns (bool);
310 
311   event Transfer(
312     address indexed from,
313     address indexed to,
314     uint256 value
315   );
316 
317   event Approval(
318     address indexed owner,
319     address indexed spender,
320     uint256 value
321   );
322 }
323 
324 
325 /**
326  * @title Standard ERC20 token
327  *
328  * @dev Implementation of the basic standard token.
329  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
330  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
331  */
332 contract ERC20 is IERC20 {
333   using SafeMath for uint256;
334 
335   mapping (address => uint256) private _balances;
336 
337   mapping (address => mapping (address => uint256)) private _allowed;
338 
339   uint256 private _totalSupply;
340 
341   /**
342   * @dev Total number of tokens in existence
343   */
344   function totalSupply() public view returns (uint256) {
345     return _totalSupply;
346   }
347 
348   /**
349   * @dev Gets the balance of the specified address.
350   * @param owner The address to query the balance of.
351   * @return An uint256 representing the amount owned by the passed address.
352   */
353   function balanceOf(address owner) public view returns (uint256) {
354     return _balances[owner];
355   }
356 
357   /**
358    * @dev Function to check the amount of tokens that an owner allowed to a spender.
359    * @param owner address The address which owns the funds.
360    * @param spender address The address which will spend the funds.
361    * @return A uint256 specifying the amount of tokens still available for the spender.
362    */
363   function allowance(
364     address owner,
365     address spender
366    )
367     public
368     view
369     returns (uint256)
370   {
371     return _allowed[owner][spender];
372   }
373 
374   /**
375   * @dev Transfer token for a specified address
376   * @param to The address to transfer to.
377   * @param value The amount to be transferred.
378   */
379   function transfer(address to, uint256 value) public returns (bool) {
380     _transfer(msg.sender, to, value);
381     return true;
382   }
383 
384   /**
385    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
386    * Beware that changing an allowance with this method brings the risk that someone may use both the old
387    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
388    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
389    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
390    * @param spender The address which will spend the funds.
391    * @param value The amount of tokens to be spent.
392    */
393   function approve(address spender, uint256 value) public returns (bool) {
394     require(spender != address(0));
395 
396     _allowed[msg.sender][spender] = value;
397     emit Approval(msg.sender, spender, value);
398     return true;
399   }
400 
401   /**
402    * @dev Transfer tokens from one address to another
403    * @param from address The address which you want to send tokens from
404    * @param to address The address which you want to transfer to
405    * @param value uint256 the amount of tokens to be transferred
406    */
407   function transferFrom(
408     address from,
409     address to,
410     uint256 value
411   )
412     public
413     returns (bool)
414   {
415     require(value <= _allowed[from][msg.sender]);
416 
417     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
418     _transfer(from, to, value);
419     return true;
420   }
421 
422   /**
423    * @dev Increase the amount of tokens that an owner allowed to a spender.
424    * approve should be called when allowed_[_spender] == 0. To increment
425    * allowed value is better to use this function to avoid 2 calls (and wait until
426    * the first transaction is mined)
427    * From MonolithDAO Token.sol
428    * @param spender The address which will spend the funds.
429    * @param addedValue The amount of tokens to increase the allowance by.
430    */
431   function increaseAllowance(
432     address spender,
433     uint256 addedValue
434   )
435     public
436     returns (bool)
437   {
438     require(spender != address(0));
439 
440     _allowed[msg.sender][spender] = (
441       _allowed[msg.sender][spender].add(addedValue));
442     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
443     return true;
444   }
445 
446   /**
447    * @dev Decrease the amount of tokens that an owner allowed to a spender.
448    * approve should be called when allowed_[_spender] == 0. To decrement
449    * allowed value is better to use this function to avoid 2 calls (and wait until
450    * the first transaction is mined)
451    * From MonolithDAO Token.sol
452    * @param spender The address which will spend the funds.
453    * @param subtractedValue The amount of tokens to decrease the allowance by.
454    */
455   function decreaseAllowance(
456     address spender,
457     uint256 subtractedValue
458   )
459     public
460     returns (bool)
461   {
462     require(spender != address(0));
463 
464     _allowed[msg.sender][spender] = (
465       _allowed[msg.sender][spender].sub(subtractedValue));
466     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
467     return true;
468   }
469 
470   /**
471   * @dev Transfer token for a specified addresses
472   * @param from The address to transfer from.
473   * @param to The address to transfer to.
474   * @param value The amount to be transferred.
475   */
476   function _transfer(address from, address to, uint256 value) internal {
477     require(value <= _balances[from]);
478     require(to != address(0));
479 
480     _balances[from] = _balances[from].sub(value);
481     _balances[to] = _balances[to].add(value);
482     emit Transfer(from, to, value);
483   }
484 
485   /**
486    * @dev Internal function that mints an amount of the token and assigns it to
487    * an account. This encapsulates the modification of balances such that the
488    * proper events are emitted.
489    * @param account The account that will receive the created tokens.
490    * @param value The amount that will be created.
491    */
492   function _mint(address account, uint256 value) internal {
493     require(account != address(0));
494     _totalSupply = _totalSupply.add(value);
495     _balances[account] = _balances[account].add(value);
496     emit Transfer(address(0), account, value);
497   }
498 
499   /**
500    * @dev Internal function that burns an amount of the token of a given
501    * account.
502    * @param account The account whose tokens will be burnt.
503    * @param value The amount that will be burnt.
504    */
505   function _burn(address account, uint256 value) internal {
506     require(account != address(0));
507     require(value <= _balances[account]);
508 
509     _totalSupply = _totalSupply.sub(value);
510     _balances[account] = _balances[account].sub(value);
511     emit Transfer(account, address(0), value);
512   }
513 
514   /**
515    * @dev Internal function that burns an amount of the token of a given
516    * account, deducting from the sender's allowance for said account. Uses the
517    * internal burn function.
518    * @param account The account whose tokens will be burnt.
519    * @param value The amount that will be burnt.
520    */
521   function _burnFrom(address account, uint256 value) internal {
522     require(value <= _allowed[account][msg.sender]);
523 
524     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
525     // this function needs to emit an event with the updated approval.
526     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
527       value);
528     _burn(account, value);
529   }
530 }
531 
532 
533 /**
534  * @title ERC20Mintable
535  * @dev ERC20 minting logic
536  */
537 contract ERC20Mintable is ERC20, MinterRole {
538   /**
539    * @dev Function to mint tokens
540    * @param to The address that will receive the minted tokens.
541    * @param value The amount of tokens to mint.
542    * @return A boolean that indicates if the operation was successful.
543    */
544   function mint(
545     address to,
546     uint256 value
547   )
548     public
549     onlyMinter
550     returns (bool)
551   {
552     _mint(to, value);
553     return true;
554   }
555 }
556 
557 
558 /**
559  * @title Burnable Token
560  * @dev Token that can be irreversibly burned (destroyed).
561  */
562 contract ERC20Burnable is ERC20 {
563 
564   /**
565    * @dev Burns a specific amount of tokens.
566    * @param value The amount of token to be burned.
567    */
568   function burn(uint256 value) public {
569     _burn(msg.sender, value);
570   }
571 
572   /**
573    * @dev Burns a specific amount of tokens from the target address and decrements allowance
574    * @param from address The address which you want to send tokens from
575    * @param value uint256 The amount of token to be burned
576    */
577   function burnFrom(address from, uint256 value) public {
578     _burnFrom(from, value);
579   }
580 }
581 
582 
583 /**
584  * @title Capped token
585  * @dev Mintable token with a token cap.
586  */
587 contract ERC20Capped is ERC20Mintable, CapperRole {
588 
589   uint256 private _cap;
590 
591   constructor(uint256 cap, address capper)
592     public
593     CapperRole(capper)
594   {
595     require(cap > 0);
596     _cap = cap;
597   }
598 
599   /**
600    * @return the cap for the token minting.
601    */
602   function cap() public view returns(uint256) {
603     return _cap;
604   }
605 
606   function _mint(address account, uint256 value) internal {
607     require(totalSupply().add(value) <= _cap);
608     super._mint(account, value);
609   }
610 
611   /**
612    * @notice Set cap
613    * @param newCap New cap
614    */
615   function setCap(uint256 newCap) external onlyCapper {
616     emit CapSet(msg.sender, _cap, newCap);
617     _cap = newCap;    
618   }
619 
620   event CapSet(
621     address indexed capper,
622     uint256 oldCap,
623     uint256 newCap
624   );
625 }
626 
627 
628 /**
629  * @title Pausable token
630  * @dev ERC20 modified with pausable transfers.
631  **/
632 contract ERC20Pausable is ERC20, Pausable {
633 
634   function transfer(
635     address to,
636     uint256 value
637   )
638     public
639     whenNotPaused
640     returns (bool)
641   {
642     return super.transfer(to, value);
643   }
644 
645   function transferFrom(
646     address from,
647     address to,
648     uint256 value
649   )
650     public
651     whenNotPaused
652     returns (bool)
653   {
654     return super.transferFrom(from, to, value);
655   }
656 
657   function approve(
658     address spender,
659     uint256 value
660   )
661     public
662     whenNotPaused
663     returns (bool)
664   {
665     return super.approve(spender, value);
666   }
667 
668   function increaseAllowance(
669     address spender,
670     uint addedValue
671   )
672     public
673     whenNotPaused
674     returns (bool success)
675   {
676     return super.increaseAllowance(spender, addedValue);
677   }
678 
679   function decreaseAllowance(
680     address spender,
681     uint subtractedValue
682   )
683     public
684     whenNotPaused
685     returns (bool success)
686   {
687     return super.decreaseAllowance(spender, subtractedValue);
688   }
689 }
690 
691 
692 
693 /**
694  * @title Ownable
695  * @dev The Ownable contract has an owner address, and provides basic authorization control
696  * functions, this simplifies the implementation of "user permissions".
697  */
698 contract Ownable {
699     address private _owner;
700 
701     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
702 
703     /**
704      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
705      * account.
706      */
707     constructor () internal {
708         _owner = msg.sender;
709         emit OwnershipTransferred(address(0), _owner);
710     }
711 
712     /**
713      * @return the address of the owner.
714      */
715     function owner() public view returns (address) {
716         return _owner;
717     }
718 
719     /**
720      * @dev Throws if called by any account other than the owner.
721      */
722     modifier onlyOwner() {
723         require(isOwner());
724         _;
725     }
726 
727     /**
728      * @return true if `msg.sender` is the owner of the contract.
729      */
730     function isOwner() public view returns (bool) {
731         return msg.sender == _owner;
732     }
733 
734     /**
735      * @dev Allows the current owner to relinquish control of the contract.
736      * @notice Renouncing to ownership will leave the contract without an owner.
737      * It will not be possible to call the functions with the `onlyOwner`
738      * modifier anymore.
739      */
740     function renounceOwnership() public onlyOwner {
741         emit OwnershipTransferred(_owner, address(0));
742         _owner = address(0);
743     }
744 
745     /**
746      * @dev Allows the current owner to transfer control of the contract to a newOwner.
747      * @param newOwner The address to transfer ownership to.
748      */
749     function transferOwnership(address newOwner) public onlyOwner {
750         _transferOwnership(newOwner);
751     }
752 
753     /**
754      * @dev Transfers control of the contract to a newOwner.
755      * @param newOwner The address to transfer ownership to.
756      */
757     function _transferOwnership(address newOwner) internal {
758         require(newOwner != address(0));
759         emit OwnershipTransferred(_owner, newOwner);
760         _owner = newOwner;
761     }
762 }
763 
764 
765 /**
766  * @title Blueseeds Token
767  * @dev Custom ERC20 token
768  */
769 contract BlueseedsToken is Ownable, ERC20Capped, ERC20Burnable, ERC20Pausable {
770 
771   string public constant name = "Blueseeds Token";
772   string public constant symbol = "BST";
773   uint8 public constant decimals = 18;
774 
775   /**
776    * @dev Constructor that gives owner all of existing tokens.
777    * @param initSupply Amount of token initial supply
778    * @param initSupplyReceiver Address will receive initial supply
779    * @param capper Address can set new cap, e.g., auditor.
780    */
781   constructor(
782     uint256 initSupply,
783     address initSupplyReceiver,
784     address capper
785   ) 
786     public
787     ERC20Capped(initSupply, capper)
788   {
789     _mint(initSupplyReceiver, initSupply);
790   }
791 
792     /**
793    * @dev Allows the current owner to relinquish control of the contract.
794    * @notice Renouncing to ownership will leave the contract without an owner.
795    * It will not be possible to call the functions with the `onlyOwner`
796    * modifier anymore.
797    */
798   function renounceOwnership() public onlyOwner {
799     _renounceOwnerAssociatedRoles();
800     super.renounceOwnership();
801   }
802 
803   /**
804    * @dev Transfers control of the contract to a newOwner.
805    * @param newOwner The address to transfer ownership to.
806    */
807   function _transferOwnership(address newOwner) internal {
808     require(newOwner != address(0));
809     addMinter(newOwner);    
810     addPauser(newOwner);
811     _renounceOwnerAssociatedRoles();
812     super._transferOwnership(newOwner);
813   }
814 
815   /**
816    * @notice Renounce all owner associated roles.
817    */
818   function _renounceOwnerAssociatedRoles() private {
819     renounceMinter();
820     renouncePauser();
821   }
822 }