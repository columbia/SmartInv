1 pragma solidity ^0.8.18;
2 
3 /**
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  */
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes calldata) {
19         return msg.data;
20     }
21 }
22 
23 
24 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.0
25 
26 
27 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
28 
29 pragma solidity ^0.8.0;
30 
31 /**
32  * @dev Contract module which provides a basic access control mechanism, where
33  * there is an account (an owner) that can be granted exclusive access to
34  * specific functions.
35  *
36  * By default, the owner account will be the one that deploys the contract. This
37  * can later be changed with {transferOwnership}.
38  *
39  * This module is used through inheritance. It will make available the modifier
40  * `onlyOwner`, which can be applied to your functions to restrict their use to
41  * the owner.
42  */
43 abstract contract Ownable is Context {
44     address private _owner;
45 
46     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48     /**
49      * @dev Initializes the contract setting the deployer as the initial owner.
50      */
51     constructor() {
52         _transferOwnership(_msgSender());
53     }
54 
55     /**
56      * @dev Returns the address of the current owner.
57      */
58     function owner() public view virtual returns (address) {
59         return _owner;
60     }
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      */
65     modifier onlyOwner() {
66         require(owner() == _msgSender(), "Ownable: caller is not the owner");
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
77     function renounceOwnership() public virtual onlyOwner {
78         _transferOwnership(address(0));
79     }
80 
81     /**
82      * @dev Transfers ownership of the contract to a new account (`newOwner`).
83      * Can only be called by the current owner.
84      */
85     function transferOwnership(address newOwner) public virtual onlyOwner {
86         require(newOwner != address(0), "Ownable: new owner is the zero address");
87         _transferOwnership(newOwner);
88     }
89 
90     /**
91      * @dev Transfers ownership of the contract to a new account (`newOwner`).
92      * Internal function without access restriction.
93      */
94     function _transferOwnership(address newOwner) internal virtual {
95         address oldOwner = _owner;
96         _owner = newOwner;
97         emit OwnershipTransferred(oldOwner, newOwner);
98     }
99 }
100 
101 
102 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.4.0
103 
104 
105 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
106 
107 pragma solidity ^0.8.0;
108 
109 /**
110  * @dev Interface of the ERC20 standard as defined in the EIP.
111  */
112 interface IERC20 {
113     /**
114      * @dev Returns the amount of tokens in existence.
115      */
116     function totalSupply() external view returns (uint256);
117 
118     /**
119      * @dev Returns the amount of tokens owned by `account`.
120      */
121     function balanceOf(address account) external view returns (uint256);
122 
123     /**
124      * @dev Moves `amount` tokens from the caller's account to `recipient`.
125      *
126      * Returns a boolean value indicating whether the operation succeeded.
127      *
128      * Emits a {Transfer} event.
129      */
130     function transfer(address recipient, uint256 amount) external returns (bool);
131 
132     /**
133      * @dev Returns the remaining number of tokens that `spender` will be
134      * allowed to spend on behalf of `owner` through {transferFrom}. This is
135      * zero by default.
136      *
137      * This value changes when {approve} or {transferFrom} are called.
138      */
139     function allowance(address owner, address spender) external view returns (uint256);
140 
141     /**
142      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
143      *
144      * Returns a boolean value indicating whether the operation succeeded.
145      *
146      * IMPORTANT: Beware that changing an allowance with this method brings the risk
147      * that someone may use both the old and the new allowance by unfortunate
148      * transaction ordering. One possible solution to mitigate this race
149      * condition is to first reduce the spender's allowance to 0 and set the
150      * desired value afterwards:
151      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
152      *
153      * Emits an {Approval} event.
154      */
155     function approve(address spender, uint256 amount) external returns (bool);
156 
157     /**
158      * @dev Moves `amount` tokens from `sender` to `recipient` using the
159      * allowance mechanism. `amount` is then deducted from the caller's
160      * allowance.
161      *
162      * Returns a boolean value indicating whether the operation succeeded.
163      *
164      * Emits a {Transfer} event.
165      */
166     function transferFrom(
167         address sender,
168         address recipient,
169         uint256 amount
170     ) external returns (bool);
171 
172     /**
173      * @dev Emitted when `value` tokens are moved from one account (`from`) to
174      * another (`to`).
175      *
176      * Note that `value` may be zero.
177      */
178     event Transfer(address indexed from, address indexed to, uint256 value);
179 
180     /**
181      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
182      * a call to {approve}. `value` is the new allowance.
183      */
184     event Approval(address indexed owner, address indexed spender, uint256 value);
185 }
186 
187 
188 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.4.0
189 
190 
191 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
192 
193 pragma solidity ^0.8.0;
194 
195 /**
196  * @dev Interface for the optional metadata functions from the ERC20 standard.
197  *
198  * _Available since v4.1._
199  */
200 interface IERC20Metadata is IERC20 {
201     /**
202      * @dev Returns the name of the token.
203      */
204     function name() external view returns (string memory);
205 
206     /**
207      * @dev Returns the symbol of the token.
208      */
209     function symbol() external view returns (string memory);
210 
211     /**
212      * @dev Returns the decimals places of the token.
213      */
214     function decimals() external view returns (uint8);
215 }
216 
217 
218 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.4.0
219 
220 
221 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
222 
223 pragma solidity ^0.8.0;
224 
225 
226 
227 /**
228  * @dev Implementation of the {IERC20} interface.
229  *
230  * This implementation is agnostic to the way tokens are created. This means
231  * that a supply mechanism has to be added in a derived contract using {_mint}.
232  * For a generic mechanism see {ERC20PresetMinterPauser}.
233  *
234  * TIP: For a detailed writeup see our guide
235  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
236  * to implement supply mechanisms].
237  *
238  * We have followed general OpenZeppelin Contracts guidelines: functions revert
239  * instead returning `false` on failure. This behavior is nonetheless
240  * conventional and does not conflict with the expectations of ERC20
241  * applications.
242  *
243  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
244  * This allows applications to reconstruct the allowance for all accounts just
245  * by listening to said events. Other implementations of the EIP may not emit
246  * these events, as it isn't required by the specification.
247  *
248  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
249  * functions have been added to mitigate the well-known issues around setting
250  * allowances. See {IERC20-approve}.
251  */
252 contract ERC20 is Context, IERC20, IERC20Metadata {
253     mapping(address => uint256) private _balances;
254 
255     mapping(address => mapping(address => uint256)) private _allowances;
256 
257     uint256 private _totalSupply;
258 
259     string private _name;
260     string private _symbol;
261 
262     /**
263      * @dev Sets the values for {name} and {symbol}.
264      *
265      * The default value of {decimals} is 18. To select a different value for
266      * {decimals} you should overload it.
267      *
268      * All two of these values are immutable: they can only be set once during
269      * construction.
270      */
271     constructor(string memory name_, string memory symbol_) {
272         _name = name_;
273         _symbol = symbol_;
274     }
275 
276     /**
277      * @dev Returns the name of the token.
278      */
279     function name() public view virtual override returns (string memory) {
280         return _name;
281     }
282 
283     /**
284      * @dev Returns the symbol of the token, usually a shorter version of the
285      * name.
286      */
287     function symbol() public view virtual override returns (string memory) {
288         return _symbol;
289     }
290 
291     /**
292      * @dev Returns the number of decimals used to get its user representation.
293      * For example, if `decimals` equals `2`, a balance of `505` tokens should
294      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
295      *
296      * Tokens usually opt for a value of 18, imitating the relationship between
297      * Ether and Wei. This is the value {ERC20} uses, unless this function is
298      * overridden;
299      *
300      * NOTE: This information is only used for _display_ purposes: it in
301      * no way affects any of the arithmetic of the contract, including
302      * {IERC20-balanceOf} and {IERC20-transfer}.
303      */
304     function decimals() public view virtual override returns (uint8) {
305         return 18;
306     }
307 
308     /**
309      * @dev See {IERC20-totalSupply}.
310      */
311     function totalSupply() public view virtual override returns (uint256) {
312         return _totalSupply;
313     }
314 
315     /**
316      * @dev See {IERC20-balanceOf}.
317      */
318     function balanceOf(address account) public view virtual override returns (uint256) {
319         return _balances[account];
320     }
321 
322     /**
323      * @dev See {IERC20-transfer}.
324      *
325      * Requirements:
326      *
327      * - `recipient` cannot be the zero address.
328      * - the caller must have a balance of at least `amount`.
329      */
330     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
331         _transfer(_msgSender(), recipient, amount);
332         return true;
333     }
334 
335     /**
336      * @dev See {IERC20-allowance}.
337      */
338     function allowance(address owner, address spender) public view virtual override returns (uint256) {
339         return _allowances[owner][spender];
340     }
341 
342     /**
343      * @dev See {IERC20-approve}.
344      *
345      * Requirements:
346      *
347      * - `spender` cannot be the zero address.
348      */
349     function approve(address spender, uint256 amount) public virtual override returns (bool) {
350         _approve(_msgSender(), spender, amount);
351         return true;
352     }
353 
354     /**
355      * @dev See {IERC20-transferFrom}.
356      *
357      * Emits an {Approval} event indicating the updated allowance. This is not
358      * required by the EIP. See the note at the beginning of {ERC20}.
359      *
360      * Requirements:
361      *
362      * - `sender` and `recipient` cannot be the zero address.
363      * - `sender` must have a balance of at least `amount`.
364      * - the caller must have allowance for ``sender``'s tokens of at least
365      * `amount`.
366      */
367     function transferFrom(
368         address sender,
369         address recipient,
370         uint256 amount
371     ) public virtual override returns (bool) {
372         _transfer(sender, recipient, amount);
373 
374         uint256 currentAllowance = _allowances[sender][_msgSender()];
375         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
376         unchecked {
377             _approve(sender, _msgSender(), currentAllowance - amount);
378         }
379 
380         return true;
381     }
382 
383     /**
384      * @dev Atomically increases the allowance granted to `spender` by the caller.
385      *
386      * This is an alternative to {approve} that can be used as a mitigation for
387      * problems described in {IERC20-approve}.
388      *
389      * Emits an {Approval} event indicating the updated allowance.
390      *
391      * Requirements:
392      *
393      * - `spender` cannot be the zero address.
394      */
395     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
396         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
397         return true;
398     }
399 
400     /**
401      * @dev Atomically decreases the allowance granted to `spender` by the caller.
402      *
403      * This is an alternative to {approve} that can be used as a mitigation for
404      * problems described in {IERC20-approve}.
405      *
406      * Emits an {Approval} event indicating the updated allowance.
407      *
408      * Requirements:
409      *
410      * - `spender` cannot be the zero address.
411      * - `spender` must have allowance for the caller of at least
412      * `subtractedValue`.
413      */
414     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
415         uint256 currentAllowance = _allowances[_msgSender()][spender];
416         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
417         unchecked {
418             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
419         }
420 
421         return true;
422     }
423 
424     /**
425      * @dev Moves `amount` of tokens from `sender` to `recipient`.
426      *
427      * This internal function is equivalent to {transfer}, and can be used to
428      * e.g. implement automatic token fees, slashing mechanisms, etc.
429      *
430      * Emits a {Transfer} event.
431      *
432      * Requirements:
433      *
434      * - `sender` cannot be the zero address.
435      * - `recipient` cannot be the zero address.
436      * - `sender` must have a balance of at least `amount`.
437      */
438     function _transfer(
439         address sender,
440         address recipient,
441         uint256 amount
442     ) internal virtual {
443         require(sender != address(0), "ERC20: transfer from the zero address");
444         require(recipient != address(0), "ERC20: transfer to the zero address");
445 
446         _beforeTokenTransfer(sender, recipient, amount);
447 
448         uint256 senderBalance = _balances[sender];
449         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
450         unchecked {
451             _balances[sender] = senderBalance - amount;
452         }
453         _balances[recipient] += amount;
454 
455         emit Transfer(sender, recipient, amount);
456 
457         _afterTokenTransfer(sender, recipient, amount);
458     }
459 
460     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
461      * the total supply.
462      *
463      * Emits a {Transfer} event with `from` set to the zero address.
464      *
465      * Requirements:
466      *
467      * - `account` cannot be the zero address.
468      */
469     function _mint(address account, uint256 amount) internal virtual {
470         require(account != address(0), "ERC20: mint to the zero address");
471 
472         _beforeTokenTransfer(address(0), account, amount);
473 
474         _totalSupply += amount;
475         _balances[account] += amount;
476         emit Transfer(address(0), account, amount);
477 
478         _afterTokenTransfer(address(0), account, amount);
479     }
480 
481     /**
482      * @dev Destroys `amount` tokens from `account`, reducing the
483      * total supply.
484      *
485      * Emits a {Transfer} event with `to` set to the zero address.
486      *
487      * Requirements:
488      *
489      * - `account` cannot be the zero address.
490      * - `account` must have at least `amount` tokens.
491      */
492     function _burn(address account, uint256 amount) internal virtual {
493         require(account != address(0), "ERC20: burn from the zero address");
494 
495         _beforeTokenTransfer(account, address(0), amount);
496 
497         uint256 accountBalance = _balances[account];
498         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
499         unchecked {
500             _balances[account] = accountBalance - amount;
501         }
502         _totalSupply -= amount;
503 
504         emit Transfer(account, address(0), amount);
505 
506         _afterTokenTransfer(account, address(0), amount);
507     }
508 
509     /**
510      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
511      *
512      * This internal function is equivalent to `approve`, and can be used to
513      * e.g. set automatic allowances for certain subsystems, etc.
514      *
515      * Emits an {Approval} event.
516      *
517      * Requirements:
518      *
519      * - `owner` cannot be the zero address.
520      * - `spender` cannot be the zero address.
521      */
522     function _approve(
523         address owner,
524         address spender,
525         uint256 amount
526     ) internal virtual {
527         require(owner != address(0), "ERC20: approve from the zero address");
528         require(spender != address(0), "ERC20: approve to the zero address");
529 
530         _allowances[owner][spender] = amount;
531         emit Approval(owner, spender, amount);
532     }
533 
534     /**
535      * @dev Hook that is called before any transfer of tokens. This includes
536      * minting and burning.
537      *
538      * Calling conditions:
539      *
540      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
541      * will be transferred to `to`.
542      * - when `from` is zero, `amount` tokens will be minted for `to`.
543      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
544      * - `from` and `to` are never both zero.
545      *
546      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
547      */
548     function _beforeTokenTransfer(
549         address from,
550         address to,
551         uint256 amount
552     ) internal virtual {}
553 
554     /**
555      * @dev Hook that is called after any transfer of tokens. This includes
556      * minting and burning.
557      *
558      * Calling conditions:
559      *
560      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
561      * has been transferred to `to`.
562      * - when `from` is zero, `amount` tokens have been minted for `to`.
563      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
564      * - `from` and `to` are never both zero.
565      *
566      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
567      */
568     function _afterTokenTransfer(
569         address from,
570         address to,
571         uint256 amount
572     ) internal virtual {}
573 }
574 
575 
576 // File contracts/wtp.sol
577 
578 
579 
580 pragma solidity ^0.8.0;
581 
582 
583 contract WeThePepe is Ownable, ERC20 {
584     bool public limited;
585     uint256 public maxHoldingAmount;
586     uint256 public minHoldingAmount;
587     address public uniswapV2Pair;
588     mapping(address => bool) public blacklists;
589 
590     constructor(uint256 _totalSupply) ERC20("We The Pepe", "WTP") {
591         _mint(msg.sender, _totalSupply);
592     }
593 
594     function blacklist(address _address, bool _isBlacklisting) external onlyOwner {
595         blacklists[_address] = _isBlacklisting;
596     }
597 
598     function setRule(bool _limited, address _uniswapV2Pair, uint256 _maxHoldingAmount, uint256 _minHoldingAmount) external onlyOwner {
599         limited = _limited;
600         uniswapV2Pair = _uniswapV2Pair;
601         maxHoldingAmount = _maxHoldingAmount;
602         minHoldingAmount = _minHoldingAmount;
603     }
604 
605     function _beforeTokenTransfer(
606         address from,
607         address to,
608         uint256 amount
609     ) override internal virtual {
610         require(!blacklists[to] && !blacklists[from], "Blacklisted");
611 
612         if (uniswapV2Pair == address(0)) {
613             require(from == owner() || to == owner(), "trading is not started");
614             return;
615         }
616 
617         if (limited && from == uniswapV2Pair) {
618             require(super.balanceOf(to) + amount <= maxHoldingAmount && super.balanceOf(to) + amount >= minHoldingAmount, "Forbid");
619         }
620     }
621 
622     function burn(uint256 value) external {
623         _burn(msg.sender, value);
624     }
625 }