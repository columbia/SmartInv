1 pragma solidity 0.4.19;
2 
3 
4 
5 
6 
7 /// @dev `Owned` is a base level contract that assigns an `owner` that can be
8 ///  later changed
9 contract Owned {
10 
11     /// @dev `owner` is the only address that can call a function with this
12     /// modifier
13     modifier onlyOwner() {
14         require(msg.sender == owner);
15         _;
16     }
17 
18     address public owner;
19 
20     /// @notice The Constructor assigns the message sender to be `owner`
21     function Owned() public {
22         owner = msg.sender;
23     }
24 
25     address public newOwner;
26 
27     /// @notice `owner` can step down and assign some other address to this role
28     /// @param _newOwner The address of the new owner. 0x0 can be used to create
29     ///  an unowned neutral vault, however that cannot be undone
30     function changeOwner(address _newOwner) public onlyOwner {
31         newOwner = _newOwner;
32     }
33 
34 
35     function acceptOwnership() public {
36         if (msg.sender == newOwner) {
37             owner = newOwner;
38         }
39     }
40 }
41 
42 
43 
44 /*
45     Copyright 2016, Jordi Baylina
46 
47     This program is free software: you can redistribute it and/or modify
48     it under the terms of the GNU General Public License as published by
49     the Free Software Foundation, either version 3 of the License, or
50     (at your option) any later version.
51 
52     This program is distributed in the hope that it will be useful,
53     but WITHOUT ANY WARRANTY; without even the implied warranty of
54     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
55     GNU General Public License for more details.
56 
57     You should have received a copy of the GNU General Public License
58     along with this program.  If not, see <http://www.gnu.org/licenses/>.
59  */
60 
61 /// @title MiniMeToken Contract
62 /// @author Jordi Baylina
63 /// @dev This token contract's goal is to make it easy for anyone to clone this
64 ///  token using the token distribution at a given block, this will allow DAO's
65 ///  and DApps to upgrade their features in a decentralized manner without
66 ///  affecting the original token
67 /// @dev It is ERC20 compliant, but still needs to under go further testing.
68 
69 
70 
71 contract Controlled {
72     /// @notice The address of the controller is the only address that can call
73     ///  a function with this modifier
74     modifier onlyController { require(msg.sender == controller); _; }
75 
76     address public controller;
77 
78     function Controlled() public { controller = msg.sender;}
79 
80     /// @notice Changes the controller of the contract
81     /// @param _newController The new controller of the contract
82     function changeController(address _newController) public onlyController {
83         controller = _newController;
84     }
85 }
86 
87 
88 /// @dev The token controller contract must implement these functions
89 contract TokenController {
90     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
91     /// @param _owner The address that sent the ether to create tokens
92     /// @return True if the ether is accepted, false if it throws
93     function proxyPayment(address _owner) public payable returns(bool);
94 
95     /// @notice Notifies the controller about a token transfer allowing the
96     ///  controller to react if desired
97     /// @param _from The origin of the transfer
98     /// @param _to The destination of the transfer
99     /// @param _amount The amount of the transfer
100     /// @return False if the controller does not authorize the transfer
101     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
102 
103     /// @notice Notifies the controller about an approval allowing the
104     ///  controller to react if desired
105     /// @param _owner The address that calls `approve()`
106     /// @param _spender The spender in the `approve()` call
107     /// @param _amount The amount in the `approve()` call
108     /// @return False if the controller does not authorize the approval
109     function onApprove(address _owner, address _spender, uint _amount) public
110         returns(bool);
111 }
112 
113 contract ApproveAndCallFallBack {
114     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
115 }
116 
117 /// @dev The actual token contract, the default controller is the msg.sender
118 ///  that deploys the contract, so usually this token will be deployed by a
119 ///  token controller contract, which Giveth will call a "Campaign"
120 contract MiniMeToken is Controlled {
121 
122     string public name;                //The Token's name: e.g. DigixDAO Tokens
123     uint8 public decimals;             //Number of decimals of the smallest unit
124     string public symbol;              //An identifier: e.g. REP
125     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
126 
127 
128     /// @dev `Checkpoint` is the structure that attaches a block number to a
129     ///  given value, the block number attached is the one that last changed the
130     ///  value
131     struct  Checkpoint {
132 
133         // `fromBlock` is the block number that the value was generated from
134         uint128 fromBlock;
135 
136         // `value` is the amount of tokens at a specific block number
137         uint128 value;
138     }
139 
140     // `parentToken` is the Token address that was cloned to produce this token;
141     //  it will be 0x0 for a token that was not cloned
142     MiniMeToken public parentToken;
143 
144     // `parentSnapShotBlock` is the block number from the Parent Token that was
145     //  used to determine the initial distribution of the Clone Token
146     uint public parentSnapShotBlock;
147 
148     // `creationBlock` is the block number that the Clone Token was created
149     uint public creationBlock;
150 
151     // `balances` is the map that tracks the balance of each address, in this
152     //  contract when the balance changes the block number that the change
153     //  occurred is also included in the map
154     mapping (address => Checkpoint[]) balances;
155 
156     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
157     mapping (address => mapping (address => uint256)) allowed;
158 
159     // Tracks the history of the `totalSupply` of the token
160     Checkpoint[] totalSupplyHistory;
161 
162     // Flag that determines if the token is transferable or not.
163     bool public transfersEnabled;
164 
165     // The factory used to create new clone tokens
166     MiniMeTokenFactory public tokenFactory;
167 
168 ////////////////
169 // Constructor
170 ////////////////
171 
172     /// @notice Constructor to create a MiniMeToken
173     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
174     ///  will create the Clone token contracts, the token factory needs to be
175     ///  deployed first
176     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
177     ///  new token
178     /// @param _parentSnapShotBlock Block of the parent token that will
179     ///  determine the initial distribution of the clone token, set to 0 if it
180     ///  is a new token
181     /// @param _tokenName Name of the new token
182     /// @param _decimalUnits Number of decimals of the new token
183     /// @param _tokenSymbol Token Symbol for the new token
184     /// @param _transfersEnabled If true, tokens will be able to be transferred
185     function MiniMeToken(
186         address _tokenFactory,
187         address _parentToken,
188         uint _parentSnapShotBlock,
189         string _tokenName,
190         uint8 _decimalUnits,
191         string _tokenSymbol,
192         bool _transfersEnabled
193     ) public {
194         tokenFactory = MiniMeTokenFactory(_tokenFactory);
195         name = _tokenName;                                 // Set the name
196         decimals = _decimalUnits;                          // Set the decimals
197         symbol = _tokenSymbol;                             // Set the symbol
198         parentToken = MiniMeToken(_parentToken);
199         parentSnapShotBlock = _parentSnapShotBlock;
200         transfersEnabled = _transfersEnabled;
201         creationBlock = block.number;
202     }
203 
204 
205 ///////////////////
206 // ERC20 Methods
207 ///////////////////
208 
209     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
210     /// @param _to The address of the recipient
211     /// @param _amount The amount of tokens to be transferred
212     /// @return Whether the transfer was successful or not
213     function transfer(address _to, uint256 _amount) public returns (bool success) {
214         require(transfersEnabled);
215         doTransfer(msg.sender, _to, _amount);
216         return true;
217     }
218 
219     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
220     ///  is approved by `_from`
221     /// @param _from The address holding the tokens being transferred
222     /// @param _to The address of the recipient
223     /// @param _amount The amount of tokens to be transferred
224     /// @return True if the transfer was successful
225     function transferFrom(address _from, address _to, uint256 _amount
226     ) public returns (bool success) {
227 
228         // The controller of this contract can move tokens around at will,
229         //  this is important to recognize! Confirm that you trust the
230         //  controller of this contract, which in most situations should be
231         //  another open source smart contract or 0x0
232         if (msg.sender != controller) {
233             require(transfersEnabled);
234 
235             // The standard ERC 20 transferFrom functionality
236             require(allowed[_from][msg.sender] >= _amount);
237             allowed[_from][msg.sender] -= _amount;
238         }
239         doTransfer(_from, _to, _amount);
240         return true;
241     }
242 
243     /// @dev This is the actual transfer function in the token contract, it can
244     ///  only be called by other functions in this contract.
245     /// @param _from The address holding the tokens being transferred
246     /// @param _to The address of the recipient
247     /// @param _amount The amount of tokens to be transferred
248     /// @return True if the transfer was successful
249     function doTransfer(address _from, address _to, uint _amount
250     ) internal {
251 
252            if (_amount == 0) {
253                Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
254                return;
255            }
256 
257            require(parentSnapShotBlock < block.number);
258 
259            // Do not allow transfer to 0x0 or the token contract itself
260            require((_to != 0) && (_to != address(this)));
261 
262            // If the amount being transfered is more than the balance of the
263            //  account the transfer throws
264            var previousBalanceFrom = balanceOfAt(_from, block.number);
265 
266            require(previousBalanceFrom >= _amount);
267 
268            // Alerts the token controller of the transfer
269            if (isContract(controller)) {
270                require(TokenController(controller).onTransfer(_from, _to, _amount));
271            }
272 
273            // First update the balance array with the new value for the address
274            //  sending the tokens
275            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
276 
277            // Then update the balance array with the new value for the address
278            //  receiving the tokens
279            var previousBalanceTo = balanceOfAt(_to, block.number);
280            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
281            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
282 
283            // An event to make the transfer easy to find on the blockchain
284            Transfer(_from, _to, _amount);
285 
286     }
287 
288     /// @param _owner The address that's balance is being requested
289     /// @return The balance of `_owner` at the current block
290     function balanceOf(address _owner) public constant returns (uint256 balance) {
291         return balanceOfAt(_owner, block.number);
292     }
293 
294     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
295     ///  its behalf. This is a modified version of the ERC20 approve function
296     ///  to be a little bit safer
297     /// @param _spender The address of the account able to transfer the tokens
298     /// @param _amount The amount of tokens to be approved for transfer
299     /// @return True if the approval was successful
300     function approve(address _spender, uint256 _amount) public returns (bool success) {
301         require(transfersEnabled);
302 
303         // To change the approve amount you first have to reduce the addresses`
304         //  allowance to zero by calling `approve(_spender,0)` if it is not
305         //  already 0 to mitigate the race condition described here:
306         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
307         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
308 
309         // Alerts the token controller of the approve function call
310         if (isContract(controller)) {
311             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
312         }
313 
314         allowed[msg.sender][_spender] = _amount;
315         Approval(msg.sender, _spender, _amount);
316         return true;
317     }
318 
319     /// @dev This function makes it easy to read the `allowed[]` map
320     /// @param _owner The address of the account that owns the token
321     /// @param _spender The address of the account able to transfer the tokens
322     /// @return Amount of remaining tokens of _owner that _spender is allowed
323     ///  to spend
324     function allowance(address _owner, address _spender
325     ) public constant returns (uint256 remaining) {
326         return allowed[_owner][_spender];
327     }
328 
329     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
330     ///  its behalf, and then a function is triggered in the contract that is
331     ///  being approved, `_spender`. This allows users to use their tokens to
332     ///  interact with contracts in one function call instead of two
333     /// @param _spender The address of the contract able to transfer the tokens
334     /// @param _amount The amount of tokens to be approved for transfer
335     /// @return True if the function call was successful
336     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
337     ) public returns (bool success) {
338         require(approve(_spender, _amount));
339 
340         ApproveAndCallFallBack(_spender).receiveApproval(
341             msg.sender,
342             _amount,
343             this,
344             _extraData
345         );
346 
347         return true;
348     }
349 
350     /// @dev This function makes it easy to get the total number of tokens
351     /// @return The total number of tokens
352     function totalSupply() public constant returns (uint) {
353         return totalSupplyAt(block.number);
354     }
355 
356 
357 ////////////////
358 // Query balance and totalSupply in History
359 ////////////////
360 
361     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
362     /// @param _owner The address from which the balance will be retrieved
363     /// @param _blockNumber The block number when the balance is queried
364     /// @return The balance at `_blockNumber`
365     function balanceOfAt(address _owner, uint _blockNumber) public constant
366         returns (uint) {
367 
368         // These next few lines are used when the balance of the token is
369         //  requested before a check point was ever created for this token, it
370         //  requires that the `parentToken.balanceOfAt` be queried at the
371         //  genesis block for that token as this contains initial balance of
372         //  this token
373         if ((balances[_owner].length == 0)
374             || (balances[_owner][0].fromBlock > _blockNumber)) {
375             if (address(parentToken) != 0) {
376                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
377             } else {
378                 // Has no parent
379                 return 0;
380             }
381 
382         // This will return the expected balance during normal situations
383         } else {
384             return getValueAt(balances[_owner], _blockNumber);
385         }
386     }
387 
388     /// @notice Total amount of tokens at a specific `_blockNumber`.
389     /// @param _blockNumber The block number when the totalSupply is queried
390     /// @return The total amount of tokens at `_blockNumber`
391     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
392 
393         // These next few lines are used when the totalSupply of the token is
394         //  requested before a check point was ever created for this token, it
395         //  requires that the `parentToken.totalSupplyAt` be queried at the
396         //  genesis block for this token as that contains totalSupply of this
397         //  token at this block number.
398         if ((totalSupplyHistory.length == 0)
399             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
400             if (address(parentToken) != 0) {
401                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
402             } else {
403                 return 0;
404             }
405 
406         // This will return the expected totalSupply during normal situations
407         } else {
408             return getValueAt(totalSupplyHistory, _blockNumber);
409         }
410     }
411 
412 ////////////////
413 // Clone Token Method
414 ////////////////
415 
416     /// @notice Creates a new clone token with the initial distribution being
417     ///  this token at `_snapshotBlock`
418     /// @param _cloneTokenName Name of the clone token
419     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
420     /// @param _cloneTokenSymbol Symbol of the clone token
421     /// @param _snapshotBlock Block when the distribution of the parent token is
422     ///  copied to set the initial distribution of the new clone token;
423     ///  if the block is zero than the actual block, the current block is used
424     /// @param _transfersEnabled True if transfers are allowed in the clone
425     /// @return The address of the new MiniMeToken Contract
426     function createCloneToken(
427         string _cloneTokenName,
428         uint8 _cloneDecimalUnits,
429         string _cloneTokenSymbol,
430         uint _snapshotBlock,
431         bool _transfersEnabled
432         ) public returns(address) {
433         if (_snapshotBlock == 0) _snapshotBlock = block.number;
434         MiniMeToken cloneToken = tokenFactory.createCloneToken(
435             this,
436             _snapshotBlock,
437             _cloneTokenName,
438             _cloneDecimalUnits,
439             _cloneTokenSymbol,
440             _transfersEnabled
441             );
442 
443         cloneToken.changeController(msg.sender);
444 
445         // An event to make the token easy to find on the blockchain
446         NewCloneToken(address(cloneToken), _snapshotBlock);
447         return address(cloneToken);
448     }
449 
450 ////////////////
451 // Generate and destroy tokens
452 ////////////////
453 
454     /// @notice Generates `_amount` tokens that are assigned to `_owner`
455     /// @param _owner The address that will be assigned the new tokens
456     /// @param _amount The quantity of tokens generated
457     /// @return True if the tokens are generated correctly
458     function generateTokens(address _owner, uint _amount
459     ) public onlyController returns (bool) {
460         uint curTotalSupply = totalSupply();
461         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
462         uint previousBalanceTo = balanceOf(_owner);
463         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
464         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
465         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
466         Transfer(0, _owner, _amount);
467         return true;
468     }
469 
470 
471     /// @notice Burns `_amount` tokens from `_owner`
472     /// @param _owner The address that will lose the tokens
473     /// @param _amount The quantity of tokens to burn
474     /// @return True if the tokens are burned correctly
475     function destroyTokens(address _owner, uint _amount
476     ) onlyController public returns (bool) {
477         uint curTotalSupply = totalSupply();
478         require(curTotalSupply >= _amount);
479         uint previousBalanceFrom = balanceOf(_owner);
480         require(previousBalanceFrom >= _amount);
481         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
482         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
483         Transfer(_owner, 0, _amount);
484         return true;
485     }
486 
487 ////////////////
488 // Enable tokens transfers
489 ////////////////
490 
491 
492     /// @notice Enables token holders to transfer their tokens freely if true
493     /// @param _transfersEnabled True if transfers are allowed in the clone
494     function enableTransfers(bool _transfersEnabled) public onlyController {
495         transfersEnabled = _transfersEnabled;
496     }
497 
498 ////////////////
499 // Internal helper functions to query and set a value in a snapshot array
500 ////////////////
501 
502     /// @dev `getValueAt` retrieves the number of tokens at a given block number
503     /// @param checkpoints The history of values being queried
504     /// @param _block The block number to retrieve the value at
505     /// @return The number of tokens being queried
506     function getValueAt(Checkpoint[] storage checkpoints, uint _block
507     ) constant internal returns (uint) {
508         if (checkpoints.length == 0) return 0;
509 
510         // Shortcut for the actual value
511         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
512             return checkpoints[checkpoints.length-1].value;
513         if (_block < checkpoints[0].fromBlock) return 0;
514 
515         // Binary search of the value in the array
516         uint min = 0;
517         uint max = checkpoints.length-1;
518         while (max > min) {
519             uint mid = (max + min + 1)/ 2;
520             if (checkpoints[mid].fromBlock<=_block) {
521                 min = mid;
522             } else {
523                 max = mid-1;
524             }
525         }
526         return checkpoints[min].value;
527     }
528 
529     /// @dev `updateValueAtNow` used to update the `balances` map and the
530     ///  `totalSupplyHistory`
531     /// @param checkpoints The history of data being updated
532     /// @param _value The new number of tokens
533     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
534     ) internal  {
535         if ((checkpoints.length == 0)
536         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
537                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
538                newCheckPoint.fromBlock =  uint128(block.number);
539                newCheckPoint.value = uint128(_value);
540            } else {
541                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
542                oldCheckPoint.value = uint128(_value);
543            }
544     }
545 
546     /// @dev Internal function to determine if an address is a contract
547     /// @param _addr The address being queried
548     /// @return True if `_addr` is a contract
549     function isContract(address _addr) constant internal returns(bool) {
550         uint size;
551         if (_addr == 0) return false;
552         assembly {
553             size := extcodesize(_addr)
554         }
555         return size>0;
556     }
557 
558     /// @dev Helper function to return a min betwen the two uints
559     function min(uint a, uint b) pure internal returns (uint) {
560         return a < b ? a : b;
561     }
562 
563     /// @notice The fallback function: If the contract's controller has not been
564     ///  set to 0, then the `proxyPayment` method is called which relays the
565     ///  ether and creates tokens as described in the token controller contract
566     function () public payable {
567         require(isContract(controller));
568         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
569     }
570 
571 //////////
572 // Safety Methods
573 //////////
574 
575     /// @notice This method can be used by the controller to extract mistakenly
576     ///  sent tokens to this contract.
577     /// @param _token The address of the token contract that you want to recover
578     ///  set to 0 in case you want to extract ether.
579     function claimTokens(address _token) public onlyController {
580         if (_token == 0x0) {
581             controller.transfer(address(this).balance);
582             return;
583         }
584 
585         MiniMeToken token = MiniMeToken(_token);
586         uint balance = token.balanceOf(this);
587         token.transfer(controller, balance);
588         ClaimedTokens(_token, controller, balance);
589     }
590 
591 ////////////////
592 // Events
593 ////////////////
594     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
595     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
596     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
597     event Approval(
598         address indexed _owner,
599         address indexed _spender,
600         uint256 _amount
601         );
602 
603 }
604 
605 
606 ////////////////
607 // MiniMeTokenFactory
608 ////////////////
609 
610 /// @dev This contract is used to generate clone contracts from a contract.
611 ///  In solidity this is the way to create a contract from a contract of the
612 ///  same class
613 contract MiniMeTokenFactory {
614 
615     /// @notice Update the DApp by creating a new token with new functionalities
616     ///  the msg.sender becomes the controller of this clone token
617     /// @param _parentToken Address of the token being cloned
618     /// @param _snapshotBlock Block of the parent token that will
619     ///  determine the initial distribution of the clone token
620     /// @param _tokenName Name of the new token
621     /// @param _decimalUnits Number of decimals of the new token
622     /// @param _tokenSymbol Token Symbol for the new token
623     /// @param _transfersEnabled If true, tokens will be able to be transferred
624     /// @return The address of the new token contract
625     function createCloneToken(
626         address _parentToken,
627         uint _snapshotBlock,
628         string _tokenName,
629         uint8 _decimalUnits,
630         string _tokenSymbol,
631         bool _transfersEnabled
632     ) public returns (MiniMeToken) {
633         MiniMeToken newToken = new MiniMeToken(
634             this,
635             _parentToken,
636             _snapshotBlock,
637             _tokenName,
638             _decimalUnits,
639             _tokenSymbol,
640             _transfersEnabled
641             );
642 
643         newToken.changeController(msg.sender);
644         return newToken;
645     }
646 }
647 
648 
649 
650 /**
651  * Math operations with safety checks
652  */
653 library SafeMath {
654   function mul(uint a, uint b) internal pure returns (uint) {
655     uint c = a * b;
656     assert(a == 0 || c / a == b);
657     return c;
658   }
659 
660   function div(uint a, uint b) internal pure returns (uint) {
661     // assert(b > 0); // Solidity automatically throws when dividing by 0
662     uint c = a / b;
663     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
664     return c;
665   }
666 
667   function sub(uint a, uint b) internal pure returns (uint) {
668     assert(b <= a);
669     return a - b;
670   }
671 
672   function add(uint a, uint b) internal pure returns (uint) {
673     uint c = a + b;
674     assert(c >= a);
675     return c;
676   }
677 
678   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
679     return a >= b ? a : b;
680   }
681 
682   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
683     return a < b ? a : b;
684   }
685 
686   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
687     return a >= b ? a : b;
688   }
689 
690   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
691     return a < b ? a : b;
692   }
693 
694   function percent(uint a, uint b) internal pure returns (uint) {
695     return b * a / 100;
696   }
697 }
698 
699 // Abstract contract for the full ERC 20 Token standard
700 // https://github.com/ethereum/EIPs/issues/20
701 
702 
703 contract ERC20Token {
704     /* This is a slight change to the ERC20 base standard.
705     function totalSupply() constant returns (uint256 supply);
706     is replaced with:
707     uint256 public totalSupply;
708     This automatically creates a getter function for the totalSupply.
709     This is moved to the base contract since public getter functions are not
710     currently recognised as an implementation of the matching abstract
711     function by the compiler.
712     */
713     /// total amount of tokens
714     uint256 public totalSupply;
715 
716     /// @param _owner The address from which the balance will be retrieved
717     /// @return The balance
718     function balanceOf(address _owner) public constant returns (uint256 balance);
719 
720     /// @notice send `_value` token to `_to` from `msg.sender`
721     /// @param _to The address of the recipient
722     /// @param _value The amount of token to be transferred
723     /// @return Whether the transfer was successful or not
724     function transfer(address _to, uint256 _value) public returns (bool success);
725 
726     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
727     /// @param _from The address of the sender
728     /// @param _to The address of the recipient
729     /// @param _value The amount of token to be transferred
730     /// @return Whether the transfer was successful or not
731     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
732 
733     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
734     /// @param _spender The address of the account able to transfer the tokens
735     /// @param _value The amount of tokens to be approved for transfer
736     /// @return Whether the approval was successful or not
737     function approve(address _spender, uint256 _value) public returns (bool success);
738 
739     /// @param _owner The address of the account owning tokens
740     /// @param _spender The address of the account able to transfer the tokens
741     /// @return Amount of remaining tokens allowed to spent
742     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
743 
744     event Transfer(address indexed _from, address indexed _to, uint256 _value);
745     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
746 }
747 
748 
749 
750 contract TokenContribution is Owned, TokenController {
751     using SafeMath for uint256;
752 
753     uint256 constant public maxSupply = 1000000000 * 10**8;
754 
755     // Half of the max supply. 50% for ico
756     uint256 constant public saleLimit = 500000000 * 10**8;
757 
758     uint256 constant public maxGasPrice = 50000000000;
759 
760     uint256 constant public maxCallFrequency = 100;
761 
762     MiniMeToken public token;
763 
764     address public destTokensTeam;
765     address public destTokensReserve;
766     address public destTokensBounties;
767     address public destTokensAirdrop;
768     address public destTokensAdvisors;
769     address public destTokensEarlyInvestors;
770 
771     uint256 public totalTokensGenerated;
772 
773     uint256 public finalizedBlock;
774     uint256 public finalizedTime;
775 
776     uint256 public generatedTokensSale;
777 
778     mapping(address => uint256) public lastCallBlock;
779 
780     modifier initialized() {
781         require(address(token) != 0x0);
782         _;
783     }
784 
785     function TokenContribution() public {
786     }
787 
788     /// @notice The owner of this contract can change the controller of the token
789     ///  Please, be sure that the owner is a trusted agent or 0x0 address.
790     /// @param _newController The address of the new controller
791     function changeController(address _newController) public onlyOwner {
792         token.changeController(_newController);
793         ControllerChanged(_newController);
794     }
795 
796 
797     /// @notice This method should be called by the owner before the contribution
798     ///  period starts This initializes most of the parameters
799     function initialize(
800         address _token,
801         address _destTokensReserve,
802         address _destTokensTeam,
803         address _destTokensBounties,
804         address _destTokensAirdrop,
805         address _destTokensAdvisors,
806         address _destTokensEarlyInvestors
807     ) public onlyOwner {
808         // Initialize only once
809         require(address(token) == 0x0);
810 
811         token = MiniMeToken(_token);
812         require(token.totalSupply() == 0);
813         require(token.controller() == address(this));
814         require(token.decimals() == 8);
815 
816         require(_destTokensReserve != 0x0);
817         destTokensReserve = _destTokensReserve;
818 
819         require(_destTokensTeam != 0x0);
820         destTokensTeam = _destTokensTeam;
821 
822         require(_destTokensBounties != 0x0);
823         destTokensBounties = _destTokensBounties;
824 
825         require(_destTokensAirdrop != 0x0);
826         destTokensAirdrop = _destTokensAirdrop;
827 
828         require(_destTokensAdvisors != 0x0);
829         destTokensAdvisors = _destTokensAdvisors;
830 
831         require(_destTokensEarlyInvestors != 0x0);
832         destTokensEarlyInvestors= _destTokensEarlyInvestors;
833     }
834 
835     //////////
836     // MiniMe Controller functions
837     //////////
838 
839     function proxyPayment(address) public payable returns (bool) {
840         return false;
841     }
842 
843     function onTransfer(address _from, address, uint256) public returns (bool) {
844         return transferable(_from);
845     }
846     
847     function onApprove(address _from, address, uint256) public returns (bool) {
848         return transferable(_from);
849     }
850 
851     function transferable(address _from) internal view returns (bool) {
852         // Allow the exchanger to work from the beginning
853         if (finalizedTime == 0) return false;
854 
855         return (getTime() > finalizedTime) || (_from == owner);
856     }
857 
858     function generate(address _th, uint256 _amount) public onlyOwner {
859         require(generatedTokensSale.add(_amount) <= saleLimit);
860         require(_amount > 0);
861 
862         generatedTokensSale = generatedTokensSale.add(_amount);
863         token.generateTokens(_th, _amount);
864 
865         NewSale(_th, _amount);
866     }
867 
868     // NOTE on Percentage format
869     // Right now, Solidity does not support decimal numbers. (This will change very soon)
870     //  So in this contract we use a representation of a percentage that consist in
871     //  expressing the percentage in "x per 10**18"
872     // This format has a precision of 16 digits for a percent.
873     // Examples:
874     //  3%   =   3*(10**16)
875     //  100% = 100*(10**16) = 10**18
876     //
877     // To get a percentage of a value we do it by first multiplying it by the percentage in  (x per 10^18)
878     //  and then divide it by 10**18
879     //
880     //              Y * X(in x per 10**18)
881     //  X% of Y = -------------------------
882     //               100(in x per 10**18)
883     //
884 
885 
886     /// @notice This method will can be called by the owner before the contribution period
887     ///  end or by anybody after the `endBlock`. This method finalizes the contribution period
888     ///  by creating the remaining tokens and transferring the controller to the configured
889     ///  controller.
890     function finalize() public initialized onlyOwner {
891         require(finalizedBlock == 0);
892 
893         finalizedBlock = getBlockNumber();
894         finalizedTime = now;
895 
896         // Percentage to sale
897         // uint256 percentageToCommunity = percent(50);
898 
899         uint256 percentageToTeam = percent(18);
900 
901         uint256 percentageToReserve = percent(8);
902 
903         uint256 percentageToBounties = percent(13);
904 
905         uint256 percentageToAirdrop = percent(2);
906 
907         uint256 percentageToAdvisors = percent(7);
908 
909         uint256 percentageToEarlyInvestors = percent(2);
910 
911         //
912         //                    percentageToBounties
913         //  bountiesTokens = ----------------------- * maxSupply
914         //                      percentage(100)
915         //
916         assert(token.generateTokens(
917                 destTokensBounties,
918                 maxSupply.mul(percentageToBounties).div(percent(100))));
919 
920         //
921         //                    percentageToReserve
922         //  reserveTokens = ----------------------- * maxSupply
923         //                      percentage(100)
924         //
925         assert(token.generateTokens(
926                 destTokensReserve,
927                 maxSupply.mul(percentageToReserve).div(percent(100))));
928 
929         //
930         //                   percentageToTeam
931         //  teamTokens = ----------------------- * maxSupply
932         //                   percentage(100)
933         //
934         assert(token.generateTokens(
935                 destTokensTeam,
936                 maxSupply.mul(percentageToTeam).div(percent(100))));
937 
938         //
939         //                   percentageToAirdrop
940         //  airdropTokens = ----------------------- * maxSupply
941         //                   percentage(100)
942         //
943         assert(token.generateTokens(
944                 destTokensAirdrop,
945                 maxSupply.mul(percentageToAirdrop).div(percent(100))));
946 
947         //
948         //                      percentageToAdvisors
949         //  advisorsTokens = ----------------------- * maxSupply
950         //                      percentage(100)
951         //
952         assert(token.generateTokens(
953                 destTokensAdvisors,
954                 maxSupply.mul(percentageToAdvisors).div(percent(100))));
955 
956         //
957         //                      percentageToEarlyInvestors
958         //  advisorsTokens = ------------------------------ * maxSupply
959         //                          percentage(100)
960         //
961         assert(token.generateTokens(
962                 destTokensEarlyInvestors,
963                 maxSupply.mul(percentageToEarlyInvestors).div(percent(100))));
964 
965         Finalized();
966     }
967 
968     function percent(uint256 p) internal pure returns (uint256) {
969         return p.mul(10 ** 16);
970     }
971 
972     /// @dev Internal function to determine if an address is a contract
973     /// @param _addr The address being queried
974     /// @return True if `_addr` is a contract
975     function isContract(address _addr) internal view returns (bool) {
976         if (_addr == 0) return false;
977         uint256 size;
978         assembly {
979             size := extcodesize(_addr)
980         }
981         return (size > 0);
982     }
983 
984 
985     //////////
986     // Constant functions
987     //////////
988 
989     /// @return Total tokens issued in weis.
990     function tokensIssued() public view returns (uint256) {
991         return token.totalSupply();
992     }
993 
994 
995     //////////
996     // Testing specific methods
997     //////////
998 
999     /// @notice This function is overridden by the test Mocks.
1000     function getBlockNumber() internal view returns (uint256) {
1001         return block.number;
1002     }
1003 
1004     /// @notice This function is overrided by the test Mocks.
1005     function getTime() internal view returns (uint256) {
1006         return now;
1007     }
1008 
1009 
1010     //////////
1011     // Safety Methods
1012     //////////
1013 
1014     /// @notice This method can be used by the controller to extract mistakenly
1015     ///  sent tokens to this contract.
1016     /// @param _token The address of the token contract that you want to recover
1017     ///  set to 0 in case you want to extract ether.
1018     function claimTokens(address _token) public onlyOwner {
1019         if (token.controller() == address(this)) {
1020             token.claimTokens(_token);
1021         }
1022         if (_token == 0x0) {
1023             owner.transfer(address(this).balance);
1024             return;
1025         }
1026 
1027         ERC20Token erc20token = ERC20Token(_token);
1028         uint256 balance = erc20token.balanceOf(this);
1029         erc20token.transfer(owner, balance);
1030         ClaimedTokens(_token, owner, balance);
1031     }
1032 
1033     event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
1034 
1035     event ControllerChanged(address indexed _newController);
1036 
1037     event NewSale(address indexed _th, uint256 _amount);
1038 
1039     event Finalized();
1040 }