1 pragma solidity ^0.4.21;
2 
3 // File: contracts/minime/Controlled.sol
4 
5 contract Controlled {
6     /// @notice The address of the controller is the only address that can call
7     ///  a function with this modifier
8     modifier onlyController { require(msg.sender == controller); _; }
9 
10     address public controller;
11 
12     function Controlled() public { controller = msg.sender;}
13 
14     /// @notice Changes the controller of the contract
15     /// @param _newController The new controller of the contract
16     function changeController(address _newController) public onlyController {
17         controller = _newController;
18     }
19 }
20 
21 // File: contracts/minime/TokenController.sol
22 
23 /// @dev The token controller contract must implement these functions
24 contract TokenController {
25     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
26     /// @param _owner The address that sent the ether to create tokens
27     /// @return True if the ether is accepted, false if it throws
28     function proxyPayment(address _owner) public payable returns(bool);
29 
30     /// @notice Notifies the controller about a token transfer allowing the
31     ///  controller to react if desired
32     /// @param _from The origin of the transfer
33     /// @param _to The destination of the transfer
34     /// @param _amount The amount of the transfer
35     /// @return False if the controller does not authorize the transfer
36     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
37 
38     /// @notice Notifies the controller about an approval allowing the
39     ///  controller to react if desired
40     /// @param _owner The address that calls `approve()`
41     /// @param _spender The spender in the `approve()` call
42     /// @param _amount The amount in the `approve()` call
43     /// @return False if the controller does not authorize the approval
44     function onApprove(address _owner, address _spender, uint _amount) public
45         returns(bool);
46 }
47 
48 // File: contracts/minime/MiniMeToken.sol
49 
50 /*
51     Copyright 2016, Jordi Baylina
52 
53     This program is free software: you can redistribute it and/or modify
54     it under the terms of the GNU General Public License as published by
55     the Free Software Foundation, either version 3 of the License, or
56     (at your option) any later version.
57 
58     This program is distributed in the hope that it will be useful,
59     but WITHOUT ANY WARRANTY; without even the implied warranty of
60     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPoSE.  See the
61     GNU General Public License for more details.
62 
63     You should have received a copy of the GNU General Public License
64     along with this program.  If not, see <http://www.gnu.org/licenses/>.
65  */
66 
67 /// @title MiniMeToken Contract
68 /// @author Jordi Baylina
69 /// @dev This token contract's goal is to make it easy for anyone to clone this
70 ///  token using the token distribution at a given block, this will allow DAO's
71 ///  and DApps to upgrade their features in a decentralized manner without
72 ///  affecting the original token
73 /// @dev It is ERC20 compliant, but still needs to under go further testing.
74 
75 
76 
77 contract ApproveAndCallFallBack {
78     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
79 }
80 
81 /// @dev The actual token contract, the default controller is the msg.sender
82 ///  that deploys the contract, so usually this token will be deployed by a
83 ///  token controller contract, which Giveth will call a "Campaign"
84 contract MiniMeToken is Controlled {
85 
86     string public name;                //The Token's name: e.g. DigixDAO Tokens
87     uint8 public decimals;             //Number of decimals of the smallest unit
88     string public symbol;              //An identifier: e.g. REP
89     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
90 
91 
92     /// @dev `Checkpoint` is the structure that attaches a block number to a
93     ///  given value, the block number attached is the one that last changed the
94     ///  value
95     struct Checkpoint {
96 
97         // `fromBlock` is the block number that the value was generated from
98         uint128 fromBlock;
99 
100         // `value` is the amount of tokens at a specific block number
101         uint128 value;
102     }
103 
104     // `parentToken` is the Token address that was cloned to produce this token;
105     //  it will be 0x0 for a token that was not cloned
106     MiniMeToken public parentToken;
107 
108     // `parentSnapShotBlock` is the block number from the Parent Token that was
109     //  used to determine the initial distribution of the Clone Token
110     uint public parentSnapShotBlock;
111 
112     // `creationBlock` is the block number that the Clone Token was created
113     uint public creationBlock;
114 
115     // `balances` is the map that tracks the balance of each address, in this
116     //  contract when the balance changes the block number that the change
117     //  occurred is also included in the map
118     mapping (address => Checkpoint[]) balances;
119 
120     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
121     mapping (address => mapping (address => uint256)) allowed;
122 
123     // Tracks the history of the `totalSupply` of the token
124     Checkpoint[] totalSupplyHistory;
125 
126     // Flag that determines if the token is transferable or not.
127     bool public transfersEnabled;
128 
129     // The factory used to create new clone tokens
130     MiniMeTokenFactory public tokenFactory;
131 
132 ////////////////
133 // Constructor
134 ////////////////
135 
136     /// @notice Constructor to create a MiniMeToken
137     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
138     ///  will create the Clone token contracts, the token factory needs to be
139     ///  deployed first
140     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
141     ///  new token
142     /// @param _parentSnapShotBlock Block of the parent token that will
143     ///  determine the initial distribution of the clone token, set to 0 if it
144     ///  is a new token
145     /// @param _tokenName Name of the new token
146     /// @param _decimalUnits Number of decimals of the new token
147     /// @param _tokenSymbol Token Symbol for the new token
148     /// @param _transfersEnabled If true, tokens will be able to be transferred
149     function MiniMeToken(
150         address _tokenFactory,
151         address _parentToken,
152         uint _parentSnapShotBlock,
153         string _tokenName,
154         uint8 _decimalUnits,
155         string _tokenSymbol,
156         bool _transfersEnabled
157     ) public {
158         tokenFactory = MiniMeTokenFactory(_tokenFactory);
159         name = _tokenName;                                 // Set the name
160         decimals = _decimalUnits;                          // Set the decimals
161         symbol = _tokenSymbol;                             // Set the symbol
162         parentToken = MiniMeToken(_parentToken);
163         parentSnapShotBlock = _parentSnapShotBlock;
164         transfersEnabled = _transfersEnabled;
165         creationBlock = block.number;
166     }
167 
168 
169 ///////////////////
170 // ERC20 Methods
171 ///////////////////
172 
173     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
174     /// @param _to The address of the recipient
175     /// @param _amount The amount of tokens to be transferred
176     /// @return Whether the transfer was successful or not
177     function transfer(address _to, uint256 _amount) public returns (bool success) {
178         require(transfersEnabled);
179         doTransfer(msg.sender, _to, _amount);
180         return true;
181     }
182 
183     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
184     ///  is approved by `_from`
185     /// @param _from The address holding the tokens being transferred
186     /// @param _to The address of the recipient
187     /// @param _amount The amount of tokens to be transferred
188     /// @return True if the transfer was successful
189     function transferFrom(address _from, address _to, uint256 _amount
190     ) public returns (bool success) {
191 
192         // The controller of this contract can move tokens around at will,
193         //  this is important to recognize! Confirm that you trust the
194         //  controller of this contract, which in most situations should be
195         //  another open source smart contract or 0x0
196         if (msg.sender != controller) {
197             require(transfersEnabled);
198 
199             // The standard ERC 20 transferFrom functionality
200             require(allowed[_from][msg.sender] >= _amount);
201             allowed[_from][msg.sender] -= _amount;
202         }
203         doTransfer(_from, _to, _amount);
204         return true;
205     }
206 
207     /// @dev This is the actual transfer function in the token contract, it can
208     ///  only be called by other functions in this contract.
209     /// @param _from The address holding the tokens being transferred
210     /// @param _to The address of the recipient
211     /// @param _amount The amount of tokens to be transferred
212     /// @return True if the transfer was successful
213     function doTransfer(address _from, address _to, uint _amount
214     ) internal {
215 
216            if (_amount == 0) {
217                Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
218                return;
219            }
220 
221            require(parentSnapShotBlock < block.number);
222 
223            // Do not allow transfer to 0x0 or the token contract itself
224            require((_to != 0) && (_to != address(this)));
225 
226            // If the amount being transfered is more than the balance of the
227            //  account the transfer throws
228            var previousBalanceFrom = balanceOfAt(_from, block.number);
229 
230            require(previousBalanceFrom >= _amount);
231 
232            // Alerts the token controller of the transfer
233            if (isContract(controller)) {
234                require(TokenController(controller).onTransfer(_from, _to, _amount));
235            }
236 
237            // First update the balance array with the new value for the address
238            //  sending the tokens
239            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
240 
241            // Then update the balance array with the new value for the address
242            //  receiving the tokens
243            var previousBalanceTo = balanceOfAt(_to, block.number);
244            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
245            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
246 
247            // An event to make the transfer easy to find on the blockchain
248            Transfer(_from, _to, _amount);
249 
250     }
251 
252     /// @param _owner The address that's balance is being requested
253     /// @return The balance of `_owner` at the current block
254     function balanceOf(address _owner) public constant returns (uint256 balance) {
255         return balanceOfAt(_owner, block.number);
256     }
257 
258     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
259     ///  its behalf. This is a modified version of the ERC20 approve function
260     ///  to be a little bit safer
261     /// @param _spender The address of the account able to transfer the tokens
262     /// @param _amount The amount of tokens to be approved for transfer
263     /// @return True if the approval was successful
264     function approve(address _spender, uint256 _amount) public returns (bool success) {
265         require(transfersEnabled);
266 
267         // To change the approve amount you first have to reduce the addresses`
268         //  allowance to zero by calling `approve(_spender,0)` if it is not
269         //  already 0 to mitigate the race condition described here:
270         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
271         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
272 
273         // Alerts the token controller of the approve function call
274         if (isContract(controller)) {
275             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
276         }
277 
278         allowed[msg.sender][_spender] = _amount;
279         Approval(msg.sender, _spender, _amount);
280         return true;
281     }
282 
283     /// @dev This function makes it easy to read the `allowed[]` map
284     /// @param _owner The address of the account that owns the token
285     /// @param _spender The address of the account able to transfer the tokens
286     /// @return Amount of remaining tokens of _owner that _spender is allowed
287     ///  to spend
288     function allowance(address _owner, address _spender
289     ) public constant returns (uint256 remaining) {
290         return allowed[_owner][_spender];
291     }
292 
293     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
294     ///  its behalf, and then a function is triggered in the contract that is
295     ///  being approved, `_spender`. This allows users to use their tokens to
296     ///  interact with contracts in one function call instead of two
297     /// @param _spender The address of the contract able to transfer the tokens
298     /// @param _amount The amount of tokens to be approved for transfer
299     /// @return True if the function call was successful
300     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
301     ) public returns (bool success) {
302         require(approve(_spender, _amount));
303 
304         ApproveAndCallFallBack(_spender).receiveApproval(
305             msg.sender,
306             _amount,
307             this,
308             _extraData
309         );
310 
311         return true;
312     }
313 
314     /// @dev This function makes it easy to get the total number of tokens
315     /// @return The total number of tokens
316     function totalSupply() public constant returns (uint) {
317         return totalSupplyAt(block.number);
318     }
319 
320 
321 ////////////////
322 // Query balance and totalSupply in History
323 ////////////////
324 
325     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
326     /// @param _owner The address from which the balance will be retrieved
327     /// @param _blockNumber The block number when the balance is queried
328     /// @return The balance at `_blockNumber`
329     function balanceOfAt(address _owner, uint _blockNumber) public constant
330         returns (uint) {
331 
332         // These next few lines are used when the balance of the token is
333         //  requested before a check point was ever created for this token, it
334         //  requires that the `parentToken.balanceOfAt` be queried at the
335         //  genesis block for that token as this contains initial balance of
336         //  this token
337         if ((balances[_owner].length == 0)
338             || (balances[_owner][0].fromBlock > _blockNumber)) {
339             if (address(parentToken) != 0) {
340                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
341             } else {
342                 // Has no parent
343                 return 0;
344             }
345 
346         // This will return the expected balance during normal situations
347         } else {
348             return getValueAt(balances[_owner], _blockNumber);
349         }
350     }
351 
352     /// @notice Total amount of tokens at a specific `_blockNumber`.
353     /// @param _blockNumber The block number when the totalSupply is queried
354     /// @return The total amount of tokens at `_blockNumber`
355     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
356 
357         // These next few lines are used when the totalSupply of the token is
358         //  requested before a check point was ever created for this token, it
359         //  requires that the `parentToken.totalSupplyAt` be queried at the
360         //  genesis block for this token as that contains totalSupply of this
361         //  token at this block number.
362         if ((totalSupplyHistory.length == 0)
363             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
364             if (address(parentToken) != 0) {
365                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
366             } else {
367                 return 0;
368             }
369 
370         // This will return the expected totalSupply during normal situations
371         } else {
372             return getValueAt(totalSupplyHistory, _blockNumber);
373         }
374     }
375 
376 ////////////////
377 // Clone Token Method
378 ////////////////
379 
380     /// @notice Creates a new clone token with the initial distribution being
381     ///  this token at `_snapshotBlock`
382     /// @param _cloneTokenName Name of the clone token
383     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
384     /// @param _cloneTokenSymbol Symbol of the clone token
385     /// @param _snapshotBlock Block when the distribution of the parent token is
386     ///  copied to set the initial distribution of the new clone token;
387     ///  if the block is zero than the actual block, the current block is used
388     /// @param _transfersEnabled True if transfers are allowed in the clone
389     /// @return The address of the new MiniMeToken Contract
390     function createCloneToken(
391         string _cloneTokenName,
392         uint8 _cloneDecimalUnits,
393         string _cloneTokenSymbol,
394         uint _snapshotBlock,
395         bool _transfersEnabled
396         ) public returns(address) {
397         if (_snapshotBlock == 0) _snapshotBlock = block.number;
398         MiniMeToken cloneToken = tokenFactory.createCloneToken(
399             this,
400             _snapshotBlock,
401             _cloneTokenName,
402             _cloneDecimalUnits,
403             _cloneTokenSymbol,
404             _transfersEnabled
405             );
406 
407         cloneToken.changeController(msg.sender);
408 
409         // An event to make the token easy to find on the blockchain
410         NewCloneToken(address(cloneToken), _snapshotBlock);
411         return address(cloneToken);
412     }
413 
414 ////////////////
415 // Generate and destroy tokens
416 ////////////////
417 
418     /// @notice Generates `_amount` tokens that are assigned to `_owner`
419     /// @param _owner The address that will be assigned the new tokens
420     /// @param _amount The quantity of tokens generated
421     /// @return True if the tokens are generated correctly
422     function generateTokens(address _owner, uint _amount
423     ) public onlyController returns (bool) {
424         uint curTotalSupply = totalSupply();
425         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
426         uint previousBalanceTo = balanceOf(_owner);
427         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
428         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
429         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
430         Transfer(0, _owner, _amount);
431         return true;
432     }
433 
434 
435     /// @notice Burns `_amount` tokens from `_owner`
436     /// @param _owner The address that will lose the tokens
437     /// @param _amount The quantity of tokens to burn
438     /// @return True if the tokens are burned correctly
439     function destroyTokens(address _owner, uint _amount
440     ) onlyController public returns (bool) {
441         uint curTotalSupply = totalSupply();
442         require(curTotalSupply >= _amount);
443         uint previousBalanceFrom = balanceOf(_owner);
444         require(previousBalanceFrom >= _amount);
445         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
446         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
447         Transfer(_owner, 0, _amount);
448         return true;
449     }
450 
451 ////////////////
452 // Enable tokens transfers
453 ////////////////
454 
455 
456     /// @notice Enables token holders to transfer their tokens freely if true
457     /// @param _transfersEnabled True if transfers are allowed in the clone
458     function enableTransfers(bool _transfersEnabled) public onlyController {
459         transfersEnabled = _transfersEnabled;
460     }
461 
462 ////////////////
463 // Internal helper functions to query and set a value in a snapshot array
464 ////////////////
465 
466     /// @dev `getValueAt` retrieves the number of tokens at a given block number
467     /// @param checkpoints The history of values being queried
468     /// @param _block The block number to retrieve the value at
469     /// @return The number of tokens being queried
470     function getValueAt(Checkpoint[] storage checkpoints, uint _block
471     ) constant internal returns (uint) {
472         if (checkpoints.length == 0) return 0;
473 
474         // Shortcut for the actual value
475         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
476             return checkpoints[checkpoints.length-1].value;
477         if (_block < checkpoints[0].fromBlock) return 0;
478 
479         // Binary search of the value in the array
480         uint min = 0;
481         uint max = checkpoints.length-1;
482         while (max > min) {
483             uint mid = (max + min + 1)/ 2;
484             if (checkpoints[mid].fromBlock<=_block) {
485                 min = mid;
486             } else {
487                 max = mid-1;
488             }
489         }
490         return checkpoints[min].value;
491     }
492 
493     /// @dev `updateValueAtNow` used to update the `balances` map and the
494     ///  `totalSupplyHistory`
495     /// @param checkpoints The history of data being updated
496     /// @param _value The new number of tokens
497     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
498     ) internal  {
499         if ((checkpoints.length == 0)
500         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
501                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
502                newCheckPoint.fromBlock =  uint128(block.number);
503                newCheckPoint.value = uint128(_value);
504            } else {
505                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
506                oldCheckPoint.value = uint128(_value);
507            }
508     }
509 
510     /// @dev Internal function to determine if an address is a contract
511     /// @param _addr The address being queried
512     /// @return True if `_addr` is a contract
513     function isContract(address _addr) constant internal returns(bool) {
514         uint size;
515         if (_addr == 0) return false;
516         assembly {
517             size := extcodesize(_addr)
518         }
519         return size>0;
520     }
521 
522     /// @dev Helper function to return a min betwen the two uints
523     function min(uint a, uint b) pure internal returns (uint) {
524         return a < b ? a : b;
525     }
526 
527     /// @notice The fallback function: If the contract's controller has not been
528     ///  set to 0, then the `proxyPayment` method is called which relays the
529     ///  ether and creates tokens as described in the token controller contract
530     function () public payable {
531         require(isContract(controller));
532         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
533     }
534 
535 //////////
536 // Safety Methods
537 //////////
538 
539     /// @notice This method can be used by the controller to extract mistakenly
540     ///  sent tokens to this contract.
541     /// @param _token The address of the token contract that you want to recover
542     ///  set to 0 in case you want to extract ether.
543     function claimTokens(address _token) public onlyController {
544         if (_token == 0x0) {
545             controller.transfer(this.balance);
546             return;
547         }
548 
549         MiniMeToken token = MiniMeToken(_token);
550         uint balance = token.balanceOf(this);
551         token.transfer(controller, balance);
552         ClaimedTokens(_token, controller, balance);
553     }
554 
555 ////////////////
556 // Events
557 ////////////////
558     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
559     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
560     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
561     event Approval(
562         address indexed _owner,
563         address indexed _spender,
564         uint256 _amount
565         );
566 
567 }
568 
569 
570 ////////////////
571 // MiniMeTokenFactory
572 ////////////////
573 
574 /// @dev This contract is used to generate clone contracts from a contract.
575 ///  In solidity this is the way to create a contract from a contract of the
576 ///  same class
577 contract MiniMeTokenFactory {
578 
579     /// @notice Update the DApp by creating a new token with new functionalities
580     ///  the msg.sender becomes the controller of this clone token
581     /// @param _parentToken Address of the token being cloned
582     /// @param _snapshotBlock Block of the parent token that will
583     ///  determine the initial distribution of the clone token
584     /// @param _tokenName Name of the new token
585     /// @param _decimalUnits Number of decimals of the new token
586     /// @param _tokenSymbol Token Symbol for the new token
587     /// @param _transfersEnabled If true, tokens will be able to be transferred
588     /// @return The address of the new token contract
589     function createCloneToken(
590         address _parentToken,
591         uint _snapshotBlock,
592         string _tokenName,
593         uint8 _decimalUnits,
594         string _tokenSymbol,
595         bool _transfersEnabled
596     ) public returns (MiniMeToken) {
597         MiniMeToken newToken = new MiniMeToken(
598             this,
599             _parentToken,
600             _snapshotBlock,
601             _tokenName,
602             _decimalUnits,
603             _tokenSymbol,
604             _transfersEnabled
605             );
606 
607         newToken.changeController(msg.sender);
608         return newToken;
609     }
610 }
611 
612 // File: contracts/SEED.sol
613 
614 contract SEED is MiniMeToken {
615   function SEED()
616     MiniMeToken(
617       0x00,          // _tokenFactory,
618       0x00,          // _parentToken,
619       0,             // _parentSnapShotBlock,
620       "SEED",        // _tokenName,
621       18,            // _decimalUnits,
622       "SEED",        // _tokenSymbol,
623       false          // _transfersEnabled
624     )
625     public
626   {}
627 }
628 
629 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
630 
631 /**
632  * @title Ownable
633  * @dev The Ownable contract has an owner address, and provides basic authorization control
634  * functions, this simplifies the implementation of "user permissions".
635  */
636 contract Ownable {
637   address public owner;
638 
639 
640   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
641 
642 
643   /**
644    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
645    * account.
646    */
647   function Ownable() public {
648     owner = msg.sender;
649   }
650 
651   /**
652    * @dev Throws if called by any account other than the owner.
653    */
654   modifier onlyOwner() {
655     require(msg.sender == owner);
656     _;
657   }
658 
659   /**
660    * @dev Allows the current owner to transfer control of the contract to a newOwner.
661    * @param newOwner The address to transfer ownership to.
662    */
663   function transferOwnership(address newOwner) public onlyOwner {
664     require(newOwner != address(0));
665     emit OwnershipTransferred(owner, newOwner);
666     owner = newOwner;
667   }
668 
669 }
670 
671 // File: openzeppelin-solidity/contracts/ownership/Whitelist.sol
672 
673 /**
674  * @title Whitelist
675  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
676  * @dev This simplifies the implementation of "user permissions".
677  */
678 contract Whitelist is Ownable {
679   mapping(address => bool) public whitelist;
680 
681   event WhitelistedAddressAdded(address addr);
682   event WhitelistedAddressRemoved(address addr);
683 
684   /**
685    * @dev Throws if called by any account that's not whitelisted.
686    */
687   modifier onlyWhitelisted() {
688     require(whitelist[msg.sender]);
689     _;
690   }
691 
692   /**
693    * @dev add an address to the whitelist
694    * @param addr address
695    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
696    */
697   function addAddressToWhitelist(address addr) onlyOwner public returns(bool success) {
698     if (!whitelist[addr]) {
699       whitelist[addr] = true;
700       emit WhitelistedAddressAdded(addr);
701       success = true;
702     }
703   }
704 
705   /**
706    * @dev add addresses to the whitelist
707    * @param addrs addresses
708    * @return true if at least one address was added to the whitelist,
709    * false if all addresses were already in the whitelist
710    */
711   function addAddressesToWhitelist(address[] addrs) onlyOwner public returns(bool success) {
712     for (uint256 i = 0; i < addrs.length; i++) {
713       if (addAddressToWhitelist(addrs[i])) {
714         success = true;
715       }
716     }
717   }
718 
719   /**
720    * @dev remove an address from the whitelist
721    * @param addr address
722    * @return true if the address was removed from the whitelist,
723    * false if the address wasn't in the whitelist in the first place
724    */
725   function removeAddressFromWhitelist(address addr) onlyOwner public returns(bool success) {
726     if (whitelist[addr]) {
727       whitelist[addr] = false;
728       emit WhitelistedAddressRemoved(addr);
729       success = true;
730     }
731   }
732 
733   /**
734    * @dev remove addresses from the whitelist
735    * @param addrs addresses
736    * @return true if at least one address was removed from the whitelist,
737    * false if all addresses weren't in the whitelist in the first place
738    */
739   function removeAddressesFromWhitelist(address[] addrs) onlyOwner public returns(bool success) {
740     for (uint256 i = 0; i < addrs.length; i++) {
741       if (removeAddressFromWhitelist(addrs[i])) {
742         success = true;
743       }
744     }
745   }
746 
747 }
748 
749 // File: contracts/SEEDWhitelist.sol
750 
751 contract SEEDWhitelist is Whitelist {
752 
753   // check the address is admin of kyc contract
754   mapping (address => bool) public admin;
755 
756   /**
757    * @dev check whether the msg.sender is admin or not
758    */
759   modifier onlyAdmin() {
760     require(admin[msg.sender]);
761     _;
762   }
763 
764   event SetAdmin(address indexed _addr, bool _value);
765 
766   function SEEDWhitelist() public {
767     admin[msg.sender] = true;
768   }
769 
770   /**
771    * @dev set new admin as admin of SEEDWhitelist contract
772    * @param _addr address The address to set as admin of SEEDWhitelist contract
773    */
774   function setAdmin(address _addr, bool _value)
775     public
776     onlyAdmin
777     returns (bool)
778   {
779     require(_addr != address(0));
780     require(admin[_addr] == !_value);
781 
782     admin[_addr] = _value;
783 
784     emit SetAdmin(_addr, _value);
785 
786     return true;
787   }
788 
789   /**
790    * @dev add an address to the whitelist
791    * @param addr address
792    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
793    */
794   function addAddressToWhitelist(address addr) onlyAdmin public returns(bool success) {
795     if (!whitelist[addr]) {
796       whitelist[addr] = true;
797       emit WhitelistedAddressAdded(addr);
798       success = true;
799     }
800   }
801 
802   /**
803    * @dev add addresses to the whitelist
804    * @param addrs addresses
805    * @return true if at least one address was added to the whitelist,
806    * false if all addresses were already in the whitelist
807    */
808   function addAddressesToWhitelist(address[] addrs) onlyAdmin public returns(bool success) {
809     for (uint256 i = 0; i < addrs.length; i++) {
810       if (addAddressToWhitelist(addrs[i])) {
811         success = true;
812       }
813     }
814   }
815 
816   /**
817    * @dev remove an address from the whitelist
818    * @param addr address
819    * @return true if the address was removed from the whitelist,
820    * false if the address wasn't in the whitelist in the first place
821    */
822   function removeAddressFromWhitelist(address addr) onlyAdmin public returns(bool success) {
823     if (whitelist[addr]) {
824       whitelist[addr] = false;
825       emit WhitelistedAddressRemoved(addr);
826       success = true;
827     }
828   }
829 
830   /**
831    * @dev remove addresses from the whitelist
832    * @param addrs addresses
833    * @return true if at least one address was removed from the whitelist,
834    * false if all addresses weren't in the whitelist in the first place
835    */
836   function removeAddressesFromWhitelist(address[] addrs) onlyAdmin public returns(bool success) {
837     for (uint256 i = 0; i < addrs.length; i++) {
838       if (removeAddressFromWhitelist(addrs[i])) {
839         success = true;
840       }
841     }
842   }
843 }
844 
845 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
846 
847 /**
848  * @title SafeMath
849  * @dev Math operations with safety checks that throw on error
850  */
851 library SafeMath {
852 
853   /**
854   * @dev Multiplies two numbers, throws on overflow.
855   */
856   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
857     if (a == 0) {
858       return 0;
859     }
860     c = a * b;
861     assert(c / a == b);
862     return c;
863   }
864 
865   /**
866   * @dev Integer division of two numbers, truncating the quotient.
867   */
868   function div(uint256 a, uint256 b) internal pure returns (uint256) {
869     // assert(b > 0); // Solidity automatically throws when dividing by 0
870     // uint256 c = a / b;
871     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
872     return a / b;
873   }
874 
875   /**
876   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
877   */
878   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
879     assert(b <= a);
880     return a - b;
881   }
882 
883   /**
884   * @dev Adds two numbers, throws on overflow.
885   */
886   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
887     c = a + b;
888     assert(c >= a);
889     return c;
890   }
891 }
892 
893 // File: openzeppelin-solidity/contracts/crowdsale/distribution/utils/RefundVault.sol
894 
895 /**
896  * @title RefundVault
897  * @dev This contract is used for storing funds while a crowdsale
898  * is in progress. Supports refunding the money if crowdsale fails,
899  * and forwarding it if crowdsale is successful.
900  */
901 contract RefundVault is Ownable {
902   using SafeMath for uint256;
903 
904   enum State { Active, Refunding, Closed }
905 
906   mapping (address => uint256) public deposited;
907   address public wallet;
908   State public state;
909 
910   event Closed();
911   event RefundsEnabled();
912   event Refunded(address indexed beneficiary, uint256 weiAmount);
913 
914   /**
915    * @param _wallet Vault address
916    */
917   function RefundVault(address _wallet) public {
918     require(_wallet != address(0));
919     wallet = _wallet;
920     state = State.Active;
921   }
922 
923   /**
924    * @param investor Investor address
925    */
926   function deposit(address investor) onlyOwner public payable {
927     require(state == State.Active);
928     deposited[investor] = deposited[investor].add(msg.value);
929   }
930 
931   function close() onlyOwner public {
932     require(state == State.Active);
933     state = State.Closed;
934     emit Closed();
935     wallet.transfer(address(this).balance);
936   }
937 
938   function enableRefunds() onlyOwner public {
939     require(state == State.Active);
940     state = State.Refunding;
941     emit RefundsEnabled();
942   }
943 
944   /**
945    * @param investor Investor address
946    */
947   function refund(address investor) public {
948     require(state == State.Refunding);
949     uint256 depositedValue = deposited[investor];
950     deposited[investor] = 0;
951     investor.transfer(depositedValue);
952     emit Refunded(investor, depositedValue);
953   }
954 }
955 
956 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
957 
958 /**
959  * @title Pausable
960  * @dev Base contract which allows children to implement an emergency stop mechanism.
961  */
962 contract Pausable is Ownable {
963   event Pause();
964   event Unpause();
965 
966   bool public paused = false;
967 
968 
969   /**
970    * @dev Modifier to make a function callable only when the contract is not paused.
971    */
972   modifier whenNotPaused() {
973     require(!paused);
974     _;
975   }
976 
977   /**
978    * @dev Modifier to make a function callable only when the contract is paused.
979    */
980   modifier whenPaused() {
981     require(paused);
982     _;
983   }
984 
985   /**
986    * @dev called by the owner to pause, triggers stopped state
987    */
988   function pause() onlyOwner whenNotPaused public {
989     paused = true;
990     emit Pause();
991   }
992 
993   /**
994    * @dev called by the owner to unpause, returns to normal state
995    */
996   function unpause() onlyOwner whenPaused public {
997     paused = false;
998     emit Unpause();
999   }
1000 }
1001 
1002 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
1003 
1004 /**
1005  * @title ERC20Basic
1006  * @dev Simpler version of ERC20 interface
1007  * @dev see https://github.com/ethereum/EIPs/issues/179
1008  */
1009 contract ERC20Basic {
1010   function totalSupply() public view returns (uint256);
1011   function balanceOf(address who) public view returns (uint256);
1012   function transfer(address to, uint256 value) public returns (bool);
1013   event Transfer(address indexed from, address indexed to, uint256 value);
1014 }
1015 
1016 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
1017 
1018 /**
1019  * @title ERC20 interface
1020  * @dev see https://github.com/ethereum/EIPs/issues/20
1021  */
1022 contract ERC20 is ERC20Basic {
1023   function allowance(address owner, address spender) public view returns (uint256);
1024   function transferFrom(address from, address to, uint256 value) public returns (bool);
1025   function approve(address spender, uint256 value) public returns (bool);
1026   event Approval(address indexed owner, address indexed spender, uint256 value);
1027 }
1028 
1029 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
1030 
1031 /**
1032  * @title SafeERC20
1033  * @dev Wrappers around ERC20 operations that throw on failure.
1034  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
1035  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1036  */
1037 library SafeERC20 {
1038   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
1039     assert(token.transfer(to, value));
1040   }
1041 
1042   function safeTransferFrom(
1043     ERC20 token,
1044     address from,
1045     address to,
1046     uint256 value
1047   )
1048     internal
1049   {
1050     assert(token.transferFrom(from, to, value));
1051   }
1052 
1053   function safeApprove(ERC20 token, address spender, uint256 value) internal {
1054     assert(token.approve(spender, value));
1055   }
1056 }
1057 
1058 // File: openzeppelin-solidity/contracts/ownership/CanReclaimToken.sol
1059 
1060 /**
1061  * @title Contracts that should be able to recover tokens
1062  * @author SylTi
1063  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
1064  * This will prevent any accidental loss of tokens.
1065  */
1066 contract CanReclaimToken is Ownable {
1067   using SafeERC20 for ERC20Basic;
1068 
1069   /**
1070    * @dev Reclaim all ERC20Basic compatible tokens
1071    * @param token ERC20Basic The address of the token contract
1072    */
1073   function reclaimToken(ERC20Basic token) external onlyOwner {
1074     uint256 balance = token.balanceOf(this);
1075     token.safeTransfer(owner, balance);
1076   }
1077 
1078 }
1079 
1080 // File: contracts/SEEDCrowdsale.sol
1081 
1082 /// @notice SEEDCrowdsale has 2 phases for crowdsale.
1083 ///  During sale phase 1, token rate is fixed at 30000.
1084 ///  After phase 2 starts, token rate is declined, starting with 25000.
1085 contract SEEDCrowdsale is Ownable, CanReclaimToken, Pausable {
1086   using SafeMath for uint256;
1087 
1088   // States
1089   SEED public token;
1090   RefundVault public vault;
1091   SEEDWhitelist public whitelist;
1092   address public newTokenOwner = 0xb34f87a1fda8ff1cf412acb8e8f40583968b7172;
1093 
1094   // 1 SEED = 1e18, 1M SEED = 1e24, 1B SEED = 1e27
1095   uint256 public constant OPERATION_AMOUNT = 1.2e27;              // 1.2B  SEED
1096   uint256 public constant BOUNTY_AMOUNT = 600e24;                 // 600M  SEED
1097   uint256 public constant COMMON_BUDGET_AMOUNT = 1.44e27;         // 1.44B SEED
1098   uint256 public constant INITIAL_SEED_FARMING_AMOUNT = 1.2e27;   // 1.2B  SEED
1099   uint256 public constant FOUNDER_AMOUNT = 960e24;                // 960M  SEED
1100   uint256 public constant RESERVE_AMOUNT = 4.8e27;                // 4.8B  SEED
1101 
1102   address public operationAdress;
1103   address public bountyAdress;
1104   address public commonBudgetAdress;
1105   address public initialSeedFarmingAdress;
1106   address public founderAdress;
1107   address public reserveAdress;
1108 
1109   // max ether cap for private-sale and crowdsale phase 1
1110   uint256 public constant phase1MaxEtherCap = 4800 ether; // solium-disable-line uppercase
1111 
1112   // max ether cap for crowdsale phase 2
1113   uint256 public constant phase2MaxEtherCap = 9600 ether; // solium-disable-line uppercase
1114 
1115   uint256 public startTime; // start time for crowdsale.
1116   uint256 public phase2StartTime; // when token rate phase2 starts.
1117   uint256 public endTime; // end time for crowdsale.
1118 
1119   // wei raised in private-sale
1120   uint256 public privateWeiRaised; // solium-disable-line uppercase
1121 
1122   uint256 public phase1WeiRaised; // wei raised in crowdsale phase 1
1123   uint256 public phase2WeiRaised; // wei raised in crowdsale phase 2
1124 
1125   bool public isFinalized;
1126 
1127   // sale phase 1 rate.
1128   uint256 public constant phase1Rate = 30000; // solium-disable-line uppercase
1129 
1130   // sale phase 2 rate.
1131   uint256[6] public phase2Rates; // solium-disable-line uppercase
1132   uint256[6] public phase2RateOffsets; // interval when next decline is going to be done.
1133 
1134   uint256 public minPurchase = 1 ether;
1135 
1136   mapping (address => uint256) public purchaserFunded;
1137   uint256 public numPurchasers;
1138 
1139   mapping (address => uint256) public privateHolderClaimed;
1140 
1141   // Events
1142   event TokenPurchase(address indexed _purchaser, address indexed _beneficiary, uint256 _value, uint256 _tokens);
1143   event TokenRateDecline(uint256 _pre, uint256 _post, uint256 _decrement);
1144 
1145   function SEEDCrowdsale(
1146     SEED _token,
1147     RefundVault _vault,
1148     SEEDWhitelist _whitelist,
1149     uint256 _startTime,
1150     uint256 _phase2StartTime,
1151     uint256 _endTime,
1152     uint256 _privateEtherFunded,
1153     address[6] _tokenHolders,
1154     uint256[6] _phase2RateOffsets)
1155     public
1156   {
1157     uint256 i;
1158     // constants
1159     phase2Rates = [
1160       25000,
1161       22000,
1162       19500,
1163       17000,
1164       14500,
1165       12000
1166     ];
1167 
1168     require(address(_token) != address(0));
1169     require(address(_vault) != address(0));
1170     require(address(_whitelist) != address(0));
1171 
1172     token = _token;
1173     vault = _vault;
1174     whitelist = _whitelist;
1175 
1176     require(_startTime != 0);
1177     require(_phase2StartTime != 0);
1178     require(_endTime != 0);
1179     require(_startTime < _phase2StartTime);
1180     require(_phase2StartTime < _endTime);
1181     require(_privateEtherFunded != 0);
1182 
1183     startTime = _startTime;
1184     phase2StartTime = _phase2StartTime;
1185     endTime = _endTime;
1186     privateWeiRaised = _privateEtherFunded;
1187 
1188     for (i = 0; i < _tokenHolders.length; i++) {
1189       require(_tokenHolders[i] != address(0));
1190     }
1191 
1192     operationAdress = _tokenHolders[0];
1193     bountyAdress = _tokenHolders[1];
1194     commonBudgetAdress = _tokenHolders[2];
1195     initialSeedFarmingAdress = _tokenHolders[3];
1196     founderAdress = _tokenHolders[4];
1197     reserveAdress = _tokenHolders[5];
1198 
1199     for (i = 0; i < _phase2RateOffsets.length - 1; i++) {
1200       require(_phase2RateOffsets[i] < _phase2RateOffsets[i + 1]);
1201     }
1202 
1203     phase2RateOffsets = _phase2RateOffsets;
1204   }
1205 
1206   function() public payable {
1207     buyTokens(msg.sender);
1208   }
1209 
1210   function claimPrivateTokens(address[] _addrs, uint[] _amounts) external onlyOwner {
1211     require(_addrs.length == _amounts.length);
1212 
1213     for (uint i = 0; i < _addrs.length; i++) {
1214       if (privateHolderClaimed[_addrs[i]] == 0) {
1215         privateHolderClaimed[_addrs[i]] = _amounts[i];
1216 
1217         token.generateTokens(_addrs[i], _amounts[i]);
1218       }
1219     }
1220   }
1221 
1222   function totalWeiRaised() external view returns (uint256) {
1223     return privateWeiRaised.add(phase1WeiRaised).add(phase2WeiRaised);
1224   }
1225 
1226   /// @notice getRate function expose token rate that decline is applied.
1227   function getRate() public view returns (uint256) {
1228     if (block.timestamp < phase2StartTime) { // solium-disable-line security/no-block-members
1229       return phase1Rate;
1230     }
1231 
1232     uint offset = block.timestamp.sub(phase2StartTime); // solium-disable-line security/no-block-members
1233 
1234     for (uint256 i = 0; i < phase2RateOffsets.length; i++) {
1235       if (offset < phase2RateOffsets[i]) {
1236         return phase2Rates[i];
1237       }
1238     }
1239 
1240     return 0;
1241   }
1242 
1243   /// @notice buyTokens process token purchase.
1244   ///  Owner can halt token purchasein an emergency.
1245   function buyTokens(address _beneficiary) public payable whenNotPaused {
1246     validatePurchase();
1247 
1248     uint256 toFund = calculateToFund();
1249     uint256 toReturn = msg.value.sub(toFund);
1250 
1251     require(toFund > 0);
1252 
1253     uint256 rate = getRate();
1254     uint256 tokens = rate.mul(toFund);
1255 
1256     require(tokens > 0);
1257 
1258     if (block.timestamp < phase2StartTime) { // solium-disable-line security/no-block-members
1259       phase1WeiRaised = phase1WeiRaised.add(toFund);
1260     } else {
1261       phase2WeiRaised = phase2WeiRaised.add(toFund);
1262     }
1263 
1264     if (purchaserFunded[msg.sender] == 0) {
1265       numPurchasers = numPurchasers.add(1);
1266     }
1267 
1268     purchaserFunded[msg.sender] = purchaserFunded[msg.sender].add(toFund);
1269     token.generateTokens(_beneficiary, tokens);
1270 
1271     emit TokenPurchase(msg.sender, _beneficiary, toFund, tokens); // solium-disable-line arg-overflow
1272 
1273     if (toReturn > 0) {
1274       msg.sender.transfer(toReturn);
1275     }
1276 
1277     vault.deposit.value(toFund)(msg.sender);
1278   }
1279 
1280   /// @notice finalize token sale. Tokens for specific holders are generated.
1281   function finalize() public onlyOwner {
1282     require(hasEnded()); // solium-disable-line security/no-block-members
1283     require(!isFinalized);
1284 
1285     isFinalized = true;
1286 
1287     token.generateTokens(operationAdress, OPERATION_AMOUNT);
1288     token.generateTokens(bountyAdress, BOUNTY_AMOUNT);
1289     token.generateTokens(commonBudgetAdress, COMMON_BUDGET_AMOUNT);
1290     token.generateTokens(initialSeedFarmingAdress, INITIAL_SEED_FARMING_AMOUNT);
1291     token.generateTokens(founderAdress, FOUNDER_AMOUNT);
1292     token.generateTokens(reserveAdress, RESERVE_AMOUNT);
1293 
1294     vault.close();
1295 
1296     token.enableTransfers(true);
1297     token.changeController(newTokenOwner);
1298     vault.transferOwnership(owner);
1299   }
1300 
1301   function hasEnded() public returns (bool) {
1302     bool afterEndTime = block.timestamp > endTime; // solium-disable-line security/no-block-members
1303     bool phase2CapReached = phase2WeiRaised == phase2MaxEtherCap;
1304 
1305     return afterEndTime || phase2CapReached;
1306   }
1307 
1308   /// @notice cap is checked in buyTokens function
1309   function validatePurchase() internal {
1310     require(msg.value >= minPurchase);
1311     require(block.timestamp >= startTime && block.timestamp <= endTime); // solium-disable-line security/no-block-members
1312     require(!isFinalized);
1313     require(whitelist.whitelist(msg.sender));
1314   }
1315 
1316   function calculateToFund() internal returns (uint256) {
1317     uint256 cap;
1318     uint256 weiRaised;
1319 
1320     if (block.timestamp < phase2StartTime) { // solium-disable-line security/no-block-members
1321       cap = phase1MaxEtherCap;
1322       weiRaised = privateWeiRaised.add(phase1WeiRaised);
1323     } else {
1324       cap = phase2MaxEtherCap;
1325       weiRaised = phase2WeiRaised;
1326     }
1327 
1328     uint256 postWeiRaised = weiRaised.add(msg.value);
1329 
1330     if (postWeiRaised > cap) {
1331       return cap.sub(weiRaised);
1332     } else {
1333       return msg.value;
1334     }
1335   }
1336 }