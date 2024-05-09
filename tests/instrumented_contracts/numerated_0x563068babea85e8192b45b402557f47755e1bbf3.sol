1 // SPDX-License-Identifier: AGPL-3.0-or-later
2 pragma solidity 0.7.5;
3 
4 interface IOwnable {
5   function policy() external view returns (address);
6 
7   function renounceManagement() external;
8 
9   function pushManagement(address newOwner_) external;
10 
11   function pullManagement() external;
12 }
13 
14 contract Ownable is IOwnable {
15   address internal _owner;
16   address internal _newOwner;
17 
18   event OwnershipPushed(
19     address indexed previousOwner,
20     address indexed newOwner
21   );
22   event OwnershipPulled(
23     address indexed previousOwner,
24     address indexed newOwner
25   );
26 
27   constructor() {
28     _owner = msg.sender;
29     emit OwnershipPushed(address(0), _owner);
30   }
31 
32   function policy() public view override returns (address) {
33     return _owner;
34   }
35 
36   modifier onlyPolicy() {
37     require(_owner == msg.sender, "Ownable: caller is not the owner");
38     _;
39   }
40 
41   function renounceManagement() public virtual override onlyPolicy {
42     emit OwnershipPushed(_owner, address(0));
43     _owner = address(0);
44   }
45 
46   function pushManagement(address newOwner_)
47     public
48     virtual
49     override
50     onlyPolicy
51   {
52     require(newOwner_ != address(0), "Ownable: new owner is the zero address");
53     emit OwnershipPushed(_owner, newOwner_);
54     _newOwner = newOwner_;
55   }
56 
57   function pullManagement() public virtual override {
58     require(msg.sender == _newOwner, "Ownable: must be new owner to pull");
59     emit OwnershipPulled(_owner, _newOwner);
60     _owner = _newOwner;
61   }
62 }
63 
64 library SafeMath {
65   function add(uint256 a, uint256 b) internal pure returns (uint256) {
66     uint256 c = a + b;
67     require(c >= a, "SafeMath: addition overflow");
68 
69     return c;
70   }
71 
72   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
73     return sub(a, b, "SafeMath: subtraction overflow");
74   }
75 
76   function sub(
77     uint256 a,
78     uint256 b,
79     string memory errorMessage
80   ) internal pure returns (uint256) {
81     require(b <= a, errorMessage);
82     uint256 c = a - b;
83 
84     return c;
85   }
86 
87   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
88     if (a == 0) {
89       return 0;
90     }
91 
92     uint256 c = a * b;
93     require(c / a == b, "SafeMath: multiplication overflow");
94 
95     return c;
96   }
97 
98   function div(uint256 a, uint256 b) internal pure returns (uint256) {
99     return div(a, b, "SafeMath: division by zero");
100   }
101 
102   function div(
103     uint256 a,
104     uint256 b,
105     string memory errorMessage
106   ) internal pure returns (uint256) {
107     require(b > 0, errorMessage);
108     uint256 c = a / b;
109     return c;
110   }
111 
112   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
113     return mod(a, b, "SafeMath: modulo by zero");
114   }
115 
116   function mod(
117     uint256 a,
118     uint256 b,
119     string memory errorMessage
120   ) internal pure returns (uint256) {
121     require(b != 0, errorMessage);
122     return a % b;
123   }
124 
125   function sqrrt(uint256 a) internal pure returns (uint256 c) {
126     if (a > 3) {
127       c = a;
128       uint256 b = add(div(a, 2), 1);
129       while (b < c) {
130         c = b;
131         b = div(add(div(a, b), b), 2);
132       }
133     } else if (a != 0) {
134       c = 1;
135     }
136   }
137 }
138 
139 library Address {
140   function isContract(address account) internal view returns (bool) {
141     uint256 size;
142     // solhint-disable-next-line no-inline-assembly
143     assembly {
144       size := extcodesize(account)
145     }
146     return size > 0;
147   }
148 
149   function sendValue(address payable recipient, uint256 amount) internal {
150     require(address(this).balance >= amount, "Address: insufficient balance");
151 
152     // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
153     (bool success, ) = recipient.call{value: amount}("");
154     require(
155       success,
156       "Address: unable to send value, recipient may have reverted"
157     );
158   }
159 
160   function functionCall(address target, bytes memory data)
161     internal
162     returns (bytes memory)
163   {
164     return functionCall(target, data, "Address: low-level call failed");
165   }
166 
167   function functionCall(
168     address target,
169     bytes memory data,
170     string memory errorMessage
171   ) internal returns (bytes memory) {
172     return _functionCallWithValue(target, data, 0, errorMessage);
173   }
174 
175   function functionCallWithValue(
176     address target,
177     bytes memory data,
178     uint256 value
179   ) internal returns (bytes memory) {
180     return
181       functionCallWithValue(
182         target,
183         data,
184         value,
185         "Address: low-level call with value failed"
186       );
187   }
188 
189   function functionCallWithValue(
190     address target,
191     bytes memory data,
192     uint256 value,
193     string memory errorMessage
194   ) internal returns (bytes memory) {
195     require(
196       address(this).balance >= value,
197       "Address: insufficient balance for call"
198     );
199     require(isContract(target), "Address: call to non-contract");
200 
201     // solhint-disable-next-line avoid-low-level-calls
202     (bool success, bytes memory returndata) = target.call{value: value}(data);
203     return _verifyCallResult(success, returndata, errorMessage);
204   }
205 
206   function _functionCallWithValue(
207     address target,
208     bytes memory data,
209     uint256 weiValue,
210     string memory errorMessage
211   ) private returns (bytes memory) {
212     require(isContract(target), "Address: call to non-contract");
213 
214     // solhint-disable-next-line avoid-low-level-calls
215     (bool success, bytes memory returndata) = target.call{value: weiValue}(
216       data
217     );
218     if (success) {
219       return returndata;
220     } else {
221       // Look for revert reason and bubble it up if present
222       if (returndata.length > 0) {
223         // The easiest way to bubble the revert reason is using memory via assembly
224 
225         // solhint-disable-next-line no-inline-assembly
226         assembly {
227           let returndata_size := mload(returndata)
228           revert(add(32, returndata), returndata_size)
229         }
230       } else {
231         revert(errorMessage);
232       }
233     }
234   }
235 
236   function functionStaticCall(address target, bytes memory data)
237     internal
238     view
239     returns (bytes memory)
240   {
241     return
242       functionStaticCall(target, data, "Address: low-level static call failed");
243   }
244 
245   function functionStaticCall(
246     address target,
247     bytes memory data,
248     string memory errorMessage
249   ) internal view returns (bytes memory) {
250     require(isContract(target), "Address: static call to non-contract");
251 
252     // solhint-disable-next-line avoid-low-level-calls
253     (bool success, bytes memory returndata) = target.staticcall(data);
254     return _verifyCallResult(success, returndata, errorMessage);
255   }
256 
257   function functionDelegateCall(address target, bytes memory data)
258     internal
259     returns (bytes memory)
260   {
261     return
262       functionDelegateCall(
263         target,
264         data,
265         "Address: low-level delegate call failed"
266       );
267   }
268 
269   function functionDelegateCall(
270     address target,
271     bytes memory data,
272     string memory errorMessage
273   ) internal returns (bytes memory) {
274     require(isContract(target), "Address: delegate call to non-contract");
275 
276     // solhint-disable-next-line avoid-low-level-calls
277     (bool success, bytes memory returndata) = target.delegatecall(data);
278     return _verifyCallResult(success, returndata, errorMessage);
279   }
280 
281   function _verifyCallResult(
282     bool success,
283     bytes memory returndata,
284     string memory errorMessage
285   ) private pure returns (bytes memory) {
286     if (success) {
287       return returndata;
288     } else {
289       if (returndata.length > 0) {
290         assembly {
291           let returndata_size := mload(returndata)
292           revert(add(32, returndata), returndata_size)
293         }
294       } else {
295         revert(errorMessage);
296       }
297     }
298   }
299 
300   function addressToString(address _address)
301     internal
302     pure
303     returns (string memory)
304   {
305     bytes32 _bytes = bytes32(uint256(_address));
306     bytes memory HEX = "0123456789abcdef";
307     bytes memory _addr = new bytes(42);
308 
309     _addr[0] = "0";
310     _addr[1] = "x";
311 
312     for (uint256 i = 0; i < 20; i++) {
313       _addr[2 + i * 2] = HEX[uint8(_bytes[i + 12] >> 4)];
314       _addr[3 + i * 2] = HEX[uint8(_bytes[i + 12] & 0x0f)];
315     }
316 
317     return string(_addr);
318   }
319 }
320 
321 interface IERC20 {
322   function decimals() external view returns (uint8);
323 
324   function totalSupply() external view returns (uint256);
325 
326   function balanceOf(address account) external view returns (uint256);
327 
328   function transfer(address recipient, uint256 amount) external returns (bool);
329 
330   function allowance(address owner, address spender)
331     external
332     view
333     returns (uint256);
334 
335   function approve(address spender, uint256 amount) external returns (bool);
336 
337   function transferFrom(
338     address sender,
339     address recipient,
340     uint256 amount
341   ) external returns (bool);
342 
343   event Transfer(address indexed from, address indexed to, uint256 value);
344 
345   event Approval(address indexed owner, address indexed spender, uint256 value);
346 }
347 
348 abstract contract ERC20 is IERC20 {
349   using SafeMath for uint256;
350 
351   // TODO comment actual hash value.
352   bytes32 private constant ERC20TOKEN_ERC1820_INTERFACE_ID =
353     keccak256("ERC20Token");
354 
355   mapping(address => uint256) internal _balances;
356 
357   mapping(address => mapping(address => uint256)) internal _allowances;
358 
359   uint256 internal _totalSupply;
360 
361   string internal _name;
362 
363   string internal _symbol;
364 
365   uint8 internal _decimals;
366 
367   constructor(
368     string memory name_,
369     string memory symbol_,
370     uint8 decimals_
371   ) {
372     _name = name_;
373     _symbol = symbol_;
374     _decimals = decimals_;
375   }
376 
377   function name() public view returns (string memory) {
378     return _name;
379   }
380 
381   function symbol() public view returns (string memory) {
382     return _symbol;
383   }
384 
385   function decimals() public view override returns (uint8) {
386     return _decimals;
387   }
388 
389   function totalSupply() public view override returns (uint256) {
390     return _totalSupply;
391   }
392 
393   function balanceOf(address account)
394     public
395     view
396     virtual
397     override
398     returns (uint256)
399   {
400     return _balances[account];
401   }
402 
403   function transfer(address recipient, uint256 amount)
404     public
405     virtual
406     override
407     returns (bool)
408   {
409     _transfer(msg.sender, recipient, amount);
410     return true;
411   }
412 
413   function allowance(address owner, address spender)
414     public
415     view
416     virtual
417     override
418     returns (uint256)
419   {
420     return _allowances[owner][spender];
421   }
422 
423   function approve(address spender, uint256 amount)
424     public
425     virtual
426     override
427     returns (bool)
428   {
429     _approve(msg.sender, spender, amount);
430     return true;
431   }
432 
433   function transferFrom(
434     address sender,
435     address recipient,
436     uint256 amount
437   ) public virtual override returns (bool) {
438     _transfer(sender, recipient, amount);
439     _approve(
440       sender,
441       msg.sender,
442       _allowances[sender][msg.sender].sub(
443         amount,
444         "ERC20: transfer amount exceeds allowance"
445       )
446     );
447     return true;
448   }
449 
450   function increaseAllowance(address spender, uint256 addedValue)
451     public
452     virtual
453     returns (bool)
454   {
455     _approve(
456       msg.sender,
457       spender,
458       _allowances[msg.sender][spender].add(addedValue)
459     );
460     return true;
461   }
462 
463   function decreaseAllowance(address spender, uint256 subtractedValue)
464     public
465     virtual
466     returns (bool)
467   {
468     _approve(
469       msg.sender,
470       spender,
471       _allowances[msg.sender][spender].sub(
472         subtractedValue,
473         "ERC20: decreased allowance below zero"
474       )
475     );
476     return true;
477   }
478 
479   function _transfer(
480     address sender,
481     address recipient,
482     uint256 amount
483   ) internal virtual {
484     require(sender != address(0), "ERC20: transfer from the zero address");
485     require(recipient != address(0), "ERC20: transfer to the zero address");
486 
487     _beforeTokenTransfer(sender, recipient, amount);
488 
489     _balances[sender] = _balances[sender].sub(
490       amount,
491       "ERC20: transfer amount exceeds balance"
492     );
493     _balances[recipient] = _balances[recipient].add(amount);
494     emit Transfer(sender, recipient, amount);
495   }
496 
497   function _mint(address account_, uint256 ammount_) internal virtual {
498     require(account_ != address(0), "ERC20: mint to the zero address");
499     _beforeTokenTransfer(address(this), account_, ammount_);
500     _totalSupply = _totalSupply.add(ammount_);
501     _balances[account_] = _balances[account_].add(ammount_);
502     emit Transfer(address(this), account_, ammount_);
503   }
504 
505   function _burn(address account, uint256 amount) internal virtual {
506     require(account != address(0), "ERC20: burn from the zero address");
507 
508     _beforeTokenTransfer(account, address(0), amount);
509 
510     _balances[account] = _balances[account].sub(
511       amount,
512       "ERC20: burn amount exceeds balance"
513     );
514     _totalSupply = _totalSupply.sub(amount);
515     emit Transfer(account, address(0), amount);
516   }
517 
518   function _approve(
519     address owner,
520     address spender,
521     uint256 amount
522   ) internal virtual {
523     require(owner != address(0), "ERC20: approve from the zero address");
524     require(spender != address(0), "ERC20: approve to the zero address");
525 
526     _allowances[owner][spender] = amount;
527     emit Approval(owner, spender, amount);
528   }
529 
530   function _beforeTokenTransfer(
531     address from_,
532     address to_,
533     uint256 amount_
534   ) internal virtual {}
535 }
536 
537 interface IERC2612Permit {
538   function permit(
539     address owner,
540     address spender,
541     uint256 amount,
542     uint256 deadline,
543     uint8 v,
544     bytes32 r,
545     bytes32 s
546   ) external;
547 
548   function nonces(address owner) external view returns (uint256);
549 }
550 
551 library Counters {
552   using SafeMath for uint256;
553 
554   struct Counter {
555     uint256 _value; // default: 0
556   }
557 
558   function current(Counter storage counter) internal view returns (uint256) {
559     return counter._value;
560   }
561 
562   function increment(Counter storage counter) internal {
563     counter._value += 1;
564   }
565 
566   function decrement(Counter storage counter) internal {
567     counter._value = counter._value.sub(1);
568   }
569 }
570 
571 abstract contract ERC20Permit is ERC20, IERC2612Permit {
572   using Counters for Counters.Counter;
573 
574   mapping(address => Counters.Counter) private _nonces;
575 
576   // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
577   bytes32 public constant PERMIT_TYPEHASH =
578     0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
579 
580   bytes32 public DOMAIN_SEPARATOR;
581 
582   constructor() {
583     uint256 chainID;
584     assembly {
585       chainID := chainid()
586     }
587 
588     DOMAIN_SEPARATOR = keccak256(
589       abi.encode(
590         keccak256(
591           "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
592         ),
593         keccak256(bytes(name())),
594         keccak256(bytes("1")), // Version
595         chainID,
596         address(this)
597       )
598     );
599   }
600 
601   function permit(
602     address owner,
603     address spender,
604     uint256 amount,
605     uint256 deadline,
606     uint8 v,
607     bytes32 r,
608     bytes32 s
609   ) public virtual override {
610     require(block.timestamp <= deadline, "Permit: expired deadline");
611 
612     bytes32 hashStruct = keccak256(
613       abi.encode(
614         PERMIT_TYPEHASH,
615         owner,
616         spender,
617         amount,
618         _nonces[owner].current(),
619         deadline
620       )
621     );
622 
623     bytes32 _hash = keccak256(
624       abi.encodePacked(uint16(0x1901), DOMAIN_SEPARATOR, hashStruct)
625     );
626 
627     address signer = ecrecover(_hash, v, r, s);
628     require(
629       signer != address(0) && signer == owner,
630       "ZeroSwapPermit: Invalid signature"
631     );
632 
633     _nonces[owner].increment();
634     _approve(owner, spender, amount);
635   }
636 
637   function nonces(address owner) public view override returns (uint256) {
638     return _nonces[owner].current();
639   }
640 }
641 
642 library SafeERC20 {
643   using SafeMath for uint256;
644   using Address for address;
645 
646   function safeTransfer(
647     IERC20 token,
648     address to,
649     uint256 value
650   ) internal {
651     _callOptionalReturn(
652       token,
653       abi.encodeWithSelector(token.transfer.selector, to, value)
654     );
655   }
656 
657   function safeTransferFrom(
658     IERC20 token,
659     address from,
660     address to,
661     uint256 value
662   ) internal {
663     _callOptionalReturn(
664       token,
665       abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
666     );
667   }
668 
669   function safeApprove(
670     IERC20 token,
671     address spender,
672     uint256 value
673   ) internal {
674     require(
675       (value == 0) || (token.allowance(address(this), spender) == 0),
676       "SafeERC20: approve from non-zero to non-zero allowance"
677     );
678     _callOptionalReturn(
679       token,
680       abi.encodeWithSelector(token.approve.selector, spender, value)
681     );
682   }
683 
684   function safeIncreaseAllowance(
685     IERC20 token,
686     address spender,
687     uint256 value
688   ) internal {
689     uint256 newAllowance = token.allowance(address(this), spender).add(value);
690     _callOptionalReturn(
691       token,
692       abi.encodeWithSelector(token.approve.selector, spender, newAllowance)
693     );
694   }
695 
696   function safeDecreaseAllowance(
697     IERC20 token,
698     address spender,
699     uint256 value
700   ) internal {
701     uint256 newAllowance = token.allowance(address(this), spender).sub(
702       value,
703       "SafeERC20: decreased allowance below zero"
704     );
705     _callOptionalReturn(
706       token,
707       abi.encodeWithSelector(token.approve.selector, spender, newAllowance)
708     );
709   }
710 
711   function _callOptionalReturn(IERC20 token, bytes memory data) private {
712     bytes memory returndata = address(token).functionCall(
713       data,
714       "SafeERC20: low-level call failed"
715     );
716     if (returndata.length > 0) {
717       // Return data is optional
718       // solhint-disable-next-line max-line-length
719       require(
720         abi.decode(returndata, (bool)),
721         "SafeERC20: ERC20 operation did not succeed"
722       );
723     }
724   }
725 }
726 
727 library FullMath {
728   function fullMul(uint256 x, uint256 y)
729     private
730     pure
731     returns (uint256 l, uint256 h)
732   {
733     uint256 mm = mulmod(x, y, uint256(-1));
734     l = x * y;
735     h = mm - l;
736     if (mm < l) h -= 1;
737   }
738 
739   function fullDiv(
740     uint256 l,
741     uint256 h,
742     uint256 d
743   ) private pure returns (uint256) {
744     uint256 pow2 = d & -d;
745     d /= pow2;
746     l /= pow2;
747     l += h * ((-pow2) / pow2 + 1);
748     uint256 r = 1;
749     r *= 2 - d * r;
750     r *= 2 - d * r;
751     r *= 2 - d * r;
752     r *= 2 - d * r;
753     r *= 2 - d * r;
754     r *= 2 - d * r;
755     r *= 2 - d * r;
756     r *= 2 - d * r;
757     return l * r;
758   }
759 
760   function mulDiv(
761     uint256 x,
762     uint256 y,
763     uint256 d
764   ) internal pure returns (uint256) {
765     (uint256 l, uint256 h) = fullMul(x, y);
766     uint256 mm = mulmod(x, y, d);
767     if (mm > l) h -= 1;
768     l -= mm;
769     require(h < d, "FullMath::mulDiv: overflow");
770     return fullDiv(l, h, d);
771   }
772 }
773 
774 library FixedPoint {
775   struct uq112x112 {
776     uint224 _x;
777   }
778 
779   struct uq144x112 {
780     uint256 _x;
781   }
782 
783   uint8 private constant RESOLUTION = 112;
784   uint256 private constant Q112 = 0x10000000000000000000000000000;
785   uint256 private constant Q224 =
786     0x100000000000000000000000000000000000000000000000000000000;
787   uint256 private constant LOWER_MASK = 0xffffffffffffffffffffffffffff; // decimal of UQ*x112 (lower 112 bits)
788 
789   function decode(uq112x112 memory self) internal pure returns (uint112) {
790     return uint112(self._x >> RESOLUTION);
791   }
792 
793   function decode112with18(uq112x112 memory self)
794     internal
795     pure
796     returns (uint256)
797   {
798     return uint256(self._x) / 5192296858534827;
799   }
800 
801   function fraction(uint256 numerator, uint256 denominator)
802     internal
803     pure
804     returns (uq112x112 memory)
805   {
806     require(denominator > 0, "FixedPoint::fraction: division by zero");
807     if (numerator == 0) return FixedPoint.uq112x112(0);
808 
809     if (numerator <= uint144(-1)) {
810       uint256 result = (numerator << RESOLUTION) / denominator;
811       require(result <= uint224(-1), "FixedPoint::fraction: overflow");
812       return uq112x112(uint224(result));
813     } else {
814       uint256 result = FullMath.mulDiv(numerator, Q112, denominator);
815       require(result <= uint224(-1), "FixedPoint::fraction: overflow");
816       return uq112x112(uint224(result));
817     }
818   }
819 }
820 
821 interface ITreasury {
822   function deposit(
823     uint256 _amount,
824     address _token,
825     uint256 _profit
826   ) external returns (bool);
827 
828   function updateReserve(address _token, uint256 _amount) external;
829 
830   function valueOfToken(address _token, uint256 _amount)
831     external
832     view
833     returns (uint256 value_);
834 
835   function mintRewards(address _recipient, uint256 _amount) external;
836 }
837 
838 interface IStaking {
839   function stake(uint256 _amount, address _recipient) external returns (bool);
840 }
841 
842 interface IStakingHelper {
843   function stake(uint256 _amount, address _recipient) external;
844 }
845 
846 contract LpBondDepository is Ownable {
847   using FixedPoint for *;
848   using SafeERC20 for IERC20;
849   using SafeMath for uint256;
850 
851   /* ======== EVENTS ======== */
852 
853   event BondCreated(
854     uint256 deposit,
855     uint256 indexed payout,
856     uint256 indexed expires,
857     uint256 indexed priceInUSD
858   );
859   event BondRedeemed(
860     address indexed recipient,
861     uint256 payout,
862     uint256 remaining
863   );
864   event BondPriceChanged(
865     uint256 indexed priceInUSD,
866     uint256 indexed internalPrice,
867     uint256 indexed debtRatio
868   );
869   event ControlVariableAdjustment(
870     uint256 initialBCV,
871     uint256 newBCV,
872     uint256 adjustment,
873     bool addition
874   );
875 
876   /* ======== STATE VARIABLES ======== */
877 
878   address public immutable LOBI; // token given as payment for bond
879   address public immutable principle; // token used to create bond
880   address public immutable treasury; // mints LOBI when receives principle
881   address public DAO; // receives profit share from bond
882   address public partnerDAO; // receives profit share from bond
883 
884   address public staking; // to auto-stake payout
885   address public stakingHelper; // to stake and claim if no staking warmup
886   bool public useHelper;
887 
888   Terms public terms; // stores terms for new bonds
889   Adjust public adjustment; // stores adjustment to BCV data
890 
891   mapping(address => Bond) public bondInfo; // stores bond information for depositors
892 
893   uint256 public totalDebt; // total value of outstanding bonds; used for pricing
894   uint256 public lastDecay; // reference block for debt decay
895 
896   /* ======== STRUCTS ======== */
897 
898   // Info for creating new bonds
899   struct Terms {
900     uint256 controlVariable; // scaling variable for price
901     uint256 vestingTerm; // in blocks
902     uint256 minimumPrice; // vs principle value. 4 decimals (1500 = 0.15)
903     uint256 maxPayout; // in thousandths of a %. i.e. 500 = 0.5%
904     uint256 maxDebt; // 9 decimal debt ratio, max % total supply created as debt
905     uint256 fee; // as % of bond payout, in hundreths. ( 500 = 5% = 0.05 for every 1 paid)
906     uint256 feePartner; // as % of bond payout, in hundreths. ( 500 = 5% = 0.05 for every 1 paid)
907   }
908 
909   // Info for bond holder
910   struct Bond {
911     uint256 payout; // LOBI remaining to be paid
912     uint256 vesting; // Blocks left to vest
913     uint256 lastBlock; // Last interaction
914     uint256 pricePaid; // In DAI, for front end viewing
915   }
916 
917   // Info for incremental adjustments to control variable
918   struct Adjust {
919     bool add; // addition or subtraction
920     uint256 rate; // increment
921     uint256 target; // BCV when adjustment finished
922     uint256 buffer; // minimum length (in blocks) between adjustments
923     uint256 lastBlock; // block when last adjustment made
924   }
925 
926   /* ======== INITIALIZATION ======== */
927 
928   constructor(
929     address _LOBI,
930     address _principle,
931     address _treasury,
932     address _DAO,
933     address _partnerDAO
934   ) {
935     require(_LOBI != address(0));
936     LOBI = _LOBI;
937     require(_principle != address(0));
938     principle = _principle;
939     require(_treasury != address(0));
940     treasury = _treasury;
941     require(_DAO != address(0));
942     DAO = _DAO;
943     require(_partnerDAO != address(0));
944     partnerDAO = _partnerDAO;
945   }
946 
947   /**
948    *  @notice initializes bond parameters
949    *  @param _controlVariable uint
950    *  @param _vestingTerm uint
951    *  @param _minimumPrice uint
952    *  @param _maxPayout uint
953    *  @param _maxDebt uint
954    *  @param _initialDebt uint
955    */
956   function initializeBondTerms(
957     uint256 _controlVariable,
958     uint256 _vestingTerm,
959     uint256 _minimumPrice,
960     uint256 _maxPayout,
961     uint256 _maxDebt,
962     uint256 _initialDebt,
963     uint256 _fee,
964     uint256 _feePartner
965   ) external onlyPolicy {
966     terms = Terms({
967       controlVariable: _controlVariable,
968       vestingTerm: _vestingTerm,
969       minimumPrice: _minimumPrice,
970       maxPayout: _maxPayout,
971       maxDebt: _maxDebt,
972       fee: _fee,
973       feePartner: _feePartner
974     });
975     totalDebt = _initialDebt;
976     lastDecay = block.number;
977   }
978 
979   /* ======== POLICY FUNCTIONS ======== */
980 
981   enum PARAMETER {
982     VESTING,
983     PAYOUT,
984     DEBT,
985     FEE,
986     FEEPARTNER
987   }
988 
989   /**
990    *  @notice set parameters for new bonds
991    *  @param _parameter PARAMETER
992    *  @param _input uint
993    */
994   function setBondTerms(PARAMETER _parameter, uint256 _input)
995     external
996     onlyPolicy
997   {
998     if (_parameter == PARAMETER.VESTING) {
999       // 0
1000       require(_input >= 10000, "Vesting must be longer than 36 hours");
1001       terms.vestingTerm = _input;
1002     } else if (_parameter == PARAMETER.PAYOUT) {
1003       // 1
1004       require(_input <= 1000, "Payout cannot be above 1 percent");
1005       terms.maxPayout = _input;
1006     } else if (_parameter == PARAMETER.DEBT) {
1007       // 2
1008       terms.maxDebt = _input;
1009     } else if (_parameter == PARAMETER.FEE) {
1010       // 3
1011       terms.fee = _input;
1012     } else if (_parameter == PARAMETER.FEEPARTNER) {
1013       // 3
1014       terms.feePartner = _input;
1015     }
1016   }
1017 
1018   /**
1019    *  @notice set control variable adjustment
1020    *  @param _addition bool
1021    *  @param _increment uint
1022    *  @param _target uint
1023    *  @param _buffer uint
1024    */
1025   function setAdjustment(
1026     bool _addition,
1027     uint256 _increment,
1028     uint256 _target,
1029     uint256 _buffer
1030   ) external onlyPolicy {
1031     require(
1032       _increment <= terms.controlVariable.mul(25).div(1000),
1033       "Increment too large"
1034     );
1035 
1036     adjustment = Adjust({
1037       add: _addition,
1038       rate: _increment,
1039       target: _target,
1040       buffer: _buffer,
1041       lastBlock: block.number
1042     });
1043   }
1044 
1045   /**
1046    *  @notice set contract for auto stake
1047    *  @param _staking address
1048    *  @param _helper bool
1049    */
1050   function setStaking(address _staking, bool _helper) external onlyPolicy {
1051     require(_staking != address(0));
1052     if (_helper) {
1053       useHelper = true;
1054       stakingHelper = _staking;
1055     } else {
1056       useHelper = false;
1057       staking = _staking;
1058     }
1059   }
1060 
1061   /* ======== USER FUNCTIONS ======== */
1062 
1063   /**
1064    *  @notice deposit bond
1065    *  @param _amount uint
1066    *  @param _maxPrice uint
1067    *  @param _depositor address
1068    *  @return uint
1069    */
1070   function deposit(
1071     uint256 _amount,
1072     uint256 _maxPrice,
1073     address _depositor
1074   ) external returns (uint256) {
1075     require(_depositor != address(0), "Invalid address");
1076 
1077     decayDebt();
1078     require(totalDebt <= terms.maxDebt, "Max capacity reached");
1079 
1080     uint256 priceInUSD = _bondPrice();
1081     uint256 nativePrice = _bondPrice();
1082 
1083     require(_maxPrice >= nativePrice, "Slippage limit: more than max price"); // slippage protection
1084 
1085     uint256 value = ITreasury(treasury).valueOfToken(principle, _amount);
1086     uint256 payout = payoutFor(value); // payout to bonder is computed
1087 
1088     require(payout >= 10000000, "Bond too small"); // must be > 0.01 LOBI ( underflow protection )
1089     require(payout <= maxPayout(), "Bond too large"); // size protection because there is no slippage
1090 
1091     // profits are calculated
1092     uint256 fee = payout.mul(terms.fee).div(10000);
1093     uint256 feePartner = payout.mul(terms.feePartner).div(10000);
1094 
1095     /**
1096             asset carries risk and is not minted against
1097             asset transfered to treasury and rewards minted as payout
1098          */
1099     IERC20(principle).safeTransferFrom(msg.sender, treasury, _amount);
1100 
1101     ITreasury(treasury).updateReserve(principle, value);
1102     ITreasury(treasury).mintRewards(
1103       address(this),
1104       payout.add(fee).add(feePartner)
1105     );
1106 
1107     if (fee != 0) {
1108       IERC20(LOBI).safeTransfer(DAO, fee);
1109     }
1110 
1111     if (feePartner != 0) {
1112       IERC20(LOBI).safeTransfer(partnerDAO, feePartner);
1113     }
1114 
1115     // total debt is increased
1116     totalDebt = totalDebt.add(value);
1117 
1118     // depositor info is stored
1119     bondInfo[_depositor] = Bond({
1120       payout: bondInfo[_depositor].payout.add(payout),
1121       vesting: terms.vestingTerm,
1122       lastBlock: block.number,
1123       pricePaid: priceInUSD
1124     });
1125 
1126     // indexed events are emitted
1127     emit BondCreated(
1128       _amount,
1129       payout,
1130       block.number.add(terms.vestingTerm),
1131       priceInUSD
1132     );
1133     emit BondPriceChanged(_bondPrice(), _bondPrice(), debtRatio());
1134 
1135     adjust(); // control variable is adjusted
1136     return payout;
1137   }
1138 
1139   /**
1140    *  @notice redeem bond for user
1141    *  @param _recipient address
1142    *  @param _stake bool
1143    *  @return uint
1144    */
1145   function redeem(address _recipient, bool _stake) external returns (uint256) {
1146     Bond memory info = bondInfo[_recipient];
1147     uint256 percentVested = percentVestedFor(_recipient); // (blocks since last interaction / vesting term remaining)
1148 
1149     if (percentVested >= 10000) {
1150       // if fully vested
1151       delete bondInfo[_recipient]; // delete user info
1152       emit BondRedeemed(_recipient, info.payout, 0); // emit bond data
1153       return stakeOrSend(_recipient, _stake, info.payout); // pay user everything due
1154     } else {
1155       // if unfinished
1156       // calculate payout vested
1157       uint256 payout = info.payout.mul(percentVested).div(10000);
1158 
1159       // store updated deposit info
1160       bondInfo[_recipient] = Bond({
1161         payout: info.payout.sub(payout),
1162         vesting: info.vesting.sub(block.number.sub(info.lastBlock)),
1163         lastBlock: block.number,
1164         pricePaid: info.pricePaid
1165       });
1166 
1167       emit BondRedeemed(_recipient, payout, bondInfo[_recipient].payout);
1168       return stakeOrSend(_recipient, _stake, payout);
1169     }
1170   }
1171 
1172   /* ======== INTERNAL HELPER FUNCTIONS ======== */
1173 
1174   /**
1175    *  @notice allow user to stake payout automatically
1176    *  @param _stake bool
1177    *  @param _amount uint
1178    *  @return uint
1179    */
1180   function stakeOrSend(
1181     address _recipient,
1182     bool _stake,
1183     uint256 _amount
1184   ) internal returns (uint256) {
1185     if (!_stake) {
1186       // if user does not want to stake
1187       IERC20(LOBI).transfer(_recipient, _amount); // send payout
1188     } else {
1189       // if user wants to stake
1190       if (useHelper) {
1191         // use if staking warmup is 0
1192         IERC20(LOBI).approve(stakingHelper, _amount);
1193         IStakingHelper(stakingHelper).stake(_amount, _recipient);
1194       } else {
1195         IERC20(LOBI).approve(staking, _amount);
1196         IStaking(staking).stake(_amount, _recipient);
1197       }
1198     }
1199     return _amount;
1200   }
1201 
1202   /**
1203    *  @notice makes incremental adjustment to control variable
1204    */
1205   function adjust() internal {
1206     uint256 blockCanAdjust = adjustment.lastBlock.add(adjustment.buffer);
1207     if (adjustment.rate != 0 && block.number >= blockCanAdjust) {
1208       uint256 initial = terms.controlVariable;
1209       if (adjustment.add) {
1210         terms.controlVariable = terms.controlVariable.add(adjustment.rate);
1211         if (terms.controlVariable >= adjustment.target) {
1212           adjustment.rate = 0;
1213         }
1214       } else {
1215         terms.controlVariable = terms.controlVariable.sub(adjustment.rate);
1216         if (terms.controlVariable <= adjustment.target) {
1217           adjustment.rate = 0;
1218         }
1219       }
1220       adjustment.lastBlock = block.number;
1221       emit ControlVariableAdjustment(
1222         initial,
1223         terms.controlVariable,
1224         adjustment.rate,
1225         adjustment.add
1226       );
1227     }
1228   }
1229 
1230   /**
1231    *  @notice reduce total debt
1232    */
1233   function decayDebt() internal {
1234     totalDebt = totalDebt.sub(debtDecay());
1235     lastDecay = block.number;
1236   }
1237 
1238   /* ======== VIEW FUNCTIONS ======== */
1239 
1240   /**
1241    *  @notice determine maximum bond size
1242    *  @return uint
1243    */
1244   function maxPayout() public view returns (uint256) {
1245     return IERC20(LOBI).totalSupply().mul(terms.maxPayout).div(100000);
1246   }
1247 
1248   /**
1249    *  @notice calculate interest due for new bond
1250    *  @param _value uint
1251    *  @return uint
1252    */
1253   function payoutFor(uint256 _value) public view returns (uint256) {
1254     return FixedPoint.fraction(_value, bondPrice()).decode112with18().div(1e14);
1255   }
1256 
1257   /**
1258    *  @notice calculate current bond premium
1259    *  @return price_ uint
1260    */
1261   function bondPrice() public view returns (uint256 price_) {
1262     price_ = terms.controlVariable.mul(debtRatio()).div(1e5);
1263     if (price_ < terms.minimumPrice) {
1264       price_ = terms.minimumPrice;
1265     }
1266   }
1267 
1268   /**
1269    *  @notice calculate current bond price and remove floor if above
1270    *  @return price_ uint
1271    */
1272   function _bondPrice() internal returns (uint256 price_) {
1273     price_ = terms.controlVariable.mul(debtRatio()).div(1e5);
1274     if (price_ < terms.minimumPrice) {
1275       price_ = terms.minimumPrice;
1276     } else if (terms.minimumPrice != 0) {
1277       terms.minimumPrice = 0;
1278     }
1279   }
1280 
1281   /**
1282    *  @notice calculate current ratio of debt to LOBI supply
1283    *  @return debtRatio_ uint
1284    */
1285   function debtRatio() public view returns (uint256 debtRatio_) {
1286     uint256 supply = IERC20(LOBI).totalSupply();
1287     debtRatio_ = FixedPoint
1288       .fraction(currentDebt().mul(1e9), supply)
1289       .decode112with18()
1290       .div(1e18);
1291   }
1292 
1293   /**
1294    *  @notice calculate debt factoring in decay
1295    *  @return uint
1296    */
1297   function currentDebt() public view returns (uint256) {
1298     return totalDebt.sub(debtDecay());
1299   }
1300 
1301   /**
1302    *  @notice amount to decay total debt by
1303    *  @return decay_ uint
1304    */
1305   function debtDecay() public view returns (uint256 decay_) {
1306     uint256 blocksSinceLast = block.number.sub(lastDecay);
1307     decay_ = totalDebt.mul(blocksSinceLast).div(terms.vestingTerm);
1308     if (decay_ > totalDebt) {
1309       decay_ = totalDebt;
1310     }
1311   }
1312 
1313   /**
1314    *  @notice calculate how far into vesting a depositor is
1315    *  @param _depositor address
1316    *  @return percentVested_ uint
1317    */
1318   function percentVestedFor(address _depositor)
1319     public
1320     view
1321     returns (uint256 percentVested_)
1322   {
1323     Bond memory bond = bondInfo[_depositor];
1324     uint256 blocksSinceLast = block.number.sub(bond.lastBlock);
1325     uint256 vesting = bond.vesting;
1326 
1327     if (vesting > 0) {
1328       percentVested_ = blocksSinceLast.mul(10000).div(vesting);
1329     } else {
1330       percentVested_ = 0;
1331     }
1332   }
1333 
1334   /**
1335    *  @notice calculate amount of LOBI available for claim by depositor
1336    *  @param _depositor address
1337    *  @return pendingPayout_ uint
1338    */
1339   function pendingPayoutFor(address _depositor)
1340     external
1341     view
1342     returns (uint256 pendingPayout_)
1343   {
1344     uint256 percentVested = percentVestedFor(_depositor);
1345     uint256 payout = bondInfo[_depositor].payout;
1346 
1347     if (percentVested >= 10000) {
1348       pendingPayout_ = payout;
1349     } else {
1350       pendingPayout_ = payout.mul(percentVested).div(10000);
1351     }
1352   }
1353 
1354   function setDAOs(address _DAO, address _partnerDAO) external onlyPolicy {
1355     DAO = _DAO;
1356     partnerDAO = _partnerDAO;
1357   }
1358 
1359   /* ======= AUXILLIARY ======= */
1360 
1361   /**
1362    *  @notice allow anyone to send lost tokens (excluding principle or LOBI) to the DAO
1363    *  @return bool
1364    */
1365   function recoverLostToken(address _token) external returns (bool) {
1366     require(_token != LOBI);
1367     require(_token != principle);
1368     IERC20(_token).safeTransfer(DAO, IERC20(_token).balanceOf(address(this)));
1369     return true;
1370   }
1371 }