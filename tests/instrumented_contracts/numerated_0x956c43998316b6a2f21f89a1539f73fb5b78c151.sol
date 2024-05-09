1 /**
2  *Submitted for verification at Etherscan.io on 2021-06-16
3 */
4 
5 // SPDX-License-Identifier: AGPL-3.0-or-later
6 pragma solidity 0.7.5;
7 
8 interface IOwnable {
9   function policy() external view returns (address);
10 
11   function renounceManagement() external;
12   
13   function pushManagement( address newOwner_ ) external;
14   
15   function pullManagement() external;
16 }
17 
18 contract Ownable is IOwnable {
19 
20     address internal _owner;
21     address internal _newOwner;
22 
23     event OwnershipPushed(address indexed previousOwner, address indexed newOwner);
24     event OwnershipPulled(address indexed previousOwner, address indexed newOwner);
25 
26     constructor () {
27         _owner = msg.sender;
28         emit OwnershipPushed( address(0), _owner );
29     }
30 
31     function policy() public view override returns (address) {
32         return _owner;
33     }
34 
35     modifier onlyPolicy() {
36         require( _owner == msg.sender, "Ownable: caller is not the owner" );
37         _;
38     }
39 
40     function renounceManagement() public virtual override onlyPolicy() {
41         emit OwnershipPushed( _owner, address(0) );
42         _owner = address(0);
43     }
44 
45     function pushManagement( address newOwner_ ) public virtual override onlyPolicy() {
46         require( newOwner_ != address(0), "Ownable: new owner is the zero address");
47         emit OwnershipPushed( _owner, newOwner_ );
48         _newOwner = newOwner_;
49     }
50     
51     function pullManagement() public virtual override {
52         require( msg.sender == _newOwner, "Ownable: must be new owner to pull");
53         emit OwnershipPulled( _owner, _newOwner );
54         _owner = _newOwner;
55     }
56 }
57 
58 library SafeMath {
59 
60     function add(uint256 a, uint256 b) internal pure returns (uint256) {
61         uint256 c = a + b;
62         require(c >= a, "SafeMath: addition overflow");
63 
64         return c;
65     }
66 
67     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68         return sub(a, b, "SafeMath: subtraction overflow");
69     }
70 
71     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
72         require(b <= a, errorMessage);
73         uint256 c = a - b;
74 
75         return c;
76     }
77 
78     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
79         if (a == 0) {
80             return 0;
81         }
82 
83         uint256 c = a * b;
84         require(c / a == b, "SafeMath: multiplication overflow");
85 
86         return c;
87     }
88 
89     function div(uint256 a, uint256 b) internal pure returns (uint256) {
90         return div(a, b, "SafeMath: division by zero");
91     }
92 
93     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
94         require(b > 0, errorMessage);
95         uint256 c = a / b;
96         return c;
97     }
98 
99     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
100         return mod(a, b, "SafeMath: modulo by zero");
101     }
102 
103     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
104         require(b != 0, errorMessage);
105         return a % b;
106     }
107 
108     function sqrrt(uint256 a) internal pure returns (uint c) {
109         if (a > 3) {
110             c = a;
111             uint b = add( div( a, 2), 1 );
112             while (b < c) {
113                 c = b;
114                 b = div( add( div( a, b ), b), 2 );
115             }
116         } else if (a != 0) {
117             c = 1;
118         }
119     }
120 }
121 
122 library Address {
123 
124     function isContract(address account) internal view returns (bool) {
125 
126         uint256 size;
127         // solhint-disable-next-line no-inline-assembly
128         assembly { size := extcodesize(account) }
129         return size > 0;
130     }
131 
132     function sendValue(address payable recipient, uint256 amount) internal {
133         require(address(this).balance >= amount, "Address: insufficient balance");
134 
135         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
136         (bool success, ) = recipient.call{ value: amount }("");
137         require(success, "Address: unable to send value, recipient may have reverted");
138     }
139 
140     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
141       return functionCall(target, data, "Address: low-level call failed");
142     }
143 
144     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
145         return _functionCallWithValue(target, data, 0, errorMessage);
146     }
147 
148     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
149         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
150     }
151 
152     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
153         require(address(this).balance >= value, "Address: insufficient balance for call");
154         require(isContract(target), "Address: call to non-contract");
155 
156         // solhint-disable-next-line avoid-low-level-calls
157         (bool success, bytes memory returndata) = target.call{ value: value }(data);
158         return _verifyCallResult(success, returndata, errorMessage);
159     }
160 
161     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
162         require(isContract(target), "Address: call to non-contract");
163 
164         // solhint-disable-next-line avoid-low-level-calls
165         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
166         if (success) {
167             return returndata;
168         } else {
169             // Look for revert reason and bubble it up if present
170             if (returndata.length > 0) {
171                 // The easiest way to bubble the revert reason is using memory via assembly
172 
173                 // solhint-disable-next-line no-inline-assembly
174                 assembly {
175                     let returndata_size := mload(returndata)
176                     revert(add(32, returndata), returndata_size)
177                 }
178             } else {
179                 revert(errorMessage);
180             }
181         }
182     }
183 
184     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
185         return functionStaticCall(target, data, "Address: low-level static call failed");
186     }
187 
188     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
189         require(isContract(target), "Address: static call to non-contract");
190 
191         // solhint-disable-next-line avoid-low-level-calls
192         (bool success, bytes memory returndata) = target.staticcall(data);
193         return _verifyCallResult(success, returndata, errorMessage);
194     }
195 
196     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
197         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
198     }
199 
200     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
201         require(isContract(target), "Address: delegate call to non-contract");
202 
203         // solhint-disable-next-line avoid-low-level-calls
204         (bool success, bytes memory returndata) = target.delegatecall(data);
205         return _verifyCallResult(success, returndata, errorMessage);
206     }
207 
208     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
209         if (success) {
210             return returndata;
211         } else {
212             if (returndata.length > 0) {
213 
214                 assembly {
215                     let returndata_size := mload(returndata)
216                     revert(add(32, returndata), returndata_size)
217                 }
218             } else {
219                 revert(errorMessage);
220             }
221         }
222     }
223 
224     function addressToString(address _address) internal pure returns(string memory) {
225         bytes32 _bytes = bytes32(uint256(_address));
226         bytes memory HEX = "0123456789abcdef";
227         bytes memory _addr = new bytes(42);
228 
229         _addr[0] = '0';
230         _addr[1] = 'x';
231 
232         for(uint256 i = 0; i < 20; i++) {
233             _addr[2+i*2] = HEX[uint8(_bytes[i + 12] >> 4)];
234             _addr[3+i*2] = HEX[uint8(_bytes[i + 12] & 0x0f)];
235         }
236 
237         return string(_addr);
238 
239     }
240 }
241 
242 interface IERC20 {
243     function decimals() external view returns (uint8);
244 
245     function totalSupply() external view returns (uint256);
246 
247     function balanceOf(address account) external view returns (uint256);
248 
249     function transfer(address recipient, uint256 amount) external returns (bool);
250 
251     function allowance(address owner, address spender) external view returns (uint256);
252 
253     function approve(address spender, uint256 amount) external returns (bool);
254 
255     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
256 
257     event Transfer(address indexed from, address indexed to, uint256 value);
258 
259     event Approval(address indexed owner, address indexed spender, uint256 value);
260 }
261 
262 abstract contract ERC20 is IERC20 {
263 
264     using SafeMath for uint256;
265 
266     // TODO comment actual hash value.
267     bytes32 constant private ERC20TOKEN_ERC1820_INTERFACE_ID = keccak256( "ERC20Token" );
268     
269     mapping (address => uint256) internal _balances;
270 
271     mapping (address => mapping (address => uint256)) internal _allowances;
272 
273     uint256 internal _totalSupply;
274 
275     string internal _name;
276     
277     string internal _symbol;
278     
279     uint8 internal _decimals;
280 
281     constructor (string memory name_, string memory symbol_, uint8 decimals_) {
282         _name = name_;
283         _symbol = symbol_;
284         _decimals = decimals_;
285     }
286 
287     function name() public view returns (string memory) {
288         return _name;
289     }
290 
291     function symbol() public view returns (string memory) {
292         return _symbol;
293     }
294 
295     function decimals() public view override returns (uint8) {
296         return _decimals;
297     }
298 
299     function totalSupply() public view override returns (uint256) {
300         return _totalSupply;
301     }
302 
303     function balanceOf(address account) public view virtual override returns (uint256) {
304         return _balances[account];
305     }
306 
307     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
308         _transfer(msg.sender, recipient, amount);
309         return true;
310     }
311 
312     function allowance(address owner, address spender) public view virtual override returns (uint256) {
313         return _allowances[owner][spender];
314     }
315 
316     function approve(address spender, uint256 amount) public virtual override returns (bool) {
317         _approve(msg.sender, spender, amount);
318         return true;
319     }
320 
321     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
322         _transfer(sender, recipient, amount);
323         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
324         return true;
325     }
326 
327     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
328         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
329         return true;
330     }
331 
332     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
333         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
334         return true;
335     }
336 
337     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
338         require(sender != address(0), "ERC20: transfer from the zero address");
339         require(recipient != address(0), "ERC20: transfer to the zero address");
340 
341         _beforeTokenTransfer(sender, recipient, amount);
342 
343         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
344         _balances[recipient] = _balances[recipient].add(amount);
345         emit Transfer(sender, recipient, amount);
346     }
347 
348     function _mint(address account_, uint256 ammount_) internal virtual {
349         require(account_ != address(0), "ERC20: mint to the zero address");
350         _beforeTokenTransfer(address( this ), account_, ammount_);
351         _totalSupply = _totalSupply.add(ammount_);
352         _balances[account_] = _balances[account_].add(ammount_);
353         emit Transfer(address( this ), account_, ammount_);
354     }
355 
356     function _burn(address account, uint256 amount) internal virtual {
357         require(account != address(0), "ERC20: burn from the zero address");
358 
359         _beforeTokenTransfer(account, address(0), amount);
360 
361         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
362         _totalSupply = _totalSupply.sub(amount);
363         emit Transfer(account, address(0), amount);
364     }
365 
366     function _approve(address owner, address spender, uint256 amount) internal virtual {
367         require(owner != address(0), "ERC20: approve from the zero address");
368         require(spender != address(0), "ERC20: approve to the zero address");
369 
370         _allowances[owner][spender] = amount;
371         emit Approval(owner, spender, amount);
372     }
373 
374   function _beforeTokenTransfer( address from_, address to_, uint256 amount_ ) internal virtual { }
375 }
376 
377 interface IERC2612Permit {
378 
379     function permit(
380         address owner,
381         address spender,
382         uint256 amount,
383         uint256 deadline,
384         uint8 v,
385         bytes32 r,
386         bytes32 s
387     ) external;
388 
389     function nonces(address owner) external view returns (uint256);
390 }
391 
392 library Counters {
393     using SafeMath for uint256;
394 
395     struct Counter {
396 
397         uint256 _value; // default: 0
398     }
399 
400     function current(Counter storage counter) internal view returns (uint256) {
401         return counter._value;
402     }
403 
404     function increment(Counter storage counter) internal {
405         counter._value += 1;
406     }
407 
408     function decrement(Counter storage counter) internal {
409         counter._value = counter._value.sub(1);
410     }
411 }
412 
413 abstract contract ERC20Permit is ERC20, IERC2612Permit {
414     using Counters for Counters.Counter;
415 
416     mapping(address => Counters.Counter) private _nonces;
417 
418     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
419     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
420 
421     bytes32 public DOMAIN_SEPARATOR;
422 
423     constructor() {
424         uint256 chainID;
425         assembly {
426             chainID := chainid()
427         }
428 
429         DOMAIN_SEPARATOR = keccak256(
430             abi.encode(
431                 keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
432                 keccak256(bytes(name())),
433                 keccak256(bytes("1")), // Version
434                 chainID,
435                 address(this)
436             )
437         );
438     }
439 
440     function permit(
441         address owner,
442         address spender,
443         uint256 amount,
444         uint256 deadline,
445         uint8 v,
446         bytes32 r,
447         bytes32 s
448     ) public virtual override {
449         require(block.timestamp <= deadline, "Permit: expired deadline");
450 
451         bytes32 hashStruct =
452             keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, amount, _nonces[owner].current(), deadline));
453 
454         bytes32 _hash = keccak256(abi.encodePacked(uint16(0x1901), DOMAIN_SEPARATOR, hashStruct));
455 
456         address signer = ecrecover(_hash, v, r, s);
457         require(signer != address(0) && signer == owner, "ZeroSwapPermit: Invalid signature");
458 
459         _nonces[owner].increment();
460         _approve(owner, spender, amount);
461     }
462 
463     function nonces(address owner) public view override returns (uint256) {
464         return _nonces[owner].current();
465     }
466 }
467 
468 library SafeERC20 {
469     using SafeMath for uint256;
470     using Address for address;
471 
472     function safeTransfer(IERC20 token, address to, uint256 value) internal {
473         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
474     }
475 
476     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
477         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
478     }
479 
480     function safeApprove(IERC20 token, address spender, uint256 value) internal {
481 
482         require((value == 0) || (token.allowance(address(this), spender) == 0),
483             "SafeERC20: approve from non-zero to non-zero allowance"
484         );
485         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
486     }
487 
488     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
489         uint256 newAllowance = token.allowance(address(this), spender).add(value);
490         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
491     }
492 
493     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
494         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
495         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
496     }
497 
498     function _callOptionalReturn(IERC20 token, bytes memory data) private {
499 
500         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
501         if (returndata.length > 0) { // Return data is optional
502             // solhint-disable-next-line max-line-length
503             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
504         }
505     }
506 }
507 
508 library FullMath {
509     function fullMul(uint256 x, uint256 y) private pure returns (uint256 l, uint256 h) {
510         uint256 mm = mulmod(x, y, uint256(-1));
511         l = x * y;
512         h = mm - l;
513         if (mm < l) h -= 1;
514     }
515 
516     function fullDiv(
517         uint256 l,
518         uint256 h,
519         uint256 d
520     ) private pure returns (uint256) {
521         uint256 pow2 = d & -d;
522         d /= pow2;
523         l /= pow2;
524         l += h * ((-pow2) / pow2 + 1);
525         uint256 r = 1;
526         r *= 2 - d * r;
527         r *= 2 - d * r;
528         r *= 2 - d * r;
529         r *= 2 - d * r;
530         r *= 2 - d * r;
531         r *= 2 - d * r;
532         r *= 2 - d * r;
533         r *= 2 - d * r;
534         return l * r;
535     }
536 
537     function mulDiv(
538         uint256 x,
539         uint256 y,
540         uint256 d
541     ) internal pure returns (uint256) {
542         (uint256 l, uint256 h) = fullMul(x, y);
543         uint256 mm = mulmod(x, y, d);
544         if (mm > l) h -= 1;
545         l -= mm;
546         require(h < d, 'FullMath::mulDiv: overflow');
547         return fullDiv(l, h, d);
548     }
549 }
550 
551 library FixedPoint {
552 
553     struct uq112x112 {
554         uint224 _x;
555     }
556 
557     struct uq144x112 {
558         uint256 _x;
559     }
560 
561     uint8 private constant RESOLUTION = 112;
562     uint256 private constant Q112 = 0x10000000000000000000000000000;
563     uint256 private constant Q224 = 0x100000000000000000000000000000000000000000000000000000000;
564     uint256 private constant LOWER_MASK = 0xffffffffffffffffffffffffffff; // decimal of UQ*x112 (lower 112 bits)
565 
566     function decode(uq112x112 memory self) internal pure returns (uint112) {
567         return uint112(self._x >> RESOLUTION);
568     }
569 
570     function decode112with18(uq112x112 memory self) internal pure returns (uint) {
571 
572         return uint(self._x) / 5192296858534827;
573     }
574 
575     function fraction(uint256 numerator, uint256 denominator) internal pure returns (uq112x112 memory) {
576         require(denominator > 0, 'FixedPoint::fraction: division by zero');
577         if (numerator == 0) return FixedPoint.uq112x112(0);
578 
579         if (numerator <= uint144(-1)) {
580             uint256 result = (numerator << RESOLUTION) / denominator;
581             require(result <= uint224(-1), 'FixedPoint::fraction: overflow');
582             return uq112x112(uint224(result));
583         } else {
584             uint256 result = FullMath.mulDiv(numerator, Q112, denominator);
585             require(result <= uint224(-1), 'FixedPoint::fraction: overflow');
586             return uq112x112(uint224(result));
587         }
588     }
589 }
590 
591 interface ITreasury {
592     function deposit( uint _amount, address _token, uint _profit ) external returns ( bool );
593     function valueOf( address _token, uint _amount ) external view returns ( uint value_ );
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
609 contract OlympusBondDepository is Ownable {
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
620     event BondCreated( uint deposit, uint indexed payout, uint indexed expires, uint indexed priceInUSD );
621     event BondRedeemed( address indexed recipient, uint payout, uint remaining );
622     event BondPriceChanged( uint indexed priceInUSD, uint indexed internalPrice, uint indexed debtRatio );
623     event ControlVariableAdjustment( uint initialBCV, uint newBCV, uint adjustment, bool addition );
624 
625 
626 
627 
628     /* ======== STATE VARIABLES ======== */
629 
630     address public immutable OHM; // token given as payment for bond
631     address public immutable principle; // token used to create bond
632     address public immutable treasury; // mints OHM when receives principle
633     address public immutable DAO; // receives profit share from bond
634 
635     bool public immutable isLiquidityBond; // LP and Reserve bonds are treated slightly different
636     address public immutable bondCalculator; // calculates value of LP tokens
637 
638     address public staking; // to auto-stake payout
639     address public stakingHelper; // to stake and claim if no staking warmup
640     bool public useHelper;
641 
642     Terms public terms; // stores terms for new bonds
643     Adjust public adjustment; // stores adjustment to BCV data
644 
645     mapping( address => Bond ) public bondInfo; // stores bond information for depositors
646 
647     uint public totalDebt; // total value of outstanding bonds; used for pricing
648     uint public lastDecay; // reference block for debt decay
649 
650 
651 
652 
653     /* ======== STRUCTS ======== */
654 
655     // Info for creating new bonds
656     struct Terms {
657         uint controlVariable; // scaling variable for price
658         uint vestingTerm; // in blocks
659         uint minimumPrice; // vs principle value
660         uint maxPayout; // in thousandths of a %. i.e. 500 = 0.5%
661         uint fee; // as % of bond payout, in hundreths. ( 500 = 5% = 0.05 for every 1 paid)
662         uint maxDebt; // 9 decimal debt ratio, max % total supply created as debt
663     }
664 
665     // Info for bond holder
666     struct Bond {
667         uint payout; // OHM remaining to be paid
668         uint vesting; // Blocks left to vest
669         uint lastBlock; // Last interaction
670         uint pricePaid; // In DAI, for front end viewing
671     }
672 
673     // Info for incremental adjustments to control variable 
674     struct Adjust {
675         bool add; // addition or subtraction
676         uint rate; // increment
677         uint target; // BCV when adjustment finished
678         uint buffer; // minimum length (in blocks) between adjustments
679         uint lastBlock; // block when last adjustment made
680     }
681 
682 
683 
684 
685     /* ======== INITIALIZATION ======== */
686 
687     constructor ( 
688         address _OHM,
689         address _principle,
690         address _treasury, 
691         address _DAO, 
692         address _bondCalculator
693     ) {
694         require( _OHM != address(0) );
695         OHM = _OHM;
696         require( _principle != address(0) );
697         principle = _principle;
698         require( _treasury != address(0) );
699         treasury = _treasury;
700         require( _DAO != address(0) );
701         DAO = _DAO;
702         // bondCalculator should be address(0) if not LP bond
703         bondCalculator = _bondCalculator;
704         isLiquidityBond = ( _bondCalculator != address(0) );
705     }
706 
707     /**
708      *  @notice initializes bond parameters
709      *  @param _controlVariable uint
710      *  @param _vestingTerm uint
711      *  @param _minimumPrice uint
712      *  @param _maxPayout uint
713      *  @param _fee uint
714      *  @param _maxDebt uint
715      *  @param _initialDebt uint
716      */
717     function initializeBondTerms( 
718         uint _controlVariable, 
719         uint _vestingTerm,
720         uint _minimumPrice,
721         uint _maxPayout,
722         uint _fee,
723         uint _maxDebt,
724         uint _initialDebt
725     ) external onlyPolicy() {
726         require( terms.controlVariable == 0, "Bonds must be initialized from 0" );
727         terms = Terms ({
728             controlVariable: _controlVariable,
729             vestingTerm: _vestingTerm,
730             minimumPrice: _minimumPrice,
731             maxPayout: _maxPayout,
732             fee: _fee,
733             maxDebt: _maxDebt
734         });
735         totalDebt = _initialDebt;
736         lastDecay = block.number;
737     }
738 
739 
740 
741     
742     /* ======== POLICY FUNCTIONS ======== */
743 
744     enum PARAMETER { VESTING, PAYOUT, FEE, DEBT }
745     /**
746      *  @notice set parameters for new bonds
747      *  @param _parameter PARAMETER
748      *  @param _input uint
749      */
750     function setBondTerms ( PARAMETER _parameter, uint _input ) external onlyPolicy() {
751         if ( _parameter == PARAMETER.VESTING ) { // 0
752             require( _input >= 10000, "Vesting must be longer than 36 hours" );
753             terms.vestingTerm = _input;
754         } else if ( _parameter == PARAMETER.PAYOUT ) { // 1
755             require( _input <= 1000, "Payout cannot be above 1 percent" );
756             terms.maxPayout = _input;
757         } else if ( _parameter == PARAMETER.FEE ) { // 2
758             require( _input <= 10000, "DAO fee cannot exceed payout" );
759             terms.fee = _input;
760         } else if ( _parameter == PARAMETER.DEBT ) { // 3
761             terms.maxDebt = _input;
762         }
763     }
764 
765     /**
766      *  @notice set control variable adjustment
767      *  @param _addition bool
768      *  @param _increment uint
769      *  @param _target uint
770      *  @param _buffer uint
771      */
772     function setAdjustment ( 
773         bool _addition,
774         uint _increment, 
775         uint _target,
776         uint _buffer 
777     ) external onlyPolicy() {
778         require( _increment <= terms.controlVariable.mul( 25 ).div( 1000 ), "Increment too large" );
779 
780         adjustment = Adjust({
781             add: _addition,
782             rate: _increment,
783             target: _target,
784             buffer: _buffer,
785             lastBlock: block.number
786         });
787     }
788 
789     /**
790      *  @notice set contract for auto stake
791      *  @param _staking address
792      *  @param _helper bool
793      */
794     function setStaking( address _staking, bool _helper ) external onlyPolicy() {
795         require( _staking != address(0) );
796         if ( _helper ) {
797             useHelper = true;
798             stakingHelper = _staking;
799         } else {
800             useHelper = false;
801             staking = _staking;
802         }
803     }
804 
805 
806     
807 
808     /* ======== USER FUNCTIONS ======== */
809 
810     /**
811      *  @notice deposit bond
812      *  @param _amount uint
813      *  @param _maxPrice uint
814      *  @param _depositor address
815      *  @return uint
816      */
817     function deposit( 
818         uint _amount, 
819         uint _maxPrice,
820         address _depositor
821     ) external returns ( uint ) {
822         require( _depositor != address(0), "Invalid address" );
823 
824         decayDebt();
825         require( totalDebt <= terms.maxDebt, "Max capacity reached" );
826         
827         uint priceInUSD = bondPriceInUSD(); // Stored in bond info
828         uint nativePrice = _bondPrice();
829 
830         require( _maxPrice >= nativePrice, "Slippage limit: more than max price" ); // slippage protection
831 
832         uint value = ITreasury( treasury ).valueOf( principle, _amount );
833         uint payout = payoutFor( value ); // payout to bonder is computed
834 
835         require( payout >= 10000000, "Bond too small" ); // must be > 0.01 OHM ( underflow protection )
836         require( payout <= maxPayout(), "Bond too large"); // size protection because there is no slippage
837 
838         // profits are calculated
839         uint fee = payout.mul( terms.fee ).div( 10000 );
840         uint profit = value.sub( payout ).sub( fee );
841 
842         /**
843             principle is transferred in
844             approved and
845             deposited into the treasury, returning (_amount - profit) OHM
846          */
847         IERC20( principle ).safeTransferFrom( msg.sender, address(this), _amount );
848         IERC20( principle ).approve( address( treasury ), _amount );
849         ITreasury( treasury ).deposit( _amount, principle, profit );
850         
851         if ( fee != 0 ) { // fee is transferred to dao 
852             IERC20( OHM ).safeTransfer( DAO, fee ); 
853         }
854         
855         // total debt is increased
856         totalDebt = totalDebt.add( value ); 
857                 
858         // depositor info is stored
859         bondInfo[ _depositor ] = Bond({ 
860             payout: bondInfo[ _depositor ].payout.add( payout ),
861             vesting: terms.vestingTerm,
862             lastBlock: block.number,
863             pricePaid: priceInUSD
864         });
865 
866         // indexed events are emitted
867         emit BondCreated( _amount, payout, block.number.add( terms.vestingTerm ), priceInUSD );
868         emit BondPriceChanged( bondPriceInUSD(), _bondPrice(), debtRatio() );
869 
870         adjust(); // control variable is adjusted
871         return payout; 
872     }
873 
874     /** 
875      *  @notice redeem bond for user
876      *  @param _recipient address
877      *  @param _stake bool
878      *  @return uint
879      */ 
880     function redeem( address _recipient, bool _stake ) external returns ( uint ) {        
881         Bond memory info = bondInfo[ _recipient ];
882         uint percentVested = percentVestedFor( _recipient ); // (blocks since last interaction / vesting term remaining)
883 
884         if ( percentVested >= 10000 ) { // if fully vested
885             delete bondInfo[ _recipient ]; // delete user info
886             emit BondRedeemed( _recipient, info.payout, 0 ); // emit bond data
887             return stakeOrSend( _recipient, _stake, info.payout ); // pay user everything due
888 
889         } else { // if unfinished
890             // calculate payout vested
891             uint payout = info.payout.mul( percentVested ).div( 10000 );
892 
893             // store updated deposit info
894             bondInfo[ _recipient ] = Bond({
895                 payout: info.payout.sub( payout ),
896                 vesting: info.vesting.sub( block.number.sub( info.lastBlock ) ),
897                 lastBlock: block.number,
898                 pricePaid: info.pricePaid
899             });
900 
901             emit BondRedeemed( _recipient, payout, bondInfo[ _recipient ].payout );
902             return stakeOrSend( _recipient, _stake, payout );
903         }
904     }
905 
906 
907 
908     
909     /* ======== INTERNAL HELPER FUNCTIONS ======== */
910 
911     /**
912      *  @notice allow user to stake payout automatically
913      *  @param _stake bool
914      *  @param _amount uint
915      *  @return uint
916      */
917     function stakeOrSend( address _recipient, bool _stake, uint _amount ) internal returns ( uint ) {
918         if ( !_stake ) { // if user does not want to stake
919             IERC20( OHM ).transfer( _recipient, _amount ); // send payout
920         } else { // if user wants to stake
921             if ( useHelper ) { // use if staking warmup is 0
922                 IERC20( OHM ).approve( stakingHelper, _amount );
923                 IStakingHelper( stakingHelper ).stake( _amount, _recipient );
924             } else {
925                 IERC20( OHM ).approve( staking, _amount );
926                 IStaking( staking ).stake( _amount, _recipient );
927             }
928         }
929         return _amount;
930     }
931 
932     /**
933      *  @notice makes incremental adjustment to control variable
934      */
935     function adjust() internal {
936         uint blockCanAdjust = adjustment.lastBlock.add( adjustment.buffer );
937         if( adjustment.rate != 0 && block.number >= blockCanAdjust ) {
938             uint initial = terms.controlVariable;
939             if ( adjustment.add ) {
940                 terms.controlVariable = terms.controlVariable.add( adjustment.rate );
941                 if ( terms.controlVariable >= adjustment.target ) {
942                     adjustment.rate = 0;
943                 }
944             } else {
945                 terms.controlVariable = terms.controlVariable.sub( adjustment.rate );
946                 if ( terms.controlVariable <= adjustment.target ) {
947                     adjustment.rate = 0;
948                 }
949             }
950             adjustment.lastBlock = block.number;
951             emit ControlVariableAdjustment( initial, terms.controlVariable, adjustment.rate, adjustment.add );
952         }
953     }
954 
955     /**
956      *  @notice reduce total debt
957      */
958     function decayDebt() internal {
959         totalDebt = totalDebt.sub( debtDecay() );
960         lastDecay = block.number;
961     }
962 
963 
964 
965 
966     /* ======== VIEW FUNCTIONS ======== */
967 
968     /**
969      *  @notice determine maximum bond size
970      *  @return uint
971      */
972     function maxPayout() public view returns ( uint ) {
973         return IERC20( OHM ).totalSupply().mul( terms.maxPayout ).div( 100000 );
974     }
975 
976     /**
977      *  @notice calculate interest due for new bond
978      *  @param _value uint
979      *  @return uint
980      */
981     function payoutFor( uint _value ) public view returns ( uint ) {
982         return FixedPoint.fraction( _value, bondPrice() ).decode112with18().div( 1e16 );
983     }
984 
985 
986     /**
987      *  @notice calculate current bond premium
988      *  @return price_ uint
989      */
990     function bondPrice() public view returns ( uint price_ ) {        
991         price_ = terms.controlVariable.mul( debtRatio() ).add( 1000000000 ).div( 1e7 );
992         if ( price_ < terms.minimumPrice ) {
993             price_ = terms.minimumPrice;
994         }
995     }
996 
997     /**
998      *  @notice calculate current bond price and remove floor if above
999      *  @return price_ uint
1000      */
1001     function _bondPrice() internal returns ( uint price_ ) {
1002         price_ = terms.controlVariable.mul( debtRatio() ).add( 1000000000 ).div( 1e7 );
1003         if ( price_ < terms.minimumPrice ) {
1004             price_ = terms.minimumPrice;        
1005         } else if ( terms.minimumPrice != 0 ) {
1006             terms.minimumPrice = 0;
1007         }
1008     }
1009 
1010     /**
1011      *  @notice converts bond price to DAI value
1012      *  @return price_ uint
1013      */
1014     function bondPriceInUSD() public view returns ( uint price_ ) {
1015         if( isLiquidityBond ) {
1016             price_ = bondPrice().mul( IBondCalculator( bondCalculator ).markdown( principle ) ).div( 100 );
1017         } else {
1018             price_ = bondPrice().mul( 10 ** IERC20( principle ).decimals() ).div( 100 );
1019         }
1020     }
1021 
1022 
1023     /**
1024      *  @notice calculate current ratio of debt to OHM supply
1025      *  @return debtRatio_ uint
1026      */
1027     function debtRatio() public view returns ( uint debtRatio_ ) {   
1028         uint supply = IERC20( OHM ).totalSupply();
1029         debtRatio_ = FixedPoint.fraction( 
1030             currentDebt().mul( 1e9 ), 
1031             supply
1032         ).decode112with18().div( 1e18 );
1033     }
1034 
1035     /**
1036      *  @notice debt ratio in same terms for reserve or liquidity bonds
1037      *  @return uint
1038      */
1039     function standardizedDebtRatio() external view returns ( uint ) {
1040         if ( isLiquidityBond ) {
1041             return debtRatio().mul( IBondCalculator( bondCalculator ).markdown( principle ) ).div( 1e9 );
1042         } else {
1043             return debtRatio();
1044         }
1045     }
1046 
1047     /**
1048      *  @notice calculate debt factoring in decay
1049      *  @return uint
1050      */
1051     function currentDebt() public view returns ( uint ) {
1052         return totalDebt.sub( debtDecay() );
1053     }
1054 
1055     /**
1056      *  @notice amount to decay total debt by
1057      *  @return decay_ uint
1058      */
1059     function debtDecay() public view returns ( uint decay_ ) {
1060         uint blocksSinceLast = block.number.sub( lastDecay );
1061         decay_ = totalDebt.mul( blocksSinceLast ).div( terms.vestingTerm );
1062         if ( decay_ > totalDebt ) {
1063             decay_ = totalDebt;
1064         }
1065     }
1066 
1067 
1068     /**
1069      *  @notice calculate how far into vesting a depositor is
1070      *  @param _depositor address
1071      *  @return percentVested_ uint
1072      */
1073     function percentVestedFor( address _depositor ) public view returns ( uint percentVested_ ) {
1074         Bond memory bond = bondInfo[ _depositor ];
1075         uint blocksSinceLast = block.number.sub( bond.lastBlock );
1076         uint vesting = bond.vesting;
1077 
1078         if ( vesting > 0 ) {
1079             percentVested_ = blocksSinceLast.mul( 10000 ).div( vesting );
1080         } else {
1081             percentVested_ = 0;
1082         }
1083     }
1084 
1085     /**
1086      *  @notice calculate amount of OHM available for claim by depositor
1087      *  @param _depositor address
1088      *  @return pendingPayout_ uint
1089      */
1090     function pendingPayoutFor( address _depositor ) external view returns ( uint pendingPayout_ ) {
1091         uint percentVested = percentVestedFor( _depositor );
1092         uint payout = bondInfo[ _depositor ].payout;
1093 
1094         if ( percentVested >= 10000 ) {
1095             pendingPayout_ = payout;
1096         } else {
1097             pendingPayout_ = payout.mul( percentVested ).div( 10000 );
1098         }
1099     }
1100 
1101 
1102 
1103 
1104     /* ======= AUXILLIARY ======= */
1105 
1106     /**
1107      *  @notice allow anyone to send lost tokens (excluding principle or OHM) to the DAO
1108      *  @return bool
1109      */
1110     function recoverLostToken( address _token ) external returns ( bool ) {
1111         require( _token != OHM );
1112         require( _token != principle );
1113         IERC20( _token ).safeTransfer( DAO, IERC20( _token ).balanceOf( address(this) ) );
1114         return true;
1115     }
1116 }