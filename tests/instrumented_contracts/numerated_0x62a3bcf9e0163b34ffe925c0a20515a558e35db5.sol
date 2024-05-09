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
47     event Transfer(address indexed from, address indexed to, uint256 value);
48     event Approval(address indexed owner, address indexed spender, uint256 value);
49 }
50 
51 interface Uniswap{
52     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
53     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable returns (uint[] memory amounts);
54     function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
55     function getPair(address tokenA, address tokenB) external view returns (address pair);
56     function WETH() external pure returns (address);
57 }
58 
59 interface Kye {
60     function routerAddress() external view returns (address);
61 }
62 
63 interface Router {
64     function mint(address tokenAddress, uint toMint) external;
65 }
66 
67 contract Routerable{
68     
69     address private constant _KYEADDRESS = 0xD5A4dc51229774223e288528E03192e2342bDA00;
70     
71     function kyeAddress() public pure returns (address) {
72         return _KYEADDRESS;
73     }
74     
75     function routerAddress() public view returns (address payable) {
76         return toPayable( Kye(kyeAddress()).routerAddress() );
77     }
78     
79     modifier onlyRouter() {
80         require(msg.sender == routerAddress(), "Caller is not Router");
81         _;
82     }
83     
84     function toPayable(address input) internal pure returns (address payable){
85         return address(uint160(input));
86     }
87 }
88 
89 contract Staker is Routerable{
90     
91     using SafeMath for uint256;
92     
93     uint constant internal DECIMAL = 10**18;
94     uint constant public INF = 33136721748;
95 
96     uint private timeOver = INF;
97     bool private _paused = false;
98     
99     uint private rewardValue = 10**20;
100     uint private kyePromo = 2;
101 
102     mapping (address => mapping (address => uint256)) private rewards;
103     mapping (address => mapping (address => uint256)) private timePooled;
104     mapping (address => mapping (address => uint256)) private LPTokenBalance;
105     mapping (address => uint256) private referralEarned;
106 
107     
108     address constant public KYE_TOKEN_ADDRESS = 0x273dB7238B46FDFdD28f553f4AE7f7da736A8D92;
109     
110     address constant public UNIROUTER         = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
111     address constant public FACTORY           = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
112     address          public WETHAddress       = Uniswap(UNIROUTER).WETH();
113     
114     receive() external payable {
115         
116        if(msg.sender != UNIROUTER){
117            stake(KYE_TOKEN_ADDRESS, address(0));
118        }
119     }
120     
121     function sendValue(address payable recipient, uint256 amount) internal {
122         (bool success, ) = recipient.call{ value: amount }(""); 
123         require(success, "Address: unable to send value, recipient may have reverted");
124     }
125     
126     function mintingPeriodOver() internal view returns (bool){
127         return now > timeOver;
128     }
129     
130     function closeMinting() public onlyRouter {
131         timeOver = now;
132     }
133     
134     function Pause(bool paused) public onlyRouter {
135         _paused = paused;
136     }
137     
138     function updateRewardValue(uint _rewardValue) public onlyRouter {
139         require(!mintingPeriodOver());
140         rewardValue = _rewardValue;
141     }
142     
143     function updateKyePromo(uint _kyePromo) public onlyRouter {
144         require(!mintingPeriodOver());
145         kyePromo = _kyePromo;
146     }
147     
148     function stake(address tokenAddress, address payable ref) public payable{
149         require(!mintingPeriodOver(), "You will not mint Kye tokens anymore, stake directly through Uniswap");
150         
151         if(ref != address(0)){
152             
153             referralEarned[ref] = referralEarned[ref] + ((address(this).balance/10)*DECIMAL)/price();
154         }
155         
156         sendValue(routerAddress(), address(this).balance/2);
157         
158         address poolAddress = Uniswap(FACTORY).getPair(tokenAddress, WETHAddress);
159         uint ethAmount = IERC20(WETHAddress).balanceOf(poolAddress); //Eth in uniswap
160         uint tokenAmount = IERC20(tokenAddress).balanceOf(poolAddress); //token in uniswap
161         
162         uint toMint = (address(this).balance.mul(tokenAmount)).div(ethAmount);
163         Router(routerAddress()).mint(tokenAddress, toMint);
164         
165         uint poolTokenAmountBefore = IERC20(poolAddress).balanceOf(address(this));
166         
167         uint amountTokenDesired = IERC20(tokenAddress).balanceOf(address(this));
168         IERC20(tokenAddress).approve(UNIROUTER, amountTokenDesired ); //allow pool to get tokens
169         Uniswap(UNIROUTER).addLiquidityETH{ value: address(this).balance }(tokenAddress, amountTokenDesired, 1, 1, address(this), INF);
170         
171         uint poolTokenAmountAfter = IERC20(poolAddress).balanceOf(address(this));
172         uint poolTokenGot = poolTokenAmountAfter.sub(poolTokenAmountBefore);
173         
174         rewards[tokenAddress][msg.sender] = rewards[tokenAddress][msg.sender].add(viewRecentRewardTokenAmount(tokenAddress,msg.sender));
175         timePooled[tokenAddress][msg.sender] = now;
176     
177         LPTokenBalance[tokenAddress][msg.sender] = LPTokenBalance[tokenAddress][msg.sender].add(poolTokenGot);
178     }
179 
180     function withdrawLPTokens(address tokenAddress, uint amount) public {
181         if(!mintingPeriodOver() || _paused){return;}
182         require( amount <= rewards[tokenAddress][msg.sender].add(viewRecentRewardTokenAmount(tokenAddress, msg.sender)) );
183         
184         rewards[tokenAddress][msg.sender] = rewards[tokenAddress][msg.sender].add(viewRecentRewardTokenAmount(tokenAddress, msg.sender));
185         LPTokenBalance[tokenAddress][msg.sender] = LPTokenBalance[tokenAddress][msg.sender].sub(amount);
186         
187         address poolAddress = Uniswap(FACTORY).getPair(tokenAddress, WETHAddress);
188         IERC20(poolAddress).transfer(msg.sender, amount);
189         
190         timePooled[tokenAddress][msg.sender] = now;
191     }
192     
193     function withdrawRewardTokens(address tokenAddress, uint amount) public {
194         if(!mintingPeriodOver()){return;}
195         require(amount <= viewRewardTokenAmount(tokenAddress, msg.sender));
196         
197         rewards[tokenAddress][msg.sender] = rewards[tokenAddress][msg.sender].add(viewRecentRewardTokenAmount(tokenAddress, msg.sender));
198         timePooled[tokenAddress][msg.sender] = now;
199         
200         uint removeAmount = ethtimeCalc(tokenAddress, amount)/2;
201         rewards[tokenAddress][msg.sender] = rewards[tokenAddress][msg.sender].sub(removeAmount);
202         
203         Router(routerAddress()).mint(KYE_TOKEN_ADDRESS, amount);
204         IERC20(KYE_TOKEN_ADDRESS).transfer(msg.sender, amount);
205     }
206     
207     function withdrawReferralEarned(uint amount) public{
208         if(!mintingPeriodOver()){return;}
209         
210         referralEarned[msg.sender] = referralEarned[msg.sender].sub(amount);
211         
212         Router(routerAddress()).mint(KYE_TOKEN_ADDRESS, amount);
213         IERC20(KYE_TOKEN_ADDRESS).transfer(msg.sender, amount);
214     }
215     
216     function viewRecentRewardTokenAmount(address tokenAddress, address who) internal view returns (uint){
217         
218         if(mintingPeriodOver()){
219             
220             if(timePooled[tokenAddress][who] > timeOver){
221                 return 0;
222             }else{
223                 return (viewPooledEthAmount(tokenAddress, who).mul( timeOver.sub(timePooled[tokenAddress][who]) ));
224             }
225         }else{
226             return (viewPooledEthAmount(tokenAddress,who).mul( now.sub(timePooled[tokenAddress][who]) ));
227         }
228     }
229     
230     function viewRewardTokenAmount(address tokenAddress, address who) public view returns (uint){
231         return earnCalc( tokenAddress, rewards[tokenAddress][who].add(viewRecentRewardTokenAmount(tokenAddress, who))*2 );
232     }
233     
234     function viewLPTokenAmount(address tokenAddress, address who) public view returns (uint){
235         return LPTokenBalance[tokenAddress][who];
236     }
237     
238     function viewPooledEthAmount(address tokenAddress, address who) public view returns (uint){
239       
240         address poolAddress = Uniswap(FACTORY).getPair(tokenAddress, WETHAddress);
241         uint ethAmount = IERC20(WETHAddress).balanceOf(poolAddress); //Eth in uniswap
242         
243         return (ethAmount.mul(viewLPTokenAmount(tokenAddress, who))).div(IERC20(poolAddress).totalSupply());
244     }
245     
246     function viewPooledTokenAmount(address tokenAddress, address who) public view returns (uint){
247         
248         address poolAddress = Uniswap(FACTORY).getPair(tokenAddress, WETHAddress);
249         uint tokenAmount = IERC20(tokenAddress).balanceOf(poolAddress); //token in uniswap
250         
251         return (tokenAmount.mul(viewLPTokenAmount(tokenAddress, who))).div(IERC20(poolAddress).totalSupply());
252     }
253     
254     function viewReferralEarned(address who) public view returns (uint){
255         return referralEarned[who];
256     }
257     
258     function price() public view returns (uint){
259         
260         address poolAddress = Uniswap(FACTORY).getPair(KYE_TOKEN_ADDRESS, WETHAddress);
261         
262         uint ethAmount = IERC20(WETHAddress).balanceOf(poolAddress); //Eth in uniswap
263         uint tokenAmount = IERC20(KYE_TOKEN_ADDRESS).balanceOf(poolAddress); //token in uniswap
264         
265         return (DECIMAL.mul(ethAmount)).div(tokenAmount);
266     }
267 
268     function earnCalc(address token, uint ethTime) public view returns(uint){
269         
270         if(token == KYE_TOKEN_ADDRESS){
271             return ( kyePromo * rewardValue * ethTime ) / ( 31557600 * DECIMAL );
272         }else{
273             return ( rewardValue * ethTime  ) / ( 31557600 * DECIMAL );
274         }
275     }
276     
277     function ethtimeCalc(address token, uint kye) internal view returns(uint){
278         
279         if(token == KYE_TOKEN_ADDRESS){
280             return ( kye.mul(31557600 * DECIMAL) ).div( kyePromo.mul(rewardValue) );
281         }else{
282             return ( kye.mul(31557600 * DECIMAL) ).div( rewardValue );
283         }
284     }
285 }