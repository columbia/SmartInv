1 pragma solidity 0.4.15;
2 
3 /// @dev `Owned` is a base level contract that assigns an `owner` that can be
4 ///  later changed
5 contract Owned {
6 
7     /// @dev `owner` is the only address that can call a function with this
8     /// modifier
9     modifier onlyOwner() {
10         require(msg.sender == owner);
11         _;
12     }
13 
14     address public owner;
15 
16     /// @notice The Constructor assigns the message sender to be `owner`
17     function Owned() {
18         owner = msg.sender;
19     }
20 
21     address public newOwner;
22 
23     /// @notice `owner` can step down and assign some other address to this role
24     /// @param _newOwner The address of the new owner. 0x0 can be used to create
25     function changeOwner(address _newOwner) onlyOwner {
26         if(msg.sender == owner) {
27             owner = _newOwner;
28         }
29     }
30 }
31 
32 
33 /**
34  * Math operations with safety checks
35  */
36 library SafeMath {
37   function mul(uint a, uint b) internal returns (uint) {
38     uint c = a * b;
39     assert(a == 0 || c / a == b);
40     return c;
41   }
42 
43   function div(uint a, uint b) internal returns (uint) {
44     // assert(b > 0); // Solidity automatically throws when dividing by 0
45     uint c = a / b;
46     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
47     return c;
48   }
49 
50   function sub(uint a, uint b) internal returns (uint) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   function add(uint a, uint b) internal returns (uint) {
56     uint c = a + b;
57     assert(c >= a);
58     return c;
59   }
60 
61   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
62     return a >= b ? a : b;
63   }
64 
65   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
66     return a < b ? a : b;
67   }
68 
69   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
70     return a >= b ? a : b;
71   }
72 
73   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
74     return a < b ? a : b;
75   }
76 }
77 
78 
79 contract DynamicCeiling is Owned {
80     using SafeMath for uint256;
81 
82     struct Ceiling {
83         bytes32 hash;
84         uint256 limit;
85         uint256 slopeFactor;
86         uint256 collectMinimum;
87     }
88 
89     address public saleAddress;
90 
91     Ceiling[] public ceilings;
92     
93     uint256 public currentIndex;
94     uint256 public revealedCeilings;
95     bool public allRevealed;
96 
97     modifier onlySaleAddress {
98         require(msg.sender == saleAddress);
99         _;
100     }
101 
102     function DynamicCeiling(address _owner, address _saleAddress) {
103         owner = _owner;
104         saleAddress = _saleAddress;
105     }
106 
107     /// @notice This should be called by the creator of the contract to commit
108     ///  all the ceilings.
109     /// @param _ceilingHashes Array of hashes of each ceiling. Each hash is calculated
110     ///  by the `calculateHash` method. More hashes than actual ceilings can be
111     ///  committed in order to hide also the number of ceilings.
112     ///  The remaining hashes can be just random numbers.
113     function setHiddenCeilings(bytes32[] _ceilingHashes) public onlyOwner {
114         require(ceilings.length == 0);
115 
116         ceilings.length = _ceilingHashes.length;
117         for (uint256 i = 0; i < _ceilingHashes.length; i = i.add(1)) {
118             ceilings[i].hash = _ceilingHashes[i];
119         }
120     }
121 
122     /// @notice Anybody can reveal the next ceiling if he knows it.
123     /// @param _limit Ceiling cap.
124     ///  (must be greater or equal to the previous one).
125     /// @param _last `true` if it's the last ceiling.
126     /// @param _salt Random number used to commit the ceiling
127     function revealCeiling(
128         uint256 _limit, 
129         uint256 _slopeFactor, 
130         uint256 _collectMinimum,
131         bool _last, 
132         bytes32 _salt) 
133         public 
134         {
135         require(!allRevealed);
136         require(
137             ceilings[revealedCeilings].hash == 
138             calculateHash(
139                 _limit, 
140                 _slopeFactor, 
141                 _collectMinimum, 
142                 _last, 
143                 _salt
144             )
145         );
146 
147         require(_limit != 0 && _slopeFactor != 0 && _collectMinimum != 0);
148         if (revealedCeilings > 0) {
149             require(_limit >= ceilings[revealedCeilings.sub(1)].limit);
150         }
151 
152         ceilings[revealedCeilings].limit = _limit;
153         ceilings[revealedCeilings].slopeFactor = _slopeFactor;
154         ceilings[revealedCeilings].collectMinimum = _collectMinimum;
155         revealedCeilings = revealedCeilings.add(1);
156 
157         if (_last) {
158             allRevealed = true;
159         }
160     }
161 
162     /// @notice Reveal multiple ceilings at once
163     function revealMulti(
164         uint256[] _limits,
165         uint256[] _slopeFactors,
166         uint256[] _collectMinimums,
167         bool[] _lasts, 
168         bytes32[] _salts) 
169         public 
170         {
171         // Do not allow none and needs to be same length for all parameters
172         require(
173             _limits.length != 0 &&
174             _limits.length == _slopeFactors.length &&
175             _limits.length == _collectMinimums.length &&
176             _limits.length == _lasts.length &&
177             _limits.length == _salts.length
178         );
179 
180         for (uint256 i = 0; i < _limits.length; i = i.add(1)) {
181             
182             revealCeiling(
183                 _limits[i],
184                 _slopeFactors[i],
185                 _collectMinimums[i],
186                 _lasts[i],
187                 _salts[i]
188             );
189         }
190     }
191 
192     /// @notice Move to ceiling, used as a failsafe
193     function moveToNextCeiling() public onlyOwner {
194 
195         currentIndex = currentIndex.add(1);
196     }
197 
198     /// @return Return the funds to collect for the current point on the ceiling
199     ///  (or 0 if no ceilings revealed yet)
200     function availableAmountToCollect(uint256  totallCollected) public onlySaleAddress returns (uint256) {
201     
202         if (revealedCeilings == 0) {
203             return 0;
204         }
205 
206         if (totallCollected >= ceilings[currentIndex].limit) {  
207             uint256 nextIndex = currentIndex.add(1);
208 
209             if (nextIndex >= revealedCeilings) {
210                 return 0; 
211             }
212             currentIndex = nextIndex;
213             if (totallCollected >= ceilings[currentIndex].limit) {
214                 return 0;  
215             }
216         }        
217         uint256 remainedFromCurrentCeiling = ceilings[currentIndex].limit.sub(totallCollected);
218         uint256 reminderWithSlopeFactor = remainedFromCurrentCeiling.div(ceilings[currentIndex].slopeFactor);
219 
220         if (reminderWithSlopeFactor > ceilings[currentIndex].collectMinimum) {
221             return reminderWithSlopeFactor;
222         }
223         
224         if (remainedFromCurrentCeiling > ceilings[currentIndex].collectMinimum) {
225             return ceilings[currentIndex].collectMinimum;
226         } else {
227             return remainedFromCurrentCeiling;
228         }
229     }
230 
231     /// @notice Calculates the hash of a ceiling.
232     /// @param _limit Ceiling cap.
233     /// @param _last `true` if it's the last ceiling.
234     /// @param _collectMinimum the minimum amount to collect
235     /// @param _salt Random number that will be needed to reveal this ceiling.
236     /// @return The calculated hash of this ceiling to be used in the `setHiddenCurves` method
237     function calculateHash(
238         uint256 _limit, 
239         uint256 _slopeFactor, 
240         uint256 _collectMinimum,
241         bool _last, 
242         bytes32 _salt) 
243         public 
244         constant 
245         returns (bytes32) 
246         {
247         return keccak256(
248             _limit,
249             _slopeFactor, 
250             _collectMinimum,
251             _last,
252             _salt
253         );
254     }
255 
256     /// @return Return the total number of ceilings committed
257     ///  (can be larger than the number of actual ceilings on the ceiling to hide
258     ///  the real number of ceilings)
259     function nCeilings() public constant returns (uint256) {
260         return ceilings.length;
261     }
262 
263 }
264 
265 /// @title Vesting trustee
266 contract Trustee is Owned {
267     using SafeMath for uint256;
268 
269     // The address of the SHP ERC20 token.
270     SHP public shp;
271 
272     struct Grant {
273         uint256 value;
274         uint256 start;
275         uint256 cliff;
276         uint256 end;
277         uint256 transferred;
278         bool revokable;
279     }
280 
281     // Grants holder.
282     mapping (address => Grant) public grants;
283 
284     // Total tokens available for vesting.
285     uint256 public totalVesting;
286 
287     event NewGrant(address indexed _from, address indexed _to, uint256 _value);
288     event UnlockGrant(address indexed _holder, uint256 _value);
289     event RevokeGrant(address indexed _holder, uint256 _refund);
290 
291     /// @dev Constructor that initializes the address of the SHP contract.
292     /// @param _shp SHP The address of the previously deployed SHP smart contract.
293     function Trustee(SHP _shp) {
294         require(_shp != address(0));
295         shp = _shp;
296     }
297 
298     /// @dev Grant tokens to a specified address.
299     /// @param _to address The address to grant tokens to.
300     /// @param _value uint256 The amount of tokens to be granted.
301     /// @param _start uint256 The beginning of the vesting period.
302     /// @param _cliff uint256 Duration of the cliff period.
303     /// @param _end uint256 The end of the vesting period.
304     /// @param _revokable bool Whether the grant is revokable or not.
305     function grant(address _to, uint256 _value, uint256 _start, uint256 _cliff, uint256 _end, bool _revokable)
306         public onlyOwner {
307         require(_to != address(0));
308         require(_value > 0);
309 
310         // Make sure that a single address can be granted tokens only once.
311         require(grants[_to].value == 0);
312 
313         // Check for date inconsistencies that may cause unexpected behavior.
314         require(_start <= _cliff && _cliff <= _end);
315 
316         // Check that this grant doesn't exceed the total amount of tokens currently available for vesting.
317         require(totalVesting.add(_value) <= shp.balanceOf(address(this)));
318 
319         // Assign a new grant.
320         grants[_to] = Grant({
321             value: _value,
322             start: _start,
323             cliff: _cliff,
324             end: _end,
325             transferred: 0,
326             revokable: _revokable
327         });
328 
329         // Tokens granted, reduce the total amount available for vesting.
330         totalVesting = totalVesting.add(_value);
331 
332         NewGrant(msg.sender, _to, _value);
333     }
334 
335     /// @dev Revoke the grant of tokens of a specifed address.
336     /// @param _holder The address which will have its tokens revoked.
337     function revoke(address _holder) public onlyOwner {
338         Grant grant = grants[_holder];
339 
340         require(grant.revokable);
341 
342         // Send the remaining SHP back to the owner.
343         uint256 refund = grant.value.sub(grant.transferred);
344 
345         // Remove the grant.
346         delete grants[_holder];
347 
348         totalVesting = totalVesting.sub(refund);
349         shp.transfer(msg.sender, refund);
350 
351         RevokeGrant(_holder, refund);
352     }
353 
354     /// @dev Calculate the total amount of vested tokens of a holder at a given time.
355     /// @param _holder address The address of the holder.
356     /// @param _time uint256 The specific time.
357     /// @return a uint256 representing a holder's total amount of vested tokens.
358     function vestedTokens(address _holder, uint256 _time) public constant returns (uint256) {
359         Grant grant = grants[_holder];
360         if (grant.value == 0) {
361             return 0;
362         }
363 
364         return calculateVestedTokens(grant, _time);
365     }
366 
367     /// @dev Calculate amount of vested tokens at a specifc time.
368     /// @param _grant Grant The vesting grant.
369     /// @param _time uint256 The time to be checked
370     /// @return An uint256 representing the amount of vested tokens of a specific grant.
371     ///   |                         _/--------   vestedTokens rect
372     ///   |                       _/
373     ///   |                     _/
374     ///   |                   _/
375     ///   |                 _/
376     ///   |                /
377     ///   |              .|
378     ///   |            .  |
379     ///   |          .    |
380     ///   |        .      |
381     ///   |      .        |
382     ///   |    .          |
383     ///   +===+===========+---------+----------> time
384     ///     Start       Cliff      End
385     function calculateVestedTokens(Grant _grant, uint256 _time) private constant returns (uint256) {
386         // If we're before the cliff, then nothing is vested.
387         if (_time < _grant.cliff) {
388             return 0;
389         }
390 
391         // If we're after the end of the vesting period - everything is vested;
392         if (_time >= _grant.end) {
393             return _grant.value;
394         }
395 
396         // Interpolate all vested tokens: vestedTokens = tokens/// (time - start) / (end - start)
397          return _grant.value.mul(_time.sub(_grant.start)).div(_grant.end.sub(_grant.start));
398     }
399 
400     /// @dev Unlock vested tokens and transfer them to their holder.
401     /// @return a uint256 representing the amount of vested tokens transferred to their holder.
402     function unlockVestedTokens() public {
403         Grant grant = grants[msg.sender];
404         require(grant.value != 0);
405 
406         // Get the total amount of vested tokens, acccording to grant.
407         uint256 vested = calculateVestedTokens(grant, now);
408         if (vested == 0) {
409             return;
410         }
411 
412         // Make sure the holder doesn't transfer more than what he already has.
413         uint256 transferable = vested.sub(grant.transferred);
414         if (transferable == 0) {
415             return;
416         }
417 
418         grant.transferred = grant.transferred.add(transferable);
419         totalVesting = totalVesting.sub(transferable);
420         shp.transfer(msg.sender, transferable);
421 
422         UnlockGrant(msg.sender, transferable);
423     }
424 }
425 
426 /// @dev The token controller contract must implement these functions
427 contract TokenController {
428     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
429     /// @param _owner The address that sent the ether to create tokens
430     /// @return True if the ether is accepted, false if it throws
431     function proxyPayment(address _owner) payable returns(bool);
432 
433     /// @notice Notifies the controller about a token transfer allowing the
434     ///  controller to react if desired
435     /// @param _from The origin of the transfer
436     /// @param _to The destination of the transfer
437     /// @param _amount The amount of the transfer
438     /// @return False if the controller does not authorize the transfer
439     function onTransfer(address _from, address _to, uint _amount) returns(bool);
440 
441     /// @notice Notifies the controller about an approval allowing the
442     ///  controller to react if desired
443     /// @param _owner The address that calls `approve()`
444     /// @param _spender The spender in the `approve()` call
445     /// @param _amount The amount in the `approve()` call
446     /// @return False if the controller does not authorize the approval
447     function onApprove(address _owner, address _spender, uint _amount)
448         returns(bool);
449 }
450 
451 contract Controlled {
452     /// @notice The address of the controller is the only address that can call
453     ///  a function with this modifier
454     modifier onlyController { require(msg.sender == controller); _; }
455 
456     address public controller;
457 
458     function Controlled() { controller = msg.sender;}
459 
460     /// @notice Changes the controller of the contract
461     /// @param _newController The new controller of the contract
462     function changeController(address _newController) onlyController {
463         controller = _newController;
464     }
465 }
466 
467 contract ApproveAndCallFallBack {
468     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
469 }
470 
471 /// @dev The actual token contract, the default controller is the msg.sender
472 ///  that deploys the contract, so usually this token will be deployed by a
473 ///  token controller contract, which Giveth will call a "Campaign"
474 contract MiniMeToken is Controlled {
475 
476     string public name;                //The Token's name: e.g. DigixDAO Tokens
477     uint8 public decimals;             //Number of decimals of the smallest unit
478     string public symbol;              //An identifier: e.g. REP
479     string public version = 'MMT_0.1'; //An arbitrary versioning scheme
480 
481 
482     /// @dev `Checkpoint` is the structure that attaches a block number to a
483     ///  given value, the block number attached is the one that last changed the
484     ///  value
485     struct  Checkpoint {
486 
487         // `fromBlock` is the block number that the value was generated from
488         uint128 fromBlock;
489 
490         // `value` is the amount of tokens at a specific block number
491         uint128 value;
492     }
493 
494     // `parentToken` is the Token address that was cloned to produce this token;
495     //  it will be 0x0 for a token that was not cloned
496     MiniMeToken public parentToken;
497 
498     // `parentSnapShotBlock` is the block number from the Parent Token that was
499     //  used to determine the initial distribution of the Clone Token
500     uint public parentSnapShotBlock;
501 
502     // `creationBlock` is the block number that the Clone Token was created
503     uint public creationBlock;
504 
505     // `balances` is the map that tracks the balance of each address, in this
506     //  contract when the balance changes the block number that the change
507     //  occurred is also included in the map
508     mapping (address => Checkpoint[]) balances;
509 
510     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
511     mapping (address => mapping (address => uint256)) allowed;
512 
513     // Tracks the history of the `totalSupply` of the token
514     Checkpoint[] totalSupplyHistory;
515 
516     // Flag that determines if the token is transferable or not.
517     bool public transfersEnabled;
518 
519     // The factory used to create new clone tokens
520     MiniMeTokenFactory public tokenFactory;
521 
522 ////////////////
523 // Constructor
524 ////////////////
525 
526     /// @notice Constructor to create a MiniMeToken
527     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
528     ///  will create the Clone token contracts, the token factory needs to be
529     ///  deployed first
530     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
531     ///  new token
532     /// @param _parentSnapShotBlock Block of the parent token that will
533     ///  determine the initial distribution of the clone token, set to 0 if it
534     ///  is a new token
535     /// @param _tokenName Name of the new token
536     /// @param _decimalUnits Number of decimals of the new token
537     /// @param _tokenSymbol Token Symbol for the new token
538     /// @param _transfersEnabled If true, tokens will be able to be transferred
539     function MiniMeToken(
540         address _tokenFactory,
541         address _parentToken,
542         uint _parentSnapShotBlock,
543         string _tokenName,
544         uint8 _decimalUnits,
545         string _tokenSymbol,
546         bool _transfersEnabled
547     ) {
548         tokenFactory = MiniMeTokenFactory(_tokenFactory);
549         name = _tokenName;                                 // Set the name
550         decimals = _decimalUnits;                          // Set the decimals
551         symbol = _tokenSymbol;                             // Set the symbol
552         parentToken = MiniMeToken(_parentToken);
553         parentSnapShotBlock = _parentSnapShotBlock;
554         transfersEnabled = _transfersEnabled;
555         creationBlock = block.number;
556     }
557 
558 
559 ///////////////////
560 // ERC20 Methods
561 ///////////////////
562 
563     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
564     /// @param _to The address of the recipient
565     /// @param _amount The amount of tokens to be transferred
566     /// @return Whether the transfer was successful or not
567     function transfer(address _to, uint256 _amount) returns (bool success) {
568         require(transfersEnabled);
569         return doTransfer(msg.sender, _to, _amount);
570     }
571 
572     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
573     ///  is approved by `_from`
574     /// @param _from The address holding the tokens being transferred
575     /// @param _to The address of the recipient
576     /// @param _amount The amount of tokens to be transferred
577     /// @return True if the transfer was successful
578     function transferFrom(address _from, address _to, uint256 _amount
579     ) returns (bool success) {
580 
581         // The controller of this contract can move tokens around at will,
582         //  this is important to recognize! Confirm that you trust the
583         //  controller of this contract, which in most situations should be
584         //  another open source smart contract or 0x0
585         if (msg.sender != controller) {
586             require(transfersEnabled);
587 
588             // The standard ERC 20 transferFrom functionality
589             if (allowed[_from][msg.sender] < _amount) return false;
590             allowed[_from][msg.sender] -= _amount;
591         }
592         return doTransfer(_from, _to, _amount);
593     }
594 
595     /// @dev This is the actual transfer function in the token contract, it can
596     ///  only be called by other functions in this contract.
597     /// @param _from The address holding the tokens being transferred
598     /// @param _to The address of the recipient
599     /// @param _amount The amount of tokens to be transferred
600     /// @return True if the transfer was successful
601     function doTransfer(address _from, address _to, uint _amount
602     ) internal returns(bool) {
603 
604            if (_amount == 0) {
605                return true;
606            }
607 
608            require(parentSnapShotBlock < block.number);
609 
610            // Do not allow transfer to 0x0 or the token contract itself
611            require((_to != 0) && (_to != address(this)));
612 
613            // If the amount being transfered is more than the balance of the
614            //  account the transfer returns false
615            var previousBalanceFrom = balanceOfAt(_from, block.number);
616            if (previousBalanceFrom < _amount) {
617                return false;
618            }
619 
620            // Alerts the token controller of the transfer
621            if (isContract(controller)) {
622                require(TokenController(controller).onTransfer(_from, _to, _amount));
623            }
624 
625            // First update the balance array with the new value for the address
626            //  sending the tokens
627            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
628 
629            // Then update the balance array with the new value for the address
630            //  receiving the tokens
631            var previousBalanceTo = balanceOfAt(_to, block.number);
632            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
633            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
634 
635            // An event to make the transfer easy to find on the blockchain
636            Transfer(_from, _to, _amount);
637 
638            return true;
639     }
640 
641     /// @param _owner The address that's balance is being requested
642     /// @return The balance of `_owner` at the current block
643     function balanceOf(address _owner) constant returns (uint256 balance) {
644         return balanceOfAt(_owner, block.number);
645     }
646 
647     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
648     ///  its behalf. This is a modified version of the ERC20 approve function
649     ///  to be a little bit safer
650     /// @param _spender The address of the account able to transfer the tokens
651     /// @param _amount The amount of tokens to be approved for transfer
652     /// @return True if the approval was successful
653     function approve(address _spender, uint256 _amount) returns (bool success) {
654         require(transfersEnabled);
655 
656         // To change the approve amount you first have to reduce the addresses`
657         //  allowance to zero by calling `approve(_spender,0)` if it is not
658         //  already 0 to mitigate the race condition described here:
659         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
660         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
661 
662         // Alerts the token controller of the approve function call
663         if (isContract(controller)) {
664             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
665         }
666 
667         allowed[msg.sender][_spender] = _amount;
668         Approval(msg.sender, _spender, _amount);
669         return true;
670     }
671 
672     /// @dev This function makes it easy to read the `allowed[]` map
673     /// @param _owner The address of the account that owns the token
674     /// @param _spender The address of the account able to transfer the tokens
675     /// @return Amount of remaining tokens of _owner that _spender is allowed
676     ///  to spend
677     function allowance(address _owner, address _spender
678     ) constant returns (uint256 remaining) {
679         return allowed[_owner][_spender];
680     }
681 
682     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
683     ///  its behalf, and then a function is triggered in the contract that is
684     ///  being approved, `_spender`. This allows users to use their tokens to
685     ///  interact with contracts in one function call instead of two
686     /// @param _spender The address of the contract able to transfer the tokens
687     /// @param _amount The amount of tokens to be approved for transfer
688     /// @return True if the function call was successful
689     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
690     ) returns (bool success) {
691         require(approve(_spender, _amount));
692 
693         ApproveAndCallFallBack(_spender).receiveApproval(
694             msg.sender,
695             _amount,
696             this,
697             _extraData
698         );
699 
700         return true;
701     }
702 
703     /// @dev This function makes it easy to get the total number of tokens
704     /// @return The total number of tokens
705     function totalSupply() constant returns (uint) {
706         return totalSupplyAt(block.number);
707     }
708 
709 
710 ////////////////
711 // Query balance and totalSupply in History
712 ////////////////
713 
714     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
715     /// @param _owner The address from which the balance will be retrieved
716     /// @param _blockNumber The block number when the balance is queried
717     /// @return The balance at `_blockNumber`
718     function balanceOfAt(address _owner, uint _blockNumber) constant
719         returns (uint) {
720 
721         // These next few lines are used when the balance of the token is
722         //  requested before a check point was ever created for this token, it
723         //  requires that the `parentToken.balanceOfAt` be queried at the
724         //  genesis block for that token as this contains initial balance of
725         //  this token
726         if ((balances[_owner].length == 0)
727             || (balances[_owner][0].fromBlock > _blockNumber)) {
728             if (address(parentToken) != 0) {
729                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
730             } else {
731                 // Has no parent
732                 return 0;
733             }
734 
735         // This will return the expected balance during normal situations
736         } else {
737             return getValueAt(balances[_owner], _blockNumber);
738         }
739     }
740 
741     /// @notice Total amount of tokens at a specific `_blockNumber`.
742     /// @param _blockNumber The block number when the totalSupply is queried
743     /// @return The total amount of tokens at `_blockNumber`
744     function totalSupplyAt(uint _blockNumber) constant returns(uint) {
745 
746         // These next few lines are used when the totalSupply of the token is
747         //  requested before a check point was ever created for this token, it
748         //  requires that the `parentToken.totalSupplyAt` be queried at the
749         //  genesis block for this token as that contains totalSupply of this
750         //  token at this block number.
751         if ((totalSupplyHistory.length == 0)
752             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
753             if (address(parentToken) != 0) {
754                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
755             } else {
756                 return 0;
757             }
758 
759         // This will return the expected totalSupply during normal situations
760         } else {
761             return getValueAt(totalSupplyHistory, _blockNumber);
762         }
763     }
764 
765 ////////////////
766 // Clone Token Method
767 ////////////////
768 
769     /// @notice Creates a new clone token with the initial distribution being
770     ///  this token at `_snapshotBlock`
771     /// @param _cloneTokenName Name of the clone token
772     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
773     /// @param _cloneTokenSymbol Symbol of the clone token
774     /// @param _snapshotBlock Block when the distribution of the parent token is
775     ///  copied to set the initial distribution of the new clone token;
776     ///  if the block is zero than the actual block, the current block is used
777     /// @param _transfersEnabled True if transfers are allowed in the clone
778     /// @return The address of the new MiniMeToken Contract
779     function createCloneToken(
780         string _cloneTokenName,
781         uint8 _cloneDecimalUnits,
782         string _cloneTokenSymbol,
783         uint _snapshotBlock,
784         bool _transfersEnabled
785         ) returns(address) {
786         if (_snapshotBlock == 0) _snapshotBlock = block.number;
787         MiniMeToken cloneToken = tokenFactory.createCloneToken(
788             this,
789             _snapshotBlock,
790             _cloneTokenName,
791             _cloneDecimalUnits,
792             _cloneTokenSymbol,
793             _transfersEnabled
794             );
795 
796         cloneToken.changeController(msg.sender);
797 
798         // An event to make the token easy to find on the blockchain
799         NewCloneToken(address(cloneToken), _snapshotBlock);
800         return address(cloneToken);
801     }
802 
803 ////////////////
804 // Generate and destroy tokens
805 ////////////////
806 
807     /// @notice Generates `_amount` tokens that are assigned to `_owner`
808     /// @param _owner The address that will be assigned the new tokens
809     /// @param _amount The quantity of tokens generated
810     /// @return True if the tokens are generated correctly
811     function generateTokens(address _owner, uint _amount
812     ) onlyController returns (bool) {
813         uint curTotalSupply = totalSupply();
814         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
815         uint previousBalanceTo = balanceOf(_owner);
816         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
817         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
818         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
819         Transfer(0, _owner, _amount);
820         return true;
821     }
822 
823 
824     /// @notice Burns `_amount` tokens from `_owner`
825     /// @param _owner The address that will lose the tokens
826     /// @param _amount The quantity of tokens to burn
827     /// @return True if the tokens are burned correctly
828     function destroyTokens(address _owner, uint _amount
829     ) onlyController returns (bool) {
830         uint curTotalSupply = totalSupply();
831         require(curTotalSupply >= _amount);
832         uint previousBalanceFrom = balanceOf(_owner);
833         require(previousBalanceFrom >= _amount);
834         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
835         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
836         Transfer(_owner, 0, _amount);
837         return true;
838     }
839 
840 ////////////////
841 // Enable tokens transfers
842 ////////////////
843 
844 
845     /// @notice Enables token holders to transfer their tokens freely if true
846     /// @param _transfersEnabled True if transfers are allowed in the clone
847     function enableTransfers(bool _transfersEnabled) onlyController {
848         transfersEnabled = _transfersEnabled;
849     }
850 
851 ////////////////
852 // Internal helper functions to query and set a value in a snapshot array
853 ////////////////
854 
855     /// @dev `getValueAt` retrieves the number of tokens at a given block number
856     /// @param checkpoints The history of values being queried
857     /// @param _block The block number to retrieve the value at
858     /// @return The number of tokens being queried
859     function getValueAt(Checkpoint[] storage checkpoints, uint _block
860     ) constant internal returns (uint) {
861         if (checkpoints.length == 0) return 0;
862 
863         // Shortcut for the actual value
864         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
865             return checkpoints[checkpoints.length-1].value;
866         if (_block < checkpoints[0].fromBlock) return 0;
867 
868         // Binary search of the value in the array
869         uint min = 0;
870         uint max = checkpoints.length-1;
871         while (max > min) {
872             uint mid = (max + min + 1)/ 2;
873             if (checkpoints[mid].fromBlock<=_block) {
874                 min = mid;
875             } else {
876                 max = mid-1;
877             }
878         }
879         return checkpoints[min].value;
880     }
881 
882     /// @dev `updateValueAtNow` used to update the `balances` map and the
883     ///  `totalSupplyHistory`
884     /// @param checkpoints The history of data being updated
885     /// @param _value The new number of tokens
886     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
887     ) internal  {
888         if ((checkpoints.length == 0)
889         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
890                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
891                newCheckPoint.fromBlock =  uint128(block.number);
892                newCheckPoint.value = uint128(_value);
893            } else {
894                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
895                oldCheckPoint.value = uint128(_value);
896            }
897     }
898 
899     /// @dev Internal function to determine if an address is a contract
900     /// @param _addr The address being queried
901     /// @return True if `_addr` is a contract
902     function isContract(address _addr) constant internal returns(bool) {
903         uint size;
904         if (_addr == 0) return false;
905         assembly {
906             size := extcodesize(_addr)
907         }
908         return size>0;
909     }
910 
911     /// @dev Helper function to return a min betwen the two uints
912     function min(uint a, uint b) internal returns (uint) {
913         return a < b ? a : b;
914     }
915 
916     /// @notice The fallback function: If the contract's controller has not been
917     ///  set to 0, then the `proxyPayment` method is called which relays the
918     ///  ether and creates tokens as described in the token controller contract
919     function ()  payable {
920         require(isContract(controller));
921         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
922     }
923 
924 //////////
925 // Safety Methods
926 //////////
927 
928     /// @notice This method can be used by the controller to extract mistakenly
929     ///  sent tokens to this contract.
930     /// @param _token The address of the token contract that you want to recover
931     ///  set to 0 in case you want to extract ether.
932     function claimTokens(address _token) onlyController {
933         if (_token == 0x0) {
934             controller.transfer(this.balance);
935             return;
936         }
937 
938         MiniMeToken token = MiniMeToken(_token);
939         uint balance = token.balanceOf(this);
940         token.transfer(controller, balance);
941         ClaimedTokens(_token, controller, balance);
942     }
943 
944 ////////////////
945 // Events
946 ////////////////
947     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
948     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
949     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
950     event Approval(
951         address indexed _owner,
952         address indexed _spender,
953         uint256 _amount
954         );
955 
956 }
957 
958 
959 ////////////////
960 // MiniMeTokenFactory
961 ////////////////
962 
963 /// @dev This contract is used to generate clone contracts from a contract.
964 ///  In solidity this is the way to create a contract from a contract of the
965 ///  same class
966 contract MiniMeTokenFactory {
967 
968     /// @notice Update the DApp by creating a new token with new functionalities
969     ///  the msg.sender becomes the controller of this clone token
970     /// @param _parentToken Address of the token being cloned
971     /// @param _snapshotBlock Block of the parent token that will
972     ///  determine the initial distribution of the clone token
973     /// @param _tokenName Name of the new token
974     /// @param _decimalUnits Number of decimals of the new token
975     /// @param _tokenSymbol Token Symbol for the new token
976     /// @param _transfersEnabled If true, tokens will be able to be transferred
977     /// @return The address of the new token contract
978     function createCloneToken(
979         address _parentToken,
980         uint _snapshotBlock,
981         string _tokenName,
982         uint8 _decimalUnits,
983         string _tokenSymbol,
984         bool _transfersEnabled
985     ) returns (MiniMeToken) 
986     {
987         MiniMeToken newToken = new MiniMeToken(
988             this,
989             _parentToken,
990             _snapshotBlock,
991             _tokenName,
992             _decimalUnits,
993             _tokenSymbol,
994             _transfersEnabled
995             );
996 
997         newToken.changeController(msg.sender);
998         return newToken;
999     }
1000 }
1001 
1002 contract SHP is MiniMeToken {
1003     // @dev SHP constructor
1004     function SHP(address _tokenFactory)
1005             MiniMeToken(
1006                 _tokenFactory,
1007                 0x0,                             // no parent token
1008                 0,                               // no snapshot block number from parent
1009                 "Sharpe Platform Token",         // Token name
1010                 18,                              // Decimals
1011                 "SHP",                           // Symbol
1012                 true                             // Enable transfers
1013             ) {}
1014 }
1015 
1016 contract AffiliateUtility is Owned {
1017     using SafeMath for uint256;
1018     
1019     uint256 public tierTwoMin;
1020     uint256 public tierThreeMin;
1021 
1022     uint256 public constant TIER1_PERCENT = 3;
1023     uint256 public constant TIER2_PERCENT = 4;
1024     uint256 public constant TIER3_PERCENT = 5;
1025     
1026     mapping (address => Affiliate) private affiliates;
1027 
1028     event AffiliateReceived(address affiliateAddress, address investorAddress, bool valid);
1029 
1030     struct Affiliate {
1031         address etherAddress;
1032         bool isPresent;
1033     }
1034 
1035     function AffiliateUtility(uint256 _tierTwoMin, uint256 _tierThreeMin) {
1036         setTiers(_tierTwoMin, _tierThreeMin);
1037     }
1038 
1039     /// @notice sets the Ether to Dollar exhchange rate
1040     /// @param _tierTwoMin the tier 2 min (in WEI)
1041     /// @param _tierThreeMin the tier 3 min (in WEI)
1042     function setTiers(uint256 _tierTwoMin, uint256 _tierThreeMin) onlyOwner {
1043         tierTwoMin = _tierTwoMin;
1044         tierThreeMin = _tierThreeMin;
1045     }
1046 
1047     /// @notice This adds an affiliate Ethereum address to our whitelist
1048     /// @param _investor The investor's address
1049     /// @param _affiliate The Ethereum address of the affiliate
1050     function addAffiliate(address _investor, address _affiliate) onlyOwner {
1051         affiliates[_investor] = Affiliate(_affiliate, true);
1052     }
1053 
1054     /// @notice calculates and returns the amount to token minted for affilliate
1055     /// @param _investor address of the investor
1056     /// @param _contributorTokens amount of SHP tokens minted for contributor
1057     /// @param _contributionValue amount of ETH contributed
1058     /// @return tuple of two values (affiliateBonus, contributorBouns)
1059     function applyAffiliate(
1060         address _investor, 
1061         uint256 _contributorTokens, 
1062         uint256 _contributionValue
1063     )
1064         public 
1065         returns(uint256, uint256) 
1066     {
1067         if (getAffiliate(_investor) == address(0)) {
1068             return (0, 0);
1069         }
1070 
1071         uint256 contributorBonus = _contributorTokens.div(100);
1072         uint256 affiliateBonus = 0;
1073 
1074         if (_contributionValue < tierTwoMin) {
1075             affiliateBonus = _contributorTokens.mul(TIER1_PERCENT).div(100);
1076         } else if (_contributionValue >= tierTwoMin && _contributionValue < tierThreeMin) {
1077             affiliateBonus = _contributorTokens.mul(TIER2_PERCENT).div(100);
1078         } else {
1079             affiliateBonus = _contributorTokens.mul(TIER3_PERCENT).div(100);
1080         }
1081 
1082         return(affiliateBonus, contributorBonus);
1083     }
1084 
1085     /// @notice Fetches the Ethereum address of a valid affiliate
1086     /// @param _investor The Ethereum address of the investor
1087     /// @return The Ethereum address as an address type
1088     function getAffiliate(address _investor) constant returns(address) {
1089         return affiliates[_investor].etherAddress;
1090     }
1091 
1092     /// @notice Checks if an affiliate is valid
1093     /// @param _investor The Ethereum address of the investor
1094     /// @return True or False
1095     function isAffiliateValid(address _investor) constant public returns(bool) {
1096         Affiliate memory affiliate = affiliates[_investor];
1097         AffiliateReceived(affiliate.etherAddress, _investor, affiliate.isPresent);
1098         return affiliate.isPresent;
1099     }
1100 }
1101 
1102 contract SCD is MiniMeToken {
1103     // @dev SCD constructor
1104     function SCD(address _tokenFactory)
1105             MiniMeToken(
1106                 _tokenFactory,
1107                 0x0,                             // no parent token
1108                 0,                               // no snapshot block number from parent
1109                 "Sharpe Crypto-Derivative",      // Token name
1110                 18,                              // Decimals
1111                 "SCD",                           // Symbol
1112                 true                             // Enable transfers
1113             ) {}
1114 }
1115 
1116 
1117 contract TokenSale is Owned, TokenController {
1118     using SafeMath for uint256;
1119     
1120     SHP public shp;
1121     AffiliateUtility public affiliateUtility;
1122     Trustee public trustee;
1123 
1124     address public etherEscrowAddress;
1125     address public bountyAddress;
1126     address public trusteeAddress;
1127     address public apiAddress;
1128 
1129     uint256 public founderTokenCount = 0;
1130     uint256 public reserveTokenCount = 0;
1131 
1132     uint256 constant public CALLER_EXCHANGE_RATE = 2000;
1133     uint256 constant public RESERVE_EXCHANGE_RATE = 1500;
1134     uint256 constant public FOUNDER_EXCHANGE_RATE = 1000;
1135     uint256 constant public BOUNTY_EXCHANGE_RATE = 500;
1136     uint256 constant public MAX_GAS_PRICE = 50000000000;
1137 
1138     bool public paused;
1139     bool public closed;
1140 
1141     mapping(address => bool) public approvedAddresses;
1142 
1143     event Contribution(uint256 etherAmount, address _caller);
1144     event NewSale(address indexed caller, uint256 etherAmount, uint256 tokensGenerated);
1145     event SaleClosed(uint256 when);
1146     
1147     modifier notPaused() {
1148         require(!paused);
1149         _;
1150     }
1151 
1152     modifier notClosed() {
1153         require(!closed);
1154         _;
1155     }
1156 
1157     modifier onlyApi() {
1158         require(msg.sender == apiAddress);
1159         _;
1160     }
1161 
1162     modifier isValidated() {
1163         require(msg.sender != 0x0);
1164         require(msg.value > 0);
1165         require(!isContract(msg.sender)); 
1166         require(tx.gasprice <= MAX_GAS_PRICE);
1167         _;
1168     }
1169 
1170     modifier isApproved() {
1171         require(approvedAddresses[msg.sender]);
1172         _;
1173     }
1174 
1175     /// @notice Adds an approved address for the sale
1176     /// @param _addr The address to approve for contribution
1177     function approveAddress(address _addr) public onlyApi {
1178         approvedAddresses[_addr] = true;
1179     }
1180 
1181     /// @notice This method sends the Ether received to the Ether escrow address
1182     /// and generates the calculated number of SHP tokens, sending them to the caller's address.
1183     /// It also generates the founder's tokens and the reserve tokens at the same time.
1184     function doBuy(
1185         address _caller,
1186         uint256 etherAmount
1187     )
1188         internal
1189     {
1190 
1191         Contribution(etherAmount, _caller);
1192 
1193         uint256 callerTokens = etherAmount.mul(CALLER_EXCHANGE_RATE);
1194         uint256 callerTokensWithDiscount = applyDiscount(etherAmount, callerTokens);
1195 
1196         uint256 reserveTokens = etherAmount.mul(RESERVE_EXCHANGE_RATE);
1197         uint256 founderTokens = etherAmount.mul(FOUNDER_EXCHANGE_RATE);
1198         uint256 bountyTokens = etherAmount.mul(BOUNTY_EXCHANGE_RATE);
1199         uint256 vestingTokens = founderTokens.add(reserveTokens);
1200 
1201         founderTokenCount = founderTokenCount.add(founderTokens);
1202         reserveTokenCount = reserveTokenCount.add(reserveTokens);
1203 
1204         payAffiliate(callerTokensWithDiscount, msg.value, msg.sender);
1205 
1206         shp.generateTokens(_caller, callerTokensWithDiscount);
1207         shp.generateTokens(bountyAddress, bountyTokens);
1208         shp.generateTokens(trusteeAddress, vestingTokens);
1209 
1210         NewSale(_caller, etherAmount, callerTokensWithDiscount);
1211         NewSale(trusteeAddress, etherAmount, vestingTokens);
1212         NewSale(bountyAddress, etherAmount, bountyTokens);
1213 
1214         etherEscrowAddress.transfer(etherAmount);
1215         updateCounters(etherAmount);
1216     }
1217 
1218     /// @notice Applies the discount based on the discount tiers
1219     /// @param _etherAmount The amount of ether used to evaluate the tier the contribution lies within
1220     /// @param _contributorTokens The tokens allocated based on the contribution
1221     function applyDiscount(uint256 _etherAmount, uint256 _contributorTokens) internal constant returns (uint256);
1222 
1223     /// @notice Updates the counters for the amount of Ether paid
1224     /// @param _etherAmount the amount of Ether paid
1225     function updateCounters(uint256 _etherAmount) internal;
1226     
1227     /// @notice Parent constructor. This needs to be extended from the child contracts
1228     /// @param _etherEscrowAddress the address that will hold the crowd funded Ether
1229     /// @param _bountyAddress the address that will hold the bounty scheme SHP
1230     /// @param _trusteeAddress the address that will hold the vesting SHP
1231     /// @param _affiliateUtilityAddress address of the deployed AffiliateUtility contract.
1232     function TokenSale (
1233         address _etherEscrowAddress,
1234         address _bountyAddress,
1235         address _trusteeAddress,
1236         address _affiliateUtilityAddress,
1237         address _apiAddress
1238     ) {
1239         etherEscrowAddress = _etherEscrowAddress;
1240         bountyAddress = _bountyAddress;
1241         trusteeAddress = _trusteeAddress;
1242         apiAddress = _apiAddress;
1243         affiliateUtility = AffiliateUtility(_affiliateUtilityAddress);
1244         trustee = Trustee(_trusteeAddress);
1245         paused = true;
1246         closed = false;
1247     }
1248 
1249     /// @notice Pays an affiliate if they are valid and present in the transaction data
1250     /// @param _tokens The contribution tokens used to calculate affiliate payment amount
1251     /// @param _etherValue The Ether value sent
1252     /// @param _caller The address of the caller
1253     function payAffiliate(uint256 _tokens, uint256 _etherValue, address _caller) internal {
1254         if (affiliateUtility.isAffiliateValid(_caller)) {
1255             address affiliate = affiliateUtility.getAffiliate(_caller);
1256             var (affiliateBonus, contributorBonus) = affiliateUtility.applyAffiliate(_caller, _tokens, _etherValue);
1257             shp.generateTokens(affiliate, affiliateBonus);
1258             shp.generateTokens(_caller, contributorBonus);
1259         }
1260     }
1261 
1262     /// @notice Sets the SHP token smart contract
1263     /// @param _shp the SHP token contract address
1264     function setShp(address _shp) public onlyOwner {
1265         shp = SHP(_shp);
1266     }
1267 
1268     /// @notice Transfers ownership of the token smart contract and trustee
1269     /// @param _tokenController the address of the new token controller
1270     /// @param _trusteeOwner the address of the new trustee owner
1271     function transferOwnership(address _tokenController, address _trusteeOwner) public onlyOwner {
1272         require(closed);
1273         require(_tokenController != 0x0);
1274         require(_trusteeOwner != 0x0);
1275         shp.changeController(_tokenController);
1276         trustee.changeOwner(_trusteeOwner);
1277     }
1278 
1279     /// @notice Internal function to determine if an address is a contract
1280     /// @param _caller The address being queried
1281     /// @return True if `caller` is a contract
1282     function isContract(address _caller) internal constant returns (bool) {
1283         uint size;
1284         assembly { size := extcodesize(_caller) }
1285         return size > 0;
1286     }
1287 
1288     /// @notice Pauses the contribution if there is any issue
1289     function pauseContribution() public onlyOwner {
1290         paused = true;
1291     }
1292 
1293     /// @notice Resumes the contribution
1294     function resumeContribution() public onlyOwner {
1295         paused = false;
1296     }
1297 
1298     //////////
1299     // MiniMe Controller Interface functions
1300     //////////
1301 
1302     // In between the offering and the network. Default settings for allowing token transfers.
1303     function proxyPayment(address) public payable returns (bool) {
1304         return false;
1305     }
1306 
1307     function onTransfer(address, address, uint256) public returns (bool) {
1308         return false;
1309     }
1310 
1311     function onApprove(address, address, uint256) public returns (bool) {
1312         return false;
1313     }
1314 }
1315 
1316 
1317 contract SharpeCrowdsale is TokenSale {
1318 
1319     uint256 public totalEtherPaid = 0;
1320     uint256 public minContributionInWei;
1321     address public saleAddress;
1322     
1323     DynamicCeiling public dynamicCeiling;
1324 
1325     modifier amountValidated() {
1326         require(msg.value >= minContributionInWei);
1327         _;
1328     }
1329 
1330     /// @notice Constructs the contract with the following arguments
1331     /// @param _etherEscrowAddress the address that will hold the crowd funded Ether
1332     /// @param _bountyAddress the address that will hold the bounty SHP
1333     /// @param _trusteeAddress the address that will hold the vesting SHP
1334     /// @param _affiliateUtilityAddress address of the deployed AffiliateUtility contract.
1335     /// @param _minContributionInWei minimum amount to contribution possilble
1336     function SharpeCrowdsale( 
1337         address _etherEscrowAddress,
1338         address _bountyAddress,
1339         address _trusteeAddress,
1340         address _affiliateUtilityAddress,
1341         address _apiAddress,
1342         uint256 _minContributionInWei) 
1343         TokenSale (
1344         _etherEscrowAddress,
1345         _bountyAddress,
1346         _trusteeAddress,
1347         _affiliateUtilityAddress,
1348         _apiAddress) 
1349     {
1350         minContributionInWei = _minContributionInWei;
1351         saleAddress = address(this);
1352     }
1353 
1354     function setDynamicCeilingAddress(address _dynamicCeilingAddress) public onlyOwner {
1355         dynamicCeiling = DynamicCeiling(_dynamicCeilingAddress);
1356     }
1357 
1358     function () 
1359         public 
1360         payable
1361         notPaused
1362         notClosed
1363         isValidated 
1364         amountValidated
1365         isApproved
1366     {
1367         uint256 contribution = msg.value;
1368         uint256 remaining = dynamicCeiling.availableAmountToCollect(totalEtherPaid);
1369         uint256 refund = 0;
1370 
1371         if (remaining == 0) {
1372             revert();
1373         }
1374 
1375         if (contribution > remaining) {
1376             contribution = remaining;
1377             refund = msg.value.sub(contribution);
1378         }
1379         doBuy(msg.sender, contribution);
1380         if (refund > 0) {
1381             msg.sender.transfer(refund);
1382         }
1383     }
1384 
1385     /// @notice Applies the discount based on the discount tiers
1386     /// @param _etherAmount The amount of ether used to evaluate the tier the contribution lies within
1387     /// @param _contributorTokens The tokens allocated based on the contribution
1388     function applyDiscount(uint256 _etherAmount, uint256 _contributorTokens) internal constant returns (uint256) {
1389         return _contributorTokens;
1390     }
1391 
1392     /// @notice Updates the counters for the amount of Ether paid
1393     /// @param _etherAmount the amount of Ether paid
1394     function updateCounters(uint256 _etherAmount) internal {
1395         totalEtherPaid = totalEtherPaid.add(_etherAmount);
1396     }
1397 
1398     /// @notice Public function enables closing of the crowdsale manually if necessary
1399     function closeSale() public onlyOwner {
1400         closed = true;
1401         SaleClosed(now);
1402     }
1403 }