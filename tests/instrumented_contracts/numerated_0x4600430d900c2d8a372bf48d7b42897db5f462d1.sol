1 // File: @openzeppelin/contracts@4.9.2/utils/Context.sol
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
28 // File: @openzeppelin/contracts@4.9.2/access/Ownable.sol
29 
30 
31 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
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
84      * `onlyOwner` functions. Can only be called by the current owner.
85      *
86      * NOTE: Renouncing ownership will leave the contract without an owner,
87      * thereby disabling any functionality that is only available to the owner.
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
113 // File: @openzeppelin/contracts@4.9.2/token/ERC20/IERC20.sol
114 
115 
116 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
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
191     function transferFrom(address from, address to, uint256 amount) external returns (bool);
192 }
193 
194 // File: @openzeppelin/contracts@4.9.2/token/ERC20/extensions/IERC20Metadata.sol
195 
196 
197 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
198 
199 pragma solidity ^0.8.0;
200 
201 
202 /**
203  * @dev Interface for the optional metadata functions from the ERC20 standard.
204  *
205  * _Available since v4.1._
206  */
207 interface IERC20Metadata is IERC20 {
208     /**
209      * @dev Returns the name of the token.
210      */
211     function name() external view returns (string memory);
212 
213     /**
214      * @dev Returns the symbol of the token.
215      */
216     function symbol() external view returns (string memory);
217 
218     /**
219      * @dev Returns the decimals places of the token.
220      */
221     function decimals() external view returns (uint8);
222 }
223 
224 // File: @openzeppelin/contracts@4.9.2/token/ERC20/ERC20.sol
225 
226 
227 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
228 
229 pragma solidity ^0.8.0;
230 
231 
232 
233 
234 /**
235  * @dev Implementation of the {IERC20} interface.
236  *
237  * This implementation is agnostic to the way tokens are created. This means
238  * that a supply mechanism has to be added in a derived contract using {_mint}.
239  * For a generic mechanism see {ERC20PresetMinterPauser}.
240  *
241  * TIP: For a detailed writeup see our guide
242  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
243  * to implement supply mechanisms].
244  *
245  * The default value of {decimals} is 18. To change this, you should override
246  * this function so it returns a different value.
247  *
248  * We have followed general OpenZeppelin Contracts guidelines: functions revert
249  * instead returning `false` on failure. This behavior is nonetheless
250  * conventional and does not conflict with the expectations of ERC20
251  * applications.
252  *
253  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
254  * This allows applications to reconstruct the allowance for all accounts just
255  * by listening to said events. Other implementations of the EIP may not emit
256  * these events, as it isn't required by the specification.
257  *
258  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
259  * functions have been added to mitigate the well-known issues around setting
260  * allowances. See {IERC20-approve}.
261  */
262 contract ERC20 is Context, IERC20, IERC20Metadata {
263     mapping(address => uint256) private _balances;
264 
265     mapping(address => mapping(address => uint256)) private _allowances;
266 
267     uint256 private _totalSupply;
268 
269     string private _name;
270     string private _symbol;
271 
272     /**
273      * @dev Sets the values for {name} and {symbol}.
274      *
275      * All two of these values are immutable: they can only be set once during
276      * construction.
277      */
278     constructor(string memory name_, string memory symbol_) {
279         _name = name_;
280         _symbol = symbol_;
281     }
282 
283     /**
284      * @dev Returns the name of the token.
285      */
286     function name() public view virtual override returns (string memory) {
287         return _name;
288     }
289 
290     /**
291      * @dev Returns the symbol of the token, usually a shorter version of the
292      * name.
293      */
294     function symbol() public view virtual override returns (string memory) {
295         return _symbol;
296     }
297 
298     /**
299      * @dev Returns the number of decimals used to get its user representation.
300      * For example, if `decimals` equals `2`, a balance of `505` tokens should
301      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
302      *
303      * Tokens usually opt for a value of 18, imitating the relationship between
304      * Ether and Wei. This is the default value returned by this function, unless
305      * it's overridden.
306      *
307      * NOTE: This information is only used for _display_ purposes: it in
308      * no way affects any of the arithmetic of the contract, including
309      * {IERC20-balanceOf} and {IERC20-transfer}.
310      */
311     function decimals() public view virtual override returns (uint8) {
312         return 18;
313     }
314 
315     /**
316      * @dev See {IERC20-totalSupply}.
317      */
318     function totalSupply() public view virtual override returns (uint256) {
319         return _totalSupply;
320     }
321 
322     /**
323      * @dev See {IERC20-balanceOf}.
324      */
325     function balanceOf(address account) public view virtual override returns (uint256) {
326         return _balances[account];
327     }
328 
329     /**
330      * @dev See {IERC20-transfer}.
331      *
332      * Requirements:
333      *
334      * - `to` cannot be the zero address.
335      * - the caller must have a balance of at least `amount`.
336      */
337     function transfer(address to, uint256 amount) public virtual override returns (bool) {
338         address owner = _msgSender();
339         _transfer(owner, to, amount);
340         return true;
341     }
342 
343     /**
344      * @dev See {IERC20-allowance}.
345      */
346     function allowance(address owner, address spender) public view virtual override returns (uint256) {
347         return _allowances[owner][spender];
348     }
349 
350     /**
351      * @dev See {IERC20-approve}.
352      *
353      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
354      * `transferFrom`. This is semantically equivalent to an infinite approval.
355      *
356      * Requirements:
357      *
358      * - `spender` cannot be the zero address.
359      */
360     function approve(address spender, uint256 amount) public virtual override returns (bool) {
361         address owner = _msgSender();
362         _approve(owner, spender, amount);
363         return true;
364     }
365 
366     /**
367      * @dev See {IERC20-transferFrom}.
368      *
369      * Emits an {Approval} event indicating the updated allowance. This is not
370      * required by the EIP. See the note at the beginning of {ERC20}.
371      *
372      * NOTE: Does not update the allowance if the current allowance
373      * is the maximum `uint256`.
374      *
375      * Requirements:
376      *
377      * - `from` and `to` cannot be the zero address.
378      * - `from` must have a balance of at least `amount`.
379      * - the caller must have allowance for ``from``'s tokens of at least
380      * `amount`.
381      */
382     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
383         address spender = _msgSender();
384         _spendAllowance(from, spender, amount);
385         _transfer(from, to, amount);
386         return true;
387     }
388 
389     /**
390      * @dev Atomically increases the allowance granted to `spender` by the caller.
391      *
392      * This is an alternative to {approve} that can be used as a mitigation for
393      * problems described in {IERC20-approve}.
394      *
395      * Emits an {Approval} event indicating the updated allowance.
396      *
397      * Requirements:
398      *
399      * - `spender` cannot be the zero address.
400      */
401     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
402         address owner = _msgSender();
403         _approve(owner, spender, allowance(owner, spender) + addedValue);
404         return true;
405     }
406 
407     /**
408      * @dev Atomically decreases the allowance granted to `spender` by the caller.
409      *
410      * This is an alternative to {approve} that can be used as a mitigation for
411      * problems described in {IERC20-approve}.
412      *
413      * Emits an {Approval} event indicating the updated allowance.
414      *
415      * Requirements:
416      *
417      * - `spender` cannot be the zero address.
418      * - `spender` must have allowance for the caller of at least
419      * `subtractedValue`.
420      */
421     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
422         address owner = _msgSender();
423         uint256 currentAllowance = allowance(owner, spender);
424         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
425         unchecked {
426             _approve(owner, spender, currentAllowance - subtractedValue);
427         }
428 
429         return true;
430     }
431 
432     /**
433      * @dev Moves `amount` of tokens from `from` to `to`.
434      *
435      * This internal function is equivalent to {transfer}, and can be used to
436      * e.g. implement automatic token fees, slashing mechanisms, etc.
437      *
438      * Emits a {Transfer} event.
439      *
440      * Requirements:
441      *
442      * - `from` cannot be the zero address.
443      * - `to` cannot be the zero address.
444      * - `from` must have a balance of at least `amount`.
445      */
446     function _transfer(address from, address to, uint256 amount) internal virtual {
447         require(from != address(0), "ERC20: transfer from the zero address");
448         require(to != address(0), "ERC20: transfer to the zero address");
449 
450         _beforeTokenTransfer(from, to, amount);
451 
452         uint256 fromBalance = _balances[from];
453         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
454         unchecked {
455             _balances[from] = fromBalance - amount;
456             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
457             // decrementing then incrementing.
458             _balances[to] += amount;
459         }
460 
461         emit Transfer(from, to, amount);
462 
463         _afterTokenTransfer(from, to, amount);
464     }
465 
466     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
467      * the total supply.
468      *
469      * Emits a {Transfer} event with `from` set to the zero address.
470      *
471      * Requirements:
472      *
473      * - `account` cannot be the zero address.
474      */
475     function _mint(address account, uint256 amount) internal virtual {
476         require(account != address(0), "ERC20: mint to the zero address");
477 
478         _beforeTokenTransfer(address(0), account, amount);
479 
480         _totalSupply += amount;
481         unchecked {
482             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
483             _balances[account] += amount;
484         }
485         emit Transfer(address(0), account, amount);
486 
487         _afterTokenTransfer(address(0), account, amount);
488     }
489 
490     /**
491      * @dev Destroys `amount` tokens from `account`, reducing the
492      * total supply.
493      *
494      * Emits a {Transfer} event with `to` set to the zero address.
495      *
496      * Requirements:
497      *
498      * - `account` cannot be the zero address.
499      * - `account` must have at least `amount` tokens.
500      */
501     function _burn(address account, uint256 amount) internal virtual {
502         require(account != address(0), "ERC20: burn from the zero address");
503 
504         _beforeTokenTransfer(account, address(0), amount);
505 
506         uint256 accountBalance = _balances[account];
507         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
508         unchecked {
509             _balances[account] = accountBalance - amount;
510             // Overflow not possible: amount <= accountBalance <= totalSupply.
511             _totalSupply -= amount;
512         }
513 
514         emit Transfer(account, address(0), amount);
515 
516         _afterTokenTransfer(account, address(0), amount);
517     }
518 
519     /**
520      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
521      *
522      * This internal function is equivalent to `approve`, and can be used to
523      * e.g. set automatic allowances for certain subsystems, etc.
524      *
525      * Emits an {Approval} event.
526      *
527      * Requirements:
528      *
529      * - `owner` cannot be the zero address.
530      * - `spender` cannot be the zero address.
531      */
532     function _approve(address owner, address spender, uint256 amount) internal virtual {
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
548     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
549         uint256 currentAllowance = allowance(owner, spender);
550         if (currentAllowance != type(uint256).max) {
551             require(currentAllowance >= amount, "ERC20: insufficient allowance");
552             unchecked {
553                 _approve(owner, spender, currentAllowance - amount);
554             }
555         }
556     }
557 
558     /**
559      * @dev Hook that is called before any transfer of tokens. This includes
560      * minting and burning.
561      *
562      * Calling conditions:
563      *
564      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
565      * will be transferred to `to`.
566      * - when `from` is zero, `amount` tokens will be minted for `to`.
567      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
568      * - `from` and `to` are never both zero.
569      *
570      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
571      */
572     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
573 
574     /**
575      * @dev Hook that is called after any transfer of tokens. This includes
576      * minting and burning.
577      *
578      * Calling conditions:
579      *
580      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
581      * has been transferred to `to`.
582      * - when `from` is zero, `amount` tokens have been minted for `to`.
583      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
584      * - `from` and `to` are never both zero.
585      *
586      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
587      */
588     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
589 }
590 
591 // File: contract-a049296d71.sol
592 
593 
594 pragma solidity ^0.8.9;
595 
596 
597 
598 contract CharlesMansonAlexJonesBeetlejuice1776PitbullKaren is ERC20, Ownable {
599     constructor()
600         ERC20("CharlesMansonAlexJonesBeetlejuice1776Pitbull(karen)", "MONERO")
601     {
602         _mint(msg.sender, 177642069 * 10 ** decimals());
603     }
604 }