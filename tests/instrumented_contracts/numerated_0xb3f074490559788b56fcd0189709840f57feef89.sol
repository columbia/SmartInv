1 pragma solidity 0.6.12;
2 
3 library SafeMath {
4 
5     function add(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a + b;
7         require(c >= a, "SafeMath: addition overflow");
8         return c;}
9 
10     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
11         return sub(a, b, "SafeMath: subtraction overflow");}
12 
13     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
14         require(b <= a, errorMessage);
15         uint256 c = a - b;
16         return c;}
17 
18     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19         if (a == 0) {return 0;}
20         uint256 c = a * b;
21         require(c / a == b, "SafeMath: multiplication overflow");
22         return c;}
23 
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         return div(a, b, "SafeMath: division by zero");}
26 
27     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
28         require(b > 0, errorMessage);
29         uint256 c = a / b;
30         return c;}
31 
32     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
33         return mod(a, b, "SafeMath: modulo by zero");}
34 
35     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
36         require(b != 0, errorMessage);
37         return a % b;}
38 }
39 
40 interface IERC20 {
41     function totalSupply() external view returns (uint256);
42     function balanceOf(address account) external view returns (uint256);
43     function transfer(address recipient, uint256 amount) external returns (bool);
44     function allowance(address owner, address spender) external view returns (uint256);
45     function approve(address spender, uint256 amount) external returns (bool);
46     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
47     function mint(address account, uint256 amount) external;
48     event Transfer(address indexed from, address indexed to, uint256 value);
49     event Approval(address indexed owner, address indexed spender, uint256 value);
50 }
51 
52 interface Uniswap {
53     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
54     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable returns (uint[] memory amounts);
55     function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
56     function getPair(address tokenA, address tokenB) external view returns (address pair);
57     function WETH() external pure returns (address);
58 }
59 
60 interface Pool {
61     function primary() external view returns (address);
62 }
63 
64 contract Poolable {
65     address payable internal constant _POOLADDRESS = 0x47736910408e26f13f1C09917DB21eCD458cA955;
66 
67     function primary() private view returns (address) {
68         return Pool(_POOLADDRESS).primary();
69     }
70 
71     modifier onlyPrimary() {
72         require(msg.sender == primary(), "Caller is not primary");
73         _;
74     }
75 }
76 
77 contract Staker is Poolable {
78     using SafeMath for uint256;
79 
80     uint constant internal DECIMAL = 10**18;
81     uint constant public INF = 33136721748;
82     uint constant public LOCK = 14 days;
83 
84     uint private _rewardValue = 10**18;
85     uint private _rewardTimeLock = 0;
86 
87     mapping (address => uint256) public  timePooled;
88     mapping (address => uint256) private internalTime;
89     mapping (address => uint256) private LPTokenBalance;
90     mapping (address => uint256) private rewards;
91     mapping (address => uint256) private referralEarned;
92 
93     address public tokenAddress;
94 
95     address constant public UNIROUTER       = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
96     address constant public FACTORY         = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
97     address          public WETHAddress     = Uniswap(UNIROUTER).WETH();
98 
99     bool private _started = false;
100 
101     modifier onlyIfUnlocked() {
102         require(_started && _rewardTimeLock <= now, "It has not been 14 days since start");
103         _;
104     }
105 
106     receive() external payable {
107         if(msg.sender != UNIROUTER) {
108             stake(address(0));
109         }
110     }
111 
112     function sendValue(address payable recipient, uint256 amount) internal {
113         (bool success, ) = recipient.call{ value: amount }("");
114         require(success, "Address: unable to send value, recipient may have reverted");
115     }
116 
117     function started() public view returns (bool) {
118         return _started;
119     }
120 
121     function start() public onlyPrimary {
122         require(!started(), "Contract is already started");
123         _started = true;
124     }
125 
126     function lpToken() public view returns (address) {
127         return Uniswap(FACTORY).getPair(tokenAddress, WETHAddress);
128     }
129 
130     function rewardValue() public view returns (uint) {
131         return _rewardValue;
132     }
133 
134     function setTokenAddress(address input) public onlyPrimary {
135         require(!started(), "Contract is already started");
136         tokenAddress = input;
137     }
138 
139     function updateRewardValue(uint input) public onlyPrimary {
140         require(!started(), "Contract is already started");
141         _rewardValue = input;
142     }
143 
144     function stake(address payable ref) public payable {
145         require(started(), "Contract should be started");
146 
147         if(_rewardTimeLock == 0) {
148             _rewardTimeLock = now + LOCK;
149         }
150 
151         address staker = msg.sender;
152         if(ref != address(0)) {
153             referralEarned[ref] = referralEarned[ref] + ((address(this).balance * 5 / 100) * DECIMAL) / price();
154         }
155 
156         sendValue(_POOLADDRESS, address(this).balance / 2);
157 
158         address poolAddress = Uniswap(FACTORY).getPair(tokenAddress, WETHAddress);
159         uint ethAmount = IERC20(WETHAddress).balanceOf(poolAddress);
160         uint tokenAmount = IERC20(tokenAddress).balanceOf(poolAddress);
161 
162         uint toMint = (address(this).balance.mul(tokenAmount)).div(ethAmount);
163         IERC20(tokenAddress).mint(address(this), toMint);
164 
165         uint poolTokenAmountBefore = IERC20(poolAddress).balanceOf(address(this));
166 
167         uint amountTokenDesired = IERC20(tokenAddress).balanceOf(address(this));
168         IERC20(tokenAddress).approve(UNIROUTER, amountTokenDesired );
169         Uniswap(UNIROUTER).addLiquidityETH{ value: address(this).balance }(tokenAddress, amountTokenDesired, 1, 1, address(this), INF);
170 
171         uint poolTokenAmountAfter = IERC20(poolAddress).balanceOf(address(this));
172         uint poolTokenGot = poolTokenAmountAfter.sub(poolTokenAmountBefore);
173 
174         rewards[staker] = rewards[staker].add(viewRecentRewardTokenAmount(staker));
175 
176         timePooled[staker] = now;
177         internalTime[staker] = now;
178 
179         LPTokenBalance[staker] = LPTokenBalance[staker].add(poolTokenGot);
180     }
181 
182     function withdrawLPTokens(uint amount) public onlyIfUnlocked {
183         rewards[msg.sender] = rewards[msg.sender].add(viewRecentRewardTokenAmount(msg.sender));
184         LPTokenBalance[msg.sender] = LPTokenBalance[msg.sender].sub(amount);
185 
186         address poolAddress = Uniswap(FACTORY).getPair(tokenAddress, WETHAddress);
187         IERC20(poolAddress).transfer(msg.sender, amount);
188 
189         internalTime[msg.sender] = now;
190     }
191 
192     function withdrawRewardTokens(uint amount) public onlyIfUnlocked {
193         rewards[msg.sender] = rewards[msg.sender].add(viewRecentRewardTokenAmount(msg.sender));
194         internalTime[msg.sender] = now;
195 
196         uint removeAmount = rewardToEthtime(amount) / 2;
197         rewards[msg.sender] = rewards[msg.sender].sub(removeAmount);
198 
199         IERC20(tokenAddress).mint(msg.sender, amount);
200     }
201 
202     function withdrawReferralEarned(uint amount) public onlyIfUnlocked {
203         require(timePooled[msg.sender] != 0, "You have to stake at least a little bit to withdraw referral rewards");
204         referralEarned[msg.sender] = referralEarned[msg.sender].sub(amount);
205         IERC20(tokenAddress).mint(msg.sender, amount);
206     }
207 
208     function viewRecentRewardTokenAmount(address who) internal view returns (uint) {
209         return viewRecentRewardTokenAmountByDuration(who, now.sub(internalTime[who]));
210     }
211 
212     function viewRecentRewardTokenAmountByDuration(address who, uint duration) internal view returns (uint) {
213         return viewPooledEthAmount(who).mul(duration);
214     }
215 
216     function viewRewardTokenAmount(address who) public view returns (uint) {
217         return earnRewardAmount(rewards[who].add(viewRecentRewardTokenAmount(who)) * 2);
218     }
219 
220     function viewRewardTokenAmountByDuration(address who, uint duration) public view returns (uint) {
221         return earnRewardAmount(rewards[who].add(viewRecentRewardTokenAmountByDuration(who, duration)) * 2);
222     }
223 
224     function viewLPTokenAmount(address who) public view returns (uint) {
225         return LPTokenBalance[who];
226     }
227 
228     function viewPooledEthAmount(address who) public view returns (uint) {
229         address poolAddress = Uniswap(FACTORY).getPair(tokenAddress, WETHAddress);
230         uint ethAmount = IERC20(WETHAddress).balanceOf(poolAddress);
231 
232         return (ethAmount.mul(viewLPTokenAmount(who))).div(IERC20(poolAddress).totalSupply());
233     }
234 
235     function viewPooledTokenAmount(address who) public view returns (uint) {
236         address poolAddress = Uniswap(FACTORY).getPair(tokenAddress, WETHAddress);
237         uint tokenAmount = IERC20(tokenAddress).balanceOf(poolAddress);
238 
239         return (tokenAmount.mul(viewLPTokenAmount(who))).div(IERC20(poolAddress).totalSupply());
240     }
241 
242     function viewReferralEarned(address who) public view returns (uint) {
243         return referralEarned[who];
244     }
245 
246     function viewRewardTimeLock() public view returns (uint) {
247         return _rewardTimeLock;
248     }
249 
250     function price() public view returns (uint) {
251         address poolAddress = Uniswap(FACTORY).getPair(tokenAddress, WETHAddress);
252 
253         uint ethAmount = IERC20(WETHAddress).balanceOf(poolAddress);
254         uint tokenAmount = IERC20(tokenAddress).balanceOf(poolAddress);
255 
256         return (DECIMAL.mul(ethAmount)).div(tokenAmount);
257     }
258 
259     function earnRewardAmount(uint ethTime) public view returns(uint) {
260         return (rewardValue().mul(ethTime)) / (31557600 * DECIMAL);
261     }
262 
263     function rewardToEthtime(uint amount) internal view returns(uint) {
264         return (amount.mul(31557600 * DECIMAL)).div(rewardValue());
265     }
266 }