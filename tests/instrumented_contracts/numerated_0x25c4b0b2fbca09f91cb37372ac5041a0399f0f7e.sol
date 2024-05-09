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
12 
13 interface IOwnable {
14     function policy() external view returns (address);
15 
16     function renounceManagement() external;
17 
18     function pushManagement(address newOwner_) external;
19 
20     function pullManagement() external;
21 }
22 
23 contract Ownable is IOwnable {
24     address internal _owner;
25     address internal _newOwner;
26 
27     event OwnershipPushed(
28         address indexed previousOwner,
29         address indexed newOwner
30     );
31     event OwnershipPulled(
32         address indexed previousOwner,
33         address indexed newOwner
34     );
35 
36     constructor() {
37         _owner = msg.sender;
38         emit OwnershipPushed(address(0), _owner);
39     }
40 
41     function policy() public view override returns (address) {
42         return _owner;
43     }
44 
45     modifier onlyPolicy() {
46         require(_owner == msg.sender, "Ownable: caller is not the owner");
47         _;
48     }
49 
50     function renounceManagement() public virtual override onlyPolicy {
51         emit OwnershipPushed(_owner, address(0));
52         _owner = address(0);
53     }
54 
55     function pushManagement(address newOwner_)
56         public
57         virtual
58         override
59         onlyPolicy
60     {
61         require(
62             newOwner_ != address(0),
63             "Ownable: new owner is the zero address"
64         );
65         emit OwnershipPushed(_owner, newOwner_);
66         _newOwner = newOwner_;
67     }
68 
69     function pullManagement() public virtual override {
70         require(msg.sender == _newOwner, "Ownable: must be new owner to pull");
71         emit OwnershipPulled(_owner, _newOwner);
72         _owner = _newOwner;
73     }
74 }
75 
76 library SafeMath {
77     function add(uint256 a, uint256 b) internal pure returns (uint256) {
78         uint256 c = a + b;
79         require(c >= a, "SafeMath: addition overflow");
80 
81         return c;
82     }
83 
84     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
85         return sub(a, b, "SafeMath: subtraction overflow");
86     }
87 
88     function sub(
89         uint256 a,
90         uint256 b,
91         string memory errorMessage
92     ) internal pure returns (uint256) {
93         require(b <= a, errorMessage);
94         uint256 c = a - b;
95 
96         return c;
97     }
98 
99     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
100         if (a == 0) {
101             return 0;
102         }
103 
104         uint256 c = a * b;
105         require(c / a == b, "SafeMath: multiplication overflow");
106 
107         return c;
108     }
109 
110     function div(uint256 a, uint256 b) internal pure returns (uint256) {
111         return div(a, b, "SafeMath: division by zero");
112     }
113 
114     function div(
115         uint256 a,
116         uint256 b,
117         string memory errorMessage
118     ) internal pure returns (uint256) {
119         require(b > 0, errorMessage);
120         uint256 c = a / b;
121         return c;
122     }
123 
124     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
125         return mod(a, b, "SafeMath: modulo by zero");
126     }
127 
128     function mod(
129         uint256 a,
130         uint256 b,
131         string memory errorMessage
132     ) internal pure returns (uint256) {
133         require(b != 0, errorMessage);
134         return a % b;
135     }
136 
137     function sqrrt(uint256 a) internal pure returns (uint256 c) {
138         if (a > 3) {
139             c = a;
140             uint256 b = add(div(a, 2), 1);
141             while (b < c) {
142                 c = b;
143                 b = div(add(div(a, b), b), 2);
144             }
145         } else if (a != 0) {
146             c = 1;
147         }
148     }
149 }
150 
151 library Address {
152     function isContract(address account) internal view returns (bool) {
153         uint256 size;
154         // solhint-disable-next-line no-inline-assembly
155         assembly {
156             size := extcodesize(account)
157         }
158         return size > 0;
159     }
160 
161     function sendValue(address payable recipient, uint256 amount) internal {
162         require(
163             address(this).balance >= amount,
164             "Address: insufficient balance"
165         );
166 
167         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
168         (bool success, ) = recipient.call{value: amount}("");
169         require(
170             success,
171             "Address: unable to send value, recipient may have reverted"
172         );
173     }
174 
175     function functionCall(address target, bytes memory data)
176         internal
177         returns (bytes memory)
178     {
179         return functionCall(target, data, "Address: low-level call failed");
180     }
181 
182     function functionCall(
183         address target,
184         bytes memory data,
185         string memory errorMessage
186     ) internal returns (bytes memory) {
187         return _functionCallWithValue(target, data, 0, errorMessage);
188     }
189 
190     function functionCallWithValue(
191         address target,
192         bytes memory data,
193         uint256 value
194     ) internal returns (bytes memory) {
195         return
196             functionCallWithValue(
197                 target,
198                 data,
199                 value,
200                 "Address: low-level call with value failed"
201             );
202     }
203 
204     function functionCallWithValue(
205         address target,
206         bytes memory data,
207         uint256 value,
208         string memory errorMessage
209     ) internal returns (bytes memory) {
210         require(
211             address(this).balance >= value,
212             "Address: insufficient balance for call"
213         );
214         require(isContract(target), "Address: call to non-contract");
215 
216         // solhint-disable-next-line avoid-low-level-calls
217         (bool success, bytes memory returndata) = target.call{value: value}(
218             data
219         );
220         return _verifyCallResult(success, returndata, errorMessage);
221     }
222 
223     function _functionCallWithValue(
224         address target,
225         bytes memory data,
226         uint256 weiValue,
227         string memory errorMessage
228     ) private returns (bytes memory) {
229         require(isContract(target), "Address: call to non-contract");
230 
231         // solhint-disable-next-line avoid-low-level-calls
232         (bool success, bytes memory returndata) = target.call{value: weiValue}(
233             data
234         );
235         if (success) {
236             return returndata;
237         } else {
238             // Look for revert reason and bubble it up if present
239             if (returndata.length > 0) {
240                 // The easiest way to bubble the revert reason is using memory via assembly
241 
242                 // solhint-disable-next-line no-inline-assembly
243                 assembly {
244                     let returndata_size := mload(returndata)
245                     revert(add(32, returndata), returndata_size)
246                 }
247             } else {
248                 revert(errorMessage);
249             }
250         }
251     }
252 
253     function functionStaticCall(address target, bytes memory data)
254         internal
255         view
256         returns (bytes memory)
257     {
258         return
259             functionStaticCall(
260                 target,
261                 data,
262                 "Address: low-level static call failed"
263             );
264     }
265 
266     function functionStaticCall(
267         address target,
268         bytes memory data,
269         string memory errorMessage
270     ) internal view returns (bytes memory) {
271         require(isContract(target), "Address: static call to non-contract");
272 
273         // solhint-disable-next-line avoid-low-level-calls
274         (bool success, bytes memory returndata) = target.staticcall(data);
275         return _verifyCallResult(success, returndata, errorMessage);
276     }
277 
278     function functionDelegateCall(address target, bytes memory data)
279         internal
280         returns (bytes memory)
281     {
282         return
283             functionDelegateCall(
284                 target,
285                 data,
286                 "Address: low-level delegate call failed"
287             );
288     }
289 
290     function functionDelegateCall(
291         address target,
292         bytes memory data,
293         string memory errorMessage
294     ) internal returns (bytes memory) {
295         require(isContract(target), "Address: delegate call to non-contract");
296 
297         // solhint-disable-next-line avoid-low-level-calls
298         (bool success, bytes memory returndata) = target.delegatecall(data);
299         return _verifyCallResult(success, returndata, errorMessage);
300     }
301 
302     function _verifyCallResult(
303         bool success,
304         bytes memory returndata,
305         string memory errorMessage
306     ) private pure returns (bytes memory) {
307         if (success) {
308             return returndata;
309         } else {
310             if (returndata.length > 0) {
311                 assembly {
312                     let returndata_size := mload(returndata)
313                     revert(add(32, returndata), returndata_size)
314                 }
315             } else {
316                 revert(errorMessage);
317             }
318         }
319     }
320 
321     function addressToString(address _address)
322         internal
323         pure
324         returns (string memory)
325     {
326         bytes32 _bytes = bytes32(uint256(_address));
327         bytes memory HEX = "0123456789abcdef";
328         bytes memory _addr = new bytes(42);
329 
330         _addr[0] = "0";
331         _addr[1] = "x";
332 
333         for (uint256 i = 0; i < 20; i++) {
334             _addr[2 + i * 2] = HEX[uint8(_bytes[i + 12] >> 4)];
335             _addr[3 + i * 2] = HEX[uint8(_bytes[i + 12] & 0x0f)];
336         }
337 
338         return string(_addr);
339     }
340 }
341 
342 interface IERC20 {
343     function decimals() external view returns (uint8);
344 
345     function totalSupply() external view returns (uint256);
346 
347     function balanceOf(address account) external view returns (uint256);
348 
349     function transfer(address recipient, uint256 amount)
350         external
351         returns (bool);
352 
353     function allowance(address owner, address spender)
354         external
355         view
356         returns (uint256);
357 
358     function approve(address spender, uint256 amount) external returns (bool);
359 
360     function transferFrom(
361         address sender,
362         address recipient,
363         uint256 amount
364     ) external returns (bool);
365 
366     event Transfer(address indexed from, address indexed to, uint256 value);
367 
368     event Approval(
369         address indexed owner,
370         address indexed spender,
371         uint256 value
372     );
373 }
374 
375 abstract contract ERC20 is IERC20 {
376     using SafeMath for uint256;
377 
378     // TODO comment actual hash value.
379     bytes32 private constant ERC20TOKEN_ERC1820_INTERFACE_ID =
380         keccak256("ERC20Token");
381 
382     mapping(address => uint256) internal _balances;
383 
384     mapping(address => mapping(address => uint256)) internal _allowances;
385 
386     uint256 internal _totalSupply;
387 
388     string internal _name;
389 
390     string internal _symbol;
391 
392     uint8 internal _decimals;
393 
394     constructor(
395         string memory name_,
396         string memory symbol_,
397         uint8 decimals_
398     ) {
399         _name = name_;
400         _symbol = symbol_;
401         _decimals = decimals_;
402     }
403 
404     function name() public view returns (string memory) {
405         return _name;
406     }
407 
408     function symbol() public view returns (string memory) {
409         return _symbol;
410     }
411 
412     function decimals() public view override returns (uint8) {
413         return _decimals;
414     }
415 
416     function totalSupply() public view override returns (uint256) {
417         return _totalSupply;
418     }
419 
420     function balanceOf(address account)
421         public
422         view
423         virtual
424         override
425         returns (uint256)
426     {
427         return _balances[account];
428     }
429 
430     function transfer(address recipient, uint256 amount)
431         public
432         virtual
433         override
434         returns (bool)
435     {
436         _transfer(msg.sender, recipient, amount);
437         return true;
438     }
439 
440     function allowance(address owner, address spender)
441         public
442         view
443         virtual
444         override
445         returns (uint256)
446     {
447         return _allowances[owner][spender];
448     }
449 
450     function approve(address spender, uint256 amount)
451         public
452         virtual
453         override
454         returns (bool)
455     {
456         _approve(msg.sender, spender, amount);
457         return true;
458     }
459 
460     function transferFrom(
461         address sender,
462         address recipient,
463         uint256 amount
464     ) public virtual override returns (bool) {
465         _transfer(sender, recipient, amount);
466         _approve(
467             sender,
468             msg.sender,
469             _allowances[sender][msg.sender].sub(
470                 amount,
471                 "ERC20: transfer amount exceeds allowance"
472             )
473         );
474         return true;
475     }
476 
477     function increaseAllowance(address spender, uint256 addedValue)
478         public
479         virtual
480         returns (bool)
481     {
482         _approve(
483             msg.sender,
484             spender,
485             _allowances[msg.sender][spender].add(addedValue)
486         );
487         return true;
488     }
489 
490     function decreaseAllowance(address spender, uint256 subtractedValue)
491         public
492         virtual
493         returns (bool)
494     {
495         _approve(
496             msg.sender,
497             spender,
498             _allowances[msg.sender][spender].sub(
499                 subtractedValue,
500                 "ERC20: decreased allowance below zero"
501             )
502         );
503         return true;
504     }
505 
506     function _transfer(
507         address sender,
508         address recipient,
509         uint256 amount
510     ) internal virtual {
511         require(sender != address(0), "ERC20: transfer from the zero address");
512         require(recipient != address(0), "ERC20: transfer to the zero address");
513 
514         _beforeTokenTransfer(sender, recipient, amount);
515 
516         _balances[sender] = _balances[sender].sub(
517             amount,
518             "ERC20: transfer amount exceeds balance"
519         );
520         _balances[recipient] = _balances[recipient].add(amount);
521         emit Transfer(sender, recipient, amount);
522     }
523 
524     function _mint(address account_, uint256 ammount_) internal virtual {
525         require(account_ != address(0), "ERC20: mint to the zero address");
526         _beforeTokenTransfer(address(this), account_, ammount_);
527         _totalSupply = _totalSupply.add(ammount_);
528         _balances[account_] = _balances[account_].add(ammount_);
529         emit Transfer(address(this), account_, ammount_);
530     }
531 
532     function _burn(address account, uint256 amount) internal virtual {
533         require(account != address(0), "ERC20: burn from the zero address");
534 
535         _beforeTokenTransfer(account, address(0), amount);
536 
537         _balances[account] = _balances[account].sub(
538             amount,
539             "ERC20: burn amount exceeds balance"
540         );
541         _totalSupply = _totalSupply.sub(amount);
542         emit Transfer(account, address(0), amount);
543     }
544 
545     function _approve(
546         address owner,
547         address spender,
548         uint256 amount
549     ) internal virtual {
550         require(owner != address(0), "ERC20: approve from the zero address");
551         require(spender != address(0), "ERC20: approve to the zero address");
552 
553         _allowances[owner][spender] = amount;
554         emit Approval(owner, spender, amount);
555     }
556 
557     function _beforeTokenTransfer(
558         address from_,
559         address to_,
560         uint256 amount_
561     ) internal virtual {}
562 }
563 
564 interface IERC2612Permit {
565     function permit(
566         address owner,
567         address spender,
568         uint256 amount,
569         uint256 deadline,
570         uint8 v,
571         bytes32 r,
572         bytes32 s
573     ) external;
574 
575     function nonces(address owner) external view returns (uint256);
576 }
577 
578 library Counters {
579     using SafeMath for uint256;
580 
581     struct Counter {
582         uint256 _value; // default: 0
583     }
584 
585     function current(Counter storage counter) internal view returns (uint256) {
586         return counter._value;
587     }
588 
589     function increment(Counter storage counter) internal {
590         counter._value += 1;
591     }
592 
593     function decrement(Counter storage counter) internal {
594         counter._value = counter._value.sub(1);
595     }
596 }
597 
598 abstract contract ERC20Permit is ERC20, IERC2612Permit {
599     using Counters for Counters.Counter;
600 
601     mapping(address => Counters.Counter) private _nonces;
602 
603     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
604     bytes32 public constant PERMIT_TYPEHASH =
605         0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
606 
607     bytes32 public DOMAIN_SEPARATOR;
608 
609     constructor() {
610         uint256 chainID;
611         assembly {
612             chainID := chainid()
613         }
614 
615         DOMAIN_SEPARATOR = keccak256(
616             abi.encode(
617                 keccak256(
618                     "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
619                 ),
620                 keccak256(bytes(name())),
621                 keccak256(bytes("1")), // Version
622                 chainID,
623                 address(this)
624             )
625         );
626     }
627 
628     function permit(
629         address owner,
630         address spender,
631         uint256 amount,
632         uint256 deadline,
633         uint8 v,
634         bytes32 r,
635         bytes32 s
636     ) public virtual override {
637         require(block.timestamp <= deadline, "Permit: expired deadline");
638 
639         bytes32 hashStruct = keccak256(
640             abi.encode(
641                 PERMIT_TYPEHASH,
642                 owner,
643                 spender,
644                 amount,
645                 _nonces[owner].current(),
646                 deadline
647             )
648         );
649 
650         bytes32 _hash = keccak256(
651             abi.encodePacked(uint16(0x1901), DOMAIN_SEPARATOR, hashStruct)
652         );
653 
654         address signer = ecrecover(_hash, v, r, s);
655         require(
656             signer != address(0) && signer == owner,
657             "ZeroSwapPermit: Invalid signature"
658         );
659 
660         _nonces[owner].increment();
661         _approve(owner, spender, amount);
662     }
663 
664     function nonces(address owner) public view override returns (uint256) {
665         return _nonces[owner].current();
666     }
667 }
668 
669 library SafeERC20 {
670     using SafeMath for uint256;
671     using Address for address;
672 
673     function safeTransfer(
674         IERC20 token,
675         address to,
676         uint256 value
677     ) internal {
678         _callOptionalReturn(
679             token,
680             abi.encodeWithSelector(token.transfer.selector, to, value)
681         );
682     }
683 
684     function safeTransferFrom(
685         IERC20 token,
686         address from,
687         address to,
688         uint256 value
689     ) internal {
690         _callOptionalReturn(
691             token,
692             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
693         );
694     }
695 
696     function safeApprove(
697         IERC20 token,
698         address spender,
699         uint256 value
700     ) internal {
701         require(
702             (value == 0) || (token.allowance(address(this), spender) == 0),
703             "SafeERC20: approve from non-zero to non-zero allowance"
704         );
705         _callOptionalReturn(
706             token,
707             abi.encodeWithSelector(token.approve.selector, spender, value)
708         );
709     }
710 
711     function safeIncreaseAllowance(
712         IERC20 token,
713         address spender,
714         uint256 value
715     ) internal {
716         uint256 newAllowance = token.allowance(address(this), spender).add(
717             value
718         );
719         _callOptionalReturn(
720             token,
721             abi.encodeWithSelector(
722                 token.approve.selector,
723                 spender,
724                 newAllowance
725             )
726         );
727     }
728 
729     function safeDecreaseAllowance(
730         IERC20 token,
731         address spender,
732         uint256 value
733     ) internal {
734         uint256 newAllowance = token.allowance(address(this), spender).sub(
735             value,
736             "SafeERC20: decreased allowance below zero"
737         );
738         _callOptionalReturn(
739             token,
740             abi.encodeWithSelector(
741                 token.approve.selector,
742                 spender,
743                 newAllowance
744             )
745         );
746     }
747 
748     function _callOptionalReturn(IERC20 token, bytes memory data) private {
749         bytes memory returndata = address(token).functionCall(
750             data,
751             "SafeERC20: low-level call failed"
752         );
753         if (returndata.length > 0) {
754             // Return data is optional
755             // solhint-disable-next-line max-line-length
756             require(
757                 abi.decode(returndata, (bool)),
758                 "SafeERC20: ERC20 operation did not succeed"
759             );
760         }
761     }
762 }
763 
764 library FullMath {
765     function fullMul(uint256 x, uint256 y)
766         private
767         pure
768         returns (uint256 l, uint256 h)
769     {
770         uint256 mm = mulmod(x, y, uint256(-1));
771         l = x * y;
772         h = mm - l;
773         if (mm < l) h -= 1;
774     }
775 
776     function fullDiv(
777         uint256 l,
778         uint256 h,
779         uint256 d
780     ) private pure returns (uint256) {
781         uint256 pow2 = d & -d;
782         d /= pow2;
783         l /= pow2;
784         l += h * ((-pow2) / pow2 + 1);
785         uint256 r = 1;
786         r *= 2 - d * r;
787         r *= 2 - d * r;
788         r *= 2 - d * r;
789         r *= 2 - d * r;
790         r *= 2 - d * r;
791         r *= 2 - d * r;
792         r *= 2 - d * r;
793         r *= 2 - d * r;
794         return l * r;
795     }
796 
797     function mulDiv(
798         uint256 x,
799         uint256 y,
800         uint256 d
801     ) internal pure returns (uint256) {
802         (uint256 l, uint256 h) = fullMul(x, y);
803         uint256 mm = mulmod(x, y, d);
804         if (mm > l) h -= 1;
805         l -= mm;
806         require(h < d, "FullMath::mulDiv: overflow");
807         return fullDiv(l, h, d);
808     }
809 }
810 
811 library FixedPoint {
812     struct uq112x112 {
813         uint224 _x;
814     }
815 
816     struct uq144x112 {
817         uint256 _x;
818     }
819 
820     uint8 private constant RESOLUTION = 112;
821     uint256 private constant Q112 = 0x10000000000000000000000000000;
822     uint256 private constant Q224 =
823         0x100000000000000000000000000000000000000000000000000000000;
824     uint256 private constant LOWER_MASK = 0xffffffffffffffffffffffffffff; // decimal of UQ*x112 (lower 112 bits)
825 
826     function decode(uq112x112 memory self) internal pure returns (uint112) {
827         return uint112(self._x >> RESOLUTION);
828     }
829 
830     function decode112with18(uq112x112 memory self)
831         internal
832         pure
833         returns (uint256)
834     {
835         return uint256(self._x) / 5192296858534827;
836     }
837 
838     function fraction(uint256 numerator, uint256 denominator)
839         internal
840         pure
841         returns (uq112x112 memory)
842     {
843         require(denominator > 0, "FixedPoint::fraction: division by zero");
844         if (numerator == 0) return FixedPoint.uq112x112(0);
845 
846         if (numerator <= uint144(-1)) {
847             uint256 result = (numerator << RESOLUTION) / denominator;
848             require(result <= uint224(-1), "FixedPoint::fraction: overflow");
849             return uq112x112(uint224(result));
850         } else {
851             uint256 result = FullMath.mulDiv(numerator, Q112, denominator);
852             require(result <= uint224(-1), "FixedPoint::fraction: overflow");
853             return uq112x112(uint224(result));
854         }
855     }
856 }
857 
858 interface ITreasury {
859     function deposit(
860         uint256 _amount,
861         address _token,
862         uint256 _profit
863     ) external returns (bool);
864 
865     function valueOf_(address _token, uint256 _amount)
866         external
867         view
868         returns (uint256 value_);
869 }
870 
871 interface IBondCalculator {
872     function valuation(address _LP, uint256 _amount)
873         external
874         view
875         returns (uint256);
876 
877     function markdown(address _LP) external view returns (uint256);
878 }
879 
880 interface IStaking {
881     function stake(uint256 _amount, address _recipient) external returns (bool);
882 }
883 
884 interface IStakingHelper {
885     function stake(uint256 _amount, address _recipient) external;
886 }
887 
888 contract AsgardBondDepository is Ownable {
889     using FixedPoint for *;
890     using SafeERC20 for IERC20;
891     using SafeMath for uint256;
892 
893     /* ======== EVENTS ======== */
894 
895     event BondCreated(
896         uint256 deposit,
897         uint256 indexed payout,
898         uint256 indexed expires,
899         uint256 indexed priceInUSD
900     );
901     event BondRedeemed(
902         address indexed recipient,
903         uint256 payout,
904         uint256 remaining
905     );
906     event BondPriceChanged(
907         uint256 indexed priceInUSD,
908         uint256 indexed internalPrice,
909         uint256 indexed debtRatio
910     );
911     event ControlVariableAdjustment(
912         uint256 initialBCV,
913         uint256 newBCV,
914         uint256 adjustment,
915         bool addition
916     );
917 
918     /* ======== STATE VARIABLES ======== */
919 
920     address public immutable ASG; // token given as payment for bond
921     address public immutable principle; // token used to create bond
922     address public immutable treasury; // mints ASG when receives principle
923     address public immutable DAO; // receives profit share from bond
924 
925     bool public immutable isLiquidityBond; // LP and Reserve bonds are treated slightly different
926     address public immutable bondCalculator; // calculates value of LP tokens
927 
928     address public staking; // to auto-stake payout
929     address public stakingHelper; // to stake and claim if no staking warmup
930     bool public useHelper;
931 
932     Terms public terms; // stores terms for new bonds
933     Adjust public adjustment; // stores adjustment to BCV data
934 
935     mapping(address => Bond) public bondInfo; // stores bond information for depositors
936 
937     uint256 public totalDebt; // total value of outstanding bonds; used for pricing
938     uint256 public lastDecay; // reference block for debt decay
939 
940     /* ======== STRUCTS ======== */
941 
942     // Info for creating new bonds
943     struct Terms {
944         uint256 controlVariable; // scaling variable for price
945         uint256 vestingTerm; // in blocks
946         uint256 minimumPrice; // vs principle value
947         uint256 maxPayout; // in thousandths of a %. i.e. 500 = 0.5%
948         uint256 fee; // as % of bond payout, in hundreths. ( 500 = 5% = 0.05 for every 1 paid)
949         uint256 maxDebt; // 9 decimal debt ratio, max % total supply created as debt
950     }
951 
952     // Info for bond holder
953     struct Bond {
954         uint256 payout; // ASG remaining to be paid
955         uint256 vesting; // Blocks left to vest
956         uint256 lastBlock; // Last interaction
957         uint256 pricePaid; // In DAI, for front end viewing
958     }
959 
960     // Info for incremental adjustments to control variable
961     struct Adjust {
962         bool add; // addition or subtraction
963         uint256 rate; // increment
964         uint256 target; // BCV when adjustment finished
965         uint256 buffer; // minimum length (in blocks) between adjustments
966         uint256 lastBlock; // block when last adjustment made
967     }
968 
969     /* ======== INITIALIZATION ======== */
970 
971     constructor(
972         address _ASG,
973         address _principle,
974         address _treasury,
975         address _DAO,
976         address _bondCalculator
977     ) {
978         require(_ASG != address(0));
979         ASG = _ASG;
980         require(_principle != address(0));
981         principle = _principle;
982         require(_treasury != address(0));
983         treasury = _treasury;
984         require(_DAO != address(0));
985         DAO = _DAO;
986         // bondCalculator should be address(0) if not LP bond
987         bondCalculator = _bondCalculator;
988         isLiquidityBond = (_bondCalculator != address(0));
989     }
990 
991     /**
992      *  @notice initializes bond parameters
993      *  @param _controlVariable uint
994      *  @param _vestingTerm uint
995      *  @param _minimumPrice uint
996      *  @param _maxPayout uint
997      *  @param _fee uint
998      *  @param _maxDebt uint
999      *  @param _initialDebt uint
1000      */
1001     function initializeBondTerms(
1002         uint256 _controlVariable,
1003         uint256 _vestingTerm,
1004         uint256 _minimumPrice,
1005         uint256 _maxPayout,
1006         uint256 _fee,
1007         uint256 _maxDebt,
1008         uint256 _initialDebt
1009     ) external onlyPolicy {
1010         require(terms.controlVariable == 0, "Bonds must be initialized from 0");
1011         terms = Terms({
1012             controlVariable: _controlVariable,
1013             vestingTerm: _vestingTerm,
1014             minimumPrice: _minimumPrice,
1015             maxPayout: _maxPayout,
1016             fee: _fee,
1017             maxDebt: _maxDebt
1018         });
1019         totalDebt = _initialDebt;
1020         lastDecay = block.number;
1021     }
1022 
1023     /* ======== POLICY FUNCTIONS ======== */
1024 
1025     enum PARAMETER {
1026         VESTING,
1027         PAYOUT,
1028         FEE,
1029         DEBT
1030     }
1031 
1032     /**
1033      *  @notice set parameters for new bonds
1034      *  @param _parameter PARAMETER
1035      *  @param _input uint
1036      */
1037     function setBondTerms(PARAMETER _parameter, uint256 _input)
1038         external
1039         onlyPolicy
1040     {
1041         if (_parameter == PARAMETER.VESTING) {
1042             // 0
1043             require(_input >= 10000, "Vesting must be longer than 36 hours");
1044             terms.vestingTerm = _input;
1045         } else if (_parameter == PARAMETER.PAYOUT) {
1046             // 1
1047             require(_input <= 100000, "Payout cannot be above 100 percent");
1048             terms.maxPayout = _input;
1049         } else if (_parameter == PARAMETER.FEE) {
1050             // 2
1051             require(_input <= 10000, "DAO fee cannot exceed payout");
1052             terms.fee = _input;
1053         } else if (_parameter == PARAMETER.DEBT) {
1054             // 3
1055             terms.maxDebt = _input;
1056         }
1057     }
1058 
1059     /**
1060      *  @notice set control variable adjustment
1061      *  @param _addition bool
1062      *  @param _increment uint
1063      *  @param _target uint
1064      *  @param _buffer uint
1065      */
1066     function setAdjustment(
1067         bool _addition,
1068         uint256 _increment,
1069         uint256 _target,
1070         uint256 _buffer
1071     ) external onlyPolicy {
1072         require(
1073             _increment <= terms.controlVariable.mul(25).div(1000),
1074             "Increment too large"
1075         );
1076 
1077         adjustment = Adjust({
1078             add: _addition,
1079             rate: _increment,
1080             target: _target,
1081             buffer: _buffer,
1082             lastBlock: block.number
1083         });
1084     }
1085 
1086     /**
1087      *  @notice set contract for auto stake
1088      *  @param _staking address
1089      *  @param _helper bool
1090      */
1091     function setStaking(address _staking, bool _helper) external onlyPolicy {
1092         require(_staking != address(0));
1093         if (_helper) {
1094             useHelper = true;
1095             stakingHelper = _staking;
1096         } else {
1097             useHelper = false;
1098             staking = _staking;
1099         }
1100     }
1101 
1102     /* ======== USER FUNCTIONS ======== */
1103 
1104     /**
1105      *  @notice deposit bond
1106      *  @param _amount uint
1107      *  @param _maxPrice uint
1108      *  @param _depositor address
1109      *  @return uint
1110      */
1111     function deposit(
1112         uint256 _amount,
1113         uint256 _maxPrice,
1114         address _depositor
1115     ) external returns (uint256) {
1116         require(_depositor != address(0), "Invalid address");
1117 
1118         decayDebt();
1119         require(totalDebt <= terms.maxDebt, "Max capacity reached");
1120 
1121         uint256 priceInUSD = bondPriceInUSD(); // Stored in bond info
1122         uint256 nativePrice = _bondPrice();
1123 
1124         require(
1125             _maxPrice >= nativePrice,
1126             "Slippage limit: more than max price"
1127         ); // slippage protection
1128 
1129         uint256 value = ITreasury(treasury).valueOf_(principle, _amount);
1130         uint256 payout = payoutFor(value); // payout to bonder is computed
1131 
1132         require(payout >= 10000000, "Bond too small"); // must be > 0.01 ASG ( underflow protection )
1133         require(payout <= maxPayout(), "Bond too large"); // size protection because there is no slippage
1134 
1135         // profits are calculated
1136         uint256 fee = payout.mul(terms.fee).div(10000);
1137         uint256 profit = value.sub(payout).sub(fee);
1138 
1139         /**
1140             principle is transferred in
1141             approved and
1142             deposited into the treasury, returning (_amount - profit) ASG
1143          */
1144         IERC20(principle).safeTransferFrom(msg.sender, address(this), _amount);
1145         IERC20(principle).approve(address(treasury), _amount);
1146         ITreasury(treasury).deposit(_amount, principle, profit);
1147 
1148         if (fee != 0) {
1149             // fee is transferred to dao
1150             IERC20(ASG).safeTransfer(DAO, fee);
1151         }
1152 
1153         // total debt is increased
1154         totalDebt = totalDebt.add(value);
1155 
1156         // depositor info is stored
1157         bondInfo[_depositor] = Bond({
1158             payout: bondInfo[_depositor].payout.add(payout),
1159             vesting: terms.vestingTerm,
1160             lastBlock: block.number,
1161             pricePaid: priceInUSD
1162         });
1163 
1164         // indexed events are emitted
1165         emit BondCreated(
1166             _amount,
1167             payout,
1168             block.number.add(terms.vestingTerm),
1169             priceInUSD
1170         );
1171         emit BondPriceChanged(bondPriceInUSD(), _bondPrice(), debtRatio());
1172 
1173         adjust(); // control variable is adjusted
1174         return payout;
1175     }
1176 
1177     /**
1178      *  @notice redeem bond for user
1179      *  @param _recipient address
1180      *  @param _stake bool
1181      *  @return uint
1182      */
1183     function redeem(address _recipient, bool _stake)
1184         external
1185         returns (uint256)
1186     {
1187         Bond memory info = bondInfo[_recipient];
1188         uint256 percentVested = percentVestedFor(_recipient); // (blocks since last interaction / vesting term remaining)
1189 
1190         if (percentVested >= 10000) {
1191             // if fully vested
1192             delete bondInfo[_recipient]; // delete user info
1193             emit BondRedeemed(_recipient, info.payout, 0); // emit bond data
1194             return stakeOrSend(_recipient, _stake, info.payout); // pay user everything due
1195         } else {
1196             // if unfinished
1197             // calculate payout vested
1198             uint256 payout = info.payout.mul(percentVested).div(10000);
1199 
1200             // store updated deposit info
1201             bondInfo[_recipient] = Bond({
1202                 payout: info.payout.sub(payout),
1203                 vesting: info.vesting.sub(block.number.sub(info.lastBlock)),
1204                 lastBlock: block.number,
1205                 pricePaid: info.pricePaid
1206             });
1207 
1208             emit BondRedeemed(_recipient, payout, bondInfo[_recipient].payout);
1209             return stakeOrSend(_recipient, _stake, payout);
1210         }
1211     }
1212 
1213     /* ======== INTERNAL HELPER FUNCTIONS ======== */
1214 
1215     /**
1216      *  @notice allow user to stake payout automatically
1217      *  @param _stake bool
1218      *  @param _amount uint
1219      *  @return uint
1220      */
1221     function stakeOrSend(
1222         address _recipient,
1223         bool _stake,
1224         uint256 _amount
1225     ) internal returns (uint256) {
1226        
1227         if (!_stake) {
1228             // if user does not want to stake
1229             IERC20(ASG).transfer(_recipient, _amount); // send payout
1230         } else {
1231             // if user wants to stake
1232             if (useHelper) {
1233                 // use if staking warmup is 0
1234                 IERC20(ASG).approve(stakingHelper, _amount);
1235                 IStakingHelper(stakingHelper).stake(_amount, _recipient);
1236             } else {
1237                 IERC20(ASG).approve(staking, _amount);
1238                 IStaking(staking).stake(_amount, _recipient);
1239             }
1240         }
1241         return _amount;
1242     }
1243 
1244     /**
1245      *  @notice makes incremental adjustment to control variable
1246      */
1247     function adjust() internal {
1248         uint256 blockCanAdjust = adjustment.lastBlock.add(adjustment.buffer);
1249         if (adjustment.rate != 0 && block.number >= blockCanAdjust) {
1250             uint256 initial = terms.controlVariable;
1251             if (adjustment.add) {
1252                 terms.controlVariable = terms.controlVariable.add(
1253                     adjustment.rate
1254                 );
1255                 if (terms.controlVariable >= adjustment.target) {
1256                     adjustment.rate = 0;
1257                 }
1258             } else {
1259                 terms.controlVariable = terms.controlVariable.sub(
1260                     adjustment.rate
1261                 );
1262                 if (terms.controlVariable <= adjustment.target) {
1263                     adjustment.rate = 0;
1264                 }
1265             }
1266             adjustment.lastBlock = block.number;
1267             emit ControlVariableAdjustment(
1268                 initial,
1269                 terms.controlVariable,
1270                 adjustment.rate,
1271                 adjustment.add
1272             );
1273         }
1274     }
1275 
1276     /**
1277      *  @notice reduce total debt
1278      */
1279     function decayDebt() internal {
1280         totalDebt = totalDebt.sub(debtDecay());
1281         lastDecay = block.number;
1282     }
1283 
1284     /* ======== VIEW FUNCTIONS ======== */
1285 
1286     /**
1287      *  @notice determine maximum bond size
1288      *  @return uint
1289      */
1290     function maxPayout() public view returns (uint256) {
1291         return IERC20(ASG).totalSupply().mul(terms.maxPayout).div(100000);
1292     }
1293 
1294     /**
1295      *  @notice calculate interest due for new bond
1296      *  @param _value uint
1297      *  @return uint
1298      */
1299     function payoutFor(uint256 _value) public view returns (uint256) {
1300         return
1301             FixedPoint.fraction(_value, bondPrice()).decode112with18().div(
1302                 1e16
1303             );
1304     }
1305 
1306     /**
1307      *  @notice calculate current bond premium
1308      *  @return price_ uint
1309      */
1310     function bondPrice() public view returns (uint256 price_) {
1311         price_ = terms.controlVariable.mul(debtRatio()).add(1000000000).div(
1312             1e7
1313         );
1314         if (price_ < terms.minimumPrice) {
1315             price_ = terms.minimumPrice;
1316         }
1317     }
1318 
1319     /**
1320      *  @notice calculate current bond price and remove floor if above
1321      *  @return price_ uint
1322      */
1323     function _bondPrice() internal returns (uint256 price_) {
1324         price_ = terms.controlVariable.mul(debtRatio()).add(1000000000).div(
1325             1e7
1326         );
1327         if (price_ < terms.minimumPrice) {
1328             price_ = terms.minimumPrice;
1329         } else if (terms.minimumPrice != 0) {
1330             terms.minimumPrice = 0;
1331         }
1332     }
1333 
1334     /**
1335      *  @notice converts bond price to DAI value
1336      *  @return price_ uint
1337      */
1338     function bondPriceInUSD() public view returns (uint256 price_) {
1339         if (isLiquidityBond) {
1340             price_ = bondPrice()
1341                 .mul(IBondCalculator(bondCalculator).markdown(principle))
1342                 .div(100);
1343         } else {
1344             price_ = bondPrice().mul(10**IERC20(principle).decimals()).div(100);
1345         }
1346     }
1347 
1348     /**
1349      *  @notice calculate current ratio of debt to ASG supply
1350      *  @return debtRatio_ uint
1351      */
1352     function debtRatio() public view returns (uint256 debtRatio_) {
1353         uint256 supply = IERC20(ASG).totalSupply();
1354         debtRatio_ = FixedPoint
1355             .fraction(currentDebt().mul(1e9), supply)
1356             .decode112with18()
1357             .div(1e18);
1358     }
1359 
1360     /**
1361      *  @notice debt ratio in same terms for reserve or liquidity bonds
1362      *  @return uint
1363      */
1364     function standardizedDebtRatio() external view returns (uint256) {
1365         if (isLiquidityBond) {
1366             return
1367                 debtRatio()
1368                     .mul(IBondCalculator(bondCalculator).markdown(principle))
1369                     .div(1e9);
1370         } else {
1371             return debtRatio();
1372         }
1373     }
1374 
1375     /**
1376      *  @notice calculate debt factoring in decay
1377      *  @return uint
1378      */
1379     function currentDebt() public view returns (uint256) {
1380         return totalDebt.sub(debtDecay());
1381     }
1382 
1383     /**
1384      *  @notice amount to decay total debt by
1385      *  @return decay_ uint
1386      */
1387     function debtDecay() public view returns (uint256 decay_) {
1388         uint256 blocksSinceLast = block.number.sub(lastDecay);
1389         decay_ = totalDebt.mul(blocksSinceLast).div(terms.vestingTerm);
1390         if (decay_ > totalDebt) {
1391             decay_ = totalDebt;
1392         }
1393     }
1394 
1395     /**
1396      *  @notice calculate how far into vesting a depositor is
1397      *  @param _depositor address
1398      *  @return percentVested_ uint
1399      */
1400     function percentVestedFor(address _depositor)
1401         public
1402         view
1403         returns (uint256 percentVested_)
1404     {
1405         Bond memory bond = bondInfo[_depositor];
1406         uint256 blocksSinceLast = block.number.sub(bond.lastBlock);
1407         uint256 vesting = bond.vesting;
1408 
1409         if (vesting > 0) {
1410             percentVested_ = blocksSinceLast.mul(10000).div(vesting);
1411         } else {
1412             percentVested_ = 0;
1413         }
1414     }
1415 
1416     /**
1417      *  @notice calculate amount of ASG available for claim by depositor
1418      *  @param _depositor address
1419      *  @return pendingPayout_ uint
1420      */
1421     function pendingPayoutFor(address _depositor)
1422         external
1423         view
1424         returns (uint256 pendingPayout_)
1425     {
1426         uint256 percentVested = percentVestedFor(_depositor);
1427         uint256 payout = bondInfo[_depositor].payout;
1428 
1429         if (percentVested >= 10000) {
1430             pendingPayout_ = payout;
1431         } else {
1432             pendingPayout_ = payout.mul(percentVested).div(10000);
1433         }
1434     }
1435 
1436     /* ======= AUXILLIARY ======= */
1437 
1438     /**
1439      *  @notice allow anyone to send lost tokens (excluding principle or ASG) to the DAO
1440      *  @return bool
1441      */
1442     function recoverLostToken(address _token) external returns (bool) {
1443         require(_token != ASG);
1444         require(_token != principle);
1445         IERC20(_token).safeTransfer(
1446             DAO,
1447             IERC20(_token).balanceOf(address(this))
1448         );
1449         return true;
1450     }
1451 }