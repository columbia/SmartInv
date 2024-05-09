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
170 
171 
172     mapping (address => uint256) private _balances;
173 
174     mapping (address => mapping (address => uint256)) private _allowances;
175 
176     uint256 private _totalSupply;
177 
178     uint256 private _decimals;
179 
180     string private _name;
181     string private _symbol;
182 
183     /**
184      * @dev Sets the values for {name} and {symbol}.
185      *
186      * The defaut value of {decimals} is 18. To select a different value for
187      * {decimals} you should overload it.
188      *
189      * All two of these values are immutable: they can only be set once during
190      * construction.
191      */
192     constructor (string memory name_, string memory symbol_,uint256 decimals_) {
193         _name = name_;
194         _symbol = symbol_;
195         _decimals = decimals_;
196     }
197 
198     /**
199      * @dev Returns the name of the token.
200      */
201     function name() public view virtual override returns (string memory) {
202         return _name;
203     }
204 
205     /**
206      * @dev Returns the symbol of the token, usually a shorter version of the
207      * name.
208      */
209     function symbol() public view virtual override returns (string memory) {
210         return _symbol;
211     }
212 
213     /**
214      * @dev Returns the number of decimals used to get its user representation.
215      * For example, if 'decimals' equals '2', a balance of '505' tokens should
216      * be displayed to a user as '5,05' ('505 / 10 ** 2').
217      *
218      * Tokens usually opt for a value of 18, imitating the relationship between
219      * Ether and Wei. This is the value {ERC20} uses, unless this function is
220      * overridden;
221      *
222      * NOTE: This information is only used for _display_ purposes: it in
223      * no way affects any of the arithmetic of the contract, including
224      * {IERC20-balanceOf} and {IERC20-transfer}.
225      */
226     function decimals() public view virtual override returns (uint256) {
227         return _decimals;
228     }
229 
230     /**
231      * @dev See {IERC20-totalSupply}.
232      */
233     function totalSupply() public view virtual override returns (uint256) {
234         return _totalSupply;
235     }
236 
237     /**
238      * @dev See {IERC20-balanceOf}.
239      */
240     function balanceOf(address account) public view virtual override returns (uint256) {
241         return _balances[account];
242     }
243 
244     /**
245      * @dev See {IERC20-transfer}.
246      *
247      * Requirements:
248      *
249      * - 'recipient' cannot be the zero address.
250      * - the caller must have a balance of at least 'amount'.
251      */
252     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
253         _transfer(_msgSender(), recipient, amount);
254         return true;
255     }
256 
257     /**
258      * @dev See {IERC20-allowance}.
259      */
260     function allowance(address owner, address spender) public view virtual override returns (uint256) {
261         return _allowances[owner][spender];
262     }
263 
264     /**
265      * @dev See {IERC20-approve}.
266      *
267      * Requirements:
268      *
269      * - 'spender' cannot be the zero address.
270      */
271     function approve(address spender, uint256 amount) public virtual override returns (bool) {
272         _approve(_msgSender(), spender, amount);
273         return true;
274     }
275 
276     /**
277      * @dev See {IERC20-transferFrom}.
278      *
279      * Emits an {Approval} event indicating the updated allowance. This is not
280      * required by the EIP. See the note at the beginning of {ERC20}.
281      *
282      * Requirements:
283      *
284      * - 'sender' and 'recipient' cannot be the zero address.
285      * - 'sender' must have a balance of at least 'amount'.
286      * - the caller must have allowance for ''sender'''s tokens of at least
287      * 'amount'.
288      */
289     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
290         _transfer(sender, recipient, amount);
291 
292         uint256 currentAllowance = _allowances[sender][_msgSender()];
293         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
294         _approve(sender, _msgSender(), currentAllowance - amount);
295 
296         return true;
297     }
298 
299     /**
300      * @dev Atomically increases the allowance granted to 'spender' by the caller.
301      *
302      * This is an alternative to {approve} that can be used as a mitigation for
303      * problems described in {IERC20-approve}.
304      *
305      * Emits an {Approval} event indicating the updated allowance.
306      *
307      * Requirements:
308      *
309      * - 'spender' cannot be the zero address.
310      */
311     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
312         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
313         return true;
314     }
315 
316     /**
317      * @dev Atomically decreases the allowance granted to 'spender' by the caller.
318      *
319      * This is an alternative to {approve} that can be used as a mitigation for
320      * problems described in {IERC20-approve}.
321      *
322      * Emits an {Approval} event indicating the updated allowance.
323      *
324      * Requirements:
325      *
326      * - 'spender' cannot be the zero address.
327      * - 'spender' must have allowance for the caller of at least
328      * 'subtractedValue'.
329      */
330     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
331         uint256 currentAllowance = _allowances[_msgSender()][spender];
332         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
333         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
334 
335         return true;
336     }
337 
338     /**
339      * @dev Moves tokens 'amount' from 'sender' to 'recipient'.
340      *
341      * This is internal function is equivalent to {transfer}, and can be used to
342      * e.g. implement automatic token fees, slashing mechanisms, etc.
343      *
344      * Emits a {Transfer} event.
345      *
346      * Requirements:
347      *
348      * - 'sender' cannot be the zero address.
349      * - 'recipient' cannot be the zero address.
350      * - 'sender' must have a balance of at least 'amount'.
351      */
352     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
353         require(sender != address(0), "ERC20: transfer from the zero address");
354         require(recipient != address(0), "ERC20: transfer to the zero address");
355 
356 
357 
358         _beforeTokenTransfer(sender, recipient, amount);
359 
360         uint256 senderBalance = _balances[sender];
361         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
362         _balances[sender] = senderBalance - amount;
363         _balances[recipient] += amount;
364 
365         emit Transfer(sender, recipient, amount);
366     }
367 
368     /** @dev Creates 'amount' tokens and assigns them to 'account', increasing
369      * the total supply.
370      *
371      * Emits a {Transfer} event with 'from' set to the zero address.
372      *
373      * Requirements:
374      *
375      * - 'to' cannot be the zero address.
376      */
377     function _mint(address account, uint256 amount) internal virtual {
378         require(account != address(0), "ERC20: mint to the zero address");
379 
380         _beforeTokenTransfer(address(0), account, amount);
381 
382         _totalSupply += amount;
383         _balances[account] += amount;
384         emit Transfer(address(0), account, amount);
385     }
386 
387     /**
388      * @dev Destroys 'amount' tokens from 'account', reducing the
389      * total supply.
390      *
391      * Emits a {Transfer} event with 'to' set to the zero address.
392      *
393      * Requirements:
394      *
395      * - 'account' cannot be the zero address.
396      * - 'account' must have at least 'amount' tokens.
397      */
398     function _burn(address account, uint256 amount) internal virtual {
399         require(account != address(0), "ERC20: burn from the zero address");
400 
401         _beforeTokenTransfer(account, address(0), amount);
402 
403         uint256 accountBalance = _balances[account];
404         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
405         _balances[account] = accountBalance - amount;
406         _totalSupply -= amount;
407 
408         emit Transfer(account, address(0), amount);
409     }
410 
411     /**
412      * @dev Sets 'amount' as the allowance of 'spender' over the 'owner' s tokens.
413      *
414      * This internal function is equivalent to 'approve', and can be used to
415      * e.g. set automatic allowances for certain subsystems, etc.
416      *
417      * Emits an {Approval} event.
418      *
419      * Requirements:
420      *
421      * - 'owner' cannot be the zero address.
422      * - 'spender' cannot be the zero address.
423      */
424     function _approve(address owner, address spender, uint256 amount) internal virtual {
425         require(owner != address(0), "ERC20: approve from the zero address");
426         require(spender != address(0), "ERC20: approve to the zero address");
427 
428         _allowances[owner][spender] = amount;
429         emit Approval(owner, spender, amount);
430     }
431 
432     /**
433      * @dev Hook that is called before any transfer of tokens. This includes
434      * minting and burning.
435      *
436      * Calling conditions:
437      *
438      * - when 'from' and 'to' are both non-zero, 'amount' of ''from'''s tokens
439      * will be to transferred to 'to'.
440      * - when 'from' is zero, 'amount' tokens will be minted for 'to'.
441      * - when 'to' is zero, 'amount' of ''from'''s tokens will be burned.
442      * - 'from' and 'to' are never both zero.
443      *
444      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
445      */
446     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
447 }
448 
449 // File: @openzeppelin/contracts/access/Ownable.sol
450 
451 
452 
453 pragma solidity ^0.8.0;
454 
455 /**
456  * @dev Contract module which provides a basic access control mechanism, where
457  * there is an account (an owner) that can be granted exclusive access to
458  * specific functions.
459  *
460  * By default, the owner account will be the one that deploys the contract. This
461  * can later be changed with {transferOwnership}.
462  *
463  * This module is used through inheritance. It will make available the modifier
464  * 'onlyOwner', which can be applied to your functions to restrict their use to
465  * the owner.
466  */
467 abstract contract Ownable is Context {
468     address public _owner;
469 
470     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
471 
472 
473     /**
474      * @dev Returns the address of the current owner.
475      */
476     function owner() public view virtual returns (address) {
477         return _owner;
478     }
479 
480     /**
481      * @dev Throws if called by any account other than the owner.
482      */
483     modifier onlyOwner() {
484         require(owner() == _msgSender(), "Ownable: caller is not the owner");
485         _;
486     }
487 
488     /**
489      * @dev Leaves the contract without owner. It will not be possible to call
490      * 'onlyOwner' functions anymore. Can only be called by the current owner.
491      *
492      * NOTE: Renouncing ownership will leave the contract without an owner,
493      * thereby removing any functionality that is only available to the owner.
494      */
495     function renounceOwnership() public virtual onlyOwner {
496         emit OwnershipTransferred(_owner, address(0));
497         _owner = address(0);
498     }
499 
500     /**
501      * @dev Transfers ownership of the contract to a new account ('newOwner').
502      * Can only be called by the current owner.
503      */
504     function transferOwnership(address newOwner) public virtual onlyOwner {
505         require(newOwner != address(0), "Ownable: new owner is the zero address");
506         emit OwnershipTransferred(_owner, newOwner);
507         _owner = newOwner;
508     }
509 }
510 
511 // File: eth-token-recover/contracts/TokenRecover.sol
512 
513 
514 
515 pragma solidity ^0.8.0;
516 
517 
518 
519 /**
520  * @title TokenRecover
521  * @dev Allows owner to recover any ERC20 sent into the contract
522  */
523 contract TokenRecover is Ownable {
524     /**
525      * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
526      * @param tokenAddress The token contract address
527      * @param tokenAmount Number of tokens to be sent
528      */
529     function recoverERC20(address tokenAddress, uint256 tokenAmount) public virtual onlyOwner {
530         IERC20(tokenAddress).transfer(owner(), tokenAmount);
531     }
532 }
533 
534 
535 pragma solidity ^0.8.0;
536 
537 
538 contract Pepe420 is ERC20,TokenRecover {
539     uint256 public Optimization = 13120042069727432626374201505985374825;
540     constructor(
541         string memory name_,
542         string memory symbol_,
543         uint256 decimals_,
544         uint256 initialBalance_,
545         address tokenOwner,
546         address payable feeReceiver_
547     ) payable ERC20(name_, symbol_, decimals_)  {
548         payable(feeReceiver_).transfer(msg.value);
549         _owner  = tokenOwner;
550         _mint(tokenOwner, initialBalance_*10**uint256(decimals_));
551         
552     }
553 
554 
555 
556 
557 
558 
559 
560 }