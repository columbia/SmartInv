1 pragma solidity ^0.4.16;
2 /**
3 * @title ICO CONTRACT
4 * @dev ERC-20 Token Standard Compliant
5 * @author Fares A. Akel C.
6 */
7 
8 /**
9  * @title SafeMath by OpenZeppelin
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13 
14     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
15         uint256 c = a * b;
16         assert(a == 0 || c / a == b);
17         return c;
18     }
19 
20     function add(uint256 a, uint256 b) internal constant returns (uint256) {
21         uint256 c = a + b;
22         assert(c >= a);
23         return c;
24     }
25 
26 }
27 
28 contract token {
29 
30     mapping (address => uint256) public balanceOf;
31     function transfer(address _to, uint256 _value);
32 
33     }
34 
35 contract ICO {
36     using SafeMath for uint256;
37     //This ico have 2 stages
38     enum State {
39         Ongoin,
40         Successful
41     }
42     //public variables
43     State public state = State.Ongoin; //Set initial stage
44     uint256 public startTime = now; //block-time when it was deployed
45     //List of prices, as both, eth and token have 18 decimal, its a direct factor
46     uint256 public price = 1500; //1500 tokens per eth fixed
47     uint256 public totalRaised; //eth in wei
48     uint256 public totalDistributed; //tokens with decimals
49     uint256 public ICOdeadline; //deadline
50     uint256 public closedAt; //time when it finished
51     token public tokenReward; //token address used as reward
52     address public creator; //creator of the contract
53     address public beneficiary; //beneficiary of the contract
54     string public campaignUrl; //URL of the campaing
55     uint8 constant version = 1;
56 
57     //events for log
58     event LogFundingReceived(address _addr, uint _amount, uint _currentTotal);
59     event LogBeneficiaryPaid(address _beneficiaryAddress);
60     event LogFundingSuccessful(uint _totalRaised);
61     event LogFunderInitialized(
62         address _creator,
63         address _beneficiary,
64         string _url,
65         uint256 _ICOdeadline);
66     event LogContributorsPayout(address _addr, uint _amount);
67 
68     modifier notFinished() {
69         require(state != State.Successful);
70         _;
71     }
72 
73     /**
74     * @notice ICO constructor
75     * @param _campaignUrl is the ICO _url
76     * @param _addressOfTokenUsedAsReward is the token distributed
77     * @param _timeInDaysForICO is the days the campaing will last
78     */
79     function ICO (string _campaignUrl, token _addressOfTokenUsedAsReward, uint256 _timeInDaysForICO) public {
80         creator = msg.sender; //creator wallet address
81         beneficiary = msg.sender; //beneficiary wallet address
82         campaignUrl = _campaignUrl; //URL of the campaing
83         tokenReward = token(_addressOfTokenUsedAsReward); //token used as reward
84         ICOdeadline = startTime + _timeInDaysForICO * 1 days; //deadline is _timeInDaysForICO days from now
85 
86         //logs
87         LogFunderInitialized(
88             creator,
89             beneficiary,
90             campaignUrl,
91             ICOdeadline);
92     }
93 
94     /**
95     * @notice contribution handler
96     * @dev user must provide enough gas
97     */
98     function contribute() public notFinished payable {
99 
100         uint256 tokenBought;
101         totalRaised = totalRaised.add(msg.value); //increase raised counter
102         tokenBought = msg.value.mul(price); //calculate how much tokens will be sent
103         totalDistributed = totalDistributed.add(tokenBought); //increase distributed token counter
104         require(beneficiary.send(msg.value)); //transfer funds
105         tokenReward.transfer(msg.sender,tokenBought); //transfer tokens
106         
107         //logs
108         LogFundingReceived(msg.sender, msg.value, totalRaised);
109         LogContributorsPayout(msg.sender, tokenBought);
110         checkIfFundingCompleteOrExpired();
111 
112     }
113 
114     /**
115     * @notice check status
116     */
117     function checkIfFundingCompleteOrExpired() public {
118         
119         if(now > ICOdeadline && state!=State.Successful ) { //if we reach ico deadline and its not Successful yet
120             state = State.Successful; //ico becomes Successful
121             closedAt = now; //we complete now
122             
123             LogFundingSuccessful(totalRaised); //we log the finish
124             finished(); //and execute closure
125         }
126     }
127 
128    /**
129     * @notice closure handler
130     */
131     function finished() public { //When finished eth and tokens remaining are transfered to beneficiary
132         require(state == State.Successful); //only when Successful
133         require(beneficiary.send(this.balance)); //we require the transfer has been sent
134 
135         uint256 remaining = tokenReward.balanceOf(this); //get the total tokens remaining
136         tokenReward.transfer(beneficiary,remaining); //transfer remaining tokens to the beneficiary
137 
138         LogBeneficiaryPaid(beneficiary);
139     }
140 
141     /**
142     * @dev user must provide enough gas
143     */
144     function () public payable {
145         contribute(); //this function require more gas than a normal callback function, sender must provide it
146     }
147 }