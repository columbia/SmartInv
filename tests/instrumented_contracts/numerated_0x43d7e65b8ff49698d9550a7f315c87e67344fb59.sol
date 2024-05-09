1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Context.sol
3 
4 pragma solidity ^0.8.0;
5 
6 /*
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 // File: @openzeppelin/contracts/access/Ownable.sol
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
46     event OwnershipTransferred(
47         address indexed previousOwner,
48         address indexed newOwner
49     );
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor() {
55         address msgSender = _msgSender();
56         _owner = msgSender;
57         emit OwnershipTransferred(address(0), msgSender);
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
83         emit OwnershipTransferred(_owner, address(0));
84         _owner = address(0);
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Can only be called by the current owner.
90      */
91     function transferOwnership(address newOwner) public virtual onlyOwner {
92         require(
93             newOwner != address(0),
94             "Ownable: new owner is the zero address"
95         );
96         emit OwnershipTransferred(_owner, newOwner);
97         _owner = newOwner;
98     }
99 }
100 
101 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
102 
103 pragma solidity ^0.8.0;
104 
105 /**
106  * @dev Interface of the ERC20 standard as defined in the EIP.
107  */
108 interface IERC20 {
109     /**
110      * @dev Returns the amount of tokens in existence.
111      */
112     function totalSupply() external view returns (uint256);
113 
114     /**
115      * @dev Returns the amount of tokens owned by `account`.
116      */
117     function balanceOf(address account) external view returns (uint256);
118 
119     /**
120      * @dev Moves `amount` tokens from the caller's account to `recipient`.
121      *
122      * Returns a boolean value indicating whether the operation succeeded.
123      *
124      * Emits a {Transfer} event.
125      */
126     function transfer(
127         address recipient,
128         uint256 amount
129     ) external returns (bool);
130 
131     /**
132      * @dev Returns the remaining number of tokens that `spender` will be
133      * allowed to spend on behalf of `owner` through {transferFrom}. This is
134      * zero by default.
135      *
136      * This value changes when {approve} or {transferFrom} are called.
137      */
138     function allowance(
139         address owner,
140         address spender
141     ) external view returns (uint256);
142 
143     /**
144      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
145      *
146      * Returns a boolean value indicating whether the operation succeeded.
147      *
148      * IMPORTANT: Beware that changing an allowance with this method brings the risk
149      * that someone may use both the old and the new allowance by unfortunate
150      * transaction ordering. One possible solution to mitigate this race
151      * condition is to first reduce the spender's allowance to 0 and set the
152      * desired value afterwards:
153      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154      *
155      * Emits an {Approval} event.
156      */
157     function approve(address spender, uint256 amount) external returns (bool);
158 
159     /**
160      * @dev Moves `amount` tokens from `sender` to `recipient` using the
161      * allowance mechanism. `amount` is then deducted from the caller's
162      * allowance.
163      *
164      * Returns a boolean value indicating whether the operation succeeded.
165      *
166      * Emits a {Transfer} event.
167      */
168     function transferFrom(
169         address sender,
170         address recipient,
171         uint256 amount
172     ) external returns (bool);
173 
174     /**
175      * @dev Emitted when `value` tokens are moved from one account (`from`) to
176      * another (`to`).
177      *
178      * Note that `value` may be zero.
179      */
180     event Transfer(address indexed from, address indexed to, uint256 value);
181 
182     /**
183      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
184      * a call to {approve}. `value` is the new allowance.
185      */
186     event Approval(
187         address indexed owner,
188         address indexed spender,
189         uint256 value
190     );
191 }
192 
193 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
194 
195 pragma solidity ^0.8.0;
196 
197 /**
198  * @dev Interface for the optional metadata functions from the ERC20 standard.
199  *
200  * _Available since v4.1._
201  */
202 interface IERC20Metadata is IERC20 {
203     /**
204      * @dev Returns the name of the token.
205      */
206     function name() external view returns (string memory);
207 
208     /**
209      * @dev Returns the symbol of the token.
210      */
211     function symbol() external view returns (string memory);
212 
213     /**
214      * @dev Returns the decimals places of the token.
215      */
216     function decimals() external view returns (uint8);
217 }
218 
219 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
220 
221 pragma solidity ^0.8.0;
222 
223 /**
224  * @dev Implementation of the {IERC20} interface.
225  *
226  * This implementation is agnostic to the way tokens are created. This means
227  * that a supply mechanism has to be added in a derived contract using {_mint}.
228  * For a generic mechanism see {ERC20PresetMinterPauser}.
229  *
230  * TIP: For a detailed writeup see our guide
231  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
232  * to implement supply mechanisms].
233  *
234  * We have followed general OpenZeppelin guidelines: functions revert instead
235  * of returning `false` on failure. This behavior is nonetheless conventional
236  * and does not conflict with the expectations of ERC20 applications.
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
260      * The defaut value of {decimals} is 18. To select a different value for
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
289      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
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
313     function balanceOf(
314         address account
315     ) public view virtual override returns (uint256) {
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
327     function transfer(
328         address recipient,
329         uint256 amount
330     ) public virtual override returns (bool) {
331         _transfer(_msgSender(), recipient, amount);
332         return true;
333     }
334 
335     /**
336      * @dev See {IERC20-allowance}.
337      */
338     function allowance(
339         address owner,
340         address spender
341     ) public view virtual override returns (uint256) {
342         return _allowances[owner][spender];
343     }
344 
345     /**
346      * @dev See {IERC20-approve}.
347      *
348      * Requirements:
349      *
350      * - `spender` cannot be the zero address.
351      */
352     function approve(
353         address spender,
354         uint256 amount
355     ) public virtual override returns (bool) {
356         _approve(_msgSender(), spender, amount);
357         return true;
358     }
359 
360     /**
361      * @dev See {IERC20-transferFrom}.
362      *
363      * Emits an {Approval} event indicating the updated allowance. This is not
364      * required by the EIP. See the note at the beginning of {ERC20}.
365      *
366      * Requirements:
367      *
368      * - `sender` and `recipient` cannot be the zero address.
369      * - `sender` must have a balance of at least `amount`.
370      * - the caller must have allowance for ``sender``'s tokens of at least
371      * `amount`.
372      */
373     function transferFrom(
374         address sender,
375         address recipient,
376         uint256 amount
377     ) public virtual override returns (bool) {
378         _transfer(sender, recipient, amount);
379 
380         uint256 currentAllowance = _allowances[sender][_msgSender()];
381         require(
382             currentAllowance >= amount,
383             "ERC20: transfer amount exceeds allowance"
384         );
385         _approve(sender, _msgSender(), currentAllowance - amount);
386 
387         return true;
388     }
389 
390     /**
391      * @dev Atomically increases the allowance granted to `spender` by the caller.
392      *
393      * This is an alternative to {approve} that can be used as a mitigation for
394      * problems described in {IERC20-approve}.
395      *
396      * Emits an {Approval} event indicating the updated allowance.
397      *
398      * Requirements:
399      *
400      * - `spender` cannot be the zero address.
401      */
402     function increaseAllowance(
403         address spender,
404         uint256 addedValue
405     ) public virtual returns (bool) {
406         _approve(
407             _msgSender(),
408             spender,
409             _allowances[_msgSender()][spender] + addedValue
410         );
411         return true;
412     }
413 
414     /**
415      * @dev Atomically decreases the allowance granted to `spender` by the caller.
416      *
417      * This is an alternative to {approve} that can be used as a mitigation for
418      * problems described in {IERC20-approve}.
419      *
420      * Emits an {Approval} event indicating the updated allowance.
421      *
422      * Requirements:
423      *
424      * - `spender` cannot be the zero address.
425      * - `spender` must have allowance for the caller of at least
426      * `subtractedValue`.
427      */
428     function decreaseAllowance(
429         address spender,
430         uint256 subtractedValue
431     ) public virtual returns (bool) {
432         uint256 currentAllowance = _allowances[_msgSender()][spender];
433         require(
434             currentAllowance >= subtractedValue,
435             "ERC20: decreased allowance below zero"
436         );
437         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
438 
439         return true;
440     }
441 
442     /**
443      * @dev Moves tokens `amount` from `sender` to `recipient`.
444      *
445      * This is internal function is equivalent to {transfer}, and can be used to
446      * e.g. implement automatic token fees, slashing mechanisms, etc.
447      *
448      * Emits a {Transfer} event.
449      *
450      * Requirements:
451      *
452      * - `sender` cannot be the zero address.
453      * - `recipient` cannot be the zero address.
454      * - `sender` must have a balance of at least `amount`.
455      */
456     function _transfer(
457         address sender,
458         address recipient,
459         uint256 amount
460     ) internal virtual {
461         require(sender != address(0), "ERC20: transfer from the zero address");
462         require(recipient != address(0), "ERC20: transfer to the zero address");
463 
464         _beforeTokenTransfer(sender, recipient, amount);
465 
466         uint256 senderBalance = _balances[sender];
467         require(
468             senderBalance >= amount,
469             "ERC20: transfer amount exceeds balance"
470         );
471         _balances[sender] = senderBalance - amount;
472         _balances[recipient] += amount;
473 
474         emit Transfer(sender, recipient, amount);
475     }
476 
477     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
478      * the total supply.
479      *
480      * Emits a {Transfer} event with `from` set to the zero address.
481      *
482      * Requirements:
483      *
484      * - `to` cannot be the zero address.
485      */
486     function _mint(address account, uint256 amount) internal virtual {
487         require(account != address(0), "ERC20: mint to the zero address");
488 
489         _beforeTokenTransfer(address(0), account, amount);
490 
491         _totalSupply += amount;
492         _balances[account] += amount;
493         emit Transfer(address(0), account, amount);
494     }
495 
496     /**
497      * @dev Destroys `amount` tokens from `account`, reducing the
498      * total supply.
499      *
500      * Emits a {Transfer} event with `to` set to the zero address.
501      *
502      * Requirements:
503      *
504      * - `account` cannot be the zero address.
505      * - `account` must have at least `amount` tokens.
506      */
507     function _burn(address account, uint256 amount) internal virtual {
508         require(account != address(0), "ERC20: burn from the zero address");
509 
510         _beforeTokenTransfer(account, address(0), amount);
511 
512         uint256 accountBalance = _balances[account];
513         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
514         _balances[account] = accountBalance - amount;
515         _totalSupply -= amount;
516 
517         emit Transfer(account, address(0), amount);
518     }
519 
520     /**
521      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
522      *
523      * This internal function is equivalent to `approve`, and can be used to
524      * e.g. set automatic allowances for certain subsystems, etc.
525      *
526      * Emits an {Approval} event.
527      *
528      * Requirements:
529      *
530      * - `owner` cannot be the zero address.
531      * - `spender` cannot be the zero address.
532      */
533     function _approve(
534         address owner,
535         address spender,
536         uint256 amount
537     ) internal virtual {
538         require(owner != address(0), "ERC20: approve from the zero address");
539         require(spender != address(0), "ERC20: approve to the zero address");
540 
541         _allowances[owner][spender] = amount;
542         emit Approval(owner, spender, amount);
543     }
544 
545     /**
546      * @dev Hook that is called before any transfer of tokens. This includes
547      * minting and burning.
548      *
549      * Calling conditions:
550      *
551      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
552      * will be to transferred to `to`.
553      * - when `from` is zero, `amount` tokens will be minted for `to`.
554      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
555      * - `from` and `to` are never both zero.
556      *
557      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
558      */
559     function _beforeTokenTransfer(
560         address from,
561         address to,
562         uint256 amount
563     ) internal virtual {}
564 }
565 
566 // File: contracts/SHIA.sol
567 
568 pragma solidity ^0.8.4;
569 
570 contract SHIA is ERC20, Ownable {
571     uint256 public maxHoldingAmount;
572     uint256 public maxTxAmount;
573     mapping(address => bool) public blacklists;
574 
575     constructor() ERC20("SHIA", "SHIA") {
576         _mint(msg.sender, 10000000000 * 10 ** decimals());
577         maxTxAmount = 1000000 * 10 ** decimals();
578         maxHoldingAmount = 50000000 * 10 ** decimals();
579     }
580 
581     function setRule(
582         uint256 _maxHoldingAmount,
583         uint256 _maxTxAmount
584     ) external onlyOwner {
585         maxHoldingAmount = _maxHoldingAmount;
586         maxTxAmount = _maxTxAmount;
587     }
588 
589     function _beforeTokenTransfer(
590         address from,
591         address to,
592         uint256 amount
593     ) internal virtual override {
594         require(!blacklists[to] && !blacklists[from], "Blacklisted");
595 
596         if (from != owner() && to != owner()) {
597             require(super.balanceOf(to) + amount <= maxHoldingAmount, "Forbid");
598         }
599 
600         if (maxTxAmount > 0 && from != owner() && to != owner()) {
601             require(amount <= maxTxAmount, "Exceeds max transaction amount");
602         }
603     }
604 
605     function burn(uint256 value) external {
606         _burn(msg.sender, value);
607     }
608 }