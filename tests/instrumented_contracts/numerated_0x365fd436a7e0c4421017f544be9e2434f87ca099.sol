1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.20;
3 
4 /* Smartest contract in the world
5 
6         #@@@          (@@@@@@@@@@       @@%        @@@@@@@%      (@@@@@@@       
7           @@@             %@@.         @@@@/      @@@    #@@@    @@@    @@@@    
8    #@%     @@@            /@@         @@* @@.     (@@     @@@    @@@      @@@   
9    @@@     @@@            *@@        @@@  *@@     *@@@@@@@@(     @@@      #@@   
10            @@@            (@@.     &@@@@@@@@@@@   #@@   @@@      @@@      @@@   
11    @@@    @@@             &@@/     &@@      @@@   @@@,   &@@@   @@@@  ,@@@@&    
12    ,@    @@%               &%      ,@        %%    @#      *@     *@@@@#        
13 
14    Never Go Full Retard!
15    Unless You're BUYING TARD
16    
17    https://tard.life
18    Twitter: https://twitter.com/fulltardlife
19    Telegram: https://t.me/fulltardlife
20 */
21 
22 /**
23  * @dev Provides information about the current execution context, including the
24  * sender of the transaction and its data. While these are generally available
25  * via msg.sender and msg.data, they should not be accessed in such a direct
26  * manner, since when dealing with meta-transactions the account sending and
27  * paying for execution may not be the actual sender (as far as an application
28  * is concerned).
29  *
30  * This contract is only required for intermediate, library-like contracts.
31  */
32 abstract contract Context {
33     function _msgSender() internal view virtual returns (address) {
34         return msg.sender;
35     }
36 
37     function _msgData() internal view virtual returns (bytes calldata) {
38         return msg.data;
39     }
40 }
41 
42 /**
43  * @dev Contract module which provides a basic access control mechanism, where
44  * there is an account (an owner) that can be granted exclusive access to
45  * specific functions.
46  *
47  * By default, the owner account will be the one that deploys the contract. This
48  * can later be changed with {transferOwnership}.
49  *
50  * This module is used through inheritance. It will make available the modifier
51  * `onlyOwner`, which can be applied to your functions to restrict their use to
52  * the owner.
53  */
54 abstract contract Ownable is Context {
55     address private _owner;
56 
57     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 
59     /**
60      * @dev Initializes the contract setting the deployer as the initial owner.
61      */
62     constructor(address initialOwner) {
63         _transferOwnership(initialOwner);
64     }
65 
66     /**
67      * @dev Throws if called by any account other than the owner.
68      */
69     modifier onlyOwner() {
70         _checkOwner();
71         _;
72     }
73 
74     /**
75      * @dev Returns the address of the current owner.
76      */
77     function owner() public view virtual returns (address) {
78         return _owner;
79     }
80 
81     /**
82      * @dev Throws if the sender is not the owner.
83      */
84     function _checkOwner() internal view virtual {
85         require(owner() == _msgSender(), "Ownable: caller is not the owner");
86     }
87 
88     /**
89      * @dev Leaves the contract without owner. It will not be possible to call
90      * `onlyOwner` functions. Can only be called by the current owner.
91      *
92      * NOTE: Renouncing ownership will leave the contract without an owner,
93      * thereby disabling any functionality that is only available to the owner.
94      */
95     function renounceOwnership() public virtual onlyOwner {
96         _transferOwnership(address(0));
97     }
98 
99     /**
100      * @dev Transfers ownership of the contract to a new account (`newOwner`).
101      * Can only be called by the current owner.
102      */
103     function transferOwnership(address newOwner) public virtual onlyOwner {
104         require(newOwner != address(0), "Ownable: new owner is the zero address");
105         _transferOwnership(newOwner);
106     }
107 
108     /**
109      * @dev Transfers ownership of the contract to a new account (`newOwner`).
110      * Internal function without access restriction.
111      */
112     function _transferOwnership(address newOwner) internal virtual {
113         address oldOwner = _owner;
114         _owner = newOwner;
115         emit OwnershipTransferred(oldOwner, newOwner);
116     }
117 }
118 
119 /**
120  * @dev Interface of the ERC20 standard as defined in the EIP.
121  */
122 interface IERC20 {
123     /**
124      * @dev Emitted when `value` tokens are moved from one account (`from`) to
125      * another (`to`).
126      *
127      * Note that `value` may be zero.
128      */
129     event Transfer(address indexed from, address indexed to, uint256 value);
130 
131     /**
132      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
133      * a call to {approve}. `value` is the new allowance.
134      */
135     event Approval(address indexed owner, address indexed spender, uint256 value);
136 
137     /**
138      * @dev Returns the amount of tokens in existence.
139      */
140     function totalSupply() external view returns (uint256);
141 
142     /**
143      * @dev Returns the amount of tokens owned by `account`.
144      */
145     function balanceOf(address account) external view returns (uint256);
146 
147     /**
148      * @dev Moves `amount` tokens from the caller's account to `to`.
149      *
150      * Returns a boolean value indicating whether the operation succeeded.
151      *
152      * Emits a {Transfer} event.
153      */
154     function transfer(address to, uint256 amount) external returns (bool);
155 
156     /**
157      * @dev Returns the remaining number of tokens that `spender` will be
158      * allowed to spend on behalf of `owner` through {transferFrom}. This is
159      * zero by default.
160      *
161      * This value changes when {approve} or {transferFrom} are called.
162      */
163     function allowance(address owner, address spender) external view returns (uint256);
164 
165     /**
166      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
167      *
168      * Returns a boolean value indicating whether the operation succeeded.
169      *
170      * IMPORTANT: Beware that changing an allowance with this method brings the risk
171      * that someone may use both the old and the new allowance by unfortunate
172      * transaction ordering. One possible solution to mitigate this race
173      * condition is to first reduce the spender's allowance to 0 and set the
174      * desired value afterwards:
175      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
176      *
177      * Emits an {Approval} event.
178      */
179     function approve(address spender, uint256 amount) external returns (bool);
180 
181     /**
182      * @dev Moves `amount` tokens from `from` to `to` using the
183      * allowance mechanism. `amount` is then deducted from the caller's
184      * allowance.
185      *
186      * Returns a boolean value indicating whether the operation succeeded.
187      *
188      * Emits a {Transfer} event.
189      */
190     function transferFrom(address from, address to, uint256 amount) external returns (bool);
191 }
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
215 /**
216  * @dev Implementation of the {IERC20} interface.
217  *
218  * This implementation is agnostic to the way tokens are created. This means
219  * that a supply mechanism has to be added in a derived contract using {_mint}.
220  *
221  * TIP: For a detailed writeup see our guide
222  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
223  * to implement supply mechanisms].
224  *
225  * The default value of {decimals} is 18. To change this, you should override
226  * this function so it returns a different value.
227  *
228  * We have followed general OpenZeppelin Contracts guidelines: functions revert
229  * instead returning `false` on failure. This behavior is nonetheless
230  * conventional and does not conflict with the expectations of ERC20
231  * applications.
232  *
233  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
234  * This allows applications to reconstruct the allowance for all accounts just
235  * by listening to said events. Other implementations of the EIP may not emit
236  * these events, as it isn't required by the specification.
237  *
238  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
239  * functions have been added to mitigate the well-known issues around setting
240  * allowances. See {IERC20-approve}.
241  */
242 contract ERC20 is Context, IERC20, IERC20Metadata {
243     mapping(address => uint256) private _balances;
244 
245     mapping(address => mapping(address => uint256)) private _allowances;
246 
247     uint256 private _totalSupply;
248 
249     string private _name;
250     string private _symbol;
251 
252     /**
253      * @dev Sets the values for {name} and {symbol}.
254      *
255      * All two of these values are immutable: they can only be set once during
256      * construction.
257      */
258     constructor(string memory name_, string memory symbol_) {
259         _name = name_;
260         _symbol = symbol_;
261     }
262 
263     /**
264      * @dev Returns the name of the token.
265      */
266     function name() public view virtual returns (string memory) {
267         return _name;
268     }
269 
270     /**
271      * @dev Returns the symbol of the token, usually a shorter version of the
272      * name.
273      */
274     function symbol() public view virtual returns (string memory) {
275         return _symbol;
276     }
277 
278     /**
279      * @dev Returns the number of decimals used to get its user representation.
280      * For example, if `decimals` equals `2`, a balance of `505` tokens should
281      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
282      *
283      * Tokens usually opt for a value of 18, imitating the relationship between
284      * Ether and Wei. This is the default value returned by this function, unless
285      * it's overridden.
286      *
287      * NOTE: This information is only used for _display_ purposes: it in
288      * no way affects any of the arithmetic of the contract, including
289      * {IERC20-balanceOf} and {IERC20-transfer}.
290      */
291     function decimals() public view virtual returns (uint8) {
292         return 18;
293     }
294 
295     /**
296      * @dev See {IERC20-totalSupply}.
297      */
298     function totalSupply() public view virtual returns (uint256) {
299         return _totalSupply;
300     }
301 
302     /**
303      * @dev See {IERC20-balanceOf}.
304      */
305     function balanceOf(address account) public view virtual returns (uint256) {
306         return _balances[account];
307     }
308 
309     /**
310      * @dev See {IERC20-transfer}.
311      *
312      * Requirements:
313      *
314      * - `to` cannot be the zero address.
315      * - the caller must have a balance of at least `amount`.
316      */
317     function transfer(address to, uint256 amount) public virtual returns (bool) {
318         address owner = _msgSender();
319         _transfer(owner, to, amount);
320         return true;
321     }
322 
323     /**
324      * @dev See {IERC20-allowance}.
325      */
326     function allowance(address owner, address spender) public view virtual returns (uint256) {
327         return _allowances[owner][spender];
328     }
329 
330     /**
331      * @dev See {IERC20-approve}.
332      *
333      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
334      * `transferFrom`. This is semantically equivalent to an infinite approval.
335      *
336      * Requirements:
337      *
338      * - `spender` cannot be the zero address.
339      */
340     function approve(address spender, uint256 amount) public virtual returns (bool) {
341         address owner = _msgSender();
342         _approve(owner, spender, amount);
343         return true;
344     }
345 
346     /**
347      * @dev See {IERC20-transferFrom}.
348      *
349      * Emits an {Approval} event indicating the updated allowance. This is not
350      * required by the EIP. See the note at the beginning of {ERC20}.
351      *
352      * NOTE: Does not update the allowance if the current allowance
353      * is the maximum `uint256`.
354      *
355      * Requirements:
356      *
357      * - `from` and `to` cannot be the zero address.
358      * - `from` must have a balance of at least `amount`.
359      * - the caller must have allowance for ``from``'s tokens of at least
360      * `amount`.
361      */
362     function transferFrom(address from, address to, uint256 amount) public virtual returns (bool) {
363         address spender = _msgSender();
364         _spendAllowance(from, spender, amount);
365         _transfer(from, to, amount);
366         return true;
367     }
368 
369     /**
370      * @dev Atomically increases the allowance granted to `spender` by the caller.
371      *
372      * This is an alternative to {approve} that can be used as a mitigation for
373      * problems described in {IERC20-approve}.
374      *
375      * Emits an {Approval} event indicating the updated allowance.
376      *
377      * Requirements:
378      *
379      * - `spender` cannot be the zero address.
380      */
381     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
382         address owner = _msgSender();
383         _approve(owner, spender, allowance(owner, spender) + addedValue);
384         return true;
385     }
386 
387     /**
388      * @dev Atomically decreases the allowance granted to `spender` by the caller.
389      *
390      * This is an alternative to {approve} that can be used as a mitigation for
391      * problems described in {IERC20-approve}.
392      *
393      * Emits an {Approval} event indicating the updated allowance.
394      *
395      * Requirements:
396      *
397      * - `spender` cannot be the zero address.
398      * - `spender` must have allowance for the caller of at least
399      * `subtractedValue`.
400      */
401     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
402         address owner = _msgSender();
403         uint256 currentAllowance = allowance(owner, spender);
404         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
405         unchecked {
406             _approve(owner, spender, currentAllowance - subtractedValue);
407         }
408 
409         return true;
410     }
411 
412     /**
413      * @dev Moves `amount` of tokens from `from` to `to`.
414      *
415      * This internal function is equivalent to {transfer}, and can be used to
416      * e.g. implement automatic token fees, slashing mechanisms, etc.
417      *
418      * Emits a {Transfer} event.
419      *
420      * NOTE: This function is not virtual, {_update} should be overridden instead.
421      */
422     function _transfer(address from, address to, uint256 amount) internal {
423         require(from != address(0), "ERC20: transfer from the zero address");
424         require(to != address(0), "ERC20: transfer to the zero address");
425         _update(from, to, amount);
426     }
427 
428     /**
429      * @dev Transfers `amount` of tokens from `from` to `to`, or alternatively mints (or burns) if `from` (or `to`) is
430      * the zero address. All customizations to transfers, mints, and burns should be done by overriding this function.
431      *
432      * Emits a {Transfer} event.
433      */
434     function _update(address from, address to, uint256 amount) internal virtual {
435         if (from == address(0)) {
436             _totalSupply += amount;
437         } else {
438             uint256 fromBalance = _balances[from];
439             require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
440             unchecked {
441                 // Overflow not possible: amount <= fromBalance <= totalSupply.
442                 _balances[from] = fromBalance - amount;
443             }
444         }
445 
446         if (to == address(0)) {
447             unchecked {
448                 // Overflow not possible: amount <= totalSupply or amount <= fromBalance <= totalSupply.
449                 _totalSupply -= amount;
450             }
451         } else {
452             unchecked {
453                 // Overflow not possible: balance + amount is at most totalSupply, which we know fits into a uint256.
454                 _balances[to] += amount;
455             }
456         }
457 
458         emit Transfer(from, to, amount);
459     }
460 
461     /**
462      * @dev Creates `amount` tokens and assigns them to `account`, by transferring it from address(0).
463      * Relies on the `_update` mechanism
464      *
465      * Emits a {Transfer} event with `from` set to the zero address.
466      *
467      * NOTE: This function is not virtual, {_update} should be overridden instead.
468      */
469     function _mint(address account, uint256 amount) internal {
470         require(account != address(0), "ERC20: mint to the zero address");
471         _update(address(0), account, amount);
472     }
473 
474     /**
475      * @dev Destroys `amount` tokens from `account`, by transferring it to address(0).
476      * Relies on the `_update` mechanism.
477      *
478      * Emits a {Transfer} event with `to` set to the zero address.
479      *
480      * NOTE: This function is not virtual, {_update} should be overridden instead
481      */
482     function _burn(address account, uint256 amount) internal {
483         require(account != address(0), "ERC20: burn from the zero address");
484         _update(account, address(0), amount);
485     }
486 
487     /**
488      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
489      *
490      * This internal function is equivalent to `approve`, and can be used to
491      * e.g. set automatic allowances for certain subsystems, etc.
492      *
493      * Emits an {Approval} event.
494      *
495      * Requirements:
496      *
497      * - `owner` cannot be the zero address.
498      * - `spender` cannot be the zero address.
499      */
500     function _approve(address owner, address spender, uint256 amount) internal virtual {
501         require(owner != address(0), "ERC20: approve from the zero address");
502         require(spender != address(0), "ERC20: approve to the zero address");
503 
504         _allowances[owner][spender] = amount;
505         emit Approval(owner, spender, amount);
506     }
507 
508     /**
509      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
510      *
511      * Does not update the allowance amount in case of infinite allowance.
512      * Revert if not enough allowance is available.
513      *
514      * Might emit an {Approval} event.
515      */
516     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
517         uint256 currentAllowance = allowance(owner, spender);
518         if (currentAllowance != type(uint256).max) {
519             require(currentAllowance >= amount, "ERC20: insufficient allowance");
520             unchecked {
521                 _approve(owner, spender, currentAllowance - amount);
522             }
523         }
524     }
525 }
526 
527 /**
528  * @dev Extension of {ERC20} that allows token holders to destroy both their own
529  * tokens and those that they have an allowance for, in a way that can be
530  * recognized off-chain (via event analysis).
531  */
532 abstract contract ERC20Burnable is Context, ERC20 {
533     /**
534      * @dev Destroys `amount` tokens from the caller.
535      *
536      * See {ERC20-_burn}.
537      */
538     function burn(uint256 amount) public virtual {
539         _burn(_msgSender(), amount);
540     }
541 
542     /**
543      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
544      * allowance.
545      *
546      * See {ERC20-_burn} and {ERC20-allowance}.
547      *
548      * Requirements:
549      *
550      * - the caller must have allowance for ``accounts``'s tokens of at least
551      * `amount`.
552      */
553     function burnFrom(address account, uint256 amount) public virtual {
554         _spendAllowance(account, _msgSender(), amount);
555         _burn(account, amount);
556     }
557 }
558 
559 /*
560     TARD
561     Never Go Full Retard!
562     Unless You're BUYING TARD
563 
564     https://tard.life
565     Twitter: https://twitter.com/fulltardlife
566     Telegram: https://t.me/fulltardlife
567 */
568 
569 contract Tard is ERC20, ERC20Burnable, Ownable {
570     constructor(
571         uint256 _totalSupply,
572         address _teamAddr,
573         uint256 _teamPer,
574         address _marketingAddr,
575         uint256 _marketingPer
576     ) ERC20("Full Tard", "TARD") Ownable(msg.sender){
577         uint256 t = _totalSupply * _teamPer / 100;
578         _mint(_teamAddr, t);
579         uint256 m = _totalSupply * _marketingPer / 100;
580         _mint(_marketingAddr, m);
581         _mint(msg.sender, _totalSupply - m - t);
582     }
583 }