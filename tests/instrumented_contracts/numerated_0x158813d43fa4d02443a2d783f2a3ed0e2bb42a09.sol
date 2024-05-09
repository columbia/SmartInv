1 library SafeMath {
2   function mul(uint a, uint b) internal returns (uint) {
3     uint c = a * b;
4     assert(a == 0 || c / a == b);
5     return c;
6   }
7 
8   function div(uint a, uint b) internal returns (uint) {
9     // assert(b > 0); // Solidity automatically throws when dividing by 0
10     uint c = a / b;
11     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
12     return c;
13   }
14 
15   function sub(uint a, uint b) internal returns (uint) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint a, uint b) internal returns (uint) {
21     uint c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 
26   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
27     return a >= b ? a : b;
28   }
29 
30   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
31     return a < b ? a : b;
32   }
33 
34   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
35     return a >= b ? a : b;
36   }
37 
38   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
39     return a < b ? a : b;
40   }
41 
42   function percent(uint a, uint b) internal returns (uint) {
43     uint c = a * b;
44     assert(a == 0 || c / a == b);
45     return c / 100;
46   }
47 }
48 
49 
50 /**
51  * @title ERC20Basic
52  * @dev Simpler version of ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/179
54  */
55 
56  /* from OpenZeppelin library */
57  /* https://github.com/OpenZeppelin/zeppelin-solidity */
58 
59 contract ERC20Basic {
60   uint256 public totalSupply;
61   function balanceOf(address who) constant returns (uint256);
62   function transfer(address to, uint256 value) returns (bool);
63   event Transfer(address indexed from, address indexed to, uint256 value);
64 }
65 
66 /// @dev The token controller contract must implement these functions
67 contract TokenController {
68     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
69     /// @param _owner The address that sent the ether to create tokens
70     /// @return True if the ether is accepted, false if it throws
71     function proxyPayment(address _owner) public payable returns(bool);
72 
73     /// @notice Notifies the controller about a token transfer allowing the
74     ///  controller to react if desired
75     /// @param _from The origin of the transfer
76     /// @param _to The destination of the transfer
77     /// @param _amount The amount of the transfer
78     /// @return False if the controller does not authorize the transfer
79     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
80 
81     /// @notice Notifies the controller about an approval allowing the
82     ///  controller to react if desired
83     /// @param _owner The address that calls `approve()`
84     /// @param _spender The spender in the `approve()` call
85     /// @param _amount The amount in the `approve()` call
86     /// @return False if the controller does not authorize the approval
87     function onApprove(address _owner, address _spender, uint _amount) public
88         returns(bool);
89 }
90 
91 contract Controlled {
92     /// @notice The address of the controller is the only address that can call
93     ///  a function with this modifier
94     modifier onlyController { require(msg.sender == controller); _; }
95 
96     address public controller;
97 
98     function Controlled() public { controller = msg.sender;}
99 
100     /// @notice Changes the controller of the contract
101     /// @param _newController The new controller of the contract
102     function changeController(address _newController) public onlyController {
103         controller = _newController;
104     }
105 }
106 
107 contract ApproveAndCallFallBack {
108     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
109 }
110 
111 /// @dev The actual token contract, the default controller is the msg.sender
112 ///  that deploys the contract, so usually this token will be deployed by a
113 ///  token controller contract, which Giveth will call a "Campaign"
114 contract MiniMeToken is Controlled {
115 
116     string public name;                //The Token's name: e.g. DigixDAO Tokens
117     uint8 public decimals;             //Number of decimals of the smallest unit
118     string public symbol;              //An identifier: e.g. REP
119     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
120 
121 
122     /// @dev `Checkpoint` is the structure that attaches a block number to a
123     ///  given value, the block number attached is the one that last changed the
124     ///  value
125     struct  Checkpoint {
126 
127         // `fromBlock` is the block number that the value was generated from
128         uint128 fromBlock;
129 
130         // `value` is the amount of tokens at a specific block number
131         uint128 value;
132     }
133 
134     // `parentToken` is the Token address that was cloned to produce this token;
135     //  it will be 0x0 for a token that was not cloned
136     MiniMeToken public parentToken;
137 
138     // `parentSnapShotBlock` is the block number from the Parent Token that was
139     //  used to determine the initial distribution of the Clone Token
140     uint public parentSnapShotBlock;
141 
142     // `creationBlock` is the block number that the Clone Token was created
143     uint public creationBlock;
144 
145     // `balances` is the map that tracks the balance of each address, in this
146     //  contract when the balance changes the block number that the change
147     //  occurred is also included in the map
148     mapping (address => Checkpoint[]) balances;
149 
150     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
151     mapping (address => mapping (address => uint256)) allowed;
152 
153     // Tracks the history of the `totalSupply` of the token
154     Checkpoint[] totalSupplyHistory;
155 
156     // Flag that determines if the token is transferable or not.
157     bool public transfersEnabled;
158 
159     // The factory used to create new clone tokens
160     MiniMeTokenFactory public tokenFactory;
161 
162 ////////////////
163 // Constructor
164 ////////////////
165 
166     /// @notice Constructor to create a MiniMeToken
167     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
168     ///  will create the Clone token contracts, the token factory needs to be
169     ///  deployed first
170     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
171     ///  new token
172     /// @param _parentSnapShotBlock Block of the parent token that will
173     ///  determine the initial distribution of the clone token, set to 0 if it
174     ///  is a new token
175     /// @param _tokenName Name of the new token
176     /// @param _decimalUnits Number of decimals of the new token
177     /// @param _tokenSymbol Token Symbol for the new token
178     /// @param _transfersEnabled If true, tokens will be able to be transferred
179     function MiniMeToken(
180         address _tokenFactory,
181         address _parentToken,
182         uint _parentSnapShotBlock,
183         string _tokenName,
184         uint8 _decimalUnits,
185         string _tokenSymbol,
186         bool _transfersEnabled
187     ) public {
188         tokenFactory = MiniMeTokenFactory(_tokenFactory);
189         name = _tokenName;                                 // Set the name
190         decimals = _decimalUnits;                          // Set the decimals
191         symbol = _tokenSymbol;                             // Set the symbol
192         parentToken = MiniMeToken(_parentToken);
193         parentSnapShotBlock = _parentSnapShotBlock;
194         transfersEnabled = _transfersEnabled;
195         creationBlock = block.number;
196     }
197 
198 
199 ///////////////////
200 // ERC20 Methods
201 ///////////////////
202 
203     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
204     /// @param _to The address of the recipient
205     /// @param _amount The amount of tokens to be transferred
206     /// @return Whether the transfer was successful or not
207     function transfer(address _to, uint256 _amount) public returns (bool success) {
208         require(transfersEnabled);
209         doTransfer(msg.sender, _to, _amount);
210         return true;
211     }
212 
213     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
214     ///  is approved by `_from`
215     /// @param _from The address holding the tokens being transferred
216     /// @param _to The address of the recipient
217     /// @param _amount The amount of tokens to be transferred
218     /// @return True if the transfer was successful
219     function transferFrom(address _from, address _to, uint256 _amount
220     ) public returns (bool success) {
221 
222         // The controller of this contract can move tokens around at will,
223         //  this is important to recognize! Confirm that you trust the
224         //  controller of this contract, which in most situations should be
225         //  another open source smart contract or 0x0
226         if (msg.sender != controller) {
227             require(transfersEnabled);
228 
229             // The standard ERC 20 transferFrom functionality
230             require(allowed[_from][msg.sender] >= _amount);
231             allowed[_from][msg.sender] -= _amount;
232         }
233         doTransfer(_from, _to, _amount);
234         return true;
235     }
236 
237     /// @dev This is the actual transfer function in the token contract, it can
238     ///  only be called by other functions in this contract.
239     /// @param _from The address holding the tokens being transferred
240     /// @param _to The address of the recipient
241     /// @param _amount The amount of tokens to be transferred
242     /// @return True if the transfer was successful
243     function doTransfer(address _from, address _to, uint _amount
244     ) internal {
245 
246            if (_amount == 0) {
247                Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
248                return;
249            }
250 
251            require(parentSnapShotBlock < block.number);
252 
253            // Do not allow transfer to 0x0 or the token contract itself
254            require((_to != 0) && (_to != address(this)));
255 
256            // If the amount being transfered is more than the balance of the
257            //  account the transfer throws
258            var previousBalanceFrom = balanceOfAt(_from, block.number);
259 
260            require(previousBalanceFrom >= _amount);
261 
262            // Alerts the token controller of the transfer
263            if (isContract(controller)) {
264                require(TokenController(controller).onTransfer(_from, _to, _amount));
265            }
266 
267            // First update the balance array with the new value for the address
268            //  sending the tokens
269            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
270 
271            // Then update the balance array with the new value for the address
272            //  receiving the tokens
273            var previousBalanceTo = balanceOfAt(_to, block.number);
274            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
275            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
276 
277            // An event to make the transfer easy to find on the blockchain
278            Transfer(_from, _to, _amount);
279 
280     }
281 
282     /// @param _owner The address that's balance is being requested
283     /// @return The balance of `_owner` at the current block
284     function balanceOf(address _owner) public constant returns (uint256 balance) {
285         return balanceOfAt(_owner, block.number);
286     }
287 
288     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
289     ///  its behalf. This is a modified version of the ERC20 approve function
290     ///  to be a little bit safer
291     /// @param _spender The address of the account able to transfer the tokens
292     /// @param _amount The amount of tokens to be approved for transfer
293     /// @return True if the approval was successful
294     function approve(address _spender, uint256 _amount) public returns (bool success) {
295         require(transfersEnabled);
296 
297         // To change the approve amount you first have to reduce the addresses`
298         //  allowance to zero by calling `approve(_spender,0)` if it is not
299         //  already 0 to mitigate the race condition described here:
300         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
301         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
302 
303         // Alerts the token controller of the approve function call
304         if (isContract(controller)) {
305             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
306         }
307 
308         allowed[msg.sender][_spender] = _amount;
309         Approval(msg.sender, _spender, _amount);
310         return true;
311     }
312 
313     /// @dev This function makes it easy to read the `allowed[]` map
314     /// @param _owner The address of the account that owns the token
315     /// @param _spender The address of the account able to transfer the tokens
316     /// @return Amount of remaining tokens of _owner that _spender is allowed
317     ///  to spend
318     function allowance(address _owner, address _spender
319     ) public constant returns (uint256 remaining) {
320         return allowed[_owner][_spender];
321     }
322 
323     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
324     ///  its behalf, and then a function is triggered in the contract that is
325     ///  being approved, `_spender`. This allows users to use their tokens to
326     ///  interact with contracts in one function call instead of two
327     /// @param _spender The address of the contract able to transfer the tokens
328     /// @param _amount The amount of tokens to be approved for transfer
329     /// @return True if the function call was successful
330     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
331     ) public returns (bool success) {
332         require(approve(_spender, _amount));
333 
334         ApproveAndCallFallBack(_spender).receiveApproval(
335             msg.sender,
336             _amount,
337             this,
338             _extraData
339         );
340 
341         return true;
342     }
343 
344     /// @dev This function makes it easy to get the total number of tokens
345     /// @return The total number of tokens
346     function totalSupply() public constant returns (uint) {
347         return totalSupplyAt(block.number);
348     }
349 
350 
351 ////////////////
352 // Query balance and totalSupply in History
353 ////////////////
354 
355     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
356     /// @param _owner The address from which the balance will be retrieved
357     /// @param _blockNumber The block number when the balance is queried
358     /// @return The balance at `_blockNumber`
359     function balanceOfAt(address _owner, uint _blockNumber) public constant
360         returns (uint) {
361 
362         // These next few lines are used when the balance of the token is
363         //  requested before a check point was ever created for this token, it
364         //  requires that the `parentToken.balanceOfAt` be queried at the
365         //  genesis block for that token as this contains initial balance of
366         //  this token
367         if ((balances[_owner].length == 0)
368             || (balances[_owner][0].fromBlock > _blockNumber)) {
369             if (address(parentToken) != 0) {
370                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
371             } else {
372                 // Has no parent
373                 return 0;
374             }
375 
376         // This will return the expected balance during normal situations
377         } else {
378             return getValueAt(balances[_owner], _blockNumber);
379         }
380     }
381 
382     /// @notice Total amount of tokens at a specific `_blockNumber`.
383     /// @param _blockNumber The block number when the totalSupply is queried
384     /// @return The total amount of tokens at `_blockNumber`
385     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
386 
387         // These next few lines are used when the totalSupply of the token is
388         //  requested before a check point was ever created for this token, it
389         //  requires that the `parentToken.totalSupplyAt` be queried at the
390         //  genesis block for this token as that contains totalSupply of this
391         //  token at this block number.
392         if ((totalSupplyHistory.length == 0)
393             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
394             if (address(parentToken) != 0) {
395                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
396             } else {
397                 return 0;
398             }
399 
400         // This will return the expected totalSupply during normal situations
401         } else {
402             return getValueAt(totalSupplyHistory, _blockNumber);
403         }
404     }
405 
406 ////////////////
407 // Clone Token Method
408 ////////////////
409 
410     /// @notice Creates a new clone token with the initial distribution being
411     ///  this token at `_snapshotBlock`
412     /// @param _cloneTokenName Name of the clone token
413     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
414     /// @param _cloneTokenSymbol Symbol of the clone token
415     /// @param _snapshotBlock Block when the distribution of the parent token is
416     ///  copied to set the initial distribution of the new clone token;
417     ///  if the block is zero than the actual block, the current block is used
418     /// @param _transfersEnabled True if transfers are allowed in the clone
419     /// @return The address of the new MiniMeToken Contract
420     function createCloneToken(
421         string _cloneTokenName,
422         uint8 _cloneDecimalUnits,
423         string _cloneTokenSymbol,
424         uint _snapshotBlock,
425         bool _transfersEnabled
426         ) public returns(address) {
427         if (_snapshotBlock == 0) _snapshotBlock = block.number;
428         MiniMeToken cloneToken = tokenFactory.createCloneToken(
429             this,
430             _snapshotBlock,
431             _cloneTokenName,
432             _cloneDecimalUnits,
433             _cloneTokenSymbol,
434             _transfersEnabled
435             );
436 
437         cloneToken.changeController(msg.sender);
438 
439         // An event to make the token easy to find on the blockchain
440         NewCloneToken(address(cloneToken), _snapshotBlock);
441         return address(cloneToken);
442     }
443 
444 ////////////////
445 // Generate and destroy tokens
446 ////////////////
447 
448     /// @notice Generates `_amount` tokens that are assigned to `_owner`
449     /// @param _owner The address that will be assigned the new tokens
450     /// @param _amount The quantity of tokens generated
451     /// @return True if the tokens are generated correctly
452     function generateTokens(address _owner, uint _amount
453     ) public onlyController returns (bool) {
454         uint curTotalSupply = totalSupply();
455         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
456         uint previousBalanceTo = balanceOf(_owner);
457         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
458         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
459         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
460         Transfer(0, _owner, _amount);
461         return true;
462     }
463 
464 
465     /// @notice Burns `_amount` tokens from `_owner`
466     /// @param _owner The address that will lose the tokens
467     /// @param _amount The quantity of tokens to burn
468     /// @return True if the tokens are burned correctly
469     function destroyTokens(address _owner, uint _amount
470     ) onlyController public returns (bool) {
471         uint curTotalSupply = totalSupply();
472         require(curTotalSupply >= _amount);
473         uint previousBalanceFrom = balanceOf(_owner);
474         require(previousBalanceFrom >= _amount);
475         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
476         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
477         Transfer(_owner, 0, _amount);
478         return true;
479     }
480 
481 ////////////////
482 // Enable tokens transfers
483 ////////////////
484 
485 
486     /// @notice Enables token holders to transfer their tokens freely if true
487     /// @param _transfersEnabled True if transfers are allowed in the clone
488     function enableTransfers(bool _transfersEnabled) public onlyController {
489         transfersEnabled = _transfersEnabled;
490     }
491 
492 ////////////////
493 // Internal helper functions to query and set a value in a snapshot array
494 ////////////////
495 
496     /// @dev `getValueAt` retrieves the number of tokens at a given block number
497     /// @param checkpoints The history of values being queried
498     /// @param _block The block number to retrieve the value at
499     /// @return The number of tokens being queried
500     function getValueAt(Checkpoint[] storage checkpoints, uint _block
501     ) constant internal returns (uint) {
502         if (checkpoints.length == 0) return 0;
503 
504         // Shortcut for the actual value
505         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
506             return checkpoints[checkpoints.length-1].value;
507         if (_block < checkpoints[0].fromBlock) return 0;
508 
509         // Binary search of the value in the array
510         uint min = 0;
511         uint max = checkpoints.length-1;
512         while (max > min) {
513             uint mid = (max + min + 1)/ 2;
514             if (checkpoints[mid].fromBlock<=_block) {
515                 min = mid;
516             } else {
517                 max = mid-1;
518             }
519         }
520         return checkpoints[min].value;
521     }
522 
523     /// @dev `updateValueAtNow` used to update the `balances` map and the
524     ///  `totalSupplyHistory`
525     /// @param checkpoints The history of data being updated
526     /// @param _value The new number of tokens
527     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
528     ) internal  {
529         if ((checkpoints.length == 0)
530         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
531                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
532                newCheckPoint.fromBlock =  uint128(block.number);
533                newCheckPoint.value = uint128(_value);
534            } else {
535                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
536                oldCheckPoint.value = uint128(_value);
537            }
538     }
539 
540     /// @dev Internal function to determine if an address is a contract
541     /// @param _addr The address being queried
542     /// @return True if `_addr` is a contract
543     function isContract(address _addr) constant internal returns(bool) {
544         uint size;
545         if (_addr == 0) return false;
546         assembly {
547             size := extcodesize(_addr)
548         }
549         return size>0;
550     }
551 
552     /// @dev Helper function to return a min betwen the two uints
553     function min(uint a, uint b) pure internal returns (uint) {
554         return a < b ? a : b;
555     }
556 
557     /// @notice The fallback function: If the contract's controller has not been
558     ///  set to 0, then the `proxyPayment` method is called which relays the
559     ///  ether and creates tokens as described in the token controller contract
560     function () public payable {
561         require(isContract(controller));
562         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
563     }
564 
565 //////////
566 // Safety Methods
567 //////////
568 
569     /// @notice This method can be used by the controller to extract mistakenly
570     ///  sent tokens to this contract.
571     /// @param _token The address of the token contract that you want to recover
572     ///  set to 0 in case you want to extract ether.
573     function claimTokens(address _token) public onlyController {
574         if (_token == 0x0) {
575             controller.transfer(this.balance);
576             return;
577         }
578 
579         MiniMeToken token = MiniMeToken(_token);
580         uint balance = token.balanceOf(this);
581         token.transfer(controller, balance);
582         ClaimedTokens(_token, controller, balance);
583     }
584 
585 ////////////////
586 // Events
587 ////////////////
588     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
589     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
590     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
591     event Approval(
592         address indexed _owner,
593         address indexed _spender,
594         uint256 _amount
595         );
596 
597 }
598 
599 
600 ////////////////
601 // MiniMeTokenFactory
602 ////////////////
603 
604 /// @dev This contract is used to generate clone contracts from a contract.
605 ///  In solidity this is the way to create a contract from a contract of the
606 ///  same class
607 contract MiniMeTokenFactory {
608 
609     /// @notice Update the DApp by creating a new token with new functionalities
610     ///  the msg.sender becomes the controller of this clone token
611     /// @param _parentToken Address of the token being cloned
612     /// @param _snapshotBlock Block of the parent token that will
613     ///  determine the initial distribution of the clone token
614     /// @param _tokenName Name of the new token
615     /// @param _decimalUnits Number of decimals of the new token
616     /// @param _tokenSymbol Token Symbol for the new token
617     /// @param _transfersEnabled If true, tokens will be able to be transferred
618     /// @return The address of the new token contract
619     function createCloneToken(
620         address _parentToken,
621         uint _snapshotBlock,
622         string _tokenName,
623         uint8 _decimalUnits,
624         string _tokenSymbol,
625         bool _transfersEnabled
626     ) public returns (MiniMeToken) {
627         MiniMeToken newToken = new MiniMeToken(
628             this,
629             _parentToken,
630             _snapshotBlock,
631             _tokenName,
632             _decimalUnits,
633             _tokenSymbol,
634             _transfersEnabled
635             );
636 
637         newToken.changeController(msg.sender);
638         return newToken;
639     }
640 }
641 contract EatMeCoin is MiniMeToken { 
642 
643   // we use this variable to store the number of the finalization block
644   uint256 public checkpointBlock;
645 
646   // address which is allowed to trigger tokens generation
647   address public mayGenerateAddr;
648 
649   // flag
650   bool tokenGenerationEnabled = true; //<- added after first audit
651 
652 
653   modifier mayGenerate() {
654     require ( (msg.sender == mayGenerateAddr) &&
655               (tokenGenerationEnabled == true) ); //<- added after first audit
656     _;
657   }
658 
659   // Constructor
660   function EatMeCoin(address _tokenFactory) 
661     MiniMeToken(
662       _tokenFactory,
663       0x0,
664       0,
665       "EatMeCoin",
666       18, // decimals
667       "EAT",
668       // SHOULD TRANSFERS BE ENABLED? -- NO
669       false){
670     
671     controller = msg.sender;
672     mayGenerateAddr = controller;
673   }
674 
675   function setGenerateAddr(address _addr) onlyController{
676     // we can appoint an address to be allowed to generate tokens
677     require( _addr != 0x0 );
678     mayGenerateAddr = _addr;
679   }
680 
681 
682   /// @notice this is default function called when ETH is send to this contract
683   ///   we use the campaign contract for selling tokens
684   function () payable {
685     revert();
686   }
687 
688   
689   /// @notice This function is copy-paste of the generateTokens of the original MiniMi contract
690   ///   except it uses mayGenerate modifier (original uses onlyController)
691   function generate_token_for(address _addrTo, uint256 _amount) mayGenerate returns (bool) {
692     
693     //balances[_addr] += _amount;
694    
695     uint256 curTotalSupply = totalSupply();
696     require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow    
697     uint256 previousBalanceTo = balanceOf(_addrTo);
698     require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
699     updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
700     updateValueAtNow(balances[_addrTo], previousBalanceTo + _amount);
701     Transfer(0, _addrTo, _amount);
702     return true;
703   }
704 
705   // overwrites the original function
706   function generateTokens(address _owner, uint256 _amount
707     ) onlyController returns (bool) {
708     revert();
709     generate_token_for(_owner, _amount);    
710   }
711 
712 
713   // permanently disables generation of new tokens
714   function finalize() mayGenerate {
715     tokenGenerationEnabled = false;
716     transfersEnabled = true;
717     checkpointBlock = block.number;
718   }  
719 }