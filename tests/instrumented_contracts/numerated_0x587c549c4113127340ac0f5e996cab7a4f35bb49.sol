1 pragma solidity ^0.4.17;
2 
3 
4 library SafeMath {
5     function mul(uint a, uint b) internal pure  returns(uint) {
6         uint c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function sub(uint a, uint b) internal pure  returns(uint) {
12         assert(b <= a);
13         return a - b;
14     }
15 
16     function add(uint a, uint b) internal pure  returns(uint) {
17         uint c = a + b;
18         assert(c >= a && c >= b);
19         return c;
20     }
21 }
22 
23 contract ERC20 {
24     uint public totalSupply;
25 
26     function balanceOf(address who) public view returns(uint);
27 
28     function allowance(address owner, address spender) public view returns(uint);
29 
30     function transfer(address to, uint value) public returns(bool ok);
31 
32     function transferFrom(address from, address to, uint value) public returns(bool ok);
33 
34     function approve(address spender, uint value) public returns(bool ok);
35 
36     event Transfer(address indexed from, address indexed to, uint value);
37     event Approval(address indexed owner, address indexed spender, uint value);
38 }
39 
40 
41 /**
42  * @title Ownable
43  * @dev The Ownable contract has an owner address, and provides basic authorization control
44  * functions, this simplifies the implementation of "user permissions".
45  */
46 contract Ownable {
47 
48     address public owner;
49     
50     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52     /**
53     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54     * account.
55     */
56     function Ownable() public {
57         owner = msg.sender;
58     }
59 
60     /**
61     * @dev Throws if called by any account other than the owner.
62     */
63     modifier onlyOwner() {
64         require(msg.sender == owner);
65         _;
66     }
67 
68     /**
69     * @dev Allows the current owner to transfer control of the contract to a newOwner.
70     * @param newOwner The address to transfer ownership to.
71     */
72     function transferOwnership(address newOwner) onlyOwner public {
73         require(newOwner != address(0));
74         OwnershipTransferred(owner, newOwner);
75         owner = newOwner;
76     }
77 
78 }
79 
80 
81 /**
82  * @title Pausable
83  * @dev Base contract which allows children to implement an emergency stop mechanism.
84  */
85 contract Pausable is Ownable {
86     event Pause();
87     event Unpause();
88 
89     bool public paused = false;
90 
91   /**
92    * @dev Modifier to make a function callable only when the contract is not paused.
93    */
94     modifier whenNotPaused() {
95         require(!paused);
96         _;
97     }
98 
99   /**
100    * @dev Modifier to make a function callable only when the contract is paused.
101    */
102     modifier whenPaused() {
103         require(paused);
104         _;
105     }
106 
107   /**
108    * @dev called by the owner to pause, triggers stopped state
109    */
110     function pause() public onlyOwner whenNotPaused {
111         paused = true;
112         Pause();
113     }
114 
115   /**
116    * @dev called by the owner to unpause, returns to normal state
117    */
118     function unpause() public onlyOwner whenPaused {
119         paused = false;
120         Unpause();
121     }
122 }
123 
124 
125 /// @title Migration Agent interface
126 contract MigrationAgent {
127 
128     function migrateFrom(address _from, uint256 _value) public;
129 }
130 
131 
132 // Crowdsale Smart Contract
133 // This smart contract collects ETH and in return sends tokens to the Backers
134 contract Crowdsale is Pausable {
135 
136     using SafeMath for uint;
137 
138     struct Backer {
139         uint weiReceived; // amount of ETH contributed
140         uint tokensSent; // amount of tokens  sent  
141         bool refunded; // true if user has been refunded       
142     }
143 
144     Token public token; // Token contract reference   
145     address public multisig; // Multisig contract that will receive the ETH    
146     address public team; // Address to which the team tokens will be sent   
147     address public zen; // Address to which zen team tokens will be sent
148     uint public ethReceived; // Number of ETH received
149     uint public totalTokensSent; // Number of tokens sent to ETH contributors
150     uint public startBlock; // Crowdsale start block
151     uint public endBlock; // Crowdsale end block
152     uint public maxCap; // Maximum number of tokens to sell
153     uint public minCap; // Minimum number of tokens to sell    
154     bool public crowdsaleClosed; // Is crowdsale still in progress
155     uint public refundCount;  // number of refunds
156     uint public totalRefunded; // total amount of refunds in wei
157     uint public tokenPriceWei; // tokn price in wei
158     uint public minInvestETH; // Minimum amount to invest
159     uint public presaleTokens;
160     uint public totalWhiteListed; 
161     uint public claimCount;
162     uint public totalClaimed;
163     uint public numOfBlocksInMinute; // number of blocks in one minute * 100. eg. 
164                                      // if one block takes 13.34 seconds, the number will be 60/13.34* 100= 449
165 
166     mapping(address => Backer) public backers; //backer list
167     address[] public backersIndex; // to be able to itarate through backers for verification.  
168     mapping(address => bool) public whiteList;
169 
170     // @notice to verify if action is not performed out of the campaing range
171     modifier respectTimeFrame() {
172 
173         require(block.number >= startBlock && block.number <= endBlock);           
174         _;
175     }
176 
177     // Events
178     event LogReceivedETH(address backer, uint amount, uint tokenAmount);
179     event LogRefundETH(address backer, uint amount);
180     event LogWhiteListed(address user, uint whiteListedNum);
181     event LogWhiteListedMultiple(uint whiteListedNum);   
182 
183     // Crowdsale  {constructor}
184     // @notice fired when contract is crated. Initilizes all constant and initial variables.
185     function Crowdsale() public {
186 
187         multisig = 0xE804Ad72e60503eD47d267351Bdd3441aC1ccb03; 
188         team = 0x86Ab6dB9932332e3350141c1D2E343C478157d04; 
189         zen = 0x3334f1fBf78e4f0CFE0f5025410326Fe0262ede9; 
190         presaleTokens = 4692000e8;      //TODO: ensure that this is correct amount
191         totalTokensSent = presaleTokens;  
192         minInvestETH = 1 ether/10; // 0.1 eth
193         startBlock = 0; // ICO start block
194         endBlock = 0; // ICO end block                    
195         maxCap = 42000000e8; // takes into consideration zen team tokens and team tokens.   
196         minCap = 8442000e8;        
197         tokenPriceWei = 80000000000000;  // Price is 0.00008 eth    
198         numOfBlocksInMinute = 400;  //  TODO: updte this value before deploying. E.g. 4.00 block/per minute wold be entered as 400           
199     }
200 
201      // @notice to populate website with status of the sale 
202     function returnWebsiteData() external view returns(uint, uint, uint, uint, uint, uint, uint, uint, bool, bool) {
203     
204         return (startBlock, endBlock, numberOfBackers(), ethReceived, maxCap, minCap, totalTokensSent, tokenPriceWei, paused, crowdsaleClosed);
205     }
206 
207     // @notice in case refunds are needed, money can be returned to the contract
208     function fundContract() external payable onlyOwner() returns (bool) {
209         return true;
210     }
211 
212     function addToWhiteList(address _user) external onlyOwner() returns (bool) {
213 
214         if (whiteList[_user] != true) {
215             whiteList[_user] = true;
216             totalWhiteListed++;
217             LogWhiteListed(_user, totalWhiteListed);            
218         }
219         return true;
220     }
221 
222     function addToWhiteListMultiple(address[] _users) external onlyOwner()  returns (bool) {
223 
224         for (uint i = 0; i < _users.length; ++i) {
225 
226             if (whiteList[_users[i]] != true) {
227                 whiteList[_users[i]] = true;
228                 totalWhiteListed++;                          
229             }           
230         }
231         LogWhiteListedMultiple(totalWhiteListed); 
232         return true;
233     }
234 
235     // @notice Move funds from pre ICO sale if needed. 
236     function transferPreICOFunds() external payable onlyOwner() returns (bool) {
237         ethReceived = ethReceived.add(msg.value);
238         return true;
239     }
240 
241     // @notice Specify address of token contract
242     // @param _tokenAddress {address} address of the token contract
243     // @return res {bool}
244     function updateTokenAddress(Token _tokenAddress) external onlyOwner() returns(bool res) {
245         token = _tokenAddress;
246         return true;
247     }
248 
249     // {fallback function}
250     // @notice It will call internal function which handels allocation of Ether and calculates amout of tokens.
251     function () external payable {           
252         contribute(msg.sender);
253     }
254 
255     // @notice It will be called by owner to start the sale    
256     function start(uint _block) external onlyOwner() {   
257 
258         require(_block < (numOfBlocksInMinute * 60 * 24 * 60)/100);  // allow max 60 days for campaign
259                                                          
260         startBlock = block.number;
261         endBlock = startBlock.add(_block); 
262     }
263 
264     // @notice Due to changing average of block time
265     // this function will allow on adjusting duration of campaign closer to the end 
266     function adjustDuration(uint _block) external onlyOwner() {
267 
268         require(_block < (numOfBlocksInMinute * 60 * 24 * 80)/100); // allow for max of 80 days for campaign
269         require(_block > block.number.sub(startBlock)); // ensure that endBlock is not set in the past
270         endBlock = startBlock.add(_block); 
271     }
272     
273     // @notice This function will finalize the sale.
274     // It will only execute if predetermined sale time passed or all tokens are sold.
275     function finalize() external onlyOwner() {
276 
277         require(!crowdsaleClosed);        
278         // purchasing precise number of tokens might be impractical, 
279         //thus subtract 1000 tokens so finalizition is possible near the end 
280         require(block.number > endBlock || totalTokensSent >= maxCap - 1000); 
281         require(totalTokensSent >= minCap);  // ensure that campaign was successful         
282         crowdsaleClosed = true; 
283 
284         if (!token.transfer(team, 45000000e8 + presaleTokens))
285             revert();
286         if (!token.transfer(zen, 3000000e8)) 
287             revert();
288         token.unlock();                       
289     }
290 
291     // @notice
292     // This function will allow to transfer unsold tokens to a new
293     // contract/wallet address to start new ICO in the future
294     function transferRemainingTokens(address _newAddress) external onlyOwner() returns (bool) {
295 
296         require(_newAddress != address(0));
297         // 180 days after ICO ends   
298         assert(block.number > endBlock + (numOfBlocksInMinute * 60 * 24 * 180)/100);         
299         if (!token.transfer(_newAddress, token.balanceOf(this))) 
300             revert(); // transfer tokens to admin account or multisig wallet
301         return true;
302     }
303 
304     // @notice Failsafe drain
305     function drain() external onlyOwner() {
306         multisig.transfer(this.balance);      
307     }
308 
309     // @notice it will allow contributors to get refund in case campaign failed
310     function refund()  external whenNotPaused returns (bool) {
311 
312 
313         require(block.number > endBlock); // ensure that campaign is over
314         require(totalTokensSent < minCap); // ensure that campaign failed
315         require(this.balance > 0);  // contract will hold 0 ether at the end of the campaign.                                  
316                                     // contract needs to be funded through fundContract() for this action
317 
318         Backer storage backer = backers[msg.sender];
319 
320         require(backer.weiReceived > 0);           
321         require(!backer.refunded);      
322 
323         backer.refunded = true;      
324         refundCount++;
325         totalRefunded = totalRefunded + backer.weiReceived;
326 
327         if (!token.burn(msg.sender, backer.tokensSent))
328             revert();
329         msg.sender.transfer(backer.weiReceived);
330         LogRefundETH(msg.sender, backer.weiReceived);
331         return true;
332     }
333    
334 
335     // @notice return number of contributors
336     // @return  {uint} number of contributors
337     function numberOfBackers() public view returns(uint) {
338         return backersIndex.length;
339     }
340 
341     // @notice It will be called by fallback function whenever ether is sent to it
342     // @param  _backer {address} address of beneficiary
343     // @return res {bool} true if transaction was successful
344     function contribute(address _backer) internal whenNotPaused respectTimeFrame returns(bool res) {
345 
346         require(msg.value >= minInvestETH);   // stop when required minimum is not sent
347         require(whiteList[_backer]);
348         uint tokensToSend = calculateNoOfTokensToSend();
349         require(totalTokensSent.add(tokensToSend) <= maxCap);  // Ensure that max cap hasn't been reached
350            
351         Backer storage backer = backers[_backer];
352 
353         if (backer.weiReceived == 0)
354             backersIndex.push(_backer);
355         
356         backer.tokensSent = backer.tokensSent.add(tokensToSend);
357         backer.weiReceived = backer.weiReceived.add(msg.value);
358         ethReceived = ethReceived.add(msg.value); // Update the total Ether recived
359         totalTokensSent = totalTokensSent.add(tokensToSend);
360 
361         if (!token.transfer(_backer, tokensToSend)) 
362             revert(); // Transfer SOCX tokens
363 
364         multisig.transfer(msg.value);  // send money to multisignature wallet
365         LogReceivedETH(_backer, msg.value, tokensToSend); // Register event
366         return true;
367     }
368 
369     // @notice This function will return number of tokens based on time intervals in the campaign
370     function calculateNoOfTokensToSend() internal constant  returns (uint) {
371 
372         uint tokenAmount = msg.value.mul(1e8) / tokenPriceWei;        
373 
374         if (block.number <= startBlock + (numOfBlocksInMinute * 60) / 100)  // less then one hour
375             return  tokenAmount + (tokenAmount * 50) / 100;
376         else if (block.number <= startBlock + (numOfBlocksInMinute * 60 * 24) / 100)  // less than one day
377             return  tokenAmount + (tokenAmount * 25) / 100; 
378         else if (block.number <= startBlock + (numOfBlocksInMinute * 60 * 24 * 2) / 100)  // less than two days
379             return  tokenAmount + (tokenAmount * 10) / 100; 
380         else if (block.number <= startBlock + (numOfBlocksInMinute * 60 * 24 * 3) / 100)  // less than three days
381             return  tokenAmount + (tokenAmount * 5) / 100;
382         else                                                                // after 3 days
383             return  tokenAmount;     
384     }
385 }
386 
387 
388 
389 // The SOCX token
390 contract Token is ERC20, Ownable {
391     
392     using SafeMath for uint;
393     
394     // Public variables of the token
395     string public name;
396     string public symbol;
397     uint8 public decimals; // How many decimals to show.
398     string public version = "v0.1";
399     uint public initialSupply;
400     uint public totalSupply;
401     bool public locked;           
402     mapping(address => uint) balances;
403     mapping(address => mapping(address => uint)) allowed;
404     address public migrationMaster;
405     address public migrationAgent;
406     address public crowdSaleAddress;
407     uint256 public totalMigrated;
408 
409     // Lock transfer for contributors during the ICO 
410     modifier onlyUnlocked() {
411         if (msg.sender != crowdSaleAddress && locked) 
412             revert();
413         _;
414     }
415 
416     modifier onlyAuthorized() {
417         if (msg.sender != owner && msg.sender != crowdSaleAddress) 
418             revert();
419         _;
420     }
421 
422     // The SOCX Token created with the time at which the crowdsale ends
423     function Token(address _crowdSaleAddress, address _migrationMaster) public {
424         // Lock the transfCrowdsaleer function during the crowdsale
425         locked = true; // Lock the transfer of tokens during the crowdsale
426         initialSupply = 90000000e8;
427         totalSupply = initialSupply;
428         name = "SocialX"; // Set the name for display purposes
429         symbol = "SOCX"; // Set the symbol for display purposes
430         decimals = 8; // Amount of decimals for display purposes
431         crowdSaleAddress = _crowdSaleAddress;              
432         balances[crowdSaleAddress] = totalSupply;
433         migrationMaster = _migrationMaster;
434     }
435 
436     function unlock() public onlyAuthorized {
437         locked = false;
438     }
439 
440     function lock() public onlyAuthorized {
441         locked = true;
442     }
443 
444     event Migrate(address indexed _from, address indexed _to, uint256 _value);
445 
446     // Token migration support:
447 
448     /// @notice Migrate tokens to the new token contract.
449     /// @dev Required state: Operational Migration
450     /// @param _value The amount of token to be migrated
451     function migrate(uint256 _value) external onlyUnlocked() {
452         // Abort if not in Operational Migration state.
453         
454         if (migrationAgent == 0) 
455             revert();
456         
457         // Validate input value.
458         if (_value == 0) 
459             revert();
460         if (_value > balances[msg.sender]) 
461             revert();
462 
463         balances[msg.sender] -= _value;
464         totalSupply -= _value;
465         totalMigrated += _value;
466         MigrationAgent(migrationAgent).migrateFrom(msg.sender, _value);
467         Migrate(msg.sender, migrationAgent, _value);
468     }
469 
470     /// @notice Set address of migration target contract and enable migration
471     /// process.
472     /// @dev Required state: Operational Normal
473     /// @dev State transition: -> Operational Migration
474     /// @param _agent The address of the MigrationAgent contract
475     function setMigrationAgent(address _agent) external onlyUnlocked() {
476         // Abort if not in Operational Normal state.
477         
478         require(migrationAgent == 0);
479         require(msg.sender == migrationMaster);
480         migrationAgent = _agent;
481     }
482 
483     function resetCrowdSaleAddress(address _newCrowdSaleAddress) external onlyAuthorized() {
484         crowdSaleAddress = _newCrowdSaleAddress;
485     }
486     
487     function setMigrationMaster(address _master) external {       
488         require(msg.sender == migrationMaster);
489         require(_master != 0);
490         migrationMaster = _master;
491     }
492 
493    // @notice burn tokens in case campaign failed
494     // @param _member {address} of member
495     // @param _value {uint} amount of tokens to burn
496     // @return  {bool} true if successful
497     function burn( address _member, uint256 _value) public onlyAuthorized returns(bool) {
498         balances[_member] = balances[_member].sub(_value);
499         totalSupply = totalSupply.sub(_value);
500         Transfer(_member, 0x0, _value);
501         return true;
502     }
503 
504     // @notice transfer tokens to given address 
505     // @param _to {address} address or recipient
506     // @param _value {uint} amount to transfer
507     // @return  {bool} true if successful  
508     function transfer(address _to, uint _value) public onlyUnlocked returns(bool) {
509         balances[msg.sender] = balances[msg.sender].sub(_value);
510         balances[_to] = balances[_to].add(_value);
511         Transfer(msg.sender, _to, _value);
512         return true;
513     }
514 
515     // @notice transfer tokens from given address to another address
516     // @param _from {address} from whom tokens are transferred 
517     // @param _to {address} to whom tokens are transferred
518     // @parm _value {uint} amount of tokens to transfer
519     // @return  {bool} true if successful   
520     function transferFrom(address _from, address _to, uint256 _value) public onlyUnlocked returns(bool success) {
521         require(balances[_from] >= _value); // Check if the sender has enough                            
522         require(_value <= allowed[_from][msg.sender]); // Check if allowed is greater or equal        
523         balances[_from] = balances[_from].sub(_value); // Subtract from the sender
524         balances[_to] = balances[_to].add(_value); // Add the same to the recipient
525         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
526         Transfer(_from, _to, _value);
527         return true;
528     }
529 
530     // @notice to query balance of account
531     // @return _owner {address} address of user to query balance 
532     function balanceOf(address _owner) public view returns(uint balance) {
533         return balances[_owner];
534     }
535 
536     /**
537     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
538     *
539     * Beware that changing an allowance with this method brings the risk that someone may use both the old
540     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
541     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
542     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
543     * @param _spender The address which will spend the funds.
544     * @param _value The amount of tokens to be spent.
545     */
546     function approve(address _spender, uint _value) public returns(bool) {
547         allowed[msg.sender][_spender] = _value;
548         Approval(msg.sender, _spender, _value);
549         return true;
550     }
551 
552     // @notice to query of allowance of one user to the other
553     // @param _owner {address} of the owner of the account
554     // @param _spender {address} of the spender of the account
555     // @return remaining {uint} amount of remaining allowance
556     function allowance(address _owner, address _spender) public view returns(uint remaining) {
557         return allowed[_owner][_spender];
558     }
559 
560     /**
561     * approve should be called when allowed[_spender] == 0. To increment
562     * allowed value is better to use this function to avoid 2 calls (and wait until
563     * the first transaction is mined)
564     * From MonolithDAO Token.sol
565     */
566     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
567         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
568         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
569         return true;
570     }
571 
572     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
573         uint oldValue = allowed[msg.sender][_spender];
574         if (_subtractedValue > oldValue) {
575             allowed[msg.sender][_spender] = 0;
576         } else {
577             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
578         }
579         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
580         return true;
581     }
582 
583 }