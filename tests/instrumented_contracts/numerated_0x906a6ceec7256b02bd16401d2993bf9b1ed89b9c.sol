1 pragma solidity 0.4.19;
2 /**
3 * @title PREVIP CCS SALE CONTRACT
4 * @dev ERC-20 Token Standard Compliant
5 * @notice Contact ico@cacaoshares.com
6 * @author Fares A. Akel C.
7 * ================================================
8 * CACAO SHARES IS A DIGITAL ASSET
9 * THAT ENABLES ANYONE TO OWN CACAO TREES
10 * OF THE CRIOLLO TYPE IN SUR DEL LAGO, VENEZUELA
11 * ================================================
12 */
13 
14 /**
15 * @title SafeMath by OpenZeppelin
16 * @dev Math operations with safety checks that throw on error
17 */
18 library SafeMath {
19 
20     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21         uint256 c = a * b;
22         assert(a == 0 || c / a == b);
23         return c;
24     }
25 
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a / b;
28     return c;
29     }
30 
31 
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         assert(c >= a);
35         return c;
36     }
37 
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         assert(b <= a);
40         return a - b;
41     }
42 }
43 
44 /**
45 * @title Fiat currency contract
46 * @dev This contract will return the value of 0.01$ USD in wei
47 */
48 contract FiatContract {
49  
50   function USD(uint _id) constant returns (uint256);
51 
52 }
53 
54 /**
55 * @title DateTime contract
56 * @dev This contract will return the unix value of any date
57 */
58 contract DateTimeAPI {
59         
60     function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour) constant returns (uint timestamp);
61 
62 }
63 
64 /**
65 * @title ERC20 Token interface
66 */
67 contract token {
68 
69     function balanceOf(address _owner) public constant returns (uint256 balance);
70     function transfer(address _to, uint256 _value) public returns (bool success);
71 
72 }
73 
74 /**
75 * @title PREVIPCCS sale main contract
76 */
77 contract PREVIPCCS {
78 
79 
80     FiatContract price = FiatContract(0x8055d0504666e2B6942BeB8D6014c964658Ca591); // MAINNET ADDRESS
81     //FiatContract price = FiatContract(0x2CDe56E5c8235D6360CCbb0c57Ce248Ca9C80909); // TESTNET ADDRESS (ROPSTEN)
82 
83     DateTimeAPI dateTimeContract = DateTimeAPI(0x1a6184CD4C5Bea62B0116de7962EE7315B7bcBce);//Main
84     //DateTimeAPI dateTimeContract = DateTimeAPI(0x1F0a2ba4B115bd3e4007533C52BBd30C17E8B222);//Ropsten
85 
86     using SafeMath for uint256;
87     //This sale have 2 stages
88     enum State {
89         PreVIP,
90         Successful
91     }
92     //public variables
93     State public state = State.PreVIP; //Set initial stage
94     uint256 public startTime = dateTimeContract.toTimestamp(2018,2,13,15); //From Feb 14 00:00 (JST - GMT+9)
95     uint256 public PREVIPdeadline = dateTimeContract.toTimestamp(2018,2,28,15); //Stop Mar 1 00:00 (JST - GMT+9)
96     uint256 public totalRaised; //eth in wei
97     uint256 public totalDistributed; //tokens distributed
98     uint256 public completedAt; //Time stamp when the sale finish
99     token public tokenReward; //Address of the valid token used as reward
100     address public creator; //Address of the contract deployer
101     string public campaignUrl; //Web site of the campaign
102     string public version = '1';
103 
104     //events for log
105     event LogFundingReceived(address _addr, uint _amount, uint _currentTotal);
106     event LogBeneficiaryPaid(address _beneficiaryAddress);
107     event LogFundingSuccessful(uint _totalRaised);
108     event LogFunderInitialized(
109         address _creator,
110         string _url);
111     event LogContributorsPayout(address _addr, uint _amount);
112 
113     modifier notFinished() {
114         require(state != State.Successful);
115         _;
116     }
117     /**
118     * @notice PREVIPCCS constructor
119     * @param _campaignUrl is the ICO _url
120     * @param _addressOfTokenUsedAsReward is the token totalDistributed
121     */
122     function PREVIPCCS (string _campaignUrl, token _addressOfTokenUsedAsReward) public {
123         creator = msg.sender;
124         campaignUrl = _campaignUrl;
125         tokenReward = token(_addressOfTokenUsedAsReward);
126 
127         LogFunderInitialized(
128             creator,
129             campaignUrl
130             );
131     }
132 
133     /**
134     * @notice contribution handler
135     */
136     function contribute() public notFinished payable {
137         require(now >= startTime);
138         require(msg.value >= 1 szabo);
139 
140         uint256 tokenBought; //Variable to store amount of tokens bought
141         uint256 tokenPrice = price.USD(0); //1 cent value in wei
142 
143         totalRaised = totalRaised.add(msg.value); //Save the total eth totalRaised (in wei)
144 
145         tokenPrice = tokenPrice.mul(36); //0.36$ USD value in wei 
146         tokenPrice = tokenPrice.div(10 ** 8); //Change base 18 to 10
147 
148         tokenBought = msg.value.div(tokenPrice); //Base 18/ Base 10 = Base 8
149         tokenBought = tokenBought.mul(10 **10); //Base 8 to Base 18
150         
151         //Discount calculation
152         if (msg.value >= 10 ether){
153             tokenBought = tokenBought.mul(123);
154             tokenBought = tokenBought.div(100); //+10% discount reflected as +23% bonus
155         } else if (msg.value >= 1 ether){
156             tokenBought = tokenBought.mul(11);
157             tokenBought = tokenBought.div(10); //+5% discount reflected as +10% bonus
158         }
159 
160         totalDistributed = totalDistributed.add(tokenBought); //Save to total tokens distributed
161         
162         tokenReward.transfer(msg.sender,tokenBought); //Send Tokens
163         
164         //LOGS
165         LogFundingReceived(msg.sender, msg.value, totalRaised);
166         LogContributorsPayout(msg.sender,tokenBought);
167 
168         checkIfFundingCompleteOrExpired();
169     }
170 
171     /**
172     * @notice Function to know how many tokens you will receive at current time
173     * @param _amountOfWei How much ETH you will invest in Wei (1ETH = 10^18 WEI)
174     */
175     function calculateTokens(uint256 _amountOfWei) public view returns(uint256) {
176         require(_amountOfWei >= 1 szabo);
177         
178         uint256 tokenBought; //Variable to store amount of tokens bought
179         uint256 tokenPrice = price.USD(0); //1 cent value in wei
180 
181         tokenPrice = tokenPrice.mul(36); //0.36$ USD value in wei 
182         tokenPrice = tokenPrice.div(10 ** 8); //Change base 18 to 10
183 
184         tokenBought = _amountOfWei.div(tokenPrice); //Base 18/ Base 10 = Base 8
185         tokenBought = tokenBought.mul(10 **10); //Base 8 to Base 18
186 
187         //Discount calculation
188         if (_amountOfWei >= 10 ether){
189             tokenBought = tokenBought.mul(123);
190             tokenBought = tokenBought.div(100); //+10% discount reflected as +23% bonus
191         } else if (_amountOfWei >= 1 ether){
192             tokenBought = tokenBought.mul(11);
193             tokenBought = tokenBought.div(10); //+5% discount reflected as +10% bonus
194         }
195 
196         return tokenBought;
197 
198     }
199 
200     /**
201     * @notice Function to know how many tokens left on contract
202     */
203     function remainigTokens() public view returns(uint256) {
204         return tokenReward.balanceOf(this);
205     } 
206 
207     /**
208     * @notice check status
209     */
210     function checkIfFundingCompleteOrExpired() public {
211 
212         if(now > PREVIPdeadline && state != State.Successful){
213 
214             state = State.Successful; //Sale becomes Successful
215             completedAt = now; //PreVIP finished
216 
217             LogFundingSuccessful(totalRaised); //we log the finish
218 
219             finished();
220         }
221     }
222 
223     /**
224     * @notice Function for closure handle
225     */
226     function finished() public { //When finished eth are transfered to creator
227         require(state == State.Successful); //Only when sale finish
228         
229         uint256 remainder = tokenReward.balanceOf(this); //Remaining tokens on contract
230 
231         require(creator.send(this.balance)); //Funds send to creator
232         tokenReward.transfer(creator,remainder); //remainder tokens send to creator
233 
234         LogBeneficiaryPaid(creator);
235         LogContributorsPayout(creator, remainder);
236 
237     }
238 
239     /**
240     * @notice Function to claim any token stuck on contract
241     */
242     function claimTokens(token _address) public{
243         require(state == State.Successful); //Only when sale finish
244         require(msg.sender == creator);
245 
246         uint256 remainder = _address.balanceOf(this); //Check remainder tokens
247         _address.transfer(creator,remainder); //Transfer tokens to creator
248         
249     }
250 
251     /**
252     * @notice Function to claim any eth stuck on contract
253     */
254     function claimEth() public { //When finished eth are transfered to creator
255         require(state == State.Successful); //Only when sale finish
256         require(msg.sender == creator);
257 
258         require(creator.send(this.balance)); //Funds send to creator
259     }
260 
261     /**
262     * @notice Function to handle eth transfers
263     * @dev BEWARE: if a call to this functions doesn't have
264     * enought gas, transaction could not be finished
265     */
266     function () public payable {
267         contribute();
268     }
269 }