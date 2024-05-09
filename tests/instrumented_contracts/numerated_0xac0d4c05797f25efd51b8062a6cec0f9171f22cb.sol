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
821 interface AggregatorV3Interface {
822   function decimals() external view returns (uint8);
823 
824   function description() external view returns (string memory);
825 
826   function version() external view returns (uint256);
827 
828   // getRoundData and latestRoundData should both raise "No data present"
829   // if they do not have data to report, instead of returning unset values
830   // which could be misinterpreted as actual reported values.
831   function getRoundData(uint80 _roundId)
832     external
833     view
834     returns (
835       uint80 roundId,
836       int256 answer,
837       uint256 startedAt,
838       uint256 updatedAt,
839       uint80 answeredInRound
840     );
841 
842   function latestRoundData()
843     external
844     view
845     returns (
846       uint80 roundId,
847       int256 answer,
848       uint256 startedAt,
849       uint256 updatedAt,
850       uint80 answeredInRound
851     );
852 }
853 
854 interface ITreasury {
855   function deposit(
856     uint256 _amount,
857     address _token,
858     uint256 _profit
859   ) external returns (bool);
860 
861   function updateReserve(address _token, uint256 _amount) external;
862 
863   function valueOfToken(address _token, uint256 _amount)
864     external
865     view
866     returns (uint256 value_);
867 
868   function mintRewards(address _recipient, uint256 _amount) external;
869 }
870 
871 interface IStaking {
872   function stake(uint256 _amount, address _recipient) external returns (bool);
873 }
874 
875 interface IStakingHelper {
876   function stake(uint256 _amount, address _recipient) external;
877 }
878 
879 contract TokenBondDepository is Ownable {
880   using FixedPoint for *;
881   using SafeERC20 for IERC20;
882   using SafeMath for uint256;
883 
884   /* ======== EVENTS ======== */
885 
886   event BondCreated(
887     uint256 deposit,
888     uint256 indexed payout,
889     uint256 indexed expires,
890     uint256 indexed priceInUSD
891   );
892   event BondRedeemed(
893     address indexed recipient,
894     uint256 payout,
895     uint256 remaining
896   );
897   event BondPriceChanged(
898     uint256 indexed priceInUSD,
899     uint256 indexed internalPrice,
900     uint256 indexed debtRatio
901   );
902   event ControlVariableAdjustment(
903     uint256 initialBCV,
904     uint256 newBCV,
905     uint256 adjustment,
906     bool addition
907   );
908 
909   /* ======== STATE VARIABLES ======== */
910 
911   address public immutable LOBI; // token given as payment for bond
912   address public immutable principle; // token used to create bond
913   address public immutable treasury; // mints LOBI when receives principle
914   address public DAO; // receives profit share from bond
915   address public partnerDAO; // receives profit share from bond
916 
917   AggregatorV3Interface internal priceFeed;
918 
919   address public staking; // to auto-stake payout
920   address public stakingHelper; // to stake and claim if no staking warmup
921   bool public useHelper;
922 
923   Terms public terms; // stores terms for new bonds
924   Adjust public adjustment; // stores adjustment to BCV data
925 
926   mapping(address => Bond) public bondInfo; // stores bond information for depositors
927 
928   uint256 public totalDebt; // total value of outstanding bonds; used for pricing
929   uint256 public lastDecay; // reference block for debt decay
930 
931   /* ======== STRUCTS ======== */
932 
933   // Info for creating new bonds
934   struct Terms {
935     uint256 controlVariable; // scaling variable for price
936     uint256 vestingTerm; // in blocks
937     uint256 minimumPrice; // vs principle value. 4 decimals (1500 = 0.15)
938     uint256 maxPayout; // in thousandths of a %. i.e. 500 = 0.5%
939     uint256 maxDebt; // 9 decimal debt ratio, max % total supply created as debt
940     uint256 fee; // as % of bond payout, in hundreths. ( 500 = 5% = 0.05 for every 1 paid)
941     uint256 feePartner; // as % of bond payout, in hundreths. ( 500 = 5% = 0.05 for every 1 paid)
942   }
943 
944   // Info for bond holder
945   struct Bond {
946     uint256 payout; // LOBI remaining to be paid
947     uint256 vesting; // Blocks left to vest
948     uint256 lastBlock; // Last interaction
949     uint256 pricePaid; // In DAI, for front end viewing
950   }
951 
952   // Info for incremental adjustments to control variable
953   struct Adjust {
954     bool add; // addition or subtraction
955     uint256 rate; // increment
956     uint256 target; // BCV when adjustment finished
957     uint256 buffer; // minimum length (in blocks) between adjustments
958     uint256 lastBlock; // block when last adjustment made
959   }
960 
961   /* ======== INITIALIZATION ======== */
962 
963   constructor(
964     address _LOBI,
965     address _principle,
966     address _treasury,
967     address _DAO,
968     address _partnerDAO,
969     address _feed
970   ) {
971     require(_LOBI != address(0));
972     LOBI = _LOBI;
973     require(_principle != address(0));
974     principle = _principle;
975     require(_treasury != address(0));
976     treasury = _treasury;
977     require(_DAO != address(0));
978     DAO = _DAO;
979     require(_partnerDAO != address(0));
980     partnerDAO = _partnerDAO;
981     require(_feed != address(0));
982     priceFeed = AggregatorV3Interface(_feed);
983   }
984 
985   /**
986    *  @notice initializes bond parameters
987    *  @param _controlVariable uint
988    *  @param _vestingTerm uint
989    *  @param _minimumPrice uint
990    *  @param _maxPayout uint
991    *  @param _maxDebt uint
992    *  @param _initialDebt uint
993    */
994   function initializeBondTerms(
995     uint256 _controlVariable,
996     uint256 _vestingTerm,
997     uint256 _minimumPrice,
998     uint256 _maxPayout,
999     uint256 _maxDebt,
1000     uint256 _initialDebt,
1001     uint256 _fee,
1002     uint256 _feePartner
1003   ) external onlyPolicy {
1004     terms = Terms({
1005       controlVariable: _controlVariable,
1006       vestingTerm: _vestingTerm,
1007       minimumPrice: _minimumPrice,
1008       maxPayout: _maxPayout,
1009       maxDebt: _maxDebt,
1010       fee: _fee,
1011       feePartner: _feePartner
1012     });
1013     totalDebt = _initialDebt;
1014     lastDecay = block.number;
1015   }
1016 
1017   /* ======== POLICY FUNCTIONS ======== */
1018 
1019   enum PARAMETER {
1020     VESTING,
1021     PAYOUT,
1022     DEBT,
1023     FEE,
1024     FEEPARTNER
1025   }
1026 
1027   /**
1028    *  @notice set parameters for new bonds
1029    *  @param _parameter PARAMETER
1030    *  @param _input uint
1031    */
1032   function setBondTerms(PARAMETER _parameter, uint256 _input)
1033     external
1034     onlyPolicy
1035   {
1036     if (_parameter == PARAMETER.VESTING) {
1037       // 0
1038       require(_input >= 10000, "Vesting must be longer than 36 hours");
1039       terms.vestingTerm = _input;
1040     } else if (_parameter == PARAMETER.PAYOUT) {
1041       // 1
1042       require(_input <= 1000, "Payout cannot be above 1 percent");
1043       terms.maxPayout = _input;
1044     } else if (_parameter == PARAMETER.DEBT) {
1045       // 2
1046       terms.maxDebt = _input;
1047     } else if (_parameter == PARAMETER.FEE) {
1048       // 3
1049       terms.fee = _input;
1050     } else if (_parameter == PARAMETER.FEEPARTNER) {
1051       // 4
1052       terms.feePartner = _input;
1053     }
1054   }
1055 
1056   /**
1057    *  @notice set control variable adjustment
1058    *  @param _addition bool
1059    *  @param _increment uint
1060    *  @param _target uint
1061    *  @param _buffer uint
1062    */
1063   function setAdjustment(
1064     bool _addition,
1065     uint256 _increment,
1066     uint256 _target,
1067     uint256 _buffer
1068   ) external onlyPolicy {
1069     require(
1070       _increment <= terms.controlVariable.mul(25).div(1000),
1071       "Increment too large"
1072     );
1073 
1074     adjustment = Adjust({
1075       add: _addition,
1076       rate: _increment,
1077       target: _target,
1078       buffer: _buffer,
1079       lastBlock: block.number
1080     });
1081   }
1082 
1083   /**
1084    *  @notice set contract for auto stake
1085    *  @param _staking address
1086    *  @param _helper bool
1087    */
1088   function setStaking(address _staking, bool _helper) external onlyPolicy {
1089     require(_staking != address(0));
1090     if (_helper) {
1091       useHelper = true;
1092       stakingHelper = _staking;
1093     } else {
1094       useHelper = false;
1095       staking = _staking;
1096     }
1097   }
1098 
1099   /* ======== USER FUNCTIONS ======== */
1100 
1101   /**
1102    *  @notice deposit bond
1103    *  @param _amount uint
1104    *  @param _maxPrice uint
1105    *  @param _depositor address
1106    *  @return uint
1107    */
1108   function deposit(
1109     uint256 _amount,
1110     uint256 _maxPrice,
1111     address _depositor
1112   ) external returns (uint256) {
1113     require(_depositor != address(0), "Invalid address");
1114 
1115     decayDebt();
1116     require(totalDebt <= terms.maxDebt, "Max capacity reached");
1117 
1118     uint256 priceInUSD = bondPriceInUSD(); // Stored in bond info
1119     uint256 nativePrice = _bondPrice();
1120 
1121     require(_maxPrice >= nativePrice, "Slippage limit: more than max price"); // slippage protection
1122 
1123     uint256 value = ITreasury(treasury).valueOfToken(principle, _amount);
1124     uint256 payout = payoutFor(value); // payout to bonder is computed
1125 
1126     require(payout >= 10000000, "Bond too small"); // must be > 0.01 LOBI ( underflow protection )
1127     require(payout <= maxPayout(), "Bond too large"); // size protection because there is no slippage
1128 
1129     // profits are calculated
1130     uint256 fee = payout.mul(terms.fee).div(10000);
1131     uint256 feePartner = payout.mul(terms.feePartner).div(10000);
1132 
1133     /**
1134             asset carries risk and is not minted against
1135             asset transfered to treasury and rewards minted as payout
1136          */
1137     IERC20(principle).safeTransferFrom(msg.sender, treasury, _amount);
1138 
1139     ITreasury(treasury).updateReserve(principle, value);
1140     ITreasury(treasury).mintRewards(
1141       address(this),
1142       payout.add(fee).add(feePartner)
1143     );
1144 
1145     if (fee != 0) {
1146       IERC20(LOBI).safeTransfer(DAO, fee);
1147     }
1148 
1149     if (feePartner != 0) {
1150       IERC20(LOBI).safeTransfer(partnerDAO, feePartner);
1151     }
1152 
1153     // total debt is increased
1154     totalDebt = totalDebt.add(value);
1155 
1156     // depositor info is stored
1157     bondInfo[_depositor] = Bond({
1158       payout: bondInfo[_depositor].payout.add(payout),
1159       vesting: terms.vestingTerm,
1160       lastBlock: block.number,
1161       pricePaid: priceInUSD
1162     });
1163 
1164     // indexed events are emitted
1165     emit BondCreated(
1166       _amount,
1167       payout,
1168       block.number.add(terms.vestingTerm),
1169       priceInUSD
1170     );
1171     emit BondPriceChanged(bondPriceInUSD(), _bondPrice(), debtRatio());
1172 
1173     adjust(); // control variable is adjusted
1174     return payout;
1175   }
1176 
1177   /**
1178    *  @notice redeem bond for user
1179    *  @param _recipient address
1180    *  @param _stake bool
1181    *  @return uint
1182    */
1183   function redeem(address _recipient, bool _stake) external returns (uint256) {
1184     Bond memory info = bondInfo[_recipient];
1185     uint256 percentVested = percentVestedFor(_recipient); // (blocks since last interaction / vesting term remaining)
1186 
1187     if (percentVested >= 10000) {
1188       // if fully vested
1189       delete bondInfo[_recipient]; // delete user info
1190       emit BondRedeemed(_recipient, info.payout, 0); // emit bond data
1191       return stakeOrSend(_recipient, _stake, info.payout); // pay user everything due
1192     } else {
1193       // if unfinished
1194       // calculate payout vested
1195       uint256 payout = info.payout.mul(percentVested).div(10000);
1196 
1197       // store updated deposit info
1198       bondInfo[_recipient] = Bond({
1199         payout: info.payout.sub(payout),
1200         vesting: info.vesting.sub(block.number.sub(info.lastBlock)),
1201         lastBlock: block.number,
1202         pricePaid: info.pricePaid
1203       });
1204 
1205       emit BondRedeemed(_recipient, payout, bondInfo[_recipient].payout);
1206       return stakeOrSend(_recipient, _stake, payout);
1207     }
1208   }
1209 
1210   /* ======== INTERNAL HELPER FUNCTIONS ======== */
1211 
1212   /**
1213    *  @notice allow user to stake payout automatically
1214    *  @param _stake bool
1215    *  @param _amount uint
1216    *  @return uint
1217    */
1218   function stakeOrSend(
1219     address _recipient,
1220     bool _stake,
1221     uint256 _amount
1222   ) internal returns (uint256) {
1223     if (!_stake) {
1224       // if user does not want to stake
1225       IERC20(LOBI).transfer(_recipient, _amount); // send payout
1226     } else {
1227       // if user wants to stake
1228       if (useHelper) {
1229         // use if staking warmup is 0
1230         IERC20(LOBI).approve(stakingHelper, _amount);
1231         IStakingHelper(stakingHelper).stake(_amount, _recipient);
1232       } else {
1233         IERC20(LOBI).approve(staking, _amount);
1234         IStaking(staking).stake(_amount, _recipient);
1235       }
1236     }
1237     return _amount;
1238   }
1239 
1240   /**
1241    *  @notice makes incremental adjustment to control variable
1242    */
1243   function adjust() internal {
1244     uint256 blockCanAdjust = adjustment.lastBlock.add(adjustment.buffer);
1245     if (adjustment.rate != 0 && block.number >= blockCanAdjust) {
1246       uint256 initial = terms.controlVariable;
1247       if (adjustment.add) {
1248         terms.controlVariable = terms.controlVariable.add(adjustment.rate);
1249         if (terms.controlVariable >= adjustment.target) {
1250           adjustment.rate = 0;
1251         }
1252       } else {
1253         terms.controlVariable = terms.controlVariable.sub(adjustment.rate);
1254         if (terms.controlVariable <= adjustment.target) {
1255           adjustment.rate = 0;
1256         }
1257       }
1258       adjustment.lastBlock = block.number;
1259       emit ControlVariableAdjustment(
1260         initial,
1261         terms.controlVariable,
1262         adjustment.rate,
1263         adjustment.add
1264       );
1265     }
1266   }
1267 
1268   /**
1269    *  @notice reduce total debt
1270    */
1271   function decayDebt() internal {
1272     totalDebt = totalDebt.sub(debtDecay());
1273     lastDecay = block.number;
1274   }
1275 
1276   /* ======== VIEW FUNCTIONS ======== */
1277 
1278   /**
1279    *  @notice determine maximum bond size
1280    *  @return uint
1281    */
1282   function maxPayout() public view returns (uint256) {
1283     return IERC20(LOBI).totalSupply().mul(terms.maxPayout).div(100000);
1284   }
1285 
1286   /**
1287    *  @notice calculate interest due for new bond
1288    *  @param _value uint
1289    *  @return uint
1290    */
1291   function payoutFor(uint256 _value) public view returns (uint256) {
1292     return FixedPoint.fraction(_value, bondPrice()).decode112with18().div(1e14);
1293   }
1294 
1295   /**
1296    *  @notice calculate current bond premium
1297    *  @return price_ uint
1298    */
1299   function bondPrice() public view returns (uint256 price_) {
1300     price_ = terms.controlVariable.mul(debtRatio()).div(1e5);
1301     if (price_ < terms.minimumPrice) {
1302       price_ = terms.minimumPrice;
1303     }
1304   }
1305 
1306   /**
1307    *  @notice calculate current bond price and remove floor if above
1308    *  @return price_ uint
1309    */
1310   function _bondPrice() internal returns (uint256 price_) {
1311     price_ = terms.controlVariable.mul(debtRatio()).div(1e5);
1312     if (price_ < terms.minimumPrice) {
1313       price_ = terms.minimumPrice;
1314     } else if (terms.minimumPrice != 0) {
1315       terms.minimumPrice = 0;
1316     }
1317   }
1318 
1319   /**
1320    *  @notice get asset price from chainlink
1321    */
1322   function assetPrice() public view returns (int256) {
1323     (, int256 price, , , ) = priceFeed.latestRoundData();
1324     return price;
1325   }
1326 
1327   /**
1328    *  @notice converts bond price to DAI value
1329    *  @return price_ uint
1330    */
1331   function bondPriceInUSD() public view returns (uint256 price_) {
1332     price_ = bondPrice().mul(uint256(assetPrice())).mul(1e6);
1333   }
1334 
1335   /**
1336    *  @notice calculate current ratio of debt to LOBI supply
1337    *  @return debtRatio_ uint
1338    */
1339   function debtRatio() public view returns (uint256 debtRatio_) {
1340     uint256 supply = IERC20(LOBI).totalSupply();
1341     debtRatio_ = FixedPoint
1342       .fraction(currentDebt().mul(1e9), supply)
1343       .decode112with18()
1344       .div(1e18);
1345   }
1346 
1347   /**
1348    *  @notice debt ratio in same terms as reserve bonds
1349    *  @return uint
1350    */
1351   function standardizedDebtRatio() external view returns (uint256) {
1352     return debtRatio().mul(uint256(assetPrice())).div(1e8); // ETH feed is 8 decimals
1353   }
1354 
1355   /**
1356    *  @notice calculate debt factoring in decay
1357    *  @return uint
1358    */
1359   function currentDebt() public view returns (uint256) {
1360     return totalDebt.sub(debtDecay());
1361   }
1362 
1363   /**
1364    *  @notice amount to decay total debt by
1365    *  @return decay_ uint
1366    */
1367   function debtDecay() public view returns (uint256 decay_) {
1368     uint256 blocksSinceLast = block.number.sub(lastDecay);
1369     decay_ = totalDebt.mul(blocksSinceLast).div(terms.vestingTerm);
1370     if (decay_ > totalDebt) {
1371       decay_ = totalDebt;
1372     }
1373   }
1374 
1375   /**
1376    *  @notice calculate how far into vesting a depositor is
1377    *  @param _depositor address
1378    *  @return percentVested_ uint
1379    */
1380   function percentVestedFor(address _depositor)
1381     public
1382     view
1383     returns (uint256 percentVested_)
1384   {
1385     Bond memory bond = bondInfo[_depositor];
1386     uint256 blocksSinceLast = block.number.sub(bond.lastBlock);
1387     uint256 vesting = bond.vesting;
1388 
1389     if (vesting > 0) {
1390       percentVested_ = blocksSinceLast.mul(10000).div(vesting);
1391     } else {
1392       percentVested_ = 0;
1393     }
1394   }
1395 
1396   /**
1397    *  @notice calculate amount of LOBI available for claim by depositor
1398    *  @param _depositor address
1399    *  @return pendingPayout_ uint
1400    */
1401   function pendingPayoutFor(address _depositor)
1402     external
1403     view
1404     returns (uint256 pendingPayout_)
1405   {
1406     uint256 percentVested = percentVestedFor(_depositor);
1407     uint256 payout = bondInfo[_depositor].payout;
1408 
1409     if (percentVested >= 10000) {
1410       pendingPayout_ = payout;
1411     } else {
1412       pendingPayout_ = payout.mul(percentVested).div(10000);
1413     }
1414   }
1415 
1416   function setDAOs(address _DAO, address _partnerDAO) external onlyPolicy {
1417     DAO = _DAO;
1418     partnerDAO = _partnerDAO;
1419   }
1420 
1421   /* ======= AUXILLIARY ======= */
1422 
1423   /**
1424    *  @notice allow anyone to send lost tokens (excluding principle or LOBI) to the DAO
1425    *  @return bool
1426    */
1427   function recoverLostToken(address _token) external returns (bool) {
1428     require(_token != LOBI);
1429     require(_token != principle);
1430     IERC20(_token).safeTransfer(DAO, IERC20(_token).balanceOf(address(this)));
1431     return true;
1432   }
1433 }