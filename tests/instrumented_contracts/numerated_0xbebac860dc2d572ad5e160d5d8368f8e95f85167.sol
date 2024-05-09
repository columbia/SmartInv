1 /*
2 W A G E
3 An inflationary, decentralized store of value
4 https://wage.money
5 https://wagie.life
6 https://t.me/WageMoney
7 
8 -----------------------------------------------------------------------
9 
10 This is free and unencumbered software released into the public domain.
11 
12 Anyone is free to copy, modify, publish, use, compile, sell, or
13 distribute this software, either in source code form or as a compiled
14 binary, for any purpose, commercial or non-commercial, and by any
15 means.
16 
17 In jurisdictions that recognize copyright laws, the author or authors
18 of this software dedicate any and all copyright interest in the
19 software to the public domain. We make this dedication for the benefit
20 of the public at large and to the detriment of our heirs and
21 successors. We intend this dedication to be an overt act of
22 relinquishment in perpetuity of all present and future rights to this
23 software under copyright law.
24 
25 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
26 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
27 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
28 IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
29 OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
30 ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
31 OTHER DEALINGS IN THE SOFTWARE.
32 
33 For more information, please refer to <http://unlicense.org/>
34 
35 */
36 
37 pragma solidity ^0.6.0;
38 
39 contract Context {
40     constructor () internal { }
41 
42     function _msgSender() internal view virtual returns (address payable) {
43         return msg.sender;
44     }
45 
46     function _msgData() internal view virtual returns (bytes memory) {
47         this;
48         return msg.data;
49     }
50 }
51 
52 pragma solidity ^0.6.0;
53 
54 library SafeMath {
55     function add(uint256 a, uint256 b) internal pure returns (uint256) {
56         uint256 c = a + b;
57         require(c >= a, "SafeMath: addition overflow");
58 
59         return c;
60     }
61 
62     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63         return sub(a, b, "SafeMath: subtraction overflow");
64     }
65 
66     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
67         require(b <= a, errorMessage);
68         uint256 c = a - b;
69 
70         return c;
71     }
72 
73     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
74         if (a == 0) {
75             return 0;
76         }
77 
78         uint256 c = a * b;
79         require(c / a == b, "SafeMath: multiplication overflow");
80 
81         return c;
82     }
83 
84     function div(uint256 a, uint256 b) internal pure returns (uint256) {
85         return div(a, b, "SafeMath: division by zero");
86     }
87 
88     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
89         require(b > 0, errorMessage);
90         uint256 c = a / b;
91 
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
103 }
104 
105 pragma solidity ^0.6.0;
106 
107 contract Ownable is Context {
108     address private _owner;
109 
110     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
111 
112     constructor () internal {
113         address msgSender = _msgSender();
114         _owner = msgSender;
115         emit OwnershipTransferred(address(0), msgSender);
116     }
117 
118     function owner() public view returns (address) {
119         return _owner;
120     }
121 
122     modifier onlyOwner() {
123         require(_owner == _msgSender(), "Ownable: caller is not the owner");
124         _;
125     }
126 
127     function renounceOwnership() public virtual onlyOwner {
128         emit OwnershipTransferred(_owner, address(0));
129         _owner = address(0);
130     }
131 
132     function transferOwnership(address newOwner) public virtual onlyOwner {
133         require(newOwner != address(0), "Ownable: new owner is the zero address");
134         emit OwnershipTransferred(_owner, newOwner);
135         _owner = newOwner;
136     }
137 }
138 
139 pragma solidity ^0.6.2;
140 
141 library Address {
142     function isContract(address account) internal view returns (bool) {
143         bytes32 codehash;
144         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
145         assembly { codehash := extcodehash(account) }
146         return (codehash != accountHash && codehash != 0x0);
147     }
148 
149     function sendValue(address payable recipient, uint256 amount) internal {
150         require(address(this).balance >= amount, "Address: insufficient balance");
151 
152         (bool success, ) = recipient.call{ value: amount }("");
153         require(success, "Address: unable to send value, recipient may have reverted");
154     }
155 }
156 
157 pragma solidity ^0.6.0;
158 
159 interface IERC20 {
160     function totalSupply() external view returns (uint256);
161     function balanceOf(address account) external view returns (uint256);
162     function transfer(address recipient, uint256 amount) external returns (bool);
163     function allowance(address owner, address spender) external view returns (uint256);
164     function approve(address spender, uint256 amount) external returns (bool);
165     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
166 
167     event Transfer(address indexed from, address indexed to, uint256 value);
168     event Approval(address indexed owner, address indexed spender, uint256 value);
169 }
170 
171 /* "sync() functions as a recovery mechanism in the case that a token asynchronously 
172 deflates the balance of a pair. In this case, trades will receive sub-optimal rates, and if no liquidity provider 
173 is willing to rectify the situation, the pair is stuck. sync() exists to set the reserves of the contract to the current balances, 
174 providing a somewhat graceful recovery from this situation." */
175 
176 interface UniV2PairI {
177     function sync() external; //
178 }
179 
180 pragma solidity ^0.6.0;
181 
182 abstract contract ERC20 is Context, IERC20 {
183     using SafeMath for uint256;
184     using Address for address;
185 
186     string private _name;
187     string private _symbol;
188     uint8 private _decimals;
189 
190     constructor (string memory name, string memory symbol) public {
191         _name = name;
192         _symbol = symbol;
193     }
194 
195     function name() public view returns (string memory) {
196         return _name;
197     }
198 
199     function symbol() public view returns (string memory) {
200         return _symbol;
201     }
202 
203     function decimals() public view returns (uint8) {
204         return _decimals;
205     }
206 
207     function _setupDecimals(uint8 decimals_) internal {
208         _decimals = decimals_;
209     }
210 
211     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
212 
213 
214     // Overriden ERC-20 functions (Ampleforth):
215     /*
216     totalSupply
217     balanceOf
218     transfer
219     allowance
220     approve
221     transferFrom
222     increaseAllowance
223     decreaseAlloance
224     _approve
225     _transfer
226     */
227 
228 }
229 
230 pragma solidity ^0.6.0;
231 
232 interface IERC165 {
233     function supportsInterface(bytes4 interfaceId) external view returns (bool);
234 }
235 
236 pragma solidity ^0.6.2;
237 
238 library ERC165Checker {
239     bytes4 private constant _INTERFACE_ID_INVALID = 0xffffffff;
240 
241     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
242 
243     function supportsERC165(address account) internal view returns (bool) {
244         return _supportsERC165Interface(account, _INTERFACE_ID_ERC165) &&
245             !_supportsERC165Interface(account, _INTERFACE_ID_INVALID);
246     }
247 
248     function supportsInterface(address account, bytes4 interfaceId) internal view returns (bool) {
249         return supportsERC165(account) &&
250             _supportsERC165Interface(account, interfaceId);
251     }
252 
253 
254     function supportsAllInterfaces(address account, bytes4[] memory interfaceIds) internal view returns (bool) {
255         if (!supportsERC165(account)) {
256             return false;
257         }
258 
259         for (uint256 i = 0; i < interfaceIds.length; i++) {
260             if (!_supportsERC165Interface(account, interfaceIds[i])) {
261                 return false;
262             }
263         }
264 
265         return true;
266     }
267 
268 
269     function _supportsERC165Interface(address account, bytes4 interfaceId) private view returns (bool) {
270         (bool success, bool result) = _callERC165SupportsInterface(account, interfaceId);
271 
272         return (success && result);
273     }
274 
275 
276     function _callERC165SupportsInterface(address account, bytes4 interfaceId)
277         private
278         view
279         returns (bool, bool)
280     {
281         bytes memory encodedParams = abi.encodeWithSelector(_INTERFACE_ID_ERC165, interfaceId);
282         (bool success, bytes memory result) = account.staticcall{ gas: 30000 }(encodedParams);
283         if (result.length < 32) return (false, false);
284         return (success, abi.decode(result, (bool)));
285     }
286 }
287 
288 pragma solidity ^0.6.0;
289 
290 contract ERC165 is IERC165 {
291 
292     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
293 
294 
295     mapping(bytes4 => bool) private _supportedInterfaces;
296 
297     constructor () internal {
298         _registerInterface(_INTERFACE_ID_ERC165);
299     }
300 
301 
302     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
303         return _supportedInterfaces[interfaceId];
304     }
305 
306 
307     function _registerInterface(bytes4 interfaceId) internal virtual {
308         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
309         _supportedInterfaces[interfaceId] = true;
310     }
311 }
312 
313 pragma solidity ^0.6.0;
314 
315 contract TokenRecover is Ownable {
316 
317 
318     function recoverERC20(address tokenAddress, uint256 tokenAmount) public onlyOwner {
319         IERC20(tokenAddress).transfer(owner(), tokenAmount);
320     }
321 }
322 
323 pragma solidity ^0.6.0;
324 
325 library EnumerableSet {
326 
327     struct Set {
328         bytes32[] _values;
329 
330         mapping (bytes32 => uint256) _indexes;
331     }
332 
333 
334     function _add(Set storage set, bytes32 value) private returns (bool) {
335         if (!_contains(set, value)) {
336             set._values.push(value);
337             set._indexes[value] = set._values.length;
338             return true;
339         } else {
340             return false;
341         }
342     }
343 
344 
345     function _remove(Set storage set, bytes32 value) private returns (bool) {
346         uint256 valueIndex = set._indexes[value];
347 
348         if (valueIndex != 0) {
349             uint256 toDeleteIndex = valueIndex - 1;
350             uint256 lastIndex = set._values.length - 1;
351 
352             bytes32 lastvalue = set._values[lastIndex];
353 
354             set._values[toDeleteIndex] = lastvalue;
355             set._indexes[lastvalue] = toDeleteIndex + 1;
356             set._values.pop();
357 
358             delete set._indexes[value];
359 
360             return true;
361         } else {
362             return false;
363         }
364     }
365 
366 
367     function _contains(Set storage set, bytes32 value) private view returns (bool) {
368         return set._indexes[value] != 0;
369     }
370 
371 
372     function _length(Set storage set) private view returns (uint256) {
373         return set._values.length;
374     }
375 
376     function _at(Set storage set, uint256 index) private view returns (bytes32) {
377         require(set._values.length > index, "EnumerableSet: index out of bounds");
378         return set._values[index];
379     }
380 
381     struct AddressSet {
382         Set _inner;
383     }
384 
385 
386     function add(AddressSet storage set, address value) internal returns (bool) {
387         return _add(set._inner, bytes32(uint256(value)));
388     }
389 
390 
391     function remove(AddressSet storage set, address value) internal returns (bool) {
392         return _remove(set._inner, bytes32(uint256(value)));
393     }
394 
395 
396     function contains(AddressSet storage set, address value) internal view returns (bool) {
397         return _contains(set._inner, bytes32(uint256(value)));
398     }
399 
400 
401     function length(AddressSet storage set) internal view returns (uint256) {
402         return _length(set._inner);
403     }
404 
405     function at(AddressSet storage set, uint256 index) internal view returns (address) {
406         return address(uint256(_at(set._inner, index)));
407     }
408 
409 
410     struct UintSet {
411         Set _inner;
412     }
413 
414 
415     function add(UintSet storage set, uint256 value) internal returns (bool) {
416         return _add(set._inner, bytes32(value));
417     }
418 
419 
420     function remove(UintSet storage set, uint256 value) internal returns (bool) {
421         return _remove(set._inner, bytes32(value));
422     }
423 
424 
425     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
426         return _contains(set._inner, bytes32(value));
427     }
428 
429 
430     function length(UintSet storage set) internal view returns (uint256) {
431         return _length(set._inner);
432     }
433 
434     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
435         return uint256(_at(set._inner, index));
436     }
437 }
438 
439 pragma solidity ^0.6.0;
440 
441 contract WAGE is ERC20, TokenRecover {
442 
443     /* 
444     Rebase 
445     Mechanism
446     Forked 
447     from
448     Ampleforth
449     Protocol
450     */
451 
452     using SafeMath for uint256;
453 
454     event LogRebase(uint256 epoch, uint256 totalSupply);
455     event LogMonetaryPolicyUpdated(address monetaryPolicy);
456     event ChangeRebase(uint256 indexed amount);
457     event ChangeRebaseRate(uint256 indexed rate);
458     event RebaseState(bool state);
459     address public monetaryPolicy;
460 
461     modifier onlyMonetaryPolicy() {
462         require(msg.sender == monetaryPolicy);
463         _;
464     }
465 
466     modifier validRecipient(address to) {
467         require(to != address(0x0));
468         require(to != address(this));
469         _;
470     }
471 
472     uint256 private constant MAX_UINT256 = ~uint256(0);
473     uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 24 * 10**18; // initial supply: 24
474 
475     // TOTAL_GONS is a multiple of INITIAL_FRAGMENTS_SUPPLY so that _gonsPerFragment is an integer.
476     // Use the highest value that fits in a uint256 for max granularity.
477     uint256 private constant TOTAL_GONS = MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);
478 
479     // MAX_SUPPLY = maximum integer < (sqrt(4*TOTAL_GONS + 1) - 1) / 2
480     uint256 private _totalSupply;
481     uint256 private constant MAX_SUPPLY = ~uint128(0); 
482     uint256 private _gonsPerFragment;
483     mapping(address => uint256) private _gonBalances;
484 
485     
486     // Union Governance / Rebase Settings
487     uint256 public genesis; // beginning of contract
488     uint256 public nextReb; // when's it time for the next rebase?
489     uint256 public rebaseAmount = 1e18; // initial is 1
490     uint256 public rebaseRate = 10800; // initial is every 3 hours
491     bool public rebState; // Is rebase active?
492     uint256 public rebaseCount = 0;
493 
494     modifier rebaseEnabled() {
495           require(rebState == true);
496           _;
497     }
498     // End of Union Governance / Rebase Settings
499 
500 
501     // This is denominated in Fragments, because the gons-fragments conversion might change before
502     // it's fully paid.
503     mapping (address => mapping (address => uint256)) private _allowedFragments;
504 
505     /**
506      * @param monetaryPolicy_ The address of the monetary policy contract to use for authentication.
507      */
508     function setMonetaryPolicy(address monetaryPolicy_)
509         public
510         onlyOwner
511     {
512         monetaryPolicy = monetaryPolicy_;
513         emit LogMonetaryPolicyUpdated(monetaryPolicy_);
514     }
515 
516     /**
517      * @dev Notifies Fragments contract about a new rebase cycle.
518      * @param supplyDelta The number of new fragment tokens to add into circulation via expansion.
519      * @return The total number of fragments after the supply adjustment.
520      */
521     function rebase(uint256 supplyDelta) public rebaseEnabled onlyMonetaryPolicy returns (uint256) {
522       
523         require(supplyDelta >= 0, "rebase amount must be positive");
524         require(now >= nextReb, "not enough time has passed");
525         nextReb = now.add(rebaseRate);  
526 
527 
528         if (supplyDelta == 0) {
529             emit LogRebase(rebaseCount, _totalSupply);
530             return _totalSupply;
531         }
532 
533         _totalSupply = _totalSupply.add(supplyDelta);
534         
535         if (_totalSupply > MAX_SUPPLY) {
536             _totalSupply = MAX_SUPPLY;
537         }
538 
539         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
540 
541         // From this point forward, _gonsPerFragment is taken as the source of truth.
542         // We recalculate a new _totalSupply to be in agreement with the _gonsPerFragmenta
543         // conversion rate.
544         // This means our applied supplyDelta can deviate from the requested supplyDelta,
545         // but this deviation is guaranteed to be < (_totalSupply^2)/(TOTAL_GONS - _totalSupply).
546         //
547         // In the case of _totalSupply <= MAX_UINT128 (our current supply cap), this
548         // deviation is guaranteed to be < 1, so we can omit this step. If the supply cap is
549         // ever increased, it must be re-included.
550         // _totalSupply = TOTAL_GONS.div(_gonsPerFragment)
551         
552         // updates trading pairs sync()
553         for (uint i = 0; i < iterateLength; i++) {
554             // using low level call to prevent reverts on remote error/non-existence
555             uniSyncs[i].sync();
556         }
557 
558 
559         rebaseCount = rebaseCount.add(1); // tracks rebases since genesis
560         emit LogRebase(rebaseCount, _totalSupply);
561         return _totalSupply;
562         
563     }
564 
565     /* 
566     End 
567     Of
568     Fork
569     from
570     Ampleforth
571     Protocol
572     */
573 
574     // indicates if transfer is enabled
575     bool private _transferEnabled = false;
576     mapping(address => bool) public transferWhitelisted;
577     event TransferEnabled();
578 
579     // pair synchronization setup
580     UniV2PairI[5] public uniSyncs;
581     uint8 public iterateLength;
582     address constant uniFactory = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
583 
584     // https://uniswap.org/docs/v2/smart-contract-integration/getting-pair-addresses/
585     function genUniAddr(address left, address right) internal pure returns (UniV2PairI) {
586         address first = left < right ? left : right;
587         address second = left < right ? right : left;
588         address pair = address(uint(keccak256(abi.encodePacked(
589           hex'ff',
590           uniFactory,
591           keccak256(abi.encodePacked(first, second)),
592           hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f'
593         ))));
594         return UniV2PairI(pair);
595     }
596 
597     function setPairAddr(uint8 id, address token1, address token2) public onlyMonetaryPolicy {
598         uniSyncs[id] = genUniAddr(token1, token2);
599     }
600 
601     function setIterateLength(uint8 number) public onlyMonetaryPolicy { // UniV2PairI[x] where x can be null, and null can't be synced.
602         iterateLength = number;
603     }
604 
605 
606     modifier canTransfer(address from) {
607         require(
608             _transferEnabled || transferWhitelisted[msg.sender] == true,
609             "WAGE: transfer is not enabled or sender is not owner!"
610         );
611         _;
612     }
613 
614       constructor(
615             string memory name,
616             string memory symbol,
617             uint8 decimals,
618             uint256 initialSupply,
619             bool transferEnabled
620       )
621             public
622             ERC20(name, symbol)
623       {
624 
625             whitelistTransferer(msg.sender);
626 
627             _gonBalances[msg.sender] = TOTAL_GONS;
628             _gonsPerFragment = TOTAL_GONS.div(initialSupply);
629             _totalSupply = initialSupply;
630             emit Transfer(address(0x0), msg.sender, initialSupply);
631 
632             monetaryPolicy = msg.sender; // Owner initially controls monetary policy
633             genesis = now; // Beginning of project WAGE
634             nextReb = genesis; // Timer begins at genesis
635             rebState = false; // Rebase is off initially
636             
637             _setupDecimals(decimals);
638 
639             if (transferEnabled) {
640                   enableTransfer();
641             }
642       }
643 
644     function transferEnabled() public view returns (bool) {
645         return _transferEnabled;
646     }
647 
648     function enableTransfer() public onlyOwner {
649         _transferEnabled = true;
650 
651         emit TransferEnabled();
652     }
653 
654     function whitelistTransferer(address user) public onlyOwner {
655         transferWhitelisted[user] = true; 
656     }
657 
658 
659     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20) {
660         super._beforeTokenTransfer(from, to, amount);
661     }
662 
663 
664     /* Begin Ampleforth ERC-20 Implementation */
665     
666     function totalSupply() public view override returns (uint256) {
667         return _totalSupply;
668     }
669 
670     function balanceOf(address who) public view override returns (uint256) {
671         return _gonBalances[who].div(_gonsPerFragment);
672     }
673 
674     function transfer(address to, uint value) public override validRecipient(to) canTransfer(msg.sender) returns(bool success) {
675         _transfer(msg.sender, to, value);
676         return true;
677     }
678 
679     function transferFrom(address from, address to, uint value) public override validRecipient(to) canTransfer(from) returns (bool success) {
680         require(value <= _allowedFragments[from][msg.sender], 'Must not send more than allowance');
681         _allowedFragments[from][msg.sender] = _allowedFragments[from][msg.sender].sub(value);
682         _transfer(from, to, value);
683         return true;
684     }
685 
686     function _transfer(address from, address to, uint256 value) internal returns (bool success) {
687          uint256 gonValue = value.mul(_gonsPerFragment);
688         _gonBalances[from] = _gonBalances[from].sub(gonValue);
689         _gonBalances[to] = _gonBalances[to].add(gonValue);
690 
691         /* 
692         Rebase mechanism is built into transfer to automate the function call. Timing will be dependent on transaction volume.
693         Rebase can be altered through governance. The frequency, amount, and state will be made modular through the Union contract.
694         */
695         if (rebState == true) { // checks if rebases are enabled 
696             if (now >= nextReb) { // prevents errors
697                 rebase(rebaseAmount);
698             }
699         }
700 
701         emit Transfer(from, to, value);       
702         return true;
703     }
704 
705     /**
706      * @dev Function to check the amount of tokens that an owner has allowed to a spender.
707      * @param owner_ The address which owns the funds.
708      * @param spender The address which will spend the funds.
709      * @return The number of tokens still available for the spender.
710      */
711     function allowance(address owner_, address spender)
712         public
713         override
714         view
715         returns (uint256)
716     {
717         return _allowedFragments[owner_][spender];
718     }
719 
720     /**
721      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
722      * msg.sender. This method is included for ERC20 compatibility.
723      * increaseAllowance and decreaseAllowance should be used instead.
724      * Changing an allowance with this method brings the risk that someone may transfer both
725      * the old and the new allowance - if they are both greater than zero - if a transfer
726      * transaction is mined before the later approve() call is mined.
727      *
728      * @param spender The address which will spend the funds.
729      * @param value The amount of tokens to be spent.
730      */
731     function approve(address spender, uint256 value)
732         public
733         override
734         returns (bool)
735     {
736         _allowedFragments[msg.sender][spender] = value;
737         emit Approval(msg.sender, spender, value);
738         return true;
739     }
740 
741     /**
742      * @dev Increase the amount of tokens that an owner has allowed to a spender.
743      * This method should be used instead of approve() to avoid the double approval vulnerability
744      * described above.
745      * @param spender The address which will spend the funds.
746      * @param addedValue The amount of tokens to increase the allowance by.
747      */
748     function increaseAllowance(address spender, uint256 addedValue)
749         public
750         returns (bool)
751     {
752         _allowedFragments[msg.sender][spender] =_allowedFragments[msg.sender][spender].add(addedValue);
753         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
754         return true;
755     }
756 
757     /**
758      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
759      *
760      * @param spender The address which will spend the funds.
761      * @param subtractedValue The amount of tokens to decrease the allowance by.
762      */
763     function decreaseAllowance(address spender, uint256 subtractedValue)
764         public
765         returns (bool)
766     {
767         uint256 oldValue = _allowedFragments[msg.sender][spender];
768         if (subtractedValue >= oldValue) {
769             _allowedFragments[msg.sender][spender] = 0;
770         } else {
771             _allowedFragments[msg.sender][spender] = oldValue.sub(subtractedValue);
772         }
773         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
774         return true;
775     }
776 
777     /* Conclude Ampleforth ERC-20 Implementation */
778 
779     /* Begin Union functions */
780     function publicRebase() rebaseEnabled external { // Anyone can call the rebase if it's time to do so
781         rebase(rebaseAmount);
782     }
783 
784     function changeRebase(uint256 amount) public onlyMonetaryPolicy { //alters rebaseAmount
785         require(amount > 0); // To pause, use rebaseState()
786         rebaseAmount = amount;
787         emit ChangeRebase(amount);
788     }
789 
790     function changeRebaseFreq(uint256 rate) public onlyMonetaryPolicy { //alters rebaseFreq 
791         require(rate > 0); // To pause, use rebaseState()
792         rebaseRate = rate;
793         emit ChangeRebaseRate(rate);
794     }
795 
796     function rebaseState(bool state) public onlyMonetaryPolicy {
797         rebState = state;
798         emit RebaseState(state);
799     }
800 
801     function resetTime() public onlyMonetaryPolicy {
802         nextReb = now; // In case of emergency.. (nextReb might be too far away)
803     }
804     /* End Union functions */
805 
806 
807 
808 }