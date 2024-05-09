1 pragma solidity 0.8.15;
2 
3 //SPDX-License-Identifier: MIT Licensed
4 
5 interface IToken {
6     function name() external view returns (string memory);
7 
8     function symbol() external view returns (string memory);
9 
10     function decimals() external view returns (uint8);
11 
12     function totalSupply() external view returns (uint256);
13 
14     function balanceOf(address owner) external view returns (uint256);
15 
16     function allowance(address owner, address spender)
17         external
18         view
19         returns (uint256);
20 
21     function approve(address spender, uint256 value) external;
22 
23     function transfer(address to, uint256 value) external;
24 
25     function transferFrom(
26         address from,
27         address to,
28         uint256 value
29     ) external;
30 
31     event Approval(
32         address indexed owner,
33         address indexed spender,
34         uint256 value
35     );
36     event Transfer(address indexed from, address indexed to, uint256 value);
37 }
38 
39 interface AggregatorV3Interface {
40     function decimals() external view returns (uint8);
41 
42     function description() external view returns (string memory);
43 
44     function version() external view returns (uint256);
45 
46     function getRoundData(uint80 _roundId)
47         external
48         view
49         returns (
50             uint80 roundId,
51             int256 answer,
52             uint256 startedAt,
53             uint256 updatedAt,
54             uint80 answeredInRound
55         );
56 
57     function latestRoundData()
58         external
59         view
60         returns (
61             uint80 roundId,
62             int256 answer,
63             uint256 startedAt,
64             uint256 updatedAt,
65             uint80 answeredInRound
66         );
67 }
68 
69 contract BostonDynamicsInuPresale {
70     using SafeMath for uint256;
71 
72     IToken public BDINU = IToken(0xdd28583bC0E941fDeC877a98C451069f8E05f1c6);
73     IToken public USDT = IToken(0xdAC17F958D2ee523a2206206994597C13D831ec7);
74     AggregatorV3Interface public priceFeedEth;
75 
76     address payable public owner;
77 
78     uint256 public tokenPerUsd = 4761904760000000000;
79     uint256 public preSaleStartTime;
80     uint256 public soldToken;
81     uint256 public totalSupply = 1500000 ether;
82     uint256 public amountRaisedEth;
83     uint256 public amountRaisedUSDT; 
84     uint256 public minimumDollar = 100000000;
85     uint256 public minimumETH = 0.05 ether;
86     uint256 public constant divider = 100;
87 
88     bool public presaleStatus;
89 
90     struct user {
91         uint256 Eth_balance;
92         uint256 busd_balance;
93         uint256 usdt_balance;
94         uint256 token_balance;
95     }
96 
97     mapping(address => user) public users;
98 
99     modifier onlyOwner() {
100         require(msg.sender == owner, "PRESALE: Not an owner");
101         _;
102     }
103 
104     event BuyToken(address indexed _user, uint256 indexed _amount);
105 
106     constructor() {
107         owner = payable(0x8d27fe9DDF5dd7B4Dd6DE02038cfe2Be9D3f61FA);
108         priceFeedEth = AggregatorV3Interface(
109             0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
110         );
111         preSaleStartTime = block.timestamp;
112         presaleStatus = true;
113     }
114 
115     receive() external payable {}
116 
117     // to get real time price of Eth
118     function getLatestPriceEth() public view returns (uint256) {
119         (, int256 price, , , ) = priceFeedEth.latestRoundData();
120         return uint256(price);
121     }
122 
123     // to buy token during preSale time with Eth => for web3 use
124 
125     function buyTokenEth() public payable {
126         require(presaleStatus == true, "Presale : Presale is finished");
127         require(msg.value >= minimumETH, "Presale : Unsuitable Amount");
128         require(soldToken <= totalSupply, "All Sold");
129 
130         uint256 numberOfTokens;
131         numberOfTokens = EthToToken(msg.value);
132         BDINU.transfer(msg.sender, numberOfTokens);
133 
134         soldToken = soldToken + (numberOfTokens);
135         amountRaisedEth = amountRaisedEth + (msg.value);
136         users[msg.sender].Eth_balance =
137             users[msg.sender].Eth_balance +
138             (msg.value);
139         users[msg.sender].token_balance =
140             users[msg.sender].token_balance +
141             (numberOfTokens);
142     }
143 
144     // to buy token during preSale time with USDT => for web3 use
145     function buyTokenUSDT(uint256 amount) public {
146         require(presaleStatus == true, "Presale : Presale is finished");
147         require(amount >= minimumDollar,"Minimum Amount is $100"); 
148         require(soldToken <= totalSupply, "All Sold");
149 
150         USDT.transferFrom(msg.sender, address(this), amount);
151 
152         uint256 numberOfTokens;
153         numberOfTokens = usdtToToken(amount);
154 
155         BDINU.transfer(msg.sender, numberOfTokens);
156         soldToken = soldToken + (numberOfTokens);
157         amountRaisedUSDT = amountRaisedUSDT + (amount);
158         users[msg.sender].usdt_balance =
159             users[msg.sender].usdt_balance +
160             (amount);
161         users[msg.sender].token_balance =
162             users[msg.sender].token_balance +
163             (numberOfTokens);
164     }
165 
166     // to check percentage of token sold
167     function getProgress() public view returns (uint256 _percent) {
168         uint256 remaining = totalSupply -
169             (soldToken / (10**(BDINU.decimals())));
170         remaining = (remaining * (divider)) / (totalSupply);
171         uint256 hundred = 100;
172         return hundred - (remaining);
173     }
174  
175     function stopPresale(bool state) external onlyOwner {
176         presaleStatus = state;
177     }
178 
179     // to check number of token for given Eth
180     function EthToToken(uint256 _amount) public view returns (uint256) {
181         uint256 EthToUsd = (_amount * (getLatestPriceEth())) / (1 ether);
182         uint256 numberOfTokens = (EthToUsd * (tokenPerUsd)) / (1e8);
183         return numberOfTokens;
184     }
185 
186     // to check number of token for given usdt
187     function usdtToToken(uint256 _amount) public view returns (uint256) {
188         uint256 numberOfTokens = (_amount * (tokenPerUsd)) / (1e6);
189         return numberOfTokens;
190     }
191 
192     // to change Price of the token
193     function changePrice(uint256 _price) external onlyOwner {
194         tokenPerUsd = _price;
195     }
196 
197     // to change preSale time duration
198     function setPreSaleTime(uint256 _startTime) external onlyOwner {
199         preSaleStartTime = _startTime;
200     }
201 
202     // transfer ownership
203     function changeOwner(address payable _newOwner) external onlyOwner {
204         owner = _newOwner;
205     }
206 
207     // change tokens
208     function changeToken(address _token) external onlyOwner {
209         BDINU = IToken(_token);
210     }
211 
212        // change minimum buy
213     function changeMinimumLimits(uint256 _inDollar, uint256 _inEth) external onlyOwner {
214         minimumDollar = _inDollar;
215         minimumETH    = _inEth;
216     }
217     // change supply
218     function changeTotalSupply(uint256 _total) external onlyOwner {
219         totalSupply = _total;
220     }
221     //change USDT
222     function changeUSDT(address _USDT) external onlyOwner {
223         USDT = IToken(_USDT);
224     }
225 
226     // to draw funds for liquidity
227     function transferFundsEth(uint256 _value) external onlyOwner {
228         owner.transfer(_value);
229     }
230 
231     // to draw out tokens
232     function transferTokens(IToken token, uint256 _value) external onlyOwner {
233         token.transfer(msg.sender, _value);
234     }
235 
236     // to get current UTC time
237     function getCurrentTime() external view returns (uint256) {
238         return block.timestamp;
239     }
240 
241     // to get contract Eth balance
242     function contractBalanceEth() external view returns (uint256) {
243         return address(this).balance;
244     }
245 
246     //to get contract USDT balance
247     function contractBalanceUSDT() external view returns (uint256) {
248         return USDT.balanceOf(address(this));
249     }
250 
251     // to get contract token balance
252     function getContractTokenApproval() external view returns (uint256) {
253         return BDINU.allowance(owner, address(this));
254     }
255 }
256 
257 library SafeMath {
258     function add(uint256 a, uint256 b) internal pure returns (uint256) {
259         uint256 c = a + b;
260         require(c >= a, "SafeMath: addition overflow");
261 
262         return c;
263     }
264 
265     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
266         return sub(a, b, "SafeMath: subtraction overflow");
267     }
268 
269     function sub(
270         uint256 a,
271         uint256 b,
272         string memory errorMessage
273     ) internal pure returns (uint256) {
274         require(b <= a, errorMessage);
275         uint256 c = a - b;
276 
277         return c;
278     }
279 
280     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
281         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
282         // benefit is lost if 'b' is also tested.
283         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
284         if (a == 0) {
285             return 0;
286         }
287 
288         uint256 c = a * b;
289         require(c / a == b, "SafeMath: multiplication overflow");
290 
291         return c;
292     }
293 
294     function div(uint256 a, uint256 b) internal pure returns (uint256) {
295         return div(a, b, "SafeMath: division by zero");
296     }
297 
298     function div(
299         uint256 a,
300         uint256 b,
301         string memory errorMessage
302     ) internal pure returns (uint256) {
303         require(b > 0, errorMessage);
304         uint256 c = a / b;
305         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
306 
307         return c;
308     }
309 
310     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
311         return mod(a, b, "SafeMath: modulo by zero");
312     }
313 
314     function mod(
315         uint256 a,
316         uint256 b,
317         string memory errorMessage
318     ) internal pure returns (uint256) {
319         require(b != 0, errorMessage);
320         return a % b;
321     }
322 }