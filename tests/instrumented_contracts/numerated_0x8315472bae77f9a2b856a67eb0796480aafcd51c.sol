1 /**
2  *Submitted for verification at Etherscan.io on 2021-02-15
3 */
4 
5 pragma solidity ^0.8.0;
6 
7 // SPDX-License-Identifier: MIT
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with GSN meta-transactions the account sending and
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
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 /**
31  * @dev Interface of the ERC20 standard as defined in the EIP.
32  */
33 interface IERC20 {
34     /**
35      * @dev Returns the amount of tokens in existence.
36      */
37     function totalSupply() external view returns (uint256);
38 
39     /**
40      * @dev Returns the amount of tokens owned by `account`.
41      */
42     function balanceOf(address account) external view returns (uint256);
43 
44     /**
45      * @dev Moves `amount` tokens from the caller's account to `recipient`.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * Emits a {Transfer} event.
50      */
51     function transfer(address recipient, uint256 amount)
52         external
53         returns (bool);
54 
55     /**
56      * @dev Returns the remaining number of tokens that `spender` will be
57      * allowed to spend on behalf of `owner` through {transferFrom}. This is
58      * zero by default.
59      *
60      * This value changes when {approve} or {transferFrom} are called.
61      */
62     function allowance(address owner, address spender)
63         external
64         view
65         returns (uint256);
66 
67     /**
68      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * IMPORTANT: Beware that changing an allowance with this method brings the risk
73      * that someone may use both the old and the new allowance by unfortunate
74      * transaction ordering. One possible solution to mitigate this race
75      * condition is to first reduce the spender's allowance to 0 and set the
76      * desired value afterwards:
77      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
78      *
79      * Emits an {Approval} event.
80      */
81     function approve(address spender, uint256 amount) external returns (bool);
82 
83     /**
84      * @dev Moves `amount` tokens from `sender` to `recipient` using the
85      * allowance mechanism. `amount` is then deducted from the caller's
86      * allowance.
87      *
88      * Returns a boolean value indicating whether the operation succeeded.
89      *
90      * Emits a {Transfer} event.
91      */
92     function transferFrom(
93         address sender,
94         address recipient,
95         uint256 amount
96     ) external returns (bool);
97 
98     /**
99      * @dev Emitted when `value` tokens are moved from one account (`from`) to
100      * another (`to`).
101      *
102      * Note that `value` may be zero.
103      */
104     event Transfer(address indexed from, address indexed to, uint256 value);
105 
106     /**
107      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
108      * a call to {approve}. `value` is the new allowance.
109      */
110     event Approval(
111         address indexed owner,
112         address indexed spender,
113         uint256 value
114     );
115 }
116 
117 /**
118  * @dev Implementation of the {IERC20} interface.
119  *
120  * This implementation is agnostic to the way tokens are created. This means
121  * that a supply mechanism has to be added in a derived contract using {_mint}.
122  * For a generic mechanism see {ERC20PresetMinterPauser}.
123  *
124  * TIP: For a detailed writeup see our guide
125  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
126  * to implement supply mechanisms].
127  *
128  * We have followed general OpenZeppelin guidelines: functions revert instead
129  * of returning `false` on failure. This behavior is nonetheless conventional
130  * and does not conflict with the expectations of ERC20 applications.
131  *
132  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
133  * This allows applications to reconstruct the allowance for all accounts just
134  * by listening to said events. Other implementations of the EIP may not emit
135  * these events, as it isn't required by the specification.
136  *
137  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
138  * functions have been added to mitigate the well-known issues around setting
139  * allowances. See {IERC20-approve}.
140  */
141 contract ERC20 is Context, IERC20 {
142     mapping(address => uint256) private _balances;
143 
144     mapping(address => mapping(address => uint256)) private _allowances;
145 
146     uint256 private _totalSupply;
147 
148     string private _name;
149     string private _symbol;
150 
151     /**
152      * @dev Sets the values for {name} and {symbol}.
153      *
154      * The defaut value of {decimals} is 18. To select a different value for
155      * {decimals} you should overload it.
156      *
157      * All three of these values are immutable: they can only be set once during
158      * construction.
159      */
160     constructor(string memory name_, string memory symbol_) {
161         _name = name_;
162         _symbol = symbol_;
163     }
164 
165     /**
166      * @dev Returns the name of the token.
167      */
168     function name() public view virtual returns (string memory) {
169         return _name;
170     }
171 
172     /**
173      * @dev Returns the symbol of the token, usually a shorter version of the
174      * name.
175      */
176     function symbol() public view virtual returns (string memory) {
177         return _symbol;
178     }
179 
180     /**
181      * @dev Returns the number of decimals used to get its user representation.
182      * For example, if `decimals` equals `2`, a balance of `505` tokens should
183      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
184      *
185      * Tokens usually opt for a value of 18, imitating the relationship between
186      * Ether and Wei. This is the value {ERC20} uses, unless this function is
187      * overloaded;
188      *
189      * NOTE: This information is only used for _display_ purposes: it in
190      * no way affects any of the arithmetic of the contract, including
191      * {IERC20-balanceOf} and {IERC20-transfer}.
192      */
193     function decimals() public view virtual returns (uint8) {
194         return 18;
195     }
196 
197     /**
198      * @dev See {IERC20-totalSupply}.
199      */
200     function totalSupply() public view virtual override returns (uint256) {
201         return _totalSupply;
202     }
203 
204     /**
205      * @dev See {IERC20-balanceOf}.
206      */
207     function balanceOf(address account)
208         public
209         view
210         virtual
211         override
212         returns (uint256)
213     {
214         return _balances[account];
215     }
216 
217     /**
218      * @dev See {IERC20-transfer}.
219      *
220      * Requirements:
221      *
222      * - `recipient` cannot be the zero address.
223      * - the caller must have a balance of at least `amount`.
224      */
225     function transfer(address recipient, uint256 amount)
226         public
227         virtual
228         override
229         returns (bool)
230     {
231         _transfer(_msgSender(), recipient, amount);
232         return true;
233     }
234 
235     /**
236      * @dev See {IERC20-allowance}.
237      */
238     function allowance(address owner, address spender)
239         public
240         view
241         virtual
242         override
243         returns (uint256)
244     {
245         return _allowances[owner][spender];
246     }
247 
248     /**
249      * @dev See {IERC20-approve}.
250      *
251      * Requirements:
252      *
253      * - `spender` cannot be the zero address.
254      */
255     function approve(address spender, uint256 amount)
256         public
257         virtual
258         override
259         returns (bool)
260     {
261         _approve(_msgSender(), spender, amount);
262         return true;
263     }
264 
265     /**
266      * @dev See {IERC20-transferFrom}.
267      *
268      * Emits an {Approval} event indicating the updated allowance. This is not
269      * required by the EIP. See the note at the beginning of {ERC20}.
270      *
271      * Requirements:
272      *
273      * - `sender` and `recipient` cannot be the zero address.
274      * - `sender` must have a balance of at least `amount`.
275      * - the caller must have allowance for ``sender``'s tokens of at least
276      * `amount`.
277      */
278     function transferFrom(
279         address sender,
280         address recipient,
281         uint256 amount
282     ) public virtual override returns (bool) {
283         _transfer(sender, recipient, amount);
284 
285         require(
286             _allowances[sender][_msgSender()] >= amount,
287             "ERC20: transfer amount exceeds allowance"
288         );
289         _approve(
290             sender,
291             _msgSender(),
292             _allowances[sender][_msgSender()] - amount
293         );
294 
295         return true;
296     }
297 
298     /**
299      * @dev Atomically increases the allowance granted to `spender` by the caller.
300      *
301      * This is an alternative to {approve} that can be used as a mitigation for
302      * problems described in {IERC20-approve}.
303      *
304      * Emits an {Approval} event indicating the updated allowance.
305      *
306      * Requirements:
307      *
308      * - `spender` cannot be the zero address.
309      */
310     function increaseAllowance(address spender, uint256 addedValue)
311         public
312         virtual
313         returns (bool)
314     {
315         _approve(
316             _msgSender(),
317             spender,
318             _allowances[_msgSender()][spender] + addedValue
319         );
320         return true;
321     }
322 
323     /**
324      * @dev Atomically decreases the allowance granted to `spender` by the caller.
325      *
326      * This is an alternative to {approve} that can be used as a mitigation for
327      * problems described in {IERC20-approve}.
328      *
329      * Emits an {Approval} event indicating the updated allowance.
330      *
331      * Requirements:
332      *
333      * - `spender` cannot be the zero address.
334      * - `spender` must have allowance for the caller of at least
335      * `subtractedValue`.
336      */
337     function decreaseAllowance(address spender, uint256 subtractedValue)
338         public
339         virtual
340         returns (bool)
341     {
342         require(
343             _allowances[_msgSender()][spender] >= subtractedValue,
344             "ERC20: decreased allowance below zero"
345         );
346         _approve(
347             _msgSender(),
348             spender,
349             _allowances[_msgSender()][spender] - subtractedValue
350         );
351 
352         return true;
353     }
354 
355     /**
356      * @dev Moves tokens `amount` from `sender` to `recipient`.
357      *
358      * This is internal function is equivalent to {transfer}, and can be used to
359      * e.g. implement automatic token fees, slashing mechanisms, etc.
360      *
361      * Emits a {Transfer} event.
362      *
363      * Requirements:
364      *
365      * - `sender` cannot be the zero address.
366      * - `recipient` cannot be the zero address.
367      * - `sender` must have a balance of at least `amount`.
368      */
369     function _transfer(
370         address sender,
371         address recipient,
372         uint256 amount
373     ) internal virtual {
374         require(sender != address(0), "ERC20: transfer from the zero address");
375         require(recipient != address(0), "ERC20: transfer to the zero address");
376 
377         _beforeTokenTransfer(sender, recipient, amount);
378 
379         require(
380             _balances[sender] >= amount,
381             "ERC20: transfer amount exceeds balance"
382         );
383         _balances[sender] -= amount;
384         _balances[recipient] += amount;
385 
386         emit Transfer(sender, recipient, amount);
387     }
388 
389     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
390      * the total supply.
391      *
392      * Emits a {Transfer} event with `from` set to the zero address.
393      *
394      * Requirements:
395      *
396      * - `to` cannot be the zero address.
397      */
398     function _mint(address account, uint256 amount) internal virtual {
399         require(account != address(0), "ERC20: mint to the zero address");
400 
401         _beforeTokenTransfer(address(0), account, amount);
402 
403         _totalSupply += amount;
404         _balances[account] += amount;
405         emit Transfer(address(0), account, amount);
406     }
407 
408     /**
409      * @dev Destroys `amount` tokens from `account`, reducing the
410      * total supply.
411      *
412      * Emits a {Transfer} event with `to` set to the zero address.
413      *
414      * Requirements:
415      *
416      * - `account` cannot be the zero address.
417      * - `account` must have at least `amount` tokens.
418      */
419     function _burn(address account, uint256 amount) internal virtual {
420         require(account != address(0), "ERC20: burn from the zero address");
421 
422         _beforeTokenTransfer(account, address(0), amount);
423 
424         require(
425             _balances[account] >= amount,
426             "ERC20: burn amount exceeds balance"
427         );
428         _balances[account] -= amount;
429         _totalSupply -= amount;
430 
431         emit Transfer(account, address(0), amount);
432     }
433 
434     /**
435      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
436      *
437      * This internal function is equivalent to `approve`, and can be used to
438      * e.g. set automatic allowances for certain subsystems, etc.
439      *
440      * Emits an {Approval} event.
441      *
442      * Requirements:
443      *
444      * - `owner` cannot be the zero address.
445      * - `spender` cannot be the zero address.
446      */
447     function _approve(
448         address owner,
449         address spender,
450         uint256 amount
451     ) internal virtual {
452         require(owner != address(0), "ERC20: approve from the zero address");
453         require(spender != address(0), "ERC20: approve to the zero address");
454 
455         _allowances[owner][spender] = amount;
456         emit Approval(owner, spender, amount);
457     }
458 
459     /**
460      * @dev Hook that is called before any transfer of tokens. This includes
461      * minting and burning.
462      *
463      * Calling conditions:
464      *
465      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
466      * will be to transferred to `to`.
467      * - when `from` is zero, `amount` tokens will be minted for `to`.
468      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
469      * - `from` and `to` are never both zero.
470      *
471      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
472      */
473     function _beforeTokenTransfer(
474         address from,
475         address to,
476         uint256 amount
477     ) internal virtual {}
478 }
479 
480 /**
481  * @dev Contract module which provides a basic access control mechanism, where
482  * there is an account (an owner) that can be granted exclusive access to
483  * specific functions.
484  *
485  * By default, the owner account will be the one that deploys the contract. This
486  * can later be changed with {transferOwnership}.
487  *
488  * This module is used through inheritance. It will make available the modifier
489  * `onlyOwner`, which can be applied to your functions to restrict their use to
490  * the owner.
491  */
492 abstract contract Ownable is Context {
493     address private _owner;
494 
495     event OwnershipTransferred(
496         address indexed previousOwner,
497         address indexed newOwner
498     );
499 
500     /**
501      * @dev Initializes the contract setting the deployer as the initial owner.
502      */
503     constructor() {
504         address msgSender = _msgSender();
505         _owner = msgSender;
506         emit OwnershipTransferred(address(0), msgSender);
507     }
508 
509     /**
510      * @dev Returns the address of the current owner.
511      */
512     function owner() public view virtual returns (address) {
513         return _owner;
514     }
515 
516     /**
517      * @dev Throws if called by any account other than the owner.
518      */
519     modifier onlyOwner() {
520         require(owner() == _msgSender(), "Ownable: caller is not the owner");
521         _;
522     }
523 
524     /**
525      * @dev Leaves the contract without owner. It will not be possible to call
526      * `onlyOwner` functions anymore. Can only be called by the current owner.
527      *
528      * NOTE: Renouncing ownership will leave the contract without an owner,
529      * thereby removing any functionality that is only available to the owner.
530      */
531     function renounceOwnership() public virtual onlyOwner {
532         emit OwnershipTransferred(_owner, address(0));
533         _owner = address(0);
534     }
535 
536     /**
537      * @dev Transfers ownership of the contract to a new account (`newOwner`).
538      * Can only be called by the current owner.
539      */
540     function transferOwnership(address newOwner) public virtual onlyOwner {
541         require(
542             newOwner != address(0),
543             "Ownable: new owner is the zero address"
544         );
545         emit OwnershipTransferred(_owner, newOwner);
546         _owner = newOwner;
547     }
548 }
549 
550 contract MMAON is ERC20, Ownable {
551     constructor(address owner) public ERC20("MMAON", "MMAON") {
552         _mint(owner, 100000000 * 10**18);
553         transferOwnership(owner);
554     }
555 
556     function mint(address recipient, uint256 amount)
557         public
558         onlyOwner
559         returns (bool)
560     {
561         _mint(recipient, amount);
562         return true;
563     }
564 }