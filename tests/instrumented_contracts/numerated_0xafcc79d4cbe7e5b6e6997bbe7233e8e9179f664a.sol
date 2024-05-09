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
37 library SafeMath {
38   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
39     uint256 c = a * b;
40     assert(a == 0 || c / a == b);
41     return c;
42   }
43 
44   function div(uint256 a, uint256 b) internal constant returns (uint256) {
45     // assert(b > 0); // Solidity automatically throws when dividing by 0
46     uint256 c = a / b;
47     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48     return c;
49   }
50 
51   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
52     assert(b <= a);
53     return a - b;
54   }
55 
56   function add(uint256 a, uint256 b) internal constant returns (uint256) {
57     uint256 c = a + b;
58     assert(c >= a);
59     return c;
60   }
61 }
62 
63 /*
64     Copyright 2016, Jordi Baylina
65 
66     This program is free software: you can redistribute it and/or modify
67     it under the terms of the GNU General Public License as published by
68     the Free Software Foundation, either version 3 of the License, or
69     (at your option) any later version.
70 
71     This program is distributed in the hope that it will be useful,
72     but WITHOUT ANY WARRANTY; without even the implied warranty of
73     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
74     GNU General Public License for more details.
75 
76     You should have received a copy of the GNU General Public License
77     along with this program.  If not, see <http://www.gnu.org/licenses/>.
78  */
79 
80 /// @title MiniMeToken Contract
81 /// @author Jordi Baylina
82 /// @dev This token contract's goal is to make it easy for anyone to clone this
83 ///  token using the token distribution at a given block, this will allow DAO's
84 ///  and DApps to upgrade their features in a decentralized manner without
85 ///  affecting the original token
86 /// @dev It is ERC20 compliant, but still needs to under go further testing.
87 
88 
89 /// @dev The token controller contract must implement these functions
90 contract TokenController {
91     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
92     /// @param _owner The address that sent the ether to create tokens
93     /// @return True if the ether is accepted, false if it throws
94     function proxyPayment(address _owner) payable returns(bool);
95 
96     /// @notice Notifies the controller about a token transfer allowing the
97     ///  controller to react if desired
98     /// @param _from The origin of the transfer
99     /// @param _to The destination of the transfer
100     /// @param _amount The amount of the transfer
101     /// @return False if the controller does not authorize the transfer
102     function onTransfer(address _from, address _to, uint _amount) returns(bool);
103 
104     /// @notice Notifies the controller about an approval allowing the
105     ///  controller to react if desired
106     /// @param _owner The address that calls `approve()`
107     /// @param _spender The spender in the `approve()` call
108     /// @param _amount The amount in the `approve()` call
109     /// @return False if the controller does not authorize the approval
110     function onApprove(address _owner, address _spender, uint _amount)
111         returns(bool);
112 }
113 
114 contract Controlled {
115     /// @notice The address of the controller is the only address that can call
116     ///  a function with this modifier
117     modifier onlyController { if (msg.sender != controller) throw; _; }
118 
119     address public controller;
120 
121     function Controlled() { controller = msg.sender;}
122 
123     /// @notice Changes the controller of the contract
124     /// @param _newController The new controller of the contract
125     function changeController(address _newController) onlyController {
126         controller = _newController;
127     }
128 }
129 
130 contract ApproveAndCallFallBack {
131     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
132 }
133 
134 /// @dev The actual token contract, the default controller is the msg.sender
135 ///  that deploys the contract, so usually this token will be deployed by a
136 ///  token controller contract, which Giveth will call a "Campaign"
137 contract MiniMeToken is Controlled {
138 
139     string public name;                //The Token's name: e.g. DigixDAO Tokens
140     uint8 public decimals;             //Number of decimals of the smallest unit
141     string public symbol;              //An identifier: e.g. REP
142     string public version = 'MMT_0.1'; //An arbitrary versioning scheme
143 
144     /// @dev `Checkpoint` is the structure that attaches a block number to a
145     ///  given value, the block number attached is the one that last changed the
146     ///  value
147     struct  Checkpoint {
148 
149         // `fromBlock` is the block number that the value was generated from
150         uint128 fromBlock;
151 
152         // `value` is the amount of tokens at a specific block number
153         uint128 value;
154     }
155 
156     // `parentToken` is the Token address that was cloned to produce this token;
157     //  it will be 0x0 for a token that was not cloned
158     MiniMeToken public parentToken;
159 
160     // `parentSnapShotBlock` is the block number from the Parent Token that was
161     //  used to determine the initial distribution of the Clone Token
162     uint public parentSnapShotBlock;
163 
164     // `creationBlock` is the block number that the Clone Token was created
165     uint public creationBlock;
166 
167     // `balances` is the map that tracks the balance of each address, in this
168     //  contract when the balance changes the block number that the change
169     //  occurred is also included in the map
170     mapping (address => Checkpoint[]) balances;
171 
172     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
173     mapping (address => mapping (address => uint256)) allowed;
174 
175     // Tracks the history of the `totalSupply` of the token
176     Checkpoint[] totalSupplyHistory;
177 
178     // Flag that determines if the token is transferable or not.
179     bool public transfersEnabled;
180 
181     // The factory used to create new clone tokens
182     MiniMeTokenFactory public tokenFactory;
183 
184 ////////////////
185 // Constructor
186 ////////////////
187 
188     /// @notice Constructor to create a MiniMeToken
189     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
190     ///  will create the Clone token contracts, the token factory needs to be
191     ///  deployed first
192     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
193     ///  new token
194     /// @param _parentSnapShotBlock Block of the parent token that will
195     ///  determine the initial distribution of the clone token, set to 0 if it
196     ///  is a new token
197     /// @param _tokenName Name of the new token
198     /// @param _decimalUnits Number of decimals of the new token
199     /// @param _tokenSymbol Token Symbol for the new token
200     /// @param _transfersEnabled If true, tokens will be able to be transferred
201     function MiniMeToken(
202         address _tokenFactory,
203         address _parentToken,
204         uint _parentSnapShotBlock,
205         string _tokenName,
206         uint8 _decimalUnits,
207         string _tokenSymbol,
208         bool _transfersEnabled
209     ) {
210         tokenFactory = MiniMeTokenFactory(_tokenFactory);
211         name = _tokenName;                                 // Set the name
212         decimals = _decimalUnits;                          // Set the decimals
213         symbol = _tokenSymbol;                             // Set the symbol
214         parentToken = MiniMeToken(_parentToken);
215         parentSnapShotBlock = _parentSnapShotBlock;
216         transfersEnabled = _transfersEnabled;
217         creationBlock = block.number;
218     }
219 
220 
221 ///////////////////
222 // ERC20 Methods
223 ///////////////////
224 
225     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
226     /// @param _to The address of the recipient
227     /// @param _amount The amount of tokens to be transferred
228     /// @return Whether the transfer was successful or not
229     function transfer(address _to, uint256 _amount) returns (bool success) {
230         if (!transfersEnabled) throw;
231         return doTransfer(msg.sender, _to, _amount);
232     }
233 
234     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
235     ///  is approved by `_from`
236     /// @param _from The address holding the tokens being transferred
237     /// @param _to The address of the recipient
238     /// @param _amount The amount of tokens to be transferred
239     /// @return True if the transfer was successful
240     function transferFrom(address _from, address _to, uint256 _amount
241     ) returns (bool success) {
242 
243         // The controller of this contract can move tokens around at will,
244         //  this is important to recognize! Confirm that you trust the
245         //  controller of this contract, which in most situations should be
246         //  another open source smart contract or 0x0
247         if (msg.sender != controller) {
248             if (!transfersEnabled) throw;
249 
250             // The standard ERC 20 transferFrom functionality
251             if (allowed[_from][msg.sender] < _amount) return false;
252             allowed[_from][msg.sender] -= _amount;
253         }
254         return doTransfer(_from, _to, _amount);
255     }
256 
257     /// @dev This is the actual transfer function in the token contract, it can
258     ///  only be called by other functions in this contract.
259     /// @param _from The address holding the tokens being transferred
260     /// @param _to The address of the recipient
261     /// @param _amount The amount of tokens to be transferred
262     /// @return True if the transfer was successful
263     function doTransfer(address _from, address _to, uint _amount
264     ) internal returns(bool) {
265 
266            if (_amount == 0) {
267                return true;
268            }
269 
270            if (parentSnapShotBlock >= block.number) throw;
271 
272            // Do not allow transfer to 0x0 or the token contract itself
273            if ((_to == 0) || (_to == address(this))) throw;
274 
275            // If the amount being transfered is more than the balance of the
276            //  account the transfer returns false
277            var previousBalanceFrom = balanceOfAt(_from, block.number);
278            if (previousBalanceFrom < _amount) {
279                return false;
280            }
281 
282            // Alerts the token controller of the transfer
283            if (isContract(controller)) {
284                if (!TokenController(controller).onTransfer(_from, _to, _amount))
285                throw;
286            }
287 
288            // First update the balance array with the new value for the address
289            //  sending the tokens
290            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
291 
292            // Then update the balance array with the new value for the address
293            //  receiving the tokens
294            var previousBalanceTo = balanceOfAt(_to, block.number);
295            if (previousBalanceTo + _amount < previousBalanceTo) throw; // Check for overflow
296            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
297 
298            // An event to make the transfer easy to find on the blockchain
299            Transfer(_from, _to, _amount);
300 
301            return true;
302     }
303 
304     /// @param _owner The address that's balance is being requested
305     /// @return The balance of `_owner` at the current block
306     function balanceOf(address _owner) constant returns (uint256 balance) {
307         return balanceOfAt(_owner, block.number);
308     }
309 
310     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
311     ///  its behalf. This is a modified version of the ERC20 approve function
312     ///  to be a little bit safer
313     /// @param _spender The address of the account able to transfer the tokens
314     /// @param _amount The amount of tokens to be approved for transfer
315     /// @return True if the approval was successful
316     function approve(address _spender, uint256 _amount) returns (bool success) {
317         if (!transfersEnabled) throw;
318 
319         // To change the approve amount you first have to reduce the addresses`
320         //  allowance to zero by calling `approve(_spender,0)` if it is not
321         //  already 0 to mitigate the race condition described here:
322         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
323         if ((_amount!=0) && (allowed[msg.sender][_spender] !=0)) throw;
324 
325         // Alerts the token controller of the approve function call
326         if (isContract(controller)) {
327             if (!TokenController(controller).onApprove(msg.sender, _spender, _amount))
328                 throw;
329         }
330 
331         allowed[msg.sender][_spender] = _amount;
332         Approval(msg.sender, _spender, _amount);
333         return true;
334     }
335 
336     /// @dev This function makes it easy to read the `allowed[]` map
337     /// @param _owner The address of the account that owns the token
338     /// @param _spender The address of the account able to transfer the tokens
339     /// @return Amount of remaining tokens of _owner that _spender is allowed
340     ///  to spend
341     function allowance(address _owner, address _spender
342     ) constant returns (uint256 remaining) {
343         return allowed[_owner][_spender];
344     }
345 
346     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
347     ///  its behalf, and then a function is triggered in the contract that is
348     ///  being approved, `_spender`. This allows users to use their tokens to
349     ///  interact with contracts in one function call instead of two
350     /// @param _spender The address of the contract able to transfer the tokens
351     /// @param _amount The amount of tokens to be approved for transfer
352     /// @return True if the function call was successful
353     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
354     ) returns (bool success) {
355         if (!approve(_spender, _amount)) throw;
356 
357         ApproveAndCallFallBack(_spender).receiveApproval(
358             msg.sender,
359             _amount,
360             this,
361             _extraData
362         );
363 
364         return true;
365     }
366 
367     /// @dev This function makes it easy to get the total number of tokens
368     /// @return The total number of tokens
369     function totalSupply() constant returns (uint) {
370         return totalSupplyAt(block.number);
371     }
372 
373 
374 ////////////////
375 // Query balance and totalSupply in History
376 ////////////////
377 
378     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
379     /// @param _owner The address from which the balance will be retrieved
380     /// @param _blockNumber The block number when the balance is queried
381     /// @return The balance at `_blockNumber`
382     function balanceOfAt(address _owner, uint _blockNumber) constant
383         returns (uint) {
384 
385         // These next few lines are used when the balance of the token is
386         //  requested before a check point was ever created for this token, it
387         //  requires that the `parentToken.balanceOfAt` be queried at the
388         //  genesis block for that token as this contains initial balance of
389         //  this token
390         if ((balances[_owner].length == 0)
391             || (balances[_owner][0].fromBlock > _blockNumber)) {
392             if (address(parentToken) != 0) {
393                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
394             } else {
395                 // Has no parent
396                 return 0;
397             }
398 
399         // This will return the expected balance during normal situations
400         } else {
401             return getValueAt(balances[_owner], _blockNumber);
402         }
403     }
404 
405     /// @notice Total amount of tokens at a specific `_blockNumber`.
406     /// @param _blockNumber The block number when the totalSupply is queried
407     /// @return The total amount of tokens at `_blockNumber`
408     function totalSupplyAt(uint _blockNumber) constant returns(uint) {
409 
410         // These next few lines are used when the totalSupply of the token is
411         //  requested before a check point was ever created for this token, it
412         //  requires that the `parentToken.totalSupplyAt` be queried at the
413         //  genesis block for this token as that contains totalSupply of this
414         //  token at this block number.
415         if ((totalSupplyHistory.length == 0)
416             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
417             if (address(parentToken) != 0) {
418                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
419             } else {
420                 return 0;
421             }
422 
423         // This will return the expected totalSupply during normal situations
424         } else {
425             return getValueAt(totalSupplyHistory, _blockNumber);
426         }
427     }
428 
429 ////////////////
430 // Clone Token Method
431 ////////////////
432 
433     /// @notice Creates a new clone token with the initial distribution being
434     ///  this token at `_snapshotBlock`
435     /// @param _cloneTokenName Name of the clone token
436     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
437     /// @param _cloneTokenSymbol Symbol of the clone token
438     /// @param _snapshotBlock Block when the distribution of the parent token is
439     ///  copied to set the initial distribution of the new clone token;
440     ///  if the block is zero than the actual block, the current block is used
441     /// @param _transfersEnabled True if transfers are allowed in the clone
442     /// @return The address of the new MiniMeToken Contract
443     function createCloneToken(
444         string _cloneTokenName,
445         uint8 _cloneDecimalUnits,
446         string _cloneTokenSymbol,
447         uint _snapshotBlock,
448         bool _transfersEnabled
449         ) returns(address) {
450         if (_snapshotBlock == 0) _snapshotBlock = block.number;
451         MiniMeToken cloneToken = tokenFactory.createCloneToken(
452             this,
453             _snapshotBlock,
454             _cloneTokenName,
455             _cloneDecimalUnits,
456             _cloneTokenSymbol,
457             _transfersEnabled
458             );
459 
460         cloneToken.changeController(msg.sender);
461 
462         // An event to make the token easy to find on the blockchain
463         NewCloneToken(address(cloneToken), _snapshotBlock);
464         return address(cloneToken);
465     }
466 
467 ////////////////
468 // Generate and destroy tokens
469 ////////////////
470 
471     /// @notice Generates `_amount` tokens that are assigned to `_owner`
472     /// @param _owner The address that will be assigned the new tokens
473     /// @param _amount The quantity of tokens generated
474     /// @return True if the tokens are generated correctly
475     function generateTokens(address _owner, uint _amount
476     ) onlyController returns (bool) {
477         uint curTotalSupply = getValueAt(totalSupplyHistory, block.number);
478         if (curTotalSupply + _amount < curTotalSupply) throw; // Check for overflow
479         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
480         var previousBalanceTo = balanceOf(_owner);
481         if (previousBalanceTo + _amount < previousBalanceTo) throw; // Check for overflow
482         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
483         Transfer(0, _owner, _amount);
484         return true;
485     }
486 
487 
488     /// @notice Burns `_amount` tokens from `_owner`
489     /// @param _owner The address that will lose the tokens
490     /// @param _amount The quantity of tokens to burn
491     /// @return True if the tokens are burned correctly
492     function destroyTokens(address _owner, uint _amount
493     ) onlyController returns (bool) {
494         uint curTotalSupply = getValueAt(totalSupplyHistory, block.number);
495         if (curTotalSupply < _amount) throw;
496         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
497         var previousBalanceFrom = balanceOf(_owner);
498         if (previousBalanceFrom < _amount) throw;
499         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
500         Transfer(_owner, 0, _amount);
501         return true;
502     }
503 
504 ////////////////
505 // Enable tokens transfers
506 ////////////////
507 
508 
509     /// @notice Enables token holders to transfer their tokens freely if true
510     /// @param _transfersEnabled True if transfers are allowed in the clone
511     function enableTransfers(bool _transfersEnabled) onlyController {
512         transfersEnabled = _transfersEnabled;
513     }
514 
515 ////////////////
516 // Internal helper functions to query and set a value in a snapshot array
517 ////////////////
518 
519     /// @dev `getValueAt` retrieves the number of tokens at a given block number
520     /// @param checkpoints The history of values being queried
521     /// @param _block The block number to retrieve the value at
522     /// @return The number of tokens being queried
523     function getValueAt(Checkpoint[] storage checkpoints, uint _block
524     ) constant internal returns (uint) {
525         if (checkpoints.length == 0) return 0;
526 
527         // Shortcut for the actual value
528         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
529             return checkpoints[checkpoints.length-1].value;
530         if (_block < checkpoints[0].fromBlock) return 0;
531 
532         // Binary search of the value in the array
533         uint min = 0;
534         uint max = checkpoints.length-1;
535         while (max > min) {
536             uint mid = (max + min + 1)/ 2;
537             if (checkpoints[mid].fromBlock<=_block) {
538                 min = mid;
539             } else {
540                 max = mid-1;
541             }
542         }
543         return checkpoints[min].value;
544     }
545 
546     /// @dev `updateValueAtNow` used to update the `balances` map and the
547     ///  `totalSupplyHistory`
548     /// @param checkpoints The history of data being updated
549     /// @param _value The new number of tokens
550     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
551     ) internal  {
552         if ((checkpoints.length == 0)
553         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
554                Checkpoint newCheckPoint = checkpoints[ checkpoints.length++ ];
555                newCheckPoint.fromBlock =  uint128(block.number);
556                newCheckPoint.value = uint128(_value);
557            } else {
558                Checkpoint oldCheckPoint = checkpoints[checkpoints.length-1];
559                oldCheckPoint.value = uint128(_value);
560            }
561     }
562 
563     /// @dev Internal function to determine if an address is a contract
564     /// @param _addr The address being queried
565     /// @return True if `_addr` is a contract
566     function isContract(address _addr) constant internal returns(bool) {
567         uint size;
568         if (_addr == 0) return false;
569         assembly {
570             size := extcodesize(_addr)
571         }
572         return size>0;
573     }
574 
575     /// @dev Helper function to return a min betwen the two uints
576     function min(uint a, uint b) internal returns (uint) {
577         return a < b ? a : b;
578     }
579 
580     /// @notice The fallback function: If the contract's controller has not been
581     ///  set to 0, then the `proxyPayment` method is called which relays the
582     ///  ether and creates tokens as described in the token controller contract
583     function ()  payable {
584         if (isContract(controller)) {
585             if (! TokenController(controller).proxyPayment.value(msg.value)(msg.sender))
586                 throw;
587         } else {
588             throw;
589         }
590     }
591 
592 
593 ////////////////
594 // Events
595 ////////////////
596     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
597     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
598     event Approval(
599         address indexed _owner,
600         address indexed _spender,
601         uint256 _amount
602         );
603 
604 }
605 
606 
607 ////////////////
608 // MiniMeTokenFactory
609 ////////////////
610 
611 /// @dev This contract is used to generate clone contracts from a contract.
612 ///  In solidity this is the way to create a contract from a contract of the
613 ///  same class
614 contract MiniMeTokenFactory {
615 
616     /// @notice Update the DApp by creating a new token with new functionalities
617     ///  the msg.sender becomes the controller of this clone token
618     /// @param _parentToken Address of the token being cloned
619     /// @param _snapshotBlock Block of the parent token that will
620     ///  determine the initial distribution of the clone token
621     /// @param _tokenName Name of the new token
622     /// @param _decimalUnits Number of decimals of the new token
623     /// @param _tokenSymbol Token Symbol for the new token
624     /// @param _transfersEnabled If true, tokens will be able to be transferred
625     /// @return The address of the new token contract
626     function createCloneToken(
627         address _parentToken,
628         uint _snapshotBlock,
629         string _tokenName,
630         uint8 _decimalUnits,
631         string _tokenSymbol,
632         bool _transfersEnabled
633     ) returns (MiniMeToken) {
634         MiniMeToken newToken = new MiniMeToken(
635             this,
636             _parentToken,
637             _snapshotBlock,
638             _tokenName,
639             _decimalUnits,
640             _tokenSymbol,
641             _transfersEnabled
642             );
643 
644         newToken.changeController(msg.sender);
645         return newToken;
646     }
647 }
648 
649 
650 contract ProfitSharing is Ownable {
651   using SafeMath for uint;
652 
653   event DividendDeposited(address indexed _depositor, uint256 _blockNumber, uint256 _amount, uint256 _totalSupply, uint256 _dividendIndex);
654   event DividendClaimed(address indexed _claimer, uint256 _dividendIndex, uint256 _claim);
655   event DividendRecycled(address indexed _recycler, uint256 _blockNumber, uint256 _amount, uint256 _totalSupply, uint256 _dividendIndex);
656 
657   MiniMeToken public token;
658 
659   uint256 public RECYCLE_TIME = 1 years;
660 
661   struct Dividend {
662     uint256 blockNumber;
663     uint256 timestamp;
664     uint256 amount;
665     uint256 claimedAmount;
666     uint256 totalSupply;
667     bool recycled;
668     mapping (address => bool) claimed;
669   }
670 
671   Dividend[] public dividends;
672 
673   mapping (address => uint256) dividendsClaimed;
674 
675   modifier validDividendIndex(uint256 _dividendIndex) {
676     require(_dividendIndex < dividends.length);
677     _;
678   }
679 
680   function ProfitSharing(address _token) {
681     token = MiniMeToken(_token);
682   }
683 
684   function depositDividend() payable
685   onlyOwner
686   {
687     uint256 currentSupply = token.totalSupplyAt(block.number);
688     uint256 dividendIndex = dividends.length;
689     uint256 blockNumber = SafeMath.sub(block.number, 1);
690     dividends.push(
691       Dividend(
692         blockNumber,
693         getNow(),
694         msg.value,
695         0,
696         currentSupply,
697         false
698       )
699     );
700     DividendDeposited(msg.sender, blockNumber, msg.value, currentSupply, dividendIndex);
701   }
702 
703   function claimDividend(uint256 _dividendIndex) public
704   validDividendIndex(_dividendIndex)
705   {
706     Dividend dividend = dividends[_dividendIndex];
707     require(dividend.claimed[msg.sender] == false);
708     require(dividend.recycled == false);
709     uint256 balance = token.balanceOfAt(msg.sender, dividend.blockNumber);
710     uint256 claim = balance.mul(dividend.amount).div(dividend.totalSupply);
711     dividend.claimed[msg.sender] = true;
712     dividend.claimedAmount = SafeMath.add(dividend.claimedAmount, claim);
713     if (claim > 0) {
714       msg.sender.transfer(claim);
715       DividendClaimed(msg.sender, _dividendIndex, claim);
716     }
717   }
718 
719   function claimDividendAll() public {
720     require(dividendsClaimed[msg.sender] < dividends.length);
721     for (uint i = dividendsClaimed[msg.sender]; i < dividends.length; i++) {
722       if ((dividends[i].claimed[msg.sender] == false) && (dividends[i].recycled == false)) {
723         dividendsClaimed[msg.sender] = SafeMath.add(i, 1);
724         claimDividend(i);
725       }
726     }
727   }
728 
729   function recycleDividend(uint256 _dividendIndex) public
730   onlyOwner
731   validDividendIndex(_dividendIndex)
732   {
733     Dividend dividend = dividends[_dividendIndex];
734     require(dividend.recycled == false);
735     require(dividend.timestamp < SafeMath.sub(getNow(), RECYCLE_TIME));
736     dividends[_dividendIndex].recycled = true;
737     uint256 currentSupply = token.totalSupplyAt(block.number);
738     uint256 remainingAmount = SafeMath.sub(dividend.amount, dividend.claimedAmount);
739     uint256 dividendIndex = dividends.length;
740     uint256 blockNumber = SafeMath.sub(block.number, 1);
741     dividends.push(
742       Dividend(
743         blockNumber,
744         getNow(),
745         remainingAmount,
746         0,
747         currentSupply,
748         false
749       )
750     );
751     DividendRecycled(msg.sender, blockNumber, remainingAmount, currentSupply, dividendIndex);
752   }
753 
754   //Function is mocked for tests
755   function getNow() internal constant returns (uint256) {
756     return now;
757   }
758 
759 }