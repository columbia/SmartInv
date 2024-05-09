1 pragma solidity 0.4.20;
2 /**
3 * @title ICO CONTRACT
4 * @dev ERC-20 Token Standard Compliant
5 * @author Fares A. Akel C. f.antonio.akel@gmail.com
6 */
7 
8 /**
9 * @title SafeMath by OpenZeppelin
10 * @dev Math operations with safety checks that throw on error
11 */
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
31 
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         assert(b <= a);
34         return a - b;
35     }
36 }
37 
38 contract token {
39 
40     function balanceOf(address _owner) public constant returns (uint256 balance);
41     function transfer(address _to, uint256 _value) public returns (bool success);
42 
43     }
44 
45 /**
46 * @title DateTime contract
47 * @dev This contract will return the unix value of any date
48 */
49 contract DateTimeAPI {
50         
51     function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour) constant returns (uint timestamp);
52 
53 }
54 
55 
56 contract ICO {
57     using SafeMath for uint256;
58     //This ico have 5 states
59     enum State {
60         stage1,
61         stage2,
62         stage3,
63         stage4,
64         Successful
65     }
66 
67     DateTimeAPI dateTimeContract = DateTimeAPI(0x1a6184CD4C5Bea62B0116de7962EE7315B7bcBce);//Main
68     //DateTimeAPI dateTimeContract = DateTimeAPI(0x1F0a2ba4B115bd3e4007533C52BBd30C17E8B222);//Ropsten
69 
70     //public variables
71     State public state = State.stage1; //Set initial stage
72     uint256 public startTime;
73     uint256 public rate;
74     uint256 public totalRaised; //eth in wei
75     uint256 public totalDistributed; //tokens
76     uint256 public ICOdeadline;
77     uint256 public completedAt;
78     token public tokenReward;
79     address public creator;
80     address public beneficiary;
81     string public version = '1';
82 
83     mapping(address => bool) public airdropClaimed;
84     mapping(address => uint) public icoTokensReceived;
85 
86     uint public constant TOKEN_SUPPLY_ICO   = 130000000 * 10 ** 18; // 130 Million tokens
87 
88     //events for log
89     event LogFundingReceived(address _addr, uint _amount, uint _currentTotal);
90     event LogBeneficiaryPaid(address _beneficiaryAddress);
91     event LogFundingSuccessful(uint _totalRaised);
92     event LogFunderInitialized(address _creator, uint256 _ICOdeadline);
93     event LogContributorsPayout(address _addr, uint _amount);
94 
95     modifier notFinished() {
96         require(state != State.Successful);
97         _;
98     }
99     /**
100     * @notice ICO constructor
101     * @param _addressOfTokenUsedAsReward is the token totalDistributed
102     */
103     function ICO (token _addressOfTokenUsedAsReward) public {
104         
105         startTime = dateTimeContract.toTimestamp(2018,3,2,12); //From March 2 12:00 UTC
106         ICOdeadline = dateTimeContract.toTimestamp(2018,3,30,12); //Till March 30 12:00 UTC;
107         rate = 80000; //Tokens per ether unit
108 
109         creator = msg.sender;
110         beneficiary = 0x3a1CE9289EC2826A69A115A6AAfC2fbaCc6F8063;
111         tokenReward = _addressOfTokenUsedAsReward;
112 
113         LogFunderInitialized(
114             creator,
115             ICOdeadline);
116     }
117 
118     /**
119     * @notice contribution handler
120     */
121     function contribute() public notFinished payable {
122         require(now >= startTime);
123         require(msg.value > 50 finney);
124 
125         uint256 tokenBought = 0;
126 
127         totalRaised = totalRaised.add(msg.value);
128         tokenBought = msg.value.mul(rate);
129 
130         //Rate of exchange depends on stage
131         if (state == State.stage1){
132 
133             tokenBought = tokenBought.mul(15);
134             tokenBought = tokenBought.div(10);//+50%
135         
136         } else if (state == State.stage2){
137         
138             tokenBought = tokenBought.mul(125);
139             tokenBought = tokenBought.div(100);//+25%
140         
141         } else if (state == State.stage3){
142         
143             tokenBought = tokenBought.mul(115);
144             tokenBought = tokenBought.div(100);//+15%
145         
146         }
147 
148         icoTokensReceived[msg.sender] = icoTokensReceived[msg.sender].add(tokenBought);
149         totalDistributed = totalDistributed.add(tokenBought);
150         
151         tokenReward.transfer(msg.sender, tokenBought);
152 
153         LogFundingReceived(msg.sender, msg.value, totalRaised);
154         LogContributorsPayout(msg.sender, tokenBought);
155         
156         checkIfFundingCompleteOrExpired();
157     }
158 
159     function claimAirdrop() external {
160 
161         doAirdrop(msg.sender);
162 
163     }
164 
165     function doAirdrop(address _participant) internal {
166         uint airdrop = computeAirdrop(_participant);
167 
168         require( airdrop > 0 );
169 
170         // update balances and token issue volume
171         airdropClaimed[_participant] = true;
172         tokenReward.transfer(_participant,airdrop);
173 
174         // log
175         LogContributorsPayout(_participant, airdrop);
176     }
177 
178     /* Function to estimate airdrop amount. For some accounts, the value of */
179     /* tokens received by calling claimAirdrop() may be less than gas costs */
180 
181     /* If an account has tokens from the ico, the amount after the airdrop */
182     /* will be newBalance = tokens * TOKEN_SUPPLY_ICO / totalDistributed */
183       
184     function computeAirdrop(address _participant) public constant returns (uint airdrop) {
185         require(state == State.Successful);
186 
187         // return  0 is the airdrop was already claimed
188         if( airdropClaimed[_participant] ) return 0;
189 
190         // return 0 if the account does not hold any crowdsale tokens
191         if( icoTokensReceived[_participant] == 0 ) return 0;
192 
193         // airdrop amount
194         uint tokens = icoTokensReceived[_participant];
195         uint newBalance = tokens.mul(TOKEN_SUPPLY_ICO) / totalDistributed;
196         airdrop = newBalance - tokens;
197     }
198 
199     /**
200     * @notice check status
201     */
202     function checkIfFundingCompleteOrExpired() public {
203 
204         if(state == State.stage1 && now > dateTimeContract.toTimestamp(2018,3,9,12)) { //Till March 9 12:00 UTC
205 
206             state = State.stage2;
207 
208         } else if(state == State.stage2 && now > dateTimeContract.toTimestamp(2018,3,16,12)) { //Till March 16 12:00 UTC
209 
210             state = State.stage3;
211             
212         } else if(state == State.stage3 && now > dateTimeContract.toTimestamp(2018,3,23,12)) { //From March 23 12:00 UTC
213 
214             state = State.stage4;
215             
216         } else if(now > ICOdeadline && state!=State.Successful) { //if we reach ico deadline and its not Successful yet
217 
218         state = State.Successful; //ico becomes Successful
219         completedAt = now; //ICO is complete
220 
221         LogFundingSuccessful(totalRaised); //we log the finish
222         finished(); //and execute closure
223 
224     }
225 }
226 
227     /**
228     * @notice closure handler
229     */
230     function finished() public { //When finished eth are transfered to beneficiary
231 
232         require(state == State.Successful);
233         require(beneficiary.send(this.balance));
234         LogBeneficiaryPaid(beneficiary);
235 
236     }
237 
238     /*
239     * @dev direct payments
240     */
241     function () public payable {
242         
243         contribute();
244 
245     }
246 }