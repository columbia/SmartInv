1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.12;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address payable) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes memory) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 abstract contract Ownable is Context {
17     address private _owner;
18 
19     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20 
21     /**
22      * @dev Initializes the contract setting the deployer as the initial owner.
23      */
24     constructor () internal{
25         address msgSender = _msgSender();
26         _owner = msgSender;
27         emit OwnershipTransferred(address(0), msgSender);
28     }
29 
30     /**
31      * @dev Returns the address of the current owner.
32      */
33     function owner() public view returns (address) {
34         return _owner;
35     }
36 
37     /**
38      * @dev Throws if called by any account other than the owner.
39      */
40     modifier onlyOwner() {
41         require(_owner == _msgSender(), "Ownable: caller is not the owner");
42         _;
43     }
44 
45     /**
46      * @dev Leaves the contract without owner. It will not be possible to call
47      * `onlyOwner` functions anymore. Can only be called by the current owner.
48      *
49      * NOTE: Renouncing ownership will leave the contract without an owner,
50      * thereby removing any functionality that is only available to the owner.
51      */
52     function renounceOwnership() public virtual onlyOwner {
53         emit OwnershipTransferred(_owner, address(0));
54         _owner = address(0);
55     }
56 
57     /**
58      * @dev Transfers ownership of the contract to a new account (`newOwner`).
59      * Can only be called by the current owner.
60      */
61     function transferOwnership(address newOwner) public virtual onlyOwner {
62         require(newOwner != address(0), "Ownable: new owner is the zero address");
63         emit OwnershipTransferred(_owner, newOwner);
64         _owner = newOwner;
65     }
66 }
67 
68 library SafeMath {
69     /**
70      * @dev Returns the addition of two unsigned integers, reverting on
71      * overflow.
72      *
73      * Counterpart to Solidity's `+` operator.
74      *
75      * Requirements:
76      *
77      * - Addition cannot overflow.
78      */
79     function add(uint256 a, uint256 b) internal pure returns (uint256) {
80         uint256 c = a + b;
81         require(c >= a, "SafeMath: addition overflow");
82 
83         return c;
84     }
85 
86     /**
87      * @dev Returns the subtraction of two unsigned integers, reverting on
88      * overflow (when the result is negative).
89      *
90      * Counterpart to Solidity's `-` operator.
91      *
92      * Requirements:
93      *
94      * - Subtraction cannot overflow.
95      */
96     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
97         return sub(a, b, "SafeMath: subtraction overflow");
98     }
99 
100     /**
101      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
102      * overflow (when the result is negative).
103      *
104      * Counterpart to Solidity's `-` operator.
105      *
106      * Requirements:
107      *
108      * - Subtraction cannot overflow.
109      */
110     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
111         require(b <= a, errorMessage);
112         uint256 c = a - b;
113 
114         return c;
115     }
116 
117     /**
118      * @dev Returns the multiplication of two unsigned integers, reverting on
119      * overflow.
120      *
121      * Counterpart to Solidity's `*` operator.
122      *
123      * Requirements:
124      *
125      * - Multiplication cannot overflow.
126      */
127     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
128         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
129         // benefit is lost if 'b' is also tested.
130         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
131         if (a == 0) {
132             return 0;
133         }
134 
135         uint256 c = a * b;
136         require(c / a == b, "SafeMath: multiplication overflow");
137 
138         return c;
139     }
140 
141     /**
142      * @dev Returns the integer division of two unsigned integers. Reverts on
143      * division by zero. The result is rounded towards zero.
144      *
145      * Counterpart to Solidity's `/` operator. Note: this function uses a
146      * `revert` opcode (which leaves remaining gas untouched) while Solidity
147      * uses an invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      *
151      * - The divisor cannot be zero.
152      */
153     function div(uint256 a, uint256 b) internal pure returns (uint256) {
154         return div(a, b, "SafeMath: division by zero.");
155     }
156 
157     /**
158      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
159      * division by zero. The result is rounded towards zero.
160      *
161      * Counterpart to Solidity's `/` operator. Note: this function uses a
162      * `revert` opcode (which leaves remaining gas untouched) while Solidity
163      * uses an invalid opcode to revert (consuming all remaining gas).
164      *
165      * Requirements:
166      *
167      * - The divisor cannot be zero.
168      */
169     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
170         require(b > 0, errorMessage);
171         uint256 c = a / b;
172         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
173 
174         return c;
175     }
176 
177     /**
178      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
179      * Reverts when dividing by zero.
180      *
181      * Counterpart to Solidity's `%` operator. This function uses a `revert`
182      * opcode (which leaves remaining gas untouched) while Solidity uses an
183      * invalid opcode to revert (consuming all remaining gas).
184      *
185      * Requirements:
186      *
187      * - The divisor cannot be zero.
188      */
189     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
190         return mod(a, b, "SafeMath: modulo by zero");
191     }
192 
193     /**
194      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
195      * Reverts with custom message when dividing by zero.
196      *
197      * Counterpart to Solidity's `%` operator. This function uses a `revert`
198      * opcode (which leaves remaining gas untouched) while Solidity uses an
199      * invalid opcode to revert (consuming all remaining gas).
200      *
201      * Requirements:
202      *
203      * - The divisor cannot be zero.
204      */
205     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
206         require(b != 0, errorMessage);
207         return a % b;
208     }
209 }
210 
211 abstract contract ReentrancyGuard {
212     // Booleans are more expensive than uint256 or any type that takes up a full
213     // word because each write operation emits an extra SLOAD to first read the
214     // slot's contents, replace the bits taken up by the boolean, and then write
215     // back. This is the compiler's defense against contract upgrades and
216     // pointer aliasing, and it cannot be disabled.
217 
218     // The values being non-zero value makes deployment a bit more expensive,
219     // but in exchange the refund on every call to nonReentrant will be lower in
220     // amount. Since refunds are capped to a percentage of the total
221     // transaction's gas, it is best to keep them low in cases like this one, to
222     // increase the likelihood of the full refund coming into effect.
223     uint256 private constant _NOT_ENTERED = 1;
224     uint256 private constant _ENTERED = 2;
225 
226     uint256 private _status;
227 
228     constructor () internal {
229         _status = _NOT_ENTERED;
230     }
231 
232     /**
233      * @dev Prevents a contract from calling itself, directly or indirectly.
234      * Calling a `nonReentrant` function from another `nonReentrant`
235      * function is not supported. It is possible to prevent this from happening
236      * by making the `nonReentrant` function external, and make it call a
237      * `private` function that does the actual work.
238      */
239     modifier nonReentrant() {
240         // On the first call to nonReentrant, _notEntered will be true
241         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
242 
243         // Any calls to nonReentrant after this point will fail
244         _status = _ENTERED;
245 
246         _;
247 
248         // By storing the original value once again, a refund is triggered (see
249         // https://eips.ethereum.org/EIPS/eip-2200)
250         _status = _NOT_ENTERED;
251     }
252 }
253 
254 library TransferHelper {
255     function safeApprove(address token, address to, uint value) internal {
256         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
257         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
258     }
259 
260     function safeTransfer(address token, address to, uint value) internal {
261         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
262         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
263     }
264 
265     function safeTransferFrom(address token, address from, address to, uint value) internal {
266         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
267         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
268     }
269     
270     // sends ETH or an erc20 token
271     function safeTransferBaseToken(address token, address payable to, uint value, bool isERC20) internal {
272         if (!isERC20) {
273             to.transfer(value);
274         } else {
275             (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
276             require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
277         }
278     }
279 }
280 
281 library EnumerableSet {
282     // To implement this library for multiple types with as little code
283     // repetition as possible, we write it in terms of a generic Set type with
284     // bytes32 values.
285     // The Set implementation uses private functions, and user-facing
286     // implementations (such as AddressSet) are just wrappers around the
287     // underlying Set.
288     // This means that we can only create new EnumerableSets for types that fit
289     // in bytes32.
290 
291     struct Set {
292         // Storage of set values
293         bytes32[] _values;
294 
295         // Position of the value in the `values` array, plus 1 because index 0
296         // means a value is not in the set.
297         mapping (bytes32 => uint256) _indexes;
298     }
299 
300     /**
301      * @dev Add a value to a set. O(1).
302      *
303      * Returns true if the value was added to the set, that is if it was not
304      * already present.
305      */
306     function _add(Set storage set, bytes32 value) private returns (bool) {
307         if (!_contains(set, value)) {
308             set._values.push(value);
309             // The value is stored at length-1, but we add 1 to all indexes
310             // and use 0 as a sentinel value
311             set._indexes[value] = set._values.length;
312             return true;
313         } else {
314             return false;
315         }
316     }
317 
318     /**
319      * @dev Removes a value from a set. O(1).
320      *
321      * Returns true if the value was removed from the set, that is if it was
322      * present.
323      */
324     function _remove(Set storage set, bytes32 value) private returns (bool) {
325         // We read and store the value's index to prevent multiple reads from the same storage slot
326         uint256 valueIndex = set._indexes[value];
327 
328         if (valueIndex != 0) { // Equivalent to contains(set, value)
329             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
330             // the array, and then remove the last element (sometimes called as 'swap and pop').
331             // This modifies the order of the array, as noted in {at}.
332 
333             uint256 toDeleteIndex = valueIndex - 1;
334             uint256 lastIndex = set._values.length - 1;
335 
336             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
337             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
338 
339             bytes32 lastvalue = set._values[lastIndex];
340 
341             // Move the last value to the index where the value to delete is
342             set._values[toDeleteIndex] = lastvalue;
343             // Update the index for the moved value
344             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
345 
346             // Delete the slot where the moved value was stored
347             set._values.pop();
348 
349             // Delete the index for the deleted slot
350             delete set._indexes[value];
351 
352             return true;
353         } else {
354             return false;
355         }
356     }
357 
358     /**
359      * @dev Returns true if the value is in the set. O(1).
360      */
361     function _contains(Set storage set, bytes32 value) private view returns (bool) {
362         return set._indexes[value] != 0;
363     }
364 
365     /**
366      * @dev Returns the number of values on the set. O(1).
367      */
368     function _length(Set storage set) private view returns (uint256) {
369         return set._values.length;
370     }
371 
372    /**
373     * @dev Returns the value stored at position `index` in the set. O(1).
374     *
375     * Note that there are no guarantees on the ordering of values inside the
376     * array, and it may change when more values are added or removed.
377     *
378     * Requirements:
379     *
380     * - `index` must be strictly less than {length}.
381     */
382     function _at(Set storage set, uint256 index) private view returns (bytes32) {
383         require(set._values.length > index, "EnumerableSet: index out of bounds.");
384         return set._values[index];
385     }
386 
387     // Bytes32Set
388 
389     struct Bytes32Set {
390         Set _inner;
391     }
392 
393     /**
394      * @dev Add a value to a set. O(1).
395      *
396      * Returns true if the value was added to the set, that is if it was not
397      * already present.
398      */
399     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
400         return _add(set._inner, value);
401     }
402 
403     /**
404      * @dev Removes a value from a set. O(1).
405      *
406      * Returns true if the value was removed from the set, that is if it was
407      * present.
408      */
409     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
410         return _remove(set._inner, value);
411     }
412 
413     /**
414      * @dev Returns true if the value is in the set. O(1).
415      */
416     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
417         return _contains(set._inner, value);
418     }
419 
420     /**
421      * @dev Returns the number of values in the set. O(1).
422      */
423     function length(Bytes32Set storage set) internal view returns (uint256) {
424         return _length(set._inner);
425     }
426 
427    /**
428     * @dev Returns the value stored at position `index` in the set. O(1).
429     *
430     * Note that there are no guarantees on the ordering of values inside the
431     * array, and it may change when more values are added or removed.
432     *
433     * Requirements:
434     *
435     * - `index` must be strictly less than {length}.
436     */
437     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
438         return _at(set._inner, index);
439     }
440 
441     // AddressSet
442 
443     struct AddressSet {
444         Set _inner;
445     }
446 
447     /**
448      * @dev Add a value to a set. O(1).
449      *
450      * Returns true if the value was added to the set, that is if it was not
451      * already present.
452      */
453     function add(AddressSet storage set, address value) internal returns (bool) {
454         return _add(set._inner, bytes32(uint256(value)));
455     }
456 
457     /**
458      * @dev Removes a value from a set. O(1).
459      *
460      * Returns true if the value was removed from the set, that is if it was
461      * present.
462      */
463     function remove(AddressSet storage set, address value) internal returns (bool) {
464         return _remove(set._inner, bytes32(uint256(value)));
465     }
466 
467     /**
468      * @dev Returns true if the value is in the set. O(1).
469      */
470     function contains(AddressSet storage set, address value) internal view returns (bool) {
471         return _contains(set._inner, bytes32(uint256(value)));
472     }
473 
474     /**
475      * @dev Returns the number of values in the set. O(1).
476      */
477     function length(AddressSet storage set) internal view returns (uint256) {
478         return _length(set._inner);
479     }
480 
481    /**
482     * @dev Returns the value stored at position `index` in the set. O(1).
483     *
484     * Note that there are no guarantees on the ordering of values inside the
485     * array, and it may change when more values are added or removed.
486     *
487     * Requirements:
488     *
489     * - `index` must be strictly less than {length}.
490     */
491     function at(AddressSet storage set, uint256 index) internal view returns (address) {
492         return address(uint256(_at(set._inner, index)));
493     }
494 
495 
496     // UintSet
497 
498     struct UintSet {
499         Set _inner;
500     }
501 
502     /**
503      * @dev Add a value to a set. O(1).
504      *
505      * Returns true if the value was added to the set, that is if it was not
506      * already present.
507      */
508     function add(UintSet storage set, uint256 value) internal returns (bool) {
509         return _add(set._inner, bytes32(value));
510     }
511 
512     /**
513      * @dev Removes a value from a set. O(1).
514      *
515      * Returns true if the value was removed from the set, that is if it was
516      * present.
517      */
518     function remove(UintSet storage set, uint256 value) internal returns (bool) {
519         return _remove(set._inner, bytes32(value));
520     }
521 
522     /**
523      * @dev Returns true if the value is in the set. O(1).
524      */
525     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
526         return _contains(set._inner, bytes32(value));
527     }
528 
529     /**
530      * @dev Returns the number of values on the set. O(1).
531      */
532     function length(UintSet storage set) internal view returns (uint256) {
533         return _length(set._inner);
534     }
535 
536    /**
537     * @dev Returns the value stored at position `index` in the set. O(1).
538     *
539     * Note that there are no guarantees on the ordering of values inside the
540     * array, and it may change when more values are added or removed.
541     *
542     * Requirements:
543     *
544     * - `index` must be strictly less than {length}.
545     */
546     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
547         return uint256(_at(set._inner, index));
548     }
549 }
550 
551 interface IERC20 {
552     event Approval(address indexed owner, address indexed spender, uint value);
553     event Transfer(address indexed from, address indexed to, uint value);
554     
555     function decimals() external view returns (uint8);
556     function name() external view returns (string memory);
557     function symbol() external view returns (string memory);
558     function totalSupply() external view returns (uint);
559     function balanceOf(address owner) external view returns (uint);
560     function allowance(address owner, address spender) external view returns (uint);
561 
562     function approve(address spender, uint value) external returns (bool);
563     function transfer(address to, uint value) external returns (bool);
564     function transferFrom(address from, address to, uint value) external returns (bool);
565 }
566 
567 contract AXLPresale is ReentrancyGuard {
568     using SafeMath for uint256;
569 
570 
571     struct PresaleInfo {
572         address sale_token; // Sale token
573         uint256 token_rate; // 1 base token = ? s_tokens, fixed price
574         uint256 raise_min; // Maximum base token BUY amount per buyer
575         uint256 raise_max; // The amount of presale tokens up for presale
576         uint256 softcap; // Minimum raise amount
577         uint256 hardcap; // Maximum raise amount
578         uint256 presale_start;
579         uint256 presale_end;
580     }
581 
582     struct PresaleStatus {
583         bool force_failed; // Set this flag to force fail the presale
584         uint256 raised_amount; // Total base currency raised (usually ETH)
585         uint256 sold_amount; // Total presale tokens sold
586         uint256 token_withdraw; // Total tokens withdrawn post successful presale
587         uint256 base_withdraw; // Total base tokens withdrawn on presale failure
588         uint256 num_buyers; // Number of unique participants
589     }
590 
591     struct BuyerInfo {
592         uint256 base; // Total base token (usually ETH) deposited by user, can be withdrawn on presale failure
593         uint256 sale; // Num presale tokens a user owned, can be withdrawn on presale success
594     }
595     
596     struct TokenInfo {
597         string name;
598         string symbol;
599         uint256 totalsupply;
600         uint256 decimal;
601     }
602   
603     address owner;
604 
605     PresaleInfo public presale_info;
606     PresaleStatus public status;
607     TokenInfo public tokeninfo;
608 
609     uint256 persaleSetting;
610 
611     mapping(address => BuyerInfo) public buyers;
612 
613     event UserDepsitedSuccess(address, uint256);
614     event UserWithdrawSuccess(uint256);
615     event UserWithdrawTokensSuccess(uint256);
616 
617     address deadaddr = 0x000000000000000000000000000000000000dEaD;
618     uint256 public lock_delay;
619 
620     modifier onlyOwner() {
621         require(owner == msg.sender, "Not presale owner.");
622         _;
623     }
624 
625     constructor() public{
626         owner = msg.sender;
627     }
628 
629     function init_private (
630         address _sale_token,
631         uint256 _token_rate,
632         uint256 _raise_min, 
633         uint256 _raise_max, 
634         uint256 _softcap, 
635         uint256 _hardcap,
636         uint256 _presale_start,
637         uint256 _presale_end
638         ) public onlyOwner {
639 
640         require(persaleSetting == 0, "Already setted");
641         require(_sale_token != address(0), "Zero Address");
642         
643         presale_info.sale_token = address(_sale_token);
644         presale_info.token_rate = _token_rate;
645         presale_info.raise_min = _raise_min;
646         presale_info.raise_max = _raise_max;
647         presale_info.softcap = _softcap;
648         presale_info.hardcap = _hardcap;
649 
650         presale_info.presale_end = _presale_end;
651         presale_info.presale_start =  _presale_start;
652         
653         //Set token token info
654         tokeninfo.name = IERC20(presale_info.sale_token).name();
655         tokeninfo.symbol = IERC20(presale_info.sale_token).symbol();
656         tokeninfo.decimal = IERC20(presale_info.sale_token).decimals();
657         tokeninfo.totalsupply = IERC20(presale_info.sale_token).totalSupply();
658 
659         persaleSetting = 1;
660     }
661 
662     function presaleStatus() public view returns (uint256) {
663         if ((block.timestamp > presale_info.presale_end) && (status.raised_amount < presale_info.softcap)) {
664             return 3; // Failure
665         }
666         if (status.raised_amount >= presale_info.hardcap) {
667             return 2; // Wonderful - reached to Hardcap
668         }
669         if ((block.timestamp > presale_info.presale_end) && (status.raised_amount >= presale_info.softcap)) {
670             return 2; // SUCCESS - Presale ended with reaching Softcap
671         }
672         if ((block.timestamp >= presale_info.presale_start) && (block.timestamp <= presale_info.presale_end)) {
673             return 1; // ACTIVE - Deposits enabled, now in Presale
674         }
675             return 0; // QUED - Awaiting start block
676     }
677     
678     // Accepts msg.value for eth or _amount for ERC20 tokens
679     function userDeposit () public payable nonReentrant {
680         require(presaleStatus() == 1, "Not Active");
681         require(presale_info.raise_min <= msg.value, "Balance is insufficent");
682         require(presale_info.raise_max >= msg.value, "Balance is too much");
683 
684         BuyerInfo storage buyer = buyers[msg.sender];
685 
686         uint256 amount_in = msg.value;
687         uint256 allowance = presale_info.raise_max.sub(buyer.base);
688         uint256 remaining = presale_info.hardcap - status.raised_amount;
689 
690         allowance = allowance > remaining ? remaining : allowance;
691         if (amount_in > allowance) {
692             amount_in = allowance;
693         }
694 
695         uint256 tokensSold = amount_in.mul(presale_info.token_rate);
696 
697         require(tokensSold > 0, "ZERO TOKENS");
698         require(status.raised_amount * presale_info.token_rate <= IERC20(presale_info.sale_token).balanceOf(address(this)), "Token remain error");
699         
700         if (buyer.base == 0) {
701             status.num_buyers++;
702         }
703         buyers[msg.sender].base = buyers[msg.sender].base.add(amount_in);
704         buyers[msg.sender].sale = buyers[msg.sender].sale.add(tokensSold);
705         status.raised_amount = status.raised_amount.add(amount_in);
706         status.sold_amount = status.sold_amount.add(tokensSold);
707         
708         // return unused ETH
709         if (amount_in < msg.value) {
710             msg.sender.transfer(msg.value.sub(amount_in));
711         }
712         
713         emit UserDepsitedSuccess(msg.sender, msg.value);
714     }
715     
716     // withdraw presale tokens
717     // percentile withdrawls allows fee on transfer or rebasing tokens to still work
718     function userWithdrawTokens () public nonReentrant {
719         require(presaleStatus() == 2, "Not succeeded"); // Success
720         require(block.timestamp >= presale_info.presale_end + lock_delay, "Token Locked."); // Lock duration check
721         
722         BuyerInfo storage buyer = buyers[msg.sender];
723         uint256 remaintoken = status.sold_amount.sub(status.token_withdraw);
724         require(remaintoken >= buyer.sale, "Nothing to withdraw.");
725         
726         TransferHelper.safeTransfer(address(presale_info.sale_token), msg.sender, buyer.sale);
727         
728         status.token_withdraw = status.token_withdraw.add(buyer.sale);
729         buyers[msg.sender].sale = 0;
730         buyers[msg.sender].base = 0;
731         
732         emit UserWithdrawTokensSuccess(buyer.sale);
733     }
734     
735     // On presale failure
736     // Percentile withdrawls allows fee on transfer or rebasing tokens to still work
737     function userWithdrawBaseTokens () public nonReentrant {
738         require(presaleStatus() == 3, "Not failed."); // FAILED
739         
740         // Refund
741         BuyerInfo storage buyer = buyers[msg.sender];
742         
743         uint256 remainingBaseBalance = address(this).balance;
744         
745         require(remainingBaseBalance >= buyer.base, "Nothing to withdraw.");
746 
747         status.base_withdraw = status.base_withdraw.add(buyer.base);
748         
749         address payable reciver = payable(msg.sender);
750         reciver.transfer(buyer.base);
751 
752         if(msg.sender == owner) {
753             ownerWithdrawTokens();
754             // return;
755         }
756 
757         buyer.base = 0;
758         buyer.sale = 0;
759         
760         emit UserWithdrawSuccess(buyer.base);
761         // TransferHelper.safeTransferBaseToken(address(presale_info.base_token), msg.sender, tokensOwed, false);
762     }
763     
764     // On presale failure
765     // Allows the owner to withdraw the tokens they sent for presale
766     function ownerWithdrawTokens () private onlyOwner {
767         require(presaleStatus() == 3, "Only failed status."); // FAILED
768         TransferHelper.safeTransfer(address(presale_info.sale_token), owner, IERC20(presale_info.sale_token).balanceOf(address(this)));
769         
770         emit UserWithdrawSuccess(IERC20(presale_info.sale_token).balanceOf(address(this)));
771     }
772 
773     function purchaseICOCoin () public nonReentrant onlyOwner {
774         require(presaleStatus() == 2, "Not succeeded"); // Success
775         
776         address payable reciver = payable(owner);
777         reciver.transfer(address(this).balance);
778     }
779 
780     function getTimestamp () public view returns (uint256) {
781         return block.timestamp;
782     }
783 
784     function setLockDelay (uint256 delay) public onlyOwner {
785         lock_delay = delay;
786     }
787 
788     function remainingBurn() public onlyOwner {
789         require(presaleStatus() == 2, "Not succeeded"); // Success
790         require(presale_info.hardcap * presale_info.token_rate >= status.sold_amount, "Nothing to burn");
791         
792         //uint256 rushTokenAmount = IERC20(presale_info.sale_token).balanceOf(address(this)) - status.sold_amount * (10 ** tokeninfo.decimal);
793         uint256 rushTokenAmount = presale_info.hardcap * presale_info.token_rate - status.sold_amount;
794 
795         TransferHelper.safeTransfer(address(presale_info.sale_token), address(deadaddr), rushTokenAmount);
796     }
797 }