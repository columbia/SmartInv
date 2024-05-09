1 pragma solidity 0.4.21;
2 /**
3 * @title ICO CONTRACT
4 * @dev ERC-20 Token Standard Compliant
5 * @notice Website: Ze.cash
6 * @author Fares A. Akel C. f.antonio.akel@gmail.com
7 */
8 
9 /**
10 * @title SafeMath by OpenZeppelin
11 * @dev Math operations with safety checks that throw on error
12 */
13 library SafeMath {
14 
15     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16         uint256 c = a * b;
17         assert(a == 0 || c / a == b);
18         return c;
19     }
20 
21     function div(uint256 a, uint256 b) internal pure returns (uint256) {
22     uint256 c = a / b;
23     return c;
24     }
25 
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         assert(b <= a);
35         return a - b;
36     }
37 }
38 
39 contract FiatContract {
40  
41   function USD(uint _id) public constant returns (uint256);
42 
43 }
44 
45 contract token {
46 
47     function balanceOf(address _owner) public constant returns (uint256 balance);
48     function transfer(address _to, uint256 _value) public returns (bool success);
49 
50 }
51 
52 /**
53 * @title Admin parameters
54 * @dev Define administration parameters for this contract
55 */
56 contract admined { //This token contract is administered
57     address public admin; //Admin address is public
58 
59     /**
60     * @dev Contract constructor
61     * define initial administrator
62     */
63     function admined() internal {
64         admin = msg.sender; //Set initial admin to contract creator
65         emit Admined(admin);
66     }
67 
68     modifier onlyAdmin() { //A modifier to define admin-only functions
69         require(msg.sender == admin);
70         _;
71     }
72 
73    /**
74     * @dev Function to set new admin address
75     * @param _newAdmin The address to transfer administration to
76     */
77     function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered
78         require(_newAdmin != address(0));
79         admin = _newAdmin;
80         emit TransferAdminship(admin);
81     }
82 
83     event TransferAdminship(address newAdminister);
84     event Admined(address administer);
85 
86 }
87 
88 contract ICO is admined{
89     using SafeMath for uint256;
90     //This ico have 2 stages
91     enum State {
92         Sale,
93         Successful
94     }
95     //public variables
96     State public state = State.Sale; //Set initial stage
97     uint256 public startTime = now; //block-time when it was deployed
98     uint256 public totalRaised; //eth in wei
99     uint256 public totalDistributed; //tokens distributed
100     uint256 public completedAt; //Time stamp when the ico finish
101     token public tokenReward; //Address of the valit token used as reward
102     address public creator; //Address of the contract deployer
103     string public campaignUrl; //Web site of the campaing
104     string public version = '2';
105 
106     FiatContract price = FiatContract(0x8055d0504666e2B6942BeB8D6014c964658Ca591); // MAINNET ADDRESS
107     //FiatContract price = FiatContract(0x2CDe56E5c8235D6360CCbb0c57Ce248Ca9C80909); // TESTNET ADDRESS (ROPSTEN)
108 
109     uint256 remanent;
110 
111     //events for log
112     event LogFundingReceived(address _addr, uint _amount, uint _currentTotal);
113     event LogBeneficiaryPaid(address _beneficiaryAddress);
114     event LogFundingSuccessful(uint _totalRaised);
115     event LogFunderInitialized(
116         address _creator,
117         string _url);
118     event LogContributorsPayout(address _addr, uint _amount);
119 
120     modifier notFinished() {
121         require(state != State.Successful);
122         _;
123     }
124     /**
125     * @notice ICO constructor
126     * @param _campaignUrl is the ICO _url
127     * @param _addressOfTokenUsedAsReward is the token totalDistributed
128     */
129     function ICO (string _campaignUrl, token _addressOfTokenUsedAsReward) public {
130         creator = msg.sender;
131         campaignUrl = _campaignUrl;
132         tokenReward = token(_addressOfTokenUsedAsReward);
133 
134         emit LogFunderInitialized(
135             creator,
136             campaignUrl
137             );
138     }
139 
140     /**
141     * @notice contribution handler
142     */
143     function contribute() public notFinished payable {
144 
145         uint256 tokenBought; //Variable to store amount of tokens bought
146         uint256 tokenPrice = price.USD(0); //1 cent value in wei
147 
148         tokenPrice = tokenPrice.div(10 ** 7);
149         totalRaised = totalRaised.add(msg.value); //Save the total eth totalRaised (in wei)
150 
151         tokenBought = msg.value.div(tokenPrice);
152         tokenBought = tokenBought.mul(10 **10); //0.10$ per token
153         
154         totalDistributed = totalDistributed.add(tokenBought);
155         
156         tokenReward.transfer(msg.sender,tokenBought);
157         
158         emit LogFundingReceived(msg.sender, msg.value, totalRaised);
159         emit LogContributorsPayout(msg.sender,tokenBought);
160     }
161 
162     function finishFunding() onlyAdmin public {
163 
164         state = State.Successful; //ico becomes Successful
165         completedAt = now; //ICO is complete
166         emit LogFundingSuccessful(totalRaised); //we log the finish
167         claimTokens();
168         claimEth();
169             
170     }
171 
172     function claimTokens() onlyAdmin public{
173 
174         remanent = tokenReward.balanceOf(this);
175         tokenReward.transfer(msg.sender,remanent);
176         
177         emit LogContributorsPayout(msg.sender,remanent);
178     }
179 
180     function claimEth() onlyAdmin public { //When finished eth are transfered to creator
181         
182         require(msg.sender.send(address(this).balance));
183 
184         emit LogBeneficiaryPaid(msg.sender);
185         
186     }
187 
188     /**
189     * @dev This is an especial function to make massive tokens assignments
190     * @param _data array of addresses to transfer to
191     * @param _amount array of amounts to tranfer to each address
192     */
193     function batch(address[] _data,uint256[] _amount) onlyAdmin public { //It takes array of addresses and array of amount
194         require(_data.length == _amount.length);//same array sizes
195         for (uint i=0; i<_data.length; i++) { //It moves over the array
196             tokenReward.transfer(_data[i],_amount[i]);
197         }
198     }
199 
200     /**
201     * @notice Function to handle eth transfers
202     * @dev BEWARE: if a call to this functions doesn't have
203     * enought gas, transaction could not be finished
204     */
205 
206     function () public payable {
207         contribute();
208     }
209 }