1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 
26 pragma solidity ^0.8.0;
27 
28 /**
29  * @dev Contract module which provides a basic access control mechanism, where
30  * there is an account (an owner) that can be granted exclusive access to
31  * specific functions.
32  *
33  * By default, the owner account will be the one that deploys the contract. This
34  * can later be changed with {transferOwnership}.
35  *
36  * This module is used through inheritance. It will make available the modifier
37  * `onlyOwner`, which can be applied to your functions to restrict their use to
38  * the owner.
39  */
40 
41 abstract contract Ownable is Context {
42     address private _owner;
43 
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46     /**
47      * @dev Initializes the contract setting the deployer as the initial owner.
48      */
49     constructor() {
50         _transferOwnership(_msgSender());
51     }
52 
53     /**
54      * @dev Returns the address of the current owner.
55      */
56     function owner() public view virtual returns (address) {
57         return _owner;
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         require(owner() == _msgSender(), "Ownable: caller is not the owner");
65         _;
66     }
67 
68     /**
69      * @dev Leaves the contract without owner. It will not be possible to call
70      * `onlyOwner` functions anymore. Can only be called by the current owner.
71      *
72      * NOTE: Renouncing ownership will leave the contract without an owner,
73      * thereby removing any functionality that is only available to the owner.
74      */
75 
76     function renounceOwnership() public virtual onlyOwner {
77         _transferOwnership(address(0));
78     }
79 
80     /**
81      * @dev Transfers ownership of the contract to a new account (`newOwner`).
82      * Can only be called by the current owner.
83      */
84 
85     function transferOwnership(address newOwner) public virtual onlyOwner {
86         require(newOwner != address(0), "Ownable: new owner is the zero address");
87         _transferOwnership(newOwner);
88     }
89 
90     /**
91      * @dev Transfers ownership of the contract to a new account (`newOwner`).
92      * Internal function without access restriction.
93      */
94 
95     function _transferOwnership(address newOwner) internal virtual {
96         address oldOwner = _owner;
97         _owner = newOwner;
98         emit OwnershipTransferred(oldOwner, newOwner);
99     }
100 }
101 
102 pragma solidity ^0.8.0;
103 
104 /**
105  * @dev Interface of the ERC20 standard as defined in the EIP.
106  */
107 interface IERC20 {
108     /**
109      * @dev Returns the amount of tokens in existence.
110      */
111     function totalSupply() external view returns (uint256);
112 
113     /**
114      * @dev Returns the amount of tokens owned by `account`.
115      */
116     function balanceOf(address account) external view returns (uint256);
117 
118     /**
119      * @dev Moves `amount` tokens from the caller's account to `recipient`.
120      *
121      * Returns a boolean value indicating whether the operation succeeded.
122      *
123      * Emits a {Transfer} event.
124      */
125     function transfer(address recipient, uint256 amount) external returns (bool);
126 
127     /**
128      * @dev Returns the remaining number of tokens that `spender` will be
129      * allowed to spend on behalf of `owner` through {transferFrom}. This is
130      * zero by default.
131      *
132      * This value changes when {approve} or {transferFrom} are called.
133      */
134     function allowance(address owner, address spender) external view returns (uint256);
135 
136     /**
137      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
138      *
139      * Returns a boolean value indicating whether the operation succeeded.
140      *
141      * IMPORTANT: Beware that changing an allowance with this method brings the risk
142      * that someone may use both the old and the new allowance by unfortunate
143      * transaction ordering. One possible solution to mitigate this race
144      * condition is to first reduce the spender's allowance to 0 and set the
145      * desired value afterwards:
146      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
147      *
148      * Emits an {Approval} event.
149      */
150 
151     function approve(address spender, uint256 amount) external returns (bool);
152 
153     /**
154      * @dev Moves `amount` tokens from `sender` to `recipient` using the
155      * allowance mechanism. `amount` is then deducted from the caller's
156      * allowance.
157      *
158      * Returns a boolean value indicating whether the operation succeeded.
159      *
160      * Emits a {Transfer} event.
161      */
162 
163     function transferFrom(
164         address sender,
165         address recipient,
166         uint256 amount
167     ) external returns (bool);
168 
169     /**
170      * @dev Emitted when `value` tokens are moved from one account (`from`) to
171      * another (`to`).
172      *
173      * Note that `value` may be zero.
174      */
175 
176     event Transfer(address indexed from, address indexed to, uint256 value);
177 
178     /**
179      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
180      * a call to {approve}. `value` is the new allowance.
181      */
182     event Approval(address indexed owner, address indexed spender, uint256 value);
183 }
184 
185 
186 pragma solidity ^0.8.0;
187 
188 /**
189  * @dev Interface for the optional metadata functions from the ERC20 standard.
190  *
191  * _Available since v4.1._
192  */
193 interface IERC20Metadata is IERC20 {
194     /**
195      * @dev Returns the name of the token.
196      */
197     function name() external view returns (string memory);
198 
199     /**
200      * @dev Returns the symbol of the token.
201      */
202     function symbol() external view returns (string memory);
203 
204     /**
205      * @dev Returns the decimals places of the token.
206      */
207     function decimals() external view returns (uint8);
208 }
209 
210 pragma solidity ^0.8.0;
211 
212 
213 /**
214  * @dev Implementation of the {IERC20} interface.
215  *
216  * This implementation is agnostic to the way tokens are created. This means
217  * that a supply mechanism has to be added in a derived contract using {_mint}.
218  * For a generic mechanism see {ERC20PresetMinterPauser}.
219  *
220  * TIP: For a detailed writeup see our guide
221  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
222  * to implement supply mechanisms].
223  *
224  * We have followed general OpenZeppelin Contracts guidelines: functions revert
225  * instead returning `false` on failure. This behavior is nonetheless
226  * conventional and does not conflict with the expectations of ERC20
227  * applications.
228  *
229  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
230  * This allows applications to reconstruct the allowance for all accounts just
231  * by listening to said events. Other implementations of the EIP may not emit
232  * these events, as it isn't required by the specification.
233  *
234  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
235  * functions have been added to mitigate the well-known issues around setting
236  * allowances. See {IERC20-approve}.
237  */
238 
239 contract ERC20 is Context, IERC20, IERC20Metadata {
240     mapping(address => uint256) private _balances;
241 
242     mapping(address => mapping(address => uint256)) private _allowances;
243 
244     uint256 private _totalSupply;
245 
246     string private _name;
247     string private _symbol;
248 
249     /**
250      * @dev Sets the values for {name} and {symbol}.
251      *
252      * The default value of {decimals} is 18. To select a different value for
253      * {decimals} you should overload it.
254      *
255      * All two of these values are immutable: they can only be set once during
256      * construction.
257      */
258 
259     constructor(string memory name_, string memory symbol_) {
260         _name = name_;
261         _symbol = symbol_;
262     }
263 
264     /**
265      * @dev Returns the name of the token.
266      */
267     function name() public view virtual override returns (string memory) {
268         return _name;
269     }
270 
271     /**
272      * @dev Returns the symbol of the token, usually a shorter version of the
273      * name.
274      */
275 
276     function symbol() public view virtual override returns (string memory) {
277         return _symbol;
278     }
279 
280     /**
281      * @dev Returns the number of decimals used to get its user representation.
282      * For example, if `decimals` equals `2`, a balance of `505` tokens should
283      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
284      *
285      * Tokens usually opt for a value of 18, imitating the relationship between
286      * Ether and Wei. This is the value {ERC20} uses, unless this function is
287      * overridden;
288      *
289      * NOTE: This information is only used for _display_ purposes: it in
290      * no way affects any of the arithmetic of the contract, including
291      * {IERC20-balanceOf} and {IERC20-transfer}.
292      */
293     function decimals() public view virtual override returns (uint8) {
294         return 18;
295     }
296 
297     /**
298      * @dev See {IERC20-totalSupply}.
299      */
300 
301     function totalSupply() public view virtual override returns (uint256) {
302         return _totalSupply;
303     }
304 
305     /**
306      * @dev See {IERC20-balanceOf}.
307      */
308 
309     function balanceOf(address account) public view virtual override returns (uint256) {
310         return _balances[account];
311     }
312 
313     /**
314      * @dev See {IERC20-transfer}.
315      *
316      * Requirements:
317      *
318      * - `recipient` cannot be the zero address.
319      * - the caller must have a balance of at least `amount`.
320      */
321     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
322         _transfer(_msgSender(), recipient, amount);
323         return true;
324     }
325 
326     /**
327      * @dev See {IERC20-allowance}.
328      */
329 
330     function allowance(address owner, address spender) public view virtual override returns (uint256) {
331         return _allowances[owner][spender];
332     }
333 
334     /**
335      * @dev See {IERC20-approve}.
336      *
337      * Requirements:
338      *
339      * - `spender` cannot be the zero address.
340      */
341     function approve(address spender, uint256 amount) public virtual override returns (bool) {
342         _approve(_msgSender(), spender, amount);
343         return true;
344     }
345 
346     /**
347      * @dev See {IERC20-transferFrom}.
348      *
349      * Emits an {Approval} event indicating the updated allowance. This is not
350      * required by the EIP. See the note at the beginning of {ERC20}.
351      *
352      * Requirements:
353      *
354      * - `sender` and `recipient` cannot be the zero address.
355      * - `sender` must have a balance of at least `amount`.
356      * - the caller must have allowance for ``sender``'s tokens of at least
357      * `amount`.
358      */
359     function transferFrom(
360         address sender,
361         address recipient,
362         uint256 amount
363     ) public virtual override returns (bool) {
364         _transfer(sender, recipient, amount);
365 
366         uint256 currentAllowance = _allowances[sender][_msgSender()];
367         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
368         unchecked {
369             _approve(sender, _msgSender(), currentAllowance - amount);
370         }
371 
372         return true;
373     }
374 
375     /**
376      * @dev Atomically increases the allowance granted to `spender` by the caller.
377      *
378      * This is an alternative to {approve} that can be used as a mitigation for
379      * problems described in {IERC20-approve}.
380      *
381      * Emits an {Approval} event indicating the updated allowance.
382      *
383      * Requirements:
384      *
385      * - `spender` cannot be the zero address.
386      */
387 
388     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
389         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
390         return true;
391     }
392 
393     /**
394      * @dev Atomically decreases the allowance granted to `spender` by the caller.
395      *
396      * This is an alternative to {approve} that can be used as a mitigation for
397      * problems described in {IERC20-approve}.
398      *
399      * Emits an {Approval} event indicating the updated allowance.
400      *
401      * Requirements:
402      *
403      * - `spender` cannot be the zero address.
404      * - `spender` must have allowance for the caller of at least
405      * `subtractedValue`.
406      */
407 
408     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
409         uint256 currentAllowance = _allowances[_msgSender()][spender];
410         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
411         unchecked {
412             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
413         }
414 
415         return true;
416     }
417 
418     /**
419      * @dev Moves `amount` of tokens from `sender` to `recipient`.
420      *
421      * This internal function is equivalent to {transfer}, and can be used to
422      * e.g. implement automatic token fees, slashing mechanisms, etc.
423      *
424      * Emits a {Transfer} event.
425      *
426      * Requirements:
427      *
428      * - `sender` cannot be the zero address.
429      * - `recipient` cannot be the zero address.
430      * - `sender` must have a balance of at least `amount`.
431      */
432 
433     function _transfer(
434         address sender,
435         address recipient,
436         uint256 amount
437     ) internal virtual {
438         require(sender != address(0), "ERC20: transfer from the zero address");
439         require(recipient != address(0), "ERC20: transfer to the zero address");
440 
441         _beforeTokenTransfer(sender, recipient, amount);
442 
443         uint256 senderBalance = _balances[sender];
444         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
445         unchecked {
446             _balances[sender] = senderBalance - amount;
447         }
448         _balances[recipient] += amount;
449 
450         emit Transfer(sender, recipient, amount);
451 
452         _afterTokenTransfer(sender, recipient, amount);
453     }
454 
455     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
456      * the total supply.
457      *
458      * Emits a {Transfer} event with `from` set to the zero address.
459      *
460      * Requirements:
461      *
462      * - `account` cannot be the zero address.
463      */
464 
465     function _mint(address account, uint256 amount) internal virtual {
466         require(account != address(0), "ERC20: mint to the zero address");
467 
468         _beforeTokenTransfer(address(0), account, amount);
469 
470         _totalSupply += amount;
471         _balances[account] += amount;
472         emit Transfer(address(0), account, amount);
473 
474         _afterTokenTransfer(address(0), account, amount);
475     }
476 
477     /**
478      * @dev Destroys `amount` tokens from `account`, reducing the
479      * total supply.
480      *
481      * Emits a {Transfer} event with `to` set to the zero address.
482      *
483      * Requirements:
484      *
485      * - `account` cannot be the zero address.
486      * - `account` must have at least `amount` tokens.
487      */
488 
489     function _burn(address account, uint256 amount) internal virtual {
490         require(account != address(0), "ERC20: burn from the zero address");
491 
492         _beforeTokenTransfer(account, address(0), amount);
493 
494         uint256 accountBalance = _balances[account];
495         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
496         unchecked {
497             _balances[account] = accountBalance - amount;
498         }
499         _totalSupply -= amount;
500 
501         emit Transfer(account, address(0), amount);
502 
503         _afterTokenTransfer(account, address(0), amount);
504     }
505 
506     /**
507      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
508      *
509      * This internal function is equivalent to `approve`, and can be used to
510      * e.g. set automatic allowances for certain subsystems, etc.
511      *
512      * Emits an {Approval} event.
513      *
514      * Requirements:
515      *
516      * - `owner` cannot be the zero address.
517      * - `spender` cannot be the zero address.
518      */
519 
520     function _approve(
521         address owner,
522         address spender,
523         uint256 amount
524     ) internal virtual {
525         require(owner != address(0), "ERC20: approve from the zero address");
526         require(spender != address(0), "ERC20: approve to the zero address");
527 
528         _allowances[owner][spender] = amount;
529         emit Approval(owner, spender, amount);
530     }
531 
532     /**
533      * @dev Hook that is called before any transfer of tokens. This includes
534      * minting and burning.
535      *
536      * Calling conditions:
537      *
538      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
539      * will be transferred to `to`.
540      * - when `from` is zero, `amount` tokens will be minted for `to`.
541      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
542      * - `from` and `to` are never both zero.
543      *
544      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
545      */
546 
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
574 
575 // File contracts/SMUDGEToken.sol
576 
577 pragma solidity ^0.8.0;
578 
579 
580 contract SMUDGE is Ownable, ERC20 {
581     address public uniswapV2Pair;
582 
583     constructor(uint256 _totalSupply) ERC20("SMUDGE", "SMUD") {
584         _mint(msg.sender, _totalSupply);
585     }
586 
587 
588     function setUniswapV2Pair(address _uniswapV2Pair) external onlyOwner {
589         uniswapV2Pair = _uniswapV2Pair;
590     }
591 
592     function burn(uint256 value) external {
593         _burn(msg.sender, value);
594     }
595 }