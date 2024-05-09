1 pragma solidity ^0.4.18;
2 
3 /*
4     Copyright 2016, Jordi Baylina.
5     Slight modification by Clément Lesaege.
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
30 contract ApproveAndCallFallBack {
31     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
32 }
33 
34 /// @dev The token controller contract must implement these functions
35 contract TokenController {
36     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
37     /// @param _owner The address that sent the ether to create tokens
38     /// @return True if the ether is accepted, false if it throws
39     function proxyPayment(address _owner) public payable returns(bool);
40 
41     /// @notice Notifies the controller about a token transfer allowing the
42     ///  controller to react if desired
43     /// @param _from The origin of the transfer
44     /// @param _to The destination of the transfer
45     /// @param _amount The amount of the transfer
46     /// @return False if the controller does not authorize the transfer
47     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
48 
49     /// @notice Notifies the controller about an approval allowing the
50     ///  controller to react if desired
51     /// @param _owner The address that calls `approve()`
52     /// @param _spender The spender in the `approve()` call
53     /// @param _amount The amount in the `approve()` call
54     /// @return False if the controller does not authorize the approval
55     function onApprove(address _owner, address _spender, uint _amount) public
56         returns(bool);
57 }
58 
59 contract Controlled {
60     /// @notice The address of the controller is the only address that can call
61     ///  a function with this modifier
62     modifier onlyController { require(msg.sender == controller); _; }
63 
64     address public controller;
65 
66     function Controlled() public { controller = msg.sender;}
67 
68     /// @notice Changes the controller of the contract
69     /// @param _newController The new controller of the contract
70     function changeController(address _newController) public onlyController {
71         controller = _newController;
72     }
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
83     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
84 
85 
86     /// @dev `Checkpoint` is the structure that attaches a block number to a
87     ///  given value, the block number attached is the one that last changed the
88     ///  value
89     struct  Checkpoint {
90 
91         // `fromBlock` is the block number that the value was generated from
92         uint128 fromBlock;
93 
94         // `value` is the amount of tokens at a specific block number
95         uint128 value;
96     }
97 
98     // `parentToken` is the Token address that was cloned to produce this token;
99     //  it will be 0x0 for a token that was not cloned
100     MiniMeToken public parentToken;
101 
102     // `parentSnapShotBlock` is the block number from the Parent Token that was
103     //  used to determine the initial distribution of the Clone Token
104     uint public parentSnapShotBlock;
105 
106     // `creationBlock` is the block number that the Clone Token was created
107     uint public creationBlock;
108 
109     // `balances` is the map that tracks the balance of each address, in this
110     //  contract when the balance changes the block number that the change
111     //  occurred is also included in the map
112     mapping (address => Checkpoint[]) balances;
113 
114     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
115     mapping (address => mapping (address => uint256)) allowed;
116 
117     // Tracks the history of the `totalSupply` of the token
118     Checkpoint[] totalSupplyHistory;
119 
120     // Flag that determines if the token is transferable or not.
121     bool public transfersEnabled;
122 
123     // The factory used to create new clone tokens
124     MiniMeTokenFactory public tokenFactory;
125 
126 ////////////////
127 // Constructor
128 ////////////////
129 
130     /// @notice Constructor to create a MiniMeToken
131     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
132     ///  will create the Clone token contracts, the token factory needs to be
133     ///  deployed first
134     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
135     ///  new token
136     /// @param _parentSnapShotBlock Block of the parent token that will
137     ///  determine the initial distribution of the clone token, set to 0 if it
138     ///  is a new token
139     /// @param _tokenName Name of the new token
140     /// @param _decimalUnits Number of decimals of the new token
141     /// @param _tokenSymbol Token Symbol for the new token
142     /// @param _transfersEnabled If true, tokens will be able to be transferred
143     function MiniMeToken(
144         address _tokenFactory,
145         address _parentToken,
146         uint _parentSnapShotBlock,
147         string _tokenName,
148         uint8 _decimalUnits,
149         string _tokenSymbol,
150         bool _transfersEnabled
151     ) public {
152         tokenFactory = MiniMeTokenFactory(_tokenFactory);
153         name = _tokenName;                                 // Set the name
154         decimals = _decimalUnits;                          // Set the decimals
155         symbol = _tokenSymbol;                             // Set the symbol
156         parentToken = MiniMeToken(_parentToken);
157         parentSnapShotBlock = _parentSnapShotBlock;
158         transfersEnabled = _transfersEnabled;
159         creationBlock = block.number;
160     }
161 
162 
163 ///////////////////
164 // ERC20 Methods
165 ///////////////////
166 
167     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
168     /// @param _to The address of the recipient
169     /// @param _amount The amount of tokens to be transferred
170     /// @return Whether the transfer was successful or not
171     function transfer(address _to, uint256 _amount) public returns (bool success) {
172         require(transfersEnabled);
173         doTransfer(msg.sender, _to, _amount);
174         return true;
175     }
176 
177     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
178     ///  is approved by `_from`
179     /// @param _from The address holding the tokens being transferred
180     /// @param _to The address of the recipient
181     /// @param _amount The amount of tokens to be transferred
182     /// @return True if the transfer was successful
183     function transferFrom(address _from, address _to, uint256 _amount
184     ) public returns (bool success) {
185 
186         // The controller of this contract can move tokens around at will,
187         //  this is important to recognize! Confirm that you trust the
188         //  controller of this contract, which in most situations should be
189         //  another open source smart contract or 0x0
190         if (msg.sender != controller) {
191             require(transfersEnabled);
192 
193             // The standard ERC 20 transferFrom functionality
194             require(allowed[_from][msg.sender] >= _amount);
195             allowed[_from][msg.sender] -= _amount;
196         }
197         doTransfer(_from, _to, _amount);
198         return true;
199     }
200 
201     /// @dev This is the actual transfer function in the token contract, it can
202     ///  only be called by other functions in this contract.
203     /// @param _from The address holding the tokens being transferred
204     /// @param _to The address of the recipient
205     /// @param _amount The amount of tokens to be transferred
206     /// @return True if the transfer was successful
207     function doTransfer(address _from, address _to, uint _amount
208     ) internal {
209 
210            if (_amount == 0) {
211                Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
212                return;
213            }
214 
215            require(parentSnapShotBlock < block.number);
216 
217            // Do not allow transfer to 0x0 or the token contract itself
218            require((_to != 0) && (_to != address(this)));
219 
220            // If the amount being transfered is more than the balance of the
221            //  account the transfer throws
222            var previousBalanceFrom = balanceOfAt(_from, block.number);
223 
224            require(previousBalanceFrom >= _amount);
225 
226            // Alerts the token controller of the transfer
227            if (isContract(controller)) {
228                require(TokenController(controller).onTransfer(_from, _to, _amount));
229            }
230 
231            // First update the balance array with the new value for the address
232            //  sending the tokens
233            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
234 
235            // Then update the balance array with the new value for the address
236            //  receiving the tokens
237            var previousBalanceTo = balanceOfAt(_to, block.number);
238            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
239            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
240 
241            // An event to make the transfer easy to find on the blockchain
242            Transfer(_from, _to, _amount);
243 
244     }
245 
246     /// @param _owner The address that's balance is being requested
247     /// @return The balance of `_owner` at the current block
248     function balanceOf(address _owner) public constant returns (uint256 balance) {
249         return balanceOfAt(_owner, block.number);
250     }
251 
252     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
253     ///  its behalf. This is the standard version to allow backward compatibility.
254     /// @param _spender The address of the account able to transfer the tokens
255     /// @param _amount The amount of tokens to be approved for transfer
256     /// @return True if the approval was successful
257     function approve(address _spender, uint256 _amount) public returns (bool success) {
258         require(transfersEnabled);
259 
260         // Alerts the token controller of the approve function call
261         if (isContract(controller)) {
262             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
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
276     ) public constant returns (uint256 remaining) {
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
288     ) public returns (bool success) {
289         require(approve(_spender, _amount));
290 
291         ApproveAndCallFallBack(_spender).receiveApproval(
292             msg.sender,
293             _amount,
294             this,
295             _extraData
296         );
297 
298         return true;
299     }
300 
301     /// @dev This function makes it easy to get the total number of tokens
302     /// @return The total number of tokens
303     function totalSupply() public constant returns (uint) {
304         return totalSupplyAt(block.number);
305     }
306 
307 
308 ////////////////
309 // Query balance and totalSupply in History
310 ////////////////
311 
312     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
313     /// @param _owner The address from which the balance will be retrieved
314     /// @param _blockNumber The block number when the balance is queried
315     /// @return The balance at `_blockNumber`
316     function balanceOfAt(address _owner, uint _blockNumber) public constant
317         returns (uint) {
318 
319         // These next few lines are used when the balance of the token is
320         //  requested before a check point was ever created for this token, it
321         //  requires that the `parentToken.balanceOfAt` be queried at the
322         //  genesis block for that token as this contains initial balance of
323         //  this token
324         if ((balances[_owner].length == 0)
325             || (balances[_owner][0].fromBlock > _blockNumber)) {
326             if (address(parentToken) != 0) {
327                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
328             } else {
329                 // Has no parent
330                 return 0;
331             }
332 
333         // This will return the expected balance during normal situations
334         } else {
335             return getValueAt(balances[_owner], _blockNumber);
336         }
337     }
338 
339     /// @notice Total amount of tokens at a specific `_blockNumber`.
340     /// @param _blockNumber The block number when the totalSupply is queried
341     /// @return The total amount of tokens at `_blockNumber`
342     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
343 
344         // These next few lines are used when the totalSupply of the token is
345         //  requested before a check point was ever created for this token, it
346         //  requires that the `parentToken.totalSupplyAt` be queried at the
347         //  genesis block for this token as that contains totalSupply of this
348         //  token at this block number.
349         if ((totalSupplyHistory.length == 0)
350             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
351             if (address(parentToken) != 0) {
352                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
353             } else {
354                 return 0;
355             }
356 
357         // This will return the expected totalSupply during normal situations
358         } else {
359             return getValueAt(totalSupplyHistory, _blockNumber);
360         }
361     }
362 
363 ////////////////
364 // Clone Token Method
365 ////////////////
366 
367     /// @notice Creates a new clone token with the initial distribution being
368     ///  this token at `_snapshotBlock`
369     /// @param _cloneTokenName Name of the clone token
370     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
371     /// @param _cloneTokenSymbol Symbol of the clone token
372     /// @param _snapshotBlock Block when the distribution of the parent token is
373     ///  copied to set the initial distribution of the new clone token;
374     ///  if the block is zero than the actual block, the current block is used
375     /// @param _transfersEnabled True if transfers are allowed in the clone
376     /// @return The address of the new MiniMeToken Contract
377     function createCloneToken(
378         string _cloneTokenName,
379         uint8 _cloneDecimalUnits,
380         string _cloneTokenSymbol,
381         uint _snapshotBlock,
382         bool _transfersEnabled
383         ) public returns(address) {
384         if (_snapshotBlock == 0) _snapshotBlock = block.number;
385         MiniMeToken cloneToken = tokenFactory.createCloneToken(
386             this,
387             _snapshotBlock,
388             _cloneTokenName,
389             _cloneDecimalUnits,
390             _cloneTokenSymbol,
391             _transfersEnabled
392             );
393 
394         cloneToken.changeController(msg.sender);
395 
396         // An event to make the token easy to find on the blockchain
397         NewCloneToken(address(cloneToken), _snapshotBlock);
398         return address(cloneToken);
399     }
400 
401 ////////////////
402 // Generate and destroy tokens
403 ////////////////
404 
405     /// @notice Generates `_amount` tokens that are assigned to `_owner`
406     /// @param _owner The address that will be assigned the new tokens
407     /// @param _amount The quantity of tokens generated
408     /// @return True if the tokens are generated correctly
409     function generateTokens(address _owner, uint _amount
410     ) public onlyController returns (bool) {
411         uint curTotalSupply = totalSupply();
412         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
413         uint previousBalanceTo = balanceOf(_owner);
414         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
415         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
416         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
417         Transfer(0, _owner, _amount);
418         return true;
419     }
420 
421 
422     /// @notice Burns `_amount` tokens from `_owner`
423     /// @param _owner The address that will lose the tokens
424     /// @param _amount The quantity of tokens to burn
425     /// @return True if the tokens are burned correctly
426     function destroyTokens(address _owner, uint _amount
427     ) onlyController public returns (bool) {
428         uint curTotalSupply = totalSupply();
429         require(curTotalSupply >= _amount);
430         uint previousBalanceFrom = balanceOf(_owner);
431         require(previousBalanceFrom >= _amount);
432         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
433         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
434         Transfer(_owner, 0, _amount);
435         return true;
436     }
437 
438 ////////////////
439 // Enable tokens transfers
440 ////////////////
441 
442 
443     /// @notice Enables token holders to transfer their tokens freely if true
444     /// @param _transfersEnabled True if transfers are allowed in the clone
445     function enableTransfers(bool _transfersEnabled) public onlyController {
446         transfersEnabled = _transfersEnabled;
447     }
448 
449 ////////////////
450 // Internal helper functions to query and set a value in a snapshot array
451 ////////////////
452 
453     /// @dev `getValueAt` retrieves the number of tokens at a given block number
454     /// @param checkpoints The history of values being queried
455     /// @param _block The block number to retrieve the value at
456     /// @return The number of tokens being queried
457     function getValueAt(Checkpoint[] storage checkpoints, uint _block
458     ) constant internal returns (uint) {
459         if (checkpoints.length == 0) return 0;
460 
461         // Shortcut for the actual value
462         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
463             return checkpoints[checkpoints.length-1].value;
464         if (_block < checkpoints[0].fromBlock) return 0;
465 
466         // Binary search of the value in the array
467         uint min = 0;
468         uint max = checkpoints.length-1;
469         while (max > min) {
470             uint mid = (max + min + 1)/ 2;
471             if (checkpoints[mid].fromBlock<=_block) {
472                 min = mid;
473             } else {
474                 max = mid-1;
475             }
476         }
477         return checkpoints[min].value;
478     }
479 
480     /// @dev `updateValueAtNow` used to update the `balances` map and the
481     ///  `totalSupplyHistory`
482     /// @param checkpoints The history of data being updated
483     /// @param _value The new number of tokens
484     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
485     ) internal  {
486         if ((checkpoints.length == 0)
487         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
488                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
489                newCheckPoint.fromBlock =  uint128(block.number);
490                newCheckPoint.value = uint128(_value);
491            } else {
492                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
493                oldCheckPoint.value = uint128(_value);
494            }
495     }
496 
497     /// @dev Internal function to determine if an address is a contract
498     /// @param _addr The address being queried
499     /// @return True if `_addr` is a contract
500     function isContract(address _addr) constant internal returns(bool) {
501         uint size;
502         if (_addr == 0) return false;
503         assembly {
504             size := extcodesize(_addr)
505         }
506         return size>0;
507     }
508 
509     /// @dev Helper function to return a min betwen the two uints
510     function min(uint a, uint b) pure internal returns (uint) {
511         return a < b ? a : b;
512     }
513 
514     /// @notice The fallback function: If the contract's controller has not been
515     ///  set to 0, then the `proxyPayment` method is called which relays the
516     ///  ether and creates tokens as described in the token controller contract
517     function () public payable {
518         require(isContract(controller));
519         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
520     }
521 
522 //////////
523 // Safety Methods
524 //////////
525 
526     /// @notice This method can be used by the controller to extract mistakenly
527     ///  sent tokens to this contract.
528     /// @param _token The address of the token contract that you want to recover
529     ///  set to 0 in case you want to extract ether.
530     function claimTokens(address _token) public onlyController {
531         if (_token == 0x0) {
532             controller.transfer(this.balance);
533             return;
534         }
535 
536         MiniMeToken token = MiniMeToken(_token);
537         uint balance = token.balanceOf(this);
538         token.transfer(controller, balance);
539         ClaimedTokens(_token, controller, balance);
540     }
541 
542 ////////////////
543 // Events
544 ////////////////
545     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
546     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
547     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
548     event Approval(
549         address indexed _owner,
550         address indexed _spender,
551         uint256 _amount
552         );
553 
554 }
555 
556 
557 ////////////////
558 // MiniMeTokenFactory
559 ////////////////
560 
561 /// @dev This contract is used to generate clone contracts from a contract.
562 ///  In solidity this is the way to create a contract from a contract of the
563 ///  same class
564 contract MiniMeTokenFactory {
565 
566     /// @notice Update the DApp by creating a new token with new functionalities
567     ///  the msg.sender becomes the controller of this clone token
568     /// @param _parentToken Address of the token being cloned
569     /// @param _snapshotBlock Block of the parent token that will
570     ///  determine the initial distribution of the clone token
571     /// @param _tokenName Name of the new token
572     /// @param _decimalUnits Number of decimals of the new token
573     /// @param _tokenSymbol Token Symbol for the new token
574     /// @param _transfersEnabled If true, tokens will be able to be transferred
575     /// @return The address of the new token contract
576     function createCloneToken(
577         address _parentToken,
578         uint _snapshotBlock,
579         string _tokenName,
580         uint8 _decimalUnits,
581         string _tokenSymbol,
582         bool _transfersEnabled
583     ) public returns (MiniMeToken) {
584         MiniMeToken newToken = new MiniMeToken(
585             this,
586             _parentToken,
587             _snapshotBlock,
588             _tokenName,
589             _decimalUnits,
590             _tokenSymbol,
591             _transfersEnabled
592             );
593 
594         newToken.changeController(msg.sender);
595         return newToken;
596     }
597 }