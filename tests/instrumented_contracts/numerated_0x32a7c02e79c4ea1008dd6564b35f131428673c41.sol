1 pragma solidity >=0.5.0 <0.7.0;
2 
3 
4 /*
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with GSN meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 contract Context {
15     // Empty internal constructor, to prevent people from mistakenly deploying
16     // an instance of this contract, which should be used via inheritance.
17     constructor () internal { }
18     // solhint-disable-previous-line no-empty-blocks
19 
20     function _msgSender() internal view returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 /**
31  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
32  * the optional functions; to access them see {ERC20Detailed}.
33  */
34 interface IERC20 {
35     /**
36      * @dev Returns the amount of tokens in existence.
37      */
38     function totalSupply() external view returns (uint256);
39 
40     /**
41      * @dev Returns the amount of tokens owned by `account`.
42      */
43     function balanceOf(address account) external view returns (uint256);
44 
45     /**
46      * @dev Moves `amount` tokens from the caller's account to `recipient`.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * Emits a {Transfer} event.
51      */
52     function transfer(address recipient, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Returns the remaining number of tokens that `spender` will be
56      * allowed to spend on behalf of `owner` through {transferFrom}. This is
57      * zero by default.
58      *
59      * This value changes when {approve} or {transferFrom} are called.
60      */
61     function allowance(address owner, address spender) external view returns (uint256);
62 
63     /**
64      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * IMPORTANT: Beware that changing an allowance with this method brings the risk
69      * that someone may use both the old and the new allowance by unfortunate
70      * transaction ordering. One possible solution to mitigate this race
71      * condition is to first reduce the spender's allowance to 0 and set the
72      * desired value afterwards:
73      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
74      *
75      * Emits an {Approval} event.
76      */
77     function approve(address spender, uint256 amount) external returns (bool);
78 
79     /**
80      * @dev Moves `amount` tokens from `sender` to `recipient` using the
81      * allowance mechanism. `amount` is then deducted from the caller's
82      * allowance.
83      *
84      * Returns a boolean value indicating whether the operation succeeded.
85      *
86      * Emits a {Transfer} event.
87      */
88     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
89 
90     /**
91      * @dev Emitted when `value` tokens are moved from one account (`from`) to
92      * another (`to`).
93      *
94      * Note that `value` may be zero.
95      */
96     event Transfer(address indexed from, address indexed to, uint256 value);
97 
98     /**
99      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
100      * a call to {approve}. `value` is the new allowance.
101      */
102     event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 
105 /**
106  * @dev Wrappers over Solidity's arithmetic operations with added overflow
107  * checks.
108  *
109  * Arithmetic operations in Solidity wrap on overflow. This can easily result
110  * in bugs, because programmers usually assume that an overflow raises an
111  * error, which is the standard behavior in high level programming languages.
112  * `SafeMath` restores this intuition by reverting the transaction when an
113  * operation overflows.
114  *
115  * Using this library instead of the unchecked operations eliminates an entire
116  * class of bugs, so it's recommended to use it always.
117  */
118 library SafeMath {
119     /**
120      * @dev Returns the addition of two unsigned integers, reverting on
121      * overflow.
122      *
123      * Counterpart to Solidity's `+` operator.
124      *
125      * Requirements:
126      * - Addition cannot overflow.
127      */
128     function add(uint256 a, uint256 b) internal pure returns (uint256) {
129         uint256 c = a + b;
130         require(c >= a, "SafeMath: addition overflow");
131 
132         return c;
133     }
134 
135     /**
136      * @dev Returns the subtraction of two unsigned integers, reverting on
137      * overflow (when the result is negative).
138      *
139      * Counterpart to Solidity's `-` operator.
140      *
141      * Requirements:
142      * - Subtraction cannot overflow.
143      */
144     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
145         return sub(a, b, "SafeMath: subtraction overflow");
146     }
147 
148     /**
149      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
150      * overflow (when the result is negative).
151      *
152      * Counterpart to Solidity's `-` operator.
153      *
154      * Requirements:
155      * - Subtraction cannot overflow.
156      *
157      * _Available since v2.4.0._
158      */
159     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
160         require(b <= a, errorMessage);
161         uint256 c = a - b;
162 
163         return c;
164     }
165 
166     /**
167      * @dev Returns the multiplication of two unsigned integers, reverting on
168      * overflow.
169      *
170      * Counterpart to Solidity's `*` operator.
171      *
172      * Requirements:
173      * - Multiplication cannot overflow.
174      */
175     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
176         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
177         // benefit is lost if 'b' is also tested.
178         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
179         if (a == 0) {
180             return 0;
181         }
182 
183         uint256 c = a * b;
184         require(c / a == b, "SafeMath: multiplication overflow");
185 
186         return c;
187     }
188 
189     /**
190      * @dev Returns the integer division of two unsigned integers. Reverts on
191      * division by zero. The result is rounded towards zero.
192      *
193      * Counterpart to Solidity's `/` operator. Note: this function uses a
194      * `revert` opcode (which leaves remaining gas untouched) while Solidity
195      * uses an invalid opcode to revert (consuming all remaining gas).
196      *
197      * Requirements:
198      * - The divisor cannot be zero.
199      */
200     function div(uint256 a, uint256 b) internal pure returns (uint256) {
201         return div(a, b, "SafeMath: division by zero");
202     }
203 
204     /**
205      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
206      * division by zero. The result is rounded towards zero.
207      *
208      * Counterpart to Solidity's `/` operator. Note: this function uses a
209      * `revert` opcode (which leaves remaining gas untouched) while Solidity
210      * uses an invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      * - The divisor cannot be zero.
214      *
215      * _Available since v2.4.0._
216      */
217     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
218         // Solidity only automatically asserts when dividing by 0
219         require(b > 0, errorMessage);
220         uint256 c = a / b;
221         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
222 
223         return c;
224     }
225 
226     /**
227      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
228      * Reverts when dividing by zero.
229      *
230      * Counterpart to Solidity's `%` operator. This function uses a `revert`
231      * opcode (which leaves remaining gas untouched) while Solidity uses an
232      * invalid opcode to revert (consuming all remaining gas).
233      *
234      * Requirements:
235      * - The divisor cannot be zero.
236      */
237     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
238         return mod(a, b, "SafeMath: modulo by zero");
239     }
240 
241     /**
242      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
243      * Reverts with custom message when dividing by zero.
244      *
245      * Counterpart to Solidity's `%` operator. This function uses a `revert`
246      * opcode (which leaves remaining gas untouched) while Solidity uses an
247      * invalid opcode to revert (consuming all remaining gas).
248      *
249      * Requirements:
250      * - The divisor cannot be zero.
251      *
252      * _Available since v2.4.0._
253      */
254     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
255         require(b != 0, errorMessage);
256         return a % b;
257     }
258 }
259 
260 /**
261  * @dev Implementation of the {IERC20} interface.
262  *
263  * This implementation is agnostic to the way tokens are created. This means
264  * that a supply mechanism has to be added in a derived contract using {_mint}.
265  * For a generic mechanism see {ERC20Mintable}.
266  *
267  * TIP: For a detailed writeup see our guide
268  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
269  * to implement supply mechanisms].
270  *
271  * We have followed general OpenZeppelin guidelines: functions revert instead
272  * of returning `false` on failure. This behavior is nonetheless conventional
273  * and does not conflict with the expectations of ERC20 applications.
274  *
275  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
276  * This allows applications to reconstruct the allowance for all accounts just
277  * by listening to said events. Other implementations of the EIP may not emit
278  * these events, as it isn't required by the specification.
279  *
280  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
281  * functions have been added to mitigate the well-known issues around setting
282  * allowances. See {IERC20-approve}.
283  */
284 contract ERC20 is Context, IERC20 {
285     using SafeMath for uint256;
286 
287     mapping (address => uint256) private _balances;
288 
289     mapping (address => mapping (address => uint256)) private _allowances;
290 
291     uint256 private _totalSupply;
292 
293     /**
294      * @dev See {IERC20-totalSupply}.
295      */
296     function totalSupply() public view returns (uint256) {
297         return _totalSupply;
298     }
299 
300     /**
301      * @dev See {IERC20-balanceOf}.
302      */
303     function balanceOf(address account) public view returns (uint256) {
304         return _balances[account];
305     }
306 
307     /**
308      * @dev See {IERC20-transfer}.
309      *
310      * Requirements:
311      *
312      * - `recipient` cannot be the zero address.
313      * - the caller must have a balance of at least `amount`.
314      */
315     function transfer(address recipient, uint256 amount) public returns (bool) {
316         _transfer(_msgSender(), recipient, amount);
317         return true;
318     }
319 
320     /**
321      * @dev See {IERC20-allowance}.
322      */
323     function allowance(address owner, address spender) public view returns (uint256) {
324         return _allowances[owner][spender];
325     }
326 
327     /**
328      * @dev See {IERC20-approve}.
329      *
330      * Requirements:
331      *
332      * - `spender` cannot be the zero address.
333      */
334     function approve(address spender, uint256 amount) public returns (bool) {
335         _approve(_msgSender(), spender, amount);
336         return true;
337     }
338 
339     /**
340      * @dev See {IERC20-transferFrom}.
341      *
342      * Emits an {Approval} event indicating the updated allowance. This is not
343      * required by the EIP. See the note at the beginning of {ERC20};
344      *
345      * Requirements:
346      * - `sender` and `recipient` cannot be the zero address.
347      * - `sender` must have a balance of at least `amount`.
348      * - the caller must have allowance for `sender`'s tokens of at least
349      * `amount`.
350      */
351     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
352         _transfer(sender, recipient, amount);
353         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
354         return true;
355     }
356 
357     /**
358      * @dev Atomically increases the allowance granted to `spender` by the caller.
359      *
360      * This is an alternative to {approve} that can be used as a mitigation for
361      * problems described in {IERC20-approve}.
362      *
363      * Emits an {Approval} event indicating the updated allowance.
364      *
365      * Requirements:
366      *
367      * - `spender` cannot be the zero address.
368      */
369     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
370         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
371         return true;
372     }
373 
374     /**
375      * @dev Atomically decreases the allowance granted to `spender` by the caller.
376      *
377      * This is an alternative to {approve} that can be used as a mitigation for
378      * problems described in {IERC20-approve}.
379      *
380      * Emits an {Approval} event indicating the updated allowance.
381      *
382      * Requirements:
383      *
384      * - `spender` cannot be the zero address.
385      * - `spender` must have allowance for the caller of at least
386      * `subtractedValue`.
387      */
388     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
389         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
390         return true;
391     }
392 
393     /**
394      * @dev Moves tokens `amount` from `sender` to `recipient`.
395      *
396      * This is internal function is equivalent to {transfer}, and can be used to
397      * e.g. implement automatic token fees, slashing mechanisms, etc.
398      *
399      * Emits a {Transfer} event.
400      *
401      * Requirements:
402      *
403      * - `sender` cannot be the zero address.
404      * - `recipient` cannot be the zero address.
405      * - `sender` must have a balance of at least `amount`.
406      */
407     function _transfer(address sender, address recipient, uint256 amount) internal {
408         require(sender != address(0), "ERC20: transfer from the zero address");
409         require(recipient != address(0), "ERC20: transfer to the zero address");
410 
411         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
412         _balances[recipient] = _balances[recipient].add(amount);
413         emit Transfer(sender, recipient, amount);
414     }
415 
416     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
417      * the total supply.
418      *
419      * Emits a {Transfer} event with `from` set to the zero address.
420      *
421      * Requirements
422      *
423      * - `to` cannot be the zero address.
424      */
425     function _mint(address account, uint256 amount) internal {
426         require(account != address(0), "ERC20: mint to the zero address");
427 
428         _totalSupply = _totalSupply.add(amount);
429         _balances[account] = _balances[account].add(amount);
430         emit Transfer(address(0), account, amount);
431     }
432 
433     /**
434      * @dev Destroys `amount` tokens from `account`, reducing the
435      * total supply.
436      *
437      * Emits a {Transfer} event with `to` set to the zero address.
438      *
439      * Requirements
440      *
441      * - `account` cannot be the zero address.
442      * - `account` must have at least `amount` tokens.
443      */
444     function _burn(address account, uint256 amount) internal {
445         require(account != address(0), "ERC20: burn from the zero address");
446 
447         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
448         _totalSupply = _totalSupply.sub(amount);
449         emit Transfer(account, address(0), amount);
450     }
451 
452     /**
453      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
454      *
455      * This is internal function is equivalent to `approve`, and can be used to
456      * e.g. set automatic allowances for certain subsystems, etc.
457      *
458      * Emits an {Approval} event.
459      *
460      * Requirements:
461      *
462      * - `owner` cannot be the zero address.
463      * - `spender` cannot be the zero address.
464      */
465     function _approve(address owner, address spender, uint256 amount) internal {
466         require(owner != address(0), "ERC20: approve from the zero address");
467         require(spender != address(0), "ERC20: approve to the zero address");
468 
469         _allowances[owner][spender] = amount;
470         emit Approval(owner, spender, amount);
471     }
472 
473     /**
474      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
475      * from the caller's allowance.
476      *
477      * See {_burn} and {_approve}.
478      */
479     function _burnFrom(address account, uint256 amount) internal {
480         _burn(account, amount);
481         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
482     }
483 }
484 
485 /**
486  * @dev Extension of {ERC20} that allows token holders to destroy both their own
487  * tokens and those that they have an allowance for, in a way that can be
488  * recognized off-chain (via event analysis).
489  */
490 contract ERC20Burnable is Context, ERC20 {
491     /**
492      * @dev Destroys `amount` tokens from the caller.
493      *
494      * See {ERC20-_burn}.
495      */
496     function burn(uint256 amount) public {
497         _burn(_msgSender(), amount);
498     }
499 
500     /**
501      * @dev See {ERC20-_burnFrom}.
502      */
503     function burnFrom(address account, uint256 amount) public {
504         _burnFrom(account, amount);
505     }
506 }
507 
508 /**
509  * @dev Contract module which provides a basic access control mechanism, where
510  * there is an account (an owner) that can be granted exclusive access to
511  * specific functions.
512  *
513  * This module is used through inheritance. It will make available the modifier
514  * `onlyOwner`, which can be applied to your functions to restrict their use to
515  * the owner.
516  */
517 contract Ownable is Context {
518     address private _owner;
519 
520     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
521 
522     /**
523      * @dev Initializes the contract setting the deployer as the initial owner.
524      */
525     constructor () internal {
526         address msgSender = _msgSender();
527         _owner = msgSender;
528         emit OwnershipTransferred(address(0), msgSender);
529     }
530 
531     /**
532      * @dev Returns the address of the current owner.
533      */
534     function owner() public view returns (address) {
535         return _owner;
536     }
537 
538     /**
539      * @dev Throws if called by any account other than the owner.
540      */
541     modifier onlyOwner() {
542         require(isOwner(), "Ownable: caller is not the owner");
543         _;
544     }
545 
546     /**
547      * @dev Returns true if the caller is the current owner.
548      */
549     function isOwner() public view returns (bool) {
550         return _msgSender() == _owner;
551     }
552 
553     /**
554      * @dev Leaves the contract without owner. It will not be possible to call
555      * `onlyOwner` functions anymore. Can only be called by the current owner.
556      *
557      * NOTE: Renouncing ownership will leave the contract without an owner,
558      * thereby removing any functionality that is only available to the owner.
559      */
560     function renounceOwnership() public onlyOwner {
561         emit OwnershipTransferred(_owner, address(0));
562         _owner = address(0);
563     }
564 
565     /**
566      * @dev Transfers ownership of the contract to a new account (`newOwner`).
567      * Can only be called by the current owner.
568      */
569     function transferOwnership(address newOwner) public onlyOwner {
570         _transferOwnership(newOwner);
571     }
572 
573     /**
574      * @dev Transfers ownership of the contract to a new account (`newOwner`).
575      */
576     function _transferOwnership(address newOwner) internal {
577         require(newOwner != address(0), "Ownable: new owner is the zero address");
578         emit OwnershipTransferred(_owner, newOwner);
579         _owner = newOwner;
580     }
581 }
582 
583 interface ICrustToken {
584   function mint(address account, uint amount) external;
585   function burn(address account, uint amount) external;
586   function getBalance(address account) external view returns (uint256);
587 }
588 
589 contract CrustToken is ERC20, Ownable, ICrustToken {
590   function name() public pure returns (string memory) {
591     return "CRUST";
592   }
593 
594   function symbol() public pure returns (string memory) {
595     return "CRU";
596   }
597 
598   function decimals() public pure returns (uint8) {
599     return 18;
600   }
601 
602   function burn(address account, uint amount) public onlyOwner {
603     _burn(account, amount);
604   }
605 
606   function mint(address account, uint amount) public onlyOwner {
607     _mint(account, amount);
608   }
609 
610   function getBalance(address account) public view returns (uint256) {
611     return balanceOf(account);
612   }
613 }
614 
615 contract CrustClaimsBase is Ownable {
616   struct ReviewItem {
617     address _target;
618     uint _amount;
619   }
620 
621   // max cap limit: 1 billion
622   uint constant HardCap = 1_000_000_000 * (10 ** 18);
623 
624   ICrustToken _token;
625   address payable _wallet;
626   address private _reviewer;
627   uint _cap;
628   uint _selled;
629   uint32 _nextReviewId = 0;
630   uint32 _totalReviewItemsCount = 0;
631   mapping (uint32 => ReviewItem) private _reviewItems;
632 
633   // event BuyCRU(address indexed _address, uint256 _value);
634   event ReviewerChanged(address indexed _reviewer);
635   event MintRequestSubmited(uint32 _reviewId);
636   event MintRequestReviewed(uint32 _reviewId, bool _approve);
637   event MintCRU(address indexed _address, uint256 _value);
638   event CapUpdated(uint256 _value);
639   event ClaimCRU(address indexed _address, uint256 _value, bytes32 pubKey);
640   event WithDraw(uint256 _value);
641 
642   modifier onlyReviewer() {
643     require(isReviewer(), "CrustClaims: caller is not the reviewer");
644     _;
645   }
646 
647   constructor(
648               address payable wallet,
649               ICrustToken token,
650               uint cap // cap: unit by eth
651               ) public {
652     _token = token;
653     _wallet = wallet;
654     _cap = cap * (10 ** 18);
655     _selled = 0;
656     _reviewer = msg.sender;
657   }
658 
659   function setReviewer(address account) public onlyReviewer {
660     require(_reviewer != account, "CrustClaims: reivewer must not the same");
661     _reviewer = account;
662     emit ReviewerChanged(account);
663   }
664 
665   function isReviewer() public view returns (bool) {
666     return _msgSender() == _reviewer;
667   }
668 
669   function reviewer() public view returns (address) {
670     return _reviewer;
671   }
672 
673   function getCap() public view returns(uint) {
674     return _cap;
675   }
676 
677   function getSelled() public view returns(uint) {
678     return _selled;
679   }
680 
681   function getToken() public view returns(ICrustToken tokenAddress) {
682     return _token;
683   }
684 
685    //
686   // sumbmit the mint request to the review queue
687   function submitMint(address account, uint amount) public onlyOwner {
688     require(amount > 0, "CrustClaims: amount must be positive");
689     uint32 reviewId = _totalReviewItemsCount;
690     _reviewItems[reviewId] = ReviewItem(account, amount);
691     _totalReviewItemsCount = _totalReviewItemsCount + 1;
692     emit MintRequestSubmited(reviewId);
693   }
694 
695   function reviewMintRequest(uint32 reviewId, bool approve) public onlyReviewer {
696     require(reviewId == _nextReviewId, "CrustClaims: mint requests should be reviewed by order");
697     require(reviewId < _totalReviewItemsCount, "CrustClaims: invalid reviewId");
698     ReviewItem memory item = _reviewItems[reviewId];
699     if (approve) {
700       _mint (item._target, item._amount);
701     }
702     _nextReviewId = _nextReviewId + 1; // move to next review item
703     delete _reviewItems[reviewId]; // cleanup storage
704     emit MintRequestReviewed(reviewId, approve);
705   }
706 
707   function getNextReviewId() public view returns (uint32) {
708     return _nextReviewId;
709   }
710 
711   function getReviewCount() public view returns (uint32) {
712       return _totalReviewItemsCount;
713   }
714 
715   function getUnReviewItemAddress(uint32 reviewId) public view returns (address) {
716     require(reviewId < _totalReviewItemsCount, "CrustClaims: invalid reviewId");
717     return _reviewItems[reviewId]._target;
718   }
719 
720   function getUnReviewItemAmount(uint32 reviewId) public view returns (uint) {
721       require(reviewId < _totalReviewItemsCount, "CrustClaims: invalid reviewId");
722       return _reviewItems[reviewId]._amount;
723   }
724 
725   function _mint(address account, uint amount) private {
726     uint selled = SafeMath.add(_selled, amount);
727     require(selled <= _cap, "not enough token left");
728     _token.mint(account, amount);
729     _selled = selled;
730     emit MintCRU(account, amount);
731   }
732 
733   //
734   // cap in eth
735   function updateCap(uint amount) public onlyOwner {
736     uint cap = SafeMath.mul(amount, 10 ** 18);
737     require(cap <= HardCap, "cap must not exceed hard cap limit");
738     require(cap >= _selled, "cap must not less than selled");
739     _cap = cap;
740     emit CapUpdated(cap);
741   }
742 
743   //
744   // claim token
745   function claim(uint amount, bytes32 pubKey) public {
746     _claim(msg.sender, amount, pubKey);
747   }
748 
749   //
750   // claim all token in the account
751   function claimAll(bytes32 pubKey) public {
752     uint256 amount = _token.getBalance(msg.sender);
753     _claim(msg.sender, amount, pubKey);
754   }
755 
756   function _claim(address account, uint amount, bytes32 pubKey) private {
757     require(amount > 0, "claim amount should not be zero");
758     require(pubKey != bytes32(0), "Failed to provide an Ed25519 or SR25519 public key.");
759 
760     _token.burn(account, amount);
761     emit ClaimCRU(account, amount, pubKey);
762   }
763 
764   //
765   // should not be used, leave it here to cover some corner cases
766   function withDraw(uint amount) public onlyOwner {
767     _wallet.transfer(amount);
768     emit WithDraw(amount);
769   }
770 }
771 
772 //
773 // locked tokens, disabled transfer functions
774 contract CrustTokenLocked is ICrustToken, Ownable {
775   string _name;
776   string _symbol;
777   uint256 private _totalSupply;
778 
779   event Transfer(address indexed from, address indexed to, uint256 value);
780 
781   mapping (address => uint256) private _balances;
782 
783   constructor(string memory name, string memory symbol) public {
784     _name = name;
785     _symbol = symbol;
786   }
787 
788   function name() public view returns (string memory) {
789     return _name;
790   }
791 
792   function symbol() public view returns (string memory) {
793     return _symbol;
794   }
795 
796   function decimals() public pure returns (uint8) {
797     return 18;
798   }
799 
800   function totalSupply() public view returns (uint256) {
801     return _totalSupply;
802   }
803 
804   function balanceOf(address account) public view returns (uint256) {
805     return _balances[account];
806   }
807 
808   function getBalance(address account) public view returns (uint256) {
809       return balanceOf(account);
810   }
811 
812   function mint(address account, uint256 amount) public onlyOwner {
813     require(account != address(0), "CrustToken: mint to the zero address");
814 
815     _totalSupply = SafeMath.add(_totalSupply, amount);
816     _balances[account] = SafeMath.add(_balances[account], amount);
817     emit Transfer(address(0), account, amount);
818   }
819 
820   function burn(address account, uint256 amount) public onlyOwner{
821     require(account != address(0), "CrustToken: burn from the zero address");
822 
823     _balances[account] = SafeMath.sub(_balances[account], amount, "CrustToken: burn amount exceeds balance");
824     _totalSupply = SafeMath.sub(_totalSupply, amount);
825     emit Transfer(account, address(0), amount);
826   }
827 }
828 
829 /* solium-disable-next-line */
830 contract CrustTokenLocked18 is CrustTokenLocked("CRUST18", "CRU18") {
831 }
832 
833 /* solium-disable-next-line */
834 contract CrustTokenLocked24 is CrustTokenLocked("CRUST24", "CRU24") {
835 }
836 
837 /* solium-disable-next-line */
838 contract CrustTokenLocked24Delayed is CrustTokenLocked("CRUST24D", "CRU24D") {
839 }
840 
841 contract CrustClaims is CrustClaimsBase {
842   constructor(
843               address payable wallet,
844               CrustToken token,
845               uint cap // cap: unit by eth
846               ) public CrustClaimsBase(wallet, token, cap) {
847   }
848 }
849 
850 contract CrustClaims18 is CrustClaimsBase {
851   constructor(
852               address payable wallet,
853               CrustTokenLocked18 token,
854               uint cap // cap: unit by eth
855               ) public CrustClaimsBase(wallet, token, cap) {
856   }
857 }
858 
859 contract CrustClaims24 is CrustClaimsBase {
860   constructor(
861               address payable wallet,
862               CrustTokenLocked24 token,
863               uint cap
864               ) public CrustClaimsBase(wallet, token, cap) {
865   }
866 }
867 
868 contract CrustClaims24Delayed is CrustClaimsBase {
869     constructor(
870                 address payable wallet,
871                 CrustTokenLocked24Delayed token,
872                 uint cap
873                 ) public CrustClaimsBase(wallet, token, cap) {
874     }
875 }