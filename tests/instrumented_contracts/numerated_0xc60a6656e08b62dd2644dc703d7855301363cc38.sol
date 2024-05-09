1 // SPDX-License-Identifier: AGPL-3.0-or-later
2 pragma solidity 0.7.5;
3 
4 
5 library SafeMath {
6 
7     function add(uint256 a, uint256 b) internal pure returns (uint256) {
8         uint256 c = a + b;
9         require(c >= a, "SafeMath: addition overflow");
10 
11         return c;
12     }
13 
14     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
15         return sub(a, b, "SafeMath: subtraction overflow");
16     }
17 
18     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
19         require(b <= a, errorMessage);
20         uint256 c = a - b;
21 
22         return c;
23     }
24 
25     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26         if (a == 0) {
27             return 0;
28         }
29 
30         uint256 c = a * b;
31         require(c / a == b, "SafeMath: multiplication overflow");
32 
33         return c;
34     }
35 
36     function div(uint256 a, uint256 b) internal pure returns (uint256) {
37         return div(a, b, "SafeMath: division by zero");
38     }
39 
40     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
41         require(b > 0, errorMessage);
42         uint256 c = a / b;
43         return c;
44     }
45 
46     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
47         return mod(a, b, "SafeMath: modulo by zero");
48     }
49 
50     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
51         require(b != 0, errorMessage);
52         return a % b;
53     }
54 
55     function sqrrt(uint256 a) internal pure returns (uint c) {
56         if (a > 3) {
57             c = a;
58             uint b = add( div( a, 2), 1 );
59             while (b < c) {
60                 c = b;
61                 b = div( add( div( a, b ), b), 2 );
62             }
63         } else if (a != 0) {
64             c = 1;
65         }
66     }
67 }
68 
69 library Address {
70 
71     function isContract(address account) internal view returns (bool) {
72 
73         uint256 size;
74         // solhint-disable-next-line no-inline-assembly
75         assembly { size := extcodesize(account) }
76         return size > 0;
77     }
78 
79     function sendValue(address payable recipient, uint256 amount) internal {
80         require(address(this).balance >= amount, "Address: insufficient balance");
81 
82         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
83         (bool success, ) = recipient.call{ value: amount }("");
84         require(success, "Address: unable to send value, recipient may have reverted");
85     }
86 
87     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
88       return functionCall(target, data, "Address: low-level call failed");
89     }
90 
91     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
92         return _functionCallWithValue(target, data, 0, errorMessage);
93     }
94 
95     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
96         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
97     }
98 
99     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
100         require(address(this).balance >= value, "Address: insufficient balance for call");
101         require(isContract(target), "Address: call to non-contract");
102 
103         // solhint-disable-next-line avoid-low-level-calls
104         (bool success, bytes memory returndata) = target.call{ value: value }(data);
105         return _verifyCallResult(success, returndata, errorMessage);
106     }
107 
108     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
109         require(isContract(target), "Address: call to non-contract");
110 
111         // solhint-disable-next-line avoid-low-level-calls
112         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
113         if (success) {
114             return returndata;
115         } else {
116             // Look for revert reason and bubble it up if present
117             if (returndata.length > 0) {
118                 // The easiest way to bubble the revert reason is using memory via assembly
119 
120                 // solhint-disable-next-line no-inline-assembly
121                 assembly {
122                     let returndata_size := mload(returndata)
123                     revert(add(32, returndata), returndata_size)
124                 }
125             } else {
126                 revert(errorMessage);
127             }
128         }
129     }
130 
131     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
132         return functionStaticCall(target, data, "Address: low-level static call failed");
133     }
134 
135     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
136         require(isContract(target), "Address: static call to non-contract");
137 
138         // solhint-disable-next-line avoid-low-level-calls
139         (bool success, bytes memory returndata) = target.staticcall(data);
140         return _verifyCallResult(success, returndata, errorMessage);
141     }
142 
143     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
144         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
145     }
146 
147     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
148         require(isContract(target), "Address: delegate call to non-contract");
149 
150         // solhint-disable-next-line avoid-low-level-calls
151         (bool success, bytes memory returndata) = target.delegatecall(data);
152         return _verifyCallResult(success, returndata, errorMessage);
153     }
154 
155     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
156         if (success) {
157             return returndata;
158         } else {
159             if (returndata.length > 0) {
160 
161                 assembly {
162                     let returndata_size := mload(returndata)
163                     revert(add(32, returndata), returndata_size)
164                 }
165             } else {
166                 revert(errorMessage);
167             }
168         }
169     }
170 
171     function addressToString(address _address) internal pure returns(string memory) {
172         bytes32 _bytes = bytes32(uint256(_address));
173         bytes memory HEX = "0123456789abcdef";
174         bytes memory _addr = new bytes(42);
175 
176         _addr[0] = '0';
177         _addr[1] = 'x';
178 
179         for(uint256 i = 0; i < 20; i++) {
180             _addr[2+i*2] = HEX[uint8(_bytes[i + 12] >> 4)];
181             _addr[3+i*2] = HEX[uint8(_bytes[i + 12] & 0x0f)];
182         }
183 
184         return string(_addr);
185 
186     }
187 }
188 
189 interface IERC20 {
190     function decimals() external view returns (uint8);
191 
192     function totalSupply() external view returns (uint256);
193 
194     function balanceOf(address account) external view returns (uint256);
195 
196     function transfer(address recipient, uint256 amount) external returns (bool);
197 
198     function allowance(address owner, address spender) external view returns (uint256);
199 
200     function approve(address spender, uint256 amount) external returns (bool);
201 
202     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
203 
204     event Transfer(address indexed from, address indexed to, uint256 value);
205 
206     event Approval(address indexed owner, address indexed spender, uint256 value);
207 }
208 
209 abstract contract ERC20 is IERC20 {
210 
211     using SafeMath for uint256;
212 
213     // TODO comment actual hash value.
214     bytes32 constant private ERC20TOKEN_ERC1820_INTERFACE_ID = keccak256( "ERC20Token" );
215     
216     mapping (address => uint256) internal _balances;
217 
218     mapping (address => mapping (address => uint256)) internal _allowances;
219 
220     uint256 internal _totalSupply;
221 
222     string internal _name;
223     
224     string internal _symbol;
225     
226     uint8 internal _decimals;
227 
228     constructor (string memory name_, string memory symbol_, uint8 decimals_) {
229         _name = name_;
230         _symbol = symbol_;
231         _decimals = decimals_;
232     }
233 
234     function name() public view returns (string memory) {
235         return _name;
236     }
237 
238     function symbol() public view returns (string memory) {
239         return _symbol;
240     }
241 
242     function decimals() public view override returns (uint8) {
243         return _decimals;
244     }
245 
246     function totalSupply() public view override returns (uint256) {
247         return _totalSupply;
248     }
249 
250     function balanceOf(address account) public view virtual override returns (uint256) {
251         return _balances[account];
252     }
253 
254     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
255         _transfer(msg.sender, recipient, amount);
256         return true;
257     }
258 
259     function allowance(address owner, address spender) public view virtual override returns (uint256) {
260         return _allowances[owner][spender];
261     }
262 
263     function approve(address spender, uint256 amount) public virtual override returns (bool) {
264         _approve(msg.sender, spender, amount);
265         return true;
266     }
267 
268     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
269         _transfer(sender, recipient, amount);
270         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
271         return true;
272     }
273 
274     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
275         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
276         return true;
277     }
278 
279     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
280         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
281         return true;
282     }
283 
284     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
285         require(sender != address(0), "ERC20: transfer from the zero address");
286         require(recipient != address(0), "ERC20: transfer to the zero address");
287 
288         _beforeTokenTransfer(sender, recipient, amount);
289 
290         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
291         _balances[recipient] = _balances[recipient].add(amount);
292         emit Transfer(sender, recipient, amount);
293     }
294 
295     function _mint(address account_, uint256 ammount_) internal virtual {
296         require(account_ != address(0), "ERC20: mint to the zero address");
297         _beforeTokenTransfer(address( this ), account_, ammount_);
298         _totalSupply = _totalSupply.add(ammount_);
299         _balances[account_] = _balances[account_].add(ammount_);
300         emit Transfer(address( this ), account_, ammount_);
301     }
302 
303     function _burn(address account, uint256 amount) internal virtual {
304         require(account != address(0), "ERC20: burn from the zero address");
305 
306         _beforeTokenTransfer(account, address(0), amount);
307 
308         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
309         _totalSupply = _totalSupply.sub(amount);
310         emit Transfer(account, address(0), amount);
311     }
312 
313     function _approve(address owner, address spender, uint256 amount) internal virtual {
314         require(owner != address(0), "ERC20: approve from the zero address");
315         require(spender != address(0), "ERC20: approve to the zero address");
316 
317         _allowances[owner][spender] = amount;
318         emit Approval(owner, spender, amount);
319     }
320 
321   function _beforeTokenTransfer( address from_, address to_, uint256 amount_ ) internal virtual { }
322 }
323 
324 interface IERC2612Permit {
325 
326     function permit(
327         address owner,
328         address spender,
329         uint256 amount,
330         uint256 deadline,
331         uint8 v,
332         bytes32 r,
333         bytes32 s
334     ) external;
335 
336     function nonces(address owner) external view returns (uint256);
337 }
338 
339 library Counters {
340     using SafeMath for uint256;
341 
342     struct Counter {
343 
344         uint256 _value; // default: 0
345     }
346 
347     function current(Counter storage counter) internal view returns (uint256) {
348         return counter._value;
349     }
350 
351     function increment(Counter storage counter) internal {
352         counter._value += 1;
353     }
354 
355     function decrement(Counter storage counter) internal {
356         counter._value = counter._value.sub(1);
357     }
358 }
359 
360 abstract contract ERC20Permit is ERC20, IERC2612Permit {
361     using Counters for Counters.Counter;
362 
363     mapping(address => Counters.Counter) private _nonces;
364 
365     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
366     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
367 
368     bytes32 public DOMAIN_SEPARATOR;
369 
370     constructor() {
371         uint256 chainID;
372         assembly {
373             chainID := chainid()
374         }
375 
376         DOMAIN_SEPARATOR = keccak256(
377             abi.encode(
378                 keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
379                 keccak256(bytes(name())),
380                 keccak256(bytes("1")), // Version
381                 chainID,
382                 address(this)
383             )
384         );
385     }
386 
387     function permit(
388         address owner,
389         address spender,
390         uint256 amount,
391         uint256 deadline,
392         uint8 v,
393         bytes32 r,
394         bytes32 s
395     ) public virtual override {
396         require(block.timestamp <= deadline, "Permit: expired deadline");
397 
398         bytes32 hashStruct =
399             keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, amount, _nonces[owner].current(), deadline));
400 
401         bytes32 _hash = keccak256(abi.encodePacked(uint16(0x1901), DOMAIN_SEPARATOR, hashStruct));
402 
403         address signer = ecrecover(_hash, v, r, s);
404         require(signer != address(0) && signer == owner, "ZeroSwapPermit: Invalid signature");
405 
406         _nonces[owner].increment();
407         _approve(owner, spender, amount);
408     }
409 
410     function nonces(address owner) public view override returns (uint256) {
411         return _nonces[owner].current();
412     }
413 }
414 
415 library SafeERC20 {
416     using SafeMath for uint256;
417     using Address for address;
418 
419     function safeTransfer(IERC20 token, address to, uint256 value) internal {
420         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
421     }
422 
423     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
424         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
425     }
426 
427     function safeApprove(IERC20 token, address spender, uint256 value) internal {
428 
429         require((value == 0) || (token.allowance(address(this), spender) == 0),
430             "SafeERC20: approve from non-zero to non-zero allowance"
431         );
432         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
433     }
434 
435     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
436         uint256 newAllowance = token.allowance(address(this), spender).add(value);
437         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
438     }
439 
440     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
441         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
442         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
443     }
444 
445     function _callOptionalReturn(IERC20 token, bytes memory data) private {
446 
447         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
448         if (returndata.length > 0) { // Return data is optional
449             // solhint-disable-next-line max-line-length
450             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
451         }
452     }
453 }
454 
455 library FullMath {
456     function fullMul(uint256 x, uint256 y) private pure returns (uint256 l, uint256 h) {
457         uint256 mm = mulmod(x, y, uint256(-1));
458         l = x * y;
459         h = mm - l;
460         if (mm < l) h -= 1;
461     }
462 
463     function fullDiv(
464         uint256 l,
465         uint256 h,
466         uint256 d
467     ) private pure returns (uint256) {
468         uint256 pow2 = d & -d;
469         d /= pow2;
470         l /= pow2;
471         l += h * ((-pow2) / pow2 + 1);
472         uint256 r = 1;
473         r *= 2 - d * r;
474         r *= 2 - d * r;
475         r *= 2 - d * r;
476         r *= 2 - d * r;
477         r *= 2 - d * r;
478         r *= 2 - d * r;
479         r *= 2 - d * r;
480         r *= 2 - d * r;
481         return l * r;
482     }
483 
484     function mulDiv(
485         uint256 x,
486         uint256 y,
487         uint256 d
488     ) internal pure returns (uint256) {
489         (uint256 l, uint256 h) = fullMul(x, y);
490         uint256 mm = mulmod(x, y, d);
491         if (mm > l) h -= 1;
492         l -= mm;
493         require(h < d, 'FullMath::mulDiv: overflow');
494         return fullDiv(l, h, d);
495     }
496 }
497 
498 library FixedPoint {
499 
500     struct uq112x112 {
501         uint224 _x;
502     }
503 
504     struct uq144x112 {
505         uint256 _x;
506     }
507 
508     uint8 private constant RESOLUTION = 112;
509     uint256 private constant Q112 = 0x10000000000000000000000000000;
510     uint256 private constant Q224 = 0x100000000000000000000000000000000000000000000000000000000;
511     uint256 private constant LOWER_MASK = 0xffffffffffffffffffffffffffff; // decimal of UQ*x112 (lower 112 bits)
512 
513     function decode(uq112x112 memory self) internal pure returns (uint112) {
514         return uint112(self._x >> RESOLUTION);
515     }
516 
517     function decode112with18(uq112x112 memory self) internal pure returns (uint) {
518 
519         return uint(self._x) / 5192296858534827;
520     }
521 
522     function fraction(uint256 numerator, uint256 denominator) internal pure returns (uq112x112 memory) {
523         require(denominator > 0, 'FixedPoint::fraction: division by zero');
524         if (numerator == 0) return FixedPoint.uq112x112(0);
525 
526         if (numerator <= uint144(-1)) {
527             uint256 result = (numerator << RESOLUTION) / denominator;
528             require(result <= uint224(-1), 'FixedPoint::fraction: overflow');
529             return uq112x112(uint224(result));
530         } else {
531             uint256 result = FullMath.mulDiv(numerator, Q112, denominator);
532             require(result <= uint224(-1), 'FixedPoint::fraction: overflow');
533             return uq112x112(uint224(result));
534         }
535     }
536 }
537 
538 interface ITreasury {
539     function deposit( uint _amount, address _token, uint _profit ) external returns ( bool );
540     function tokenValue( address _token, uint _amount ) external view returns ( uint value_ );
541 }
542 
543 interface IBondCalculator {
544     function valuation( address _LP, uint _amount ) external view returns ( uint );
545     function markdown( address _LP ) external view returns ( uint );
546 }
547 
548 interface IStaking {
549     function stake(
550         address _to,
551         uint256 _amount,
552         bool _rebasing,
553         bool _claim
554     ) external returns (uint256);
555 }
556 
557 interface IOlympusAuthority {
558     /* ========== EVENTS ========== */
559     
560     event GovernorPushed(address indexed from, address indexed to, bool _effectiveImmediately);
561     event GuardianPushed(address indexed from, address indexed to, bool _effectiveImmediately);    
562     event PolicyPushed(address indexed from, address indexed to, bool _effectiveImmediately);    
563     event VaultPushed(address indexed from, address indexed to, bool _effectiveImmediately);    
564 
565     event GovernorPulled(address indexed from, address indexed to);
566     event GuardianPulled(address indexed from, address indexed to);
567     event PolicyPulled(address indexed from, address indexed to);
568     event VaultPulled(address indexed from, address indexed to);
569 
570     /* ========== VIEW ========== */
571     
572     function governor() external view returns (address);
573     function guardian() external view returns (address);
574     function policy() external view returns (address);
575     function vault() external view returns (address);
576 }
577 
578 abstract contract OlympusAccessControlled {
579 
580     /* ========== EVENTS ========== */
581 
582     event AuthorityUpdated(IOlympusAuthority indexed authority);
583 
584     string UNAUTHORIZED = "UNAUTHORIZED"; // save gas
585 
586     /* ========== STATE VARIABLES ========== */
587 
588     IOlympusAuthority public authority;
589 
590 
591     /* ========== Constructor ========== */
592 
593     constructor(IOlympusAuthority _authority) {
594         authority = _authority;
595         emit AuthorityUpdated(_authority);
596     }
597     
598 
599     /* ========== MODIFIERS ========== */
600     
601     modifier onlyGovernor() {
602         require(msg.sender == authority.governor(), UNAUTHORIZED);
603         _;
604     }
605     
606     modifier onlyGuardian() {
607         require(msg.sender == authority.guardian(), UNAUTHORIZED);
608         _;
609     }
610     
611     modifier onlyPolicy() {
612         require(msg.sender == authority.policy(), UNAUTHORIZED);
613         _;
614     }
615 
616     modifier onlyVault() {
617         require(msg.sender == authority.vault(), UNAUTHORIZED);
618         _;
619     }
620     
621     /* ========== GOV ONLY ========== */
622     
623     function setAuthority(IOlympusAuthority _newAuthority) external onlyGovernor {
624         authority = _newAuthority;
625         emit AuthorityUpdated(_newAuthority);
626     }
627 }
628 
629 contract OlympusV1BondDepository is OlympusAccessControlled {
630 
631     using FixedPoint for *;
632     using SafeERC20 for IERC20;
633     using SafeMath for uint;
634 
635 
636 
637 
638     /* ======== EVENTS ======== */
639 
640     event BondCreated( uint deposit, uint indexed payout, uint indexed expires, uint indexed priceInUSD );
641     event BondRedeemed( address indexed recipient, uint payout, uint remaining );
642     event BondPriceChanged( uint indexed priceInUSD, uint indexed internalPrice, uint indexed debtRatio );
643     event ControlVariableAdjustment( uint initialBCV, uint newBCV, uint adjustment, bool addition );
644 
645 
646 
647 
648     /* ======== STATE VARIABLES ======== */
649 
650     IERC20 public immutable OHM; // token given as payment for bond
651     address public immutable principle; // token used to create bond
652     ITreasury public immutable treasury; // mints OHM when receives principle
653     address public immutable DAO; // receives profit share from bond
654     IStaking public immutable staking; // to stake payout
655 
656     bool public immutable isLiquidityBond; // LP and Reserve bonds are treated slightly different
657     address public immutable bondCalculator; // calculates value of LP tokens
658 
659     Terms public terms; // stores terms for new bonds
660     Adjust public adjustment; // stores adjustment to BCV data
661 
662     mapping( address => Bond ) public bondInfo; // stores bond information for depositors
663 
664     uint public totalDebt; // total value of outstanding bonds; used for pricing
665     uint public lastDecay; // reference block for debt decay
666 
667 
668 
669 
670     /* ======== STRUCTS ======== */
671 
672     // Info for creating new bonds
673     struct Terms {
674         uint controlVariable; // scaling variable for price
675         uint vestingTerm; // in blocks
676         uint minimumPrice; // vs principle value
677         uint maxPayout; // in thousandths of a %. i.e. 500 = 0.5%
678         uint fee; // as % of bond payout, in hundreths. ( 500 = 5% = 0.05 for every 1 paid)
679         uint maxDebt; // 9 decimal debt ratio, max % total supply created as debt
680     }
681 
682     // Info for bond holder
683     struct Bond {
684         uint payout; // OHM remaining to be paid
685         uint vesting; // Blocks left to vest
686         uint lastBlock; // Last interaction
687         uint pricePaid; // In DAI, for front end viewing
688     }
689 
690     // Info for incremental adjustments to control variable 
691     struct Adjust {
692         bool add; // addition or subtraction
693         uint rate; // increment
694         uint target; // BCV when adjustment finished
695         uint buffer; // minimum length (in blocks) between adjustments
696         uint lastBlock; // block when last adjustment made
697     }
698 
699 
700 
701 
702     /* ======== INITIALIZATION ======== */
703 
704     constructor ( 
705         address _OHM,
706         address _principle,
707         address _treasury, 
708         address _DAO, 
709         address _bondCalculator,
710         address _staking,
711         address _authority
712     ) OlympusAccessControlled(IOlympusAuthority(_authority)) {
713         require( _OHM != address(0) );
714         OHM = IERC20(_OHM);
715         require( _principle != address(0) );
716         principle = _principle;
717         require( _treasury != address(0) );
718         treasury = ITreasury(_treasury);
719         require( _DAO != address(0) );
720         DAO = _DAO;
721         require(_staking != address(0));
722         staking = IStaking(_staking);
723         // bondCalculator should be address(0) if not LP bond
724         bondCalculator = _bondCalculator;
725         isLiquidityBond = ( _bondCalculator != address(0) );
726     }
727 
728     /**
729      *  @notice initializes bond parameters
730      *  @param _controlVariable uint
731      *  @param _vestingTerm uint
732      *  @param _minimumPrice uint
733      *  @param _maxPayout uint
734      *  @param _fee uint
735      *  @param _maxDebt uint
736      *  @param _initialDebt uint
737      */
738     function initializeBondTerms( 
739         uint _controlVariable, 
740         uint _vestingTerm,
741         uint _minimumPrice,
742         uint _maxPayout,
743         uint _fee,
744         uint _maxDebt,
745         uint _initialDebt
746     ) external onlyPolicy() {
747         require( terms.controlVariable == 0, "Bonds must be initialized from 0" );
748         terms = Terms ({
749             controlVariable: _controlVariable,
750             vestingTerm: _vestingTerm,
751             minimumPrice: _minimumPrice,
752             maxPayout: _maxPayout,
753             fee: _fee,
754             maxDebt: _maxDebt
755         });
756         totalDebt = _initialDebt;
757         lastDecay = block.number;
758     }
759 
760 
761 
762     
763     /* ======== POLICY FUNCTIONS ======== */
764 
765     enum PARAMETER { VESTING, PAYOUT, FEE, DEBT }
766     /**
767      *  @notice set parameters for new bonds
768      *  @param _parameter PARAMETER
769      *  @param _input uint
770      */
771     function setBondTerms ( PARAMETER _parameter, uint _input ) external onlyPolicy() {
772         if ( _parameter == PARAMETER.VESTING ) { // 0
773             require( _input >= 10000, "Vesting must be longer than 36 hours" );
774             terms.vestingTerm = _input;
775         } else if ( _parameter == PARAMETER.PAYOUT ) { // 1
776             require( _input <= 1000, "Payout cannot be above 1 percent" );
777             terms.maxPayout = _input;
778         } else if ( _parameter == PARAMETER.FEE ) { // 2
779             require( _input <= 10000, "DAO fee cannot exceed payout" );
780             terms.fee = _input;
781         } else if ( _parameter == PARAMETER.DEBT ) { // 3
782             terms.maxDebt = _input;
783         }
784     }
785 
786     /**
787      *  @notice set control variable adjustment
788      *  @param _addition bool
789      *  @param _increment uint
790      *  @param _target uint
791      *  @param _buffer uint
792      */
793     function setAdjustment ( 
794         bool _addition,
795         uint _increment, 
796         uint _target,
797         uint _buffer 
798     ) external onlyPolicy() {
799         require( _increment <= terms.controlVariable.mul( 25 ).div( 1000 ), "Increment too large" );
800 
801         adjustment = Adjust({
802             add: _addition,
803             rate: _increment,
804             target: _target,
805             buffer: _buffer,
806             lastBlock: block.number
807         });
808     }
809 
810 
811     
812 
813     /* ======== USER FUNCTIONS ======== */
814 
815     /**
816      *  @notice deposit bond
817      *  @param _amount uint
818      *  @param _maxPrice uint
819      *  @param _depositor address
820      *  @return uint
821      */
822     function deposit( 
823         uint _amount, 
824         uint _maxPrice,
825         address _depositor
826     ) external returns ( uint ) {
827         require( _depositor != address(0), "Invalid address" );
828 
829         decayDebt();
830         require( totalDebt <= terms.maxDebt, "Max capacity reached" );
831         
832         uint priceInUSD = bondPriceInUSD(); // Stored in bond info
833         uint nativePrice = _bondPrice();
834 
835         require( _maxPrice >= nativePrice, "Slippage limit: more than max price" ); // slippage protection
836 
837         uint value = treasury.tokenValue(principle, _amount);
838         uint payout = payoutFor(value); // payout to bonder is computed
839 
840         require( payout >= 10000000, "Bond too small" ); // must be > 0.01 OHM ( underflow protection )
841         require( payout <= maxPayout(), "Bond too large"); // size protection because there is no slippage
842 
843         // profits are calculated
844         uint fee = payout.mul( terms.fee ).div( 10000 );
845         uint profit = value.sub( payout ).sub( fee );
846 
847         /**
848             principle is transferred in
849             approved and
850             deposited into the treasury, returning (_amount - profit) OHM
851          */
852         IERC20(principle).safeTransferFrom( msg.sender, address(this), _amount );
853         IERC20(principle).approve( address(treasury), _amount );
854         treasury.deposit( _amount, principle, profit );
855         
856         if ( fee != 0 ) { // fee is transferred to dao 
857             OHM.safeTransfer( DAO, fee ); 
858         }
859         
860         // total debt is increased
861         totalDebt = totalDebt.add( value ); 
862                 
863         // depositor info is stored
864         bondInfo[ _depositor ] = Bond({ 
865             payout: bondInfo[ _depositor ].payout.add( payout ),
866             vesting: terms.vestingTerm,
867             lastBlock: block.number,
868             pricePaid: priceInUSD
869         });
870 
871         // indexed events are emitted
872         emit BondCreated( _amount, payout, block.number.add( terms.vestingTerm ), priceInUSD );
873         emit BondPriceChanged( bondPriceInUSD(), _bondPrice(), debtRatio() );
874 
875         adjust(); // control variable is adjusted
876         return payout; 
877     }
878 
879     /** 
880      *  @notice redeem bond for user
881      *  @param _recipient address
882      *  @param _stake bool
883      *  @return uint
884      */ 
885     function redeem( address _recipient, bool _stake ) external returns ( uint ) {        
886         Bond memory info = bondInfo[ _recipient ];
887         uint percentVested = percentVestedFor( _recipient ); // (blocks since last interaction / vesting term remaining)
888 
889         if ( percentVested >= 10000 ) { // if fully vested
890             delete bondInfo[ _recipient ]; // delete user info
891             emit BondRedeemed( _recipient, info.payout, 0 ); // emit bond data
892             return stakeOrSend( _recipient, _stake, info.payout ); // pay user everything due
893 
894         } else { // if unfinished
895             // calculate payout vested
896             uint payout = info.payout.mul( percentVested ).div( 10000 );
897 
898             // store updated deposit info
899             bondInfo[ _recipient ] = Bond({
900                 payout: info.payout.sub( payout ),
901                 vesting: info.vesting.sub( block.number.sub( info.lastBlock ) ),
902                 lastBlock: block.number,
903                 pricePaid: info.pricePaid
904             });
905 
906             emit BondRedeemed( _recipient, payout, bondInfo[ _recipient ].payout );
907             return stakeOrSend( _recipient, _stake, payout );
908         }
909     }
910 
911 
912 
913     
914     /* ======== INTERNAL HELPER FUNCTIONS ======== */
915 
916     /**
917      *  @notice allow user to stake payout automatically
918      *  @param _stake bool
919      *  @param _amount uint
920      *  @return uint
921      */
922     function stakeOrSend( address _recipient, bool _stake, uint _amount ) internal returns ( uint ) {
923         if ( !_stake ) { // if user does not want to stake
924             OHM.transfer( _recipient, _amount ); // send payout
925         } else { // if user wants to stake
926             OHM.approve(address(staking), _amount);
927             staking.stake(_recipient, _amount, false, true);
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
973         return OHM.totalSupply().mul( terms.maxPayout ).div( 100000 );
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
1111         require( _token != address(OHM) );
1112         require( _token != principle );
1113         IERC20( _token ).safeTransfer( DAO, IERC20( _token ).balanceOf( address(this) ) );
1114         return true;
1115     }
1116 }