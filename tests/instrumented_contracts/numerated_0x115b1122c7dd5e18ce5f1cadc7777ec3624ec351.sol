1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 /**
4  * @title FixidityLib
5  * @author Gadi Guy, Alberto Cuesta Canada
6  * @notice This library provides fixed point arithmetic with protection against
7  * overflow. 
8  * All operations are done with int256 and the operands must have been created 
9  * with any of the newFrom* functions, which shift the comma digits() to the 
10  * right and check for limits.
11  * When using this library be sure of using maxNewFixed() as the upper limit for
12  * creation of fixed point numbers. Use maxFixedMul(), maxFixedDiv() and
13  * maxFixedAdd() if you want to be certain that those operations don't 
14  * overflow.
15  */
16 library FixidityLib {
17 
18     /**
19      * @notice Number of positions that the comma is shifted to the right.
20      */
21     function digits() internal pure returns(uint8) {
22         return 24;
23     }
24     
25     /**
26      * @notice This is 1 in the fixed point units used in this library.
27      * @dev Test fixed1() equals 10^digits()
28      * Hardcoded to 24 digits.
29      */
30     function fixed1() internal pure returns(int256) {
31         return 1000000000000000000000000;
32     }
33 
34     /**
35      * @notice The amount of decimals lost on each multiplication operand.
36      * @dev Test mulPrecision() equals sqrt(fixed1)
37      * Hardcoded to 24 digits.
38      */
39     function mulPrecision() internal pure returns(int256) {
40         return 1000000000000;
41     }
42 
43     /**
44      * @notice Maximum value that can be represented in an int256
45      * @dev Test maxInt256() equals 2^255 -1
46      */
47     function maxInt256() internal pure returns(int256) {
48         return 57896044618658097711785492504343953926634992332820282019728792003956564819967;
49     }
50 
51     /**
52      * @notice Minimum value that can be represented in an int256
53      * @dev Test minInt256 equals (2^255) * (-1)
54      */
55     function minInt256() internal pure returns(int256) {
56         return -57896044618658097711785492504343953926634992332820282019728792003956564819968;
57     }
58 
59     /**
60      * @notice Maximum value that can be converted to fixed point. Optimize for
61      * @dev deployment. 
62      * Test maxNewFixed() equals maxInt256() / fixed1()
63      * Hardcoded to 24 digits.
64      */
65     function maxNewFixed() internal pure returns(int256) {
66         return 57896044618658097711785492504343953926634992332820282;
67     }
68 
69     /**
70      * @notice Maximum value that can be converted to fixed point. Optimize for
71      * deployment. 
72      * @dev Test minNewFixed() equals -(maxInt256()) / fixed1()
73      * Hardcoded to 24 digits.
74      */
75     function minNewFixed() internal pure returns(int256) {
76         return -57896044618658097711785492504343953926634992332820282;
77     }
78 
79     /**
80      * @notice Maximum value that can be safely used as an addition operator.
81      * @dev Test maxFixedAdd() equals maxInt256()-1 / 2
82      * Test add(maxFixedAdd(),maxFixedAdd()) equals maxFixedAdd() + maxFixedAdd()
83      * Test add(maxFixedAdd()+1,maxFixedAdd()) throws 
84      * Test add(-maxFixedAdd(),-maxFixedAdd()) equals -maxFixedAdd() - maxFixedAdd()
85      * Test add(-maxFixedAdd(),-maxFixedAdd()-1) throws 
86      */
87     function maxFixedAdd() internal pure returns(int256) {
88         return 28948022309329048855892746252171976963317496166410141009864396001978282409983;
89     }
90 
91     /**
92      * @notice Maximum negative value that can be safely in a subtraction.
93      * @dev Test maxFixedSub() equals minInt256() / 2
94      */
95     function maxFixedSub() internal pure returns(int256) {
96         return -28948022309329048855892746252171976963317496166410141009864396001978282409984;
97     }
98 
99     /**
100      * @notice Maximum value that can be safely used as a multiplication operator.
101      * @dev Calculated as sqrt(maxInt256()*fixed1()). 
102      * Be careful with your sqrt() implementation. I couldn't find a calculator
103      * that would give the exact square root of maxInt256*fixed1 so this number
104      * is below the real number by no more than 3*10**28. It is safe to use as
105      * a limit for your multiplications, although powers of two of numbers over
106      * this value might still work.
107      * Test multiply(maxFixedMul(),maxFixedMul()) equals maxFixedMul() * maxFixedMul()
108      * Test multiply(maxFixedMul(),maxFixedMul()+1) throws 
109      * Test multiply(-maxFixedMul(),maxFixedMul()) equals -maxFixedMul() * maxFixedMul()
110      * Test multiply(-maxFixedMul(),maxFixedMul()+1) throws 
111      * Hardcoded to 24 digits.
112      */
113     function maxFixedMul() internal pure returns(int256) {
114         return 240615969168004498257251713877715648331380787511296;
115     }
116 
117     /**
118      * @notice Maximum value that can be safely used as a dividend.
119      * @dev divide(maxFixedDiv,newFixedFraction(1,fixed1())) = maxInt256().
120      * Test maxFixedDiv() equals maxInt256()/fixed1()
121      * Test divide(maxFixedDiv(),multiply(mulPrecision(),mulPrecision())) = maxFixedDiv()*(10^digits())
122      * Test divide(maxFixedDiv()+1,multiply(mulPrecision(),mulPrecision())) throws
123      * Hardcoded to 24 digits.
124      */
125     function maxFixedDiv() internal pure returns(int256) {
126         return 57896044618658097711785492504343953926634992332820282;
127     }
128 
129     /**
130      * @notice Maximum value that can be safely used as a divisor.
131      * @dev Test maxFixedDivisor() equals fixed1()*fixed1() - Or 10**(digits()*2)
132      * Test divide(10**(digits()*2 + 1),10**(digits()*2)) = returns 10*fixed1()
133      * Test divide(10**(digits()*2 + 1),10**(digits()*2 + 1)) = throws
134      * Hardcoded to 24 digits.
135      */
136     function maxFixedDivisor() internal pure returns(int256) {
137         return 1000000000000000000000000000000000000000000000000;
138     }
139 
140     /**
141      * @notice Converts an int256 to fixed point units, equivalent to multiplying
142      * by 10^digits().
143      * @dev Test newFixed(0) returns 0
144      * Test newFixed(1) returns fixed1()
145      * Test newFixed(maxNewFixed()) returns maxNewFixed() * fixed1()
146      * Test newFixed(maxNewFixed()+1) fails
147      */
148     function newFixed(int256 x)
149         internal
150         pure
151         returns (int256)
152     {
153         assert(x <= maxNewFixed());
154         assert(x >= minNewFixed());
155         return x * fixed1();
156     }
157 
158     /**
159      * @notice Converts an int256 in the fixed point representation of this 
160      * library to a non decimal. All decimal digits will be truncated.
161      */
162     function fromFixed(int256 x)
163         internal
164         pure
165         returns (int256)
166     {
167         return x / fixed1();
168     }
169 
170     /**
171      * @notice Converts an int256 which is already in some fixed point 
172      * representation to a different fixed precision representation.
173      * Both the origin and destination precisions must be 38 or less digits.
174      * Origin values with a precision higher than the destination precision
175      * will be truncated accordingly.
176      * @dev 
177      * Test convertFixed(1,0,0) returns 1;
178      * Test convertFixed(1,1,1) returns 1;
179      * Test convertFixed(1,1,0) returns 0;
180      * Test convertFixed(1,0,1) returns 10;
181      * Test convertFixed(10,1,0) returns 1;
182      * Test convertFixed(10,0,1) returns 100;
183      * Test convertFixed(100,1,0) returns 10;
184      * Test convertFixed(100,0,1) returns 1000;
185      * Test convertFixed(1000,2,0) returns 10;
186      * Test convertFixed(1000,0,2) returns 100000;
187      * Test convertFixed(1000,2,1) returns 100;
188      * Test convertFixed(1000,1,2) returns 10000;
189      * Test convertFixed(maxInt256,1,0) returns maxInt256/10;
190      * Test convertFixed(maxInt256,0,1) throws
191      * Test convertFixed(maxInt256,38,0) returns maxInt256/(10**38);
192      * Test convertFixed(1,0,38) returns 10**38;
193      * Test convertFixed(maxInt256,39,0) throws
194      * Test convertFixed(1,0,39) throws
195      */
196     function convertFixed(int256 x, uint8 _originDigits, uint8 _destinationDigits)
197         internal
198         pure
199         returns (int256)
200     {
201         assert(_originDigits <= 38 && _destinationDigits <= 38);
202         
203         uint8 decimalDifference;
204         if ( _originDigits > _destinationDigits ){
205             decimalDifference = _originDigits - _destinationDigits;
206             return x/int256((uint128(10)**uint128(decimalDifference)));
207         }
208         else if ( _originDigits < _destinationDigits ){
209             decimalDifference = _destinationDigits - _originDigits;
210             // Cast uint8 -> uint128 is safe
211             // Exponentiation is safe:
212             //     _originDigits and _destinationDigits limited to 38 or less
213             //     decimalDifference = abs(_destinationDigits - _originDigits)
214             //     decimalDifference < 38
215             //     10**38 < 2**128-1
216             assert(x <= maxInt256()/int256(uint128(10)**uint128(decimalDifference)));
217             assert(x >= minInt256()/int256(uint128(10)**uint128(decimalDifference)));
218             return x*(int256(uint128(10)**uint128(decimalDifference)));
219         }
220         // _originDigits == digits()) 
221         return x;
222     }
223 
224     /**
225      * @notice Converts an int256 which is already in some fixed point 
226      * representation to that of this library. The _originDigits parameter is the
227      * precision of x. Values with a precision higher than FixidityLib.digits()
228      * will be truncated accordingly.
229      */
230     function newFixed(int256 x, uint8 _originDigits)
231         internal
232         pure
233         returns (int256)
234     {
235         return convertFixed(x, _originDigits, digits());
236     }
237 
238     /**
239      * @notice Converts an int256 in the fixed point representation of this 
240      * library to a different representation. The _destinationDigits parameter is the
241      * precision of the output x. Values with a precision below than 
242      * FixidityLib.digits() will be truncated accordingly.
243      */
244     function fromFixed(int256 x, uint8 _destinationDigits)
245         internal
246         pure
247         returns (int256)
248     {
249         return convertFixed(x, digits(), _destinationDigits);
250     }
251 
252     /**
253      * @notice Converts two int256 representing a fraction to fixed point units,
254      * equivalent to multiplying dividend and divisor by 10^digits().
255      * @dev 
256      * Test newFixedFraction(maxFixedDiv()+1,1) fails
257      * Test newFixedFraction(1,maxFixedDiv()+1) fails
258      * Test newFixedFraction(1,0) fails     
259      * Test newFixedFraction(0,1) returns 0
260      * Test newFixedFraction(1,1) returns fixed1()
261      * Test newFixedFraction(maxFixedDiv(),1) returns maxFixedDiv()*fixed1()
262      * Test newFixedFraction(1,fixed1()) returns 1
263      * Test newFixedFraction(1,fixed1()-1) returns 0
264      */
265     function newFixedFraction(
266         int256 numerator, 
267         int256 denominator
268         )
269         internal
270         pure
271         returns (int256)
272     {
273         assert(numerator <= maxNewFixed());
274         assert(denominator <= maxNewFixed());
275         assert(denominator != 0);
276         int256 convertedNumerator = newFixed(numerator);
277         int256 convertedDenominator = newFixed(denominator);
278         return divide(convertedNumerator, convertedDenominator);
279     }
280 
281     /**
282      * @notice Returns the integer part of a fixed point number.
283      * @dev 
284      * Test integer(0) returns 0
285      * Test integer(fixed1()) returns fixed1()
286      * Test integer(newFixed(maxNewFixed())) returns maxNewFixed()*fixed1()
287      * Test integer(-fixed1()) returns -fixed1()
288      * Test integer(newFixed(-maxNewFixed())) returns -maxNewFixed()*fixed1()
289      */
290     function integer(int256 x) internal pure returns (int256) {
291         return (x / fixed1()) * fixed1(); // Can't overflow
292     }
293 
294     /**
295      * @notice Returns the fractional part of a fixed point number. 
296      * In the case of a negative number the fractional is also negative.
297      * @dev 
298      * Test fractional(0) returns 0
299      * Test fractional(fixed1()) returns 0
300      * Test fractional(fixed1()-1) returns 10^24-1
301      * Test fractional(-fixed1()) returns 0
302      * Test fractional(-fixed1()+1) returns -10^24-1
303      */
304     function fractional(int256 x) internal pure returns (int256) {
305         return x - (x / fixed1()) * fixed1(); // Can't overflow
306     }
307 
308     /**
309      * @notice Converts to positive if negative.
310      * Due to int256 having one more negative number than positive numbers 
311      * abs(minInt256) reverts.
312      * @dev 
313      * Test abs(0) returns 0
314      * Test abs(fixed1()) returns -fixed1()
315      * Test abs(-fixed1()) returns fixed1()
316      * Test abs(newFixed(maxNewFixed())) returns maxNewFixed()*fixed1()
317      * Test abs(newFixed(minNewFixed())) returns -minNewFixed()*fixed1()
318      */
319     function abs(int256 x) internal pure returns (int256) {
320         if (x >= 0) {
321             return x;
322         } else {
323             int256 result = -x;
324             assert (result > 0);
325             return result;
326         }
327     }
328 
329     /**
330      * @notice x+y. If any operator is higher than maxFixedAdd() it 
331      * might overflow.
332      * In solidity maxInt256 + 1 = minInt256 and viceversa.
333      * @dev 
334      * Test add(maxFixedAdd(),maxFixedAdd()) returns maxInt256()-1
335      * Test add(maxFixedAdd()+1,maxFixedAdd()+1) fails
336      * Test add(-maxFixedSub(),-maxFixedSub()) returns minInt256()
337      * Test add(-maxFixedSub()-1,-maxFixedSub()-1) fails
338      * Test add(maxInt256(),maxInt256()) fails
339      * Test add(minInt256(),minInt256()) fails
340      */
341     function add(int256 x, int256 y) internal pure returns (int256) {
342         int256 z = x + y;
343         if (x > 0 && y > 0) assert(z > x && z > y);
344         if (x < 0 && y < 0) assert(z < x && z < y);
345         return z;
346     }
347 
348     /**
349      * @notice x-y. You can use add(x,-y) instead. 
350      * @dev Tests covered by add(x,y)
351      */
352     function subtract(int256 x, int256 y) internal pure returns (int256) {
353         return add(x,-y);
354     }
355 
356     /**
357      * @notice x*y. If any of the operators is higher than maxFixedMul() it 
358      * might overflow.
359      * @dev 
360      * Test multiply(0,0) returns 0
361      * Test multiply(maxFixedMul(),0) returns 0
362      * Test multiply(0,maxFixedMul()) returns 0
363      * Test multiply(maxFixedMul(),fixed1()) returns maxFixedMul()
364      * Test multiply(fixed1(),maxFixedMul()) returns maxFixedMul()
365      * Test all combinations of (2,-2), (2, 2.5), (2, -2.5) and (0.5, -0.5)
366      * Test multiply(fixed1()/mulPrecision(),fixed1()*mulPrecision())
367      * Test multiply(maxFixedMul()-1,maxFixedMul()) equals multiply(maxFixedMul(),maxFixedMul()-1)
368      * Test multiply(maxFixedMul(),maxFixedMul()) returns maxInt256() // Probably not to the last digits
369      * Test multiply(maxFixedMul()+1,maxFixedMul()) fails
370      * Test multiply(maxFixedMul(),maxFixedMul()+1) fails
371      */
372     function multiply(int256 x, int256 y) internal pure returns (int256) {
373         if (x == 0 || y == 0) return 0;
374         if (y == fixed1()) return x;
375         if (x == fixed1()) return y;
376 
377         // Separate into integer and fractional parts
378         // x = x1 + x2, y = y1 + y2
379         int256 x1 = integer(x) / fixed1();
380         int256 x2 = fractional(x);
381         int256 y1 = integer(y) / fixed1();
382         int256 y2 = fractional(y);
383         
384         // (x1 + x2) * (y1 + y2) = (x1 * y1) + (x1 * y2) + (x2 * y1) + (x2 * y2)
385         int256 x1y1 = x1 * y1;
386         if (x1 != 0) assert(x1y1 / x1 == y1); // Overflow x1y1
387         
388         // x1y1 needs to be multiplied back by fixed1
389         // solium-disable-next-line mixedcase
390         int256 fixed_x1y1 = x1y1 * fixed1();
391         if (x1y1 != 0) assert(fixed_x1y1 / x1y1 == fixed1()); // Overflow x1y1 * fixed1
392         x1y1 = fixed_x1y1;
393 
394         int256 x2y1 = x2 * y1;
395         if (x2 != 0) assert(x2y1 / x2 == y1); // Overflow x2y1
396 
397         int256 x1y2 = x1 * y2;
398         if (x1 != 0) assert(x1y2 / x1 == y2); // Overflow x1y2
399 
400         x2 = x2 / mulPrecision();
401         y2 = y2 / mulPrecision();
402         int256 x2y2 = x2 * y2;
403         if (x2 != 0) assert(x2y2 / x2 == y2); // Overflow x2y2
404 
405         // result = fixed1() * x1 * y1 + x1 * y2 + x2 * y1 + x2 * y2 / fixed1();
406         int256 result = x1y1;
407         result = add(result, x2y1); // Add checks for overflow
408         result = add(result, x1y2); // Add checks for overflow
409         result = add(result, x2y2); // Add checks for overflow
410         return result;
411     }
412     
413     /**
414      * @notice 1/x
415      * @dev 
416      * Test reciprocal(0) fails
417      * Test reciprocal(fixed1()) returns fixed1()
418      * Test reciprocal(fixed1()*fixed1()) returns 1 // Testing how the fractional is truncated
419      * Test reciprocal(2*fixed1()*fixed1()) returns 0 // Testing how the fractional is truncated
420      */
421     function reciprocal(int256 x) internal pure returns (int256) {
422         assert(x != 0);
423         return (fixed1()*fixed1()) / x; // Can't overflow
424     }
425 
426     /**
427      * @notice x/y. If the dividend is higher than maxFixedDiv() it 
428      * might overflow. You can use multiply(x,reciprocal(y)) instead.
429      * There is a loss of precision on division for the lower mulPrecision() decimals.
430      * @dev 
431      * Test divide(fixed1(),0) fails
432      * Test divide(maxFixedDiv(),1) = maxFixedDiv()*(10^digits())
433      * Test divide(maxFixedDiv()+1,1) throws
434      * Test divide(maxFixedDiv(),maxFixedDiv()) returns fixed1()
435      */
436     function divide(int256 x, int256 y) internal pure returns (int256) {
437         if (y == fixed1()) return x;
438         assert(y != 0);
439         assert(y <= maxFixedDivisor());
440         return multiply(x, reciprocal(y));
441     }
442 }
443 
444 /*
445  * @dev Provides information about the current execution context, including the
446  * sender of the transaction and its data. While these are generally available
447  * via msg.sender and msg.data, they should not be accessed in such a direct
448  * manner, since when dealing with meta-transactions the account sending and
449  * paying for execution may not be the actual sender (as far as an application
450  * is concerned).
451  *
452  * This contract is only required for intermediate, library-like contracts.
453  */
454 abstract contract Context {
455     function _msgSender() internal view virtual returns (address) {
456         return msg.sender;
457     }
458 
459     function _msgData() internal view virtual returns (bytes calldata) {
460         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
461         return msg.data;
462     }
463 }
464 /**
465  * @dev Interface of the ERC20 standard as defined in the EIP.
466  */
467 interface IERC20 {
468     /**
469      * @dev Returns the amount of tokens in existence.
470      */
471     function totalSupply() external view returns (uint256);
472 
473     /**
474      * @dev Returns the amount of tokens owned by `account`.
475      */
476     function balanceOf(address account) external view returns (uint256);
477 
478     /**
479      * @dev Moves `amount` tokens from the caller's account to `recipient`.
480      *
481      * Returns a boolean value indicating whether the operation succeeded.
482      *
483      * Emits a {Transfer} event.
484      */
485     function transfer(address recipient, uint256 amount) external returns (bool);
486 
487     /**
488      * @dev Returns the remaining number of tokens that `spender` will be
489      * allowed to spend on behalf of `owner` through {transferFrom}. This is
490      * zero by default.
491      *
492      * This value changes when {approve} or {transferFrom} are called.
493      */
494     function allowance(address owner, address spender) external view returns (uint256);
495 
496     /**
497      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
498      *
499      * Returns a boolean value indicating whether the operation succeeded.
500      *
501      * IMPORTANT: Beware that changing an allowance with this method brings the risk
502      * that someone may use both the old and the new allowance by unfortunate
503      * transaction ordering. One possible solution to mitigate this race
504      * condition is to first reduce the spender's allowance to 0 and set the
505      * desired value afterwards:
506      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
507      *
508      * Emits an {Approval} event.
509      */
510     function approve(address spender, uint256 amount) external returns (bool);
511 
512     /**
513      * @dev Moves `amount` tokens from `sender` to `recipient` using the
514      * allowance mechanism. `amount` is then deducted from the caller's
515      * allowance.
516      *
517      * Returns a boolean value indicating whether the operation succeeded.
518      *
519      * Emits a {Transfer} event.
520      */
521     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
522 
523     /**
524      * @dev Emitted when `value` tokens are moved from one account (`from`) to
525      * another (`to`).
526      *
527      * Note that `value` may be zero.
528      */
529     event Transfer(address indexed from, address indexed to, uint256 value);
530 
531     /**
532      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
533      * a call to {approve}. `value` is the new allowance.
534      */
535     event Approval(address indexed owner, address indexed spender, uint256 value);
536 }
537 
538 interface IFuelTank {
539   function openNozzle() external;
540   function addTokens(address user, uint amount) external;
541 }
542 
543 contract MeowDAO is IERC20, Context {
544   using FixidityLib for int256;
545 
546   uint256 _totalSupply = 0;
547   string private _name;
548   string private _symbol;
549 
550   uint8 private _decimals = 13;
551   uint private _contractStart;
552 
553   address public grumpyAddress;
554   address public grumpyFuelTankAddress;
555   uint public swapEndTime;
556 
557   bool public launched = false;
558 
559   uint256 public totalStartingSupply = 10**10 * 10**13; //10_000_000_000.0_000_000_000_000 10 billion MEOWS. 10^23
560 
561   mapping (address => uint256) private _balances;
562   mapping (address => mapping (address => uint256)) private _allowances;
563 
564   mapping (address => uint) public periodStart;
565   mapping (address => bool) public currentlyStaked;
566   mapping (address => uint) public unlockStartTime;
567   mapping (address => address) public currentVotes;
568   mapping (address => uint256) public voteWeights;
569 
570   mapping (address => uint256) public stakingCoordinatesTime;
571   mapping (address => uint256) public stakingCoordinatesAmount;
572 
573   mapping(address => uint256) public voteCounts;
574   address[] public voteIterator;
575   mapping(address => bool) public walletWasVotedFor;
576   address public currentCharityWallet;
577 
578   constructor(address _grumpyAddress, address _grumpyFuelTankAddress, string memory __name, string memory __symbol) {
579     _name = __name;
580     _symbol = __symbol;
581 
582     _contractStart = block.timestamp;
583 
584     grumpyAddress = _grumpyAddress;
585     grumpyFuelTankAddress = _grumpyFuelTankAddress;
586 
587     swapEndTime = block.timestamp + (86400 * 5);
588   }
589 
590   function _swapGrumpyInternal(address user, uint256 amount) private {
591     require(block.timestamp < swapEndTime);
592     require(!isStaked(user), "cannot swap into staked wallet");
593     
594     IERC20(grumpyAddress).transferFrom(user, grumpyFuelTankAddress, amount);
595     IFuelTank(grumpyFuelTankAddress).addTokens(user, amount);
596 
597     _balances[user] += amount;
598 
599     _totalSupply += amount;
600 
601     emit Transfer(address(0), user, amount);
602   }
603 
604   function swapGrumpy(uint256 amount) public {
605     _swapGrumpyInternal(_msgSender(), amount);
606   }
607 
608   function initializeCoinThruster() external {
609     require(block.timestamp >= swapEndTime, "NotReady");
610     require(launched == false, "AlreadyLaunched");
611 
612     IFuelTank(grumpyFuelTankAddress).openNozzle();
613 
614     if (totalStartingSupply > _totalSupply) {
615       uint256 remainingTokens = totalStartingSupply - _totalSupply;
616 
617       _balances[grumpyFuelTankAddress] = _balances[grumpyFuelTankAddress] + remainingTokens;
618       _totalSupply += remainingTokens;
619 
620       emit Transfer(address(0), grumpyFuelTankAddress, remainingTokens);
621     }
622 
623     launched = true;
624   }
625 
626   function getBlockTime() public view returns (uint) {
627     return block.timestamp;
628   }
629 
630   function isStaked(address wallet) public view returns (bool) {
631     return currentlyStaked[wallet];
632   }
633 
634   function isUnlocked(address wallet) private returns (bool) {
635     uint unlockStarted = unlockStartTime[wallet];
636 
637     if (unlockStarted == 0) return true;
638 
639     uint unlockedAt = unlockStarted + (86400 * 5);
640 
641     if (block.timestamp > unlockedAt) {
642       unlockStartTime[wallet] = 0;
643       return true;
644     }
645     else return false;
646   }
647 
648   function _stakeWalletFor(address sender) private returns (bool) {
649     require(!isStaked(sender));
650     require(enoughFundsToStake(sender), "InsfcntFnds");
651     require(isUnlocked(sender), "WalletIsLocked");
652 
653     currentlyStaked[sender] = true;
654     unlockStartTime[sender] = 0;
655     currentVotes[sender] = address(0);
656     periodStart[sender] = block.timestamp;
657 
658     stakingCoordinatesTime[sender] = block.timestamp;
659     stakingCoordinatesAmount[sender] = _balances[sender];
660 
661     return true;
662   }
663 
664   function stakeWallet() public returns (bool) {
665     return _stakeWalletFor(_msgSender());
666   }
667 
668   function _unstakeWalletFor(address sender, bool shouldReify) private {
669     require(isStaked(sender));
670 
671     if (shouldReify) reifyYield(sender);
672 
673     if (voteWeights[sender] != 0) {
674       removeVoteWeight(sender);
675       updateCharityWallet();
676     }
677 
678     currentlyStaked[sender] = false;
679     currentVotes[sender] = address(0);
680     voteWeights[sender] = 0;
681     periodStart[sender] = 0;
682 
683     stakingCoordinatesTime[sender] = 0;
684     stakingCoordinatesAmount[sender] = 0;
685 
686     unlockStartTime[sender] = block.timestamp;
687   } 
688 
689   function unstakeWallet() public {
690     _unstakeWalletFor(_msgSender(), true);
691   }
692 
693   function unstakeWalletSansReify() public {
694     _unstakeWalletFor(_msgSender(), false);
695   }
696 
697   function voteIteratorLength() external view returns (uint) {
698     return voteIterator.length;
699   }
700 
701   function voteWithRebuildIfNecessary(address charityWalletVote) public {
702     if (voteIterator.length == 12 && !walletWasVotedFor[charityWalletVote]) {
703       rebuildVotingIterator();
704     }
705     _voteForAddressBy(charityWalletVote, _msgSender());
706   }
707 
708   function rebuildVotingIterator() public {
709     require(voteIterator.length == 12, "Voting Iterator not full");
710 
711     address[12] memory voteCopy;
712     for (uint i = 0; i < 12; i++) {
713       voteCopy[i] = voteIterator[i];
714     }
715 
716     //insertion sort copy
717     for (uint i = 1; i < 12; i++)
718     {
719       address keyAddress = voteCopy[i];
720       uint key = voteCounts[keyAddress];
721 
722       uint j = i - 1;
723 
724       bool broke = false;
725       while (j >= 0 && voteCounts[voteCopy[j]] < key) {
726         voteCopy[j + 1] = voteCopy[j];
727 
728         if (j == 0) {
729           broke = true;
730           break;
731         }
732         else j--;
733       }
734 
735       if (broke) voteCopy[0] = keyAddress;
736       else voteCopy[j + 1] = keyAddress;
737     }
738 
739     for (uint i = 11; i >= 6; i--) {
740       address vote = voteCopy[i];
741       walletWasVotedFor[vote] = false;
742     }
743 
744     delete voteIterator;
745     for (uint i = 0; i < 6; i++) {
746       voteIterator.push(voteCopy[i]);
747     }
748 
749   }
750 
751   function _voteForAddressBy(address charityWalletVote, address sender) private {
752     require(isStaked(sender));
753 
754     trackCandidate(charityWalletVote);
755 
756     removeVoteWeight(sender);
757     setVoteWeight(sender);
758     addVoteWeight(sender, charityWalletVote);
759     updateCharityWallet();
760   }
761 
762   function trackCandidate(address charityWalletCandidate) private {
763     // If wallet was never voted for before add it to voteIterator
764     if (!walletWasVotedFor[charityWalletCandidate]) {
765       require(voteIterator.length < 12, "Vote Iterator must be rebuilt");
766 
767       voteIterator.push(charityWalletCandidate);
768       walletWasVotedFor[charityWalletCandidate] = true;
769     }
770   }
771 
772   function removeVoteWeight(address sender) private {
773     address vote = currentVotes[sender];
774     voteCounts[vote] = voteCounts[vote] - voteWeights[sender];
775   }
776 
777   function setVoteWeight(address sender) private {
778     uint256 newVoteWeight = _balances[sender];
779     voteWeights[sender] = newVoteWeight;
780   }
781 
782   function addVoteWeight(address sender, address charityWalletVote) private {
783     voteCounts[charityWalletVote] = voteCounts[charityWalletVote] + voteWeights[sender];
784     currentVotes[sender] = charityWalletVote;
785   }
786 
787   function voteForAddress(address charityWalletVote) public {
788     _voteForAddressBy(charityWalletVote, _msgSender());
789   }
790 
791   event NewCharityWallet(address oldW, address newW);
792 
793   function updateCharityWallet() private {
794     uint256 maxVoteValue = 0; 
795     address winner = address(0);
796 
797     for (uint i = 0; i < voteIterator.length; i++) {
798       address currentWallet = voteIterator[i];
799       uint256 voteValue = voteCounts[currentWallet];
800 
801       if (voteValue > maxVoteValue) {
802         maxVoteValue = voteValue;
803         winner = currentWallet;
804       }
805     }
806 
807     if (currentCharityWallet == winner) return;
808 
809     emit NewCharityWallet(currentCharityWallet, winner);
810 
811     currentCharityWallet = winner;
812   }
813 
814   function validCharityWallet() internal view returns (bool) {
815     return currentCharityWallet != address(0) && !isStaked(currentCharityWallet);
816   }
817 
818   function getCompoundingFactor(address wallet) private view returns (uint) {
819     return block.timestamp - periodStart[wallet];
820   }
821 
822   function calculateYield(uint256 principal, uint n) public pure returns (uint256) {
823     int256 fixedPrincipal = int256(principal).newFixed();
824 
825     int256 rate = int256(2144017221509).newFixedFraction(1000000000000000000000);
826     int256 fixed2 = int256(2).newFixed();
827 
828     while (n > 0) {
829       if (n % 2 == 1) {
830         fixedPrincipal = fixedPrincipal.add(fixedPrincipal.multiply(rate));
831         n -= 1;
832       }
833       else {
834         rate = (fixed2.multiply(rate))
835           .add(rate.multiply(rate));
836         n /= 2;
837       }
838     }
839     return uint256(fixedPrincipal.fromFixed()) - principal;
840   }
841 
842   function getTransactionFee(uint256 txAmt) private view returns (uint256){
843     uint period = block.timestamp - _contractStart;
844 
845     if (period > 31536000) return 0;
846     else if (period > 23652000) return txAmt / 400;
847     else if (period > 15768000) return txAmt / 200;
848     else if (period > 7884000) return (txAmt / 400) * 3;
849     else return txAmt / 100;
850   } 
851 
852   function reifyYield(address wallet) public {
853     require(isStaked(wallet), 'MstBeStkd');
854 
855     uint compoundingFactor = getCompoundingFactor(wallet);
856 
857     if (compoundingFactor < 60) return;
858 
859     uint256 yield = calculateYield(_balances[wallet], compoundingFactor);
860 
861     _balances[wallet] += yield;
862 
863     if (validCharityWallet()) {
864       uint256 charityYield = (yield / 7) * 3;
865       _balances[currentCharityWallet] += charityYield;
866       _totalSupply += (yield + charityYield);
867     } else {
868       _totalSupply += yield;
869     }
870 
871     periodStart[wallet] = block.timestamp;
872   }
873 
874   function enoughFundsToStake(address wallet) private view returns (bool) {
875     return _balances[wallet] >= 10000000000000000;
876   }
877 
878   function name() external view returns (string memory) {
879     return _name;
880   } 
881 
882   function symbol() external view returns (string memory) {
883     return _symbol;
884   }
885 
886   function decimals() external view returns (uint8) {
887     return _decimals;
888   }
889 
890   function contractStart() external view returns (uint) {
891     return _contractStart;
892   }
893 
894   function totalSupply() external view override returns (uint256) {
895     return _totalSupply;
896   }
897 
898   function balanceOf(address account) public view virtual override returns (uint256) {
899     uint b = _balances[account];
900 
901     if (isStaked(account) && currentCharityWallet != account) {
902       return b + calculateYield(b, getCompoundingFactor(account));
903     }
904     return b;
905   }
906 
907   function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
908     _transfer(_msgSender(), recipient, amount);
909     return true;
910   }
911 
912   function _transfer(address sender, address recipient, uint256 amount) internal virtual {
913     require(sender != address(0), "ERC20: transfer from the zero address");
914     require(recipient != address(0), "ERC20: transfer to the zero address");
915     require(!isStaked(sender), "StkdWlltCnntTrnsf");
916     require(isUnlocked(sender), "LockedWlltCnntTrnsfr");
917     require(_balances[sender] >= amount, "ERC20: transfer amount exceeds balance");
918 
919     if (isStaked(recipient)) {
920       reifyYield(recipient);
921     }
922 
923     uint sentAmount = amount; 
924 
925     if (validCharityWallet()) {
926       uint256 txFee = getTransactionFee(amount);
927 
928       if (txFee != 0) {
929         sentAmount -= txFee;
930         _balances[currentCharityWallet] += txFee;
931       }
932     }
933 
934     _balances[sender] -= amount;
935     _balances[recipient] += sentAmount;
936 
937     emit Transfer(sender, recipient, amount);
938   }
939 
940   function allowance(address owner, address spender) public view virtual override returns (uint256) {
941     return _allowances[owner][spender];
942   }
943 
944   function approve(address spender, uint256 amount) public override returns (bool) {
945     _approve(_msgSender(), spender, amount);
946     return true;
947   }
948 
949   function _approve(address owner, address spender, uint256 amount) internal virtual {
950     require(owner != address(0), "ERC20: approve from the zero address");
951     require(spender != address(0), "ERC20: approve to the zero address");
952 
953     _allowances[owner][spender] = amount;
954     emit Approval(owner, spender, amount);
955   }
956 
957   function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
958     _transfer(sender, recipient, amount);
959 
960     uint256 currentAllowance = _allowances[sender][_msgSender()];
961     require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
962     _approve(sender, _msgSender(), currentAllowance - amount);
963 
964     return true;
965   }
966 
967   function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
968     _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
969     return true;
970   }
971 
972   function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
973     uint256 currentAllowance = _allowances[_msgSender()][spender];
974     require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
975     _approve(_msgSender(), spender, currentAllowance - subtractedValue);
976     return true;
977   }
978 }