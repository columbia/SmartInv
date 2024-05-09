1 pragma solidity 0.4.24;
2 
3 /* 
4     RMPL.sol
5 
6     Elastic Supply ERC20 Token with randomized rebasing.
7     
8     Forked from Ampleforth: https://github.com/ampleforth/uFragments (Credits to Ampleforth team for implementation of rebasing on the ethereum network).
9     
10     GPL 3.0 license.
11     
12     RMPL.sol - Basic ERC20 Token with rebase functionality
13     Rebaser.sol - Handles decentralized, autonomous, random rebasing on-chain. 
14     
15     Rebaser.sol will be upgraded as the project progresses. Ownership of RMPL.sol can be changed to new versions of Rebaser.sol as they are released.
16     
17     See github for more info and latest versions: https://github.com/rmpldefiteam
18     
19     Once a final version has been agreed, owner address of RMPL.sol will be locked to ensure completely decentralised operation forever.
20     
21 */
22 
23 contract Initializable {
24 
25   bool private initialized;
26   bool private initializing;
27 
28   modifier initializer() {
29     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
30 
31     bool wasInitializing = initializing;
32     initializing = true;
33     initialized = true;
34 
35     _;
36 
37     initializing = wasInitializing;
38   }
39 
40   function isConstructor() private view returns (bool) {
41     uint256 cs;
42     assembly { cs := extcodesize(address) }
43     return cs == 0;
44   }
45 
46   uint256[50] private ______gap;
47 }
48 
49 contract Ownable is Initializable {
50 
51   address private _owner;
52   uint256 private _ownershipLocked;
53 
54   event OwnershipLocked(address lockedOwner);
55   event OwnershipRenounced(address indexed previousOwner);
56   event OwnershipTransferred(
57     address indexed previousOwner,
58     address indexed newOwner
59   );
60 
61 
62   function initialize(address sender) internal initializer {
63     _owner = sender;
64 	_ownershipLocked = 0;
65   }
66 
67   function owner() public view returns(address) {
68     return _owner;
69   }
70 
71   modifier onlyOwner() {
72     require(isOwner());
73     _;
74   }
75 
76   function isOwner() public view returns(bool) {
77     return msg.sender == _owner;
78   }
79 
80   function transferOwnership(address newOwner) public onlyOwner {
81     _transferOwnership(newOwner);
82   }
83 
84   function _transferOwnership(address newOwner) internal {
85     require(_ownershipLocked == 0);
86     require(newOwner != address(0));
87     emit OwnershipTransferred(_owner, newOwner);
88     _owner = newOwner;
89   }
90   
91   // Set _ownershipLocked flag to lock contract owner forever
92   function lockOwnership() public onlyOwner {
93 	require(_ownershipLocked == 0);
94 	emit OwnershipLocked(_owner);
95     _ownershipLocked = 1;
96   }
97 
98   uint256[50] private ______gap;
99 }
100 
101 interface IERC20 {
102   function totalSupply() external view returns (uint256);
103 
104   function balanceOf(address who) external view returns (uint256);
105 
106   function allowance(address owner, address spender)
107     external view returns (uint256);
108 
109   function transfer(address to, uint256 value) external returns (bool);
110 
111   function approve(address spender, uint256 value)
112     external returns (bool);
113 
114   function transferFrom(address from, address to, uint256 value)
115     external returns (bool);
116 
117   event Transfer(
118     address indexed from,
119     address indexed to,
120     uint256 value
121   );
122 
123   event Approval(
124     address indexed owner,
125     address indexed spender,
126     uint256 value
127   );
128 }
129 
130 contract ERC20Detailed is Initializable, IERC20 {
131   string private _name;
132   string private _symbol;
133   uint8 private _decimals;
134 
135   function initialize(string name, string symbol, uint8 decimals) internal initializer {
136     _name = name;
137     _symbol = symbol;
138     _decimals = decimals;
139   }
140 
141   function name() public view returns(string) {
142     return _name;
143   }
144 
145   function symbol() public view returns(string) {
146     return _symbol;
147   }
148 
149   function decimals() public view returns(uint8) {
150     return _decimals;
151   }
152 
153   uint256[50] private ______gap;
154 }
155 
156 library SafeMath {
157 
158     function add(uint256 a, uint256 b) internal pure returns (uint256) {
159         uint256 c = a + b;
160         require(c >= a, "SafeMath: addition overflow");
161 
162         return c;
163     }
164 
165     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
166         return sub(a, b, "SafeMath: subtraction overflow");
167     }
168 
169     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
170         require(b <= a, errorMessage);
171         uint256 c = a - b;
172 
173         return c;
174     }
175 
176     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
177         if (a == 0) {
178             return 0;
179         }
180 
181         uint256 c = a * b;
182         require(c / a == b, "SafeMath: multiplication overflow");
183 
184         return c;
185     }
186 
187     function div(uint256 a, uint256 b) internal pure returns (uint256) {
188         return div(a, b, "SafeMath: division by zero");
189     }
190 
191     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
192         require(b > 0, errorMessage);
193         uint256 c = a / b;
194 
195         return c;
196     }
197 
198     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
199         return mod(a, b, "SafeMath: modulo by zero");
200     }
201 
202     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
203         require(b != 0, errorMessage);
204         return a % b;
205     }
206 }
207 
208 /*
209 MIT License
210 
211 Copyright (c) 2018 requestnetwork
212 Copyright (c) 2018 Fragments, Inc.
213 
214 Permission is hereby granted, free of charge, to any person obtaining a copy
215 of this software and associated documentation files (the "Software"), to deal
216 in the Software without restriction, including without limitation the rights
217 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
218 copies of the Software, and to permit persons to whom the Software is
219 furnished to do so, subject to the following conditions:
220 
221 The above copyright notice and this permission notice shall be included in all
222 copies or substantial portions of the Software.
223 
224 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
225 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
226 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
227 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
228 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
229 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
230 SOFTWARE.
231 */
232 
233 library SafeMathInt {
234 
235     int256 private constant MIN_INT256 = int256(1) << 255;
236     int256 private constant MAX_INT256 = ~(int256(1) << 255);
237 
238     function mul(int256 a, int256 b)
239         internal
240         pure
241         returns (int256)
242     {
243         int256 c = a * b;
244 
245         // Detect overflow when multiplying MIN_INT256 with -1
246         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
247         require((b == 0) || (c / b == a));
248         return c;
249     }
250 
251     function div(int256 a, int256 b)
252         internal
253         pure
254         returns (int256)
255     {
256         // Prevent overflow when dividing MIN_INT256 by -1
257         require(b != -1 || a != MIN_INT256);
258 
259         // Solidity already throws when dividing by 0.
260         return a / b;
261     }
262 
263     function sub(int256 a, int256 b)
264         internal
265         pure
266         returns (int256)
267     {
268         int256 c = a - b;
269         require((b >= 0 && c <= a) || (b < 0 && c > a));
270         return c;
271     }
272 
273     function add(int256 a, int256 b)
274         internal
275         pure
276         returns (int256)
277     {
278         int256 c = a + b;
279         require((b >= 0 && c >= a) || (b < 0 && c < a));
280         return c;
281     }
282 
283     function abs(int256 a)
284         internal
285         pure
286         returns (int256)
287     {
288         require(a != MIN_INT256);
289         return a < 0 ? -a : a;
290     }
291 }
292 
293 contract RMPL is Ownable, ERC20Detailed {
294 
295 	// PLEASE READ BEFORE CHANGING ANY ACCOUNTING OR MATH
296     // Anytime there is division, there is a risk of numerical instability from rounding errors. In
297     // order to minimize this risk, we adhere to the following guidelines:
298     // 1) The conversion rate adopted is the number of gons that equals 1 fragment.
299     //    The inverse rate must not be used--TOTAL_GONS is always the numerator and _totalSupply is
300     //    always the denominator. (i.e. If you want to convert gons to fragments instead of
301     //    multiplying by the inverse rate, you should divide by the normal rate)
302     // 2) Gon balances converted into Fragments are always rounded down (truncated).
303     //
304     // We make the following guarantees:
305     // - If address 'A' transfers x Fragments to address 'B'. A's resulting external balance will
306     //   be decreased by precisely x Fragments, and B's external balance will be precisely
307     //   increased by x Fragments.
308     //
309     // We do not guarantee that the sum of all balances equals the result of calling totalSupply().
310     // This is because, for any conversion function 'f()' that has non-zero rounding error,
311     // f(x0) + f(x1) + ... + f(xn) is not always equal to f(x0 + x1 + ... xn).
312 	
313 
314     using SafeMath for uint256;
315     using SafeMathInt for int256;
316 	
317 	struct Transaction {
318         bool enabled;
319         address destination;
320         bytes data;
321     }
322 
323     event TransactionFailed(address indexed destination, uint index, bytes data);
324 	
325 	// Stable ordering is not guaranteed.
326 
327     Transaction[] public transactions;
328 
329     event LogRebase(uint256 indexed epoch, uint256 totalSupply);
330 
331     modifier validRecipient(address to) {
332         require(to != address(0x0));
333         require(to != address(this));
334         _;
335     }
336 
337     uint256 private constant DECIMALS = 9;
338     uint256 private constant MAX_UINT256 = ~uint256(0);
339     uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 30 * 10**5 * 10**DECIMALS;
340 
341 	// TOTAL_GONS is a multiple of INITIAL_FRAGMENTS_SUPPLY so that _gonsPerFragment is an integer.
342     // Use the highest value that fits in a uint256 for max granularity.
343     uint256 private constant TOTAL_GONS = MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);
344 
345 	// MAX_SUPPLY = maximum integer < (sqrt(4*TOTAL_GONS + 1) - 1) / 2
346     uint256 private constant MAX_SUPPLY = ~uint128(0);  // (2^128) - 1
347 	
348 	uint256 private _epoch;
349 
350     uint256 private _totalSupply;
351     uint256 private _gonsPerFragment;
352     mapping(address => uint256) private _gonBalances;
353 	
354 	// This is denominated in Fragments, because the gons-fragments conversion might change before
355     // it's fully paid.
356     mapping (address => mapping (address => uint256)) private _allowedFragments;
357 
358 	/**
359      * @dev Notifies Fragments contract about a new rebase cycle.
360      * @param supplyDelta The number of new fragment tokens to add into circulation via expansion.
361      * @return The total number of fragments after the supply adjustment.
362      */
363     function rebase(int256 supplyDelta)
364         external
365         onlyOwner
366         returns (uint256)
367     {
368 	
369 		_epoch = _epoch.add(1);
370 		
371         if (supplyDelta == 0) {
372             emit LogRebase(_epoch, _totalSupply);
373             return _totalSupply;
374         }
375 
376         if (supplyDelta < 0) {
377             _totalSupply = _totalSupply.sub(uint256(supplyDelta.abs()));
378         } else {
379             _totalSupply = _totalSupply.add(uint256(supplyDelta));
380         }
381 
382         if (_totalSupply > MAX_SUPPLY) {
383             _totalSupply = MAX_SUPPLY;
384         }
385 
386         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
387 		
388 		// From this point forward, _gonsPerFragment is taken as the source of truth.
389         // We recalculate a new _totalSupply to be in agreement with the _gonsPerFragment
390         // conversion rate.
391         // This means our applied supplyDelta can deviate from the requested supplyDelta,
392         // but this deviation is guaranteed to be < (_totalSupply^2)/(TOTAL_GONS - _totalSupply).
393         //
394         // In the case of _totalSupply <= MAX_UINT128 (our current supply cap), this
395         // deviation is guaranteed to be < 1, so we can omit this step. If the supply cap is
396         // ever increased, it must be re-included.
397         // _totalSupply = TOTAL_GONS.div(_gonsPerFragment)
398 		
399 		emit LogRebase(_epoch, _totalSupply);
400 
401 		for (uint i = 0; i < transactions.length; i++) {
402             Transaction storage t = transactions[i];
403             if (t.enabled) {
404                 bool result = externalCall(t.destination, t.data);
405                 if (!result) {
406                     emit TransactionFailed(t.destination, i, t.data);
407                     revert("Transaction Failed");
408                 }
409             }
410         }
411 		
412         return _totalSupply;
413     }
414 	
415 	constructor() public {
416 	
417 		Ownable.initialize(msg.sender);
418 		ERC20Detailed.initialize("RMPL", "RMPL", uint8(DECIMALS));
419         
420         _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
421         _gonBalances[msg.sender] = TOTAL_GONS;
422         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
423 
424         emit Transfer(address(0x0), msg.sender, _totalSupply);
425     }
426 	
427 	/**
428      * @return The total number of fragments.
429      */
430 
431     function totalSupply()
432         public
433         view
434         returns (uint256)
435     {
436         return _totalSupply;
437     }
438 	
439 	/**
440      * @param who The address to query.
441      * @return The balance of the specified address.
442      */
443 
444     function balanceOf(address who)
445         public
446         view
447         returns (uint256)
448     {
449         return _gonBalances[who].div(_gonsPerFragment);
450     }
451 
452 	/**
453      * @dev Transfer tokens to a specified address.
454      * @param to The address to transfer to.
455      * @param value The amount to be transferred.
456      * @return True on success, false otherwise.
457      */
458 	 
459     function transfer(address to, uint256 value)
460         public
461         validRecipient(to)
462         returns (bool)
463     {
464         uint256 merValue = value.mul(_gonsPerFragment);
465         _gonBalances[msg.sender] = _gonBalances[msg.sender].sub(merValue);
466         _gonBalances[to] = _gonBalances[to].add(merValue);
467         emit Transfer(msg.sender, to, value);
468         return true;
469     }
470 
471 	/**
472      * @dev Function to check the amount of tokens that an owner has allowed to a spender.
473      * @param owner_ The address which owns the funds.
474      * @param spender The address which will spend the funds.
475      * @return The number of tokens still available for the spender.
476      */
477 	 
478     function allowance(address owner_, address spender)
479         public
480         view
481         returns (uint256)
482     {
483         return _allowedFragments[owner_][spender];
484     }
485 	
486 	/**
487      * @dev Transfer tokens from one address to another.
488      * @param from The address you want to send tokens from.
489      * @param to The address you want to transfer to.
490      * @param value The amount of tokens to be transferred.
491      */
492 
493     function transferFrom(address from, address to, uint256 value)
494         public
495         validRecipient(to)
496         returns (bool)
497     {
498         _allowedFragments[from][msg.sender] = _allowedFragments[from][msg.sender].sub(value);
499 
500         uint256 merValue = value.mul(_gonsPerFragment);
501         _gonBalances[from] = _gonBalances[from].sub(merValue);
502         _gonBalances[to] = _gonBalances[to].add(merValue);
503         emit Transfer(from, to, value);
504 
505         return true;
506     }
507 	
508 	/**
509      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
510      * msg.sender. This method is included for ERC20 compatibility.
511      * increaseAllowance and decreaseAllowance should be used instead.
512      * Changing an allowance with this method brings the risk that someone may transfer both
513      * the old and the new allowance - if they are both greater than zero - if a transfer
514      * transaction is mined before the later approve() call is mined.
515      *
516      * @param spender The address which will spend the funds.
517      * @param value The amount of tokens to be spent.
518      */
519 
520     function approve(address spender, uint256 value)
521         public
522         returns (bool)
523     {
524         _allowedFragments[msg.sender][spender] = value;
525         emit Approval(msg.sender, spender, value);
526         return true;
527     }
528 	
529 	/**
530      * @dev Increase the amount of tokens that an owner has allowed to a spender.
531      * This method should be used instead of approve() to avoid the double approval vulnerability
532      * described above.
533      * @param spender The address which will spend the funds.
534      * @param addedValue The amount of tokens to increase the allowance by.
535      */
536 
537     function increaseAllowance(address spender, uint256 addedValue)
538         public
539         returns (bool)
540     {
541         _allowedFragments[msg.sender][spender] =
542             _allowedFragments[msg.sender][spender].add(addedValue);
543         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
544         return true;
545     }
546 	
547 	/**
548      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
549      *
550      * @param spender The address which will spend the funds.
551      * @param subtractedValue The amount of tokens to decrease the allowance by.
552      */
553 
554     function decreaseAllowance(address spender, uint256 subtractedValue)
555         public
556         returns (bool)
557     {
558         uint256 oldValue = _allowedFragments[msg.sender][spender];
559         if (subtractedValue >= oldValue) {
560             _allowedFragments[msg.sender][spender] = 0;
561         } else {
562             _allowedFragments[msg.sender][spender] = oldValue.sub(subtractedValue);
563         }
564         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
565         return true;
566     }
567 	
568 	/**
569      * @notice Adds a transaction that gets called for a downstream receiver of rebases
570      * @param destination Address of contract destination
571      * @param data Transaction data payload
572      */
573 	
574     function addTransaction(address destination, bytes data)
575         external
576         onlyOwner
577     {
578         transactions.push(Transaction({
579             enabled: true,
580             destination: destination,
581             data: data
582         }));
583     }
584 	
585 	/**
586      * @param index Index of transaction to remove.
587      *              Transaction ordering may have changed since adding.
588      */
589 
590     function removeTransaction(uint index)
591         external
592         onlyOwner
593     {
594         require(index < transactions.length, "index out of bounds");
595 
596         if (index < transactions.length - 1) {
597             transactions[index] = transactions[transactions.length - 1];
598         }
599 
600         transactions.length--;
601     }
602 	
603 	/**
604      * @param index Index of transaction. Transaction ordering may have changed since adding.
605      * @param enabled True for enabled, false for disabled.
606      */
607 
608     function setTransactionEnabled(uint index, bool enabled)
609         external
610         onlyOwner
611     {
612         require(index < transactions.length, "index must be in range of stored tx list");
613         transactions[index].enabled = enabled;
614     }
615 	
616 	/**
617      * @return Number of transactions, both enabled and disabled, in transactions list.
618      */
619 
620     function transactionsSize()
621         external
622         view
623         returns (uint256)
624     {
625         return transactions.length;
626     }
627 	
628 	/**
629      * @dev wrapper to call the encoded transactions on downstream consumers.
630      * @param destination Address of destination contract.
631      * @param data The encoded data payload.
632      * @return True on success
633      */
634 
635     function externalCall(address destination, bytes data)
636         internal
637         returns (bool)
638     {
639         bool result;
640         assembly {  // solhint-disable-line no-inline-assembly
641             // "Allocate" memory for output
642             // (0x40 is where "free memory" pointer is stored by convention)
643             let outputAddress := mload(0x40)
644 
645             // First 32 bytes are the padded length of data, so exclude that
646             let dataAddress := add(data, 32)
647 
648             result := call(
649                 // 34710 is the value that solidity is currently emitting
650                 // It includes callGas (700) + callVeryLow (3, to pay for SUB)
651                 // + callValueTransferGas (9000) + callNewAccountGas
652                 // (25000, in case the destination address does not exist and needs creating)
653                 sub(gas, 34710),
654 
655 
656                 destination,
657                 0, // transfer value in wei
658                 dataAddress,
659                 mload(data),  // Size of the input, in bytes. Stored in position 0 of the array.
660                 outputAddress,
661                 0  // Output is ignored, therefore the output size is zero
662             )
663         }
664         return result;
665     }
666 }