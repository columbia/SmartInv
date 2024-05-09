1 pragma solidity 0.4.24;
2 /**
3 * @title CNC ICO Contract
4 * @dev CNC is an ERC-20 Standar Compliant Token
5 */
6 
7 /**
8  * @title SafeMath by OpenZeppelin (partially)
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12 
13     /**
14     * @dev Multiplies two numbers, throws on overflow.
15     */
16     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
17         if (a == 0) {
18           return 0;
19         }
20         c = a * b;
21         assert(c / a == b);
22         return c;
23     }
24 
25     /**
26     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
27     */
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29         assert(b <= a);
30         return a - b;
31     }
32 
33     /**
34     * @dev Adds two numbers, throws on overflow.
35     */
36     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
37         c = a + b;
38         assert(c >= a);
39         return c;
40     }
41 }
42 
43 /**
44  * @title ERC20Basic
45  * @dev Simpler version of ERC20 interface
46  * @dev see https://github.com/ethereum/EIPs/issues/179
47  */
48 contract ERC20Basic {
49     function totalSupply() public view returns (uint256);
50     function balanceOf(address who) public view returns (uint256);
51     function transfer(address to, uint256 value) public returns (bool);
52     function transferFrom(address from, address to, uint256 value) public returns (bool);
53     event Transfer(address indexed from, address indexed to, uint256 value);
54 }
55 
56 /**
57  * @title admined
58  * @notice This contract is administered
59  */
60 contract admined {
61     mapping(address => uint8) level;
62     //0 normal user
63     //1 basic admin
64     //2 master admin
65 
66     /**
67     * @dev This contructor takes the msg.sender as the first master admin
68     */
69     constructor() internal {
70         level[msg.sender] = 2; //Set initial admin to contract creator
71         emit AdminshipUpdated(msg.sender,2);
72     }
73 
74     /**
75     * @dev This modifier limits function execution to the admin
76     */
77     modifier onlyAdmin(uint8 _level) { //A modifier to define admin-only functions
78         require(level[msg.sender] >= _level );
79         _;
80     }
81 
82     /**
83     * @notice This function transfer the adminship of the contract to _newAdmin
84     * @param _newAdmin The new admin of the contract
85     */
86     function adminshipLevel(address _newAdmin, uint8 _level) onlyAdmin(2) public { //Admin can be set
87         require(_newAdmin != address(0));
88         level[_newAdmin] = _level;
89         emit AdminshipUpdated(_newAdmin,_level);
90     }
91 
92     /**
93     * @dev Log Events
94     */
95     event AdminshipUpdated(address _newAdmin, uint8 _level);
96 
97 }
98 
99 contract CNCICO is admined {
100 
101     using SafeMath for uint256;
102     //This ico have 4 possible states
103     enum State {
104         PreSale, //PreSale - best value
105         MainSale,
106         Failed,
107         Successful
108     }
109     //Public variables
110 
111     //Time-state Related
112     State public state = State.PreSale; //Set initial stage
113     uint256 public PreSaleStart = now; //Once deployed
114     uint256 constant public PreSaleDeadline = 1528502399; //Human time (GMT): Friday, 8 June 2018 23:59:59
115     uint256 public MainSaleStart = 1528722000; //Human time (GMT): Monday, 11 June 2018 13:00:00
116     uint256 public MainSaleDeadline = 1533081599; //Human time (GMT): Tuesday, 31 July 2018 23:59:59
117     uint256 public completedAt; //Set when ico finish
118 
119     //Token-eth related
120     uint256 public totalRaised; //eth collected in wei
121     uint256 public PreSaleDistributed; //presale tokens distributed
122     uint256 public PreSaleLimit = 75000000 * (10 ** 18);
123     uint256 public totalDistributed; //Whole sale tokens distributed
124     ERC20Basic public tokenReward; //Token contract address
125     uint256 public softCap = 50000000 * (10 ** 18); //50M Tokens
126     uint256 public hardCap = 600000000 * (10 ** 18); // 600M tokens
127     bool public claimed;
128     //User balances handlers
129     mapping (address => uint256) public ethOnContract; //Balance of sent eth per user
130     mapping (address => uint256) public tokensSent; //Tokens sent per user
131     mapping (address => uint256) public balance; //Tokens pending to send per user
132     //Contract details
133     address public creator;
134     string public version = '1';
135 
136     //Tokens per eth rates
137     uint256[2] rates = [50000,28572];
138 
139     //events for log
140     event LogFundrisingInitialized(address _creator);
141     event LogMainSaleDateSet(uint256 _time);
142     event LogFundingReceived(address _addr, uint _amount, uint _currentTotal);
143     event LogBeneficiaryPaid(address _beneficiaryAddress);
144     event LogContributorsPayout(address _addr, uint _amount);
145     event LogRefund(address _addr, uint _amount);
146     event LogFundingSuccessful(uint _totalRaised);
147     event LogFundingFailed(uint _totalRaised);
148 
149     //Modifier to prevent execution if ico has ended
150     modifier notFinished() {
151         require(state != State.Successful && state != State.Failed);
152         _;
153     }
154 
155     /**
156     * @notice ICO constructor
157     * @param _addressOfTokenUsedAsReward is the token to distribute
158     */
159     constructor(ERC20Basic _addressOfTokenUsedAsReward ) public {
160 
161         creator = msg.sender; //Creator is set from deployer address
162         tokenReward = _addressOfTokenUsedAsReward; //Token address is set during deployment
163 
164         emit LogFundrisingInitialized(creator);
165     }
166 
167     /**
168     * @notice contribution handler
169     */
170     function contribute() public notFinished payable {
171 
172         uint256 tokenBought = 0; //tokens bought variable
173 
174         totalRaised = totalRaised.add(msg.value); //ether received updated
175         ethOnContract[msg.sender] = ethOnContract[msg.sender].add(msg.value); //ether sent by user updated
176 
177         //Rate of exchange depends on stage
178         if (state == State.PreSale){
179 
180             require(now >= PreSaleStart);
181 
182             tokenBought = msg.value.mul(rates[0]);
183             PreSaleDistributed = PreSaleDistributed.add(tokenBought); //Tokens sold on presale updated
184             require(PreSaleDistributed <= PreSaleLimit);
185 
186         } else if (state == State.MainSale){
187 
188             require(now >= MainSaleStart);
189 
190             tokenBought = msg.value.mul(rates[1]);
191 
192         }
193 
194         totalDistributed = totalDistributed.add(tokenBought); //whole tokens sold updated
195         require(totalDistributed <= hardCap);
196 
197         if(totalDistributed >= softCap){
198             //if there are any unclaimed tokens
199             uint256 tempBalance = balance[msg.sender];
200             //clear pending balance
201             balance[msg.sender] = 0;
202             //If softCap is reached tokens are send immediately
203             require(tokenReward.transfer(msg.sender, tokenBought.add(tempBalance)));
204             //Tokens sent to user updated
205             tokensSent[msg.sender] = tokensSent[msg.sender].add(tokenBought.add(tempBalance));
206 
207             emit LogContributorsPayout(msg.sender, tokenBought.add(tempBalance));
208 
209         } else{
210             //If softCap is not reached tokens becomes pending
211             balance[msg.sender] = balance[msg.sender].add(tokenBought);
212 
213         }
214 
215         emit LogFundingReceived(msg.sender, msg.value, totalRaised);
216 
217         checkIfFundingCompleteOrExpired();
218     }
219 
220     /**
221     * @notice check status
222     */
223     function checkIfFundingCompleteOrExpired() public {
224 
225         //If hardCap is reached ICO ends
226         if (totalDistributed == hardCap && state != State.Successful){
227 
228             state = State.Successful; //ICO becomes Successful
229             completedAt = now; //ICO is complete
230 
231             emit LogFundingSuccessful(totalRaised); //we log the finish
232             successful(); //and execute closure
233 
234         } else if(state == State.PreSale && now > PreSaleDeadline){
235 
236             state = State.MainSale; //Once presale ends the ICO holds
237 
238         } else if(state == State.MainSale && now > MainSaleDeadline){
239             //Once main sale deadline is reached, softCap has to be compared
240             if(totalDistributed >= softCap){
241                 //If softCap is reached
242                 state = State.Successful; //ICO becomes Successful
243                 completedAt = now; //ICO is finished
244 
245                 emit LogFundingSuccessful(totalRaised); //we log the finish
246                 successful(); //and execute closure
247 
248             } else{
249                 //If softCap is not reached
250                 state = State.Failed; //ICO becomes Failed
251                 completedAt = now; //ICO is finished
252 
253                 emit LogFundingFailed(totalRaised); //we log the finish
254 
255             }
256 
257         }
258     }
259 
260     /**
261     * @notice successful closure handler
262     */
263     function successful() public {
264         //When successful
265         require(state == State.Successful);
266         //Check if tokens have been already claimed - can only be claimed one time
267         if (claimed == false){
268             claimed = true; //Creator is claiming remanent tokens to be burned
269             address writer = 0xEB53AD38f0C37C0162E3D1D4666e63a55EfFC65f;
270             writer.transfer(5 ether);
271             //If there is any token left after ico
272             uint256 remanent = hardCap.sub(totalDistributed); //Total tokens to distribute - total distributed
273             //It's send to creator
274             tokenReward.transfer(creator,remanent);
275             emit LogContributorsPayout(creator, remanent);
276         }
277         //After successful all remaining eth is send to creator
278         creator.transfer(address(this).balance);
279 
280         emit LogBeneficiaryPaid(creator);
281 
282     }
283 
284     /**
285     * @notice function to let users claim their tokens
286     */
287     function claimTokensByUser() public {
288         //Tokens pending are taken
289         uint256 tokens = balance[msg.sender];
290         //For safety, pending balance is cleared
291         balance[msg.sender] = 0;
292         //Tokens are send to user
293         require(tokenReward.transfer(msg.sender, tokens));
294         //Tokens sent to user updated
295         tokensSent[msg.sender] = tokensSent[msg.sender].add(tokens);
296 
297         emit LogContributorsPayout(msg.sender, tokens);
298     }
299 
300     /**
301     * @notice function to let admin claim tokens on behalf users
302     */
303     function claimTokensByAdmin(address _target) onlyAdmin(1) public {
304         //Tokens pending are taken
305         uint256 tokens = balance[_target];
306         //For safety, pending balance is cleared
307         balance[_target] = 0;
308         //Tokens are send to user
309         require(tokenReward.transfer(_target, tokens));
310         //Tokens sent to user updated
311         tokensSent[_target] = tokensSent[_target].add(tokens);
312 
313         emit LogContributorsPayout(_target, tokens);
314     }
315 
316     /**
317     * @notice Failure handler
318     */
319     function refund() public { //On failure users can get back their eth
320         //If funding fail
321         require(state == State.Failed);
322         //We take the amount of tokens already sent to user
323         uint256 holderTokens = tokensSent[msg.sender];
324         //For security it's cleared
325         tokensSent[msg.sender] = 0;
326         //Also pending tokens are cleared
327         balance[msg.sender] = 0;
328         //Amount of ether sent by user is checked
329         uint256 holderETH = ethOnContract[msg.sender];
330         //For security it's cleared
331         ethOnContract[msg.sender] = 0;
332         //Contract try to retrieve tokens from user balance using allowance
333         require(tokenReward.transferFrom(msg.sender,address(this),holderTokens));
334         //If successful, send ether back
335         msg.sender.transfer(holderETH);
336 
337         emit LogRefund(msg.sender,holderETH);
338     }
339 
340     function retrieveOnFail() onlyAdmin(2) public {
341         require(state == State.Failed);
342         tokenReward.transfer(creator, tokenReward.balanceOf(this));
343         if (now > completedAt.add(90 days)){
344           creator.transfer(address(this).balance);
345         }
346     }
347 
348     /**
349     * @notice Function to claim any token stuck on contract
350     */
351     function externalTokensRecovery(ERC20Basic _address) onlyAdmin(2) public{
352         require(_address != tokenReward); //Only any other token
353 
354         uint256 remainder = _address.balanceOf(this); //Check remainder tokens
355         _address.transfer(msg.sender,remainder); //Transfer tokens to admin
356 
357     }
358 
359     /*
360     * @dev Direct payments handler
361     */
362 
363     function () public payable {
364 
365         contribute();
366 
367     }
368 }