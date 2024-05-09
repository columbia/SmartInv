1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 pragma solidity ^0.4.11;
33 
34 contract StakeTreeMVP {
35   using SafeMath for uint256;
36 
37   uint public version = 1;
38 
39   struct Funder {
40     bool exists;
41     uint balance;
42     uint withdrawalEntry;
43   }
44   mapping(address => Funder) public funders;
45 
46   bool public live = true; // For sunsetting contract
47   uint public totalCurrentFunders = 0; // Keeps track of total funders
48   uint public withdrawalCounter = 0; // Keeps track of how many withdrawals have taken place
49   uint public sunsetWithdrawDate;
50  
51   address public beneficiary; // Address for beneficiary
52   uint public sunsetWithdrawalPeriod; // How long it takes for beneficiary to swipe contract when put into sunset mode
53   uint public withdrawalPeriod; // How long the beneficiary has to wait withdraw
54   uint public minimumFundingAmount; // Setting used for setting minimum amounts to fund contract with
55   uint public lastWithdrawal; // Last withdrawal time
56   uint public nextWithdrawal; // Next withdrawal time
57 
58   uint public contractStartTime; // For accounting purposes
59 
60   function StakeTreeMVP(
61     address beneficiaryAddress, 
62     uint withdrawalPeriodInit, 
63     uint withdrawalStart, 
64     uint sunsetWithdrawPeriodInit,
65     uint minimumFundingAmountInit) {
66 
67     beneficiary = beneficiaryAddress;
68     withdrawalPeriod = withdrawalPeriodInit;
69     sunsetWithdrawalPeriod = sunsetWithdrawPeriodInit;
70 
71     lastWithdrawal = withdrawalStart; 
72     nextWithdrawal = lastWithdrawal + withdrawalPeriod;
73 
74     minimumFundingAmount = minimumFundingAmountInit;
75 
76     contractStartTime = now;
77   }
78 
79   // Modifiers
80   modifier onlyByBeneficiary() {
81     require(msg.sender == beneficiary);
82     _;
83   }
84 
85   modifier onlyByFunder() {
86     require(isFunder(msg.sender));
87     _;
88   }
89 
90   modifier onlyAfterNextWithdrawalDate() {
91     require(now >= nextWithdrawal);
92     _;
93   }
94 
95   modifier onlyWhenLive() {
96     require(live);
97     _;
98   }
99 
100   modifier onlyWhenSunset() {
101     require(!live);
102     _;
103   }
104 
105   /*
106   * External accounts can pay directly to contract to fund it.
107   */
108   function () payable {
109     fund();
110   }
111 
112   /*
113   * Additional api for contracts to use as well
114   * Can only happen when live and over a minimum amount set by the beneficiary
115   */
116 
117   function fund() public payable onlyWhenLive {
118     require(msg.value >= minimumFundingAmount);
119 
120     // Only increase total funders when we have a new funder
121     if(!isFunder(msg.sender)) {
122       totalCurrentFunders = totalCurrentFunders.add(1); // Increase total funder count
123 
124       funders[msg.sender] = Funder({
125         exists: true,
126         balance: msg.value,
127         withdrawalEntry: withdrawalCounter // Set the withdrawal counter. Ie at which withdrawal the funder "entered" the patronage contract
128       });
129     }
130     else {
131       // If the funder is already in the pool let's update things while we're at it
132       // This calculates their actual balance left and adds their top up amount
133       funders[msg.sender].balance = getRefundAmountForFunder(msg.sender).add(msg.value);
134       // Reset withdrawal counter
135       funders[msg.sender].withdrawalEntry = withdrawalCounter;
136     }
137   }
138 
139   // Pure functions
140 
141   /*
142   * This function calculates how much the beneficiary can withdraw.
143   * Due to no floating points in Solidity, we will lose some fidelity
144   * if there's wei on the last digit. The beneficiary loses a neglibible amount
145   * to withdraw but this benefits the beneficiary again on later withdrawals.
146   * We multiply by 10 (which corresponds to the 10%) 
147   * then divide by 100 to get the actual part.
148   */
149   function calculateWithdrawalAmount(uint startAmount) public returns (uint){
150     return startAmount.mul(10).div(100); // 10%
151   }
152 
153   /*
154   * This function calculates the refund amount for the funder.
155   * Due to no floating points in Solidity, we will lose some fidelity.
156   * The funder loses a neglibible amount to refund. 
157   * The left over wei gets pooled to the fund.
158   */
159   function calculateRefundAmount(uint amount, uint withdrawalTimes) public returns (uint) {    
160     for(uint i=0; i<withdrawalTimes; i++){
161       amount = amount.mul(9).div(10);
162     }
163     return amount;
164   }
165 
166   // Getter functions
167 
168   /*
169   * To calculate the refund amount we look at how many times the beneficiary
170   * has withdrawn since the funder added their funds. 
171   * We use that deduct 10% for each withdrawal.
172   */
173 
174   function getRefundAmountForFunder(address addr) public constant returns (uint) {
175     uint amount = funders[addr].balance;
176     uint withdrawalTimes = getHowManyWithdrawalsForFunder(addr);
177     return calculateRefundAmount(amount, withdrawalTimes);
178   }
179 
180   function getBeneficiary() public constant returns (address) {
181     return beneficiary;
182   }
183 
184   function getCurrentTotalFunders() public constant returns (uint) {
185     return totalCurrentFunders;
186   }
187 
188   function getWithdrawalCounter() public constant returns (uint) {
189     return withdrawalCounter;
190   }
191 
192   function getWithdrawalEntryForFunder(address addr) public constant returns (uint) {
193     return funders[addr].withdrawalEntry;
194   }
195 
196   function getContractBalance() public constant returns (uint256 balance) {
197     balance = this.balance;
198   }
199 
200   function getFunderBalance(address funder) public constant returns (uint256) {
201     return getRefundAmountForFunder(funder);
202   }
203 
204   function isFunder(address addr) public constant returns (bool) {
205     return funders[addr].exists;
206   }
207 
208   function getHowManyWithdrawalsForFunder(address addr) private constant returns (uint) {
209     return withdrawalCounter.sub(getWithdrawalEntryForFunder(addr));
210   }
211 
212   // State changing functions
213   function setMinimumFundingAmount(uint amount) external onlyByBeneficiary {
214     require(amount > 0);
215     minimumFundingAmount = amount;
216   }
217 
218   function withdraw() external onlyByBeneficiary onlyAfterNextWithdrawalDate onlyWhenLive  {
219     // Check
220     uint amount = calculateWithdrawalAmount(this.balance);
221 
222     // Effects
223     withdrawalCounter = withdrawalCounter.add(1);
224     lastWithdrawal = now; // For tracking purposes
225     nextWithdrawal = nextWithdrawal + withdrawalPeriod; // Fixed period increase
226 
227     // Interaction
228     beneficiary.transfer(amount);
229   }
230 
231   // Refunding by funder
232   // Only funders can refund their own funding
233   // Can only be sent back to the same address it was funded with
234   // We also remove the funder if they succesfully exit with their funds
235   function refund() external onlyByFunder {
236     // Check
237     uint walletBalance = this.balance;
238     uint amount = getRefundAmountForFunder(msg.sender);
239     require(amount > 0);
240 
241     // Effects
242     removeFunder();
243 
244     // Interaction
245     msg.sender.transfer(amount);
246 
247     // Make sure this worked as intended
248     assert(this.balance == walletBalance-amount);
249   }
250 
251   // Used when the funder wants to remove themselves as a funder
252   // without refunding. Their eth stays in the pool
253   function removeFunder() public onlyByFunder {
254     delete funders[msg.sender];
255     totalCurrentFunders = totalCurrentFunders.sub(1);
256   }
257 
258   /*
259   * The beneficiary can decide to stop using this contract.
260   * They use this sunset function to put it into sunset mode.
261   * The beneficiary can then swipe rest of the funds after a set time
262   * if funders have not withdrawn their funds.
263   */
264 
265   function sunset() external onlyByBeneficiary onlyWhenLive {
266     sunsetWithdrawDate = now.add(sunsetWithdrawalPeriod);
267     live = false;
268   }
269 
270   function swipe(address recipient) external onlyWhenSunset onlyByBeneficiary {
271     require(now >= sunsetWithdrawDate);
272 
273     recipient.transfer(this.balance);
274   }
275 }