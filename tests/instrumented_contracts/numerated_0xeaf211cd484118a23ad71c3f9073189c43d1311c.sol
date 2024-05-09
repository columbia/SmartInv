1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.7.6;
4 
5 
6 
7 // Part: Context
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
20     function _msgSender() internal view virtual returns (address payable) {
21         return payable(msg.sender);
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 // Part: IERC20
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
46     function allowance(address owner, address spender) external view returns (uint256);
47     /**
48      * @dev Moves `amount` tokens from the caller's account to `recipient`.
49      *
50      * Returns a boolean value indicating whether the operation succeeded.
51      *
52      * Emits a {Transfer} event.
53      */
54     function transfer(address recipient, uint256 amount) external returns (bool);
55 
56     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
57     /**
58      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * IMPORTANT: Beware that changing an allowance with this method brings the risk
63      * that someone may use both the old and the new allowance by unfortunate
64      * transaction ordering. One possible solution to mitigate this race
65      * condition is to first reduce the spender's allowance to 0 and set the
66      * desired value afterwards:
67      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
68      *
69      * Emits an {Approval} event.
70      */
71     function approve(address spender, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Emitted when `value` tokens are moved from one account (`from`) to
75      * another (`to`).
76      *
77      * Note that `value` may be zero.
78      */
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 
81     /**
82      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
83      * a call to {approve}. `value` is the new allowance.
84      */
85     event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 // Part: SafeMath
89 
90 /**
91  * @dev Wrappers over Solidity's arithmetic operations with added overflow
92  * checks.
93  *
94  * Arithmetic operations in Solidity wrap on overflow. This can easily result
95  * in bugs, because programmers usually assume that an overflow raises an
96  * error, which is the standard behavior in high level programming languages.
97  * `SafeMath` restores this intuition by reverting the transaction when an
98  * operation overflows.
99  *
100  * Using this library instead of the unchecked operations eliminates an entire
101  * class of bugs, so it's recommended to use it always.
102  */
103 library SafeMath {
104     /**
105      * @dev Returns the addition of two unsigned integers, with an overflow flag.
106      *
107      * _Available since v3.4._
108      */
109     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
110         uint256 c = a + b;
111         if (c < a) return (false, 0);
112         return (true, c);
113     }
114 
115     /**
116      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
117      *
118      * _Available since v3.4._
119      */
120     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
121         if (b > a) return (false, 0);
122         return (true, a - b);
123     }
124 
125     /**
126      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
127      *
128      * _Available since v3.4._
129      */
130     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
131         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
132         // benefit is lost if 'b' is also tested.
133         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
134         if (a == 0) return (true, 0);
135         uint256 c = a * b;
136         if (c / a != b) return (false, 0);
137         return (true, c);
138     }
139 
140     /**
141      * @dev Returns the division of two unsigned integers, with a division by zero flag.
142      *
143      * _Available since v3.4._
144      */
145     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
146         if (b == 0) return (false, 0);
147         return (true, a / b);
148     }
149 
150     /**
151      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
152      *
153      * _Available since v3.4._
154      */
155     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
156         if (b == 0) return (false, 0);
157         return (true, a % b);
158     }
159 
160     /**
161      * @dev Returns the addition of two unsigned integers, reverting on
162      * overflow.
163      *
164      * Counterpart to Solidity's `+` operator.
165      *
166      * Requirements:
167      *
168      * - Addition cannot overflow.
169      */
170     function add(uint256 a, uint256 b) internal pure returns (uint256) {
171         uint256 c = a + b;
172         require(c >= a, "SafeMath: addition overflow");
173         return c;
174     }
175 
176     /**
177      * @dev Returns the subtraction of two unsigned integers, reverting on
178      * overflow (when the result is negative).
179      *
180      * Counterpart to Solidity's `-` operator.
181      *
182      * Requirements:
183      *
184      * - Subtraction cannot overflow.
185      */
186     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
187         require(b <= a, "SafeMath: subtraction overflow");
188         return a - b;
189     }
190 
191     /**
192      * @dev Returns the multiplication of two unsigned integers, reverting on
193      * overflow.
194      *
195      * Counterpart to Solidity's `*` operator.
196      *
197      * Requirements:
198      *
199      * - Multiplication cannot overflow.
200      */
201     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
202         if (a == 0) return 0;
203         uint256 c = a * b;
204         require(c / a == b, "SafeMath: multiplication overflow");
205         return c;
206     }
207 
208     /**
209      * @dev Returns the integer division of two unsigned integers, reverting on
210      * division by zero. The result is rounded towards zero.
211      *
212      * Counterpart to Solidity's `/` operator. Note: this function uses a
213      * `revert` opcode (which leaves remaining gas untouched) while Solidity
214      * uses an invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function div(uint256 a, uint256 b) internal pure returns (uint256) {
221         require(b > 0, "SafeMath: division by zero");
222         return a / b;
223     }
224 
225     /**
226      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
227      * reverting when dividing by zero.
228      *
229      * Counterpart to Solidity's `%` operator. This function uses a `revert`
230      * opcode (which leaves remaining gas untouched) while Solidity uses an
231      * invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      *
235      * - The divisor cannot be zero.
236      */
237     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
238         require(b > 0, "SafeMath: modulo by zero");
239         return a % b;
240     }
241 
242     /**
243      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
244      * overflow (when the result is negative).
245      *
246      * CAUTION: This function is deprecated because it requires allocating memory for the error
247      * message unnecessarily. For custom revert reasons use {trySub}.
248      *
249      * Counterpart to Solidity's `-` operator.
250      *
251      * Requirements:
252      *
253      * - Subtraction cannot overflow.
254      */
255     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
256         require(b <= a, errorMessage);
257         return a - b;
258     }
259 
260     /**
261      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
262      * division by zero. The result is rounded towards zero.
263      *
264      * CAUTION: This function is deprecated because it requires allocating memory for the error
265      * message unnecessarily. For custom revert reasons use {tryDiv}.
266      *
267      * Counterpart to Solidity's `/` operator. Note: this function uses a
268      * `revert` opcode (which leaves remaining gas untouched) while Solidity
269      * uses an invalid opcode to revert (consuming all remaining gas).
270      *
271      * Requirements:
272      *
273      * - The divisor cannot be zero.
274      */
275     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
276         require(b > 0, errorMessage);
277         return a / b;
278     }
279 
280     /**
281      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
282      * reverting with custom message when dividing by zero.
283      *
284      * CAUTION: This function is deprecated because it requires allocating memory for the error
285      * message unnecessarily. For custom revert reasons use {tryMod}.
286      *
287      * Counterpart to Solidity's `%` operator. This function uses a `revert`
288      * opcode (which leaves remaining gas untouched) while Solidity uses an
289      * invalid opcode to revert (consuming all remaining gas).
290      *
291      * Requirements:
292      *
293      * - The divisor cannot be zero.
294      */
295     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
296         require(b > 0, errorMessage);
297         return a % b;
298     }
299 }
300 
301 // Part: ERC20
302 
303 /**
304  * @dev Implementation of the {IERC20} interface.
305  *
306  * This implementation is agnostic to the way tokens are created. This means
307  * that a supply mechanism has to be added in a derived contract using {_mint}.
308  * For a generic mechanism see {ERC20PresetMinterPauser}.
309  *
310  * TIP: For a detailed writeup see our guide
311  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
312  * to implement supply mechanisms].
313  *
314  * We have followed general OpenZeppelin guidelines: functions revert instead
315  * of returning `false` on failure. This behavior is nonetheless conventional
316  * and does not conflict with the expectations of ERC20 applications.
317  *
318  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
319  * This allows applications to reconstruct the allowance for all accounts just
320  * by listening to said events. Other implementations of the EIP may not emit
321  * these events, as it isn't required by the specification.
322  *
323  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
324  * functions have been added to mitigate the well-known issues around setting
325  * allowances. See {IERC20-approve}.
326  */
327 contract ERC20 is Context, IERC20 {
328     using SafeMath for uint256;
329 
330     mapping (address => uint256) private _balances;
331 
332     mapping (address => mapping (address => uint256)) private _allowances;
333 
334     uint256 private _totalSupply; // 2 million initial supply
335     string private _name = "PIXA Token";
336     string private _symbol = "PIXA";
337     uint8 private _decimals = 0;
338     address payable wizarDAO = 0x717e63BF905fF0f433333B6f0a289b66462Cd8a1; //starts with temporary address
339     address payable pixalyfewallet = 0x5c2B89CBeC1a4996Aa5e81f3dFf8505ABeC6B34c; // PixaLyfe wallet
340     bool public wizarDAOlock = true;
341     /**
342      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
343      * a default value of 18.
344      *
345      * To select a different value for {decimals}, use {_setupDecimals}.
346      *
347      * All three of these values are immutable: they can only be set once during
348      * construction.
349      */
350     /**
351      * @dev Returns the name of the token.
352      */
353     function name() public view virtual returns (string memory) {
354         return _name;
355     }
356 
357     /**
358      * @dev Returns the symbol of the token, usually a shorter version of the
359      * name.
360      */
361     function symbol() public view virtual returns (string memory) {
362         return _symbol;
363     }
364 
365     /**
366      * @dev Returns the number of decimals used to get its user representation.
367      * For example, if `decimals` equals `2`, a balance of `505` tokens should
368      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
369      *
370      * Tokens usually opt for a value of 18, imitating the relationship between
371      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
372      * called.
373      *
374      * NOTE: This information is only used for _display_ purposes: it in
375      * no way affects any of the arithmetic of the contract, including
376      * {IERC20-balanceOf} and {IERC20-transfer}.
377      */
378     function decimals() public view virtual returns (uint8) {
379         return _decimals;
380     }
381 
382     /**
383      * @dev See {IERC20-totalSupply}.
384      */
385     function totalSupply() public view virtual override returns (uint256) {
386         return _totalSupply;
387     }
388 
389     /**
390      * @dev See {IERC20-balanceOf}.
391      */
392     function balanceOf(address account) public view virtual override returns (uint256) {
393         return _balances[account];
394     }
395 
396     /**
397      * @dev See {IERC20-transfer}.
398      *
399      * Requirements:
400      *
401      * - `recipient` cannot be the zero address.
402      * - the caller must have a balance of at least `amount`.
403      */
404     function transfer(address recipient, uint256 initamount) public virtual override returns (bool) {
405         require(initamount >= 1, "Transfer amount must be greater or equal to 1 $PIXA");
406         uint256 amount = initamount;
407         address wizarDAOtrue = read_address();
408         _transfer(_msgSender(), recipient, amount-1); // amount - 1 to reciever
409         _transfer(_msgSender(), wizarDAOtrue, 1); // tax to WizarDAO
410         _mint(wizarDAOtrue, 10); // Mint  10 more to WizarDAO
411     }
412 
413     // lock DAO address, tax & mints will be locked to the wizarDAO address.
414     function daoLock() public {
415         require(msg.sender == pixalyfewallet);
416         wizarDAOlock = false;
417     } 
418 
419     // update to new address (eventually permanent with daoLock bool false)
420     function updateDAOwallet(address payable newAddress) public {
421         require(msg.sender == pixalyfewallet);
422         require(wizarDAOlock);
423         wizarDAO = newAddress;
424     } 
425 
426     // reads current DAO address 
427     function read_address() public view returns (address) {
428         return wizarDAO;
429     } 
430 
431 
432     function burn(uint256 amount) public virtual {
433         _burn(_msgSender(), amount);
434     }
435 
436     /**
437      * @dev See {IERC20-approve}.
438      *
439      * Requirements:
440      *
441      * - `spender` cannot be the zero address.
442      */
443     function approve(address spender, uint256 amount) public virtual override returns (bool) {
444         _approve(_msgSender(), spender, amount);
445         return true;
446     }
447 
448     /**
449      * @dev Moves tokens `amount` from `sender` to `recipient`.
450      *
451      * This is internal function is equivalent to {transfer}, and can be used to
452      * e.g. implement automatic token fees, slashing mechanisms, etc.
453      *
454      * Emits a {Transfer} event.
455      *
456      * Requirements:
457      *
458      * - `sender` cannot be the zero address.
459      * - `recipient` cannot be the zero address.
460      * - `sender` must have a balance of at least `amount`.
461      */
462     function _transfer(address sender, address recipient, uint256 amount) internal virtual returns (bool) {
463         require(sender != address(0), "ERC20: transfer from the zero address");
464         require(recipient != address(0), "ERC20: transfer to the zero address");
465 
466         _beforeTokenTransfer(sender, recipient, amount);
467 
468         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
469         _balances[recipient] = _balances[recipient].add(amount);
470         emit Transfer(sender, recipient, amount);
471         return true;
472     }
473 
474     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
475      * the total supply.
476      *
477      * Emits a {Transfer} event with `from` set to the zero address.
478      *
479      * Requirements:
480      *
481      * - `to` cannot be the zero address.
482      */
483     function _mint(address account, uint256 amount) internal virtual {
484         require(account != address(0), "ERC20: mint to the zero address");
485 
486         _beforeTokenTransfer(address(0), account, amount);
487 
488         _totalSupply = _totalSupply.add(amount);
489         _balances[account] = _balances[account].add(amount);
490         emit Transfer(address(0), account, amount);
491     }
492 
493     /**
494      * @dev Destroys `amount` tokens from `account`, reducing the
495      * total supply.
496      *
497      * Emits a {Transfer} event with `to` set to the zero address.
498      *
499      * Requirements:
500      *
501      * - `account` cannot be the zero address.
502      * - `account` must have at least `amount` tokens.
503      */
504     function _burn(address account, uint256 amount) internal virtual {
505         require(account != address(0), "ERC20: burn from the zero address");
506 
507         _beforeTokenTransfer(account, address(0), amount);
508 
509         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
510         _totalSupply = _totalSupply.sub(amount);
511         emit Transfer(account, address(0), amount);
512     }
513 
514     /**
515      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
516      *
517      * This internal function is equivalent to `approve`, and can be used to
518      * e.g. set automatic allowances for certain subsystems, etc.
519      *
520      * Emits an {Approval} event.
521      *
522      * Requirements:
523      *
524      * - `owner` cannot be the zero address.
525      * - `spender` cannot be the zero address.
526      */
527     function _approve(address owner, address spender, uint256 amount) internal virtual {
528         require(owner != address(0), "ERC20: approve from the zero address");
529         require(spender != address(0), "ERC20: approve to the zero address");
530 
531         _allowances[owner][spender] = amount;
532         emit Approval(owner, spender, amount);
533     }
534 
535     /**
536      * @dev Sets {decimals} to a value other than the default one of 18.
537      *
538      * WARNING: This function should only be called from the constructor. Most
539      * applications that interact with token contracts will not expect
540      * {decimals} to ever change, and may work incorrectly if it does.
541      */
542     function _setupDecimals(uint8 decimals_) internal virtual {
543         _decimals = decimals_;
544     }
545 
546     /**
547      * @dev Hook that is called before any transfer of tokens. This includes
548      * minting and burning.
549      *
550      * Calling conditions:
551      *
552      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
553      * will be to transferred to `to`.
554      * - when `from` is zero, `amount` tokens will be minted for `to`.
555      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
556      * - `from` and `to` are never both zero.
557      *
558      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
559      */
560     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
561 
562 
563     function allowance(address owner, address spender) public view virtual override returns (uint256) {
564         return _allowances[owner][spender];
565     }
566 
567     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
568         _transfer(sender, recipient, amount);
569         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
570         return true;
571     }
572 
573     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
574         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
575         return true;
576     }
577 
578     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
579         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
580         return true;
581     }
582 
583 }
584 
585 // File: PIXA.sol
586 
587 contract PIXA is ERC20 {
588     using SafeMath for uint256;
589     uint256 public tokenPrice = 10000000000000; // 0.00001 ETH
590     uint256 public tokensSold = 0; // At deployment, zero tokens sold.
591     address payable wizarDAOtemp = 0x717e63BF905fF0f433333B6f0a289b66462Cd8a1; //temporary DAO wallet
592     address payable pixadeploywallet = 0x6936Ec090eEB012A81Ada463FCf55BB3dFd86264; // deployment wallet
593     bool public saleStatus = false;
594     event Sell(address _buyer, uint256 _amount); // Purchase during ICO
595 
596     /**
597      * @dev Constructor that gives msg.sender all of existing tokens.
598      */
599     constructor(
600         uint256 initialSupply //define initial supply of 3 mil. tokens.
601 
602     ) ERC20() {
603         _mint(address(this), 500000); // initial mint 1/4 for ICO
604         _mint(pixalyfewallet, 500000); // initial mint 1/4 for airdrops & marketing
605         _mint(wizarDAOtemp, 1000000); // initial mint 1/2 to DAO
606     }// 2 million PIXA initial supply, priced at 0.00001 ETH per for ICO, market cap est. 20 ETH.
607 
608     function multiply(uint x, uint y) internal pure returns (uint z) {
609         require(y == 0 || (z = x * y) / y == x);
610     }
611 
612     // start ICO
613     function startSale() public {
614         require(msg.sender == pixalyfewallet);
615         saleStatus = true;
616     } 
617 
618     // close ICO
619     function endSale() public {
620         require(msg.sender == pixalyfewallet);
621         saleStatus = false;
622     } 
623 
624     // Function to buy tokens during ICO, need sale toggle on.
625     function buyTokens(uint256 _numberOfTokens) public payable {
626         require(saleStatus);
627         require(msg.value == multiply(_numberOfTokens, tokenPrice));
628         require(balanceOf(address(this)) >= _numberOfTokens);
629         require(_transfer(address(this), msg.sender, _numberOfTokens));
630 
631         tokensSold += _numberOfTokens;
632 
633         emit Sell(msg.sender, _numberOfTokens);
634     }
635 
636     function getBalance() public view returns (uint256) {
637         return address(this).balance;
638     }
639 
640     // withdraw eth from ico deposited in contract to pixalyfe wallet
641     function withdrawAmount() public {
642         require(msg.sender == pixalyfewallet);
643         uint256 amount = getBalance();
644         msg.sender.transfer(amount);
645     }    
646 
647     // leftover PIXA from ICO goes to WizarDAO
648     function withdrawPixa(uint256 amount) public {
649         require(msg.sender == pixalyfewallet);
650         address wizarDAOwith = read_address();
651         _transfer(address(this), wizarDAOwith, amount);
652     }    
653 
654 
655 
656 
657 }
