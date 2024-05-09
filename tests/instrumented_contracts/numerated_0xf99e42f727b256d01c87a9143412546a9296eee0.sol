1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 /**
32  * @title Ownable
33  * @dev The Ownable contract has an owner address, and provides basic authorization control
34  * functions, this simplifies the implementation of "user permissions".
35  */
36 contract Ownable {
37   address public owner;
38 
39 
40   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42 
43   /**
44    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
45    * account.
46    */
47   function Ownable() public {
48     owner = msg.sender;
49   }
50 
51 
52   /**
53    * @dev Throws if called by any account other than the owner.
54    */
55   modifier onlyOwner() {
56     require(msg.sender == owner);
57     _;
58   }
59 
60 
61   /**
62    * @dev Allows the current owner to transfer control of the contract to a newOwner.
63    * @param newOwner The address to transfer ownership to.
64    */
65   function transferOwnership(address newOwner) public onlyOwner {
66     require(newOwner != address(0));
67     OwnershipTransferred(owner, newOwner);
68     owner = newOwner;
69   }
70 
71 }
72 
73 
74 contract Pausable is Ownable {
75   event Pause();
76   event Unpause();
77 
78   bool public paused = false;
79 
80 
81   /**
82    * @dev Modifier to make a function callable only when the contract is not paused.
83    */
84   modifier whenNotPaused() {
85     require(!paused);
86     _;
87   }
88 
89   /**
90    * @dev Modifier to make a function callable only when the contract is paused.
91    */
92   modifier whenPaused() {
93     require(paused);
94     _;
95   }
96 
97   /**
98    * @dev called by the owner to pause, triggers stopped state
99    */
100   function pause() onlyOwner whenNotPaused public {
101     paused = true;
102     Pause();
103   }
104 
105   /**
106    * @dev called by the owner to unpause, returns to normal state
107    */
108   function unpause() onlyOwner whenPaused public {
109     paused = false;
110     Unpause();
111   }
112 }
113 
114 contract Lending is Ownable, Pausable {
115     using SafeMath for uint256;
116     uint256 public minContribAmount = 0.1 ether;                          // 0.01 ether
117     enum LendingState {AcceptingContributions, AwaitingReturn, ProjectNotFunded, ContributionReturned}
118 
119     mapping(address => Investor) public investors;
120     uint256 public fundingStartTime;                                     // Start time of contribution period in UNIX time
121     uint256 public fundingEndTime;                                       // End time of contribution period in UNIX time
122     uint256 public totalContributed;
123     bool public capReached;
124     LendingState public state;
125     address[] public investorsKeys;
126 
127     uint256 public lendingInterestRatePercentage;
128     uint256 public totalLendingAmount;
129     uint256 public lendingDays;
130     uint256 public initialFiatPerEthRate;
131     uint256 public totalLendingFiatAmount;
132     address public borrower;
133     uint256 public borrowerReturnDate;
134     uint256 public borrowerReturnFiatAmount;
135     uint256 public borrowerReturnFiatPerEthRate;
136     uint256 public borrowerReturnAmount;
137 
138     struct Investor {
139         uint amount;
140         bool isCompensated;
141     }
142 
143     // events
144     event onCapReached(uint endTime);
145     event onContribution(uint totalContributed, address indexed investor, uint amount, uint investorsCount);
146     event onCompensated(address indexed contributor, uint amount);
147     event excessContributionReturned(address indexed contributor, uint amount);
148     event StateChange(uint state);
149 
150     function Lending(uint _fundingStartTime, uint _fundingEndTime, address _borrower, uint _lendingInterestRatePercentage, uint _totalLendingAmount, uint256 _lendingDays) public {
151         fundingStartTime = _fundingStartTime;
152         fundingEndTime = _fundingEndTime;
153         borrower = _borrower;
154         // 115
155         lendingInterestRatePercentage = _lendingInterestRatePercentage;
156         totalLendingAmount = _totalLendingAmount;
157         //90 days for version 0.1
158         lendingDays = _lendingDays;
159         state = LendingState.AcceptingContributions;
160         StateChange(uint(state));
161     }
162 
163     function() public payable whenNotPaused {
164         if(state == LendingState.AwaitingReturn){
165             returnBorroweedEth();
166         } else{
167             contributeWithAddress(msg.sender);
168         }
169     }
170 
171     function isContribPeriodRunning() public constant returns(bool){
172         return fundingStartTime <= now && fundingEndTime > now && !capReached;
173     }
174 
175     // @notice Function to participate in contribution period
176     //  Amounts from the same address should be added up
177     //  If cap is reached, end time should be modified
178     //  Funds should be transferred into multisig wallet
179     // @param contributor Address
180     function contributeWithAddress(address contributor) public payable whenNotPaused {
181         require(msg.value >= minContribAmount);
182         require(isContribPeriodRunning());
183 
184         uint contribValue = msg.value;
185         uint excessContribValue = 0;
186 
187         uint oldTotalContributed = totalContributed;
188 
189         totalContributed = oldTotalContributed.add(contribValue);
190 
191         uint newTotalContributed = totalContributed;
192 
193         // cap was reached
194         if (newTotalContributed >=  totalLendingAmount &&
195             oldTotalContributed < totalLendingAmount)
196         {
197             capReached = true;
198             fundingEndTime = now;
199             onCapReached(fundingEndTime);
200 
201             // Everything above hard cap will be sent back to contributor
202             excessContribValue = newTotalContributed.sub(totalLendingAmount);
203             contribValue = contribValue.sub(excessContribValue);
204 
205             totalContributed = totalLendingAmount;
206         }
207 
208         if (investors[contributor].amount == 0) {
209             investorsKeys.push(contributor);
210         }
211 
212         investors[contributor].amount = investors[contributor].amount.add(contribValue);
213 
214         if (excessContribValue > 0) {
215             msg.sender.transfer(excessContribValue);
216             excessContributionReturned(msg.sender, excessContribValue);
217         }
218         onContribution(newTotalContributed, contributor, contribValue, investorsKeys.length);
219     }
220 
221     function enableReturnContribution() external onlyOwner {
222         require(totalContributed < totalLendingAmount);
223         require(now > fundingEndTime);
224         state = LendingState.ProjectNotFunded;
225         StateChange(uint(state));
226     }
227 
228     // @notice Function to participate in contribution period
229     //  Amounts from the same address should be added up
230     //  If cap is reached, end time should be modified
231     //  Funds should be transferred into multisig wallet
232     // @param contributor Address
233     function finishContributionPeriod(uint256 _initialFiatPerEthRate) onlyOwner {
234         require(capReached == true);
235         initialFiatPerEthRate = _initialFiatPerEthRate;
236         borrower.transfer(totalContributed);
237         state = LendingState.AwaitingReturn;
238         StateChange(uint(state));
239         totalLendingFiatAmount = totalLendingAmount.mul(initialFiatPerEthRate);
240         borrowerReturnFiatAmount = totalLendingFiatAmount.mul(lendingInterestRatePercentage).div(100);
241     }
242 
243     function reclaimContribution(address beneficiary) external {
244         require(state == LendingState.ProjectNotFunded);
245         uint contribution = investors[beneficiary].amount;
246         require(contribution > 0);
247         beneficiary.transfer(contribution);
248     }
249 
250     function establishBorrowerReturnFiatPerEthRate(uint256 _borrowerReturnFiatPerEthRate) external onlyOwner{
251         require(state == LendingState.AwaitingReturn);
252         borrowerReturnFiatPerEthRate = _borrowerReturnFiatPerEthRate;
253         borrowerReturnAmount = borrowerReturnFiatAmount.div(borrowerReturnFiatPerEthRate);
254     }
255 
256     function returnBorroweedEth() payable public {
257         require(state == LendingState.AwaitingReturn);
258         require(borrowerReturnFiatPerEthRate > 0);
259         require(msg.value == borrowerReturnAmount);
260         state = LendingState.ContributionReturned;
261         StateChange(uint(state));
262     }
263 
264     function reclaimContributionWithInterest(address beneficiary) external {
265         require(state == LendingState.ContributionReturned);
266         uint contribution = investors[beneficiary].amount.mul(initialFiatPerEthRate).mul(lendingInterestRatePercentage).div(borrowerReturnFiatPerEthRate).div(100);
267         require(contribution > 0);
268         beneficiary.transfer(contribution);
269     }
270 
271     function selfKill() external onlyOwner {
272         selfdestruct(owner);
273     }
274 }