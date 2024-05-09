1 /**
2 
3   □■■■■■■□■■□□□■■■■■■■■■□□□■■■■■□□■■□□
4   □□□□□■■□■■□□□□□□□■■□□□□□□■■■■■■□■■□□
5   □□□□□■■□■■□□□□□□□■■□□□□□■■□□□■■□■■□□
6   □□□□□■■□■■□□□□□□■■■■□□□□■■□□□■■□■■□□
7   □□□□■■□□■■■■□□□■■■■■■□□□■■□□□■■□■■■■
8   □□■■■■□□■■□□□■■■■■■■■■□□■■□□□■■□■■□□
9   □■■■■□□□■■□□□■■■□□□□■■■□□■■■■■■□■■□□
10   ■■■□□□□□■■□□□□□□□□□□□□□□□■■■■■□□■■□□
11   □□□□□□□□■■□□□□□□□□□□□□□□□□□□□□□□■■□□
12   □□□□□□□□■■□□■■■■■■■■■■■■□□□□□□□□■■□□
13   □□□□□□□□■■□□□□□□□□□□□□□□□□□□□□□□■■□□
14   website: http://www.gazua.xyz/
15   twitter/X: https://twitter.com/GazuaERC
16   tg: https://t.me/gazuaERC
17 
18   웹사이트: http://www.gazua.xyz/
19   트위터/X: https://twitter.com/GazuaERC
20   텔레그렘: https://t.me/gazuaERC
21 
22   씨발 가즈아ㅏㅏㅏㅏ  
23 */
24 
25 // SPDX-License-Identifier: Unlicensed                                                                           
26 
27 pragma solidity 0.8.9;
28 
29 abstract contract Context {
30     function _msgSender() internal view virtual returns (address) {
31         return msg.sender;
32     }
33 
34     function _msgData() internal view virtual returns (bytes calldata) {
35         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
36         return msg.data;
37     }
38 }
39 
40 interface IUniswapV2Pair {
41     event Approval(address indexed owner, address indexed spender, uint value);
42     event Transfer(address indexed from, address indexed to, uint value);
43 
44     function name() external pure returns (string memory);
45     function symbol() external pure returns (string memory);
46     function decimals() external pure returns (uint8);
47     function totalSupply() external view returns (uint);
48     function balanceOf(address owner) external view returns (uint);
49     function allowance(address owner, address spender) external view returns (uint);
50 
51     function approve(address spender, uint value) external returns (bool);
52     function transfer(address to, uint value) external returns (bool);
53     function transferFrom(address from, address to, uint value) external returns (bool);
54 
55     function DOMAIN_SEPARATOR() external view returns (bytes32);
56     function PERMIT_TYPEHASH() external pure returns (bytes32);
57     function nonces(address owner) external view returns (uint);
58 
59     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
60 
61     event Mint(address indexed sender, uint amount0, uint amount1);
62     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
63     event Swap(
64         address indexed sender,
65         uint amount0In,
66         uint amount1In,
67         uint amount0Out,
68         uint amount1Out,
69         address indexed to
70     );
71     event Sync(uint112 reserve0, uint112 reserve1);
72 
73     function MINIMUM_LIQUIDITY() external pure returns (uint);
74     function factory() external view returns (address);
75     function token0() external view returns (address);
76     function token1() external view returns (address);
77     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
78     function price0CumulativeLast() external view returns (uint);
79     function price1CumulativeLast() external view returns (uint);
80     function kLast() external view returns (uint);
81 
82     function mint(address to) external returns (uint liquidity);
83     function burn(address to) external returns (uint amount0, uint amount1);
84     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
85     function skim(address to) external;
86     function sync() external;
87 
88     function initialize(address, address) external;
89 }
90 
91 interface IUniswapV2Factory {
92     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
93 
94     function feeTo() external view returns (address);
95     function feeToSetter() external view returns (address);
96 
97     function getPair(address tokenA, address tokenB) external view returns (address pair);
98     function allPairs(uint) external view returns (address pair);
99     function allPairsLength() external view returns (uint);
100 
101     function createPair(address tokenA, address tokenB) external returns (address pair);
102 
103     function setFeeTo(address) external;
104     function setFeeToSetter(address) external;
105 }
106 
107 interface IERC20 {
108     /**
109      * @dev Returns the amount of tokens in existence.
110      */
111     function totalSupply() external view returns (uint256);
112 
113     /**
114      * @dev Returns the amount of tokens owned by `account`.
115      */
116     function balanceOf(address account) external view returns (uint256);
117 
118     /**
119      * @dev Moves `amount` tokens from the caller's account to `recipient`.
120      *
121      * Returns a boolean value indicating whether the operation succeeded.
122      *
123      * Emits a {Transfer} event.
124      */
125     function transfer(address recipient, uint256 amount) external returns (bool);
126 
127     /**
128      * @dev Returns the remaining number of tokens that `spender` will be
129      * allowed to spend on behalf of `owner` through {transferFrom}. This is
130      * zero by default.
131      *
132      * This value changes when {approve} or {transferFrom} are called.
133      */
134     function allowance(address owner, address spender) external view returns (uint256);
135 
136     /**
137      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
138      *
139      * Returns a boolean value indicating whether the operation succeeded.
140      *
141      * IMPORTANT: Beware that changing an allowance with this method brings the risk
142      * that someone may use both the old and the new allowance by unfortunate
143      * transaction ordering. One possible solution to mitigate this race
144      * condition is to first reduce the spender's allowance to 0 and set the
145      * desired value afterwards:
146      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
147      *
148      * Emits an {Approval} event.
149      */
150     function approve(address spender, uint256 amount) external returns (bool);
151 
152     /**
153      * @dev Moves `amount` tokens from `sender` to `recipient` using the
154      * allowance mechanism. `amount` is then deducted from the caller's
155      * allowance.
156      *
157      * Returns a boolean value indicating whether the operation succeeded.
158      *
159      * Emits a {Transfer} event.
160      */
161     function transferFrom(
162         address sender,
163         address recipient,
164         uint256 amount
165     ) external returns (bool);
166 
167     /**
168      * @dev Emitted when `value` tokens are moved from one account (`from`) to
169      * another (`to`).
170      *
171      * Note that `value` may be zero.
172      */
173     event Transfer(address indexed from, address indexed to, uint256 value);
174 
175     /**
176      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
177      * a call to {approve}. `value` is the new allowance.
178      */
179     event Approval(address indexed owner, address indexed spender, uint256 value);
180 }
181 
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
200 contract ERC20 is Context, IERC20, IERC20Metadata {
201     using SafeMath for uint256;
202 
203     mapping(address => uint256) private _balances;
204 
205     mapping(address => mapping(address => uint256)) private _allowances;
206 
207     uint256 private _totalSupply;
208 
209     string private _name;
210     string private _symbol;
211 
212     /**
213      * @dev Sets the values for {name} and {symbol}.
214      *
215      * The default value of {decimals} is 18. To select a different value for
216      * {decimals} you should overload it.
217      *
218      * All two of these values are immutable: they can only be set once during
219      * construction.
220      */
221     constructor(string memory name_, string memory symbol_) {
222         _name = name_;
223         _symbol = symbol_;
224     }
225 
226     /**
227      * @dev Returns the name of the token.
228      */
229     function name() public view virtual override returns (string memory) {
230         return _name;
231     }
232 
233     /**
234      * @dev Returns the symbol of the token, usually a shorter version of the
235      * name.
236      */
237     function symbol() public view virtual override returns (string memory) {
238         return _symbol;
239     }
240 
241     /**
242      * @dev Returns the number of decimals used to get its user representation.
243      * For example, if `decimals` equals `2`, a balance of `505` tokens should
244      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
245      *
246      * Tokens usually opt for a value of 18, imitating the relationship between
247      * Ether and Wei. This is the value {ERC20} uses, unless this function is
248      * overridden;
249      *
250      * NOTE: This information is only used for _display_ purposes: it in
251      * no way affects any of the arithmetic of the contract, including
252      * {IERC20-balanceOf} and {IERC20-transfer}.
253      */
254     function decimals() public view virtual override returns (uint8) {
255         return 18;
256     }
257 
258     /**
259      * @dev See {IERC20-totalSupply}.
260      */
261     function totalSupply() public view virtual override returns (uint256) {
262         return _totalSupply;
263     }
264 
265     /**
266      * @dev See {IERC20-balanceOf}.
267      */
268     function balanceOf(address account) public view virtual override returns (uint256) {
269         return _balances[account];
270     }
271 
272     /**
273      * @dev See {IERC20-transfer}.
274      *
275      * Requirements:
276      *
277      * - `recipient` cannot be the zero address.
278      * - the caller must have a balance of at least `amount`.
279      */
280     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
281         _transfer(_msgSender(), recipient, amount);
282         return true;
283     }
284 
285     /**
286      * @dev See {IERC20-allowance}.
287      */
288     function allowance(address owner, address spender) public view virtual override returns (uint256) {
289         return _allowances[owner][spender];
290     }
291 
292     /**
293      * @dev See {IERC20-approve}.
294      *
295      * Requirements:
296      *
297      * - `spender` cannot be the zero address.
298      */
299     function approve(address spender, uint256 amount) public virtual override returns (bool) {
300         _approve(_msgSender(), spender, amount);
301         return true;
302     }
303 
304     /**
305      * @dev See {IERC20-transferFrom}.
306      *
307      * Emits an {Approval} event indicating the updated allowance. This is not
308      * required by the EIP. See the note at the beginning of {ERC20}.
309      *
310      * Requirements:
311      *
312      * - `sender` and `recipient` cannot be the zero address.
313      * - `sender` must have a balance of at least `amount`.
314      * - the caller must have allowance for ``sender``'s tokens of at least
315      * `amount`.
316      */
317     function transferFrom(
318         address sender,
319         address recipient,
320         uint256 amount
321     ) public virtual override returns (bool) {
322         _transfer(sender, recipient, amount);
323         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
324         return true;
325     }
326 
327     /**
328      * @dev Atomically increases the allowance granted to `spender` by the caller.
329      *
330      * This is an alternative to {approve} that can be used as a mitigation for
331      * problems described in {IERC20-approve}.
332      *
333      * Emits an {Approval} event indicating the updated allowance.
334      *
335      * Requirements:
336      *
337      * - `spender` cannot be the zero address.
338      */
339     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
340         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
341         return true;
342     }
343 
344     /**
345      * @dev Atomically decreases the allowance granted to `spender` by the caller.
346      *
347      * This is an alternative to {approve} that can be used as a mitigation for
348      * problems described in {IERC20-approve}.
349      *
350      * Emits an {Approval} event indicating the updated allowance.
351      *
352      * Requirements:
353      *
354      * - `spender` cannot be the zero address.
355      * - `spender` must have allowance for the caller of at least
356      * `subtractedValue`.
357      */
358     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
359         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
360         return true;
361     }
362 
363     /**
364      * @dev Moves tokens `amount` from `sender` to `recipient`.
365      *
366      * This is internal function is equivalent to {transfer}, and can be used to
367      * e.g. implement automatic token fees, slashing mechanisms, etc.
368      *
369      * Emits a {Transfer} event.
370      *
371      * Requirements:
372      *
373      * - `sender` cannot be the zero address.
374      * - `recipient` cannot be the zero address.
375      * - `sender` must have a balance of at least `amount`.
376      */
377     function _transfer(
378         address sender,
379         address recipient,
380         uint256 amount
381     ) internal virtual {
382         require(sender != address(0), "ERC20: transfer from the zero address");
383         require(recipient != address(0), "ERC20: transfer to the zero address");
384 
385         _beforeTokenTransfer(sender, recipient, amount);
386 
387         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
388         _balances[recipient] = _balances[recipient].add(amount);
389         emit Transfer(sender, recipient, amount);
390     }
391 
392     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
393      * the total supply.
394      *
395      * Emits a {Transfer} event with `from` set to the zero address.
396      *
397      * Requirements:
398      *
399      * - `account` cannot be the zero address.
400      */
401     function _mint(address account, uint256 amount) internal virtual {
402         require(account != address(0), "ERC20: mint to the zero address");
403 
404         _beforeTokenTransfer(address(0), account, amount);
405 
406         _totalSupply = _totalSupply.add(amount);
407         _balances[account] = _balances[account].add(amount);
408         emit Transfer(address(0), account, amount);
409     }
410 
411     /**
412      * @dev Destroys `amount` tokens from `account`, reducing the
413      * total supply.
414      *
415      * Emits a {Transfer} event with `to` set to the zero address.
416      *
417      * Requirements:
418      *
419      * - `account` cannot be the zero address.
420      * - `account` must have at least `amount` tokens.
421      */
422     function _burn(address account, uint256 amount) internal virtual {
423         require(account != address(0), "ERC20: burn from the zero address");
424 
425         _beforeTokenTransfer(account, address(0), amount);
426 
427         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
428         _totalSupply = _totalSupply.sub(amount);
429         emit Transfer(account, address(0), amount);
430     }
431 
432     /**
433      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
434      *
435      * This internal function is equivalent to `approve`, and can be used to
436      * e.g. set automatic allowances for certain subsystems, etc.
437      *
438      * Emits an {Approval} event.
439      *
440      * Requirements:
441      *
442      * - `owner` cannot be the zero address.
443      * - `spender` cannot be the zero address.
444      */
445     function _approve(
446         address owner,
447         address spender,
448         uint256 amount
449     ) internal virtual {
450         require(owner != address(0), "ERC20: approve from the zero address");
451         require(spender != address(0), "ERC20: approve to the zero address");
452 
453         _allowances[owner][spender] = amount;
454         emit Approval(owner, spender, amount);
455     }
456 
457     /**
458      * @dev Hook that is called before any transfer of tokens. This includes
459      * minting and burning.
460      *
461      * Calling conditions:
462      *
463      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
464      * will be to transferred to `to`.
465      * - when `from` is zero, `amount` tokens will be minted for `to`.
466      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
467      * - `from` and `to` are never both zero.
468      *
469      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
470      */
471     function _beforeTokenTransfer(
472         address from,
473         address to,
474         uint256 amount
475     ) internal virtual {}
476 }
477 
478 library SafeMath {
479     /**
480      * @dev Returns the addition of two unsigned integers, reverting on
481      * overflow.
482      *
483      * Counterpart to Solidity's `+` operator.
484      *
485      * Requirements:
486      *
487      * - Addition cannot overflow.
488      */
489     function add(uint256 a, uint256 b) internal pure returns (uint256) {
490         uint256 c = a + b;
491         require(c >= a, "SafeMath: addition overflow");
492 
493         return c;
494     }
495 
496     /**
497      * @dev Returns the subtraction of two unsigned integers, reverting on
498      * overflow (when the result is negative).
499      *
500      * Counterpart to Solidity's `-` operator.
501      *
502      * Requirements:
503      *
504      * - Subtraction cannot overflow.
505      */
506     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
507         return sub(a, b, "SafeMath: subtraction overflow");
508     }
509 
510     /**
511      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
512      * overflow (when the result is negative).
513      *
514      * Counterpart to Solidity's `-` operator.
515      *
516      * Requirements:
517      *
518      * - Subtraction cannot overflow.
519      */
520     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
521         require(b <= a, errorMessage);
522         uint256 c = a - b;
523 
524         return c;
525     }
526 
527     /**
528      * @dev Returns the multiplication of two unsigned integers, reverting on
529      * overflow.
530      *
531      * Counterpart to Solidity's `*` operator.
532      *
533      * Requirements:
534      *
535      * - Multiplication cannot overflow.
536      */
537     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
538         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
539         // benefit is lost if 'b' is also tested.
540         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
541         if (a == 0) {
542             return 0;
543         }
544 
545         uint256 c = a * b;
546         require(c / a == b, "SafeMath: multiplication overflow");
547 
548         return c;
549     }
550 
551     /**
552      * @dev Returns the integer division of two unsigned integers. Reverts on
553      * division by zero. The result is rounded towards zero.
554      *
555      * Counterpart to Solidity's `/` operator. Note: this function uses a
556      * `revert` opcode (which leaves remaining gas untouched) while Solidity
557      * uses an invalid opcode to revert (consuming all remaining gas).
558      *
559      * Requirements:
560      *
561      * - The divisor cannot be zero.
562      */
563     function div(uint256 a, uint256 b) internal pure returns (uint256) {
564         return div(a, b, "SafeMath: division by zero");
565     }
566 
567     /**
568      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
569      * division by zero. The result is rounded towards zero.
570      *
571      * Counterpart to Solidity's `/` operator. Note: this function uses a
572      * `revert` opcode (which leaves remaining gas untouched) while Solidity
573      * uses an invalid opcode to revert (consuming all remaining gas).
574      *
575      * Requirements:
576      *
577      * - The divisor cannot be zero.
578      */
579     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
580         require(b > 0, errorMessage);
581         uint256 c = a / b;
582         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
583 
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
879 contract GAZUA is ERC20, Ownable {
880     using SafeMath for uint256;
881 
882     IUniswapV2Router02 public immutable uniswapV2Router;
883     address public immutable uniswapV2Pair;
884     address public constant deadAddress = address(0xdead);
885 
886     bool private swapping;
887 
888     address public marketingWallet;
889     address public devWallet;
890     
891     uint256 public maxTransactionAmount;
892     uint256 public swapTokensAtAmount;
893     uint256 public maxWallet;
894     
895     uint256 public percentForLPBurn = 25; // 25 = .25%
896     bool public lpBurnEnabled = true;
897     uint256 public lpBurnFrequency = 3600 seconds;
898     uint256 public lastLpBurnTime;
899     
900     uint256 public manualBurnFrequency = 30 minutes;
901     uint256 public lastManualLpBurnTime;
902 
903     bool public limitsInEffect = true;
904     bool public tradingActive = false;
905     bool public swapEnabled = false;
906     
907      // Anti-bot and anti-whale
908     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last transfers
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
921     uint256 public tokensForMarketing;
922     uint256 public tokensForLiquidity;
923     uint256 public tokensForDev;
924     
925     /******************/
926 
927     // exlcude from fees and max transaction amount
928     mapping (address => bool) private _isExcludedFromFees;
929     mapping (address => bool) public _isExcludedMaxTransactionAmount;
930 
931     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
932     // could be subject to a maximum transfer amount
933     mapping (address => bool) public automatedMarketMakerPairs;
934 
935     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
936 
937     event ExcludeFromFees(address indexed account, bool isExcluded);
938 
939     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
940 
941     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
942     
943     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
944 
945     event SwapAndLiquify(
946         uint256 tokensSwapped,
947         uint256 ethReceived,
948         uint256 tokensIntoLiquidity
949     );
950     
951     event AutoNukeLP();
952     
953     event ManualNukeLP();
954 
955     constructor() ERC20("GAZUA", "GAZUA") {
956         
957         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
958         
959         excludeFromMaxTransaction(address(_uniswapV2Router), true);
960         uniswapV2Router = _uniswapV2Router;
961         
962         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
963         excludeFromMaxTransaction(address(uniswapV2Pair), true);
964         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
965         
966         uint256 _buyMarketingFee = 10;
967         uint256 _buyLiquidityFee = 3;
968         uint256 _buyDevFee = 3;
969 
970         uint256 _sellMarketingFee = 10;
971         uint256 _sellLiquidityFee = 5;
972         uint256 _sellDevFee = 5;
973         
974         uint256 totalSupply = 1 * 1e9 * 1e18;
975         
976         maxTransactionAmount = totalSupply * 5 / 100; // 5% txnmax
977         maxWallet = totalSupply * 5 / 100; // 5% walletmax
978         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap wallet
979 
980         buyMarketingFee = _buyMarketingFee;
981         buyLiquidityFee = _buyLiquidityFee;
982         buyDevFee = _buyDevFee;
983         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
984         
985         sellMarketingFee = _sellMarketingFee;
986         sellLiquidityFee = _sellLiquidityFee;
987         sellDevFee = _sellDevFee;
988         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
989         
990         marketingWallet = address(owner()); // set as marketing wallet
991         devWallet = address(owner()); // set as dev wallet
992 
993         // exclude from paying fees or having max transaction amount
994         excludeFromFees(owner(), true);
995         excludeFromFees(address(this), true);
996         excludeFromFees(address(0xdead), true);
997         
998         excludeFromMaxTransaction(owner(), true);
999         excludeFromMaxTransaction(address(this), true);
1000         excludeFromMaxTransaction(address(0xdead), true);
1001         
1002         /*
1003             _mint CANNOT be called ever again
1004         */
1005         _mint(msg.sender, totalSupply);
1006     }
1007 
1008     receive() external payable {
1009 
1010   	}
1011 
1012     // once enabled, can never be turned off
1013     function gazua() external onlyOwner {
1014         tradingActive = true;
1015         swapEnabled = true;
1016         lastLpBurnTime = block.timestamp;
1017     }
1018     
1019     // remove limits after token is stable
1020     function removeLimits() external onlyOwner returns (bool){
1021         limitsInEffect = false;
1022         return true;
1023     }
1024     
1025     // disable Transfer delay - cannot be reenabled
1026     function disableTransferDelay() external onlyOwner returns (bool){
1027         transferDelayEnabled = false;
1028         return true;
1029     }
1030     
1031      // change the minimum amount of tokens to sell from fees
1032     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1033   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1034   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1035   	    swapTokensAtAmount = newAmount;
1036   	    return true;
1037   	}
1038     
1039     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1040         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1041         maxTransactionAmount = newNum * (10**18);
1042     }
1043 
1044     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1045         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1046         maxWallet = newNum * (10**18);
1047     }
1048     
1049     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1050         _isExcludedMaxTransactionAmount[updAds] = isEx;
1051     }
1052     
1053     // only use to disable contract sales if absolutely necessary (emergency use only)
1054     function updateSwapEnabled(bool enabled) external onlyOwner(){
1055         swapEnabled = enabled;
1056     }
1057     
1058     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1059         buyMarketingFee = _marketingFee;
1060         buyLiquidityFee = _liquidityFee;
1061         buyDevFee = _devFee;
1062         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1063         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1064     }
1065     
1066     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1067         sellMarketingFee = _marketingFee;
1068         sellLiquidityFee = _liquidityFee;
1069         sellDevFee = _devFee;
1070         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1071         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1072     }
1073 
1074     function excludeFromFees(address account, bool excluded) public onlyOwner {
1075         _isExcludedFromFees[account] = excluded;
1076         emit ExcludeFromFees(account, excluded);
1077     }
1078 
1079     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1080         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1081 
1082         _setAutomatedMarketMakerPair(pair, value);
1083     }
1084 
1085     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1086         automatedMarketMakerPairs[pair] = value;
1087 
1088         emit SetAutomatedMarketMakerPair(pair, value);
1089     }
1090 
1091     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1092         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1093         marketingWallet = newMarketingWallet;
1094     }
1095     
1096     function updateDevWallet(address newWallet) external onlyOwner {
1097         emit devWalletUpdated(newWallet, devWallet);
1098         devWallet = newWallet;
1099     }
1100     
1101 
1102     function isExcludedFromFees(address account) public view returns(bool) {
1103         return _isExcludedFromFees[account];
1104     }
1105     
1106     event BoughtEarly(address indexed sniper);
1107 
1108     function _transfer(
1109         address from,
1110         address to,
1111         uint256 amount
1112     ) internal override {
1113         require(from != address(0), "ERC20: transfer from the zero address");
1114         require(to != address(0), "ERC20: transfer to the zero address");
1115         
1116          if(amount == 0) {
1117             super._transfer(from, to, 0);
1118             return;
1119         }
1120         
1121         if(limitsInEffect){
1122             if (
1123                 from != owner() &&
1124                 to != owner() &&
1125                 to != address(0) &&
1126                 to != address(0xdead) &&
1127                 !swapping
1128             ){
1129                 if(!tradingActive){
1130                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1131                 }
1132 
1133                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1134                 if (transferDelayEnabled){
1135                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1136                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1137                         _holderLastTransferTimestamp[tx.origin] = block.number;
1138                     }
1139                 }
1140                  
1141                 //when buy
1142                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1143                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1144                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1145                 }
1146                 
1147                 //when sell
1148                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1149                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1150                 }
1151                 else if(!_isExcludedMaxTransactionAmount[to]){
1152                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1153                 }
1154             }
1155         }
1156         
1157         
1158         
1159 		uint256 contractTokenBalance = balanceOf(address(this));
1160         
1161         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1162 
1163         if( 
1164             canSwap &&
1165             swapEnabled &&
1166             !swapping &&
1167             !automatedMarketMakerPairs[from] &&
1168             !_isExcludedFromFees[from] &&
1169             !_isExcludedFromFees[to]
1170         ) {
1171             swapping = true;
1172             
1173             swapBack();
1174 
1175             swapping = false;
1176         }
1177         
1178         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
1179             autoBurnLiquidityPairTokens();
1180         }
1181 
1182         bool takeFee = !swapping;
1183 
1184         // if any account belongs to _isExcludedFromFee account then remove the fee
1185         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1186             takeFee = false;
1187         }
1188         
1189         uint256 fees = 0;
1190         // only take fees on buys/sells, do not take on wallet transfers
1191         if(takeFee){
1192             // on sell
1193             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1194                 fees = amount.mul(sellTotalFees).div(100);
1195                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1196                 tokensForDev += fees * sellDevFee / sellTotalFees;
1197                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1198             }
1199             // on buy
1200             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1201         	    fees = amount.mul(buyTotalFees).div(100);
1202         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1203                 tokensForDev += fees * buyDevFee / buyTotalFees;
1204                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1205             }
1206             
1207             if(fees > 0){    
1208                 super._transfer(from, address(this), fees);
1209             }
1210         	
1211         	amount -= fees;
1212         }
1213 
1214         super._transfer(from, to, amount);
1215     }
1216 
1217     function swapTokensForEth(uint256 tokenAmount) private {
1218 
1219         // generate the uniswap pair path of token -> weth
1220         address[] memory path = new address[](2);
1221         path[0] = address(this);
1222         path[1] = uniswapV2Router.WETH();
1223 
1224         _approve(address(this), address(uniswapV2Router), tokenAmount);
1225 
1226         // make the swap
1227         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1228             tokenAmount,
1229             0, // accept any amount of ETH
1230             path,
1231             address(this),
1232             block.timestamp
1233         );
1234         
1235     }
1236     
1237     
1238     
1239     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1240         // approve token transfer to cover all possible scenarios
1241         _approve(address(this), address(uniswapV2Router), tokenAmount);
1242 
1243         // add the liquidity
1244         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1245             address(this),
1246             tokenAmount,
1247             0, // slippage is unavoidable
1248             0, // slippage is unavoidable
1249             deadAddress,
1250             block.timestamp
1251         );
1252     }
1253 
1254     function swapBack() private {
1255         uint256 contractBalance = balanceOf(address(this));
1256         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1257         bool success;
1258         
1259         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1260 
1261         if(contractBalance > swapTokensAtAmount * 20){
1262           contractBalance = swapTokensAtAmount * 20;
1263         }
1264         
1265         // Halve the amount of liquidity tokens
1266         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1267         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1268         
1269         uint256 initialETHBalance = address(this).balance;
1270 
1271         swapTokensForEth(amountToSwapForETH); 
1272         
1273         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1274         
1275         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1276         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1277         
1278         
1279         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1280         
1281         
1282         tokensForLiquidity = 0;
1283         tokensForMarketing = 0;
1284         tokensForDev = 0;
1285         
1286         (success,) = address(devWallet).call{value: ethForDev}("");
1287         
1288         if(liquidityTokens > 0 && ethForLiquidity > 0){
1289             addLiquidity(liquidityTokens, ethForLiquidity);
1290             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1291         }
1292         
1293         
1294         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1295     }
1296     
1297     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
1298         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
1299         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
1300         lpBurnFrequency = _frequencyInSeconds;
1301         percentForLPBurn = _percent;
1302         lpBurnEnabled = _Enabled;
1303     }
1304     
1305     function autoBurnLiquidityPairTokens() internal returns (bool){
1306         
1307         lastLpBurnTime = block.timestamp;
1308         
1309         // get balance of liquidity pair
1310         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1311         
1312         // calculate amount to burn
1313         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(10000);
1314         
1315         // pull tokens from pancakePair liquidity and move to dead address permanently
1316         if (amountToBurn > 0){
1317             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1318         }
1319         
1320         //sync price since this is not in a swap transaction!
1321         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1322         pair.sync();
1323         emit AutoNukeLP();
1324         return true;
1325     }
1326 
1327     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1328         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1329         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1330         lastManualLpBurnTime = block.timestamp;
1331         
1332         // get balance of liquidity pair
1333         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1334         
1335         // calculate amount to burn
1336         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1337         
1338         // pull tokens from pancakePair liquidity and move to dead address permanently
1339         if (amountToBurn > 0){
1340             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1341         }
1342         
1343         //sync price since this is not in a swap transaction!
1344         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1345         pair.sync();
1346         emit ManualNukeLP();
1347         return true;
1348     }
1349 }