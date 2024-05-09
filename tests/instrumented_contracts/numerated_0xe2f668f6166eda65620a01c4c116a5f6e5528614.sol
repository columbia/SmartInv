1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
28 
29 
30 
31 pragma solidity ^0.8.0;
32 
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * By default, the owner account will be the one that deploys the contract. This
40  * can later be changed with {transferOwnership}.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 abstract contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor() {
55         _transferOwnership(_msgSender());
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view virtual returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(owner() == _msgSender(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     /**
74      * @dev Leaves the contract without owner. It will not be possible to call
75      * `onlyOwner` functions anymore. Can only be called by the current owner.
76      *
77      * NOTE: Renouncing ownership will leave the contract without an owner,
78      * thereby removing any functionality that is only available to the owner.
79      */
80     function renounceOwnership() public virtual onlyOwner {
81         _transferOwnership(address(0));
82     }
83 
84     /**
85      * @dev Transfers ownership of the contract to a new account (`newOwner`).
86      * Can only be called by the current owner.
87      */
88     function transferOwnership(address newOwner) public virtual onlyOwner {
89         require(newOwner != address(0), "Ownable: new owner is the zero address");
90         _transferOwnership(newOwner);
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Internal function without access restriction.
96      */
97     function _transferOwnership(address newOwner) internal virtual {
98         address oldOwner = _owner;
99         _owner = newOwner;
100         emit OwnershipTransferred(oldOwner, newOwner);
101     }
102 }
103 
104 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
105 
106 
107 
108 pragma solidity ^0.8.0;
109 
110 /**
111  * @dev Interface of the ERC20 standard as defined in the EIP.
112  */
113 interface IERC20 {
114     /**
115      * @dev Returns the amount of tokens in existence.
116      */
117     function totalSupply() external view returns (uint256);
118 
119     /**
120      * @dev Returns the amount of tokens owned by `account`.
121      */
122     function balanceOf(address account) external view returns (uint256);
123 
124     /**
125      * @dev Moves `amount` tokens from the caller's account to `recipient`.
126      *
127      * Returns a boolean value indicating whether the operation succeeded.
128      *
129      * Emits a {Transfer} event.
130      */
131     function transfer(address recipient, uint256 amount) external returns (bool);
132 
133     /**
134      * @dev Returns the remaining number of tokens that `spender` will be
135      * allowed to spend on behalf of `owner` through {transferFrom}. This is
136      * zero by default.
137      *
138      * This value changes when {approve} or {transferFrom} are called.
139      */
140     function allowance(address owner, address spender) external view returns (uint256);
141 
142     /**
143      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
144      *
145      * Returns a boolean value indicating whether the operation succeeded.
146      *
147      * IMPORTANT: Beware that changing an allowance with this method brings the risk
148      * that someone may use both the old and the new allowance by unfortunate
149      * transaction ordering. One possible solution to mitigate this race
150      * condition is to first reduce the spender's allowance to 0 and set the
151      * desired value afterwards:
152      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153      *
154      * Emits an {Approval} event.
155      */
156     function approve(address spender, uint256 amount) external returns (bool);
157 
158     /**
159      * @dev Moves `amount` tokens from `sender` to `recipient` using the
160      * allowance mechanism. `amount` is then deducted from the caller's
161      * allowance.
162      *
163      * Returns a boolean value indicating whether the operation succeeded.
164      *
165      * Emits a {Transfer} event.
166      */
167     function transferFrom(
168         address sender,
169         address recipient,
170         uint256 amount
171     ) external returns (bool);
172 
173     /**
174      * @dev Emitted when `value` tokens are moved from one account (`from`) to
175      * another (`to`).
176      *
177      * Note that `value` may be zero.
178      */
179     event Transfer(address indexed from, address indexed to, uint256 value);
180 
181     /**
182      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
183      * a call to {approve}. `value` is the new allowance.
184      */
185     event Approval(address indexed owner, address indexed spender, uint256 value);
186 }
187 
188 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/IERC20Metadata.sol
189 
190 
191 
192 pragma solidity ^0.8.0;
193 
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
217 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol
218 
219 
220 
221 pragma solidity ^0.8.0;
222 
223 
224 
225 
226 /**
227  * @dev Implementation of the {IERC20} interface.
228  *
229  * This implementation is agnostic to the way tokens are created. This means
230  * that a supply mechanism has to be added in a derived contract using {_mint}.
231  * For a generic mechanism see {ERC20PresetMinterPauser}.
232  *
233  * TIP: For a detailed writeup see our guide
234  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
235  * to implement supply mechanisms].
236  *
237  * We have followed general OpenZeppelin Contracts guidelines: functions revert
238  * instead returning `false` on failure. This behavior is nonetheless
239  * conventional and does not conflict with the expectations of ERC20
240  * applications.
241  *
242  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
243  * This allows applications to reconstruct the allowance for all accounts just
244  * by listening to said events. Other implementations of the EIP may not emit
245  * these events, as it isn't required by the specification.
246  *
247  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
248  * functions have been added to mitigate the well-known issues around setting
249  * allowances. See {IERC20-approve}.
250  */
251 contract ERC20 is Context, IERC20, IERC20Metadata {
252     mapping(address => uint256) private _balances;
253 
254     mapping(address => mapping(address => uint256)) private _allowances;
255 
256     uint256 private _totalSupply;
257 
258     string private _name;
259     string private _symbol;
260 
261     /**
262      * @dev Sets the values for {name} and {symbol}.
263      *
264      * The default value of {decimals} is 18. To select a different value for
265      * {decimals} you should overload it.
266      *
267      * All two of these values are immutable: they can only be set once during
268      * construction.
269      */
270     constructor(string memory name_, string memory symbol_) {
271         _name = name_;
272         _symbol = symbol_;
273     }
274 
275     /**
276      * @dev Returns the name of the token.
277      */
278     function name() public view virtual override returns (string memory) {
279         return _name;
280     }
281 
282     /**
283      * @dev Returns the symbol of the token, usually a shorter version of the
284      * name.
285      */
286     function symbol() public view virtual override returns (string memory) {
287         return _symbol;
288     }
289 
290     /**
291      * @dev Returns the number of decimals used to get its user representation.
292      * For example, if `decimals` equals `2`, a balance of `505` tokens should
293      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
294      *
295      * Tokens usually opt for a value of 18, imitating the relationship between
296      * Ether and Wei. This is the value {ERC20} uses, unless this function is
297      * overridden;
298      *
299      * NOTE: This information is only used for _display_ purposes: it in
300      * no way affects any of the arithmetic of the contract, including
301      * {IERC20-balanceOf} and {IERC20-transfer}.
302      */
303     function decimals() public view virtual override returns (uint8) {
304         return 18;
305     }
306 
307     /**
308      * @dev See {IERC20-totalSupply}.
309      */
310     function totalSupply() public view virtual override returns (uint256) {
311         return _totalSupply;
312     }
313 
314     /**
315      * @dev See {IERC20-balanceOf}.
316      */
317     function balanceOf(address account) public view virtual override returns (uint256) {
318         return _balances[account];
319     }
320 
321     /**
322      * @dev See {IERC20-transfer}.
323      *
324      * Requirements:
325      *
326      * - `recipient` cannot be the zero address.
327      * - the caller must have a balance of at least `amount`.
328      */
329     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
330         _transfer(_msgSender(), recipient, amount);
331         return true;
332     }
333 
334     /**
335      * @dev See {IERC20-allowance}.
336      */
337     function allowance(address owner, address spender) public view virtual override returns (uint256) {
338         return _allowances[owner][spender];
339     }
340 
341     /**
342      * @dev See {IERC20-approve}.
343      *
344      * Requirements:
345      *
346      * - `spender` cannot be the zero address.
347      */
348     function approve(address spender, uint256 amount) public virtual override returns (bool) {
349         _approve(_msgSender(), spender, amount);
350         return true;
351     }
352 
353     /**
354      * @dev See {IERC20-transferFrom}.
355      *
356      * Emits an {Approval} event indicating the updated allowance. This is not
357      * required by the EIP. See the note at the beginning of {ERC20}.
358      *
359      * Requirements:
360      *
361      * - `sender` and `recipient` cannot be the zero address.
362      * - `sender` must have a balance of at least `amount`.
363      * - the caller must have allowance for ``sender``'s tokens of at least
364      * `amount`.
365      */
366     function transferFrom(
367         address sender,
368         address recipient,
369         uint256 amount
370     ) public virtual override returns (bool) {
371         _transfer(sender, recipient, amount);
372 
373         uint256 currentAllowance = _allowances[sender][_msgSender()];
374         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
375         unchecked {
376             _approve(sender, _msgSender(), currentAllowance - amount);
377         }
378 
379         return true;
380     }
381 
382     /**
383      * @dev Atomically increases the allowance granted to `spender` by the caller.
384      *
385      * This is an alternative to {approve} that can be used as a mitigation for
386      * problems described in {IERC20-approve}.
387      *
388      * Emits an {Approval} event indicating the updated allowance.
389      *
390      * Requirements:
391      *
392      * - `spender` cannot be the zero address.
393      */
394     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
395         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
396         return true;
397     }
398 
399     /**
400      * @dev Atomically decreases the allowance granted to `spender` by the caller.
401      *
402      * This is an alternative to {approve} that can be used as a mitigation for
403      * problems described in {IERC20-approve}.
404      *
405      * Emits an {Approval} event indicating the updated allowance.
406      *
407      * Requirements:
408      *
409      * - `spender` cannot be the zero address.
410      * - `spender` must have allowance for the caller of at least
411      * `subtractedValue`.
412      */
413     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
414         uint256 currentAllowance = _allowances[_msgSender()][spender];
415         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
416         unchecked {
417             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
418         }
419 
420         return true;
421     }
422 
423     /**
424      * @dev Moves `amount` of tokens from `sender` to `recipient`.
425      *
426      * This internal function is equivalent to {transfer}, and can be used to
427      * e.g. implement automatic token fees, slashing mechanisms, etc.
428      *
429      * Emits a {Transfer} event.
430      *
431      * Requirements:
432      *
433      * - `sender` cannot be the zero address.
434      * - `recipient` cannot be the zero address.
435      * - `sender` must have a balance of at least `amount`.
436      */
437     function _transfer(
438         address sender,
439         address recipient,
440         uint256 amount
441     ) internal virtual {
442         require(sender != address(0), "ERC20: transfer from the zero address");
443         require(recipient != address(0), "ERC20: transfer to the zero address");
444 
445         _beforeTokenTransfer(sender, recipient, amount);
446 
447         uint256 senderBalance = _balances[sender];
448         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
449         unchecked {
450             _balances[sender] = senderBalance - amount;
451         }
452         _balances[recipient] += amount;
453 
454         emit Transfer(sender, recipient, amount);
455 
456         _afterTokenTransfer(sender, recipient, amount);
457     }
458 
459     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
460      * the total supply.
461      *
462      * Emits a {Transfer} event with `from` set to the zero address.
463      *
464      * Requirements:
465      *
466      * - `account` cannot be the zero address.
467      */
468     function _mint(address account, uint256 amount) internal virtual {
469         require(account != address(0), "ERC20: mint to the zero address");
470 
471         _beforeTokenTransfer(address(0), account, amount);
472 
473         _totalSupply += amount;
474         _balances[account] += amount;
475         emit Transfer(address(0), account, amount);
476 
477         _afterTokenTransfer(address(0), account, amount);
478     }
479 
480     /**
481      * @dev Destroys `amount` tokens from `account`, reducing the
482      * total supply.
483      *
484      * Emits a {Transfer} event with `to` set to the zero address.
485      *
486      * Requirements:
487      *
488      * - `account` cannot be the zero address.
489      * - `account` must have at least `amount` tokens.
490      */
491     function _burn(address account, uint256 amount) internal virtual {
492         require(account != address(0), "ERC20: burn from the zero address");
493 
494         _beforeTokenTransfer(account, address(0), amount);
495 
496         uint256 accountBalance = _balances[account];
497         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
498         unchecked {
499             _balances[account] = accountBalance - amount;
500         }
501         _totalSupply -= amount;
502 
503         emit Transfer(account, address(0), amount);
504 
505         _afterTokenTransfer(account, address(0), amount);
506     }
507 
508     /**
509      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
510      *
511      * This internal function is equivalent to `approve`, and can be used to
512      * e.g. set automatic allowances for certain subsystems, etc.
513      *
514      * Emits an {Approval} event.
515      *
516      * Requirements:
517      *
518      * - `owner` cannot be the zero address.
519      * - `spender` cannot be the zero address.
520      */
521     function _approve(
522         address owner,
523         address spender,
524         uint256 amount
525     ) internal virtual {
526         require(owner != address(0), "ERC20: approve from the zero address");
527         require(spender != address(0), "ERC20: approve to the zero address");
528 
529         _allowances[owner][spender] = amount;
530         emit Approval(owner, spender, amount);
531     }
532 
533     /**
534      * @dev Hook that is called before any transfer of tokens. This includes
535      * minting and burning.
536      *
537      * Calling conditions:
538      *
539      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
540      * will be transferred to `to`.
541      * - when `from` is zero, `amount` tokens will be minted for `to`.
542      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
543      * - `from` and `to` are never both zero.
544      *
545      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
546      */
547     function _beforeTokenTransfer(
548         address from,
549         address to,
550         uint256 amount
551     ) internal virtual {}
552 
553     /**
554      * @dev Hook that is called after any transfer of tokens. This includes
555      * minting and burning.
556      *
557      * Calling conditions:
558      *
559      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
560      * has been transferred to `to`.
561      * - when `from` is zero, `amount` tokens have been minted for `to`.
562      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
563      * - `from` and `to` are never both zero.
564      *
565      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
566      */
567     function _afterTokenTransfer(
568         address from,
569         address to,
570         uint256 amount
571     ) internal virtual {}
572 }
573 
574 // File: megustastoken.sol
575 
576 
577 
578 
579 contract MeGusta is Ownable, ERC20 {
580     bool public limited;
581     uint256 public maxHoldingAmount;
582     uint256 public minHoldingAmount;
583     address public uniswapV2Pair;
584     mapping(address => bool) public blacklists;
585     mapping(address => bool) public whitelists;
586 
587     constructor(uint256 _totalSupply) ERC20("Me Gusta", "GUSTA") {
588         _mint(msg.sender, _totalSupply);
589     }
590 
591     function blacklist(address[] calldata _addresses, bool _isBlacklisting) external onlyOwner {
592         for (uint i; i < _addresses.length; i++) {
593             blacklists[_addresses[i]] = _isBlacklisting;
594         }
595     }
596 
597     function whitelist(address[] calldata _addresses, bool _isWhitelisting) external onlyOwner {
598         for (uint i; i < _addresses.length; i++) {
599             whitelists[_addresses[i]] = _isWhitelisting;
600         }
601     }
602 
603     function setRule(bool _limited, address _uniswapV2Pair, uint256 _maxHoldingAmount, uint256 _minHoldingAmount) external onlyOwner {
604         limited = _limited;
605         uniswapV2Pair = _uniswapV2Pair;
606         maxHoldingAmount = _maxHoldingAmount;
607         minHoldingAmount = _minHoldingAmount;
608     }
609 
610     function _beforeTokenTransfer(
611         address from,
612         address to,
613         uint256 amount
614     ) override internal virtual {
615         require(!blacklists[to] && !blacklists[from], "Blacklisted");
616 
617         if (uniswapV2Pair == address(0)) {
618             require(from == owner() || to == owner(), "trading is not started");
619             return;
620         }
621 
622         if (!whitelists[from] && !whitelists[to]) {
623             if (limited && from == uniswapV2Pair) {
624                 require(super.balanceOf(to) + amount <= maxHoldingAmount && super.balanceOf(to) + amount >= minHoldingAmount, "Forbid");
625             }
626         }
627     }
628 
629     function burn(uint256 value) external {
630         _burn(msg.sender, value);
631     }
632 }