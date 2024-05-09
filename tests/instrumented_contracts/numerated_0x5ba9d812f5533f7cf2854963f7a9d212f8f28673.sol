1 pragma solidity 0.5.7;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 library Address {
6     /**
7      * @dev Returns true if `account` is a contract.
8      *
9      * This test is non-exhaustive, and there may be false-negatives: during the
10      * execution of a contract's constructor, its address will be reported as
11      * not containing a contract.
12      *
13      * IMPORTANT: It is unsafe to assume that an address for which this
14      * function returns false is an externally-owned account (EOA) and not a
15      * contract.
16      */
17     function isContract(address account) internal view returns (bool) {
18         // This method relies in extcodesize, which returns 0 for contracts in
19         // construction, since the code is only stored at the end of the
20         // constructor execution.
21 
22         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
23         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
24         // for accounts without code, i.e. `keccak256('')`
25         bytes32 codehash;
26         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
27         // solhint-disable-next-line no-inline-assembly
28         assembly { codehash := extcodehash(account) }
29         return (codehash != 0x0 && codehash != accountHash);
30     }
31 
32     /**
33      * @dev Converts an `address` into `address payable`. Note that this is
34      * simply a type cast: the actual underlying value is not changed.
35      *
36      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
37      * @dev Get it via `npm install @openzeppelin/contracts@next`.
38      */
39     function toPayable(address account) internal pure returns (address payable) {
40         return address(uint160(account));
41     }
42 }
43 
44 contract Context {
45     // Empty internal constructor, to prevent people from mistakenly deploying
46     // an instance of this contract, which should be used via inheritance.
47     constructor () internal { }
48     // solhint-disable-previous-line no-empty-blocks
49 
50     function _msgSender() internal view returns (address payable) {
51         return msg.sender;
52     }
53 
54     function _msgData() internal view returns (bytes memory) {
55         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
56         return msg.data;
57     }
58 }
59 
60 contract Basket {
61     address[] public tokens;
62     mapping(address => uint256) public weights; // unit: aqToken/RSV
63     mapping(address => bool) public has;
64     // INVARIANT: {addr | addr in tokens} == {addr | has[addr] == true}
65     
66     // SECURITY PROPERTY: The value of prev is always a Basket, and cannot be set by any user.
67     
68     // WARNING: A basket can be of size 0. It is the Manager's responsibility
69     //                    to ensure Issuance does not happen against an empty basket.
70 
71     /// Construct a new basket from an old Basket `prev`, and a list of tokens and weights with
72     /// which to update `prev`. If `prev == address(0)`, act like it's an empty basket.
73     constructor(Basket trustedPrev, address[] memory _tokens, uint256[] memory _weights) public {
74         require(_tokens.length == _weights.length, "Basket: unequal array lengths");
75 
76         // Initialize data from input arrays
77         tokens = new address[](_tokens.length);
78         for (uint256 i = 0; i < _tokens.length; i++) {
79             require(!has[_tokens[i]], "duplicate token entries");
80             weights[_tokens[i]] = _weights[i];
81             has[_tokens[i]] = true;
82             tokens[i] = _tokens[i];
83         }
84 
85         // If there's a previous basket, copy those of its contents not already set.
86         if (trustedPrev != Basket(0)) {
87             for (uint256 i = 0; i < trustedPrev.size(); i++) {
88                 address tok = trustedPrev.tokens(i);
89                 if (!has[tok]) {
90                     weights[tok] = trustedPrev.weights(tok);
91                     has[tok] = true;
92                     tokens.push(tok);
93                 }
94             }
95         }
96         require(tokens.length <= 10, "Basket: bad length");
97     }
98 
99     function getTokens() external view returns(address[] memory) {
100         return tokens;
101     }
102 
103     function size() external view returns(uint256) {
104         return tokens.length;
105     }
106 }
107 
108 library SafeMath {
109     /**
110      * @dev Returns the addition of two unsigned integers, reverting on
111      * overflow.
112      *
113      * Counterpart to Solidity's `+` operator.
114      *
115      * Requirements:
116      * - Addition cannot overflow.
117      */
118     function add(uint256 a, uint256 b) internal pure returns (uint256) {
119         uint256 c = a + b;
120         require(c >= a, "SafeMath: addition overflow");
121 
122         return c;
123     }
124 
125     /**
126      * @dev Returns the subtraction of two unsigned integers, reverting on
127      * overflow (when the result is negative).
128      *
129      * Counterpart to Solidity's `-` operator.
130      *
131      * Requirements:
132      * - Subtraction cannot overflow.
133      */
134     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
135         return sub(a, b, "SafeMath: subtraction overflow");
136     }
137 
138     /**
139      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
140      * overflow (when the result is negative).
141      *
142      * Counterpart to Solidity's `-` operator.
143      *
144      * Requirements:
145      * - Subtraction cannot overflow.
146      *
147      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
148      * @dev Get it via `npm install @openzeppelin/contracts@next`.
149      */
150     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
151         require(b <= a, errorMessage);
152         uint256 c = a - b;
153 
154         return c;
155     }
156 
157     /**
158      * @dev Returns the multiplication of two unsigned integers, reverting on
159      * overflow.
160      *
161      * Counterpart to Solidity's `*` operator.
162      *
163      * Requirements:
164      * - Multiplication cannot overflow.
165      */
166     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
167         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
168         // benefit is lost if 'b' is also tested.
169         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
170         if (a == 0) {
171             return 0;
172         }
173 
174         uint256 c = a * b;
175         require(c / a == b, "SafeMath: multiplication overflow");
176 
177         return c;
178     }
179 
180     /**
181      * @dev Returns the integer division of two unsigned integers. Reverts on
182      * division by zero. The result is rounded towards zero.
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      * - The divisor cannot be zero.
190      */
191     function div(uint256 a, uint256 b) internal pure returns (uint256) {
192         return div(a, b, "SafeMath: division by zero");
193     }
194 
195     /**
196      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
197      * division by zero. The result is rounded towards zero.
198      *
199      * Counterpart to Solidity's `/` operator. Note: this function uses a
200      * `revert` opcode (which leaves remaining gas untouched) while Solidity
201      * uses an invalid opcode to revert (consuming all remaining gas).
202      *
203      * Requirements:
204      * - The divisor cannot be zero.
205      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
206      * @dev Get it via `npm install @openzeppelin/contracts@next`.
207      */
208     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
209         // Solidity only automatically asserts when dividing by 0
210         require(b > 0, errorMessage);
211         uint256 c = a / b;
212         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
213 
214         return c;
215     }
216 
217     /**
218      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
219      * Reverts when dividing by zero.
220      *
221      * Counterpart to Solidity's `%` operator. This function uses a `revert`
222      * opcode (which leaves remaining gas untouched) while Solidity uses an
223      * invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      * - The divisor cannot be zero.
227      */
228     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
229         return mod(a, b, "SafeMath: modulo by zero");
230     }
231 
232     /**
233      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
234      * Reverts with custom message when dividing by zero.
235      *
236      * Counterpart to Solidity's `%` operator. This function uses a `revert`
237      * opcode (which leaves remaining gas untouched) while Solidity uses an
238      * invalid opcode to revert (consuming all remaining gas).
239      *
240      * Requirements:
241      * - The divisor cannot be zero.
242      *
243      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
244      * @dev Get it via `npm install @openzeppelin/contracts@next`.
245      */
246     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
247         require(b != 0, errorMessage);
248         return a % b;
249     }
250 }
251 
252 interface IRSV {
253     // Standard ERC20 functions
254     function transfer(address, uint256) external returns(bool);
255     function approve(address, uint256) external returns(bool);
256     function transferFrom(address, address, uint256) external returns(bool);
257     function totalSupply() external view returns(uint256);
258     function balanceOf(address) external view returns(uint256);
259     function allowance(address, address) external view returns(uint256);
260     event Transfer(address indexed from, address indexed to, uint256 value);
261     event Approval(address indexed owner, address indexed spender, uint256 value);
262 
263     // RSV-specific functions
264     function decimals() external view returns(uint8);
265     function mint(address, uint256) external;
266     function burnFrom(address, uint256) external;
267 }
268 
269 interface IERC20 {
270     /**
271      * @dev Returns the amount of tokens in existence.
272      */
273     function totalSupply() external view returns (uint256);
274 
275     /**
276      * @dev Returns the amount of tokens owned by `account`.
277      */
278     function balanceOf(address account) external view returns (uint256);
279 
280     /**
281      * @dev Moves `amount` tokens from the caller's account to `recipient`.
282      *
283      * Returns a boolean value indicating whether the operation succeeded.
284      *
285      * Emits a {Transfer} event.
286      */
287     function transfer(address recipient, uint256 amount) external returns (bool);
288 
289     /**
290      * @dev Returns the remaining number of tokens that `spender` will be
291      * allowed to spend on behalf of `owner` through {transferFrom}. This is
292      * zero by default.
293      *
294      * This value changes when {approve} or {transferFrom} are called.
295      */
296     function allowance(address owner, address spender) external view returns (uint256);
297 
298     /**
299      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
300      *
301      * Returns a boolean value indicating whether the operation succeeded.
302      *
303      * IMPORTANT: Beware that changing an allowance with this method brings the risk
304      * that someone may use both the old and the new allowance by unfortunate
305      * transaction ordering. One possible solution to mitigate this race
306      * condition is to first reduce the spender's allowance to 0 and set the
307      * desired value afterwards:
308      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
309      *
310      * Emits an {Approval} event.
311      */
312     function approve(address spender, uint256 amount) external returns (bool);
313 
314     /**
315      * @dev Moves `amount` tokens from `sender` to `recipient` using the
316      * allowance mechanism. `amount` is then deducted from the caller's
317      * allowance.
318      *
319      * Returns a boolean value indicating whether the operation succeeded.
320      *
321      * Emits a {Transfer} event.
322      */
323     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
324 
325     /**
326      * @dev Emitted when `value` tokens are moved from one account (`from`) to
327      * another (`to`).
328      *
329      * Note that `value` may be zero.
330      */
331     event Transfer(address indexed from, address indexed to, uint256 value);
332 
333     /**
334      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
335      * a call to {approve}. `value` is the new allowance.
336      */
337     event Approval(address indexed owner, address indexed spender, uint256 value);
338 }
339 
340 contract Ownable is Context {
341     address private _owner;
342     address private _nominatedOwner;
343 
344     event NewOwnerNominated(address indexed previousOwner, address indexed nominee);
345     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
346 
347     /**
348      * @dev Initializes the contract setting the deployer as the initial owner.
349      */
350     constructor () internal {
351         address msgSender = _msgSender();
352         _owner = msgSender;
353         emit OwnershipTransferred(address(0), msgSender);
354     }
355 
356     /**
357      * @dev Returns the address of the current owner.
358      */
359     function owner() public view returns (address) {
360         return _owner;
361     }
362 
363     /**
364      * @dev Returns the address of the current nominated owner.
365      */
366     function nominatedOwner() external view returns (address) {
367         return _nominatedOwner;
368     }
369 
370     /**
371      * @dev Throws if called by any account other than the owner.
372      */
373     modifier onlyOwner() {
374         _onlyOwner();
375         _;
376     }
377 
378     function _onlyOwner() internal view {
379         require(_msgSender() == _owner, "caller is not owner");
380     }
381 
382     /**
383      * @dev Nominates a new owner `newOwner`.
384      * Requires a follow-up `acceptOwnership`.
385      * Can only be called by the current owner.
386      */
387     function nominateNewOwner(address newOwner) external onlyOwner {
388         require(newOwner != address(0), "new owner is 0 address");
389         emit NewOwnerNominated(_owner, newOwner);
390         _nominatedOwner = newOwner;
391     }
392 
393     /**
394      * @dev Accepts ownership of the contract.
395      */
396     function acceptOwnership() external {
397         require(_nominatedOwner == _msgSender(), "unauthorized");
398         emit OwnershipTransferred(_owner, _nominatedOwner);
399         _owner = _nominatedOwner;
400     }
401 
402     /** Set `_owner` to the 0 address.
403      * Only do this to deliberately lock in the current permissions.
404      *
405      * THIS CANNOT BE UNDONE! Call this only if you know what you're doing and why you're doing it!
406      */
407     function renounceOwnership(string calldata declaration) external onlyOwner {
408         string memory requiredDeclaration = "I hereby renounce ownership of this contract forever.";
409         require(
410             keccak256(abi.encodePacked(declaration)) ==
411             keccak256(abi.encodePacked(requiredDeclaration)),
412             "declaration incorrect");
413 
414         emit OwnershipTransferred(_owner, address(0));
415         _owner = address(0);
416     }
417 }
418 
419 library SafeERC20 {
420     using SafeMath for uint256;
421     using Address for address;
422 
423     function safeTransfer(IERC20 token, address to, uint256 value) internal {
424         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
425     }
426 
427     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
428         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
429     }
430 
431     function safeApprove(IERC20 token, address spender, uint256 value) internal {
432         // safeApprove should only be called when setting an initial allowance,
433         // or when resetting it to zero. To increase and decrease it, use
434         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
435         // solhint-disable-next-line max-line-length
436         require((value == 0) || (token.allowance(address(this), spender) == 0),
437             "SafeERC20: approve from non-zero to non-zero allowance"
438         );
439         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
440     }
441 
442     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
443         uint256 newAllowance = token.allowance(address(this), spender).add(value);
444         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
445     }
446 
447     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
448         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
449         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
450     }
451 
452     /**
453      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
454      * on the return value: the return value is optional (but if data is returned, it must not be false).
455      * @param token The token targeted by the call.
456      * @param data The call data (encoded using abi.encode or one of its variants).
457      */
458     function callOptionalReturn(IERC20 token, bytes memory data) private {
459         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
460         // we're implementing it ourselves.
461 
462         // A Solidity high level call has three parts:
463         //  1. The target address is checked to verify it contains contract code
464         //  2. The call itself is made, and success asserted
465         //  3. The return value is decoded, which in turn checks the size of the returned data.
466         // solhint-disable-next-line max-line-length
467         require(address(token).isContract(), "SafeERC20: call to non-contract");
468 
469         // solhint-disable-next-line avoid-low-level-calls
470         (bool success, bytes memory returndata) = address(token).call(data);
471         require(success, "SafeERC20: low-level call failed");
472 
473         if (returndata.length > 0) { // Return data is optional
474             // solhint-disable-next-line max-line-length
475             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
476         }
477     }
478 }
479 
480 interface IProposal {
481     function proposer() external returns(address);
482     function accept(uint256 time) external;
483     function cancel() external;
484     function complete(IRSV rsv, Basket oldBasket) external returns(Basket);
485     function nominateNewOwner(address newOwner) external;
486     function acceptOwnership() external;
487 }
488 
489 interface IProposalFactory {
490     function createSwapProposal(address,
491         address[] calldata tokens,
492         uint256[] calldata amounts,
493         bool[] calldata toVault
494     ) external returns (IProposal);
495 
496     function createWeightProposal(address proposer, Basket basket) external returns (IProposal);
497 }
498 
499 contract ProposalFactory is IProposalFactory {
500     function createSwapProposal(
501         address proposer,
502         address[] calldata tokens,
503         uint256[] calldata amounts,
504         bool[] calldata toVault
505     )
506         external returns (IProposal)
507     {
508         IProposal proposal = IProposal(new SwapProposal(proposer, tokens, amounts, toVault));
509         proposal.nominateNewOwner(msg.sender);
510         return proposal;
511     }
512 
513     function createWeightProposal(address proposer, Basket basket) external returns (IProposal) {
514         IProposal proposal = IProposal(new WeightProposal(proposer, basket));
515         proposal.nominateNewOwner(msg.sender);
516         return proposal;
517     }
518 }
519 
520 contract Proposal is IProposal, Ownable {
521     using SafeMath for uint256;
522     using SafeERC20 for IERC20;
523 
524     uint256 public time;
525     address public proposer;
526 
527     enum State { Created, Accepted, Cancelled, Completed }
528     State public state;
529     
530     event ProposalCreated(address indexed proposer);
531     event ProposalAccepted(address indexed proposer, uint256 indexed time);
532     event ProposalCancelled(address indexed proposer);
533     event ProposalCompleted(address indexed proposer, address indexed basket);
534 
535     constructor(address _proposer) public {
536         proposer = _proposer;
537         state = State.Created;
538         emit ProposalCreated(proposer);
539     }
540 
541     /// Moves a proposal from the Created to Accepted state.
542     function accept(uint256 _time) external onlyOwner {
543         require(state == State.Created, "proposal not created");
544         time = _time;
545         state = State.Accepted;
546         emit ProposalAccepted(proposer, _time);
547     }
548 
549     /// Cancels a proposal if it has not been completed.
550     function cancel() external onlyOwner {
551         require(state != State.Completed);
552         state = State.Cancelled;
553         emit ProposalCancelled(proposer);
554     }
555 
556     /// Moves a proposal from the Accepted to Completed state.
557     /// Returns the tokens, quantitiesIn, and quantitiesOut, required to implement the proposal.
558     function complete(IRSV rsv, Basket oldBasket)
559         external onlyOwner returns(Basket)
560     {
561         require(state == State.Accepted, "proposal must be accepted");
562         require(now > time, "wait to execute");
563         state = State.Completed;
564 
565         Basket b = _newBasket(rsv, oldBasket);
566         emit ProposalCompleted(proposer, address(b));
567         return b;
568     }
569 
570     /// Returns the newly-proposed basket. This varies for different types of proposals,
571     /// so it's abstract here.
572     function _newBasket(IRSV trustedRSV, Basket oldBasket) internal returns(Basket);
573 }
574 
575 /**
576  * A WeightProposal represents a suggestion to change the backing for RSV to a new distribution
577  * of tokens. You can think of it as designating what a _single RSV_ should be backed by, but
578  * deferring on the precise quantities of tokens that will be need to be exchanged until a later
579  * point in time.
580  *
581  * When this proposal is completed, it simply returns the target basket.
582  */
583 contract WeightProposal is Proposal {
584     Basket public trustedBasket;
585 
586     constructor(address _proposer, Basket _trustedBasket) Proposal(_proposer) public {
587         require(_trustedBasket.size() > 0, "proposal cannot be empty");
588         trustedBasket = _trustedBasket;
589     }
590 
591     /// Returns the newly-proposed basket
592     function _newBasket(IRSV, Basket) internal returns(Basket) {
593         return trustedBasket;
594     }
595 }
596 
597 /**
598  * A SwapProposal represents a suggestion to transfer fixed amounts of tokens into and out of the
599  * vault. Whereas a WeightProposal designates how much a _single RSV_ should be backed by,
600  * a SwapProposal first designates what quantities of tokens to transfer in total and then
601  * solves for the new resultant basket later.
602  *
603  * When this proposal is completed, it calculates what the weights for the new basket will be
604  * and returns it. If RSV supply is 0, this kind of Proposal cannot be used. 
605  */
606 
607 // On "unit" comments, see comment at top of Manager.sol.
608 contract SwapProposal is Proposal {
609     address[] public tokens;
610     uint256[] public amounts; // unit: qToken
611     bool[] public toVault;
612 
613     uint256 constant WEIGHT_SCALE = uint256(10)**18; // unit: aqToken / qToken
614 
615     constructor(address _proposer,
616                 address[] memory _tokens,
617                 uint256[] memory _amounts, // unit: qToken
618                 bool[] memory _toVault )
619         Proposal(_proposer) public
620     {
621         require(_tokens.length > 0, "proposal cannot be empty");
622         require(_tokens.length == _amounts.length && _amounts.length == _toVault.length,
623                 "unequal array lengths");
624         tokens = _tokens;
625         amounts = _amounts;
626         toVault = _toVault;
627     }
628 
629     /// Return the newly-proposed basket, based on the current vault and the old basket.
630     function _newBasket(IRSV trustedRSV, Basket trustedOldBasket) internal returns(Basket) {
631 
632         uint256[] memory weights = new uint256[](tokens.length);
633         // unit: aqToken/RSV
634 
635         uint256 scaleFactor = WEIGHT_SCALE.mul(uint256(10)**(trustedRSV.decimals()));
636         // unit: aqToken/qToken * qRSV/RSV
637 
638         uint256 rsvSupply = trustedRSV.totalSupply();
639         // unit: qRSV
640 
641         for (uint256 i = 0; i < tokens.length; i++) {
642             uint256 oldWeight = trustedOldBasket.weights(tokens[i]);
643             // unit: aqToken/RSV
644 
645             if (toVault[i]) {
646                 // We require that the execution of a SwapProposal takes in no more than the funds
647                 // offered in its proposal -- that's part of the premise. It turns out that,
648                 // because we're rounding down _here_ and rounding up in
649                 // Manager._executeBasketShift(), it's possible for the naive implementation of
650                 // this mechanism to overspend the proposer's tokens by 1 qToken. We avoid that,
651                 // here, by making the effective proposal one less. Yeah, it's pretty fiddly.
652                 
653                 weights[i] = oldWeight.add( (amounts[i].sub(1)).mul(scaleFactor).div(rsvSupply) );
654                 //unit: aqToken/RSV == aqToken/RSV == [qToken] * [aqToken/qToken*qRSV/RSV] / [qRSV]
655             } else {
656                 weights[i] = oldWeight.sub( amounts[i].mul(scaleFactor).div(rsvSupply) );
657                 //unit: aqToken/RSV
658             }
659         }
660 
661         return new Basket(trustedOldBasket, tokens, weights);
662         // unit check for weights: aqToken/RSV
663     }
664 }
665 
666 
667 
668 interface IVault {
669     function withdrawTo(address, uint256, address) external;
670 }
671 
672 /**
673  * The Manager contract is the point of contact between the Reserve ecosystem and the
674  * surrounding world. It manages the Issuance and Redemption of RSV, a decentralized stablecoin
675  * backed by a basket of tokens.
676  *
677  * The Manager also implements a Proposal system to handle administration of changes to the
678  * backing of RSV. Anyone can propose a change to the backing.  Once the `owner` approves the
679  * proposal, then after a pre-determined delay the proposal is eligible for execution by
680  * anyone. However, the funds to execute the proposal must come from the proposer.
681  *
682  * There are two different ways to propose changes to the backing of RSV:
683  * - proposeSwap()
684  * - proposeWeights()
685  *
686  * In both cases, tokens are exchanged with the Vault and a new RSV backing is set. You can
687  * think of the first type of proposal as being useful when you don't want to rebalance the
688  * Vault by exchanging absolute quantities of tokens; its downside is that you don't know
689  * precisely what the resulting basket weights will be. The second type of proposal is more
690  * useful when you want to fine-tune the Vault weights and accept the downside that it's
691  * difficult to know what capital will be required when the proposal is executed.
692  */
693 
694 /* On "unit" comments:
695  *
696  * The units in use around weight computations are fiddly, and it's pretty annoying to get them
697  * properly into the Solidity type system. So, there are many comments of the form "unit:
698  * ...". Where such a comment is describing a field, method, or return parameter, the comment means
699  * that the data in that place is to be interpreted to have that type. Many places also have
700  * comments with more complicated expressions; that's manually working out the dimensional analysis
701  * to ensure that the given expression has correct units.
702  *
703  * Some dimensions used in this analysis:
704  * - 1 RSV: 1 Reserve
705  * - 1 qRSV: 1 quantum of Reserve.
706  *      (RSV & qRSV are convertible by .mul(10**reserve.decimals() qRSV/RSV))
707  * - 1 qToken: 1 quantum of an external Token.
708  * - 1 aqToken: 1 atto-quantum of an external Token.
709  *      (qToken and aqToken are convertible by .mul(10**18 aqToken/qToken)
710  * - 1 BPS: 1 Basis Point. Effectively dimensionless; convertible with .mul(10000 BPS).
711  *
712  * Note that we _never_ reason in units of Tokens or attoTokens.
713  */
714 contract Manager is Ownable {
715     using SafeERC20 for IERC20;
716     using SafeMath for uint256;
717 
718     // ROLES
719 
720     // Manager is already Ownable, but in addition it also has an `operator`.
721     address public operator;
722 
723     // DATA
724 
725     Basket public trustedBasket;
726     IVault public trustedVault;
727     IRSV public trustedRSV;
728     IProposalFactory public trustedProposalFactory;
729 
730     // Proposals
731     mapping(uint256 => IProposal) public trustedProposals;
732     uint256 public proposalsLength;
733     uint256 public delay = 24 hours;
734 
735     // Controls
736     bool public issuancePaused;
737     bool public emergency;
738 
739     // The spread between issuance and redemption in basis points (BPS).
740     uint256 public seigniorage;              // 0.1% spread -> 10 BPS. unit: BPS
741     uint256 constant BPS_FACTOR = 10000;     // This is what 100% looks like in BPS. unit: BPS
742     uint256 constant WEIGHT_SCALE = 10**18; // unit: aqToken/qToken
743 
744     event ProposalsCleared();
745 
746     // RSV traded events
747     event Issuance(address indexed user, uint256 indexed amount);
748     event Redemption(address indexed user, uint256 indexed amount);
749 
750     // Pause events
751     event IssuancePausedChanged(bool indexed oldVal, bool indexed newVal);
752     event EmergencyChanged(bool indexed oldVal, bool indexed newVal);
753     event OperatorChanged(address indexed oldAccount, address indexed newAccount);
754     event SeigniorageChanged(uint256 oldVal, uint256 newVal);
755     event VaultChanged(address indexed oldVaultAddr, address indexed newVaultAddr);
756     event DelayChanged(uint256 oldVal, uint256 newVal);
757 
758     // Proposals
759     event WeightsProposed(uint256 indexed id,
760         address indexed proposer,
761         address[] tokens,
762         uint256[] weights);
763 
764     event SwapProposed(uint256 indexed id,
765         address indexed proposer,
766         address[] tokens,
767         uint256[] amounts,
768         bool[] toVault);
769 
770     event ProposalAccepted(uint256 indexed id, address indexed proposer);
771     event ProposalCanceled(uint256 indexed id, address indexed proposer, address indexed canceler);
772     event ProposalExecuted(uint256 indexed id,
773         address indexed proposer,
774         address indexed executor,
775         address oldBasket,
776         address newBasket);
777 
778     // ============================ Constructor ===============================
779 
780     /// Begins in `emergency` state.
781     constructor(
782         address vaultAddr,
783         address rsvAddr,
784         address proposalFactoryAddr,
785         address basketAddr,
786         address operatorAddr,
787         uint256 _seigniorage) public
788     {
789         require(_seigniorage <= 1000, "max seigniorage 10%");
790         trustedVault = IVault(vaultAddr);
791         trustedRSV = IRSV(rsvAddr);
792         trustedProposalFactory = IProposalFactory(proposalFactoryAddr);
793         trustedBasket = Basket(basketAddr);
794         operator = operatorAddr;
795         seigniorage = _seigniorage;
796         emergency = true; // it's not an emergency, but we want everything to start paused.
797     }
798 
799     // ============================= Modifiers ================================
800 
801     /// Modifies a function to run only when issuance is not paused.
802     modifier issuanceNotPaused() {
803         require(!issuancePaused, "issuance is paused");
804         _;
805     }
806 
807     /// Modifies a function to run only when there is not some emergency that requires upgrades.
808     modifier notEmergency() {
809         require(!emergency, "contract is paused");
810         _;
811     }
812 
813     /// Modifies a function to run only when the caller is the operator account.
814     modifier onlyOperator() {
815         require(_msgSender() == operator, "operator only");
816         _;
817     }
818 
819     /// Modifies a function to run and complete only if the vault is collateralized.
820     modifier vaultCollateralized() {
821         require(isFullyCollateralized(), "undercollateralized");
822         _;
823         assert(isFullyCollateralized());
824     }
825 
826     // ========================= Public + External ============================
827 
828     /// Set if issuance should be paused.
829     function setIssuancePaused(bool val) external onlyOperator {
830         emit IssuancePausedChanged(issuancePaused, val);
831         issuancePaused = val;
832     }
833 
834     /// Set if all contract actions should be paused.
835     function setEmergency(bool val) external onlyOperator {
836         emit EmergencyChanged(emergency, val);
837         emergency = val;
838     }
839 
840     /// Set the vault.
841     function setVault(address newVaultAddress) external onlyOwner {
842         emit VaultChanged(address(trustedVault), newVaultAddress);
843         trustedVault = IVault(newVaultAddress);
844     }
845 
846     /// Clear the list of proposals.
847     function clearProposals() external onlyOperator {
848         proposalsLength = 0;
849         emit ProposalsCleared();
850     }
851 
852     /// Set the operator.
853     function setOperator(address _operator) external onlyOwner {
854         emit OperatorChanged(operator, _operator);
855         operator = _operator;
856     }
857 
858     /// Set the seigniorage, in BPS.
859     function setSeigniorage(uint256 _seigniorage) external onlyOwner {
860         require(_seigniorage <= 1000, "max seigniorage 10%");
861         emit SeigniorageChanged(seigniorage, _seigniorage);
862         seigniorage = _seigniorage;
863     }
864 
865     /// Set the Proposal delay in hours.
866     function setDelay(uint256 _delay) external onlyOwner {
867         emit DelayChanged(delay, _delay);
868         delay = _delay;
869     }
870 
871     /// Ensure that the Vault is fully collateralized.  That this is true should be an
872     /// invariant of this contract: it's true before and after every txn.
873     function isFullyCollateralized() public view returns(bool) {
874         uint256 scaleFactor = WEIGHT_SCALE.mul(uint256(10) ** trustedRSV.decimals());
875         // scaleFactor unit: aqToken/qToken * qRSV/RSV
876 
877         for (uint256 i = 0; i < trustedBasket.size(); i++) {
878 
879             address trustedToken = trustedBasket.tokens(i);
880             uint256 weight = trustedBasket.weights(trustedToken); // unit: aqToken/RSV
881             uint256 balance = IERC20(trustedToken).balanceOf(address(trustedVault)); //unit: qToken
882 
883             // Return false if this token is undercollateralized:
884             if (trustedRSV.totalSupply().mul(weight) > balance.mul(scaleFactor)) {
885                 // checking units: [qRSV] * [aqToken/RSV] == [qToken] * [aqToken/qToken * qRSV/RSV]
886                 return false;
887             }
888         }
889         return true;
890     }
891 
892     /// Get amounts of basket tokens required to issue an amount of RSV.
893     /// The returned array will be in the same order as the current basket.tokens.
894     /// return unit: qToken[]
895     function toIssue(uint256 rsvAmount) public view returns (uint256[] memory) {
896         // rsvAmount unit: qRSV.
897         uint256[] memory amounts = new uint256[](trustedBasket.size());
898 
899         uint256 feeRate = uint256(seigniorage.add(BPS_FACTOR));
900         // feeRate unit: BPS
901         uint256 effectiveAmount = rsvAmount.mul(feeRate).div(BPS_FACTOR);
902         // effectiveAmount unit: qRSV == qRSV*BPS/BPS
903 
904         // On issuance, amounts[i] of token i will enter the vault. To maintain full backing,
905         // we have to round _up_ each amounts[i].
906         for (uint256 i = 0; i < trustedBasket.size(); i++) {
907             address trustedToken = trustedBasket.tokens(i);
908             amounts[i] = _weighted(
909                 effectiveAmount,
910                 trustedBasket.weights(trustedToken),
911                 RoundingMode.UP
912             );
913             // unit: qToken = _weighted(qRSV, aqToken/RSV, _)
914         }
915 
916         return amounts; // unit: qToken[]
917     }
918 
919     /// Get amounts of basket tokens that would be sent upon redeeming an amount of RSV.
920     /// The returned array will be in the same order as the current basket.tokens.
921     /// return unit: qToken[]
922     function toRedeem(uint256 rsvAmount) public view returns (uint256[] memory) {
923         // rsvAmount unit: qRSV
924         uint256[] memory amounts = new uint256[](trustedBasket.size());
925 
926         // On redemption, amounts[i] of token i will leave the vault. To maintain full backing,
927         // we have to round _down_ each amounts[i].
928         for (uint256 i = 0; i < trustedBasket.size(); i++) {
929             address trustedToken = trustedBasket.tokens(i);
930             amounts[i] = _weighted(
931                 rsvAmount,
932                 trustedBasket.weights(trustedToken),
933                 RoundingMode.DOWN
934             );
935             // unit: qToken = _weighted(qRSV, aqToken/RSV, _)
936         }
937 
938         return amounts;
939     }
940 
941     /// Handles issuance.
942     /// rsvAmount unit: qRSV
943     function issue(uint256 rsvAmount) external
944         issuanceNotPaused
945         notEmergency
946         vaultCollateralized
947     {
948         require(rsvAmount > 0, "cannot issue zero RSV");
949         require(trustedBasket.size() > 0, "basket cannot be empty");
950 
951         // Accept collateral tokens.
952         uint256[] memory amounts = toIssue(rsvAmount); // unit: qToken[]
953         for (uint256 i = 0; i < trustedBasket.size(); i++) {
954             IERC20(trustedBasket.tokens(i)).safeTransferFrom(
955                 _msgSender(),
956                 address(trustedVault),
957                 amounts[i]
958             );
959             // unit check for amounts[i]: qToken.
960         }
961 
962         // Compensate with RSV.
963         trustedRSV.mint(_msgSender(), rsvAmount);
964         // unit check for rsvAmount: qRSV.
965 
966         emit Issuance(_msgSender(), rsvAmount);
967     }
968 
969     /// Handles redemption.
970     /// rsvAmount unit: qRSV
971     function redeem(uint256 rsvAmount) external notEmergency vaultCollateralized {
972         require(rsvAmount > 0, "cannot redeem 0 RSV");
973         require(trustedBasket.size() > 0, "basket cannot be empty");
974 
975         // Burn RSV tokens.
976         trustedRSV.burnFrom(_msgSender(), rsvAmount);
977         // unit check: rsvAmount is qRSV.
978 
979         // Compensate with collateral tokens.
980         uint256[] memory amounts = toRedeem(rsvAmount); // unit: qToken[]
981         for (uint256 i = 0; i < trustedBasket.size(); i++) {
982             trustedVault.withdrawTo(trustedBasket.tokens(i), amounts[i], _msgSender());
983             // unit check for amounts[i]: qToken.
984         }
985 
986         emit Redemption(_msgSender(), rsvAmount);
987     }
988 
989     /**
990      * Propose an exchange of current Vault tokens for new Vault tokens.
991      *
992      * These parameters are phyiscally a set of arrays because Solidity doesn't let you pass
993      * around arrays of structs as parameters of transactions. Semantically, read these three
994      * lists as a list of triples (token, amount, toVault), where:
995      *
996      * - token is the address of an ERC-20 token,
997      * - amount is the amount of the token that the proposer says they will trade with the vault,
998      * - toVault is the direction of that trade. If toVault is true, the proposer offers to send
999      *   `amount` of `token` to the vault. If toVault is false, the proposer expects to receive
1000      *   `amount` of `token` from the vault.
1001      *
1002      * If and when this proposal is accepted and executed, then:
1003      *
1004      * 1. The Manager checks that the proposer has allowed adequate funds, for the proposed
1005      *    transfers from the proposer to the vault.
1006      * 2. The proposed set of token transfers occur between the Vault and the proposer.
1007      * 3. The Vault's basket weights are raised and lowered, based on these token transfers and the
1008      *    total supply of RSV **at the time when the proposal is executed**.
1009      *
1010      * Note that the set of token transfers will almost always be at very slightly lower volumes
1011      * than requested, due to the rounding error involved in (a) adjusting the weights at execution
1012      * time and (b) keeping the Vault fully collateralized. The contracts should never attempt to
1013      * trade at higher volumes than requested.
1014      *
1015      * The intended behavior of proposers is that they will make proposals that shift the Vault
1016      * composition towards some known target of Reserve's management while maintaining full
1017      * backing; the expected behavior of Reserve's management is to accept only such proposals,
1018      * excepting during dire emergencies.
1019      *
1020      * Note: This type of proposal does not reliably remove token addresses!
1021      * If you want to remove token addresses entirely, use proposeWeights.
1022      *
1023      * Returns the new proposal's ID.
1024      */
1025     function proposeSwap(
1026         address[] calldata tokens,
1027         uint256[] calldata amounts, // unit: qToken
1028         bool[] calldata toVault
1029     )
1030     external notEmergency vaultCollateralized returns(uint256)
1031     {
1032         require(tokens.length == amounts.length && amounts.length == toVault.length,
1033             "proposeSwap: unequal lengths");
1034         uint256 proposalID = proposalsLength++;
1035 
1036         trustedProposals[proposalID] = trustedProposalFactory.createSwapProposal(
1037             _msgSender(),
1038             tokens,
1039             amounts,
1040             toVault
1041         );
1042         trustedProposals[proposalID].acceptOwnership();
1043 
1044         emit SwapProposed(proposalID, _msgSender(), tokens, amounts, toVault);
1045         return proposalID;
1046     }
1047 
1048 
1049     /**
1050      * Propose a new basket, defined by a list of tokens address, and their basket weights.
1051      *
1052      * Note: With this type of proposal, the allowances of tokens that will be required of the
1053      * proposer may change between proposition and execution. If the supply of RSV rises or falls,
1054      * then more or fewer tokens will be required to execute the proposal.
1055      *
1056      * Returns the new proposal's ID.
1057      */
1058 
1059     function proposeWeights(address[] calldata tokens, uint256[] calldata weights)
1060     external notEmergency vaultCollateralized returns(uint256)
1061     {
1062         require(tokens.length == weights.length, "proposeWeights: unequal lengths");
1063         require(tokens.length > 0, "proposeWeights: zero length");
1064 
1065         uint256 proposalID = proposalsLength++;
1066 
1067         trustedProposals[proposalID] = trustedProposalFactory.createWeightProposal(
1068             _msgSender(),
1069             new Basket(Basket(0), tokens, weights)
1070         );
1071         trustedProposals[proposalID].acceptOwnership();
1072 
1073         emit WeightsProposed(proposalID, _msgSender(), tokens, weights);
1074         return proposalID;
1075     }
1076 
1077     /// Accepts a proposal for a new basket, beginning the required delay.
1078     function acceptProposal(uint256 id) external onlyOperator notEmergency vaultCollateralized {
1079         require(proposalsLength > id, "proposals length <= id");
1080         trustedProposals[id].accept(now.add(delay));
1081         emit ProposalAccepted(id, trustedProposals[id].proposer());
1082     }
1083 
1084     /// Cancels a proposal. This can be done anytime before it is enacted by any of:
1085     /// 1. Proposer 2. Operator 3. Owner
1086     function cancelProposal(uint256 id) external notEmergency vaultCollateralized {
1087         require(
1088             _msgSender() == trustedProposals[id].proposer() ||
1089             _msgSender() == owner() ||
1090             _msgSender() == operator,
1091             "cannot cancel"
1092         );
1093         require(proposalsLength > id, "proposals length <= id");
1094         trustedProposals[id].cancel();
1095         emit ProposalCanceled(id, trustedProposals[id].proposer(), _msgSender());
1096     }
1097 
1098     /// Executes a proposal by exchanging collateral tokens with the proposer.
1099     function executeProposal(uint256 id) external onlyOperator notEmergency vaultCollateralized {
1100         require(proposalsLength > id, "proposals length <= id");
1101         address proposer = trustedProposals[id].proposer();
1102         Basket trustedOldBasket = trustedBasket;
1103 
1104         // Complete proposal and compute new basket
1105         trustedBasket = trustedProposals[id].complete(trustedRSV, trustedOldBasket);
1106 
1107         // For each token in either basket, perform transfers between proposer and Vault
1108         for (uint256 i = 0; i < trustedOldBasket.size(); i++) {
1109             address trustedToken = trustedOldBasket.tokens(i);
1110             _executeBasketShift(
1111                 trustedOldBasket.weights(trustedToken),
1112                 trustedBasket.weights(trustedToken),
1113                 trustedToken,
1114                 proposer
1115             );
1116         }
1117         for (uint256 i = 0; i < trustedBasket.size(); i++) {
1118             address trustedToken = trustedBasket.tokens(i);
1119             if (!trustedOldBasket.has(trustedToken)) {
1120                 _executeBasketShift(
1121                     trustedOldBasket.weights(trustedToken),
1122                     trustedBasket.weights(trustedToken),
1123                     trustedToken,
1124                     proposer
1125                 );
1126             }
1127         }
1128 
1129         emit ProposalExecuted(
1130             id,
1131             proposer,
1132             _msgSender(),
1133             address(trustedOldBasket),
1134             address(trustedBasket)
1135         );
1136     }
1137 
1138 
1139     // ============================= Internal ================================
1140 
1141     /// _executeBasketShift transfers the necessary amount of `token` between vault and `proposer`
1142     /// to rebalance the vault's balance of token, as it goes from oldBasket to newBasket.
1143     /// @dev To carry out a proposal, this is executed once per relevant token.
1144     function _executeBasketShift(
1145         uint256 oldWeight, // unit: aqTokens/RSV
1146         uint256 newWeight, // unit: aqTokens/RSV
1147         address trustedToken,
1148         address proposer
1149     ) internal {
1150         if (newWeight > oldWeight) {
1151             // This token must increase in the vault, so transfer from proposer to vault.
1152             // (Transfer into vault: round up)
1153             uint256 transferAmount =_weighted(
1154                 trustedRSV.totalSupply(),
1155                 newWeight.sub(oldWeight),
1156                 RoundingMode.UP
1157             );
1158             // transferAmount unit: qTokens
1159 
1160             if (transferAmount > 0) {
1161                 IERC20(trustedToken).safeTransferFrom(
1162                     proposer,
1163                     address(trustedVault),
1164                     transferAmount
1165                 );
1166             }
1167 
1168         } else if (newWeight < oldWeight) {
1169             // This token will decrease in the vault, so transfer from vault to proposer.
1170             // (Transfer out of vault: round down)
1171             uint256 transferAmount =_weighted(
1172                 trustedRSV.totalSupply(),
1173                 oldWeight.sub(newWeight),
1174                 RoundingMode.DOWN
1175             );
1176             // transferAmount unit: qTokens
1177             if (transferAmount > 0) {
1178                 trustedVault.withdrawTo(trustedToken, transferAmount, proposer);
1179             }
1180         }
1181     }
1182 
1183     // When you perform a weighting of some amount of RSV, it will involve a division, and
1184     // precision will be lost. When it rounds, do you want to round UP or DOWN? Be maximally
1185     // conservative.
1186     enum RoundingMode {UP, DOWN}
1187 
1188     /// From a weighting of RSV (e.g., a basket weight) and an amount of RSV,
1189     /// compute the amount of the weighted token that matches that amount of RSV.
1190     function _weighted(
1191         uint256 amount, // unit: qRSV
1192         uint256 weight, // unit: aqToken/RSV
1193         RoundingMode rnd
1194     ) internal view returns(uint256) // return unit: qTokens
1195     {
1196         uint256 scaleFactor = WEIGHT_SCALE.mul(uint256(10)**(trustedRSV.decimals()));
1197         // scaleFactor unit: aqTokens/qTokens * qRSV/RSV
1198         uint256 shiftedWeight = amount.mul(weight);
1199         // shiftedWeight unit: qRSV/RSV * aqTokens
1200 
1201         // If the weighting is precise, or we're rounding down, then use normal division.
1202         if (rnd == RoundingMode.DOWN || shiftedWeight.mod(scaleFactor) == 0) {
1203             return shiftedWeight.div(scaleFactor);
1204             // return unit: qTokens == qRSV/RSV * aqTokens * (qTokens/aqTokens * RSV/qRSV)
1205         }
1206         return shiftedWeight.div(scaleFactor).add(1); // return unit: qTokens
1207     }
1208 }