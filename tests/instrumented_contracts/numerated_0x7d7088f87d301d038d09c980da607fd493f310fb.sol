1 /**
2  *Submitted for verification at Etherscan.io on 2022-12-21
3 */
4 
5 // https://t.me/SSSPortal
6 // https://twitter.com/SuperSaiyanERC
7 
8 // “Show them what a Saiyan is made of!” 
9 
10 // SPDX-License-Identifier: MIT
11 /**
12 
13 **/ 
14 
15 pragma solidity 0.8.17;
16 
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
28 library Address {
29     function isContract(address account) internal view returns (bool) {
30         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
31         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
32         // for accounts without code, i.e. `keccak256('')`
33         bytes32 codehash;
34         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
35         // solhint-disable-next-line no-inline-assembly
36         assembly { codehash := extcodehash(account) }
37         return (codehash != accountHash && codehash != 0x0);
38     }
39     function sendValue(address payable recipient, uint256 amount) internal {
40         require(address(this).balance >= amount, "Address: insufficient balance");
41         (bool success, ) = recipient.call{ value: amount }("");
42         require(success, "Address: unable to send value, recipient may have reverted");
43     }
44     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
45       return functionCall(target, data, "Address: low-level call failed");
46     }
47     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
48         return _functionCallWithValue(target, data, 0, errorMessage);
49     }
50     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
51         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
52     }
53     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
54         require(address(this).balance >= value, "Address: insufficient balance for call");
55         return _functionCallWithValue(target, data, value, errorMessage);
56     }
57     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
58         require(isContract(target), "Address: call to non-contract");
59         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
60         if (success) {
61             return returndata;
62         } else {
63             if (returndata.length > 0) {
64                 assembly {
65                     let returndata_size := mload(returndata)
66                     revert(add(32, returndata), returndata_size)
67                 }
68             } else {
69                 revert(errorMessage);
70             }
71         }
72     }
73 }
74 
75 contract Ownable is Context {
76     address private _owner;
77 
78     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
79 
80     /**
81      * @dev Initializes the contract setting the deployer as the initial owner.
82      */
83     constructor () {
84         address msgSender = _msgSender();
85         _owner = msgSender;
86         emit OwnershipTransferred(address(0), msgSender);
87     }
88 
89     /**
90      * @dev Returns the address of the current owner.
91      */
92     function owner() public view returns (address) {
93         return _owner;
94     }
95 
96     /**
97      * @dev Throws if called by any account other than the owner.
98      */
99     modifier onlyOwner() {
100         require(_owner == _msgSender(), "Ownable: caller is not the owner");
101         _;
102     }
103 
104     /**
105      * @dev Leaves the contract without owner. It will not be possible to call
106      * `onlyOwner` functions anymore. Can only be called by the current owner.
107      *
108      * NOTE: Renouncing ownership will leave the contract without an owner,
109      * thereby removing any functionality that is only available to the owner.
110      */
111     function renounceOwnership() public virtual onlyOwner {
112         emit OwnershipTransferred(_owner, address(0));
113         _owner = address(0);
114     }
115 
116     /**
117      * @dev Transfers ownership of the contract to a new account (`newOwner`).
118      * Can only be called by the current owner.
119      */
120     function transferOwnership(address newOwner) public virtual onlyOwner {
121         require(newOwner != address(0), "Ownable: new owner is the zero address");
122         emit OwnershipTransferred(_owner, newOwner);
123         _owner = newOwner;
124     }
125 }
126 
127 /**
128  * @dev Interface of the ERC20 standard as defined in the EIP.
129  */
130 interface IERC20 {
131     /**
132      * @dev Returns the amount of tokens in existence.
133      */
134     function totalSupply() external view returns (uint256);
135 
136     /**
137      * @dev Returns the amount of tokens owned by `account`.
138      */
139     function balanceOf(address account) external view returns (uint256);
140 
141     /**
142      * @dev Moves `amount` tokens from the caller's account to `recipient`.
143      *
144      * Returns a boolean value indicating whether the operation succeeded.
145      *
146      * Emits a {Transfer} event.
147      */
148     function transfer(address recipient, uint256 amount) external returns (bool);
149 
150     /**
151      * @dev Returns the remaining number of tokens that `spender` will be
152      * allowed to spend on behalf of `owner` through {transferFrom}. This is
153      * zero by default.
154      *
155      * This value changes when {approve} or {transferFrom} are called.
156      */
157     function allowance(address owner, address spender) external view returns (uint256);
158 
159     /**
160      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
161      *
162      * Returns a boolean value indicating whether the operation succeeded.
163      *
164      * IMPORTANT: Beware that changing an allowance with this method brings the risk
165      * that someone may use both the old and the new allowance by unfortunate
166      * transaction ordering. One possible solution to mitigate this race
167      * condition is to first reduce the spender's allowance to 0 and set the
168      * desired value afterwards:
169      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
170      *
171      * Emits an {Approval} event.
172      */
173     function approve(address spender, uint256 amount) external returns (bool);
174 
175     /**
176      * @dev Moves `amount` tokens from `sender` to `recipient` using the
177      * allowance mechanism. `amount` is then deducted from the caller's
178      * allowance.
179      *
180      * Returns a boolean value indicating whether the operation succeeded.
181      *
182      * Emits a {Transfer} event.
183      */
184     function transferFrom(
185         address sender,
186         address recipient,
187         uint256 amount
188     ) external returns (bool);
189 
190     /**
191      * @dev Emitted when `value` tokens are moved from one account (`from`) to
192      * another (`to`).
193      *
194      * Note that `value` may be zero.
195      */
196     event Transfer(address indexed from, address indexed to, uint256 value);
197 
198     /**
199      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
200      * a call to {approve}. `value` is the new allowance.
201      */
202     event Approval(address indexed owner, address indexed spender, uint256 value);
203 }
204 
205 /**
206  * @dev Interface for the optional metadata functions from the ERC20 standard.
207  *
208  * _Available since v4.1._
209  */
210 interface IERC20Metadata is IERC20 {
211     /**
212      * @dev Returns the name of the token.
213      */
214     function name() external view returns (string memory);
215 
216     /**
217      * @dev Returns the symbol of the token.
218      */
219     function symbol() external view returns (string memory);
220 
221     /**
222      * @dev Returns the decimals places of the token.
223      */
224     function decimals() external view returns (uint8);
225 } 
226 
227 // Safe Math Helpers 
228 // --------------------------------------------------------------
229 library SafeMath {
230     /**
231      * @dev Returns the addition of two unsigned integers, reverting on
232      * overflow.
233      *
234      * Counterpart to Solidity's `+` operator.
235      *
236      * Requirements:
237      *
238      * - Addition cannot overflow.
239      */
240     function add(uint256 a, uint256 b) internal pure returns (uint256) {
241         uint256 c = a + b;
242         require(c >= a, "SafeMath: addition overflow");
243 
244         return c;
245     }
246 
247     /**
248      * @dev Returns the subtraction of two unsigned integers, reverting on
249      * overflow (when the result is negative).
250      *
251      * Counterpart to Solidity's `-` operator.
252      *
253      * Requirements:
254      *
255      * - Subtraction cannot overflow.
256      */
257     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
258         return sub(a, b, "SafeMath: subtraction overflow");
259     }
260 
261     /**
262      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
263      * overflow (when the result is negative).
264      *
265      * Counterpart to Solidity's `-` operator.
266      *
267      * Requirements:
268      *
269      * - Subtraction cannot overflow.
270      */
271     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
272         require(b <= a, errorMessage);
273         uint256 c = a - b;
274 
275         return c;
276     }
277 
278     /**
279      * @dev Returns the multiplication of two unsigned integers, reverting on
280      * overflow.
281      *
282      * Counterpart to Solidity's `*` operator.
283      *
284      * Requirements:
285      *
286      * - Multiplication cannot overflow.
287      */
288     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
289         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
290         // benefit is lost if 'b' is also tested.
291         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
292         if (a == 0) {
293             return 0;
294         }
295 
296         uint256 c = a * b;
297         require(c / a == b, "SafeMath: multiplication overflow");
298 
299         return c;
300     }
301 
302     /**
303      * @dev Returns the integer division of two unsigned integers. Reverts on
304      * division by zero. The result is rounded towards zero.
305      *
306      * Counterpart to Solidity's `/` operator. Note: this function uses a
307      * `revert` opcode (which leaves remaining gas untouched) while Solidity
308      * uses an invalid opcode to revert (consuming all remaining gas).
309      *
310      * Requirements:
311      *
312      * - The divisor cannot be zero.
313      */
314     function div(uint256 a, uint256 b) internal pure returns (uint256) {
315         return div(a, b, "SafeMath: division by zero");
316     }
317 
318     /**
319      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
320      * division by zero. The result is rounded towards zero.
321      *
322      * Counterpart to Solidity's `/` operator. Note: this function uses a
323      * `revert` opcode (which leaves remaining gas untouched) while Solidity
324      * uses an invalid opcode to revert (consuming all remaining gas).
325      *
326      * Requirements:
327      *
328      * - The divisor cannot be zero.
329      */
330     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
331         require(b > 0, errorMessage);
332         uint256 c = a / b;
333         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
334 
335         return c;
336     }
337 
338     /**
339      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
340      * Reverts when dividing by zero.
341      *
342      * Counterpart to Solidity's `%` operator. This function uses a `revert`
343      * opcode (which leaves remaining gas untouched) while Solidity uses an
344      * invalid opcode to revert (consuming all remaining gas).
345      *
346      * Requirements:
347      *
348      * - The divisor cannot be zero.
349      */
350     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
351         return mod(a, b, "SafeMath: modulo by zero");
352     }
353 
354     /**
355      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
356      * Reverts with custom message when dividing by zero.
357      *
358      * Counterpart to Solidity's `%` operator. This function uses a `revert`
359      * opcode (which leaves remaining gas untouched) while Solidity uses an
360      * invalid opcode to revert (consuming all remaining gas).
361      *
362      * Requirements:
363      *
364      * - The divisor cannot be zero.
365      */
366     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
367         require(b != 0, errorMessage);
368         return a % b;
369     }
370 }
371 
372 contract ERC20 is Context, IERC20, IERC20Metadata {
373     using SafeMath for uint256;
374 
375     mapping(address => uint256) private _balances;
376     mapping(address => mapping(address => uint256)) private _allowances;
377 
378     uint256 private _totalSupply;
379     string private _name;
380     string private _symbol;
381     uint8 private _decimals;
382 
383     /**
384      * @dev Sets the values for {name} and {symbol}.
385      *
386      * The default value of {decimals} is 18. To select a different value for
387      * {decimals} you should overload it.
388      *
389      * All two of these values are immutable: they can only be set once during
390      * construction.
391      */
392     constructor(string memory name_, string memory symbol_, uint8 decimals_) {
393         _name = name_;
394         _symbol = symbol_;
395         _decimals = decimals_;
396     }
397 
398     /**
399      * @dev Returns the name of the token.
400      */
401     function name() public view virtual override returns (string memory) {
402         return _name;
403     }
404 
405     /**
406      * @dev Returns the symbol of the token, usually a shorter version of the
407      * name.
408      */
409     function symbol() public view virtual override returns (string memory) {
410         return _symbol;
411     }
412 
413     /**
414      * @dev Returns the number of decimals used to get its user representation.
415      * For example, if `decimals` equals `2`, a balance of `505` tokens should
416      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
417      *
418      * Tokens usually opt for a value of 18, imitating the relationship between
419      * Ether and Wei. This is the value {ERC20} uses, unless this function is
420      * overridden;
421      *
422      * NOTE: This information is only used for _display_ purposes: it in
423      * no way affects any of the arithmetic of the contract, including
424      * {IERC20-balanceOf} and {IERC20-transfer}.
425      */
426     function decimals() public view virtual override returns (uint8) {
427         return _decimals;
428     }
429 
430     /**
431      * @dev See {IERC20-totalSupply}.
432      */
433     function totalSupply() public view virtual override returns (uint256) {
434         return _totalSupply;
435     }
436 
437     /**
438      * @dev See {IERC20-balanceOf}.
439      */
440     function balanceOf(address account) public view virtual override returns (uint256) {
441         return _balances[account];
442     }
443 
444     /**
445      * @dev See {IERC20-transfer}.
446      *
447      * Requirements:
448      *
449      * - `recipient` cannot be the zero address.
450      * - the caller must have a balance of at least `amount`.
451      */
452     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
453         _transfer(_msgSender(), recipient, amount);
454         return true;
455     }
456 
457     /**
458      * @dev See {IERC20-allowance}.
459      */
460     function allowance(address owner, address spender) public view virtual override returns (uint256) {
461         return _allowances[owner][spender];
462     }
463 
464     /**
465      * @dev See {IERC20-approve}.
466      *
467      * Requirements:
468      *
469      * - `spender` cannot be the zero address.
470      */
471     function approve(address spender, uint256 amount) public virtual override returns (bool) {
472         _approve(_msgSender(), spender, amount);
473         return true;
474     }
475 
476     /**
477      * @dev See {IERC20-transferFrom}.
478      *
479      * Emits an {Approval} event indicating the updated allowance. This is not
480      * required by the EIP. See the note at the beginning of {ERC20}.
481      *
482      * Requirements:
483      *
484      * - `sender` and `recipient` cannot be the zero address.
485      * - `sender` must have a balance of at least `amount`.
486      * - the caller must have allowance for ``sender``'s tokens of at least
487      * `amount`.
488      */
489     function transferFrom(
490         address sender,
491         address recipient,
492         uint256 amount
493     ) public virtual override returns (bool) {
494         _transfer(sender, recipient, amount);
495         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
496         return true;
497     }
498 
499     /**
500      * @dev Atomically increases the allowance granted to `spender` by the caller.
501      *
502      * This is an alternative to {approve} that can be used as a mitigation for
503      * problems described in {IERC20-approve}.
504      *
505      * Emits an {Approval} event indicating the updated allowance.
506      *
507      * Requirements:
508      *
509      * - `spender` cannot be the zero address.
510      */
511     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
512         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
513         return true;
514     }
515 
516     /**
517      * @dev Atomically decreases the allowance granted to `spender` by the caller.
518      *
519      * This is an alternative to {approve} that can be used as a mitigation for
520      * problems described in {IERC20-approve}.
521      *
522      * Emits an {Approval} event indicating the updated allowance.
523      *
524      * Requirements:
525      *
526      * - `spender` cannot be the zero address.
527      * - `spender` must have allowance for the caller of at least
528      * `subtractedValue`.
529      */
530     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
531         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
532         return true;
533     }
534 
535     /**
536      * @dev Moves tokens `amount` from `sender` to `recipient`.
537      *
538      * This is internal function is equivalent to {transfer}, and can be used to
539      * e.g. implement automatic token fees, slashing mechanisms, etc.
540      *
541      * Emits a {Transfer} event.
542      *
543      * Requirements:
544      *
545      * - `sender` cannot be the zero address.
546      * - `recipient` cannot be the zero address.
547      * - `sender` must have a balance of at least `amount`.
548      */
549     function _transfer(
550         address sender,
551         address recipient,
552         uint256 amount
553     ) internal virtual {
554         require(sender != address(0), "ERC20: transfer from the zero address");
555         require(recipient != address(0), "ERC20: transfer to the zero address");
556 
557         _beforeTokenTransfer(sender, recipient, amount);
558 
559         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
560         _balances[recipient] = _balances[recipient].add(amount);
561         emit Transfer(sender, recipient, amount);
562     }
563 
564     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
565      * the total supply.
566      *
567      * Emits a {Transfer} event with `from` set to the zero address.
568      *
569      * Requirements:
570      *
571      * - `account` cannot be the zero address.
572      */
573     function _createInitialSupply(address account, uint256 amount) internal virtual {
574         require(account != address(0), "ERC20: cannot send to the zero address");
575 
576         _beforeTokenTransfer(address(0), account, amount);
577 
578         _totalSupply = _totalSupply.add(amount);
579         _balances[account] = _balances[account].add(amount);
580         emit Transfer(address(0), account, amount);
581     }
582 
583     /**
584      * @dev Destroys `amount` tokens from `account`, reducing the
585      * total supply.
586      *
587      * Emits a {Transfer} event with `to` set to the zero address.
588      *
589      * Requirements:
590      *
591      * - `account` cannot be the zero address.
592      * - `account` must have at least `amount` tokens.
593      */
594     function _burn(address account, uint256 amount) internal virtual {
595         require(account != address(0), "ERC20: burn from the zero address");
596 
597         _beforeTokenTransfer(account, address(0), amount);
598 
599         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
600         _totalSupply = _totalSupply.sub(amount);
601         emit Transfer(account, address(0), amount);
602     }
603 
604     /**
605      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
606      *
607      * This internal function is equivalent to `approve`, and can be used to
608      * e.g. set automatic allowances for certain subsystems, etc.
609      *
610      * Emits an {Approval} event.
611      *
612      * Requirements:
613      *
614      * - `owner` cannot be the zero address.
615      * - `spender` cannot be the zero address.
616      */
617     function _approve(
618         address owner,
619         address spender,
620         uint256 amount
621     ) internal virtual {
622         require(owner != address(0), "ERC20: approve from the zero address");
623         require(spender != address(0), "ERC20: approve to the zero address");
624 
625         _allowances[owner][spender] = amount;
626         emit Approval(owner, spender, amount);
627     }
628 
629     function _beforeTokenTransfer(
630         address from,
631         address to,
632         uint256 amount
633     ) internal virtual {}
634 }
635 
636 // Uniswap Router 
637 // --------------------------------------------------------------
638 interface IUniswapV2Factory {
639     event PairCreated(
640         address indexed token0,
641         address indexed token1,
642         address pair,
643         uint256
644     );
645     function feeTo() external view returns (address);
646     function feeToSetter() external view returns (address);
647     function allPairsLength() external view returns (uint256);
648     function getPair(address tokenA, address tokenB)
649         external
650         view
651         returns (address pair);
652     function allPairs(uint256) external view returns (address pair);
653     function createPair(address tokenA, address tokenB)
654         external
655         returns (address pair);
656     function setFeeTo(address) external;
657     function setFeeToSetter(address) external;
658 }
659 interface IUniswapV2Pair {
660     event Approval(
661         address indexed owner,
662         address indexed spender,
663         uint256 value
664     );
665     event Transfer(address indexed from, address indexed to, uint256 value);
666     function name() external pure returns (string memory);
667     function symbol() external pure returns (string memory);
668     function decimals() external pure returns (uint8);
669     function totalSupply() external view returns (uint256);
670     function balanceOf(address owner) external view returns (uint256);
671     function allowance(address owner, address spender)
672         external
673         view
674         returns (uint256);
675     function approve(address spender, uint256 value) external returns (bool);
676     function transfer(address to, uint256 value) external returns (bool);
677     function transferFrom(
678         address from,
679         address to,
680         uint256 value
681     ) external returns (bool);
682     function DOMAIN_SEPARATOR() external view returns (bytes32);
683     function PERMIT_TYPEHASH() external pure returns (bytes32);
684     function nonces(address owner) external view returns (uint256);
685     function permit(
686         address owner,
687         address spender,
688         uint256 value,
689         uint256 deadline,
690         uint8 v,
691         bytes32 r,
692         bytes32 s
693     ) external;
694     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
695     event Burn(
696         address indexed sender,
697         uint256 amount0,
698         uint256 amount1,
699         address indexed to
700     );
701     event Swap(
702         address indexed sender,
703         uint256 amount0In,
704         uint256 amount1In,
705         uint256 amount0Out,
706         uint256 amount1Out,
707         address indexed to
708     );
709     event Sync(uint112 reserve0, uint112 reserve1);
710     function MINIMUM_LIQUIDITY() external pure returns (uint256);
711     function factory() external view returns (address);
712     function token0() external view returns (address);
713     function token1() external view returns (address);
714     function getReserves()
715         external
716         view
717         returns (
718             uint112 reserve0,
719             uint112 reserve1,
720             uint32 blockTimestampLast
721         );
722     function price0CumulativeLast() external view returns (uint256);
723     function price1CumulativeLast() external view returns (uint256);
724     function kLast() external view returns (uint256);
725     function mint(address to) external returns (uint256 liquidity);
726     function burn(address to)
727         external
728         returns (uint256 amount0, uint256 amount1);
729     function swap(
730         uint256 amount0Out,
731         uint256 amount1Out,
732         address to,
733         bytes calldata data
734     ) external;
735     function skim(address to) external;
736     function sync() external;
737     function initialize(address, address) external;
738 }
739 interface IUniswapV2Router01 {
740     function factory() external pure returns (address);
741     function WETH() external pure returns (address);
742     function addLiquidity(
743         address tokenA,
744         address tokenB,
745         uint256 amountADesired,
746         uint256 amountBDesired,
747         uint256 amountAMin,
748         uint256 amountBMin,
749         address to,
750         uint256 deadline
751     )
752         external
753         returns (
754             uint256 amountA,
755             uint256 amountB,
756             uint256 liquidity
757         );
758     function addLiquidityETH(
759         address token,
760         uint256 amountTokenDesired,
761         uint256 amountTokenMin,
762         uint256 amountETHMin,
763         address to,
764         uint256 deadline
765     )
766         external
767         payable
768         returns (
769             uint256 amountToken,
770             uint256 amountETH,
771             uint256 liquidity
772         );
773     function removeLiquidity(
774         address tokenA,
775         address tokenB,
776         uint256 liquidity,
777         uint256 amountAMin,
778         uint256 amountBMin,
779         address to,
780         uint256 deadline
781     ) external returns (uint256 amountA, uint256 amountB);
782     function removeLiquidityETH(
783         address token,
784         uint256 liquidity,
785         uint256 amountTokenMin,
786         uint256 amountETHMin,
787         address to,
788         uint256 deadline
789     ) external returns (uint256 amountToken, uint256 amountETH);
790     function removeLiquidityWithPermit(
791         address tokenA,
792         address tokenB,
793         uint256 liquidity,
794         uint256 amountAMin,
795         uint256 amountBMin,
796         address to,
797         uint256 deadline,
798         bool approveMax,
799         uint8 v,
800         bytes32 r,
801         bytes32 s
802     ) external returns (uint256 amountA, uint256 amountB);
803     function removeLiquidityETHWithPermit(
804         address token,
805         uint256 liquidity,
806         uint256 amountTokenMin,
807         uint256 amountETHMin,
808         address to,
809         uint256 deadline,
810         bool approveMax,
811         uint8 v,
812         bytes32 r,
813         bytes32 s
814     ) external returns (uint256 amountToken, uint256 amountETH);
815     function swapExactTokensForTokens(
816         uint256 amountIn,
817         uint256 amountOutMin,
818         address[] calldata path,
819         address to,
820         uint256 deadline
821     ) external returns (uint256[] memory amounts);
822     function swapTokensForExactTokens(
823         uint256 amountOut,
824         uint256 amountInMax,
825         address[] calldata path,
826         address to,
827         uint256 deadline
828     ) external returns (uint256[] memory amounts);
829     function swapExactETHForTokens(
830         uint256 amountOutMin,
831         address[] calldata path,
832         address to,
833         uint256 deadline
834     ) external payable returns (uint256[] memory amounts);
835     function swapTokensForExactETH(
836         uint256 amountOut,
837         uint256 amountInMax,
838         address[] calldata path,
839         address to,
840         uint256 deadline
841     ) external returns (uint256[] memory amounts);
842     function swapExactTokensForETH(
843         uint256 amountIn,
844         uint256 amountOutMin,
845         address[] calldata path,
846         address to,
847         uint256 deadline
848     ) external returns (uint256[] memory amounts);
849     function swapETHForExactTokens(
850         uint256 amountOut,
851         address[] calldata path,
852         address to,
853         uint256 deadline
854     ) external payable returns (uint256[] memory amounts);
855     function quote(
856         uint256 amountA,
857         uint256 reserveA,
858         uint256 reserveB
859     ) external pure returns (uint256 amountB);
860     function getAmountOut(
861         uint256 amountIn,
862         uint256 reserveIn,
863         uint256 reserveOut
864     ) external pure returns (uint256 amountOut);
865     function getAmountIn(
866         uint256 amountOut,
867         uint256 reserveIn,
868         uint256 reserveOut
869     ) external pure returns (uint256 amountIn);
870     function getAmountsOut(uint256 amountIn, address[] calldata path)
871         external
872         view
873         returns (uint256[] memory amounts);
874     function getAmountsIn(uint256 amountOut, address[] calldata path)
875         external
876         view
877         returns (uint256[] memory amounts);
878 }
879 interface IUniswapV2Router02 is IUniswapV2Router01 {
880     function removeLiquidityETHSupportingFeeOnTransferTokens(
881         address token,
882         uint256 liquidity,
883         uint256 amountTokenMin,
884         uint256 amountETHMin,
885         address to,
886         uint256 deadline
887     ) external returns (uint256 amountETH);
888     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
889         address token,
890         uint256 liquidity,
891         uint256 amountTokenMin,
892         uint256 amountETHMin,
893         address to,
894         uint256 deadline,
895         bool approveMax,
896         uint8 v,
897         bytes32 r,
898         bytes32 s
899     ) external returns (uint256 amountETH);
900     function swapExactETHForTokensSupportingFeeOnTransferTokens(
901         uint256 amountOutMin,
902         address[] calldata path,
903         address to,
904         uint256 deadline
905     ) external payable;
906     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
907         uint256 amountIn,
908         uint256 amountOutMin,
909         address[] calldata path,
910         address to,
911         uint256 deadline
912     ) external;
913     function swapExactTokensForETHSupportingFeeOnTransferTokens(
914         uint256 amountIn,
915         uint256 amountOutMin,
916         address[] calldata path,
917         address to,
918         uint256 deadline
919     ) external;
920 }
921 
922 
923 // Main Contract Logic 
924 // --------------------------------------------------------------
925 contract SuperSaiyan is Context, IERC20, Ownable {
926     // Imports
927     using SafeMath for uint256;
928     using Address for address;
929 
930     // Configurables -----------------------------
931     
932     // Context";
933     string private _name = "Super Saiyan";
934     string private _symbol = "SS";
935     uint8 private _decimals = 18;
936 
937     // Supply 
938     uint256 private _totalSupply = 1 * 1e6 * 1e18;    
939     uint256 private minimumTokensBeforeSwap = _totalSupply * 1 / 500;    
940 
941     // Restrictions
942     uint256 public _maxTxAmount = (_totalSupply * 30) / 1000;      
943     uint256 public _walletMax = (_totalSupply * 30) / 1000; 
944     bool public checkWalletLimit = true;
945     
946     // wallets
947     address payable public liquidityWallet = payable(0x527a0eEdf4cFC50344CC007E838A2cfFAAd819Ce);
948     address payable public operationsWallet =  payable(0x527a0eEdf4cFC50344CC007E838A2cfFAAd819Ce);
949     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
950     
951     // fees    
952     uint256 public liquidityFeeBuy = 0;
953     uint256 public operationsFeeBuy = 3;
954     uint256 public totalFeesBuy;
955     uint256 public maxTotalFeeBuy = 10;
956 
957     // fees
958     uint256 public liquidityFeeSell = 0;
959     uint256 public operationsFeeSell = 35;
960     uint256 public totalFeesSell;
961     uint256 public maxTotalFeeSell = 99;
962 
963     // distribution ratio
964     uint256 public _liquiditySharePercentage = 0;
965     uint256 public _operationsSharePercentage = 100;
966     uint256 public _totalDistributionShares;
967 
968     // max amounts    
969     mapping (address => uint256) _balances;
970     mapping (address => mapping (address => uint256)) private _allowances;
971     mapping (address => bool) public isExcludedFromFee;
972     mapping (address => bool) public isWalletLimitExempt;
973     mapping (address => bool) isTxLimitExempt;
974 
975     // Router Information    
976     mapping (address => bool) public isMarketPair;
977     IUniswapV2Router02 public uniswapV2Router;
978     address public uniswapPair; 
979     
980     // toggle swap back (fees)
981     bool inSwapAndLiquify;
982     uint256 public tokensForLiquidity;
983     uint256 public tokensForOperations;    
984 
985     // Launch Settings
986     bool public tradingOpen = true;    
987 
988     // events    
989     event LiquidityWalletUpdated(address indexed newLiquidityWallet, address indexed oldLiquidityWallet);
990     event OperationsWalletUpdated(address indexed newOperationsWallet, address indexed oldOperationsWallet); 
991     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiqudity); 
992     event SwapTokensForETH(uint256 amountIn, address[] path);
993     
994     // toogle to stop swap if already underway
995     modifier lockTheSwap {
996         inSwapAndLiquify = true;
997         _;
998         inSwapAndLiquify = false;
999     }
1000 
1001     constructor () {
1002 
1003         // load total fees 
1004         totalFeesBuy = operationsFeeBuy + liquidityFeeBuy;
1005         totalFeesSell = operationsFeeSell + liquidityFeeSell; 
1006 
1007         // load total distribution 
1008         _totalDistributionShares = _liquiditySharePercentage + _operationsSharePercentage;
1009         
1010         // create router ------------------------------
1011         IUniswapV2Router02 _uniswapV2Router;
1012         if (block.chainid == 1) {
1013             _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1014         } else if (block.chainid == 5) {
1015             _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1016         } else revert();
1017 
1018          // Create a uniswap pair for this new token         
1019         uniswapPair = IUniswapV2Factory(_uniswapV2Router.factory())
1020             .createPair(address(this), _uniswapV2Router.WETH());
1021         uniswapV2Router = _uniswapV2Router; 
1022         isMarketPair[address(uniswapPair)] = true;
1023 
1024         // set allowances        
1025         _allowances[address(this)][address(uniswapV2Router)] = _totalSupply;
1026         
1027         // exclude from paying fees or having max transaction amount
1028         isExcludedFromFee[owner()] = true;
1029         isExcludedFromFee[address(this)] = true;
1030         isExcludedFromFee[address(0xdead)] = true; 
1031         isExcludedFromFee[liquidityWallet] = true; 
1032         isExcludedFromFee[operationsWallet] = true; 
1033         
1034         // exclude contracts from max wallet size
1035         isWalletLimitExempt[owner()] = true;
1036         isWalletLimitExempt[address(uniswapPair)] = true;
1037         isWalletLimitExempt[address(this)] = true;
1038         isWalletLimitExempt[liquidityWallet] = true; 
1039         isWalletLimitExempt[operationsWallet] = true; 
1040         
1041         // exclude contracts from max wallet size
1042         isTxLimitExempt[owner()] = true;
1043         isTxLimitExempt[address(this)] = true;
1044         
1045         _balances[_msgSender()] = _totalSupply;   
1046         emit Transfer(address(0), _msgSender(), _totalSupply);  
1047     }
1048 
1049     receive() external payable {
1050 
1051   	}
1052   	
1053   	// @dev Public read functions start -------------------------------------
1054     function name() public view returns (string memory) {
1055         return _name;
1056     }
1057 
1058     function symbol() public view returns (string memory) {
1059         return _symbol;
1060     }
1061 
1062     function decimals() public view returns (uint8) {
1063         return _decimals;
1064     }
1065 
1066     function totalSupply() public view override returns (uint256) {
1067         return _totalSupply;
1068     }
1069 
1070     function balanceOf(address account) public view override returns (uint256) {
1071         return _balances[account];
1072     }
1073 
1074     // custom allowance methods
1075     function allowance(address owner, address spender) public view override returns (uint256) {
1076         return _allowances[owner][spender];
1077     }
1078     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1079         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1080         return true;
1081     }
1082     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1083         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1084         return true;
1085     }
1086     
1087     // get minimum tokens before swap
1088     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
1089         return minimumTokensBeforeSwap;
1090     }
1091 
1092     // approve spending methods
1093     function approve(address spender, uint256 amount) public override returns (bool) {
1094         _approve(_msgSender(), spender, amount);
1095         return true;
1096     }
1097     function _approve(address owner, address spender, uint256 amount) private {
1098         require(owner != address(0), "ERC20: approve from the zero address");
1099         require(spender != address(0), "ERC20: approve to the zero address");
1100         _allowances[owner][spender] = amount;
1101         emit Approval(owner, spender, amount);
1102     }
1103     
1104     function getCirculatingSupply() public view returns (uint256) {
1105         return _totalSupply.sub(balanceOf(deadAddress));
1106     }
1107     
1108     function getBlock()public view returns (uint256) {
1109         return block.number;
1110     }
1111 
1112   	// @dev Owner functions start -------------------------------------
1113     
1114     // toogle market pair status
1115     function setMarketPairStatus(address account, bool newValue) public onlyOwner {
1116         isMarketPair[account] = newValue;
1117     }
1118 
1119     // set excluded xx limit 
1120     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
1121         isTxLimitExempt[holder] = exempt;
1122     }
1123 
1124     // update max tx amount
1125     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1126         _maxTxAmount = maxTxAmount;
1127     }
1128 
1129     // set excluded tax 
1130     function setIsExcludedFromFee(address account, bool newValue) public onlyOwner {
1131         isExcludedFromFee[account] = newValue;
1132     }
1133     
1134     // update fees
1135     function updateFees(uint256 _operationsFee, uint256 _liquidityFee) external onlyOwner {
1136         operationsFeeBuy = _operationsFee;
1137         liquidityFeeBuy = _liquidityFee;
1138         totalFeesBuy = operationsFeeBuy + liquidityFeeBuy;
1139         require(totalFeesBuy <= maxTotalFeeBuy, "Must keep fees at maxTotalFeeBuy or less");
1140     }
1141 
1142     function updateFeesSell(uint256 _operationsFee, uint256 _liquidityFee) external onlyOwner {
1143         operationsFeeSell = _operationsFee;
1144         liquidityFeeSell = _liquidityFee;
1145         totalFeesSell = operationsFeeSell + liquidityFeeSell;
1146         require(totalFeesSell <= maxTotalFeeSell, "Must keep fees at maxTotalFeeSell or less");
1147     }
1148     
1149     // set distribution settings
1150     function setDistributionSettings(uint256 newLiquidityShare, uint256 newOperationsShare) external onlyOwner() {
1151         _liquiditySharePercentage = newLiquidityShare;
1152         _operationsSharePercentage = newOperationsShare; 
1153         _totalDistributionShares = _liquiditySharePercentage + _operationsSharePercentage;
1154         require(_totalDistributionShares == 100, "Distribution needs to total to 100");
1155     }
1156 
1157     // remove wallet limit
1158     function enableDisableWalletLimit(bool newValue) external onlyOwner {
1159        checkWalletLimit = newValue;
1160     }
1161     
1162     // set excluded wallet limit 
1163     function setIsWalletLimitExempt(address holder, bool exempt) external onlyOwner {
1164         isWalletLimitExempt[holder] = exempt;
1165     }
1166     
1167     // update wallet limit
1168     function setWalletLimit(uint256 newLimit) external onlyOwner {
1169         _walletMax  = newLimit;
1170     }
1171     
1172     // change the minimum amount of tokens to sell from fees
1173     function setNumTokensBeforeSwap(uint256 newLimit) external onlyOwner() {
1174         minimumTokensBeforeSwap = newLimit;
1175     }
1176 
1177     // sets the wallet that receives LP tokens to lock
1178     function updateLiquidityWallet(address newAddress) external onlyOwner {
1179         require(newAddress != address(0), "Cannot set to address 0");
1180         isExcludedFromFee[newAddress] = true;
1181         isExcludedFromFee[liquidityWallet] = false;
1182         emit LiquidityWalletUpdated(newAddress, liquidityWallet);
1183         liquidityWallet =  payable(newAddress);
1184     }
1185     
1186     // updates the operations wallet (marketing, charity, etc.)
1187     function updateOperationsWallet(address newAddress) external onlyOwner {
1188         require(newAddress != address(0), "Cannot set to address 0");
1189         isExcludedFromFee[newAddress] = true;
1190         isExcludedFromFee[operationsWallet] = false;
1191         emit OperationsWalletUpdated(newAddress, operationsWallet);
1192         operationsWallet = payable(newAddress);
1193     }    
1194 
1195     // transfer amount to address
1196     function transferToAddressETH(address payable recipient, uint256 amount) private {
1197         recipient.transfer(amount);
1198     }
1199 
1200     // change router address
1201     function changeRouterAddress(address newRouterAddress) public onlyOwner returns(address newPairAddress) {
1202 
1203         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(newRouterAddress); 
1204         newPairAddress = IUniswapV2Factory(_uniswapV2Router.factory()).getPair(address(this), _uniswapV2Router.WETH());
1205 
1206         // check if new pair deployed
1207         if(newPairAddress == address(0)) 
1208         {
1209             newPairAddress = IUniswapV2Factory(_uniswapV2Router.factory())
1210                 .createPair(address(this), _uniswapV2Router.WETH());
1211         }
1212 
1213         uniswapPair = newPairAddress; 
1214         uniswapV2Router = _uniswapV2Router; 
1215         isWalletLimitExempt[address(uniswapPair)] = true;
1216         isMarketPair[address(uniswapPair)] = true;
1217     }
1218 
1219     // once enabled, can never be turned off
1220     function setTrading() public onlyOwner {
1221         tradingOpen = true;
1222     }
1223           
1224     // pre airdrop to any holders    
1225     function airdropToWallets(address[] memory airdropWallets, uint256[] memory amount) external onlyOwner() {
1226         require(airdropWallets.length == amount.length, "airdropToWallets:: Arrays must be the same length");
1227         for(uint256 i = 0; i < airdropWallets.length; i++){
1228             address wallet = airdropWallets[i];
1229             uint256 airdropAmount = amount[i];
1230             emit Transfer(msg.sender, wallet, airdropAmount);
1231         }
1232     }
1233 
1234     // @dev Views start here ------------------------------------
1235 
1236     // @dev User Callable Functions start here! ---------------------------------------------  
1237 
1238      function transfer(address recipient, uint256 amount) public override returns (bool) {
1239         _transfer(_msgSender(), recipient, amount);
1240         return true;
1241     }
1242 
1243     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
1244         _transfer(sender, recipient, amount);
1245         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1246         return true;
1247     }   
1248 
1249     function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {
1250         require(sender != address(0), "ERC20: transfer from the zero address");
1251         require(recipient != address(0), "ERC20: transfer to the zero address");
1252 
1253         // check trading open
1254         if (!tradingOpen) {
1255             require(sender == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
1256         }
1257 
1258         if(inSwapAndLiquify)
1259         { 
1260             return _basicTransfer(sender, recipient, amount); 
1261         }
1262         else
1263         {   
1264             // required for wallet distribution    
1265             if (sender != owner() && recipient != owner()){ 
1266                 _checkTxLimit(sender,amount); 
1267             }
1268 
1269             // check can swap for fees and liq
1270             uint256 contractTokenBalance = balanceOf(address(this));
1271             bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
1272             if (overMinimumTokenBalance && !inSwapAndLiquify && !isMarketPair[sender]) 
1273             {
1274                 swapAndLiquify(contractTokenBalance);    
1275             }
1276 
1277             // check senders balance
1278             _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
1279             uint256 finalAmount = (isExcludedFromFee[sender] || isExcludedFromFee[recipient]) ? 
1280                                          amount : takeFee(sender, recipient, amount);
1281 
1282             // check wallet holding limit
1283             if(checkWalletLimit && !isWalletLimitExempt[recipient])
1284                 require(balanceOf(recipient).add(finalAmount) <= _walletMax);
1285 
1286             // continue    
1287             _balances[recipient] = _balances[recipient].add(finalAmount);
1288             emit Transfer(sender, recipient, finalAmount);
1289             return true;
1290         }
1291     }
1292 
1293     // transfer for     
1294     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
1295         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
1296         _balances[recipient] = _balances[recipient].add(amount);
1297         emit Transfer(sender, recipient, amount);
1298         return true;
1299     }
1300     
1301     // take fee method
1302     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
1303         uint256 feeAmount = 0;
1304         if(isMarketPair[sender]) {
1305             feeAmount = amount.mul(totalFeesBuy).div(100);
1306         }
1307         else if(isMarketPair[recipient]) {
1308             feeAmount = amount.mul(totalFeesSell).div(100);
1309         }
1310         if(feeAmount > 0) {
1311             _balances[address(this)] = _balances[address(this)].add(feeAmount);
1312             emit Transfer(sender, address(this), feeAmount);
1313         }
1314         return amount.sub(feeAmount);
1315     }
1316 
1317     // swap tokens for fees and liq
1318     function swapAndLiquify(uint256 swapAmount) private lockTheSwap {
1319 
1320         // check there are currently tokens to sell
1321         uint256 tokensForLP = swapAmount.mul(_liquiditySharePercentage).div(_totalDistributionShares).div(2);
1322         uint256 tokensForSwap = swapAmount.sub(tokensForLP);   
1323 
1324         // swap tokens
1325         swapTokensForEth(tokensForSwap);
1326 
1327         // received amount
1328         uint256 amountReceived = address(this).balance;
1329         
1330         // work out distribution
1331         uint256 totalFee = _totalDistributionShares.sub(_liquiditySharePercentage.div(2));
1332         uint256 amountLiquidity = amountReceived.mul(_liquiditySharePercentage).div(totalFee).div(2);                
1333         uint256 amountOperations = amountReceived.sub(amountLiquidity);
1334 
1335         if(amountOperations > 0)
1336             transferToAddressETH(operationsWallet, amountOperations);
1337 
1338         if(amountLiquidity > 0 && tokensForLP > 0){
1339             addLiquidity(tokensForLP, amountLiquidity);
1340             emit SwapAndLiquify(tokensForSwap, amountLiquidity, tokensForLP);
1341         }
1342     }
1343 
1344     // swap tokens to eth
1345     function swapTokensForEth(uint256 tokenAmount) private {
1346         address[] memory path = new address[](2);
1347         path[0] = address(this);
1348         path[1] = uniswapV2Router.WETH();
1349         _approve(address(this), address(uniswapV2Router), tokenAmount);
1350         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1351             tokenAmount,
1352             0, 
1353             path,
1354             address(this), 
1355             block.timestamp
1356         );
1357         emit SwapTokensForETH(tokenAmount, path);
1358     }
1359 
1360     // add liqiudity 
1361     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1362         _approve(address(this), address(uniswapV2Router), tokenAmount);
1363         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1364             address(this),
1365             tokenAmount,
1366             0, 
1367             0, 
1368             owner(),
1369             block.timestamp
1370         );
1371     }
1372     
1373     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
1374     function buyBackTokens(uint256 ETHAmountInWei) external onlyOwner {
1375         // generate the uniswap pair path of weth -> eth
1376         address[] memory path = new address[](2);
1377         path[0] = uniswapV2Router.WETH();
1378         path[1] = address(this);
1379 
1380         // make the swap
1381         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: ETHAmountInWei}(
1382             0, // accept any amount of Ethereum
1383             path,
1384             address(0xdead),
1385             block.timestamp
1386         );
1387     }
1388 
1389     function _checkTxLimit(address sender, uint256 amount) private view{ 
1390         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
1391     }
1392 }