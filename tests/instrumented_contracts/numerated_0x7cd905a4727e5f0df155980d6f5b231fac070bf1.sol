1 /**
2  *Submitted for verification at Etherscan.io on 2023-05-05
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity =0.8.4;
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
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 pragma solidity =0.8.4;
31 
32 /**
33  * @dev Interface of the ERC20 standard as defined in the EIP.
34  */
35 interface IERC20 {
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
47      * @dev Moves `amount` tokens from the caller's account to `recipient`.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * Emits a {Transfer} event.
52      */
53     function transfer(address recipient, uint256 amount)
54         external
55         returns (bool);
56 
57     /**
58      * @dev Returns the remaining number of tokens that `spender` will be
59      * allowed to spend on behalf of `owner` through {transferFrom}. This is
60      * zero by default.
61      *
62      * This value changes when {approve} or {transferFrom} are called.
63      */
64     function allowance(address owner, address spender)
65         external
66         view
67         returns (uint256);
68 
69     /**
70      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
71      *
72      * Returns a boolean value indicating whether the operation succeeded.
73      *
74      * IMPORTANT: Beware that changing an allowance with this method brings the risk
75      * that someone may use both the old and the new allowance by unfortunate
76      * transaction ordering. One possible solution to mitigate this race
77      * condition is to first reduce the spender's allowance to 0 and set the
78      * desired value afterwards:
79      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
80      *
81      * Emits an {Approval} event.
82      */
83     function approve(address spender, uint256 amount) external returns (bool);
84 
85     /**
86      * @dev Moves `amount` tokens from `sender` to `recipient` using the
87      * allowance mechanism. `amount` is then deducted from the caller's
88      * allowance.
89      *
90      * Returns a boolean value indicating whether the operation succeeded.
91      *
92      * Emits a {Transfer} event.
93      */
94     function transferFrom(
95         address sender,
96         address recipient,
97         uint256 amount
98     ) external returns (bool);
99 
100     /**
101      * @dev Emitted when `value` tokens are moved from one account (`from`) to
102      * another (`to`).
103      *
104      * Note that `value` may be zero.
105      */
106     event Transfer(address indexed from, address indexed to, uint256 value);
107 
108     /**
109      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
110      * a call to {approve}. `value` is the new allowance.
111      */
112     event Approval(
113         address indexed owner,
114         address indexed spender,
115         uint256 value
116     );
117 }
118 
119 pragma solidity =0.8.4;
120 
121 /**
122  * @dev Contract module which provides a basic access control mechanism, where
123  * there is an account (an owner) that can be granted exclusive access to
124  * specific functions.
125  *
126  * By default, the owner account will be the one that deploys the contract. This
127  * can later be changed with {transferOwnership}.
128  *
129  * This module is used through inheritance. It will make available the modifier
130  * `onlyOwner`, which can be applied to your functions to restrict their use to
131  * the owner.
132  */
133 contract Ownable is Context {
134     address private _owner;
135 
136     event OwnershipTransferred(
137         address indexed previousOwner,
138         address indexed newOwner
139     );
140 
141     /**
142      * @dev Initializes the contract setting the deployer as the initial owner.
143      */
144     constructor() {
145         address msgSender = _msgSender();
146         _owner = msgSender;
147         emit OwnershipTransferred(address(0), msgSender);
148     }
149 
150     /**
151      * @dev Returns the address of the current owner.
152      */
153     function owner() public view returns (address) {
154         return _owner;
155     }
156 
157     /**
158      * @dev Throws if called by any account other than the owner.
159      */
160     modifier onlyOwner() {
161         require(_owner == _msgSender(), "Ownable: caller is not the owner");
162         _;
163     }
164 
165     /**
166      * @dev Leaves the contract without owner. It will not be possible to call
167      * `onlyOwner` functions anymore. Can only be called by the current owner.
168      *
169      * NOTE: Renouncing ownership will leave the contract without an owner,
170      * thereby removing any functionality that is only available to the owner.
171      */
172     function renounceOwnership() public virtual onlyOwner {
173         emit OwnershipTransferred(_owner, address(0));
174         _owner = address(0);
175     }
176 
177     /**
178      * @dev Transfers ownership of the contract to a new account (`newOwner`).
179      * Can only be called by the current owner.
180      */
181     function transferOwnership(address newOwner) public virtual onlyOwner {
182         require(
183             newOwner != address(0),
184             "Ownable: new owner is the zero address"
185         );
186         emit OwnershipTransferred(_owner, newOwner);
187         _owner = newOwner;
188     }
189 }
190 
191 pragma solidity =0.8.4;
192 
193 contract AntiWhale is Ownable {
194     uint256 public startDate;
195     uint256 public endDate;
196     uint256 public limitWhale;
197     bool public antiWhaleActivated;
198 
199     function activateAntiWhale() public onlyOwner {
200         require(antiWhaleActivated == false);
201         antiWhaleActivated = true;
202     }
203 
204     function deActivateAntiWhale() public onlyOwner {
205         require(antiWhaleActivated == true);
206         antiWhaleActivated = false;
207     }
208 
209     function setAntiWhale(uint256 _startDate, uint256 _endDate, uint256 _limitWhale) public onlyOwner {
210         startDate = _startDate;
211         endDate = _endDate;
212         limitWhale = _limitWhale;
213         antiWhaleActivated = true;
214     }
215 
216     function isWhale(uint256 amount) public view returns (bool) {
217         if (
218             msg.sender == owner() ||
219             antiWhaleActivated == false ||
220             amount <= limitWhale
221         ) return false;
222 
223         if (block.timestamp >= startDate && block.timestamp <= endDate)
224             return true;
225 
226         return false;
227     }
228 }
229 
230 pragma solidity =0.8.4;
231 
232 /**
233  * @dev Implementation of the {IERC20} interface.
234  *
235  * This implementation is agnostic to the way tokens are created. This means
236  * that a supply mechanism has to be added in a derived contract using {_mint}.
237  * For a generic mechanism see {ERC20PresetMinterPauser}.
238  *
239  * TIP: For a detailed writeup see our guide
240  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
241  * to implement supply mechanisms].
242  *
243  * We have followed general OpenZeppelin guidelines: functions revert instead
244  * of returning `false` on failure. This behavior is nonetheless conventional
245  * and does not conflict with the expectations of ERC20 applications.
246  *
247  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
248  * This allows applications to reconstruct the allowance for all accounts just
249  * by listening to said events. Other implementations of the EIP may not emit
250  * these events, as it isn't required by the specification.
251  *
252  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
253  * functions have been added to mitigate the well-known issues around setting
254  * allowances. See {IERC20-approve}.
255  */
256 contract Ferrari is Context, IERC20, Ownable, AntiWhale {
257     mapping(address => uint256) private _balances;
258 
259     mapping(address => mapping(address => uint256)) private _allowances;
260 
261     string private _name = "Ferrari";
262     string private _symbol = "RARI";
263     uint8 private _decimals = 18;
264 
265     uint256 constant maxCap = 4200000000 * (10**18);
266     uint256 private _totalSupply = maxCap;
267 
268     /**
269      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
270      * a default value of 8.
271      *
272      * To select a different value for {decimals}, use {_setupDecimals}.
273      *
274      * All three of these values are immutable: they can only be set once during
275      * construction.
276      */
277     constructor() {
278         _balances[msg.sender] = maxCap; //At the moment of creation all tokens will go to the owner.
279     }
280 
281     /**
282      * @dev Returns the name of the token.
283      */
284     function name() public view virtual returns (string memory) {
285         return _name;
286     }
287 
288     /**
289      * @dev Returns the symbol of the token, usually a shorter version of the
290      * name.
291      */
292     function symbol() public view virtual returns (string memory) {
293         return _symbol;
294     }
295 
296     /**
297      * @dev Returns the number of decimals used to get its user representation.
298      * For example, if `decimals` equals `2`, a balance of `505` tokens should
299      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
300      *
301      * Tokens usually opt for a value of 18, imitating the relationship between
302      * Ether and Wei. This is the value {ERC20} uses, unless this function is
303      * overridden;
304      *
305      * NOTE: This information is only used for _display_ purposes: it in
306      * no way affects any of the arithmetic of the contract, including
307      * {IERC20-balanceOf} and {IERC20-transfer}.
308      */
309     function decimals() public view virtual returns (uint8) {
310         return 18;
311     }
312 
313     /**
314      * @dev See {IERC20-totalSupply}.
315      */
316     function totalSupply() public view virtual override returns (uint256) {
317         return _totalSupply;
318     }
319 
320     /**
321      * @dev See {IERC20-balanceOf}.
322      */
323     function balanceOf(address account)
324         public
325         view
326         virtual
327         override
328         returns (uint256)
329     {
330         return _balances[account];
331     }
332 
333     /**
334      * @dev See {IERC20-transfer}.
335      *
336      * Requirements:
337      *
338      * - `recipient` cannot be the zero address.
339      * - the caller must have a balance of at least `amount`.
340      */
341     function transfer(address recipient, uint256 amount)
342         public
343         virtual
344         override
345         returns (bool)
346     {
347         _transfer(_msgSender(), recipient, amount);
348         return true;
349     }
350 
351     /**
352      * @dev See {IERC20-allowance}.
353      */
354     function allowance(address owner, address spender)
355         public
356         view
357         virtual
358         override
359         returns (uint256)
360     {
361         return _allowances[owner][spender];
362     }
363 
364     /**
365      * @dev See {IERC20-approve}.
366      *
367      * Requirements:
368      *
369      * - `spender` cannot be the zero address.
370      */
371     function approve(address spender, uint256 amount)
372         public
373         virtual
374         override
375         returns (bool)
376     {
377         _approve(_msgSender(), spender, amount);
378         return true;
379     }
380 
381     /**
382      * @dev See {IERC20-transferFrom}.
383      *
384      * Emits an {Approval} event indicating the updated allowance. This is not
385      * required by the EIP. See the note at the beginning of {ERC20}.
386      *
387      * Requirements:
388      *
389      * - `sender` and `recipient` cannot be the zero address.
390      * - `sender` must have a balance of at least `amount`.
391      * - the caller must have allowance for ``sender``'s tokens of at least
392      * `amount`.
393      */
394     function transferFrom(
395         address sender,
396         address recipient,
397         uint256 amount
398     ) public virtual override returns (bool) {
399         _transfer(sender, recipient, amount);
400 
401         uint256 currentAllowance = _allowances[sender][_msgSender()];
402         require(
403             currentAllowance >= amount,
404             "ERC20: transfer amount exceeds allowance"
405         );
406         _approve(sender, _msgSender(), currentAllowance - amount);
407 
408         return true;
409     }
410 
411     /**
412      * @dev Atomically increases the allowance granted to `spender` by the caller.
413      *
414      * This is an alternative to {approve} that can be used as a mitigation for
415      * problems described in {IERC20-approve}.
416      *
417      * Emits an {Approval} event indicating the updated allowance.
418      *
419      * Requirements:
420      *
421      * - `spender` cannot be the zero address.
422      */
423     function increaseAllowance(address spender, uint256 addedValue)
424         public
425         virtual
426         returns (bool)
427     {
428         _approve(
429             _msgSender(),
430             spender,
431             _allowances[_msgSender()][spender] + addedValue
432         );
433         return true;
434     }
435 
436     /**
437      * @dev Atomically decreases the allowance granted to `spender` by the caller.
438      *
439      * This is an alternative to {approve} that can be used as a mitigation for
440      * problems described in {IERC20-approve}.
441      *
442      * Emits an {Approval} event indicating the updated allowance.
443      *
444      * Requirements:
445      *
446      * - `spender` cannot be the zero address.
447      * - `spender` must have allowance for the caller of at least
448      * `subtractedValue`.
449      */
450     function decreaseAllowance(address spender, uint256 subtractedValue)
451         public
452         virtual
453         returns (bool)
454     {
455         uint256 currentAllowance = _allowances[_msgSender()][spender];
456         require(
457             currentAllowance >= subtractedValue,
458             "ERC20: decreased allowance below zero"
459         );
460         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
461 
462         return true;
463     }
464 
465     /**
466      * @dev Moves tokens `amount` from `sender` to `recipient`.
467      *
468      * This is internal function is equivalent to {transfer}, and can be used to
469      * e.g. implement automatic token fees, slashing mechanisms, etc.
470      *
471      * Emits a {Transfer} event.
472      *
473      * Requirements:
474      *
475      * - `sender` cannot be the zero address.
476      * - `recipient` cannot be the zero address.
477      * - `sender` must have a balance of at least `amount`.
478      */
479     function _transfer(
480         address sender,
481         address recipient,
482         uint256 amount
483     ) internal virtual {
484         require(sender != address(0), "ERC20: transfer from the zero address");
485 
486         if (recipient == address(0)) {
487             _burn(sender, amount);
488         } else {
489             require(!isWhale(amount), "Error: No time for whales!");
490 
491             uint256 senderBalance = _balances[sender];
492             require(
493                 senderBalance >= amount,
494                 "ERC20: transfer amount exceeds balance"
495             );
496             _balances[sender] = senderBalance - amount;
497             _balances[recipient] += amount;
498 
499             emit Transfer(sender, recipient, amount);
500         }
501     }
502 
503     /**
504      * @dev Destroys `amount` tokens from `account`, reducing the
505      * total supply.
506      *
507      * Emits a {Transfer} event with `to` set to the zero address.
508      *
509      * Requirements:
510      *
511      * - `account` cannot be the zero address.
512      * - `account` must have at least `amount` tokens.
513      */
514     function _burn(address account, uint256 amount) internal virtual {
515         require(account != address(0), "ERC20: burn from the zero address");
516 
517         uint256 accountBalance = _balances[account];
518         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
519         _balances[account] = accountBalance - amount;
520         _totalSupply -= amount;
521 
522         emit Transfer(account, address(0), amount);
523     }
524 
525     /**
526      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
527      *
528      * This internal function is equivalent to `approve`, and can be used to
529      * e.g. set automatic allowances for certain subsystems, etc.
530      *
531      * Emits an {Approval} event.
532      *
533      * Requirements:
534      *
535      * - `owner` cannot be the zero address.
536      * - `spender` cannot be the zero address.
537      */
538     function _approve(
539         address owner,
540         address spender,
541         uint256 amount
542     ) internal virtual {
543         require(owner != address(0), "ERC20: approve from the zero address");
544         require(spender != address(0), "ERC20: approve to the zero address");
545 
546         _allowances[owner][spender] = amount;
547         emit Approval(owner, spender, amount);
548     }
549 }