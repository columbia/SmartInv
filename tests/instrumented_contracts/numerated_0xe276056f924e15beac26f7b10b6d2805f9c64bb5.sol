1 // SPDX-License-Identifier: Unlicensed
2 
3 
4 
5 pragma solidity ^0.6.12;
6 
7 
8 
9 abstract contract Context {
10 
11     function _msgSender() internal view virtual returns (address payable) {
12 
13         return msg.sender;
14 
15     }
16 
17 
18 
19     function _msgData() internal view virtual returns (bytes memory) {
20 
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22 
23         return msg.data;
24 
25     }
26 
27 }
28 
29 
30 
31 interface IERC20 {
32 
33     /**
34 
35      * @dev Returns the amount of tokens in existence.
36 
37      */
38 
39     function totalSupply() external view returns (uint256);
40 
41 
42 
43     /**
44 
45      * @dev Returns the amount of tokens owned by `account`.
46 
47      */
48 
49     function balanceOf(address account) external view returns (uint256);
50 
51 
52 
53     /**
54 
55      * @dev Moves `amount` tokens from the caller's account to `recipient`.
56 
57      *
58 
59      * Returns a boolean value indicating whether the operation succeeded.
60 
61      *
62 
63      * Emits a {Transfer} event.
64 
65      */
66 
67     function transfer(address recipient, uint256 amount) external returns (bool);
68 
69 
70 
71     /**
72 
73      * @dev Returns the remaining number of tokens that `spender` will be
74 
75      * allowed to spend on behalf of `owner` through {transferFrom}. This is
76 
77      * zero by default.
78 
79      *
80 
81      * This value changes when {approve} or {transferFrom} are called.
82 
83      */
84 
85     function allowance(address owner, address spender) external view returns (uint256);
86 
87 
88 
89     /**
90 
91      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
92 
93      *
94 
95      * Returns a boolean value indicating whether the operation succeeded.
96 
97      *
98 
99      * IMPORTANT: Beware that changing an allowance with this method brings the risk
100 
101      * that someone may use both the old and the new allowance by unfortunate
102 
103      * transaction ordering. One possible solution to mitigate this race
104 
105      * condition is to first reduce the spender's allowance to 0 and set the
106 
107      * desired value afterwards:
108 
109      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
110 
111      *
112 
113      * Emits an {Approval} event.
114 
115      */
116 
117     function approve(address spender, uint256 amount) external returns (bool);
118 
119 
120 
121     /**
122 
123      * @dev Moves `amount` tokens from `sender` to `recipient` using the
124 
125      * allowance mechanism. `amount` is then deducted from the caller's
126 
127      * allowance.
128 
129      *
130 
131      * Returns a boolean value indicating whether the operation succeeded.
132 
133      *
134 
135      * Emits a {Transfer} event.
136 
137      */
138 
139     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
140 
141 
142 
143     /**
144 
145      * @dev Emitted when `value` tokens are moved from one account (`from`) to
146 
147      * another (`to`).
148 
149      *
150 
151      * Note that `value` may be zero.
152 
153      */
154 
155     event Transfer(address indexed from, address indexed to, uint256 value);
156 
157 
158 
159     /**
160 
161      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
162 
163      * a call to {approve}. `value` is the new allowance.
164 
165      */
166 
167     event Approval(address indexed owner, address indexed spender, uint256 value);
168 
169 }
170 
171 
172 
173 library SafeMath {
174 
175     /**
176 
177      * @dev Returns the addition of two unsigned integers, reverting on
178 
179      * overflow.
180 
181      *
182 
183      * Counterpart to Solidity's `+` operator.
184 
185      *
186 
187      * Requirements:
188 
189      *
190 
191      * - Addition cannot overflow.
192 
193      */
194 
195     function add(uint256 a, uint256 b) internal pure returns (uint256) {
196 
197         uint256 c = a + b;
198 
199         require(c >= a, "SafeMath: addition overflow");
200 
201 
202 
203         return c;
204 
205     }
206 
207 
208 
209     /**
210 
211      * @dev Returns the subtraction of two unsigned integers, reverting on
212 
213      * overflow (when the result is negative).
214 
215      *
216 
217      * Counterpart to Solidity's `-` operator.
218 
219      *
220 
221      * Requirements:
222 
223      *
224 
225      * - Subtraction cannot overflow.
226 
227      */
228 
229     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
230 
231         return sub(a, b, "SafeMath: subtraction overflow");
232 
233     }
234 
235 
236 
237     /**
238 
239      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
240 
241      * overflow (when the result is negative).
242 
243      *
244 
245      * Counterpart to Solidity's `-` operator.
246 
247      *
248 
249      * Requirements:
250 
251      *
252 
253      * - Subtraction cannot overflow.
254 
255      */
256 
257     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
258 
259         require(b <= a, errorMessage);
260 
261         uint256 c = a - b;
262 
263 
264 
265         return c;
266 
267     }
268 
269 
270 
271     /**
272 
273      * @dev Returns the multiplication of two unsigned integers, reverting on
274 
275      * overflow.
276 
277      *
278 
279      * Counterpart to Solidity's `*` operator.
280 
281      *
282 
283      * Requirements:
284 
285      *
286 
287      * - Multiplication cannot overflow.
288 
289      */
290 
291     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
292 
293         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
294 
295         // benefit is lost if 'b' is also tested.
296 
297         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
298 
299         if (a == 0) {
300 
301             return 0;
302 
303         }
304 
305 
306 
307         uint256 c = a * b;
308 
309         require(c / a == b, "SafeMath: multiplication overflow");
310 
311 
312 
313         return c;
314 
315     }
316 
317 
318 
319     /**
320 
321      * @dev Returns the integer division of two unsigned integers. Reverts on
322 
323      * division by zero. The result is rounded towards zero.
324 
325      *
326 
327      * Counterpart to Solidity's `/` operator. Note: this function uses a
328 
329      * `revert` opcode (which leaves remaining gas untouched) while Solidity
330 
331      * uses an invalid opcode to revert (consuming all remaining gas).
332 
333      *
334 
335      * Requirements:
336 
337      *
338 
339      * - The divisor cannot be zero.
340 
341      */
342 
343     function div(uint256 a, uint256 b) internal pure returns (uint256) {
344 
345         return div(a, b, "SafeMath: division by zero");
346 
347     }
348 
349 
350 
351     /**
352 
353      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
354 
355      * division by zero. The result is rounded towards zero.
356 
357      *
358 
359      * Counterpart to Solidity's `/` operator. Note: this function uses a
360 
361      * `revert` opcode (which leaves remaining gas untouched) while Solidity
362 
363      * uses an invalid opcode to revert (consuming all remaining gas).
364 
365      *
366 
367      * Requirements:
368 
369      *
370 
371      * - The divisor cannot be zero.
372 
373      */
374 
375     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
376 
377         require(b > 0, errorMessage);
378 
379         uint256 c = a / b;
380 
381         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
382 
383 
384 
385         return c;
386 
387     }
388 
389 
390 
391     /**
392 
393      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
394 
395      * Reverts when dividing by zero.
396 
397      *
398 
399      * Counterpart to Solidity's `%` operator. This function uses a `revert`
400 
401      * opcode (which leaves remaining gas untouched) while Solidity uses an
402 
403      * invalid opcode to revert (consuming all remaining gas).
404 
405      *
406 
407      * Requirements:
408 
409      *
410 
411      * - The divisor cannot be zero.
412 
413      */
414 
415     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
416 
417         return mod(a, b, "SafeMath: modulo by zero");
418 
419     }
420 
421 
422 
423     /**
424 
425      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
426 
427      * Reverts with custom message when dividing by zero.
428 
429      *
430 
431      * Counterpart to Solidity's `%` operator. This function uses a `revert`
432 
433      * opcode (which leaves remaining gas untouched) while Solidity uses an
434 
435      * invalid opcode to revert (consuming all remaining gas).
436 
437      *
438 
439      * Requirements:
440 
441      *
442 
443      * - The divisor cannot be zero.
444 
445      */
446 
447     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
448 
449         require(b != 0, errorMessage);
450 
451         return a % b;
452 
453     }
454 
455 }
456 
457 
458 
459 library Address {
460 
461     /**
462 
463      * @dev Returns true if `account` is a contract.
464 
465      *
466 
467      * [IMPORTANT]
468 
469      * ====
470 
471      * It is unsafe to assume that an address for which this function returns
472 
473      * false is an externally-owned account (EOA) and not a contract.
474 
475      *
476 
477      * Among others, `isContract` will return false for the following
478 
479      * types of addresses:
480 
481      *
482 
483      *  - an externally-owned account
484 
485      *  - a contract in construction
486 
487      *  - an address where a contract will be created
488 
489      *  - an address where a contract lived, but was destroyed
490 
491      * ====
492 
493      */
494 
495     function isContract(address account) internal view returns (bool) {
496 
497         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
498 
499         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
500 
501         // for accounts without code, i.e. `keccak256('')`
502 
503         bytes32 codehash;
504 
505         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
506 
507         // solhint-disable-next-line no-inline-assembly
508 
509         assembly { codehash := extcodehash(account) }
510 
511         return (codehash != accountHash && codehash != 0x0);
512 
513     }
514 
515 
516 
517     /**
518 
519      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
520 
521      * `recipient`, forwarding all available gas and reverting on errors.
522 
523      *
524 
525      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
526 
527      * of certain opcodes, possibly making contracts go over the 2300 gas limit
528 
529      * imposed by `transfer`, making them unable to receive funds via
530 
531      * `transfer`. {sendValue} removes this limitation.
532 
533      *
534 
535      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
536 
537      *
538 
539      * IMPORTANT: because control is transferred to `recipient`, care must be
540 
541      * taken to not create reentrancy vulnerabilities. Consider using
542 
543      * {ReentrancyGuard} or the
544 
545      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
546 
547      */
548 
549     function sendValue(address payable recipient, uint256 amount) internal {
550 
551         require(address(this).balance >= amount, "Address: insufficient balance");
552 
553 
554 
555         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
556 
557         (bool success, ) = recipient.call{ value: amount }("");
558 
559         require(success, "Address: unable to send value, recipient may have reverted");
560 
561     }
562 
563 
564 
565     /**
566 
567      * @dev Performs a Solidity function call using a low level `call`. A
568 
569      * plain`call` is an unsafe replacement for a function call: use this
570 
571      * function instead.
572 
573      *
574 
575      * If `target` reverts with a revert reason, it is bubbled up by this
576 
577      * function (like regular Solidity function calls).
578 
579      *
580 
581      * Returns the raw returned data. To convert to the expected return value,
582 
583      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
584 
585      *
586 
587      * Requirements:
588 
589      *
590 
591      * - `target` must be a contract.
592 
593      * - calling `target` with `data` must not revert.
594 
595      *
596 
597      * _Available since v3.1._
598 
599      */
600 
601     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
602 
603       return functionCall(target, data, "Address: low-level call failed");
604 
605     }
606 
607 
608 
609     /**
610 
611      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
612 
613      * `errorMessage` as a fallback revert reason when `target` reverts.
614 
615      *
616 
617      * _Available since v3.1._
618 
619      */
620 
621     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
622 
623         return _functionCallWithValue(target, data, 0, errorMessage);
624 
625     }
626 
627 
628 
629     /**
630 
631      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
632 
633      * but also transferring `value` wei to `target`.
634 
635      *
636 
637      * Requirements:
638 
639      *
640 
641      * - the calling contract must have an ETH balance of at least `value`.
642 
643      * - the called Solidity function must be `payable`.
644 
645      *
646 
647      * _Available since v3.1._
648 
649      */
650 
651     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
652 
653         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
654 
655     }
656 
657 
658 
659     /**
660 
661      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
662 
663      * with `errorMessage` as a fallback revert reason when `target` reverts.
664 
665      *
666 
667      * _Available since v3.1._
668 
669      */
670 
671     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
672 
673         require(address(this).balance >= value, "Address: insufficient balance for call");
674 
675         return _functionCallWithValue(target, data, value, errorMessage);
676 
677     }
678 
679 
680 
681     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
682 
683         require(isContract(target), "Address: call to non-contract");
684 
685 
686 
687         // solhint-disable-next-line avoid-low-level-calls
688 
689         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
690 
691         if (success) {
692 
693             return returndata;
694 
695         } else {
696 
697             // Look for revert reason and bubble it up if present
698 
699             if (returndata.length > 0) {
700 
701                 // The easiest way to bubble the revert reason is using memory via assembly
702 
703 
704 
705                 // solhint-disable-next-line no-inline-assembly
706 
707                 assembly {
708 
709                     let returndata_size := mload(returndata)
710 
711                     revert(add(32, returndata), returndata_size)
712 
713                 }
714 
715             } else {
716 
717                 revert(errorMessage);
718 
719             }
720 
721         }
722 
723     }
724 
725 }
726 
727 
728 
729 contract Ownable is Context {
730 
731     address private _owner;
732 
733 
734 
735     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
736 
737 
738 
739     /**
740 
741      * @dev Initializes the contract setting the deployer as the initial owner.
742 
743      */
744 
745     constructor () internal {
746 
747         address msgSender = _msgSender();
748 
749         _owner = msgSender;
750 
751         emit OwnershipTransferred(address(0), msgSender);
752 
753     }
754 
755 
756 
757     /**
758 
759      * @dev Returns the address of the current owner.
760 
761      */
762 
763     function owner() public view returns (address) {
764 
765         return _owner;
766 
767     }
768 
769 
770 
771     /**
772 
773      * @dev Throws if called by any account other than the owner.
774 
775      */
776 
777     modifier onlyOwner() {
778 
779         require(_owner == _msgSender(), "Ownable: caller is not the owner");
780 
781         _;
782 
783     }
784 
785 
786 
787     /**
788 
789      * @dev Leaves the contract without owner. It will not be possible to call
790 
791      * `onlyOwner` functions anymore. Can only be called by the current owner.
792 
793      *
794 
795      * NOTE: Renouncing ownership will leave the contract without an owner,
796 
797      * thereby removing any functionality that is only available to the owner.
798 
799      */
800 
801     function renounceOwnership() public virtual onlyOwner {
802 
803         emit OwnershipTransferred(_owner, address(0));
804 
805         _owner = address(0);
806 
807     }
808 
809 
810 
811     /**
812 
813      * @dev Transfers ownership of the contract to a new account (`newOwner`).
814 
815      * Can only be called by the current owner.
816 
817      */
818 
819     function transferOwnership(address newOwner) public virtual onlyOwner {
820 
821         require(newOwner != address(0), "Ownable: new owner is the zero address");
822 
823         emit OwnershipTransferred(_owner, newOwner);
824 
825         _owner = newOwner;
826 
827     }
828 
829 }
830 
831 
832 
833 
834 
835 
836 
837 contract Firulais is Context, IERC20, Ownable {
838 
839     using SafeMath for uint256;
840 
841     using Address for address;
842 
843 
844 
845     mapping (address => uint256) private _rOwned;
846 
847     mapping (address => uint256) private _tOwned;
848 
849     mapping (address => mapping (address => uint256)) private _allowances;
850 
851 
852 
853     mapping (address => bool) private _isExcluded;
854 
855     address[] private _excluded;
856 
857    
858 
859     uint256 private constant MAX = ~uint256(0);
860 
861     uint256 private constant _tTotal = 100000000000 * 10**6 * 10**9;
862 
863     uint256 private _rTotal = (MAX - (MAX % _tTotal));
864 
865     uint256 private _tFeeTotal;
866 
867 
868 
869     string private _name = 'Firulais';
870 
871     string private _symbol = 'FIRU';
872 
873     uint8 private _decimals = 9;
874 
875 
876 
877     constructor () public {
878 
879         _rOwned[_msgSender()] = _rTotal;
880 
881         emit Transfer(address(0), _msgSender(), _tTotal);
882 
883     }
884 
885 
886 
887     function name() public view returns (string memory) {
888 
889         return _name;
890 
891     }
892 
893 
894 
895     function symbol() public view returns (string memory) {
896 
897         return _symbol;
898 
899     }
900 
901 
902 
903     function decimals() public view returns (uint8) {
904 
905         return _decimals;
906 
907     }
908 
909 
910 
911     function totalSupply() public view override returns (uint256) {
912 
913         return _tTotal;
914 
915     }
916 
917 
918 
919     function balanceOf(address account) public view override returns (uint256) {
920 
921         if (_isExcluded[account]) return _tOwned[account];
922 
923         return tokenFromReflection(_rOwned[account]);
924 
925     }
926 
927 
928 
929     function transfer(address recipient, uint256 amount) public override returns (bool) {
930 
931         _transfer(_msgSender(), recipient, amount);
932 
933         return true;
934 
935     }
936 
937 
938 
939     function allowance(address owner, address spender) public view override returns (uint256) {
940 
941         return _allowances[owner][spender];
942 
943     }
944 
945 
946 
947     function approve(address spender, uint256 amount) public override returns (bool) {
948 
949         _approve(_msgSender(), spender, amount);
950 
951         return true;
952 
953     }
954 
955 
956 
957     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
958 
959         _transfer(sender, recipient, amount);
960 
961         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
962 
963         return true;
964 
965     }
966 
967 
968 
969     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
970 
971         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
972 
973         return true;
974 
975     }
976 
977 
978 
979     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
980 
981         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
982 
983         return true;
984 
985     }
986 
987 
988 
989     function isExcluded(address account) public view returns (bool) {
990 
991         return _isExcluded[account];
992 
993     }
994 
995 
996 
997     function totalFees() public view returns (uint256) {
998 
999         return _tFeeTotal;
1000 
1001     }
1002 
1003 
1004 
1005     function reflect(uint256 tAmount) public {
1006 
1007         address sender = _msgSender();
1008 
1009         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
1010 
1011         (uint256 rAmount,,,,) = _getValues(tAmount);
1012 
1013         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1014 
1015         _rTotal = _rTotal.sub(rAmount);
1016 
1017         _tFeeTotal = _tFeeTotal.add(tAmount);
1018 
1019     }
1020 
1021 
1022 
1023     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
1024 
1025         require(tAmount <= _tTotal, "Amount must be less than supply");
1026 
1027         if (!deductTransferFee) {
1028 
1029             (uint256 rAmount,,,,) = _getValues(tAmount);
1030 
1031             return rAmount;
1032 
1033         } else {
1034 
1035             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
1036 
1037             return rTransferAmount;
1038 
1039         }
1040 
1041     }
1042 
1043 
1044 
1045     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
1046 
1047         require(rAmount <= _rTotal, "Amount must be less than total reflections");
1048 
1049         uint256 currentRate =  _getRate();
1050 
1051         return rAmount.div(currentRate);
1052 
1053     }
1054 
1055 
1056 
1057     function excludeAccount(address account) external onlyOwner() {
1058 
1059         require(!_isExcluded[account], "Account is already excluded");
1060 
1061         if(_rOwned[account] > 0) {
1062 
1063             _tOwned[account] = tokenFromReflection(_rOwned[account]);
1064 
1065         }
1066 
1067         _isExcluded[account] = true;
1068 
1069         _excluded.push(account);
1070 
1071     }
1072 
1073 
1074 
1075     function includeAccount(address account) external onlyOwner() {
1076 
1077         require(_isExcluded[account], "Account is already excluded");
1078 
1079         for (uint256 i = 0; i < _excluded.length; i++) {
1080 
1081             if (_excluded[i] == account) {
1082 
1083                 _excluded[i] = _excluded[_excluded.length - 1];
1084 
1085                 _tOwned[account] = 0;
1086 
1087                 _isExcluded[account] = false;
1088 
1089                 _excluded.pop();
1090 
1091                 break;
1092 
1093             }
1094 
1095         }
1096 
1097     }
1098 
1099 
1100 
1101     function _approve(address owner, address spender, uint256 amount) private {
1102 
1103         require(owner != address(0), "ERC20: approve from the zero address");
1104 
1105         require(spender != address(0), "ERC20: approve to the zero address");
1106 
1107 
1108 
1109         _allowances[owner][spender] = amount;
1110 
1111         emit Approval(owner, spender, amount);
1112 
1113     }
1114 
1115 
1116 
1117     function _transfer(address sender, address recipient, uint256 amount) private {
1118 
1119         require(sender != address(0), "ERC20: transfer from the zero address");
1120 
1121         require(recipient != address(0), "ERC20: transfer to the zero address");
1122 
1123         require(amount > 0, "Transfer amount must be greater than zero");
1124 
1125         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1126 
1127             _transferFromExcluded(sender, recipient, amount);
1128 
1129         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1130 
1131             _transferToExcluded(sender, recipient, amount);
1132 
1133         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1134 
1135             _transferStandard(sender, recipient, amount);
1136 
1137         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1138 
1139             _transferBothExcluded(sender, recipient, amount);
1140 
1141         } else {
1142 
1143             _transferStandard(sender, recipient, amount);
1144 
1145         }
1146 
1147     }
1148 
1149 
1150 
1151     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1152 
1153         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
1154 
1155         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1156 
1157         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
1158 
1159         _reflectFee(rFee, tFee);
1160 
1161         emit Transfer(sender, recipient, tTransferAmount);
1162 
1163     }
1164 
1165 
1166 
1167     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1168 
1169         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
1170 
1171         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1172 
1173         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1174 
1175         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1176 
1177         _reflectFee(rFee, tFee);
1178 
1179         emit Transfer(sender, recipient, tTransferAmount);
1180 
1181     }
1182 
1183 
1184 
1185     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1186 
1187         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
1188 
1189         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1190 
1191         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1192 
1193         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1194 
1195         _reflectFee(rFee, tFee);
1196 
1197         emit Transfer(sender, recipient, tTransferAmount);
1198 
1199     }
1200 
1201 
1202 
1203     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1204 
1205         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
1206 
1207         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1208 
1209         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1210 
1211         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1212 
1213         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
1214 
1215         _reflectFee(rFee, tFee);
1216 
1217         emit Transfer(sender, recipient, tTransferAmount);
1218 
1219     }
1220 
1221 
1222 
1223     function _reflectFee(uint256 rFee, uint256 tFee) private {
1224 
1225         _rTotal = _rTotal.sub(rFee);
1226 
1227         _tFeeTotal = _tFeeTotal.add(tFee);
1228 
1229     }
1230 
1231 
1232 
1233     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
1234 
1235         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
1236 
1237         uint256 currentRate =  _getRate();
1238 
1239         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
1240 
1241         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
1242 
1243     }
1244 
1245 
1246 
1247     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
1248 
1249         uint256 tFee = tAmount.div(100).mul(2);
1250 
1251         uint256 tTransferAmount = tAmount.sub(tFee);
1252 
1253         return (tTransferAmount, tFee);
1254 
1255     }
1256 
1257 
1258 
1259     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1260 
1261         uint256 rAmount = tAmount.mul(currentRate);
1262 
1263         uint256 rFee = tFee.mul(currentRate);
1264 
1265         uint256 rTransferAmount = rAmount.sub(rFee);
1266 
1267         return (rAmount, rTransferAmount, rFee);
1268 
1269     }
1270 
1271 
1272 
1273     function _getRate() private view returns(uint256) {
1274 
1275         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1276 
1277         return rSupply.div(tSupply);
1278 
1279     }
1280 
1281 
1282 
1283     function _getCurrentSupply() private view returns(uint256, uint256) {
1284 
1285         uint256 rSupply = _rTotal;
1286 
1287         uint256 tSupply = _tTotal;      
1288 
1289         for (uint256 i = 0; i < _excluded.length; i++) {
1290 
1291             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1292 
1293             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1294 
1295             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1296 
1297         }
1298 
1299         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1300 
1301         return (rSupply, tSupply);
1302 
1303     }
1304 
1305 }