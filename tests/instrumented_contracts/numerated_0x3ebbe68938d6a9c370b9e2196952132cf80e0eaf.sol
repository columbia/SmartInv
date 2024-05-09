1 pragma solidity ^0.4.25;
2 
3 // https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/IERC20.sol
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
38 
39 pragma solidity ^0.4.25;
40 
41 // https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
42 
43 /**
44  * @title SafeMath
45  * @dev Math operations with safety checks that revert on error
46  */
47 library SafeMath {
48 
49   /**
50   * @dev Multiplies two numbers, reverts on overflow.
51   */
52   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
54     // benefit is lost if 'b' is also tested.
55     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
56     if (a == 0) {
57       return 0;
58     }
59 
60     uint256 c = a * b;
61     require(c / a == b);
62 
63     return c;
64   }
65 
66   /**
67   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
68   */
69   function div(uint256 a, uint256 b) internal pure returns (uint256) {
70     require(b > 0); // Solidity only automatically asserts when dividing by 0
71     uint256 c = a / b;
72     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
73 
74     return c;
75   }
76 
77   /**
78   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
79   */
80   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
81     require(b <= a);
82     uint256 c = a - b;
83 
84     return c;
85   }
86 
87   /**
88   * @dev Adds two numbers, reverts on overflow.
89   */
90   function add(uint256 a, uint256 b) internal pure returns (uint256) {
91     uint256 c = a + b;
92     require(c >= a);
93 
94     return c;
95   }
96 
97   /**
98   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
99   * reverts when dividing by zero.
100   */
101   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
102     require(b != 0);
103     return a % b;
104   }
105 }
106 
107 pragma solidity ^0.4.25;
108 
109 // https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/SafeERC20.sol
110 
111 /**
112  * @title SafeERC20
113  * @dev Wrappers around ERC20 operations that throw on failure.
114  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
115  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
116  */
117 library SafeERC20 {
118 
119   using SafeMath for uint256;
120 
121   function safeTransfer(
122     IERC20 token,
123     address to,
124     uint256 value
125   )
126     internal
127   {
128     require(token.transfer(to, value));
129   }
130 
131   function safeTransferFrom(
132     IERC20 token,
133     address from,
134     address to,
135     uint256 value
136   )
137     internal
138   {
139     require(token.transferFrom(from, to, value));
140   }
141 
142   function safeApprove(
143     IERC20 token,
144     address spender,
145     uint256 value
146   )
147     internal
148   {
149     // safeApprove should only be called when setting an initial allowance,
150     // or when resetting it to zero. To increase and decrease it, use
151     // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
152     require((value == 0) || (token.allowance(msg.sender, spender) == 0));
153     require(token.approve(spender, value));
154   }
155 
156   function safeIncreaseAllowance(
157     IERC20 token,
158     address spender,
159     uint256 value
160   )
161     internal
162   {
163     uint256 newAllowance = token.allowance(address(this), spender).add(value);
164     require(token.approve(spender, newAllowance));
165   }
166 
167   function safeDecreaseAllowance(
168     IERC20 token,
169     address spender,
170     uint256 value
171   )
172     internal
173   {
174     uint256 newAllowance = token.allowance(address(this), spender).sub(value);
175     require(token.approve(spender, newAllowance));
176   }
177 }
178 
179 pragma solidity ^0.4.25;
180 
181 // https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/ERC20.sol
182 
183 
184 /**
185  * @title Standard ERC20 token
186  *
187  * @dev Implementation of the basic standard token.
188  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
189  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
190  */
191 contract ERC20 is IERC20 {
192   using SafeMath for uint256;
193 
194   mapping (address => uint256) private _balances;
195 
196   mapping (address => mapping (address => uint256)) private _allowed;
197 
198   uint256 private _totalSupply;
199 
200   /**
201   * @dev Total number of tokens in existence
202   */
203   function totalSupply() public view returns (uint256) {
204     return _totalSupply;
205   }
206 
207   /**
208   * @dev Gets the balance of the specified address.
209   * @param owner The address to query the balance of.
210   * @return An uint256 representing the amount owned by the passed address.
211   */
212   function balanceOf(address owner) public view returns (uint256) {
213     return _balances[owner];
214   }
215 
216   /**
217    * @dev Function to check the amount of tokens that an owner allowed to a spender.
218    * @param owner address The address which owns the funds.
219    * @param spender address The address which will spend the funds.
220    * @return A uint256 specifying the amount of tokens still available for the spender.
221    */
222   function allowance(
223     address owner,
224     address spender
225    )
226     public
227     view
228     returns (uint256)
229   {
230     return _allowed[owner][spender];
231   }
232 
233   /**
234   * @dev Transfer token for a specified address
235   * @param to The address to transfer to.
236   * @param value The amount to be transferred.
237   */
238   function transfer(address to, uint256 value) public returns (bool) {
239     _transfer(msg.sender, to, value);
240     return true;
241   }
242 
243   /**
244    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
245    * Beware that changing an allowance with this method brings the risk that someone may use both the old
246    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
247    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
248    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
249    * @param spender The address which will spend the funds.
250    * @param value The amount of tokens to be spent.
251    */
252   function approve(address spender, uint256 value) public returns (bool) {
253     require(spender != address(0));
254 
255     _allowed[msg.sender][spender] = value;
256     emit Approval(msg.sender, spender, value);
257     return true;
258   }
259 
260   /**
261    * @dev Transfer tokens from one address to another
262    * @param from address The address which you want to send tokens from
263    * @param to address The address which you want to transfer to
264    * @param value uint256 the amount of tokens to be transferred
265    */
266   function transferFrom(
267     address from,
268     address to,
269     uint256 value
270   )
271     public
272     returns (bool)
273   {
274     require(value <= _allowed[from][msg.sender]);
275 
276     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
277     _transfer(from, to, value);
278     return true;
279   }
280 
281   /**
282    * @dev Increase the amount of tokens that an owner allowed to a spender.
283    * approve should be called when allowed_[_spender] == 0. To increment
284    * allowed value is better to use this function to avoid 2 calls (and wait until
285    * the first transaction is mined)
286    * From MonolithDAO Token.sol
287    * @param spender The address which will spend the funds.
288    * @param addedValue The amount of tokens to increase the allowance by.
289    */
290   function increaseAllowance(
291     address spender,
292     uint256 addedValue
293   )
294     public
295     returns (bool)
296   {
297     require(spender != address(0));
298 
299     _allowed[msg.sender][spender] = (
300       _allowed[msg.sender][spender].add(addedValue));
301     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
302     return true;
303   }
304 
305   /**
306    * @dev Decrease the amount of tokens that an owner allowed to a spender.
307    * approve should be called when allowed_[_spender] == 0. To decrement
308    * allowed value is better to use this function to avoid 2 calls (and wait until
309    * the first transaction is mined)
310    * From MonolithDAO Token.sol
311    * @param spender The address which will spend the funds.
312    * @param subtractedValue The amount of tokens to decrease the allowance by.
313    */
314   function decreaseAllowance(
315     address spender,
316     uint256 subtractedValue
317   )
318     public
319     returns (bool)
320   {
321     require(spender != address(0));
322 
323     _allowed[msg.sender][spender] = (
324       _allowed[msg.sender][spender].sub(subtractedValue));
325     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
326     return true;
327   }
328 
329   /**
330   * @dev Transfer token for a specified addresses
331   * @param from The address to transfer from.
332   * @param to The address to transfer to.
333   * @param value The amount to be transferred.
334   */
335   function _transfer(address from, address to, uint256 value) internal {
336     require(value <= _balances[from]);
337     require(to != address(0));
338 
339     _balances[from] = _balances[from].sub(value);
340     _balances[to] = _balances[to].add(value);
341     emit Transfer(from, to, value);
342   }
343 
344   /**
345    * @dev Internal function that mints an amount of the token and assigns it to
346    * an account. This encapsulates the modification of balances such that the
347    * proper events are emitted.
348    * @param account The account that will receive the created tokens.
349    * @param value The amount that will be created.
350    */
351   function _mint(address account, uint256 value) internal {
352     require(account != 0);
353     _totalSupply = _totalSupply.add(value);
354     _balances[account] = _balances[account].add(value);
355     emit Transfer(address(0), account, value);
356   }
357 
358   /**
359    * @dev Internal function that burns an amount of the token of a given
360    * account.
361    * @param account The account whose tokens will be burnt.
362    * @param value The amount that will be burnt.
363    */
364   function _burn(address account, uint256 value) internal {
365     require(account != 0);
366     require(value <= _balances[account]);
367 
368     _totalSupply = _totalSupply.sub(value);
369     _balances[account] = _balances[account].sub(value);
370     emit Transfer(account, address(0), value);
371   }
372 
373   /**
374    * @dev Internal function that burns an amount of the token of a given
375    * account, deducting from the sender's allowance for said account. Uses the
376    * internal burn function.
377    * @param account The account whose tokens will be burnt.
378    * @param value The amount that will be burnt.
379    */
380   function _burnFrom(address account, uint256 value) internal {
381     require(value <= _allowed[account][msg.sender]);
382 
383     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
384     // this function needs to emit an event with the updated approval.
385     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
386       value);
387     _burn(account, value);
388   }
389 }
390 
391 pragma solidity ^0.4.25;
392 
393 // https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/access/Roles.sol
394 
395 /**
396  * @title Roles
397  * @dev Library for managing addresses assigned to a Role.
398  */
399 library Roles {
400   struct Role {
401     mapping (address => bool) bearer;
402   }
403 
404   /**
405    * @dev give an account access to this role
406    */
407   function add(Role storage role, address account) internal {
408     require(account != address(0));
409     require(!has(role, account));
410 
411     role.bearer[account] = true;
412   }
413 
414   /**
415    * @dev remove an account's access to this role
416    */
417   function remove(Role storage role, address account) internal {
418     require(account != address(0));
419     require(has(role, account));
420 
421     role.bearer[account] = false;
422   }
423 
424   /**
425    * @dev check if an account has this role
426    * @return bool
427    */
428   function has(Role storage role, address account)
429     internal
430     view
431     returns (bool)
432   {
433     require(account != address(0));
434     return role.bearer[account];
435   }
436 }
437 
438 
439 pragma solidity ^0.4.25;
440 
441 // https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/ERC20Detailed.sol
442 
443 /**
444  * @title ERC20Detailed token
445  * @dev The decimals are only for visualization purposes.
446  * All the operations are done using the smallest and indivisible token unit,
447  * just as on Ethereum all the operations are done in wei.
448  */
449 contract ERC20Detailed is IERC20 {
450   string private _name;
451   string private _symbol;
452   uint8 private _decimals;
453 
454   constructor(string name, string symbol, uint8 decimals) public {
455     _name = name;
456     _symbol = symbol;
457     _decimals = decimals;
458   }
459 
460   /**
461    * @return the name of the token.
462    */
463   function name() public view returns(string) {
464     return _name;
465   }
466 
467   /**
468    * @return the symbol of the token.
469    */
470   function symbol() public view returns(string) {
471     return _symbol;
472   }
473 
474   /**
475    * @return the number of decimals of the token.
476    */
477   function decimals() public view returns(uint8) {
478     return _decimals;
479   }
480 }
481 
482 
483 pragma solidity ^0.4.25;
484 
485 // https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/access/roles/MinterRole.sol
486 
487 contract MinterRole {
488   using Roles for Roles.Role;
489 
490   event MinterAdded(address indexed account);
491   event MinterRemoved(address indexed account);
492 
493   Roles.Role private minters;
494 
495   constructor() internal {
496     _addMinter(msg.sender);
497   }
498 
499   modifier onlyMinter() {
500     require(isMinter(msg.sender));
501     _;
502   }
503 
504   function isMinter(address account) public view returns (bool) {
505     return minters.has(account);
506   }
507 
508   function addMinter(address account) public onlyMinter {
509     _addMinter(account);
510   }
511 
512   function renounceMinter() public {
513     _removeMinter(msg.sender);
514   }
515 
516   function _addMinter(address account) internal {
517     minters.add(account);
518     emit MinterAdded(account);
519   }
520 
521   function _removeMinter(address account) internal {
522     minters.remove(account);
523     emit MinterRemoved(account);
524   }
525 }
526 
527 pragma solidity ^0.4.25;
528 
529 // https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/ERC20Mintable.sol
530 
531 /**
532  * @title ERC20Mintable
533  * @dev ERC20 minting logic
534  */
535 contract ERC20Mintable is ERC20, MinterRole {
536   /**
537    * @dev Function to mint tokens
538    * @param to The address that will receive the minted tokens.
539    * @param value The amount of tokens to mint.
540    * @return A boolean that indicates if the operation was successful.
541    */
542   function mint(
543     address to,
544     uint256 value
545   )
546     public
547     onlyMinter
548     returns (bool)
549   {
550     _mint(to, value);
551     return true;
552   }
553 }
554 
555 pragma solidity ^0.4.25;
556 
557 // https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/ERC20Capped.sol
558 
559 /**
560  * @title Capped token
561  * @dev Mintable token with a token cap.
562  */
563 contract ERC20Capped is ERC20Mintable {
564 
565   uint256 private _cap;
566 
567   constructor(uint256 cap)
568     public
569   {
570     require(cap > 0);
571     _cap = cap;
572   }
573 
574   /**
575    * @return the cap for the token minting.
576    */
577   function cap() public view returns(uint256) {
578     return _cap;
579   }
580 
581   function _mint(address account, uint256 value) internal {
582     require(totalSupply().add(value) <= _cap);
583     super._mint(account, value);
584   }
585 }
586 
587 
588 
589 pragma solidity ^0.4.25;
590 
591 // https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/ERC20Burnable.sol
592 
593 /**
594  * @title Burnable Token
595  * @dev Token that can be irreversibly burned (destroyed).
596  */
597 contract ERC20Burnable is ERC20 {
598 
599   /**
600    * @dev Burns a specific amount of tokens.
601    * @param value The amount of token to be burned.
602    */
603   function burn(uint256 value) public {
604     _burn(msg.sender, value);
605   }
606 
607   /**
608    * @dev Burns a specific amount of tokens from the target address and decrements allowance
609    * @param from address The address which you want to send tokens from
610    * @param value uint256 The amount of token to be burned
611    */
612   function burnFrom(address from, uint256 value) public {
613     _burnFrom(from, value);
614   }
615 }
616 
617 contract PauserRole {
618   using Roles for Roles.Role;
619 
620   event PauserAdded(address indexed account);
621   event PauserRemoved(address indexed account);
622 
623   Roles.Role private pausers;
624 
625   constructor() internal {
626     _addPauser(msg.sender);
627   }
628 
629   modifier onlyPauser() {
630     require(isPauser(msg.sender));
631     _;
632   }
633 
634   function isPauser(address account) public view returns (bool) {
635     return pausers.has(account);
636   }
637 
638   function addPauser(address account) public onlyPauser {
639     _addPauser(account);
640   }
641 
642   function renouncePauser() public {
643     _removePauser(msg.sender);
644   }
645 
646   function _addPauser(address account) internal {
647     pausers.add(account);
648     emit PauserAdded(account);
649   }
650 
651   function _removePauser(address account) internal {
652     pausers.remove(account);
653     emit PauserRemoved(account);
654   }
655 }
656 
657 /**
658  * @title Pausable
659  * @dev Base contract which allows children to implement an emergency stop mechanism.
660  */
661 contract Pausable is PauserRole {
662   event Paused(address account);
663   event Unpaused(address account);
664 
665   bool private _paused;
666 
667   constructor() internal {
668     _paused = false;
669   }
670 
671   /**
672    * @return true if the contract is paused, false otherwise.
673    */
674   function paused() public view returns(bool) {
675     return _paused;
676   }
677 
678   /**
679    * @dev Modifier to make a function callable only when the contract is not paused.
680    */
681   modifier whenNotPaused() {
682     require(!_paused);
683     _;
684   }
685 
686   /**
687    * @dev Modifier to make a function callable only when the contract is paused.
688    */
689   modifier whenPaused() {
690     require(_paused);
691     _;
692   }
693 
694   /**
695    * @dev called by the owner to pause, triggers stopped state
696    */
697   function pause() public onlyPauser whenNotPaused {
698     _paused = true;
699     emit Paused(msg.sender);
700   }
701 
702   /**
703    * @dev called by the owner to unpause, returns to normal state
704    */
705   function unpause() public onlyPauser whenPaused {
706     _paused = false;
707     emit Unpaused(msg.sender);
708   }
709 }
710 
711 pragma solidity ^0.4.25;
712 
713 // https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/ERC20Pausable.sol
714 
715 /**
716  * @title Pausable token
717  * @dev ERC20 modified with pausable transfers.
718  **/
719 contract ERC20Pausable is ERC20, Pausable {
720 
721   function transfer(
722     address to,
723     uint256 value
724   )
725     public
726     whenNotPaused
727     returns (bool)
728   {
729     return super.transfer(to, value);
730   }
731 
732   function transferFrom(
733     address from,
734     address to,
735     uint256 value
736   )
737     public
738     whenNotPaused
739     returns (bool)
740   {
741     return super.transferFrom(from, to, value);
742   }
743 
744   function approve(
745     address spender,
746     uint256 value
747   )
748     public
749     whenNotPaused
750     returns (bool)
751   {
752     return super.approve(spender, value);
753   }
754 
755   function increaseAllowance(
756     address spender,
757     uint addedValue
758   )
759     public
760     whenNotPaused
761     returns (bool success)
762   {
763     return super.increaseAllowance(spender, addedValue);
764   }
765 
766   function decreaseAllowance(
767     address spender,
768     uint subtractedValue
769   )
770     public
771     whenNotPaused
772     returns (bool success)
773   {
774     return super.decreaseAllowance(spender, subtractedValue);
775   }
776 }
777 
778 
779 /**
780  * @title Frtehan
781  * @dev All tokens are pre-assigned to the creator.
782  */
783 contract Frethan is ERC20Detailed, ERC20, ERC20Mintable, ERC20Burnable, ERC20Capped, ERC20Pausable {
784     using SafeMath for uint256;
785     using SafeERC20 for ERC20;
786 
787     // Contract Details
788     uint8 private constant _DECIMALS = 18;                      // Standard - Best not to change
789     string private constant _NAME = "Frethan";                  // Frethan - Name always
790     string private constant _SYMBOL = "FAE";                    // FAE - Sybmbol for Live Network
791     uint256 private constant _SUPPLY = 10000000000;             // 10 Billion
792 
793     // Calculate Intial Supply
794     uint256 public initialSupply = _SUPPLY * (10 ** uint256(_DECIMALS));
795 
796     // Variables for Contract Details
797     string public name;
798     string public symbol;
799     uint8 public decimals;
800 
801     constructor()
802         ERC20Detailed (_NAME, _SYMBOL, _DECIMALS)
803         ERC20Capped (initialSupply)
804         public
805         {
806           // Set Contract Details
807           name = _NAME;
808           symbol = _SYMBOL;
809           decimals = _DECIMALS;
810 
811           // Mint the InitialSupply
812           _mint(msg.sender, initialSupply);
813 
814         }
815         
816 
817     }