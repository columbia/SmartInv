1 pragma solidity ^0.4.18;
2 
3 contract Controlled {
4     /// @notice The address of the controller is the only address that can call
5     ///  a function with this modifier
6     modifier onlyController { require(msg.sender == controller); _; }
7 
8     address public controller;
9 
10     function Controlled() public { controller = msg.sender;}
11 
12     /// @notice Changes the controller of the contract
13     /// @param _newController The new controller of the contract
14     function changeController(address _newController) public onlyController {
15         controller = _newController;
16     }
17 }
18 
19 pragma solidity ^0.4.18;
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
46 pragma solidity ^0.4.18;
47 
48 /*
49     Copyright 2016, Jordi Baylina
50 
51     This program is free software: you can redistribute it and/or modify
52     it under the terms of the GNU General Public License as published by
53     the Free Software Foundation, either version 3 of the License, or
54     (at your option) any later version.
55 
56     This program is distributed in the hope that it will be useful,
57     but WITHOUT ANY WARRANTY; without even the implied warranty of
58     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
59     GNU General Public License for more details.
60 
61     You should have received a copy of the GNU General Public License
62     along with this program.  If not, see <http://www.gnu.org/licenses/>.
63  */
64 
65 /// @title MiniMeToken Contract
66 /// @author Jordi Baylina
67 /// @dev This token contract's goal is to make it easy for anyone to clone this
68 ///  token using the token distribution at a given block, this will allow DAO's
69 ///  and DApps to upgrade their features in a decentralized manner without
70 ///  affecting the original token
71 /// @dev It is ERC20 compliant, but still needs to under go further testing.
72 
73 // import "./Controlled.sol";
74 // import "./TokenController.sol";
75 
76 contract ApproveAndCallFallBack {
77     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
78 }
79 
80 /// @dev The actual token contract, the default controller is the msg.sender
81 ///  that deploys the contract, so usually this token will be deployed by a
82 ///  token controller contract, which Giveth will call a "Campaign"
83 contract MiniMeToken is Controlled {
84 
85     string public name;                //The Token's name: e.g. DigixDAO Tokens
86     uint8 public decimals;             //Number of decimals of the smallest unit
87     string public symbol;              //An identifier: e.g. REP
88     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
89 
90 
91     /// @dev `Checkpoint` is the structure that attaches a block number to a
92     ///  given value, the block number attached is the one that last changed the
93     ///  value
94     struct  Checkpoint {
95 
96         // `fromBlock` is the block number that the value was generated from
97         uint128 fromBlock;
98 
99         // `value` is the amount of tokens at a specific block number
100         uint128 value;
101     }
102 
103     // `parentToken` is the Token address that was cloned to produce this token;
104     //  it will be 0x0 for a token that was not cloned
105     MiniMeToken public parentToken;
106 
107     // `parentSnapShotBlock` is the block number from the Parent Token that was
108     //  used to determine the initial distribution of the Clone Token
109     uint public parentSnapShotBlock;
110 
111     // `creationBlock` is the block number that the Clone Token was created
112     uint public creationBlock;
113 
114     // `balances` is the map that tracks the balance of each address, in this
115     //  contract when the balance changes the block number that the change
116     //  occurred is also included in the map
117     mapping (address => Checkpoint[]) balances;
118 
119     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
120     mapping (address => mapping (address => uint256)) allowed;
121 
122     // Tracks the history of the `totalSupply` of the token
123     Checkpoint[] totalSupplyHistory;
124 
125     // Flag that determines if the token is transferable or not.
126     bool public transfersEnabled;
127 
128     // The factory used to create new clone tokens
129     MiniMeTokenFactory public tokenFactory;
130 
131 ////////////////
132 // Constructor
133 ////////////////
134 
135     /// @notice Constructor to create a MiniMeToken
136     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
137     ///  will create the Clone token contracts, the token factory needs to be
138     ///  deployed first
139     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
140     ///  new token
141     /// @param _parentSnapShotBlock Block of the parent token that will
142     ///  determine the initial distribution of the clone token, set to 0 if it
143     ///  is a new token
144     /// @param _tokenName Name of the new token
145     /// @param _decimalUnits Number of decimals of the new token
146     /// @param _tokenSymbol Token Symbol for the new token
147     /// @param _transfersEnabled If true, tokens will be able to be transferred
148     function MiniMeToken(
149         address _tokenFactory,
150         address _parentToken,
151         uint _parentSnapShotBlock,
152         string _tokenName,
153         uint8 _decimalUnits,
154         string _tokenSymbol,
155         bool _transfersEnabled
156     ) public {
157         tokenFactory = MiniMeTokenFactory(_tokenFactory);
158         name = _tokenName;                                 // Set the name
159         decimals = _decimalUnits;                          // Set the decimals
160         symbol = _tokenSymbol;                             // Set the symbol
161         parentToken = MiniMeToken(_parentToken);
162         parentSnapShotBlock = _parentSnapShotBlock;
163         transfersEnabled = _transfersEnabled;
164         creationBlock = block.number;
165     }
166 
167 
168 ///////////////////
169 // ERC20 Methods
170 ///////////////////
171 
172     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
173     /// @param _to The address of the recipient
174     /// @param _amount The amount of tokens to be transferred
175     /// @return Whether the transfer was successful or not
176     function transfer(address _to, uint256 _amount) public returns (bool success) {
177         require(transfersEnabled);
178         doTransfer(msg.sender, _to, _amount);
179         return true;
180     }
181 
182     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
183     ///  is approved by `_from`
184     /// @param _from The address holding the tokens being transferred
185     /// @param _to The address of the recipient
186     /// @param _amount The amount of tokens to be transferred
187     /// @return True if the transfer was successful
188     function transferFrom(address _from, address _to, uint256 _amount
189     ) public returns (bool success) {
190 
191         // The controller of this contract can move tokens around at will,
192         //  this is important to recognize! Confirm that you trust the
193         //  controller of this contract, which in most situations should be
194         //  another open source smart contract or 0x0
195         if (msg.sender != controller) {
196             require(transfersEnabled);
197 
198             // The standard ERC 20 transferFrom functionality
199             require(allowed[_from][msg.sender] >= _amount);
200             allowed[_from][msg.sender] -= _amount;
201         }
202         doTransfer(_from, _to, _amount);
203         return true;
204     }
205 
206     /// @dev This is the actual transfer function in the token contract, it can
207     ///  only be called by other functions in this contract.
208     /// @param _from The address holding the tokens being transferred
209     /// @param _to The address of the recipient
210     /// @param _amount The amount of tokens to be transferred
211     /// @return True if the transfer was successful
212     function doTransfer(address _from, address _to, uint _amount
213     ) internal {
214 
215            if (_amount == 0) {
216                Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
217                return;
218            }
219 
220            require(parentSnapShotBlock < block.number);
221 
222            // Do not allow transfer to 0x0 or the token contract itself
223            require((_to != 0) && (_to != address(this)));
224 
225            // If the amount being transfered is more than the balance of the
226            //  account the transfer throws
227            var previousBalanceFrom = balanceOfAt(_from, block.number);
228 
229            require(previousBalanceFrom >= _amount);
230 
231            // Alerts the token controller of the transfer
232            if (isContract(controller)) {
233                require(TokenController(controller).onTransfer(_from, _to, _amount));
234            }
235 
236            // First update the balance array with the new value for the address
237            //  sending the tokens
238            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
239 
240            // Then update the balance array with the new value for the address
241            //  receiving the tokens
242            var previousBalanceTo = balanceOfAt(_to, block.number);
243            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
244            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
245 
246            // An event to make the transfer easy to find on the blockchain
247            Transfer(_from, _to, _amount);
248 
249     }
250 
251     /// @param _owner The address that's balance is being requested
252     /// @return The balance of `_owner` at the current block
253     function balanceOf(address _owner) public constant returns (uint256 balance) {
254         return balanceOfAt(_owner, block.number);
255     }
256 
257     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
258     ///  its behalf. This is a modified version of the ERC20 approve function
259     ///  to be a little bit safer
260     /// @param _spender The address of the account able to transfer the tokens
261     /// @param _amount The amount of tokens to be approved for transfer
262     /// @return True if the approval was successful
263     function approve(address _spender, uint256 _amount) public returns (bool success) {
264         require(transfersEnabled);
265 
266         // To change the approve amount you first have to reduce the addresses`
267         //  allowance to zero by calling `approve(_spender,0)` if it is not
268         //  already 0 to mitigate the race condition described here:
269         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
270         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
271 
272         // Alerts the token controller of the approve function call
273         if (isContract(controller)) {
274             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
275         }
276 
277         allowed[msg.sender][_spender] = _amount;
278         Approval(msg.sender, _spender, _amount);
279         return true;
280     }
281 
282     /// @dev This function makes it easy to read the `allowed[]` map
283     /// @param _owner The address of the account that owns the token
284     /// @param _spender The address of the account able to transfer the tokens
285     /// @return Amount of remaining tokens of _owner that _spender is allowed
286     ///  to spend
287     function allowance(address _owner, address _spender
288     ) public constant returns (uint256 remaining) {
289         return allowed[_owner][_spender];
290     }
291 
292     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
293     ///  its behalf, and then a function is triggered in the contract that is
294     ///  being approved, `_spender`. This allows users to use their tokens to
295     ///  interact with contracts in one function call instead of two
296     /// @param _spender The address of the contract able to transfer the tokens
297     /// @param _amount The amount of tokens to be approved for transfer
298     /// @return True if the function call was successful
299     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
300     ) public returns (bool success) {
301         require(approve(_spender, _amount));
302 
303         ApproveAndCallFallBack(_spender).receiveApproval(
304             msg.sender,
305             _amount,
306             this,
307             _extraData
308         );
309 
310         return true;
311     }
312 
313     /// @dev This function makes it easy to get the total number of tokens
314     /// @return The total number of tokens
315     function totalSupply() public constant returns (uint) {
316         return totalSupplyAt(block.number);
317     }
318 
319 
320 ////////////////
321 // Query balance and totalSupply in History
322 ////////////////
323 
324     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
325     /// @param _owner The address from which the balance will be retrieved
326     /// @param _blockNumber The block number when the balance is queried
327     /// @return The balance at `_blockNumber`
328     function balanceOfAt(address _owner, uint _blockNumber) public constant
329         returns (uint) {
330 
331         // These next few lines are used when the balance of the token is
332         //  requested before a check point was ever created for this token, it
333         //  requires that the `parentToken.balanceOfAt` be queried at the
334         //  genesis block for that token as this contains initial balance of
335         //  this token
336         if ((balances[_owner].length == 0)
337             || (balances[_owner][0].fromBlock > _blockNumber)) {
338             if (address(parentToken) != 0) {
339                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
340             } else {
341                 // Has no parent
342                 return 0;
343             }
344 
345         // This will return the expected balance during normal situations
346         } else {
347             return getValueAt(balances[_owner], _blockNumber);
348         }
349     }
350 
351     /// @notice Total amount of tokens at a specific `_blockNumber`.
352     /// @param _blockNumber The block number when the totalSupply is queried
353     /// @return The total amount of tokens at `_blockNumber`
354     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
355 
356         // These next few lines are used when the totalSupply of the token is
357         //  requested before a check point was ever created for this token, it
358         //  requires that the `parentToken.totalSupplyAt` be queried at the
359         //  genesis block for this token as that contains totalSupply of this
360         //  token at this block number.
361         if ((totalSupplyHistory.length == 0)
362             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
363             if (address(parentToken) != 0) {
364                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
365             } else {
366                 return 0;
367             }
368 
369         // This will return the expected totalSupply during normal situations
370         } else {
371             return getValueAt(totalSupplyHistory, _blockNumber);
372         }
373     }
374 
375 ////////////////
376 // Clone Token Method
377 ////////////////
378 
379     /// @notice Creates a new clone token with the initial distribution being
380     ///  this token at `_snapshotBlock`
381     /// @param _cloneTokenName Name of the clone token
382     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
383     /// @param _cloneTokenSymbol Symbol of the clone token
384     /// @param _snapshotBlock Block when the distribution of the parent token is
385     ///  copied to set the initial distribution of the new clone token;
386     ///  if the block is zero than the actual block, the current block is used
387     /// @param _transfersEnabled True if transfers are allowed in the clone
388     /// @return The address of the new MiniMeToken Contract
389     function createCloneToken(
390         string _cloneTokenName,
391         uint8 _cloneDecimalUnits,
392         string _cloneTokenSymbol,
393         uint _snapshotBlock,
394         bool _transfersEnabled
395         ) public returns(address) {
396         if (_snapshotBlock == 0) _snapshotBlock = block.number;
397         MiniMeToken cloneToken = tokenFactory.createCloneToken(
398             this,
399             _snapshotBlock,
400             _cloneTokenName,
401             _cloneDecimalUnits,
402             _cloneTokenSymbol,
403             _transfersEnabled
404             );
405 
406         cloneToken.changeController(msg.sender);
407 
408         // An event to make the token easy to find on the blockchain
409         NewCloneToken(address(cloneToken), _snapshotBlock);
410         return address(cloneToken);
411     }
412 
413 ////////////////
414 // Generate and destroy tokens
415 ////////////////
416 
417     /// @notice Generates `_amount` tokens that are assigned to `_owner`
418     /// @param _owner The address that will be assigned the new tokens
419     /// @param _amount The quantity of tokens generated
420     /// @return True if the tokens are generated correctly
421     function generateTokens(address _owner, uint _amount
422     ) public onlyController returns (bool) {
423         uint curTotalSupply = totalSupply();
424         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
425         uint previousBalanceTo = balanceOf(_owner);
426         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
427         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
428         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
429         Transfer(0, _owner, _amount);
430         return true;
431     }
432 
433 
434     /// @notice Burns `_amount` tokens from `_owner`
435     /// @param _owner The address that will lose the tokens
436     /// @param _amount The quantity of tokens to burn
437     /// @return True if the tokens are burned correctly
438     function destroyTokens(address _owner, uint _amount
439     ) onlyController public returns (bool) {
440         uint curTotalSupply = totalSupply();
441         require(curTotalSupply >= _amount);
442         uint previousBalanceFrom = balanceOf(_owner);
443         require(previousBalanceFrom >= _amount);
444         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
445         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
446         Transfer(_owner, 0, _amount);
447         return true;
448     }
449 
450 ////////////////
451 // Enable tokens transfers
452 ////////////////
453 
454 
455     /// @notice Enables token holders to transfer their tokens freely if true
456     /// @param _transfersEnabled True if transfers are allowed in the clone
457     function enableTransfers(bool _transfersEnabled) public onlyController {
458         transfersEnabled = _transfersEnabled;
459     }
460 
461 ////////////////
462 // Internal helper functions to query and set a value in a snapshot array
463 ////////////////
464 
465     /// @dev `getValueAt` retrieves the number of tokens at a given block number
466     /// @param checkpoints The history of values being queried
467     /// @param _block The block number to retrieve the value at
468     /// @return The number of tokens being queried
469     function getValueAt(Checkpoint[] storage checkpoints, uint _block
470     ) constant internal returns (uint) {
471         if (checkpoints.length == 0) return 0;
472 
473         // Shortcut for the actual value
474         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
475             return checkpoints[checkpoints.length-1].value;
476         if (_block < checkpoints[0].fromBlock) return 0;
477 
478         // Binary search of the value in the array
479         uint min = 0;
480         uint max = checkpoints.length-1;
481         while (max > min) {
482             uint mid = (max + min + 1)/ 2;
483             if (checkpoints[mid].fromBlock<=_block) {
484                 min = mid;
485             } else {
486                 max = mid-1;
487             }
488         }
489         return checkpoints[min].value;
490     }
491 
492     /// @dev `updateValueAtNow` used to update the `balances` map and the
493     ///  `totalSupplyHistory`
494     /// @param checkpoints The history of data being updated
495     /// @param _value The new number of tokens
496     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
497     ) internal  {
498         if ((checkpoints.length == 0)
499         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
500                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
501                newCheckPoint.fromBlock =  uint128(block.number);
502                newCheckPoint.value = uint128(_value);
503            } else {
504                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
505                oldCheckPoint.value = uint128(_value);
506            }
507     }
508 
509     /// @dev Internal function to determine if an address is a contract
510     /// @param _addr The address being queried
511     /// @return True if `_addr` is a contract
512     function isContract(address _addr) constant internal returns(bool) {
513         uint size;
514         if (_addr == 0) return false;
515         assembly {
516             size := extcodesize(_addr)
517         }
518         return size>0;
519     }
520 
521     /// @dev Helper function to return a min betwen the two uints
522     function min(uint a, uint b) pure internal returns (uint) {
523         return a < b ? a : b;
524     }
525 
526     /// @notice The fallback function: If the contract's controller has not been
527     ///  set to 0, then the `proxyPayment` method is called which relays the
528     ///  ether and creates tokens as described in the token controller contract
529     function () public payable {
530         require(isContract(controller));
531         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
532     }
533 
534 //////////
535 // Safety Methods
536 //////////
537 
538     /// @notice This method can be used by the controller to extract mistakenly
539     ///  sent tokens to this contract.
540     /// @param _token The address of the token contract that you want to recover
541     ///  set to 0 in case you want to extract ether.
542     function claimTokens(address _token) public onlyController {
543         if (_token == 0x0) {
544             controller.transfer(this.balance);
545             return;
546         }
547 
548         MiniMeToken token = MiniMeToken(_token);
549         uint balance = token.balanceOf(this);
550         token.transfer(controller, balance);
551         ClaimedTokens(_token, controller, balance);
552     }
553 
554 ////////////////
555 // Events
556 ////////////////
557     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
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
595     ) public returns (MiniMeToken) {
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