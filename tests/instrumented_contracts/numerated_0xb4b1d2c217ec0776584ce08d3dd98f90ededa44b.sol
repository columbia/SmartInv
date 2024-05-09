1 /*
2     Copyright 2016, Jordi Baylina
3 
4     This program is free software: you can redistribute it and/or modify
5     it under the terms of the GNU General Public License as published by
6     the Free Software Foundation, either version 3 of the License, or
7     (at your option) any later version.
8 
9     This program is distributed in the hope that it will be useful,
10     but WITHOUT ANY WARRANTY; without even the implied warranty of
11     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
12     GNU General Public License for more details.
13 
14     You should have received a copy of the GNU General Public License
15     along with this program.  If not, see <http://www.gnu.org/licenses/>.
16  */
17 
18 /// @title MiniMeToken Contract
19 /// @author Jordi Baylina
20 /// @dev This token contract's goal is to make it easy for anyone to clone this
21 ///  token using the token distribution at a given block, this will allow DAO's
22 ///  and DApps to upgrade their features in a decentralized manner without
23 ///  affecting the original token
24 /// @dev It is ERC20 compliant, but still needs to under go further testing.
25 
26 /// @dev The token controller contract must implement these functions
27 contract TokenController {
28     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
29     /// @param _owner The address that sent the ether to create tokens
30     /// @return True if the ether is accepted, false if it throws
31     function proxyPayment(address _owner) payable returns(bool);
32 
33     /// @notice Notifies the controller about a token transfer allowing the
34     ///  controller to react if desired
35     /// @param _from The origin of the transfer
36     /// @param _to The destination of the transfer
37     /// @param _amount The amount of the transfer
38     /// @return False if the controller does not authorize the transfer
39     function onTransfer(address _from, address _to, uint _amount) returns(bool);
40 
41     /// @notice Notifies the controller about an approval allowing the
42     ///  controller to react if desired
43     /// @param _owner The address that calls `approve()`
44     /// @param _spender The spender in the `approve()` call
45     /// @param _amount The amount in the `approve()` call
46     /// @return False if the controller does not authorize the approval
47     function onApprove(address _owner, address _spender, uint _amount)
48         returns(bool);
49 }
50 
51 contract Controlled {
52     /// @notice The address of the controller is the only address that can call
53     ///  a function with this modifier
54     modifier onlyController { require(msg.sender == controller); _; }
55 
56     address public controller;
57 
58     function Controlled() { controller = msg.sender;}
59 
60     /// @notice Changes the controller of the contract
61     /// @param _newController The new controller of the contract
62     function changeController(address _newController) onlyController {
63         controller = _newController;
64     }
65 }
66 
67 contract ApproveAndCallFallBack {
68     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
69 }
70 
71 /// @dev The actual token contract, the default controller is the msg.sender
72 ///  that deploys the contract, so usually this token will be deployed by a
73 ///  token controller contract, which Giveth will call a "Campaign"
74 contract MiniMeToken is Controlled {
75 
76     string public name;                //The Token's name: e.g. DigixDAO Tokens
77     uint8 public decimals;             //Number of decimals of the smallest unit
78     string public symbol;              //An identifier: e.g. REP
79     string public version = 'MMT_0.1'; //An arbitrary versioning scheme
80 
81 
82     /// @dev `Checkpoint` is the structure that attaches a block number to a
83     ///  given value, the block number attached is the one that last changed the
84     ///  value
85     struct  Checkpoint {
86 
87         // `fromBlock` is the block number that the value was generated from
88         uint128 fromBlock;
89 
90         // `value` is the amount of tokens at a specific block number
91         uint128 value;
92     }
93 
94     // `parentToken` is the Token address that was cloned to produce this token;
95     //  it will be 0x0 for a token that was not cloned
96     MiniMeToken public parentToken;
97 
98     // `parentSnapShotBlock` is the block number from the Parent Token that was
99     //  used to determine the initial distribution of the Clone Token
100     uint public parentSnapShotBlock;
101 
102     // `creationBlock` is the block number that the Clone Token was created
103     uint public creationBlock;
104 
105     // `balances` is the map that tracks the balance of each address, in this
106     //  contract when the balance changes the block number that the change
107     //  occurred is also included in the map
108     mapping (address => Checkpoint[]) balances;
109 
110     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
111     mapping (address => mapping (address => uint256)) allowed;
112 
113     // Tracks the history of the `totalSupply` of the token
114     Checkpoint[] totalSupplyHistory;
115 
116     // Flag that determines if the token is transferable or not.
117     bool public transfersEnabled;
118 
119     // The factory used to create new clone tokens
120     MiniMeTokenFactory public tokenFactory;
121 
122 ////////////////
123 // Constructor
124 ////////////////
125 
126     /// @notice Constructor to create a MiniMeToken
127     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
128     ///  will create the Clone token contracts, the token factory needs to be
129     ///  deployed first
130     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
131     ///  new token
132     /// @param _parentSnapShotBlock Block of the parent token that will
133     ///  determine the initial distribution of the clone token, set to 0 if it
134     ///  is a new token
135     /// @param _tokenName Name of the new token
136     /// @param _decimalUnits Number of decimals of the new token
137     /// @param _tokenSymbol Token Symbol for the new token
138     /// @param _transfersEnabled If true, tokens will be able to be transferred
139     function MiniMeToken(
140         address _tokenFactory,
141         address _parentToken,
142         uint _parentSnapShotBlock,
143         string _tokenName,
144         uint8 _decimalUnits,
145         string _tokenSymbol,
146         bool _transfersEnabled
147     ) {
148         tokenFactory = MiniMeTokenFactory(_tokenFactory);
149         name = _tokenName;                                 // Set the name
150         decimals = _decimalUnits;                          // Set the decimals
151         symbol = _tokenSymbol;                             // Set the symbol
152         parentToken = MiniMeToken(_parentToken);
153         parentSnapShotBlock = _parentSnapShotBlock;
154         transfersEnabled = _transfersEnabled;
155         creationBlock = block.number;
156     }
157 
158 
159 ///////////////////
160 // ERC20 Methods
161 ///////////////////
162 
163     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
164     /// @param _to The address of the recipient
165     /// @param _amount The amount of tokens to be transferred
166     /// @return Whether the transfer was successful or not
167     function transfer(address _to, uint256 _amount) returns (bool success) {
168         require(transfersEnabled);
169         return doTransfer(msg.sender, _to, _amount);
170     }
171 
172     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
173     ///  is approved by `_from`
174     /// @param _from The address holding the tokens being transferred
175     /// @param _to The address of the recipient
176     /// @param _amount The amount of tokens to be transferred
177     /// @return True if the transfer was successful
178     function transferFrom(address _from, address _to, uint256 _amount
179     ) returns (bool success) {
180 
181         // The controller of this contract can move tokens around at will,
182         //  this is important to recognize! Confirm that you trust the
183         //  controller of this contract, which in most situations should be
184         //  another open source smart contract or 0x0
185         if (msg.sender != controller) {
186             require(transfersEnabled);
187 
188             // The standard ERC 20 transferFrom functionality
189             if (allowed[_from][msg.sender] < _amount) return false;
190             allowed[_from][msg.sender] -= _amount;
191         }
192         return doTransfer(_from, _to, _amount);
193     }
194 
195     /// @dev This is the actual transfer function in the token contract, it can
196     ///  only be called by other functions in this contract.
197     /// @param _from The address holding the tokens being transferred
198     /// @param _to The address of the recipient
199     /// @param _amount The amount of tokens to be transferred
200     /// @return True if the transfer was successful
201     function doTransfer(address _from, address _to, uint _amount
202     ) internal returns(bool) {
203 
204            if (_amount == 0) {
205                return true;
206            }
207 
208            require(parentSnapShotBlock < block.number);
209 
210            // Do not allow transfer to 0x0 or the token contract itself
211            require((_to != 0) && (_to != address(this)));
212 
213            // If the amount being transfered is more than the balance of the
214            //  account the transfer returns false
215            var previousBalanceFrom = balanceOfAt(_from, block.number);
216            if (previousBalanceFrom < _amount) {
217                return false;
218            }
219 
220            // Alerts the token controller of the transfer
221            if (isContract(controller)) {
222                require(TokenController(controller).onTransfer(_from, _to, _amount));
223            }
224 
225            // First update the balance array with the new value for the address
226            //  sending the tokens
227            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
228 
229            // Then update the balance array with the new value for the address
230            //  receiving the tokens
231            var previousBalanceTo = balanceOfAt(_to, block.number);
232            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
233            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
234 
235            // An event to make the transfer easy to find on the blockchain
236            Transfer(_from, _to, _amount);
237 
238            return true;
239     }
240 
241     /// @param _owner The address that's balance is being requested
242     /// @return The balance of `_owner` at the current block
243     function balanceOf(address _owner) constant returns (uint256 balance) {
244         return balanceOfAt(_owner, block.number);
245     }
246 
247     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
248     ///  its behalf. This is a modified version of the ERC20 approve function
249     ///  to be a little bit safer
250     /// @param _spender The address of the account able to transfer the tokens
251     /// @param _amount The amount of tokens to be approved for transfer
252     /// @return True if the approval was successful
253     function approve(address _spender, uint256 _amount) returns (bool success) {
254         require(transfersEnabled);
255 
256         // To change the approve amount you first have to reduce the addresses`
257         //  allowance to zero by calling `approve(_spender,0)` if it is not
258         //  already 0 to mitigate the race condition described here:
259         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
260         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
261 
262         // Alerts the token controller of the approve function call
263         if (isContract(controller)) {
264             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
265         }
266 
267         allowed[msg.sender][_spender] = _amount;
268         Approval(msg.sender, _spender, _amount);
269         return true;
270     }
271 
272     /// @dev This function makes it easy to read the `allowed[]` map
273     /// @param _owner The address of the account that owns the token
274     /// @param _spender The address of the account able to transfer the tokens
275     /// @return Amount of remaining tokens of _owner that _spender is allowed
276     ///  to spend
277     function allowance(address _owner, address _spender
278     ) constant returns (uint256 remaining) {
279         return allowed[_owner][_spender];
280     }
281 
282     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
283     ///  its behalf, and then a function is triggered in the contract that is
284     ///  being approved, `_spender`. This allows users to use their tokens to
285     ///  interact with contracts in one function call instead of two
286     /// @param _spender The address of the contract able to transfer the tokens
287     /// @param _amount The amount of tokens to be approved for transfer
288     /// @return True if the function call was successful
289     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
290     ) returns (bool success) {
291         require(approve(_spender, _amount));
292 
293         ApproveAndCallFallBack(_spender).receiveApproval(
294             msg.sender,
295             _amount,
296             this,
297             _extraData
298         );
299 
300         return true;
301     }
302 
303     /// @dev This function makes it easy to get the total number of tokens
304     /// @return The total number of tokens
305     function totalSupply() constant returns (uint) {
306         return totalSupplyAt(block.number);
307     }
308 
309 
310 ////////////////
311 // Query balance and totalSupply in History
312 ////////////////
313 
314     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
315     /// @param _owner The address from which the balance will be retrieved
316     /// @param _blockNumber The block number when the balance is queried
317     /// @return The balance at `_blockNumber`
318     function balanceOfAt(address _owner, uint _blockNumber) constant
319         returns (uint) {
320 
321         // These next few lines are used when the balance of the token is
322         //  requested before a check point was ever created for this token, it
323         //  requires that the `parentToken.balanceOfAt` be queried at the
324         //  genesis block for that token as this contains initial balance of
325         //  this token
326         if ((balances[_owner].length == 0)
327             || (balances[_owner][0].fromBlock > _blockNumber)) {
328             if (address(parentToken) != 0) {
329                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
330             } else {
331                 // Has no parent
332                 return 0;
333             }
334 
335         // This will return the expected balance during normal situations
336         } else {
337             return getValueAt(balances[_owner], _blockNumber);
338         }
339     }
340 
341     /// @notice Total amount of tokens at a specific `_blockNumber`.
342     /// @param _blockNumber The block number when the totalSupply is queried
343     /// @return The total amount of tokens at `_blockNumber`
344     function totalSupplyAt(uint _blockNumber) constant returns(uint) {
345 
346         // These next few lines are used when the totalSupply of the token is
347         //  requested before a check point was ever created for this token, it
348         //  requires that the `parentToken.totalSupplyAt` be queried at the
349         //  genesis block for this token as that contains totalSupply of this
350         //  token at this block number.
351         if ((totalSupplyHistory.length == 0)
352             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
353             if (address(parentToken) != 0) {
354                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
355             } else {
356                 return 0;
357             }
358 
359         // This will return the expected totalSupply during normal situations
360         } else {
361             return getValueAt(totalSupplyHistory, _blockNumber);
362         }
363     }
364 
365 ////////////////
366 // Clone Token Method
367 ////////////////
368 
369     /// @notice Creates a new clone token with the initial distribution being
370     ///  this token at `_snapshotBlock`
371     /// @param _cloneTokenName Name of the clone token
372     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
373     /// @param _cloneTokenSymbol Symbol of the clone token
374     /// @param _snapshotBlock Block when the distribution of the parent token is
375     ///  copied to set the initial distribution of the new clone token;
376     ///  if the block is zero than the actual block, the current block is used
377     /// @param _transfersEnabled True if transfers are allowed in the clone
378     /// @return The address of the new MiniMeToken Contract
379     function createCloneToken(
380         string _cloneTokenName,
381         uint8 _cloneDecimalUnits,
382         string _cloneTokenSymbol,
383         uint _snapshotBlock,
384         bool _transfersEnabled
385         ) returns(address) {
386         if (_snapshotBlock == 0) _snapshotBlock = block.number;
387         MiniMeToken cloneToken = tokenFactory.createCloneToken(
388             this,
389             _snapshotBlock,
390             _cloneTokenName,
391             _cloneDecimalUnits,
392             _cloneTokenSymbol,
393             _transfersEnabled
394             );
395 
396         cloneToken.changeController(msg.sender);
397 
398         // An event to make the token easy to find on the blockchain
399         NewCloneToken(address(cloneToken), _snapshotBlock);
400         return address(cloneToken);
401     }
402 
403 ////////////////
404 // Generate and destroy tokens
405 ////////////////
406 
407     /// @notice Generates `_amount` tokens that are assigned to `_owner`
408     /// @param _owner The address that will be assigned the new tokens
409     /// @param _amount The quantity of tokens generated
410     /// @return True if the tokens are generated correctly
411     function generateTokens(address _owner, uint _amount
412     ) onlyController returns (bool) {
413         uint curTotalSupply = totalSupply();
414         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
415         uint previousBalanceTo = balanceOf(_owner);
416         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
417         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
418         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
419         Transfer(0, _owner, _amount);
420         return true;
421     }
422 
423 
424     /// @notice Burns `_amount` tokens from `_owner`
425     /// @param _owner The address that will lose the tokens
426     /// @param _amount The quantity of tokens to burn
427     /// @return True if the tokens are burned correctly
428     function destroyTokens(address _owner, uint _amount
429     ) onlyController returns (bool) {
430         uint curTotalSupply = totalSupply();
431         require(curTotalSupply >= _amount);
432         uint previousBalanceFrom = balanceOf(_owner);
433         require(previousBalanceFrom >= _amount);
434         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
435         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
436         Transfer(_owner, 0, _amount);
437         return true;
438     }
439 
440 ////////////////
441 // Enable tokens transfers
442 ////////////////
443 
444 
445     /// @notice Enables token holders to transfer their tokens freely if true
446     /// @param _transfersEnabled True if transfers are allowed in the clone
447     function enableTransfers(bool _transfersEnabled) onlyController {
448         transfersEnabled = _transfersEnabled;
449     }
450 
451 ////////////////
452 // Internal helper functions to query and set a value in a snapshot array
453 ////////////////
454 
455     /// @dev `getValueAt` retrieves the number of tokens at a given block number
456     /// @param checkpoints The history of values being queried
457     /// @param _block The block number to retrieve the value at
458     /// @return The number of tokens being queried
459     function getValueAt(Checkpoint[] storage checkpoints, uint _block
460     ) constant internal returns (uint) {
461         if (checkpoints.length == 0) return 0;
462 
463         // Shortcut for the actual value
464         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
465             return checkpoints[checkpoints.length-1].value;
466         if (_block < checkpoints[0].fromBlock) return 0;
467 
468         // Binary search of the value in the array
469         uint min = 0;
470         uint max = checkpoints.length-1;
471         while (max > min) {
472             uint mid = (max + min + 1)/ 2;
473             if (checkpoints[mid].fromBlock<=_block) {
474                 min = mid;
475             } else {
476                 max = mid-1;
477             }
478         }
479         return checkpoints[min].value;
480     }
481 
482     /// @dev `updateValueAtNow` used to update the `balances` map and the
483     ///  `totalSupplyHistory`
484     /// @param checkpoints The history of data being updated
485     /// @param _value The new number of tokens
486     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
487     ) internal  {
488         if ((checkpoints.length == 0)
489         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
490                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
491                newCheckPoint.fromBlock =  uint128(block.number);
492                newCheckPoint.value = uint128(_value);
493            } else {
494                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
495                oldCheckPoint.value = uint128(_value);
496            }
497     }
498 
499     /// @dev Internal function to determine if an address is a contract
500     /// @param _addr The address being queried
501     /// @return True if `_addr` is a contract
502     function isContract(address _addr) constant internal returns(bool) {
503         uint size;
504         if (_addr == 0) return false;
505         assembly {
506             size := extcodesize(_addr)
507         }
508         return size>0;
509     }
510 
511     /// @dev Helper function to return a min betwen the two uints
512     function min(uint a, uint b) internal returns (uint) {
513         return a < b ? a : b;
514     }
515 
516     /// @notice The fallback function: If the contract's controller has not been
517     ///  set to 0, then the `proxyPayment` method is called which relays the
518     ///  ether and creates tokens as described in the token controller contract
519     function ()  payable {
520         require(isContract(controller));
521         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
522     }
523 
524 //////////
525 // Safety Methods
526 //////////
527 
528     /// @notice This method can be used by the controller to extract mistakenly
529     ///  sent tokens to this contract.
530     /// @param _token The address of the token contract that you want to recover
531     ///  set to 0 in case you want to extract ether.
532     function claimTokens(address _token) onlyController {
533         if (_token == 0x0) {
534             controller.transfer(this.balance);
535             return;
536         }
537 
538         MiniMeToken token = MiniMeToken(_token);
539         uint balance = token.balanceOf(this);
540         token.transfer(controller, balance);
541         ClaimedTokens(_token, controller, balance);
542     }
543 
544 ////////////////
545 // Events
546 ////////////////
547     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
548     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
549     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
550     event Approval(
551         address indexed _owner,
552         address indexed _spender,
553         uint256 _amount
554         );
555 
556 }
557 
558 
559 ////////////////
560 // MiniMeTokenFactory
561 ////////////////
562 
563 /// @dev This contract is used to generate clone contracts from a contract.
564 ///  In solidity this is the way to create a contract from a contract of the
565 ///  same class
566 contract MiniMeTokenFactory {
567 
568     /// @notice Update the DApp by creating a new token with new functionalities
569     ///  the msg.sender becomes the controller of this clone token
570     /// @param _parentToken Address of the token being cloned
571     /// @param _snapshotBlock Block of the parent token that will
572     ///  determine the initial distribution of the clone token
573     /// @param _tokenName Name of the new token
574     /// @param _decimalUnits Number of decimals of the new token
575     /// @param _tokenSymbol Token Symbol for the new token
576     /// @param _transfersEnabled If true, tokens will be able to be transferred
577     /// @return The address of the new token contract
578     function createCloneToken(
579         address _parentToken,
580         uint _snapshotBlock,
581         string _tokenName,
582         uint8 _decimalUnits,
583         string _tokenSymbol,
584         bool _transfersEnabled
585     ) returns (MiniMeToken) {
586         MiniMeToken newToken = new MiniMeToken(
587             this,
588             _parentToken,
589             _snapshotBlock,
590             _tokenName,
591             _decimalUnits,
592             _tokenSymbol,
593             _transfersEnabled
594             );
595 
596         newToken.changeController(msg.sender);
597         return newToken;
598     }
599 }
600 
601 contract Climate is MiniMeToken {
602     // @dev Climate constructor just parametrizes the MiniMeIrrevocableVestedToken constructor
603     function Climate(address _tokenFactory)
604             MiniMeToken(
605                 _tokenFactory,
606                 0x0,                     // no parent token
607                 0,                       // no snapshot block number from parent
608                 "Climatecoin",           // Token name
609                 18,                      // Decimals
610                 "CO2",                   // Symbol
611                 true                     // Enable transfers
612             ) {}
613 }