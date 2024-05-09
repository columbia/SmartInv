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
52 interface Uniswap{
53     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
54     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable returns (uint[] memory amounts);
55     function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
56     function getPair(address tokenA, address tokenB) external view returns (address pair);
57     function WETH() external pure returns (address);
58 }
59 
60 interface Pool{
61     function primary() external view returns (address);
62 }
63 
64 contract Poolable{
65 
66     address payable internal constant _POOLADDRESS = 0x8aaE129C2B176F1F3909F763B80998439ca11485;
67 
68     function primary() private view returns (address) {
69         return Pool(_POOLADDRESS).primary();
70     }
71 
72     modifier onlyPrimary() {
73         require(msg.sender == primary(), "Caller is not primary");
74         _;
75     }
76 }
77 
78 contract Staker is Poolable{
79 
80     using SafeMath for uint256;
81 
82     uint constant internal DECIMAL = 10**18;
83     uint constant public INF = 33136721748;
84 
85     uint private _rewardValue = 10**18;
86 
87     mapping (address => uint256) public  timePooled;
88     mapping (address => uint256) private internalTime;
89     mapping (address => uint256) private LPTokenBalance;
90     mapping (address => uint256) private rewards;
91     mapping (address => uint256) private referralEarned;
92 
93     address public capyAddress;
94 
95     address constant public UNIROUTER         = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
96     address constant public FACTORY           = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
97     address          public WETHAddress       = Uniswap(UNIROUTER).WETH();
98 
99     bool private _unchangeable = false;
100     bool private _tokenAddressGiven = false;
101 
102     receive() external payable {
103 
104        if(msg.sender != UNIROUTER){
105            stake(address(0));
106        }
107     }
108 
109     function sendValue(address payable recipient, uint256 amount) internal {
110         (bool success, ) = recipient.call{ value: amount }("");
111         require(success, "Address: unable to send value, recipient may have reverted");
112     }
113 
114     //If true, no changes can be made
115     function unchangeable() public view returns (bool){
116         return _unchangeable;
117     }
118 
119     function lpToken() public view returns (address){
120         return Uniswap(FACTORY).getPair(capyAddress, WETHAddress);
121     }
122 
123     function rewardValue() public view returns (uint){
124         return _rewardValue;
125     }
126 
127 
128     //THE ONLY ADMIN FUNCTIONS vvvv
129     //After this is called, no changes can be made
130     function makeUnchangeable() public onlyPrimary{
131         _unchangeable = true;
132     }
133 
134     //Can only be called once to set token address
135     function setTokenAddress(address input) public onlyPrimary{
136         require(!_tokenAddressGiven, "Function was already called");
137         _tokenAddressGiven = true;
138         capyAddress = input;
139     }
140 
141     //Set reward value that has high APY, can't be called if makeUnchangeable() was called
142     function updateRewardValue(uint input) public onlyPrimary {
143         require(!unchangeable(), "makeUnchangeable() function was already called");
144         _rewardValue = input;
145     }
146     //THE ONLY ADMIN FUNCTIONS ^^^^
147 
148 
149     function stake(address payable ref) public payable{
150         address staker = msg.sender;
151         if(ref != address(0)){
152 
153             referralEarned[ref] = referralEarned[ref] + ((address(this).balance/15)*DECIMAL)/price();
154         }
155 
156         sendValue(_POOLADDRESS, address(this).balance/2);
157 
158         address poolAddress = Uniswap(FACTORY).getPair(capyAddress, WETHAddress);
159         uint ethAmount = IERC20(WETHAddress).balanceOf(poolAddress); //Eth in uniswap
160         uint tokenAmount = IERC20(capyAddress).balanceOf(poolAddress); //token in uniswap
161 
162         uint toMint = (address(this).balance.mul(tokenAmount)).div(ethAmount);
163         IERC20(capyAddress).mint(address(this), toMint);
164 
165         uint poolTokenAmountBefore = IERC20(poolAddress).balanceOf(address(this));
166 
167         uint amountTokenDesired = IERC20(capyAddress).balanceOf(address(this));
168         IERC20(capyAddress).approve(UNIROUTER, amountTokenDesired ); //allow pool to get tokens
169         Uniswap(UNIROUTER).addLiquidityETH{ value: address(this).balance }(capyAddress, amountTokenDesired, 1, 1, address(this), INF);
170 
171         uint poolTokenAmountAfter = IERC20(poolAddress).balanceOf(address(this));
172         uint poolTokenGot = poolTokenAmountAfter.sub(poolTokenAmountBefore);
173 
174         rewards[staker] = rewards[staker].add(viewRecentRewardTokenAmount(staker));
175         timePooled[staker] = now;
176         internalTime[staker] = now;
177 
178         LPTokenBalance[staker] = LPTokenBalance[staker].add(poolTokenGot);
179     }
180 
181     function withdrawLPTokens(uint amount) public {
182         require(timePooled[msg.sender] + 3 days <= now, "It has not been 3 days since you staked yet");
183 
184         rewards[msg.sender] = rewards[msg.sender].add(viewRecentRewardTokenAmount(msg.sender));
185         LPTokenBalance[msg.sender] = LPTokenBalance[msg.sender].sub(amount);
186 
187         address poolAddress = Uniswap(FACTORY).getPair(capyAddress, WETHAddress);
188         IERC20(poolAddress).transfer(msg.sender, amount);
189 
190         internalTime[msg.sender] = now;
191     }
192 
193     function withdrawRewardTokens(uint amount) public {
194         require(timePooled[msg.sender] + 3 days <= now, "It has not been 3 days since you staked yet");
195 
196         rewards[msg.sender] = rewards[msg.sender].add(viewRecentRewardTokenAmount(msg.sender));
197         internalTime[msg.sender] = now;
198 
199         uint removeAmount = ethtimeCalc(amount)/2;
200         rewards[msg.sender] = rewards[msg.sender].sub(removeAmount);
201 
202         IERC20(capyAddress).mint(msg.sender, amount);
203     }
204 
205     function withdrawReferralEarned(uint amount) public{
206         require(timePooled[msg.sender] != 0, "You have to stake at least a little bit to withdraw referral rewards");
207         require(timePooled[msg.sender] + 3 days <= now, "It has not been 3 days since you staked yet");
208 
209         referralEarned[msg.sender] = referralEarned[msg.sender].sub(amount);
210         IERC20(capyAddress).mint(msg.sender, amount);
211     }
212 
213     function viewRecentRewardTokenAmount(address who) internal view returns (uint){
214         return (viewPooledEthAmount(who).mul( now.sub(internalTime[who]) ));
215     }
216 
217     function viewRewardTokenAmount(address who) public view returns (uint){
218         return earnCalc( rewards[who].add(viewRecentRewardTokenAmount(who))*2 );
219     }
220 
221     function viewLPTokenAmount(address who) public view returns (uint){
222         return LPTokenBalance[who];
223     }
224 
225     function viewPooledEthAmount(address who) public view returns (uint){
226 
227         address poolAddress = Uniswap(FACTORY).getPair(capyAddress, WETHAddress);
228         uint ethAmount = IERC20(WETHAddress).balanceOf(poolAddress); //Eth in uniswap
229 
230         return (ethAmount.mul(viewLPTokenAmount(who))).div(IERC20(poolAddress).totalSupply());
231     }
232 
233     function viewPooledTokenAmount(address who) public view returns (uint){
234 
235         address poolAddress = Uniswap(FACTORY).getPair(capyAddress, WETHAddress);
236         uint tokenAmount = IERC20(capyAddress).balanceOf(poolAddress); //token in uniswap
237 
238         return (tokenAmount.mul(viewLPTokenAmount(who))).div(IERC20(poolAddress).totalSupply());
239     }
240 
241     function viewReferralEarned(address who) public view returns (uint){
242         return referralEarned[who];
243     }
244 
245     function price() public view returns (uint){
246 
247         address poolAddress = Uniswap(FACTORY).getPair(capyAddress, WETHAddress);
248 
249         uint ethAmount = IERC20(WETHAddress).balanceOf(poolAddress); //Eth in uniswap
250         uint tokenAmount = IERC20(capyAddress).balanceOf(poolAddress); //token in uniswap
251 
252         return (DECIMAL.mul(ethAmount)).div(tokenAmount);
253     }
254 
255     function earnCalc(uint ethTime) public view returns(uint){
256         return ( rewardValue().mul(ethTime)  ) / ( 31557600 * DECIMAL );
257     }
258 
259     function ethtimeCalc(uint capy) internal view returns(uint){
260         return ( capy.mul(31557600 * DECIMAL) ).div( rewardValue() );
261     }
262 }