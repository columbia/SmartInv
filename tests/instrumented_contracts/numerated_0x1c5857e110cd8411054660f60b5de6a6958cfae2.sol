1 pragma solidity 0.5.7;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 interface IERC20 {
6     /**
7      * @dev Returns the amount of tokens in existence.
8      */
9     function totalSupply() external view returns (uint256);
10 
11     /**
12      * @dev Returns the amount of tokens owned by `account`.
13      */
14     function balanceOf(address account) external view returns (uint256);
15 
16     /**
17      * @dev Moves `amount` tokens from the caller's account to `recipient`.
18      *
19      * Returns a boolean value indicating whether the operation succeeded.
20      *
21      * Emits a {Transfer} event.
22      */
23     function transfer(address recipient, uint256 amount) external returns (bool);
24 
25     /**
26      * @dev Returns the remaining number of tokens that `spender` will be
27      * allowed to spend on behalf of `owner` through {transferFrom}. This is
28      * zero by default.
29      *
30      * This value changes when {approve} or {transferFrom} are called.
31      */
32     function allowance(address owner, address spender) external view returns (uint256);
33 
34     /**
35      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
36      *
37      * Returns a boolean value indicating whether the operation succeeded.
38      *
39      * IMPORTANT: Beware that changing an allowance with this method brings the risk
40      * that someone may use both the old and the new allowance by unfortunate
41      * transaction ordering. One possible solution to mitigate this race
42      * condition is to first reduce the spender's allowance to 0 and set the
43      * desired value afterwards:
44      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
45      *
46      * Emits an {Approval} event.
47      */
48     function approve(address spender, uint256 amount) external returns (bool);
49 
50     /**
51      * @dev Moves `amount` tokens from `sender` to `recipient` using the
52      * allowance mechanism. `amount` is then deducted from the caller's
53      * allowance.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * Emits a {Transfer} event.
58      */
59     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Emitted when `value` tokens are moved from one account (`from`) to
63      * another (`to`).
64      *
65      * Note that `value` may be zero.
66      */
67     event Transfer(address indexed from, address indexed to, uint256 value);
68 
69     /**
70      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
71      * a call to {approve}. `value` is the new allowance.
72      */
73     event Approval(address indexed owner, address indexed spender, uint256 value);
74 }
75 
76 library SafeMath {
77     /**
78      * @dev Returns the addition of two unsigned integers, reverting on
79      * overflow.
80      *
81      * Counterpart to Solidity's `+` operator.
82      *
83      * Requirements:
84      * - Addition cannot overflow.
85      */
86     function add(uint256 a, uint256 b) internal pure returns (uint256) {
87         uint256 c = a + b;
88         require(c >= a, "SafeMath: addition overflow");
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the subtraction of two unsigned integers, reverting on
95      * overflow (when the result is negative).
96      *
97      * Counterpart to Solidity's `-` operator.
98      *
99      * Requirements:
100      * - Subtraction cannot overflow.
101      */
102     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
103         return sub(a, b, "SafeMath: subtraction overflow");
104     }
105 
106     /**
107      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
108      * overflow (when the result is negative).
109      *
110      * Counterpart to Solidity's `-` operator.
111      *
112      * Requirements:
113      * - Subtraction cannot overflow.
114      *
115      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
116      * @dev Get it via `npm install @openzeppelin/contracts@next`.
117      */
118     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
119         require(b <= a, errorMessage);
120         uint256 c = a - b;
121 
122         return c;
123     }
124 
125     /**
126      * @dev Returns the multiplication of two unsigned integers, reverting on
127      * overflow.
128      *
129      * Counterpart to Solidity's `*` operator.
130      *
131      * Requirements:
132      * - Multiplication cannot overflow.
133      */
134     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
135         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
136         // benefit is lost if 'b' is also tested.
137         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
138         if (a == 0) {
139             return 0;
140         }
141 
142         uint256 c = a * b;
143         require(c / a == b, "SafeMath: multiplication overflow");
144 
145         return c;
146     }
147 
148     /**
149      * @dev Returns the integer division of two unsigned integers. Reverts on
150      * division by zero. The result is rounded towards zero.
151      *
152      * Counterpart to Solidity's `/` operator. Note: this function uses a
153      * `revert` opcode (which leaves remaining gas untouched) while Solidity
154      * uses an invalid opcode to revert (consuming all remaining gas).
155      *
156      * Requirements:
157      * - The divisor cannot be zero.
158      */
159     function div(uint256 a, uint256 b) internal pure returns (uint256) {
160         return div(a, b, "SafeMath: division by zero");
161     }
162 
163     /**
164      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
165      * division by zero. The result is rounded towards zero.
166      *
167      * Counterpart to Solidity's `/` operator. Note: this function uses a
168      * `revert` opcode (which leaves remaining gas untouched) while Solidity
169      * uses an invalid opcode to revert (consuming all remaining gas).
170      *
171      * Requirements:
172      * - The divisor cannot be zero.
173      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
174      * @dev Get it via `npm install @openzeppelin/contracts@next`.
175      */
176     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
177         // Solidity only automatically asserts when dividing by 0
178         require(b > 0, errorMessage);
179         uint256 c = a / b;
180         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
181 
182         return c;
183     }
184 
185     /**
186      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
187      * Reverts when dividing by zero.
188      *
189      * Counterpart to Solidity's `%` operator. This function uses a `revert`
190      * opcode (which leaves remaining gas untouched) while Solidity uses an
191      * invalid opcode to revert (consuming all remaining gas).
192      *
193      * Requirements:
194      * - The divisor cannot be zero.
195      */
196     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
197         return mod(a, b, "SafeMath: modulo by zero");
198     }
199 
200     /**
201      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
202      * Reverts with custom message when dividing by zero.
203      *
204      * Counterpart to Solidity's `%` operator. This function uses a `revert`
205      * opcode (which leaves remaining gas untouched) while Solidity uses an
206      * invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      * - The divisor cannot be zero.
210      *
211      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
212      * @dev Get it via `npm install @openzeppelin/contracts@next`.
213      */
214     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
215         require(b != 0, errorMessage);
216         return a % b;
217     }
218 }
219 
220 contract Context {
221     // Empty internal constructor, to prevent people from mistakenly deploying
222     // an instance of this contract, which should be used via inheritance.
223     constructor () internal { }
224     // solhint-disable-previous-line no-empty-blocks
225 
226     function _msgSender() internal view returns (address payable) {
227         return msg.sender;
228     }
229 
230     function _msgData() internal view returns (bytes memory) {
231         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
232         return msg.data;
233     }
234 }
235 
236 contract Ownable is Context {
237     address private _owner;
238     address private _nominatedOwner;
239 
240     event NewOwnerNominated(address indexed previousOwner, address indexed nominee);
241     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
242 
243     /**
244      * @dev Initializes the contract setting the deployer as the initial owner.
245      */
246     constructor () internal {
247         address msgSender = _msgSender();
248         _owner = msgSender;
249         emit OwnershipTransferred(address(0), msgSender);
250     }
251 
252     /**
253      * @dev Returns the address of the current owner.
254      */
255     function owner() public view returns (address) {
256         return _owner;
257     }
258 
259     /**
260      * @dev Returns the address of the current nominated owner.
261      */
262     function nominatedOwner() external view returns (address) {
263         return _nominatedOwner;
264     }
265 
266     /**
267      * @dev Throws if called by any account other than the owner.
268      */
269     modifier onlyOwner() {
270         _onlyOwner();
271         _;
272     }
273 
274     function _onlyOwner() internal view {
275         require(_msgSender() == _owner, "caller is not owner");
276     }
277 
278     /**
279      * @dev Nominates a new owner `newOwner`.
280      * Requires a follow-up `acceptOwnership`.
281      * Can only be called by the current owner.
282      */
283     function nominateNewOwner(address newOwner) external onlyOwner {
284         require(newOwner != address(0), "new owner is 0 address");
285         emit NewOwnerNominated(_owner, newOwner);
286         _nominatedOwner = newOwner;
287     }
288 
289     /**
290      * @dev Accepts ownership of the contract.
291      */
292     function acceptOwnership() external {
293         require(_nominatedOwner == _msgSender(), "unauthorized");
294         emit OwnershipTransferred(_owner, _nominatedOwner);
295         _owner = _nominatedOwner;
296     }
297 
298     /** Set `_owner` to the 0 address.
299      * Only do this to deliberately lock in the current permissions.
300      *
301      * THIS CANNOT BE UNDONE! Call this only if you know what you're doing and why you're doing it!
302      */
303     function renounceOwnership(string calldata declaration) external onlyOwner {
304         string memory requiredDeclaration = "I hereby renounce ownership of this contract forever.";
305         require(
306             keccak256(abi.encodePacked(declaration)) ==
307             keccak256(abi.encodePacked(requiredDeclaration)),
308             "declaration incorrect");
309 
310         emit OwnershipTransferred(_owner, address(0));
311         _owner = address(0);
312     }
313 }
314 
315 contract ReserveEternalStorage is Ownable {
316 
317     using SafeMath for uint256;
318 
319 
320     // ===== auth =====
321 
322     address public reserveAddress;
323 
324     event ReserveAddressTransferred(
325         address indexed oldReserveAddress,
326         address indexed newReserveAddress
327     );
328 
329     /// On construction, set auth fields.
330     constructor() public {
331         reserveAddress = _msgSender();
332         emit ReserveAddressTransferred(address(0), reserveAddress);
333     }
334 
335     /// Only run modified function if sent by `reserveAddress`.
336     modifier onlyReserveAddress() {
337         require(_msgSender() == reserveAddress, "onlyReserveAddress");
338         _;
339     }
340 
341     /// Set `reserveAddress`.
342     function updateReserveAddress(address newReserveAddress) external {
343         require(newReserveAddress != address(0), "zero address");
344         require(_msgSender() == reserveAddress || _msgSender() == owner(), "not authorized");
345         emit ReserveAddressTransferred(reserveAddress, newReserveAddress);
346         reserveAddress = newReserveAddress;
347     }
348 
349 
350 
351     // ===== balance =====
352 
353     mapping(address => uint256) public balance;
354 
355     /// Add `value` to `balance[key]`, unless this causes integer overflow.
356     ///
357     /// @dev This is a slight divergence from the strict Eternal Storage pattern, but it reduces
358     /// the gas for the by-far most common token usage, it's a *very simple* divergence, and
359     /// `setBalance` is available anyway.
360     function addBalance(address key, uint256 value) external onlyReserveAddress {
361         balance[key] = balance[key].add(value);
362     }
363 
364     /// Subtract `value` from `balance[key]`, unless this causes integer underflow.
365     function subBalance(address key, uint256 value) external onlyReserveAddress {
366         balance[key] = balance[key].sub(value);
367     }
368 
369     /// Set `balance[key]` to `value`.
370     function setBalance(address key, uint256 value) external onlyReserveAddress {
371         balance[key] = value;
372     }
373 
374 
375 
376     // ===== allowed =====
377 
378     mapping(address => mapping(address => uint256)) public allowed;
379 
380     /// Set `to`'s allowance of `from`'s tokens to `value`.
381     function setAllowed(address from, address to, uint256 value) external onlyReserveAddress {
382         allowed[from][to] = value;
383     }
384 }
385 
386 interface ITXFee {
387      function calculateFee(address from, address to, uint256 amount) external returns (uint256);
388 }
389 
390 contract Reserve is IERC20, Ownable {
391     using SafeMath for uint256;
392 
393 
394     // ==== State ====
395 
396 
397     // Non-constant-sized data
398     ReserveEternalStorage internal trustedData;
399 
400     // TX Fee helper contract
401     ITXFee public trustedTxFee;
402 
403     // Basic token data
404     uint256 public totalSupply;
405     uint256 public maxSupply;
406 
407     // Paused data
408     bool public paused;
409 
410     // Auth roles
411     address public minter;
412     address public pauser;
413     address public feeRecipient;
414 
415 
416     // ==== Events, Constants, and Constructor ====
417 
418 
419     // Auth role change events
420     event MinterChanged(address indexed newMinter);
421     event PauserChanged(address indexed newPauser);
422     event FeeRecipientChanged(address indexed newFeeRecipient);
423     event MaxSupplyChanged(uint256 indexed newMaxSupply);
424     event EternalStorageTransferred(address indexed newReserveAddress);
425     event TxFeeHelperChanged(address indexed newTxFeeHelper);
426 
427     // Pause events
428     event Paused(address indexed account);
429     event Unpaused(address indexed account);
430 
431     // Basic information as constants
432     string public constant name = "Reserve";
433     string public constant symbol = "RSV";
434     uint8 public constant decimals = 18;
435 
436     /// Initialize critical fields.
437     constructor() public {
438         pauser = msg.sender;
439         feeRecipient = msg.sender;
440         // minter defaults to the zero address.
441 
442         maxSupply = 2 ** 256 - 1;
443         paused = true;
444 
445         trustedTxFee = ITXFee(address(0));
446         trustedData = new ReserveEternalStorage();
447         trustedData.nominateNewOwner(msg.sender);
448     }
449 
450     /// Accessor for eternal storage contract address.
451     function getEternalStorageAddress() external view returns(address) {
452         return address(trustedData);
453     }
454 
455 
456     // ==== Admin functions ====
457 
458 
459     /// Modifies a function to only run if sent by `role`.
460     modifier only(address role) {
461         require(msg.sender == role, "unauthorized: not role holder");
462         _;
463     }
464 
465     /// Modifies a function to only run if sent by `role` or the contract's `owner`.
466     modifier onlyOwnerOr(address role) {
467         require(msg.sender == owner() || msg.sender == role, "unauthorized: not owner or role");
468         _;
469     }
470 
471     /// Change who holds the `minter` role.
472     function changeMinter(address newMinter) external onlyOwnerOr(minter) {
473         minter = newMinter;
474         emit MinterChanged(newMinter);
475     }
476 
477     /// Change who holds the `pauser` role.
478     function changePauser(address newPauser) external onlyOwnerOr(pauser) {
479         pauser = newPauser;
480         emit PauserChanged(newPauser);
481     }
482 
483     function changeFeeRecipient(address newFeeRecipient) external onlyOwnerOr(feeRecipient) {
484         feeRecipient = newFeeRecipient;
485         emit FeeRecipientChanged(newFeeRecipient);
486     }
487 
488     /// Make a different address the EternalStorage contract's reserveAddress.
489     /// This will break this contract, so only do it if you're
490     /// abandoning this contract, e.g., for an upgrade.
491     function transferEternalStorage(address newReserveAddress) external onlyOwner isPaused {
492         require(newReserveAddress != address(0), "zero address");
493         emit EternalStorageTransferred(newReserveAddress);
494         trustedData.updateReserveAddress(newReserveAddress);
495     }
496 
497     /// Change the contract that helps with transaction fee calculation.
498     function changeTxFeeHelper(address newTrustedTxFee) external onlyOwner {
499         trustedTxFee = ITXFee(newTrustedTxFee);
500         emit TxFeeHelperChanged(newTrustedTxFee);
501     }
502 
503     /// Change the maximum supply allowed.
504     function changeMaxSupply(uint256 newMaxSupply) external onlyOwner {
505         maxSupply = newMaxSupply;
506         emit MaxSupplyChanged(newMaxSupply);
507     }
508 
509     /// Pause the contract.
510     function pause() external only(pauser) {
511         paused = true;
512         emit Paused(pauser);
513     }
514 
515     /// Unpause the contract.
516     function unpause() external only(pauser) {
517         paused = false;
518         emit Unpaused(pauser);
519     }
520 
521     /// Modifies a function to run only when the contract is paused.
522     modifier isPaused() {
523         require(paused, "contract is not paused");
524         _;
525     }
526 
527     /// Modifies a function to run only when the contract is not paused.
528     modifier notPaused() {
529         require(!paused, "contract is paused");
530         _;
531     }
532 
533 
534     // ==== Token transfers, allowances, minting, and burning ====
535 
536 
537     /// @return how many attoRSV are held by `holder`.
538     function balanceOf(address holder) external view returns (uint256) {
539         return trustedData.balance(holder);
540     }
541 
542     /// @return how many attoRSV `holder` has allowed `spender` to control.
543     function allowance(address holder, address spender) external view returns (uint256) {
544         return trustedData.allowed(holder, spender);
545     }
546 
547     /// Transfer `value` attoRSV from `msg.sender` to `to`.
548     function transfer(address to, uint256 value)
549         external
550         notPaused
551         returns (bool)
552     {
553         _transfer(msg.sender, to, value);
554         return true;
555     }
556 
557     /**
558      * Approve `spender` to spend `value` attotokens on behalf of `msg.sender`.
559      *
560      * Beware that changing a nonzero allowance with this method brings the risk that
561      * someone may use both the old and the new allowance by unfortunate transaction ordering. One
562      * way to mitigate this risk is to first reduce the spender's allowance
563      * to 0, and then set the desired value afterwards, per
564      * [this ERC-20 issue](https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729).
565      *
566      * A simpler workaround is to use `increaseAllowance` or `decreaseAllowance`, below.
567      *
568      * @param spender address The address which will spend the funds.
569      * @param value uint256 How many attotokens to allow `spender` to spend.
570      */
571     function approve(address spender, uint256 value)
572         external
573         notPaused
574         returns (bool)
575     {
576         _approve(msg.sender, spender, value);
577         return true;
578     }
579 
580     /// Transfer approved tokens from one address to another.
581     /// @param from address The address to send tokens from.
582     /// @param to address The address to send tokens to.
583     /// @param value uint256 The number of attotokens to send.
584     function transferFrom(address from, address to, uint256 value)
585         external
586         notPaused
587         returns (bool)
588     {
589         _transfer(from, to, value);
590         _approve(from, msg.sender, trustedData.allowed(from, msg.sender).sub(value));
591         return true;
592     }
593 
594     /// Increase `spender`'s allowance of the sender's tokens.
595     /// @dev From MonolithDAO Token.sol
596     /// @param spender The address which will spend the funds.
597     /// @param addedValue How many attotokens to increase the allowance by.
598     function increaseAllowance(address spender, uint256 addedValue)
599         external
600         notPaused
601         returns (bool)
602     {
603         _approve(msg.sender, spender, trustedData.allowed(msg.sender, spender).add(addedValue));
604         return true;
605     }
606 
607     /// Decrease `spender`'s allowance of the sender's tokens.
608     /// @dev From MonolithDAO Token.sol
609     /// @param spender The address which will spend the funds.
610     /// @param subtractedValue How many attotokens to decrease the allowance by.
611     function decreaseAllowance(address spender, uint256 subtractedValue)
612         external
613         notPaused
614         returns (bool)
615     {
616         _approve(
617             msg.sender,
618             spender,
619             trustedData.allowed(msg.sender, spender).sub(subtractedValue)
620         );
621         return true;
622     }
623 
624     /// Mint `value` new attotokens to `account`.
625     function mint(address account, uint256 value)
626         external
627         notPaused
628         only(minter)
629     {
630         require(account != address(0), "can't mint to address zero");
631 
632         totalSupply = totalSupply.add(value);
633         require(totalSupply < maxSupply, "max supply exceeded");
634         trustedData.addBalance(account, value);
635         emit Transfer(address(0), account, value);
636     }
637 
638     /// Burn `value` attotokens from `account`, if sender has that much allowance from `account`.
639     function burnFrom(address account, uint256 value)
640         external
641         notPaused
642         only(minter)
643     {
644         _burn(account, value);
645         _approve(account, msg.sender, trustedData.allowed(account, msg.sender).sub(value));
646     }
647 
648     /// @dev Transfer of `value` attotokens from `from` to `to`.
649     /// Internal; doesn't check permissions.
650     function _transfer(address from, address to, uint256 value) internal {
651         require(to != address(0), "can't transfer to address zero");
652         trustedData.subBalance(from, value);
653         uint256 fee = 0;
654 
655         if (address(trustedTxFee) != address(0)) {
656             fee = trustedTxFee.calculateFee(from, to, value);
657             require(fee <= value, "transaction fee out of bounds");
658 
659             trustedData.addBalance(feeRecipient, fee);
660             emit Transfer(from, feeRecipient, fee);
661         }
662 
663         trustedData.addBalance(to, value.sub(fee));
664         emit Transfer(from, to, value.sub(fee));
665     }
666 
667     /// @dev Burn `value` attotokens from `account`.
668     /// Internal; doesn't check permissions.
669     function _burn(address account, uint256 value) internal {
670         require(account != address(0), "can't burn from address zero");
671 
672         totalSupply = totalSupply.sub(value);
673         trustedData.subBalance(account, value);
674         emit Transfer(account, address(0), value);
675     }
676 
677     /// @dev Set `spender`'s allowance on `holder`'s tokens to `value` attotokens.
678     /// Internal; doesn't check permissions.
679     function _approve(address holder, address spender, uint256 value) internal {
680         require(spender != address(0), "spender cannot be address zero");
681         require(holder != address(0), "holder cannot be address zero");
682 
683         trustedData.setAllowed(holder, spender, value);
684         emit Approval(holder, spender, value);
685     }
686 }