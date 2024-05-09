1 pragma solidity 0.4.21;
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
23 
24 /**
25  * @title Ownable
26  * @dev The Ownable contract has an owner address, and provides basic authorization control
27  * functions, this simplifies the implementation of "user permissions".
28  */
29 contract Ownable {
30     address public owner;
31     address public newOwner;
32 
33     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35     /**
36     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
37     * account.
38     */
39     function Ownable() public {
40         owner = msg.sender;
41         newOwner = address(0);
42     }
43 
44     /**
45     * @dev Throws if called by any account other than the owner.
46     */
47     modifier onlyOwner() {
48         require(msg.sender == owner);
49         _;
50     }
51 
52     /**
53     * @dev Allows the current owner to transfer control of the contract to a newOwner.
54     * @param _newOwner The address to transfer ownership to.
55     */
56     function transferOwnership(address _newOwner) public onlyOwner {
57         require(address(0) != _newOwner);
58         newOwner = _newOwner;
59     }
60 
61     function acceptOwnership() public {
62         require(msg.sender == newOwner);
63         emit OwnershipTransferred(owner, msg.sender);
64         owner = msg.sender;
65         newOwner = address(0);
66     }
67 
68 }
69 
70 /**
71  * @title Pausable
72  * @dev Base contract which allows children to implement an emergency stop mechanism.
73  */
74 contract Pausable is Ownable {
75     event Pause();
76     event Unpause();
77 
78     bool public paused = false;
79 
80     /**
81     * @dev Modifier to make a function callable only when the contract is not paused.
82     */
83     modifier whenNotPaused() {
84         require(!paused);
85         _;
86     }
87 
88     /**
89     * @dev Modifier to make a function callable only when the contract is paused.
90     */
91     modifier whenPaused() {
92         require(paused);
93         _;
94     }
95 
96     /**
97     * @dev called by the owner to pause, triggers stopped state
98     */
99     function pause() public onlyOwner whenNotPaused {
100         paused = true;
101         emit Pause();
102     }
103 
104     /**
105     * @dev called by the owner to unpause, returns to normal state
106     */
107     function unpause() public onlyOwner whenPaused {
108         paused = false;
109         emit Unpause();
110     }
111 }
112 
113 
114 // Crowdsale Smart Contract
115 // This smart contract collects ETH and in return sends tokens to contributors
116 contract Crowdsale is Pausable {
117 
118     using SafeMath for uint;
119 
120     struct Backer {
121         uint weiReceived; // amount of ETH contributed
122         uint tokensToSend; // amount of tokens  sent
123         bool refunded;
124     }
125 
126     Token public token; // Token contract reference
127     address public multisig; // Multisig contract that will receive the ETH
128     address public team; // Address at which the team tokens will be sent
129     uint public ethReceivedPresale; // Number of ETH received in presale
130     uint public ethReceivedMain; // Number of ETH received in public sale
131     uint public tokensSentPresale; // Tokens sent during presale
132     uint public tokensSentMain; // Tokens sent during public ICO
133     uint public totalTokensSent; // Total number of tokens sent to contributors
134     uint public startBlock; // Crowdsale start block
135     uint public endBlock; // Crowdsale end block
136     uint public maxCap; // Maximum number of tokens to sell
137     uint public minInvestETH; // Minimum amount to invest
138     bool public crowdsaleClosed; // Is crowdsale still in progress
139     Step public currentStep;  // To allow for controlled steps of the campaign
140     uint public refundCount;  // Number of refunds
141     uint public totalRefunded; // Total amount of Eth refunded
142     uint public numOfBlocksInMinute; // number of blocks in one minute * 100. eg.
143     WhiteList public whiteList;     // whitelist contract
144     uint public tokenPriceWei;      // Price of token in wei
145 
146     mapping(address => Backer) public backers; // contributors list
147     address[] public backersIndex; // to be able to iterate through backers for verification.
148     uint public priorTokensSent;
149     uint public presaleCap;
150 
151 
152     // @notice to verify if action is not performed out of the campaign range
153     modifier respectTimeFrame() {
154         require(block.number >= startBlock && block.number <= endBlock);
155         _;
156     }
157 
158     // @notice to set and determine steps of crowdsale
159     enum Step {
160         FundingPreSale,     // presale mode
161         FundingPublicSale,  // public mode
162         Refunding  // in case campaign failed during this step contributors will be able to receive refunds
163     }
164 
165     // Events
166     event ReceivedETH(address indexed backer, uint amount, uint tokenAmount);
167     event RefundETH(address indexed backer, uint amount);
168 
169     // Crowdsale  {constructor}
170     // @notice fired when contract is crated. Initializes all constant and initial values.
171     // @param _dollarToEtherRatio {uint} how many dollars are in one eth.  $333.44/ETH would be passed as 33344
172     function Crowdsale(WhiteList _whiteList) public {
173 
174         require(_whiteList != address(0));
175         multisig = 0x10f78f2a70B52e6c3b490113c72Ba9A90ff1b5CA;
176         team = 0x10f78f2a70B52e6c3b490113c72Ba9A90ff1b5CA;
177         maxCap = 1510000000e8;
178         minInvestETH = 1 ether/2;
179         currentStep = Step.FundingPreSale;
180         numOfBlocksInMinute = 408;          // E.g. 4.38 block/per minute wold be entered as 438
181         priorTokensSent = 4365098999e7;     //tokens distributed in private sale and airdrops
182         whiteList = _whiteList;             // white list address
183         presaleCap = 160000000e8;           // max for sell in presale
184         tokenPriceWei = 57142857142857;     // 17500 tokens per ether
185     }
186 
187     // @notice Specify address of token contract
188     // @param _tokenAddress {address} address of token contract
189     // @return res {bool}
190     function setTokenAddress(Token _tokenAddress) external onlyOwner() returns(bool res) {
191         require(token == address(0));
192         token = _tokenAddress;
193         return true;
194     }
195 
196     // @notice set the step of the campaign from presale to public sale
197     // contract is deployed in presale mode
198     // WARNING: there is no way to go back
199     function advanceStep() public onlyOwner() {
200         require(Step.FundingPreSale == currentStep);
201         currentStep = Step.FundingPublicSale;
202         minInvestETH = 1 ether/4;
203     }
204 
205     // @notice in case refunds are needed, money can be returned to the contract
206     // and contract switched to mode refunding
207     function prepareRefund() public payable onlyOwner() {
208 
209         require(crowdsaleClosed);
210         require(msg.value == ethReceivedPresale.add(ethReceivedMain)); // make sure that proper amount of ether is sent
211         currentStep = Step.Refunding;
212     }
213 
214     // @notice return number of contributors
215     // @return  {uint} number of contributors
216     function numberOfBackers() public view returns(uint) {
217         return backersIndex.length;
218     }
219 
220     // {fallback function}
221     // @notice It will call internal function which handles allocation of Ether and calculates tokens.
222     // Contributor will be instructed to specify sufficient amount of gas. e.g. 250,000
223     function () external payable {
224         contribute(msg.sender);
225     }
226 
227     // @notice It will be called by owner to start the sale
228     function start(uint _block) external onlyOwner() {
229 
230         require(startBlock == 0);
231         require(_block <= (numOfBlocksInMinute * 60 * 24 * 54)/100);  // allow max 54 days for campaign
232         startBlock = block.number;
233         endBlock = startBlock.add(_block);
234     }
235 
236     // @notice Due to changing average of block time
237     // this function will allow on adjusting duration of campaign closer to the end
238     function adjustDuration(uint _block) external onlyOwner() {
239 
240         require(startBlock > 0);
241         require(_block < (numOfBlocksInMinute * 60 * 24 * 60)/100); // allow for max of 60 days for campaign
242         require(_block > block.number.sub(startBlock)); // ensure that endBlock is not set in the past
243         endBlock = startBlock.add(_block);
244     }
245 
246     // @notice It will be called by fallback function whenever ether is sent to it
247     // @param  _backer {address} address of contributor
248     // @return res {bool} true if transaction was successful
249     function contribute(address _backer) internal whenNotPaused() respectTimeFrame() returns(bool res) {
250         require(!crowdsaleClosed);
251         require(whiteList.isWhiteListed(_backer));      // ensure that user is whitelisted
252 
253         uint tokensToSend = determinePurchase();
254 
255         Backer storage backer = backers[_backer];
256 
257         if (backer.weiReceived == 0)
258             backersIndex.push(_backer);
259 
260         backer.tokensToSend += tokensToSend; // save contributor's total tokens sent
261         backer.weiReceived = backer.weiReceived.add(msg.value);  // save contributor's total ether contributed
262 
263         if (Step.FundingPublicSale == currentStep) { // Update the total Ether received and tokens sent during public sale
264             ethReceivedMain = ethReceivedMain.add(msg.value);
265             tokensSentMain += tokensToSend;
266         }else {                                                 // Update the total Ether recived and tokens sent during presale
267             ethReceivedPresale = ethReceivedPresale.add(msg.value);
268             tokensSentPresale += tokensToSend;
269         }
270 
271         totalTokensSent += tokensToSend;     // update the total amount of tokens sent
272         multisig.transfer(address(this).balance);   // transfer funds to multisignature wallet
273 
274         require(token.transfer(_backer, tokensToSend));   // Transfer tokens
275 
276         emit ReceivedETH(_backer, msg.value, tokensToSend); // Register event
277         return true;
278     }
279 
280     // @notice determine if purchase is valid and return proper number of tokens
281     // @return tokensToSend {uint} proper number of tokens based on the timline
282     function determinePurchase() internal view  returns (uint) {
283 
284         require(msg.value >= minInvestETH);   // ensure that min contributions amount is met
285 
286         uint tokensToSend = msg.value.mul(1e8) / tokenPriceWei;   //1e8 ensures that token gets 8 decimal values
287 
288         if (Step.FundingPublicSale == currentStep) {  // calculate price of token in public sale
289             require(totalTokensSent + tokensToSend + priorTokensSent <= maxCap); // Ensure that max cap hasn't been reached
290         }else {
291             tokensToSend += (tokensToSend * 50) / 100;
292             require(totalTokensSent + tokensToSend <= presaleCap); // Ensure that max cap hasn't been reached for presale
293         }
294         return tokensToSend;
295     }
296 
297 
298     // @notice This function will finalize the sale.
299     // It will only execute if predetermined sale time passed or all tokens are sold.
300     // it will fail if minimum cap is not reached
301     function finalize() external onlyOwner() {
302 
303         require(!crowdsaleClosed);
304         // purchasing precise number of tokens might be impractical, thus subtract 1000
305         // tokens so finalization is possible near the end
306         require(block.number >= endBlock || totalTokensSent + priorTokensSent >= maxCap - 1000);
307         crowdsaleClosed = true;
308 
309         require(token.transfer(team, token.balanceOf(this))); // transfer all remaining tokens to team address
310         token.unlock();
311     }
312 
313     // @notice Fail-safe drain
314     function drain() external onlyOwner() {
315         multisig.transfer(address(this).balance);
316     }
317 
318     // @notice Fail-safe token transfer
319     function tokenDrain() external onlyOwner() {
320         if (block.number > endBlock) {
321             require(token.transfer(multisig, token.balanceOf(this)));
322         }
323     }
324 
325     // @notice it will allow contributors to get refund in case campaign failed
326     // @return {bool} true if successful
327     function refund() external whenNotPaused() returns (bool) {
328 
329         require(currentStep == Step.Refunding);
330 
331         Backer storage backer = backers[msg.sender];
332 
333         require(backer.weiReceived > 0);  // ensure that user has sent contribution
334         require(!backer.refunded);        // ensure that user hasn't been refunded yet
335 
336         backer.refunded = true;  // save refund status to true
337         refundCount++;
338         totalRefunded = totalRefunded + backer.weiReceived;
339 
340         require(token.transfer(msg.sender, backer.tokensToSend)); // return allocated tokens
341         msg.sender.transfer(backer.weiReceived);  // send back the contribution
342         emit RefundETH(msg.sender, backer.weiReceived);
343         return true;
344     }
345 
346 
347 
348 }
349 
350 
351 contract ERC20 {
352     uint public totalSupply;
353 
354     function balanceOf(address who) public view returns(uint);
355 
356     function allowance(address owner, address spender) public view returns(uint);
357 
358     function transfer(address to, uint value) public returns(bool ok);
359 
360     function transferFrom(address from, address to, uint value) public returns(bool ok);
361 
362     function approve(address spender, uint value) public returns(bool ok);
363 
364     event Transfer(address indexed from, address indexed to, uint value);
365     event Approval(address indexed owner, address indexed spender, uint value);
366 }
367 
368 
369 // The token
370 contract Token is ERC20, Ownable {
371 
372     using SafeMath for uint;
373 
374     // Public variables of the token
375     string public name;
376     string public symbol;
377     uint8 public decimals; // How many decimals to show.
378     string public version = "v0.1";
379     uint public totalSupply;
380     bool public locked;
381     mapping(address => uint) balances;
382     mapping(address => mapping(address => uint)) allowed;
383     address public crowdSaleAddress;
384 
385 
386     // Lock transfer for contributors during the ICO
387     modifier onlyUnlocked() {
388         if (msg.sender != crowdSaleAddress && msg.sender != owner && locked)
389             revert();
390         _;
391     }
392 
393     modifier onlyAuthorized() {
394         if (msg.sender != owner && msg.sender != crowdSaleAddress)
395             revert();
396         _;
397     }
398 
399     // @notice The Token contract
400     function Token(address _crowdsaleAddress) public {
401 
402         require(_crowdsaleAddress != address(0));
403         locked = true; // Lock the transfer of tokens during the crowdsale
404         totalSupply = 2600000000e8;
405         name = "Kripton";                           // Set the name for display purposes
406         symbol = "LPK";                             // Set the symbol for display purposes
407         decimals = 8;                               // Amount of decimals
408         crowdSaleAddress = _crowdsaleAddress;
409         balances[_crowdsaleAddress] = totalSupply;
410     }
411 
412     // @notice unlock token for trading
413     function unlock() public onlyAuthorized {
414         locked = false;
415     }
416 
417     // @lock token from trading during ICO
418     function lock() public onlyAuthorized {
419         locked = true;
420     }
421 
422     // @notice transfer tokens to given address
423     // @param _to {address} address or recipient
424     // @param _value {uint} amount to transfer
425     // @return  {bool} true if successful
426     function transfer(address _to, uint _value) public onlyUnlocked returns(bool) {
427         balances[msg.sender] = balances[msg.sender].sub(_value);
428         balances[_to] = balances[_to].add(_value);
429         emit Transfer(msg.sender, _to, _value);
430         return true;
431     }
432 
433     // @notice transfer tokens from given address to another address
434     // @param _from {address} from whom tokens are transferred
435     // @param _to {address} to whom tokens are transferred
436     // @parm _value {uint} amount of tokens to transfer
437     // @return  {bool} true if successful
438     function transferFrom(address _from, address _to, uint256 _value) public onlyUnlocked returns(bool success) {
439         require(balances[_from] >= _value); // Check if the sender has enough
440         require(_value <= allowed[_from][msg.sender]); // Check if allowed is greater or equal
441         balances[_from] = balances[_from].sub(_value); // Subtract from the sender
442         balances[_to] = balances[_to].add(_value); // Add the same to the recipient
443         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
444         emit Transfer(_from, _to, _value);
445         return true;
446     }
447 
448     // @notice to query balance of account
449     // @return _owner {address} address of user to query balance
450     function balanceOf(address _owner) public view returns(uint balance) {
451         return balances[_owner];
452     }
453 
454     /**
455     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
456     *
457     * Beware that changing an allowance with this method brings the risk that someone may use both the old
458     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
459     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
460     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
461     * @param _spender The address which will spend the funds.
462     * @param _value The amount of tokens to be spent.
463     */
464     function approve(address _spender, uint _value) public returns(bool) {
465         allowed[msg.sender][_spender] = _value;
466         emit Approval(msg.sender, _spender, _value);
467         return true;
468     }
469 
470     // @notice to query of allowance of one user to the other
471     // @param _owner {address} of the owner of the account
472     // @param _spender {address} of the spender of the account
473     // @return remaining {uint} amount of remaining allowance
474     function allowance(address _owner, address _spender) public view returns(uint remaining) {
475         return allowed[_owner][_spender];
476     }
477 
478     /**
479     * approve should be called when allowed[_spender] == 0. To increment
480     * allowed value is better to use this function to avoid 2 calls (and wait until
481     * the first transaction is mined)
482     * From MonolithDAO Token.sol
483     */
484     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
485         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
486         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
487         return true;
488     }
489 
490 
491     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
492         uint oldValue = allowed[msg.sender][_spender];
493         if (_subtractedValue > oldValue) {
494             allowed[msg.sender][_spender] = 0;
495         } else {
496             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
497         }
498         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
499         return true;
500     }
501 
502 }
503 
504 // Whitelist smart contract
505 // This smart contract keeps list of addresses to whitelist
506 contract WhiteList is Ownable {
507 
508 
509     mapping(address => bool) public whiteList;
510     uint public totalWhiteListed; //white listed users number
511 
512     event LogWhiteListed(address indexed user, uint whiteListedNum);
513     event LogWhiteListedMultiple(uint whiteListedNum);
514     event LogRemoveWhiteListed(address indexed user);
515 
516     // @notice it will return status of white listing
517     // @return true if user is white listed and false if is not
518     function isWhiteListed(address _user) external view returns (bool) {
519 
520         return whiteList[_user];
521     }
522 
523     // @notice it will remove whitelisted user
524     // @param _contributor {address} of user to unwhitelist
525     function removeFromWhiteList(address _user) external onlyOwner() {
526 
527         require(whiteList[_user] == true);
528         whiteList[_user] = false;
529         totalWhiteListed--;
530         emit LogRemoveWhiteListed(_user);
531     }
532 
533     // @notice it will white list one member
534     // @param _user {address} of user to whitelist
535     // @return true if successful
536     function addToWhiteList(address _user) external onlyOwner() {
537 
538         if (whiteList[_user] != true) {
539             whiteList[_user] = true;
540             totalWhiteListed++;
541             emit LogWhiteListed(_user, totalWhiteListed);
542         }else
543 
544             revert();
545     }
546 
547     // @notice it will white list multiple members
548     // @param _user {address[]} of users to whitelist
549     // @return true if successful
550     function addToWhiteListMultiple(address[] _users) external onlyOwner() {
551 
552         for (uint i = 0; i < _users.length; ++i) {
553 
554             if (whiteList[_users[i]] != true) {
555                 whiteList[_users[i]] = true;
556                 totalWhiteListed++;
557             }
558         }
559         emit LogWhiteListedMultiple(totalWhiteListed);
560     }
561 }