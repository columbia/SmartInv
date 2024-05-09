1 pragma solidity ^0.5.0;
2 
3 library Math {
4     function max(uint256 a, uint256 b) internal pure returns (uint256) {
5         return a >= b ? a : b;
6     }
7 
8     function min(uint256 a, uint256 b) internal pure returns (uint256) {
9         return a < b ? a : b;
10     }
11 
12     function average(uint256 a, uint256 b) internal pure returns (uint256) {
13         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
14     }
15 }
16 
17 library SafeMath {
18     function add(uint256 a, uint256 b) internal pure returns (uint256) {
19         uint256 c = a + b;
20         require(c >= a, "SafeMath: addition overflow");
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         return sub(a, b, "SafeMath: subtraction overflow");
26     }
27 
28     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
29         require(b <= a, errorMessage);
30         uint256 c = a - b;
31 
32         return c;
33     }
34 
35     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
36         if (a == 0) {
37             return 0;
38         }
39 
40         uint256 c = a * b;
41         require(c / a == b, "SafeMath: multiplication overflow");
42 
43         return c;
44     }
45 
46     function div(uint256 a, uint256 b) internal pure returns (uint256) {
47         return div(a, b, "SafeMath: division by zero");
48     }
49 
50     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
51         require(b > 0, errorMessage);
52         uint256 c = a / b;
53         return c;
54     }
55 
56     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
57         return mod(a, b, "SafeMath: modulo by zero");
58     }
59 
60     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b != 0, errorMessage);
62         return a % b;
63     }
64 }
65 
66 contract Context {
67     constructor () internal { }
68 
69     function _msgSender() internal view returns (address payable) {
70         return msg.sender;
71     }
72 
73     function _msgData() internal view returns (bytes memory) {
74         this;
75         return msg.data;
76     }
77 }
78 
79 contract Ownable is Context {
80     address private _owner;
81 
82     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
83 
84     constructor () internal {
85         _owner = _msgSender();
86         emit OwnershipTransferred(address(0), _owner);
87     }
88 
89     function owner() public view returns (address) {
90         return _owner;
91     }
92 
93     modifier onlyOwner() {
94         require(isOwner(), "Ownable: caller is not the owner");
95         _;
96     }
97 
98     function isOwner() public view returns (bool) {
99         return _msgSender() == _owner;
100     }
101 
102     function renounceOwnership() public onlyOwner {
103         emit OwnershipTransferred(_owner, address(0));
104         _owner = address(0);
105     }
106 
107     function transferOwnership(address newOwner) public onlyOwner {
108         _transferOwnership(newOwner);
109     }
110 
111     function _transferOwnership(address newOwner) internal {
112         require(newOwner != address(0), "Ownable: new owner is the zero address");
113         emit OwnershipTransferred(_owner, newOwner);
114         _owner = newOwner;
115     }
116 }
117 
118 interface IERC20 {
119     function totalSupply() external view returns (uint256);
120     function balanceOf(address account) external view returns (uint256);
121     function transfer(address recipient, uint256 amount) external returns (bool);
122     function mint(address account, uint amount) external;
123     function allowance(address owner, address spender) external view returns (uint256);
124     function approve(address spender, uint256 amount) external returns (bool);
125     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
126     event Transfer(address indexed from, address indexed to, uint256 value);
127     event Approval(address indexed owner, address indexed spender, uint256 value);
128 }
129 
130 library Address {
131     function toPayable(address account) internal pure returns (address payable) {
132         return address(uint160(account));
133     }
134 
135     function sendValue(address payable recipient, uint256 amount) internal {
136         require(address(this).balance >= amount, "Address: insufficient balance");
137 
138         // solhint-disable-next-line avoid-call-value
139         (bool success, ) = recipient.call.value(amount)("");
140         require(success, "Address: unable to send value, recipient may have reverted");
141     }
142 }
143 
144 contract IRewardDistributionRecipient is Ownable {
145     address rewardDistribution;
146 
147     function notifyRewardAmount(uint256 reward) external;
148 
149     modifier onlyRewardDistribution() {
150         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
151         _;
152     }
153 
154     function setRewardDistribution(address _rewardDistribution)
155     external
156     onlyOwner
157     {
158         rewardDistribution = _rewardDistribution;
159     }
160 }
161 
162 
163 contract PegsTokenWrapper {
164     using SafeMath for uint256;
165 
166     IERC20 public pegs;
167 
168     uint256 private _totalSupply;
169     mapping(address => uint256) private _balances;
170 
171     function totalSupply() public view returns (uint256) {
172         return _totalSupply;
173     }
174 
175     function balanceOf(address account) public view returns (uint256) {
176         return _balances[account];
177     }
178 
179     function stake(uint256 amount) public {
180         pegs.transferFrom(msg.sender, address(this), amount);
181         _totalSupply = _totalSupply.add(amount);
182         _balances[msg.sender] = _balances[msg.sender].add(amount);
183     }
184 
185     function withdraw(uint256 amount) public {
186         _totalSupply = _totalSupply.sub(amount);
187         _balances[msg.sender] = _balances[msg.sender].sub(amount);
188         pegs.transfer(msg.sender, amount);
189     }
190 }
191 
192 contract PusdRewardAssign is PegsTokenWrapper, IRewardDistributionRecipient {
193     // IERC20 public pusd;
194     address public pusd;
195     address public pusdReward;
196     uint256 public DURATION = 24 hours;
197 
198     uint256 public initreward = 0;
199     uint256 public starttime = 1610236800;
200     uint256 public periodFinish = 1619827200;
201     uint256 public rewardRate = 0;
202     uint256 public lastUpdateTime;
203     uint256 public rewardPerTokenStored;
204     mapping(address => uint256) public userRewardPerTokenPaid;
205     mapping(address => uint256) public rewards;
206     mapping(address => uint256) public totalRewards;
207     
208 
209     event RewardAdded(uint256 reward);
210     event Staked(address indexed user, uint256 amount);
211     event Withdrawn(address indexed user, uint256 amount);
212     event RewardPaid(address indexed user, uint256 reward);
213 
214     modifier updateReward(address account) {
215         rewardPerTokenStored = rewardPerToken();
216         lastUpdateTime = lastTimeRewardApplicable();
217         if (account != address(0)) {
218             rewards[account] = earned(account);
219             userRewardPerTokenPaid[account] = rewardPerTokenStored;
220         }
221         _;
222     }
223 
224     constructor(address _lockToken, address _mintToken,address _pusdReward, uint _startTime, uint256 _duration) public {
225         starttime = _startTime;
226         DURATION = _duration;
227         periodFinish = starttime.add(DURATION);
228         pusd = _mintToken;
229         pusdReward = _pusdReward;
230         pegs = IERC20(_lockToken);
231     }
232 
233     function lastTimeRewardApplicable() public view returns (uint256) {
234         return Math.min(block.timestamp, periodFinish);
235     }
236 
237     function rewardPerToken() public view returns (uint256) {
238         if (totalSupply() == 0) {
239             return rewardPerTokenStored;
240         }
241         return
242         rewardPerTokenStored.add(
243             lastTimeRewardApplicable()
244             .sub(lastUpdateTime)
245             .mul(rewardRate)
246             .mul(1e18)
247             .div(totalSupply())
248         );
249     }
250 
251     function earned(address account) public view returns (uint256) {
252         return
253         balanceOf(account)
254         .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
255         .div(1e18)
256         .add(rewards[account]);
257     }
258 
259     function stake(uint256 amount) public updateReward(msg.sender)  checkStart{
260         require(amount > 0, "Cannot stake 0");
261         super.stake(amount);
262         emit Staked(msg.sender, amount);
263     }
264     
265     function withdraw(uint256 amount) public updateReward(msg.sender)  checkStart{
266         require(amount > 0, "Cannot withdraw 0");
267         require(balanceOf(msg.sender)>=amount, "Insufficient balance!");
268         super.withdraw(amount);
269         emit Withdrawn(msg.sender, amount);
270     }
271 
272     function exit() external {
273         withdraw(balanceOf(msg.sender));
274         // getReward();
275     }
276 
277     function getReward() public updateReward(msg.sender)  checkStart{
278         uint256 _now = block.timestamp;
279         require(_now.sub(starttime) >= 3 days,"You can get reward 3 days after start time!");
280         uint256 reward = earned(msg.sender);
281         if (reward > 0) {
282             rewards[msg.sender] = 0;
283             IERC20(pusd).transfer(msg.sender, reward);
284             totalRewards[msg.sender] = totalRewards[msg.sender].add(reward);
285             emit RewardPaid(msg.sender, reward);
286         }
287     }
288 
289     
290     modifier checkStart(){
291         require(block.timestamp > starttime,"not start");
292         _;
293     }
294 
295     function getRewardBalance() public view returns(uint){
296         return IERC20(pusd).balanceOf(address(this));
297     }
298 
299     function setRewardDuration (uint256 _duration) public onlyOwner {
300         DURATION = _duration;
301     }
302     
303     function notifyRewardAmount(uint256 reward)
304     external
305     {
306         require(keccak256(abi.encodePacked(msg.sender))==keccak256(abi.encodePacked(pusdReward)),"Invalid pusd reward contract address");
307         initreward = reward;
308         rewardPerTokenStored = rewardPerToken();
309         lastUpdateTime = lastTimeRewardApplicable();
310         
311         if (block.timestamp > starttime) {
312             if (block.timestamp >= periodFinish) {
313                 rewardRate = reward.div(DURATION);
314             } else {
315                 uint256 remaining = periodFinish.sub(block.timestamp);
316                 uint256 leftover = remaining.mul(rewardRate);
317                 rewardRate = reward.add(leftover).div(DURATION);
318             }
319             lastUpdateTime = block.timestamp;
320             periodFinish = block.timestamp.add(DURATION);
321             emit RewardAdded(reward);
322         } else {
323             rewardRate = reward.div(DURATION);
324             lastUpdateTime = starttime;
325             periodFinish = starttime.add(DURATION);
326             emit RewardAdded(reward);
327         }
328     }
329     
330 
331 }