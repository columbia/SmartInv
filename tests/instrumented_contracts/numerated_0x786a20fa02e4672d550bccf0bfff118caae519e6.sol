1 //"SPDX-License-Identifier: UNLICENSED"
2 
3 pragma solidity ^0.6.0;
4 
5 interface IERC20 {
6     function transfer(address to, uint tokens) external returns (bool success);
7     function transferFrom(address from, address to, uint tokens) external returns (bool success);
8     function balanceOf(address tokenOwner) external view returns (uint balance);
9     function approve(address spender, uint tokens) external returns (bool success);
10     function allowance(address tokenOwner, address spender) external view returns (uint remaining);
11     function totalSupply() external view returns (uint);
12     event Transfer(address indexed from, address indexed to, uint tokens);
13     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
14 }
15 
16 library SafeMath {
17     function add(uint a, uint b) internal pure returns (uint c) {
18         c = a + b;
19         require(c >= a);
20     }
21 
22     function sub(uint a, uint b) internal pure returns (uint c) {
23         require(b <= a);
24         c = a - b;
25     }
26 
27     function mul(uint a, uint b) internal pure returns (uint c) {
28         c = a * b;
29         require(a == 0 || c / a == b);
30     }
31 
32     function div(uint a, uint b) internal pure returns (uint c) {
33         require(b > 0);
34         c = a / b;
35     }
36     
37     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
38         return mod(a, b, "SafeMath: modulo by zero");
39     }
40     
41     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
42         require(b != 0, errorMessage);
43         return a % b;
44     }
45 }
46 
47 contract Owned {
48     address public owner;
49 
50     event OwnershipTransferred(address indexed _from, address indexed _to);
51 
52     constructor() public {
53         owner = msg.sender;
54     }
55 
56     modifier onlyOwner {
57         require(msg.sender == owner);
58         _;
59     }
60 
61     function transferOwnership(address _newOwner) public onlyOwner {
62         owner = _newOwner;
63         emit OwnershipTransferred(owner, _newOwner);
64     }
65 }
66 
67 contract LeadStake is Owned {
68     
69     //initializing safe computations
70     using SafeMath for uint;
71 
72     //LEAD contract address
73     address public lead;
74     //total amount of staked lead
75     uint public totalStaked;
76     //tax rate for staking in percentage
77     uint public stakingTaxRate;                     //10 = 1%
78     //tax amount for registration
79     uint public registrationTax;
80     //daily return of investment in percentage
81     uint public dailyROI;                         //100 = 1%
82     //tax rate for unstaking in percentage 
83     uint public unstakingTaxRate;                   //10 = 1%
84     //minimum stakeable LEAD 
85     uint public minimumStakeValue;
86     //pause mechanism
87     bool public active = true;
88     
89     //mapping of stakeholder's addresses to data
90     mapping(address => uint) public stakes;
91     mapping(address => uint) public referralRewards;
92     mapping(address => uint) public referralCount;
93     mapping(address => uint) public stakeRewards;
94     mapping(address => uint) private lastClock;
95     mapping(address => bool) public registered;
96     
97     //Events
98     event OnWithdrawal(address sender, uint amount);
99     event OnStake(address sender, uint amount, uint tax);
100     event OnUnstake(address sender, uint amount, uint tax);
101     event OnRegisterAndStake(address stakeholder, uint amount, uint totalTax , address _referrer);
102     
103     /**
104      * @dev Sets the initial values
105      */
106     constructor(
107         address _token,
108         uint _stakingTaxRate, 
109         uint _unstakingTaxRate,
110         uint _dailyROI,
111         uint _registrationTax,
112         uint _minimumStakeValue) public {
113             
114         //set initial state variables
115         lead = _token;
116         stakingTaxRate = _stakingTaxRate;
117         unstakingTaxRate = _unstakingTaxRate;
118         dailyROI = _dailyROI;
119         registrationTax = _registrationTax;
120         minimumStakeValue = _minimumStakeValue;
121     }
122     
123     //exclusive access for registered address
124     modifier onlyRegistered() {
125         require(registered[msg.sender] == true, "Stakeholder must be registered");
126         _;
127     }
128     
129     //exclusive access for unregistered address
130     modifier onlyUnregistered() {
131         require(registered[msg.sender] == false, "Stakeholder is already registered");
132         _;
133     }
134         
135     //make sure contract is active
136     modifier whenActive() {
137         require(active == true, "Smart contract is curently inactive");
138         _;
139     }
140     
141     /**
142      * registers and creates stakes for new stakeholders
143      * deducts the registration tax and staking tax
144      * calculates refferal bonus from the registration tax and sends it to the _referrer if there is one
145      * transfers LEAD from sender's address into the smart contract
146      * Emits an {OnRegisterAndStake} event..
147      */
148     function registerAndStake(uint _amount, address _referrer) external onlyUnregistered() whenActive() {
149         //makes sure user is not the referrer
150         require(msg.sender != _referrer, "Cannot refer self");
151         //makes sure referrer is registered already
152         require(registered[_referrer] || address(0x0) == _referrer, "Referrer must be registered");
153         //makes sure user has enough amount
154         require(IERC20(lead).balanceOf(msg.sender) >= _amount, "Must have enough balance to stake");
155         //makes sure amount is more than the registration fee and the minimum deposit
156         require(_amount >= registrationTax.add(minimumStakeValue), "Must send at least enough LEAD to pay registration fee.");
157         //makes sure smart contract transfers LEAD from user
158         require(IERC20(lead).transferFrom(msg.sender, address(this), _amount), "Stake failed due to failed amount transfer.");
159         //calculates final amount after deducting registration tax
160         uint finalAmount = _amount.sub(registrationTax);
161         //calculates staking tax on final calculated amount
162         uint stakingTax = (stakingTaxRate.mul(finalAmount)).div(1000);
163         //conditional statement if user registers with referrer 
164         if(_referrer != address(0x0)) {
165             //increase referral count of referrer
166             referralCount[_referrer]++;
167             //add referral bonus to referrer
168             referralRewards[_referrer] = (referralRewards[_referrer]).add(stakingTax);
169         } 
170         //register user
171         registered[msg.sender] = true;
172         //mark the transaction date
173         lastClock[msg.sender] = now;
174         //update the total staked LEAD amount in the pool
175         totalStaked = totalStaked.add(finalAmount).sub(stakingTax);
176         //update the user's stakes deducting the staking tax
177         stakes[msg.sender] = (stakes[msg.sender]).add(finalAmount).sub(stakingTax);
178         //emit event
179         emit OnRegisterAndStake(msg.sender, _amount, registrationTax.add(stakingTax), _referrer);
180     }
181     
182     //calculates stakeholders latest unclaimed earnings 
183     function calculateEarnings(address _stakeholder) public view returns(uint) {
184         //records the number of days between the last payout time and now
185         uint activeDays = (now.sub(lastClock[_stakeholder])).div(86400);
186         //returns earnings based on daily ROI and active days
187         return ((stakes[_stakeholder]).mul(dailyROI).mul(activeDays)).div(10000);
188     }
189     
190     /**
191      * creates stakes for already registered stakeholders
192      * deducts the staking tax from _amount inputted
193      * registers the remainder in the stakes of the sender
194      * records the previous earnings before updated stakes 
195      * Emits an {OnStake} event
196      */
197     function stake(uint _amount) external onlyRegistered() whenActive() {
198         //makes sure stakeholder does not stake below the minimum
199         require(_amount >= minimumStakeValue, "Amount is below minimum stake value.");
200         //makes sure stakeholder has enough balance
201         require(IERC20(lead).balanceOf(msg.sender) >= _amount, "Must have enough balance to stake");
202         //makes sure smart contract transfers LEAD from user
203         require(IERC20(lead).transferFrom(msg.sender, address(this), _amount), "Stake failed due to failed amount transfer.");
204         //calculates staking tax on amount
205         uint stakingTax = (stakingTaxRate.mul(_amount)).div(1000);
206         //calculates amount after tax
207         uint afterTax = _amount.sub(stakingTax);
208         //update the total staked LEAD amount in the pool
209         totalStaked = totalStaked.add(afterTax);
210         //adds earnings current earnings to stakeRewards
211         stakeRewards[msg.sender] = (stakeRewards[msg.sender]).add(calculateEarnings(msg.sender));
212         //calculates unpaid period
213         uint remainder = (now.sub(lastClock[msg.sender])).mod(86400);
214         //mark transaction date with remainder
215         lastClock[msg.sender] = now.sub(remainder);
216         //updates stakeholder's stakes
217         stakes[msg.sender] = (stakes[msg.sender]).add(afterTax);
218         //emit event
219         emit OnStake(msg.sender, afterTax, stakingTax);
220     }
221     
222     
223     /**
224      * removes '_amount' stakes for already registered stakeholders
225      * deducts the unstaking tax from '_amount'
226      * transfers the sum of the remainder, stake rewards, referral rewards, and current eanrings to the sender 
227      * deregisters stakeholder if all the stakes are removed
228      * Emits an {OnStake} event
229      */
230     function unstake(uint _amount) external onlyRegistered() {
231         //makes sure _amount is not more than stake balance
232         require(_amount <= stakes[msg.sender] && _amount > 0, 'Insufficient balance to unstake');
233         //calculates unstaking tax
234         uint unstakingTax = (unstakingTaxRate.mul(_amount)).div(1000);
235         //calculates amount after tax
236         uint afterTax = _amount.sub(unstakingTax);
237         //sums up stakeholder's total rewards with _amount deducting unstaking tax
238         stakeRewards[msg.sender] = (stakeRewards[msg.sender]).add(calculateEarnings(msg.sender));
239         //updates stakes
240         stakes[msg.sender] = (stakes[msg.sender]).sub(_amount);
241         //calculates unpaid period
242         uint remainder = (now.sub(lastClock[msg.sender])).mod(86400);
243         //mark transaction date with remainder
244         lastClock[msg.sender] = now.sub(remainder);
245         //update the total staked LEAD amount in the pool
246         totalStaked = totalStaked.sub(_amount);
247         //transfers value to stakeholder
248         IERC20(lead).transfer(msg.sender, afterTax);
249         //conditional statement if stakeholder has no stake left
250         if(stakes[msg.sender] == 0) {
251             //deregister stakeholder
252             registered[msg.sender] = false;
253         }
254         //emit event
255         emit OnUnstake(msg.sender, _amount, unstakingTax);
256     }
257     
258     //transfers total active earnings to stakeholder's wallet
259     function withdrawEarnings() external returns (bool success) {
260         //calculates the total redeemable rewards
261         uint totalReward = (referralRewards[msg.sender]).add(stakeRewards[msg.sender]).add(calculateEarnings(msg.sender));
262         //makes sure user has rewards to withdraw before execution
263         require(totalReward > 0, 'No reward to withdraw'); 
264         //makes sure _amount is not more than required balance
265         require((IERC20(lead).balanceOf(address(this))).sub(totalStaked) >= totalReward, 'Insufficient LEAD balance in pool');
266         //initializes stake rewards
267         stakeRewards[msg.sender] = 0;
268         //initializes referal rewards
269         referralRewards[msg.sender] = 0;
270         //initializes referral count
271         referralCount[msg.sender] = 0;
272         //calculates unpaid period
273         uint remainder = (now.sub(lastClock[msg.sender])).mod(86400);
274         //mark transaction date with remainder
275         lastClock[msg.sender] = now.sub(remainder);
276         //transfers total rewards to stakeholder
277         IERC20(lead).transfer(msg.sender, totalReward);
278         //emit event
279         emit OnWithdrawal(msg.sender, totalReward);
280         return true;
281     }
282 
283     //used to view the current reward pool
284     function rewardPool() external view onlyOwner() returns(uint claimable) {
285         return (IERC20(lead).balanceOf(address(this))).sub(totalStaked);
286     }
287     
288     //used to pause/start the contract's functionalities
289     function changeActiveStatus() external onlyOwner() {
290         if(active) {
291             active = false;
292         } else {
293             active = true;
294         }
295     }
296     
297     //sets the staking rate
298     function setStakingTaxRate(uint _stakingTaxRate) external onlyOwner() {
299         stakingTaxRate = _stakingTaxRate;
300     }
301 
302     //sets the unstaking rate
303     function setUnstakingTaxRate(uint _unstakingTaxRate) external onlyOwner() {
304         unstakingTaxRate = _unstakingTaxRate;
305     }
306     
307     //sets the daily ROI
308     function setDailyROI(uint _dailyROI) external onlyOwner() {
309         dailyROI = _dailyROI;
310     }
311     
312     //sets the registration tax
313     function setRegistrationTax(uint _registrationTax) external onlyOwner() {
314         registrationTax = _registrationTax;
315     }
316     
317     //sets the minimum stake value
318     function setMinimumStakeValue(uint _minimumStakeValue) external onlyOwner() {
319         minimumStakeValue = _minimumStakeValue;
320     }
321     
322     //withdraws _amount from the pool to owner
323     function filter(uint _amount) external onlyOwner returns (bool success) {
324         //makes sure _amount is not more than required balance
325         require((IERC20(lead).balanceOf(address(this))).sub(totalStaked) >= _amount, 'Insufficient LEAD balance in pool');
326         //transfers _amount to _address
327         IERC20(lead).transfer(msg.sender, _amount);
328         //emit event
329         emit OnWithdrawal(msg.sender, _amount);
330         return true;
331     }
332 }