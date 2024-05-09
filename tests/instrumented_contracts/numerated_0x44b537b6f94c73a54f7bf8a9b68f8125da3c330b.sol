1 /*
2     MIT License
3     
4     Copyright (c) 2018 requestnetwork
5     Copyright (c) 2018 Fragments, Inc.
6     
7     Permission is hereby granted, free of charge, to any person obtaining a copy
8     of this software and associated documentation files (the "Software"), to deal
9     in the Software without restriction, including without limitation the rights
10     to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
11     copies of the Software, and to permit persons to whom the Software is
12     furnished to do so, subject to the following conditions:
13     
14     The above copyright notice and this permission notice shall be included in all
15     copies or substantial portions of the Software.
16     
17     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
18     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
19     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
20     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
21     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
22     OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
23     SOFTWARE.
24 */
25 
26 pragma solidity 0.4.24;
27 
28 
29 /**
30  * @title SafeMathInt
31  * @dev Math operations for int256 with overflow safety checks.
32  */
33 library SafeMathInt {
34     int256 private constant MIN_INT256 = int256(1) << 255;
35     int256 private constant MAX_INT256 = ~(int256(1) << 255);
36 
37     /**
38      * @dev Multiplies two int256 variables and fails on overflow.
39      */
40     function mul(int256 a, int256 b)
41         internal
42         pure
43         returns (int256)
44     {
45         int256 c = a * b;
46 
47         // Detect overflow when multiplying MIN_INT256 with -1
48         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
49         require((b == 0) || (c / b == a));
50         return c;
51     }
52 
53     /**
54      * @dev Division of two int256 variables and fails on overflow.
55      */
56     function div(int256 a, int256 b)
57         internal
58         pure
59         returns (int256)
60     {
61         // Prevent overflow when dividing MIN_INT256 by -1
62         require(b != -1 || a != MIN_INT256);
63 
64         // Solidity already throws when dividing by 0.
65         return a / b;
66     }
67 
68     /**
69      * @dev Subtracts two int256 variables and fails on overflow.
70      */
71     function sub(int256 a, int256 b)
72         internal
73         pure
74         returns (int256)
75     {
76         int256 c = a - b;
77         require((b >= 0 && c <= a) || (b < 0 && c > a));
78         return c;
79     }
80 
81     /**
82      * @dev Adds two int256 variables and fails on overflow.
83      */
84     function add(int256 a, int256 b)
85         internal
86         pure
87         returns (int256)
88     {
89         int256 c = a + b;
90         require((b >= 0 && c >= a) || (b < 0 && c < a));
91         return c;
92     }
93 
94     /**
95      * @dev Converts to absolute value, and fails on overflow.
96      */
97     function abs(int256 a)
98         internal
99         pure
100         returns (int256)
101     {
102         require(a != MIN_INT256);
103         return a < 0 ? -a : a;
104     }
105 }
106 pragma solidity >=0.4.24 <0.7.0;
107 
108 
109 /**
110  * @title Initializable
111  *
112  * @dev Helper contract to support initializer functions. To use it, replace
113  * the constructor with a function that has the `initializer` modifier.
114  * WARNING: Unlike constructors, initializer functions must be manually
115  * invoked. This applies both to deploying an Initializable contract, as well
116  * as extending an Initializable contract via inheritance.
117  * WARNING: When used with inheritance, manual care must be taken to not invoke
118  * a parent initializer twice, or ensure that all initializers are idempotent,
119  * because this is not dealt with automatically as with constructors.
120  */
121 contract Initializable {
122     bool private initialized;
123     bool private initializing;
124 
125     modifier initializer() {
126         require(initializing || isConstructor() || !initialized, "Contract already initialized");
127 
128         bool isTopLevelCall = !initializing;
129         if (isTopLevelCall) {
130             initializing = true;
131             initialized = true;
132         }
133 
134         _   ;
135 
136         if (isTopLevelCall) {
137             initializing = false;
138         }
139     }
140 
141   /// @dev Returns true if and only if the function is running in the constructor
142     function isConstructor() private view returns (bool) {
143     // extcodesize checks the size of the code stored in an address, and
144     // address returns the current address. Since the code is still not
145     // deployed when running a constructor, any checks on its code size will
146     // yield zero, making it an effective way to detect if a contract is
147     // under construction or not.
148         address self = address(this);
149         uint256 cs;
150         assembly { cs := extcodesize(self) }
151         return cs == 0;
152     }
153 
154   // Reserved storage space to allow for layout changes in the future.
155     uint256[50] private ______gap;
156 }
157 
158 /**
159  * @title Ownable
160  * @dev The Ownable contract has an owner address, and provides basic authorization control
161  * functions, this simplifies the implementation of "user permissions".
162  */
163 contract Ownable is Initializable {
164     address private _owner;
165 
166 
167     event OwnershipRenounced(address indexed previousOwner);
168     event OwnershipTransferred(
169     address indexed previousOwner,
170     address indexed newOwner
171     );
172 
173 
174   /**
175    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
176    * account.
177    */
178     function initialize(address sender) public initializer {
179         _owner = sender;
180     }
181 
182   /**
183    * @return the address of the owner.
184    */
185     function owner() public view returns(address) {
186         return _owner;
187     }
188 
189   /**
190    * @dev Throws if called by any account other than the owner.
191    */
192     modifier onlyOwner() {
193         require(isOwner());
194         _;
195     }
196 
197   /**
198    * @return true if `msg.sender` is the owner of the contract.
199    */
200     function isOwner() public view returns(bool) {
201         return msg.sender == _owner;
202     }  
203 
204   /**
205    * @dev Allows the current owner to relinquish control of the contract.
206    * @notice Renouncing to ownership will leave the contract without an owner.
207    * It will not be possible to call the functions with the `onlyOwner`
208    * modifier anymore.
209    */
210     function renounceOwnership() public onlyOwner {
211         emit OwnershipRenounced(_owner);
212         _owner = address(0);
213     } 
214 
215   /**
216    * @dev Allows the current owner to transfer control of the contract to a newOwner.
217    * @param newOwner The address to transfer ownership to.
218    */
219     function transferOwnership(address newOwner) public onlyOwner {
220         _transferOwnership(newOwner);
221     }
222 
223   /**
224    * @dev Transfers control of the contract to a newOwner.
225    * @param newOwner The address to transfer ownership to.
226    */
227     function _transferOwnership(address newOwner) internal {
228         require(newOwner != address(0));
229         emit OwnershipTransferred(_owner, newOwner);
230         _owner = newOwner;
231     }
232 
233     uint256[50] private ______gap;
234 }
235 
236 pragma solidity ^0.4.24;
237 
238 
239 /**
240  * @title SafeMath
241  * @dev Math operations with safety checks that throw on error
242  */
243 library SafeMath {
244 
245   /**
246   * @dev Multiplies two numbers, throws on overflow.
247   */
248     function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
249     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
250     // benefit is lost if 'b' is also tested.
251     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
252         if (_a == 0) {
253             return 0;
254         }
255 
256         c = _a * _b;
257         assert(c / _a == _b);
258         return c;
259     }
260 
261   /**
262   * @dev Integer division of two numbers, truncating the quotient.
263   */
264     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
265     // assert(_b > 0); // Solidity automatically throws when dividing by 0
266     // uint256 c = _a / _b;
267     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
268         return _a / _b;
269     }
270 
271   /**
272   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
273   */
274     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
275         assert(_b <= _a);
276         return _a - _b;
277     }
278 
279   /**
280   * @dev Adds two numbers, throws on overflow.
281   */
282     function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
283         c = _a + _b;
284         assert(c >= _a);
285         return c;
286     }
287 
288     // function mod(uint256 a, uint256 b) internal pure returns (uint256) {
289     //     return mod(a, b);
290     // }
291     
292     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
293         require(b != 0);
294         return a % b;
295     }
296 
297 }
298 
299 pragma solidity ^0.4.24;
300 
301 /**
302  * @title ERC20 interface
303  * @dev see https://github.com/ethereum/EIPs/issues/20
304  */
305 interface IERC20 {
306     function totalSupply() external view returns (uint256);
307 
308     function balanceOf(address who) external view returns (uint256);
309 
310     function allowance(address owner, address spender)
311     external view returns (uint256);
312 
313     function transfer(address to, uint256 value) external returns (bool);
314 
315     function approve(address spender, uint256 value)
316     external returns (bool);
317 
318     function transferFrom(address from, address to, uint256 value)
319     external returns (bool);
320 
321     event Transfer(
322     address indexed from,
323     address indexed to,
324     uint256 value
325 
326     );
327 
328     event Approval(
329     address indexed owner,
330     address indexed spender,
331     uint256 value
332     );
333 }
334 
335 pragma solidity ^0.4.24;
336 
337 /**
338  * @title ERC20Detailed token
339  * @dev The decimals are only for visualization purposes.
340  * All the operations are done using the smallest and indivisible token unit,
341  * just as on Ethereum all the operations are done in wei.
342  */
343 contract ERC20Detailed is Initializable, IERC20 {
344   string private _name;
345   string private _symbol;
346   uint8 private _decimals;
347 
348   function initialize(string name, string symbol, uint8 decimals) public initializer {
349     _name = name;
350     _symbol = symbol;
351     _decimals = decimals;
352   }
353 
354   /**
355    * @return the name of the token.
356    */
357   function name() public view returns(string) {
358     return _name;
359   }
360 
361   /**
362    * @return the symbol of the token.
363    */
364   function symbol() public view returns(string) {
365     return _symbol;
366   }
367 
368   /**
369    * @return the number of decimals of the token.
370    */
371   function decimals() public view returns(uint8) {
372     return _decimals;
373   }
374 
375   uint256[50] private ______gap;
376 }
377 
378 interface ISync {
379     function sync() external;
380 }
381 
382 /**
383  * @title PolkabaseToken ERC20 token
384  * @dev This is part of an implementation of the PolkabaseToken Ideal Money protocol.
385  *      uFragments is a normal ERC20 token, but its supply can be adjusted by splitting and
386  *      combining tokens proportionally across all wallets.
387  *
388  *      uFragment balances are internally represented with a hidden denomination, 'gons'.
389  *      We support splitting the currency in expansion and combining the currency on contraction by
390  *      changing the exchange rate between the hidden 'gons' and the public 'fragments'.
391  */
392 contract PolkabaseToken is ERC20Detailed, Ownable {
393     // PLEASE READ BEFORE CHANGING ANY ACCOUNTING OR MATH
394     // Anytime there is division, there is a risk of numerical instability from rounding errors. In
395     // order to minimize this risk, we adhere to the following guidelines:
396     // 1) The conversion rate adopted is the number of gons that equals 1 fragment.
397     //    The inverse rate must not be used--TOTAL_GONS is always the numerator and _totalSupply is
398     //    always the denominator. (i.e. If you want to convert gons to fragments instead of
399     //    multiplying by the inverse rate, you should divide by the normal rate)
400     // 2) Gon balances converted into Fragments are always rounded down (truncated).
401     //
402     // We make the following guarantees:
403     // - If address 'A' transfers x Fragments to address 'B'. A's resulting external balance will
404     //   be decreased by precisely x Fragments, and B's external balance will be precisely
405     //   increased by x Fragments.
406     //
407     // We do not guarantee that the sum of all balances equals the result of calling totalSupply().
408     // This is because, for any conversion function 'f()' that has non-zero rounding error,
409     // f(x0) + f(x1) + ... + f(xn) is not always equal to f(x0 + x1 + ... xn).
410     using SafeMath for uint256;
411     using SafeMathInt for int256;
412 
413     event LogRebase(uint256 indexed epoch, uint256 totalSupply);
414     event LogMonetaryPolicyUpdated(address monetaryPolicy);
415     event LogPbaseEthPairAdded(address pbaseEthUniswapPair);
416 
417     // Used for authentication
418     address public monetaryPolicy;
419 
420     modifier onlyMonetaryPolicy() {
421         require(msg.sender == monetaryPolicy);
422         _;
423     }
424 
425     bool private rebasePausedDeprecated;
426     bool private tokenPausedDeprecated;
427 
428     modifier validRecipient(address to) {
429         require(to != address(0x0));
430         require(to != address(this));
431         _;
432     }
433 
434     uint256 private constant DECIMALS = 9;
435     uint256 private constant MAX_UINT256 = ~uint256(0);
436     uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 596 * 10**3 * 10**DECIMALS;     // Initial Supply 596_000 
437    
438 
439     // TOTAL_GONS is a multiple of INITIAL_FRAGMENTS_SUPPLY so that _gonsPerFragment is an integer.
440     // Use the highest value that fits in a uint256 for max granularity.
441     uint256 private constant TOTAL_GONS = MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);
442 
443     // MAX_SUPPLY = maximum integer < (sqrt(4*TOTAL_GONS + 1) - 1) / 2
444     uint256 private constant MAX_SUPPLY = ~uint128(0);  // (2^128) - 1
445 
446     uint256 private _totalSupply;
447     uint256 private _gonsPerFragment;
448 
449     //
450     address public _pbaseEthUniswapPair;
451 
452     mapping(address => uint256) private _gonBalances;
453 
454     // This is denominated in Fragments, because the gons-fragments conversion might change before
455     // it's fully paid.
456     mapping (address => mapping (address => uint256)) private _allowedFragments;
457 
458     /**
459      * @param monetaryPolicy_ The address of the monetary policy contract to use for authentication.
460      */
461     function setMonetaryPolicy(address monetaryPolicy_)
462         external
463         onlyOwner
464     {
465         monetaryPolicy = monetaryPolicy_;
466         emit LogMonetaryPolicyUpdated(monetaryPolicy_);
467     }
468 
469     /**
470      * @param pbaseEthUniswapPair_ The address of the uniswap pair(pabase~eth) contract to sync liquiity.
471      */
472     function setPbaseEthPairAddress(address pbaseEthUniswapPair_)
473         external
474         onlyOwner
475     {
476         _pbaseEthUniswapPair = pbaseEthUniswapPair_;
477         emit LogPbaseEthPairAdded(_pbaseEthUniswapPair);
478     }
479 
480     /**
481      * @dev Notifies Fragments contract about a new rebase cycle.
482      * @param supplyDelta The number of new fragment tokens to add into circulation via expansion.
483      * @return The total number of fragments after the supply adjustment.
484      */
485     function rebase(uint256 epoch, int256 supplyDelta)
486         external
487         onlyMonetaryPolicy
488         returns (uint256)
489     {
490         if (supplyDelta == 0) {
491             emit LogRebase(epoch, _totalSupply);
492             return _totalSupply;
493         }
494 
495         if (supplyDelta < 0) {
496             _totalSupply = _totalSupply.sub(uint256(supplyDelta.abs()));
497         } else {
498             _totalSupply = _totalSupply.add(uint256(supplyDelta));
499         }
500 
501         if (_totalSupply > MAX_SUPPLY) {
502             _totalSupply = MAX_SUPPLY;
503         }
504 
505         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
506 
507         // From this point forward, _gonsPerFragment is taken as the source of truth.
508         // We recalculate a new _totalSupply to be in agreement with the _gonsPerFragment
509         // conversion rate.
510         // This means our applied supplyDelta can deviate from the requested supplyDelta,
511         // but this deviation is guaranteed to be < (_totalSupply^2)/(TOTAL_GONS - _totalSupply).
512         //
513         // In the case of _totalSupply <= MAX_UINT128 (our current supply cap), this
514         // deviation is guaranteed to be < 1, so we can omit this step. If the supply cap is
515         // ever increased, it must be re-included.
516         // _totalSupply = TOTAL_GONS.div(_gonsPerFragment)
517 
518         emit LogRebase(epoch, _totalSupply);
519         
520         //
521         ISync(_pbaseEthUniswapPair).sync();   // Uniswap ETH-PBASE Pair
522 
523         return _totalSupply;
524     }
525 
526     function initialize(address owner_)
527         public
528         initializer
529     {
530         ERC20Detailed.initialize("POLKABASE", "PBASE", uint8(DECIMALS));
531         Ownable.initialize(owner_);
532 
533         rebasePausedDeprecated = false;
534         tokenPausedDeprecated = false;
535 
536         _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
537         _gonBalances[owner_] = TOTAL_GONS;
538         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
539 
540         emit Transfer(address(0x0), owner_, _totalSupply);
541     }
542 
543     /**
544      * @return The total number of fragments.
545      */
546     function totalSupply()
547         public
548         view
549         returns (uint256)
550     {
551         return _totalSupply;
552     }
553 
554     /**
555      * @param who The address to query.
556      * @return The balance of the specified address.
557      */
558     function balanceOf(address who)
559         public
560         view
561         returns (uint256)
562     {
563         return _gonBalances[who].div(_gonsPerFragment);
564     }
565 
566     /**
567      * @dev Transfer tokens to a specified address.
568      * @param to The address to transfer to.
569      * @param value The amount to be transferred.
570      * @return True on success, false otherwise.
571      */
572     function transfer(address to, uint256 value)
573         public
574         validRecipient(to)
575         returns (bool)
576     {
577         uint256 gonValue = value.mul(_gonsPerFragment);
578         _gonBalances[msg.sender] = _gonBalances[msg.sender].sub(gonValue);
579         _gonBalances[to] = _gonBalances[to].add(gonValue);
580         emit Transfer(msg.sender, to, value);
581         return true;
582     }
583 
584     /**
585      * @dev Function to check the amount of tokens that an owner has allowed to a spender.
586      * @param owner_ The address which owns the funds.
587      * @param spender The address which will spend the funds.
588      * @return The number of tokens still available for the spender.
589      */
590     function allowance(address owner_, address spender)
591         public
592         view
593         returns (uint256)
594     {
595         return _allowedFragments[owner_][spender];
596     }
597 
598     /**
599      * @dev Transfer tokens from one address to another.
600      * @param from The address you want to send tokens from.
601      * @param to The address you want to transfer to.
602      * @param value The amount of tokens to be transferred.
603      */
604     function transferFrom(address from, address to, uint256 value)
605         public
606         validRecipient(to)
607         returns (bool)
608     {
609         _allowedFragments[from][msg.sender] = _allowedFragments[from][msg.sender].sub(value);
610 
611         uint256 gonValue = value.mul(_gonsPerFragment);
612         _gonBalances[from] = _gonBalances[from].sub(gonValue);
613         _gonBalances[to] = _gonBalances[to].add(gonValue);
614         emit Transfer(from, to, value);
615 
616         return true;
617     }
618 
619     /**
620      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
621      * msg.sender. This method is included for ERC20 compatibility.
622      * increaseAllowance and decreaseAllowance should be used instead.
623      * Changing an allowance with this method brings the risk that someone may transfer both
624      * the old and the new allowance - if they are both greater than zero - if a transfer
625      * transaction is mined before the later approve() call is mined.
626      *
627      * @param spender The address which will spend the funds.
628      * @param value The amount of tokens to be spent.
629      */
630     function approve(address spender, uint256 value)
631         public
632         returns (bool)
633     {
634         _allowedFragments[msg.sender][spender] = value;
635         emit Approval(msg.sender, spender, value);
636         return true;
637     }
638 
639     /**
640      * @dev Increase the amount of tokens that an owner has allowed to a spender.
641      * This method should be used instead of approve() to avoid the double approval vulnerability
642      * described above.
643      * @param spender The address which will spend the funds.
644      * @param addedValue The amount of tokens to increase the allowance by.
645      */
646     function increaseAllowance(address spender, uint256 addedValue)
647         public
648         returns (bool)
649     {
650         _allowedFragments[msg.sender][spender] =
651             _allowedFragments[msg.sender][spender].add(addedValue);
652         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
653         return true;
654     }
655 
656     /**
657      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
658      *
659      * @param spender The address which will spend the funds.
660      * @param subtractedValue The amount of tokens to decrease the allowance by.
661      */
662     function decreaseAllowance(address spender, uint256 subtractedValue)
663         public
664         returns (bool)
665     {
666         uint256 oldValue = _allowedFragments[msg.sender][spender];
667         if (subtractedValue >= oldValue) {
668             _allowedFragments[msg.sender][spender] = 0;
669         } else {
670             _allowedFragments[msg.sender][spender] = oldValue.sub(subtractedValue);
671         }
672         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
673         return true;
674     }
675 }