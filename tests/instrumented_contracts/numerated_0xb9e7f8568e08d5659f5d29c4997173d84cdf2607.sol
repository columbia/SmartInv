1 pragma solidity ^0.4.6;
2 
3 /*
4     Copyright 2016, Jordi Baylina
5 
6     This program is free software: you can redistribute it and/or modify
7     it under the terms of the GNU General Public License as published by
8     the Free Software Foundation, either version 3 of the License, or
9     (at your option) any later version.
10 
11     This program is distributed in the hope that it will be useful,
12     but WITHOUT ANY WARRANTY; without even the implied warranty of
13     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
14     GNU General Public License for more details.
15 
16     You should have received a copy of the GNU General Public License
17     along with this program.  If not, see <http://www.gnu.org/licenses/>.
18  */
19 
20 /// @title MiniMeToken Contract
21 /// @author Jordi Baylina
22 /// @dev This token contract's goal is to make it easy for anyone to clone this
23 ///  token using the token distribution at a given block, this will allow DAO's
24 ///  and DApps to upgrade their features in a decentralized manner without
25 ///  affecting the original token
26 /// @dev It is ERC20 compliant, but still needs to under go further testing.
27 
28 
29 /// @dev The token controller contract must implement these functions
30 contract TokenController {
31     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
32     /// @param _owner The address that sent the ether to create tokens
33     /// @return True if the ether is accepted, false if it throws
34     function proxyPayment(address _owner) payable returns(bool);
35 
36     /// @notice Notifies the controller about a token transfer allowing the
37     ///  controller to react if desired
38     /// @param _from The origin of the transfer
39     /// @param _to The destination of the transfer
40     /// @param _amount The amount of the transfer
41     /// @return False if the controller does not authorize the transfer
42     function onTransfer(address _from, address _to, uint _amount) returns(bool);
43 
44     /// @notice Notifies the controller about an approval allowing the
45     ///  controller to react if desired
46     /// @param _owner The address that calls `approve()`
47     /// @param _spender The spender in the `approve()` call
48     /// @param _amount The amount in the `approve()` call
49     /// @return False if the controller does not authorize the approval
50     function onApprove(address _owner, address _spender, uint _amount)
51         returns(bool);
52 }
53 
54 contract Controlled {
55     /// @notice The address of the controller is the only address that can call
56     ///  a function with this modifier
57     modifier onlyController { if (msg.sender != controller) throw; _; }
58 
59     address public controller;
60 
61     function Controlled() { controller = msg.sender;}
62 
63     /// @notice Changes the controller of the contract
64     /// @param _newController The new controller of the contract
65     function changeController(address _newController) onlyController {
66         controller = _newController;
67     }
68 }
69 
70 /// @dev The actual token contract, the default controller is the msg.sender
71 ///  that deploys the contract, so usually this token will be deployed by a
72 ///  token controller contract, which Giveth will call a "Campaign"
73 contract MiniMeToken is Controlled {
74 
75     string public name;                //The Token's name: e.g. DigixDAO Tokens
76     uint8 public decimals;             //Number of decimals of the smallest unit
77     string public symbol;              //An identifier: e.g. REP
78     string public version = 'MMT_0.1'; //An arbitrary versioning scheme
79 
80 
81     /// @dev `Checkpoint` is the structure that attaches a block number to a
82     ///  given value, the block number attached is the one that last changed the
83     ///  value
84     struct  Checkpoint {
85 
86         // `fromBlock` is the block number that the value was generated from
87         uint128 fromBlock;
88 
89         // `value` is the amount of tokens at a specific block number
90         uint128 value;
91     }
92 
93     // `parentToken` is the Token address that was cloned to produce this token;
94     //  it will be 0x0 for a token that was not cloned
95     MiniMeToken public parentToken;
96 
97     // `parentSnapShotBlock` is the block number from the Parent Token that was
98     //  used to determine the initial distribution of the Clone Token
99     uint public parentSnapShotBlock;
100 
101     // `creationBlock` is the block number that the Clone Token was created
102     uint public creationBlock;
103 
104     // `balances` is the map that tracks the balance of each address, in this
105     //  contract when the balance changes the block number that the change
106     //  occurred is also included in the map
107     mapping (address => Checkpoint[]) balances;
108 
109     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
110     mapping (address => mapping (address => uint256)) allowed;
111 
112     // Tracks the history of the `totalSupply` of the token
113     Checkpoint[] totalSupplyHistory;
114 
115     // Flag that determines if the token is transferable or not.
116     bool public transfersEnabled;
117 
118     // The factory used to create new clone tokens
119     MiniMeTokenFactory public tokenFactory;
120 
121 ////////////////
122 // Constructor
123 ////////////////
124 
125     /// @notice Constructor to create a MiniMeToken
126     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
127     ///  will create the Clone token contracts, the token factory needs to be
128     ///  deployed first
129     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
130     ///  new token
131     /// @param _parentSnapShotBlock Block of the parent token that will
132     ///  determine the initial distribution of the clone token, set to 0 if it
133     ///  is a new token
134     /// @param _tokenName Name of the new token
135     /// @param _decimalUnits Number of decimals of the new token
136     /// @param _tokenSymbol Token Symbol for the new token
137     /// @param _transfersEnabled If true, tokens will be able to be transferred
138     function MiniMeToken(
139         address _tokenFactory,
140         address _parentToken,
141         uint _parentSnapShotBlock,
142         string _tokenName,
143         uint8 _decimalUnits,
144         string _tokenSymbol,
145         bool _transfersEnabled
146     ) {
147         tokenFactory = MiniMeTokenFactory(_tokenFactory);
148         name = _tokenName;                                 // Set the name
149         decimals = _decimalUnits;                          // Set the decimals
150         symbol = _tokenSymbol;                             // Set the symbol
151         parentToken = MiniMeToken(_parentToken);
152         parentSnapShotBlock = _parentSnapShotBlock;
153         transfersEnabled = _transfersEnabled;
154         creationBlock = block.number;
155     }
156 
157 
158 ///////////////////
159 // ERC20 Methods
160 ///////////////////
161 
162     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
163     /// @param _to The address of the recipient
164     /// @param _amount The amount of tokens to be transferred
165     /// @return Whether the transfer was successful or not
166     function transfer(address _to, uint256 _amount) returns (bool success) {
167         if (!transfersEnabled) throw;
168         return doTransfer(msg.sender, _to, _amount);
169     }
170 
171     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
172     ///  is approved by `_from`
173     /// @param _from The address holding the tokens being transferred
174     /// @param _to The address of the recipient
175     /// @param _amount The amount of tokens to be transferred
176     /// @return True if the transfer was successful
177     function transferFrom(address _from, address _to, uint256 _amount
178     ) returns (bool success) {
179 
180         // The controller of this contract can move tokens around at will,
181         //  this is important to recognize! Confirm that you trust the
182         //  controller of this contract, which in most situations should be
183         //  another open source smart contract or 0x0
184         if (msg.sender != controller) {
185             if (!transfersEnabled) throw;
186 
187             // The standard ERC 20 transferFrom functionality
188             if (allowed[_from][msg.sender] < _amount) return false;
189             allowed[_from][msg.sender] -= _amount;
190         }
191         return doTransfer(_from, _to, _amount);
192     }
193 
194     /// @dev This is the actual transfer function in the token contract, it can
195     ///  only be called by other functions in this contract.
196     /// @param _from The address holding the tokens being transferred
197     /// @param _to The address of the recipient
198     /// @param _amount The amount of tokens to be transferred
199     /// @return True if the transfer was successful
200     function doTransfer(address _from, address _to, uint _amount
201     ) internal returns(bool) {
202 
203            if (_amount == 0) {
204                return true;
205            }
206 
207            // Do not allow transfer to 0x0 or the token contract itself
208            if ((_to == 0) || (_to == address(this))) throw;
209 
210            // If the amount being transfered is more than the balance of the
211            //  account the transfer returns false
212            var previousBalanceFrom = balanceOfAt(_from, block.number);
213            if (previousBalanceFrom < _amount) {
214                return false;
215            }
216 
217            // Alerts the token controller of the transfer
218            if (isContract(controller)) {
219                if (!TokenController(controller).onTransfer(_from, _to, _amount))
220                throw;
221            }
222 
223            // First update the balance array with the new value for the address
224            //  sending the tokens
225            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
226 
227            // Then update the balance array with the new value for the address
228            //  receiving the tokens
229            var previousBalanceTo = balanceOfAt(_to, block.number);
230            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
231 
232            // An event to make the transfer easy to find on the blockchain
233            Transfer(_from, _to, _amount);
234 
235            return true;
236     }
237 
238     /// @param _owner The address that's balance is being requested
239     /// @return The balance of `_owner` at the current block
240     function balanceOf(address _owner) constant returns (uint256 balance) {
241         return balanceOfAt(_owner, block.number);
242     }
243 
244     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
245     ///  its behalf. This is a modified version of the ERC20 approve function
246     ///  to be a little bit safer
247     /// @param _spender The address of the account able to transfer the tokens
248     /// @param _amount The amount of tokens to be approved for transfer
249     /// @return True if the approval was successful
250     function approve(address _spender, uint256 _amount) returns (bool success) {
251         if (!transfersEnabled) throw;
252 
253         // To change the approve amount you first have to reduce the addresses´
254         //  allowance to zero by calling `approve(_spender,0)` if it is not
255         //  already 0 to mitigate the race condition described here:
256         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
257         if ((_amount!=0) && (allowed[msg.sender][_spender] !=0)) throw;
258 
259         // Alerts the token controller of the approve function call
260         if (isContract(controller)) {
261             if (!TokenController(controller).onApprove(msg.sender, _spender, _amount))
262                 throw;
263         }
264 
265         allowed[msg.sender][_spender] = _amount;
266         Approval(msg.sender, _spender, _amount);
267         return true;
268     }
269 
270     /// @dev This function makes it easy to read the `allowed[]` map
271     /// @param _owner The address of the account that owns the token
272     /// @param _spender The address of the account able to transfer the tokens
273     /// @return Amount of remaining tokens of _owner that _spender is allowed
274     ///  to spend
275     function allowance(address _owner, address _spender
276     ) constant returns (uint256 remaining) {
277         return allowed[_owner][_spender];
278     }
279 
280     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
281     ///  its behalf, and then a function is triggered in the contract that is
282     ///  being approved, `_spender`. This allows users to use their tokens to
283     ///  interact with contracts in one function call instead of two
284     /// @param _spender The address of the contract able to transfer the tokens
285     /// @param _amount The amount of tokens to be approved for transfer
286     /// @return True if the function call was successful
287     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
288     ) returns (bool success) {
289         allowed[msg.sender][_spender] = _amount;
290         Approval(msg.sender, _spender, _amount);
291 
292         // This portion is copied from ConsenSys's Standard Token Contract. It
293         //  calls the receiveApproval function that is part of the contract that
294         //  is being approved (`_spender`). The function should look like:
295         //  `receiveApproval(address _from, uint256 _amount, address
296         //  _tokenContract, bytes _extraData)` It is assumed that the call
297         //  *should* succeed, otherwise the plain vanilla approve would be used
298         if(!_spender.call(
299             bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))),
300             msg.sender,
301             _amount,
302             this,
303             _extraData
304             )) { throw;
305         }
306         return true;
307     }
308 
309     /// @dev This function makes it easy to get the total number of tokens
310     /// @return The total number of tokens
311     function totalSupply() constant returns (uint) {
312         return totalSupplyAt(block.number);
313     }
314 
315 
316 ////////////////
317 // Query balance and totalSupply in History
318 ////////////////
319 
320     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
321     /// @param _owner The address from which the balance will be retrieved
322     /// @param _blockNumber The block number when the balance is queried
323     /// @return The balance at `_blockNumber`
324     function balanceOfAt(address _owner, uint _blockNumber) constant
325         returns (uint) {
326 
327         // If the `_blockNumber` requested is before the genesis block for the
328         //  the token being queried, the value returned is 0
329         if (_blockNumber < creationBlock) {
330             return 0;
331 
332         // These next few lines are used when the balance of the token is
333         //  requested before a check point was ever created for this token, it
334         //  requires that the `parentToken.balanceOfAt` be queried at the
335         //  genesis block for that token as this contains initial balance of
336         //  this token
337         } else if ((balances[_owner].length == 0)
338             || (balances[_owner][0].fromBlock > _blockNumber)) {
339             if (address(parentToken) != 0) {
340                 return parentToken.balanceOfAt(_owner, parentSnapShotBlock);
341             } else {
342                 // Has no parent
343                 return 0;
344             }
345 
346         // This will return the expected balance during normal situations
347         } else {
348             return getValueAt(balances[_owner], _blockNumber);
349         }
350 
351     }
352 
353     /// @notice Total amount of tokens at a specific `_blockNumber`.
354     /// @param _blockNumber The block number when the totalSupply is queried
355     /// @return The total amount of tokens at `_blockNumber`
356     function totalSupplyAt(uint _blockNumber) constant returns(uint) {
357 
358         // If the `_blockNumber` requested is before the genesis block for the
359         //  the token being queried, the value returned is 0
360         if (_blockNumber < creationBlock) {
361             return 0;
362 
363         // These next few lines are used when the totalSupply of the token is
364         //  requested before a check point was ever created for this token, it
365         //  requires that the `parentToken.totalSupplyAt` be queried at the
366         //  genesis block for this token as that contains totalSupply of this
367         //  token at this block number.
368         } else if ((totalSupplyHistory.length == 0)
369             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
370             if (address(parentToken) != 0) {
371                 return parentToken.totalSupplyAt(parentSnapShotBlock);
372             } else {
373                 return 0;
374             }
375 
376         // This will return the expected totalSupply during normal situations
377         } else {
378             return getValueAt(totalSupplyHistory, _blockNumber);
379         }
380     }
381 
382 ////////////////
383 // Clone Token Method
384 ////////////////
385 
386     /// @notice Creates a new clone token with the initial distribution being
387     ///  this token at `_snapshotBlock`
388     /// @param _cloneTokenName Name of the clone token
389     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
390     /// @param _cloneTokenSymbol Symbol of the clone token
391     /// @param _snapshotBlock Block when the distribution of the parent token is
392     ///  copied to set the initial distribution of the new clone token;
393     ///  if the block is higher than the actual block, the current block is used
394     /// @param _transfersEnabled True if transfers are allowed in the clone
395     /// @return The address of the new MiniMeToken Contract
396     function createCloneToken(
397         string _cloneTokenName,
398         uint8 _cloneDecimalUnits,
399         string _cloneTokenSymbol,
400         uint _snapshotBlock,
401         bool _transfersEnabled
402         ) returns(address) {
403         if (_snapshotBlock > block.number) _snapshotBlock = block.number;
404         MiniMeToken cloneToken = tokenFactory.createCloneToken(
405             this,
406             _snapshotBlock,
407             _cloneTokenName,
408             _cloneDecimalUnits,
409             _cloneTokenSymbol,
410             _transfersEnabled
411             );
412 
413         cloneToken.changeController(msg.sender);
414 
415         // An event to make the token easy to find on the blockchain
416         NewCloneToken(address(cloneToken), _snapshotBlock);
417         return address(cloneToken);
418     }
419 
420 ////////////////
421 // Generate and destroy tokens
422 ////////////////
423 
424     /// @notice Generates `_amount` tokens that are assigned to `_owner`
425     /// @param _owner The address that will be assigned the new tokens
426     /// @param _amount The quantity of tokens generated
427     /// @return True if the tokens are generated correctly
428     function generateTokens(address _owner, uint _amount
429     ) onlyController returns (bool) {
430         uint curTotalSupply = getValueAt(totalSupplyHistory, block.number);
431         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
432         var previousBalanceTo = balanceOf(_owner);
433         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
434         Transfer(0, _owner, _amount);
435         return true;
436     }
437 
438 
439     /// @notice Burns `_amount` tokens from `_owner`
440     /// @param _owner The address that will lose the tokens
441     /// @param _amount The quantity of tokens to burn
442     /// @return True if the tokens are burned correctly
443     function destroyTokens(address _owner, uint _amount
444     ) onlyController returns (bool) {
445         uint curTotalSupply = getValueAt(totalSupplyHistory, block.number);
446         if (curTotalSupply < _amount) throw;
447         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
448         var previousBalanceFrom = balanceOf(_owner);
449         if (previousBalanceFrom < _amount) throw;
450         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
451         Transfer(_owner, 0, _amount);
452         return true;
453     }
454 
455 ////////////////
456 // Enable tokens transfers
457 ////////////////
458 
459 
460     /// @notice Enables token holders to transfer their tokens freely if true
461     /// @param _transfersEnabled True if transfers are allowed in the clone
462     function enableTransfers(bool _transfersEnabled) onlyController {
463         transfersEnabled = _transfersEnabled;
464     }
465 
466 ////////////////
467 // Internal helper functions to query and set a value in a snapshot array
468 ////////////////
469 
470     /// @dev `getValueAt` retrieves the number of tokens at a given block number
471     /// @param checkpoints The history of values being queried
472     /// @param _block The block number to retrieve the value at
473     /// @return The number of tokens being queried
474     function getValueAt(Checkpoint[] storage checkpoints, uint _block
475     ) constant internal returns (uint) {
476         if (checkpoints.length == 0) return 0;
477 
478         // Shortcut for the actual value
479         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
480             return checkpoints[checkpoints.length-1].value;
481         if (_block < checkpoints[0].fromBlock) return 0;
482 
483         // Binary search of the value in the array
484         uint min = 0;
485         uint max = checkpoints.length-1;
486         while (max > min) {
487             uint mid = (max + min + 1)/ 2;
488             if (checkpoints[mid].fromBlock<=_block) {
489                 min = mid;
490             } else {
491                 max = mid-1;
492             }
493         }
494         return checkpoints[min].value;
495     }
496 
497     /// @dev `updateValueAtNow` used to update the `balances` map and the
498     ///  `totalSupplyHistory`
499     /// @param checkpoints The history of data being updated
500     /// @param _value The new number of tokens
501     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
502     ) internal  {
503         if ((checkpoints.length == 0)
504         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
505                Checkpoint newCheckPoint = checkpoints[ checkpoints.length++ ];
506                newCheckPoint.fromBlock =  uint128(block.number);
507                newCheckPoint.value = uint128(_value);
508            } else {
509                Checkpoint oldCheckPoint = checkpoints[checkpoints.length-1];
510                oldCheckPoint.value = uint128(_value);
511            }
512     }
513 
514     /// @dev Internal function to determine if an address is a contract
515     /// @param _addr The address being queried
516     /// @return True if `_addr` is a contract
517     function isContract(address _addr) constant internal returns(bool) {
518         uint size;
519         if (_addr == 0) return false;
520         assembly {
521             size := extcodesize(_addr)
522         }
523         return size>0;
524     }
525 
526     /// @notice The fallback function: If the contract's controller has not been
527     ///  set to 0, then the `proxyPayment` method is called which relays the
528     ///  ether and creates tokens as described in the token controller contract
529     function ()  payable {
530         if (isContract(controller)) {
531             if (! TokenController(controller).proxyPayment.value(msg.value)(msg.sender))
532                 throw;
533         } else {
534             throw;
535         }
536     }
537 
538 
539 ////////////////
540 // Events
541 ////////////////
542     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
543     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
544     event Approval(
545         address indexed _owner,
546         address indexed _spender,
547         uint256 _amount
548         );
549 
550 }
551 
552 
553 ////////////////
554 // MiniMeTokenFactory
555 ////////////////
556 
557 /// @dev This contract is used to generate clone contracts from a contract.
558 ///  In solidity this is the way to create a contract from a contract of the
559 ///  same class
560 contract MiniMeTokenFactory {
561 
562     /// @notice Update the DApp by creating a new token with new functionalities
563     ///  the msg.sender becomes the controller of this clone token
564     /// @param _parentToken Address of the token being cloned
565     /// @param _snapshotBlock Block of the parent token that will
566     ///  determine the initial distribution of the clone token
567     /// @param _tokenName Name of the new token
568     /// @param _decimalUnits Number of decimals of the new token
569     /// @param _tokenSymbol Token Symbol for the new token
570     /// @param _transfersEnabled If true, tokens will be able to be transferred
571     /// @return The address of the new token contract
572     function createCloneToken(
573         address _parentToken,
574         uint _snapshotBlock,
575         string _tokenName,
576         uint8 _decimalUnits,
577         string _tokenSymbol,
578         bool _transfersEnabled
579     ) returns (MiniMeToken) {
580         MiniMeToken newToken = new MiniMeToken(
581             this,
582             _parentToken,
583             _snapshotBlock,
584             _tokenName,
585             _decimalUnits,
586             _tokenSymbol,
587             _transfersEnabled
588             );
589 
590         newToken.changeController(msg.sender);
591         return newToken;
592     }
593 }