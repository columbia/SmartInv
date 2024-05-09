1 pragma solidity ^ 0.4.17;
2 
3 
4 library SafeMath {
5     function mul(uint a, uint b) pure internal returns(uint) {
6         uint c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
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
23 
24 
25 
26 
27 contract Ownable {
28     address public owner;
29 
30     function Ownable() public {
31         owner = msg.sender;
32     }
33 
34     function transferOwnership(address newOwner) public onlyOwner {
35         if (newOwner != address(0)) 
36             owner = newOwner;
37     }
38 
39     function kill() public {
40         if (msg.sender == owner) 
41             selfdestruct(owner);
42     }
43 
44     modifier onlyOwner() {
45         if (msg.sender == owner)
46             _;
47     }
48 }
49 
50 
51 contract Pausable is Ownable {
52     bool public stopped;
53 
54     modifier stopInEmergency {
55         if (stopped) {
56             revert();
57         }
58         _;
59     }
60 
61     modifier onlyInEmergency {
62         if (!stopped) {
63             revert();
64         }
65         _;
66     }
67 
68     // Called by the owner in emergency, triggers stopped state
69     function emergencyStop() external onlyOwner() {
70         stopped = true;
71     }
72 
73     // Called by the owner to end of emergency, returns to normal state
74     function release() external onlyOwner() onlyInEmergency {
75         stopped = false;
76     }
77 }
78 
79 
80 // Crowdsale Smart Contract
81 // This smart contract collects ETH and in return sends tokens to contributors
82 contract Crowdsale is Pausable {
83 
84     using SafeMath for uint;
85 
86     struct Backer {
87         uint weiReceived; // amount of ETH contributed
88         uint tokensSent; // amount of tokens  sent  
89         bool refunded; // true if user has been refunded       
90     }
91 
92     Token public token; // Token contract reference   
93     address public multisig; // Multisig contract that will receive the ETH    
94     address public team; // Address at which the team tokens will be sent        
95     uint public ethReceivedPresale; // Number of ETH received in presale
96     uint public ethReceivedMain; // Number of ETH received in public sale
97     uint public totalTokensSent; // Number of tokens sent to ETH contributors
98     uint public startBlock; // Crowdsale start block
99     uint public endBlock; // Crowdsale end block
100     uint public maxCap; // Maximum number of tokens to sell
101     uint public minCap; // Minimum number of ETH to raise
102     uint public minInvestETH; // Minimum amount to invest   
103     bool public crowdsaleClosed; // Is crowdsale still in progress
104     Step public currentStep;  // to allow for controled steps of the campaign 
105     uint public refundCount;  // number of refunds
106     uint public totalRefunded; // total amount of refunds    
107     uint public tokenPriceWei;  // price of token in wei
108 
109     mapping(address => Backer) public backers; //backer list
110     address[] public backersIndex; // to be able to itarate through backers for verification.  
111 
112     
113     // @notice to verify if action is not performed out of the campaing range
114     modifier respectTimeFrame() {
115         if ((block.number < startBlock) || (block.number > endBlock)) 
116             revert();
117         _;
118     }
119 
120     // @notice to set and determine steps of crowdsale
121     enum Step {
122         Unknown,
123         FundingPreSale,     // presale mode
124         FundingPublicSale,  // public mode
125         Refunding  // in case campaign failed during this step contributors will be able to receive refunds
126     }
127 
128     // Events
129     event ReceivedETH(address backer, uint amount, uint tokenAmount);
130     event RefundETH(address backer, uint amount);
131 
132 
133     // Crowdsale  {constructor}
134     // @notice fired when contract is crated. Initilizes all constnat and initial values.
135     function Crowdsale() public {
136         multisig = 0xc15464420aC025077Ba280cBDe51947Fc12583D6; 
137         team = 0xc15464420aC025077Ba280cBDe51947Fc12583D6;                                  
138         minInvestETH = 1 ether/100;
139         startBlock = 0; // Should wait for the call of the function start
140         endBlock = 0; // Should wait for the call of the function start                  
141         tokenPriceWei = 1 ether/8000;
142         maxCap = 30600000e18;         
143         minCap = 900000e18;        
144         totalTokensSent = 1253083e18;  
145         setStep(Step.FundingPreSale);
146     }
147 
148     // @notice to populate website with status of the sale 
149     function returnWebsiteData() external view returns(uint, uint, uint, uint, uint, uint, uint, uint, Step, bool, bool) {            
150     
151         return (startBlock, endBlock, backersIndex.length, ethReceivedPresale.add(ethReceivedMain), maxCap, minCap, totalTokensSent, tokenPriceWei, currentStep, stopped, crowdsaleClosed);
152     }
153 
154     // @notice in case refunds are needed, money can be returned to the contract
155     function fundContract() external payable onlyOwner() returns (bool) {
156         return true;
157     }
158 
159     // @notice Specify address of token contract
160     // @param _tokenAddress {address} address of token contract
161     // @return res {bool}
162     function updateTokenAddress(Token _tokenAddress) external onlyOwner() returns(bool res) {
163         token = _tokenAddress;
164         return true;
165     }
166 
167     // @notice set the step of the campaign 
168     // @param _step {Step}
169     function setStep(Step _step) public onlyOwner() {
170         currentStep = _step;
171         
172         if (currentStep == Step.FundingPreSale) {  // for presale 
173             tokenPriceWei = 1 ether/8000;  
174             minInvestETH = 1 ether/100;                             
175         }else if (currentStep == Step.FundingPublicSale) { // for public sale
176             tokenPriceWei = 1 ether/5000;   
177             minInvestETH = 0;               
178         }            
179     }
180 
181     // @notice return number of contributors
182     // @return  {uint} number of contributors   
183     function numberOfBackers() external view returns(uint) {
184         return backersIndex.length;
185     }
186 
187     // {fallback function}
188     // @notice It will call internal function which handels allocation of Ether and calculates tokens.
189     function () external payable {           
190         contribute(msg.sender);
191     }
192 
193     // @notice It will be called by owner to start the sale    
194     function start(uint _block) external onlyOwner() {   
195 
196         require(_block < 246528);  // 4.28*60*24*40 days = 246528     
197         startBlock = block.number;
198         endBlock = startBlock.add(_block); 
199     }
200 
201     // @notice Due to changing average of block time
202     // this function will allow on adjusting duration of campaign closer to the end 
203     function adjustDuration(uint _block) external onlyOwner() {
204 
205         require(_block < 308160);  // 4.28*60*24*50 days = 308160     
206         require(_block > block.number.sub(startBlock)); // ensure that endBlock is not set in the past
207         endBlock = startBlock.add(_block); 
208     }
209 
210     // @notice It will be called by fallback function whenever ether is sent to it
211     // @param  _backer {address} address contributor
212     // @return res {bool} true if transaction was successful
213     function contribute(address _backer) internal stopInEmergency respectTimeFrame returns(bool res) {
214     
215         require(currentStep == Step.FundingPreSale || currentStep == Step.FundingPublicSale); // ensure that this is correct step
216         require(msg.value >= minInvestETH);   // ensure that min contributions amount is met
217           
218         uint tokensToSend = msg.value.mul(1e18) / tokenPriceWei; // calculate amount of tokens to send  (add 18 0s first)     
219         require(totalTokensSent.add(tokensToSend) < maxCap); // Ensure that max cap hasn't been reached  
220             
221         Backer storage backer = backers[_backer];
222     
223         if (backer.weiReceived == 0)      
224             backersIndex.push(_backer);
225            
226         backer.tokensSent = backer.tokensSent.add(tokensToSend); // save contributors tokens to be sent
227         backer.weiReceived = backer.weiReceived.add(msg.value);  // save how much was the contribution
228         totalTokensSent = totalTokensSent.add(tokensToSend);     // update the total amount of tokens sent
229     
230         if (Step.FundingPublicSale == currentStep)  // Update the total Ether recived
231             ethReceivedMain = ethReceivedMain.add(msg.value);
232         else
233             ethReceivedPresale = ethReceivedPresale.add(msg.value);     
234 
235         if (!token.transfer(_backer, tokensToSend)) 
236             revert(); // Transfer tokens   
237     
238         multisig.transfer(this.balance);   // transfer funds to multisignature wallet             
239     
240         ReceivedETH(_backer, msg.value, tokensToSend); // Register event
241         return true;
242     }
243 
244     // @notice This function will finalize the sale.
245     // It will only execute if predetermined sale time passed or all tokens are sold.
246     // it will fail if minimum cap is not reached
247     function finalize() external onlyOwner() {
248 
249         require(!crowdsaleClosed);        
250         // purchasing precise number of tokens might be impractical, thus subtract 1000 tokens so finalizition is possible
251         // near the end 
252         require(block.number >= endBlock || totalTokensSent >= maxCap.sub(1000));                 
253         require(totalTokensSent >= minCap);  // ensure that minimum was reached
254 
255         crowdsaleClosed = true;  
256         
257         if (!token.transfer(team, token.balanceOf(this))) // transfer all remaing tokens to team address
258             revert();
259         token.unlock();                      
260     }
261 
262     // @notice Failsafe drain
263     function drain() external onlyOwner() {
264         multisig.transfer(this.balance);               
265     }
266 
267     // @notice Failsafe token transfer
268     function tokenDrian() external onlyOwner() {
269         if (block.number > endBlock) {
270             if (!token.transfer(team, token.balanceOf(this))) 
271                 revert();
272         }
273     }
274     
275     // @notice it will allow contributors to get refund in case campaign failed
276     function refund() external stopInEmergency returns (bool) {
277 
278         require(currentStep == Step.Refunding);         
279        
280         require(this.balance > 0);  // contract will hold 0 ether at the end of campaign.                                  
281                                     // contract needs to be funded through fundContract() 
282 
283         Backer storage backer = backers[msg.sender];
284 
285         require(backer.weiReceived > 0);  // esnure that user has sent contribution
286         require(!backer.refunded);         // ensure that user hasn't been refunded yet
287 
288         if (!token.returnTokens(msg.sender, backer.tokensSent)) // transfer tokens
289             revert();
290         backer.refunded = true;  // save refund status to true
291     
292         refundCount++;
293         totalRefunded = totalRefunded.add(backer.weiReceived);
294         msg.sender.transfer(backer.weiReceived);  // send back the contribution 
295         RefundETH(msg.sender, backer.weiReceived);
296         return true;
297     }
298 }
299 
300 
301 contract ERC20 {
302     uint public totalSupply;
303    
304     function transfer(address to, uint value) public returns(bool ok);  
305     function balanceOf(address who) public view returns(uint);
306 }
307 
308 
309 // The token
310 contract Token is ERC20, Ownable {
311 
312     function returnTokens(address _member, uint256 _value) public returns(bool);
313     function unlock() public;
314 }