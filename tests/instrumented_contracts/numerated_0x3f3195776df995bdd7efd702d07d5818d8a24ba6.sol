1 pragma solidity ^0.4.11;
2 
3 
4 /*
5     Copyright 2016, Jordi Baylina
6 
7     This program is free software: you can redistribute it and/or modify
8     it under the terms of the GNU General Public License as published by
9     the Free Software Foundation, either version 3 of the License, or
10     (at your option) any later version.
11 
12     This program is distributed in the hope that it will be useful,
13     but WITHOUT ANY WARRANTY; without even the implied warranty of
14     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
15     GNU General Public License for more details.
16 
17     You should have received a copy of the GNU General Public License
18     along with this program.  If not, see <http://www.gnu.org/licenses/>.
19  */
20 
21 /// @title MiniMeToken Contract
22 /// @author Jordi Baylina
23 /// @dev This token contract's goal is to make it easy for anyone to clone this
24 ///  token using the token distribution at a given block, this will allow DAO's
25 ///  and DApps to upgrade their features in a decentralized manner without
26 ///  affecting the original token
27 /// @dev It is ERC20 compliant, but still needs to under go further testing.
28 
29 
30 /// @dev The token controller contract must implement these functions
31 contract TokenController {
32     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
33     /// @param _owner The address that sent the ether to create tokens
34     /// @return True if the ether is accepted, false if it throws
35     function proxyPayment(address _owner) payable returns(bool);
36 
37     /// @notice Notifies the controller about a token transfer allowing the
38     ///  controller to react if desired
39     /// @param _from The origin of the transfer
40     /// @param _to The destination of the transfer
41     /// @param _amount The amount of the transfer
42     /// @return False if the controller does not authorize the transfer
43     function onTransfer(address _from, address _to, uint _amount) returns(bool);
44 
45     /// @notice Notifies the controller about an approval allowing the
46     ///  controller to react if desired
47     /// @param _owner The address that calls `approve()`
48     /// @param _spender The spender in the `approve()` call
49     /// @param _amount The amount in the `approve()` call
50     /// @return False if the controller does not authorize the approval
51     function onApprove(address _owner, address _spender, uint _amount)
52         returns(bool);
53 }
54 
55 contract Controlled {
56     /// @notice The address of the controller is the only address that can call
57     ///  a function with this modifier
58     modifier onlyController { if (msg.sender != controller) throw; _; }
59 
60     address public controller;
61 
62     function Controlled() { controller = msg.sender;}
63 
64     /// @notice Changes the controller of the contract
65     /// @param _newController The new controller of the contract
66     function changeController(address _newController) onlyController {
67         controller = _newController;
68     }
69 }
70 
71 contract ApproveAndCallFallBack {
72     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
73 }
74 
75 /// @dev The actual token contract, the default controller is the msg.sender
76 ///  that deploys the contract, so usually this token will be deployed by a
77 ///  token controller contract, which Giveth will call a "Campaign"
78 contract MiniMeToken is Controlled {
79 
80     string public name;                //The Token's name: e.g. DigixDAO Tokens
81     uint8 public decimals;             //Number of decimals of the smallest unit
82     string public symbol;              //An identifier: e.g. REP
83     string public version = 'MMT_0.1'; //An arbitrary versioning scheme
84 
85     /// @dev `Checkpoint` is the structure that attaches a block number to a
86     ///  given value, the block number attached is the one that last changed the
87     ///  value
88     struct  Checkpoint {
89 
90         // `fromBlock` is the block number that the value was generated from
91         uint128 fromBlock;
92 
93         // `value` is the amount of tokens at a specific block number
94         uint128 value;
95     }
96 
97     // `parentToken` is the Token address that was cloned to produce this token;
98     //  it will be 0x0 for a token that was not cloned
99     MiniMeToken public parentToken;
100 
101     // `parentSnapShotBlock` is the block number from the Parent Token that was
102     //  used to determine the initial distribution of the Clone Token
103     uint public parentSnapShotBlock;
104 
105     // `creationBlock` is the block number that the Clone Token was created
106     uint public creationBlock;
107 
108     // `balances` is the map that tracks the balance of each address, in this
109     //  contract when the balance changes the block number that the change
110     //  occurred is also included in the map
111     mapping (address => Checkpoint[]) balances;
112 
113     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
114     mapping (address => mapping (address => uint256)) allowed;
115 
116     // Tracks the history of the `totalSupply` of the token
117     Checkpoint[] totalSupplyHistory;
118 
119     // Flag that determines if the token is transferable or not.
120     bool public transfersEnabled;
121 
122     // The factory used to create new clone tokens
123     MiniMeTokenFactory public tokenFactory;
124 
125 ////////////////
126 // Constructor
127 ////////////////
128 
129     /// @notice Constructor to create a MiniMeToken
130     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
131     ///  will create the Clone token contracts, the token factory needs to be
132     ///  deployed first
133     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
134     ///  new token
135     /// @param _parentSnapShotBlock Block of the parent token that will
136     ///  determine the initial distribution of the clone token, set to 0 if it
137     ///  is a new token
138     /// @param _tokenName Name of the new token
139     /// @param _decimalUnits Number of decimals of the new token
140     /// @param _tokenSymbol Token Symbol for the new token
141     /// @param _transfersEnabled If true, tokens will be able to be transferred
142     function MiniMeToken(
143         address _tokenFactory,
144         address _parentToken,
145         uint _parentSnapShotBlock,
146         string _tokenName,
147         uint8 _decimalUnits,
148         string _tokenSymbol,
149         bool _transfersEnabled
150     ) {
151         tokenFactory = MiniMeTokenFactory(_tokenFactory);
152         name = _tokenName;                                 // Set the name
153         decimals = _decimalUnits;                          // Set the decimals
154         symbol = _tokenSymbol;                             // Set the symbol
155         parentToken = MiniMeToken(_parentToken);
156         parentSnapShotBlock = _parentSnapShotBlock;
157         transfersEnabled = _transfersEnabled;
158         creationBlock = block.number;
159     }
160 
161 
162 ///////////////////
163 // ERC20 Methods
164 ///////////////////
165 
166     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
167     /// @param _to The address of the recipient
168     /// @param _amount The amount of tokens to be transferred
169     /// @return Whether the transfer was successful or not
170     function transfer(address _to, uint256 _amount) returns (bool success) {
171         if (!transfersEnabled) throw;
172         return doTransfer(msg.sender, _to, _amount);
173     }
174 
175     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
176     ///  is approved by `_from`
177     /// @param _from The address holding the tokens being transferred
178     /// @param _to The address of the recipient
179     /// @param _amount The amount of tokens to be transferred
180     /// @return True if the transfer was successful
181     function transferFrom(address _from, address _to, uint256 _amount
182     ) returns (bool success) {
183 
184         // The controller of this contract can move tokens around at will,
185         //  this is important to recognize! Confirm that you trust the
186         //  controller of this contract, which in most situations should be
187         //  another open source smart contract or 0x0
188         if (msg.sender != controller) {
189             if (!transfersEnabled) throw;
190 
191             // The standard ERC 20 transferFrom functionality
192             if (allowed[_from][msg.sender] < _amount) return false;
193             allowed[_from][msg.sender] -= _amount;
194         }
195         return doTransfer(_from, _to, _amount);
196     }
197 
198     /// @dev This is the actual transfer function in the token contract, it can
199     ///  only be called by other functions in this contract.
200     /// @param _from The address holding the tokens being transferred
201     /// @param _to The address of the recipient
202     /// @param _amount The amount of tokens to be transferred
203     /// @return True if the transfer was successful
204     function doTransfer(address _from, address _to, uint _amount
205     ) internal returns(bool) {
206 
207            if (_amount == 0) {
208                return true;
209            }
210 
211            if (parentSnapShotBlock >= block.number) throw;
212 
213            // Do not allow transfer to 0x0 or the token contract itself
214            if ((_to == 0) || (_to == address(this))) throw;
215 
216            // If the amount being transfered is more than the balance of the
217            //  account the transfer returns false
218            var previousBalanceFrom = balanceOfAt(_from, block.number);
219            if (previousBalanceFrom < _amount) {
220                return false;
221            }
222 
223            // Alerts the token controller of the transfer
224            if (isContract(controller)) {
225                if (!TokenController(controller).onTransfer(_from, _to, _amount))
226                throw;
227            }
228 
229            // First update the balance array with the new value for the address
230            //  sending the tokens
231            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
232 
233            // Then update the balance array with the new value for the address
234            //  receiving the tokens
235            var previousBalanceTo = balanceOfAt(_to, block.number);
236            if (previousBalanceTo + _amount < previousBalanceTo) throw; // Check for overflow
237            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
238 
239            // An event to make the transfer easy to find on the blockchain
240            Transfer(_from, _to, _amount);
241 
242            return true;
243     }
244 
245     /// @param _owner The address that's balance is being requested
246     /// @return The balance of `_owner` at the current block
247     function balanceOf(address _owner) constant returns (uint256 balance) {
248         return balanceOfAt(_owner, block.number);
249     }
250 
251     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
252     ///  its behalf. This is a modified version of the ERC20 approve function
253     ///  to be a little bit safer
254     /// @param _spender The address of the account able to transfer the tokens
255     /// @param _amount The amount of tokens to be approved for transfer
256     /// @return True if the approval was successful
257     function approve(address _spender, uint256 _amount) returns (bool success) {
258         if (!transfersEnabled) throw;
259 
260         // To change the approve amount you first have to reduce the addresses`
261         //  allowance to zero by calling `approve(_spender,0)` if it is not
262         //  already 0 to mitigate the race condition described here:
263         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
264         if ((_amount!=0) && (allowed[msg.sender][_spender] !=0)) throw;
265 
266         // Alerts the token controller of the approve function call
267         if (isContract(controller)) {
268             if (!TokenController(controller).onApprove(msg.sender, _spender, _amount))
269                 throw;
270         }
271 
272         allowed[msg.sender][_spender] = _amount;
273         Approval(msg.sender, _spender, _amount);
274         return true;
275     }
276 
277     /// @dev This function makes it easy to read the `allowed[]` map
278     /// @param _owner The address of the account that owns the token
279     /// @param _spender The address of the account able to transfer the tokens
280     /// @return Amount of remaining tokens of _owner that _spender is allowed
281     ///  to spend
282     function allowance(address _owner, address _spender
283     ) constant returns (uint256 remaining) {
284         return allowed[_owner][_spender];
285     }
286 
287     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
288     ///  its behalf, and then a function is triggered in the contract that is
289     ///  being approved, `_spender`. This allows users to use their tokens to
290     ///  interact with contracts in one function call instead of two
291     /// @param _spender The address of the contract able to transfer the tokens
292     /// @param _amount The amount of tokens to be approved for transfer
293     /// @return True if the function call was successful
294     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
295     ) returns (bool success) {
296         if (!approve(_spender, _amount)) throw;
297 
298         ApproveAndCallFallBack(_spender).receiveApproval(
299             msg.sender,
300             _amount,
301             this,
302             _extraData
303         );
304 
305         return true;
306     }
307 
308     /// @dev This function makes it easy to get the total number of tokens
309     /// @return The total number of tokens
310     function totalSupply() constant returns (uint) {
311         return totalSupplyAt(block.number);
312     }
313 
314 
315 ////////////////
316 // Query balance and totalSupply in History
317 ////////////////
318 
319     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
320     /// @param _owner The address from which the balance will be retrieved
321     /// @param _blockNumber The block number when the balance is queried
322     /// @return The balance at `_blockNumber`
323     function balanceOfAt(address _owner, uint _blockNumber) constant
324         returns (uint) {
325 
326         // These next few lines are used when the balance of the token is
327         //  requested before a check point was ever created for this token, it
328         //  requires that the `parentToken.balanceOfAt` be queried at the
329         //  genesis block for that token as this contains initial balance of
330         //  this token
331         if ((balances[_owner].length == 0)
332             || (balances[_owner][0].fromBlock > _blockNumber)) {
333             if (address(parentToken) != 0) {
334                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
335             } else {
336                 // Has no parent
337                 return 0;
338             }
339 
340         // This will return the expected balance during normal situations
341         } else {
342             return getValueAt(balances[_owner], _blockNumber);
343         }
344     }
345 
346     /// @notice Total amount of tokens at a specific `_blockNumber`.
347     /// @param _blockNumber The block number when the totalSupply is queried
348     /// @return The total amount of tokens at `_blockNumber`
349     function totalSupplyAt(uint _blockNumber) constant returns(uint) {
350 
351         // These next few lines are used when the totalSupply of the token is
352         //  requested before a check point was ever created for this token, it
353         //  requires that the `parentToken.totalSupplyAt` be queried at the
354         //  genesis block for this token as that contains totalSupply of this
355         //  token at this block number.
356         if ((totalSupplyHistory.length == 0)
357             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
358             if (address(parentToken) != 0) {
359                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
360             } else {
361                 return 0;
362             }
363 
364         // This will return the expected totalSupply during normal situations
365         } else {
366             return getValueAt(totalSupplyHistory, _blockNumber);
367         }
368     }
369 
370 ////////////////
371 // Clone Token Method
372 ////////////////
373 
374     /// @notice Creates a new clone token with the initial distribution being
375     ///  this token at `_snapshotBlock`
376     /// @param _cloneTokenName Name of the clone token
377     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
378     /// @param _cloneTokenSymbol Symbol of the clone token
379     /// @param _snapshotBlock Block when the distribution of the parent token is
380     ///  copied to set the initial distribution of the new clone token;
381     ///  if the block is zero than the actual block, the current block is used
382     /// @param _transfersEnabled True if transfers are allowed in the clone
383     /// @return The address of the new MiniMeToken Contract
384     function createCloneToken(
385         string _cloneTokenName,
386         uint8 _cloneDecimalUnits,
387         string _cloneTokenSymbol,
388         uint _snapshotBlock,
389         bool _transfersEnabled
390         ) returns(address) {
391         if (_snapshotBlock == 0) _snapshotBlock = block.number;
392         MiniMeToken cloneToken = tokenFactory.createCloneToken(
393             this,
394             _snapshotBlock,
395             _cloneTokenName,
396             _cloneDecimalUnits,
397             _cloneTokenSymbol,
398             _transfersEnabled
399             );
400 
401         cloneToken.changeController(msg.sender);
402 
403         // An event to make the token easy to find on the blockchain
404         NewCloneToken(address(cloneToken), _snapshotBlock);
405         return address(cloneToken);
406     }
407 
408 ////////////////
409 // Generate and destroy tokens
410 ////////////////
411 
412     /// @notice Generates `_amount` tokens that are assigned to `_owner`
413     /// @param _owner The address that will be assigned the new tokens
414     /// @param _amount The quantity of tokens generated
415     /// @return True if the tokens are generated correctly
416     function generateTokens(address _owner, uint _amount
417     ) onlyController returns (bool) {
418         uint curTotalSupply = getValueAt(totalSupplyHistory, block.number);
419         if (curTotalSupply + _amount < curTotalSupply) throw; // Check for overflow
420         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
421         var previousBalanceTo = balanceOf(_owner);
422         if (previousBalanceTo + _amount < previousBalanceTo) throw; // Check for overflow
423         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
424         Transfer(0, _owner, _amount);
425         return true;
426     }
427 
428 
429     /// @notice Burns `_amount` tokens from `_owner`
430     /// @param _owner The address that will lose the tokens
431     /// @param _amount The quantity of tokens to burn
432     /// @return True if the tokens are burned correctly
433     function destroyTokens(address _owner, uint _amount
434     ) onlyController returns (bool) {
435         uint curTotalSupply = getValueAt(totalSupplyHistory, block.number);
436         if (curTotalSupply < _amount) throw;
437         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
438         var previousBalanceFrom = balanceOf(_owner);
439         if (previousBalanceFrom < _amount) throw;
440         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
441         Transfer(_owner, 0, _amount);
442         return true;
443     }
444 
445 ////////////////
446 // Enable tokens transfers
447 ////////////////
448 
449 
450     /// @notice Enables token holders to transfer their tokens freely if true
451     /// @param _transfersEnabled True if transfers are allowed in the clone
452     function enableTransfers(bool _transfersEnabled) onlyController {
453         transfersEnabled = _transfersEnabled;
454     }
455 
456 ////////////////
457 // Internal helper functions to query and set a value in a snapshot array
458 ////////////////
459 
460     /// @dev `getValueAt` retrieves the number of tokens at a given block number
461     /// @param checkpoints The history of values being queried
462     /// @param _block The block number to retrieve the value at
463     /// @return The number of tokens being queried
464     function getValueAt(Checkpoint[] storage checkpoints, uint _block
465     ) constant internal returns (uint) {
466         if (checkpoints.length == 0) return 0;
467 
468         // Shortcut for the actual value
469         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
470             return checkpoints[checkpoints.length-1].value;
471         if (_block < checkpoints[0].fromBlock) return 0;
472 
473         // Binary search of the value in the array
474         uint min = 0;
475         uint max = checkpoints.length-1;
476         while (max > min) {
477             uint mid = (max + min + 1)/ 2;
478             if (checkpoints[mid].fromBlock<=_block) {
479                 min = mid;
480             } else {
481                 max = mid-1;
482             }
483         }
484         return checkpoints[min].value;
485     }
486 
487     /// @dev `updateValueAtNow` used to update the `balances` map and the
488     ///  `totalSupplyHistory`
489     /// @param checkpoints The history of data being updated
490     /// @param _value The new number of tokens
491     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
492     ) internal  {
493         if ((checkpoints.length == 0)
494         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
495                Checkpoint newCheckPoint = checkpoints[ checkpoints.length++ ];
496                newCheckPoint.fromBlock =  uint128(block.number);
497                newCheckPoint.value = uint128(_value);
498            } else {
499                Checkpoint oldCheckPoint = checkpoints[checkpoints.length-1];
500                oldCheckPoint.value = uint128(_value);
501            }
502     }
503 
504     /// @dev Internal function to determine if an address is a contract
505     /// @param _addr The address being queried
506     /// @return True if `_addr` is a contract
507     function isContract(address _addr) constant internal returns(bool) {
508         uint size;
509         if (_addr == 0) return false;
510         assembly {
511             size := extcodesize(_addr)
512         }
513         return size>0;
514     }
515 
516     /// @dev Helper function to return a min betwen the two uints
517     function min(uint a, uint b) internal returns (uint) {
518         return a < b ? a : b;
519     }
520 
521     /// @notice The fallback function: If the contract's controller has not been
522     ///  set to 0, then the `proxyPayment` method is called which relays the
523     ///  ether and creates tokens as described in the token controller contract
524     function ()  payable {
525         if (isContract(controller)) {
526             if (! TokenController(controller).proxyPayment.value(msg.value)(msg.sender))
527                 throw;
528         } else {
529             throw;
530         }
531     }
532 
533 
534 ////////////////
535 // Events
536 ////////////////
537     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
538     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
539     event Approval(
540         address indexed _owner,
541         address indexed _spender,
542         uint256 _amount
543         );
544 
545 }
546 
547 
548 ////////////////
549 // MiniMeTokenFactory
550 ////////////////
551 
552 /// @dev This contract is used to generate clone contracts from a contract.
553 ///  In solidity this is the way to create a contract from a contract of the
554 ///  same class
555 contract MiniMeTokenFactory {
556 
557     /// @notice Update the DApp by creating a new token with new functionalities
558     ///  the msg.sender becomes the controller of this clone token
559     /// @param _parentToken Address of the token being cloned
560     /// @param _snapshotBlock Block of the parent token that will
561     ///  determine the initial distribution of the clone token
562     /// @param _tokenName Name of the new token
563     /// @param _decimalUnits Number of decimals of the new token
564     /// @param _tokenSymbol Token Symbol for the new token
565     /// @param _transfersEnabled If true, tokens will be able to be transferred
566     /// @return The address of the new token contract
567     function createCloneToken(
568         address _parentToken,
569         uint _snapshotBlock,
570         string _tokenName,
571         uint8 _decimalUnits,
572         string _tokenSymbol,
573         bool _transfersEnabled
574     ) returns (MiniMeToken) {
575         MiniMeToken newToken = new MiniMeToken(
576             this,
577             _parentToken,
578             _snapshotBlock,
579             _tokenName,
580             _decimalUnits,
581             _tokenSymbol,
582             _transfersEnabled
583             );
584 
585         newToken.changeController(msg.sender);
586         return newToken;
587     }
588 }
589 
590 library SafeMath {
591   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
592     uint256 c = a * b;
593     assert(a == 0 || c / a == b);
594     return c;
595   }
596 
597   function div(uint256 a, uint256 b) internal constant returns (uint256) {
598     // assert(b > 0); // Solidity automatically throws when dividing by 0
599     uint256 c = a / b;
600     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
601     return c;
602   }
603 
604   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
605     assert(b <= a);
606     return a - b;
607   }
608 
609   function add(uint256 a, uint256 b) internal constant returns (uint256) {
610     uint256 c = a + b;
611     assert(c >= a);
612     return c;
613   }
614 }
615 
616 contract Ownable {
617   address public owner;
618 
619 
620   /**
621    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
622    * account.
623    */
624   function Ownable() {
625     owner = msg.sender;
626   }
627 
628 
629   /**
630    * @dev Throws if called by any account other than the owner.
631    */
632   modifier onlyOwner() {
633     require(msg.sender == owner);
634     _;
635   }
636 
637 
638   /**
639    * @dev Allows the current owner to transfer control of the contract to a newOwner.
640    * @param newOwner The address to transfer ownership to.
641    */
642   function transferOwnership(address newOwner) onlyOwner {
643     if (newOwner != address(0)) {
644       owner = newOwner;
645     }
646   }
647 
648 }
649 
650 
651 contract ProfitSharing is Ownable {
652   using SafeMath for uint;
653 
654   event DividendDeposited(address indexed _depositor, uint256 _blockNumber, uint256 _amount, uint256 _totalSupply, uint256 _dividendIndex);
655   event DividendClaimed(address indexed _claimer, uint256 _dividendIndex, uint256 _claim);
656   event DividendRecycled(address indexed _recycler, uint256 _blockNumber, uint256 _amount, uint256 _totalSupply, uint256 _dividendIndex);
657 
658   MiniMeToken public miniMeToken;
659 
660   uint256 public RECYCLE_TIME = 1 years;
661 
662   struct Dividend {
663     uint256 blockNumber;
664     uint256 timestamp;
665     uint256 amount;
666     uint256 claimedAmount;
667     uint256 totalSupply;
668     bool recycled;
669     mapping (address => bool) claimed;
670   }
671 
672   Dividend[] public dividends;
673 
674   mapping (address => uint256) dividendsClaimed;
675 
676   modifier validDividendIndex(uint256 _dividendIndex) {
677     require(_dividendIndex < dividends.length);
678     _;
679   }
680 
681   function ProfitSharing(address _miniMeToken) {
682     miniMeToken = MiniMeToken(_miniMeToken);
683   }
684 
685   function depositDividend() payable
686   onlyOwner
687   {
688     uint256 currentSupply = miniMeToken.totalSupplyAt(block.number);
689     uint256 dividendIndex = dividends.length;
690     dividends.push(
691       Dividend(
692         block.number,
693         getNow(),
694         msg.value,
695         0,
696         currentSupply,
697         false
698       )
699     );
700     DividendDeposited(msg.sender, block.number, msg.value, currentSupply, dividendIndex);
701   }
702 
703   function claimDividend(uint256 _dividendIndex) public
704   validDividendIndex(_dividendIndex)
705   {
706     Dividend dividend = dividends[_dividendIndex];
707     require(dividend.claimed[msg.sender] == false);
708     require(dividend.recycled == false);
709     uint256 balance = miniMeToken.balanceOfAt(msg.sender, dividend.blockNumber);
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
737     uint256 currentSupply = miniMeToken.totalSupplyAt(block.number);
738     uint256 remainingAmount = SafeMath.sub(dividend.amount, dividend.claimedAmount);
739     uint256 dividendIndex = dividends.length;
740     dividends.push(
741       Dividend(
742         block.number,
743         getNow(),
744         remainingAmount,
745         0,
746         currentSupply,
747         false
748       )
749     );
750     DividendRecycled(msg.sender, block.number, remainingAmount, currentSupply, dividendIndex);
751   }
752 
753   //Function is mocked for tests
754   function getNow() internal constant returns (uint256) {
755     return now;
756   }
757 
758 }