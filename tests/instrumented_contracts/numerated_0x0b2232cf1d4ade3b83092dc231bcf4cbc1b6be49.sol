1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Controlled
5  * @dev Restricts execution of modified functions to the contract controller alone
6  */
7 contract Controlled {
8   address public controller;
9 
10   function Controlled() public {
11     controller = msg.sender;
12   }
13 
14   modifier onlyController {
15     require(msg.sender == controller);
16     _;
17   }
18 
19   function transferControl(address newController) public onlyController{
20     controller = newController;
21   }
22 } 
23 
24 
25 
26 
27 
28 /// @title MiniMeToken Contract
29 /// @author Jordi Baylina
30 /// @dev This token contract's goal is to make it easy for anyone to clone this
31 ///  token using the token distribution at a given block, this will allow DAO's
32 ///  and DApps to upgrade their features in a decentralized manner without
33 ///  affecting the original token
34 /// @dev It is ERC20 compliant, but still needs to under go further testing.
35 
36 
37 //import "./TokenController.sol";
38 
39 contract ApproveAndCallFallBack {
40     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
41 }
42 
43 /// @dev The actual token contract, the default controller is the msg.sender
44 ///  that deploys the contract, so usually this token will be deployed by a
45 ///  token controller contract, which Giveth will call a "Campaign"
46 contract MiniMeToken is Controlled {
47 
48     string public name;                //The Token's name: e.g. DigixDAO Tokens
49     uint8 public decimals;             //Number of decimals of the smallest unit
50     string public symbol;              //An identifier: e.g. REP
51 
52 
53     /// @dev `Checkpoint` is the structure that attaches a block number to a
54     ///  given value, the block number attached is the one that last changed the
55     ///  value
56     struct  Checkpoint {
57 
58         // `fromBlock` is the block number that the value was generated from
59         uint128 fromBlock;
60 
61         // `value` is the amount of tokens at a specific block number
62         uint128 value;
63     }
64 
65     // `parentToken` is the Token address that was cloned to produce this token;
66     //  it will be 0x0 for a token that was not cloned
67     MiniMeToken public parentToken;
68 
69     // `parentSnapShotBlock` is the block number from the Parent Token that was
70     //  used to determine the initial distribution of the Clone Token
71     uint public parentSnapShotBlock;
72 
73     // `creationBlock` is the block number that the Clone Token was created
74     uint public creationBlock;
75 
76     // `balances` is the map that tracks the balance of each address, in this
77     //  contract when the balance changes the block number that the change
78     //  occurred is also included in the map
79     mapping (address => Checkpoint[]) balances;
80 
81     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
82     mapping (address => mapping (address => uint256)) allowed;
83 
84     // Tracks the history of the `totalSupply` of the token
85     Checkpoint[] totalSupplyHistory;
86 
87     // Flag that determines if the token is transferable or not.
88     bool public transfersEnabled;
89 
90     // The factory used to create new clone tokens
91     MiniMeTokenFactory public tokenFactory;
92 
93 ////////////////
94 // Constructor
95 ////////////////
96 
97     /// @notice Constructor to create a MiniMeToken
98     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
99     ///  will create the Clone token contracts, the token factory needs to be
100     ///  deployed first
101     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
102     ///  new token
103     /// @param _parentSnapShotBlock Block of the parent token that will
104     ///  determine the initial distribution of the clone token, set to 0 if it
105     ///  is a new token
106     /// @param _tokenName Name of the new token
107     /// @param _decimalUnits Number of decimals of the new token
108     /// @param _tokenSymbol Token Symbol for the new token
109     /// @param _transfersEnabled If true, tokens will be able to be transferred
110     function MiniMeToken(
111         address _tokenFactory,
112         address _parentToken,
113         uint _parentSnapShotBlock,
114         string _tokenName,
115         uint8 _decimalUnits,
116         string _tokenSymbol,
117         bool _transfersEnabled
118     ) public {
119         tokenFactory = MiniMeTokenFactory(_tokenFactory);
120         name = _tokenName;                                 // Set the name
121         decimals = _decimalUnits;                          // Set the decimals
122         symbol = _tokenSymbol;                             // Set the symbol
123         parentToken = MiniMeToken(_parentToken);
124         parentSnapShotBlock = _parentSnapShotBlock;
125         transfersEnabled = _transfersEnabled;
126         creationBlock = block.number;
127     }
128 
129 
130 ///////////////////
131 // ERC20 Methods
132 ///////////////////
133 
134     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
135     /// @param _to The address of the recipient
136     /// @param _amount The amount of tokens to be transferred
137     /// @return Whether the transfer was successful or not
138     function transfer(address _to, uint256 _amount) public returns (bool success) {
139         require(transfersEnabled);
140         return doTransfer(msg.sender, _to, _amount);
141     }
142 
143     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
144     ///  is approved by `_from`
145     /// @param _from The address holding the tokens being transferred
146     /// @param _to The address of the recipient
147     /// @param _amount The amount of tokens to be transferred
148     /// @return True if the transfer was successful
149     function transferFrom(address _from, address _to, uint256 _amount
150     ) public returns (bool success) {
151 
152         // The controller of this contract can move tokens around at will,
153         //  this is important to recognize! Confirm that you trust the
154         //  controller of this contract, which in most situations should be
155         //  another open source smart contract or 0x0
156         if (msg.sender != controller) {
157             require(transfersEnabled);
158 
159             // The standard ERC 20 transferFrom functionality
160             if (allowed[_from][msg.sender] < _amount) return false;
161             allowed[_from][msg.sender] -= _amount;
162         }
163         return doTransfer(_from, _to, _amount);
164     }
165 
166     /// @dev This is the actual transfer function in the token contract, it can
167     ///  only be called by other functions in this contract.
168     /// @param _from The address holding the tokens being transferred
169     /// @param _to The address of the recipient
170     /// @param _amount The amount of tokens to be transferred
171     /// @return True if the transfer was successful
172     function doTransfer(address _from, address _to, uint _amount
173     ) internal returns(bool) {
174 
175            if (_amount == 0) {
176                return true;
177            }
178 
179            require(parentSnapShotBlock < block.number);
180 
181            // Do not allow transfer to 0x0 or the token contract itself
182            require((_to != address(0x0)) && (_to != address(this)));
183 
184            // If the amount being transfered is more than the balance of the
185            //  account the transfer returns false
186            var previousBalanceFrom = balanceOfAt(_from, block.number);
187            if (previousBalanceFrom < _amount) {
188                return false;
189            }
190 
191            // Alerts the token controller of the transfer
192            // if (isContract(controller)) {
193                // require(TokenController(controller).onTransfer(_from, _to, _amount));
194            // }
195 
196            // First update the balance array with the new value for the address
197            //  sending the tokens
198            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
199 
200            // Then update the balance array with the new value for the address
201            //  receiving the tokens
202            var previousBalanceTo = balanceOfAt(_to, block.number);
203            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
204            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
205 
206            // An event to make the transfer easy to find on the blockchain
207            Transfer(_from, _to, _amount);
208 
209            return true;
210     }
211 
212     /// @param _owner The address that's balance is being requested
213     /// @return The balance of `_owner` at the current block
214     function balanceOf(address _owner) public constant returns (uint256 balance) {
215         return balanceOfAt(_owner, block.number);
216     }
217 
218     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
219     ///  its behalf. This is a modified version of the ERC20 approve function
220     ///  to be a little bit safer
221     /// @param _spender The address of the account able to transfer the tokens
222     /// @param _amount The amount of tokens to be approved for transfer
223     /// @return True if the approval was successful
224     function approve(address _spender, uint256 _amount) public returns (bool success) {
225         require(transfersEnabled);
226 
227         // To change the approve amount you first have to reduce the addresses`
228         //  allowance to zero by calling `approve(_spender,0)` if it is not
229         //  already 0 to mitigate the race condition described here:
230         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
231         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
232 
233         // Alerts the token controller of the approve function call
234         // if (isContract(controller)) {
235             // require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
236         // }
237 
238         allowed[msg.sender][_spender] = _amount;
239         Approval(msg.sender, _spender, _amount);
240         return true;
241     }
242 
243     /// @dev This function makes it easy to read the `allowed[]` map
244     /// @param _owner The address of the account that owns the token
245     /// @param _spender The address of the account able to transfer the tokens
246     /// @return Amount of remaining tokens of _owner that _spender is allowed
247     ///  to spend
248     function allowance(address _owner, address _spender
249     ) public constant returns (uint256 remaining) {
250         return allowed[_owner][_spender];
251     }
252 
253     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
254     ///  its behalf, and then a function is triggered in the contract that is
255     ///  being approved, `_spender`. This allows users to use their tokens to
256     ///  interact with contracts in one function call instead of two
257     /// @param _spender The address of the contract able to transfer the tokens
258     /// @param _amount The amount of tokens to be approved for transfer
259     /// @return True if the function call was successful
260     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
261     ) public returns (bool success) {
262         require(approve(_spender, _amount));
263 
264         ApproveAndCallFallBack(_spender).receiveApproval(
265             msg.sender,
266             _amount,
267             this,
268             _extraData
269         );
270 
271         return true;
272     }
273 
274     /// @dev This function makes it easy to get the total number of tokens
275     /// @return The total number of tokens
276     function totalSupply() public constant returns (uint) {
277         return totalSupplyAt(block.number);
278     }
279 
280 
281 ////////////////
282 // Query balance and totalSupply in History
283 ////////////////
284 
285     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
286     /// @param _owner The address from which the balance will be retrieved
287     /// @param _blockNumber The block number when the balance is queried
288     /// @return The balance at `_blockNumber`
289     function balanceOfAt(address _owner, uint _blockNumber) public constant
290         returns (uint) {
291 
292         // These next few lines are used when the balance of the token is
293         //  requested before a check point was ever created for this token, it
294         //  requires that the `parentToken.balanceOfAt` be queried at the
295         //  genesis block for that token as this contains initial balance of
296         //  this token
297         if ((balances[_owner].length == 0)
298             || (balances[_owner][0].fromBlock > _blockNumber)) {
299             if (address(parentToken) != 0) {
300                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
301             } else {
302                 // Has no parent
303                 return 0;
304             }
305 
306         // This will return the expected balance during normal situations
307         } else {
308             return getValueAt(balances[_owner], _blockNumber);
309         }
310     }
311 
312     /// @notice Total amount of tokens at a specific `_blockNumber`.
313     /// @param _blockNumber The block number when the totalSupply is queried
314     /// @return The total amount of tokens at `_blockNumber`
315     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
316 
317         // These next few lines are used when the totalSupply of the token is
318         //  requested before a check point was ever created for this token, it
319         //  requires that the `parentToken.totalSupplyAt` be queried at the
320         //  genesis block for this token as that contains totalSupply of this
321         //  token at this block number.
322         if ((totalSupplyHistory.length == 0)
323             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
324             if (address(parentToken) != 0) {
325                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
326             } else {
327                 return 0;
328             }
329 
330         // This will return the expected totalSupply during normal situations
331         } else {
332             return getValueAt(totalSupplyHistory, _blockNumber);
333         }
334     }
335 
336 ////////////////
337 // Clone Token Method
338 ////////////////
339 
340     /// @notice Creates a new clone token with the initial distribution being
341     ///  this token at `_snapshotBlock`
342     /// @param _cloneTokenName Name of the clone token
343     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
344     /// @param _cloneTokenSymbol Symbol of the clone token
345     /// @param _snapshotBlock Block when the distribution of the parent token is
346     ///  copied to set the initial distribution of the new clone token;
347     ///  if the block is zero than the actual block, the current block is used
348     /// @param _transfersEnabled True if transfers are allowed in the clone
349     /// @return The address of the new MiniMeToken Contract
350     function createCloneToken(
351         string _cloneTokenName,
352         uint8 _cloneDecimalUnits,
353         string _cloneTokenSymbol,
354         uint _snapshotBlock,
355         bool _transfersEnabled
356         ) public returns(address) {            
357         if (_snapshotBlock == 0) _snapshotBlock = block.number;
358         MiniMeToken cloneToken = tokenFactory.createCloneToken(
359             this,
360             _snapshotBlock,
361             _cloneTokenName,
362             _cloneDecimalUnits,
363             _cloneTokenSymbol,
364             _transfersEnabled
365             );
366 
367         cloneToken.transferControl(msg.sender);
368 
369         // An event to make the token easy to find on the blockchain
370         NewCloneToken(address(cloneToken), _snapshotBlock);
371         return address(cloneToken);
372     }
373 
374 ////////////////
375 // Generate and destroy tokens
376 ////////////////
377 
378     /// @notice Generates `_amount` tokens that are assigned to `_owner`
379     /// @param _owner The address that will be assigned the new tokens
380     /// @param _amount The quantity of tokens generated
381     /// @return True if the tokens are generated correctly
382     function generateTokens(address _owner, uint _amount
383     ) public onlyController returns (bool) {
384         uint curTotalSupply = totalSupply();
385         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
386         uint previousBalanceTo = balanceOf(_owner);
387         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
388         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
389         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
390         Transfer(address(0x0), _owner, _amount);
391         return true;
392     }
393 
394 
395     /// @notice Burns `_amount` tokens from `_owner`
396     /// @param _owner The address that will lose the tokens
397     /// @param _amount The quantity of tokens to burn
398     /// @return True if the tokens are burned correctly
399     function destroyTokens(address _owner, uint _amount
400     ) onlyController public returns (bool) {
401         uint curTotalSupply = totalSupply();
402         require(curTotalSupply >= _amount);
403         uint previousBalanceFrom = balanceOf(_owner);
404         require(previousBalanceFrom >= _amount);
405         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
406         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
407         Transfer(_owner, address(0x0), _amount);
408         return true;
409     }
410 
411 ////////////////
412 // Enable tokens transfers
413 ////////////////
414 
415 
416     /// @notice Enables token holders to transfer their tokens freely if true
417     /// @param _transfersEnabled True if transfers are allowed in the clone
418     function enableTransfers(bool _transfersEnabled) public onlyController {
419         transfersEnabled = _transfersEnabled;
420     }
421 
422 ////////////////
423 // Internal helper functions to query and set a value in a snapshot array
424 ////////////////
425 
426     /// @dev `getValueAt` retrieves the number of tokens at a given block number
427     /// @param checkpoints The history of values being queried
428     /// @param _block The block number to retrieve the value at
429     /// @return The number of tokens being queried
430     function getValueAt(Checkpoint[] storage checkpoints, uint _block
431     ) constant internal returns (uint) {
432         if (checkpoints.length == 0) return 0;
433 
434         // Shortcut for the actual value
435         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
436             return checkpoints[checkpoints.length-1].value;
437         if (_block < checkpoints[0].fromBlock) return 0;
438 
439         // Binary search of the value in the array
440         uint min = 0;
441         uint max = checkpoints.length-1;
442         while (max > min) {
443             uint mid = (max + min + 1)/ 2;
444             if (checkpoints[mid].fromBlock<=_block) {
445                 min = mid;
446             } else {
447                 max = mid-1;
448             }
449         }
450         return checkpoints[min].value;
451     }
452 
453     /// @dev `updateValueAtNow` used to update the `balances` map and the
454     ///  `totalSupplyHistory`
455     /// @param checkpoints The history of data being updated
456     /// @param _value The new number of tokens
457     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
458     ) internal  {
459         if ((checkpoints.length == 0)
460         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
461                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
462                newCheckPoint.fromBlock =  uint128(block.number);
463                newCheckPoint.value = uint128(_value);
464            } else {
465                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
466                oldCheckPoint.value = uint128(_value);
467            }
468     }
469 
470     /// @dev Internal function to determine if an address is a contract
471     /// @param _addr The address being queried
472     /// @return True if `_addr` is a contract
473     function isContract(address _addr) constant internal returns(bool) {
474         uint size;
475         if (_addr == address(0x0)) return false;
476         assembly {
477             size := extcodesize(_addr)
478         }
479         return size>0;
480     }
481 
482     /// @dev Helper function to return a min betwen the two uints
483     function min(uint a, uint b) pure internal returns (uint) {
484         return a < b ? a : b;
485     }
486 
487     /// @notice The fallback function: If the contract's controller has not been
488     ///  set to 0, then the `proxyPayment` method is called which relays the
489     ///  ether and creates tokens as described in the token controller contract
490     // function () public payable {
491         // require(isContract(controller));
492         // require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
493     // }
494 
495 //////////
496 // Safety Methods
497 //////////
498 
499     /// @notice This method can be used by the controller to extract mistakenly
500     ///  sent tokens to this contract.
501     /// @param _token The address of the token contract that you want to recover
502     ///  set to 0 in case you want to extract ether.
503     function claimTokens(address _token) public onlyController {
504         if (_token == address(0x0)) {
505             controller.transfer(this.balance);
506             return;
507         }
508 
509         MiniMeToken token = MiniMeToken(_token);
510         uint balance = token.balanceOf(this);
511         token.transfer(controller, balance);
512         ClaimedTokens(_token, controller, balance);
513     }
514 
515 ////////////////
516 // Events
517 ////////////////
518     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
519     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
520     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
521     event Approval(
522         address indexed _owner,
523         address indexed _spender,
524         uint256 _amount
525         );
526 
527 }
528 
529 
530 ////////////////
531 // MiniMeTokenFactory
532 ////////////////
533 
534 /// @dev This contract is used to generate clone contracts from a contract.
535 ///  In solidity this is the way to create a contract from a contract of the
536 ///  same class
537 contract MiniMeTokenFactory {
538 
539     /// @notice Update the DApp by creating a new token with new functionalities
540     ///  the msg.sender becomes the controller of this clone token
541     /// @param _parentToken Address of the token being cloned
542     /// @param _snapshotBlock Block of the parent token that will
543     ///  determine the initial distribution of the clone token
544     /// @param _tokenName Name of the new token
545     /// @param _decimalUnits Number of decimals of the new token
546     /// @param _tokenSymbol Token Symbol for the new token
547     /// @param _transfersEnabled If true, tokens will be able to be transferred
548     /// @return The address of the new token contract
549     function createCloneToken(
550         address _parentToken,
551         uint _snapshotBlock,
552         string _tokenName,
553         uint8 _decimalUnits,
554         string _tokenSymbol,
555         bool _transfersEnabled
556     ) public returns (MiniMeToken) {
557         MiniMeToken newToken = new MiniMeToken(
558             this,
559             _parentToken,
560             _snapshotBlock,
561             _tokenName,
562             _decimalUnits,
563             _tokenSymbol,
564             _transfersEnabled
565             );
566 
567         newToken.transferControl(msg.sender);
568         return newToken;
569     }
570 }
571 
572 
573 /**
574  * @title SafeMath
575  * @dev Math operations that are safe for uint256 against overflow and negative values
576  * @dev https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
577  */
578 
579 
580 library SafeMath {
581   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
582     if (a == 0) {
583       return 0;
584     }
585     uint256 c = a * b;
586     assert(c / a == b);
587     return c;
588   }
589 
590   function div(uint256 a, uint256 b) internal pure returns (uint256) {
591     // assert(b > 0); // Solidity automatically throws when dividing by 0
592     uint256 c = a / b;
593     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
594     return c;
595   }
596 
597   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
598     assert(b <= a);
599     return a - b;
600   }
601 
602   function add(uint256 a, uint256 b) internal pure returns (uint256) {
603     uint256 c = a + b;
604     assert(c >= a);
605     return c;
606   }
607 }
608 
609 
610 
611 
612 
613 /**
614  * @title Pausable
615  * @dev Base contract which allows children to implement an emergency stop mechanism.
616  */
617 contract Pausable is Controlled {
618   event Pause();
619   event Unpause();
620 
621   bool public paused = false;
622 
623 
624   /**
625    * @dev Modifier to make a function callable only when the contract is not paused.
626    */
627   modifier whenNotPaused() {
628     require(!paused);
629     _;
630   }
631 
632   /**
633    * @dev Modifier to make a function callable only when the contract is paused.
634    */
635   modifier whenPaused() {
636     require(paused);
637     _;
638   }
639 
640   /**
641    * @dev called by the owner to pause, triggers stopped state
642    */
643   function pause() onlyController whenNotPaused public {
644     paused = true;
645     Pause();
646   }
647 
648   /**
649    * @dev called by the owner to unpause, returns to normal state
650    */
651   function unpause() onlyController whenPaused public {
652     paused = false;
653     Unpause();
654   }
655 }
656 
657 contract CrowdSale is Pausable {
658     using SafeMath for uint256;
659     
660     uint256 public startFundingTime = 1517990460; // Feb 7, 2018 @ 08h01 UTC == 00h01 PDT        
661     uint256 public endFundingTime = 1523779200;   // Apr 15, 2018 @ 08h00 UTC == 08h00 PDT
662         
663     uint256 public totalEtherCollected;           // In wei
664     uint256 public totalTokensSold;               // KISSES tokens sold
665     
666     uint256 public etherToUSDrate = 800;          // Default exchange rate 
667     
668     MiniMeToken public tokenContract;             // The  token for this CrowdSale
669     
670     address public etherVault = 0x674552169ec1683Aa26aa7406337FAc67BF31ED5; // The address holding the Ether received
671     address public unsoldTokensVault = 0x5316e0A703a584ECa2e95B73B4E6dB8E98E089e0; // The address where all unsold tokens will be sent to
672  
673     address public tokenVault;                    // The address holding the KISSES tokens for sale
674     
675     // Logs purchaser address and investment amount - to be used to track top 100 investors
676     event Purchase(address investor, uint256 weiReceived, uint256 tokensSold);
677     
678     // Constructor - takes address of token contract as parameter
679     // Assumes msg.sender is address of the tokenVault <==> msg.sender also deployed tokenContract
680     function CrowdSale(address _tokenAddress) public {
681         require (_tokenAddress != address(0));            
682         
683         tokenContract = MiniMeToken(_tokenAddress);     
684 
685         tokenVault = msg.sender;
686     }
687     
688     // Fallback function invokes internal doPayment method
689     function () public whenNotPaused payable {
690         doPayment(msg.sender);
691     }
692     
693     // Internal logic that processes payments
694     function doPayment(address _owner) internal {
695 
696         // First check that the Campaign is allowed to receive this donation
697         require ((now >= startFundingTime) && (now <= endFundingTime) && (msg.value != 0));
698         
699         // Calculate the number of tokens purchased and the dollar amount thereof
700         uint256 tokens = calculateTokens(msg.value);
701            
702         // Track how much Ether the campaign has collected
703         totalEtherCollected = totalEtherCollected.add(msg.value);
704         // Track how many KISSES tokens the campaign has sold
705         totalTokensSold = totalTokensSold.add(tokens);        
706 
707         // Send the ether to the etherVault
708         require (etherVault.send(msg.value));
709 
710         // Transfer tokens from tokenVault to the _owner address
711         // Will throw if tokens exceeds balance in remaining in tokenVault
712         require (tokenContract.transferFrom(tokenVault, _owner, tokens));
713         
714         // Emit the Purchase event 
715         Purchase(_owner, msg.value, tokens);
716         
717         return;
718     }
719     
720     // Handles the bonus logic & conversion from Ether's 18 decimal places to 5 decimals for the KISSES token
721     function calculateTokens(uint256 _wei) internal view returns (uint256) {
722  
723         uint256 weiAmount = _wei;
724         uint256 USDamount = (weiAmount.mul(etherToUSDrate)).div(10**14); // preserves 4 decimal places
725 
726         uint256 purchaseAmount; 
727         uint256 withBonus;
728  
729         // if purchase made between 07 & 14 February 2018
730         if(now < 1518595200) {
731             purchaseAmount = USDamount; // 1 Token == 1 USD
732             // minimum purchase of one token, maximum of three hundred and fifty thousand
733             if(purchaseAmount < 10000 || purchaseAmount > 3500000000) {
734                  revert();
735             }
736             else {
737                  withBonus = purchaseAmount.mul(19); // 90% bonus for the whole week
738                  return withBonus;
739             }   
740         }
741  
742         // if purchase made between 14 & 15 February 2018
743         else if(now >= 1518595200 && now < 1518681600) {
744             purchaseAmount = USDamount; // 1 Token == 1 USD
745             // minimum purchase of one token, maximum of three hundred and fifty thousand
746             if(purchaseAmount < 10000 || purchaseAmount > 3500000000) {
747                  revert();
748             }
749             else {
750                  withBonus = purchaseAmount.mul(18); // 80% bonus for the whole of Valentine's Day
751                  return withBonus;
752             }   
753         }
754 
755         // if purchase made between 15 February and 21 February
756         else if(now >= 1518681600 && now < 1519286400) {
757             purchaseAmount = USDamount; // 1 Token == 1 USD
758             // minimum purchase of one token, maximum of three hundred and fifty thousand
759             if(purchaseAmount < 10000 || purchaseAmount > 3500000000) {
760                 revert();
761             }     
762             else {
763                 if(weiAmount >= 500 finney && weiAmount < 1 ether) {
764                     withBonus = purchaseAmount.mul(11); // 10% bonus
765                     return withBonus;
766                 }
767                 else if(weiAmount >= 1 ether) {
768                     withBonus = purchaseAmount.mul(16); // 60% bonus
769                     return withBonus;                
770                 }
771                 else {
772                     withBonus = purchaseAmount.mul(10); // no bonus
773                     return withBonus;
774                 }
775             }
776         }
777 
778         // if purchase made between 22 February and 28 February
779         else if(now >= 1519286400 && now < 1519891200) {
780             purchaseAmount = USDamount; // 1 Token == 1 USD
781             // minimum purchase of one token, maximum of three hundred and fifty thousand
782             if(purchaseAmount < 10000 || purchaseAmount > 3500000000) {
783                 revert();
784             }
785             else {
786                 if(weiAmount >= 500 finney && weiAmount < 1 ether) {
787                     withBonus = purchaseAmount.mul(11); // 10% bonus
788                     return withBonus;
789                 }
790                 else if(weiAmount >= 1 ether) {
791                     withBonus = purchaseAmount.mul(15); // 50% bonus
792                     return withBonus;                
793                 }
794                 else {
795                     withBonus = purchaseAmount.mul(10); // no bonus
796                     return withBonus;
797                 }
798             }
799         }
800 
801         // if purchase made between 1 March and 14 March
802         else if(now >= 1519891200 && now < 1521100800) {
803             purchaseAmount = (USDamount.mul(10)).div(14); // 1 KISSES = 1.4 USD
804             if(purchaseAmount < 10000 || purchaseAmount > 3500000000) {
805                 revert();
806             }
807             else {
808                 if(weiAmount >= 500 finney && weiAmount < 1 ether) {
809                     withBonus = purchaseAmount.mul(11); // 10% bonus
810                     return withBonus;
811                 }
812                 else if(weiAmount >= 1 ether && weiAmount < 5 ether) {
813                     withBonus = purchaseAmount.mul(13); // 30% bonus
814                     return withBonus;
815                 }
816                 else if(weiAmount >= 5 ether && weiAmount < 8 ether) {
817                     withBonus = purchaseAmount.mul(14); // 40% bonus
818                     return withBonus;
819                 }              
820                 else if(weiAmount >= 8 ether) {
821                     withBonus = purchaseAmount.mul(15); // 50% bonus
822                     return withBonus;
823                 }
824                 else {
825                     withBonus = purchaseAmount.mul(10); // no bonus
826                     return withBonus;
827                 }              
828             }
829         }  
830 
831         // if purchase made between 15 March and 31 March
832         else if(now >= 1521100800 && now < 1522569600) {
833             purchaseAmount = (USDamount.mul(10)).div(19); // 1 KISSES = 1.9 USD
834             // minimum purchase of one token, maximum of three hundred and fifty thousand
835             if(purchaseAmount < 10000 || purchaseAmount > 3500000000) {
836                 revert();
837             }
838             else {
839                 if(weiAmount >= 500 finney && weiAmount < 1 ether) {
840                     withBonus = purchaseAmount.mul(11); // 10% bonus
841                     return withBonus;
842                 } 
843                 else if(weiAmount >= 1 ether && weiAmount < 5 ether) {
844                     withBonus = purchaseAmount.mul(13); // 30% bonus
845                     return withBonus;
846                 }
847                 else if(weiAmount >= 5 ether && weiAmount < 8 ether) {
848                     withBonus = purchaseAmount.mul(14); // 40% bonus
849                     return withBonus;               
850                 }              
851                 else if(weiAmount >= 8 ether) {
852                     withBonus = purchaseAmount.mul(15); // 50% bonus
853                     return withBonus;               
854                 }              
855                 else {
856                     withBonus = purchaseAmount.mul(10); // no bonus
857                     return withBonus;               
858                 }
859             }
860         }
861 
862         // if purchase made between 1 April and 14 April
863         else if(now > 1522569600 && now <= endFundingTime) {
864             purchaseAmount = (USDamount.mul(10)).div(27); // 1 KISSES = 2.7 USD
865             // minimum purchase of one token, maximum of three hundred and fifty thousand
866             if(purchaseAmount < 10000 || purchaseAmount > 3500000000) {
867                 revert();
868             }
869             else{
870                 if(weiAmount >= 500 finney && weiAmount < 1 ether) {
871                     withBonus = purchaseAmount.mul(11); // 10% bonus
872                     return withBonus;
873                 }
874                 else if(weiAmount >= 1 ether && weiAmount < 5 ether) {
875                     withBonus = purchaseAmount.mul(13); // 30% bonus
876                     return withBonus;               
877                 }
878                 else if(weiAmount >= 5 ether && weiAmount < 8 ether) {
879                     withBonus = purchaseAmount.mul(14); // 40% bonus
880                     return withBonus;               
881                 }              
882                 else if(weiAmount >= 8 ether) {
883                     withBonus = purchaseAmount.mul(15); // 50% bonus
884                     return withBonus;              
885                 }              
886                 else {
887                     withBonus = purchaseAmount.mul(10); // no bonus
888                     return withBonus;               
889                 }
890             }
891         }
892     }
893     
894     // Method to change the etherVault address
895     function setVault(address _newVaultAddress) public onlyController whenPaused {
896         etherVault = _newVaultAddress;
897     }
898     
899     // Method to change the Ether to Dollar exchange rate 
900     function setEthToUSDRate(uint256 _rate) public onlyController whenPaused {
901         etherToUSDrate = _rate;
902     }    
903         
904     // Wrap up CrowdSale and direct any ether stored in this contract to etherVault
905     function finalizeFunding() public onlyController {
906         require(now >= endFundingTime);
907         uint256 unsoldTokens = tokenContract.allowance(tokenVault, address(this));
908         if(unsoldTokens > 0) {
909             require (tokenContract.transferFrom(tokenVault, unsoldTokensVault, unsoldTokens));
910         }
911         selfdestruct(etherVault);
912     }
913     
914 }