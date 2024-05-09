1 pragma solidity ^ 0.4.18;
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
24 
25 
26 
27 /**
28  * @title Ownable
29  * @dev The Ownable contract has an owner address, and provides basic authorization control
30  * functions, this simplifies the implementation of "user permissions".
31  */
32 contract Ownable {
33     address public owner;
34     
35     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37     /**
38     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
39     * account.
40     */
41     function Ownable() public {
42         owner = msg.sender;
43     }
44 
45     /**
46     * @dev Throws if called by any account other than the owner.
47     */
48     modifier onlyOwner() {
49         require(msg.sender == owner);
50         _;
51     }
52 
53     /**
54     * @dev Allows the current owner to transfer control of the contract to a newOwner.
55     * @param newOwner The address to transfer ownership to.
56     */
57     function transferOwnership(address newOwner) onlyOwner public {
58         require(newOwner != address(0));
59         OwnershipTransferred(owner, newOwner);
60         owner = newOwner;
61     }
62 
63 }
64 
65 /**
66  * @title Pausable
67  * @dev Base contract which allows children to implement an emergency stop mechanism.
68  */
69 contract Pausable is Ownable {
70     event Pause();
71     event Unpause();
72 
73     bool public paused = false;
74 
75     /**
76     * @dev Modifier to make a function callable only when the contract is not paused.
77     */
78     modifier whenNotPaused() {
79         require(!paused);
80         _;
81     }
82 
83     /**
84     * @dev Modifier to make a function callable only when the contract is paused.
85     */
86     modifier whenPaused() {
87         require(paused);
88         _;
89     }
90 
91     /**
92     * @dev called by the owner to pause, triggers stopped state
93     */
94     function pause() public onlyOwner whenNotPaused {
95         paused = true;
96         Pause();
97     }
98 
99     /**
100     * @dev called by the owner to unpause, returns to normal state
101     */
102     function unpause() public onlyOwner whenPaused {
103         paused = false;
104         Unpause();
105     }
106 }
107 
108 // @notice  Whitelist interface which will hold whitelisted users
109 contract WhiteList is Ownable {
110 
111     function isWhiteListed(address _user) external view returns (bool);        
112 }
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
142     uint public dollarToEtherRatio; // how many dollars are in one eth. Amount uses two decimal values. e.g. $333.44/ETH would be passed as 33344 
143     uint public numOfBlocksInMinute; // number of blocks in one minute * 100. eg. 
144     WhiteList public whiteList;     // whitelist contract
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
173         multisig = 0x10f78f2a70B52e6c3b490113c72Ba9A90ff1b5CA; 
174         team = 0x10f78f2a70B52e6c3b490113c72Ba9A90ff1b5CA; 
175         maxCap = 1510000000e8;             
176         minInvestETH = 1 ether/2;    
177         currentStep = Step.FundingPreSale;
178         dollarToEtherRatio = 56413;       
179         numOfBlocksInMinute = 408;          // E.g. 4.38 block/per minute wold be entered as 438                  
180         priorTokensSent = 4365098999e7;     //tokens distributed in private sale and airdrops
181         whiteList = _whiteList;             // white list address
182         presaleCap = 107000000e8;           // max for sell in presale
183 
184     }
185 
186     // @notice to populate website with status of the sale and minimize amout of calls for each variable
187     function returnWebsiteData() external view returns(uint, uint, uint, uint, uint, uint, Step, bool, bool) {            
188     
189         return (startBlock, endBlock, backersIndex.length, ethReceivedPresale + ethReceivedMain, maxCap, totalTokensSent, currentStep, paused, crowdsaleClosed);
190     }
191 
192     // @notice Specify address of token contract
193     // @param _tokenAddress {address} address of token contract
194     // @return res {bool}
195     function setTokenAddress(Token _tokenAddress) external onlyOwner() returns(bool res) {
196         require(token == address(0));
197         token = _tokenAddress;
198         return true;
199     }
200 
201     // @notice set the step of the campaign from presale to public sale
202     // contract is deployed in presale mode
203     // WARNING: there is no way to go back
204     function advanceStep() public onlyOwner() {
205 
206         currentStep = Step.FundingPublicSale;                                             
207         minInvestETH = 1 ether/4;                                     
208     }
209 
210     // @notice in case refunds are needed, money can be returned to the contract
211     // and contract switched to mode refunding
212     function prepareRefund() public payable onlyOwner() {
213         
214         require(msg.value == ethReceivedPresale.add(ethReceivedMain)); // make sure that proper amount of ether is sent
215         currentStep = Step.Refunding;
216     }
217 
218     // @notice return number of contributors
219     // @return  {uint} number of contributors   
220     function numberOfBackers() public view returns(uint) {
221         return backersIndex.length;
222     }
223 
224     // {fallback function}
225     // @notice It will call internal function which handles allocation of Ether and calculates tokens.
226     // Contributor will be instructed to specify sufficient amount of gas. e.g. 250,000 
227     function () external payable {           
228         contribute(msg.sender);
229     }
230 
231     // @notice It will be called by owner to start the sale    
232     function start(uint _block) external onlyOwner() {   
233 
234         require(_block <= (numOfBlocksInMinute * 60 * 24 * 55)/100);  // allow max 55 days for campaign 323136
235         startBlock = block.number;
236         endBlock = startBlock.add(_block); 
237     }
238 
239     // @notice Due to changing average of block time
240     // this function will allow on adjusting duration of campaign closer to the end 
241     function adjustDuration(uint _block) external onlyOwner() {
242 
243         require(_block < (numOfBlocksInMinute * 60 * 24 * 60)/100); // allow for max of 60 days for campaign
244         require(_block > block.number.sub(startBlock)); // ensure that endBlock is not set in the past
245         endBlock = startBlock.add(_block); 
246     }   
247 
248     // @notice due to Ether to Dollar flacutation this value will be adjusted during the campaign
249     // @param _dollarToEtherRatio {uint} new value of dollar to ether ratio
250     function adjustDollarToEtherRatio(uint _dollarToEtherRatio) external onlyOwner() {
251         require(_dollarToEtherRatio > 0);
252         dollarToEtherRatio = _dollarToEtherRatio;
253     }
254 
255     // @notice It will be called by fallback function whenever ether is sent to it
256     // @param  _backer {address} address of contributor
257     // @return res {bool} true if transaction was successful
258     function contribute(address _backer) internal whenNotPaused() respectTimeFrame() returns(bool res) {
259 
260         require(whiteList.isWhiteListed(_backer));      // ensure that user is whitelisted
261 
262         uint tokensToSend = determinePurchase();
263             
264         Backer storage backer = backers[_backer];
265 
266         if (backer.weiReceived == 0)
267             backersIndex.push(_backer);
268        
269         backer.tokensToSend += tokensToSend; // save contributor's total tokens sent
270         backer.weiReceived = backer.weiReceived.add(msg.value);  // save contributor's total ether contributed
271 
272         if (Step.FundingPublicSale == currentStep) { // Update the total Ether received and tokens sent during public sale
273             ethReceivedMain = ethReceivedMain.add(msg.value);
274             tokensSentMain += tokensToSend;
275         }else {                                                 // Update the total Ether recived and tokens sent during presale
276             ethReceivedPresale = ethReceivedPresale.add(msg.value); 
277             tokensSentPresale += tokensToSend;
278         }
279                                                      
280         totalTokensSent += tokensToSend;     // update the total amount of tokens sent        
281         multisig.transfer(this.balance);   // transfer funds to multisignature wallet    
282 
283         if (!token.transfer(_backer, tokensToSend)) 
284             revert(); // Transfer tokens             
285 
286         ReceivedETH(_backer, msg.value, tokensToSend); // Register event
287         return true;
288     }
289 
290     // @notice determine if purchase is valid and return proper number of tokens
291     // @return tokensToSend {uint} proper number of tokens based on the timline
292     function determinePurchase() internal view  returns (uint) {
293 
294         require(msg.value >= minInvestETH);   // ensure that min contributions amount is met  
295         uint tokenAmount = dollarToEtherRatio.mul(msg.value)/4e10;  // price of token is $0.01 and there are 8 decimals for the token
296         
297         uint tokensToSend;
298           
299         if (Step.FundingPublicSale == currentStep) {  // calculate price of token in public sale
300             tokensToSend = tokenAmount;
301             require(totalTokensSent + tokensToSend + priorTokensSent <= maxCap); // Ensure that max cap hasn't been reached  
302         }else {
303             tokensToSend = tokenAmount + (tokenAmount * 50) / 100; 
304             require(totalTokensSent + tokensToSend <= presaleCap); // Ensure that max cap hasn't been reached for presale            
305         }                                                        
306        
307         return tokensToSend;
308     }
309 
310     
311     // @notice This function will finalize the sale.
312     // It will only execute if predetermined sale time passed or all tokens are sold.
313     // it will fail if minimum cap is not reached
314     function finalize() external onlyOwner() {
315 
316         require(!crowdsaleClosed);        
317         // purchasing precise number of tokens might be impractical, thus subtract 1000 
318         // tokens so finalization is possible near the end 
319         require(block.number >= endBlock || totalTokensSent + priorTokensSent >= maxCap - 1000);                        
320         crowdsaleClosed = true; 
321         
322         if (!token.transfer(team, token.balanceOf(this))) // transfer all remaining tokens to team address
323             revert();        
324         token.unlock();                      
325     }
326 
327     // @notice Fail-safe drain
328     function drain() external onlyOwner() {
329         multisig.transfer(this.balance);               
330     }
331 
332     // @notice Fail-safe token transfer
333     function tokenDrain() external onlyOwner() {
334         if (block.number > endBlock) {
335             if (!token.transfer(multisig, token.balanceOf(this))) 
336                 revert();
337         }
338     }
339     
340     // @notice it will allow contributors to get refund in case campaign failed
341     // @return {bool} true if successful
342     function refund() external whenNotPaused() returns (bool) {
343 
344         require(currentStep == Step.Refunding);                        
345 
346         Backer storage backer = backers[msg.sender];
347 
348         require(backer.weiReceived > 0);  // ensure that user has sent contribution
349         require(!backer.refunded);        // ensure that user hasn't been refunded yet
350 
351         backer.refunded = true;  // save refund status to true
352         refundCount++;
353         totalRefunded = totalRefunded + backer.weiReceived;
354 
355         if (!token.transfer(msg.sender, backer.tokensToSend)) // return allocated tokens
356             revert();                            
357         msg.sender.transfer(backer.weiReceived);  // send back the contribution 
358         RefundETH(msg.sender, backer.weiReceived);
359         return true;
360     }
361 
362    
363 
364 }
365 
366 
367 contract ERC20 {
368     uint public totalSupply;
369 
370     function balanceOf(address who) public view returns(uint);
371 
372     function allowance(address owner, address spender) public view returns(uint);
373 
374     function transfer(address to, uint value) public returns(bool ok);
375 
376     function transferFrom(address from, address to, uint value) public returns(bool ok);
377 
378     function approve(address spender, uint value) public returns(bool ok);
379 
380     event Transfer(address indexed from, address indexed to, uint value);
381     event Approval(address indexed owner, address indexed spender, uint value);
382 }
383 
384 // The token
385 contract Token is ERC20, Ownable {
386    
387     function unlock() public;
388 
389 }