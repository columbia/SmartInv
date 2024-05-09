1 pragma solidity 0.4.24;
2 /**
3 * @title IADOWR Special Event Contract
4 * @dev ERC-20 Token Standard Compliant Contract
5 */
6 
7 /**
8  * @title SafeMath by OpenZeppelin
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12 
13   /**
14   * @dev Multiplies two numbers, throws on overflow.
15   */
16   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17     if (a == 0) {
18       return 0;
19     }
20     uint256 c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return c;
33   }
34 
35   /**
36   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256) {
47     uint256 c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 /**
54  * Token contract interface for external use
55  */
56 contract token {
57 
58     function balanceOf(address _owner) public constant returns (uint256 balance);
59     function transfer(address _to, uint256 _value) public;
60 
61 }
62 
63 
64 /**
65  * @title admined
66  * @notice This contract have some admin-only functions
67  */
68 contract admined {
69     mapping (address => uint8) public admin; //Admin address is public
70 
71     /**
72     * @dev This contructor takes the msg.sender as the first administer
73     */
74     constructor() internal {
75         admin[msg.sender] = 2; //Set initial master admin to contract creator
76         emit AssignAdminship(msg.sender, 2);
77     }
78 
79     /**
80     * @dev This modifier limits function execution to the admin
81     */
82     modifier onlyAdmin(uint8 _level) { //A modifier to define admin-only functions
83         require(admin[msg.sender] >= _level);
84         _;
85     }
86 
87     /**
88     * @notice This function transfer the adminship of the contract to _newAdmin
89     * @param _newAdmin User address
90     * @param _level User new level
91     */
92     function assingAdminship(address _newAdmin, uint8 _level) onlyAdmin(2) public { //Admin can be transfered
93         admin[_newAdmin] = _level;
94         emit AssignAdminship(_newAdmin , _level);
95     }
96 
97     /**
98     * @dev Log Events
99     */
100     event AssignAdminship(address newAdminister, uint8 level);
101 
102 }
103 
104 contract IADSpecialEvent is admined {
105 
106     using SafeMath for uint256;
107 
108     //This ico contract have 2 states
109     enum State {
110         Ongoing,
111         Successful
112     }
113     //public variables
114     token public constant tokenReward = token(0xC1E2097d788d33701BA3Cc2773BF67155ec93FC4);
115     State public state = State.Ongoing; //Set initial stage
116     uint256 public totalRaised; //eth in wei funded
117     uint256 public totalDistributed; //tokens distributed
118     uint256 public completedAt;
119     address public creator;
120     mapping (address => bool) whiteList;
121     uint256 public rate = 6250;//Base rate is 5000 IAD/ETH - It's a 25% bonus
122     string public version = '1';
123 
124     //events for log
125     event LogFundingReceived(address _addr, uint _amount, uint _currentTotal);
126     event LogBeneficiaryPaid(address _beneficiaryAddress);
127     event LogFundingSuccessful(uint _totalRaised);
128     event LogFunderInitialized(address _creator);
129     event LogContributorsPayout(address _addr, uint _amount);
130 
131     modifier notFinished() {
132         require(state != State.Successful);
133         _;
134     }
135 
136     /**
137     * @notice ICO constructor
138     */
139     constructor () public {
140 
141         creator = msg.sender;
142 
143         emit LogFunderInitialized(creator);
144     }
145 
146     /**
147     * @notice whiteList handler
148     */
149     function whitelistAddress(address _user, bool _flag) onlyAdmin(1) public {
150         whiteList[_user] = _flag;
151     }
152 
153     function checkWhitelist(address _user) onlyAdmin(1) public view returns (bool flag) {
154         return whiteList[_user];
155     }
156 
157     /**
158     * @notice contribution handler
159     */
160     function contribute() public notFinished payable {
161         //must be whitlisted
162         require(whiteList[msg.sender] == true);
163         //lets get the total purchase
164         uint256 tokenBought = msg.value.mul(rate);
165         //Minimum 150K tokenss
166         require(tokenBought >= 150000 * (10 ** 18));
167         //Keep track of total wei raised
168         totalRaised = totalRaised.add(msg.value);
169         //Keep track of total tokens distributed
170         totalDistributed = totalDistributed.add(tokenBought);
171         //Transfer the tokens
172         tokenReward.transfer(msg.sender, tokenBought);
173         //Logs
174         emit LogFundingReceived(msg.sender, msg.value, totalRaised);
175         emit LogContributorsPayout(msg.sender, tokenBought);
176     }
177 
178     /**
179     * @notice closure handler
180     */
181     function finish() onlyAdmin(2) public { //When finished eth and tremaining tokens are transfered to creator
182 
183         if(state != State.Successful){
184           state = State.Successful;
185           completedAt = now;
186         }
187 
188         uint256 remanent = tokenReward.balanceOf(this);
189         require(creator.send(address(this).balance));
190         tokenReward.transfer(creator,remanent);
191 
192         emit LogBeneficiaryPaid(creator);
193         emit LogContributorsPayout(creator, remanent);
194 
195     }
196 
197     function sendTokensManually(address _to, uint256 _amount) onlyAdmin(2) public {
198 
199         require(whiteList[_to] == true);
200         //Keep track of total tokens distributed
201         totalDistributed = totalDistributed.add(_amount);
202         //Transfer the tokens
203         tokenReward.transfer(_to, _amount);
204         //Logs
205         emit LogContributorsPayout(_to, _amount);
206 
207     }
208 
209     /**
210     * @notice Function to claim eth on contract
211     */
212     function claimETH() onlyAdmin(2) public{
213 
214         require(creator.send(address(this).balance));
215 
216         emit LogBeneficiaryPaid(creator);
217 
218     }
219 
220     /**
221     * @notice Function to claim any token stuck on contract at any time
222     */
223     function claimTokens(token _address) onlyAdmin(2) public{
224         require(state == State.Successful); //Only when sale finish
225 
226         uint256 remainder = _address.balanceOf(this); //Check remainder tokens
227         _address.transfer(msg.sender,remainder); //Transfer tokens to admin
228 
229     }
230 
231     /*
232     * @dev direct payments handler
233     */
234 
235     function () public payable {
236 
237         contribute();
238 
239     }
240 }