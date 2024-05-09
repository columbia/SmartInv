1 pragma solidity ^ 0.4.17;
2 
3 contract SafeMath {
4     function safeMul(uint a, uint b) pure internal returns(uint) {
5         uint c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function safeSub(uint a, uint b) pure internal returns(uint) {
11         assert(b <= a);
12         return a - b;
13     }
14 
15     function safeAdd(uint a, uint b) pure internal returns(uint) {
16         uint c = a + b;
17         assert(c >= a && c >= b);
18         return c;
19     }
20 }
21 
22 
23 
24 
25 contract Ownable {
26     address public owner;
27 
28     function Ownable() public {
29         owner = msg.sender;
30     }
31 
32     function transferOwnership(address newOwner) public onlyOwner {
33         if (newOwner != address(0)) 
34             owner = newOwner;
35     }
36 
37     function kill() public {
38         if (msg.sender == owner) 
39             selfdestruct(owner);
40     }
41 
42     modifier onlyOwner() {
43         if (msg.sender == owner)
44             _;
45     }
46 }
47 
48 contract Pausable is Ownable {
49     bool public stopped;
50 
51     modifier stopInEmergency {
52         if (stopped) {
53             revert();
54         }
55         _;
56     }
57 
58     modifier onlyInEmergency {
59         if (!stopped) {
60             revert();
61         }
62         _;
63     }
64 
65     // Called by the owner in emergency, triggers stopped state
66     function emergencyStop() external onlyOwner {
67         stopped = true;
68     }
69 
70     // Called by the owner to end of emergency, returns to normal state
71     function release() external onlyOwner onlyInEmergency {
72         stopped = false;
73     }
74 }
75 
76 
77 contract ERC20 {
78     uint public totalSupply;
79 
80     function balanceOf(address who) public view returns(uint);
81 
82     function allowance(address owner, address spender) public view returns(uint);
83 
84     function transfer(address to, uint value) public returns(bool ok);
85 
86     function transferFrom(address from, address to, uint value) public returns(bool ok);
87 
88     function approve(address spender, uint value) public returns(bool ok);
89 
90     event Transfer(address indexed from, address indexed to, uint value);
91     event Approval(address indexed owner, address indexed spender, uint value);
92 }
93 
94 
95 contract Token is ERC20, SafeMath, Ownable {
96 
97     function transfer(address _to, uint _value) public returns(bool);
98 }
99 
100 // Presale Smart Contract
101 // This smart contract collects ETH and in return sends tokens to the backers
102 contract Presale is SafeMath, Pausable {
103 
104     struct Backer {
105         uint weiReceived; // amount of ETH contributed
106         uint tokensToSend; // amount of tokens  sent
107         bool claimed;
108         bool refunded;
109     }
110    
111     address public multisig; // Multisig contract that will receive the ETH    
112     uint public ethReceived; // Number of ETH received
113     uint public tokensSent; // Number of tokens sent to ETH contributors
114     uint public startBlock; // Presale start block
115     uint public endBlock; // Presale end block
116 
117     uint public minInvestment; // Minimum amount to invest
118     uint public maxInvestment; // Maximum investment
119     bool public presaleClosed; // Is presale still on going     
120     uint public tokenPriceWei; // price of token in wei
121     Token public token; // addresss of token contract
122 
123 
124     mapping(address => Backer) public backers; //backer list
125     address[] public backersIndex;  // to be able to iterate through backer list
126     uint public maxCap;  // max cap
127     uint public claimCount;  // number of contributors claming tokens
128     uint public refundCount;  // number of contributors receivig refunds
129     uint public totalClaimed;  // total of tokens claimed
130     uint public totalRefunded;  // total of tokens refunded
131     bool public mainSaleSuccessfull; // true if main sale was successfull
132     mapping(address => uint) public claimed; // Tokens claimed by contibutors
133     mapping(address => uint) public refunded; // Tokens refunded to contributors
134 
135 
136     // @notice to verify if action is not performed out of the campaing range
137     modifier respectTimeFrame() {
138         if ((block.number < startBlock) || (block.number > endBlock)) 
139             revert();
140         _;
141     }
142 
143     // @notice overwrting this function to ensure that money if any     is returned to authorized party. 
144     function kill() public {
145         if (msg.sender == owner) 
146             selfdestruct(multisig);
147     }
148 
149 
150     // Events
151     event ReceivedETH(address backer, uint amount, uint tokenAmount);
152     event TokensClaimed(address backer, uint count);
153     event Refunded(address backer, uint amount);
154 
155 
156 
157     // Presale  {constructor}
158     // @notice fired when contract is crated. Initilizes all needed variables.
159     function Presale() public {        
160         multisig = 0xF821Fd99BCA2111327b6a411C90BE49dcf78CE0f; 
161         minInvestment = 5e17;  // 0.5 eth
162         maxInvestment = 75 ether;      
163         maxCap = 82500000e18;
164         startBlock = 0; // Should wait for the call of the function start
165         endBlock = 0; // Should wait for the call of the function start       
166         tokenPriceWei = 1100000000000000;      
167         tokensSent = 2534559883e16;         
168     }
169 
170     // @notice​ ​return​ ​ number​ of​ ​contributors
171     //​ ​@return​ ​ ​{uint}​ ​ number​ ​ of contributors
172     function numberOfBackers() public view returns(uint) {
173         return backersIndex.length;
174     }
175 
176     // @notice to populate website with status of the sale 
177     function returnWebsiteData() external view returns(uint, uint, uint, uint, uint, uint, uint, uint, uint, bool, bool) {
178     
179         return (startBlock, endBlock, numberOfBackers(), ethReceived, maxCap, tokensSent, tokenPriceWei, minInvestment, maxInvestment, stopped, presaleClosed );
180     }
181 
182     // @notice called to mark contributors when tokens are transfered to them after ICO manually. 
183     // @param _backer {address} address of beneficiary
184     function claimTokensForUser(address _backer) onlyOwner() external returns(bool) {
185 
186         require (!backer.refunded); // if refunded, don't allow tokens to be claimed           
187         require (!backer.claimed); // if tokens claimed, don't allow to be claimed again            
188         require (backer.tokensToSend != 0); // only continue if there are any tokens to send        
189         Backer storage backer = backers[_backer];
190         backer.claimed = true;  // mark record as claimed
191 
192         if (!token.transfer(_backer, backer.tokensToSend)) 
193             revert(); // send claimed tokens to contributor account
194 
195         TokensClaimed(msg.sender, backer.tokensToSend);  
196         return true;
197     }
198 
199 
200     // {fallback function}
201     // @notice It will call internal function which handels allocation of Ether and calculates PPP tokens.
202     function () public payable {
203         contribute(msg.sender);
204     }
205 
206     // @notice in case refunds are needed, money can be returned to the contract
207     function fundContract() external payable onlyOwner() returns (bool) {
208         mainSaleSuccessfull = false;
209         return true;
210     }
211 
212     // @notice It will be called by owner to start the sale    
213     // block numbers will be calculated based on current block time average. 
214     function start(uint _block) external onlyOwner() {
215         require(_block < 54000);  // 2.5*60*24*15 days = 54000  
216         startBlock = block.number;
217         endBlock = safeAdd(startBlock, _block);   
218     }
219 
220     // @notice Due to changing average of block time
221     // this function will allow on adjusting duration of campaign closer to the end 
222     // @param _block  number of blocks representing duration 
223     function adjustDuration(uint _block) external onlyOwner() {
224         
225         require(_block <= 72000);  // 2.5*60*24*20 days = 72000     
226         require(_block > safeSub(block.number, startBlock)); // ensure that endBlock is not set in the past
227         endBlock = safeAdd(startBlock, _block);   
228     }
229 
230     
231 
232 
233     // @notice set the address of the token contract
234     // @param _token  {Token} address of the token contract
235     function setToken(Token _token) public onlyOwner() returns(bool) {
236 
237         token = _token;
238         mainSaleSuccessfull = true;
239         return true;
240     }
241 
242     // @notice sets status of main ICO
243     // @param _status {bool} true if public ICO was successful
244     function setMainCampaignStatus(bool _status) public onlyOwner() {
245         mainSaleSuccessfull = _status;
246     }
247 
248     // @notice It will be called by fallback function whenever ether is sent to it
249     // @param  _contributor {address} address of beneficiary
250     // @return res {bool} true if transaction was successful
251 
252     function contribute(address _contributor) internal stopInEmergency respectTimeFrame returns(bool res) {
253          
254         require (msg.value >= minInvestment && msg.value <= maxInvestment);  // ensure that min and max contributions amount is met
255                    
256         uint tokensToSend = calculateNoOfTokensToSend();
257         
258         require (safeAdd(tokensSent, tokensToSend) <= maxCap);  // Ensure that max cap hasn't been reached
259 
260         Backer storage backer = backers[_contributor];
261 
262         if (backer.weiReceived == 0)
263             backersIndex.push(_contributor);
264 
265         backer.tokensToSend = safeAdd(backer.tokensToSend, tokensToSend);
266         backer.weiReceived = safeAdd(backer.weiReceived, msg.value);
267         ethReceived = safeAdd(ethReceived, msg.value); // Update the total Ether recived
268         tokensSent = safeAdd(tokensSent, tokensToSend);
269 
270         multisig.transfer(msg.value);  // send money to multisignature wallet
271 
272         ReceivedETH(_contributor, msg.value, tokensToSend); // Register event
273         return true;
274     }
275 
276     // @notice It is called by contribute to determine amount of tokens for given contribution    
277     // @return tokensToPurchase {uint} value of tokens to purchase
278 
279     function calculateNoOfTokensToSend() view internal returns(uint) {
280          
281         uint tokenAmount = safeMul(msg.value, 1e18) / tokenPriceWei;
282         uint ethAmount = msg.value;
283 
284         if (ethAmount >= 50 ether)
285             return tokenAmount + (tokenAmount * 5) / 100;  // 5% percent bonus
286         else if (ethAmount >= 15 ether)
287             return tokenAmount + (tokenAmount * 25) / 1000; // 2.5% percent bonus
288         else 
289             return tokenAmount;
290     }
291 
292     // @notice This function will finalize the sale.
293     // It will only execute if predetermined sale time passed 
294 
295     function finalize() external onlyOwner() {
296 
297         require (!presaleClosed);           
298         require (block.number >= endBlock);                          
299         presaleClosed = true;
300     }
301 
302 
303     // @notice contributors can claim tokens after public ICO is finished
304     // tokens are only claimable when token address is available. 
305 
306     function claimTokens() external {
307 
308         require(mainSaleSuccessfull);
309        
310         require (token != address(0));  // address of the token is set after ICO
311                                         // claiming of tokens will be only possible once address of token
312                                         // is set through setToken
313            
314         Backer storage backer = backers[msg.sender];
315 
316         require (!backer.refunded); // if refunded, don't allow for another refund           
317         require (!backer.claimed); // if tokens claimed, don't allow refunding            
318         require (backer.tokensToSend != 0);   // only continue if there are any tokens to send           
319 
320         claimCount++;
321         claimed[msg.sender] = backer.tokensToSend;  // save claimed tokens
322         backer.claimed = true;
323         totalClaimed = safeAdd(totalClaimed, backer.tokensToSend);
324         
325         if (!token.transfer(msg.sender, backer.tokensToSend)) 
326             revert(); // send claimed tokens to contributor account
327 
328         TokensClaimed(msg.sender, backer.tokensToSend);  
329     }
330 
331     // @notice allow refund when ICO failed
332     // In such a case contract will need to be funded. 
333     // Until contract is funded this function will throw
334 
335     function refund() external {
336 
337         require(!mainSaleSuccessfull);  // ensure that ICO failed
338         require(this.balance > 0);  // contract will hold 0 ether at the end of campaign.                                  
339                                     // contract needs to be funded through fundContract() 
340         Backer storage backer = backers[msg.sender];
341 
342         require (!backer.claimed); // check if tokens have been allocated already                   
343         require (!backer.refunded); // check if user has been already refunded     
344         require(backer.weiReceived != 0);  // check if user has actually sent any contributions        
345 
346         backer.refunded = true; // mark contributor as refunded. 
347         totalRefunded = safeAdd(totalRefunded, backer.weiReceived);
348         refundCount ++;
349         refunded[msg.sender] = backer.weiReceived;
350 
351         msg.sender.transfer(backer.weiReceived);  // refund contribution        
352         Refunded(msg.sender, backer.weiReceived); // log event
353     }
354 
355 
356     // @notice Failsafe drain
357     function drain() external onlyOwner() {
358         multisig.transfer(this.balance);
359             
360     }
361 }