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
26 
27 
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
56      * @dev Throws if called by any account other than the owner.
57      */
58     modifier onlyOwner() {
59         _checkOwner();
60         _;
61     }
62 
63     /**
64      * @dev Returns the address of the current owner.
65      */
66     function owner() public view virtual returns (address) {
67         return _owner;
68     }
69 
70     /**
71      * @dev Throws if the sender is not the owner.
72      */
73     function _checkOwner() internal view virtual {
74         require(owner() == _msgSender(), "Ownable: caller is not the owner");
75     }
76 
77     /**
78      * @dev Leaves the contract without owner. It will not be possible to call
79      * `onlyOwner` functions anymore. Can only be called by the current owner.
80      *
81      * NOTE: Renouncing ownership will leave the contract without an owner,
82      * thereby removing any functionality that is only available to the owner.
83      */
84     function renounceOwnership() public virtual onlyOwner {
85         _transferOwnership(address(0));
86     }
87 
88     /**
89      * @dev Transfers ownership of the contract to a new account (`newOwner`).
90      * Can only be called by the current owner.
91      */
92     function transferOwnership(address newOwner) public virtual onlyOwner {
93         require(newOwner != address(0), "Ownable: new owner is the zero address");
94         _transferOwnership(newOwner);
95     }
96 
97     /**
98      * @dev Transfers ownership of the contract to a new account (`newOwner`).
99      * Internal function without access restriction.
100      */
101     function _transferOwnership(address newOwner) internal virtual {
102         address oldOwner = _owner;
103         _owner = newOwner;
104         emit OwnershipTransferred(oldOwner, newOwner);
105     }
106 }
107 
108 
109 
110 pragma solidity ^0.8.0;
111 
112 /**
113  * @dev Interface of the ERC20 standard as defined in the EIP.
114  */
115 interface IERC20 {
116     /**
117      * @dev Emitted when `value` tokens are moved from one account (`from`) to
118      * another (`to`).
119      *
120      * Note that `value` may be zero.
121      */
122     event Transfer(address indexed from, address indexed to, uint256 value);
123 
124     /**
125      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
126      * a call to {approve}. `value` is the new allowance.
127      */
128     event Approval(address indexed owner, address indexed spender, uint256 value);
129 
130     /**
131      * @dev Returns the amount of tokens in existence.
132      */
133     function totalSupply() external view returns (uint256);
134 
135     /**
136      * @dev Returns the amount of tokens owned by `account`.
137      */
138     function balanceOf(address account) external view returns (uint256);
139 
140     /**
141      * @dev Moves `amount` tokens from the caller's account to `to`.
142      *
143      * Returns a boolean value indicating whether the operation succeeded.
144      *
145      * Emits a {Transfer} event.
146      */
147     function transfer(address to, uint256 amount) external returns (bool);
148 
149     /**
150      * @dev Returns the remaining number of tokens that `spender` will be
151      * allowed to spend on behalf of `owner` through {transferFrom}. This is
152      * zero by default.
153      *
154      * This value changes when {approve} or {transferFrom} are called.
155      */
156     function allowance(address owner, address spender) external view returns (uint256);
157 
158     /**
159      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
160      *
161      * Returns a boolean value indicating whether the operation succeeded.
162      *
163      * IMPORTANT: Beware that changing an allowance with this method brings the risk
164      * that someone may use both the old and the new allowance by unfortunate
165      * transaction ordering. One possible solution to mitigate this race
166      * condition is to first reduce the spender's allowance to 0 and set the
167      * desired value afterwards:
168      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
169      *
170      * Emits an {Approval} event.
171      */
172     function approve(address spender, uint256 amount) external returns (bool);
173 
174     /**
175      * @dev Moves `amount` tokens from `from` to `to` using the
176      * allowance mechanism. `amount` is then deducted from the caller's
177      * allowance.
178      *
179      * Returns a boolean value indicating whether the operation succeeded.
180      *
181      * Emits a {Transfer} event.
182      */
183     function transferFrom(
184         address from,
185         address to,
186         uint256 amount
187     ) external returns (bool);
188 }
189 
190 
191 
192 pragma solidity ^0.8.0;
193 
194 /**
195  * @dev Interface for the optional metadata functions from the ERC20 standard.
196  *
197  * _Available since v4.1._
198  */
199 interface IERC20Metadata is IERC20 {
200     /**
201      * @dev Returns the name of the token.
202      */
203     function name() external view returns (string memory);
204 
205     /**
206      * @dev Returns the symbol of the token.
207      */
208     function symbol() external view returns (string memory);
209 
210     /**
211      * @dev Returns the decimals places of the token.
212      */
213     function decimals() external view returns (uint8);
214 }
215 
216 
217 
218 pragma solidity ^0.8.0;
219 
220 
221 
222 /**
223  * @dev Implementation of the {IERC20} interface.
224  *
225  * This implementation is agnostic to the way tokens are created. This means
226  * that a supply mechanism has to be added in a derived contract using {_mint}.
227  * For a generic mechanism see {ERC20PresetMinterPauser}.
228  *
229  * TIP: For a detailed writeup see our guide
230  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
231  * to implement supply mechanisms].
232  *
233  * We have followed general OpenZeppelin Contracts guidelines: functions revert
234  * instead returning `false` on failure. This behavior is nonetheless
235  * conventional and does not conflict with the expectations of ERC20
236  * applications.
237  *
238  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
239  * This allows applications to reconstruct the allowance for all accounts just
240  * by listening to said events. Other implementations of the EIP may not emit
241  * these events, as it isn't required by the specification.
242  *
243  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
244  * functions have been added to mitigate the well-known issues around setting
245  * allowances. See {IERC20-approve}.
246  */
247 contract ERC20 is Context, IERC20, IERC20Metadata {
248     mapping(address => uint256) private _balances;
249 
250     mapping(address => mapping(address => uint256)) private _allowances;
251 
252     uint256 private _totalSupply;
253 
254     string private _name;
255     string private _symbol;
256 
257     /**
258      * @dev Sets the values for {name} and {symbol}.
259      *
260      * The default value of {decimals} is 18. To select a different value for
261      * {decimals} you should overload it.
262      *
263      * All two of these values are immutable: they can only be set once during
264      * construction.
265      */
266     constructor(string memory name_, string memory symbol_) {
267         _name = name_;
268         _symbol = symbol_;
269     }
270 
271     /**
272      * @dev Returns the name of the token.
273      */
274     function name() public view virtual override returns (string memory) {
275         return _name;
276     }
277 
278     /**
279      * @dev Returns the symbol of the token, usually a shorter version of the
280      * name.
281      */
282     function symbol() public view virtual override returns (string memory) {
283         return _symbol;
284     }
285 
286     /**
287      * @dev Returns the number of decimals used to get its user representation.
288      * For example, if `decimals` equals `2`, a balance of `505` tokens should
289      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
290      *
291      * Tokens usually opt for a value of 18, imitating the relationship between
292      * Ether and Wei. This is the value {ERC20} uses, unless this function is
293      * overridden;
294      *
295      * NOTE: This information is only used for _display_ purposes: it in
296      * no way affects any of the arithmetic of the contract, including
297      * {IERC20-balanceOf} and {IERC20-transfer}.
298      */
299     function decimals() public view virtual override returns (uint8) {
300         return 18;
301     }
302 
303     /**
304      * @dev See {IERC20-totalSupply}.
305      */
306     function totalSupply() public view virtual override returns (uint256) {
307         return _totalSupply;
308     }
309 
310     /**
311      * @dev See {IERC20-balanceOf}.
312      */
313     function balanceOf(address account) public view virtual override returns (uint256) {
314         return _balances[account];
315     }
316 
317     /**
318      * @dev See {IERC20-transfer}.
319      *
320      * Requirements:
321      *
322      * - `to` cannot be the zero address.
323      * - the caller must have a balance of at least `amount`.
324      */
325     function transfer(address to, uint256 amount) public virtual override returns (bool) {
326         address owner = _msgSender();
327         _transfer(owner, to, amount);
328         return true;
329     }
330 
331     /**
332      * @dev See {IERC20-allowance}.
333      */
334     function allowance(address owner, address spender) public view virtual override returns (uint256) {
335         return _allowances[owner][spender];
336     }
337 
338     /**
339      * @dev See {IERC20-approve}.
340      *
341      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
342      * `transferFrom`. This is semantically equivalent to an infinite approval.
343      *
344      * Requirements:
345      *
346      * - `spender` cannot be the zero address.
347      */
348     function approve(address spender, uint256 amount) public virtual override returns (bool) {
349         address owner = _msgSender();
350         _approve(owner, spender, amount);
351         return true;
352     }
353 
354     /**
355      * @dev See {IERC20-transferFrom}.
356      *
357      * Emits an {Approval} event indicating the updated allowance. This is not
358      * required by the EIP. See the note at the beginning of {ERC20}.
359      *
360      * NOTE: Does not update the allowance if the current allowance
361      * is the maximum `uint256`.
362      *
363      * Requirements:
364      *
365      * - `from` and `to` cannot be the zero address.
366      * - `from` must have a balance of at least `amount`.
367      * - the caller must have allowance for ``from``'s tokens of at least
368      * `amount`.
369      */
370     function transferFrom(
371         address from,
372         address to,
373         uint256 amount
374     ) public virtual override returns (bool) {
375         address spender = _msgSender();
376         _spendAllowance(from, spender, amount);
377         _transfer(from, to, amount);
378         return true;
379     }
380 
381     /**
382      * @dev Atomically increases the allowance granted to `spender` by the caller.
383      *
384      * This is an alternative to {approve} that can be used as a mitigation for
385      * problems described in {IERC20-approve}.
386      *
387      * Emits an {Approval} event indicating the updated allowance.
388      *
389      * Requirements:
390      *
391      * - `spender` cannot be the zero address.
392      */
393     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
394         address owner = _msgSender();
395         _approve(owner, spender, allowance(owner, spender) + addedValue);
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
414         address owner = _msgSender();
415         uint256 currentAllowance = allowance(owner, spender);
416         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
417         unchecked {
418             _approve(owner, spender, currentAllowance - subtractedValue);
419         }
420 
421         return true;
422     }
423 
424     /**
425      * @dev Moves `amount` of tokens from `from` to `to`.
426      *
427      * This internal function is equivalent to {transfer}, and can be used to
428      * e.g. implement automatic token fees, slashing mechanisms, etc.
429      *
430      * Emits a {Transfer} event.
431      *
432      * Requirements:
433      *
434      * - `from` cannot be the zero address.
435      * - `to` cannot be the zero address.
436      * - `from` must have a balance of at least `amount`.
437      */
438     function _transfer(
439         address from,
440         address to,
441         uint256 amount
442     ) internal virtual {
443         require(from != address(0), "ERC20: transfer from the zero address");
444         require(to != address(0), "ERC20: transfer to the zero address");
445 
446         _beforeTokenTransfer(from, to, amount);
447 
448         uint256 fromBalance = _balances[from];
449         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
450         unchecked {
451             _balances[from] = fromBalance - amount;
452             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
453             // decrementing then incrementing.
454             _balances[to] += amount;
455         }
456 
457         emit Transfer(from, to, amount);
458 
459         _afterTokenTransfer(from, to, amount);
460     }
461 
462     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
463      * the total supply.
464      *
465      * Emits a {Transfer} event with `from` set to the zero address.
466      *
467      * Requirements:
468      *
469      * - `account` cannot be the zero address.
470      */
471     function _mint(address account, uint256 amount) internal virtual {
472         require(account != address(0), "ERC20: mint to the zero address");
473 
474         _beforeTokenTransfer(address(0), account, amount);
475 
476         _totalSupply += amount;
477         unchecked {
478             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
479             _balances[account] += amount;
480         }
481         emit Transfer(address(0), account, amount);
482 
483         _afterTokenTransfer(address(0), account, amount);
484     }
485 
486     /**
487      * @dev Destroys `amount` tokens from `account`, reducing the
488      * total supply.
489      *
490      * Emits a {Transfer} event with `to` set to the zero address.
491      *
492      * Requirements:
493      *
494      * - `account` cannot be the zero address.
495      * - `account` must have at least `amount` tokens.
496      */
497     function _burn(address account, uint256 amount) internal virtual {
498         require(account != address(0), "ERC20: burn from the zero address");
499 
500         _beforeTokenTransfer(account, address(0), amount);
501 
502         uint256 accountBalance = _balances[account];
503         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
504         unchecked {
505             _balances[account] = accountBalance - amount;
506             // Overflow not possible: amount <= accountBalance <= totalSupply.
507             _totalSupply -= amount;
508         }
509 
510         emit Transfer(account, address(0), amount);
511 
512         _afterTokenTransfer(account, address(0), amount);
513     }
514 
515     /**
516      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
517      *
518      * This internal function is equivalent to `approve`, and can be used to
519      * e.g. set automatic allowances for certain subsystems, etc.
520      *
521      * Emits an {Approval} event.
522      *
523      * Requirements:
524      *
525      * - `owner` cannot be the zero address.
526      * - `spender` cannot be the zero address.
527      */
528     function _approve(
529         address owner,
530         address spender,
531         uint256 amount
532     ) internal virtual {
533         require(owner != address(0), "ERC20: approve from the zero address");
534         require(spender != address(0), "ERC20: approve to the zero address");
535 
536         _allowances[owner][spender] = amount;
537         emit Approval(owner, spender, amount);
538     }
539 
540     /**
541      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
542      *
543      * Does not update the allowance amount in case of infinite allowance.
544      * Revert if not enough allowance is available.
545      *
546      * Might emit an {Approval} event.
547      */
548     function _spendAllowance(
549         address owner,
550         address spender,
551         uint256 amount
552     ) internal virtual {
553         uint256 currentAllowance = allowance(owner, spender);
554         if (currentAllowance != type(uint256).max) {
555             require(currentAllowance >= amount, "ERC20: insufficient allowance");
556             unchecked {
557                 _approve(owner, spender, currentAllowance - amount);
558             }
559         }
560     }
561 
562     /**
563      * @dev Hook that is called before any transfer of tokens. This includes
564      * minting and burning.
565      *
566      * Calling conditions:
567      *
568      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
569      * will be transferred to `to`.
570      * - when `from` is zero, `amount` tokens will be minted for `to`.
571      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
572      * - `from` and `to` are never both zero.
573      *
574      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
575      */
576     function _beforeTokenTransfer(
577         address from,
578         address to,
579         uint256 amount
580     ) internal virtual {}
581 
582     /**
583      * @dev Hook that is called after any transfer of tokens. This includes
584      * minting and burning.
585      *
586      * Calling conditions:
587      *
588      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
589      * has been transferred to `to`.
590      * - when `from` is zero, `amount` tokens have been minted for `to`.
591      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
592      * - `from` and `to` are never both zero.
593      *
594      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
595      */
596     function _afterTokenTransfer(
597         address from,
598         address to,
599         uint256 amount
600     ) internal virtual {}
601 }
602 
603 
604 pragma solidity ^0.8.9;
605 contract LarryCoin is ERC20, Ownable {
606     constructor() ERC20("Larry Coin", "LRB") {
607         _mint(msg.sender, 999999999999999 * 10 ** decimals());
608     }
609 }