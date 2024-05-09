1 // SPDX-License-Identifier: AGPL-3.0-or-later
2 pragma solidity 0.7.5;
3 
4 
5 interface IOwnable {
6   function policy() external view returns (address);
7 
8   function renounceManagement() external;
9   
10   function pushManagement( address newOwner_ ) external;
11   
12   function pullManagement() external;
13 }
14 
15 contract Ownable is IOwnable {
16 
17     address internal _owner;
18     address internal _newOwner;
19 
20     event OwnershipPushed(address indexed previousOwner, address indexed newOwner);
21     event OwnershipPulled(address indexed previousOwner, address indexed newOwner);
22 
23     constructor () {
24         _owner = msg.sender;
25         emit OwnershipPushed( address(0), _owner );
26     }
27 
28     function policy() public view override returns (address) {
29         return _owner;
30     }
31 
32     modifier onlyPolicy() {
33         require( _owner == msg.sender, "Ownable: caller is not the owner" );
34         _;
35     }
36 
37     function renounceManagement() public virtual override onlyPolicy() {
38         emit OwnershipPushed( _owner, address(0) );
39         _owner = address(0);
40     }
41 
42     function pushManagement( address newOwner_ ) public virtual override onlyPolicy() {
43         require( newOwner_ != address(0), "Ownable: new owner is the zero address");
44         emit OwnershipPushed( _owner, newOwner_ );
45         _newOwner = newOwner_;
46     }
47     
48     function pullManagement() public virtual override {
49         require( msg.sender == _newOwner, "Ownable: must be new owner to pull");
50         emit OwnershipPulled( _owner, _newOwner );
51         _owner = _newOwner;
52     }
53 }
54 
55 library SafeMath {
56 
57     function add(uint256 a, uint256 b) internal pure returns (uint256) {
58         uint256 c = a + b;
59         require(c >= a, "SafeMath: addition overflow");
60 
61         return c;
62     }
63 
64     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
65         return sub(a, b, "SafeMath: subtraction overflow");
66     }
67 
68     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
69         require(b <= a, errorMessage);
70         uint256 c = a - b;
71 
72         return c;
73     }
74 
75     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76         if (a == 0) {
77             return 0;
78         }
79 
80         uint256 c = a * b;
81         require(c / a == b, "SafeMath: multiplication overflow");
82 
83         return c;
84     }
85 
86     function div(uint256 a, uint256 b) internal pure returns (uint256) {
87         return div(a, b, "SafeMath: division by zero");
88     }
89 
90     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
91         require(b > 0, errorMessage);
92         uint256 c = a / b;
93         return c;
94     }
95 
96     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
97         return mod(a, b, "SafeMath: modulo by zero");
98     }
99 
100     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
101         require(b != 0, errorMessage);
102         return a % b;
103     }
104 
105     function sqrrt(uint256 a) internal pure returns (uint c) {
106         if (a > 3) {
107             c = a;
108             uint b = add( div( a, 2), 1 );
109             while (b < c) {
110                 c = b;
111                 b = div( add( div( a, b ), b), 2 );
112             }
113         } else if (a != 0) {
114             c = 1;
115         }
116     }
117 }
118 
119 library Address {
120 
121     function isContract(address account) internal view returns (bool) {
122 
123         uint256 size;
124         // solhint-disable-next-line no-inline-assembly
125         assembly { size := extcodesize(account) }
126         return size > 0;
127     }
128 
129     function sendValue(address payable recipient, uint256 amount) internal {
130         require(address(this).balance >= amount, "Address: insufficient balance");
131 
132         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
133         (bool success, ) = recipient.call{ value: amount }("");
134         require(success, "Address: unable to send value, recipient may have reverted");
135     }
136 
137     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
138       return functionCall(target, data, "Address: low-level call failed");
139     }
140 
141     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
142         return _functionCallWithValue(target, data, 0, errorMessage);
143     }
144 
145     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
146         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
147     }
148 
149     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
150         require(address(this).balance >= value, "Address: insufficient balance for call");
151         require(isContract(target), "Address: call to non-contract");
152 
153         // solhint-disable-next-line avoid-low-level-calls
154         (bool success, bytes memory returndata) = target.call{ value: value }(data);
155         return _verifyCallResult(success, returndata, errorMessage);
156     }
157 
158     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
159         require(isContract(target), "Address: call to non-contract");
160 
161         // solhint-disable-next-line avoid-low-level-calls
162         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
163         if (success) {
164             return returndata;
165         } else {
166             // Look for revert reason and bubble it up if present
167             if (returndata.length > 0) {
168                 // The easiest way to bubble the revert reason is using memory via assembly
169 
170                 // solhint-disable-next-line no-inline-assembly
171                 assembly {
172                     let returndata_size := mload(returndata)
173                     revert(add(32, returndata), returndata_size)
174                 }
175             } else {
176                 revert(errorMessage);
177             }
178         }
179     }
180 
181     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
182         return functionStaticCall(target, data, "Address: low-level static call failed");
183     }
184 
185     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
186         require(isContract(target), "Address: static call to non-contract");
187 
188         // solhint-disable-next-line avoid-low-level-calls
189         (bool success, bytes memory returndata) = target.staticcall(data);
190         return _verifyCallResult(success, returndata, errorMessage);
191     }
192 
193     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
194         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
195     }
196 
197     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
198         require(isContract(target), "Address: delegate call to non-contract");
199 
200         // solhint-disable-next-line avoid-low-level-calls
201         (bool success, bytes memory returndata) = target.delegatecall(data);
202         return _verifyCallResult(success, returndata, errorMessage);
203     }
204 
205     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
206         if (success) {
207             return returndata;
208         } else {
209             if (returndata.length > 0) {
210 
211                 assembly {
212                     let returndata_size := mload(returndata)
213                     revert(add(32, returndata), returndata_size)
214                 }
215             } else {
216                 revert(errorMessage);
217             }
218         }
219     }
220 
221     function addressToString(address _address) internal pure returns(string memory) {
222         bytes32 _bytes = bytes32(uint256(_address));
223         bytes memory HEX = "0123456789abcdef";
224         bytes memory _addr = new bytes(42);
225 
226         _addr[0] = '0';
227         _addr[1] = 'x';
228 
229         for(uint256 i = 0; i < 20; i++) {
230             _addr[2+i*2] = HEX[uint8(_bytes[i + 12] >> 4)];
231             _addr[3+i*2] = HEX[uint8(_bytes[i + 12] & 0x0f)];
232         }
233 
234         return string(_addr);
235 
236     }
237 }
238 
239 interface IERC20 {
240     function decimals() external view returns (uint8);
241 
242     function totalSupply() external view returns (uint256);
243 
244     function balanceOf(address account) external view returns (uint256);
245 
246     function transfer(address recipient, uint256 amount) external returns (bool);
247 
248     function allowance(address owner, address spender) external view returns (uint256);
249 
250     function approve(address spender, uint256 amount) external returns (bool);
251 
252     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
253 
254     event Transfer(address indexed from, address indexed to, uint256 value);
255 
256     event Approval(address indexed owner, address indexed spender, uint256 value);
257 }
258 
259 abstract contract ERC20 is IERC20 {
260 
261     using SafeMath for uint256;
262 
263     // TODO comment actual hash value.
264     bytes32 constant private ERC20TOKEN_ERC1820_INTERFACE_ID = keccak256( "ERC20Token" );
265     
266     mapping (address => uint256) internal _balances;
267 
268     mapping (address => mapping (address => uint256)) internal _allowances;
269 
270     uint256 internal _totalSupply;
271 
272     string internal _name;
273     
274     string internal _symbol;
275     
276     uint8 internal _decimals;
277 
278     constructor (string memory name_, string memory symbol_, uint8 decimals_) {
279         _name = name_;
280         _symbol = symbol_;
281         _decimals = decimals_;
282     }
283 
284     function name() public view returns (string memory) {
285         return _name;
286     }
287 
288     function symbol() public view returns (string memory) {
289         return _symbol;
290     }
291 
292     function decimals() public view override returns (uint8) {
293         return _decimals;
294     }
295 
296     function totalSupply() public view override returns (uint256) {
297         return _totalSupply;
298     }
299 
300     function balanceOf(address account) public view virtual override returns (uint256) {
301         return _balances[account];
302     }
303 
304     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
305         _transfer(msg.sender, recipient, amount);
306         return true;
307     }
308 
309     function allowance(address owner, address spender) public view virtual override returns (uint256) {
310         return _allowances[owner][spender];
311     }
312 
313     function approve(address spender, uint256 amount) public virtual override returns (bool) {
314         _approve(msg.sender, spender, amount);
315         return true;
316     }
317 
318     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
319         _transfer(sender, recipient, amount);
320         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
321         return true;
322     }
323 
324     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
325         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
326         return true;
327     }
328 
329     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
330         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
331         return true;
332     }
333 
334     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
335         require(sender != address(0), "ERC20: transfer from the zero address");
336         require(recipient != address(0), "ERC20: transfer to the zero address");
337 
338         _beforeTokenTransfer(sender, recipient, amount);
339 
340         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
341         _balances[recipient] = _balances[recipient].add(amount);
342         emit Transfer(sender, recipient, amount);
343     }
344 
345     function _mint(address account_, uint256 ammount_) internal virtual {
346         require(account_ != address(0), "ERC20: mint to the zero address");
347         _beforeTokenTransfer(address( this ), account_, ammount_);
348         _totalSupply = _totalSupply.add(ammount_);
349         _balances[account_] = _balances[account_].add(ammount_);
350         emit Transfer(address( this ), account_, ammount_);
351     }
352 
353     function _burn(address account, uint256 amount) internal virtual {
354         require(account != address(0), "ERC20: burn from the zero address");
355 
356         _beforeTokenTransfer(account, address(0), amount);
357 
358         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
359         _totalSupply = _totalSupply.sub(amount);
360         emit Transfer(account, address(0), amount);
361     }
362 
363     function _approve(address owner, address spender, uint256 amount) internal virtual {
364         require(owner != address(0), "ERC20: approve from the zero address");
365         require(spender != address(0), "ERC20: approve to the zero address");
366 
367         _allowances[owner][spender] = amount;
368         emit Approval(owner, spender, amount);
369     }
370 
371   function _beforeTokenTransfer( address from_, address to_, uint256 amount_ ) internal virtual { }
372 }
373 
374 interface IERC2612Permit {
375 
376     function permit(
377         address owner,
378         address spender,
379         uint256 amount,
380         uint256 deadline,
381         uint8 v,
382         bytes32 r,
383         bytes32 s
384     ) external;
385 
386     function nonces(address owner) external view returns (uint256);
387 }
388 
389 library Counters {
390     using SafeMath for uint256;
391 
392     struct Counter {
393 
394         uint256 _value; // default: 0
395     }
396 
397     function current(Counter storage counter) internal view returns (uint256) {
398         return counter._value;
399     }
400 
401     function increment(Counter storage counter) internal {
402         counter._value += 1;
403     }
404 
405     function decrement(Counter storage counter) internal {
406         counter._value = counter._value.sub(1);
407     }
408 }
409 
410 abstract contract ERC20Permit is ERC20, IERC2612Permit {
411     using Counters for Counters.Counter;
412 
413     mapping(address => Counters.Counter) private _nonces;
414 
415     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
416     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
417 
418     bytes32 public DOMAIN_SEPARATOR;
419 
420     constructor() {
421         uint256 chainID;
422         assembly {
423             chainID := chainid()
424         }
425 
426         DOMAIN_SEPARATOR = keccak256(
427             abi.encode(
428                 keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
429                 keccak256(bytes(name())),
430                 keccak256(bytes("1")), // Version
431                 chainID,
432                 address(this)
433             )
434         );
435     }
436 
437     function permit(
438         address owner,
439         address spender,
440         uint256 amount,
441         uint256 deadline,
442         uint8 v,
443         bytes32 r,
444         bytes32 s
445     ) public virtual override {
446         require(block.timestamp <= deadline, "Permit: expired deadline");
447 
448         bytes32 hashStruct =
449             keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, amount, _nonces[owner].current(), deadline));
450 
451         bytes32 _hash = keccak256(abi.encodePacked(uint16(0x1901), DOMAIN_SEPARATOR, hashStruct));
452 
453         address signer = ecrecover(_hash, v, r, s);
454         require(signer != address(0) && signer == owner, "ZeroSwapPermit: Invalid signature");
455 
456         _nonces[owner].increment();
457         _approve(owner, spender, amount);
458     }
459 
460     function nonces(address owner) public view override returns (uint256) {
461         return _nonces[owner].current();
462     }
463 }
464 
465 library SafeERC20 {
466     using SafeMath for uint256;
467     using Address for address;
468 
469     function safeTransfer(IERC20 token, address to, uint256 value) internal {
470         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
471     }
472 
473     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
474         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
475     }
476 
477     function safeApprove(IERC20 token, address spender, uint256 value) internal {
478 
479         require((value == 0) || (token.allowance(address(this), spender) == 0),
480             "SafeERC20: approve from non-zero to non-zero allowance"
481         );
482         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
483     }
484 
485     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
486         uint256 newAllowance = token.allowance(address(this), spender).add(value);
487         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
488     }
489 
490     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
491         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
492         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
493     }
494 
495     function _callOptionalReturn(IERC20 token, bytes memory data) private {
496 
497         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
498         if (returndata.length > 0) { // Return data is optional
499             // solhint-disable-next-line max-line-length
500             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
501         }
502     }
503 }
504 
505 library FullMath {
506     function fullMul(uint256 x, uint256 y) private pure returns (uint256 l, uint256 h) {
507         uint256 mm = mulmod(x, y, uint256(-1));
508         l = x * y;
509         h = mm - l;
510         if (mm < l) h -= 1;
511     }
512 
513     function fullDiv(
514         uint256 l,
515         uint256 h,
516         uint256 d
517     ) private pure returns (uint256) {
518         uint256 pow2 = d & -d;
519         d /= pow2;
520         l /= pow2;
521         l += h * ((-pow2) / pow2 + 1);
522         uint256 r = 1;
523         r *= 2 - d * r;
524         r *= 2 - d * r;
525         r *= 2 - d * r;
526         r *= 2 - d * r;
527         r *= 2 - d * r;
528         r *= 2 - d * r;
529         r *= 2 - d * r;
530         r *= 2 - d * r;
531         return l * r;
532     }
533 
534     function mulDiv(
535         uint256 x,
536         uint256 y,
537         uint256 d
538     ) internal pure returns (uint256) {
539         (uint256 l, uint256 h) = fullMul(x, y);
540         uint256 mm = mulmod(x, y, d);
541         if (mm > l) h -= 1;
542         l -= mm;
543         require(h < d, 'FullMath::mulDiv: overflow');
544         return fullDiv(l, h, d);
545     }
546 }
547 
548 library FixedPoint {
549 
550     struct uq112x112 {
551         uint224 _x;
552     }
553 
554     struct uq144x112 {
555         uint256 _x;
556     }
557 
558     uint8 private constant RESOLUTION = 112;
559     uint256 private constant Q112 = 0x10000000000000000000000000000;
560     uint256 private constant Q224 = 0x100000000000000000000000000000000000000000000000000000000;
561     uint256 private constant LOWER_MASK = 0xffffffffffffffffffffffffffff; // decimal of UQ*x112 (lower 112 bits)
562 
563     function decode(uq112x112 memory self) internal pure returns (uint112) {
564         return uint112(self._x >> RESOLUTION);
565     }
566 
567     function decode112with18(uq112x112 memory self) internal pure returns (uint) {
568 
569         return uint(self._x) / 5192296858534827;
570     }
571 
572     function fraction(uint256 numerator, uint256 denominator) internal pure returns (uq112x112 memory) {
573         require(denominator > 0, 'FixedPoint::fraction: division by zero');
574         if (numerator == 0) return FixedPoint.uq112x112(0);
575 
576         if (numerator <= uint144(-1)) {
577             uint256 result = (numerator << RESOLUTION) / denominator;
578             require(result <= uint224(-1), 'FixedPoint::fraction: overflow');
579             return uq112x112(uint224(result));
580         } else {
581             uint256 result = FullMath.mulDiv(numerator, Q112, denominator);
582             require(result <= uint224(-1), 'FixedPoint::fraction: overflow');
583             return uq112x112(uint224(result));
584         }
585     }
586 }
587 
588 interface ITreasury {
589     function deposit( uint _amount, address _token, uint _profit ) external returns ( bool );
590     function valueOf( address _token, uint _amount ) external view returns ( uint value_ );
591     function getFloor(address _token) external view returns(uint);
592     function mintRewards(address _recipient, uint _amount ) external;
593 }
594 
595 interface IBondCalculator {
596     function valuation( address _LP, uint _amount ) external view returns ( uint );
597     function markdown( address _LP ) external view returns ( uint );
598 }
599 
600 interface IStaking {
601     function stake( uint _amount, address _recipient ) external returns ( bool );
602 }
603 
604 interface IStakingHelper {
605     function stake( uint _amount, address _recipient ) external;
606 }
607 
608 contract REDACTEDBondDepositoryRewardBased is Ownable {
609 
610     using FixedPoint for *;
611     using SafeERC20 for IERC20;
612     using SafeMath for uint;
613 
614 
615 
616 
617     /* ======== EVENTS ======== */
618 
619     event BondCreated( uint deposit, uint indexed payout, uint indexed expires, uint indexed nativePrice );
620     event BondRedeemed( address indexed recipient, uint payout, uint remaining );
621     event BondPriceChanged( uint indexed nativePrice, uint indexed internalPrice, uint indexed debtRatio );
622     event ControlVariableAdjustment( uint initialBCV, uint newBCV, uint adjustment, bool addition );
623 
624 
625 
626 
627     /* ======== STATE VARIABLES ======== */
628 
629     address public immutable BTRFLY; // token given as payment for bond
630     address public immutable principal; // token used to create bond
631     address public immutable OLYMPUSDAO; // we pay homage to these guys :) (tithe/ti-the hahahahhahah)
632     address public immutable treasury; // mints BTRFLY when receives principal
633     address public immutable DAO; // receives profit share from bond
634     address public OLYMPUSTreasury; // Olympus treasury can be updated by the OLYMPUSDAO
635 
636     bool public immutable isLiquidityBond; // LP and Reserve bonds are treated slightly different
637     address public immutable bondCalculator; // calculates value of LP tokens
638 
639     address public staking; // to auto-stake payout
640     address public stakingHelper; // to stake and claim if no staking warmup
641     bool public useHelper;
642 
643     Terms public terms; // stores terms for new bonds
644     Adjust public adjustment; // stores adjustment to BCV data
645 
646     mapping( address => Bond ) public bondInfo; // stores bond information for depositors
647 
648     uint public totalDebt; // total value of outstanding bonds; used for pricing
649     uint public lastDecay; // reference block for debt decay
650 
651 
652 
653 
654     /* ======== STRUCTS ======== */
655 
656     // Info for creating new bonds
657     struct Terms {
658         uint controlVariable; // scaling variable for price
659         uint vestingTerm; // in blocks
660         uint minimumPrice; // vs principal value
661         uint maxPayout; // in thousandths of a %. i.e. 500 = 0.5%
662         uint fee; // as % of bond payout, in hundreths. ( 500 = 5% = 0.05 for every 1 paid)
663         uint tithe; // in thousandths of a %. i.e. 500 = 0.5%
664         uint maxDebt; // 9 decimal debt ratio, max % total supply created as debt
665     }
666 
667     // Info for bond holder
668     struct Bond {
669         uint payout; // BTRFLY remaining to be paid
670         uint vesting; // Blocks left to vest
671         uint lastBlock; // Last interaction
672         uint pricePaid; // In native asset, for front end viewing
673     }
674 
675     // Info for incremental adjustments to control variable 
676     struct Adjust {
677         bool add; // addition or subtraction
678         uint rate; // increment
679         uint target; // BCV when adjustment finished
680         uint buffer; // minimum length (in blocks) between adjustments
681         uint lastBlock; // block when last adjustment made
682     }
683 
684 
685 
686 
687     /* ======== INITIALIZATION ======== */
688 
689     constructor ( 
690         address _BTRFLY,
691         address _principal,
692         address _treasury, 
693         address _DAO, 
694         address _bondCalculator,
695         address _OLYMPUSDAO,
696         address _OLYMPUSTreasury
697     ) {
698         require( _BTRFLY != address(0) );
699         BTRFLY = _BTRFLY;
700         require( _principal != address(0) );
701         principal = _principal;
702         require( _treasury != address(0) );
703         treasury = _treasury;
704         require( _DAO != address(0) );
705         DAO = _DAO;
706         // bondCalculator should be address(0) if not LP bond
707         bondCalculator = _bondCalculator;
708         isLiquidityBond = ( _bondCalculator != address(0) );
709         OLYMPUSDAO = _OLYMPUSDAO;
710         OLYMPUSTreasury = _OLYMPUSTreasury;
711     }
712 
713     /**
714      *  @notice initializes bond parameters
715      *  @param _controlVariable uint
716      *  @param _vestingTerm uint
717      *  @param _minimumPrice uint
718      *  @param _maxPayout uint
719      *  @param _fee uint
720      *  @param _maxDebt uint
721      *  @param _initialDebt uint
722      */
723     function initializeBondTerms( 
724         uint _controlVariable, 
725         uint _vestingTerm,
726         uint _minimumPrice,
727         uint _maxPayout,
728         uint _fee,
729         uint _maxDebt,
730         uint _tithe,
731         uint _initialDebt
732     ) external onlyPolicy() {
733         require( terms.controlVariable == 0, "Bonds must be initialized from 0" );
734         terms = Terms ({
735             controlVariable: _controlVariable,
736             vestingTerm: _vestingTerm,
737             minimumPrice: _minimumPrice,
738             maxPayout: _maxPayout,
739             fee: _fee,
740             maxDebt: _maxDebt,
741             tithe: _tithe
742         });
743         totalDebt = _initialDebt;
744         lastDecay = block.number;
745     }
746 
747 
748 
749     
750     /* ======== POLICY FUNCTIONS ======== */
751 
752     enum PARAMETER { VESTING, PAYOUT, FEE, DEBT }
753     /**
754      *  @notice set parameters for new bonds
755      *  @param _parameter PARAMETER
756      *  @param _input uint
757      */
758     function setBondTerms ( PARAMETER _parameter, uint _input ) external onlyPolicy() {
759         if ( _parameter == PARAMETER.VESTING ) { // 0
760             require( _input >= 10000, "Vesting must be longer than 36 hours" );
761             terms.vestingTerm = _input;
762         } else if ( _parameter == PARAMETER.PAYOUT ) { // 1
763             require( _input <= 1000, "Payout cannot be above 1 percent" );
764             terms.maxPayout = _input;
765         } else if ( _parameter == PARAMETER.FEE ) { // 2
766             require( _input <= 10000, "DAO fee cannot exceed payout" );
767             terms.fee = _input;
768         } else if ( _parameter == PARAMETER.DEBT ) { // 3
769             terms.maxDebt = _input;
770         }
771     }
772 
773     /**
774      *  @notice set control variable adjustment
775      *  @param _addition bool
776      *  @param _increment uint
777      *  @param _target uint
778      *  @param _buffer uint
779      */
780     function setAdjustment ( 
781         bool _addition,
782         uint _increment, 
783         uint _target,
784         uint _buffer 
785     ) external onlyPolicy() {
786         require( _increment <= terms.controlVariable.mul( 25 ).div( 1000 ), "Increment too large" );
787 
788         adjustment = Adjust({
789             add: _addition,
790             rate: _increment,
791             target: _target,
792             buffer: _buffer,
793             lastBlock: block.number
794         });
795     }
796 
797     /**
798      *  @notice set contract for auto stake
799      *  @param _staking address
800      *  @param _helper bool
801      */
802     function setStaking( address _staking, bool _helper ) external onlyPolicy() {
803         require( _staking != address(0) );
804         if ( _helper ) {
805             useHelper = true;
806             stakingHelper = _staking;
807         } else {
808             useHelper = false;
809             staking = _staking;
810         }
811     }
812 
813 
814     
815 
816     /* ======== USER FUNCTIONS ======== */
817 
818     /**
819      *  @notice deposit bond
820      *  @param _amount uint
821      *  @param _maxPrice uint
822      *  @param _depositor address
823      *  @return uint
824      */
825     function deposit( 
826         uint _amount, 
827         uint _maxPrice,
828         address _depositor
829     ) external returns ( uint ) {
830         require( _depositor != address(0), "Invalid address" );
831         require( _depositor == msg.sender , "Depositor not msg.sender" );
832 
833         decayDebt();
834         require( totalDebt <= terms.maxDebt, "Max capacity reached" );
835         
836         uint nativePrice = _bondPrice();
837 
838         require( _maxPrice >= nativePrice, "Slippage limit: more than max price" ); // slippage protection
839 
840         uint tithePrincipal = _amount.mul(terms.tithe).div(100000);
841 
842         uint value = ITreasury( treasury ).valueOf( principal, _amount );
843         uint payout = payoutFor( value ); // payout to bonder is computed
844 
845         require( payout >= 10000000, "Bond too small" ); // must be > 0.01 BTRFLY ( underflow protection )
846         require( payout <= maxPayout(), "Bond too large"); // size protection because there is no slippage
847 
848         /**
849             principal is transferred in
850             approved and
851             deposited into the treasury, returning (_amount - profit) BTRFLY
852          */
853         IERC20( principal ).safeTransferFrom( msg.sender, address(this), _amount );
854         IERC20( principal ).safeTransfer( OLYMPUSTreasury, tithePrincipal );
855 
856         uint amountDeposit = _amount.sub(tithePrincipal);
857         IERC20( principal ).safeTransfer( address( treasury ), amountDeposit );
858 
859         //call mintRewards
860         uint titheBTRFLY = payout.mul(terms.tithe).div(100000);
861         uint fee = payout.mul( terms.fee ).div( 100000 );
862         uint totalMint = titheBTRFLY.add(fee).add(payout);
863 
864         ITreasury(treasury).mintRewards(address(this),totalMint);
865         
866         // fee is transferred to daos
867         IERC20( BTRFLY ).safeTransfer( DAO, fee ); 
868         IERC20( BTRFLY ).safeTransfer( OLYMPUSTreasury, titheBTRFLY );
869         
870         // total debt is increased
871         totalDebt = totalDebt.add( value ); 
872                 
873         // depositor info is stored
874         bondInfo[ _depositor ] = Bond({ 
875             payout: bondInfo[ _depositor ].payout.add( payout ),
876             vesting: terms.vestingTerm,
877             lastBlock: block.number,
878             pricePaid: nativePrice
879         });
880 
881         // indexed events are emitted
882         emit BondCreated( _amount, payout, block.number.add( terms.vestingTerm ), nativePrice );
883         //emit BondPriceChanged( bondPriceInUSD(), _bondPrice(), debtRatio() );
884 
885         adjust(); // control variable is adjusted
886         return payout; 
887     }
888 
889     /** 
890      *  @notice redeem bond for user
891      *  @param _recipient address
892      *  @param _stake bool
893      *  @return uint
894      */ 
895     function redeem( address _recipient, bool _stake ) external returns ( uint ) {        
896         Bond memory info = bondInfo[ _recipient ];
897         uint percentVested = percentVestedFor( _recipient ); // (blocks since last interaction / vesting term remaining)
898 
899         if ( percentVested >= 10000 ) { // if fully vested
900             delete bondInfo[ _recipient ]; // delete user info
901             emit BondRedeemed( _recipient, info.payout, 0 ); // emit bond data
902             return stakeOrSend( _recipient, _stake, info.payout ); // pay user everything due
903 
904         } else { // if unfinished
905             // calculate payout vested
906             uint payout = info.payout.mul( percentVested ).div( 10000 );
907 
908             // store updated deposit info
909             bondInfo[ _recipient ] = Bond({
910                 payout: info.payout.sub( payout ),
911                 vesting: info.vesting.sub( block.number.sub( info.lastBlock ) ),
912                 lastBlock: block.number,
913                 pricePaid: info.pricePaid
914             });
915 
916             emit BondRedeemed( _recipient, payout, bondInfo[ _recipient ].payout );
917             return stakeOrSend( _recipient, _stake, payout );
918         }
919     }
920 
921 
922 
923     
924     /* ======== INTERNAL HELPER FUNCTIONS ======== */
925 
926     /**
927      *  @notice allow user to stake payout automatically
928      *  @param _stake bool
929      *  @param _amount uint
930      *  @return uint
931      */
932     function stakeOrSend( address _recipient, bool _stake, uint _amount ) internal returns ( uint ) {
933         if ( !_stake ) { // if user does not want to stake
934             IERC20( BTRFLY ).transfer( _recipient, _amount ); // send payout
935         } else { // if user wants to stake
936             if ( useHelper ) { // use if staking warmup is 0
937                 IERC20( BTRFLY ).approve( stakingHelper, _amount );
938                 IStakingHelper( stakingHelper ).stake( _amount, _recipient );
939             } else {
940                 IERC20( BTRFLY ).approve( staking, _amount );
941                 IStaking( staking ).stake( _amount, _recipient );
942             }
943         }
944         return _amount;
945     }
946 
947     /**
948      *  @notice makes incremental adjustment to control variable
949      */
950     function adjust() internal {
951         uint blockCanAdjust = adjustment.lastBlock.add( adjustment.buffer );
952         if( adjustment.rate != 0 && block.number >= blockCanAdjust ) {
953             uint initial = terms.controlVariable;
954             if ( adjustment.add ) {
955                 terms.controlVariable = terms.controlVariable.add( adjustment.rate );
956                 if ( terms.controlVariable >= adjustment.target ) {
957                     adjustment.rate = 0;
958                 }
959             } else {
960                 terms.controlVariable = terms.controlVariable.sub( adjustment.rate );
961                 if ( terms.controlVariable <= adjustment.target ) {
962                     adjustment.rate = 0;
963                 }
964             }
965             adjustment.lastBlock = block.number;
966             emit ControlVariableAdjustment( initial, terms.controlVariable, adjustment.rate, adjustment.add );
967         }
968     }
969 
970     /**
971      *  @notice reduce total debt
972      */
973     function decayDebt() internal {
974         totalDebt = totalDebt.sub( debtDecay() );
975         lastDecay = block.number;
976     }
977 
978 
979 
980 
981     /* ======== VIEW FUNCTIONS ======== */
982 
983     /**
984      *  @notice determine maximum bond size
985      *  @return uint
986      */
987     function maxPayout() public view returns ( uint ) {
988         return IERC20( BTRFLY ).totalSupply().mul( terms.maxPayout ).div( 100000 );
989     }
990 
991     /**
992      *  @notice calculate interest due for new bond
993      *  @param _value uint
994      *  @return uint
995      */
996     function payoutFor( uint _value ) public view returns ( uint ) {
997         return FixedPoint.fraction( _value, bondPrice() ).decode112with18().div( 1e16 );
998     }
999 
1000 
1001     /**
1002      *  @notice calculate current bond premium
1003      *  @return price_ uint
1004      */
1005     function bondPrice() public view returns ( uint price_ ) {        
1006         price_ = terms.controlVariable.mul( debtRatio() ).add( ITreasury(treasury).getFloor(principal) ).div( 1e7 );
1007         if ( price_ < terms.minimumPrice ) {
1008             price_ = terms.minimumPrice;
1009         }
1010     }
1011 
1012     /**
1013      *  @notice calculate current bond price and remove floor if above
1014      *  @return price_ uint
1015      */
1016     function _bondPrice() internal returns ( uint price_ ) {
1017         price_ = terms.controlVariable.mul( debtRatio() ).add( ITreasury(treasury).getFloor(principal) ).div( 1e7 );
1018         if ( price_ < terms.minimumPrice ) {
1019             price_ = terms.minimumPrice;        
1020         } else if ( terms.minimumPrice != 0 ) {
1021             terms.minimumPrice = 0;
1022         }
1023     }
1024 
1025     /**
1026      *  @notice converts bond price to DAI value
1027      *  @return price_ uint
1028      */
1029     function bondPriceInUSD() public view returns ( uint price_ ) {
1030         if( isLiquidityBond ) {
1031             price_ = bondPrice().mul( IBondCalculator( bondCalculator ).markdown( principal ) ).div( 100 );
1032         } else {
1033             price_ = bondPrice().mul( 10 ** IERC20( principal ).decimals() ).div( 100 );
1034         }
1035     }
1036 
1037 
1038     /**
1039      *  @notice calculate current ratio of debt to BTRFLY supply
1040      *  @return debtRatio_ uint
1041      */
1042     function debtRatio() public view returns ( uint debtRatio_ ) {   
1043         uint supply = IERC20( BTRFLY ).totalSupply();
1044         debtRatio_ = FixedPoint.fraction( 
1045             currentDebt().mul( 1e9 ), 
1046             supply
1047         ).decode112with18().div( 1e18 );
1048     }
1049 
1050     /**
1051      *  @notice debt ratio in same terms for reserve or liquidity bonds
1052      *  @return uint
1053      */
1054     function standardizedDebtRatio() external view returns ( uint ) {
1055         if ( isLiquidityBond ) {
1056             return debtRatio().mul( IBondCalculator( bondCalculator ).markdown( principal ) ).div( 1e9 );
1057         } else {
1058             return debtRatio();
1059         }
1060     }
1061 
1062     /**
1063      *  @notice calculate debt factoring in decay
1064      *  @return uint
1065      */
1066     function currentDebt() public view returns ( uint ) {
1067         return totalDebt.sub( debtDecay() );
1068     }
1069 
1070     /**
1071      *  @notice amount to decay total debt by
1072      *  @return decay_ uint
1073      */
1074     function debtDecay() public view returns ( uint decay_ ) {
1075         uint blocksSinceLast = block.number.sub( lastDecay );
1076         decay_ = totalDebt.mul( blocksSinceLast ).div( terms.vestingTerm );
1077         if ( decay_ > totalDebt ) {
1078             decay_ = totalDebt;
1079         }
1080     }
1081 
1082 
1083     /**
1084      *  @notice calculate how far into vesting a depositor is
1085      *  @param _depositor address
1086      *  @return percentVested_ uint
1087      */
1088     function percentVestedFor( address _depositor ) public view returns ( uint percentVested_ ) {
1089         Bond memory bond = bondInfo[ _depositor ];
1090         uint blocksSinceLast = block.number.sub( bond.lastBlock );
1091         uint vesting = bond.vesting;
1092 
1093         if ( vesting > 0 ) {
1094             percentVested_ = blocksSinceLast.mul( 10000 ).div( vesting );
1095         } else {
1096             percentVested_ = 0;
1097         }
1098     }
1099 
1100     /**
1101      *  @notice calculate amount of BTRFLY available for claim by depositor
1102      *  @param _depositor address
1103      *  @return pendingPayout_ uint
1104      */
1105     function pendingPayoutFor( address _depositor ) external view returns ( uint pendingPayout_ ) {
1106         uint percentVested = percentVestedFor( _depositor );
1107         uint payout = bondInfo[ _depositor ].payout;
1108 
1109         if ( percentVested >= 10000 ) {
1110             pendingPayout_ = payout;
1111         } else {
1112             pendingPayout_ = payout.mul( percentVested ).div( 10000 );
1113         }
1114     }
1115 
1116 
1117 
1118 
1119     /* ======= AUXILLIARY ======= */
1120 
1121     /**
1122      *  @notice allow anyone to send lost tokens (excluding principal or BTRFLY) to the DAO
1123      *  @return bool
1124      */
1125     function recoverLostToken( address _token ) external returns ( bool ) {
1126         require( _token != BTRFLY );
1127         require( _token != principal );
1128         IERC20( _token ).safeTransfer( DAO, IERC20( _token ).balanceOf( address(this) ) );
1129         return true;
1130     }
1131 
1132     function setOLYMPUSTreasury( address _newTreasury ) external {
1133         require(msg.sender == OLYMPUSDAO || msg.sender == DAO, "UNAUTHORISED : YOU'RE NOT OLYMPUS OR REDACTED");
1134         OLYMPUSTreasury = _newTreasury;
1135     }
1136 
1137 
1138 
1139 }