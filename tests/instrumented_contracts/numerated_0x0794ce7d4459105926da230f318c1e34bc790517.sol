1 pragma solidity ^0.4.24;
2 
3 
4 contract Controlled {
5     /// @notice The address of the controller is the only address that can call
6     ///  a function with this modifier
7     modifier onlyController { require(msg.sender == controller); _; }
8 
9     address public controller;
10 
11     function Controlled() public { controller = msg.sender;}
12 
13     /// @notice Changes the controller of the contract
14     /// @param _newController The new controller of the contract
15     function changeController(address _newController) public onlyController {
16         controller = _newController;
17     }
18 }
19 
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
46 
47 /*
48     Copyright 2016, Jordi Baylina
49 
50     This program is free software: you can redistribute it and/or modify
51     it under the terms of the GNU General Public License as published by
52     the Free Software Foundation, either version 3 of the License, or
53     (at your option) any later version.
54 
55     This program is distributed in the hope that it will be useful,
56     but WITHOUT ANY WARRANTY; without even the implied warranty of
57     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
58     GNU General Public License for more details.
59 
60     You should have received a copy of the GNU General Public License
61     along with this program.  If not, see <http://www.gnu.org/licenses/>.
62  */
63 
64 /// @title MiniMeToken Contract
65 /// @author Jordi Baylina
66 /// @dev This token contract's goal is to make it easy for anyone to clone this
67 ///  token using the token distribution at a given block, this will allow DAO's
68 ///  and DApps to upgrade their features in a decentralized manner without
69 ///  affecting the original token
70 /// @dev It is ERC20 compliant, but still needs to under go further testing.
71 
72 
73 
74 contract ApproveAndCallFallBack {
75     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
76 }
77 
78 /// @dev The actual token contract, the default controller is the msg.sender
79 ///  that deploys the contract, so usually this token will be deployed by a
80 ///  token controller contract, which Giveth will call a "Campaign"
81 contract MiniMeToken is Controlled {
82 
83     string public name;                //The Token's name: e.g. DigixDAO Tokens
84     uint8 public decimals;             //Number of decimals of the smallest unit
85     string public symbol;              //An identifier: e.g. REP
86     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
87 
88 
89     /// @dev `Checkpoint` is the structure that attaches a block number to a
90     ///  given value, the block number attached is the one that last changed the
91     ///  value
92     struct  Checkpoint {
93 
94         // `fromBlock` is the block number that the value was generated from
95         uint128 fromBlock;
96 
97         // `value` is the amount of tokens at a specific block number
98         uint128 value;
99     }
100 
101     // `parentToken` is the Token address that was cloned to produce this token;
102     //  it will be 0x0 for a token that was not cloned
103     MiniMeToken public parentToken;
104 
105     // `parentSnapShotBlock` is the block number from the Parent Token that was
106     //  used to determine the initial distribution of the Clone Token
107     uint public parentSnapShotBlock;
108 
109     // `creationBlock` is the block number that the Clone Token was created
110     uint public creationBlock;
111 
112     // `balances` is the map that tracks the balance of each address, in this
113     //  contract when the balance changes the block number that the change
114     //  occurred is also included in the map
115     mapping (address => Checkpoint[]) balances;
116 
117     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
118     mapping (address => mapping (address => uint256)) allowed;
119 
120     // Tracks the history of the `totalSupply` of the token
121     Checkpoint[] totalSupplyHistory;
122 
123     // Flag that determines if the token is transferable or not.
124     bool public transfersEnabled;
125 
126     // The factory used to create new clone tokens
127     MiniMeTokenFactory public tokenFactory;
128 
129 ////////////////
130 // Constructor
131 ////////////////
132 
133     /// @notice Constructor to create a MiniMeToken
134     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
135     ///  will create the Clone token contracts, the token factory needs to be
136     ///  deployed first
137     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
138     ///  new token
139     /// @param _parentSnapShotBlock Block of the parent token that will
140     ///  determine the initial distribution of the clone token, set to 0 if it
141     ///  is a new token
142     /// @param _tokenName Name of the new token
143     /// @param _decimalUnits Number of decimals of the new token
144     /// @param _tokenSymbol Token Symbol for the new token
145     /// @param _transfersEnabled If true, tokens will be able to be transferred
146     function MiniMeToken(
147         address _tokenFactory,
148         address _parentToken,
149         uint _parentSnapShotBlock,
150         string _tokenName,
151         uint8 _decimalUnits,
152         string _tokenSymbol,
153         bool _transfersEnabled
154     ) public {
155         tokenFactory = MiniMeTokenFactory(_tokenFactory);
156         name = _tokenName;                                 // Set the name
157         decimals = _decimalUnits;                          // Set the decimals
158         symbol = _tokenSymbol;                             // Set the symbol
159         parentToken = MiniMeToken(_parentToken);
160         parentSnapShotBlock = _parentSnapShotBlock;
161         transfersEnabled = _transfersEnabled;
162         creationBlock = block.number;
163     }
164 
165 
166 ///////////////////
167 // ERC20 Methods
168 ///////////////////
169 
170     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
171     /// @param _to The address of the recipient
172     /// @param _amount The amount of tokens to be transferred
173     /// @return Whether the transfer was successful or not
174     function transfer(address _to, uint256 _amount) public returns (bool success) {
175         require(transfersEnabled);
176         return doTransfer(msg.sender, _to, _amount);
177     }
178 
179     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
180     ///  is approved by `_from`
181     /// @param _from The address holding the tokens being transferred
182     /// @param _to The address of the recipient
183     /// @param _amount The amount of tokens to be transferred
184     /// @return True if the transfer was successful
185     function transferFrom(address _from, address _to, uint256 _amount
186     ) public returns (bool success) {
187 
188         // The controller of this contract can move tokens around at will,
189         //  this is important to recognize! Confirm that you trust the
190         //  controller of this contract, which in most situations should be
191         //  another open source smart contract or 0x0
192         if (msg.sender != controller) {
193             require(transfersEnabled);
194 
195             // The standard ERC 20 transferFrom functionality
196             if (allowed[_from][msg.sender] < _amount) return false;
197             allowed[_from][msg.sender] -= _amount;
198         }
199         return doTransfer(_from, _to, _amount);
200     }
201 
202     /// @dev This is the actual transfer function in the token contract, it can
203     ///  only be called by other functions in this contract.
204     /// @param _from The address holding the tokens being transferred
205     /// @param _to The address of the recipient
206     /// @param _amount The amount of tokens to be transferred
207     /// @return True if the transfer was successful
208     function doTransfer(address _from, address _to, uint _amount
209     ) internal returns(bool) {
210 
211            if (_amount == 0) {
212                return true;
213            }
214 
215            require(parentSnapShotBlock < block.number);
216 
217            // Do not allow transfer to 0x0 or the token contract itself
218            require((_to != 0) && (_to != address(this)));
219 
220            // If the amount being transfered is more than the balance of the
221            //  account the transfer returns false
222            var previousBalanceFrom = balanceOfAt(_from, block.number);
223            if (previousBalanceFrom < _amount) {
224                return false;
225            }
226 
227            // Alerts the token controller of the transfer
228            if (isContract(controller)) {
229                require(TokenController(controller).onTransfer(_from, _to, _amount));
230            }
231 
232            // First update the balance array with the new value for the address
233            //  sending the tokens
234            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
235 
236            // Then update the balance array with the new value for the address
237            //  receiving the tokens
238            var previousBalanceTo = balanceOfAt(_to, block.number);
239            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
240            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
241 
242            // An event to make the transfer easy to find on the blockchain
243            Transfer(_from, _to, _amount);
244 
245            return true;
246     }
247 
248     /// @param _owner The address that's balance is being requested
249     /// @return The balance of `_owner` at the current block
250     function balanceOf(address _owner) public constant returns (uint256 balance) {
251         return balanceOfAt(_owner, block.number);
252     }
253 
254     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
255     ///  its behalf. This is a modified version of the ERC20 approve function
256     ///  to be a little bit safer
257     /// @param _spender The address of the account able to transfer the tokens
258     /// @param _amount The amount of tokens to be approved for transfer
259     /// @return True if the approval was successful
260     function approve(address _spender, uint256 _amount) public returns (bool success) {
261         require(transfersEnabled);
262 
263         // To change the approve amount you first have to reduce the addresses`
264         //  allowance to zero by calling `approve(_spender,0)` if it is not
265         //  already 0 to mitigate the race condition described here:
266         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
267         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
268 
269         // Alerts the token controller of the approve function call
270         if (isContract(controller)) {
271             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
272         }
273 
274         allowed[msg.sender][_spender] = _amount;
275         Approval(msg.sender, _spender, _amount);
276         return true;
277     }
278 
279     /// @dev This function makes it easy to read the `allowed[]` map
280     /// @param _owner The address of the account that owns the token
281     /// @param _spender The address of the account able to transfer the tokens
282     /// @return Amount of remaining tokens of _owner that _spender is allowed
283     ///  to spend
284     function allowance(address _owner, address _spender
285     ) public constant returns (uint256 remaining) {
286         return allowed[_owner][_spender];
287     }
288 
289     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
290     ///  its behalf, and then a function is triggered in the contract that is
291     ///  being approved, `_spender`. This allows users to use their tokens to
292     ///  interact with contracts in one function call instead of two
293     /// @param _spender The address of the contract able to transfer the tokens
294     /// @param _amount The amount of tokens to be approved for transfer
295     /// @return True if the function call was successful
296     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
297     ) public returns (bool success) {
298         require(approve(_spender, _amount));
299 
300         ApproveAndCallFallBack(_spender).receiveApproval(
301             msg.sender,
302             _amount,
303             this,
304             _extraData
305         );
306 
307         return true;
308     }
309 
310     /// @dev This function makes it easy to get the total number of tokens
311     /// @return The total number of tokens
312     function totalSupply() public constant returns (uint) {
313         return totalSupplyAt(block.number);
314     }
315 
316 
317 ////////////////
318 // Query balance and totalSupply in History
319 ////////////////
320 
321     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
322     /// @param _owner The address from which the balance will be retrieved
323     /// @param _blockNumber The block number when the balance is queried
324     /// @return The balance at `_blockNumber`
325     function balanceOfAt(address _owner, uint _blockNumber) public constant
326         returns (uint) {
327 
328         // These next few lines are used when the balance of the token is
329         //  requested before a check point was ever created for this token, it
330         //  requires that the `parentToken.balanceOfAt` be queried at the
331         //  genesis block for that token as this contains initial balance of
332         //  this token
333         if ((balances[_owner].length == 0)
334             || (balances[_owner][0].fromBlock > _blockNumber)) {
335             if (address(parentToken) != 0) {
336                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
337             } else {
338                 // Has no parent
339                 return 0;
340             }
341 
342         // This will return the expected balance during normal situations
343         } else {
344             return getValueAt(balances[_owner], _blockNumber);
345         }
346     }
347 
348     /// @notice Total amount of tokens at a specific `_blockNumber`.
349     /// @param _blockNumber The block number when the totalSupply is queried
350     /// @return The total amount of tokens at `_blockNumber`
351     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
352 
353         // These next few lines are used when the totalSupply of the token is
354         //  requested before a check point was ever created for this token, it
355         //  requires that the `parentToken.totalSupplyAt` be queried at the
356         //  genesis block for this token as that contains totalSupply of this
357         //  token at this block number.
358         if ((totalSupplyHistory.length == 0)
359             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
360             if (address(parentToken) != 0) {
361                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
362             } else {
363                 return 0;
364             }
365 
366         // This will return the expected totalSupply during normal situations
367         } else {
368             return getValueAt(totalSupplyHistory, _blockNumber);
369         }
370     }
371 
372 ////////////////
373 // Clone Token Method
374 ////////////////
375 
376     /// @notice Creates a new clone token with the initial distribution being
377     ///  this token at `_snapshotBlock`
378     /// @param _cloneTokenName Name of the clone token
379     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
380     /// @param _cloneTokenSymbol Symbol of the clone token
381     /// @param _snapshotBlock Block when the distribution of the parent token is
382     ///  copied to set the initial distribution of the new clone token;
383     ///  if the block is zero than the actual block, the current block is used
384     /// @param _transfersEnabled True if transfers are allowed in the clone
385     /// @return The address of the new MiniMeToken Contract
386     function createCloneToken(
387         string _cloneTokenName,
388         uint8 _cloneDecimalUnits,
389         string _cloneTokenSymbol,
390         uint _snapshotBlock,
391         bool _transfersEnabled
392         ) public returns(address) {
393         if (_snapshotBlock == 0) _snapshotBlock = block.number;
394         MiniMeToken cloneToken = tokenFactory.createCloneToken(
395             this,
396             _snapshotBlock,
397             _cloneTokenName,
398             _cloneDecimalUnits,
399             _cloneTokenSymbol,
400             _transfersEnabled
401             );
402 
403         cloneToken.changeController(msg.sender);
404 
405         // An event to make the token easy to find on the blockchain
406         NewCloneToken(address(cloneToken), _snapshotBlock);
407         return address(cloneToken);
408     }
409 
410 ////////////////
411 // Generate and destroy tokens
412 ////////////////
413 
414     /// @notice Generates `_amount` tokens that are assigned to `_owner`
415     /// @param _owner The address that will be assigned the new tokens
416     /// @param _amount The quantity of tokens generated
417     /// @return True if the tokens are generated correctly
418     function generateTokens(address _owner, uint _amount
419     ) public onlyController returns (bool) {
420         uint curTotalSupply = totalSupply();
421         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
422         uint previousBalanceTo = balanceOf(_owner);
423         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
424         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
425         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
426         Transfer(0, _owner, _amount);
427         return true;
428     }
429 
430 
431     /// @notice Burns `_amount` tokens from `_owner`
432     /// @param _owner The address that will lose the tokens
433     /// @param _amount The quantity of tokens to burn
434     /// @return True if the tokens are burned correctly
435     function destroyTokens(address _owner, uint _amount
436     ) onlyController public returns (bool) {
437         uint curTotalSupply = totalSupply();
438         require(curTotalSupply >= _amount);
439         uint previousBalanceFrom = balanceOf(_owner);
440         require(previousBalanceFrom >= _amount);
441         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
442         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
443         Transfer(_owner, 0, _amount);
444         return true;
445     }
446 
447 ////////////////
448 // Enable tokens transfers
449 ////////////////
450 
451 
452     /// @notice Enables token holders to transfer their tokens freely if true
453     /// @param _transfersEnabled True if transfers are allowed in the clone
454     function enableTransfers(bool _transfersEnabled) public onlyController {
455         transfersEnabled = _transfersEnabled;
456     }
457 
458 ////////////////
459 // Internal helper functions to query and set a value in a snapshot array
460 ////////////////
461 
462     /// @dev `getValueAt` retrieves the number of tokens at a given block number
463     /// @param checkpoints The history of values being queried
464     /// @param _block The block number to retrieve the value at
465     /// @return The number of tokens being queried
466     function getValueAt(Checkpoint[] storage checkpoints, uint _block
467     ) constant internal returns (uint) {
468         if (checkpoints.length == 0) return 0;
469 
470         // Shortcut for the actual value
471         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
472             return checkpoints[checkpoints.length-1].value;
473         if (_block < checkpoints[0].fromBlock) return 0;
474 
475         // Binary search of the value in the array
476         uint min = 0;
477         uint max = checkpoints.length-1;
478         while (max > min) {
479             uint mid = (max + min + 1)/ 2;
480             if (checkpoints[mid].fromBlock<=_block) {
481                 min = mid;
482             } else {
483                 max = mid-1;
484             }
485         }
486         return checkpoints[min].value;
487     }
488 
489     /// @dev `updateValueAtNow` used to update the `balances` map and the
490     ///  `totalSupplyHistory`
491     /// @param checkpoints The history of data being updated
492     /// @param _value The new number of tokens
493     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
494     ) internal  {
495         if ((checkpoints.length == 0)
496         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
497                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
498                newCheckPoint.fromBlock =  uint128(block.number);
499                newCheckPoint.value = uint128(_value);
500            } else {
501                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
502                oldCheckPoint.value = uint128(_value);
503            }
504     }
505 
506     /// @dev Internal function to determine if an address is a contract
507     /// @param _addr The address being queried
508     /// @return True if `_addr` is a contract
509     function isContract(address _addr) constant internal returns(bool) {
510         uint size;
511         if (_addr == 0) return false;
512         assembly {
513             size := extcodesize(_addr)
514         }
515         return size>0;
516     }
517 
518     /// @dev Helper function to return a min betwen the two uints
519     function min(uint a, uint b) pure internal returns (uint) {
520         return a < b ? a : b;
521     }
522 
523     /// @notice The fallback function: If the contract's controller has not been
524     ///  set to 0, then the `proxyPayment` method is called which relays the
525     ///  ether and creates tokens as described in the token controller contract
526     function () public payable {
527         require(isContract(controller));
528         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
529     }
530 
531 //////////
532 // Safety Methods
533 //////////
534 
535     /// @notice This method can be used by the controller to extract mistakenly
536     ///  sent tokens to this contract.
537     /// @param _token The address of the token contract that you want to recover
538     ///  set to 0 in case you want to extract ether.
539     function claimTokens(address _token) public onlyController {
540         if (_token == 0x0) {
541             controller.transfer(this.balance);
542             return;
543         }
544 
545         MiniMeToken token = MiniMeToken(_token);
546         uint balance = token.balanceOf(this);
547         token.transfer(controller, balance);
548         ClaimedTokens(_token, controller, balance);
549     }
550 
551 ////////////////
552 // Events
553 ////////////////
554     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
555     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
556     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
557     event Approval(
558         address indexed _owner,
559         address indexed _spender,
560         uint256 _amount
561         );
562 
563 }
564 
565 
566 ////////////////
567 // MiniMeTokenFactory
568 ////////////////
569 
570 /// @dev This contract is used to generate clone contracts from a contract.
571 ///  In solidity this is the way to create a contract from a contract of the
572 ///  same class
573 contract MiniMeTokenFactory {
574 
575     /// @notice Update the DApp by creating a new token with new functionalities
576     ///  the msg.sender becomes the controller of this clone token
577     /// @param _parentToken Address of the token being cloned
578     /// @param _snapshotBlock Block of the parent token that will
579     ///  determine the initial distribution of the clone token
580     /// @param _tokenName Name of the new token
581     /// @param _decimalUnits Number of decimals of the new token
582     /// @param _tokenSymbol Token Symbol for the new token
583     /// @param _transfersEnabled If true, tokens will be able to be transferred
584     /// @return The address of the new token contract
585     function createCloneToken(
586         address _parentToken,
587         uint _snapshotBlock,
588         string _tokenName,
589         uint8 _decimalUnits,
590         string _tokenSymbol,
591         bool _transfersEnabled
592     ) public returns (MiniMeToken) {
593         MiniMeToken newToken = new MiniMeToken(
594             this,
595             _parentToken,
596             _snapshotBlock,
597             _tokenName,
598             _decimalUnits,
599             _tokenSymbol,
600             _transfersEnabled
601             );
602 
603         newToken.changeController(msg.sender);
604         return newToken;
605     }
606 }
607 
608 
609 /**
610  * @title Burnable MiniMe Token
611  * @dev Token that can be irreversibly burned (destroyed).
612  */
613 contract BurnableMiniMeToken is MiniMeToken {
614   event Burn(address indexed burner, uint256 value);
615 
616   /**
617    * @dev Burns a specific amount of tokens.
618    * @param _amount The amount of token to be burned.
619    */
620   function burn(uint256 _amount) public returns (bool) {
621     uint curTotalSupply = totalSupply();
622     require(curTotalSupply >= _amount);
623     uint previousBalanceFrom = balanceOf(msg.sender);
624     require(previousBalanceFrom >= _amount);
625     updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
626     updateValueAtNow(balances[msg.sender], previousBalanceFrom - _amount);
627     Transfer(msg.sender, 0, _amount);
628     return true;
629   }
630 }
631 
632 
633 pragma solidity^0.4.18;
634 
635 
636   
637 contract RankingBallGoldToken is MiniMeToken, BurnableMiniMeToken { 
638     function RankingBallGoldToken(address _tokenFactory)
639       MiniMeToken(
640         _tokenFactory,
641         0x0,                     // no parent token
642         0,                       // no snapshot block number from parent
643         "RankingBall Gold",  // Token name
644         18,                      // Decimals
645         "RBG",                   // Symbol
646         true                     // Enable transfers
647       ) {} 
648 }
649 
650 
651 interface POSTokenI {
652   /// @notice Query if a contract implements an interface
653   /// @param interfaceID The interface identifier, as specified in ERC-165
654   /// @dev Interface identification is specified in ERC-165. This function
655   ///  uses less than 30,000 gas.
656   /// @return `true` if the contract implements `interfaceID` and
657   ///  `interfaceID` is not 0xffffffff, `false` otherwise
658   function supportsInterface(bytes4 interfaceID) public view returns (bool);
659 
660   /// @notice calls `Ownable.transferOwnership()` or `Controlled.changeController()`
661   function transferOwnershipTo(address _to) public;
662 }
663 
664 interface MintableTokenI {
665   function mint(address _to, uint256 _amount) public returns (bool);
666 }
667 
668 interface MiniMeTokenI {
669   function generateTokens(address _to, uint256 _amount) public returns (bool);
670 }
671 
672 
673 /**
674  * @title SafeMath
675  * @dev Math operations with safety checks that throw on error
676  */
677 library SafeMath {
678 
679   /**
680   * @dev Multiplies two numbers, throws on overflow.
681   */
682   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
683     if (a == 0) {
684       return 0;
685     }
686     c = a * b;
687     assert(c / a == b);
688     return c;
689   }
690 
691   /**
692   * @dev Integer division of two numbers, truncating the quotient.
693   */
694   function div(uint256 a, uint256 b) internal pure returns (uint256) {
695     // assert(b > 0); // Solidity automatically throws when dividing by 0
696     // uint256 c = a / b;
697     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
698     return a / b;
699   }
700 
701   /**
702   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
703   */
704   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
705     assert(b <= a);
706     return a - b;
707   }
708 
709   /**
710   * @dev Adds two numbers, throws on overflow.
711   */
712   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
713     c = a + b;
714     assert(c >= a);
715     return c;
716   }
717 }
718 
719 
720 /**
721  * @title Ownable
722  * @dev The Ownable contract has an owner address, and provides basic authorization control
723  * functions, this simplifies the implementation of "user permissions".
724  */
725 contract Ownable {
726   address public owner;
727 
728 
729   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
730 
731 
732   /**
733    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
734    * account.
735    */
736   function Ownable() public {
737     owner = msg.sender;
738   }
739 
740   /**
741    * @dev Throws if called by any account other than the owner.
742    */
743   modifier onlyOwner() {
744     require(msg.sender == owner);
745     _;
746   }
747 
748   /**
749    * @dev Allows the current owner to transfer control of the contract to a newOwner.
750    * @param newOwner The address to transfer ownership to.
751    */
752   function transferOwnership(address newOwner) public onlyOwner {
753     require(newOwner != address(0));
754     emit OwnershipTransferred(owner, newOwner);
755     owner = newOwner;
756   }
757 
758 }
759 
760 
761 /**
762  * @title ERC20Basic
763  * @dev Simpler version of ERC20 interface
764  * @dev see https://github.com/ethereum/EIPs/issues/179
765  */
766 contract ERC20Basic {
767   function totalSupply() public view returns (uint256);
768   function balanceOf(address who) public view returns (uint256);
769   function transfer(address to, uint256 value) public returns (bool);
770   event Transfer(address indexed from, address indexed to, uint256 value);
771 }
772 
773 
774 /**
775  * @title ERC20 interface
776  * @dev see https://github.com/ethereum/EIPs/issues/20
777  */
778 contract ERC20 is ERC20Basic {
779   function allowance(address owner, address spender) public view returns (uint256);
780   function transferFrom(address from, address to, uint256 value) public returns (bool);
781   function approve(address spender, uint256 value) public returns (bool);
782   event Approval(address indexed owner, address indexed spender, uint256 value);
783 }
784 
785 
786 /// @title POSController
787 /// @dev POSController is a token controller that generate token interests.
788 ///  according to parameters(rate, coeff, interval blocks).
789 ///  It should be controller of `MiniMeToken` or owner of `MintableToken`.
790 contract POSController is Ownable, TokenController {
791   using SafeMath for uint256;
792 
793   struct Claim {
794     uint128 fromBlock;
795     uint128 claimedValue;
796   }
797 
798   address public token;
799 
800   // POSController parameters
801   uint256 public posInterval;
802   uint256 public posRate;
803   uint256 public posCoeff;
804 
805   uint256 public initBlockNumber;
806 
807   mapping (address => Claim[]) public claims;
808 
809   event Claimed(address indexed _owner, uint256 _amount);
810 
811   /* Constructor */
812   function POSController(
813     address _token,
814     uint256 _posInterval,
815     uint256 _initBlockNumber,
816     uint256 _posRate,
817     uint256 _posCoeff
818   ) public {
819     require(_token != address(0));
820 
821     require(_posInterval != 0);
822     require(_posRate != 0);
823     require(_posCoeff != 0);
824 
825     token = _token;
826     posInterval = _posInterval;
827     posRate = _posRate;
828     posCoeff = _posCoeff;
829 
830     if (_initBlockNumber == 0) {
831       initBlockNumber = block.number;
832     } else {
833       initBlockNumber = _initBlockNumber;
834     }
835   }
836 
837   /* External */
838 
839   /* Public */
840   /// @notice claim interests generated by POSController
841   function claimTokens(address _owner) public {
842     doClaim(_owner, claims[_owner]);
843   }
844 
845   /// @notice transfer token ownerhsip
846   function claimTokenOwnership(address _to) public onlyOwner {
847     POSTokenI(token).transferOwnershipTo(_to);
848   }
849 
850   /// @notice proxyPayment implements MiniMeToken Controller's proxyPayment
851   function proxyPayment(address _owner) public payable returns(bool) {
852     revert(); // reject ether transfer to token contract
853     return false;
854   }
855 
856   /// @notice onTransfer implements MiniMeToken Controller's onTransfer
857   function onTransfer(address _from, address _to, uint _amount) public returns(bool) {
858     claimTokens(_from);
859     claimTokens(_to);
860     return true;
861   }
862 
863   /// @notice onApprove implements MiniMeToken Controller's onApprove
864   function onApprove(address _owner, address _spender, uint _amount) public returns(bool) {
865     return true;
866   }
867 
868   /* Internal */
869   function doClaim(address _owner, Claim[] storage c) internal {
870     uint256 claimRate;
871 
872     if (c.length == 0 && claimable(block.number)) {
873       claimRate = getClaimRate(0);
874     } else if (c.length > 0 && claimable(c[c.length - 1].fromBlock)) {
875       claimRate = getClaimRate(c[c.length - 1].fromBlock);
876     }
877 
878     if (claimRate > 0) {
879       Claim storage newClaim = c[c.length++];
880 
881       uint256 balance = ERC20(token).balanceOf(_owner);
882 
883       // Short cuircit if there is no token to claim
884       if (balance == 0) {
885         return;
886       }
887 
888       // TODO: reduce variables into few statements
889       uint256 targetBalance = balance.mul(posCoeff.add(claimRate)).div(posCoeff);
890       uint256 claimedValue = targetBalance.sub(balance);
891 
892       newClaim.claimedValue = uint128(claimedValue);
893       newClaim.fromBlock = uint128(block.number);
894 
895       require(generateTokens(_owner, newClaim.claimedValue));
896 
897       emit Claimed(_owner, newClaim.claimedValue);
898     }
899   }
900 
901   function generateTokens(address _to, uint256 _value) internal returns (bool) {
902     if (POSTokenI(token).supportsInterface(bytes4(keccak256("mint(address,uint256)")))) {
903       return MintableTokenI(token).mint(_to, _value);
904     } else if (POSTokenI(token).supportsInterface(bytes4(keccak256("generateTokens(address,uint256)")))) {
905       return MiniMeTokenI(token).generateTokens(_to, _value);
906     }
907 
908     return false;
909   }
910 
911   function claimable(uint256 _blockNumber) internal view returns (bool) {
912     if (_blockNumber < initBlockNumber) return false;
913 
914     return (_blockNumber - initBlockNumber) >= posInterval;
915   }
916 
917   function getClaimRate(uint256 _fromBlock) internal view returns (uint256) {
918     // interval block number when token holder get interests.
919     // if holder didn't claim before, `initBlockNumber`
920     // otherwise, n-th interval block (`initBlockNumber` + k * `posInterval`)
921     uint256 lastIntervalBlock;
922 
923     if (_fromBlock == 0) { // first claim
924       lastIntervalBlock = initBlockNumber;
925     } else { // second or further claim
926       uint256 offset = _fromBlock.sub(initBlockNumber) % posInterval;
927       lastIntervalBlock = _fromBlock.sub(offset);
928     }
929 
930     // # of cumulative claims
931     uint256 pow = block.number.sub(lastIntervalBlock) / posInterval;
932 
933     // no token to claim
934     if (pow == 0) {
935       return 0;
936     }
937 
938     // assume 1 claim is given to reduce loop iteration
939     uint256 rate = posRate;
940 
941     // if claim rate is 10%,
942     // 1st claim: 10%
943     // 2nd claim: 10% + 11%
944     // 3rd claim: 10% + (10% + 11%) * 110%
945     //
946     // ith claim: posRate + [i-1th claim] * (posCoeff + posRate) / posCoeff
947     for (uint256 i = 0; i < pow - 1; i++) {
948       rate = rate.mul(posCoeff.add(posRate)).div(posCoeff).add(posRate);
949     }
950 
951     return rate;
952   }
953 }
954 
955 
956 
957 
958 
959 /// @dev BalanceUpdatableMiniMeToken assumes token controller may update
960 ///  token balance inside `onTransfer` function of token controller.
961 contract BalanceUpdatableMiniMeToken is MiniMeToken {
962 
963   /// @dev Override doTransfer function. only modified parts are documented.
964   function doTransfer(address _from, address _to, uint _amount) internal returns(bool) {
965 
966     if (_amount == 0) {
967       Transfer(_from, _to, _amount);
968       return true;
969     }
970 
971     require(parentSnapShotBlock < block.number);
972     require((_to != 0) && (_to != address(this)));
973 
974     uint previousBalanceFrom = balanceOfAt(_from, block.number);
975     require(previousBalanceFrom >= _amount);
976 
977     if (isContract(controller)) {
978       require(TokenController(controller).onTransfer(_from, _to, _amount));
979 
980       // update balance
981       previousBalanceFrom = balanceOfAt(_from, block.number);
982       require(previousBalanceFrom >= _amount);
983     }
984 
985     updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
986 
987     var previousBalanceTo = balanceOfAt(_to, block.number);
988     require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
989     updateValueAtNow(balances[_to], previousBalanceTo + _amount);
990 
991     Transfer(_from, _to, _amount);
992 
993     return true;
994   }
995 }
996 
997 
998 /**
999  * @title Basic token
1000  * @dev Basic version of StandardToken, with no allowances.
1001  */
1002 contract BasicToken is ERC20Basic {
1003   using SafeMath for uint256;
1004 
1005   mapping(address => uint256) balances;
1006 
1007   uint256 totalSupply_;
1008 
1009   /**
1010   * @dev total number of tokens in existence
1011   */
1012   function totalSupply() public view returns (uint256) {
1013     return totalSupply_;
1014   }
1015 
1016   /**
1017   * @dev transfer token for a specified address
1018   * @param _to The address to transfer to.
1019   * @param _value The amount to be transferred.
1020   */
1021   function transfer(address _to, uint256 _value) public returns (bool) {
1022     require(_to != address(0));
1023     require(_value <= balances[msg.sender]);
1024 
1025     balances[msg.sender] = balances[msg.sender].sub(_value);
1026     balances[_to] = balances[_to].add(_value);
1027     emit Transfer(msg.sender, _to, _value);
1028     return true;
1029   }
1030 
1031   /**
1032   * @dev Gets the balance of the specified address.
1033   * @param _owner The address to query the the balance of.
1034   * @return An uint256 representing the amount owned by the passed address.
1035   */
1036   function balanceOf(address _owner) public view returns (uint256) {
1037     return balances[_owner];
1038   }
1039 
1040 }
1041 
1042 
1043 /**
1044  * @title Standard ERC20 token
1045  *
1046  * @dev Implementation of the basic standard token.
1047  * @dev https://github.com/ethereum/EIPs/issues/20
1048  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
1049  */
1050 contract StandardToken is ERC20, BasicToken {
1051 
1052   mapping (address => mapping (address => uint256)) internal allowed;
1053 
1054 
1055   /**
1056    * @dev Transfer tokens from one address to another
1057    * @param _from address The address which you want to send tokens from
1058    * @param _to address The address which you want to transfer to
1059    * @param _value uint256 the amount of tokens to be transferred
1060    */
1061   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
1062     require(_to != address(0));
1063     require(_value <= balances[_from]);
1064     require(_value <= allowed[_from][msg.sender]);
1065 
1066     balances[_from] = balances[_from].sub(_value);
1067     balances[_to] = balances[_to].add(_value);
1068     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
1069     emit Transfer(_from, _to, _value);
1070     return true;
1071   }
1072 
1073   /**
1074    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
1075    *
1076    * Beware that changing an allowance with this method brings the risk that someone may use both the old
1077    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
1078    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
1079    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1080    * @param _spender The address which will spend the funds.
1081    * @param _value The amount of tokens to be spent.
1082    */
1083   function approve(address _spender, uint256 _value) public returns (bool) {
1084     allowed[msg.sender][_spender] = _value;
1085     emit Approval(msg.sender, _spender, _value);
1086     return true;
1087   }
1088 
1089   /**
1090    * @dev Function to check the amount of tokens that an owner allowed to a spender.
1091    * @param _owner address The address which owns the funds.
1092    * @param _spender address The address which will spend the funds.
1093    * @return A uint256 specifying the amount of tokens still available for the spender.
1094    */
1095   function allowance(address _owner, address _spender) public view returns (uint256) {
1096     return allowed[_owner][_spender];
1097   }
1098 
1099   /**
1100    * @dev Increase the amount of tokens that an owner allowed to a spender.
1101    *
1102    * approve should be called when allowed[_spender] == 0. To increment
1103    * allowed value is better to use this function to avoid 2 calls (and wait until
1104    * the first transaction is mined)
1105    * From MonolithDAO Token.sol
1106    * @param _spender The address which will spend the funds.
1107    * @param _addedValue The amount of tokens to increase the allowance by.
1108    */
1109   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
1110     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
1111     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1112     return true;
1113   }
1114 
1115   /**
1116    * @dev Decrease the amount of tokens that an owner allowed to a spender.
1117    *
1118    * approve should be called when allowed[_spender] == 0. To decrement
1119    * allowed value is better to use this function to avoid 2 calls (and wait until
1120    * the first transaction is mined)
1121    * From MonolithDAO Token.sol
1122    * @param _spender The address which will spend the funds.
1123    * @param _subtractedValue The amount of tokens to decrease the allowance by.
1124    */
1125   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
1126     uint oldValue = allowed[msg.sender][_spender];
1127     if (_subtractedValue > oldValue) {
1128       allowed[msg.sender][_spender] = 0;
1129     } else {
1130       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
1131     }
1132     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1133     return true;
1134   }
1135 
1136 }
1137 
1138 
1139 /**
1140  * @title Mintable token
1141  * @dev Simple ERC20 Token example, with mintable token creation
1142  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
1143  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
1144  */
1145 contract MintableToken is StandardToken, Ownable {
1146   event Mint(address indexed to, uint256 amount);
1147   event MintFinished();
1148 
1149   bool public mintingFinished = false;
1150 
1151 
1152   modifier canMint() {
1153     require(!mintingFinished);
1154     _;
1155   }
1156 
1157   /**
1158    * @dev Function to mint tokens
1159    * @param _to The address that will receive the minted tokens.
1160    * @param _amount The amount of tokens to mint.
1161    * @return A boolean that indicates if the operation was successful.
1162    */
1163   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
1164     totalSupply_ = totalSupply_.add(_amount);
1165     balances[_to] = balances[_to].add(_amount);
1166     emit Mint(_to, _amount);
1167     emit Transfer(address(0), _to, _amount);
1168     return true;
1169   }
1170 
1171   /**
1172    * @dev Function to stop minting new tokens.
1173    * @return True if the operation was successful.
1174    */
1175   function finishMinting() onlyOwner canMint public returns (bool) {
1176     mintingFinished = true;
1177     emit MintFinished();
1178     return true;
1179   }
1180 }
1181 
1182 
1183 /// @title TokenControllerBridge
1184 /// @notice TokenControllerBridge mocks Giveth's `Controller` for
1185 ///  Zeppelin's `Ownable` `ERC20` Token.
1186 contract TokenControllerBridge is ERC20, Ownable {
1187   function () public payable {
1188     require(isContract(owner));
1189     require(TokenController(owner).proxyPayment.value(msg.value)(msg.sender));
1190   }
1191 
1192   /// @dev invoke onTransfer function before actual transfer function is executed.
1193   function transfer(address _to, uint256 _value) public returns (bool) {
1194     if (isContract(owner)) { // owner should be able to generate tokens
1195       require(balanceOf(msg.sender) >= _value);
1196       require(TokenController(owner).onTransfer(msg.sender, _to, _value));
1197     }
1198 
1199     return super.transfer(_to, _value);
1200   }
1201 
1202   /// @dev invoke onTransfer function before actual transfer function is executed.
1203   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
1204     if (isContract(owner)) { // owner should be able to generate tokens
1205       require(balanceOf(_from) >= _value);
1206       require(TokenController(owner).onTransfer(_from, _to, _value));
1207     }
1208 
1209     return super.transferFrom(_from, _to, _value);
1210   }
1211 
1212   /// @dev invoke onApprove function before actual transfer function is executed.
1213   function approve(address _spender, uint256 _value) public returns (bool) {
1214     if (isContract(owner)) {
1215       require(TokenController(owner).onApprove(msg.sender, _spender, _value));
1216     }
1217 
1218     return super.approve(_spender, _value);
1219   }
1220 
1221   /// @dev Internal function to determine if an address is a contract
1222   /// @param _addr The address being queried
1223   /// @return True if `_addr` is a contract
1224   function isContract(address _addr) internal view returns(bool) {
1225     uint256 size;
1226     if (_addr == 0) return false;
1227     assembly {
1228       size := extcodesize(_addr)
1229     }
1230     return size > 0;
1231   }
1232 }
1233 
1234 
1235 /// @title POSMintableTokenAPI
1236 /// @notice MintableToken should inherit POSMintableTokenAPI to be able to
1237 ///  compatible with POSController.
1238 contract POSMintableTokenAPI is POSTokenI, TokenControllerBridge {
1239   function supportsInterface(bytes4 interfaceID) public view returns (bool) {
1240     return interfaceID == bytes4(keccak256("mint(address,uint256)")); // TODO: use bytes4 literal
1241   }
1242 
1243   function transferOwnershipTo(address _to) public {
1244     transferOwnership(_to);
1245   }
1246 }
1247 
1248 
1249 /// @title POSMiniMeTokenAPI
1250 /// @notice BalanceUpdatableMiniMeToken should inherit POSMintableTokenAPI to be able to
1251 ///  compatible with POSController.
1252 contract POSMiniMeTokenAPI is POSTokenI, Controlled {
1253   function supportsInterface(bytes4 interfaceID) public view returns (bool) {
1254     return interfaceID == bytes4(keccak256("generateTokens(address,uint256)")); // TODO: use bytes4 literal
1255   }
1256 
1257   function transferOwnershipTo(address _to) public {
1258     changeController(_to);
1259   }
1260 }
1261 
1262 
1263 /// @dev POSMiniMeToken inherits BalanceUpdatableMiniMeToken to update token balances
1264 ///  inside `onTransfer` function, POSMiniMeTokenAPI to provdie common
1265 ///  interface for POSController.
1266 // solium-disable no-empty-blocks
1267 contract POSMiniMeToken is BalanceUpdatableMiniMeToken, POSMiniMeTokenAPI {}
1268 
1269 
1270 contract RankingBallGoldCustomToken is POSMiniMeToken, RankingBallGoldToken {
1271   function RankingBallGoldCustomToken(address _tokenFactory)
1272     RankingBallGoldToken(_tokenFactory)
1273     public
1274   {}
1275 }