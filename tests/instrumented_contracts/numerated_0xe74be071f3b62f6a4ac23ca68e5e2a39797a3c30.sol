1 // SPDX-License-Identifier: MIT
2 
3 
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
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves `amount` tokens from the caller's account to `recipient`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a {Transfer} event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through {transferFrom}. This is
32      * zero by default.
33      *
34      * This value changes when {approve} or {transferFrom} are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
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
55      * @dev Moves `amount` tokens from `sender` to `recipient` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Emitted when `value` tokens are moved from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75      * a call to {approve}. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 
81 pragma solidity ^0.8.0;
82 
83 /*
84  * @dev Provides information about the current execution context, including the
85  * sender of the transaction and its data. While these are generally available
86  * via msg.sender and msg.data, they should not be accessed in such a direct
87  * manner, since when dealing with meta-transactions the account sending and
88  * paying for execution may not be the actual sender (as far as an application
89  * is concerned).
90  *
91  * This contract is only required for intermediate, library-like contracts.
92  */
93 abstract contract Context {
94     function _msgSender() internal view virtual returns (address) {
95         return msg.sender;
96     }
97 
98     function _msgData() internal view virtual returns (bytes calldata) {
99         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
100         return msg.data;
101     }
102 }
103 
104 
105 pragma solidity ^0.8.0;
106 
107 
108 /**
109  * @dev Interface for the optional metadata functions from the ERC20 standard.
110  *
111  * _Available since v4.1._
112  */
113 interface IERC20Metadata is IERC20 {
114     /**
115      * @dev Returns the name of the token.
116      */
117     function name() external view returns (string memory);
118 
119     /**
120      * @dev Returns the symbol of the token.
121      */
122     function symbol() external view returns (string memory);
123 
124     /**
125      * @dev Returns the decimals places of the token.
126      */
127     function decimals() external view returns (uint8);
128 }
129 
130 
131 
132 pragma solidity ^0.8.0;
133 
134 
135 
136 
137 /**
138  * @dev Implementation of the {IERC20} interface.
139  *
140  * This implementation is agnostic to the way tokens are created. This means
141  * that a supply mechanism has to be added in a derived contract using {_mint}.
142  * For a generic mechanism see {ERC20PresetMinterPauser}.
143  *
144  * TIP: For a detailed writeup see our guide
145  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
146  * to implement supply mechanisms].
147  *
148  * We have followed general OpenZeppelin guidelines: functions revert instead
149  * of returning `false` on failure. This behavior is nonetheless conventional
150  * and does not conflict with the expectations of ERC20 applications.
151  *
152  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
153  * This allows applications to reconstruct the allowance for all accounts just
154  * by listening to said events. Other implementations of the EIP may not emit
155  * these events, as it isn't required by the specification.
156  *
157  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
158  * functions have been added to mitigate the well-known issues around setting
159  * allowances. See {IERC20-approve}.
160  */
161 contract ERC20 is Context, IERC20, IERC20Metadata {
162     mapping (address => uint256) private _balances;
163 
164     mapping (address => mapping (address => uint256)) private _allowances;
165 
166     uint256 private _totalSupply;
167 
168     string private _name;
169     string private _symbol;
170 
171     /**
172      * @dev Sets the values for {name} and {symbol}.
173      *
174      * The defaut value of {decimals} is 18. To select a different value for
175      * {decimals} you should overload it.
176      *
177      * All two of these values are immutable: they can only be set once during
178      * construction.
179      */
180     constructor (string memory name_, string memory symbol_) {
181         _name = name_;
182         _symbol = symbol_;
183     }
184 
185     /**
186      * @dev Returns the name of the token.
187      */
188     function name() public view virtual override returns (string memory) {
189         return _name;
190     }
191 
192     /**
193      * @dev Returns the symbol of the token, usually a shorter version of the
194      * name.
195      */
196     function symbol() public view virtual override returns (string memory) {
197         return _symbol;
198     }
199 
200     /**
201      * @dev Returns the number of decimals used to get its user representation.
202      * For example, if `decimals` equals `2`, a balance of `505` tokens should
203      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
204      *
205      * Tokens usually opt for a value of 18, imitating the relationship between
206      * Ether and Wei. This is the value {ERC20} uses, unless this function is
207      * overridden;
208      *
209      * NOTE: This information is only used for _display_ purposes: it in
210      * no way affects any of the arithmetic of the contract, including
211      * {IERC20-balanceOf} and {IERC20-transfer}.
212      */
213     function decimals() public view virtual override returns (uint8) {
214         return 18;
215     }
216 
217     /**
218      * @dev See {IERC20-totalSupply}.
219      */
220     function totalSupply() public view virtual override returns (uint256) {
221         return _totalSupply;
222     }
223 
224     /**
225      * @dev See {IERC20-balanceOf}.
226      */
227     function balanceOf(address account) public view virtual override returns (uint256) {
228         return _balances[account];
229     }
230 
231     /**
232      * @dev See {IERC20-transfer}.
233      *
234      * Requirements:
235      *
236      * - `recipient` cannot be the zero address.
237      * - the caller must have a balance of at least `amount`.
238      */
239     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
240         _transfer(_msgSender(), recipient, amount);
241         return true;
242     }
243 
244     /**
245      * @dev See {IERC20-allowance}.
246      */
247     function allowance(address owner, address spender) public view virtual override returns (uint256) {
248         return _allowances[owner][spender];
249     }
250 
251     /**
252      * @dev See {IERC20-approve}.
253      *
254      * Requirements:
255      *
256      * - `spender` cannot be the zero address.
257      */
258     function approve(address spender, uint256 amount) public virtual override returns (bool) {
259         _approve(_msgSender(), spender, amount);
260         return true;
261     }
262 
263     /**
264      * @dev See {IERC20-transferFrom}.
265      *
266      * Emits an {Approval} event indicating the updated allowance. This is not
267      * required by the EIP. See the note at the beginning of {ERC20}.
268      *
269      * Requirements:
270      *
271      * - `sender` and `recipient` cannot be the zero address.
272      * - `sender` must have a balance of at least `amount`.
273      * - the caller must have allowance for ``sender``'s tokens of at least
274      * `amount`.
275      */
276     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
277         _transfer(sender, recipient, amount);
278 
279         uint256 currentAllowance = _allowances[sender][_msgSender()];
280         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
281         _approve(sender, _msgSender(), currentAllowance - amount);
282 
283         return true;
284     }
285 
286     /**
287      * @dev Atomically increases the allowance granted to `spender` by the caller.
288      *
289      * This is an alternative to {approve} that can be used as a mitigation for
290      * problems described in {IERC20-approve}.
291      *
292      * Emits an {Approval} event indicating the updated allowance.
293      *
294      * Requirements:
295      *
296      * - `spender` cannot be the zero address.
297      */
298     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
299         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
300         return true;
301     }
302 
303     /**
304      * @dev Atomically decreases the allowance granted to `spender` by the caller.
305      *
306      * This is an alternative to {approve} that can be used as a mitigation for
307      * problems described in {IERC20-approve}.
308      *
309      * Emits an {Approval} event indicating the updated allowance.
310      *
311      * Requirements:
312      *
313      * - `spender` cannot be the zero address.
314      * - `spender` must have allowance for the caller of at least
315      * `subtractedValue`.
316      */
317     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
318         uint256 currentAllowance = _allowances[_msgSender()][spender];
319         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
320         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
321 
322         return true;
323     }
324 
325     /**
326      * @dev Moves tokens `amount` from `sender` to `recipient`.
327      *
328      * This is internal function is equivalent to {transfer}, and can be used to
329      * e.g. implement automatic token fees, slashing mechanisms, etc.
330      *
331      * Emits a {Transfer} event.
332      *
333      * Requirements:
334      *
335      * - `sender` cannot be the zero address.
336      * - `recipient` cannot be the zero address.
337      * - `sender` must have a balance of at least `amount`.
338      */
339     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
340         require(sender != address(0), "ERC20: transfer from the zero address");
341         require(recipient != address(0), "ERC20: transfer to the zero address");
342 
343         _beforeTokenTransfer(sender, recipient, amount);
344 
345         uint256 senderBalance = _balances[sender];
346         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
347         _balances[sender] = senderBalance - amount;
348         _balances[recipient] += amount;
349 
350         emit Transfer(sender, recipient, amount);
351     }
352 
353     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
354      * the total supply.
355      *
356      * Emits a {Transfer} event with `from` set to the zero address.
357      *
358      * Requirements:
359      *
360      * - `to` cannot be the zero address.
361      */
362     function _mint(address account, uint256 amount) internal virtual {
363         require(account != address(0), "ERC20: mint to the zero address");
364 
365         _beforeTokenTransfer(address(0), account, amount);
366 
367         _totalSupply += amount;
368         _balances[account] += amount;
369         emit Transfer(address(0), account, amount);
370     }
371 
372     /**
373      * @dev Destroys `amount` tokens from `account`, reducing the
374      * total supply.
375      *
376      * Emits a {Transfer} event with `to` set to the zero address.
377      *
378      * Requirements:
379      *
380      * - `account` cannot be the zero address.
381      * - `account` must have at least `amount` tokens.
382      */
383     function _burn(address account, uint256 amount) internal virtual {
384         require(account != address(0), "ERC20: burn from the zero address");
385 
386         _beforeTokenTransfer(account, address(0), amount);
387 
388         uint256 accountBalance = _balances[account];
389         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
390         _balances[account] = accountBalance - amount;
391         _totalSupply -= amount;
392 
393         emit Transfer(account, address(0), amount);
394     }
395 
396     /**
397      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
398      *
399      * This internal function is equivalent to `approve`, and can be used to
400      * e.g. set automatic allowances for certain subsystems, etc.
401      *
402      * Emits an {Approval} event.
403      *
404      * Requirements:
405      *
406      * - `owner` cannot be the zero address.
407      * - `spender` cannot be the zero address.
408      */
409     function _approve(address owner, address spender, uint256 amount) internal virtual {
410         require(owner != address(0), "ERC20: approve from the zero address");
411         require(spender != address(0), "ERC20: approve to the zero address");
412 
413         _allowances[owner][spender] = amount;
414         emit Approval(owner, spender, amount);
415     }
416 
417     /**
418      * @dev Hook that is called before any transfer of tokens. This includes
419      * minting and burning.
420      *
421      * Calling conditions:
422      *
423      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
424      * will be to transferred to `to`.
425      * - when `from` is zero, `amount` tokens will be minted for `to`.
426      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
427      * - `from` and `to` are never both zero.
428      *
429      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
430      */
431     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
432 }
433 
434 pragma solidity 0.8.4;
435 
436 
437 contract Owned {
438     address public owner;
439     address public nominatedOwner;
440     address public benefitial;
441     constructor(address _owner) public {
442         require(_owner != address(0), 'Owner address cannot be 0');
443         owner = _owner;
444         benefitial = _owner;
445         emit OwnerChanged(address(0), _owner);
446     }
447     function nominateNewOwner(address _owner) external isOwner {
448         nominatedOwner = _owner;
449         emit OwnerNominated(_owner);
450     }
451     function acceptOwnership() external {
452         require(msg.sender == nominatedOwner, 'You must be nominated before you can accept ownership');
453         emit OwnerChanged(owner, nominatedOwner);
454         owner = nominatedOwner;
455         nominatedOwner = address(0);
456     }
457     function transferBenefitial(address _benefitial) external isOwner {
458         address oldBenefitial = benefitial;
459         benefitial = _benefitial;
460         emit BenefitialChanged(oldBenefitial, benefitial);
461     }
462     modifier isOwner() {
463         require(owner == msg.sender, "You are not Owner");
464         _;
465     }
466     
467     event OwnerNominated(address indexed newOwner);
468     event OwnerChanged(address indexed oldOwner, address indexed newOwner);
469     event BenefitialChanged(address indexed oldBenefitial, address indexed newBenefitial);
470 }
471 
472 contract RCG is ERC20, Owned {
473   mapping (address => uint256) private _balances;
474   mapping (address => mapping (address => uint256)) private _allowed;
475 
476   string public constant tokenName = "Recharge";
477   string public constant tokenSymbol = "RCG";
478   uint256 _totalSupply = 0;
479   uint256 public basePercent = 0;
480 
481   constructor(address _owner, uint256 amount) ERC20(tokenName, tokenSymbol) Owned(_owner) {
482     _issue(msg.sender, amount);
483     _totalSupply=amount;
484   }
485     
486   function changeBurnRate(uint256 rate) public isOwner returns (bool){
487     basePercent = rate;
488     return true;
489   }
490   
491   /// @notice Returns total token supply
492   function totalSupply() public view override returns (uint256) {
493     return _totalSupply;
494   }
495 
496   /// @notice Returns user balance
497   function balanceOf(address owner) public view override returns (uint256) {
498     return _balances[owner];
499   }
500 
501   /// @notice Returns number of tokens that the owner has allowed the spender to withdraw
502   function allowance(address owner, address spender) public view override returns (uint256) {
503     return _allowed[owner][spender];
504   }
505 
506   /// @notice Returns value of calculate the quantity to destory during transfer
507   function cut(uint256 value) public view returns (uint256)  {
508     if(basePercent==0) return 0;
509     uint256 c = value+basePercent;
510     uint256 d = c-1;
511     uint256 roundValue = d/basePercent*basePercent;
512     uint256 cutValue = roundValue*basePercent/10000;
513     return cutValue;
514   }
515 
516   /// @notice From owner address sends value to address.
517   function transfer(address to, uint256 value) public override returns (bool) {
518     require(to != address(0), "Address cannot be 0x0");
519       
520     uint256 tokensToBurn = cut(value);
521     uint256 tokensToTransfer = value-tokensToBurn;
522 
523     _balances[msg.sender] = _balances[msg.sender]-value;
524     _balances[to] = _balances[to]+tokensToTransfer;
525     _balances[benefitial] = _balances[benefitial]+tokensToBurn;
526 
527     emit Transfer(msg.sender, to, tokensToTransfer);
528     emit Transfer(msg.sender, benefitial, tokensToBurn);
529     return true;
530   }
531 
532   /// @notice Give Spender the right to withdraw as much tokens as value
533   function approve(address spender, uint256 value) public override returns (bool) {
534     require(spender != address(0), "Address cannot be 0x0");
535     _allowed[msg.sender][spender] = value;
536     emit Approval(msg.sender, spender, value);
537     return true;
538   }
539 
540   /** @notice From address sends value to address.
541               However, this function can only be performed by a spender 
542               who is entitled to withdraw through the aprove function. 
543   */
544   function transferFrom(address from, address to, uint256 value) public override returns (bool) {
545     require(to != address(0), "Address cannot be 0x0");
546 
547     _balances[from] = _balances[from]-value;
548 
549     uint256 tokensToBurn = cut(value);
550     uint256 tokensToTransfer = value-tokensToBurn;
551 
552     _balances[to] = _balances[to]+tokensToTransfer;
553     _balances[benefitial] = _balances[benefitial]+tokensToBurn;
554 
555     _allowed[from][msg.sender] = _allowed[from][msg.sender]-value;
556 
557     emit Approval(from, msg.sender, _allowed[from][msg.sender]);
558     emit Transfer(from, to, tokensToTransfer);
559     emit Transfer(from, benefitial, tokensToBurn);
560 
561     return true;
562   }
563 
564   /// @notice Add the value of the privilege granted through the allowance function
565   function upAllowance(address spender, uint256 addedValue) public returns (bool) {
566     require(spender != address(0), "Address cannot be 0x0");
567     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender]+addedValue);
568     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
569     return true;
570   }
571 
572   /// @notice Subtract the value of the privilege granted through the allowance function
573   function downAllowance(address spender, uint256 subtractedValue) public returns (bool) {
574     require(spender != address(0), "Address cannot be 0x0");
575     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender]-subtractedValue);
576     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
577     return true;
578   }
579 
580   /// @notice Issue token from 0x address
581   function _issue(address account, uint256 amount) internal {
582     require(amount != 0, "Amount cannot be 0");
583     _balances[account] = _balances[account]+amount;
584     emit Transfer(address(0), account, amount);
585   }
586 
587   /// @notice Returns _destory function
588   function destroy(uint256 amount) external {
589     _destroy(msg.sender, amount);
590   }
591 
592   /// @notice Destroy the token by transferring it to the 0x address.
593   function _destroy(address account, uint256 amount) internal {
594     require(amount != 0, "Amount Cannot be 0");
595     _balances[account] = _balances[account]-amount;
596     _totalSupply = _totalSupply-amount;
597     emit Transfer(account, address(0), amount);
598   }
599 
600   /** @notice From address sends value 0x address.
601               However, this function can only be performed by a spender 
602               who is entitled to withdraw through the aprove function. 
603   */
604   function destroyFrom(address account, uint256 amount) external {
605     _allowed[account][msg.sender] = _allowed[account][msg.sender]-amount;
606     _destroy(account, amount);
607 
608     emit Approval(account, msg.sender, _allowed[account][msg.sender]);
609   }
610     
611 }