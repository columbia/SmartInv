1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.19;
4 
5 interface IUniswapV2Router01 {
6     function factory() external pure returns (address);
7 
8     function WETH() external pure returns (address);
9 
10     function addLiquidity(
11         address tokenA,
12         address tokenB,
13         uint amountADesired,
14         uint amountBDesired,
15         uint amountAMin,
16         uint amountBMin,
17         address to,
18         uint deadline
19     ) external returns (uint amountA, uint amountB, uint liquidity);
20 
21     function addLiquidityETH(
22         address token,
23         uint amountTokenDesired,
24         uint amountTokenMin,
25         uint amountETHMin,
26         address to,
27         uint deadline
28     )
29         external
30         payable
31         returns (uint amountToken, uint amountETH, uint liquidity);
32 
33     function removeLiquidity(
34         address tokenA,
35         address tokenB,
36         uint liquidity,
37         uint amountAMin,
38         uint amountBMin,
39         address to,
40         uint deadline
41     ) external returns (uint amountA, uint amountB);
42 
43     function removeLiquidityETH(
44         address token,
45         uint liquidity,
46         uint amountTokenMin,
47         uint amountETHMin,
48         address to,
49         uint deadline
50     ) external returns (uint amountToken, uint amountETH);
51 
52     function removeLiquidityWithPermit(
53         address tokenA,
54         address tokenB,
55         uint liquidity,
56         uint amountAMin,
57         uint amountBMin,
58         address to,
59         uint deadline,
60         bool approveMax,
61         uint8 v,
62         bytes32 r,
63         bytes32 s
64     ) external returns (uint amountA, uint amountB);
65 
66     function removeLiquidityETHWithPermit(
67         address token,
68         uint liquidity,
69         uint amountTokenMin,
70         uint amountETHMin,
71         address to,
72         uint deadline,
73         bool approveMax,
74         uint8 v,
75         bytes32 r,
76         bytes32 s
77     ) external returns (uint amountToken, uint amountETH);
78 
79     function swapExactTokensForTokens(
80         uint amountIn,
81         uint amountOutMin,
82         address[] calldata path,
83         address to,
84         uint deadline
85     ) external returns (uint[] memory amounts);
86 
87     function swapTokensForExactTokens(
88         uint amountOut,
89         uint amountInMax,
90         address[] calldata path,
91         address to,
92         uint deadline
93     ) external returns (uint[] memory amounts);
94 
95     function swapExactETHForTokens(
96         uint amountOutMin,
97         address[] calldata path,
98         address to,
99         uint deadline
100     ) external payable returns (uint[] memory amounts);
101 
102     function swapTokensForExactETH(
103         uint amountOut,
104         uint amountInMax,
105         address[] calldata path,
106         address to,
107         uint deadline
108     ) external returns (uint[] memory amounts);
109 
110     function swapExactTokensForETH(
111         uint amountIn,
112         uint amountOutMin,
113         address[] calldata path,
114         address to,
115         uint deadline
116     ) external returns (uint[] memory amounts);
117 
118     function swapETHForExactTokens(
119         uint amountOut,
120         address[] calldata path,
121         address to,
122         uint deadline
123     ) external payable returns (uint[] memory amounts);
124 
125     function quote(
126         uint amountA,
127         uint reserveA,
128         uint reserveB
129     ) external pure returns (uint amountB);
130 
131     function getAmountOut(
132         uint amountIn,
133         uint reserveIn,
134         uint reserveOut
135     ) external pure returns (uint amountOut);
136 
137     function getAmountIn(
138         uint amountOut,
139         uint reserveIn,
140         uint reserveOut
141     ) external pure returns (uint amountIn);
142 
143     function getAmountsOut(
144         uint amountIn,
145         address[] calldata path
146     ) external view returns (uint[] memory amounts);
147 
148     function getAmountsIn(
149         uint amountOut,
150         address[] calldata path
151     ) external view returns (uint[] memory amounts);
152 }
153 
154 interface IUniswapV2Router02 is IUniswapV2Router01 {
155     function removeLiquidityETHSupportingFeeOnTransferTokens(
156         address token,
157         uint liquidity,
158         uint amountTokenMin,
159         uint amountETHMin,
160         address to,
161         uint deadline
162     ) external returns (uint amountETH);
163 
164     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
165         address token,
166         uint liquidity,
167         uint amountTokenMin,
168         uint amountETHMin,
169         address to,
170         uint deadline,
171         bool approveMax,
172         uint8 v,
173         bytes32 r,
174         bytes32 s
175     ) external returns (uint amountETH);
176 
177     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
178         uint amountIn,
179         uint amountOutMin,
180         address[] calldata path,
181         address to,
182         uint deadline
183     ) external;
184 
185     function swapExactETHForTokensSupportingFeeOnTransferTokens(
186         uint amountOutMin,
187         address[] calldata path,
188         address to,
189         uint deadline
190     ) external payable;
191 
192     function swapExactTokensForETHSupportingFeeOnTransferTokens(
193         uint amountIn,
194         uint amountOutMin,
195         address[] calldata path,
196         address to,
197         uint deadline
198     ) external;
199 }
200 
201 interface IUniswapV2Factory {
202     event PairCreated(
203         address indexed token0,
204         address indexed token1,
205         address pair,
206         uint
207     );
208 
209     function feeTo() external view returns (address);
210 
211     function feeToSetter() external view returns (address);
212 
213     function getPair(
214         address tokenA,
215         address tokenB
216     ) external view returns (address pair);
217 
218     function allPairs(uint) external view returns (address pair);
219 
220     function allPairsLength() external view returns (uint);
221 
222     function createPair(
223         address tokenA,
224         address tokenB
225     ) external returns (address pair);
226 
227     function setFeeTo(address) external;
228 
229     function setFeeToSetter(address) external;
230 }
231 
232 library Address {
233     function isContract(address account) internal view returns (bool) {
234         return account.code.length > 0;
235     }
236 
237     function sendValue(address payable recipient, uint256 amount) internal {
238         require(
239             address(this).balance >= amount,
240             "Address: insufficient balance"
241         );
242 
243         (bool success, ) = recipient.call{value: amount}("");
244         require(
245             success,
246             "Address: unable to send value, recipient may have reverted"
247         );
248     }
249 
250     function functionCall(
251         address target,
252         bytes memory data
253     ) internal returns (bytes memory) {
254         return
255             functionCallWithValue(
256                 target,
257                 data,
258                 0,
259                 "Address: low-level call failed"
260             );
261     }
262 
263     function functionCall(
264         address target,
265         bytes memory data,
266         string memory errorMessage
267     ) internal returns (bytes memory) {
268         return functionCallWithValue(target, data, 0, errorMessage);
269     }
270 
271     function functionCallWithValue(
272         address target,
273         bytes memory data,
274         uint256 value
275     ) internal returns (bytes memory) {
276         return
277             functionCallWithValue(
278                 target,
279                 data,
280                 value,
281                 "Address: low-level call with value failed"
282             );
283     }
284 
285     function functionCallWithValue(
286         address target,
287         bytes memory data,
288         uint256 value,
289         string memory errorMessage
290     ) internal returns (bytes memory) {
291         require(
292             address(this).balance >= value,
293             "Address: insufficient balance for call"
294         );
295         (bool success, bytes memory returndata) = target.call{value: value}(
296             data
297         );
298         return
299             verifyCallResultFromTarget(
300                 target,
301                 success,
302                 returndata,
303                 errorMessage
304             );
305     }
306 
307     function functionStaticCall(
308         address target,
309         bytes memory data
310     ) internal view returns (bytes memory) {
311         return
312             functionStaticCall(
313                 target,
314                 data,
315                 "Address: low-level static call failed"
316             );
317     }
318 
319     function functionStaticCall(
320         address target,
321         bytes memory data,
322         string memory errorMessage
323     ) internal view returns (bytes memory) {
324         (bool success, bytes memory returndata) = target.staticcall(data);
325         return
326             verifyCallResultFromTarget(
327                 target,
328                 success,
329                 returndata,
330                 errorMessage
331             );
332     }
333 
334     function functionDelegateCall(
335         address target,
336         bytes memory data
337     ) internal returns (bytes memory) {
338         return
339             functionDelegateCall(
340                 target,
341                 data,
342                 "Address: low-level delegate call failed"
343             );
344     }
345 
346     function functionDelegateCall(
347         address target,
348         bytes memory data,
349         string memory errorMessage
350     ) internal returns (bytes memory) {
351         (bool success, bytes memory returndata) = target.delegatecall(data);
352         return
353             verifyCallResultFromTarget(
354                 target,
355                 success,
356                 returndata,
357                 errorMessage
358             );
359     }
360 
361     function verifyCallResultFromTarget(
362         address target,
363         bool success,
364         bytes memory returndata,
365         string memory errorMessage
366     ) internal view returns (bytes memory) {
367         if (success) {
368             if (returndata.length == 0) {
369                 require(isContract(target), "Address: call to non-contract");
370             }
371             return returndata;
372         } else {
373             _revert(returndata, errorMessage);
374         }
375     }
376 
377     function verifyCallResult(
378         bool success,
379         bytes memory returndata,
380         string memory errorMessage
381     ) internal pure returns (bytes memory) {
382         if (success) {
383             return returndata;
384         } else {
385             _revert(returndata, errorMessage);
386         }
387     }
388 
389     function _revert(
390         bytes memory returndata,
391         string memory errorMessage
392     ) private pure {
393         if (returndata.length > 0) {
394             /// @solidity memory-safe-assembly
395             assembly {
396                 let returndata_size := mload(returndata)
397                 revert(add(32, returndata), returndata_size)
398             }
399         } else {
400             revert(errorMessage);
401         }
402     }
403 }
404 
405 interface IERC20Permit {
406     function permit(
407         address owner,
408         address spender,
409         uint256 value,
410         uint256 deadline,
411         uint8 v,
412         bytes32 r,
413         bytes32 s
414     ) external;
415 
416     function nonces(address owner) external view returns (uint256);
417 
418     // solhint-disable-next-line func-name-mixedcase
419     function DOMAIN_SEPARATOR() external view returns (bytes32);
420 }
421 
422 interface IERC20 {
423     event Transfer(address indexed from, address indexed to, uint256 value);
424 
425     event Approval(
426         address indexed owner,
427         address indexed spender,
428         uint256 value
429     );
430 
431     function totalSupply() external view returns (uint256);
432 
433     function balanceOf(address account) external view returns (uint256);
434 
435     function transfer(address to, uint256 amount) external returns (bool);
436 
437     function allowance(
438         address owner,
439         address spender
440     ) external view returns (uint256);
441 
442     function approve(address spender, uint256 amount) external returns (bool);
443 
444     function transferFrom(
445         address from,
446         address to,
447         uint256 amount
448     ) external returns (bool);
449 }
450 
451 library SafeERC20 {
452     using Address for address;
453 
454     function safeTransfer(IERC20 token, address to, uint256 value) internal {
455         _callOptionalReturn(
456             token,
457             abi.encodeWithSelector(token.transfer.selector, to, value)
458         );
459     }
460 
461     function safeTransferFrom(
462         IERC20 token,
463         address from,
464         address to,
465         uint256 value
466     ) internal {
467         _callOptionalReturn(
468             token,
469             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
470         );
471     }
472 
473     function safeApprove(
474         IERC20 token,
475         address spender,
476         uint256 value
477     ) internal {
478         require(
479             (value == 0) || (token.allowance(address(this), spender) == 0),
480             "SafeERC20: approve from non-zero to non-zero allowance"
481         );
482         _callOptionalReturn(
483             token,
484             abi.encodeWithSelector(token.approve.selector, spender, value)
485         );
486     }
487 
488     function safeIncreaseAllowance(
489         IERC20 token,
490         address spender,
491         uint256 value
492     ) internal {
493         uint256 oldAllowance = token.allowance(address(this), spender);
494         _callOptionalReturn(
495             token,
496             abi.encodeWithSelector(
497                 token.approve.selector,
498                 spender,
499                 oldAllowance + value
500             )
501         );
502     }
503 
504     function safeDecreaseAllowance(
505         IERC20 token,
506         address spender,
507         uint256 value
508     ) internal {
509         unchecked {
510             uint256 oldAllowance = token.allowance(address(this), spender);
511             require(
512                 oldAllowance >= value,
513                 "SafeERC20: decreased allowance below zero"
514             );
515             _callOptionalReturn(
516                 token,
517                 abi.encodeWithSelector(
518                     token.approve.selector,
519                     spender,
520                     oldAllowance - value
521                 )
522             );
523         }
524     }
525 
526     function forceApprove(
527         IERC20 token,
528         address spender,
529         uint256 value
530     ) internal {
531         bytes memory approvalCall = abi.encodeWithSelector(
532             token.approve.selector,
533             spender,
534             value
535         );
536 
537         if (!_callOptionalReturnBool(token, approvalCall)) {
538             _callOptionalReturn(
539                 token,
540                 abi.encodeWithSelector(token.approve.selector, spender, 0)
541             );
542             _callOptionalReturn(token, approvalCall);
543         }
544     }
545 
546     function safePermit(
547         IERC20Permit token,
548         address owner,
549         address spender,
550         uint256 value,
551         uint256 deadline,
552         uint8 v,
553         bytes32 r,
554         bytes32 s
555     ) internal {
556         uint256 nonceBefore = token.nonces(owner);
557         token.permit(owner, spender, value, deadline, v, r, s);
558         uint256 nonceAfter = token.nonces(owner);
559         require(
560             nonceAfter == nonceBefore + 1,
561             "SafeERC20: permit did not succeed"
562         );
563     }
564 
565     function _callOptionalReturn(IERC20 token, bytes memory data) private {
566         bytes memory returndata = address(token).functionCall(
567             data,
568             "SafeERC20: low-level call failed"
569         );
570         require(
571             returndata.length == 0 || abi.decode(returndata, (bool)),
572             "SafeERC20: ERC20 operation did not succeed"
573         );
574     }
575 
576     function _callOptionalReturnBool(
577         IERC20 token,
578         bytes memory data
579     ) private returns (bool) {
580         (bool success, bytes memory returndata) = address(token).call(data);
581         return
582             success &&
583             (returndata.length == 0 || abi.decode(returndata, (bool))) &&
584             Address.isContract(address(token));
585     }
586 }
587 
588 interface IERC20Metadata is IERC20 {
589     function name() external view returns (string memory);
590 
591     function symbol() external view returns (string memory);
592 
593     function decimals() external view returns (uint8);
594 }
595 
596 abstract contract ReentrancyGuard {
597     uint256 private constant _NOT_ENTERED = 1;
598     uint256 private constant _ENTERED = 2;
599 
600     uint256 private _status;
601 
602     constructor() {
603         _status = _NOT_ENTERED;
604     }
605 
606     modifier nonReentrant() {
607         _nonReentrantBefore();
608         _;
609         _nonReentrantAfter();
610     }
611 
612     function _nonReentrantBefore() private {
613         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
614 
615         _status = _ENTERED;
616     }
617 
618     function _nonReentrantAfter() private {
619         _status = _NOT_ENTERED;
620     }
621 
622     function _reentrancyGuardEntered() internal view returns (bool) {
623         return _status == _ENTERED;
624     }
625 }
626 
627 abstract contract Context {
628     function _msgSender() internal view virtual returns (address) {
629         return msg.sender;
630     }
631 
632     function _msgData() internal view virtual returns (bytes calldata) {
633         return msg.data;
634     }
635 }
636 
637 contract ERC20 is Context, IERC20, IERC20Metadata {
638     mapping(address => uint256) private _balances;
639 
640     mapping(address => mapping(address => uint256)) private _allowances;
641 
642     uint256 private _totalSupply;
643 
644     string private _name;
645     string private _symbol;
646 
647     constructor(string memory name_, string memory symbol_) {
648         _name = name_;
649         _symbol = symbol_;
650     }
651 
652     function name() public view virtual override returns (string memory) {
653         return _name;
654     }
655 
656     function symbol() public view virtual override returns (string memory) {
657         return _symbol;
658     }
659 
660     function decimals() public view virtual override returns (uint8) {
661         return 18;
662     }
663 
664     function totalSupply() public view virtual override returns (uint256) {
665         return _totalSupply;
666     }
667 
668     function balanceOf(
669         address account
670     ) public view virtual override returns (uint256) {
671         return _balances[account];
672     }
673 
674     function transfer(
675         address to,
676         uint256 amount
677     ) public virtual override returns (bool) {
678         address owner = _msgSender();
679         _transfer(owner, to, amount);
680         return true;
681     }
682 
683     function allowance(
684         address owner,
685         address spender
686     ) public view virtual override returns (uint256) {
687         return _allowances[owner][spender];
688     }
689 
690     function approve(
691         address spender,
692         uint256 amount
693     ) public virtual override returns (bool) {
694         address owner = _msgSender();
695         _approve(owner, spender, amount);
696         return true;
697     }
698 
699     function transferFrom(
700         address from,
701         address to,
702         uint256 amount
703     ) public virtual override returns (bool) {
704         address spender = _msgSender();
705         _spendAllowance(from, spender, amount);
706         _transfer(from, to, amount);
707         return true;
708     }
709 
710     function increaseAllowance(
711         address spender,
712         uint256 addedValue
713     ) public virtual returns (bool) {
714         address owner = _msgSender();
715         _approve(owner, spender, allowance(owner, spender) + addedValue);
716         return true;
717     }
718 
719     function decreaseAllowance(
720         address spender,
721         uint256 subtractedValue
722     ) public virtual returns (bool) {
723         address owner = _msgSender();
724         uint256 currentAllowance = allowance(owner, spender);
725         require(
726             currentAllowance >= subtractedValue,
727             "ERC20: decreased allowance below zero"
728         );
729         unchecked {
730             _approve(owner, spender, currentAllowance - subtractedValue);
731         }
732 
733         return true;
734     }
735 
736     function _transfer(
737         address from,
738         address to,
739         uint256 amount
740     ) internal virtual {
741         require(from != address(0), "ERC20: transfer from the zero address");
742         require(to != address(0), "ERC20: transfer to the zero address");
743 
744         _beforeTokenTransfer(from, to, amount);
745 
746         uint256 fromBalance = _balances[from];
747         require(
748             fromBalance >= amount,
749             "ERC20: transfer amount exceeds balance"
750         );
751         unchecked {
752             _balances[from] = fromBalance - amount;
753 
754             _balances[to] += amount;
755         }
756 
757         emit Transfer(from, to, amount);
758 
759         _afterTokenTransfer(from, to, amount);
760     }
761 
762     function _mint(address account, uint256 amount) internal virtual {
763         require(account != address(0), "ERC20: mint to the zero address");
764 
765         _beforeTokenTransfer(address(0), account, amount);
766 
767         _totalSupply += amount;
768         unchecked {
769             _balances[account] += amount;
770         }
771         emit Transfer(address(0), account, amount);
772 
773         _afterTokenTransfer(address(0), account, amount);
774     }
775 
776     function _burn(address account, uint256 amount) internal virtual {
777         require(account != address(0), "ERC20: burn from the zero address");
778 
779         _beforeTokenTransfer(account, address(0), amount);
780 
781         uint256 accountBalance = _balances[account];
782         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
783         unchecked {
784             _balances[account] = accountBalance - amount;
785 
786             _totalSupply -= amount;
787         }
788 
789         emit Transfer(account, address(0), amount);
790 
791         _afterTokenTransfer(account, address(0), amount);
792     }
793 
794     function _approve(
795         address owner,
796         address spender,
797         uint256 amount
798     ) internal virtual {
799         require(owner != address(0), "ERC20: approve from the zero address");
800         require(spender != address(0), "ERC20: approve to the zero address");
801 
802         _allowances[owner][spender] = amount;
803         emit Approval(owner, spender, amount);
804     }
805 
806     function _spendAllowance(
807         address owner,
808         address spender,
809         uint256 amount
810     ) internal virtual {
811         uint256 currentAllowance = allowance(owner, spender);
812         if (currentAllowance != type(uint256).max) {
813             require(
814                 currentAllowance >= amount,
815                 "ERC20: insufficient allowance"
816             );
817             unchecked {
818                 _approve(owner, spender, currentAllowance - amount);
819             }
820         }
821     }
822 
823     function _beforeTokenTransfer(
824         address from,
825         address to,
826         uint256 amount
827     ) internal virtual {}
828 
829     function _afterTokenTransfer(
830         address from,
831         address to,
832         uint256 amount
833     ) internal virtual {}
834 }
835 
836 abstract contract Ownable is Context {
837     address private _owner;
838 
839     event OwnershipTransferred(
840         address indexed previousOwner,
841         address indexed newOwner
842     );
843 
844     constructor() {
845         _transferOwnership(_msgSender());
846     }
847 
848     modifier onlyOwner() {
849         _checkOwner();
850         _;
851     }
852 
853     function owner() public view virtual returns (address) {
854         return _owner;
855     }
856 
857     function _checkOwner() internal view virtual {
858         require(owner() == _msgSender(), "Ownable: caller is not the owner");
859     }
860 
861     function renounceOwnership() public virtual onlyOwner {
862         _transferOwnership(address(0));
863     }
864 
865     function transferOwnership(address newOwner) public virtual onlyOwner {
866         require(
867             newOwner != address(0),
868             "Ownable: new owner is the zero address"
869         );
870         _transferOwnership(newOwner);
871     }
872 
873     function _transferOwnership(address newOwner) internal virtual {
874         address oldOwner = _owner;
875         _owner = newOwner;
876         emit OwnershipTransferred(oldOwner, newOwner);
877     }
878 }
879 
880 contract XCOIN is Ownable, ReentrancyGuard, ERC20 {
881     using SafeERC20 for IERC20;
882 
883     uint256 public liquidityTaxBuy;
884     uint256 public liquidityTaxSell;
885 
886     uint256 public marketingTaxBuy;
887     uint256 public marketingTaxSell;
888 
889     uint256 public immutable denominator;
890 
891     uint256 public liquidityTokenAmount;
892     uint256 public marketingTokenAmount;
893 
894     address public marketingWallet;
895 
896     bool private swapping;
897     uint256 public swapTokensAtAmount;
898     bool public isSwapBackEnabled;
899 
900     IUniswapV2Router02 public immutable uniswapV2Router;
901     address public immutable uniswapV2Pair;
902 
903     mapping(address => bool) private _isAutomatedMarketMakerPair;
904     mapping(address => bool) private _isExcludedFromFees;
905 
906     modifier inSwap() {
907         swapping = true;
908         _;
909         swapping = false;
910     }
911 
912     event UpdateBuyTax(uint256 liquidityTaxBuy, uint256 marketingTaxBuy);
913     event UpdateSellTax(uint256 liquidityTaxSell, uint256 marketingTaxSell);
914     event UpdateMarketingWallet(address indexed marketingWallet);
915     event UpdateSwapTokensAtAmount(uint256 swapTokensAtAmount);
916     event UpdateSwapBackStatus(bool status);
917     event UpdateAutomatedMarketMakerPair(address indexed pair, bool status);
918     event UpdateExcludeFromFees(address indexed account, bool isExcluded);
919 
920     constructor() ERC20("X-Coin", "X") {
921         _transferOwnership(0x119c70D7A0D90A1Aa341BDd637c475E43Cf60Be4);
922         _mint(owner(), 10_000_000_000 * (10 ** 18));
923 
924         liquidityTaxBuy = 0;
925         liquidityTaxSell = 0;
926 
927         marketingTaxBuy = 0;
928         marketingTaxSell = 0;
929 
930         denominator = 10_000;
931 
932         marketingWallet = 0x08cEEB0FbaF9194855609D16054416f47d556086;
933 
934         swapTokensAtAmount = totalSupply() / 100_000;
935         isSwapBackEnabled = true;
936 
937         address router = getRouterAddress();
938         uniswapV2Router = IUniswapV2Router02(router);
939         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
940             address(this),
941             uniswapV2Router.WETH()
942         );
943 
944         _approve(address(this), address(uniswapV2Router), type(uint256).max);
945 
946         _isAutomatedMarketMakerPair[address(uniswapV2Pair)] = true;
947 
948         _isExcludedFromFees[address(0xdead)] = true;
949         _isExcludedFromFees[address(owner())] = true;
950         _isExcludedFromFees[address(this)] = true;
951         _isExcludedFromFees[address(uniswapV2Router)] = true;
952     }
953 
954     receive() external payable {}
955 
956     fallback() external payable {}
957 
958     function isContract(address account) internal view returns (bool) {
959         return account.code.length > 0;
960     }
961 
962     function getRouterAddress() public view returns (address) {
963         if (block.chainid == 56) {
964             return 0x10ED43C718714eb63d5aA57B78B54704E256024E;
965         } else if (block.chainid == 97) {
966             return 0xD99D1c33F9fC3444f8101754aBC46c52416550D1;
967         } else if (block.chainid == 1 || block.chainid == 5) {
968             return 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
969         } else {
970             revert("Cannot found router on this network");
971         }
972     }
973 
974     function claimStuckTokens(address token) external onlyOwner {
975         require(token != address(this), "Owner cannot claim native tokens");
976 
977         if (token == address(0x0)) {
978             payable(msg.sender).transfer(address(this).balance);
979             return;
980         }
981         IERC20 ERC20token = IERC20(token);
982         uint256 balance = ERC20token.balanceOf(address(this));
983         ERC20token.safeTransfer(msg.sender, balance);
984     }
985 
986     function setBuyTax(
987         uint256 _liquidityTaxBuy,
988         uint256 _marketingTaxBuy
989     ) external onlyOwner {
990         require(
991             liquidityTaxBuy != _liquidityTaxBuy ||
992                 marketingTaxBuy != _marketingTaxBuy,
993             "Buy Tax already on that amount"
994         );
995         require(
996             _liquidityTaxBuy + _marketingTaxBuy <= 1_000,
997             "Buy Tax cannot be more than 10%"
998         );
999 
1000         liquidityTaxBuy = _liquidityTaxBuy;
1001         marketingTaxBuy = _marketingTaxBuy;
1002 
1003         emit UpdateBuyTax(_liquidityTaxBuy, _marketingTaxBuy);
1004     }
1005 
1006     function setSellTax(
1007         uint256 _liquidityTaxSell,
1008         uint256 _marketingTaxSell
1009     ) external onlyOwner {
1010         require(
1011             liquidityTaxSell != _liquidityTaxSell ||
1012                 marketingTaxSell != _marketingTaxSell,
1013             "Sell Tax already on that amount"
1014         );
1015         require(
1016             _liquidityTaxSell + _marketingTaxSell <= 1_000,
1017             "Sell Tax cannot be more than 10%"
1018         );
1019 
1020         liquidityTaxSell = _liquidityTaxSell;
1021         marketingTaxSell = _marketingTaxSell;
1022 
1023         emit UpdateSellTax(_liquidityTaxSell, _marketingTaxSell);
1024     }
1025 
1026     function setMarketingWallet(address _marketingWallet) external onlyOwner {
1027         require(
1028             _marketingWallet != marketingWallet,
1029             "Marketing wallet is already that address"
1030         );
1031         require(
1032             _marketingWallet != address(0),
1033             "Marketing wallet cannot be the zero address"
1034         );
1035         require(
1036             !isContract(_marketingWallet),
1037             "Marketing wallet cannot be a contract"
1038         );
1039 
1040         marketingWallet = _marketingWallet;
1041         emit UpdateMarketingWallet(_marketingWallet);
1042     }
1043 
1044     function setSwapTokensAtAmount(uint256 amount) external onlyOwner {
1045         require(
1046             swapTokensAtAmount != amount,
1047             "SwapTokensAtAmount already on that amount"
1048         );
1049         require(
1050             amount >= totalSupply() / 1_000_000,
1051             "Amount must be equal or greater than 0.000001% of Total Supply"
1052         );
1053 
1054         swapTokensAtAmount = amount;
1055 
1056         emit UpdateSwapTokensAtAmount(amount);
1057     }
1058 
1059     function toggleSwapBack(bool status) external onlyOwner {
1060         require(isSwapBackEnabled != status, "SwapBack already on status");
1061 
1062         isSwapBackEnabled = status;
1063         emit UpdateSwapBackStatus(status);
1064     }
1065 
1066     function setAutomatedMarketMakerPair(
1067         address pair,
1068         bool status
1069     ) external onlyOwner {
1070         require(
1071             _isAutomatedMarketMakerPair[pair] != status,
1072             "Pair address is already the value of 'status'"
1073         );
1074         require(pair != address(uniswapV2Pair), "Cannot set this pair");
1075 
1076         _isAutomatedMarketMakerPair[pair] = status;
1077 
1078         emit UpdateAutomatedMarketMakerPair(pair, status);
1079     }
1080 
1081     function isAutomatedMarketMakerPair(
1082         address pair
1083     ) external view returns (bool) {
1084         return _isAutomatedMarketMakerPair[pair];
1085     }
1086 
1087     function setExcludeFromFees(
1088         address account,
1089         bool excluded
1090     ) external onlyOwner {
1091         require(
1092             _isExcludedFromFees[account] != excluded,
1093             "Account is already the value of 'excluded'"
1094         );
1095         _isExcludedFromFees[account] = excluded;
1096 
1097         emit UpdateExcludeFromFees(account, excluded);
1098     }
1099 
1100     function isExcludedFromFees(address account) external view returns (bool) {
1101         return _isExcludedFromFees[account];
1102     }
1103 
1104     function _transfer(
1105         address from,
1106         address to,
1107         uint256 amount
1108     ) internal override {
1109         require(from != address(0), "ERC20: transfer from the zero address");
1110         require(to != address(0), "ERC20: transfer to the zero address");
1111 
1112         if (amount == 0) {
1113             super._transfer(from, to, 0);
1114             return;
1115         }
1116 
1117         uint256 contractTokenBalance = balanceOf(address(this));
1118 
1119         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1120 
1121         if (
1122             canSwap &&
1123             !swapping &&
1124             !_isAutomatedMarketMakerPair[from] &&
1125             isSwapBackEnabled &&
1126             liquidityTokenAmount + marketingTokenAmount > 0
1127         ) {
1128             swapBack();
1129         }
1130 
1131         bool takeFee = true;
1132 
1133         if (_isExcludedFromFees[from] || _isExcludedFromFees[to] || swapping) {
1134             takeFee = false;
1135         }
1136 
1137         if (takeFee) {
1138             uint256 tempLiquidityAmount;
1139             uint256 tempMarketingAmount;
1140 
1141             if (_isAutomatedMarketMakerPair[from]) {
1142                 tempLiquidityAmount = (amount * liquidityTaxBuy) / denominator;
1143                 tempMarketingAmount = (amount * marketingTaxBuy) / denominator;
1144             } else if (_isAutomatedMarketMakerPair[to]) {
1145                 tempLiquidityAmount = (amount * liquidityTaxSell) / denominator;
1146                 tempMarketingAmount = (amount * marketingTaxSell) / denominator;
1147             }
1148 
1149             liquidityTokenAmount += tempLiquidityAmount;
1150             marketingTokenAmount += tempMarketingAmount;
1151 
1152             uint256 fees = tempLiquidityAmount + tempMarketingAmount;
1153 
1154             if (fees > 0) {
1155                 amount -= fees;
1156                 super._transfer(from, address(this), fees);
1157             }
1158         }
1159 
1160         super._transfer(from, to, amount);
1161     }
1162 
1163     function swapBack() internal inSwap {
1164         address[] memory path = new address[](2);
1165         path[0] = address(this);
1166         path[1] = uniswapV2Router.WETH();
1167 
1168         uint256 contractTokenBalance = balanceOf(address(this));
1169 
1170         uint256 totalTax = liquidityTokenAmount + marketingTokenAmount;
1171 
1172         uint256 liquifyToken = (contractTokenBalance *
1173             (liquidityTokenAmount / 2)) / totalTax;
1174 
1175         uint256 swapBackAmount = contractTokenBalance - liquifyToken;
1176 
1177         totalTax -= (liquidityTokenAmount) / 2;
1178 
1179         try
1180             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1181                 swapBackAmount,
1182                 0,
1183                 path,
1184                 address(this),
1185                 block.timestamp
1186             )
1187         {} catch {
1188             return;
1189         }
1190 
1191         uint256 newBalance = address(this).balance;
1192 
1193         uint256 marketingBNB = (newBalance * marketingTokenAmount) / totalTax;
1194         uint256 liquifyBNB = newBalance - marketingBNB;
1195 
1196         if (liquifyToken > 0 && liquifyBNB > 0) {
1197             try
1198                 uniswapV2Router.addLiquidityETH{value: liquifyBNB}(
1199                     address(this),
1200                     liquifyToken,
1201                     0,
1202                     0,
1203                     address(0xdead),
1204                     block.timestamp
1205                 )
1206             {} catch {}
1207         }
1208 
1209         if (marketingBNB > 0) {
1210             sendBNB(marketingWallet, marketingBNB);
1211         }
1212 
1213         liquidityTokenAmount = 0;
1214         marketingTokenAmount = 0;
1215     }
1216 
1217     function sendBNB(
1218         address _to,
1219         uint256 amount
1220     ) internal nonReentrant returns (bool) {
1221         if (address(this).balance < amount) return false;
1222 
1223         (bool success, ) = payable(_to).call{value: amount}("");
1224 
1225         return success;
1226     }
1227 
1228     function manualSwapBack() external {
1229         uint256 contractTokenBalance = balanceOf(address(this));
1230 
1231         require(contractTokenBalance > 0, "Cant Swap Back 0 Token!");
1232 
1233         swapBack();
1234     }
1235 }