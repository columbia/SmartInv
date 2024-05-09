1 // SPDX-License-Identifier: AGPL-3.0-or-later
2 pragma solidity 0.7.5;
3 
4 interface IOwnable {
5   function policy() external view returns (address);
6 
7   function renounceManagement() external;
8   
9   function pushManagement( address newOwner_ ) external;
10   
11   function pullManagement() external;
12 }
13 
14 contract Ownable is IOwnable {
15 
16     address internal _owner;
17     address internal _newOwner;
18 
19     event OwnershipPushed(address indexed previousOwner, address indexed newOwner);
20     event OwnershipPulled(address indexed previousOwner, address indexed newOwner);
21 
22     constructor () {
23         _owner = msg.sender;
24         emit OwnershipPushed( address(0), _owner );
25     }
26 
27     function policy() public view override returns (address) {
28         return _owner;
29     }
30 
31     modifier onlyPolicy() {
32         require( _owner == msg.sender, "Ownable: caller is not the owner" );
33         _;
34     }
35 
36     function renounceManagement() public virtual override onlyPolicy() {
37         emit OwnershipPushed( _owner, address(0) );
38         _owner = address(0);
39     }
40 
41     function pushManagement( address newOwner_ ) public virtual override onlyPolicy() {
42         require( newOwner_ != address(0), "Ownable: new owner is the zero address");
43         emit OwnershipPushed( _owner, newOwner_ );
44         _newOwner = newOwner_;
45     }
46     
47     function pullManagement() public virtual override {
48         require( msg.sender == _newOwner, "Ownable: must be new owner to pull");
49         emit OwnershipPulled( _owner, _newOwner );
50         _owner = _newOwner;
51     }
52 }
53 
54 library SafeMath {
55 
56     function add(uint256 a, uint256 b) internal pure returns (uint256) {
57         uint256 c = a + b;
58         require(c >= a, "SafeMath: addition overflow");
59 
60         return c;
61     }
62 
63     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64         return sub(a, b, "SafeMath: subtraction overflow");
65     }
66 
67     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
68         require(b <= a, errorMessage);
69         uint256 c = a - b;
70 
71         return c;
72     }
73 
74     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
75         if (a == 0) {
76             return 0;
77         }
78 
79         uint256 c = a * b;
80         require(c / a == b, "SafeMath: multiplication overflow");
81 
82         return c;
83     }
84 
85     function div(uint256 a, uint256 b) internal pure returns (uint256) {
86         return div(a, b, "SafeMath: division by zero");
87     }
88 
89     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
90         require(b > 0, errorMessage);
91         uint256 c = a / b;
92         return c;
93     }
94 
95     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
96         return mod(a, b, "SafeMath: modulo by zero");
97     }
98 
99     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
100         require(b != 0, errorMessage);
101         return a % b;
102     }
103 
104     function sqrrt(uint256 a) internal pure returns (uint c) {
105         if (a > 3) {
106             c = a;
107             uint b = add( div( a, 2), 1 );
108             while (b < c) {
109                 c = b;
110                 b = div( add( div( a, b ), b), 2 );
111             }
112         } else if (a != 0) {
113             c = 1;
114         }
115     }
116 }
117 
118 library Address {
119 
120     function isContract(address account) internal view returns (bool) {
121 
122         uint256 size;
123         // solhint-disable-next-line no-inline-assembly
124         assembly { size := extcodesize(account) }
125         return size > 0;
126     }
127 
128     function sendValue(address payable recipient, uint256 amount) internal {
129         require(address(this).balance >= amount, "Address: insufficient balance");
130 
131         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
132         (bool success, ) = recipient.call{ value: amount }("");
133         require(success, "Address: unable to send value, recipient may have reverted");
134     }
135 
136     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
137       return functionCall(target, data, "Address: low-level call failed");
138     }
139 
140     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
141         return _functionCallWithValue(target, data, 0, errorMessage);
142     }
143 
144     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
145         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
146     }
147 
148     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
149         require(address(this).balance >= value, "Address: insufficient balance for call");
150         require(isContract(target), "Address: call to non-contract");
151 
152         // solhint-disable-next-line avoid-low-level-calls
153         (bool success, bytes memory returndata) = target.call{ value: value }(data);
154         return _verifyCallResult(success, returndata, errorMessage);
155     }
156 
157     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
158         require(isContract(target), "Address: call to non-contract");
159 
160         // solhint-disable-next-line avoid-low-level-calls
161         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
162         if (success) {
163             return returndata;
164         } else {
165             // Look for revert reason and bubble it up if present
166             if (returndata.length > 0) {
167                 // The easiest way to bubble the revert reason is using memory via assembly
168 
169                 // solhint-disable-next-line no-inline-assembly
170                 assembly {
171                     let returndata_size := mload(returndata)
172                     revert(add(32, returndata), returndata_size)
173                 }
174             } else {
175                 revert(errorMessage);
176             }
177         }
178     }
179 
180     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
181         return functionStaticCall(target, data, "Address: low-level static call failed");
182     }
183 
184     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
185         require(isContract(target), "Address: static call to non-contract");
186 
187         // solhint-disable-next-line avoid-low-level-calls
188         (bool success, bytes memory returndata) = target.staticcall(data);
189         return _verifyCallResult(success, returndata, errorMessage);
190     }
191 
192     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
193         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
194     }
195 
196     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
197         require(isContract(target), "Address: delegate call to non-contract");
198 
199         // solhint-disable-next-line avoid-low-level-calls
200         (bool success, bytes memory returndata) = target.delegatecall(data);
201         return _verifyCallResult(success, returndata, errorMessage);
202     }
203 
204     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
205         if (success) {
206             return returndata;
207         } else {
208             if (returndata.length > 0) {
209 
210                 assembly {
211                     let returndata_size := mload(returndata)
212                     revert(add(32, returndata), returndata_size)
213                 }
214             } else {
215                 revert(errorMessage);
216             }
217         }
218     }
219 
220     function addressToString(address _address) internal pure returns(string memory) {
221         bytes32 _bytes = bytes32(uint256(_address));
222         bytes memory HEX = "0123456789abcdef";
223         bytes memory _addr = new bytes(42);
224 
225         _addr[0] = '0';
226         _addr[1] = 'x';
227 
228         for(uint256 i = 0; i < 20; i++) {
229             _addr[2+i*2] = HEX[uint8(_bytes[i + 12] >> 4)];
230             _addr[3+i*2] = HEX[uint8(_bytes[i + 12] & 0x0f)];
231         }
232 
233         return string(_addr);
234 
235     }
236 }
237 
238 interface IERC20 {
239     function decimals() external view returns (uint8);
240 
241     function totalSupply() external view returns (uint256);
242 
243     function balanceOf(address account) external view returns (uint256);
244 
245     function transfer(address recipient, uint256 amount) external returns (bool);
246 
247     function allowance(address owner, address spender) external view returns (uint256);
248 
249     function approve(address spender, uint256 amount) external returns (bool);
250 
251     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
252 
253     event Transfer(address indexed from, address indexed to, uint256 value);
254 
255     event Approval(address indexed owner, address indexed spender, uint256 value);
256 }
257 
258 abstract contract ERC20 is IERC20 {
259 
260     using SafeMath for uint256;
261 
262     // TODO comment actual hash value.
263     bytes32 constant private ERC20TOKEN_ERC1820_INTERFACE_ID = keccak256( "ERC20Token" );
264     
265     mapping (address => uint256) internal _balances;
266 
267     mapping (address => mapping (address => uint256)) internal _allowances;
268 
269     uint256 internal _totalSupply;
270 
271     string internal _name;
272     
273     string internal _symbol;
274     
275     uint8 internal _decimals;
276 
277     constructor (string memory name_, string memory symbol_, uint8 decimals_) {
278         _name = name_;
279         _symbol = symbol_;
280         _decimals = decimals_;
281     }
282 
283     function name() public view returns (string memory) {
284         return _name;
285     }
286 
287     function symbol() public view returns (string memory) {
288         return _symbol;
289     }
290 
291     function decimals() public view override returns (uint8) {
292         return _decimals;
293     }
294 
295     function totalSupply() public view override returns (uint256) {
296         return _totalSupply;
297     }
298 
299     function balanceOf(address account) public view virtual override returns (uint256) {
300         return _balances[account];
301     }
302 
303     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
304         _transfer(msg.sender, recipient, amount);
305         return true;
306     }
307 
308     function allowance(address owner, address spender) public view virtual override returns (uint256) {
309         return _allowances[owner][spender];
310     }
311 
312     function approve(address spender, uint256 amount) public virtual override returns (bool) {
313         _approve(msg.sender, spender, amount);
314         return true;
315     }
316 
317     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
318         _transfer(sender, recipient, amount);
319         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
320         return true;
321     }
322 
323     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
324         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
325         return true;
326     }
327 
328     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
329         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
330         return true;
331     }
332 
333     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
334         require(sender != address(0), "ERC20: transfer from the zero address");
335         require(recipient != address(0), "ERC20: transfer to the zero address");
336 
337         _beforeTokenTransfer(sender, recipient, amount);
338 
339         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
340         _balances[recipient] = _balances[recipient].add(amount);
341         emit Transfer(sender, recipient, amount);
342     }
343 
344     function _mint(address account_, uint256 ammount_) internal virtual {
345         require(account_ != address(0), "ERC20: mint to the zero address");
346         _beforeTokenTransfer(address( this ), account_, ammount_);
347         _totalSupply = _totalSupply.add(ammount_);
348         _balances[account_] = _balances[account_].add(ammount_);
349         emit Transfer(address( this ), account_, ammount_);
350     }
351 
352     function _burn(address account, uint256 amount) internal virtual {
353         require(account != address(0), "ERC20: burn from the zero address");
354 
355         _beforeTokenTransfer(account, address(0), amount);
356 
357         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
358         _totalSupply = _totalSupply.sub(amount);
359         emit Transfer(account, address(0), amount);
360     }
361 
362     function _approve(address owner, address spender, uint256 amount) internal virtual {
363         require(owner != address(0), "ERC20: approve from the zero address");
364         require(spender != address(0), "ERC20: approve to the zero address");
365 
366         _allowances[owner][spender] = amount;
367         emit Approval(owner, spender, amount);
368     }
369 
370   function _beforeTokenTransfer( address from_, address to_, uint256 amount_ ) internal virtual { }
371 }
372 
373 interface IERC2612Permit {
374 
375     function permit(
376         address owner,
377         address spender,
378         uint256 amount,
379         uint256 deadline,
380         uint8 v,
381         bytes32 r,
382         bytes32 s
383     ) external;
384 
385     function nonces(address owner) external view returns (uint256);
386 }
387 
388 library Counters {
389     using SafeMath for uint256;
390 
391     struct Counter {
392 
393         uint256 _value; // default: 0
394     }
395 
396     function current(Counter storage counter) internal view returns (uint256) {
397         return counter._value;
398     }
399 
400     function increment(Counter storage counter) internal {
401         counter._value += 1;
402     }
403 
404     function decrement(Counter storage counter) internal {
405         counter._value = counter._value.sub(1);
406     }
407 }
408 
409 abstract contract ERC20Permit is ERC20, IERC2612Permit {
410     using Counters for Counters.Counter;
411 
412     mapping(address => Counters.Counter) private _nonces;
413 
414     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
415     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
416 
417     bytes32 public DOMAIN_SEPARATOR;
418 
419     constructor() {
420         uint256 chainID;
421         assembly {
422             chainID := chainid()
423         }
424 
425         DOMAIN_SEPARATOR = keccak256(
426             abi.encode(
427                 keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
428                 keccak256(bytes(name())),
429                 keccak256(bytes("1")), // Version
430                 chainID,
431                 address(this)
432             )
433         );
434     }
435 
436     function permit(
437         address owner,
438         address spender,
439         uint256 amount,
440         uint256 deadline,
441         uint8 v,
442         bytes32 r,
443         bytes32 s
444     ) public virtual override {
445         require(block.timestamp <= deadline, "Permit: expired deadline");
446 
447         bytes32 hashStruct =
448             keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, amount, _nonces[owner].current(), deadline));
449 
450         bytes32 _hash = keccak256(abi.encodePacked(uint16(0x1901), DOMAIN_SEPARATOR, hashStruct));
451 
452         address signer = ecrecover(_hash, v, r, s);
453         require(signer != address(0) && signer == owner, "ZeroSwapPermit: Invalid signature");
454 
455         _nonces[owner].increment();
456         _approve(owner, spender, amount);
457     }
458 
459     function nonces(address owner) public view override returns (uint256) {
460         return _nonces[owner].current();
461     }
462 }
463 
464 library SafeERC20 {
465     using SafeMath for uint256;
466     using Address for address;
467 
468     function safeTransfer(IERC20 token, address to, uint256 value) internal {
469         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
470     }
471 
472     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
473         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
474     }
475 
476     function safeApprove(IERC20 token, address spender, uint256 value) internal {
477 
478         require((value == 0) || (token.allowance(address(this), spender) == 0),
479             "SafeERC20: approve from non-zero to non-zero allowance"
480         );
481         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
482     }
483 
484     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
485         uint256 newAllowance = token.allowance(address(this), spender).add(value);
486         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
487     }
488 
489     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
490         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
491         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
492     }
493 
494     function _callOptionalReturn(IERC20 token, bytes memory data) private {
495 
496         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
497         if (returndata.length > 0) { // Return data is optional
498             // solhint-disable-next-line max-line-length
499             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
500         }
501     }
502 }
503 
504 library FullMath {
505     function fullMul(uint256 x, uint256 y) private pure returns (uint256 l, uint256 h) {
506         uint256 mm = mulmod(x, y, uint256(-1));
507         l = x * y;
508         h = mm - l;
509         if (mm < l) h -= 1;
510     }
511 
512     function fullDiv(
513         uint256 l,
514         uint256 h,
515         uint256 d
516     ) private pure returns (uint256) {
517         uint256 pow2 = d & -d;
518         d /= pow2;
519         l /= pow2;
520         l += h * ((-pow2) / pow2 + 1);
521         uint256 r = 1;
522         r *= 2 - d * r;
523         r *= 2 - d * r;
524         r *= 2 - d * r;
525         r *= 2 - d * r;
526         r *= 2 - d * r;
527         r *= 2 - d * r;
528         r *= 2 - d * r;
529         r *= 2 - d * r;
530         return l * r;
531     }
532 
533     function mulDiv(
534         uint256 x,
535         uint256 y,
536         uint256 d
537     ) internal pure returns (uint256) {
538         (uint256 l, uint256 h) = fullMul(x, y);
539         uint256 mm = mulmod(x, y, d);
540         if (mm > l) h -= 1;
541         l -= mm;
542         require(h < d, 'FullMath::mulDiv: overflow');
543         return fullDiv(l, h, d);
544     }
545 }
546 
547 library FixedPoint {
548 
549     struct uq112x112 {
550         uint224 _x;
551     }
552 
553     struct uq144x112 {
554         uint256 _x;
555     }
556 
557     uint8 private constant RESOLUTION = 112;
558     uint256 private constant Q112 = 0x10000000000000000000000000000;
559     uint256 private constant Q224 = 0x100000000000000000000000000000000000000000000000000000000;
560     uint256 private constant LOWER_MASK = 0xffffffffffffffffffffffffffff; // decimal of UQ*x112 (lower 112 bits)
561 
562     function decode(uq112x112 memory self) internal pure returns (uint112) {
563         return uint112(self._x >> RESOLUTION);
564     }
565 
566     function decode112with18(uq112x112 memory self) internal pure returns (uint) {
567 
568         return uint(self._x) / 5192296858534827;
569     }
570 
571     function fraction(uint256 numerator, uint256 denominator) internal pure returns (uq112x112 memory) {
572         require(denominator > 0, 'FixedPoint::fraction: division by zero');
573         if (numerator == 0) return FixedPoint.uq112x112(0);
574 
575         if (numerator <= uint144(-1)) {
576             uint256 result = (numerator << RESOLUTION) / denominator;
577             require(result <= uint224(-1), 'FixedPoint::fraction: overflow');
578             return uq112x112(uint224(result));
579         } else {
580             uint256 result = FullMath.mulDiv(numerator, Q112, denominator);
581             require(result <= uint224(-1), 'FixedPoint::fraction: overflow');
582             return uq112x112(uint224(result));
583         }
584     }
585 }
586 
587 interface ITreasury {
588     function deposit( uint _amount, address _token, uint _profit ) external returns ( bool );
589     function valueOf( address _token, uint _amount ) external view returns ( uint value_ );
590 }
591 
592 interface IBarterCalculator {
593     function valuation( address _LP, uint _amount ) external view returns ( uint );
594     function markdown( address _LP ) external view returns ( uint );
595 }
596 
597 interface IStaking {
598     function stake( uint _amount, address _recipient ) external returns ( bool );
599 }
600 
601 interface IStakingHelper {
602     function stake( uint _amount, address _recipient ) external;
603 }
604 
605 contract UniversalBarterDepository is Ownable {
606 
607     using FixedPoint for *;
608     using SafeERC20 for IERC20;
609     using SafeMath for uint;
610 
611 
612 
613 
614     /* ======== EVENTS ======== */
615 
616     event BarterCreated( uint deposit, uint indexed payout, uint indexed expires, uint indexed priceInUSD );
617     event BarterRedeemed( address indexed recipient, uint payout, uint remaining );
618     event BarterPriceChanged( uint indexed priceInUSD, uint indexed internalPrice, uint indexed debtRatio );
619     event ControlVariableAdjustment( uint initialBCV, uint newBCV, uint adjustment, bool addition );
620 
621 
622 
623 
624     /* ======== STATE VARIABLES ======== */
625 
626     address public immutable USV; // token given as payment for barter
627     address public immutable principle; // token used to create barter
628     address public immutable treasury; // mints USV when receives principle
629     address public immutable AtlasTeam; // receives profit share from barter
630 
631     bool public immutable isLiquidityBarter; // LP and Reserve barters are treated slightly different
632     address public immutable barterCalculator; // calculates value of LP tokens
633 
634     address public staking; // to auto-stake payout
635     address public stakingHelper; // to stake and claim if no staking warmup
636     bool public useHelper;
637 
638     Terms public terms; // stores terms for new barters
639     Adjust public adjustment; // stores adjustment to BCV data
640 
641     mapping( address => Barter ) public barterInfo; // stores barter information for depositors
642 
643     uint public totalDebt; // total value of outstanding barters; used for pricing
644     uint public lastDecay; // reference block for debt decay
645 
646 
647 
648 
649     /* ======== STRUCTS ======== */
650 
651     // Info for creating new barters
652     struct Terms {
653         uint controlVariable; // scaling variable for price
654         uint vestingTerm; // in blocks
655         uint minimumPrice; // vs principle value
656         uint maxPayout; // in thousandths of a %. i.e. 500 = 0.5%
657         uint fee; // as % of barter payout, in hundreths. ( 500 = 5% = 0.05 for every 1 paid)
658         uint maxDebt; // 9 decimal debt ratio, max % total supply created as debt
659     }
660 
661     // Info for barterer
662     struct Barter {
663         uint payout; // USV remaining to be paid
664         uint vesting; // Blocks left to vest
665         uint lastBlock; // Last interaction
666         uint pricePaid; // In DAI, for front end viewing
667     }
668 
669     // Info for incremental adjustments to control variable 
670     struct Adjust {
671         bool add; // addition or subtraction
672         uint rate; // increment
673         uint target; // BCV when adjustment finished
674         uint buffer; // minimum length (in blocks) between adjustments
675         uint lastBlock; // block when last adjustment made
676     }
677 
678 
679 
680 
681     /* ======== INITIALIZATION ======== */
682 
683     constructor ( 
684         address _USV,
685         address _principle,
686         address _treasury, 
687         address _AtlasTeam, 
688         address _barterCalculator
689     ) {
690         require( _USV != address(0) );
691         USV = _USV;
692         require( _principle != address(0) );
693         principle = _principle;
694         require( _treasury != address(0) );
695         treasury = _treasury;
696         require( _AtlasTeam != address(0) );
697         AtlasTeam = _AtlasTeam;
698         // barterCalculator should be address(0) if not LP barter
699         barterCalculator = _barterCalculator;
700         isLiquidityBarter = ( _barterCalculator != address(0) );
701     }
702 
703     /**
704      *  @notice initializes barter parameters
705      *  @param _controlVariable uint
706      *  @param _vestingTerm uint
707      *  @param _minimumPrice uint
708      *  @param _maxPayout uint
709      *  @param _fee uint
710      *  @param _maxDebt uint
711      *  @param _initialDebt uint
712      */
713     function initializeBarterTerms( 
714         uint _controlVariable, 
715         uint _vestingTerm,
716         uint _minimumPrice,
717         uint _maxPayout,
718         uint _fee,
719         uint _maxDebt,
720         uint _initialDebt
721     ) external onlyPolicy() {
722         require( terms.controlVariable == 0, "Barters must be initialized from 0" );
723         terms = Terms ({
724             controlVariable: _controlVariable,
725             vestingTerm: _vestingTerm,
726             minimumPrice: _minimumPrice,
727             maxPayout: _maxPayout,
728             fee: _fee,
729             maxDebt: _maxDebt
730         });
731         totalDebt = _initialDebt;
732         lastDecay = block.number;
733     }
734 
735 
736 
737     
738     /* ======== POLICY FUNCTIONS ======== */
739 
740     enum PARAMETER { VESTING, PAYOUT, FEE, DEBT }
741     /**
742      *  @notice set parameters for new barters
743      *  @param _parameter PARAMETER
744      *  @param _input uint
745      */
746     function setBarterTerms ( PARAMETER _parameter, uint _input ) external onlyPolicy() {
747         if ( _parameter == PARAMETER.VESTING ) { // 0
748             require( _input >= 58378, "Vesting must be longer than 36 hours" );
749             terms.vestingTerm = _input;
750         } else if ( _parameter == PARAMETER.PAYOUT ) { // 1
751             require( _input <= 1000, "Payout cannot be above 1 percent" );
752             terms.maxPayout = _input;
753         } else if ( _parameter == PARAMETER.FEE ) { // 2
754             require( _input <= 10000, "AtlasTeam fee cannot exceed payout" );
755             terms.fee = _input;
756         } else if ( _parameter == PARAMETER.DEBT ) { // 3
757             terms.maxDebt = _input;
758         }
759     }
760 
761     /**
762      *  @notice set control variable adjustment
763      *  @param _addition bool
764      *  @param _increment uint
765      *  @param _target uint
766      *  @param _buffer uint
767      */
768     function setAdjustment ( 
769         bool _addition,
770         uint _increment, 
771         uint _target,
772         uint _buffer 
773     ) external onlyPolicy() {
774         require( _increment <= terms.controlVariable.mul( 500 ).div( 1000 ), "Increment too large" );
775 
776         adjustment = Adjust({
777             add: _addition,
778             rate: _increment,
779             target: _target,
780             buffer: _buffer,
781             lastBlock: block.number
782         });
783     }
784 
785     /**
786      *  @notice set contract for auto stake
787      *  @param _staking address
788      *  @param _helper bool
789      */
790     function setStaking( address _staking, bool _helper ) external onlyPolicy() {
791         require( _staking != address(0) );
792         if ( _helper ) {
793             useHelper = true;
794             stakingHelper = _staking;
795         } else {
796             useHelper = false;
797             staking = _staking;
798         }
799     }
800 
801 
802     
803 
804     /* ======== USER FUNCTIONS ======== */
805 
806     /**
807      *  @notice deposit barter
808      *  @param _amount uint
809      *  @param _maxPrice uint
810      *  @param _depositor address
811      *  @return uint
812      */
813     function deposit( 
814         uint _amount, 
815         uint _maxPrice,
816         address _depositor
817     ) external returns ( uint ) {
818         require( _depositor != address(0), "Invalid address" );
819 
820         decayDebt();
821         require( totalDebt <= terms.maxDebt, "Max capacity reached" );
822         
823         uint priceInUSD = barterPriceInUSD(); // Stored in barter info
824         uint nativePrice = _barterPrice();
825 
826         require( _maxPrice >= nativePrice, "Slippage limit: more than max price" ); // slippage protection
827 
828         uint value = ITreasury( treasury ).valueOf( principle, _amount ); 
829         uint payout = payoutFor( value ); // payout to barterer is computed
830 
831         require( payout >= 10000000, "Barter too small" ); // must be > 0.01 USV (10e7) ( underflow protection )
832         require( payout <= maxPayout(), "Barter too large"); // size protection because there is no slippage
833 
834         // profits are calculated
835         uint fee = payout.mul( terms.fee ).div( 10000 );
836         uint profit = value.sub( payout ).sub( fee );
837 
838         /**
839             principle is transferred in
840             approved and
841             deposited into the treasury, returning (_amount - profit) USV
842          */
843         IERC20( principle ).safeTransferFrom( msg.sender, address(this), _amount );
844         IERC20( principle ).approve( address( treasury ), _amount );
845         ITreasury( treasury ).deposit( _amount, principle, profit );
846         
847         if ( fee != 0 ) { // fee is transferred to AtlasTeam 
848             IERC20( USV ).safeTransfer( AtlasTeam, fee ); 
849         }
850         
851         // total debt is increased
852         totalDebt = totalDebt.add( value ); 
853                 
854         // depositor info is stored
855         barterInfo[ _depositor ] = Barter({ 
856             payout: barterInfo[ _depositor ].payout.add( payout ),
857             vesting: terms.vestingTerm,
858             lastBlock: block.number,
859             pricePaid: priceInUSD
860         });
861 
862         // indexed events are emitted
863         emit BarterCreated( _amount, payout, block.number.add( terms.vestingTerm ), priceInUSD );
864         emit BarterPriceChanged( barterPriceInUSD(), _barterPrice(), debtRatio() );
865 
866         adjust(); // control variable is adjusted
867         return payout; 
868     }
869 
870     /** 
871      *  @notice redeem barter for user
872      *  @param _recipient address
873      *  @param _stake bool
874      *  @return uint
875      */ 
876     function redeem( address _recipient, bool _stake ) external returns ( uint ) {        
877         Barter memory info = barterInfo[ _recipient ];
878         uint percentVested = percentVestedFor( _recipient ); // (blocks since last interaction / vesting term remaining)
879 
880         if ( percentVested >= 10000 ) { // if fully vested
881             delete barterInfo[ _recipient ]; // delete user info
882             emit BarterRedeemed( _recipient, info.payout, 0 ); // emit barter data
883             return stakeOrSend( _recipient, _stake, info.payout ); // pay user everything due
884 
885         } else { // if unfinished
886             // calculate payout vested
887             uint payout = info.payout.mul( percentVested ).div( 10000 );
888 
889             // store updated deposit info
890             barterInfo[ _recipient ] = Barter({
891                 payout: info.payout.sub( payout ),
892                 vesting: info.vesting.sub( block.number.sub( info.lastBlock ) ),
893                 lastBlock: block.number,
894                 pricePaid: info.pricePaid
895             });
896 
897             emit BarterRedeemed( _recipient, payout, barterInfo[ _recipient ].payout );
898             return stakeOrSend( _recipient, _stake, payout );
899         }
900     }
901 
902 
903 
904     
905     /* ======== INTERNAL HELPER FUNCTIONS ======== */
906 
907     /**
908      *  @notice allow user to stake payout automatically
909      *  @param _stake bool
910      *  @param _amount uint
911      *  @return uint
912      */
913     function stakeOrSend( address _recipient, bool _stake, uint _amount ) internal returns ( uint ) {
914         if ( !_stake ) { // if user does not want to stake
915             IERC20( USV ).transfer( _recipient, _amount ); // send payout
916         } else { // if user wants to stake
917             if ( useHelper ) { // use if staking warmup is 0
918                 IERC20( USV ).approve( stakingHelper, _amount );
919                 IStakingHelper( stakingHelper ).stake( _amount, _recipient );
920             } else {
921                 IERC20( USV ).approve( staking, _amount );
922                 IStaking( staking ).stake( _amount, _recipient );
923             }
924         }
925         return _amount;
926     }
927 
928     /**
929      *  @notice makes incremental adjustment to control variable
930      */
931     function adjust() internal {
932         uint blockCanAdjust = adjustment.lastBlock.add( adjustment.buffer );
933         if( adjustment.rate != 0 && block.number >= blockCanAdjust ) {
934             uint initial = terms.controlVariable;
935             if ( adjustment.add ) {
936                 terms.controlVariable = terms.controlVariable.add( adjustment.rate );
937                 if ( terms.controlVariable >= adjustment.target ) {
938                     adjustment.rate = 0;
939                 }
940             } else {
941                 terms.controlVariable = terms.controlVariable.sub( adjustment.rate );
942                 if ( terms.controlVariable <= adjustment.target ) {
943                     adjustment.rate = 0;
944                 }
945             }
946             adjustment.lastBlock = block.number;
947             emit ControlVariableAdjustment( initial, terms.controlVariable, adjustment.rate, adjustment.add );
948         }
949     }
950 
951     /**
952      *  @notice reduce total debt
953      */
954     function decayDebt() internal {
955         totalDebt = totalDebt.sub( debtDecay() );
956         lastDecay = block.number;
957     }
958 
959 
960 
961 
962     /* ======== VIEW FUNCTIONS ======== */
963 
964     /**
965      *  @notice determine maximum barter size
966      *  @return uint
967      */
968     function maxPayout() public view returns ( uint ) {
969         return IERC20( USV ).totalSupply().mul( terms.maxPayout ).div( 100000 );
970     }
971 
972     /**
973      *  @notice calculate interest due for new barter
974      *  @param _value uint
975      *  @return uint
976      */
977     function payoutFor( uint _value ) public view returns ( uint ) {
978         return FixedPoint.fraction( _value, barterPrice() ).decode112with18().div( 1e16 );
979     }
980 
981 
982     /**
983      *  @notice calculate current barter premium
984      *  @return price_ uint
985      */
986     function barterPrice() public view returns ( uint price_ ) {        
987         price_ = terms.controlVariable.mul( debtRatio() ).add( 1000000000 ).div( 1e7 );
988         if ( price_ < terms.minimumPrice ) {
989             price_ = terms.minimumPrice;
990         }
991     }
992 
993     /**
994      *  @notice calculate current barter price and remove floor if above
995      *  @return price_ uint
996      */
997     function _barterPrice() internal returns ( uint price_ ) {
998         price_ = terms.controlVariable.mul( debtRatio() ).add( 1000000000 ).div( 1e7 );
999         if ( price_ < terms.minimumPrice ) {
1000             price_ = terms.minimumPrice;        
1001         } else if ( terms.minimumPrice != 0 ) {
1002             terms.minimumPrice = 0;
1003         }
1004     }
1005 
1006     /**
1007      *  @notice converts barter price to DAI value
1008      *  @return price_ uint
1009      */
1010     function barterPriceInUSD() public view returns ( uint price_ ) {
1011         if( isLiquidityBarter ) {
1012             price_ = barterPrice().mul( IBarterCalculator( barterCalculator ).markdown( principle ) ).div( 100 );
1013         } else {
1014             price_ = barterPrice().mul( 10 ** IERC20( principle ).decimals() ).div( 100 );
1015         }
1016     }
1017 
1018 
1019     /**
1020      *  @notice calculate current ratio of debt to USV supply
1021      *  @return debtRatio_ uint
1022      */
1023     function debtRatio() public view returns ( uint debtRatio_ ) {   
1024         uint supply = IERC20( USV ).totalSupply();
1025         debtRatio_ = FixedPoint.fraction( 
1026             currentDebt().mul( 1e9 ), 
1027             supply
1028         ).decode112with18().div( 1e18 );
1029     }
1030 
1031     /**
1032      *  @notice debt ratio in same terms for reserve or liquidity barters
1033      *  @return uint
1034      */
1035     function standardizedDebtRatio() external view returns ( uint ) {
1036         if ( isLiquidityBarter ) {
1037             return debtRatio().mul( IBarterCalculator( barterCalculator ).markdown( principle ) ).div( 1e9 );
1038         } else {
1039             return debtRatio();
1040         }
1041     }
1042 
1043     /**
1044      *  @notice calculate debt factoring in decay
1045      *  @return uint
1046      */
1047     function currentDebt() public view returns ( uint ) {
1048         return totalDebt.sub( debtDecay() );
1049     }
1050 
1051     /**
1052      *  @notice amount to decay total debt by
1053      *  @return decay_ uint
1054      */
1055     function debtDecay() public view returns ( uint decay_ ) {
1056         uint blocksSinceLast = block.number.sub( lastDecay );
1057         decay_ = totalDebt.mul( blocksSinceLast ).div( terms.vestingTerm );
1058         if ( decay_ > totalDebt ) {
1059             decay_ = totalDebt;
1060         }
1061     }
1062 
1063 
1064     /**
1065      *  @notice calculate how far into vesting a depositor is
1066      *  @param _depositor address
1067      *  @return percentVested_ uint
1068      */
1069     function percentVestedFor( address _depositor ) public view returns ( uint percentVested_ ) {
1070         Barter memory barter = barterInfo[ _depositor ];
1071         uint blocksSinceLast = block.number.sub( barter.lastBlock );
1072         uint vesting = barter.vesting;
1073 
1074         if ( vesting > 0 ) {
1075             percentVested_ = blocksSinceLast.mul( 10000 ).div( vesting );
1076         } else {
1077             percentVested_ = 0;
1078         }
1079     }
1080 
1081     /**
1082      *  @notice calculate amount of USV available for claim by depositor
1083      *  @param _depositor address
1084      *  @return pendingPayout_ uint
1085      */
1086     function pendingPayoutFor( address _depositor ) external view returns ( uint pendingPayout_ ) {
1087         uint percentVested = percentVestedFor( _depositor );
1088         uint payout = barterInfo[ _depositor ].payout;
1089 
1090         if ( percentVested >= 10000 ) {
1091             pendingPayout_ = payout;
1092         } else {
1093             pendingPayout_ = payout.mul( percentVested ).div( 10000 );
1094         }
1095     }
1096 
1097 
1098 
1099 
1100     /* ======= AUXILLIARY ======= */
1101 
1102     /**
1103      *  @notice allow anyone to send lost tokens (excluding principle or USV) to the AtlasTeam
1104      *  @return bool
1105      */
1106     function recoverLostToken( address _token ) external returns ( bool ) {
1107         require( _token != USV );
1108         require( _token != principle );
1109         IERC20( _token ).safeTransfer( AtlasTeam, IERC20( _token ).balanceOf( address(this) ) );
1110         return true;
1111     }
1112 }