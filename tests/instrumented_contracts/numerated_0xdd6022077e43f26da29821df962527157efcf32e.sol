1 pragma solidity ^0.4.18;
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
31 }
32 
33 contract token {
34 
35     function balanceOf(address _owner) public constant returns (uint256 balance);
36     function transfer(address _to, uint256 _value) public returns (bool success);
37 
38     }
39 
40 contract ICO {
41     using SafeMath for uint256;
42     //This ico have 4 stages
43     enum State {
44         EarlyPreSale,
45         PreSale,
46         Crowdsale,
47         Successful
48     }
49     //public variables
50     State public state = State.EarlyPreSale; //Set initial stage
51     uint256 public startTime = now; //block-time when it was deployed
52     uint256[2] public price = [6667,5000]; //Price rates for base calculation
53     uint256 public totalRaised; //eth in wei
54     uint256 public totalDistributed; //tokens distributed
55     uint256 public stageDistributed; //tokens distributed on the actual stage
56     uint256 public completedAt; //Time stamp when the ico finish
57     token public tokenReward; //Address of the valit token used as reward
58     address public creator; //Address of the contract deployer
59     string public campaignUrl; //Web site of the campaing
60     string public version = '1';
61 
62     //events for log
63     event LogFundingReceived(address _addr, uint _amount, uint _currentTotal);
64     event LogBeneficiaryPaid(address _beneficiaryAddress);
65     event LogFundingSuccessful(uint _totalRaised);
66     event LogFunderInitialized(
67         address _creator,
68         string _url);
69     event LogContributorsPayout(address _addr, uint _amount);
70     event StageDistributed(State _stage, uint256 _stageDistributed);
71 
72     modifier notFinished() {
73         require(state != State.Successful);
74         _;
75     }
76     /**
77     * @notice ICO constructor
78     * @param _campaignUrl is the ICO _url
79     * @param _addressOfTokenUsedAsReward is the token totalDistributed
80     */
81     function ICO (string _campaignUrl, token _addressOfTokenUsedAsReward) public {
82         creator = msg.sender;
83         campaignUrl = _campaignUrl;
84         tokenReward = token(_addressOfTokenUsedAsReward);
85 
86         LogFunderInitialized(
87             creator,
88             campaignUrl
89             );
90     }
91 
92     /**
93     * @notice contribution handler
94     */
95     function contribute() public notFinished payable {
96 
97         require(msg.value >= 100 finney);
98 
99         uint256 tokenBought; //Variable to store amount of tokens bought
100         totalRaised = totalRaised.add(msg.value); //Save the total eth totalRaised (in wei)
101 
102         if (state == State.EarlyPreSale){
103 
104             tokenBought = msg.value.mul(price[0]); //Base price rate
105             tokenBought = tokenBought.mul(12); // 12/10 = 1.2
106             tokenBought = tokenBought.div(10); // 1.2 => 100% + 20% Bonus               
107             
108             require(stageDistributed.add(tokenBought) <= 60000000 * (10 ** 18)); //Cannot exceed 60.000.000 distributed
109 
110         } else if (state == State.PreSale){
111 
112             tokenBought = msg.value.mul(price[0]); //Base price rate
113             tokenBought = tokenBought.mul(11); // 11/10 = 1.1
114             tokenBought = tokenBought.div(10); // 1.1 => 100% + 10% Bonus               
115             
116             require(stageDistributed.add(tokenBought) <= 60000000 * (10 ** 18)); //Cannot exceed 60.000.000 distributed
117 
118         } else if (state == State.Crowdsale){
119 
120             tokenBought = msg.value.mul(price[1]); //Base price rate
121 
122             require(stageDistributed.add(tokenBought) <= 80000000 * (10 ** 18)); //Cannot exceed 80.000.000 distributed
123 
124         }
125 
126         totalDistributed = totalDistributed.add(tokenBought);
127         stageDistributed = stageDistributed.add(tokenBought);
128         
129         tokenReward.transfer(msg.sender, tokenBought);
130         
131         LogFundingReceived(msg.sender, msg.value, totalRaised);
132         LogContributorsPayout(msg.sender, tokenBought);
133         
134         checkIfFundingCompleteOrExpired();
135     }
136 
137     /**
138     * @notice check status
139     */
140     function checkIfFundingCompleteOrExpired() public {
141         
142         if(state!=State.Successful){ //if we are on ICO period and its not Successful
143             
144             if(state == State.EarlyPreSale && now > startTime.add(8 days)){
145 
146                 StageDistributed(state,stageDistributed);
147 
148                 state = State.PreSale;
149                 stageDistributed = 0;
150             
151             } else if(state == State.PreSale && now > startTime.add(15 days)){
152 
153                 StageDistributed(state,stageDistributed);
154 
155                 state = State.Crowdsale;
156                 stageDistributed = 0;
157 
158             } else if(state == State.Crowdsale && now > startTime.add(36 days)){
159 
160                 StageDistributed(state,stageDistributed);
161 
162                 state = State.Successful; //ico becomes Successful
163                 completedAt = now; //ICO is complete
164                 LogFundingSuccessful(totalRaised); //we log the finish
165                 finished(); //and execute closure
166             
167             }
168         }
169     }
170 
171     /**
172     * @notice closure handler
173     */
174     function finished() public { //When finished eth are transfered to creator
175         require(state == State.Successful);
176         uint256 remanent = tokenReward.balanceOf(this);
177 
178         require(creator.send(this.balance));
179         tokenReward.transfer(creator,remanent);
180 
181         LogBeneficiaryPaid(creator);
182         LogContributorsPayout(creator, remanent);
183     }
184 
185     /**
186     * @notice Function to handle eth transfers
187     * @dev BEWARE: if a call to this functions doesn't have
188     * enought gas, transaction could not be finished
189     */
190 
191     function () public payable {
192         contribute();
193     }
194 }