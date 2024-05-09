1 pragma solidity ^0.5.0;
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
131      * _Available since v2.4.0._
132      */
133     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
134         require(b <= a, errorMessage);
135         uint256 c = a - b;
136 
137         return c;
138     }
139 
140     /**
141      * @dev Returns the multiplication of two unsigned integers, reverting on
142      * overflow.
143      *
144      * Counterpart to Solidity's `*` operator.
145      *
146      * Requirements:
147      * - Multiplication cannot overflow.
148      */
149     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
150         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
151         // benefit is lost if 'b' is also tested.
152         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
153         if (a == 0) {
154             return 0;
155         }
156 
157         uint256 c = a * b;
158         require(c / a == b, "SafeMath: multiplication overflow");
159 
160         return c;
161     }
162 
163     /**
164      * @dev Returns the integer division of two unsigned integers. Reverts on
165      * division by zero. The result is rounded towards zero.
166      *
167      * Counterpart to Solidity's `/` operator. Note: this function uses a
168      * `revert` opcode (which leaves remaining gas untouched) while Solidity
169      * uses an invalid opcode to revert (consuming all remaining gas).
170      *
171      * Requirements:
172      * - The divisor cannot be zero.
173      */
174     function div(uint256 a, uint256 b) internal pure returns (uint256) {
175         return div(a, b, "SafeMath: division by zero");
176     }
177 
178     /**
179      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
180      * division by zero. The result is rounded towards zero.
181      *
182      * Counterpart to Solidity's `/` operator. Note: this function uses a
183      * `revert` opcode (which leaves remaining gas untouched) while Solidity
184      * uses an invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      * - The divisor cannot be zero.
188      *
189      * _Available since v2.4.0._
190      */
191     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
192         // Solidity only automatically asserts when dividing by 0
193         require(b > 0, errorMessage);
194         uint256 c = a / b;
195         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
196 
197         return c;
198     }
199 
200     /**
201      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
202      * Reverts when dividing by zero.
203      *
204      * Counterpart to Solidity's `%` operator. This function uses a `revert`
205      * opcode (which leaves remaining gas untouched) while Solidity uses an
206      * invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      * - The divisor cannot be zero.
210      */
211     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
212         return mod(a, b, "SafeMath: modulo by zero");
213     }
214 
215     /**
216      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
217      * Reverts with custom message when dividing by zero.
218      *
219      * Counterpart to Solidity's `%` operator. This function uses a `revert`
220      * opcode (which leaves remaining gas untouched) while Solidity uses an
221      * invalid opcode to revert (consuming all remaining gas).
222      *
223      * Requirements:
224      * - The divisor cannot be zero.
225      *
226      * _Available since v2.4.0._
227      */
228     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
229         require(b != 0, errorMessage);
230         return a % b;
231     }
232 }
233 
234 
235 /**
236  * @dev Standard math utilities missing in the Solidity language.
237  */
238 library Math {
239     /**
240      * @dev Returns the largest of two numbers.
241      */
242     function max(uint256 a, uint256 b) internal pure returns (uint256) {
243         return a >= b ? a : b;
244     }
245 
246     /**
247      * @dev Returns the smallest of two numbers.
248      */
249     function min(uint256 a, uint256 b) internal pure returns (uint256) {
250         return a < b ? a : b;
251     }
252 
253     /**
254      * @dev Returns the average of two numbers. The result is rounded towards
255      * zero.
256      */
257     function average(uint256 a, uint256 b) internal pure returns (uint256) {
258         // (a + b) / 2 can overflow, so we distribute
259         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
260     }
261 }
262 
263 
264 /**
265  * @dev Collection of functions related to array types.
266  */
267 library Arrays {
268    /**
269      * @dev Searches a sorted `array` and returns the first index that contains
270      * a value greater or equal to `element`. If no such index exists (i.e. all
271      * values in the array are strictly less than `element`), the array length is
272      * returned. Time complexity O(log n).
273      *
274      * `array` is expected to be sorted in ascending order, and to contain no
275      * repeated elements.
276      */
277     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
278         if (array.length == 0) {
279             return 0;
280         }
281 
282         uint256 low = 0;
283         uint256 high = array.length;
284 
285         while (low < high) {
286             uint256 mid = Math.average(low, high);
287 
288             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
289             // because Math.average rounds down (it does integer division with truncation).
290             if (array[mid] > element) {
291                 high = mid;
292             } else {
293                 low = mid + 1;
294             }
295         }
296 
297         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
298         if (low > 0 && array[low - 1] == element) {
299             return low - 1;
300         } else {
301             return low;
302         }
303     }
304 }
305 
306 
307 /**
308  * @title Counters
309  * @author Matt Condon (@shrugs)
310  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
311  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
312  *
313  * Include with `using Counters for Counters.Counter;`
314  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
315  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
316  * directly accessed.
317  */
318 library Counters {
319     using SafeMath for uint256;
320 
321     struct Counter {
322         // This variable should never be directly accessed by users of the library: interactions must be restricted to
323         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
324         // this feature: see https://github.com/ethereum/solidity/issues/4637
325         uint256 _value; // default: 0
326     }
327 
328     function current(Counter storage counter) internal view returns (uint256) {
329         return counter._value;
330     }
331 
332     function increment(Counter storage counter) internal {
333         counter._value += 1;
334     }
335 
336     function decrement(Counter storage counter) internal {
337         counter._value = counter._value.sub(1);
338     }
339 }
340 
341 
342 /*
343  * @dev Provides information about the current execution context, including the
344  * sender of the transaction and its data. While these are generally available
345  * via msg.sender and msg.data, they should not be accessed in such a direct
346  * manner, since when dealing with GSN meta-transactions the account sending and
347  * paying for execution may not be the actual sender (as far as an application
348  * is concerned).
349  *
350  * This contract is only required for intermediate, library-like contracts.
351  */
352 contract Context {
353     // Empty internal constructor, to prevent people from mistakenly deploying
354     // an instance of this contract, which should be used via inheritance.
355     constructor () internal { }
356     // solhint-disable-previous-line no-empty-blocks
357 
358     function _msgSender() internal view returns (address payable) {
359         return msg.sender;
360     }
361 
362     function _msgData() internal view returns (bytes memory) {
363         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
364         return msg.data;
365     }
366 }
367 
368 
369 /**
370  * @dev Implementation of the {IERC20} interface.
371  *
372  * This implementation is agnostic to the way tokens are created. This means
373  * that a supply mechanism has to be added in a derived contract using {_mint}.
374  * For a generic mechanism see {ERC20Mintable}.
375  *
376  * TIP: For a detailed writeup see our guide
377  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
378  * to implement supply mechanisms].
379  *
380  * We have followed general OpenZeppelin guidelines: functions revert instead
381  * of returning `false` on failure. This behavior is nonetheless conventional
382  * and does not conflict with the expectations of ERC20 applications.
383  *
384  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
385  * This allows applications to reconstruct the allowance for all accounts just
386  * by listening to said events. Other implementations of the EIP may not emit
387  * these events, as it isn't required by the specification.
388  *
389  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
390  * functions have been added to mitigate the well-known issues around setting
391  * allowances. See {IERC20-approve}.
392  */
393 contract ERC20 is Context, IERC20 {
394     using SafeMath for uint256;
395 
396     mapping (address => uint256) private _balances;
397 
398     mapping (address => mapping (address => uint256)) private _allowances;
399 
400     uint256 private _totalSupply;
401 
402     /**
403      * @dev See {IERC20-totalSupply}.
404      */
405     function totalSupply() public view returns (uint256) {
406         return _totalSupply;
407     }
408 
409     /**
410      * @dev See {IERC20-balanceOf}.
411      */
412     function balanceOf(address account) public view returns (uint256) {
413         return _balances[account];
414     }
415 
416     /**
417      * @dev See {IERC20-transfer}.
418      *
419      * Requirements:
420      *
421      * - `recipient` cannot be the zero address.
422      * - the caller must have a balance of at least `amount`.
423      */
424     function transfer(address recipient, uint256 amount) public returns (bool) {
425         _transfer(_msgSender(), recipient, amount);
426         return true;
427     }
428 
429     /**
430      * @dev See {IERC20-allowance}.
431      */
432     function allowance(address owner, address spender) public view returns (uint256) {
433         return _allowances[owner][spender];
434     }
435 
436     /**
437      * @dev See {IERC20-approve}.
438      *
439      * Requirements:
440      *
441      * - `spender` cannot be the zero address.
442      */
443     function approve(address spender, uint256 amount) public returns (bool) {
444         _approve(_msgSender(), spender, amount);
445         return true;
446     }
447 
448     /**
449      * @dev See {IERC20-transferFrom}.
450      *
451      * Emits an {Approval} event indicating the updated allowance. This is not
452      * required by the EIP. See the note at the beginning of {ERC20};
453      *
454      * Requirements:
455      * - `sender` and `recipient` cannot be the zero address.
456      * - `sender` must have a balance of at least `amount`.
457      * - the caller must have allowance for `sender`'s tokens of at least
458      * `amount`.
459      */
460     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
461         _transfer(sender, recipient, amount);
462         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
463         return true;
464     }
465 
466     /**
467      * @dev Atomically increases the allowance granted to `spender` by the caller.
468      *
469      * This is an alternative to {approve} that can be used as a mitigation for
470      * problems described in {IERC20-approve}.
471      *
472      * Emits an {Approval} event indicating the updated allowance.
473      *
474      * Requirements:
475      *
476      * - `spender` cannot be the zero address.
477      */
478     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
479         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
480         return true;
481     }
482 
483     /**
484      * @dev Atomically decreases the allowance granted to `spender` by the caller.
485      *
486      * This is an alternative to {approve} that can be used as a mitigation for
487      * problems described in {IERC20-approve}.
488      *
489      * Emits an {Approval} event indicating the updated allowance.
490      *
491      * Requirements:
492      *
493      * - `spender` cannot be the zero address.
494      * - `spender` must have allowance for the caller of at least
495      * `subtractedValue`.
496      */
497     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
498         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
499         return true;
500     }
501 
502     /**
503      * @dev Moves tokens `amount` from `sender` to `recipient`.
504      *
505      * This is internal function is equivalent to {transfer}, and can be used to
506      * e.g. implement automatic token fees, slashing mechanisms, etc.
507      *
508      * Emits a {Transfer} event.
509      *
510      * Requirements:
511      *
512      * - `sender` cannot be the zero address.
513      * - `recipient` cannot be the zero address.
514      * - `sender` must have a balance of at least `amount`.
515      */
516     function _transfer(address sender, address recipient, uint256 amount) internal {
517         require(sender != address(0), "ERC20: transfer from the zero address");
518         require(recipient != address(0), "ERC20: transfer to the zero address");
519 
520         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
521         _balances[recipient] = _balances[recipient].add(amount);
522         emit Transfer(sender, recipient, amount);
523     }
524 
525     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
526      * the total supply.
527      *
528      * Emits a {Transfer} event with `from` set to the zero address.
529      *
530      * Requirements
531      *
532      * - `to` cannot be the zero address.
533      */
534     function _mint(address account, uint256 amount) internal {
535         require(account != address(0), "ERC20: mint to the zero address");
536 
537         _totalSupply = _totalSupply.add(amount);
538         _balances[account] = _balances[account].add(amount);
539         emit Transfer(address(0), account, amount);
540     }
541 
542      /**
543      * @dev Destroys `amount` tokens from `account`, reducing the
544      * total supply.
545      *
546      * Emits a {Transfer} event with `to` set to the zero address.
547      *
548      * Requirements
549      *
550      * - `account` cannot be the zero address.
551      * - `account` must have at least `amount` tokens.
552      */
553     function _burn(address account, uint256 amount) internal {
554         require(account != address(0), "ERC20: burn from the zero address");
555 
556         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
557         _totalSupply = _totalSupply.sub(amount);
558         emit Transfer(account, address(0), amount);
559     }
560 
561     /**
562      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
563      *
564      * This is internal function is equivalent to `approve`, and can be used to
565      * e.g. set automatic allowances for certain subsystems, etc.
566      *
567      * Emits an {Approval} event.
568      *
569      * Requirements:
570      *
571      * - `owner` cannot be the zero address.
572      * - `spender` cannot be the zero address.
573      */
574     function _approve(address owner, address spender, uint256 amount) internal {
575         require(owner != address(0), "ERC20: approve from the zero address");
576         require(spender != address(0), "ERC20: approve to the zero address");
577 
578         _allowances[owner][spender] = amount;
579         emit Approval(owner, spender, amount);
580     }
581 
582     /**
583      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
584      * from the caller's allowance.
585      *
586      * See {_burn} and {_approve}.
587      */
588     function _burnFrom(address account, uint256 amount) internal {
589         _burn(account, amount);
590         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
591     }
592 }
593 
594 
595 /**
596  * @title ERC20 token with snapshots.
597  * @dev Inspired by Jordi Baylina's
598  * https://github.com/Giveth/minimd/blob/ea04d950eea153a04c51fa510b068b9dded390cb/contracts/MiniMeToken.sol[MiniMeToken]
599  * to record historical balances.
600  *
601  * When a snapshot is made, the balances and total supply at the time of the snapshot are recorded for later
602  * access.
603  *
604  * To make a snapshot, call the {snapshot} function, which will emit the {Snapshot} event and return a snapshot id.
605  * To get the total supply from a snapshot, call the function {totalSupplyAt} with the snapshot id.
606  * To get the balance of an account from a snapshot, call the {balanceOfAt} function with the snapshot id and the
607  * account address.
608  * @author Validity Labs AG <info@validitylabs.org>
609  */
610 contract ERC20Snapshot is ERC20 {
611     using SafeMath for uint256;
612     using Arrays for uint256[];
613     using Counters for Counters.Counter;
614 
615     // Snapshotted values have arrays of ids and the value corresponding to that id. These could be an array of a
616     // Snapshot struct, but that would impede usage of functions that work on an array.
617     struct Snapshots {
618         uint256[] ids;
619         uint256[] values;
620     }
621 
622     mapping (address => Snapshots) private _accountBalanceSnapshots;
623     Snapshots private _totalSupplySnapshots;
624 
625     // Snapshot ids increase monotonically, with the first value being 1. An id of 0 is invalid.
626     Counters.Counter private _currentSnapshotId;
627 
628     event Snapshot(uint256 id);
629 
630     // Creates a new snapshot id. Balances are only stored in snapshots on demand: unless a snapshot was taken, a
631     // balance change will not be recorded. This means the extra added cost of storing snapshotted balances is only paid
632     // when required, but is also flexible enough that it allows for e.g. daily snapshots.
633     function snapshot() public returns (uint256) {
634         _currentSnapshotId.increment();
635 
636         uint256 currentId = _currentSnapshotId.current();
637         emit Snapshot(currentId);
638         return currentId;
639     }
640 
641     function balanceOfAt(address account, uint256 snapshotId) public view returns (uint256) {
642         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _accountBalanceSnapshots[account]);
643 
644         return snapshotted ? value : balanceOf(account);
645     }
646 
647     function totalSupplyAt(uint256 snapshotId) public view returns(uint256) {
648         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _totalSupplySnapshots);
649 
650         return snapshotted ? value : totalSupply();
651     }
652 
653     // _transfer, _mint and _burn are the only functions where the balances are modified, so it is there that the
654     // snapshots are updated. Note that the update happens _before_ the balance change, with the pre-modified value.
655     // The same is true for the total supply and _mint and _burn.
656     function _transfer(address from, address to, uint256 value) internal {
657         _updateAccountSnapshot(from);
658         _updateAccountSnapshot(to);
659 
660         super._transfer(from, to, value);
661     }
662 
663     function _mint(address account, uint256 value) internal {
664         _updateAccountSnapshot(account);
665         _updateTotalSupplySnapshot();
666 
667         super._mint(account, value);
668     }
669 
670     function _burn(address account, uint256 value) internal {
671         _updateAccountSnapshot(account);
672         _updateTotalSupplySnapshot();
673 
674         super._burn(account, value);
675     }
676 
677     // When a valid snapshot is queried, there are three possibilities:
678     //  a) The queried value was not modified after the snapshot was taken. Therefore, a snapshot entry was never
679     //  created for this id, and all stored snapshot ids are smaller than the requested one. The value that corresponds
680     //  to this id is the current one.
681     //  b) The queried value was modified after the snapshot was taken. Therefore, there will be an entry with the
682     //  requested id, and its value is the one to return.
683     //  c) More snapshots were created after the requested one, and the queried value was later modified. There will be
684     //  no entry for the requested id: the value that corresponds to it is that of the smallest snapshot id that is
685     //  larger than the requested one.
686     //
687     // In summary, we need to find an element in an array, returning the index of the smallest value that is larger if
688     // it is not found, unless said value doesn't exist (e.g. when all values are smaller). Arrays.findUpperBound does
689     // exactly this.
690     function _valueAt(uint256 snapshotId, Snapshots storage snapshots)
691         private view returns (bool, uint256)
692     {
693         require(snapshotId > 0, "ERC20Snapshot: id is 0");
694         // solhint-disable-next-line max-line-length
695         require(snapshotId <= _currentSnapshotId.current(), "ERC20Snapshot: nonexistent id");
696 
697         uint256 index = snapshots.ids.findUpperBound(snapshotId);
698 
699         if (index == snapshots.ids.length) {
700             return (false, 0);
701         } else {
702             return (true, snapshots.values[index]);
703         }
704     }
705 
706     function _updateAccountSnapshot(address account) private {
707         _updateSnapshot(_accountBalanceSnapshots[account], balanceOf(account));
708     }
709 
710     function _updateTotalSupplySnapshot() private {
711         _updateSnapshot(_totalSupplySnapshots, totalSupply());
712     }
713 
714     function _updateSnapshot(Snapshots storage snapshots, uint256 currentValue) private {
715         uint256 currentId = _currentSnapshotId.current();
716         if (_lastSnapshotId(snapshots.ids) < currentId) {
717             snapshots.ids.push(currentId);
718             snapshots.values.push(currentValue);
719         }
720     }
721 
722     function _lastSnapshotId(uint256[] storage ids) private view returns (uint256) {
723         if (ids.length == 0) {
724             return 0;
725         } else {
726             return ids[ids.length - 1];
727         }
728     }
729 }
730 
731 /**
732  * @title ERC20 interface that includes burn and mint methods.
733  */
734 contract ExpandedIERC20 is IERC20 {
735     /**
736      * @notice Burns a specific amount of the caller's tokens.
737      * @dev Only burns the caller's tokens, so it is safe to leave this method permissionless.
738      */
739     function burn(uint value) external;
740 
741     /**
742      * @notice Mints tokens and adds them to the balance of the `to` address.
743      * @dev This method should be permissioned to only allow designated parties to mint tokens.
744      */
745     function mint(address to, uint value) external returns (bool);
746 }
747 
748 
749 library Exclusive {
750     struct RoleMembership {
751         address member;
752     }
753 
754     function isMember(RoleMembership storage roleMembership, address memberToCheck) internal view returns (bool) {
755         return roleMembership.member == memberToCheck;
756     }
757 
758     function resetMember(RoleMembership storage roleMembership, address newMember) internal {
759         require(newMember != address(0x0), "Cannot set an exclusive role to 0x0");
760         roleMembership.member = newMember;
761     }
762 
763     function getMember(RoleMembership storage roleMembership) internal view returns (address) {
764         return roleMembership.member;
765     }
766 
767     function init(RoleMembership storage roleMembership, address initialMember) internal {
768         resetMember(roleMembership, initialMember);
769     }
770 }
771 
772 
773 library Shared {
774     struct RoleMembership {
775         mapping(address => bool) members;
776     }
777 
778     function isMember(RoleMembership storage roleMembership, address memberToCheck) internal view returns (bool) {
779         return roleMembership.members[memberToCheck];
780     }
781 
782     function addMember(RoleMembership storage roleMembership, address memberToAdd) internal {
783         roleMembership.members[memberToAdd] = true;
784     }
785 
786     function removeMember(RoleMembership storage roleMembership, address memberToRemove) internal {
787         roleMembership.members[memberToRemove] = false;
788     }
789 
790     function init(RoleMembership storage roleMembership, address[] memory initialMembers) internal {
791         for (uint i = 0; i < initialMembers.length; i++) {
792             addMember(roleMembership, initialMembers[i]);
793         }
794     }
795 }
796 
797 
798 /**
799  * @title Base class to manage permissions for the derived class.
800  */
801 contract MultiRole {
802     using Exclusive for Exclusive.RoleMembership;
803     using Shared for Shared.RoleMembership;
804 
805     enum RoleType { Invalid, Exclusive, Shared }
806 
807     struct Role {
808         uint managingRole;
809         RoleType roleType;
810         Exclusive.RoleMembership exclusiveRoleMembership;
811         Shared.RoleMembership sharedRoleMembership;
812     }
813 
814     mapping(uint => Role) private roles;
815 
816     /**
817      * @notice Reverts unless the caller is a member of the specified roleId.
818      */
819     modifier onlyRoleHolder(uint roleId) {
820         require(holdsRole(roleId, msg.sender), "Sender does not hold required role");
821         _;
822     }
823 
824     /**
825      * @notice Reverts unless the caller is a member of the manager role for the specified roleId.
826      */
827     modifier onlyRoleManager(uint roleId) {
828         require(holdsRole(roles[roleId].managingRole, msg.sender), "Can only be called by a role manager");
829         _;
830     }
831 
832     /**
833      * @notice Reverts unless the roleId represents an initialized, exclusive roleId.
834      */
835     modifier onlyExclusive(uint roleId) {
836         require(roles[roleId].roleType == RoleType.Exclusive, "Must be called on an initialized Exclusive role");
837         _;
838     }
839 
840     /**
841      * @notice Reverts unless the roleId represents an initialized, shared roleId.
842      */
843     modifier onlyShared(uint roleId) {
844         require(roles[roleId].roleType == RoleType.Shared, "Must be called on an initialized Shared role");
845         _;
846     }
847 
848     /**
849      * @notice Whether `memberToCheck` is a member of roleId.
850      * @dev Reverts if roleId does not correspond to an initialized role.
851      */
852     function holdsRole(uint roleId, address memberToCheck) public view returns (bool) {
853         Role storage role = roles[roleId];
854         if (role.roleType == RoleType.Exclusive) {
855             return role.exclusiveRoleMembership.isMember(memberToCheck);
856         } else if (role.roleType == RoleType.Shared) {
857             return role.sharedRoleMembership.isMember(memberToCheck);
858         }
859         require(false, "Invalid roleId");
860     }
861 
862     /**
863      * @notice Changes the exclusive role holder of `roleId` to `newMember`.
864      * @dev Reverts if the caller is not a member of the managing role for `roleId` or if `roleId` is not an
865      * initialized, exclusive role.
866      */
867     function resetMember(uint roleId, address newMember) public onlyExclusive(roleId) onlyRoleManager(roleId) {
868         roles[roleId].exclusiveRoleMembership.resetMember(newMember);
869     }
870 
871     /**
872      * @notice Gets the current holder of the exclusive role, `roleId`.
873      * @dev Reverts if `roleId` does not represent an initialized, exclusive role.
874      */
875     function getMember(uint roleId) public view onlyExclusive(roleId) returns (address) {
876         return roles[roleId].exclusiveRoleMembership.getMember();
877     }
878 
879     /**
880      * @notice Adds `newMember` to the shared role, `roleId`.
881      * @dev Reverts if `roleId` does not represent an initialized, shared role or if the caller is not a member of the
882      * managing role for `roleId`.
883      */
884     function addMember(uint roleId, address newMember) public onlyShared(roleId) onlyRoleManager(roleId) {
885         roles[roleId].sharedRoleMembership.addMember(newMember);
886     }
887 
888     /**
889      * @notice Removes `memberToRemove` from the shared role, `roleId`.
890      * @dev Reverts if `roleId` does not represent an initialized, shared role or if the caller is not a member of the
891      * managing role for `roleId`.
892      */
893     function removeMember(uint roleId, address memberToRemove) public onlyShared(roleId) onlyRoleManager(roleId) {
894         roles[roleId].sharedRoleMembership.removeMember(memberToRemove);
895     }
896 
897     /**
898      * @notice Reverts if `roleId` is not initialized.
899      */
900     modifier onlyValidRole(uint roleId) {
901         require(roles[roleId].roleType != RoleType.Invalid, "Attempted to use an invalid roleId");
902         _;
903     }
904 
905     /**
906      * @notice Reverts if `roleId` is initialized.
907      */
908     modifier onlyInvalidRole(uint roleId) {
909         require(roles[roleId].roleType == RoleType.Invalid, "Cannot use a pre-existing role");
910         _;
911     }
912 
913     /**
914      * @notice Internal method to initialize a shared role, `roleId`, which will be managed by `managingRoleId`.
915      * `initialMembers` will be immediately added to the role.
916      * @dev Should be called by derived contracts, usually at construction time. Will revert if the role is already
917      * initialized.
918      */
919     function _createSharedRole(uint roleId, uint managingRoleId, address[] memory initialMembers)
920         internal
921         onlyInvalidRole(roleId)
922     {
923         Role storage role = roles[roleId];
924         role.roleType = RoleType.Shared;
925         role.managingRole = managingRoleId;
926         role.sharedRoleMembership.init(initialMembers);
927         require(roles[managingRoleId].roleType != RoleType.Invalid,
928             "Attempted to use an invalid role to manage a shared role");
929     }
930 
931     /**
932      * @notice Internal method to initialize a exclusive role, `roleId`, which will be managed by `managingRoleId`.
933      * `initialMembers` will be immediately added to the role.
934      * @dev Should be called by derived contracts, usually at construction time. Will revert if the role is already
935      * initialized.
936      */
937     function _createExclusiveRole(uint roleId, uint managingRoleId, address initialMember)
938         internal
939         onlyInvalidRole(roleId)
940     {
941         Role storage role = roles[roleId];
942         role.roleType = RoleType.Exclusive;
943         role.managingRole = managingRoleId;
944         role.exclusiveRoleMembership.init(initialMember);
945         require(roles[managingRoleId].roleType != RoleType.Invalid,
946             "Attempted to use an invalid role to manage an exclusive role");
947     }
948 }
949 
950 
951 /**
952  * @title Ownership of this token allows a voter to respond to price requests.
953  * @dev Supports snapshotting and allows the Oracle to mint new tokens as rewards.
954  */
955 contract VotingToken is ExpandedIERC20, ERC20Snapshot, MultiRole {
956 
957     enum Roles {
958         // Can set the minter and burner.
959         Owner,
960         // Addresses that can mint new tokens.
961         Minter,
962         // Addresses that can burn tokens that address owns.
963         Burner
964     }
965 
966     // Standard ERC20 metadata.
967     string public constant name = "UMA Voting Token v1"; // solhint-disable-line const-name-snakecase
968     string public constant symbol = "UMA"; // solhint-disable-line const-name-snakecase
969     uint8 public constant decimals = 18; // solhint-disable-line const-name-snakecase
970 
971     constructor() public {
972         _createExclusiveRole(uint(Roles.Owner), uint(Roles.Owner), msg.sender);
973         _createSharedRole(uint(Roles.Minter), uint(Roles.Owner), new address[](0));
974         _createSharedRole(uint(Roles.Burner), uint(Roles.Owner), new address[](0));
975     }
976 
977     /**
978      * @dev Mints `value` tokens to `recipient`, returning true on success.
979      */
980     function mint(address recipient, uint value) external onlyRoleHolder(uint(Roles.Minter)) returns (bool) {
981         _mint(recipient, value);
982         return true;
983     }
984 
985     /**
986      * @dev Burns `value` tokens owned by `msg.sender`.
987      */
988     function burn(uint value) external onlyRoleHolder(uint(Roles.Burner)) {
989         _burn(msg.sender, value);
990     }
991 }