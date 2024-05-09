1 pragma solidity 0.4.24;
2 /**
3 * @title Vivalid ICO Contract
4 * @dev ViV is an ERC-20 Standar Compliant Token
5 * For more info https://vivalid.io
6 */
7 
8 /**
9  * @title SafeMath by OpenZeppelin (partially)
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13 
14     /**
15     * @dev Multiplies two numbers, throws on overflow.
16     */
17     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
18         if (a == 0) {
19           return 0;
20         }
21         c = a * b;
22         assert(c / a == b);
23         return c;
24     }
25 
26     /**
27     * @dev Adds two numbers, throws on overflow.
28     */
29     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
30         c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 /**
37  * @title ERC20Basic
38  * @dev Simpler version of ERC20 interface
39  * @dev see https://github.com/ethereum/EIPs/issues/179
40  */
41 contract ERC20Basic {    
42     function totalSupply() public view returns (uint256);
43     function balanceOf(address who) public view returns (uint256);
44     function transfer(address to, uint256 value) public returns (bool);
45     function transferFrom(address from, address to, uint256 value) public returns (bool);
46     event Transfer(address indexed from, address indexed to, uint256 value);
47 }
48 
49 /**
50  * @title admined
51  * @notice This contract is administered
52  */
53 contract admined {
54     mapping(address => uint8) level; 
55     //0 normal user
56     //1 basic admin
57     //2 master admin
58 
59     /**
60     * @dev This contructor takes the msg.sender as the first master admin
61     */
62     constructor() internal {
63         level[msg.sender] = 2; //Set initial admin to contract creator
64         emit AdminshipUpdated(msg.sender,2);
65     }
66 
67     /**
68     * @dev This modifier limits function execution to the admin
69     */
70     modifier onlyAdmin(uint8 _level) { //A modifier to define admin-only functions
71         require(level[msg.sender] >= _level );
72         _;
73     }
74 
75     /**
76     * @notice This function transfer the adminship of the contract to _newAdmin
77     * @param _newAdmin The new admin of the contract
78     */
79     function adminshipLevel(address _newAdmin, uint8 _level) onlyAdmin(2) public { //Admin can be set
80         require(_newAdmin != address(0));
81         level[_newAdmin] = _level;
82         emit AdminshipUpdated(_newAdmin,_level);
83     }
84 
85     /**
86     * @dev Log Events
87     */
88     event AdminshipUpdated(address _newAdmin, uint8 _level);
89 
90 }
91 
92 contract ViVICO is admined {
93 
94     using SafeMath for uint256;
95     //This ico have 5 possible states
96     enum State {
97         PreSale, //PreSale - best value
98         MainSale,
99         OnHold,
100         Failed,
101         Successful
102     }
103     //Public variables
104 
105     //Time-state Related
106     State public state = State.PreSale; //Set initial stage
107     uint256 public PreSaleStart = now; //Once deployed
108     uint256 constant public PreSaleDeadline = 1529452799; //(GMT): Tuesday, 19 de June de 2018 23:59:59
109     uint256 public MainSaleStart; //TBA
110     uint256 public MainSaleDeadline; // TBA
111     uint256 public completedAt; //Set when ico finish
112     //Token-eth related
113     uint256 public totalRaised; //eth collected in wei
114     uint256 public PreSaleDistributed; //presale tokens distributed
115     uint256 public totalDistributed; //Whole sale tokens distributed
116     ERC20Basic public tokenReward; //Token contract address
117     uint256 public softCap = 11000000 * (10 ** 18); //11M Tokens
118     uint256 public hardCap = 140000000 * (10 ** 18); // 140M tokens
119     //User balances handlers
120     mapping (address => uint256) public ethOnContract; //Balance of sent eth per user
121     mapping (address => uint256) public tokensSent; //Tokens sent per user
122     mapping (address => uint256) public balance; //Tokens pending to send per user
123     //Contract details
124     address public creator;
125     string public version = '1';
126 
127     //Tokens per eth rates
128     uint256[5] rates = [2520,2070,1980,1890,1800];
129 
130     //User rights handlers
131     mapping (address => bool) public whiteList; //List of allowed to send eth
132     mapping (address => bool) public KYCValid; //KYC validation to claim tokens
133 
134     //events for log
135     event LogFundrisingInitialized(address _creator);
136     event LogMainSaleDateSet(uint256 _time);
137     event LogFundingReceived(address _addr, uint _amount, uint _currentTotal);
138     event LogBeneficiaryPaid(address _beneficiaryAddress);
139     event LogContributorsPayout(address _addr, uint _amount);
140     event LogRefund(address _addr, uint _amount);
141     event LogFundingSuccessful(uint _totalRaised);
142     event LogFundingFailed(uint _totalRaised);
143 
144     //Modofoer to prevent execution if ico has ended or is holded
145     modifier notFinishedOrHold() {
146         require(state != State.Successful && state != State.OnHold && state != State.Failed);
147         _;
148     }
149 
150     /**
151     * @notice ICO constructor
152     * @param _addressOfTokenUsedAsReward is the token to distribute
153     */
154     constructor(ERC20Basic _addressOfTokenUsedAsReward ) public {
155 
156         creator = msg.sender; //Creator is set from deployer address
157         tokenReward = _addressOfTokenUsedAsReward; //Token address is set during deployment
158 
159         emit LogFundrisingInitialized(creator);
160     }
161 
162     /**
163     * @notice Whitelist function
164     */
165     function whitelistAddress(address _user, bool _flag) public onlyAdmin(1) {
166         whiteList[_user] = _flag;
167     }
168     
169     /**
170     * @notice KYC validation function
171     */
172     function validateKYC(address _user, bool _flag) public onlyAdmin(1) {
173         KYCValid[_user] = _flag;
174     }
175 
176     /**
177     * @notice Main Sale Start function
178     */
179     function setMainSaleStart(uint256 _startTime) public onlyAdmin(2) {
180         require(state == State.OnHold);
181         require(_startTime > now);
182         MainSaleStart = _startTime;
183         MainSaleDeadline = MainSaleStart.add(12 weeks);
184         state = State.MainSale;
185 
186         emit LogMainSaleDateSet(MainSaleStart);
187     }
188 
189     /**
190     * @notice contribution handler
191     */
192     function contribute() public notFinishedOrHold payable {
193         require(whiteList[msg.sender] == true); //User must be whitelisted
194         require(msg.value >= 0.1 ether); //Minimal contribution
195         
196         uint256 tokenBought = 0; //tokens bought variable
197 
198         totalRaised = totalRaised.add(msg.value); //ether received updated
199         ethOnContract[msg.sender] = ethOnContract[msg.sender].add(msg.value); //ether sent by user updated
200 
201         //Rate of exchange depends on stage
202         if (state == State.PreSale){
203             
204             require(now >= PreSaleStart);
205 
206             tokenBought = msg.value.mul(rates[0]);
207             PreSaleDistributed = PreSaleDistributed.add(tokenBought); //Tokens sold on presale updated
208         
209         } else if (state == State.MainSale){
210 
211             require(now >= MainSaleStart);
212 
213             if (now <= MainSaleStart.add(1 weeks)){
214                 tokenBought = msg.value.mul(rates[1]);
215             } else if (now <= MainSaleStart.add(2 weeks)){
216                 tokenBought = msg.value.mul(rates[2]);
217             } else if (now <= MainSaleStart.add(3 weeks)){
218                 tokenBought = msg.value.mul(rates[3]);
219             } else tokenBought = msg.value.mul(rates[4]);
220                 
221         }
222 
223         require(totalDistributed.add(tokenBought) <= hardCap);
224 
225         if(KYCValid[msg.sender] == true){
226             //if there are any unclaimed tokens
227             uint256 tempBalance = balance[msg.sender];
228             //clear pending balance
229             balance[msg.sender] = 0;
230             //If KYC is valid tokens are send immediately
231             require(tokenReward.transfer(msg.sender, tokenBought.add(tempBalance)));
232             //Tokens sent to user updated
233             tokensSent[msg.sender] = tokensSent[msg.sender].add(tokenBought.add(tempBalance));
234 
235             emit LogContributorsPayout(msg.sender, tokenBought.add(tempBalance));
236 
237         } else{
238             //If KYC is not valid tokens becomes pending
239             balance[msg.sender] = balance[msg.sender].add(tokenBought);
240 
241         }
242 
243         totalDistributed = totalDistributed.add(tokenBought); //whole tokens sold updated
244         emit LogFundingReceived(msg.sender, msg.value, totalRaised);
245         
246         checkIfFundingCompleteOrExpired();
247     }
248 
249     /**
250     * @notice check status
251     */
252     function checkIfFundingCompleteOrExpired() public {
253 
254         //If hardCap is reached ICO ends
255         if (totalDistributed == hardCap && state != State.Successful){
256 
257             state = State.Successful; //ICO becomes Successful
258             completedAt = now; //ICO is complete
259 
260             emit LogFundingSuccessful(totalRaised); //we log the finish
261             successful(); //and execute closure
262 
263         } else if(state == State.PreSale && now > PreSaleDeadline){
264 
265             state = State.OnHold; //Once presale ends the ICO holds
266 
267         } else if(state == State.MainSale && now > MainSaleDeadline){
268             //Once main sale deadline is reached, softCap has to be compared
269             if(totalDistributed >= softCap){
270                 //If softCap is reached
271                 state = State.Successful; //ICO becomes Successful
272                 completedAt = now; //ICO is finished
273 
274                 emit LogFundingSuccessful(totalRaised); //we log the finish
275                 successful(); //and execute closure
276 
277             } else{
278                 //If softCap is not reached
279                 state = State.Failed; //ICO becomes Failed
280                 completedAt = now; //ICO is finished
281 
282                 emit LogFundingFailed(totalRaised); //we log the finish       
283 
284             }
285 
286         }
287     }
288 
289     /**
290     * @notice successful closure handler
291     */
292     function successful() public { 
293         //When successful
294         require(state == State.Successful);
295         //Users have 14 days period to claim tokens
296         if (now > completedAt.add(14 days)){
297             //If there is any token left after
298             uint256 remanent = tokenReward.balanceOf(this);
299             //It's send to creator
300             tokenReward.transfer(creator,remanent);
301             emit LogContributorsPayout(creator, remanent);
302         }
303         //After successful eth is send to creator
304         creator.transfer(address(this).balance);
305 
306         emit LogBeneficiaryPaid(creator);
307 
308     }
309 
310     function claimEth() onlyAdmin(2) public {
311         //Only if softcap is reached
312         require(totalDistributed >= softCap);
313         //eth is send to creator
314         creator.transfer(address(this).balance);
315         emit LogBeneficiaryPaid(creator);
316     }
317 
318     /**
319     * @notice function to let users claim their tokens
320     */
321     function claimTokensByUser() public {
322         //User must have a valid KYC
323         require(KYCValid[msg.sender] == true);
324         //Tokens pending are taken
325         uint256 tokens = balance[msg.sender];
326         //For safety, pending balance is cleared
327         balance[msg.sender] = 0;
328         //Tokens are send to user
329         require(tokenReward.transfer(msg.sender, tokens));
330         //Tokens sent to user updated
331         tokensSent[msg.sender] = tokensSent[msg.sender].add(tokens);
332 
333         emit LogContributorsPayout(msg.sender, tokens);
334     }
335 
336     /**
337     * @notice function to let admin claim tokens on behalf users
338     */
339     function claimTokensByAdmin(address _target) onlyAdmin(1) public {
340         //User must have a valid KYC
341         require(KYCValid[_target] == true);
342         //Tokens pending are taken
343         uint256 tokens = balance[_target];
344         //For safety, pending balance is cleared
345         balance[_target] = 0;
346         //Tokens are send to user
347         require(tokenReward.transfer(_target, tokens));
348         //Tokens sent to user updated
349         tokensSent[_target] = tokensSent[_target].add(tokens);
350 
351         emit LogContributorsPayout(_target, tokens);       
352     }
353 
354     /**
355     * @notice Failure handler
356     */
357     function refund() public { //On failure users can get back their eth
358         //If funding fail
359         require(state == State.Failed);
360         //Users have 90 days to claim a refund
361         if (now < completedAt.add(90 days)){
362             //We take the amount of tokens already sent to user
363             uint256 holderTokens = tokensSent[msg.sender];
364             //For security it's cleared            
365             tokensSent[msg.sender] = 0;
366             //Also pending tokens are cleared
367             balance[msg.sender] = 0;
368             //Amount of ether sent by user is checked
369             uint256 holderETH = ethOnContract[msg.sender];
370             //For security it's cleared            
371             ethOnContract[msg.sender] = 0;
372             //Contract try to retrieve tokens from user balance using allowance
373             require(tokenReward.transferFrom(msg.sender,address(this),holderTokens));
374             //If successful, send ether back
375             msg.sender.transfer(holderETH);
376 
377             emit LogRefund(msg.sender,holderETH);
378         } else{
379             //After 90 days period only a master admin can use the function
380             require(level[msg.sender] >= 2);
381             //To claim remanent tokens on contract
382             uint256 remanent = tokenReward.balanceOf(this);
383             //And ether
384             creator.transfer(address(this).balance);
385             tokenReward.transfer(creator,remanent);
386 
387             emit LogBeneficiaryPaid(creator);
388             emit LogContributorsPayout(creator, remanent);
389         }
390         
391     
392 
393     }
394 
395     /**
396     * @notice Function to claim any token stuck on contract
397     */
398     function externalTokensRecovery(ERC20Basic _address) onlyAdmin(2) public{
399         require(_address != tokenReward); //Only any other token
400 
401         uint256 remainder = _address.balanceOf(this); //Check remainder tokens
402         _address.transfer(msg.sender,remainder); //Transfer tokens to admin
403         
404     }
405 
406     /*
407     * @dev Direct payments handler
408     */
409 
410     function () public payable {
411         
412         contribute();
413 
414     }
415 }