1 /**
2  *Submitted for verification at Etherscan.io on 2023-07-07
3 */
4 
5 /**
6 https://medium.com/@sFLOKI
7 https://twitter.com/sFloki_ERC
8 https://t.me/sFLOKIENTRY
9 
10 Web v1: https://sFloki.com/
11 
12 */
13 
14 // SPDX-License-Identifier: MIT
15 
16 pragma solidity 0.8.19;
17 
18 interface IUniswapV2Router01 {
19     function factory() external pure returns (address);
20 
21     function WETH() external pure returns (address);
22 
23     function addLiquidity(
24         address tokenA,
25         address tokenB,
26         uint amountADesired,
27         uint amountBDesired,
28         uint amountAMin,
29         uint amountBMin,
30         address to,
31         uint deadline
32     ) external returns (uint amountA, uint amountB, uint liquidity);
33 
34     function addLiquidityETH(
35         address token,
36         uint amountTokenDesired,
37         uint amountTokenMin,
38         uint amountETHMin,
39         address to,
40         uint deadline
41     )
42         external
43         payable
44         returns (uint amountToken, uint amountETH, uint liquidity);
45 
46     function removeLiquidity(
47         address tokenA,
48         address tokenB,
49         uint liquidity,
50         uint amountAMin,
51         uint amountBMin,
52         address to,
53         uint deadline
54     ) external returns (uint amountA, uint amountB);
55 
56     function removeLiquidityETH(
57         address token,
58         uint liquidity,
59         uint amountTokenMin,
60         uint amountETHMin,
61         address to,
62         uint deadline
63     ) external returns (uint amountToken, uint amountETH);
64 
65     function removeLiquidityWithPermit(
66         address tokenA,
67         address tokenB,
68         uint liquidity,
69         uint amountAMin,
70         uint amountBMin,
71         address to,
72         uint deadline,
73         bool approveMax,
74         uint8 v,
75         bytes32 r,
76         bytes32 s
77     ) external returns (uint amountA, uint amountB);
78 
79     function removeLiquidityETHWithPermit(
80         address token,
81         uint liquidity,
82         uint amountTokenMin,
83         uint amountETHMin,
84         address to,
85         uint deadline,
86         bool approveMax,
87         uint8 v,
88         bytes32 r,
89         bytes32 s
90     ) external returns (uint amountToken, uint amountETH);
91 
92     function swapExactTokensForTokens(
93         uint amountIn,
94         uint amountOutMin,
95         address[] calldata path,
96         address to,
97         uint deadline
98     ) external returns (uint[] memory amounts);
99 
100     function swapTokensForExactTokens(
101         uint amountOut,
102         uint amountInMax,
103         address[] calldata path,
104         address to,
105         uint deadline
106     ) external returns (uint[] memory amounts);
107 
108     function swapExactETHForTokens(
109         uint amountOutMin,
110         address[] calldata path,
111         address to,
112         uint deadline
113     ) external payable returns (uint[] memory amounts);
114 
115     function swapTokensForExactETH(
116         uint amountOut,
117         uint amountInMax,
118         address[] calldata path,
119         address to,
120         uint deadline
121     ) external returns (uint[] memory amounts);
122 
123     function swapExactTokensForETH(
124         uint amountIn,
125         uint amountOutMin,
126         address[] calldata path,
127         address to,
128         uint deadline
129     ) external returns (uint[] memory amounts);
130 
131     function swapETHForExactTokens(
132         uint amountOut,
133         address[] calldata path,
134         address to,
135         uint deadline
136     ) external payable returns (uint[] memory amounts);
137 
138     function quote(
139         uint amountA,
140         uint reserveA,
141         uint reserveB
142     ) external pure returns (uint amountB);
143 
144     function getAmountOut(
145         uint amountIn,
146         uint reserveIn,
147         uint reserveOut
148     ) external pure returns (uint amountOut);
149 
150     function getAmountIn(
151         uint amountOut,
152         uint reserveIn,
153         uint reserveOut
154     ) external pure returns (uint amountIn);
155 
156     function getAmountsOut(
157         uint amountIn,
158         address[] calldata path
159     ) external view returns (uint[] memory amounts);
160 
161     function getAmountsIn(
162         uint amountOut,
163         address[] calldata path
164     ) external view returns (uint[] memory amounts);
165 }
166 
167 interface IUniswapV2Router02 is IUniswapV2Router01 {
168     function removeLiquidityETHSupportingFeeOnTransferTokens(
169         address token,
170         uint liquidity,
171         uint amountTokenMin,
172         uint amountETHMin,
173         address to,
174         uint deadline
175     ) external returns (uint amountETH);
176 
177     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
178         address token,
179         uint liquidity,
180         uint amountTokenMin,
181         uint amountETHMin,
182         address to,
183         uint deadline,
184         bool approveMax,
185         uint8 v,
186         bytes32 r,
187         bytes32 s
188     ) external returns (uint amountETH);
189 
190     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
191         uint amountIn,
192         uint amountOutMin,
193         address[] calldata path,
194         address to,
195         uint deadline
196     ) external;
197 
198     function swapExactETHForTokensSupportingFeeOnTransferTokens(
199         uint amountOutMin,
200         address[] calldata path,
201         address to,
202         uint deadline
203     ) external payable;
204 
205     function swapExactTokensForETHSupportingFeeOnTransferTokens(
206         uint amountIn,
207         uint amountOutMin,
208         address[] calldata path,
209         address to,
210         uint deadline
211     ) external;
212 }
213 
214 interface IUniswapV2Factory {
215     event PairCreated(
216         address indexed token0,
217         address indexed token1,
218         address pair,
219         uint
220     );
221 
222     function feeTo() external view returns (address);
223 
224     function feeToSetter() external view returns (address);
225 
226     function getPair(
227         address tokenA,
228         address tokenB
229     ) external view returns (address pair);
230 
231     function allPairs(uint) external view returns (address pair);
232 
233     function allPairsLength() external view returns (uint);
234 
235     function createPair(
236         address tokenA,
237         address tokenB
238     ) external returns (address pair);
239 
240     function setFeeTo(address) external;
241 
242     function setFeeToSetter(address) external;
243 }
244 
245 library Address {
246     function isContract(address account) internal view returns (bool) {
247         return account.code.length > 0;
248     }
249 
250     function sendValue(address payable recipient, uint256 amount) internal {
251         require(
252             address(this).balance >= amount,
253             "Address: insufficient balance"
254         );
255 
256         (bool success, ) = recipient.call{value: amount}("");
257         require(
258             success,
259             "Address: unable to send value, recipient may have reverted"
260         );
261     }
262 
263     function functionCall(
264         address target,
265         bytes memory data
266     ) internal returns (bytes memory) {
267         return
268             functionCallWithValue(
269                 target,
270                 data,
271                 0,
272                 "Address: low-level call failed"
273             );
274     }
275 
276     function functionCall(
277         address target,
278         bytes memory data,
279         string memory errorMessage
280     ) internal returns (bytes memory) {
281         return functionCallWithValue(target, data, 0, errorMessage);
282     }
283 
284     function functionCallWithValue(
285         address target,
286         bytes memory data,
287         uint256 value
288     ) internal returns (bytes memory) {
289         return
290             functionCallWithValue(
291                 target,
292                 data,
293                 value,
294                 "Address: low-level call with value failed"
295             );
296     }
297 
298     function functionCallWithValue(
299         address target,
300         bytes memory data,
301         uint256 value,
302         string memory errorMessage
303     ) internal returns (bytes memory) {
304         require(
305             address(this).balance >= value,
306             "Address: insufficient balance for call"
307         );
308         (bool success, bytes memory returndata) = target.call{value: value}(
309             data
310         );
311         return
312             verifyCallResultFromTarget(
313                 target,
314                 success,
315                 returndata,
316                 errorMessage
317             );
318     }
319 
320     function functionStaticCall(
321         address target,
322         bytes memory data
323     ) internal view returns (bytes memory) {
324         return
325             functionStaticCall(
326                 target,
327                 data,
328                 "Address: low-level static call failed"
329             );
330     }
331 
332     function functionStaticCall(
333         address target,
334         bytes memory data,
335         string memory errorMessage
336     ) internal view returns (bytes memory) {
337         (bool success, bytes memory returndata) = target.staticcall(data);
338         return
339             verifyCallResultFromTarget(
340                 target,
341                 success,
342                 returndata,
343                 errorMessage
344             );
345     }
346 
347     function functionDelegateCall(
348         address target,
349         bytes memory data
350     ) internal returns (bytes memory) {
351         return
352             functionDelegateCall(
353                 target,
354                 data,
355                 "Address: low-level delegate call failed"
356             );
357     }
358 
359     function functionDelegateCall(
360         address target,
361         bytes memory data,
362         string memory errorMessage
363     ) internal returns (bytes memory) {
364         (bool success, bytes memory returndata) = target.delegatecall(data);
365         return
366             verifyCallResultFromTarget(
367                 target,
368                 success,
369                 returndata,
370                 errorMessage
371             );
372     }
373 
374     function verifyCallResultFromTarget(
375         address target,
376         bool success,
377         bytes memory returndata,
378         string memory errorMessage
379     ) internal view returns (bytes memory) {
380         if (success) {
381             if (returndata.length == 0) {
382                 require(isContract(target), "Address: call to non-contract");
383             }
384             return returndata;
385         } else {
386             _revert(returndata, errorMessage);
387         }
388     }
389 
390     function verifyCallResult(
391         bool success,
392         bytes memory returndata,
393         string memory errorMessage
394     ) internal pure returns (bytes memory) {
395         if (success) {
396             return returndata;
397         } else {
398             _revert(returndata, errorMessage);
399         }
400     }
401 
402     function _revert(
403         bytes memory returndata,
404         string memory errorMessage
405     ) private pure {
406         if (returndata.length > 0) {
407             /// @solidity memory-safe-assembly
408             assembly {
409                 let returndata_size := mload(returndata)
410                 revert(add(32, returndata), returndata_size)
411             }
412         } else {
413             revert(errorMessage);
414         }
415     }
416 }
417 
418 interface IERC20Permit {
419     function permit(
420         address owner,
421         address spender,
422         uint256 value,
423         uint256 deadline,
424         uint8 v,
425         bytes32 r,
426         bytes32 s
427     ) external;
428 
429     function nonces(address owner) external view returns (uint256);
430 
431     // solhint-disable-next-line func-name-mixedcase
432     function DOMAIN_SEPARATOR() external view returns (bytes32);
433 }
434 
435 interface IERC20 {
436     event Transfer(address indexed from, address indexed to, uint256 value);
437 
438     event Approval(
439         address indexed owner,
440         address indexed spender,
441         uint256 value
442     );
443 
444     function totalSupply() external view returns (uint256);
445 
446     function balanceOf(address account) external view returns (uint256);
447 
448     function transfer(address to, uint256 amount) external returns (bool);
449 
450     function allowance(
451         address owner,
452         address spender
453     ) external view returns (uint256);
454 
455     function approve(address spender, uint256 amount) external returns (bool);
456 
457     function transferFrom(
458         address from,
459         address to,
460         uint256 amount
461     ) external returns (bool);
462 }
463 
464 library SafeERC20 {
465     using Address for address;
466 
467     function safeTransfer(IERC20 token, address to, uint256 value) internal {
468         _callOptionalReturn(
469             token,
470             abi.encodeWithSelector(token.transfer.selector, to, value)
471         );
472     }
473 
474     function safeTransferFrom(
475         IERC20 token,
476         address from,
477         address to,
478         uint256 value
479     ) internal {
480         _callOptionalReturn(
481             token,
482             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
483         );
484     }
485 
486     function safeApprove(
487         IERC20 token,
488         address spender,
489         uint256 value
490     ) internal {
491         require(
492             (value == 0) || (token.allowance(address(this), spender) == 0),
493             "SafeERC20: approve from non-zero to non-zero allowance"
494         );
495         _callOptionalReturn(
496             token,
497             abi.encodeWithSelector(token.approve.selector, spender, value)
498         );
499     }
500 
501     function safeIncreaseAllowance(
502         IERC20 token,
503         address spender,
504         uint256 value
505     ) internal {
506         uint256 oldAllowance = token.allowance(address(this), spender);
507         _callOptionalReturn(
508             token,
509             abi.encodeWithSelector(
510                 token.approve.selector,
511                 spender,
512                 oldAllowance + value
513             )
514         );
515     }
516 
517     function safeDecreaseAllowance(
518         IERC20 token,
519         address spender,
520         uint256 value
521     ) internal {
522         unchecked {
523             uint256 oldAllowance = token.allowance(address(this), spender);
524             require(
525                 oldAllowance >= value,
526                 "SafeERC20: decreased allowance below zero"
527             );
528             _callOptionalReturn(
529                 token,
530                 abi.encodeWithSelector(
531                     token.approve.selector,
532                     spender,
533                     oldAllowance - value
534                 )
535             );
536         }
537     }
538 
539     function forceApprove(
540         IERC20 token,
541         address spender,
542         uint256 value
543     ) internal {
544         bytes memory approvalCall = abi.encodeWithSelector(
545             token.approve.selector,
546             spender,
547             value
548         );
549 
550         if (!_callOptionalReturnBool(token, approvalCall)) {
551             _callOptionalReturn(
552                 token,
553                 abi.encodeWithSelector(token.approve.selector, spender, 0)
554             );
555             _callOptionalReturn(token, approvalCall);
556         }
557     }
558 
559     function safePermit(
560         IERC20Permit token,
561         address owner,
562         address spender,
563         uint256 value,
564         uint256 deadline,
565         uint8 v,
566         bytes32 r,
567         bytes32 s
568     ) internal {
569         uint256 nonceBefore = token.nonces(owner);
570         token.permit(owner, spender, value, deadline, v, r, s);
571         uint256 nonceAfter = token.nonces(owner);
572         require(
573             nonceAfter == nonceBefore + 1,
574             "SafeERC20: permit did not succeed"
575         );
576     }
577 
578     function _callOptionalReturn(IERC20 token, bytes memory data) private {
579         bytes memory returndata = address(token).functionCall(
580             data,
581             "SafeERC20: low-level call failed"
582         );
583         require(
584             returndata.length == 0 || abi.decode(returndata, (bool)),
585             "SafeERC20: ERC20 operation did not succeed"
586         );
587     }
588 
589     function _callOptionalReturnBool(
590         IERC20 token,
591         bytes memory data
592     ) private returns (bool) {
593         (bool success, bytes memory returndata) = address(token).call(data);
594         return
595             success &&
596             (returndata.length == 0 || abi.decode(returndata, (bool))) &&
597             Address.isContract(address(token));
598     }
599 }
600 
601 interface IERC20Metadata is IERC20 {
602     function name() external view returns (string memory);
603 
604     function symbol() external view returns (string memory);
605 
606     function decimals() external view returns (uint8);
607 }
608 
609 abstract contract ReentrancyGuard {
610     uint256 private constant _NOT_ENTERED = 1;
611     uint256 private constant _ENTERED = 2;
612 
613     uint256 private _status;
614 
615     constructor() {
616         _status = _NOT_ENTERED;
617     }
618 
619     modifier nonReentrant() {
620         _nonReentrantBefore();
621         _;
622         _nonReentrantAfter();
623     }
624 
625     function _nonReentrantBefore() private {
626         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
627 
628         _status = _ENTERED;
629     }
630 
631     function _nonReentrantAfter() private {
632         _status = _NOT_ENTERED;
633     }
634 
635     function _reentrancyGuardEntered() internal view returns (bool) {
636         return _status == _ENTERED;
637     }
638 }
639 
640 abstract contract Context {
641     function _msgSender() internal view virtual returns (address) {
642         return msg.sender;
643     }
644 
645     function _msgData() internal view virtual returns (bytes calldata) {
646         return msg.data;
647     }
648 }
649 
650 contract ERC20 is Context, IERC20, IERC20Metadata {
651     mapping(address => uint256) private _balances;
652 
653     mapping(address => mapping(address => uint256)) private _allowances;
654 
655     uint256 private _totalSupply;
656 
657     string private _name;
658     string private _symbol;
659 
660     constructor(string memory name_, string memory symbol_) {
661         _name = name_;
662         _symbol = symbol_;
663     }
664 
665     function name() public view virtual override returns (string memory) {
666         return _name;
667     }
668 
669     function symbol() public view virtual override returns (string memory) {
670         return _symbol;
671     }
672 
673     function decimals() public view virtual override returns (uint8) {
674         return 18;
675     }
676 
677     function totalSupply() public view virtual override returns (uint256) {
678         return _totalSupply;
679     }
680 
681     function balanceOf(
682         address account
683     ) public view virtual override returns (uint256) {
684         return _balances[account];
685     }
686 
687     function transfer(
688         address to,
689         uint256 amount
690     ) public virtual override returns (bool) {
691         address owner = _msgSender();
692         _transfer(owner, to, amount);
693         return true;
694     }
695 
696     function allowance(
697         address owner,
698         address spender
699     ) public view virtual override returns (uint256) {
700         return _allowances[owner][spender];
701     }
702 
703     function approve(
704         address spender,
705         uint256 amount
706     ) public virtual override returns (bool) {
707         address owner = _msgSender();
708         _approve(owner, spender, amount);
709         return true;
710     }
711 
712     function transferFrom(
713         address from,
714         address to,
715         uint256 amount
716     ) public virtual override returns (bool) {
717         address spender = _msgSender();
718         _spendAllowance(from, spender, amount);
719         _transfer(from, to, amount);
720         return true;
721     }
722 
723     function increaseAllowance(
724         address spender,
725         uint256 addedValue
726     ) public virtual returns (bool) {
727         address owner = _msgSender();
728         _approve(owner, spender, allowance(owner, spender) + addedValue);
729         return true;
730     }
731 
732     function decreaseAllowance(
733         address spender,
734         uint256 subtractedValue
735     ) public virtual returns (bool) {
736         address owner = _msgSender();
737         uint256 currentAllowance = allowance(owner, spender);
738         require(
739             currentAllowance >= subtractedValue,
740             "ERC20: decreased allowance below zero"
741         );
742         unchecked {
743             _approve(owner, spender, currentAllowance - subtractedValue);
744         }
745 
746         return true;
747     }
748 
749     function _transfer(
750         address from,
751         address to,
752         uint256 amount
753     ) internal virtual {
754         require(from != address(0), "ERC20: transfer from the zero address");
755         require(to != address(0), "ERC20: transfer to the zero address");
756 
757         _beforeTokenTransfer(from, to, amount);
758 
759         uint256 fromBalance = _balances[from];
760         require(
761             fromBalance >= amount,
762             "ERC20: transfer amount exceeds balance"
763         );
764         unchecked {
765             _balances[from] = fromBalance - amount;
766 
767             _balances[to] += amount;
768         }
769 
770         emit Transfer(from, to, amount);
771 
772         _afterTokenTransfer(from, to, amount);
773     }
774 
775     function _mint(address account, uint256 amount) internal virtual {
776         require(account != address(0), "ERC20: mint to the zero address");
777 
778         _beforeTokenTransfer(address(0), account, amount);
779 
780         _totalSupply += amount;
781         unchecked {
782             _balances[account] += amount;
783         }
784         emit Transfer(address(0), account, amount);
785 
786         _afterTokenTransfer(address(0), account, amount);
787     }
788 
789     function _burn(address account, uint256 amount) internal virtual {
790         require(account != address(0), "ERC20: burn from the zero address");
791 
792         _beforeTokenTransfer(account, address(0), amount);
793 
794         uint256 accountBalance = _balances[account];
795         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
796         unchecked {
797             _balances[account] = accountBalance - amount;
798 
799             _totalSupply -= amount;
800         }
801 
802         emit Transfer(account, address(0), amount);
803 
804         _afterTokenTransfer(account, address(0), amount);
805     }
806 
807     function _approve(
808         address owner,
809         address spender,
810         uint256 amount
811     ) internal virtual {
812         require(owner != address(0), "ERC20: approve from the zero address");
813         require(spender != address(0), "ERC20: approve to the zero address");
814 
815         _allowances[owner][spender] = amount;
816         emit Approval(owner, spender, amount);
817     }
818 
819     function _spendAllowance(
820         address owner,
821         address spender,
822         uint256 amount
823     ) internal virtual {
824         uint256 currentAllowance = allowance(owner, spender);
825         if (currentAllowance != type(uint256).max) {
826             require(
827                 currentAllowance >= amount,
828                 "ERC20: insufficient allowance"
829             );
830             unchecked {
831                 _approve(owner, spender, currentAllowance - amount);
832             }
833         }
834     }
835 
836     function _beforeTokenTransfer(
837         address from,
838         address to,
839         uint256 amount
840     ) internal virtual {}
841 
842     function _afterTokenTransfer(
843         address from,
844         address to,
845         uint256 amount
846     ) internal virtual {}
847 }
848 
849 abstract contract Ownable is Context {
850     address private _owner;
851 
852     event OwnershipTransferred(
853         address indexed previousOwner,
854         address indexed newOwner
855     );
856 
857     constructor() {
858         _transferOwnership(_msgSender());
859     }
860 
861     modifier onlyOwner() {
862         _checkOwner();
863         _;
864     }
865 
866     function owner() public view virtual returns (address) {
867         return _owner;
868     }
869 
870     function _checkOwner() internal view virtual {
871         require(owner() == _msgSender(), "Ownable: caller is not the owner");
872     }
873 
874     function renounceOwnership() public virtual onlyOwner {
875         _transferOwnership(address(0));
876     }
877 
878     function transferOwnership(address newOwner) public virtual onlyOwner {
879         require(
880             newOwner != address(0),
881             "Ownable: new owner is the zero address"
882         );
883         _transferOwnership(newOwner);
884     }
885 
886     function _transferOwnership(address newOwner) internal virtual {
887         address oldOwner = _owner;
888         _owner = newOwner;
889         emit OwnershipTransferred(oldOwner, newOwner);
890     }
891 }
892 
893 contract sFLOKI is Ownable, ReentrancyGuard, ERC20 {
894     using SafeERC20 for IERC20;
895 
896     uint256 public liquidityTaxBuy;
897     uint256 public liquidityTaxSell;
898 
899     uint256 public marketingTaxBuy;
900     uint256 public marketingTaxSell;
901 
902     uint256 public immutable denominator;
903 
904     uint256 public liquidityTokenAmount;
905     uint256 public marketingTokenAmount;
906 
907     address public marketingWallet;
908 
909     bool private swapping;
910     uint256 public swapTokensAtAmount;
911     bool public isSwapBackEnabled;
912 
913     IUniswapV2Router02 public immutable uniswapV2Router;
914     address public immutable uniswapV2Pair;
915 
916     uint256 public maxWalletLimit;
917 
918     mapping(address => bool) private _isAutomatedMarketMakerPair;
919     mapping(address => bool) private _isExcludedFromFees;
920     mapping(address => bool) private _isExcludedFromMaxWalletLimit;
921 
922     modifier inSwap() {
923         swapping = true;
924         _;
925         swapping = false;
926     }
927 
928     event UpdateBuyTax(uint256 liquidityTaxBuy, uint256 marketingTaxBuy);
929     event UpdateSellTax(uint256 liquidityTaxSell, uint256 marketingTaxSell);
930     event UpdateMarketingWallet(address indexed marketingWallet);
931     event UpdateMaxWalletLimit(uint256 maxWalletLimit);
932       event UpdateExcludeFromMaxWalletLimit(
933         address indexed account,
934         bool isExcluded
935     );
936     event UpdateSwapTokensAtAmount(uint256 swapTokensAtAmount);
937     event UpdateSwapBackStatus(bool status);
938     event UpdateAutomatedMarketMakerPair(address indexed pair, bool status);
939     event UpdateExcludeFromFees(address indexed account, bool isExcluded);
940 
941     constructor() ERC20("STAKED FLOKI", "sFLOKI") {
942         _mint(owner(), 10_000_000_000 * (10 ** 18));
943 
944         liquidityTaxBuy = 0;
945         liquidityTaxSell = 0;
946 
947         marketingTaxBuy = 2000;
948         marketingTaxSell = 2000;
949 
950         denominator = 10_000;
951 
952         marketingWallet = 0x0Fe0DD81718F6e48B877B9D3E0b241eBd7b8D76c;
953 
954         swapTokensAtAmount = totalSupply() / 100_000;
955         isSwapBackEnabled = true;
956 
957         address router = getRouterAddress();
958         uniswapV2Router = IUniswapV2Router02(router);
959         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
960             address(this),
961             uniswapV2Router.WETH()
962         );
963 
964         _approve(address(this), address(uniswapV2Router), type(uint256).max);
965 
966         maxWalletLimit = 200;
967 
968         _isAutomatedMarketMakerPair[address(uniswapV2Pair)] = true;
969 
970         _isExcludedFromMaxWalletLimit[address(0xdead)] = true;
971         _isExcludedFromMaxWalletLimit[address(owner())] = true;
972         _isExcludedFromMaxWalletLimit[address(this)] = true;
973         _isExcludedFromMaxWalletLimit[address(uniswapV2Router)] = true;
974         _isExcludedFromMaxWalletLimit[address(uniswapV2Pair)] = true;
975 
976         _isExcludedFromFees[address(0xdead)] = true;
977         _isExcludedFromFees[address(owner())] = true;
978         _isExcludedFromFees[address(this)] = true;
979         _isExcludedFromFees[address(uniswapV2Router)] = true;
980     }
981 
982     receive() external payable {}
983 
984     fallback() external payable {}
985 
986     function isContract(address account) internal view returns (bool) {
987         return account.code.length > 0;
988     }
989 
990     function getRouterAddress() public view returns (address) {
991         if (block.chainid == 56) {
992             return 0x10ED43C718714eb63d5aA57B78B54704E256024E;
993         } else if (block.chainid == 97) {
994             return 0xD99D1c33F9fC3444f8101754aBC46c52416550D1;
995         } else if (block.chainid == 1 || block.chainid == 5) {
996             return 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
997         } else {
998             revert("Cannot found router on this network");
999         }
1000     }
1001 
1002     function claimStuckTokens(address token) external onlyOwner {
1003         require(token != address(this), "Owner cannot claim native tokens");
1004 
1005         if (token == address(0x0)) {
1006             payable(msg.sender).transfer(address(this).balance);
1007             return;
1008         }
1009         IERC20 ERC20token = IERC20(token);
1010         uint256 balance = ERC20token.balanceOf(address(this));
1011         ERC20token.safeTransfer(msg.sender, balance);
1012     }
1013 
1014     function setBuyTax(
1015         uint256 _liquidityTaxBuy,
1016         uint256 _marketingTaxBuy
1017     ) external onlyOwner {
1018         require(
1019             liquidityTaxBuy != _liquidityTaxBuy ||
1020                 marketingTaxBuy != _marketingTaxBuy,
1021             "Buy Tax already on that amount"
1022         );
1023         require(
1024             _liquidityTaxBuy + _marketingTaxBuy <= 4_000,
1025             "Buy Tax cannot be more than 10%"
1026         );
1027 
1028         liquidityTaxBuy = _liquidityTaxBuy;
1029         marketingTaxBuy = _marketingTaxBuy;
1030 
1031         emit UpdateBuyTax(_liquidityTaxBuy, _marketingTaxBuy);
1032     }
1033 
1034     function setSellTax(
1035         uint256 _liquidityTaxSell,
1036         uint256 _marketingTaxSell
1037     ) external onlyOwner {
1038         require(
1039             liquidityTaxSell != _liquidityTaxSell ||
1040                 marketingTaxSell != _marketingTaxSell,
1041             "Sell Tax already on that amount"
1042         );
1043         require(
1044             _liquidityTaxSell + _marketingTaxSell <= 4_000,
1045             "Sell Tax cannot be more than 10%"
1046         );
1047 
1048         liquidityTaxSell = _liquidityTaxSell;
1049         marketingTaxSell = _marketingTaxSell;
1050 
1051         emit UpdateSellTax(_liquidityTaxSell, _marketingTaxSell);
1052     }
1053 
1054     function setMarketingWallet(address _marketingWallet) external onlyOwner {
1055         require(
1056             _marketingWallet != marketingWallet,
1057             "Marketing wallet is already that address"
1058         );
1059         require(
1060             _marketingWallet != address(0),
1061             "Marketing wallet cannot be the zero address"
1062         );
1063         require(
1064             !isContract(_marketingWallet),
1065             "Marketing wallet cannot be a contract"
1066         );
1067 
1068         marketingWallet = _marketingWallet;
1069         emit UpdateMarketingWallet(_marketingWallet);
1070     }
1071 
1072     function setSwapTokensAtAmount(uint256 amount) external onlyOwner {
1073         require(
1074             swapTokensAtAmount != amount,
1075             "SwapTokensAtAmount already on that amount"
1076         );
1077         require(
1078             amount >= totalSupply() / 1_000_000,
1079             "Amount must be equal or greater than 0.000001% of Total Supply"
1080         );
1081 
1082         swapTokensAtAmount = amount;
1083 
1084         emit UpdateSwapTokensAtAmount(amount);
1085     }
1086 
1087     function toggleSwapBack(bool status) external onlyOwner {
1088         require(isSwapBackEnabled != status, "SwapBack already on status");
1089 
1090         isSwapBackEnabled = status;
1091         emit UpdateSwapBackStatus(status);
1092     }
1093 
1094     function setMaxWalletLimit(uint256 amount) external onlyOwner {
1095         require(
1096             maxWalletLimit != amount,
1097             "maxWalletLimit already on that amount"
1098         );
1099         require(
1100             amount >= 10 && amount <= 10_000,
1101             "maxWalletLimit cannot be below 0.1% of totalSupply (10) or more than 100% of totalSupply (10000)"
1102         );
1103 
1104         maxWalletLimit = amount;
1105 
1106         emit UpdateMaxWalletLimit(amount);
1107     }
1108 
1109 
1110     function setAutomatedMarketMakerPair(
1111         address pair,
1112         bool status
1113     ) external onlyOwner {
1114         require(
1115             _isAutomatedMarketMakerPair[pair] != status,
1116             "Pair address is already the value of 'status'"
1117         );
1118         require(pair != address(uniswapV2Pair), "Cannot set this pair");
1119 
1120         _isAutomatedMarketMakerPair[pair] = status;
1121 
1122         emit UpdateAutomatedMarketMakerPair(pair, status);
1123     }
1124 
1125     function isAutomatedMarketMakerPair(
1126         address pair
1127     ) external view returns (bool) {
1128         return _isAutomatedMarketMakerPair[pair];
1129     }
1130 
1131     function setExcludeFromFees(
1132         address account,
1133         bool excluded
1134     ) external onlyOwner {
1135         require(
1136             _isExcludedFromFees[account] != excluded,
1137             "Account is already the value of 'excluded'"
1138         );
1139         _isExcludedFromFees[account] = excluded;
1140 
1141         emit UpdateExcludeFromFees(account, excluded);
1142     }
1143 
1144     function isExcludedFromFees(address account) external view returns (bool) {
1145         return _isExcludedFromFees[account];
1146     }
1147 
1148     function setExcludeFromMaxWalletLimit(
1149         address account,
1150         bool excluded
1151     ) external onlyOwner {
1152         require(
1153             account != address(this),
1154             "State of this contract address cannot be modified"
1155         );
1156         require(
1157             _isExcludedFromMaxWalletLimit[account] != excluded,
1158             "Account is already the value of 'excluded'"
1159         );
1160         require(account != address(uniswapV2Pair), "Cannot set this pair");
1161 
1162         _isExcludedFromMaxWalletLimit[account] = excluded;
1163 
1164         emit UpdateExcludeFromMaxWalletLimit(account, excluded);
1165     }
1166 
1167     function isExcludedFromMaxWalletLimit(
1168         address account
1169     ) external view returns (bool) {
1170         return _isExcludedFromMaxWalletLimit[account];
1171     }
1172 
1173     function _transfer(
1174         address from,
1175         address to,
1176         uint256 amount
1177     ) internal override {
1178         require(from != address(0), "ERC20: transfer from the zero address");
1179         require(to != address(0), "ERC20: transfer to the zero address");
1180 
1181         if (amount == 0) {
1182             super._transfer(from, to, 0);
1183             return;
1184         }
1185 
1186         uint256 contractTokenBalance = balanceOf(address(this));
1187 
1188         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1189 
1190         if (
1191             canSwap &&
1192             !swapping &&
1193             !_isAutomatedMarketMakerPair[from] &&
1194             isSwapBackEnabled &&
1195             liquidityTokenAmount + marketingTokenAmount > 0
1196         ) {
1197             swapBack();
1198         }
1199 
1200         bool takeFee = true;
1201 
1202         if (_isExcludedFromFees[from] || _isExcludedFromFees[to] || swapping) {
1203             takeFee = false;
1204         }
1205 
1206          if (!_isExcludedFromMaxWalletLimit[to]) {
1207                 require(
1208                     balanceOf(to) + amount <=
1209                         (totalSupply() * maxWalletLimit) / denominator,
1210                     "Balance of to user cannot more than wallet limit"
1211                 );
1212             }
1213         
1214 
1215         if (takeFee) {
1216             uint256 tempLiquidityAmount;
1217             uint256 tempMarketingAmount;
1218 
1219             if (_isAutomatedMarketMakerPair[from]) {
1220                 tempLiquidityAmount = (amount * liquidityTaxBuy) / denominator;
1221                 tempMarketingAmount = (amount * marketingTaxBuy) / denominator;
1222             } else if (_isAutomatedMarketMakerPair[to]) {
1223                 tempLiquidityAmount = (amount * liquidityTaxSell) / denominator;
1224                 tempMarketingAmount = (amount * marketingTaxSell) / denominator;
1225             }
1226 
1227             liquidityTokenAmount += tempLiquidityAmount;
1228             marketingTokenAmount += tempMarketingAmount;
1229 
1230             uint256 fees = tempLiquidityAmount + tempMarketingAmount;
1231 
1232             if (fees > 0) {
1233                 amount -= fees;
1234                 super._transfer(from, address(this), fees);
1235             }
1236         }
1237 
1238         super._transfer(from, to, amount);
1239     }
1240 
1241     function swapBack() internal inSwap {
1242         address[] memory path = new address[](2);
1243         path[0] = address(this);
1244         path[1] = uniswapV2Router.WETH();
1245 
1246         uint256 contractTokenBalance = balanceOf(address(this));
1247 
1248         uint256 totalTax = liquidityTokenAmount + marketingTokenAmount;
1249 
1250         uint256 liquifyToken = (contractTokenBalance *
1251             (liquidityTokenAmount / 2)) / totalTax;
1252 
1253         uint256 swapBackAmount = contractTokenBalance - liquifyToken;
1254 
1255         totalTax -= (liquidityTokenAmount) / 2;
1256 
1257         try
1258             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1259                 swapBackAmount,
1260                 0,
1261                 path,
1262                 address(this),
1263                 block.timestamp
1264             )
1265         {} catch {
1266             return;
1267         }
1268 
1269         uint256 newBalance = address(this).balance;
1270 
1271         uint256 marketingBNB = (newBalance * marketingTokenAmount) / totalTax;
1272         uint256 liquifyBNB = newBalance - marketingBNB;
1273 
1274         if (liquifyToken > 0 && liquifyBNB > 0) {
1275             try
1276                 uniswapV2Router.addLiquidityETH{value: liquifyBNB}(
1277                     address(this),
1278                     liquifyToken,
1279                     0,
1280                     0,
1281                     address(0xdead),
1282                     block.timestamp
1283                 )
1284             {} catch {}
1285         }
1286 
1287         if (marketingBNB > 0) {
1288             sendBNB(marketingWallet, marketingBNB);
1289         }
1290 
1291         liquidityTokenAmount = 0;
1292         marketingTokenAmount = 0;
1293     }
1294 
1295     function sendBNB(
1296         address _to,
1297         uint256 amount
1298     ) internal nonReentrant returns (bool) {
1299         if (address(this).balance < amount) return false;
1300 
1301         (bool success, ) = payable(_to).call{value: amount}("");
1302 
1303         return success;
1304     }
1305 
1306     function manualSwapBack() external {
1307         uint256 contractTokenBalance = balanceOf(address(this));
1308 
1309         require(contractTokenBalance > 0, "Cant Swap Back 0 Token!");
1310 
1311         swapBack();
1312     }
1313 }