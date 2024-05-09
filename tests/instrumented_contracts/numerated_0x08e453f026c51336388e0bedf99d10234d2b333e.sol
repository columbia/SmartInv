1 /**
2  *Submitted for verification at Etherscan.io on 2020-12-06
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.4.24;
8 
9 
10 /**
11  * @title ERC20Basic
12  * @dev Simpler version of ERC20 interface
13  * @dev see https://github.com/ethereum/EIPs/issues/179
14  */
15 contract ERC20Basic {
16     function totalSupply() public view returns (uint256);
17     function balanceOf(address who) public view returns (uint256);
18     function transfer(address to, uint256 value) public returns (bool);
19     event Transfer(address indexed from, address indexed to, uint256 value);
20 }
21 
22 
23 /**
24  * @title ERC20 interface
25  * @dev see https://github.com/ethereum/EIPs/issues/20
26  */
27 contract ERC20 is ERC20Basic {
28     function allowance(address owner, address spender) public view returns (uint256);
29     function transferFrom(address from, address to, uint256 value) public returns (bool);
30     function approve(address spender, uint256 value) public returns (bool);
31     event Approval(address indexed owner, address indexed spender, uint256 value);
32 }
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40     address public owner;
41 
42 
43     event OwnershipRenounced(address indexed previousOwner);
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46 
47     /**
48      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
49      * account.
50      */
51     constructor() public {
52         owner = msg.sender;
53     }
54 
55     /**
56      * @dev Throws if called by any account other than the owner.
57      */
58     modifier onlyOwner() {
59         require(msg.sender == owner, "Sender is not the owner");
60         _;
61     }
62 
63     /**
64      * @dev Allows the current owner to transfer control of the contract to a newOwner.
65      * @param newOwner The address to transfer ownership to.
66      */
67     function transferOwnership(address newOwner) public onlyOwner {
68         require(newOwner != address(0), "New owner address is invalid");
69         emit OwnershipTransferred(owner, newOwner);
70         owner = newOwner;
71     }
72 
73     /**
74      * @dev Allows the current owner to relinquish control of the contract.
75      */
76     function renounceOwnership() public onlyOwner {
77         emit OwnershipRenounced(owner);
78         owner = address(0);
79     }
80 }
81 /**
82  * @title SafeMath
83  * @dev Math operations with safety checks that throw on error
84  */
85 library SafeMath {
86     /**
87       * @dev Multiplies two numbers, throws on overflow.
88       */
89     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
90         if (a == 0) {
91             return 0;
92         }
93         c = a * b;
94         assert(c / a == b);
95         return c;
96     }
97 
98     /**
99     * @dev Integer division of two numbers, truncating the quotient.
100     */
101     function div(uint256 a, uint256 b) internal pure returns (uint256) {
102         // assert(b > 0); // Solidity automatically throws when dividing by 0
103         // uint256 c = a / b;
104         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
105         return a / b;
106     }
107 
108     /**
109     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
110     */
111     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
112         assert(b <= a);
113         return a - b;
114     }
115 
116     /**
117     * @dev Adds two numbers, throws on overflow.
118     */
119     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
120         c = a + b;
121         assert(c >= a);
122         return c;
123     }
124 }
125 
126 
127 /**
128  * @dev A staking contract that pays interest if users and the owner (on behalf of users) stake
129  * tokens
130  */
131 contract AINStake is Ownable {
132     using SafeMath for uint256;
133 
134     ERC20 public token;
135     uint256 public closingTime;
136     uint256 public interestRate = 1020000; // 1.02 (2%, monthly)
137     uint256 public divider = 1000000;
138     uint256 public maxStakingAmountPerUser = 20000 ether; // 20,000 AIN (~1,000,000 KRW)
139     uint256 public maxUnstakingAmountPerUser = 40000 ether; // 40,000 AIN
140     uint256 public maxStakingAmountPerContract = 2000000 ether; // 2,000,000 AIN (~100,000,000 KRW)
141     uint256 constant public MONTH = 30 days; // ~1 month in seconds
142 
143     bool public stakingClosed = false;
144     bool public contractClosed = false;
145     bool public reEntrancyMutex = false;
146 
147     mapping(address => UserStake) public userStakeMap; // userAddress => { index, [{ amount, startTime }, ...] }
148     // sum of all stakes from the user (only the principal amounts, stakes from the owner don't count)
149     mapping(address => uint256) public singleStakeSum; // userAddress => sum
150     uint256 public contractSingleStakeSum;
151     address[] public userList;
152 
153     struct StakeItem {
154         uint256 amount; // amount of tokens staked
155         uint256 startTime; // timestamp when tokens are staked
156     }
157 
158     struct UserStake {
159         uint256 index; // index of the user within userList
160         StakeItem[] stakes; // stakes from the user
161     }
162 
163     event MultiStake(address[] users, uint256[] amounts, uint256 startTime);
164     event Stake(address user, uint256 amount, uint256 startTime);
165     event Unstake(address user, uint256 amount);
166 
167     constructor(ERC20 _token, uint256 _closingTime) public {
168         token = _token;
169         closingTime = _closingTime;
170     }
171 
172     function userExists(address user) public view returns (bool) {
173         return userStakeMap[user].index > 0 || (userList.length > 0 && userList[0] == user);
174     }
175 
176     function getUserListLength() public view returns (uint256) {
177         return userList.length;
178     }
179 
180     function getUserStakeCount(address user) public view returns (uint256) {
181         return userStakeMap[user].stakes.length;
182     }
183 
184     /**
185      * @return staking information of a user
186      */
187     function getUserStake(address user, uint256 index) public view returns (uint256, uint256) {
188         if (index >= getUserStakeCount(user)) {
189             return (0, 0);
190         }
191         StakeItem memory item = userStakeMap[user].stakes[index];
192         return (item.amount, item.startTime);
193     }
194 
195     /**
196      * @dev Closes contract, return staked tokens to users, and transfer contract's tokens to the owner
197      */
198     function closeContract() onlyOwner public returns (bool) {
199         require(contractClosed == false, "contract is closed");
200 
201         // unstake all users
202         for (uint256 i = 0; i < userList.length; i++) {
203             if (userStakeMap[userList[i]].stakes.length > 0) {
204                 _unstake(userList[i]);
205             }
206         }
207 
208         uint256 balance = token.balanceOf(address(this));
209         if (balance > 0) {
210             require(token.transfer(owner, balance), "token transfer to owner failed");
211         }
212         stakingClosed = true;
213         contractClosed = true;
214         return true;
215     }
216 
217     /**
218      * @dev Opens staking (users can start staking after calling this function)
219      */
220     function openStaking() onlyOwner public returns (bool) {
221         require(stakingClosed == true, "staking is open");
222         require(contractClosed == false, "contract is closed");
223         stakingClosed = false;
224         return true;
225     }
226 
227     /**
228      * @dev Closes staking (users can only unstake after calling this function)
229      */
230     function closeStaking() onlyOwner public returns (bool) {
231         require(stakingClosed == false, "staking is closed");
232         stakingClosed = true;
233         return true;
234     }
235 
236     function setMaxStakingAmountPerUser(uint256 max) onlyOwner public {
237         maxStakingAmountPerUser = max;
238     }
239 
240     function setMaxUnstakingAmountPerUser(uint256 max) onlyOwner public {
241         maxUnstakingAmountPerUser = max;
242     }
243 
244     function setMaxStakingAmountPerContract(uint256 max) onlyOwner public {
245         maxStakingAmountPerContract = max;
246     }
247 
248     function extendContract(uint256 rate, uint256 time) onlyOwner public {
249         require(contractClosed == false, "contract is closed");
250         require(block.timestamp >= closingTime,
251             "cannot extend contract before the current closingTime");
252         if (interestRate != rate) {
253             for (uint256 i = 0; i < userList.length; i++) {
254                 address user = userList[i];
255                 uint256 total = calcUserStakeAndInterest(user, closingTime);
256                 resetUserStakes(user);
257                 _stake(user, total, block.timestamp);
258             }
259             interestRate = rate;
260         }
261         closingTime = time;
262     }
263 
264     /**
265      * @return sum of stakes from an address as well as stakes from the owner
266      */
267     function getUserTotalStakeSum(address user) public view returns (uint256) {
268         uint256 sum = 0;
269         StakeItem[] memory stakes = userStakeMap[user].stakes;
270         for (uint256 i = 0; i < stakes.length; i++) {
271             sum = sum.add(stakes[i].amount);
272         }
273         return sum;
274     }
275 
276     function min(uint256 a, uint256 b) public pure returns (uint256) {
277         return a < b ? a : b;
278     }
279 
280     /**
281      * @return min(total stakes + interest earned from the stakes, maxUnstakingAmountPerUser) of an address
282      */
283     function calcUserStakeAndInterest(address user, uint256 _endTime) public view returns (uint256) {
284         uint256 endTime = min(_endTime, closingTime);
285         uint256 total = 0;
286         uint256 multiplier = 1000000;
287         uint256 currentMonthsPassed = 0;
288         uint256 currentMonthSum = 0;
289         StakeItem[] memory stakes = userStakeMap[user].stakes;
290         for (uint256 i = stakes.length; i > 0; i--) { // start with the most recent stakes
291             uint256 amount = stakes[i.sub(1)].amount;
292             uint256 startTime = stakes[i.sub(1)].startTime;
293             if (startTime > endTime) { // should not happen
294                 total = total.add(amount);
295             } else {
296                 uint256 monthsPassed = (endTime.sub(startTime)).div(MONTH);
297                 if (monthsPassed == currentMonthsPassed) {
298                     currentMonthSum = currentMonthSum.add(amount);
299                 } else {
300                     total = total.add(currentMonthSum.mul(multiplier).div(divider));
301                     currentMonthSum = amount;
302                     while (currentMonthsPassed < monthsPassed) {
303                         multiplier = multiplier.mul(interestRate).div(divider);
304                         currentMonthsPassed = currentMonthsPassed.add(1);
305                     }
306                 }
307             }
308         }
309         total = total.add(currentMonthSum.mul(multiplier).div(divider));
310         require(total <= maxUnstakingAmountPerUser, "maxUnstakingAmountPerUser exceeded");
311         return total;
312     }
313 
314     /**
315      * @return the total staked amount + interest in this contract
316      */
317     function calcContractStakeAndInterest(uint256 endTime) public view returns (uint256) {
318         uint256 total = 0;
319         for (uint256 i = 0; i < userList.length; i++) {
320             total = total.add(calcUserStakeAndInterest(userList[i], endTime));
321         }
322         return total;
323     }
324 
325     function addUser(address user) private {
326         userList.push(user);
327         userStakeMap[user].index = userList.length.sub(1);
328     }
329 
330     /**
331      * @dev Deletes user's stakes from userStakeMap (keeps the user in userList)
332      */
333     function resetUserStakes(address user) private {
334         // NOTE: decreasing array length will automatically clean up the storage slots occupied by 
335         // the out-of-bounds elements
336         userStakeMap[user].stakes.length = 0;
337         contractSingleStakeSum = contractSingleStakeSum.sub(singleStakeSum[user]);
338         delete singleStakeSum[user];
339     }
340 
341     function addMultiStakeWhitelist(address[] users) onlyOwner public {
342         for (uint256 i = 0; i < users.length; i++) {
343             address user = users[i];
344             if (!userExists(user)) {
345                 addUser(user);
346             }
347         }
348     }
349 
350     function _stake(address user, uint256 amount, uint256 startTime) private {
351         userStakeMap[user].stakes.push(StakeItem(amount, startTime));
352     }
353 
354     /**
355      * @dev Airdrops tokens, in the form of stakes, to multiple users. Note that before calling this
356      * fucntion, the owner should call token.approve() for the transferFrom() to work, as well as
357      * addMultiStakeWhitelist() to register users.
358      */
359     function multiStake(address[] users, uint256[] amounts) onlyOwner public returns (bool) {
360         require(contractClosed == false, "contract closed");
361         require(users.length == amounts.length, "array length mismatch");
362 
363         address emptyAddr = address(0);
364         uint256 amountTotal = 0;
365         for (uint256 i = 0; i < amounts.length; i++) {
366             require(users[i] != emptyAddr, "invalid address");
367             amountTotal = amountTotal.add(amounts[i]);
368         }
369         require(token.transferFrom(msg.sender, address(this), amountTotal), "transferFrom failed");
370 
371         uint256 startTime = block.timestamp;
372         for (uint256 j = 0; j < users.length; j++) {
373             _stake(users[j], amounts[j], startTime);
374         }
375 
376         emit MultiStake(users, amounts, startTime);
377 
378         return true;
379     }
380 
381     /**
382      * @dev Stakes tokens and earn interest. User must first approve this contract for transferring
383      * her tokens.
384      */
385     function stake(uint256 amount) public returns (bool) {
386         require(!reEntrancyMutex, "re-entrancy occurred");
387         require(stakingClosed == false, "staking closed");
388         require(contractClosed == false, "contract closed");
389         require(block.timestamp < closingTime, "past closing time");
390         require(amount > 0, "invalid amount");
391         require(amount.add(singleStakeSum[msg.sender]) <= maxStakingAmountPerUser,
392             "max user staking amount exceeded");
393         require(amount.add(contractSingleStakeSum) <= maxStakingAmountPerContract,
394             "max contract staking amount exceeded");
395         
396         reEntrancyMutex = true;
397         require(token.transferFrom(msg.sender, address(this), amount), "transferFrom failed");
398 
399         if (!userExists(msg.sender)) {
400             addUser(msg.sender);
401         }
402         
403         _stake(msg.sender, amount, block.timestamp);
404         singleStakeSum[msg.sender] = singleStakeSum[msg.sender].add(amount);
405         contractSingleStakeSum = contractSingleStakeSum.add(amount);
406         reEntrancyMutex = false;
407 
408         emit Stake(msg.sender, amount, block.timestamp);
409 
410         return true;
411     }
412 
413     function _unstake(address user) private returns (uint256) {
414         require(!reEntrancyMutex, "re-entrancy occurred");
415         reEntrancyMutex = true;
416         uint256 amount = calcUserStakeAndInterest(user, block.timestamp);
417         require(amount > 0 && amount <= maxUnstakingAmountPerUser, "invalid unstaking amount");
418         resetUserStakes(user);
419         require(token.transfer(user, amount), "transfer failed");
420         reEntrancyMutex = false;
421         return amount;
422     }
423 
424     /**
425      * @dev Unstakes a user's stakes and interest all at once
426      */
427     function unstake() public returns (bool) {
428         require(contractClosed == false, "contract closed");
429         require(userStakeMap[msg.sender].stakes.length > 0, "no stakes");
430         uint256 amount = _unstake(msg.sender);
431         emit Unstake(msg.sender, amount);
432         return true;
433     }
434 }