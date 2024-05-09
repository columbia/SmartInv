1 pragma solidity ^ 0.4.17;
2 
3 library SafeMath {
4     function mul(uint a, uint b) pure internal returns(uint) {
5         uint c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10 
11     function sub(uint a, uint b) pure internal returns(uint) {
12         assert(b <= a);
13         return a - b;
14     }
15 
16     function add(uint a, uint b) pure internal returns(uint) {
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
41 contract Ownable {
42     address public owner;
43 
44     function Ownable() public {
45         owner = msg.sender;
46     }
47 
48     function transferOwnership(address newOwner) public onlyOwner {
49         if (newOwner != address(0)) 
50             owner = newOwner;
51     }
52 
53     function kill() public {
54         if (msg.sender == owner) 
55             selfdestruct(owner);
56     }
57 
58     modifier onlyOwner() {
59         if (msg.sender == owner)
60             _;
61     }
62 }
63 
64 contract Pausable is Ownable {
65     bool public stopped;
66 
67     modifier stopInEmergency {
68         if (stopped) {
69             revert();
70         }
71         _;
72     }
73 
74     modifier onlyInEmergency {
75         if (!stopped) {
76             revert();
77         }
78         _;
79     }
80 
81     // Called by the owner in emergency, triggers stopped state
82     function emergencyStop() external onlyOwner() {
83         stopped = true;
84     }
85 
86     // Called by the owner to end of emergency, returns to normal state
87     function release() external onlyOwner() onlyInEmergency {
88         stopped = false;
89     }
90 }
91 
92 
93 
94 
95 
96 // Crowdsale Smart Contract
97 // This smart contract collects ETH and in return sends tokens to contributors
98 contract Crowdsale is Pausable {
99 
100     using SafeMath for uint;
101 
102     struct Backer {
103         uint weiReceived; // amount of ETH contributed
104         uint tokensSent; // amount of tokens  sent  
105         bool refunded; // true if user has been refunded       
106     }
107 
108     Token public token; // Token contract reference   
109     address public multisig; // Multisig contract that will receive the ETH    
110     address public team; // Address at which the team tokens will be sent     
111     address public lottery; //address for 50% of remaining tokens 
112     uint public ethReceivedPresale; // Number of ETH received in presal
113     uint public ethReceivedMain; // Number of ETH received in main sale
114     uint public totalTokensSent; // Number of sent to ETH contributors
115     uint public startBlock; // Crowdsale start block
116     uint public endBlock; // Crowdsale end block
117     uint public maxCap; // Maximum number of to sell
118     uint public minCap; // Minimum number of ETH to raise
119     uint public minInvestETH; // Minimum amount to invest   
120     bool public crowdsaleClosed; // Is crowdsale still on going
121     Step public currentStep;  // to allow for controled steps of the campaign 
122     uint public refundCount;  // number of refunds
123     uint public totalRefunded; // total amount of refunds    
124     uint public tokenPriceWei;
125 
126     mapping(address => Backer) public backers; //backer list
127     address[] public backersIndex; // to be able to itarate through backers for verification.  
128 
129 
130      // @ntice ovwrite to ensure that if any money are left, they go 
131      // to multisig wallet
132      function kill() public {
133         if (msg.sender == owner) 
134             selfdestruct(multisig);
135     }
136 
137     // @notice to verify if action is not performed out of the campaing range
138     modifier respectTimeFrame() {
139         if ((block.number < startBlock) || (block.number > endBlock)) 
140             revert();
141         _;
142     }
143 
144 
145     modifier minCapNotReached() {
146         if (ethReceivedPresale.add(ethReceivedMain) >= minCap) 
147             revert();
148         _;
149     }
150 
151 
152     // @notice to set and determine steps of crowdsale
153     enum Step {
154         Unknown,
155         FundingPreSale,     // presale mode
156         FundingPublicSale,  // public mode
157         Refunding  // in case campaign failed during this step contributors will be able to receive refunds
158     }
159 
160 
161     // Events
162     event ReceivedETH(address backer, uint amount, uint tokenAmount);
163     event RefundETH(address backer, uint amount);
164 
165 
166     // Crowdsale  {constructor}
167     // @notice fired when contract is crated. Initilizes all constnat variables.
168     function Crowdsale() public {
169         
170         multisig = 0xC30b7a7d82c71467AF9eC85e039e4ED586EF9812; 
171         team = 0xC30b7a7d82c71467AF9eC85e039e4ED586EF9812;       
172         lottery = 0xC30b7a7d82c71467AF9eC85e039e4ED586EF9812;                                                         
173         maxCap = 14700000e18;        
174         tokenPriceWei = 6666666666e5;
175         totalTokensSent = 0; 
176         minCap = (750 ether * 1e18) / tokenPriceWei;
177         setStep(Step.FundingPreSale);
178     }
179 
180        // @notice to populate website with status of the sale 
181     function returnWebsiteData() external constant returns(uint, uint, uint, uint, uint, uint, uint, uint, Step, bool, bool) {
182         
183     
184         return (startBlock, endBlock, backersIndex.length, ethReceivedPresale.add(ethReceivedMain), maxCap, minCap, totalTokensSent,  tokenPriceWei, currentStep, stopped, crowdsaleClosed);
185     }
186 
187     // @notice in case refunds are needed, money can be returned to the contract
188     function fundContract() external payable onlyOwner() returns (bool) {
189         return true;
190     }
191 
192 
193     // @notice Specify address of token contract
194     // @param _tokenAddress {address} address of token contrac
195     // @return res {bool}
196     function updateTokenAddress(Token _tokenAddress) external onlyOwner() returns(bool res) {
197         token = _tokenAddress;
198         return true;
199     }
200 
201 
202     // @notice set the step of the campaign 
203     // @param _step {Step}
204     function setStep(Step _step) public onlyOwner() {
205         currentStep = _step;
206         
207         if (currentStep == Step.FundingPreSale)  // for presale             
208             minInvestETH = 1 ether/4;                             
209         else if (currentStep == Step.FundingPublicSale) // for public sale           
210             minInvestETH = 0;                               
211     }
212 
213 
214     // @notice return number of contributors
215     // @return  {uint} number of contributors   
216     function numberOfBackers() public constant returns(uint) {
217         return backersIndex.length;
218     }
219 
220 
221 
222     // {fallback function}
223     // @notice It will call internal function which handels allocation of Ether and calculates tokens.
224     function () external payable {           
225         contribute(msg.sender);
226     }
227 
228 
229     // @notice It will be called by owner to start the sale    
230     function start(uint _block) external onlyOwner() {   
231 
232         require(_block < 216000);  // 2.5*60*24*60 days = 216000     
233         startBlock = block.number;
234         endBlock = startBlock.add(_block); 
235     }
236 
237     // @notice Due to changing average of block time
238     // this function will allow on adjusting duration of campaign closer to the end 
239     function adjustDuration(uint _block) external onlyOwner() {
240 
241         require(_block < 288000);  // 2.5*60*24*80 days = 288000     
242         require(_block > block.number.sub(startBlock)); // ensure that endBlock is not set in the past
243         endBlock = startBlock.add(_block); 
244     }
245 
246     // @notice It will be called by fallback function whenever ether is sent to it
247     // @param  _backer {address} address of beneficiary
248     // @return res {bool} true if transaction was successful
249     function contribute(address _backer) internal stopInEmergency respectTimeFrame returns(bool res) {
250 
251         uint tokensToSend = validPurchase();
252             
253         Backer storage backer = backers[_backer];
254 
255         if (!token.transfer(_backer, tokensToSend)) 
256             revert(); // Transfer tokens
257         backer.tokensSent = backer.tokensSent.add(tokensToSend); // save contributors tokens to be sent
258         backer.weiReceived = backer.weiReceived.add(msg.value);  // save how much was the contribution
259 
260         if (Step.FundingPublicSale == currentStep)  // Update the total Ether recived
261            ethReceivedMain = ethReceivedMain.add(msg.value);
262         else
263             ethReceivedPresale = ethReceivedPresale.add(msg.value); 
264                                                      
265         totalTokensSent = totalTokensSent.add(tokensToSend);     // update the total amount of tokens sent
266         backersIndex.push(_backer);
267 
268         multisig.transfer(this.balance);   // transfer funds to multisignature wallet             
269 
270         ReceivedETH(_backer, msg.value, tokensToSend); // Register event
271         return true;
272     }
273 
274 
275 
276     // @notice determine if purchase is valid and return proper number of tokens
277     // @return tokensToSend {uint} proper number of tokens based on the timline
278 
279     function validPurchase() constant internal returns (uint) {
280        
281         require (msg.value >= minInvestETH);   // ensure that min contributions amount is met
282 
283         // calculate amount of tokens to send  (add 18 0s first)   
284         uint tokensToSend = msg.value.mul(1e18) / tokenPriceWei;  // basic nmumber of tokens to send
285           
286         if (Step.FundingPublicSale == currentStep)   // calculate stepped price of token in public sale
287             tokensToSend = calculateNoOfTokensToSend(tokensToSend); 
288         else                                         // calculate number of tokens for presale with 50% bonus
289             tokensToSend = tokensToSend.add(tokensToSend.mul(50) / 100);
290           
291         require(totalTokensSent.add(tokensToSend) < maxCap); // Ensure that max cap hasn't been reached  
292 
293         return tokensToSend;
294     }
295     
296     // @notice It is called by handleETH to determine amount of tokens for given contribution
297     // @param _amount {uint} current range computed
298     // @return tokensToPurchase {uint} value of tokens to purchase
299     function calculateNoOfTokensToSend(uint _amount) internal constant returns(uint) {
300    
301         if (ethReceivedMain <= 1500 ether)        // First 1500 ETH: 25%
302             return _amount.add(_amount.mul(25) / 100);
303         else if (ethReceivedMain <= 2500 ether)   // 1501 to 2500 ETH: 15%              
304             return _amount.add(_amount.mul(15) / 100);
305         else if (ethReceivedMain < 3000 ether)   // 2501 to 3000 ETH: 10%
306             return _amount.add(_amount.mul(10) / 100);
307         else if (ethReceivedMain <= 4000 ether)  // 3001 to 4000 ETH: 5%
308             return _amount.add(_amount.mul(5) / 100);
309         else if (ethReceivedMain <= 5000 ether)  // 4001 to 5000 ETH : 2%
310             return _amount.add(_amount.mul(2) / 100);
311         else                                 // 5000+ No bonus after that
312             return _amount;
313     }
314 
315     // @notice show for display purpose amount of tokens which can be bought 
316     // at given moment. 
317     // @param _ether {uint} amount of ehter
318     function estimateTokenNumber(uint _amountWei ) external view returns (uint) { 
319         return calculateNoOfTokensToSend(_amountWei);
320     }
321 
322     // @notice This function will finalize the sale.
323     // It will only execute if predetermined sale time passed or all tokens are sold.
324     function finalize() external onlyOwner() {
325 
326         uint totalEtherReceived = ethReceivedPresale.add(ethReceivedMain);
327 
328         require(!crowdsaleClosed);        
329         // purchasing precise number of tokens might be impractical, thus subtract 100 tokens so finalizition is possible
330         // near the end 
331         require (block.number >= endBlock || totalTokensSent >= maxCap.sub(100)); 
332         require(totalEtherReceived >= minCap && block.number >= endBlock);             
333 
334         if (totalTokensSent >= minCap) {           
335             if (!token.transfer(team, 6300000e18)) // transfer tokens for the team/dev/advisors
336                 revert();
337             if (!token.transfer(lottery, token.balanceOf(this) / 2)) 
338                 revert();
339             if (!token.burn(this, token.balanceOf(this)))
340                 revert();
341              token.unlock();
342         }
343         crowdsaleClosed = true;       
344     }
345 
346   
347 
348     // @notice Failsafe drain
349     function drain() external onlyOwner() {
350         multisig.transfer(this.balance);               
351     }
352 
353 
354 
355     // @notice Failsafe token transfer
356     function tokenDrian() external onlyOwner() {
357        if (block.number > endBlock) {
358         if (!token.transfer(team, token.balanceOf(this))) 
359                 revert();
360         }
361     }
362     
363 
364 
365     function refund()  external stopInEmergency returns (bool) {
366 
367         require(totalTokensSent < minCap); 
368         require(this.balance > 0);  // contract will hold 0 ether at the end of campaign.                                  
369                                     // contract needs to be funded through fundContract() 
370 
371         Backer storage backer = backers[msg.sender];
372 
373         if (backer.weiReceived == 0)
374             revert();
375 
376         require(!backer.refunded);
377         require(backer.tokensSent != 0);
378 
379         if (!token.burn(msg.sender, backer.tokensSent))
380             revert();
381         backer.refunded = true;
382       
383         refundCount ++;
384         totalRefunded = totalRefunded.add(backer.weiReceived);
385         msg.sender.transfer(backer.weiReceived);
386         RefundETH(msg.sender, backer.weiReceived);
387         return true;
388     }
389 }
390 
391 // The token
392 contract Token is ERC20,  Ownable {
393 
394     using SafeMath for uint;
395     // Public variables of the token
396     string public name;
397     string public symbol;
398     uint8 public decimals; // How many decimals to show.
399     string public version = "v0.1";       
400     uint public totalSupply;
401     bool public locked;
402     address public crowdSaleAddress;
403     
404 
405 
406     mapping(address => uint) balances;
407     mapping(address => mapping(address => uint)) allowed;
408 
409     // tokens are locked during the ICO. Allow transfer of tokens after ICO. 
410     modifier onlyUnlocked() {
411         if (msg.sender != crowdSaleAddress && locked) 
412             revert();
413         _;
414     }
415 
416 
417     // allow burning of tokens only by authorized users 
418     modifier onlyAuthorized() {
419         if (msg.sender != owner && msg.sender != crowdSaleAddress ) 
420             revert();
421         _;
422     }
423 
424 
425     // The Token 
426     function Token(address _crowdSaleAddress) public {
427         
428         locked = true;  // Lock the transfCrowdsaleer function during the crowdsale
429         totalSupply = 21000000e18; 
430         name = "Lottery Token"; // Set the name for display purposes
431         symbol = "ETHD"; // Set the symbol for display purposes
432         decimals = 18; // Amount of decimals for display purposes
433         crowdSaleAddress = _crowdSaleAddress;                                  
434         balances[crowdSaleAddress] = totalSupply;
435     }
436 
437     function unlock() public onlyAuthorized {
438         locked = false;
439     }
440 
441     function lock() public onlyAuthorized {
442         locked = true;
443     }
444     
445 
446     function burn( address _member, uint256 _value) public onlyAuthorized returns(bool) {
447         balances[_member] = balances[_member].sub(_value);
448         totalSupply = totalSupply.sub(_value);
449         Transfer(_member, 0x0, _value);
450         return true;
451     }
452 
453     function transfer(address _to, uint _value) public onlyUnlocked returns(bool) {
454         balances[msg.sender] = balances[msg.sender].sub(_value);
455         balances[_to] = balances[_to].add(_value);
456         Transfer(msg.sender, _to, _value);
457         return true;
458     }
459 
460     
461     function transferFrom(address _from, address _to, uint256 _value) public onlyUnlocked returns(bool success) {
462         require (balances[_from] >= _value); // Check if the sender has enough                            
463         require (_value <= allowed[_from][msg.sender]); // Check if allowed is greater or equal        
464         balances[_from] = balances[_from].sub(_value); // Subtract from the sender
465         balances[_to] = balances[_to].add(_value); // Add the same to the recipient
466         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
467         Transfer(_from, _to, _value);
468         return true;
469     }
470 
471     function balanceOf(address _owner) public view returns(uint balance) {
472         return balances[_owner];
473     }
474 
475 
476     /**
477     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
478     *
479     * Beware that changing an allowance with this method brings the risk that someone may use both the old
480     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
481     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
482     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
483     * @param _spender The address which will spend the funds.
484     * @param _value The amount of tokens to be spent.
485     */
486     function approve(address _spender, uint _value) public returns(bool) {
487         allowed[msg.sender][_spender] = _value;
488         Approval(msg.sender, _spender, _value);
489         return true;
490     }
491 
492 
493     function allowance(address _owner, address _spender) public constant returns(uint remaining) {
494         return allowed[_owner][_spender];
495     }
496 
497     /**
498     * approve should be called when allowed[_spender] == 0. To increment
499     * allowed value is better to use this function to avoid 2 calls (and wait until
500     * the first transaction is mined)
501     * From MonolithDAO Token.sol
502     */
503     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
504         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
505         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
506         return true;
507     }
508 
509     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
510         uint oldValue = allowed[msg.sender][_spender];
511         if (_subtractedValue > oldValue) {
512         allowed[msg.sender][_spender] = 0;
513         } else {
514         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
515         }
516         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
517         return true;
518     }
519 
520 }