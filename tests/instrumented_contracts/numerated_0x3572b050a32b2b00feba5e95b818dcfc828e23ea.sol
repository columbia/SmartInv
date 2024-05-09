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
76 abstract contract LAVAContract {
77     function balanceOf(address account) external view virtual returns (uint256);
78     function transfer(address recipient, uint256 amount) external virtual returns (bool);
79     function transferFrom(address sender, address recipient, uint256 amount) external virtual returns (bool);
80 }
81 
82 abstract contract RewardContract {
83     function getLavaUNIv2Balance() external view virtual returns (uint256);
84     function giveLavaUNIv2Reward(address recipient, uint256 amount) external virtual returns (bool);
85 }
86 
87 contract LAVAStaker is Ownable {
88     using SafeMath for uint256;
89 
90     LAVAContract private _lavaContract;                      // lava token contract
91     RewardContract private _rewardContract;                 // reward contract
92 
93     mapping (address => StakerInfo) private _stakeMap;      // map for stakers
94 
95     address private _devWallet;                             // dev wallet address
96     uint256 private _devLastClaimTimestamp;                 // dev wallet address
97     address[] private _stakers;                             // staker's array
98     
99     uint256 private _totalStakedAmount = 0;                // total staked amount
100     uint256 private _minStakeAmount = 1e18;                // min stakable amount
101     
102     uint256 private _rewardPortion = 10;                    // reward portion 10%
103     
104     uint256 private _rewardFee = 98;                        // reward fee 98%, rest for dev 2%
105 
106 
107     struct StakerInfo {
108         uint256 stakedAmount;
109         uint256 lastClaimTimestamp;
110         uint256 rewardAmount;
111     }
112     
113     // Events
114     event Staked(address indexed staker, uint256 amount);
115     event Unstaked(address indexed staker, uint256 amount);
116     event Claim(address indexed staker, uint256 amount);
117     
118     constructor (LAVAContract lavaContract, address devWallet) public {
119         _lavaContract = lavaContract;
120         _devWallet = devWallet;
121         
122     }
123     
124     function stake(uint256 amount) public {
125         require(
126             amount >= _minStakeAmount,
127             "LAVAStaker: stake amount is less than min stake amount."
128         );
129 
130         require(
131             _lavaContract.transferFrom(
132                 _msgSender(),
133                 address(this),
134                 amount
135             ),
136             "LAVAStaker: stake failed."
137         );
138         
139         uint256 currentTimestamp = uint256(now);
140         
141         if(_stakers.length == 0)
142             _devLastClaimTimestamp = currentTimestamp;
143 
144         if(_stakeMap[_msgSender()].stakedAmount == 0 && _stakeMap[_msgSender()].lastClaimTimestamp == 0) {
145             _stakers.push(_msgSender());
146             _stakeMap[_msgSender()].lastClaimTimestamp = currentTimestamp;
147         } else {
148             _stakeMap[_msgSender()].rewardAmount = _stakeMap[_msgSender()].rewardAmount.add(calcReward(_msgSender(), currentTimestamp));
149             _stakeMap[_msgSender()].lastClaimTimestamp = currentTimestamp;
150         }
151             
152         _stakeMap[_msgSender()].stakedAmount = _stakeMap[_msgSender()].stakedAmount.add(amount);
153         _totalStakedAmount = _totalStakedAmount.add(amount);
154         
155         emit Staked(_msgSender(), amount);
156     }
157     
158     function unstake(uint256 amount) public {
159         require(
160             _stakeMap[_msgSender()].stakedAmount >= amount,
161             "LAVAStaker: unstake amount exceededs the staked amount."
162         );
163         
164         uint256 currentTimestamp = uint256(now);
165 
166         _stakeMap[_msgSender()].rewardAmount = _stakeMap[_msgSender()].rewardAmount.add(calcReward(_msgSender(), currentTimestamp));
167         _stakeMap[_msgSender()].lastClaimTimestamp = currentTimestamp;
168         
169         _stakeMap[_msgSender()].stakedAmount = _stakeMap[_msgSender()].stakedAmount.sub(amount);
170         _totalStakedAmount = _totalStakedAmount.sub(amount);
171 
172         require(
173             _lavaContract.transfer(
174                 _msgSender(),
175                 amount
176             ),
177             "LAVAStaker: unstake failed."
178         );
179         
180         if(_stakeMap[_msgSender()].stakedAmount == 0) {
181             _stakeMap[_msgSender()].lastClaimTimestamp = 0;
182             for(uint i=0; i<_stakers.length; i++) {
183                 if(_stakers[i] == _msgSender()) {
184                     _stakers[i] = _stakers[_stakers.length-1];
185                     _stakers.pop();
186                     break;
187                 }
188             }
189         }
190         emit Unstaked(_msgSender(), amount);
191     }
192     
193     function claim() public {
194         uint256 currentTimestamp = uint256(now);
195         uint256 rewardAmount = _stakeMap[_msgSender()].rewardAmount.add(calcReward(_msgSender(), currentTimestamp));
196         _stakeMap[_msgSender()].lastClaimTimestamp = currentTimestamp;
197         
198         require(
199             _rewardContract.giveLavaUNIv2Reward(_msgSender(), rewardAmount),
200             "LAVAStaker: claim failed."
201         );
202         
203         _stakeMap[_msgSender()].rewardAmount = 0;
204 	    emit Claim(_msgSender(), rewardAmount);
205 	    
206 	    if(currentTimestamp.sub(_devLastClaimTimestamp) >= 86400) {
207 	        rewardAmount = calcDevReward(currentTimestamp);
208 	        _devLastClaimTimestamp = currentTimestamp;
209 	        
210 	         require(
211                 _rewardContract.giveLavaUNIv2Reward(_devWallet, rewardAmount),
212                 "LAVAStaker: dev reward claim failed."
213             );
214 	        emit Claim(_devWallet, rewardAmount);
215 	    }
216     }
217     
218     function endStake() external {
219         unstake(_stakeMap[_msgSender()].stakedAmount);
220         claim();
221     }
222     
223     function calcReward(address staker, uint256 currentTimestamp) private view returns (uint256) {
224         if(_totalStakedAmount == 0)
225             return 0;
226         uint256 rewardPoolBalance = _rewardContract.getLavaUNIv2Balance();
227         uint256 passTime = currentTimestamp.sub(_stakeMap[staker].lastClaimTimestamp);
228         uint256 rewardAmountForStakers = rewardPoolBalance.mul(_rewardPortion).div(100).mul(_rewardFee).div(100);
229         uint256 rewardAmount = rewardAmountForStakers.mul(passTime).div(86400).mul(_stakeMap[staker].stakedAmount).div(_totalStakedAmount);
230         return rewardAmount;
231     }
232     
233     function calcDevReward(uint256 currentTimestamp) private view returns (uint256) {
234         uint256 rewardPoolBalance = _rewardContract.getLavaUNIv2Balance();
235         uint256 passTime = currentTimestamp.sub(_devLastClaimTimestamp);
236         uint256 rewardAmount = rewardPoolBalance.mul(_rewardPortion).div(100).mul(uint256(100).sub(_rewardFee)).div(100).mul(passTime).div(86400);
237         return rewardAmount;
238     }
239     
240     /**
241      * Get store wallet
242      */
243     function getRewardContract() external view returns (address) {
244         return address(_rewardContract);
245     }
246      
247     /**
248      * Get total staked amount
249      */
250     function getTotalStakedAmount() external view returns (uint256) {
251         return _totalStakedAmount;
252     }
253     
254     /**
255      * Get reward amount of staker
256      */
257     function getReward(address staker) external view returns (uint256) {
258         return _stakeMap[staker].rewardAmount.add(calcReward(staker, now));
259     }
260     
261     /**
262      * Get reward pool balance (LAVA Uni-V2)
263      */
264     function getRewardPoolBalance() external view returns (uint256) {
265         return _rewardContract.getLavaUNIv2Balance();
266     }
267     
268     /**
269      * Get last claim timestamp
270      */
271     function getLastClaimTimestamp(address staker) external view returns (uint256) {
272         return _stakeMap[staker].lastClaimTimestamp;
273     }
274     
275     /**
276      * Get staked amount of staker
277      */
278     function getStakedAmount(address staker) external view returns (uint256) {
279         return _stakeMap[staker].stakedAmount;
280     }
281     
282     /**
283      * Get min stake amount
284      */
285     function getMinStakeAmount() external view returns (uint256) {
286         return _minStakeAmount;
287     }
288     
289     /**
290      * Get rewards portion
291      */
292     function getRewardPortion() external view returns (uint256) {
293         return _rewardPortion;
294     }
295     
296     /**
297      * Get staker count
298      */
299     function getStakerCount() external view returns (uint256) {
300         return _stakers.length;
301     }
302     
303      /**
304      * Get rewards fee
305      */
306     function getRewardFee() external view returns (uint256) {
307         return _rewardFee;
308     }
309     
310     /**
311      * Get staked rank
312      */
313     function getStakedRank(address staker) external view returns (uint256) {
314         uint256 rank = 1;
315         uint256 senderStakedAmount = _stakeMap[staker].stakedAmount;
316         
317         for(uint i=0; i<_stakers.length; i++) {
318             if(_stakers[i] != staker && senderStakedAmount < _stakeMap[_stakers[i]].stakedAmount)
319                 rank = rank.add(1);
320         }
321         return rank;
322     }
323     
324     /**
325      * Set store wallet contract address
326      */
327     function setRewardContract(RewardContract rewardContract) external onlyOwner returns (bool) {
328         require(address(rewardContract) != address(0), 'LAVAStaker: reward contract address should not be zero address.');
329 
330         _rewardContract = rewardContract;
331         return true;
332     }
333 
334     /**
335      * Set rewards portion in store balance. 
336      * ex: 10 => 10%
337      */
338     function setRewardPortion(uint256 rewardPortion) external onlyOwner returns (bool) {
339         require(rewardPortion >= 10 && rewardPortion <= 100, 'LAVAStaker: reward portion should be in 10 ~ 100.');
340 
341         _rewardPortion = rewardPortion;
342         return true;
343     }
344     
345     /**
346      * Set rewards portion for stakers in rewards amount. 
347      * ex: 98 => 98% (2% for dev)
348      */
349     function setRewardFee(uint256 rewardFee) external onlyOwner returns (bool) {
350         require(rewardFee >= 96 && rewardFee <= 100, 'LAVAStaker: reward fee should be in 96 ~ 100.' );
351 
352         _rewardFee = rewardFee;
353         return true;
354     }
355 }