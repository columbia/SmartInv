1 // "SPDX-License-Identifier: MIT"
2 pragma solidity 0.7.3;
3 
4 abstract contract Context {
5     function _msgSender() internal view returns (address payable) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view returns (bytes memory) {
10         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
11         return msg.data;
12     }
13 }
14 
15 abstract contract Ownable is Context {
16     address private _owner;
17 
18     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20     constructor() {
21         address msgSender = _msgSender();
22         _owner = msgSender;
23         emit OwnershipTransferred(address(0), msgSender);
24     }
25 
26     function owner() public view returns (address) {
27         return _owner;
28     }
29 
30     modifier onlyOwner() {
31         require(_owner == _msgSender(), "Ownable: caller is not the owner");
32         _;
33     }
34 
35     function renounceOwnership() public onlyOwner {
36         emit OwnershipTransferred(_owner, address(0));
37         _owner = address(0);
38     }
39 
40     /**
41      * @dev Transfers ownership of the contract to a new account (`newOwner`).
42      * Can only be called by the current owner.
43      */
44     function transferOwnership(address newOwner) public onlyOwner {
45         require(newOwner != address(0), "Ownable: new owner is the zero address");
46         emit OwnershipTransferred(_owner, newOwner);
47         _owner = newOwner;
48     }
49 }
50 
51 library SafeMath {
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a, "SafeMath: addition overflow");
55 
56         return c;
57     }
58 
59 
60     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61         return sub(a, b, "SafeMath: subtraction overflow");
62     }
63 
64     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
65         require(b <= a, errorMessage);
66         uint256 c = a - b;
67 
68         return c;
69     }
70     
71     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
72         if (a == 0) {
73             return 0;
74         }
75 
76         uint256 c = a * b;
77         require(c / a == b, "SafeMath: multiplication overflow");
78 
79         return c;
80     }
81 
82     function div(uint256 a, uint256 b) internal pure returns (uint256) {
83         return div(a, b, "SafeMath: division by zero");
84     }
85 
86     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
87         require(b > 0, errorMessage);
88         uint256 c = a / b;
89         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
90 
91         return c;
92     }
93 
94     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
95         return mod(a, b, "SafeMath: modulo by zero");
96     }
97 
98     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
99         require(b != 0, errorMessage);
100         return a % b;
101     }
102 }
103 
104 interface IERC20 {
105     function totalSupply() external view returns (uint256);
106 
107     function balanceOf(address account) external view returns (uint256);
108 
109     function transfer(address recipient, uint256 amount) external returns (bool);
110 
111     function allowance(address owner, address spender) external view returns (uint256);
112 
113     function approve(address spender, uint256 amount) external returns (bool);
114 
115     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
116 
117     event Transfer(address indexed from, address indexed to, uint256 value);
118 
119     event Approval(address indexed owner, address indexed spender, uint256 value);
120 }
121 
122 contract EthanolVault is Ownable {
123     using SafeMath for uint;
124     IERC20 public EthanolAddress;
125     address public admin;
126     uint public rewardPool;
127     uint public totalSharedRewards;
128 
129     mapping(address => uint) private rewardsEarned;
130     mapping(address => Savings) private _savings;
131 
132     struct Savings {
133         address user;
134         uint startTime;
135         uint duration;
136         uint amount;
137     }
138 
139     event _LockSavings(
140         address indexed stakeholder, 
141         uint indexed stake,
142         uint indexed unlockTime
143     );
144 
145     event _UnLockSavings(
146         address indexed stakeholder,
147         uint indexed value,
148         uint indexed timestamp
149     );
150 
151     event _RewardShared(
152         uint indexed timestamp,
153         uint indexed rewards
154     );
155 
156     constructor(IERC20 _EthanolAddress) {
157         EthanolAddress = _EthanolAddress;
158         admin = _msgSender();
159     }
160 
161     function shareReward(address[] memory _accounts, uint[] memory _rewards) public {
162         require(_msgSender() == admin, "Caller is not a validator");
163         uint _totalRewards = 0;
164 
165         for(uint i = 0; i < _accounts.length; i++) {
166             address _user = _accounts[i];
167             uint _reward = _rewards[i];
168             _totalRewards = _totalRewards.add(_reward);
169             rewardsEarned[_user] = rewardsEarned[_user].add(_reward);
170         }
171         
172         totalSharedRewards = totalSharedRewards.add(_totalRewards);
173         EthanolAddress.transferFrom(_msgSender(), address(this), _totalRewards);
174         emit _RewardShared(block.timestamp, _totalRewards);
175     }
176 
177     
178     function checkRewards(address _user) public view returns(uint) {
179         return rewardsEarned[_user];
180     }
181     
182     function withdrawRewards(uint _amount) public {
183         require(rewardsEarned[_msgSender()] > 0, "You have zero rewards to claim");
184 
185         rewardsEarned[_msgSender()] = rewardsEarned[_msgSender()].sub(_amount);
186         uint _taxedAmount = _amount.mul(10).div(100);
187         uint _totalBalance = _amount.sub(_taxedAmount);
188         
189         rewardPool = rewardPool.add(_taxedAmount);
190         EthanolAddress.transfer(_msgSender(), _totalBalance);
191     }
192 
193     function monthlySave(uint _numberOfMonths, uint _amount) public {
194         uint _numberOfDays = _numberOfMonths.mul(31 days);
195         timeLock(_numberOfDays, _amount);
196     }
197 
198     function yearlySave(uint _amount) public {
199         uint _numberOfDays = 365 days;
200         timeLock(_numberOfDays, _amount);
201     }
202 
203     function timeLock(uint _duration, uint _amount) private {
204         require(_savings[_msgSender()].amount == 0, "Funds has already been locked");
205         
206         uint _taxAmount = _amount.mul(4).div(100);
207         uint _balance = _amount.sub(_taxAmount);
208 
209         EthanolAddress.transferFrom(_msgSender(), address(this), _amount);
210         
211         rewardPool = rewardPool.add(_taxAmount);
212         _savings[_msgSender()] = Savings(
213             _msgSender(), 
214             block.timestamp, 
215             _duration, 
216             _balance
217         );  
218         emit _LockSavings(_msgSender(), _balance, block.timestamp);             
219     }
220 
221     function releaseTokens() public {
222         require(
223             block.timestamp > _savings[_msgSender()].startTime.add(_savings[_msgSender()].duration), 
224             "Unable to withdraw funds while tokens is still locked"
225         );
226         require(_savings[_msgSender()].amount > 0, "You have zero savings");
227 
228         uint _amount = _savings[_msgSender()].amount;
229         _savings[_msgSender()].amount = 0;
230 
231         
232         if(_savings[_msgSender()].duration >= 365 days) {
233             uint _rewards = _amount.mul(500).div(100);
234             _amount = _amount.add(_rewards);
235             
236         } else {
237             uint _rewards = _amount.mul(40).div(100);
238             uint _numberOfMonths = _savings[_msgSender()].duration.div(31 days);
239             _rewards = _rewards.mul(_numberOfMonths);
240             _amount = _amount.add(_rewards);
241         }
242         
243         rewardPool = rewardPool.sub(_amount);
244         EthanolAddress.transfer(_msgSender(), _amount);
245         emit _UnLockSavings(_msgSender(), _amount, block.timestamp);
246     }
247     
248     function getLockedTokens(address _user) external view returns(uint) {
249         return _savings[_user].amount;
250     }
251 
252     receive() external payable {
253         revert("You can not send token directly to the contract");
254     }
255 }