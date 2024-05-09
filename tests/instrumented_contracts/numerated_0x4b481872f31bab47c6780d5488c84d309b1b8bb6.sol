1 pragma solidity 0.5.7;
2 
3 
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
7  * the optional functions; to access them see {ERC20Detailed}.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves `amount` tokens from the caller's account to `recipient`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a {Transfer} event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through {transferFrom}. This is
32      * zero by default.
33      *
34      * This value changes when {approve} or {transferFrom} are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * IMPORTANT: Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an {Approval} event.
51      */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Moves `amount` tokens from `sender` to `recipient` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Emitted when `value` tokens are moved from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75      * a call to {approve}. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 /**
81  * @dev Wrappers over Solidity's arithmetic operations with added overflow
82  * checks.
83  *
84  * Arithmetic operations in Solidity wrap on overflow. This can easily result
85  * in bugs, because programmers usually assume that an overflow raises an
86  * error, which is the standard behavior in high level programming languages.
87  * `SafeMath` restores this intuition by reverting the transaction when an
88  * operation overflows.
89  *
90  * Using this library instead of the unchecked operations eliminates an entire
91  * class of bugs, so it's recommended to use it always.
92  */
93 library SafeMath {
94     /**
95      * @dev Returns the addition of two unsigned integers, reverting on
96      * overflow.
97      *
98      * Counterpart to Solidity's `+` operator.
99      *
100      * Requirements:
101      * - Addition cannot overflow.
102      */
103     function add(uint256 a, uint256 b) internal pure returns (uint256) {
104         uint256 c = a + b;
105         require(c >= a, "SafeMath: addition overflow");
106 
107         return c;
108     }
109 
110     /**
111      * @dev Returns the subtraction of two unsigned integers, reverting on
112      * overflow (when the result is negative).
113      *
114      * Counterpart to Solidity's `-` operator.
115      *
116      * Requirements:
117      * - Subtraction cannot overflow.
118      */
119     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120         return sub(a, b, "SafeMath: subtraction overflow");
121     }
122 
123     /**
124      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
125      * overflow (when the result is negative).
126      *
127      * Counterpart to Solidity's `-` operator.
128      *
129      * Requirements:
130      * - Subtraction cannot overflow.
131      *
132      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
133      * @dev Get it via `npm install @openzeppelin/contracts@next`.
134      */
135     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
136         require(b <= a, errorMessage);
137         uint256 c = a - b;
138 
139         return c;
140     }
141 
142     /**
143      * @dev Returns the multiplication of two unsigned integers, reverting on
144      * overflow.
145      *
146      * Counterpart to Solidity's `*` operator.
147      *
148      * Requirements:
149      * - Multiplication cannot overflow.
150      */
151     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
152         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
153         // benefit is lost if 'b' is also tested.
154         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
155         if (a == 0) {
156             return 0;
157         }
158 
159         uint256 c = a * b;
160         require(c / a == b, "SafeMath: multiplication overflow");
161 
162         return c;
163     }
164 
165     /**
166      * @dev Returns the integer division of two unsigned integers. Reverts on
167      * division by zero. The result is rounded towards zero.
168      *
169      * Counterpart to Solidity's `/` operator. Note: this function uses a
170      * `revert` opcode (which leaves remaining gas untouched) while Solidity
171      * uses an invalid opcode to revert (consuming all remaining gas).
172      *
173      * Requirements:
174      * - The divisor cannot be zero.
175      */
176     function div(uint256 a, uint256 b) internal pure returns (uint256) {
177         return div(a, b, "SafeMath: division by zero");
178     }
179 
180     /**
181      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
182      * division by zero. The result is rounded towards zero.
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      * - The divisor cannot be zero.
190      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
191      * @dev Get it via `npm install @openzeppelin/contracts@next`.
192      */
193     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
194         // Solidity only automatically asserts when dividing by 0
195         require(b > 0, errorMessage);
196         uint256 c = a / b;
197         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
198 
199         return c;
200     }
201 
202     /**
203      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
204      * Reverts when dividing by zero.
205      *
206      * Counterpart to Solidity's `%` operator. This function uses a `revert`
207      * opcode (which leaves remaining gas untouched) while Solidity uses an
208      * invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      * - The divisor cannot be zero.
212      */
213     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
214         return mod(a, b, "SafeMath: modulo by zero");
215     }
216 
217     /**
218      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
219      * Reverts with custom message when dividing by zero.
220      *
221      * Counterpart to Solidity's `%` operator. This function uses a `revert`
222      * opcode (which leaves remaining gas untouched) while Solidity uses an
223      * invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      * - The divisor cannot be zero.
227      *
228      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
229      * @dev Get it via `npm install @openzeppelin/contracts@next`.
230      */
231     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
232         require(b != 0, errorMessage);
233         return a % b;
234     }
235 }
236   
237 
238 /**
239  * @dev Collection of functions related to the address type
240  */
241 library Address {
242     /**
243      * @dev Returns true if `account` is a contract.
244      *
245      * This test is non-exhaustive, and there may be false-negatives: during the
246      * execution of a contract's constructor, its address will be reported as
247      * not containing a contract.
248      *
249      * IMPORTANT: It is unsafe to assume that an address for which this
250      * function returns false is an externally-owned account (EOA) and not a
251      * contract.
252      */
253     function isContract(address account) internal view returns (bool) {
254         // This method relies in extcodesize, which returns 0 for contracts in
255         // construction, since the code is only stored at the end of the
256         // constructor execution.
257 
258         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
259         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
260         // for accounts without code, i.e. `keccak256('')`
261         bytes32 codehash;
262         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
263         // solhint-disable-next-line no-inline-assembly
264         assembly { codehash := extcodehash(account) }
265         return (codehash != 0x0 && codehash != accountHash);
266     }
267 
268     /**
269      * @dev Converts an `address` into `address payable`. Note that this is
270      * simply a type cast: the actual underlying value is not changed.
271      *
272      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
273      * @dev Get it via `npm install @openzeppelin/contracts@next`.
274      */
275     function toPayable(address account) internal pure returns (address payable) {
276         return address(uint160(account));
277     }
278 }
279 
280 /**
281  * @title SafeERC20
282  * @dev Wrappers around ERC20 operations that throw on failure (when the token
283  * contract returns false). Tokens that return no value (and instead revert or
284  * throw on failure) are also supported, non-reverting calls are assumed to be
285  * successful.
286  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
287  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
288  */
289 library SafeERC20 {
290     using SafeMath for uint256;
291     using Address for address;
292 
293     function safeTransfer(IERC20 token, address to, uint256 value) internal {
294         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
295     }
296 
297     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
298         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
299     }
300 
301     function safeApprove(IERC20 token, address spender, uint256 value) internal {
302         // safeApprove should only be called when setting an initial allowance,
303         // or when resetting it to zero. To increase and decrease it, use
304         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
305         // solhint-disable-next-line max-line-length
306         require((value == 0) || (token.allowance(address(this), spender) == 0),
307             "SafeERC20: approve from non-zero to non-zero allowance"
308         );
309         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
310     }
311 
312     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
313         uint256 newAllowance = token.allowance(address(this), spender).add(value);
314         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
315     }
316 
317     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
318         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
319         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
320     }
321 
322     /**
323      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
324      * on the return value: the return value is optional (but if data is returned, it must not be false).
325      * @param token The token targeted by the call.
326      * @param data The call data (encoded using abi.encode or one of its variants).
327      */
328     function callOptionalReturn(IERC20 token, bytes memory data) private {
329         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
330         // we're implementing it ourselves.
331 
332         // A Solidity high level call has three parts:
333         //  1. The target address is checked to verify it contains contract code
334         //  2. The call itself is made, and success asserted
335         //  3. The return value is decoded, which in turn checks the size of the returned data.
336         // solhint-disable-next-line max-line-length
337         require(address(token).isContract(), "SafeERC20: call to non-contract");
338 
339         // solhint-disable-next-line avoid-low-level-calls
340         (bool success, bytes memory returndata) = address(token).call(data);
341         require(success, "SafeERC20: low-level call failed");
342 
343         if (returndata.length > 0) { // Return data is optional
344             // solhint-disable-next-line max-line-length
345             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
346         }
347     }
348 }
349 
350 interface IRSV {
351     // Standard ERC20 functions
352     function transfer(address, uint256) external returns(bool);
353     function approve(address, uint256) external returns(bool);
354     function transferFrom(address, address, uint256) external returns(bool);
355     function totalSupply() external view returns(uint256);
356     function balanceOf(address) external view returns(uint256);
357     function allowance(address, address) external view returns(uint256);
358     event Transfer(address indexed from, address indexed to, uint256 value);
359     event Approval(address indexed owner, address indexed spender, uint256 value);
360 
361     // RSV-specific functions
362     function decimals() external view returns(uint8);
363     function mint(address, uint256) external;
364     function burnFrom(address, uint256) external;
365     function relayTransfer(address, address, uint256) external returns(bool);
366     function relayTransferFrom(address, address, address, uint256) external returns(bool);
367     function relayApprove(address, address, uint256) external returns(bool);
368 }
369 
370 
371 /*
372  * @dev Provides information about the current execution context, including the
373  * sender of the transaction and its data. While these are generally available
374  * via msg.sender and msg.data, they should not be accessed in such a direct
375  * manner, since when dealing with GSN meta-transactions the account sending and
376  * paying for execution may not be the actual sender (as far as an application
377  * is concerned).
378  *
379  * This contract is only required for intermediate, library-like contracts.
380  */
381 contract Context {
382     // Empty internal constructor, to prevent people from mistakenly deploying
383     // an instance of this contract, which should be used via inheritance.
384     constructor () internal { }
385     // solhint-disable-previous-line no-empty-blocks
386 
387     function _msgSender() internal view returns (address payable) {
388         return msg.sender;
389     }
390 
391     function _msgData() internal view returns (bytes memory) {
392         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
393         return msg.data;
394     }
395 }
396 /**
397  * @dev Contract module which provides a basic access control mechanism, where there is an account
398  * (owner) that can be granted exclusive access to specific functions.
399  *
400  * This module is used through inheritance by using the modifier `onlyOwner`.
401  *
402  * To change ownership, use a 2-part nominate-accept pattern.
403  *
404  * This contract is loosely based off of https://git.io/JenNF but additionally requires new owners
405  * to accept ownership before the transition occurs.
406  */
407 contract Ownable is Context {
408     address private _owner;
409     address private _nominatedOwner;
410 
411     event NewOwnerNominated(address indexed previousOwner, address indexed nominee);
412     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
413 
414     /**
415      * @dev Initializes the contract setting the deployer as the initial owner.
416      */
417     constructor () internal {
418         address msgSender = _msgSender();
419         _owner = msgSender;
420         emit OwnershipTransferred(address(0), msgSender);
421     }
422 
423     /**
424      * @dev Returns the address of the current owner.
425      */
426     function owner() public view returns (address) {
427         return _owner;
428     }
429 
430     /**
431      * @dev Returns the address of the current nominated owner.
432      */
433     function nominatedOwner() external view returns (address) {
434         return _nominatedOwner;
435     }
436 
437     /**
438      * @dev Throws if called by any account other than the owner.
439      */
440     modifier onlyOwner() {
441         _onlyOwner();
442         _;
443     }
444 
445     function _onlyOwner() internal view {
446         require(_msgSender() == _owner, "caller is not owner");
447     }
448 
449     /**
450      * @dev Nominates a new owner `newOwner`.
451      * Requires a follow-up `acceptOwnership`.
452      * Can only be called by the current owner.
453      */
454     function nominateNewOwner(address newOwner) external onlyOwner {
455         require(newOwner != address(0), "new owner is 0 address");
456         emit NewOwnerNominated(_owner, newOwner);
457         _nominatedOwner = newOwner;
458     }
459 
460     /**
461      * @dev Accepts ownership of the contract.
462      */
463     function acceptOwnership() external {
464         require(_nominatedOwner == _msgSender(), "unauthorized");
465         emit OwnershipTransferred(_owner, _nominatedOwner);
466         _owner = _nominatedOwner;
467     }
468 
469     /** Set `_owner` to the 0 address.
470      * Only do this to deliberately lock in the current permissions.
471      *
472      * THIS CANNOT BE UNDONE! Call this only if you know what you're doing and why you're doing it!
473      */
474     function renounceOwnership(string calldata declaration) external onlyOwner {
475         string memory requiredDeclaration = "I hereby renounce ownership of this contract forever.";
476         require(
477             keccak256(abi.encodePacked(declaration)) ==
478             keccak256(abi.encodePacked(requiredDeclaration)),
479             "declaration incorrect");
480 
481         emit OwnershipTransferred(_owner, address(0));
482         _owner = address(0);
483     }
484 }
485 
486 
487 /**
488  * This Basket contract is essentially just a data structure; it represents the tokens and weights
489  * in some Reserve-backing basket, either proposed or accepted.
490  *
491  * @dev Each `weights` value is an integer, with unit aqToken/RSV. (That is, atto-quantum-Tokens
492  * per RSV). If you prefer, you can think about this as if the weights value is itself an
493  * 18-decimal fixed-point value with unit qToken/RSV. (It would be prettier if these were just
494  * straightforwardly qTokens/RSV, but that introduces unacceptable rounding error in some of our
495  * basket computations.)
496  *
497  * @dev For example, let's say we have the token USDX in the vault, and it's represented to 6
498  * decimal places, and the RSV basket should include 3/10ths of a USDX for each RSV. Then the
499  * corresponding basket weight will be represented as 3*(10**23), because:
500  *
501  * @dev 3*(10**23) aqToken/RSV == 0.3 Token/RSV * (10**6 qToken/Token) * (10**18 aqToken/qToken)
502  *
503  * @dev For further notes on units, see the header comment for Manager.sol.
504 */
505 
506 contract Basket {
507     address[] public tokens;
508     mapping(address => uint256) public weights; // unit: aqToken/RSV
509     mapping(address => bool) public has;
510     // INVARIANT: {addr | addr in tokens} == {addr | has[addr] == true}
511     
512     // SECURITY PROPERTY: The value of prev is always a Basket, and cannot be set by any user.
513     
514     // WARNING: A basket can be of size 0. It is the Manager's responsibility
515     //                    to ensure Issuance does not happen against an empty basket.
516 
517     /// Construct a new basket from an old Basket `prev`, and a list of tokens and weights with
518     /// which to update `prev`. If `prev == address(0)`, act like it's an empty basket.
519     constructor(Basket trustedPrev, address[] memory _tokens, uint256[] memory _weights) public {
520         require(_tokens.length == _weights.length, "Basket: unequal array lengths");
521 
522         // Initialize data from input arrays
523         tokens = new address[](_tokens.length);
524         for (uint256 i = 0; i < _tokens.length; i++) {
525             require(!has[_tokens[i]], "duplicate token entries");
526             weights[_tokens[i]] = _weights[i];
527             has[_tokens[i]] = true;
528             tokens[i] = _tokens[i];
529         }
530 
531         // If there's a previous basket, copy those of its contents not already set.
532         if (trustedPrev != Basket(0)) {
533             for (uint256 i = 0; i < trustedPrev.size(); i++) {
534                 address tok = trustedPrev.tokens(i);
535                 if (!has[tok]) {
536                     weights[tok] = trustedPrev.weights(tok);
537                     has[tok] = true;
538                     tokens.push(tok);
539                 }
540             }
541         }
542         require(tokens.length <= 10, "Basket: bad length");
543     }
544 
545     function getTokens() external view returns(address[] memory) {
546         return tokens;
547     }
548 
549     function size() external view returns(uint256) {
550         return tokens.length;
551     }
552 }
553 
554 
555 /**
556  * A Proposal represents a suggestion to change the backing for RSV.
557  *
558  * The lifecycle of a proposal:
559  * 1. Creation
560  * 2. Acceptance
561  * 3. Completion
562  *
563  * A time can be set during acceptance to determine when completion is eligible.  A proposal can
564  * also be cancelled before it is completed. If a proposal is cancelled, it can no longer become
565  * Completed.
566  *
567  * This contract is intended to be used in one of two possible ways. Either:
568  * - A target RSV basket is proposed, and quantities to be exchanged are deduced at the time of
569  *   proposal execution.
570  * - A specific quantity of tokens to be exchanged is proposed, and the resultant RSV basket is
571  *   determined at the time of proposal execution.
572  */
573 
574 interface IProposal {
575     function proposer() external returns(address);
576     function accept(uint256 time) external;
577     function cancel() external;
578     function complete(IRSV rsv, Basket oldBasket) external returns(Basket);
579     function nominateNewOwner(address newOwner) external;
580     function acceptOwnership() external;
581 }
582 
583 interface IProposalFactory {
584     function createSwapProposal(address,
585         address[] calldata tokens,
586         uint256[] calldata amounts,
587         bool[] calldata toVault
588     ) external returns (IProposal);
589 
590     function createWeightProposal(address proposer, Basket basket) external returns (IProposal);
591 }
592 
593 contract ProposalFactory is IProposalFactory {
594     function createSwapProposal(
595         address proposer,
596         address[] calldata tokens,
597         uint256[] calldata amounts,
598         bool[] calldata toVault
599     )
600         external returns (IProposal)
601     {
602         IProposal proposal = IProposal(new SwapProposal(proposer, tokens, amounts, toVault));
603         proposal.nominateNewOwner(msg.sender);
604         return proposal;
605     }
606 
607     function createWeightProposal(address proposer, Basket basket) external returns (IProposal) {
608         IProposal proposal = IProposal(new WeightProposal(proposer, basket));
609         proposal.nominateNewOwner(msg.sender);
610         return proposal;
611     }
612 }
613 
614 contract Proposal is IProposal, Ownable {
615     using SafeMath for uint256;
616     using SafeERC20 for IERC20;
617 
618     uint256 public time;
619     address public proposer;
620 
621     enum State { Created, Accepted, Cancelled, Completed }
622     State public state;
623     
624     event ProposalCreated(address indexed proposer);
625     event ProposalAccepted(address indexed proposer, uint256 indexed time);
626     event ProposalCancelled(address indexed proposer);
627     event ProposalCompleted(address indexed proposer, address indexed basket);
628 
629     constructor(address _proposer) public {
630         proposer = _proposer;
631         state = State.Created;
632         emit ProposalCreated(proposer);
633     }
634 
635     /// Moves a proposal from the Created to Accepted state.
636     function accept(uint256 _time) external onlyOwner {
637         require(state == State.Created, "proposal not created");
638         time = _time;
639         state = State.Accepted;
640         emit ProposalAccepted(proposer, _time);
641     }
642 
643     /// Cancels a proposal if it has not been completed.
644     function cancel() external onlyOwner {
645         require(state != State.Completed);
646         state = State.Cancelled;
647         emit ProposalCancelled(proposer);
648     }
649 
650     /// Moves a proposal from the Accepted to Completed state.
651     /// Returns the tokens, quantitiesIn, and quantitiesOut, required to implement the proposal.
652     function complete(IRSV rsv, Basket oldBasket)
653         external onlyOwner returns(Basket)
654     {
655         require(state == State.Accepted, "proposal must be accepted");
656         require(now > time, "wait to execute");
657         state = State.Completed;
658 
659         Basket b = _newBasket(rsv, oldBasket);
660         emit ProposalCompleted(proposer, address(b));
661         return b;
662     }
663 
664     /// Returns the newly-proposed basket. This varies for different types of proposals,
665     /// so it's abstract here.
666     function _newBasket(IRSV trustedRSV, Basket oldBasket) internal returns(Basket);
667 }
668 
669 /**
670  * A WeightProposal represents a suggestion to change the backing for RSV to a new distribution
671  * of tokens. You can think of it as designating what a _single RSV_ should be backed by, but
672  * deferring on the precise quantities of tokens that will be need to be exchanged until a later
673  * point in time.
674  *
675  * When this proposal is completed, it simply returns the target basket.
676  */
677 contract WeightProposal is Proposal {
678     Basket public trustedBasket;
679 
680     constructor(address _proposer, Basket _trustedBasket) Proposal(_proposer) public {
681         require(_trustedBasket.size() > 0, "proposal cannot be empty");
682         trustedBasket = _trustedBasket;
683     }
684 
685     /// Returns the newly-proposed basket
686     function _newBasket(IRSV, Basket) internal returns(Basket) {
687         return trustedBasket;
688     }
689 }
690 
691 /**
692  * A SwapProposal represents a suggestion to transfer fixed amounts of tokens into and out of the
693  * vault. Whereas a WeightProposal designates how much a _single RSV_ should be backed by,
694  * a SwapProposal first designates what quantities of tokens to transfer in total and then
695  * solves for the new resultant basket later.
696  *
697  * When this proposal is completed, it calculates what the weights for the new basket will be
698  * and returns it. If RSV supply is 0, this kind of Proposal cannot be used. 
699  */
700 
701 // On "unit" comments, see comment at top of Manager.sol.
702 contract SwapProposal is Proposal {
703     address[] public tokens;
704     uint256[] public amounts; // unit: qToken
705     bool[] public toVault;
706 
707     uint256 constant WEIGHT_SCALE = uint256(10)**18; // unit: aqToken / qToken
708 
709     constructor(address _proposer,
710                 address[] memory _tokens,
711                 uint256[] memory _amounts, // unit: qToken
712                 bool[] memory _toVault )
713         Proposal(_proposer) public
714     {
715         require(_tokens.length > 0, "proposal cannot be empty");
716         require(_tokens.length == _amounts.length && _amounts.length == _toVault.length,
717                 "unequal array lengths");
718         tokens = _tokens;
719         amounts = _amounts;
720         toVault = _toVault;
721     }
722 
723     /// Return the newly-proposed basket, based on the current vault and the old basket.
724     function _newBasket(IRSV trustedRSV, Basket trustedOldBasket) internal returns(Basket) {
725 
726         uint256[] memory weights = new uint256[](tokens.length);
727         // unit: aqToken/RSV
728 
729         uint256 scaleFactor = WEIGHT_SCALE.mul(uint256(10)**(trustedRSV.decimals()));
730         // unit: aqToken/qToken * qRSV/RSV
731 
732         uint256 rsvSupply = trustedRSV.totalSupply();
733         // unit: qRSV
734 
735         for (uint256 i = 0; i < tokens.length; i++) {
736             uint256 oldWeight = trustedOldBasket.weights(tokens[i]);
737             // unit: aqToken/RSV
738 
739             if (toVault[i]) {
740                 // We require that the execution of a SwapProposal takes in no more than the funds
741                 // offered in its proposal -- that's part of the premise. It turns out that,
742                 // because we're rounding down _here_ and rounding up in
743                 // Manager._executeBasketShift(), it's possible for the naive implementation of
744                 // this mechanism to overspend the proposer's tokens by 1 qToken. We avoid that,
745                 // here, by making the effective proposal one less. Yeah, it's pretty fiddly.
746                 
747                 weights[i] = oldWeight.add( (amounts[i].sub(1)).mul(scaleFactor).div(rsvSupply) );
748                 //unit: aqToken/RSV == aqToken/RSV == [qToken] * [aqToken/qToken*qRSV/RSV] / [qRSV]
749             } else {
750                 weights[i] = oldWeight.sub( amounts[i].mul(scaleFactor).div(rsvSupply) );
751                 //unit: aqToken/RSV
752             }
753         }
754 
755         return new Basket(trustedOldBasket, tokens, weights);
756         // unit check for weights: aqToken/RSV
757     }
758 }
759 
760 
761 
762 
763 interface IVault {
764     function withdrawTo(address, uint256, address) external;
765 }
766 
767 /**
768  * The Manager contract is the point of contact between the Reserve ecosystem and the
769  * surrounding world. It manages the Issuance and Redemption of RSV, a decentralized stablecoin
770  * backed by a basket of tokens.
771  *
772  * The Manager also implements a Proposal system to handle administration of changes to the
773  * backing of RSV. Anyone can propose a change to the backing.  Once the `owner` approves the
774  * proposal, then after a pre-determined delay the proposal is eligible for execution by
775  * anyone. However, the funds to execute the proposal must come from the proposer.
776  *
777  * There are two different ways to propose changes to the backing of RSV:
778  * - proposeSwap()
779  * - proposeWeights()
780  *
781  * In both cases, tokens are exchanged with the Vault and a new RSV backing is set. You can
782  * think of the first type of proposal as being useful when you don't want to rebalance the
783  * Vault by exchanging absolute quantities of tokens; its downside is that you don't know
784  * precisely what the resulting basket weights will be. The second type of proposal is more
785  * useful when you want to fine-tune the Vault weights and accept the downside that it's
786  * difficult to know what capital will be required when the proposal is executed.
787  */
788 
789 /* On "unit" comments:
790  *
791  * The units in use around weight computations are fiddly, and it's pretty annoying to get them
792  * properly into the Solidity type system. So, there are many comments of the form "unit:
793  * ...". Where such a comment is describing a field, method, or return parameter, the comment means
794  * that the data in that place is to be interpreted to have that type. Many places also have
795  * comments with more complicated expressions; that's manually working out the dimensional analysis
796  * to ensure that the given expression has correct units.
797  *
798  * Some dimensions used in this analysis:
799  * - 1 RSV: 1 Reserve
800  * - 1 qRSV: 1 quantum of Reserve.
801  *      (RSV & qRSV are convertible by .mul(10**reserve.decimals() qRSV/RSV))
802  * - 1 qToken: 1 quantum of an external Token.
803  * - 1 aqToken: 1 atto-quantum of an external Token.
804  *      (qToken and aqToken are convertible by .mul(10**18 aqToken/qToken)
805  * - 1 BPS: 1 Basis Point. Effectively dimensionless; convertible with .mul(10000 BPS).
806  *
807  * Note that we _never_ reason in units of Tokens or attoTokens.
808  */
809 contract Manager is Ownable {
810     using SafeERC20 for IERC20;
811     using SafeMath for uint256;
812 
813     // ROLES
814 
815     // Manager is already Ownable, but in addition it also has an `operator`.
816     address public operator;
817 
818     // DATA
819 
820     Basket public trustedBasket;
821     IVault public trustedVault;
822     IRSV public trustedRSV;
823     IProposalFactory public trustedProposalFactory;
824 
825     // Proposals
826     mapping(uint256 => IProposal) public trustedProposals;
827     uint256 public proposalsLength;
828     uint256 public delay = 24 hours;
829 
830     // Controls
831     bool public issuancePaused;
832     bool public emergency;
833 
834     // The spread between issuance and redemption in basis points (BPS).
835     uint256 public seigniorage;              // 0.1% spread -> 10 BPS. unit: BPS
836     uint256 constant BPS_FACTOR = 10000;     // This is what 100% looks like in BPS. unit: BPS
837     uint256 constant WEIGHT_SCALE = 10**18; // unit: aqToken/qToken
838 
839     event ProposalsCleared();
840 
841     // RSV traded events
842     event Issuance(address indexed user, uint256 indexed amount);
843     event Redemption(address indexed user, uint256 indexed amount);
844 
845     // Pause events
846     event IssuancePausedChanged(bool indexed oldVal, bool indexed newVal);
847     event EmergencyChanged(bool indexed oldVal, bool indexed newVal);
848     event OperatorChanged(address indexed oldAccount, address indexed newAccount);
849     event SeigniorageChanged(uint256 oldVal, uint256 newVal);
850     event VaultChanged(address indexed oldVaultAddr, address indexed newVaultAddr);
851     event DelayChanged(uint256 oldVal, uint256 newVal);
852 
853     // Proposals
854     event WeightsProposed(uint256 indexed id,
855         address indexed proposer,
856         address[] tokens,
857         uint256[] weights);
858 
859     event SwapProposed(uint256 indexed id,
860         address indexed proposer,
861         address[] tokens,
862         uint256[] amounts,
863         bool[] toVault);
864 
865     event ProposalAccepted(uint256 indexed id, address indexed proposer);
866     event ProposalCanceled(uint256 indexed id, address indexed proposer, address indexed canceler);
867     event ProposalExecuted(uint256 indexed id,
868         address indexed proposer,
869         address indexed executor,
870         address oldBasket,
871         address newBasket);
872 
873     // ============================ Constructor ===============================
874 
875     /// Begins in `emergency` state.
876     constructor(
877         address vaultAddr,
878         address rsvAddr,
879         address proposalFactoryAddr,
880         address basketAddr,
881         address operatorAddr,
882         uint256 _seigniorage) public
883     {
884         require(_seigniorage <= 1000, "max seigniorage 10%");
885         trustedVault = IVault(vaultAddr);
886         trustedRSV = IRSV(rsvAddr);
887         trustedProposalFactory = IProposalFactory(proposalFactoryAddr);
888         trustedBasket = Basket(basketAddr);
889         operator = operatorAddr;
890         seigniorage = _seigniorage;
891         emergency = true; // it's not an emergency, but we want everything to start paused.
892     }
893 
894     // ============================= Modifiers ================================
895 
896     /// Modifies a function to run only when issuance is not paused.
897     modifier issuanceNotPaused() {
898         require(!issuancePaused, "issuance is paused");
899         _;
900     }
901 
902     /// Modifies a function to run only when there is not some emergency that requires upgrades.
903     modifier notEmergency() {
904         require(!emergency, "contract is paused");
905         _;
906     }
907 
908     /// Modifies a function to run only when the caller is the operator account.
909     modifier onlyOperator() {
910         require(_msgSender() == operator, "operator only");
911         _;
912     }
913 
914     /// Modifies a function to run and complete only if the vault is collateralized.
915     modifier vaultCollateralized() {
916         require(isFullyCollateralized(), "undercollateralized");
917         _;
918         assert(isFullyCollateralized());
919     }
920 
921     // ========================= Public + External ============================
922 
923     /// Set if issuance should be paused.
924     function setIssuancePaused(bool val) external onlyOperator {
925         emit IssuancePausedChanged(issuancePaused, val);
926         issuancePaused = val;
927     }
928 
929     /// Set if all contract actions should be paused.
930     function setEmergency(bool val) external onlyOperator {
931         emit EmergencyChanged(emergency, val);
932         emergency = val;
933     }
934 
935     /// Set the vault.
936     function setVault(address newVaultAddress) external onlyOwner {
937         emit VaultChanged(address(trustedVault), newVaultAddress);
938         trustedVault = IVault(newVaultAddress);
939     }
940 
941     /// Clear the list of proposals.
942     function clearProposals() external onlyOperator {
943         proposalsLength = 0;
944         emit ProposalsCleared();
945     }
946 
947     /// Set the operator.
948     function setOperator(address _operator) external onlyOwner {
949         emit OperatorChanged(operator, _operator);
950         operator = _operator;
951     }
952 
953     /// Set the seigniorage, in BPS.
954     function setSeigniorage(uint256 _seigniorage) external onlyOwner {
955         require(_seigniorage <= 1000, "max seigniorage 10%");
956         emit SeigniorageChanged(seigniorage, _seigniorage);
957         seigniorage = _seigniorage;
958     }
959 
960     /// Set the Proposal delay in hours.
961     function setDelay(uint256 _delay) external onlyOwner {
962         emit DelayChanged(delay, _delay);
963         delay = _delay;
964     }
965 
966     /// Ensure that the Vault is fully collateralized.  That this is true should be an
967     /// invariant of this contract: it's true before and after every txn.
968     function isFullyCollateralized() public view returns(bool) {
969         uint256 scaleFactor = WEIGHT_SCALE.mul(uint256(10) ** trustedRSV.decimals());
970         // scaleFactor unit: aqToken/qToken * qRSV/RSV
971 
972         for (uint256 i = 0; i < trustedBasket.size(); i++) {
973 
974             address trustedToken = trustedBasket.tokens(i);
975             uint256 weight = trustedBasket.weights(trustedToken); // unit: aqToken/RSV
976             uint256 balance = IERC20(trustedToken).balanceOf(address(trustedVault)); //unit: qToken
977 
978             // Return false if this token is undercollateralized:
979             if (trustedRSV.totalSupply().mul(weight) > balance.mul(scaleFactor)) {
980                 // checking units: [qRSV] * [aqToken/RSV] == [qToken] * [aqToken/qToken * qRSV/RSV]
981                 return false;
982             }
983         }
984         return true;
985     }
986 
987     /// Get amounts of basket tokens required to issue an amount of RSV.
988     /// The returned array will be in the same order as the current basket.tokens.
989     /// return unit: qToken[]
990     function toIssue(uint256 rsvAmount) public view returns (uint256[] memory) {
991         // rsvAmount unit: qRSV.
992         uint256[] memory amounts = new uint256[](trustedBasket.size());
993 
994         uint256 feeRate = uint256(seigniorage.add(BPS_FACTOR));
995         // feeRate unit: BPS
996         uint256 effectiveAmount = rsvAmount.mul(feeRate).div(BPS_FACTOR);
997         // effectiveAmount unit: qRSV == qRSV*BPS/BPS
998 
999         // On issuance, amounts[i] of token i will enter the vault. To maintain full backing,
1000         // we have to round _up_ each amounts[i].
1001         for (uint256 i = 0; i < trustedBasket.size(); i++) {
1002             address trustedToken = trustedBasket.tokens(i);
1003             amounts[i] = _weighted(
1004                 effectiveAmount,
1005                 trustedBasket.weights(trustedToken),
1006                 RoundingMode.UP
1007             );
1008             // unit: qToken = _weighted(qRSV, aqToken/RSV, _)
1009         }
1010 
1011         return amounts; // unit: qToken[]
1012     }
1013 
1014     /// Get amounts of basket tokens that would be sent upon redeeming an amount of RSV.
1015     /// The returned array will be in the same order as the current basket.tokens.
1016     /// return unit: qToken[]
1017     function toRedeem(uint256 rsvAmount) public view returns (uint256[] memory) {
1018         // rsvAmount unit: qRSV
1019         uint256[] memory amounts = new uint256[](trustedBasket.size());
1020 
1021         // On redemption, amounts[i] of token i will leave the vault. To maintain full backing,
1022         // we have to round _down_ each amounts[i].
1023         for (uint256 i = 0; i < trustedBasket.size(); i++) {
1024             address trustedToken = trustedBasket.tokens(i);
1025             amounts[i] = _weighted(
1026                 rsvAmount,
1027                 trustedBasket.weights(trustedToken),
1028                 RoundingMode.DOWN
1029             );
1030             // unit: qToken = _weighted(qRSV, aqToken/RSV, _)
1031         }
1032 
1033         return amounts;
1034     }
1035 
1036     /// Handles issuance.
1037     /// rsvAmount unit: qRSV
1038     function issue(uint256 rsvAmount) external
1039         issuanceNotPaused
1040         notEmergency
1041         vaultCollateralized
1042     {
1043         require(rsvAmount > 0, "cannot issue zero RSV");
1044         require(trustedBasket.size() > 0, "basket cannot be empty");
1045 
1046         // Accept collateral tokens.
1047         uint256[] memory amounts = toIssue(rsvAmount); // unit: qToken[]
1048         for (uint256 i = 0; i < trustedBasket.size(); i++) {
1049             IERC20(trustedBasket.tokens(i)).safeTransferFrom(
1050                 _msgSender(),
1051                 address(trustedVault),
1052                 amounts[i]
1053             );
1054             // unit check for amounts[i]: qToken.
1055         }
1056 
1057         // Compensate with RSV.
1058         trustedRSV.mint(_msgSender(), rsvAmount);
1059         // unit check for rsvAmount: qRSV.
1060 
1061         emit Issuance(_msgSender(), rsvAmount);
1062     }
1063 
1064     /// Handles redemption.
1065     /// rsvAmount unit: qRSV
1066     function redeem(uint256 rsvAmount) external notEmergency vaultCollateralized {
1067         require(rsvAmount > 0, "cannot redeem 0 RSV");
1068         require(trustedBasket.size() > 0, "basket cannot be empty");
1069 
1070         // Burn RSV tokens.
1071         trustedRSV.burnFrom(_msgSender(), rsvAmount);
1072         // unit check: rsvAmount is qRSV.
1073 
1074         // Compensate with collateral tokens.
1075         uint256[] memory amounts = toRedeem(rsvAmount); // unit: qToken[]
1076         for (uint256 i = 0; i < trustedBasket.size(); i++) {
1077             trustedVault.withdrawTo(trustedBasket.tokens(i), amounts[i], _msgSender());
1078             // unit check for amounts[i]: qToken.
1079         }
1080 
1081         emit Redemption(_msgSender(), rsvAmount);
1082     }
1083 
1084     /**
1085      * Propose an exchange of current Vault tokens for new Vault tokens.
1086      *
1087      * These parameters are phyiscally a set of arrays because Solidity doesn't let you pass
1088      * around arrays of structs as parameters of transactions. Semantically, read these three
1089      * lists as a list of triples (token, amount, toVault), where:
1090      *
1091      * - token is the address of an ERC-20 token,
1092      * - amount is the amount of the token that the proposer says they will trade with the vault,
1093      * - toVault is the direction of that trade. If toVault is true, the proposer offers to send
1094      *   `amount` of `token` to the vault. If toVault is false, the proposer expects to receive
1095      *   `amount` of `token` from the vault.
1096      *
1097      * If and when this proposal is accepted and executed, then:
1098      *
1099      * 1. The Manager checks that the proposer has allowed adequate funds, for the proposed
1100      *    transfers from the proposer to the vault.
1101      * 2. The proposed set of token transfers occur between the Vault and the proposer.
1102      * 3. The Vault's basket weights are raised and lowered, based on these token transfers and the
1103      *    total supply of RSV **at the time when the proposal is executed**.
1104      *
1105      * Note that the set of token transfers will almost always be at very slightly lower volumes
1106      * than requested, due to the rounding error involved in (a) adjusting the weights at execution
1107      * time and (b) keeping the Vault fully collateralized. The contracts should never attempt to
1108      * trade at higher volumes than requested.
1109      *
1110      * The intended behavior of proposers is that they will make proposals that shift the Vault
1111      * composition towards some known target of Reserve's management while maintaining full
1112      * backing; the expected behavior of Reserve's management is to accept only such proposals,
1113      * excepting during dire emergencies.
1114      *
1115      * Note: This type of proposal does not reliably remove token addresses!
1116      * If you want to remove token addresses entirely, use proposeWeights.
1117      *
1118      * Returns the new proposal's ID.
1119      */
1120     function proposeSwap(
1121         address[] calldata tokens,
1122         uint256[] calldata amounts, // unit: qToken
1123         bool[] calldata toVault
1124     )
1125     external notEmergency vaultCollateralized returns(uint256)
1126     {
1127         require(tokens.length == amounts.length && amounts.length == toVault.length,
1128             "proposeSwap: unequal lengths");
1129         uint256 proposalID = proposalsLength++;
1130 
1131         trustedProposals[proposalID] = trustedProposalFactory.createSwapProposal(
1132             _msgSender(),
1133             tokens,
1134             amounts,
1135             toVault
1136         );
1137         trustedProposals[proposalID].acceptOwnership();
1138 
1139         emit SwapProposed(proposalID, _msgSender(), tokens, amounts, toVault);
1140         return proposalID;
1141     }
1142 
1143 
1144     /**
1145      * Propose a new basket, defined by a list of tokens address, and their basket weights.
1146      *
1147      * Note: With this type of proposal, the allowances of tokens that will be required of the
1148      * proposer may change between proposition and execution. If the supply of RSV rises or falls,
1149      * then more or fewer tokens will be required to execute the proposal.
1150      *
1151      * Returns the new proposal's ID.
1152      */
1153 
1154     function proposeWeights(address[] calldata tokens, uint256[] calldata weights)
1155     external notEmergency vaultCollateralized returns(uint256)
1156     {
1157         require(tokens.length == weights.length, "proposeWeights: unequal lengths");
1158         require(tokens.length > 0, "proposeWeights: zero length");
1159 
1160         uint256 proposalID = proposalsLength++;
1161 
1162         trustedProposals[proposalID] = trustedProposalFactory.createWeightProposal(
1163             _msgSender(),
1164             new Basket(Basket(0), tokens, weights)
1165         );
1166         trustedProposals[proposalID].acceptOwnership();
1167 
1168         emit WeightsProposed(proposalID, _msgSender(), tokens, weights);
1169         return proposalID;
1170     }
1171 
1172     /// Accepts a proposal for a new basket, beginning the required delay.
1173     function acceptProposal(uint256 id) external onlyOperator notEmergency vaultCollateralized {
1174         require(proposalsLength > id, "proposals length <= id");
1175         trustedProposals[id].accept(now.add(delay));
1176         emit ProposalAccepted(id, trustedProposals[id].proposer());
1177     }
1178 
1179     /// Cancels a proposal. This can be done anytime before it is enacted by any of:
1180     /// 1. Proposer 2. Operator 3. Owner
1181     function cancelProposal(uint256 id) external notEmergency vaultCollateralized {
1182         require(
1183             _msgSender() == trustedProposals[id].proposer() ||
1184             _msgSender() == owner() ||
1185             _msgSender() == operator,
1186             "cannot cancel"
1187         );
1188         require(proposalsLength > id, "proposals length <= id");
1189         trustedProposals[id].cancel();
1190         emit ProposalCanceled(id, trustedProposals[id].proposer(), _msgSender());
1191     }
1192 
1193     /// Executes a proposal by exchanging collateral tokens with the proposer.
1194     function executeProposal(uint256 id) external onlyOperator notEmergency vaultCollateralized {
1195         require(proposalsLength > id, "proposals length <= id");
1196         address proposer = trustedProposals[id].proposer();
1197         Basket trustedOldBasket = trustedBasket;
1198 
1199         // Complete proposal and compute new basket
1200         trustedBasket = trustedProposals[id].complete(trustedRSV, trustedOldBasket);
1201 
1202         // For each token in either basket, perform transfers between proposer and Vault
1203         for (uint256 i = 0; i < trustedOldBasket.size(); i++) {
1204             address trustedToken = trustedOldBasket.tokens(i);
1205             _executeBasketShift(
1206                 trustedOldBasket.weights(trustedToken),
1207                 trustedBasket.weights(trustedToken),
1208                 trustedToken,
1209                 proposer
1210             );
1211         }
1212         for (uint256 i = 0; i < trustedBasket.size(); i++) {
1213             address trustedToken = trustedBasket.tokens(i);
1214             if (!trustedOldBasket.has(trustedToken)) {
1215                 _executeBasketShift(
1216                     trustedOldBasket.weights(trustedToken),
1217                     trustedBasket.weights(trustedToken),
1218                     trustedToken,
1219                     proposer
1220                 );
1221             }
1222         }
1223 
1224         emit ProposalExecuted(
1225             id,
1226             proposer,
1227             _msgSender(),
1228             address(trustedOldBasket),
1229             address(trustedBasket)
1230         );
1231     }
1232 
1233 
1234     // ============================= Internal ================================
1235 
1236     /// _executeBasketShift transfers the necessary amount of `token` between vault and `proposer`
1237     /// to rebalance the vault's balance of token, as it goes from oldBasket to newBasket.
1238     /// @dev To carry out a proposal, this is executed once per relevant token.
1239     function _executeBasketShift(
1240         uint256 oldWeight, // unit: aqTokens/RSV
1241         uint256 newWeight, // unit: aqTokens/RSV
1242         address trustedToken,
1243         address proposer
1244     ) internal {
1245         if (newWeight > oldWeight) {
1246             // This token must increase in the vault, so transfer from proposer to vault.
1247             // (Transfer into vault: round up)
1248             uint256 transferAmount =_weighted(
1249                 trustedRSV.totalSupply(),
1250                 newWeight.sub(oldWeight),
1251                 RoundingMode.UP
1252             );
1253             // transferAmount unit: qTokens
1254 
1255             if (transferAmount > 0) {
1256                 IERC20(trustedToken).safeTransferFrom(
1257                     proposer,
1258                     address(trustedVault),
1259                     transferAmount
1260                 );
1261             }
1262 
1263         } else if (newWeight < oldWeight) {
1264             // This token will decrease in the vault, so transfer from vault to proposer.
1265             // (Transfer out of vault: round down)
1266             uint256 transferAmount =_weighted(
1267                 trustedRSV.totalSupply(),
1268                 oldWeight.sub(newWeight),
1269                 RoundingMode.DOWN
1270             );
1271             // transferAmount unit: qTokens
1272             if (transferAmount > 0) {
1273                 trustedVault.withdrawTo(trustedToken, transferAmount, proposer);
1274             }
1275         }
1276     }
1277 
1278     // When you perform a weighting of some amount of RSV, it will involve a division, and
1279     // precision will be lost. When it rounds, do you want to round UP or DOWN? Be maximally
1280     // conservative.
1281     enum RoundingMode {UP, DOWN}
1282 
1283     /// From a weighting of RSV (e.g., a basket weight) and an amount of RSV,
1284     /// compute the amount of the weighted token that matches that amount of RSV.
1285     function _weighted(
1286         uint256 amount, // unit: qRSV
1287         uint256 weight, // unit: aqToken/RSV
1288         RoundingMode rnd
1289     ) internal view returns(uint256) // return unit: qTokens
1290     {
1291         uint256 scaleFactor = WEIGHT_SCALE.mul(uint256(10)**(trustedRSV.decimals()));
1292         // scaleFactor unit: aqTokens/qTokens * qRSV/RSV
1293         uint256 shiftedWeight = amount.mul(weight);
1294         // shiftedWeight unit: qRSV/RSV * aqTokens
1295 
1296         // If the weighting is precise, or we're rounding down, then use normal division.
1297         if (rnd == RoundingMode.DOWN || shiftedWeight.mod(scaleFactor) == 0) {
1298             return shiftedWeight.div(scaleFactor);
1299             // return unit: qTokens == qRSV/RSV * aqTokens * (qTokens/aqTokens * RSV/qRSV)
1300         }
1301         return shiftedWeight.div(scaleFactor).add(1); // return unit: qTokens
1302     }
1303 }