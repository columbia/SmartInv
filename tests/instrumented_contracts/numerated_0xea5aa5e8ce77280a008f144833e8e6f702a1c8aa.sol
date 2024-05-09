1 pragma solidity ^0.4.16;
2 /**
3  * @title SafeMath by OpenZeppelin
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7 
8     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function add(uint256 a, uint256 b) internal constant returns (uint256) {
15         uint256 c = a + b;
16         assert(c >= a);
17         return c;
18     }
19 }
20 
21 contract token {
22 
23     function balanceOf(address _owner) public constant returns (uint256 balance);
24     function transfer(address _to, uint256 _value) public returns (bool success);
25 
26     }
27 
28 contract ICO {
29     using SafeMath for uint256;
30     //This ico have 3 stages
31     enum State {
32         Ongoin,
33         SoftCap,
34         Successful
35     }
36     //public variables
37     State public state = State.Ongoin; //Set initial stage
38     uint256 public startTime = now; //block-time when it was deployed
39     uint256 public delay;
40     //List of prices, as both, eth and token have 18 decimal, its a direct factor
41     uint[2] public tablePrices = [
42     2500, //for first 10million tokens
43     2000
44     ];
45     uint256 public SoftCap = 40000000 * (10 ** 18); //40 million tokens
46     uint256 public HardCap = 80000000 * (10 ** 18); //80 million tokens
47     uint256 public totalRaised; //eth in wei
48     uint256 public totalDistributed; //tokens
49     uint256 public ICOdeadline = startTime.add(21 days);//21 days deadline
50     uint256 public completedAt;
51     uint256 public closedAt;
52     token public tokenReward;
53     address public creator;
54     address public beneficiary;
55     string public campaignUrl;
56     uint8 constant version = 1;
57 
58     //events for log
59     event LogFundingReceived(address _addr, uint _amount, uint _currentTotal);
60     event LogBeneficiaryPaid(address _beneficiaryAddress);
61     event LogFundingSuccessful(uint _totalRaised);
62     event LogFunderInitialized(
63         address _creator,
64         address _beneficiary,
65         string _url,
66         uint256 _ICOdeadline);
67     event LogContributorsPayout(address _addr, uint _amount);
68 
69     modifier notFinished() {
70         require(state != State.Successful);
71         _;
72     }
73     /**
74     * @notice ICO constructor
75     * @param _campaignUrl is the ICO _url
76     * @param _addressOfTokenUsedAsReward is the token totalDistributed
77     */
78     function ICO (string _campaignUrl, token _addressOfTokenUsedAsReward, uint256 _delay) public {
79         creator = msg.sender;
80         beneficiary = msg.sender;
81         campaignUrl = _campaignUrl;
82         tokenReward = token(_addressOfTokenUsedAsReward);
83         delay = startTime.add(_delay * 1 hours);
84         LogFunderInitialized(
85             creator,
86             beneficiary,
87             campaignUrl,
88             ICOdeadline);
89     }
90 
91     /**
92     * @notice contribution handler
93     */
94     function contribute() public notFinished payable {
95         require(now > delay);
96         uint tokenBought;
97         totalRaised = totalRaised.add(msg.value);
98 
99         if(totalDistributed < 10000000 * (10 ** 18)){ //if on the first 10M
100             tokenBought = msg.value.mul(tablePrices[0]);
101         }
102         else {
103             tokenBought = msg.value.mul(tablePrices[1]);
104         }
105 
106         totalDistributed = totalDistributed.add(tokenBought);
107         tokenReward.transfer(msg.sender, tokenBought);
108         
109         LogFundingReceived(msg.sender, msg.value, totalRaised);
110         LogContributorsPayout(msg.sender, tokenBought);
111         
112         checkIfFundingCompleteOrExpired();
113     }
114 
115     /**
116     * @notice check status
117     */
118     function checkIfFundingCompleteOrExpired() public {
119         
120         if(now < ICOdeadline && state!=State.Successful){ //if we are on ICO period and its not Successful
121             if(state == State.Ongoin && totalRaised >= SoftCap){ //if we are Ongoin and we pass the SoftCap
122                 state = State.SoftCap; //We are on SoftCap state
123                 completedAt = now; //ICO is complete and will finish in 24h
124             }
125             else if (state == State.SoftCap && now > completedAt.add(24 hours)){ //if we are on SoftCap state and 24hrs have passed
126                 state == State.Successful; //the ico becomes Successful
127                 closedAt = now; //we finish now
128                 LogFundingSuccessful(totalRaised); //we log the finish
129                 finished(); //and execute closure
130             }
131         }
132         else if(now > ICOdeadline && state!=State.Successful ) { //if we reach ico deadline and its not Successful yet
133             state = State.Successful; //ico becomes Successful
134 
135             if(completedAt == 0){  //if not completed previously
136                 completedAt = now; //we complete now
137             }
138 
139             closedAt = now; //we finish now
140             LogFundingSuccessful(totalRaised); //we log the finish
141             finished(); //and execute closure
142         }
143     }
144 
145     function payOut() public {
146         require(msg.sender == beneficiary);
147         require(beneficiary.send(this.balance));
148         LogBeneficiaryPaid(beneficiary);
149     }
150 
151    /**
152     * @notice closure handler
153     */
154     function finished() public { //When finished eth are transfered to beneficiary
155         require(state == State.Successful);
156         uint256 remanent = tokenReward.balanceOf(this);
157 
158         require(beneficiary.send(this.balance));
159         tokenReward.transfer(beneficiary,remanent);
160 
161         LogBeneficiaryPaid(beneficiary);
162         LogContributorsPayout(beneficiary, remanent);
163     }
164 
165     function () public payable {
166         contribute();
167     }
168 }