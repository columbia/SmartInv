1 // SPDX-License-Identifier: MIT
2 
3 /**
4 
5 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
6 MMMMMMMMMMMMMMMMMMMMMMMMMMMMWWWWWWWWWWWWWWWMMMMMMMMMMMMMMMMMMMMMMMMMMM
7 MMMMMMMMMMMMMMMMMMMMMMWWNXXKKKKKKKXXXXKKKKKKXXNWWMMMMMMMMMMMMMMMMMMMMM
8 MMMMMMMMMMMMMMMMMMWNXKKKKXXNWWWWMMWWWWMWWWWNXXXKKKXNWMMMMMMMMMMMMMMMMM
9 MMMMMMMMMMMMMMMWNXKKKXNWMMMMMMMMMNOdxKWMMMMMMMMWNXKKKXNWMMMMMMMMMMMMMM
10 MMMMMMMMMMMMMWXKKKNWMMMMMMMMMMMMNx:;;l0WMMMMMMMMMMMWNK0KXWMMMMMMMMMMMM
11 MMMMMMMMMMMWXKKXWMMMMMMMMMMMMMMXd:;;;;cOWMMMMMMMMMMMMMWXKKXWMMMMMMMMMM
12 MMMMMMMMMWNKKXWMMMMMMMMMMMMMMWKo;;col:;:kNMMMMMMMMMMMMMMWX0KNWMMMMMMMM
13 MMMMMMMMWX0XWMMMMMMMMMMMMMMMWOl;;oKWXkc;:dXMMMMMMMMMMMMMMMWX0XWMMMMMMM
14 MMMMMMMNKKNWMMMMMMMMMMMMMMMNkc;:dXMMMWOc;;oKWMMMMMMMMMMMMMMWNKKNMMMMMM
15 MMMMMMNKKNMMMMMMMMMMMMMMMMNx:;:xNMMMMMW0l;;l0WMMMMMMMWMMMMMMMNKKNMMMMM
16 MMMMMNKKNMMMMMMMMMMMMMMMMXd:;ckNMMMMMMMMKo:;cOWMMMMXkxkXWMMMMMNKKNMMMM
17 MMMMWK0NMMMMMMMMMMMMMMMWKo;;l0WMMMMMMMMMMXx:;:xNMMW0lccxXMMMMMMN0KWMMM
18 MMMMX0XWMMMMMMWWMMMMMMWOl;;oKWMMMMMMMMMMMMNkc;:dXMMNklcoKMMMMMMMX0XMMM
19 MMMWKKNMMWK0OkkkkkkKWNkc;:dXMMMMMMMMMMMMMMMWOl;;oKWMXdcxNMMMMMMMNKKWMM
20 MMMN0XWMMWNXX0OdlccdKOc;:xNMMMWXKKXNWNNNNWWMW0o;;l0WNkdKWMMMMMMMWX0NMM
21 MMMX0XMMMMMMMMMN0dlcdOxoONMMMMW0xdddddodxk0KNWXd:;l0Kx0WMMMMMMMMMX0XMM
22 MMMX0NMMMMMMMMMMWXxlcoOXWMMMMWKkolclodkKNNNNWWMNxcxOkKWMMMMMMMMMMX0XMM
23 MMMX0XMMMMMMMMMMMMNklclkNMMWXklccodxdodKWMMMMMMMNKOkKWMMMMMMMMMMMX0XMM
24 MMMN0XWMMMMMMMMMMMMNOoclxXN0occcdKX0xlco0WMMMMMMNOOXMMMMMMMMMMMMMX0NMM
25 MMMWKKWMMMMMMMMMMMMMW0dccoxocccdKWMWNklclONMMMMXOONMMMMMMMMMMMMMWKKWMM
26 MMMMX0XMMMMMMMMMMMMMMWKdcccccco0WMMMMNOoclkNWWKk0NMMMMMMMMMMMMMMX0XWMM
27 MMMMWKKNMMMMMMMMMMMMMMMXxlcccckNMMMMMMW0oclxK0kKWMMMMMMMMMMMMMMNKKWMMM
28 MMMMMN0KWMMMMMMMMMMMMMMMNklccoKWMMMMMMMWKdlcoxKWMMMMMMMMMMMMMMWK0NMMMM
29 MMMMMMN0KWMMMMMMMMMMMMMMMNOod0KXWMMMMMMNK0xoxXWMMMMMMMMMMMMMMWK0NMMMMM
30 MMMMMMMN0KNMMMMMMMMMMMMMMMWXKkll0WMMMMXdcoOKNMMMMMMMMMMMMMMMNK0NMMMMMM
31 MMMMMMMMNK0XWMMMMMMMMMMMMMMMNd:;cOWMWKo:;c0WMMMMMMMMMMMMMMWX0KNMMMMMMM
32 MMMMMMMMMWXKKNWMMMMMMMMMMMMMMXd:;cx0kl;;l0WMMMMMMMMMMMMMWNKKXWMMMMMMMM
33 MMMMMMMMMMMWX0KNWMMMMMMMMMMMMMNkc;;::;:oKWMMMMMMMMMMMMWNK0XWMMMMMMMMMM
34 MMMMMMMMMMMMMNXKKXNWMMMMMMMMMMMWOc;;;:dXMMMMMMMMMMMWNXKKXWMMMMMMMMMMMM
35 MMMMMMMMMMMMMMMWNKKKXNWMMMMMMMMMW0l:ckNMMMMMMMMMWNXKKKNWMMMMMMMMMMMMMM
36 MMMMMMMMMMMMMMMMMMWNXKKKXXNWWWMMMMX0KWMMMWWWNXXKKKXNWMMMMMMMMMMMMMMMMM
37 MMMMMMMMMMMMMMMMMMMMMWWNXXKKKKKXXXXXXXXXXKKKKXXNWWMMMMMMMMMMMMMMMMMMMM
38 MMMMMMMMMMMMMMMMMMMMMMMMMMMWWNNNNNNNNNNNNWWWMMMMMMMMMMMMMMMMMMMMMMMMMM
39 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
40 
41 
42 ---------------------- [ WPSmartContracts.com ] ----------------------
43 
44                        [ Blockchain Made Easy ]
45 
46 
47     |
48     |  Stakes v.2
49     |
50     |----------------------------
51     |
52     |  Flavor
53     |
54     |  >  Ube: Fully featured ERC-20 Staking contract with maturity time 
55     |          and an annual interest 
56     |
57 
58 */
59 
60 pragma solidity ^0.8.2;
61 
62 /**
63  * @dev Wrappers over Solidity's arithmetic operations with added overflow
64  * checks.
65  *
66  * Arithmetic operations in Solidity wrap on overflow. This can easily result
67  * in bugs, because programmers usually assume that an overflow raises an
68  * error, which is the standard behavior in high level programming languages.
69  * `SafeMath` restores this intuition by reverting the transaction when an
70  * operation overflows.
71  *
72  * Using this library instead of the unchecked operations eliminates an entire
73  * class of bugs, so it's recommended to use it always.
74  */
75 library SafeMath {
76     /**
77      * @dev Returns the addition of two unsigned integers, reverting on
78      * overflow.
79      *
80      * Counterpart to Solidity's `+` operator.
81      *
82      * Requirements:
83      * - Addition cannot overflow.
84      */
85     function add(uint256 a, uint256 b) internal pure returns (uint256) {
86         uint256 c = a + b;
87         require(c >= a, "SafeMath: addition overflow");
88 
89         return c;
90     }
91 
92     /**
93      * @dev Returns the subtraction of two unsigned integers, reverting on
94      * overflow (when the result is negative).
95      *
96      * Counterpart to Solidity's `-` operator.
97      *
98      * Requirements:
99      * - Subtraction cannot overflow.
100      */
101     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
102         return sub(a, b, "SafeMath: subtraction overflow");
103     }
104 
105     /**
106      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
107      * overflow (when the result is negative).
108      *
109      * Counterpart to Solidity's `-` operator.
110      *
111      * Requirements:
112      * - Subtraction cannot overflow.
113      */
114     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
115         require(b <= a, errorMessage);
116         uint256 c = a - b;
117 
118         return c;
119     }
120 
121     /**
122      * @dev Returns the multiplication of two unsigned integers, reverting on
123      * overflow.
124      *
125      * Counterpart to Solidity's `*` operator.
126      *
127      * Requirements:
128      * - Multiplication cannot overflow.
129      */
130     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
131         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
132         // benefit is lost if 'b' is also tested.
133         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
134         if (a == 0) {
135             return 0;
136         }
137 
138         uint256 c = a * b;
139         require(c / a == b, "SafeMath: multiplication overflow");
140 
141         return c;
142     }
143 
144     /**
145      * @dev Returns the integer division of two unsigned integers. Reverts on
146      * division by zero. The result is rounded towards zero.
147      *
148      * Counterpart to Solidity's `/` operator. Note: this function uses a
149      * `revert` opcode (which leaves remaining gas untouched) while Solidity
150      * uses an invalid opcode to revert (consuming all remaining gas).
151      *
152      * Requirements:
153      * - The divisor cannot be zero.
154      */
155     function div(uint256 a, uint256 b) internal pure returns (uint256) {
156         return div(a, b, "SafeMath: division by zero");
157     }
158 
159     /**
160      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
161      * division by zero. The result is rounded towards zero.
162      *
163      * Counterpart to Solidity's `/` operator. Note: this function uses a
164      * `revert` opcode (which leaves remaining gas untouched) while Solidity
165      * uses an invalid opcode to revert (consuming all remaining gas).
166      *
167      * Requirements:
168      * - The divisor cannot be zero.
169      */
170     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
171         // Solidity only automatically asserts when dividing by 0
172         require(b > 0, errorMessage);
173         uint256 c = a / b;
174         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
175 
176         return c;
177     }
178 
179     /**
180      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
181      * Reverts when dividing by zero.
182      *
183      * Counterpart to Solidity's `%` operator. This function uses a `revert`
184      * opcode (which leaves remaining gas untouched) while Solidity uses an
185      * invalid opcode to revert (consuming all remaining gas).
186      *
187      * Requirements:
188      * - The divisor cannot be zero.
189      */
190     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
191         return mod(a, b, "SafeMath: modulo by zero");
192     }
193 
194     /**
195      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
196      * Reverts with custom message when dividing by zero.
197      *
198      * Counterpart to Solidity's `%` operator. This function uses a `revert`
199      * opcode (which leaves remaining gas untouched) while Solidity uses an
200      * invalid opcode to revert (consuming all remaining gas).
201      *
202      * Requirements:
203      * - The divisor cannot be zero.
204      */
205     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
206         require(b != 0, errorMessage);
207         return a % b;
208     }
209 }
210 
211 /**
212  * @title Owner
213  * @dev Set & change owner
214  */
215 contract Owner {
216 
217     address private owner;
218     
219     // event for EVM logging
220     event OwnerSet(address indexed oldOwner, address indexed newOwner);
221     
222     // modifier to check if caller is owner
223     modifier isOwner() {
224         // If the first argument of 'require' evaluates to 'false', execution terminates and all
225         // changes to the state and to Ether balances are reverted.
226         // This used to consume all gas in old EVM versions, but not anymore.
227         // It is often a good idea to use 'require' to check if functions are called correctly.
228         // As a second argument, you can also provide an explanation about what went wrong.
229         require(msg.sender == owner, "Caller is not owner");
230         _;
231     }
232     
233     /**
234      * @dev Set contract deployer as owner
235      */
236     constructor(address _owner) {
237         owner = _owner;
238         emit OwnerSet(address(0), owner);
239     }
240 
241     /**
242      * @dev Change owner
243      * @param newOwner address of new owner
244      */
245     function changeOwner(address newOwner) public isOwner {
246         emit OwnerSet(owner, newOwner);
247         owner = newOwner;
248     }
249 
250     /**
251      * @dev Return owner address 
252      * @return address of owner
253      */
254     function getOwner() public view returns (address) {
255         return owner;
256     }
257 }
258 
259 /**
260  * @dev Contract module that helps prevent reentrant calls to a function.
261  *
262  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
263  * available, which can be applied to functions to make sure there are no nested
264  * (reentrant) calls to them.
265  *
266  * Note that because there is a single `nonReentrant` guard, functions marked as
267  * `nonReentrant` may not call one another. This can be worked around by making
268  * those functions `private`, and then adding `external` `nonReentrant` entry
269  * points to them.
270  *
271  * TIP: If you would like to learn more about reentrancy and alternative ways
272  * to protect against it, check out our blog post
273  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
274  */
275 abstract contract ReentrancyGuard {
276     // Booleans are more expensive than uint256 or any type that takes up a full
277     // word because each write operation emits an extra SLOAD to first read the
278     // slot's contents, replace the bits taken up by the boolean, and then write
279     // back. This is the compiler's defense against contract upgrades and
280     // pointer aliasing, and it cannot be disabled.
281 
282     // The values being non-zero value makes deployment a bit more expensive,
283     // but in exchange the refund on every call to nonReentrant will be lower in
284     // amount. Since refunds are capped to a percentage of the total
285     // transaction's gas, it is best to keep them low in cases like this one, to
286     // increase the likelihood of the full refund coming into effect.
287     uint256 private constant _NOT_ENTERED = 1;
288     uint256 private constant _ENTERED = 2;
289 
290     uint256 private _status;
291 
292     constructor() {
293         _status = _NOT_ENTERED;
294     }
295 
296     /**
297      * @dev Prevents a contract from calling itself, directly or indirectly.
298      * Calling a `nonReentrant` function from another `nonReentrant`
299      * function is not supported. It is possible to prevent this from happening
300      * by making the `nonReentrant` function external, and making it call a
301      * `private` function that does the actual work.
302      */
303     modifier nonReentrant() {
304         // On the first call to nonReentrant, _notEntered will be true
305         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
306 
307         // Any calls to nonReentrant after this point will fail
308         _status = _ENTERED;
309 
310         _;
311 
312         // By storing the original value once again, a refund is triggered (see
313         // https://eips.ethereum.org/EIPS/eip-2200)
314         _status = _NOT_ENTERED;
315     }
316 }
317 
318 /**
319  * @dev Interface of the ERC20 standard as defined in the EIP.
320  */
321 interface IERC20 {
322     /**
323      * @dev Returns the amount of tokens in existence.
324      */
325     function totalSupply() external view returns (uint256);
326 
327     /**
328      * @dev Returns the amount of tokens owned by `account`.
329      */
330     function balanceOf(address account) external view returns (uint256);
331 
332     /**
333      * @dev Moves `amount` tokens from the caller's account to `recipient`.
334      *
335      * Returns a boolean value indicating whether the operation succeeded.
336      *
337      * Emits a {Transfer} event.
338      */
339     function transfer(address recipient, uint256 amount) external returns (bool);
340 
341     /**
342      * @dev Returns the remaining number of tokens that `spender` will be
343      * allowed to spend on behalf of `owner` through {transferFrom}. This is
344      * zero by default.
345      *
346      * This value changes when {approve} or {transferFrom} are called.
347      */
348     function allowance(address owner, address spender) external view returns (uint256);
349 
350     /**
351      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
352      *
353      * Returns a boolean value indicating whether the operation succeeded.
354      *
355      * IMPORTANT: Beware that changing an allowance with this method brings the risk
356      * that someone may use both the old and the new allowance by unfortunate
357      * transaction ordering. One possible solution to mitigate this race
358      * condition is to first reduce the spender's allowance to 0 and set the
359      * desired value afterwards:
360      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
361      *
362      * Emits an {Approval} event.
363      */
364     function approve(address spender, uint256 amount) external returns (bool);
365 
366     /**
367      * @dev Moves `amount` tokens from `sender` to `recipient` using the
368      * allowance mechanism. `amount` is then deducted from the caller's
369      * allowance.
370      *
371      * Returns a boolean value indicating whether the operation succeeded.
372      *
373      * Emits a {Transfer} event.
374      */
375     function transferFrom(
376         address sender,
377         address recipient,
378         uint256 amount
379     ) external returns (bool);
380 
381     /**
382      * @dev Emitted when `value` tokens are moved from one account (`from`) to
383      * another (`to`).
384      *
385      * Note that `value` may be zero.
386      */
387     event Transfer(address indexed from, address indexed to, uint256 value);
388 
389     /**
390      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
391      * a call to {approve}. `value` is the new allowance.
392      */
393     event Approval(address indexed owner, address indexed spender, uint256 value);
394 }
395 
396 /**
397  * @dev Interface for the optional metadata functions from the ERC20 standard.
398  *
399  * _Available since v4.1._
400  */
401 interface IERC20Metadata is IERC20 {
402     /**
403      * @dev Returns the name of the token.
404      */
405     function name() external view returns (string memory);
406 
407     /**
408      * @dev Returns the symbol of the token.
409      */
410     function symbol() external view returns (string memory);
411 
412     /**
413      * @dev Returns the decimals places of the token.
414      */
415     function decimals() external view returns (uint8);
416 }
417 
418 /**
419  * @dev Provides information about the current execution context, including the
420  * sender of the transaction and its data. While these are generally available
421  * via msg.sender and msg.data, they should not be accessed in such a direct
422  * manner, since when dealing with meta-transactions the account sending and
423  * paying for execution may not be the actual sender (as far as an application
424  * is concerned).
425  *
426  * This contract is only required for intermediate, library-like contracts.
427  */
428 abstract contract Context {
429     function _msgSender() internal view virtual returns (address) {
430         return msg.sender;
431     }
432 
433     function _msgData() internal view virtual returns (bytes calldata) {
434         return msg.data;
435     }
436 }
437 
438 /**
439  * @dev Implementation of the {IERC20} interface.
440  *
441  * This implementation is agnostic to the way tokens are created. This means
442  * that a supply mechanism has to be added in a derived contract using {_mint}.
443  * For a generic mechanism see {ERC20PresetMinterPauser}.
444  *
445  * TIP: For a detailed writeup see our guide
446  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
447  * to implement supply mechanisms].
448  *
449  * We have followed general OpenZeppelin Contracts guidelines: functions revert
450  * instead returning `false` on failure. This behavior is nonetheless
451  * conventional and does not conflict with the expectations of ERC20
452  * applications.
453  *
454  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
455  * This allows applications to reconstruct the allowance for all accounts just
456  * by listening to said events. Other implementations of the EIP may not emit
457  * these events, as it isn't required by the specification.
458  *
459  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
460  * functions have been added to mitigate the well-known issues around setting
461  * allowances. See {IERC20-approve}.
462  */
463 contract ERC20 is Context, IERC20, IERC20Metadata {
464     mapping(address => uint256) private _balances;
465 
466     mapping(address => mapping(address => uint256)) private _allowances;
467 
468     uint256 private _totalSupply;
469 
470     string private _name;
471     string private _symbol;
472 
473     /**
474      * @dev Sets the values for {name} and {symbol}.
475      *
476      * The default value of {decimals} is 18. To select a different value for
477      * {decimals} you should overload it.
478      *
479      * All two of these values are immutable: they can only be set once during
480      * construction.
481      */
482     constructor(string memory name_, string memory symbol_) {
483         _name = name_;
484         _symbol = symbol_;
485     }
486 
487     /**
488      * @dev Returns the name of the token.
489      */
490     function name() public view virtual override returns (string memory) {
491         return _name;
492     }
493 
494     /**
495      * @dev Returns the symbol of the token, usually a shorter version of the
496      * name.
497      */
498     function symbol() public view virtual override returns (string memory) {
499         return _symbol;
500     }
501 
502     /**
503      * @dev Returns the number of decimals used to get its user representation.
504      * For example, if `decimals` equals `2`, a balance of `505` tokens should
505      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
506      *
507      * Tokens usually opt for a value of 18, imitating the relationship between
508      * Ether and Wei. This is the value {ERC20} uses, unless this function is
509      * overridden;
510      *
511      * NOTE: This information is only used for _display_ purposes: it in
512      * no way affects any of the arithmetic of the contract, including
513      * {IERC20-balanceOf} and {IERC20-transfer}.
514      */
515     function decimals() public view virtual override returns (uint8) {
516         return 18;
517     }
518 
519     /**
520      * @dev See {IERC20-totalSupply}.
521      */
522     function totalSupply() public view virtual override returns (uint256) {
523         return _totalSupply;
524     }
525 
526     /**
527      * @dev See {IERC20-balanceOf}.
528      */
529     function balanceOf(address account) public view virtual override returns (uint256) {
530         return _balances[account];
531     }
532 
533     /**
534      * @dev See {IERC20-transfer}.
535      *
536      * Requirements:
537      *
538      * - `recipient` cannot be the zero address.
539      * - the caller must have a balance of at least `amount`.
540      */
541     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
542         _transfer(_msgSender(), recipient, amount);
543         return true;
544     }
545 
546     /**
547      * @dev See {IERC20-allowance}.
548      */
549     function allowance(address owner, address spender) public view virtual override returns (uint256) {
550         return _allowances[owner][spender];
551     }
552 
553     /**
554      * @dev See {IERC20-approve}.
555      *
556      * Requirements:
557      *
558      * - `spender` cannot be the zero address.
559      */
560     function approve(address spender, uint256 amount) public virtual override returns (bool) {
561         _approve(_msgSender(), spender, amount);
562         return true;
563     }
564 
565     /**
566      * @dev See {IERC20-transferFrom}.
567      *
568      * Emits an {Approval} event indicating the updated allowance. This is not
569      * required by the EIP. See the note at the beginning of {ERC20}.
570      *
571      * Requirements:
572      *
573      * - `sender` and `recipient` cannot be the zero address.
574      * - `sender` must have a balance of at least `amount`.
575      * - the caller must have allowance for ``sender``'s tokens of at least
576      * `amount`.
577      */
578     function transferFrom(
579         address sender,
580         address recipient,
581         uint256 amount
582     ) public virtual override returns (bool) {
583         _transfer(sender, recipient, amount);
584 
585         uint256 currentAllowance = _allowances[sender][_msgSender()];
586         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
587         unchecked {
588             _approve(sender, _msgSender(), currentAllowance - amount);
589         }
590 
591         return true;
592     }
593 
594     /**
595      * @dev Atomically increases the allowance granted to `spender` by the caller.
596      *
597      * This is an alternative to {approve} that can be used as a mitigation for
598      * problems described in {IERC20-approve}.
599      *
600      * Emits an {Approval} event indicating the updated allowance.
601      *
602      * Requirements:
603      *
604      * - `spender` cannot be the zero address.
605      */
606     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
607         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
608         return true;
609     }
610 
611     /**
612      * @dev Atomically decreases the allowance granted to `spender` by the caller.
613      *
614      * This is an alternative to {approve} that can be used as a mitigation for
615      * problems described in {IERC20-approve}.
616      *
617      * Emits an {Approval} event indicating the updated allowance.
618      *
619      * Requirements:
620      *
621      * - `spender` cannot be the zero address.
622      * - `spender` must have allowance for the caller of at least
623      * `subtractedValue`.
624      */
625     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
626         uint256 currentAllowance = _allowances[_msgSender()][spender];
627         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
628         unchecked {
629             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
630         }
631 
632         return true;
633     }
634 
635     /**
636      * @dev Moves `amount` of tokens from `sender` to `recipient`.
637      *
638      * This internal function is equivalent to {transfer}, and can be used to
639      * e.g. implement automatic token fees, slashing mechanisms, etc.
640      *
641      * Emits a {Transfer} event.
642      *
643      * Requirements:
644      *
645      * - `sender` cannot be the zero address.
646      * - `recipient` cannot be the zero address.
647      * - `sender` must have a balance of at least `amount`.
648      */
649     function _transfer(
650         address sender,
651         address recipient,
652         uint256 amount
653     ) internal virtual {
654         require(sender != address(0), "ERC20: transfer from the zero address");
655         require(recipient != address(0), "ERC20: transfer to the zero address");
656 
657         _beforeTokenTransfer(sender, recipient, amount);
658 
659         uint256 senderBalance = _balances[sender];
660         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
661         unchecked {
662             _balances[sender] = senderBalance - amount;
663         }
664         _balances[recipient] += amount;
665 
666         emit Transfer(sender, recipient, amount);
667 
668         _afterTokenTransfer(sender, recipient, amount);
669     }
670 
671     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
672      * the total supply.
673      *
674      * Emits a {Transfer} event with `from` set to the zero address.
675      *
676      * Requirements:
677      *
678      * - `account` cannot be the zero address.
679      */
680     function _mint(address account, uint256 amount) internal virtual {
681         require(account != address(0), "ERC20: mint to the zero address");
682 
683         _beforeTokenTransfer(address(0), account, amount);
684 
685         _totalSupply += amount;
686         _balances[account] += amount;
687         emit Transfer(address(0), account, amount);
688 
689         _afterTokenTransfer(address(0), account, amount);
690     }
691 
692     /**
693      * @dev Destroys `amount` tokens from `account`, reducing the
694      * total supply.
695      *
696      * Emits a {Transfer} event with `to` set to the zero address.
697      *
698      * Requirements:
699      *
700      * - `account` cannot be the zero address.
701      * - `account` must have at least `amount` tokens.
702      */
703     function _burn(address account, uint256 amount) internal virtual {
704         require(account != address(0), "ERC20: burn from the zero address");
705 
706         _beforeTokenTransfer(account, address(0), amount);
707 
708         uint256 accountBalance = _balances[account];
709         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
710         unchecked {
711             _balances[account] = accountBalance - amount;
712         }
713         _totalSupply -= amount;
714 
715         emit Transfer(account, address(0), amount);
716 
717         _afterTokenTransfer(account, address(0), amount);
718     }
719 
720     /**
721      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
722      *
723      * This internal function is equivalent to `approve`, and can be used to
724      * e.g. set automatic allowances for certain subsystems, etc.
725      *
726      * Emits an {Approval} event.
727      *
728      * Requirements:
729      *
730      * - `owner` cannot be the zero address.
731      * - `spender` cannot be the zero address.
732      */
733     function _approve(
734         address owner,
735         address spender,
736         uint256 amount
737     ) internal virtual {
738         require(owner != address(0), "ERC20: approve from the zero address");
739         require(spender != address(0), "ERC20: approve to the zero address");
740 
741         _allowances[owner][spender] = amount;
742         emit Approval(owner, spender, amount);
743     }
744 
745     /**
746      * @dev Hook that is called before any transfer of tokens. This includes
747      * minting and burning.
748      *
749      * Calling conditions:
750      *
751      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
752      * will be transferred to `to`.
753      * - when `from` is zero, `amount` tokens will be minted for `to`.
754      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
755      * - `from` and `to` are never both zero.
756      *
757      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
758      */
759     function _beforeTokenTransfer(
760         address from,
761         address to,
762         uint256 amount
763     ) internal virtual {}
764 
765     /**
766      * @dev Hook that is called after any transfer of tokens. This includes
767      * minting and burning.
768      *
769      * Calling conditions:
770      *
771      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
772      * has been transferred to `to`.
773      * - when `from` is zero, `amount` tokens have been minted for `to`.
774      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
775      * - `from` and `to` are never both zero.
776      *
777      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
778      */
779     function _afterTokenTransfer(
780         address from,
781         address to,
782         uint256 amount
783     ) internal virtual {}
784 }
785 
786 /**
787  * 
788  * Stakes is an interest gain contract for ERC-20 tokens
789  * 
790  * assets is the ERC20 token
791  * interest_rate: percentage rate
792  * maturity is the time in seconds after which is safe to end the stake
793  * penalization for ending a stake before maturity time
794  * lower_amount is the minimum amount for creating a stake
795  * 
796  */
797 contract Stakes is Owner, ReentrancyGuard {
798 
799     using SafeMath for uint256;
800 
801     // token    
802     ERC20 public asset;
803 
804     // stakes history
805     struct Record {
806         uint256 from;
807         uint256 amount;
808         uint256 gain;
809         uint256 penalization;
810         uint256 to;
811         bool ended;
812     }
813 
814     // contract parameters
815     uint8 public interest_rate;
816     uint256 public maturity;
817     uint8 public penalization;
818     uint256 public lower_amount;
819 
820     mapping(address => Record[]) public ledger;
821 
822     event StakeStart(address indexed user, uint256 value, uint256 index);
823     event StakeEnd(address indexed user, uint256 value, uint256 penalty, uint256 interest, uint256 index);
824     
825     constructor(ERC20 _erc20, address _owner, uint8 _rate, uint256 _maturity, uint8 _penalization, uint256 _lower) Owner(_owner) {
826         require(_penalization<=100, "Penalty has to be an integer between 0 and 100");
827         asset = _erc20;
828         interest_rate = _rate;
829         maturity = _maturity;
830         penalization = _penalization;
831         lower_amount = _lower;
832     }
833     
834     function start(uint256 _value) external {
835         require(_value >= lower_amount, "Invalid value");
836         asset.transferFrom(msg.sender, address(this), _value);
837         ledger[msg.sender].push(Record(block.timestamp, _value, 0, 0, 0, false));
838         emit StakeStart(msg.sender, _value, ledger[msg.sender].length-1);
839     }
840 
841     function end(uint256 i) external nonReentrant {
842 
843         require(i < ledger[msg.sender].length, "Invalid index");
844         require(ledger[msg.sender][i].ended==false, "Invalid stake");
845         
846         // penalization
847         if(block.timestamp.sub(ledger[msg.sender][i].from) < maturity) {
848             uint256 _penalization = ledger[msg.sender][i].amount.mul(penalization).div(100);
849             asset.transfer(msg.sender, ledger[msg.sender][i].amount.sub(_penalization));
850             asset.transfer(getOwner(), _penalization);
851             ledger[msg.sender][i].penalization = _penalization;
852             ledger[msg.sender][i].to = block.timestamp;
853             ledger[msg.sender][i].ended = true;
854             emit StakeEnd(msg.sender, ledger[msg.sender][i].amount, _penalization, 0, i);
855         // interest gained
856         } else {
857             uint256 _interest = get_gains(msg.sender, i);
858             // check that the owner can pay interest before trying to pay
859             if (asset.allowance(getOwner(), address(this)) >= _interest && asset.balanceOf(getOwner()) >= _interest) {
860                 asset.transferFrom(getOwner(), msg.sender, _interest);
861             } else {
862                 _interest = 0;
863             }
864             asset.transfer(msg.sender, ledger[msg.sender][i].amount);
865             ledger[msg.sender][i].gain = _interest;
866             ledger[msg.sender][i].to = block.timestamp;
867             ledger[msg.sender][i].ended = true;
868             emit StakeEnd(msg.sender, ledger[msg.sender][i].amount, 0, _interest, i);
869         }
870     }
871 
872     function set(uint256 _lower, uint256 _maturity, uint8 _rate, uint8 _penalization) public isOwner {
873         require(_penalization<=100, "Invalid value");
874         lower_amount = _lower;
875         maturity = _maturity;
876         interest_rate = _rate;
877         penalization = _penalization;
878     }
879     
880     // calculate interest to the current date time
881     function get_gains(address _address, uint256 _rec_number) public view returns (uint256) {
882         uint256 _record_seconds = block.timestamp.sub(ledger[_address][_rec_number].from);
883         uint256 _year_seconds = 365*24*60*60;
884         return _record_seconds.mul(
885             ledger[_address][_rec_number].amount.mul(interest_rate).div(100)
886         ).div(_year_seconds);
887     }
888 
889     function ledger_length(address _address) public view returns (uint256) {
890         return ledger[_address].length;
891     }
892 
893 }