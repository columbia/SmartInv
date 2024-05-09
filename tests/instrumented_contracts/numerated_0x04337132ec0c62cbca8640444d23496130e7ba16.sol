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
76 abstract contract MOLContract {
77     function balanceOf(address account) external view virtual returns (uint256);
78     function transfer(address recipient, uint256 amount) external virtual returns (bool);
79     function transferFrom(address sender, address recipient, uint256 amount) external virtual returns (bool);
80 }
81 
82 abstract contract RewardContract {
83     function getLavaBalance() external view virtual returns (uint256);
84     function giveLavaReward(address recipient, uint256 amount) external virtual returns (bool);
85 }
86 
87 contract MOLStaker is Ownable {
88     using SafeMath for uint256;
89 
90     MOLContract private _molContract;                       // mol token contract
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
106     uint256 private _taxFee = 3;                            // tax fee for transaction
107     
108     struct StakerInfo {
109         uint256 stakedAmount;
110         uint256 lastClaimTimestamp;
111         uint256 rewardAmount;
112     }
113     
114     // Events
115     event Staked(address indexed staker, uint256 amount);
116     event Unstaked(address indexed staker, uint256 amount);
117     event Claim(address indexed staker, uint256 amount);
118     
119     constructor (MOLContract molContract, address devWallet) public {
120         _molContract = molContract;
121         _devWallet = devWallet;
122         
123     }
124     
125     function stake(uint256 amount) public {
126         require(
127             amount >= _minStakeAmount,
128             "MOLStaker: stake amount is less than min stake amount."
129         );
130 
131         require(
132             _molContract.transferFrom(
133                 _msgSender(),
134                 address(this),
135                 amount
136             ),
137             "MOLStaker: stake failed."
138         );
139         
140         uint256 taxAmount = amount.mul(_taxFee).div(100);
141         uint256 realStakedAmount = amount.sub(taxAmount);
142         uint256 currentTimestamp = uint256(now);
143         
144         if(_stakers.length == 0)
145             _devLastClaimTimestamp = currentTimestamp;
146 
147         if(_stakeMap[_msgSender()].stakedAmount == 0) {
148             _stakers.push(_msgSender());
149             _stakeMap[_msgSender()].lastClaimTimestamp = currentTimestamp;
150         } else {
151             _stakeMap[_msgSender()].rewardAmount = _stakeMap[_msgSender()].rewardAmount.add(calcReward(_msgSender(), currentTimestamp));
152             _stakeMap[_msgSender()].lastClaimTimestamp = currentTimestamp;
153         }
154             
155         _stakeMap[_msgSender()].stakedAmount = _stakeMap[_msgSender()].stakedAmount.add(realStakedAmount);
156         _totalStakedAmount = _totalStakedAmount.add(realStakedAmount);
157         
158         emit Staked(_msgSender(), realStakedAmount);
159     }
160     
161     function unstake(uint256 amount) public {
162         require(
163             _stakeMap[_msgSender()].stakedAmount >= amount,
164             "MOLStaker: unstake amount exceededs the staked amount."
165         );
166 
167         uint256 currentTimestamp = uint256(now);
168 
169         _stakeMap[_msgSender()].rewardAmount = _stakeMap[_msgSender()].rewardAmount.add(calcReward(_msgSender(), currentTimestamp));
170         _stakeMap[_msgSender()].lastClaimTimestamp = currentTimestamp;
171         
172         _stakeMap[_msgSender()].stakedAmount = _stakeMap[_msgSender()].stakedAmount.sub(amount);
173         _totalStakedAmount = _totalStakedAmount.sub(amount);
174         
175         require(
176             _molContract.transfer(
177                 _msgSender(),
178                 amount
179             ),
180             "MOLStaker: unstake failed."
181         );
182 
183         if(_stakeMap[_msgSender()].stakedAmount == 0) {
184             _stakeMap[_msgSender()].lastClaimTimestamp = 0;
185             for(uint i=0; i<_stakers.length; i++) {
186                 if(_stakers[i] == _msgSender()) {
187                     _stakers[i] = _stakers[_stakers.length-1];
188                     _stakers.pop();
189                     break;
190                 }
191             }
192         }
193         emit Unstaked(_msgSender(), amount);
194     }
195     
196     function claim() public {
197         uint256 currentTimestamp = uint256(now);
198         uint256 rewardAmount = _stakeMap[_msgSender()].rewardAmount.add(calcReward(_msgSender(), currentTimestamp));
199         _stakeMap[_msgSender()].lastClaimTimestamp = currentTimestamp;
200         
201         require(
202             _rewardContract.giveLavaReward(_msgSender(), rewardAmount),
203             "MOLStaker: claim failed."
204         );
205         
206         _stakeMap[_msgSender()].rewardAmount = 0;
207 	    emit Claim(_msgSender(), rewardAmount);
208 	    
209 	    if(currentTimestamp.sub(_devLastClaimTimestamp) >= 86400) {
210 	        rewardAmount = calcDevReward(currentTimestamp);
211 	        _devLastClaimTimestamp = currentTimestamp;
212 	        
213 	         require(
214                 _rewardContract.giveLavaReward(_devWallet, rewardAmount),
215                 "MOLStaker: dev reward claim failed."
216             );
217 	        emit Claim(_devWallet, rewardAmount);
218 	    }
219     }
220     
221     function endStake() external {
222         unstake(_stakeMap[_msgSender()].stakedAmount);
223         claim();
224     }
225     
226     function calcReward(address staker, uint256 currentTimestamp) private view returns (uint256) {
227         if(_totalStakedAmount == 0)
228             return 0;
229         uint256 rewardPoolBalance = _rewardContract.getLavaBalance();
230         uint256 passTime = currentTimestamp.sub(_stakeMap[staker].lastClaimTimestamp);
231         uint256 rewardAmountForStakers = rewardPoolBalance.mul(_rewardPortion).div(100).mul(_rewardFee).div(100);
232         uint256 rewardAmount = rewardAmountForStakers.mul(passTime).div(86400).mul(_stakeMap[staker].stakedAmount).div(_totalStakedAmount);
233         return rewardAmount;
234     }
235     
236     function calcDevReward(uint256 currentTimestamp) private view returns (uint256) {
237         uint256 rewardPoolBalance = _rewardContract.getLavaBalance();
238         uint256 passTime = currentTimestamp.sub(_devLastClaimTimestamp);
239         uint256 rewardAmount = rewardPoolBalance.mul(_rewardPortion).div(100).mul(uint256(100).sub(_rewardFee)).div(100).mul(passTime).div(86400);
240         return rewardAmount;
241     }
242 
243     /**
244      * Get store wallet
245      */
246     function getRewardContract() external view returns (address) {
247         return address(_rewardContract);
248     }
249      
250     /**
251      * Get total staked amount
252      */
253     function getTotalStakedAmount() external view returns (uint256) {
254         return _totalStakedAmount;
255     }
256     
257     /**
258      * Get reward amount of staker
259      */
260     function getReward(address staker) external view returns (uint256) {
261         return _stakeMap[staker].rewardAmount.add(calcReward(staker, now));
262     }
263     
264     /**
265      * Get reward pool balance (LAVA)
266      */
267     function getRewardPoolBalance() external view returns (uint256) {
268         return _rewardContract.getLavaBalance();
269     }
270     
271     /**
272      * Get last claim timestamp
273      */
274     function getLastClaimTimestamp(address staker) external view returns (uint256) {
275         return _stakeMap[staker].lastClaimTimestamp;
276     }
277     
278     /**
279      * Get staked amount of staker
280      */
281     function getStakedAmount(address staker) external view returns (uint256) {
282         return _stakeMap[staker].stakedAmount;
283     }
284     
285     /**
286      * Get min stake amount
287      */
288     function getMinStakeAmount() external view returns (uint256) {
289         return _minStakeAmount;
290     }
291     
292     /**
293      * Get rewards portion
294      */
295     function getRewardPortion() external view returns (uint256) {
296         return _rewardPortion;
297     }
298     
299     /**
300      * Get staker count
301      */
302     function getStakerCount() external view returns (uint256) {
303         return _stakers.length;
304     }
305     
306      /**
307      * Get rewards fee
308      */
309     function getRewardFee() external view returns (uint256) {
310         return _rewardFee;
311     }
312     
313     /**
314      * Get staked rank
315      */
316     function getStakedRank(address staker) external view returns (uint256) {
317         uint256 rank = 1;
318         uint256 senderStakedAmount = _stakeMap[staker].stakedAmount;
319         
320         for(uint i=0; i<_stakers.length; i++) {
321             if(_stakers[i] != staker && senderStakedAmount < _stakeMap[_stakers[i]].stakedAmount)
322                 rank = rank.add(1);
323         }
324         return rank;
325     }
326     
327     /**
328      * Set store wallet contract address
329      */
330     function setRewardContract(RewardContract rewardContract) external onlyOwner returns (bool) {
331         require(address(rewardContract) != address(0), 'MOLStaker: reward contract address should not be zero address.');
332 
333         _rewardContract = rewardContract;
334         return true;
335     }
336 
337     /**
338      * Set rewards portion in store balance. 
339      * ex: 10 => 10%
340      */
341     function setRewardPortion(uint256 rewardPortion) external onlyOwner returns (bool) {
342         require(rewardPortion >= 10 && rewardPortion <= 100, 'MOLStaker: reward portion should be in 10 ~ 100.');
343 
344         _rewardPortion = rewardPortion;
345         return true;
346     }
347     
348     /**
349      * Set rewards portion for stakers in rewards amount. 
350      * ex: 98 => 98% (2% for dev)
351      */
352     function setRewardFee(uint256 rewardFee) external onlyOwner returns (bool) {
353         require(rewardFee >= 96 && rewardFee <= 100, 'MOLStaker: reward fee should be in 96 ~ 100.' );
354 
355         _rewardFee = rewardFee;
356         return true;
357     }
358 }