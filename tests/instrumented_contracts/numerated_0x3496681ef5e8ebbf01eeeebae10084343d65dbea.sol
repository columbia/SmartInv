1 // SPDX-License-Identifier: AGPL-3.0-or-later
2 pragma solidity 0.7.5;
3 
4 //import "hardhat/console.sol";
5 
6 interface IOwnable {
7   function policy() external view returns (address);
8 
9   function renounceManagement() external;
10   
11   function pushManagement( address newOwner_ ) external;
12   
13   function pullManagement() external;
14 }
15 
16 contract Ownable is IOwnable {
17 
18     address internal _owner;
19     address internal _newOwner;
20 
21     event OwnershipPushed(address indexed previousOwner, address indexed newOwner);
22     event OwnershipPulled(address indexed previousOwner, address indexed newOwner);
23 
24     constructor () {
25         _owner = msg.sender;
26         emit OwnershipPushed( address(0), _owner );
27     }
28 
29     function policy() public view override returns (address) {
30         return _owner;
31     }
32 
33     modifier onlyPolicy() {
34         require( _owner == msg.sender, "Ownable: caller is not the owner" );
35         _;
36     }
37 
38     function renounceManagement() public virtual override onlyPolicy() {
39         emit OwnershipPushed( _owner, address(0) );
40         _owner = address(0);
41     }
42 
43     function pushManagement( address newOwner_ ) public virtual override onlyPolicy() {
44         require( newOwner_ != address(0), "Ownable: new owner is the zero address");
45         emit OwnershipPushed( _owner, newOwner_ );
46         _newOwner = newOwner_;
47     }
48     
49     function pullManagement() public virtual override {
50         require( msg.sender == _newOwner, "Ownable: must be new owner to pull");
51         emit OwnershipPulled( _owner, _newOwner );
52         _owner = _newOwner;
53     }
54 }
55 
56 library SafeMath {
57 
58     function add(uint256 a, uint256 b) internal pure returns (uint256) {
59         uint256 c = a + b;
60         require(c >= a, "SafeMath: addition overflow");
61 
62         return c;
63     }
64 
65     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66         return sub(a, b, "SafeMath: subtraction overflow");
67     }
68 
69     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
70         require(b <= a, errorMessage);
71         uint256 c = a - b;
72 
73         return c;
74     }
75 
76     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
77         if (a == 0) {
78             return 0;
79         }
80 
81         uint256 c = a * b;
82         require(c / a == b, "SafeMath: multiplication overflow");
83 
84         return c;
85     }
86 
87     function div(uint256 a, uint256 b) internal pure returns (uint256) {
88         return div(a, b, "SafeMath: division by zero");
89     }
90 
91     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
92         require(b > 0, errorMessage);
93         uint256 c = a / b;
94         return c;
95     }
96 
97     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
98         return mod(a, b, "SafeMath: modulo by zero");
99     }
100 
101     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
102         require(b != 0, errorMessage);
103         return a % b;
104     }
105 
106     function sqrrt(uint256 a) internal pure returns (uint c) {
107         if (a > 3) {
108             c = a;
109             uint b = add( div( a, 2), 1 );
110             while (b < c) {
111                 c = b;
112                 b = div( add( div( a, b ), b), 2 );
113             }
114         } else if (a != 0) {
115             c = 1;
116         }
117     }
118 }
119 
120 library Address {
121 
122     function isContract(address account) internal view returns (bool) {
123 
124         uint256 size;
125         // solhint-disable-next-line no-inline-assembly
126         assembly { size := extcodesize(account) }
127         return size > 0;
128     }
129 
130     function sendValue(address payable recipient, uint256 amount) internal {
131         require(address(this).balance >= amount, "Address: insufficient balance");
132 
133         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
134         (bool success, ) = recipient.call{ value: amount }("");
135         require(success, "Address: unable to send value, recipient may have reverted");
136     }
137 
138     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
139       return functionCall(target, data, "Address: low-level call failed");
140     }
141 
142     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
143         return _functionCallWithValue(target, data, 0, errorMessage);
144     }
145 
146     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
147         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
148     }
149 
150     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
151         require(address(this).balance >= value, "Address: insufficient balance for call");
152         require(isContract(target), "Address: call to non-contract");
153 
154         // solhint-disable-next-line avoid-low-level-calls
155         (bool success, bytes memory returndata) = target.call{ value: value }(data);
156         return _verifyCallResult(success, returndata, errorMessage);
157     }
158 
159     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
160         require(isContract(target), "Address: call to non-contract");
161 
162         // solhint-disable-next-line avoid-low-level-calls
163         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
164         if (success) {
165             return returndata;
166         } else {
167             // Look for revert reason and bubble it up if present
168             if (returndata.length > 0) {
169                 // The easiest way to bubble the revert reason is using memory via assembly
170 
171                 // solhint-disable-next-line no-inline-assembly
172                 assembly {
173                     let returndata_size := mload(returndata)
174                     revert(add(32, returndata), returndata_size)
175                 }
176             } else {
177                 revert(errorMessage);
178             }
179         }
180     }
181 
182     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
183         return functionStaticCall(target, data, "Address: low-level static call failed");
184     }
185 
186     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
187         require(isContract(target), "Address: static call to non-contract");
188 
189         // solhint-disable-next-line avoid-low-level-calls
190         (bool success, bytes memory returndata) = target.staticcall(data);
191         return _verifyCallResult(success, returndata, errorMessage);
192     }
193 
194     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
195         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
196     }
197 
198     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
199         require(isContract(target), "Address: delegate call to non-contract");
200 
201         // solhint-disable-next-line avoid-low-level-calls
202         (bool success, bytes memory returndata) = target.delegatecall(data);
203         return _verifyCallResult(success, returndata, errorMessage);
204     }
205 
206     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
207         if (success) {
208             return returndata;
209         } else {
210             if (returndata.length > 0) {
211 
212                 assembly {
213                     let returndata_size := mload(returndata)
214                     revert(add(32, returndata), returndata_size)
215                 }
216             } else {
217                 revert(errorMessage);
218             }
219         }
220     }
221 
222     function addressToString(address _address) internal pure returns(string memory) {
223         bytes32 _bytes = bytes32(uint256(_address));
224         bytes memory HEX = "0123456789abcdef";
225         bytes memory _addr = new bytes(42);
226 
227         _addr[0] = '0';
228         _addr[1] = 'x';
229 
230         for(uint256 i = 0; i < 20; i++) {
231             _addr[2+i*2] = HEX[uint8(_bytes[i + 12] >> 4)];
232             _addr[3+i*2] = HEX[uint8(_bytes[i + 12] & 0x0f)];
233         }
234 
235         return string(_addr);
236 
237     }
238 }
239 
240 interface IERC20 {
241     function decimals() external view returns (uint8);
242 
243     function totalSupply() external view returns (uint256);
244 
245     function balanceOf(address account) external view returns (uint256);
246 
247     function transfer(address recipient, uint256 amount) external returns (bool);
248 
249     function allowance(address owner, address spender) external view returns (uint256);
250 
251     function approve(address spender, uint256 amount) external returns (bool);
252 
253     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
254 
255     event Transfer(address indexed from, address indexed to, uint256 value);
256 
257     event Approval(address indexed owner, address indexed spender, uint256 value);
258 }
259 
260 abstract contract ERC20 is IERC20 {
261 
262     using SafeMath for uint256;
263 
264     // TODO comment actual hash value.
265     bytes32 constant private ERC20TOKEN_ERC1820_INTERFACE_ID = keccak256( "ERC20Token" );
266     
267     mapping (address => uint256) internal _balances;
268 
269     mapping (address => mapping (address => uint256)) internal _allowances;
270 
271     uint256 internal _totalSupply;
272 
273     string internal _name;
274     
275     string internal _symbol;
276     
277     uint8 internal _decimals;
278 
279     constructor (string memory name_, string memory symbol_, uint8 decimals_) {
280         _name = name_;
281         _symbol = symbol_;
282         _decimals = decimals_;
283     }
284 
285     function name() public view returns (string memory) {
286         return _name;
287     }
288 
289     function symbol() public view returns (string memory) {
290         return _symbol;
291     }
292 
293     function decimals() public view override returns (uint8) {
294         return _decimals;
295     }
296 
297     function totalSupply() public view override returns (uint256) {
298         return _totalSupply;
299     }
300 
301     function balanceOf(address account) public view virtual override returns (uint256) {
302         return _balances[account];
303     }
304 
305     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
306         _transfer(msg.sender, recipient, amount);
307         return true;
308     }
309 
310     function allowance(address owner, address spender) public view virtual override returns (uint256) {
311         return _allowances[owner][spender];
312     }
313 
314     function approve(address spender, uint256 amount) public virtual override returns (bool) {
315         _approve(msg.sender, spender, amount);
316         return true;
317     }
318 
319     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
320         _transfer(sender, recipient, amount);
321         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
322         return true;
323     }
324 
325     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
326         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
327         return true;
328     }
329 
330     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
331         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
332         return true;
333     }
334 
335     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
336         require(sender != address(0), "ERC20: transfer from the zero address");
337         require(recipient != address(0), "ERC20: transfer to the zero address");
338 
339         _beforeTokenTransfer(sender, recipient, amount);
340 
341         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
342         _balances[recipient] = _balances[recipient].add(amount);
343         emit Transfer(sender, recipient, amount);
344     }
345 
346     function _mint(address account_, uint256 ammount_) internal virtual {
347         require(account_ != address(0), "ERC20: mint to the zero address");
348         _beforeTokenTransfer(address( this ), account_, ammount_);
349         _totalSupply = _totalSupply.add(ammount_);
350         _balances[account_] = _balances[account_].add(ammount_);
351         emit Transfer(address( this ), account_, ammount_);
352     }
353 
354     function _burn(address account, uint256 amount) internal virtual {
355         require(account != address(0), "ERC20: burn from the zero address");
356 
357         _beforeTokenTransfer(account, address(0), amount);
358 
359         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
360         _totalSupply = _totalSupply.sub(amount);
361         emit Transfer(account, address(0), amount);
362     }
363 
364     function _approve(address owner, address spender, uint256 amount) internal virtual {
365         require(owner != address(0), "ERC20: approve from the zero address");
366         require(spender != address(0), "ERC20: approve to the zero address");
367 
368         _allowances[owner][spender] = amount;
369         emit Approval(owner, spender, amount);
370     }
371 
372   function _beforeTokenTransfer( address from_, address to_, uint256 amount_ ) internal virtual { }
373 }
374 
375 interface IERC2612Permit {
376 
377     function permit(
378         address owner,
379         address spender,
380         uint256 amount,
381         uint256 deadline,
382         uint8 v,
383         bytes32 r,
384         bytes32 s
385     ) external;
386 
387     function nonces(address owner) external view returns (uint256);
388 }
389 
390 library Counters {
391     using SafeMath for uint256;
392 
393     struct Counter {
394 
395         uint256 _value; // default: 0
396     }
397 
398     function current(Counter storage counter) internal view returns (uint256) {
399         return counter._value;
400     }
401 
402     function increment(Counter storage counter) internal {
403         counter._value += 1;
404     }
405 
406     function decrement(Counter storage counter) internal {
407         counter._value = counter._value.sub(1);
408     }
409 }
410 
411 abstract contract ERC20Permit is ERC20, IERC2612Permit {
412     using Counters for Counters.Counter;
413 
414     mapping(address => Counters.Counter) private _nonces;
415 
416     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
417     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
418 
419     bytes32 public DOMAIN_SEPARATOR;
420 
421     constructor() {
422         uint256 chainID;
423         assembly {
424             chainID := chainid()
425         }
426 
427         DOMAIN_SEPARATOR = keccak256(
428             abi.encode(
429                 keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
430                 keccak256(bytes(name())),
431                 keccak256(bytes("1")), // Version
432                 chainID,
433                 address(this)
434             )
435         );
436     }
437 
438     function permit(
439         address owner,
440         address spender,
441         uint256 amount,
442         uint256 deadline,
443         uint8 v,
444         bytes32 r,
445         bytes32 s
446     ) public virtual override {
447         require(block.timestamp <= deadline, "Permit: expired deadline");
448 
449         bytes32 hashStruct =
450             keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, amount, _nonces[owner].current(), deadline));
451 
452         bytes32 _hash = keccak256(abi.encodePacked(uint16(0x1901), DOMAIN_SEPARATOR, hashStruct));
453 
454         address signer = ecrecover(_hash, v, r, s);
455         require(signer != address(0) && signer == owner, "ZeroSwapPermit: Invalid signature");
456 
457         _nonces[owner].increment();
458         _approve(owner, spender, amount);
459     }
460 
461     function nonces(address owner) public view override returns (uint256) {
462         return _nonces[owner].current();
463     }
464 }
465 
466 library SafeERC20 {
467     using SafeMath for uint256;
468     using Address for address;
469 
470     function safeTransfer(IERC20 token, address to, uint256 value) internal {
471         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
472     }
473 
474     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
475         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
476     }
477 
478     function safeApprove(IERC20 token, address spender, uint256 value) internal {
479 
480         require((value == 0) || (token.allowance(address(this), spender) == 0),
481             "SafeERC20: approve from non-zero to non-zero allowance"
482         );
483         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
484     }
485 
486     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
487         uint256 newAllowance = token.allowance(address(this), spender).add(value);
488         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
489     }
490 
491     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
492         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
493         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
494     }
495 
496     function _callOptionalReturn(IERC20 token, bytes memory data) private {
497 
498         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
499         if (returndata.length > 0) { // Return data is optional
500             // solhint-disable-next-line max-line-length
501             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
502         }
503     }
504 }
505 
506 library FullMath {
507     function fullMul(uint256 x, uint256 y) private pure returns (uint256 l, uint256 h) {
508         uint256 mm = mulmod(x, y, uint256(-1));
509         l = x * y;
510         h = mm - l;
511         if (mm < l) h -= 1;
512     }
513 
514     function fullDiv(
515         uint256 l,
516         uint256 h,
517         uint256 d
518     ) private pure returns (uint256) {
519         uint256 pow2 = d & -d;
520         d /= pow2;
521         l /= pow2;
522         l += h * ((-pow2) / pow2 + 1);
523         uint256 r = 1;
524         r *= 2 - d * r;
525         r *= 2 - d * r;
526         r *= 2 - d * r;
527         r *= 2 - d * r;
528         r *= 2 - d * r;
529         r *= 2 - d * r;
530         r *= 2 - d * r;
531         r *= 2 - d * r;
532         return l * r;
533     }
534 
535     function mulDiv(
536         uint256 x,
537         uint256 y,
538         uint256 d
539     ) internal pure returns (uint256) {
540         (uint256 l, uint256 h) = fullMul(x, y);
541         uint256 mm = mulmod(x, y, d);
542         if (mm > l) h -= 1;
543         l -= mm;
544         require(h < d, 'FullMath::mulDiv: overflow');
545         return fullDiv(l, h, d);
546     }
547 }
548 
549 library FixedPoint {
550 
551     struct uq112x112 {
552         uint224 _x;
553     }
554 
555     struct uq144x112 {
556         uint256 _x;
557     }
558 
559     uint8 private constant RESOLUTION = 112;
560     uint256 private constant Q112 = 0x10000000000000000000000000000;
561     uint256 private constant Q224 = 0x100000000000000000000000000000000000000000000000000000000;
562     uint256 private constant LOWER_MASK = 0xffffffffffffffffffffffffffff; // decimal of UQ*x112 (lower 112 bits)
563 
564     function decode(uq112x112 memory self) internal pure returns (uint112) {
565         return uint112(self._x >> RESOLUTION);
566     }
567 
568     function decode112with18(uq112x112 memory self) internal pure returns (uint) {
569 
570         return uint(self._x) / 5192296858534827;
571     }
572 
573     function fraction(uint256 numerator, uint256 denominator) internal pure returns (uq112x112 memory) {
574         require(denominator > 0, 'FixedPoint::fraction: division by zero');
575         if (numerator == 0) return FixedPoint.uq112x112(0);
576 
577         if (numerator <= uint144(-1)) {
578             uint256 result = (numerator << RESOLUTION) / denominator;
579             require(result <= uint224(-1), 'FixedPoint::fraction: overflow');
580             return uq112x112(uint224(result));
581         } else {
582             uint256 result = FullMath.mulDiv(numerator, Q112, denominator);
583             require(result <= uint224(-1), 'FixedPoint::fraction: overflow');
584             return uq112x112(uint224(result));
585         }
586     }
587 }
588 
589 interface ITreasury {
590     function deposit( uint _amount, address _token, uint _profit ) external returns ( bool );
591     function valueOf( address _token, uint _amount ) external view returns ( uint value_ );
592     function getFloor(address _token) external view returns(uint);
593     function mintRewards(address _recipient, uint _amount ) external;
594 }
595 
596 interface IBondCalculator {
597     function valuation( address _LP, uint _amount ) external view returns ( uint );
598     function markdown( address _LP ) external view returns ( uint );
599 }
600 
601 interface IStaking {
602     function stake( uint _amount, address _recipient ) external returns ( bool );
603 }
604 
605 interface IStakingHelper {
606     function stake( uint _amount, address _recipient ) external;
607 }
608 
609 contract REDACTEDBondDepositoryRewardBased is Ownable {
610 
611     using FixedPoint for *;
612     using SafeERC20 for IERC20;
613     using SafeMath for uint;
614 
615 
616 
617 
618     /* ======== EVENTS ======== */
619 
620     event BondCreated( uint deposit, uint indexed payout, uint indexed expires, uint indexed nativePrice );
621     event BondRedeemed( address indexed recipient, uint payout, uint remaining );
622     event BondPriceChanged( uint indexed nativePrice, uint indexed internalPrice, uint indexed debtRatio );
623     event ControlVariableAdjustment( uint initialBCV, uint newBCV, uint adjustment, bool addition );
624 
625 
626 
627 
628     /* ======== STATE VARIABLES ======== */
629 
630     address public immutable BTRFLY; // token given as payment for bond
631     address public immutable principal; // token used to create bond
632     address public immutable OLYMPUSDAO; // we pay homage to these guys :) (tithe/ti-the hahahahhahah)
633     address public immutable treasury; // mints BTRFLY when receives principal
634     address public immutable DAO; // receives profit share from bond
635     address public OLYMPUSTreasury; // Olympus treasury can be updated by the OLYMPUSDAO
636 
637     bool public immutable isLiquidityBond; // LP and Reserve bonds are treated slightly different
638     address public immutable bondCalculator; // calculates value of LP tokens
639 
640     address public staking; // to auto-stake payout
641     address public stakingHelper; // to stake and claim if no staking warmup
642     bool public useHelper;
643 
644     Terms public terms; // stores terms for new bonds
645     Adjust public adjustment; // stores adjustment to BCV data
646 
647     mapping( address => Bond ) public bondInfo; // stores bond information for depositors
648 
649     uint public totalDebt; // total value of outstanding bonds; used for pricing
650     uint public lastDecay; // reference block for debt decay
651 
652 
653 
654 
655     /* ======== STRUCTS ======== */
656 
657     // Info for creating new bonds
658     struct Terms {
659         uint controlVariable; // scaling variable for price
660         uint vestingTerm; // in blocks
661         uint minimumPrice; // vs principal value
662         uint maxPayout; // in thousandths of a %. i.e. 500 = 0.5%
663         uint fee; // as % of bond payout, in hundreths. ( 500 = 5% = 0.05 for every 1 paid)
664         uint tithe; // in thousandths of a %. i.e. 500 = 0.5%
665         uint maxDebt; // 9 decimal debt ratio, max % total supply created as debt
666     }
667 
668     // Info for bond holder
669     struct Bond {
670         uint payout; // BTRFLY remaining to be paid
671         uint vesting; // Blocks left to vest
672         uint lastBlock; // Last interaction
673         uint pricePaid; // In native asset, for front end viewing
674     }
675 
676     // Info for incremental adjustments to control variable 
677     struct Adjust {
678         bool add; // addition or subtraction
679         uint rate; // increment
680         uint target; // BCV when adjustment finished
681         uint buffer; // minimum length (in blocks) between adjustments
682         uint lastBlock; // block when last adjustment made
683     }
684 
685 
686 
687 
688     /* ======== INITIALIZATION ======== */
689 
690     constructor ( 
691         address _BTRFLY,
692         address _principal,
693         address _treasury, 
694         address _DAO, 
695         address _bondCalculator,
696         address _OLYMPUSDAO,
697         address _OLYMPUSTreasury
698     ) {
699         require( _BTRFLY != address(0) );
700         BTRFLY = _BTRFLY;
701         require( _principal != address(0) );
702         principal = _principal;
703         require( _treasury != address(0) );
704         treasury = _treasury;
705         require( _DAO != address(0) );
706         DAO = _DAO;
707         // bondCalculator should be address(0) if not LP bond
708         bondCalculator = _bondCalculator;
709         isLiquidityBond = ( _bondCalculator != address(0) );
710         OLYMPUSDAO = _OLYMPUSDAO;
711         OLYMPUSTreasury = _OLYMPUSTreasury;
712     }
713 
714     /**
715      *  @notice initializes bond parameters
716      *  @param _controlVariable uint
717      *  @param _vestingTerm uint
718      *  @param _minimumPrice uint
719      *  @param _maxPayout uint
720      *  @param _fee uint
721      *  @param _maxDebt uint
722      *  @param _initialDebt uint
723      */
724     function initializeBondTerms( 
725         uint _controlVariable, 
726         uint _vestingTerm,
727         uint _minimumPrice,
728         uint _maxPayout,
729         uint _fee,
730         uint _maxDebt,
731         uint _tithe,
732         uint _initialDebt
733     ) external onlyPolicy() {
734         require( terms.controlVariable == 0, "Bonds must be initialized from 0" );
735         terms = Terms ({
736             controlVariable: _controlVariable,
737             vestingTerm: _vestingTerm,
738             minimumPrice: _minimumPrice,
739             maxPayout: _maxPayout,
740             fee: _fee,
741             maxDebt: _maxDebt,
742             tithe: _tithe
743         });
744         totalDebt = _initialDebt;
745         lastDecay = block.number;
746     }
747 
748 
749 
750     
751     /* ======== POLICY FUNCTIONS ======== */
752 
753     enum PARAMETER { VESTING, PAYOUT, FEE, DEBT }
754     /**
755      *  @notice set parameters for new bonds
756      *  @param _parameter PARAMETER
757      *  @param _input uint
758      */
759     function setBondTerms ( PARAMETER _parameter, uint _input ) external onlyPolicy() {
760         if ( _parameter == PARAMETER.VESTING ) { // 0
761             require( _input >= 10000, "Vesting must be longer than 36 hours" );
762             terms.vestingTerm = _input;
763         } else if ( _parameter == PARAMETER.PAYOUT ) { // 1
764             require( _input <= 1000, "Payout cannot be above 1 percent" );
765             terms.maxPayout = _input;
766         } else if ( _parameter == PARAMETER.FEE ) { // 2
767             require( _input <= 10000, "DAO fee cannot exceed payout" );
768             terms.fee = _input;
769         } else if ( _parameter == PARAMETER.DEBT ) { // 3
770             terms.maxDebt = _input;
771         }
772     }
773 
774     /**
775      *  @notice set control variable adjustment
776      *  @param _addition bool
777      *  @param _increment uint
778      *  @param _target uint
779      *  @param _buffer uint
780      */
781     function setAdjustment ( 
782         bool _addition,
783         uint _increment, 
784         uint _target,
785         uint _buffer 
786     ) external onlyPolicy() {
787         require( _increment <= terms.controlVariable.mul( 25 ).div( 1000 ), "Increment too large" );
788 
789         adjustment = Adjust({
790             add: _addition,
791             rate: _increment,
792             target: _target,
793             buffer: _buffer,
794             lastBlock: block.number
795         });
796     }
797 
798     /**
799      *  @notice set contract for auto stake
800      *  @param _staking address
801      *  @param _helper bool
802      */
803     function setStaking( address _staking, bool _helper ) external onlyPolicy() {
804         require( _staking != address(0) );
805         if ( _helper ) {
806             useHelper = true;
807             stakingHelper = _staking;
808         } else {
809             useHelper = false;
810             staking = _staking;
811         }
812     }
813 
814 
815     
816 
817     /* ======== USER FUNCTIONS ======== */
818 
819     /**
820      *  @notice deposit bond
821      *  @param _amount uint
822      *  @param _maxPrice uint
823      *  @param _depositor address
824      *  @return uint
825      */
826     function deposit( 
827         uint _amount, 
828         uint _maxPrice,
829         address _depositor
830     ) external returns ( uint ) {
831         require( _depositor != address(0), "Invalid address" );
832         require( _depositor == msg.sender , "Depositor not msg.sender" );
833 
834         decayDebt();
835         require( totalDebt <= terms.maxDebt, "Max capacity reached" );
836         
837         uint nativePrice = _bondPrice();
838 
839         require( _maxPrice >= nativePrice, "Slippage limit: more than max price" ); // slippage protection
840 
841         uint tithePrincipal = _amount.mul(terms.tithe).div(100000);
842 
843         uint value = ITreasury( treasury ).valueOf( principal, _amount );
844         //console.log(" value = ", value);
845         uint payout = payoutFor( value ); // payout to bonder is computed
846         //console.log("payout = ", payout);
847 
848         require( payout >= 10000000, "Bond too small" ); // must be > 0.01 BTRFLY ( underflow protection )
849         require( payout <= maxPayout(), "Bond too large"); // size protection because there is no slippage
850 
851         /**
852             principal is transferred in
853             approved and
854             deposited into the treasury, returning (_amount - profit) BTRFLY
855          */
856         IERC20( principal ).safeTransferFrom( msg.sender, address(this), _amount );
857         IERC20( principal ).safeTransfer( OLYMPUSTreasury, tithePrincipal );
858 
859         uint amountDeposit = _amount.sub(tithePrincipal);
860         IERC20( principal ).safeTransfer( address( treasury ), amountDeposit );
861 
862         //call mintRewards
863         uint titheBTRFLY = payout.mul(terms.tithe).div(100000);
864         uint fee = payout.mul( terms.fee ).div( 100000 );
865         uint totalMint = titheBTRFLY.add(fee).add(payout);
866 
867         ITreasury(treasury).mintRewards(address(this),totalMint);
868         
869         // fee is transferred to daos
870         IERC20( BTRFLY ).safeTransfer( DAO, fee ); 
871         IERC20( BTRFLY ).safeTransfer( OLYMPUSTreasury, titheBTRFLY );
872         
873         // total debt is increased
874         totalDebt = totalDebt.add( value ); 
875                 
876         // depositor info is stored
877         bondInfo[ _depositor ] = Bond({ 
878             payout: bondInfo[ _depositor ].payout.add( payout ),
879             vesting: terms.vestingTerm,
880             lastBlock: block.number,
881             pricePaid: nativePrice
882         });
883 
884         // indexed events are emitted
885         emit BondCreated( _amount, payout, block.number.add( terms.vestingTerm ), nativePrice );
886         //emit BondPriceChanged( bondPriceInUSD(), _bondPrice(), debtRatio() );
887 
888         adjust(); // control variable is adjusted
889         return payout; 
890     }
891 
892     /** 
893      *  @notice redeem bond for user
894      *  @param _recipient address
895      *  @param _stake bool
896      *  @return uint
897      */ 
898     function redeem( address _recipient, bool _stake ) external returns ( uint ) {        
899         Bond memory info = bondInfo[ _recipient ];
900         uint percentVested = percentVestedFor( _recipient ); // (blocks since last interaction / vesting term remaining)
901 
902         if ( percentVested >= 10000 ) { // if fully vested
903             delete bondInfo[ _recipient ]; // delete user info
904             emit BondRedeemed( _recipient, info.payout, 0 ); // emit bond data
905             return stakeOrSend( _recipient, _stake, info.payout ); // pay user everything due
906 
907         } else { // if unfinished
908             // calculate payout vested
909             uint payout = info.payout.mul( percentVested ).div( 10000 );
910 
911             // store updated deposit info
912             bondInfo[ _recipient ] = Bond({
913                 payout: info.payout.sub( payout ),
914                 vesting: info.vesting.sub( block.number.sub( info.lastBlock ) ),
915                 lastBlock: block.number,
916                 pricePaid: info.pricePaid
917             });
918 
919             emit BondRedeemed( _recipient, payout, bondInfo[ _recipient ].payout );
920             return stakeOrSend( _recipient, _stake, payout );
921         }
922     }
923 
924 
925 
926     
927     /* ======== INTERNAL HELPER FUNCTIONS ======== */
928 
929     /**
930      *  @notice allow user to stake payout automatically
931      *  @param _stake bool
932      *  @param _amount uint
933      *  @return uint
934      */
935     function stakeOrSend( address _recipient, bool _stake, uint _amount ) internal returns ( uint ) {
936         if ( !_stake ) { // if user does not want to stake
937             IERC20( BTRFLY ).transfer( _recipient, _amount ); // send payout
938         } else { // if user wants to stake
939             if ( useHelper ) { // use if staking warmup is 0
940                 IERC20( BTRFLY ).approve( stakingHelper, _amount );
941                 IStakingHelper( stakingHelper ).stake( _amount, _recipient );
942             } else {
943                 IERC20( BTRFLY ).approve( staking, _amount );
944                 IStaking( staking ).stake( _amount, _recipient );
945             }
946         }
947         return _amount;
948     }
949 
950     /**
951      *  @notice makes incremental adjustment to control variable
952      */
953     function adjust() internal {
954         uint blockCanAdjust = adjustment.lastBlock.add( adjustment.buffer );
955         if( adjustment.rate != 0 && block.number >= blockCanAdjust ) {
956             uint initial = terms.controlVariable;
957             if ( adjustment.add ) {
958                 terms.controlVariable = terms.controlVariable.add( adjustment.rate );
959                 if ( terms.controlVariable >= adjustment.target ) {
960                     adjustment.rate = 0;
961                 }
962             } else {
963                 terms.controlVariable = terms.controlVariable.sub( adjustment.rate );
964                 if ( terms.controlVariable <= adjustment.target ) {
965                     adjustment.rate = 0;
966                 }
967             }
968             adjustment.lastBlock = block.number;
969             emit ControlVariableAdjustment( initial, terms.controlVariable, adjustment.rate, adjustment.add );
970         }
971     }
972 
973     /**
974      *  @notice reduce total debt
975      */
976     function decayDebt() internal {
977         totalDebt = totalDebt.sub( debtDecay() );
978         lastDecay = block.number;
979     }
980 
981 
982 
983 
984     /* ======== VIEW FUNCTIONS ======== */
985 
986     /**
987      *  @notice determine maximum bond size
988      *  @return uint
989      */
990     function maxPayout() public view returns ( uint ) {
991         return IERC20( BTRFLY ).totalSupply().mul( terms.maxPayout ).div( 100000 );
992     }
993 
994     /**
995      *  @notice calculate interest due for new bond
996      *  @param _value uint
997      *  @return uint
998      */
999     function payoutFor( uint _value ) public view returns ( uint ) {
1000         return FixedPoint.fraction( _value, bondPrice() ).decode112with18().div( 1e16 );
1001     }
1002 
1003 
1004     /**
1005      *  @notice calculate current bond premium
1006      *  @return price_ uint
1007      */
1008     function bondPrice() public view returns ( uint price_ ) {        
1009         price_ = terms.controlVariable.mul( debtRatio() ).add( ITreasury(treasury).getFloor(principal) ).div( 1e7 );
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
1020         price_ = terms.controlVariable.mul( debtRatio() ).add( ITreasury(treasury).getFloor(principal) ).div( 1e7 );
1021         if ( price_ < terms.minimumPrice ) {
1022             price_ = terms.minimumPrice;        
1023         } else if ( terms.minimumPrice != 0 ) {
1024             terms.minimumPrice = 0;
1025         }
1026     }
1027 
1028     /**
1029      *  @notice converts bond price to DAI value
1030      *  @return price_ uint
1031      */
1032     function bondPriceInUSD() public view returns ( uint price_ ) {
1033         if( isLiquidityBond ) {
1034             price_ = bondPrice().mul( IBondCalculator( bondCalculator ).markdown( principal ) ).div( 100 );
1035         } else {
1036             price_ = bondPrice().mul( 10 ** IERC20( principal ).decimals() ).div( 100 );
1037         }
1038     }
1039 
1040 
1041     /**
1042      *  @notice calculate current ratio of debt to BTRFLY supply
1043      *  @return debtRatio_ uint
1044      */
1045     function debtRatio() public view returns ( uint debtRatio_ ) {   
1046         uint supply = IERC20( BTRFLY ).totalSupply();
1047         debtRatio_ = FixedPoint.fraction( 
1048             currentDebt().mul( 1e9 ), 
1049             supply
1050         ).decode112with18().div( 1e18 );
1051     }
1052 
1053     /**
1054      *  @notice debt ratio in same terms for reserve or liquidity bonds
1055      *  @return uint
1056      */
1057     function standardizedDebtRatio() external view returns ( uint ) {
1058         if ( isLiquidityBond ) {
1059             return debtRatio().mul( IBondCalculator( bondCalculator ).markdown( principal ) ).div( 1e9 );
1060         } else {
1061             return debtRatio();
1062         }
1063     }
1064 
1065     /**
1066      *  @notice calculate debt factoring in decay
1067      *  @return uint
1068      */
1069     function currentDebt() public view returns ( uint ) {
1070         return totalDebt.sub( debtDecay() );
1071     }
1072 
1073     /**
1074      *  @notice amount to decay total debt by
1075      *  @return decay_ uint
1076      */
1077     function debtDecay() public view returns ( uint decay_ ) {
1078         uint blocksSinceLast = block.number.sub( lastDecay );
1079         decay_ = totalDebt.mul( blocksSinceLast ).div( terms.vestingTerm );
1080         if ( decay_ > totalDebt ) {
1081             decay_ = totalDebt;
1082         }
1083     }
1084 
1085 
1086     /**
1087      *  @notice calculate how far into vesting a depositor is
1088      *  @param _depositor address
1089      *  @return percentVested_ uint
1090      */
1091     function percentVestedFor( address _depositor ) public view returns ( uint percentVested_ ) {
1092         Bond memory bond = bondInfo[ _depositor ];
1093         uint blocksSinceLast = block.number.sub( bond.lastBlock );
1094         uint vesting = bond.vesting;
1095 
1096         if ( vesting > 0 ) {
1097             percentVested_ = blocksSinceLast.mul( 10000 ).div( vesting );
1098         } else {
1099             percentVested_ = 0;
1100         }
1101     }
1102 
1103     /**
1104      *  @notice calculate amount of BTRFLY available for claim by depositor
1105      *  @param _depositor address
1106      *  @return pendingPayout_ uint
1107      */
1108     function pendingPayoutFor( address _depositor ) external view returns ( uint pendingPayout_ ) {
1109         uint percentVested = percentVestedFor( _depositor );
1110         uint payout = bondInfo[ _depositor ].payout;
1111 
1112         if ( percentVested >= 10000 ) {
1113             pendingPayout_ = payout;
1114         } else {
1115             pendingPayout_ = payout.mul( percentVested ).div( 10000 );
1116         }
1117     }
1118 
1119 
1120 
1121 
1122     /* ======= AUXILLIARY ======= */
1123 
1124     /**
1125      *  @notice allow anyone to send lost tokens (excluding principal or BTRFLY) to the DAO
1126      *  @return bool
1127      */
1128     function recoverLostToken( address _token ) external returns ( bool ) {
1129         require( _token != BTRFLY );
1130         require( _token != principal );
1131         IERC20( _token ).safeTransfer( DAO, IERC20( _token ).balanceOf( address(this) ) );
1132         return true;
1133     }
1134 
1135     function setOLYMPUSTreasury( address _newTreasury ) external {
1136         require(msg.sender == OLYMPUSDAO || msg.sender == DAO, "UNAUTHORISED : YOU'RE NOT OLYMPUS OR REDACTED");
1137         OLYMPUSTreasury = _newTreasury;
1138     }
1139 
1140 
1141 
1142 }