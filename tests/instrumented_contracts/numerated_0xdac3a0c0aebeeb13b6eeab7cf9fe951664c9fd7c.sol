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
12 // 40%	800,000,000	Founder, team, exchange ecosystem & maintenance
13 // 10%	200,000,000	Price stability and maintenance of TM Token(Burning)
14 // 10%	200,000,000	Reserved funds to prepare for future problems
15 // ----------------------------------------------------------------------------
16 
17 /**
18  * @title Ownable
19  * @dev The Ownable contract has an owner address, and provides basic authorization control
20  * functions, this simplifies the implementation of "user permissions".
21  */
22 contract Ownable {
23   address private _owner;
24 
25   event OwnershipRenounced(address indexed previousOwner);
26   event OwnershipTransferred(
27     address indexed previousOwner,
28     address indexed newOwner
29   );
30 
31   /**
32    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
33    * account.
34    */
35   constructor() public {
36     _owner = msg.sender;
37   }
38 
39   /**
40    * @return the address of the owner.
41    */
42   function owner() public view returns(address) {
43     return _owner;
44   }
45 
46   /**
47    * @dev Throws if called by any account other than the owner.
48    */
49   modifier onlyOwner() {
50     require(isOwner());
51     _;
52   }
53 
54   /**
55    * @return true if `msg.sender` is the owner of the contract.
56    */
57   function isOwner() public view returns(bool) {
58     return msg.sender == _owner;
59   }
60 
61   /**
62    * @dev Allows the current owner to relinquish control of the contract.
63    * @notice Renouncing to ownership will leave the contract without an owner.
64    * It will not be possible to call the functions with the `onlyOwner`
65    * modifier anymore.
66    */
67   function renounceOwnership() public onlyOwner {
68     emit OwnershipRenounced(_owner);
69     _owner = address(0);
70   }
71 
72   /**
73    * @dev Allows the current owner to transfer control of the contract to a newOwner.
74    * @param newOwner The address to transfer ownership to.
75    */
76   function transferOwnership(address newOwner) public onlyOwner {
77     _transferOwnership(newOwner);
78   }
79 
80   /**
81    * @dev Transfers control of the contract to a newOwner.
82    * @param newOwner The address to transfer ownership to.
83    */
84   function _transferOwnership(address newOwner) internal {
85     require(newOwner != address(0));
86     emit OwnershipTransferred(_owner, newOwner);
87     _owner = newOwner;
88   }
89 }
90 
91 
92 /**
93  * @title SafeMath
94  * @dev Math operations with safety checks that revert on error
95  */
96 library SafeMath {
97 
98   /**
99   * @dev Multiplies two numbers, reverts on overflow.
100   */
101   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
102     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
103     // benefit is lost if 'b' is also tested.
104     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
105     if (a == 0) {
106       return 0;
107     }
108 
109     uint256 c = a * b;
110     require(c / a == b);
111 
112     return c;
113   }
114 
115   /**
116   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
117   */
118   function div(uint256 a, uint256 b) internal pure returns (uint256) {
119     require(b > 0); // Solidity only automatically asserts when dividing by 0
120     uint256 c = a / b;
121     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122 
123     return c;
124   }
125 
126   /**
127   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
128   */
129   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
130     require(b <= a);
131     uint256 c = a - b;
132 
133     return c;
134   }
135 
136   /**
137   * @dev Adds two numbers, reverts on overflow.
138   */
139   function add(uint256 a, uint256 b) internal pure returns (uint256) {
140     uint256 c = a + b;
141     require(c >= a);
142 
143     return c;
144   }
145 
146   /**
147   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
148   * reverts when dividing by zero.
149   */
150   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
151     require(b != 0);
152     return a % b;
153   }
154 }
155 
156 
157 /**
158  * @title ERC20 interface
159  * @dev see https://github.com/ethereum/EIPs/issues/20
160  */
161 interface IERC20 {
162   function totalSupply() external view returns (uint256);
163 
164   function balanceOf(address who) external view returns (uint256);
165 
166   function allowance(address owner, address spender)
167     external view returns (uint256);
168 
169   function transfer(address to, uint256 value) external returns (bool);
170 
171   function approve(address spender, uint256 value)
172     external returns (bool);
173 
174   function transferFrom(address from, address to, uint256 value)
175     external returns (bool);
176 
177   event Transfer(
178     address indexed from,
179     address indexed to,
180     uint256 value
181   );
182 
183   event Approval(
184     address indexed owner,
185     address indexed spender,
186     uint256 value
187   );
188 }
189 
190 
191 /**
192  * @title SafeERC20
193  * @dev Wrappers around ERC20 operations that throw on failure.
194  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
195  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
196  */
197 library SafeERC20 {
198   function safeTransfer(
199     IERC20 token,
200     address to,
201     uint256 value
202   )
203     internal
204   {
205     require(token.transfer(to, value));
206   }
207 
208   function safeTransferFrom(
209     IERC20 token,
210     address from,
211     address to,
212     uint256 value
213   )
214     internal
215   {
216     require(token.transferFrom(from, to, value));
217   }
218 
219   function safeApprove(
220     IERC20 token,
221     address spender,
222     uint256 value
223   )
224     internal
225   {
226     require(token.approve(spender, value));
227   }
228 }
229 
230 
231 /**
232  * @title Roles
233  * @dev Library for managing addresses assigned to a Role.
234  */
235 library Roles {
236   struct Role {
237     mapping (address => bool) bearer;
238   }
239 
240   /**
241    * @dev give an account access to this role
242    */
243   function add(Role storage role, address account) internal {
244     require(account != address(0));
245     role.bearer[account] = true;
246   }
247 
248   /**
249    * @dev remove an account's access to this role
250    */
251   function remove(Role storage role, address account) internal {
252     require(account != address(0));
253     role.bearer[account] = false;
254   }
255 
256   /**
257    * @dev check if an account has this role
258    * @return bool
259    */
260   function has(Role storage role, address account)
261     internal
262     view
263     returns (bool)
264   {
265     require(account != address(0));
266     return role.bearer[account];
267   }
268 }
269 
270 
271 contract SignerRole {
272   using Roles for Roles.Role;
273 
274   event SignerAdded(address indexed account);
275   event SignerRemoved(address indexed account);
276 
277   Roles.Role private signers;
278 
279   constructor() public {
280     _addSigner(msg.sender);
281   }
282 
283   modifier onlySigner() {
284     require(isSigner(msg.sender));
285     _;
286   }
287 
288   function isSigner(address account) public view returns (bool) {
289     return signers.has(account);
290   }
291 
292   function addSigner(address account) public onlySigner {
293     _addSigner(account);
294   }
295 
296   function renounceSigner() public {
297     _removeSigner(msg.sender);
298   }
299 
300   function _addSigner(address account) internal {
301     signers.add(account);
302     emit SignerAdded(account);
303   }
304 
305   function _removeSigner(address account) internal {
306     signers.remove(account);
307     emit SignerRemoved(account);
308   }
309 }
310 
311 
312 contract MinterRole {
313   using Roles for Roles.Role;
314 
315   event MinterAdded(address indexed account);
316   event MinterRemoved(address indexed account);
317 
318   Roles.Role private minters;
319 
320   constructor() public {
321     _addMinter(msg.sender);
322   }
323 
324   modifier onlyMinter() {
325     require(isMinter(msg.sender));
326     _;
327   }
328 
329   function isMinter(address account) public view returns (bool) {
330     return minters.has(account);
331   }
332 
333   function addMinter(address account) public onlyMinter {
334     _addMinter(account);
335   }
336 
337   function renounceMinter() public {
338     _removeMinter(msg.sender);
339   }
340 
341   function _addMinter(address account) internal {
342     minters.add(account);
343     emit MinterAdded(account);
344   }
345 
346   function _removeMinter(address account) internal {
347     minters.remove(account);
348     emit MinterRemoved(account);
349   }
350 }
351 
352 
353 contract PauserRole {
354   using Roles for Roles.Role;
355 
356   event PauserAdded(address indexed account);
357   event PauserRemoved(address indexed account);
358 
359   Roles.Role private pausers;
360 
361   constructor() public {
362     _addPauser(msg.sender);
363   }
364 
365   modifier onlyPauser() {
366     require(isPauser(msg.sender));
367     _;
368   }
369 
370   function isPauser(address account) public view returns (bool) {
371     return pausers.has(account);
372   }
373 
374   function addPauser(address account) public onlyPauser {
375     _addPauser(account);
376   }
377 
378   function renouncePauser() public {
379     _removePauser(msg.sender);
380   }
381 
382   function _addPauser(address account) internal {
383     pausers.add(account);
384     emit PauserAdded(account);
385   }
386 
387   function _removePauser(address account) internal {
388     pausers.remove(account);
389     emit PauserRemoved(account);
390   }
391 }
392 
393 
394 /**
395  * @title Standard ERC20 token
396  *
397  * @dev Implementation of the basic standard token.
398  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
399  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
400  */
401 contract ERC20 is IERC20 {
402   using SafeMath for uint256;
403 
404   mapping (address => uint256) private _balances;
405 
406   mapping (address => mapping (address => uint256)) private _allowed;
407 
408   uint256 private _totalSupply;
409 
410   /**
411   * @dev Total number of tokens in existence
412   */
413   function totalSupply() public view returns (uint256) {
414     return _totalSupply;
415   }
416 
417   /**
418   * @dev Gets the balance of the specified address.
419   * @param owner The address to query the balance of.
420   * @return An uint256 representing the amount owned by the passed address.
421   */
422   function balanceOf(address owner) public view returns (uint256) {
423     return _balances[owner];
424   }
425 
426   /**
427    * @dev Function to check the amount of tokens that an owner allowed to a spender.
428    * @param owner address The address which owns the funds.
429    * @param spender address The address which will spend the funds.
430    * @return A uint256 specifying the amount of tokens still available for the spender.
431    */
432   function allowance(
433     address owner,
434     address spender
435    )
436     public
437     view
438     returns (uint256)
439   {
440     return _allowed[owner][spender];
441   }
442 
443   /**
444   * @dev Transfer token for a specified address
445   * @param to The address to transfer to.
446   * @param value The amount to be transferred.
447   */
448   function transfer(address to, uint256 value) public returns (bool) {
449     _transfer(msg.sender, to, value);
450     return true;
451   }
452 
453   /**
454    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
455    * Beware that changing an allowance with this method brings the risk that someone may use both the old
456    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
457    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
458    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
459    * @param spender The address which will spend the funds.
460    * @param value The amount of tokens to be spent.
461    */
462   function approve(address spender, uint256 value) public returns (bool) {
463     require(spender != address(0));
464 
465     _allowed[msg.sender][spender] = value;
466     emit Approval(msg.sender, spender, value);
467     return true;
468   }
469 
470   /**
471    * @dev Transfer tokens from one address to another
472    * @param from address The address which you want to send tokens from
473    * @param to address The address which you want to transfer to
474    * @param value uint256 the amount of tokens to be transferred
475    */
476   function transferFrom(
477     address from,
478     address to,
479     uint256 value
480   )
481     public
482     returns (bool)
483   {
484     require(value <= _allowed[from][msg.sender]);
485 
486     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
487     _transfer(from, to, value);
488     return true;
489   }
490 
491   /**
492    * @dev Increase the amount of tokens that an owner allowed to a spender.
493    * approve should be called when allowed_[_spender] == 0. To increment
494    * allowed value is better to use this function to avoid 2 calls (and wait until
495    * the first transaction is mined)
496    * From MonolithDAO Token.sol
497    * @param spender The address which will spend the funds.
498    * @param addedValue The amount of tokens to increase the allowance by.
499    */
500   function increaseAllowance(
501     address spender,
502     uint256 addedValue
503   )
504     public
505     returns (bool)
506   {
507     require(spender != address(0));
508 
509     _allowed[msg.sender][spender] = (
510       _allowed[msg.sender][spender].add(addedValue));
511     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
512     return true;
513   }
514 
515   /**
516    * @dev Decrease the amount of tokens that an owner allowed to a spender.
517    * approve should be called when allowed_[_spender] == 0. To decrement
518    * allowed value is better to use this function to avoid 2 calls (and wait until
519    * the first transaction is mined)
520    * From MonolithDAO Token.sol
521    * @param spender The address which will spend the funds.
522    * @param subtractedValue The amount of tokens to decrease the allowance by.
523    */
524   function decreaseAllowance(
525     address spender,
526     uint256 subtractedValue
527   )
528     public
529     returns (bool)
530   {
531     require(spender != address(0));
532 
533     _allowed[msg.sender][spender] = (
534       _allowed[msg.sender][spender].sub(subtractedValue));
535     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
536     return true;
537   }
538 
539   /**
540   * @dev Transfer token for a specified addresses
541   * @param from The address to transfer from.
542   * @param to The address to transfer to.
543   * @param value The amount to be transferred.
544   */
545   function _transfer(address from, address to, uint256 value) internal {
546     require(value <= _balances[from]);
547     require(to != address(0));
548 
549     _balances[from] = _balances[from].sub(value);
550     _balances[to] = _balances[to].add(value);
551     emit Transfer(from, to, value);
552   }
553 
554   /**
555    * @dev Internal function that mints an amount of the token and assigns it to
556    * an account. This encapsulates the modification of balances such that the
557    * proper events are emitted.
558    * @param account The account that will receive the created tokens.
559    * @param value The amount that will be created.
560    */
561   function _mint(address account, uint256 value) internal {
562     require(account != 0);
563     _totalSupply = _totalSupply.add(value);
564     _balances[account] = _balances[account].add(value);
565     emit Transfer(address(0), account, value);
566   }
567 
568   /**
569    * @dev Internal function that burns an amount of the token of a given
570    * account.
571    * @param account The account whose tokens will be burnt.
572    * @param value The amount that will be burnt.
573    */
574   function _burn(address account, uint256 value) internal {
575     require(account != 0);
576     require(value <= _balances[account]);
577 
578     _totalSupply = _totalSupply.sub(value);
579     _balances[account] = _balances[account].sub(value);
580     emit Transfer(account, address(0), value);
581   }
582 
583   /**
584    * @dev Internal function that burns an amount of the token of a given
585    * account, deducting from the sender's allowance for said account. Uses the
586    * internal burn function.
587    * @param account The account whose tokens will be burnt.
588    * @param value The amount that will be burnt.
589    */
590   function _burnFrom(address account, uint256 value) internal {
591     require(value <= _allowed[account][msg.sender]);
592 
593     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
594     // this function needs to emit an event with the updated approval.
595     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
596       value);
597     _burn(account, value);
598   }
599 }
600 
601 
602 /**
603  * @title TokenTimelock
604  * @dev TokenTimelock is a token holder contract that will allow a
605  * beneficiary to extract the tokens after a given release time
606  */
607 contract TokenTimelock {
608   using SafeERC20 for IERC20;
609 
610   // ERC20 basic token contract being held
611   IERC20 private _token;
612 
613   // beneficiary of tokens after they are released
614   address private _beneficiary;
615 
616   // timestamp when token release is enabled
617   uint256 private _releaseTime;
618 
619   constructor(
620     IERC20 token,
621     address beneficiary,
622     uint256 releaseTime
623   )
624     public
625   {
626     // solium-disable-next-line security/no-block-members
627     require(releaseTime > block.timestamp);
628     _token = token;
629     _beneficiary = beneficiary;
630     _releaseTime = releaseTime;
631   }
632 
633   /**
634    * @return the token being held.
635    */
636   function token() public view returns(IERC20) {
637     return _token;
638   }
639 
640   /**
641    * @return the beneficiary of the tokens.
642    */
643   function beneficiary() public view returns(address) {
644     return _beneficiary;
645   }
646 
647   /**
648    * @return the time when the tokens are released.
649    */
650   function releaseTime() public view returns(uint256) {
651     return _releaseTime;
652   }
653 
654   /**
655    * @notice Transfers tokens held by timelock to beneficiary.
656    */
657   function release() public {
658     // solium-disable-next-line security/no-block-members
659     require(block.timestamp >= _releaseTime);
660 
661     uint256 amount = _token.balanceOf(address(this));
662     require(amount > 0);
663 
664     _token.safeTransfer(_beneficiary, amount);
665   }
666 }
667 
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
679   /**
680    * @return true if the contract is paused, false otherwise.
681    */
682   function paused() public view returns(bool) {
683     return _paused;
684   }
685 
686   /**
687    * @dev Modifier to make a function callable only when the contract is not paused.
688    */
689   modifier whenNotPaused() {
690     require(!_paused);
691     _;
692   }
693 
694   /**
695    * @dev Modifier to make a function callable only when the contract is paused.
696    */
697   modifier whenPaused() {
698     require(_paused);
699     _;
700   }
701 
702   /**
703    * @dev called by the owner to pause, triggers stopped state
704    */
705   function pause() public onlyPauser whenNotPaused {
706     _paused = true;
707     emit Paused();
708   }
709 
710   /**
711    * @dev called by the owner to unpause, returns to normal state
712    */
713   function unpause() public onlyPauser whenPaused {
714     _paused = false;
715     emit Unpaused();
716   }
717 }
718 
719 
720 /**
721  * @title ERC20Mintable
722  * @dev ERC20 minting logic
723  */
724 contract ERC20Mintable is ERC20, MinterRole {
725   /**
726    * @dev Function to mint tokens
727    * @param to The address that will receive the minted tokens.
728    * @param value The amount of tokens to mint.
729    * @return A boolean that indicates if the operation was successful.
730    */
731   function mint(
732     address to,
733     uint256 value
734   )
735     public
736     onlyMinter
737     returns (bool)
738   {
739     _mint(to, value);
740     return true;
741   }
742 }
743 
744 
745 /**
746  * @title Burnable Token
747  * @dev Token that can be irreversibly burned (destroyed).
748  */
749 contract ERC20Burnable is ERC20 {
750 
751   /**
752    * @dev Burns a specific amount of tokens.
753    * @param value The amount of token to be burned.
754    */
755   function burn(uint256 value) public {
756     _burn(msg.sender, value);
757   }
758 
759   /**
760    * @dev Burns a specific amount of tokens from the target address and decrements allowance
761    * @param from address The address which you want to send tokens from
762    * @param value uint256 The amount of token to be burned
763    */
764   function burnFrom(address from, uint256 value) public {
765     _burnFrom(from, value);
766   }
767 }
768 
769 
770 /**
771  * @title Pausable token
772  * @dev ERC20 modified with pausable transfers.
773  **/
774 contract ERC20Pausable is ERC20, Pausable {
775 
776   function transfer(
777     address to,
778     uint256 value
779   )
780     public
781     whenNotPaused
782     returns (bool)
783   {
784     return super.transfer(to, value);
785   }
786 
787   function transferFrom(
788     address from,
789     address to,
790     uint256 value
791   )
792     public
793     whenNotPaused
794     returns (bool)
795   {
796     return super.transferFrom(from, to, value);
797   }
798 
799   function approve(
800     address spender,
801     uint256 value
802   )
803     public
804     whenNotPaused
805     returns (bool)
806   {
807     return super.approve(spender, value);
808   }
809 
810   function increaseAllowance(
811     address spender,
812     uint addedValue
813   )
814     public
815     whenNotPaused
816     returns (bool success)
817   {
818     return super.increaseAllowance(spender, addedValue);
819   }
820 
821   function decreaseAllowance(
822     address spender,
823     uint subtractedValue
824   )
825     public
826     whenNotPaused
827     returns (bool success)
828   {
829     return super.decreaseAllowance(spender, subtractedValue);
830   }
831 }
832 
833 
834 contract TMtoken is ERC20Pausable, ERC20Burnable, ERC20Mintable {
835 
836   string public constant name = "Tokenmom";
837   string public constant symbol = "TM";
838   uint8 public constant decimals = 18;
839   uint256 public constant INITIAL_SUPPLY = 2000000000 * (10 ** uint256(decimals));
840  
841   /**
842    * @dev Constructor that gives msg.sender all of existing tokens.
843    */
844   constructor() public {
845     _mint(msg.sender, INITIAL_SUPPLY);
846   }
847 
848 }