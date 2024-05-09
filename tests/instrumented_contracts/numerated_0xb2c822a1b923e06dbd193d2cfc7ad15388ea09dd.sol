1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-25
3 */
4 
5 pragma solidity 0.5.17;
6 
7 /* 
8     VAMP.sol
9 
10     Elastic Supply ERC20 Token with randomized rebasing.
11     
12     Forked from Ampleforth: https://github.com/ampleforth/uFragments
13     
14     GPL 3.0 license.
15     
16     VAMP.sol - Basic ERC20 Token with rebase functionality
17     Rebaser.sol - Handles decentralized, autonomous, random rebasing on-chain. 
18     
19     Rebaser.sol will be upgraded as the project progresses. Ownership of VAMP.sol can be changed to new versions of Rebaser.sol as they are released.
20     
21     See github for more info and latest versions: https://github.com/VAMPdefiteam
22     
23     Once a final version has been agreed, owner address of VAMP.sol will be locked to ensure completely decentralised operation forever.
24     
25 */
26 
27 contract Initializable {
28 
29   bool private initialized;
30   bool private initializing;
31 
32   modifier initializer() {
33     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
34 
35     bool wasInitializing = initializing;
36     initializing = true;
37     initialized = true;
38 
39     _;
40 
41     initializing = wasInitializing;
42   }
43 
44   function isConstructor() private view returns (bool) {
45     uint256 cs;
46     assembly { cs := extcodesize(address) }
47     return cs == 0;
48   }
49 
50   uint256[50] private ______gap;
51 }
52 
53 contract Ownable is Initializable {
54 
55   address private _owner;
56   uint256 private _ownershipLocked;
57 
58   event OwnershipLocked(address lockedOwner);
59   event OwnershipRenounced(address indexed previousOwner);
60   event OwnershipTransferred(
61     address indexed previousOwner,
62     address indexed newOwner
63   );
64 
65 
66   function initialize(address sender) internal initializer {
67     _owner = sender;
68 	_ownershipLocked = 0;
69   }
70 
71   function owner() public view returns(address) {
72     return _owner;
73   }
74 
75   modifier onlyOwner() {
76     require(isOwner());
77     _;
78   }
79 
80   function isOwner() public view returns(bool) {
81     return msg.sender == _owner;
82   }
83 
84   function transferOwnership(address newOwner) public onlyOwner {
85     _transferOwnership(newOwner);
86   }
87 
88   function _transferOwnership(address newOwner) internal {
89     require(_ownershipLocked == 0);
90     require(newOwner != address(0));
91     emit OwnershipTransferred(_owner, newOwner);
92     _owner = newOwner;
93   }
94   
95   // Set _ownershipLocked flag to lock contract owner forever
96   function lockOwnership() public onlyOwner {
97 	require(_ownershipLocked == 0);
98 	emit OwnershipLocked(_owner);
99     _ownershipLocked = 1;
100   }
101 
102   uint256[50] private ______gap;
103 }
104 
105 interface IERC20 {
106   function totalSupply() external view returns (uint256);
107 
108   function balanceOf(address who) external view returns (uint256);
109 
110   function allowance(address owner, address spender)
111     external view returns (uint256);
112 
113   function transfer(address to, uint256 value) external returns (bool);
114 
115   function approve(address spender, uint256 value)
116     external returns (bool);
117 
118   function transferFrom(address from, address to, uint256 value)
119     external returns (bool);
120 
121   event Transfer(
122     address indexed from,
123     address indexed to,
124     uint256 value
125   );
126 
127   event Approval(
128     address indexed owner,
129     address indexed spender,
130     uint256 value
131   );
132 }
133 
134 contract ERC20Detailed is Initializable, IERC20 {
135   string private _name;
136   string private _symbol;
137   uint8 private _decimals;
138 
139   function initialize( string memory name, string memory symbol, uint8  decimals) internal initializer {
140     _name = name;
141     _symbol = symbol;
142     _decimals = decimals;
143   }
144 
145   function name() public view returns(string memory) {
146     return _name;
147   }
148 
149   function symbol() public view returns(string memory) {
150     return _symbol;
151   }
152 
153   function decimals() public view returns(uint8) {
154     return _decimals;
155   }
156 
157   uint256[50] private ______gap;
158 }
159 
160 library SafeMath {
161 
162     function add(uint256 a, uint256 b) internal pure returns (uint256) {
163         uint256 c = a + b;
164         require(c >= a, "SafeMath: addition overflow");
165 
166         return c;
167     }
168 
169     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
170         return sub(a, b, "SafeMath: subtraction overflow");
171     }
172 
173     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
174         require(b <= a, errorMessage);
175         uint256 c = a - b;
176 
177         return c;
178     }
179 
180     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
181         if (a == 0) {
182             return 0;
183         }
184 
185         uint256 c = a * b;
186         require(c / a == b, "SafeMath: multiplication overflow");
187 
188         return c;
189     }
190 
191     function div(uint256 a, uint256 b) internal pure returns (uint256) {
192         return div(a, b, "SafeMath: division by zero");
193     }
194 
195     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
196         require(b > 0, errorMessage);
197         uint256 c = a / b;
198 
199         return c;
200     }
201 
202     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
203         return mod(a, b, "SafeMath: modulo by zero");
204     }
205 
206     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
207         require(b != 0, errorMessage);
208         return a % b;
209     }
210 }
211 
212 /*
213 MIT License
214 
215 Copyright (c) 2018 requestnetwork
216 Copyright (c) 2018 Fragments, Inc.
217 
218 Permission is hereby granted, free of charge, to any person obtaining a copy
219 of this software and associated documentation files (the "Software"), to deal
220 in the Software without restriction, including without limitation the rights
221 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
222 copies of the Software, and to permit persons to whom the Software is
223 furnished to do so, subject to the following conditions:
224 
225 The above copyright notice and this permission notice shall be included in all
226 copies or substantial portions of the Software.
227 
228 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
229 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
230 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
231 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
232 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
233 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
234 SOFTWARE.
235 */
236 
237 library SafeMathInt {
238 
239     int256 private constant MIN_INT256 = int256(1) << 255;
240     int256 private constant MAX_INT256 = ~(int256(1) << 255);
241 
242     function mul(int256 a, int256 b)
243         internal
244         pure
245         returns (int256)
246     {
247         int256 c = a * b;
248 
249         // Detect overflow when multiplying MIN_INT256 with -1
250         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
251         require((b == 0) || (c / b == a));
252         return c;
253     }
254 
255     function div(int256 a, int256 b)
256         internal
257         pure
258         returns (int256)
259     {
260         // Prevent overflow when dividing MIN_INT256 by -1
261         require(b != -1 || a != MIN_INT256);
262 
263         // Solidity already throws when dividing by 0.
264         return a / b;
265     }
266 
267     function sub(int256 a, int256 b)
268         internal
269         pure
270         returns (int256)
271     {
272         int256 c = a - b;
273         require((b >= 0 && c <= a) || (b < 0 && c > a));
274         return c;
275     }
276 
277     function add(int256 a, int256 b)
278         internal
279         pure
280         returns (int256)
281     {
282         int256 c = a + b;
283         require((b >= 0 && c >= a) || (b < 0 && c < a));
284         return c;
285     }
286 
287     function abs(int256 a)
288         internal
289         pure
290         returns (int256)
291     {
292         require(a != MIN_INT256);
293         return a < 0 ? -a : a;
294     }
295 }
296 
297 contract VAMP is Ownable, ERC20Detailed {
298 
299 	// PLEASE READ BEFORE CHANGING ANY ACCOUNTING OR MATH
300     // Anytime there is division, there is a risk of numerical instability from rounding errors. In
301     // order to minimize this risk, we adhere to the following guidelines:
302     // 1) The conversion rate adopted is the number of gons that equals 1 fragment.
303     //    The inverse rate must not be used--TOTAL_GONS is always the numerator and _totalSupply is
304     //    always the denominator. (i.e. If you want to convert gons to fragments instead of
305     //    multiplying by the inverse rate, you should divide by the normal rate)
306     // 2) Gon balances converted into Fragments are always rounded down (truncated).
307     //
308     // We make the following guarantees:
309     // - If address 'A' transfers x Fragments to address 'B'. A's resulting external balance will
310     //   be decreased by precisely x Fragments, and B's external balance will be precisely
311     //   increased by x Fragments.
312     //
313     // We do not guarantee that the sum of all balances equals the result of calling totalSupply().
314     // This is because, for any conversion function 'f()' that has non-zero rounding error,
315     // f(x0) + f(x1) + ... + f(xn) is not always equal to f(x0 + x1 + ... xn).
316 	
317 
318     using SafeMath for uint256;
319     using SafeMathInt for int256;
320 	
321 	struct Transaction {
322         bool enabled;
323         address destination;
324         bytes data;
325     }
326 
327     event TransactionFailed(address indexed destination, uint index, bytes data);
328 	
329 	// Stable ordering is not guaranteed.
330 
331     Transaction[] public transactions;
332 
333     event LogRebase(uint256 indexed epoch, uint256 totalSupply);
334 
335     modifier validRecipient(address to) {
336         require(to != address(0x0));
337         require(to != address(this));
338         _;
339     }
340 
341     uint256 private constant DECIMALS = 18;
342     uint256 private constant MAX_UINT256 = ~uint256(0);
343     uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 13750000 * 10**DECIMALS;
344 
345 	// TOTAL_GONS is a multiple of INITIAL_FRAGMENTS_SUPPLY so that _gonsPerFragment is an integer.
346     // Use the highest value that fits in a uint256 for max granularity.
347     uint256 private constant TOTAL_GONS = MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);
348 
349 	// MAX_SUPPLY = maximum integer < (sqrt(4*TOTAL_GONS + 1) - 1) / 2
350     uint256 private constant MAX_SUPPLY = ~uint128(0);  // (2^128) - 1
351 	
352 	uint256 private _epoch;
353 
354     uint256 private _totalSupply;
355     uint256 private _gonsPerFragment;
356     address private rebaser;
357     mapping(address => uint256) private _gonBalances;
358 	
359 	// This is denominated in Fragments, because the gons-fragments conversion might change before
360     // it's fully paid.
361     mapping (address => mapping (address => uint256)) private _allowedFragments;
362 
363     
364   modifier onlyRebaser() {
365     require(msg.sender == rebaser);
366     _;
367   }
368 
369     function setRebaser(address _rebaser) public onlyOwner {
370         rebaser = _rebaser;
371     }
372 
373 	/**
374      * @dev Notifies Fragments contract about a new rebase cycle.
375      * @param supplyDelta The number of new fragment tokens to add into circulation via expansion.
376      * @return The total number of fragments after the supply adjustment.
377      */
378     function rebase(int256 supplyDelta)
379         external
380         onlyRebaser
381         returns (uint256)
382     {
383 	
384 		_epoch = _epoch.add(1);
385 		
386         if (supplyDelta == 0) {
387             emit LogRebase(_epoch, _totalSupply);
388             return _totalSupply;
389         }
390 
391         if (supplyDelta < 0) {
392             _totalSupply = _totalSupply.sub(uint256(supplyDelta.abs()));
393         } else {
394             _totalSupply = _totalSupply.add(uint256(supplyDelta));
395         }
396 
397         if (_totalSupply > MAX_SUPPLY) {
398             _totalSupply = MAX_SUPPLY;
399         }
400 
401         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
402 		
403 		// From this point forward, _gonsPerFragment is taken as the source of truth.
404         // We recalculate a new _totalSupply to be in agreement with the _gonsPerFragment
405         // conversion rate.
406         // This means our applied supplyDelta can deviate from the requested supplyDelta,
407         // but this deviation is guaranteed to be < (_totalSupply^2)/(TOTAL_GONS - _totalSupply).
408         //
409         // In the case of _totalSupply <= MAX_UINT128 (our current supply cap), this
410         // deviation is guaranteed to be < 1, so we can omit this step. If the supply cap is
411         // ever increased, it must be re-included.
412         // _totalSupply = TOTAL_GONS.div(_gonsPerFragment)
413 		
414 		emit LogRebase(_epoch, _totalSupply);
415 
416 		for (uint i = 0; i < transactions.length; i++) {
417             Transaction storage t = transactions[i];
418             if (t.enabled) {
419                 bool result = externalCall(t.destination, t.data);
420                 if (!result) {
421                     emit TransactionFailed(t.destination, i, t.data);
422                     revert("Transaction Failed");
423                 }
424             }
425         }
426 		
427         return _totalSupply;
428     }
429 	
430 	constructor() public {
431 	
432 		Ownable.initialize(msg.sender);
433 		ERC20Detailed.initialize("Vampire Protocol", "VAMP", uint8(DECIMALS));
434         
435         _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
436         _gonBalances[msg.sender] = TOTAL_GONS;
437         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
438 
439         emit Transfer(address(0x0), msg.sender, _totalSupply);
440     }
441 
442 	
443 	/**
444      * @return The total number of fragments.
445      */
446 
447     function totalSupply()
448         public
449         view
450         returns (uint256)
451     {
452         return _totalSupply;
453     }
454 	
455 	/**
456      * @param who The address to query.
457      * @return The balance of the specified address.
458      */
459 
460     function balanceOf(address who)
461         public
462         view
463         returns (uint256)
464     {
465         return _gonBalances[who].div(_gonsPerFragment);
466     }
467 
468 	/**
469      * @dev Transfer tokens to a specified address.
470      * @param to The address to transfer to.
471      * @param value The amount to be transferred.
472      * @return True on success, false otherwise.
473      */
474 	 
475     function transfer(address to, uint256 value)
476         public
477         validRecipient(to)
478         returns (bool)
479     {
480         uint256 merValue = value.mul(_gonsPerFragment);
481         _gonBalances[msg.sender] = _gonBalances[msg.sender].sub(merValue);
482         _gonBalances[to] = _gonBalances[to].add(merValue);
483         emit Transfer(msg.sender, to, value);
484         return true;
485     }
486 
487 	/**
488      * @dev Function to check the amount of tokens that an owner has allowed to a spender.
489      * @param owner_ The address which owns the funds.
490      * @param spender The address which will spend the funds.
491      * @return The number of tokens still available for the spender.
492      */
493 	 
494     function allowance(address owner_, address spender)
495         public
496         view
497         returns (uint256)
498     {
499         return _allowedFragments[owner_][spender];
500     }
501 	
502 	/**
503      * @dev Transfer tokens from one address to another.
504      * @param from The address you want to send tokens from.
505      * @param to The address you want to transfer to.
506      * @param value The amount of tokens to be transferred.
507      */
508 
509     function transferFrom(address from, address to, uint256 value)
510         public
511         validRecipient(to)
512         returns (bool)
513     {
514         _allowedFragments[from][msg.sender] = _allowedFragments[from][msg.sender].sub(value);
515 
516         uint256 merValue = value.mul(_gonsPerFragment);
517         _gonBalances[from] = _gonBalances[from].sub(merValue);
518         _gonBalances[to] = _gonBalances[to].add(merValue);
519         emit Transfer(from, to, value);
520 
521         return true;
522     }
523 	
524 	/**
525      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
526      * msg.sender. This method is included for ERC20 compatibility.
527      * increaseAllowance and decreaseAllowance should be used instead.
528      * Changing an allowance with this method brings the risk that someone may transfer both
529      * the old and the new allowance - if they are both greater than zero - if a transfer
530      * transaction is mined before the later approve() call is mined.
531      *
532      * @param spender The address which will spend the funds.
533      * @param value The amount of tokens to be spent.
534      */
535 
536     function approve(address spender, uint256 value)
537         public
538         returns (bool)
539     {
540         _allowedFragments[msg.sender][spender] = value;
541         emit Approval(msg.sender, spender, value);
542         return true;
543     }
544 	
545 	/**
546      * @dev Increase the amount of tokens that an owner has allowed to a spender.
547      * This method should be used instead of approve() to avoid the double approval vulnerability
548      * described above.
549      * @param spender The address which will spend the funds.
550      * @param addedValue The amount of tokens to increase the allowance by.
551      */
552 
553     function increaseAllowance(address spender, uint256 addedValue)
554         public
555         returns (bool)
556     {
557         _allowedFragments[msg.sender][spender] =
558             _allowedFragments[msg.sender][spender].add(addedValue);
559         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
560         return true;
561     }
562 	
563 	/**
564      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
565      *
566      * @param spender The address which will spend the funds.
567      * @param subtractedValue The amount of tokens to decrease the allowance by.
568      */
569 
570     function decreaseAllowance(address spender, uint256 subtractedValue)
571         public
572         returns (bool)
573     {
574         uint256 oldValue = _allowedFragments[msg.sender][spender];
575         if (subtractedValue >= oldValue) {
576             _allowedFragments[msg.sender][spender] = 0;
577         } else {
578             _allowedFragments[msg.sender][spender] = oldValue.sub(subtractedValue);
579         }
580         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
581         return true;
582     }
583 	
584 	/**
585      * @notice Adds a transaction that gets called for a downstream receiver of rebases
586      * @param destination Address of contract destination
587      * @param data Transaction data payload
588      */
589 	
590     function addTransaction(address destination, bytes calldata data)
591         external
592         onlyOwner
593     {
594         transactions.push(Transaction({
595             enabled: true,
596             destination: destination,
597             data: data
598         }));
599     }
600 	
601 	/**
602      * @param index Index of transaction to remove.
603      *              Transaction ordering may have changed since adding.
604      */
605 
606     function removeTransaction(uint index)
607         external
608         onlyOwner
609     {
610         require(index < transactions.length, "index out of bounds");
611 
612         if (index < transactions.length - 1) {
613             transactions[index] = transactions[transactions.length - 1];
614         }
615 
616         transactions.length--;
617     }
618 	
619 	/**
620      * @param index Index of transaction. Transaction ordering may have changed since adding.
621      * @param enabled True for enabled, false for disabled.
622      */
623 
624     function setTransactionEnabled(uint index, bool enabled)
625         external
626         onlyOwner
627     {
628         require(index < transactions.length, "index must be in range of stored tx list");
629         transactions[index].enabled = enabled;
630     }
631 	
632 	/**
633      * @return Number of transactions, both enabled and disabled, in transactions list.
634      */
635 
636     function transactionsSize()
637         external
638         view
639         returns (uint256)
640     {
641         return transactions.length;
642     }
643 	
644 	/**
645      * @dev wrapper to call the encoded transactions on downstream consumers.
646      * @param destination Address of destination contract.
647      * @param data The encoded data payload.
648      * @return True on success
649      */
650 
651     function externalCall(address destination, bytes memory data)
652         internal
653         returns (bool)
654     {
655         bool result;
656         assembly {  // solhint-disable-line no-inline-assembly
657             // "Allocate" memory for output
658             // (0x40 is where "free memory" pointer is stored by convention)
659             let outputAddress := mload(0x40)
660 
661             // First 32 bytes are the padded length of data, so exclude that
662             let dataAddress := add(data, 32)
663 
664             result := call(
665                 // 34710 is the value that solidity is currently emitting
666                 // It includes callGas (700) + callVeryLow (3, to pay for SUB)
667                 // + callValueTransferGas (9000) + callNewAccountGas
668                 // (25000, in case the destination address does not exist and needs creating)
669                 sub(gas, 34710),
670 
671 
672                 destination,
673                 0, // transfer value in wei
674                 dataAddress,
675                 mload(data),  // Size of the input, in bytes. Stored in position 0 of the array.
676                 outputAddress,
677                 0  // Output is ignored, therefore the output size is zero
678             )
679         }
680         return result;
681     }
682 }