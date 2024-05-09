1 // SPDX-License-Identifier: MIT
2 
3 
4 pragma solidity ^0.6.0;
5 
6 library SafeMath {
7     function add(uint256 a, uint256 b) internal pure returns (uint256) {
8         uint256 c = a + b;
9         require(c >= a, "SafeMath: addition overflow");
10         return c;
11     }
12     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
13         return sub(a, b, "SafeMath: subtraction overflow");
14     }
15     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
16         require(b <= a, errorMessage);
17         uint256 c = a - b;
18         return c;
19     }
20     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
22         // benefit is lost if 'b' is also tested.
23         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
24         if (a == 0) {
25             return 0;
26         }
27         uint256 c = a * b;
28         require(c / a == b, "SafeMath: multiplication overflow");
29         return c;
30     }
31     function div(uint256 a, uint256 b) internal pure returns (uint256) {
32         return div(a, b, "SafeMath: division by zero");
33     }
34     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
35         require(b > 0, errorMessage);
36         uint256 c = a / b;
37         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38         return c;
39     }
40     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
41         return mod(a, b, "SafeMath: modulo by zero");
42     }
43     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
44         require(b != 0, errorMessage);
45         return a % b;
46     }
47 }
48 
49 abstract contract Context {
50     function _msgSender() internal view virtual returns (address payable) {
51         return msg.sender;
52     }
53     function _msgData() internal view virtual returns (bytes memory) {
54         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
55         return msg.data;
56     }
57 }
58 
59 contract Ownable is Context {
60     address private _owner;
61     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62     constructor () internal {
63         address msgSender = _msgSender();
64         _owner = msgSender;
65         emit OwnershipTransferred(address(0), msgSender);
66     }
67     function owner() public view returns (address) {
68         return _owner;
69     }
70     modifier onlyOwner() {
71         require(_owner == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 }
75 
76 interface BSKToken {
77     function balanceOf(address owner) external view returns (uint);
78     function transfer(address to, uint value) external returns (bool);
79     function transferFrom(address from, address to, uint value) external returns (bool);
80 }
81 
82 abstract contract RewardContract {
83     function getBalance() external view virtual returns (uint256);
84     function giveReward(address recipient, uint256 amount) external virtual returns (bool);
85 }
86 
87 contract BSKTStaker is Ownable {
88     using SafeMath for uint256;
89 
90     BSKToken public immutable _bskToken;    		        // BSKT contract
91     RewardContract public _rewardContract;                  // reward contract
92 
93     mapping (address => StakerInfo) private _stakeMap;      // map for stakers
94 
95     address[] private _stakers;                             // staker's array
96     
97     uint256 private _totalStakedAmount = 0;                 // total staked amount
98     uint256 private _minStakeAmount = 10000e18;             // min stakable amount
99     
100     uint256 private _rewardPortion = 10;                    // reward portion 10%
101     
102     struct StakerInfo {
103         uint256 stakedAmount;
104         uint256 rewardAmount;
105         uint256 lastClaimTimestamp;
106     }
107     
108     // Events
109     event Staked(address staker, uint256 amount);
110     event Unstaked(address staker, uint256 amount);
111     event Claim(address staker, uint256 amount);
112     
113     constructor (BSKToken bskToken) public {
114         _bskToken = bskToken;
115         
116     }
117     
118     function stake(uint256 amount) public {
119         require(
120             amount >= _minStakeAmount,
121             "BSKTStaker: stake amount is less than min stake amount."
122         );
123 
124         uint256 initialBalance = _bskToken.balanceOf(address(this));
125         
126         require(
127             _bskToken.transferFrom(
128                 _msgSender(),
129                 address(this),
130                 amount
131             ),
132             "BSKTStaker: stake failed."
133         );
134 
135         uint256 realStakedAmount = _bskToken.balanceOf(address(this)).sub(initialBalance);
136         uint256 currentTimestamp = uint256(now);
137 
138         if(_stakeMap[_msgSender()].stakedAmount == 0)
139             _stakers.push(_msgSender());
140         else
141             _stakeMap[_msgSender()].rewardAmount = calcReward(_msgSender(), currentTimestamp);
142         _stakeMap[_msgSender()].lastClaimTimestamp = currentTimestamp;
143             
144         _stakeMap[_msgSender()].stakedAmount = _stakeMap[_msgSender()].stakedAmount.add(realStakedAmount);
145         _totalStakedAmount = _totalStakedAmount.add(realStakedAmount);
146         
147         emit Staked(_msgSender(), realStakedAmount);
148     }
149     
150     function unstake(uint256 amount) public {
151         require(
152             _stakeMap[_msgSender()].stakedAmount >= amount,
153             "BSKTStaker: unstake amount exceededs the staked amount."
154         );
155 
156         uint256 currentTimestamp = uint256(now);
157         _stakeMap[_msgSender()].rewardAmount = calcReward(_msgSender(), currentTimestamp);
158         _stakeMap[_msgSender()].lastClaimTimestamp = currentTimestamp;
159         _stakeMap[_msgSender()].stakedAmount = _stakeMap[_msgSender()].stakedAmount.sub(amount);
160         _totalStakedAmount = _totalStakedAmount.sub(amount);
161 
162         require(
163             _bskToken.transfer(
164                 _msgSender(),
165                 amount
166             ),
167             "BSKTStaker: unstake failed."
168         );
169         
170         if(_stakeMap[_msgSender()].stakedAmount == 0) {
171             for(uint i=0; i<_stakers.length; i++) {
172                 if(_stakers[i] == _msgSender()) {
173                     _stakers[i] = _stakers[_stakers.length-1];
174                     _stakers.pop();
175                     break;
176                 }
177             }
178         }
179         emit Unstaked(_msgSender(), amount);
180     }
181     
182     function claim() public {
183         uint256 currentTimestamp = uint256(now);
184         uint256 rewardAmount = calcReward(_msgSender(), currentTimestamp);
185         _stakeMap[_msgSender()].lastClaimTimestamp = currentTimestamp;
186         _stakeMap[_msgSender()].rewardAmount = 0;
187         
188         require(
189             _rewardContract.giveReward(_msgSender(), rewardAmount),
190             "BSKTStaker: claim failed."
191         );
192         
193 	    emit Claim(_msgSender(), rewardAmount);
194     }
195     
196     function endStake() external {
197         unstake(_stakeMap[_msgSender()].stakedAmount);
198         claim();
199     }
200     
201     function calcReward(address account, uint256 currentTimestamp) internal view returns (uint256) {
202         if(_totalStakedAmount == 0)
203             return 0;
204         uint256 rewardPoolBalance = _rewardContract.getBalance();
205         uint256 passTime = currentTimestamp.sub(_stakeMap[account].lastClaimTimestamp);
206         uint256 rewardAmountForStakers = rewardPoolBalance.mul(_rewardPortion).div(100);
207         uint256 rewardAmount = rewardAmountForStakers.mul(passTime).div(86400).mul(_stakeMap[account].stakedAmount).div(_totalStakedAmount);
208         return _stakeMap[account].rewardAmount.add(rewardAmount);
209     }
210     
211     /**
212      * Get store wallet
213      */
214     function getRewardContract() external view returns (address) {
215         return address(_rewardContract);
216     }
217      
218     /**
219      * Get total staked amount
220      */
221     function getTotalStakedAmount() external view returns (uint256) {
222         return _totalStakedAmount;
223     }
224     
225     /**
226      * Get reward amount of staker
227      */
228     function getReward(address account) external view returns (uint256) {
229         return calcReward(account, now);
230     }
231     
232     /**
233      * Get reward pool balance (LAVA)
234      */
235     function getRewardPoolBalance() external view returns (uint256) {
236         return _rewardContract.getBalance();
237     }
238     
239     /**
240      * Get last claim timestamp
241      */
242     function getLastClaimTimestamp() external view returns (uint256) {
243         return _stakeMap[_msgSender()].lastClaimTimestamp;
244     }
245     
246     /**
247      * Get staked amount of staker
248      */
249     function getStakedAmount(address staker) external view returns (uint256) {
250         return _stakeMap[staker].stakedAmount;
251     }
252     
253     /**
254      * Get min stake amount
255      */
256     function getMinStakeAmount() external view returns (uint256) {
257         return _minStakeAmount;
258     }
259     
260     /**
261      * Get rewards portion
262      */
263     function getRewardPortion() external view returns (uint256) {
264         return _rewardPortion;
265     }
266     
267     /**
268      * Get staker count
269      */
270     function getStakerCount() external view returns (uint256) {
271         return _stakers.length;
272     }
273 
274     /**
275      * Get staked rank
276      */
277     function getStakedRank(address account) external view returns (uint256) {
278         uint256 rank = 1;
279         uint256 senderStakedAmount = _stakeMap[account].stakedAmount;
280         
281         for(uint i=0; i<_stakers.length; i++) {
282             if(_stakers[i] != account && senderStakedAmount < _stakeMap[_stakers[i]].stakedAmount)
283                 rank = rank.add(1);
284         }
285         return rank;
286     }
287     
288     /**
289      * Set store wallet contract address
290      */
291     function setRewardContract(RewardContract rewardContract) external onlyOwner returns (bool) {
292         require(address(rewardContract) != address(0), 'BSKTStaker: reward contract address should not be zero address.');
293 
294         _rewardContract = rewardContract;
295         return true;
296     }
297 
298     /**
299      * Set rewards portion in store balance. 
300      */
301     function setRewardPortion(uint256 rewardPortion) external onlyOwner returns (bool) {
302         require(rewardPortion >= 10 && rewardPortion <= 100, 'BSKTStaker: reward portion should be in 10 ~ 100.');
303 
304         _rewardPortion = rewardPortion;
305         return true;
306     }
307 }