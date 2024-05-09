1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 contract SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13   function div(uint256 a, uint256 b) internal constant returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23   function add(uint256 a, uint256 b) internal constant returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
29     return a >= b ? a : b;
30   }
31   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
32     return a < b ? a : b;
33   }
34   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
35     return a >= b ? a : b;
36   }
37   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
38     return a < b ? a : b;
39   }
40 }
41 /**
42  * @title ERC20Basic
43  * @dev Simpler version of ERC20 interface
44  * @dev see https://github.com/ethereum/EIPs/issues/179
45  */
46 contract ERC20Basic {
47   uint256 public totalSupply;
48   function balanceOf(address who) public view returns (uint256);
49   function transfer(address to, uint256 value) public returns (bool);
50   event Transfer(address indexed from, address indexed to, uint256 value);
51 }
52 /**
53  * @title ERC20 interface
54  * @dev see https://github.com/ethereum/EIPs/issues/20
55  */
56 contract ERC20 is ERC20Basic {
57   function allowance(address owner, address spender) public view returns (uint256);
58   function transferFrom(address from, address to, uint256 value) public returns (bool);
59   function approve(address spender, uint256 value) public returns (bool);
60   event Approval(address indexed owner, address indexed spender, uint256 value);
61 }
62 /**
63  * @title SafeERC20
64  * @dev Wrappers around ERC20 operations that throw on failure.
65  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
66  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
67  */
68 library SafeERC20 {
69   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
70     assert(token.transfer(to, value));
71   }
72   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
73     assert(token.transferFrom(from, to, value));
74   }
75   function safeApprove(ERC20 token, address spender, uint256 value) internal {
76     assert(token.approve(spender, value));
77   }
78 }
79 /**
80  * @title Ownable
81  * @dev The Ownable contract has an owner address, and provides basic authorization control
82  * functions, this simplifies the implementation of "user permissions".
83  */
84 contract Ownable {
85   address public owner;
86   /**
87    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
88    * account.
89    */
90   function Ownable() {
91     owner = msg.sender;
92   }
93   /**
94    * @dev Throws if called by any account other than the owner.
95    */
96   modifier onlyOwner() {
97     require(msg.sender == owner);
98     _;
99   }
100   /**
101    * @dev Allows the current owner to transfer control of the contract to a newOwner.
102    * @param newOwner The address to transfer ownership to.
103    */
104   function transferOwnership(address newOwner) onlyOwner {
105     require(newOwner != address(0));
106     owner = newOwner;
107   }
108 }
109 /**
110  * @title KYC
111  * @dev KYC contract handles the white list for ASTCrowdsale contract
112  * Only accounts registered in KYC contract can buy AST token.
113  * Admins can register account, and the reason why
114  */
115 contract KYC is Ownable {
116   // check the address is registered for token sale
117   mapping (address => bool) public registeredAddress;
118   // check the address is admin of kyc contract
119   mapping (address => bool) public admin;
120   event Registered(address indexed _addr);
121   event Unregistered(address indexed _addr);
122   event NewAdmin(address indexed _addr);
123   event ClaimedTokens(address _token, address owner, uint256 balance);
124   /**
125    * @dev check whether the address is registered for token sale or not.
126    * @param _addr address
127    */
128   modifier onlyRegistered(address _addr) {
129     require(registeredAddress[_addr]);
130     _;
131   }
132   /**
133    * @dev check whether the msg.sender is admin or not
134    */
135   modifier onlyAdmin() {
136     require(admin[msg.sender]);
137     _;
138   }
139   function KYC() {
140     admin[msg.sender] = true;
141   }
142   /**
143    * @dev set new admin as admin of KYC contract
144    * @param _addr address The address to set as admin of KYC contract
145    */
146   function setAdmin(address _addr)
147     public
148     onlyOwner
149   {
150     require(_addr != address(0) && admin[_addr] == false);
151     admin[_addr] = true;
152     NewAdmin(_addr);
153   }
154   /**
155    * @dev register the address for token sale
156    * @param _addr address The address to register for token sale
157    */
158   function register(address _addr)
159     public
160     onlyAdmin
161   {
162     require(_addr != address(0) && registeredAddress[_addr] == false);
163     registeredAddress[_addr] = true;
164     Registered(_addr);
165   }
166   /**
167    * @dev register the addresses for token sale
168    * @param _addrs address[] The addresses to register for token sale
169    */
170   function registerByList(address[] _addrs)
171     public
172     onlyAdmin
173   {
174     for(uint256 i = 0; i < _addrs.length; i++) {
175       require(_addrs[i] != address(0) && registeredAddress[_addrs[i]] == false);
176       registeredAddress[_addrs[i]] = true;
177       Registered(_addrs[i]);
178     }
179   }
180   /**
181    * @dev unregister the registered address
182    * @param _addr address The address to unregister for token sale
183    */
184   function unregister(address _addr)
185     public
186     onlyAdmin
187     onlyRegistered(_addr)
188   {
189     registeredAddress[_addr] = false;
190     Unregistered(_addr);
191   }
192   /**
193    * @dev unregister the registered addresses
194    * @param _addrs address[] The addresses to unregister for token sale
195    */
196   function unregisterByList(address[] _addrs)
197     public
198     onlyAdmin
199   {
200     for(uint256 i = 0; i < _addrs.length; i++) {
201       require(registeredAddress[_addrs[i]]);
202       registeredAddress[_addrs[i]] = false;
203       Unregistered(_addrs[i]);
204     }
205   }
206   function claimTokens(address _token) public onlyOwner {
207     if (_token == 0x0) {
208         owner.transfer(this.balance);
209         return;
210     }
211     ERC20Basic token = ERC20Basic(_token);
212     uint256 balance = token.balanceOf(this);
213     token.transfer(owner, balance);
214     ClaimedTokens(_token, owner, balance);
215   }
216 }
217 /*
218     Copyright 2016, Jordi Baylina
219     This program is free software: you can redistribute it and/or modify
220     it under the terms of the GNU General Public License as published by
221     the Free Software Foundation, either version 3 of the License, or
222     (at your option) any later version.
223     This program is distributed in the hope that it will be useful,
224     but WITHOUT ANY WARRANTY; without even the implied warranty of
225     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
226     GNU General Public License for more details.
227     You should have received a copy of the GNU General Public License
228     along with this program.  If not, see <http://www.gnu.org/licenses/>.
229  */
230 /// @title MiniMeToken Contract
231 /// @author Jordi Baylina
232 /// @dev This token contract's goal is to make it easy for anyone to clone this
233 ///  token using the token distribution at a given block, this will allow DAO's
234 ///  and DApps to upgrade their features in a decentralized manner without
235 ///  affecting the original token
236 /// @dev It is ERC20 compliant, but still needs to under go further testing.
237 contract Controlled {
238     /// @notice The address of the controller is the only address that can call
239     ///  a function with this modifier
240     modifier onlyController { require(msg.sender == controller); _; }
241     address public controller;
242     function Controlled() public { controller = msg.sender;}
243     /// @notice Changes the controller of the contract
244     /// @param _newController The new controller of the contract
245     function changeController(address _newController) public onlyController {
246         controller = _newController;
247     }
248 }
249 /// @dev The token controller contract must implement these functions
250 contract TokenController {
251     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
252     /// @param _owner The address that sent the ether to create tokens
253     /// @return True if the ether is accepted, false if it throws
254     function proxyPayment(address _owner) public payable returns(bool);
255     /// @notice Notifies the controller about a token transfer allowing the
256     ///  controller to react if desired
257     /// @param _from The origin of the transfer
258     /// @param _to The destination of the transfer
259     /// @param _amount The amount of the transfer
260     /// @return False if the controller does not authorize the transfer
261     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
262     /// @notice Notifies the controller about an approval allowing the
263     ///  controller to react if desired
264     /// @param _owner The address that calls `approve()`
265     /// @param _spender The spender in the `approve()` call
266     /// @param _amount The amount in the `approve()` call
267     /// @return False if the controller does not authorize the approval
268     function onApprove(address _owner, address _spender, uint _amount) public
269         returns(bool);
270 }
271 contract ApproveAndCallFallBack {
272     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
273 }
274 /// @dev The actual token contract, the default controller is the msg.sender
275 ///  that deploys the contract, so usually this token will be deployed by a
276 ///  token controller contract, which Giveth will call a "Campaign"
277 contract MiniMeToken is Controlled {
278     string public name;                //The Token's name: e.g. DigixDAO Tokens
279     uint8 public decimals;             //Number of decimals of the smallest unit
280     string public symbol;              //An identifier: e.g. REP
281     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
282     /// @dev `Checkpoint` is the structure that attaches a block number to a
283     ///  given value, the block number attached is the one that last changed the
284     ///  value
285     struct  Checkpoint {
286         // `fromBlock` is the block number that the value was generated from
287         uint128 fromBlock;
288         // `value` is the amount of tokens at a specific block number
289         uint128 value;
290     }
291     // `parentToken` is the Token address that was cloned to produce this token;
292     //  it will be 0x0 for a token that was not cloned
293     MiniMeToken public parentToken;
294     // `parentSnapShotBlock` is the block number from the Parent Token that was
295     //  used to determine the initial distribution of the Clone Token
296     uint public parentSnapShotBlock;
297     // `creationBlock` is the block number that the Clone Token was created
298     uint public creationBlock;
299     // `balances` is the map that tracks the balance of each address, in this
300     //  contract when the balance changes the block number that the change
301     //  occurred is also included in the map
302     mapping (address => Checkpoint[]) balances;
303     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
304     mapping (address => mapping (address => uint256)) allowed;
305     // Tracks the history of the `totalSupply` of the token
306     Checkpoint[] totalSupplyHistory;
307     // Flag that determines if the token is transferable or not.
308     bool public transfersEnabled;
309     // The factory used to create new clone tokens
310     MiniMeTokenFactory public tokenFactory;
311 ////////////////
312 // Constructor
313 ////////////////
314     /// @notice Constructor to create a MiniMeToken
315     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
316     ///  will create the Clone token contracts, the token factory needs to be
317     ///  deployed first
318     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
319     ///  new token
320     /// @param _parentSnapShotBlock Block of the parent token that will
321     ///  determine the initial distribution of the clone token, set to 0 if it
322     ///  is a new token
323     /// @param _tokenName Name of the new token
324     /// @param _decimalUnits Number of decimals of the new token
325     /// @param _tokenSymbol Token Symbol for the new token
326     /// @param _transfersEnabled If true, tokens will be able to be transferred
327     function MiniMeToken(
328         address _tokenFactory,
329         address _parentToken,
330         uint _parentSnapShotBlock,
331         string _tokenName,
332         uint8 _decimalUnits,
333         string _tokenSymbol,
334         bool _transfersEnabled
335     ) public {
336         tokenFactory = MiniMeTokenFactory(_tokenFactory);
337         name = _tokenName;                                 // Set the name
338         decimals = _decimalUnits;                          // Set the decimals
339         symbol = _tokenSymbol;                             // Set the symbol
340         parentToken = MiniMeToken(_parentToken);
341         parentSnapShotBlock = _parentSnapShotBlock;
342         transfersEnabled = _transfersEnabled;
343         creationBlock = block.number;
344     }
345 ///////////////////
346 // ERC20 Methods
347 ///////////////////
348     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
349     /// @param _to The address of the recipient
350     /// @param _amount The amount of tokens to be transferred
351     /// @return Whether the transfer was successful or not
352     function transfer(address _to, uint256 _amount) public returns (bool success) {
353         require(transfersEnabled);
354         return doTransfer(msg.sender, _to, _amount);
355     }
356     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
357     ///  is approved by `_from`
358     /// @param _from The address holding the tokens being transferred
359     /// @param _to The address of the recipient
360     /// @param _amount The amount of tokens to be transferred
361     /// @return True if the transfer was successful
362     function transferFrom(address _from, address _to, uint256 _amount
363     ) public returns (bool success) {
364         // The controller of this contract can move tokens around at will,
365         //  this is important to recognize! Confirm that you trust the
366         //  controller of this contract, which in most situations should be
367         //  another open source smart contract or 0x0
368         if (msg.sender != controller) {
369             require(transfersEnabled);
370             // The standard ERC 20 transferFrom functionality
371             if (allowed[_from][msg.sender] < _amount) return false;
372             allowed[_from][msg.sender] -= _amount;
373         }
374         return doTransfer(_from, _to, _amount);
375     }
376     /// @dev This is the actual transfer function in the token contract, it can
377     ///  only be called by other functions in this contract.
378     /// @param _from The address holding the tokens being transferred
379     /// @param _to The address of the recipient
380     /// @param _amount The amount of tokens to be transferred
381     /// @return True if the transfer was successful
382     function doTransfer(address _from, address _to, uint _amount
383     ) internal returns(bool) {
384            if (_amount == 0) {
385                return true;
386            }
387            require(parentSnapShotBlock < block.number);
388            // Do not allow transfer to 0x0 or the token contract itself
389            require((_to != 0) && (_to != address(this)));
390            // If the amount being transfered is more than the balance of the
391            //  account the transfer returns false
392            var previousBalanceFrom = balanceOfAt(_from, block.number);
393            if (previousBalanceFrom < _amount) {
394                return false;
395            }
396            // Alerts the token controller of the transfer
397            if (isContract(controller)) {
398                require(TokenController(controller).onTransfer(_from, _to, _amount));
399            }
400            // First update the balance array with the new value for the address
401            //  sending the tokens
402            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
403            // Then update the balance array with the new value for the address
404            //  receiving the tokens
405            var previousBalanceTo = balanceOfAt(_to, block.number);
406            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
407            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
408            // An event to make the transfer easy to find on the blockchain
409            Transfer(_from, _to, _amount);
410            return true;
411     }
412     /// @param _owner The address that's balance is being requested
413     /// @return The balance of `_owner` at the current block
414     function balanceOf(address _owner) public constant returns (uint256 balance) {
415         return balanceOfAt(_owner, block.number);
416     }
417     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
418     ///  its behalf. This is a modified version of the ERC20 approve function
419     ///  to be a little bit safer
420     /// @param _spender The address of the account able to transfer the tokens
421     /// @param _amount The amount of tokens to be approved for transfer
422     /// @return True if the approval was successful
423     function approve(address _spender, uint256 _amount) public returns (bool success) {
424         require(transfersEnabled);
425         // To change the approve amount you first have to reduce the addresses`
426         //  allowance to zero by calling `approve(_spender,0)` if it is not
427         //  already 0 to mitigate the race condition described here:
428         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
429         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
430         // Alerts the token controller of the approve function call
431         if (isContract(controller)) {
432             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
433         }
434         allowed[msg.sender][_spender] = _amount;
435         Approval(msg.sender, _spender, _amount);
436         return true;
437     }
438     /// @dev This function makes it easy to read the `allowed[]` map
439     /// @param _owner The address of the account that owns the token
440     /// @param _spender The address of the account able to transfer the tokens
441     /// @return Amount of remaining tokens of _owner that _spender is allowed
442     ///  to spend
443     function allowance(address _owner, address _spender
444     ) public constant returns (uint256 remaining) {
445         return allowed[_owner][_spender];
446     }
447     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
448     ///  its behalf, and then a function is triggered in the contract that is
449     ///  being approved, `_spender`. This allows users to use their tokens to
450     ///  interact with contracts in one function call instead of two
451     /// @param _spender The address of the contract able to transfer the tokens
452     /// @param _amount The amount of tokens to be approved for transfer
453     /// @return True if the function call was successful
454     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
455     ) public returns (bool success) {
456         require(approve(_spender, _amount));
457         ApproveAndCallFallBack(_spender).receiveApproval(
458             msg.sender,
459             _amount,
460             this,
461             _extraData
462         );
463         return true;
464     }
465     /// @dev This function makes it easy to get the total number of tokens
466     /// @return The total number of tokens
467     function totalSupply() public constant returns (uint) {
468         return totalSupplyAt(block.number);
469     }
470 ////////////////
471 // Query balance and totalSupply in History
472 ////////////////
473     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
474     /// @param _owner The address from which the balance will be retrieved
475     /// @param _blockNumber The block number when the balance is queried
476     /// @return The balance at `_blockNumber`
477     function balanceOfAt(address _owner, uint _blockNumber) public constant
478         returns (uint) {
479         // These next few lines are used when the balance of the token is
480         //  requested before a check point was ever created for this token, it
481         //  requires that the `parentToken.balanceOfAt` be queried at the
482         //  genesis block for that token as this contains initial balance of
483         //  this token
484         if ((balances[_owner].length == 0)
485             || (balances[_owner][0].fromBlock > _blockNumber)) {
486             if (address(parentToken) != 0) {
487                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
488             } else {
489                 // Has no parent
490                 return 0;
491             }
492         // This will return the expected balance during normal situations
493         } else {
494             return getValueAt(balances[_owner], _blockNumber);
495         }
496     }
497     /// @notice Total amount of tokens at a specific `_blockNumber`.
498     /// @param _blockNumber The block number when the totalSupply is queried
499     /// @return The total amount of tokens at `_blockNumber`
500     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
501         // These next few lines are used when the totalSupply of the token is
502         //  requested before a check point was ever created for this token, it
503         //  requires that the `parentToken.totalSupplyAt` be queried at the
504         //  genesis block for this token as that contains totalSupply of this
505         //  token at this block number.
506         if ((totalSupplyHistory.length == 0)
507             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
508             if (address(parentToken) != 0) {
509                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
510             } else {
511                 return 0;
512             }
513         // This will return the expected totalSupply during normal situations
514         } else {
515             return getValueAt(totalSupplyHistory, _blockNumber);
516         }
517     }
518 ////////////////
519 // Clone Token Method
520 ////////////////
521     /// @notice Creates a new clone token with the initial distribution being
522     ///  this token at `_snapshotBlock`
523     /// @param _cloneTokenName Name of the clone token
524     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
525     /// @param _cloneTokenSymbol Symbol of the clone token
526     /// @param _snapshotBlock Block when the distribution of the parent token is
527     ///  copied to set the initial distribution of the new clone token;
528     ///  if the block is zero than the actual block, the current block is used
529     /// @param _transfersEnabled True if transfers are allowed in the clone
530     /// @return The address of the new MiniMeToken Contract
531     function createCloneToken(
532         string _cloneTokenName,
533         uint8 _cloneDecimalUnits,
534         string _cloneTokenSymbol,
535         uint _snapshotBlock,
536         bool _transfersEnabled
537         ) public returns(address) {
538         if (_snapshotBlock == 0) _snapshotBlock = block.number;
539         MiniMeToken cloneToken = tokenFactory.createCloneToken(
540             this,
541             _snapshotBlock,
542             _cloneTokenName,
543             _cloneDecimalUnits,
544             _cloneTokenSymbol,
545             _transfersEnabled
546             );
547         cloneToken.changeController(msg.sender);
548         // An event to make the token easy to find on the blockchain
549         NewCloneToken(address(cloneToken), _snapshotBlock);
550         return address(cloneToken);
551     }
552 ////////////////
553 // Generate and destroy tokens
554 ////////////////
555     /// @notice Generates `_amount` tokens that are assigned to `_owner`
556     /// @param _owner The address that will be assigned the new tokens
557     /// @param _amount The quantity of tokens generated
558     /// @return True if the tokens are generated correctly
559     function generateTokens(address _owner, uint _amount
560     ) public onlyController returns (bool) {
561         uint curTotalSupply = totalSupply();
562         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
563         uint previousBalanceTo = balanceOf(_owner);
564         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
565         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
566         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
567         Transfer(0, _owner, _amount);
568         return true;
569     }
570     /// @notice Burns `_amount` tokens from `_owner`
571     /// @param _owner The address that will lose the tokens
572     /// @param _amount The quantity of tokens to burn
573     /// @return True if the tokens are burned correctly
574     function destroyTokens(address _owner, uint _amount
575     ) onlyController public returns (bool) {
576         uint curTotalSupply = totalSupply();
577         require(curTotalSupply >= _amount);
578         uint previousBalanceFrom = balanceOf(_owner);
579         require(previousBalanceFrom >= _amount);
580         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
581         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
582         Transfer(_owner, 0, _amount);
583         return true;
584     }
585 ////////////////
586 // Enable tokens transfers
587 ////////////////
588     /// @notice Enables token holders to transfer their tokens freely if true
589     /// @param _transfersEnabled True if transfers are allowed in the clone
590     function enableTransfers(bool _transfersEnabled) public onlyController {
591         transfersEnabled = _transfersEnabled;
592     }
593 ////////////////
594 // Internal helper functions to query and set a value in a snapshot array
595 ////////////////
596     /// @dev `getValueAt` retrieves the number of tokens at a given block number
597     /// @param checkpoints The history of values being queried
598     /// @param _block The block number to retrieve the value at
599     /// @return The number of tokens being queried
600     function getValueAt(Checkpoint[] storage checkpoints, uint _block
601     ) constant internal returns (uint) {
602         if (checkpoints.length == 0) return 0;
603         // Shortcut for the actual value
604         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
605             return checkpoints[checkpoints.length-1].value;
606         if (_block < checkpoints[0].fromBlock) return 0;
607         // Binary search of the value in the array
608         uint min = 0;
609         uint max = checkpoints.length-1;
610         while (max > min) {
611             uint mid = (max + min + 1)/ 2;
612             if (checkpoints[mid].fromBlock<=_block) {
613                 min = mid;
614             } else {
615                 max = mid-1;
616             }
617         }
618         return checkpoints[min].value;
619     }
620     /// @dev `updateValueAtNow` used to update the `balances` map and the
621     ///  `totalSupplyHistory`
622     /// @param checkpoints The history of data being updated
623     /// @param _value The new number of tokens
624     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
625     ) internal  {
626         if ((checkpoints.length == 0)
627         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
628                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
629                newCheckPoint.fromBlock =  uint128(block.number);
630                newCheckPoint.value = uint128(_value);
631            } else {
632                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
633                oldCheckPoint.value = uint128(_value);
634            }
635     }
636     /// @dev Internal function to determine if an address is a contract
637     /// @param _addr The address being queried
638     /// @return True if `_addr` is a contract
639     function isContract(address _addr) constant internal returns(bool) {
640         uint size;
641         if (_addr == 0) return false;
642         assembly {
643             size := extcodesize(_addr)
644         }
645         return size>0;
646     }
647     /// @dev Helper function to return a min betwen the two uints
648     function min(uint a, uint b) pure internal returns (uint) {
649         return a < b ? a : b;
650     }
651     /// @notice The fallback function: If the contract's controller has not been
652     ///  set to 0, then the `proxyPayment` method is called which relays the
653     ///  ether and creates tokens as described in the token controller contract
654     function () public payable {
655         require(isContract(controller));
656         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
657     }
658 //////////
659 // Safety Methods
660 //////////
661     /// @notice This method can be used by the controller to extract mistakenly
662     ///  sent tokens to this contract.
663     /// @param _token The address of the token contract that you want to recover
664     ///  set to 0 in case you want to extract ether.
665     function claimTokens(address _token) public onlyController {
666         if (_token == 0x0) {
667             controller.transfer(this.balance);
668             return;
669         }
670         MiniMeToken token = MiniMeToken(_token);
671         uint balance = token.balanceOf(this);
672         token.transfer(controller, balance);
673         ClaimedTokens(_token, controller, balance);
674     }
675 ////////////////
676 // Events
677 ////////////////
678     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
679     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
680     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
681     event Approval(
682         address indexed _owner,
683         address indexed _spender,
684         uint256 _amount
685         );
686 }
687 ////////////////
688 // MiniMeTokenFactory
689 ////////////////
690 /// @dev This contract is used to generate clone contracts from a contract.
691 ///  In solidity this is the way to create a contract from a contract of the
692 ///  same class
693 contract MiniMeTokenFactory {
694     /// @notice Update the DApp by creating a new token with new functionalities
695     ///  the msg.sender becomes the controller of this clone token
696     /// @param _parentToken Address of the token being cloned
697     /// @param _snapshotBlock Block of the parent token that will
698     ///  determine the initial distribution of the clone token
699     /// @param _tokenName Name of the new token
700     /// @param _decimalUnits Number of decimals of the new token
701     /// @param _tokenSymbol Token Symbol for the new token
702     /// @param _transfersEnabled If true, tokens will be able to be transferred
703     /// @return The address of the new token contract
704     function createCloneToken(
705         address _parentToken,
706         uint _snapshotBlock,
707         string _tokenName,
708         uint8 _decimalUnits,
709         string _tokenSymbol,
710         bool _transfersEnabled
711     ) public returns (MiniMeToken) {
712         MiniMeToken newToken = new MiniMeToken(
713             this,
714             _parentToken,
715             _snapshotBlock,
716             _tokenName,
717             _decimalUnits,
718             _tokenSymbol,
719             _transfersEnabled
720             );
721         newToken.changeController(msg.sender);
722         return newToken;
723     }
724 }
725 contract ATC is MiniMeToken {
726   mapping (address => bool) public blacklisted;
727   bool public generateFinished;
728   // @dev ATC constructor just parametrizes the MiniMeToken constructor
729   function ATC(address _tokenFactory)
730           MiniMeToken(
731               _tokenFactory,
732               0x0,                     // no parent token
733               0,                       // no snapshot block number from parent
734               "ATCon Token",  // Token name
735               18,                      // Decimals
736               "ATC",                   // Symbol
737               false                     // Enable transfers
738           ) {}
739   function generateTokens(address _owner, uint _amount
740       ) public onlyController returns (bool) {
741         require(generateFinished == false);
742         //check msg.sender (controller ??)
743         return super.generateTokens(_owner, _amount);
744       }
745   function doTransfer(address _from, address _to, uint _amount
746       ) internal returns(bool) {
747         require(blacklisted[_from] == false);
748         return super.doTransfer(_from, _to, _amount);
749       }
750   function finishGenerating() public onlyController returns (bool success) {
751     generateFinished = true;
752     return true;
753   }
754   function blacklistAccount(address tokenOwner) public onlyController returns (bool success) {
755     blacklisted[tokenOwner] = true;
756     return true;
757   }
758   function unBlacklistAccount(address tokenOwner) public onlyController returns (bool success) {
759     blacklisted[tokenOwner] = false;
760     return true;
761   }
762 }
763 /**
764  * @title RefundVault
765  * @dev This contract is used for storing funds while a crowdsale
766  * is in progress. Supports refunding the money if crowdsale fails,
767  * and forwarding it if crowdsale is successful.
768  */
769 contract RefundVault is Ownable, SafeMath{
770   enum State { Active, Refunding, Closed }
771   mapping (address => uint256) public deposited;
772   mapping (address => uint256) public refunded;
773   State public state;
774   address[] public reserveWallet;
775   event Closed();
776   event RefundsEnabled();
777   event Refunded(address indexed beneficiary, uint256 weiAmount);
778   /**
779    * @dev This constructor sets the addresses of
780    * 10 reserve wallets.
781    * and forwarding it if crowdsale is successful.
782    * @param _reserveWallet address[5] The addresses of reserve wallet.
783    */
784   function RefundVault(address[] _reserveWallet) {
785     state = State.Active;
786     reserveWallet = _reserveWallet;
787   }
788   /**
789    * @dev This function is called when user buy tokens. Only RefundVault
790    * contract stores the Ether user sent which forwarded from crowdsale
791    * contract.
792    * @param investor address The address who buy the token from crowdsale.
793    */
794   function deposit(address investor) onlyOwner payable {
795     require(state == State.Active);
796     deposited[investor] = add(deposited[investor], msg.value);
797   }
798   event Transferred(address _to, uint _value);
799   /**
800    * @dev This function is called when crowdsale is successfully finalized.
801    */
802   function close() onlyOwner {
803     require(state == State.Active);
804     state = State.Closed;
805     uint256 balance = this.balance;
806     uint256 reserveAmountForEach = div(balance, reserveWallet.length);
807     for(uint8 i = 0; i < reserveWallet.length; i++){
808       reserveWallet[i].transfer(reserveAmountForEach);
809       Transferred(reserveWallet[i], reserveAmountForEach);
810     }
811     Closed();
812   }
813   /**
814    * @dev This function is called when crowdsale is unsuccessfully finalized
815    * and refund is required.
816    */
817   function enableRefunds() onlyOwner {
818     require(state == State.Active);
819     state = State.Refunding;
820     RefundsEnabled();
821   }
822   /**
823    * @dev This function allows for user to refund Ether.
824    */
825   function refund(address investor) returns (bool) {
826     require(state == State.Refunding);
827     if (refunded[investor] > 0) {
828       return false;
829     }
830     uint256 depositedValue = deposited[investor];
831     deposited[investor] = 0;
832     refunded[investor] = depositedValue;
833     investor.transfer(depositedValue);
834     Refunded(investor, depositedValue);
835     return true;
836   }
837 }
838 /**
839  * @title Pausable
840  * @dev Base contract which allows children to implement an emergency stop mechanism.
841  */
842 contract Pausable is Ownable {
843   event Pause();
844   event Unpause();
845   bool public paused = false;
846   /**
847    * @dev modifier to allow actions only when the contract IS paused
848    */
849   modifier whenNotPaused() {
850     require(!paused);
851     _;
852   }
853   /**
854    * @dev modifier to allow actions only when the contract IS NOT paused
855    */
856   modifier whenPaused() {
857     require(paused);
858     _;
859   }
860   /**
861    * @dev called by the owner to pause, triggers stopped state
862    */
863   function pause() onlyOwner whenNotPaused {
864     paused = true;
865     Pause();
866   }
867   /**
868    * @dev called by the owner to unpause, returns to normal state
869    */
870   function unpause() onlyOwner whenPaused {
871     paused = false;
872     Unpause();
873   }
874 }
875 contract ATCCrowdSale is Ownable, SafeMath, Pausable {
876   KYC public kyc;
877   ATC public token;
878   RefundVault public vault;
879   address public presale;
880   address public bountyAddress; //5% for bounty
881   address public partnersAddress; //15% for community groups & partners
882   address public ATCReserveLocker; //15% with 2 years lock
883   address public teamLocker; // 15% with 2 years vesting
884   struct Period {
885     uint256 startTime;
886     uint256 endTime;
887     uint256 bonus; // used to calculate rate with bonus. ragne 0 ~ 15 (0% ~ 15%)
888   }
889   uint256 public baseRate; // 1 ETH = 1500 ATC
890   uint256[] public additionalBonusAmounts;
891   Period[] public periods;
892   uint8 constant public MAX_PERIOD_COUNT = 8;
893   uint256 public weiRaised;
894   uint256 public maxEtherCap;
895   uint256 public minEtherCap;
896   mapping (address => uint256) public beneficiaryFunded;
897   address[] investorList;
898   mapping (address => bool) inInvestorList;
899   address public ATCController;
900   bool public isFinalized;
901   uint256 public refundCompleted;
902   bool public presaleFallBackCalled;
903   uint256 public finalizedTime;
904   bool public initialized;
905   event CrowdSaleTokenPurchase(address indexed _investor, address indexed _beneficiary, uint256 _toFund, uint256 _tokens);
906   event StartPeriod(uint256 _startTime, uint256 _endTime, uint256 _bonus);
907   event Finalized();
908   event PresaleFallBack(uint256 _presaleWeiRaised);
909   event PushInvestorList(address _investor);
910   event RefundAll(uint256 _numToRefund);
911   event ClaimedTokens(address _claimToken, address owner, uint256 balance);
912   event Initialize();
913   function initialize (
914     address _kyc,
915     address _token,
916     address _vault,
917     address _presale,
918     address _bountyAddress,
919     address _partnersAddress,
920     address _ATCReserveLocker,
921     address _teamLocker,
922     address _tokenController,
923     uint256 _maxEtherCap,
924     uint256 _minEtherCap,
925     uint256 _baseRate,
926     uint256[] _additionalBonusAmounts
927     ) onlyOwner {
928       require(!initialized);
929       require(_kyc != 0x00 && _token != 0x00 && _vault != 0x00 && _presale != 0x00);
930       require(_bountyAddress != 0x00 && _partnersAddress != 0x00);
931       require(_ATCReserveLocker != 0x00 && _teamLocker != 0x00);
932       require(_tokenController != 0x00);
933       require(0 < _minEtherCap && _minEtherCap < _maxEtherCap);
934       require(_baseRate > 0);
935       require(_additionalBonusAmounts[0] > 0);
936       for (uint i = 0; i < _additionalBonusAmounts.length - 1; i++) {
937         require(_additionalBonusAmounts[i] < _additionalBonusAmounts[i + 1]);
938       }
939       kyc = KYC(_kyc);
940       token = ATC(_token);
941       vault = RefundVault(_vault);
942       presale = _presale;
943       bountyAddress = _bountyAddress;
944       partnersAddress = _partnersAddress;
945       ATCReserveLocker = _ATCReserveLocker;
946       teamLocker = _teamLocker;
947       ATCController = _tokenController;
948       maxEtherCap = _maxEtherCap;
949       minEtherCap = _minEtherCap;
950       baseRate = _baseRate;
951       additionalBonusAmounts = _additionalBonusAmounts;
952       initialized = true;
953       Initialize();
954     }
955   function () public payable {
956     buy(msg.sender);
957   }
958   function presaleFallBack(uint256 _presaleWeiRaised) public returns (bool) {
959     require(!presaleFallBackCalled);
960     require(msg.sender == presale);
961     weiRaised = _presaleWeiRaised;
962     presaleFallBackCalled = true;
963     PresaleFallBack(_presaleWeiRaised);
964     return true;
965   }
966   function buy(address beneficiary)
967     public
968     payable
969     whenNotPaused
970   {
971       // check validity
972       require(presaleFallBackCalled);
973       require(beneficiary != 0x00);
974       require(kyc.registeredAddress(beneficiary));
975       require(onSale());
976       require(validPurchase());
977       require(!isFinalized);
978       // calculate eth amount
979       uint256 weiAmount = msg.value;
980       uint256 toFund;
981       uint256 postWeiRaised = add(weiRaised, weiAmount);
982       if (postWeiRaised > maxEtherCap) {
983         toFund = sub(maxEtherCap, weiRaised);
984       } else {
985         toFund = weiAmount;
986       }
987       require(toFund > 0);
988       require(weiAmount >= toFund);
989       uint256 rate = calculateRate(toFund);
990       uint256 tokens = mul(toFund, rate);
991       uint256 toReturn = sub(weiAmount, toFund);
992       pushInvestorList(msg.sender);
993       weiRaised = add(weiRaised, toFund);
994       beneficiaryFunded[beneficiary] = add(beneficiaryFunded[beneficiary], toFund);
995       token.generateTokens(beneficiary, tokens);
996       if (toReturn > 0) {
997         msg.sender.transfer(toReturn);
998       }
999       forwardFunds(toFund);
1000       CrowdSaleTokenPurchase(msg.sender, beneficiary, toFund, tokens);
1001   }
1002   function pushInvestorList(address investor) internal {
1003     if (!inInvestorList[investor]) {
1004       inInvestorList[investor] = true;
1005       investorList.push(investor);
1006       PushInvestorList(investor);
1007     }
1008   }
1009   function validPurchase() internal view returns (bool) {
1010     bool nonZeroPurchase = msg.value != 0;
1011     return nonZeroPurchase && !maxReached();
1012   }
1013   function forwardFunds(uint256 toFund) internal {
1014     vault.deposit.value(toFund)(msg.sender);
1015   }
1016   /**
1017    * @dev Checks whether minEtherCap is reached
1018    * @return true if min ether cap is reaced
1019    */
1020   function minReached() public view returns (bool) {
1021     return weiRaised >= minEtherCap;
1022   }
1023   /**
1024    * @dev Checks whether maxEtherCap is reached
1025    * @return true if max ether cap is reaced
1026    */
1027   function maxReached() public view returns (bool) {
1028     return weiRaised == maxEtherCap;
1029   }
1030   function getPeriodBonus() public view returns (uint256) {
1031     bool nowOnSale;
1032     uint256 currentPeriod;
1033     for (uint i = 0; i < periods.length; i++) {
1034       if (periods[i].startTime <= now && now <= periods[i].endTime) {
1035         nowOnSale = true;
1036         currentPeriod = i;
1037         break;
1038       }
1039     }
1040     require(nowOnSale);
1041     return periods[currentPeriod].bonus;
1042   }
1043   /**
1044    * @dev rate = baseRate * (100 + bonus) / 100
1045    */
1046   function calculateRate(uint256 toFund) public view returns (uint256)  {
1047     uint bonus = getPeriodBonus();
1048     // bonus for eth amount
1049     if (additionalBonusAmounts[0] <= toFund) {
1050       bonus = add(bonus, 5); // 5% amount bonus for more than 300 ETH
1051     }
1052     if (additionalBonusAmounts[1] <= toFund) {
1053       bonus = add(bonus, 5); // 10% amount bonus for more than 6000 ETH
1054     }
1055     if (additionalBonusAmounts[2] <= toFund) {
1056       bonus = 25; // final 25% amount bonus for more than 8000 ETH
1057     }
1058     if (additionalBonusAmounts[3] <= toFund) {
1059       bonus = 30; // final 30% amount bonus for more than 10000 ETH
1060     }
1061     return div(mul(baseRate, add(bonus, 100)), 100);
1062   }
1063   function startPeriod(uint256 _startTime, uint256 _endTime) public onlyOwner returns (bool) {
1064     require(periods.length < MAX_PERIOD_COUNT);
1065     require(now < _startTime && _startTime < _endTime);
1066     if (periods.length != 0) {
1067       require(sub(_endTime, _startTime) <= 7 days);
1068       require(periods[periods.length - 1].endTime < _startTime);
1069     }
1070     // 15% -> 10% -> 5% -> 0%
1071     Period memory newPeriod;
1072     newPeriod.startTime = _startTime;
1073     newPeriod.endTime = _endTime;
1074     if(periods.length < 3) {
1075       newPeriod.bonus = sub(15, mul(5, periods.length));
1076     } else {
1077       newPeriod.bonus = 0;
1078     }
1079     periods.push(newPeriod);
1080     StartPeriod(_startTime, _endTime, newPeriod.bonus);
1081     return true;
1082   }
1083   function onSale() public returns (bool) {
1084     bool nowOnSale;
1085     for (uint i = 0; i < periods.length; i++) {
1086       if (periods[i].startTime <= now && now <= periods[i].endTime) {
1087         nowOnSale = true;
1088         break;
1089       }
1090     }
1091     return nowOnSale;
1092   }
1093   /**
1094    * @dev should be called after crowdsale ends, to do
1095    */
1096   function finalize() onlyOwner {
1097     require(!isFinalized);
1098     require(!onSale() || maxReached());
1099     finalizedTime = now;
1100     finalization();
1101     Finalized();
1102     isFinalized = true;
1103   }
1104   /**
1105    * @dev end token minting on finalization, mint tokens for dev team and reserve wallets
1106    */
1107   function finalization() internal {
1108     if (minReached()) {
1109       vault.close();
1110       uint256 totalToken = token.totalSupply();
1111       // token distribution : 50% for sale, 5% for bounty, 15% for partners, 15% for reserve, 15% for team
1112       uint256 bountyAmount = div(mul(totalToken, 5), 50);
1113       uint256 partnersAmount = div(mul(totalToken, 15), 50);
1114       uint256 reserveAmount = div(mul(totalToken, 15), 50);
1115       uint256 teamAmount = div(mul(totalToken, 15), 50);
1116       distributeToken(bountyAmount, partnersAmount, reserveAmount, teamAmount);
1117       token.enableTransfers(true);
1118     } else {
1119       vault.enableRefunds();
1120     }
1121     token.finishGenerating();
1122     token.changeController(ATCController);
1123   }
1124   function distributeToken(uint256 bountyAmount, uint256 partnersAmount, uint256 reserveAmount, uint256 teamAmount) internal {
1125     require(bountyAddress != 0x00 && partnersAddress != 0x00);
1126     require(ATCReserveLocker != 0x00 && teamLocker != 0x00);
1127     token.generateTokens(bountyAddress, bountyAmount);
1128     token.generateTokens(partnersAddress, partnersAmount);
1129     token.generateTokens(ATCReserveLocker, reserveAmount);
1130     token.generateTokens(teamLocker, teamAmount);
1131   }
1132   /**
1133    * @dev refund a lot of investors at a time checking onlyOwner
1134    * @param numToRefund uint256 The number of investors to refund
1135    */
1136   function refundAll(uint256 numToRefund) onlyOwner {
1137     require(isFinalized);
1138     require(!minReached());
1139     require(numToRefund > 0);
1140     uint256 limit = refundCompleted + numToRefund;
1141     if (limit > investorList.length) {
1142       limit = investorList.length;
1143     }
1144     for(uint256 i = refundCompleted; i < limit; i++) {
1145       vault.refund(investorList[i]);
1146     }
1147     refundCompleted = limit;
1148     RefundAll(numToRefund);
1149   }
1150   /**
1151    * @dev if crowdsale is unsuccessful, investors can claim refunds here
1152    * @param investor address The account to be refunded
1153    */
1154   function claimRefund(address investor) returns (bool) {
1155     require(isFinalized);
1156     require(!minReached());
1157     return vault.refund(investor);
1158   }
1159   function claimTokens(address _claimToken) public onlyOwner {
1160     if (token.controller() == address(this)) {
1161          token.claimTokens(_claimToken);
1162     }
1163     if (_claimToken == 0x0) {
1164         owner.transfer(this.balance);
1165         return;
1166     }
1167     ERC20Basic claimToken = ERC20Basic(_claimToken);
1168     uint256 balance = claimToken.balanceOf(this);
1169     claimToken.transfer(owner, balance);
1170     ClaimedTokens(_claimToken, owner, balance);
1171   }
1172 }
1173 /**
1174  * @title TokenTimelock
1175  * @dev TokenTimelock is a token holder contract that will allow a
1176  * beneficiary to extract the tokens after a given release time
1177  */
1178 contract ReserveLocker is SafeMath{
1179   using SafeERC20 for ERC20Basic;
1180   ERC20Basic public token;
1181   ATCCrowdSale public crowdsale;
1182   address public beneficiary;
1183   function ReserveLocker(address _token, address _crowdsale, address _beneficiary) {
1184     require(_token != 0x00);
1185     require(_crowdsale != 0x00);
1186     require(_beneficiary != 0x00);
1187     token = ERC20Basic(_token);
1188     crowdsale = ATCCrowdSale(_crowdsale);
1189     beneficiary = _beneficiary;
1190   }
1191   /**
1192    * @notice Transfers tokens held by timelock to beneficiary.
1193    */
1194    function release() public {
1195      uint256 finalizedTime = crowdsale.finalizedTime();
1196      require(finalizedTime > 0 && now > add(finalizedTime, 2 years));
1197      uint256 amount = token.balanceOf(this);
1198      require(amount > 0);
1199      token.safeTransfer(beneficiary, amount);
1200    }
1201   function setToken(address newToken) public {
1202     require(msg.sender == beneficiary);
1203     require(newToken != 0x00);
1204     token = ERC20Basic(newToken);
1205   }
1206 }
1207 /**
1208  * @title TokenTimelock
1209  * @dev TokenTimelock is a token holder contract that will allow a
1210  * beneficiary to extract the tokens after a given release time
1211  */
1212 contract TeamLocker is SafeMath{
1213   using SafeERC20 for ERC20Basic;
1214   ERC20Basic public token;
1215   ATCCrowdSale public crowdsale;
1216   address[] public beneficiaries;
1217   uint256 public collectedTokens;
1218   function TeamLocker(address _token, address _crowdsale, address[] _beneficiaries) {
1219     require(_token != 0x00);
1220     require(_crowdsale != 0x00);
1221     for (uint i = 0; i < _beneficiaries.length; i++) {
1222       require(_beneficiaries[i] != 0x00);
1223     }
1224     token = ERC20Basic(_token);
1225     crowdsale = ATCCrowdSale(_crowdsale);
1226     beneficiaries = _beneficiaries;
1227   }
1228   /**
1229    * @notice Transfers tokens held by timelock to beneficiary.
1230    */
1231   function release() public {
1232     uint256 balance = token.balanceOf(address(this));
1233     uint256 total = add(balance, collectedTokens);
1234     uint256 finalizedTime = crowdsale.finalizedTime();
1235     require(finalizedTime > 0);
1236     uint256 lockTime1 = add(finalizedTime, 183 days); // 6 months
1237     uint256 lockTime2 = add(finalizedTime, 1 years); // 1 year
1238     uint256 currentRatio = 20;
1239     if (now >= lockTime1) {
1240       currentRatio = 50;
1241     }
1242     if (now >= lockTime2) {
1243       currentRatio = 100;
1244     }
1245     uint256 releasedAmount = div(mul(total, currentRatio), 100);
1246     uint256 grantAmount = sub(releasedAmount, collectedTokens);
1247     require(grantAmount > 0);
1248     collectedTokens = add(collectedTokens, grantAmount);
1249     uint256 grantAmountForEach = div(grantAmount, 3);
1250     for (uint i = 0; i < beneficiaries.length; i++) {
1251         token.safeTransfer(beneficiaries[i], grantAmountForEach);
1252     }
1253   }
1254   function setToken(address newToken) public {
1255     require(newToken != 0x00);
1256     bool isBeneficiary;
1257     for (uint i = 0; i < beneficiaries.length; i++) {
1258       if (msg.sender == beneficiaries[i]) {
1259         isBeneficiary = true;
1260       }
1261     }
1262     require(isBeneficiary);
1263     token = ERC20Basic(newToken);
1264   }
1265 }