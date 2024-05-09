1 /**
2  *Submitted for verification at Etherscan.io on 2021-10-21
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-10-03
7 */
8 
9 // SPDX-License-Identifier: AGPL-3.0-or-later
10 pragma solidity 0.7.5;
11 
12 // Contract logic @ line 607
13 
14 interface IOwnable {
15   function policy() external view returns (address);
16 
17   function renounceManagement() external;
18   
19   function pushManagement( address newOwner_ ) external;
20   
21   function pullManagement() external;
22 }
23 
24 contract Ownable is IOwnable {
25 
26     address internal _owner;
27     address internal _newOwner;
28 
29     event OwnershipPushed(address indexed previousOwner, address indexed newOwner);
30     event OwnershipPulled(address indexed previousOwner, address indexed newOwner);
31 
32     constructor () {
33         _owner = msg.sender;
34         emit OwnershipPushed( address(0), _owner );
35     }
36 
37     function policy() public view override returns (address) {
38         return _owner;
39     }
40 
41     modifier onlyPolicy() {
42         require( _owner == msg.sender, "Ownable: caller is not the owner" );
43         _;
44     }
45 
46     function renounceManagement() public virtual override onlyPolicy() {
47         emit OwnershipPushed( _owner, address(0) );
48         _owner = address(0);
49     }
50 
51     function pushManagement( address newOwner_ ) public virtual override onlyPolicy() {
52         require( newOwner_ != address(0), "Ownable: new owner is the zero address");
53         emit OwnershipPushed( _owner, newOwner_ );
54         _newOwner = newOwner_;
55     }
56     
57     function pullManagement() public virtual override {
58         require( msg.sender == _newOwner, "Ownable: must be new owner to pull");
59         emit OwnershipPulled( _owner, _newOwner );
60         _owner = _newOwner;
61     }
62 }
63 
64 library SafeMath {
65 
66     function add(uint256 a, uint256 b) internal pure returns (uint256) {
67         uint256 c = a + b;
68         require(c >= a, "SafeMath: addition overflow");
69 
70         return c;
71     }
72 
73     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74         return sub(a, b, "SafeMath: subtraction overflow");
75     }
76 
77     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
78         require(b <= a, errorMessage);
79         uint256 c = a - b;
80 
81         return c;
82     }
83 
84     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
85         if (a == 0) {
86             return 0;
87         }
88 
89         uint256 c = a * b;
90         require(c / a == b, "SafeMath: multiplication overflow");
91 
92         return c;
93     }
94 
95     function div(uint256 a, uint256 b) internal pure returns (uint256) {
96         return div(a, b, "SafeMath: division by zero");
97     }
98 
99     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
100         require(b > 0, errorMessage);
101         uint256 c = a / b;
102         return c;
103     }
104 
105     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
106         return mod(a, b, "SafeMath: modulo by zero");
107     }
108 
109     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
110         require(b != 0, errorMessage);
111         return a % b;
112     }
113 
114     function sqrrt(uint256 a) internal pure returns (uint c) {
115         if (a > 3) {
116             c = a;
117             uint b = add( div( a, 2), 1 );
118             while (b < c) {
119                 c = b;
120                 b = div( add( div( a, b ), b), 2 );
121             }
122         } else if (a != 0) {
123             c = 1;
124         }
125     }
126 }
127 
128 library Address {
129 
130     function isContract(address account) internal view returns (bool) {
131 
132         uint256 size;
133         // solhint-disable-next-line no-inline-assembly
134         assembly { size := extcodesize(account) }
135         return size > 0;
136     }
137 
138     function sendValue(address payable recipient, uint256 amount) internal {
139         require(address(this).balance >= amount, "Address: insufficient balance");
140 
141         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
142         (bool success, ) = recipient.call{ value: amount }("");
143         require(success, "Address: unable to send value, recipient may have reverted");
144     }
145 
146     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
147       return functionCall(target, data, "Address: low-level call failed");
148     }
149 
150     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
151         return _functionCallWithValue(target, data, 0, errorMessage);
152     }
153 
154     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
155         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
156     }
157 
158     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
159         require(address(this).balance >= value, "Address: insufficient balance for call");
160         require(isContract(target), "Address: call to non-contract");
161 
162         // solhint-disable-next-line avoid-low-level-calls
163         (bool success, bytes memory returndata) = target.call{ value: value }(data);
164         return _verifyCallResult(success, returndata, errorMessage);
165     }
166 
167     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
168         require(isContract(target), "Address: call to non-contract");
169 
170         // solhint-disable-next-line avoid-low-level-calls
171         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
172         if (success) {
173             return returndata;
174         } else {
175             // Look for revert reason and bubble it up if present
176             if (returndata.length > 0) {
177                 // The easiest way to bubble the revert reason is using memory via assembly
178 
179                 // solhint-disable-next-line no-inline-assembly
180                 assembly {
181                     let returndata_size := mload(returndata)
182                     revert(add(32, returndata), returndata_size)
183                 }
184             } else {
185                 revert(errorMessage);
186             }
187         }
188     }
189 
190     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
191         return functionStaticCall(target, data, "Address: low-level static call failed");
192     }
193 
194     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
195         require(isContract(target), "Address: static call to non-contract");
196 
197         // solhint-disable-next-line avoid-low-level-calls
198         (bool success, bytes memory returndata) = target.staticcall(data);
199         return _verifyCallResult(success, returndata, errorMessage);
200     }
201 
202     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
203         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
204     }
205 
206     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
207         require(isContract(target), "Address: delegate call to non-contract");
208 
209         // solhint-disable-next-line avoid-low-level-calls
210         (bool success, bytes memory returndata) = target.delegatecall(data);
211         return _verifyCallResult(success, returndata, errorMessage);
212     }
213 
214     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
215         if (success) {
216             return returndata;
217         } else {
218             if (returndata.length > 0) {
219 
220                 assembly {
221                     let returndata_size := mload(returndata)
222                     revert(add(32, returndata), returndata_size)
223                 }
224             } else {
225                 revert(errorMessage);
226             }
227         }
228     }
229 
230     function addressToString(address _address) internal pure returns(string memory) {
231         bytes32 _bytes = bytes32(uint256(_address));
232         bytes memory HEX = "0123456789abcdef";
233         bytes memory _addr = new bytes(42);
234 
235         _addr[0] = '0';
236         _addr[1] = 'x';
237 
238         for(uint256 i = 0; i < 20; i++) {
239             _addr[2+i*2] = HEX[uint8(_bytes[i + 12] >> 4)];
240             _addr[3+i*2] = HEX[uint8(_bytes[i + 12] & 0x0f)];
241         }
242 
243         return string(_addr);
244 
245     }
246 }
247 
248 interface IERC20 {
249     function decimals() external view returns (uint8);
250 
251     function totalSupply() external view returns (uint256);
252 
253     function balanceOf(address account) external view returns (uint256);
254 
255     function transfer(address recipient, uint256 amount) external returns (bool);
256 
257     function allowance(address owner, address spender) external view returns (uint256);
258 
259     function approve(address spender, uint256 amount) external returns (bool);
260 
261     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
262 
263     event Transfer(address indexed from, address indexed to, uint256 value);
264 
265     event Approval(address indexed owner, address indexed spender, uint256 value);
266 }
267 
268 abstract contract ERC20 is IERC20 {
269 
270     using SafeMath for uint256;
271 
272     // TODO comment actual hash value.
273     bytes32 constant private ERC20TOKEN_ERC1820_INTERFACE_ID = keccak256( "ERC20Token" );
274     
275     mapping (address => uint256) internal _balances;
276 
277     mapping (address => mapping (address => uint256)) internal _allowances;
278 
279     uint256 internal _totalSupply;
280 
281     string internal _name;
282     
283     string internal _symbol;
284     
285     uint8 internal _decimals;
286 
287     constructor (string memory name_, string memory symbol_, uint8 decimals_) {
288         _name = name_;
289         _symbol = symbol_;
290         _decimals = decimals_;
291     }
292 
293     function name() public view returns (string memory) {
294         return _name;
295     }
296 
297     function symbol() public view returns (string memory) {
298         return _symbol;
299     }
300 
301     function decimals() public view override returns (uint8) {
302         return _decimals;
303     }
304 
305     function totalSupply() public view override returns (uint256) {
306         return _totalSupply;
307     }
308 
309     function balanceOf(address account) public view virtual override returns (uint256) {
310         return _balances[account];
311     }
312 
313     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
314         _transfer(msg.sender, recipient, amount);
315         return true;
316     }
317 
318     function allowance(address owner, address spender) public view virtual override returns (uint256) {
319         return _allowances[owner][spender];
320     }
321 
322     function approve(address spender, uint256 amount) public virtual override returns (bool) {
323         _approve(msg.sender, spender, amount);
324         return true;
325     }
326 
327     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
328         _transfer(sender, recipient, amount);
329         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
330         return true;
331     }
332 
333     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
334         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
335         return true;
336     }
337 
338     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
339         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
340         return true;
341     }
342 
343     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
344         require(sender != address(0), "ERC20: transfer from the zero address");
345         require(recipient != address(0), "ERC20: transfer to the zero address");
346 
347         _beforeTokenTransfer(sender, recipient, amount);
348 
349         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
350         _balances[recipient] = _balances[recipient].add(amount);
351         emit Transfer(sender, recipient, amount);
352     }
353 
354     function _mint(address account_, uint256 ammount_) internal virtual {
355         require(account_ != address(0), "ERC20: mint to the zero address");
356         _beforeTokenTransfer(address( this ), account_, ammount_);
357         _totalSupply = _totalSupply.add(ammount_);
358         _balances[account_] = _balances[account_].add(ammount_);
359         emit Transfer(address( this ), account_, ammount_);
360     }
361 
362     function _burn(address account, uint256 amount) internal virtual {
363         require(account != address(0), "ERC20: burn from the zero address");
364 
365         _beforeTokenTransfer(account, address(0), amount);
366 
367         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
368         _totalSupply = _totalSupply.sub(amount);
369         emit Transfer(account, address(0), amount);
370     }
371 
372     function _approve(address owner, address spender, uint256 amount) internal virtual {
373         require(owner != address(0), "ERC20: approve from the zero address");
374         require(spender != address(0), "ERC20: approve to the zero address");
375 
376         _allowances[owner][spender] = amount;
377         emit Approval(owner, spender, amount);
378     }
379 
380   function _beforeTokenTransfer( address from_, address to_, uint256 amount_ ) internal virtual { }
381 }
382 
383 interface IERC2612Permit {
384 
385     function permit(
386         address owner,
387         address spender,
388         uint256 amount,
389         uint256 deadline,
390         uint8 v,
391         bytes32 r,
392         bytes32 s
393     ) external;
394 
395     function nonces(address owner) external view returns (uint256);
396 }
397 
398 library Counters {
399     using SafeMath for uint256;
400 
401     struct Counter {
402 
403         uint256 _value; // default: 0
404     }
405 
406     function current(Counter storage counter) internal view returns (uint256) {
407         return counter._value;
408     }
409 
410     function increment(Counter storage counter) internal {
411         counter._value += 1;
412     }
413 
414     function decrement(Counter storage counter) internal {
415         counter._value = counter._value.sub(1);
416     }
417 }
418 
419 abstract contract ERC20Permit is ERC20, IERC2612Permit {
420     using Counters for Counters.Counter;
421 
422     mapping(address => Counters.Counter) private _nonces;
423 
424     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
425     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
426 
427     bytes32 public DOMAIN_SEPARATOR;
428 
429     constructor() {
430         uint256 chainID;
431         assembly {
432             chainID := chainid()
433         }
434 
435         DOMAIN_SEPARATOR = keccak256(
436             abi.encode(
437                 keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
438                 keccak256(bytes(name())),
439                 keccak256(bytes("1")), // Version
440                 chainID,
441                 address(this)
442             )
443         );
444     }
445 
446     function permit(
447         address owner,
448         address spender,
449         uint256 amount,
450         uint256 deadline,
451         uint8 v,
452         bytes32 r,
453         bytes32 s
454     ) public virtual override {
455         require(block.timestamp <= deadline, "Permit: expired deadline");
456 
457         bytes32 hashStruct =
458             keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, amount, _nonces[owner].current(), deadline));
459 
460         bytes32 _hash = keccak256(abi.encodePacked(uint16(0x1901), DOMAIN_SEPARATOR, hashStruct));
461 
462         address signer = ecrecover(_hash, v, r, s);
463         require(signer != address(0) && signer == owner, "ZeroSwapPermit: Invalid signature");
464 
465         _nonces[owner].increment();
466         _approve(owner, spender, amount);
467     }
468 
469     function nonces(address owner) public view override returns (uint256) {
470         return _nonces[owner].current();
471     }
472 }
473 
474 library SafeERC20 {
475     using SafeMath for uint256;
476     using Address for address;
477 
478     function safeTransfer(IERC20 token, address to, uint256 value) internal {
479         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
480     }
481 
482     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
483         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
484     }
485 
486     function safeApprove(IERC20 token, address spender, uint256 value) internal {
487 
488         require((value == 0) || (token.allowance(address(this), spender) == 0),
489             "SafeERC20: approve from non-zero to non-zero allowance"
490         );
491         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
492     }
493 
494     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
495         uint256 newAllowance = token.allowance(address(this), spender).add(value);
496         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
497     }
498 
499     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
500         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
501         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
502     }
503 
504     function _callOptionalReturn(IERC20 token, bytes memory data) private {
505 
506         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
507         if (returndata.length > 0) { // Return data is optional
508             // solhint-disable-next-line max-line-length
509             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
510         }
511     }
512 }
513 
514 library FullMath {
515     function fullMul(uint256 x, uint256 y) private pure returns (uint256 l, uint256 h) {
516         uint256 mm = mulmod(x, y, uint256(-1));
517         l = x * y;
518         h = mm - l;
519         if (mm < l) h -= 1;
520     }
521 
522     function fullDiv(
523         uint256 l,
524         uint256 h,
525         uint256 d
526     ) private pure returns (uint256) {
527         uint256 pow2 = d & -d;
528         d /= pow2;
529         l /= pow2;
530         l += h * ((-pow2) / pow2 + 1);
531         uint256 r = 1;
532         r *= 2 - d * r;
533         r *= 2 - d * r;
534         r *= 2 - d * r;
535         r *= 2 - d * r;
536         r *= 2 - d * r;
537         r *= 2 - d * r;
538         r *= 2 - d * r;
539         r *= 2 - d * r;
540         return l * r;
541     }
542 
543     function mulDiv(
544         uint256 x,
545         uint256 y,
546         uint256 d
547     ) internal pure returns (uint256) {
548         (uint256 l, uint256 h) = fullMul(x, y);
549         uint256 mm = mulmod(x, y, d);
550         if (mm > l) h -= 1;
551         l -= mm;
552         require(h < d, 'FullMath::mulDiv: overflow');
553         return fullDiv(l, h, d);
554     }
555 }
556 
557 library FixedPoint {
558 
559     struct uq112x112 {
560         uint224 _x;
561     }
562 
563     struct uq144x112 {
564         uint256 _x;
565     }
566 
567     uint8 private constant RESOLUTION = 112;
568     uint256 private constant Q112 = 0x10000000000000000000000000000;
569     uint256 private constant Q224 = 0x100000000000000000000000000000000000000000000000000000000;
570     uint256 private constant LOWER_MASK = 0xffffffffffffffffffffffffffff; // decimal of UQ*x112 (lower 112 bits)
571 
572     function decode(uq112x112 memory self) internal pure returns (uint112) {
573         return uint112(self._x >> RESOLUTION);
574     }
575 
576     function decode112with18(uq112x112 memory self) internal pure returns (uint) {
577 
578         return uint(self._x) / 5192296858534827;
579     }
580 
581     function fraction(uint256 numerator, uint256 denominator) internal pure returns (uq112x112 memory) {
582         require(denominator > 0, 'FixedPoint::fraction: division by zero');
583         if (numerator == 0) return FixedPoint.uq112x112(0);
584 
585         if (numerator <= uint144(-1)) {
586             uint256 result = (numerator << RESOLUTION) / denominator;
587             require(result <= uint224(-1), 'FixedPoint::fraction: overflow');
588             return uq112x112(uint224(result));
589         } else {
590             uint256 result = FullMath.mulDiv(numerator, Q112, denominator);
591             require(result <= uint224(-1), 'FixedPoint::fraction: overflow');
592             return uq112x112(uint224(result));
593         }
594     }
595 }
596 
597 interface ITreasury {
598     function deposit( uint _amount, address _token, uint _profit ) external returns ( bool );
599     function valueOf( address _token, uint _amount ) external view returns ( uint value_ );
600     function mintRewards( address _to, uint _amount ) external;
601 }
602 
603 interface IBondCalculator {
604     function valuation( address _LP, uint _amount ) external view returns ( uint );
605     function markdown( address _LP ) external view returns ( uint );
606 }
607 
608 interface IStaking {
609     function stake( uint _amount, address _recipient ) external returns ( bool );
610 }
611 
612 interface IStakingHelper {
613     function stake( uint _amount, address _recipient ) external;
614 }
615 
616 interface AggregatorV3Interface {
617 
618   function decimals() external view returns (uint8);
619   function description() external view returns (string memory);
620   function version() external view returns (uint256);
621 
622   // getRoundData and latestRoundData should both raise "No data present"
623   // if they do not have data to report, instead of returning unset values
624   // which could be misinterpreted as actual reported values.
625   function getRoundData(uint80 _roundId)
626     external
627     view
628     returns (
629       uint80 roundId,
630       int256 answer,
631       uint256 startedAt,
632       uint256 updatedAt,
633       uint80 answeredInRound
634     );
635   function latestRoundData()
636     external
637     view
638     returns (
639       uint80 roundId,
640       int256 answer,
641       uint256 startedAt,
642       uint256 updatedAt,
643       uint80 answeredInRound
644     );
645 }
646 
647 contract OlympusBondDepository is Ownable {
648 
649     using FixedPoint for *;
650     using SafeERC20 for IERC20;
651     using SafeMath for uint;
652 
653 
654 
655 
656     /* ======== EVENTS ======== */
657 
658     event BondCreated( uint deposit, uint indexed payout, uint indexed expires, uint indexed priceInUSD );
659     event BondRedeemed( address indexed recipient, uint payout, uint remaining );
660     event BondPriceChanged( uint indexed priceInUSD, uint indexed internalPrice, uint indexed debtRatio );
661     event ControlVariableAdjustment( uint initialBCV, uint newBCV, uint adjustment, bool addition );
662 
663 
664 
665 
666     /* ======== STATE VARIABLES ======== */
667 
668     address public immutable OHM; // token given as payment for bond
669     address public immutable principle; // token used to create bond
670     address public immutable treasury; // mints OHM when receives principle
671 
672     address public immutable bondCalculator; // calculates value of LP tokens
673     
674     AggregatorV3Interface internal priceFeed;
675 
676     address public staking; // to auto-stake payout
677     address public stakingHelper; // to stake and claim if no staking warmup
678     bool public useHelper;
679 
680     Terms public terms; // stores terms for new bonds
681     Adjust public adjustment; // stores adjustment to BCV data
682 
683     mapping( address => Bond ) public bondInfo; // stores bond information for depositors
684 
685     uint public totalDebt; // total value of outstanding bonds; used for pricing
686     uint public lastDecay; // reference block for debt decay
687 
688 
689 
690 
691     /* ======== STRUCTS ======== */
692 
693     // Info for creating new bonds
694     struct Terms {
695         uint controlVariable; // scaling variable for price
696         uint vestingTerm; // in blocks
697         uint minimumPrice; // vs principle value
698         uint maxPayout; // in thousandths of a %. i.e. 500 = 0.5%
699         uint maxDebt; // 9 decimal debt ratio, max % total supply created as debt
700     }
701 
702     // Info for bond holder
703     struct Bond {
704         uint payout; // OHM remaining to be paid
705         uint vesting; // Blocks left to vest
706         uint lastBlock; // Last interaction
707         uint pricePaid; // In DAI, for front end viewing
708     }
709 
710     // Info for incremental adjustments to control variable 
711     struct Adjust {
712         bool add; // addition or subtraction
713         uint rate; // increment
714         uint target; // BCV when adjustment finished
715         uint buffer; // minimum length (in blocks) between adjustments
716         uint lastBlock; // block when last adjustment made
717     }
718 
719 
720 
721 
722     /* ======== INITIALIZATION ======== */
723 
724     constructor ( 
725         address _OHM,
726         address _principle,
727         address _treasury, 
728         address _bondCalculator,
729         address _feed
730     ) {
731         require( _OHM != address(0) );
732         OHM = _OHM;
733         require( _principle != address(0) );
734         principle = _principle;
735         require( _treasury != address(0) );
736         treasury = _treasury;
737         // bondCalculator should be address(0) if not LP bond
738         bondCalculator = _bondCalculator;
739         priceFeed = AggregatorV3Interface( _feed );
740     }
741 
742     /**
743      *  @notice initializes bond parameters
744      *  @param _controlVariable uint
745      *  @param _vestingTerm uint
746      *  @param _minimumPrice uint
747      *  @param _maxPayout uint
748      *  @param _maxDebt uint
749      *  @param _initialDebt uint
750      */
751     function initializeBondTerms( 
752         uint _controlVariable, 
753         uint _vestingTerm,
754         uint _minimumPrice,
755         uint _maxPayout,
756         uint _maxDebt,
757         uint _initialDebt
758     ) external onlyPolicy() {
759         require( terms.controlVariable == 0, "Bonds must be initialized from 0" );
760         terms = Terms ({
761             controlVariable: _controlVariable,
762             vestingTerm: _vestingTerm,
763             minimumPrice: _minimumPrice,
764             maxPayout: _maxPayout,
765             maxDebt: _maxDebt
766         });
767         totalDebt = _initialDebt;
768         lastDecay = block.number;
769     }
770 
771 
772 
773     
774     /* ======== POLICY FUNCTIONS ======== */
775 
776     enum PARAMETER { VESTING, PAYOUT, DEBT }
777     /**
778      *  @notice set parameters for new bonds
779      *  @param _parameter PARAMETER
780      *  @param _input uint
781      */
782     function setBondTerms ( PARAMETER _parameter, uint _input ) external onlyPolicy() {
783         if ( _parameter == PARAMETER.VESTING ) { // 0
784             require( _input >= 10000, "Vesting must be longer than 36 hours" );
785             terms.vestingTerm = _input;
786         } else if ( _parameter == PARAMETER.PAYOUT ) { // 1
787             require( _input <= 1000, "Payout cannot be above 1 percent" );
788             terms.maxPayout = _input;
789         } else if ( _parameter == PARAMETER.DEBT ) { // 3
790             terms.maxDebt = _input;
791         }
792     }
793 
794     /**
795      *  @notice set control variable adjustment
796      *  @param _addition bool
797      *  @param _increment uint
798      *  @param _target uint
799      *  @param _buffer uint
800      */
801     function setAdjustment ( 
802         bool _addition,
803         uint _increment, 
804         uint _target,
805         uint _buffer 
806     ) external onlyPolicy() {
807         require( _increment <= terms.controlVariable.mul( 25 ).div( 1000 ), "Increment too large" );
808 
809         adjustment = Adjust({
810             add: _addition,
811             rate: _increment,
812             target: _target,
813             buffer: _buffer,
814             lastBlock: block.number
815         });
816     }
817 
818     /**
819      *  @notice set contract for auto stake
820      *  @param _staking address
821      *  @param _helper bool
822      */
823     function setStaking( address _staking, bool _helper ) external onlyPolicy() {
824         require( _staking != address(0) );
825         if ( _helper ) {
826             useHelper = true;
827             stakingHelper = _staking;
828         } else {
829             useHelper = false;
830             staking = _staking;
831         }
832     }
833 
834 
835     
836 
837     /* ======== USER FUNCTIONS ======== */
838 
839     /**
840      *  @notice deposit bond
841      *  @param _amount uint
842      *  @param _maxPrice uint
843      *  @param _depositor address
844      *  @return uint
845      */
846     function deposit( 
847         uint _amount, 
848         uint _maxPrice,
849         address _depositor
850     ) external returns ( uint ) {
851         require( _depositor != address(0), "Invalid address" );
852 
853         decayDebt();
854         require( totalDebt <= terms.maxDebt, "Max capacity reached" );
855         
856         uint priceInUSD = bondPriceInUSD(); // Stored in bond info
857         uint nativePrice = _bondPrice();
858 
859         require( _maxPrice >= nativePrice, "Slippage limit: more than max price" ); // slippage protection
860 
861         uint value = ITreasury( treasury ).valueOf( principle, _amount );
862         uint payout = payoutFor( value ); // payout to bonder is computed
863 
864         require( payout >= 10000000, "Bond too small" ); // must be > 0.01 OHM ( underflow protection )
865         require( payout <= maxPayout(), "Bond too large"); // size protection because there is no slippage
866 
867         /**
868             asset carries risk and is not minted against
869             asset transfered to treasury and rewards minted as payout
870          */
871         IERC20( principle ).safeTransferFrom( msg.sender, treasury, _amount );
872         ITreasury( treasury ).mintRewards( address(this), payout );
873         
874         // total debt is increased
875         totalDebt = totalDebt.add( value ); 
876                 
877         // depositor info is stored
878         bondInfo[ _depositor ] = Bond({ 
879             payout: bondInfo[ _depositor ].payout.add( payout ),
880             vesting: terms.vestingTerm,
881             lastBlock: block.number,
882             pricePaid: priceInUSD
883         });
884 
885         // indexed events are emitted
886         emit BondCreated( _amount, payout, block.number.add( terms.vestingTerm ), priceInUSD );
887         emit BondPriceChanged( bondPriceInUSD(), _bondPrice(), debtRatio() );
888 
889         adjust(); // control variable is adjusted
890         return payout; 
891     }
892 
893     /** 
894      *  @notice redeem bond for user
895      *  @param _recipient address
896      *  @param _stake bool
897      *  @return uint
898      */ 
899     function redeem( address _recipient, bool _stake ) external returns ( uint ) {        
900         Bond memory info = bondInfo[ _recipient ];
901         uint percentVested = percentVestedFor( _recipient ); // (blocks since last interaction / vesting term remaining)
902 
903         if ( percentVested >= 10000 ) { // if fully vested
904             delete bondInfo[ _recipient ]; // delete user info
905             emit BondRedeemed( _recipient, info.payout, 0 ); // emit bond data
906             return stakeOrSend( _recipient, _stake, info.payout ); // pay user everything due
907 
908         } else { // if unfinished
909             // calculate payout vested
910             uint payout = info.payout.mul( percentVested ).div( 10000 );
911 
912             // store updated deposit info
913             bondInfo[ _recipient ] = Bond({
914                 payout: info.payout.sub( payout ),
915                 vesting: info.vesting.sub( block.number.sub( info.lastBlock ) ),
916                 lastBlock: block.number,
917                 pricePaid: info.pricePaid
918             });
919 
920             emit BondRedeemed( _recipient, payout, bondInfo[ _recipient ].payout );
921             return stakeOrSend( _recipient, _stake, payout );
922         }
923     }
924 
925 
926 
927     
928     /* ======== INTERNAL HELPER FUNCTIONS ======== */
929 
930     /**
931      *  @notice allow user to stake payout automatically
932      *  @param _stake bool
933      *  @param _amount uint
934      *  @return uint
935      */
936     function stakeOrSend( address _recipient, bool _stake, uint _amount ) internal returns ( uint ) {
937         if ( !_stake ) { // if user does not want to stake
938             IERC20( OHM ).transfer( _recipient, _amount ); // send payout
939         } else { // if user wants to stake
940             if ( useHelper ) { // use if staking warmup is 0
941                 IERC20( OHM ).approve( stakingHelper, _amount );
942                 IStakingHelper( stakingHelper ).stake( _amount, _recipient );
943             } else {
944                 IERC20( OHM ).approve( staking, _amount );
945                 IStaking( staking ).stake( _amount, _recipient );
946             }
947         }
948         return _amount;
949     }
950 
951     /**
952      *  @notice makes incremental adjustment to control variable
953      */
954     function adjust() internal {
955         uint blockCanAdjust = adjustment.lastBlock.add( adjustment.buffer );
956         if( adjustment.rate != 0 && block.number >= blockCanAdjust ) {
957             uint initial = terms.controlVariable;
958             if ( adjustment.add ) {
959                 terms.controlVariable = terms.controlVariable.add( adjustment.rate );
960                 if ( terms.controlVariable >= adjustment.target ) {
961                     adjustment.rate = 0;
962                 }
963             } else {
964                 terms.controlVariable = terms.controlVariable.sub( adjustment.rate );
965                 if ( terms.controlVariable <= adjustment.target ) {
966                     adjustment.rate = 0;
967                 }
968             }
969             adjustment.lastBlock = block.number;
970             emit ControlVariableAdjustment( initial, terms.controlVariable, adjustment.rate, adjustment.add );
971         }
972     }
973 
974     /**
975      *  @notice reduce total debt
976      */
977     function decayDebt() internal {
978         totalDebt = totalDebt.sub( debtDecay() );
979         lastDecay = block.number;
980     }
981 
982 
983 
984 
985     /* ======== VIEW FUNCTIONS ======== */
986 
987     /**
988      *  @notice determine maximum bond size
989      *  @return uint
990      */
991     function maxPayout() public view returns ( uint ) {
992         return IERC20( OHM ).totalSupply().mul( terms.maxPayout ).div( 100000 );
993     }
994 
995     /**
996      *  @notice calculate interest due for new bond
997      *  @param _value uint
998      *  @return uint
999      */
1000     function payoutFor( uint _value ) public view returns ( uint ) {
1001         return FixedPoint.fraction( _value, bondPrice() ).decode112with18().div( 1e14 );
1002     }
1003 
1004     /**
1005      *  @notice calculate current bond premium
1006      *  @return price_ uint
1007      */
1008     function bondPrice() public view returns ( uint price_ ) {        
1009         price_ = terms.controlVariable.mul( debtRatio() ).div( 1e5 );
1010         if ( price_ < terms.minimumPrice ) {
1011             price_ = terms.minimumPrice;
1012         }
1013     }
1014 
1015     /**
1016      *  @notice calculate current bond price and remove floor if above
1017      *  @return price_ uint
1018      */
1019     function _bondPrice() internal returns ( uint price_ ) {
1020         price_ = terms.controlVariable.mul( debtRatio() ).div( 1e5 );
1021         if ( price_ < terms.minimumPrice ) {
1022             price_ = terms.minimumPrice;        
1023         } else if ( terms.minimumPrice != 0 ) {
1024             terms.minimumPrice = 0;
1025         }
1026     }
1027     
1028     /**
1029      *  @notice get asset price from chainlink
1030      */
1031     function assetPrice() public view returns (int) {
1032         ( , int price, , , ) = priceFeed.latestRoundData();
1033         return price;
1034     }
1035 
1036     /**
1037      *  @notice converts bond price to DAI value
1038      *  @return price_ uint
1039      */
1040     function bondPriceInUSD() public view returns ( uint price_ ) {
1041         price_ = bondPrice()
1042                     .mul( IBondCalculator( bondCalculator ).markdown( principle ) )
1043                     .mul( uint( assetPrice() ) )
1044                     .div( 1e12 );
1045     }
1046 
1047 
1048     /**
1049      *  @notice calculate current ratio of debt to OHM supply
1050      *  @return debtRatio_ uint
1051      */
1052     function debtRatio() public view returns ( uint debtRatio_ ) {   
1053         debtRatio_ = FixedPoint.fraction( 
1054             currentDebt().mul( 1e9 ), 
1055             IERC20( OHM ).totalSupply()
1056         ).decode112with18().div( 1e18 );
1057     }
1058 
1059     /**
1060      *  @notice debt ratio in same terms for reserve or liquidity bonds
1061      *  @return uint
1062      */
1063     function standardizedDebtRatio() external view returns ( uint ) {
1064         return debtRatio().mul( IBondCalculator( bondCalculator ).markdown( principle ) ).div( 1e9 );
1065     }
1066 
1067     /**
1068      *  @notice calculate debt factoring in decay
1069      *  @return uint
1070      */
1071     function currentDebt() public view returns ( uint ) {
1072         return totalDebt.sub( debtDecay() );
1073     }
1074 
1075     /**
1076      *  @notice amount to decay total debt by
1077      *  @return decay_ uint
1078      */
1079     function debtDecay() public view returns ( uint decay_ ) {
1080         uint blocksSinceLast = block.number.sub( lastDecay );
1081         decay_ = totalDebt.mul( blocksSinceLast ).div( terms.vestingTerm );
1082         if ( decay_ > totalDebt ) {
1083             decay_ = totalDebt;
1084         }
1085     }
1086 
1087 
1088     /**
1089      *  @notice calculate how far into vesting a depositor is
1090      *  @param _depositor address
1091      *  @return percentVested_ uint
1092      */
1093     function percentVestedFor( address _depositor ) public view returns ( uint percentVested_ ) {
1094         Bond memory bond = bondInfo[ _depositor ];
1095         uint blocksSinceLast = block.number.sub( bond.lastBlock );
1096         uint vesting = bond.vesting;
1097 
1098         if ( vesting > 0 ) {
1099             percentVested_ = blocksSinceLast.mul( 10000 ).div( vesting );
1100         } else {
1101             percentVested_ = 0;
1102         }
1103     }
1104 
1105     /**
1106      *  @notice calculate amount of OHM available for claim by depositor
1107      *  @param _depositor address
1108      *  @return pendingPayout_ uint
1109      */
1110     function pendingPayoutFor( address _depositor ) external view returns ( uint pendingPayout_ ) {
1111         uint percentVested = percentVestedFor( _depositor );
1112         uint payout = bondInfo[ _depositor ].payout;
1113 
1114         if ( percentVested >= 10000 ) {
1115             pendingPayout_ = payout;
1116         } else {
1117             pendingPayout_ = payout.mul( percentVested ).div( 10000 );
1118         }
1119     }
1120 }