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
95 // Crowdsale Smart Contract
96 // This smart contract collects ETH and in return sends tokens to contributors
97 contract Crowdsale is Pausable {
98 
99     using SafeMath for uint;
100 
101     struct Backer {
102         uint weiReceived; // amount of ETH contributed
103         uint tokensSent; // amount of tokens  sent  
104         bool refunded; // true if user has been refunded       
105     }
106 
107     Token public token; // Token contract reference   
108     address public multisig; // Multisig contract that will receive the ETH    
109     address public team; // Address at which the team tokens will be sent        
110     uint public ethReceivedPresale; // Number of ETH received in presale
111     uint public ethReceivedMain; // Number of ETH received in public sale
112     uint public totalTokensSent; // Number of tokens sent to ETH contributors
113     uint public startBlock; // Crowdsale start block
114     uint public endBlock; // Crowdsale end block
115     uint public maxCap; // Maximum number of tokens to sell
116     uint public minCap; // Minimum number of ETH to raise
117     uint public minInvestETH; // Minimum amount to invest   
118     bool public crowdsaleClosed; // Is crowdsale still in progress
119     Step public currentStep;  // to allow for controled steps of the campaign 
120     uint public refundCount;  // number of refunds
121     uint public totalRefunded; // total amount of refunds    
122     uint public tokenPriceWei;  // price of token in wei
123 
124     mapping(address => Backer) public backers; //backer list
125     address[] public backersIndex; // to be able to itarate through backers for verification.  
126 
127 
128     // @ntice ovewrite to ensure that if any money are left, they go 
129     // to multisig wallet
130     function kill() public {
131         if (msg.sender == owner) 
132             selfdestruct(multisig);
133     }
134 
135     // @notice to verify if action is not performed out of the campaing range
136     modifier respectTimeFrame() {
137         if ((block.number < startBlock) || (block.number > endBlock)) 
138             revert();
139         _;
140     }
141 
142 
143     // @notice to set and determine steps of crowdsale
144     enum Step {
145         Unknown,
146         FundingPreSale,     // presale mode
147         FundingPublicSale,  // public mode
148         Refunding  // in case campaign failed during this step contributors will be able to receive refunds
149     }
150 
151 
152     // Events
153     event ReceivedETH(address backer, uint amount, uint tokenAmount);
154     event RefundETH(address backer, uint amount);
155 
156 
157     // Crowdsale  {constructor}
158     // @notice fired when contract is crated. Initilizes all constnat and initial values.
159     function Crowdsale() public {
160         multisig = 0xc15464420aC025077Ba280cBDe51947Fc12583D6; //TODO: Replace address with correct one
161         team = 0xc15464420aC025077Ba280cBDe51947Fc12583D6; //TODO: Replace address with correct one                                  
162         minInvestETH = 3 ether;
163         startBlock = 0; // Should wait for the call of the function start
164         endBlock = 0; // Should wait for the call of the function start                  
165         tokenPriceWei = 1 ether/2000;
166         maxCap = 30600000e18;         
167         minCap = 1000 ether;        
168         setStep(Step.FundingPreSale);
169     }
170 
171     // @notice to populate website with status of the sale 
172     function returnWebsiteData() external view returns(uint, uint, uint, uint, uint, uint, uint, uint, Step, bool, bool) {            
173     
174         return (startBlock, endBlock, backersIndex.length, ethReceivedPresale.add(ethReceivedMain), maxCap, minCap, totalTokensSent,  tokenPriceWei, currentStep, stopped, crowdsaleClosed);
175     }
176 
177     // @notice in case refunds are needed, money can be returned to the contract
178     function fundContract() external payable onlyOwner() returns (bool) {
179         return true;
180     }
181 
182 
183     // @notice Specify address of token contract
184     // @param _tokenAddress {address} address of token contract
185     // @return res {bool}
186     function updateTokenAddress(Token _tokenAddress) external onlyOwner() returns(bool res) {
187         token = _tokenAddress;
188         return true;
189     }
190 
191 
192     // @notice set the step of the campaign 
193     // @param _step {Step}
194     function setStep(Step _step) public onlyOwner() {
195         currentStep = _step;
196         
197         if (currentStep == Step.FundingPreSale) {  // for presale 
198             tokenPriceWei = 500000000000000;     
199             minInvestETH = 3 ether;                             
200         }else if (currentStep == Step.FundingPublicSale) { // for public sale
201             tokenPriceWei = 833333000000000;   
202             minInvestETH = 0;               
203         }            
204     }
205 
206 
207     // @notice return number of contributors
208     // @return  {uint} number of contributors   
209     function numberOfBackers() public view returns(uint) {
210         return backersIndex.length;
211     }
212 
213 
214     // {fallback function}
215     // @notice It will call internal function which handels allocation of Ether and calculates tokens.
216     function () external payable {           
217         contribute(msg.sender);
218     }
219 
220 
221     // @notice It will be called by owner to start the sale    
222     function start(uint _block) external onlyOwner() {   
223 
224         require(_block < 216000);  // 2.5*60*24*60 days = 216000     
225         startBlock = block.number;
226         endBlock = startBlock.add(_block); 
227     }
228 
229     // @notice Due to changing average of block time
230     // this function will allow on adjusting duration of campaign closer to the end 
231     function adjustDuration(uint _block) external onlyOwner() {
232 
233         require(_block < 288000);  // 2.5*60*24*80 days = 288000     
234         require(_block > block.number.sub(startBlock)); // ensure that endBlock is not set in the past
235         endBlock = startBlock.add(_block); 
236     }
237 
238     // @notice It will be called by fallback function whenever ether is sent to it
239     // @param  _backer {address} address contributor
240     // @return res {bool} true if transaction was successful
241     function contribute(address _backer) internal stopInEmergency respectTimeFrame returns(bool res) {
242     
243         require(currentStep == Step.FundingPreSale || currentStep == Step.FundingPublicSale); // ensure that this is correct step  
244         require (msg.value >= minInvestETH);   // ensure that min contributions amount is met
245           
246         uint tokensToSend = msg.value.mul(1e18) / tokenPriceWei; // calculate amount of tokens to send  (add 18 0s first)     
247         require(totalTokensSent.add(tokensToSend) < maxCap); // Ensure that max cap hasn't been reached  
248             
249         Backer storage backer = backers[_backer];
250     
251          if (backer.weiReceived == 0)      
252             backersIndex.push(_backer);
253     
254         if (!token.transfer(_backer, tokensToSend)) 
255             revert(); // Transfer tokens
256         backer.tokensSent = backer.tokensSent.add(tokensToSend); // save contributors tokens to be sent
257         backer.weiReceived = backer.weiReceived.add(msg.value);  // save how much was the contribution
258         totalTokensSent = totalTokensSent.add(tokensToSend);     // update the total amount of tokens sent
259     
260         if (Step.FundingPublicSale == currentStep)  // Update the total Ether recived
261                 ethReceivedMain = ethReceivedMain.add(msg.value);
262         else
263                 ethReceivedPresale = ethReceivedPresale.add(msg.value);        
264     
265         multisig.transfer(this.balance);   // transfer funds to multisignature wallet             
266     
267         ReceivedETH(_backer, msg.value, tokensToSend); // Register event
268         return true;
269     }
270 
271   
272 
273     // @notice This function will finalize the sale.
274     // It will only execute if predetermined sale time passed or all tokens are sold.
275     // it will fail if minimum cap is not reached
276     function finalize() external onlyOwner() {
277 
278         require(!crowdsaleClosed);        
279         // purchasing precise number of tokens might be impractical, thus subtract 100 tokens so finalizition is possible
280         // near the end 
281         require (block.number >= endBlock || totalTokensSent >= maxCap.sub(100)); 
282         
283         uint totalEtherReceived = ethReceivedPresale.add(ethReceivedMain);
284         require(totalEtherReceived >= minCap);  // ensure that minimum was reached
285         
286         if (!token.transfer(team, token.balanceOf(this))) // transfer all remaing tokens to team address
287                 revert();
288             token.unlock();
289         
290         crowdsaleClosed = true;        
291     }
292 
293 
294     // @notice Failsafe drain
295     function drain() external onlyOwner() {
296         multisig.transfer(this.balance);               
297     }
298 
299 
300 
301     // @notice Failsafe token transfer
302     function tokenDrian() external onlyOwner() {
303     if (block.number > endBlock) {
304         if (!token.transfer(team, token.balanceOf(this))) 
305                 revert();
306         }
307     }
308     
309 
310     // @notice it will allow contributors to get refund in case campaign failed
311     function refund() external stopInEmergency returns (bool) {
312 
313         require(currentStep == Step.Refunding); 
314         
315         uint totalEtherReceived = ethReceivedPresale.add(ethReceivedMain);
316 
317         require(totalEtherReceived < minCap);  // ensure that campaing failed
318         require(this.balance > 0);  // contract will hold 0 ether at the end of campaign.                                  
319                                     // contract needs to be funded through fundContract() 
320 
321         Backer storage backer = backers[msg.sender];
322 
323         require (backer.weiReceived > 0);  // esnure that user has sent contribution
324         require(!backer.refunded);         // ensure that user hasn't been refunded yet
325 
326         if (!token.burn(msg.sender, backer.tokensSent)) // burn tokens
327             revert();
328         backer.refunded = true;  // save refund status to true
329     
330         refundCount ++;
331         totalRefunded = totalRefunded.add(backer.weiReceived);
332         msg.sender.transfer(backer.weiReceived);  // send back the contribution 
333         RefundETH(msg.sender, backer.weiReceived);
334         return true;
335     }
336 }
337 
338 // The token
339 contract Token is ERC20,  Ownable {
340 
341     using SafeMath for uint;
342     // Public variables of the token
343     string public name;
344     string public symbol;
345     uint8 public decimals; // How many decimals to show.
346     string public version = "v0.1";       
347     uint public totalSupply;
348     bool public locked;
349     address public crowdSaleAddress;
350     
351 
352 
353     mapping(address => uint) balances;
354     mapping(address => mapping(address => uint)) allowed;
355 
356     // tokens are locked during the ICO. Allow transfer of tokens after ICO. 
357     modifier onlyUnlocked() {
358         if (msg.sender != crowdSaleAddress && locked) 
359             revert();
360         _;
361     }
362 
363 
364     // allow burning of tokens only by authorized users 
365     modifier onlyAuthorized() {
366         if (msg.sender != owner && msg.sender != crowdSaleAddress ) 
367             revert();
368         _;
369     }
370 
371 
372     // The Token 
373     function Token(address _crowdSaleAddress) public {
374         
375         locked = true;  // Lock the Crowdsale function during the crowdsale
376         totalSupply = 60000000e18; 
377         name = "Requitix"; // Set the name for display purposes
378         symbol = "RQX"; // Set the symbol for display purposes
379         decimals = 18; // Amount of decimals for display purposes
380         crowdSaleAddress = _crowdSaleAddress;                                  
381         balances[crowdSaleAddress] = totalSupply;
382     }
383 
384     function unlock() public onlyAuthorized {
385         locked = false;
386     }
387 
388     function lock() public onlyAuthorized {
389         locked = true;
390     }
391     
392 
393     function burn( address _member, uint256 _value) public onlyAuthorized returns(bool) {
394         balances[_member] = balances[_member].sub(_value);
395         totalSupply = totalSupply.sub(_value);
396         Transfer(_member, 0x0, _value);
397         return true;
398     }
399 
400     function transfer(address _to, uint _value) public onlyUnlocked returns(bool) {
401         balances[msg.sender] = balances[msg.sender].sub(_value);
402         balances[_to] = balances[_to].add(_value);
403         Transfer(msg.sender, _to, _value);
404         return true;
405     }
406 
407     
408     function transferFrom(address _from, address _to, uint256 _value) public onlyUnlocked returns(bool success) {
409         require (balances[_from] >= _value); // Check if the sender has enough                            
410         require (_value <= allowed[_from][msg.sender]); // Check if allowed is greater or equal        
411         balances[_from] = balances[_from].sub(_value); // Subtract from the sender
412         balances[_to] = balances[_to].add(_value); // Add the same to the recipient
413         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
414         Transfer(_from, _to, _value);
415         return true;
416     }
417 
418     function balanceOf(address _owner) public view returns(uint balance) {
419         return balances[_owner];
420     }
421 
422 
423     /**
424     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
425     *
426     * Beware that changing an allowance with this method brings the risk that someone may use both the old
427     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
428     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
429     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
430     * @param _spender The address which will spend the funds.
431     * @param _value The amount of tokens to be spent.
432     */
433     function approve(address _spender, uint _value) public returns(bool) {
434         allowed[msg.sender][_spender] = _value;
435         Approval(msg.sender, _spender, _value);
436         return true;
437     }
438 
439 
440     function allowance(address _owner, address _spender) public view returns(uint remaining) {
441         return allowed[_owner][_spender];
442     }
443 
444     /**
445     * approve should be called when allowed[_spender] == 0. To increment
446     * allowed value is better to use this function to avoid 2 calls (and wait until
447     * the first transaction is mined)
448     * From MonolithDAO Token.sol
449     */
450     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
451         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
452         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
453         return true;
454     }
455 
456     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
457         uint oldValue = allowed[msg.sender][_spender];
458         if (_subtractedValue > oldValue) {
459         allowed[msg.sender][_spender] = 0;
460         } else {
461         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
462         }
463         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
464         return true;
465     }
466 
467 }