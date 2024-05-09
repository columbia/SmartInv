1 pragma solidity 0.5.0;
2 
3 /* 
4     TREND.sol
5 
6     Elastic Supply ERC20 Token with randomized rebasing.
7     
8     Forked from Ampleforth: https://github.com/ampleforth/uFragments
9     
10     GPL 3.0 license.
11     
12     TREND.sol - Basic ERC20 Token with rebase functionality
13     Orchestrator.sol - Handles decentralized, autonomous, random rebasing on-chain. 
14     
15     Orchestrator.sol will be upgraded as the project progresses. Ownership of TREND.sol can be changed to new versions of Orchestrator.sol as they are released.
16     
17     
18     Once a final version has been agreed, owner address of TREND.sol will be locked to ensure completely decentralised operation forever.
19     
20 */
21 
22 contract Initializable {
23 
24   bool private initialized;
25   bool private initializing;
26 
27   modifier initializer() {
28     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
29 
30     bool wasInitializing = initializing;
31     initializing = true;
32     initialized = true;
33 
34     _;
35 
36     initializing = wasInitializing;
37   }
38 
39     function isConstructor() private view returns (bool) {
40     uint256 cs;
41     assembly { cs := extcodesize(address) }
42     return cs == 0;
43   }
44 
45   uint256[50] private ______gap;
46 }
47 
48 contract Ownable is Initializable {
49 
50   address private _owner;
51   uint256 private _ownershipLocked;
52 
53   event OwnershipLocked(address lockedOwner);
54   event OwnershipRenounced(address indexed previousOwner);
55   event OwnershipTransferred(
56     address indexed previousOwner,
57     address indexed newOwner
58   );
59 
60 
61   function initialize(address sender) internal initializer {
62     _owner = sender;
63 	_ownershipLocked = 0;
64   }
65 
66   function owner() public view returns(address) {
67     return _owner;
68   }
69 
70   modifier onlyOwner() {
71     require(isOwner());
72     _;
73   }
74 
75   function isOwner() public view returns(bool) {
76     return msg.sender == _owner;
77   }
78 
79   function transferOwnership(address newOwner) public onlyOwner {
80     _transferOwnership(newOwner);
81   }
82 
83   function _transferOwnership(address newOwner) internal {
84     require(_ownershipLocked == 0);
85     require(newOwner != address(0));
86     emit OwnershipTransferred(_owner, newOwner);
87     _owner = newOwner;
88   }
89   
90   // Set _ownershipLocked flag to lock contract owner forever
91   function lockOwnership() public onlyOwner {
92 	require(_ownershipLocked == 0);
93 	emit OwnershipLocked(_owner);
94     _ownershipLocked = 1;
95   }
96 
97   uint256[50] private ______gap;
98 }
99 
100 interface IERC20 {
101   function totalSupply() external view returns (uint256);
102 
103   function balanceOf(address who) external view returns (uint256);
104 
105   function allowance(address owner, address spender)
106     external view returns (uint256);
107 
108   function transfer(address to, uint256 value) external returns (bool);
109 
110   function approve(address spender, uint256 value)
111     external returns (bool);
112 
113   function transferFrom(address from, address to, uint256 value)
114     external returns (bool);
115 
116   event Transfer(
117     address indexed from,
118     address indexed to,
119     uint256 value
120   );
121 
122   event Approval(
123     address indexed owner,
124     address indexed spender,
125     uint256 value
126   );
127 }
128 
129 contract ERC20Detailed is Initializable, IERC20 {
130   string private _name;
131   string private _symbol;
132   uint8 private _decimals;
133 
134   function initialize(string memory name, string memory symbol, uint8 decimals) internal initializer {
135     _name = name;
136     _symbol = symbol;
137     _decimals = decimals;
138   }
139 
140   function name() public view returns(string memory) {
141     return _name;
142   }
143 
144   function symbol() public view returns(string memory) {
145     return _symbol;
146   }
147 
148   function decimals() public view returns(uint8) {
149     return _decimals;
150   }
151 
152   uint256[50] private ______gap;
153 }
154 
155 library SafeMath {
156 
157     function add(uint256 a, uint256 b) internal pure returns (uint256) {
158         uint256 c = a + b;
159         require(c >= a, "SafeMath: addition overflow");
160 
161         return c;
162     }
163 
164     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
165         return sub(a, b, "SafeMath: subtraction overflow");
166     }
167 
168     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
169         require(b <= a, errorMessage);
170         uint256 c = a - b;
171 
172         return c;
173     }
174 
175     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
176         if (a == 0) {
177             return 0;
178         }
179 
180         uint256 c = a * b;
181         require(c / a == b, "SafeMath: multiplication overflow");
182 
183         return c;
184     }
185 
186     function div(uint256 a, uint256 b) internal pure returns (uint256) {
187         return div(a, b, "SafeMath: division by zero");
188     }
189 
190     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
191         require(b > 0, errorMessage);
192         uint256 c = a / b;
193 
194         return c;
195     }
196 
197     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
198         return mod(a, b, "SafeMath: modulo by zero");
199     }
200 
201     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
202         require(b != 0, errorMessage);
203         return a % b;
204     }
205 }
206 
207 /*
208 MIT License
209 
210 Copyright (c) 2018 requestnetwork
211 Copyright (c) 2018 Fragments, Inc.
212 
213 Permission is hereby granted, free of charge, to any person obtaining a copy
214 of this software and associated documentation files (the "Software"), to deal
215 in the Software without restriction, including without limitation the rights
216 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
217 copies of the Software, and to permit persons to whom the Software is
218 furnished to do so, subject to the following conditions:
219 
220 The above copyright notice and this permission notice shall be included in all
221 copies or substantial portions of the Software.
222 
223 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
224 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
225 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
226 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
227 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
228 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
229 SOFTWARE.
230 */
231 
232 library SafeMathInt {
233 
234     int256 private constant MIN_INT256 = int256(1) << 255;
235     int256 private constant MAX_INT256 = ~(int256(1) << 255);
236 
237     function mul(int256 a, int256 b)
238         internal
239         pure
240         returns (int256)
241     {
242         int256 c = a * b;
243 
244         // Detect overflow when multiplying MIN_INT256 with -1
245         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
246         require((b == 0) || (c / b == a));
247         return c;
248     }
249 
250     function div(int256 a, int256 b)
251         internal
252         pure
253         returns (int256)
254     {
255         // Prevent overflow when dividing MIN_INT256 by -1
256         require(b != -1 || a != MIN_INT256);
257 
258         // Solidity already throws when dividing by 0.
259         return a / b;
260     }
261 
262     function sub(int256 a, int256 b)
263         internal
264         pure
265         returns (int256)
266     {
267         int256 c = a - b;
268         require((b >= 0 && c <= a) || (b < 0 && c > a));
269         return c;
270     }
271 
272     function add(int256 a, int256 b)
273         internal
274         pure
275         returns (int256)
276     {
277         int256 c = a + b;
278         require((b >= 0 && c >= a) || (b < 0 && c < a));
279         return c;
280     }
281 
282     function abs(int256 a)
283         internal
284         pure
285         returns (int256)
286     {
287         require(a != MIN_INT256);
288         return a < 0 ? -a : a;
289     }
290 }
291 
292 contract Trend is Ownable, ERC20Detailed {
293 
294 	// PLEASE READ BEFORE CHANGING ANY ACCOUNTING OR MATH
295     // Anytime there is division, there is a risk of numerical instability from rounding errors. In
296     // order to minimize this risk, we adhere to the following guidelines:
297     // 1) The conversion rate adopted is the number of gons that equals 1 fragment.
298     //    The inverse rate must not be used--TOTAL_GONS is always the numerator and _totalSupply is
299     //    always the denominator. (i.e. If you want to convert gons to fragments instead of
300     //    multiplying by the inverse rate, you should divide by the normal rate)
301     // 2) Gon balances converted into Fragments are always rounded down (truncated).
302     //
303     // We make the following guarantees:
304     // - If address 'A' transfers x Fragments to address 'B'. A's resulting external balance will
305     //   be decreased by precisely x Fragments, and B's external balance will be precisely
306     //   increased by x Fragments.
307     //
308     // We do not guarantee that the sum of all balances equals the result of calling totalSupply().
309     // This is because, for any conversion function 'f()' that has non-zero rounding error,
310     // f(x0) + f(x1) + ... + f(xn) is not always equal to f(x0 + x1 + ... xn).
311 	
312 
313     using SafeMath for uint256;
314     using SafeMathInt for int256;
315 	
316 	struct Transaction {
317         bool enabled;
318         address destination;
319         bytes data;
320     }
321 
322     event TransactionFailed(address indexed destination, uint index, bytes data);
323 	
324 	// Stable ordering is not guaranteed.
325 
326     Transaction[] public transactions;
327 
328     event LogRebase(uint256 indexed epoch, uint256 totalSupply);
329 
330     modifier validRecipient(address to) {
331         require(to != address(0x0));
332         require(to != address(this));
333         _;
334     }
335 
336     uint256 private constant DECIMALS = 9;
337     uint256 private constant MAX_UINT256 = ~uint256(0);
338     uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 626 * 10**3 * 10**DECIMALS;
339 
340 	// TOTAL_GONS is a multiple of INITIAL_FRAGMENTS_SUPPLY so that _gonsPerFragment is an integer.
341     // Use the highest value that fits in a uint256 for max granularity.
342     uint256 private constant TOTAL_GONS = MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);
343 
344 	// MAX_SUPPLY = maximum integer < (sqrt(4*TOTAL_GONS + 1) - 1) / 2
345     uint256 private constant MAX_SUPPLY = ~uint128(0);  // (2^128) - 1
346 	
347 	uint256 private _epoch;
348 
349     uint256 private _totalSupply;
350     uint256 private _gonsPerFragment;
351     mapping(address => uint256) private _gonBalances;
352 	
353 	// This is denominated in Fragments, because the gons-fragments conversion might change before
354     // it's fully paid.
355     mapping (address => mapping (address => uint256)) private _allowedFragments;
356 
357 	/**
358      * @dev Notifies Fragments contract about a new rebase cycle.
359      * @param supplyDelta The number of new fragment tokens to add into circulation via expansion.
360      * @return The total number of fragments after the supply adjustment.
361      */
362     function rebase(int256 supplyDelta)
363         external
364         onlyOwner
365         returns (uint256)
366     {
367 	
368 		_epoch = _epoch.add(1);
369 		
370         if (supplyDelta == 0) {
371             emit LogRebase(_epoch, _totalSupply);
372             return _totalSupply;
373         }
374 
375         if (supplyDelta < 0) {
376             _totalSupply = _totalSupply.sub(uint256(supplyDelta.abs()));
377         } else {
378             _totalSupply = _totalSupply.add(uint256(supplyDelta));
379         }
380 
381         if (_totalSupply > MAX_SUPPLY) {
382             _totalSupply = MAX_SUPPLY;
383         }
384 
385         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
386 		
387 		// From this point forward, _gonsPerFragment is taken as the source of truth.
388         // We recalculate a new _totalSupply to be in agreement with the _gonsPerFragment
389         // conversion rate.
390         // This means our applied supplyDelta can deviate from the requested supplyDelta,
391         // but this deviation is guaranteed to be < (_totalSupply^2)/(TOTAL_GONS - _totalSupply).
392         //
393         // In the case of _totalSupply <= MAX_UINT128 (our current supply cap), this
394         // deviation is guaranteed to be < 1, so we can omit this step. If the supply cap is
395         // ever increased, it must be re-included.
396         // _totalSupply = TOTAL_GONS.div(_gonsPerFragment)
397 		
398 		emit LogRebase(_epoch, _totalSupply);
399 
400 		for (uint i = 0; i < transactions.length; i++) {
401             Transaction storage t = transactions[i];
402             if (t.enabled) {
403                 bool result = externalCall(t.destination, t.data);
404                 if (!result) {
405                     emit TransactionFailed(t.destination, i, t.data);
406                     revert("Transaction Failed");
407                 }
408             }
409         }
410 		
411         return _totalSupply;
412     }
413 	
414 	constructor() public {
415 	
416 		Ownable.initialize(msg.sender);
417 		ERC20Detailed.initialize("Trend Token", "TREND", uint8(DECIMALS));
418         
419         _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
420         _gonBalances[msg.sender] = TOTAL_GONS;
421         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
422 
423         emit Transfer(address(0x0), msg.sender, _totalSupply);
424     }
425 	
426 	/**
427      * @return The total number of fragments.
428      */
429 
430     function totalSupply()
431         public
432         view
433         returns (uint256)
434     {
435         return _totalSupply;
436     }
437 	
438 	/**
439      * @param who The address to query.
440      * @return The balance of the specified address.
441      */
442 
443     function balanceOf(address who)
444         public
445         view
446         returns (uint256)
447     {
448         return _gonBalances[who].div(_gonsPerFragment);
449     }
450 
451 	/**
452      * @dev Transfer tokens to a specified address.
453      * @param to The address to transfer to.
454      * @param value The amount to be transferred.
455      * @return True on success, false otherwise.
456      */
457 	 
458     function transfer(address to, uint256 value)
459         public
460         validRecipient(to)
461         returns (bool)
462     {
463         uint256 merValue = value.mul(_gonsPerFragment);
464         _gonBalances[msg.sender] = _gonBalances[msg.sender].sub(merValue);
465         _gonBalances[to] = _gonBalances[to].add(merValue);
466         emit Transfer(msg.sender, to, value);
467         return true;
468     }
469 
470 	/**
471      * @dev Function to check the amount of tokens that an owner has allowed to a spender.
472      * @param owner_ The address which owns the funds.
473      * @param spender The address which will spend the funds.
474      * @return The number of tokens still available for the spender.
475      */
476 	 
477     function allowance(address owner_, address spender)
478         public
479         view
480         returns (uint256)
481     {
482         return _allowedFragments[owner_][spender];
483     }
484 	
485 	/**
486      * @dev Transfer tokens from one address to another.
487      * @param from The address you want to send tokens from.
488      * @param to The address you want to transfer to.
489      * @param value The amount of tokens to be transferred.
490      */
491 
492     function transferFrom(address from, address to, uint256 value)
493         public
494         validRecipient(to)
495         returns (bool)
496     {
497         _allowedFragments[from][msg.sender] = _allowedFragments[from][msg.sender].sub(value);
498 
499         uint256 merValue = value.mul(_gonsPerFragment);
500         _gonBalances[from] = _gonBalances[from].sub(merValue);
501         _gonBalances[to] = _gonBalances[to].add(merValue);
502         emit Transfer(from, to, value);
503 
504         return true;
505     }
506 	
507 	/**
508      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
509      * msg.sender. This method is included for ERC20 compatibility.
510      * increaseAllowance and decreaseAllowance should be used instead.
511      * Changing an allowance with this method brings the risk that someone may transfer both
512      * the old and the new allowance - if they are both greater than zero - if a transfer
513      * transaction is mined before the later approve() call is mined.
514      *
515      * @param spender The address which will spend the funds.
516      * @param value The amount of tokens to be spent.
517      */
518 
519     function approve(address spender, uint256 value)
520         public
521         returns (bool)
522     {
523         _allowedFragments[msg.sender][spender] = value;
524         emit Approval(msg.sender, spender, value);
525         return true;
526     }
527 	
528 	/**
529      * @dev Increase the amount of tokens that an owner has allowed to a spender.
530      * This method should be used instead of approve() to avoid the double approval vulnerability
531      * described above.
532      * @param spender The address which will spend the funds.
533      * @param addedValue The amount of tokens to increase the allowance by.
534      */
535 
536     function increaseAllowance(address spender, uint256 addedValue)
537         public
538         returns (bool)
539     {
540         _allowedFragments[msg.sender][spender] =
541             _allowedFragments[msg.sender][spender].add(addedValue);
542         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
543         return true;
544     }
545 	
546 	/**
547      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
548      *
549      * @param spender The address which will spend the funds.
550      * @param subtractedValue The amount of tokens to decrease the allowance by.
551      */
552 
553     function decreaseAllowance(address spender, uint256 subtractedValue)
554         public
555         returns (bool)
556     {
557         uint256 oldValue = _allowedFragments[msg.sender][spender];
558         if (subtractedValue >= oldValue) {
559             _allowedFragments[msg.sender][spender] = 0;
560         } else {
561             _allowedFragments[msg.sender][spender] = oldValue.sub(subtractedValue);
562         }
563         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
564         return true;
565     }
566 	
567 	/**
568      * @notice Adds a transaction that gets called for a downstream receiver of rebases
569      * @param destination Address of contract destination
570      * @param data Transaction data payload
571      */
572 	
573     function addTransaction(address destination, bytes calldata data)
574         external
575         onlyOwner
576     {
577         transactions.push(Transaction({
578             enabled: true,
579             destination: destination,
580             data: data
581         }));
582     }
583 	
584 	/**
585      * @param index Index of transaction to remove.
586      *              Transaction ordering may have changed since adding.
587      */
588 
589     function removeTransaction(uint index)
590         external
591         onlyOwner
592     {
593         require(index < transactions.length, "index out of bounds");
594 
595         if (index < transactions.length - 1) {
596             transactions[index] = transactions[transactions.length - 1];
597         }
598 
599         transactions.length--;
600     }
601 	
602 	/**
603      * @param index Index of transaction. Transaction ordering may have changed since adding.
604      * @param enabled True for enabled, false for disabled.
605      */
606 
607     function setTransactionEnabled(uint index, bool enabled)
608         external
609         onlyOwner
610     {
611         require(index < transactions.length, "index must be in range of stored tx list");
612         transactions[index].enabled = enabled;
613     }
614 	
615 	/**
616      * @return Number of transactions, both enabled and disabled, in transactions list.
617      */
618 
619     function transactionsSize()
620         external
621         view
622         returns (uint256)
623     {
624         return transactions.length;
625     }
626 	
627 	/**
628      * @dev wrapper to call the encoded transactions on downstream consumers.
629      * @param destination Address of destination contract.
630      * @param data The encoded data payload.
631      * @return True on success
632      */
633 
634     function externalCall(address destination, bytes memory data)
635         internal
636         returns (bool)
637     {
638         bool result;
639         assembly {  // solhint-disable-line no-inline-assembly
640             // "Allocate" memory for output
641             // (0x40 is where "free memory" pointer is stored by convention)
642             let outputAddress := mload(0x40)
643 
644             // First 32 bytes are the padded length of data, so exclude that
645             let dataAddress := add(data, 32)
646 
647             result := call(
648                 // 34710 is the value that solidity is currently emitting
649                 // It includes callGas (700) + callVeryLow (3, to pay for SUB)
650                 // + callValueTransferGas (9000) + callNewAccountGas
651                 // (25000, in case the destination address does not exist and needs creating)
652                 sub(gas, 34710),
653 
654 
655                 destination,
656                 0, // transfer value in wei
657                 dataAddress,
658                 mload(data),  // Size of the input, in bytes. Stored in position 0 of the array.
659                 outputAddress,
660                 0  // Output is ignored, therefore the output size is zero
661             )
662         }
663         return result;
664     }
665 }