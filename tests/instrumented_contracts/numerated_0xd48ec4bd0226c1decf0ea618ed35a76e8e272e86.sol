1 pragma solidity ^0.4.23;
2 
3 // File: contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 contract SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 
34   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
35     return a >= b ? a : b;
36   }
37 
38   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
39     return a < b ? a : b;
40   }
41 
42   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
43     return a >= b ? a : b;
44   }
45 
46   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
47     return a < b ? a : b;
48   }
49 }
50 
51 // File: contracts/token/ERC20Basic.sol
52 
53 /**
54  * @title ERC20Basic
55  * @dev Simpler version of ERC20 interface
56  * @dev see https://github.com/ethereum/EIPs/issues/179
57  */
58 contract ERC20Basic {
59   uint256 public totalSupply;
60   function balanceOf(address who) public view returns (uint256);
61   function transfer(address to, uint256 value) public returns (bool);
62   event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 // File: contracts/Ownerable.sol
66 
67 contract Ownerable {
68     /// @notice The address of the owner is the only address that can call
69     ///  a function with this modifier
70     modifier onlyOwner { require(msg.sender == owner); _; }
71 
72     address public owner;
73 
74     constructor() public { owner = msg.sender;}
75 
76     /// @notice Changes the owner of the contract
77     /// @param _newOwner The new owner of the contract
78     function setOwner(address _newOwner) public onlyOwner {
79         owner = _newOwner;
80     }
81 }
82 
83 // File: contracts/KYC.sol
84 
85 /**
86  * @title KYC
87  * @dev KYC contract handles the white list for ASTCrowdsale contract
88  * Only accounts registered in KYC contract can buy AST token.
89  * Admins can register account, and the reason why
90  */
91 contract KYC is Ownerable {
92   // check the address is registered for token sale
93   mapping (address => bool) public registeredAddress;
94 
95   // check the address is admin of kyc contract
96   mapping (address => bool) public admin;
97 
98   event Registered(address indexed _addr);
99   event Unregistered(address indexed _addr);
100   event NewAdmin(address indexed _addr);
101   event ClaimedTokens(address _token, address owner, uint256 balance);
102 
103   /**
104    * @dev check whether the address is registered for token sale or not.
105    * @param _addr address
106    */
107   modifier onlyRegistered(address _addr) {
108     require(registeredAddress[_addr]);
109     _;
110   }
111 
112   /**
113    * @dev check whether the msg.sender is admin or not
114    */
115   modifier onlyAdmin() {
116     require(admin[msg.sender]);
117     _;
118   }
119 
120   constructor () public {
121     admin[msg.sender] = true;
122   }
123 
124   /**
125    * @dev set new admin as admin of KYC contract
126    * @param _addr address The address to set as admin of KYC contract
127    */
128   function setAdmin(address _addr)
129     public
130     onlyOwner
131   {
132     require(_addr != address(0) && admin[_addr] == false);
133     admin[_addr] = true;
134 
135     emit NewAdmin(_addr);
136   }
137 
138   /**
139    * @dev register the address for token sale
140    * @param _addr address The address to register for token sale
141    */
142   function register(address _addr)
143     public
144     onlyAdmin
145   {
146     require(_addr != address(0) && registeredAddress[_addr] == false);
147 
148     registeredAddress[_addr] = true;
149 
150     emit Registered(_addr);
151   }
152 
153   /**
154    * @dev register the addresses for token sale
155    * @param _addrs address[] The addresses to register for token sale
156    */
157   function registerByList(address[] _addrs)
158     public
159     onlyAdmin
160   {
161     for(uint256 i = 0; i < _addrs.length; i++) {
162       require(_addrs[i] != address(0) && registeredAddress[_addrs[i]] == false);
163 
164       registeredAddress[_addrs[i]] = true;
165 
166       emit Registered(_addrs[i]);
167     }
168   }
169 
170   /**
171    * @dev unregister the registered address
172    * @param _addr address The address to unregister for token sale
173    */
174   function unregister(address _addr)
175     public
176     onlyAdmin
177     onlyRegistered(_addr)
178   {
179     registeredAddress[_addr] = false;
180 
181     emit Unregistered(_addr);
182   }
183 
184   /**
185    * @dev unregister the registered addresses
186    * @param _addrs address[] The addresses to unregister for token sale
187    */
188   function unregisterByList(address[] _addrs)
189     public
190     onlyAdmin
191   {
192     for(uint256 i = 0; i < _addrs.length; i++) {
193       require(registeredAddress[_addrs[i]]);
194 
195       registeredAddress[_addrs[i]] = false;
196 
197       emit Unregistered(_addrs[i]);
198     }
199   }
200 
201   function claimTokens(address _token) public onlyOwner {
202 
203     if (_token == 0x0) {
204         owner.transfer( address(this).balance );
205         return;
206     }
207 
208     ERC20Basic token = ERC20Basic(_token);
209     uint256 balance = token.balanceOf(this);
210     token.transfer(owner, balance);
211 
212     emit ClaimedTokens(_token, owner, balance);
213   }
214 }
215 
216 // File: contracts/token/Controlled.sol
217 
218 contract Controlled {
219     /// @notice The address of the controller is the only address that can call
220     ///  a function with this modifier
221     modifier onlyController { require(msg.sender == controller); _; }
222 
223     address public controller;
224 
225     constructor() public { controller = msg.sender;}
226 
227     /// @notice Changes the controller of the contract
228     /// @param _newController The new controller of the contract
229     function changeController(address _newController) public onlyController {
230         controller = _newController;
231     }
232 }
233 
234 // File: contracts/token/TokenController.sol
235 
236 /// @dev The token controller contract must implement these functions
237 contract TokenController {
238     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
239     /// @param _owner The address that sent the ether to create tokens
240     /// @return True if the ether is accepted, false if it throws
241     function proxyPayment(address _owner) public payable returns(bool);
242 
243     /// @notice Notifies the controller about a token transfer allowing the
244     ///  controller to react if desired
245     /// @param _from The origin of the transfer
246     /// @param _to The destination of the transfer
247     /// @param _amount The amount of the transfer
248     /// @return False if the controller does not authorize the transfer
249     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
250 
251     /// @notice Notifies the controller about an approval allowing the
252     ///  controller to react if desired
253     /// @param _owner The address that calls `approve()`
254     /// @param _spender The spender in the `approve()` call
255     /// @param _amount The amount in the `approve()` call
256     /// @return False if the controller does not authorize the approval
257     function onApprove(address _owner, address _spender, uint _amount) public
258         returns(bool);
259 }
260 
261 // File: contracts/token/MiniMeToken.sol
262 
263 /*
264     Copyright 2016, Jordi Baylina
265 
266     This program is free software: you can redistribute it and/or modify
267     it under the terms of the GNU General Public License as published by
268     the Free Software Foundation, either version 3 of the License, or
269     (at your option) any later version.
270 
271     This program is distributed in the hope that it will be useful,
272     but WITHOUT ANY WARRANTY; without even the implied warranty of
273     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
274     GNU General Public License for more details.
275 
276     You should have received a copy of the GNU General Public License
277     along with this program.  If not, see <http://www.gnu.org/licenses/>.
278  */
279 
280 /// @title MiniMeToken Contract
281 /// @author Jordi Baylina
282 /// @dev This token contract's goal is to make it easy for anyone to clone this
283 ///  token using the token distribution at a given block, this will allow DAO's
284 ///  and DApps to upgrade their features in a decentralized manner without
285 ///  affecting the original token
286 /// @dev It is ERC20 compliant, but still needs to under go further testing.
287 
288 
289 
290 contract ApproveAndCallFallBack {
291     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
292 }
293 
294 /// @dev The actual token contract, the default controller is the msg.sender
295 ///  that deploys the contract, so usually this token will be deployed by a
296 ///  token controller contract, which Giveth will call a "Campaign"
297 contract MiniMeToken is Controlled {
298 
299     string public name;                //The Token's name: e.g. DigixDAO Tokens
300     uint8 public decimals;             //Number of decimals of the smallest unit
301     string public symbol;              //An identifier: e.g. REP
302     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
303 
304 
305     /// @dev `Checkpoint` is the structure that attaches a block number to a
306     ///  given value, the block number attached is the one that last changed the
307     ///  value
308     struct  Checkpoint {
309 
310         // `fromBlock` is the block number that the value was generated from
311         uint128 fromBlock;
312 
313         // `value` is the amount of tokens at a specific block number
314         uint128 value;
315     }
316 
317     // `parentToken` is the Token address that was cloned to produce this token;
318     //  it will be 0x0 for a token that was not cloned
319     MiniMeToken public parentToken;
320 
321     // `parentSnapShotBlock` is the block number from the Parent Token that was
322     //  used to determine the initial distribution of the Clone Token
323     uint public parentSnapShotBlock;
324 
325     // `creationBlock` is the block number that the Clone Token was created
326     uint public creationBlock;
327 
328     // `balances` is the map that tracks the balance of each address, in this
329     //  contract when the balance changes the block number that the change
330     //  occurred is also included in the map
331     mapping (address => Checkpoint[]) balances;
332 
333     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
334     mapping (address => mapping (address => uint256)) allowed;
335 
336     // Tracks the history of the `totalSupply` of the token
337     Checkpoint[] totalSupplyHistory;
338 
339     // Flag that determines if the token is transferable or not.
340     bool public transfersEnabled;
341 
342     // The factory used to create new clone tokens
343     MiniMeTokenFactory public tokenFactory;
344 
345 ////////////////
346 // Constructor
347 ////////////////
348 
349     /// @notice Constructor to create a MiniMeToken
350     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
351     ///  will create the Clone token contracts, the token factory needs to be
352     ///  deployed first
353     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
354     ///  new token
355     /// @param _parentSnapShotBlock Block of the parent token that will
356     ///  determine the initial distribution of the clone token, set to 0 if it
357     ///  is a new token
358     /// @param _tokenName Name of the new token
359     /// @param _decimalUnits Number of decimals of the new token
360     /// @param _tokenSymbol Token Symbol for the new token
361     /// @param _transfersEnabled If true, tokens will be able to be transferred
362     function MiniMeToken(
363         address _tokenFactory,
364         address _parentToken,
365         uint _parentSnapShotBlock,
366         string _tokenName,
367         uint8 _decimalUnits,
368         string _tokenSymbol,
369         bool _transfersEnabled
370     ) public {
371         tokenFactory = MiniMeTokenFactory(_tokenFactory);
372         name = _tokenName;                                 // Set the name
373         decimals = _decimalUnits;                          // Set the decimals
374         symbol = _tokenSymbol;                             // Set the symbol
375         parentToken = MiniMeToken(_parentToken);
376         parentSnapShotBlock = _parentSnapShotBlock;
377         transfersEnabled = _transfersEnabled;
378         creationBlock = block.number;
379     }
380 
381 
382 ///////////////////
383 // ERC20 Methods
384 ///////////////////
385 
386     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
387     /// @param _to The address of the recipient
388     /// @param _amount The amount of tokens to be transferred
389     /// @return Whether the transfer was successful or not
390     function transfer(address _to, uint256 _amount) public returns (bool success) {
391         require(transfersEnabled);
392         return doTransfer(msg.sender, _to, _amount);
393     }
394 
395     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
396     ///  is approved by `_from`
397     /// @param _from The address holding the tokens being transferred
398     /// @param _to The address of the recipient
399     /// @param _amount The amount of tokens to be transferred
400     /// @return True if the transfer was successful
401     function transferFrom(address _from, address _to, uint256 _amount
402     ) public returns (bool success) {
403 
404         // The controller of this contract can move tokens around at will,
405         //  this is important to recognize! Confirm that you trust the
406         //  controller of this contract, which in most situations should be
407         //  another open source smart contract or 0x0
408         if (msg.sender != controller) {
409             require(transfersEnabled);
410 
411             // The standard ERC 20 transferFrom functionality
412             require (allowed[_from][msg.sender] >= _amount);
413             allowed[_from][msg.sender] -= _amount;
414         }
415         return doTransfer(_from, _to, _amount);
416     }
417 
418     /// @dev This is the actual transfer function in the token contract, it can
419     ///  only be called by other functions in this contract.
420     /// @param _from The address holding the tokens being transferred
421     /// @param _to The address of the recipient
422     /// @param _amount The amount of tokens to be transferred
423     /// @return True if the transfer was successful
424     function doTransfer(address _from, address _to, uint _amount
425     ) internal returns(bool) {
426 
427            if (_amount == 0) {
428                return true;
429            }
430 
431            require(parentSnapShotBlock < block.number);
432 
433            // Do not allow transfer to 0x0 or the token contract itself
434            require((_to != 0) && (_to != address(this)));
435 
436            // If the amount being transfered is more than the balance of the
437            //  account the transfer returns false
438            uint previousBalanceFrom = balanceOfAt(_from, block.number);
439            require(previousBalanceFrom >= _amount);
440            //if (previousBalanceFrom < _amount) {
441            //    return false;
442            //}
443 
444            // Alerts the token controller of the transfer
445            if (isContract(controller)) {
446                require(TokenController(controller).onTransfer(_from, _to, _amount));
447            }
448 
449            // First update the balance array with the new value for the address
450            //  sending the tokens
451            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
452 
453            // Then update the balance array with the new value for the address
454            //  receiving the tokens
455            uint previousBalanceTo = balanceOfAt(_to, block.number);
456            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
457            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
458 
459            // An event to make the transfer easy to find on the blockchain
460            emit Transfer(_from, _to, _amount);
461 
462            return true;
463     }
464 
465     /// @param _owner The address that's balance is being requested
466     /// @return The balance of `_owner` at the current block
467     function balanceOf(address _owner) public constant returns (uint256 balance) {
468         return balanceOfAt(_owner, block.number);
469     }
470 
471     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
472     ///  its behalf. This is a modified version of the ERC20 approve function
473     ///  to be a little bit safer
474     /// @param _spender The address of the account able to transfer the tokens
475     /// @param _amount The amount of tokens to be approved for transfer
476     /// @return True if the approval was successful
477     function approve(address _spender, uint256 _amount) public returns (bool success) {
478         require(transfersEnabled);
479 
480         // To change the approve amount you first have to reduce the addresses`
481         //  allowance to zero by calling `approve(_spender,0)` if it is not
482         //  already 0 to mitigate the race condition described here:
483         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
484         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
485 
486         // Alerts the token controller of the approve function call
487         if (isContract(controller)) {
488             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
489         }
490 
491         allowed[msg.sender][_spender] = _amount;
492         emit Approval(msg.sender, _spender, _amount);
493         return true;
494     }
495 
496     /// @dev This function makes it easy to read the `allowed[]` map
497     /// @param _owner The address of the account that owns the token
498     /// @param _spender The address of the account able to transfer the tokens
499     /// @return Amount of remaining tokens of _owner that _spender is allowed
500     ///  to spend
501     function allowance(address _owner, address _spender
502     ) public constant returns (uint256 remaining) {
503         return allowed[_owner][_spender];
504     }
505 
506     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
507     ///  its behalf, and then a function is triggered in the contract that is
508     ///  being approved, `_spender`. This allows users to use their tokens to
509     ///  interact with contracts in one function call instead of two
510     /// @param _spender The address of the contract able to transfer the tokens
511     /// @param _amount The amount of tokens to be approved for transfer
512     /// @return True if the function call was successful
513     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
514     ) public returns (bool success) {
515         require(approve(_spender, _amount));
516 
517         ApproveAndCallFallBack(_spender).receiveApproval(
518             msg.sender,
519             _amount,
520             this,
521             _extraData
522         );
523 
524         return true;
525     }
526 
527     /// @dev This function makes it easy to get the total number of tokens
528     /// @return The total number of tokens
529     function totalSupply() public constant returns (uint) {
530         return totalSupplyAt(block.number);
531     }
532 
533 
534 ////////////////
535 // Query balance and totalSupply in History
536 ////////////////
537 
538     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
539     /// @param _owner The address from which the balance will be retrieved
540     /// @param _blockNumber The block number when the balance is queried
541     /// @return The balance at `_blockNumber`
542     function balanceOfAt(address _owner, uint _blockNumber) public constant
543         returns (uint) {
544 
545         // These next few lines are used when the balance of the token is
546         //  requested before a check point was ever created for this token, it
547         //  requires that the `parentToken.balanceOfAt` be queried at the
548         //  genesis block for that token as this contains initial balance of
549         //  this token
550         if ((balances[_owner].length == 0)
551             || (balances[_owner][0].fromBlock > _blockNumber)) {
552             if (address(parentToken) != 0) {
553                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
554             } else {
555                 // Has no parent
556                 return 0;
557             }
558 
559         // This will return the expected balance during normal situations
560         } else {
561             return getValueAt(balances[_owner], _blockNumber);
562         }
563     }
564 
565     /// @notice Total amount of tokens at a specific `_blockNumber`.
566     /// @param _blockNumber The block number when the totalSupply is queried
567     /// @return The total amount of tokens at `_blockNumber`
568     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
569 
570         // These next few lines are used when the totalSupply of the token is
571         //  requested before a check point was ever created for this token, it
572         //  requires that the `parentToken.totalSupplyAt` be queried at the
573         //  genesis block for this token as that contains totalSupply of this
574         //  token at this block number.
575         if ((totalSupplyHistory.length == 0)
576             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
577             if (address(parentToken) != 0) {
578                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
579             } else {
580                 return 0;
581             }
582 
583         // This will return the expected totalSupply during normal situations
584         } else {
585             return getValueAt(totalSupplyHistory, _blockNumber);
586         }
587     }
588 
589 ////////////////
590 // Clone Token Method
591 ////////////////
592 
593     /// @notice Creates a new clone token with the initial distribution being
594     ///  this token at `_snapshotBlock`
595     /// @param _cloneTokenName Name of the clone token
596     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
597     /// @param _cloneTokenSymbol Symbol of the clone token
598     /// @param _snapshotBlock Block when the distribution of the parent token is
599     ///  copied to set the initial distribution of the new clone token;
600     ///  if the block is zero than the actual block, the current block is used
601     /// @param _transfersEnabled True if transfers are allowed in the clone
602     /// @return The address of the new MiniMeToken Contract
603     function createCloneToken(
604         string _cloneTokenName,
605         uint8 _cloneDecimalUnits,
606         string _cloneTokenSymbol,
607         uint _snapshotBlock,
608         bool _transfersEnabled
609         ) public returns(address) {
610         if (_snapshotBlock == 0) _snapshotBlock = block.number;
611         MiniMeToken cloneToken = tokenFactory.createCloneToken(
612             this,
613             _snapshotBlock,
614             _cloneTokenName,
615             _cloneDecimalUnits,
616             _cloneTokenSymbol,
617             _transfersEnabled
618             );
619 
620         cloneToken.changeController(msg.sender);
621 
622         // An event to make the token easy to find on the blockchain
623         emit NewCloneToken(address(cloneToken), _snapshotBlock);
624         return address(cloneToken);
625     }
626 
627 ////////////////
628 // Generate and destroy tokens
629 ////////////////
630 
631     /// @notice Generates `_amount` tokens that are assigned to `_owner`
632     /// @param _owner The address that will be assigned the new tokens
633     /// @param _amount The quantity of tokens generated
634     /// @return True if the tokens are generated correctly
635     function generateTokens(address _owner, uint _amount
636     ) public onlyController returns (bool) {
637         uint curTotalSupply = totalSupply();
638         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
639         uint previousBalanceTo = balanceOf(_owner);
640         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
641         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
642         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
643         emit Transfer(0, _owner, _amount);
644         return true;
645     }
646 
647     /// @notice Burns `_amount` tokens from `_owner`
648     /// @param _owner The address that will lose the tokens
649     /// @param _amount The quantity of tokens to burn
650     /// @return True if the tokens are burned correctly
651     function destroyTokens(address _owner, uint _amount
652     ) onlyController public returns (bool) {
653         uint curTotalSupply = totalSupply();
654         require(curTotalSupply >= _amount);
655         uint previousBalanceFrom = balanceOf(_owner);
656         require(previousBalanceFrom >= _amount);
657         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
658         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
659         emit Transfer(_owner, 0, _amount);
660         return true;
661     }
662 
663 ////////////////
664 // Enable tokens transfers
665 ////////////////
666 
667 
668     /// @notice Enables token holders to transfer their tokens freely if true
669     /// @param _transfersEnabled True if transfers are allowed in the clone
670     function enableTransfers(bool _transfersEnabled) public onlyController {
671         transfersEnabled = _transfersEnabled;
672     }
673 
674 ////////////////
675 // Internal helper functions to query and set a value in a snapshot array
676 ////////////////
677 
678     /// @dev `getValueAt` retrieves the number of tokens at a given block number
679     /// @param checkpoints The history of values being queried
680     /// @param _block The block number to retrieve the value at
681     /// @return The number of tokens being queried
682     function getValueAt(Checkpoint[] storage checkpoints, uint _block
683     ) constant internal returns (uint) {
684         if (checkpoints.length == 0) return 0;
685 
686         // Shortcut for the actual value
687         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
688             return checkpoints[checkpoints.length-1].value;
689         if (_block < checkpoints[0].fromBlock) return 0;
690 
691         // Binary search of the value in the array
692         uint min = 0;
693         uint max = checkpoints.length-1;
694         while (max > min) {
695             uint mid = (max + min + 1)/ 2;
696             if (checkpoints[mid].fromBlock<=_block) {
697                 min = mid;
698             } else {
699                 max = mid-1;
700             }
701         }
702         return checkpoints[min].value;
703     }
704 
705     /// @dev `updateValueAtNow` used to update the `balances` map and the
706     ///  `totalSupplyHistory`
707     /// @param checkpoints The history of data being updated
708     /// @param _value The new number of tokens
709     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
710     ) internal  {
711         if ((checkpoints.length == 0)
712         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
713                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
714                newCheckPoint.fromBlock =  uint128(block.number);
715                newCheckPoint.value = uint128(_value);
716            } else {
717                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
718                oldCheckPoint.value = uint128(_value);
719            }
720     }
721     
722     /// @dev Internal function to determine if an address is a contract
723     /// @param _addr The address being queried
724     /// @return True if `_addr` is a contract
725     function isContract(address _addr) constant internal returns(bool) {
726         uint size;
727         if (_addr == 0) return false;
728         assembly {
729             size := extcodesize(_addr)
730         }
731         return size>0;
732     }
733 
734     /// @dev Helper function to return a min betwen the two uints
735     function min(uint a, uint b) pure internal returns (uint) {
736         return a < b ? a : b;
737     }
738 
739     /// @notice The fallback function: If the contract's controller has not been
740     ///  set to 0, then the `proxyPayment` method is called which relays the
741     ///  ether and creates tokens as described in the token controller contract
742     function () public payable {
743         require(isContract(controller));
744         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
745     }
746 
747 //////////
748 // Safety Methods
749 //////////
750 
751     /// @notice This method can be used by the controller to extract mistakenly
752     ///  sent tokens to this contract.
753     /// @param _token The address of the token contract that you want to recover
754     ///  set to 0 in case you want to extract ether.
755     function claimTokens(address _token) public onlyController {
756         if (_token == 0x0) {
757             controller.transfer( address(this).balance);
758             return;
759         }
760 
761         MiniMeToken token = MiniMeToken(_token);
762         uint balance = token.balanceOf(this);
763         token.transfer(controller, balance);
764         emit ClaimedTokens(_token, controller, balance);
765     }
766 
767 ////////////////
768 // Events
769 ////////////////
770     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
771     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
772     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
773     event Approval(
774         address indexed _owner,
775         address indexed _spender,
776         uint256 _amount
777         );
778 
779 }
780 
781 
782 ////////////////
783 // MiniMeTokenFactory
784 ////////////////
785 
786 /// @dev This contract is used to generate clone contracts from a contract.
787 ///  In solidity this is the way to create a contract from a contract of the
788 ///  same class
789 contract MiniMeTokenFactory {
790 
791     /// @notice Update the DApp by creating a new token with new functionalities
792     ///  the msg.sender becomes the controller of this clone token
793     /// @param _parentToken Address of the token being cloned
794     /// @param _snapshotBlock Block of the parent token that will
795     ///  determine the initial distribution of the clone token
796     /// @param _tokenName Name of the new token
797     /// @param _decimalUnits Number of decimals of the new token
798     /// @param _tokenSymbol Token Symbol for the new token
799     /// @param _transfersEnabled If true, tokens will be able to be transferred
800     /// @return The address of the new token contract
801     function createCloneToken(
802         address _parentToken,
803         uint _snapshotBlock,
804         string _tokenName,
805         uint8 _decimalUnits,
806         string _tokenSymbol,
807         bool _transfersEnabled
808     ) public returns (MiniMeToken) {
809         MiniMeToken newToken = new MiniMeToken(
810             this,
811             _parentToken,
812             _snapshotBlock,
813             _tokenName,
814             _decimalUnits,
815             _tokenSymbol,
816             _transfersEnabled
817             );
818 
819         newToken.changeController(msg.sender);
820         return newToken;
821     }
822 }
823 
824 // File: contracts/HEX.sol
825 
826 contract HEX is MiniMeToken {
827     mapping (address => bool) public blacklisted;
828     bool public generateFinished;
829 
830     constructor (address _tokenFactory)
831         MiniMeToken(
832               _tokenFactory,
833               0x0,                     // no parent token
834               0,                       // no snapshot block number from parent
835               "Health Evolution on X.blockchain",  // Token name
836               18,                      // Decimals
837               "HEX",                   // Symbol
838               false                     // Enable transfers
839           ) {
840     }
841 
842     function generateTokens(address _holder, uint _amount) public onlyController returns (bool) {
843         require(generateFinished == false);
844         return super.generateTokens(_holder, _amount);
845     }
846 
847     function doTransfer(address _from, address _to, uint _amount) internal returns(bool) {
848         require(blacklisted[_from] == false);
849         return super.doTransfer(_from, _to, _amount);
850     }
851 
852     function finishGenerating() public onlyController returns (bool) {
853         generateFinished = true;
854         return true;
855     }
856 
857     function blacklistAccount(address tokenOwner) public onlyController returns (bool success) {
858         blacklisted[tokenOwner] = true;
859         return true;
860     }
861 
862     function unBlacklistAccount(address tokenOwner) public onlyController returns (bool success) {
863         blacklisted[tokenOwner] = false;
864         return true;
865     }
866 
867 //////////
868 // Safety Methods
869 //////////
870 
871     /// @notice This method can be used by the controller to extract mistakenly
872     ///  sent tokens to this contract.
873     /// @param _token The address of the token contract that you want to recover
874     ///  set to 0 in case you want to extract ether.
875     function claimTokens(address _token) public onlyController {
876         if (_token == 0x0) {
877             controller.transfer( address(this).balance);
878             return;
879         }
880 
881         MiniMeToken token = MiniMeToken(_token);
882         uint balance = token.balanceOf(address(this));
883         token.transfer(controller, balance);
884 
885         emit ClaimedTokens(_token, controller, balance);
886     }
887 
888     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
889 }
890 
891 // File: contracts/atxinf/ATXICOToken.sol
892 
893 contract ATXICOToken {
894     function atxBuy(address _from, uint256 _amount) public returns(bool);
895 }
896 
897 // File: contracts/HEXCrowdSale.sol
898 
899 contract HEXCrowdSale is Ownerable, SafeMath, ATXICOToken {
900   uint256 public maxHEXCap;
901   uint256 public minHEXCap;
902 
903   uint256 public ethRate;
904   uint256 public atxRate;
905   /* uint256 public ethFunded;
906   uint256 public atxFunded; */
907 
908   address[] public ethInvestors;
909   mapping (address => uint256) public ethInvestorFunds;
910 
911   address[] public atxInvestors;
912   mapping (address => uint256) public atxInvestorFunds;
913 
914   address[] public atxChangeAddrs;
915   mapping (address => uint256) public atxChanges;
916 
917   KYC public kyc;
918   HEX public hexToken;
919   address public hexControllerAddr;
920   ERC20Basic public atxToken;
921   address public atxControllerAddr;
922   //Vault public vault;
923 
924   address[] public memWallets;
925   address[] public vaultWallets;
926 
927   struct Period {
928     uint256 startTime;
929     uint256 endTime;
930     uint256 bonus; // used to calculate rate with bonus. ragne 0 ~ 15 (0% ~ 15%)
931   }
932   Period[] public periods;
933 
934   bool public isInitialized;
935   bool public isFinalized;
936 
937   function init (
938     address _kyc,
939     address _token,
940     address _hexController,
941     address _atxToken,
942     address _atxController,
943     // address _vault,
944     address[] _memWallets,
945     address[] _vaultWallets,
946     uint256 _ethRate,
947     uint256 _atxRate,
948     uint256 _maxHEXCap,
949     uint256 _minHEXCap ) public onlyOwner {
950 
951       require(isInitialized == false);
952 
953       kyc = KYC(_kyc);
954       hexToken = HEX(_token);
955       hexControllerAddr = _hexController;
956       atxToken = ERC20Basic(_atxToken);
957       atxControllerAddr = _atxController;
958 
959       memWallets = _memWallets;
960       vaultWallets = _vaultWallets;
961 
962       /* vault = Vault(_vault);
963       vault.setFundTokenAddr(_atxToken); */
964 
965       ethRate = _ethRate;
966       atxRate = _atxRate;
967 
968       maxHEXCap = _maxHEXCap;
969       minHEXCap = _minHEXCap;
970 
971       isInitialized = true;
972     }
973 
974     function () public payable {
975       ethBuy();
976     }
977 
978     function ethBuy() internal {
979       // check validity
980       require(msg.value >= 50e18); // minimum fund
981 
982       require(isInitialized);
983       require(!isFinalized);
984 
985       require(msg.sender != 0x0 && msg.value != 0x0);
986       require(kyc.registeredAddress(msg.sender));
987       require(maxReached() == false);
988       require(onSale());
989 
990       uint256 fundingAmt = msg.value;
991       uint256 bonus = getPeriodBonus();
992       uint256 currTotalSupply = hexToken.totalSupply();
993       uint256 fundableHEXRoom = sub(maxHEXCap, currTotalSupply);
994       uint256 reqedHex = eth2HexWithBonus(fundingAmt, bonus);
995       uint256 toFund;
996       uint256 reFund;
997 
998       if(reqedHex > fundableHEXRoom) {
999         reqedHex = fundableHEXRoom;
1000 
1001         toFund = hex2EthWithBonus(reqedHex, bonus); //div(fundableHEXRoom, mul(ethRate, add(1, div(bonus,100))));
1002         reFund = sub(fundingAmt, toFund);
1003 
1004         // toFund 로 계산한 HEX 수량이 fundableHEXRoom 과 같아야 한다.
1005         // 그러나 소수점 문제로 인하여 정확히 같아지지 않을 경우가 발생한다.
1006         //require(reqedHex == eth2HexWithBonus(toFund, bonus) );
1007 
1008       } else {
1009         toFund = fundingAmt;
1010         reFund = 0;
1011       }
1012 
1013       require(fundingAmt >= toFund);
1014       require(toFund > 0);
1015 
1016       // pushInvestorList
1017       if(ethInvestorFunds[msg.sender] == 0x0) {
1018         ethInvestors.push(msg.sender);
1019       }
1020       ethInvestorFunds[msg.sender] = add(ethInvestorFunds[msg.sender], toFund);
1021 
1022       /* ethFunded = add(ethFunded, toFund); */
1023 
1024       hexToken.generateTokens(msg.sender, reqedHex);
1025 
1026       if(reFund > 0) {
1027         msg.sender.transfer(reFund);
1028       }
1029 
1030       //vault.ethDeposit.value(toFund)(msg.sender);
1031 
1032       emit SaleToken(msg.sender, msg.sender, 0, toFund, reqedHex);
1033     }
1034 
1035     //
1036     // ATXICOToken 메소드 구현.
1037     // 외부에서 이 함수가 바로 호출되면 코인 생성됨.
1038     // 반드시 ATXController 에서만 호출 허용 할 것.
1039     //
1040     function atxBuy(address _from, uint256 _amount) public returns(bool) {
1041       // check validity
1042       require(_amount >= 250000e18); // minimum fund
1043 
1044       require(isInitialized);
1045       require(!isFinalized);
1046 
1047       require(_from != 0x0 && _amount != 0x0);
1048       require(kyc.registeredAddress(_from));
1049       require(maxReached() == false);
1050       require(onSale());
1051 
1052       // Only from ATX Controller.
1053       require(msg.sender == atxControllerAddr);
1054 
1055       // 수신자(현재컨트랙트) atx 수신후 잔액 오버플로우 확인.
1056       uint256 currAtxBal = atxToken.balanceOf( address(this) );
1057       require(currAtxBal + _amount >= currAtxBal); // Check for overflow
1058 
1059       uint256 fundingAmt = _amount;
1060       uint256 bonus = getPeriodBonus();
1061       uint256 currTotalSupply = hexToken.totalSupply();
1062       uint256 fundableHEXRoom = sub(maxHEXCap, currTotalSupply);
1063       uint256 reqedHex = atx2HexWithBonus(fundingAmt, bonus); //mul(add(fundingAmt, mul(fundingAmt, div(bonus, 100))), atxRate);
1064       uint256 toFund;
1065       uint256 reFund;
1066 
1067       if(reqedHex > fundableHEXRoom) {
1068         reqedHex = fundableHEXRoom;
1069 
1070         toFund = hex2AtxWithBonus(reqedHex, bonus); //div(fundableHEXRoom, mul(atxRate, add(1, div(bonus,100))));
1071         reFund = sub(fundingAmt, toFund);
1072 
1073         // toFund 로 계산한 HEX 수량이 fundableHEXRoom 과 같아야 한다.
1074         // 그러나 소수점 문제로 인하여 정확히 같아지지 않을 경우가 발생한다.
1075         //require(reqedHex == atx2HexWithBonus(toFund, bonus) );
1076 
1077       } else {
1078         toFund = fundingAmt;
1079         reFund = 0;
1080       }
1081 
1082       require(fundingAmt >= toFund);
1083       require(toFund > 0);
1084 
1085 
1086       // pushInvestorList
1087       if(atxInvestorFunds[_from] == 0x0) {
1088         atxInvestors.push(_from);
1089       }
1090       atxInvestorFunds[_from] = add(atxInvestorFunds[_from], toFund);
1091 
1092       /* atxFunded = add(atxFunded, toFund); */
1093 
1094       hexToken.generateTokens(_from, reqedHex);
1095 
1096       // 현재 시점에서
1097       // HEXCrowdSale 이 수신한 ATX 는
1098       // 아직 HEXCrowdSale 계정의 잔액에 반영되지 않았다....
1099       // _amount 는 아직 this 의 잔액에 반영되지 않았기때문에,
1100       // 이것을 vault 로 전송할 수도 없고,
1101       // 잔액을 되돌릴 수도 없다.
1102       if(reFund > 0) {
1103         //atxToken.transfer(_from, reFund);
1104         if(atxChanges[_from] == 0x0) {
1105           atxChangeAddrs.push(_from);
1106         }
1107         atxChanges[_from] = add(atxChanges[_from], reFund);
1108       }
1109 
1110       // 현재 시점에서
1111       // HEXCrowdSale 이 수신한 ATX 는
1112       // 아직 HEXCrowdSale 계정의 잔액에 반영되지 않았다....
1113       // 그래서 vault 로 전송할 수가 없다.
1114       //if( atxToken.transfer( address(vault), toFund) ) {
1115         //vault.atxDeposit(_from, toFund);
1116       //}
1117 
1118       emit SaleToken(msg.sender, _from, 1, toFund, reqedHex);
1119 
1120       return true;
1121     }
1122 
1123     function finish() public onlyOwner {
1124       require(!isFinalized);
1125 
1126       returnATXChanges();
1127 
1128       if(minReached()) {
1129 
1130         //vault.close();
1131         require(vaultWallets.length == 31);
1132         uint eachATX = div(atxToken.balanceOf(address(this)), vaultWallets.length);
1133         for(uint idx = 0; idx < vaultWallets.length; idx++) {
1134           // atx
1135           atxToken.transfer(vaultWallets[idx], eachATX);
1136         }
1137         // atx remained
1138         if(atxToken.balanceOf(address(this)) > 0) {
1139           atxToken.transfer(vaultWallets[vaultWallets.length - 1], atxToken.balanceOf(address(this)));
1140         }
1141         // ether
1142         //if(address(this).balance > 0) {
1143           vaultWallets[vaultWallets.length - 1].transfer( address(this).balance );
1144         //}
1145 
1146         require(memWallets.length == 6);
1147         hexToken.generateTokens(memWallets[0], 14e26); // airdrop
1148         hexToken.generateTokens(memWallets[1], 84e25); // team locker
1149         hexToken.generateTokens(memWallets[2], 84e25); // advisors locker
1150         hexToken.generateTokens(memWallets[3], 80e25); // healthdata mining
1151         hexToken.generateTokens(memWallets[4], 92e25); // marketing
1152         hexToken.generateTokens(memWallets[5], 80e25); // reserved
1153 
1154         //hexToken.enableTransfers(true);
1155 
1156       } else {
1157         //vault.enableRefunds();
1158       }
1159 
1160       hexToken.finishGenerating();
1161       hexToken.changeController(hexControllerAddr);
1162 
1163       isFinalized = true;
1164 
1165       emit SaleFinished();
1166     }
1167 
1168     function maxReached() public view returns (bool) {
1169       return (hexToken.totalSupply() >= maxHEXCap);
1170     }
1171 
1172     function minReached() public view returns (bool) {
1173       return (hexToken.totalSupply() >= minHEXCap);
1174     }
1175 
1176     function addPeriod(uint256 _start, uint256 _end) public onlyOwner {
1177       require(now < _start && _start < _end);
1178       if (periods.length != 0) {
1179         //require(sub(_endTime, _startTime) <= 7 days);
1180         require(periods[periods.length - 1].endTime < _start);
1181       }
1182       Period memory newPeriod;
1183       newPeriod.startTime = _start;
1184       newPeriod.endTime = _end;
1185       newPeriod.bonus = 0;
1186       if(periods.length == 0) {
1187         newPeriod.bonus = 50; // Private
1188       }
1189       else if(periods.length == 1) {
1190         newPeriod.bonus = 30; // pre
1191       }
1192       else if(periods.length == 2) {
1193         newPeriod.bonus = 20; // crowd 1
1194       }
1195       else if (periods.length == 3) {
1196         newPeriod.bonus = 15; // crowd 2
1197       }
1198       else if (periods.length == 4) {
1199         newPeriod.bonus = 10; // crowd 3
1200       }
1201       else if (periods.length == 5) {
1202         newPeriod.bonus = 5; // crowd 4
1203       }
1204 
1205       periods.push(newPeriod);
1206     }
1207 
1208     function getPeriodBonus() public view returns (uint256) {
1209       bool nowOnSale;
1210       uint256 currentPeriod;
1211 
1212       for (uint i = 0; i < periods.length; i++) {
1213         if (periods[i].startTime <= now && now <= periods[i].endTime) {
1214           nowOnSale = true;
1215           currentPeriod = i;
1216           break;
1217         }
1218       }
1219 
1220       require(nowOnSale);
1221       return periods[currentPeriod].bonus;
1222     }
1223 
1224     function eth2HexWithBonus(uint256 _eth, uint256 bonus) public view returns(uint256) {
1225       uint basic = mul(_eth, ethRate);
1226       return div(mul(basic, add(bonus, 100)), 100);
1227       //return add(basic, div(mul(basic, bonus), 100));
1228     }
1229 
1230     function hex2EthWithBonus(uint256 _hex, uint256 bonus) public view returns(uint256)  {
1231       return div(mul(_hex, 100), mul(ethRate, add(100, bonus)));
1232       //return div(_hex, mul(ethRate, add(1, div(bonus,100))));
1233     }
1234 
1235     function atx2HexWithBonus(uint256 _atx, uint256 bonus) public view returns(uint256)  {
1236       uint basic = mul(_atx, atxRate);
1237       return div(mul(basic, add(bonus, 100)), 100);
1238       //return add(basic, div(mul(basic, bonus), 100));
1239     }
1240 
1241     function hex2AtxWithBonus(uint256 _hex, uint256 bonus) public view returns(uint256)  {
1242       return div(mul(_hex, 100), mul(atxRate, add(100, bonus)));
1243       //return div(_hex, mul(atxRate, add(1, div(bonus,100))));
1244     }
1245 
1246     function onSale() public view returns (bool) {
1247       bool nowOnSale;
1248 
1249       // Except Private Sale...
1250       for (uint i = 1; i < periods.length; i++) {
1251         if (periods[i].startTime <= now && now <= periods[i].endTime) {
1252           nowOnSale = true;
1253           break;
1254         }
1255       }
1256 
1257       return nowOnSale;
1258     }
1259 
1260     function atxChangeAddrCount() public view returns(uint256) {
1261       return atxChangeAddrs.length;
1262     }
1263 
1264     function returnATXChanges() public onlyOwner {
1265       //require(atxChangeAddrs.length > 0);
1266 
1267       for(uint256 i=0; i<atxChangeAddrs.length; i++) {
1268         if(atxChanges[atxChangeAddrs[i]] > 0) {
1269             if( atxToken.transfer(atxChangeAddrs[i], atxChanges[atxChangeAddrs[i]]) ) {
1270               atxChanges[atxChangeAddrs[i]] = 0x0;
1271             }
1272         }
1273       }
1274     }
1275 
1276     //
1277     // Safety Methods
1278     function claimTokens(address _claimToken) public onlyOwner {
1279 
1280       if (hexToken.controller() == address(this)) {
1281            hexToken.claimTokens(_claimToken);
1282       }
1283 
1284       if (_claimToken == 0x0) {
1285           owner.transfer(address(this).balance);
1286           return;
1287       }
1288 
1289       ERC20Basic claimToken = ERC20Basic(_claimToken);
1290       uint256 balance = claimToken.balanceOf( address(this) );
1291       claimToken.transfer(owner, balance);
1292 
1293       emit ClaimedTokens(_claimToken, owner, balance);
1294     }
1295 
1296     //
1297     // Event
1298 
1299     event SaleToken(address indexed _sender, address indexed _investor, uint256 indexed _fundType, uint256 _toFund, uint256 _hexTokens);
1300     event ClaimedTokens(address indexed _claimToken, address indexed owner, uint256 balance);
1301     event SaleFinished();
1302   }