1 pragma solidity 0.4.24;
2 /**
3 * @title ROC ICO Contract
4 */
5 
6 /**
7  * @title SafeMath by OpenZeppelin
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11 
12   /**
13   * @dev Multiplies two numbers, throws on overflow.
14   */
15   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16     if (a == 0) {
17       return 0;
18     }
19     uint256 c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23 
24   /**
25   * @dev Integer division of two numbers, truncating the quotient.
26   */
27   function div(uint256 a, uint256 b) internal pure returns (uint256) {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return c;
32   }
33 
34   /**
35   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36   */
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   /**
43   * @dev Adds two numbers, throws on overflow.
44   */
45   function add(uint256 a, uint256 b) internal pure returns (uint256) {
46     uint256 c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 /**
53  * @title ERC20Basic
54  * @dev Simpler version of ERC20 interface
55  * @dev see https://github.com/ethereum/EIPs/issues/179
56  */
57 interface ERC20Basic {
58     function totalSupply() constant external returns (uint256 supply);
59     function balanceOf(address _owner) constant external returns (uint256 balance);
60     function transfer(address _to, uint256 _value) external returns (bool success);
61     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
62     event Transfer(address indexed _from, address indexed _to, uint256 _value);
63 }
64 
65 /**
66  * @title admined
67  * @notice This contract is administered
68  */
69 contract admined {
70     mapping(address => uint8) public level;
71     //Levels are
72     //0 normal user (default)
73     //1 basic admin
74     //2 master admin
75 
76     /**
77     * @dev This contructor takes the msg.sender (deployer wallet) as the first master admin
78     */
79     constructor() internal {
80         level[msg.sender] = 2; //Set initial admin to contract creator
81         emit AdminshipUpdated(msg.sender,2);
82     }
83 
84     /**
85     * @dev This modifier limits function execution to the admin
86     */
87     modifier onlyAdmin(uint8 _level) { //A modifier to define admin-only functions
88         require(level[msg.sender] >= _level );
89         _;
90     }
91 
92     /**
93     * @notice This function set adminship on the contract to _newAdmin
94     * @param _newAdmin The new admin of the contract
95     * @param _level The level assigned
96     */
97     function adminshipLevel(address _newAdmin, uint8 _level) onlyAdmin(2) public { //Admin can be set
98         require(_newAdmin != address(0));
99         level[_newAdmin] = _level;
100         emit AdminshipUpdated(_newAdmin,_level);
101     }
102 
103     /**
104     * @dev Log Events
105     */
106     event AdminshipUpdated(address _newAdmin, uint8 _level);
107 
108 }
109 
110 contract ROCICO is admined {
111 
112     using SafeMath for uint256;
113     //This ico have these possible states
114     enum State {
115         Stage1,
116         Stage2,
117         Stage3,
118         Successful
119     }
120     //Public variables
121 
122     //Time-state Related
123     State public state = State.Stage1; //Set initial stage
124     uint256 public startTime = 1536883200; //Human time (GMT): Friday, 14 September 2018 0:00:00
125     uint256 public Stage1Deadline = 1537833600; //Human time (GMT): Tuesday, 25 September 2018 0:00:00
126     uint256 public Stage2Deadline = 1538697600; //Human time (GMT): Friday, 5 October 2018 0:00:00
127     uint256 public Stage3Deadline = 1539647999; //Human time (GMT): Monday, 15 October 2018 23:59:59
128     uint256 public completedAt; //Set when ico finish
129 
130     //Token-eth related
131     uint256 public totalRaised; //eth collected in wei
132     uint256 public totalDistributed; //Whole sale tokens distributed
133     ERC20Basic public tokenReward; //Token contract address
134 
135     //Contract details
136     address public creator;
137     address public beneficiary;
138     string public version = '1';
139 
140     //Tokens per eth rates
141     uint256[3] rates = [1000000,800000,700000];
142 
143     //events for log
144     event LogFundrisingInitialized(address _creator);
145     event LogFundingReceived(address _addr, uint _amount, uint _currentTotal);
146     event LogBeneficiaryPaid(address _beneficiaryAddress);
147     event LogContributorsPayout(address _addr, uint _amount);
148     event LogFundingSuccessful(uint _totalRaised);
149 
150     //Modifier to prevent execution if ico has ended
151     modifier notFinished() {
152         require(state != State.Successful);
153         _;
154     }
155 
156     /**
157     * @notice ICO constructor
158     */
159     constructor(address _beneficiaryAddress, address _tokenAddress) public {
160 
161         require(_beneficiaryAddress != address(0));
162 
163         beneficiary = _beneficiaryAddress;
164         creator = msg.sender; //Creator is set on deployment
165         tokenReward = ERC20Basic(_tokenAddress); //Token contract address
166 
167         emit LogFundrisingInitialized(beneficiary);
168     }
169 
170     /**
171     * @notice contribution handler
172     */
173     function contribute() public notFinished payable {
174 
175         //Minimum contribution 0.001 eth
176         require(msg.value >= 1 finney);
177 
178         uint256 tokenBought = 0; //tokens bought variable
179 
180         totalRaised = totalRaised.add(msg.value); //ether received counter updated
181 
182         emit LogFundingReceived(msg.sender, msg.value, totalRaised); //log
183 
184         if(state == State.Stage1){
185 
186             tokenBought = msg.value.mul(rates[0]); //Stage1 rate
187 
188             //Bonus 25%
189             tokenBought = tokenBought.mul(125);
190             tokenBought = tokenBought.div(100);
191 
192         } else if(state == State.Stage2){
193 
194             tokenBought = msg.value.mul(rates[1]); //Stage2 rate
195 
196             //Bonus 15%
197             tokenBought = tokenBought.mul(115);
198             tokenBought = tokenBought.div(100);
199 
200         } else {
201 
202             tokenBought = msg.value.mul(rates[2]); //Stage3 rate
203 
204             //Bonus 5%
205             tokenBought = tokenBought.mul(105);
206             tokenBought = tokenBought.div(100);
207 
208         }
209 
210         tokenBought = tokenBought.div(1e10); //Decimals correction
211 
212         if(msg.value >= 5 ether){
213           tokenBought = tokenBought.mul(2); //+100%
214         }
215 
216         totalDistributed = totalDistributed.add(tokenBought); //whole tokens sold counter updated
217 
218         beneficiary.transfer(address(this).balance);
219 
220         emit LogBeneficiaryPaid(creator);
221 
222         require(tokenReward.transfer(msg.sender,tokenBought));
223 
224         emit LogContributorsPayout(msg.sender,tokenBought); //Log the claim
225 
226         checkIfFundingCompleteOrExpired(); //State check
227     }
228 
229     /**
230     * @notice function to check status
231     */
232     function checkIfFundingCompleteOrExpired() public {
233 
234         if( now >= Stage3Deadline && state != State.Successful ){//If deadline is reached
235 
236             state = State.Successful; //ICO becomes Successful
237             completedAt = now; //ICO is complete
238 
239             emit LogFundingSuccessful(totalRaised); //we log the finish
240             successful(); //and execute closure
241 
242         } else if (state == State.Stage1 && now >= Stage1Deadline){
243 
244             state = State.Stage2;
245 
246         } else if (state == State.Stage2 && now >= Stage2Deadline){
247 
248             state = State.Stage3;
249 
250         }
251     }
252 
253     /**
254     * @notice successful closure handler
255     */
256     function successful() public {
257         //When successful
258         require(state == State.Successful);
259 
260         //If there is any token left after ico
261         uint256 remanent = tokenReward.balanceOf(this); //Total tokens remaining
262         require(tokenReward.transfer(beneficiary,remanent));//Tokens are send back to creator
263 
264         //After successful ico all remaining eth is send to beneficiary
265         beneficiary.transfer(address(this).balance);
266         emit LogBeneficiaryPaid(creator);
267     }
268 
269     /**
270     * @notice Function to claim any token stuck on contract
271     */
272     function externalTokensRecovery(ERC20Basic _address) onlyAdmin(2) public{
273 
274         uint256 remainder = _address.balanceOf(this); //Check remainder tokens
275         _address.transfer(msg.sender,remainder); //Transfer tokens to admin
276 
277     }
278 
279     /*
280     * @dev Direct payments handler
281     */
282     function () public payable {
283 
284         contribute();
285 
286     }
287 }