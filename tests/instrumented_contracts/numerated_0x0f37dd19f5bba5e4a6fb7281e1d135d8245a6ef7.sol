1 pragma solidity 0.4.23;
2 /**
3 * @title IADOWR TGE CONTRACT
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
61 
62 }
63 
64 
65 /**
66 * @title DateTime contract
67 * @dev This contract will return the unix value of any date
68 */
69 contract DateTime {
70 
71     function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute) public constant returns (uint timestamp);
72 
73 }
74 
75 
76 /**
77  * @title manager
78  * @notice This contract have some manager-only functions
79  */
80 contract manager {
81     address public admin; //Admin address is public
82     
83     /**
84     * @dev This contructor takes the msg.sender as the first administer
85     */
86     constructor() internal {
87         admin = msg.sender; //Set initial admin to contract creator
88         emit Manager(admin);
89     }
90 
91     /**
92     * @dev This modifier limits function execution to the admin
93     */
94     modifier onlyAdmin() { //A modifier to define admin-only functions
95         require(msg.sender == admin);
96         _;
97     }
98 
99     /**
100     * @notice This function transfer the adminship of the contract to _newAdmin
101     * @param _newAdmin The new admin of the contract
102     */
103     function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered
104         admin = _newAdmin;
105         emit TransferAdminship(admin);
106     }
107 
108     /**
109     * @dev Log Events
110     */
111     event TransferAdminship(address newAdminister);
112     event Manager(address administer);
113 
114 }
115 
116 contract IADTGE is manager {
117 
118     using SafeMath for uint256;
119 
120     DateTime dateTimeContract = DateTime(0x1a6184CD4C5Bea62B0116de7962EE7315B7bcBce);//Main
121     
122     //This TGE contract have 2 states
123     enum State {
124         Ongoing,
125         Successful
126     }
127     //public variables
128     token public constant tokenReward = token(0xC1E2097d788d33701BA3Cc2773BF67155ec93FC4);
129     State public state = State.Ongoing; //Set initial stage
130     uint256 public startTime = dateTimeContract.toTimestamp(2018,4,30,7,0); //From Apr 30 00:00 (PST)
131     uint256 public deadline = dateTimeContract.toTimestamp(2018,5,31,6,59); //Until May 30 23:59 (PST)
132     uint256 public totalRaised; //eth in wei funded
133     uint256 public totalDistributed; //tokens distributed
134     uint256 public completedAt;
135     address public creator;
136     uint256[2] public rates = [6250,5556];//Base rate is 5000 IAD/ETH - 1st 15 days 20% discount/2nd 15 days 10% discount
137     string public version = '1';
138 
139     //events for log
140     event LogFundingReceived(address _addr, uint _amount, uint _currentTotal);
141     event LogBeneficiaryPaid(address _beneficiaryAddress);
142     event LogFundingSuccessful(uint _totalRaised);
143     event LogFunderInitialized(address _creator);
144     event LogContributorsPayout(address _addr, uint _amount);
145     
146     modifier notFinished() {
147         require(state != State.Successful);
148         _;
149     }
150 
151     /**
152     * @notice TGE constructor
153     */
154     constructor () public {
155         
156         creator = msg.sender;
157     
158         emit LogFunderInitialized(creator);
159     }
160 
161     /**
162     * @notice contribution handler
163     */
164     function contribute() public notFinished payable {
165         require(now >= startTime);
166         uint256 tokenBought;
167 
168         totalRaised = totalRaised.add(msg.value);
169 
170         if (now < startTime.add(15 days)){
171 
172             tokenBought = msg.value.mul(rates[0]);
173         
174         } else {
175 
176             tokenBought = msg.value.mul(rates[1]);
177         
178         }
179 
180         totalDistributed = totalDistributed.add(tokenBought);
181         
182         tokenReward.transfer(msg.sender, tokenBought);
183 
184         emit LogFundingReceived(msg.sender, msg.value, totalRaised);
185         emit LogContributorsPayout(msg.sender, tokenBought);
186         
187         checkIfFundingCompleteOrExpired();
188     }
189 
190     /**
191     * @notice check status
192     */
193     function checkIfFundingCompleteOrExpired() public {
194 
195         if(now > deadline){
196 
197             state = State.Successful; //TGE becomes Successful
198             completedAt = now; //TGE end time
199 
200             emit LogFundingSuccessful(totalRaised); //we log the finish
201             finished(); //and execute closure
202 
203         }
204     }
205 
206     /**
207     * @notice closure handler
208     */
209     function finished() public { //When finished eth and tremaining tokens are transfered to creator
210 
211         require(state == State.Successful);
212         uint256 remanent = tokenReward.balanceOf(this);
213 
214         require(creator.send(address(this).balance));
215         tokenReward.transfer(creator,remanent);
216 
217         emit LogBeneficiaryPaid(creator);
218         emit LogContributorsPayout(creator, remanent);
219 
220     }
221 
222     /**
223     * @notice Function to claim any token stuck on contract at any time
224     */
225     function claimTokens(token _address) onlyAdmin public{
226         require(state == State.Successful); //Only when sale finish
227 
228         uint256 remainder = _address.balanceOf(this); //Check remainder tokens
229         _address.transfer(admin,remainder); //Transfer tokens to admin
230         
231     }
232 
233     /*
234     * @dev direct payments handler
235     */
236 
237     function () public payable {
238         
239         contribute();
240 
241     }
242 }