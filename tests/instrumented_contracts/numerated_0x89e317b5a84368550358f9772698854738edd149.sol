1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 contract ERC20Basic {
29   uint256 public totalSupply;
30   function balanceOf(address who) public constant returns (uint256);
31   function transfer(address to, uint256 value) public returns (bool);
32   event Transfer(address indexed from, address indexed to, uint256 value);
33 }
34 
35 contract BasicToken is ERC20Basic {
36   using SafeMath for uint256;
37 
38   mapping(address => uint256) balances;
39 
40   /**
41   * @dev transfer token for a specified address
42   * @param _to The address to transfer to.
43   * @param _value The amount to be transferred.
44   */
45   function transfer(address _to, uint256 _value) public returns (bool) {
46     require(_to != address(0));
47 
48     // SafeMath.sub will throw if there is not enough balance.
49     balances[msg.sender] = balances[msg.sender].sub(_value);
50     balances[_to] = balances[_to].add(_value);
51     Transfer(msg.sender, _to, _value);
52     return true;
53   }
54 
55   /**
56   * @dev Gets the balance of the specified address.
57   * @param _owner The address to query the the balance of.
58   * @return An uint256 representing the amount owned by the passed address.
59   */
60   function balanceOf(address _owner) public constant returns (uint256 balance) {
61     return balances[_owner];
62   }
63 
64 }
65 
66 contract ERC20 is ERC20Basic {
67   function allowance(address owner, address spender) public constant returns (uint256);
68   function transferFrom(address from, address to, uint256 value) public returns (bool);
69   function approve(address spender, uint256 value) public returns (bool);
70   event Approval(address indexed owner, address indexed spender, uint256 value);
71 }
72 
73 
74 /**
75  * @title Standard ERC20 token
76  *
77  * @dev Implementation of the basic standard token.
78  * @dev https://github.com/ethereum/EIPs/issues/20
79  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
80  */
81 contract StandardToken is ERC20, BasicToken {
82 
83   mapping (address => mapping (address => uint256)) allowed;
84 
85 
86   /**
87    * @dev Transfer tokens from one address to another
88    * @param _from address The address which you want to send tokens from
89    * @param _to address The address which you want to transfer to
90    * @param _value uint256 the amount of tokens to be transferred
91    */
92   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
93     require(_to != address(0));
94 
95     uint256 _allowance = allowed[_from][msg.sender];
96 
97     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
98     // require (_value <= _allowance);
99 
100     balances[_from] = balances[_from].sub(_value);
101     balances[_to] = balances[_to].add(_value);
102     allowed[_from][msg.sender] = _allowance.sub(_value);
103     Transfer(_from, _to, _value);
104     return true;
105   }
106 
107   /**
108    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
109    *
110    * Beware that changing an allowance with this method brings the risk that someone may use both the old
111    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
112    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
113    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
114    * @param _spender The address which will spend the funds.
115    * @param _value The amount of tokens to be spent.
116    */
117   function approve(address _spender, uint256 _value) public returns (bool) {
118     allowed[msg.sender][_spender] = _value;
119     Approval(msg.sender, _spender, _value);
120     return true;
121   }
122 
123   /**
124    * @dev Function to check the amount of tokens that an owner allowed to a spender.
125    * @param _owner address The address which owns the funds.
126    * @param _spender address The address which will spend the funds.
127    * @return A uint256 specifying the amount of tokens still available for the spender.
128    */
129   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
130     return allowed[_owner][_spender];
131   }
132 
133   /**
134    * approve should be called when allowed[_spender] == 0. To increment
135    * allowed value is better to use this function to avoid 2 calls (and wait until
136    * the first transaction is mined)
137    * From MonolithDAO Token.sol
138    */
139   function increaseApproval (address _spender, uint _addedValue)
140     returns (bool success) {
141     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
142     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
143     return true;
144   }
145 
146   function decreaseApproval (address _spender, uint _subtractedValue)
147     returns (bool success) {
148     uint oldValue = allowed[msg.sender][_spender];
149     if (_subtractedValue > oldValue) {
150       allowed[msg.sender][_spender] = 0;
151     } else {
152       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
153     }
154     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
155     return true;
156   }
157 
158 }
159 
160 contract Ownable {
161   address public owner;
162 
163 
164   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
165 
166 
167   /**
168    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
169    * account.
170    */
171   function Ownable() {
172     owner = msg.sender;
173   }
174 
175 
176   /**
177    * @dev Throws if called by any account other than the owner.
178    */
179   modifier onlyOwner() {
180     require(msg.sender == owner);
181     _;
182   }
183 
184 
185   /**
186    * @dev Allows the current owner to transfer control of the contract to a newOwner.
187    * @param newOwner The address to transfer ownership to.
188    */
189   function transferOwnership(address newOwner) onlyOwner public {
190     require(newOwner != address(0));
191     OwnershipTransferred(owner, newOwner);
192     owner = newOwner;
193   }
194 
195 }
196 
197 library Math {
198   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
199     return a >= b ? a : b;
200   }
201 
202   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
203     return a < b ? a : b;
204   }
205 
206   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
207     return a >= b ? a : b;
208   }
209 
210   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
211     return a < b ? a : b;
212   }
213 }
214 
215 contract ContractReceiver {
216 
217    function tokenFallback(address _from, uint _value, bytes _data);
218 
219 }
220 
221 /*
222     Copyright 2016, Jordi Baylina
223 
224     This program is free software: you can redistribute it and/or modify
225     it under the terms of the GNU General Public License as published by
226     the Free Software Foundation, either version 3 of the License, or
227     (at your option) any later version.
228 
229     This program is distributed in the hope that it will be useful,
230     but WITHOUT ANY WARRANTY; without even the implied warranty of
231     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
232     GNU General Public License for more details.
233 
234     You should have received a copy of the GNU General Public License
235     along with this program.  If not, see <http://www.gnu.org/licenses/>.
236  */
237 
238 /// @title MiniMeToken Contract
239 /// @author Jordi Baylina
240 /// @dev This token contract's goal is to make it easy for anyone to clone this
241 ///  token using the token distribution at a given block, this will allow DAO's
242 ///  and DApps to upgrade their features in a decentralized manner without
243 ///  affecting the original token
244 /// @dev It is ERC20 compliant, but still needs to under go further testing.
245 
246 
247 /// @dev The token controller contract must implement these functions
248 contract TokenController {
249     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
250     /// @param _owner The address that sent the ether to create tokens
251     /// @return True if the ether is accepted, false if it throws
252     function proxyPayment(address _owner) payable returns(bool);
253 
254     /// @notice Notifies the controller about a token transfer allowing the
255     ///  controller to react if desired
256     /// @param _from The origin of the transfer
257     /// @param _to The destination of the transfer
258     /// @param _amount The amount of the transfer
259     /// @return False if the controller does not authorize the transfer
260     function onTransfer(address _from, address _to, uint _amount) returns(bool);
261 
262     /// @notice Notifies the controller about an approval allowing the
263     ///  controller to react if desired
264     /// @param _owner The address that calls `approve()`
265     /// @param _spender The spender in the `approve()` call
266     /// @param _amount The amount in the `approve()` call
267     /// @return False if the controller does not authorize the approval
268     function onApprove(address _owner, address _spender, uint _amount)
269         returns(bool);
270 }
271 
272 contract Controlled {
273     /// @notice The address of the controller is the only address that can call
274     ///  a function with this modifier
275     modifier onlyController { require(msg.sender == controller); _; }
276 
277     address public controller;
278 
279     function Controlled() { controller = msg.sender;}
280 
281     /// @notice Changes the controller of the contract
282     /// @param _newController The new controller of the contract
283     function changeController(address _newController) onlyController {
284         controller = _newController;
285     }
286 }
287 
288 contract ApproveAndCallFallBack {
289     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
290 }
291 
292 /// @dev The actual token contract, the default controller is the msg.sender
293 ///  that deploys the contract, so usually this token will be deployed by a
294 ///  token controller contract, which Giveth will call a "Campaign"
295 contract MiniMeToken is Controlled {
296 
297     string public name;                //The Token's name: e.g. DigixDAO Tokens
298     uint8 public decimals;             //Number of decimals of the smallest unit
299     string public symbol;              //An identifier: e.g. REP
300     string public version = 'MMT_0.1'; //An arbitrary versioning scheme
301 
302 
303     /// @dev `Checkpoint` is the structure that attaches a block number to a
304     ///  given value, the block number attached is the one that last changed the
305     ///  value
306     struct  Checkpoint {
307 
308         // `fromBlock` is the block number that the value was generated from
309         uint128 fromBlock;
310 
311         // `value` is the amount of tokens at a specific block number
312         uint128 value;
313     }
314 
315     // `parentToken` is the Token address that was cloned to produce this token;
316     //  it will be 0x0 for a token that was not cloned
317     MiniMeToken public parentToken;
318 
319     // `parentSnapShotBlock` is the block number from the Parent Token that was
320     //  used to determine the initial distribution of the Clone Token
321     uint public parentSnapShotBlock;
322 
323     // `creationBlock` is the block number that the Clone Token was created
324     uint public creationBlock;
325 
326     // `balances` is the map that tracks the balance of each address, in this
327     //  contract when the balance changes the block number that the change
328     //  occurred is also included in the map
329     mapping (address => Checkpoint[]) balances;
330 
331     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
332     mapping (address => mapping (address => uint256)) allowed;
333 
334     // Tracks the history of the `totalSupply` of the token
335     Checkpoint[] totalSupplyHistory;
336 
337     // Flag that determines if the token is transferable or not.
338     bool public transfersEnabled;
339 
340     // The factory used to create new clone tokens
341     MiniMeTokenFactory public tokenFactory;
342 
343 ////////////////
344 // Constructor
345 ////////////////
346 
347     /// @notice Constructor to create a MiniMeToken
348     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
349     ///  will create the Clone token contracts, the token factory needs to be
350     ///  deployed first
351     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
352     ///  new token
353     /// @param _parentSnapShotBlock Block of the parent token that will
354     ///  determine the initial distribution of the clone token, set to 0 if it
355     ///  is a new token
356     /// @param _tokenName Name of the new token
357     /// @param _decimalUnits Number of decimals of the new token
358     /// @param _tokenSymbol Token Symbol for the new token
359     /// @param _transfersEnabled If true, tokens will be able to be transferred
360     function MiniMeToken(
361         address _tokenFactory,
362         address _parentToken,
363         uint _parentSnapShotBlock,
364         string _tokenName,
365         uint8 _decimalUnits,
366         string _tokenSymbol,
367         bool _transfersEnabled
368     ) {
369         tokenFactory = MiniMeTokenFactory(_tokenFactory);
370         name = _tokenName;                                 // Set the name
371         decimals = _decimalUnits;                          // Set the decimals
372         symbol = _tokenSymbol;                             // Set the symbol
373         parentToken = MiniMeToken(_parentToken);
374         parentSnapShotBlock = _parentSnapShotBlock;
375         transfersEnabled = _transfersEnabled;
376         creationBlock = block.number;
377     }
378 
379 
380 ///////////////////
381 // ERC20 Methods
382 ///////////////////
383 
384     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
385     /// @param _to The address of the recipient
386     /// @param _amount The amount of tokens to be transferred
387     /// @return Whether the transfer was successful or not
388     function transfer(address _to, uint256 _amount) returns (bool success) {
389         require(transfersEnabled);
390         return doTransfer(msg.sender, _to, _amount);
391     }
392 
393     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
394     ///  is approved by `_from`
395     /// @param _from The address holding the tokens being transferred
396     /// @param _to The address of the recipient
397     /// @param _amount The amount of tokens to be transferred
398     /// @return True if the transfer was successful
399     function transferFrom(address _from, address _to, uint256 _amount
400     ) returns (bool success) {
401 
402         // The controller of this contract can move tokens around at will,
403         //  this is important to recognize! Confirm that you trust the
404         //  controller of this contract, which in most situations should be
405         //  another open source smart contract or 0x0
406         if (msg.sender != controller) {
407             require(transfersEnabled);
408 
409             // The standard ERC 20 transferFrom functionality
410             if (allowed[_from][msg.sender] < _amount) return false;
411             allowed[_from][msg.sender] -= _amount;
412         }
413         return doTransfer(_from, _to, _amount);
414     }
415 
416     /// @dev This is the actual transfer function in the token contract, it can
417     ///  only be called by other functions in this contract.
418     /// @param _from The address holding the tokens being transferred
419     /// @param _to The address of the recipient
420     /// @param _amount The amount of tokens to be transferred
421     /// @return True if the transfer was successful
422     function doTransfer(address _from, address _to, uint _amount
423     ) internal returns(bool) {
424 
425            if (_amount == 0) {
426                return true;
427            }
428 
429            require(parentSnapShotBlock < block.number);
430 
431            // Do not allow transfer to 0x0 or the token contract itself
432            require((_to != 0) && (_to != address(this)));
433 
434            // If the amount being transfered is more than the balance of the
435            //  account the transfer returns false
436            var previousBalanceFrom = balanceOfAt(_from, block.number);
437            if (previousBalanceFrom < _amount) {
438                return false;
439            }
440 
441            // Alerts the token controller of the transfer
442            if (isContract(controller)) {
443                require(TokenController(controller).onTransfer(_from, _to, _amount));
444            }
445 
446            // First update the balance array with the new value for the address
447            //  sending the tokens
448            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
449 
450            // Then update the balance array with the new value for the address
451            //  receiving the tokens
452            var previousBalanceTo = balanceOfAt(_to, block.number);
453            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
454            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
455 
456            // An event to make the transfer easy to find on the blockchain
457            Transfer(_from, _to, _amount);
458 
459            return true;
460     }
461 
462     /// @param _owner The address that's balance is being requested
463     /// @return The balance of `_owner` at the current block
464     function balanceOf(address _owner) constant returns (uint256 balance) {
465         return balanceOfAt(_owner, block.number);
466     }
467 
468     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
469     ///  its behalf. This is a modified version of the ERC20 approve function
470     ///  to be a little bit safer
471     /// @param _spender The address of the account able to transfer the tokens
472     /// @param _amount The amount of tokens to be approved for transfer
473     /// @return True if the approval was successful
474     function approve(address _spender, uint256 _amount) returns (bool success) {
475         require(transfersEnabled);
476 
477         // To change the approve amount you first have to reduce the addresses`
478         //  allowance to zero by calling `approve(_spender,0)` if it is not
479         //  already 0 to mitigate the race condition described here:
480         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
481         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
482 
483         // Alerts the token controller of the approve function call
484         if (isContract(controller)) {
485             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
486         }
487 
488         allowed[msg.sender][_spender] = _amount;
489         Approval(msg.sender, _spender, _amount);
490         return true;
491     }
492 
493     /// @dev This function makes it easy to read the `allowed[]` map
494     /// @param _owner The address of the account that owns the token
495     /// @param _spender The address of the account able to transfer the tokens
496     /// @return Amount of remaining tokens of _owner that _spender is allowed
497     ///  to spend
498     function allowance(address _owner, address _spender
499     ) constant returns (uint256 remaining) {
500         return allowed[_owner][_spender];
501     }
502 
503     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
504     ///  its behalf, and then a function is triggered in the contract that is
505     ///  being approved, `_spender`. This allows users to use their tokens to
506     ///  interact with contracts in one function call instead of two
507     /// @param _spender The address of the contract able to transfer the tokens
508     /// @param _amount The amount of tokens to be approved for transfer
509     /// @return True if the function call was successful
510     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
511     ) returns (bool success) {
512         require(approve(_spender, _amount));
513 
514         ApproveAndCallFallBack(_spender).receiveApproval(
515             msg.sender,
516             _amount,
517             this,
518             _extraData
519         );
520 
521         return true;
522     }
523 
524     /// @dev This function makes it easy to get the total number of tokens
525     /// @return The total number of tokens
526     function totalSupply() constant returns (uint) {
527         return totalSupplyAt(block.number);
528     }
529 
530 
531 ////////////////
532 // Query balance and totalSupply in History
533 ////////////////
534 
535     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
536     /// @param _owner The address from which the balance will be retrieved
537     /// @param _blockNumber The block number when the balance is queried
538     /// @return The balance at `_blockNumber`
539     function balanceOfAt(address _owner, uint _blockNumber) constant
540         returns (uint) {
541 
542         // These next few lines are used when the balance of the token is
543         //  requested before a check point was ever created for this token, it
544         //  requires that the `parentToken.balanceOfAt` be queried at the
545         //  genesis block for that token as this contains initial balance of
546         //  this token
547         if ((balances[_owner].length == 0)
548             || (balances[_owner][0].fromBlock > _blockNumber)) {
549             if (address(parentToken) != 0) {
550                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
551             } else {
552                 // Has no parent
553                 return 0;
554             }
555 
556         // This will return the expected balance during normal situations
557         } else {
558             return getValueAt(balances[_owner], _blockNumber);
559         }
560     }
561 
562     /// @notice Total amount of tokens at a specific `_blockNumber`.
563     /// @param _blockNumber The block number when the totalSupply is queried
564     /// @return The total amount of tokens at `_blockNumber`
565     function totalSupplyAt(uint _blockNumber) constant returns(uint) {
566 
567         // These next few lines are used when the totalSupply of the token is
568         //  requested before a check point was ever created for this token, it
569         //  requires that the `parentToken.totalSupplyAt` be queried at the
570         //  genesis block for this token as that contains totalSupply of this
571         //  token at this block number.
572         if ((totalSupplyHistory.length == 0)
573             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
574             if (address(parentToken) != 0) {
575                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
576             } else {
577                 return 0;
578             }
579 
580         // This will return the expected totalSupply during normal situations
581         } else {
582             return getValueAt(totalSupplyHistory, _blockNumber);
583         }
584     }
585 
586 ////////////////
587 // Clone Token Method
588 ////////////////
589 
590     /// @notice Creates a new clone token with the initial distribution being
591     ///  this token at `_snapshotBlock`
592     /// @param _cloneTokenName Name of the clone token
593     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
594     /// @param _cloneTokenSymbol Symbol of the clone token
595     /// @param _snapshotBlock Block when the distribution of the parent token is
596     ///  copied to set the initial distribution of the new clone token;
597     ///  if the block is zero than the actual block, the current block is used
598     /// @param _transfersEnabled True if transfers are allowed in the clone
599     /// @return The address of the new MiniMeToken Contract
600     function createCloneToken(
601         string _cloneTokenName,
602         uint8 _cloneDecimalUnits,
603         string _cloneTokenSymbol,
604         uint _snapshotBlock,
605         bool _transfersEnabled
606         ) returns(address) {
607         if (_snapshotBlock == 0) _snapshotBlock = block.number;
608         MiniMeToken cloneToken = tokenFactory.createCloneToken(
609             this,
610             _snapshotBlock,
611             _cloneTokenName,
612             _cloneDecimalUnits,
613             _cloneTokenSymbol,
614             _transfersEnabled
615             );
616 
617         cloneToken.changeController(msg.sender);
618 
619         // An event to make the token easy to find on the blockchain
620         NewCloneToken(address(cloneToken), _snapshotBlock);
621         return address(cloneToken);
622     }
623 
624 ////////////////
625 // Generate and destroy tokens
626 ////////////////
627 
628     /// @notice Generates `_amount` tokens that are assigned to `_owner`
629     /// @param _owner The address that will be assigned the new tokens
630     /// @param _amount The quantity of tokens generated
631     /// @return True if the tokens are generated correctly
632     function generateTokens(address _owner, uint _amount
633     ) onlyController returns (bool) {
634         uint curTotalSupply = totalSupply();
635         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
636         uint previousBalanceTo = balanceOf(_owner);
637         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
638         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
639         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
640         Transfer(0, _owner, _amount);
641         return true;
642     }
643 
644 
645     /// @notice Burns `_amount` tokens from `_owner`
646     /// @param _owner The address that will lose the tokens
647     /// @param _amount The quantity of tokens to burn
648     /// @return True if the tokens are burned correctly
649     function destroyTokens(address _owner, uint _amount
650     ) onlyController returns (bool) {
651         uint curTotalSupply = totalSupply();
652         require(curTotalSupply >= _amount);
653         uint previousBalanceFrom = balanceOf(_owner);
654         require(previousBalanceFrom >= _amount);
655         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
656         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
657         Transfer(_owner, 0, _amount);
658         return true;
659     }
660 
661 ////////////////
662 // Enable tokens transfers
663 ////////////////
664 
665 
666     /// @notice Enables token holders to transfer their tokens freely if true
667     /// @param _transfersEnabled True if transfers are allowed in the clone
668     function enableTransfers(bool _transfersEnabled) onlyController {
669         transfersEnabled = _transfersEnabled;
670     }
671 
672 ////////////////
673 // Internal helper functions to query and set a value in a snapshot array
674 ////////////////
675 
676     /// @dev `getValueAt` retrieves the number of tokens at a given block number
677     /// @param checkpoints The history of values being queried
678     /// @param _block The block number to retrieve the value at
679     /// @return The number of tokens being queried
680     function getValueAt(Checkpoint[] storage checkpoints, uint _block
681     ) constant internal returns (uint) {
682         if (checkpoints.length == 0) return 0;
683 
684         // Shortcut for the actual value
685         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
686             return checkpoints[checkpoints.length-1].value;
687         if (_block < checkpoints[0].fromBlock) return 0;
688 
689         // Binary search of the value in the array
690         uint min = 0;
691         uint max = checkpoints.length-1;
692         while (max > min) {
693             uint mid = (max + min + 1)/ 2;
694             if (checkpoints[mid].fromBlock<=_block) {
695                 min = mid;
696             } else {
697                 max = mid-1;
698             }
699         }
700         return checkpoints[min].value;
701     }
702 
703     /// @dev `updateValueAtNow` used to update the `balances` map and the
704     ///  `totalSupplyHistory`
705     /// @param checkpoints The history of data being updated
706     /// @param _value The new number of tokens
707     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
708     ) internal  {
709         if ((checkpoints.length == 0)
710         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
711                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
712                newCheckPoint.fromBlock =  uint128(block.number);
713                newCheckPoint.value = uint128(_value);
714            } else {
715                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
716                oldCheckPoint.value = uint128(_value);
717            }
718     }
719 
720     /// @dev Internal function to determine if an address is a contract
721     /// @param _addr The address being queried
722     /// @return True if `_addr` is a contract
723     function isContract(address _addr) constant internal returns(bool) {
724         uint size;
725         if (_addr == 0) return false;
726         assembly {
727             size := extcodesize(_addr)
728         }
729         return size>0;
730     }
731 
732     /// @dev Helper function to return a min betwen the two uints
733     function min(uint a, uint b) internal returns (uint) {
734         return a < b ? a : b;
735     }
736 
737     /// @notice The fallback function: If the contract's controller has not been
738     ///  set to 0, then the `proxyPayment` method is called which relays the
739     ///  ether and creates tokens as described in the token controller contract
740     function ()  payable {
741         require(isContract(controller));
742         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
743     }
744 
745 //////////
746 // Safety Methods
747 //////////
748 
749     /// @notice This method can be used by the controller to extract mistakenly
750     ///  sent tokens to this contract.
751     /// @param _token The address of the token contract that you want to recover
752     ///  set to 0 in case you want to extract ether.
753     function claimTokens(address _token) onlyController {
754         if (_token == 0x0) {
755             controller.transfer(this.balance);
756             return;
757         }
758 
759         MiniMeToken token = MiniMeToken(_token);
760         uint balance = token.balanceOf(this);
761         token.transfer(controller, balance);
762         ClaimedTokens(_token, controller, balance);
763     }
764 
765 ////////////////
766 // Events
767 ////////////////
768     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
769     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
770     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
771     event Approval(
772         address indexed _owner,
773         address indexed _spender,
774         uint256 _amount
775         );
776 
777 }
778 
779 
780 ////////////////
781 // MiniMeTokenFactory
782 ////////////////
783 
784 /// @dev This contract is used to generate clone contracts from a contract.
785 ///  In solidity this is the way to create a contract from a contract of the
786 ///  same class
787 contract MiniMeTokenFactory {
788 
789     /// @notice Update the DApp by creating a new token with new functionalities
790     ///  the msg.sender becomes the controller of this clone token
791     /// @param _parentToken Address of the token being cloned
792     /// @param _snapshotBlock Block of the parent token that will
793     ///  determine the initial distribution of the clone token
794     /// @param _tokenName Name of the new token
795     /// @param _decimalUnits Number of decimals of the new token
796     /// @param _tokenSymbol Token Symbol for the new token
797     /// @param _transfersEnabled If true, tokens will be able to be transferred
798     /// @return The address of the new token contract
799     function createCloneToken(
800         address _parentToken,
801         uint _snapshotBlock,
802         string _tokenName,
803         uint8 _decimalUnits,
804         string _tokenSymbol,
805         bool _transfersEnabled
806     ) returns (MiniMeToken) {
807         MiniMeToken newToken = new MiniMeToken(
808             this,
809             _parentToken,
810             _snapshotBlock,
811             _tokenName,
812             _decimalUnits,
813             _tokenSymbol,
814             _transfersEnabled
815             );
816 
817         newToken.changeController(msg.sender);
818         return newToken;
819     }
820 }
821 
822 
823 /// @title SpecToken - Crowdfunding code for the Spectre.ai Token Sale
824 contract SpectreSubscriber2Token is StandardToken, Ownable, TokenController {
825   using SafeMath for uint;
826 
827   string public constant name = "SPECTRE SUBSCRIBER2 TOKEN";
828   string public constant symbol = "SXS2";
829   uint256 public constant decimals = 18;
830 
831   uint256 public constant TOTAL_CAP = 91627765897795994966351100;
832 
833   address public specDWallet;
834   address public specUWallet;
835 
836   uint256 public transferTime = 0;
837   uint256 public saleEnd = 1512907200;
838   bool public tokenAddressesSet = false;
839   uint256 constant D160 = 0x0010000000000000000000000000000000000000000;
840 
841   event OwnerTransfer(address indexed _from, address indexed _to, uint256 _value);
842   event TransferTimeSet(uint256 _transferTime);
843 
844   modifier isTransferable() {
845     require(tokenAddressesSet);
846     require(getNow() > transferTime);
847     _;
848   }
849 
850   function setTransferTime(uint256 _transferTime) onlyOwner {
851     transferTime = _transferTime;
852     TransferTimeSet(transferTime);
853   }
854 
855   function mint(address _to, uint256 _amount) onlyOwner {
856     require(totalSupply.add(_amount) <= TOTAL_CAP);
857     balances[_to] = balances[_to].add(_amount);
858     totalSupply = totalSupply.add(_amount);
859     Transfer(0, _to, _amount);
860   }
861 
862   function burn(address _to, uint256 _amount) onlyOwner {
863     balances[_to] = balances[_to].sub(_amount);
864     totalSupply = totalSupply.sub(_amount);
865     Transfer(_to, 0, _amount);
866   }
867 
868   //@notice Function to configure contract addresses
869   //@param `_specUWallet` - address of Utility contract
870   //@param `_specDWallet` - address of Dividend contract
871   function setTokenAddresses(address _specUWallet, address _specDWallet) onlyOwner public {
872     require(!tokenAddressesSet);
873     require(_specDWallet != address(0));
874     require(_specUWallet != address(0));
875     require(isContract(_specDWallet));
876     require(isContract(_specUWallet));
877     specUWallet = _specUWallet;
878     specDWallet = _specDWallet;
879     tokenAddressesSet = true;
880   }
881 
882   function withdrawEther() public onlyOwner {
883     //In case ether is sent, even though not refundable
884     msg.sender.transfer(this.balance);
885   }
886 
887   //@notice Standard function transfer similar to ERC20 transfer with no _data .
888   //@notice Added due to backwards compatibility reasons .
889   function transfer(address _to, uint256 _value) isTransferable returns (bool success) {
890     //standard function transfer similar to ERC20 transfer with no _data
891     //added due to backwards compatibility reasons
892     require(_to == specDWallet || _to == specUWallet);
893     require(isContract(_to));
894     bytes memory empty;
895     return transferToContract(msg.sender, _to, _value, empty);
896   }
897 
898   //@notice assemble the given address bytecode. If bytecode exists then the _addr is a contract.
899   function isContract(address _addr) private returns (bool is_contract) {
900     uint256 length;
901     assembly {
902       //retrieve the size of the code on target address, this needs assembly
903       length := extcodesize(_addr)
904     }
905     return (length>0);
906   }
907 
908   //@notice function that is called when transaction target is a contract
909   function transferToContract(address _from, address _to, uint256 _value, bytes _data) internal returns (bool success) {
910     require(balanceOf(_from) >= _value);
911     balances[_from] = balanceOf(_from).sub(_value);
912     balances[_to] = balanceOf(_to).add(_value);
913     ContractReceiver receiver = ContractReceiver(_to);
914     receiver.tokenFallback(_from, _value, _data);
915     Transfer(_from, _to, _value);
916     return true;
917   }
918 
919   /**
920    * @dev Transfer tokens from one address to another - needed for owner transfers
921    * @param _from address The address which you want to send tokens from
922    * @param _to address The address which you want to transfer to
923    * @param _value uint256 the amount of tokens to be transferred
924    */
925   function transferFrom(address _from, address _to, uint256 _value) public isTransferable returns (bool) {
926     require(_to == specDWallet || _to == specUWallet);
927     require(isContract(_to));
928     //owner can transfer tokens on behalf of users after 28 days
929     if (msg.sender == owner && getNow() > saleEnd + 30 days) {
930       OwnerTransfer(_from, _to, _value);
931     } else {
932       uint256 _allowance = allowed[_from][msg.sender];
933       allowed[_from][msg.sender] = _allowance.sub(_value);
934     }
935 
936     //Now make the transfer
937     bytes memory empty;
938     return transferToContract(_from, _to, _value, empty);
939 
940   }
941 
942   // data is an array of uint256s. Each uint256 represents a address and amount.
943   // The 160 LSB is the address that wants to be added
944   // The 96 MSB is the amount of to be minted for that address
945   function multiMint(uint256[] data) public onlyOwner {
946     for (uint256 i = 0; i < data.length; i++) {
947       address addr = address(data[i] & (D160 - 1));
948       uint256 amount = data[i] / D160;
949       mint(addr, amount);
950     }
951   }
952 
953   // data is an array of uint256s. Each uint256 represents a address and amount.
954   // The 160 LSB is the address that wants to be added
955   // The 96 MSB is the amount of to be minted for that address
956   function multiBurn(uint256[] data) public onlyOwner {
957     for (uint256 i = 0; i < data.length; i++) {
958       address addr = address(data[i] & (D160 - 1));
959       uint256 amount = data[i] / D160;
960       burn(addr, amount);
961     }
962   }
963 
964   /////////////////
965   // TokenController interface
966   /////////////////
967 
968   /// @notice `proxyPayment()` returns false, meaning ether is not accepted at
969   ///  the token address, only the address of FiinuCrowdSale
970   /// @param _owner The address that will hold the newly created tokens
971 
972   function proxyPayment(address _owner) payable returns(bool) {
973       return false;
974   }
975 
976   /// @notice Notifies the controller about a transfer, for this Campaign all
977   ///  transfers are allowed by default and no extra notifications are needed
978   /// @param _from The origin of the transfer
979   /// @param _to The destination of the transfer
980   /// @param _amount The amount of the transfer
981   /// @return False if the controller does not authorize the transfer
982   function onTransfer(address _from, address _to, uint _amount) returns(bool) {
983       return true;
984   }
985 
986   /// @notice Notifies the controller about an approval, for this Campaign all
987   ///  approvals are allowed by default and no extra notifications are needed
988   /// @param _owner The address that calls `approve()`
989   /// @param _spender The spender in the `approve()` call
990   /// @param _amount The amount in the `approve()` call
991   /// @return False if the controller does not authorize the approval
992   function onApprove(address _owner, address _spender, uint _amount)
993       returns(bool)
994   {
995       return true;
996   }
997 
998   function getNow() constant internal returns (uint256) {
999     return now;
1000   }
1001 
1002 }