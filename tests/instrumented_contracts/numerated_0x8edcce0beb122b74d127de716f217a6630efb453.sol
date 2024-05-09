1 pragma solidity ^0.4.18;
2 /**
3 * @title ICO CONTRACT
4 * @dev ERC-20 Token Standard Compliant
5 */
6 
7 /**
8 * @title SafeMath by OpenZeppelin
9 * @dev Math operations with safety checks that throw on error
10 */
11 library SafeMath {
12 
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a * b;
15         assert(a == 0 || c / a == b);
16         return c;
17     }
18 
19     function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     uint256 c = a / b;
21     return c;
22     }
23 
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 contract token {
33 
34     function balanceOf(address _owner) public constant returns (uint256 balance);
35     function transfer(address _to, uint256 _value) public returns (bool success);
36 
37     }
38 
39 /**
40 * @title admined
41 * @notice This contract is administered
42 */
43 contract admined {
44     address public admin; //Admin address is public
45     
46     /**
47     * @dev This contructor takes the msg.sender as the first administer
48     */
49     function admined() internal {
50         admin = msg.sender; //Set initial admin to contract creator
51         Admined(admin);
52     }
53 
54     /**
55     * @dev This modifier limits function execution to the admin
56     */
57     modifier onlyAdmin() { //A modifier to define admin-only functions
58         require(msg.sender == admin);
59         _;
60     }
61 
62     /**
63     * @notice This function transfer the adminship of the contract to _newAdmin
64     * @param _newAdmin The new admin of the contract
65     */
66     function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered
67         admin = _newAdmin;
68         TransferAdminship(admin);
69     }
70 
71     /**
72     * @dev Log Events
73     */
74     event TransferAdminship(address newAdminister);
75     event Admined(address administer);
76 
77 }
78 
79 
80 contract ICO is admined {
81     using SafeMath for uint256;
82     //This ico have 5 stages
83     enum State {
84         EarlyBird,
85         PreSale,
86         TokenSale,
87         ITO,
88         Successful
89     }
90     //public variables
91     uint256 public priceOfEthOnEUR;
92     State public state = State.EarlyBird; //Set initial stage
93     uint256 public startTime = now; //block-time when it was deployed
94     uint256 public price; //Price rate for base calculation
95     uint256 public totalRaised; //eth in wei
96     uint256 public totalDistributed; //tokens distributed
97     uint256 public stageDistributed; //tokens distributed on the actual stage
98     uint256 public completedAt; //Time stamp when the ico finish
99     token public tokenReward; //Address of the valit token used as reward
100     address public creator; //Address of the contract deployer
101     string public campaignUrl; //Web site of the campaing
102     string public version = '1';
103 
104     //events for log
105     event LogFundingReceived(address _addr, uint _amount, uint _currentTotal);
106     event LogBeneficiaryPaid(address _beneficiaryAddress);
107     event LogFundingSuccessful(uint _totalRaised);
108     event LogFunderInitialized(
109         address _creator,
110         string _url,
111         uint256 _initialRate);
112     event LogContributorsPayout(address _addr, uint _amount);
113     event PriceUpdate(uint256 _newPrice);
114     event StageDistributed(State _stage, uint256 _stageDistributed);
115 
116     modifier notFinished() {
117         require(state != State.Successful);
118         _;
119     }
120     /**
121     * @notice ICO constructor
122     * @param _campaignUrl is the ICO _url
123     * @param _addressOfTokenUsedAsReward is the token totalDistributed
124     * @param _initialEURPriceOfEth is the current price in EUR for a single ether
125     */
126     function ICO (string _campaignUrl, token _addressOfTokenUsedAsReward, uint256 _initialEURPriceOfEth) public {
127         creator = msg.sender;
128         campaignUrl = _campaignUrl;
129         tokenReward = token(_addressOfTokenUsedAsReward);
130         priceOfEthOnEUR = _initialEURPriceOfEth;
131         price = SafeMath.div(priceOfEthOnEUR.mul(6666666666666666667),1000000000000000000);
132         
133         LogFunderInitialized(
134             creator,
135             campaignUrl,
136             price
137             );
138         PriceUpdate(price);
139     }
140 
141     function updatePriceOfEth(uint256 _newPrice) onlyAdmin public {
142         priceOfEthOnEUR = _newPrice;
143         price = SafeMath.div(priceOfEthOnEUR.mul(6666666666666666667),1000000000000000000);
144         PriceUpdate(price);
145     }
146 
147     /**
148     * @notice contribution handler
149     */
150     function contribute() public notFinished payable {
151 
152         uint256 tokenBought;
153         totalRaised = totalRaised.add(msg.value);
154 
155         if (state == State.EarlyBird){
156 
157             tokenBought = msg.value.mul(price);
158             tokenBought = tokenBought.mul(4); //4x
159             require(stageDistributed.add(tokenBought) <= 200000000 * (10 ** 18));
160 
161         } else if (state == State.PreSale){
162 
163             tokenBought = msg.value.mul(price);
164             tokenBought = tokenBought.mul(15); //1.5x
165             tokenBought = tokenBought.div(10);
166             require(stageDistributed.add(tokenBought) <= 500000000 * (10 ** 18));
167 
168         } else if (state == State.TokenSale){
169 
170             tokenBought = msg.value.mul(price); //1x
171             require(stageDistributed.add(tokenBought) <= 500000000 * (10 ** 18));
172 
173         } else if (state == State.ITO){
174 
175             tokenBought = msg.value.mul(price); //1x
176             require(stageDistributed.add(tokenBought) <= 800000000 * (10 ** 18));
177 
178         } 
179 
180         totalDistributed = totalDistributed.add(tokenBought);
181         stageDistributed = stageDistributed.add(tokenBought);
182         tokenReward.transfer(msg.sender, tokenBought);
183         
184         LogFundingReceived(msg.sender, msg.value, totalRaised);
185         LogContributorsPayout(msg.sender, tokenBought);
186         
187         checkIfFundingCompleteOrExpired();
188     }
189 
190     /**
191     * @notice check status
192     */
193     function checkIfFundingCompleteOrExpired() public {
194         
195         if(state!=State.Successful){ //if we are on ICO period and its not Successful
196             
197             if(state == State.EarlyBird && now > startTime.add(38 days)){ //38 days - 25.12.2017 to 01.02.2018
198                 
199                 StageDistributed(state,stageDistributed);
200 
201                 state = State.PreSale;
202                 stageDistributed = 0;
203             
204             } else if(state == State.PreSale && now > startTime.add(127 days)){ //89 days(+38) - 01.02.2018 to 01.05.2018
205                 
206                 StageDistributed(state,stageDistributed);
207 
208                 state = State.TokenSale;
209                 stageDistributed = 0;
210 
211             } else if(state == State.TokenSale && now > startTime.add(219 days)){ //92 days(+127) - 01.05.2018 to 01.08.2018
212             
213                 StageDistributed(state,stageDistributed);
214 
215                 state = State.ITO;
216                 stageDistributed = 0;
217 
218             } else if(state == State.ITO && now > startTime.add(372 days)){ //153 days(+219) - 01.08.2018 to 01.01.2019
219                 
220                 StageDistributed(state,stageDistributed);
221 
222                 state = State.Successful; //ico becomes Successful
223                 completedAt = now; //ICO is complete
224                 LogFundingSuccessful(totalRaised); //we log the finish
225                 finished(); //and execute closure
226             
227             }
228         }
229     }
230 
231     /**
232     * @notice function to withdraw eth to creator address
233     */
234     function payOut() public {
235         require(msg.sender == creator); //Only the creator can withdraw funds
236         require(creator.send(this.balance));
237         LogBeneficiaryPaid(creator);
238     }
239 
240     /**
241     * @notice closure handler
242     */
243     function finished() public { //When finished eth are transfered to creator
244         require(state == State.Successful);
245         uint256 remanent = tokenReward.balanceOf(this);
246 
247         require(creator.send(this.balance));
248         tokenReward.transfer(creator,remanent);
249 
250         LogBeneficiaryPaid(creator);
251         LogContributorsPayout(creator, remanent);
252     }
253 
254     function () public payable {
255         contribute();
256     }
257 }