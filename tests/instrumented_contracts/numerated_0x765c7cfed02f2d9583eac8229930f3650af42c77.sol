1 // File: contracts/REDACTEDBondDepositoryRewardBased.sol
2 
3 
4 pragma solidity 0.7.5;
5 
6 interface IOwnable {
7   function policy() external view returns (address);
8 
9   function renounceManagement() external;
10 
11   function pushManagement(address newOwner_) external;
12 
13   function pullManagement() external;
14 }
15 
16 contract Ownable is IOwnable {
17   address internal _owner;
18   address internal _newOwner;
19 
20   event OwnershipPushed(address indexed previousOwner, address indexed newOwner);
21   event OwnershipPulled(address indexed previousOwner, address indexed newOwner);
22 
23   constructor() {
24     _owner = msg.sender;
25     emit OwnershipPushed(address(0), _owner);
26   }
27 
28   function policy() public view override returns (address) {
29     return _owner;
30   }
31 
32   modifier onlyPolicy() {
33     require(_owner == msg.sender, 'Ownable: caller is not the owner');
34     _;
35   }
36 
37   function renounceManagement() public virtual override onlyPolicy {
38     emit OwnershipPushed(_owner, address(0));
39     _owner = address(0);
40   }
41 
42   function pushManagement(address newOwner_) public virtual override onlyPolicy {
43     require(newOwner_ != address(0), 'Ownable: new owner is the zero address');
44     emit OwnershipPushed(_owner, newOwner_);
45     _newOwner = newOwner_;
46   }
47 
48   function pullManagement() public virtual override {
49     require(msg.sender == _newOwner, 'Ownable: must be new owner to pull');
50     emit OwnershipPulled(_owner, _newOwner);
51     _owner = _newOwner;
52   }
53 }
54 
55 library SafeMath {
56   function add(uint256 a, uint256 b) internal pure returns (uint256) {
57     uint256 c = a + b;
58     require(c >= a, 'SafeMath: addition overflow');
59 
60     return c;
61   }
62 
63   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64     return sub(a, b, 'SafeMath: subtraction overflow');
65   }
66 
67   function sub(
68     uint256 a,
69     uint256 b,
70     string memory errorMessage
71   ) internal pure returns (uint256) {
72     require(b <= a, errorMessage);
73     uint256 c = a - b;
74 
75     return c;
76   }
77 
78   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
79     if (a == 0) {
80       return 0;
81     }
82 
83     uint256 c = a * b;
84     require(c / a == b, 'SafeMath: multiplication overflow');
85 
86     return c;
87   }
88 
89   function div(uint256 a, uint256 b) internal pure returns (uint256) {
90     return div(a, b, 'SafeMath: division by zero');
91   }
92 
93   function div(
94     uint256 a,
95     uint256 b,
96     string memory errorMessage
97   ) internal pure returns (uint256) {
98     require(b > 0, errorMessage);
99     uint256 c = a / b;
100     return c;
101   }
102 
103   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
104     return mod(a, b, 'SafeMath: modulo by zero');
105   }
106 
107   function mod(
108     uint256 a,
109     uint256 b,
110     string memory errorMessage
111   ) internal pure returns (uint256) {
112     require(b != 0, errorMessage);
113     return a % b;
114   }
115 
116   function sqrrt(uint256 a) internal pure returns (uint256 c) {
117     if (a > 3) {
118       c = a;
119       uint256 b = add(div(a, 2), 1);
120       while (b < c) {
121         c = b;
122         b = div(add(div(a, b), b), 2);
123       }
124     } else if (a != 0) {
125       c = 1;
126     }
127   }
128 }
129 
130 library Address {
131   function isContract(address account) internal view returns (bool) {
132     uint256 size;
133     // solhint-disable-next-line no-inline-assembly
134     assembly {
135       size := extcodesize(account)
136     }
137     return size > 0;
138   }
139 
140   function sendValue(address payable recipient, uint256 amount) internal {
141     require(address(this).balance >= amount, 'Address: insufficient balance');
142 
143     // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
144     (bool success, ) = recipient.call{value: amount}('');
145     require(success, 'Address: unable to send value, recipient may have reverted');
146   }
147 
148   function functionCall(address target, bytes memory data) internal returns (bytes memory) {
149     return functionCall(target, data, 'Address: low-level call failed');
150   }
151 
152   function functionCall(
153     address target,
154     bytes memory data,
155     string memory errorMessage
156   ) internal returns (bytes memory) {
157     return _functionCallWithValue(target, data, 0, errorMessage);
158   }
159 
160   function functionCallWithValue(
161     address target,
162     bytes memory data,
163     uint256 value
164   ) internal returns (bytes memory) {
165     return
166       functionCallWithValue(target, data, value, 'Address: low-level call with value failed');
167   }
168 
169   function functionCallWithValue(
170     address target,
171     bytes memory data,
172     uint256 value,
173     string memory errorMessage
174   ) internal returns (bytes memory) {
175     require(address(this).balance >= value, 'Address: insufficient balance for call');
176     require(isContract(target), 'Address: call to non-contract');
177 
178     // solhint-disable-next-line avoid-low-level-calls
179     (bool success, bytes memory returndata) = target.call{value: value}(data);
180     return _verifyCallResult(success, returndata, errorMessage);
181   }
182 
183   function _functionCallWithValue(
184     address target,
185     bytes memory data,
186     uint256 weiValue,
187     string memory errorMessage
188   ) private returns (bytes memory) {
189     require(isContract(target), 'Address: call to non-contract');
190 
191     // solhint-disable-next-line avoid-low-level-calls
192     (bool success, bytes memory returndata) = target.call{value: weiValue}(data);
193     if (success) {
194       return returndata;
195     } else {
196       // Look for revert reason and bubble it up if present
197       if (returndata.length > 0) {
198         // The easiest way to bubble the revert reason is using memory via assembly
199 
200         // solhint-disable-next-line no-inline-assembly
201         assembly {
202           let returndata_size := mload(returndata)
203           revert(add(32, returndata), returndata_size)
204         }
205       } else {
206         revert(errorMessage);
207       }
208     }
209   }
210 
211   function functionStaticCall(address target, bytes memory data)
212     internal
213     view
214     returns (bytes memory)
215   {
216     return functionStaticCall(target, data, 'Address: low-level static call failed');
217   }
218 
219   function functionStaticCall(
220     address target,
221     bytes memory data,
222     string memory errorMessage
223   ) internal view returns (bytes memory) {
224     require(isContract(target), 'Address: static call to non-contract');
225 
226     // solhint-disable-next-line avoid-low-level-calls
227     (bool success, bytes memory returndata) = target.staticcall(data);
228     return _verifyCallResult(success, returndata, errorMessage);
229   }
230 
231   function functionDelegateCall(address target, bytes memory data)
232     internal
233     returns (bytes memory)
234   {
235     return functionDelegateCall(target, data, 'Address: low-level delegate call failed');
236   }
237 
238   function functionDelegateCall(
239     address target,
240     bytes memory data,
241     string memory errorMessage
242   ) internal returns (bytes memory) {
243     require(isContract(target), 'Address: delegate call to non-contract');
244 
245     // solhint-disable-next-line avoid-low-level-calls
246     (bool success, bytes memory returndata) = target.delegatecall(data);
247     return _verifyCallResult(success, returndata, errorMessage);
248   }
249 
250   function _verifyCallResult(
251     bool success,
252     bytes memory returndata,
253     string memory errorMessage
254   ) private pure returns (bytes memory) {
255     if (success) {
256       return returndata;
257     } else {
258       if (returndata.length > 0) {
259         assembly {
260           let returndata_size := mload(returndata)
261           revert(add(32, returndata), returndata_size)
262         }
263       } else {
264         revert(errorMessage);
265       }
266     }
267   }
268 
269   function addressToString(address _address) internal pure returns (string memory) {
270     bytes32 _bytes = bytes32(uint256(_address));
271     bytes memory HEX = '0123456789abcdef';
272     bytes memory _addr = new bytes(42);
273 
274     _addr[0] = '0';
275     _addr[1] = 'x';
276 
277     for (uint256 i = 0; i < 20; i++) {
278       _addr[2 + i * 2] = HEX[uint8(_bytes[i + 12] >> 4)];
279       _addr[3 + i * 2] = HEX[uint8(_bytes[i + 12] & 0x0f)];
280     }
281 
282     return string(_addr);
283   }
284 }
285 
286 interface IERC20 {
287   function decimals() external view returns (uint8);
288 
289   function totalSupply() external view returns (uint256);
290 
291   function balanceOf(address account) external view returns (uint256);
292 
293   function transfer(address recipient, uint256 amount) external returns (bool);
294 
295   function allowance(address owner, address spender) external view returns (uint256);
296 
297   function approve(address spender, uint256 amount) external returns (bool);
298 
299   function transferFrom(
300     address sender,
301     address recipient,
302     uint256 amount
303   ) external returns (bool);
304 
305   event Transfer(address indexed from, address indexed to, uint256 value);
306 
307   event Approval(address indexed owner, address indexed spender, uint256 value);
308 }
309 
310 abstract contract ERC20 is IERC20 {
311   using SafeMath for uint256;
312 
313   // TODO comment actual hash value.
314   bytes32 private constant ERC20TOKEN_ERC1820_INTERFACE_ID = keccak256('ERC20Token');
315 
316   mapping(address => uint256) internal _balances;
317 
318   mapping(address => mapping(address => uint256)) internal _allowances;
319 
320   uint256 internal _totalSupply;
321 
322   string internal _name;
323 
324   string internal _symbol;
325 
326   uint8 internal _decimals;
327 
328   constructor(
329     string memory name_,
330     string memory symbol_,
331     uint8 decimals_
332   ) {
333     _name = name_;
334     _symbol = symbol_;
335     _decimals = decimals_;
336   }
337 
338   function name() public view returns (string memory) {
339     return _name;
340   }
341 
342   function symbol() public view returns (string memory) {
343     return _symbol;
344   }
345 
346   function decimals() public view override returns (uint8) {
347     return _decimals;
348   }
349 
350   function totalSupply() public view override returns (uint256) {
351     return _totalSupply;
352   }
353 
354   function balanceOf(address account) public view virtual override returns (uint256) {
355     return _balances[account];
356   }
357 
358   function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
359     _transfer(msg.sender, recipient, amount);
360     return true;
361   }
362 
363   function allowance(address owner, address spender)
364     public
365     view
366     virtual
367     override
368     returns (uint256)
369   {
370     return _allowances[owner][spender];
371   }
372 
373   function approve(address spender, uint256 amount) public virtual override returns (bool) {
374     _approve(msg.sender, spender, amount);
375     return true;
376   }
377 
378   function transferFrom(
379     address sender,
380     address recipient,
381     uint256 amount
382   ) public virtual override returns (bool) {
383     _transfer(sender, recipient, amount);
384     _approve(
385       sender,
386       msg.sender,
387       _allowances[sender][msg.sender].sub(amount, 'ERC20: transfer amount exceeds allowance')
388     );
389     return true;
390   }
391 
392   function increaseAllowance(address spender, uint256 addedValue)
393     public
394     virtual
395     returns (bool)
396   {
397     _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
398     return true;
399   }
400 
401   function decreaseAllowance(address spender, uint256 subtractedValue)
402     public
403     virtual
404     returns (bool)
405   {
406     _approve(
407       msg.sender,
408       spender,
409       _allowances[msg.sender][spender].sub(
410         subtractedValue,
411         'ERC20: decreased allowance below zero'
412       )
413     );
414     return true;
415   }
416 
417   function _transfer(
418     address sender,
419     address recipient,
420     uint256 amount
421   ) internal virtual {
422     require(sender != address(0), 'ERC20: transfer from the zero address');
423     require(recipient != address(0), 'ERC20: transfer to the zero address');
424 
425     _beforeTokenTransfer(sender, recipient, amount);
426 
427     _balances[sender] = _balances[sender].sub(amount, 'ERC20: transfer amount exceeds balance');
428     _balances[recipient] = _balances[recipient].add(amount);
429     emit Transfer(sender, recipient, amount);
430   }
431 
432   function _mint(address account_, uint256 ammount_) internal virtual {
433     require(account_ != address(0), 'ERC20: mint to the zero address');
434     _beforeTokenTransfer(address(this), account_, ammount_);
435     _totalSupply = _totalSupply.add(ammount_);
436     _balances[account_] = _balances[account_].add(ammount_);
437     emit Transfer(address(this), account_, ammount_);
438   }
439 
440   function _burn(address account, uint256 amount) internal virtual {
441     require(account != address(0), 'ERC20: burn from the zero address');
442 
443     _beforeTokenTransfer(account, address(0), amount);
444 
445     _balances[account] = _balances[account].sub(amount, 'ERC20: burn amount exceeds balance');
446     _totalSupply = _totalSupply.sub(amount);
447     emit Transfer(account, address(0), amount);
448   }
449 
450   function _approve(
451     address owner,
452     address spender,
453     uint256 amount
454   ) internal virtual {
455     require(owner != address(0), 'ERC20: approve from the zero address');
456     require(spender != address(0), 'ERC20: approve to the zero address');
457 
458     _allowances[owner][spender] = amount;
459     emit Approval(owner, spender, amount);
460   }
461 
462   function _beforeTokenTransfer(
463     address from_,
464     address to_,
465     uint256 amount_
466   ) internal virtual {}
467 }
468 
469 interface IERC2612Permit {
470   function permit(
471     address owner,
472     address spender,
473     uint256 amount,
474     uint256 deadline,
475     uint8 v,
476     bytes32 r,
477     bytes32 s
478   ) external;
479 
480   function nonces(address owner) external view returns (uint256);
481 }
482 
483 library Counters {
484   using SafeMath for uint256;
485 
486   struct Counter {
487     uint256 _value; // default: 0
488   }
489 
490   function current(Counter storage counter) internal view returns (uint256) {
491     return counter._value;
492   }
493 
494   function increment(Counter storage counter) internal {
495     counter._value += 1;
496   }
497 
498   function decrement(Counter storage counter) internal {
499     counter._value = counter._value.sub(1);
500   }
501 }
502 
503 abstract contract ERC20Permit is ERC20, IERC2612Permit {
504   using Counters for Counters.Counter;
505 
506   mapping(address => Counters.Counter) private _nonces;
507 
508   // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
509   bytes32 public constant PERMIT_TYPEHASH =
510     0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
511 
512   bytes32 public DOMAIN_SEPARATOR;
513 
514   constructor() {
515     uint256 chainID;
516     assembly {
517       chainID := chainid()
518     }
519 
520     DOMAIN_SEPARATOR = keccak256(
521       abi.encode(
522         keccak256(
523           'EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'
524         ),
525         keccak256(bytes(name())),
526         keccak256(bytes('1')), // Version
527         chainID,
528         address(this)
529       )
530     );
531   }
532 
533   function permit(
534     address owner,
535     address spender,
536     uint256 amount,
537     uint256 deadline,
538     uint8 v,
539     bytes32 r,
540     bytes32 s
541   ) public virtual override {
542     require(block.timestamp <= deadline, 'Permit: expired deadline');
543 
544     bytes32 hashStruct = keccak256(
545       abi.encode(PERMIT_TYPEHASH, owner, spender, amount, _nonces[owner].current(), deadline)
546     );
547 
548     bytes32 _hash = keccak256(abi.encodePacked(uint16(0x1901), DOMAIN_SEPARATOR, hashStruct));
549 
550     address signer = ecrecover(_hash, v, r, s);
551     require(signer != address(0) && signer == owner, 'ZeroSwapPermit: Invalid signature');
552 
553     _nonces[owner].increment();
554     _approve(owner, spender, amount);
555   }
556 
557   function nonces(address owner) public view override returns (uint256) {
558     return _nonces[owner].current();
559   }
560 }
561 
562 library SafeERC20 {
563   using SafeMath for uint256;
564   using Address for address;
565 
566   function safeTransfer(
567     IERC20 token,
568     address to,
569     uint256 value
570   ) internal {
571     _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
572   }
573 
574   function safeTransferFrom(
575     IERC20 token,
576     address from,
577     address to,
578     uint256 value
579   ) internal {
580     _callOptionalReturn(
581       token,
582       abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
583     );
584   }
585 
586   function safeApprove(
587     IERC20 token,
588     address spender,
589     uint256 value
590   ) internal {
591     require(
592       (value == 0) || (token.allowance(address(this), spender) == 0),
593       'SafeERC20: approve from non-zero to non-zero allowance'
594     );
595     _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
596   }
597 
598   function safeIncreaseAllowance(
599     IERC20 token,
600     address spender,
601     uint256 value
602   ) internal {
603     uint256 newAllowance = token.allowance(address(this), spender).add(value);
604     _callOptionalReturn(
605       token,
606       abi.encodeWithSelector(token.approve.selector, spender, newAllowance)
607     );
608   }
609 
610   function safeDecreaseAllowance(
611     IERC20 token,
612     address spender,
613     uint256 value
614   ) internal {
615     uint256 newAllowance = token.allowance(address(this), spender).sub(
616       value,
617       'SafeERC20: decreased allowance below zero'
618     );
619     _callOptionalReturn(
620       token,
621       abi.encodeWithSelector(token.approve.selector, spender, newAllowance)
622     );
623   }
624 
625   function _callOptionalReturn(IERC20 token, bytes memory data) private {
626     bytes memory returndata = address(token).functionCall(
627       data,
628       'SafeERC20: low-level call failed'
629     );
630     if (returndata.length > 0) {
631       // Return data is optional
632       // solhint-disable-next-line max-line-length
633       require(abi.decode(returndata, (bool)), 'SafeERC20: ERC20 operation did not succeed');
634     }
635   }
636 }
637 
638 library FullMath {
639   function fullMul(uint256 x, uint256 y) private pure returns (uint256 l, uint256 h) {
640     uint256 mm = mulmod(x, y, uint256(-1));
641     l = x * y;
642     h = mm - l;
643     if (mm < l) h -= 1;
644   }
645 
646   function fullDiv(
647     uint256 l,
648     uint256 h,
649     uint256 d
650   ) private pure returns (uint256) {
651     uint256 pow2 = d & -d;
652     d /= pow2;
653     l /= pow2;
654     l += h * ((-pow2) / pow2 + 1);
655     uint256 r = 1;
656     r *= 2 - d * r;
657     r *= 2 - d * r;
658     r *= 2 - d * r;
659     r *= 2 - d * r;
660     r *= 2 - d * r;
661     r *= 2 - d * r;
662     r *= 2 - d * r;
663     r *= 2 - d * r;
664     return l * r;
665   }
666 
667   function mulDiv(
668     uint256 x,
669     uint256 y,
670     uint256 d
671   ) internal pure returns (uint256) {
672     (uint256 l, uint256 h) = fullMul(x, y);
673     uint256 mm = mulmod(x, y, d);
674     if (mm > l) h -= 1;
675     l -= mm;
676     require(h < d, 'FullMath::mulDiv: overflow');
677     return fullDiv(l, h, d);
678   }
679 }
680 
681 library FixedPoint {
682   struct uq112x112 {
683     uint224 _x;
684   }
685 
686   struct uq144x112 {
687     uint256 _x;
688   }
689 
690   uint8 private constant RESOLUTION = 112;
691   uint256 private constant Q112 = 0x10000000000000000000000000000;
692   uint256 private constant Q224 = 0x100000000000000000000000000000000000000000000000000000000;
693   uint256 private constant LOWER_MASK = 0xffffffffffffffffffffffffffff; // decimal of UQ*x112 (lower 112 bits)
694 
695   function decode(uq112x112 memory self) internal pure returns (uint112) {
696     return uint112(self._x >> RESOLUTION);
697   }
698 
699   function decode112with18(uq112x112 memory self) internal pure returns (uint256) {
700     return uint256(self._x) / 5192296858534827;
701   }
702 
703   function fraction(uint256 numerator, uint256 denominator)
704     internal
705     pure
706     returns (uq112x112 memory)
707   {
708     require(denominator > 0, 'FixedPoint::fraction: division by zero');
709     if (numerator == 0) return FixedPoint.uq112x112(0);
710 
711     if (numerator <= uint144(-1)) {
712       uint256 result = (numerator << RESOLUTION) / denominator;
713       require(result <= uint224(-1), 'FixedPoint::fraction: overflow');
714       return uq112x112(uint224(result));
715     } else {
716       uint256 result = FullMath.mulDiv(numerator, Q112, denominator);
717       require(result <= uint224(-1), 'FixedPoint::fraction: overflow');
718       return uq112x112(uint224(result));
719     }
720   }
721 }
722 
723 interface ITreasury {
724   function deposit(
725     uint256 _amount,
726     address _token,
727     uint256 _profit
728   ) external returns (bool);
729 
730   function valueOf(address _token, uint256 _amount) external view returns (uint256 value_);
731 
732   function getFloor(address _token) external view returns (uint256);
733 
734   function mintRewards(address _recipient, uint256 _amount) external;
735 }
736 
737 interface IBondCalculator {
738   function valuation(address _LP, uint256 _amount) external view returns (uint256);
739 
740   function markdown(address _LP) external view returns (uint256);
741 }
742 
743 interface IStaking {
744   function stake(uint256 _amount, address _recipient) external returns (bool);
745 }
746 
747 interface IStakingHelper {
748   function stake(uint256 _amount, address _recipient) external;
749 }
750 
751 contract REDACTEDBondDepositoryRewardBased is Ownable {
752   using FixedPoint for *;
753   using SafeERC20 for IERC20;
754   using SafeMath for uint256;
755 
756   /* ======== EVENTS ======== */
757 
758   event BondCreated(
759     uint256 deposit,
760     uint256 indexed payout,
761     uint256 indexed expires,
762     uint256 indexed nativePrice
763   );
764   event BondRedeemed(address indexed recipient, uint256 payout, uint256 remaining);
765   event BondPriceChanged(
766     uint256 indexed nativePrice,
767     uint256 indexed internalPrice,
768     uint256 indexed debtRatio
769   );
770   event ControlVariableAdjustment(
771     uint256 initialBCV,
772     uint256 newBCV,
773     uint256 adjustment,
774     bool addition
775   );
776 
777   /* ======== STATE VARIABLES ======== */
778 
779   address public immutable BTRFLY; // token given as payment for bond
780   address public immutable principal; // token used to create bond
781   address public immutable OLYMPUSDAO; // we pay homage to these guys :) (tithe/ti-the hahahahhahah)
782   address public immutable treasury; // mints BTRFLY when receives principal
783   address public immutable DAO; // receives profit share from bond
784   address public OLYMPUSTreasury; // Olympus treasury can be updated by the OLYMPUSDAO
785 
786   bool public immutable isLiquidityBond; // LP and Reserve bonds are treated slightly different
787   address public immutable bondCalculator; // calculates value of LP tokens
788 
789   address public staking; // to auto-stake payout
790   address public stakingHelper; // to stake and claim if no staking warmup
791   bool public useHelper;
792 
793   Terms public terms; // stores terms for new bonds
794   Adjust public adjustment; // stores adjustment to BCV data
795 
796   mapping(address => Bond) public bondInfo; // stores bond information for depositors
797 
798   uint256 public totalDebt; // total value of outstanding bonds; used for pricing
799   uint256 public lastDecay; // reference block for debt decay
800 
801   /* ======== STRUCTS ======== */
802 
803   // Info for creating new bonds
804   struct Terms {
805     uint256 controlVariable; // scaling variable for price
806     uint256 vestingTerm; // in blocks
807     uint256 minimumPrice; // vs principal value
808     uint256 maxPayout; // in thousandths of a %. i.e. 500 = 0.5%
809     uint256 fee; // as % of bond payout, in hundreths. ( 500 = 5% = 0.05 for every 1 paid)
810     uint256 tithe; // in thousandths of a %. i.e. 500 = 0.5%
811     uint256 maxDebt; // 9 decimal debt ratio, max % total supply created as debt
812   }
813 
814   // Info for bond holder
815   struct Bond {
816     uint256 payout; // BTRFLY remaining to be paid
817     uint256 vesting; // Blocks left to vest
818     uint256 lastBlock; // Last interaction
819     uint256 pricePaid; // In native asset, for front end viewing
820   }
821 
822   // Info for incremental adjustments to control variable
823   struct Adjust {
824     bool add; // addition or subtraction
825     uint256 rate; // increment
826     uint256 target; // BCV when adjustment finished
827     uint256 buffer; // minimum length (in blocks) between adjustments
828     uint256 lastBlock; // block when last adjustment made
829   }
830 
831   /* ======== INITIALIZATION ======== */
832 
833   constructor(
834     address _BTRFLY,
835     address _principal,
836     address _treasury,
837     address _DAO,
838     address _bondCalculator,
839     address _OLYMPUSDAO,
840     address _OLYMPUSTreasury
841   ) {
842     require(_BTRFLY != address(0));
843     BTRFLY = _BTRFLY;
844     require(_principal != address(0));
845     principal = _principal;
846     require(_treasury != address(0));
847     treasury = _treasury;
848     require(_DAO != address(0));
849     DAO = _DAO;
850     // bondCalculator should be address(0) if not LP bond
851     bondCalculator = _bondCalculator;
852     isLiquidityBond = (_bondCalculator != address(0));
853     OLYMPUSDAO = _OLYMPUSDAO;
854     OLYMPUSTreasury = _OLYMPUSTreasury;
855   }
856 
857   /**
858    *  @notice initializes bond parameters
859    *  @param _controlVariable uint
860    *  @param _vestingTerm uint
861    *  @param _minimumPrice uint
862    *  @param _maxPayout uint
863    *  @param _fee uint
864    *  @param _maxDebt uint
865    *  @param _initialDebt uint
866    */
867   function initializeBondTerms(
868     uint256 _controlVariable,
869     uint256 _vestingTerm,
870     uint256 _minimumPrice,
871     uint256 _maxPayout,
872     uint256 _fee,
873     uint256 _maxDebt,
874     uint256 _tithe,
875     uint256 _initialDebt
876   ) external onlyPolicy {
877     require(terms.controlVariable == 0, 'Bonds must be initialized from 0');
878     terms = Terms({
879       controlVariable: _controlVariable,
880       vestingTerm: _vestingTerm,
881       minimumPrice: _minimumPrice,
882       maxPayout: _maxPayout,
883       fee: _fee,
884       maxDebt: _maxDebt,
885       tithe: _tithe
886     });
887     totalDebt = _initialDebt;
888     lastDecay = block.number;
889   }
890 
891   /* ======== POLICY FUNCTIONS ======== */
892 
893   enum PARAMETER {
894     VESTING,
895     PAYOUT,
896     FEE,
897     DEBT
898   }
899 
900   /**
901    *  @notice set parameters for new bonds
902    *  @param _parameter PARAMETER
903    *  @param _input uint
904    */
905   function setBondTerms(PARAMETER _parameter, uint256 _input) external onlyPolicy {
906     if (_parameter == PARAMETER.VESTING) {
907       // 0
908       require(_input >= 10000, 'Vesting must be longer than 36 hours');
909       terms.vestingTerm = _input;
910     } else if (_parameter == PARAMETER.PAYOUT) {
911       // 1
912       require(_input <= 1000, 'Payout cannot be above 1 percent');
913       terms.maxPayout = _input;
914     } else if (_parameter == PARAMETER.FEE) {
915       // 2
916       require(_input <= 10000, 'DAO fee cannot exceed payout');
917       terms.fee = _input;
918     } else if (_parameter == PARAMETER.DEBT) {
919       // 3
920       terms.maxDebt = _input;
921     }
922   }
923 
924   /**
925    *  @notice set control variable adjustment
926    *  @param _addition bool
927    *  @param _increment uint
928    *  @param _target uint
929    *  @param _buffer uint
930    */
931   function setAdjustment(
932     bool _addition,
933     uint256 _increment,
934     uint256 _target,
935     uint256 _buffer
936   ) external onlyPolicy {
937     require(_increment <= terms.controlVariable.mul(25).div(1000), 'Increment too large');
938 
939     adjustment = Adjust({
940       add: _addition,
941       rate: _increment,
942       target: _target,
943       buffer: _buffer,
944       lastBlock: block.number
945     });
946   }
947 
948   /**
949    *  @notice set contract for auto stake
950    *  @param _staking address
951    *  @param _helper bool
952    */
953   function setStaking(address _staking, bool _helper) external onlyPolicy {
954     require(_staking != address(0));
955     if (_helper) {
956       useHelper = true;
957       stakingHelper = _staking;
958     } else {
959       useHelper = false;
960       staking = _staking;
961     }
962   }
963 
964   /* ======== USER FUNCTIONS ======== */
965 
966   /**
967    *  @notice deposit bond
968    *  @param _amount uint
969    *  @param _maxPrice uint
970    *  @param _depositor address
971    *  @return uint
972    */
973   function deposit(
974     uint256 _amount,
975     uint256 _maxPrice,
976     address _depositor
977   ) external returns (uint256) {
978     require(_depositor != address(0), 'Invalid address');
979 
980     decayDebt();
981     require(totalDebt <= terms.maxDebt, 'Max capacity reached');
982 
983     uint256 nativePrice = _bondPrice();
984 
985     require(_maxPrice >= nativePrice, 'Slippage limit: more than max price'); // slippage protection
986 
987     uint256 tithePrincipal = _amount.mul(terms.tithe).div(100000);
988 
989     uint256 value = ITreasury(treasury).valueOf(principal, _amount);
990     uint256 payout = payoutFor(value); // payout to bonder is computed
991 
992     require(payout >= 10000000, 'Bond too small'); // must be > 0.01 BTRFLY ( underflow protection )
993     require(payout <= maxPayout(), 'Bond too large'); // size protection because there is no slippage
994 
995     /**
996             principal is transferred in
997             approved and
998             deposited into the treasury, returning (_amount - profit) BTRFLY
999          */
1000     IERC20(principal).safeTransferFrom(msg.sender, address(this), _amount);
1001     IERC20(principal).safeTransfer(OLYMPUSTreasury, tithePrincipal);
1002 
1003     uint256 amountDeposit = _amount.sub(tithePrincipal);
1004     IERC20(principal).safeTransfer(address(treasury), amountDeposit);
1005 
1006     //call mintRewards
1007     uint256 titheBTRFLY = payout.mul(terms.tithe).div(100000);
1008     uint256 fee = payout.mul(terms.fee).div(100000);
1009     uint256 totalMint = titheBTRFLY.add(fee).add(payout);
1010 
1011     ITreasury(treasury).mintRewards(address(this), totalMint);
1012 
1013     // fee is transferred to daos
1014     IERC20(BTRFLY).safeTransfer(DAO, fee);
1015     IERC20(BTRFLY).safeTransfer(OLYMPUSTreasury, titheBTRFLY);
1016 
1017     // total debt is increased
1018     totalDebt = totalDebt.add(value);
1019 
1020     // depositor info is stored
1021     bondInfo[_depositor] = Bond({
1022       payout: bondInfo[_depositor].payout.add(payout),
1023       vesting: terms.vestingTerm,
1024       lastBlock: block.number,
1025       pricePaid: nativePrice
1026     });
1027 
1028     // indexed events are emitted
1029     emit BondCreated(_amount, payout, block.number.add(terms.vestingTerm), nativePrice);
1030     //emit BondPriceChanged( bondPriceInUSD(), _bondPrice(), debtRatio() );
1031 
1032     adjust(); // control variable is adjusted
1033     return payout;
1034   }
1035 
1036   /**
1037    *  @notice redeem bond for user
1038    *  @param _recipient address
1039    *  @param _stake bool
1040    *  @return uint
1041    */
1042   function redeem(address _recipient, bool _stake) external returns (uint256) {
1043     Bond memory info = bondInfo[_recipient];
1044     uint256 percentVested = percentVestedFor(_recipient); // (blocks since last interaction / vesting term remaining)
1045 
1046     if (percentVested >= 10000) {
1047       // if fully vested
1048       delete bondInfo[_recipient]; // delete user info
1049       emit BondRedeemed(_recipient, info.payout, 0); // emit bond data
1050       return stakeOrSend(_recipient, _stake, info.payout); // pay user everything due
1051     } else {
1052       // if unfinished
1053       // calculate payout vested
1054       uint256 payout = info.payout.mul(percentVested).div(10000);
1055 
1056       // store updated deposit info
1057       bondInfo[_recipient] = Bond({
1058         payout: info.payout.sub(payout),
1059         vesting: info.vesting.sub(block.number.sub(info.lastBlock)),
1060         lastBlock: block.number,
1061         pricePaid: info.pricePaid
1062       });
1063 
1064       emit BondRedeemed(_recipient, payout, bondInfo[_recipient].payout);
1065       return stakeOrSend(_recipient, _stake, payout);
1066     }
1067   }
1068 
1069   /* ======== INTERNAL HELPER FUNCTIONS ======== */
1070 
1071   /**
1072    *  @notice allow user to stake payout automatically
1073    *  @param _stake bool
1074    *  @param _amount uint
1075    *  @return uint
1076    */
1077   function stakeOrSend(
1078     address _recipient,
1079     bool _stake,
1080     uint256 _amount
1081   ) internal returns (uint256) {
1082     if (!_stake) {
1083       // if user does not want to stake
1084       IERC20(BTRFLY).transfer(_recipient, _amount); // send payout
1085     } else {
1086       // if user wants to stake
1087       if (useHelper) {
1088         // use if staking warmup is 0
1089         IERC20(BTRFLY).approve(stakingHelper, _amount);
1090         IStakingHelper(stakingHelper).stake(_amount, _recipient);
1091       } else {
1092         IERC20(BTRFLY).approve(staking, _amount);
1093         IStaking(staking).stake(_amount, _recipient);
1094       }
1095     }
1096     return _amount;
1097   }
1098 
1099   /**
1100    *  @notice makes incremental adjustment to control variable
1101    */
1102   function adjust() internal {
1103     uint256 blockCanAdjust = adjustment.lastBlock.add(adjustment.buffer);
1104     if (adjustment.rate != 0 && block.number >= blockCanAdjust) {
1105       uint256 initial = terms.controlVariable;
1106       if (adjustment.add) {
1107         terms.controlVariable = terms.controlVariable.add(adjustment.rate);
1108         if (terms.controlVariable >= adjustment.target) {
1109           adjustment.rate = 0;
1110         }
1111       } else {
1112         terms.controlVariable = terms.controlVariable.sub(adjustment.rate);
1113         if (terms.controlVariable <= adjustment.target) {
1114           adjustment.rate = 0;
1115         }
1116       }
1117       adjustment.lastBlock = block.number;
1118       emit ControlVariableAdjustment(
1119         initial,
1120         terms.controlVariable,
1121         adjustment.rate,
1122         adjustment.add
1123       );
1124     }
1125   }
1126 
1127   /**
1128    *  @notice reduce total debt
1129    */
1130   function decayDebt() internal {
1131     totalDebt = totalDebt.sub(debtDecay());
1132     lastDecay = block.number;
1133   }
1134 
1135   /* ======== VIEW FUNCTIONS ======== */
1136 
1137   /**
1138    *  @notice determine maximum bond size
1139    *  @return uint
1140    */
1141   function maxPayout() public view returns (uint256) {
1142     return IERC20(BTRFLY).totalSupply().mul(terms.maxPayout).div(100000);
1143   }
1144 
1145   /**
1146    *  @notice calculate interest due for new bond
1147    *  @param _value uint
1148    *  @return uint
1149    */
1150   function payoutFor(uint256 _value) public view returns (uint256) {
1151     return FixedPoint.fraction(_value, bondPrice()).decode112with18().div(1e16);
1152   }
1153 
1154   /**
1155    *  @notice calculate current bond premium
1156    *  @return price_ uint
1157    */
1158   function bondPrice() public view returns (uint256 price_) {
1159     price_ = terms
1160       .controlVariable
1161       .mul(debtRatio())
1162       .add(ITreasury(treasury).getFloor(principal))
1163       .div(1e7);
1164     if (price_ < terms.minimumPrice) {
1165       price_ = terms.minimumPrice;
1166     }
1167   }
1168 
1169   /**
1170    *  @notice calculate current bond price and remove floor if above
1171    *  @return price_ uint
1172    */
1173   function _bondPrice() internal returns (uint256 price_) {
1174     price_ = terms
1175       .controlVariable
1176       .mul(debtRatio())
1177       .add(ITreasury(treasury).getFloor(principal))
1178       .div(1e7);
1179     if (price_ < terms.minimumPrice) {
1180       price_ = terms.minimumPrice;
1181     } else if (terms.minimumPrice != 0) {
1182       terms.minimumPrice = 0;
1183     }
1184   }
1185 
1186   /**
1187    *  @notice converts bond price to DAI value
1188    *  @return price_ uint
1189    */
1190   function bondPriceInUSD() public view returns (uint256 price_) {
1191     if (isLiquidityBond) {
1192       price_ = bondPrice().mul(IBondCalculator(bondCalculator).markdown(principal)).div(100);
1193     } else {
1194       price_ = bondPrice().mul(10**IERC20(principal).decimals()).div(100);
1195     }
1196   }
1197 
1198   /**
1199    *  @notice calculate current ratio of debt to BTRFLY supply
1200    *  @return debtRatio_ uint
1201    */
1202   function debtRatio() public view returns (uint256 debtRatio_) {
1203     uint256 supply = IERC20(BTRFLY).totalSupply();
1204     debtRatio_ = FixedPoint.fraction(currentDebt().mul(1e9), supply).decode112with18().div(
1205       1e18
1206     );
1207   }
1208 
1209   /**
1210    *  @notice debt ratio in same terms for reserve or liquidity bonds
1211    *  @return uint
1212    */
1213   function standardizedDebtRatio() external view returns (uint256) {
1214     if (isLiquidityBond) {
1215       return debtRatio().mul(IBondCalculator(bondCalculator).markdown(principal)).div(1e9);
1216     } else {
1217       return debtRatio();
1218     }
1219   }
1220 
1221   /**
1222    *  @notice calculate debt factoring in decay
1223    *  @return uint
1224    */
1225   function currentDebt() public view returns (uint256) {
1226     return totalDebt.sub(debtDecay());
1227   }
1228 
1229   /**
1230    *  @notice amount to decay total debt by
1231    *  @return decay_ uint
1232    */
1233   function debtDecay() public view returns (uint256 decay_) {
1234     uint256 blocksSinceLast = block.number.sub(lastDecay);
1235     decay_ = totalDebt.mul(blocksSinceLast).div(terms.vestingTerm);
1236     if (decay_ > totalDebt) {
1237       decay_ = totalDebt;
1238     }
1239   }
1240 
1241   /**
1242    *  @notice calculate how far into vesting a depositor is
1243    *  @param _depositor address
1244    *  @return percentVested_ uint
1245    */
1246   function percentVestedFor(address _depositor) public view returns (uint256 percentVested_) {
1247     Bond memory bond = bondInfo[_depositor];
1248     uint256 blocksSinceLast = block.number.sub(bond.lastBlock);
1249     uint256 vesting = bond.vesting;
1250 
1251     if (vesting > 0) {
1252       percentVested_ = blocksSinceLast.mul(10000).div(vesting);
1253     } else {
1254       percentVested_ = 0;
1255     }
1256   }
1257 
1258   /**
1259    *  @notice calculate amount of BTRFLY available for claim by depositor
1260    *  @param _depositor address
1261    *  @return pendingPayout_ uint
1262    */
1263   function pendingPayoutFor(address _depositor) external view returns (uint256 pendingPayout_) {
1264     uint256 percentVested = percentVestedFor(_depositor);
1265     uint256 payout = bondInfo[_depositor].payout;
1266 
1267     if (percentVested >= 10000) {
1268       pendingPayout_ = payout;
1269     } else {
1270       pendingPayout_ = payout.mul(percentVested).div(10000);
1271     }
1272   }
1273 
1274   /* ======= AUXILLIARY ======= */
1275 
1276   /**
1277    *  @notice allow anyone to send lost tokens (excluding principal or BTRFLY) to the DAO
1278    *  @return bool
1279    */
1280   function recoverLostToken(address _token) external returns (bool) {
1281     require(_token != BTRFLY);
1282     require(_token != principal);
1283     IERC20(_token).safeTransfer(DAO, IERC20(_token).balanceOf(address(this)));
1284     return true;
1285   }
1286 
1287   function setOLYMPUSTreasury(address _newTreasury) external {
1288     require(
1289       msg.sender == OLYMPUSDAO || msg.sender == DAO,
1290       "UNAUTHORISED : YOU'RE NOT OLYMPUS OR REDACTED"
1291     );
1292     OLYMPUSTreasury = _newTreasury;
1293   }
1294 }