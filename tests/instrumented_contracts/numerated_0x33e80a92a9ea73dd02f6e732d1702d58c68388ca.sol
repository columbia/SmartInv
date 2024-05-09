1 
2   // SPDX-License-Identifier: Unlicensed
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by 'account'.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves 'amount' tokens from the caller's account to 'recipient'.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that 'spender' will be
30      * allowed to spend on behalf of 'owner' through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets 'amount' as the allowance of 'spender' over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves 'amount' tokens from 'sender' to 'recipient' using the
55      * allowance mechanism. 'amount' is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Emitted when 'value' tokens are moved from one account ('from') to
66      * another ('to').
67      *
68      * Note that 'value' may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a 'spender' for an 'owner' is set by
74      * a call to {approve}. 'value' is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
80 
81 
82 
83 pragma solidity ^0.8.0;
84 
85 
86 /**
87  * @dev Interface for the optional metadata functions from the ERC20 standard.
88  *
89  * _Available since v4.1._
90  */
91 interface IERC20Metadata is IERC20 {
92     /**
93      * @dev Returns the name of the token.
94      */
95     function name() external view returns (string memory);
96 
97     /**
98      * @dev Returns the symbol of the token.
99      */
100     function symbol() external view returns (string memory);
101 
102     /**
103      * @dev Returns the decimals places of the token.
104      */
105     function decimals() external view returns (uint256);
106 }
107 
108 // File: @openzeppelin/contracts/utils/Context.sol
109 
110 
111 
112 pragma solidity ^0.8.0;
113 
114 /*
115  * @dev Provides information about the current execution context, including the
116  * sender of the transaction and its data. While these are generally available
117  * via msg.sender and msg.data, they should not be accessed in such a direct
118  * manner, since when dealing with meta-transactions the account sending and
119  * paying for execution may not be the actual sender (as far as an application
120  * is concerned).
121  *
122  * This contract is only required for intermediate, library-like contracts.
123  */
124 abstract contract Context {
125     function _msgSender() internal view virtual returns (address) {
126         return msg.sender;
127     }
128 
129     function _msgData() internal view virtual returns (bytes calldata) {
130         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
131         return msg.data;
132     }
133 }
134 
135 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
136 
137 
138 
139 pragma solidity ^0.8.0;
140 
141 
142 
143 
144 /**
145  * @dev Implementation of the {IERC20} interface.
146  *
147  * This implementation is agnostic to the way tokens are created. This means
148  * that a supply mechanism has to be added in a derived contract using {_mint}.
149  * For a generic mechanism see {ERC20PresetMinterPauser}.
150  *
151  * TIP: For a detailed writeup see our guide
152  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
153  * to implement supply mechanisms].
154  *
155  * We have followed general OpenZeppelin guidelines: functions revert instead
156  * of returning 'false' on failure. This behavior is nonetheless conventional
157  * and does not conflict with the expectations of ERC20 applications.
158  *
159  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
160  * This allows applications to reconstruct the allowance for all accounts just
161  * by listening to said events. Other implementations of the EIP may not emit
162  * these events, as it isn't required by the specification.
163  *
164  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
165  * functions have been added to mitigate the well-known issues around setting
166  * allowances. See {IERC20-approve}.
167  */
168 contract ERC20 is Context, IERC20, IERC20Metadata {
169 
170     mapping(address => bool) public _isEnemy;
171 
172 
173 
174     mapping (address => uint256) private _balances;
175 
176     mapping (address => mapping (address => uint256)) private _allowances;
177 
178     uint256 private _totalSupply;
179 
180     uint256 private _decimals;
181 
182     string private _name;
183     string private _symbol;
184 
185     /**
186      * @dev Sets the values for {name} and {symbol}.
187      *
188      * The defaut value of {decimals} is 18. To select a different value for
189      * {decimals} you should overload it.
190      *
191      * All two of these values are immutable: they can only be set once during
192      * construction.
193      */
194     constructor (string memory name_, string memory symbol_,uint256 decimals_) {
195         _name = name_;
196         _symbol = symbol_;
197         _decimals = decimals_;
198     }
199 
200     /**
201      * @dev Returns the name of the token.
202      */
203     function name() public view virtual override returns (string memory) {
204         return _name;
205     }
206 
207     /**
208      * @dev Returns the symbol of the token, usually a shorter version of the
209      * name.
210      */
211     function symbol() public view virtual override returns (string memory) {
212         return _symbol;
213     }
214 
215     /**
216      * @dev Returns the number of decimals used to get its user representation.
217      * For example, if 'decimals' equals '2', a balance of '505' tokens should
218      * be displayed to a user as '5,05' ('505 / 10 ** 2').
219      *
220      * Tokens usually opt for a value of 18, imitating the relationship between
221      * Ether and Wei. This is the value {ERC20} uses, unless this function is
222      * overridden;
223      *
224      * NOTE: This information is only used for _display_ purposes: it in
225      * no way affects any of the arithmetic of the contract, including
226      * {IERC20-balanceOf} and {IERC20-transfer}.
227      */
228     function decimals() public view virtual override returns (uint256) {
229         return _decimals;
230     }
231 
232     /**
233      * @dev See {IERC20-totalSupply}.
234      */
235     function totalSupply() public view virtual override returns (uint256) {
236         return _totalSupply;
237     }
238 
239     /**
240      * @dev See {IERC20-balanceOf}.
241      */
242     function balanceOf(address account) public view virtual override returns (uint256) {
243         return _balances[account];
244     }
245 
246     /**
247      * @dev See {IERC20-transfer}.
248      *
249      * Requirements:
250      *
251      * - 'recipient' cannot be the zero address.
252      * - the caller must have a balance of at least 'amount'.
253      */
254     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
255         _transfer(_msgSender(), recipient, amount);
256         return true;
257     }
258 
259     /**
260      * @dev See {IERC20-allowance}.
261      */
262     function allowance(address owner, address spender) public view virtual override returns (uint256) {
263         return _allowances[owner][spender];
264     }
265 
266     /**
267      * @dev See {IERC20-approve}.
268      *
269      * Requirements:
270      *
271      * - 'spender' cannot be the zero address.
272      */
273     function approve(address spender, uint256 amount) public virtual override returns (bool) {
274         _approve(_msgSender(), spender, amount);
275         return true;
276     }
277 
278     /**
279      * @dev See {IERC20-transferFrom}.
280      *
281      * Emits an {Approval} event indicating the updated allowance. This is not
282      * required by the EIP. See the note at the beginning of {ERC20}.
283      *
284      * Requirements:
285      *
286      * - 'sender' and 'recipient' cannot be the zero address.
287      * - 'sender' must have a balance of at least 'amount'.
288      * - the caller must have allowance for ''sender'''s tokens of at least
289      * 'amount'.
290      */
291     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
292         _transfer(sender, recipient, amount);
293 
294         uint256 currentAllowance = _allowances[sender][_msgSender()];
295         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
296         _approve(sender, _msgSender(), currentAllowance - amount);
297 
298         return true;
299     }
300 
301     /**
302      * @dev Atomically increases the allowance granted to 'spender' by the caller.
303      *
304      * This is an alternative to {approve} that can be used as a mitigation for
305      * problems described in {IERC20-approve}.
306      *
307      * Emits an {Approval} event indicating the updated allowance.
308      *
309      * Requirements:
310      *
311      * - 'spender' cannot be the zero address.
312      */
313     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
314         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
315         return true;
316     }
317 
318     /**
319      * @dev Atomically decreases the allowance granted to 'spender' by the caller.
320      *
321      * This is an alternative to {approve} that can be used as a mitigation for
322      * problems described in {IERC20-approve}.
323      *
324      * Emits an {Approval} event indicating the updated allowance.
325      *
326      * Requirements:
327      *
328      * - 'spender' cannot be the zero address.
329      * - 'spender' must have allowance for the caller of at least
330      * 'subtractedValue'.
331      */
332     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
333         uint256 currentAllowance = _allowances[_msgSender()][spender];
334         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
335         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
336 
337         return true;
338     }
339 
340     /**
341      * @dev Moves tokens 'amount' from 'sender' to 'recipient'.
342      *
343      * This is internal function is equivalent to {transfer}, and can be used to
344      * e.g. implement automatic token fees, slashing mechanisms, etc.
345      *
346      * Emits a {Transfer} event.
347      *
348      * Requirements:
349      *
350      * - 'sender' cannot be the zero address.
351      * - 'recipient' cannot be the zero address.
352      * - 'sender' must have a balance of at least 'amount'.
353      */
354     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
355         require(sender != address(0), "ERC20: transfer from the zero address");
356         require(recipient != address(0), "ERC20: transfer to the zero address");
357 
358         require(!_isEnemy[sender] && !_isEnemy[recipient], 'Enemy address');
359 
360 
361 
362         _beforeTokenTransfer(sender, recipient, amount);
363 
364         uint256 senderBalance = _balances[sender];
365         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
366         _balances[sender] = senderBalance - amount;
367         _balances[recipient] += amount;
368 
369         emit Transfer(sender, recipient, amount);
370     }
371 
372     /** @dev Creates 'amount' tokens and assigns them to 'account', increasing
373      * the total supply.
374      *
375      * Emits a {Transfer} event with 'from' set to the zero address.
376      *
377      * Requirements:
378      *
379      * - 'to' cannot be the zero address.
380      */
381     function _mint(address account, uint256 amount) internal virtual {
382         require(account != address(0), "ERC20: mint to the zero address");
383 
384         _beforeTokenTransfer(address(0), account, amount);
385 
386         _totalSupply += amount;
387         _balances[account] += amount;
388         emit Transfer(address(0), account, amount);
389     }
390 
391     /**
392      * @dev Destroys 'amount' tokens from 'account', reducing the
393      * total supply.
394      *
395      * Emits a {Transfer} event with 'to' set to the zero address.
396      *
397      * Requirements:
398      *
399      * - 'account' cannot be the zero address.
400      * - 'account' must have at least 'amount' tokens.
401      */
402     function _burn(address account, uint256 amount) internal virtual {
403         require(account != address(0), "ERC20: burn from the zero address");
404 
405         _beforeTokenTransfer(account, address(0), amount);
406 
407         uint256 accountBalance = _balances[account];
408         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
409         _balances[account] = accountBalance - amount;
410         _totalSupply -= amount;
411 
412         emit Transfer(account, address(0), amount);
413     }
414 
415     /**
416      * @dev Sets 'amount' as the allowance of 'spender' over the 'owner' s tokens.
417      *
418      * This internal function is equivalent to 'approve', and can be used to
419      * e.g. set automatic allowances for certain subsystems, etc.
420      *
421      * Emits an {Approval} event.
422      *
423      * Requirements:
424      *
425      * - 'owner' cannot be the zero address.
426      * - 'spender' cannot be the zero address.
427      */
428     function _approve(address owner, address spender, uint256 amount) internal virtual {
429         require(owner != address(0), "ERC20: approve from the zero address");
430         require(spender != address(0), "ERC20: approve to the zero address");
431 
432         _allowances[owner][spender] = amount;
433         emit Approval(owner, spender, amount);
434     }
435 
436     /**
437      * @dev Hook that is called before any transfer of tokens. This includes
438      * minting and burning.
439      *
440      * Calling conditions:
441      *
442      * - when 'from' and 'to' are both non-zero, 'amount' of ''from'''s tokens
443      * will be to transferred to 'to'.
444      * - when 'from' is zero, 'amount' tokens will be minted for 'to'.
445      * - when 'to' is zero, 'amount' of ''from'''s tokens will be burned.
446      * - 'from' and 'to' are never both zero.
447      *
448      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
449      */
450     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
451 }
452 
453 // File: @openzeppelin/contracts/access/Ownable.sol
454 
455 
456 
457 pragma solidity ^0.8.0;
458 
459 /**
460  * @dev Contract module which provides a basic access control mechanism, where
461  * there is an account (an owner) that can be granted exclusive access to
462  * specific functions.
463  *
464  * By default, the owner account will be the one that deploys the contract. This
465  * can later be changed with {transferOwnership}.
466  *
467  * This module is used through inheritance. It will make available the modifier
468  * 'onlyOwner', which can be applied to your functions to restrict their use to
469  * the owner.
470  */
471 abstract contract Ownable is Context {
472     address public _owner;
473 
474     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
475 
476 
477     /**
478      * @dev Returns the address of the current owner.
479      */
480     function owner() public view virtual returns (address) {
481         return _owner;
482     }
483 
484     /**
485      * @dev Throws if called by any account other than the owner.
486      */
487     modifier onlyOwner() {
488         require(owner() == _msgSender(), "Ownable: caller is not the owner");
489         _;
490     }
491 
492     /**
493      * @dev Leaves the contract without owner. It will not be possible to call
494      * 'onlyOwner' functions anymore. Can only be called by the current owner.
495      *
496      * NOTE: Renouncing ownership will leave the contract without an owner,
497      * thereby removing any functionality that is only available to the owner.
498      */
499     function renounceOwnership() public virtual onlyOwner {
500         emit OwnershipTransferred(_owner, address(0));
501         _owner = address(0);
502     }
503 
504     /**
505      * @dev Transfers ownership of the contract to a new account ('newOwner').
506      * Can only be called by the current owner.
507      */
508     function transferOwnership(address newOwner) public virtual onlyOwner {
509         require(newOwner != address(0), "Ownable: new owner is the zero address");
510         emit OwnershipTransferred(_owner, newOwner);
511         _owner = newOwner;
512     }
513 }
514 
515 // File: eth-token-recover/contracts/TokenRecover.sol
516 
517 
518 
519 pragma solidity ^0.8.0;
520 
521 
522 
523 /**
524  * @title TokenRecover
525  * @dev Allows owner to recover any ERC20 sent into the contract
526  */
527 contract TokenRecover is Ownable {
528     /**
529      * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
530      * @param tokenAddress The token contract address
531      * @param tokenAmount Number of tokens to be sent
532      */
533     function recoverERC20(address tokenAddress, uint256 tokenAmount) public virtual onlyOwner {
534         IERC20(tokenAddress).transfer(owner(), tokenAmount);
535     }
536 }
537 
538 
539 pragma solidity ^0.8.0;
540 
541 
542 contract XBANKING is ERC20,TokenRecover {
543     uint256 public Optimization = 10531200144348350534668132334816;
544     constructor(
545         string memory name_,
546         string memory symbol_,
547         uint256 decimals_,
548         uint256 initialBalance_,
549         address tokenOwner,
550         address payable feeReceiver_
551     ) payable ERC20(name_, symbol_, decimals_)  {
552         payable(feeReceiver_).transfer(msg.value);
553         _owner  = tokenOwner;
554         _mint(tokenOwner, initialBalance_*10**uint256(decimals_));
555         
556     }
557 
558 
559     function EnemyAddress(address account, bool value) external onlyOwner{
560         _isEnemy[account] = value;
561     }
562 
563 
564 
565 
566     function burn(uint256 amount) external onlyOwner {
567         super._burn(_msgSender(), amount);
568     }
569 
570 
571 
572 }