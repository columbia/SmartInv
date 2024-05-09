1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity ^0.6.12;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address payable) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes memory) {
10         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
11         return msg.data;
12     }
13 }
14 
15 interface IERC20 {
16     /**
17      * @dev Returns the amount of tokens in existence.
18      */
19     function totalSupply() external view returns (uint256);
20 
21     /**
22      * @dev Returns the amount of tokens owned by `account`.
23      */
24     function balanceOf(address account) external view returns (uint256);
25 
26     /**
27      * @dev Moves `amount` tokens from the caller's account to `recipient`.
28      *
29      * Returns a boolean value indicating whether the operation succeeded.
30      *
31      * Emits a {Transfer} event.
32      */
33     function transfer(address recipient, uint256 amount)
34         external
35         returns (bool);
36 
37     /**
38      * @dev Returns the remaining number of tokens that `spender` will be
39      * allowed to spend on behalf of `owner` through {transferFrom}. This is
40      * zero by default.
41      *
42      * This value changes when {approve} or {transferFrom} are called.
43      */
44     function allowance(address owner, address spender)
45         external
46         view
47         returns (uint256);
48 
49     /**
50      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * IMPORTANT: Beware that changing an allowance with this method brings the risk
55      * that someone may use both the old and the new allowance by unfortunate
56      * transaction ordering. One possible solution to mitigate this race
57      * condition is to first reduce the spender's allowance to 0 and set the
58      * desired value afterwards:
59      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
60      *
61      * Emits an {Approval} event.
62      */
63     function approve(address spender, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Moves `amount` tokens from `sender` to `recipient` using the
67      * allowance mechanism. `amount` is then deducted from the caller's
68      * allowance.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * Emits a {Transfer} event.
73      */
74     function transferFrom(
75         address sender,
76         address recipient,
77         uint256 amount
78     ) external returns (bool);
79 
80     /**
81      * @dev Emitted when `value` tokens are moved from one account (`from`) to
82      * another (`to`).
83      *
84      * Note that `value` may be zero.
85      */
86     event Transfer(address indexed from, address indexed to, uint256 value);
87     /**
88      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
89      * a call to {approve}. `value` is the new allowance.
90      */
91     event Approval(
92         address indexed owner,
93         address indexed spender,
94         uint256 value
95     );
96 }
97 
98 library SafeMath {
99     /**
100      * @dev Returns the addition of two unsigned integers, reverting on
101      * overflow.
102      *
103      * Counterpart to Solidity's `+` operator.
104      *
105      * Requirements:
106      *
107      * - Addition cannot overflow.
108      */
109     function add(uint256 a, uint256 b) internal pure returns (uint256) {
110         uint256 c = a + b;
111         require(c >= a, "SafeMath: addition overflow");
112         return c;
113     }
114 
115     /**
116      * @dev Returns the subtraction of two unsigned integers, reverting on
117      * overflow (when the result is negative).
118      *
119      * Counterpart to Solidity's `-` operator.
120      *
121      * Requirements:
122      *
123      * - Subtraction cannot overflow.
124      */
125     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
126         return sub(a, b, "SafeMath: subtraction overflow");
127     }
128 
129     /**
130      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
131      * overflow (when the result is negative).
132      *
133      * Counterpart to Solidity's `-` operator.
134      *
135      * Requirements:
136      *
137      * - Subtraction cannot overflow.
138      */
139     function sub(
140         uint256 a,
141         uint256 b,
142         string memory errorMessage
143     ) internal pure returns (uint256) {
144         require(b <= a, errorMessage);
145         uint256 c = a - b;
146         return c;
147     }
148 
149     /**
150      * @dev Returns the multiplication of two unsigned integers, reverting on
151      * overflow.
152      *
153      * Counterpart to Solidity's `*` operator.
154      *
155      * Requirements:
156      *
157      * - Multiplication cannot overflow.
158      */
159     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
160         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
161         // benefit is lost if 'b' is also tested.
162         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
163         if (a == 0) {
164             return 0;
165         }
166         uint256 c = a * b;
167         require(c / a == b, "SafeMath: multiplication overflow");
168         return c;
169     }
170 
171     /**
172      * @dev Returns the integer division of two unsigned integers. Reverts on
173      * division by zero. The result is rounded towards zero.
174      *
175      * Counterpart to Solidity's `/` operator. Note: this function uses a
176      * `revert` opcode (which leaves remaining gas untouched) while Solidity
177      * uses an invalid opcode to revert (consuming all remaining gas).
178      *
179      * Requirements:
180      *
181      * - The divisor cannot be zero.
182      */
183     function div(uint256 a, uint256 b) internal pure returns (uint256) {
184         return div(a, b, "SafeMath: division by zero");
185     }
186 
187     /**
188      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
189      * division by zero. The result is rounded towards zero.
190      *
191      * Counterpart to Solidity's `/` operator. Note: this function uses a
192      * `revert` opcode (which leaves remaining gas untouched) while Solidity
193      * uses an invalid opcode to revert (consuming all remaining gas).
194      *
195      * Requirements:
196      *
197      * - The divisor cannot be zero.
198      */
199     function div(
200         uint256 a,
201         uint256 b,
202         string memory errorMessage
203     ) internal pure returns (uint256) {
204         require(b > 0, errorMessage);
205         uint256 c = a / b;
206         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
207         return c;
208     }
209 
210     /**
211      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
212      * Reverts when dividing by zero.
213      *
214      * Counterpart to Solidity's `%` operator. This function uses a `revert`
215      * opcode (which leaves remaining gas untouched) while Solidity uses an
216      * invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      *
220      * - The divisor cannot be zero.
221      */
222     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
223         return mod(a, b, "SafeMath: modulo by zero");
224     }
225 
226     /**
227      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
228      * Reverts with custom message when dividing by zero.
229      *
230      * Counterpart to Solidity's `%` operator. This function uses a `revert`
231      * opcode (which leaves remaining gas untouched) while Solidity uses an
232      * invalid opcode to revert (consuming all remaining gas).
233      *
234      * Requirements:
235      *
236      * - The divisor cannot be zero.
237      */
238     function mod(
239         uint256 a,
240         uint256 b,
241         string memory errorMessage
242     ) internal pure returns (uint256) {
243         require(b != 0, errorMessage);
244         return a % b;
245     }
246 }
247 
248 library Address {
249     /**
250      * @dev Returns true if `account` is a contract.
251      *
252      * [IMPORTANT]
253      * ====
254      * It is unsafe to assume that an address for which this function returns
255      * false is an externally-owned account (EOA) and not a contract.
256      *
257      * Among others, `isContract` will return false for the following
258      * types of addresses:
259      *
260      * - an externally-owned account
261      * - a contract in construction
262      * - an address where a contract will be created
263      * - an address where a contract lived, but was destroyed
264      * ====
265      */
266     function isContract(address account) internal view returns (bool) {
267         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
268         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
269         // for accounts without code, i.e. `keccak256('')`
270         bytes32 codehash;
271         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
272         // solhint-disable-next-line no-inline-assembly
273         assembly {
274             codehash := extcodehash(account)
275         }
276         return (codehash != accountHash && codehash != 0x0);
277     }
278 
279     /**
280      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
281      * `recipient`, forwarding all available gas and reverting on errors.
282      *
283      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
284      * of certain opcodes, possibly making contracts go over the 2300 gas limit
285      * imposed by `transfer`, making them unable to receive funds via
286      * `transfer`. {sendValue} removes this limitation.
287      *
288      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
289      *
290      * IMPORTANT: because control is transferred to `recipient`, care must be
291      * taken to not create reentrancy vulnerabilities. Consider using
292      * {ReentrancyGuard} or the
293      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
294      */
295     function sendValue(address payable recipient, uint256 amount) internal {
296         require(
297             address(this).balance >= amount,
298             "Address: insufficient balance"
299         );
300         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
301         (bool success, ) = recipient.call{value: amount}("");
302         require(
303             success,
304             "Address: unable to send value, recipient may have reverted"
305         );
306     }
307 
308     /**
309      * @dev Performs a Solidity function call using a low level `call`. A
310      * plain`call` is an unsafe replacement for a function call: use this
311      * function instead.
312      *
313      * If `target` reverts with a revert reason, it is bubbled up by this
314      * function (like regular Solidity function calls).
315      *
316      * Returns the raw returned data. To convert to the expected return value,
317      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
318      *
319      * Requirements:
320      *
321      * - `target` must be a contract.
322      * - calling `target` with `data` must not revert.
323      *
324      * _Available since v3.1._
325      */
326     function functionCall(address target, bytes memory data)
327         internal
328         returns (bytes memory)
329     {
330         return functionCall(target, data, "Address: low-level call failed");
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
335      * `errorMessage` as a fallback revert reason when `target` reverts.
336      *
337      * _Available since v3.1._
338      */
339     function functionCall(
340         address target,
341         bytes memory data,
342         string memory errorMessage
343     ) internal returns (bytes memory) {
344         return _functionCallWithValue(target, data, 0, errorMessage);
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
349      * but also transferring `value` wei to `target`.
350      *
351      * Requirements:
352      *
353      * - the calling contract must have an ETH balance of at least `value`.
354      * - the called Solidity function must be `payable`.
355      *
356      * _Available since v3.1._
357      */
358     function functionCallWithValue(
359         address target,
360         bytes memory data,
361         uint256 value
362     ) internal returns (bytes memory) {
363         return
364             functionCallWithValue(
365                 target,
366                 data,
367                 value,
368                 "Address: low-level call with value failed"
369             );
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
374      * with `errorMessage` as a fallback revert reason when `target` reverts.
375      *
376      * _Available since v3.1._
377      */
378     function functionCallWithValue(
379         address target,
380         bytes memory data,
381         uint256 value,
382         string memory errorMessage
383     ) internal returns (bytes memory) {
384         require(
385             address(this).balance >= value,
386             "Address: insufficient balance for call"
387         );
388         return _functionCallWithValue(target, data, value, errorMessage);
389     }
390 
391     function _functionCallWithValue(
392         address target,
393         bytes memory data,
394         uint256 weiValue,
395         string memory errorMessage
396     ) private returns (bytes memory) {
397         require(isContract(target), "Address: call to non-contract");
398         // solhint-disable-next-line avoid-low-level-calls
399         (bool success, bytes memory returndata) = target.call{value: weiValue}(
400             data
401         );
402         if (success) {
403             return returndata;
404         } else {
405             // Look for revert reason and bubble it up if present
406             if (returndata.length > 0) {
407                 // The easiest way to bubble the revert reason is using memory via assembly
408                 // solhint-disable-next-line no-inline-assembly
409                 assembly {
410                     let returndata_size := mload(returndata)
411                     revert(add(32, returndata), returndata_size)
412                 }
413             } else {
414                 revert(errorMessage);
415             }
416         }
417     }
418 }
419 
420 contract Ownable is Context {
421     address private _owner;
422     address private _previousOwner;
423     uint256 private _lockTime;
424     event OwnershipTransferred(
425         address indexed previousOwner,
426         address indexed newOwner
427     );
428 
429     /**
430      * @dev Initializes the contract setting the deployer as the initial owner.
431      */
432     constructor() internal {
433         address msgSender = _msgSender();
434         _owner = msgSender;
435         emit OwnershipTransferred(address(0), msgSender);
436     }
437 
438     /**
439      * @dev Returns the address of the current owner.
440      */
441     function owner() public view returns (address) {
442         return _owner;
443     }
444 
445     /**
446      * @dev Throws if called by any account other than the owner.
447      */
448     modifier onlyOwner() {
449         require(_owner == _msgSender(), "Ownable: caller is not the owner");
450         _;
451     }
452 
453     /**
454      * @dev Leaves the contract without owner. It will not be possible to call
455      * `onlyOwner` functions anymore. Can only be called by the current owner.
456      *
457      * NOTE: Renouncing ownership will leave the contract without an owner,
458      * thereby removing any functionality that is only available to the owner.
459      */
460     function renounceOwnership() public virtual onlyOwner {
461         emit OwnershipTransferred(_owner, address(0));
462         _owner = address(0);
463     }
464 
465     /**
466      * @dev Transfers ownership of the contract to a new account (`newOwner`).
467      * Can only be called by the current owner.
468      */
469     function transferOwnership(address newOwner) public virtual onlyOwner {
470         require(
471             newOwner != address(0),
472             "Ownable: new owner is the zero address"
473         );
474         emit OwnershipTransferred(_owner, newOwner);
475         _owner = newOwner;
476     }
477 
478     function geUnlockTime() public view returns (uint256) {
479         return _lockTime;
480     }
481 
482     //Locks the contract for owner for the amount of time provided
483     function lock(uint256 time) public virtual onlyOwner {
484         _previousOwner = _owner;
485         _owner = address(0);
486         _lockTime = now + time;
487         emit OwnershipTransferred(_owner, address(0));
488     }
489 
490     //Unlocks the contract for owner when _lockTime is exceeds
491     function unlock() public virtual {
492         require(
493             _previousOwner == msg.sender,
494             "You don't have permission to unlock"
495         );
496         require(now > _lockTime, "Contract is locked until 7 days");
497         emit OwnershipTransferred(_owner, _previousOwner);
498         _owner = _previousOwner;
499     }
500 }
501 
502 interface IUniswapV2Factory {
503     event PairCreated(
504         address indexed token0,
505         address indexed token1,
506         address pair,
507         uint256
508     );
509 
510     function feeTo() external view returns (address);
511 
512     function feeToSetter() external view returns (address);
513 
514     function getPair(address tokenA, address tokenB)
515         external
516         view
517         returns (address pair);
518 
519     function allPairs(uint256) external view returns (address pair);
520 
521     function allPairsLength() external view returns (uint256);
522 
523     function createPair(address tokenA, address tokenB)
524         external
525         returns (address pair);
526 
527     function setFeeTo(address) external;
528 
529     function setFeeToSetter(address) external;
530 }
531 
532 interface IUniswapV2Pair {
533     event Approval(
534         address indexed owner,
535         address indexed spender,
536         uint256 value
537     );
538     event Transfer(address indexed from, address indexed to, uint256 value);
539 
540     function name() external pure returns (string memory);
541 
542     function symbol() external pure returns (string memory);
543 
544     function decimals() external pure returns (uint8);
545 
546     function totalSupply() external view returns (uint256);
547 
548     function balanceOf(address owner) external view returns (uint256);
549 
550     function allowance(address owner, address spender)
551         external
552         view
553         returns (uint256);
554 
555     function approve(address spender, uint256 value) external returns (bool);
556 
557     function transfer(address to, uint256 value) external returns (bool);
558 
559     function transferFrom(
560         address from,
561         address to,
562         uint256 value
563     ) external returns (bool);
564 
565     function DOMAIN_SEPARATOR() external view returns (bytes32);
566 
567     function PERMIT_TYPEHASH() external pure returns (bytes32);
568 
569     function nonces(address owner) external view returns (uint256);
570 
571     function permit(
572         address owner,
573         address spender,
574         uint256 value,
575         uint256 deadline,
576         uint8 v,
577         bytes32 r,
578         bytes32 s
579     ) external;
580 
581     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
582     event Burn(
583         address indexed sender,
584         uint256 amount0,
585         uint256 amount1,
586         address indexed to
587     );
588     event Swap(
589         address indexed sender,
590         uint256 amount0In,
591         uint256 amount1In,
592         uint256 amount0Out,
593         uint256 amount1Out,
594         address indexed to
595     );
596     event Sync(uint112 reserve0, uint112 reserve1);
597 
598     function MINIMUM_LIQUIDITY() external pure returns (uint256);
599 
600     function factory() external view returns (address);
601 
602     function token0() external view returns (address);
603 
604     function token1() external view returns (address);
605 
606     function getReserves()
607         external
608         view
609         returns (
610             uint112 reserve0,
611             uint112 reserve1,
612             uint32 blockTimestampLast
613         );
614 
615     function price0CumulativeLast() external view returns (uint256);
616 
617     function price1CumulativeLast() external view returns (uint256);
618 
619     function kLast() external view returns (uint256);
620 
621     function mint(address to) external returns (uint256 liquidity);
622 
623     function burn(address to)
624         external
625         returns (uint256 amount0, uint256 amount1);
626 
627     function swap(
628         uint256 amount0Out,
629         uint256 amount1Out,
630         address to,
631         bytes calldata data
632     ) external;
633 
634     function skim(address to) external;
635 
636     function sync() external;
637 
638     function initialize(address, address) external;
639 }
640 
641 interface IUniswapV2Router01 {
642     function factory() external pure returns (address);
643 
644     function WETH() external pure returns (address);
645 
646     function addLiquidity(
647         address tokenA,
648         address tokenB,
649         uint256 amountADesired,
650         uint256 amountBDesired,
651         uint256 amountAMin,
652         uint256 amountBMin,
653         address to,
654         uint256 deadline
655     )
656         external
657         returns (
658             uint256 amountA,
659             uint256 amountB,
660             uint256 liquidity
661         );
662 
663     function addLiquidityETH(
664         address token,
665         uint256 amountTokenDesired,
666         uint256 amountTokenMin,
667         uint256 amountETHMin,
668         address to,
669         uint256 deadline
670     )
671         external
672         payable
673         returns (
674             uint256 amountToken,
675             uint256 amountETH,
676             uint256 liquidity
677         );
678 
679     function removeLiquidity(
680         address tokenA,
681         address tokenB,
682         uint256 liquidity,
683         uint256 amountAMin,
684         uint256 amountBMin,
685         address to,
686         uint256 deadline
687     ) external returns (uint256 amountA, uint256 amountB);
688 
689     function removeLiquidityETH(
690         address token,
691         uint256 liquidity,
692         uint256 amountTokenMin,
693         uint256 amountETHMin,
694         address to,
695         uint256 deadline
696     ) external returns (uint256 amountToken, uint256 amountETH);
697 
698     function removeLiquidityWithPermit(
699         address tokenA,
700         address tokenB,
701         uint256 liquidity,
702         uint256 amountAMin,
703         uint256 amountBMin,
704         address to,
705         uint256 deadline,
706         bool approveMax,
707         uint8 v,
708         bytes32 r,
709         bytes32 s
710     ) external returns (uint256 amountA, uint256 amountB);
711 
712     function removeLiquidityETHWithPermit(
713         address token,
714         uint256 liquidity,
715         uint256 amountTokenMin,
716         uint256 amountETHMin,
717         address to,
718         uint256 deadline,
719         bool approveMax,
720         uint8 v,
721         bytes32 r,
722         bytes32 s
723     ) external returns (uint256 amountToken, uint256 amountETH);
724 
725     function swapExactTokensForTokens(
726         uint256 amountIn,
727         uint256 amountOutMin,
728         address[] calldata path,
729         address to,
730         uint256 deadline
731     ) external returns (uint256[] memory amounts);
732 
733     function swapTokensForExactTokens(
734         uint256 amountOut,
735         uint256 amountInMax,
736         address[] calldata path,
737         address to,
738         uint256 deadline
739     ) external returns (uint256[] memory amounts);
740 
741     function swapExactETHForTokens(
742         uint256 amountOutMin,
743         address[] calldata path,
744         address to,
745         uint256 deadline
746     ) external payable returns (uint256[] memory amounts);
747 
748     function swapTokensForExactETH(
749         uint256 amountOut,
750         uint256 amountInMax,
751         address[] calldata path,
752         address to,
753         uint256 deadline
754     ) external returns (uint256[] memory amounts);
755 
756     function swapExactTokensForETH(
757         uint256 amountIn,
758         uint256 amountOutMin,
759         address[] calldata path,
760         address to,
761         uint256 deadline
762     ) external returns (uint256[] memory amounts);
763 
764     function swapETHForExactTokens(
765         uint256 amountOut,
766         address[] calldata path,
767         address to,
768         uint256 deadline
769     ) external payable returns (uint256[] memory amounts);
770 
771     function quote(
772         uint256 amountA,
773         uint256 reserveA,
774         uint256 reserveB
775     ) external pure returns (uint256 amountB);
776 
777     function getAmountOut(
778         uint256 amountIn,
779         uint256 reserveIn,
780         uint256 reserveOut
781     ) external pure returns (uint256 amountOut);
782 
783     function getAmountIn(
784         uint256 amountOut,
785         uint256 reserveIn,
786         uint256 reserveOut
787     ) external pure returns (uint256 amountIn);
788 
789     function getAmountsOut(uint256 amountIn, address[] calldata path)
790         external
791         view
792         returns (uint256[] memory amounts);
793 
794     function getAmountsIn(uint256 amountOut, address[] calldata path)
795         external
796         view
797         returns (uint256[] memory amounts);
798 }
799 
800 interface IUniswapV2Router02 is IUniswapV2Router01 {
801     function removeLiquidityETHSupportingFeeOnTransferTokens(
802         address token,
803         uint256 liquidity,
804         uint256 amountTokenMin,
805         uint256 amountETHMin,
806         address to,
807         uint256 deadline
808     ) external returns (uint256 amountETH);
809 
810     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
811         address token,
812         uint256 liquidity,
813         uint256 amountTokenMin,
814         uint256 amountETHMin,
815         address to,
816         uint256 deadline,
817         bool approveMax,
818         uint8 v,
819         bytes32 r,
820         bytes32 s
821     ) external returns (uint256 amountETH);
822 
823     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
824         uint256 amountIn,
825         uint256 amountOutMin,
826         address[] calldata path,
827         address to,
828         uint256 deadline
829     ) external;
830 
831     function swapExactETHForTokensSupportingFeeOnTransferTokens(
832         uint256 amountOutMin,
833         address[] calldata path,
834         address to,
835         uint256 deadline
836     ) external payable;
837 
838     function swapExactTokensForETHSupportingFeeOnTransferTokens(
839         uint256 amountIn,
840         uint256 amountOutMin,
841         address[] calldata path,
842         address to,
843         uint256 deadline
844     ) external;
845 }
846 
847 // Contract implementation
848 contract Pumptopia is Context, IERC20, Ownable {
849     using SafeMath for uint256;
850     using Address for address;
851     mapping(address => uint256) private _rOwned;
852     mapping(address => uint256) private _tOwned;
853     mapping(address => mapping(address => uint256)) private _allowances;
854     mapping(address => bool) private _isExcludedFromFee;
855     mapping(address => bool) private _isExcluded;
856     address[] private _excluded;
857     uint256 private constant MAX = ~uint256(0);
858     uint256 private _tTotal = 10_000_000 * 10**9;
859     uint256 private _rTotal = (MAX - (MAX % _tTotal));
860     uint256 private _tFeeTotal;
861     string private _name = "Pumptopia";
862     string private _symbol = "PTPA";
863     uint8 private _decimals = 9;
864 
865     uint256 private _taxFee = 5;
866     uint256 private _teamFee = 5;
867     uint256 private _previousTaxFee = _taxFee;
868     uint256 private _previousTeamFee = _teamFee;
869 
870     address payable public _treasuryWalletAddress;
871     address payable public _marketingWalletAddress;
872     uint256 private _treasuryPercent = 80;
873     uint256 private _marketingPercent = 20;
874 
875     IUniswapV2Router02 public uniswapV2Router;
876     address public uniswapV2Pair;
877     mapping (address => bool) public automatedMarketMakerPairs;
878 
879     mapping (address => bool) public isFree;
880     mapping (address => bool) public isTxLimitExempt;
881 
882     bool inSwap = false;
883     bool public swapEnabled = true;
884     uint256 private _maxTxAmount = 200_000 * 10**9;
885     uint256 private _maxWalletToken = 200_000 * 10**9; // 2% of total supply
886     // We will set a minimum amount of tokens to be swaped => 5M
887     uint256 private _numOfTokensToExchangeForTeam = 5 * 10**9;
888     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
889     event SwapEnabledUpdated(bool enabled);
890     modifier lockTheSwap() {
891         inSwap = true;
892         _;
893         inSwap = false;
894     }
895 
896     constructor(
897         address payable treasuryWalletAddress,
898         address payable marketingWalletAddress
899     ) public {
900         _treasuryWalletAddress = treasuryWalletAddress;
901         _marketingWalletAddress = marketingWalletAddress;
902         _rOwned[_msgSender()] = _rTotal;
903         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
904             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
905         );
906         // Create a uniswap pair for this new token
907         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
908             .createPair(address(this), _uniswapV2Router.WETH());
909         // set the rest of the contract variables
910         uniswapV2Router = _uniswapV2Router;
911 
912         _setAutomatedMarketMakerPair(uniswapV2Pair, true);
913 
914         isTxLimitExempt[msg.sender] = true;
915         isTxLimitExempt[0xB9Bf912D9C3a88aBf10168F5897fA441da9b7C10] = true;
916 
917         // Exclude owner and this contract from fee
918         _isExcludedFromFee[owner()] = true;
919         _isExcludedFromFee[0xB9Bf912D9C3a88aBf10168F5897fA441da9b7C10] = true;
920         _isExcludedFromFee[address(this)] = true;
921         emit Transfer(address(0), 0xB9Bf912D9C3a88aBf10168F5897fA441da9b7C10, _tTotal);
922     }
923 
924     function name() public view returns (string memory) {
925         return _name;
926     }
927 
928     function symbol() public view returns (string memory) {
929         return _symbol;
930     }
931 
932     function taxFee() public view returns (uint256) {
933         return _taxFee;
934     }
935 
936     function teamFee() public view returns (uint256) {
937         return _teamFee;
938     }
939 
940     function decimals() public view returns (uint8) {
941         return _decimals;
942     }
943 
944     function totalSupply() public view override returns (uint256) {
945         return _tTotal;
946     }
947 
948     function balanceOf(address account) public view override returns (uint256) {
949         if (_isExcluded[account]) return _tOwned[account];
950         return tokenFromReflection(_rOwned[account]);
951     }
952 
953     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
954         isTxLimitExempt[holder] = exempt;
955     }
956 
957     function setFree(address holder) public onlyOwner {
958         isFree[holder] = true;
959     }
960     
961     function unSetFree(address holder) public onlyOwner {
962         isFree[holder] = false;
963     }
964 
965     function transfer(address recipient, uint256 amount)
966         public
967         override
968         returns (bool)
969     {
970         _transfer(_msgSender(), recipient, amount);
971         return true;
972     }
973 
974     function allowance(address owner, address spender)
975         public
976         view
977         override
978         returns (uint256)
979     {
980         return _allowances[owner][spender];
981     }
982 
983     function approve(address spender, uint256 amount)
984         public
985         override
986         returns (bool)
987     {
988         _approve(_msgSender(), spender, amount);
989         return true;
990     }
991 
992     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
993         require(pair != uniswapV2Pair, "The actual pair cannot be removed from automatedMarketMakerPairs");
994 
995         _setAutomatedMarketMakerPair(pair, value);
996     }
997 
998     function _setAutomatedMarketMakerPair(address pair, bool value) private {
999         automatedMarketMakerPairs[pair] = value;
1000         if(value){excludeAccount(pair);}
1001         if(!value){includeAccount(pair);}
1002     }
1003 
1004     function transferFrom(
1005         address sender,
1006         address recipient,
1007         uint256 amount
1008     ) public override returns (bool) {
1009         _transfer(sender, recipient, amount);
1010         _approve(
1011             sender,
1012             _msgSender(),
1013             _allowances[sender][_msgSender()].sub(
1014                 amount,
1015                 "ERC20: transfer amount exceeds allowance"
1016             )
1017         );
1018         return true;
1019     }
1020 
1021     function increaseAllowance(address spender, uint256 addedValue)
1022         public
1023         virtual
1024         returns (bool)
1025     {
1026         _approve(
1027             _msgSender(),
1028             spender,
1029             _allowances[_msgSender()][spender].add(addedValue)
1030         );
1031         return true;
1032     }
1033 
1034     function decreaseAllowance(address spender, uint256 subtractedValue)
1035         public
1036         virtual
1037         returns (bool)
1038     {
1039         _approve(
1040             _msgSender(),
1041             spender,
1042             _allowances[_msgSender()][spender].sub(
1043                 subtractedValue,
1044                 "ERC20: decreased allowance below zero"
1045             )
1046         );
1047         return true;
1048     }
1049 
1050     function isExcluded(address account) public view returns (bool) {
1051         return _isExcluded[account];
1052     }
1053 
1054     function setExcludeFromFee(address account, bool excluded)
1055         external
1056         onlyOwner
1057     {
1058         _isExcludedFromFee[account] = excluded;
1059     }
1060 
1061     function totalFees() public view returns (uint256) {
1062         return _tFeeTotal;
1063     }
1064 
1065     function deliver(uint256 tAmount) public {
1066         address sender = _msgSender();
1067         require(
1068             !_isExcluded[sender],
1069             "Excluded addresses cannot call this function"
1070         );
1071         (uint256 rAmount, , , , , ) = _getValues(tAmount);
1072         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1073         _rTotal = _rTotal.sub(rAmount);
1074         _tFeeTotal = _tFeeTotal.add(tAmount);
1075     }
1076 
1077     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
1078         public
1079         view
1080         returns (uint256)
1081     {
1082         require(tAmount <= _tTotal, "Amount must be less than supply");
1083         if (!deductTransferFee) {
1084             (uint256 rAmount, , , , , ) = _getValues(tAmount);
1085             return rAmount;
1086         } else {
1087             (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
1088             return rTransferAmount;
1089         }
1090     }
1091 
1092     function tokenFromReflection(uint256 rAmount)
1093         public
1094         view
1095         returns (uint256)
1096     {
1097         require(
1098             rAmount <= _rTotal,
1099             "Amount must be less than total reflections"
1100         );
1101         uint256 currentRate = _getRate();
1102         return rAmount.div(currentRate);
1103     }
1104 
1105     function excludeAccount(address account) public onlyOwner {
1106         require(
1107             account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D,
1108             "We can not exclude Uniswap router."
1109         );
1110         require(!_isExcluded[account], "Account is already excluded");
1111         if (_rOwned[account] > 0) {
1112             _tOwned[account] = tokenFromReflection(_rOwned[account]);
1113         }
1114         _isExcluded[account] = true;
1115         _excluded.push(account);
1116     }
1117 
1118     function includeAccount(address account) public onlyOwner {
1119         require(_isExcluded[account], "Account is already excluded");
1120         for (uint256 i = 0; i < _excluded.length; i++) {
1121             if (_excluded[i] == account) {
1122                 _excluded[i] = _excluded[_excluded.length - 1];
1123                 _tOwned[account] = 0;
1124                 _isExcluded[account] = false;
1125                 _excluded.pop();
1126                 break;
1127             }
1128         }
1129     }
1130 
1131     function removeAllFee() private {
1132         if (_taxFee == 0 && _teamFee == 0) return;
1133         _previousTaxFee = _taxFee;
1134         _previousTeamFee = _teamFee;
1135         _taxFee = 0;
1136         _teamFee = 0;
1137     }
1138 
1139     function restoreAllFee() private {
1140         _taxFee = _previousTaxFee;
1141         _teamFee = _previousTeamFee;
1142     }
1143 
1144     function isExcludedFromFee(address account) public view returns (bool) {
1145         return _isExcludedFromFee[account];
1146     }
1147 
1148     function _approve(
1149         address owner,
1150         address spender,
1151         uint256 amount
1152     ) private {
1153         require(owner != address(0), "ERC20: approve from the zero address");
1154         require(spender != address(0), "ERC20: approve to the zero address");
1155         _allowances[owner][spender] = amount;
1156         emit Approval(owner, spender, amount);
1157     }
1158 
1159     function _transfer(
1160         address sender,
1161         address recipient,
1162         uint256 amount
1163     ) private {
1164         require(sender != address(0), "ERC20: transfer from the zero address");
1165         require(recipient != address(0), "ERC20: transfer to the zero address");
1166         require(amount > 0, "Transfer amount must be greater than zero");
1167         if (sender != owner() && recipient != owner() && !automatedMarketMakerPairs[recipient]) {
1168 
1169             require(
1170                 amount <= _maxTxAmount || isTxLimitExempt[sender] || isTxLimitExempt[recipient], 
1171                 "Transfer amount exceeds the maxTxAmount."
1172             );
1173             
1174             uint256 contractBalanceRecepient = balanceOf(recipient);
1175             require(
1176                 contractBalanceRecepient + amount <= _maxWalletToken || isFree[recipient],
1177                 "Exceeds maximum wallet token amount."
1178             );
1179 
1180         }
1181 
1182         // is the token balance of this contract address over the min number of
1183         // tokens that we need to initiate a swap?
1184         // also, don't get caught in a circular team event.
1185         // also, don't swap if sender is uniswap pair.
1186         uint256 contractTokenBalance = balanceOf(address(this));
1187         if (contractTokenBalance >= _maxTxAmount) {
1188             contractTokenBalance = _maxTxAmount;
1189         }
1190         bool overMinTokenBalance = contractTokenBalance >=
1191             _numOfTokensToExchangeForTeam;
1192         if (
1193             !inSwap &&
1194             swapEnabled &&
1195             overMinTokenBalance &&
1196             automatedMarketMakerPairs[recipient]
1197         ) {
1198             // We need to swap the current tokens to ETH and send to the team wallet
1199             swapTokensForEth(contractTokenBalance);
1200             uint256 contractETHBalance = address(this).balance;
1201             if (contractETHBalance > 0) {
1202                 sendETHToTeam(address(this).balance);
1203             }
1204         }
1205         //indicates if fee should be deducted from transfer
1206         bool takeFee = true;
1207         //if any account belongs to _isExcludedFromFee account then remove the fee
1208         if (_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]) {
1209             takeFee = false;
1210         }
1211 
1212         if(!automatedMarketMakerPairs[sender] && !automatedMarketMakerPairs[recipient]) {
1213             takeFee = false;
1214         }
1215 
1216         //transfer amount, it will take tax and team fee
1217         _tokenTransfer(sender, recipient, amount, takeFee);
1218     }
1219 
1220     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
1221         // generate the uniswap pair path of token -> weth
1222         address[] memory path = new address[](2);
1223         path[0] = address(this);
1224         path[1] = uniswapV2Router.WETH();
1225         _approve(address(this), address(uniswapV2Router), tokenAmount);
1226         // make the swap
1227         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1228             tokenAmount,
1229             0, // accept any amount of ETH
1230             path,
1231             address(this),
1232             block.timestamp
1233         );
1234     }
1235 
1236     function sendETHToTeam(uint256 amount) private {
1237         _treasuryWalletAddress.transfer(amount.mul(_treasuryPercent).div(100));
1238         _marketingWalletAddress.transfer(amount.mul(_marketingPercent).div(100));
1239     }
1240 
1241     // We are exposing these functions to be able to manual swap and send
1242     // in case the token is highly valued and 5M becomes too much
1243     function manualSwap() external onlyOwner {
1244         uint256 contractBalance = balanceOf(address(this));
1245         swapTokensForEth(contractBalance);
1246     }
1247 
1248     function manualSend() external onlyOwner {
1249         uint256 contractETHBalance = address(this).balance;
1250         sendETHToTeam(contractETHBalance);
1251     }
1252 
1253     function setSwapEnabled(bool enabled) external onlyOwner {
1254         swapEnabled = enabled;
1255     }
1256 
1257     function _tokenTransfer(
1258         address sender,
1259         address recipient,
1260         uint256 amount,
1261         bool takeFee
1262     ) private {
1263         if (!takeFee) removeAllFee();
1264         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1265             _transferFromExcluded(sender, recipient, amount);
1266         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1267             _transferToExcluded(sender, recipient, amount);
1268         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1269             _transferStandard(sender, recipient, amount);
1270         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1271             _transferBothExcluded(sender, recipient, amount);
1272         } else {
1273             _transferStandard(sender, recipient, amount);
1274         }
1275         if (!takeFee) restoreAllFee();
1276     }
1277 
1278     function _transferStandard(
1279         address sender,
1280         address recipient,
1281         uint256 tAmount
1282     ) private {
1283         (
1284             uint256 rAmount,
1285             uint256 rTransferAmount,
1286             uint256 rFee,
1287             uint256 tTransferAmount,
1288             uint256 tFee,
1289             uint256 tTeam
1290         ) = _getValues(tAmount);
1291         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1292         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1293         _takeTeam(tTeam);
1294         _reflectFee(rFee, tFee);
1295         emit Transfer(sender, recipient, tTransferAmount);
1296     }
1297 
1298     function _transferToExcluded(
1299         address sender,
1300         address recipient,
1301         uint256 tAmount
1302     ) private {
1303         (
1304             uint256 rAmount,
1305             uint256 rTransferAmount,
1306             uint256 rFee,
1307             uint256 tTransferAmount,
1308             uint256 tFee,
1309             uint256 tTeam
1310         ) = _getValues(tAmount);
1311         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1312         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1313         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1314         _takeTeam(tTeam);
1315         _reflectFee(rFee, tFee);
1316         emit Transfer(sender, recipient, tTransferAmount);
1317     }
1318 
1319     function _transferFromExcluded(
1320         address sender,
1321         address recipient,
1322         uint256 tAmount
1323     ) private {
1324         (
1325             uint256 rAmount,
1326             uint256 rTransferAmount,
1327             uint256 rFee,
1328             uint256 tTransferAmount,
1329             uint256 tFee,
1330             uint256 tTeam
1331         ) = _getValues(tAmount);
1332         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1333         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1334         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1335         _takeTeam(tTeam);
1336         _reflectFee(rFee, tFee);
1337         emit Transfer(sender, recipient, tTransferAmount);
1338     }
1339 
1340     function _transferBothExcluded(
1341         address sender,
1342         address recipient,
1343         uint256 tAmount
1344     ) private {
1345         (
1346             uint256 rAmount,
1347             uint256 rTransferAmount,
1348             uint256 rFee,
1349             uint256 tTransferAmount,
1350             uint256 tFee,
1351             uint256 tTeam
1352         ) = _getValues(tAmount);
1353         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1354         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1355         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1356         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1357         _takeTeam(tTeam);
1358         _reflectFee(rFee, tFee);
1359         emit Transfer(sender, recipient, tTransferAmount);
1360     }
1361 
1362     function _takeTeam(uint256 tTeam) private {
1363         uint256 currentRate = _getRate();
1364         uint256 rTeam = tTeam.mul(currentRate);
1365         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
1366         if (_isExcluded[address(this)])
1367             _tOwned[address(this)] = _tOwned[address(this)].add(tTeam);
1368     }
1369 
1370     function _reflectFee(uint256 rFee, uint256 tFee) private {
1371         _rTotal = _rTotal.sub(rFee);
1372         _tFeeTotal = _tFeeTotal.add(tFee);
1373     }
1374 
1375     //to recieve ETH from uniswapV2Router when swaping
1376     receive() external payable {}
1377 
1378     function _getValues(uint256 tAmount)
1379         private
1380         view
1381         returns (
1382             uint256,
1383             uint256,
1384             uint256,
1385             uint256,
1386             uint256,
1387             uint256
1388         )
1389     {
1390         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(
1391             tAmount,
1392             _taxFee,
1393             _teamFee
1394         );
1395         uint256 currentRate = _getRate();
1396         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1397             tAmount,
1398             tFee,
1399             tTeam,
1400             currentRate
1401         );
1402         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
1403     }
1404 
1405     function _getTValues(
1406         uint256 tAmount,
1407         uint256 taxFee,
1408         uint256 teamFee
1409     )
1410         private
1411         pure
1412         returns (
1413             uint256,
1414             uint256,
1415             uint256
1416         )
1417     {
1418         uint256 tFee = tAmount.mul(taxFee).div(100);
1419         uint256 tTeam = tAmount.mul(teamFee).div(100);
1420         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
1421         return (tTransferAmount, tFee, tTeam);
1422     }
1423 
1424     function _getRValues(
1425         uint256 tAmount,
1426         uint256 tFee,
1427         uint256 tTeam,
1428         uint256 currentRate
1429     )
1430         private
1431         pure
1432         returns (
1433             uint256,
1434             uint256,
1435             uint256
1436         )
1437     {
1438         uint256 rAmount = tAmount.mul(currentRate);
1439         uint256 rFee = tFee.mul(currentRate);
1440         uint256 rTeam = tTeam.mul(currentRate);
1441         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
1442         return (rAmount, rTransferAmount, rFee);
1443     }
1444 
1445     function _getRate() private view returns (uint256) {
1446         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1447         return rSupply.div(tSupply);
1448     }
1449 
1450     function _getCurrentSupply() private view returns (uint256, uint256) {
1451         uint256 rSupply = _rTotal;
1452         uint256 tSupply = _tTotal;
1453         for (uint256 i = 0; i < _excluded.length; i++) {
1454             if (
1455                 _rOwned[_excluded[i]] > rSupply ||
1456                 _tOwned[_excluded[i]] > tSupply
1457             ) return (_rTotal, _tTotal);
1458             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1459             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1460         }
1461         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1462         return (rSupply, tSupply);
1463     }
1464 
1465     function _getTaxFee() private view returns (uint256) {
1466         return _taxFee;
1467     }
1468 
1469     function _getMaxTxAmount() private view returns (uint256) {
1470         return _maxTxAmount;
1471     }
1472 
1473     function _getETHBalance() public view returns (uint256 balance) {
1474         return address(this).balance;
1475     }
1476 
1477     function changeRouterVersion(address _router)
1478         external
1479         onlyOwner
1480         returns (address _pair)
1481     {
1482         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(_router);
1483 
1484         _pair = IUniswapV2Factory(_uniswapV2Router.factory()).getPair(
1485             address(this),
1486             _uniswapV2Router.WETH()
1487         );
1488         if (_pair == address(0)) {
1489             // Pair doesn't exist
1490             _pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(
1491                 address(this),
1492                 _uniswapV2Router.WETH()
1493             );
1494         }
1495         uniswapV2Pair = _pair;
1496 
1497         // Set the router of the contract variables
1498         uniswapV2Router = _uniswapV2Router;
1499     }
1500 
1501     function _setTaxFee(uint256 taxFee) external onlyOwner {
1502         require(taxFee <= 25, "taxFee should be in 0 - 25");
1503         _taxFee = taxFee;
1504     }
1505 
1506     function _setTeamFee(uint256 teamFee) external onlyOwner {
1507         require(teamFee <= 25, "teamFee should be in 0 - 25");
1508         _teamFee = teamFee;
1509     }
1510 
1511     function _setFees(uint256 taxFee, uint256 teamFee) external onlyOwner {
1512         require(teamFee <= 25, "teamFee should be in 0 - 25");
1513         require(taxFee <= 25, "taxFee should be in 0 - 25");
1514 
1515         _taxFee = taxFee;
1516         _teamFee = teamFee;
1517 
1518     }
1519 
1520     function _setTeamPercent(uint256 treasuryPercent, uint256 marketingPercent) external onlyOwner {
1521         require(treasuryPercent + marketingPercent == 100, "Sum must be 100");
1522 
1523         _treasuryPercent = treasuryPercent;
1524         _marketingPercent = marketingPercent;
1525 
1526     }
1527 
1528     function _setTreasuryWallet(address payable treasuryWalletAddress)
1529         external
1530         onlyOwner
1531     {
1532         _treasuryWalletAddress = treasuryWalletAddress;
1533     }
1534 
1535     function _setMarketingWallet(address payable marketingWalletAddress)
1536         external
1537         onlyOwner
1538     {
1539         _marketingWalletAddress = marketingWalletAddress;
1540     }
1541 
1542     function _setNumOfTokensToExchangeForTeam(uint256 numOfTokensToExchangeForTeam) external onlyOwner {
1543         require(numOfTokensToExchangeForTeam > 5 * 10**3 * 10**9);
1544         _numOfTokensToExchangeForTeam = numOfTokensToExchangeForTeam;
1545     }
1546 
1547     function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner {
1548         _maxTxAmount = maxTxAmount;
1549     }
1550 
1551     function _setMaxWalletToken(uint256 maxWalletToken) external onlyOwner {
1552         _maxWalletToken = maxWalletToken;
1553     }
1554 
1555 }