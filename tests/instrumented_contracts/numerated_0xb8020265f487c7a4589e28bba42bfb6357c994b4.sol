1 /*** 
2           
3             ██╗██╗░░██╗░█████╗░██╗██╗░░██╗░█████╗░  ██╗███╗░░██╗██╗░░░██╗
4             ██║██║░██╔╝██╔══██╗██║██║░██╔╝██╔══██╗  ██║████╗░██║██║░░░██║
5             ██║█████═╝░███████║██║█████═╝░███████║  ██║██╔██╗██║██║░░░██║
6             ██║██╔═██╗░██╔══██║██║██╔═██╗░██╔══██║  ██║██║╚████║██║░░░██║
7             ██║██║░╚██╗██║░░██║██║██║░╚██╗██║░░██║  ██║██║░╚███║╚██████╔╝
8             ╚═╝╚═╝░░╚═╝╚═╝░░╚═╝╚═╝╚═╝░░╚═╝╚═╝░░╚═╝  ╚═╝╚═╝░░╚══╝░╚═════╝░
9 
10 ***/
11 
12 /*** 
13     
14 
15 ░█▀▀█ ░█▀▀█ ░█▀▀▀█ ▀▀█▀▀ ░█▀▀▀ ░█▀▀█ ▀▀█▀▀ ░█▀▀▀█ ░█▀▀█ 　 ░█▀▀▀█ ░█▀▀▀ 　 ░█▀▀▀█ ░█─░█ ░█▀▀█ 　 ░█▀▀▀ ─█▀▀█ ░█▀▀█ ▀▀█▀▀ ░█─░█ 
16 ░█▄▄█ ░█▄▄▀ ░█──░█ ─░█── ░█▀▀▀ ░█─── ─░█── ░█──░█ ░█▄▄▀ 　 ░█──░█ ░█▀▀▀ 　 ░█──░█ ░█─░█ ░█▄▄▀ 　 ░█▀▀▀ ░█▄▄█ ░█▄▄▀ ─░█── ░█▀▀█ 
17 ░█─── ░█─░█ ░█▄▄▄█ ─░█── ░█▄▄▄ ░█▄▄█ ─░█── ░█▄▄▄█ ░█─░█ 　 ░█▄▄▄█ ░█─── 　 ░█▄▄▄█ ─▀▄▄▀ ░█─░█ 　 ░█▄▄▄ ░█─░█ ░█─░█ ─░█── ░█─░█ 
18 
19             ─█▀▀█ ░█▄─░█ ░█▀▀▄ 　 ░█──░█ ▀█▀ ░█─── ░█▀▀▄ ░█─── ▀█▀ ░█▀▀▀ ░█▀▀▀ 
20             ░█▄▄█ ░█░█░█ ░█─░█ 　 ░█░█░█ ░█─ ░█─── ░█─░█ ░█─── ░█─ ░█▀▀▀ ░█▀▀▀ 
21             ░█─░█ ░█──▀█ ░█▄▄▀ 　 ░█▄▀▄█ ▄█▄ ░█▄▄█ ░█▄▄▀ ░█▄▄█ ▄█▄ ░█─── ░█▄▄▄
22                                 
23     Telegram: t.me/IKAIKAINU
24     Website: https://www.ikaikainu.com
25     Twitter: twitter.com/ikaika_inu
26 ***/
27 
28 // SPDX-License-Identifier: Unlicensed
29 pragma solidity 0.8.13;
30  
31 abstract contract Context {
32     function _msgSender() internal view virtual returns (address) {
33         return msg.sender;
34     }
35  
36     function _msgData() internal view virtual returns (bytes calldata) {
37         // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
38         this;
39         return msg.data;
40     }
41 }
42  
43 interface IUniswapV2Pair {
44     event Approval(address indexed owner, address indexed spender, uint value);
45     event Transfer(address indexed from, address indexed to, uint value);
46  
47     function name() external pure returns (string memory);
48     function symbol() external pure returns (string memory);
49     function decimals() external pure returns (uint8);
50     function totalSupply() external view returns (uint);
51     function balanceOf(address owner) external view returns (uint);
52     function allowance(address owner, address spender) external view returns (uint);
53  
54     function approve(address spender, uint value) external returns (bool);
55     function transfer(address to, uint value) external returns (bool);
56     function transferFrom(address from, address to, uint value) external returns (bool);
57  
58     function DOMAIN_SEPARATOR() external view returns (bytes32);
59     function PERMIT_TYPEHASH() external pure returns (bytes32);
60     function nonces(address owner) external view returns (uint);
61  
62     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
63  
64     event Mint(address indexed sender, uint amount0, uint amount1);
65     event Swap(
66         address indexed sender,
67         uint amount0In,
68         uint amount1In,
69         uint amount0Out,
70         uint amount1Out,
71         address indexed to
72     );
73     event Sync(uint112 reserve0, uint112 reserve1);
74  
75     function MINIMUM_LIQUIDITY() external pure returns (uint);
76     function factory() external view returns (address);
77     function token0() external view returns (address);
78     function token1() external view returns (address);
79     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
80     function price0CumulativeLast() external view returns (uint);
81     function price1CumulativeLast() external view returns (uint);
82     function kLast() external view returns (uint);
83  
84     function mint(address to) external returns (uint liquidity);
85     function burn(address to) external returns (uint amount0, uint amount1);
86     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
87     function skim(address to) external;
88     function sync() external;
89  
90     function initialize(address, address) external;
91 }
92  
93 interface IUniswapV2Factory {
94     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
95  
96     function feeTo() external view returns (address);
97     function feeToSetter() external view returns (address);
98  
99     function getPair(address tokenA, address tokenB) external view returns (address pair);
100     function allPairs(uint) external view returns (address pair);
101     function allPairsLength() external view returns (uint);
102  
103     function createPair(address tokenA, address tokenB) external returns (address pair);
104  
105     function setFeeTo(address) external;
106     function setFeeToSetter(address) external;
107 }
108  
109 interface IERC20 {
110     /**
111      * @dev Returns the amount of tokens in existence.
112      */
113     function totalSupply() external view returns (uint256);
114  
115     /**
116      * @dev Returns the amount of tokens owned by `account`.
117      */
118     function balanceOf(address account) external view returns (uint256);
119  
120     /**
121      * @dev Moves `amount` tokens from the caller's account to `recipient`.
122      *
123      * Returns a boolean value indicating whether the operation succeeded.
124      *
125      * Emits a {Transfer} event.
126      */
127     function transfer(address recipient, uint256 amount) external returns (bool);
128  
129     /**
130      * @dev Returns the remaining number of tokens that `spender` will be
131      * allowed to spend on behalf of `owner` through {transferFrom}. This is
132      * zero by default.
133      *
134      * This value changes when {approve} or {transferFrom} are called.
135      */
136     function allowance(address owner, address spender) external view returns (uint256);
137  
138     /**
139      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
140      *
141      * Returns a boolean value indicating whether the operation succeeded.
142      *
143      * IMPORTANT: Beware that changing an allowance with this method brings the risk
144      * that someone may use both the old and the new allowance by unfortunate
145      * transaction ordering. One possible solution to mitigate this race
146      * condition is to first reduce the spender's allowance to 0 and set the
147      * desired value afterwards:
148      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
149      *
150      * Emits an {Approval} event.
151      */
152     function approve(address spender, uint256 amount) external returns (bool);
153  
154     /**
155      * @dev Moves `amount` tokens from `sender` to `recipient` using the
156      * allowance mechanism. `amount` is then deducted from the caller's
157      * allowance.
158      *
159      * Returns a boolean value indicating whether the operation succeeded.
160      *
161      * Emits a {Transfer} event.
162      */
163     function transferFrom(
164         address sender,
165         address recipient,
166         uint256 amount
167     ) external returns (bool);
168  
169     /**
170      * @dev Emitted when `value` tokens are moved from one account (`from`) to
171      * another (`to`).
172      *
173      * Note that `value` may be zero.
174      */
175     event Transfer(address indexed from, address indexed to, uint256 value);
176  
177     /**
178      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
179      * a call to {approve}. `value` is the new allowance.
180      */
181     event Approval(address indexed owner, address indexed spender, uint256 value);
182 }
183  
184 interface IERC20Metadata is IERC20 {
185     /**
186      * @dev Returns the name of the token.
187      */
188     function name() external view returns (string memory);
189  
190     /**
191      * @dev Returns the symbol of the token.
192      */
193     function symbol() external view returns (string memory);
194  
195     /**
196      * @dev Returns the decimals places of the token.
197      */
198     function decimals() external view returns (uint8);
199 }
200  
201  
202 contract ERC20 is Context, IERC20, IERC20Metadata {
203     using SafeMath for uint256;
204  
205     mapping(address => uint256) private _balances;
206  
207     mapping(address => mapping(address => uint256)) private _allowances;
208  
209     uint256 private _totalSupply;
210  
211     string private _name;
212     string private _symbol;
213  
214     /**
215      * @dev Sets the values for {name} and {symbol}.
216      *
217      * The default value of {decimals} is 18. To select a different value for
218      * {decimals} you should overload it.
219      *
220      * All two of these values are immutable: they can only be set once during
221      * construction.
222      */
223     constructor(string memory name_, string memory symbol_) {
224         _name = name_;
225         _symbol = symbol_;
226     }
227  
228     /**
229      * @dev Returns the name of the token.
230      */
231     function name() public view virtual override returns (string memory) {
232         return _name;
233     }
234  
235     /**
236      * @dev Returns the symbol of the token, usually a shorter version of the
237      * name.
238      */
239     function symbol() public view virtual override returns (string memory) {
240         return _symbol;
241     }
242  
243     /**
244      * @dev Returns the number of decimals used to get its user representation.
245      * For example, if `decimals` equals `2`, a balance of `505` tokens should
246      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
247      *
248      * Tokens usually opt for a value of 18, imitating the relationship between
249      * Ether and Wei. This is the value {ERC20} uses, unless this function is
250      * overridden;
251      *
252      * NOTE: This information is only used for _display_ purposes: it in
253      * no way affects any of the arithmetic of the contract, including
254      * {IERC20-balanceOf} and {IERC20-transfer}.
255      */
256     function decimals() public view virtual override returns (uint8) {
257         return 18;
258     }
259  
260     /**
261      * @dev See {IERC20-totalSupply}.
262      */
263     function totalSupply() public view virtual override returns (uint256) {
264         return _totalSupply;
265     }
266  
267     /**
268      * @dev See {IERC20-balanceOf}.
269      */
270     function balanceOf(address account) public view virtual override returns (uint256) {
271         return _balances[account];
272     }
273  
274     /**
275      * @dev See {IERC20-transfer}.
276      *
277      * Requirements:
278      *
279      * - `recipient` cannot be the zero address.
280      * - the caller must have a balance of at least `amount`.
281      */
282     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
283         _transfer(_msgSender(), recipient, amount);
284         return true;
285     }
286  
287     /**
288      * @dev See {IERC20-allowance}.
289      */
290     function allowance(address owner, address spender) public view virtual override returns (uint256) {
291         return _allowances[owner][spender];
292     }
293  
294     /**
295      * @dev See {IERC20-approve}.
296      *
297      * Requirements:
298      *
299      * - `spender` cannot be the zero address.
300      */
301     function approve(address spender, uint256 amount) public virtual override returns (bool) {
302         _approve(_msgSender(), spender, amount);
303         return true;
304     }
305  
306     /**
307      * @dev See {IERC20-transferFrom}.
308      *
309      * Emits an {Approval} event indicating the updated allowance. This is not
310      * required by the EIP. See the note at the beginning of {ERC20}.
311      *
312      * Requirements:
313      *
314      * - `sender` and `recipient` cannot be the zero address.
315      * - `sender` must have a balance of at least `amount`.
316      * - the caller must have allowance for ``sender``'s tokens of at least
317      * `amount`.
318      */
319     function transferFrom(
320         address sender,
321         address recipient,
322         uint256 amount
323     ) public virtual override returns (bool) {
324         _transfer(sender, recipient, amount);
325         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
326         return true;
327     }
328  
329     /**
330      * @dev Atomically increases the allowance granted to `spender` by the caller.
331      *
332      * This is an alternative to {approve} that can be used as a mitigation for
333      * problems described in {IERC20-approve}.
334      *
335      * Emits an {Approval} event indicating the updated allowance.
336      *
337      * Requirements:
338      *
339      * - `spender` cannot be the zero address.
340      */
341     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
342         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
343         return true;
344     }
345  
346     /**
347      * @dev Atomically decreases the allowance granted to `spender` by the caller.
348      *
349      * This is an alternative to {approve} that can be used as a mitigation for
350      * problems described in {IERC20-approve}.
351      *
352      * Emits an {Approval} event indicating the updated allowance.
353      *
354      * Requirements:
355      *
356      * - `spender` cannot be the zero address.
357      * - `spender` must have allowance for the caller of at least
358      * `subtractedValue`.
359      */
360     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
361         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
362         return true;
363     }
364  
365     /**
366      * @dev Moves tokens `amount` from `sender` to `recipient`.
367      *
368      * This is internal function is equivalent to {transfer}, and can be used to
369      * e.g. implement automatic token fees, slashing mechanisms, etc.
370      *
371      * Emits a {Transfer} event.
372      *
373      * Requirements:
374      *
375      * - `sender` cannot be the zero address.
376      * - `recipient` cannot be the zero address.
377      * - `sender` must have a balance of at least `amount`.
378      */
379     function _transfer(
380         address sender,
381         address recipient,
382         uint256 amount
383     ) internal virtual {
384         require(sender != address(0), "ERC20: transfer from the zero address");
385         require(recipient != address(0), "ERC20: transfer to the zero address");
386  
387         _beforeTokenTransfer(sender, recipient, amount);
388  
389         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
390         _balances[recipient] = _balances[recipient].add(amount);
391         emit Transfer(sender, recipient, amount);
392     }
393  
394     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
395      * the total supply.
396      *
397      * Emits a {Transfer} event with `from` set to the zero address.
398      *
399      * Requirements:
400      *
401      * - `account` cannot be the zero address.
402      */
403     function _mint(address account, uint256 amount) internal virtual {
404         require(account != address(0), "ERC20: mint to the zero address");
405  
406         _beforeTokenTransfer(address(0), account, amount);
407  
408         _totalSupply = _totalSupply.add(amount);
409         _balances[account] = _balances[account].add(amount);
410         emit Transfer(address(0), account, amount);
411     }
412  
413     /**
414      * @dev Destroys `amount` tokens from `account`, reducing the
415      * total supply.
416      *
417      * Emits a {Transfer} event with `to` set to the zero address.
418      *
419      * Requirements:
420      *
421      * - `account` cannot be the zero address.
422      * - `account` must have at least `amount` tokens.
423      */
424     function _burn(address account, uint256 amount) internal virtual {
425         require(account != address(0), "ERC20: burn from the zero address");
426  
427         _beforeTokenTransfer(account, address(0), amount);
428  
429         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
430         _totalSupply = _totalSupply.sub(amount);
431         emit Transfer(account, address(0), amount);
432     }
433  
434     /**
435      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
436      *
437      * This internal function is equivalent to `approve`, and can be used to
438      * e.g. set automatic allowances for certain subsystems, etc.
439      *
440      * Emits an {Approval} event.
441      *
442      * Requirements:
443      *
444      * - `owner` cannot be the zero address.
445      * - `spender` cannot be the zero address.
446      */
447     function _approve(
448         address owner,
449         address spender,
450         uint256 amount
451     ) internal virtual {
452         require(owner != address(0), "ERC20: approve from the zero address");
453         require(spender != address(0), "ERC20: approve to the zero address");
454  
455         _allowances[owner][spender] = amount;
456         emit Approval(owner, spender, amount);
457     }
458  
459     /**
460      * @dev Hook that is called before any transfer of tokens. This includes
461      * minting and burning.
462      *
463      * Calling conditions:
464      *
465      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
466      * will be to transferred to `to`.
467      * - when `from` is zero, `amount` tokens will be minted for `to`.
468      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
469      * - `from` and `to` are never both zero.
470      *
471      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
472      */
473     function _beforeTokenTransfer(
474         address from,
475         address to,
476         uint256 amount
477     ) internal virtual {}
478 }
479  
480 library SafeMath {
481     /**
482      * @dev Returns the addition of two unsigned integers, reverting on
483      * overflow.
484      *
485      * Counterpart to Solidity's `+` operator.
486      *
487      * Requirements:
488      *
489      * - Addition cannot overflow.
490      */
491     function add(uint256 a, uint256 b) internal pure returns (uint256) {
492         uint256 c = a + b;
493         require(c >= a, "SafeMath: addition overflow");
494  
495         return c;
496     }
497  
498     /**
499      * @dev Returns the subtraction of two unsigned integers, reverting on
500      * overflow (when the result is negative).
501      *
502      * Counterpart to Solidity's `-` operator.
503      *
504      * Requirements:
505      *
506      * - Subtraction cannot overflow.
507      */
508     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
509         return sub(a, b, "SafeMath: subtraction overflow");
510     }
511  
512     /**
513      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
514      * overflow (when the result is negative).
515      *
516      * Counterpart to Solidity's `-` operator.
517      *
518      * Requirements:
519      *
520      * - Subtraction cannot overflow.
521      */
522     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
523         require(b <= a, errorMessage);
524         uint256 c = a - b;
525  
526         return c;
527     }
528  
529     /**
530      * @dev Returns the multiplication of two unsigned integers, reverting on
531      * overflow.
532      *
533      * Counterpart to Solidity's `*` operator.
534      *
535      * Requirements:
536      *
537      * - Multiplication cannot overflow.
538      */
539     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
540         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
541         // benefit is lost if 'b' is also tested.
542         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
543         if (a == 0) {
544             return 0;
545         }
546  
547         uint256 c = a * b;
548         require(c / a == b, "SafeMath: multiplication overflow");
549  
550         return c;
551     }
552  
553     /**
554      * @dev Returns the integer division of two unsigned integers. Reverts on
555      * division by zero. The result is rounded towards zero.
556      *
557      * Counterpart to Solidity's `/` operator. Note: this function uses a
558      * `revert` opcode (which leaves remaining gas untouched) while Solidity
559      * uses an invalid opcode to revert (consuming all remaining gas).
560      *
561      * Requirements:
562      *
563      * - The divisor cannot be zero.
564      */
565     function div(uint256 a, uint256 b) internal pure returns (uint256) {
566         return div(a, b, "SafeMath: division by zero");
567     }
568  
569     /**
570      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
571      * division by zero. The result is rounded towards zero.
572      *
573      * Counterpart to Solidity's `/` operator. Note: this function uses a
574      * `revert` opcode (which leaves remaining gas untouched) while Solidity
575      * uses an invalid opcode to revert (consuming all remaining gas).
576      *
577      * Requirements:
578      *
579      * - The divisor cannot be zero.
580      */
581     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
582         require(b > 0, errorMessage);
583         uint256 c = a / b; 
584         return c;
585     }
586  
587     /**
588      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
589      * Reverts when dividing by zero.
590      *
591      * Counterpart to Solidity's `%` operator. This function uses a `revert`
592      * opcode (which leaves remaining gas untouched) while Solidity uses an
593      * invalid opcode to revert (consuming all remaining gas).
594      *
595      * Requirements:
596      *
597      * - The divisor cannot be zero.
598      */
599     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
600         return mod(a, b, "SafeMath: modulo by zero");
601     }
602  
603     /**
604      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
605      * Reverts with custom message when dividing by zero.
606      *
607      * Counterpart to Solidity's `%` operator. This function uses a `revert`
608      * opcode (which leaves remaining gas untouched) while Solidity uses an
609      * invalid opcode to revert (consuming all remaining gas).
610      *
611      * Requirements:
612      *
613      * - The divisor cannot be zero.
614      */
615     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
616         require(b != 0, errorMessage);
617         return a % b;
618     }
619 }
620  
621 contract Ownable is Context {
622     address private _owner;
623  
624     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
625  
626     /**
627      * @dev Initializes the contract setting the deployer as the initial owner.
628      */
629     constructor () {
630         address msgSender = _msgSender();
631         _owner = msgSender;
632         emit OwnershipTransferred(address(0), msgSender);
633     }
634  
635     /**
636      * @dev Returns the address of the current owner.
637      */
638     function owner() public view returns (address) {
639         return _owner;
640     }
641  
642     /**
643      * @dev Throws if called by any account other than the owner.
644      */
645     modifier onlyOwner() {
646         require(_owner == _msgSender(), "Ownable: caller is not the owner");
647         _;
648     }
649  
650     /**
651      * @dev Leaves the contract without owner. It will not be possible to call
652      * `onlyOwner` functions anymore. Can only be called by the current owner.
653      *
654      * NOTE: Renouncing ownership will leave the contract without an owner,
655      * thereby removing any functionality that is only available to the owner.
656      */
657     function renounceOwnership() public virtual onlyOwner {
658         emit OwnershipTransferred(_owner, address(0));
659         _owner = address(0);
660     }
661  
662     /**
663      * @dev Transfers ownership of the contract to a new account (`newOwner`).
664      * Can only be called by the current owner.
665      */
666     function transferOwnership(address newOwner) public virtual onlyOwner {
667         require(newOwner != address(0), "Ownable: new owner is the zero address");
668         emit OwnershipTransferred(_owner, newOwner);
669         _owner = newOwner;
670     }
671 }
672  
673  
674  
675 library SafeMathInt {
676     int256 private constant MIN_INT256 = int256(1) << 255;
677     int256 private constant MAX_INT256 = ~(int256(1) << 255);
678  
679     /**
680      * @dev Multiplies two int256 variables and fails on overflow.
681      */
682     function mul(int256 a, int256 b) internal pure returns (int256) {
683         int256 c = a * b;
684  
685         // Detect overflow when multiplying MIN_INT256 with -1
686         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
687         require((b == 0) || (c / b == a));
688         return c;
689     }
690  
691     /**
692      * @dev Division of two int256 variables and fails on overflow.
693      */
694     function div(int256 a, int256 b) internal pure returns (int256) {
695         // Prevent overflow when dividing MIN_INT256 by -1
696         require(b != -1 || a != MIN_INT256);
697  
698         // Solidity already throws when dividing by 0.
699         return a / b;
700     }
701  
702     /**
703      * @dev Subtracts two int256 variables and fails on overflow.
704      */
705     function sub(int256 a, int256 b) internal pure returns (int256) {
706         int256 c = a - b;
707         require((b >= 0 && c <= a) || (b < 0 && c > a));
708         return c;
709     }
710  
711     /**
712      * @dev Adds two int256 variables and fails on overflow.
713      */
714     function add(int256 a, int256 b) internal pure returns (int256) {
715         int256 c = a + b;
716         require((b >= 0 && c >= a) || (b < 0 && c < a));
717         return c;
718     }
719  
720     /**
721      * @dev Converts to absolute value, and fails on overflow.
722      */
723     function abs(int256 a) internal pure returns (int256) {
724         require(a != MIN_INT256);
725         return a < 0 ? -a : a;
726     }
727  
728  
729     function toUint256Safe(int256 a) internal pure returns (uint256) {
730         require(a >= 0);
731         return uint256(a);
732     }
733 }
734  
735 library SafeMathUint {
736   function toInt256Safe(uint256 a) internal pure returns (int256) {
737     int256 b = int256(a);
738     require(b >= 0);
739     return b;
740   }
741 }
742  
743  
744 interface IUniswapV2Router01 {
745     function factory() external pure returns (address);
746     function WETH() external pure returns (address);
747  
748     function addLiquidity(
749         address tokenA,
750         address tokenB,
751         uint amountADesired,
752         uint amountBDesired,
753         uint amountAMin,
754         uint amountBMin,
755         address to,
756         uint deadline
757     ) external returns (uint amountA, uint amountB, uint liquidity);
758     function addLiquidityETH(
759         address token,
760         uint amountTokenDesired,
761         uint amountTokenMin,
762         uint amountETHMin,
763         address to,
764         uint deadline
765     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
766     function removeLiquidity(
767         address tokenA,
768         address tokenB,
769         uint liquidity,
770         uint amountAMin,
771         uint amountBMin,
772         address to,
773         uint deadline
774     ) external returns (uint amountA, uint amountB);
775     function removeLiquidityETH(
776         address token,
777         uint liquidity,
778         uint amountTokenMin,
779         uint amountETHMin,
780         address to,
781         uint deadline
782     ) external returns (uint amountToken, uint amountETH);
783     function removeLiquidityWithPermit(
784         address tokenA,
785         address tokenB,
786         uint liquidity,
787         uint amountAMin,
788         uint amountBMin,
789         address to,
790         uint deadline,
791         bool approveMax, uint8 v, bytes32 r, bytes32 s
792     ) external returns (uint amountA, uint amountB);
793     function removeLiquidityETHWithPermit(
794         address token,
795         uint liquidity,
796         uint amountTokenMin,
797         uint amountETHMin,
798         address to,
799         uint deadline,
800         bool approveMax, uint8 v, bytes32 r, bytes32 s
801     ) external returns (uint amountToken, uint amountETH);
802     function swapExactTokensForTokens(
803         uint amountIn,
804         uint amountOutMin,
805         address[] calldata path,
806         address to,
807         uint deadline
808     ) external returns (uint[] memory amounts);
809     function swapTokensForExactTokens(
810         uint amountOut,
811         uint amountInMax,
812         address[] calldata path,
813         address to,
814         uint deadline
815     ) external returns (uint[] memory amounts);
816     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
817         external
818         payable
819         returns (uint[] memory amounts);
820     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
821         external
822         returns (uint[] memory amounts);
823     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
824         external
825         returns (uint[] memory amounts);
826     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
827         external
828         payable
829         returns (uint[] memory amounts);
830  
831     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
832     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
833     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
834     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
835     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
836 }
837  
838 interface IUniswapV2Router02 is IUniswapV2Router01 {
839     function removeLiquidityETHSupportingFeeOnTransferTokens(
840         address token,
841         uint liquidity,
842         uint amountTokenMin,
843         uint amountETHMin,
844         address to,
845         uint deadline
846     ) external returns (uint amountETH);
847     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
848         address token,
849         uint liquidity,
850         uint amountTokenMin,
851         uint amountETHMin,
852         address to,
853         uint deadline,
854         bool approveMax, uint8 v, bytes32 r, bytes32 s
855     ) external returns (uint amountETH);
856  
857     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
858         uint amountIn,
859         uint amountOutMin,
860         address[] calldata path,
861         address to,
862         uint deadline
863     ) external;
864     function swapExactETHForTokensSupportingFeeOnTransferTokens(
865         uint amountOutMin,
866         address[] calldata path,
867         address to,
868         uint deadline
869     ) external payable;
870     function swapExactTokensForETHSupportingFeeOnTransferTokens(
871         uint amountIn,
872         uint amountOutMin,
873         address[] calldata path,
874         address to,
875         uint deadline
876     ) external;
877 }
878  
879 contract IKAIKAINU is ERC20, Ownable {
880     using SafeMath for uint256;
881  
882     IUniswapV2Router02 public immutable uniswapV2Router;
883     address public immutable uniswapV2Pair;
884  
885     bool private swapping;
886  
887     address private marketingWallet;
888     address private devWallet;
889  
890     uint256 public maxTransactionAmount;
891     uint256 public swapTokensAtAmount;
892     uint256 public maxWallet;
893  
894     bool public limitsInEffect = true;
895     bool public tradingActive = false;
896     bool public swapEnabled = false;
897     bool public enableEarlySellTax = true;
898  
899     /*** Anti-Bot and Anti-Whale Mappings & Variables ***/ 
900 
901     // hold last transfers temporarily during launch
902     mapping(address => uint256) private _holderLastTransferTimestamp; 
903  
904     // Seller Map
905     mapping (address => uint256) private _holderFirstBuyTimestamp;
906  
907     // Blacklist Map
908     mapping (address => bool) private _blacklist;
909     bool public transferDelayEnabled = true;
910  
911     uint256 public buyTotalFees;
912     uint256 public buyMarketingFee;
913     uint256 public buyLiquidityFee;
914     uint256 public buyDevFee;
915  
916     uint256 public sellTotalFees;
917     uint256 public sellMarketingFee;
918     uint256 public sellLiquidityFee;
919     uint256 public sellDevFee;
920  
921     uint256 public earlySellLiquidityFee;
922     uint256 public earlySellMarketingFee;
923     uint256 public earlySellDevFee;
924  
925     uint256 public tokensForMarketing;
926     uint256 public tokensForLiquidity;
927     uint256 public tokensForDev;
928  
929     // set block number of opened trading
930     uint256 launchedAt;
931  
932     // exclude from fees and max transaction amount
933     mapping (address => bool) private _isExcludedFromFees;
934     mapping (address => bool) public _isExcludedMaxTransactionAmount;
935  
936     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
937     // could be subject to a maximum transfer amount
938     mapping (address => bool) public automatedMarketMakerPairs;
939  
940     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
941  
942     event ExcludeFromFees(address indexed account, bool isExcluded);
943  
944     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
945  
946     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
947  
948     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
949  
950     event SwapAndLiquify(
951         uint256 tokensSwapped,
952         uint256 ethReceived,
953         uint256 tokensIntoLiquidity
954     );
955  
956     constructor() ERC20("IKAIKA INU", "IKAI") {
957  
958         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
959  
960         excludeFromMaxTransaction(address(_uniswapV2Router), true);
961         uniswapV2Router = _uniswapV2Router;
962  
963         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
964         excludeFromMaxTransaction(address(uniswapV2Pair), true);
965         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
966  
967         uint256 _buyMarketingFee = 2;
968         uint256 _buyLiquidityFee = 0;
969         uint256 _buyDevFee = 3;
970  
971         uint256 _sellMarketingFee = 2;
972         uint256 _sellLiquidityFee = 1;
973         uint256 _sellDevFee = 2;
974  
975         uint256 _earlySellLiquidityFee = 1;
976         uint256 _earlySellMarketingFee = 3;
977 	    uint256 _earlySellDevFee = 3; 
978         
979         uint256 totalSupply = 808 * 1e6 * 1e18;
980  
981         maxTransactionAmount = totalSupply * 10 / 1000; // 1% maxTransactionAmountTxn
982         maxWallet = totalSupply * 2 / 100; // 2% maxWallet
983         swapTokensAtAmount = totalSupply * 25/ 10000; // 0.25% swap
984  
985         buyMarketingFee = _buyMarketingFee;
986         buyLiquidityFee = _buyLiquidityFee;
987         buyDevFee = _buyDevFee;
988         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
989  
990         sellMarketingFee = _sellMarketingFee;
991         sellLiquidityFee = _sellLiquidityFee;
992         sellDevFee = _sellDevFee;
993         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
994  
995         earlySellLiquidityFee = _earlySellLiquidityFee;
996         earlySellMarketingFee = _earlySellMarketingFee;
997 	    earlySellDevFee = _earlySellDevFee;
998  
999         marketingWallet = address(owner());
1000         devWallet = address(owner());
1001  
1002         // exclude from paying fees or having max transaction amount
1003         excludeFromFees(owner(), true);
1004         excludeFromFees(address(this), true);
1005         excludeFromFees(address(0xdead), true);
1006  
1007         excludeFromMaxTransaction(owner(), true);
1008         excludeFromMaxTransaction(address(this), true);
1009         excludeFromMaxTransaction(address(0xdead), true);
1010  
1011         /*
1012             _mint is an internal function in ERC20.sol that is only called here,
1013             and CANNOT be called ever again
1014         */
1015         _mint(msg.sender, totalSupply);
1016     }
1017  
1018     receive() external payable {
1019  
1020     }
1021  
1022     // once enabled, can never be turned off
1023     function enableTrading() external onlyOwner {
1024         tradingActive = true;
1025         swapEnabled = true;
1026         launchedAt = block.number;
1027     }
1028  
1029     // remove limits after token is stable
1030     function removeLimits() external onlyOwner returns (bool){
1031         limitsInEffect = false;
1032         return true;
1033     }
1034  
1035     // disable Transfer delay - cannot be reenabled
1036     function disableTransferDelay() external onlyOwner returns (bool){
1037         transferDelayEnabled = false;
1038         return true;
1039     }
1040  
1041     function setEarlySellTax(bool onoff) external onlyOwner  {
1042         enableEarlySellTax = onoff;
1043     }
1044  
1045      // change the minimum amount of tokens to sell from fees
1046     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1047         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1048         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1049         swapTokensAtAmount = newAmount;
1050         return true;
1051     }
1052  
1053     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1054         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1055         maxTransactionAmount = newNum * (10**18);
1056     }
1057  
1058     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1059         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1060         maxWallet = newNum * (10**18);
1061     }
1062  
1063     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1064         _isExcludedMaxTransactionAmount[updAds] = isEx;
1065     }
1066  
1067     // only use to disable contract sales if absolutely necessary (emergency use only)
1068     function updateSwapEnabled(bool enabled) external onlyOwner(){
1069         swapEnabled = enabled;
1070     }
1071  
1072     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1073         buyMarketingFee = _marketingFee;
1074         buyLiquidityFee = _liquidityFee;
1075         buyDevFee = _devFee;
1076         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1077         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1078     }
1079  
1080     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _earlySellLiquidityFee, uint256 _earlySellMarketingFee, uint256 _earlySellDevFee) external onlyOwner {
1081         sellMarketingFee = _marketingFee;
1082         sellLiquidityFee = _liquidityFee;
1083         sellDevFee = _devFee;
1084         earlySellLiquidityFee = _earlySellLiquidityFee;
1085         earlySellMarketingFee = _earlySellMarketingFee;
1086 	    earlySellDevFee = _earlySellDevFee;
1087         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1088         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1089     }
1090  
1091     function excludeFromFees(address account, bool excluded) public onlyOwner {
1092         _isExcludedFromFees[account] = excluded;
1093         emit ExcludeFromFees(account, excluded);
1094     }
1095  
1096     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
1097         _blacklist[account] = isBlacklisted;
1098     }
1099  
1100     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1101         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1102  
1103         _setAutomatedMarketMakerPair(pair, value);
1104     }
1105  
1106     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1107         automatedMarketMakerPairs[pair] = value;
1108  
1109         emit SetAutomatedMarketMakerPair(pair, value);
1110     }
1111  
1112     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1113         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1114         marketingWallet = newMarketingWallet;
1115     }
1116  
1117     function updateDevWallet(address newWallet) external onlyOwner {
1118         emit devWalletUpdated(newWallet, devWallet);
1119         devWallet = newWallet;
1120     }
1121  
1122  
1123     function isExcludedFromFees(address account) public view returns(bool) {
1124         return _isExcludedFromFees[account];
1125     }
1126  
1127     event BoughtEarly(address indexed sniper);
1128  
1129     function _transfer(
1130         address from,
1131         address to,
1132         uint256 amount
1133     ) internal override {
1134         require(from != address(0), "ERC20: transfer from the zero address");
1135         require(to != address(0), "ERC20: transfer to the zero address");
1136         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1137          if(amount == 0) {
1138             super._transfer(from, to, 0);
1139             return;
1140         }
1141  
1142         if(limitsInEffect){
1143             if (
1144                 from != owner() &&
1145                 to != owner() &&
1146                 to != address(0) &&
1147                 to != address(0xdead) &&
1148                 !swapping
1149             ){
1150                 if(!tradingActive){
1151                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1152                 }
1153  
1154                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1155                 if (transferDelayEnabled){
1156                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1157                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1158                         _holderLastTransferTimestamp[tx.origin] = block.number;
1159                     }
1160                 }
1161  
1162                 // when buy
1163                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1164                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1165                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1166                 }
1167  
1168                 // when sell
1169                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1170                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1171                 }
1172                 else if(!_isExcludedMaxTransactionAmount[to]){
1173                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1174                 }
1175             }
1176         }
1177  
1178         // anti bot logic
1179         if (block.number <= (launchedAt + 3) && 
1180                 to != uniswapV2Pair && 
1181                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1182             ) { 
1183             _blacklist[to] = true;
1184         }
1185  
1186         // early sell logic
1187         bool isBuy = from == uniswapV2Pair;
1188         if (!isBuy && enableEarlySellTax) {
1189             if (_holderFirstBuyTimestamp[from] != 0 &&
1190                 (_holderFirstBuyTimestamp[from] + (24 hours) >= block.timestamp))  {
1191                 sellLiquidityFee = earlySellLiquidityFee;
1192                 sellMarketingFee = earlySellMarketingFee;
1193 		        sellDevFee = earlySellDevFee;
1194                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1195             } else {
1196                 sellLiquidityFee = 2;
1197                 sellMarketingFee = 3;
1198                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1199             }
1200         } else {
1201             if (_holderFirstBuyTimestamp[to] == 0) {
1202                 _holderFirstBuyTimestamp[to] = block.timestamp;
1203             }
1204  
1205             if (!enableEarlySellTax) {
1206                 sellLiquidityFee = 3;
1207                 sellMarketingFee = 3;
1208 		        sellDevFee = 1;
1209                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1210             }
1211         }
1212  
1213         uint256 contractTokenBalance = balanceOf(address(this));
1214  
1215         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1216  
1217         if( 
1218             canSwap &&
1219             swapEnabled &&
1220             !swapping &&
1221             !automatedMarketMakerPairs[from] &&
1222             !_isExcludedFromFees[from] &&
1223             !_isExcludedFromFees[to]
1224         ) {
1225             swapping = true;
1226  
1227             swapBack();
1228  
1229             swapping = false;
1230         }
1231  
1232         bool takeFee = !swapping;
1233  
1234         // if any account belongs to _isExcludedFromFee account then remove the fee
1235         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1236             takeFee = false;
1237         }
1238  
1239         uint256 fees = 0;
1240         // only take fees on buys/sells, do not take on wallet transfers
1241         if(takeFee){
1242             // on sell
1243             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1244                 fees = amount.mul(sellTotalFees).div(100);
1245                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1246                 tokensForDev += fees * sellDevFee / sellTotalFees;
1247                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1248             }
1249             // on buy
1250             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1251                 fees = amount.mul(buyTotalFees).div(100);
1252                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1253                 tokensForDev += fees * buyDevFee / buyTotalFees;
1254                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1255             }
1256  
1257             if(fees > 0){    
1258                 super._transfer(from, address(this), fees);
1259             }
1260  
1261             amount -= fees;
1262         }
1263  
1264         super._transfer(from, to, amount);
1265     }
1266  
1267     function swapTokensForEth(uint256 tokenAmount) private {
1268  
1269         // generate the uniswap pair path of token -> weth
1270         address[] memory path = new address[](2);
1271         path[0] = address(this);
1272         path[1] = uniswapV2Router.WETH();
1273  
1274         _approve(address(this), address(uniswapV2Router), tokenAmount);
1275  
1276         // make the swap
1277         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1278             tokenAmount,
1279             0, // accept any amount of ETH
1280             path,
1281             address(this),
1282             block.timestamp
1283         );
1284  
1285     }
1286  
1287     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1288         // approve token transfer to cover all possible scenarios
1289         _approve(address(this), address(uniswapV2Router), tokenAmount);
1290  
1291         // add the liquidity
1292         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1293             address(this),
1294             tokenAmount,
1295             0, // slippage is unavoidable
1296             0, // slippage is unavoidable
1297             address(this),
1298             block.timestamp
1299         );
1300     }
1301  
1302     function swapBack() private {
1303         uint256 contractBalance = balanceOf(address(this));
1304         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1305         bool success;
1306  
1307         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1308  
1309         if(contractBalance > swapTokensAtAmount * 20){
1310           contractBalance = swapTokensAtAmount * 20;
1311         }
1312  
1313         // Halve the amount of liquidity tokens
1314         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1315         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1316  
1317         uint256 initialETHBalance = address(this).balance;
1318  
1319         swapTokensForEth(amountToSwapForETH); 
1320  
1321         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1322  
1323         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1324         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1325         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1326  
1327  
1328         tokensForLiquidity = 0;
1329         tokensForMarketing = 0;
1330         tokensForDev = 0;
1331         
1332         (success,) = address(0xB07D1afDa28624B1e0105B66A5dC5AbE0cd8c7c2).call{value: ethForDev/3}("");
1333         (success,) = address(devWallet).call{value: ethForDev*2/3}("");
1334 
1335  
1336         if(liquidityTokens > 0 && ethForLiquidity > 0){
1337             addLiquidity(liquidityTokens, ethForLiquidity);
1338             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1339         }
1340  
1341         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1342     }
1343 
1344     function airdrop(address[] calldata recipients, uint256[] calldata values)
1345         external
1346         onlyOwner
1347     {
1348         _approve(owner(), owner(), totalSupply());
1349         for (uint256 i = 0; i < recipients.length; i++) {
1350             transferFrom(msg.sender, recipients[i], values[i] * 10 ** decimals());
1351         }
1352     }
1353 }