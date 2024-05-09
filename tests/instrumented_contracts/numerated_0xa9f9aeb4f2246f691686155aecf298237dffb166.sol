1 pragma solidity ^0.4.24;
2 // ----------------------------------------------------------------------------
3 // DAVID Token(DVD) Smart Contract V.1.1
4 // 데이비드 토큰(DVD) 스마트 컨트랙트 버전1.1
5 // Symbol       : DVD
6 // Name         : DAVID Token
7 // Decimals     : 18
8 // Total supply : 1,000,000,000
9 // ----------------------------------------------------------------------------
10 
11 /**
12  * @title Ownable
13  * @dev The Ownable contract has an owner address, and provides basic authorization control
14  * functions, this simplifies the implementation of "user permissions".
15  */
16 contract Ownable {
17   address private _owner;
18 
19   event OwnershipRenounced(address indexed previousOwner);
20   event OwnershipTransferred(
21     address indexed previousOwner,
22     address indexed newOwner
23   );
24 
25   /**
26    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
27    * account.
28    */
29   constructor() public {
30     _owner = msg.sender;
31   }
32 
33   /**
34    * @return the address of the owner.
35    */
36   function owner() public view returns(address) {
37     return _owner;
38   }
39 
40   /**
41    * @dev Throws if called by any account other than the owner.
42    */
43   modifier onlyOwner() {
44     require(isOwner());
45     _;
46   }
47 
48   /**
49    * @return true if `msg.sender` is the owner of the contract.
50    */
51   function isOwner() public view returns(bool) {
52     return msg.sender == _owner;
53   }
54 
55   /**
56    * @dev Allows the current owner to relinquish control of the contract.
57    * @notice Renouncing to ownership will leave the contract without an owner.
58    * It will not be possible to call the functions with the `onlyOwner`
59    * modifier anymore.
60    */
61   function renounceOwnership() public onlyOwner {
62     emit OwnershipRenounced(_owner);
63     _owner = address(0);
64   }
65 
66   /**
67    * @dev Allows the current owner to transfer control of the contract to a newOwner.
68    * @param newOwner The address to transfer ownership to.
69    */
70   function transferOwnership(address newOwner) public onlyOwner {
71     _transferOwnership(newOwner);
72   }
73 
74   /**
75    * @dev Transfers control of the contract to a newOwner.
76    * @param newOwner The address to transfer ownership to.
77    */
78   function _transferOwnership(address newOwner) internal {
79     require(newOwner != address(0));
80     emit OwnershipTransferred(_owner, newOwner);
81     _owner = newOwner;
82   }
83 }
84 
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
150 
151 /**
152  * @title ERC20 interface
153  * @dev see https://github.com/ethereum/EIPs/issues/20
154  */
155 interface IERC20 {
156   function totalSupply() external view returns (uint256);
157 
158   function balanceOf(address who) external view returns (uint256);
159 
160   function allowance(address owner, address spender)
161     external view returns (uint256);
162 
163   function transfer(address to, uint256 value) external returns (bool);
164 
165   function approve(address spender, uint256 value)
166     external returns (bool);
167 
168   function transferFrom(address from, address to, uint256 value)
169     external returns (bool);
170 
171   event Transfer(
172     address indexed from,
173     address indexed to,
174     uint256 value
175   );
176 
177   event Approval(
178     address indexed owner,
179     address indexed spender,
180     uint256 value
181   );
182 }
183 
184 
185 /**
186  * @title SafeERC20
187  * @dev Wrappers around ERC20 operations that throw on failure.
188  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
189  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
190  */
191 library SafeERC20 {
192   function safeTransfer(
193     IERC20 token,
194     address to,
195     uint256 value
196   )
197     internal
198   {
199     require(token.transfer(to, value));
200   }
201 
202   function safeTransferFrom(
203     IERC20 token,
204     address from,
205     address to,
206     uint256 value
207   )
208     internal
209   {
210     require(token.transferFrom(from, to, value));
211   }
212 
213   function safeApprove(
214     IERC20 token,
215     address spender,
216     uint256 value
217   )
218     internal
219   {
220     require(token.approve(spender, value));
221   }
222 }
223 
224 
225 /**
226  * @title Roles
227  * @dev Library for managing addresses assigned to a Role.
228  */
229 library Roles {
230   struct Role {
231     mapping (address => bool) bearer;
232   }
233 
234   /**
235    * @dev give an account access to this role
236    */
237   function add(Role storage role, address account) internal {
238     require(account != address(0));
239     role.bearer[account] = true;
240   }
241 
242   /**
243    * @dev remove an account's access to this role
244    */
245   function remove(Role storage role, address account) internal {
246     require(account != address(0));
247     role.bearer[account] = false;
248   }
249 
250   /**
251    * @dev check if an account has this role
252    * @return bool
253    */
254   function has(Role storage role, address account)
255     internal
256     view
257     returns (bool)
258   {
259     require(account != address(0));
260     return role.bearer[account];
261   }
262 }
263 
264 
265 contract SignerRole {
266   using Roles for Roles.Role;
267 
268   event SignerAdded(address indexed account);
269   event SignerRemoved(address indexed account);
270 
271   Roles.Role private signers;
272 
273   constructor() public {
274     _addSigner(msg.sender);
275   }
276 
277   modifier onlySigner() {
278     require(isSigner(msg.sender));
279     _;
280   }
281 
282   function isSigner(address account) public view returns (bool) {
283     return signers.has(account);
284   }
285 
286   function addSigner(address account) public onlySigner {
287     _addSigner(account);
288   }
289 
290   function renounceSigner() public {
291     _removeSigner(msg.sender);
292   }
293 
294   function _addSigner(address account) internal {
295     signers.add(account);
296     emit SignerAdded(account);
297   }
298 
299   function _removeSigner(address account) internal {
300     signers.remove(account);
301     emit SignerRemoved(account);
302   }
303 }
304 
305 
306 contract MinterRole {
307   using Roles for Roles.Role;
308 
309   event MinterAdded(address indexed account);
310   event MinterRemoved(address indexed account);
311 
312   Roles.Role private minters;
313 
314   constructor() public {
315     _addMinter(msg.sender);
316   }
317 
318   modifier onlyMinter() {
319     require(isMinter(msg.sender));
320     _;
321   }
322 
323   function isMinter(address account) public view returns (bool) {
324     return minters.has(account);
325   }
326 
327   function addMinter(address account) public onlyMinter {
328     _addMinter(account);
329   }
330 
331   function renounceMinter() public {
332     _removeMinter(msg.sender);
333   }
334 
335   function _addMinter(address account) internal {
336     minters.add(account);
337     emit MinterAdded(account);
338   }
339 
340   function _removeMinter(address account) internal {
341     minters.remove(account);
342     emit MinterRemoved(account);
343   }
344 }
345 
346 
347 contract PauserRole {
348   using Roles for Roles.Role;
349 
350   event PauserAdded(address indexed account);
351   event PauserRemoved(address indexed account);
352 
353   Roles.Role private pausers;
354 
355   constructor() public {
356     _addPauser(msg.sender);
357   }
358 
359   modifier onlyPauser() {
360     require(isPauser(msg.sender));
361     _;
362   }
363 
364   function isPauser(address account) public view returns (bool) {
365     return pausers.has(account);
366   }
367 
368   function addPauser(address account) public onlyPauser {
369     _addPauser(account);
370   }
371 
372   function renouncePauser() public {
373     _removePauser(msg.sender);
374   }
375 
376   function _addPauser(address account) internal {
377     pausers.add(account);
378     emit PauserAdded(account);
379   }
380 
381   function _removePauser(address account) internal {
382     pausers.remove(account);
383     emit PauserRemoved(account);
384   }
385 }
386 
387 
388 /**
389  * @title Standard ERC20 token
390  *
391  * @dev Implementation of the basic standard token.
392  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
393  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
394  */
395 contract ERC20 is IERC20, Ownable {
396   using SafeMath for uint256;
397 
398   mapping (address => uint256) private _balances;
399 
400   mapping (address => mapping (address => uint256)) private _allowed;
401 
402   uint256 private _totalSupply;
403 
404   /**
405   * @dev Total number of tokens in existence
406   */
407   function totalSupply() public view returns (uint256) {
408     return _totalSupply;
409   }
410 
411   /**
412   * @dev Gets the balance of the specified address.
413   * @param owner The address to query the balance of.
414   * @return An uint256 representing the amount owned by the passed address.
415   */
416   function balanceOf(address owner) public view returns (uint256) {
417     return _balances[owner];
418   }
419 
420   /**
421    * @dev Function to check the amount of tokens that an owner allowed to a spender.
422    * @param owner address The address which owns the funds.
423    * @param spender address The address which will spend the funds.
424    * @return A uint256 specifying the amount of tokens still available for the spender.
425    */
426   function allowance(
427     address owner,
428     address spender
429    )
430     public
431     view
432     returns (uint256)
433   {
434     return _allowed[owner][spender];
435   }
436 
437   /**
438   * @dev Transfer token for a specified address
439   * @param to The address to transfer to.
440   * @param value The amount to be transferred.
441   */
442   function transfer(address to, uint256 value) public returns (bool) {
443     _transfer(msg.sender, to, value);
444     return true;
445   }
446 
447   /**
448    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
449    * Beware that changing an allowance with this method brings the risk that someone may use both the old
450    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
451    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
452    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
453    * @param spender The address which will spend the funds.
454    * @param value The amount of tokens to be spent.
455    */
456   function approve(address spender, uint256 value) public returns (bool) {
457     require(spender != address(0));
458 
459     _allowed[msg.sender][spender] = value;
460     emit Approval(msg.sender, spender, value);
461     return true;
462   }
463 
464   /**
465    * @dev Transfer tokens from one address to another
466    * @param from address The address which you want to send tokens from
467    * @param to address The address which you want to transfer to
468    * @param value uint256 the amount of tokens to be transferred
469    */
470   function transferFrom(
471     address from,
472     address to,
473     uint256 value
474   )
475     public
476     returns (bool)
477   {
478     require(value <= _allowed[from][msg.sender]);
479 
480     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
481     _transfer(from, to, value);
482     return true;
483   }
484 
485   /**
486    * @dev Increase the amount of tokens that an owner allowed to a spender.
487    * approve should be called when allowed_[_spender] == 0. To increment
488    * allowed value is better to use this function to avoid 2 calls (and wait until
489    * the first transaction is mined)
490    * From MonolithDAO Token.sol
491    * @param spender The address which will spend the funds.
492    * @param addedValue The amount of tokens to increase the allowance by.
493    */
494   function increaseAllowance(
495     address spender,
496     uint256 addedValue
497   )
498     public
499     returns (bool)
500   {
501     require(spender != address(0));
502 
503     _allowed[msg.sender][spender] = (
504       _allowed[msg.sender][spender].add(addedValue));
505     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
506     return true;
507   }
508 
509   /**
510    * @dev Decrease the amount of tokens that an owner allowed to a spender.
511    * approve should be called when allowed_[_spender] == 0. To decrement
512    * allowed value is better to use this function to avoid 2 calls (and wait until
513    * the first transaction is mined)
514    * From MonolithDAO Token.sol
515    * @param spender The address which will spend the funds.
516    * @param subtractedValue The amount of tokens to decrease the allowance by.
517    */
518   function decreaseAllowance(
519     address spender,
520     uint256 subtractedValue
521   )
522     public
523     returns (bool)
524   {
525     require(spender != address(0));
526 
527     _allowed[msg.sender][spender] = (
528       _allowed[msg.sender][spender].sub(subtractedValue));
529     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
530     return true;
531   }
532 
533   /**
534   * @dev Transfer token for a specified addresses
535   * @param from The address to transfer from.
536   * @param to The address to transfer to.
537   * @param value The amount to be transferred.
538   */
539   function _transfer(address from, address to, uint256 value) internal {
540     require(value <= _balances[from]);
541     require(to != address(0));
542 
543     _balances[from] = _balances[from].sub(value);
544     _balances[to] = _balances[to].add(value);
545     emit Transfer(from, to, value);
546   }
547 
548   /**
549    * @dev Internal function that mints an amount of the token and assigns it to
550    * an account. This encapsulates the modification of balances such that the
551    * proper events are emitted.
552    * @param account The account that will receive the created tokens.
553    * @param value The amount that will be created.
554    */
555   function _mint(address account, uint256 value) internal {
556     require(account != 0);
557     _totalSupply = _totalSupply.add(value);
558     _balances[account] = _balances[account].add(value);
559     emit Transfer(address(0), account, value);
560   }
561 
562   /**
563    * @dev Internal function that burns an amount of the token of a given
564    * account.
565    * @param account The account whose tokens will be burnt.
566    * @param value The amount that will be burnt.
567    */
568   function _burn(address account, uint256 value) internal {
569     require(account != 0);
570     require(value <= _balances[account]);
571 
572     _totalSupply = _totalSupply.sub(value);
573     _balances[account] = _balances[account].sub(value);
574     emit Transfer(account, address(0), value);
575   }
576 
577   /**
578    * @dev Internal function that burns an amount of the token of a given
579    * account, deducting from the sender's allowance for said account. Uses the
580    * internal burn function.
581    * @param account The account whose tokens will be burnt.
582    * @param value The amount that will be burnt.
583    */
584   function _burnFrom(address account, uint256 value) internal {
585     require(value <= _allowed[account][msg.sender]);
586 
587     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
588     // this function needs to emit an event with the updated approval.
589     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
590       value);
591     _burn(account, value);
592   }
593 }
594 
595 
596 /**
597  * @title TokenTimelock
598  * @dev TokenTimelock is a token holder contract that will allow a
599  * beneficiary to extract the tokens after a given release time
600  */
601 contract TokenTimelock {
602   using SafeERC20 for IERC20;
603 
604   // ERC20 basic token contract being held
605   IERC20 private _token;
606 
607   // beneficiary of tokens after they are released
608   address private _beneficiary;
609 
610   // timestamp when token release is enabled
611   uint256 private _releaseTime;
612 
613   constructor(
614     IERC20 token,
615     address beneficiary,
616     uint256 releaseTime
617   )
618     public
619   {
620     // solium-disable-next-line security/no-block-members
621     require(releaseTime > block.timestamp);
622     _token = token;
623     _beneficiary = beneficiary;
624     _releaseTime = releaseTime;
625   }
626 
627   /**
628    * @return the token being held.
629    */
630   function token() public view returns(IERC20) {
631     return _token;
632   }
633 
634   /**
635    * @return the beneficiary of the tokens.
636    */
637   function beneficiary() public view returns(address) {
638     return _beneficiary;
639   }
640 
641   /**
642    * @return the time when the tokens are released.
643    */
644   function releaseTime() public view returns(uint256) {
645     return _releaseTime;
646   }
647 
648   /**
649    * @notice Transfers tokens held by timelock to beneficiary.
650    */
651   function release() public {
652     // solium-disable-next-line security/no-block-members
653     require(block.timestamp >= _releaseTime);
654 
655     uint256 amount = _token.balanceOf(address(this));
656     require(amount > 0);
657 
658     _token.safeTransfer(_beneficiary, amount);
659   }
660 }
661 
662 
663 /**
664  * @title Pausable
665  * @dev Base contract which allows children to implement an emergency stop mechanism.
666  */
667 contract Pausable is PauserRole {
668   event Paused();
669   event Unpaused();
670 
671   bool private _paused = false;
672 
673   /**
674    * @return true if the contract is paused, false otherwise.
675    */
676   function paused() public view returns(bool) {
677     return _paused;
678   }
679 
680   /**
681    * @dev Modifier to make a function callable only when the contract is not paused.
682    */
683   modifier whenNotPaused() {
684     require(!_paused);
685     _;
686   }
687 
688   /**
689    * @dev Modifier to make a function callable only when the contract is paused.
690    */
691   modifier whenPaused() {
692     require(_paused);
693     _;
694   }
695 
696   /**
697    * @dev called by the owner to pause, triggers stopped state
698    */
699   function pause() public onlyPauser whenNotPaused {
700     _paused = true;
701     emit Paused();
702   }
703 
704   /**
705    * @dev called by the owner to unpause, returns to normal state
706    */
707   function unpause() public onlyPauser whenPaused {
708     _paused = false;
709     emit Unpaused();
710   }
711 }
712 
713 
714 /**
715  * @title ERC20Mintable
716  * @dev ERC20 minting logic
717  */
718 contract ERC20Mintable is ERC20, MinterRole {
719   /**
720    * @dev Function to mint tokens
721    * @param to The address that will receive the minted tokens.
722    * @param value The amount of tokens to mint.
723    * @return A boolean that indicates if the operation was successful.
724    */
725   function mint(
726     address to,
727     uint256 value
728   )
729     public
730     onlyMinter
731     returns (bool)
732   {
733     _mint(to, value);
734     return true;
735   }
736 }
737 
738 
739 /**
740  * @title Burnable Token
741  * @dev Token that can be irreversibly burned (destroyed).
742  */
743 contract ERC20Burnable is ERC20 {
744 
745   /**
746    * @dev Burns a specific amount of tokens.
747    * @param value The amount of token to be burned.
748    */
749   function burn(uint256 value) public {
750     _burn(msg.sender, value);
751   }
752 
753   /**
754    * @dev Burns a specific amount of tokens from the target address and decrements allowance
755    * @param from address The address which you want to send tokens from
756    * @param value uint256 The amount of token to be burned
757    */
758   function burnFrom(address from, uint256 value) public {
759     _burnFrom(from, value);
760   }
761 }
762 
763 
764 /**
765  * @title Pausable token
766  * @dev ERC20 modified with pausable transfers.
767  **/
768 contract ERC20Pausable is ERC20, Pausable {
769 
770   function transfer(
771     address to,
772     uint256 value
773   )
774     public
775     whenNotPaused
776     returns (bool)
777   {
778     return super.transfer(to, value);
779   }
780 
781   function transferFrom(
782     address from,
783     address to,
784     uint256 value
785   )
786     public
787     whenNotPaused
788     returns (bool)
789   {
790     return super.transferFrom(from, to, value);
791   }
792 
793   function approve(
794     address spender,
795     uint256 value
796   )
797     public
798     whenNotPaused
799     returns (bool)
800   {
801     return super.approve(spender, value);
802   }
803 
804   function increaseAllowance(
805     address spender,
806     uint addedValue
807   )
808     public
809     whenNotPaused
810     returns (bool success)
811   {
812     return super.increaseAllowance(spender, addedValue);
813   }
814 
815   function decreaseAllowance(
816     address spender,
817     uint subtractedValue
818   )
819     public
820     whenNotPaused
821     returns (bool success)
822   {
823     return super.decreaseAllowance(spender, subtractedValue);
824   }
825 }
826 
827 
828 contract DAVID is ERC20Pausable, ERC20Burnable, ERC20Mintable {
829 
830   string public constant name = "DAVID";
831   string public constant symbol = "DVD";
832   uint8 public constant decimals = 18;
833   uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
834 
835   /**
836    * @dev Constructor that gives msg.sender all of existing tokens.
837    */
838   constructor() public {
839     _mint(msg.sender, INITIAL_SUPPLY);
840   }
841 
842 }