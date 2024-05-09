1 pragma solidity ^0.4.6;
2 
3 contract Ownable {
4   address public owner;
5 
6   function Ownable() {
7     owner = msg.sender;
8   }
9 
10   modifier onlyOwner() {
11     if (msg.sender != owner) {
12       throw;
13     }
14     _;
15   }
16 
17   function transferOwnership(address newOwner) onlyOwner {
18     if (newOwner != address(0)) {
19       owner = newOwner;
20     }
21   }
22 
23 }
24 
25 /*
26     Copyright 2016, Jordi Baylina
27 
28     This program is free software: you can redistribute it and/or modify
29     it under the terms of the GNU General Public License as published by
30     the Free Software Foundation, either version 3 of the License, or
31     (at your option) any later version.
32 
33     This program is distributed in the hope that it will be useful,
34     but WITHOUT ANY WARRANTY; without even the implied warranty of
35     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
36     GNU General Public License for more details.
37 
38     You should have received a copy of the GNU General Public License
39     along with this program.  If not, see <http://www.gnu.org/licenses/>.
40  */
41 
42 /// @title MiniMeToken Contract
43 /// @author Jordi Baylina
44 /// @dev This token contract's goal is to make it easy for anyone to clone this
45 ///  token using the token distribution at a given block, this will allow DAO's
46 ///  and DApps to upgrade their features in a decentralized manner without
47 ///  affecting the original token
48 /// @dev It is ERC20 compliant, but still needs to under go further testing.
49 
50 
51 /// @dev The token controller contract must implement these functions
52 contract TokenController {
53     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
54     /// @param _owner The address that sent the ether to create tokens
55     /// @return True if the ether is accepted, false if it throws
56     function proxyPayment(address _owner) payable returns(bool);
57 
58     /// @notice Notifies the controller about a token transfer allowing the
59     ///  controller to react if desired
60     /// @param _from The origin of the transfer
61     /// @param _to The destination of the transfer
62     /// @param _amount The amount of the transfer
63     /// @return False if the controller does not authorize the transfer
64     function onTransfer(address _from, address _to, uint _amount) returns(bool);
65 
66     /// @notice Notifies the controller about an approval allowing the
67     ///  controller to react if desired
68     /// @param _owner The address that calls `approve()`
69     /// @param _spender The spender in the `approve()` call
70     /// @param _amount The amount in the `approve()` call
71     /// @return False if the controller does not authorize the approval
72     function onApprove(address _owner, address _spender, uint _amount)
73         returns(bool);
74 }
75 
76 contract Controlled {
77     /// @notice The address of the controller is the only address that can call
78     ///  a function with this modifier
79     modifier onlyController { if (msg.sender != controller) throw; _; }
80 
81     address public controller;
82 
83     function Controlled() { controller = msg.sender;}
84 
85     /// @notice Changes the controller of the contract
86     /// @param _newController The new controller of the contract
87     function changeController(address _newController) onlyController {
88         controller = _newController;
89     }
90 }
91 
92 contract ApproveAndCallFallBack {
93     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
94 }
95 
96 /// @dev The actual token contract, the default controller is the msg.sender
97 ///  that deploys the contract, so usually this token will be deployed by a
98 ///  token controller contract, which Giveth will call a "Campaign"
99 contract MiniMeToken is Controlled, Ownable {
100 
101     string public name;                //The Token's name: e.g. DigixDAO Tokens
102     uint8 public decimals;             //Number of decimals of the smallest unit
103     string public symbol;              //An identifier: e.g. REP
104     string public version = 'MMT_0.1'; //An arbitrary versioning scheme
105 
106     /// @dev `Checkpoint` is the structure that attaches a block number to a
107     ///  given value, the block number attached is the one that last changed the
108     ///  value
109     struct  Checkpoint {
110 
111         // `fromBlock` is the block number that the value was generated from
112         uint128 fromBlock;
113 
114         // `value` is the amount of tokens at a specific block number
115         uint128 value;
116     }
117 
118     // `parentToken` is the Token address that was cloned to produce this token;
119     //  it will be 0x0 for a token that was not cloned
120     MiniMeToken public parentToken;
121 
122     // `parentSnapShotBlock` is the block number from the Parent Token that was
123     //  used to determine the initial distribution of the Clone Token
124     uint public parentSnapShotBlock;
125 
126     // `creationBlock` is the block number that the Clone Token was created
127     uint public creationBlock;
128 
129     // `balances` is the map that tracks the balance of each address, in this
130     //  contract when the balance changes the block number that the change
131     //  occurred is also included in the map
132     mapping (address => Checkpoint[]) balances;
133 
134     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
135     mapping (address => mapping (address => uint256)) allowed;
136 
137     // Tracks the history of the `totalSupply` of the token
138     Checkpoint[] totalSupplyHistory;
139 
140     // Flag that determines if the token is transferable or not.
141     bool public transfersEnabled;
142 
143     // The factory used to create new clone tokens
144     MiniMeTokenFactory public tokenFactory;
145 
146 ////////////////
147 // Constructor
148 ////////////////
149 
150     /// @notice Constructor to create a MiniMeToken
151     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
152     ///  will create the Clone token contracts, the token factory needs to be
153     ///  deployed first
154     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
155     ///  new token
156     /// @param _parentSnapShotBlock Block of the parent token that will
157     ///  determine the initial distribution of the clone token, set to 0 if it
158     ///  is a new token
159     /// @param _tokenName Name of the new token
160     /// @param _decimalUnits Number of decimals of the new token
161     /// @param _tokenSymbol Token Symbol for the new token
162     /// @param _transfersEnabled If true, tokens will be able to be transferred
163     function MiniMeToken(
164         address _tokenFactory,
165         address _parentToken,
166         uint _parentSnapShotBlock,
167         string _tokenName,
168         uint8 _decimalUnits,
169         string _tokenSymbol,
170         bool _transfersEnabled
171     ) {
172         tokenFactory = MiniMeTokenFactory(_tokenFactory);
173         name = _tokenName;                                 // Set the name
174         decimals = _decimalUnits;                          // Set the decimals
175         symbol = _tokenSymbol;                             // Set the symbol
176         parentToken = MiniMeToken(_parentToken);
177         parentSnapShotBlock = _parentSnapShotBlock;
178         transfersEnabled = _transfersEnabled;
179         creationBlock = block.number;
180     }
181 
182 
183 ///////////////////
184 // ERC20 Methods
185 ///////////////////
186 
187     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
188     /// @param _to The address of the recipient
189     /// @param _amount The amount of tokens to be transferred
190     /// @return Whether the transfer was successful or not
191     function transfer(address _to, uint256 _amount) returns (bool success) {
192         if (!transfersEnabled) throw;
193         return doTransfer(msg.sender, _to, _amount);
194     }
195 
196     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
197     ///  is approved by `_from`
198     /// @param _from The address holding the tokens being transferred
199     /// @param _to The address of the recipient
200     /// @param _amount The amount of tokens to be transferred
201     /// @return True if the transfer was successful
202     function transferFrom(address _from, address _to, uint256 _amount
203     ) returns (bool success) {
204 
205         // The controller of this contract can move tokens around at will,
206         //  this is important to recognize! Confirm that you trust the
207         //  controller of this contract, which in most situations should be
208         //  another open source smart contract or 0x0
209         if (msg.sender != controller) {
210             if (!transfersEnabled) throw;
211 
212             // The standard ERC 20 transferFrom functionality
213             if (allowed[_from][msg.sender] < _amount) return false;
214             allowed[_from][msg.sender] -= _amount;
215         }
216         return doTransfer(_from, _to, _amount);
217     }
218 
219     /// @dev This is the actual transfer function in the token contract, it can
220     ///  only be called by other functions in this contract.
221     /// @param _from The address holding the tokens being transferred
222     /// @param _to The address of the recipient
223     /// @param _amount The amount of tokens to be transferred
224     /// @return True if the transfer was successful
225     function doTransfer(address _from, address _to, uint _amount
226     ) internal returns(bool) {
227 
228            if (_amount == 0) {
229                return true;
230            }
231 
232            if (parentSnapShotBlock >= block.number) throw;
233 
234            // Do not allow transfer to 0x0 or the token contract itself
235            if ((_to == 0) || (_to == address(this))) throw;
236 
237            // If the amount being transfered is more than the balance of the
238            //  account the transfer returns false
239            var previousBalanceFrom = balanceOfAt(_from, block.number);
240            if (previousBalanceFrom < _amount) {
241                return false;
242            }
243 
244            // Alerts the token controller of the transfer
245            if (isContract(controller)) {
246                if (!TokenController(controller).onTransfer(_from, _to, _amount))
247                throw;
248            }
249 
250            // First update the balance array with the new value for the address
251            //  sending the tokens
252            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
253 
254            // Then update the balance array with the new value for the address
255            //  receiving the tokens
256            var previousBalanceTo = balanceOfAt(_to, block.number);
257            if (previousBalanceTo + _amount < previousBalanceTo) throw; // Check for overflow
258            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
259 
260            // An event to make the transfer easy to find on the blockchain
261            Transfer(_from, _to, _amount);
262 
263            return true;
264     }
265 
266     /// @param _owner The address that's balance is being requested
267     /// @return The balance of `_owner` at the current block
268     function balanceOf(address _owner) constant returns (uint256 balance) {
269         return balanceOfAt(_owner, block.number);
270     }
271 
272     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
273     ///  its behalf. This is a modified version of the ERC20 approve function
274     ///  to be a little bit safer
275     /// @param _spender The address of the account able to transfer the tokens
276     /// @param _amount The amount of tokens to be approved for transfer
277     /// @return True if the approval was successful
278     function approve(address _spender, uint256 _amount) returns (bool success) {
279         if (!transfersEnabled) throw;
280 
281         // To change the approve amount you first have to reduce the addresses`
282         //  allowance to zero by calling `approve(_spender,0)` if it is not
283         //  already 0 to mitigate the race condition described here:
284         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
285         if ((_amount!=0) && (allowed[msg.sender][_spender] !=0)) throw;
286 
287         // Alerts the token controller of the approve function call
288         if (isContract(controller)) {
289             if (!TokenController(controller).onApprove(msg.sender, _spender, _amount))
290                 throw;
291         }
292 
293         allowed[msg.sender][_spender] = _amount;
294         Approval(msg.sender, _spender, _amount);
295         return true;
296     }
297 
298     /// @dev This function makes it easy to read the `allowed[]` map
299     /// @param _owner The address of the account that owns the token
300     /// @param _spender The address of the account able to transfer the tokens
301     /// @return Amount of remaining tokens of _owner that _spender is allowed
302     ///  to spend
303     function allowance(address _owner, address _spender
304     ) constant returns (uint256 remaining) {
305         return allowed[_owner][_spender];
306     }
307 
308     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
309     ///  its behalf, and then a function is triggered in the contract that is
310     ///  being approved, `_spender`. This allows users to use their tokens to
311     ///  interact with contracts in one function call instead of two
312     /// @param _spender The address of the contract able to transfer the tokens
313     /// @param _amount The amount of tokens to be approved for transfer
314     /// @return True if the function call was successful
315     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
316     ) returns (bool success) {
317         if (!approve(_spender, _amount)) throw;
318 
319         ApproveAndCallFallBack(_spender).receiveApproval(
320             msg.sender,
321             _amount,
322             this,
323             _extraData
324         );
325 
326         return true;
327     }
328 
329     /// @dev This function makes it easy to get the total number of tokens
330     /// @return The total number of tokens
331     function totalSupply() constant returns (uint) {
332         return totalSupplyAt(block.number);
333     }
334 
335 
336 ////////////////
337 // Query balance and totalSupply in History
338 ////////////////
339 
340     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
341     /// @param _owner The address from which the balance will be retrieved
342     /// @param _blockNumber The block number when the balance is queried
343     /// @return The balance at `_blockNumber`
344     function balanceOfAt(address _owner, uint _blockNumber) constant
345         returns (uint) {
346 
347         // These next few lines are used when the balance of the token is
348         //  requested before a check point was ever created for this token, it
349         //  requires that the `parentToken.balanceOfAt` be queried at the
350         //  genesis block for that token as this contains initial balance of
351         //  this token
352         if ((balances[_owner].length == 0)
353             || (balances[_owner][0].fromBlock > _blockNumber)) {
354             if (address(parentToken) != 0) {
355                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
356             } else {
357                 // Has no parent
358                 return 0;
359             }
360 
361         // This will return the expected balance during normal situations
362         } else {
363             return getValueAt(balances[_owner], _blockNumber);
364         }
365     }
366 
367     /// @notice Total amount of tokens at a specific `_blockNumber`.
368     /// @param _blockNumber The block number when the totalSupply is queried
369     /// @return The total amount of tokens at `_blockNumber`
370     function totalSupplyAt(uint _blockNumber) constant returns(uint) {
371 
372         // These next few lines are used when the totalSupply of the token is
373         //  requested before a check point was ever created for this token, it
374         //  requires that the `parentToken.totalSupplyAt` be queried at the
375         //  genesis block for this token as that contains totalSupply of this
376         //  token at this block number.
377         if ((totalSupplyHistory.length == 0)
378             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
379             if (address(parentToken) != 0) {
380                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
381             } else {
382                 return 0;
383             }
384 
385         // This will return the expected totalSupply during normal situations
386         } else {
387             return getValueAt(totalSupplyHistory, _blockNumber);
388         }
389     }
390 
391 ////////////////
392 // Clone Token Method
393 ////////////////
394 
395     /// @notice Creates a new clone token with the initial distribution being
396     ///  this token at `_snapshotBlock`
397     /// @param _cloneTokenName Name of the clone token
398     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
399     /// @param _cloneTokenSymbol Symbol of the clone token
400     /// @param _snapshotBlock Block when the distribution of the parent token is
401     ///  copied to set the initial distribution of the new clone token;
402     ///  if the block is zero than the actual block, the current block is used
403     /// @param _transfersEnabled True if transfers are allowed in the clone
404     /// @return The address of the new MiniMeToken Contract
405     function createCloneToken(
406         string _cloneTokenName,
407         uint8 _cloneDecimalUnits,
408         string _cloneTokenSymbol,
409         uint _snapshotBlock,
410         bool _transfersEnabled
411         ) returns(address) {
412         if (_snapshotBlock == 0) _snapshotBlock = block.number;
413         MiniMeToken cloneToken = tokenFactory.createCloneToken(
414             this,
415             _snapshotBlock,
416             _cloneTokenName,
417             _cloneDecimalUnits,
418             _cloneTokenSymbol,
419             _transfersEnabled
420             );
421 
422         cloneToken.changeController(msg.sender);
423 
424         // An event to make the token easy to find on the blockchain
425         NewCloneToken(address(cloneToken), _snapshotBlock);
426         return address(cloneToken);
427     }
428 
429 ////////////////
430 // Generate and destroy tokens
431 ////////////////
432 
433     /// @notice Generates `_amount` tokens that are assigned to `_owner`
434     /// @param _owner The address that will be assigned the new tokens
435     /// @param _amount The quantity of tokens generated
436     /// @return True if the tokens are generated correctly
437     function generateTokens(address _owner, uint _amount
438     ) onlyController returns (bool) {
439         uint curTotalSupply = getValueAt(totalSupplyHistory, block.number);
440         if (curTotalSupply + _amount < curTotalSupply) throw; // Check for overflow
441         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
442         var previousBalanceTo = balanceOf(_owner);
443         if (previousBalanceTo + _amount < previousBalanceTo) throw; // Check for overflow
444         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
445         Transfer(0, _owner, _amount);
446         return true;
447     }
448 
449 
450     /// @notice Burns `_amount` tokens from `_owner`
451     /// @param _owner The address that will lose the tokens
452     /// @param _amount The quantity of tokens to burn
453     /// @return True if the tokens are burned correctly
454     function destroyTokens(address _owner, uint _amount
455     ) onlyController returns (bool) {
456         uint curTotalSupply = getValueAt(totalSupplyHistory, block.number);
457         if (curTotalSupply < _amount) throw;
458         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
459         var previousBalanceFrom = balanceOf(_owner);
460         if (previousBalanceFrom < _amount) throw;
461         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
462         Transfer(_owner, 0, _amount);
463         return true;
464     }
465 
466 ////////////////
467 // Enable tokens transfers
468 ////////////////
469 
470 
471     /// @notice Enables token holders to transfer their tokens freely if true
472     /// @param _transfersEnabled True if transfers are allowed in the clone
473     function enableTransfers(bool _transfersEnabled) onlyController {
474         transfersEnabled = _transfersEnabled;
475     }
476 
477 ////////////////
478 // Internal helper functions to query and set a value in a snapshot array
479 ////////////////
480 
481     /// @dev `getValueAt` retrieves the number of tokens at a given block number
482     /// @param checkpoints The history of values being queried
483     /// @param _block The block number to retrieve the value at
484     /// @return The number of tokens being queried
485     function getValueAt(Checkpoint[] storage checkpoints, uint _block
486     ) constant internal returns (uint) {
487         if (checkpoints.length == 0) return 0;
488 
489         // Shortcut for the actual value
490         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
491             return checkpoints[checkpoints.length-1].value;
492         if (_block < checkpoints[0].fromBlock) return 0;
493 
494         // Binary search of the value in the array
495         uint min = 0;
496         uint max = checkpoints.length-1;
497         while (max > min) {
498             uint mid = (max + min + 1)/ 2;
499             if (checkpoints[mid].fromBlock<=_block) {
500                 min = mid;
501             } else {
502                 max = mid-1;
503             }
504         }
505         return checkpoints[min].value;
506     }
507 
508     /// @dev `updateValueAtNow` used to update the `balances` map and the
509     ///  `totalSupplyHistory`
510     /// @param checkpoints The history of data being updated
511     /// @param _value The new number of tokens
512     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
513     ) internal  {
514         if ((checkpoints.length == 0)
515         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
516                Checkpoint newCheckPoint = checkpoints[ checkpoints.length++ ];
517                newCheckPoint.fromBlock =  uint128(block.number);
518                newCheckPoint.value = uint128(_value);
519            } else {
520                Checkpoint oldCheckPoint = checkpoints[checkpoints.length-1];
521                oldCheckPoint.value = uint128(_value);
522            }
523     }
524 
525     /// @dev Internal function to determine if an address is a contract
526     /// @param _addr The address being queried
527     /// @return True if `_addr` is a contract
528     function isContract(address _addr) constant internal returns(bool) {
529         uint size;
530         if (_addr == 0) return false;
531         assembly {
532             size := extcodesize(_addr)
533         }
534         return size>0;
535     }
536 
537     /// @dev Helper function to return a min betwen the two uints
538     function min(uint a, uint b) internal returns (uint) {
539         return a < b ? a : b;
540     }
541 
542     /// @notice The fallback function: If the contract's controller has not been
543     ///  set to 0, then the `proxyPayment` method is called which relays the
544     ///  ether and creates tokens as described in the token controller contract
545     function ()  payable {
546         if (isContract(controller)) {
547             if (! TokenController(controller).proxyPayment.value(msg.value)(msg.sender))
548                 throw;
549         } else {
550             throw;
551         }
552     }
553 
554 
555 ////////////////
556 // Events
557 ////////////////
558     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
559     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
560     event Approval(
561         address indexed _owner,
562         address indexed _spender,
563         uint256 _amount
564         );
565 
566 }
567 
568 
569 ////////////////
570 // MiniMeTokenFactory
571 ////////////////
572 
573 /// @dev This contract is used to generate clone contracts from a contract.
574 ///  In solidity this is the way to create a contract from a contract of the
575 ///  same class
576 contract MiniMeTokenFactory {
577 
578     /// @notice Update the DApp by creating a new token with new functionalities
579     ///  the msg.sender becomes the controller of this clone token
580     /// @param _parentToken Address of the token being cloned
581     /// @param _snapshotBlock Block of the parent token that will
582     ///  determine the initial distribution of the clone token
583     /// @param _tokenName Name of the new token
584     /// @param _decimalUnits Number of decimals of the new token
585     /// @param _tokenSymbol Token Symbol for the new token
586     /// @param _transfersEnabled If true, tokens will be able to be transferred
587     /// @return The address of the new token contract
588     function createCloneToken(
589         address _parentToken,
590         uint _snapshotBlock,
591         string _tokenName,
592         uint8 _decimalUnits,
593         string _tokenSymbol,
594         bool _transfersEnabled
595     ) returns (MiniMeToken) {
596         MiniMeToken newToken = new MiniMeToken(
597             this,
598             _parentToken,
599             _snapshotBlock,
600             _tokenName,
601             _decimalUnits,
602             _tokenSymbol,
603             _transfersEnabled
604             );
605 
606         newToken.changeController(msg.sender);
607         return newToken;
608     }
609 }
610 contract ETSToken is MiniMeToken {
611 
612     uint256 constant D160 = 0x0010000000000000000000000000000000000000000;
613 
614     function ETSToken(address _tokenFactory)
615             MiniMeToken(
616                 _tokenFactory,
617                 0x0,                     // no parent token
618                 0,                       // no snapshot block number from parent
619                 "ETH Share",  // Token name
620                 3,                       // Decimals
621                 "ETS",                   // Symbol
622                 false                    // Enable transfers
623             ) {}
624 
625     // data is an array of uint256s. Each uint256 represents a transfer.
626     // The 160 LSB is the destination of the address that wants to be sent
627     // The 96 MSB is the amount of tokens that wants to be sent.
628     function multiMint(uint256[] data) public onlyController {
629         for (uint256 i = 0; i < data.length; i++) {
630             address addr = address(data[i] & (D160 - 1));
631             uint256 amount = data[i] / D160;
632 
633             assert(generateTokens(addr, amount));
634         }
635     }
636 
637 }