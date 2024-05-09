1 /**
2 
3 
4 𝘛𝘩𝘦 𝘚𝘩𝘪 𝘛𝘦𝘮𝘱𝘭𝘦 𝘪𝘯𝘵𝘳𝘰𝘥𝘶𝘤𝘦𝘴 𝘵𝘰 𝘵𝘩𝘦 𝘣𝘭𝘰𝘤𝘬𝘤𝘩𝘢𝘪𝘯 𝘢 𝘻𝘦𝘯-𝘭𝘪𝘬𝘦 𝘸𝘰𝘳𝘭𝘥 𝘧𝘪𝘭𝘭𝘦𝘥 𝘸𝘪𝘵𝘩 𝘱𝘦𝘢𝘤𝘦𝘧𝘶𝘭 𝘧𝘦𝘦𝘭𝘪𝘯𝘨𝘴, 𝘮𝘦𝘥𝘪𝘵𝘢𝘵𝘪𝘰𝘯, 𝘣𝘳𝘦𝘢𝘵𝘩𝘵𝘢𝘬𝘪𝘯𝘨 𝘯𝘢𝘵𝘶𝘳𝘢𝘭 𝘣𝘦𝘢𝘶𝘵𝘺, 𝘢𝘯𝘥 𝘴𝘱𝘪𝘳𝘪𝘵𝘶𝘢𝘭 𝘤𝘰𝘯𝘯𝘦𝘤𝘵𝘪𝘰𝘯𝘴.
5 
6 
7 https://zenshitemple.com/
8 
9 https://t.me/JetchiJournal 
10 
11 
12 
13 𝘚𝘵𝘦𝘢𝘭𝘵𝘩 𝘭𝘢𝘶𝘯𝘤𝘩 𝘣𝘺 𝘑𝘦𝘵𝘤𝘩𝘪 𝘥𝘦𝘷
14 
15 
16 
17 
18 
19 
20 /**
21  
22 // SPDX-License-Identifier: Unlicensed
23 
24 
25 */
26 pragma solidity 0.8.9;
27  
28 abstract contract Context {
29     function _msgSender() internal view virtual returns (address) {
30         return msg.sender;
31     }
32  
33     function _msgData() internal view virtual returns (bytes calldata) {
34         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
35         return msg.data;
36     }
37 }
38  
39 interface IUniswapV2Pair {
40     event Approval(address indexed owner, address indexed spender, uint value);
41     event Transfer(address indexed from, address indexed to, uint value);
42  
43     function name() external pure returns (string memory);
44     function symbol() external pure returns (string memory);
45     function decimals() external pure returns (uint8);
46     function totalSupply() external view returns (uint);
47     function balanceOf(address owner) external view returns (uint);
48     function allowance(address owner, address spender) external view returns (uint);
49  
50     function approve(address spender, uint value) external returns (bool);
51     function transfer(address to, uint value) external returns (bool);
52     function transferFrom(address from, address to, uint value) external returns (bool);
53  
54     function DOMAIN_SEPARATOR() external view returns (bytes32);
55     function PERMIT_TYPEHASH() external pure returns (bytes32);
56     function nonces(address owner) external view returns (uint);
57  
58     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
59  
60     event Mint(address indexed sender, uint amount0, uint amount1);
61     event Swap(
62         address indexed sender,
63         uint amount0In,
64         uint amount1In,
65         uint amount0Out,
66         uint amount1Out,
67         address indexed to
68     );
69     event Sync(uint112 reserve0, uint112 reserve1);
70  
71     function MINIMUM_LIQUIDITY() external pure returns (uint);
72     function factory() external view returns (address);
73     function token0() external view returns (address);
74     function token1() external view returns (address);
75     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
76     function price0CumulativeLast() external view returns (uint);
77     function price1CumulativeLast() external view returns (uint);
78     function kLast() external view returns (uint);
79  
80     function mint(address to) external returns (uint liquidity);
81     function burn(address to) external returns (uint amount0, uint amount1);
82     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
83     function skim(address to) external;
84     function sync() external;
85  
86     function initialize(address, address) external;
87 }
88  
89 interface IUniswapV2Factory {
90     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
91  
92     function feeTo() external view returns (address);
93     function feeToSetter() external view returns (address);
94  
95     function getPair(address tokenA, address tokenB) external view returns (address pair);
96     function allPairs(uint) external view returns (address pair);
97     function allPairsLength() external view returns (uint);
98  
99     function createPair(address tokenA, address tokenB) external returns (address pair);
100  
101     function setFeeTo(address) external;
102     function setFeeToSetter(address) external;
103 }
104  
105 interface IERC20 {
106     /**
107      * @dev Returns the amount of tokens in existence.
108      */
109     function totalSupply() external view returns (uint256);
110  
111     /**
112      * @dev Returns the amount of tokens owned by `account`.
113      */
114     function balanceOf(address account) external view returns (uint256);
115  
116     /**
117      * @dev Moves `amount` tokens from the caller's account to `recipient`.
118      *
119      * Returns a boolean value indicating whether the operation succeeded.
120      *
121      * Emits a {Transfer} event.
122      */
123     function transfer(address recipient, uint256 amount) external returns (bool);
124  
125     /**
126      * @dev Returns the remaining number of tokens that `spender` will be
127      * allowed to spend on behalf of `owner` through {transferFrom}. This is
128      * zero by default.
129      *
130      * This value changes when {approve} or {transferFrom} are called.
131      */
132     function allowance(address owner, address spender) external view returns (uint256);
133  
134     /**
135      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
136      *
137      * Returns a boolean value indicating whether the operation succeeded.
138      *
139      * IMPORTANT: Beware that changing an allowance with this method brings the risk
140      * that someone may use both the old and the new allowance by unfortunate
141      * transaction ordering. One possible solution to mitigate this race
142      * condition is to first reduce the spender's allowance to 0 and set the
143      * desired value afterwards:
144      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
145      *
146      * Emits an {Approval} event.
147      */
148     function approve(address spender, uint256 amount) external returns (bool);
149  
150     /**
151      * @dev Moves `amount` tokens from `sender` to `recipient` using the
152      * allowance mechanism. `amount` is then deducted from the caller's
153      * allowance.
154      *
155      * Returns a boolean value indicating whether the operation succeeded.
156      *
157      * Emits a {Transfer} event.
158      */
159     function transferFrom(
160         address sender,
161         address recipient,
162         uint256 amount
163     ) external returns (bool);
164  
165     /**
166      * @dev Emitted when `value` tokens are moved from one account (`from`) to
167      * another (`to`).
168      *
169      * Note that `value` may be zero.
170      */
171     event Transfer(address indexed from, address indexed to, uint256 value);
172  
173     /**
174      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
175      * a call to {approve}. `value` is the new allowance.
176      */
177     event Approval(address indexed owner, address indexed spender, uint256 value);
178 }
179  
180 interface IERC20Metadata is IERC20 {
181     /**
182      * @dev Returns the name of the token.
183      */
184     function name() external view returns (string memory);
185  
186     /**
187      * @dev Returns the symbol of the token.
188      */
189     function symbol() external view returns (string memory);
190  
191     /**
192      * @dev Returns the decimals places of the token.
193      */
194     function decimals() external view returns (uint8);
195 }
196  
197  
198 contract ERC20 is Context, IERC20, IERC20Metadata {
199     using SafeMath for uint256;
200  
201     mapping(address => uint256) private _balances;
202  
203     mapping(address => mapping(address => uint256)) private _allowances;
204  
205     uint256 private _totalSupply;
206  
207     string private _name;
208     string private _symbol;
209  
210     /**
211      * @dev Sets the values for {name} and {symbol}.
212      *
213      * The default value of {decimals} is 18. To select a different value for
214      * {decimals} you should overload it.
215      *
216      * All two of these values are immutable: they can only be set once during
217      * construction.
218      */
219     constructor(string memory name_, string memory symbol_) {
220         _name = name_;
221         _symbol = symbol_;
222     }
223  
224     /**
225      * @dev Returns the name of the token.
226      */
227     function name() public view virtual override returns (string memory) {
228         return _name;
229     }
230  
231     /**
232      * @dev Returns the symbol of the token, usually a shorter version of the
233      * name.
234      */
235     function symbol() public view virtual override returns (string memory) {
236         return _symbol;
237     }
238  
239     /**
240      * @dev Returns the number of decimals used to get its user representation.
241      * For example, if `decimals` equals `2`, a balance of `505` tokens should
242      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
243      *
244      * Tokens usually opt for a value of 18, imitating the relationship between
245      * Ether and Wei. This is the value {ERC20} uses, unless this function is
246      * overridden;
247      *
248      * NOTE: This information is only used for _display_ purposes: it in
249      * no way affects any of the arithmetic of the contract, including
250      * {IERC20-balanceOf} and {IERC20-transfer}.
251      */
252     function decimals() public view virtual override returns (uint8) {
253         return 18;
254     }
255  
256     /**
257      * @dev See {IERC20-totalSupply}.
258      */
259     function totalSupply() public view virtual override returns (uint256) {
260         return _totalSupply;
261     }
262  
263     /**
264      * @dev See {IERC20-balanceOf}.
265      */
266     function balanceOf(address account) public view virtual override returns (uint256) {
267         return _balances[account];
268     }
269  
270     /**
271      * @dev See {IERC20-transfer}.
272      *
273      * Requirements:
274      *
275      * - `recipient` cannot be the zero address.
276      * - the caller must have a balance of at least `amount`.
277      */
278     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
279         _transfer(_msgSender(), recipient, amount);
280         return true;
281     }
282  
283     /**
284      * @dev See {IERC20-allowance}.
285      */
286     function allowance(address owner, address spender) public view virtual override returns (uint256) {
287         return _allowances[owner][spender];
288     }
289  
290     /**
291      * @dev See {IERC20-approve}.
292      *
293      * Requirements:
294      *
295      * - `spender` cannot be the zero address.
296      */
297     function approve(address spender, uint256 amount) public virtual override returns (bool) {
298         _approve(_msgSender(), spender, amount);
299         return true;
300     }
301  
302     /**
303      * @dev See {IERC20-transferFrom}.
304      *
305      * Emits an {Approval} event indicating the updated allowance. This is not
306      * required by the EIP. See the note at the beginning of {ERC20}.
307      *
308      * Requirements:
309      *
310      * - `sender` and `recipient` cannot be the zero address.
311      * - `sender` must have a balance of at least `amount`.
312      * - the caller must have allowance for ``sender``'s tokens of at least
313      * `amount`.
314      */
315     function transferFrom(
316         address sender,
317         address recipient,
318         uint256 amount
319     ) public virtual override returns (bool) {
320         _transfer(sender, recipient, amount);
321         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
322         return true;
323     }
324  
325     /**
326      * @dev Atomically increases the allowance granted to `spender` by the caller.
327      *
328      * This is an alternative to {approve} that can be used as a mitigation for
329      * problems described in {IERC20-approve}.
330      *
331      * Emits an {Approval} event indicating the updated allowance.
332      *
333      * Requirements:
334      *
335      * - `spender` cannot be the zero address.
336      */
337     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
338         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
339         return true;
340     }
341  
342     /**
343      * @dev Atomically decreases the allowance granted to `spender` by the caller.
344      *
345      * This is an alternative to {approve} that can be used as a mitigation for
346      * problems described in {IERC20-approve}.
347      *
348      * Emits an {Approval} event indicating the updated allowance.
349      *
350      * Requirements:
351      *
352      * - `spender` cannot be the zero address.
353      * - `spender` must have allowance for the caller of at least
354      * `subtractedValue`.
355      */
356     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
357         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
358         return true;
359     }
360  
361     /**
362      * @dev Moves tokens `amount` from `sender` to `recipient`.
363      *
364      * This is internal function is equivalent to {transfer}, and can be used to
365      * e.g. implement automatic token fees, slashing mechanisms, etc.
366      *
367      * Emits a {Transfer} event.
368      *
369      * Requirements:
370      *
371      * - `sender` cannot be the zero address.
372      * - `recipient` cannot be the zero address.
373      * - `sender` must have a balance of at least `amount`.
374      */
375     function _transfer(
376         address sender,
377         address recipient,
378         uint256 amount
379     ) internal virtual {
380         require(sender != address(0), "ERC20: transfer from the zero address");
381         require(recipient != address(0), "ERC20: transfer to the zero address");
382  
383         _beforeTokenTransfer(sender, recipient, amount);
384  
385         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
386         _balances[recipient] = _balances[recipient].add(amount);
387         emit Transfer(sender, recipient, amount);
388     }
389  
390     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
391      * the total supply.
392      *
393      * Emits a {Transfer} event with `from` set to the zero address.
394      *
395      * Requirements:
396      *
397      * - `account` cannot be the zero address.
398      */
399     function _mint(address account, uint256 amount) internal virtual {
400         require(account != address(0), "ERC20: mint to the zero address");
401  
402         _beforeTokenTransfer(address(0), account, amount);
403  
404         _totalSupply = _totalSupply.add(amount);
405         _balances[account] = _balances[account].add(amount);
406         emit Transfer(address(0), account, amount);
407     }
408  
409     /**
410      * @dev Destroys `amount` tokens from `account`, reducing the
411      * total supply.
412      *
413      * Emits a {Transfer} event with `to` set to the zero address.
414      *
415      * Requirements:
416      *
417      * - `account` cannot be the zero address.
418      * - `account` must have at least `amount` tokens.
419      */
420     function _burn(address account, uint256 amount) internal virtual {
421         require(account != address(0), "ERC20: burn from the zero address");
422  
423         _beforeTokenTransfer(account, address(0), amount);
424  
425         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
426         _totalSupply = _totalSupply.sub(amount);
427         emit Transfer(account, address(0), amount);
428     }
429  
430     /**
431      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
432      *
433      * This internal function is equivalent to `approve`, and can be used to
434      * e.g. set automatic allowances for certain subsystems, etc.
435      *
436      * Emits an {Approval} event.
437      *
438      * Requirements:
439      *
440      * - `owner` cannot be the zero address.
441      * - `spender` cannot be the zero address.
442      */
443     function _approve(
444         address owner,
445         address spender,
446         uint256 amount
447     ) internal virtual {
448         require(owner != address(0), "ERC20: approve from the zero address");
449         require(spender != address(0), "ERC20: approve to the zero address");
450  
451         _allowances[owner][spender] = amount;
452         emit Approval(owner, spender, amount);
453     }
454  
455     /**
456      * @dev Hook that is called before any transfer of tokens. This includes
457      * minting and burning.
458      *
459      * Calling conditions:
460      *
461      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
462      * will be to transferred to `to`.
463      * - when `from` is zero, `amount` tokens will be minted for `to`.
464      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
465      * - `from` and `to` are never both zero.
466      *
467      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
468      */
469     function _beforeTokenTransfer(
470         address from,
471         address to,
472         uint256 amount
473     ) internal virtual {}
474 }
475  
476 library SafeMath {
477     /**
478      * @dev Returns the addition of two unsigned integers, reverting on
479      * overflow.
480      *
481      * Counterpart to Solidity's `+` operator.
482      *
483      * Requirements:
484      *
485      * - Addition cannot overflow.
486      */
487     function add(uint256 a, uint256 b) internal pure returns (uint256) {
488         uint256 c = a + b;
489         require(c >= a, "SafeMath: addition overflow");
490  
491         return c;
492     }
493  
494     /**
495      * @dev Returns the subtraction of two unsigned integers, reverting on
496      * overflow (when the result is negative).
497      *
498      * Counterpart to Solidity's `-` operator.
499      *
500      * Requirements:
501      *
502      * - Subtraction cannot overflow.
503      */
504     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
505         return sub(a, b, "SafeMath: subtraction overflow");
506     }
507  
508     /**
509      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
510      * overflow (when the result is negative).
511      *
512      * Counterpart to Solidity's `-` operator.
513      *
514      * Requirements:
515      *
516      * - Subtraction cannot overflow.
517      */
518     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
519         require(b <= a, errorMessage);
520         uint256 c = a - b;
521  
522         return c;
523     }
524  
525     /**
526      * @dev Returns the multiplication of two unsigned integers, reverting on
527      * overflow.
528      *
529      * Counterpart to Solidity's `*` operator.
530      *
531      * Requirements:
532      *
533      * - Multiplication cannot overflow.
534      */
535     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
536         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
537         // benefit is lost if 'b' is also tested.
538         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
539         if (a == 0) {
540             return 0;
541         }
542  
543         uint256 c = a * b;
544         require(c / a == b, "SafeMath: multiplication overflow");
545  
546         return c;
547     }
548  
549     /**
550      * @dev Returns the integer division of two unsigned integers. Reverts on
551      * division by zero. The result is rounded towards zero.
552      *
553      * Counterpart to Solidity's `/` operator. Note: this function uses a
554      * `revert` opcode (which leaves remaining gas untouched) while Solidity
555      * uses an invalid opcode to revert (consuming all remaining gas).
556      *
557      * Requirements:
558      *
559      * - The divisor cannot be zero.
560      */
561     function div(uint256 a, uint256 b) internal pure returns (uint256) {
562         return div(a, b, "SafeMath: division by zero");
563     }
564  
565     /**
566      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
567      * division by zero. The result is rounded towards zero.
568      *
569      * Counterpart to Solidity's `/` operator. Note: this function uses a
570      * `revert` opcode (which leaves remaining gas untouched) while Solidity
571      * uses an invalid opcode to revert (consuming all remaining gas).
572      *
573      * Requirements:
574      *
575      * - The divisor cannot be zero.
576      */
577     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
578         require(b > 0, errorMessage);
579         uint256 c = a / b;
580         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
581  
582         return c;
583     }
584  
585     /**
586      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
587      * Reverts when dividing by zero.
588      *
589      * Counterpart to Solidity's `%` operator. This function uses a `revert`
590      * opcode (which leaves remaining gas untouched) while Solidity uses an
591      * invalid opcode to revert (consuming all remaining gas).
592      *
593      * Requirements:
594      *
595      * - The divisor cannot be zero.
596      */
597     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
598         return mod(a, b, "SafeMath: modulo by zero");
599     }
600  
601     /**
602      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
603      * Reverts with custom message when dividing by zero.
604      *
605      * Counterpart to Solidity's `%` operator. This function uses a `revert`
606      * opcode (which leaves remaining gas untouched) while Solidity uses an
607      * invalid opcode to revert (consuming all remaining gas).
608      *
609      * Requirements:
610      *
611      * - The divisor cannot be zero.
612      */
613     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
614         require(b != 0, errorMessage);
615         return a % b;
616     }
617 }
618  
619 contract Ownable is Context {
620     address private _owner;
621  
622     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
623  
624     /**
625      * @dev Initializes the contract setting the deployer as the initial owner.
626      */
627     constructor () {
628         address msgSender = _msgSender();
629         _owner = msgSender;
630         emit OwnershipTransferred(address(0), msgSender);
631     }
632  
633     /**
634      * @dev Returns the address of the current owner.
635      */
636     function owner() public view returns (address) {
637         return _owner;
638     }
639  
640     /**
641      * @dev Throws if called by any account other than the owner.
642      */
643     modifier onlyOwner() {
644         require(_owner == _msgSender(), "Ownable: caller is not the owner");
645         _;
646     }
647  
648     /**
649      * @dev Leaves the contract without owner. It will not be possible to call
650      * `onlyOwner` functions anymore. Can only be called by the current owner.
651      *
652      * NOTE: Renouncing ownership will leave the contract without an owner,
653      * thereby removing any functionality that is only available to the owner.
654      */
655     function renounceOwnership() public virtual onlyOwner {
656         emit OwnershipTransferred(_owner, address(0));
657         _owner = address(0);
658     }
659  
660     /**
661      * @dev Transfers ownership of the contract to a new account (`newOwner`).
662      * Can only be called by the current owner.
663      */
664     function transferOwnership(address newOwner) public virtual onlyOwner {
665         require(newOwner != address(0), "Ownable: new owner is the zero address");
666         emit OwnershipTransferred(_owner, newOwner);
667         _owner = newOwner;
668     }
669 }
670  
671  
672  
673 library SafeMathInt {
674     int256 private constant MIN_INT256 = int256(1) << 255;
675     int256 private constant MAX_INT256 = ~(int256(1) << 255);
676  
677     /**
678      * @dev Multiplies two int256 variables and fails on overflow.
679      */
680     function mul(int256 a, int256 b) internal pure returns (int256) {
681         int256 c = a * b;
682  
683         // Detect overflow when multiplying MIN_INT256 with -1
684         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
685         require((b == 0) || (c / b == a));
686         return c;
687     }
688  
689     /**
690      * @dev Division of two int256 variables and fails on overflow.
691      */
692     function div(int256 a, int256 b) internal pure returns (int256) {
693         // Prevent overflow when dividing MIN_INT256 by -1
694         require(b != -1 || a != MIN_INT256);
695  
696         // Solidity already throws when dividing by 0.
697         return a / b;
698     }
699  
700     /**
701      * @dev Subtracts two int256 variables and fails on overflow.
702      */
703     function sub(int256 a, int256 b) internal pure returns (int256) {
704         int256 c = a - b;
705         require((b >= 0 && c <= a) || (b < 0 && c > a));
706         return c;
707     }
708  
709     /**
710      * @dev Adds two int256 variables and fails on overflow.
711      */
712     function add(int256 a, int256 b) internal pure returns (int256) {
713         int256 c = a + b;
714         require((b >= 0 && c >= a) || (b < 0 && c < a));
715         return c;
716     }
717  
718     /**
719      * @dev Converts to absolute value, and fails on overflow.
720      */
721     function abs(int256 a) internal pure returns (int256) {
722         require(a != MIN_INT256);
723         return a < 0 ? -a : a;
724     }
725  
726  
727     function toUint256Safe(int256 a) internal pure returns (uint256) {
728         require(a >= 0);
729         return uint256(a);
730     }
731 }
732  
733 library SafeMathUint {
734   function toInt256Safe(uint256 a) internal pure returns (int256) {
735     int256 b = int256(a);
736     require(b >= 0);
737     return b;
738   }
739 }
740  
741  
742 interface IUniswapV2Router01 {
743     function factory() external pure returns (address);
744     function WETH() external pure returns (address);
745  
746     function addLiquidity(
747         address tokenA,
748         address tokenB,
749         uint amountADesired,
750         uint amountBDesired,
751         uint amountAMin,
752         uint amountBMin,
753         address to,
754         uint deadline
755     ) external returns (uint amountA, uint amountB, uint liquidity);
756     function addLiquidityETH(
757         address token,
758         uint amountTokenDesired,
759         uint amountTokenMin,
760         uint amountETHMin,
761         address to,
762         uint deadline
763     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
764     function removeLiquidity(
765         address tokenA,
766         address tokenB,
767         uint liquidity,
768         uint amountAMin,
769         uint amountBMin,
770         address to,
771         uint deadline
772     ) external returns (uint amountA, uint amountB);
773     function removeLiquidityETH(
774         address token,
775         uint liquidity,
776         uint amountTokenMin,
777         uint amountETHMin,
778         address to,
779         uint deadline
780     ) external returns (uint amountToken, uint amountETH);
781     function removeLiquidityWithPermit(
782         address tokenA,
783         address tokenB,
784         uint liquidity,
785         uint amountAMin,
786         uint amountBMin,
787         address to,
788         uint deadline,
789         bool approveMax, uint8 v, bytes32 r, bytes32 s
790     ) external returns (uint amountA, uint amountB);
791     function removeLiquidityETHWithPermit(
792         address token,
793         uint liquidity,
794         uint amountTokenMin,
795         uint amountETHMin,
796         address to,
797         uint deadline,
798         bool approveMax, uint8 v, bytes32 r, bytes32 s
799     ) external returns (uint amountToken, uint amountETH);
800     function swapExactTokensForTokens(
801         uint amountIn,
802         uint amountOutMin,
803         address[] calldata path,
804         address to,
805         uint deadline
806     ) external returns (uint[] memory amounts);
807     function swapTokensForExactTokens(
808         uint amountOut,
809         uint amountInMax,
810         address[] calldata path,
811         address to,
812         uint deadline
813     ) external returns (uint[] memory amounts);
814     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
815         external
816         payable
817         returns (uint[] memory amounts);
818     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
819         external
820         returns (uint[] memory amounts);
821     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
822         external
823         returns (uint[] memory amounts);
824     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
825         external
826         payable
827         returns (uint[] memory amounts);
828  
829     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
830     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
831     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
832     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
833     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
834 }
835  
836 interface IUniswapV2Router02 is IUniswapV2Router01 {
837     function removeLiquidityETHSupportingFeeOnTransferTokens(
838         address token,
839         uint liquidity,
840         uint amountTokenMin,
841         uint amountETHMin,
842         address to,
843         uint deadline
844     ) external returns (uint amountETH);
845     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
846         address token,
847         uint liquidity,
848         uint amountTokenMin,
849         uint amountETHMin,
850         address to,
851         uint deadline,
852         bool approveMax, uint8 v, bytes32 r, bytes32 s
853     ) external returns (uint amountETH);
854  
855     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
856         uint amountIn,
857         uint amountOutMin,
858         address[] calldata path,
859         address to,
860         uint deadline
861     ) external;
862     function swapExactETHForTokensSupportingFeeOnTransferTokens(
863         uint amountOutMin,
864         address[] calldata path,
865         address to,
866         uint deadline
867     ) external payable;
868     function swapExactTokensForETHSupportingFeeOnTransferTokens(
869         uint amountIn,
870         uint amountOutMin,
871         address[] calldata path,
872         address to,
873         uint deadline
874     ) external;
875 }
876  
877 contract TEMPLE is ERC20, Ownable {
878     using SafeMath for uint256;
879  
880     IUniswapV2Router02 public immutable uniswapV2Router;
881     address public immutable uniswapV2Pair;
882  
883     bool private swapping;
884  
885     address private marketingWallet;
886     address private devWallet;
887  
888     uint256 public maxTransactionAmount;
889     uint256 public swapTokensAtAmount;
890     uint256 public maxWallet;
891  
892     bool public limitsInEffect = true;
893     bool public tradingActive = false;
894     bool public swapEnabled = false;
895  
896      // Anti-bot and anti-whale mappings and variables
897     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
898  
899     // Seller Map
900     mapping (address => uint256) private _holderFirstBuyTimestamp;
901  
902     // Blacklist Map
903     mapping (address => bool) private _blacklist;
904     bool public transferDelayEnabled = true;
905  
906     uint256 public buyTotalFees;
907     uint256 public buyMarketingFee;
908     uint256 public buyLiquidityFee;
909     uint256 public buyDevFee;
910  
911     uint256 public sellTotalFees;
912     uint256 public sellMarketingFee;
913     uint256 public sellLiquidityFee;
914     uint256 public sellDevFee;
915  
916     uint256 public tokensForMarketing;
917     uint256 public tokensForLiquidity;
918     uint256 public tokensForDev;
919  
920     // block number of opened trading
921     uint256 launchedAt;
922  
923     /******************/
924  
925     // exclude from fees and max transaction amount
926     mapping (address => bool) private _isExcludedFromFees;
927     mapping (address => bool) public _isExcludedMaxTransactionAmount;
928  
929     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
930     // could be subject to a maximum transfer amount
931     mapping (address => bool) public automatedMarketMakerPairs;
932  
933     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
934  
935     event ExcludeFromFees(address indexed account, bool isExcluded);
936  
937     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
938  
939     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
940  
941     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
942  
943     event SwapAndLiquify(
944         uint256 tokensSwapped,
945         uint256 ethReceived,
946         uint256 tokensIntoLiquidity
947     );
948  
949     event AutoNukeLP();
950  
951     event ManualNukeLP();
952  
953     constructor() ERC20("Temple of Zen Shi", "TEMPLE") {
954  
955         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
956  
957         excludeFromMaxTransaction(address(_uniswapV2Router), true);
958         uniswapV2Router = _uniswapV2Router;
959  
960         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
961         excludeFromMaxTransaction(address(uniswapV2Pair), true);
962         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
963  
964         uint256 _buyMarketingFee = 0;
965         uint256 _buyLiquidityFee = 0;
966         uint256 _buyDevFee = 3;
967  
968         uint256 _sellMarketingFee = 0;
969         uint256 _sellLiquidityFee = 0;
970         uint256 _sellDevFee = 3;
971  
972         uint256 totalSupply = 1 * 1e12 * 1e18;
973  
974         maxTransactionAmount = totalSupply * 10 / 1000; // 1% maxTransactionAmountTxn
975         maxWallet = totalSupply * 20 / 1000; // 2% maxWallet
976         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.1% swap wallet
977  
978         buyMarketingFee = _buyMarketingFee;
979         buyLiquidityFee = _buyLiquidityFee;
980         buyDevFee = _buyDevFee;
981         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
982  
983         sellMarketingFee = _sellMarketingFee;
984         sellLiquidityFee = _sellLiquidityFee;
985         sellDevFee = _sellDevFee;
986         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
987  
988         marketingWallet = address(owner()); // set as marketing wallet
989         devWallet = address(owner()); // set as dev wallet
990  
991         // exclude from paying fees or having max transaction amount
992         excludeFromFees(owner(), true);
993         excludeFromFees(address(this), true);
994         excludeFromFees(address(0xdead), true);
995  
996         excludeFromMaxTransaction(owner(), true);
997         excludeFromMaxTransaction(address(this), true);
998         excludeFromMaxTransaction(address(0xdead), true);
999  
1000         /*
1001             _mint is an internal function in ERC20.sol that is only called here,
1002             and CANNOT be called ever again
1003         */
1004         _mint(msg.sender, totalSupply);
1005     }
1006  
1007     receive() external payable {
1008  
1009     }
1010  
1011     // once enabled, can never be turned off
1012     function enableTrading() external onlyOwner {
1013         tradingActive = true;
1014         swapEnabled = true;
1015         launchedAt = block.number;
1016     }
1017  
1018     // remove limits after token is stable
1019     function removeLimits() external onlyOwner returns (bool){
1020         limitsInEffect = false;
1021         return true;
1022     }
1023  
1024     // disable Transfer delay - cannot be reenabled
1025     function disableTransferDelay() external onlyOwner returns (bool){
1026         transferDelayEnabled = false;
1027         return true;
1028     }
1029  
1030      // change the minimum amount of tokens to sell from fees
1031     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1032         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1033         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1034         swapTokensAtAmount = newAmount;
1035         return true;
1036     }
1037  
1038     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1039         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1040         maxTransactionAmount = newNum * (10**18);
1041     }
1042  
1043     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1044         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1045         maxWallet = newNum * (10**18);
1046     }
1047  
1048     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1049         _isExcludedMaxTransactionAmount[updAds] = isEx;
1050     }
1051  
1052     // only use to disable contract sales if absolutely necessary (emergency use only)
1053     function updateSwapEnabled(bool enabled) external onlyOwner(){
1054         swapEnabled = enabled;
1055     }
1056  
1057     function excludeFromFees(address account, bool excluded) public onlyOwner {
1058         _isExcludedFromFees[account] = excluded;
1059         emit ExcludeFromFees(account, excluded);
1060     }
1061  
1062     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
1063         _blacklist[account] = isBlacklisted;
1064     }
1065  
1066     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1067         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1068  
1069         _setAutomatedMarketMakerPair(pair, value);
1070     }
1071  
1072     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1073         automatedMarketMakerPairs[pair] = value;
1074  
1075         emit SetAutomatedMarketMakerPair(pair, value);
1076     }
1077  
1078     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1079         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1080         marketingWallet = newMarketingWallet;
1081     }
1082  
1083     function updateDevWallet(address newWallet) external onlyOwner {
1084         emit devWalletUpdated(newWallet, devWallet);
1085         devWallet = newWallet;
1086     }
1087  
1088  
1089     function isExcludedFromFees(address account) public view returns(bool) {
1090         return _isExcludedFromFees[account];
1091     }
1092  
1093     function _transfer(
1094         address from,
1095         address to,
1096         uint256 amount
1097     ) internal override {
1098         require(from != address(0), "ERC20: transfer from the zero address");
1099         require(to != address(0), "ERC20: transfer to the zero address");
1100         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1101          if(amount == 0) {
1102             super._transfer(from, to, 0);
1103             return;
1104         }
1105  
1106         if(limitsInEffect){
1107             if (
1108                 from != owner() &&
1109                 to != owner() &&
1110                 to != address(0) &&
1111                 to != address(0xdead) &&
1112                 !swapping
1113             ){
1114                 if(!tradingActive){
1115                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1116                 }
1117  
1118                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1119                 if (transferDelayEnabled){
1120                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1121                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1122                         _holderLastTransferTimestamp[tx.origin] = block.number;
1123                     }
1124                 }
1125  
1126                 //when buy
1127                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1128                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1129                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1130                 }
1131  
1132                 //when sell
1133                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1134                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1135                 }
1136                 else if(!_isExcludedMaxTransactionAmount[to]){
1137                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1138                 }
1139             }
1140         }
1141  
1142         uint256 contractTokenBalance = balanceOf(address(this));
1143  
1144         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1145  
1146         if( 
1147             canSwap &&
1148             swapEnabled &&
1149             !swapping &&
1150             !automatedMarketMakerPairs[from] &&
1151             !_isExcludedFromFees[from] &&
1152             !_isExcludedFromFees[to]
1153         ) {
1154             swapping = true;
1155  
1156             swapBack();
1157  
1158             swapping = false;
1159         }
1160  
1161         bool takeFee = !swapping;
1162  
1163         // if any account belongs to _isExcludedFromFee account then remove the fee
1164         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1165             takeFee = false;
1166         }
1167  
1168         uint256 fees = 0;
1169         // only take fees on buys/sells, do not take on wallet transfers
1170         if(takeFee){
1171             // on sell
1172             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1173                 fees = amount.mul(sellTotalFees).div(100);
1174                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1175                 tokensForDev += fees * sellDevFee / sellTotalFees;
1176                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1177             }
1178             // on buy
1179             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1180                 fees = amount.mul(buyTotalFees).div(100);
1181                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1182                 tokensForDev += fees * buyDevFee / buyTotalFees;
1183                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1184             }
1185  
1186             if(fees > 0){    
1187                 super._transfer(from, address(this), fees);
1188             }
1189  
1190             amount -= fees;
1191         }
1192  
1193         super._transfer(from, to, amount);
1194     }
1195  
1196     function swapTokensForEth(uint256 tokenAmount) private {
1197  
1198         // generate the uniswap pair path of token -> weth
1199         address[] memory path = new address[](2);
1200         path[0] = address(this);
1201         path[1] = uniswapV2Router.WETH();
1202  
1203         _approve(address(this), address(uniswapV2Router), tokenAmount);
1204  
1205         // make the swap
1206         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1207             tokenAmount,
1208             0, // accept any amount of ETH
1209             path,
1210             address(this),
1211             block.timestamp
1212         );
1213  
1214     }
1215  
1216     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1217         // approve token transfer to cover all possible scenarios
1218         _approve(address(this), address(uniswapV2Router), tokenAmount);
1219  
1220         // add the liquidity
1221         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1222             address(this),
1223             tokenAmount,
1224             0, // slippage is unavoidable
1225             0, // slippage is unavoidable
1226             address(this),
1227             block.timestamp
1228         );
1229     }
1230  
1231     function swapBack() private {
1232         uint256 contractBalance = balanceOf(address(this));
1233         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1234         bool success;
1235  
1236         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1237  
1238         if(contractBalance > swapTokensAtAmount * 20){
1239           contractBalance = swapTokensAtAmount * 20;
1240         }
1241  
1242         // Halve the amount of liquidity tokens
1243         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1244         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1245  
1246         uint256 initialETHBalance = address(this).balance;
1247  
1248         swapTokensForEth(amountToSwapForETH); 
1249  
1250         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1251  
1252         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1253         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1254         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1255  
1256  
1257         tokensForLiquidity = 0;
1258         tokensForMarketing = 0;
1259         tokensForDev = 0;
1260  
1261         (success,) = address(devWallet).call{value: ethForDev}("");
1262  
1263         if(liquidityTokens > 0 && ethForLiquidity > 0){
1264             addLiquidity(liquidityTokens, ethForLiquidity);
1265             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1266         }
1267  
1268         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1269     }
1270 }