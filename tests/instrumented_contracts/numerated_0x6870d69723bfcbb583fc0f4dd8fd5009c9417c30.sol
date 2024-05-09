1 /**
2  *Submitted for verification at Etherscan.io on 2022-01-21
3 */
4 
5 // SPDX-License-Identifier: AGPL-3.0-or-later
6 pragma solidity 0.7.5;
7 
8 //import "hardhat/console.sol";
9 
10 interface IOwnable {
11   function policy() external view returns (address);
12 
13   function renounceManagement() external;
14   
15   function pushManagement( address newOwner_ ) external;
16   
17   function pullManagement() external;
18 }
19 
20 contract Ownable is IOwnable {
21 
22     address internal _owner;
23     address internal _newOwner;
24 
25     event OwnershipPushed(address indexed previousOwner, address indexed newOwner);
26     event OwnershipPulled(address indexed previousOwner, address indexed newOwner);
27 
28     constructor () {
29         _owner = msg.sender;
30         emit OwnershipPushed( address(0), _owner );
31     }
32 
33     function policy() public view override returns (address) {
34         return _owner;
35     }
36 
37     modifier onlyPolicy() {
38         require( _owner == msg.sender, "Ownable: caller is not the owner" );
39         _;
40     }
41 
42     function renounceManagement() public virtual override onlyPolicy() {
43         emit OwnershipPushed( _owner, address(0) );
44         _owner = address(0);
45     }
46 
47     function pushManagement( address newOwner_ ) public virtual override onlyPolicy() {
48         require( newOwner_ != address(0), "Ownable: new owner is the zero address");
49         emit OwnershipPushed( _owner, newOwner_ );
50         _newOwner = newOwner_;
51     }
52     
53     function pullManagement() public virtual override {
54         require( msg.sender == _newOwner, "Ownable: must be new owner to pull");
55         emit OwnershipPulled( _owner, _newOwner );
56         _owner = _newOwner;
57     }
58 }
59 
60 library SafeMath {
61 
62     function add(uint256 a, uint256 b) internal pure returns (uint256) {
63         uint256 c = a + b;
64         require(c >= a, "SafeMath: addition overflow");
65 
66         return c;
67     }
68 
69     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70         return sub(a, b, "SafeMath: subtraction overflow");
71     }
72 
73     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
74         require(b <= a, errorMessage);
75         uint256 c = a - b;
76 
77         return c;
78     }
79 
80     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
81         if (a == 0) {
82             return 0;
83         }
84 
85         uint256 c = a * b;
86         require(c / a == b, "SafeMath: multiplication overflow");
87 
88         return c;
89     }
90 
91     function div(uint256 a, uint256 b) internal pure returns (uint256) {
92         return div(a, b, "SafeMath: division by zero");
93     }
94 
95     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
96         require(b > 0, errorMessage);
97         uint256 c = a / b;
98         return c;
99     }
100 
101     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
102         return mod(a, b, "SafeMath: modulo by zero");
103     }
104 
105     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
106         require(b != 0, errorMessage);
107         return a % b;
108     }
109 
110     function sqrrt(uint256 a) internal pure returns (uint c) {
111         if (a > 3) {
112             c = a;
113             uint b = add( div( a, 2), 1 );
114             while (b < c) {
115                 c = b;
116                 b = div( add( div( a, b ), b), 2 );
117             }
118         } else if (a != 0) {
119             c = 1;
120         }
121     }
122 }
123 
124 library Address {
125 
126     function isContract(address account) internal view returns (bool) {
127 
128         uint256 size;
129         // solhint-disable-next-line no-inline-assembly
130         assembly { size := extcodesize(account) }
131         return size > 0;
132     }
133 
134     function sendValue(address payable recipient, uint256 amount) internal {
135         require(address(this).balance >= amount, "Address: insufficient balance");
136 
137         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
138         (bool success, ) = recipient.call{ value: amount }("");
139         require(success, "Address: unable to send value, recipient may have reverted");
140     }
141 
142     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
143       return functionCall(target, data, "Address: low-level call failed");
144     }
145 
146     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
147         return _functionCallWithValue(target, data, 0, errorMessage);
148     }
149 
150     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
151         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
152     }
153 
154     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
155         require(address(this).balance >= value, "Address: insufficient balance for call");
156         require(isContract(target), "Address: call to non-contract");
157 
158         // solhint-disable-next-line avoid-low-level-calls
159         (bool success, bytes memory returndata) = target.call{ value: value }(data);
160         return _verifyCallResult(success, returndata, errorMessage);
161     }
162 
163     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
164         require(isContract(target), "Address: call to non-contract");
165 
166         // solhint-disable-next-line avoid-low-level-calls
167         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
168         if (success) {
169             return returndata;
170         } else {
171             // Look for revert reason and bubble it up if present
172             if (returndata.length > 0) {
173                 // The easiest way to bubble the revert reason is using memory via assembly
174 
175                 // solhint-disable-next-line no-inline-assembly
176                 assembly {
177                     let returndata_size := mload(returndata)
178                     revert(add(32, returndata), returndata_size)
179                 }
180             } else {
181                 revert(errorMessage);
182             }
183         }
184     }
185 
186     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
187         return functionStaticCall(target, data, "Address: low-level static call failed");
188     }
189 
190     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
191         require(isContract(target), "Address: static call to non-contract");
192 
193         // solhint-disable-next-line avoid-low-level-calls
194         (bool success, bytes memory returndata) = target.staticcall(data);
195         return _verifyCallResult(success, returndata, errorMessage);
196     }
197 
198     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
199         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
200     }
201 
202     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
203         require(isContract(target), "Address: delegate call to non-contract");
204 
205         // solhint-disable-next-line avoid-low-level-calls
206         (bool success, bytes memory returndata) = target.delegatecall(data);
207         return _verifyCallResult(success, returndata, errorMessage);
208     }
209 
210     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
211         if (success) {
212             return returndata;
213         } else {
214             if (returndata.length > 0) {
215 
216                 assembly {
217                     let returndata_size := mload(returndata)
218                     revert(add(32, returndata), returndata_size)
219                 }
220             } else {
221                 revert(errorMessage);
222             }
223         }
224     }
225 
226     function addressToString(address _address) internal pure returns(string memory) {
227         bytes32 _bytes = bytes32(uint256(_address));
228         bytes memory HEX = "0123456789abcdef";
229         bytes memory _addr = new bytes(42);
230 
231         _addr[0] = '0';
232         _addr[1] = 'x';
233 
234         for(uint256 i = 0; i < 20; i++) {
235             _addr[2+i*2] = HEX[uint8(_bytes[i + 12] >> 4)];
236             _addr[3+i*2] = HEX[uint8(_bytes[i + 12] & 0x0f)];
237         }
238 
239         return string(_addr);
240 
241     }
242 }
243 
244 interface IERC20 {
245     function decimals() external view returns (uint8);
246 
247     function totalSupply() external view returns (uint256);
248 
249     function balanceOf(address account) external view returns (uint256);
250 
251     function transfer(address recipient, uint256 amount) external returns (bool);
252 
253     function allowance(address owner, address spender) external view returns (uint256);
254 
255     function approve(address spender, uint256 amount) external returns (bool);
256 
257     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
258 
259     event Transfer(address indexed from, address indexed to, uint256 value);
260 
261     event Approval(address indexed owner, address indexed spender, uint256 value);
262 }
263 
264 abstract contract ERC20 is IERC20 {
265 
266     using SafeMath for uint256;
267 
268     // TODO comment actual hash value.
269     bytes32 constant private ERC20TOKEN_ERC1820_INTERFACE_ID = keccak256( "ERC20Token" );
270     
271     mapping (address => uint256) internal _balances;
272 
273     mapping (address => mapping (address => uint256)) internal _allowances;
274 
275     uint256 internal _totalSupply;
276 
277     string internal _name;
278     
279     string internal _symbol;
280     
281     uint8 internal _decimals;
282 
283     constructor (string memory name_, string memory symbol_, uint8 decimals_) {
284         _name = name_;
285         _symbol = symbol_;
286         _decimals = decimals_;
287     }
288 
289     function name() public view returns (string memory) {
290         return _name;
291     }
292 
293     function symbol() public view returns (string memory) {
294         return _symbol;
295     }
296 
297     function decimals() public view override returns (uint8) {
298         return _decimals;
299     }
300 
301     function totalSupply() public view override returns (uint256) {
302         return _totalSupply;
303     }
304 
305     function balanceOf(address account) public view virtual override returns (uint256) {
306         return _balances[account];
307     }
308 
309     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
310         _transfer(msg.sender, recipient, amount);
311         return true;
312     }
313 
314     function allowance(address owner, address spender) public view virtual override returns (uint256) {
315         return _allowances[owner][spender];
316     }
317 
318     function approve(address spender, uint256 amount) public virtual override returns (bool) {
319         _approve(msg.sender, spender, amount);
320         return true;
321     }
322 
323     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
324         _transfer(sender, recipient, amount);
325         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
326         return true;
327     }
328 
329     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
330         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
331         return true;
332     }
333 
334     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
335         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
336         return true;
337     }
338 
339     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
340         require(sender != address(0), "ERC20: transfer from the zero address");
341         require(recipient != address(0), "ERC20: transfer to the zero address");
342 
343         _beforeTokenTransfer(sender, recipient, amount);
344 
345         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
346         _balances[recipient] = _balances[recipient].add(amount);
347         emit Transfer(sender, recipient, amount);
348     }
349 
350     function _mint(address account_, uint256 ammount_) internal virtual {
351         require(account_ != address(0), "ERC20: mint to the zero address");
352         _beforeTokenTransfer(address( this ), account_, ammount_);
353         _totalSupply = _totalSupply.add(ammount_);
354         _balances[account_] = _balances[account_].add(ammount_);
355         emit Transfer(address( this ), account_, ammount_);
356     }
357 
358     function _burn(address account, uint256 amount) internal virtual {
359         require(account != address(0), "ERC20: burn from the zero address");
360 
361         _beforeTokenTransfer(account, address(0), amount);
362 
363         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
364         _totalSupply = _totalSupply.sub(amount);
365         emit Transfer(account, address(0), amount);
366     }
367 
368     function _approve(address owner, address spender, uint256 amount) internal virtual {
369         require(owner != address(0), "ERC20: approve from the zero address");
370         require(spender != address(0), "ERC20: approve to the zero address");
371 
372         _allowances[owner][spender] = amount;
373         emit Approval(owner, spender, amount);
374     }
375 
376   function _beforeTokenTransfer( address from_, address to_, uint256 amount_ ) internal virtual { }
377 }
378 
379 interface IERC2612Permit {
380 
381     function permit(
382         address owner,
383         address spender,
384         uint256 amount,
385         uint256 deadline,
386         uint8 v,
387         bytes32 r,
388         bytes32 s
389     ) external;
390 
391     function nonces(address owner) external view returns (uint256);
392 }
393 
394 library Counters {
395     using SafeMath for uint256;
396 
397     struct Counter {
398 
399         uint256 _value; // default: 0
400     }
401 
402     function current(Counter storage counter) internal view returns (uint256) {
403         return counter._value;
404     }
405 
406     function increment(Counter storage counter) internal {
407         counter._value += 1;
408     }
409 
410     function decrement(Counter storage counter) internal {
411         counter._value = counter._value.sub(1);
412     }
413 }
414 
415 abstract contract ERC20Permit is ERC20, IERC2612Permit {
416     using Counters for Counters.Counter;
417 
418     mapping(address => Counters.Counter) private _nonces;
419 
420     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
421     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
422 
423     bytes32 public DOMAIN_SEPARATOR;
424 
425     constructor() {
426         uint256 chainID;
427         assembly {
428             chainID := chainid()
429         }
430 
431         DOMAIN_SEPARATOR = keccak256(
432             abi.encode(
433                 keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
434                 keccak256(bytes(name())),
435                 keccak256(bytes("1")), // Version
436                 chainID,
437                 address(this)
438             )
439         );
440     }
441 
442     function permit(
443         address owner,
444         address spender,
445         uint256 amount,
446         uint256 deadline,
447         uint8 v,
448         bytes32 r,
449         bytes32 s
450     ) public virtual override {
451         require(block.timestamp <= deadline, "Permit: expired deadline");
452 
453         bytes32 hashStruct =
454             keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, amount, _nonces[owner].current(), deadline));
455 
456         bytes32 _hash = keccak256(abi.encodePacked(uint16(0x1901), DOMAIN_SEPARATOR, hashStruct));
457 
458         address signer = ecrecover(_hash, v, r, s);
459         require(signer != address(0) && signer == owner, "ZeroSwapPermit: Invalid signature");
460 
461         _nonces[owner].increment();
462         _approve(owner, spender, amount);
463     }
464 
465     function nonces(address owner) public view override returns (uint256) {
466         return _nonces[owner].current();
467     }
468 }
469 
470 library SafeERC20 {
471     using SafeMath for uint256;
472     using Address for address;
473 
474     function safeTransfer(IERC20 token, address to, uint256 value) internal {
475         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
476     }
477 
478     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
479         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
480     }
481 
482     function safeApprove(IERC20 token, address spender, uint256 value) internal {
483 
484         require((value == 0) || (token.allowance(address(this), spender) == 0),
485             "SafeERC20: approve from non-zero to non-zero allowance"
486         );
487         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
488     }
489 
490     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
491         uint256 newAllowance = token.allowance(address(this), spender).add(value);
492         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
493     }
494 
495     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
496         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
497         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
498     }
499 
500     function _callOptionalReturn(IERC20 token, bytes memory data) private {
501 
502         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
503         if (returndata.length > 0) { // Return data is optional
504             // solhint-disable-next-line max-line-length
505             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
506         }
507     }
508 }
509 
510 library FullMath {
511     function fullMul(uint256 x, uint256 y) private pure returns (uint256 l, uint256 h) {
512         uint256 mm = mulmod(x, y, uint256(-1));
513         l = x * y;
514         h = mm - l;
515         if (mm < l) h -= 1;
516     }
517 
518     function fullDiv(
519         uint256 l,
520         uint256 h,
521         uint256 d
522     ) private pure returns (uint256) {
523         uint256 pow2 = d & -d;
524         d /= pow2;
525         l /= pow2;
526         l += h * ((-pow2) / pow2 + 1);
527         uint256 r = 1;
528         r *= 2 - d * r;
529         r *= 2 - d * r;
530         r *= 2 - d * r;
531         r *= 2 - d * r;
532         r *= 2 - d * r;
533         r *= 2 - d * r;
534         r *= 2 - d * r;
535         r *= 2 - d * r;
536         return l * r;
537     }
538 
539     function mulDiv(
540         uint256 x,
541         uint256 y,
542         uint256 d
543     ) internal pure returns (uint256) {
544         (uint256 l, uint256 h) = fullMul(x, y);
545         uint256 mm = mulmod(x, y, d);
546         if (mm > l) h -= 1;
547         l -= mm;
548         require(h < d, 'FullMath::mulDiv: overflow');
549         return fullDiv(l, h, d);
550     }
551 }
552 
553 library FixedPoint {
554 
555     struct uq112x112 {
556         uint224 _x;
557     }
558 
559     struct uq144x112 {
560         uint256 _x;
561     }
562 
563     uint8 private constant RESOLUTION = 112;
564     uint256 private constant Q112 = 0x10000000000000000000000000000;
565     uint256 private constant Q224 = 0x100000000000000000000000000000000000000000000000000000000;
566     uint256 private constant LOWER_MASK = 0xffffffffffffffffffffffffffff; // decimal of UQ*x112 (lower 112 bits)
567 
568     function decode(uq112x112 memory self) internal pure returns (uint112) {
569         return uint112(self._x >> RESOLUTION);
570     }
571 
572     function decode112with18(uq112x112 memory self) internal pure returns (uint) {
573 
574         return uint(self._x) / 5192296858534827;
575     }
576 
577     function fraction(uint256 numerator, uint256 denominator) internal pure returns (uq112x112 memory) {
578         require(denominator > 0, 'FixedPoint::fraction: division by zero');
579         if (numerator == 0) return FixedPoint.uq112x112(0);
580 
581         if (numerator <= uint144(-1)) {
582             uint256 result = (numerator << RESOLUTION) / denominator;
583             require(result <= uint224(-1), 'FixedPoint::fraction: overflow');
584             return uq112x112(uint224(result));
585         } else {
586             uint256 result = FullMath.mulDiv(numerator, Q112, denominator);
587             require(result <= uint224(-1), 'FixedPoint::fraction: overflow');
588             return uq112x112(uint224(result));
589         }
590     }
591 }
592 
593 interface ITreasury {
594     function deposit( uint _amount, address _token, uint _profit ) external returns ( bool );
595     function valueOf( address _token, uint _amount ) external view returns ( uint value_ );
596     function getFloor(address _token) external view returns(uint);
597     function mintRewards(address _recipient, uint _amount ) external;
598 }
599 
600 interface IBondCalculator {
601     function valuation( address _LP, uint _amount ) external view returns ( uint );
602     function markdown( address _LP ) external view returns ( uint );
603 }
604 
605 interface IStaking {
606     function stake( uint _amount, address _recipient ) external returns ( bool );
607 }
608 
609 interface IStakingHelper {
610     function stake( uint _amount, address _recipient ) external;
611 }
612 
613 contract REDACTEDBondDepositoryRewardBased is Ownable {
614 
615     using FixedPoint for *;
616     using SafeERC20 for IERC20;
617     using SafeMath for uint;
618 
619 
620 
621 
622     /* ======== EVENTS ======== */
623 
624     event BondCreated( uint deposit, uint indexed payout, uint indexed expires, uint indexed nativePrice );
625     event BondRedeemed( address indexed recipient, uint payout, uint remaining );
626     event BondPriceChanged( uint indexed nativePrice, uint indexed internalPrice, uint indexed debtRatio );
627     event ControlVariableAdjustment( uint initialBCV, uint newBCV, uint adjustment, bool addition );
628 
629 
630 
631 
632     /* ======== STATE VARIABLES ======== */
633 
634     address public immutable BTRFLY; // token given as payment for bond
635     address public immutable principal; // token used to create bond
636     address public immutable OLYMPUSDAO; // we pay homage to these guys :) (tithe/ti-the hahahahhahah)
637     address public immutable treasury; // mints BTRFLY when receives principal
638     address public immutable DAO; // receives profit share from bond
639     address public OLYMPUSTreasury; // Olympus treasury can be updated by the OLYMPUSDAO
640 
641     bool public immutable isLiquidityBond; // LP and Reserve bonds are treated slightly different
642     address public immutable bondCalculator; // calculates value of LP tokens
643 
644     address public staking; // to auto-stake payout
645     address public stakingHelper; // to stake and claim if no staking warmup
646     bool public useHelper;
647 
648     Terms public terms; // stores terms for new bonds
649     Adjust public adjustment; // stores adjustment to BCV data
650 
651     mapping( address => Bond ) public bondInfo; // stores bond information for depositors
652 
653     uint public totalDebt; // total value of outstanding bonds; used for pricing
654     uint public lastDecay; // reference block for debt decay
655 
656 
657 
658 
659     /* ======== STRUCTS ======== */
660 
661     // Info for creating new bonds
662     struct Terms {
663         uint controlVariable; // scaling variable for price
664         uint vestingTerm; // in blocks
665         uint minimumPrice; // vs principal value
666         uint maxPayout; // in thousandths of a %. i.e. 500 = 0.5%
667         uint fee; // as % of bond payout, in hundreths. ( 500 = 5% = 0.05 for every 1 paid)
668         uint tithe; // in thousandths of a %. i.e. 500 = 0.5%
669         uint maxDebt; // 9 decimal debt ratio, max % total supply created as debt
670     }
671 
672     // Info for bond holder
673     struct Bond {
674         uint payout; // BTRFLY remaining to be paid
675         uint vesting; // Blocks left to vest
676         uint lastBlock; // Last interaction
677         uint pricePaid; // In native asset, for front end viewing
678     }
679 
680     // Info for incremental adjustments to control variable 
681     struct Adjust {
682         bool add; // addition or subtraction
683         uint rate; // increment
684         uint target; // BCV when adjustment finished
685         uint buffer; // minimum length (in blocks) between adjustments
686         uint lastBlock; // block when last adjustment made
687     }
688 
689 
690 
691 
692     /* ======== INITIALIZATION ======== */
693 
694     constructor ( 
695         address _BTRFLY,
696         address _principal,
697         address _treasury, 
698         address _DAO, 
699         address _bondCalculator,
700         address _OLYMPUSDAO,
701         address _OLYMPUSTreasury
702     ) {
703         require( _BTRFLY != address(0) );
704         BTRFLY = _BTRFLY;
705         require( _principal != address(0) );
706         principal = _principal;
707         require( _treasury != address(0) );
708         treasury = _treasury;
709         require( _DAO != address(0) );
710         DAO = _DAO;
711         // bondCalculator should be address(0) if not LP bond
712         bondCalculator = _bondCalculator;
713         isLiquidityBond = ( _bondCalculator != address(0) );
714         OLYMPUSDAO = _OLYMPUSDAO;
715         OLYMPUSTreasury = _OLYMPUSTreasury;
716     }
717 
718     /**
719      *  @notice initializes bond parameters
720      *  @param _controlVariable uint
721      *  @param _vestingTerm uint
722      *  @param _minimumPrice uint
723      *  @param _maxPayout uint
724      *  @param _fee uint
725      *  @param _maxDebt uint
726      *  @param _initialDebt uint
727      */
728     function initializeBondTerms( 
729         uint _controlVariable, 
730         uint _vestingTerm,
731         uint _minimumPrice,
732         uint _maxPayout,
733         uint _fee,
734         uint _maxDebt,
735         uint _tithe,
736         uint _initialDebt
737     ) external onlyPolicy() {
738         require( terms.controlVariable == 0, "Bonds must be initialized from 0" );
739         terms = Terms ({
740             controlVariable: _controlVariable,
741             vestingTerm: _vestingTerm,
742             minimumPrice: _minimumPrice,
743             maxPayout: _maxPayout,
744             fee: _fee,
745             maxDebt: _maxDebt,
746             tithe: _tithe
747         });
748         totalDebt = _initialDebt;
749         lastDecay = block.number;
750     }
751 
752 
753 
754     
755     /* ======== POLICY FUNCTIONS ======== */
756 
757     enum PARAMETER { VESTING, PAYOUT, FEE, DEBT }
758     /**
759      *  @notice set parameters for new bonds
760      *  @param _parameter PARAMETER
761      *  @param _input uint
762      */
763     function setBondTerms ( PARAMETER _parameter, uint _input ) external onlyPolicy() {
764         if ( _parameter == PARAMETER.VESTING ) { // 0
765             require( _input >= 10000, "Vesting must be longer than 36 hours" );
766             terms.vestingTerm = _input;
767         } else if ( _parameter == PARAMETER.PAYOUT ) { // 1
768             require( _input <= 1000, "Payout cannot be above 1 percent" );
769             terms.maxPayout = _input;
770         } else if ( _parameter == PARAMETER.FEE ) { // 2
771             require( _input <= 10000, "DAO fee cannot exceed payout" );
772             terms.fee = _input;
773         } else if ( _parameter == PARAMETER.DEBT ) { // 3
774             terms.maxDebt = _input;
775         }
776     }
777 
778     /**
779      *  @notice set control variable adjustment
780      *  @param _addition bool
781      *  @param _increment uint
782      *  @param _target uint
783      *  @param _buffer uint
784      */
785     function setAdjustment ( 
786         bool _addition,
787         uint _increment, 
788         uint _target,
789         uint _buffer 
790     ) external onlyPolicy() {
791         require( _increment <= terms.controlVariable.mul( 25 ).div( 1000 ), "Increment too large" );
792 
793         adjustment = Adjust({
794             add: _addition,
795             rate: _increment,
796             target: _target,
797             buffer: _buffer,
798             lastBlock: block.number
799         });
800     }
801 
802     /**
803      *  @notice set contract for auto stake
804      *  @param _staking address
805      *  @param _helper bool
806      */
807     function setStaking( address _staking, bool _helper ) external onlyPolicy() {
808         require( _staking != address(0) );
809         if ( _helper ) {
810             useHelper = true;
811             stakingHelper = _staking;
812         } else {
813             useHelper = false;
814             staking = _staking;
815         }
816     }
817 
818 
819     
820 
821     /* ======== USER FUNCTIONS ======== */
822 
823     /**
824      *  @notice deposit bond
825      *  @param _amount uint
826      *  @param _maxPrice uint
827      *  @param _depositor address
828      *  @return uint
829      */
830     function deposit( 
831         uint _amount, 
832         uint _maxPrice,
833         address _depositor
834     ) external returns ( uint ) {
835         require( _depositor != address(0), "Invalid address" );
836         require( _depositor == msg.sender , "Depositor not msg.sender" );
837 
838         decayDebt();
839         require( totalDebt <= terms.maxDebt, "Max capacity reached" );
840         
841         uint nativePrice = _bondPrice();
842 
843         require( _maxPrice >= nativePrice, "Slippage limit: more than max price" ); // slippage protection
844 
845         uint tithePrincipal = _amount.mul(terms.tithe).div(100000);
846 
847         uint value = ITreasury( treasury ).valueOf( principal, _amount );
848         //console.log(" value = ", value);
849         uint payout = payoutFor( value ); // payout to bonder is computed
850         //console.log("payout = ", payout);
851 
852         require( payout >= 10000000, "Bond too small" ); // must be > 0.01 BTRFLY ( underflow protection )
853         require( payout <= maxPayout(), "Bond too large"); // size protection because there is no slippage
854 
855         /**
856             principal is transferred in
857             approved and
858             deposited into the treasury, returning (_amount - profit) BTRFLY
859          */
860         IERC20( principal ).safeTransferFrom( msg.sender, address(this), _amount );
861         IERC20( principal ).safeTransfer( OLYMPUSTreasury, tithePrincipal );
862 
863         uint amountDeposit = _amount.sub(tithePrincipal);
864         IERC20( principal ).safeTransfer( address( treasury ), amountDeposit );
865 
866         //call mintRewards
867         uint titheBTRFLY = payout.mul(terms.tithe).div(100000);
868         uint fee = payout.mul( terms.fee ).div( 100000 );
869         uint totalMint = titheBTRFLY.add(fee).add(payout);
870 
871         ITreasury(treasury).mintRewards(address(this),totalMint);
872         
873         // fee is transferred to daos
874         IERC20( BTRFLY ).safeTransfer( DAO, fee ); 
875         IERC20( BTRFLY ).safeTransfer( OLYMPUSTreasury, titheBTRFLY );
876         
877         // total debt is increased
878         totalDebt = totalDebt.add( value ); 
879                 
880         // depositor info is stored
881         bondInfo[ _depositor ] = Bond({ 
882             payout: bondInfo[ _depositor ].payout.add( payout ),
883             vesting: terms.vestingTerm,
884             lastBlock: block.number,
885             pricePaid: nativePrice
886         });
887 
888         // indexed events are emitted
889         emit BondCreated( _amount, payout, block.number.add( terms.vestingTerm ), nativePrice );
890         //emit BondPriceChanged( bondPriceInUSD(), _bondPrice(), debtRatio() );
891 
892         adjust(); // control variable is adjusted
893         return payout; 
894     }
895 
896     /** 
897      *  @notice redeem bond for user
898      *  @param _recipient address
899      *  @param _stake bool
900      *  @return uint
901      */ 
902     function redeem( address _recipient, bool _stake ) external returns ( uint ) {        
903         Bond memory info = bondInfo[ _recipient ];
904         uint percentVested = percentVestedFor( _recipient ); // (blocks since last interaction / vesting term remaining)
905 
906         if ( percentVested >= 10000 ) { // if fully vested
907             delete bondInfo[ _recipient ]; // delete user info
908             emit BondRedeemed( _recipient, info.payout, 0 ); // emit bond data
909             return stakeOrSend( _recipient, _stake, info.payout ); // pay user everything due
910 
911         } else { // if unfinished
912             // calculate payout vested
913             uint payout = info.payout.mul( percentVested ).div( 10000 );
914 
915             // store updated deposit info
916             bondInfo[ _recipient ] = Bond({
917                 payout: info.payout.sub( payout ),
918                 vesting: info.vesting.sub( block.number.sub( info.lastBlock ) ),
919                 lastBlock: block.number,
920                 pricePaid: info.pricePaid
921             });
922 
923             emit BondRedeemed( _recipient, payout, bondInfo[ _recipient ].payout );
924             return stakeOrSend( _recipient, _stake, payout );
925         }
926     }
927 
928 
929 
930     
931     /* ======== INTERNAL HELPER FUNCTIONS ======== */
932 
933     /**
934      *  @notice allow user to stake payout automatically
935      *  @param _stake bool
936      *  @param _amount uint
937      *  @return uint
938      */
939     function stakeOrSend( address _recipient, bool _stake, uint _amount ) internal returns ( uint ) {
940         if ( !_stake ) { // if user does not want to stake
941             IERC20( BTRFLY ).transfer( _recipient, _amount ); // send payout
942         } else { // if user wants to stake
943             if ( useHelper ) { // use if staking warmup is 0
944                 IERC20( BTRFLY ).approve( stakingHelper, _amount );
945                 IStakingHelper( stakingHelper ).stake( _amount, _recipient );
946             } else {
947                 IERC20( BTRFLY ).approve( staking, _amount );
948                 IStaking( staking ).stake( _amount, _recipient );
949             }
950         }
951         return _amount;
952     }
953 
954     /**
955      *  @notice makes incremental adjustment to control variable
956      */
957     function adjust() internal {
958         uint blockCanAdjust = adjustment.lastBlock.add( adjustment.buffer );
959         if( adjustment.rate != 0 && block.number >= blockCanAdjust ) {
960             uint initial = terms.controlVariable;
961             if ( adjustment.add ) {
962                 terms.controlVariable = terms.controlVariable.add( adjustment.rate );
963                 if ( terms.controlVariable >= adjustment.target ) {
964                     adjustment.rate = 0;
965                 }
966             } else {
967                 terms.controlVariable = terms.controlVariable.sub( adjustment.rate );
968                 if ( terms.controlVariable <= adjustment.target ) {
969                     adjustment.rate = 0;
970                 }
971             }
972             adjustment.lastBlock = block.number;
973             emit ControlVariableAdjustment( initial, terms.controlVariable, adjustment.rate, adjustment.add );
974         }
975     }
976 
977     /**
978      *  @notice reduce total debt
979      */
980     function decayDebt() internal {
981         totalDebt = totalDebt.sub( debtDecay() );
982         lastDecay = block.number;
983     }
984 
985 
986 
987 
988     /* ======== VIEW FUNCTIONS ======== */
989 
990     /**
991      *  @notice determine maximum bond size
992      *  @return uint
993      */
994     function maxPayout() public view returns ( uint ) {
995         return IERC20( BTRFLY ).totalSupply().mul( terms.maxPayout ).div( 100000 );
996     }
997 
998     /**
999      *  @notice calculate interest due for new bond
1000      *  @param _value uint
1001      *  @return uint
1002      */
1003     function payoutFor( uint _value ) public view returns ( uint ) {
1004         return FixedPoint.fraction( _value, bondPrice() ).decode112with18().div( 1e16 );
1005     }
1006 
1007 
1008     /**
1009      *  @notice calculate current bond premium
1010      *  @return price_ uint
1011      */
1012     function bondPrice() public view returns ( uint price_ ) {        
1013         price_ = terms.controlVariable.mul( debtRatio() ).add( ITreasury(treasury).getFloor(principal) ).div( 1e7 );
1014         if ( price_ < terms.minimumPrice ) {
1015             price_ = terms.minimumPrice;
1016         }
1017     }
1018 
1019     /**
1020      *  @notice calculate current bond price and remove floor if above
1021      *  @return price_ uint
1022      */
1023     function _bondPrice() internal returns ( uint price_ ) {
1024         price_ = terms.controlVariable.mul( debtRatio() ).add( ITreasury(treasury).getFloor(principal) ).div( 1e7 );
1025         if ( price_ < terms.minimumPrice ) {
1026             price_ = terms.minimumPrice;        
1027         } else if ( terms.minimumPrice != 0 ) {
1028             terms.minimumPrice = 0;
1029         }
1030     }
1031 
1032     /**
1033      *  @notice converts bond price to DAI value
1034      *  @return price_ uint
1035      */
1036     function bondPriceInUSD() public view returns ( uint price_ ) {
1037         if( isLiquidityBond ) {
1038             price_ = bondPrice().mul( IBondCalculator( bondCalculator ).markdown( principal ) ).div( 100 );
1039         } else {
1040             price_ = bondPrice().mul( 10 ** IERC20( principal ).decimals() ).div( 100 );
1041         }
1042     }
1043 
1044 
1045     /**
1046      *  @notice calculate current ratio of debt to BTRFLY supply
1047      *  @return debtRatio_ uint
1048      */
1049     function debtRatio() public view returns ( uint debtRatio_ ) {   
1050         uint supply = IERC20( BTRFLY ).totalSupply();
1051         debtRatio_ = FixedPoint.fraction( 
1052             currentDebt().mul( 1e9 ), 
1053             supply
1054         ).decode112with18().div( 1e18 );
1055     }
1056 
1057     /**
1058      *  @notice debt ratio in same terms for reserve or liquidity bonds
1059      *  @return uint
1060      */
1061     function standardizedDebtRatio() external view returns ( uint ) {
1062         if ( isLiquidityBond ) {
1063             return debtRatio().mul( IBondCalculator( bondCalculator ).markdown( principal ) ).div( 1e9 );
1064         } else {
1065             return debtRatio();
1066         }
1067     }
1068 
1069     /**
1070      *  @notice calculate debt factoring in decay
1071      *  @return uint
1072      */
1073     function currentDebt() public view returns ( uint ) {
1074         return totalDebt.sub( debtDecay() );
1075     }
1076 
1077     /**
1078      *  @notice amount to decay total debt by
1079      *  @return decay_ uint
1080      */
1081     function debtDecay() public view returns ( uint decay_ ) {
1082         uint blocksSinceLast = block.number.sub( lastDecay );
1083         decay_ = totalDebt.mul( blocksSinceLast ).div( terms.vestingTerm );
1084         if ( decay_ > totalDebt ) {
1085             decay_ = totalDebt;
1086         }
1087     }
1088 
1089 
1090     /**
1091      *  @notice calculate how far into vesting a depositor is
1092      *  @param _depositor address
1093      *  @return percentVested_ uint
1094      */
1095     function percentVestedFor( address _depositor ) public view returns ( uint percentVested_ ) {
1096         Bond memory bond = bondInfo[ _depositor ];
1097         uint blocksSinceLast = block.number.sub( bond.lastBlock );
1098         uint vesting = bond.vesting;
1099 
1100         if ( vesting > 0 ) {
1101             percentVested_ = blocksSinceLast.mul( 10000 ).div( vesting );
1102         } else {
1103             percentVested_ = 0;
1104         }
1105     }
1106 
1107     /**
1108      *  @notice calculate amount of BTRFLY available for claim by depositor
1109      *  @param _depositor address
1110      *  @return pendingPayout_ uint
1111      */
1112     function pendingPayoutFor( address _depositor ) external view returns ( uint pendingPayout_ ) {
1113         uint percentVested = percentVestedFor( _depositor );
1114         uint payout = bondInfo[ _depositor ].payout;
1115 
1116         if ( percentVested >= 10000 ) {
1117             pendingPayout_ = payout;
1118         } else {
1119             pendingPayout_ = payout.mul( percentVested ).div( 10000 );
1120         }
1121     }
1122 
1123 
1124 
1125 
1126     /* ======= AUXILLIARY ======= */
1127 
1128     /**
1129      *  @notice allow anyone to send lost tokens (excluding principal or BTRFLY) to the DAO
1130      *  @return bool
1131      */
1132     function recoverLostToken( address _token ) external returns ( bool ) {
1133         require( _token != BTRFLY );
1134         require( _token != principal );
1135         IERC20( _token ).safeTransfer( DAO, IERC20( _token ).balanceOf( address(this) ) );
1136         return true;
1137     }
1138 
1139     function setOLYMPUSTreasury( address _newTreasury ) external {
1140         require(msg.sender == OLYMPUSDAO || msg.sender == DAO, "UNAUTHORISED : YOU'RE NOT OLYMPUS OR REDACTED");
1141         OLYMPUSTreasury = _newTreasury;
1142     }
1143 
1144 
1145 
1146 }