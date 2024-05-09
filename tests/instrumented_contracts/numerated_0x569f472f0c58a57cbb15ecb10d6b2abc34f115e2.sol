1 pragma solidity ^0.6.0;
2 
3 library SafeMath {
4     function add(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a + b;
6         require(c >= a, "SafeMath: addition overflow");
7         return c;
8     }
9     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
10         return sub(a, b, "SafeMath: subtraction overflow");
11     }
12     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
13         require(b <= a, errorMessage);
14         uint256 c = a - b;
15         return c;
16     }
17     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
19         // benefit is lost if 'b' is also tested.
20         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
21         if (a == 0) {
22             return 0;
23         }
24         uint256 c = a * b;
25         require(c / a == b, "SafeMath: multiplication overflow");
26         return c;
27     }
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         return div(a, b, "SafeMath: division by zero");
30     }
31     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
32         require(b > 0, errorMessage);
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35         return c;
36     }
37     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
38         return mod(a, b, "SafeMath: modulo by zero");
39     }
40     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
41         require(b != 0, errorMessage);
42         return a % b;
43     }
44 }
45 
46 abstract contract Context {
47     function _msgSender() internal view virtual returns (address payable) {
48         return msg.sender;
49     }
50     function _msgData() internal view virtual returns (bytes memory) {
51         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
52         return msg.data;
53     }
54 }
55 
56 contract Ownable is Context {
57     address private _owner;
58     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59     constructor () internal {
60         address msgSender = _msgSender();
61         _owner = msgSender;
62         emit OwnershipTransferred(address(0), msgSender);
63     }
64     function owner() public view returns (address) {
65         return _owner;
66     }
67     modifier onlyOwner() {
68         require(_owner == _msgSender(), "Ownable: caller is not the owner");
69         _;
70     }
71 }
72 
73 abstract contract LiqLpContract {
74     function balanceOf(address account) external view virtual returns (uint256);
75     function transfer(address recipient, uint256 amount) external virtual returns (bool);
76     function transferFrom(address sender, address recipient, uint256 amount) external virtual returns (bool);
77 }
78 
79 abstract contract RewardContract {
80     function getFogBalance() external view virtual returns (uint256);
81     function giveFogReward(address recipient, uint256 amount) external virtual returns (bool);
82 }
83 
84 contract LiqLpStaker is Ownable {
85     using SafeMath for uint256;
86 
87     LiqLpContract private _liqLpContract;                   // Liq UniswapPair token contract
88     RewardContract private _rewardContract;                 // reward contract
89 
90     mapping (address => StakerInfo) private _stakeMap;      // map for stakers
91 
92     address private _devWallet;                             // dev wallet address
93     uint256 private _devLastClaimTimestamp;                 // dev wallet address
94     address[] private _stakers;                             // staker's array
95     
96     uint256 private _totalStakedAmount = 0;                // total staked amount
97     
98     uint256 private _rewardPortion = 10;                    // reward portion 10%
99     
100     uint256 private _rewardFee = 98;                        // reward fee 98%, rest for dev 2%
101 
102     
103     struct StakerInfo {
104         uint256 stakedAmount;
105         uint256 lastClaimTimestamp;
106         uint256 rewardAmount;
107     }
108     
109     // Events
110     event Staked(address indexed staker, uint256 amount);
111     event Unstaked(address indexed staker, uint256 amount);
112     event Claim(address indexed staker, uint256 amount);
113     
114     constructor (LiqLpContract liqLpContract, address devWallet) public {
115         _liqLpContract = liqLpContract;
116         _devWallet = devWallet;
117         
118     }
119     
120     function stake(uint256 amount) public {
121       
122         require(
123             _liqLpContract.transferFrom(
124                 _msgSender(),
125                 address(this),
126                 amount
127             ),
128             "liqLpStaker: stake failed."
129         );
130         
131         uint256 StakedAmount = amount;
132         uint256 currentTimestamp = uint256(now);
133         
134         if(_stakers.length == 0)
135             _devLastClaimTimestamp = currentTimestamp;
136 
137         if(_stakeMap[_msgSender()].stakedAmount == 0) {
138             _stakers.push(_msgSender());
139             _stakeMap[_msgSender()].lastClaimTimestamp = currentTimestamp;
140         } else {
141             _stakeMap[_msgSender()].rewardAmount = _stakeMap[_msgSender()].rewardAmount.add(calcReward(_msgSender(), currentTimestamp));
142             _stakeMap[_msgSender()].lastClaimTimestamp = currentTimestamp;
143         }
144             
145         _stakeMap[_msgSender()].stakedAmount = _stakeMap[_msgSender()].stakedAmount.add(StakedAmount);
146         _totalStakedAmount = _totalStakedAmount.add(amount);
147         
148         emit Staked(_msgSender(), StakedAmount);
149     }
150     
151     function unstake(uint256 amount) public {
152         require(
153             _stakeMap[_msgSender()].stakedAmount >= amount,
154             "LiqLpStaker: unstake amount exceededs the staked amount."
155         );
156 
157         uint256 currentTimestamp = uint256(now);
158 
159         _stakeMap[_msgSender()].rewardAmount = _stakeMap[_msgSender()].rewardAmount.add(calcReward(_msgSender(), currentTimestamp));
160         _stakeMap[_msgSender()].lastClaimTimestamp = currentTimestamp;
161         
162         _stakeMap[_msgSender()].stakedAmount = _stakeMap[_msgSender()].stakedAmount.sub(amount);
163         _totalStakedAmount = _totalStakedAmount.sub(amount);
164         
165         require(
166             _liqLpContract.transfer(
167                 _msgSender(),
168                 amount
169             ),
170             "LiqLpStaker: unstake failed."
171         );
172 
173         if(_stakeMap[_msgSender()].stakedAmount == 0) {
174             _stakeMap[_msgSender()].lastClaimTimestamp = 0;
175             for(uint i=0; i<_stakers.length; i++) {
176                 if(_stakers[i] == _msgSender()) {
177                     _stakers[i] = _stakers[_stakers.length-1];
178                     _stakers.pop();
179                     break;
180                 }
181             }
182         }
183         emit Unstaked(_msgSender(), amount);
184     }
185     
186     function claim() public {
187         uint256 currentTimestamp = uint256(now);
188         uint256 rewardAmount = _stakeMap[_msgSender()].rewardAmount.add(calcReward(_msgSender(), currentTimestamp));
189         _stakeMap[_msgSender()].lastClaimTimestamp = currentTimestamp;
190         
191         require(
192             _rewardContract.giveFogReward(_msgSender(), rewardAmount),
193             "LiqLpStaker: claim failed."
194         );
195         
196         _stakeMap[_msgSender()].rewardAmount = 0;
197 	    emit Claim(_msgSender(), rewardAmount);
198 	    
199 	    if(currentTimestamp.sub(_devLastClaimTimestamp) >= 86400) {
200 	        rewardAmount = calcDevReward(currentTimestamp);
201 	        _devLastClaimTimestamp = currentTimestamp;
202 	        
203 	         require(
204                 _rewardContract.giveFogReward(_devWallet, rewardAmount),
205                 "LiqLpStaker: dev reward claim failed."
206             );
207 	        emit Claim(_devWallet, rewardAmount);
208 	    }
209     }
210     
211     function endStake() external {
212         unstake(_stakeMap[_msgSender()].stakedAmount);
213         claim();
214     }
215     
216     function calcReward(address staker, uint256 currentTimestamp) private view returns (uint256) {
217         if(_totalStakedAmount == 0)
218             return 0;
219         uint256 rewardPoolBalance = _rewardContract.getFogBalance();
220         uint256 passTime = currentTimestamp.sub(_stakeMap[staker].lastClaimTimestamp);
221         uint256 rewardAmountForStakers = rewardPoolBalance.mul(_rewardPortion).div(100).mul(_rewardFee).div(100);
222         uint256 rewardAmount = rewardAmountForStakers.mul(passTime).div(86400).mul(_stakeMap[staker].stakedAmount).div(_totalStakedAmount);
223         return rewardAmount;
224     }
225     
226     function calcDevReward(uint256 currentTimestamp) private view returns (uint256) {
227         uint256 rewardPoolBalance = _rewardContract.getFogBalance();
228         uint256 passTime = currentTimestamp.sub(_devLastClaimTimestamp);
229         uint256 rewardAmount = rewardPoolBalance.mul(_rewardPortion).div(100).mul(uint256(100).sub(_rewardFee)).div(100).mul(passTime).div(86400);
230         return rewardAmount;
231     }
232 
233     /**
234      * Get store wallet
235      */
236     function getRewardContract() external view returns (address) {
237         return address(_rewardContract);
238     }
239      
240     /**
241      * Get total staked amount
242      */
243     function getTotalStakedAmount() external view returns (uint256) {
244         return _totalStakedAmount;
245     }
246     
247     /**
248      * Get reward amount of staker
249      */
250     function getReward(address staker) external view returns (uint256) {
251         return _stakeMap[staker].rewardAmount.add(calcReward(staker, now));
252     }
253     
254     /**
255      * Get reward pool balance (LAVA)
256      */
257     function getRewardPoolBalance() external view returns (uint256) {
258         return _rewardContract.getFogBalance();
259     }
260     
261     /**
262      * Get last claim timestamp
263      */
264     function getLastClaimTimestamp(address staker) external view returns (uint256) {
265         return _stakeMap[staker].lastClaimTimestamp;
266     }
267     
268     /**
269      * Get staked amount of staker
270      */
271     function getStakedAmount(address staker) external view returns (uint256) {
272         return _stakeMap[staker].stakedAmount;
273     }
274     
275     /**
276      * Get rewards portion
277      */
278     function getRewardPortion() external view returns (uint256) {
279         return _rewardPortion;
280     }
281     
282     /**
283      * Get staker count
284      */
285     function getStakerCount() external view returns (uint256) {
286         return _stakers.length;
287     }
288     
289      /**
290      * Get rewards fee
291      */
292     function getRewardFee() external view returns (uint256) {
293         return _rewardFee;
294     }
295     
296     /**
297      * Get staked rank
298      */
299     function getStakedRank(address staker) external view returns (uint256) {
300         uint256 rank = 1;
301         uint256 senderStakedAmount = _stakeMap[staker].stakedAmount;
302         
303         for(uint i=0; i<_stakers.length; i++) {
304             if(_stakers[i] != staker && senderStakedAmount < _stakeMap[_stakers[i]].stakedAmount)
305                 rank = rank.add(1);
306         }
307         return rank;
308     }
309     
310     /**
311      * Set store wallet contract address
312      */
313     function setRewardContract(RewardContract rewardContract) external onlyOwner returns (bool) {
314         require(address(rewardContract) != address(0), 'LiqLpStaker: reward contract address should not be zero address.');
315 
316         _rewardContract = rewardContract;
317         return true;
318     }
319 
320     /**
321      * Set rewards portion in store balance. 
322      * ex: 10 => 10%
323      */
324     function setRewardPortion(uint256 rewardPortion) external onlyOwner returns (bool) {
325         require(rewardPortion >= 10 && rewardPortion <= 100, 'LiqLpStaker: reward portion should be in 10 ~ 100.');
326 
327         _rewardPortion = rewardPortion;
328         return true;
329     }
330     
331     /**
332      * Set rewards portion for stakers in rewards amount. 
333      * ex: 98 => 98% (2% for dev)
334      */
335     function setRewardFee(uint256 rewardFee) external onlyOwner returns (bool) {
336         require(rewardFee >= 96 && rewardFee <= 100, 'LiqLpStaker: reward fee should be in 96 ~ 100.' );
337 
338         _rewardFee = rewardFee;
339         return true;
340     }
341 }