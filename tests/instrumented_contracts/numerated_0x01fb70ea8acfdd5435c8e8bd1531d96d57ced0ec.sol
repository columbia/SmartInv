1 // SPDX-License-Identifier: UNLICENSED
2 
3 // File: @openzeppelin/contracts/utils/Context.sol
4 
5 
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 // File: @openzeppelin/contracts/access/Ownable.sol
30 
31 
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
57         _setOwner(_msgSender());
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         _setOwner(address(0));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         _setOwner(newOwner);
93     }
94 
95     function _setOwner(address newOwner) private {
96         address oldOwner = _owner;
97         _owner = newOwner;
98         emit OwnershipTransferred(oldOwner, newOwner);
99     }
100 }
101 
102 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
103 
104 
105 
106 pragma solidity ^0.8.0;
107 
108 /**
109  * @dev Interface of the ERC20 standard as defined in the EIP.
110  */
111 interface IERC20 {
112     /**
113      * @dev Returns the amount of tokens in existence.
114      */
115     function totalSupply() external view returns (uint256);
116 
117     /**
118      * @dev Returns the amount of tokens owned by `account`.
119      */
120     function balanceOf(address account) external view returns (uint256);
121 
122     /**
123      * @dev Moves `amount` tokens from the caller's account to `recipient`.
124      *
125      * Returns a boolean value indicating whether the operation succeeded.
126      *
127      * Emits a {Transfer} event.
128      */
129     function transfer(address recipient, uint256 amount) external returns (bool);
130 
131     /**
132      * @dev Returns the remaining number of tokens that `spender` will be
133      * allowed to spend on behalf of `owner` through {transferFrom}. This is
134      * zero by default.
135      *
136      * This value changes when {approve} or {transferFrom} are called.
137      */
138     function allowance(address owner, address spender) external view returns (uint256);
139 
140     /**
141      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
142      *
143      * Returns a boolean value indicating whether the operation succeeded.
144      *
145      * IMPORTANT: Beware that changing an allowance with this method brings the risk
146      * that someone may use both the old and the new allowance by unfortunate
147      * transaction ordering. One possible solution to mitigate this race
148      * condition is to first reduce the spender's allowance to 0 and set the
149      * desired value afterwards:
150      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
151      *
152      * Emits an {Approval} event.
153      */
154     function approve(address spender, uint256 amount) external returns (bool);
155 
156     /**
157      * @dev Moves `amount` tokens from `sender` to `recipient` using the
158      * allowance mechanism. `amount` is then deducted from the caller's
159      * allowance.
160      *
161      * Returns a boolean value indicating whether the operation succeeded.
162      *
163      * Emits a {Transfer} event.
164      */
165     function transferFrom(
166         address sender,
167         address recipient,
168         uint256 amount
169     ) external returns (bool);
170 
171     /**
172      * @dev Emitted when `value` tokens are moved from one account (`from`) to
173      * another (`to`).
174      *
175      * Note that `value` may be zero.
176      */
177     event Transfer(address indexed from, address indexed to, uint256 value);
178 
179     /**
180      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
181      * a call to {approve}. `value` is the new allowance.
182      */
183     event Approval(address indexed owner, address indexed spender, uint256 value);
184 }
185 
186 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
187 
188 
189 
190 pragma solidity ^0.8.0;
191 
192 
193 /**
194  * @dev Interface for the optional metadata functions from the ERC20 standard.
195  *
196  * _Available since v4.1._
197  */
198 interface IERC20Metadata is IERC20 {
199     /**
200      * @dev Returns the name of the token.
201      */
202     function name() external view returns (string memory);
203 
204     /**
205      * @dev Returns the symbol of the token.
206      */
207     function symbol() external view returns (string memory);
208 
209     /**
210      * @dev Returns the decimals places of the token.
211      */
212     function decimals() external view returns (uint8);
213 }
214 
215 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
216 
217 
218 
219 pragma solidity ^0.8.0;
220 
221 
222 
223 
224 /**
225  * @dev Implementation of the {IERC20} interface.
226  *
227  * This implementation is agnostic to the way tokens are created. This means
228  * that a supply mechanism has to be added in a derived contract using {_mint}.
229  * For a generic mechanism see {ERC20PresetMinterPauser}.
230  *
231  * TIP: For a detailed writeup see our guide
232  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
233  * to implement supply mechanisms].
234  *
235  * We have followed general OpenZeppelin Contracts guidelines: functions revert
236  * instead returning `false` on failure. This behavior is nonetheless
237  * conventional and does not conflict with the expectations of ERC20
238  * applications.
239  *
240  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
241  * This allows applications to reconstruct the allowance for all accounts just
242  * by listening to said events. Other implementations of the EIP may not emit
243  * these events, as it isn't required by the specification.
244  *
245  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
246  * functions have been added to mitigate the well-known issues around setting
247  * allowances. See {IERC20-approve}.
248  */
249 contract ERC20 is Context, IERC20, IERC20Metadata {
250     mapping(address => uint256) private _balances;
251 
252     mapping(address => mapping(address => uint256)) private _allowances;
253 
254     uint256 private _totalSupply;
255 
256     string private _name;
257     string private _symbol;
258 
259     /**
260      * @dev Sets the values for {name} and {symbol}.
261      *
262      * The default value of {decimals} is 18. To select a different value for
263      * {decimals} you should overload it.
264      *
265      * All two of these values are immutable: they can only be set once during
266      * construction.
267      */
268     constructor(string memory name_, string memory symbol_) {
269         _name = name_;
270         _symbol = symbol_;
271     }
272 
273     /**
274      * @dev Returns the name of the token.
275      */
276     function name() public view virtual override returns (string memory) {
277         return _name;
278     }
279 
280     /**
281      * @dev Returns the symbol of the token, usually a shorter version of the
282      * name.
283      */
284     function symbol() public view virtual override returns (string memory) {
285         return _symbol;
286     }
287 
288     /**
289      * @dev Returns the number of decimals used to get its user representation.
290      * For example, if `decimals` equals `2`, a balance of `505` tokens should
291      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
292      *
293      * Tokens usually opt for a value of 18, imitating the relationship between
294      * Ether and Wei. This is the value {ERC20} uses, unless this function is
295      * overridden;
296      *
297      * NOTE: This information is only used for _display_ purposes: it in
298      * no way affects any of the arithmetic of the contract, including
299      * {IERC20-balanceOf} and {IERC20-transfer}.
300      */
301     function decimals() public view virtual override returns (uint8) {
302         return 18;
303     }
304 
305     /**
306      * @dev See {IERC20-totalSupply}.
307      */
308     function totalSupply() public view virtual override returns (uint256) {
309         return _totalSupply;
310     }
311 
312     /**
313      * @dev See {IERC20-balanceOf}.
314      */
315     function balanceOf(address account) public view virtual override returns (uint256) {
316         return _balances[account];
317     }
318 
319     /**
320      * @dev See {IERC20-transfer}.
321      *
322      * Requirements:
323      *
324      * - `recipient` cannot be the zero address.
325      * - the caller must have a balance of at least `amount`.
326      */
327     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
328         _transfer(_msgSender(), recipient, amount);
329         return true;
330     }
331 
332     /**
333      * @dev See {IERC20-allowance}.
334      */
335     function allowance(address owner, address spender) public view virtual override returns (uint256) {
336         return _allowances[owner][spender];
337     }
338 
339     /**
340      * @dev See {IERC20-approve}.
341      *
342      * Requirements:
343      *
344      * - `spender` cannot be the zero address.
345      */
346     function approve(address spender, uint256 amount) public virtual override returns (bool) {
347         _approve(_msgSender(), spender, amount);
348         return true;
349     }
350 
351     /**
352      * @dev See {IERC20-transferFrom}.
353      *
354      * Emits an {Approval} event indicating the updated allowance. This is not
355      * required by the EIP. See the note at the beginning of {ERC20}.
356      *
357      * Requirements:
358      *
359      * - `sender` and `recipient` cannot be the zero address.
360      * - `sender` must have a balance of at least `amount`.
361      * - the caller must have allowance for ``sender``'s tokens of at least
362      * `amount`.
363      */
364     function transferFrom(
365         address sender,
366         address recipient,
367         uint256 amount
368     ) public virtual override returns (bool) {
369         _transfer(sender, recipient, amount);
370 
371         uint256 currentAllowance = _allowances[sender][_msgSender()];
372         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
373         unchecked {
374             _approve(sender, _msgSender(), currentAllowance - amount);
375         }
376 
377         return true;
378     }
379 
380     /**
381      * @dev Atomically increases the allowance granted to `spender` by the caller.
382      *
383      * This is an alternative to {approve} that can be used as a mitigation for
384      * problems described in {IERC20-approve}.
385      *
386      * Emits an {Approval} event indicating the updated allowance.
387      *
388      * Requirements:
389      *
390      * - `spender` cannot be the zero address.
391      */
392     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
393         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
394         return true;
395     }
396 
397     /**
398      * @dev Atomically decreases the allowance granted to `spender` by the caller.
399      *
400      * This is an alternative to {approve} that can be used as a mitigation for
401      * problems described in {IERC20-approve}.
402      *
403      * Emits an {Approval} event indicating the updated allowance.
404      *
405      * Requirements:
406      *
407      * - `spender` cannot be the zero address.
408      * - `spender` must have allowance for the caller of at least
409      * `subtractedValue`.
410      */
411     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
412         uint256 currentAllowance = _allowances[_msgSender()][spender];
413         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
414         unchecked {
415             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
416         }
417 
418         return true;
419     }
420 
421     /**
422      * @dev Moves `amount` of tokens from `sender` to `recipient`.
423      *
424      * This internal function is equivalent to {transfer}, and can be used to
425      * e.g. implement automatic token fees, slashing mechanisms, etc.
426      *
427      * Emits a {Transfer} event.
428      *
429      * Requirements:
430      *
431      * - `sender` cannot be the zero address.
432      * - `recipient` cannot be the zero address.
433      * - `sender` must have a balance of at least `amount`.
434      */
435     function _transfer(
436         address sender,
437         address recipient,
438         uint256 amount
439     ) internal virtual {
440         require(sender != address(0), "ERC20: transfer from the zero address");
441         require(recipient != address(0), "ERC20: transfer to the zero address");
442 
443         _beforeTokenTransfer(sender, recipient, amount);
444 
445         uint256 senderBalance = _balances[sender];
446         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
447         unchecked {
448             _balances[sender] = senderBalance - amount;
449         }
450         _balances[recipient] += amount;
451 
452         emit Transfer(sender, recipient, amount);
453 
454         _afterTokenTransfer(sender, recipient, amount);
455     }
456 
457     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
458      * the total supply.
459      *
460      * Emits a {Transfer} event with `from` set to the zero address.
461      *
462      * Requirements:
463      *
464      * - `account` cannot be the zero address.
465      */
466     function _mint(address account, uint256 amount) internal virtual {
467         require(account != address(0), "ERC20: mint to the zero address");
468 
469         _beforeTokenTransfer(address(0), account, amount);
470 
471         _totalSupply += amount;
472         _balances[account] += amount;
473         emit Transfer(address(0), account, amount);
474 
475         _afterTokenTransfer(address(0), account, amount);
476     }
477 
478     /**
479      * @dev Destroys `amount` tokens from `account`, reducing the
480      * total supply.
481      *
482      * Emits a {Transfer} event with `to` set to the zero address.
483      *
484      * Requirements:
485      *
486      * - `account` cannot be the zero address.
487      * - `account` must have at least `amount` tokens.
488      */
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
519     function _approve(
520         address owner,
521         address spender,
522         uint256 amount
523     ) internal virtual {
524         require(owner != address(0), "ERC20: approve from the zero address");
525         require(spender != address(0), "ERC20: approve to the zero address");
526 
527         _allowances[owner][spender] = amount;
528         emit Approval(owner, spender, amount);
529     }
530 
531     /**
532      * @dev Hook that is called before any transfer of tokens. This includes
533      * minting and burning.
534      *
535      * Calling conditions:
536      *
537      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
538      * will be transferred to `to`.
539      * - when `from` is zero, `amount` tokens will be minted for `to`.
540      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
541      * - `from` and `to` are never both zero.
542      *
543      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
544      */
545     function _beforeTokenTransfer(
546         address from,
547         address to,
548         uint256 amount
549     ) internal virtual {}
550 
551     /**
552      * @dev Hook that is called after any transfer of tokens. This includes
553      * minting and burning.
554      *
555      * Calling conditions:
556      *
557      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
558      * has been transferred to `to`.
559      * - when `from` is zero, `amount` tokens have been minted for `to`.
560      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
561      * - `from` and `to` are never both zero.
562      *
563      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
564      */
565     function _afterTokenTransfer(
566         address from,
567         address to,
568         uint256 amount
569     ) internal virtual {}
570 }
571 
572 // File: gist-1f87777a8e5027809ee13e6029c9b3ee/SelectToken.sol
573 
574 
575 
576 pragma solidity >=0.7.0 <0.9.0;
577 
578 
579 
580 /**
581  * @title Implementation of ERC20 interface
582  * @author Michal Wojcik
583  * @notice This is SmartElectrum project ERC20 token implementation
584  */
585 contract SelectToken is ERC20, Ownable {
586     
587     /**
588      * @dev Initializes the contract with correct parameters.
589      */
590     constructor() ERC20("SmartElectrum", "SELECT") {
591         _mint(msg.sender, 100_000_000 * 10 ** decimals());
592     }
593 
594      /**
595      * @notice Destroy given amount of tokens and reduce the total supply.
596      *         Can be called ONLY by contract OWNER.
597      * @param amount amount of tokens to destroy
598      * @dev Emits a {Transfer} event with `to` set to the zero address.
599      */
600     function burnTokens(uint amount) external onlyOwner() {
601         _burn(msg.sender, amount);
602     }
603 }