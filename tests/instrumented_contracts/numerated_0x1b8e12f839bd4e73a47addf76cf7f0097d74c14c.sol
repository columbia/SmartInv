1 // File: openzeppelin-eth/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.5.0;
4 
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that revert on error
9  */
10 library SafeMath {
11 
12     /**
13     * @dev Multiplies two numbers, reverts on overflow.
14     */
15     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
17         // benefit is lost if 'b' is also tested.
18         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
19         if (a == 0) {
20             return 0;
21         }
22 
23         uint256 c = a * b;
24         require(c / a == b);
25 
26         return c;
27     }
28 
29     /**
30     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
31     */
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         require(b > 0); // Solidity only automatically asserts when dividing by 0
34         uint256 c = a / b;
35         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36 
37         return c;
38     }
39 
40     /**
41     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
42     */
43     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44         require(b <= a);
45         uint256 c = a - b;
46 
47         return c;
48     }
49 
50     /**
51     * @dev Adds two numbers, reverts on overflow.
52     */
53     function add(uint256 a, uint256 b) internal pure returns (uint256) {
54         uint256 c = a + b;
55         require(c >= a);
56 
57         return c;
58     }
59 
60     /**
61     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
62     * reverts when dividing by zero.
63     */
64     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
65         require(b != 0);
66         return a % b;
67     }
68 }
69 
70 // File: zos-lib/contracts/Initializable.sol
71 
72 pragma solidity >=0.5.0 <0.6.0;
73 
74 
75 /**
76  * @title Initializable
77  *
78  * @dev Helper contract to support initializer functions. To use it, replace
79  * the constructor with a function that has the `initializer` modifier.
80  * WARNING: Unlike constructors, initializer functions must be manually
81  * invoked. This applies both to deploying an Initializable contract, as well
82  * as extending an Initializable contract via inheritance.
83  * WARNING: When used with inheritance, manual care must be taken to not invoke
84  * a parent initializer twice, or ensure that all initializers are idempotent,
85  * because this is not dealt with automatically as with constructors.
86  */
87 contract Initializable {
88 
89     /**
90      * @dev Indicates that the contract has been initialized.
91      */
92     bool private initialized;
93 
94     /**
95      * @dev Indicates that the contract is in the process of being initialized.
96      */
97     bool private initializing;
98 
99     /**
100      * @dev Modifier to use in the initializer function of a contract.
101      */
102     modifier initializer() {
103         require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
104 
105         bool isTopLevelCall = !initializing;
106         if (isTopLevelCall) {
107             initializing = true;
108             initialized = true;
109         }
110 
111         _;
112 
113         if (isTopLevelCall) {
114             initializing = false;
115         }
116     }
117 
118     /// @dev Returns true if and only if the function is running in the constructor
119     function isConstructor() private view returns (bool) {
120         // extcodesize checks the size of the code stored in an address, and
121         // address returns the current address. Since the code is still not
122         // deployed when running a constructor, any checks on its code size will
123         // yield zero, making it an effective way to detect if a contract is
124         // under construction or not.
125         uint256 cs;
126         assembly { cs := extcodesize(address) }
127         return cs == 0;
128     }
129 
130     // Reserved storage space to allow for layout changes in the future.
131     uint256[50] private ______gap;
132 }
133 
134 // File: openzeppelin-eth/contracts/ownership/Ownable.sol
135 
136 pragma solidity ^0.5.0;
137 
138 
139 /**
140  * @title Ownable
141  * @dev The Ownable contract has an owner address, and provides basic authorization control
142  * functions, this simplifies the implementation of "user permissions".
143  */
144 contract Ownable is Initializable {
145     address private _owner;
146 
147 
148     event OwnershipRenounced(address indexed previousOwner);
149     event OwnershipTransferred(
150         address indexed previousOwner,
151         address indexed newOwner
152     );
153 
154 
155     /**
156      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
157      * account.
158      */
159     function initialize(address sender) public initializer {
160         _owner = sender;
161     }
162 
163     /**
164      * @return the address of the owner.
165      */
166     function owner() public view returns(address) {
167         return _owner;
168     }
169 
170     /**
171      * @dev Throws if called by any account other than the owner.
172      */
173     modifier onlyOwner() {
174         require(isOwner());
175         _;
176     }
177 
178     /**
179      * @return true if `msg.sender` is the owner of the contract.
180      */
181     function isOwner() public view returns(bool) {
182         return msg.sender == _owner;
183     }
184 
185     /**
186      * @dev Allows the current owner to relinquish control of the contract.
187      * @notice Renouncing to ownership will leave the contract without an owner.
188      * It will not be possible to call the functions with the `onlyOwner`
189      * modifier anymore.
190      */
191     function renounceOwnership() public onlyOwner {
192         emit OwnershipRenounced(_owner);
193         _owner = address(0);
194     }
195 
196     /**
197      * @dev Allows the current owner to transfer control of the contract to a newOwner.
198      * @param newOwner The address to transfer ownership to.
199      */
200     function transferOwnership(address newOwner) public onlyOwner {
201         _transferOwnership(newOwner);
202     }
203 
204     /**
205      * @dev Transfers control of the contract to a newOwner.
206      * @param newOwner The address to transfer ownership to.
207      */
208     function _transferOwnership(address newOwner) internal {
209         require(newOwner != address(0));
210         emit OwnershipTransferred(_owner, newOwner);
211         _owner = newOwner;
212     }
213 
214     uint256[50] private ______gap;
215 }
216 
217 // File: openzeppelin-eth/contracts/token/ERC20/IERC20.sol
218 
219 pragma solidity ^0.5.0;
220 
221 
222 /**
223  * @title ERC20 interface
224  * @dev see https://github.com/ethereum/EIPs/issues/20
225  */
226 interface IERC20 {
227     function totalSupply() external view returns (uint256);
228 
229     function balanceOf(address who) external view returns (uint256);
230 
231     function allowance(address owner, address spender)
232     external view returns (uint256);
233 
234     function transfer(address to, uint256 value) external returns (bool);
235 
236     function approve(address spender, uint256 value)
237     external returns (bool);
238 
239     function transferFrom(address from, address to, uint256 value)
240     external returns (bool);
241 
242     event Transfer(
243         address indexed from,
244         address indexed to,
245         uint256 value
246     );
247 
248     event Approval(
249         address indexed owner,
250         address indexed spender,
251         uint256 value
252     );
253 }
254 
255 // File: openzeppelin-eth/contracts/token/ERC20/ERC20Detailed.sol
256 
257 pragma solidity ^0.5.0;
258 
259 
260 
261 
262 /**
263  * @title ERC20Detailed token
264  * @dev The decimals are only for visualization purposes.
265  * All the operations are done using the smallest and indivisible token unit,
266  * just as on Ethereum all the operations are done in wei.
267  */
268 contract ERC20Detailed is Initializable, IERC20 {
269     string private _name;
270     string private _symbol;
271     uint8 private _decimals;
272 
273     function initialize(string memory name, string memory symbol, uint8 decimals) public initializer {
274         _name = name;
275         _symbol = symbol;
276         _decimals = decimals;
277     }
278 
279     /**
280      * @return the name of the token.
281      */
282     function name() public view returns(string memory) {
283         return _name;
284     }
285 
286     /**
287      * @return the symbol of the token.
288      */
289     function symbol() public view returns(string memory) {
290         return _symbol;
291     }
292 
293     /**
294      * @return the number of decimals of the token.
295      */
296     function decimals() public view returns(uint8) {
297         return _decimals;
298     }
299 
300     uint256[50] private ______gap;
301 }
302 
303 // File: uFragments/contracts/lib/SafeMathInt.sol
304 
305 /*
306 MIT License
307 
308 Copyright (c) 2018 requestnetwork
309 Copyright (c) 2018 Fragments, Inc.
310 
311 Permission is hereby granted, free of charge, to any person obtaining a copy
312 of this software and associated documentation files (the "Software"), to deal
313 in the Software without restriction, including without limitation the rights
314 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
315 copies of the Software, and to permit persons to whom the Software is
316 furnished to do so, subject to the following conditions:
317 
318 The above copyright notice and this permission notice shall be included in all
319 copies or substantial portions of the Software.
320 
321 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
322 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
323 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
324 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
325 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
326 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
327 SOFTWARE.
328 */
329 
330 pragma solidity ^0.5.0;
331 
332 
333 /**
334  * @title SafeMathInt
335  * @dev Math operations for int256 with overflow safety checks.
336  */
337 library SafeMathInt {
338     int256 private constant MIN_INT256 = int256(1) << 255;
339     int256 private constant MAX_INT256 = ~(int256(1) << 255);
340 
341     /**
342      * @dev Multiplies two int256 variables and fails on overflow.
343      */
344     function mul(int256 a, int256 b)
345     internal
346     pure
347     returns (int256)
348     {
349         int256 c = a * b;
350 
351         // Detect overflow when multiplying MIN_INT256 with -1
352         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
353         require((b == 0) || (c / b == a));
354         return c;
355     }
356 
357     /**
358      * @dev Division of two int256 variables and fails on overflow.
359      */
360     function div(int256 a, int256 b)
361     internal
362     pure
363     returns (int256)
364     {
365         // Prevent overflow when dividing MIN_INT256 by -1
366         require(b != -1 || a != MIN_INT256);
367 
368         // Solidity already throws when dividing by 0.
369         return a / b;
370     }
371 
372     /**
373      * @dev Subtracts two int256 variables and fails on overflow.
374      */
375     function sub(int256 a, int256 b)
376     internal
377     pure
378     returns (int256)
379     {
380         int256 c = a - b;
381         require((b >= 0 && c <= a) || (b < 0 && c > a));
382         return c;
383     }
384 
385     /**
386      * @dev Adds two int256 variables and fails on overflow.
387      */
388     function add(int256 a, int256 b)
389     internal
390     pure
391     returns (int256)
392     {
393         int256 c = a + b;
394         require((b >= 0 && c >= a) || (b < 0 && c < a));
395         return c;
396     }
397 
398     /**
399      * @dev Converts to absolute value, and fails on overflow.
400      */
401     function abs(int256 a)
402     internal
403     pure
404     returns (int256)
405     {
406         require(a != MIN_INT256);
407         return a < 0 ? -a : a;
408     }
409 }
410 
411 // File: uFragments/contracts/UFragments.sol
412 
413 pragma solidity ^0.5.0;
414 
415 
416 
417 
418 
419 
420 /**
421  * @title uFragments ERC20 token
422  * @dev This is part of an implementation of the uFragments Ideal Money protocol.
423  *      uFragments is a normal ERC20 token, but its supply can be adjusted by splitting and
424  *      combining tokens proportionally across all wallets.
425  *
426  *      uFragment balances are internally represented with a hidden denomination, 'gons'.
427  *      We support splitting the currency in expansion and combining the currency on contraction by
428  *      changing the exchange rate between the hidden 'gons' and the public 'fragments'.
429  */
430 contract vUSD is ERC20Detailed, Ownable {
431     // PLEASE READ BEFORE CHANGING ANY ACCOUNTING OR MATH
432     // Anytime there is division, there is a risk of numerical instability from rounding errors. In
433     // order to minimize this risk, we adhere to the following guidelines:
434     // 1) The conversion rate adopted is the number of gons that equals 1 fragment.
435     //    The inverse rate must not be used--TOTAL_GONS is always the numerator and _totalSupply is
436     //    always the denominator. (i.e. If you want to convert gons to fragments instead of
437     //    multiplying by the inverse rate, you should divide by the normal rate)
438     // 2) Gon balances converted into Fragments are always rounded down (truncated).
439     //
440     // We make the following guarantees:
441     // - If address 'A' transfers x Fragments to address 'B'. A's resulting external balance will
442     //   be decreased by precisely x Fragments, and B's external balance will be precisely
443     //   increased by x Fragments.
444     //
445     // We do not guarantee that the sum of all balances equals the result of calling totalSupply().
446     // This is because, for any conversion function 'f()' that has non-zero rounding error,
447     // f(x0) + f(x1) + ... + f(xn) is not always equal to f(x0 + x1 + ... xn).
448     using SafeMath for uint256;
449     using SafeMathInt for int256;
450 
451     event LogRebase(uint256 indexed epoch, uint256 totalSupply);
452     event LogMonetaryPolicyUpdated(address monetaryPolicy);
453 
454     // Used for authentication
455     address public monetaryPolicy;
456 
457     modifier onlyMonetaryPolicy() {
458         require(msg.sender == monetaryPolicy);
459         _;
460     }
461 
462     bool private rebasePausedDeprecated;
463     bool private tokenPausedDeprecated;
464 
465     modifier validRecipient(address to) {
466         require(to != address(0x0));
467         require(to != address(this));
468         _;
469     }
470 
471     uint256 private constant DECIMALS = 9;
472     uint256 private constant MAX_UINT256 = ~uint256(0);
473     uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 10 * 10**6 * 10**DECIMALS; // 10 million (locked in this base contract)
474 
475     // TOTAL_GONS is a multiple of INITIAL_FRAGMENTS_SUPPLY so that _gonsPerFragment is an integer.
476     // Use the highest value that fits in a uint256 for max granularity.
477     uint256 private constant TOTAL_GONS = MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);
478 
479     // MAX_SUPPLY = maximum integer < (sqrt(4*TOTAL_GONS + 1) - 1) / 2
480     uint256 private constant MAX_SUPPLY = ~uint128(0);  // (2^128) - 1
481 
482     uint256 private _totalSupply;
483     uint256 private _gonsPerFragment;
484     mapping(address => uint256) private _gonBalances;
485 
486     // This is denominated in Fragments, because the gons-fragments conversion might change before
487     // it's fully paid.
488     mapping (address => mapping (address => uint256)) private _allowedFragments;
489 
490     mapping (address => bool) public minters;
491 
492     function addMinter(address _minter) public onlyOwner {
493         minters[_minter] = true;
494     }
495 
496     function removeMinter(address _minter) public onlyOwner {
497         minters[_minter] = false;
498     }
499 
500     function mint(address account, uint amount) public {
501         require(minters[msg.sender], "!minter");
502         require(account != address(0x0), "ERC20: mint to the zero address");
503         uint256 gonValue = amount.mul(_gonsPerFragment);
504         _totalSupply = _totalSupply.add(amount);
505         _gonBalances[account] = _gonBalances[account].add(gonValue);
506         emit Transfer(address(0x0), account, amount);
507     }
508 
509     function burn(uint amount) public {
510         require(msg.sender != address(0x0), "ERC20: burn from the zero address");
511         uint256 gonValue = amount.mul(_gonsPerFragment);
512         _gonBalances[msg.sender] = _gonBalances[msg.sender].sub(gonValue);
513         _totalSupply = _totalSupply.sub(amount);
514         emit Transfer(address(0x0), msg.sender, amount);
515     }
516 
517     /**
518      * @param monetaryPolicy_ The address of the monetary policy contract to use for authentication.
519      */
520     function setMonetaryPolicy(address monetaryPolicy_)
521     external
522     onlyOwner
523     {
524         monetaryPolicy = monetaryPolicy_;
525         emit LogMonetaryPolicyUpdated(monetaryPolicy_);
526     }
527 
528     /**
529      * @dev Notifies Fragments contract about a new rebase cycle.
530      * @param supplyDelta The number of new fragment tokens to add into circulation via expansion.
531      * @return The total number of fragments after the supply adjustment.
532      */
533     function rebase(uint256 epoch, int256 supplyDelta)
534     external
535     onlyMonetaryPolicy
536     returns (uint256)
537     {
538         if (supplyDelta == 0) {
539             emit LogRebase(epoch, _totalSupply);
540             return _totalSupply;
541         }
542 
543         if (supplyDelta < 0) {
544             _totalSupply = _totalSupply.sub(uint256(supplyDelta.abs()));
545         } else {
546             _totalSupply = _totalSupply.add(uint256(supplyDelta));
547         }
548 
549         if (_totalSupply > MAX_SUPPLY) {
550             _totalSupply = MAX_SUPPLY;
551         }
552 
553         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
554 
555         // From this point forward, _gonsPerFragment is taken as the source of truth.
556         // We recalculate a new _totalSupply to be in agreement with the _gonsPerFragment
557         // conversion rate.
558         // This means our applied supplyDelta can deviate from the requested supplyDelta,
559         // but this deviation is guaranteed to be < (_totalSupply^2)/(TOTAL_GONS - _totalSupply).
560         //
561         // In the case of _totalSupply <= MAX_UINT128 (our current supply cap), this
562         // deviation is guaranteed to be < 1, so we can omit this step. If the supply cap is
563         // ever increased, it must be re-included.
564         // _totalSupply = TOTAL_GONS.div(_gonsPerFragment)
565 
566         emit LogRebase(epoch, _totalSupply);
567         return _totalSupply;
568     }
569 
570     function initialize(address owner_)
571     public
572     initializer
573     {
574         ERC20Detailed.initialize("Value USD", "vUSD", uint8(DECIMALS));
575         Ownable.initialize(owner_);
576 
577         rebasePausedDeprecated = false;
578         tokenPausedDeprecated = false;
579 
580         _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
581         _gonBalances[address(this)] = TOTAL_GONS;
582         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
583 
584         emit Transfer(address(0x0), owner_, _totalSupply);
585     }
586 
587     /**
588      * @return The total number of fragments.
589      */
590     function totalSupply()
591     public
592     view
593     returns (uint256)
594     {
595         return _totalSupply;
596     }
597 
598     /**
599      * @param who The address to query.
600      * @return The balance of the specified address.
601      */
602     function balanceOf(address who)
603     public
604     view
605     returns (uint256)
606     {
607         return _gonBalances[who].div(_gonsPerFragment);
608     }
609 
610     /**
611      * @dev Transfer tokens to a specified address.
612      * @param to The address to transfer to.
613      * @param value The amount to be transferred.
614      * @return True on success, false otherwise.
615      */
616     function transfer(address to, uint256 value)
617     public
618     validRecipient(to)
619     returns (bool)
620     {
621         uint256 gonValue = value.mul(_gonsPerFragment);
622         _gonBalances[msg.sender] = _gonBalances[msg.sender].sub(gonValue);
623         _gonBalances[to] = _gonBalances[to].add(gonValue);
624         emit Transfer(msg.sender, to, value);
625         return true;
626     }
627 
628     /**
629      * @dev Function to check the amount of tokens that an owner has allowed to a spender.
630      * @param owner_ The address which owns the funds.
631      * @param spender The address which will spend the funds.
632      * @return The number of tokens still available for the spender.
633      */
634     function allowance(address owner_, address spender)
635     public
636     view
637     returns (uint256)
638     {
639         return _allowedFragments[owner_][spender];
640     }
641 
642     /**
643      * @dev Transfer tokens from one address to another.
644      * @param from The address you want to send tokens from.
645      * @param to The address you want to transfer to.
646      * @param value The amount of tokens to be transferred.
647      */
648     function transferFrom(address from, address to, uint256 value)
649     public
650     validRecipient(to)
651     returns (bool)
652     {
653         _allowedFragments[from][msg.sender] = _allowedFragments[from][msg.sender].sub(value);
654 
655         uint256 gonValue = value.mul(_gonsPerFragment);
656         _gonBalances[from] = _gonBalances[from].sub(gonValue);
657         _gonBalances[to] = _gonBalances[to].add(gonValue);
658         emit Transfer(from, to, value);
659 
660         return true;
661     }
662 
663     /**
664      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
665      * msg.sender. This method is included for ERC20 compatibility.
666      * increaseAllowance and decreaseAllowance should be used instead.
667      * Changing an allowance with this method brings the risk that someone may transfer both
668      * the old and the new allowance - if they are both greater than zero - if a transfer
669      * transaction is mined before the later approve() call is mined.
670      *
671      * @param spender The address which will spend the funds.
672      * @param value The amount of tokens to be spent.
673      */
674     function approve(address spender, uint256 value)
675     public
676     returns (bool)
677     {
678         _allowedFragments[msg.sender][spender] = value;
679         emit Approval(msg.sender, spender, value);
680         return true;
681     }
682 
683     /**
684      * @dev Increase the amount of tokens that an owner has allowed to a spender.
685      * This method should be used instead of approve() to avoid the double approval vulnerability
686      * described above.
687      * @param spender The address which will spend the funds.
688      * @param addedValue The amount of tokens to increase the allowance by.
689      */
690     function increaseAllowance(address spender, uint256 addedValue)
691     public
692     returns (bool)
693     {
694         _allowedFragments[msg.sender][spender] =
695         _allowedFragments[msg.sender][spender].add(addedValue);
696         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
697         return true;
698     }
699 
700     /**
701      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
702      *
703      * @param spender The address which will spend the funds.
704      * @param subtractedValue The amount of tokens to decrease the allowance by.
705      */
706     function decreaseAllowance(address spender, uint256 subtractedValue)
707     public
708     returns (bool)
709     {
710         uint256 oldValue = _allowedFragments[msg.sender][spender];
711         if (subtractedValue >= oldValue) {
712             _allowedFragments[msg.sender][spender] = 0;
713         } else {
714             _allowedFragments[msg.sender][spender] = oldValue.sub(subtractedValue);
715         }
716         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
717         return true;
718     }
719 }