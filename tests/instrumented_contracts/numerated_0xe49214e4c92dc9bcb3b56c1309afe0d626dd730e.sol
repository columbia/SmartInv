1 pragma solidity ^0.4.23;
2 
3 // File: node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     emit OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: node_modules/zeppelin-solidity/contracts/ownership/Claimable.sol
46 
47 /**
48  * @title Claimable
49  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
50  * This allows the new owner to accept the transfer.
51  */
52 contract Claimable is Ownable {
53   address public pendingOwner;
54 
55   /**
56    * @dev Modifier throws if called by any account other than the pendingOwner.
57    */
58   modifier onlyPendingOwner() {
59     require(msg.sender == pendingOwner);
60     _;
61   }
62 
63   /**
64    * @dev Allows the current owner to set the pendingOwner address.
65    * @param newOwner The address to transfer ownership to.
66    */
67   function transferOwnership(address newOwner) onlyOwner public {
68     pendingOwner = newOwner;
69   }
70 
71   /**
72    * @dev Allows the pendingOwner address to finalize the transfer.
73    */
74   function claimOwnership() onlyPendingOwner public {
75     emit OwnershipTransferred(owner, pendingOwner);
76     owner = pendingOwner;
77     pendingOwner = address(0);
78   }
79 }
80 
81 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
82 
83 /**
84  * @title ERC20Basic
85  * @dev Simpler version of ERC20 interface
86  * @dev see https://github.com/ethereum/EIPs/issues/179
87  */
88 contract ERC20Basic {
89   function totalSupply() public view returns (uint256);
90   function balanceOf(address who) public view returns (uint256);
91   function transfer(address to, uint256 value) public returns (bool);
92   event Transfer(address indexed _from, address indexed _to, uint256 _value);
93 }
94 
95 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/ERC20.sol
96 
97 /**
98  * @title ERC20 interface
99  * @dev see https://github.com/ethereum/EIPs/issues/20
100  */
101 contract ERC20 is ERC20Basic {
102   function allowance(address owner, address spender) public view returns (uint256);
103   function transferFrom(address from, address to, uint256 value) public returns (bool);
104   function approve(address spender, uint256 value) public returns (bool);
105   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
106 }
107 
108 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
109 
110 /**
111  * @title SafeERC20
112  * @dev Wrappers around ERC20 operations that throw on failure.
113  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
114  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
115  */
116 library SafeERC20 {
117   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
118     require(token.transfer(to, value));
119   }
120 
121   function safeTransferFrom(
122     ERC20 token,
123     address from,
124     address to,
125     uint256 value
126   )
127     internal
128   {
129     require(token.transferFrom(from, to, value));
130   }
131 
132   function safeApprove(ERC20 token, address spender, uint256 value) internal {
133     require(token.approve(spender, value));
134   }
135 }
136 
137 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/TokenTimelock.sol
138 
139 /**
140  * @title TokenTimelock
141  * @dev TokenTimelock is a token holder contract that will allow a
142  * beneficiary to extract the tokens after a given release time
143  */
144 contract TokenTimelock {
145   using SafeERC20 for ERC20Basic;
146 
147   // ERC20 basic token contract being held
148   ERC20Basic public token;
149 
150   // beneficiary of tokens after they are released
151   address public beneficiary;
152 
153   // timestamp when token release is enabled
154   uint256 public releaseTime;
155 
156   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint256 _releaseTime) public {
157     // solium-disable-next-line security/no-block-members
158     require(_releaseTime > block.timestamp);
159     token = _token;
160     beneficiary = _beneficiary;
161     releaseTime = _releaseTime;
162   }
163 
164   /**
165    * @notice Transfers tokens held by timelock to beneficiary.
166    */
167   function release() public {
168     // solium-disable-next-line security/no-block-members
169     require(block.timestamp >= releaseTime);
170 
171     uint256 amount = token.balanceOf(this);
172     require(amount > 0);
173 
174     token.safeTransfer(beneficiary, amount);
175   }
176 }
177 
178 // File: node_modules/zeppelin-solidity/contracts/math/SafeMath.sol
179 
180 /**
181  * @title SafeMath
182  * @dev Math operations with safety checks that throw on error
183  */
184 library SafeMath {
185 
186   /**
187   * @dev Multiplies two numbers, throws on overflow.
188   */
189   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
190     if (a == 0) {
191       return 0;
192     }
193     c = a * b;
194     assert(c / a == b);
195     return c;
196   }
197 
198   /**
199   * @dev Integer division of two numbers, truncating the quotient.
200   */
201   function div(uint256 a, uint256 b) internal pure returns (uint256) {
202     // assert(b > 0); // Solidity automatically throws when dividing by 0
203     // uint256 c = a / b;
204     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
205     return a / b;
206   }
207 
208   /**
209   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
210   */
211   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
212     assert(b <= a);
213     return a - b;
214   }
215 
216   /**
217   * @dev Adds two numbers, throws on overflow.
218   */
219   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
220     c = a + b;
221     assert(c >= a);
222     return c;
223   }
224 }
225 
226 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
227 
228 /**
229  * @title Basic token
230  * @dev Basic version of StandardToken, with no allowances.
231  */
232 contract BasicToken is ERC20Basic {
233   using SafeMath for uint256;
234 
235   mapping(address => uint256) balances;
236 
237   uint256 totalSupply_;
238 
239   /**
240   * @dev total number of tokens in existence
241   */
242   function totalSupply() public view returns (uint256) {
243     return totalSupply_;
244   }
245 
246   /**
247   * @dev transfer token for a specified address
248   * @param _to The address to transfer to.
249   * @param _value The amount to be transferred.
250   */
251   function transfer(address _to, uint256 _value) public returns (bool) {
252     require(_to != address(0));
253     require(_value <= balances[msg.sender]);
254 
255     balances[msg.sender] = balances[msg.sender].sub(_value);
256     balances[_to] = balances[_to].add(_value);
257     emit Transfer(msg.sender, _to, _value);
258     return true;
259   }
260 
261   /**
262   * @dev Gets the balance of the specified address.
263   * @param _owner The address to query the the balance of.
264   * @return An uint256 representing the amount owned by the passed address.
265   */
266   function balanceOf(address _owner) public view returns (uint256) {
267     return balances[_owner];
268   }
269 
270 }
271 
272 // File: node_modules/zeppelin-solidity/contracts/lifecycle/Pausable.sol
273 
274 /**
275  * @title Pausable
276  * @dev Base contract which allows children to implement an emergency stop mechanism.
277  */
278 contract Pausable is Ownable {
279   event Pause();
280   event Unpause();
281 
282   bool public paused = false;
283 
284 
285   /**
286    * @dev Modifier to make a function callable only when the contract is not paused.
287    */
288   modifier whenNotPaused() {
289     require(!paused);
290     _;
291   }
292 
293   /**
294    * @dev Modifier to make a function callable only when the contract is paused.
295    */
296   modifier whenPaused() {
297     require(paused);
298     _;
299   }
300 
301   /**
302    * @dev called by the owner to pause, triggers stopped state
303    */
304   function pause() onlyOwner whenNotPaused public {
305     paused = true;
306     emit Pause();
307   }
308 
309   /**
310    * @dev called by the owner to unpause, returns to normal state
311    */
312   function unpause() onlyOwner whenPaused public {
313     paused = false;
314     emit Unpause();
315   }
316 }
317 
318 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
319 
320 /**
321  * @title Standard ERC20 token
322  *
323  * @dev Implementation of the basic standard token.
324  * @dev https://github.com/ethereum/EIPs/issues/20
325  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
326  */
327 contract StandardToken is ERC20, BasicToken {
328 
329   mapping (address => mapping (address => uint256)) internal allowed;
330 
331 
332   /**
333    * @dev Transfer tokens from one address to another
334    * @param _from address The address which you want to send tokens from
335    * @param _to address The address which you want to transfer to
336    * @param _value uint256 the amount of tokens to be transferred
337    */
338   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
339     require(_to != address(0));
340     require(_value <= balances[_from]);
341     require(_value <= allowed[_from][msg.sender]);
342 
343     balances[_from] = balances[_from].sub(_value);
344     balances[_to] = balances[_to].add(_value);
345     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
346     emit Transfer(_from, _to, _value);
347     return true;
348   }
349 
350   /**
351    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
352    *
353    * Beware that changing an allowance with this method brings the risk that someone may use both the old
354    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
355    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
356    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
357    * @param _spender The address which will spend the funds.
358    * @param _value The amount of tokens to be spent.
359    */
360   function approve(address _spender, uint256 _value) public returns (bool) {
361     allowed[msg.sender][_spender] = _value;
362     emit Approval(msg.sender, _spender, _value);
363     return true;
364   }
365 
366   /**
367    * @dev Function to check the amount of tokens that an owner allowed to a spender.
368    * @param _owner address The address which owns the funds.
369    * @param _spender address The address which will spend the funds.
370    * @return A uint256 specifying the amount of tokens still available for the spender.
371    */
372   function allowance(address _owner, address _spender) public view returns (uint256) {
373     return allowed[_owner][_spender];
374   }
375 }
376 
377 // File: contracts/ERC223.sol
378 
379 contract ERC223 is ERC20 {
380     function transfer(address to, uint256 value, bytes data) public returns (bool);
381     function transferFrom(address from, address to, uint256 value, bytes data) public returns (bool);
382     event Transfer(address indexed _from, address indexed _to, uint256 indexed _value, bytes _data);
383 }
384 
385 // File: contracts/ERC223Receiver.sol
386 
387 /*
388   * @title Contract that will work with ERC223 tokens.
389   */
390  
391 contract ERC223Receiver { 
392 /*
393  * @dev Standard ERC223 function that will handle incoming token transfers.
394  *
395  * @param _from  Token sender address.
396  * @param _value Amount of tokens.
397  * @param _data  Transaction metadata.
398  */
399     function tokenFallback(address _from, uint _value, bytes _data) public;
400 }
401 
402 // File: contracts/ERC223Token.sol
403 
404 /**
405  * @title ERC223 token implementation.
406  * @dev Standard ERC223 implementation with capability of deactivating ERC223 functionalities.
407  *      Contracts that are known to support ERC20 tokens can be whitelisted to bypass tokenfallback call.
408  */
409 contract ERC223Token is ERC223, StandardToken, Ownable {
410     using SafeMath for uint256;
411 
412     // If true will invoke token fallback else it will act as an ERC20 token
413     bool public erc223Activated;
414     // List of contracts which are known to have support for ERC20 tokens.
415     // Needed to maintain compatibility with contracts that support ERC20 tokens but not ERC223 tokens.                      
416     mapping (address => bool) public supportedContracts;
417     // List of contracts which users allowed to bypass tokenFallback.
418     // Needed in case user wants to send tokens to contracts that do not support ERC223 tokens, i.e. multisig wallets.
419     mapping (address => mapping (address => bool)) public userAcknowledgedContracts;
420 
421     function setErc223Activated(bool _activated) external onlyOwner {
422         erc223Activated = _activated;
423     }
424 
425     function setSupportedContract(address _address, bool _supported) external onlyOwner {
426         supportedContracts[_address] = _supported;
427     }
428 
429     function setUserAcknowledgedContract(address _address, bool _acknowledged) external {
430         userAcknowledgedContracts[msg.sender][_address] = _acknowledged;
431     }
432 
433     /**
434      * @dev Checks if target address is a contract.
435      * @param _address The address to check.
436      */
437     function isContract(address _address) internal returns (bool) {
438         uint256 codeLength;
439         assembly {
440             // Retrieve the size of the code on target address
441             codeLength := extcodesize(_address)
442         }
443         return codeLength > 0;
444     }
445 
446     /**
447      * @dev Calls the tokenFallback function of the token receiver.
448      * @param _from  Token sender address.
449      * @param _to  Token receiver address.
450      * @param _value Amount of tokens.
451      * @param _data  Transaction metadata.
452      */
453     function invokeTokenReceiver(address _from, address _to, uint256 _value, bytes _data) internal {
454         ERC223Receiver receiver = ERC223Receiver(_to);
455         receiver.tokenFallback(_from, _value, _data);
456         emit Transfer(_from, _to, _value, _data);
457     }
458 
459     /**
460      * @dev Transfer specified amount of tokens to the specified address.
461      *      Added to maintain ERC20 compatibility.
462      * @param _to Receiver address.
463      * @param _value Amount of tokens to be transferred.
464      */
465     function transfer(address _to, uint256 _value) public returns (bool) {
466         bytes memory emptyData;
467         return transfer(_to, _value, emptyData);
468     }
469 
470     /**
471      * @dev Transfer specified amount of tokens to the specified address.
472      *      Invokes tokenFallback if the recipient is a contract.
473      *      Transaction to contracts without implementation of tokenFallback will revert.
474      * @param _to Receiver address.
475      * @param _value Amount of tokens to be transferred.
476      * @param _data Transaction metadata.
477      */
478     function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
479         bool status = super.transfer(_to, _value);
480 
481         // Invoke token receiver only when erc223 is activate, not listed on the whitelist and is a contract.
482         if (erc223Activated 
483             && isContract(_to)
484             && supportedContracts[_to] == false 
485             && userAcknowledgedContracts[msg.sender][_to] == false
486             && status == true) {
487             invokeTokenReceiver(msg.sender, _to, _value, _data);
488         }
489         return status;
490     }
491 
492     /**
493      * @dev Transfer specified amount of tokens from one address to another.
494      *      Added to maintain ERC20 compatibility.
495      * @param _from Sender address.
496      * @param _to Receiver address.
497      * @param _value Amount of tokens to be transferred.
498      */
499     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
500         bytes memory emptyData;
501         return transferFrom(_from, _to, _value, emptyData);
502     }
503 
504     /**
505      * @dev Transfer specified amount of tokens from one address to another.
506      *      Invokes tokenFallback if the recipient is a contract.
507      *      Transaction to contracts without implementation of tokenFallback will revert.
508      * @param _from Sender address.
509      * @param _to Receiver address.
510      * @param _value Amount of tokens to be transferred.
511      * @param _data Transaction metadata.
512      */
513     function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
514         bool status = super.transferFrom(_from, _to, _value);
515 
516         if (erc223Activated 
517             && isContract(_to)
518             && supportedContracts[_to] == false 
519             && userAcknowledgedContracts[msg.sender][_to] == false
520             && status == true) {
521             invokeTokenReceiver(_from, _to, _value, _data);
522         }
523         return status;
524     }
525 
526     function approve(address _spender, uint256 _value) public returns (bool) {
527         return super.approve(_spender, _value);
528     }
529 }
530 
531 // File: contracts/PausableERC223Token.sol
532 
533 /**
534  * @title ERC223 token implementation.
535  * @dev Standard ERC223 implementation with Pausable feature.      
536  */
537 
538 contract PausableERC223Token is ERC223Token, Pausable {
539 
540     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
541         return super.transfer(_to, _value);
542     }
543 
544     function transfer(address _to, uint256 _value, bytes _data) public whenNotPaused returns (bool) {
545         return super.transfer(_to, _value, _data);
546     }
547 
548     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
549         return super.transferFrom(_from, _to, _value);
550     }
551 
552     function transferFrom(address _from, address _to, uint256 _value, bytes _data) public whenNotPaused returns (bool) {
553         return super.transferFrom(_from, _to, _value, _data);
554     }
555 
556     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
557         return super.approve(_spender, _value);
558     }
559 }
560 
561 // File: contracts/SynchroCoin.sol
562 
563 /* @title SynchroCoin SYC Token
564  * @dev New SynchroCoin SYC Token migration from legacy contract.
565  */
566 
567 contract SynchroCoin is PausableERC223Token, Claimable {
568     string public constant name = "SynchroCoin";
569     string public constant symbol = "SYC";
570     uint8 public constant decimals = 18;
571     MigrationAgent public migrationAgent;
572 
573     function SynchroCoin(address _legacySycAddress, uint256 _timelockReleaseTime) public {        
574         migrationAgent = new MigrationAgent(_legacySycAddress, this, _timelockReleaseTime);
575         migrationAgent.transferOwnership(msg.sender);
576 
577         ERC20 legacySycContract = ERC20(_legacySycAddress);
578         totalSupply_ = legacySycContract.totalSupply();
579         balances[migrationAgent] = balances[migrationAgent].add(totalSupply_);
580 
581         pause();
582     }
583 }
584 
585 // File: contracts/MigrationAgent.sol
586 
587 /**
588  *  @title MigrationAgent
589  *  @dev Contract that keeps track of the migration process from one token contract to another. 
590  */
591 contract MigrationAgent is Ownable {
592     using SafeMath for uint256;
593 
594     ERC20 public legacySycContract;    // Previous Token Contract
595     ERC20 public sycContract;       // New Token Contract to migrate to
596     uint256 public targetSupply;    // Target supply amount to meet
597     uint256 public migratedSupply;  // Total amount of tokens migrated
598 
599     mapping (address => bool) public migrated;  // Flags to keep track of addresses already migrated
600 
601     uint256 public timelockReleaseTime; // Timelocked token release time
602     TokenTimelock public tokenTimelock; // TokenTimelock for Synchrolife team, advisors and partners
603 
604     event Migrate(address indexed holder, uint256 balance);
605 
606     function MigrationAgent(address _legacySycAddress, address _sycAddress, uint256 _timelockReleaseTime) public {
607         require(_legacySycAddress != address(0));
608         require(_sycAddress != address(0));
609 
610         legacySycContract = ERC20(_legacySycAddress);
611         targetSupply = legacySycContract.totalSupply();
612         timelockReleaseTime = _timelockReleaseTime;
613         sycContract = ERC20(_sycAddress);
614     }
615 
616     /**
617      * @dev Create a new timelock to replace the old one.
618      * @param _legacyVaultAddress Address of the vault contract from previous SynchroCoin contract.
619      */
620     function migrateVault(address _legacyVaultAddress) onlyOwner external { 
621         require(_legacyVaultAddress != address(0));
622         require(!migrated[_legacyVaultAddress]);
623         require(tokenTimelock == address(0));
624 
625         // Lock up the tokens for the team/advisors/partners.
626         migrated[_legacyVaultAddress] = true;        
627         uint256 timelockAmount = legacySycContract.balanceOf(_legacyVaultAddress);
628         tokenTimelock = new TokenTimelock(sycContract, msg.sender, timelockReleaseTime);
629         sycContract.transfer(tokenTimelock, timelockAmount);
630         migratedSupply = migratedSupply.add(timelockAmount);
631         emit Migrate(_legacyVaultAddress, timelockAmount);
632     }
633 
634     /**
635      * @dev Copies the balance of given addresses from the legacy contract
636      * @param _tokenHolders Array of addresses to migrate balance from the legacy contract
637      * @return True if operation was completed
638      */
639     function migrateBalances(address[] _tokenHolders) onlyOwner external {
640         for (uint256 i = 0; i < _tokenHolders.length; i++) {
641             migrateBalance(_tokenHolders[i]);
642         }
643     }
644 
645     /**
646      * @dev Copies the balance of a given address from the legacy contract
647      * @param _tokenHolder Address to migrate balance from the legacy contract
648      * @return True if balance was copied. False if balance had already been migrated or if address has zero balance in the legacy contract
649      */
650     function migrateBalance(address _tokenHolder) onlyOwner public returns (bool) {
651         if (migrated[_tokenHolder]) {
652             return false;   // Already migrated, therefore do nothing.
653         }
654 
655         uint256 balance = legacySycContract.balanceOf(_tokenHolder);
656         if (balance == 0) {
657             return false;   // Has no balance in legacy contract, therefore do nothing.
658         }
659 
660         // Copy balance
661         migrated[_tokenHolder] = true;
662         sycContract.transfer(_tokenHolder, balance);
663         migratedSupply = migratedSupply.add(balance);
664         emit Migrate(_tokenHolder, balance);
665         return true;
666     }
667 
668     /**
669      * @dev Destructs the contract and sends any remaining ETH/SYC to the owner.
670      */
671     function kill() onlyOwner public {
672         uint256 balance = sycContract.balanceOf(this);
673         sycContract.transfer(owner, balance);
674         selfdestruct(owner);
675     }
676 }