1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that revert on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, reverts on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (a == 0) {
18       return 0;
19     }
20 
21     uint256 c = a * b;
22     require(c / a == b);
23 
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     require(b > 0); // Solidity only automatically asserts when dividing by 0
32     uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34 
35     return c;
36   }
37 
38   /**
39   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42     require(b <= a);
43     uint256 c = a - b;
44 
45     return c;
46   }
47 
48   /**
49   * @dev Adds two numbers, reverts on overflow.
50   */
51   function add(uint256 a, uint256 b) internal pure returns (uint256) {
52     uint256 c = a + b;
53     require(c >= a);
54 
55     return c;
56   }
57 
58   /**
59   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
60   * reverts when dividing by zero.
61   */
62   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63     require(b != 0);
64     return a % b;
65   }
66 }
67 
68 /**
69  * @title Initializable
70  *
71  * @dev Helper contract to support initializer functions. To use it, replace
72  * the constructor with a function that has the `initializer` modifier.
73  * WARNING: Unlike constructors, initializer functions must be manually
74  * invoked. This applies both to deploying an Initializable contract, as well
75  * as extending an Initializable contract via inheritance.
76  * WARNING: When used with inheritance, manual care must be taken to not invoke
77  * a parent initializer twice, or ensure that all initializers are idempotent,
78  * because this is not dealt with automatically as with constructors.
79  */
80 contract Initializable {
81 
82   /**
83    * @dev Indicates that the contract has been initialized.
84    */
85   bool private initialized;
86 
87   /**
88    * @dev Indicates that the contract is in the process of being initialized.
89    */
90   bool private initializing;
91 
92   /**
93    * @dev Modifier to use in the initializer function of a contract.
94    */
95   modifier initializer() {
96     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
97 
98     bool wasInitializing = initializing;
99     initializing = true;
100     initialized = true;
101 
102     _;
103 
104     initializing = wasInitializing;
105   }
106 
107   /// @dev Returns true if and only if the function is running in the constructor
108   function isConstructor() private view returns (bool) {
109     // extcodesize checks the size of the code stored in an address, and
110     // address returns the current address. Since the code is still not
111     // deployed when running a constructor, any checks on its code size will
112     // yield zero, making it an effective way to detect if a contract is
113     // under construction or not.
114     uint256 cs;
115     assembly { cs := extcodesize(address) }
116     return cs == 0;
117   }
118 
119   // Reserved storage space to allow for layout changes in the future.
120   uint256[50] private ______gap;
121 }
122 
123 /**
124  * @title Ownable
125  * @dev The Ownable contract has an owner address, and provides basic authorization control
126  * functions, this simplifies the implementation of "user permissions".
127  */
128 contract Ownable is Initializable {
129   address private _owner;
130 
131 
132   event OwnershipRenounced(address indexed previousOwner);
133   event OwnershipTransferred(
134     address indexed previousOwner,
135     address indexed newOwner
136   );
137 
138 
139   /**
140    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
141    * account.
142    */
143   function initialize(address sender) public initializer {
144     _owner = sender;
145   }
146 
147   /**
148    * @return the address of the owner.
149    */
150   function owner() public view returns(address) {
151     return _owner;
152   }
153 
154   /**
155    * @dev Throws if called by any account other than the owner.
156    */
157   modifier onlyOwner() {
158     require(isOwner());
159     _;
160   }
161 
162   /**
163    * @return true if `msg.sender` is the owner of the contract.
164    */
165   function isOwner() public view returns(bool) {
166     return msg.sender == _owner;
167   }
168 
169   /**
170    * @dev Allows the current owner to relinquish control of the contract.
171    * @notice Renouncing to ownership will leave the contract without an owner.
172    * It will not be possible to call the functions with the `onlyOwner`
173    * modifier anymore.
174    */
175   function renounceOwnership() public onlyOwner {
176     emit OwnershipRenounced(_owner);
177     _owner = address(0);
178   }
179 
180   /**
181    * @dev Allows the current owner to transfer control of the contract to a newOwner.
182    * @param newOwner The address to transfer ownership to.
183    */
184   function transferOwnership(address newOwner) public onlyOwner {
185     _transferOwnership(newOwner);
186   }
187 
188   /**
189    * @dev Transfers control of the contract to a newOwner.
190    * @param newOwner The address to transfer ownership to.
191    */
192   function _transferOwnership(address newOwner) internal {
193     require(newOwner != address(0));
194     emit OwnershipTransferred(_owner, newOwner);
195     _owner = newOwner;
196   }
197 
198   uint256[50] private ______gap;
199 }
200 
201 /**
202  * @title ERC20 interface
203  * @dev see https://github.com/ethereum/EIPs/issues/20
204  */
205 interface IERC20 {
206   function totalSupply() external view returns (uint256);
207 
208   function balanceOf(address who) external view returns (uint256);
209 
210   function allowance(address owner, address spender)
211     external view returns (uint256);
212 
213   function transfer(address to, uint256 value) external returns (bool);
214 
215   function approve(address spender, uint256 value)
216     external returns (bool);
217 
218   function transferFrom(address from, address to, uint256 value)
219     external returns (bool);
220 
221   event Transfer(
222     address indexed from,
223     address indexed to,
224     uint256 value
225   );
226 
227   event Approval(
228     address indexed owner,
229     address indexed spender,
230     uint256 value
231   );
232 }
233 
234 /**
235  * @title ERC20Detailed token
236  * @dev The decimals are only for visualization purposes.
237  * All the operations are done using the smallest and indivisible token unit,
238  * just as on Ethereum all the operations are done in wei.
239  */
240 contract ERC20Detailed is Initializable, IERC20 {
241   string private _name;
242   string private _symbol;
243   uint8 private _decimals;
244 
245   function initialize(string name, string symbol, uint8 decimals) public initializer {
246     _name = name;
247     _symbol = symbol;
248     _decimals = decimals;
249   }
250 
251   /**
252    * @return the name of the token.
253    */
254   function name() public view returns(string) {
255     return _name;
256   }
257 
258   /**
259    * @return the symbol of the token.
260    */
261   function symbol() public view returns(string) {
262     return _symbol;
263   }
264 
265   /**
266    * @return the number of decimals of the token.
267    */
268   function decimals() public view returns(uint8) {
269     return _decimals;
270   }
271 
272   uint256[50] private ______gap;
273 }
274 
275 /*
276 MIT License
277 
278 Copyright (c) 2018 requestnetwork
279 Copyright (c) 2018 Fragments, Inc.
280 
281 Permission is hereby granted, free of charge, to any person obtaining a copy
282 of this software and associated documentation files (the "Software"), to deal
283 in the Software without restriction, including without limitation the rights
284 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
285 copies of the Software, and to permit persons to whom the Software is
286 furnished to do so, subject to the following conditions:
287 
288 The above copyright notice and this permission notice shall be included in all
289 copies or substantial portions of the Software.
290 
291 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
292 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
293 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
294 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
295 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
296 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
297 SOFTWARE.
298 */
299 /**
300  * @title SafeMathInt
301  * @dev Math operations for int256 with overflow safety checks.
302  */
303 library SafeMathInt {
304     int256 private constant MIN_INT256 = int256(1) << 255;
305     int256 private constant MAX_INT256 = ~(int256(1) << 255);
306 
307     /**
308      * @dev Multiplies two int256 variables and fails on overflow.
309      */
310     function mul(int256 a, int256 b)
311         internal
312         pure
313         returns (int256)
314     {
315         int256 c = a * b;
316 
317         // Detect overflow when multiplying MIN_INT256 with -1
318         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
319         require((b == 0) || (c / b == a));
320         return c;
321     }
322 
323     /**
324      * @dev Division of two int256 variables and fails on overflow.
325      */
326     function div(int256 a, int256 b)
327         internal
328         pure
329         returns (int256)
330     {
331         // Prevent overflow when dividing MIN_INT256 by -1
332         require(b != -1 || a != MIN_INT256);
333 
334         // Solidity already throws when dividing by 0.
335         return a / b;
336     }
337 
338     /**
339      * @dev Subtracts two int256 variables and fails on overflow.
340      */
341     function sub(int256 a, int256 b)
342         internal
343         pure
344         returns (int256)
345     {
346         int256 c = a - b;
347         require((b >= 0 && c <= a) || (b < 0 && c > a));
348         return c;
349     }
350 
351     /**
352      * @dev Adds two int256 variables and fails on overflow.
353      */
354     function add(int256 a, int256 b)
355         internal
356         pure
357         returns (int256)
358     {
359         int256 c = a + b;
360         require((b >= 0 && c >= a) || (b < 0 && c < a));
361         return c;
362     }
363 
364     /**
365      * @dev Converts to absolute value, and fails on overflow.
366      */
367     function abs(int256 a)
368         internal
369         pure
370         returns (int256)
371     {
372         require(a != MIN_INT256);
373         return a < 0 ? -a : a;
374     }
375 }
376 
377 /**
378  * @title uFragments ERC20 token
379  * @dev This is part of an implementation of the uFragments Ideal Money protocol.
380  *      uFragments is a normal ERC20 token, but its supply can be adjusted by splitting and
381  *      combining tokens proportionally across all wallets.
382  *
383  *      uFragment balances are internally represented with a hidden denomination, 'gons'.
384  *      We support splitting the currency in expansion and combining the currency on contraction by
385  *      changing the exchange rate between the hidden 'gons' and the public 'fragments'.
386  */
387 contract UFragments is ERC20Detailed, Ownable {
388     // PLEASE READ BEFORE CHANGING ANY ACCOUNTING OR MATH
389     // Anytime there is division, there is a risk of numerical instability from rounding errors. In
390     // order to minimize this risk, we adhere to the following guidelines:
391     // 1) The conversion rate adopted is the number of gons that equals 1 fragment.
392     //    The inverse rate must not be used--TOTAL_GONS is always the numerator and _totalSupply is
393     //    always the denominator. (i.e. If you want to convert gons to fragments instead of
394     //    multiplying by the inverse rate, you should divide by the normal rate)
395     // 2) Gon balances converted into Fragments are always rounded down (truncated).
396     //
397     // We make the following guarantees:
398     // - If address 'A' transfers x Fragments to address 'B'. A's resulting external balance will
399     //   be decreased by precisely x Fragments, and B's external balance will be precisely
400     //   increased by x Fragments.
401     //
402     // We do not guarantee that the sum of all balances equals the result of calling totalSupply().
403     // This is because, for any conversion function 'f()' that has non-zero rounding error,
404     // f(x0) + f(x1) + ... + f(xn) is not always equal to f(x0 + x1 + ... xn).
405     using SafeMath for uint256;
406     using SafeMathInt for int256;
407 
408     event LogRebase(uint256 indexed epoch, uint256 totalSupply);
409     event LogRebasePaused(bool paused);
410     event LogTokenPaused(bool paused);
411     event LogMonetaryPolicyUpdated(address monetaryPolicy);
412 
413     // Used for authentication
414     address public monetaryPolicy;
415 
416     modifier onlyMonetaryPolicy() {
417         require(msg.sender == monetaryPolicy);
418         _;
419     }
420 
421     // Precautionary emergency controls.
422     bool public rebasePaused;
423     bool public tokenPaused;
424 
425     modifier whenRebaseNotPaused() {
426         require(!rebasePaused);
427         _;
428     }
429 
430     modifier whenTokenNotPaused() {
431         require(!tokenPaused);
432         _;
433     }
434 
435     modifier validRecipient(address to) {
436         require(to != address(0x0));
437         require(to != address(this));
438         _;
439     }
440 
441     uint256 private constant DECIMALS = 18;
442     uint256 private constant MAX_UINT256 = ~uint256(0);
443     uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 100000 * 10**DECIMALS;
444 
445     // TOTAL_GONS is a multiple of INITIAL_FRAGMENTS_SUPPLY so that _gonsPerFragment is an integer.
446     // Use the highest value that fits in a uint256 for max granularity.
447     uint256 private constant TOTAL_GONS = MAX_UINT256 -
448         (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);
449 
450     // MAX_SUPPLY = maximum integer < (sqrt(4*TOTAL_GONS + 1) - 1) / 2
451     uint256 private constant MAX_SUPPLY = ~uint128(0); // (2^128) - 1
452 
453     uint256 private _totalSupply;
454     uint256 private _gonsPerFragment;
455     mapping(address => uint256) private _gonBalances;
456 
457     // This is denominated in Fragments, because the gons-fragments conversion might change before
458     // it's fully paid.
459     mapping(address => mapping(address => uint256)) private _allowedFragments;
460 
461     /**
462      * @param monetaryPolicy_ The address of the monetary policy contract to use for authentication.
463      */
464     function setMonetaryPolicy(address monetaryPolicy_) external onlyOwner {
465         monetaryPolicy = monetaryPolicy_;
466         emit LogMonetaryPolicyUpdated(monetaryPolicy_);
467     }
468 
469     /**
470      * @dev Pauses or unpauses the execution of rebase operations.
471      * @param paused Pauses rebase operations if this is true.
472      */
473     function setRebasePaused(bool paused) external onlyOwner {
474         rebasePaused = paused;
475         emit LogRebasePaused(paused);
476     }
477 
478     /**
479      * @dev Pauses or unpauses execution of ERC-20 transactions.
480      * @param paused Pauses ERC-20 transactions if this is true.
481      */
482     function setTokenPaused(bool paused) external onlyOwner {
483         tokenPaused = paused;
484         emit LogTokenPaused(paused);
485     }
486 
487     /**
488      * @dev Notifies Fragments contract about a new rebase cycle.
489      * @param supplyDelta The number of new fragment tokens to add into circulation via expansion.
490      * @return The total number of fragments after the supply adjustment.
491      */
492     function rebase(uint256 epoch, int256 supplyDelta)
493         external
494         onlyMonetaryPolicy
495         whenRebaseNotPaused
496         returns (uint256)
497     {
498         if (supplyDelta == 0) {
499             emit LogRebase(epoch, _totalSupply);
500             return _totalSupply;
501         }
502 
503         if (supplyDelta < 0) {
504             _totalSupply = _totalSupply.sub(uint256(supplyDelta.abs()));
505         } else {
506             _totalSupply = _totalSupply.add(uint256(supplyDelta));
507         }
508 
509         if (_totalSupply > MAX_SUPPLY) {
510             _totalSupply = MAX_SUPPLY;
511         }
512 
513         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
514 
515         // From this point forward, _gonsPerFragment is taken as the source of truth.
516         // We recalculate a new _totalSupply to be in agreement with the _gonsPerFragment
517         // conversion rate.
518         // This means our applied supplyDelta can deviate from the requested supplyDelta,
519         // but this deviation is guaranteed to be < (_totalSupply^2)/(TOTAL_GONS - _totalSupply).
520         //
521         // In the case of _totalSupply <= MAX_UINT128 (our current supply cap), this
522         // deviation is guaranteed to be < 1, so we can omit this step. If the supply cap is
523         // ever increased, it must be re-included.
524         // _totalSupply = TOTAL_GONS.div(_gonsPerFragment)
525 
526         emit LogRebase(epoch, _totalSupply);
527         return _totalSupply;
528     }
529 
530     function initialize(address owner_) public initializer {
531         ERC20Detailed.initialize("DotBased", "xDOT", uint8(DECIMALS));
532         Ownable.initialize(owner_);
533 
534         rebasePaused = false;
535         tokenPaused = false;
536 
537         _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
538         _gonBalances[owner_] = TOTAL_GONS;
539         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
540 
541         emit Transfer(address(0x0), owner_, _totalSupply);
542     }
543 
544     /**
545      * @return The total number of fragments.
546      */
547     function totalSupply() public view returns (uint256) {
548         return _totalSupply;
549     }
550 
551     /**
552      * @param who The address to query.
553      * @return The balance of the specified address.
554      */
555     function balanceOf(address who) public view returns (uint256) {
556         return _gonBalances[who].div(_gonsPerFragment);
557     }
558 
559     /**
560      * @dev Transfer tokens to a specified address.
561      * @param to The address to transfer to.
562      * @param value The amount to be transferred.
563      * @return True on success, false otherwise.
564      */
565     function transfer(address to, uint256 value)
566         public
567         validRecipient(to)
568         whenTokenNotPaused
569         returns (bool)
570     {
571         uint256 gonValue = value.mul(_gonsPerFragment);
572         _gonBalances[msg.sender] = _gonBalances[msg.sender].sub(gonValue);
573         _gonBalances[to] = _gonBalances[to].add(gonValue);
574         emit Transfer(msg.sender, to, value);
575         return true;
576     }
577 
578     /**
579      * @dev Function to check the amount of tokens that an owner has allowed to a spender.
580      * @param owner_ The address which owns the funds.
581      * @param spender The address which will spend the funds.
582      * @return The number of tokens still available for the spender.
583      */
584     function allowance(address owner_, address spender)
585         public
586         view
587         returns (uint256)
588     {
589         return _allowedFragments[owner_][spender];
590     }
591 
592     /**
593      * @dev Transfer tokens from one address to another.
594      * @param from The address you want to send tokens from.
595      * @param to The address you want to transfer to.
596      * @param value The amount of tokens to be transferred.
597      */
598     function transferFrom(
599         address from,
600         address to,
601         uint256 value
602     ) public validRecipient(to) whenTokenNotPaused returns (bool) {
603         _allowedFragments[from][msg.sender] = _allowedFragments[from][msg
604             .sender]
605             .sub(value);
606 
607         uint256 gonValue = value.mul(_gonsPerFragment);
608         _gonBalances[from] = _gonBalances[from].sub(gonValue);
609         _gonBalances[to] = _gonBalances[to].add(gonValue);
610         emit Transfer(from, to, value);
611 
612         return true;
613     }
614 
615     /**
616      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
617      * msg.sender. This method is included for ERC20 compatibility.
618      * increaseAllowance and decreaseAllowance should be used instead.
619      * Changing an allowance with this method brings the risk that someone may transfer both
620      * the old and the new allowance - if they are both greater than zero - if a transfer
621      * transaction is mined before the later approve() call is mined.
622      *
623      * @param spender The address which will spend the funds.
624      * @param value The amount of tokens to be spent.
625      */
626     function approve(address spender, uint256 value)
627         public
628         whenTokenNotPaused
629         returns (bool)
630     {
631         _allowedFragments[msg.sender][spender] = value;
632         emit Approval(msg.sender, spender, value);
633         return true;
634     }
635 
636     /**
637      * @dev Increase the amount of tokens that an owner has allowed to a spender.
638      * This method should be used instead of approve() to avoid the double approval vulnerability
639      * described above.
640      * @param spender The address which will spend the funds.
641      * @param addedValue The amount of tokens to increase the allowance by.
642      */
643     function increaseAllowance(address spender, uint256 addedValue)
644         public
645         whenTokenNotPaused
646         returns (bool)
647     {
648         _allowedFragments[msg.sender][spender] = _allowedFragments[msg
649             .sender][spender]
650             .add(addedValue);
651         emit Approval(
652             msg.sender,
653             spender,
654             _allowedFragments[msg.sender][spender]
655         );
656         return true;
657     }
658 
659     /**
660      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
661      *
662      * @param spender The address which will spend the funds.
663      * @param subtractedValue The amount of tokens to decrease the allowance by.
664      */
665     function decreaseAllowance(address spender, uint256 subtractedValue)
666         public
667         whenTokenNotPaused
668         returns (bool)
669     {
670         uint256 oldValue = _allowedFragments[msg.sender][spender];
671         if (subtractedValue >= oldValue) {
672             _allowedFragments[msg.sender][spender] = 0;
673         } else {
674             _allowedFragments[msg.sender][spender] = oldValue.sub(
675                 subtractedValue
676             );
677         }
678         emit Approval(
679             msg.sender,
680             spender,
681             _allowedFragments[msg.sender][spender]
682         );
683         return true;
684     }
685 }