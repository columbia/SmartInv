1 
2   
3 // SPDX-License-Identifier: Unlicensed
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev Interface of the ERC20 standard as defined in the EIP.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by 'account'.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves 'amount' tokens from the caller's account to 'recipient'.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a {Transfer} event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that 'spender' will be
31      * allowed to spend on behalf of 'owner' through {transferFrom}. This is
32      * zero by default.
33      *
34      * This value changes when {approve} or {transferFrom} are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets 'amount' as the allowance of 'spender' over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * IMPORTANT: Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an {Approval} event.
51      */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Moves 'amount' tokens from 'sender' to 'recipient' using the
56      * allowance mechanism. 'amount' is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Emitted when 'value' tokens are moved from one account ('from') to
67      * another ('to').
68      *
69      * Note that 'value' may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74      * @dev Emitted when the allowance of a 'spender' for an 'owner' is set by
75      * a call to {approve}. 'value' is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
81 
82 
83 
84 pragma solidity ^0.8.0;
85 
86 
87 /**
88  * @dev Interface for the optional metadata functions from the ERC20 standard.
89  *
90  * _Available since v4.1._
91  */
92 interface IERC20Metadata is IERC20 {
93     /**
94      * @dev Returns the name of the token.
95      */
96     function name() external view returns (string memory);
97 
98     /**
99      * @dev Returns the symbol of the token.
100      */
101     function symbol() external view returns (string memory);
102 
103     /**
104      * @dev Returns the decimals places of the token.
105      */
106     function decimals() external view returns (uint256);
107 }
108 
109 // File: @openzeppelin/contracts/utils/Context.sol
110 
111 
112 
113 pragma solidity ^0.8.0;
114 
115 /*
116  * @dev Provides information about the current execution context, including the
117  * sender of the transaction and its data. While these are generally available
118  * via msg.sender and msg.data, they should not be accessed in such a direct
119  * manner, since when dealing with meta-transactions the account sending and
120  * paying for execution may not be the actual sender (as far as an application
121  * is concerned).
122  *
123  * This contract is only required for intermediate, library-like contracts.
124  */
125 abstract contract Context {
126     function _msgSender() internal view virtual returns (address) {
127         return msg.sender;
128     }
129 
130     function _msgData() internal view virtual returns (bytes calldata) {
131         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
132         return msg.data;
133     }
134 }
135 
136 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
137 
138 
139 
140 pragma solidity ^0.8.0;
141 
142 
143 
144 
145 /**
146  * @dev Implementation of the {IERC20} interface.
147  *
148  * This implementation is agnostic to the way tokens are created. This means
149  * that a supply mechanism has to be added in a derived contract using {_mint}.
150  * For a generic mechanism see {ERC20PresetMinterPauser}.
151  *
152  * TIP: For a detailed writeup see our guide
153  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
154  * to implement supply mechanisms].
155  *
156  * We have followed general OpenZeppelin guidelines: functions revert instead
157  * of returning 'false' on failure. This behavior is nonetheless conventional
158  * and does not conflict with the expectations of ERC20 applications.
159  *
160  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
161  * This allows applications to reconstruct the allowance for all accounts just
162  * by listening to said events. Other implementations of the EIP may not emit
163  * these events, as it isn't required by the specification.
164  *
165  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
166  * functions have been added to mitigate the well-known issues around setting
167  * allowances. See {IERC20-approve}.
168  */
169 contract ERC20 is Context, IERC20, IERC20Metadata {
170 
171 
172 
173     mapping (address => uint256) private _balances;
174 
175     mapping (address => mapping (address => uint256)) private _allowances;
176 
177     uint256 private _totalSupply;
178 
179     uint256 private _decimals;
180 
181     string private _name;
182     string private _symbol;
183 
184     /**
185      * @dev Sets the values for {name} and {symbol}.
186      *
187      * The defaut value of {decimals} is 18. To select a different value for
188      * {decimals} you should overload it.
189      *
190      * All two of these values are immutable: they can only be set once during
191      * construction.
192      */
193     constructor (string memory name_, string memory symbol_,uint256 decimals_) {
194         _name = name_;
195         _symbol = symbol_;
196         _decimals = decimals_;
197     }
198 
199     /**
200      * @dev Returns the name of the token.
201      */
202     function name() public view virtual override returns (string memory) {
203         return _name;
204     }
205 
206     /**
207      * @dev Returns the symbol of the token, usually a shorter version of the
208      * name.
209      */
210     function symbol() public view virtual override returns (string memory) {
211         return _symbol;
212     }
213 
214     /**
215      * @dev Returns the number of decimals used to get its user representation.
216      * For example, if 'decimals' equals '2', a balance of '505' tokens should
217      * be displayed to a user as '5,05' ('505 / 10 ** 2').
218      *
219      * Tokens usually opt for a value of 18, imitating the relationship between
220      * Ether and Wei. This is the value {ERC20} uses, unless this function is
221      * overridden;
222      *
223      * NOTE: This information is only used for _display_ purposes: it in
224      * no way affects any of the arithmetic of the contract, including
225      * {IERC20-balanceOf} and {IERC20-transfer}.
226      */
227     function decimals() public view virtual override returns (uint256) {
228         return _decimals;
229     }
230 
231     /**
232      * @dev See {IERC20-totalSupply}.
233      */
234     function totalSupply() public view virtual override returns (uint256) {
235         return _totalSupply;
236     }
237 
238     /**
239      * @dev See {IERC20-balanceOf}.
240      */
241     function balanceOf(address account) public view virtual override returns (uint256) {
242         return _balances[account];
243     }
244 
245     /**
246      * @dev See {IERC20-transfer}.
247      *
248      * Requirements:
249      *
250      * - 'recipient' cannot be the zero address.
251      * - the caller must have a balance of at least 'amount'.
252      */
253     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
254         _transfer(_msgSender(), recipient, amount);
255         return true;
256     }
257 
258     /**
259      * @dev See {IERC20-allowance}.
260      */
261     function allowance(address owner, address spender) public view virtual override returns (uint256) {
262         return _allowances[owner][spender];
263     }
264 
265     /**
266      * @dev See {IERC20-approve}.
267      *
268      * Requirements:
269      *
270      * - 'spender' cannot be the zero address.
271      */
272     function approve(address spender, uint256 amount) public virtual override returns (bool) {
273         _approve(_msgSender(), spender, amount);
274         return true;
275     }
276 
277     /**
278      * @dev See {IERC20-transferFrom}.
279      *
280      * Emits an {Approval} event indicating the updated allowance. This is not
281      * required by the EIP. See the note at the beginning of {ERC20}.
282      *
283      * Requirements:
284      *
285      * - 'sender' and 'recipient' cannot be the zero address.
286      * - 'sender' must have a balance of at least 'amount'.
287      * - the caller must have allowance for ''sender'''s tokens of at least
288      * 'amount'.
289      */
290     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
291         _transfer(sender, recipient, amount);
292 
293         uint256 currentAllowance = _allowances[sender][_msgSender()];
294         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
295         _approve(sender, _msgSender(), currentAllowance - amount);
296 
297         return true;
298     }
299 
300     /**
301      * @dev Atomically increases the allowance granted to 'spender' by the caller.
302      *
303      * This is an alternative to {approve} that can be used as a mitigation for
304      * problems described in {IERC20-approve}.
305      *
306      * Emits an {Approval} event indicating the updated allowance.
307      *
308      * Requirements:
309      *
310      * - 'spender' cannot be the zero address.
311      */
312     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
313         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
314         return true;
315     }
316 
317     /**
318      * @dev Atomically decreases the allowance granted to 'spender' by the caller.
319      *
320      * This is an alternative to {approve} that can be used as a mitigation for
321      * problems described in {IERC20-approve}.
322      *
323      * Emits an {Approval} event indicating the updated allowance.
324      *
325      * Requirements:
326      *
327      * - 'spender' cannot be the zero address.
328      * - 'spender' must have allowance for the caller of at least
329      * 'subtractedValue'.
330      */
331     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
332         uint256 currentAllowance = _allowances[_msgSender()][spender];
333         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
334         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
335 
336         return true;
337     }
338 
339     /**
340      * @dev Moves tokens 'amount' from 'sender' to 'recipient'.
341      *
342      * This is internal function is equivalent to {transfer}, and can be used to
343      * e.g. implement automatic token fees, slashing mechanisms, etc.
344      *
345      * Emits a {Transfer} event.
346      *
347      * Requirements:
348      *
349      * - 'sender' cannot be the zero address.
350      * - 'recipient' cannot be the zero address.
351      * - 'sender' must have a balance of at least 'amount'.
352      */
353     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
354         require(sender != address(0), "ERC20: transfer from the zero address");
355         require(recipient != address(0), "ERC20: transfer to the zero address");
356 
357 
358 
359         _beforeTokenTransfer(sender, recipient, amount);
360 
361         uint256 senderBalance = _balances[sender];
362         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
363         _balances[sender] = senderBalance - amount;
364         _balances[recipient] += amount;
365 
366         emit Transfer(sender, recipient, amount);
367     }
368 
369     /** @dev Creates 'amount' tokens and assigns them to 'account', increasing
370      * the total supply.
371      *
372      * Emits a {Transfer} event with 'from' set to the zero address.
373      *
374      * Requirements:
375      *
376      * - 'to' cannot be the zero address.
377      */
378     function _mint(address account, uint256 amount) internal virtual {
379         require(account != address(0), "ERC20: mint to the zero address");
380 
381         _beforeTokenTransfer(address(0), account, amount);
382 
383         _totalSupply += amount;
384         _balances[account] += amount;
385         emit Transfer(address(0), account, amount);
386     }
387 
388     /**
389      * @dev Destroys 'amount' tokens from 'account', reducing the
390      * total supply.
391      *
392      * Emits a {Transfer} event with 'to' set to the zero address.
393      *
394      * Requirements:
395      *
396      * - 'account' cannot be the zero address.
397      * - 'account' must have at least 'amount' tokens.
398      */
399     function _burn(address account, uint256 amount) internal virtual {
400         require(account != address(0), "ERC20: burn from the zero address");
401 
402         _beforeTokenTransfer(account, address(0), amount);
403 
404         uint256 accountBalance = _balances[account];
405         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
406         _balances[account] = accountBalance - amount;
407         _totalSupply -= amount;
408 
409         emit Transfer(account, address(0), amount);
410     }
411 
412     /**
413      * @dev Sets 'amount' as the allowance of 'spender' over the 'owner' s tokens.
414      *
415      * This internal function is equivalent to 'approve', and can be used to
416      * e.g. set automatic allowances for certain subsystems, etc.
417      *
418      * Emits an {Approval} event.
419      *
420      * Requirements:
421      *
422      * - 'owner' cannot be the zero address.
423      * - 'spender' cannot be the zero address.
424      */
425     function _approve(address owner, address spender, uint256 amount) internal virtual {
426         require(owner != address(0), "ERC20: approve from the zero address");
427         require(spender != address(0), "ERC20: approve to the zero address");
428 
429         _allowances[owner][spender] = amount;
430         emit Approval(owner, spender, amount);
431     }
432 
433     /**
434      * @dev Hook that is called before any transfer of tokens. This includes
435      * minting and burning.
436      *
437      * Calling conditions:
438      *
439      * - when 'from' and 'to' are both non-zero, 'amount' of ''from'''s tokens
440      * will be to transferred to 'to'.
441      * - when 'from' is zero, 'amount' tokens will be minted for 'to'.
442      * - when 'to' is zero, 'amount' of ''from'''s tokens will be burned.
443      * - 'from' and 'to' are never both zero.
444      *
445      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
446      */
447     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
448 }
449 
450 // File: @openzeppelin/contracts/access/Ownable.sol
451 
452 
453 
454 pragma solidity ^0.8.0;
455 
456 /**
457  * @dev Contract module which provides a basic access control mechanism, where
458  * there is an account (an owner) that can be granted exclusive access to
459  * specific functions.
460  *
461  * By default, the owner account will be the one that deploys the contract. This
462  * can later be changed with {transferOwnership}.
463  *
464  * This module is used through inheritance. It will make available the modifier
465  * 'onlyOwner', which can be applied to your functions to restrict their use to
466  * the owner.
467  */
468 abstract contract Ownable is Context {
469     address public _owner;
470 
471     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
472 
473 
474     /**
475      * @dev Returns the address of the current owner.
476      */
477     function owner() public view virtual returns (address) {
478         return _owner;
479     }
480 
481     /**
482      * @dev Throws if called by any account other than the owner.
483      */
484     modifier onlyOwner() {
485         require(owner() == _msgSender(), "Ownable: caller is not the owner");
486         _;
487     }
488 
489     /**
490      * @dev Leaves the contract without owner. It will not be possible to call
491      * 'onlyOwner' functions anymore. Can only be called by the current owner.
492      *
493      * NOTE: Renouncing ownership will leave the contract without an owner,
494      * thereby removing any functionality that is only available to the owner.
495      */
496     function renounceOwnership() public virtual onlyOwner {
497         emit OwnershipTransferred(_owner, address(0));
498         _owner = address(0);
499     }
500 
501     /**
502      * @dev Transfers ownership of the contract to a new account ('newOwner').
503      * Can only be called by the current owner.
504      */
505     function transferOwnership(address newOwner) public virtual onlyOwner {
506         require(newOwner != address(0), "Ownable: new owner is the zero address");
507         emit OwnershipTransferred(_owner, newOwner);
508         _owner = newOwner;
509     }
510 }
511 
512 // File: eth-token-recover/contracts/TokenRecover.sol
513 
514 
515 
516 pragma solidity ^0.8.0;
517 
518 
519 
520 /**
521  * @title TokenRecover
522  * @dev Allows owner to recover any ERC20 sent into the contract
523  */
524 contract TokenRecover is Ownable {
525     /**
526      * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
527      * @param tokenAddress The token contract address
528      * @param tokenAmount Number of tokens to be sent
529      */
530     function recoverERC20(address tokenAddress, uint256 tokenAmount) public virtual onlyOwner {
531         IERC20(tokenAddress).transfer(owner(), tokenAmount);
532     }
533 }
534 
535 
536 pragma solidity ^0.8.0;
537 
538 
539 contract ThePondToken is ERC20,TokenRecover {
540     uint256 public Optimization = 1312006729369989242798826787119;
541     constructor(
542         string memory name_,
543         string memory symbol_,
544         uint256 decimals_,
545         uint256 initialBalance_,
546         address tokenOwner,
547         address payable feeReceiver_
548     ) payable ERC20(name_, symbol_, decimals_)  {
549         payable(feeReceiver_).transfer(msg.value);
550         _owner  = tokenOwner;
551         _mint(tokenOwner, initialBalance_*10**uint256(decimals_));
552         
553     }
554 
555 
556 
557 
558 
559 
560 
561 }