1 pragma solidity ^0.4.16;
2 /*
3 PAXCHANGE ICO Contract
4 
5 PAXCHANGE TOKEN is an ERC-20 Token Standar Compliant
6 
7 Contract developer: Fares A. Akel C.
8 f.antonio.akel@gmail.com
9 MIT PGP KEY ID: 078E41CB
10 */
11 
12 /**
13  * @title SafeMath by OpenZeppelin
14  * @dev Math operations with safety checks that throw on error
15  */
16 library SafeMath {
17 
18     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19         uint256 c = a * b;
20         assert(a == 0 || c / a == b);
21         return c;
22     }
23 
24     function add(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a + b;
26         assert(c >= a);
27         return c;
28     }
29 }
30 
31 /**
32 * Token interface definition
33 */
34 contract ERC20Token {
35 
36     function transfer(address _to, uint256 _value) public returns (bool success); //transfer function to let the contract move own tokens
37     function balanceOf(address _owner) public constant returns (uint256 balance); //Function to check an address balance
38     
39                 }
40 
41 contract PAXCHANGEICO {
42     using SafeMath for uint256;
43     /**
44     * This ICO have 3 states 0:PreSale 1:ICO 2:Successful
45     */
46     enum State {
47         PreSale,
48         ICO,
49         Successful
50     }
51     /**
52     * Variables definition - Public
53     */
54     State public state = State.PreSale; //Set initial stage
55     uint256 public startTime = now; //block-time when it was deployed
56     uint256 public totalRaised;
57     uint256 public currentBalance;
58     uint256 public preSaledeadline;
59     uint256 public ICOdeadline;
60     uint256 public completedAt;
61     ERC20Token public tokenReward;
62     address public creator;
63     string public campaignUrl;
64     uint256 public constant version = 1;
65     uint256[4] public prices = [
66     7800, // 1 eth~=300$ 1 PAXCHANGE = 0.05$ + 30% bonus => 1eth = 7800 PAXCHANGE
67     7200, // 1 eth~=300$ 1 PAXCHANGE = 0.05$ + 20% bonus => 1eth = 7200 PAXCHANGE
68     6600, // 1 eth~=300$ 1 PAXCHANGE = 0.05$ + 10% bonus => 1eth = 6600 PAXCHANGE
69     3000  // 1 eth~=300$ 1 PAXCHANGE = 0.1$ => 1eth = 3000 PAXCHANGE
70     ];
71     /**
72     *Log Events
73     */
74     event LogFundingReceived(address _addr, uint _amount, uint _currentTotal);
75     event LogBeneficiaryPaid(address _beneficiaryAddress);
76     event LogFundingSuccessful(uint _totalRaised);
77     event LogICOInitialized(
78         address _creator,
79         string _url,
80         uint256 _PreSaledeadline,
81         uint256 _ICOdeadline);
82     event LogContributorsPayout(address _addr, uint _amount);
83     /**
84     *Modifier to require the ICO is on going
85     */
86     modifier notFinished() {
87         require(state != State.Successful);
88         _;
89     }
90     /**
91     *Constructor
92     */
93     function PAXCHANGEICO (
94         string _campaignUrl,
95         ERC20Token _addressOfTokenUsedAsReward)
96         public
97     {
98         creator = msg.sender;
99         campaignUrl = _campaignUrl;
100         preSaledeadline = startTime.add(3 weeks);
101         ICOdeadline = preSaledeadline.add(3 weeks);
102         currentBalance = 0;
103         tokenReward = ERC20Token(_addressOfTokenUsedAsReward);
104         LogICOInitialized(
105             creator,
106             campaignUrl,
107             preSaledeadline,
108             ICOdeadline);
109     }
110     /**
111     *@dev Function to contribute to the ICO
112     *Its check first if ICO is ongoin
113     *so no one can transfer to it after finished
114     */
115     function contribute() public notFinished payable {
116 
117         uint256 tokenBought;
118         totalRaised = totalRaised.add(msg.value);
119         currentBalance = totalRaised;
120 
121         if (state == State.PreSale && now < startTime + 1 weeks){ //if we are on the first week of the presale
122             tokenBought = uint256(msg.value).mul(prices[0]);
123             if (totalRaised.add(tokenBought) > 10000000 * (10**18)){
124                 revert();
125             }
126         }
127         else if (state == State.PreSale && now < startTime + 2 weeks){ //if we are on the second week of the presale
128             tokenBought = uint256(msg.value).mul(prices[1]);
129             if (totalRaised.add(tokenBought) > 10000000 * (10**18)){
130                 revert();
131             }
132         }
133         else if (state == State.PreSale && now < startTime + 3 weeks){ //if we are on the third week of the presale
134             tokenBought = uint256(msg.value).mul(prices[2]);
135             if (totalRaised.add(tokenBought) > 10000000 * (10**18)){
136                 revert();
137             }
138         }
139         else if (state == State.ICO) { //if we are on the ICO period
140             tokenBought = uint256(msg.value).mul(prices[3]);
141         }
142         else {revert();}
143 
144         tokenReward.transfer(msg.sender, tokenBought);
145         
146         LogFundingReceived(msg.sender, msg.value, totalRaised);
147         LogContributorsPayout(msg.sender, tokenBought);
148         
149         checkIfFundingCompleteOrExpired();
150     }
151     /**
152     *@dev Function to check if ICO if finished
153     */
154     function checkIfFundingCompleteOrExpired() public {
155         
156         if(now > preSaledeadline && now < ICOdeadline){
157             state = State.ICO;
158         }
159         else if(now > ICOdeadline && state==State.ICO){
160             state = State.Successful;
161             completedAt = now;
162             LogFundingSuccessful(totalRaised);
163             finished();  
164         }
165     }
166     /**
167     *@dev Function to do final transactions
168     *When finished eth and remaining tokens are transfered to creator
169     */
170     function finished() public {
171         require(state == State.Successful);
172         
173         uint remanent;
174         remanent =  tokenReward.balanceOf(this);
175         currentBalance = 0;
176         
177         tokenReward.transfer(creator,remanent);
178         require(creator.send(this.balance));
179 
180         LogBeneficiaryPaid(creator);
181         LogContributorsPayout(creator, remanent);
182     }
183     /**
184     *@dev Function to handle eth transfers
185     *For security it require a minimun value
186     *BEWARE: if a call to this functions doesnt have
187     *enought gas transaction could not be finished
188     */
189     function () public payable {
190         require(msg.value > 1 finney);
191         contribute();
192     }
193 }