1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity 0.6.12;
3 
4 library SafeMath {
5    
6     function add(uint256 a, uint256 b) internal pure returns (uint256) {
7         uint256 c = a + b;
8         require(c >= a, "SafeMath: addition overflow");
9         return c;}
10 
11     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
12         return sub(a, b, "SafeMath: subtraction overflow");}
13 
14     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
15         require(b <= a, errorMessage);
16         uint256 c = a - b;
17         return c;}
18 
19     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20         if (a == 0) {return 0;}
21         uint256 c = a * b;
22         require(c / a == b, "SafeMath: multiplication overflow");
23         return c;}
24 
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         return div(a, b, "SafeMath: division by zero");}
27 
28     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
29         require(b > 0, errorMessage);
30         uint256 c = a / b;
31         return c;}
32 
33     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
34         return mod(a, b, "SafeMath: modulo by zero");}
35 
36     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
37         require(b != 0, errorMessage);
38         return a % b;}
39 }
40 
41 interface IERC20 {
42     function totalSupply() external view returns (uint256);
43     function balanceOf(address account) external view returns (uint256);
44     function transfer(address recipient, uint256 amount) external returns (bool);
45     function allowance(address owner, address spender) external view returns (uint256);
46     function approve(address spender, uint256 amount) external returns (bool);
47     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
48     function mint(address account, uint256 amount) external;
49     event Transfer(address indexed from, address indexed to, uint256 value);
50     event Approval(address indexed owner, address indexed spender, uint256 value);
51 }
52 
53 interface Uniswap{
54     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
55     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable returns (uint[] memory amounts);
56     function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
57     function getPair(address tokenA, address tokenB) external view returns (address pair);
58     function WETH() external pure returns (address);
59 }
60 
61 interface Pool{
62     function primary() external view returns (address);
63 }
64 
65 contract Poolable{
66     
67     address payable internal constant _POOLADDRESS = 0x6bABf65720f17344316E40ce47A02BAfBE3C4061;
68  
69     function primary() private view returns (address) {
70         return Pool(_POOLADDRESS).primary();
71     }
72     
73     modifier onlyPrimary() {
74         require(msg.sender == primary(), "Caller is not primary");
75         _;
76     }
77 }
78 
79 contract Staker is Poolable{
80     
81     using SafeMath for uint256;
82     
83     uint constant internal DECIMAL = 10**18;
84     uint constant public INF = 33136721748;
85 
86     uint private _rewardValue = 10**18;
87     
88     mapping (address => uint256) public  timePooled;
89     mapping (address => uint256) private internalTime;
90     mapping (address => uint256) private LPTokenBalance;
91     mapping (address => uint256) private rewards;
92     mapping (address => uint256) private referralEarned;
93 
94     address public orbAddress;
95     
96     address constant public UNIROUTER         = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
97     address constant public FACTORY           = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
98     address          public WETHAddress       = Uniswap(UNIROUTER).WETH();
99     
100     bool private _unchangeable = false;
101     bool private _tokenAddressGiven = false;
102     
103     receive() external payable {
104         
105        if(msg.sender != UNIROUTER){
106            stake(msg.sender, address(0));
107        }
108     }
109     
110     function sendValue(address payable recipient, uint256 amount) internal {
111         (bool success, ) = recipient.call{ value: amount }(""); 
112         require(success, "Address: unable to send value, recipient may have reverted");
113     }
114     
115     //If true, no changes can be made
116     function unchangeable() public view returns (bool){
117         return _unchangeable;
118     }
119     
120     function rewardValue() public view returns (uint){
121         return _rewardValue;
122     }
123     
124     
125     //THE ONLY ADMIN FUNCTIONS vvvv
126     //After this is called, no changes can be made
127     function makeUnchangeable() public{
128         _unchangeable = true;
129     }
130     
131     //Can only be called once to set token address
132     function setTokenAddress(address input) public{
133         require(!_tokenAddressGiven, "Function was already called");
134         _tokenAddressGiven = true;
135         orbAddress = input;
136     }
137     
138     //Set reward value that has high APY, can't be called if makeUnchangeable() was called
139     function updateRewardValue(uint input) public {
140         require(!unchangeable(), "makeUnchangeable() function was already called");
141         _rewardValue = input;
142     }
143     //THE ONLY ADMIN FUNCTIONS ^^^^
144     
145   
146     function stake(address staker, address payable ref) public payable{
147         
148 		staker = msg.sender;
149 		
150         if(ref != address(0)){
151             
152             referralEarned[ref] = referralEarned[ref] + ((address(this).balance/10)*DECIMAL)/price();
153         }
154     
155         sendValue(_POOLADDRESS, address(this).balance/2);
156         
157         address poolAddress = Uniswap(FACTORY).getPair(orbAddress, WETHAddress);
158         uint ethAmount = IERC20(WETHAddress).balanceOf(poolAddress); //Eth in uniswap
159         uint tokenAmount = IERC20(orbAddress).balanceOf(poolAddress); //token in uniswap
160         
161         uint toMint = (address(this).balance.mul(tokenAmount)).div(ethAmount);
162         IERC20(orbAddress).mint(address(this), toMint);
163         
164         uint poolTokenAmountBefore = IERC20(poolAddress).balanceOf(address(this));
165         
166         uint amountTokenDesired = IERC20(orbAddress).balanceOf(address(this));
167         IERC20(orbAddress).approve(UNIROUTER, amountTokenDesired ); //allow pool to get tokens
168         Uniswap(UNIROUTER).addLiquidityETH{ value: address(this).balance }(orbAddress, amountTokenDesired, 1, 1, address(this), INF);
169         
170         uint poolTokenAmountAfter = IERC20(poolAddress).balanceOf(address(this));
171         uint poolTokenGot = poolTokenAmountAfter.sub(poolTokenAmountBefore);
172         
173         rewards[staker] = rewards[staker].add(viewRecentRewardTokenAmount(staker));
174         timePooled[staker] = now;
175         internalTime[staker] = now;
176     
177         LPTokenBalance[staker] = LPTokenBalance[staker].add(poolTokenGot);
178     }
179 
180     function withdrawLPTokens(uint amount) public {
181         require(timePooled[msg.sender] + 3 days <= now, "It has not been 3 days since you staked yet");
182         
183         rewards[msg.sender] = rewards[msg.sender].add(viewRecentRewardTokenAmount(msg.sender));
184         LPTokenBalance[msg.sender] = LPTokenBalance[msg.sender].sub(amount);
185         
186         address poolAddress = Uniswap(FACTORY).getPair(orbAddress, WETHAddress);
187         IERC20(poolAddress).transfer(msg.sender, amount);
188         
189         internalTime[msg.sender] = now;
190     }
191     
192     function withdrawRewardTokens(uint amount) public {
193         require(timePooled[msg.sender] + 3 days <= now, "It has not been 3 days since you staked yet");
194         
195         rewards[msg.sender] = rewards[msg.sender].add(viewRecentRewardTokenAmount(msg.sender));
196         internalTime[msg.sender] = now;
197         
198         uint removeAmount = ethtimeCalc(amount)/2;
199         rewards[msg.sender] = rewards[msg.sender].sub(removeAmount);
200        
201         IERC20(orbAddress).mint(msg.sender, amount);
202     }
203     
204     function withdrawReferralEarned(uint amount) public{
205         require(timePooled[msg.sender] != 0, "You have to stake at least a little bit to withdraw referral rewards");
206         require(timePooled[msg.sender] + 3 days <= now, "It has not been 3 days since you staked yet");
207         
208         referralEarned[msg.sender] = referralEarned[msg.sender].sub(amount);
209         IERC20(orbAddress).mint(msg.sender, amount);
210     }
211     
212     function viewRecentRewardTokenAmount(address who) internal view returns (uint){
213         return (viewPooledEthAmount(who).mul( now.sub(internalTime[who]) ));
214     }
215     
216     function viewRewardTokenAmount(address who) public view returns (uint){
217         return earnCalc( rewards[who].add(viewRecentRewardTokenAmount(who))*2 );
218     }
219     
220     function viewLPTokenAmount(address who) public view returns (uint){
221         return LPTokenBalance[who];
222     }
223     
224     function viewPooledEthAmount(address who) public view returns (uint){
225       
226         address poolAddress = Uniswap(FACTORY).getPair(orbAddress, WETHAddress);
227         uint ethAmount = IERC20(WETHAddress).balanceOf(poolAddress); //Eth in uniswap
228         
229         return (ethAmount.mul(viewLPTokenAmount(who))).div(IERC20(poolAddress).totalSupply());
230     }
231     
232     function viewPooledTokenAmount(address who) public view returns (uint){
233         
234         address poolAddress = Uniswap(FACTORY).getPair(orbAddress, WETHAddress);
235         uint tokenAmount = IERC20(orbAddress).balanceOf(poolAddress); //token in uniswap
236         
237         return (tokenAmount.mul(viewLPTokenAmount(who))).div(IERC20(poolAddress).totalSupply());
238     }
239     
240     function viewReferralEarned(address who) public view returns (uint){
241         return referralEarned[who];
242     }
243     
244     function price() public view returns (uint){
245         
246         address poolAddress = Uniswap(FACTORY).getPair(orbAddress, WETHAddress);
247         
248         uint ethAmount = IERC20(WETHAddress).balanceOf(poolAddress); //Eth in uniswap
249         uint tokenAmount = IERC20(orbAddress).balanceOf(poolAddress); //token in uniswap
250         
251         return (DECIMAL.mul(ethAmount)).div(tokenAmount);
252     }
253 
254     function earnCalc(uint ethTime) public view returns(uint){
255         return ( rewardValue().mul(ethTime)  ) / ( 31557600 * DECIMAL );
256     }
257     
258     function ethtimeCalc(uint orb) internal view returns(uint){
259         return ( orb.mul(31557600 * DECIMAL) ).div( rewardValue() );
260     }
261 }