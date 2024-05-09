1 // SPDX-License-Identifier: MIT
2 
3 /* 
4 
5     _    __  __ ____  _     _____ ____       _     _       _       
6    / \  |  \/  |  _ \| |   | ____/ ___| ___ | | __| |     (_) ___  
7   / _ \ | |\/| | |_) | |   |  _|| |  _ / _ \| |/ _` |     | |/ _ \ 
8  / ___ \| |  | |  __/| |___| |__| |_| | (_) | | (_| |  _  | | (_) |
9 /_/   \_\_|  |_|_|   |_____|_____\____|\___/|_|\__,_| (_) |_|\___/ 
10                                 
11 
12     Ample Gold $AMPLG is a goldpegged defi protocol that is based on Ampleforths elastic tokensupply model. 
13     AMPLG is designed to maintain its base price target of 0.01g of Gold with a progammed inflation adjustment (rebase).
14     
15     Forked from Ampleforth: https://github.com/ampleforth/uFragments (Credits to Ampleforth team for implementation of rebasing on the ethereum network)
16     
17     GPL 3.0 license
18     
19     AMPLG.sol - AMPLG ERC20 Token
20   
21 */
22 
23 pragma solidity ^0.4.24;
24 
25 contract Initializable {
26 
27   bool private initialized;
28   bool private initializing;
29 
30   modifier initializer() {
31     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
32 
33     bool wasInitializing = initializing;
34     initializing = true;
35     initialized = true;
36 
37     _;
38 
39     initializing = wasInitializing;
40   }
41 
42   function isConstructor() private view returns (bool) {
43     uint256 cs;
44     assembly { cs := extcodesize(address) }
45     return cs == 0;
46   }
47 
48   uint256[50] private ______gap;
49 }
50 
51 contract Ownable is Initializable {
52 
53   address private _owner;
54   uint256 private _ownershipLocked;
55 
56   event OwnershipLocked(address lockedOwner);
57   event OwnershipRenounced(address indexed previousOwner);
58   event OwnershipTransferred(
59     address indexed previousOwner,
60     address indexed newOwner
61   );
62 
63 
64   function initialize(address sender) internal initializer {
65     _owner = sender;
66   _ownershipLocked = 0;
67   }
68 
69   function owner() public view returns(address) {
70     return _owner;
71   }
72 
73   modifier onlyOwner() {
74     require(isOwner());
75     _;
76   }
77 
78   function isOwner() public view returns(bool) {
79     return msg.sender == _owner;
80   }
81 
82   function transferOwnership(address newOwner) public onlyOwner {
83     _transferOwnership(newOwner);
84   }
85 
86   function _transferOwnership(address newOwner) internal {
87     require(_ownershipLocked == 0);
88     require(newOwner != address(0));
89     emit OwnershipTransferred(_owner, newOwner);
90     _owner = newOwner;
91   }
92   
93   // Set _ownershipLocked flag to lock contract owner forever
94   function lockOwnership() public onlyOwner {
95   require(_ownershipLocked == 0);
96   emit OwnershipLocked(_owner);
97     _ownershipLocked = 1;
98   }
99 
100   uint256[50] private ______gap;
101 }
102 
103 interface IERC20 {
104   function totalSupply() external view returns (uint256);
105 
106   function balanceOf(address who) external view returns (uint256);
107 
108   function allowance(address owner, address spender)
109     external view returns (uint256);
110 
111   function transfer(address to, uint256 value) external returns (bool);
112 
113   function approve(address spender, uint256 value)
114     external returns (bool);
115 
116   function transferFrom(address from, address to, uint256 value)
117     external returns (bool);
118 
119   event Transfer(
120     address indexed from,
121     address indexed to,
122     uint256 value
123   );
124 
125   event Approval(
126     address indexed owner,
127     address indexed spender,
128     uint256 value
129   );
130 }
131 
132 contract ERC20Detailed is Initializable, IERC20 {
133   string private _name;
134   string private _symbol;
135   uint8 private _decimals;
136 
137   function initialize(string name, string symbol, uint8 decimals) internal initializer {
138     _name = name;
139     _symbol = symbol;
140     _decimals = decimals;
141   }
142 
143   function name() public view returns(string) {
144     return _name;
145   }
146 
147   function symbol() public view returns(string) {
148     return _symbol;
149   }
150 
151   function decimals() public view returns(uint8) {
152     return _decimals;
153   }
154 
155   uint256[50] private ______gap;
156 }
157 
158 library SafeMath {
159 
160     function add(uint256 a, uint256 b) internal pure returns (uint256) {
161         uint256 c = a + b;
162         require(c >= a, "SafeMath: addition overflow");
163 
164         return c;
165     }
166 
167     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
168         return sub(a, b, "SafeMath: subtraction overflow");
169     }
170 
171     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
172         require(b <= a, errorMessage);
173         uint256 c = a - b;
174 
175         return c;
176     }
177 
178     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
179         if (a == 0) {
180             return 0;
181         }
182 
183         uint256 c = a * b;
184         require(c / a == b, "SafeMath: multiplication overflow");
185 
186         return c;
187     }
188 
189     function div(uint256 a, uint256 b) internal pure returns (uint256) {
190         return div(a, b, "SafeMath: division by zero");
191     }
192 
193     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
194         require(b > 0, errorMessage);
195         uint256 c = a / b;
196 
197         return c;
198     }
199 
200     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
201         return mod(a, b, "SafeMath: modulo by zero");
202     }
203 
204     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
205         require(b != 0, errorMessage);
206         return a % b;
207     }
208 }
209 
210 /*
211 MIT License
212 
213 Copyright (c) 2018 requestnetwork
214 Copyright (c) 2018 Fragments, Inc.
215 
216 Permission is hereby granted, free of charge, to any person obtaining a copy
217 of this software and associated documentation files (the "Software"), to deal
218 in the Software without restriction, including without limitation the rights
219 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
220 copies of the Software, and to permit persons to whom the Software is
221 furnished to do so, subject to the following conditions:
222 
223 The above copyright notice and this permission notice shall be included in all
224 copies or substantial portions of the Software.
225 
226 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
227 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
228 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
229 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
230 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
231 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
232 SOFTWARE.
233 */
234 
235 library SafeMathInt {
236 
237     int256 private constant MIN_INT256 = int256(1) << 255;
238     int256 private constant MAX_INT256 = ~(int256(1) << 255);
239 
240     function mul(int256 a, int256 b)
241         internal
242         pure
243         returns (int256)
244     {
245         int256 c = a * b;
246 
247         // Detect overflow when multiplying MIN_INT256 with -1
248         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
249         require((b == 0) || (c / b == a));
250         return c;
251     }
252 
253     function div(int256 a, int256 b)
254         internal
255         pure
256         returns (int256)
257     {
258         // Prevent overflow when dividing MIN_INT256 by -1
259         require(b != -1 || a != MIN_INT256);
260 
261         // Solidity already throws when dividing by 0.
262         return a / b;
263     }
264 
265     function sub(int256 a, int256 b)
266         internal
267         pure
268         returns (int256)
269     {
270         int256 c = a - b;
271         require((b >= 0 && c <= a) || (b < 0 && c > a));
272         return c;
273     }
274 
275     function add(int256 a, int256 b)
276         internal
277         pure
278         returns (int256)
279     {
280         int256 c = a + b;
281         require((b >= 0 && c >= a) || (b < 0 && c < a));
282         return c;
283     }
284 
285     function abs(int256 a)
286         internal
287         pure
288         returns (int256)
289     {
290         require(a != MIN_INT256);
291         return a < 0 ? -a : a;
292     }
293 }
294 
295 contract AMPLGToken is Ownable, ERC20Detailed {
296 
297     //AmpleGold $AMPLG
298 
299     //AmpleGold (code name AMPLG) is a goldpegged defi protocol that is based on Ampleforths elastic tokensupply model. AMPLG is designed to maintain its base price target of 0.01g of Gold with a progammed inflation adjustment (rebase).
300     
301     //Where Ampleforth rose to a 300m mcap in merely weeks, there were a couple of flaws in their model. We have remodeled and reprogrammed these flaws into a new version of the ample defi protocol.
302 
303     //We are all about decentralization and one thing we distrust most is the current economic fiat system. When the current financial system collapses and the dollar crashes, we strive to remain truly stable by pegging our token to the goldprice. Where 1 AMPLG = 0.01gram of Gold.
304 
305     //Also there were issues with the rebasing protocol. Because its always at a fixed time and date, there was huge volatility right before and after each rebase caused by bots, algorithms and traders. This has been tackled by RMPL and has been implemented in AMPLG. WE do this by using a randomized rebase event, that triggers an average of 365 times a year but at at random times.
306 
307     using SafeMath for uint256;
308     using SafeMathInt for int256;
309 
310     event LogRebasePaused(bool paused);
311     event LogTokenPaused(bool paused);
312 
313     event LogGoldPolicyUpdated(address goldPolicy);
314 
315     // Used for authentication
316     address public goldPolicy;
317 
318     modifier onlyGoldPolicy() {
319         require(msg.sender == goldPolicy);
320         _;
321     }
322 
323   struct Transaction {
324         bool enabled;
325         address destination;
326         bytes data;
327     }
328 
329     event TransactionFailed(address indexed destination, uint index, bytes data);
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
341      // Precautionary emergency controls.
342     bool public rebasePaused;
343     bool public tokenPaused;
344 
345     modifier whenRebaseNotPaused() {
346         require(!rebasePaused);
347         _;
348     }
349 
350     modifier whenTokenNotPaused() {
351         require(!tokenPaused);
352         _;
353     }
354 
355     uint256 private constant DECIMALS = 9;
356     uint256 private constant MAX_UINT256 = ~uint256(0);
357     uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 30 * 10**5 * 10**DECIMALS;
358 
359     // TOTAL_GONS is a multiple of INITIAL_FRAGMENTS_SUPPLY so that _gonsPerFragment is an integer.
360     // Use the highest value that fits in a uint256 for max granularity.
361     uint256 private constant TOTAL_GONS = MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);
362 
363     // MAX_SUPPLY = maximum integer < (sqrt(4*TOTAL_GONS + 1) - 1) / 2
364     uint256 private constant MAX_SUPPLY = ~uint128(0);  // (2^128) - 1
365   
366     uint256 private _epoch;
367 
368     uint256 private _totalSupply;
369     uint256 private _gonsPerFragment;
370     mapping(address => uint256) private _gonBalances;
371   
372     // This is denominated in Fragments, because the gons-fragments conversion might change before
373     // it's fully paid.
374     mapping (address => mapping (address => uint256)) private _allowedFragments;
375 
376     /**
377      * @param _goldPolicy The address of the AMPLG $AMPLG Gold policy contract to use for authentication.
378      */
379     function setGoldPolicy(address _goldPolicy)
380         external
381         onlyOwner
382     {
383         goldPolicy = _goldPolicy;
384         emit LogGoldPolicyUpdated(_goldPolicy);
385     }
386 
387     /**
388      * @dev Pauses or unpauses the execution of rebase operations.
389      * @param paused Pauses rebase operations if this is true.
390      */
391     function setRebasePaused(bool paused)
392         external
393         onlyOwner
394     {
395         rebasePaused = paused;
396         emit LogRebasePaused(paused);
397     }
398 
399     /**
400      * @dev Pauses or unpauses execution of ERC-20 transactions.
401      * @param paused Pauses ERC-20 transactions if this is true.
402      */
403     function setTokenPaused(bool paused)
404         external
405         onlyOwner
406     {
407         tokenPaused = paused;
408         emit LogTokenPaused(paused);
409     }
410 
411   /**
412      * @dev Notifies Fragments contract about a new rebase cycle.
413      * @param supplyDelta The number of new fragment tokens to add into circulation via expansion.
414      * @return The total number of fragments after the supply adjustment.
415      */
416     function rebase(int256 supplyDelta)
417         external
418         onlyOwner
419         returns (uint256)
420     { 
421         _epoch = _epoch.add(1);
422     
423         if (supplyDelta == 0) {
424             emit LogRebase(_epoch, _totalSupply);
425             return _totalSupply;
426         }
427 
428         if (supplyDelta < 0) {
429             _totalSupply = _totalSupply.sub(uint256(supplyDelta.abs()));
430         } else {
431             _totalSupply = _totalSupply.add(uint256(supplyDelta));
432         }
433 
434         if (_totalSupply > MAX_SUPPLY) {
435             _totalSupply = MAX_SUPPLY;
436         }
437 
438         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
439  
440         emit LogRebase(_epoch, _totalSupply);
441 
442         for (uint i = 0; i < transactions.length; i++) {
443               Transaction storage t = transactions[i];
444               if (t.enabled) {
445                   bool result = externalCall(t.destination, t.data);
446                   if (!result) {
447                       emit TransactionFailed(t.destination, i, t.data);
448                       revert("Transaction Failed");
449                   }
450               }
451           }
452     
453         return _totalSupply;
454     }
455     
456      /**
457      * @dev Notifies Fragments contract about a new rebase cycle.
458      * @param supplyDelta The number of new fragment tokens to add into circulation via expansion.
459      * @return The total number of fragments after the supply adjustment.
460      */
461     function rebaseGold(uint256 epoch, int256 supplyDelta)
462         external
463         onlyGoldPolicy
464         returns (uint256)
465     {
466         if (supplyDelta == 0) {
467             emit LogRebase(epoch, _totalSupply);
468             return _totalSupply;
469         }
470 
471         if (supplyDelta < 0) {
472             _totalSupply = _totalSupply.sub(uint256(supplyDelta.abs()));
473         } else {
474             _totalSupply = _totalSupply.add(uint256(supplyDelta));
475         }
476 
477         if (_totalSupply > MAX_SUPPLY) {
478             _totalSupply = MAX_SUPPLY;
479         }
480 
481         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
482 
483         emit LogRebase(epoch, _totalSupply);
484         return _totalSupply;
485     }
486 
487   constructor(address _goldPolicy) public {
488   
489     Ownable.initialize(msg.sender);
490     ERC20Detailed.initialize("Ample Gold", "AMPLG", uint8(DECIMALS));
491 
492         rebasePaused = false;
493         tokenPaused = false;
494         
495         _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
496         _gonBalances[msg.sender] = TOTAL_GONS;
497         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
498 
499         goldPolicy = _goldPolicy;
500 
501         emit Transfer(address(0x0), msg.sender, _totalSupply);
502     }
503   
504   /**
505      * @return The total number of fragments.
506      */
507 
508     function totalSupply()  
509     public
510     view
511         returns (uint256)
512     {
513         return _totalSupply;
514     }
515   
516   /**
517      * @param who The address to query.
518      * @return The balance of the specified address.
519      */
520 
521     function balanceOf(address who)
522         public
523         view
524         returns (uint256)
525     {
526         return _gonBalances[who].div(_gonsPerFragment);
527     }
528 
529   /**
530      * @dev Transfer tokens to a specified address.
531      * @param to The address to transfer to.
532      * @param value The amount to be transferred.
533      * @return True on success, false otherwise.
534      */
535    
536     function transfer(address to, uint256 value)
537         public
538         whenTokenNotPaused
539         validRecipient(to)
540         returns (bool)
541     {
542         uint256 merValue = value.mul(_gonsPerFragment);
543         _gonBalances[msg.sender] = _gonBalances[msg.sender].sub(merValue);
544         _gonBalances[to] = _gonBalances[to].add(merValue);
545         emit Transfer(msg.sender, to, value);
546         return true;
547     }
548 
549   /**
550      * @dev Function to check the amount of tokens that an owner has allowed to a spender.
551      * @param owner_ The address which owns the funds.
552      * @param spender The address which will spend the funds.
553      * @return The number of tokens still available for the spender.
554      */
555    
556     function allowance(address owner_, address spender)
557         public
558         view
559         returns (uint256)
560     {
561         return _allowedFragments[owner_][spender];
562     }
563   
564   /**
565      * @dev Transfer tokens from one address to another.
566      * @param from The address you want to send tokens from.
567      * @param to The address you want to transfer to.
568      * @param value The amount of tokens to be transferred.
569      */
570 
571     function transferFrom(address from, address to, uint256 value)
572         public
573         whenTokenNotPaused
574         validRecipient(to)
575         returns (bool)
576     {
577         _allowedFragments[from][msg.sender] = _allowedFragments[from][msg.sender].sub(value);
578 
579         uint256 merValue = value.mul(_gonsPerFragment);
580         _gonBalances[from] = _gonBalances[from].sub(merValue);
581         _gonBalances[to] = _gonBalances[to].add(merValue);
582         emit Transfer(from, to, value);
583 
584         return true;
585     }
586   
587   /**
588      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
589      * msg.sender. This method is included for ERC20 compatibility.
590      * increaseAllowance and decreaseAllowance should be used instead.
591      * Changing an allowance with this method brings the risk that someone may transfer both
592      * the old and the new allowance - if they are both greater than zero - if a transfer
593      * transaction is mined before the later approve() call is mined.
594      *
595      * @param spender The address which will spend the funds.
596      * @param value The amount of tokens to be spent.
597      */
598 
599     function approve(address spender, uint256 value)
600         public
601         whenTokenNotPaused
602         returns (bool)
603     {
604         _allowedFragments[msg.sender][spender] = value;
605         emit Approval(msg.sender, spender, value);
606         return true;
607     }
608   
609   /**
610      * @dev Increase the amount of tokens that an owner has allowed to a spender.
611      * This method should be used instead of approve() to avoid the double approval vulnerability
612      * described above.
613      * @param spender The address which will spend the funds.
614      * @param addedValue The amount of tokens to increase the allowance by.
615      */
616 
617     function increaseAllowance(address spender, uint256 addedValue)
618         public
619         whenTokenNotPaused
620         returns (bool)
621     {
622         _allowedFragments[msg.sender][spender] =
623             _allowedFragments[msg.sender][spender].add(addedValue);
624         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
625         return true;
626     }
627   
628   /**
629      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
630      *
631      * @param spender The address which will spend the funds.
632      * @param subtractedValue The amount of tokens to decrease the allowance by.
633      */
634 
635     function decreaseAllowance(address spender, uint256 subtractedValue)
636         public
637         whenTokenNotPaused
638         returns (bool)
639     {
640         uint256 oldValue = _allowedFragments[msg.sender][spender];
641         if (subtractedValue >= oldValue) {
642             _allowedFragments[msg.sender][spender] = 0;
643         } else {
644             _allowedFragments[msg.sender][spender] = oldValue.sub(subtractedValue);
645         }
646         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
647         return true;
648     }
649   
650   /**
651      * @notice Adds a transaction that gets called for a downstream receiver of rebases
652      * @param destination Address of contract destination
653      * @param data Transaction data payload
654      */
655   
656     function addTransaction(address destination, bytes data)
657         external
658         onlyOwner
659     {
660         transactions.push(Transaction({
661             enabled: true,
662             destination: destination,
663             data: data
664         }));
665     }
666   
667   /**
668      * @param index Index of transaction to remove.
669      *              Transaction ordering may have changed since adding.
670      */
671 
672     function removeTransaction(uint index)
673         external
674         onlyOwner
675     {
676         require(index < transactions.length, "index out of bounds");
677 
678         if (index < transactions.length - 1) {
679             transactions[index] = transactions[transactions.length - 1];
680         }
681 
682         transactions.length--;
683     }
684   
685   /**
686      * @param index Index of transaction. Transaction ordering may have changed since adding.
687      * @param enabled True for enabled, false for disabled.
688      */
689 
690     function setTransactionEnabled(uint index, bool enabled)
691         external
692         onlyOwner
693     {
694         require(index < transactions.length, "index must be in range of stored tx list");
695         transactions[index].enabled = enabled;
696     }
697   
698   /**
699      * @return Number of transactions, both enabled and disabled, in transactions list.
700      */
701 
702     function transactionsSize()
703         external
704         view
705         returns (uint256)
706     {
707         return transactions.length;
708     }
709   
710   /**
711      * @dev wrapper to call the encoded transactions on downstream consumers.
712      * @param destination Address of destination contract.
713      * @param data The encoded data payload.
714      * @return True on success
715      */
716 
717     function externalCall(address destination, bytes data)
718         internal
719         returns (bool)
720     {
721         bool result;
722         assembly {  // solhint-disable-line no-inline-assembly
723             // "Allocate" memory for output
724             // (0x40 is where "free memory" pointer is stored by convention)
725             let outputAddress := mload(0x40)
726 
727             // First 32 bytes are the padded length of data, so exclude that
728             let dataAddress := add(data, 32)
729 
730             result := call(
731                 // 34710 is the value that solidity is currently emitting
732                 // It includes callGas (700) + callVeryLow (3, to pay for SUB)
733                 // + callValueTransferGas (9000) + callNewAccountGas
734                 // (25000, in case the destination address does not exist and needs creating)
735                 sub(gas, 34710),
736 
737 
738                 destination,
739                 0, // transfer value in wei
740                 dataAddress,
741                 mload(data),  // Size of the input, in bytes. Stored in position 0 of the array.
742                 outputAddress,
743                 0  // Output is ignored, therefore the output size is zero
744             )
745         }
746         return result;
747     }
748 }