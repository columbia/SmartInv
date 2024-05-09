1 pragma solidity 0.5.7;
2 
3 
4 /**
5  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
6  * the optional functions; to access them see {ERC20Detailed}.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 /**
80  * @dev Wrappers over Solidity's arithmetic operations with added overflow
81  * checks.
82  *
83  * Arithmetic operations in Solidity wrap on overflow. This can easily result
84  * in bugs, because programmers usually assume that an overflow raises an
85  * error, which is the standard behavior in high level programming languages.
86  * `SafeMath` restores this intuition by reverting the transaction when an
87  * operation overflows.
88  *
89  * Using this library instead of the unchecked operations eliminates an entire
90  * class of bugs, so it's recommended to use it always.
91  */
92 library SafeMath {
93     /**
94      * @dev Returns the addition of two unsigned integers, reverting on
95      * overflow.
96      *
97      * Counterpart to Solidity's `+` operator.
98      *
99      * Requirements:
100      * - Addition cannot overflow.
101      */
102     function add(uint256 a, uint256 b) internal pure returns (uint256) {
103         uint256 c = a + b;
104         require(c >= a, "SafeMath: addition overflow");
105 
106         return c;
107     }
108 
109     /**
110      * @dev Returns the subtraction of two unsigned integers, reverting on
111      * overflow (when the result is negative).
112      *
113      * Counterpart to Solidity's `-` operator.
114      *
115      * Requirements:
116      * - Subtraction cannot overflow.
117      */
118     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
119         return sub(a, b, "SafeMath: subtraction overflow");
120     }
121 
122     /**
123      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
124      * overflow (when the result is negative).
125      *
126      * Counterpart to Solidity's `-` operator.
127      *
128      * Requirements:
129      * - Subtraction cannot overflow.
130      *
131      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
132      * @dev Get it via `npm install @openzeppelin/contracts@next`.
133      */
134     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
135         require(b <= a, errorMessage);
136         uint256 c = a - b;
137 
138         return c;
139     }
140 
141     /**
142      * @dev Returns the multiplication of two unsigned integers, reverting on
143      * overflow.
144      *
145      * Counterpart to Solidity's `*` operator.
146      *
147      * Requirements:
148      * - Multiplication cannot overflow.
149      */
150     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
151         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
152         // benefit is lost if 'b' is also tested.
153         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
154         if (a == 0) {
155             return 0;
156         }
157 
158         uint256 c = a * b;
159         require(c / a == b, "SafeMath: multiplication overflow");
160 
161         return c;
162     }
163 
164     /**
165      * @dev Returns the integer division of two unsigned integers. Reverts on
166      * division by zero. The result is rounded towards zero.
167      *
168      * Counterpart to Solidity's `/` operator. Note: this function uses a
169      * `revert` opcode (which leaves remaining gas untouched) while Solidity
170      * uses an invalid opcode to revert (consuming all remaining gas).
171      *
172      * Requirements:
173      * - The divisor cannot be zero.
174      */
175     function div(uint256 a, uint256 b) internal pure returns (uint256) {
176         return div(a, b, "SafeMath: division by zero");
177     }
178 
179     /**
180      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
181      * division by zero. The result is rounded towards zero.
182      *
183      * Counterpart to Solidity's `/` operator. Note: this function uses a
184      * `revert` opcode (which leaves remaining gas untouched) while Solidity
185      * uses an invalid opcode to revert (consuming all remaining gas).
186      *
187      * Requirements:
188      * - The divisor cannot be zero.
189      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
190      * @dev Get it via `npm install @openzeppelin/contracts@next`.
191      */
192     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
193         // Solidity only automatically asserts when dividing by 0
194         require(b > 0, errorMessage);
195         uint256 c = a / b;
196         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
197 
198         return c;
199     }
200 
201     /**
202      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
203      * Reverts when dividing by zero.
204      *
205      * Counterpart to Solidity's `%` operator. This function uses a `revert`
206      * opcode (which leaves remaining gas untouched) while Solidity uses an
207      * invalid opcode to revert (consuming all remaining gas).
208      *
209      * Requirements:
210      * - The divisor cannot be zero.
211      */
212     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
213         return mod(a, b, "SafeMath: modulo by zero");
214     }
215 
216     /**
217      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
218      * Reverts with custom message when dividing by zero.
219      *
220      * Counterpart to Solidity's `%` operator. This function uses a `revert`
221      * opcode (which leaves remaining gas untouched) while Solidity uses an
222      * invalid opcode to revert (consuming all remaining gas).
223      *
224      * Requirements:
225      * - The divisor cannot be zero.
226      *
227      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
228      * @dev Get it via `npm install @openzeppelin/contracts@next`.
229      */
230     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
231         require(b != 0, errorMessage);
232         return a % b;
233     }
234 }
235 
236 
237 /*
238  * @dev Provides information about the current execution context, including the
239  * sender of the transaction and its data. While these are generally available
240  * via msg.sender and msg.data, they should not be accessed in such a direct
241  * manner, since when dealing with GSN meta-transactions the account sending and
242  * paying for execution may not be the actual sender (as far as an application
243  * is concerned).
244  *
245  * This contract is only required for intermediate, library-like contracts.
246  */
247 contract Context {
248     // Empty internal constructor, to prevent people from mistakenly deploying
249     // an instance of this contract, which should be used via inheritance.
250     constructor () internal { }
251     // solhint-disable-previous-line no-empty-blocks
252 
253     function _msgSender() internal view returns (address payable) {
254         return msg.sender;
255     }
256 
257     function _msgData() internal view returns (bytes memory) {
258         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
259         return msg.data;
260     }
261 }
262 /**
263  * @dev Contract module which provides a basic access control mechanism, where there is an account
264  * (owner) that can be granted exclusive access to specific functions.
265  *
266  * This module is used through inheritance by using the modifier `onlyOwner`.
267  *
268  * To change ownership, use a 2-part nominate-accept pattern.
269  *
270  * This contract is loosely based off of https://git.io/JenNF but additionally requires new owners
271  * to accept ownership before the transition occurs.
272  */
273 contract Ownable is Context {
274     address private _owner;
275     address private _nominatedOwner;
276 
277     event NewOwnerNominated(address indexed previousOwner, address indexed nominee);
278     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
279 
280     /**
281      * @dev Initializes the contract setting the deployer as the initial owner.
282      */
283     constructor () internal {
284         address msgSender = _msgSender();
285         _owner = msgSender;
286         emit OwnershipTransferred(address(0), msgSender);
287     }
288 
289     /**
290      * @dev Returns the address of the current owner.
291      */
292     function owner() public view returns (address) {
293         return _owner;
294     }
295 
296     /**
297      * @dev Returns the address of the current nominated owner.
298      */
299     function nominatedOwner() external view returns (address) {
300         return _nominatedOwner;
301     }
302 
303     /**
304      * @dev Throws if called by any account other than the owner.
305      */
306     modifier onlyOwner() {
307         _onlyOwner();
308         _;
309     }
310 
311     function _onlyOwner() internal view {
312         require(_msgSender() == _owner, "caller is not owner");
313     }
314 
315     /**
316      * @dev Nominates a new owner `newOwner`.
317      * Requires a follow-up `acceptOwnership`.
318      * Can only be called by the current owner.
319      */
320     function nominateNewOwner(address newOwner) external onlyOwner {
321         require(newOwner != address(0), "new owner is 0 address");
322         emit NewOwnerNominated(_owner, newOwner);
323         _nominatedOwner = newOwner;
324     }
325 
326     /**
327      * @dev Accepts ownership of the contract.
328      */
329     function acceptOwnership() external {
330         require(_nominatedOwner == _msgSender(), "unauthorized");
331         emit OwnershipTransferred(_owner, _nominatedOwner);
332         _owner = _nominatedOwner;
333     }
334 
335     /** Set `_owner` to the 0 address.
336      * Only do this to deliberately lock in the current permissions.
337      *
338      * THIS CANNOT BE UNDONE! Call this only if you know what you're doing and why you're doing it!
339      */
340     function renounceOwnership(string calldata declaration) external onlyOwner {
341         string memory requiredDeclaration = "I hereby renounce ownership of this contract forever.";
342         require(
343             keccak256(abi.encodePacked(declaration)) ==
344             keccak256(abi.encodePacked(requiredDeclaration)),
345             "declaration incorrect");
346 
347         emit OwnershipTransferred(_owner, address(0));
348         _owner = address(0);
349     }
350 }
351 
352 
353 /**
354  * @title Eternal Storage for the Reserve Token
355  *
356  * @dev Eternal Storage facilitates future upgrades.
357  *
358  * If Reserve chooses to release an upgraded contract for the Reserve in the future, Reserve will
359  * have the option of reusing the deployed version of this data contract to simplify migration.
360  *
361  * The use of this contract does not imply that Reserve will choose to do a future upgrade, nor
362  * that any future upgrades will necessarily re-use this storage. It merely provides option value.
363  */
364 contract ReserveEternalStorage is Ownable {
365 
366     using SafeMath for uint256;
367 
368 
369     // ===== auth =====
370 
371     address public reserveAddress;
372 
373     event ReserveAddressTransferred(
374         address indexed oldReserveAddress,
375         address indexed newReserveAddress
376     );
377 
378     /// On construction, set auth fields.
379     constructor() public {
380         reserveAddress = _msgSender();
381         emit ReserveAddressTransferred(address(0), reserveAddress);
382     }
383 
384     /// Only run modified function if sent by `reserveAddress`.
385     modifier onlyReserveAddress() {
386         require(_msgSender() == reserveAddress, "onlyReserveAddress");
387         _;
388     }
389 
390     /// Set `reserveAddress`.
391     function updateReserveAddress(address newReserveAddress) external {
392         require(newReserveAddress != address(0), "zero address");
393         require(_msgSender() == reserveAddress || _msgSender() == owner(), "not authorized");
394         emit ReserveAddressTransferred(reserveAddress, newReserveAddress);
395         reserveAddress = newReserveAddress;
396     }
397 
398 
399 
400     // ===== balance =====
401 
402     mapping(address => uint256) public balance;
403 
404     /// Add `value` to `balance[key]`, unless this causes integer overflow.
405     ///
406     /// @dev This is a slight divergence from the strict Eternal Storage pattern, but it reduces
407     /// the gas for the by-far most common token usage, it's a *very simple* divergence, and
408     /// `setBalance` is available anyway.
409     function addBalance(address key, uint256 value) external onlyReserveAddress {
410         balance[key] = balance[key].add(value);
411     }
412 
413     /// Subtract `value` from `balance[key]`, unless this causes integer underflow.
414     function subBalance(address key, uint256 value) external onlyReserveAddress {
415         balance[key] = balance[key].sub(value);
416     }
417 
418     /// Set `balance[key]` to `value`.
419     function setBalance(address key, uint256 value) external onlyReserveAddress {
420         balance[key] = value;
421     }
422 
423 
424 
425     // ===== allowed =====
426 
427     mapping(address => mapping(address => uint256)) public allowed;
428 
429     /// Set `to`'s allowance of `from`'s tokens to `value`.
430     function setAllowed(address from, address to, uint256 value) external onlyReserveAddress {
431         allowed[from][to] = value;
432     }
433 }
434 
435 /**
436  * @title An interface representing a contract that calculates transaction fees
437  */
438  interface ITXFee {
439      function calculateFee(address from, address to, uint256 amount) external returns (uint256);
440  }
441 
442 /**
443  * @title The Reserve Token
444  * @dev An ERC-20 token with minting, burning, pausing, and user freezing.
445  * Based on OpenZeppelin's [implementation](https://github.com/OpenZeppelin/openzeppelin-solidity/blob/41aa39afbc13f0585634061701c883fe512a5469/contracts/token/ERC20/ERC20.sol).
446  *
447  * Non-constant-sized data is held in ReserveEternalStorage, to facilitate potential future upgrades.
448  */
449 contract Reserve is IERC20, Ownable {
450     using SafeMath for uint256;
451 
452 
453     // ==== State ====
454 
455 
456     // Non-constant-sized data
457     ReserveEternalStorage internal trustedData;
458 
459     // TX Fee helper contract
460     ITXFee public trustedTxFee;
461 
462     // Relayer
463     address public trustedRelayer;
464 
465     // Basic token data
466     uint256 public totalSupply;
467     uint256 public maxSupply;
468 
469     // Paused data
470     bool public paused;
471 
472     // Auth roles
473     address public minter;
474     address public pauser;
475     address public feeRecipient;
476 
477 
478     // ==== Events, Constants, and Constructor ====
479 
480 
481     // Auth role change events
482     event MinterChanged(address indexed newMinter);
483     event PauserChanged(address indexed newPauser);
484     event FeeRecipientChanged(address indexed newFeeRecipient);
485     event MaxSupplyChanged(uint256 indexed newMaxSupply);
486     event EternalStorageTransferred(address indexed newReserveAddress);
487     event TxFeeHelperChanged(address indexed newTxFeeHelper);
488     event TrustedRelayerChanged(address indexed newTrustedRelayer);
489 
490     // Pause events
491     event Paused(address indexed account);
492     event Unpaused(address indexed account);
493 
494     // Basic information as constants
495     string public constant name = "Reserve";
496     string public constant symbol = "RSV";
497     string public constant version = "2.1";
498     uint8 public constant decimals = 18;
499 
500     /// Initialize critical fields.
501     constructor() public {
502         pauser = msg.sender;
503         feeRecipient = msg.sender;
504         // minter defaults to the zero address.
505 
506         maxSupply = 2 ** 256 - 1;
507         paused = true;
508 
509         trustedTxFee = ITXFee(address(0));
510         trustedRelayer = address(0);
511         trustedData = ReserveEternalStorage(address(0));
512     }
513 
514     /// Accessor for eternal storage contract address.
515     function getEternalStorageAddress() external view returns(address) {
516         return address(trustedData);
517     }
518 
519 
520     // ==== Admin functions ====
521 
522 
523     /// Modifies a function to only run if sent by `role`.
524     modifier only(address role) {
525         require(msg.sender == role, "unauthorized: not role holder");
526         _;
527     }
528 
529     /// Modifies a function to only run if sent by `role` or the contract's `owner`.
530     modifier onlyOwnerOr(address role) {
531         require(msg.sender == owner() || msg.sender == role, "unauthorized: not owner or role");
532         _;
533     }
534 
535     /// Change who holds the `minter` role.
536     function changeMinter(address newMinter) external onlyOwnerOr(minter) {
537         minter = newMinter;
538         emit MinterChanged(newMinter);
539     }
540 
541     /// Change who holds the `pauser` role.
542     function changePauser(address newPauser) external onlyOwnerOr(pauser) {
543         pauser = newPauser;
544         emit PauserChanged(newPauser);
545     }
546 
547     function changeFeeRecipient(address newFeeRecipient) external onlyOwnerOr(feeRecipient) {
548         feeRecipient = newFeeRecipient;
549         emit FeeRecipientChanged(newFeeRecipient);
550     }
551 
552     /// Make a different address the EternalStorage contract's reserveAddress.
553     /// This will break this contract, so only do it if you're
554     /// abandoning this contract, e.g., for an upgrade.
555     function transferEternalStorage(address newReserveAddress) external onlyOwner isPaused {
556         require(newReserveAddress != address(0), "zero address");
557         emit EternalStorageTransferred(newReserveAddress);
558         trustedData.updateReserveAddress(newReserveAddress);
559     }
560 
561     /// Change the contract that is able to do metatransactions.
562     function changeRelayer(address newTrustedRelayer) external onlyOwner {
563         trustedRelayer = newTrustedRelayer;
564         emit TrustedRelayerChanged(newTrustedRelayer);
565     }
566 
567     /// Change the contract that helps with transaction fee calculation.
568     function changeTxFeeHelper(address newTrustedTxFee) external onlyOwner {
569         trustedTxFee = ITXFee(newTrustedTxFee);
570         emit TxFeeHelperChanged(newTrustedTxFee);
571     }
572 
573     /// Change the maximum supply allowed.
574     function changeMaxSupply(uint256 newMaxSupply) external onlyOwner {
575         maxSupply = newMaxSupply;
576         emit MaxSupplyChanged(newMaxSupply);
577     }
578 
579     /// Pause the contract.
580     function pause() external only(pauser) {
581         paused = true;
582         emit Paused(pauser);
583     }
584 
585     /// Unpause the contract.
586     function unpause() external only(pauser) {
587         paused = false;
588         emit Unpaused(pauser);
589     }
590 
591     /// Modifies a function to run only when the contract is paused.
592     modifier isPaused() {
593         require(paused, "contract is not paused");
594         _;
595     }
596 
597     /// Modifies a function to run only when the contract is not paused.
598     modifier notPaused() {
599         require(!paused, "contract is paused");
600         _;
601     }
602 
603 
604     // ==== Token transfers, allowances, minting, and burning ====
605 
606 
607     /// @return how many attoRSV are held by `holder`.
608     function balanceOf(address holder) external view returns (uint256) {
609         return trustedData.balance(holder);
610     }
611 
612     /// @return how many attoRSV `holder` has allowed `spender` to control.
613     function allowance(address holder, address spender) external view returns (uint256) {
614         return trustedData.allowed(holder, spender);
615     }
616 
617     /// Transfer `value` attoRSV from `msg.sender` to `to`.
618     function transfer(address to, uint256 value)
619         external
620         notPaused
621         returns (bool)
622     {
623         _transfer(msg.sender, to, value);
624         return true;
625     }
626 
627     /**
628      * Approve `spender` to spend `value` attotokens on behalf of `msg.sender`.
629      *
630      * Beware that changing a nonzero allowance with this method brings the risk that
631      * someone may use both the old and the new allowance by unfortunate transaction ordering. One
632      * way to mitigate this risk is to first reduce the spender's allowance
633      * to 0, and then set the desired value afterwards, per
634      * [this ERC-20 issue](https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729).
635      *
636      * A simpler workaround is to use `increaseAllowance` or `decreaseAllowance`, below.
637      *
638      * @param spender address The address which will spend the funds.
639      * @param value uint256 How many attotokens to allow `spender` to spend.
640      */
641     function approve(address spender, uint256 value)
642         external
643         notPaused
644         returns (bool)
645     {
646         _approve(msg.sender, spender, value);
647         return true;
648     }
649 
650     /// Transfer approved tokens from one address to another.
651     /// @param from address The address to send tokens from.
652     /// @param to address The address to send tokens to.
653     /// @param value uint256 The number of attotokens to send.
654     function transferFrom(address from, address to, uint256 value)
655         external
656         notPaused
657         returns (bool)
658     {
659         _transfer(from, to, value);
660         _approve(from, msg.sender, trustedData.allowed(from, msg.sender).sub(value));
661         return true;
662     }
663 
664     /// Increase `spender`'s allowance of the sender's tokens.
665     /// @dev From MonolithDAO Token.sol
666     /// @param spender The address which will spend the funds.
667     /// @param addedValue How many attotokens to increase the allowance by.
668     function increaseAllowance(address spender, uint256 addedValue)
669         external
670         notPaused
671         returns (bool)
672     {
673         _approve(msg.sender, spender, trustedData.allowed(msg.sender, spender).add(addedValue));
674         return true;
675     }
676 
677     /// Decrease `spender`'s allowance of the sender's tokens.
678     /// @dev From MonolithDAO Token.sol
679     /// @param spender The address which will spend the funds.
680     /// @param subtractedValue How many attotokens to decrease the allowance by.
681     function decreaseAllowance(address spender, uint256 subtractedValue)
682         external
683         notPaused
684         returns (bool)
685     {
686         _approve(
687             msg.sender,
688             spender,
689             trustedData.allowed(msg.sender, spender).sub(subtractedValue)
690         );
691         return true;
692     }
693 
694     /// Mint `value` new attotokens to `account`.
695     function mint(address account, uint256 value)
696         external
697         notPaused
698         only(minter)
699     {
700         require(account != address(0), "can't mint to address zero");
701 
702         totalSupply = totalSupply.add(value);
703         require(totalSupply < maxSupply, "max supply exceeded");
704         trustedData.addBalance(account, value);
705         emit Transfer(address(0), account, value);
706     }
707 
708     /// Burn `value` attotokens from `account`, if sender has that much allowance from `account`.
709     function burnFrom(address account, uint256 value)
710         external
711         notPaused
712         only(minter)
713     {
714         _burn(account, value);
715         _approve(account, msg.sender, trustedData.allowed(account, msg.sender).sub(value));
716     }
717 
718     // ==== Relay functions === //
719     
720     /// Transfer `value` attotokens from `from` to `to`.
721     /// Callable only by the relay contract.
722     function relayTransfer(address from, address to, uint256 value) 
723         external 
724         notPaused
725         only(trustedRelayer)
726         returns (bool)
727     {
728         _transfer(from, to, value);
729         return true;
730     }
731 
732     /// Approve `value` attotokens to be spent by `spender` from `holder`.
733     /// Callable only by the relay contract.
734     function relayApprove(address holder, address spender, uint256 value) 
735         external 
736         notPaused
737         only(trustedRelayer)
738         returns (bool)
739     {
740         _approve(holder, spender, value);
741         return true;
742     }
743 
744     /// `spender` transfers `value` attotokens from `holder` to `to`.
745     /// Requires allowance.
746     /// Callable only by the relay contract.
747     function relayTransferFrom(address holder, address spender, address to, uint256 value) 
748         external 
749         notPaused
750         only(trustedRelayer)
751         returns (bool)
752     {
753         _transfer(holder, to, value);
754         _approve(holder, spender, trustedData.allowed(holder, spender).sub(value));
755         return true;
756     }
757 
758     /// @dev Transfer of `value` attotokens from `from` to `to`.
759     /// Internal; doesn't check permissions.
760     function _transfer(address from, address to, uint256 value) internal {
761         require(to != address(0), "can't transfer to address zero");
762         trustedData.subBalance(from, value);
763         uint256 fee = 0;
764 
765         if (address(trustedTxFee) != address(0)) {
766             fee = trustedTxFee.calculateFee(from, to, value);
767             require(fee <= value, "transaction fee out of bounds");
768 
769             trustedData.addBalance(feeRecipient, fee);
770             emit Transfer(from, feeRecipient, fee);
771         }
772 
773         trustedData.addBalance(to, value.sub(fee));
774         emit Transfer(from, to, value.sub(fee));
775     }
776 
777     /// @dev Burn `value` attotokens from `account`.
778     /// Internal; doesn't check permissions.
779     function _burn(address account, uint256 value) internal {
780         require(account != address(0), "can't burn from address zero");
781 
782         totalSupply = totalSupply.sub(value);
783         trustedData.subBalance(account, value);
784         emit Transfer(account, address(0), value);
785     }
786 
787     /// @dev Set `spender`'s allowance on `holder`'s tokens to `value` attotokens.
788     /// Internal; doesn't check permissions.
789     function _approve(address holder, address spender, uint256 value) internal {
790         require(spender != address(0), "spender cannot be address zero");
791         require(holder != address(0), "holder cannot be address zero");
792 
793         trustedData.setAllowed(holder, spender, value);
794         emit Approval(holder, spender, value);
795     }
796 
797 // ===========================  Upgradeability   =====================================
798 
799     /// Accept upgrade from previous RSV instance. Can only be called once. 
800     function acceptUpgrade(address previousImplementation) external onlyOwner {
801         require(address(trustedData) == address(0), "can only be run once");
802         Reserve previous = Reserve(previousImplementation);
803         trustedData = ReserveEternalStorage(previous.getEternalStorageAddress());
804 
805         // Copy values from old contract
806         totalSupply = previous.totalSupply();
807         maxSupply = previous.maxSupply();
808         emit MaxSupplyChanged(maxSupply);
809         
810         // Unpause.
811         paused = false;
812         emit Unpaused(pauser);
813 
814         previous.acceptOwnership();
815 
816         // Take control of Eternal Storage.
817         previous.changePauser(address(this));
818         previous.pause();
819         previous.transferEternalStorage(address(this));
820 
821         // Burn the bridge behind us.
822         previous.changeMinter(address(0));
823         previous.changePauser(address(0));
824         previous.renounceOwnership("I hereby renounce ownership of this contract forever.");
825     }
826 }