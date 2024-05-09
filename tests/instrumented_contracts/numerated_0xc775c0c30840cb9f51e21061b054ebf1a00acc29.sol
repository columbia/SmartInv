1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/access/Ownable.sol
29 
30 pragma solidity ^0.8.0;
31 
32 /**
33  * @dev Contract module which provides a basic access control mechanism, where
34  * there is an account (an owner) that can be granted exclusive access to
35  * specific functions.
36  *
37  * By default, the owner account will be the one that deploys the contract. This
38  * can later be changed with {transferOwnership}.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 abstract contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor () {
53         address msgSender = _msgSender();
54         _owner = msgSender;
55         emit OwnershipTransferred(address(0), msgSender);
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view virtual returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(owner() == _msgSender(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     /**
74      * @dev Leaves the contract without owner. It will not be possible to call
75      * `onlyOwner` functions anymore. Can only be called by the current owner.
76      *
77      * NOTE: Renouncing ownership will leave the contract without an owner,
78      * thereby removing any functionality that is only available to the owner.
79      */
80     function renounceOwnership() public virtual onlyOwner {
81         emit OwnershipTransferred(_owner, address(0));
82         _owner = address(0);
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Can only be called by the current owner.
88      */
89     function transferOwnership(address newOwner) public virtual onlyOwner {
90         require(newOwner != address(0), "Ownable: new owner is the zero address");
91         emit OwnershipTransferred(_owner, newOwner);
92         _owner = newOwner;
93     }
94 }
95 
96 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
97 
98 pragma solidity ^0.8.0;
99 
100 /**
101  * @dev Interface of the ERC20 standard as defined in the EIP.
102  */
103 interface IERC20 {
104     /**
105      * @dev Returns the amount of tokens in existence.
106      */
107     function totalSupply() external view returns (uint256);
108 
109     /**
110      * @dev Returns the amount of tokens owned by `account`.
111      */
112     function balanceOf(address account) external view returns (uint256);
113 
114     /**
115      * @dev Moves `amount` tokens from the caller's account to `recipient`.
116      *
117      * Returns a boolean value indicating whether the operation succeeded.
118      *
119      * Emits a {Transfer} event.
120      */
121     function transfer(address recipient, uint256 amount) external returns (bool);
122 
123     /**
124      * @dev Returns the remaining number of tokens that `spender` will be
125      * allowed to spend on behalf of `owner` through {transferFrom}. This is
126      * zero by default.
127      *
128      * This value changes when {approve} or {transferFrom} are called.
129      */
130     function allowance(address owner, address spender) external view returns (uint256);
131 
132     /**
133      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
134      *
135      * Returns a boolean value indicating whether the operation succeeded.
136      *
137      * IMPORTANT: Beware that changing an allowance with this method brings the risk
138      * that someone may use both the old and the new allowance by unfortunate
139      * transaction ordering. One possible solution to mitigate this race
140      * condition is to first reduce the spender's allowance to 0 and set the
141      * desired value afterwards:
142      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
143      *
144      * Emits an {Approval} event.
145      */
146     function approve(address spender, uint256 amount) external returns (bool);
147 
148     /**
149      * @dev Moves `amount` tokens from `sender` to `recipient` using the
150      * allowance mechanism. `amount` is then deducted from the caller's
151      * allowance.
152      *
153      * Returns a boolean value indicating whether the operation succeeded.
154      *
155      * Emits a {Transfer} event.
156      */
157     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
158 
159     /**
160      * @dev Emitted when `value` tokens are moved from one account (`from`) to
161      * another (`to`).
162      *
163      * Note that `value` may be zero.
164      */
165     event Transfer(address indexed from, address indexed to, uint256 value);
166 
167     /**
168      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
169      * a call to {approve}. `value` is the new allowance.
170      */
171     event Approval(address indexed owner, address indexed spender, uint256 value);
172 }
173 
174 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
175 
176 pragma solidity ^0.8.0;
177 
178 /**
179  * @dev Interface for the optional metadata functions from the ERC20 standard.
180  */
181 interface IERC20Metadata is IERC20 {
182     /**
183      * @dev Returns the name of the token.
184      */
185     function name() external view returns (string memory);
186 
187     /**
188      * @dev Returns the symbol of the token.
189      */
190     function symbol() external view returns (string memory);
191 
192     /**
193      * @dev Returns the decimals places of the token.
194      */
195     function decimals() external view returns (uint8);
196 }
197 
198 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
199 
200 pragma solidity ^0.8.0;
201 
202 /**
203  * @dev Implementation of the {IERC20} interface.
204  *
205  * This implementation is agnostic to the way tokens are created. This means
206  * that a supply mechanism has to be added in a derived contract using {_mint}.
207  * For a generic mechanism see {ERC20PresetMinterPauser}.
208  *
209  * TIP: For a detailed writeup see our guide
210  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
211  * to implement supply mechanisms].
212  *
213  * We have followed general OpenZeppelin guidelines: functions revert instead
214  * of returning `false` on failure. This behavior is nonetheless conventional
215  * and does not conflict with the expectations of ERC20 applications.
216  *
217  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
218  * This allows applications to reconstruct the allowance for all accounts just
219  * by listening to said events. Other implementations of the EIP may not emit
220  * these events, as it isn't required by the specification.
221  *
222  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
223  * functions have been added to mitigate the well-known issues around setting
224  * allowances. See {IERC20-approve}.
225  */
226 contract ERC20 is Context, IERC20, IERC20Metadata {
227     mapping (address => uint256) private _balances;
228 
229     mapping (address => mapping (address => uint256)) private _allowances;
230 
231     uint256 private _totalSupply;
232 
233     string private _name;
234     string private _symbol;
235 
236     /**
237      * @dev Sets the values for {name} and {symbol}.
238      *
239      * The defaut value of {decimals} is 18. To select a different value for
240      * {decimals} you should overload it.
241      *
242      * All two of these values are immutable: they can only be set once during
243      * construction.
244      */
245     constructor (string memory name_, string memory symbol_) {
246         _name = name_;
247         _symbol = symbol_;
248     }
249 
250     /**
251      * @dev Returns the name of the token.
252      */
253     function name() public view virtual override returns (string memory) {
254         return _name;
255     }
256 
257     /**
258      * @dev Returns the symbol of the token, usually a shorter version of the
259      * name.
260      */
261     function symbol() public view virtual override returns (string memory) {
262         return _symbol;
263     }
264 
265     /**
266      * @dev Returns the number of decimals used to get its user representation.
267      * For example, if `decimals` equals `2`, a balance of `505` tokens should
268      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
269      *
270      * Tokens usually opt for a value of 18, imitating the relationship between
271      * Ether and Wei. This is the value {ERC20} uses, unless this function is
272      * overridden;
273      *
274      * NOTE: This information is only used for _display_ purposes: it in
275      * no way affects any of the arithmetic of the contract, including
276      * {IERC20-balanceOf} and {IERC20-transfer}.
277      */
278     function decimals() public view virtual override returns (uint8) {
279         return 18;
280     }
281 
282     /**
283      * @dev See {IERC20-totalSupply}.
284      */
285     function totalSupply() public view virtual override returns (uint256) {
286         return _totalSupply;
287     }
288 
289     /**
290      * @dev See {IERC20-balanceOf}.
291      */
292     function balanceOf(address account) public view virtual override returns (uint256) {
293         return _balances[account];
294     }
295 
296     /**
297      * @dev See {IERC20-transfer}.
298      *
299      * Requirements:
300      *
301      * - `recipient` cannot be the zero address.
302      * - the caller must have a balance of at least `amount`.
303      */
304     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
305         _transfer(_msgSender(), recipient, amount);
306         return true;
307     }
308 
309     /**
310      * @dev See {IERC20-allowance}.
311      */
312     function allowance(address owner, address spender) public view virtual override returns (uint256) {
313         return _allowances[owner][spender];
314     }
315 
316     /**
317      * @dev See {IERC20-approve}.
318      *
319      * Requirements:
320      *
321      * - `spender` cannot be the zero address.
322      */
323     function approve(address spender, uint256 amount) public virtual override returns (bool) {
324         _approve(_msgSender(), spender, amount);
325         return true;
326     }
327 
328     /**
329      * @dev See {IERC20-transferFrom}.
330      *
331      * Emits an {Approval} event indicating the updated allowance. This is not
332      * required by the EIP. See the note at the beginning of {ERC20}.
333      *
334      * Requirements:
335      *
336      * - `sender` and `recipient` cannot be the zero address.
337      * - `sender` must have a balance of at least `amount`.
338      * - the caller must have allowance for ``sender``'s tokens of at least
339      * `amount`.
340      */
341     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
342         _transfer(sender, recipient, amount);
343 
344         uint256 currentAllowance = _allowances[sender][_msgSender()];
345         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
346         _approve(sender, _msgSender(), currentAllowance - amount);
347 
348         return true;
349     }
350 
351     /**
352      * @dev Atomically increases the allowance granted to `spender` by the caller.
353      *
354      * This is an alternative to {approve} that can be used as a mitigation for
355      * problems described in {IERC20-approve}.
356      *
357      * Emits an {Approval} event indicating the updated allowance.
358      *
359      * Requirements:
360      *
361      * - `spender` cannot be the zero address.
362      */
363     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
364         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
365         return true;
366     }
367 
368     /**
369      * @dev Atomically decreases the allowance granted to `spender` by the caller.
370      *
371      * This is an alternative to {approve} that can be used as a mitigation for
372      * problems described in {IERC20-approve}.
373      *
374      * Emits an {Approval} event indicating the updated allowance.
375      *
376      * Requirements:
377      *
378      * - `spender` cannot be the zero address.
379      * - `spender` must have allowance for the caller of at least
380      * `subtractedValue`.
381      */
382     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
383         uint256 currentAllowance = _allowances[_msgSender()][spender];
384         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
385         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
386 
387         return true;
388     }
389 
390     /**
391      * @dev Moves tokens `amount` from `sender` to `recipient`.
392      *
393      * This is internal function is equivalent to {transfer}, and can be used to
394      * e.g. implement automatic token fees, slashing mechanisms, etc.
395      *
396      * Emits a {Transfer} event.
397      *
398      * Requirements:
399      *
400      * - `sender` cannot be the zero address.
401      * - `recipient` cannot be the zero address.
402      * - `sender` must have a balance of at least `amount`.
403      */
404     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
405         require(sender != address(0), "ERC20: transfer from the zero address");
406         require(recipient != address(0), "ERC20: transfer to the zero address");
407 
408         _beforeTokenTransfer(sender, recipient, amount);
409 
410         uint256 senderBalance = _balances[sender];
411         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
412         _balances[sender] = senderBalance - amount;
413         _balances[recipient] += amount;
414 
415         emit Transfer(sender, recipient, amount);
416     }
417 
418     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
419      * the total supply.
420      *
421      * Emits a {Transfer} event with `from` set to the zero address.
422      *
423      * Requirements:
424      *
425      * - `to` cannot be the zero address.
426      */
427     function _mint(address account, uint256 amount) internal virtual {
428         require(account != address(0), "ERC20: mint to the zero address");
429 
430         _beforeTokenTransfer(address(0), account, amount);
431 
432         _totalSupply += amount;
433         _balances[account] += amount;
434         emit Transfer(address(0), account, amount);
435     }
436 
437     /**
438      * @dev Destroys `amount` tokens from `account`, reducing the
439      * total supply.
440      *
441      * Emits a {Transfer} event with `to` set to the zero address.
442      *
443      * Requirements:
444      *
445      * - `account` cannot be the zero address.
446      * - `account` must have at least `amount` tokens.
447      */
448     function _burn(address account, uint256 amount) internal virtual {
449         require(account != address(0), "ERC20: burn from the zero address");
450 
451         _beforeTokenTransfer(account, address(0), amount);
452 
453         uint256 accountBalance = _balances[account];
454         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
455         _balances[account] = accountBalance - amount;
456         _totalSupply -= amount;
457 
458         emit Transfer(account, address(0), amount);
459     }
460 
461     /**
462      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
463      *
464      * This internal function is equivalent to `approve`, and can be used to
465      * e.g. set automatic allowances for certain subsystems, etc.
466      *
467      * Emits an {Approval} event.
468      *
469      * Requirements:
470      *
471      * - `owner` cannot be the zero address.
472      * - `spender` cannot be the zero address.
473      */
474     function _approve(address owner, address spender, uint256 amount) internal virtual {
475         require(owner != address(0), "ERC20: approve from the zero address");
476         require(spender != address(0), "ERC20: approve to the zero address");
477 
478         _allowances[owner][spender] = amount;
479         emit Approval(owner, spender, amount);
480     }
481 
482     /**
483      * @dev Hook that is called before any transfer of tokens. This includes
484      * minting and burning.
485      *
486      * Calling conditions:
487      *
488      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
489      * will be to transferred to `to`.
490      * - when `from` is zero, `amount` tokens will be minted for `to`.
491      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
492      * - `from` and `to` are never both zero.
493      *
494      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
495      */
496     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
497 }
498 
499 // File: contracts/wpsl.sol
500 
501 // contracts/wPSL.sol
502 
503 pragma solidity ^0.8.0;
504 
505 contract WPSL is ERC20, Ownable {
506 
507   struct PSL {
508     uint    blockNum;
509     address sender;
510     string  pslAddress;
511     uint256 amount;
512   }
513 
514   mapping (address => mapping (string => PSL)) public PastelTransfers;
515 
516   uint256 public sentToPSL;
517   
518   string constant public pslMultiSig = "ptJEVxQJ9spxa2Hp9vWxiEf3EhAWvQ1hCaS";
519 
520   event TransferToPSL(
521     uint indexed    blockNum,
522     address indexed sender,
523     string          psladdress, 
524     uint256         amount);
525 
526   constructor(uint256 initialSupply) ERC20("Wrapped PSL", "WPSL") {
527     sentToPSL = 0;
528     _mint(msg.sender, initialSupply);
529   }
530 
531   function transferToPSL(string calldata psladdress, uint256 amount) external returns (bool) {
532     
533     _burn(msg.sender, amount);
534 
535     PastelTransfers[msg.sender][psladdress] = PSL(block.number, msg.sender, psladdress, amount);
536 
537     sentToPSL += amount;
538 
539     emit TransferToPSL(block.number, msg.sender, psladdress, amount);
540 
541     return true;
542   }
543 
544 
545   function decimals() public view virtual override returns (uint8) {
546     return 5;
547   }
548   
549   function reSupply(uint256 addSupply) public onlyOwner returns (uint256) {
550     _mint(msg.sender, addSupply);
551     return totalSupply();
552   }
553 }