1 pragma solidity 0.6.12;
2 
3 /*
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with GSN meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  */
13 contract Context {
14     // Empty internal constructor, to prevent people from mistakenly deploying
15     // an instance of this contract, which should be used via inheritance.
16     constructor() internal {}
17 
18     function _msgSender() internal view returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // 
29 /**
30  * @dev Contract module which provides a basic access control mechanism, where
31  * there is an account (an owner) that can be granted exclusive access to
32  * specific functions.
33  *
34  * By default, the owner account will be the one that deploys the contract. This
35  * can later be changed with {transferOwnership}.
36  *
37  * This module is used through inheritance. It will make available the modifier
38  * `onlyOwner`, which can be applied to your functions to restrict their use to
39  * the owner.
40  */
41 contract Ownable is Context {
42     address private _owner;
43 
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46     /**
47      * @dev Initializes the contract setting the deployer as the initial owner.
48      */
49     constructor() internal {
50         address msgSender = _msgSender();
51         _owner = msgSender;
52         emit OwnershipTransferred(address(0), msgSender);
53     }
54 
55     /**
56      * @dev Returns the address of the current owner.
57      */
58     function owner() public view returns (address) {
59         return _owner;
60     }
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      */
65     modifier onlyOwner() {
66         require(_owner == _msgSender(), 'Ownable: caller is not the owner');
67         _;
68     }
69 
70     /**
71      * @dev Leaves the contract without owner. It will not be possible to call
72      * `onlyOwner` functions anymore. Can only be called by the current owner.
73      *
74      * NOTE: Renouncing ownership will leave the contract without an owner,
75      * thereby removing any functionality that is only available to the owner.
76      */
77     function renounceOwnership() public onlyOwner {
78         emit OwnershipTransferred(_owner, address(0));
79         _owner = address(0);
80     }
81 
82     /**
83      * @dev Transfers ownership of the contract to a new account (`newOwner`).
84      * Can only be called by the current owner.
85      */
86     function transferOwnership(address newOwner) public onlyOwner {
87         _transferOwnership(newOwner);
88     }
89 
90     /**
91      * @dev Transfers ownership of the contract to a new account (`newOwner`).
92      */
93     function _transferOwnership(address newOwner) internal {
94         require(newOwner != address(0), 'Ownable: new owner is the zero address');
95         emit OwnershipTransferred(_owner, newOwner);
96         _owner = newOwner;
97     }
98 }
99 
100 // 
101 interface IERC20 {
102     /**
103      * @dev Returns the amount of tokens in existence.
104      */
105     function totalSupply() external view returns (uint256);
106 
107     /**
108      * @dev Returns the token decimals.
109      */
110     function decimals() external view returns (uint8);
111 
112     /**
113      * @dev Returns the token symbol.
114      */
115     function symbol() external view returns (string memory);
116 
117     /**
118      * @dev Returns the token name.
119      */
120     function name() external view returns (string memory);
121 
122     /**
123      * @dev Returns the amount of tokens owned by `account`.
124      */
125     function balanceOf(address account) external view returns (uint256);
126 
127     /**
128      * @dev Moves `amount` tokens from the caller's account to `recipient`.
129      *
130      * Returns a boolean value indicating whether the operation succeeded.
131      *
132      * Emits a {Transfer} event.
133      */
134     function transfer(address recipient, uint256 amount) external returns (bool);
135 
136     /**
137      * @dev Returns the remaining number of tokens that `spender` will be
138      * allowed to spend on behalf of `owner` through {transferFrom}. This is
139      * zero by default.
140      *
141      * This value changes when {approve} or {transferFrom} are called.
142      */
143     function allowance(address _owner, address spender) external view returns (uint256);
144 
145     /**
146      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
147      *
148      * Returns a boolean value indicating whether the operation succeeded.
149      *
150      * IMPORTANT: Beware that changing an allowance with this method brings the risk
151      * that someone may use both the old and the new allowance by unfortunate
152      * transaction ordering. One possible solution to mitigate this race
153      * condition is to first reduce the spender's allowance to 0 and set the
154      * desired value afterwards:
155      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
156      *
157      * Emits an {Approval} event.
158      */
159     function approve(address spender, uint256 amount) external returns (bool);
160 
161     /**
162      * @dev Moves `amount` tokens from `sender` to `recipient` using the
163      * allowance mechanism. `amount` is then deducted from the caller's
164      * allowance.
165      *
166      * Returns a boolean value indicating whether the operation succeeded.
167      *
168      * Emits a {Transfer} event.
169      */
170     function transferFrom(
171         address sender,
172         address recipient,
173         uint256 amount
174     ) external returns (bool);
175 
176     /**
177      * @dev Emitted when `value` tokens are moved from one account (`from`) to
178      * another (`to`).
179      *
180      * Note that `value` may be zero.
181      */
182     event Transfer(address indexed from, address indexed to, uint256 value);
183 
184     /**
185      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
186      * a call to {approve}. `value` is the new allowance.
187      */
188     event Approval(address indexed owner, address indexed spender, uint256 value);
189 }
190 
191 // 
192 /**
193  * @dev Wrappers over Solidity's arithmetic operations with added overflow
194  * checks.
195  *
196  * Arithmetic operations in Solidity wrap on overflow. This can easily result
197  * in bugs, because programmers usually assume that an overflow raises an
198  * error, which is the standard behavior in high level programming languages.
199  * `SafeMath` restores this intuition by reverting the transaction when an
200  * operation overflows.
201  *
202  * Using this library instead of the unchecked operations eliminates an entire
203  * class of bugs, so it's recommended to use it always.
204  */
205 library SafeMath {
206     /**
207      * @dev Returns the addition of two unsigned integers, reverting on
208      * overflow.
209      *
210      * Counterpart to Solidity's `+` operator.
211      *
212      * Requirements:
213      *
214      * - Addition cannot overflow.
215      */
216     function add(uint256 a, uint256 b) internal pure returns (uint256) {
217         uint256 c = a + b;
218         require(c >= a, 'SafeMath: addition overflow');
219 
220         return c;
221     }
222 
223     /**
224      * @dev Returns the subtraction of two unsigned integers, reverting on
225      * overflow (when the result is negative).
226      *
227      * Counterpart to Solidity's `-` operator.
228      *
229      * Requirements:
230      *
231      * - Subtraction cannot overflow.
232      */
233     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
234         return sub(a, b, 'SafeMath: subtraction overflow');
235     }
236 
237     /**
238      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
239      * overflow (when the result is negative).
240      *
241      * Counterpart to Solidity's `-` operator.
242      *
243      * Requirements:
244      *
245      * - Subtraction cannot overflow.
246      */
247     function sub(
248         uint256 a,
249         uint256 b,
250         string memory errorMessage
251     ) internal pure returns (uint256) {
252         require(b <= a, errorMessage);
253         uint256 c = a - b;
254 
255         return c;
256     }
257 
258     /**
259      * @dev Returns the multiplication of two unsigned integers, reverting on
260      * overflow.
261      *
262      * Counterpart to Solidity's `*` operator.
263      *
264      * Requirements:
265      *
266      * - Multiplication cannot overflow.
267      */
268     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
269         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
270         // benefit is lost if 'b' is also tested.
271         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
272         if (a == 0) {
273             return 0;
274         }
275 
276         uint256 c = a * b;
277         require(c / a == b, 'SafeMath: multiplication overflow');
278 
279         return c;
280     }
281 
282     /**
283      * @dev Returns the integer division of two unsigned integers. Reverts on
284      * division by zero. The result is rounded towards zero.
285      *
286      * Counterpart to Solidity's `/` operator. Note: this function uses a
287      * `revert` opcode (which leaves remaining gas untouched) while Solidity
288      * uses an invalid opcode to revert (consuming all remaining gas).
289      *
290      * Requirements:
291      *
292      * - The divisor cannot be zero.
293      */
294     function div(uint256 a, uint256 b) internal pure returns (uint256) {
295         return div(a, b, 'SafeMath: division by zero');
296     }
297 
298     /**
299      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
300      * division by zero. The result is rounded towards zero.
301      *
302      * Counterpart to Solidity's `/` operator. Note: this function uses a
303      * `revert` opcode (which leaves remaining gas untouched) while Solidity
304      * uses an invalid opcode to revert (consuming all remaining gas).
305      *
306      * Requirements:
307      *
308      * - The divisor cannot be zero.
309      */
310     function div(
311         uint256 a,
312         uint256 b,
313         string memory errorMessage
314     ) internal pure returns (uint256) {
315         require(b > 0, errorMessage);
316         uint256 c = a / b;
317         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
318 
319         return c;
320     }
321 
322     /**
323      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
324      * Reverts when dividing by zero.
325      *
326      * Counterpart to Solidity's `%` operator. This function uses a `revert`
327      * opcode (which leaves remaining gas untouched) while Solidity uses an
328      * invalid opcode to revert (consuming all remaining gas).
329      *
330      * Requirements:
331      *
332      * - The divisor cannot be zero.
333      */
334     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
335         return mod(a, b, 'SafeMath: modulo by zero');
336     }
337 
338     /**
339      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
340      * Reverts with custom message when dividing by zero.
341      *
342      * Counterpart to Solidity's `%` operator. This function uses a `revert`
343      * opcode (which leaves remaining gas untouched) while Solidity uses an
344      * invalid opcode to revert (consuming all remaining gas).
345      *
346      * Requirements:
347      *
348      * - The divisor cannot be zero.
349      */
350     function mod(
351         uint256 a,
352         uint256 b,
353         string memory errorMessage
354     ) internal pure returns (uint256) {
355         require(b != 0, errorMessage);
356         return a % b;
357     }
358 
359     function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
360         z = x < y ? x : y;
361     }
362 
363     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
364     function sqrt(uint256 y) internal pure returns (uint256 z) {
365         if (y > 3) {
366             z = y;
367             uint256 x = y / 2 + 1;
368             while (x < z) {
369                 z = x;
370                 x = (y / x + x) / 2;
371             }
372         } else if (y != 0) {
373             z = 1;
374         }
375     }
376 }
377 
378 // 
379 /**
380  * @dev Collection of functions related to the address type
381  */
382 library Address {
383     /**
384      * @dev Returns true if `account` is a contract.
385      *
386      * [IMPORTANT]
387      * ====
388      * It is unsafe to assume that an address for which this function returns
389      * false is an externally-owned account (EOA) and not a contract.
390      *
391      * Among others, `isContract` will return false for the following
392      * types of addresses:
393      *
394      *  - an externally-owned account
395      *  - a contract in construction
396      *  - an address where a contract will be created
397      *  - an address where a contract lived, but was destroyed
398      * ====
399      */
400     function isContract(address account) internal view returns (bool) {
401         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
402         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
403         // for accounts without code, i.e. `keccak256('')`
404         bytes32 codehash;
405         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
406         // solhint-disable-next-line no-inline-assembly
407         assembly {
408             codehash := extcodehash(account)
409         }
410         return (codehash != accountHash && codehash != 0x0);
411     }
412 
413     /**
414      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
415      * `recipient`, forwarding all available gas and reverting on errors.
416      *
417      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
418      * of certain opcodes, possibly making contracts go over the 2300 gas limit
419      * imposed by `transfer`, making them unable to receive funds via
420      * `transfer`. {sendValue} removes this limitation.
421      *
422      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
423      *
424      * IMPORTANT: because control is transferred to `recipient`, care must be
425      * taken to not create reentrancy vulnerabilities. Consider using
426      * {ReentrancyGuard} or the
427      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
428      */
429     function sendValue(address payable recipient, uint256 amount) internal {
430         require(address(this).balance >= amount, 'Address: insufficient balance');
431 
432         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
433         (bool success, ) = recipient.call{value: amount}('');
434         require(success, 'Address: unable to send value, recipient may have reverted');
435     }
436 
437     /**
438      * @dev Performs a Solidity function call using a low level `call`. A
439      * plain`call` is an unsafe replacement for a function call: use this
440      * function instead.
441      *
442      * If `target` reverts with a revert reason, it is bubbled up by this
443      * function (like regular Solidity function calls).
444      *
445      * Returns the raw returned data. To convert to the expected return value,
446      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
447      *
448      * Requirements:
449      *
450      * - `target` must be a contract.
451      * - calling `target` with `data` must not revert.
452      *
453      * _Available since v3.1._
454      */
455     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
456         return functionCall(target, data, 'Address: low-level call failed');
457     }
458 
459     /**
460      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
461      * `errorMessage` as a fallback revert reason when `target` reverts.
462      *
463      * _Available since v3.1._
464      */
465     function functionCall(
466         address target,
467         bytes memory data,
468         string memory errorMessage
469     ) internal returns (bytes memory) {
470         return _functionCallWithValue(target, data, 0, errorMessage);
471     }
472 
473     /**
474      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
475      * but also transferring `value` wei to `target`.
476      *
477      * Requirements:
478      *
479      * - the calling contract must have an ETH balance of at least `value`.
480      * - the called Solidity function must be `payable`.
481      *
482      * _Available since v3.1._
483      */
484     function functionCallWithValue(
485         address target,
486         bytes memory data,
487         uint256 value
488     ) internal returns (bytes memory) {
489         return functionCallWithValue(target, data, value, 'Address: low-level call with value failed');
490     }
491 
492     /**
493      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
494      * with `errorMessage` as a fallback revert reason when `target` reverts.
495      *
496      * _Available since v3.1._
497      */
498     function functionCallWithValue(
499         address target,
500         bytes memory data,
501         uint256 value,
502         string memory errorMessage
503     ) internal returns (bytes memory) {
504         require(address(this).balance >= value, 'Address: insufficient balance for call');
505         return _functionCallWithValue(target, data, value, errorMessage);
506     }
507 
508     function _functionCallWithValue(
509         address target,
510         bytes memory data,
511         uint256 weiValue,
512         string memory errorMessage
513     ) private returns (bytes memory) {
514         require(isContract(target), 'Address: call to non-contract');
515 
516         // solhint-disable-next-line avoid-low-level-calls
517         (bool success, bytes memory returndata) = target.call{value: weiValue}(data);
518         if (success) {
519             return returndata;
520         } else {
521             // Look for revert reason and bubble it up if present
522             if (returndata.length > 0) {
523                 // The easiest way to bubble the revert reason is using memory via assembly
524 
525                 // solhint-disable-next-line no-inline-assembly
526                 assembly {
527                     let returndata_size := mload(returndata)
528                     revert(add(32, returndata), returndata_size)
529                 }
530             } else {
531                 revert(errorMessage);
532             }
533         }
534     }
535 }
536 
537 contract LGEWhitelisted is Context {
538     
539     using SafeMath for uint256;
540     
541     struct WhitelistRound {
542         uint256 duration;
543         uint256 amountMax;
544         mapping(address => bool) addresses;
545         mapping(address => uint256) purchased;
546     }
547   
548     WhitelistRound[] public _lgeWhitelistRounds;
549     
550     uint256 public _lgeTimestamp;
551     address public _lgePairAddress;
552     
553     address public _whitelister;
554     
555     event WhitelisterTransferred(address indexed previousWhitelister, address indexed newWhitelister);
556     
557     constructor () internal {
558         _whitelister = _msgSender();
559     }
560     
561     modifier onlyWhitelister() {
562         require(_whitelister == _msgSender(), "Caller is not the whitelister");
563         _;
564     }
565     
566     function renounceWhitelister() external onlyWhitelister {
567         emit WhitelisterTransferred(_whitelister, address(0));
568         _whitelister = address(0);
569     }
570     
571     function transferWhitelister(address newWhitelister) external onlyWhitelister {
572         _transferWhitelister(newWhitelister);
573     }
574     
575     function _transferWhitelister(address newWhitelister) internal {
576         require(newWhitelister != address(0), "New whitelister is the zero address");
577         emit WhitelisterTransferred(_whitelister, newWhitelister);
578         _whitelister = newWhitelister;
579     }
580     
581     /*
582      * createLGEWhitelist - Call this after initial Token Generation Event (TGE) 
583      * 
584      * pairAddress - address generated from createPair() event on DEX
585      * durations - array of durations (seconds) for each whitelist rounds
586      * amountsMax - array of max amounts (TOKEN decimals) for each whitelist round
587      * 
588      */
589   
590     function createLGEWhitelist(address pairAddress, uint256[] calldata durations, uint256[] calldata amountsMax) external onlyWhitelister() {
591         require(durations.length == amountsMax.length, "Invalid whitelist(s)");
592         
593         _lgePairAddress = pairAddress;
594         
595         if(durations.length > 0) {
596             
597             delete _lgeWhitelistRounds;
598         
599             for (uint256 i = 0; i < durations.length; i++) {
600                 _lgeWhitelistRounds.push(WhitelistRound(durations[i], amountsMax[i]));
601             }
602         
603         }
604     }
605     
606     /*
607      * modifyLGEWhitelistAddresses - Define what addresses are included/excluded from a whitelist round
608      * 
609      * index - 0-based index of round to modify whitelist
610      * duration - period in seconds from LGE event or previous whitelist round
611      * amountMax - max amount (TOKEN decimals) for each whitelist round
612      * 
613      */
614     
615     function modifyLGEWhitelist(uint256 index, uint256 duration, uint256 amountMax, address[] calldata addresses, bool enabled) external onlyWhitelister() {
616         require(index < _lgeWhitelistRounds.length, "Invalid index");
617         require(amountMax > 0, "Invalid amountMax");
618 
619         if(duration != _lgeWhitelistRounds[index].duration)
620             _lgeWhitelistRounds[index].duration = duration;
621         
622         if(amountMax != _lgeWhitelistRounds[index].amountMax)  
623             _lgeWhitelistRounds[index].amountMax = amountMax;
624         
625         for (uint256 i = 0; i < addresses.length; i++) {
626             _lgeWhitelistRounds[index].addresses[addresses[i]] = enabled;
627         }
628     }
629     
630     /*
631      *  getLGEWhitelistRound
632      *
633      *  returns:
634      *
635      *  1. whitelist round number ( 0 = no active round now )
636      *  2. duration, in seconds, current whitelist round is active for
637      *  3. timestamp current whitelist round closes at
638      *  4. maximum amount a whitelister can purchase in this round
639      *  5. is caller whitelisted
640      *  6. how much caller has purchased in current whitelist round
641      *
642      */
643     
644     function getLGEWhitelistRound() public view returns (uint256, uint256, uint256, uint256, bool, uint256) {
645         
646         if(_lgeTimestamp > 0) {
647             
648             uint256 wlCloseTimestampLast = _lgeTimestamp;
649         
650             for (uint256 i = 0; i < _lgeWhitelistRounds.length; i++) {
651                 
652                 WhitelistRound storage wlRound = _lgeWhitelistRounds[i];
653                 
654                 wlCloseTimestampLast = wlCloseTimestampLast.add(wlRound.duration);
655                 if(now <= wlCloseTimestampLast)
656                     return (i.add(1), wlRound.duration, wlCloseTimestampLast, wlRound.amountMax, wlRound.addresses[_msgSender()], wlRound.purchased[_msgSender()]);
657             }
658         
659         }
660         
661         return (0, 0, 0, 0, false, 0);
662     }
663     
664     /*
665      * _applyLGEWhitelist - internal function to be called initially before any transfers
666      * 
667      */
668     
669     function _applyLGEWhitelist(address sender, address recipient, uint256 amount) internal {
670         
671         if(_lgePairAddress == address(0) || _lgeWhitelistRounds.length == 0)
672             return;
673         
674         if(_lgeTimestamp == 0 && sender != _lgePairAddress && recipient == _lgePairAddress && amount > 0)
675             _lgeTimestamp = now;
676         
677         if(sender == _lgePairAddress && recipient != _lgePairAddress) {
678             //buying
679             
680             (uint256 wlRoundNumber,,,,,) = getLGEWhitelistRound();
681         
682             if(wlRoundNumber > 0) {
683                 
684                 WhitelistRound storage wlRound = _lgeWhitelistRounds[wlRoundNumber.sub(1)];
685                 
686                 require(wlRound.addresses[recipient], "LGE - Buyer is not whitelisted");
687                 
688                 uint256 amountRemaining = 0;
689                 
690                 if(wlRound.purchased[recipient] < wlRound.amountMax)
691                     amountRemaining = wlRound.amountMax.sub(wlRound.purchased[recipient]);
692     
693                 require(amount <= amountRemaining, "LGE - Amount exceeds whitelist maximum");
694                 wlRound.purchased[recipient] = wlRound.purchased[recipient].add(amount);
695                 
696             }
697             
698         }
699         
700     }
701     
702 }
703 
704 // 
705 /**
706  * @dev Implementation of the {IERC20} interface.
707  *
708  * This implementation is agnostic to the way tokens are created. This means
709  * that a supply mechanism has to be added in a derived contract using {_mint}.
710  * For a generic mechanism see {ERC20PresetMinterPauser}.
711  *
712  * TIP: For a detailed writeup see our guide
713  * https://forum.zeppelin.solutions/t/how-to-implement-ERC20-supply-mechanisms/226[How
714  * to implement supply mechanisms].
715  *
716  * We have followed general OpenZeppelin guidelines: functions revert instead
717  * of returning `false` on failure. This behavior is nonetheless conventional
718  * and does not conflict with the expectations of ERC20 applications.
719  *
720  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
721  * This allows applications to reconstruct the allowance for all accounts just
722  * by listening to said events. Other implementations of the EIP may not emit
723  * these events, as it isn't required by the specification.
724  *
725  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
726  * functions have been added to mitigate the well-known issues around setting
727  * allowances. See {IERC20-approve}.
728  */
729 contract ERC20 is Context, IERC20, Ownable {
730     using SafeMath for uint256;
731     using Address for address;
732 
733     mapping(address => uint256) private _balances;
734 
735     mapping(address => mapping(address => uint256)) private _allowances;
736 
737     uint256 private _totalSupply;
738 
739     string private _name;
740     string private _symbol;
741     uint8 private _decimals;
742 
743     /**
744      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
745      * a default value of 18.
746      *
747      * To select a different value for {decimals}, use {_setupDecimals}.
748      *
749      * All three of these values are immutable: they can only be set once during
750      * construction.
751      */
752     constructor(string memory name, string memory symbol) public {
753         _name = name;
754         _symbol = symbol;
755         _decimals = 18;
756     }
757 
758     /**
759      * @dev Returns the token name.
760      */
761     function name() public override view returns (string memory) {
762         return _name;
763     }
764 
765     /**
766      * @dev Returns the token decimals.
767      */
768     function decimals() public override view returns (uint8) {
769         return _decimals;
770     }
771 
772     /**
773      * @dev Returns the token symbol.
774      */
775     function symbol() public override view returns (string memory) {
776         return _symbol;
777     }
778 
779     /**
780      * @dev See {ERC20-totalSupply}.
781      */
782     function totalSupply() public override view returns (uint256) {
783         return _totalSupply;
784     }
785 
786     /**
787      * @dev See {ERC20-balanceOf}.
788      */
789     function balanceOf(address account) public override view returns (uint256) {
790         return _balances[account];
791     }
792 
793     /**
794      * @dev See {ERC20-transfer}.
795      *
796      * Requirements:
797      *
798      * - `recipient` cannot be the zero address.
799      * - the caller must have a balance of at least `amount`.
800      */
801     function transfer(address recipient, uint256 amount) public override returns (bool) {
802         _transfer(_msgSender(), recipient, amount);
803         return true;
804     }
805 
806     /**
807      * @dev See {ERC20-allowance}.
808      */
809     function allowance(address owner, address spender) public override view returns (uint256) {
810         return _allowances[owner][spender];
811     }
812 
813     /**
814      * @dev See {ERC20-approve}.
815      *
816      * Requirements:
817      *
818      * - `spender` cannot be the zero address.
819      */
820     function approve(address spender, uint256 amount) public override returns (bool) {
821         _approve(_msgSender(), spender, amount);
822         return true;
823     }
824 
825     /**
826      * @dev See {ERC20-transferFrom}.
827      *
828      * Emits an {Approval} event indicating the updated allowance. This is not
829      * required by the EIP. See the note at the beginning of {ERC20};
830      *
831      * Requirements:
832      * - `sender` and `recipient` cannot be the zero address.
833      * - `sender` must have a balance of at least `amount`.
834      * - the caller must have allowance for `sender`'s tokens of at least
835      * `amount`.
836      */
837     function transferFrom(
838         address sender,
839         address recipient,
840         uint256 amount
841     ) public override returns (bool) {
842         _transfer(sender, recipient, amount);
843         _approve(
844             sender,
845             _msgSender(),
846             _allowances[sender][_msgSender()].sub(amount, 'ERC20: transfer amount exceeds allowance')
847         );
848         return true;
849     }
850 
851     /**
852      * @dev Atomically increases the allowance granted to `spender` by the caller.
853      *
854      * This is an alternative to {approve} that can be used as a mitigation for
855      * problems described in {ERC20-approve}.
856      *
857      * Emits an {Approval} event indicating the updated allowance.
858      *
859      * Requirements:
860      *
861      * - `spender` cannot be the zero address.
862      */
863     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
864         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
865         return true;
866     }
867 
868     /**
869      * @dev Atomically decreases the allowance granted to `spender` by the caller.
870      *
871      * This is an alternative to {approve} that can be used as a mitigation for
872      * problems described in {ERC20-approve}.
873      *
874      * Emits an {Approval} event indicating the updated allowance.
875      *
876      * Requirements:
877      *
878      * - `spender` cannot be the zero address.
879      * - `spender` must have allowance for the caller of at least
880      * `subtractedValue`.
881      */
882     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
883         _approve(
884             _msgSender(),
885             spender,
886             _allowances[_msgSender()][spender].sub(subtractedValue, 'ERC20: decreased allowance below zero')
887         );
888         return true;
889     }
890 
891     /**
892      * @dev Creates `amount` tokens and assigns them to `msg.sender`, increasing
893      * the total supply.
894      *
895      * Requirements
896      *
897      * - `msg.sender` must be the token owner
898      */
899     function mint(uint256 amount) public onlyOwner returns (bool) {
900         _mint(_msgSender(), amount);
901         return true;
902     }
903 
904     /**
905      * @dev Moves tokens `amount` from `sender` to `recipient`.
906      *
907      * This is internal function is equivalent to {transfer}, and can be used to
908      * e.g. implement automatic token fees, slashing mechanisms, etc.
909      *
910      * Emits a {Transfer} event.
911      *
912      * Requirements:
913      *
914      * - `sender` cannot be the zero address.
915      * - `recipient` cannot be the zero address.
916      * - `sender` must have a balance of at least `amount`.
917      */
918     function _transfer(
919         address sender,
920         address recipient,
921         uint256 amount
922     ) internal {
923         require(sender != address(0), 'ERC20: transfer from the zero address');
924         require(recipient != address(0), 'ERC20: transfer to the zero address');
925 
926         _beforeTokenTransfer(sender, recipient, amount);
927   
928         _balances[sender] = _balances[sender].sub(amount, 'ERC20: transfer amount exceeds balance');
929         _balances[recipient] = _balances[recipient].add(amount);
930         emit Transfer(sender, recipient, amount);
931     }
932 
933     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
934      * the total supply.
935      *
936      * Emits a {Transfer} event with `from` set to the zero address.
937      *
938      * Requirements
939      *
940      * - `to` cannot be the zero address.
941      */
942     function _mint(address account, uint256 amount) internal {
943         require(account != address(0), 'ERC20: mint to the zero address');
944 
945         _beforeTokenTransfer(address(0), account, amount);
946  
947         _totalSupply = _totalSupply.add(amount);
948         _balances[account] = _balances[account].add(amount);
949         emit Transfer(address(0), account, amount);
950     }
951 
952     /**
953      * @dev Destroys `amount` tokens from `account`, reducing the
954      * total supply.
955      *
956      * Emits a {Transfer} event with `to` set to the zero address.
957      *
958      * Requirements
959      *
960      * - `account` cannot be the zero address.
961      * - `account` must have at least `amount` tokens.
962      */
963     function _burn(address account, uint256 amount) internal {
964         require(account != address(0), 'ERC20: burn from the zero address');
965         
966         _beforeTokenTransfer(account, address(0), amount);
967 
968         _balances[account] = _balances[account].sub(amount, 'ERC20: burn amount exceeds balance');
969         _totalSupply = _totalSupply.sub(amount);
970         emit Transfer(account, address(0), amount);
971     }
972 
973     /**
974      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
975      *
976      * This is internal function is equivalent to `approve`, and can be used to
977      * e.g. set automatic allowances for certain subsystems, etc.
978      *
979      * Emits an {Approval} event.
980      *
981      * Requirements:
982      *
983      * - `owner` cannot be the zero address.
984      * - `spender` cannot be the zero address.
985      */
986     function _approve(
987         address owner,
988         address spender,
989         uint256 amount
990     ) internal {
991         require(owner != address(0), 'ERC20: approve from the zero address');
992         require(spender != address(0), 'ERC20: approve to the zero address');
993 
994         _allowances[owner][spender] = amount;
995         emit Approval(owner, spender, amount);
996     }
997 
998     /**
999      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
1000      * from the caller's allowance.
1001      *
1002      * See {_burn} and {_approve}.
1003      */
1004     function _burnFrom(address account, uint256 amount) internal {
1005         _burn(account, amount);
1006         _approve(
1007             account,
1008             _msgSender(),
1009             _allowances[account][_msgSender()].sub(amount, 'ERC20: burn amount exceeds allowance')
1010         );
1011     }
1012     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1013 }
1014 
1015 
1016 contract IDTT is ERC20('Identity', 'IDTT'), LGEWhitelisted {
1017 
1018     uint256 private _cap = 1000000000e18;
1019     
1020     function cap() public view returns (uint256) {
1021         return _cap;
1022     }
1023 
1024     /**
1025      * @dev See {ERC20-_beforeTokenTransfer}.
1026      *
1027      * Requirements:
1028      *
1029      * - minted tokens must not cause the total supply to go over the cap.
1030      */
1031     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1032         
1033         LGEWhitelisted._applyLGEWhitelist(from, to, amount);
1034         super._beforeTokenTransfer(from, to, amount);
1035 
1036         if (from == address(0)) { // When minting tokens
1037             require(totalSupply() + amount <= _cap, "ERC20Capped: cap exceeded");
1038         }
1039     }
1040 
1041     function mint(address _to, uint256 _amount) public onlyOwner {
1042         _mint(_to, _amount);
1043     }
1044 
1045 }