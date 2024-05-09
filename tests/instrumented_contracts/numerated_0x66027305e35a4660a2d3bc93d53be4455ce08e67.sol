1 pragma solidity ^0.4.23;
2 
3 // File: contracts/commons/SafeMath.sol
4 
5 /**
6  * @title SafeMath by OpenZeppelin (partially)
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         uint256 c = a * b;
13         assert(a == 0 || c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         uint256 c = a / b;
19         return c;
20     }
21 
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29         assert(b <= a);
30         return a - b;
31     }
32 }
33 
34 // File: contracts/interfaces/ERC20TokenInterface.sol
35 
36 /**
37  * Token contract interface for external use
38  */
39 contract ERC20TokenInterface {
40 
41     function balanceOf(address _owner) public constant returns (uint256 value);
42 
43     function transfer(address _to, uint256 _value) public returns (bool success);
44 
45     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
46 
47     function approve(address _spender, uint256 _value) public returns (bool success);
48 
49     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
50 
51 }
52 
53 // File: contracts/interfaces/FiatContractInterface.sol
54 
55 /**
56 * @title Fiat currency contract
57 * @dev This contract will return the value of 0.01$ ETH in wei
58 */
59 contract FiatContractInterface {
60 
61     function EUR(uint _id) public constant returns (uint256);
62 
63 }
64 
65 // File: contracts/NETRico.sol
66 
67 /**
68 * @title NETRico sale main contract
69 */
70 contract NETRico {
71 
72     FiatContractInterface price = FiatContractInterface(0x8055d0504666e2B6942BeB8D6014c964658Ca591); // MAINNET ADDRESS
73 
74     using SafeMath for uint256;
75 
76     //This sale have 3 stages
77     enum State {
78         Stage1,
79         Stage2,
80         Successful
81     }
82 
83     //public variables
84     State public state = State.Stage1; //Set initial stage
85     uint256 public startTime;
86     uint256 public startStage2Time;
87     uint256 public deadline;
88     uint256 public totalRaised; //eth in wei
89     uint256 public totalDistributed; //tokens distributed
90     uint256 public completedAt; //Time stamp when the sale finish
91     ERC20TokenInterface public tokenReward; //Address of the valid token used as reward
92     address public creator; //Address of the contract deployer
93     string public campaignUrl; //Web site of the campaign
94     string public version = "2";
95 
96     //events for log
97     event LogFundingReceived(address _addr, uint _amount, uint _currentTotal);
98     event LogBeneficiaryPaid(address _beneficiaryAddress);
99     event LogFundingSuccessful(uint _totalRaised);
100     event LogFunderInitialized(address _creator, string _url);
101     event LogContributorsPayout(address _addr, uint _amount);
102 
103     modifier notFinished() {
104         require(state != State.Successful);
105         _;
106     }
107 
108     modifier onlyCreator() {
109         require(msg.sender == creator);
110         _;
111     }
112 
113     /**
114     * @notice NETRico constructor
115     * @param _campaignUrl is the ICO _url
116     * @param _addressOfTokenUsedAsReward is the token totalDistributed
117     * @param _startTime timestamp of Stage1 start
118     * @param _startStage2Time timestamp of Stage2 start
119     * @param _deadline timestamp of Stage2 stop
120     */
121     function NETRico(string _campaignUrl, ERC20TokenInterface _addressOfTokenUsedAsReward,
122         uint256 _startTime, uint256 _startStage2Time, uint256 _deadline) public {
123         require(_addressOfTokenUsedAsReward != address(0)
124             && _startTime > now
125             && _startStage2Time > _startTime
126             && _deadline > _startStage2Time);
127 
128         creator = 0xB987B463c7573f0B7b6eD7cc8E5Fab9042272065;
129         //creator = msg.sender;
130         campaignUrl = _campaignUrl;
131         tokenReward = ERC20TokenInterface(_addressOfTokenUsedAsReward);
132 
133         startTime = _startTime;
134         startStage2Time = _startStage2Time;
135         deadline = _deadline;
136 
137         emit LogFunderInitialized(creator, campaignUrl);
138     }
139 
140     /**
141     * @notice Function to handle eth transfers
142     * @dev BEWARE: if a call to this functions doesn't have
143     * enough gas, transaction could not be finished
144     */
145     function() public payable {
146         contribute();
147     }
148 
149     /**
150     * @notice Set timestamp of Stage2 start
151     **/
152     function setStage2Start(uint256 _startStage2Time) public onlyCreator {
153         require(_startStage2Time > now && _startStage2Time > startTime && _startStage2Time < deadline);
154         startStage2Time = _startStage2Time;
155     }
156 
157     /**
158     * @notice Set timestamp of deadline
159     **/
160     function setDeadline(uint256 _deadline) public onlyCreator {
161         require(_deadline > now && _deadline > startStage2Time);
162         deadline = _deadline;
163     }
164 
165     /**
166     * @notice contribution handler
167     */
168     function contribute() public notFinished payable {
169         require(now >= startTime);
170 
171         uint256 tokenBought;
172         //Variable to store amount of tokens bought
173         uint256 tokenPrice = price.EUR(0);
174         //1 cent value in wei
175 
176         totalRaised = totalRaised.add(msg.value);
177         //Save the total eth totalRaised (in wei)
178 
179         tokenPrice = tokenPrice.mul(2);
180         //0.02$ EUR value in wei
181         tokenPrice = tokenPrice.div(10 ** 8);
182         //Change base 18 to 10
183 
184         tokenBought = msg.value.div(tokenPrice);
185         //Base 18/ Base 10 = Base 8
186         tokenBought = tokenBought.mul(10 ** 10);
187         //Base 8 to Base 18
188 
189         require(tokenBought >= 100 * 10 ** 18);
190         //Minimum 100 base tokens
191 
192         //Bonus calculation
193         if (state == State.Stage1) {
194             tokenBought = tokenBought.mul(140);
195             tokenBought = tokenBought.div(100);
196             //+40%
197         } else if (state == State.Stage2) {
198             tokenBought = tokenBought.mul(120);
199             tokenBought = tokenBought.div(100);
200             //+20%
201         }
202 
203         totalDistributed = totalDistributed.add(tokenBought);
204         //Save to total tokens distributed
205 
206         tokenReward.transfer(msg.sender, tokenBought);
207         //Send Tokens
208 
209         creator.transfer(msg.value);
210         // Send ETH to creator
211         emit LogBeneficiaryPaid(creator);
212 
213         //LOGS
214         emit LogFundingReceived(msg.sender, msg.value, totalRaised);
215         emit LogContributorsPayout(msg.sender, tokenBought);
216 
217         checkIfFundingCompleteOrExpired();
218     }
219 
220     /**
221     * @notice check status
222     */
223     function checkIfFundingCompleteOrExpired() public {
224 
225         if (now > deadline && state != State.Successful) {
226 
227             state = State.Successful;
228             //Sale becomes Successful
229             completedAt = now;
230             //ICO finished
231 
232             emit LogFundingSuccessful(totalRaised);
233             //we log the finish
234 
235             finished();
236         } else if (state == State.Stage1 && now >= startStage2Time) {
237 
238             state = State.Stage2;
239 
240         }
241     }
242 
243     /**
244     * @notice Function for closure handle
245     */
246     function finished() public { //When finished eth are transferred to creator
247         require(state == State.Successful);
248         //Only when sale finish
249 
250         uint256 remainder = tokenReward.balanceOf(this);
251         //Remaining tokens on contract
252         //Funds send to creator if any
253         if (address(this).balance > 0) {
254             creator.transfer(address(this).balance);
255             emit LogBeneficiaryPaid(creator);
256         }
257 
258         tokenReward.transfer(creator, remainder);
259         //remainder tokens send to creator
260         emit LogContributorsPayout(creator, remainder);
261 
262     }
263 
264     /**
265     * @notice Function to claim any token stuck on contract
266     */
267     function claimTokens(ERC20TokenInterface _address) public {
268         require(state == State.Successful);
269         //Only when sale finish
270         require(msg.sender == creator);
271 
272         uint256 remainder = _address.balanceOf(this);
273         //Check remainder tokens
274         _address.transfer(creator, remainder);
275         //Transfer tokens to creator
276 
277     }
278 }