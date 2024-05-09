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
587 interface AggregatorV3Interface {
588 
589   function decimals() external view returns (uint8);
590   function description() external view returns (string memory);
591   function version() external view returns (uint256);
592 
593   // getRoundData and latestRoundData should both raise "No data present"
594   // if they do not have data to report, instead of returning unset values
595   // which could be misinterpreted as actual reported values.
596   function getRoundData(uint80 _roundId)
597     external
598     view
599     returns (
600       uint80 roundId,
601       int256 answer,
602       uint256 startedAt,
603       uint256 updatedAt,
604       uint80 answeredInRound
605     );
606   function latestRoundData()
607     external
608     view
609     returns (
610       uint80 roundId,
611       int256 answer,
612       uint256 startedAt,
613       uint256 updatedAt,
614       uint80 answeredInRound
615     );
616 }
617 
618 interface ITreasury {
619     function deposit( uint _amount, address _token, uint _profit ) external returns ( bool );
620     function valueOf( address _token, uint _amount ) external view returns ( uint value_ );
621     function mintRewards( address _recipient, uint _amount ) external;
622 }
623 
624 interface IStaking {
625     function stake( uint _amount, address _recipient ) external returns ( bool );
626 }
627 
628 interface IStakingHelper {
629     function stake( uint _amount, address _recipient ) external;
630 }
631 
632 contract OlympusBondDepository is Ownable {
633 
634     using FixedPoint for *;
635     using SafeERC20 for IERC20;
636     using SafeMath for uint;
637 
638 
639 
640 
641     /* ======== EVENTS ======== */
642 
643     event BondCreated( uint deposit, uint indexed payout, uint indexed expires, uint indexed priceInUSD );
644     event BondRedeemed( address indexed recipient, uint payout, uint remaining );
645     event BondPriceChanged( uint indexed priceInUSD, uint indexed internalPrice, uint indexed debtRatio );
646     event ControlVariableAdjustment( uint initialBCV, uint newBCV, uint adjustment, bool addition );
647 
648 
649 
650 
651     /* ======== STATE VARIABLES ======== */
652 
653     address public immutable OHM; // token given as payment for bond
654     address public immutable principle; // token used to create bond
655     address public immutable treasury; // mints OHM when receives principle
656     address public immutable DAO; // receives profit share from bond
657 
658     AggregatorV3Interface internal priceFeed;
659 
660     address public staking; // to auto-stake payout
661     address public stakingHelper; // to stake and claim if no staking warmup
662     bool public useHelper;
663 
664     Terms public terms; // stores terms for new bonds
665     Adjust public adjustment; // stores adjustment to BCV data
666 
667     mapping( address => Bond ) public bondInfo; // stores bond information for depositors
668 
669     uint public totalDebt; // total value of outstanding bonds; used for pricing
670     uint public lastDecay; // reference block for debt decay
671 
672 
673 
674 
675     /* ======== STRUCTS ======== */
676 
677     // Info for creating new bonds
678     struct Terms {
679         uint controlVariable; // scaling variable for price
680         uint vestingTerm; // in blocks
681         uint minimumPrice; // vs principle value. 4 decimals (1500 = 0.15)
682         uint maxPayout; // in thousandths of a %. i.e. 500 = 0.5%
683         uint maxDebt; // 9 decimal debt ratio, max % total supply created as debt
684     }
685 
686     // Info for bond holder
687     struct Bond {
688         uint payout; // OHM remaining to be paid
689         uint vesting; // Blocks left to vest
690         uint lastBlock; // Last interaction
691         uint pricePaid; // In DAI, for front end viewing
692     }
693 
694     // Info for incremental adjustments to control variable 
695     struct Adjust {
696         bool add; // addition or subtraction
697         uint rate; // increment
698         uint target; // BCV when adjustment finished
699         uint buffer; // minimum length (in blocks) between adjustments
700         uint lastBlock; // block when last adjustment made
701     }
702 
703 
704 
705 
706     /* ======== INITIALIZATION ======== */
707 
708     constructor ( 
709         address _OHM,
710         address _principle,
711         address _treasury, 
712         address _DAO,
713         address _feed
714     ) {
715         require( _OHM != address(0) );
716         OHM = _OHM;
717         require( _principle != address(0) );
718         principle = _principle;
719         require( _treasury != address(0) );
720         treasury = _treasury;
721         require( _DAO != address(0) );
722         DAO = _DAO;
723         require( _feed != address(0) );
724         priceFeed = AggregatorV3Interface( _feed );
725     }
726 
727     /**
728      *  @notice initializes bond parameters
729      *  @param _controlVariable uint
730      *  @param _vestingTerm uint
731      *  @param _minimumPrice uint
732      *  @param _maxPayout uint
733      *  @param _maxDebt uint
734      *  @param _initialDebt uint
735      */
736     function initializeBondTerms( 
737         uint _controlVariable, 
738         uint _vestingTerm,
739         uint _minimumPrice,
740         uint _maxPayout,
741         uint _maxDebt,
742         uint _initialDebt
743     ) external onlyPolicy() {
744         require( currentDebt() == 0, "Debt must be 0 for initialization" );
745         terms = Terms ({
746             controlVariable: _controlVariable,
747             vestingTerm: _vestingTerm,
748             minimumPrice: _minimumPrice,
749             maxPayout: _maxPayout,
750             maxDebt: _maxDebt
751         });
752         totalDebt = _initialDebt;
753         lastDecay = block.number;
754     }
755 
756 
757 
758     
759     /* ======== POLICY FUNCTIONS ======== */
760 
761     enum PARAMETER { VESTING, PAYOUT, DEBT }
762     /**
763      *  @notice set parameters for new bonds
764      *  @param _parameter PARAMETER
765      *  @param _input uint
766      */
767     function setBondTerms ( PARAMETER _parameter, uint _input ) external onlyPolicy() {
768         if ( _parameter == PARAMETER.VESTING ) { // 0
769             require( _input >= 10000, "Vesting must be longer than 36 hours" );
770             terms.vestingTerm = _input;
771         } else if ( _parameter == PARAMETER.PAYOUT ) { // 1
772             require( _input <= 1000, "Payout cannot be above 1 percent" );
773             terms.maxPayout = _input;
774         } else if ( _parameter == PARAMETER.DEBT ) { // 3
775             terms.maxDebt = _input;
776         }
777     }
778 
779     /**
780      *  @notice set control variable adjustment
781      *  @param _addition bool
782      *  @param _increment uint
783      *  @param _target uint
784      *  @param _buffer uint
785      */
786     function setAdjustment ( 
787         bool _addition,
788         uint _increment, 
789         uint _target,
790         uint _buffer 
791     ) external onlyPolicy() {
792         require( _increment <= terms.controlVariable.mul( 25 ).div( 1000 ), "Increment too large" );
793 
794         adjustment = Adjust({
795             add: _addition,
796             rate: _increment,
797             target: _target,
798             buffer: _buffer,
799             lastBlock: block.number
800         });
801     }
802 
803     /**
804      *  @notice set contract for auto stake
805      *  @param _staking address
806      *  @param _helper bool
807      */
808     function setStaking( address _staking, bool _helper ) external onlyPolicy() {
809         require( _staking != address(0) );
810         if ( _helper ) {
811             useHelper = true;
812             stakingHelper = _staking;
813         } else {
814             useHelper = false;
815             staking = _staking;
816         }
817     }
818 
819 
820     
821 
822     /* ======== USER FUNCTIONS ======== */
823 
824     /**
825      *  @notice deposit bond
826      *  @param _amount uint
827      *  @param _maxPrice uint
828      *  @param _depositor address
829      *  @return uint
830      */
831     function deposit( 
832         uint _amount, 
833         uint _maxPrice,
834         address _depositor
835     ) external returns ( uint ) {
836         require( _depositor != address(0), "Invalid address" );
837 
838         decayDebt();
839         require( totalDebt <= terms.maxDebt, "Max capacity reached" );
840         
841         uint priceInUSD = bondPriceInUSD(); // Stored in bond info
842         uint nativePrice = _bondPrice();
843 
844         require( _maxPrice >= nativePrice, "Slippage limit: more than max price" ); // slippage protection
845 
846         uint value = ITreasury( treasury ).valueOf( principle, _amount );
847         uint payout = payoutFor( value ); // payout to bonder is computed
848 
849         require( payout >= 10000000, "Bond too small" ); // must be > 0.01 OHM ( underflow protection )
850         require( payout <= maxPayout(), "Bond too large"); // size protection because there is no slippage
851 
852         /**
853             asset carries risk and is not minted against
854             asset transfered to treasury and rewards minted as payout
855          */
856         IERC20( principle ).safeTransferFrom( msg.sender, treasury, _amount );
857         ITreasury( treasury ).mintRewards( address(this), payout );
858         
859         // total debt is increased
860         totalDebt = totalDebt.add( value ); 
861                 
862         // depositor info is stored
863         bondInfo[ _depositor ] = Bond({ 
864             payout: bondInfo[ _depositor ].payout.add( payout ),
865             vesting: terms.vestingTerm,
866             lastBlock: block.number,
867             pricePaid: priceInUSD
868         });
869 
870         // indexed events are emitted
871         emit BondCreated( _amount, payout, block.number.add( terms.vestingTerm ), priceInUSD );
872         emit BondPriceChanged( bondPriceInUSD(), _bondPrice(), debtRatio() );
873 
874         adjust(); // control variable is adjusted
875         return payout; 
876     }
877 
878     /** 
879      *  @notice redeem bond for user
880      *  @param _recipient address
881      *  @param _stake bool
882      *  @return uint
883      */ 
884     function redeem( address _recipient, bool _stake ) external returns ( uint ) {        
885         Bond memory info = bondInfo[ _recipient ];
886         uint percentVested = percentVestedFor( _recipient ); // (blocks since last interaction / vesting term remaining)
887 
888         if ( percentVested >= 10000 ) { // if fully vested
889             delete bondInfo[ _recipient ]; // delete user info
890             emit BondRedeemed( _recipient, info.payout, 0 ); // emit bond data
891             return stakeOrSend( _recipient, _stake, info.payout ); // pay user everything due
892 
893         } else { // if unfinished
894             // calculate payout vested
895             uint payout = info.payout.mul( percentVested ).div( 10000 );
896 
897             // store updated deposit info
898             bondInfo[ _recipient ] = Bond({
899                 payout: info.payout.sub( payout ),
900                 vesting: info.vesting.sub( block.number.sub( info.lastBlock ) ),
901                 lastBlock: block.number,
902                 pricePaid: info.pricePaid
903             });
904 
905             emit BondRedeemed( _recipient, payout, bondInfo[ _recipient ].payout );
906             return stakeOrSend( _recipient, _stake, payout );
907         }
908     }
909 
910 
911 
912     
913     /* ======== INTERNAL HELPER FUNCTIONS ======== */
914 
915     /**
916      *  @notice allow user to stake payout automatically
917      *  @param _stake bool
918      *  @param _amount uint
919      *  @return uint
920      */
921     function stakeOrSend( address _recipient, bool _stake, uint _amount ) internal returns ( uint ) {
922         if ( !_stake ) { // if user does not want to stake
923             IERC20( OHM ).transfer( _recipient, _amount ); // send payout
924         } else { // if user wants to stake
925             if ( useHelper ) { // use if staking warmup is 0
926                 IERC20( OHM ).approve( stakingHelper, _amount );
927                 IStakingHelper( stakingHelper ).stake( _amount, _recipient );
928             } else {
929                 IERC20( OHM ).approve( staking, _amount );
930                 IStaking( staking ).stake( _amount, _recipient );
931             }
932         }
933         return _amount;
934     }
935 
936     /**
937      *  @notice makes incremental adjustment to control variable
938      */
939     function adjust() internal {
940         uint blockCanAdjust = adjustment.lastBlock.add( adjustment.buffer );
941         if( adjustment.rate != 0 && block.number >= blockCanAdjust ) {
942             uint initial = terms.controlVariable;
943             if ( adjustment.add ) {
944                 terms.controlVariable = terms.controlVariable.add( adjustment.rate );
945                 if ( terms.controlVariable >= adjustment.target ) {
946                     adjustment.rate = 0;
947                 }
948             } else {
949                 terms.controlVariable = terms.controlVariable.sub( adjustment.rate );
950                 if ( terms.controlVariable <= adjustment.target ) {
951                     adjustment.rate = 0;
952                 }
953             }
954             adjustment.lastBlock = block.number;
955             emit ControlVariableAdjustment( initial, terms.controlVariable, adjustment.rate, adjustment.add );
956         }
957     }
958 
959     /**
960      *  @notice reduce total debt
961      */
962     function decayDebt() internal {
963         totalDebt = totalDebt.sub( debtDecay() );
964         lastDecay = block.number;
965     }
966 
967 
968 
969 
970     /* ======== VIEW FUNCTIONS ======== */
971 
972     /**
973      *  @notice determine maximum bond size
974      *  @return uint
975      */
976     function maxPayout() public view returns ( uint ) {
977         return IERC20( OHM ).totalSupply().mul( terms.maxPayout ).div( 100000 );
978     }
979 
980     /**
981      *  @notice calculate interest due for new bond
982      *  @param _value uint
983      *  @return uint
984      */
985     function payoutFor( uint _value ) public view returns ( uint ) {
986         return FixedPoint.fraction( _value, bondPrice() ).decode112with18().div( 1e14 );
987     }
988 
989 
990     /**
991      *  @notice calculate current bond premium
992      *  @return price_ uint
993      */
994     function bondPrice() public view returns ( uint price_ ) {        
995         price_ = terms.controlVariable.mul( debtRatio() ).div( 1e5 );
996         if ( price_ < terms.minimumPrice ) {
997             price_ = terms.minimumPrice;
998         }
999     }
1000 
1001     /**
1002      *  @notice calculate current bond price and remove floor if above
1003      *  @return price_ uint
1004      */
1005     function _bondPrice() internal returns ( uint price_ ) {
1006         price_ = terms.controlVariable.mul( debtRatio() ).div( 1e5 );
1007         if ( price_ < terms.minimumPrice ) {
1008             price_ = terms.minimumPrice;        
1009         } else if ( terms.minimumPrice != 0 ) {
1010             terms.minimumPrice = 0;
1011         }
1012     }
1013 
1014     /**
1015      *  @notice get asset price from chainlink
1016      */
1017     function assetPrice() public view returns (int) {
1018         ( , int price, , , ) = priceFeed.latestRoundData();
1019         return price;
1020     }
1021 
1022     /**
1023      *  @notice converts bond price to DAI value
1024      *  @return price_ uint
1025      */
1026     function bondPriceInUSD() public view returns ( uint price_ ) {
1027         price_ = bondPrice().mul( uint( assetPrice() ) ).mul( 1e6 );
1028     }
1029 
1030 
1031     /**
1032      *  @notice calculate current ratio of debt to OHM supply
1033      *  @return debtRatio_ uint
1034      */
1035     function debtRatio() public view returns ( uint debtRatio_ ) {   
1036         uint supply = IERC20( OHM ).totalSupply();
1037         debtRatio_ = FixedPoint.fraction( 
1038             currentDebt().mul( 1e9 ), 
1039             supply
1040         ).decode112with18().div( 1e18 );
1041     }
1042 
1043     /**
1044      *  @notice debt ratio in same terms as reserve bonds
1045      *  @return uint
1046      */
1047     function standardizedDebtRatio() external view returns ( uint ) {
1048         return debtRatio().mul( uint( assetPrice() ) ).div( 1e8 ); // ETH feed is 8 decimals
1049     }
1050 
1051     /**
1052      *  @notice calculate debt factoring in decay
1053      *  @return uint
1054      */
1055     function currentDebt() public view returns ( uint ) {
1056         return totalDebt.sub( debtDecay() );
1057     }
1058 
1059     /**
1060      *  @notice amount to decay total debt by
1061      *  @return decay_ uint
1062      */
1063     function debtDecay() public view returns ( uint decay_ ) {
1064         uint blocksSinceLast = block.number.sub( lastDecay );
1065         decay_ = totalDebt.mul( blocksSinceLast ).div( terms.vestingTerm );
1066         if ( decay_ > totalDebt ) {
1067             decay_ = totalDebt;
1068         }
1069     }
1070 
1071 
1072     /**
1073      *  @notice calculate how far into vesting a depositor is
1074      *  @param _depositor address
1075      *  @return percentVested_ uint
1076      */
1077     function percentVestedFor( address _depositor ) public view returns ( uint percentVested_ ) {
1078         Bond memory bond = bondInfo[ _depositor ];
1079         uint blocksSinceLast = block.number.sub( bond.lastBlock );
1080         uint vesting = bond.vesting;
1081 
1082         if ( vesting > 0 ) {
1083             percentVested_ = blocksSinceLast.mul( 10000 ).div( vesting );
1084         } else {
1085             percentVested_ = 0;
1086         }
1087     }
1088 
1089     /**
1090      *  @notice calculate amount of OHM available for claim by depositor
1091      *  @param _depositor address
1092      *  @return pendingPayout_ uint
1093      */
1094     function pendingPayoutFor( address _depositor ) external view returns ( uint pendingPayout_ ) {
1095         uint percentVested = percentVestedFor( _depositor );
1096         uint payout = bondInfo[ _depositor ].payout;
1097 
1098         if ( percentVested >= 10000 ) {
1099             pendingPayout_ = payout;
1100         } else {
1101             pendingPayout_ = payout.mul( percentVested ).div( 10000 );
1102         }
1103     }
1104 
1105 
1106 
1107 
1108     /* ======= AUXILLIARY ======= */
1109 
1110     /**
1111      *  @notice allow anyone to send lost tokens (excluding principle or OHM) to the DAO
1112      *  @return bool
1113      */
1114     function recoverLostToken( address _token ) external returns ( bool ) {
1115         require( _token != OHM );
1116         require( _token != principle );
1117         IERC20( _token ).safeTransfer( DAO, IERC20( _token ).balanceOf( address(this) ) );
1118         return true;
1119     }
1120 }