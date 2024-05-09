1 pragma solidity 0.4.25;
2 /**
3 * @title PRIWGR ICO Contract
4 * @dev PRIWGR is an ERC-20 Standar Compliant Token
5 */
6 
7 /**
8  * @title SafeMath by OpenZeppelin
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12 
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a * b;
15         assert(a == 0 || c / a == b);
16         return c;
17     }
18 
19     function div(uint256 a, uint256 b) internal pure returns (uint256) {
20         uint256 c = a / b;
21         return c;
22     }
23 
24     function add(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a + b;
26         assert(c >= a);
27         return c;
28     }
29 
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         assert(b <= a);
32         return a - b;
33     }
34 
35 }
36 
37 
38 /**
39  * @title ERC20Basic
40  * @dev Simpler version of ERC20 interface
41  * @dev see https://github.com/ethereum/EIPs/issues/179
42  */
43 contract ERC20Basic {
44     function totalSupply() public view returns (uint256);
45     function balanceOf(address who) public view returns (uint256);
46     function transfer(address to, uint256 value) public;
47     function transferFrom(address from, address to, uint256 value) public returns (bool);
48     event Transfer(address indexed from, address indexed to, uint256 value);
49 }
50 
51 /**
52  * @title admined
53  * @notice This contract is administered
54  */
55 contract admined {
56     //mapping to user levels
57     mapping(address => uint8) public level;
58     //0 normal user
59     //1 basic admin
60     //2 master admin
61 
62     /**
63     * @dev This contructor takes the msg.sender as the first master admin
64     */
65     constructor() internal {
66         level[msg.sender] = 2; //Set initial admin to contract creator
67         emit AdminshipUpdated(msg.sender,2); //Log the admin set
68     }
69 
70     /**
71     * @dev This modifier limits function execution to the admin
72     */
73     modifier onlyAdmin(uint8 _level) { //A modifier to define admin-only functions
74         require(level[msg.sender] >= _level ); //It require the user level to be more or equal than _level
75         _;
76     }
77 
78     /**
79     * @notice This function transfer the adminship of the contract to _newAdmin
80     * @param _newAdmin The new admin of the contract
81     */
82     function adminshipLevel(address _newAdmin, uint8 _level) onlyAdmin(2) public { //Admin can be set
83         require(_newAdmin != address(0)); //The new admin must not be zero address
84         level[_newAdmin] = _level; //New level is set
85         emit AdminshipUpdated(_newAdmin,_level); //Log the admin set
86     }
87 
88     /**
89     * @dev Log Events
90     */
91     event AdminshipUpdated(address _newAdmin, uint8 _level);
92 
93 }
94 
95 contract PRIWGRICO is admined {
96 
97     using SafeMath for uint256;
98     //This ico have these possible states
99     enum State {
100         MAINSALE,
101         Successful
102     }
103     //Public variables
104 
105     //Time-state Related
106     State public state = State.MAINSALE; //Set initial stage
107     uint256 public MAINSALEStart = now;
108     uint256 public SaleDeadline = MAINSALEStart.add(120 days); //Human time (GMT):
109     uint256 public completedAt; //Set when ico finish
110     //Token-eth related
111     uint256 public totalRaised; //eth collected in wei
112     uint256 public totalDistributed; //Whole sale tokens distributed
113     ERC20Basic public tokenReward; //Token contract address
114 
115     //Contract details
116     address public creator; //Creator address
117     address public WGRholder; //Holder address
118     string public version = '0.1'; //Contract version
119 
120     //Price related
121     uint256 public USDPriceInWei; // 0.01 cent (0.0001$) in wei
122 
123     //events for log
124     event LogFundrisingInitialized(address indexed _creator);
125     event LogFundingReceived(address indexed _addr, uint _amount, uint _currentTotal);
126     event LogBeneficiaryPaid(address indexed _beneficiaryAddress);
127     event LogContributorsPayout(address indexed _addr, uint _amount);
128     event LogFundingSuccessful(uint _totalRaised);
129 
130     //Modifier to prevent execution if ico has ended or is holded
131     modifier notFinished() {
132         require(state != State.Successful);
133         _;
134     }
135 
136     /**
137     * @notice ICO constructor
138     * @param _addressOfTokenUsedAsReward is the token to distribute
139     */
140     constructor(ERC20Basic _addressOfTokenUsedAsReward, uint _initialUSDInWei) public {
141 
142         creator = msg.sender; //Creator is set from deployer address
143         WGRholder = creator; //WGRholder is set to creator address
144         tokenReward = _addressOfTokenUsedAsReward; //Token address is set during deployment
145         USDPriceInWei = _initialUSDInWei;
146 
147         emit LogFundrisingInitialized(creator); //Log contract initialization
148 
149     }
150 
151     /**
152     * @notice contribution handler
153     */
154     function contribute(address _target, uint256 _value) public notFinished payable {
155         require(now > MAINSALEStart); //Current time must be equal or greater than the start time
156 
157         address user;
158         uint remaining;
159         uint256 tokenBought;
160         uint256 temp;
161 
162         if(_target != address(0) && level[msg.sender] >= 1){
163           user = _target;
164           remaining = _value.mul(1e18);
165         } else {
166           user = msg.sender;
167           remaining = msg.value.mul(1e18);
168         }
169 
170         totalRaised = totalRaised.add(remaining.div(1e18)); //ether received updated
171 
172         while(remaining > 0){
173 
174           (temp,remaining) = tokenBuyCalc(remaining);
175           tokenBought = tokenBought.add(temp);
176 
177         }
178 
179         temp = 0;
180 
181         totalDistributed = totalDistributed.add(tokenBought); //Whole tokens sold updated
182         
183         WGRholder.transfer(address(this).balance); //After successful eth is send to WGRholder
184         emit LogBeneficiaryPaid(WGRholder); //Log transaction
185 
186         tokenReward.transfer(user,tokenBought);
187 
188         emit LogFundingReceived(user, msg.value, totalRaised); //Log the purchase
189 
190         checkIfFundingCompleteOrExpired(); //Execute state checks
191     }
192 
193 
194     /*
195     * This function handle the token purchases values
196     */
197     function tokenBuyCalc(uint _value) internal view returns (uint sold,uint remaining) {
198 
199       uint256 tempPrice = USDPriceInWei; //0.001$ in wei
200 
201       //state == State.MAINSALE
202 
203       tempPrice = tempPrice.mul(1000); //0.1$
204       sold = _value.div(tempPrice);
205 
206       return (sold,0);
207 
208     }
209 
210     /**
211     * @notice Process to check contract current status
212     */
213     function checkIfFundingCompleteOrExpired() public {
214 
215         if ( now > SaleDeadline && state != State.Successful){ //If Deadline is reached and not yet successful
216 
217             state = State.Successful; //ICO becomes Successful
218             completedAt = now; //ICO is complete
219 
220             emit LogFundingSuccessful(totalRaised); //we log the finish
221             successful(); //and execute closure
222 
223         }
224 
225     }
226 
227     /**
228     * @notice successful closure handler
229     */
230     function successful() public {
231         require(state == State.Successful); //When successful
232         uint256 temp = tokenReward.balanceOf(address(this)); //Remanent tokens handle
233         tokenReward.transfer(creator,temp); //Try to transfer
234 
235         emit LogContributorsPayout(creator,temp); //Log transaction
236 
237         WGRholder.transfer(address(this).balance); //After successful eth is send to WGRholder
238 
239         emit LogBeneficiaryPaid(WGRholder); //Log transaction
240 
241     }
242 
243     /*
244     * Funtion to update current price of ether
245     * it expects the value in wei of 0.01 cent (0.0001$)
246     */
247     function setPrice(uint _value) public onlyAdmin(2) {
248 
249       USDPriceInWei = _value;
250 
251     }
252     function setHolder(address _holder) public onlyAdmin(2) {
253 
254       WGRholder = _holder;
255 
256     }
257 
258     /**
259     * @notice Function to claim any token stuck on contract
260     * @param _address Address of target token
261     */
262     function externalTokensRecovery(ERC20Basic _address) onlyAdmin(2) public{
263         require(state == State.Successful); //Only when sale finish
264 
265         uint256 remainder = _address.balanceOf(address(this)); //Check remainder tokens
266         _address.transfer(msg.sender,remainder); //Transfer tokens to admin
267 
268     }
269 
270     /*
271     * @dev Direct payments handler
272     */
273     function () public payable {
274 
275         contribute(address(0),0); //Forward to contribute function
276 
277     }
278 }