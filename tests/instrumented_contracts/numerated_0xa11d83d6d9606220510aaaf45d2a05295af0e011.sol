1 /**
2 
3 Web: https://larryv2.com/
4 
5 Socials: 
6 https://twitter.com/Larry_ether
7 https://t.me/LARRY_Entry
8 
9 Medium:
10 https://medium.com/@LARRYV2/larry-v2-c69619e2465
11 
12 
13 
14 */
15 
16 // SPDX-License-Identifier: MIT
17 
18 pragma solidity 0.8.18;
19 
20 interface IUniswapV2Router01 {
21     function factory() external pure returns (address);
22 
23     function WETH() external pure returns (address);
24 
25     function addLiquidity(
26         address tokenA,
27         address tokenB,
28         uint amountADesired,
29         uint amountBDesired,
30         uint amountAMin,
31         uint amountBMin,
32         address to,
33         uint deadline
34     ) external returns (uint amountA, uint amountB, uint liquidity);
35 
36     function addLiquidityETH(
37         address token,
38         uint amountTokenDesired,
39         uint amountTokenMin,
40         uint amountETHMin,
41         address to,
42         uint deadline
43     )
44         external
45         payable
46         returns (uint amountToken, uint amountETH, uint liquidity);
47 
48     function removeLiquidity(
49         address tokenA,
50         address tokenB,
51         uint liquidity,
52         uint amountAMin,
53         uint amountBMin,
54         address to,
55         uint deadline
56     ) external returns (uint amountA, uint amountB);
57 
58     function removeLiquidityETH(
59         address token,
60         uint liquidity,
61         uint amountTokenMin,
62         uint amountETHMin,
63         address to,
64         uint deadline
65     ) external returns (uint amountToken, uint amountETH);
66 
67     function removeLiquidityWithPermit(
68         address tokenA,
69         address tokenB,
70         uint liquidity,
71         uint amountAMin,
72         uint amountBMin,
73         address to,
74         uint deadline,
75         bool approveMax,
76         uint8 v,
77         bytes32 r,
78         bytes32 s
79     ) external returns (uint amountA, uint amountB);
80 
81     function removeLiquidityETHWithPermit(
82         address token,
83         uint liquidity,
84         uint amountTokenMin,
85         uint amountETHMin,
86         address to,
87         uint deadline,
88         bool approveMax,
89         uint8 v,
90         bytes32 r,
91         bytes32 s
92     ) external returns (uint amountToken, uint amountETH);
93 
94     function swapExactTokensForTokens(
95         uint amountIn,
96         uint amountOutMin,
97         address[] calldata path,
98         address to,
99         uint deadline
100     ) external returns (uint[] memory amounts);
101 
102     function swapTokensForExactTokens(
103         uint amountOut,
104         uint amountInMax,
105         address[] calldata path,
106         address to,
107         uint deadline
108     ) external returns (uint[] memory amounts);
109 
110     function swapExactETHForTokens(
111         uint amountOutMin,
112         address[] calldata path,
113         address to,
114         uint deadline
115     ) external payable returns (uint[] memory amounts);
116 
117     function swapTokensForExactETH(
118         uint amountOut,
119         uint amountInMax,
120         address[] calldata path,
121         address to,
122         uint deadline
123     ) external returns (uint[] memory amounts);
124 
125     function swapExactTokensForETH(
126         uint amountIn,
127         uint amountOutMin,
128         address[] calldata path,
129         address to,
130         uint deadline
131     ) external returns (uint[] memory amounts);
132 
133     function swapETHForExactTokens(
134         uint amountOut,
135         address[] calldata path,
136         address to,
137         uint deadline
138     ) external payable returns (uint[] memory amounts);
139 
140     function quote(
141         uint amountA,
142         uint reserveA,
143         uint reserveB
144     ) external pure returns (uint amountB);
145 
146     function getAmountOut(
147         uint amountIn,
148         uint reserveIn,
149         uint reserveOut
150     ) external pure returns (uint amountOut);
151 
152     function getAmountIn(
153         uint amountOut,
154         uint reserveIn,
155         uint reserveOut
156     ) external pure returns (uint amountIn);
157 
158     function getAmountsOut(
159         uint amountIn,
160         address[] calldata path
161     ) external view returns (uint[] memory amounts);
162 
163     function getAmountsIn(
164         uint amountOut,
165         address[] calldata path
166     ) external view returns (uint[] memory amounts);
167 }
168 
169   /**
170      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
171      *
172      * Returns a boolean value indicating whether the operation succeeded.
173      *
174      * IMPORTANT: Beware that changing an allowance with this method brings the risk
175      * that someone may use both the old and the new allowance by unfortunate
176      * transaction ordering. One possible solution to mitigate this race
177      * condition is to first reduce the spender's allowance to 0 and set the
178      * desired value afterwards:
179      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
180      *
181      * Emits an {Approval} event.
182      */
183 
184 interface IUniswapV2Router02 is IUniswapV2Router01 {
185     function removeLiquidityETHSupportingFeeOnTransferTokens(
186         address token,
187         uint liquidity,
188         uint amountTokenMin,
189         uint amountETHMin,
190         address to,
191         uint deadline
192     ) external returns (uint amountETH);
193 
194     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
195         address token,
196         uint liquidity,
197         uint amountTokenMin,
198         uint amountETHMin,
199         address to,
200         uint deadline,
201         bool approveMax,
202         uint8 v,
203         bytes32 r,
204         bytes32 s
205     ) external returns (uint amountETH);
206 
207     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
208         uint amountIn,
209         uint amountOutMin,
210         address[] calldata path,
211         address to,
212         uint deadline
213     ) external;
214 
215     function swapExactETHForTokensSupportingFeeOnTransferTokens(
216         uint amountOutMin,
217         address[] calldata path,
218         address to,
219         uint deadline
220     ) external payable;
221 
222     function swapExactTokensForETHSupportingFeeOnTransferTokens(
223         uint amountIn,
224         uint amountOutMin,
225         address[] calldata path,
226         address to,
227         uint deadline
228     ) external;
229 }
230 
231 interface IUniswapV2Factory {
232     event PairCreated(
233         address indexed token0,
234         address indexed token1,
235         address pair,
236         uint
237     );
238 
239     /**
240      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
241      * a call to {approve}. `value` is the new allowance.
242      */
243 
244     function feeTo() external view returns (address);
245 
246     function feeToSetter() external view returns (address);
247 
248     function getPair(
249         address tokenA,
250         address tokenB
251     ) external view returns (address pair);
252 
253     function allPairs(uint) external view returns (address pair);
254 
255     function allPairsLength() external view returns (uint);
256 
257     function createPair(
258         address tokenA,
259         address tokenB
260     ) external returns (address pair);
261 
262     function setFeeTo(address) external;
263 
264     function setFeeToSetter(address) external;
265 }
266 
267 library Address {
268     function isContract(address account) internal view returns (bool) {
269         return account.code.length > 0;
270     }
271 
272     function sendValue(address payable recipient, uint256 amount) internal {
273         require(
274             address(this).balance >= amount,
275             "Address: insufficient balance"
276         );
277 
278         (bool success, ) = recipient.call{value: amount}("");
279         require(
280             success,
281             "Address: unable to send value, recipient may have reverted"
282         );
283     }
284 
285     function functionCall(
286         address target,
287         bytes memory data
288     ) internal returns (bytes memory) {
289         return
290             functionCallWithValue(
291                 target,
292                 data,
293                 0,
294                 "Address: low-level call failed"
295             );
296     }
297 
298     function functionCall(
299         address target,
300         bytes memory data,
301         string memory errorMessage
302     ) internal returns (bytes memory) {
303         return functionCallWithValue(target, data, 0, errorMessage);
304     }
305 
306     function functionCallWithValue(
307         address target,
308         bytes memory data,
309         uint256 value
310     ) internal returns (bytes memory) {
311         return
312             functionCallWithValue(
313                 target,
314                 data,
315                 value,
316                 "Address: low-level call with value failed"
317             );
318     }
319 
320     function functionCallWithValue(
321         address target,
322         bytes memory data,
323         uint256 value,
324         string memory errorMessage
325     ) internal returns (bytes memory) {
326         require(
327             address(this).balance >= value,
328             "Address: insufficient balance for call"
329         );
330         (bool success, bytes memory returndata) = target.call{value: value}(
331             data
332         );
333         return
334             verifyCallResultFromTarget(
335                 target,
336                 success,
337                 returndata,
338                 errorMessage
339             );
340     }
341 
342     function functionStaticCall(
343         address target,
344         bytes memory data
345     ) internal view returns (bytes memory) {
346         return
347             functionStaticCall(
348                 target,
349                 data,
350                 "Address: low-level static call failed"
351             );
352     }
353 
354     function functionStaticCall(
355         address target,
356         bytes memory data,
357         string memory errorMessage
358     ) internal view returns (bytes memory) {
359         (bool success, bytes memory returndata) = target.staticcall(data);
360         return
361             verifyCallResultFromTarget(
362                 target,
363                 success,
364                 returndata,
365                 errorMessage
366             );
367     }
368 
369     function functionDelegateCall(
370         address target,
371         bytes memory data
372     ) internal returns (bytes memory) {
373         return
374             functionDelegateCall(
375                 target,
376                 data,
377                 "Address: low-level delegate call failed"
378             );
379     }
380 
381     function functionDelegateCall(
382         address target,
383         bytes memory data,
384         string memory errorMessage
385     ) internal returns (bytes memory) {
386         (bool success, bytes memory returndata) = target.delegatecall(data);
387         return
388             verifyCallResultFromTarget(
389                 target,
390                 success,
391                 returndata,
392                 errorMessage
393             );
394     }
395 
396     function verifyCallResultFromTarget(
397         address target,
398         bool success,
399         bytes memory returndata,
400         string memory errorMessage
401     ) internal view returns (bytes memory) {
402         if (success) {
403             if (returndata.length == 0) {
404                 require(isContract(target), "Address: call to non-contract");
405             }
406             return returndata;
407         } else {
408             _revert(returndata, errorMessage);
409         }
410     }
411 
412     function verifyCallResult(
413         bool success,
414         bytes memory returndata,
415         string memory errorMessage
416     ) internal pure returns (bytes memory) {
417         if (success) {
418             return returndata;
419         } else {
420             _revert(returndata, errorMessage);
421         }
422     }
423 
424     function _revert(
425         bytes memory returndata,
426         string memory errorMessage
427     ) private pure {
428         if (returndata.length > 0) {
429             /// @solidity memory-safe-assembly
430             assembly {
431                 let returndata_size := mload(returndata)
432                 revert(add(32, returndata), returndata_size)
433             }
434         } else {
435             revert(errorMessage);
436         }
437     }
438 }
439 
440 interface IERC20Permit {
441     function permit(
442         address owner,
443         address spender,
444         uint256 value,
445         uint256 deadline,
446         uint8 v,
447         bytes32 r,
448         bytes32 s
449     ) external;
450 
451     function nonces(address owner) external view returns (uint256);
452 
453 
454 /*
455  * @dev Provides information about the current execution context, including the
456  * sender of the transaction and its data. While these are generally available
457  * via msg.sender and msg.data, they should not be accessed in such a direct
458  * manner, since when dealing with meta-transactions the account sending and
459  * paying for execution may not be the actual sender (as far as an application
460  * is concerned).
461  *
462  * This contract is only required for intermediate, library-like contracts.
463  */
464     // solhint-disable-next-line func-name-mixedcase
465     
466     function DOMAIN_SEPARATOR() external view returns (bytes32);
467 }
468 
469 interface IERC20 {
470     event Transfer(address indexed from, address indexed to, uint256 value);
471 
472     event Approval(
473         address indexed owner,
474         address indexed spender,
475         uint256 value
476     );
477 
478     function totalSupply() external view returns (uint256);
479 
480     function balanceOf(address account) external view returns (uint256);
481 
482     function transfer(address to, uint256 amount) external returns (bool);
483 
484     function allowance(
485         address owner,
486         address spender
487     ) external view returns (uint256);
488 
489     function approve(address spender, uint256 amount) external returns (bool);
490 
491     function transferFrom(
492         address from,
493         address to,
494         uint256 amount
495     ) external returns (bool);
496 }
497 
498 library SafeERC20 {
499     using Address for address;
500 
501     function safeTransfer(IERC20 token, address to, uint256 value) internal {
502         _callOptionalReturn(
503             token,
504             abi.encodeWithSelector(token.transfer.selector, to, value)
505         );
506     }
507 
508     function safeTransferFrom(
509         IERC20 token,
510         address from,
511         address to,
512         uint256 value
513     ) internal {
514         _callOptionalReturn(
515             token,
516             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
517         );
518     }
519 
520     function safeApprove(
521         IERC20 token,
522         address spender,
523         uint256 value
524     ) internal {
525         require(
526             (value == 0) || (token.allowance(address(this), spender) == 0),
527             "SafeERC20: approve from non-zero to non-zero allowance"
528         );
529         _callOptionalReturn(
530             token,
531             abi.encodeWithSelector(token.approve.selector, spender, value)
532         );
533     }
534 
535     function safeIncreaseAllowance(
536         IERC20 token,
537         address spender,
538         uint256 value
539     ) internal {
540         uint256 oldAllowance = token.allowance(address(this), spender);
541         _callOptionalReturn(
542             token,
543             abi.encodeWithSelector(
544                 token.approve.selector,
545                 spender,
546                 oldAllowance + value
547             )
548         );
549     }
550 
551     function safeDecreaseAllowance(
552         IERC20 token,
553         address spender,
554         uint256 value
555     ) internal {
556         unchecked {
557             uint256 oldAllowance = token.allowance(address(this), spender);
558             require(
559                 oldAllowance >= value,
560                 "SafeERC20: decreased allowance below zero"
561             );
562             _callOptionalReturn(
563                 token,
564                 abi.encodeWithSelector(
565                     token.approve.selector,
566                     spender,
567                     oldAllowance - value
568                 )
569             );
570         }
571     }
572 
573     function forceApprove(
574         IERC20 token,
575         address spender,
576         uint256 value
577     ) internal {
578         bytes memory approvalCall = abi.encodeWithSelector(
579             token.approve.selector,
580             spender,
581             value
582         );
583 
584         if (!_callOptionalReturnBool(token, approvalCall)) {
585             _callOptionalReturn(
586                 token,
587                 abi.encodeWithSelector(token.approve.selector, spender, 0)
588             );
589             _callOptionalReturn(token, approvalCall);
590         }
591     }
592 
593     function safePermit(
594         IERC20Permit token,
595         address owner,
596         address spender,
597         uint256 value,
598         uint256 deadline,
599         uint8 v,
600         bytes32 r,
601         bytes32 s
602     ) internal {
603         uint256 nonceBefore = token.nonces(owner);
604         token.permit(owner, spender, value, deadline, v, r, s);
605         uint256 nonceAfter = token.nonces(owner);
606         require(
607             nonceAfter == nonceBefore + 1,
608             "SafeERC20: permit did not succeed"
609         );
610     }
611 
612     function _callOptionalReturn(IERC20 token, bytes memory data) private {
613         bytes memory returndata = address(token).functionCall(
614             data,
615             "SafeERC20: low-level call failed"
616         );
617         require(
618             returndata.length == 0 || abi.decode(returndata, (bool)),
619             "SafeERC20: ERC20 operation did not succeed"
620         );
621     }
622 
623     function _callOptionalReturnBool(
624         IERC20 token,
625         bytes memory data
626     ) private returns (bool) {
627         (bool success, bytes memory returndata) = address(token).call(data);
628         return
629             success &&
630             (returndata.length == 0 || abi.decode(returndata, (bool))) &&
631             Address.isContract(address(token));
632     }
633 }
634 
635 interface IERC20Metadata is IERC20 {
636     function name() external view returns (string memory);
637 
638     function symbol() external view returns (string memory);
639 
640     function decimals() external view returns (uint8);
641 }
642 
643 abstract contract ReentrancyGuard {
644     uint256 private constant _NOT_ENTERED = 1;
645     uint256 private constant _ENTERED = 2;
646 
647     uint256 private _status;
648 
649     constructor() {
650         _status = _NOT_ENTERED;
651     }
652 
653     modifier nonReentrant() {
654         _nonReentrantBefore();
655         _;
656         _nonReentrantAfter();
657     }
658 
659     function _nonReentrantBefore() private {
660         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
661 
662         _status = _ENTERED;
663     }
664 
665     function _nonReentrantAfter() private {
666         _status = _NOT_ENTERED;
667     }
668 
669     function _reentrancyGuardEntered() internal view returns (bool) {
670         return _status == _ENTERED;
671     }
672 }
673 
674 abstract contract Context {
675     function _msgSender() internal view virtual returns (address) {
676         return msg.sender;
677     }
678 
679     function _msgData() internal view virtual returns (bytes calldata) {
680         return msg.data;
681     }
682 }
683 
684 contract ERC20 is Context, IERC20, IERC20Metadata {
685     mapping(address => uint256) private _balances;
686 
687     mapping(address => mapping(address => uint256)) private _allowances;
688 
689     uint256 private _totalSupply;
690 
691     string private _name;
692     string private _symbol;
693 
694     constructor(string memory name_, string memory symbol_) {
695         _name = name_;
696         _symbol = symbol_;
697     }
698 
699     function name() public view virtual override returns (string memory) {
700         return _name;
701     }
702 
703     function symbol() public view virtual override returns (string memory) {
704         return _symbol;
705     }
706 
707     function decimals() public view virtual override returns (uint8) {
708         return 18;
709     }
710 
711     function totalSupply() public view virtual override returns (uint256) {
712         return _totalSupply;
713     }
714 
715     function balanceOf(
716         address account
717     ) public view virtual override returns (uint256) {
718         return _balances[account];
719     }
720 
721     function transfer(
722         address to,
723         uint256 amount
724     ) public virtual override returns (bool) {
725         address owner = _msgSender();
726         _transfer(owner, to, amount);
727         return true;
728     }
729 
730     function allowance(
731         address owner,
732         address spender
733     ) public view virtual override returns (uint256) {
734         return _allowances[owner][spender];
735     }
736 
737     function approve(
738         address spender,
739         uint256 amount
740     ) public virtual override returns (bool) {
741         address owner = _msgSender();
742         _approve(owner, spender, amount);
743         return true;
744     }
745 
746     function transferFrom(
747         address from,
748         address to,
749         uint256 amount
750     ) public virtual override returns (bool) {
751         address spender = _msgSender();
752         _spendAllowance(from, spender, amount);
753         _transfer(from, to, amount);
754         return true;
755     }
756 
757     function increaseAllowance(
758         address spender,
759         uint256 addedValue
760     ) public virtual returns (bool) {
761         address owner = _msgSender();
762         _approve(owner, spender, allowance(owner, spender) + addedValue);
763         return true;
764     }
765 
766     function decreaseAllowance(
767         address spender,
768         uint256 subtractedValue
769     ) public virtual returns (bool) {
770         address owner = _msgSender();
771         uint256 currentAllowance = allowance(owner, spender);
772         require(
773             currentAllowance >= subtractedValue,
774             "ERC20: decreased allowance below zero"
775         );
776         unchecked {
777             _approve(owner, spender, currentAllowance - subtractedValue);
778         }
779 
780         return true;
781     }
782 
783     function _transfer(
784         address from,
785         address to,
786         uint256 amount
787     ) internal virtual {
788         require(from != address(0), "ERC20: transfer from the zero address");
789         require(to != address(0), "ERC20: transfer to the zero address");
790 
791         _beforeTokenTransfer(from, to, amount);
792 
793         uint256 fromBalance = _balances[from];
794         require(
795             fromBalance >= amount,
796             "ERC20: transfer amount exceeds balance"
797         );
798         unchecked {
799             _balances[from] = fromBalance - amount;
800 
801             _balances[to] += amount;
802         }
803 
804         emit Transfer(from, to, amount);
805 
806         _afterTokenTransfer(from, to, amount);
807     }
808 
809     function _mint(address account, uint256 amount) internal virtual {
810         require(account != address(0), "ERC20: mint to the zero address");
811 
812         _beforeTokenTransfer(address(0), account, amount);
813 
814         _totalSupply += amount;
815         unchecked {
816             _balances[account] += amount;
817         }
818         emit Transfer(address(0), account, amount);
819 
820         _afterTokenTransfer(address(0), account, amount);
821     }
822 
823     function _burn(address account, uint256 amount) internal virtual {
824         require(account != address(0), "ERC20: burn from the zero address");
825 
826         _beforeTokenTransfer(account, address(0), amount);
827 
828         uint256 accountBalance = _balances[account];
829         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
830         unchecked {
831             _balances[account] = accountBalance - amount;
832 
833             _totalSupply -= amount;
834         }
835 
836         emit Transfer(account, address(0), amount);
837 
838         _afterTokenTransfer(account, address(0), amount);
839     }
840 
841     function _approve(
842         address owner,
843         address spender,
844         uint256 amount
845     ) internal virtual {
846         require(owner != address(0), "ERC20: approve from the zero address");
847         require(spender != address(0), "ERC20: approve to the zero address");
848 
849         _allowances[owner][spender] = amount;
850         emit Approval(owner, spender, amount);
851     }
852 
853     function _spendAllowance(
854         address owner,
855         address spender,
856         uint256 amount
857     ) internal virtual {
858         uint256 currentAllowance = allowance(owner, spender);
859         if (currentAllowance != type(uint256).max) {
860             require(
861                 currentAllowance >= amount,
862                 "ERC20: insufficient allowance"
863             );
864             unchecked {
865                 _approve(owner, spender, currentAllowance - amount);
866             }
867         }
868     }
869 
870     function _beforeTokenTransfer(
871         address from,
872         address to,
873         uint256 amount
874     ) internal virtual {}
875 
876     function _afterTokenTransfer(
877         address from,
878         address to,
879         uint256 amount
880     ) internal virtual {}
881 }
882 
883 abstract contract Ownable is Context {
884     address private _owner;
885 
886     event OwnershipTransferred(
887         address indexed previousOwner,
888         address indexed newOwner
889     );
890 
891     constructor() {
892         _transferOwnership(_msgSender());
893     }
894 
895     modifier onlyOwner() {
896         _checkOwner();
897         _;
898     }
899 
900     function owner() public view virtual returns (address) {
901         return _owner;
902     }
903 
904     function _checkOwner() internal view virtual {
905         require(owner() == _msgSender(), "Ownable: caller is not the owner");
906     }
907 
908     function renounceOwnership() public virtual onlyOwner {
909         _transferOwnership(address(0));
910     }
911 
912     function transferOwnership(address newOwner) public virtual onlyOwner {
913         require(
914             newOwner != address(0),
915             "Ownable: new owner is the zero address"
916         );
917         _transferOwnership(newOwner);
918     }
919 
920     function _transferOwnership(address newOwner) internal virtual {
921         address oldOwner = _owner;
922         _owner = newOwner;
923         emit OwnershipTransferred(oldOwner, newOwner);
924     }
925 }
926 
927 contract LARRYV2 is Ownable, ReentrancyGuard, ERC20 {
928     using SafeERC20 for IERC20;
929 
930     uint256 public liquidityTaxBuy;
931     uint256 public liquidityTaxSell;
932 
933     uint256 public marketingTaxBuy;
934     uint256 public marketingTaxSell;
935 
936     uint256 public immutable denominator;
937 
938     uint256 public liquidityTokenAmount;
939     uint256 public marketingTokenAmount;
940 
941     address public marketingWallet;
942 
943     bool private swapping;
944     uint256 public swapTokensAtAmount;
945     bool public isSwapBackEnabled;
946 
947     IUniswapV2Router02 public immutable uniswapV2Router;
948     address public immutable uniswapV2Pair;
949 
950     uint256 public maxWalletLimit;
951 
952     mapping(address => bool) private _isAutomatedMarketMakerPair;
953     mapping(address => bool) private _isExcludedFromFees;
954     mapping(address => bool) private _isExcludedFromMaxWalletLimit;
955 
956     modifier inSwap() {
957         swapping = true;
958         _;
959         swapping = false;
960     }
961 
962     event UpdateBuyTax(uint256 liquidityTaxBuy, uint256 marketingTaxBuy);
963     event UpdateSellTax(uint256 liquidityTaxSell, uint256 marketingTaxSell);
964     event UpdateMarketingWallet(address indexed marketingWallet);
965     event UpdateMaxWalletLimit(uint256 maxWalletLimit);
966       event UpdateExcludeFromMaxWalletLimit(
967         address indexed account,
968         bool isExcluded
969     );
970     event UpdateSwapTokensAtAmount(uint256 swapTokensAtAmount);
971     event UpdateSwapBackStatus(bool status);
972     event UpdateAutomatedMarketMakerPair(address indexed pair, bool status);
973     event UpdateExcludeFromFees(address indexed account, bool isExcluded);
974 
975     constructor() ERC20("LARRY V2", "LARRY.V2") {
976         _mint(owner(), 44_000_000_000 * (10 ** 18));
977 
978         liquidityTaxBuy = 0;
979         liquidityTaxSell = 0;
980 
981         marketingTaxBuy = 200;
982         marketingTaxSell = 1000;
983 
984         denominator = 10_000;
985 
986         marketingWallet = 0xc02E77eCe604d5c8D882AEf51023934e25Ef7241;
987 
988         swapTokensAtAmount = totalSupply() / 100_000;
989         isSwapBackEnabled = true;
990 
991         address router = getRouterAddress();
992         uniswapV2Router = IUniswapV2Router02(router);
993         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
994             address(this),
995             uniswapV2Router.WETH()
996         );
997 
998         _approve(address(this), address(uniswapV2Router), type(uint256).max);
999 
1000         maxWalletLimit = 200;
1001 
1002         _isAutomatedMarketMakerPair[address(uniswapV2Pair)] = true;
1003 
1004         _isExcludedFromMaxWalletLimit[address(0xdead)] = true;
1005         _isExcludedFromMaxWalletLimit[address(owner())] = true;
1006         _isExcludedFromMaxWalletLimit[address(this)] = true;
1007         _isExcludedFromMaxWalletLimit[address(uniswapV2Router)] = true;
1008         _isExcludedFromMaxWalletLimit[address(uniswapV2Pair)] = true;
1009 
1010         _isExcludedFromFees[address(0xdead)] = true;
1011         _isExcludedFromFees[address(owner())] = true;
1012         _isExcludedFromFees[address(this)] = true;
1013         _isExcludedFromFees[address(uniswapV2Router)] = true;
1014     }
1015 
1016     receive() external payable {}
1017 
1018     fallback() external payable {}
1019 
1020     function isContract(address account) internal view returns (bool) {
1021         return account.code.length > 0;
1022     }
1023 
1024     function getRouterAddress() public view returns (address) {
1025         if (block.chainid == 56) {
1026             return 0x10ED43C718714eb63d5aA57B78B54704E256024E;
1027         } else if (block.chainid == 97) {
1028             return 0xD99D1c33F9fC3444f8101754aBC46c52416550D1;
1029         } else if (block.chainid == 1 || block.chainid == 5) {
1030             return 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
1031         } else {
1032             revert("Cannot found router on this network");
1033         }
1034     }
1035 
1036     function claimStuckTokens(address token) external onlyOwner {
1037         require(token != address(this), "Owner cannot claim native tokens");
1038 
1039         if (token == address(0x0)) {
1040             payable(msg.sender).transfer(address(this).balance);
1041             return;
1042         }
1043         IERC20 ERC20token = IERC20(token);
1044         uint256 balance = ERC20token.balanceOf(address(this));
1045         ERC20token.safeTransfer(msg.sender, balance);
1046     }
1047 
1048     function setBuyTax(
1049         uint256 _liquidityTaxBuy,
1050         uint256 _marketingTaxBuy
1051     ) external onlyOwner {
1052         require(
1053             liquidityTaxBuy != _liquidityTaxBuy ||
1054                 marketingTaxBuy != _marketingTaxBuy,
1055             "Buy Tax already on that amount"
1056         );
1057         require(
1058             _liquidityTaxBuy + _marketingTaxBuy <= 4_000,
1059             "Buy Tax cannot be more than 10%"
1060         );
1061 
1062         liquidityTaxBuy = _liquidityTaxBuy;
1063         marketingTaxBuy = _marketingTaxBuy;
1064 
1065         emit UpdateBuyTax(_liquidityTaxBuy, _marketingTaxBuy);
1066     }
1067 
1068     function setSellTax(
1069         uint256 _liquidityTaxSell,
1070         uint256 _marketingTaxSell
1071     ) external onlyOwner {
1072         require(
1073             liquidityTaxSell != _liquidityTaxSell ||
1074                 marketingTaxSell != _marketingTaxSell,
1075             "Sell Tax already on that amount"
1076         );
1077         require(
1078             _liquidityTaxSell + _marketingTaxSell <= 4_000,
1079             "Sell Tax cannot be more than 10%"
1080         );
1081 
1082         liquidityTaxSell = _liquidityTaxSell;
1083         marketingTaxSell = _marketingTaxSell;
1084 
1085         emit UpdateSellTax(_liquidityTaxSell, _marketingTaxSell);
1086     }
1087 
1088     function setMarketingWallet(address _marketingWallet) external onlyOwner {
1089         require(
1090             _marketingWallet != marketingWallet,
1091             "Marketing wallet is already that address"
1092         );
1093         require(
1094             _marketingWallet != address(0),
1095             "Marketing wallet cannot be the zero address"
1096         );
1097         require(
1098             !isContract(_marketingWallet),
1099             "Marketing wallet cannot be a contract"
1100         );
1101 
1102         marketingWallet = _marketingWallet;
1103         emit UpdateMarketingWallet(_marketingWallet);
1104     }
1105 
1106     function setSwapTokensAtAmount(uint256 amount) external onlyOwner {
1107         require(
1108             swapTokensAtAmount != amount,
1109             "SwapTokensAtAmount already on that amount"
1110         );
1111         require(
1112             amount >= totalSupply() / 1_000_000,
1113             "Amount must be equal or greater than 0.000001% of Total Supply"
1114         );
1115 
1116         swapTokensAtAmount = amount;
1117 
1118         emit UpdateSwapTokensAtAmount(amount);
1119     }
1120 
1121     function toggleSwapBack(bool status) external onlyOwner {
1122         require(isSwapBackEnabled != status, "SwapBack already on status");
1123 
1124         isSwapBackEnabled = status;
1125         emit UpdateSwapBackStatus(status);
1126     }
1127 
1128     function setMaxWalletLimit(uint256 amount) external onlyOwner {
1129         require(
1130             maxWalletLimit != amount,
1131             "maxWalletLimit already on that amount"
1132         );
1133         require(
1134             amount >= 10 && amount <= 10_000,
1135             "maxWalletLimit cannot be below 0.1% of totalSupply (10) or more than 100% of totalSupply (10000)"
1136         );
1137 
1138         maxWalletLimit = amount;
1139 
1140         emit UpdateMaxWalletLimit(amount);
1141     }
1142 
1143 
1144     function setAutomatedMarketMakerPair(
1145         address pair,
1146         bool status
1147     ) external onlyOwner {
1148         require(
1149             _isAutomatedMarketMakerPair[pair] != status,
1150             "Pair address is already the value of 'status'"
1151         );
1152         require(pair != address(uniswapV2Pair), "Cannot set this pair");
1153 
1154         _isAutomatedMarketMakerPair[pair] = status;
1155 
1156         emit UpdateAutomatedMarketMakerPair(pair, status);
1157     }
1158 
1159     function isAutomatedMarketMakerPair(
1160         address pair
1161     ) external view returns (bool) {
1162         return _isAutomatedMarketMakerPair[pair];
1163     }
1164 
1165     function setExcludeFromFees(
1166         address account,
1167         bool excluded
1168     ) external onlyOwner {
1169         require(
1170             _isExcludedFromFees[account] != excluded,
1171             "Account is already the value of 'excluded'"
1172         );
1173         _isExcludedFromFees[account] = excluded;
1174 
1175         emit UpdateExcludeFromFees(account, excluded);
1176     }
1177 
1178     function isExcludedFromFees(address account) external view returns (bool) {
1179         return _isExcludedFromFees[account];
1180     }
1181 
1182     function setExcludeFromMaxWalletLimit(
1183         address account,
1184         bool excluded
1185     ) external onlyOwner {
1186         require(
1187             account != address(this),
1188             "State of this contract address cannot be modified"
1189         );
1190         require(
1191             _isExcludedFromMaxWalletLimit[account] != excluded,
1192             "Account is already the value of 'excluded'"
1193         );
1194         require(account != address(uniswapV2Pair), "Cannot set this pair");
1195 
1196         _isExcludedFromMaxWalletLimit[account] = excluded;
1197 
1198         emit UpdateExcludeFromMaxWalletLimit(account, excluded);
1199     }
1200 
1201     function isExcludedFromMaxWalletLimit(
1202         address account
1203     ) external view returns (bool) {
1204         return _isExcludedFromMaxWalletLimit[account];
1205     }
1206 
1207     function _transfer(
1208         address from,
1209         address to,
1210         uint256 amount
1211     ) internal override {
1212         require(from != address(0), "ERC20: transfer from the zero address");
1213         require(to != address(0), "ERC20: transfer to the zero address");
1214 
1215         if (amount == 0) {
1216             super._transfer(from, to, 0);
1217             return;
1218         }
1219 
1220         uint256 contractTokenBalance = balanceOf(address(this));
1221 
1222         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1223 
1224         if (
1225             canSwap &&
1226             !swapping &&
1227             !_isAutomatedMarketMakerPair[from] &&
1228             isSwapBackEnabled &&
1229             liquidityTokenAmount + marketingTokenAmount > 0
1230         ) {
1231             swapBack();
1232         }
1233 
1234         bool takeFee = true;
1235 
1236         if (_isExcludedFromFees[from] || _isExcludedFromFees[to] || swapping) {
1237             takeFee = false;
1238         }
1239 
1240          if (!_isExcludedFromMaxWalletLimit[to]) {
1241                 require(
1242                     balanceOf(to) + amount <=
1243                         (totalSupply() * maxWalletLimit) / denominator,
1244                     "Balance of to user cannot more than wallet limit"
1245                 );
1246             }
1247         
1248 
1249         if (takeFee) {
1250             uint256 tempLiquidityAmount;
1251             uint256 tempMarketingAmount;
1252 
1253             if (_isAutomatedMarketMakerPair[from]) {
1254                 tempLiquidityAmount = (amount * liquidityTaxBuy) / denominator;
1255                 tempMarketingAmount = (amount * marketingTaxBuy) / denominator;
1256             } else if (_isAutomatedMarketMakerPair[to]) {
1257                 tempLiquidityAmount = (amount * liquidityTaxSell) / denominator;
1258                 tempMarketingAmount = (amount * marketingTaxSell) / denominator;
1259             }
1260 
1261             liquidityTokenAmount += tempLiquidityAmount;
1262             marketingTokenAmount += tempMarketingAmount;
1263 
1264             uint256 fees = tempLiquidityAmount + tempMarketingAmount;
1265 
1266             if (fees > 0) {
1267                 amount -= fees;
1268                 super._transfer(from, address(this), fees);
1269             }
1270         }
1271 
1272         super._transfer(from, to, amount);
1273     }
1274 
1275     function swapBack() internal inSwap {
1276         address[] memory path = new address[](2);
1277         path[0] = address(this);
1278         path[1] = uniswapV2Router.WETH();
1279 
1280         uint256 contractTokenBalance = balanceOf(address(this));
1281 
1282         uint256 totalTax = liquidityTokenAmount + marketingTokenAmount;
1283 
1284         uint256 liquifyToken = (contractTokenBalance *
1285             (liquidityTokenAmount / 2)) / totalTax;
1286 
1287         uint256 swapBackAmount = contractTokenBalance - liquifyToken;
1288 
1289         totalTax -= (liquidityTokenAmount) / 2;
1290 
1291         try
1292             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1293                 swapBackAmount,
1294                 0,
1295                 path,
1296                 address(this),
1297                 block.timestamp
1298             )
1299         {} catch {
1300             return;
1301         }
1302 
1303         uint256 newBalance = address(this).balance;
1304 
1305         uint256 marketingBNB = (newBalance * marketingTokenAmount) / totalTax;
1306         uint256 liquifyBNB = newBalance - marketingBNB;
1307 
1308         if (liquifyToken > 0 && liquifyBNB > 0) {
1309             try
1310                 uniswapV2Router.addLiquidityETH{value: liquifyBNB}(
1311                     address(this),
1312                     liquifyToken,
1313                     0,
1314                     0,
1315                     address(0xdead),
1316                     block.timestamp
1317                 )
1318             {} catch {}
1319         }
1320 
1321         if (marketingBNB > 0) {
1322             sendBNB(marketingWallet, marketingBNB);
1323         }
1324 
1325         liquidityTokenAmount = 0;
1326         marketingTokenAmount = 0;
1327     }
1328 
1329     function sendBNB(
1330         address _to,
1331         uint256 amount
1332     ) internal nonReentrant returns (bool) {
1333         if (address(this).balance < amount) return false;
1334 
1335         (bool success, ) = payable(_to).call{value: amount}("");
1336 
1337         return success;
1338     }
1339 
1340     function manualSwapBack() external {
1341         uint256 contractTokenBalance = balanceOf(address(this));
1342 
1343         require(contractTokenBalance > 0, "Cant Swap Back 0 Token!");
1344 
1345         swapBack();
1346     }
1347 }