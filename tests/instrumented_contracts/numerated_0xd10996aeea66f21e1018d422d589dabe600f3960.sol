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
32 contract token {
33 
34     function balanceOf(address _owner) public constant returns (uint256 value);
35     function transfer(address _to, uint256 _value) public returns (bool success);
36 
37     }
38 
39 contract ICO {
40     using SafeMath for uint256;
41     //This ico have 5 states
42     enum State {
43         preico,
44         week1,
45         week2,
46         week3,
47         week4,
48         week5,
49         week6,
50         week7,
51         Successful
52     }
53     //public variables
54     State public state = State.preico; //Set initial stage
55     uint256 public startTime = now; //block-time when it was deployed
56     uint256 public rate;
57     uint256 public totalRaised; //eth in wei
58     uint256 public totalDistributed; //tokens
59     uint256 public totalContributors;
60     uint256 public ICOdeadline;
61     uint256 public completedAt;
62     token public tokenReward;
63     address public creator;
64     string public campaignUrl;
65     string public version = '1';
66 
67     //events for log
68     event LogFundingReceived(address _addr, uint _amount, uint _currentTotal);
69     event LogBeneficiaryPaid(address _beneficiaryAddress);
70     event LogFundingSuccessful(uint _totalRaised);
71     event LogFunderInitialized(
72         address _creator,
73         string _url,
74         uint256 _ICOdeadline);
75     event LogContributorsPayout(address _addr, uint _amount);
76 
77     modifier notFinished() {
78         require(state != State.Successful);
79         _;
80     }
81     /**
82     * @notice ICO constructor
83     * @param _campaignUrl is the ICO _url
84     * @param _addressOfTokenUsedAsReward is the token totalDistributed
85     */
86     function ICO (
87         string _campaignUrl,
88         token _addressOfTokenUsedAsReward) public {
89         require(_addressOfTokenUsedAsReward!=address(0));
90 
91         creator = msg.sender;
92         campaignUrl = _campaignUrl;
93         tokenReward = _addressOfTokenUsedAsReward;
94         rate = 3214;
95         ICOdeadline = startTime.add(64 days); //9 weeks
96 
97         LogFunderInitialized(
98             creator,
99             campaignUrl,
100             ICOdeadline);
101     }
102 
103     /**
104     * @notice contribution handler
105     */
106     function contribute() public notFinished payable {
107 
108         uint256 tokenBought = 0;
109 
110         totalRaised = totalRaised.add(msg.value);
111         totalContributors = totalContributors.add(1);
112 
113         tokenBought = msg.value.mul(rate);
114 
115         //Rate of exchange depends on stage
116         if (state == State.preico){
117 
118             tokenBought = tokenBought.mul(14);
119             tokenBought = tokenBought.mul(10); //14/10 = 1.4 = 140%
120         
121         } else if (state == State.week1){
122 
123             tokenBought = tokenBought.mul(13);
124             tokenBought = tokenBought.mul(10); //13/10 = 1.3 = 130%
125 
126         } else if (state == State.week2){
127 
128             tokenBought = tokenBought.mul(125);
129             tokenBought = tokenBought.mul(100); //125/100 = 1.25 = 125%
130 
131         } else if (state == State.week3){
132 
133             tokenBought = tokenBought.mul(12);
134             tokenBought = tokenBought.mul(10); //12/10 = 1.2 = 120%
135 
136         } else if (state == State.week4){
137 
138             tokenBought = tokenBought.mul(115);
139             tokenBought = tokenBought.mul(100); //115/100 = 1.15 = 115%
140 
141         } else if (state == State.week5){
142 
143             tokenBought = tokenBought.mul(11);
144             tokenBought = tokenBought.mul(10); //11/10 = 1.10 = 110%
145 
146         } else if (state == State.week6){
147 
148             tokenBought = tokenBought.mul(105);
149             tokenBought = tokenBought.mul(100); //105/100 = 1.05 = 105%
150 
151         }
152 
153         totalDistributed = totalDistributed.add(tokenBought);
154         
155         require(creator.send(msg.value));
156         tokenReward.transfer(msg.sender, tokenBought);
157 
158         LogFundingReceived(msg.sender, msg.value, totalRaised);
159         LogContributorsPayout(msg.sender, tokenBought);
160         
161         checkIfFundingCompleteOrExpired();
162     }
163 
164     /**
165     * @notice check status
166     */
167     function checkIfFundingCompleteOrExpired() public {
168 
169         if(state == State.preico && now > startTime.add(15 days)){
170 
171             state = State.week1;
172 
173         } else if(state == State.week1 && now > startTime.add(22 days)){
174 
175             state = State.week2;
176             
177         } else if(state == State.week2 && now > startTime.add(29 days)){
178 
179             state = State.week3;
180             
181         } else if(state == State.week3 && now > startTime.add(36 days)){
182 
183             state = State.week4;
184             
185         } else if(state == State.week4 && now > startTime.add(43 days)){
186 
187             state = State.week5;
188             
189         } else if(state == State.week5 && now > startTime.add(50 days)){
190 
191             state = State.week6;
192             
193         } else if(state == State.week6 && now > startTime.add(57 days)){
194 
195             state = State.week7;
196             
197         } else if(now > ICOdeadline && state!=State.Successful ) { //if we reach ico deadline and its not Successful yet
198 
199             state = State.Successful; //ico becomes Successful
200             completedAt = now; //ICO is complete
201 
202             LogFundingSuccessful(totalRaised); //we log the finish
203             finished(); //and execute closure
204         }
205     }
206 
207     /**
208     * @notice closure handler
209     */
210     function finished() public { //When finished eth are transfered to creator
211 
212         require(state == State.Successful);
213         uint256 remanent = tokenReward.balanceOf(this);
214 
215         tokenReward.transfer(creator,remanent);
216 
217         LogBeneficiaryPaid(creator);
218         LogContributorsPayout(creator, remanent);
219 
220     }
221 
222     /*
223     * @dev Direct payments handle
224     */
225 
226     function () public payable {
227         
228         contribute();
229 
230     }
231 }