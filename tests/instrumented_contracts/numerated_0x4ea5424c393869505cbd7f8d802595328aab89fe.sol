1 // File: @openzeppelin/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     /**
49      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
50      * overflow (when the result is negative).
51      *
52      * Counterpart to Solidity's `-` operator.
53      *
54      * Requirements:
55      * - Subtraction cannot overflow.
56      *
57      * _Available since v2.4.0._
58      */
59     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b <= a, errorMessage);
61         uint256 c = a - b;
62 
63         return c;
64     }
65 
66     /**
67      * @dev Returns the multiplication of two unsigned integers, reverting on
68      * overflow.
69      *
70      * Counterpart to Solidity's `*` operator.
71      *
72      * Requirements:
73      * - Multiplication cannot overflow.
74      */
75     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
77         // benefit is lost if 'b' is also tested.
78         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
79         if (a == 0) {
80             return 0;
81         }
82 
83         uint256 c = a * b;
84         require(c / a == b, "SafeMath: multiplication overflow");
85 
86         return c;
87     }
88 
89     /**
90      * @dev Returns the integer division of two unsigned integers. Reverts on
91      * division by zero. The result is rounded towards zero.
92      *
93      * Counterpart to Solidity's `/` operator. Note: this function uses a
94      * `revert` opcode (which leaves remaining gas untouched) while Solidity
95      * uses an invalid opcode to revert (consuming all remaining gas).
96      *
97      * Requirements:
98      * - The divisor cannot be zero.
99      */
100     function div(uint256 a, uint256 b) internal pure returns (uint256) {
101         return div(a, b, "SafeMath: division by zero");
102     }
103 
104     /**
105      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
106      * division by zero. The result is rounded towards zero.
107      *
108      * Counterpart to Solidity's `/` operator. Note: this function uses a
109      * `revert` opcode (which leaves remaining gas untouched) while Solidity
110      * uses an invalid opcode to revert (consuming all remaining gas).
111      *
112      * Requirements:
113      * - The divisor cannot be zero.
114      *
115      * _Available since v2.4.0._
116      */
117     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
118         // Solidity only automatically asserts when dividing by 0
119         require(b > 0, errorMessage);
120         uint256 c = a / b;
121         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
128      * Reverts when dividing by zero.
129      *
130      * Counterpart to Solidity's `%` operator. This function uses a `revert`
131      * opcode (which leaves remaining gas untouched) while Solidity uses an
132      * invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      * - The divisor cannot be zero.
136      */
137     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
138         return mod(a, b, "SafeMath: modulo by zero");
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * Reverts with custom message when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      * - The divisor cannot be zero.
151      *
152      * _Available since v2.4.0._
153      */
154     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         require(b != 0, errorMessage);
156         return a % b;
157     }
158 }
159 
160 // File: @openzeppelin/contracts/math/Math.sol
161 
162 pragma solidity ^0.5.0;
163 
164 /**
165  * @dev Standard math utilities missing in the Solidity language.
166  */
167 library Math {
168     /**
169      * @dev Returns the largest of two numbers.
170      */
171     function max(uint256 a, uint256 b) internal pure returns (uint256) {
172         return a >= b ? a : b;
173     }
174 
175     /**
176      * @dev Returns the smallest of two numbers.
177      */
178     function min(uint256 a, uint256 b) internal pure returns (uint256) {
179         return a < b ? a : b;
180     }
181 
182     /**
183      * @dev Returns the average of two numbers. The result is rounded towards
184      * zero.
185      */
186     function average(uint256 a, uint256 b) internal pure returns (uint256) {
187         // (a + b) / 2 can overflow, so we distribute
188         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
189     }
190 }
191 
192 // File: @openzeppelin/contracts/utils/Arrays.sol
193 
194 pragma solidity ^0.5.0;
195 
196 
197 /**
198  * @dev Collection of functions related to array types.
199  */
200 library Arrays {
201    /**
202      * @dev Searches a sorted `array` and returns the first index that contains
203      * a value greater or equal to `element`. If no such index exists (i.e. all
204      * values in the array are strictly less than `element`), the array length is
205      * returned. Time complexity O(log n).
206      *
207      * `array` is expected to be sorted in ascending order, and to contain no
208      * repeated elements.
209      */
210     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
211         if (array.length == 0) {
212             return 0;
213         }
214 
215         uint256 low = 0;
216         uint256 high = array.length;
217 
218         while (low < high) {
219             uint256 mid = Math.average(low, high);
220 
221             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
222             // because Math.average rounds down (it does integer division with truncation).
223             if (array[mid] > element) {
224                 high = mid;
225             } else {
226                 low = mid + 1;
227             }
228         }
229 
230         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
231         if (low > 0 && array[low - 1] == element) {
232             return low - 1;
233         } else {
234             return low;
235         }
236     }
237 }
238 
239 // File: @openzeppelin/contracts/drafts/Counters.sol
240 
241 pragma solidity ^0.5.0;
242 
243 
244 /**
245  * @title Counters
246  * @author Matt Condon (@shrugs)
247  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
248  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
249  *
250  * Include with `using Counters for Counters.Counter;`
251  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
252  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
253  * directly accessed.
254  */
255 library Counters {
256     using SafeMath for uint256;
257 
258     struct Counter {
259         // This variable should never be directly accessed by users of the library: interactions must be restricted to
260         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
261         // this feature: see https://github.com/ethereum/solidity/issues/4637
262         uint256 _value; // default: 0
263     }
264 
265     function current(Counter storage counter) internal view returns (uint256) {
266         return counter._value;
267     }
268 
269     function increment(Counter storage counter) internal {
270         // The {SafeMath} overflow check can be skipped here, see the comment at the top
271         counter._value += 1;
272     }
273 
274     function decrement(Counter storage counter) internal {
275         counter._value = counter._value.sub(1);
276     }
277 }
278 
279 // File: @openzeppelin/contracts/GSN/Context.sol
280 
281 pragma solidity ^0.5.0;
282 
283 /*
284  * @dev Provides information about the current execution context, including the
285  * sender of the transaction and its data. While these are generally available
286  * via msg.sender and msg.data, they should not be accessed in such a direct
287  * manner, since when dealing with GSN meta-transactions the account sending and
288  * paying for execution may not be the actual sender (as far as an application
289  * is concerned).
290  *
291  * This contract is only required for intermediate, library-like contracts.
292  */
293 contract Context {
294     // Empty internal constructor, to prevent people from mistakenly deploying
295     // an instance of this contract, which should be used via inheritance.
296     constructor () internal { }
297     // solhint-disable-previous-line no-empty-blocks
298 
299     function _msgSender() internal view returns (address payable) {
300         return msg.sender;
301     }
302 
303     function _msgData() internal view returns (bytes memory) {
304         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
305         return msg.data;
306     }
307 }
308 
309 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
310 
311 pragma solidity ^0.5.0;
312 
313 /**
314  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
315  * the optional functions; to access them see {ERC20Detailed}.
316  */
317 interface IERC20 {
318     /**
319      * @dev Returns the amount of tokens in existence.
320      */
321     function totalSupply() external view returns (uint256);
322 
323     /**
324      * @dev Returns the amount of tokens owned by `account`.
325      */
326     function balanceOf(address account) external view returns (uint256);
327 
328     /**
329      * @dev Moves `amount` tokens from the caller's account to `recipient`.
330      *
331      * Returns a boolean value indicating whether the operation succeeded.
332      *
333      * Emits a {Transfer} event.
334      */
335     function transfer(address recipient, uint256 amount) external returns (bool);
336 
337     /**
338      * @dev Returns the remaining number of tokens that `spender` will be
339      * allowed to spend on behalf of `owner` through {transferFrom}. This is
340      * zero by default.
341      *
342      * This value changes when {approve} or {transferFrom} are called.
343      */
344     function allowance(address owner, address spender) external view returns (uint256);
345 
346     /**
347      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
348      *
349      * Returns a boolean value indicating whether the operation succeeded.
350      *
351      * IMPORTANT: Beware that changing an allowance with this method brings the risk
352      * that someone may use both the old and the new allowance by unfortunate
353      * transaction ordering. One possible solution to mitigate this race
354      * condition is to first reduce the spender's allowance to 0 and set the
355      * desired value afterwards:
356      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
357      *
358      * Emits an {Approval} event.
359      */
360     function approve(address spender, uint256 amount) external returns (bool);
361 
362     /**
363      * @dev Moves `amount` tokens from `sender` to `recipient` using the
364      * allowance mechanism. `amount` is then deducted from the caller's
365      * allowance.
366      *
367      * Returns a boolean value indicating whether the operation succeeded.
368      *
369      * Emits a {Transfer} event.
370      */
371     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
372 
373     /**
374      * @dev Emitted when `value` tokens are moved from one account (`from`) to
375      * another (`to`).
376      *
377      * Note that `value` may be zero.
378      */
379     event Transfer(address indexed from, address indexed to, uint256 value);
380 
381     /**
382      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
383      * a call to {approve}. `value` is the new allowance.
384      */
385     event Approval(address indexed owner, address indexed spender, uint256 value);
386 }
387 
388 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
389 
390 pragma solidity ^0.5.0;
391 
392 
393 
394 
395 /**
396  * @dev Implementation of the {IERC20} interface.
397  *
398  * This implementation is agnostic to the way tokens are created. This means
399  * that a supply mechanism has to be added in a derived contract using {_mint}.
400  * For a generic mechanism see {ERC20Mintable}.
401  *
402  * TIP: For a detailed writeup see our guide
403  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
404  * to implement supply mechanisms].
405  *
406  * We have followed general OpenZeppelin guidelines: functions revert instead
407  * of returning `false` on failure. This behavior is nonetheless conventional
408  * and does not conflict with the expectations of ERC20 applications.
409  *
410  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
411  * This allows applications to reconstruct the allowance for all accounts just
412  * by listening to said events. Other implementations of the EIP may not emit
413  * these events, as it isn't required by the specification.
414  *
415  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
416  * functions have been added to mitigate the well-known issues around setting
417  * allowances. See {IERC20-approve}.
418  */
419 contract ERC20 is Context, IERC20 {
420     using SafeMath for uint256;
421 
422     mapping (address => uint256) private _balances;
423 
424     mapping (address => mapping (address => uint256)) private _allowances;
425 
426     uint256 private _totalSupply;
427 
428     /**
429      * @dev See {IERC20-totalSupply}.
430      */
431     function totalSupply() public view returns (uint256) {
432         return _totalSupply;
433     }
434 
435     /**
436      * @dev See {IERC20-balanceOf}.
437      */
438     function balanceOf(address account) public view returns (uint256) {
439         return _balances[account];
440     }
441 
442     /**
443      * @dev See {IERC20-transfer}.
444      *
445      * Requirements:
446      *
447      * - `recipient` cannot be the zero address.
448      * - the caller must have a balance of at least `amount`.
449      */
450     function transfer(address recipient, uint256 amount) public returns (bool) {
451         _transfer(_msgSender(), recipient, amount);
452         return true;
453     }
454 
455     /**
456      * @dev See {IERC20-allowance}.
457      */
458     function allowance(address owner, address spender) public view returns (uint256) {
459         return _allowances[owner][spender];
460     }
461 
462     /**
463      * @dev See {IERC20-approve}.
464      *
465      * Requirements:
466      *
467      * - `spender` cannot be the zero address.
468      */
469     function approve(address spender, uint256 amount) public returns (bool) {
470         _approve(_msgSender(), spender, amount);
471         return true;
472     }
473 
474     /**
475      * @dev See {IERC20-transferFrom}.
476      *
477      * Emits an {Approval} event indicating the updated allowance. This is not
478      * required by the EIP. See the note at the beginning of {ERC20};
479      *
480      * Requirements:
481      * - `sender` and `recipient` cannot be the zero address.
482      * - `sender` must have a balance of at least `amount`.
483      * - the caller must have allowance for `sender`'s tokens of at least
484      * `amount`.
485      */
486     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
487         _transfer(sender, recipient, amount);
488         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
489         return true;
490     }
491 
492     /**
493      * @dev Atomically increases the allowance granted to `spender` by the caller.
494      *
495      * This is an alternative to {approve} that can be used as a mitigation for
496      * problems described in {IERC20-approve}.
497      *
498      * Emits an {Approval} event indicating the updated allowance.
499      *
500      * Requirements:
501      *
502      * - `spender` cannot be the zero address.
503      */
504     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
505         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
506         return true;
507     }
508 
509     /**
510      * @dev Atomically decreases the allowance granted to `spender` by the caller.
511      *
512      * This is an alternative to {approve} that can be used as a mitigation for
513      * problems described in {IERC20-approve}.
514      *
515      * Emits an {Approval} event indicating the updated allowance.
516      *
517      * Requirements:
518      *
519      * - `spender` cannot be the zero address.
520      * - `spender` must have allowance for the caller of at least
521      * `subtractedValue`.
522      */
523     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
524         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
525         return true;
526     }
527 
528     /**
529      * @dev Moves tokens `amount` from `sender` to `recipient`.
530      *
531      * This is internal function is equivalent to {transfer}, and can be used to
532      * e.g. implement automatic token fees, slashing mechanisms, etc.
533      *
534      * Emits a {Transfer} event.
535      *
536      * Requirements:
537      *
538      * - `sender` cannot be the zero address.
539      * - `recipient` cannot be the zero address.
540      * - `sender` must have a balance of at least `amount`.
541      */
542     function _transfer(address sender, address recipient, uint256 amount) internal {
543         require(sender != address(0), "ERC20: transfer from the zero address");
544         require(recipient != address(0), "ERC20: transfer to the zero address");
545 
546         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
547         _balances[recipient] = _balances[recipient].add(amount);
548         emit Transfer(sender, recipient, amount);
549     }
550 
551     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
552      * the total supply.
553      *
554      * Emits a {Transfer} event with `from` set to the zero address.
555      *
556      * Requirements
557      *
558      * - `to` cannot be the zero address.
559      */
560     function _mint(address account, uint256 amount) internal {
561         require(account != address(0), "ERC20: mint to the zero address");
562 
563         _totalSupply = _totalSupply.add(amount);
564         _balances[account] = _balances[account].add(amount);
565         emit Transfer(address(0), account, amount);
566     }
567 
568     /**
569      * @dev Destroys `amount` tokens from `account`, reducing the
570      * total supply.
571      *
572      * Emits a {Transfer} event with `to` set to the zero address.
573      *
574      * Requirements
575      *
576      * - `account` cannot be the zero address.
577      * - `account` must have at least `amount` tokens.
578      */
579     function _burn(address account, uint256 amount) internal {
580         require(account != address(0), "ERC20: burn from the zero address");
581 
582         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
583         _totalSupply = _totalSupply.sub(amount);
584         emit Transfer(account, address(0), amount);
585     }
586 
587     /**
588      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
589      *
590      * This is internal function is equivalent to `approve`, and can be used to
591      * e.g. set automatic allowances for certain subsystems, etc.
592      *
593      * Emits an {Approval} event.
594      *
595      * Requirements:
596      *
597      * - `owner` cannot be the zero address.
598      * - `spender` cannot be the zero address.
599      */
600     function _approve(address owner, address spender, uint256 amount) internal {
601         require(owner != address(0), "ERC20: approve from the zero address");
602         require(spender != address(0), "ERC20: approve to the zero address");
603 
604         _allowances[owner][spender] = amount;
605         emit Approval(owner, spender, amount);
606     }
607 
608     /**
609      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
610      * from the caller's allowance.
611      *
612      * See {_burn} and {_approve}.
613      */
614     function _burnFrom(address account, uint256 amount) internal {
615         _burn(account, amount);
616         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
617     }
618 }
619 
620 // File: @openzeppelin/contracts/drafts/ERC20Snapshot.sol
621 
622 pragma solidity ^0.5.0;
623 
624 
625 
626 
627 
628 /**
629  * @title ERC20 token with snapshots.
630  * @dev Inspired by Jordi Baylina's
631  * https://github.com/Giveth/minimd/blob/ea04d950eea153a04c51fa510b068b9dded390cb/contracts/MiniMeToken.sol[MiniMeToken]
632  * to record historical balances.
633  *
634  * When a snapshot is made, the balances and total supply at the time of the snapshot are recorded for later
635  * access.
636  *
637  * To make a snapshot, call the {snapshot} function, which will emit the {Snapshot} event and return a snapshot id.
638  * To get the total supply from a snapshot, call the function {totalSupplyAt} with the snapshot id.
639  * To get the balance of an account from a snapshot, call the {balanceOfAt} function with the snapshot id and the
640  * account address.
641  * @author Validity Labs AG <info@validitylabs.org>
642  */
643 contract ERC20Snapshot is ERC20 {
644     using SafeMath for uint256;
645     using Arrays for uint256[];
646     using Counters for Counters.Counter;
647 
648     // Snapshotted values have arrays of ids and the value corresponding to that id. These could be an array of a
649     // Snapshot struct, but that would impede usage of functions that work on an array.
650     struct Snapshots {
651         uint256[] ids;
652         uint256[] values;
653     }
654 
655     mapping (address => Snapshots) private _accountBalanceSnapshots;
656     Snapshots private _totalSupplySnapshots;
657 
658     // Snapshot ids increase monotonically, with the first value being 1. An id of 0 is invalid.
659     Counters.Counter private _currentSnapshotId;
660 
661     event Snapshot(uint256 id);
662 
663     // Creates a new snapshot id. Balances are only stored in snapshots on demand: unless a snapshot was taken, a
664     // balance change will not be recorded. This means the extra added cost of storing snapshotted balances is only paid
665     // when required, but is also flexible enough that it allows for e.g. daily snapshots.
666     function snapshot() public returns (uint256) {
667         _currentSnapshotId.increment();
668 
669         uint256 currentId = _currentSnapshotId.current();
670         emit Snapshot(currentId);
671         return currentId;
672     }
673 
674     function balanceOfAt(address account, uint256 snapshotId) public view returns (uint256) {
675         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _accountBalanceSnapshots[account]);
676 
677         return snapshotted ? value : balanceOf(account);
678     }
679 
680     function totalSupplyAt(uint256 snapshotId) public view returns(uint256) {
681         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _totalSupplySnapshots);
682 
683         return snapshotted ? value : totalSupply();
684     }
685 
686     // _transfer, _mint and _burn are the only functions where the balances are modified, so it is there that the
687     // snapshots are updated. Note that the update happens _before_ the balance change, with the pre-modified value.
688     // The same is true for the total supply and _mint and _burn.
689     function _transfer(address from, address to, uint256 value) internal {
690         _updateAccountSnapshot(from);
691         _updateAccountSnapshot(to);
692 
693         super._transfer(from, to, value);
694     }
695 
696     function _mint(address account, uint256 value) internal {
697         _updateAccountSnapshot(account);
698         _updateTotalSupplySnapshot();
699 
700         super._mint(account, value);
701     }
702 
703     function _burn(address account, uint256 value) internal {
704         _updateAccountSnapshot(account);
705         _updateTotalSupplySnapshot();
706 
707         super._burn(account, value);
708     }
709 
710     // When a valid snapshot is queried, there are three possibilities:
711     //  a) The queried value was not modified after the snapshot was taken. Therefore, a snapshot entry was never
712     //  created for this id, and all stored snapshot ids are smaller than the requested one. The value that corresponds
713     //  to this id is the current one.
714     //  b) The queried value was modified after the snapshot was taken. Therefore, there will be an entry with the
715     //  requested id, and its value is the one to return.
716     //  c) More snapshots were created after the requested one, and the queried value was later modified. There will be
717     //  no entry for the requested id: the value that corresponds to it is that of the smallest snapshot id that is
718     //  larger than the requested one.
719     //
720     // In summary, we need to find an element in an array, returning the index of the smallest value that is larger if
721     // it is not found, unless said value doesn't exist (e.g. when all values are smaller). Arrays.findUpperBound does
722     // exactly this.
723     function _valueAt(uint256 snapshotId, Snapshots storage snapshots)
724         private view returns (bool, uint256)
725     {
726         require(snapshotId > 0, "ERC20Snapshot: id is 0");
727         // solhint-disable-next-line max-line-length
728         require(snapshotId <= _currentSnapshotId.current(), "ERC20Snapshot: nonexistent id");
729 
730         uint256 index = snapshots.ids.findUpperBound(snapshotId);
731 
732         if (index == snapshots.ids.length) {
733             return (false, 0);
734         } else {
735             return (true, snapshots.values[index]);
736         }
737     }
738 
739     function _updateAccountSnapshot(address account) private {
740         _updateSnapshot(_accountBalanceSnapshots[account], balanceOf(account));
741     }
742 
743     function _updateTotalSupplySnapshot() private {
744         _updateSnapshot(_totalSupplySnapshots, totalSupply());
745     }
746 
747     function _updateSnapshot(Snapshots storage snapshots, uint256 currentValue) private {
748         uint256 currentId = _currentSnapshotId.current();
749         if (_lastSnapshotId(snapshots.ids) < currentId) {
750             snapshots.ids.push(currentId);
751             snapshots.values.push(currentValue);
752         }
753     }
754 
755     function _lastSnapshotId(uint256[] storage ids) private view returns (uint256) {
756         if (ids.length == 0) {
757             return 0;
758         } else {
759             return ids[ids.length - 1];
760         }
761     }
762 }
763 
764 // File: @openzeppelin/contracts/access/Roles.sol
765 
766 pragma solidity ^0.5.0;
767 
768 /**
769  * @title Roles
770  * @dev Library for managing addresses assigned to a Role.
771  */
772 library Roles {
773     struct Role {
774         mapping (address => bool) bearer;
775     }
776 
777     /**
778      * @dev Give an account access to this role.
779      */
780     function add(Role storage role, address account) internal {
781         require(!has(role, account), "Roles: account already has role");
782         role.bearer[account] = true;
783     }
784 
785     /**
786      * @dev Remove an account's access to this role.
787      */
788     function remove(Role storage role, address account) internal {
789         require(has(role, account), "Roles: account does not have role");
790         role.bearer[account] = false;
791     }
792 
793     /**
794      * @dev Check if an account has this role.
795      * @return bool
796      */
797     function has(Role storage role, address account) internal view returns (bool) {
798         require(account != address(0), "Roles: account is the zero address");
799         return role.bearer[account];
800     }
801 }
802 
803 // File: @openzeppelin/contracts/access/roles/MinterRole.sol
804 
805 pragma solidity ^0.5.0;
806 
807 
808 
809 contract MinterRole is Context {
810     using Roles for Roles.Role;
811 
812     event MinterAdded(address indexed account);
813     event MinterRemoved(address indexed account);
814 
815     Roles.Role private _minters;
816 
817     constructor () internal {
818         _addMinter(_msgSender());
819     }
820 
821     modifier onlyMinter() {
822         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
823         _;
824     }
825 
826     function isMinter(address account) public view returns (bool) {
827         return _minters.has(account);
828     }
829 
830     function addMinter(address account) public onlyMinter {
831         _addMinter(account);
832     }
833 
834     function renounceMinter() public {
835         _removeMinter(_msgSender());
836     }
837 
838     function _addMinter(address account) internal {
839         _minters.add(account);
840         emit MinterAdded(account);
841     }
842 
843     function _removeMinter(address account) internal {
844         _minters.remove(account);
845         emit MinterRemoved(account);
846     }
847 }
848 
849 // File: @openzeppelin/contracts/token/ERC20/ERC20Mintable.sol
850 
851 pragma solidity ^0.5.0;
852 
853 
854 
855 /**
856  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
857  * which have permission to mint (create) new tokens as they see fit.
858  *
859  * At construction, the deployer of the contract is the only minter.
860  */
861 contract ERC20Mintable is ERC20, MinterRole {
862     /**
863      * @dev See {ERC20-_mint}.
864      *
865      * Requirements:
866      *
867      * - the caller must have the {MinterRole}.
868      */
869     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
870         _mint(account, amount);
871         return true;
872     }
873 }
874 
875 // File: contracts/incentives/IIncentives.sol
876 
877 pragma solidity ^0.5.17;
878 
879 // A simple interface used by exchange to track rewards
880 interface IIncentives {
881     // Tracks the rewards for traders / referrals based of the amount
882     function rewardTrader(address traderAddress, address referalAddress, uint256 amount) external;
883 
884     // Tracks liquidity being removed
885     function trackLiquidityRemoved(address liquidityProvider, uint256 amount) external;
886 }
887 
888 // File: contracts/registry/IRegistry.sol
889 
890 pragma solidity ^0.5.17;
891 
892 contract IRegistry {
893     function getVotingAddress() public view returns (address);
894 
895     function getExchangeFactoryAddress() public view returns (address);
896 
897     function getWethAddress() public view returns (address);
898 
899     function getMessageProcessorAddress() public view returns (address);
900 
901     function getFsTokenAddress() public view returns (address);
902 
903     function getFsTokenProxyAdminAddress() public view returns (address);
904 
905     function getIncentivesAddress() public view returns (address);
906 
907     function getWalletAddress() public view returns (address payable);
908 
909     function getReplayTrackerAddress() public view returns (address);
910 
911     function getLiquidityTokenFactoryAddress() public view returns (address);
912 
913     function hasLiquidityTokensnapshotAccess(address sender) public view returns (bool);
914 
915     function hasWalletAccess(address sender) public view returns (bool);
916 
917     function removeWalletAccess(address _walletAccessor) public;
918 
919     function isValidOracleAddress(address oracleAddress) public view returns (bool);
920 
921     function isValidVerifierAddress(address verifierAddress) public view returns (bool);
922 
923     function isValidStamperAddress(address stamperAddress) public view returns (bool);
924 
925     function isExchange(address exchangeAddress) public view returns (bool);
926 
927     function addExchange(address _exchange) public;
928 
929     function removeExchange(address _exchange) public;
930 
931     function updateVotingAddress(address _address) public;
932 }
933 
934 // File: contracts/registry/IRegistryUpdateConsumer.sol
935 
936 pragma solidity ^0.5.17;
937 
938 // Implemented by objects that need to know about registry updates.
939 interface IRegistryUpdateConsumer {
940     function onRegistryRefresh() external;
941 }
942 
943 // File: @openzeppelin/contracts/ownership/Ownable.sol
944 
945 pragma solidity ^0.5.0;
946 
947 /**
948  * @dev Contract module which provides a basic access control mechanism, where
949  * there is an account (an owner) that can be granted exclusive access to
950  * specific functions.
951  *
952  * This module is used through inheritance. It will make available the modifier
953  * `onlyOwner`, which can be applied to your functions to restrict their use to
954  * the owner.
955  */
956 contract Ownable is Context {
957     address private _owner;
958 
959     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
960 
961     /**
962      * @dev Initializes the contract setting the deployer as the initial owner.
963      */
964     constructor () internal {
965         address msgSender = _msgSender();
966         _owner = msgSender;
967         emit OwnershipTransferred(address(0), msgSender);
968     }
969 
970     /**
971      * @dev Returns the address of the current owner.
972      */
973     function owner() public view returns (address) {
974         return _owner;
975     }
976 
977     /**
978      * @dev Throws if called by any account other than the owner.
979      */
980     modifier onlyOwner() {
981         require(isOwner(), "Ownable: caller is not the owner");
982         _;
983     }
984 
985     /**
986      * @dev Returns true if the caller is the current owner.
987      */
988     function isOwner() public view returns (bool) {
989         return _msgSender() == _owner;
990     }
991 
992     /**
993      * @dev Leaves the contract without owner. It will not be possible to call
994      * `onlyOwner` functions anymore. Can only be called by the current owner.
995      *
996      * NOTE: Renouncing ownership will leave the contract without an owner,
997      * thereby removing any functionality that is only available to the owner.
998      */
999     function renounceOwnership() public onlyOwner {
1000         emit OwnershipTransferred(_owner, address(0));
1001         _owner = address(0);
1002     }
1003 
1004     /**
1005      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1006      * Can only be called by the current owner.
1007      */
1008     function transferOwnership(address newOwner) public onlyOwner {
1009         _transferOwnership(newOwner);
1010     }
1011 
1012     /**
1013      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1014      */
1015     function _transferOwnership(address newOwner) internal {
1016         require(newOwner != address(0), "Ownable: new owner is the zero address");
1017         emit OwnershipTransferred(_owner, newOwner);
1018         _owner = newOwner;
1019     }
1020 }
1021 
1022 // File: contracts/registry/RegistryHolder.sol
1023 
1024 pragma solidity ^0.5.17;
1025 
1026 
1027 
1028 // Holds a reference to the registry
1029 // Eventually Ownership will be renounced
1030 contract RegistryHolder is Ownable {
1031     address private registryAddress;
1032 
1033     function getRegistryAddress() public view returns (address) {
1034         return registryAddress;
1035     }
1036 
1037     // Change the address of registry, if the caller is the voting system as identified by the old
1038     // registry.
1039     function updateRegistry(address _newAddress) public {
1040         require(isOwner() || isVotingSystem(), "Only owner or voting system");
1041         require(_newAddress != address(0), "Zero address");
1042         registryAddress = _newAddress;
1043     }
1044 
1045     function isVotingSystem() private view returns (bool) {
1046         if (registryAddress == address(0)) {
1047             return false;
1048         }
1049         return IRegistry(registryAddress).getVotingAddress() == msg.sender;
1050     }
1051 }
1052 
1053 // File: contracts/registry/KnowsRegistry.sol
1054 
1055 pragma solidity ^0.5.17;
1056 
1057 
1058 
1059 
1060 // Base class for objects that need to know about other objects in the system
1061 // This allows us to share modifiers and have a unified way of looking up other objects.
1062 contract KnowsRegistry is IRegistryUpdateConsumer {
1063     RegistryHolder private registryHolder;
1064 
1065     modifier onlyVotingSystem() {
1066         require(isVotingSystem(msg.sender), "Only voting system");
1067         _;
1068     }
1069 
1070     modifier onlyExchangeFactory() {
1071         require(isExchangeFactory(msg.sender), "Only exchange factory");
1072         _;
1073     }
1074 
1075     modifier onlyExchangeFactoryOrVotingSystem() {
1076         require(isExchangeFactory(msg.sender) || isVotingSystem(msg.sender), "Only exchange factory or voting");
1077         _;
1078     }
1079 
1080     modifier requiresWalletAcccess() {
1081         require(getRegistry().hasWalletAccess(msg.sender), "requires wallet access");
1082         _;
1083     }
1084 
1085     modifier onlyMessageProcessor() {
1086         require(getRegistry().getMessageProcessorAddress() == msg.sender, "only MessageProcessor");
1087         _;
1088     }
1089 
1090     modifier onlyExchange() {
1091         require(getRegistry().isExchange(msg.sender), "Only exchange");
1092         _;
1093     }
1094 
1095     modifier onlyRegistry() {
1096         require(getRegistryAddress() == msg.sender, "only registry");
1097         _;
1098     }
1099 
1100     modifier onlyOracle() {
1101         require(isValidOracleAddress(msg.sender), "only oracle");
1102         _;
1103     }
1104 
1105     modifier requiresLiquidityTokenSnapshotAccess() {
1106         require(getRegistry().hasLiquidityTokensnapshotAccess(msg.sender), "only incentives");
1107         _;
1108     }
1109 
1110     constructor(address _registryHolder) public {
1111         registryHolder = RegistryHolder(_registryHolder);
1112     }
1113 
1114     function getRegistryHolder() internal view returns (RegistryHolder) {
1115         return registryHolder;
1116     }
1117 
1118     function getRegistry() internal view returns (IRegistry) {
1119         return IRegistry(getRegistryAddress());
1120     }
1121 
1122     function getRegistryAddress() internal view returns (address) {
1123         return registryHolder.getRegistryAddress();
1124     }
1125 
1126     function isRegistryHolder(address a) internal view returns (bool) {
1127         return a == address(registryHolder);
1128     }
1129 
1130     function isValidOracleAddress(address oracleAddress) public view returns (bool) {
1131         return getRegistry().isValidOracleAddress(oracleAddress);
1132     }
1133 
1134     function isValidVerifierAddress(address verifierAddress) public view returns (bool) {
1135         return getRegistry().isValidVerifierAddress(verifierAddress);
1136     }
1137 
1138     function isValidStamperAddress(address stamperAddress) public view returns (bool) {
1139         return getRegistry().isValidStamperAddress(stamperAddress);
1140     }
1141 
1142     function isVotingSystem(address a) public view returns (bool) {
1143         return a == getRegistry().getVotingAddress();
1144     }
1145 
1146     function isExchangeFactory(address a) public view returns (bool) {
1147         return a == getRegistry().getExchangeFactoryAddress();
1148     }
1149 
1150     function checkNotNull(address a) internal pure returns (address) {
1151         require(a != address(0), "address must be non zero");
1152         return a;
1153     }
1154 
1155     function checkNotNullAP(address payable a) internal pure returns (address payable) {
1156         require(a != address(0), "address must be non zero");
1157         return a;
1158     }
1159 }
1160 
1161 // File: contracts/incentives/Incentives.sol
1162 
1163 pragma solidity ^0.5.17;
1164 
1165 
1166 
1167 
1168 
1169 
1170 contract Incentives is KnowsRegistry, IIncentives {
1171     using SafeMath for uint256;
1172 
1173     // A structure containin all data about an exchange
1174     struct ExchangeData {
1175         address exchangeAddress;
1176         // The liquidity token of the exchange
1177         ERC20Snapshot liquidityToken;
1178         uint256 defaultLiquidityPayoutMultiplier;
1179         uint256 defaultTraderPayoutMultiplier;
1180         uint256 defaultReferralPayoutMultiplier;
1181         uint256 defaultExchangeWeight;
1182         // A mapping for all epochs this exchange has been active
1183         mapping(uint16 => Epoch) epochEntries;
1184         // Has this exchange been removed
1185         bool isRemoved;
1186     }
1187 
1188     // An epoch entry for an exchange
1189     struct Epoch {
1190         uint256 snapShotId;
1191         uint256 liquidityPayoutMultiplier;
1192         uint256 traderPayoutMultiplier;
1193         uint256 referralPayoutMultiplier;
1194         uint256 exchangeWeight;
1195         uint256 sumOfExchangeWeights;
1196         uint256 totalLiquidityRemoved;
1197         mapping(address => uint256) traderPayout;
1198         mapping(address => uint256) referralPayout;
1199         mapping(address => uint256) withdrawnLiquidityByAddress;
1200         uint256 totalTraderPayout;
1201         uint256 totalReferralPayout;
1202         bool isActiveEpoch;
1203         mapping(address => bool) paidOutLiquidityByAddress;
1204         bool isRemoved;
1205     }
1206 
1207     event ReferralPayout(address _target, uint256 totalPayout);
1208     event TraderPayout(address _target, uint256 totalPayout);
1209     event LiquidityProviderPayout(address _target, uint256 totalPayout);
1210 
1211     // Reference to the fsToken contract
1212     ERC20Mintable public fsToken;
1213 
1214     // A mapping from exchange address to ExchangeData
1215     mapping(address => ExchangeData) public exchangeDataByExchangeAddress;
1216     // A list of all supported exchanges, when exchanges get removed they simply get marked as removed
1217     // in the ExchangeData / EpochEntry
1218     address[] private allExchangeAddresses;
1219 
1220     // The count of epochs since this contract has launched
1221     uint16 public epochCount;
1222 
1223     // The maximum epoch this contract will run for ~5 years
1224     uint16 public maxEpoch = 1750;
1225     uint256 public totalTokensToMintPerEpoch = 40000 ether;
1226     // Time until the next epoch can be rolled forward
1227     // We chose slightly less than 24 hrs since we expect this to drift over time
1228     // allowing us to make up for a slight drift by sending the transaction slightly earlier
1229     uint256 public epochAdvanceTime = 23 hours + 55 minutes;
1230 
1231     uint256 public lastUpdateTimestamp = now;
1232     // The sum of all exchanges weight that are being active.
1233     uint256 public currentSumOfExchangeWeights;
1234 
1235     // will not payout to LP's if less to minRequiredSnapshotId
1236     uint256 public minRequiredSnapshotId = 0;
1237 
1238     constructor(address _registryHolder) public KnowsRegistry(_registryHolder) {
1239         fsToken = ERC20Mintable(getRegistry().getFsTokenAddress());
1240     }
1241 
1242     function setMaxEpoch(uint16 _maxEpoch) public onlyVotingSystem {
1243         maxEpoch = _maxEpoch;
1244     }
1245     function setTotalTokensToMintPerEpoch(uint256 _totalTokensToMintPerEpoch) public onlyVotingSystem {
1246         totalTokensToMintPerEpoch = _totalTokensToMintPerEpoch;
1247     }
1248     function setEpochAdvanceTime(uint256 _epochAdvanceTime) public onlyVotingSystem {
1249         epochAdvanceTime = _epochAdvanceTime;
1250     }
1251     function setMinRequiredSnapshotId(uint256 _minRequiredSnapshotId) public onlyVotingSystem {
1252         minRequiredSnapshotId = _minRequiredSnapshotId;
1253     }
1254 
1255     // Moves the contract one epoch forward.
1256     // Enables the previous epoch to be paid out.
1257     // Enables the new current epoch to track rewards.
1258     function advanceEpoch() public {
1259         if (epochCount > maxEpoch) {
1260             revert("past max epochs");
1261         }
1262 
1263         if (now.sub(lastUpdateTimestamp) < epochAdvanceTime) {
1264             revert("wait for a epoch to pass");
1265         }
1266 
1267         lastUpdateTimestamp = lastUpdateTimestamp + epochAdvanceTime;
1268 
1269         uint16 oldEpoch = epochCount;
1270         bool hasNewEpoch = epochCount < maxEpoch;
1271         epochCount++;
1272 
1273         for (uint256 i = 0; i < allExchangeAddresses.length; i++) {
1274             ExchangeData storage data = exchangeDataByExchangeAddress[allExchangeAddresses[i]];
1275             Epoch storage oldEpochData = data.epochEntries[oldEpoch];
1276             if (oldEpochData.isActiveEpoch) {
1277                 oldEpochData.isActiveEpoch = false;
1278             }
1279 
1280             if (hasNewEpoch) {
1281                 Epoch storage epoch = data.epochEntries[epochCount];
1282                 epoch.liquidityPayoutMultiplier = data.defaultLiquidityPayoutMultiplier;
1283                 epoch.traderPayoutMultiplier = data.defaultTraderPayoutMultiplier;
1284                 epoch.referralPayoutMultiplier = data.defaultReferralPayoutMultiplier;
1285                 epoch.exchangeWeight = data.defaultExchangeWeight;
1286                 epoch.sumOfExchangeWeights = currentSumOfExchangeWeights;
1287                 epoch.isActiveEpoch = true;
1288                 epoch.snapShotId = data.liquidityToken.snapshot();
1289                 epoch.isRemoved = data.isRemoved;
1290             }
1291         }
1292     }
1293 
1294     // Changes the payout distribution for a given exchange
1295     function updatePayoutDistribution(
1296         address _exchangeAddress,
1297         uint256 _liquidityPayoutMultiplier,
1298         uint256 _traderPayoutMultiplier,
1299         uint256 _referralPayoutMultiplier,
1300         uint256 defaultExchangeWeight
1301     ) public onlyExchangeFactoryOrVotingSystem {
1302         require(
1303             _liquidityPayoutMultiplier.add(_traderPayoutMultiplier).add(_referralPayoutMultiplier) == 1 ether,
1304             "!= 1"
1305         );
1306 
1307         requireExchangeExists(_exchangeAddress);
1308 
1309         ExchangeData storage data = exchangeDataByExchangeAddress[_exchangeAddress];
1310 
1311         currentSumOfExchangeWeights = currentSumOfExchangeWeights.add(defaultExchangeWeight).sub(
1312             data.defaultExchangeWeight
1313         );
1314 
1315         data.defaultLiquidityPayoutMultiplier = _liquidityPayoutMultiplier;
1316         data.defaultTraderPayoutMultiplier = _traderPayoutMultiplier;
1317         data.defaultReferralPayoutMultiplier = _referralPayoutMultiplier;
1318         data.defaultExchangeWeight = defaultExchangeWeight;
1319 
1320         // Updating the current epoch
1321         Epoch storage epoch = data.epochEntries[epochCount];
1322         if (epoch.isActiveEpoch) {
1323             epoch.liquidityPayoutMultiplier = _liquidityPayoutMultiplier;
1324             epoch.traderPayoutMultiplier = _traderPayoutMultiplier;
1325             epoch.referralPayoutMultiplier = _referralPayoutMultiplier;
1326             epoch.exchangeWeight = defaultExchangeWeight;
1327         }
1328 
1329         for (uint256 i = 0; i < allExchangeAddresses.length; i++) {
1330             ExchangeData storage exchangeData = exchangeDataByExchangeAddress[allExchangeAddresses[i]];
1331             Epoch storage exchangeEpoch = exchangeData.epochEntries[epochCount];
1332             if (epoch.isActiveEpoch) {
1333                 exchangeEpoch.sumOfExchangeWeights = currentSumOfExchangeWeights;
1334             }
1335         }
1336     }
1337 
1338     // Adds an exchange creating its associated data structures
1339     function addExchange(address _exchange, address _liquidityToken) public onlyExchangeFactoryOrVotingSystem {
1340         require(exchangeDataByExchangeAddress[_exchange].exchangeAddress == address(0), "exchange should not exists");
1341 
1342         allExchangeAddresses.push(_exchange);
1343         ExchangeData storage data = exchangeDataByExchangeAddress[_exchange];
1344         data.exchangeAddress = _exchange;
1345         data.liquidityToken = ERC20Snapshot(_liquidityToken);
1346 
1347         // init epoch
1348         Epoch storage epoch = data.epochEntries[epochCount];
1349         epoch.isActiveEpoch = true;
1350         epoch.snapShotId = data.liquidityToken.snapshot();
1351     }
1352 
1353     // Removes an exchange
1354     // Instead of actually deleting its mapping it will be marked as removed
1355     function removeExchange(address _exchange) public onlyExchangeFactoryOrVotingSystem {
1356         if (address(exchangeDataByExchangeAddress[_exchange].exchangeAddress) == address(0)) {
1357             return;
1358         }
1359 
1360         ExchangeData storage data = exchangeDataByExchangeAddress[_exchange];
1361         currentSumOfExchangeWeights = currentSumOfExchangeWeights < data.defaultExchangeWeight
1362             ? 0
1363             : currentSumOfExchangeWeights.sub(data.defaultExchangeWeight);
1364 
1365         data.isRemoved = true;
1366     }
1367 
1368     // Serves as a safety switch to disable minting for FST in case there is a problem with incentives
1369     function renounceMinter() public onlyVotingSystem {
1370         fsToken.renounceMinter();
1371     }
1372 
1373     // See IIncentives#rewardTrader
1374     function rewardTrader(address _trader, address _referral, uint256 _amount) public onlyExchange {
1375         Epoch storage epoch = getActiveEpoch(msg.sender);
1376 
1377         epoch.traderPayout[_trader] = epoch.traderPayout[_trader].add(_amount);
1378         epoch.totalTraderPayout = epoch.totalTraderPayout.add(_amount);
1379 
1380         if (_referral != address(0)) {
1381             epoch.referralPayout[_referral] = epoch.referralPayout[_referral].add(_amount);
1382             epoch.totalReferralPayout = epoch.totalReferralPayout.add(_amount);
1383         }
1384     }
1385 
1386     // See IIncentives#trackLiquidityRemoved
1387     function trackLiquidityRemoved(address _liquidityProvider, uint256 _amount) public onlyExchange {
1388         Epoch storage epoch = getActiveEpoch(msg.sender);
1389         ExchangeData storage data = exchangeDataByExchangeAddress[msg.sender];
1390 
1391         uint256 maxWithdraw = data.liquidityToken.balanceOfAt(_liquidityProvider, epoch.snapShotId);
1392 
1393         uint256 currentWithdrawn = epoch.withdrawnLiquidityByAddress[_liquidityProvider];
1394         uint256 userTotalWithdrawn = currentWithdrawn.add(_amount);
1395         epoch.withdrawnLiquidityByAddress[_liquidityProvider] = userTotalWithdrawn;
1396         uint256 toAdd = userTotalWithdrawn <= maxWithdraw ? _amount : currentWithdrawn >= maxWithdraw
1397             ? 0
1398             : maxWithdraw.sub(currentWithdrawn);
1399         epoch.totalLiquidityRemoved = epoch.totalLiquidityRemoved.add(toAdd);
1400     }
1401 
1402     function getActiveEpoch(address exchange) private view returns (Epoch storage) {
1403         require(epochCount < maxEpoch, "max epoch reached");
1404 
1405         ExchangeData storage data = exchangeDataByExchangeAddress[exchange];
1406         require(!data.isRemoved, "Exchange is removed");
1407 
1408         Epoch storage epochEntry = data.epochEntries[epochCount];
1409         require(epochEntry.isActiveEpoch, "Epoch should be active");
1410         return epochEntry;
1411     }
1412 
1413     // Payout a trader for a given set of epochs
1414     function payoutTrader(address _target, uint16[] memory _epochs) public {
1415         uint256 totalPayout = 0;
1416         for (uint256 i = 0; i < allExchangeAddresses.length; i++) {
1417             for (uint256 j = 0; j < _epochs.length; j++) {
1418                 Epoch storage epochEntry = getEpochOrDie(allExchangeAddresses[i], _epochs[j]);
1419                 totalPayout = totalPayout.add(calculateTraderPayout(epochEntry, _target));
1420                 // Zero out payment to mark it as withdrawn
1421                 epochEntry.traderPayout[_target] = 0;
1422             }
1423         }
1424         fsToken.mint(_target, totalPayout);
1425         emit TraderPayout(_target, totalPayout);
1426     }
1427 
1428     // Get the payout for a trader for a given set of epochs
1429     function getTraderPayout(address _target, uint16[] memory _epochs) public view returns (uint256) {
1430         uint256 totalPayout = 0;
1431         for (uint256 i = 0; i < allExchangeAddresses.length; i++) {
1432             for (uint256 j = 0; j < _epochs.length; j++) {
1433                 Epoch storage epochEntry = getEpochOrDie(allExchangeAddresses[i], _epochs[j]);
1434                 totalPayout = totalPayout.add(calculateTraderPayout(epochEntry, _target));
1435             }
1436         }
1437         return totalPayout;
1438     }
1439 
1440     function calculateTraderPayout(Epoch storage epochEntry, address trader) private view returns (uint256) {
1441         if (epochEntry.totalTraderPayout == 0 || epochEntry.sumOfExchangeWeights == 0) {
1442             return 0;
1443         }
1444 
1445         uint256 traderValue = epochEntry.traderPayout[trader];
1446 
1447         uint256 payoutAmount = totalTokensToMintPerEpoch
1448             .mul(traderValue)
1449             .div(epochEntry.totalTraderPayout)
1450             .mul(epochEntry.traderPayoutMultiplier)
1451             .div(1 ether)
1452             .mul(epochEntry.exchangeWeight)
1453             .div(epochEntry.sumOfExchangeWeights);
1454 
1455         return payoutAmount;
1456     }
1457 
1458     // Payout referrals for a given set of epochs
1459     function payoutReferral(address _target, uint16[] memory _epochs) public {
1460         uint256 totalPayout = 0;
1461         for (uint256 i = 0; i < allExchangeAddresses.length; i++) {
1462             for (uint256 j = 0; j < _epochs.length; j++) {
1463                 Epoch storage epochEntry = getEpochOrDie(allExchangeAddresses[i], _epochs[j]);
1464                 totalPayout = totalPayout.add(calculateReferralPayout(epochEntry, _target));
1465                 // Zero out payment to mark it as withdrawn
1466                 epochEntry.referralPayout[_target] = 0;
1467             }
1468         }
1469         fsToken.mint(_target, totalPayout);
1470         emit ReferralPayout(_target, totalPayout);
1471     }
1472 
1473     // Get payout referrals for a given set of epochs
1474     function getReferralPayout(address _target, uint16[] memory _epochs) public view returns (uint256) {
1475         uint256 totalPayout = 0;
1476         for (uint256 i = 0; i < allExchangeAddresses.length; i++) {
1477             for (uint256 j = 0; j < _epochs.length; j++) {
1478                 Epoch storage epochEntry = getEpochOrDie(allExchangeAddresses[i], _epochs[j]);
1479                 totalPayout = totalPayout.add(calculateReferralPayout(epochEntry, _target));
1480             }
1481         }
1482         return totalPayout;
1483     }
1484 
1485     function calculateReferralPayout(Epoch storage epochEntry, address referral) private view returns (uint256) {
1486         if (epochEntry.totalReferralPayout == 0 || epochEntry.sumOfExchangeWeights == 0) {
1487             return 0;
1488         }
1489 
1490         uint256 referralValue = epochEntry.referralPayout[referral];
1491 
1492         uint256 payoutAmount = totalTokensToMintPerEpoch
1493             .mul(referralValue)
1494             .div(epochEntry.totalReferralPayout)
1495             .mul(epochEntry.referralPayoutMultiplier)
1496             .div(1 ether)
1497             .mul(epochEntry.exchangeWeight)
1498             .div(epochEntry.sumOfExchangeWeights);
1499 
1500         return payoutAmount;
1501     }
1502 
1503     // Payout liquidity providers for a given set of epochs
1504     function payoutLiquidityProvider(address _target, uint16[] memory _epochs) public {
1505         uint256 totalPayout = 0;
1506 
1507         for (uint256 i = 0; i < allExchangeAddresses.length; i++) {
1508             for (uint256 j = 0; j < _epochs.length; j++) {
1509                 Epoch storage epochEntry = getEpochOrDie(allExchangeAddresses[i], _epochs[j]);
1510                 totalPayout = totalPayout.add(
1511                     calculateLiquidityProviderPayout(_target, allExchangeAddresses[i], epochEntry)
1512                 );
1513                 // Ensure liquidity rewards can not be withdrawn twice for a epoch
1514                 require(!epochEntry.paidOutLiquidityByAddress[_target], "Already paid out");
1515                 epochEntry.paidOutLiquidityByAddress[_target] = true;
1516             }
1517         }
1518         fsToken.mint(_target, totalPayout);
1519         emit LiquidityProviderPayout(_target, totalPayout);
1520     }
1521 
1522     // Get Payout for liquidity providers for a given set of epochs
1523     function getLiquidityProviderPayout(address _target, uint16[] memory _epochs) public view returns (uint256) {
1524         uint256 totalPayout = 0;
1525         for (uint256 i = 0; i < allExchangeAddresses.length; i++) {
1526             for (uint256 j = 0; j < _epochs.length; j++) {
1527                 Epoch storage epochEntry = getEpochOrDie(allExchangeAddresses[i], _epochs[j]);
1528                 totalPayout = totalPayout.add(
1529                     calculateLiquidityProviderPayout(_target, allExchangeAddresses[i], epochEntry)
1530                 );
1531             }
1532         }
1533         return totalPayout;
1534     }
1535 
1536     function calculateLiquidityProviderPayout(
1537         address liquidityProvider,
1538         address exchangeAddress,
1539         Epoch storage epochEntry
1540     ) private view returns (uint256) {
1541         if (epochEntry.isRemoved) {
1542             return 0;
1543         }
1544 
1545         if (epochEntry.snapShotId < minRequiredSnapshotId) {
1546             return 0;
1547         }
1548 
1549         ExchangeData storage data = exchangeDataByExchangeAddress[exchangeAddress];
1550 
1551         uint256 totalLiquidity = data.liquidityToken.totalSupplyAt(epochEntry.snapShotId);
1552         if (totalLiquidity == 0 || epochEntry.sumOfExchangeWeights == 0) {
1553             return 0;
1554         }
1555 
1556         uint256 adjustedLiquidity = totalLiquidity.sub(epochEntry.totalLiquidityRemoved);
1557         if (adjustedLiquidity == 0) {
1558             return 0;
1559         }
1560 
1561         uint256 withdrawnLiquidity = epochEntry.withdrawnLiquidityByAddress[liquidityProvider];
1562         uint256 providedLiquidity = data.liquidityToken.balanceOfAt(liquidityProvider, epochEntry.snapShotId);
1563         uint256 liquidityProvidedInEpoch = providedLiquidity > withdrawnLiquidity
1564             ? providedLiquidity.sub(withdrawnLiquidity)
1565             : 0;
1566 
1567         uint256 payoutAmount = totalTokensToMintPerEpoch
1568             .mul(liquidityProvidedInEpoch)
1569             .div(adjustedLiquidity)
1570             .mul(epochEntry.liquidityPayoutMultiplier)
1571             .div(1 ether)
1572             .mul(epochEntry.exchangeWeight)
1573             .div(epochEntry.sumOfExchangeWeights);
1574 
1575         return payoutAmount;
1576     }
1577 
1578     function getEpochOrDie(address exchangeAddress, uint16 epoch) private view returns (Epoch storage) {
1579         requireExchangeExists(exchangeAddress);
1580         ExchangeData storage data = exchangeDataByExchangeAddress[exchangeAddress];
1581         Epoch storage epochEntry = data.epochEntries[epoch];
1582 
1583         require(!epochEntry.isActiveEpoch, "epoch can not be withdrawn yet");
1584         return epochEntry;
1585     }
1586 
1587     function requireExchangeExists(address exchangeAddress) private view {
1588         require(
1589             address(exchangeDataByExchangeAddress[exchangeAddress].exchangeAddress) != address(0),
1590             "Exchange does not exist"
1591         );
1592     }
1593 
1594     function onRegistryRefresh() public onlyRegistry {
1595         fsToken = ERC20Mintable(checkNotNull(getRegistry().getFsTokenAddress()));
1596     }
1597 
1598     function getAllExchangeAddresses() public view returns (address[] memory) {
1599         return allExchangeAddresses;
1600     }
1601 
1602     function getExchangeDataByAddress(address exchangeAddress)
1603         public
1604         view
1605         returns (address, uint256, uint256, uint256, uint256, bool)
1606     {
1607         ExchangeData storage ex = exchangeDataByExchangeAddress[exchangeAddress];
1608 
1609         return (
1610             address(ex.liquidityToken),
1611             ex.defaultLiquidityPayoutMultiplier,
1612             ex.defaultTraderPayoutMultiplier,
1613             ex.defaultReferralPayoutMultiplier,
1614             ex.defaultExchangeWeight,
1615             ex.isRemoved
1616         );
1617     }
1618 
1619     function getExchangeEpoch(address exchangeAddress, uint16 epochNumber)
1620         public
1621         view
1622         returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, bool, bool)
1623     {
1624         ExchangeData storage ex = exchangeDataByExchangeAddress[exchangeAddress];
1625         Epoch storage epoch = ex.epochEntries[epochNumber];
1626 
1627         return (
1628             epoch.snapShotId,
1629             epoch.liquidityPayoutMultiplier,
1630             epoch.traderPayoutMultiplier,
1631             epoch.referralPayoutMultiplier,
1632             epoch.exchangeWeight,
1633             epoch.sumOfExchangeWeights,
1634             epoch.totalTraderPayout,
1635             epoch.totalReferralPayout,
1636             epoch.isActiveEpoch,
1637             epoch.isRemoved
1638         );
1639     }
1640 
1641     function getExchangeEpochByUser(address exchangeAddress, uint16 epochNumber, address userAddress)
1642         public
1643         view
1644         returns (uint256, uint256, uint256, bool, uint256)
1645     {
1646         ExchangeData storage ex = exchangeDataByExchangeAddress[exchangeAddress];
1647         Epoch storage epoch = ex.epochEntries[epochNumber];
1648 
1649         return (
1650             epoch.traderPayout[userAddress],
1651             epoch.referralPayout[userAddress],
1652             epoch.withdrawnLiquidityByAddress[userAddress],
1653             epoch.paidOutLiquidityByAddress[userAddress],
1654             calculateLiquidityProviderPayout(userAddress, exchangeAddress, epoch)
1655         );
1656     }
1657 }