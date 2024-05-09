1 pragma solidity ^0.4.18;
2 /*
3     Copyright 2016, Jordi Baylina
4     This program is free software: you can redistribute it and/or modify
5     it under the terms of the GNU General Public License as published by
6     the Free Software Foundation, either version 3 of the License, or
7     (at your option) any later version.
8     This program is distributed in the hope that it will be useful,
9     but WITHOUT ANY WARRANTY; without even the implied warranty of
10     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
11     GNU General Public License for more details.
12     You should have received a copy of the GNU General Public License
13     along with this program.  If not, see <http://www.gnu.org/licenses/>.
14  */
15 /// @title MiniMeToken Contract
16 /// @author Jordi Baylina
17 /// @dev This token contract's goal is to make it easy for anyone to clone this
18 ///  token using the token distribution at a given block, this will allow DAO's
19 ///  and DApps to upgrade their features in a decentralized manner without
20 ///  affecting the original token
21 /// @dev It is ERC20 compliant, but still needs to under go further testing.
22 contract Controlled {
23     /// @notice The address of the controller is the only address that can call
24     ///  a function with this modifier
25     modifier onlyController { require(msg.sender == controller); _; }
26     address public controller;
27     function Controlled() public { controller = msg.sender;}
28     /// @notice Changes the controller of the contract
29     /// @param _newController The new controller of the contract
30     function changeController(address _newController) public onlyController {
31         controller = _newController;
32     }
33 }
34 /// @dev The token controller contract must implement these functions
35 contract TokenController {
36     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
37     /// @param _owner The address that sent the ether to create tokens
38     /// @return True if the ether is accepted, false if it throws
39     function proxyPayment(address _owner) public payable returns(bool);
40     /// @notice Notifies the controller about a token transfer allowing the
41     ///  controller to react if desired
42     /// @param _from The origin of the transfer
43     /// @param _to The destination of the transfer
44     /// @param _amount The amount of the transfer
45     /// @return False if the controller does not authorize the transfer
46     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
47     /// @notice Notifies the controller about an approval allowing the
48     ///  controller to react if desired
49     /// @param _owner The address that calls `approve()`
50     /// @param _spender The spender in the `approve()` call
51     /// @param _amount The amount in the `approve()` call
52     /// @return False if the controller does not authorize the approval
53     function onApprove(address _owner, address _spender, uint _amount) public
54         returns(bool);
55 }
56 contract ApproveAndCallFallBack {
57     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
58 }
59 /// @dev The actual token contract, the default controller is the msg.sender
60 ///  that deploys the contract, so usually this token will be deployed by a
61 ///  token controller contract, which Giveth will call a "Campaign"
62 contract MiniMeToken is Controlled {
63     string public name;                //The Token's name: e.g. DigixDAO Tokens
64     uint8 public decimals;             //Number of decimals of the smallest unit
65     string public symbol;              //An identifier: e.g. REP
66     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
67     /// @dev `Checkpoint` is the structure that attaches a block number to a
68     ///  given value, the block number attached is the one that last changed the
69     ///  value
70     struct  Checkpoint {
71         // `fromBlock` is the block number that the value was generated from
72         uint128 fromBlock;
73         // `value` is the amount of tokens at a specific block number
74         uint128 value;
75     }
76     // `parentToken` is the Token address that was cloned to produce this token;
77     //  it will be 0x0 for a token that was not cloned
78     MiniMeToken public parentToken;
79     // `parentSnapShotBlock` is the block number from the Parent Token that was
80     //  used to determine the initial distribution of the Clone Token
81     uint public parentSnapShotBlock;
82     // `creationBlock` is the block number that the Clone Token was created
83     uint public creationBlock;
84     // `balances` is the map that tracks the balance of each address, in this
85     //  contract when the balance changes the block number that the change
86     //  occurred is also included in the map
87     mapping (address => Checkpoint[]) balances;
88     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
89     mapping (address => mapping (address => uint256)) allowed;
90     // Tracks the history of the `totalSupply` of the token
91     Checkpoint[] totalSupplyHistory;
92     // Flag that determines if the token is transferable or not.
93     bool public transfersEnabled;
94     // The factory used to create new clone tokens
95     MiniMeTokenFactory public tokenFactory;
96 ////////////////
97 // Constructor
98 ////////////////
99     /// @notice Constructor to create a MiniMeToken
100     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
101     ///  will create the Clone token contracts, the token factory needs to be
102     ///  deployed first
103     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
104     ///  new token
105     /// @param _parentSnapShotBlock Block of the parent token that will
106     ///  determine the initial distribution of the clone token, set to 0 if it
107     ///  is a new token
108     /// @param _tokenName Name of the new token
109     /// @param _decimalUnits Number of decimals of the new token
110     /// @param _tokenSymbol Token Symbol for the new token
111     /// @param _transfersEnabled If true, tokens will be able to be transferred
112     function MiniMeToken(
113         address _tokenFactory,
114         address _parentToken,
115         uint _parentSnapShotBlock,
116         string _tokenName,
117         uint8 _decimalUnits,
118         string _tokenSymbol,
119         bool _transfersEnabled
120     ) public {
121         tokenFactory = MiniMeTokenFactory(_tokenFactory);
122         name = _tokenName;                                 // Set the name
123         decimals = _decimalUnits;                          // Set the decimals
124         symbol = _tokenSymbol;                             // Set the symbol
125         parentToken = MiniMeToken(_parentToken);
126         parentSnapShotBlock = _parentSnapShotBlock;
127         transfersEnabled = _transfersEnabled;
128         creationBlock = block.number;
129     }
130 ///////////////////
131 // ERC20 Methods
132 ///////////////////
133     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
134     /// @param _to The address of the recipient
135     /// @param _amount The amount of tokens to be transferred
136     /// @return Whether the transfer was successful or not
137     function transfer(address _to, uint256 _amount) public returns (bool success) {
138         require(transfersEnabled);
139         return doTransfer(msg.sender, _to, _amount);
140     }
141     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
142     ///  is approved by `_from`
143     /// @param _from The address holding the tokens being transferred
144     /// @param _to The address of the recipient
145     /// @param _amount The amount of tokens to be transferred
146     /// @return True if the transfer was successful
147     function transferFrom(address _from, address _to, uint256 _amount
148     ) public returns (bool success) {
149         // The controller of this contract can move tokens around at will,
150         //  this is important to recognize! Confirm that you trust the
151         //  controller of this contract, which in most situations should be
152         //  another open source smart contract or 0x0
153         if (msg.sender != controller) {
154             require(transfersEnabled);
155             // The standard ERC 20 transferFrom functionality
156             if (allowed[_from][msg.sender] < _amount) return false;
157             allowed[_from][msg.sender] -= _amount;
158         }
159         return doTransfer(_from, _to, _amount);
160     }
161     /// @dev This is the actual transfer function in the token contract, it can
162     ///  only be called by other functions in this contract.
163     /// @param _from The address holding the tokens being transferred
164     /// @param _to The address of the recipient
165     /// @param _amount The amount of tokens to be transferred
166     /// @return True if the transfer was successful
167     function doTransfer(address _from, address _to, uint _amount
168     ) internal returns(bool) {
169            if (_amount == 0) {
170                return true;
171            }
172            require(parentSnapShotBlock < block.number);
173            // Do not allow transfer to 0x0 or the token contract itself
174            require((_to != 0) && (_to != address(this)));
175            // If the amount being transfered is more than the balance of the
176            //  account the transfer returns false
177            var previousBalanceFrom = balanceOfAt(_from, block.number);
178            if (previousBalanceFrom < _amount) {
179                return false;
180            }
181            // Alerts the token controller of the transfer
182            if (isContract(controller)) {
183                require(TokenController(controller).onTransfer(_from, _to, _amount));
184            }
185            // First update the balance array with the new value for the address
186            //  sending the tokens
187            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
188            // Then update the balance array with the new value for the address
189            //  receiving the tokens
190            var previousBalanceTo = balanceOfAt(_to, block.number);
191            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
192            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
193            // An event to make the transfer easy to find on the blockchain
194            Transfer(_from, _to, _amount);
195            return true;
196     }
197     /// @param _owner The address that's balance is being requested
198     /// @return The balance of `_owner` at the current block
199     function balanceOf(address _owner) public constant returns (uint256 balance) {
200         return balanceOfAt(_owner, block.number);
201     }
202     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
203     ///  its behalf. This is a modified version of the ERC20 approve function
204     ///  to be a little bit safer
205     /// @param _spender The address of the account able to transfer the tokens
206     /// @param _amount The amount of tokens to be approved for transfer
207     /// @return True if the approval was successful
208     function approve(address _spender, uint256 _amount) public returns (bool success) {
209         require(transfersEnabled);
210         // To change the approve amount you first have to reduce the addresses`
211         //  allowance to zero by calling `approve(_spender,0)` if it is not
212         //  already 0 to mitigate the race condition described here:
213         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
214         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
215         // Alerts the token controller of the approve function call
216         if (isContract(controller)) {
217             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
218         }
219         allowed[msg.sender][_spender] = _amount;
220         Approval(msg.sender, _spender, _amount);
221         return true;
222     }
223     /// @dev This function makes it easy to read the `allowed[]` map
224     /// @param _owner The address of the account that owns the token
225     /// @param _spender The address of the account able to transfer the tokens
226     /// @return Amount of remaining tokens of _owner that _spender is allowed
227     ///  to spend
228     function allowance(address _owner, address _spender
229     ) public constant returns (uint256 remaining) {
230         return allowed[_owner][_spender];
231     }
232     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
233     ///  its behalf, and then a function is triggered in the contract that is
234     ///  being approved, `_spender`. This allows users to use their tokens to
235     ///  interact with contracts in one function call instead of two
236     /// @param _spender The address of the contract able to transfer the tokens
237     /// @param _amount The amount of tokens to be approved for transfer
238     /// @return True if the function call was successful
239     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
240     ) public returns (bool success) {
241         require(approve(_spender, _amount));
242         ApproveAndCallFallBack(_spender).receiveApproval(
243             msg.sender,
244             _amount,
245             this,
246             _extraData
247         );
248         return true;
249     }
250     /// @dev This function makes it easy to get the total number of tokens
251     /// @return The total number of tokens
252     function totalSupply() public constant returns (uint) {
253         return totalSupplyAt(block.number);
254     }
255 ////////////////
256 // Query balance and totalSupply in History
257 ////////////////
258     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
259     /// @param _owner The address from which the balance will be retrieved
260     /// @param _blockNumber The block number when the balance is queried
261     /// @return The balance at `_blockNumber`
262     function balanceOfAt(address _owner, uint _blockNumber) public constant
263         returns (uint) {
264         // These next few lines are used when the balance of the token is
265         //  requested before a check point was ever created for this token, it
266         //  requires that the `parentToken.balanceOfAt` be queried at the
267         //  genesis block for that token as this contains initial balance of
268         //  this token
269         if ((balances[_owner].length == 0)
270             || (balances[_owner][0].fromBlock > _blockNumber)) {
271             if (address(parentToken) != 0) {
272                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
273             } else {
274                 // Has no parent
275                 return 0;
276             }
277         // This will return the expected balance during normal situations
278         } else {
279             return getValueAt(balances[_owner], _blockNumber);
280         }
281     }
282     /// @notice Total amount of tokens at a specific `_blockNumber`.
283     /// @param _blockNumber The block number when the totalSupply is queried
284     /// @return The total amount of tokens at `_blockNumber`
285     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
286         // These next few lines are used when the totalSupply of the token is
287         //  requested before a check point was ever created for this token, it
288         //  requires that the `parentToken.totalSupplyAt` be queried at the
289         //  genesis block for this token as that contains totalSupply of this
290         //  token at this block number.
291         if ((totalSupplyHistory.length == 0)
292             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
293             if (address(parentToken) != 0) {
294                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
295             } else {
296                 return 0;
297             }
298         // This will return the expected totalSupply during normal situations
299         } else {
300             return getValueAt(totalSupplyHistory, _blockNumber);
301         }
302     }
303 ////////////////
304 // Clone Token Method
305 ////////////////
306     /// @notice Creates a new clone token with the initial distribution being
307     ///  this token at `_snapshotBlock`
308     /// @param _cloneTokenName Name of the clone token
309     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
310     /// @param _cloneTokenSymbol Symbol of the clone token
311     /// @param _snapshotBlock Block when the distribution of the parent token is
312     ///  copied to set the initial distribution of the new clone token;
313     ///  if the block is zero than the actual block, the current block is used
314     /// @param _transfersEnabled True if transfers are allowed in the clone
315     /// @return The address of the new MiniMeToken Contract
316     function createCloneToken(
317         string _cloneTokenName,
318         uint8 _cloneDecimalUnits,
319         string _cloneTokenSymbol,
320         uint _snapshotBlock,
321         bool _transfersEnabled
322         ) public returns(address) {
323         if (_snapshotBlock == 0) _snapshotBlock = block.number;
324         MiniMeToken cloneToken = tokenFactory.createCloneToken(
325             this,
326             _snapshotBlock,
327             _cloneTokenName,
328             _cloneDecimalUnits,
329             _cloneTokenSymbol,
330             _transfersEnabled
331             );
332         cloneToken.changeController(msg.sender);
333         // An event to make the token easy to find on the blockchain
334         NewCloneToken(address(cloneToken), _snapshotBlock);
335         return address(cloneToken);
336     }
337 ////////////////
338 // Generate and destroy tokens
339 ////////////////
340     /// @notice Generates `_amount` tokens that are assigned to `_owner`
341     /// @param _owner The address that will be assigned the new tokens
342     /// @param _amount The quantity of tokens generated
343     /// @return True if the tokens are generated correctly
344     function generateTokens(address _owner, uint _amount
345     ) public onlyController returns (bool) {
346         uint curTotalSupply = totalSupply();
347         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
348         uint previousBalanceTo = balanceOf(_owner);
349         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
350         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
351         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
352         Transfer(0, _owner, _amount);
353         return true;
354     }
355     /// @notice Burns `_amount` tokens from `_owner`
356     /// @param _owner The address that will lose the tokens
357     /// @param _amount The quantity of tokens to burn
358     /// @return True if the tokens are burned correctly
359     function destroyTokens(address _owner, uint _amount
360     ) onlyController public returns (bool) {
361         uint curTotalSupply = totalSupply();
362         require(curTotalSupply >= _amount);
363         uint previousBalanceFrom = balanceOf(_owner);
364         require(previousBalanceFrom >= _amount);
365         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
366         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
367         Transfer(_owner, 0, _amount);
368         return true;
369     }
370 ////////////////
371 // Enable tokens transfers
372 ////////////////
373     /// @notice Enables token holders to transfer their tokens freely if true
374     /// @param _transfersEnabled True if transfers are allowed in the clone
375     function enableTransfers(bool _transfersEnabled) public onlyController {
376         transfersEnabled = _transfersEnabled;
377     }
378 ////////////////
379 // Internal helper functions to query and set a value in a snapshot array
380 ////////////////
381     /// @dev `getValueAt` retrieves the number of tokens at a given block number
382     /// @param checkpoints The history of values being queried
383     /// @param _block The block number to retrieve the value at
384     /// @return The number of tokens being queried
385     function getValueAt(Checkpoint[] storage checkpoints, uint _block
386     ) constant internal returns (uint) {
387         if (checkpoints.length == 0) return 0;
388         // Shortcut for the actual value
389         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
390             return checkpoints[checkpoints.length-1].value;
391         if (_block < checkpoints[0].fromBlock) return 0;
392         // Binary search of the value in the array
393         uint min = 0;
394         uint max = checkpoints.length-1;
395         while (max > min) {
396             uint mid = (max + min + 1)/ 2;
397             if (checkpoints[mid].fromBlock<=_block) {
398                 min = mid;
399             } else {
400                 max = mid-1;
401             }
402         }
403         return checkpoints[min].value;
404     }
405     /// @dev `updateValueAtNow` used to update the `balances` map and the
406     ///  `totalSupplyHistory`
407     /// @param checkpoints The history of data being updated
408     /// @param _value The new number of tokens
409     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
410     ) internal  {
411         if ((checkpoints.length == 0)
412         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
413                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
414                newCheckPoint.fromBlock =  uint128(block.number);
415                newCheckPoint.value = uint128(_value);
416            } else {
417                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
418                oldCheckPoint.value = uint128(_value);
419            }
420     }
421     /// @dev Internal function to determine if an address is a contract
422     /// @param _addr The address being queried
423     /// @return True if `_addr` is a contract
424     function isContract(address _addr) constant internal returns(bool) {
425         uint size;
426         if (_addr == 0) return false;
427         assembly {
428             size := extcodesize(_addr)
429         }
430         return size>0;
431     }
432     /// @dev Helper function to return a min betwen the two uints
433     function min(uint a, uint b) pure internal returns (uint) {
434         return a < b ? a : b;
435     }
436     /// @notice The fallback function: If the contract's controller has not been
437     ///  set to 0, then the `proxyPayment` method is called which relays the
438     ///  ether and creates tokens as described in the token controller contract
439     function () public payable {
440         require(isContract(controller));
441         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
442     }
443 //////////
444 // Safety Methods
445 //////////
446     /// @notice This method can be used by the controller to extract mistakenly
447     ///  sent tokens to this contract.
448     /// @param _token The address of the token contract that you want to recover
449     ///  set to 0 in case you want to extract ether.
450     function claimTokens(address _token) public onlyController {
451         if (_token == 0x0) {
452             controller.transfer(this.balance);
453             return;
454         }
455         MiniMeToken token = MiniMeToken(_token);
456         uint balance = token.balanceOf(this);
457         token.transfer(controller, balance);
458         ClaimedTokens(_token, controller, balance);
459     }
460 ////////////////
461 // Events
462 ////////////////
463     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
464     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
465     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
466     event Approval(
467         address indexed _owner,
468         address indexed _spender,
469         uint256 _amount
470         );
471 }
472 ////////////////
473 // MiniMeTokenFactory
474 ////////////////
475 /// @dev This contract is used to generate clone contracts from a contract.
476 ///  In solidity this is the way to create a contract from a contract of the
477 ///  same class
478 contract MiniMeTokenFactory {
479     /// @notice Update the DApp by creating a new token with new functionalities
480     ///  the msg.sender becomes the controller of this clone token
481     /// @param _parentToken Address of the token being cloned
482     /// @param _snapshotBlock Block of the parent token that will
483     ///  determine the initial distribution of the clone token
484     /// @param _tokenName Name of the new token
485     /// @param _decimalUnits Number of decimals of the new token
486     /// @param _tokenSymbol Token Symbol for the new token
487     /// @param _transfersEnabled If true, tokens will be able to be transferred
488     /// @return The address of the new token contract
489     function createCloneToken(
490         address _parentToken,
491         uint _snapshotBlock,
492         string _tokenName,
493         uint8 _decimalUnits,
494         string _tokenSymbol,
495         bool _transfersEnabled
496     ) public returns (MiniMeToken) {
497         MiniMeToken newToken = new MiniMeToken(
498             this,
499             _parentToken,
500             _snapshotBlock,
501             _tokenName,
502             _decimalUnits,
503             _tokenSymbol,
504             _transfersEnabled
505             );
506         newToken.changeController(msg.sender);
507         return newToken;
508     }
509 }
510 contract ATC is MiniMeToken {
511   mapping (address => bool) public blacklisted;
512   bool public generateFinished;
513   // @dev ATC constructor just parametrizes the MiniMeToken constructor
514   function ATC(address _tokenFactory)
515           MiniMeToken(
516               _tokenFactory,
517               0x0,                     // no parent token
518               0,                       // no snapshot block number from parent
519               "ATCon Token",  // Token name
520               18,                      // Decimals
521               "ATC",                   // Symbol
522               false                     // Enable transfers
523           ) {}
524   function generateTokens(address _owner, uint _amount
525       ) public onlyController returns (bool) {
526         require(generateFinished == false);
527         //check msg.sender (controller ??)
528         return super.generateTokens(_owner, _amount);
529       }
530   function doTransfer(address _from, address _to, uint _amount
531       ) internal returns(bool) {
532         require(blacklisted[_from] == false);
533         return super.doTransfer(_from, _to, _amount);
534       }
535   function finishGenerating() public onlyController returns (bool success) {
536     generateFinished = true;
537     return true;
538   }
539   function blacklistAccount(address tokenOwner) public onlyController returns (bool success) {
540     blacklisted[tokenOwner] = true;
541     return true;
542   }
543   function unBlacklistAccount(address tokenOwner) public onlyController returns (bool success) {
544     blacklisted[tokenOwner] = false;
545     return true;
546   }
547 }