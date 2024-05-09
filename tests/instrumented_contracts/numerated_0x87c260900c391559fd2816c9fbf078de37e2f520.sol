1 pragma solidity ^0.4.18;
2 
3 /*
4     Based on the work of Jordi Baylina with a slight modification about the approve function by Clément Lesaege.
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
20 
21 /// @dev The token controller contract must implement these functions
22 contract TokenController {
23     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
24     /// @param _owner The address that sent the ether to create tokens
25     /// @return True if the ether is accepted, false if it throws
26     function proxyPayment(address _owner) public payable returns(bool);
27 
28     /// @notice Notifies the controller about a token transfer allowing the
29     ///  controller to react if desired
30     /// @param _from The origin of the transfer
31     /// @param _to The destination of the transfer
32     /// @param _amount The amount of the transfer
33     /// @return False if the controller does not authorize the transfer
34     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
35 
36     /// @notice Notifies the controller about an approval allowing the
37     ///  controller to react if desired
38     /// @param _owner The address that calls `approve()`
39     /// @param _spender The spender in the `approve()` call
40     /// @param _amount The amount in the `approve()` call
41     /// @return False if the controller does not authorize the approval
42     function onApprove(address _owner, address _spender, uint _amount) public
43         returns(bool);
44 }
45 
46 
47 contract Controlled {
48     /// @notice The address of the controller is the only address that can call
49     ///  a function with this modifier
50     modifier onlyController { require(msg.sender == controller); _; }
51 
52     address public controller;
53 
54     function Controlled() public { controller = msg.sender;}
55 
56     /// @notice Changes the controller of the contract
57     /// @param _newController The new controller of the contract
58     function changeController(address _newController) public onlyController {
59         controller = _newController;
60     }
61 }
62 
63 
64 contract ApproveAndCallFallBack {
65     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
66 }
67 
68 /// @dev The actual token contract, the default controller is the msg.sender
69 ///  that deploys the contract, so usually this token will be deployed by a
70 ///  token controller contract, which Giveth will call a "Campaign"
71 contract MiniMeToken is Controlled {
72 
73     string public name;                //The Token's name: e.g. DigixDAO Tokens
74     uint8 public decimals;             //Number of decimals of the smallest unit
75     string public symbol;              //An identifier: e.g. REP
76     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
77 
78 
79     /// @dev `Checkpoint` is the structure that attaches a block number to a
80     ///  given value, the block number attached is the one that last changed the
81     ///  value
82     struct  Checkpoint {
83 
84         // `fromBlock` is the block number that the value was generated from
85         uint128 fromBlock;
86 
87         // `value` is the amount of tokens at a specific block number
88         uint128 value;
89     }
90 
91     // `parentToken` is the Token address that was cloned to produce this token;
92     //  it will be 0x0 for a token that was not cloned
93     MiniMeToken public parentToken;
94 
95     // `parentSnapShotBlock` is the block number from the Parent Token that was
96     //  used to determine the initial distribution of the Clone Token
97     uint public parentSnapShotBlock;
98 
99     // `creationBlock` is the block number that the Clone Token was created
100     uint public creationBlock;
101 
102     // `balances` is the map that tracks the balance of each address, in this
103     //  contract when the balance changes the block number that the change
104     //  occurred is also included in the map
105     mapping (address => Checkpoint[]) balances;
106 
107     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
108     mapping (address => mapping (address => uint256)) allowed;
109 
110     // Tracks the history of the `totalSupply` of the token
111     Checkpoint[] totalSupplyHistory;
112 
113     // Flag that determines if the token is transferable or not.
114     bool public transfersEnabled;
115 
116     // The factory used to create new clone tokens
117     MiniMeTokenFactory public tokenFactory;
118 
119 ////////////////
120 // Constructor
121 ////////////////
122 
123     /// @notice Constructor to create a MiniMeToken
124     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
125     ///  will create the Clone token contracts, the token factory needs to be
126     ///  deployed first
127     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
128     ///  new token
129     /// @param _parentSnapShotBlock Block of the parent token that will
130     ///  determine the initial distribution of the clone token, set to 0 if it
131     ///  is a new token
132     /// @param _tokenName Name of the new token
133     /// @param _decimalUnits Number of decimals of the new token
134     /// @param _tokenSymbol Token Symbol for the new token
135     /// @param _transfersEnabled If true, tokens will be able to be transferred
136     function MiniMeToken(
137         address _tokenFactory,
138         address _parentToken,
139         uint _parentSnapShotBlock,
140         string _tokenName,
141         uint8 _decimalUnits,
142         string _tokenSymbol,
143         bool _transfersEnabled
144     ) public {
145         tokenFactory = MiniMeTokenFactory(_tokenFactory);
146         name = _tokenName;                                 // Set the name
147         decimals = _decimalUnits;                          // Set the decimals
148         symbol = _tokenSymbol;                             // Set the symbol
149         parentToken = MiniMeToken(_parentToken);
150         parentSnapShotBlock = _parentSnapShotBlock;
151         transfersEnabled = _transfersEnabled;
152         creationBlock = block.number;
153     }
154 
155 
156 ///////////////////
157 // ERC20 Methods
158 ///////////////////
159 
160     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
161     /// @param _to The address of the recipient
162     /// @param _amount The amount of tokens to be transferred
163     /// @return Whether the transfer was successful or not
164     function transfer(address _to, uint256 _amount) public returns (bool success) {
165         require(transfersEnabled);
166         doTransfer(msg.sender, _to, _amount);
167         return true;
168     }
169 
170     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
171     ///  is approved by `_from`
172     /// @param _from The address holding the tokens being transferred
173     /// @param _to The address of the recipient
174     /// @param _amount The amount of tokens to be transferred
175     /// @return True if the transfer was successful
176     function transferFrom(address _from, address _to, uint256 _amount
177     ) public returns (bool success) {
178 
179         // The controller of this contract can move tokens around at will,
180         //  this is important to recognize! Confirm that you trust the
181         //  controller of this contract, which in most situations should be
182         //  another open source smart contract or 0x0
183         if (msg.sender != controller) {
184             require(transfersEnabled);
185 
186             // The standard ERC 20 transferFrom functionality
187             require(allowed[_from][msg.sender] >= _amount);
188             allowed[_from][msg.sender] -= _amount;
189         }
190         doTransfer(_from, _to, _amount);
191         return true;
192     }
193 
194     /// @dev This is the actual transfer function in the token contract, it can
195     ///  only be called by other functions in this contract.
196     /// @param _from The address holding the tokens being transferred
197     /// @param _to The address of the recipient
198     /// @param _amount The amount of tokens to be transferred
199     /// @return True if the transfer was successful
200     function doTransfer(address _from, address _to, uint _amount
201     ) internal {
202 
203            if (_amount == 0) {
204                Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
205                return;
206            }
207 
208            require(parentSnapShotBlock < block.number);
209 
210            // Do not allow transfer to 0x0 or the token contract itself
211            require((_to != 0) && (_to != address(this)));
212 
213            // If the amount being transfered is more than the balance of the
214            //  account the transfer throws
215            var previousBalanceFrom = balanceOfAt(_from, block.number);
216 
217            require(previousBalanceFrom >= _amount);
218 
219            // Alerts the token controller of the transfer
220            if (isContract(controller)) {
221                require(TokenController(controller).onTransfer(_from, _to, _amount));
222            }
223 
224            // First update the balance array with the new value for the address
225            //  sending the tokens
226            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
227 
228            // Then update the balance array with the new value for the address
229            //  receiving the tokens
230            var previousBalanceTo = balanceOfAt(_to, block.number);
231            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
232            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
233 
234            // An event to make the transfer easy to find on the blockchain
235            Transfer(_from, _to, _amount);
236 
237     }
238 
239     /// @param _owner The address that's balance is being requested
240     /// @return The balance of `_owner` at the current block
241     function balanceOf(address _owner) public constant returns (uint256 balance) {
242         return balanceOfAt(_owner, block.number);
243     }
244 
245     /** @notice `msg.sender` approves `_spender` to spend `_amount` tokens on its behalf.
246       * This is a ERC20 compliant version.
247       * @param _spender The address of the account able to transfer the tokens
248       * @param _amount The amount of tokens to be approved for transfer
249       * @return True if the approval was successful
250       */
251     function approve(address _spender, uint256 _amount) public returns (bool success) {
252         require(transfersEnabled);
253         // Alerts the token controller of the approve function call
254         if (isContract(controller)) {
255             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
256         }
257     }
258 
259     /// @dev This function makes it easy to read the `allowed[]` map
260     /// @param _owner The address of the account that owns the token
261     /// @param _spender The address of the account able to transfer the tokens
262     /// @return Amount of remaining tokens of _owner that _spender is allowed
263     ///  to spend
264     function allowance(address _owner, address _spender
265     ) public constant returns (uint256 remaining) {
266         return allowed[_owner][_spender];
267     }
268 
269     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
270     ///  its behalf, and then a function is triggered in the contract that is
271     ///  being approved, `_spender`. This allows users to use their tokens to
272     ///  interact with contracts in one function call instead of two
273     /// @param _spender The address of the contract able to transfer the tokens
274     /// @param _amount The amount of tokens to be approved for transfer
275     /// @return True if the function call was successful
276     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
277     ) public returns (bool success) {
278         require(approve(_spender, _amount));
279 
280         ApproveAndCallFallBack(_spender).receiveApproval(
281             msg.sender,
282             _amount,
283             this,
284             _extraData
285         );
286 
287         return true;
288     }
289 
290     /// @dev This function makes it easy to get the total number of tokens
291     /// @return The total number of tokens
292     function totalSupply() public constant returns (uint) {
293         return totalSupplyAt(block.number);
294     }
295 
296 
297 ////////////////
298 // Query balance and totalSupply in History
299 ////////////////
300 
301     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
302     /// @param _owner The address from which the balance will be retrieved
303     /// @param _blockNumber The block number when the balance is queried
304     /// @return The balance at `_blockNumber`
305     function balanceOfAt(address _owner, uint _blockNumber) public constant
306         returns (uint) {
307 
308         // These next few lines are used when the balance of the token is
309         //  requested before a check point was ever created for this token, it
310         //  requires that the `parentToken.balanceOfAt` be queried at the
311         //  genesis block for that token as this contains initial balance of
312         //  this token
313         if ((balances[_owner].length == 0)
314             || (balances[_owner][0].fromBlock > _blockNumber)) {
315             if (address(parentToken) != 0) {
316                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
317             } else {
318                 // Has no parent
319                 return 0;
320             }
321 
322         // This will return the expected balance during normal situations
323         } else {
324             return getValueAt(balances[_owner], _blockNumber);
325         }
326     }
327 
328     /// @notice Total amount of tokens at a specific `_blockNumber`.
329     /// @param _blockNumber The block number when the totalSupply is queried
330     /// @return The total amount of tokens at `_blockNumber`
331     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
332 
333         // These next few lines are used when the totalSupply of the token is
334         //  requested before a check point was ever created for this token, it
335         //  requires that the `parentToken.totalSupplyAt` be queried at the
336         //  genesis block for this token as that contains totalSupply of this
337         //  token at this block number.
338         if ((totalSupplyHistory.length == 0)
339             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
340             if (address(parentToken) != 0) {
341                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
342             } else {
343                 return 0;
344             }
345 
346         // This will return the expected totalSupply during normal situations
347         } else {
348             return getValueAt(totalSupplyHistory, _blockNumber);
349         }
350     }
351 
352 ////////////////
353 // Clone Token Method
354 ////////////////
355 
356     /// @notice Creates a new clone token with the initial distribution being
357     ///  this token at `_snapshotBlock`
358     /// @param _cloneTokenName Name of the clone token
359     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
360     /// @param _cloneTokenSymbol Symbol of the clone token
361     /// @param _snapshotBlock Block when the distribution of the parent token is
362     ///  copied to set the initial distribution of the new clone token;
363     ///  if the block is zero than the actual block, the current block is used
364     /// @param _transfersEnabled True if transfers are allowed in the clone
365     /// @return The address of the new MiniMeToken Contract
366     function createCloneToken(
367         string _cloneTokenName,
368         uint8 _cloneDecimalUnits,
369         string _cloneTokenSymbol,
370         uint _snapshotBlock,
371         bool _transfersEnabled
372         ) public returns(address) {
373         if (_snapshotBlock == 0) _snapshotBlock = block.number;
374         MiniMeToken cloneToken = tokenFactory.createCloneToken(
375             this,
376             _snapshotBlock,
377             _cloneTokenName,
378             _cloneDecimalUnits,
379             _cloneTokenSymbol,
380             _transfersEnabled
381             );
382 
383         cloneToken.changeController(msg.sender);
384 
385         // An event to make the token easy to find on the blockchain
386         NewCloneToken(address(cloneToken), _snapshotBlock);
387         return address(cloneToken);
388     }
389 
390 ////////////////
391 // Generate and destroy tokens
392 ////////////////
393 
394     /// @notice Generates `_amount` tokens that are assigned to `_owner`
395     /// @param _owner The address that will be assigned the new tokens
396     /// @param _amount The quantity of tokens generated
397     /// @return True if the tokens are generated correctly
398     function generateTokens(address _owner, uint _amount
399     ) public onlyController returns (bool) {
400         uint curTotalSupply = totalSupply();
401         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
402         uint previousBalanceTo = balanceOf(_owner);
403         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
404         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
405         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
406         Transfer(0, _owner, _amount);
407         return true;
408     }
409 
410 
411     /// @notice Burns `_amount` tokens from `_owner`
412     /// @param _owner The address that will lose the tokens
413     /// @param _amount The quantity of tokens to burn
414     /// @return True if the tokens are burned correctly
415     function destroyTokens(address _owner, uint _amount
416     ) onlyController public returns (bool) {
417         uint curTotalSupply = totalSupply();
418         require(curTotalSupply >= _amount);
419         uint previousBalanceFrom = balanceOf(_owner);
420         require(previousBalanceFrom >= _amount);
421         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
422         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
423         Transfer(_owner, 0, _amount);
424         return true;
425     }
426 
427 ////////////////
428 // Enable tokens transfers
429 ////////////////
430 
431 
432     /// @notice Enables token holders to transfer their tokens freely if true
433     /// @param _transfersEnabled True if transfers are allowed in the clone
434     function enableTransfers(bool _transfersEnabled) public onlyController {
435         transfersEnabled = _transfersEnabled;
436     }
437 
438 ////////////////
439 // Internal helper functions to query and set a value in a snapshot array
440 ////////////////
441 
442     /// @dev `getValueAt` retrieves the number of tokens at a given block number
443     /// @param checkpoints The history of values being queried
444     /// @param _block The block number to retrieve the value at
445     /// @return The number of tokens being queried
446     function getValueAt(Checkpoint[] storage checkpoints, uint _block
447     ) constant internal returns (uint) {
448         if (checkpoints.length == 0) return 0;
449 
450         // Shortcut for the actual value
451         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
452             return checkpoints[checkpoints.length-1].value;
453         if (_block < checkpoints[0].fromBlock) return 0;
454 
455         // Binary search of the value in the array
456         uint min = 0;
457         uint max = checkpoints.length-1;
458         while (max > min) {
459             uint mid = (max + min + 1)/ 2;
460             if (checkpoints[mid].fromBlock<=_block) {
461                 min = mid;
462             } else {
463                 max = mid-1;
464             }
465         }
466         return checkpoints[min].value;
467     }
468 
469     /// @dev `updateValueAtNow` used to update the `balances` map and the
470     ///  `totalSupplyHistory`
471     /// @param checkpoints The history of data being updated
472     /// @param _value The new number of tokens
473     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
474     ) internal  {
475         if ((checkpoints.length == 0)
476         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
477                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
478                newCheckPoint.fromBlock =  uint128(block.number);
479                newCheckPoint.value = uint128(_value);
480            } else {
481                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
482                oldCheckPoint.value = uint128(_value);
483            }
484     }
485 
486     /// @dev Internal function to determine if an address is a contract
487     /// @param _addr The address being queried
488     /// @return True if `_addr` is a contract
489     function isContract(address _addr) constant internal returns(bool) {
490         uint size;
491         if (_addr == 0) return false;
492         assembly {
493             size := extcodesize(_addr)
494         }
495         return size>0;
496     }
497 
498     /// @dev Helper function to return a min betwen the two uints
499     function min(uint a, uint b) pure internal returns (uint) {
500         return a < b ? a : b;
501     }
502 
503     /// @notice The fallback function: If the contract's controller has not been
504     ///  set to 0, then the `proxyPayment` method is called which relays the
505     ///  ether and creates tokens as described in the token controller contract
506     function () public payable {
507         require(isContract(controller));
508         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
509     }
510 
511 //////////
512 // Safety Methods
513 //////////
514 
515     /// @notice This method can be used by the controller to extract mistakenly
516     ///  sent tokens to this contract.
517     /// @param _token The address of the token contract that you want to recover
518     ///  set to 0 in case you want to extract ether.
519     function claimTokens(address _token) public onlyController {
520         if (_token == 0x0) {
521             controller.transfer(this.balance);
522             return;
523         }
524 
525         MiniMeToken token = MiniMeToken(_token);
526         uint balance = token.balanceOf(this);
527         token.transfer(controller, balance);
528         ClaimedTokens(_token, controller, balance);
529     }
530 
531 ////////////////
532 // Events
533 ////////////////
534     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
535     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
536     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
537     event Approval(
538         address indexed _owner,
539         address indexed _spender,
540         uint256 _amount
541         );
542 
543 }
544 
545 
546 ////////////////
547 // MiniMeTokenFactory
548 ////////////////
549 
550 /// @dev This contract is used to generate clone contracts from a contract.
551 ///  In solidity this is the way to create a contract from a contract of the
552 ///  same class
553 contract MiniMeTokenFactory {
554 
555     /// @notice Update the DApp by creating a new token with new functionalities
556     ///  the msg.sender becomes the controller of this clone token
557     /// @param _parentToken Address of the token being cloned
558     /// @param _snapshotBlock Block of the parent token that will
559     ///  determine the initial distribution of the clone token
560     /// @param _tokenName Name of the new token
561     /// @param _decimalUnits Number of decimals of the new token
562     /// @param _tokenSymbol Token Symbol for the new token
563     /// @param _transfersEnabled If true, tokens will be able to be transferred
564     /// @return The address of the new token contract
565     function createCloneToken(
566         address _parentToken,
567         uint _snapshotBlock,
568         string _tokenName,
569         uint8 _decimalUnits,
570         string _tokenSymbol,
571         bool _transfersEnabled
572     ) public returns (MiniMeToken) {
573         MiniMeToken newToken = new MiniMeToken(
574             this,
575             _parentToken,
576             _snapshotBlock,
577             _tokenName,
578             _decimalUnits,
579             _tokenSymbol,
580             _transfersEnabled
581             );
582 
583         newToken.changeController(msg.sender);
584         return newToken;
585     }
586 }