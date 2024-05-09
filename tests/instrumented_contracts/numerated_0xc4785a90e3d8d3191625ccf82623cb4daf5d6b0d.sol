1 pragma solidity ^0.4.20;
2 /**
3 * @title ICO SALE CONTRACT
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
20         uint256 c = a / b;
21         return c;
22     }
23 
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32         assert(b <= a);
33         return a - b;
34     }
35 }
36 
37 /**
38 * @title Fiat currency contract
39 * @dev This contract will return the value of 0.01$ ETH in wei
40 */
41 contract FiatContract {
42  
43   function EUR(uint _id) constant public returns (uint256);
44 
45 }
46 
47 /**
48 * @title DateTime contract
49 * @dev This contract will return the unix value of any date
50 */
51 contract DateTimeAPI {
52         
53     function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour) constant public returns (uint timestamp);
54 
55 }
56 
57 /**
58 * @title ERC20 Token interface
59 */
60 contract token {
61 
62     function balanceOf(address _owner) public constant returns (uint256 balance);
63     function transfer(address _to, uint256 _value) public returns (bool success);
64 
65 }
66 
67 /**
68 * @title NETRico sale main contract
69 */
70 contract NETRico {
71 
72     FiatContract price = FiatContract(0x8055d0504666e2B6942BeB8D6014c964658Ca591); // MAINNET ADDRESS
73 
74     DateTimeAPI dateTimeContract = DateTimeAPI(0x1a6184CD4C5Bea62B0116de7962EE7315B7bcBce);//Main
75 
76     using SafeMath for uint256;
77     //This sale have 5 stages
78     enum State {
79         Stage1,
80         Stage2,
81         Stage3,
82         Stage4,
83         Successful
84     }
85     //public variables
86     State public state = State.Stage1; //Set initial stage
87     uint256 public startTime = dateTimeContract.toTimestamp(2018,4,1,0); //From Apr 1 2018 00:00
88     uint256 public deadline = dateTimeContract.toTimestamp(2019,3,27,0); //Stop Mar 27 2019 00:00
89     uint256 public totalRaised; //eth in wei
90     uint256 public totalDistributed; //tokens distributed
91     uint256 public completedAt; //Time stamp when the sale finish
92     token public tokenReward; //Address of the valid token used as reward
93     address public creator; //Address of the contract deployer
94     string public campaignUrl; //Web site of the campaign
95     string public version = '2';
96 
97     //events for log
98     event LogFundingReceived(address _addr, uint _amount, uint _currentTotal);
99     event LogBeneficiaryPaid(address _beneficiaryAddress);
100     event LogFundingSuccessful(uint _totalRaised);
101     event LogFunderInitialized(
102         address _creator,
103         string _url);
104     event LogContributorsPayout(address _addr, uint _amount);
105 
106     modifier notFinished() {
107         require(state != State.Successful);
108         _;
109     }
110     /**
111     * @notice NETRico constructor
112     * @param _campaignUrl is the ICO _url
113     * @param _addressOfTokenUsedAsReward is the token totalDistributed
114     */
115     function NETRico (string _campaignUrl, token _addressOfTokenUsedAsReward) public {
116         creator = 0xB987B463c7573f0B7b6eD7cc8E5Fab9042272065;
117         //creator = msg.sender;
118         campaignUrl = _campaignUrl;
119         tokenReward = token(_addressOfTokenUsedAsReward);
120 
121         emit LogFunderInitialized(
122             creator,
123             campaignUrl
124             );
125     }
126 
127     /**
128     * @notice contribution handler
129     */
130     function contribute() public notFinished payable {
131         require(now >= startTime);
132 
133         uint256 tokenBought; //Variable to store amount of tokens bought
134         uint256 tokenPrice = price.EUR(0); //1 cent value in wei
135 
136         totalRaised = totalRaised.add(msg.value); //Save the total eth totalRaised (in wei)
137 
138         tokenPrice = tokenPrice.mul(2); //0.02$ EUR value in wei 
139         tokenPrice = tokenPrice.div(10 ** 8); //Change base 18 to 10
140 
141         tokenBought = msg.value.div(tokenPrice); //Base 18/ Base 10 = Base 8
142         tokenBought = tokenBought.mul(10 ** 10); //Base 8 to Base 18
143 
144         require(tokenBought >= 100 * 10 ** 18); //Minimum 100 base tokens 
145         
146         //Bonus calculation
147         if (state == State.Stage1){
148             tokenBought = tokenBought.mul(2); //+100%
149         } else if (state == State.Stage2){
150             tokenBought = tokenBought.mul(175);
151             tokenBought = tokenBought.div(100); //+75%
152         } else if (state == State.Stage3){
153             tokenBought = tokenBought.mul(15);
154             tokenBought = tokenBought.div(10); //+50%
155         } else if (state == State.Stage4){
156             tokenBought = tokenBought.mul(125);
157             tokenBought = tokenBought.div(100); //+25%
158         }
159 
160         totalDistributed = totalDistributed.add(tokenBought); //Save to total tokens distributed
161         
162         tokenReward.transfer(msg.sender,tokenBought); //Send Tokens
163         
164         creator.transfer(msg.value); // Send ETH to creator
165         emit LogBeneficiaryPaid(creator);
166         
167         //LOGS
168         emit LogFundingReceived(msg.sender, msg.value, totalRaised);
169         emit  LogContributorsPayout(msg.sender,tokenBought);
170 
171         checkIfFundingCompleteOrExpired();
172     }
173 
174     /**
175     * @notice check status
176     */
177     function checkIfFundingCompleteOrExpired() public {
178 
179         if(now > deadline && state != State.Successful){
180 
181             state = State.Successful; //Sale becomes Successful
182             completedAt = now; //ICO finished
183 
184             emit LogFundingSuccessful(totalRaised); //we log the finish
185 
186             finished();
187         } else if(state == State.Stage3 && now > dateTimeContract.toTimestamp(2018,12,27,0)){
188 
189             state = State.Stage4;
190             
191         } else if(state == State.Stage2 && now > dateTimeContract.toTimestamp(2018,9,28,0)){
192 
193             state = State.Stage3;
194             
195         } else if(state == State.Stage1 && now > dateTimeContract.toTimestamp(2018,6,30,0)){
196 
197             state = State.Stage2;
198 
199         }
200     }
201 
202     /**
203     * @notice Function for closure handle
204     */
205     function finished() public { //When finished eth are transfered to creator
206         require(state == State.Successful); //Only when sale finish
207         
208         uint256 remainder = tokenReward.balanceOf(this); //Remaining tokens on contract
209         //Funds send to creator if any
210         if(address(this).balance > 0) {
211             creator.transfer(address(this).balance);
212             emit LogBeneficiaryPaid(creator);
213         }
214  
215         tokenReward.transfer(creator,remainder); //remainder tokens send to creator
216         emit LogContributorsPayout(creator, remainder);
217 
218     }
219 
220     /**
221     * @notice Function to claim any token stuck on contract
222     */
223     function claimTokens(token _address) public{
224         require(state == State.Successful); //Only when sale finish
225         require(msg.sender == creator);
226 
227         uint256 remainder = _address.balanceOf(this); //Check remainder tokens
228         _address.transfer(creator,remainder); //Transfer tokens to creator
229         
230     }
231 
232     /**
233     * @notice Function to handle eth transfers
234     * @dev BEWARE: if a call to this functions doesn't have
235     * enought gas, transaction could not be finished
236     */
237     function() public payable {
238         contribute();
239     }
240     
241 }