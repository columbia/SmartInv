1 pragma solidity ^0.4.24;
2 // ----------------------------------------------------------------------------
3 // TOKENMOM DECENTRALIZED EXCHANGE Token(TM) Smart Contract V.1.1
4 // 토큰맘 탈중앙화거래소 토큰(TM) 스마트 컨트랙트 버전1.1
5 // Exchange URL : https://tokenmom.com
6 // Trading FEE  : 0.00% Event (Maker and Taker)
7 // Symbol       : TM
8 // Name         : TOKENMOM Token
9 // Decimals     : 18
10 // Total supply : 2,000,000,000
11 // 40%	800,000,000	Free TM token to Tokenmom users(Rewards & Referral)
12 // 30%	600,000,000	Founder, team, exchange maintenance
13 // 20%	400,000,000	Price stability and maintenance of TM Token(Burning)
14 // 10%	200,000,000	Reserved funds to prepare for problems
15 // 100%	2,000,000,000	TOTAL SUPPLY
16 // ----------------------------------------------------------------------------
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address private _owner;
25 
26   event OwnershipRenounced(address indexed previousOwner);
27   event OwnershipTransferred(
28     address indexed previousOwner,
29     address indexed newOwner
30   );
31 
32   /**
33    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
34    * account.
35    */
36   constructor() public {
37     _owner = msg.sender;
38   }
39 
40   /**
41    * @return the address of the owner.
42    */
43   function owner() public view returns(address) {
44     return _owner;
45   }
46 
47   /**
48    * @dev Throws if called by any account other than the owner.
49    */
50   modifier onlyOwner() {
51     require(isOwner());
52     _;
53   }
54 
55   /**
56    * @return true if `msg.sender` is the owner of the contract.
57    */
58   function isOwner() public view returns(bool) {
59     return msg.sender == _owner;
60   }
61 
62   /**
63    * @dev Allows the current owner to relinquish control of the contract.
64    * @notice Renouncing to ownership will leave the contract without an owner.
65    * It will not be possible to call the functions with the `onlyOwner`
66    * modifier anymore.
67    */
68   function renounceOwnership() public onlyOwner {
69     emit OwnershipRenounced(_owner);
70     _owner = address(0);
71   }
72 
73   /**
74    * @dev Allows the current owner to transfer control of the contract to a newOwner.
75    * @param newOwner The address to transfer ownership to.
76    */
77   function transferOwnership(address newOwner) public onlyOwner {
78     _transferOwnership(newOwner);
79   }
80 
81   /**
82    * @dev Transfers control of the contract to a newOwner.
83    * @param newOwner The address to transfer ownership to.
84    */
85   function _transferOwnership(address newOwner) internal {
86     require(newOwner != address(0));
87     emit OwnershipTransferred(_owner, newOwner);
88     _owner = newOwner;
89   }
90 }
91 
92 
93 /**
94  * @title SafeMath
95  * @dev Math operations with safety checks that revert on error
96  */
97 library SafeMath {
98 
99   /**
100   * @dev Multiplies two numbers, reverts on overflow.
101   */
102   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
103     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
104     // benefit is lost if 'b' is also tested.
105     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
106     if (a == 0) {
107       return 0;
108     }
109 
110     uint256 c = a * b;
111     require(c / a == b);
112 
113     return c;
114   }
115 
116   /**
117   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
118   */
119   function div(uint256 a, uint256 b) internal pure returns (uint256) {
120     require(b > 0); // Solidity only automatically asserts when dividing by 0
121     uint256 c = a / b;
122     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123 
124     return c;
125   }
126 
127   /**
128   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
129   */
130   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
131     require(b <= a);
132     uint256 c = a - b;
133 
134     return c;
135   }
136 
137   /**
138   * @dev Adds two numbers, reverts on overflow.
139   */
140   function add(uint256 a, uint256 b) internal pure returns (uint256) {
141     uint256 c = a + b;
142     require(c >= a);
143 
144     return c;
145   }
146 
147   /**
148   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
149   * reverts when dividing by zero.
150   */
151   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
152     require(b != 0);
153     return a % b;
154   }
155 }
156 
157 
158 /**
159  * @title ERC20 interface
160  * @dev see https://github.com/ethereum/EIPs/issues/20
161  */
162 interface IERC20 {
163   function totalSupply() external view returns (uint256);
164 
165   function balanceOf(address who) external view returns (uint256);
166 
167   function allowance(address owner, address spender)
168     external view returns (uint256);
169 
170   function transfer(address to, uint256 value) external returns (bool);
171 
172   function approve(address spender, uint256 value)
173     external returns (bool);
174 
175   function transferFrom(address from, address to, uint256 value)
176     external returns (bool);
177 
178   event Transfer(
179     address indexed from,
180     address indexed to,
181     uint256 value
182   );
183 
184   event Approval(
185     address indexed owner,
186     address indexed spender,
187     uint256 value
188   );
189 }
190 
191 
192 /**
193  * @title SafeERC20
194  * @dev Wrappers around ERC20 operations that throw on failure.
195  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
196  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
197  */
198 library SafeERC20 {
199   function safeTransfer(
200     IERC20 token,
201     address to,
202     uint256 value
203   )
204     internal
205   {
206     require(token.transfer(to, value));
207   }
208 
209   function safeTransferFrom(
210     IERC20 token,
211     address from,
212     address to,
213     uint256 value
214   )
215     internal
216   {
217     require(token.transferFrom(from, to, value));
218   }
219 
220   function safeApprove(
221     IERC20 token,
222     address spender,
223     uint256 value
224   )
225     internal
226   {
227     require(token.approve(spender, value));
228   }
229 }
230 
231 
232 /**
233  * @title Roles
234  * @dev Library for managing addresses assigned to a Role.
235  */
236 library Roles {
237   struct Role {
238     mapping (address => bool) bearer;
239   }
240 
241   /**
242    * @dev give an account access to this role
243    */
244   function add(Role storage role, address account) internal {
245     require(account != address(0));
246     role.bearer[account] = true;
247   }
248 
249   /**
250    * @dev remove an account's access to this role
251    */
252   function remove(Role storage role, address account) internal {
253     require(account != address(0));
254     role.bearer[account] = false;
255   }
256 
257   /**
258    * @dev check if an account has this role
259    * @return bool
260    */
261   function has(Role storage role, address account)
262     internal
263     view
264     returns (bool)
265   {
266     require(account != address(0));
267     return role.bearer[account];
268   }
269 }
270 
271 
272 contract SignerRole {
273   using Roles for Roles.Role;
274 
275   event SignerAdded(address indexed account);
276   event SignerRemoved(address indexed account);
277 
278   Roles.Role private signers;
279 
280   constructor() public {
281     _addSigner(msg.sender);
282   }
283 
284   modifier onlySigner() {
285     require(isSigner(msg.sender));
286     _;
287   }
288 
289   function isSigner(address account) public view returns (bool) {
290     return signers.has(account);
291   }
292 
293   function addSigner(address account) public onlySigner {
294     _addSigner(account);
295   }
296 
297   function renounceSigner() public {
298     _removeSigner(msg.sender);
299   }
300 
301   function _addSigner(address account) internal {
302     signers.add(account);
303     emit SignerAdded(account);
304   }
305 
306   function _removeSigner(address account) internal {
307     signers.remove(account);
308     emit SignerRemoved(account);
309   }
310 }
311 
312 
313 contract MinterRole {
314   using Roles for Roles.Role;
315 
316   event MinterAdded(address indexed account);
317   event MinterRemoved(address indexed account);
318 
319   Roles.Role private minters;
320 
321   constructor() public {
322     _addMinter(msg.sender);
323   }
324 
325   modifier onlyMinter() {
326     require(isMinter(msg.sender));
327     _;
328   }
329 
330   function isMinter(address account) public view returns (bool) {
331     return minters.has(account);
332   }
333 
334   function addMinter(address account) public onlyMinter {
335     _addMinter(account);
336   }
337 
338   function renounceMinter() public {
339     _removeMinter(msg.sender);
340   }
341 
342   function _addMinter(address account) internal {
343     minters.add(account);
344     emit MinterAdded(account);
345   }
346 
347   function _removeMinter(address account) internal {
348     minters.remove(account);
349     emit MinterRemoved(account);
350   }
351 }
352 
353 
354 contract PauserRole {
355   using Roles for Roles.Role;
356 
357   event PauserAdded(address indexed account);
358   event PauserRemoved(address indexed account);
359 
360   Roles.Role private pausers;
361 
362   constructor() public {
363     _addPauser(msg.sender);
364   }
365 
366   modifier onlyPauser() {
367     require(isPauser(msg.sender));
368     _;
369   }
370 
371   function isPauser(address account) public view returns (bool) {
372     return pausers.has(account);
373   }
374 
375   function addPauser(address account) public onlyPauser {
376     _addPauser(account);
377   }
378 
379   function renouncePauser() public {
380     _removePauser(msg.sender);
381   }
382 
383   function _addPauser(address account) internal {
384     pausers.add(account);
385     emit PauserAdded(account);
386   }
387 
388   function _removePauser(address account) internal {
389     pausers.remove(account);
390     emit PauserRemoved(account);
391   }
392 }
393 
394 
395 /**
396  * @title Standard ERC20 token
397  *
398  * @dev Implementation of the basic standard token.
399  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
400  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
401  */
402 contract ERC20 is IERC20 {
403   using SafeMath for uint256;
404 
405   mapping (address => uint256) private _balances;
406 
407   mapping (address => mapping (address => uint256)) private _allowed;
408 
409   uint256 private _totalSupply;
410 
411   /**
412   * @dev Total number of tokens in existence
413   */
414   function totalSupply() public view returns (uint256) {
415     return _totalSupply;
416   }
417 
418   /**
419   * @dev Gets the balance of the specified address.
420   * @param owner The address to query the balance of.
421   * @return An uint256 representing the amount owned by the passed address.
422   */
423   function balanceOf(address owner) public view returns (uint256) {
424     return _balances[owner];
425   }
426 
427   /**
428    * @dev Function to check the amount of tokens that an owner allowed to a spender.
429    * @param owner address The address which owns the funds.
430    * @param spender address The address which will spend the funds.
431    * @return A uint256 specifying the amount of tokens still available for the spender.
432    */
433   function allowance(
434     address owner,
435     address spender
436    )
437     public
438     view
439     returns (uint256)
440   {
441     return _allowed[owner][spender];
442   }
443 
444   /**
445   * @dev Transfer token for a specified address
446   * @param to The address to transfer to.
447   * @param value The amount to be transferred.
448   */
449   function transfer(address to, uint256 value) public returns (bool) {
450     _transfer(msg.sender, to, value);
451     return true;
452   }
453 
454   /**
455    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
456    * Beware that changing an allowance with this method brings the risk that someone may use both the old
457    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
458    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
459    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
460    * @param spender The address which will spend the funds.
461    * @param value The amount of tokens to be spent.
462    */
463   function approve(address spender, uint256 value) public returns (bool) {
464     require(spender != address(0));
465 
466     _allowed[msg.sender][spender] = value;
467     emit Approval(msg.sender, spender, value);
468     return true;
469   }
470 
471   /**
472    * @dev Transfer tokens from one address to another
473    * @param from address The address which you want to send tokens from
474    * @param to address The address which you want to transfer to
475    * @param value uint256 the amount of tokens to be transferred
476    */
477   function transferFrom(
478     address from,
479     address to,
480     uint256 value
481   )
482     public
483     returns (bool)
484   {
485     require(value <= _allowed[from][msg.sender]);
486 
487     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
488     _transfer(from, to, value);
489     return true;
490   }
491 
492   /**
493    * @dev Increase the amount of tokens that an owner allowed to a spender.
494    * approve should be called when allowed_[_spender] == 0. To increment
495    * allowed value is better to use this function to avoid 2 calls (and wait until
496    * the first transaction is mined)
497    * From MonolithDAO Token.sol
498    * @param spender The address which will spend the funds.
499    * @param addedValue The amount of tokens to increase the allowance by.
500    */
501   function increaseAllowance(
502     address spender,
503     uint256 addedValue
504   )
505     public
506     returns (bool)
507   {
508     require(spender != address(0));
509 
510     _allowed[msg.sender][spender] = (
511       _allowed[msg.sender][spender].add(addedValue));
512     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
513     return true;
514   }
515 
516   /**
517    * @dev Decrease the amount of tokens that an owner allowed to a spender.
518    * approve should be called when allowed_[_spender] == 0. To decrement
519    * allowed value is better to use this function to avoid 2 calls (and wait until
520    * the first transaction is mined)
521    * From MonolithDAO Token.sol
522    * @param spender The address which will spend the funds.
523    * @param subtractedValue The amount of tokens to decrease the allowance by.
524    */
525   function decreaseAllowance(
526     address spender,
527     uint256 subtractedValue
528   )
529     public
530     returns (bool)
531   {
532     require(spender != address(0));
533 
534     _allowed[msg.sender][spender] = (
535       _allowed[msg.sender][spender].sub(subtractedValue));
536     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
537     return true;
538   }
539 
540   /**
541   * @dev Transfer token for a specified addresses
542   * @param from The address to transfer from.
543   * @param to The address to transfer to.
544   * @param value The amount to be transferred.
545   */
546   function _transfer(address from, address to, uint256 value) internal {
547     require(value <= _balances[from]);
548     require(to != address(0));
549 
550     _balances[from] = _balances[from].sub(value);
551     _balances[to] = _balances[to].add(value);
552     emit Transfer(from, to, value);
553   }
554 
555   /**
556    * @dev Internal function that mints an amount of the token and assigns it to
557    * an account. This encapsulates the modification of balances such that the
558    * proper events are emitted.
559    * @param account The account that will receive the created tokens.
560    * @param value The amount that will be created.
561    */
562   function _mint(address account, uint256 value) internal {
563     require(account != 0);
564     _totalSupply = _totalSupply.add(value);
565     _balances[account] = _balances[account].add(value);
566     emit Transfer(address(0), account, value);
567   }
568 
569   /**
570    * @dev Internal function that burns an amount of the token of a given
571    * account.
572    * @param account The account whose tokens will be burnt.
573    * @param value The amount that will be burnt.
574    */
575   function _burn(address account, uint256 value) internal {
576     require(account != 0);
577     require(value <= _balances[account]);
578 
579     _totalSupply = _totalSupply.sub(value);
580     _balances[account] = _balances[account].sub(value);
581     emit Transfer(account, address(0), value);
582   }
583 
584   /**
585    * @dev Internal function that burns an amount of the token of a given
586    * account, deducting from the sender's allowance for said account. Uses the
587    * internal burn function.
588    * @param account The account whose tokens will be burnt.
589    * @param value The amount that will be burnt.
590    */
591   function _burnFrom(address account, uint256 value) internal {
592     require(value <= _allowed[account][msg.sender]);
593 
594     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
595     // this function needs to emit an event with the updated approval.
596     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
597       value);
598     _burn(account, value);
599   }
600 }
601 
602 
603 /**
604  * @title TokenTimelock
605  * @dev TokenTimelock is a token holder contract that will allow a
606  * beneficiary to extract the tokens after a given release time
607  */
608 contract TokenTimelock {
609   using SafeERC20 for IERC20;
610 
611   // ERC20 basic token contract being held
612   IERC20 private _token;
613 
614   // beneficiary of tokens after they are released
615   address private _beneficiary;
616 
617   // timestamp when token release is enabled
618   uint256 private _releaseTime;
619 
620   constructor(
621     IERC20 token,
622     address beneficiary,
623     uint256 releaseTime
624   )
625     public
626   {
627     // solium-disable-next-line security/no-block-members
628     require(releaseTime > block.timestamp);
629     _token = token;
630     _beneficiary = beneficiary;
631     _releaseTime = releaseTime;
632   }
633 
634   /**
635    * @return the token being held.
636    */
637   function token() public view returns(IERC20) {
638     return _token;
639   }
640 
641   /**
642    * @return the beneficiary of the tokens.
643    */
644   function beneficiary() public view returns(address) {
645     return _beneficiary;
646   }
647 
648   /**
649    * @return the time when the tokens are released.
650    */
651   function releaseTime() public view returns(uint256) {
652     return _releaseTime;
653   }
654 
655   /**
656    * @notice Transfers tokens held by timelock to beneficiary.
657    */
658   function release() public {
659     // solium-disable-next-line security/no-block-members
660     require(block.timestamp >= _releaseTime);
661 
662     uint256 amount = _token.balanceOf(address(this));
663     require(amount > 0);
664 
665     _token.safeTransfer(_beneficiary, amount);
666   }
667 }
668 
669 
670 /**
671  * @title Pausable
672  * @dev Base contract which allows children to implement an emergency stop mechanism.
673  */
674 contract Pausable is PauserRole {
675   event Paused();
676   event Unpaused();
677 
678   bool private _paused = false;
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
720 
721 /**
722  * @title ERC20Mintable
723  * @dev ERC20 minting logic
724  */
725 contract ERC20Mintable is ERC20, MinterRole {
726   /**
727    * @dev Function to mint tokens
728    * @param to The address that will receive the minted tokens.
729    * @param value The amount of tokens to mint.
730    * @return A boolean that indicates if the operation was successful.
731    */
732   function mint(
733     address to,
734     uint256 value
735   )
736     public
737     onlyMinter
738     returns (bool)
739   {
740     _mint(to, value);
741     return true;
742   }
743 }
744 
745 
746 /**
747  * @title Burnable Token
748  * @dev Token that can be irreversibly burned (destroyed).
749  */
750 contract ERC20Burnable is ERC20 {
751 
752   /**
753    * @dev Burns a specific amount of tokens.
754    * @param value The amount of token to be burned.
755    */
756   function burn(uint256 value) public {
757     _burn(msg.sender, value);
758   }
759 
760   /**
761    * @dev Burns a specific amount of tokens from the target address and decrements allowance
762    * @param from address The address which you want to send tokens from
763    * @param value uint256 The amount of token to be burned
764    */
765   function burnFrom(address from, uint256 value) public {
766     _burnFrom(from, value);
767   }
768 }
769 
770 
771 /**
772  * @title Pausable token
773  * @dev ERC20 modified with pausable transfers.
774  **/
775 contract ERC20Pausable is ERC20, Pausable {
776 
777   function transfer(
778     address to,
779     uint256 value
780   )
781     public
782     whenNotPaused
783     returns (bool)
784   {
785     return super.transfer(to, value);
786   }
787 
788   function transferFrom(
789     address from,
790     address to,
791     uint256 value
792   )
793     public
794     whenNotPaused
795     returns (bool)
796   {
797     return super.transferFrom(from, to, value);
798   }
799 
800   function approve(
801     address spender,
802     uint256 value
803   )
804     public
805     whenNotPaused
806     returns (bool)
807   {
808     return super.approve(spender, value);
809   }
810 
811   function increaseAllowance(
812     address spender,
813     uint addedValue
814   )
815     public
816     whenNotPaused
817     returns (bool success)
818   {
819     return super.increaseAllowance(spender, addedValue);
820   }
821 
822   function decreaseAllowance(
823     address spender,
824     uint subtractedValue
825   )
826     public
827     whenNotPaused
828     returns (bool success)
829   {
830     return super.decreaseAllowance(spender, subtractedValue);
831   }
832 }
833 
834 
835 contract TMtoken is ERC20Pausable, ERC20Burnable, ERC20Mintable {
836 
837   string public constant name = "Tokenmom";
838   string public constant symbol = "TM";
839   uint8 public constant decimals = 18;
840   uint256 public constant INITIAL_SUPPLY = 2000000000 * (10 ** uint256(decimals));
841  
842   /**
843    * @dev Constructor that gives msg.sender all of existing tokens.
844    */
845   constructor() public {
846     _mint(msg.sender, INITIAL_SUPPLY);
847   }
848 
849 }