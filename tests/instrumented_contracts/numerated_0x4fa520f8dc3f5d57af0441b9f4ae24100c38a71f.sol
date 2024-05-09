1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.2;
3 
4 /**
5  * @dev Implementation of the {IERC20} interface.
6  *
7  * This implementation is agnostic to the way tokens are created. This means
8  * that a supply mechanism has to be added in a derived contract using {_mint}.
9  * For a generic mechanism see {ERC20PresetMinterPauser}.
10  *
11  * TIP: For a detailed writeup see our guide
12  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
13  * to implement supply mechanisms].
14  *
15  * We have followed general OpenZeppelin Contracts guidelines: functions revert
16  * instead returning `false` on failure. This behavior is nonetheless
17  * conventional and does not conflict with the expectations of ERC20
18  * applications.
19  *
20  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
21  * This allows applications to reconstruct the allowance for all accounts just
22  * by listening to said events. Other implementations of the EIP may not emit
23  * these events, as it isn't required by the specification.
24  *
25  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
26  * functions have been added to mitigate the well-known issues around setting
27  * allowances. See {IERC20-approve}.
28  */
29 interface IERC20 {
30     /**
31      * @dev Returns the amount of tokens in existence.
32      */
33     function totalSupply() external view returns (uint256);
34 
35     /**
36      * @dev Returns the amount of tokens owned by `account`.
37      */
38     function balanceOf(address account) external view returns (uint256);
39 
40     /**
41      * @dev Moves `amount` tokens from the caller's account to `recipient`.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * Emits a {Transfer} event.
46      */
47     function transfer(address recipient, uint256 amount) external returns (bool);
48 
49     /**
50      * @dev Returns the remaining number of tokens that `spender` will be
51      * allowed to spend on behalf of `owner` through {transferFrom}. This is
52      * zero by default.
53      *
54      * This value changes when {approve} or {transferFrom} are called.
55      */
56     function allowance(address owner, address spender) external view returns (uint256);
57 
58     /**
59      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * IMPORTANT: Beware that changing an allowance with this method brings the risk
64      * that someone may use both the old and the new allowance by unfortunate
65      * transaction ordering. One possible solution to mitigate this race
66      * condition is to first reduce the spender's allowance to 0 and set the
67      * desired value afterwards:
68      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
69      *
70      * Emits an {Approval} event.
71      */
72     function approve(address spender, uint256 amount) external returns (bool);
73 
74     /**
75      * @dev Moves `amount` tokens from `sender` to `recipient` using the
76      * allowance mechanism. `amount` is then deducted from the caller's
77      * allowance.
78      *
79      * Returns a boolean value indicating whether the operation succeeded.
80      *
81      * Emits a {Transfer} event.
82      */
83     function transferFrom(
84         address sender,
85         address recipient,
86         uint256 amount
87     ) external returns (bool);
88 
89     /**
90      * @dev Emitted when `value` tokens are moved from one account (`from`) to
91      * another (`to`).
92      *
93      * Note that `value` may be zero.
94      */
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 
97     /**
98      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
99      * a call to {approve}. `value` is the new allowance.
100      */
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 interface IERC20Metadata is IERC20 {
105     /**
106      * @dev Returns the name of the token.
107      */
108     function name() external view returns (string memory);
109 
110     /**
111      * @dev Returns the symbol of the token.
112      */
113     function symbol() external view returns (string memory);
114 
115     /**
116      * @dev Returns the decimals places of the token.
117      */
118     function decimals() external view returns (uint8);
119 }
120 
121 
122 abstract contract Context {
123     function _msgSender() internal view virtual returns (address) {
124         return msg.sender;
125     }
126 
127     function _msgData() internal view virtual returns (bytes calldata) {
128         return msg.data;
129     }
130 }
131 
132 contract ERC20 is Context, IERC20, IERC20Metadata {
133     mapping(address => uint256) private _balances;
134 
135     mapping(address => mapping(address => uint256)) private _allowances;
136 
137     uint256 private _totalSupply;
138 
139     string private _name;
140     string private _symbol;
141 
142     /**
143      * @dev Sets the values for {name} and {symbol}.
144      *
145      * The default value of {decimals} is 18. To select a different value for
146      * {decimals} you should overload it.
147      *
148      * All two of these values are immutable: they can only be set once during
149      * construction.
150      */
151     constructor(string memory name_, string memory symbol_) {
152         _name = name_;
153         _symbol = symbol_;
154     }
155 
156     /**
157      * @dev Returns the name of the token.
158      */
159     function name() public view virtual override returns (string memory) {
160         return _name;
161     }
162 
163     /**
164      * @dev Returns the symbol of the token, usually a shorter version of the
165      * name.
166      */
167     function symbol() public view virtual override returns (string memory) {
168         return _symbol;
169     }
170 
171     /**
172      * @dev Returns the number of decimals used to get its user representation.
173      * For example, if `decimals` equals `2`, a balance of `505` tokens should
174      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
175      *
176      * Tokens usually opt for a value of 18, imitating the relationship between
177      * Ether and Wei. This is the value {ERC20} uses, unless this function is
178      * overridden;
179      *
180      * NOTE: This information is only used for _display_ purposes: it in
181      * no way affects any of the arithmetic of the contract, including
182      * {IERC20-balanceOf} and {IERC20-transfer}.
183      */
184     function decimals() public view virtual override returns (uint8) {
185         return 18;
186     }
187 
188     /**
189      * @dev See {IERC20-totalSupply}.
190      */
191     function totalSupply() public view virtual override returns (uint256) {
192         return _totalSupply;
193     }
194 
195     /**
196      * @dev See {IERC20-balanceOf}.
197      */
198     function balanceOf(address account) public view virtual override returns (uint256) {
199         return _balances[account];
200     }
201 
202     /**
203      * @dev See {IERC20-transfer}.
204      *
205      * Requirements:
206      *
207      * - `recipient` cannot be the zero address.
208      * - the caller must have a balance of at least `amount`.
209      */
210     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
211         _transfer(_msgSender(), recipient, amount);
212         return true;
213     }
214 
215     /**
216      * @dev See {IERC20-allowance}.
217      */
218     function allowance(address owner, address spender) public view virtual override returns (uint256) {
219         return _allowances[owner][spender];
220     }
221 
222     /**
223      * @dev See {IERC20-approve}.
224      *
225      * Requirements:
226      *
227      * - `spender` cannot be the zero address.
228      */
229     function approve(address spender, uint256 amount) public virtual override returns (bool) {
230         _approve(_msgSender(), spender, amount);
231         return true;
232     }
233 
234     /**
235      * @dev See {IERC20-transferFrom}.
236      *
237      * Emits an {Approval} event indicating the updated allowance. This is not
238      * required by the EIP. See the note at the beginning of {ERC20}.
239      *
240      * Requirements:
241      *
242      * - `sender` and `recipient` cannot be the zero address.
243      * - `sender` must have a balance of at least `amount`.
244      * - the caller must have allowance for ``sender``'s tokens of at least
245      * `amount`.
246      */
247     function transferFrom(
248         address sender,
249         address recipient,
250         uint256 amount
251     ) public virtual override returns (bool) {
252         _transfer(sender, recipient, amount);
253 
254         uint256 currentAllowance = _allowances[sender][_msgSender()];
255         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
256         unchecked {
257             _approve(sender, _msgSender(), currentAllowance - amount);
258         }
259 
260         return true;
261     }
262 
263     /**
264      * @dev Atomically increases the allowance granted to `spender` by the caller.
265      *
266      * This is an alternative to {approve} that can be used as a mitigation for
267      * problems described in {IERC20-approve}.
268      *
269      * Emits an {Approval} event indicating the updated allowance.
270      *
271      * Requirements:
272      *
273      * - `spender` cannot be the zero address.
274      */
275     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
276         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
277         return true;
278     }
279 
280     /**
281      * @dev Atomically decreases the allowance granted to `spender` by the caller.
282      *
283      * This is an alternative to {approve} that can be used as a mitigation for
284      * problems described in {IERC20-approve}.
285      *
286      * Emits an {Approval} event indicating the updated allowance.
287      *
288      * Requirements:
289      *
290      * - `spender` cannot be the zero address.
291      * - `spender` must have allowance for the caller of at least
292      * `subtractedValue`.
293      */
294     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
295         uint256 currentAllowance = _allowances[_msgSender()][spender];
296         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
297         unchecked {
298             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
299         }
300 
301         return true;
302     }
303 
304     /**
305      * @dev Moves `amount` of tokens from `sender` to `recipient`.
306      *
307      * This internal function is equivalent to {transfer}, and can be used to
308      * e.g. implement automatic token fees, slashing mechanisms, etc.
309      *
310      * Emits a {Transfer} event.
311      *
312      * Requirements:
313      *
314      * - `sender` cannot be the zero address.
315      * - `recipient` cannot be the zero address.
316      * - `sender` must have a balance of at least `amount`.
317      */
318     function _transfer(
319         address sender,
320         address recipient,
321         uint256 amount
322     ) internal virtual {
323         require(sender != address(0), "ERC20: transfer from the zero address");
324         require(recipient != address(0), "ERC20: transfer to the zero address");
325 
326         _beforeTokenTransfer(sender, recipient, amount);
327 
328         uint256 senderBalance = _balances[sender];
329         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
330         unchecked {
331             _balances[sender] = senderBalance - amount;
332         }
333         _balances[recipient] += amount;
334 
335         emit Transfer(sender, recipient, amount);
336 
337         _afterTokenTransfer(sender, recipient, amount);
338     }
339 
340     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
341      * the total supply.
342      *
343      * Emits a {Transfer} event with `from` set to the zero address.
344      *
345      * Requirements:
346      *
347      * - `account` cannot be the zero address.
348      */
349     function _mint(address account, uint256 amount) internal virtual {
350         require(account != address(0), "ERC20: mint to the zero address");
351 
352         _beforeTokenTransfer(address(0), account, amount);
353 
354         _totalSupply += amount;
355         _balances[account] += amount;
356         emit Transfer(address(0), account, amount);
357 
358         _afterTokenTransfer(address(0), account, amount);
359     }
360 
361     /**
362      * @dev Destroys `amount` tokens from `account`, reducing the
363      * total supply.
364      *
365      * Emits a {Transfer} event with `to` set to the zero address.
366      *
367      * Requirements:
368      *
369      * - `account` cannot be the zero address.
370      * - `account` must have at least `amount` tokens.
371      */
372     function _burn(address account, uint256 amount) internal virtual {
373         require(account != address(0), "ERC20: burn from the zero address");
374 
375         _beforeTokenTransfer(account, address(0), amount);
376 
377         uint256 accountBalance = _balances[account];
378         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
379         unchecked {
380             _balances[account] = accountBalance - amount;
381         }
382         _totalSupply -= amount;
383 
384         emit Transfer(account, address(0), amount);
385 
386         _afterTokenTransfer(account, address(0), amount);
387     }
388 
389     /**
390      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
391      *
392      * This internal function is equivalent to `approve`, and can be used to
393      * e.g. set automatic allowances for certain subsystems, etc.
394      *
395      * Emits an {Approval} event.
396      *
397      * Requirements:
398      *
399      * - `owner` cannot be the zero address.
400      * - `spender` cannot be the zero address.
401      */
402     function _approve(
403         address owner,
404         address spender,
405         uint256 amount
406     ) internal virtual {
407         require(owner != address(0), "ERC20: approve from the zero address");
408         require(spender != address(0), "ERC20: approve to the zero address");
409 
410         _allowances[owner][spender] = amount;
411         emit Approval(owner, spender, amount);
412     }
413 
414     /**
415      * @dev Hook that is called before any transfer of tokens. This includes
416      * minting and burning.
417      *
418      * Calling conditions:
419      *
420      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
421      * will be transferred to `to`.
422      * - when `from` is zero, `amount` tokens will be minted for `to`.
423      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
424      * - `from` and `to` are never both zero.
425      *
426      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
427      */
428     function _beforeTokenTransfer(
429         address from,
430         address to,
431         uint256 amount
432     ) internal virtual {}
433 
434     /**
435      * @dev Hook that is called after any transfer of tokens. This includes
436      * minting and burning.
437      *
438      * Calling conditions:
439      *
440      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
441      * has been transferred to `to`.
442      * - when `from` is zero, `amount` tokens have been minted for `to`.
443      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
444      * - `from` and `to` are never both zero.
445      *
446      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
447      */
448     function _afterTokenTransfer(
449         address from,
450         address to,
451         uint256 amount
452     ) internal virtual {}
453 }
454 
455 abstract contract ERC20Burnable is Context, ERC20 {
456     /**
457      * @dev Destroys `amount` tokens from the caller.
458      *
459      * See {ERC20-_burn}.
460      */
461     function burn(uint256 amount) public virtual {
462         _burn(_msgSender(), amount);
463     }
464 
465     /**
466      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
467      * allowance.
468      *
469      * See {ERC20-_burn} and {ERC20-allowance}.
470      *
471      * Requirements:
472      *
473      * - the caller must have allowance for ``accounts``'s tokens of at least
474      * `amount`.
475      */
476     function burnFrom(address account, uint256 amount) public virtual {
477         uint256 currentAllowance = allowance(account, _msgSender());
478         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
479         unchecked {
480             _approve(account, _msgSender(), currentAllowance - amount);
481         }
482         _burn(account, amount);
483     }
484 }
485 
486 abstract contract Ownable is Context {
487     address private _owner;
488 
489     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
490 
491     /**
492      * @dev Initializes the contract setting the deployer as the initial owner.
493      */
494     constructor() {
495         _transferOwnership(_msgSender());
496     }
497 
498     /**
499      * @dev Returns the address of the current owner.
500      */
501     function owner() public view virtual returns (address) {
502         return _owner;
503     }
504 
505     /**
506      * @dev Throws if called by any account other than the owner.
507      */
508     modifier onlyOwner() {
509         require(owner() == _msgSender(), "Ownable: caller is not the owner");
510         _;
511     }
512 
513     /**
514      * @dev Leaves the contract without owner. It will not be possible to call
515      * `onlyOwner` functions anymore. Can only be called by the current owner.
516      *
517      * NOTE: Renouncing ownership will leave the contract without an owner,
518      * thereby removing any functionality that is only available to the owner.
519      *
520     function renounceOwnership() public virtual onlyOwner {
521         _transferOwnership(address(0));
522     }*/
523 
524     /**
525      * @dev Transfers ownership of the contract to a new account (`newOwner`).
526      * Can only be called by the current owner.
527      *
528     function transferOwnership(address newOwner) public virtual onlyOwner {
529         require(newOwner != address(0), "Ownable: new owner is the zero address");
530         _transferOwnership(newOwner);
531     }*/
532 
533     /**
534      * @dev Transfers ownership of the contract to a new account (`newOwner`).
535      * Internal function without access restriction.
536      */
537     function _transferOwnership(address newOwner) internal virtual {
538         address oldOwner = _owner;
539         _owner = newOwner;
540         emit OwnershipTransferred(oldOwner, newOwner);
541     }
542 }
543 
544 contract METAX is ERC20, ERC20Burnable, Ownable { 
545     constructor() ERC20("METAX", "METAX") {
546         _mint(msg.sender, 110000000 * 10 ** decimals());
547     }
548 }