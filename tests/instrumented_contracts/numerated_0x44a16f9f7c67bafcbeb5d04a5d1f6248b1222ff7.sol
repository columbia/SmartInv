1 pragma solidity ^0.4.18;
2 /**
3 * @title ICO CONTRACT
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
21         uint256 c = a / b;
22         return c;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 contract DateTime {
33 
34     function toTimestamp(uint16 year, uint8 month, uint8 day) constant returns (uint timestamp);
35 
36 }
37 
38 contract token {
39 
40     function balanceOf(address _owner) public constant returns (uint256 value);
41     function transfer(address _to, uint256 _value) public returns (bool success);
42 
43     }
44 
45 contract ICO {
46     using SafeMath for uint256;
47     //This ico have 5 states
48     enum State {
49         ico,
50         Successful
51     }
52     //public variables
53     State public state = State.ico; //Set initial stage
54     uint256 public startTime = now; //block-time when it was deployed
55     uint256 public rate = 1250;
56     uint256 public totalRaised; //eth in wei
57     uint256 public totalDistributed; //tokens
58     uint256 public ICOdeadline;
59     uint256 public completedAt;
60     token public tokenReward;
61     address public creator;
62     string public version = '1';
63 
64     DateTime dateTimeContract = DateTime(0x1a6184CD4C5Bea62B0116de7962EE7315B7bcBce);
65 
66     //events for log
67     event LogFundingReceived(address _addr, uint _amount, uint _currentTotal);
68     event LogBeneficiaryPaid(address _beneficiaryAddress);
69     event LogFundingSuccessful(uint _totalRaised);
70     event LogFunderInitialized(
71         address _creator,
72         uint256 _ICOdeadline);
73     event LogContributorsPayout(address _addr, uint _amount);
74 
75     modifier notFinished() {
76         require(state != State.Successful);
77         _;
78     }
79     /**
80     * @notice ICO constructor
81     * @param _addressOfTokenUsedAsReward is the token totalDistributed
82     */
83     function ICO (token _addressOfTokenUsedAsReward ) public {
84 
85         creator = msg.sender;
86         tokenReward = _addressOfTokenUsedAsReward;
87         ICOdeadline = dateTimeContract.toTimestamp(2018,5,15);
88 
89         LogFunderInitialized(
90             creator,
91             ICOdeadline);
92     }
93 
94     /**
95     * @notice contribution handler
96     */
97     function contribute() public notFinished payable {
98 
99         require(msg.value > (10**10));
100         
101         uint256 tokenBought = 0;
102 
103         totalRaised = totalRaised.add(msg.value);
104 
105         tokenBought = msg.value.div(10 ** 10);//token is 8 decimals, eth 18
106         tokenBought = tokenBought.mul(rate);
107 
108         //Bonuses depends on stage
109         if (now < dateTimeContract.toTimestamp(2018,2,15)){//presale
110 
111             tokenBought = tokenBought.mul(15);
112             tokenBought = tokenBought.div(10); //15/10 = 1.5 = 150%
113             require(totalDistributed.add(tokenBought) <= 100000000 * (10 ** 8));//presale limit
114         
115         } else if (now < dateTimeContract.toTimestamp(2018,2,28)){
116 
117             tokenBought = tokenBought.mul(14);
118             tokenBought = tokenBought.div(10); //14/10 = 1.4 = 140%
119         
120         } else if (now < dateTimeContract.toTimestamp(2018,3,15)){
121 
122             tokenBought = tokenBought.mul(13);
123             tokenBought = tokenBought.div(10); //13/10 = 1.3 = 130%
124         
125         } else if (now < dateTimeContract.toTimestamp(2018,3,31)){
126 
127             tokenBought = tokenBought.mul(12);
128             tokenBought = tokenBought.div(10); //12/10 = 1.2 = 120%
129         
130         } else if (now < dateTimeContract.toTimestamp(2018,4,30)){
131 
132             tokenBought = tokenBought.mul(11);
133             tokenBought = tokenBought.div(10); //11/10 = 1.1 = 110%
134         
135         } else if (now < dateTimeContract.toTimestamp(2018,5,15)){
136 
137             tokenBought = tokenBought.mul(105);
138             tokenBought = tokenBought.div(100); //105/10 = 1.05 = 105%
139         
140         }
141 
142         totalDistributed = totalDistributed.add(tokenBought);
143         
144         tokenReward.transfer(msg.sender, tokenBought);
145 
146         LogFundingReceived(msg.sender, msg.value, totalRaised);
147         LogContributorsPayout(msg.sender, tokenBought);
148         
149         checkIfFundingCompleteOrExpired();
150     }
151 
152     /**
153     * @notice check status
154     */
155     function checkIfFundingCompleteOrExpired() public {
156 
157         if(now > ICOdeadline && state!=State.Successful ) { //if we reach ico deadline and its not Successful yet
158 
159             state = State.Successful; //ico becomes Successful
160             completedAt = now; //ICO is complete
161 
162             LogFundingSuccessful(totalRaised); //we log the finish
163             finished(); //and execute closure
164         }
165     }
166 
167     /**
168     * @notice closure handler
169     */
170     function finished() public { //When finished eth are transfered to creator
171 
172         require(state == State.Successful);
173         uint256 remanent = tokenReward.balanceOf(this);
174 
175         require(creator.send(this.balance));
176         tokenReward.transfer(creator,remanent);
177 
178         LogBeneficiaryPaid(creator);
179         LogContributorsPayout(creator, remanent);
180 
181     }
182 
183     /*
184     * @dev Direct payments handle
185     */
186 
187     function () public payable {
188         
189         contribute();
190 
191     }
192 }