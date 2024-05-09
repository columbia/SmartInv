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
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     _owner = msg.sender;
25   }
26 
27   /**
28    * @return the address of the owner.
29    */
30   function owner() public view returns(address) {
31     return _owner;
32   }
33 
34   /**
35    * @dev Throws if called by any account other than the owner.
36    */
37   modifier onlyOwner() {
38     require(isOwner());
39     _;
40   }
41 
42   /**
43    * @return true if `msg.sender` is the owner of the contract.
44    */
45   function isOwner() public view returns(bool) {
46     return msg.sender == _owner;
47   }
48 
49   /**
50    * @dev Allows the current owner to relinquish control of the contract.
51    * @notice Renouncing to ownership will leave the contract without an owner.
52    * It will not be possible to call the functions with the `onlyOwner`
53    * modifier anymore.
54    */
55   function renounceOwnership() public onlyOwner {
56     emit OwnershipRenounced(_owner);
57     _owner = address(0);
58   }
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62    * @param newOwner The address to transfer ownership to.
63    */
64   function transferOwnership(address newOwner) public onlyOwner {
65     _transferOwnership(newOwner);
66   }
67 
68   /**
69    * @dev Transfers control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function _transferOwnership(address newOwner) internal {
73     require(newOwner != address(0));
74     emit OwnershipTransferred(_owner, newOwner);
75     _owner = newOwner;
76   }
77 }
78 
79 /**
80  * @title ERC20 interface
81  * @dev see https://github.com/ethereum/EIPs/issues/20
82  */
83 interface IERC20 {
84 
85   function totalSupply() external view returns (uint256);
86 
87   function balanceOf(address who) external view returns (uint256);
88 
89   function allowance(address owner, address spender)
90     external view returns (uint256);
91 
92   function transfer(address to, uint256 value) external returns (bool);
93 
94   function approve(address spender, uint256 value)
95     external returns (bool);
96 
97   function transferFrom(address from, address to, uint256 value)
98     external returns (bool);
99 
100   event Transfer(
101     address indexed from,
102     address indexed to,
103     uint256 value
104   );
105 
106   event Approval(
107     address indexed owner,
108     address indexed spender,
109     uint256 value
110   );
111 }
112 
113 /**
114  * @title Standard ERC20 token
115  *
116  * @dev Implementation of the basic standard token.
117  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
118  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
119  */
120 contract ERC20 is IERC20, Ownable {
121   using SafeMath for uint256;
122 
123   mapping (address => uint256) internal _balances;
124 
125   mapping (address => mapping (address => uint256)) internal _allowed;
126 
127   uint256 internal _totalSupply;
128 
129   uint256 internal _totalHolders;
130 
131   uint256 internal _totalTransfers;
132 
133   uint256 internal _initialSupply;
134 
135   function initialSupply() public view returns (uint256) {
136     return _initialSupply;
137   }
138 
139   /**
140   * @dev Total number of tokens in existence
141   */
142   function totalSupply() public view returns (uint256) {
143     return _totalSupply;
144   }
145 
146   function circulatingSupply() public view returns (uint256) {
147     require(_totalSupply >= _balances[owner()]);
148     return _totalSupply.sub(_balances[owner()]);
149   }
150 
151   /**
152   * @dev total number of token holders in existence
153   */
154   function totalHolders() public view returns (uint256) {
155     return _totalHolders;
156   }
157 
158   /**
159   * @dev total number of token transfers
160   */
161   function totalTransfers() public view returns (uint256) {
162     return _totalTransfers;
163   }
164 
165   /**
166   * @dev Gets the balance of the specified address.
167   * @param owner The address to query the balance of.
168   * @return An uint256 representing the amount owned by the passed address.
169   */
170   function balanceOf(address owner) public view returns (uint256) {
171     return _balances[owner];
172   }
173 
174   /**
175    * @dev Function to check the amount of tokens that an owner allowed to a spender.
176    * @param owner address The address which owns the funds.
177    * @param spender address The address which will spend the funds.
178    * @return A uint256 specifying the amount of tokens still available for the spender.
179    */
180   function allowance(
181     address owner,
182     address spender
183    )
184     public
185     view
186     returns (uint256)
187   {
188     return _allowed[owner][spender];
189   }
190 
191   /**
192   * @dev Transfer token for a specified address
193   * @param to The address to transfer to.
194   * @param value The amount to be transferred.
195   */
196   function transfer(address to, uint256 value) public returns (bool) {
197     require(value <= _balances[msg.sender]);
198     require(to != address(0));
199 
200     _balances[msg.sender] = _balances[msg.sender].sub(value);
201     if (_balances[msg.sender] == 0 && _totalHolders > 0) {
202       _totalHolders = _totalHolders.sub(1);
203     }
204     if (_balances[to] == 0) {
205       _totalHolders = _totalHolders.add(1);
206     }
207     _balances[to] = _balances[to].add(value);
208     _totalTransfers = _totalTransfers.add(1);
209     emit Transfer(msg.sender, to, value);
210     return true;
211   }
212 
213   /**
214    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
215    * Beware that changing an allowance with this method brings the risk that someone may use both the old
216    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
217    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
218    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
219    * @param spender The address which will spend the funds.
220    * @param value The amount of tokens to be spent.
221    */
222   function approve(address spender, uint256 value) public returns (bool) {
223     require(spender != address(0));
224 
225     _allowed[msg.sender][spender] = value;
226     emit Approval(msg.sender, spender, value);
227     return true;
228   }
229 
230   /**
231    * @dev Transfer tokens from one address to another
232    * @param from address The address which you want to send tokens from
233    * @param to address The address which you want to transfer to
234    * @param value uint256 the amount of tokens to be transferred
235    */
236   function transferFrom(
237     address from,
238     address to,
239     uint256 value
240   )
241     public
242     returns (bool)
243   {
244     if (msg.sender == from) {
245       return transfer(to, value);
246     }
247 
248     require(value <= _balances[from]);
249     require(value <= _allowed[from][msg.sender]);
250     require(to != address(0));
251 
252     _balances[from] = _balances[from].sub(value);
253 
254     if (_balances[from] == 0 && _totalHolders > 0) {
255       _totalHolders = _totalHolders.sub(1);
256     }
257     if (_balances[to] == 0) {
258       _totalHolders = _totalHolders.add(1);
259     }
260 
261     _balances[to] = _balances[to].add(value);
262     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
263     _totalTransfers = _totalTransfers.add(1);
264     emit Transfer(from, to, value);
265     return true;
266   }
267 
268   /**
269    * @dev Increase the amount of tokens that an owner allowed to a spender.
270    * approve should be called when allowed_[_spender] == 0. To increment
271    * allowed value is better to use this function to avoid 2 calls (and wait until
272    * the first transaction is mined)
273    * From MonolithDAO Token.sol
274    * @param spender The address which will spend the funds.
275    * @param addedValue The amount of tokens to increase the allowance by.
276    */
277   function increaseAllowance(
278     address spender,
279     uint256 addedValue
280   )
281     public
282     returns (bool)
283   {
284     require(spender != address(0));
285 
286     _allowed[msg.sender][spender] = (
287       _allowed[msg.sender][spender].add(addedValue));
288     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
289     return true;
290   }
291 
292   /**
293    * @dev Decrease the amount of tokens that an owner allowed to a spender.
294    * approve should be called when allowed_[_spender] == 0. To decrement
295    * allowed value is better to use this function to avoid 2 calls (and wait until
296    * the first transaction is mined)
297    * From MonolithDAO Token.sol
298    * @param spender The address which will spend the funds.
299    * @param subtractedValue The amount of tokens to decrease the allowance by.
300    */
301   function decreaseAllowance(
302     address spender,
303     uint256 subtractedValue
304   )
305     public
306     returns (bool)
307   {
308     require(spender != address(0));
309 
310     _allowed[msg.sender][spender] = (
311       _allowed[msg.sender][spender].sub(subtractedValue));
312     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
313     return true;
314   }
315 
316   /**
317    * @dev Internal function that mints an amount of the token and assigns it to
318    * an account. This encapsulates the modification of balances such that the
319    * proper events are emitted.
320    * @param account The account that will receive the created tokens.
321    * @param amount The amount that will be created.
322    */
323   function _mint(address account, uint256 amount) internal {
324     require(account != 0);
325     _totalSupply = _totalSupply.add(amount);
326     if (_balances[account] == 0) {
327       _totalHolders = _totalHolders.add(1);
328     }
329     _balances[account] = _balances[account].add(amount);
330     emit Transfer(address(0), account, amount);
331   }
332 
333   /**
334    * @dev Internal function that burns an amount of the token of a given
335    * account.
336    * @param account The account whose tokens will be burnt.
337    * @param amount The amount that will be burnt.
338    */
339   function _burn(address account, uint256 amount) internal {
340     require(account != 0);
341     require(amount <= _balances[account]);
342 
343     _totalSupply = _totalSupply.sub(amount);
344     _balances[account] = _balances[account].sub(amount);
345     if (_balances[account] == 0 && _totalHolders > 0) {
346       _totalHolders = _totalHolders.sub(1);
347     }
348     emit Transfer(account, address(0), amount);
349   }
350 
351   /**
352    * @dev Internal function that burns an amount of the token of a given
353    * account, deducting from the sender's allowance for said account. Uses the
354    * internal burn function.
355    * @param account The account whose tokens will be burnt.
356    * @param amount The amount that will be burnt.
357    */
358   function _burnFrom(address account, uint256 amount) internal {
359     require(amount <= _allowed[account][msg.sender]);
360 
361     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
362     // this function needs to emit an event with the updated approval.
363     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
364       amount);
365     _burn(account, amount);
366   }
367 }
368 
369 contract AgentRole is Ownable {
370   using Roles for Roles.Role;
371 
372   event AgentAdded(address indexed account);
373   event AgentRemoved(address indexed account);
374 
375   Roles.Role private agencies;
376 
377   constructor() public {
378     agencies.add(msg.sender);
379   }
380 
381   modifier onlyAgent() {
382     require(isOwner() || isAgent(msg.sender));
383     _;
384   }
385 
386   function isAgent(address account) public view returns (bool) {
387     return agencies.has(account);
388   }
389 
390   function addAgent(address account) public onlyAgent {
391     agencies.add(account);
392     emit AgentAdded(account);
393   }
394 
395   function renounceAgent() public onlyAgent {
396     agencies.remove(msg.sender);
397   }
398 
399   function _removeAgent(address account) internal {
400     agencies.remove(account);
401     emit AgentRemoved(account);
402   }
403 }
404 
405 /**
406  * @title Agent token
407  * @dev ERC20 modified with agentable transfers.
408  **/
409 contract ERC20Agentable is ERC20, AgentRole {
410 
411   function removeAgent(address account) public onlyAgent {
412     _removeAgent(account);
413   }
414 
415   function _removeAgent(address account) internal {
416     super._removeAgent(account);
417   }
418 
419   function transferProxy(
420     address from,
421     address to,
422     uint256 value
423   )
424     public
425     onlyAgent
426     returns (bool)
427   {
428     if (msg.sender == from) {
429       return transfer(to, value);
430     }
431 
432     require(value <= _balances[from]);
433     require(to != address(0));
434 
435     _balances[from] = _balances[from].sub(value);
436 
437     if (_balances[from] == 0 && _totalHolders > 0) {
438       _totalHolders = _totalHolders.sub(1);
439     }
440     if (_balances[to] == 0) {
441       _totalHolders = _totalHolders.add(1);
442     }
443 
444     _balances[to] = _balances[to].add(value);
445     _totalTransfers = _totalTransfers.add(1);
446     emit Transfer(from, to, value);
447     return true;
448   }
449 
450   function approveProxy(
451     address from,
452     address spender,
453     uint256 value
454   )
455     public
456     onlyAgent
457     returns (bool)
458   {
459     require(spender != address(0));
460 
461     _allowed[from][spender] = value;
462     emit Approval(from, spender, value);
463     return true;
464   }
465 
466   function increaseAllowanceProxy(
467     address from,
468     address spender,
469     uint addedValue
470   )
471     public
472     onlyAgent
473     returns (bool success)
474   {
475     require(spender != address(0));
476 
477     _allowed[from][spender] = (
478       _allowed[from][spender].add(addedValue));
479     emit Approval(from, spender, _allowed[from][spender]);
480     return true;
481   }
482 
483   function decreaseAllowanceProxy(
484     address from,
485     address spender,
486     uint subtractedValue
487   )
488     public
489     onlyAgent
490     returns (bool success)
491   {
492     require(spender != address(0));
493 
494     _allowed[from][spender] = (
495       _allowed[from][spender].sub(subtractedValue));
496     emit Approval(from, spender, _allowed[from][spender]);
497     return true;
498   }
499 }
500 
501 /**
502  * @title Burnable Token
503  * @dev Token that can be irreversibly burned (destroyed).
504  */
505 contract ERC20Burnable is ERC20 {
506 
507   /**
508    * @dev Burns a specific amount of tokens.
509    * @param value The amount of token to be burned.
510    */
511   function burn(uint256 value) public {
512     _burn(msg.sender, value);
513   }
514 
515   /**
516    * @dev Burns a specific amount of tokens from the target address and decrements allowance
517    * @param from address The address which you want to send tokens from
518    * @param value uint256 The amount of token to be burned
519    */
520   function burnFrom(address from, uint256 value) public {
521     _burnFrom(from, value);
522   }
523 
524   /**
525    * @dev Overrides ERC20._burn in order for burn and burnFrom to emit
526    * an additional Burn event.
527    */
528   function _burn(address who, uint256 value) internal {
529     super._burn(who, value);
530   }
531 }
532 
533 contract MinterRole is Ownable {
534   using Roles for Roles.Role;
535 
536   event MinterAdded(address indexed account);
537   event MinterRemoved(address indexed account);
538 
539   Roles.Role private minters;
540 
541   constructor() public {
542     minters.add(msg.sender);
543   }
544 
545   modifier onlyMinter() {
546     require(isOwner() || isMinter(msg.sender));
547     _;
548   }
549 
550   function isMinter(address account) public view returns (bool) {
551     return minters.has(account);
552   }
553 
554   function addMinter(address account) public onlyMinter {
555     minters.add(account);
556     emit MinterAdded(account);
557   }
558 
559   function renounceMinter() public onlyMinter {
560     minters.remove(msg.sender);
561   }
562 
563   function _removeMinter(address account) internal {
564     minters.remove(account);
565     emit MinterRemoved(account);
566   }
567 }
568 
569 /**
570  * @title ERC20Mintable
571  * @dev ERC20 minting logic
572  */
573 contract ERC20Mintable is ERC20, MinterRole {
574   event MintingFinished();
575 
576   bool private _mintingFinished = false;
577 
578   modifier onlyBeforeMintingFinished() {
579     require(!_mintingFinished);
580     _;
581   }
582 
583   function removeMinter(address account) public onlyMinter {
584     _removeMinter(account);
585   }
586 
587   function _removeMinter(address account) internal {
588     super._removeMinter(account);
589   }
590 
591   /**
592    * @return true if the minting is finished.
593    */
594   function mintingFinished() public view returns(bool) {
595     return _mintingFinished;
596   }
597 
598   /**
599    * @dev Function to mint tokens
600    * @param to The address that will receive the minted tokens.
601    * @param amount The amount of tokens to mint.
602    * @return A boolean that indicates if the operation was successful.
603    */
604   function mint(
605     address to,
606     uint256 amount
607   )
608     public
609     onlyMinter
610     onlyBeforeMintingFinished
611     returns (bool)
612   {
613     _mint(to, amount);
614     return true;
615   }
616 
617   /**
618    * @dev Function to stop minting new tokens.
619    * @return True if the operation was successful.
620    */
621   function finishMinting()
622     public
623     onlyMinter
624     onlyBeforeMintingFinished
625     returns (bool)
626   {
627     _mintingFinished = true;
628     emit MintingFinished();
629     return true;
630   }
631 }
632 
633 contract PauserRole is Ownable {
634   using Roles for Roles.Role;
635 
636   event PauserAdded(address indexed account);
637   event PauserRemoved(address indexed account);
638 
639   Roles.Role private pausers;
640 
641   constructor() public {
642     pausers.add(msg.sender);
643   }
644 
645   modifier onlyPauser() {
646     require(isOwner() || isPauser(msg.sender));
647     _;
648   }
649 
650   function isPauser(address account) public view returns (bool) {
651     return pausers.has(account);
652   }
653 
654   function addPauser(address account) public onlyPauser {
655     pausers.add(account);
656     emit PauserAdded(account);
657   }
658 
659   function renouncePauser() public onlyPauser {
660     pausers.remove(msg.sender);
661   }
662 
663   function _removePauser(address account) internal {
664     pausers.remove(account);
665     emit PauserRemoved(account);
666   }
667 }
668 
669 /**
670  * @title Pausable
671  * @dev Base contract which allows children to implement an emergency stop mechanism.
672  */
673 contract Pausable is PauserRole {
674   event Paused();
675   event Unpaused();
676 
677   bool private _paused = false;
678 
679 
680   /**
681    * @return true if the contract is paused, false otherwise.
682    */
683   function paused() public view returns(bool) {
684     return _paused;
685   }
686 
687   /**
688    * @dev Modifier to make a function callable only when the contract is not paused.
689    */
690   modifier whenNotPaused() {
691     require(!_paused);
692     _;
693   }
694 
695   /**
696    * @dev Modifier to make a function callable only when the contract is paused.
697    */
698   modifier whenPaused() {
699     require(_paused);
700     _;
701   }
702 
703   /**
704    * @dev called by the owner to pause, triggers stopped state
705    */
706   function pause() public onlyPauser whenNotPaused {
707     _paused = true;
708     emit Paused();
709   }
710 
711   /**
712    * @dev called by the owner to unpause, returns to normal state
713    */
714   function unpause() public onlyPauser whenPaused {
715     _paused = false;
716     emit Unpaused();
717   }
718 }
719 
720 /**
721  * @title Pausable token
722  * @dev ERC20 modified with pausable transfers.
723  **/
724 contract ERC20Pausable is ERC20, Pausable {
725 
726   function removePauser(address account) public onlyPauser {
727     _removePauser(account);
728   }
729 
730   function _removePauser(address account) internal {
731     super._removePauser(account);
732   }
733 
734   function transfer(
735     address to,
736     uint256 value
737   )
738     public
739     whenNotPaused
740     returns (bool)
741   {
742     return super.transfer(to, value);
743   }
744 
745   function transferFrom(
746     address from,
747     address to,
748     uint256 value
749   )
750     public
751     whenNotPaused
752     returns (bool)
753   {
754     return super.transferFrom(from, to, value);
755   }
756 
757   function approve(
758     address spender,
759     uint256 value
760   )
761     public
762     whenNotPaused
763     returns (bool)
764   {
765     return super.approve(spender, value);
766   }
767 
768   function increaseAllowance(
769     address spender,
770     uint addedValue
771   )
772     public
773     whenNotPaused
774     returns (bool success)
775   {
776     return super.increaseAllowance(spender, addedValue);
777   }
778 
779   function decreaseAllowance(
780     address spender,
781     uint subtractedValue
782   )
783     public
784     whenNotPaused
785     returns (bool success)
786   {
787     return super.decreaseAllowance(spender, subtractedValue);
788   }
789 }
790 
791 
792 
793 /**
794  * @title Roles
795  * @dev Library for managing addresses assigned to a Role.
796  */
797 library Roles {
798   struct Role {
799     mapping (address => bool) bearer;
800   }
801 
802   /**
803    * @dev give an account access to this role
804    */
805   function add(Role storage role, address account) internal {
806     require(account != address(0));
807     role.bearer[account] = true;
808   }
809 
810   /**
811    * @dev remove an account's access to this role
812    */
813   function remove(Role storage role, address account) internal {
814     require(account != address(0));
815     role.bearer[account] = false;
816   }
817 
818   /**
819    * @dev check if an account has this role
820    * @return bool
821    */
822   function has(Role storage role, address account)
823     internal
824     view
825     returns (bool)
826   {
827     require(account != address(0));
828     return role.bearer[account];
829   }
830 }
831 
832 /**
833  * @title SafeERC20
834  * @dev Wrappers around ERC20 operations that throw on failure.
835  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
836  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
837  */
838 library SafeERC20 {
839   function safeTransfer(
840     IERC20 token,
841     address to,
842     uint256 value
843   )
844     internal
845   {
846     require(token.transfer(to, value));
847   }
848 
849   function safeTransferFrom(
850     IERC20 token,
851     address from,
852     address to,
853     uint256 value
854   )
855     internal
856   {
857     require(token.transferFrom(from, to, value));
858   }
859 
860   function safeApprove(
861     IERC20 token,
862     address spender,
863     uint256 value
864   )
865     internal
866   {
867     require(token.approve(spender, value));
868   }
869 }
870 
871 /**
872  * @title SafeMath
873  * @dev Math operations with safety checks that revert on error
874  */
875 library SafeMath {
876 
877   /**
878   * @dev Multiplies two numbers, reverts on overflow.
879   */
880   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
881     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
882     // benefit is lost if 'b' is also tested.
883     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
884     if (a == 0) {
885       return 0;
886     }
887 
888     uint256 c = a * b;
889     require(c / a == b);
890 
891     return c;
892   }
893 
894   /**
895   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
896   */
897   function div(uint256 a, uint256 b) internal pure returns (uint256) {
898     require(b > 0); // Solidity only automatically asserts when dividing by 0
899     uint256 c = a / b;
900     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
901 
902     return c;
903   }
904 
905   /**
906   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
907   */
908   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
909     require(b <= a);
910     uint256 c = a - b;
911 
912     return c;
913   }
914 
915   /**
916   * @dev Adds two numbers, reverts on overflow.
917   */
918   function add(uint256 a, uint256 b) internal pure returns (uint256) {
919     uint256 c = a + b;
920     require(c >= a);
921 
922     return c;
923   }
924 
925   /**
926   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
927   * reverts when dividing by zero.
928   */
929   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
930     require(b != 0);
931     return a % b;
932   }
933 }
934 
935 contract Token is ERC20Burnable, ERC20Mintable, ERC20Pausable, ERC20Agentable {
936 
937   string private _name;
938   string private _symbol;
939   uint8 private _decimals;
940 
941   constructor(string name, string symbol, uint8 decimals, uint256 initialSupply) public {
942     _name = name;
943     _symbol = symbol;
944     _decimals = decimals;
945     _initialSupply = initialSupply;
946     _totalSupply = _initialSupply;
947     _balances[msg.sender] = _initialSupply;
948     emit Transfer(0x0, msg.sender, _initialSupply);
949   }
950 
951   /**
952    * @return the name of the token.
953    */
954   function name() public view returns(string) {
955     return _name;
956   }
957 
958   /**
959    * @return the symbol of the token.
960    */
961   function symbol() public view returns(string) {
962     return _symbol;
963   }
964 
965   /**
966    * @return the number of decimals of the token.
967    */
968   function decimals() public view returns(uint8) {
969     return _decimals;
970   }
971 
972   function meta(address account) public view returns (string, string, uint8, uint256, uint256, uint256, uint256, uint256, uint256) {
973     uint256 circulating = 0;
974     if (_totalSupply > _balances[owner()]) {
975       circulating = _totalSupply.sub(_balances[owner()]);
976     }
977     uint256 balance = 0;
978     if (account != address(0)) {
979       balance = _balances[account];
980     } else if (msg.sender != address(0)) {
981       balance = _balances[msg.sender];
982     }
983     return (_name, _symbol, _decimals, _initialSupply, _totalSupply, _totalTransfers, _totalHolders, circulating, balance);
984   }
985 
986   function batchTransfer(address[] addresses, uint256[] tokenAmount) public returns (bool) {
987     require(addresses.length > 0 && addresses.length == tokenAmount.length);
988     for (uint i = 0; i < addresses.length; i++) {
989         address _to = addresses[i];
990         uint256 _value = tokenAmount[i];
991         super.transfer(_to, _value);
992     }
993     return true;
994   }
995 
996   function batchTransferFrom(address _from, address[] addresses, uint256[] tokenAmount) public returns (bool) {
997     require(addresses.length > 0 && addresses.length == tokenAmount.length);
998     for (uint i = 0; i < addresses.length; i++) {
999         address _to = addresses[i];
1000         uint256 _value = tokenAmount[i];
1001         super.transferFrom(_from, _to, _value);
1002     }
1003     return true;
1004   }
1005 
1006 
1007 }