1 pragma solidity ^0.4.18;
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
26 
27 /// @dev It is ERC20 compliant, but still needs to under go further testing.
28 contract Controlled {
29     /// @notice The address of the controller is the only address that can call
30     ///  a function with this modifier
31     modifier onlyController { require(msg.sender == controller); _; }
32 
33     address public controller;
34 
35     function Controlled() public { controller = msg.sender;}
36 
37     /// @notice Changes the controller of the contract
38     /// @param _newController The new controller of the contract
39     function changeController(address _newController) public onlyController {
40         controller = _newController;
41     }
42 }
43 
44 /// @dev The token controller contract must implement these functions
45 contract TokenController {
46     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
47     /// @param _owner The address that sent the ether to create tokens
48     /// @return True if the ether is accepted, false if it throws
49     function proxyPayment(address _owner) public payable returns(bool);
50 
51     /// @notice Notifies the controller about a token transfer allowing the
52     ///  controller to react if desired
53     /// @param _from The origin of the transfer
54     /// @param _to The destination of the transfer
55     /// @param _amount The amount of the transfer
56     /// @return False if the controller does not authorize the transfer
57     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
58 
59     /// @notice Notifies the controller about an approval allowing the
60     ///  controller to react if desired
61     /// @param _owner The address that calls `approve()`
62     /// @param _spender The spender in the `approve()` call
63     /// @param _amount The amount in the `approve()` call
64     /// @return False if the controller does not authorize the approval
65     function onApprove(address _owner, address _spender, uint _amount) public
66         returns(bool);
67 }
68 
69 contract ApproveAndCallFallBack {
70     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
71 }
72 
73 /// @dev The actual token contract, the default controller is the msg.sender
74 ///  that deploys the contract, so usually this token will be deployed by a
75 ///  token controller contract, which Giveth will call a "Campaign"
76 contract MiniMeToken is Controlled {
77 
78     string public name;                //The Token's name: e.g. DigixDAO Tokens
79     uint8 public decimals;             //Number of decimals of the smallest unit
80     string public symbol;              //An identifier: e.g. REP
81     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
82 
83 
84     /// @dev `Checkpoint` is the structure that attaches a block number to a
85     ///  given value, the block number attached is the one that last changed the
86     ///  value
87     struct  Checkpoint {
88 
89         // `fromBlock` is the block number that the value was generated from
90         uint128 fromBlock;
91 
92         // `value` is the amount of tokens at a specific block number
93         uint128 value;
94     }
95 
96     // `parentToken` is the Token address that was cloned to produce this token;
97     //  it will be 0x0 for a token that was not cloned
98     MiniMeToken public parentToken;
99 
100     // `parentSnapShotBlock` is the block number from the Parent Token that was
101     //  used to determine the initial distribution of the Clone Token
102     uint public parentSnapShotBlock;
103 
104     // `creationBlock` is the block number that the Clone Token was created
105     uint public creationBlock;
106 
107     // `balances` is the map that tracks the balance of each address, in this
108     //  contract when the balance changes the block number that the change
109     //  occurred is also included in the map
110     mapping (address => Checkpoint[]) balances;
111 
112     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
113     mapping (address => mapping (address => uint256)) allowed;
114 
115     // Tracks the history of the `totalSupply` of the token
116     Checkpoint[] totalSupplyHistory;
117 
118     // Flag that determines if the token is transferable or not.
119     bool public transfersEnabled;
120 
121     // The factory used to create new clone tokens
122     MiniMeTokenFactory public tokenFactory;
123 
124 ////////////////
125 // Constructor
126 ////////////////
127 
128     /// @notice Constructor to create a MiniMeToken
129     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
130     ///  will create the Clone token contracts, the token factory needs to be
131     ///  deployed first
132     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
133     ///  new token
134     /// @param _parentSnapShotBlock Block of the parent token that will
135     ///  determine the initial distribution of the clone token, set to 0 if it
136     ///  is a new token
137     /// @param _tokenName Name of the new token
138     /// @param _decimalUnits Number of decimals of the new token
139     /// @param _tokenSymbol Token Symbol for the new token
140     /// @param _transfersEnabled If true, tokens will be able to be transferred
141     function MiniMeToken(
142         address _tokenFactory,
143         address _parentToken,
144         uint _parentSnapShotBlock,
145         string _tokenName,
146         uint8 _decimalUnits,
147         string _tokenSymbol,
148         bool _transfersEnabled
149     ) public {
150         tokenFactory = MiniMeTokenFactory(_tokenFactory);
151         name = _tokenName;                                 // Set the name
152         decimals = _decimalUnits;                          // Set the decimals
153         symbol = _tokenSymbol;                             // Set the symbol
154         parentToken = MiniMeToken(_parentToken);
155         parentSnapShotBlock = _parentSnapShotBlock;
156         transfersEnabled = _transfersEnabled;
157         creationBlock = block.number;
158     }
159 
160 
161 ///////////////////
162 // ERC20 Methods
163 ///////////////////
164 
165     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
166     /// @param _to The address of the recipient
167     /// @param _amount The amount of tokens to be transferred
168     /// @return Whether the transfer was successful or not
169     function transfer(address _to, uint256 _amount) public returns (bool success) {
170         require(transfersEnabled);
171         return doTransfer(msg.sender, _to, _amount);
172     }
173 
174     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
175     ///  is approved by `_from`
176     /// @param _from The address holding the tokens being transferred
177     /// @param _to The address of the recipient
178     /// @param _amount The amount of tokens to be transferred
179     /// @return True if the transfer was successful
180     function transferFrom(address _from, address _to, uint256 _amount
181     ) public returns (bool success) {
182 
183         // The controller of this contract can move tokens around at will,
184         //  this is important to recognize! Confirm that you trust the
185         //  controller of this contract, which in most situations should be
186         //  another open source smart contract or 0x0
187         if (msg.sender != controller) {
188             require(transfersEnabled);
189 
190             // The standard ERC 20 transferFrom functionality
191             if (allowed[_from][msg.sender] < _amount) return false;
192             allowed[_from][msg.sender] -= _amount;
193         }
194         return doTransfer(_from, _to, _amount);
195     }
196 
197     /// @dev This is the actual transfer function in the token contract, it can
198     ///  only be called by other functions in this contract.
199     /// @param _from The address holding the tokens being transferred
200     /// @param _to The address of the recipient
201     /// @param _amount The amount of tokens to be transferred
202     /// @return True if the transfer was successful
203     function doTransfer(address _from, address _to, uint _amount
204     ) internal returns(bool) {
205 
206            if (_amount == 0) {
207                return true;
208            }
209 
210            require(parentSnapShotBlock < block.number);
211 
212            // Do not allow transfer to 0x0 or the token contract itself
213            require((_to != 0) && (_to != address(this)));
214 
215            // If the amount being transfered is more than the balance of the
216            //  account the transfer returns false
217            var previousBalanceFrom = balanceOfAt(_from, block.number);
218            if (previousBalanceFrom < _amount) {
219                return false;
220            }
221 
222            // Alerts the token controller of the transfer
223            if (isContract(controller)) {
224                require(TokenController(controller).onTransfer(_from, _to, _amount));
225            }
226 
227            // First update the balance array with the new value for the address
228            //  sending the tokens
229            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
230 
231            // Then update the balance array with the new value for the address
232            //  receiving the tokens
233            var previousBalanceTo = balanceOfAt(_to, block.number);
234            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
235            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
236 
237            // An event to make the transfer easy to find on the blockchain
238            Transfer(_from, _to, _amount);
239 
240            return true;
241     }
242 
243     /// @param _owner The address that's balance is being requested
244     /// @return The balance of `_owner` at the current block
245     function balanceOf(address _owner) public constant returns (uint256 balance) {
246         return balanceOfAt(_owner, block.number);
247     }
248 
249     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
250     ///  its behalf. This is a modified version of the ERC20 approve function
251     ///  to be a little bit safer
252     /// @param _spender The address of the account able to transfer the tokens
253     /// @param _amount The amount of tokens to be approved for transfer
254     /// @return True if the approval was successful
255     function approve(address _spender, uint256 _amount) public returns (bool success) {
256         require(transfersEnabled);
257 
258         // To change the approve amount you first have to reduce the addresses`
259         //  allowance to zero by calling `approve(_spender,0)` if it is not
260         //  already 0 to mitigate the race condition described here:
261         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
262         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
263 
264         // Alerts the token controller of the approve function call
265         if (isContract(controller)) {
266             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
267         }
268 
269         allowed[msg.sender][_spender] = _amount;
270         Approval(msg.sender, _spender, _amount);
271         return true;
272     }
273 
274     /// @dev This function makes it easy to read the `allowed[]` map
275     /// @param _owner The address of the account that owns the token
276     /// @param _spender The address of the account able to transfer the tokens
277     /// @return Amount of remaining tokens of _owner that _spender is allowed
278     ///  to spend
279     function allowance(address _owner, address _spender
280     ) public constant returns (uint256 remaining) {
281         return allowed[_owner][_spender];
282     }
283 
284     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
285     ///  its behalf, and then a function is triggered in the contract that is
286     ///  being approved, `_spender`. This allows users to use their tokens to
287     ///  interact with contracts in one function call instead of two
288     /// @param _spender The address of the contract able to transfer the tokens
289     /// @param _amount The amount of tokens to be approved for transfer
290     /// @return True if the function call was successful
291     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
292     ) public returns (bool success) {
293         require(approve(_spender, _amount));
294 
295         ApproveAndCallFallBack(_spender).receiveApproval(
296             msg.sender,
297             _amount,
298             this,
299             _extraData
300         );
301 
302         return true;
303     }
304 
305     /// @dev This function makes it easy to get the total number of tokens
306     /// @return The total number of tokens
307     function totalSupply() public constant returns (uint) {
308         return totalSupplyAt(block.number);
309     }
310 
311 
312 ////////////////
313 // Query balance and totalSupply in History
314 ////////////////
315 
316     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
317     /// @param _owner The address from which the balance will be retrieved
318     /// @param _blockNumber The block number when the balance is queried
319     /// @return The balance at `_blockNumber`
320     function balanceOfAt(address _owner, uint _blockNumber) public constant
321         returns (uint) {
322 
323         // These next few lines are used when the balance of the token is
324         //  requested before a check point was ever created for this token, it
325         //  requires that the `parentToken.balanceOfAt` be queried at the
326         //  genesis block for that token as this contains initial balance of
327         //  this token
328         if ((balances[_owner].length == 0)
329             || (balances[_owner][0].fromBlock > _blockNumber)) {
330             if (address(parentToken) != 0) {
331                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
332             } else {
333                 // Has no parent
334                 return 0;
335             }
336 
337         // This will return the expected balance during normal situations
338         } else {
339             return getValueAt(balances[_owner], _blockNumber);
340         }
341     }
342 
343     /// @notice Total amount of tokens at a specific `_blockNumber`.
344     /// @param _blockNumber The block number when the totalSupply is queried
345     /// @return The total amount of tokens at `_blockNumber`
346     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
347 
348         // These next few lines are used when the totalSupply of the token is
349         //  requested before a check point was ever created for this token, it
350         //  requires that the `parentToken.totalSupplyAt` be queried at the
351         //  genesis block for this token as that contains totalSupply of this
352         //  token at this block number.
353         if ((totalSupplyHistory.length == 0)
354             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
355             if (address(parentToken) != 0) {
356                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
357             } else {
358                 return 0;
359             }
360 
361         // This will return the expected totalSupply during normal situations
362         } else {
363             return getValueAt(totalSupplyHistory, _blockNumber);
364         }
365     }
366 
367 ////////////////
368 // Clone Token Method
369 ////////////////
370 
371     /// @notice Creates a new clone token with the initial distribution being
372     ///  this token at `_snapshotBlock`
373     /// @param _cloneTokenName Name of the clone token
374     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
375     /// @param _cloneTokenSymbol Symbol of the clone token
376     /// @param _snapshotBlock Block when the distribution of the parent token is
377     ///  copied to set the initial distribution of the new clone token;
378     ///  if the block is zero than the actual block, the current block is used
379     /// @param _transfersEnabled True if transfers are allowed in the clone
380     /// @return The address of the new MiniMeToken Contract
381     function createCloneToken(
382         string _cloneTokenName,
383         uint8 _cloneDecimalUnits,
384         string _cloneTokenSymbol,
385         uint _snapshotBlock,
386         bool _transfersEnabled
387         ) public returns(address) {
388         if (_snapshotBlock == 0) _snapshotBlock = block.number;
389         MiniMeToken cloneToken = tokenFactory.createCloneToken(
390             this,
391             _snapshotBlock,
392             _cloneTokenName,
393             _cloneDecimalUnits,
394             _cloneTokenSymbol,
395             _transfersEnabled
396             );
397 
398         cloneToken.changeController(msg.sender);
399 
400         // An event to make the token easy to find on the blockchain
401         NewCloneToken(address(cloneToken), _snapshotBlock);
402         return address(cloneToken);
403     }
404 
405 ////////////////
406 // Generate and destroy tokens
407 ////////////////
408 
409     /// @notice Generates `_amount` tokens that are assigned to `_owner`
410     /// @param _owner The address that will be assigned the new tokens
411     /// @param _amount The quantity of tokens generated
412     /// @return True if the tokens are generated correctly
413     function generateTokens(address _owner, uint _amount
414     ) public onlyController returns (bool) {
415         uint curTotalSupply = totalSupply();
416         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
417         uint previousBalanceTo = balanceOf(_owner);
418         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
419         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
420         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
421         Transfer(0, _owner, _amount);
422         return true;
423     }
424 
425 
426     /// @notice Burns `_amount` tokens from `_owner`
427     /// @param _owner The address that will lose the tokens
428     /// @param _amount The quantity of tokens to burn
429     /// @return True if the tokens are burned correctly
430     function destroyTokens(address _owner, uint _amount
431     ) onlyController public returns (bool) {
432         uint curTotalSupply = totalSupply();
433         require(curTotalSupply >= _amount);
434         uint previousBalanceFrom = balanceOf(_owner);
435         require(previousBalanceFrom >= _amount);
436         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
437         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
438         Transfer(_owner, 0, _amount);
439         return true;
440     }
441 
442 ////////////////
443 // Enable tokens transfers
444 ////////////////
445 
446 
447     /// @notice Enables token holders to transfer their tokens freely if true
448     /// @param _transfersEnabled True if transfers are allowed in the clone
449     function enableTransfers(bool _transfersEnabled) public onlyController {
450         transfersEnabled = _transfersEnabled;
451     }
452 
453 ////////////////
454 // Internal helper functions to query and set a value in a snapshot array
455 ////////////////
456 
457     /// @dev `getValueAt` retrieves the number of tokens at a given block number
458     /// @param checkpoints The history of values being queried
459     /// @param _block The block number to retrieve the value at
460     /// @return The number of tokens being queried
461     function getValueAt(Checkpoint[] storage checkpoints, uint _block
462     ) constant internal returns (uint) {
463         if (checkpoints.length == 0) return 0;
464 
465         // Shortcut for the actual value
466         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
467             return checkpoints[checkpoints.length-1].value;
468         if (_block < checkpoints[0].fromBlock) return 0;
469 
470         // Binary search of the value in the array
471         uint min = 0;
472         uint max = checkpoints.length-1;
473         while (max > min) {
474             uint mid = (max + min + 1)/ 2;
475             if (checkpoints[mid].fromBlock<=_block) {
476                 min = mid;
477             } else {
478                 max = mid-1;
479             }
480         }
481         return checkpoints[min].value;
482     }
483 
484     /// @dev `updateValueAtNow` used to update the `balances` map and the
485     ///  `totalSupplyHistory`
486     /// @param checkpoints The history of data being updated
487     /// @param _value The new number of tokens
488     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
489     ) internal  {
490         if ((checkpoints.length == 0)
491         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
492                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
493                newCheckPoint.fromBlock =  uint128(block.number);
494                newCheckPoint.value = uint128(_value);
495            } else {
496                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
497                oldCheckPoint.value = uint128(_value);
498            }
499     }
500 
501     /// @dev Internal function to determine if an address is a contract
502     /// @param _addr The address being queried
503     /// @return True if `_addr` is a contract
504     function isContract(address _addr) constant internal returns(bool) {
505         uint size;
506         if (_addr == 0) return false;
507         assembly {
508             size := extcodesize(_addr)
509         }
510         return size>0;
511     }
512 
513     /// @dev Helper function to return a min betwen the two uints
514     function min(uint a, uint b) pure internal returns (uint) {
515         return a < b ? a : b;
516     }
517 
518     /// @notice The fallback function: If the contract's controller has not been
519     ///  set to 0, then the `proxyPayment` method is called which relays the
520     ///  ether and creates tokens as described in the token controller contract
521     function () public payable {
522         require(isContract(controller));
523         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
524     }
525 
526 //////////
527 // Safety Methods
528 //////////
529 
530     /// @notice This method can be used by the controller to extract mistakenly
531     ///  sent tokens to this contract.
532     /// @param _token The address of the token contract that you want to recover
533     ///  set to 0 in case you want to extract ether.
534     function claimTokens(address _token) public onlyController {
535         if (_token == 0x0) {
536             controller.transfer(this.balance);
537             return;
538         }
539 
540         MiniMeToken token = MiniMeToken(_token);
541         uint balance = token.balanceOf(this);
542         token.transfer(controller, balance);
543         ClaimedTokens(_token, controller, balance);
544     }
545 
546 ////////////////
547 // Events
548 ////////////////
549     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
550     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
551     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
552     event Approval(
553         address indexed _owner,
554         address indexed _spender,
555         uint256 _amount
556         );
557 
558 }
559 
560 
561 ////////////////
562 // MiniMeTokenFactory
563 ////////////////
564 
565 /// @dev This contract is used to generate clone contracts from a contract.
566 ///  In solidity this is the way to create a contract from a contract of the
567 ///  same class
568 contract MiniMeTokenFactory {
569 
570     /// @notice Update the DApp by creating a new token with new functionalities
571     ///  the msg.sender becomes the controller of this clone token
572     /// @param _parentToken Address of the token being cloned
573     /// @param _snapshotBlock Block of the parent token that will
574     ///  determine the initial distribution of the clone token
575     /// @param _tokenName Name of the new token
576     /// @param _decimalUnits Number of decimals of the new token
577     /// @param _tokenSymbol Token Symbol for the new token
578     /// @param _transfersEnabled If true, tokens will be able to be transferred
579     /// @return The address of the new token contract
580     function createCloneToken(
581         address _parentToken,
582         uint _snapshotBlock,
583         string _tokenName,
584         uint8 _decimalUnits,
585         string _tokenSymbol,
586         bool _transfersEnabled
587     ) public returns (MiniMeToken) {
588         MiniMeToken newToken = new MiniMeToken(
589             this,
590             _parentToken,
591             _snapshotBlock,
592             _tokenName,
593             _decimalUnits,
594             _tokenSymbol,
595             _transfersEnabled
596             );
597 
598         newToken.changeController(msg.sender);
599         return newToken;
600     }
601 }