1 /**
2  *Submitted for verification at Etherscan.io on 2022-10-23
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity 0.8.17;
8 
9 
10 // ERC Standard Objects 
11 // --------------------------------------------------------------
12 /*
13  * @dev Provides information about the current execution context, including the
14  * sender of the transaction and its data. While these are generally available
15  * via msg.sender and msg.data, they should not be accessed in such a direct
16  * manner, since when dealing with meta-transactions the account sending and
17  * paying for execution may not be the actual sender (as far as an application
18  * is concerned).
19  *
20  * This contract is only required for intermediate, library-like contracts.
21  */
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view virtual returns (bytes calldata) {
28         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
29         return msg.data;
30     }
31 }
32 
33 library Address {
34     function isContract(address account) internal view returns (bool) {
35         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
36         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
37         // for accounts without code, i.e. `keccak256('')`
38         bytes32 codehash;
39         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
40         // solhint-disable-next-line no-inline-assembly
41         assembly { codehash := extcodehash(account) }
42         return (codehash != accountHash && codehash != 0x0);
43     }
44     function sendValue(address payable recipient, uint256 amount) internal {
45         require(address(this).balance >= amount, "Address: insufficient balance");
46         (bool success, ) = recipient.call{ value: amount }("");
47         require(success, "Address: unable to send value, recipient may have reverted");
48     }
49     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
50       return functionCall(target, data, "Address: low-level call failed");
51     }
52     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
53         return _functionCallWithValue(target, data, 0, errorMessage);
54     }
55     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
56         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
57     }
58     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
59         require(address(this).balance >= value, "Address: insufficient balance for call");
60         return _functionCallWithValue(target, data, value, errorMessage);
61     }
62     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
63         require(isContract(target), "Address: call to non-contract");
64         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
65         if (success) {
66             return returndata;
67         } else {
68             if (returndata.length > 0) {
69                 assembly {
70                     let returndata_size := mload(returndata)
71                     revert(add(32, returndata), returndata_size)
72                 }
73             } else {
74                 revert(errorMessage);
75             }
76         }
77     }
78 }
79 
80 contract Ownable is Context {
81     address private _owner;
82 
83     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
84 
85     /**
86      * @dev Initializes the contract setting the deployer as the initial owner.
87      */
88     constructor () {
89         address msgSender = _msgSender();
90         _owner = msgSender;
91         emit OwnershipTransferred(address(0), msgSender);
92     }
93 
94     /**
95      * @dev Returns the address of the current owner.
96      */
97     function owner() public view returns (address) {
98         return _owner;
99     }
100 
101     /**
102      * @dev Throws if called by any account other than the owner.
103      */
104     modifier onlyOwner() {
105         require(_owner == _msgSender(), "Ownable: caller is not the owner");
106         _;
107     }
108 
109     /**
110      * @dev Leaves the contract without owner. It will not be possible to call
111      * `onlyOwner` functions anymore. Can only be called by the current owner.
112      *
113      * NOTE: Renouncing ownership will leave the contract without an owner,
114      * thereby removing any functionality that is only available to the owner.
115      */
116     function renounceOwnership() public virtual onlyOwner {
117         emit OwnershipTransferred(_owner, address(0));
118         _owner = address(0);
119     }
120 
121     /**
122      * @dev Transfers ownership of the contract to a new account (`newOwner`).
123      * Can only be called by the current owner.
124      */
125     function transferOwnership(address newOwner) public virtual onlyOwner {
126         require(newOwner != address(0), "Ownable: new owner is the zero address");
127         emit OwnershipTransferred(_owner, newOwner);
128         _owner = newOwner;
129     }
130 }
131 
132 /**
133  * @dev Interface of the ERC20 standard as defined in the EIP.
134  */
135 interface IERC20 {
136     /**
137      * @dev Returns the amount of tokens in existence.
138      */
139     function totalSupply() external view returns (uint256);
140 
141     /**
142      * @dev Returns the amount of tokens owned by `account`.
143      */
144     function balanceOf(address account) external view returns (uint256);
145 
146     /**
147      * @dev Moves `amount` tokens from the caller's account to `recipient`.
148      *
149      * Returns a boolean value indicating whether the operation succeeded.
150      *
151      * Emits a {Transfer} event.
152      */
153     function transfer(address recipient, uint256 amount) external returns (bool);
154 
155     /**
156      * @dev Returns the remaining number of tokens that `spender` will be
157      * allowed to spend on behalf of `owner` through {transferFrom}. This is
158      * zero by default.
159      *
160      * This value changes when {approve} or {transferFrom} are called.
161      */
162     function allowance(address owner, address spender) external view returns (uint256);
163 
164     /**
165      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
166      *
167      * Returns a boolean value indicating whether the operation succeeded.
168      *
169      * IMPORTANT: Beware that changing an allowance with this method brings the risk
170      * that someone may use both the old and the new allowance by unfortunate
171      * transaction ordering. One possible solution to mitigate this race
172      * condition is to first reduce the spender's allowance to 0 and set the
173      * desired value afterwards:
174      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
175      *
176      * Emits an {Approval} event.
177      */
178     function approve(address spender, uint256 amount) external returns (bool);
179 
180     /**
181      * @dev Moves `amount` tokens from `sender` to `recipient` using the
182      * allowance mechanism. `amount` is then deducted from the caller's
183      * allowance.
184      *
185      * Returns a boolean value indicating whether the operation succeeded.
186      *
187      * Emits a {Transfer} event.
188      */
189     function transferFrom(
190         address sender,
191         address recipient,
192         uint256 amount
193     ) external returns (bool);
194 
195     /**
196      * @dev Emitted when `value` tokens are moved from one account (`from`) to
197      * another (`to`).
198      *
199      * Note that `value` may be zero.
200      */
201     event Transfer(address indexed from, address indexed to, uint256 value);
202 
203     /**
204      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
205      * a call to {approve}. `value` is the new allowance.
206      */
207     event Approval(address indexed owner, address indexed spender, uint256 value);
208 }
209 
210 /**
211  * @dev Interface for the optional metadata functions from the ERC20 standard.
212  *
213  * _Available since v4.1._
214  */
215 interface IERC20Metadata is IERC20 {
216     /**
217      * @dev Returns the name of the token.
218      */
219     function name() external view returns (string memory);
220 
221     /**
222      * @dev Returns the symbol of the token.
223      */
224     function symbol() external view returns (string memory);
225 
226     /**
227      * @dev Returns the decimals places of the token.
228      */
229     function decimals() external view returns (uint8);
230 } 
231 
232 // Safe Math Helpers 
233 // --------------------------------------------------------------
234 library SafeMath {
235     /**
236      * @dev Returns the addition of two unsigned integers, reverting on
237      * overflow.
238      *
239      * Counterpart to Solidity's `+` operator.
240      *
241      * Requirements:
242      *
243      * - Addition cannot overflow.
244      */
245     function add(uint256 a, uint256 b) internal pure returns (uint256) {
246         uint256 c = a + b;
247         require(c >= a, "SafeMath: addition overflow");
248 
249         return c;
250     }
251 
252     /**
253      * @dev Returns the subtraction of two unsigned integers, reverting on
254      * overflow (when the result is negative).
255      *
256      * Counterpart to Solidity's `-` operator.
257      *
258      * Requirements:
259      *
260      * - Subtraction cannot overflow.
261      */
262     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
263         return sub(a, b, "SafeMath: subtraction overflow");
264     }
265 
266     /**
267      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
268      * overflow (when the result is negative).
269      *
270      * Counterpart to Solidity's `-` operator.
271      *
272      * Requirements:
273      *
274      * - Subtraction cannot overflow.
275      */
276     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
277         require(b <= a, errorMessage);
278         uint256 c = a - b;
279 
280         return c;
281     }
282 
283     /**
284      * @dev Returns the multiplication of two unsigned integers, reverting on
285      * overflow.
286      *
287      * Counterpart to Solidity's `*` operator.
288      *
289      * Requirements:
290      *
291      * - Multiplication cannot overflow.
292      */
293     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
294         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
295         // benefit is lost if 'b' is also tested.
296         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
297         if (a == 0) {
298             return 0;
299         }
300 
301         uint256 c = a * b;
302         require(c / a == b, "SafeMath: multiplication overflow");
303 
304         return c;
305     }
306 
307     /**
308      * @dev Returns the integer division of two unsigned integers. Reverts on
309      * division by zero. The result is rounded towards zero.
310      *
311      * Counterpart to Solidity's `/` operator. Note: this function uses a
312      * `revert` opcode (which leaves remaining gas untouched) while Solidity
313      * uses an invalid opcode to revert (consuming all remaining gas).
314      *
315      * Requirements:
316      *
317      * - The divisor cannot be zero.
318      */
319     function div(uint256 a, uint256 b) internal pure returns (uint256) {
320         return div(a, b, "SafeMath: division by zero");
321     }
322 
323     /**
324      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
325      * division by zero. The result is rounded towards zero.
326      *
327      * Counterpart to Solidity's `/` operator. Note: this function uses a
328      * `revert` opcode (which leaves remaining gas untouched) while Solidity
329      * uses an invalid opcode to revert (consuming all remaining gas).
330      *
331      * Requirements:
332      *
333      * - The divisor cannot be zero.
334      */
335     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
336         require(b > 0, errorMessage);
337         uint256 c = a / b;
338         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
339 
340         return c;
341     }
342 
343     /**
344      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
345      * Reverts when dividing by zero.
346      *
347      * Counterpart to Solidity's `%` operator. This function uses a `revert`
348      * opcode (which leaves remaining gas untouched) while Solidity uses an
349      * invalid opcode to revert (consuming all remaining gas).
350      *
351      * Requirements:
352      *
353      * - The divisor cannot be zero.
354      */
355     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
356         return mod(a, b, "SafeMath: modulo by zero");
357     }
358 
359     /**
360      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
361      * Reverts with custom message when dividing by zero.
362      *
363      * Counterpart to Solidity's `%` operator. This function uses a `revert`
364      * opcode (which leaves remaining gas untouched) while Solidity uses an
365      * invalid opcode to revert (consuming all remaining gas).
366      *
367      * Requirements:
368      *
369      * - The divisor cannot be zero.
370      */
371     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
372         require(b != 0, errorMessage);
373         return a % b;
374     }
375 }
376 
377 contract ERC20 is Context, IERC20, IERC20Metadata {
378     using SafeMath for uint256;
379 
380     mapping(address => uint256) private _balances;
381     mapping(address => mapping(address => uint256)) private _allowances;
382 
383     uint256 private _totalSupply;
384     string private _name;
385     string private _symbol;
386     uint8 private _decimals;
387 
388     /**
389      * @dev Sets the values for {name} and {symbol}.
390      *
391      * The default value of {decimals} is 18. To select a different value for
392      * {decimals} you should overload it.
393      *
394      * All two of these values are immutable: they can only be set once during
395      * construction.
396      */
397     constructor(string memory name_, string memory symbol_, uint8 decimals_) {
398         _name = name_;
399         _symbol = symbol_;
400         _decimals = decimals_;
401     }
402 
403     /**
404      * @dev Returns the name of the token.
405      */
406     function name() public view virtual override returns (string memory) {
407         return _name;
408     }
409 
410     /**
411      * @dev Returns the symbol of the token, usually a shorter version of the
412      * name.
413      */
414     function symbol() public view virtual override returns (string memory) {
415         return _symbol;
416     }
417 
418     /**
419      * @dev Returns the number of decimals used to get its user representation.
420      * For example, if `decimals` equals `2`, a balance of `505` tokens should
421      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
422      *
423      * Tokens usually opt for a value of 18, imitating the relationship between
424      * Ether and Wei. This is the value {ERC20} uses, unless this function is
425      * overridden;
426      *
427      * NOTE: This information is only used for _display_ purposes: it in
428      * no way affects any of the arithmetic of the contract, including
429      * {IERC20-balanceOf} and {IERC20-transfer}.
430      */
431     function decimals() public view virtual override returns (uint8) {
432         return _decimals;
433     }
434 
435     /**
436      * @dev See {IERC20-totalSupply}.
437      */
438     function totalSupply() public view virtual override returns (uint256) {
439         return _totalSupply;
440     }
441 
442     /**
443      * @dev See {IERC20-balanceOf}.
444      */
445     function balanceOf(address account) public view virtual override returns (uint256) {
446         return _balances[account];
447     }
448 
449     /**
450      * @dev See {IERC20-transfer}.
451      *
452      * Requirements:
453      *
454      * - `recipient` cannot be the zero address.
455      * - the caller must have a balance of at least `amount`.
456      */
457     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
458         _transfer(_msgSender(), recipient, amount);
459         return true;
460     }
461 
462     /**
463      * @dev See {IERC20-allowance}.
464      */
465     function allowance(address owner, address spender) public view virtual override returns (uint256) {
466         return _allowances[owner][spender];
467     }
468 
469     /**
470      * @dev See {IERC20-approve}.
471      *
472      * Requirements:
473      *
474      * - `spender` cannot be the zero address.
475      */
476     function approve(address spender, uint256 amount) public virtual override returns (bool) {
477         _approve(_msgSender(), spender, amount);
478         return true;
479     }
480 
481     /**
482      * @dev See {IERC20-transferFrom}.
483      *
484      * Emits an {Approval} event indicating the updated allowance. This is not
485      * required by the EIP. See the note at the beginning of {ERC20}.
486      *
487      * Requirements:
488      *
489      * - `sender` and `recipient` cannot be the zero address.
490      * - `sender` must have a balance of at least `amount`.
491      * - the caller must have allowance for ``sender``'s tokens of at least
492      * `amount`.
493      */
494     function transferFrom(
495         address sender,
496         address recipient,
497         uint256 amount
498     ) public virtual override returns (bool) {
499         _transfer(sender, recipient, amount);
500         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
501         return true;
502     }
503 
504     /**
505      * @dev Atomically increases the allowance granted to `spender` by the caller.
506      *
507      * This is an alternative to {approve} that can be used as a mitigation for
508      * problems described in {IERC20-approve}.
509      *
510      * Emits an {Approval} event indicating the updated allowance.
511      *
512      * Requirements:
513      *
514      * - `spender` cannot be the zero address.
515      */
516     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
517         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
518         return true;
519     }
520 
521     /**
522      * @dev Atomically decreases the allowance granted to `spender` by the caller.
523      *
524      * This is an alternative to {approve} that can be used as a mitigation for
525      * problems described in {IERC20-approve}.
526      *
527      * Emits an {Approval} event indicating the updated allowance.
528      *
529      * Requirements:
530      *
531      * - `spender` cannot be the zero address.
532      * - `spender` must have allowance for the caller of at least
533      * `subtractedValue`.
534      */
535     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
536         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
537         return true;
538     }
539 
540     /**
541      * @dev Moves tokens `amount` from `sender` to `recipient`.
542      *
543      * This is internal function is equivalent to {transfer}, and can be used to
544      * e.g. implement automatic token fees, slashing mechanisms, etc.
545      *
546      * Emits a {Transfer} event.
547      *
548      * Requirements:
549      *
550      * - `sender` cannot be the zero address.
551      * - `recipient` cannot be the zero address.
552      * - `sender` must have a balance of at least `amount`.
553      */
554     function _transfer(
555         address sender,
556         address recipient,
557         uint256 amount
558     ) internal virtual {
559         require(sender != address(0), "ERC20: transfer from the zero address");
560         require(recipient != address(0), "ERC20: transfer to the zero address");
561 
562         _beforeTokenTransfer(sender, recipient, amount);
563 
564         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
565         _balances[recipient] = _balances[recipient].add(amount);
566         emit Transfer(sender, recipient, amount);
567     }
568 
569     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
570      * the total supply.
571      *
572      * Emits a {Transfer} event with `from` set to the zero address.
573      *
574      * Requirements:
575      *
576      * - `account` cannot be the zero address.
577      */
578     function _createInitialSupply(address account, uint256 amount) internal virtual {
579         require(account != address(0), "ERC20: cannot send to the zero address");
580 
581         _beforeTokenTransfer(address(0), account, amount);
582 
583         _totalSupply = _totalSupply.add(amount);
584         _balances[account] = _balances[account].add(amount);
585         emit Transfer(address(0), account, amount);
586     }
587 
588     /**
589      * @dev Destroys `amount` tokens from `account`, reducing the
590      * total supply.
591      *
592      * Emits a {Transfer} event with `to` set to the zero address.
593      *
594      * Requirements:
595      *
596      * - `account` cannot be the zero address.
597      * - `account` must have at least `amount` tokens.
598      */
599     function _burn(address account, uint256 amount) internal virtual {
600         require(account != address(0), "ERC20: burn from the zero address");
601 
602         _beforeTokenTransfer(account, address(0), amount);
603 
604         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
605         _totalSupply = _totalSupply.sub(amount);
606         emit Transfer(account, address(0), amount);
607     }
608 
609     /**
610      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
611      *
612      * This internal function is equivalent to `approve`, and can be used to
613      * e.g. set automatic allowances for certain subsystems, etc.
614      *
615      * Emits an {Approval} event.
616      *
617      * Requirements:
618      *
619      * - `owner` cannot be the zero address.
620      * - `spender` cannot be the zero address.
621      */
622     function _approve(
623         address owner,
624         address spender,
625         uint256 amount
626     ) internal virtual {
627         require(owner != address(0), "ERC20: approve from the zero address");
628         require(spender != address(0), "ERC20: approve to the zero address");
629 
630         _allowances[owner][spender] = amount;
631         emit Approval(owner, spender, amount);
632     }
633 
634     function _beforeTokenTransfer(
635         address from,
636         address to,
637         uint256 amount
638     ) internal virtual {}
639 }
640 
641 // Uniswap Router 
642 // --------------------------------------------------------------
643 interface IUniswapV2Factory {
644     event PairCreated(
645         address indexed token0,
646         address indexed token1,
647         address pair,
648         uint256
649     );
650     function feeTo() external view returns (address);
651     function feeToSetter() external view returns (address);
652     function allPairsLength() external view returns (uint256);
653     function getPair(address tokenA, address tokenB)
654         external
655         view
656         returns (address pair);
657     function allPairs(uint256) external view returns (address pair);
658     function createPair(address tokenA, address tokenB)
659         external
660         returns (address pair);
661     function setFeeTo(address) external;
662     function setFeeToSetter(address) external;
663 }
664 interface IUniswapV2Pair {
665     event Approval(
666         address indexed owner,
667         address indexed spender,
668         uint256 value
669     );
670     event Transfer(address indexed from, address indexed to, uint256 value);
671     function name() external pure returns (string memory);
672     function symbol() external pure returns (string memory);
673     function decimals() external pure returns (uint8);
674     function totalSupply() external view returns (uint256);
675     function balanceOf(address owner) external view returns (uint256);
676     function allowance(address owner, address spender)
677         external
678         view
679         returns (uint256);
680     function approve(address spender, uint256 value) external returns (bool);
681     function transfer(address to, uint256 value) external returns (bool);
682     function transferFrom(
683         address from,
684         address to,
685         uint256 value
686     ) external returns (bool);
687     function DOMAIN_SEPARATOR() external view returns (bytes32);
688     function PERMIT_TYPEHASH() external pure returns (bytes32);
689     function nonces(address owner) external view returns (uint256);
690     function permit(
691         address owner,
692         address spender,
693         uint256 value,
694         uint256 deadline,
695         uint8 v,
696         bytes32 r,
697         bytes32 s
698     ) external;
699     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
700     event Burn(
701         address indexed sender,
702         uint256 amount0,
703         uint256 amount1,
704         address indexed to
705     );
706     event Swap(
707         address indexed sender,
708         uint256 amount0In,
709         uint256 amount1In,
710         uint256 amount0Out,
711         uint256 amount1Out,
712         address indexed to
713     );
714     event Sync(uint112 reserve0, uint112 reserve1);
715     function MINIMUM_LIQUIDITY() external pure returns (uint256);
716     function factory() external view returns (address);
717     function token0() external view returns (address);
718     function token1() external view returns (address);
719     function getReserves()
720         external
721         view
722         returns (
723             uint112 reserve0,
724             uint112 reserve1,
725             uint32 blockTimestampLast
726         );
727     function price0CumulativeLast() external view returns (uint256);
728     function price1CumulativeLast() external view returns (uint256);
729     function kLast() external view returns (uint256);
730     function mint(address to) external returns (uint256 liquidity);
731     function burn(address to)
732         external
733         returns (uint256 amount0, uint256 amount1);
734     function swap(
735         uint256 amount0Out,
736         uint256 amount1Out,
737         address to,
738         bytes calldata data
739     ) external;
740     function skim(address to) external;
741     function sync() external;
742     function initialize(address, address) external;
743 }
744 interface IUniswapV2Router01 {
745     function factory() external pure returns (address);
746     function WETH() external pure returns (address);
747     function addLiquidity(
748         address tokenA,
749         address tokenB,
750         uint256 amountADesired,
751         uint256 amountBDesired,
752         uint256 amountAMin,
753         uint256 amountBMin,
754         address to,
755         uint256 deadline
756     )
757         external
758         returns (
759             uint256 amountA,
760             uint256 amountB,
761             uint256 liquidity
762         );
763     function addLiquidityETH(
764         address token,
765         uint256 amountTokenDesired,
766         uint256 amountTokenMin,
767         uint256 amountETHMin,
768         address to,
769         uint256 deadline
770     )
771         external
772         payable
773         returns (
774             uint256 amountToken,
775             uint256 amountETH,
776             uint256 liquidity
777         );
778     function removeLiquidity(
779         address tokenA,
780         address tokenB,
781         uint256 liquidity,
782         uint256 amountAMin,
783         uint256 amountBMin,
784         address to,
785         uint256 deadline
786     ) external returns (uint256 amountA, uint256 amountB);
787     function removeLiquidityETH(
788         address token,
789         uint256 liquidity,
790         uint256 amountTokenMin,
791         uint256 amountETHMin,
792         address to,
793         uint256 deadline
794     ) external returns (uint256 amountToken, uint256 amountETH);
795     function removeLiquidityWithPermit(
796         address tokenA,
797         address tokenB,
798         uint256 liquidity,
799         uint256 amountAMin,
800         uint256 amountBMin,
801         address to,
802         uint256 deadline,
803         bool approveMax,
804         uint8 v,
805         bytes32 r,
806         bytes32 s
807     ) external returns (uint256 amountA, uint256 amountB);
808     function removeLiquidityETHWithPermit(
809         address token,
810         uint256 liquidity,
811         uint256 amountTokenMin,
812         uint256 amountETHMin,
813         address to,
814         uint256 deadline,
815         bool approveMax,
816         uint8 v,
817         bytes32 r,
818         bytes32 s
819     ) external returns (uint256 amountToken, uint256 amountETH);
820     function swapExactTokensForTokens(
821         uint256 amountIn,
822         uint256 amountOutMin,
823         address[] calldata path,
824         address to,
825         uint256 deadline
826     ) external returns (uint256[] memory amounts);
827     function swapTokensForExactTokens(
828         uint256 amountOut,
829         uint256 amountInMax,
830         address[] calldata path,
831         address to,
832         uint256 deadline
833     ) external returns (uint256[] memory amounts);
834     function swapExactETHForTokens(
835         uint256 amountOutMin,
836         address[] calldata path,
837         address to,
838         uint256 deadline
839     ) external payable returns (uint256[] memory amounts);
840     function swapTokensForExactETH(
841         uint256 amountOut,
842         uint256 amountInMax,
843         address[] calldata path,
844         address to,
845         uint256 deadline
846     ) external returns (uint256[] memory amounts);
847     function swapExactTokensForETH(
848         uint256 amountIn,
849         uint256 amountOutMin,
850         address[] calldata path,
851         address to,
852         uint256 deadline
853     ) external returns (uint256[] memory amounts);
854     function swapETHForExactTokens(
855         uint256 amountOut,
856         address[] calldata path,
857         address to,
858         uint256 deadline
859     ) external payable returns (uint256[] memory amounts);
860     function quote(
861         uint256 amountA,
862         uint256 reserveA,
863         uint256 reserveB
864     ) external pure returns (uint256 amountB);
865     function getAmountOut(
866         uint256 amountIn,
867         uint256 reserveIn,
868         uint256 reserveOut
869     ) external pure returns (uint256 amountOut);
870     function getAmountIn(
871         uint256 amountOut,
872         uint256 reserveIn,
873         uint256 reserveOut
874     ) external pure returns (uint256 amountIn);
875     function getAmountsOut(uint256 amountIn, address[] calldata path)
876         external
877         view
878         returns (uint256[] memory amounts);
879     function getAmountsIn(uint256 amountOut, address[] calldata path)
880         external
881         view
882         returns (uint256[] memory amounts);
883 }
884 interface IUniswapV2Router02 is IUniswapV2Router01 {
885     function removeLiquidityETHSupportingFeeOnTransferTokens(
886         address token,
887         uint256 liquidity,
888         uint256 amountTokenMin,
889         uint256 amountETHMin,
890         address to,
891         uint256 deadline
892     ) external returns (uint256 amountETH);
893     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
894         address token,
895         uint256 liquidity,
896         uint256 amountTokenMin,
897         uint256 amountETHMin,
898         address to,
899         uint256 deadline,
900         bool approveMax,
901         uint8 v,
902         bytes32 r,
903         bytes32 s
904     ) external returns (uint256 amountETH);
905     function swapExactETHForTokensSupportingFeeOnTransferTokens(
906         uint256 amountOutMin,
907         address[] calldata path,
908         address to,
909         uint256 deadline
910     ) external payable;
911     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
912         uint256 amountIn,
913         uint256 amountOutMin,
914         address[] calldata path,
915         address to,
916         uint256 deadline
917     ) external;
918     function swapExactTokensForETHSupportingFeeOnTransferTokens(
919         uint256 amountIn,
920         uint256 amountOutMin,
921         address[] calldata path,
922         address to,
923         uint256 deadline
924     ) external;
925 }
926 
927 
928 // Main Contract Logic 
929 // --------------------------------------------------------------
930 contract Alcazar is Context, IERC20, Ownable {
931     // Imports
932     using SafeMath for uint256;
933     using Address for address;
934 
935     // Configurables -----------------------------
936     
937     // Context
938     string private _name = "Alcazar";
939     string private _symbol = "ALCAZAR";
940     uint8 private _decimals = 18;
941 
942     // Supply 
943     uint256 private _totalSupply = 1 * 1e9 * 1e18;    
944     uint256 private minimumTokensBeforeSwap = _totalSupply * 25 / 100000;    
945 
946     // Restrictions
947     uint256 public _maxTxAmount = (_totalSupply * 8) / 1000;      
948     uint256 public _walletMax = (_totalSupply * 8) / 1000; 
949     bool public checkWalletLimit = true;
950     
951     // wallets
952     address payable public liquidityWallet = payable(0x2FF9d7be466f674c8640466A55fFdd02b3a00864);
953     address payable public operationsWallet =  payable(0x2FF9d7be466f674c8640466A55fFdd02b3a00864);
954     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
955     
956     // fees    
957     uint256 public liquidityFeeBuy = 2;
958     uint256 public operationsFeeBuy = 1;
959     uint256 public totalFeesBuy;
960     uint256 public maxTotalFeeBuy = 10;
961 
962     // fees
963     uint256 public liquidityFeeSell = 2;
964     uint256 public operationsFeeSell = 1;
965     uint256 public totalFeesSell;
966     uint256 public maxTotalFeeSell = 10;
967 
968     // distribution ratio
969     uint256 public _liquiditySharePercentage = 67;
970     uint256 public _operationsSharePercentage = 33;
971     uint256 public _totalDistributionShares;
972 
973     // max amounts    
974     mapping (address => uint256) _balances;
975     mapping (address => mapping (address => uint256)) private _allowances;
976     mapping (address => bool) public isExcludedFromFee;
977     mapping (address => bool) public isWalletLimitExempt;
978     mapping (address => bool) isTxLimitExempt;
979 
980     // Router Information    
981     mapping (address => bool) public isMarketPair;
982     IUniswapV2Router02 public uniswapV2Router;
983     address public uniswapPair; 
984     
985     // toggle swap back (fees)
986     bool inSwapAndLiquify;
987     uint256 public tokensForLiquidity;
988     uint256 public tokensForOperations;    
989 
990     // Launch Settings
991     bool public tradingOpen = false;    
992 
993     // events    
994     event LiquidityWalletUpdated(address indexed newLiquidityWallet, address indexed oldLiquidityWallet);
995     event OperationsWalletUpdated(address indexed newOperationsWallet, address indexed oldOperationsWallet); 
996     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiqudity); 
997     event SwapTokensForETH(uint256 amountIn, address[] path);
998     
999     // toogle to stop swap if already underway
1000     modifier lockTheSwap {
1001         inSwapAndLiquify = true;
1002         _;
1003         inSwapAndLiquify = false;
1004     }
1005 
1006     constructor () {
1007 
1008         // load total fees 
1009         totalFeesBuy = operationsFeeBuy + liquidityFeeBuy;
1010         totalFeesSell = operationsFeeSell + liquidityFeeSell; 
1011 
1012         // load total distribution 
1013         _totalDistributionShares = _liquiditySharePercentage + _operationsSharePercentage;
1014         
1015         // create router ------------------------------
1016         IUniswapV2Router02 _uniswapV2Router;
1017         if (block.chainid == 1) {
1018             _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1019         } else if (block.chainid == 5) {
1020             _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1021         } else revert();
1022 
1023          // Create a uniswap pair for this new token         
1024         uniswapPair = IUniswapV2Factory(_uniswapV2Router.factory())
1025             .createPair(address(this), _uniswapV2Router.WETH());
1026         uniswapV2Router = _uniswapV2Router; 
1027         isMarketPair[address(uniswapPair)] = true;
1028 
1029         // set allowances        
1030         _allowances[address(this)][address(uniswapV2Router)] = _totalSupply;
1031         
1032         // exclude from paying fees or having max transaction amount
1033         isExcludedFromFee[owner()] = true;
1034         isExcludedFromFee[address(this)] = true;
1035         isExcludedFromFee[address(0xdead)] = true; 
1036         isExcludedFromFee[liquidityWallet] = true; 
1037         isExcludedFromFee[operationsWallet] = true; 
1038         
1039         // exclude contracts from max wallet size
1040         isWalletLimitExempt[owner()] = true;
1041         isWalletLimitExempt[address(uniswapPair)] = true;
1042         isWalletLimitExempt[address(this)] = true;
1043         isWalletLimitExempt[liquidityWallet] = true; 
1044         isWalletLimitExempt[operationsWallet] = true; 
1045         
1046         // exclude contracts from max wallet size
1047         isTxLimitExempt[owner()] = true;
1048         isTxLimitExempt[address(this)] = true;
1049         
1050         _balances[_msgSender()] = _totalSupply;   
1051         emit Transfer(address(0), _msgSender(), _totalSupply);  
1052     }
1053 
1054     receive() external payable {
1055 
1056   	}
1057   	
1058   	// @dev Public read functions start -------------------------------------
1059     function name() public view returns (string memory) {
1060         return _name;
1061     }
1062 
1063     function symbol() public view returns (string memory) {
1064         return _symbol;
1065     }
1066 
1067     function decimals() public view returns (uint8) {
1068         return _decimals;
1069     }
1070 
1071     function totalSupply() public view override returns (uint256) {
1072         return _totalSupply;
1073     }
1074 
1075     function balanceOf(address account) public view override returns (uint256) {
1076         return _balances[account];
1077     }
1078 
1079     // custom allowance methods
1080     function allowance(address owner, address spender) public view override returns (uint256) {
1081         return _allowances[owner][spender];
1082     }
1083     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1084         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1085         return true;
1086     }
1087     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1088         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1089         return true;
1090     }
1091     
1092     // get minimum tokens before swap
1093     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
1094         return minimumTokensBeforeSwap;
1095     }
1096 
1097     // approve spending methods
1098     function approve(address spender, uint256 amount) public override returns (bool) {
1099         _approve(_msgSender(), spender, amount);
1100         return true;
1101     }
1102     function _approve(address owner, address spender, uint256 amount) private {
1103         require(owner != address(0), "ERC20: approve from the zero address");
1104         require(spender != address(0), "ERC20: approve to the zero address");
1105         _allowances[owner][spender] = amount;
1106         emit Approval(owner, spender, amount);
1107     }
1108     
1109     function getCirculatingSupply() public view returns (uint256) {
1110         return _totalSupply.sub(balanceOf(deadAddress));
1111     }
1112     
1113     function getBlock()public view returns (uint256) {
1114         return block.number;
1115     }
1116 
1117   	// @dev Owner functions start -------------------------------------
1118     
1119     // toogle market pair status
1120     function setMarketPairStatus(address account, bool newValue) public onlyOwner {
1121         isMarketPair[account] = newValue;
1122     }
1123 
1124     // set excluded xx limit 
1125     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
1126         isTxLimitExempt[holder] = exempt;
1127     }
1128 
1129     // update max tx amount
1130     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1131         _maxTxAmount = maxTxAmount;
1132     }
1133 
1134     // set excluded tax 
1135     function setIsExcludedFromFee(address account, bool newValue) public onlyOwner {
1136         isExcludedFromFee[account] = newValue;
1137     }
1138     
1139     // update fees
1140     function updateFees(uint256 _operationsFee, uint256 _liquidityFee) external onlyOwner {
1141         operationsFeeBuy = _operationsFee;
1142         liquidityFeeBuy = _liquidityFee;
1143         totalFeesBuy = operationsFeeBuy + liquidityFeeBuy;
1144         require(totalFeesBuy <= maxTotalFeeBuy, "Must keep fees at maxTotalFeeBuy or less");
1145     }
1146 
1147     function updateFeesSell(uint256 _operationsFee, uint256 _liquidityFee) external onlyOwner {
1148         operationsFeeSell = _operationsFee;
1149         liquidityFeeSell = _liquidityFee;
1150         totalFeesSell = operationsFeeSell + liquidityFeeSell;
1151         require(totalFeesSell <= maxTotalFeeSell, "Must keep fees at maxTotalFeeSell or less");
1152     }
1153     
1154     // set distribution settings
1155     function setDistributionSettings(uint256 newLiquidityShare, uint256 newOperationsShare) external onlyOwner() {
1156         _liquiditySharePercentage = newLiquidityShare;
1157         _operationsSharePercentage = newOperationsShare; 
1158         _totalDistributionShares = _liquiditySharePercentage + _operationsSharePercentage;
1159         require(_totalDistributionShares == 100, "Distribution needs to total to 100");
1160     }
1161 
1162     // remove wallet limit
1163     function enableDisableWalletLimit(bool newValue) external onlyOwner {
1164        checkWalletLimit = newValue;
1165     }
1166     
1167     // set excluded wallet limit 
1168     function setIsWalletLimitExempt(address holder, bool exempt) external onlyOwner {
1169         isWalletLimitExempt[holder] = exempt;
1170     }
1171     
1172     // update wallet limit
1173     function setWalletLimit(uint256 newLimit) external onlyOwner {
1174         _walletMax  = newLimit;
1175     }
1176     
1177     // change the minimum amount of tokens to sell from fees
1178     function setNumTokensBeforeSwap(uint256 newLimit) external onlyOwner() {
1179         minimumTokensBeforeSwap = newLimit;
1180     }
1181 
1182     // sets the wallet that receives LP tokens to lock
1183     function updateLiquidityWallet(address newAddress) external onlyOwner {
1184         require(newAddress != address(0), "Cannot set to address 0");
1185         isExcludedFromFee[newAddress] = true;
1186         isExcludedFromFee[liquidityWallet] = false;
1187         emit LiquidityWalletUpdated(newAddress, liquidityWallet);
1188         liquidityWallet =  payable(newAddress);
1189     }
1190     
1191     // updates the operations wallet (marketing, charity, etc.)
1192     function updateOperationsWallet(address newAddress) external onlyOwner {
1193         require(newAddress != address(0), "Cannot set to address 0");
1194         isExcludedFromFee[newAddress] = true;
1195         isExcludedFromFee[operationsWallet] = false;
1196         emit OperationsWalletUpdated(newAddress, operationsWallet);
1197         operationsWallet = payable(newAddress);
1198     }    
1199 
1200     // transfer amount to address
1201     function transferToAddressETH(address payable recipient, uint256 amount) private {
1202         recipient.transfer(amount);
1203     }
1204 
1205     // change router address
1206     function changeRouterAddress(address newRouterAddress) public onlyOwner returns(address newPairAddress) {
1207 
1208         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(newRouterAddress); 
1209         newPairAddress = IUniswapV2Factory(_uniswapV2Router.factory()).getPair(address(this), _uniswapV2Router.WETH());
1210 
1211         // check if new pair deployed
1212         if(newPairAddress == address(0)) 
1213         {
1214             newPairAddress = IUniswapV2Factory(_uniswapV2Router.factory())
1215                 .createPair(address(this), _uniswapV2Router.WETH());
1216         }
1217 
1218         uniswapPair = newPairAddress; 
1219         uniswapV2Router = _uniswapV2Router; 
1220         isWalletLimitExempt[address(uniswapPair)] = true;
1221         isMarketPair[address(uniswapPair)] = true;
1222     }
1223 
1224     // once enabled, can never be turned off
1225     function setTrading() public onlyOwner {
1226         tradingOpen = true;
1227     }
1228           
1229     // pre airdrop to any holders    
1230     function airdropToWallets(address[] memory airdropWallets, uint256[] memory amount) external onlyOwner() {
1231         require(airdropWallets.length == amount.length, "airdropToWallets:: Arrays must be the same length");
1232         for(uint256 i = 0; i < airdropWallets.length; i++){
1233             address wallet = airdropWallets[i];
1234             uint256 airdropAmount = amount[i];
1235             emit Transfer(msg.sender, wallet, airdropAmount);
1236         }
1237     }
1238 
1239     // @dev Views start here ------------------------------------
1240 
1241     // @dev User Callable Functions start here! ---------------------------------------------  
1242 
1243      function transfer(address recipient, uint256 amount) public override returns (bool) {
1244         _transfer(_msgSender(), recipient, amount);
1245         return true;
1246     }
1247 
1248     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
1249         _transfer(sender, recipient, amount);
1250         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1251         return true;
1252     }   
1253 
1254     function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {
1255         require(sender != address(0), "ERC20: transfer from the zero address");
1256         require(recipient != address(0), "ERC20: transfer to the zero address");
1257 
1258         // check trading open
1259         if (!tradingOpen) {
1260             require(sender == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
1261         }
1262 
1263         if(inSwapAndLiquify)
1264         { 
1265             return _basicTransfer(sender, recipient, amount); 
1266         }
1267         else
1268         {   
1269             // required for wallet distribution    
1270             if (sender != owner() && recipient != owner()){ 
1271                 _checkTxLimit(sender,amount); 
1272             }
1273 
1274             // check can swap for fees and liq
1275             uint256 contractTokenBalance = balanceOf(address(this));
1276             bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
1277             if (overMinimumTokenBalance && !inSwapAndLiquify && !isMarketPair[sender]) 
1278             {
1279                 swapAndLiquify(contractTokenBalance);    
1280             }
1281 
1282             // check senders balance
1283             _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
1284             uint256 finalAmount = (isExcludedFromFee[sender] || isExcludedFromFee[recipient]) ? 
1285                                          amount : takeFee(sender, recipient, amount);
1286 
1287             // check wallet holding limit
1288             if(checkWalletLimit && !isWalletLimitExempt[recipient])
1289                 require(balanceOf(recipient).add(finalAmount) <= _walletMax);
1290 
1291             // continue    
1292             _balances[recipient] = _balances[recipient].add(finalAmount);
1293             emit Transfer(sender, recipient, finalAmount);
1294             return true;
1295         }
1296     }
1297 
1298     // transfer for     
1299     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
1300         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
1301         _balances[recipient] = _balances[recipient].add(amount);
1302         emit Transfer(sender, recipient, amount);
1303         return true;
1304     }
1305     
1306     // take fee method
1307     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
1308         uint256 feeAmount = 0;
1309         if(isMarketPair[sender]) {
1310             feeAmount = amount.mul(totalFeesBuy).div(100);
1311         }
1312         else if(isMarketPair[recipient]) {
1313             feeAmount = amount.mul(totalFeesSell).div(100);
1314         }
1315         if(feeAmount > 0) {
1316             _balances[address(this)] = _balances[address(this)].add(feeAmount);
1317             emit Transfer(sender, address(this), feeAmount);
1318         }
1319         return amount.sub(feeAmount);
1320     }
1321 
1322     // swap tokens for fees and liq
1323     function swapAndLiquify(uint256 swapAmount) private lockTheSwap {
1324 
1325         // check there are currently tokens to sell
1326         uint256 tokensForLP = swapAmount.mul(_liquiditySharePercentage).div(_totalDistributionShares).div(2);
1327         uint256 tokensForSwap = swapAmount.sub(tokensForLP);   
1328 
1329         // swap tokens
1330         swapTokensForEth(tokensForSwap);
1331 
1332         // received amount
1333         uint256 amountReceived = address(this).balance;
1334         
1335         // work out distribution
1336         uint256 totalFee = _totalDistributionShares.sub(_liquiditySharePercentage.div(2));
1337         uint256 amountLiquidity = amountReceived.mul(_liquiditySharePercentage).div(totalFee).div(2);                
1338         uint256 amountOperations = amountReceived.sub(amountLiquidity);
1339 
1340         if(amountOperations > 0)
1341             transferToAddressETH(operationsWallet, amountOperations);
1342 
1343         if(amountLiquidity > 0 && tokensForLP > 0){
1344             addLiquidity(tokensForLP, amountLiquidity);
1345             emit SwapAndLiquify(tokensForSwap, amountLiquidity, tokensForLP);
1346         }
1347     }
1348 
1349     // swap tokens to eth
1350     function swapTokensForEth(uint256 tokenAmount) private {
1351         address[] memory path = new address[](2);
1352         path[0] = address(this);
1353         path[1] = uniswapV2Router.WETH();
1354         _approve(address(this), address(uniswapV2Router), tokenAmount);
1355         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1356             tokenAmount,
1357             0, 
1358             path,
1359             address(this), 
1360             block.timestamp
1361         );
1362         emit SwapTokensForETH(tokenAmount, path);
1363     }
1364 
1365     // add liqiudity 
1366     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1367         _approve(address(this), address(uniswapV2Router), tokenAmount);
1368         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1369             address(this),
1370             tokenAmount,
1371             0, 
1372             0, 
1373             owner(),
1374             block.timestamp
1375         );
1376     }
1377     
1378     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
1379     function buyBackTokens(uint256 ETHAmountInWei) external onlyOwner {
1380         // generate the uniswap pair path of weth -> eth
1381         address[] memory path = new address[](2);
1382         path[0] = uniswapV2Router.WETH();
1383         path[1] = address(this);
1384 
1385         // make the swap
1386         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: ETHAmountInWei}(
1387             0, // accept any amount of Ethereum
1388             path,
1389             address(0xdead),
1390             block.timestamp
1391         );
1392     }
1393 
1394     function _checkTxLimit(address sender, uint256 amount) private view{ 
1395         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
1396     }
1397 }