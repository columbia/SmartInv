1 pragma solidity =0.6.6;
2 
3 /**
4  * Math operations with safety checks
5  */
6 library SafeMath {
7     function add(uint a, uint b) internal pure returns (uint) {
8         uint c = a + b;
9         require(c >= a, "SafeMath: addition overflow");
10 
11         return c;
12     }
13     function sub(uint a, uint b) internal pure returns (uint) {
14         return sub(a, b, "SafeMath: subtraction overflow");
15     }
16     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
17         require(b <= a, errorMessage);
18         uint c = a - b;
19 
20         return c;
21     }
22     function mul(uint a, uint b) internal pure returns (uint) {
23         if (a == 0) {
24             return 0;
25         }
26 
27         uint c = a * b;
28         require(c / a == b, "SafeMath: multiplication overflow");
29 
30         return c;
31     }
32     function div(uint a, uint b) internal pure returns (uint) {
33         return div(a, b, "SafeMath: division by zero");
34     }
35     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
36         // Solidity only automatically asserts when dividing by 0
37         require(b > 0, errorMessage);
38         uint c = a / b;
39 
40         return c;
41     }
42 }
43 
44 /**
45  * @title Ownable
46  * @dev The Ownable contract has an owner address, and provides basic authorization control
47  * functions, this simplifies the implementation of "user permissions".
48  */
49 contract Ownable {
50     address public owner;
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52     /**
53      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54      * account.
55      */
56     constructor() public {
57         owner = msg.sender;
58     }
59 
60 
61     /**
62      * @dev Throws if called by any account other than the owner.
63      */
64     modifier onlyOwner() {
65         require(msg.sender == owner);
66         _;
67     }
68 
69 
70     /**
71      * @dev Allows the current owner to transfer control of the contract to a newOwner.
72      * @param newOwner The address to transfer ownership to.
73      */
74     function transferOwnership(address newOwner) public onlyOwner {
75         require(newOwner != address(0));
76         emit OwnershipTransferred(owner, newOwner);
77         owner = newOwner;
78     }
79 }
80 
81 interface IUniswapV2Router01 {
82     function factory() external pure returns (address);
83     function WETH() external pure returns (address);
84 
85     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
86     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
87     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
88     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
89 }
90 
91 interface UpgradedPriceAble {
92     function getAmountsOutToken(uint value, uint8 rate) external view returns (uint balance);
93     function getAmountsOutEth(uint value, uint8 rate) external view returns (uint balance);
94 }
95 
96 
97 interface ERC20 {
98     function allowance(address owner, address spender) external view returns (uint256);
99     function transferFrom(address from, address to, uint256 value) external;
100 //    function approve(address spender, uint256 value) public;
101 //    function totalSupply() public view returns (uint256);
102     function balanceOf(address who) external view returns (uint256);
103     function transfer(address to, uint256 value) external;
104 //    event Transfer(address indexed from, address indexed to, uint256 value);
105 //    event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 contract UsdgMarket is Ownable{
109     using SafeMath for uint;
110 
111     uint oneEth = 1000000000000000000;
112     uint8  public buyTokenRate = 100;
113     uint8  public saleTokenRate = 100;
114 
115     IUniswapV2Router01 public uniswapRouter;
116     ERC20 public usdg;
117 
118     address[] pathEth2Usdg;
119     address public upgradedAddress;
120     bool public upgraded = false;
121 
122     event BuyToken(address indexed from,uint inValue, uint outValue);
123     event SaleToken(address indexed from,uint inValue, uint outValue);
124     event GovWithdrawEth(address indexed to, uint256 value);
125     event GovWithdrawToken(address indexed to, uint256 value);
126 
127     modifier ensure(uint deadline) {
128         require(deadline >= block.timestamp, 'Market: EXPIRED');
129         _;
130     }
131 
132     constructor(address _usdg, address _usdt, address _uniswap)public {
133         _setPath(_usdg,_usdt,_uniswap);
134     }
135 
136     function _setPath(address _usdg, address _usdt,address _uniswap)private {
137         uniswapRouter = IUniswapV2Router01(_uniswap);
138         address _weth = uniswapRouter.WETH();
139         usdg = ERC20(_usdg);
140         pathEth2Usdg.push(_weth);
141         pathEth2Usdg.push(_usdt);
142     }
143 
144     function getEthPrice()public view returns (uint balance) {
145         uint[] memory amounts = uniswapRouter.getAmountsOut( oneEth, pathEth2Usdg);
146         return amounts[1];
147     }
148     function _getAmountsOutToken(uint value, uint8 rate) private view returns (uint balance) {
149         uint rs = getEthPrice();  
150         rs = rs.mul(value).div(oneEth);
151         if(rate > 0){
152             rs = rs.mul(rate).div(100);
153         }
154         rs = rs.mul(1000); 
155         return rs;
156     }
157 
158     function _getAmountsOutEth(uint value, uint8 rate) private view returns (uint balance) {
159         uint ePrice = getEthPrice();   
160         uint uPrice = oneEth.div(ePrice);  
161         uint rs = uPrice.mul(value);
162         if(rate > 0){
163             rs = rs.mul(rate).div(100);
164         }
165         rs = rs.div(1000); 
166         return rs;
167     }
168 
169     function getAmountsOutToken(uint _value) public view returns (uint balance) {
170         uint amount;
171         if (upgraded) {
172             amount = UpgradedPriceAble(upgradedAddress).getAmountsOutToken(_value,buyTokenRate);
173         } else {
174             amount = _getAmountsOutToken(_value,buyTokenRate);
175         }
176         return amount;
177     }
178 
179     function getAmountsOutEth(uint _value) public view returns (uint balance) {
180         uint amount;
181         if (upgraded) {
182             amount = UpgradedPriceAble(upgradedAddress).getAmountsOutToken(_value,saleTokenRate);
183         } else {
184             amount = _getAmountsOutEth(_value,saleTokenRate);
185         }
186         return amount;
187     }
188 
189     function buyTokenSafe(uint amountOutMin,  uint deadline)payable ensure(deadline) public {
190         require(msg.value > 0, "!value");
191         uint amount = getAmountsOutToken(msg.value);
192         require(amount >= amountOutMin, 'INSUFFICIENT_OUTPUT_AMOUNT');
193         uint balanced = usdg.balanceOf(address(this));
194         require(balanced >= amount, "!contract balanced");
195         usdg.transfer(msg.sender, amount);
196         BuyToken(msg.sender,msg.value, amount);
197     }
198 
199     function saleTokenSafe(uint256 _value,uint amountOutMin,  uint deadline) ensure(deadline) public {
200         require(_value > 0, "!value");
201         uint amount = getAmountsOutEth(_value);
202         require(amount >= amountOutMin, 'INSUFFICIENT_OUTPUT_AMOUNT');
203         msg.sender.transfer(amount);
204         uint allowed = usdg.allowance(msg.sender,address(this));
205         uint balanced = usdg.balanceOf(msg.sender);
206         require(allowed >= _value, "!allowed");
207         require(balanced >= _value, "!balanced");
208         usdg.transferFrom( msg.sender,address(this), _value);
209         SaleToken(msg.sender,_value, amount);
210     }
211 
212     function buyToken()payable  public {
213         require(msg.value > 0, "!value");
214         uint amount = getAmountsOutToken(msg.value);
215         uint balanced = usdg.balanceOf(address(this));
216         require(balanced >= amount, "!contract balanced");
217         usdg.transfer(msg.sender, amount);
218         BuyToken(msg.sender,msg.value, amount);
219     }
220 
221     function saleToken(uint256 _value) public {
222         require(_value > 0, "!value");
223         uint amount = getAmountsOutEth(_value);
224         msg.sender.transfer(amount);
225         uint allowed = usdg.allowance(msg.sender,address(this));
226         uint balanced = usdg.balanceOf(msg.sender);
227         require(allowed >= _value, "!allowed");
228         require(balanced >= _value, "!balanced");
229         usdg.transferFrom( msg.sender,address(this), _value);
230         SaleToken(msg.sender,_value, amount);
231     }
232 
233     function govWithdrawToken(uint256 _amount)onlyOwner public {
234         require(_amount > 0, "!zero input");
235 
236         usdg.transfer( msg.sender, _amount);
237         emit GovWithdrawToken(msg.sender, _amount);
238     }
239 
240     function govWithdrawEth(uint256 _amount)onlyOwner public {
241         require(_amount > 0, "!zero input");
242         msg.sender.transfer(_amount);
243         emit GovWithdrawEth(msg.sender, _amount);
244     }
245 
246     function changeRates(uint8 _buyTokenRate, uint8 _saleTokenRate)onlyOwner public {
247         require(201 > buyTokenRate, "_buyTokenRate big than 200");
248         require(201 > _saleTokenRate, "_saleTokenRate big than 200");
249         buyTokenRate = _buyTokenRate;
250         saleTokenRate = _saleTokenRate;
251     }
252 
253     fallback() external payable {}
254 }