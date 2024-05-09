1 pragma solidity ^0.4.18;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 contract SafeMath {
7   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12   function div(uint256 a, uint256 b) internal constant returns (uint256) {
13     // assert(b > 0); // Solidity automatically throws when dividing by 0
14     uint256 c = a / b;
15     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
16     return c;
17   }
18   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
28     return a >= b ? a : b;
29   }
30   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
31     return a < b ? a : b;
32   }
33   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
34     return a >= b ? a : b;
35   }
36   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
37     return a < b ? a : b;
38   }
39 }
40 /**
41  * @title ERC20Basic
42  * @dev Simpler version of ERC20 interface
43  * @dev see https://github.com/ethereum/EIPs/issues/179
44  */
45 contract ERC20Basic {
46   uint256 public totalSupply;
47   function balanceOf(address who) public view returns (uint256);
48   function transfer(address to, uint256 value) public returns (bool);
49   event Transfer(address indexed from, address indexed to, uint256 value);
50 }
51 /**
52  * @title ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/20
54  */
55 contract ERC20 is ERC20Basic {
56   function allowance(address owner, address spender) public view returns (uint256);
57   function transferFrom(address from, address to, uint256 value) public returns (bool);
58   function approve(address spender, uint256 value) public returns (bool);
59   event Approval(address indexed owner, address indexed spender, uint256 value);
60 }
61 /**
62  * @title SafeERC20
63  * @dev Wrappers around ERC20 operations that throw on failure.
64  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
65  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
66  */
67 library SafeERC20 {
68   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
69     assert(token.transfer(to, value));
70   }
71   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
72     assert(token.transferFrom(from, to, value));
73   }
74   function safeApprove(ERC20 token, address spender, uint256 value) internal {
75     assert(token.approve(spender, value));
76   }
77 }
78 /**
79  * @title Ownable
80  * @dev The Ownable contract has an owner address, and provides basic authorization control
81  * functions, this simplifies the implementation of "user permissions".
82  */
83 contract Ownable {
84   address public owner;
85   /**
86    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
87    * account.
88    */
89   function Ownable() {
90     owner = msg.sender;
91   }
92   /**
93    * @dev Throws if called by any account other than the owner.
94    */
95   modifier onlyOwner() {
96     require(msg.sender == owner);
97     _;
98   }
99   /**
100    * @dev Allows the current owner to transfer control of the contract to a newOwner.
101    * @param newOwner The address to transfer ownership to.
102    */
103   function transferOwnership(address newOwner) onlyOwner {
104     require(newOwner != address(0));
105     owner = newOwner;
106   }
107 }
108 /**
109  * @title KYC
110  * @dev KYC contract handles the white list for ASTCrowdsale contract
111  * Only accounts registered in KYC contract can buy AST token.
112  * Admins can register account, and the reason why
113  */
114 contract KYC is Ownable {
115   // check the address is registered for token sale
116   mapping (address => bool) public registeredAddress;
117   // check the address is admin of kyc contract
118   mapping (address => bool) public admin;
119   event Registered(address indexed _addr);
120   event Unregistered(address indexed _addr);
121   event NewAdmin(address indexed _addr);
122   event ClaimedTokens(address _token, address owner, uint256 balance);
123   /**
124    * @dev check whether the address is registered for token sale or not.
125    * @param _addr address
126    */
127   modifier onlyRegistered(address _addr) {
128     require(registeredAddress[_addr]);
129     _;
130   }
131   /**
132    * @dev check whether the msg.sender is admin or not
133    */
134   modifier onlyAdmin() {
135     require(admin[msg.sender]);
136     _;
137   }
138   function KYC() {
139     admin[msg.sender] = true;
140   }
141   /**
142    * @dev set new admin as admin of KYC contract
143    * @param _addr address The address to set as admin of KYC contract
144    */
145   function setAdmin(address _addr)
146     public
147     onlyOwner
148   {
149     require(_addr != address(0) && admin[_addr] == false);
150     admin[_addr] = true;
151     NewAdmin(_addr);
152   }
153   /**
154    * @dev register the address for token sale
155    * @param _addr address The address to register for token sale
156    */
157   function register(address _addr)
158     public
159     onlyAdmin
160   {
161     require(_addr != address(0) && registeredAddress[_addr] == false);
162     registeredAddress[_addr] = true;
163     Registered(_addr);
164   }
165   /**
166    * @dev register the addresses for token sale
167    * @param _addrs address[] The addresses to register for token sale
168    */
169   function registerByList(address[] _addrs)
170     public
171     onlyAdmin
172   {
173     for(uint256 i = 0; i < _addrs.length; i++) {
174       require(_addrs[i] != address(0) && registeredAddress[_addrs[i]] == false);
175       registeredAddress[_addrs[i]] = true;
176       Registered(_addrs[i]);
177     }
178   }
179   /**
180    * @dev unregister the registered address
181    * @param _addr address The address to unregister for token sale
182    */
183   function unregister(address _addr)
184     public
185     onlyAdmin
186     onlyRegistered(_addr)
187   {
188     registeredAddress[_addr] = false;
189     Unregistered(_addr);
190   }
191   /**
192    * @dev unregister the registered addresses
193    * @param _addrs address[] The addresses to unregister for token sale
194    */
195   function unregisterByList(address[] _addrs)
196     public
197     onlyAdmin
198   {
199     for(uint256 i = 0; i < _addrs.length; i++) {
200       require(registeredAddress[_addrs[i]]);
201       registeredAddress[_addrs[i]] = false;
202       Unregistered(_addrs[i]);
203     }
204   }
205   function claimTokens(address _token) public onlyOwner {
206     if (_token == 0x0) {
207         owner.transfer(this.balance);
208         return;
209     }
210     ERC20Basic token = ERC20Basic(_token);
211     uint256 balance = token.balanceOf(this);
212     token.transfer(owner, balance);
213     ClaimedTokens(_token, owner, balance);
214   }
215 }
216 /*
217     Copyright 2016, Jordi Baylina
218     This program is free software: you can redistribute it and/or modify
219     it under the terms of the GNU General Public License as published by
220     the Free Software Foundation, either version 3 of the License, or
221     (at your option) any later version.
222     This program is distributed in the hope that it will be useful,
223     but WITHOUT ANY WARRANTY; without even the implied warranty of
224     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
225     GNU General Public License for more details.
226     You should have received a copy of the GNU General Public License
227     along with this program.  If not, see <http://www.gnu.org/licenses/>.
228  */
229 /// @title MiniMeToken Contract
230 /// @author Jordi Baylina
231 /// @dev This token contract's goal is to make it easy for anyone to clone this
232 ///  token using the token distribution at a given block, this will allow DAO's
233 ///  and DApps to upgrade their features in a decentralized manner without
234 ///  affecting the original token
235 /// @dev It is ERC20 compliant, but still needs to under go further testing.
236 contract Controlled {
237     /// @notice The address of the controller is the only address that can call
238     ///  a function with this modifier
239     modifier onlyController { require(msg.sender == controller); _; }
240     address public controller;
241     function Controlled() public { controller = msg.sender;}
242     /// @notice Changes the controller of the contract
243     /// @param _newController The new controller of the contract
244     function changeController(address _newController) public onlyController {
245         controller = _newController;
246     }
247 }
248 /// @dev The token controller contract must implement these functions
249 contract TokenController {
250     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
251     /// @param _owner The address that sent the ether to create tokens
252     /// @return True if the ether is accepted, false if it throws
253     function proxyPayment(address _owner) public payable returns(bool);
254     /// @notice Notifies the controller about a token transfer allowing the
255     ///  controller to react if desired
256     /// @param _from The origin of the transfer
257     /// @param _to The destination of the transfer
258     /// @param _amount The amount of the transfer
259     /// @return False if the controller does not authorize the transfer
260     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
261     /// @notice Notifies the controller about an approval allowing the
262     ///  controller to react if desired
263     /// @param _owner The address that calls `approve()`
264     /// @param _spender The spender in the `approve()` call
265     /// @param _amount The amount in the `approve()` call
266     /// @return False if the controller does not authorize the approval
267     function onApprove(address _owner, address _spender, uint _amount) public
268         returns(bool);
269 }
270 contract ApproveAndCallFallBack {
271     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
272 }
273 /// @dev The actual token contract, the default controller is the msg.sender
274 ///  that deploys the contract, so usually this token will be deployed by a
275 ///  token controller contract, which Giveth will call a "Campaign"
276 contract MiniMeToken is Controlled {
277     string public name;                //The Token's name: e.g. DigixDAO Tokens
278     uint8 public decimals;             //Number of decimals of the smallest unit
279     string public symbol;              //An identifier: e.g. REP
280     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
281     /// @dev `Checkpoint` is the structure that attaches a block number to a
282     ///  given value, the block number attached is the one that last changed the
283     ///  value
284     struct  Checkpoint {
285         // `fromBlock` is the block number that the value was generated from
286         uint128 fromBlock;
287         // `value` is the amount of tokens at a specific block number
288         uint128 value;
289     }
290     // `parentToken` is the Token address that was cloned to produce this token;
291     //  it will be 0x0 for a token that was not cloned
292     MiniMeToken public parentToken;
293     // `parentSnapShotBlock` is the block number from the Parent Token that was
294     //  used to determine the initial distribution of the Clone Token
295     uint public parentSnapShotBlock;
296     // `creationBlock` is the block number that the Clone Token was created
297     uint public creationBlock;
298     // `balances` is the map that tracks the balance of each address, in this
299     //  contract when the balance changes the block number that the change
300     //  occurred is also included in the map
301     mapping (address => Checkpoint[]) balances;
302     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
303     mapping (address => mapping (address => uint256)) allowed;
304     // Tracks the history of the `totalSupply` of the token
305     Checkpoint[] totalSupplyHistory;
306     // Flag that determines if the token is transferable or not.
307     bool public transfersEnabled;
308     // The factory used to create new clone tokens
309     MiniMeTokenFactory public tokenFactory;
310 ////////////////
311 // Constructor
312 ////////////////
313     /// @notice Constructor to create a MiniMeToken
314     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
315     ///  will create the Clone token contracts, the token factory needs to be
316     ///  deployed first
317     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
318     ///  new token
319     /// @param _parentSnapShotBlock Block of the parent token that will
320     ///  determine the initial distribution of the clone token, set to 0 if it
321     ///  is a new token
322     /// @param _tokenName Name of the new token
323     /// @param _decimalUnits Number of decimals of the new token
324     /// @param _tokenSymbol Token Symbol for the new token
325     /// @param _transfersEnabled If true, tokens will be able to be transferred
326     function MiniMeToken(
327         address _tokenFactory,
328         address _parentToken,
329         uint _parentSnapShotBlock,
330         string _tokenName,
331         uint8 _decimalUnits,
332         string _tokenSymbol,
333         bool _transfersEnabled
334     ) public {
335         tokenFactory = MiniMeTokenFactory(_tokenFactory);
336         name = _tokenName;                                 // Set the name
337         decimals = _decimalUnits;                          // Set the decimals
338         symbol = _tokenSymbol;                             // Set the symbol
339         parentToken = MiniMeToken(_parentToken);
340         parentSnapShotBlock = _parentSnapShotBlock;
341         transfersEnabled = _transfersEnabled;
342         creationBlock = block.number;
343     }
344 ///////////////////
345 // ERC20 Methods
346 ///////////////////
347     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
348     /// @param _to The address of the recipient
349     /// @param _amount The amount of tokens to be transferred
350     /// @return Whether the transfer was successful or not
351     function transfer(address _to, uint256 _amount) public returns (bool success) {
352         require(transfersEnabled);
353         return doTransfer(msg.sender, _to, _amount);
354     }
355     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
356     ///  is approved by `_from`
357     /// @param _from The address holding the tokens being transferred
358     /// @param _to The address of the recipient
359     /// @param _amount The amount of tokens to be transferred
360     /// @return True if the transfer was successful
361     function transferFrom(address _from, address _to, uint256 _amount
362     ) public returns (bool success) {
363         // The controller of this contract can move tokens around at will,
364         //  this is important to recognize! Confirm that you trust the
365         //  controller of this contract, which in most situations should be
366         //  another open source smart contract or 0x0
367         if (msg.sender != controller) {
368             require(transfersEnabled);
369             // The standard ERC 20 transferFrom functionality
370             if (allowed[_from][msg.sender] < _amount) return false;
371             allowed[_from][msg.sender] -= _amount;
372         }
373         return doTransfer(_from, _to, _amount);
374     }
375     /// @dev This is the actual transfer function in the token contract, it can
376     ///  only be called by other functions in this contract.
377     /// @param _from The address holding the tokens being transferred
378     /// @param _to The address of the recipient
379     /// @param _amount The amount of tokens to be transferred
380     /// @return True if the transfer was successful
381     function doTransfer(address _from, address _to, uint _amount
382     ) internal returns(bool) {
383            if (_amount == 0) {
384                return true;
385            }
386            require(parentSnapShotBlock < block.number);
387            // Do not allow transfer to 0x0 or the token contract itself
388            require((_to != 0) && (_to != address(this)));
389            // If the amount being transfered is more than the balance of the
390            //  account the transfer returns false
391            var previousBalanceFrom = balanceOfAt(_from, block.number);
392            if (previousBalanceFrom < _amount) {
393                return false;
394            }
395            // Alerts the token controller of the transfer
396            if (isContract(controller)) {
397                require(TokenController(controller).onTransfer(_from, _to, _amount));
398            }
399            // First update the balance array with the new value for the address
400            //  sending the tokens
401            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
402            // Then update the balance array with the new value for the address
403            //  receiving the tokens
404            var previousBalanceTo = balanceOfAt(_to, block.number);
405            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
406            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
407            // An event to make the transfer easy to find on the blockchain
408            Transfer(_from, _to, _amount);
409            return true;
410     }
411     /// @param _owner The address that's balance is being requested
412     /// @return The balance of `_owner` at the current block
413     function balanceOf(address _owner) public constant returns (uint256 balance) {
414         return balanceOfAt(_owner, block.number);
415     }
416     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
417     ///  its behalf. This is a modified version of the ERC20 approve function
418     ///  to be a little bit safer
419     /// @param _spender The address of the account able to transfer the tokens
420     /// @param _amount The amount of tokens to be approved for transfer
421     /// @return True if the approval was successful
422     function approve(address _spender, uint256 _amount) public returns (bool success) {
423         require(transfersEnabled);
424         // To change the approve amount you first have to reduce the addresses`
425         //  allowance to zero by calling `approve(_spender,0)` if it is not
426         //  already 0 to mitigate the race condition described here:
427         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
428         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
429         // Alerts the token controller of the approve function call
430         if (isContract(controller)) {
431             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
432         }
433         allowed[msg.sender][_spender] = _amount;
434         Approval(msg.sender, _spender, _amount);
435         return true;
436     }
437     /// @dev This function makes it easy to read the `allowed[]` map
438     /// @param _owner The address of the account that owns the token
439     /// @param _spender The address of the account able to transfer the tokens
440     /// @return Amount of remaining tokens of _owner that _spender is allowed
441     ///  to spend
442     function allowance(address _owner, address _spender
443     ) public constant returns (uint256 remaining) {
444         return allowed[_owner][_spender];
445     }
446     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
447     ///  its behalf, and then a function is triggered in the contract that is
448     ///  being approved, `_spender`. This allows users to use their tokens to
449     ///  interact with contracts in one function call instead of two
450     /// @param _spender The address of the contract able to transfer the tokens
451     /// @param _amount The amount of tokens to be approved for transfer
452     /// @return True if the function call was successful
453     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
454     ) public returns (bool success) {
455         require(approve(_spender, _amount));
456         ApproveAndCallFallBack(_spender).receiveApproval(
457             msg.sender,
458             _amount,
459             this,
460             _extraData
461         );
462         return true;
463     }
464     /// @dev This function makes it easy to get the total number of tokens
465     /// @return The total number of tokens
466     function totalSupply() public constant returns (uint) {
467         return totalSupplyAt(block.number);
468     }
469 ////////////////
470 // Query balance and totalSupply in History
471 ////////////////
472     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
473     /// @param _owner The address from which the balance will be retrieved
474     /// @param _blockNumber The block number when the balance is queried
475     /// @return The balance at `_blockNumber`
476     function balanceOfAt(address _owner, uint _blockNumber) public constant
477         returns (uint) {
478         // These next few lines are used when the balance of the token is
479         //  requested before a check point was ever created for this token, it
480         //  requires that the `parentToken.balanceOfAt` be queried at the
481         //  genesis block for that token as this contains initial balance of
482         //  this token
483         if ((balances[_owner].length == 0)
484             || (balances[_owner][0].fromBlock > _blockNumber)) {
485             if (address(parentToken) != 0) {
486                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
487             } else {
488                 // Has no parent
489                 return 0;
490             }
491         // This will return the expected balance during normal situations
492         } else {
493             return getValueAt(balances[_owner], _blockNumber);
494         }
495     }
496     /// @notice Total amount of tokens at a specific `_blockNumber`.
497     /// @param _blockNumber The block number when the totalSupply is queried
498     /// @return The total amount of tokens at `_blockNumber`
499     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
500         // These next few lines are used when the totalSupply of the token is
501         //  requested before a check point was ever created for this token, it
502         //  requires that the `parentToken.totalSupplyAt` be queried at the
503         //  genesis block for this token as that contains totalSupply of this
504         //  token at this block number.
505         if ((totalSupplyHistory.length == 0)
506             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
507             if (address(parentToken) != 0) {
508                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
509             } else {
510                 return 0;
511             }
512         // This will return the expected totalSupply during normal situations
513         } else {
514             return getValueAt(totalSupplyHistory, _blockNumber);
515         }
516     }
517 ////////////////
518 // Clone Token Method
519 ////////////////
520     /// @notice Creates a new clone token with the initial distribution being
521     ///  this token at `_snapshotBlock`
522     /// @param _cloneTokenName Name of the clone token
523     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
524     /// @param _cloneTokenSymbol Symbol of the clone token
525     /// @param _snapshotBlock Block when the distribution of the parent token is
526     ///  copied to set the initial distribution of the new clone token;
527     ///  if the block is zero than the actual block, the current block is used
528     /// @param _transfersEnabled True if transfers are allowed in the clone
529     /// @return The address of the new MiniMeToken Contract
530     function createCloneToken(
531         string _cloneTokenName,
532         uint8 _cloneDecimalUnits,
533         string _cloneTokenSymbol,
534         uint _snapshotBlock,
535         bool _transfersEnabled
536         ) public returns(address) {
537         if (_snapshotBlock == 0) _snapshotBlock = block.number;
538         MiniMeToken cloneToken = tokenFactory.createCloneToken(
539             this,
540             _snapshotBlock,
541             _cloneTokenName,
542             _cloneDecimalUnits,
543             _cloneTokenSymbol,
544             _transfersEnabled
545             );
546         cloneToken.changeController(msg.sender);
547         // An event to make the token easy to find on the blockchain
548         NewCloneToken(address(cloneToken), _snapshotBlock);
549         return address(cloneToken);
550     }
551 ////////////////
552 // Generate and destroy tokens
553 ////////////////
554     /// @notice Generates `_amount` tokens that are assigned to `_owner`
555     /// @param _owner The address that will be assigned the new tokens
556     /// @param _amount The quantity of tokens generated
557     /// @return True if the tokens are generated correctly
558     function generateTokens(address _owner, uint _amount
559     ) public onlyController returns (bool) {
560         uint curTotalSupply = totalSupply();
561         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
562         uint previousBalanceTo = balanceOf(_owner);
563         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
564         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
565         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
566         Transfer(0, _owner, _amount);
567         return true;
568     }
569     /// @notice Burns `_amount` tokens from `_owner`
570     /// @param _owner The address that will lose the tokens
571     /// @param _amount The quantity of tokens to burn
572     /// @return True if the tokens are burned correctly
573     function destroyTokens(address _owner, uint _amount
574     ) onlyController public returns (bool) {
575         uint curTotalSupply = totalSupply();
576         require(curTotalSupply >= _amount);
577         uint previousBalanceFrom = balanceOf(_owner);
578         require(previousBalanceFrom >= _amount);
579         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
580         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
581         Transfer(_owner, 0, _amount);
582         return true;
583     }
584 ////////////////
585 // Enable tokens transfers
586 ////////////////
587     /// @notice Enables token holders to transfer their tokens freely if true
588     /// @param _transfersEnabled True if transfers are allowed in the clone
589     function enableTransfers(bool _transfersEnabled) public onlyController {
590         transfersEnabled = _transfersEnabled;
591     }
592 ////////////////
593 // Internal helper functions to query and set a value in a snapshot array
594 ////////////////
595     /// @dev `getValueAt` retrieves the number of tokens at a given block number
596     /// @param checkpoints The history of values being queried
597     /// @param _block The block number to retrieve the value at
598     /// @return The number of tokens being queried
599     function getValueAt(Checkpoint[] storage checkpoints, uint _block
600     ) constant internal returns (uint) {
601         if (checkpoints.length == 0) return 0;
602         // Shortcut for the actual value
603         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
604             return checkpoints[checkpoints.length-1].value;
605         if (_block < checkpoints[0].fromBlock) return 0;
606         // Binary search of the value in the array
607         uint min = 0;
608         uint max = checkpoints.length-1;
609         while (max > min) {
610             uint mid = (max + min + 1)/ 2;
611             if (checkpoints[mid].fromBlock<=_block) {
612                 min = mid;
613             } else {
614                 max = mid-1;
615             }
616         }
617         return checkpoints[min].value;
618     }
619     /// @dev `updateValueAtNow` used to update the `balances` map and the
620     ///  `totalSupplyHistory`
621     /// @param checkpoints The history of data being updated
622     /// @param _value The new number of tokens
623     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
624     ) internal  {
625         if ((checkpoints.length == 0)
626         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
627                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
628                newCheckPoint.fromBlock =  uint128(block.number);
629                newCheckPoint.value = uint128(_value);
630            } else {
631                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
632                oldCheckPoint.value = uint128(_value);
633            }
634     }
635     /// @dev Internal function to determine if an address is a contract
636     /// @param _addr The address being queried
637     /// @return True if `_addr` is a contract
638     function isContract(address _addr) constant internal returns(bool) {
639         uint size;
640         if (_addr == 0) return false;
641         assembly {
642             size := extcodesize(_addr)
643         }
644         return size>0;
645     }
646     /// @dev Helper function to return a min betwen the two uints
647     function min(uint a, uint b) pure internal returns (uint) {
648         return a < b ? a : b;
649     }
650     /// @notice The fallback function: If the contract's controller has not been
651     ///  set to 0, then the `proxyPayment` method is called which relays the
652     ///  ether and creates tokens as described in the token controller contract
653     function () public payable {
654         require(isContract(controller));
655         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
656     }
657 //////////
658 // Safety Methods
659 //////////
660     /// @notice This method can be used by the controller to extract mistakenly
661     ///  sent tokens to this contract.
662     /// @param _token The address of the token contract that you want to recover
663     ///  set to 0 in case you want to extract ether.
664     function claimTokens(address _token) public onlyController {
665         if (_token == 0x0) {
666             controller.transfer(this.balance);
667             return;
668         }
669         MiniMeToken token = MiniMeToken(_token);
670         uint balance = token.balanceOf(this);
671         token.transfer(controller, balance);
672         ClaimedTokens(_token, controller, balance);
673     }
674 ////////////////
675 // Events
676 ////////////////
677     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
678     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
679     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
680     event Approval(
681         address indexed _owner,
682         address indexed _spender,
683         uint256 _amount
684         );
685 }
686 ////////////////
687 // MiniMeTokenFactory
688 ////////////////
689 /// @dev This contract is used to generate clone contracts from a contract.
690 ///  In solidity this is the way to create a contract from a contract of the
691 ///  same class
692 contract MiniMeTokenFactory {
693     /// @notice Update the DApp by creating a new token with new functionalities
694     ///  the msg.sender becomes the controller of this clone token
695     /// @param _parentToken Address of the token being cloned
696     /// @param _snapshotBlock Block of the parent token that will
697     ///  determine the initial distribution of the clone token
698     /// @param _tokenName Name of the new token
699     /// @param _decimalUnits Number of decimals of the new token
700     /// @param _tokenSymbol Token Symbol for the new token
701     /// @param _transfersEnabled If true, tokens will be able to be transferred
702     /// @return The address of the new token contract
703     function createCloneToken(
704         address _parentToken,
705         uint _snapshotBlock,
706         string _tokenName,
707         uint8 _decimalUnits,
708         string _tokenSymbol,
709         bool _transfersEnabled
710     ) public returns (MiniMeToken) {
711         MiniMeToken newToken = new MiniMeToken(
712             this,
713             _parentToken,
714             _snapshotBlock,
715             _tokenName,
716             _decimalUnits,
717             _tokenSymbol,
718             _transfersEnabled
719             );
720         newToken.changeController(msg.sender);
721         return newToken;
722     }
723 }
724 contract ATC is MiniMeToken {
725   mapping (address => bool) public blacklisted;
726   bool public generateFinished;
727   // @dev ATC constructor just parametrizes the MiniMeToken constructor
728   function ATC(address _tokenFactory)
729           MiniMeToken(
730               _tokenFactory,
731               0x0,                     // no parent token
732               0,                       // no snapshot block number from parent
733               "Aston Token",  // Token name
734               18,                      // Decimals
735               "ATC",                   // Symbol
736               false                     // Enable transfers
737           ) {}
738   function generateTokens(address _owner, uint _amount
739       ) public onlyController returns (bool) {
740         require(generateFinished == false);
741         //check msg.sender (controller ??)
742         return super.generateTokens(_owner, _amount);
743       }
744   function doTransfer(address _from, address _to, uint _amount
745       ) internal returns(bool) {
746         require(blacklisted[_from] == false);
747         return super.doTransfer(_from, _to, _amount);
748       }
749   function finishGenerating() public onlyController returns (bool success) {
750     generateFinished = true;
751     return true;
752   }
753   function blacklistAccount(address tokenOwner) public onlyController returns (bool success) {
754     blacklisted[tokenOwner] = true;
755     return true;
756   }
757   function unBlacklistAccount(address tokenOwner) public onlyController returns (bool success) {
758     blacklisted[tokenOwner] = false;
759     return true;
760   }
761 }
762 /**
763  * @title RefundVault
764  * @dev This contract is used for storing funds while a crowdsale
765  * is in progress. Supports refunding the money if crowdsale fails,
766  * and forwarding it if crowdsale is successful.
767  */
768 contract RefundVault is Ownable, SafeMath{
769   enum State { Active, Refunding, Closed }
770   mapping (address => uint256) public deposited;
771   mapping (address => uint256) public refunded;
772   State public state;
773   address[] public reserveWallet;
774   event Closed();
775   event RefundsEnabled();
776   event Refunded(address indexed beneficiary, uint256 weiAmount);
777   /**
778    * @dev This constructor sets the addresses of
779    * 10 reserve wallets.
780    * and forwarding it if crowdsale is successful.
781    * @param _reserveWallet address[5] The addresses of reserve wallet.
782    */
783   function RefundVault(address[] _reserveWallet) {
784     state = State.Active;
785     reserveWallet = _reserveWallet;
786   }
787   /**
788    * @dev This function is called when user buy tokens. Only RefundVault
789    * contract stores the Ether user sent which forwarded from crowdsale
790    * contract.
791    * @param investor address The address who buy the token from crowdsale.
792    */
793   function deposit(address investor) onlyOwner payable {
794     require(state == State.Active);
795     deposited[investor] = add(deposited[investor], msg.value);
796   }
797   event Transferred(address _to, uint _value);
798   /**
799    * @dev This function is called when crowdsale is successfully finalized.
800    */
801   function close() onlyOwner {
802     require(state == State.Active);
803     state = State.Closed;
804     uint256 balance = this.balance;
805     uint256 reserveAmountForEach = div(balance, reserveWallet.length);
806     for(uint8 i = 0; i < reserveWallet.length; i++){
807       reserveWallet[i].transfer(reserveAmountForEach);
808       Transferred(reserveWallet[i], reserveAmountForEach);
809     }
810     Closed();
811   }
812   /**
813    * @dev This function is called when crowdsale is unsuccessfully finalized
814    * and refund is required.
815    */
816   function enableRefunds() onlyOwner {
817     require(state == State.Active);
818     state = State.Refunding;
819     RefundsEnabled();
820   }
821   /**
822    * @dev This function allows for user to refund Ether.
823    */
824   function refund(address investor) returns (bool) {
825     require(state == State.Refunding);
826     if (refunded[investor] > 0) {
827       return false;
828     }
829     uint256 depositedValue = deposited[investor];
830     deposited[investor] = 0;
831     refunded[investor] = depositedValue;
832     investor.transfer(depositedValue);
833     Refunded(investor, depositedValue);
834     return true;
835   }
836 }
837 /**
838  * @title Pausable
839  * @dev Base contract which allows children to implement an emergency stop mechanism.
840  */
841 contract Pausable is Ownable {
842   event Pause();
843   event Unpause();
844   bool public paused = false;
845   /**
846    * @dev modifier to allow actions only when the contract IS paused
847    */
848   modifier whenNotPaused() {
849     require(!paused);
850     _;
851   }
852   /**
853    * @dev modifier to allow actions only when the contract IS NOT paused
854    */
855   modifier whenPaused() {
856     require(paused);
857     _;
858   }
859   /**
860    * @dev called by the owner to pause, triggers stopped state
861    */
862   function pause() onlyOwner whenNotPaused {
863     paused = true;
864     Pause();
865   }
866   /**
867    * @dev called by the owner to unpause, returns to normal state
868    */
869   function unpause() onlyOwner whenPaused {
870     paused = false;
871     Unpause();
872   }
873 }
874 contract ATCCrowdSale is Ownable, SafeMath, Pausable {
875   KYC public kyc;
876   ATC public token;
877   RefundVault public vault;
878   address public presale;
879   address public bountyAddress; //5% for bounty
880   address public partnersAddress; //15% for community groups & partners
881   address public ATCReserveLocker; //15% with 2 years lock
882   address public teamLocker; // 15% with 2 years vesting
883   struct Period {
884     uint256 startTime;
885     uint256 endTime;
886     uint256 bonus; // used to calculate rate with bonus. ragne 0 ~ 15 (0% ~ 15%)
887   }
888   uint256 public baseRate; // 1 ETH = 1500 ATC
889   uint256[] public additionalBonusAmounts;
890   Period[] public periods;
891   uint8 constant public MAX_PERIOD_COUNT = 8;
892   uint256 public weiRaised;
893   uint256 public maxEtherCap;
894   uint256 public minEtherCap;
895   mapping (address => uint256) public beneficiaryFunded;
896   address[] investorList;
897   mapping (address => bool) inInvestorList;
898   address public ATCController;
899   bool public isFinalized;
900   uint256 public refundCompleted;
901   bool public presaleFallBackCalled;
902   uint256 public finalizedTime;
903   bool public initialized;
904   event CrowdSaleTokenPurchase(address indexed _investor, address indexed _beneficiary, uint256 _toFund, uint256 _tokens);
905   event StartPeriod(uint256 _startTime, uint256 _endTime, uint256 _bonus);
906   event Finalized();
907   event PresaleFallBack(uint256 _presaleWeiRaised);
908   event PushInvestorList(address _investor);
909   event RefundAll(uint256 _numToRefund);
910   event ClaimedTokens(address _claimToken, address owner, uint256 balance);
911   event Initialize();
912   function initialize (
913     address _kyc,
914     address _token,
915     address _vault,
916     address _presale,
917     address _bountyAddress,
918     address _partnersAddress,
919     address _ATCReserveLocker,
920     address _teamLocker,
921     address _tokenController,
922     uint256 _maxEtherCap,
923     uint256 _minEtherCap,
924     uint256 _baseRate,
925     uint256[] _additionalBonusAmounts
926     ) onlyOwner {
927       require(!initialized);
928       require(_kyc != 0x00 && _token != 0x00 && _vault != 0x00 && _presale != 0x00);
929       require(_bountyAddress != 0x00 && _partnersAddress != 0x00);
930       require(_ATCReserveLocker != 0x00 && _teamLocker != 0x00);
931       require(_tokenController != 0x00);
932       require(0 < _minEtherCap && _minEtherCap < _maxEtherCap);
933       require(_baseRate > 0);
934       require(_additionalBonusAmounts[0] > 0);
935       for (uint i = 0; i < _additionalBonusAmounts.length - 1; i++) {
936         require(_additionalBonusAmounts[i] < _additionalBonusAmounts[i + 1]);
937       }
938       kyc = KYC(_kyc);
939       token = ATC(_token);
940       vault = RefundVault(_vault);
941       presale = _presale;
942       bountyAddress = _bountyAddress;
943       partnersAddress = _partnersAddress;
944       ATCReserveLocker = _ATCReserveLocker;
945       teamLocker = _teamLocker;
946       ATCController = _tokenController;
947       maxEtherCap = _maxEtherCap;
948       minEtherCap = _minEtherCap;
949       baseRate = _baseRate;
950       additionalBonusAmounts = _additionalBonusAmounts;
951       initialized = true;
952       Initialize();
953     }
954   function () public payable {
955     buy(msg.sender);
956   }
957   function presaleFallBack(uint256 _presaleWeiRaised) public returns (bool) {
958     require(!presaleFallBackCalled);
959     require(msg.sender == presale);
960     weiRaised = _presaleWeiRaised;
961     presaleFallBackCalled = true;
962     PresaleFallBack(_presaleWeiRaised);
963     return true;
964   }
965   function buy(address beneficiary)
966     public
967     payable
968     whenNotPaused
969   {
970       // check validity
971       require(presaleFallBackCalled);
972       require(beneficiary != 0x00);
973       require(kyc.registeredAddress(beneficiary));
974       require(onSale());
975       require(validPurchase());
976       require(!isFinalized);
977       // calculate eth amount
978       uint256 weiAmount = msg.value;
979       uint256 toFund;
980       uint256 postWeiRaised = add(weiRaised, weiAmount);
981       if (postWeiRaised > maxEtherCap) {
982         toFund = sub(maxEtherCap, weiRaised);
983       } else {
984         toFund = weiAmount;
985       }
986       require(toFund > 0);
987       require(weiAmount >= toFund);
988       uint256 rate = calculateRate(toFund);
989       uint256 tokens = mul(toFund, rate);
990       uint256 toReturn = sub(weiAmount, toFund);
991       pushInvestorList(msg.sender);
992       weiRaised = add(weiRaised, toFund);
993       beneficiaryFunded[beneficiary] = add(beneficiaryFunded[beneficiary], toFund);
994       token.generateTokens(beneficiary, tokens);
995       if (toReturn > 0) {
996         msg.sender.transfer(toReturn);
997       }
998       forwardFunds(toFund);
999       CrowdSaleTokenPurchase(msg.sender, beneficiary, toFund, tokens);
1000   }
1001   function pushInvestorList(address investor) internal {
1002     if (!inInvestorList[investor]) {
1003       inInvestorList[investor] = true;
1004       investorList.push(investor);
1005       PushInvestorList(investor);
1006     }
1007   }
1008   function validPurchase() internal view returns (bool) {
1009     bool nonZeroPurchase = msg.value != 0;
1010     return nonZeroPurchase && !maxReached();
1011   }
1012   function forwardFunds(uint256 toFund) internal {
1013     vault.deposit.value(toFund)(msg.sender);
1014   }
1015   /**
1016    * @dev Checks whether minEtherCap is reached
1017    * @return true if min ether cap is reaced
1018    */
1019   function minReached() public view returns (bool) {
1020     return weiRaised >= minEtherCap;
1021   }
1022   /**
1023    * @dev Checks whether maxEtherCap is reached
1024    * @return true if max ether cap is reaced
1025    */
1026   function maxReached() public view returns (bool) {
1027     return weiRaised == maxEtherCap;
1028   }
1029   function getPeriodBonus() public view returns (uint256) {
1030     bool nowOnSale;
1031     uint256 currentPeriod;
1032     for (uint i = 0; i < periods.length; i++) {
1033       if (periods[i].startTime <= now && now <= periods[i].endTime) {
1034         nowOnSale = true;
1035         currentPeriod = i;
1036         break;
1037       }
1038     }
1039     require(nowOnSale);
1040     return periods[currentPeriod].bonus;
1041   }
1042   /**
1043    * @dev rate = baseRate * (100 + bonus) / 100
1044    */
1045   function calculateRate(uint256 toFund) public view returns (uint256)  {
1046     uint bonus = getPeriodBonus();
1047     // bonus for eth amount
1048     if (additionalBonusAmounts[0] <= toFund) {
1049       bonus = add(bonus, 5); // 5% amount bonus for more than 300 ETH
1050     }
1051     if (additionalBonusAmounts[1] <= toFund) {
1052       bonus = add(bonus, 5); // 10% amount bonus for more than 6000 ETH
1053     }
1054     if (additionalBonusAmounts[2] <= toFund) {
1055       bonus = 25; // final 25% amount bonus for more than 8000 ETH
1056     }
1057     if (additionalBonusAmounts[3] <= toFund) {
1058       bonus = 30; // final 30% amount bonus for more than 10000 ETH
1059     }
1060     return div(mul(baseRate, add(bonus, 100)), 100);
1061   }
1062   function startPeriod(uint256 _startTime, uint256 _endTime) public onlyOwner returns (bool) {
1063     require(periods.length < MAX_PERIOD_COUNT);
1064     require(now < _startTime && _startTime < _endTime);
1065     if (periods.length != 0) {
1066       require(sub(_endTime, _startTime) <= 7 days);
1067       require(periods[periods.length - 1].endTime < _startTime);
1068     }
1069     // 15% -> 10% -> 5% -> 0%
1070     Period memory newPeriod;
1071     newPeriod.startTime = _startTime;
1072     newPeriod.endTime = _endTime;
1073     if(periods.length < 3) {
1074       newPeriod.bonus = sub(15, mul(5, periods.length));
1075     } else {
1076       newPeriod.bonus = 0;
1077     }
1078     periods.push(newPeriod);
1079     StartPeriod(_startTime, _endTime, newPeriod.bonus);
1080     return true;
1081   }
1082   function onSale() public returns (bool) {
1083     bool nowOnSale;
1084     for (uint i = 0; i < periods.length; i++) {
1085       if (periods[i].startTime <= now && now <= periods[i].endTime) {
1086         nowOnSale = true;
1087         break;
1088       }
1089     }
1090     return nowOnSale;
1091   }
1092   /**
1093    * @dev should be called after crowdsale ends, to do
1094    */
1095   function finalize() onlyOwner {
1096     require(!isFinalized);
1097     require(!onSale() || maxReached());
1098     finalizedTime = now;
1099     finalization();
1100     Finalized();
1101     isFinalized = true;
1102   }
1103   /**
1104    * @dev end token minting on finalization, mint tokens for dev team and reserve wallets
1105    */
1106   function finalization() internal {
1107     if (minReached()) {
1108       vault.close();
1109       uint256 totalToken = token.totalSupply();
1110       // token distribution : 50% for sale, 5% for bounty, 15% for partners, 15% for reserve, 15% for team
1111       uint256 bountyAmount = div(mul(totalToken, 5), 50);
1112       uint256 partnersAmount = div(mul(totalToken, 15), 50);
1113       uint256 reserveAmount = div(mul(totalToken, 15), 50);
1114       uint256 teamAmount = div(mul(totalToken, 15), 50);
1115       distributeToken(bountyAmount, partnersAmount, reserveAmount, teamAmount);
1116       token.enableTransfers(true);
1117     } else {
1118       vault.enableRefunds();
1119     }
1120     token.finishGenerating();
1121     token.changeController(ATCController);
1122   }
1123   function distributeToken(uint256 bountyAmount, uint256 partnersAmount, uint256 reserveAmount, uint256 teamAmount) internal {
1124     require(bountyAddress != 0x00 && partnersAddress != 0x00);
1125     require(ATCReserveLocker != 0x00 && teamLocker != 0x00);
1126     token.generateTokens(bountyAddress, bountyAmount);
1127     token.generateTokens(partnersAddress, partnersAmount);
1128     token.generateTokens(ATCReserveLocker, reserveAmount);
1129     token.generateTokens(teamLocker, teamAmount);
1130   }
1131   /**
1132    * @dev refund a lot of investors at a time checking onlyOwner
1133    * @param numToRefund uint256 The number of investors to refund
1134    */
1135   function refundAll(uint256 numToRefund) onlyOwner {
1136     require(isFinalized);
1137     require(!minReached());
1138     require(numToRefund > 0);
1139     uint256 limit = refundCompleted + numToRefund;
1140     if (limit > investorList.length) {
1141       limit = investorList.length;
1142     }
1143     for(uint256 i = refundCompleted; i < limit; i++) {
1144       vault.refund(investorList[i]);
1145     }
1146     refundCompleted = limit;
1147     RefundAll(numToRefund);
1148   }
1149   /**
1150    * @dev if crowdsale is unsuccessful, investors can claim refunds here
1151    * @param investor address The account to be refunded
1152    */
1153   function claimRefund(address investor) returns (bool) {
1154     require(isFinalized);
1155     require(!minReached());
1156     return vault.refund(investor);
1157   }
1158   function claimTokens(address _claimToken) public onlyOwner {
1159     if (token.controller() == address(this)) {
1160          token.claimTokens(_claimToken);
1161     }
1162     if (_claimToken == 0x0) {
1163         owner.transfer(this.balance);
1164         return;
1165     }
1166     ERC20Basic claimToken = ERC20Basic(_claimToken);
1167     uint256 balance = claimToken.balanceOf(this);
1168     claimToken.transfer(owner, balance);
1169     ClaimedTokens(_claimToken, owner, balance);
1170   }
1171 }
1172 /**
1173  * @title TokenTimelock
1174  * @dev TokenTimelock is a token holder contract that will allow a
1175  * beneficiary to extract the tokens after a given release time
1176  */
1177 contract ReserveLocker is SafeMath{
1178   using SafeERC20 for ERC20Basic;
1179   ERC20Basic public token;
1180   ATCCrowdSale public crowdsale;
1181   address public beneficiary;
1182   function ReserveLocker(address _token, address _crowdsale, address _beneficiary) {
1183     require(_token != 0x00);
1184     require(_crowdsale != 0x00);
1185     require(_beneficiary != 0x00);
1186     token = ERC20Basic(_token);
1187     crowdsale = ATCCrowdSale(_crowdsale);
1188     beneficiary = _beneficiary;
1189   }
1190   /**
1191    * @notice Transfers tokens held by timelock to beneficiary.
1192    */
1193    function release() public {
1194      uint256 finalizedTime = crowdsale.finalizedTime();
1195      require(finalizedTime > 0 && now > add(finalizedTime, 2 years));
1196      uint256 amount = token.balanceOf(this);
1197      require(amount > 0);
1198      token.safeTransfer(beneficiary, amount);
1199    }
1200   function setToken(address newToken) public {
1201     require(msg.sender == beneficiary);
1202     require(newToken != 0x00);
1203     token = ERC20Basic(newToken);
1204   }
1205 }
1206 /**
1207  * @title TokenTimelock
1208  * @dev TokenTimelock is a token holder contract that will allow a
1209  * beneficiary to extract the tokens after a given release time
1210  */
1211 contract TeamLocker is SafeMath{
1212   using SafeERC20 for ERC20Basic;
1213   ERC20Basic public token;
1214   ATCCrowdSale public crowdsale;
1215   address[] public beneficiaries;
1216   uint256 public collectedTokens;
1217   function TeamLocker(address _token, address _crowdsale, address[] _beneficiaries) {
1218     require(_token != 0x00);
1219     require(_crowdsale != 0x00);
1220     for (uint i = 0; i < _beneficiaries.length; i++) {
1221       require(_beneficiaries[i] != 0x00);
1222     }
1223     token = ERC20Basic(_token);
1224     crowdsale = ATCCrowdSale(_crowdsale);
1225     beneficiaries = _beneficiaries;
1226   }
1227   /**
1228    * @notice Transfers tokens held by timelock to beneficiary.
1229    */
1230   function release() public {
1231     uint256 balance = token.balanceOf(address(this));
1232     uint256 total = add(balance, collectedTokens);
1233     uint256 finalizedTime = crowdsale.finalizedTime();
1234     require(finalizedTime > 0);
1235     uint256 lockTime1 = add(finalizedTime, 183 days); // 6 months
1236     uint256 lockTime2 = add(finalizedTime, 1 years); // 1 year
1237     uint256 currentRatio = 20;
1238     if (now >= lockTime1) {
1239       currentRatio = 50;
1240     }
1241     if (now >= lockTime2) {
1242       currentRatio = 100;
1243     }
1244     uint256 releasedAmount = div(mul(total, currentRatio), 100);
1245     uint256 grantAmount = sub(releasedAmount, collectedTokens);
1246     require(grantAmount > 0);
1247     collectedTokens = add(collectedTokens, grantAmount);
1248     uint256 grantAmountForEach = div(grantAmount, 3);
1249     for (uint i = 0; i < beneficiaries.length; i++) {
1250         token.safeTransfer(beneficiaries[i], grantAmountForEach);
1251     }
1252   }
1253   function setToken(address newToken) public {
1254     require(newToken != 0x00);
1255     bool isBeneficiary;
1256     for (uint i = 0; i < beneficiaries.length; i++) {
1257       if (msg.sender == beneficiaries[i]) {
1258         isBeneficiary = true;
1259       }
1260     }
1261     require(isBeneficiary);
1262     token = ERC20Basic(newToken);
1263   }
1264 }
1265 contract ATCCrowdSale2 is Ownable, SafeMath, Pausable {
1266   KYC public kyc;
1267   ATC public token;
1268   RefundVault public vault;
1269   address public bountyAddress; //5% for bounty
1270   address public partnersAddress; //15% for community groups & partners
1271   address public ATCReserveLocker; //15% with 2 years lock
1272   address public teamLocker; // 15% with 2 years vesting
1273   struct Period {
1274     uint256 startTime;
1275     uint256 endTime;
1276     uint256 bonus; // used to calculate rate with bonus. ragne 0 ~ 15 (0% ~ 15%)
1277   }
1278   uint256 public baseRate; // 1 ETH = 1500 ATC
1279   uint256[] public additionalBonusAmounts;
1280   Period[] public periods;
1281   uint8 constant public MAX_PERIOD_COUNT = 8;
1282   uint256 public weiRaised;
1283   uint256 public maxEtherCap;
1284   uint256 public minEtherCap;
1285   mapping (address => uint256) public beneficiaryFunded;
1286   address[] investorList;
1287   mapping (address => bool) inInvestorList;
1288   address public ATCController;
1289   bool public isFinalized;
1290   uint256 public refundCompleted;
1291   uint256 public finalizedTime;
1292   bool public initialized;
1293   event CrowdSaleTokenPurchase(address indexed _investor, address indexed _beneficiary, uint256 _toFund, uint256 _tokens);
1294   event StartPeriod(uint256 _startTime, uint256 _endTime, uint256 _bonus);
1295   event Finalized();
1296   event PushInvestorList(address _investor);
1297   event RefundAll(uint256 _numToRefund);
1298   event ClaimedTokens(address _claimToken, address owner, uint256 balance);
1299   event Initialize();
1300   function initialize (
1301     address _kyc,
1302     address _token,
1303     address _vault,
1304     address _bountyAddress,
1305     address _partnersAddress,
1306     address _ATCReserveLocker,
1307     address _teamLocker,
1308     address _tokenController,
1309     uint256 _maxEtherCap,
1310     uint256 _minEtherCap,
1311     uint256 _baseRate,
1312     uint256[] _additionalBonusAmounts
1313     ) onlyOwner {
1314       require(!initialized);
1315       require(_kyc != 0x00 && _token != 0x00 && _vault != 0x00);
1316       require(_bountyAddress != 0x00 && _partnersAddress != 0x00);
1317       require(_ATCReserveLocker != 0x00 && _teamLocker != 0x00);
1318       require(_tokenController != 0x00);
1319       require(0 < _minEtherCap && _minEtherCap < _maxEtherCap);
1320       require(_baseRate > 0);
1321       require(_additionalBonusAmounts[0] > 0);
1322       for (uint i = 0; i < _additionalBonusAmounts.length - 1; i++) {
1323         require(_additionalBonusAmounts[i] < _additionalBonusAmounts[i + 1]);
1324       }
1325       kyc = KYC(_kyc);
1326       token = ATC(_token);
1327       vault = RefundVault(_vault);
1328       bountyAddress = _bountyAddress;
1329       partnersAddress = _partnersAddress;
1330       ATCReserveLocker = _ATCReserveLocker;
1331       teamLocker = _teamLocker;
1332       ATCController = _tokenController;
1333       maxEtherCap = _maxEtherCap;
1334       minEtherCap = _minEtherCap;
1335       baseRate = _baseRate;
1336       additionalBonusAmounts = _additionalBonusAmounts;
1337       initialized = true;
1338       Initialize();
1339     }
1340   function () public payable {
1341     buy(msg.sender);
1342   }
1343   function buy(address beneficiary)
1344     public
1345     payable
1346     whenNotPaused
1347   {
1348       // check validity
1349       require(beneficiary != 0x00);
1350       require(kyc.registeredAddress(beneficiary));
1351       require(onSale());
1352       require(validPurchase());
1353       require(!isFinalized);
1354       // calculate eth amount
1355       uint256 weiAmount = msg.value;
1356       uint256 toFund;
1357       uint256 postWeiRaised = add(weiRaised, weiAmount);
1358       if (postWeiRaised > maxEtherCap) {
1359         toFund = sub(maxEtherCap, weiRaised);
1360       } else {
1361         toFund = weiAmount;
1362       }
1363       require(toFund > 0);
1364       require(weiAmount >= toFund);
1365       uint256 rate = calculateRate(toFund);
1366       uint256 tokens = mul(toFund, rate);
1367       uint256 toReturn = sub(weiAmount, toFund);
1368       pushInvestorList(msg.sender);
1369       weiRaised = add(weiRaised, toFund);
1370       beneficiaryFunded[beneficiary] = add(beneficiaryFunded[beneficiary], toFund);
1371       token.generateTokens(beneficiary, tokens);
1372       if (toReturn > 0) {
1373         msg.sender.transfer(toReturn);
1374       }
1375       forwardFunds(toFund);
1376       CrowdSaleTokenPurchase(msg.sender, beneficiary, toFund, tokens);
1377   }
1378   function pushInvestorList(address investor) internal {
1379     if (!inInvestorList[investor]) {
1380       inInvestorList[investor] = true;
1381       investorList.push(investor);
1382       PushInvestorList(investor);
1383     }
1384   }
1385   function validPurchase() internal view returns (bool) {
1386     bool nonZeroPurchase = msg.value != 0;
1387     return nonZeroPurchase && !maxReached();
1388   }
1389   function forwardFunds(uint256 toFund) internal {
1390     vault.deposit.value(toFund)(msg.sender);
1391   }
1392   /**
1393    * @dev Checks whether minEtherCap is reached
1394    * @return true if min ether cap is reaced
1395    */
1396   function minReached() public view returns (bool) {
1397     return weiRaised >= minEtherCap;
1398   }
1399   /**
1400    * @dev Checks whether maxEtherCap is reached
1401    * @return true if max ether cap is reaced
1402    */
1403   function maxReached() public view returns (bool) {
1404     return weiRaised == maxEtherCap;
1405   }
1406   function getPeriodBonus() public view returns (uint256) {
1407     bool nowOnSale;
1408     uint256 currentPeriod;
1409     for (uint i = 0; i < periods.length; i++) {
1410       if (periods[i].startTime <= now && now <= periods[i].endTime) {
1411         nowOnSale = true;
1412         currentPeriod = i;
1413         break;
1414       }
1415     }
1416     require(nowOnSale);
1417     return periods[currentPeriod].bonus;
1418   }
1419   /**
1420    * @dev rate = baseRate * (100 + bonus) / 100
1421    */
1422   function calculateRate(uint256 toFund) public view returns (uint256)  {
1423     uint bonus = getPeriodBonus();
1424     // bonus for eth amount
1425     if (additionalBonusAmounts[0] <= toFund) {
1426       bonus = add(bonus, 5); // 5% amount bonus for more than 300 ETH
1427     }
1428     if (additionalBonusAmounts[1] <= toFund) {
1429       bonus = add(bonus, 5); // 10% amount bonus for more than 6000 ETH
1430     }
1431     if (additionalBonusAmounts[2] <= toFund) {
1432       bonus = 25; // final 25% amount bonus for more than 8000 ETH
1433     }
1434     if (additionalBonusAmounts[3] <= toFund) {
1435       bonus = 30; // final 30% amount bonus for more than 10000 ETH
1436     }
1437     return div(mul(baseRate, add(bonus, 100)), 100);
1438   }
1439   function startPeriod(uint256 _startTime, uint256 _endTime) public onlyOwner returns (bool) {
1440     require(periods.length < MAX_PERIOD_COUNT);
1441     require(now < _startTime && _startTime < _endTime);
1442     if (periods.length != 0) {
1443       require(sub(_endTime, _startTime) <= 7 days);
1444       require(periods[periods.length - 1].endTime < _startTime);
1445     }
1446     // 15% -> 10% -> 5% -> 0%
1447     Period memory newPeriod;
1448     newPeriod.startTime = _startTime;
1449     newPeriod.endTime = _endTime;
1450     if(periods.length < 3) {
1451       newPeriod.bonus = sub(15, mul(5, periods.length));
1452     } else {
1453       newPeriod.bonus = 0;
1454     }
1455     periods.push(newPeriod);
1456     StartPeriod(_startTime, _endTime, newPeriod.bonus);
1457     return true;
1458   }
1459   function onSale() public returns (bool) {
1460     bool nowOnSale;
1461     for (uint i = 0; i < periods.length; i++) {
1462       if (periods[i].startTime <= now && now <= periods[i].endTime) {
1463         nowOnSale = true;
1464         break;
1465       }
1466     }
1467     return nowOnSale;
1468   }
1469   /**
1470    * @dev should be called after crowdsale ends, to do
1471    */
1472   function finalize() onlyOwner {
1473     require(!isFinalized);
1474     require(!onSale() || maxReached());
1475     finalizedTime = now;
1476     finalization();
1477     Finalized();
1478     isFinalized = true;
1479   }
1480   /**
1481    * @dev end token minting on finalization, mint tokens for dev team and reserve wallets
1482    */
1483   function finalization() internal {
1484     if (minReached()) {
1485       vault.close();
1486       uint256 totalToken = token.totalSupply();
1487       // token distribution : 50% for sale, 5% for bounty, 15% for partners, 15% for reserve, 15% for team
1488       uint256 bountyAmount = div(mul(totalToken, 5), 50);
1489       uint256 partnersAmount = div(mul(totalToken, 15), 50);
1490       uint256 reserveAmount = div(mul(totalToken, 15), 50);
1491       uint256 teamAmount = div(mul(totalToken, 15), 50);
1492       distributeToken(bountyAmount, partnersAmount, reserveAmount, teamAmount);
1493       token.enableTransfers(true);
1494     } else {
1495       vault.enableRefunds();
1496     }
1497     token.finishGenerating();
1498     token.changeController(ATCController);
1499   }
1500   function distributeToken(uint256 bountyAmount, uint256 partnersAmount, uint256 reserveAmount, uint256 teamAmount) internal {
1501     require(bountyAddress != 0x00 && partnersAddress != 0x00);
1502     require(ATCReserveLocker != 0x00 && teamLocker != 0x00);
1503     token.generateTokens(bountyAddress, bountyAmount);
1504     token.generateTokens(partnersAddress, partnersAmount);
1505     token.generateTokens(ATCReserveLocker, reserveAmount);
1506     token.generateTokens(teamLocker, teamAmount);
1507   }
1508   /**
1509    * @dev refund a lot of investors at a time checking onlyOwner
1510    * @param numToRefund uint256 The number of investors to refund
1511    */
1512   function refundAll(uint256 numToRefund) onlyOwner {
1513     require(isFinalized);
1514     require(!minReached());
1515     require(numToRefund > 0);
1516     uint256 limit = refundCompleted + numToRefund;
1517     if (limit > investorList.length) {
1518       limit = investorList.length;
1519     }
1520     for(uint256 i = refundCompleted; i < limit; i++) {
1521       vault.refund(investorList[i]);
1522     }
1523     refundCompleted = limit;
1524     RefundAll(numToRefund);
1525   }
1526   /**
1527    * @dev if crowdsale is unsuccessful, investors can claim refunds here
1528    * @param investor address The account to be refunded
1529    */
1530   function claimRefund(address investor) returns (bool) {
1531     require(isFinalized);
1532     require(!minReached());
1533     return vault.refund(investor);
1534   }
1535   function claimTokens(address _claimToken) public onlyOwner {
1536     if (token.controller() == address(this)) {
1537          token.claimTokens(_claimToken);
1538     }
1539     if (_claimToken == 0x0) {
1540         owner.transfer(this.balance);
1541         return;
1542     }
1543     ERC20Basic claimToken = ERC20Basic(_claimToken);
1544     uint256 balance = claimToken.balanceOf(this);
1545     claimToken.transfer(owner, balance);
1546     ClaimedTokens(_claimToken, owner, balance);
1547   }
1548 }