1 /**
2  *Submitted for verification at Etherscan.io on 2021-06-18
3  */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-06-16
7  */
8 
9 // SPDX-License-Identifier: AGPL-3.0-or-later
10 pragma solidity 0.7.5;
11 
12 interface IOwnable {
13     function policy() external view returns (address);
14 
15     function renounceManagement() external;
16 
17     function pushManagement(address newOwner_) external;
18 
19     function pullManagement() external;
20 }
21 
22 contract Ownable is IOwnable {
23     address internal _owner;
24     address internal _newOwner;
25 
26     event OwnershipPushed(
27         address indexed previousOwner,
28         address indexed newOwner
29     );
30     event OwnershipPulled(
31         address indexed previousOwner,
32         address indexed newOwner
33     );
34 
35     constructor() {
36         _owner = msg.sender;
37         emit OwnershipPushed(address(0), _owner);
38     }
39 
40     function policy() public view override returns (address) {
41         return _owner;
42     }
43 
44     modifier onlyPolicy() {
45         require(_owner == msg.sender, "Ownable: caller is not the owner");
46         _;
47     }
48 
49     function renounceManagement() public virtual override onlyPolicy {
50         emit OwnershipPushed(_owner, address(0));
51         _owner = address(0);
52     }
53 
54     function pushManagement(address newOwner_)
55         public
56         virtual
57         override
58         onlyPolicy
59     {
60         require(
61             newOwner_ != address(0),
62             "Ownable: new owner is the zero address"
63         );
64         emit OwnershipPushed(_owner, newOwner_);
65         _newOwner = newOwner_;
66     }
67 
68     function pullManagement() public virtual override {
69         require(msg.sender == _newOwner, "Ownable: must be new owner to pull");
70         emit OwnershipPulled(_owner, _newOwner);
71         _owner = _newOwner;
72     }
73 }
74 
75 library SafeMath {
76     function add(uint256 a, uint256 b) internal pure returns (uint256) {
77         uint256 c = a + b;
78         require(c >= a, "SafeMath: addition overflow");
79 
80         return c;
81     }
82 
83     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
84         return sub(a, b, "SafeMath: subtraction overflow");
85     }
86 
87     function sub(
88         uint256 a,
89         uint256 b,
90         string memory errorMessage
91     ) internal pure returns (uint256) {
92         require(b <= a, errorMessage);
93         uint256 c = a - b;
94 
95         return c;
96     }
97 
98     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
99         if (a == 0) {
100             return 0;
101         }
102 
103         uint256 c = a * b;
104         require(c / a == b, "SafeMath: multiplication overflow");
105 
106         return c;
107     }
108 
109     function div(uint256 a, uint256 b) internal pure returns (uint256) {
110         return div(a, b, "SafeMath: division by zero");
111     }
112 
113     function div(
114         uint256 a,
115         uint256 b,
116         string memory errorMessage
117     ) internal pure returns (uint256) {
118         require(b > 0, errorMessage);
119         uint256 c = a / b;
120         return c;
121     }
122 
123     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
124         return mod(a, b, "SafeMath: modulo by zero");
125     }
126 
127     function mod(
128         uint256 a,
129         uint256 b,
130         string memory errorMessage
131     ) internal pure returns (uint256) {
132         require(b != 0, errorMessage);
133         return a % b;
134     }
135 
136     function sqrrt(uint256 a) internal pure returns (uint256 c) {
137         if (a > 3) {
138             c = a;
139             uint256 b = add(div(a, 2), 1);
140             while (b < c) {
141                 c = b;
142                 b = div(add(div(a, b), b), 2);
143             }
144         } else if (a != 0) {
145             c = 1;
146         }
147     }
148 }
149 
150 library Address {
151     function isContract(address account) internal view returns (bool) {
152         uint256 size;
153         // solhint-disable-next-line no-inline-assembly
154         assembly {
155             size := extcodesize(account)
156         }
157         return size > 0;
158     }
159 
160     function sendValue(address payable recipient, uint256 amount) internal {
161         require(
162             address(this).balance >= amount,
163             "Address: insufficient balance"
164         );
165 
166         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
167         (bool success, ) = recipient.call{value: amount}("");
168         require(
169             success,
170             "Address: unable to send value, recipient may have reverted"
171         );
172     }
173 
174     function functionCall(address target, bytes memory data)
175         internal
176         returns (bytes memory)
177     {
178         return functionCall(target, data, "Address: low-level call failed");
179     }
180 
181     function functionCall(
182         address target,
183         bytes memory data,
184         string memory errorMessage
185     ) internal returns (bytes memory) {
186         return _functionCallWithValue(target, data, 0, errorMessage);
187     }
188 
189     function functionCallWithValue(
190         address target,
191         bytes memory data,
192         uint256 value
193     ) internal returns (bytes memory) {
194         return
195             functionCallWithValue(
196                 target,
197                 data,
198                 value,
199                 "Address: low-level call with value failed"
200             );
201     }
202 
203     function functionCallWithValue(
204         address target,
205         bytes memory data,
206         uint256 value,
207         string memory errorMessage
208     ) internal returns (bytes memory) {
209         require(
210             address(this).balance >= value,
211             "Address: insufficient balance for call"
212         );
213         require(isContract(target), "Address: call to non-contract");
214 
215         // solhint-disable-next-line avoid-low-level-calls
216         (bool success, bytes memory returndata) = target.call{value: value}(
217             data
218         );
219         return _verifyCallResult(success, returndata, errorMessage);
220     }
221 
222     function _functionCallWithValue(
223         address target,
224         bytes memory data,
225         uint256 weiValue,
226         string memory errorMessage
227     ) private returns (bytes memory) {
228         require(isContract(target), "Address: call to non-contract");
229 
230         // solhint-disable-next-line avoid-low-level-calls
231         (bool success, bytes memory returndata) = target.call{value: weiValue}(
232             data
233         );
234         if (success) {
235             return returndata;
236         } else {
237             // Look for revert reason and bubble it up if present
238             if (returndata.length > 0) {
239                 // The easiest way to bubble the revert reason is using memory via assembly
240 
241                 // solhint-disable-next-line no-inline-assembly
242                 assembly {
243                     let returndata_size := mload(returndata)
244                     revert(add(32, returndata), returndata_size)
245                 }
246             } else {
247                 revert(errorMessage);
248             }
249         }
250     }
251 
252     function functionStaticCall(address target, bytes memory data)
253         internal
254         view
255         returns (bytes memory)
256     {
257         return
258             functionStaticCall(
259                 target,
260                 data,
261                 "Address: low-level static call failed"
262             );
263     }
264 
265     function functionStaticCall(
266         address target,
267         bytes memory data,
268         string memory errorMessage
269     ) internal view returns (bytes memory) {
270         require(isContract(target), "Address: static call to non-contract");
271 
272         // solhint-disable-next-line avoid-low-level-calls
273         (bool success, bytes memory returndata) = target.staticcall(data);
274         return _verifyCallResult(success, returndata, errorMessage);
275     }
276 
277     function functionDelegateCall(address target, bytes memory data)
278         internal
279         returns (bytes memory)
280     {
281         return
282             functionDelegateCall(
283                 target,
284                 data,
285                 "Address: low-level delegate call failed"
286             );
287     }
288 
289     function functionDelegateCall(
290         address target,
291         bytes memory data,
292         string memory errorMessage
293     ) internal returns (bytes memory) {
294         require(isContract(target), "Address: delegate call to non-contract");
295 
296         // solhint-disable-next-line avoid-low-level-calls
297         (bool success, bytes memory returndata) = target.delegatecall(data);
298         return _verifyCallResult(success, returndata, errorMessage);
299     }
300 
301     function _verifyCallResult(
302         bool success,
303         bytes memory returndata,
304         string memory errorMessage
305     ) private pure returns (bytes memory) {
306         if (success) {
307             return returndata;
308         } else {
309             if (returndata.length > 0) {
310                 assembly {
311                     let returndata_size := mload(returndata)
312                     revert(add(32, returndata), returndata_size)
313                 }
314             } else {
315                 revert(errorMessage);
316             }
317         }
318     }
319 
320     function addressToString(address _address)
321         internal
322         pure
323         returns (string memory)
324     {
325         bytes32 _bytes = bytes32(uint256(_address));
326         bytes memory HEX = "0123456789abcdef";
327         bytes memory _addr = new bytes(42);
328 
329         _addr[0] = "0";
330         _addr[1] = "x";
331 
332         for (uint256 i = 0; i < 20; i++) {
333             _addr[2 + i * 2] = HEX[uint8(_bytes[i + 12] >> 4)];
334             _addr[3 + i * 2] = HEX[uint8(_bytes[i + 12] & 0x0f)];
335         }
336 
337         return string(_addr);
338     }
339 }
340 
341 interface IERC20 {
342     function decimals() external view returns (uint8);
343 
344     function totalSupply() external view returns (uint256);
345 
346     function balanceOf(address account) external view returns (uint256);
347 
348     function transfer(address recipient, uint256 amount)
349         external
350         returns (bool);
351 
352     function allowance(address owner, address spender)
353         external
354         view
355         returns (uint256);
356 
357     function approve(address spender, uint256 amount) external returns (bool);
358 
359     function transferFrom(
360         address sender,
361         address recipient,
362         uint256 amount
363     ) external returns (bool);
364 
365     event Transfer(address indexed from, address indexed to, uint256 value);
366 
367     event Approval(
368         address indexed owner,
369         address indexed spender,
370         uint256 value
371     );
372 }
373 
374 abstract contract ERC20 is IERC20 {
375     using SafeMath for uint256;
376 
377     // TODO comment actual hash value.
378     bytes32 private constant ERC20TOKEN_ERC1820_INTERFACE_ID =
379         keccak256("ERC20Token");
380 
381     mapping(address => uint256) internal _balances;
382 
383     mapping(address => mapping(address => uint256)) internal _allowances;
384 
385     uint256 internal _totalSupply;
386 
387     string internal _name;
388 
389     string internal _symbol;
390 
391     uint8 internal _decimals;
392 
393     constructor(
394         string memory name_,
395         string memory symbol_,
396         uint8 decimals_
397     ) {
398         _name = name_;
399         _symbol = symbol_;
400         _decimals = decimals_;
401     }
402 
403     function name() public view returns (string memory) {
404         return _name;
405     }
406 
407     function symbol() public view returns (string memory) {
408         return _symbol;
409     }
410 
411     function decimals() public view override returns (uint8) {
412         return _decimals;
413     }
414 
415     function totalSupply() public view override returns (uint256) {
416         return _totalSupply;
417     }
418 
419     function balanceOf(address account)
420         public
421         view
422         virtual
423         override
424         returns (uint256)
425     {
426         return _balances[account];
427     }
428 
429     function transfer(address recipient, uint256 amount)
430         public
431         virtual
432         override
433         returns (bool)
434     {
435         _transfer(msg.sender, recipient, amount);
436         return true;
437     }
438 
439     function allowance(address owner, address spender)
440         public
441         view
442         virtual
443         override
444         returns (uint256)
445     {
446         return _allowances[owner][spender];
447     }
448 
449     function approve(address spender, uint256 amount)
450         public
451         virtual
452         override
453         returns (bool)
454     {
455         _approve(msg.sender, spender, amount);
456         return true;
457     }
458 
459     function transferFrom(
460         address sender,
461         address recipient,
462         uint256 amount
463     ) public virtual override returns (bool) {
464         _transfer(sender, recipient, amount);
465         _approve(
466             sender,
467             msg.sender,
468             _allowances[sender][msg.sender].sub(
469                 amount,
470                 "ERC20: transfer amount exceeds allowance"
471             )
472         );
473         return true;
474     }
475 
476     function increaseAllowance(address spender, uint256 addedValue)
477         public
478         virtual
479         returns (bool)
480     {
481         _approve(
482             msg.sender,
483             spender,
484             _allowances[msg.sender][spender].add(addedValue)
485         );
486         return true;
487     }
488 
489     function decreaseAllowance(address spender, uint256 subtractedValue)
490         public
491         virtual
492         returns (bool)
493     {
494         _approve(
495             msg.sender,
496             spender,
497             _allowances[msg.sender][spender].sub(
498                 subtractedValue,
499                 "ERC20: decreased allowance below zero"
500             )
501         );
502         return true;
503     }
504 
505     function _transfer(
506         address sender,
507         address recipient,
508         uint256 amount
509     ) internal virtual {
510         require(sender != address(0), "ERC20: transfer from the zero address");
511         require(recipient != address(0), "ERC20: transfer to the zero address");
512 
513         _beforeTokenTransfer(sender, recipient, amount);
514 
515         _balances[sender] = _balances[sender].sub(
516             amount,
517             "ERC20: transfer amount exceeds balance"
518         );
519         _balances[recipient] = _balances[recipient].add(amount);
520         emit Transfer(sender, recipient, amount);
521     }
522 
523     function _mint(address account_, uint256 ammount_) internal virtual {
524         require(account_ != address(0), "ERC20: mint to the zero address");
525         _beforeTokenTransfer(address(this), account_, ammount_);
526         _totalSupply = _totalSupply.add(ammount_);
527         _balances[account_] = _balances[account_].add(ammount_);
528         emit Transfer(address(this), account_, ammount_);
529     }
530 
531     function _burn(address account, uint256 amount) internal virtual {
532         require(account != address(0), "ERC20: burn from the zero address");
533 
534         _beforeTokenTransfer(account, address(0), amount);
535 
536         _balances[account] = _balances[account].sub(
537             amount,
538             "ERC20: burn amount exceeds balance"
539         );
540         _totalSupply = _totalSupply.sub(amount);
541         emit Transfer(account, address(0), amount);
542     }
543 
544     function _approve(
545         address owner,
546         address spender,
547         uint256 amount
548     ) internal virtual {
549         require(owner != address(0), "ERC20: approve from the zero address");
550         require(spender != address(0), "ERC20: approve to the zero address");
551 
552         _allowances[owner][spender] = amount;
553         emit Approval(owner, spender, amount);
554     }
555 
556     function _beforeTokenTransfer(
557         address from_,
558         address to_,
559         uint256 amount_
560     ) internal virtual {}
561 }
562 
563 interface IERC2612Permit {
564     function permit(
565         address owner,
566         address spender,
567         uint256 amount,
568         uint256 deadline,
569         uint8 v,
570         bytes32 r,
571         bytes32 s
572     ) external;
573 
574     function nonces(address owner) external view returns (uint256);
575 }
576 
577 library Counters {
578     using SafeMath for uint256;
579 
580     struct Counter {
581         uint256 _value; // default: 0
582     }
583 
584     function current(Counter storage counter) internal view returns (uint256) {
585         return counter._value;
586     }
587 
588     function increment(Counter storage counter) internal {
589         counter._value += 1;
590     }
591 
592     function decrement(Counter storage counter) internal {
593         counter._value = counter._value.sub(1);
594     }
595 }
596 
597 abstract contract ERC20Permit is ERC20, IERC2612Permit {
598     using Counters for Counters.Counter;
599 
600     mapping(address => Counters.Counter) private _nonces;
601 
602     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
603     bytes32 public constant PERMIT_TYPEHASH =
604         0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
605 
606     bytes32 public DOMAIN_SEPARATOR;
607 
608     constructor() {
609         uint256 chainID;
610         assembly {
611             chainID := chainid()
612         }
613 
614         DOMAIN_SEPARATOR = keccak256(
615             abi.encode(
616                 keccak256(
617                     "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
618                 ),
619                 keccak256(bytes(name())),
620                 keccak256(bytes("1")), // Version
621                 chainID,
622                 address(this)
623             )
624         );
625     }
626 
627     function permit(
628         address owner,
629         address spender,
630         uint256 amount,
631         uint256 deadline,
632         uint8 v,
633         bytes32 r,
634         bytes32 s
635     ) public virtual override {
636         require(block.timestamp <= deadline, "Permit: expired deadline");
637 
638         bytes32 hashStruct = keccak256(
639             abi.encode(
640                 PERMIT_TYPEHASH,
641                 owner,
642                 spender,
643                 amount,
644                 _nonces[owner].current(),
645                 deadline
646             )
647         );
648 
649         bytes32 _hash = keccak256(
650             abi.encodePacked(uint16(0x1901), DOMAIN_SEPARATOR, hashStruct)
651         );
652 
653         address signer = ecrecover(_hash, v, r, s);
654         require(
655             signer != address(0) && signer == owner,
656             "ZeroSwapPermit: Invalid signature"
657         );
658 
659         _nonces[owner].increment();
660         _approve(owner, spender, amount);
661     }
662 
663     function nonces(address owner) public view override returns (uint256) {
664         return _nonces[owner].current();
665     }
666 }
667 
668 library SafeERC20 {
669     using SafeMath for uint256;
670     using Address for address;
671 
672     function safeTransfer(
673         IERC20 token,
674         address to,
675         uint256 value
676     ) internal {
677         _callOptionalReturn(
678             token,
679             abi.encodeWithSelector(token.transfer.selector, to, value)
680         );
681     }
682 
683     function safeTransferFrom(
684         IERC20 token,
685         address from,
686         address to,
687         uint256 value
688     ) internal {
689         _callOptionalReturn(
690             token,
691             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
692         );
693     }
694 
695     function safeApprove(
696         IERC20 token,
697         address spender,
698         uint256 value
699     ) internal {
700         require(
701             (value == 0) || (token.allowance(address(this), spender) == 0),
702             "SafeERC20: approve from non-zero to non-zero allowance"
703         );
704         _callOptionalReturn(
705             token,
706             abi.encodeWithSelector(token.approve.selector, spender, value)
707         );
708     }
709 
710     function safeIncreaseAllowance(
711         IERC20 token,
712         address spender,
713         uint256 value
714     ) internal {
715         uint256 newAllowance = token.allowance(address(this), spender).add(
716             value
717         );
718         _callOptionalReturn(
719             token,
720             abi.encodeWithSelector(
721                 token.approve.selector,
722                 spender,
723                 newAllowance
724             )
725         );
726     }
727 
728     function safeDecreaseAllowance(
729         IERC20 token,
730         address spender,
731         uint256 value
732     ) internal {
733         uint256 newAllowance = token.allowance(address(this), spender).sub(
734             value,
735             "SafeERC20: decreased allowance below zero"
736         );
737         _callOptionalReturn(
738             token,
739             abi.encodeWithSelector(
740                 token.approve.selector,
741                 spender,
742                 newAllowance
743             )
744         );
745     }
746 
747     function _callOptionalReturn(IERC20 token, bytes memory data) private {
748         bytes memory returndata = address(token).functionCall(
749             data,
750             "SafeERC20: low-level call failed"
751         );
752         if (returndata.length > 0) {
753             // Return data is optional
754             // solhint-disable-next-line max-line-length
755             require(
756                 abi.decode(returndata, (bool)),
757                 "SafeERC20: ERC20 operation did not succeed"
758             );
759         }
760     }
761 }
762 
763 library FullMath {
764     function fullMul(uint256 x, uint256 y)
765         private
766         pure
767         returns (uint256 l, uint256 h)
768     {
769         uint256 mm = mulmod(x, y, uint256(-1));
770         l = x * y;
771         h = mm - l;
772         if (mm < l) h -= 1;
773     }
774 
775     function fullDiv(
776         uint256 l,
777         uint256 h,
778         uint256 d
779     ) private pure returns (uint256) {
780         uint256 pow2 = d & -d;
781         d /= pow2;
782         l /= pow2;
783         l += h * ((-pow2) / pow2 + 1);
784         uint256 r = 1;
785         r *= 2 - d * r;
786         r *= 2 - d * r;
787         r *= 2 - d * r;
788         r *= 2 - d * r;
789         r *= 2 - d * r;
790         r *= 2 - d * r;
791         r *= 2 - d * r;
792         r *= 2 - d * r;
793         return l * r;
794     }
795 
796     function mulDiv(
797         uint256 x,
798         uint256 y,
799         uint256 d
800     ) internal pure returns (uint256) {
801         (uint256 l, uint256 h) = fullMul(x, y);
802         uint256 mm = mulmod(x, y, d);
803         if (mm > l) h -= 1;
804         l -= mm;
805         require(h < d, "FullMath::mulDiv: overflow");
806         return fullDiv(l, h, d);
807     }
808 }
809 
810 library FixedPoint {
811     struct uq112x112 {
812         uint224 _x;
813     }
814 
815     struct uq144x112 {
816         uint256 _x;
817     }
818 
819     uint8 private constant RESOLUTION = 112;
820     uint256 private constant Q112 = 0x10000000000000000000000000000;
821     uint256 private constant Q224 =
822         0x100000000000000000000000000000000000000000000000000000000;
823     uint256 private constant LOWER_MASK = 0xffffffffffffffffffffffffffff; // decimal of UQ*x112 (lower 112 bits)
824 
825     function decode(uq112x112 memory self) internal pure returns (uint112) {
826         return uint112(self._x >> RESOLUTION);
827     }
828 
829     function decode112with18(uq112x112 memory self)
830         internal
831         pure
832         returns (uint256)
833     {
834         return uint256(self._x) / 5192296858534827;
835     }
836 
837     function fraction(uint256 numerator, uint256 denominator)
838         internal
839         pure
840         returns (uq112x112 memory)
841     {
842         require(denominator > 0, "FixedPoint::fraction: division by zero");
843         if (numerator == 0) return FixedPoint.uq112x112(0);
844 
845         if (numerator <= uint144(-1)) {
846             uint256 result = (numerator << RESOLUTION) / denominator;
847             require(result <= uint224(-1), "FixedPoint::fraction: overflow");
848             return uq112x112(uint224(result));
849         } else {
850             uint256 result = FullMath.mulDiv(numerator, Q112, denominator);
851             require(result <= uint224(-1), "FixedPoint::fraction: overflow");
852             return uq112x112(uint224(result));
853         }
854     }
855 }
856 
857 interface ITreasury {
858     function deposit(
859         uint256 _amount,
860         address _token,
861         uint256 _profit
862     ) external returns (bool);
863 
864     function valueOf_(address _token, uint256 _amount)
865         external
866         view
867         returns (uint256 value_);
868 }
869 
870 interface IBondCalculator {
871     function valuation(address _LP, uint256 _amount)
872         external
873         view
874         returns (uint256);
875 
876     function markdown(address _LP) external view returns (uint256);
877 }
878 
879 interface IStaking {
880     function stake(uint256 _amount, address _recipient) external returns (bool);
881 }
882 
883 interface IStakingHelper {
884     function stake(uint256 _amount, address _recipient) external;
885 }
886 
887 contract AsgardBondDepository is Ownable {
888     using FixedPoint for *;
889     using SafeERC20 for IERC20;
890     using SafeMath for uint256;
891 
892     /* ======== EVENTS ======== */
893 
894     event BondCreated(
895         uint256 deposit,
896         uint256 indexed payout,
897         uint256 indexed expires,
898         uint256 indexed priceInUSD
899     );
900     event BondRedeemed(
901         address indexed recipient,
902         uint256 payout,
903         uint256 remaining
904     );
905     event BondPriceChanged(
906         uint256 indexed priceInUSD,
907         uint256 indexed internalPrice,
908         uint256 indexed debtRatio
909     );
910     event ControlVariableAdjustment(
911         uint256 initialBCV,
912         uint256 newBCV,
913         uint256 adjustment,
914         bool addition
915     );
916 
917     /* ======== STATE VARIABLES ======== */
918 
919     address public immutable ASG; // token given as payment for bond
920     address public immutable principle; // token used to create bond
921     address public immutable treasury; // mints ASG when receives principle
922     address public immutable DAO; // receives profit share from bond
923 
924     bool public immutable isLiquidityBond; // LP and Reserve bonds are treated slightly different
925     address public immutable bondCalculator; // calculates value of LP tokens
926 
927     address public staking; // to auto-stake payout
928     address public stakingHelper; // to stake and claim if no staking warmup
929     bool public useHelper;
930 
931     Terms public terms; // stores terms for new bonds
932     Adjust public adjustment; // stores adjustment to BCV data
933 
934     mapping(address => Bond) public bondInfo; // stores bond information for depositors
935 
936     uint256 public totalDebt; // total value of outstanding bonds; used for pricing
937     uint256 public lastDecay; // reference block for debt decay
938 
939     /* ======== STRUCTS ======== */
940 
941     // Info for creating new bonds
942     struct Terms {
943         uint256 controlVariable; // scaling variable for price
944         uint256 vestingTerm; // in blocks
945         uint256 minimumPrice; // vs principle value
946         uint256 maxPayout; // in thousandths of a %. i.e. 500 = 0.5%
947         uint256 fee; // as % of bond payout, in hundreths. ( 500 = 5% = 0.05 for every 1 paid)
948         uint256 maxDebt; // 9 decimal debt ratio, max % total supply created as debt
949     }
950 
951     // Info for bond holder
952     struct Bond {
953         uint256 payout; // ASG remaining to be paid
954         uint256 vesting; // Blocks left to vest
955         uint256 lastBlock; // Last interaction
956         uint256 pricePaid; // In DAI, for front end viewing
957     }
958 
959     // Info for incremental adjustments to control variable
960     struct Adjust {
961         bool add; // addition or subtraction
962         uint256 rate; // increment
963         uint256 target; // BCV when adjustment finished
964         uint256 buffer; // minimum length (in blocks) between adjustments
965         uint256 lastBlock; // block when last adjustment made
966     }
967 
968     /* ======== INITIALIZATION ======== */
969 
970     constructor(
971         address _ASG,
972         address _principle,
973         address _treasury,
974         address _DAO,
975         address _bondCalculator
976     ) {
977         require(_ASG != address(0));
978         ASG = _ASG;
979         require(_principle != address(0));
980         principle = _principle;
981         require(_treasury != address(0));
982         treasury = _treasury;
983         require(_DAO != address(0));
984         DAO = _DAO;
985         // bondCalculator should be address(0) if not LP bond
986         bondCalculator = _bondCalculator;
987         isLiquidityBond = (_bondCalculator != address(0));
988     }
989 
990     /**
991      *  @notice initializes bond parameters
992      *  @param _controlVariable uint
993      *  @param _vestingTerm uint
994      *  @param _minimumPrice uint
995      *  @param _maxPayout uint
996      *  @param _fee uint
997      *  @param _maxDebt uint
998      *  @param _initialDebt uint
999      */
1000     function initializeBondTerms(
1001         uint256 _controlVariable,
1002         uint256 _vestingTerm,
1003         uint256 _minimumPrice,
1004         uint256 _maxPayout,
1005         uint256 _fee,
1006         uint256 _maxDebt,
1007         uint256 _initialDebt
1008     ) external onlyPolicy {
1009         require(terms.controlVariable == 0, "Bonds must be initialized from 0");
1010         terms = Terms({
1011             controlVariable: _controlVariable,
1012             vestingTerm: _vestingTerm,
1013             minimumPrice: _minimumPrice,
1014             maxPayout: _maxPayout,
1015             fee: _fee,
1016             maxDebt: _maxDebt
1017         });
1018         totalDebt = _initialDebt;
1019         lastDecay = block.number;
1020     }
1021 
1022     /* ======== POLICY FUNCTIONS ======== */
1023 
1024     enum PARAMETER {
1025         VESTING,
1026         PAYOUT,
1027         FEE,
1028         DEBT
1029     }
1030 
1031     /**
1032      *  @notice set parameters for new bonds
1033      *  @param _parameter PARAMETER
1034      *  @param _input uint
1035      */
1036     function setBondTerms(PARAMETER _parameter, uint256 _input)
1037         external
1038         onlyPolicy
1039     {
1040         if (_parameter == PARAMETER.VESTING) {
1041             // 0
1042             require(_input >= 10000, "Vesting must be longer than 36 hours");
1043             terms.vestingTerm = _input;
1044         } else if (_parameter == PARAMETER.PAYOUT) {
1045             // 1
1046             require(_input <= 100000, "Payout cannot be above 100 percent");
1047             terms.maxPayout = _input;
1048         } else if (_parameter == PARAMETER.FEE) {
1049             // 2
1050             require(_input <= 10000, "DAO fee cannot exceed payout");
1051             terms.fee = _input;
1052         } else if (_parameter == PARAMETER.DEBT) {
1053             // 3
1054             terms.maxDebt = _input;
1055         }
1056     }
1057 
1058     /**
1059      *  @notice set control variable adjustment
1060      *  @param _addition bool
1061      *  @param _increment uint
1062      *  @param _target uint
1063      *  @param _buffer uint
1064      */
1065     function setAdjustment(
1066         bool _addition,
1067         uint256 _increment,
1068         uint256 _target,
1069         uint256 _buffer
1070     ) external onlyPolicy {
1071         adjustment = Adjust({
1072             add: _addition,
1073             rate: _increment,
1074             target: _target,
1075             buffer: _buffer,
1076             lastBlock: block.number
1077         });
1078     }
1079 
1080     /**
1081      *  @notice set contract for auto stake
1082      *  @param _staking address
1083      *  @param _helper bool
1084      */
1085     function setStaking(address _staking, bool _helper) external onlyPolicy {
1086         require(_staking != address(0));
1087         if (_helper) {
1088             useHelper = true;
1089             stakingHelper = _staking;
1090         } else {
1091             useHelper = false;
1092             staking = _staking;
1093         }
1094     }
1095 
1096     /* ======== USER FUNCTIONS ======== */
1097 
1098     /**
1099      *  @notice deposit bond
1100      *  @param _amount uint
1101      *  @param _maxPrice uint
1102      *  @param _depositor address
1103      *  @return uint
1104      */
1105     function deposit(
1106         uint256 _amount,
1107         uint256 _maxPrice,
1108         address _depositor
1109     ) external returns (uint256) {
1110         require(_depositor != address(0), "Invalid address");
1111 
1112         decayDebt();
1113         require(totalDebt <= terms.maxDebt, "Max capacity reached");
1114 
1115         uint256 priceInUSD = bondPriceInUSD(); // Stored in bond info
1116         uint256 nativePrice = _bondPrice();
1117 
1118         require(
1119             _maxPrice >= nativePrice,
1120             "Slippage limit: more than max price"
1121         ); // slippage protection
1122 
1123         uint256 value = ITreasury(treasury).valueOf_(principle, _amount);
1124         uint256 payout = payoutFor(value); // payout to bonder is computed
1125 
1126         require(payout >= 10000000, "Bond too small"); // must be > 0.01 ASG ( underflow protection )
1127         require(payout <= maxPayout(), "Bond too large"); // size protection because there is no slippage
1128 
1129         // profits are calculated
1130         uint256 fee = payout.mul(terms.fee).div(10000);
1131         uint256 profit = value.sub(payout).sub(fee);
1132 
1133         /**
1134             principle is transferred in
1135             approved and
1136             deposited into the treasury, returning (_amount - profit) ASG
1137          */
1138         IERC20(principle).safeTransferFrom(msg.sender, address(this), _amount);
1139         IERC20(principle).approve(address(treasury), _amount);
1140         ITreasury(treasury).deposit(_amount, principle, profit);
1141 
1142         if (fee != 0) {
1143             // fee is transferred to dao
1144             IERC20(ASG).safeTransfer(DAO, fee);
1145         }
1146 
1147         // total debt is increased
1148         totalDebt = totalDebt.add(value);
1149 
1150         // depositor info is stored
1151         bondInfo[_depositor] = Bond({
1152             payout: bondInfo[_depositor].payout.add(payout),
1153             vesting: terms.vestingTerm,
1154             lastBlock: block.number,
1155             pricePaid: priceInUSD
1156         });
1157 
1158         // indexed events are emitted
1159         emit BondCreated(
1160             _amount,
1161             payout,
1162             block.number.add(terms.vestingTerm),
1163             priceInUSD
1164         );
1165         emit BondPriceChanged(bondPriceInUSD(), _bondPrice(), debtRatio());
1166 
1167         adjust(); // control variable is adjusted
1168         return payout;
1169     }
1170 
1171     /**
1172      *  @notice redeem bond for user
1173      *  @param _recipient address
1174      *  @param _stake bool
1175      *  @return uint
1176      */
1177     function redeem(address _recipient, bool _stake)
1178         external
1179         returns (uint256)
1180     {
1181         Bond memory info = bondInfo[_recipient];
1182         uint256 percentVested = percentVestedFor(_recipient); // (blocks since last interaction / vesting term remaining)
1183 
1184         if (percentVested >= 10000) {
1185             // if fully vested
1186             delete bondInfo[_recipient]; // delete user info
1187             emit BondRedeemed(_recipient, info.payout, 0); // emit bond data
1188             return stakeOrSend(_recipient, _stake, info.payout); // pay user everything due
1189         } else {
1190             // if unfinished
1191             // calculate payout vested
1192             uint256 payout = info.payout.mul(percentVested).div(10000);
1193 
1194             // store updated deposit info
1195             bondInfo[_recipient] = Bond({
1196                 payout: info.payout.sub(payout),
1197                 vesting: info.vesting.sub(block.number.sub(info.lastBlock)),
1198                 lastBlock: block.number,
1199                 pricePaid: info.pricePaid
1200             });
1201 
1202             emit BondRedeemed(_recipient, payout, bondInfo[_recipient].payout);
1203             return stakeOrSend(_recipient, _stake, payout);
1204         }
1205     }
1206 
1207     /* ======== INTERNAL HELPER FUNCTIONS ======== */
1208 
1209     /**
1210      *  @notice allow user to stake payout automatically
1211      *  @param _stake bool
1212      *  @param _amount uint
1213      *  @return uint
1214      */
1215     function stakeOrSend(
1216         address _recipient,
1217         bool _stake,
1218         uint256 _amount
1219     ) internal returns (uint256) {
1220         if (!_stake) {
1221             // if user does not want to stake
1222             IERC20(ASG).transfer(_recipient, _amount); // send payout
1223         } else {
1224             // if user wants to stake
1225             if (useHelper) {
1226                 // use if staking warmup is 0
1227                 IERC20(ASG).approve(stakingHelper, _amount);
1228                 IStakingHelper(stakingHelper).stake(_amount, _recipient);
1229             } else {
1230                 IERC20(ASG).approve(staking, _amount);
1231                 IStaking(staking).stake(_amount, _recipient);
1232             }
1233         }
1234         return _amount;
1235     }
1236 
1237     /**
1238      *  @notice makes incremental adjustment to control variable
1239      */
1240     function adjust() internal {
1241         uint256 blockCanAdjust = adjustment.lastBlock.add(adjustment.buffer);
1242         if (adjustment.rate != 0 && block.number >= blockCanAdjust) {
1243             uint256 initial = terms.controlVariable;
1244             if (adjustment.add) {
1245                 terms.controlVariable = terms.controlVariable.add(
1246                     adjustment.rate
1247                 );
1248                 if (terms.controlVariable >= adjustment.target) {
1249                     adjustment.rate = 0;
1250                 }
1251             } else {
1252                 terms.controlVariable = terms.controlVariable.sub(
1253                     adjustment.rate
1254                 );
1255                 if (terms.controlVariable <= adjustment.target) {
1256                     adjustment.rate = 0;
1257                 }
1258             }
1259             adjustment.lastBlock = block.number;
1260             emit ControlVariableAdjustment(
1261                 initial,
1262                 terms.controlVariable,
1263                 adjustment.rate,
1264                 adjustment.add
1265             );
1266         }
1267     }
1268 
1269     /**
1270      *  @notice reduce total debt
1271      */
1272     function decayDebt() internal {
1273         totalDebt = totalDebt.sub(debtDecay());
1274         lastDecay = block.number;
1275     }
1276 
1277     /* ======== VIEW FUNCTIONS ======== */
1278 
1279     /**
1280      *  @notice determine maximum bond size
1281      *  @return uint
1282      */
1283     function maxPayout() public view returns (uint256) {
1284         return IERC20(ASG).totalSupply().mul(terms.maxPayout).div(100000);
1285     }
1286 
1287     /**
1288      *  @notice calculate interest due for new bond
1289      *  @param _value uint
1290      *  @return uint
1291      */
1292     function payoutFor(uint256 _value) public view returns (uint256) {
1293         return
1294             FixedPoint.fraction(_value, bondPrice()).decode112with18().div(
1295                 1e16
1296             );
1297     }
1298 
1299     /**
1300      *  @notice calculate current bond premium
1301      *  @return price_ uint
1302      */
1303     function bondPrice() public view returns (uint256 price_) {
1304         price_ = terms.controlVariable.mul(debtRatio()).add(1000000000).div(
1305             1e7
1306         );
1307         if (price_ < terms.minimumPrice) {
1308             price_ = terms.minimumPrice;
1309         }
1310     }
1311 
1312     /**
1313      *  @notice calculate current bond price and remove floor if above
1314      *  @return price_ uint
1315      */
1316     function _bondPrice() internal returns (uint256 price_) {
1317         price_ = terms.controlVariable.mul(debtRatio()).add(1000000000).div(
1318             1e7
1319         );
1320         if (price_ < terms.minimumPrice) {
1321             price_ = terms.minimumPrice;
1322         } else if (terms.minimumPrice != 0) {
1323             terms.minimumPrice = 0;
1324         }
1325     }
1326 
1327     /**
1328      *  @notice converts bond price to DAI value
1329      *  @return price_ uint
1330      */
1331     function bondPriceInUSD() public view returns (uint256 price_) {
1332         if (isLiquidityBond) {
1333             price_ = bondPrice()
1334                 .mul(IBondCalculator(bondCalculator).markdown(principle))
1335                 .div(100);
1336         } else {
1337             price_ = bondPrice().mul(10**IERC20(principle).decimals()).div(100);
1338         }
1339     }
1340 
1341     /**
1342      *  @notice calculate current ratio of debt to ASG supply
1343      *  @return debtRatio_ uint
1344      */
1345     function debtRatio() public view returns (uint256 debtRatio_) {
1346         uint256 supply = IERC20(ASG).totalSupply();
1347         debtRatio_ = FixedPoint
1348             .fraction(currentDebt().mul(1e9), supply)
1349             .decode112with18()
1350             .div(1e18);
1351     }
1352 
1353     /**
1354      *  @notice debt ratio in same terms for reserve or liquidity bonds
1355      *  @return uint
1356      */
1357     function standardizedDebtRatio() external view returns (uint256) {
1358         if (isLiquidityBond) {
1359             return
1360                 debtRatio()
1361                     .mul(IBondCalculator(bondCalculator).markdown(principle))
1362                     .div(1e9);
1363         } else {
1364             return debtRatio();
1365         }
1366     }
1367 
1368     /**
1369      *  @notice calculate debt factoring in decay
1370      *  @return uint
1371      */
1372     function currentDebt() public view returns (uint256) {
1373         return totalDebt.sub(debtDecay());
1374     }
1375 
1376     /**
1377      *  @notice amount to decay total debt by
1378      *  @return decay_ uint
1379      */
1380     function debtDecay() public view returns (uint256 decay_) {
1381         uint256 blocksSinceLast = block.number.sub(lastDecay);
1382         decay_ = totalDebt.mul(blocksSinceLast).div(terms.vestingTerm);
1383         if (decay_ > totalDebt) {
1384             decay_ = totalDebt;
1385         }
1386     }
1387 
1388     /**
1389      *  @notice calculate how far into vesting a depositor is
1390      *  @param _depositor address
1391      *  @return percentVested_ uint
1392      */
1393     function percentVestedFor(address _depositor)
1394         public
1395         view
1396         returns (uint256 percentVested_)
1397     {
1398         Bond memory bond = bondInfo[_depositor];
1399         uint256 blocksSinceLast = block.number.sub(bond.lastBlock);
1400         uint256 vesting = bond.vesting;
1401 
1402         if (vesting > 0) {
1403             percentVested_ = blocksSinceLast.mul(10000).div(vesting);
1404         } else {
1405             percentVested_ = 0;
1406         }
1407     }
1408 
1409     /**
1410      *  @notice calculate amount of ASG available for claim by depositor
1411      *  @param _depositor address
1412      *  @return pendingPayout_ uint
1413      */
1414     function pendingPayoutFor(address _depositor)
1415         external
1416         view
1417         returns (uint256 pendingPayout_)
1418     {
1419         uint256 percentVested = percentVestedFor(_depositor);
1420         uint256 payout = bondInfo[_depositor].payout;
1421 
1422         if (percentVested >= 10000) {
1423             pendingPayout_ = payout;
1424         } else {
1425             pendingPayout_ = payout.mul(percentVested).div(10000);
1426         }
1427     }
1428 
1429     /* ======= AUXILLIARY ======= */
1430 
1431     /**
1432      *  @notice allow anyone to send lost tokens (excluding principle or ASG) to the DAO
1433      *  @return bool
1434      */
1435     function recoverLostToken(address _token) external returns (bool) {
1436         require(_token != ASG);
1437         require(_token != principle);
1438         IERC20(_token).safeTransfer(
1439             DAO,
1440             IERC20(_token).balanceOf(address(this))
1441         );
1442         return true;
1443     }
1444 }