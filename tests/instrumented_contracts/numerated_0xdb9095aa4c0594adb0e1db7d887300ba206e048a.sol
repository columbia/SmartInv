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
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 
32   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a >= b ? a : b;
34   }
35 
36   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
37     return a < b ? a : b;
38   }
39 
40   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a >= b ? a : b;
42   }
43 
44   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
45     return a < b ? a : b;
46   }
47 }
48 
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56   address public owner;
57 
58 
59   /**
60    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
61    * account.
62    */
63   function Ownable() {
64     owner = msg.sender;
65   }
66 
67 
68   /**
69    * @dev Throws if called by any account other than the owner.
70    */
71   modifier onlyOwner() {
72     require(msg.sender == owner);
73     _;
74   }
75 
76 
77   /**
78    * @dev Allows the current owner to transfer control of the contract to a newOwner.
79    * @param newOwner The address to transfer ownership to.
80    */
81   function transferOwnership(address newOwner) onlyOwner {
82     require(newOwner != address(0));
83     owner = newOwner;
84   }
85 
86 }
87 
88 
89 /*
90     Copyright 2016, Jordi Baylina
91 
92     This program is free software: you can redistribute it and/or modify
93     it under the terms of the GNU General Public License as published by
94     the Free Software Foundation, either version 3 of the License, or
95     (at your option) any later version.
96 
97     This program is distributed in the hope that it will be useful,
98     but WITHOUT ANY WARRANTY; without even the implied warranty of
99     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
100     GNU General Public License for more details.
101 
102     You should have received a copy of the GNU General Public License
103     along with this program.  If not, see <http://www.gnu.org/licenses/>.
104  */
105 
106 /// @title MiniMeToken Contract
107 /// @author Jordi Baylina
108 /// @dev This token contract's goal is to make it easy for anyone to clone this
109 ///  token using the token distribution at a given block, this will allow DAO's
110 ///  and DApps to upgrade their features in a decentralized manner without
111 ///  affecting the original token
112 /// @dev It is ERC20 compliant, but still needs to under go further testing.
113 
114 /// @dev The token controller contract must implement these functions
115 contract TokenController {
116     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
117     /// @param _owner The address that sent the ether to create tokens
118     /// @return True if the ether is accepted, false if it throws
119     function proxyPayment(address _owner) public payable returns(bool);
120 
121     /// @notice Notifies the controller about a token transfer allowing the
122     ///  controller to react if desired
123     /// @param _from The origin of the transfer
124     /// @param _to The destination of the transfer
125     /// @param _amount The amount of the transfer
126     /// @return False if the controller does not authorize the transfer
127     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
128 
129     /// @notice Notifies the controller about an approval allowing the
130     ///  controller to react if desired
131     /// @param _owner The address that calls `approve()`
132     /// @param _spender The spender in the `approve()` call
133     /// @param _amount The amount in the `approve()` call
134     /// @return False if the controller does not authorize the approval
135     function onApprove(address _owner, address _spender, uint _amount) public
136         returns(bool);
137 }
138 
139 
140 
141 contract Controlled {
142     /// @notice The address of the controller is the only address that can call
143     ///  a function with this modifier
144     modifier onlyController { require(msg.sender == controller); _; }
145 
146     address public controller;
147 
148     function Controlled() public { controller = msg.sender;}
149 
150     /// @notice Changes the controller of the contract
151     /// @param _newController The new controller of the contract
152     function changeController(address _newController) public onlyController {
153         controller = _newController;
154     }
155 }
156 
157 
158 contract ApproveAndCallFallBack {
159     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
160 }
161 
162 /// @dev The actual token contract, the default controller is the msg.sender
163 ///  that deploys the contract, so usually this token will be deployed by a
164 ///  token controller contract, which Giveth will call a "Campaign"
165 contract MiniMeToken is Controlled {
166 
167     string public name;                //The Token's name: e.g. DigixDAO Tokens
168     uint8 public decimals;             //Number of decimals of the smallest unit
169     string public symbol;              //An identifier: e.g. REP
170     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
171 
172 
173     /// @dev `Checkpoint` is the structure that attaches a block number to a
174     ///  given value, the block number attached is the one that last changed the
175     ///  value
176     struct  Checkpoint {
177 
178         // `fromBlock` is the block number that the value was generated from
179         uint128 fromBlock;
180 
181         // `value` is the amount of tokens at a specific block number
182         uint128 value;
183     }
184 
185     // `parentToken` is the Token address that was cloned to produce this token;
186     //  it will be 0x0 for a token that was not cloned
187     MiniMeToken public parentToken;
188 
189     // `parentSnapShotBlock` is the block number from the Parent Token that was
190     //  used to determine the initial distribution of the Clone Token
191     uint public parentSnapShotBlock;
192 
193     // `creationBlock` is the block number that the Clone Token was created
194     uint public creationBlock;
195 
196     // `balances` is the map that tracks the balance of each address, in this
197     //  contract when the balance changes the block number that the change
198     //  occurred is also included in the map
199     mapping (address => Checkpoint[]) balances;
200 
201     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
202     mapping (address => mapping (address => uint256)) allowed;
203 
204     // Tracks the history of the `totalSupply` of the token
205     Checkpoint[] totalSupplyHistory;
206 
207     // Flag that determines if the token is transferable or not.
208     bool public transfersEnabled;
209 
210     // The factory used to create new clone tokens
211     MiniMeTokenFactory public tokenFactory;
212 
213 ////////////////
214 // Constructor
215 ////////////////
216 
217     /// @notice Constructor to create a MiniMeToken
218     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
219     ///  will create the Clone token contracts, the token factory needs to be
220     ///  deployed first
221     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
222     ///  new token
223     /// @param _parentSnapShotBlock Block of the parent token that will
224     ///  determine the initial distribution of the clone token, set to 0 if it
225     ///  is a new token
226     /// @param _tokenName Name of the new token
227     /// @param _decimalUnits Number of decimals of the new token
228     /// @param _tokenSymbol Token Symbol for the new token
229     /// @param _transfersEnabled If true, tokens will be able to be transferred
230     function MiniMeToken(
231         address _tokenFactory,
232         address _parentToken,
233         uint _parentSnapShotBlock,
234         string _tokenName,
235         uint8 _decimalUnits,
236         string _tokenSymbol,
237         bool _transfersEnabled
238     ) public {
239         tokenFactory = MiniMeTokenFactory(_tokenFactory);
240         name = _tokenName;                                 // Set the name
241         decimals = _decimalUnits;                          // Set the decimals
242         symbol = _tokenSymbol;                             // Set the symbol
243         parentToken = MiniMeToken(_parentToken);
244         parentSnapShotBlock = _parentSnapShotBlock;
245         transfersEnabled = _transfersEnabled;
246         creationBlock = block.number;
247     }
248 
249 
250 ///////////////////
251 // ERC20 Methods
252 ///////////////////
253 
254     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
255     /// @param _to The address of the recipient
256     /// @param _amount The amount of tokens to be transferred
257     /// @return Whether the transfer was successful or not
258     function transfer(address _to, uint256 _amount) public returns (bool success) {
259         require(transfersEnabled);
260         return doTransfer(msg.sender, _to, _amount);
261     }
262 
263     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
264     ///  is approved by `_from`
265     /// @param _from The address holding the tokens being transferred
266     /// @param _to The address of the recipient
267     /// @param _amount The amount of tokens to be transferred
268     /// @return True if the transfer was successful
269     function transferFrom(address _from, address _to, uint256 _amount
270     ) public returns (bool success) {
271 
272         // The controller of this contract can move tokens around at will,
273         //  this is important to recognize! Confirm that you trust the
274         //  controller of this contract, which in most situations should be
275         //  another open source smart contract or 0x0
276         if (msg.sender != controller) {
277             require(transfersEnabled);
278 
279             // The standard ERC 20 transferFrom functionality
280             if (allowed[_from][msg.sender] < _amount) return false;
281             allowed[_from][msg.sender] -= _amount;
282         }
283         return doTransfer(_from, _to, _amount);
284     }
285 
286     /// @dev This is the actual transfer function in the token contract, it can
287     ///  only be called by other functions in this contract.
288     /// @param _from The address holding the tokens being transferred
289     /// @param _to The address of the recipient
290     /// @param _amount The amount of tokens to be transferred
291     /// @return True if the transfer was successful
292     function doTransfer(address _from, address _to, uint _amount
293     ) internal returns(bool) {
294 
295            if (_amount == 0) {
296                return true;
297            }
298 
299            require(parentSnapShotBlock < block.number);
300 
301            // Do not allow transfer to 0x0 or the token contract itself
302            require((_to != 0) && (_to != address(this)));
303 
304            // If the amount being transfered is more than the balance of the
305            //  account the transfer returns false
306            var previousBalanceFrom = balanceOfAt(_from, block.number);
307            if (previousBalanceFrom < _amount) {
308                return false;
309            }
310 
311            // Alerts the token controller of the transfer
312            if (isContract(controller)) {
313                require(TokenController(controller).onTransfer(_from, _to, _amount));
314            }
315 
316            // First update the balance array with the new value for the address
317            //  sending the tokens
318            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
319 
320            // Then update the balance array with the new value for the address
321            //  receiving the tokens
322            var previousBalanceTo = balanceOfAt(_to, block.number);
323            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
324            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
325 
326            // An event to make the transfer easy to find on the blockchain
327            Transfer(_from, _to, _amount);
328 
329            return true;
330     }
331 
332     /// @param _owner The address that's balance is being requested
333     /// @return The balance of `_owner` at the current block
334     function balanceOf(address _owner) public constant returns (uint256 balance) {
335         return balanceOfAt(_owner, block.number);
336     }
337 
338     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
339     ///  its behalf. This is a modified version of the ERC20 approve function
340     ///  to be a little bit safer
341     /// @param _spender The address of the account able to transfer the tokens
342     /// @param _amount The amount of tokens to be approved for transfer
343     /// @return True if the approval was successful
344     function approve(address _spender, uint256 _amount) public returns (bool success) {
345         require(transfersEnabled);
346 
347         // To change the approve amount you first have to reduce the addresses`
348         //  allowance to zero by calling `approve(_spender,0)` if it is not
349         //  already 0 to mitigate the race condition described here:
350         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
351         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
352 
353         // Alerts the token controller of the approve function call
354         if (isContract(controller)) {
355             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
356         }
357 
358         allowed[msg.sender][_spender] = _amount;
359         Approval(msg.sender, _spender, _amount);
360         return true;
361     }
362 
363     /// @dev This function makes it easy to read the `allowed[]` map
364     /// @param _owner The address of the account that owns the token
365     /// @param _spender The address of the account able to transfer the tokens
366     /// @return Amount of remaining tokens of _owner that _spender is allowed
367     ///  to spend
368     function allowance(address _owner, address _spender
369     ) public constant returns (uint256 remaining) {
370         return allowed[_owner][_spender];
371     }
372 
373     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
374     ///  its behalf, and then a function is triggered in the contract that is
375     ///  being approved, `_spender`. This allows users to use their tokens to
376     ///  interact with contracts in one function call instead of two
377     /// @param _spender The address of the contract able to transfer the tokens
378     /// @param _amount The amount of tokens to be approved for transfer
379     /// @return True if the function call was successful
380     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
381     ) public returns (bool success) {
382         require(approve(_spender, _amount));
383 
384         ApproveAndCallFallBack(_spender).receiveApproval(
385             msg.sender,
386             _amount,
387             this,
388             _extraData
389         );
390 
391         return true;
392     }
393 
394     /// @dev This function makes it easy to get the total number of tokens
395     /// @return The total number of tokens
396     function totalSupply() public constant returns (uint) {
397         return totalSupplyAt(block.number);
398     }
399 
400 
401 ////////////////
402 // Query balance and totalSupply in History
403 ////////////////
404 
405     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
406     /// @param _owner The address from which the balance will be retrieved
407     /// @param _blockNumber The block number when the balance is queried
408     /// @return The balance at `_blockNumber`
409     function balanceOfAt(address _owner, uint _blockNumber) public constant
410         returns (uint) {
411 
412         // These next few lines are used when the balance of the token is
413         //  requested before a check point was ever created for this token, it
414         //  requires that the `parentToken.balanceOfAt` be queried at the
415         //  genesis block for that token as this contains initial balance of
416         //  this token
417         if ((balances[_owner].length == 0)
418             || (balances[_owner][0].fromBlock > _blockNumber)) {
419             if (address(parentToken) != 0) {
420                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
421             } else {
422                 // Has no parent
423                 return 0;
424             }
425 
426         // This will return the expected balance during normal situations
427         } else {
428             return getValueAt(balances[_owner], _blockNumber);
429         }
430     }
431 
432     /// @notice Total amount of tokens at a specific `_blockNumber`.
433     /// @param _blockNumber The block number when the totalSupply is queried
434     /// @return The total amount of tokens at `_blockNumber`
435     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
436 
437         // These next few lines are used when the totalSupply of the token is
438         //  requested before a check point was ever created for this token, it
439         //  requires that the `parentToken.totalSupplyAt` be queried at the
440         //  genesis block for this token as that contains totalSupply of this
441         //  token at this block number.
442         if ((totalSupplyHistory.length == 0)
443             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
444             if (address(parentToken) != 0) {
445                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
446             } else {
447                 return 0;
448             }
449 
450         // This will return the expected totalSupply during normal situations
451         } else {
452             return getValueAt(totalSupplyHistory, _blockNumber);
453         }
454     }
455 
456 ////////////////
457 // Clone Token Method
458 ////////////////
459 
460     /// @notice Creates a new clone token with the initial distribution being
461     ///  this token at `_snapshotBlock`
462     /// @param _cloneTokenName Name of the clone token
463     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
464     /// @param _cloneTokenSymbol Symbol of the clone token
465     /// @param _snapshotBlock Block when the distribution of the parent token is
466     ///  copied to set the initial distribution of the new clone token;
467     ///  if the block is zero than the actual block, the current block is used
468     /// @param _transfersEnabled True if transfers are allowed in the clone
469     /// @return The address of the new MiniMeToken Contract
470     function createCloneToken(
471         string _cloneTokenName,
472         uint8 _cloneDecimalUnits,
473         string _cloneTokenSymbol,
474         uint _snapshotBlock,
475         bool _transfersEnabled
476         ) public returns(address) {
477         if (_snapshotBlock == 0) _snapshotBlock = block.number;
478         MiniMeToken cloneToken = tokenFactory.createCloneToken(
479             this,
480             _snapshotBlock,
481             _cloneTokenName,
482             _cloneDecimalUnits,
483             _cloneTokenSymbol,
484             _transfersEnabled
485             );
486 
487         cloneToken.changeController(msg.sender);
488 
489         // An event to make the token easy to find on the blockchain
490         NewCloneToken(address(cloneToken), _snapshotBlock);
491         return address(cloneToken);
492     }
493 
494 ////////////////
495 // Generate and destroy tokens
496 ////////////////
497 
498     /// @notice Generates `_amount` tokens that are assigned to `_owner`
499     /// @param _owner The address that will be assigned the new tokens
500     /// @param _amount The quantity of tokens generated
501     /// @return True if the tokens are generated correctly
502     function generateTokens(address _owner, uint _amount
503     ) public onlyController returns (bool) {
504         uint curTotalSupply = totalSupply();
505         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
506         uint previousBalanceTo = balanceOf(_owner);
507         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
508         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
509         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
510         Transfer(0, _owner, _amount);
511         return true;
512     }
513 
514 
515     /// @notice Burns `_amount` tokens from `_owner`
516     /// @param _owner The address that will lose the tokens
517     /// @param _amount The quantity of tokens to burn
518     /// @return True if the tokens are burned correctly
519     function destroyTokens(address _owner, uint _amount
520     ) onlyController public returns (bool) {
521         uint curTotalSupply = totalSupply();
522         require(curTotalSupply >= _amount);
523         uint previousBalanceFrom = balanceOf(_owner);
524         require(previousBalanceFrom >= _amount);
525         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
526         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
527         Transfer(_owner, 0, _amount);
528         return true;
529     }
530 
531 ////////////////
532 // Enable tokens transfers
533 ////////////////
534 
535 
536     /// @notice Enables token holders to transfer their tokens freely if true
537     /// @param _transfersEnabled True if transfers are allowed in the clone
538     function enableTransfers(bool _transfersEnabled) public onlyController {
539         transfersEnabled = _transfersEnabled;
540     }
541 
542 ////////////////
543 // Internal helper functions to query and set a value in a snapshot array
544 ////////////////
545 
546     /// @dev `getValueAt` retrieves the number of tokens at a given block number
547     /// @param checkpoints The history of values being queried
548     /// @param _block The block number to retrieve the value at
549     /// @return The number of tokens being queried
550     function getValueAt(Checkpoint[] storage checkpoints, uint _block
551     ) constant internal returns (uint) {
552         if (checkpoints.length == 0) return 0;
553 
554         // Shortcut for the actual value
555         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
556             return checkpoints[checkpoints.length-1].value;
557         if (_block < checkpoints[0].fromBlock) return 0;
558 
559         // Binary search of the value in the array
560         uint min = 0;
561         uint max = checkpoints.length-1;
562         while (max > min) {
563             uint mid = (max + min + 1)/ 2;
564             if (checkpoints[mid].fromBlock<=_block) {
565                 min = mid;
566             } else {
567                 max = mid-1;
568             }
569         }
570         return checkpoints[min].value;
571     }
572 
573     /// @dev `updateValueAtNow` used to update the `balances` map and the
574     ///  `totalSupplyHistory`
575     /// @param checkpoints The history of data being updated
576     /// @param _value The new number of tokens
577     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
578     ) internal  {
579         if ((checkpoints.length == 0)
580         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
581                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
582                newCheckPoint.fromBlock =  uint128(block.number);
583                newCheckPoint.value = uint128(_value);
584            } else {
585                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
586                oldCheckPoint.value = uint128(_value);
587            }
588     }
589 
590     /// @dev Internal function to determine if an address is a contract
591     /// @param _addr The address being queried
592     /// @return True if `_addr` is a contract
593     function isContract(address _addr) constant internal returns(bool) {
594         uint size;
595         if (_addr == 0) return false;
596         assembly {
597             size := extcodesize(_addr)
598         }
599         return size>0;
600     }
601 
602     /// @dev Helper function to return a min betwen the two uints
603     function min(uint a, uint b) pure internal returns (uint) {
604         return a < b ? a : b;
605     }
606 
607     /// @notice The fallback function: If the contract's controller has not been
608     ///  set to 0, then the `proxyPayment` method is called which relays the
609     ///  ether and creates tokens as described in the token controller contract
610     function () public payable {
611         require(isContract(controller));
612         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
613     }
614 
615 //////////
616 // Safety Methods
617 //////////
618 
619     /// @notice This method can be used by the controller to extract mistakenly
620     ///  sent tokens to this contract.
621     /// @param _token The address of the token contract that you want to recover
622     ///  set to 0 in case you want to extract ether.
623     function claimTokens(address _token) public onlyController {
624         if (_token == 0x0) {
625             controller.transfer(this.balance);
626             return;
627         }
628 
629         MiniMeToken token = MiniMeToken(_token);
630         uint balance = token.balanceOf(this);
631         token.transfer(controller, balance);
632         ClaimedTokens(_token, controller, balance);
633     }
634 
635 ////////////////
636 // Events
637 ////////////////
638     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
639     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
640     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
641     event Approval(
642         address indexed _owner,
643         address indexed _spender,
644         uint256 _amount
645         );
646 
647 }
648 
649 
650 ////////////////
651 // MiniMeTokenFactory
652 ////////////////
653 
654 /// @dev This contract is used to generate clone contracts from a contract.
655 ///  In solidity this is the way to create a contract from a contract of the
656 ///  same class
657 contract MiniMeTokenFactory {
658 
659     /// @notice Update the DApp by creating a new token with new functionalities
660     ///  the msg.sender becomes the controller of this clone token
661     /// @param _parentToken Address of the token being cloned
662     /// @param _snapshotBlock Block of the parent token that will
663     ///  determine the initial distribution of the clone token
664     /// @param _tokenName Name of the new token
665     /// @param _decimalUnits Number of decimals of the new token
666     /// @param _tokenSymbol Token Symbol for the new token
667     /// @param _transfersEnabled If true, tokens will be able to be transferred
668     /// @return The address of the new token contract
669     function createCloneToken(
670         address _parentToken,
671         uint _snapshotBlock,
672         string _tokenName,
673         uint8 _decimalUnits,
674         string _tokenSymbol,
675         bool _transfersEnabled
676     ) public returns (MiniMeToken) {
677         MiniMeToken newToken = new MiniMeToken(
678             this,
679             _parentToken,
680             _snapshotBlock,
681             _tokenName,
682             _decimalUnits,
683             _tokenSymbol,
684             _transfersEnabled
685             );
686 
687         newToken.changeController(msg.sender);
688         return newToken;
689     }
690 }
691 
692 contract ATC is MiniMeToken {
693   mapping (address => bool) public blacklisted;
694   bool public generateFinished;
695 
696   // @dev ATC constructor just parametrizes the MiniMeToken constructor
697   function ATC(address _tokenFactory)
698           MiniMeToken(
699               _tokenFactory,
700               0x0,                     // no parent token
701               0,                       // no snapshot block number from parent
702               "ATCon Token",  // Token name
703               18,                      // Decimals
704               "ATC",                   // Symbol
705               false                     // Enable transfers
706           ) {}
707 
708   function generateTokens(address _owner, uint _amount
709       ) public onlyController returns (bool) {
710         require(generateFinished == false);
711 
712         //check msg.sender (controller ??)
713         return super.generateTokens(_owner, _amount);
714       }
715   function doTransfer(address _from, address _to, uint _amount
716       ) internal returns(bool) {
717         require(blacklisted[_from] == false);
718         return super.doTransfer(_from, _to, _amount);
719       }
720 
721   function finishGenerating() public onlyController returns (bool success) {
722     generateFinished = true;
723     return true;
724   }
725 
726   function blacklistAccount(address tokenOwner) public onlyController returns (bool success) {
727     blacklisted[tokenOwner] = true;
728     return true;
729   }
730   function unBlacklistAccount(address tokenOwner) public onlyController returns (bool success) {
731     blacklisted[tokenOwner] = false;
732     return true;
733   }
734 
735 }
736 
737 
738 /**
739  * @title PresaleKYC
740  * @dev PresaleKYC contract handles the white list for ASTPresale contract
741  * Only accounts registered in PresaleKYC contract can buy AST token as Presale.
742  */
743 contract PresaleKYC is Ownable, SafeMath {
744 
745   // check the address is registered for token sale
746   mapping (address => bool) public registeredAddress;
747 
748   // guaranteedlimit for each presale investor
749   mapping (address => uint256) public presaleGuaranteedLimit;
750 
751   event Registered(address indexed _addr, uint256 _amount);
752   event Unregistered(address indexed _addr);
753 
754   /**
755    * @dev check whether the address is registered for token sale or not.
756    * @param _addr address
757    */
758   modifier onlyRegistered(address _addr) {
759     require(registeredAddress[_addr]);
760     _;
761   }
762 
763   /**
764    * @dev register the address for token sale
765    * @param _addr address The address to register for token sale
766    */
767   function register(address _addr, uint256 _maxGuaranteedLimit)
768     public
769     onlyOwner
770   {
771     require(_addr != address(0) && registeredAddress[_addr] == false);
772 
773     registeredAddress[_addr] = true;
774     presaleGuaranteedLimit[_addr] = _maxGuaranteedLimit;
775 
776     Registered(_addr, _maxGuaranteedLimit);
777   }
778 
779   /**
780    * @dev register the addresses for token sale
781    * @param _addrs address[] The addresses to register for token sale
782    */
783   function registerByList(address[] _addrs, uint256[] _maxGuaranteedLimits)
784     public
785     onlyOwner
786   {
787     for(uint256 i = 0; i < _addrs.length; i++) {
788       require(_addrs[i] != address(0) && registeredAddress[_addrs[i]] == false);
789 
790       registeredAddress[_addrs[i]] = true;
791       presaleGuaranteedLimit[_addrs[i]] = _maxGuaranteedLimits[i];
792 
793       Registered(_addrs[i], _maxGuaranteedLimits[i]);
794     }
795   }
796 
797   /**
798    * @dev unregister the registered address
799    * @param _addr address The address to unregister for token sale
800    */
801   function unregister(address _addr)
802     public
803     onlyOwner
804     onlyRegistered(_addr)
805   {
806 
807     registeredAddress[_addr] = false;
808     presaleGuaranteedLimit[_addr] = 0;
809 
810     Unregistered(_addr);
811   }
812 
813   /**
814    * @dev unregister the registered addresses
815    * @param _addrs address[] The addresses to unregister for token sale
816    */
817   function unregisterByList(address[] _addrs)
818     public
819     onlyOwner
820   {
821     for(uint256 i = 0; i < _addrs.length; i++) {
822       require(registeredAddress[_addrs[i]]);
823 
824       registeredAddress[_addrs[i]] = false;
825       presaleGuaranteedLimit[_addrs[i]] = 0;
826 
827       Unregistered(_addrs[i]);
828     }
829 
830   }
831 }
832 
833 
834 /**
835  * @title Pausable
836  * @dev Base contract which allows children to implement an emergency stop mechanism.
837  */
838 contract Pausable is Ownable {
839   event Pause();
840   event Unpause();
841 
842   bool public paused = false;
843 
844 
845   /**
846    * @dev modifier to allow actions only when the contract IS paused
847    */
848   modifier whenNotPaused() {
849     require(!paused);
850     _;
851   }
852 
853   /**
854    * @dev modifier to allow actions only when the contract IS NOT paused
855    */
856   modifier whenPaused() {
857     require(paused);
858     _;
859   }
860 
861   /**
862    * @dev called by the owner to pause, triggers stopped state
863    */
864   function pause() onlyOwner whenNotPaused {
865     paused = true;
866     Pause();
867   }
868 
869   /**
870    * @dev called by the owner to unpause, returns to normal state
871    */
872   function unpause() onlyOwner whenPaused {
873     paused = false;
874     Unpause();
875   }
876 }
877 
878 
879 /**
880  * @title ERC20Basic
881  * @dev Simpler version of ERC20 interface
882  * @dev see https://github.com/ethereum/EIPs/issues/179
883  */
884 contract ERC20Basic {
885   uint256 public totalSupply;
886   function balanceOf(address who) public view returns (uint256);
887   function transfer(address to, uint256 value) public returns (bool);
888   event Transfer(address indexed from, address indexed to, uint256 value);
889 }
890 
891 
892 /**
893  * @title RefundVault
894  * @dev This contract is used for storing funds while a crowdsale
895  * is in progress. Supports refunding the money if crowdsale fails,
896  * and forwarding it if crowdsale is successful.
897  */
898 contract RefundVault is Ownable, SafeMath{
899 
900   enum State { Active, Refunding, Closed }
901 
902   mapping (address => uint256) public deposited;
903   mapping (address => uint256) public refunded;
904   State public state;
905 
906   address[] public reserveWallet;
907 
908   event Closed();
909   event RefundsEnabled();
910   event Refunded(address indexed beneficiary, uint256 weiAmount);
911 
912   /**
913    * @dev This constructor sets the addresses of
914    * 10 reserve wallets.
915    * and forwarding it if crowdsale is successful.
916    * @param _reserveWallet address[5] The addresses of reserve wallet.
917    */
918   function RefundVault(address[] _reserveWallet) {
919     state = State.Active;
920     reserveWallet = _reserveWallet;
921   }
922 
923   /**
924    * @dev This function is called when user buy tokens. Only RefundVault
925    * contract stores the Ether user sent which forwarded from crowdsale
926    * contract.
927    * @param investor address The address who buy the token from crowdsale.
928    */
929   function deposit(address investor) onlyOwner payable {
930     require(state == State.Active);
931     deposited[investor] = add(deposited[investor], msg.value);
932   }
933 
934   event Transferred(address _to, uint _value);
935 
936   /**
937    * @dev This function is called when crowdsale is successfully finalized.
938    */
939   function close() onlyOwner {
940     require(state == State.Active);
941     state = State.Closed;
942 
943     uint256 balance = this.balance;
944 
945     uint256 reserveAmountForEach = div(balance, reserveWallet.length);
946 
947     for(uint8 i = 0; i < reserveWallet.length; i++){
948       reserveWallet[i].transfer(reserveAmountForEach);
949       Transferred(reserveWallet[i], reserveAmountForEach);
950     }
951 
952     Closed();
953   }
954 
955   /**
956    * @dev This function is called when crowdsale is unsuccessfully finalized
957    * and refund is required.
958    */
959   function enableRefunds() onlyOwner {
960     require(state == State.Active);
961     state = State.Refunding;
962     RefundsEnabled();
963   }
964 
965   /**
966    * @dev This function allows for user to refund Ether.
967    */
968   function refund(address investor) returns (bool) {
969     require(state == State.Refunding);
970 
971     if (refunded[investor] > 0) {
972       return false;
973     }
974 
975     uint256 depositedValue = deposited[investor];
976     deposited[investor] = 0;
977     refunded[investor] = depositedValue;
978     investor.transfer(depositedValue);
979     Refunded(investor, depositedValue);
980 
981     return true;
982   }
983 
984 }
985 
986 
987 contract PresaleFallbackReceiver {
988     function presaleFallBack(uint256 _presaleWeiRaised) public returns (bool);
989 }
990 
991 contract ATCPresale is Ownable, PresaleKYC, Pausable {
992   ATC public token;
993   RefundVault public vault;
994 
995   uint256 public rate;
996   uint256 public weiRaised;
997   uint256 public maxEtherCap;
998   uint64 public startTime;
999   uint64 public endTime;
1000 
1001   bool public isFinalized;
1002   mapping (address => uint256) public beneficiaryFunded;
1003 
1004   event PresaleTokenPurchase(address indexed buyer, address indexed beneficiary, uint256 toFund, uint256 tokens);
1005   event ClaimedTokens(address _claimToken, address owner, uint256 balance);
1006 
1007   function ATCPresale(
1008     address _token,
1009     address _vault,
1010     uint64 _startTime,
1011     uint64 _endTime,
1012     uint256 _maxEtherCap,
1013     uint256 _rate
1014     ) {
1015       require(_token != 0x00 && _vault != 0x00);
1016       require(now < _startTime && _startTime < _endTime);
1017       require(_maxEtherCap > 0);
1018       require(_rate > 0);
1019 
1020       token = ATC(_token);
1021       vault = RefundVault(_vault);
1022       startTime = _startTime;
1023       endTime = _endTime;
1024       maxEtherCap = _maxEtherCap;
1025       rate = _rate;
1026     }
1027 
1028   function () payable {
1029     buyPresale(msg.sender);
1030   }
1031 
1032   function buyPresale(address beneficiary)
1033     payable
1034     onlyRegistered(beneficiary)
1035     whenNotPaused
1036   {
1037     // check validity
1038     require(beneficiary != 0x00);
1039     require(validPurchase());
1040 
1041     uint256 weiAmount = msg.value;
1042     uint256 toFund;
1043 
1044     uint256 guaranteedLimit = presaleGuaranteedLimit[beneficiary];
1045     require(guaranteedLimit > 0);
1046 
1047     uint256 totalAmount = add(beneficiaryFunded[beneficiary], weiAmount);
1048     if (totalAmount > guaranteedLimit) {
1049       toFund = sub(guaranteedLimit, beneficiaryFunded[beneficiary]);
1050     } else {
1051       toFund = weiAmount;
1052     }
1053 
1054     uint256 postWeiRaised = add(weiRaised, toFund);
1055     if (postWeiRaised > maxEtherCap) {
1056       toFund = sub(maxEtherCap, weiRaised);
1057     }
1058 
1059     require(toFund > 0);
1060     require(weiAmount >= toFund);
1061 
1062     uint256 tokens = mul(toFund, rate);
1063     uint256 toReturn = sub(weiAmount, toFund);
1064 
1065     weiRaised = add(weiRaised, toFund);
1066     beneficiaryFunded[beneficiary] = add(beneficiaryFunded[beneficiary], toFund);
1067 
1068     //TODO: Error check
1069     token.generateTokens(beneficiary, tokens);
1070 
1071     if (toReturn > 0) {
1072       msg.sender.transfer(toReturn);
1073     }
1074     forwardFunds(toFund);
1075     PresaleTokenPurchase(msg.sender, beneficiary, toFund, tokens);
1076   }
1077 
1078   function validPurchase() internal constant returns (bool) {
1079     bool nonZeroPurchase = msg.value != 0;
1080     bool validTime = now >= startTime && now <= endTime;
1081     return nonZeroPurchase && !maxReached() && validTime;
1082   }
1083 
1084   /**
1085    * @dev Checks whether maxEtherCap is reached
1086    * @return true if max ether cap is reaced
1087    */
1088   function maxReached() public constant returns (bool) {
1089     return weiRaised == maxEtherCap;
1090   }
1091 
1092   function forwardFunds(uint256 toFund) internal {
1093     vault.deposit.value(toFund)(msg.sender);
1094   }
1095 
1096   event Log(string messgae); // for dev
1097 
1098   function finalizePresale(
1099     address newOwner
1100     ) onlyOwner {
1101       require(!isFinalized);
1102       require(now > endTime);
1103 
1104       PresaleFallbackReceiver crowdsale = PresaleFallbackReceiver(newOwner);
1105       require(crowdsale.presaleFallBack(weiRaised));
1106 
1107       changeTokenController(newOwner);
1108       changeVaultOwner(newOwner);
1109 
1110       isFinalized = true;
1111   }
1112   function changeTokenController(address newOwner) onlyOwner internal {
1113     token.changeController(newOwner);
1114   }
1115   function changeVaultOwner(address newOwner) onlyOwner internal {
1116     vault.transferOwnership(newOwner);
1117   }
1118 
1119   function claimTokens(address _claimToken) public onlyOwner {
1120 
1121     if (token.controller() == address(this)) {
1122          token.claimTokens(_claimToken);
1123     }
1124 
1125     if (_claimToken == 0x0) {
1126         owner.transfer(this.balance);
1127         return;
1128     }
1129 
1130     ERC20Basic claimToken = ERC20Basic(_claimToken);
1131     uint256 balance = claimToken.balanceOf(this);
1132     claimToken.transfer(owner, balance);
1133 
1134     ClaimedTokens(_claimToken, owner, balance);
1135   }
1136 }