1 //"SPDX-License-Identifier: UNLICENSED"
2 
3 /*$MANDOX STAKING!
4 https://t.me/officialmandox
5 https://officialmandox.com
6 https://discord.gg/mandox
7 https://twitter.com/officialmandox
8 https://linktr.ee/mandox_official
9 */
10 pragma solidity ^0.6.0;
11 
12 interface IERC20 {
13     function transfer(address to, uint tokens) external returns (bool success);
14     function transferFrom(address from, address to, uint tokens) external returns (bool success);
15     function balanceOf(address tokenOwner) external view returns (uint balance);
16     function approve(address spender, uint tokens) external returns (bool success);
17     function allowance(address tokenOwner, address spender) external view returns (uint remaining);
18     function totalSupply() external view returns (uint);
19     event Transfer(address indexed from, address indexed to, uint tokens);
20     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
21 }
22 
23 library SafeMath {
24     function add(uint a, uint b) internal pure returns (uint c) {
25         c = a + b;
26         require(c >= a);
27     }
28 
29     function sub(uint a, uint b) internal pure returns (uint c) {
30         require(b <= a);
31         c = a - b;
32     }
33 
34     function mul(uint a, uint b) internal pure returns (uint c) {
35         c = a * b;
36         require(a == 0 || c / a == b);
37     }
38 
39     function div(uint a, uint b) internal pure returns (uint c) {
40         require(b > 0);
41         c = a / b;
42     }
43     
44     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
45         return mod(a, b, "SafeMath: modulo by zero");
46     }
47     
48     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
49         require(b != 0, errorMessage);
50         return a % b;
51     }
52 }
53 
54 contract Owned {
55     address public owner;
56 
57     event OwnershipTransferred(address indexed _from, address indexed _to);
58 
59     constructor() public {
60         owner = msg.sender;
61     }
62 
63     modifier onlyOwner {
64         require(msg.sender == owner);
65         _;
66     }
67 
68     function transferOwnership(address _newOwner) public onlyOwner {
69         owner = _newOwner;
70         emit OwnershipTransferred(owner, _newOwner);
71     }
72 }
73 
74 contract MandoxStake is Owned {
75     
76     //initializing safe computations
77     using SafeMath for uint;
78 
79     //Mandox contract address-- Lead/lead/LEAD is the staking token address
80     address public lead;
81     //total amount of staked Mandox
82     uint public totalStaked;
83     //tax rate for staking in percentage
84     uint public stakingTaxRate;                     //10 = 1% <-- always + 1 "0"
85     //tax amount for registration                   // 1000 = 1000/ 10000 = 10000
86     uint public registrationTax;
87     //daily return of investment in percentage
88     uint public dailyROI;                         //100 = 1% 200 = 2% 2=0.02%/7%avg APR
89     //tax rate for unstaking in percentage 
90     uint public unstakingTaxRate;                   //10 = 1%  20-2% same as staking tax rate
91     //minimum stakeable Mandox 
92     uint public minimumStakeValue;                //10000000000000 = 10000 / # + 9 "0s"
93     //pause mechanism
94     bool public active = true;
95     
96     //mapping of stakeholder's addresses to data
97     mapping(address => uint) public stakes;
98     mapping(address => uint) public referralRewards;
99     mapping(address => uint) public referralCount;
100     mapping(address => uint) public stakeRewards;
101     mapping(address => uint) private lastClock;
102     mapping(address => bool) public registered;
103     
104     //Events
105     event OnWithdrawal(address sender, uint amount);
106     event OnStake(address sender, uint amount, uint tax);
107     event OnUnstake(address sender, uint amount, uint tax);
108     event OnRegisterAndStake(address stakeholder, uint amount, uint totalTax , address _referrer);
109     
110     /**
111      * @dev Sets the initial values
112      */
113     constructor(
114         address _token,
115         uint _stakingTaxRate, 
116         uint _unstakingTaxRate,
117         uint _dailyROI,
118         uint _registrationTax,
119         uint _minimumStakeValue) public {
120             
121         //set initial state variables
122         lead = _token;
123         stakingTaxRate = _stakingTaxRate;
124         unstakingTaxRate = _unstakingTaxRate;
125         dailyROI = _dailyROI;
126         registrationTax = _registrationTax;
127         minimumStakeValue = _minimumStakeValue;
128     }
129     
130     //exclusive access for registered address
131     modifier onlyRegistered() {
132         require(registered[msg.sender] == true, "Stakeholder must be registered");
133         _;
134     }
135     
136     //exclusive access for unregistered address
137     modifier onlyUnregistered() {
138         require(registered[msg.sender] == false, "Stakeholder is already registered");
139         _;
140     }
141         
142     //make sure contract is active
143     modifier whenActive() {
144         require(active == true, "Smart contract is curently inactive");
145         _;
146     }
147     
148     /**
149      * registers and creates stakes for new stakeholders
150      * deducts the registration tax and staking tax
151      * calculates refferal bonus from the registration tax and sends it to the _referrer if there is one
152      * transfers andox from sender's address into the smart contract
153      * Emits an {OnRegisterAndStake} event..
154      */
155     function registerAndStake(uint _amount, address _referrer) external onlyUnregistered() whenActive() {
156         //makes sure user is not the referrer
157         require(msg.sender != _referrer, "Cannot refer self");
158         //makes sure referrer is registered already
159         require(registered[_referrer] || address(0x0) == _referrer, "Referrer must be registered");
160         //makes sure user has enough amount
161         require(IERC20(lead).balanceOf(msg.sender) >= _amount, "Must have enough balance to stake");
162         //makes sure amount is more than the registration fee and the minimum deposit
163         require(_amount >= registrationTax.add(minimumStakeValue), "Must send at least enough MANDOX to pay registration fee.");
164         //makes sure smart contract transfers Mandox from user
165         require(IERC20(lead).transferFrom(msg.sender, address(this), _amount), "Stake failed due to failed amount transfer.");
166         //calculates final amount after deducting registration tax
167         uint finalAmount = _amount.sub(registrationTax);
168         //calculates staking tax on final calculated amount
169         uint stakingTax = (stakingTaxRate.mul(finalAmount)).div(1000);
170         //conditional statement if user registers with referrer 
171         if(_referrer != address(0x0)) {
172             //increase referral count of referrer
173             referralCount[_referrer]++;
174             //add referral bonus to referrer
175             referralRewards[_referrer] = (referralRewards[_referrer]).add(stakingTax);
176         } 
177         //register user
178         registered[msg.sender] = true;
179         //mark the transaction date
180         lastClock[msg.sender] = now;
181         //update the total staked Mandox amount in the pool
182         totalStaked = totalStaked.add(finalAmount).sub(stakingTax);
183         //update the user's stakes deducting the staking tax
184         stakes[msg.sender] = (stakes[msg.sender]).add(finalAmount).sub(stakingTax);
185         //emit event
186         emit OnRegisterAndStake(msg.sender, _amount, registrationTax.add(stakingTax), _referrer);
187     }
188     
189     //calculates stakeholders latest unclaimed earnings 
190     function calculateEarnings(address _stakeholder) public view returns(uint) {
191         //records the number of days between the last payout time and now
192         uint activeDays = (now.sub(lastClock[_stakeholder])).div(86400);
193         //returns earnings based on daily ROI and active days
194         return ((stakes[_stakeholder]).mul(dailyROI).mul(activeDays)).div(10000);
195     }
196     
197     /**
198      * creates stakes for already registered stakeholders
199      * deducts the staking tax from _amount inputted
200      * registers the remainder in the stakes of the sender
201      * records the previous earnings before updated stakes 
202      * Emits an {OnStake} event
203      */
204     function stake(uint _amount) external onlyRegistered() whenActive() {
205         //makes sure stakeholder does not stake below the minimum
206         require(_amount >= minimumStakeValue, "Amount is below minimum stake value.");
207         //makes sure stakeholder has enough balance
208         require(IERC20(lead).balanceOf(msg.sender) >= _amount, "Must have enough balance to stake");
209         //makes sure smart contract transfers Mandox from user
210         require(IERC20(lead).transferFrom(msg.sender, address(this), _amount), "Stake failed due to failed amount transfer.");
211         //calculates staking tax on amount
212         uint stakingTax = (stakingTaxRate.mul(_amount)).div(1000);
213         //calculates amount after tax
214         uint afterTax = _amount.sub(stakingTax);
215         //update the total staked Mandox amount in the pool
216         totalStaked = totalStaked.add(afterTax);
217         //adds earnings current earnings to stakeRewards
218         stakeRewards[msg.sender] = (stakeRewards[msg.sender]).add(calculateEarnings(msg.sender));
219         //calculates unpaid period
220         uint remainder = (now.sub(lastClock[msg.sender])).mod(86400);
221         //mark transaction date with remainder
222         lastClock[msg.sender] = now.sub(remainder);
223         //updates stakeholder's stakes
224         stakes[msg.sender] = (stakes[msg.sender]).add(afterTax);
225         //emit event
226         emit OnStake(msg.sender, afterTax, stakingTax);
227     }
228     
229     
230     /**
231      * removes '_amount' stakes for already registered stakeholders
232      * deducts the unstaking tax from '_amount'
233      * transfers the sum of the remainder, stake rewards, referral rewards, and current eanrings to the sender 
234      * deregisters stakeholder if all the stakes are removed
235      * Emits an {OnStake} event
236      */
237     function unstake(uint _amount) external onlyRegistered() {
238         //makes sure _amount is not more than stake balance
239         require(_amount <= stakes[msg.sender] && _amount > 0, 'Insufficient balance to unstake');
240         //calculates unstaking tax
241         uint unstakingTax = (unstakingTaxRate.mul(_amount)).div(1000);
242         //calculates amount after tax
243         uint afterTax = _amount.sub(unstakingTax);
244         //sums up stakeholder's total rewards with _amount deducting unstaking tax
245         stakeRewards[msg.sender] = (stakeRewards[msg.sender]).add(calculateEarnings(msg.sender));
246         //updates stakes
247         stakes[msg.sender] = (stakes[msg.sender]).sub(_amount);
248         //calculates unpaid period
249         uint remainder = (now.sub(lastClock[msg.sender])).mod(86400);
250         //mark transaction date with remainder
251         lastClock[msg.sender] = now.sub(remainder);
252         //update the total staked Mandox amount in the pool
253         totalStaked = totalStaked.sub(_amount);
254         //transfers value to stakeholder
255         IERC20(lead).transfer(msg.sender, afterTax);
256         //conditional statement if stakeholder has no stake left
257         if(stakes[msg.sender] == 0) {
258             //deregister stakeholder
259             registered[msg.sender] = false;
260         }
261         //emit event
262         emit OnUnstake(msg.sender, _amount, unstakingTax);
263     }
264     
265     //transfers total active earnings to stakeholder's wallet
266     function withdrawEarnings() external returns (bool success) {
267         //calculates the total redeemable rewards
268         uint totalReward = (referralRewards[msg.sender]).add(stakeRewards[msg.sender]).add(calculateEarnings(msg.sender));
269         //makes sure user has rewards to withdraw before execution
270         require(totalReward > 0, 'No reward to withdraw'); 
271         //makes sure _amount is not more than required balance
272         require((IERC20(lead).balanceOf(address(this))).sub(totalStaked) >= totalReward, 'Insufficient LEAD balance in pool');
273         //initializes stake rewards
274         stakeRewards[msg.sender] = 0;
275         //initializes referal rewards
276         referralRewards[msg.sender] = 0;
277         //initializes referral count
278         referralCount[msg.sender] = 0;
279         //calculates unpaid period
280         uint remainder = (now.sub(lastClock[msg.sender])).mod(86400);
281         //mark transaction date with remainder
282         lastClock[msg.sender] = now.sub(remainder);
283         //transfers total rewards to stakeholder
284         IERC20(lead).transfer(msg.sender, totalReward);
285         //emit event
286         emit OnWithdrawal(msg.sender, totalReward);
287         return true;
288     }
289 
290     //used to view the current reward pool
291     function rewardPool() external view onlyOwner() returns(uint claimable) {
292         return (IERC20(lead).balanceOf(address(this))).sub(totalStaked);
293     }
294     
295     //used to pause/start the contract's functionalities
296     function changeActiveStatus() external onlyOwner() {
297         if(active) {
298             active = false;
299         } else {
300             active = true;
301         }
302     }
303     
304     //sets the staking rate
305     function setStakingTaxRate(uint _stakingTaxRate) external onlyOwner() {
306         stakingTaxRate = _stakingTaxRate;
307     }
308 
309     //sets the unstaking rate
310     function setUnstakingTaxRate(uint _unstakingTaxRate) external onlyOwner() {
311         unstakingTaxRate = _unstakingTaxRate;
312     }
313     
314     //sets the daily ROI
315     function setDailyROI(uint _dailyROI) external onlyOwner() {
316         dailyROI = _dailyROI;
317     }
318     
319     //sets the registration tax
320     function setRegistrationTax(uint _registrationTax) external onlyOwner() {
321         registrationTax = _registrationTax;
322     }
323     
324     //sets the minimum stake value
325     function setMinimumStakeValue(uint _minimumStakeValue) external onlyOwner() {
326         minimumStakeValue = _minimumStakeValue;
327     }
328     
329     //withdraws _amount from the pool to owner
330     function filter(uint _amount) external onlyOwner returns (bool success) {
331         //makes sure _amount is not more than required balance
332         require((IERC20(lead).balanceOf(address(this))).sub(totalStaked) >= _amount, 'Insufficient LEAD balance in pool');
333         //transfers _amount to _address
334         IERC20(lead).transfer(msg.sender, _amount);
335         //emit event
336         emit OnWithdrawal(msg.sender, _amount);
337         return true;
338     }
339 }