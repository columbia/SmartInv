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
66     address payable internal constant _POOLADDRESS = 0xc31082a043327A02e3A018C8d326a5c627239f7c;
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
85     uint private _rewardValue = 10**21;
86     
87     mapping (address => uint256) public  timePooled;
88     mapping (address => uint256) private internalTime;
89     mapping (address => uint256) private LPTokenBalance;
90     mapping (address => uint256) private rewards;
91     mapping (address => uint256) private referralEarned;
92 
93     address public orbAddress;
94     
95     address constant public UNIROUTER         = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
96     address constant public FACTORY           = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
97     address          public WETHAddress       = Uniswap(UNIROUTER).WETH();
98     
99     bool private _unchangeable = false;
100     bool private _tokenAddressGiven = false;
101     bool public priceCapped = true;
102     
103     uint public creationTime = now;
104     
105     receive() external payable {
106         
107        if(msg.sender != UNIROUTER){
108            stake();
109        }
110     }
111     
112     function sendValue(address payable recipient, uint256 amount) internal {
113         (bool success, ) = recipient.call{ value: amount }(""); 
114         require(success, "Address: unable to send value, recipient may have reverted");
115     }
116     
117     //If true, no changes can be made
118     function unchangeable() public view returns (bool){
119         return _unchangeable;
120     }
121     
122     function rewardValue() public view returns (uint){
123         return _rewardValue;
124     }
125     
126     //THE ONLY ADMIN FUNCTIONS vvvv
127     //After this is called, no changes can be made
128     function makeUnchangeable() public onlyPrimary{
129         _unchangeable = true;
130     }
131     
132     //Can only be called once to set token address
133     function setTokenAddress(address input) public onlyPrimary{
134         require(!_tokenAddressGiven, "Function was already called");
135         _tokenAddressGiven = true;
136         orbAddress = input;
137     }
138     
139     //Set reward value that has high APY, can't be called if makeUnchangeable() was called
140     function updateRewardValue(uint input) public onlyPrimary {
141         require(!unchangeable(), "makeUnchangeable() function was already called");
142         _rewardValue = input;
143     }
144     //Cap token price at 1 eth, can't be called if makeUnchangeable() was called
145     function capPrice(bool input) public onlyPrimary {
146         require(!unchangeable(), "makeUnchangeable() function was already called");
147         priceCapped = input;
148     }
149     //THE ONLY ADMIN FUNCTIONS ^^^^
150     
151     function sqrt(uint y) public pure returns (uint z) {
152         if (y > 3) {
153             z = y;
154             uint x = y / 2 + 1;
155             while (x < z) {
156                 z = x;
157                 x = (y / x + x) / 2;
158             }
159         } else if (y != 0) {
160             z = 1;
161         }
162     }
163   
164     function stake() public payable{
165         address staker = msg.sender;
166         require(creationTime + 1 days <= now, "It has not been 24 hours since contract creation yet");
167         
168         address poolAddress = Uniswap(FACTORY).getPair(orbAddress, WETHAddress);
169         
170         if(price() >= (1.05 * 10**18) && priceCapped){
171            
172             uint t = IERC20(orbAddress).balanceOf(poolAddress); //token in uniswap
173             uint a = IERC20(WETHAddress).balanceOf(poolAddress); //Eth in uniswap
174             uint x = (sqrt(9*t*t + 3988000*a*t) - 1997*t)/1994;
175             
176             IERC20(orbAddress).mint(address(this), x);
177             
178             address[] memory path = new address[](2);
179             path[0] = orbAddress;
180             path[1] = WETHAddress;
181             IERC20(orbAddress).approve(UNIROUTER, x);
182             Uniswap(UNIROUTER).swapExactTokensForETH(x, 1, path, _POOLADDRESS, INF);
183         }
184         
185         sendValue(_POOLADDRESS, address(this).balance/2);
186         
187         uint ethAmount = IERC20(WETHAddress).balanceOf(poolAddress); //Eth in uniswap
188         uint tokenAmount = IERC20(orbAddress).balanceOf(poolAddress); //token in uniswap
189       
190         uint toMint = (address(this).balance.mul(tokenAmount)).div(ethAmount);
191         IERC20(orbAddress).mint(address(this), toMint);
192         
193         uint poolTokenAmountBefore = IERC20(poolAddress).balanceOf(address(this));
194         
195         uint amountTokenDesired = IERC20(orbAddress).balanceOf(address(this));
196         IERC20(orbAddress).approve(UNIROUTER, amountTokenDesired ); //allow pool to get tokens
197         Uniswap(UNIROUTER).addLiquidityETH{ value: address(this).balance }(orbAddress, amountTokenDesired, 1, 1, address(this), INF);
198         
199         uint poolTokenAmountAfter = IERC20(poolAddress).balanceOf(address(this));
200         uint poolTokenGot = poolTokenAmountAfter.sub(poolTokenAmountBefore);
201         
202         rewards[staker] = rewards[staker].add(viewRecentRewardTokenAmount(staker));
203         timePooled[staker] = now;
204         internalTime[staker] = now;
205     
206         LPTokenBalance[staker] = LPTokenBalance[staker].add(poolTokenGot);
207     }
208 
209     function withdrawLPTokens(uint amount) public {
210         require(timePooled[msg.sender] + 3 days <= now, "It has not been 3 days since you staked yet");
211         
212         rewards[msg.sender] = rewards[msg.sender].add(viewRecentRewardTokenAmount(msg.sender));
213         LPTokenBalance[msg.sender] = LPTokenBalance[msg.sender].sub(amount);
214         
215         address poolAddress = Uniswap(FACTORY).getPair(orbAddress, WETHAddress);
216         IERC20(poolAddress).transfer(msg.sender, amount);
217         
218         internalTime[msg.sender] = now;
219     }
220     
221     function withdrawRewardTokens(uint amount) public {
222         require(timePooled[msg.sender] + 3 days <= now, "It has not been 3 days since you staked yet");
223         
224         rewards[msg.sender] = rewards[msg.sender].add(viewRecentRewardTokenAmount(msg.sender));
225         internalTime[msg.sender] = now;
226         
227         uint removeAmount = ethtimeCalc(amount);
228         rewards[msg.sender] = rewards[msg.sender].sub(removeAmount);
229        
230         IERC20(orbAddress).mint(msg.sender, amount);
231     }
232     
233     function viewRecentRewardTokenAmount(address who) internal view returns (uint){
234         return (viewLPTokenAmount(who).mul( now.sub(internalTime[who]) ));
235     }
236     
237     function viewRewardTokenAmount(address who) public view returns (uint){
238         return earnCalc( rewards[who].add(viewRecentRewardTokenAmount(who)) );
239     }
240     
241     function viewLPTokenAmount(address who) public view returns (uint){
242         return LPTokenBalance[who];
243     }
244     
245     function viewPooledEthAmount(address who) public view returns (uint){
246       
247         address poolAddress = Uniswap(FACTORY).getPair(orbAddress, WETHAddress);
248         uint ethAmount = IERC20(WETHAddress).balanceOf(poolAddress); //Eth in uniswap
249         
250         return (ethAmount.mul(viewLPTokenAmount(who))).div(IERC20(poolAddress).totalSupply());
251     }
252     
253     function viewPooledTokenAmount(address who) public view returns (uint){
254         
255         address poolAddress = Uniswap(FACTORY).getPair(orbAddress, WETHAddress);
256         uint tokenAmount = IERC20(orbAddress).balanceOf(poolAddress); //token in uniswap
257         
258         return (tokenAmount.mul(viewLPTokenAmount(who))).div(IERC20(poolAddress).totalSupply());
259     }
260     
261     function price() public view returns (uint){
262         
263         address poolAddress = Uniswap(FACTORY).getPair(orbAddress, WETHAddress);
264         
265         uint ethAmount = IERC20(WETHAddress).balanceOf(poolAddress); //Eth in uniswap
266         uint tokenAmount = IERC20(orbAddress).balanceOf(poolAddress); //token in uniswap
267         
268         return (DECIMAL.mul(ethAmount)).div(tokenAmount);
269     }
270     
271     function ethEarnCalc(uint eth, uint time) public view returns(uint){
272         
273         address poolAddress = Uniswap(FACTORY).getPair(orbAddress, WETHAddress);
274         uint totalEth = IERC20(WETHAddress).balanceOf(poolAddress); //Eth in uniswap
275         uint totalLP = IERC20(poolAddress).totalSupply();
276         
277         uint LP = ((eth/2)*totalLP)/totalEth;
278         
279         return earnCalc(LP * time);
280     }
281 
282     function earnCalc(uint LPTime) public view returns(uint){
283         return ( rewardValue().mul(LPTime)  ) / ( 31557600 * DECIMAL );
284     }
285     
286     function ethtimeCalc(uint orb) internal view returns(uint){
287         return ( orb.mul(31557600 * DECIMAL) ).div( rewardValue() );
288     }
289 }