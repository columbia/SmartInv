1 pragma solidity ^0.4.11;
2 
3 
4 /// @dev `Owned` is a base level contract that assigns an `owner` that can be
5 ///  later changed
6 contract Owned {
7 
8     /// @dev `owner` is the only address that can call a function with this
9     /// modifier
10     modifier onlyOwner() {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     address public owner;
16 
17     /// @notice The Constructor assigns the message sender to be `owner`
18     function Owned() {
19         owner = msg.sender;
20     }
21 
22     address public newOwner;
23 
24     /// @notice `owner` can step down and assign some other address to this role
25     /// @param _newOwner The address of the new owner. 0x0 can be used to create
26     ///  an unowned neutral vault, however that cannot be undone
27     function changeOwner(address _newOwner) onlyOwner {
28         newOwner = _newOwner;
29     }
30 
31 
32     function acceptOwnership() {
33         if (msg.sender == newOwner) {
34             owner = newOwner;
35         }
36     }
37 }
38 
39 // Abstract contract for the full ERC 20 Token standard
40 // https://github.com/ethereum/EIPs/issues/20
41 
42 contract ERC20Token {
43     /* This is a slight change to the ERC20 base standard.
44     function totalSupply() constant returns (uint256 supply);
45     is replaced with:
46     uint256 public totalSupply;
47     This automatically creates a getter function for the totalSupply.
48     This is moved to the base contract since public getter functions are not
49     currently recognised as an implementation of the matching abstract
50     function by the compiler.
51     */
52     /// total amount of tokens
53     uint256 public totalSupply;
54 
55     /// @param _owner The address from which the balance will be retrieved
56     /// @return The balance
57     function balanceOf(address _owner) constant returns (uint256 balance);
58 
59     /// @notice send `_value` token to `_to` from `msg.sender`
60     /// @param _to The address of the recipient
61     /// @param _value The amount of token to be transferred
62     /// @return Whether the transfer was successful or not
63     function transfer(address _to, uint256 _value) returns (bool success);
64 
65     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
66     /// @param _from The address of the sender
67     /// @param _to The address of the recipient
68     /// @param _value The amount of token to be transferred
69     /// @return Whether the transfer was successful or not
70     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
71 
72     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
73     /// @param _spender The address of the account able to transfer the tokens
74     /// @param _value The amount of tokens to be approved for transfer
75     /// @return Whether the approval was successful or not
76     function approve(address _spender, uint256 _value) returns (bool success);
77 
78     /// @param _owner The address of the account owning tokens
79     /// @param _spender The address of the account able to transfer the tokens
80     /// @return Amount of remaining tokens allowed to spent
81     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
82 
83     event Transfer(address indexed _from, address indexed _to, uint256 _value);
84     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
85 }
86 
87 
88 
89 /**
90  * Math operations with safety checks
91  */
92 library SafeMath {
93   function mul(uint a, uint b) internal returns (uint) {
94     uint c = a * b;
95     assert(a == 0 || c / a == b);
96     return c;
97   }
98 
99   function div(uint a, uint b) internal returns (uint) {
100     // assert(b > 0); // Solidity automatically throws when dividing by 0
101     uint c = a / b;
102     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
103     return c;
104   }
105 
106   function sub(uint a, uint b) internal returns (uint) {
107     assert(b <= a);
108     return a - b;
109   }
110 
111   function add(uint a, uint b) internal returns (uint) {
112     uint c = a + b;
113     assert(c >= a);
114     return c;
115   }
116 
117   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
118     return a >= b ? a : b;
119   }
120 
121   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
122     return a < b ? a : b;
123   }
124 
125   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
126     return a >= b ? a : b;
127   }
128 
129   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
130     return a < b ? a : b;
131   }
132 }
133 
134 
135 /*
136     Copyright 2017, Jordi Baylina
137 
138     This program is free software: you can redistribute it and/or modify
139     it under the terms of the GNU General Public License as published by
140     the Free Software Foundation, either version 3 of the License, or
141     (at your option) any later version.
142 
143     This program is distributed in the hope that it will be useful,
144     but WITHOUT ANY WARRANTY; without even the implied warranty of
145     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
146     GNU General Public License for more details.
147 
148     You should have received a copy of the GNU General Public License
149     along with this program.  If not, see <http://www.gnu.org/licenses/>.
150  */
151 
152 /// @title DynamicCeiling Contract
153 /// @author Jordi Baylina
154 /// @dev This contract calculates the ceiling from a series of curves.
155 ///  These curves are committed first and revealed later.
156 ///  All the curves must be in increasing order and the last curve is marked
157 ///  as the last one.
158 ///  This contract allows to hide and reveal the ceiling at will of the owner.
159 
160 
161 
162 contract DynamicCeiling is Owned {
163     using SafeMath for uint256;
164 
165     struct Curve {
166         bytes32 hash;
167         // Absolute limit for this curve
168         uint256 limit;
169         // The funds remaining to be collected are divided by `slopeFactor` smooth ceiling
170         // with a long tail where big and small buyers can take part.
171         uint256 slopeFactor;
172         // This keeps the curve flat at this number, until funds to be collected is less than this
173         uint256 collectMinimum;
174     }
175 
176     address public contribution;
177 
178     Curve[] public curves;
179     uint256 public currentIndex;
180     uint256 public revealedCurves;
181     bool public allRevealed;
182 
183     /// @dev `contribution` is the only address that can call a function with this
184     /// modifier
185     modifier onlyContribution {
186         require(msg.sender == contribution);
187         _;
188     }
189 
190     function DynamicCeiling(address _owner, address _contribution) {
191         owner = _owner;
192         contribution = _contribution;
193     }
194 
195     /// @notice This should be called by the creator of the contract to commit
196     ///  all the curves.
197     /// @param _curveHashes Array of hashes of each curve. Each hash is calculated
198     ///  by the `calculateHash` method. More hashes than actual curves can be
199     ///  committed in order to hide also the number of curves.
200     ///  The remaining hashes can be just random numbers.
201     function setHiddenCurves(bytes32[] _curveHashes) public onlyOwner {
202         require(curves.length == 0);
203 
204         curves.length = _curveHashes.length;
205         for (uint256 i = 0; i < _curveHashes.length; i = i.add(1)) {
206             curves[i].hash = _curveHashes[i];
207         }
208     }
209 
210 
211     /// @notice Anybody can reveal the next curve if he knows it.
212     /// @param _limit Ceiling cap.
213     ///  (must be greater or equal to the previous one).
214     /// @param _last `true` if it's the last curve.
215     /// @param _salt Random number used to commit the curve
216     function revealCurve(uint256 _limit, uint256 _slopeFactor, uint256 _collectMinimum,
217                          bool _last, bytes32 _salt) public {
218         require(!allRevealed);
219 
220         require(curves[revealedCurves].hash == calculateHash(_limit, _slopeFactor, _collectMinimum,
221                                                              _last, _salt));
222 
223         require(_limit != 0 && _slopeFactor != 0 && _collectMinimum != 0);
224         if (revealedCurves > 0) {
225             require(_limit >= curves[revealedCurves.sub(1)].limit);
226         }
227 
228         curves[revealedCurves].limit = _limit;
229         curves[revealedCurves].slopeFactor = _slopeFactor;
230         curves[revealedCurves].collectMinimum = _collectMinimum;
231         revealedCurves = revealedCurves.add(1);
232 
233         if (_last) allRevealed = true;
234     }
235 
236     /// @notice Reveal multiple curves at once
237     function revealMulti(uint256[] _limits, uint256[] _slopeFactors, uint256[] _collectMinimums,
238                          bool[] _lasts, bytes32[] _salts) public {
239         // Do not allow none and needs to be same length for all parameters
240         require(_limits.length != 0 &&
241                 _limits.length == _slopeFactors.length &&
242                 _limits.length == _collectMinimums.length &&
243                 _limits.length == _lasts.length &&
244                 _limits.length == _salts.length);
245 
246         for (uint256 i = 0; i < _limits.length; i = i.add(1)) {
247             revealCurve(_limits[i], _slopeFactors[i], _collectMinimums[i],
248                         _lasts[i], _salts[i]);
249         }
250     }
251 
252     /// @notice Move to curve, used as a failsafe
253     function moveTo(uint256 _index) public onlyOwner {
254         require(_index < revealedCurves &&       // No more curves
255                 _index == currentIndex.add(1));  // Only move one index at a time
256         currentIndex = _index;
257     }
258 
259     /// @return Return the funds to collect for the current point on the curve
260     ///  (or 0 if no curves revealed yet)
261     function toCollect(uint256 collected) public onlyContribution returns (uint256) {
262         if (revealedCurves == 0) return 0;
263 
264         // Move to the next curve
265         if (collected >= curves[currentIndex].limit) {  // Catches `limit == 0`
266             uint256 nextIndex = currentIndex.add(1);
267             if (nextIndex >= revealedCurves) return 0;  // No more curves
268             currentIndex = nextIndex;
269             if (collected >= curves[currentIndex].limit) return 0;  // Catches `limit == 0`
270         }
271 
272         // Everything left to collect from this limit
273         uint256 difference = curves[currentIndex].limit.sub(collected);
274 
275         // Current point on the curve
276         uint256 collect = difference.div(curves[currentIndex].slopeFactor);
277 
278         // Prevents paying too much fees vs to be collected; breaks long tail
279         if (collect <= curves[currentIndex].collectMinimum) {
280             if (difference > curves[currentIndex].collectMinimum) {
281                 return curves[currentIndex].collectMinimum;
282             } else {
283                 return difference;
284             }
285         } else {
286             return collect;
287         }
288     }
289 
290     /// @notice Calculates the hash of a curve.
291     /// @param _limit Ceiling cap.
292     /// @param _last `true` if it's the last curve.
293     /// @param _salt Random number that will be needed to reveal this curve.
294     /// @return The calculated hash of this curve to be used in the `setHiddenCurves` method
295     function calculateHash(uint256 _limit, uint256 _slopeFactor, uint256 _collectMinimum,
296                            bool _last, bytes32 _salt) public constant returns (bytes32) {
297         return keccak256(_limit, _slopeFactor, _collectMinimum, _last, _salt);
298     }
299 
300     /// @return Return the total number of curves committed
301     ///  (can be larger than the number of actual curves on the curve to hide
302     ///  the real number of curves)
303     function nCurves() public constant returns (uint256) {
304         return curves.length;
305     }
306 
307 }
308 
309 
310 /*
311     Copyright 2016, Jordi Baylina
312 
313     This program is free software: you can redistribute it and/or modify
314     it under the terms of the GNU General Public License as published by
315     the Free Software Foundation, either version 3 of the License, or
316     (at your option) any later version.
317 
318     This program is distributed in the hope that it will be useful,
319     but WITHOUT ANY WARRANTY; without even the implied warranty of
320     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
321     GNU General Public License for more details.
322 
323     You should have received a copy of the GNU General Public License
324     along with this program.  If not, see <http://www.gnu.org/licenses/>.
325  */
326 
327 /// @title MiniMeToken Contract
328 /// @author Jordi Baylina
329 /// @dev This token contract's goal is to make it easy for anyone to clone this
330 ///  token using the token distribution at a given block, this will allow DAO's
331 ///  and DApps to upgrade their features in a decentralized manner without
332 ///  affecting the original token
333 /// @dev It is ERC20 compliant, but still needs to under go further testing.
334 
335 
336 /// @dev The token controller contract must implement these functions
337 contract TokenController {
338     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
339     /// @param _owner The address that sent the ether to create tokens
340     /// @return True if the ether is accepted, false if it throws
341     function proxyPayment(address _owner) payable returns(bool);
342 
343     /// @notice Notifies the controller about a token transfer allowing the
344     ///  controller to react if desired
345     /// @param _from The origin of the transfer
346     /// @param _to The destination of the transfer
347     /// @param _amount The amount of the transfer
348     /// @return False if the controller does not authorize the transfer
349     function onTransfer(address _from, address _to, uint _amount) returns(bool);
350 
351     /// @notice Notifies the controller about an approval allowing the
352     ///  controller to react if desired
353     /// @param _owner The address that calls `approve()`
354     /// @param _spender The spender in the `approve()` call
355     /// @param _amount The amount in the `approve()` call
356     /// @return False if the controller does not authorize the approval
357     function onApprove(address _owner, address _spender, uint _amount)
358         returns(bool);
359 }
360 
361 contract Controlled {
362     /// @notice The address of the controller is the only address that can call
363     ///  a function with this modifier
364     modifier onlyController { if (msg.sender != controller) throw; _; }
365 
366     address public controller;
367 
368     function Controlled() { controller = msg.sender;}
369 
370     /// @notice Changes the controller of the contract
371     /// @param _newController The new controller of the contract
372     function changeController(address _newController) onlyController {
373         controller = _newController;
374     }
375 }
376 
377 contract ApproveAndCallFallBack {
378     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
379 }
380 
381 /// @dev The actual token contract, the default controller is the msg.sender
382 ///  that deploys the contract, so usually this token will be deployed by a
383 ///  token controller contract, which Giveth will call a "Campaign"
384 contract MiniMeToken is Controlled {
385 
386     string public name;                //The Token's name: e.g. DigixDAO Tokens
387     uint8 public decimals;             //Number of decimals of the smallest unit
388     string public symbol;              //An identifier: e.g. REP
389     string public version = 'MMT_0.1'; //An arbitrary versioning scheme
390 
391 
392     /// @dev `Checkpoint` is the structure that attaches a block number to a
393     ///  given value, the block number attached is the one that last changed the
394     ///  value
395     struct  Checkpoint {
396 
397         // `fromBlock` is the block number that the value was generated from
398         uint128 fromBlock;
399 
400         // `value` is the amount of tokens at a specific block number
401         uint128 value;
402     }
403 
404     // `parentToken` is the Token address that was cloned to produce this token;
405     //  it will be 0x0 for a token that was not cloned
406     MiniMeToken public parentToken;
407 
408     // `parentSnapShotBlock` is the block number from the Parent Token that was
409     //  used to determine the initial distribution of the Clone Token
410     uint public parentSnapShotBlock;
411 
412     // `creationBlock` is the block number that the Clone Token was created
413     uint public creationBlock;
414 
415     // `balances` is the map that tracks the balance of each address, in this
416     //  contract when the balance changes the block number that the change
417     //  occurred is also included in the map
418     mapping (address => Checkpoint[]) balances;
419 
420     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
421     mapping (address => mapping (address => uint256)) allowed;
422 
423     // Tracks the history of the `totalSupply` of the token
424     Checkpoint[] totalSupplyHistory;
425 
426     // Flag that determines if the token is transferable or not.
427     bool public transfersEnabled;
428 
429     // The factory used to create new clone tokens
430     MiniMeTokenFactory public tokenFactory;
431 
432 ////////////////
433 // Constructor
434 ////////////////
435 
436     /// @notice Constructor to create a MiniMeToken
437     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
438     ///  will create the Clone token contracts, the token factory needs to be
439     ///  deployed first
440     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
441     ///  new token
442     /// @param _parentSnapShotBlock Block of the parent token that will
443     ///  determine the initial distribution of the clone token, set to 0 if it
444     ///  is a new token
445     /// @param _tokenName Name of the new token
446     /// @param _decimalUnits Number of decimals of the new token
447     /// @param _tokenSymbol Token Symbol for the new token
448     /// @param _transfersEnabled If true, tokens will be able to be transferred
449     function MiniMeToken(
450         address _tokenFactory,
451         address _parentToken,
452         uint _parentSnapShotBlock,
453         string _tokenName,
454         uint8 _decimalUnits,
455         string _tokenSymbol,
456         bool _transfersEnabled
457     ) {
458         tokenFactory = MiniMeTokenFactory(_tokenFactory);
459         name = _tokenName;                                 // Set the name
460         decimals = _decimalUnits;                          // Set the decimals
461         symbol = _tokenSymbol;                             // Set the symbol
462         parentToken = MiniMeToken(_parentToken);
463         parentSnapShotBlock = _parentSnapShotBlock;
464         transfersEnabled = _transfersEnabled;
465         creationBlock = getBlockNumber();
466     }
467 
468 
469 ///////////////////
470 // ERC20 Methods
471 ///////////////////
472 
473     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
474     /// @param _to The address of the recipient
475     /// @param _amount The amount of tokens to be transferred
476     /// @return Whether the transfer was successful or not
477     function transfer(address _to, uint256 _amount) returns (bool success) {
478         if (!transfersEnabled) throw;
479         return doTransfer(msg.sender, _to, _amount);
480     }
481 
482     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
483     ///  is approved by `_from`
484     /// @param _from The address holding the tokens being transferred
485     /// @param _to The address of the recipient
486     /// @param _amount The amount of tokens to be transferred
487     /// @return True if the transfer was successful
488     function transferFrom(address _from, address _to, uint256 _amount
489     ) returns (bool success) {
490 
491         // The controller of this contract can move tokens around at will,
492         //  this is important to recognize! Confirm that you trust the
493         //  controller of this contract, which in most situations should be
494         //  another open source smart contract or 0x0
495         if (msg.sender != controller) {
496             if (!transfersEnabled) throw;
497 
498             // The standard ERC 20 transferFrom functionality
499             if (allowed[_from][msg.sender] < _amount) return false;
500             allowed[_from][msg.sender] -= _amount;
501         }
502         return doTransfer(_from, _to, _amount);
503     }
504 
505     /// @dev This is the actual transfer function in the token contract, it can
506     ///  only be called by other functions in this contract.
507     /// @param _from The address holding the tokens being transferred
508     /// @param _to The address of the recipient
509     /// @param _amount The amount of tokens to be transferred
510     /// @return True if the transfer was successful
511     function doTransfer(address _from, address _to, uint _amount
512     ) internal returns(bool) {
513 
514            if (_amount == 0) {
515                return true;
516            }
517 
518            if (parentSnapShotBlock >= getBlockNumber()) throw;
519 
520            // Do not allow transfer to 0x0 or the token contract itself
521            if ((_to == 0) || (_to == address(this))) throw;
522 
523            // If the amount being transfered is more than the balance of the
524            //  account the transfer returns false
525            var previousBalanceFrom = balanceOfAt(_from, getBlockNumber());
526            if (previousBalanceFrom < _amount) {
527                return false;
528            }
529 
530            // Alerts the token controller of the transfer
531            if (isContract(controller)) {
532                if (!TokenController(controller).onTransfer(_from, _to, _amount))
533                throw;
534            }
535 
536            // First update the balance array with the new value for the address
537            //  sending the tokens
538            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
539 
540            // Then update the balance array with the new value for the address
541            //  receiving the tokens
542            var previousBalanceTo = balanceOfAt(_to, getBlockNumber());
543            if (previousBalanceTo + _amount < previousBalanceTo) throw; // Check for overflow
544            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
545 
546            // An event to make the transfer easy to find on the blockchain
547            Transfer(_from, _to, _amount);
548 
549            return true;
550     }
551 
552     /// @param _owner The address that's balance is being requested
553     /// @return The balance of `_owner` at the current block
554     function balanceOf(address _owner) constant returns (uint256 balance) {
555         return balanceOfAt(_owner, getBlockNumber());
556     }
557 
558     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
559     ///  its behalf. This is a modified version of the ERC20 approve function
560     ///  to be a little bit safer
561     /// @param _spender The address of the account able to transfer the tokens
562     /// @param _amount The amount of tokens to be approved for transfer
563     /// @return True if the approval was successful
564     function approve(address _spender, uint256 _amount) returns (bool success) {
565         if (!transfersEnabled) throw;
566 
567         // To change the approve amount you first have to reduce the addresses`
568         //  allowance to zero by calling `approve(_spender,0)` if it is not
569         //  already 0 to mitigate the race condition described here:
570         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
571         if ((_amount!=0) && (allowed[msg.sender][_spender] !=0)) throw;
572 
573         // Alerts the token controller of the approve function call
574         if (isContract(controller)) {
575             if (!TokenController(controller).onApprove(msg.sender, _spender, _amount))
576                 throw;
577         }
578 
579         allowed[msg.sender][_spender] = _amount;
580         Approval(msg.sender, _spender, _amount);
581         return true;
582     }
583 
584     /// @dev This function makes it easy to read the `allowed[]` map
585     /// @param _owner The address of the account that owns the token
586     /// @param _spender The address of the account able to transfer the tokens
587     /// @return Amount of remaining tokens of _owner that _spender is allowed
588     ///  to spend
589     function allowance(address _owner, address _spender
590     ) constant returns (uint256 remaining) {
591         return allowed[_owner][_spender];
592     }
593 
594     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
595     ///  its behalf, and then a function is triggered in the contract that is
596     ///  being approved, `_spender`. This allows users to use their tokens to
597     ///  interact with contracts in one function call instead of two
598     /// @param _spender The address of the contract able to transfer the tokens
599     /// @param _amount The amount of tokens to be approved for transfer
600     /// @return True if the function call was successful
601     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
602     ) returns (bool success) {
603         if (!approve(_spender, _amount)) throw;
604 
605         ApproveAndCallFallBack(_spender).receiveApproval(
606             msg.sender,
607             _amount,
608             this,
609             _extraData
610         );
611 
612         return true;
613     }
614 
615     /// @dev This function makes it easy to get the total number of tokens
616     /// @return The total number of tokens
617     function totalSupply() constant returns (uint) {
618         return totalSupplyAt(getBlockNumber());
619     }
620 
621 
622 ////////////////
623 // Query balance and totalSupply in History
624 ////////////////
625 
626     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
627     /// @param _owner The address from which the balance will be retrieved
628     /// @param _blockNumber The block number when the balance is queried
629     /// @return The balance at `_blockNumber`
630     function balanceOfAt(address _owner, uint _blockNumber) constant
631         returns (uint) {
632 
633         // These next few lines are used when the balance of the token is
634         //  requested before a check point was ever created for this token, it
635         //  requires that the `parentToken.balanceOfAt` be queried at the
636         //  genesis block for that token as this contains initial balance of
637         //  this token
638         if ((balances[_owner].length == 0)
639             || (balances[_owner][0].fromBlock > _blockNumber)) {
640             if (address(parentToken) != 0) {
641                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
642             } else {
643                 // Has no parent
644                 return 0;
645             }
646 
647         // This will return the expected balance during normal situations
648         } else {
649             return getValueAt(balances[_owner], _blockNumber);
650         }
651     }
652 
653     /// @notice Total amount of tokens at a specific `_blockNumber`.
654     /// @param _blockNumber The block number when the totalSupply is queried
655     /// @return The total amount of tokens at `_blockNumber`
656     function totalSupplyAt(uint _blockNumber) constant returns(uint) {
657 
658         // These next few lines are used when the totalSupply of the token is
659         //  requested before a check point was ever created for this token, it
660         //  requires that the `parentToken.totalSupplyAt` be queried at the
661         //  genesis block for this token as that contains totalSupply of this
662         //  token at this block number.
663         if ((totalSupplyHistory.length == 0)
664             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
665             if (address(parentToken) != 0) {
666                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
667             } else {
668                 return 0;
669             }
670 
671         // This will return the expected totalSupply during normal situations
672         } else {
673             return getValueAt(totalSupplyHistory, _blockNumber);
674         }
675     }
676 
677 ////////////////
678 // Clone Token Method
679 ////////////////
680 
681     /// @notice Creates a new clone token with the initial distribution being
682     ///  this token at `_snapshotBlock`
683     /// @param _cloneTokenName Name of the clone token
684     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
685     /// @param _cloneTokenSymbol Symbol of the clone token
686     /// @param _snapshotBlock Block when the distribution of the parent token is
687     ///  copied to set the initial distribution of the new clone token;
688     ///  if the block is zero than the actual block, the current block is used
689     /// @param _transfersEnabled True if transfers are allowed in the clone
690     /// @return The address of the new MiniMeToken Contract
691     function createCloneToken(
692         string _cloneTokenName,
693         uint8 _cloneDecimalUnits,
694         string _cloneTokenSymbol,
695         uint _snapshotBlock,
696         bool _transfersEnabled
697         ) returns(address) {
698         if (_snapshotBlock == 0) _snapshotBlock = getBlockNumber();
699         MiniMeToken cloneToken = tokenFactory.createCloneToken(
700             this,
701             _snapshotBlock,
702             _cloneTokenName,
703             _cloneDecimalUnits,
704             _cloneTokenSymbol,
705             _transfersEnabled
706             );
707 
708         cloneToken.changeController(msg.sender);
709 
710         // An event to make the token easy to find on the blockchain
711         NewCloneToken(address(cloneToken), _snapshotBlock);
712         return address(cloneToken);
713     }
714 
715 ////////////////
716 // Generate and destroy tokens
717 ////////////////
718 
719     /// @notice Generates `_amount` tokens that are assigned to `_owner`
720     /// @param _owner The address that will be assigned the new tokens
721     /// @param _amount The quantity of tokens generated
722     /// @return True if the tokens are generated correctly
723     function generateTokens(address _owner, uint _amount
724     ) onlyController returns (bool) {
725         uint curTotalSupply = getValueAt(totalSupplyHistory, getBlockNumber());
726         if (curTotalSupply + _amount < curTotalSupply) throw; // Check for overflow
727         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
728         var previousBalanceTo = balanceOf(_owner);
729         if (previousBalanceTo + _amount < previousBalanceTo) throw; // Check for overflow
730         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
731         Transfer(0, _owner, _amount);
732         return true;
733     }
734 
735 
736     /// @notice Burns `_amount` tokens from `_owner`
737     /// @param _owner The address that will lose the tokens
738     /// @param _amount The quantity of tokens to burn
739     /// @return True if the tokens are burned correctly
740     function destroyTokens(address _owner, uint _amount
741     ) onlyController returns (bool) {
742         uint curTotalSupply = getValueAt(totalSupplyHistory, getBlockNumber());
743         if (curTotalSupply < _amount) throw;
744         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
745         var previousBalanceFrom = balanceOf(_owner);
746         if (previousBalanceFrom < _amount) throw;
747         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
748         Transfer(_owner, 0, _amount);
749         return true;
750     }
751 
752 ////////////////
753 // Enable tokens transfers
754 ////////////////
755 
756 
757     /// @notice Enables token holders to transfer their tokens freely if true
758     /// @param _transfersEnabled True if transfers are allowed in the clone
759     function enableTransfers(bool _transfersEnabled) onlyController {
760         transfersEnabled = _transfersEnabled;
761     }
762 
763 ////////////////
764 // Internal helper functions to query and set a value in a snapshot array
765 ////////////////
766 
767     /// @dev `getValueAt` retrieves the number of tokens at a given block number
768     /// @param checkpoints The history of values being queried
769     /// @param _block The block number to retrieve the value at
770     /// @return The number of tokens being queried
771     function getValueAt(Checkpoint[] storage checkpoints, uint _block
772     ) constant internal returns (uint) {
773         if (checkpoints.length == 0) return 0;
774 
775         // Shortcut for the actual value
776         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
777             return checkpoints[checkpoints.length-1].value;
778         if (_block < checkpoints[0].fromBlock) return 0;
779 
780         // Binary search of the value in the array
781         uint min = 0;
782         uint max = checkpoints.length-1;
783         while (max > min) {
784             uint mid = (max + min + 1)/ 2;
785             if (checkpoints[mid].fromBlock<=_block) {
786                 min = mid;
787             } else {
788                 max = mid-1;
789             }
790         }
791         return checkpoints[min].value;
792     }
793 
794     /// @dev `updateValueAtNow` used to update the `balances` map and the
795     ///  `totalSupplyHistory`
796     /// @param checkpoints The history of data being updated
797     /// @param _value The new number of tokens
798     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
799     ) internal  {
800         if ((checkpoints.length == 0)
801         || (checkpoints[checkpoints.length -1].fromBlock < getBlockNumber())) {
802                Checkpoint newCheckPoint = checkpoints[ checkpoints.length++ ];
803                newCheckPoint.fromBlock =  uint128(getBlockNumber());
804                newCheckPoint.value = uint128(_value);
805            } else {
806                Checkpoint oldCheckPoint = checkpoints[checkpoints.length-1];
807                oldCheckPoint.value = uint128(_value);
808            }
809     }
810 
811     /// @dev Internal function to determine if an address is a contract
812     /// @param _addr The address being queried
813     /// @return True if `_addr` is a contract
814     function isContract(address _addr) constant internal returns(bool) {
815         uint size;
816         if (_addr == 0) return false;
817         assembly {
818             size := extcodesize(_addr)
819         }
820         return size>0;
821     }
822 
823     /// @dev Helper function to return a min betwen the two uints
824     function min(uint a, uint b) internal returns (uint) {
825         return a < b ? a : b;
826     }
827 
828     /// @notice The fallback function: If the contract's controller has not been
829     ///  set to 0, then the `proxyPayment` method is called which relays the
830     ///  ether and creates tokens as described in the token controller contract
831     function ()  payable {
832         if (isContract(controller)) {
833             if (! TokenController(controller).proxyPayment.value(msg.value)(msg.sender))
834                 throw;
835         } else {
836             throw;
837         }
838     }
839 
840 
841 //////////
842 // Testing specific methods
843 //////////
844 
845     /// @notice This function is overridden by the test Mocks.
846     function getBlockNumber() internal constant returns (uint256) {
847         return block.number;
848     }
849 
850 //////////
851 // Safety Methods
852 //////////
853 
854     /// @notice This method can be used by the controller to extract mistakenly
855     ///  sent tokens to this contract.
856     /// @param _token The address of the token contract that you want to recover
857     ///  set to 0 in case you want to extract ether.
858     function claimTokens(address _token) onlyController {
859         if (_token == 0x0) {
860             controller.transfer(this.balance);
861             return;
862         }
863 
864         ERC20Token token = ERC20Token(_token);
865         uint balance = token.balanceOf(this);
866         token.transfer(controller, balance);
867         ClaimedTokens(_token, controller, balance);
868     }
869 
870 ////////////////
871 // Events
872 ////////////////
873 
874     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
875     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
876     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
877     event Approval(
878         address indexed _owner,
879         address indexed _spender,
880         uint256 _amount
881         );
882 
883 }
884 
885 
886 ////////////////
887 // MiniMeTokenFactory
888 ////////////////
889 
890 /// @dev This contract is used to generate clone contracts from a contract.
891 ///  In solidity this is the way to create a contract from a contract of the
892 ///  same class
893 contract MiniMeTokenFactory {
894 
895     /// @notice Update the DApp by creating a new token with new functionalities
896     ///  the msg.sender becomes the controller of this clone token
897     /// @param _parentToken Address of the token being cloned
898     /// @param _snapshotBlock Block of the parent token that will
899     ///  determine the initial distribution of the clone token
900     /// @param _tokenName Name of the new token
901     /// @param _decimalUnits Number of decimals of the new token
902     /// @param _tokenSymbol Token Symbol for the new token
903     /// @param _transfersEnabled If true, tokens will be able to be transferred
904     /// @return The address of the new token contract
905     function createCloneToken(
906         address _parentToken,
907         uint _snapshotBlock,
908         string _tokenName,
909         uint8 _decimalUnits,
910         string _tokenSymbol,
911         bool _transfersEnabled
912     ) returns (MiniMeToken) {
913         MiniMeToken newToken = new MiniMeToken(
914             this,
915             _parentToken,
916             _snapshotBlock,
917             _tokenName,
918             _decimalUnits,
919             _tokenSymbol,
920             _transfersEnabled
921             );
922 
923         newToken.changeController(msg.sender);
924         return newToken;
925     }
926 }
927 
928 
929 /*
930     Copyright 2017, Jarrad Hope (Status Research & Development GmbH)
931 */
932 
933 
934 contract SNT is MiniMeToken {
935     // @dev SNT constructor just parametrizes the MiniMeIrrevocableVestedToken constructor
936     function SNT(address _tokenFactory)
937             MiniMeToken(
938                 _tokenFactory,
939                 0x0,                     // no parent token
940                 0,                       // no snapshot block number from parent
941                 "Status Network Token",  // Token name
942                 18,                      // Decimals
943                 "SNT",                   // Symbol
944                 true                     // Enable transfers
945             ) {}
946 }
947 
948 
949 /*
950     Copyright 2017, Jordi Baylina
951 
952     This program is free software: you can redistribute it and/or modify
953     it under the terms of the GNU General Public License as published by
954     the Free Software Foundation, either version 3 of the License, or
955     (at your option) any later version.
956 
957     This program is distributed in the hope that it will be useful,
958     but WITHOUT ANY WARRANTY; without even the implied warranty of
959     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
960     GNU General Public License for more details.
961 
962     You should have received a copy of the GNU General Public License
963     along with this program.  If not, see <http://www.gnu.org/licenses/>.
964  */
965 
966 /// @title StatusContribution Contract
967 /// @author Jordi Baylina
968 /// @dev This contract will be the SNT controller during the contribution period.
969 ///  This contract will determine the rules during this period.
970 ///  Final users will generally not interact directly with this contract. ETH will
971 ///  be sent to the SNT token contract. The ETH is sent to this contract and from here,
972 ///  ETH is sent to the contribution walled and SNTs are mined according to the defined
973 ///  rules.
974 
975 
976 contract StatusContribution is Owned, TokenController {
977     using SafeMath for uint256;
978 
979     uint256 constant public failSafeLimit = 300000 ether;
980     uint256 constant public maxGuaranteedLimit = 30000 ether;
981     uint256 constant public exchangeRate = 10000;
982     uint256 constant public maxGasPrice = 50000000000;
983     uint256 constant public maxCallFrequency = 100;
984 
985     MiniMeToken public SGT;
986     MiniMeToken public SNT;
987     uint256 public startBlock;
988     uint256 public endBlock;
989 
990     address public destEthDevs;
991 
992     address public destTokensDevs;
993     address public destTokensReserve;
994     uint256 public maxSGTSupply;
995     address public destTokensSgt;
996     DynamicCeiling public dynamicCeiling;
997 
998     address public sntController;
999 
1000     mapping (address => uint256) public guaranteedBuyersLimit;
1001     mapping (address => uint256) public guaranteedBuyersBought;
1002 
1003     uint256 public totalGuaranteedCollected;
1004     uint256 public totalNormalCollected;
1005 
1006     uint256 public finalizedBlock;
1007     uint256 public finalizedTime;
1008 
1009     mapping (address => uint256) public lastCallBlock;
1010 
1011     bool public paused;
1012 
1013     modifier initialized() {
1014         require(address(SNT) != 0x0);
1015         _;
1016     }
1017 
1018     modifier contributionOpen() {
1019         require(getBlockNumber() >= startBlock &&
1020                 getBlockNumber() <= endBlock &&
1021                 finalizedBlock == 0 &&
1022                 address(SNT) != 0x0);
1023         _;
1024     }
1025 
1026     modifier notPaused() {
1027         require(!paused);
1028         _;
1029     }
1030 
1031     function StatusContribution() {
1032         paused = false;
1033     }
1034 
1035 
1036     /// @notice This method should be called by the owner before the contribution
1037     ///  period starts This initializes most of the parameters
1038     /// @param _snt Address of the SNT token contract
1039     /// @param _sntController Token controller for the SNT that will be transferred after
1040     ///  the contribution finalizes.
1041     /// @param _startBlock Block when the contribution period starts
1042     /// @param _endBlock The last block that the contribution period is active
1043     /// @param _dynamicCeiling Address of the contract that controls the ceiling
1044     /// @param _destEthDevs Destination address where the contribution ether is sent
1045     /// @param _destTokensReserve Address where the tokens for the reserve are sent
1046     /// @param _destTokensSgt Address of the exchanger SGT-SNT where the SNT are sent
1047     ///  to be distributed to the SGT holders.
1048     /// @param _destTokensDevs Address where the tokens for the dev are sent
1049     /// @param _sgt Address of the SGT token contract
1050     /// @param _maxSGTSupply Quantity of SGT tokens that would represent 10% of status.
1051     function initialize(
1052         address _snt,
1053         address _sntController,
1054 
1055         uint256 _startBlock,
1056         uint256 _endBlock,
1057 
1058         address _dynamicCeiling,
1059 
1060         address _destEthDevs,
1061 
1062         address _destTokensReserve,
1063         address _destTokensSgt,
1064         address _destTokensDevs,
1065 
1066         address _sgt,
1067         uint256 _maxSGTSupply
1068     ) public onlyOwner {
1069         // Initialize only once
1070         require(address(SNT) == 0x0);
1071 
1072         SNT = MiniMeToken(_snt);
1073         require(SNT.totalSupply() == 0);
1074         require(SNT.controller() == address(this));
1075         require(SNT.decimals() == 18);  // Same amount of decimals as ETH
1076 
1077         require(_sntController != 0x0);
1078         sntController = _sntController;
1079 
1080         require(_startBlock >= getBlockNumber());
1081         require(_startBlock < _endBlock);
1082         startBlock = _startBlock;
1083         endBlock = _endBlock;
1084 
1085         require(_dynamicCeiling != 0x0);
1086         dynamicCeiling = DynamicCeiling(_dynamicCeiling);
1087 
1088         require(_destEthDevs != 0x0);
1089         destEthDevs = _destEthDevs;
1090 
1091         require(_destTokensReserve != 0x0);
1092         destTokensReserve = _destTokensReserve;
1093 
1094         require(_destTokensSgt != 0x0);
1095         destTokensSgt = _destTokensSgt;
1096 
1097         require(_destTokensDevs != 0x0);
1098         destTokensDevs = _destTokensDevs;
1099 
1100         require(_sgt != 0x0);
1101         SGT = MiniMeToken(_sgt);
1102 
1103         require(_maxSGTSupply >= MiniMeToken(SGT).totalSupply());
1104         maxSGTSupply = _maxSGTSupply;
1105     }
1106 
1107     /// @notice Sets the limit for a guaranteed address. All the guaranteed addresses
1108     ///  will be able to get SNTs during the contribution period with his own
1109     ///  specific limit.
1110     ///  This method should be called by the owner after the initialization
1111     ///  and before the contribution starts.
1112     /// @param _th Guaranteed address
1113     /// @param _limit Limit for the guaranteed address.
1114     function setGuaranteedAddress(address _th, uint256 _limit) public initialized onlyOwner {
1115         require(getBlockNumber() < startBlock);
1116         require(_limit > 0 && _limit <= maxGuaranteedLimit);
1117         guaranteedBuyersLimit[_th] = _limit;
1118         GuaranteedAddress(_th, _limit);
1119     }
1120 
1121     /// @notice If anybody sends Ether directly to this contract, consider he is
1122     ///  getting SNTs.
1123     function () public payable notPaused {
1124         proxyPayment(msg.sender);
1125     }
1126 
1127 
1128     //////////
1129     // MiniMe Controller functions
1130     //////////
1131 
1132     /// @notice This method will generally be called by the SNT token contract to
1133     ///  acquire SNTs. Or directly from third parties that want to acquire SNTs in
1134     ///  behalf of a token holder.
1135     /// @param _th SNT holder where the SNTs will be minted.
1136     function proxyPayment(address _th) public payable notPaused initialized contributionOpen returns (bool) {
1137         require(_th != 0x0);
1138         if (guaranteedBuyersLimit[_th] > 0) {
1139             buyGuaranteed(_th);
1140         } else {
1141             buyNormal(_th);
1142         }
1143         return true;
1144     }
1145 
1146     function onTransfer(address, address, uint256) public returns (bool) {
1147         return false;
1148     }
1149 
1150     function onApprove(address, address, uint256) public returns (bool) {
1151         return false;
1152     }
1153 
1154     function buyNormal(address _th) internal {
1155         require(tx.gasprice <= maxGasPrice);
1156 
1157         // Antispam mechanism
1158         address caller;
1159         if (msg.sender == address(SNT)) {
1160             caller = _th;
1161         } else {
1162             caller = msg.sender;
1163         }
1164 
1165         // Do not allow contracts to game the system
1166         require(!isContract(caller));
1167 
1168         require(getBlockNumber().sub(lastCallBlock[caller]) >= maxCallFrequency);
1169         lastCallBlock[caller] = getBlockNumber();
1170 
1171         uint256 toCollect = dynamicCeiling.toCollect(totalNormalCollected);
1172 
1173         uint256 toFund;
1174         if (msg.value <= toCollect) {
1175             toFund = msg.value;
1176         } else {
1177             toFund = toCollect;
1178         }
1179 
1180         totalNormalCollected = totalNormalCollected.add(toFund);
1181         doBuy(_th, toFund, false);
1182     }
1183 
1184     function buyGuaranteed(address _th) internal {
1185         uint256 toCollect = guaranteedBuyersLimit[_th];
1186 
1187         uint256 toFund;
1188         if (guaranteedBuyersBought[_th].add(msg.value) > toCollect) {
1189             toFund = toCollect.sub(guaranteedBuyersBought[_th]);
1190         } else {
1191             toFund = msg.value;
1192         }
1193 
1194         guaranteedBuyersBought[_th] = guaranteedBuyersBought[_th].add(toFund);
1195         totalGuaranteedCollected = totalGuaranteedCollected.add(toFund);
1196         doBuy(_th, toFund, true);
1197     }
1198 
1199     function doBuy(address _th, uint256 _toFund, bool _guaranteed) internal {
1200         assert(msg.value >= _toFund);  // Not needed, but double check.
1201         assert(totalCollected() <= failSafeLimit);
1202 
1203         if (_toFund > 0) {
1204             uint256 tokensGenerated = _toFund.mul(exchangeRate);
1205             assert(SNT.generateTokens(_th, tokensGenerated));
1206             destEthDevs.transfer(_toFund);
1207             NewSale(_th, _toFund, tokensGenerated, _guaranteed);
1208         }
1209 
1210         uint256 toReturn = msg.value.sub(_toFund);
1211         if (toReturn > 0) {
1212             // If the call comes from the Token controller,
1213             // then we return it to the token Holder.
1214             // Otherwise we return to the sender.
1215             if (msg.sender == address(SNT)) {
1216                 _th.transfer(toReturn);
1217             } else {
1218                 msg.sender.transfer(toReturn);
1219             }
1220         }
1221     }
1222 
1223     // NOTE on Percentage format
1224     // Right now, Solidity does not support decimal numbers. (This will change very soon)
1225     //  So in this contract we use a representation of a percentage that consist in
1226     //  expressing the percentage in "x per 10**18"
1227     // This format has a precision of 16 digits for a percent.
1228     // Examples:
1229     //  3%   =   3*(10**16)
1230     //  100% = 100*(10**16) = 10**18
1231     //
1232     // To get a percentage of a value we do it by first multiplying it by the percentage in  (x per 10^18)
1233     //  and then divide it by 10**18
1234     //
1235     //              Y * X(in x per 10**18)
1236     //  X% of Y = -------------------------
1237     //               100(in x per 10**18)
1238     //
1239 
1240 
1241     /// @notice This method will can be called by the owner before the contribution period
1242     ///  end or by anybody after the `endBlock`. This method finalizes the contribution period
1243     ///  by creating the remaining tokens and transferring the controller to the configured
1244     ///  controller.
1245     function finalize() public initialized {
1246         require(getBlockNumber() >= startBlock);
1247         require(msg.sender == owner || getBlockNumber() > endBlock);
1248         require(finalizedBlock == 0);
1249 
1250         // Do not allow termination until all curves revealed.
1251         require(dynamicCeiling.allRevealed());
1252 
1253         // Allow premature finalization if final limit is reached
1254         if (getBlockNumber() <= endBlock) {
1255             var (,lastLimit,,) = dynamicCeiling.curves(dynamicCeiling.revealedCurves().sub(1));
1256             require(totalNormalCollected >= lastLimit);
1257         }
1258 
1259         finalizedBlock = getBlockNumber();
1260         finalizedTime = now;
1261 
1262         uint256 percentageToSgt;
1263         if (SGT.totalSupply() >= maxSGTSupply) {
1264             percentageToSgt = percent(10);  // 10%
1265         } else {
1266 
1267             //
1268             //                           SGT.totalSupply()
1269             //  percentageToSgt = 10% * -------------------
1270             //                             maxSGTSupply
1271             //
1272             percentageToSgt = percent(10).mul(SGT.totalSupply()).div(maxSGTSupply);
1273         }
1274 
1275         uint256 percentageToDevs = percent(20);  // 20%
1276 
1277 
1278         //
1279         //  % To Contributors = 41% + (10% - % to SGT holders)
1280         //
1281         uint256 percentageToContributors = percent(41).add(percent(10).sub(percentageToSgt));
1282 
1283         uint256 percentageToReserve = percent(29);
1284 
1285 
1286         // SNT.totalSupply() -> Tokens minted during the contribution
1287         //  totalTokens  -> Total tokens that should be after the allocation
1288         //                   of devTokens, sgtTokens and reserve
1289         //  percentageToContributors -> Which percentage should go to the
1290         //                               contribution participants
1291         //                               (x per 10**18 format)
1292         //  percent(100) -> 100% in (x per 10**18 format)
1293         //
1294         //                       percentageToContributors
1295         //  SNT.totalSupply() = -------------------------- * totalTokens  =>
1296         //                             percent(100)
1297         //
1298         //
1299         //                            percent(100)
1300         //  =>  totalTokens = ---------------------------- * SNT.totalSupply()
1301         //                      percentageToContributors
1302         //
1303         uint256 totalTokens = SNT.totalSupply().mul(percent(100)).div(percentageToContributors);
1304 
1305 
1306         // Generate tokens for SGT Holders.
1307 
1308         //
1309         //                    percentageToReserve
1310         //  reserveTokens = ----------------------- * totalTokens
1311         //                      percentage(100)
1312         //
1313         assert(SNT.generateTokens(
1314             destTokensReserve,
1315             totalTokens.mul(percentageToReserve).div(percent(100))));
1316 
1317         //
1318         //                  percentageToSgt
1319         //  sgtTokens = ----------------------- * totalTokens
1320         //                   percentage(100)
1321         //
1322         assert(SNT.generateTokens(
1323             destTokensSgt,
1324             totalTokens.mul(percentageToSgt).div(percent(100))));
1325 
1326 
1327         //
1328         //                   percentageToDevs
1329         //  devTokens = ----------------------- * totalTokens
1330         //                   percentage(100)
1331         //
1332         assert(SNT.generateTokens(
1333             destTokensDevs,
1334             totalTokens.mul(percentageToDevs).div(percent(100))));
1335 
1336         SNT.changeController(sntController);
1337 
1338         Finalized();
1339     }
1340 
1341     function percent(uint256 p) internal returns (uint256) {
1342         return p.mul(10**16);
1343     }
1344 
1345     /// @dev Internal function to determine if an address is a contract
1346     /// @param _addr The address being queried
1347     /// @return True if `_addr` is a contract
1348     function isContract(address _addr) constant internal returns (bool) {
1349         if (_addr == 0) return false;
1350         uint256 size;
1351         assembly {
1352             size := extcodesize(_addr)
1353         }
1354         return (size > 0);
1355     }
1356 
1357 
1358     //////////
1359     // Constant functions
1360     //////////
1361 
1362     /// @return Total tokens issued in weis.
1363     function tokensIssued() public constant returns (uint256) {
1364         return SNT.totalSupply();
1365     }
1366 
1367     /// @return Total Ether collected.
1368     function totalCollected() public constant returns (uint256) {
1369         return totalNormalCollected.add(totalGuaranteedCollected);
1370     }
1371 
1372 
1373     //////////
1374     // Testing specific methods
1375     //////////
1376 
1377     /// @notice This function is overridden by the test Mocks.
1378     function getBlockNumber() internal constant returns (uint256) {
1379         return block.number;
1380     }
1381 
1382 
1383     //////////
1384     // Safety Methods
1385     //////////
1386 
1387     /// @notice This method can be used by the controller to extract mistakenly
1388     ///  sent tokens to this contract.
1389     /// @param _token The address of the token contract that you want to recover
1390     ///  set to 0 in case you want to extract ether.
1391     function claimTokens(address _token) public onlyOwner {
1392         if (SNT.controller() == address(this)) {
1393             SNT.claimTokens(_token);
1394         }
1395         if (_token == 0x0) {
1396             owner.transfer(this.balance);
1397             return;
1398         }
1399 
1400         ERC20Token token = ERC20Token(_token);
1401         uint256 balance = token.balanceOf(this);
1402         token.transfer(owner, balance);
1403         ClaimedTokens(_token, owner, balance);
1404     }
1405 
1406 
1407     /// @notice Pauses the contribution if there is any issue
1408     function pauseContribution() onlyOwner {
1409         paused = true;
1410     }
1411 
1412     /// @notice Resumes the contribution
1413     function resumeContribution() onlyOwner {
1414         paused = false;
1415     }
1416 
1417     event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
1418     event NewSale(address indexed _th, uint256 _amount, uint256 _tokens, bool _guaranteed);
1419     event GuaranteedAddress(address indexed _th, uint256 _limit);
1420     event Finalized();
1421 }
1422 
1423 
1424 /*
1425     Copyright 2017, Jordi Baylina
1426 
1427     This program is free software: you can redistribute it and/or modify
1428     it under the terms of the GNU General Public License as published by
1429     the Free Software Foundation, either version 3 of the License, or
1430     (at your option) any later version.
1431 
1432     This program is distributed in the hope that it will be useful,
1433     but WITHOUT ANY WARRANTY; without even the implied warranty of
1434     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1435     GNU General Public License for more details.
1436 
1437     You should have received a copy of the GNU General Public License
1438     along with this program.  If not, see <http://www.gnu.org/licenses/>.
1439  */
1440 
1441 /// @title ContributionWallet Contract
1442 /// @author Jordi Baylina
1443 /// @dev This contract will be hold the Ether during the contribution period.
1444 ///  The idea of this contract is to avoid recycling Ether during the contribution
1445 ///  period. So all the ETH collected will be locked here until the contribution
1446 ///  period ends
1447 
1448 // @dev Contract to hold sale raised funds during the sale period.
1449 // Prevents attack in which the Aragon Multisig sends raised ether
1450 // to the sale contract to mint tokens to itself, and getting the
1451 // funds back immediately.
1452 
1453 
1454 
1455 contract ContributionWallet {
1456 
1457     // Public variables
1458     address public multisig;
1459     uint256 public endBlock;
1460     StatusContribution public contribution;
1461 
1462     // @dev Constructor initializes public variables
1463     // @param _multisig The address of the multisig that will receive the funds
1464     // @param _endBlock Block after which the multisig can request the funds
1465     // @param _contribution Address of the StatusContribution contract
1466     function ContributionWallet(address _multisig, uint256 _endBlock, address _contribution) {
1467         require(_multisig != 0x0);
1468         require(_contribution != 0x0);
1469         require(_endBlock != 0 && _endBlock <= 4000000);
1470         multisig = _multisig;
1471         endBlock = _endBlock;
1472         contribution = StatusContribution(_contribution);
1473     }
1474 
1475     // @dev Receive all sent funds without any further logic
1476     function () public payable {}
1477 
1478     // @dev Withdraw function sends all the funds to the wallet if conditions are correct
1479     function withdraw() public {
1480         require(msg.sender == multisig);              // Only the multisig can request it
1481         require(block.number > endBlock ||            // Allow after end block
1482                 contribution.finalizedBlock() != 0);  // Allow when sale is finalized
1483         multisig.transfer(this.balance);
1484     }
1485 
1486 }
1487 
1488 
1489 /*
1490     Copyright 2017, Jordi Baylina
1491 
1492     This program is free software: you can redistribute it and/or modify
1493     it under the terms of the GNU General Public License as published by
1494     the Free Software Foundation, either version 3 of the License, or
1495     (at your option) any later version.
1496 
1497     This program is distributed in the hope that it will be useful,
1498     but WITHOUT ANY WARRANTY; without even the implied warranty of
1499     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1500     GNU General Public License for more details.
1501 
1502     You should have received a copy of the GNU General Public License
1503     along with this program.  If not, see <http://www.gnu.org/licenses/>.
1504  */
1505 
1506 /// @title DevTokensHolder Contract
1507 /// @author Jordi Baylina
1508 /// @dev This contract will hold the tokens of the developers.
1509 ///  Tokens will not be able to be collected until 6 months after the contribution
1510 ///  period ends. And it will be increasing linearly until 2 years.
1511 
1512 
1513 //  collectable tokens
1514 //   |                         _/--------   vestedTokens rect
1515 //   |                       _/
1516 //   |                     _/
1517 //   |                   _/
1518 //   |                 _/
1519 //   |               _/
1520 //   |             _/
1521 //   |           _/
1522 //   |          |
1523 //   |        . |
1524 //   |      .   |
1525 //   |    .     |
1526 //   +===+======+--------------+----------> time
1527 //     Contrib   6 Months       24 Months
1528 //       End
1529 
1530 
1531 
1532 contract DevTokensHolder is Owned {
1533     using SafeMath for uint256;
1534 
1535     uint256 collectedTokens;
1536     StatusContribution contribution;
1537     MiniMeToken snt;
1538 
1539     function DevTokensHolder(address _owner, address _contribution, address _snt) {
1540         owner = _owner;
1541         contribution = StatusContribution(_contribution);
1542         snt = MiniMeToken(_snt);
1543     }
1544 
1545 
1546     /// @notice The Dev (Owner) will call this method to extract the tokens
1547     function collectTokens() public onlyOwner {
1548         uint256 balance = snt.balanceOf(address(this));
1549         uint256 total = collectedTokens.add(balance);
1550 
1551         uint256 finalizedTime = contribution.finalizedTime();
1552 
1553         require(finalizedTime > 0 && getTime() > finalizedTime.add(months(6)));
1554 
1555         uint256 canExtract = total.mul(getTime().sub(finalizedTime)).div(months(24));
1556 
1557         canExtract = canExtract.sub(collectedTokens);
1558 
1559         if (canExtract > balance) {
1560             canExtract = balance;
1561         }
1562 
1563         collectedTokens = collectedTokens.add(canExtract);
1564         assert(snt.transfer(owner, canExtract));
1565 
1566         TokensWithdrawn(owner, canExtract);
1567     }
1568 
1569     function months(uint256 m) internal returns (uint256) {
1570         return m.mul(30 days);
1571     }
1572 
1573     function getTime() internal returns (uint256) {
1574         return now;
1575     }
1576 
1577 
1578     //////////
1579     // Safety Methods
1580     //////////
1581 
1582     /// @notice This method can be used by the controller to extract mistakenly
1583     ///  sent tokens to this contract.
1584     /// @param _token The address of the token contract that you want to recover
1585     ///  set to 0 in case you want to extract ether.
1586     function claimTokens(address _token) public onlyOwner {
1587         require(_token != address(snt));
1588         if (_token == 0x0) {
1589             owner.transfer(this.balance);
1590             return;
1591         }
1592 
1593         ERC20Token token = ERC20Token(_token);
1594         uint256 balance = token.balanceOf(this);
1595         token.transfer(owner, balance);
1596         ClaimedTokens(_token, owner, balance);
1597     }
1598 
1599     event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
1600     event TokensWithdrawn(address indexed _holder, uint256 _amount);
1601 }
1602 
1603 
1604 /*
1605     Copyright 2017, Jordi Baylina
1606 
1607     This program is free software: you can redistribute it and/or modify
1608     it under the terms of the GNU General Public License as published by
1609     the Free Software Foundation, either version 3 of the License, or
1610     (at your option) any later version.
1611 
1612     This program is distributed in the hope that it will be useful,
1613     but WITHOUT ANY WARRANTY; without even the implied warranty of
1614     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1615     GNU General Public License for more details.
1616 
1617     You should have received a copy of the GNU General Public License
1618     along with this program.  If not, see <http://www.gnu.org/licenses/>.
1619  */
1620 
1621 /// @title SGTExchanger Contract
1622 /// @author Jordi Baylina
1623 /// @dev This contract will be used to distribute SNT between SGT holders.
1624 ///  SGT token is not transferable, and we just keep an accounting between all tokens
1625 ///  deposited and the tokens collected.
1626 ///  The controllerShip of SGT should be transferred to this contract before the
1627 ///  contribution period starts.
1628 
1629 
1630 contract SGTExchanger is TokenController, Owned {
1631     using SafeMath for uint256;
1632 
1633     mapping (address => uint256) public collected;
1634     uint256 public totalCollected;
1635     MiniMeToken public sgt;
1636     MiniMeToken public snt;
1637     StatusContribution public statusContribution;
1638 
1639     function SGTExchanger(address _sgt, address _snt, address _statusContribution) {
1640         sgt = MiniMeToken(_sgt);
1641         snt = MiniMeToken(_snt);
1642         statusContribution = StatusContribution(_statusContribution);
1643     }
1644 
1645     /// @notice This method should be called by the SGT holders to collect their
1646     ///  corresponding SNTs
1647     function collect() public {
1648         uint256 finalizedBlock = statusContribution.finalizedBlock();
1649 
1650         require(finalizedBlock != 0);
1651         require(getBlockNumber() > finalizedBlock);
1652 
1653         uint256 total = totalCollected.add(snt.balanceOf(address(this)));
1654 
1655         uint256 balance = sgt.balanceOfAt(msg.sender, finalizedBlock);
1656 
1657         // First calculate how much correspond to him
1658         uint256 amount = total.mul(balance).div(sgt.totalSupplyAt(finalizedBlock));
1659 
1660         // And then subtract the amount already collected
1661         amount = amount.sub(collected[msg.sender]);
1662 
1663         require(amount > 0);  // Notify the user that there are no tokens to exchange
1664 
1665         totalCollected = totalCollected.add(amount);
1666         collected[msg.sender] = collected[msg.sender].add(amount);
1667 
1668         assert(snt.transfer(msg.sender, amount));
1669 
1670         TokensCollected(msg.sender, amount);
1671     }
1672 
1673     function proxyPayment(address) public payable returns (bool) {
1674         throw;
1675     }
1676 
1677     function onTransfer(address, address, uint256) public returns (bool) {
1678         return false;
1679     }
1680 
1681     function onApprove(address, address, uint256) public returns (bool) {
1682         return false;
1683     }
1684 
1685     //////////
1686     // Testing specific methods
1687     //////////
1688 
1689     /// @notice This function is overridden by the test Mocks.
1690     function getBlockNumber() internal constant returns (uint256) {
1691         return block.number;
1692     }
1693 
1694     //////////
1695     // Safety Method
1696     //////////
1697 
1698     /// @notice This method can be used by the controller to extract mistakenly
1699     ///  sent tokens to this contract.
1700     /// @param _token The address of the token contract that you want to recover
1701     ///  set to 0 in case you want to extract ether.
1702     function claimTokens(address _token) public onlyOwner {
1703         require(_token != address(snt));
1704         if (_token == 0x0) {
1705             owner.transfer(this.balance);
1706             return;
1707         }
1708 
1709         ERC20Token token = ERC20Token(_token);
1710         uint256 balance = token.balanceOf(this);
1711         token.transfer(owner, balance);
1712         ClaimedTokens(_token, owner, balance);
1713     }
1714 
1715     event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
1716     event TokensCollected(address indexed _holder, uint256 _amount);
1717 
1718 }
1719 
1720 /*
1721     Copyright 2017, Jordi Baylina
1722 
1723     This program is free software: you can redistribute it and/or modify
1724     it under the terms of the GNU General Public License as published by
1725     the Free Software Foundation, either version 3 of the License, or
1726     (at your option) any later version.
1727 
1728     This program is distributed in the hope that it will be useful,
1729     but WITHOUT ANY WARRANTY; without even the implied warranty of
1730     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1731     GNU General Public License for more details.
1732 
1733     You should have received a copy of the GNU General Public License
1734     along with this program.  If not, see <http://www.gnu.org/licenses/>.
1735  */
1736 
1737 /// @title SNTPlaceholder Contract
1738 /// @author Jordi Baylina
1739 /// @dev The SNTPlaceholder contract will take control over the SNT after the contribution
1740 ///  is finalized and before the Status Network is deployed.
1741 ///  The contract allows for SNT transfers and transferFrom and implements the
1742 ///  logic for transferring control of the token to the network when the offering
1743 ///  asks it to do so.
1744 
1745 
1746 contract SNTPlaceHolder is TokenController, Owned {
1747     using SafeMath for uint256;
1748 
1749     MiniMeToken public snt;
1750     StatusContribution public contribution;
1751     uint256 public activationTime;
1752     address public sgtExchanger;
1753 
1754     /// @notice Constructor
1755     /// @param _owner Trusted owner for this contract.
1756     /// @param _snt SNT token contract address
1757     /// @param _contribution StatusContribution contract address
1758     /// @param _sgtExchanger SGT-SNT Exchange address. (During the first week
1759     ///  only this exchanger will be able to move tokens)
1760     function SNTPlaceHolder(address _owner, address _snt, address _contribution, address _sgtExchanger) {
1761         owner = _owner;
1762         snt = MiniMeToken(_snt);
1763         contribution = StatusContribution(_contribution);
1764         sgtExchanger = _sgtExchanger;
1765     }
1766 
1767     /// @notice The owner of this contract can change the controller of the SNT token
1768     ///  Please, be sure that the owner is a trusted agent or 0x0 address.
1769     /// @param _newController The address of the new controller
1770 
1771     function changeController(address _newController) public onlyOwner {
1772         snt.changeController(_newController);
1773         ControllerChanged(_newController);
1774     }
1775 
1776 
1777     //////////
1778     // MiniMe Controller Interface functions
1779     //////////
1780 
1781     // In between the offering and the network. Default settings for allowing token transfers.
1782     function proxyPayment(address) public payable returns (bool) {
1783         return false;
1784     }
1785 
1786     function onTransfer(address _from, address, uint256) public returns (bool) {
1787         return transferable(_from);
1788     }
1789 
1790     function onApprove(address _from, address, uint256) public returns (bool) {
1791         return transferable(_from);
1792     }
1793 
1794     function transferable(address _from) internal returns (bool) {
1795         // Allow the exchanger to work from the beginning
1796         if (activationTime == 0) {
1797             uint256 f = contribution.finalizedTime();
1798             if (f > 0) {
1799                 activationTime = f.add(1 weeks);
1800             } else {
1801                 return false;
1802             }
1803         }
1804         return (getTime() > activationTime) || (_from == sgtExchanger);
1805     }
1806 
1807 
1808     //////////
1809     // Testing specific methods
1810     //////////
1811 
1812     /// @notice This function is overrided by the test Mocks.
1813     function getTime() internal returns (uint256) {
1814         return now;
1815     }
1816 
1817 
1818     //////////
1819     // Safety Methods
1820     //////////
1821 
1822     /// @notice This method can be used by the controller to extract mistakenly
1823     ///  sent tokens to this contract.
1824     /// @param _token The address of the token contract that you want to recover
1825     ///  set to 0 in case you want to extract ether.
1826     function claimTokens(address _token) public onlyOwner {
1827         if (snt.controller() == address(this)) {
1828             snt.claimTokens(_token);
1829         }
1830         if (_token == 0x0) {
1831             owner.transfer(this.balance);
1832             return;
1833         }
1834 
1835         ERC20Token token = ERC20Token(_token);
1836         uint256 balance = token.balanceOf(this);
1837         token.transfer(owner, balance);
1838         ClaimedTokens(_token, owner, balance);
1839     }
1840 
1841     event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
1842     event ControllerChanged(address indexed _newController);
1843 }