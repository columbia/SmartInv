1 // File: @openzeppelin/contracts@4.8.0/utils/Context.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts@4.8.0/access/Ownable.sol
29 
30 
31 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         _checkOwner();
65         _;
66     }
67 
68     /**
69      * @dev Returns the address of the current owner.
70      */
71     function owner() public view virtual returns (address) {
72         return _owner;
73     }
74 
75     /**
76      * @dev Throws if the sender is not the owner.
77      */
78     function _checkOwner() internal view virtual {
79         require(owner() == _msgSender(), "Ownable: caller is not the owner");
80     }
81 
82     /**
83      * @dev Leaves the contract without owner. It will not be possible to call
84      * `onlyOwner` functions anymore. Can only be called by the current owner.
85      *
86      * NOTE: Renouncing ownership will leave the contract without an owner,
87      * thereby removing any functionality that is only available to the owner.
88      */
89     function renounceOwnership() public virtual onlyOwner {
90         _transferOwnership(address(0));
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Can only be called by the current owner.
96      */
97     function transferOwnership(address newOwner) public virtual onlyOwner {
98         require(newOwner != address(0), "Ownable: new owner is the zero address");
99         _transferOwnership(newOwner);
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      * Internal function without access restriction.
105      */
106     function _transferOwnership(address newOwner) internal virtual {
107         address oldOwner = _owner;
108         _owner = newOwner;
109         emit OwnershipTransferred(oldOwner, newOwner);
110     }
111 }
112 
113 // File: @openzeppelin/contracts@4.8.0/token/ERC20/IERC20.sol
114 
115 
116 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
117 
118 pragma solidity ^0.8.0;
119 
120 /**
121  * @dev Interface of the ERC20 standard as defined in the EIP.
122  */
123 interface IERC20 {
124     /**
125      * @dev Emitted when `value` tokens are moved from one account (`from`) to
126      * another (`to`).
127      *
128      * Note that `value` may be zero.
129      */
130     event Transfer(address indexed from, address indexed to, uint256 value);
131 
132     /**
133      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
134      * a call to {approve}. `value` is the new allowance.
135      */
136     event Approval(address indexed owner, address indexed spender, uint256 value);
137 
138     /**
139      * @dev Returns the amount of tokens in existence.
140      */
141     function totalSupply() external view returns (uint256);
142 
143     /**
144      * @dev Returns the amount of tokens owned by `account`.
145      */
146     function balanceOf(address account) external view returns (uint256);
147 
148     /**
149      * @dev Moves `amount` tokens from the caller's account to `to`.
150      *
151      * Returns a boolean value indicating whether the operation succeeded.
152      *
153      * Emits a {Transfer} event.
154      */
155     function transfer(address to, uint256 amount) external returns (bool);
156 
157     /**
158      * @dev Returns the remaining number of tokens that `spender` will be
159      * allowed to spend on behalf of `owner` through {transferFrom}. This is
160      * zero by default.
161      *
162      * This value changes when {approve} or {transferFrom} are called.
163      */
164     function allowance(address owner, address spender) external view returns (uint256);
165 
166     /**
167      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
168      *
169      * Returns a boolean value indicating whether the operation succeeded.
170      *
171      * IMPORTANT: Beware that changing an allowance with this method brings the risk
172      * that someone may use both the old and the new allowance by unfortunate
173      * transaction ordering. One possible solution to mitigate this race
174      * condition is to first reduce the spender's allowance to 0 and set the
175      * desired value afterwards:
176      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
177      *
178      * Emits an {Approval} event.
179      */
180     function approve(address spender, uint256 amount) external returns (bool);
181 
182     /**
183      * @dev Moves `amount` tokens from `from` to `to` using the
184      * allowance mechanism. `amount` is then deducted from the caller's
185      * allowance.
186      *
187      * Returns a boolean value indicating whether the operation succeeded.
188      *
189      * Emits a {Transfer} event.
190      */
191     function transferFrom(
192         address from,
193         address to,
194         uint256 amount
195     ) external returns (bool);
196 }
197 
198 // File: @openzeppelin/contracts@4.8.0/token/ERC20/extensions/IERC20Metadata.sol
199 
200 
201 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
202 
203 pragma solidity ^0.8.0;
204 
205 
206 /**
207  * @dev Interface for the optional metadata functions from the ERC20 standard.
208  *
209  * _Available since v4.1._
210  */
211 interface IERC20Metadata is IERC20 {
212     /**
213      * @dev Returns the name of the token.
214      */
215     function name() external view returns (string memory);
216 
217     /**
218      * @dev Returns the symbol of the token.
219      */
220     function symbol() external view returns (string memory);
221 
222     /**
223      * @dev Returns the decimals places of the token.
224      */
225     function decimals() external view returns (uint8);
226 }
227 
228 // File: @openzeppelin/contracts@4.8.0/token/ERC20/ERC20.sol
229 
230 
231 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
232 
233 pragma solidity ^0.8.0;
234 
235 
236 
237 
238 /**
239  * @dev Implementation of the {IERC20} interface.
240  *
241  * This implementation is agnostic to the way tokens are created. This means
242  * that a supply mechanism has to be added in a derived contract using {_mint}.
243  * For a generic mechanism see {ERC20PresetMinterPauser}.
244  *
245  * TIP: For a detailed writeup see our guide
246  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
247  * to implement supply mechanisms].
248  *
249  * We have followed general OpenZeppelin Contracts guidelines: functions revert
250  * instead returning `false` on failure. This behavior is nonetheless
251  * conventional and does not conflict with the expectations of ERC20
252  * applications.
253  *
254  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
255  * This allows applications to reconstruct the allowance for all accounts just
256  * by listening to said events. Other implementations of the EIP may not emit
257  * these events, as it isn't required by the specification.
258  *
259  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
260  * functions have been added to mitigate the well-known issues around setting
261  * allowances. See {IERC20-approve}.
262  */
263 contract ERC20 is Context, IERC20, IERC20Metadata {
264     mapping(address => uint256) private _balances;
265 
266     mapping(address => mapping(address => uint256)) private _allowances;
267 
268     uint256 private _totalSupply;
269 
270     string private _name;
271     string private _symbol;
272 
273     /**
274      * @dev Sets the values for {name} and {symbol}.
275      *
276      * The default value of {decimals} is 18. To select a different value for
277      * {decimals} you should overload it.
278      *
279      * All two of these values are immutable: they can only be set once during
280      * construction.
281      */
282     constructor(string memory name_, string memory symbol_) {
283         _name = name_;
284         _symbol = symbol_;
285     }
286 
287     /**
288      * @dev Returns the name of the token.
289      */
290     function name() public view virtual override returns (string memory) {
291         return _name;
292     }
293 
294     /**
295      * @dev Returns the symbol of the token, usually a shorter version of the
296      * name.
297      */
298     function symbol() public view virtual override returns (string memory) {
299         return _symbol;
300     }
301 
302     /**
303      * @dev Returns the number of decimals used to get its user representation.
304      * For example, if `decimals` equals `2`, a balance of `505` tokens should
305      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
306      *
307      * Tokens usually opt for a value of 18, imitating the relationship between
308      * Ether and Wei. This is the value {ERC20} uses, unless this function is
309      * overridden;
310      *
311      * NOTE: This information is only used for _display_ purposes: it in
312      * no way affects any of the arithmetic of the contract, including
313      * {IERC20-balanceOf} and {IERC20-transfer}.
314      */
315     function decimals() public view virtual override returns (uint8) {
316         return 18;
317     }
318 
319     /**
320      * @dev See {IERC20-totalSupply}.
321      */
322     function totalSupply() public view virtual override returns (uint256) {
323         return _totalSupply;
324     }
325 
326     /**
327      * @dev See {IERC20-balanceOf}.
328      */
329     function balanceOf(address account) public view virtual override returns (uint256) {
330         return _balances[account];
331     }
332 
333     /**
334      * @dev See {IERC20-transfer}.
335      *
336      * Requirements:
337      *
338      * - `to` cannot be the zero address.
339      * - the caller must have a balance of at least `amount`.
340      */
341     function transfer(address to, uint256 amount) public virtual override returns (bool) {
342         address owner = _msgSender();
343         _transfer(owner, to, amount);
344         return true;
345     }
346 
347     /**
348      * @dev See {IERC20-allowance}.
349      */
350     function allowance(address owner, address spender) public view virtual override returns (uint256) {
351         return _allowances[owner][spender];
352     }
353 
354     /**
355      * @dev See {IERC20-approve}.
356      *
357      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
358      * `transferFrom`. This is semantically equivalent to an infinite approval.
359      *
360      * Requirements:
361      *
362      * - `spender` cannot be the zero address.
363      */
364     function approve(address spender, uint256 amount) public virtual override returns (bool) {
365         address owner = _msgSender();
366         _approve(owner, spender, amount);
367         return true;
368     }
369 
370     /**
371      * @dev See {IERC20-transferFrom}.
372      *
373      * Emits an {Approval} event indicating the updated allowance. This is not
374      * required by the EIP. See the note at the beginning of {ERC20}.
375      *
376      * NOTE: Does not update the allowance if the current allowance
377      * is the maximum `uint256`.
378      *
379      * Requirements:
380      *
381      * - `from` and `to` cannot be the zero address.
382      * - `from` must have a balance of at least `amount`.
383      * - the caller must have allowance for ``from``'s tokens of at least
384      * `amount`.
385      */
386     function transferFrom(
387         address from,
388         address to,
389         uint256 amount
390     ) public virtual override returns (bool) {
391         address spender = _msgSender();
392         _spendAllowance(from, spender, amount);
393         _transfer(from, to, amount);
394         return true;
395     }
396 
397     /**
398      * @dev Atomically increases the allowance granted to `spender` by the caller.
399      *
400      * This is an alternative to {approve} that can be used as a mitigation for
401      * problems described in {IERC20-approve}.
402      *
403      * Emits an {Approval} event indicating the updated allowance.
404      *
405      * Requirements:
406      *
407      * - `spender` cannot be the zero address.
408      */
409     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
410         address owner = _msgSender();
411         _approve(owner, spender, allowance(owner, spender) + addedValue);
412         return true;
413     }
414 
415     /**
416      * @dev Atomically decreases the allowance granted to `spender` by the caller.
417      *
418      * This is an alternative to {approve} that can be used as a mitigation for
419      * problems described in {IERC20-approve}.
420      *
421      * Emits an {Approval} event indicating the updated allowance.
422      *
423      * Requirements:
424      *
425      * - `spender` cannot be the zero address.
426      * - `spender` must have allowance for the caller of at least
427      * `subtractedValue`.
428      */
429     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
430         address owner = _msgSender();
431         uint256 currentAllowance = allowance(owner, spender);
432         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
433         unchecked {
434             _approve(owner, spender, currentAllowance - subtractedValue);
435         }
436 
437         return true;
438     }
439 
440     /**
441      * @dev Moves `amount` of tokens from `from` to `to`.
442      *
443      * This internal function is equivalent to {transfer}, and can be used to
444      * e.g. implement automatic token fees, slashing mechanisms, etc.
445      *
446      * Emits a {Transfer} event.
447      *
448      * Requirements:
449      *
450      * - `from` cannot be the zero address.
451      * - `to` cannot be the zero address.
452      * - `from` must have a balance of at least `amount`.
453      */
454     function _transfer(
455         address from,
456         address to,
457         uint256 amount
458     ) internal virtual {
459         require(from != address(0), "ERC20: transfer from the zero address");
460         require(to != address(0), "ERC20: transfer to the zero address");
461 
462         _beforeTokenTransfer(from, to, amount);
463 
464         uint256 fromBalance = _balances[from];
465         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
466         unchecked {
467             _balances[from] = fromBalance - amount;
468             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
469             // decrementing then incrementing.
470             _balances[to] += amount;
471         }
472 
473         emit Transfer(from, to, amount);
474 
475         _afterTokenTransfer(from, to, amount);
476     }
477 
478     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
479      * the total supply.
480      *
481      * Emits a {Transfer} event with `from` set to the zero address.
482      *
483      * Requirements:
484      *
485      * - `account` cannot be the zero address.
486      */
487     function _mint(address account, uint256 amount) internal virtual {
488         require(account != address(0), "ERC20: mint to the zero address");
489 
490         _beforeTokenTransfer(address(0), account, amount);
491 
492         _totalSupply += amount;
493         unchecked {
494             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
495             _balances[account] += amount;
496         }
497         emit Transfer(address(0), account, amount);
498 
499         _afterTokenTransfer(address(0), account, amount);
500     }
501 
502     /**
503      * @dev Destroys `amount` tokens from `account`, reducing the
504      * total supply.
505      *
506      * Emits a {Transfer} event with `to` set to the zero address.
507      *
508      * Requirements:
509      *
510      * - `account` cannot be the zero address.
511      * - `account` must have at least `amount` tokens.
512      */
513     function _burn(address account, uint256 amount) internal virtual {
514         require(account != address(0), "ERC20: burn from the zero address");
515 
516         _beforeTokenTransfer(account, address(0), amount);
517 
518         uint256 accountBalance = _balances[account];
519         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
520         unchecked {
521             _balances[account] = accountBalance - amount;
522             // Overflow not possible: amount <= accountBalance <= totalSupply.
523             _totalSupply -= amount;
524         }
525 
526         emit Transfer(account, address(0), amount);
527 
528         _afterTokenTransfer(account, address(0), amount);
529     }
530 
531     /**
532      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
533      *
534      * This internal function is equivalent to `approve`, and can be used to
535      * e.g. set automatic allowances for certain subsystems, etc.
536      *
537      * Emits an {Approval} event.
538      *
539      * Requirements:
540      *
541      * - `owner` cannot be the zero address.
542      * - `spender` cannot be the zero address.
543      */
544     function _approve(
545         address owner,
546         address spender,
547         uint256 amount
548     ) internal virtual {
549         require(owner != address(0), "ERC20: approve from the zero address");
550         require(spender != address(0), "ERC20: approve to the zero address");
551 
552         _allowances[owner][spender] = amount;
553         emit Approval(owner, spender, amount);
554     }
555 
556     /**
557      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
558      *
559      * Does not update the allowance amount in case of infinite allowance.
560      * Revert if not enough allowance is available.
561      *
562      * Might emit an {Approval} event.
563      */
564     function _spendAllowance(
565         address owner,
566         address spender,
567         uint256 amount
568     ) internal virtual {
569         uint256 currentAllowance = allowance(owner, spender);
570         if (currentAllowance != type(uint256).max) {
571             require(currentAllowance >= amount, "ERC20: insufficient allowance");
572             unchecked {
573                 _approve(owner, spender, currentAllowance - amount);
574             }
575         }
576     }
577 
578     /**
579      * @dev Hook that is called before any transfer of tokens. This includes
580      * minting and burning.
581      *
582      * Calling conditions:
583      *
584      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
585      * will be transferred to `to`.
586      * - when `from` is zero, `amount` tokens will be minted for `to`.
587      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
588      * - `from` and `to` are never both zero.
589      *
590      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
591      */
592     function _beforeTokenTransfer(
593         address from,
594         address to,
595         uint256 amount
596     ) internal virtual {}
597 
598     /**
599      * @dev Hook that is called after any transfer of tokens. This includes
600      * minting and burning.
601      *
602      * Calling conditions:
603      *
604      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
605      * has been transferred to `to`.
606      * - when `from` is zero, `amount` tokens have been minted for `to`.
607      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
608      * - `from` and `to` are never both zero.
609      *
610      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
611      */
612     function _afterTokenTransfer(
613         address from,
614         address to,
615         uint256 amount
616     ) internal virtual {}
617 }
618 
619 // File: contract-13ab5e0b92.sol
620 
621 
622 pragma solidity ^0.8.9;
623 
624 
625 
626 contract StartupersCoin is ERC20, Ownable {
627     constructor() ERC20("StartupersCoin", "STAR") {
628         _mint(msg.sender, 500000000000 * 10 ** decimals());
629     }
630 }