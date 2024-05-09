1 pragma solidity ^0.4.16;
2 /**
3 * @title UNR ICO CONTRACT
4 * @dev ERC-20 Token Standard Compliant
5 * @author Fares A. Akel C. f.antonio.akel@gmail.com
6 */
7 
8 /**
9  * @title SafeMath by OpenZeppelin
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13 
14     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a * b;
16         assert(a == 0 || c / a == b);
17         return c;
18     }
19 
20     function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a / b;
22     return c;
23     }
24 
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 contract token {
34 
35     function balanceOf(address _owner) public constant returns (uint256 balance);
36     function transfer(address _to, uint256 _value) public returns (bool success);
37 
38     }
39 
40 /**
41  * @title admined
42  * @notice This contract is administered
43  */
44 contract admined {
45     address public admin; //Admin address is public
46     
47     /**
48     * @dev This contructor takes the msg.sender as the first administer
49     */
50     function admined() internal {
51         admin = msg.sender; //Set initial admin to contract creator
52         Admined(admin);
53     }
54 
55     /**
56     * @dev This modifier limits function execution to the admin
57     */
58     modifier onlyAdmin() { //A modifier to define admin-only functions
59         require(msg.sender == admin);
60         _;
61     }
62 
63     /**
64     * @notice This function transfer the adminship of the contract to _newAdmin
65     * @param _newAdmin The new admin of the contract
66     */
67     function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered
68         admin = _newAdmin;
69         TransferAdminship(admin);
70     }
71 
72     /**
73     * @dev Log Events
74     */
75     event TransferAdminship(address newAdminister);
76     event Admined(address administer);
77 
78 }
79 
80 
81 contract UNRICO is admined {
82     using SafeMath for uint256;
83     //This ico have 3 stages
84     enum State {
85         Ongoin,
86         Successful
87     }
88     //public variables
89     uint256 public priceOfEthOnUSD;
90     State public state = State.Ongoin; //Set initial stage
91     uint256 public startTime = now; //block-time when it was deployed
92     uint256[5] public price;
93     uint256 public HardCap;
94     uint256 public totalRaised; //eth in wei
95     uint256 public totalDistributed; //tokens
96     uint256 public ICOdeadline = startTime.add(27 days);//27 days deadline
97     uint256 public completedAt;
98     token public tokenReward;
99     address public creator;
100     address public beneficiary;
101     string public campaignUrl;
102     uint8 constant version = 1;
103 
104     //events for log
105     event LogFundingReceived(address _addr, uint _amount, uint _currentTotal);
106     event LogBeneficiaryPaid(address _beneficiaryAddress);
107     event LogFundingSuccessful(uint _totalRaised);
108     event LogFunderInitialized(
109         address _creator,
110         address _beneficiary,
111         string _url,
112         uint256 _ICOdeadline);
113     event LogContributorsPayout(address _addr, uint _amount);
114     event PriceUpdate(uint256 _newPrice);
115 
116     modifier notFinished() {
117         require(state != State.Successful);
118         _;
119     }
120     /**
121     * @notice ICO constructor
122     * @param _campaignUrl is the ICO _url
123     * @param _addressOfTokenUsedAsReward is the token totalDistributed
124     * @param _initialUsdPriceOfEth is the current price in USD for a single ether
125     */
126     function UNRICO (string _campaignUrl, token _addressOfTokenUsedAsReward, uint256 _initialUsdPriceOfEth) public {
127         creator = msg.sender;
128         beneficiary = msg.sender;
129         campaignUrl = _campaignUrl;
130         tokenReward = token(_addressOfTokenUsedAsReward);
131         priceOfEthOnUSD = _initialUsdPriceOfEth;
132         HardCap = SafeMath.div(7260000*10**18,priceOfEthOnUSD); //7,260,000$
133         price[0] = SafeMath.div(1 * 10 ** 15, priceOfEthOnUSD.mul(1666666));
134         price[1] = SafeMath.div(1 * 10 ** 11, priceOfEthOnUSD.mul(125));
135         price[2] = SafeMath.div(1 * 10 ** 15, priceOfEthOnUSD.mul(1111111));
136         price[3] = SafeMath.div(1 * 10 ** 15, priceOfEthOnUSD.mul(1052631));
137         price[4] = SafeMath.div(1 * 10 ** 10, priceOfEthOnUSD.mul(10));
138 
139         LogFunderInitialized(
140             creator,
141             beneficiary,
142             campaignUrl,
143             ICOdeadline);
144         PriceUpdate(priceOfEthOnUSD);
145     }
146 
147     function updatePriceOfEth(uint256 _newPrice) onlyAdmin public {
148         priceOfEthOnUSD = _newPrice;
149         price[0] = SafeMath.div(1 * 10 ** 15, priceOfEthOnUSD.mul(1666666));
150         price[1] = SafeMath.div(1 * 10 ** 11, priceOfEthOnUSD.mul(125));
151         price[2] = SafeMath.div(1 * 10 ** 15, priceOfEthOnUSD.mul(1111111));
152         price[3] = SafeMath.div(1 * 10 ** 15, priceOfEthOnUSD.mul(1052631));
153         price[4] = SafeMath.div(1 * 10 ** 10, priceOfEthOnUSD.mul(10));
154         HardCap = SafeMath.div(7260000*10**18,priceOfEthOnUSD); //7,260,000$
155         PriceUpdate(_newPrice);
156     }
157 
158     /**
159     * @notice contribution handler
160     */
161     function contribute() public notFinished payable {
162 
163         uint256 tokenBought;
164         uint256 required;
165         totalRaised = totalRaised.add(msg.value);
166 
167         if(totalDistributed < 2000000 * (10 ** 8)){
168             tokenBought = msg.value.div(price[0]);
169             required = SafeMath.div(10000,6);
170             require(tokenBought >= required);
171         }
172         else if (totalDistributed < 20000000 * (10 ** 8)){
173             tokenBought = msg.value.div(price[1]);
174             required = SafeMath.div(10000,8);
175             require(tokenBought >= required);
176         }
177         else if (totalDistributed < 40000000 * (10 ** 8)){
178             tokenBought = msg.value.div(price[2]);
179             required = SafeMath.div(10000,9);
180             require(tokenBought >= required);
181         }
182         else if (totalDistributed < 60000000 * (10 ** 8)){
183             tokenBought = msg.value.div(price[3]);
184             required = SafeMath.div(100000,95);
185             require(tokenBought >= required);
186         }
187         else if (totalDistributed < 80000000 * (10 ** 8)){
188             tokenBought = msg.value.div(price[4]);
189             required = 1000;
190             require(tokenBought >= required);
191 
192         }
193 
194 
195         totalDistributed = totalDistributed.add(tokenBought);
196         tokenReward.transfer(msg.sender, tokenBought);
197         
198         LogFundingReceived(msg.sender, msg.value, totalRaised);
199         LogContributorsPayout(msg.sender, tokenBought);
200         
201         checkIfFundingCompleteOrExpired();
202     }
203 
204     /**
205     * @notice check status
206     */
207     function checkIfFundingCompleteOrExpired() public {
208         
209         if(now < ICOdeadline && state!=State.Successful){ //if we are on ICO period and its not Successful
210             if(state == State.Ongoin && totalRaised >= HardCap){ //if we are Ongoin and we pass the HardCap
211                 state = State.Successful; //We are on Successful state
212                 completedAt = now; //ICO is complete
213             }
214         }
215         else if(now > ICOdeadline && state!=State.Successful ) { //if we reach ico deadline and its not Successful yet
216             state = State.Successful; //ico becomes Successful
217             completedAt = now; //ICO is complete
218             LogFundingSuccessful(totalRaised); //we log the finish
219             finished(); //and execute closure
220         }
221     }
222 
223     function payOut() public {
224         require(msg.sender == beneficiary);
225         require(beneficiary.send(this.balance));
226         LogBeneficiaryPaid(beneficiary);
227     }
228 
229    /**
230     * @notice closure handler
231     */
232     function finished() public { //When finished eth are transfered to beneficiary
233         require(state == State.Successful);
234         uint256 remanent = tokenReward.balanceOf(this);
235 
236         require(beneficiary.send(this.balance));
237         tokenReward.transfer(beneficiary,remanent);
238 
239         LogBeneficiaryPaid(beneficiary);
240         LogContributorsPayout(beneficiary, remanent);
241     }
242 
243     function () public payable {
244         contribute();
245     }
246 }