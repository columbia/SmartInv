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
27 // File: contracts/InvestorWalletFactoryI.sol
28 
29 contract InvestorWalletFactoryI {
30   address public exchanger;
31 }
32 
33 // File: contracts/SafeMath.sol
34 
35 /**
36  * @title SafeMath
37  * @dev Math operations with safety checks that throw on error
38  */
39 library SafeMath {
40   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
41     uint256 c = a * b;
42     assert(a == 0 || c / a == b);
43     return c;
44   }
45 
46   function div(uint256 a, uint256 b) internal constant returns (uint256) {
47     // assert(b > 0); // Solidity automatically throws when dividing by 0
48     uint256 c = a / b;
49     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
50     return c;
51   }
52 
53   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
54     assert(b <= a);
55     return a - b;
56   }
57 
58   function add(uint256 a, uint256 b) internal constant returns (uint256) {
59     uint256 c = a + b;
60     assert(c >= a);
61     return c;
62   }
63 }
64 
65 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
66 
67 /**
68  * @title Ownable
69  * @dev The Ownable contract has an owner address, and provides basic authorization control
70  * functions, this simplifies the implementation of "user permissions".
71  */
72 contract Ownable {
73   address public owner;
74 
75 
76   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
77 
78 
79   /**
80    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
81    * account.
82    */
83   function Ownable() public {
84     owner = msg.sender;
85   }
86 
87 
88   /**
89    * @dev Throws if called by any account other than the owner.
90    */
91   modifier onlyOwner() {
92     require(msg.sender == owner);
93     _;
94   }
95 
96 
97   /**
98    * @dev Allows the current owner to transfer control of the contract to a newOwner.
99    * @param newOwner The address to transfer ownership to.
100    */
101   function transferOwnership(address newOwner) public onlyOwner {
102     require(newOwner != address(0));
103     OwnershipTransferred(owner, newOwner);
104     owner = newOwner;
105   }
106 
107 }
108 
109 // File: contracts/InvestorWallet.sol
110 
111 // 1. WePower deploy a contract which is controlled by WePower multisig.
112 // 2. Investor transfer eth or any other currency to WePower multisig or some bank.
113 // 3. WePower mints WCT2 to that investor contract wallet.
114 // 4. Investor contract wallet stores WCT2.
115 // 5. WePower transfers ownership to Investor multisig.
116 // 6. Investor can only claim tokens after X months defined on the contract deployment.
117 
118 contract InvestorWallet is Ownable {
119   using SafeMath for uint256;
120   address internal wct2;
121   InvestorWalletFactoryI internal factory;
122   uint256 public releaseTime;
123 
124   function InvestorWallet(address _wct2, address _factory, uint256 _monthsToRelease) {
125     wct2 = _wct2;
126     factory = InvestorWalletFactoryI(_factory);
127     releaseTime = getTime().add(months(_monthsToRelease));
128   }
129 
130   function () public onlyOwner {
131     exchangeTokens();
132     collectTokens();
133   }
134 
135   function exchangeTokens() public onlyOwner {
136     ExchangerI exchanger = ExchangerI(factory.exchanger());
137 
138     require(address(exchanger) != 0x0);
139     exchanger.collect(address(this));
140   }
141 
142   /// @notice The Dev (Owner) will call this method to extract the tokens
143   event logger(string s);
144   function collectTokens() public onlyOwner {
145     require(getTime() > releaseTime);
146     ExchangerI exchanger = ExchangerI(factory.exchanger());
147     require(address(exchanger) != 0x0);
148     ERC20Basic wpr = ERC20Basic(exchanger.wpr());
149     uint256 balance = wpr.balanceOf(address(this));
150     require(wpr.transfer(owner, balance));
151     TokensWithdrawn(owner, balance);
152   }
153 
154   function getTime() internal returns (uint256) {
155     return now;
156   }
157 
158   function months(uint256 m) internal returns (uint256) {
159       return m.mul(30 days);
160   }
161 
162   //////////
163   // Safety Methods
164   //////////
165 
166   /// @notice This method can be used by the owner to extract mistakenly
167   ///  sent tokens to this contract.
168   /// @param _token The address of the token contract that you want to recover
169   ///  set to 0 in case you want to extract ether.
170   function claimTokens(address _token) public onlyOwner {
171     ExchangerI exchanger = ExchangerI(factory.exchanger());
172     require(address(exchanger) != 0x0);
173     ERC20Basic wpr = ERC20Basic(exchanger.wpr());
174     require(_token != address(wct2) && _token != address(wpr));
175 
176     if (_token == 0x0) {
177       owner.transfer(this.balance);
178       return;
179     }
180 
181     ERC20Basic token = ERC20Basic(_token);
182     uint256 balance = token.balanceOf(this);
183     token.transfer(owner, balance);
184     ClaimedTokens(_token, owner, balance);
185   }
186 
187   event ClaimedTokens(address indexed _token, address indexed _owner, uint256 _amount);
188   event TokensWithdrawn(address indexed _holder, uint256 _amount);
189 }
190 
191 // File: contracts/MiniMeToken.sol
192 
193 /*
194     Copyright 2016, Jordi Baylina
195 
196     This program is free software: you can redistribute it and/or modify
197     it under the terms of the GNU General Public License as published by
198     the Free Software Foundation, either version 3 of the License, or
199     (at your option) any later version.
200 
201     This program is distributed in the hope that it will be useful,
202     but WITHOUT ANY WARRANTY; without even the implied warranty of
203     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
204     GNU General Public License for more details.
205 
206     You should have received a copy of the GNU General Public License
207     along with this program.  If not, see <http://www.gnu.org/licenses/>.
208  */
209 
210 /// @title MiniMeToken Contract
211 /// @author Jordi Baylina
212 /// @dev This token contract's goal is to make it easy for anyone to clone this
213 ///  token using the token distribution at a given block, this will allow DAO's
214 ///  and DApps to upgrade their features in a decentralized manner without
215 ///  affecting the original token
216 /// @dev It is ERC20 compliant, but still needs to under go further testing.
217 
218 
219 /// @dev The token controller contract must implement these functions
220 contract TokenController {
221     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
222     /// @param _owner The address that sent the ether to create tokens
223     /// @return True if the ether is accepted, false if it throws
224     function proxyPayment(address _owner) payable returns(bool);
225 
226     /// @notice Notifies the controller about a token transfer allowing the
227     ///  controller to react if desired
228     /// @param _from The origin of the transfer
229     /// @param _to The destination of the transfer
230     /// @param _amount The amount of the transfer
231     /// @return False if the controller does not authorize the transfer
232     function onTransfer(address _from, address _to, uint _amount) returns(bool);
233 
234     /// @notice Notifies the controller about an approval allowing the
235     ///  controller to react if desired
236     /// @param _owner The address that calls `approve()`
237     /// @param _spender The spender in the `approve()` call
238     /// @param _amount The amount in the `approve()` call
239     /// @return False if the controller does not authorize the approval
240     function onApprove(address _owner, address _spender, uint _amount)
241         returns(bool);
242 }
243 
244 contract Controlled {
245     /// @notice The address of the controller is the only address that can call
246     ///  a function with this modifier
247     modifier onlyController { require(msg.sender == controller); _; }
248 
249     address public controller;
250 
251     function Controlled() { controller = msg.sender;}
252 
253     /// @notice Changes the controller of the contract
254     /// @param _newController The new controller of the contract
255     function changeController(address _newController) onlyController {
256         controller = _newController;
257     }
258 }
259 
260 contract ApproveAndCallFallBack {
261     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
262 }
263 
264 /// @dev The actual token contract, the default controller is the msg.sender
265 ///  that deploys the contract, so usually this token will be deployed by a
266 ///  token controller contract, which Giveth will call a "Campaign"
267 contract MiniMeToken is Controlled {
268 
269     string public name;                //The Token's name: e.g. DigixDAO Tokens
270     uint8 public decimals;             //Number of decimals of the smallest unit
271     string public symbol;              //An identifier: e.g. REP
272     string public version = 'MMT_0.1'; //An arbitrary versioning scheme
273 
274 
275     /// @dev `Checkpoint` is the structure that attaches a block number to a
276     ///  given value, the block number attached is the one that last changed the
277     ///  value
278     struct  Checkpoint {
279 
280         // `fromBlock` is the block number that the value was generated from
281         uint128 fromBlock;
282 
283         // `value` is the amount of tokens at a specific block number
284         uint128 value;
285     }
286 
287     // `parentToken` is the Token address that was cloned to produce this token;
288     //  it will be 0x0 for a token that was not cloned
289     MiniMeToken public parentToken;
290 
291     // `parentSnapShotBlock` is the block number from the Parent Token that was
292     //  used to determine the initial distribution of the Clone Token
293     uint public parentSnapShotBlock;
294 
295     // `creationBlock` is the block number that the Clone Token was created
296     uint public creationBlock;
297 
298     // `balances` is the map that tracks the balance of each address, in this
299     //  contract when the balance changes the block number that the change
300     //  occurred is also included in the map
301     mapping (address => Checkpoint[]) balances;
302 
303     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
304     mapping (address => mapping (address => uint256)) allowed;
305 
306     // Tracks the history of the `totalSupply` of the token
307     Checkpoint[] totalSupplyHistory;
308 
309     // Flag that determines if the token is transferable or not.
310     bool public transfersEnabled;
311 
312     // The factory used to create new clone tokens
313     MiniMeTokenFactory public tokenFactory;
314 
315 ////////////////
316 // Constructor
317 ////////////////
318 
319     /// @notice Constructor to create a MiniMeToken
320     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
321     ///  will create the Clone token contracts, the token factory needs to be
322     ///  deployed first
323     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
324     ///  new token
325     /// @param _parentSnapShotBlock Block of the parent token that will
326     ///  determine the initial distribution of the clone token, set to 0 if it
327     ///  is a new token
328     /// @param _tokenName Name of the new token
329     /// @param _decimalUnits Number of decimals of the new token
330     /// @param _tokenSymbol Token Symbol for the new token
331     /// @param _transfersEnabled If true, tokens will be able to be transferred
332     function MiniMeToken(
333         address _tokenFactory,
334         address _parentToken,
335         uint _parentSnapShotBlock,
336         string _tokenName,
337         uint8 _decimalUnits,
338         string _tokenSymbol,
339         bool _transfersEnabled
340     ) {
341         tokenFactory = MiniMeTokenFactory(_tokenFactory);
342         name = _tokenName;                                 // Set the name
343         decimals = _decimalUnits;                          // Set the decimals
344         symbol = _tokenSymbol;                             // Set the symbol
345         parentToken = MiniMeToken(_parentToken);
346         parentSnapShotBlock = _parentSnapShotBlock;
347         transfersEnabled = _transfersEnabled;
348         creationBlock = block.number;
349     }
350 
351 
352 ///////////////////
353 // ERC20 Methods
354 ///////////////////
355 
356     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
357     /// @param _to The address of the recipient
358     /// @param _amount The amount of tokens to be transferred
359     /// @return Whether the transfer was successful or not
360     function transfer(address _to, uint256 _amount) returns (bool success) {
361         require(transfersEnabled);
362         return doTransfer(msg.sender, _to, _amount);
363     }
364 
365     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
366     ///  is approved by `_from`
367     /// @param _from The address holding the tokens being transferred
368     /// @param _to The address of the recipient
369     /// @param _amount The amount of tokens to be transferred
370     /// @return True if the transfer was successful
371     function transferFrom(address _from, address _to, uint256 _amount
372     ) returns (bool success) {
373 
374         // The controller of this contract can move tokens around at will,
375 
376         //  controller of this contract, which in most situations should be
377         //  another open source smart contract or 0x0
378         if (msg.sender != controller) {
379             require(transfersEnabled);
380 
381             // The standard ERC 20 transferFrom functionality
382             if (allowed[_from][msg.sender] < _amount) return false;
383             allowed[_from][msg.sender] -= _amount;
384         }
385         return doTransfer(_from, _to, _amount);
386     }
387 
388     /// @dev This is the actual transfer function in the token contract, it can
389     ///  only be called by other functions in this contract.
390     /// @param _from The address holding the tokens being transferred
391     /// @param _to The address of the recipient
392     /// @param _amount The amount of tokens to be transferred
393     /// @return True if the transfer was successful
394     function doTransfer(address _from, address _to, uint _amount
395     ) internal returns(bool) {
396 
397            if (_amount == 0) {
398                return true;
399            }
400 
401            require(parentSnapShotBlock < block.number);
402 
403            // Do not allow transfer to 0x0 or the token contract itself
404            require((_to != 0) && (_to != address(this)));
405 
406            // If the amount being transfered is more than the balance of the
407            //  account the transfer returns false
408            var previousBalanceFrom = balanceOfAt(_from, block.number);
409            if (previousBalanceFrom < _amount) {
410                return false;
411            }
412 
413            // Alerts the token controller of the transfer
414            if (isContract(controller)) {
415                require(TokenController(controller).onTransfer(_from, _to, _amount));
416            }
417 
418            // First update the balance array with the new value for the address
419            //  sending the tokens
420            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
421 
422            // Then update the balance array with the new value for the address
423            //  receiving the tokens
424            var previousBalanceTo = balanceOfAt(_to, block.number);
425            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
426            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
427 
428            // An event to make the transfer easy to find on the blockchain
429            Transfer(_from, _to, _amount);
430 
431            return true;
432     }
433 
434     /// @param _owner The address that's balance is being requested
435     /// @return The balance of `_owner` at the current block
436     function balanceOf(address _owner) constant returns (uint256 balance) {
437         return balanceOfAt(_owner, block.number);
438     }
439 
440     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
441     ///  its behalf. This is a modified version of the ERC20 approve function
442     ///  to be a little bit safer
443     /// @param _spender The address of the account able to transfer the tokens
444     /// @param _amount The amount of tokens to be approved for transfer
445     /// @return True if the approval was successful
446     function approve(address _spender, uint256 _amount) returns (bool success) {
447         require(transfersEnabled);
448 
449         // To change the approve amount you first have to reduce the addresses`
450         //  allowance to zero by calling `approve(_spender,0)` if it is not
451         //  already 0 to mitigate the race condition described here:
452         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
453         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
454 
455         // Alerts the token controller of the approve function call
456         if (isContract(controller)) {
457             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
458         }
459 
460         allowed[msg.sender][_spender] = _amount;
461         Approval(msg.sender, _spender, _amount);
462         return true;
463     }
464 
465     /// @dev This function makes it easy to read the `allowed[]` map
466     /// @param _owner The address of the account that owns the token
467     /// @param _spender The address of the account able to transfer the tokens
468     /// @return Amount of remaining tokens of _owner that _spender is allowed
469     ///  to spend
470     function allowance(address _owner, address _spender
471     ) constant returns (uint256 remaining) {
472         return allowed[_owner][_spender];
473     }
474 
475     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
476     ///  its behalf, and then a function is triggered in the contract that is
477     ///  being approved, `_spender`. This allows users to use their tokens to
478     ///  interact with contracts in one function call instead of two
479     /// @param _spender The address of the contract able to transfer the tokens
480     /// @param _amount The amount of tokens to be approved for transfer
481     /// @return True if the function call was successful
482     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
483     ) returns (bool success) {
484         require(approve(_spender, _amount));
485 
486         ApproveAndCallFallBack(_spender).receiveApproval(
487             msg.sender,
488             _amount,
489             this,
490             _extraData
491         );
492 
493         return true;
494     }
495 
496     /// @dev This function makes it easy to get the total number of tokens
497     /// @return The total number of tokens
498     function totalSupply() constant returns (uint) {
499         return totalSupplyAt(block.number);
500     }
501 
502 
503 ////////////////
504 // Query balance and totalSupply in History
505 ////////////////
506 
507     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
508     /// @param _owner The address from which the balance will be retrieved
509     /// @param _blockNumber The block number when the balance is queried
510     /// @return The balance at `_blockNumber`
511     function balanceOfAt(address _owner, uint _blockNumber) constant
512         returns (uint) {
513 
514         // These next few lines are used when the balance of the token is
515         //  requested before a check point was ever created for this token, it
516         //  requires that the `parentToken.balanceOfAt` be queried at the
517         //  genesis block for that token as this contains initial balance of
518         //  this token
519         if ((balances[_owner].length == 0)
520             || (balances[_owner][0].fromBlock > _blockNumber)) {
521             if (address(parentToken) != 0) {
522                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
523             } else {
524                 // Has no parent
525                 return 0;
526             }
527 
528         // This will return the expected balance during normal situations
529         } else {
530             return getValueAt(balances[_owner], _blockNumber);
531         }
532     }
533 
534     /// @notice Total amount of tokens at a specific `_blockNumber`.
535     /// @param _blockNumber The block number when the totalSupply is queried
536     /// @return The total amount of tokens at `_blockNumber`
537     function totalSupplyAt(uint _blockNumber) constant returns(uint) {
538 
539         // These next few lines are used when the totalSupply of the token is
540         //  requested before a check point was ever created for this token, it
541         //  requires that the `parentToken.totalSupplyAt` be queried at the
542         //  genesis block for this token as that contains totalSupply of this
543         //  token at this block number.
544         if ((totalSupplyHistory.length == 0)
545             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
546             if (address(parentToken) != 0) {
547                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
548             } else {
549                 return 0;
550             }
551 
552         // This will return the expected totalSupply during normal situations
553         } else {
554             return getValueAt(totalSupplyHistory, _blockNumber);
555         }
556     }
557 
558 ////////////////
559 // Clone Token Method
560 ////////////////
561 
562     /// @notice Creates a new clone token with the initial distribution being
563     ///  this token at `_snapshotBlock`
564     /// @param _cloneTokenName Name of the clone token
565     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
566     /// @param _cloneTokenSymbol Symbol of the clone token
567     /// @param _snapshotBlock Block when the distribution of the parent token is
568     ///  copied to set the initial distribution of the new clone token;
569     ///  if the block is zero than the actual block, the current block is used
570     /// @param _transfersEnabled True if transfers are allowed in the clone
571     /// @return The address of the new MiniMeToken Contract
572     function createCloneToken(
573         string _cloneTokenName,
574         uint8 _cloneDecimalUnits,
575         string _cloneTokenSymbol,
576         uint _snapshotBlock,
577         bool _transfersEnabled
578         ) returns(address) {
579         if (_snapshotBlock == 0) _snapshotBlock = block.number;
580         MiniMeToken cloneToken = tokenFactory.createCloneToken(
581             this,
582             _snapshotBlock,
583             _cloneTokenName,
584             _cloneDecimalUnits,
585             _cloneTokenSymbol,
586             _transfersEnabled
587             );
588 
589         cloneToken.changeController(msg.sender);
590 
591         // An event to make the token easy to find on the blockchain
592         NewCloneToken(address(cloneToken), _snapshotBlock);
593         return address(cloneToken);
594     }
595 
596 ////////////////
597 // Generate and destroy tokens
598 ////////////////
599 
600     /// @notice Generates `_amount` tokens that are assigned to `_owner`
601     /// @param _owner The address that will be assigned the new tokens
602     /// @param _amount The quantity of tokens generated
603     /// @return True if the tokens are generated correctly
604     function generateTokens(address _owner, uint _amount
605     ) onlyController returns (bool) {
606         uint curTotalSupply = totalSupply();
607         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
608         uint previousBalanceTo = balanceOf(_owner);
609         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
610         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
611         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
612         Transfer(0, _owner, _amount);
613         return true;
614     }
615 
616 
617     /// @notice Burns `_amount` tokens from `_owner`
618     /// @param _owner The address that will lose the tokens
619     /// @param _amount The quantity of tokens to burn
620     /// @return True if the tokens are burned correctly
621     function destroyTokens(address _owner, uint _amount
622     ) onlyController returns (bool) {
623         uint curTotalSupply = totalSupply();
624         require(curTotalSupply >= _amount);
625         uint previousBalanceFrom = balanceOf(_owner);
626         require(previousBalanceFrom >= _amount);
627         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
628         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
629         Transfer(_owner, 0, _amount);
630         return true;
631     }
632 
633 ////////////////
634 // Enable tokens transfers
635 ////////////////
636 
637 
638     /// @notice Enables token holders to transfer their tokens freely if true
639     /// @param _transfersEnabled True if transfers are allowed in the clone
640     function enableTransfers(bool _transfersEnabled) onlyController {
641         transfersEnabled = _transfersEnabled;
642     }
643 
644 ////////////////
645 // Internal helper functions to query and set a value in a snapshot array
646 ////////////////
647 
648     /// @dev `getValueAt` retrieves the number of tokens at a given block number
649     /// @param checkpoints The history of values being queried
650     /// @param _block The block number to retrieve the value at
651     /// @return The number of tokens being queried
652     function getValueAt(Checkpoint[] storage checkpoints, uint _block
653     ) constant internal returns (uint) {
654         if (checkpoints.length == 0) return 0;
655 
656         // Shortcut for the actual value
657         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
658             return checkpoints[checkpoints.length-1].value;
659         if (_block < checkpoints[0].fromBlock) return 0;
660 
661         // Binary search of the value in the array
662         uint min = 0;
663         uint max = checkpoints.length-1;
664         while (max > min) {
665             uint mid = (max + min + 1)/ 2;
666             if (checkpoints[mid].fromBlock<=_block) {
667                 min = mid;
668             } else {
669                 max = mid-1;
670             }
671         }
672         return checkpoints[min].value;
673     }
674 
675     /// @dev `updateValueAtNow` used to update the `balances` map and the
676     ///  `totalSupplyHistory`
677     /// @param checkpoints The history of data being updated
678     /// @param _value The new number of tokens
679     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
680     ) internal  {
681         if ((checkpoints.length == 0)
682         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
683                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
684                newCheckPoint.fromBlock =  uint128(block.number);
685                newCheckPoint.value = uint128(_value);
686            } else {
687                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
688                oldCheckPoint.value = uint128(_value);
689            }
690     }
691 
692     /// @dev Internal function to determine if an address is a contract
693     /// @param _addr The address being queried
694     /// @return True if `_addr` is a contract
695     function isContract(address _addr) constant internal returns(bool) {
696         uint size;
697         if (_addr == 0) return false;
698         assembly {
699             size := extcodesize(_addr)
700         }
701         return size>0;
702     }
703 
704     /// @dev Helper function to return a min betwen the two uints
705     function min(uint a, uint b) internal returns (uint) {
706         return a < b ? a : b;
707     }
708 
709     /// @notice The fallback function: If the contract's controller has not been
710     ///  set to 0, then the `proxyPayment` method is called which relays the
711     ///  ether and creates tokens as described in the token controller contract
712     function ()  payable {
713         require(isContract(controller));
714         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
715     }
716 
717 //////////
718 // Safety Methods
719 //////////
720 
721     /// @notice This method can be used by the controller to extract mistakenly
722     ///  sent tokens to this contract.
723     /// @param _token The address of the token contract that you want to recover
724     ///  set to 0 in case you want to extract ether.
725     function claimTokens(address _token) onlyController {
726         if (_token == 0x0) {
727             controller.transfer(this.balance);
728             return;
729         }
730 
731         MiniMeToken token = MiniMeToken(_token);
732         uint balance = token.balanceOf(this);
733         token.transfer(controller, balance);
734         ClaimedTokens(_token, controller, balance);
735     }
736 
737 ////////////////
738 // Events
739 ////////////////
740     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
741     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
742     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
743     event Approval(
744         address indexed _owner,
745         address indexed _spender,
746         uint256 _amount
747         );
748 
749 }
750 
751 
752 ////////////////
753 // MiniMeTokenFactory
754 ////////////////
755 
756 /// @dev This contract is used to generate clone contracts from a contract.
757 ///  In solidity this is the way to create a contract from a contract of the
758 ///  same class
759 contract MiniMeTokenFactory {
760 
761     /// @notice Update the DApp by creating a new token with new functionalities
762     ///  the msg.sender becomes the controller of this clone token
763     /// @param _parentToken Address of the token being cloned
764     /// @param _snapshotBlock Block of the parent token that will
765     ///  determine the initial distribution of the clone token
766     /// @param _tokenName Name of the new token
767     /// @param _decimalUnits Number of decimals of the new token
768     /// @param _tokenSymbol Token Symbol for the new token
769     /// @param _transfersEnabled If true, tokens will be able to be transferred
770     /// @return The address of the new token contract
771     function createCloneToken(
772         address _parentToken,
773         uint _snapshotBlock,
774         string _tokenName,
775         uint8 _decimalUnits,
776         string _tokenSymbol,
777         bool _transfersEnabled
778     ) returns (MiniMeToken) {
779         MiniMeToken newToken = new MiniMeToken(
780             this,
781             _parentToken,
782             _snapshotBlock,
783             _tokenName,
784             _decimalUnits,
785             _tokenSymbol,
786             _transfersEnabled
787             );
788 
789         newToken.changeController(msg.sender);
790         return newToken;
791     }
792 }
793 
794 // File: contracts/InvestorWalletFactory.sol
795 
796 contract InvestorWalletFactory is InvestorWalletFactoryI, Ownable {
797   MiniMeToken public wct2;
798 
799   function InvestorWalletFactory(address _wct2) public {
800     wct2 = MiniMeToken(_wct2);
801   }
802 
803   function createInvestorWallet(
804       uint256 _monthsToRelease,
805       address _investor,
806       uint256 _amount
807   ) onlyOwner returns (InvestorWallet) {
808     InvestorWallet newWallet = new InvestorWallet(
809       address(wct2),
810       address(this),
811       _monthsToRelease
812     );
813 
814     newWallet.transferOwnership(_investor);
815     wct2.generateTokens(newWallet, _amount);
816     return newWallet;
817   }
818 
819   function setExchanger(address _exchanger) public onlyOwner {
820     exchanger = _exchanger;
821   }
822 
823   function retrieveWCT2() public onlyOwner {
824     wct2.changeController(msg.sender);
825   }
826 }