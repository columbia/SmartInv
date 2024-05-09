1 pragma solidity ^0.4.11;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   /**
8    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
9    * account.
10    */
11   function Ownable() {
12     owner = msg.sender;
13   }
14 
15 
16   /**
17    * @dev Throws if called by any account other than the owner.
18    */
19   modifier onlyOwner() {
20     require(msg.sender == owner);
21     _;
22   }
23 
24 
25   /**
26    * @dev Allows the current owner to transfer control of the contract to a newOwner.
27    * @param newOwner The address to transfer ownership to.
28    */
29   function transferOwnership(address newOwner) onlyOwner {
30     if (newOwner != address(0)) {
31       owner = newOwner;
32     }
33   }
34 
35 }
36 
37 /*
38     Copyright 2016, Jordi Baylina
39 
40     This program is free software: you can redistribute it and/or modify
41     it under the terms of the GNU General Public License as published by
42     the Free Software Foundation, either version 3 of the License, or
43     (at your option) any later version.
44 
45     This program is distributed in the hope that it will be useful,
46     but WITHOUT ANY WARRANTY; without even the implied warranty of
47     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
48     GNU General Public License for more details.
49 
50     You should have received a copy of the GNU General Public License
51     along with this program.  If not, see <http://www.gnu.org/licenses/>.
52  */
53 
54 /// @title MiniMeToken Contract
55 /// @author Jordi Baylina
56 /// @dev This token contract's goal is to make it easy for anyone to clone this
57 ///  token using the token distribution at a given block, this will allow DAO's
58 ///  and DApps to upgrade their features in a decentralized manner without
59 ///  affecting the original token
60 /// @dev It is ERC20 compliant, but still needs to under go further testing.
61 
62 
63 /// @dev The token controller contract must implement these functions
64 contract TokenController {
65     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
66     /// @param _owner The address that sent the ether to create tokens
67     /// @return True if the ether is accepted, false if it throws
68     function proxyPayment(address _owner) payable returns(bool);
69 
70     /// @notice Notifies the controller about a token transfer allowing the
71     ///  controller to react if desired
72     /// @param _from The origin of the transfer
73     /// @param _to The destination of the transfer
74     /// @param _amount The amount of the transfer
75     /// @return False if the controller does not authorize the transfer
76     function onTransfer(address _from, address _to, uint _amount) returns(bool);
77 
78     /// @notice Notifies the controller about an approval allowing the
79     ///  controller to react if desired
80     /// @param _owner The address that calls `approve()`
81     /// @param _spender The spender in the `approve()` call
82     /// @param _amount The amount in the `approve()` call
83     /// @return False if the controller does not authorize the approval
84     function onApprove(address _owner, address _spender, uint _amount)
85         returns(bool);
86 }
87 
88 contract Controlled {
89     /// @notice The address of the controller is the only address that can call
90     ///  a function with this modifier
91     modifier onlyController { if (msg.sender != controller) throw; _; }
92 
93     address public controller;
94 
95     function Controlled() { controller = msg.sender;}
96 
97     /// @notice Changes the controller of the contract
98     /// @param _newController The new controller of the contract
99     function changeController(address _newController) onlyController {
100         controller = _newController;
101     }
102 }
103 
104 contract ApproveAndCallFallBack {
105     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
106 }
107 
108 /// @dev The actual token contract, the default controller is the msg.sender
109 ///  that deploys the contract, so usually this token will be deployed by a
110 ///  token controller contract, which Giveth will call a "Campaign"
111 contract MiniMeToken is Controlled {
112 
113     string public name;                //The Token's name: e.g. DigixDAO Tokens
114     uint8 public decimals;             //Number of decimals of the smallest unit
115     string public symbol;              //An identifier: e.g. REP
116     string public version = 'MMT_0.1'; //An arbitrary versioning scheme
117 
118     /// @dev `Checkpoint` is the structure that attaches a block number to a
119     ///  given value, the block number attached is the one that last changed the
120     ///  value
121     struct  Checkpoint {
122 
123         // `fromBlock` is the block number that the value was generated from
124         uint128 fromBlock;
125 
126         // `value` is the amount of tokens at a specific block number
127         uint128 value;
128     }
129 
130     // `parentToken` is the Token address that was cloned to produce this token;
131     //  it will be 0x0 for a token that was not cloned
132     MiniMeToken public parentToken;
133 
134     // `parentSnapShotBlock` is the block number from the Parent Token that was
135     //  used to determine the initial distribution of the Clone Token
136     uint public parentSnapShotBlock;
137 
138     // `creationBlock` is the block number that the Clone Token was created
139     uint public creationBlock;
140 
141     // `balances` is the map that tracks the balance of each address, in this
142     //  contract when the balance changes the block number that the change
143     //  occurred is also included in the map
144     mapping (address => Checkpoint[]) balances;
145 
146     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
147     mapping (address => mapping (address => uint256)) allowed;
148 
149     // Tracks the history of the `totalSupply` of the token
150     Checkpoint[] totalSupplyHistory;
151 
152     // Flag that determines if the token is transferable or not.
153     bool public transfersEnabled;
154 
155     // The factory used to create new clone tokens
156     MiniMeTokenFactory public tokenFactory;
157 
158 ////////////////
159 // Constructor
160 ////////////////
161 
162     /// @notice Constructor to create a MiniMeToken
163     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
164     ///  will create the Clone token contracts, the token factory needs to be
165     ///  deployed first
166     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
167     ///  new token
168     /// @param _parentSnapShotBlock Block of the parent token that will
169     ///  determine the initial distribution of the clone token, set to 0 if it
170     ///  is a new token
171     /// @param _tokenName Name of the new token
172     /// @param _decimalUnits Number of decimals of the new token
173     /// @param _tokenSymbol Token Symbol for the new token
174     /// @param _transfersEnabled If true, tokens will be able to be transferred
175     function MiniMeToken(
176         address _tokenFactory,
177         address _parentToken,
178         uint _parentSnapShotBlock,
179         string _tokenName,
180         uint8 _decimalUnits,
181         string _tokenSymbol,
182         bool _transfersEnabled
183     ) {
184         tokenFactory = MiniMeTokenFactory(_tokenFactory);
185         name = _tokenName;                                 // Set the name
186         decimals = _decimalUnits;                          // Set the decimals
187         symbol = _tokenSymbol;                             // Set the symbol
188         parentToken = MiniMeToken(_parentToken);
189         parentSnapShotBlock = _parentSnapShotBlock;
190         transfersEnabled = _transfersEnabled;
191         creationBlock = block.number;
192     }
193 
194 
195 ///////////////////
196 // ERC20 Methods
197 ///////////////////
198 
199     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
200     /// @param _to The address of the recipient
201     /// @param _amount The amount of tokens to be transferred
202     /// @return Whether the transfer was successful or not
203     function transfer(address _to, uint256 _amount) returns (bool success) {
204         if (!transfersEnabled) throw;
205         return doTransfer(msg.sender, _to, _amount);
206     }
207 
208     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
209     ///  is approved by `_from`
210     /// @param _from The address holding the tokens being transferred
211     /// @param _to The address of the recipient
212     /// @param _amount The amount of tokens to be transferred
213     /// @return True if the transfer was successful
214     function transferFrom(address _from, address _to, uint256 _amount
215     ) returns (bool success) {
216 
217         // The controller of this contract can move tokens around at will,
218         //  this is important to recognize! Confirm that you trust the
219         //  controller of this contract, which in most situations should be
220         //  another open source smart contract or 0x0
221         if (msg.sender != controller) {
222             if (!transfersEnabled) throw;
223 
224             // The standard ERC 20 transferFrom functionality
225             if (allowed[_from][msg.sender] < _amount) return false;
226             allowed[_from][msg.sender] -= _amount;
227         }
228         return doTransfer(_from, _to, _amount);
229     }
230 
231     /// @dev This is the actual transfer function in the token contract, it can
232     ///  only be called by other functions in this contract.
233     /// @param _from The address holding the tokens being transferred
234     /// @param _to The address of the recipient
235     /// @param _amount The amount of tokens to be transferred
236     /// @return True if the transfer was successful
237     function doTransfer(address _from, address _to, uint _amount
238     ) internal returns(bool) {
239 
240            if (_amount == 0) {
241                return true;
242            }
243 
244            if (parentSnapShotBlock >= block.number) throw;
245 
246            // Do not allow transfer to 0x0 or the token contract itself
247            if ((_to == 0) || (_to == address(this))) throw;
248 
249            // If the amount being transfered is more than the balance of the
250            //  account the transfer returns false
251            var previousBalanceFrom = balanceOfAt(_from, block.number);
252            if (previousBalanceFrom < _amount) {
253                return false;
254            }
255 
256            // Alerts the token controller of the transfer
257            if (isContract(controller)) {
258                if (!TokenController(controller).onTransfer(_from, _to, _amount))
259                throw;
260            }
261 
262            // First update the balance array with the new value for the address
263            //  sending the tokens
264            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
265 
266            // Then update the balance array with the new value for the address
267            //  receiving the tokens
268            var previousBalanceTo = balanceOfAt(_to, block.number);
269            if (previousBalanceTo + _amount < previousBalanceTo) throw; // Check for overflow
270            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
271 
272            // An event to make the transfer easy to find on the blockchain
273            Transfer(_from, _to, _amount);
274 
275            return true;
276     }
277 
278     /// @param _owner The address that's balance is being requested
279     /// @return The balance of `_owner` at the current block
280     function balanceOf(address _owner) constant returns (uint256 balance) {
281         return balanceOfAt(_owner, block.number);
282     }
283 
284     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
285     ///  its behalf. This is a modified version of the ERC20 approve function
286     ///  to be a little bit safer
287     /// @param _spender The address of the account able to transfer the tokens
288     /// @param _amount The amount of tokens to be approved for transfer
289     /// @return True if the approval was successful
290     function approve(address _spender, uint256 _amount) returns (bool success) {
291         if (!transfersEnabled) throw;
292 
293         // To change the approve amount you first have to reduce the addresses`
294         //  allowance to zero by calling `approve(_spender,0)` if it is not
295         //  already 0 to mitigate the race condition described here:
296         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
297         if ((_amount!=0) && (allowed[msg.sender][_spender] !=0)) throw;
298 
299         // Alerts the token controller of the approve function call
300         if (isContract(controller)) {
301             if (!TokenController(controller).onApprove(msg.sender, _spender, _amount))
302                 throw;
303         }
304 
305         allowed[msg.sender][_spender] = _amount;
306         Approval(msg.sender, _spender, _amount);
307         return true;
308     }
309 
310     /// @dev This function makes it easy to read the `allowed[]` map
311     /// @param _owner The address of the account that owns the token
312     /// @param _spender The address of the account able to transfer the tokens
313     /// @return Amount of remaining tokens of _owner that _spender is allowed
314     ///  to spend
315     function allowance(address _owner, address _spender
316     ) constant returns (uint256 remaining) {
317         return allowed[_owner][_spender];
318     }
319 
320     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
321     ///  its behalf, and then a function is triggered in the contract that is
322     ///  being approved, `_spender`. This allows users to use their tokens to
323     ///  interact with contracts in one function call instead of two
324     /// @param _spender The address of the contract able to transfer the tokens
325     /// @param _amount The amount of tokens to be approved for transfer
326     /// @return True if the function call was successful
327     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
328     ) returns (bool success) {
329         if (!approve(_spender, _amount)) throw;
330 
331         ApproveAndCallFallBack(_spender).receiveApproval(
332             msg.sender,
333             _amount,
334             this,
335             _extraData
336         );
337 
338         return true;
339     }
340 
341     /// @dev This function makes it easy to get the total number of tokens
342     /// @return The total number of tokens
343     function totalSupply() constant returns (uint) {
344         return totalSupplyAt(block.number);
345     }
346 
347 
348 ////////////////
349 // Query balance and totalSupply in History
350 ////////////////
351 
352     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
353     /// @param _owner The address from which the balance will be retrieved
354     /// @param _blockNumber The block number when the balance is queried
355     /// @return The balance at `_blockNumber`
356     function balanceOfAt(address _owner, uint _blockNumber) constant
357         returns (uint) {
358 
359         // These next few lines are used when the balance of the token is
360         //  requested before a check point was ever created for this token, it
361         //  requires that the `parentToken.balanceOfAt` be queried at the
362         //  genesis block for that token as this contains initial balance of
363         //  this token
364         if ((balances[_owner].length == 0)
365             || (balances[_owner][0].fromBlock > _blockNumber)) {
366             if (address(parentToken) != 0) {
367                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
368             } else {
369                 // Has no parent
370                 return 0;
371             }
372 
373         // This will return the expected balance during normal situations
374         } else {
375             return getValueAt(balances[_owner], _blockNumber);
376         }
377     }
378 
379     /// @notice Total amount of tokens at a specific `_blockNumber`.
380     /// @param _blockNumber The block number when the totalSupply is queried
381     /// @return The total amount of tokens at `_blockNumber`
382     function totalSupplyAt(uint _blockNumber) constant returns(uint) {
383 
384         // These next few lines are used when the totalSupply of the token is
385         //  requested before a check point was ever created for this token, it
386         //  requires that the `parentToken.totalSupplyAt` be queried at the
387         //  genesis block for this token as that contains totalSupply of this
388         //  token at this block number.
389         if ((totalSupplyHistory.length == 0)
390             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
391             if (address(parentToken) != 0) {
392                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
393             } else {
394                 return 0;
395             }
396 
397         // This will return the expected totalSupply during normal situations
398         } else {
399             return getValueAt(totalSupplyHistory, _blockNumber);
400         }
401     }
402 
403 ////////////////
404 // Clone Token Method
405 ////////////////
406 
407     /// @notice Creates a new clone token with the initial distribution being
408     ///  this token at `_snapshotBlock`
409     /// @param _cloneTokenName Name of the clone token
410     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
411     /// @param _cloneTokenSymbol Symbol of the clone token
412     /// @param _snapshotBlock Block when the distribution of the parent token is
413     ///  copied to set the initial distribution of the new clone token;
414     ///  if the block is zero than the actual block, the current block is used
415     /// @param _transfersEnabled True if transfers are allowed in the clone
416     /// @return The address of the new MiniMeToken Contract
417     function createCloneToken(
418         string _cloneTokenName,
419         uint8 _cloneDecimalUnits,
420         string _cloneTokenSymbol,
421         uint _snapshotBlock,
422         bool _transfersEnabled
423         ) returns(address) {
424         if (_snapshotBlock == 0) _snapshotBlock = block.number;
425         MiniMeToken cloneToken = tokenFactory.createCloneToken(
426             this,
427             _snapshotBlock,
428             _cloneTokenName,
429             _cloneDecimalUnits,
430             _cloneTokenSymbol,
431             _transfersEnabled
432             );
433 
434         cloneToken.changeController(msg.sender);
435 
436         // An event to make the token easy to find on the blockchain
437         NewCloneToken(address(cloneToken), _snapshotBlock);
438         return address(cloneToken);
439     }
440 
441 ////////////////
442 // Generate and destroy tokens
443 ////////////////
444 
445     /// @notice Generates `_amount` tokens that are assigned to `_owner`
446     /// @param _owner The address that will be assigned the new tokens
447     /// @param _amount The quantity of tokens generated
448     /// @return True if the tokens are generated correctly
449     function generateTokens(address _owner, uint _amount
450     ) onlyController returns (bool) {
451         uint curTotalSupply = getValueAt(totalSupplyHistory, block.number);
452         if (curTotalSupply + _amount < curTotalSupply) throw; // Check for overflow
453         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
454         var previousBalanceTo = balanceOf(_owner);
455         if (previousBalanceTo + _amount < previousBalanceTo) throw; // Check for overflow
456         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
457         Transfer(0, _owner, _amount);
458         return true;
459     }
460 
461 
462     /// @notice Burns `_amount` tokens from `_owner`
463     /// @param _owner The address that will lose the tokens
464     /// @param _amount The quantity of tokens to burn
465     /// @return True if the tokens are burned correctly
466     function destroyTokens(address _owner, uint _amount
467     ) onlyController returns (bool) {
468         uint curTotalSupply = getValueAt(totalSupplyHistory, block.number);
469         if (curTotalSupply < _amount) throw;
470         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
471         var previousBalanceFrom = balanceOf(_owner);
472         if (previousBalanceFrom < _amount) throw;
473         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
474         Transfer(_owner, 0, _amount);
475         return true;
476     }
477 
478 ////////////////
479 // Enable tokens transfers
480 ////////////////
481 
482 
483     /// @notice Enables token holders to transfer their tokens freely if true
484     /// @param _transfersEnabled True if transfers are allowed in the clone
485     function enableTransfers(bool _transfersEnabled) onlyController {
486         transfersEnabled = _transfersEnabled;
487     }
488 
489 ////////////////
490 // Internal helper functions to query and set a value in a snapshot array
491 ////////////////
492 
493     /// @dev `getValueAt` retrieves the number of tokens at a given block number
494     /// @param checkpoints The history of values being queried
495     /// @param _block The block number to retrieve the value at
496     /// @return The number of tokens being queried
497     function getValueAt(Checkpoint[] storage checkpoints, uint _block
498     ) constant internal returns (uint) {
499         if (checkpoints.length == 0) return 0;
500 
501         // Shortcut for the actual value
502         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
503             return checkpoints[checkpoints.length-1].value;
504         if (_block < checkpoints[0].fromBlock) return 0;
505 
506         // Binary search of the value in the array
507         uint min = 0;
508         uint max = checkpoints.length-1;
509         while (max > min) {
510             uint mid = (max + min + 1)/ 2;
511             if (checkpoints[mid].fromBlock<=_block) {
512                 min = mid;
513             } else {
514                 max = mid-1;
515             }
516         }
517         return checkpoints[min].value;
518     }
519 
520     /// @dev `updateValueAtNow` used to update the `balances` map and the
521     ///  `totalSupplyHistory`
522     /// @param checkpoints The history of data being updated
523     /// @param _value The new number of tokens
524     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
525     ) internal  {
526         if ((checkpoints.length == 0)
527         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
528                Checkpoint newCheckPoint = checkpoints[ checkpoints.length++ ];
529                newCheckPoint.fromBlock =  uint128(block.number);
530                newCheckPoint.value = uint128(_value);
531            } else {
532                Checkpoint oldCheckPoint = checkpoints[checkpoints.length-1];
533                oldCheckPoint.value = uint128(_value);
534            }
535     }
536 
537     /// @dev Internal function to determine if an address is a contract
538     /// @param _addr The address being queried
539     /// @return True if `_addr` is a contract
540     function isContract(address _addr) constant internal returns(bool) {
541         uint size;
542         if (_addr == 0) return false;
543         assembly {
544             size := extcodesize(_addr)
545         }
546         return size>0;
547     }
548 
549     /// @dev Helper function to return a min betwen the two uints
550     function min(uint a, uint b) internal returns (uint) {
551         return a < b ? a : b;
552     }
553 
554     /// @notice The fallback function: If the contract's controller has not been
555     ///  set to 0, then the `proxyPayment` method is called which relays the
556     ///  ether and creates tokens as described in the token controller contract
557     function ()  payable {
558         if (isContract(controller)) {
559             if (! TokenController(controller).proxyPayment.value(msg.value)(msg.sender))
560                 throw;
561         } else {
562             throw;
563         }
564     }
565 
566 
567 ////////////////
568 // Events
569 ////////////////
570     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
571     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
572     event Approval(
573         address indexed _owner,
574         address indexed _spender,
575         uint256 _amount
576         );
577 
578 }
579 
580 
581 ////////////////
582 // MiniMeTokenFactory
583 ////////////////
584 
585 /// @dev This contract is used to generate clone contracts from a contract.
586 ///  In solidity this is the way to create a contract from a contract of the
587 ///  same class
588 contract MiniMeTokenFactory {
589 
590     /// @notice Update the DApp by creating a new token with new functionalities
591     ///  the msg.sender becomes the controller of this clone token
592     /// @param _parentToken Address of the token being cloned
593     /// @param _snapshotBlock Block of the parent token that will
594     ///  determine the initial distribution of the clone token
595     /// @param _tokenName Name of the new token
596     /// @param _decimalUnits Number of decimals of the new token
597     /// @param _tokenSymbol Token Symbol for the new token
598     /// @param _transfersEnabled If true, tokens will be able to be transferred
599     /// @return The address of the new token contract
600     function createCloneToken(
601         address _parentToken,
602         uint _snapshotBlock,
603         string _tokenName,
604         uint8 _decimalUnits,
605         string _tokenSymbol,
606         bool _transfersEnabled
607     ) returns (MiniMeToken) {
608         MiniMeToken newToken = new MiniMeToken(
609             this,
610             _parentToken,
611             _snapshotBlock,
612             _tokenName,
613             _decimalUnits,
614             _tokenSymbol,
615             _transfersEnabled
616             );
617 
618         newToken.changeController(msg.sender);
619         return newToken;
620     }
621 }
622 
623 library SafeMath {
624   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
625     uint256 c = a * b;
626     assert(a == 0 || c / a == b);
627     return c;
628   }
629 
630   function div(uint256 a, uint256 b) internal constant returns (uint256) {
631     // assert(b > 0); // Solidity automatically throws when dividing by 0
632     uint256 c = a / b;
633     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
634     return c;
635   }
636 
637   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
638     assert(b <= a);
639     return a - b;
640   }
641 
642   function add(uint256 a, uint256 b) internal constant returns (uint256) {
643     uint256 c = a + b;
644     assert(c >= a);
645     return c;
646   }
647 }
648 
649 contract ProfitSharing is Ownable {
650   using SafeMath for uint;
651 
652   event DividendDeposited(address indexed _depositor, uint256 _blockNumber, uint256 _amount, uint256 _totalSupply, uint256 _dividendIndex);
653   event DividendClaimed(address indexed _claimer, uint256 _dividendIndex, uint256 _claim);
654   event DividendRecycled(address indexed _recycler, uint256 _blockNumber, uint256 _amount, uint256 _totalSupply, uint256 _dividendIndex);
655 
656   MiniMeToken public miniMeToken;
657 
658   uint256 public RECYCLE_TIME = 1 years;
659 
660   struct Dividend {
661     uint256 blockNumber;
662     uint256 timestamp;
663     uint256 amount;
664     uint256 claimedAmount;
665     uint256 totalSupply;
666     bool recycled;
667     mapping (address => bool) claimed;
668   }
669 
670   Dividend[] public dividends;
671 
672   mapping (address => uint256) dividendsClaimed;
673 
674   modifier validDividendIndex(uint256 _dividendIndex) {
675     require(_dividendIndex < dividends.length);
676     _;
677   }
678 
679   function ProfitSharing(address _miniMeToken) {
680     miniMeToken = MiniMeToken(_miniMeToken);
681   }
682 
683   function depositDividend() payable
684   onlyOwner
685   {
686     uint256 currentSupply = miniMeToken.totalSupplyAt(block.number);
687     uint256 dividendIndex = dividends.length;
688     uint256 blockNumber = SafeMath.sub(block.number, 1);
689     dividends.push(
690       Dividend(
691         blockNumber,
692         getNow(),
693         msg.value,
694         0,
695         currentSupply,
696         false
697       )
698     );
699     DividendDeposited(msg.sender, blockNumber, msg.value, currentSupply, dividendIndex);
700   }
701 
702   function claimDividend(uint256 _dividendIndex) public
703   validDividendIndex(_dividendIndex)
704   {
705     Dividend dividend = dividends[_dividendIndex];
706     require(dividend.claimed[msg.sender] == false);
707     require(dividend.recycled == false);
708     uint256 balance = miniMeToken.balanceOfAt(msg.sender, dividend.blockNumber);
709     uint256 claim = balance.mul(dividend.amount).div(dividend.totalSupply);
710     dividend.claimed[msg.sender] = true;
711     dividend.claimedAmount = SafeMath.add(dividend.claimedAmount, claim);
712     if (claim > 0) {
713       msg.sender.transfer(claim);
714       DividendClaimed(msg.sender, _dividendIndex, claim);
715     }
716   }
717 
718   function claimDividendAll() public {
719     require(dividendsClaimed[msg.sender] < dividends.length);
720     for (uint i = dividendsClaimed[msg.sender]; i < dividends.length; i++) {
721       if ((dividends[i].claimed[msg.sender] == false) && (dividends[i].recycled == false)) {
722         dividendsClaimed[msg.sender] = SafeMath.add(i, 1);
723         claimDividend(i);
724       }
725     }
726   }
727 
728   function recycleDividend(uint256 _dividendIndex) public
729   onlyOwner
730   validDividendIndex(_dividendIndex)
731   {
732     Dividend dividend = dividends[_dividendIndex];
733     require(dividend.recycled == false);
734     require(dividend.timestamp < SafeMath.sub(getNow(), RECYCLE_TIME));
735     dividends[_dividendIndex].recycled = true;
736     uint256 currentSupply = miniMeToken.totalSupplyAt(block.number);
737     uint256 remainingAmount = SafeMath.sub(dividend.amount, dividend.claimedAmount);
738     uint256 dividendIndex = dividends.length;
739     uint256 blockNumber = SafeMath.sub(block.number, 1);
740     dividends.push(
741       Dividend(
742         blockNumber,
743         getNow(),
744         remainingAmount,
745         0,
746         currentSupply,
747         false
748       )
749     );
750     DividendRecycled(msg.sender, blockNumber, remainingAmount, currentSupply, dividendIndex);
751   }
752 
753   //Function is mocked for tests
754   function getNow() internal constant returns (uint256) {
755     return now;
756   }
757 
758 }