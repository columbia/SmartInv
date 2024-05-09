1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   uint256 public totalSupply;
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: contracts/ExchangerI.sol
18 
19 contract ExchangerI {
20   ERC20Basic public wpr;
21 
22   /// @notice This method should be called by the WCT holders to collect their
23   ///  corresponding WPRs
24   function collect(address caller) public;
25 }
26 
27 // File: contracts/MiniMeToken.sol
28 
29 /*
30     Copyright 2016, Jordi Baylina
31 
32     This program is free software: you can redistribute it and/or modify
33     it under the terms of the GNU General Public License as published by
34     the Free Software Foundation, either version 3 of the License, or
35     (at your option) any later version.
36 
37     This program is distributed in the hope that it will be useful,
38     but WITHOUT ANY WARRANTY; without even the implied warranty of
39     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
40     GNU General Public License for more details.
41 
42     You should have received a copy of the GNU General Public License
43     along with this program.  If not, see <http://www.gnu.org/licenses/>.
44  */
45 
46 /// @title MiniMeToken Contract
47 /// @author Jordi Baylina
48 /// @dev This token contract's goal is to make it easy for anyone to clone this
49 ///  token using the token distribution at a given block, this will allow DAO's
50 ///  and DApps to upgrade their features in a decentralized manner without
51 ///  affecting the original token
52 /// @dev It is ERC20 compliant, but still needs to under go further testing.
53 
54 
55 /// @dev The token controller contract must implement these functions
56 contract TokenController {
57     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
58     /// @param _owner The address that sent the ether to create tokens
59     /// @return True if the ether is accepted, false if it throws
60     function proxyPayment(address _owner) payable returns(bool);
61 
62     /// @notice Notifies the controller about a token transfer allowing the
63     ///  controller to react if desired
64     /// @param _from The origin of the transfer
65     /// @param _to The destination of the transfer
66     /// @param _amount The amount of the transfer
67     /// @return False if the controller does not authorize the transfer
68     function onTransfer(address _from, address _to, uint _amount) returns(bool);
69 
70     /// @notice Notifies the controller about an approval allowing the
71     ///  controller to react if desired
72     /// @param _owner The address that calls `approve()`
73     /// @param _spender The spender in the `approve()` call
74     /// @param _amount The amount in the `approve()` call
75     /// @return False if the controller does not authorize the approval
76     function onApprove(address _owner, address _spender, uint _amount)
77         returns(bool);
78 }
79 
80 contract Controlled {
81     /// @notice The address of the controller is the only address that can call
82     ///  a function with this modifier
83     modifier onlyController { require(msg.sender == controller); _; }
84 
85     address public controller;
86 
87     function Controlled() { controller = msg.sender;}
88 
89     /// @notice Changes the controller of the contract
90     /// @param _newController The new controller of the contract
91     function changeController(address _newController) onlyController {
92         controller = _newController;
93     }
94 }
95 
96 contract ApproveAndCallFallBack {
97     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
98 }
99 
100 /// @dev The actual token contract, the default controller is the msg.sender
101 ///  that deploys the contract, so usually this token will be deployed by a
102 ///  token controller contract, which Giveth will call a "Campaign"
103 contract MiniMeToken is Controlled {
104 
105     string public name;                //The Token's name: e.g. DigixDAO Tokens
106     uint8 public decimals;             //Number of decimals of the smallest unit
107     string public symbol;              //An identifier: e.g. REP
108     string public version = 'MMT_0.1'; //An arbitrary versioning scheme
109 
110 
111     /// @dev `Checkpoint` is the structure that attaches a block number to a
112     ///  given value, the block number attached is the one that last changed the
113     ///  value
114     struct  Checkpoint {
115 
116         // `fromBlock` is the block number that the value was generated from
117         uint128 fromBlock;
118 
119         // `value` is the amount of tokens at a specific block number
120         uint128 value;
121     }
122 
123     // `parentToken` is the Token address that was cloned to produce this token;
124     //  it will be 0x0 for a token that was not cloned
125     MiniMeToken public parentToken;
126 
127     // `parentSnapShotBlock` is the block number from the Parent Token that was
128     //  used to determine the initial distribution of the Clone Token
129     uint public parentSnapShotBlock;
130 
131     // `creationBlock` is the block number that the Clone Token was created
132     uint public creationBlock;
133 
134     // `balances` is the map that tracks the balance of each address, in this
135     //  contract when the balance changes the block number that the change
136     //  occurred is also included in the map
137     mapping (address => Checkpoint[]) balances;
138 
139     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
140     mapping (address => mapping (address => uint256)) allowed;
141 
142     // Tracks the history of the `totalSupply` of the token
143     Checkpoint[] totalSupplyHistory;
144 
145     // Flag that determines if the token is transferable or not.
146     bool public transfersEnabled;
147 
148     // The factory used to create new clone tokens
149     MiniMeTokenFactory public tokenFactory;
150 
151 ////////////////
152 // Constructor
153 ////////////////
154 
155     /// @notice Constructor to create a MiniMeToken
156     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
157     ///  will create the Clone token contracts, the token factory needs to be
158     ///  deployed first
159     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
160     ///  new token
161     /// @param _parentSnapShotBlock Block of the parent token that will
162     ///  determine the initial distribution of the clone token, set to 0 if it
163     ///  is a new token
164     /// @param _tokenName Name of the new token
165     /// @param _decimalUnits Number of decimals of the new token
166     /// @param _tokenSymbol Token Symbol for the new token
167     /// @param _transfersEnabled If true, tokens will be able to be transferred
168     function MiniMeToken(
169         address _tokenFactory,
170         address _parentToken,
171         uint _parentSnapShotBlock,
172         string _tokenName,
173         uint8 _decimalUnits,
174         string _tokenSymbol,
175         bool _transfersEnabled
176     ) {
177         tokenFactory = MiniMeTokenFactory(_tokenFactory);
178         name = _tokenName;                                 // Set the name
179         decimals = _decimalUnits;                          // Set the decimals
180         symbol = _tokenSymbol;                             // Set the symbol
181         parentToken = MiniMeToken(_parentToken);
182         parentSnapShotBlock = _parentSnapShotBlock;
183         transfersEnabled = _transfersEnabled;
184         creationBlock = block.number;
185     }
186 
187 
188 ///////////////////
189 // ERC20 Methods
190 ///////////////////
191 
192     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
193     /// @param _to The address of the recipient
194     /// @param _amount The amount of tokens to be transferred
195     /// @return Whether the transfer was successful or not
196     function transfer(address _to, uint256 _amount) returns (bool success) {
197         require(transfersEnabled);
198         return doTransfer(msg.sender, _to, _amount);
199     }
200 
201     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
202     ///  is approved by `_from`
203     /// @param _from The address holding the tokens being transferred
204     /// @param _to The address of the recipient
205     /// @param _amount The amount of tokens to be transferred
206     /// @return True if the transfer was successful
207     function transferFrom(address _from, address _to, uint256 _amount
208     ) returns (bool success) {
209 
210         // The controller of this contract can move tokens around at will,
211 
212         //  controller of this contract, which in most situations should be
213         //  another open source smart contract or 0x0
214         if (msg.sender != controller) {
215             require(transfersEnabled);
216 
217             // The standard ERC 20 transferFrom functionality
218             if (allowed[_from][msg.sender] < _amount) return false;
219             allowed[_from][msg.sender] -= _amount;
220         }
221         return doTransfer(_from, _to, _amount);
222     }
223 
224     /// @dev This is the actual transfer function in the token contract, it can
225     ///  only be called by other functions in this contract.
226     /// @param _from The address holding the tokens being transferred
227     /// @param _to The address of the recipient
228     /// @param _amount The amount of tokens to be transferred
229     /// @return True if the transfer was successful
230     function doTransfer(address _from, address _to, uint _amount
231     ) internal returns(bool) {
232 
233            if (_amount == 0) {
234                return true;
235            }
236 
237            require(parentSnapShotBlock < block.number);
238 
239            // Do not allow transfer to 0x0 or the token contract itself
240            require((_to != 0) && (_to != address(this)));
241 
242            // If the amount being transfered is more than the balance of the
243            //  account the transfer returns false
244            var previousBalanceFrom = balanceOfAt(_from, block.number);
245            if (previousBalanceFrom < _amount) {
246                return false;
247            }
248 
249            // Alerts the token controller of the transfer
250            if (isContract(controller)) {
251                require(TokenController(controller).onTransfer(_from, _to, _amount));
252            }
253 
254            // First update the balance array with the new value for the address
255            //  sending the tokens
256            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
257 
258            // Then update the balance array with the new value for the address
259            //  receiving the tokens
260            var previousBalanceTo = balanceOfAt(_to, block.number);
261            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
262            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
263 
264            // An event to make the transfer easy to find on the blockchain
265            Transfer(_from, _to, _amount);
266 
267            return true;
268     }
269 
270     /// @param _owner The address that's balance is being requested
271     /// @return The balance of `_owner` at the current block
272     function balanceOf(address _owner) constant returns (uint256 balance) {
273         return balanceOfAt(_owner, block.number);
274     }
275 
276     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
277     ///  its behalf. This is a modified version of the ERC20 approve function
278     ///  to be a little bit safer
279     /// @param _spender The address of the account able to transfer the tokens
280     /// @param _amount The amount of tokens to be approved for transfer
281     /// @return True if the approval was successful
282     function approve(address _spender, uint256 _amount) returns (bool success) {
283         require(transfersEnabled);
284 
285         // To change the approve amount you first have to reduce the addresses`
286         //  allowance to zero by calling `approve(_spender,0)` if it is not
287         //  already 0 to mitigate the race condition described here:
288         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
289         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
290 
291         // Alerts the token controller of the approve function call
292         if (isContract(controller)) {
293             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
294         }
295 
296         allowed[msg.sender][_spender] = _amount;
297         Approval(msg.sender, _spender, _amount);
298         return true;
299     }
300 
301     /// @dev This function makes it easy to read the `allowed[]` map
302     /// @param _owner The address of the account that owns the token
303     /// @param _spender The address of the account able to transfer the tokens
304     /// @return Amount of remaining tokens of _owner that _spender is allowed
305     ///  to spend
306     function allowance(address _owner, address _spender
307     ) constant returns (uint256 remaining) {
308         return allowed[_owner][_spender];
309     }
310 
311     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
312     ///  its behalf, and then a function is triggered in the contract that is
313     ///  being approved, `_spender`. This allows users to use their tokens to
314     ///  interact with contracts in one function call instead of two
315     /// @param _spender The address of the contract able to transfer the tokens
316     /// @param _amount The amount of tokens to be approved for transfer
317     /// @return True if the function call was successful
318     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
319     ) returns (bool success) {
320         require(approve(_spender, _amount));
321 
322         ApproveAndCallFallBack(_spender).receiveApproval(
323             msg.sender,
324             _amount,
325             this,
326             _extraData
327         );
328 
329         return true;
330     }
331 
332     /// @dev This function makes it easy to get the total number of tokens
333     /// @return The total number of tokens
334     function totalSupply() constant returns (uint) {
335         return totalSupplyAt(block.number);
336     }
337 
338 
339 ////////////////
340 // Query balance and totalSupply in History
341 ////////////////
342 
343     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
344     /// @param _owner The address from which the balance will be retrieved
345     /// @param _blockNumber The block number when the balance is queried
346     /// @return The balance at `_blockNumber`
347     function balanceOfAt(address _owner, uint _blockNumber) constant
348         returns (uint) {
349 
350         // These next few lines are used when the balance of the token is
351         //  requested before a check point was ever created for this token, it
352         //  requires that the `parentToken.balanceOfAt` be queried at the
353         //  genesis block for that token as this contains initial balance of
354         //  this token
355         if ((balances[_owner].length == 0)
356             || (balances[_owner][0].fromBlock > _blockNumber)) {
357             if (address(parentToken) != 0) {
358                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
359             } else {
360                 // Has no parent
361                 return 0;
362             }
363 
364         // This will return the expected balance during normal situations
365         } else {
366             return getValueAt(balances[_owner], _blockNumber);
367         }
368     }
369 
370     /// @notice Total amount of tokens at a specific `_blockNumber`.
371     /// @param _blockNumber The block number when the totalSupply is queried
372     /// @return The total amount of tokens at `_blockNumber`
373     function totalSupplyAt(uint _blockNumber) constant returns(uint) {
374 
375         // These next few lines are used when the totalSupply of the token is
376         //  requested before a check point was ever created for this token, it
377         //  requires that the `parentToken.totalSupplyAt` be queried at the
378         //  genesis block for this token as that contains totalSupply of this
379         //  token at this block number.
380         if ((totalSupplyHistory.length == 0)
381             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
382             if (address(parentToken) != 0) {
383                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
384             } else {
385                 return 0;
386             }
387 
388         // This will return the expected totalSupply during normal situations
389         } else {
390             return getValueAt(totalSupplyHistory, _blockNumber);
391         }
392     }
393 
394 ////////////////
395 // Clone Token Method
396 ////////////////
397 
398     /// @notice Creates a new clone token with the initial distribution being
399     ///  this token at `_snapshotBlock`
400     /// @param _cloneTokenName Name of the clone token
401     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
402     /// @param _cloneTokenSymbol Symbol of the clone token
403     /// @param _snapshotBlock Block when the distribution of the parent token is
404     ///  copied to set the initial distribution of the new clone token;
405     ///  if the block is zero than the actual block, the current block is used
406     /// @param _transfersEnabled True if transfers are allowed in the clone
407     /// @return The address of the new MiniMeToken Contract
408     function createCloneToken(
409         string _cloneTokenName,
410         uint8 _cloneDecimalUnits,
411         string _cloneTokenSymbol,
412         uint _snapshotBlock,
413         bool _transfersEnabled
414         ) returns(address) {
415         if (_snapshotBlock == 0) _snapshotBlock = block.number;
416         MiniMeToken cloneToken = tokenFactory.createCloneToken(
417             this,
418             _snapshotBlock,
419             _cloneTokenName,
420             _cloneDecimalUnits,
421             _cloneTokenSymbol,
422             _transfersEnabled
423             );
424 
425         cloneToken.changeController(msg.sender);
426 
427         // An event to make the token easy to find on the blockchain
428         NewCloneToken(address(cloneToken), _snapshotBlock);
429         return address(cloneToken);
430     }
431 
432 ////////////////
433 // Generate and destroy tokens
434 ////////////////
435 
436     /// @notice Generates `_amount` tokens that are assigned to `_owner`
437     /// @param _owner The address that will be assigned the new tokens
438     /// @param _amount The quantity of tokens generated
439     /// @return True if the tokens are generated correctly
440     function generateTokens(address _owner, uint _amount
441     ) onlyController returns (bool) {
442         uint curTotalSupply = totalSupply();
443         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
444         uint previousBalanceTo = balanceOf(_owner);
445         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
446         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
447         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
448         Transfer(0, _owner, _amount);
449         return true;
450     }
451 
452 
453     /// @notice Burns `_amount` tokens from `_owner`
454     /// @param _owner The address that will lose the tokens
455     /// @param _amount The quantity of tokens to burn
456     /// @return True if the tokens are burned correctly
457     function destroyTokens(address _owner, uint _amount
458     ) onlyController returns (bool) {
459         uint curTotalSupply = totalSupply();
460         require(curTotalSupply >= _amount);
461         uint previousBalanceFrom = balanceOf(_owner);
462         require(previousBalanceFrom >= _amount);
463         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
464         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
465         Transfer(_owner, 0, _amount);
466         return true;
467     }
468 
469 ////////////////
470 // Enable tokens transfers
471 ////////////////
472 
473 
474     /// @notice Enables token holders to transfer their tokens freely if true
475     /// @param _transfersEnabled True if transfers are allowed in the clone
476     function enableTransfers(bool _transfersEnabled) onlyController {
477         transfersEnabled = _transfersEnabled;
478     }
479 
480 ////////////////
481 // Internal helper functions to query and set a value in a snapshot array
482 ////////////////
483 
484     /// @dev `getValueAt` retrieves the number of tokens at a given block number
485     /// @param checkpoints The history of values being queried
486     /// @param _block The block number to retrieve the value at
487     /// @return The number of tokens being queried
488     function getValueAt(Checkpoint[] storage checkpoints, uint _block
489     ) constant internal returns (uint) {
490         if (checkpoints.length == 0) return 0;
491 
492         // Shortcut for the actual value
493         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
494             return checkpoints[checkpoints.length-1].value;
495         if (_block < checkpoints[0].fromBlock) return 0;
496 
497         // Binary search of the value in the array
498         uint min = 0;
499         uint max = checkpoints.length-1;
500         while (max > min) {
501             uint mid = (max + min + 1)/ 2;
502             if (checkpoints[mid].fromBlock<=_block) {
503                 min = mid;
504             } else {
505                 max = mid-1;
506             }
507         }
508         return checkpoints[min].value;
509     }
510 
511     /// @dev `updateValueAtNow` used to update the `balances` map and the
512     ///  `totalSupplyHistory`
513     /// @param checkpoints The history of data being updated
514     /// @param _value The new number of tokens
515     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
516     ) internal  {
517         if ((checkpoints.length == 0)
518         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
519                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
520                newCheckPoint.fromBlock =  uint128(block.number);
521                newCheckPoint.value = uint128(_value);
522            } else {
523                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
524                oldCheckPoint.value = uint128(_value);
525            }
526     }
527 
528     /// @dev Internal function to determine if an address is a contract
529     /// @param _addr The address being queried
530     /// @return True if `_addr` is a contract
531     function isContract(address _addr) constant internal returns(bool) {
532         uint size;
533         if (_addr == 0) return false;
534         assembly {
535             size := extcodesize(_addr)
536         }
537         return size>0;
538     }
539 
540     /// @dev Helper function to return a min betwen the two uints
541     function min(uint a, uint b) internal returns (uint) {
542         return a < b ? a : b;
543     }
544 
545     /// @notice The fallback function: If the contract's controller has not been
546     ///  set to 0, then the `proxyPayment` method is called which relays the
547     ///  ether and creates tokens as described in the token controller contract
548     function ()  payable {
549         require(isContract(controller));
550         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
551     }
552 
553 //////////
554 // Safety Methods
555 //////////
556 
557     /// @notice This method can be used by the controller to extract mistakenly
558     ///  sent tokens to this contract.
559     /// @param _token The address of the token contract that you want to recover
560     ///  set to 0 in case you want to extract ether.
561     function claimTokens(address _token) onlyController {
562         if (_token == 0x0) {
563             controller.transfer(this.balance);
564             return;
565         }
566 
567         MiniMeToken token = MiniMeToken(_token);
568         uint balance = token.balanceOf(this);
569         token.transfer(controller, balance);
570         ClaimedTokens(_token, controller, balance);
571     }
572 
573 ////////////////
574 // Events
575 ////////////////
576     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
577     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
578     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
579     event Approval(
580         address indexed _owner,
581         address indexed _spender,
582         uint256 _amount
583         );
584 
585 }
586 
587 
588 ////////////////
589 // MiniMeTokenFactory
590 ////////////////
591 
592 /// @dev This contract is used to generate clone contracts from a contract.
593 ///  In solidity this is the way to create a contract from a contract of the
594 ///  same class
595 contract MiniMeTokenFactory {
596 
597     /// @notice Update the DApp by creating a new token with new functionalities
598     ///  the msg.sender becomes the controller of this clone token
599     /// @param _parentToken Address of the token being cloned
600     /// @param _snapshotBlock Block of the parent token that will
601     ///  determine the initial distribution of the clone token
602     /// @param _tokenName Name of the new token
603     /// @param _decimalUnits Number of decimals of the new token
604     /// @param _tokenSymbol Token Symbol for the new token
605     /// @param _transfersEnabled If true, tokens will be able to be transferred
606     /// @return The address of the new token contract
607     function createCloneToken(
608         address _parentToken,
609         uint _snapshotBlock,
610         string _tokenName,
611         uint8 _decimalUnits,
612         string _tokenSymbol,
613         bool _transfersEnabled
614     ) returns (MiniMeToken) {
615         MiniMeToken newToken = new MiniMeToken(
616             this,
617             _parentToken,
618             _snapshotBlock,
619             _tokenName,
620             _decimalUnits,
621             _tokenSymbol,
622             _transfersEnabled
623             );
624 
625         newToken.changeController(msg.sender);
626         return newToken;
627     }
628 }
629 
630 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
631 
632 /**
633  * @title Ownable
634  * @dev The Ownable contract has an owner address, and provides basic authorization control
635  * functions, this simplifies the implementation of "user permissions".
636  */
637 contract Ownable {
638   address public owner;
639 
640 
641   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
642 
643 
644   /**
645    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
646    * account.
647    */
648   function Ownable() public {
649     owner = msg.sender;
650   }
651 
652 
653   /**
654    * @dev Throws if called by any account other than the owner.
655    */
656   modifier onlyOwner() {
657     require(msg.sender == owner);
658     _;
659   }
660 
661 
662   /**
663    * @dev Allows the current owner to transfer control of the contract to a newOwner.
664    * @param newOwner The address to transfer ownership to.
665    */
666   function transferOwnership(address newOwner) public onlyOwner {
667     require(newOwner != address(0));
668     OwnershipTransferred(owner, newOwner);
669     owner = newOwner;
670   }
671 
672 }
673 
674 // File: zeppelin-solidity/contracts/math/SafeMath.sol
675 
676 /**
677  * @title SafeMath
678  * @dev Math operations with safety checks that throw on error
679  */
680 library SafeMath {
681   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
682     if (a == 0) {
683       return 0;
684     }
685     uint256 c = a * b;
686     assert(c / a == b);
687     return c;
688   }
689 
690   function div(uint256 a, uint256 b) internal pure returns (uint256) {
691     // assert(b > 0); // Solidity automatically throws when dividing by 0
692     uint256 c = a / b;
693     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
694     return c;
695   }
696 
697   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
698     assert(b <= a);
699     return a - b;
700   }
701 
702   function add(uint256 a, uint256 b) internal pure returns (uint256) {
703     uint256 c = a + b;
704     assert(c >= a);
705     return c;
706   }
707 }
708 
709 // File: zeppelin-solidity/contracts/token/BasicToken.sol
710 
711 /**
712  * @title Basic token
713  * @dev Basic version of StandardToken, with no allowances.
714  */
715 contract BasicToken is ERC20Basic {
716   using SafeMath for uint256;
717 
718   mapping(address => uint256) balances;
719 
720   /**
721   * @dev transfer token for a specified address
722   * @param _to The address to transfer to.
723   * @param _value The amount to be transferred.
724   */
725   function transfer(address _to, uint256 _value) public returns (bool) {
726     require(_to != address(0));
727     require(_value <= balances[msg.sender]);
728 
729     // SafeMath.sub will throw if there is not enough balance.
730     balances[msg.sender] = balances[msg.sender].sub(_value);
731     balances[_to] = balances[_to].add(_value);
732     Transfer(msg.sender, _to, _value);
733     return true;
734   }
735 
736   /**
737   * @dev Gets the balance of the specified address.
738   * @param _owner The address to query the the balance of.
739   * @return An uint256 representing the amount owned by the passed address.
740   */
741   function balanceOf(address _owner) public view returns (uint256 balance) {
742     return balances[_owner];
743   }
744 
745 }
746 
747 // File: zeppelin-solidity/contracts/token/ERC20.sol
748 
749 /**
750  * @title ERC20 interface
751  * @dev see https://github.com/ethereum/EIPs/issues/20
752  */
753 contract ERC20 is ERC20Basic {
754   function allowance(address owner, address spender) public view returns (uint256);
755   function transferFrom(address from, address to, uint256 value) public returns (bool);
756   function approve(address spender, uint256 value) public returns (bool);
757   event Approval(address indexed owner, address indexed spender, uint256 value);
758 }
759 
760 // File: zeppelin-solidity/contracts/token/StandardToken.sol
761 
762 /**
763  * @title Standard ERC20 token
764  *
765  * @dev Implementation of the basic standard token.
766  * @dev https://github.com/ethereum/EIPs/issues/20
767  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
768  */
769 contract StandardToken is ERC20, BasicToken {
770 
771   mapping (address => mapping (address => uint256)) internal allowed;
772 
773 
774   /**
775    * @dev Transfer tokens from one address to another
776    * @param _from address The address which you want to send tokens from
777    * @param _to address The address which you want to transfer to
778    * @param _value uint256 the amount of tokens to be transferred
779    */
780   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
781     require(_to != address(0));
782     require(_value <= balances[_from]);
783     require(_value <= allowed[_from][msg.sender]);
784 
785     balances[_from] = balances[_from].sub(_value);
786     balances[_to] = balances[_to].add(_value);
787     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
788     Transfer(_from, _to, _value);
789     return true;
790   }
791 
792   /**
793    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
794    *
795    * Beware that changing an allowance with this method brings the risk that someone may use both the old
796    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
797    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
798    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
799    * @param _spender The address which will spend the funds.
800    * @param _value The amount of tokens to be spent.
801    */
802   function approve(address _spender, uint256 _value) public returns (bool) {
803     allowed[msg.sender][_spender] = _value;
804     Approval(msg.sender, _spender, _value);
805     return true;
806   }
807 
808   /**
809    * @dev Function to check the amount of tokens that an owner allowed to a spender.
810    * @param _owner address The address which owns the funds.
811    * @param _spender address The address which will spend the funds.
812    * @return A uint256 specifying the amount of tokens still available for the spender.
813    */
814   function allowance(address _owner, address _spender) public view returns (uint256) {
815     return allowed[_owner][_spender];
816   }
817 
818   /**
819    * @dev Increase the amount of tokens that an owner allowed to a spender.
820    *
821    * approve should be called when allowed[_spender] == 0. To increment
822    * allowed value is better to use this function to avoid 2 calls (and wait until
823    * the first transaction is mined)
824    * From MonolithDAO Token.sol
825    * @param _spender The address which will spend the funds.
826    * @param _addedValue The amount of tokens to increase the allowance by.
827    */
828   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
829     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
830     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
831     return true;
832   }
833 
834   /**
835    * @dev Decrease the amount of tokens that an owner allowed to a spender.
836    *
837    * approve should be called when allowed[_spender] == 0. To decrement
838    * allowed value is better to use this function to avoid 2 calls (and wait until
839    * the first transaction is mined)
840    * From MonolithDAO Token.sol
841    * @param _spender The address which will spend the funds.
842    * @param _subtractedValue The amount of tokens to decrease the allowance by.
843    */
844   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
845     uint oldValue = allowed[msg.sender][_spender];
846     if (_subtractedValue > oldValue) {
847       allowed[msg.sender][_spender] = 0;
848     } else {
849       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
850     }
851     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
852     return true;
853   }
854 
855 }
856 
857 // File: zeppelin-solidity/contracts/token/MintableToken.sol
858 
859 /**
860  * @title Mintable token
861  * @dev Simple ERC20 Token example, with mintable token creation
862  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
863  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
864  */
865 
866 contract MintableToken is StandardToken, Ownable {
867   event Mint(address indexed to, uint256 amount);
868   event MintFinished();
869 
870   bool public mintingFinished = false;
871 
872 
873   modifier canMint() {
874     require(!mintingFinished);
875     _;
876   }
877 
878   /**
879    * @dev Function to mint tokens
880    * @param _to The address that will receive the minted tokens.
881    * @param _amount The amount of tokens to mint.
882    * @return A boolean that indicates if the operation was successful.
883    */
884   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
885     totalSupply = totalSupply.add(_amount);
886     balances[_to] = balances[_to].add(_amount);
887     Mint(_to, _amount);
888     Transfer(address(0), _to, _amount);
889     return true;
890   }
891 
892   /**
893    * @dev Function to stop minting new tokens.
894    * @return True if the operation was successful.
895    */
896   function finishMinting() onlyOwner canMint public returns (bool) {
897     mintingFinished = true;
898     MintFinished();
899     return true;
900   }
901 }
902 
903 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
904 
905 /**
906  * @title Pausable
907  * @dev Base contract which allows children to implement an emergency stop mechanism.
908  */
909 contract Pausable is Ownable {
910   event Pause();
911   event Unpause();
912 
913   bool public paused = false;
914 
915 
916   /**
917    * @dev Modifier to make a function callable only when the contract is not paused.
918    */
919   modifier whenNotPaused() {
920     require(!paused);
921     _;
922   }
923 
924   /**
925    * @dev Modifier to make a function callable only when the contract is paused.
926    */
927   modifier whenPaused() {
928     require(paused);
929     _;
930   }
931 
932   /**
933    * @dev called by the owner to pause, triggers stopped state
934    */
935   function pause() onlyOwner whenNotPaused public {
936     paused = true;
937     Pause();
938   }
939 
940   /**
941    * @dev called by the owner to unpause, returns to normal state
942    */
943   function unpause() onlyOwner whenPaused public {
944     paused = false;
945     Unpause();
946   }
947 }
948 
949 // File: zeppelin-solidity/contracts/token/PausableToken.sol
950 
951 /**
952  * @title Pausable token
953  *
954  * @dev StandardToken modified with pausable transfers.
955  **/
956 
957 contract PausableToken is StandardToken, Pausable {
958 
959   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
960     return super.transfer(_to, _value);
961   }
962 
963   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
964     return super.transferFrom(_from, _to, _value);
965   }
966 
967   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
968     return super.approve(_spender, _value);
969   }
970 
971   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
972     return super.increaseApproval(_spender, _addedValue);
973   }
974 
975   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
976     return super.decreaseApproval(_spender, _subtractedValue);
977   }
978 }
979 
980 // File: contracts/WPR.sol
981 
982 /**
983  * @title WePower Contribution Token
984  */
985 contract WPR is MintableToken, PausableToken {
986   string constant public name = "WePower Token";
987   string constant public symbol = "WPR";
988   uint constant public decimals = 18;
989 
990   function WPR() {
991   }
992 
993   //////////
994   // Safety Methods
995   //////////
996 
997   /// @notice This method can be used by the controller to extract mistakenly
998   ///  sent tokens to this contract.
999   /// @param _token The address of the token contract that you want to recover
1000   ///  set to 0 in case you want to extract ether.
1001   function claimTokens(address _token) public onlyOwner {
1002     if (_token == 0x0) {
1003       owner.transfer(this.balance);
1004       return;
1005     }
1006 
1007     ERC20 token = ERC20(_token);
1008     uint balance = token.balanceOf(this);
1009     token.transfer(owner, balance);
1010     ClaimedTokens(_token, owner, balance);
1011   }
1012 
1013   event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
1014 
1015   function disown() public onlyOwner {
1016     OwnershipTransferred(owner, address(0));
1017     owner = address(0);
1018   }
1019 }
1020 
1021 // File: contracts/Contribution.sol
1022 
1023 contract Contribution is Ownable {
1024   using SafeMath for uint256;
1025 
1026   WPR public wpr;
1027   address public contributionWallet;
1028   address public teamHolder;
1029   address public communityHolder;
1030   address public futureHolder;
1031   address public exchanger;
1032 
1033   // Wings Integration
1034   uint256 public totalCollected;
1035 
1036   uint256 public totalWeiCap;             // Total Wei to be collected
1037   uint256 public totalWeiCollected;       // How much Wei has been collected
1038   uint256 public presaleTokensIssued;
1039 
1040   uint256 public minimumPerTransaction = 0.01 ether;
1041 
1042   uint256 public numWhitelistedInvestors;
1043   mapping (address => bool) public canPurchase;
1044   mapping (address => uint256) public individualWeiCollected;
1045 
1046   uint256 public startTime;
1047   uint256 public endTime;
1048 
1049   uint256 public initializedTime;
1050   uint256 public finalizedTime;
1051 
1052   uint256 public initializedBlock;
1053   uint256 public finalizedBlock;
1054 
1055   bool public paused;
1056 
1057   modifier initialized() {
1058     require(initializedBlock != 0);
1059     _;
1060   }
1061 
1062   modifier contributionOpen() {
1063     require(getBlockTimestamp() >= startTime &&
1064            getBlockTimestamp() <= endTime &&
1065            finalizedTime == 0);
1066     _;
1067   }
1068 
1069   modifier notPaused() {
1070     require(!paused);
1071     _;
1072   }
1073 
1074   function Contribution(address _wpr) {
1075     require(_wpr != 0x0);
1076     wpr = WPR(_wpr);
1077   }
1078 
1079   function initialize(
1080       address _wct1,
1081       address _wct2,
1082       address _exchanger,
1083       address _contributionWallet,
1084       address _futureHolder,
1085       address _teamHolder,
1086       address _communityHolder,
1087       uint256 _totalWeiCap,
1088       uint256 _startTime,
1089       uint256 _endTime
1090   ) public onlyOwner {
1091     // Initialize only once
1092     require(initializedBlock == 0);
1093     require(initializedTime == 0);
1094     assert(wpr.totalSupply() == 0);
1095     assert(wpr.owner() == address(this));
1096     assert(wpr.decimals() == 18);  // Same amount of decimals as ETH
1097     wpr.pause();
1098 
1099     require(_contributionWallet != 0x0);
1100     contributionWallet = _contributionWallet;
1101 
1102     require(_futureHolder != 0x0);
1103     futureHolder = _futureHolder;
1104 
1105     require(_teamHolder != 0x0);
1106     teamHolder = _teamHolder;
1107 
1108     require(_communityHolder != 0x0);
1109     communityHolder = _communityHolder;
1110 
1111     require(_startTime >= getBlockTimestamp());
1112     require(_startTime < _endTime);
1113     startTime = _startTime;
1114     endTime = _endTime;
1115 
1116     require(_totalWeiCap > 0);
1117     totalWeiCap = _totalWeiCap;
1118 
1119     initializedBlock = getBlockNumber();
1120     initializedTime = getBlockTimestamp();
1121 
1122     require(_wct1 != 0x0);
1123     require(_wct2 != 0x0);
1124     require(_exchanger != 0x0);
1125 
1126     presaleTokensIssued = MiniMeToken(_wct1).totalSupplyAt(initializedBlock);
1127     presaleTokensIssued = presaleTokensIssued.add(
1128       MiniMeToken(_wct2).totalSupplyAt(initializedBlock)
1129     );
1130 
1131     // Exchange rate from wct to wpr 10000
1132     require(wpr.mint(_exchanger, presaleTokensIssued.mul(10000)));
1133     exchanger = _exchanger;
1134 
1135     Initialized(initializedBlock);
1136   }
1137 
1138   /// @notice interface for founders to blacklist investors
1139   /// @param _investors array of investors
1140   function blacklistAddresses(address[] _investors) public onlyOwner {
1141     for (uint256 i = 0; i < _investors.length; i++) {
1142       blacklist(_investors[i]);
1143     }
1144   }
1145 
1146   /// @notice Notifies if an investor is whitelisted for contribution
1147   /// @param _investor investor address
1148   /// @return status
1149   function isWhitelisted(address _investor) public onlyOwner constant returns(bool) {
1150     return canPurchase[_investor];
1151   }
1152 
1153   /// @notice interface for founders to whitelist investors
1154   /// @param _investors array of investors
1155   function whitelistAddresses(address[] _investors) public onlyOwner {
1156     for (uint256 i = 0; i < _investors.length; i++) {
1157       whitelist(_investors[i]);
1158     }
1159   }
1160 
1161   function whitelist(address investor) public onlyOwner {
1162     if (canPurchase[investor]) return;
1163     numWhitelistedInvestors++;
1164     canPurchase[investor] = true;
1165   }
1166 
1167   function blacklist(address investor) public onlyOwner {
1168     if (!canPurchase[investor]) return;
1169     numWhitelistedInvestors--;
1170     canPurchase[investor] = false;
1171   }
1172 
1173   // ETH-WPR exchange rate
1174   function exchangeRate() constant public initialized returns (uint256) {
1175     return 8000;
1176   }
1177 
1178   function tokensToGenerate(uint256 toFund) internal returns (uint256 generatedTokens) {
1179     generatedTokens = toFund.mul(exchangeRate());
1180   }
1181 
1182   /// @notice If anybody sends Ether directly to this contract, consider he is
1183   /// getting WPRs.
1184   function () public payable notPaused {
1185     proxyPayment(msg.sender);
1186   }
1187 
1188   //////////
1189   // TokenController functions
1190   //////////
1191 
1192   /// @notice This method will generally be called by the WPR token contract to
1193   ///  acquire WPRs. Or directly from third parties that want to acquire WPRs in
1194   ///  behalf of a token holder.
1195   /// @param _th WPR holder where the WPRs will be minted.
1196   function proxyPayment(address _th) public payable notPaused initialized contributionOpen returns (bool) {
1197     require(_th != 0x0);
1198     if (msg.value == 0) {
1199       wpr.unpause();
1200       ExchangerI(exchanger).collect(_th);
1201       wpr.pause();
1202     } else {
1203       doBuy(_th);
1204     }
1205     return true;
1206   }
1207 
1208   function doBuy(address _th) internal {
1209     // whitelisting only during the first day
1210     // if (getBlockTimestamp() <= startTime + 1 days) {
1211     require(canPurchase[_th]);
1212     // }
1213     require(msg.value >= minimumPerTransaction);
1214     uint256 toFund = msg.value;
1215     uint256 toCollect = weiToCollectByInvestor(_th);
1216 
1217     require(toCollect > 0);
1218 
1219     // Check total supply cap reached, sell the all remaining tokens
1220     if (toFund > toCollect) {
1221       toFund = toCollect;
1222     }
1223     uint256 tokensGenerated = tokensToGenerate(toFund);
1224     require(tokensGenerated > 0);
1225     require(wpr.mint(_th, tokensGenerated));
1226 
1227     contributionWallet.transfer(toFund);
1228     // Wings Integration
1229     totalCollected = totalCollected.add(toFund);
1230     individualWeiCollected[_th] = individualWeiCollected[_th].add(toFund);
1231     totalWeiCollected = totalWeiCollected.add(toFund);
1232     NewSale(_th, toFund, tokensGenerated);
1233 
1234     uint256 toReturn = msg.value.sub(toFund);
1235     if (toReturn > 0) {
1236       _th.transfer(toReturn);
1237     }
1238   }
1239 
1240   /// @notice This method will can be called by the controller before the contribution period
1241   ///  end or by anybody after the `endTime`. This method finalizes the contribution period
1242   ///  by creating the remaining tokens and transferring the controller to the configured
1243   ///  controller.
1244   function finalize() public initialized {
1245     require(finalizedBlock == 0);
1246     require(finalizedTime == 0);
1247     require(getBlockTimestamp() >= startTime);
1248     require(msg.sender == owner || getBlockTimestamp() > endTime || weiToCollect() == 0);
1249 
1250     uint CROWDSALE_PCT = 62;
1251     uint TEAMHOLDER_PCT = 20;
1252     uint COMMUNITYHOLDER_PCT = 15;
1253     uint FUTUREHOLDER_PCT = 3;
1254     assert(CROWDSALE_PCT + TEAMHOLDER_PCT + COMMUNITYHOLDER_PCT + FUTUREHOLDER_PCT == 100);
1255 
1256     // WPR generated so far is 62% of total
1257     uint256 tokenCap = wpr.totalSupply().mul(100).div(CROWDSALE_PCT);
1258     // team Wallet will have 20% of the total Tokens and will be in a 36 months
1259     // vesting contract with 3 months cliff.
1260     wpr.mint(teamHolder, tokenCap.mul(TEAMHOLDER_PCT).div(100));
1261     // community Wallet will have access to 15% of the total Tokens.
1262     wpr.mint(communityHolder, tokenCap.mul(COMMUNITYHOLDER_PCT).div(100));
1263     // future Wallet will have 3% of the total Tokens and will be able to retrieve
1264     // after a 4 years.
1265     wpr.mint(futureHolder, tokenCap.mul(FUTUREHOLDER_PCT).div(100));
1266 
1267     require(wpr.finishMinting());
1268     wpr.transferOwnership(owner);
1269 
1270     finalizedBlock = getBlockNumber();
1271     finalizedTime = getBlockTimestamp();
1272 
1273     Finalized(finalizedBlock);
1274   }
1275 
1276   //////////
1277   // Constant functions
1278   //////////
1279 
1280   /// @return Total eth that still available for collection in weis.
1281   function weiToCollect() public constant returns(uint256) {
1282     return totalWeiCap > totalWeiCollected ? totalWeiCap.sub(totalWeiCollected) : 0;
1283   }
1284 
1285   /// @return Total eth that still available for collection in weis.
1286   function weiToCollectByInvestor(address investor) public constant returns(uint256) {
1287     uint256 cap;
1288     uint256 collected;
1289     // adding 1 day as a placeholder for X hours.
1290     // This should change into a variable or coded into the contract.
1291     if (getBlockTimestamp() <= startTime + 5 hours) {
1292       cap = totalWeiCap.div(numWhitelistedInvestors);
1293       collected = individualWeiCollected[investor];
1294     } else {
1295       cap = totalWeiCap;
1296       collected = totalWeiCollected;
1297     }
1298     return cap > collected ? cap.sub(collected) : 0;
1299   }
1300 
1301   //////////
1302   // Testing specific methods
1303   //////////
1304 
1305   /// @notice This function is overridden by the test Mocks.
1306   function getBlockNumber() internal constant returns (uint256) {
1307     return block.number;
1308   }
1309 
1310   function getBlockTimestamp() internal constant returns (uint256) {
1311     return block.timestamp;
1312   }
1313 
1314   //////////
1315   // Safety Methods
1316   //////////
1317 
1318   // Wings Integration
1319   // This function can be used by the contract owner to add ether collected
1320   // outside of this contract, such as from a presale
1321   function setTotalCollected(uint _totalCollected) public onlyOwner {
1322     totalCollected = _totalCollected;
1323   }
1324 
1325   /// @notice This method can be used by the controller to extract mistakenly
1326   ///  sent tokens to this contract.
1327   /// @param _token The address of the token contract that you want to recover
1328   ///  set to 0 in case you want to extract ether.
1329   function claimTokens(address _token) public onlyOwner {
1330     if (wpr.owner() == address(this)) {
1331       wpr.claimTokens(_token);
1332     }
1333 
1334     if (_token == 0x0) {
1335       owner.transfer(this.balance);
1336       return;
1337     }
1338 
1339     ERC20 token = ERC20(_token);
1340     uint256 balance = token.balanceOf(this);
1341     token.transfer(owner, balance);
1342     ClaimedTokens(_token, owner, balance);
1343   }
1344 
1345   /// @notice Pauses the contribution if there is any issue
1346   function pauseContribution(bool _paused) onlyOwner {
1347     paused = _paused;
1348   }
1349 
1350   event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
1351   event NewSale(address indexed _th, uint256 _amount, uint256 _tokens);
1352   event Initialized(uint _now);
1353   event Finalized(uint _now);
1354 }
1355 
1356 // File: contracts/Exchanger.sol
1357 
1358 /*
1359   Copyright 2017, Klaus Hott (BlockChainLabs.nz)
1360   Copyright 2017, Jordi Baylina (Giveth)
1361 
1362   This program is free software: you can redistribute it and/or modify
1363   it under the terms of the GNU General Public License as published by
1364   the Free Software Foundation, either version 3 of the License, or
1365   (at your option) any later version.
1366 
1367   This program is distributed in the hope that it will be useful,
1368   but WITHOUT ANY WARRANTY; without even the implied warranty of
1369   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1370   GNU General Public License for more details.
1371 
1372   You should have received a copy of the GNU General Public License
1373   along with this program.  If not, see <http://www.gnu.org/licenses/>.
1374 */
1375 
1376 /// @title Exchanger Contract
1377 /// @author Klaus Hott
1378 /// @dev This contract will be used to distribute WPR between WCT holders.
1379 ///  WCT token is not transferable, and we just keep an accounting between all tokens
1380 ///  deposited and the tokens collected.
1381 
1382 
1383 
1384 
1385 contract Exchanger is ExchangerI, Ownable {
1386   using SafeMath for uint256;
1387 
1388   mapping (address => uint256) public collected;
1389   uint256 public totalCollected;
1390   MiniMeToken public wct1;
1391   MiniMeToken public wct2;
1392   Contribution public contribution;
1393 
1394   function Exchanger(address _wct1, address _wct2, address _wpr, address _contribution) {
1395     wct1 = MiniMeToken(_wct1);
1396     wct2 = MiniMeToken(_wct2);
1397     wpr = ERC20Basic(_wpr);
1398     contribution = Contribution(_contribution);
1399   }
1400 
1401   function () public {
1402     if (contribution.finalizedBlock() == 0) {
1403       contribution.proxyPayment(msg.sender);
1404     } else {
1405       collect(msg.sender);
1406     }
1407   }
1408 
1409   /// @notice This method should be called by the WCT holders to collect their
1410   ///  corresponding WPRs
1411   function collect(address caller) public {
1412     // WCT sholder could collect WPR right after contribution started
1413     require(getBlockTimestamp() > contribution.startTime());
1414 
1415     uint256 pre_sale_fixed_at = contribution.initializedBlock();
1416 
1417     // Get current WPR ballance at contributions initialization-
1418     uint256 balance = wct1.balanceOfAt(caller, pre_sale_fixed_at);
1419     balance = balance.add(wct2.balanceOfAt(caller, pre_sale_fixed_at));
1420 
1421     uint256 totalSupplied = wct1.totalSupplyAt(pre_sale_fixed_at);
1422     totalSupplied = totalSupplied.add(wct2.totalSupplyAt(pre_sale_fixed_at));
1423 
1424     // total of wpr to be distributed.
1425     uint256 total = totalCollected.add(wpr.balanceOf(address(this)));
1426 
1427     // First calculate how much correspond to him
1428     assert(totalSupplied > 0);
1429     uint256 amount = total.mul(balance).div(totalSupplied);
1430 
1431     // And then subtract the amount already collected
1432     amount = amount.sub(collected[caller]);
1433 
1434     // Notify the user that there are no tokens to exchange
1435     require(amount > 0);
1436 
1437     totalCollected = totalCollected.add(amount);
1438     collected[caller] = collected[caller].add(amount);
1439 
1440     require(wpr.transfer(caller, amount));
1441 
1442     TokensCollected(caller, amount);
1443   }
1444 
1445   //////////
1446   // Testing specific methods
1447   //////////
1448 
1449   /// @notice This function is overridden by the test Mocks.
1450   function getBlockNumber() internal constant returns (uint256) {
1451     return block.number;
1452   }
1453 
1454   /// @notice This function is overridden by the test Mocks.
1455   function getBlockTimestamp() internal constant returns (uint256) {
1456     return block.timestamp;
1457   }
1458 
1459   //////////
1460   // Safety Method
1461   //////////
1462 
1463   /// @notice This method can be used by the controller to extract mistakenly
1464   ///  sent tokens to this contract.
1465   /// @param _token The address of the token contract that you want to recover
1466   ///  set to 0 in case you want to extract ether.
1467   function claimTokens(address _token) public onlyOwner {
1468     assert(_token != address(wpr));
1469     if (_token == 0x0) {
1470       owner.transfer(this.balance);
1471       return;
1472     }
1473 
1474     ERC20 token = ERC20(_token);
1475     uint256 balance = token.balanceOf(this);
1476     token.transfer(owner, balance);
1477     ClaimedTokens(_token, owner, balance);
1478   }
1479 
1480   event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
1481   event TokensCollected(address indexed _holder, uint256 _amount);
1482 }