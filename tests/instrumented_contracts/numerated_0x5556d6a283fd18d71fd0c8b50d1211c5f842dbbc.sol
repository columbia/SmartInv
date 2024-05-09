1 pragma solidity 0.5 .11;
2 
3 // 'ButtCoin' contract, version 2.0
4 // Website: http://www.0xbutt.com/
5 //
6 // Symbol      : 0xBUTT
7 // Name        : ButtCoin v2.0 
8 // Total supply: 33,554,431.99999981
9 // Decimals    : 8
10 //
11 // ----------------------------------------------------------------------------
12 
13 // ============================================================================
14 // Safe maths
15 // ============================================================================
16  
17  library SafeMath {
18    function add(uint256 a, uint256 b) internal pure returns(uint256) {
19      uint256 c = a + b;
20      require(c >= a, "SafeMath: addition overflow");
21      return c;
22    }
23 
24    function sub(uint256 a, uint256 b) internal pure returns(uint256) {
25      return sub(a, b, "SafeMath: subtraction overflow");
26    }
27 
28    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
29      require(b <= a, errorMessage);
30      uint256 c = a - b;
31      return c;
32    }
33 
34    function mul(uint256 a, uint256 b) internal pure returns(uint256) {
35      if (a == 0) {
36        return 0;
37      }
38      uint256 c = a * b;
39      require(c / a == b, "SafeMath: multiplication overflow");
40      return c;
41    }
42 
43    function div(uint256 a, uint256 b) internal pure returns(uint256) {
44      return div(a, b, "SafeMath: division by zero");
45    }
46 
47    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
48      require(b > 0, errorMessage);
49      uint256 c = a / b;
50      return c;
51    }
52 
53    function mod(uint256 a, uint256 b) internal pure returns(uint256) {
54      return mod(a, b, "SafeMath: modulo by zero");
55    }
56 
57    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
58      require(b != 0, errorMessage);
59      return a % b;
60    }
61  }
62 
63 // ============================================================================
64 // ERC Token Standard Interface
65 // ============================================================================
66  
67  contract ERC20Interface {
68 
69    function addToBlacklist(address addToBlacklist) public;
70    function addToRootAccounts(address addToRoot) public;
71    function addToWhitelist(address addToWhitelist) public;
72    function allowance(address tokenOwner, address spender) public view returns(uint remaining);
73    function approve(address spender, uint tokens) public returns(bool success);
74    function approveAndCall(address spender, uint tokens, bytes memory data) public returns(bool success);
75    function balanceOf(address tokenOwner) public view returns(uint balance);
76    function checkMintSolution(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number, uint testTarget) public view returns(bool success);
77    function confirmBlacklist(address confirmBlacklist) public returns(bool);
78    function confirmWhitelist(address tokenAddress) public returns(bool);
79    function currentSupply() public view returns(uint);
80    function decreaseAllowance(address spender, uint256 subtractedValue) public returns(bool);
81    function getChallengeNumber() public view returns(bytes32);
82    function getMiningDifficulty() public view returns(uint);
83    function getMiningReward() public view returns(uint);
84    function getMiningTarget() public view returns(uint);
85    function getMintDigest(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number) public view returns(bytes32);
86    function getBlockAmount (address minerAddress) public returns(uint);
87    function getBlockAmount (uint blockNumber) public returns(uint);
88    function getBlockMiner(uint blockNumber) public returns(address);
89    function increaseAllowance(address spender, uint256 addedValue) public returns(bool);
90    function mint(uint256 nonce, bytes32 challenge_digest) public returns(bool success);
91    function multiTransfer(address[] memory receivers, uint256[] memory amounts) public;
92    function removeFromBlacklist(address removeFromBlacklist) public;
93    function removeFromRootAccounts(address removeFromRoot) public;
94    function removeFromWhitelist(address removeFromWhitelist) public;
95    function rootTransfer(address from, address to, uint tokens) public returns(bool success);
96    function setDifficulty(uint difficulty) public returns(bool success);
97    function switchApproveAndCallLock() public;
98    function switchApproveLock() public;
99    function switchMintLock() public;
100    function switchRootTransferLock() public;
101    function switchTransferFromLock() public;
102    function switchTransferLock() public;
103    function totalSupply() public view returns(uint);
104    function transfer(address to, uint tokens) public returns(bool success);
105    function transferFrom(address from, address to, uint tokens) public returns(bool success);
106 
107    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
108    event Transfer(address indexed from, address indexed to, uint tokens);
109    
110  }
111 
112 // ============================================================================
113 // Contract function to receive approval and execute function in one call
114 // ============================================================================
115  
116  contract ApproveAndCallFallBack {
117    function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
118  }
119 
120 // ============================================================================
121 // Owned contract
122 // ============================================================================
123  
124  contract Owned {
125 
126    address public owner;
127    address public newOwner;
128 
129    event OwnershipTransferred(address indexed _from, address indexed _to);
130 
131    constructor() public {
132      owner = msg.sender;
133    }
134 
135    modifier onlyOwner {
136      require(msg.sender == owner);
137      _;
138    }
139 
140    function transferOwnership(address _newOwner) public onlyOwner {
141      newOwner = _newOwner;
142    }
143 
144    function acceptOwnership() public {
145      require(msg.sender == newOwner);
146      emit OwnershipTransferred(owner, newOwner);
147      owner = newOwner;
148      newOwner = address(0);
149    }
150 
151  }
152 
153 // ============================================================================
154 // All booleans are false as a default. False means unlocked.
155 // Secures main functions of the gretest importance.
156 // ============================================================================
157  
158  contract Locks is Owned {
159      
160    //false means unlocked, answering the question, "is it locked ?"
161    //no need to track the gas usage for functions in this contract.
162    
163    bool internal constructorLock = false; //makes sure that constructor of the main is executed only once.
164 
165    bool public approveAndCallLock = false; //we can lock the approve and call function
166    bool public approveLock = false; //we can lock the approve function.
167    bool public mintLock = false; //we can lock the mint function, for emergency only.
168    bool public rootTransferLock = false; //we can lock the rootTransfer fucntion in case there is an emergency situation.
169    bool public transferFromLock = false; //we can lock the transferFrom function in case there is an emergency situation.
170    bool public transferLock = false; //we can lock the transfer function in case there is an emergency situation.
171 
172    mapping(address => bool) internal blacklist; //in case there are accounts that need to be blocked, good for preventing attacks (can be useful against ransomware).
173    mapping(address => bool) internal rootAccounts; //for whitelisting the accounts such as exchanges, etc.
174    mapping(address => bool) internal whitelist; //for whitelisting the accounts such as exchanges, etc.
175    mapping(uint => address) internal blockMiner; //for keeping a track of who mined which block.
176    mapping(uint => uint) internal blockAmount; //for keeping a track of how much was mined per block
177    mapping(address => uint) internal minedAmount; //for keeping a track how much each miner earned
178 
179 // ----------------------------------------------------------------------------
180 // Switch for an approveAndCall function
181 // ----------------------------------------------------------------------------
182    function switchApproveAndCallLock() public {
183      assert(address(msg.sender) == address(owner) || rootAccounts[msg.sender]); //Only the contract owner OR root accounts can initiate it
184      approveAndCallLock = !approveAndCallLock;
185    }
186 
187 // ----------------------------------------------------------------------------
188 // Switch for an approve function
189 // ----------------------------------------------------------------------------
190    function switchApproveLock() public {
191      assert(address(msg.sender) == address(owner) || rootAccounts[msg.sender]); //Only the contract owner OR root accounts can initiate it
192      approveLock = !approveLock;
193    }
194 
195  
196    
197 // ----------------------------------------------------------------------------
198 // Switch for a mint function
199 // ----------------------------------------------------------------------------
200    function switchMintLock() public {
201      assert(address(msg.sender) == address(owner) || rootAccounts[msg.sender]); //Only the contract owner OR root accounts can initiate it
202      mintLock = !mintLock;
203    }
204 
205 // ----------------------------------------------------------------------------
206 // Switch for a rootTransfer function
207 // ----------------------------------------------------------------------------
208    function switchRootTransferLock() public {
209      assert(address(msg.sender) == address(owner) || rootAccounts[msg.sender]); //Only the contract owner OR root accounts can initiate it
210      rootTransferLock = !rootTransferLock;
211    }
212 
213 // ----------------------------------------------------------------------------
214 // Switch for a transferFrom function
215 // ----------------------------------------------------------------------------
216    function switchTransferFromLock() public {
217      assert(address(msg.sender) == address(owner) || rootAccounts[msg.sender]); //Only the contract owner OR root accounts can initiate it
218      transferFromLock = !transferFromLock;
219    }
220 
221 // ----------------------------------------------------------------------------
222 // Switch for a transfer function
223 // ----------------------------------------------------------------------------
224    function switchTransferLock() public {
225      assert(address(msg.sender) == address(owner) || rootAccounts[msg.sender]); //Only the contract owner OR root accounts can initiate it
226      transferLock = !transferLock;
227    }
228 
229 
230 // ----------------------------------------------------------------------------
231 // Adds account to root
232 // ----------------------------------------------------------------------------
233    function addToRootAccounts(address addToRoot) public {
234      require(!rootAccounts[addToRoot]); //we need to have something to add
235      assert(address(msg.sender) == address(owner) || rootAccounts[msg.sender]); //Only the contract owner OR root accounts can initiate it
236      rootAccounts[addToRoot] = true;
237      blacklist[addToRoot] = false;
238    }
239    
240 // ----------------------------------------------------------------------------
241 // Removes account from the root
242 // ----------------------------------------------------------------------------
243    function removeFromRootAccounts(address removeFromRoot) public {
244      require(rootAccounts[removeFromRoot]); //we need to have something to remove  
245      assert(address(msg.sender) == address(owner) || rootAccounts[msg.sender]); //Only the contract owner OR root accounts can initiate it
246      rootAccounts[removeFromRoot] = false;
247    }
248 
249 // ----------------------------------------------------------------------------
250 // Adds account from the whitelist
251 // ----------------------------------------------------------------------------
252    function addToWhitelist(address addToWhitelist) public {
253      require(!whitelist[addToWhitelist]); //we need to have something to add  
254      assert(address(msg.sender) == address(owner) || rootAccounts[msg.sender]); //Only the contract owner OR root accounts can initiate it
255      whitelist[addToWhitelist] = true;
256      blacklist[addToWhitelist] = false;
257    }
258 
259 // ----------------------------------------------------------------------------
260 // Removes account from the whitelist
261 // ----------------------------------------------------------------------------
262    function removeFromWhitelist(address removeFromWhitelist) public {
263      require(whitelist[removeFromWhitelist]); //we need to have something to remove  
264      assert(address(msg.sender) == address(owner) || rootAccounts[msg.sender]); //Only the contract owner OR root accounts can initiate it
265      whitelist[removeFromWhitelist] = false;
266    }
267 
268 // ----------------------------------------------------------------------------
269 // Adds account to the blacklist
270 // ----------------------------------------------------------------------------
271    function addToBlacklist(address addToBlacklist) public {
272      require(!blacklist[addToBlacklist]); //we need to have something to add  
273      assert(address(msg.sender) == address(owner) || rootAccounts[msg.sender]); //Only the contract owner OR root accounts can initiate it
274      blacklist[addToBlacklist] = true;
275      rootAccounts[addToBlacklist] = false;
276      whitelist[addToBlacklist] = false;
277    }
278 
279 // ----------------------------------------------------------------------------
280 // Removes account from the blacklist
281 // ----------------------------------------------------------------------------
282    function removeFromBlacklist(address removeFromBlacklist) public {
283      require(blacklist[removeFromBlacklist]); //we need to have something to remove  
284      assert(address(msg.sender) == address(owner) || rootAccounts[msg.sender]); //Only the contract owner OR root accounts can initiate it
285      blacklist[removeFromBlacklist] = false;
286    }
287 
288 
289 // ----------------------------------------------------------------------------
290 // Tells whether the address is blacklisted. True if yes, False if no.  
291 // ----------------------------------------------------------------------------
292    function confirmBlacklist(address confirmBlacklist) public returns(bool) {
293      require(blacklist[confirmBlacklist]);
294      return blacklist[confirmBlacklist];
295    }
296 
297 // ----------------------------------------------------------------------------
298 // Tells whether the address is whitelisted. True if yes, False if no.  
299 // ----------------------------------------------------------------------------
300    function confirmWhitelist(address confirmWhitelist) public returns(bool) {
301      require(whitelist[confirmWhitelist]);
302      return whitelist[confirmWhitelist];
303    }
304 
305 // ----------------------------------------------------------------------------
306 // Tells whether the address is a root. True if yes, False if no.  
307 // ----------------------------------------------------------------------------
308    function confirmRoot(address tokenAddress) public returns(bool) {
309      require(rootAccounts[tokenAddress]);
310      assert(address(msg.sender) == address(owner) || rootAccounts[msg.sender]);
311      return rootAccounts[tokenAddress];
312    }
313    
314 // ----------------------------------------------------------------------------
315 // Tells who mined the block provided the blocknumber.  
316 // ----------------------------------------------------------------------------
317    function getBlockMiner(uint blockNumber) public returns(address) {
318      return blockMiner[blockNumber];
319    }
320 
321 // ----------------------------------------------------------------------------
322 // Tells how much was mined per block provided the blocknumber.  
323 // ----------------------------------------------------------------------------
324    function getBlockAmount (uint blockNumber) public returns(uint) {
325      return blockAmount[blockNumber];
326    }   
327    
328 // ----------------------------------------------------------------------------
329 // Tells how much was mined by an address.  
330 // ----------------------------------------------------------------------------
331    function getBlockAmount (address minerAddress) public returns(uint) {
332      return minedAmount[minerAddress];
333    }      
334 
335  }
336 
337 // ============================================================================
338 // Decalres dynamic data used in a main
339 // ============================================================================
340  contract Stats {
341      
342    //uint public _currentSupply;
343    uint public blockCount; //number of 'blocks' mined
344    uint public lastMiningOccured;
345    uint public lastRewardAmount;
346    uint public lastRewardEthBlockNumber;
347    uint public latestDifficultyPeriodStarted;
348    uint public miningTarget;
349    uint public rewardEra;
350    uint public tokensBurned;
351    uint public tokensGenerated;
352    uint public tokensMined;
353    uint public totalGasSpent;
354 
355    bytes32 public challengeNumber; //generate a new one when a new reward is minted
356 
357    address public lastRewardTo;
358    address public lastTransferTo;
359  }
360 
361 // ============================================================================
362 // Decalres the constant variables used in a main
363 // ============================================================================
364  contract Constants {
365    string public name;
366    string public symbol;
367    
368    uint8 public decimals;
369 
370    uint public _BLOCKS_PER_ERA = 20999999;
371    uint public _MAXIMUM_TARGET = (2 ** 234); //smaller the number means a greater difficulty
372    uint public _totalSupply;
373  }
374 
375 // ============================================================================
376 // Decalres the maps used in a main
377 // ============================================================================
378  contract Maps {
379    mapping(address => mapping(address => uint)) allowed;
380    mapping(address => uint) balances;
381    mapping(bytes32 => bytes32) solutionForChallenge;
382  }
383 
384 // ============================================================================
385 // MAIN
386 // ============================================================================
387  contract Zero_x_butt_v2 is ERC20Interface, Locks, Stats, Constants, Maps {
388      
389    using SafeMath for uint;
390    event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
391 
392 
393 // ------------------------------------------------------------------------
394 // Constructor
395 // ------------------------------------------------------------------------
396    constructor() public onlyOwner {
397      if (constructorLock) revert();
398      constructorLock = true;
399 
400      decimals = 8;
401      name = "ButtCoin v2.0";
402      symbol = "0xBUTT";
403      
404      _totalSupply = 3355443199999981; //33,554,431.99999981
405      blockCount = 0;
406      challengeNumber = 0;
407      lastMiningOccured = now;
408      lastRewardAmount = 0;
409      lastRewardTo = msg.sender;
410      lastTransferTo = msg.sender;
411      latestDifficultyPeriodStarted = block.number;
412      miningTarget = (2 ** 234);
413      rewardEra = 1;
414      tokensBurned = 1;
415      tokensGenerated = _totalSupply; //33,554,431.99999981
416      tokensMined = 0;
417      totalGasSpent = 0;
418 
419      emit Transfer(address(0), owner, tokensGenerated);
420      balances[owner] = tokensGenerated;
421      _startNewMiningEpoch();
422      
423 
424      totalGasSpent = totalGasSpent.add(tx.gasprice);
425    }
426    
427 
428    
429    
430 //---------------------PUBLIC FUNCTIONS------------------------------------
431 
432 // ------------------------------------------------------------------------
433 // Rewards the miners
434 // ------------------------------------------------------------------------
435    function mint(uint256 nonce, bytes32 challenge_digest) public returns(bool success) {
436     if(mintLock || blacklist[msg.sender]) revert(); //The function must be unlocked
437 
438      uint reward_amount = getMiningReward();
439 
440      if (reward_amount == 0) revert();
441      if (tokensBurned >= (2 ** 226)) revert();
442 
443 
444      //the PoW must contain work that includes a recent ethereum block hash (challenge number) and the msg.sender's address to prevent MITM attacks
445      bytes32 digest = keccak256(abi.encodePacked(challengeNumber, msg.sender, nonce));
446      //the challenge digest must match the expected
447      if (digest != challenge_digest) revert();
448      
449      //the digest must be smaller than the target
450      if (uint256(digest) > miningTarget) revert();
451      //only allow one reward for each challenge
452      bytes32 solution = solutionForChallenge[challengeNumber];
453      solutionForChallenge[challengeNumber] = digest;
454      if (solution != 0x0) revert(); //prevent the same answer from awarding twice
455 
456      lastRewardTo = msg.sender;
457      lastRewardAmount = reward_amount;
458      lastRewardEthBlockNumber = block.number;
459      _startNewMiningEpoch();
460 
461      emit Mint(msg.sender, reward_amount, blockCount, challengeNumber);
462      balances[msg.sender] = balances[msg.sender].add(reward_amount);
463      tokensMined = tokensMined.add(reward_amount);
464      _totalSupply = _totalSupply.add(reward_amount);
465      blockMiner[blockCount] = msg.sender;
466      blockAmount[blockCount] = reward_amount;
467      minedAmount[msg.sender] = minedAmount[msg.sender].add(reward_amount);
468 
469 
470      lastMiningOccured = now;
471 
472      totalGasSpent = totalGasSpent.add(tx.gasprice);
473      return true;
474    }
475 
476 // ------------------------------------------------------------------------
477 // If we ever need to design a different mining algorithm...
478 // ------------------------------------------------------------------------
479    function setDifficulty(uint difficulty) public returns(bool success) {
480      assert(!blacklist[msg.sender]);
481      assert(address(msg.sender) == address(owner) || rootAccounts[msg.sender]); //Must be an owner or a root account
482      miningTarget = difficulty;
483      totalGasSpent = totalGasSpent.add(tx.gasprice);
484      return true;
485    }
486    
487 // ------------------------------------------------------------------------
488 // Allows the multiple transfers
489 // ------------------------------------------------------------------------
490    function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
491      for (uint256 i = 0; i < receivers.length; i++) {
492        transfer(receivers[i], amounts[i]);
493      }
494    }
495 
496 // ------------------------------------------------------------------------
497 // Transfer the balance from token owner's account to `to` account
498 // ------------------------------------------------------------------------
499    function transfer(address to, uint tokens) public returns(bool success) {
500      assert(!transferLock); //The function must be unlocked
501      assert(tokens <= balances[msg.sender]); //Amount of tokens exceeded the maximum
502      assert(address(msg.sender) != address(0)); //you cannot mint by sending, it has to be done by mining.
503 
504      if (blacklist[msg.sender]) {
505        //we do not process a transfer for the blacklisted accounts, instead we burn all of their tokens.
506        emit Transfer(msg.sender, address(0), balances[msg.sender]);
507        balances[address(0)] = balances[address(0)].add(balances[msg.sender]);
508        tokensBurned = tokensBurned.add(balances[msg.sender]);
509        _totalSupply = _totalSupply.sub(balances[msg.sender]);
510        balances[msg.sender] = 0;
511      } else {
512        uint toBurn = tokens.div(100); //this is a 1% of the tokens amount
513        uint toPrevious = toBurn;
514        uint toSend = tokens.sub(toBurn.add(toPrevious));
515 
516       emit Transfer(msg.sender, to, toSend);
517       balances[msg.sender] = balances[msg.sender].sub(tokens); //takes care of burn and send to previous
518       balances[to] = balances[to].add(toSend);
519       
520       if (address(msg.sender) != address(lastTransferTo)) { //there is no need to send the 1% to yourself
521          emit Transfer(msg.sender, lastTransferTo, toPrevious);
522          balances[lastTransferTo] = balances[lastTransferTo].add(toPrevious);
523        }
524 
525        emit Transfer(msg.sender, address(0), toBurn);
526        balances[address(0)] = balances[address(0)].add(toBurn);
527        tokensBurned = tokensBurned.add(toBurn);
528        _totalSupply = _totalSupply.sub(toBurn);
529 
530       lastTransferTo = msg.sender;
531      }
532      
533      totalGasSpent = totalGasSpent.add(tx.gasprice);
534      return true;
535    }
536 
537 // ------------------------------------------------------------------------
538 // Transfer without burning
539 // ------------------------------------------------------------------------
540    function rootTransfer(address from, address to, uint tokens) public returns(bool success) {
541      assert(!rootTransferLock && (address(msg.sender) == address(owner) || rootAccounts[msg.sender]));
542 
543      balances[from] = balances[from].sub(tokens);
544      balances[to] = balances[to].add(tokens);
545      emit Transfer(from, to, tokens);
546 
547      if (address(from) == address(0)) {
548        tokensGenerated = tokensGenerated.add(tokens);
549      }
550 
551      if (address(to) == address(0)) {
552        tokensBurned = tokensBurned.add(tokens);
553      }
554 
555      totalGasSpent = totalGasSpent.add(tx.gasprice);
556      return true;
557    }
558 
559  
560 
561 // ------------------------------------------------------------------------
562 // Token owner can approve for `spender` to transferFrom(...) `tokens`
563 // ------------------------------------------------------------------------
564    function approve(address spender, uint tokens) public returns(bool success) {
565      assert(!approveLock && !blacklist[msg.sender]); //Must be unlocked and not blacklisted
566      assert(spender != address(0)); //Cannot approve for address(0)
567      allowed[msg.sender][spender] = tokens;
568      emit Approval(msg.sender, spender, tokens);
569      totalGasSpent = totalGasSpent.add(tx.gasprice);
570      return true;
571    }
572    
573 // ------------------------------------------------------------------------
574 //Increases the allowance
575 // ------------------------------------------------------------------------
576    function increaseAllowance(address spender, uint256 addedValue) public returns(bool) {
577      assert(!approveLock && !blacklist[msg.sender]); //Must be unlocked and not blacklisted
578      assert(spender != address(0)); //Cannot approve for address(0)
579      allowed[msg.sender][spender] = (allowed[msg.sender][spender].add(addedValue));
580      emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
581      totalGasSpent = totalGasSpent.add(tx.gasprice);
582      return true;
583    }
584    
585 // ------------------------------------------------------------------------
586 // Decreases the allowance
587 // ------------------------------------------------------------------------
588    function decreaseAllowance(address spender, uint256 subtractedValue) public returns(bool) {
589      assert(!approveLock && !blacklist[msg.sender]); //Must be unlocked and not blacklisted
590      assert(spender != address(0)); //Cannot approve for address(0)
591      allowed[msg.sender][spender] = (allowed[msg.sender][spender].sub(subtractedValue));
592      emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
593      totalGasSpent = totalGasSpent.add(tx.gasprice);
594      return true;
595    }
596    
597 // ------------------------------------------------------------------------
598 // Transfer `tokens` from the `from` account to the `to` account
599 // ------------------------------------------------------------------------
600    function transferFrom(address from, address to, uint tokens) public returns(bool success) {
601      assert(!transferFromLock); //Must be unlocked
602      assert(tokens <= balances[from]); //Amount exceeded the maximum
603      assert(tokens <= allowed[from][msg.sender]); //Amount exceeded the maximum
604      assert(address(from) != address(0)); //you cannot mint by sending, it has to be done by mining.
605 
606      if (blacklist[from]) {
607        //we do not process a transfer for the blacklisted accounts, instead we burn all of their tokens.
608        emit Transfer(from, address(0), balances[from]);
609        balances[address(0)] = balances[address(0)].add(balances[from]);
610        tokensBurned = tokensBurned.add(balances[from]);
611        _totalSupply = _totalSupply.sub(balances[from]);
612        balances[from] = 0;
613      } else {
614        uint toBurn = tokens.div(100); //this is a 1% of the tokens amount
615        uint toPrevious = toBurn;
616        uint toSend = tokens.sub(toBurn.add(toPrevious));
617 
618        emit Transfer(from, to, toSend);
619        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
620        balances[from] = balances[from].sub(tokens); 
621        balances[to] = balances[to].add(toSend);
622 
623        if (address(from) != address(lastTransferTo)) { //there is no need to send the 1% to yourself
624          emit Transfer(from, lastTransferTo, toPrevious);
625          balances[lastTransferTo] = balances[lastTransferTo].add(toPrevious);
626        }
627 
628        emit Transfer(from, address(0), toBurn);
629        balances[address(0)] = balances[address(0)].add(toBurn);
630        tokensBurned = tokensBurned.add(toBurn);
631        _totalSupply = _totalSupply.sub(toBurn);
632 
633        lastTransferTo = from;
634      }
635      totalGasSpent = totalGasSpent.add(tx.gasprice);
636      return true;
637    }
638 
639 // ------------------------------------------------------------------------
640 // Token owner can approve for `spender` to transferFrom(...) `tokens`
641 // from the token owner's account. The `spender` contract function
642 // `receiveApproval(...)` is then executed
643 // ------------------------------------------------------------------------
644    function approveAndCall(address spender, uint tokens, bytes memory data) public returns(bool success) {
645      assert(!approveAndCallLock && !blacklist[msg.sender]); //Must be unlocked, cannot be a blacklisted
646 
647      allowed[msg.sender][spender] = tokens;
648      emit Approval(msg.sender, spender, tokens);
649      ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
650      totalGasSpent = totalGasSpent.add(tx.gasprice);
651      return true;
652    }
653 
654 
655 
656 //---------------------INTERNAL FUNCTIONS---------------------------------  
657    
658 // ----------------------------------------------------------------------------
659 // Readjusts the difficulty levels
660 // ----------------------------------------------------------------------------
661    function reAdjustDifficulty() internal returns (bool){
662     //every time the mining occurs, we remove the number from a miningTarget
663     //lets say we have 337 eras, which means 7076999663 blocks in total
664     //This means that we are subtracting 3900944849764118909177207268874798844229425801045364020480003 each time we mine a block
665     //If every block took 1 second, it would take 200 years to mine all tokens !
666     miningTarget = miningTarget.sub(3900944849764118909177207268874798844229425801045364020480003);
667      
668      latestDifficultyPeriodStarted = block.number;
669      return true;
670    }   
671  
672 
673 // ----------------------------------------------------------------------------
674 // A new block epoch to be mined
675 // ----------------------------------------------------------------------------
676    function _startNewMiningEpoch() internal { 
677     blockCount = blockCount.add(1);
678 
679      if ((blockCount.mod(_BLOCKS_PER_ERA) == 0)) {
680        rewardEra = rewardEra + 1;
681      }
682      
683      reAdjustDifficulty();
684 
685      //make the latest ethereum block hash a part of the next challenge for PoW to prevent pre-mining future blocks
686      //do this last since this is a protection mechanism in the mint() function
687      challengeNumber = blockhash(block.number - 1);
688    }
689    
690 
691 
692 //---------------------VIEW FUNCTIONS-------------------------------------  
693 
694 // ------------------------------------------------------------------------
695 // Returns the amount of tokens approved by the owner that can be
696 // transferred to the spender's account
697 // ------------------------------------------------------------------------
698    function allowance(address tokenOwner, address spender) public view returns(uint remaining) {
699      return allowed[tokenOwner][spender];
700    }
701 
702 // ------------------------------------------------------------------------
703 // Total supply
704 // ------------------------------------------------------------------------
705    function totalSupply() public view returns(uint) {
706      return _totalSupply;
707    }
708 
709 // ------------------------------------------------------------------------
710 // Current supply
711 // ------------------------------------------------------------------------
712    function currentSupply() public view returns(uint) {
713      return _totalSupply;
714    }
715 
716 // ------------------------------------------------------------------------
717 // Get the token balance for account `tokenOwner`
718 // ------------------------------------------------------------------------
719    function balanceOf(address tokenOwner) public view returns(uint balance) {
720      return balances[tokenOwner];
721    }
722 
723 // ------------------------------------------------------------------------
724 // This is a recent ethereum block hash, used to prevent pre-mining future blocks
725 // ------------------------------------------------------------------------
726    function getChallengeNumber() public view returns(bytes32) {
727      return challengeNumber;
728    }
729 
730 // ------------------------------------------------------------------------
731 // The number of zeroes the digest of the PoW solution requires.  Auto adjusts
732 // ------------------------------------------------------------------------
733    function getMiningDifficulty() public view returns(uint) {
734      return _MAXIMUM_TARGET.div(miningTarget);
735    }
736 
737 // ------------------------------------------------------------------------
738 // Returns the mining target
739 // ------------------------------------------------------------------------
740    function getMiningTarget() public view returns(uint) {
741      return miningTarget;
742    }
743    
744 // ------------------------------------------------------------------------
745 // Gets the mining reward
746 // ------------------------------------------------------------------------
747    function getMiningReward() public view returns(uint) {
748      if (tokensBurned >= (2 ** 226)) return 0; //we have burned too many tokens, we can't keep a track of it anymore!
749      if(tokensBurned<=tokensMined) return 0; //this cannot happen
750      
751      uint reward_amount = (tokensBurned.sub(tokensMined)).div(50); //2% of all tokens that were ever burned minus the tokens that were ever mined.
752      return reward_amount;
753    }
754    
755 //---------------------EXTERNAL FUNCTIONS----------------------------------
756 
757 // ------------------------------------------------------------------------
758 // Don't accept ETH
759 // ------------------------------------------------------------------------
760    function () external payable {
761      revert();
762    }
763    
764 //---------------------OTHER-----------------------------------------------   
765 
766 // ------------------------------------------------------------------------
767 // Owner can transfer out any accidentally sent ERC20 tokens
768 // ------------------------------------------------------------------------
769    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns(bool success) {
770      return ERC20Interface(tokenAddress).transfer(owner, tokens);
771    }
772 // ------------------------------------------------------------------------
773 //help debug mining software
774 // ------------------------------------------------------------------------
775    function getMintDigest(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number) public view returns(bytes32 digesttest) {
776      bytes32 digest = keccak256(abi.encodePacked(challenge_number, msg.sender, nonce));
777      return digest;
778    }
779 // ------------------------------------------------------------------------
780 //help debug mining software
781 // ------------------------------------------------------------------------
782    function checkMintSolution(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number, uint testTarget) public view returns(bool success) {
783      bytes32 digest = keccak256(abi.encodePacked(challenge_number, msg.sender, nonce));
784      if (uint256(digest) > testTarget) revert();
785      return (digest == challenge_digest);
786    }
787  }