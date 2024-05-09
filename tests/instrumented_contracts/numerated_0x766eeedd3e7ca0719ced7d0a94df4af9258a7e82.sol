1 pragma solidity ^0.5.2;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 interface IERC20 {
10     function transfer(address to, uint256 value) external returns (bool);
11 
12     function approve(address spender, uint256 value) external returns (bool);
13 
14     function transferFrom(address from, address to, uint256 value) external returns (bool);
15 
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address who) external view returns (uint256);
19 
20     function allowance(address owner, address spender) external view returns (uint256);
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
28 
29 /**
30  * @title SafeMath
31  * @dev Unsigned math operations with safety checks that revert on error
32  */
33 library SafeMath {
34     /**
35     * @dev Multiplies two unsigned integers, reverts on overflow.
36     */
37     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
39         // benefit is lost if 'b' is also tested.
40         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
41         if (a == 0) {
42             return 0;
43         }
44 
45         uint256 c = a * b;
46         require(c / a == b);
47 
48         return c;
49     }
50 
51     /**
52     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
53     */
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {
55         // Solidity only automatically asserts when dividing by 0
56         require(b > 0);
57         uint256 c = a / b;
58         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59 
60         return c;
61     }
62 
63     /**
64     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
65     */
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         require(b <= a);
68         uint256 c = a - b;
69 
70         return c;
71     }
72 
73     /**
74     * @dev Adds two unsigned integers, reverts on overflow.
75     */
76     function add(uint256 a, uint256 b) internal pure returns (uint256) {
77         uint256 c = a + b;
78         require(c >= a);
79 
80         return c;
81     }
82 
83     /**
84     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
85     * reverts when dividing by zero.
86     */
87     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
88         require(b != 0);
89         return a % b;
90     }
91 }
92 
93 // File: uniswap-solidity/contracts/UniswapFactoryInterface.sol
94 
95 // https://docs.uniswap.io/smart-contract-integration/interface
96 contract UniswapFactoryInterface {
97     // Public Variables
98     address public exchangeTemplate;
99     uint256 public tokenCount;
100     // Create Exchange
101     function createExchange(address token) external returns (address exchange);
102     // Get Exchange and Token Info
103     function getExchange(address token) external view returns (address exchange);
104     function getToken(address exchange) external view returns (address token);
105     function getTokenWithId(uint256 tokenId) external view returns (address token);
106     // Never use
107     function initializeFactory(address template) external;
108 }
109 
110 // File: uniswap-solidity/contracts/UniswapExchangeInterface.sol
111 
112 // https://docs.uniswap.io/smart-contract-integration/interface
113 contract UniswapExchangeInterface {
114     // Address of ERC20 token sold on this exchange
115     function tokenAddress() external view returns (address token);
116     // Address of Uniswap Factory
117     function factoryAddress() external view returns (address factory);
118     // Provide Liquidity
119     function addLiquidity(uint256 min_liquidity, uint256 max_tokens, uint256 deadline) external payable returns (uint256);
120     function removeLiquidity(uint256 amount, uint256 min_eth, uint256 min_tokens, uint256 deadline) external returns (uint256, uint256);
121     // Get Prices
122     function getEthToTokenInputPrice(uint256 eth_sold) external view returns (uint256 tokens_bought);
123     function getEthToTokenOutputPrice(uint256 tokens_bought) external view returns (uint256 eth_sold);
124     function getTokenToEthInputPrice(uint256 tokens_sold) external view returns (uint256 eth_bought);
125     function getTokenToEthOutputPrice(uint256 eth_bought) external view returns (uint256 tokens_sold);
126     // Trade ETH to ERC20
127     function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline) external payable returns (uint256  tokens_bought);
128     function ethToTokenTransferInput(uint256 min_tokens, uint256 deadline, address recipient) external payable returns (uint256  tokens_bought);
129     function ethToTokenSwapOutput(uint256 tokens_bought, uint256 deadline) external payable returns (uint256  eth_sold);
130     function ethToTokenTransferOutput(uint256 tokens_bought, uint256 deadline, address recipient) external payable returns (uint256  eth_sold);
131     // Trade ERC20 to ETH
132     function tokenToEthSwapInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline) external returns (uint256  eth_bought);
133     function tokenToEthTransferInput(uint256 tokens_sold, uint256 min_tokens, uint256 deadline, address recipient) external returns (uint256  eth_bought);
134     function tokenToEthSwapOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline) external returns (uint256  tokens_sold);
135     function tokenToEthTransferOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline, address recipient) external returns (uint256  tokens_sold);
136     // Trade ERC20 to ERC20
137     function tokenToTokenSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address token_addr) external returns (uint256  tokens_bought);
138     function tokenToTokenTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_bought);
139     function tokenToTokenSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address token_addr) external returns (uint256  tokens_sold);
140     function tokenToTokenTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_sold);
141     // Trade ERC20 to Custom Pool
142     function tokenToExchangeSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address exchange_addr) external returns (uint256  tokens_bought);
143     function tokenToExchangeTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_bought);
144     function tokenToExchangeSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address exchange_addr) external returns (uint256  tokens_sold);
145     function tokenToExchangeTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_sold);
146     // ERC20 comaptibility for liquidity tokens
147     bytes32 public name;
148     bytes32 public symbol;
149     uint256 public decimals;
150     function transfer(address _to, uint256 _value) external returns (bool);
151     function transferFrom(address _from, address _to, uint256 value) external returns (bool);
152     function approve(address _spender, uint256 _value) external returns (bool);
153     function allowance(address _owner, address _spender) external view returns (uint256);
154     function balanceOf(address _owner) external view returns (uint256);
155     // Never use
156     function setup(address token_addr) external;
157 }
158 
159 // File: uniswap-solidity/contracts/Uniswap.sol
160 
161 
162 
163 // File: contracts/safe/SafeERC20.sol
164 
165 library SafeERC20 {
166     using SafeMath for uint256;
167 
168     function transferTokens(
169       IERC20 _token,
170       address _from,
171       address _to,
172       uint256 _value
173     ) internal {
174         uint256 oldBalance = _token.balanceOf(_to);
175         require(
176             _token.transferFrom(_from, _to, _value),
177             "Failed to transfer tokens."
178         );
179         require(
180             _token.balanceOf(_to) >= oldBalance.add(_value),
181             "Balance validation failed after transfer."
182         );
183     }
184 
185     function approveTokens(
186       IERC20 _token,
187       address _spender,
188       uint256 _value
189     ) internal {
190         uint256 nextAllowance =
191           _token.allowance(address(this), _spender).add(_value);
192         require(
193             _token.approve(_spender, nextAllowance),
194             "Failed to approve exchange withdrawal of tokens."
195         );
196         require(
197             _token.allowance(address(this), _spender) >= nextAllowance,
198             "Failed to validate token approval."
199         );
200     }
201 }
202 
203 // File: contracts/safe/SafeExchange.sol
204 
205 library SafeExchange {
206     using SafeMath for uint256;
207 
208     modifier swaps(uint256 _value, IERC20 _token) {
209         uint256 nextBalance = _token.balanceOf(address(this)).add(_value);
210         _;
211         require(
212             _token.balanceOf(address(this)) >= nextBalance,
213             "Balance validation failed after swap."
214         );
215     }
216 
217     function swapTokens(
218         UniswapExchangeInterface _exchange,
219         uint256 _outValue,
220         uint256 _inValue,
221         uint256 _ethValue,
222         uint256 _deadline,
223         IERC20 _outToken
224     ) internal swaps(_outValue, _outToken) {
225         _exchange.tokenToTokenSwapOutput(
226             _outValue,
227             _inValue,
228             _ethValue,
229             _deadline,
230             address(_outToken)
231         );
232     }
233 
234     function swapEther(
235         UniswapExchangeInterface _exchange,
236         uint256 _outValue,
237         uint256 _ethValue,
238         uint256 _deadline,
239         IERC20 _outToken
240     ) internal swaps(_outValue, _outToken) {
241         _exchange.ethToTokenSwapOutput.value(_ethValue)(_outValue, _deadline);
242     }
243 }
244 
245 // File: contracts/Unipay.sol
246 
247 contract Unipay {
248     using SafeMath for uint256;
249     using SafeERC20 for IERC20;
250     using SafeExchange for UniswapExchangeInterface;
251 
252     UniswapFactoryInterface factory;
253     IERC20 outToken;
254     address recipient;
255 
256     constructor(address _factory, address _recipient, address _token) public {
257         factory = UniswapFactoryInterface(_factory);
258         outToken = IERC20(_token);
259         recipient = _recipient;
260     }
261 
262     function price(
263         address _token,
264         uint256 _value
265     ) public view returns (uint256, uint256, UniswapExchangeInterface) {
266         UniswapExchangeInterface inExchange =
267           UniswapExchangeInterface(factory.getExchange(_token));
268         UniswapExchangeInterface outExchange =
269           UniswapExchangeInterface(factory.getExchange(address(outToken)));
270         uint256 etherCost = outExchange.getEthToTokenOutputPrice(_value);
271         uint256 tokenCost = inExchange.getTokenToEthOutputPrice(etherCost);
272         return (tokenCost, etherCost, inExchange);
273     }
274 
275     function price(
276       uint256 _value
277     ) public view returns (uint256, UniswapExchangeInterface) {
278       UniswapExchangeInterface exchange =
279         UniswapExchangeInterface(factory.getExchange(address(outToken)));
280       return (exchange.getEthToTokenOutputPrice(_value), exchange);
281     }
282 
283     function collect(
284         address _from,
285         address _token,
286         uint256 _value,
287         uint256 _deadline
288     ) public {
289         (
290             uint256 tokenCost,
291             uint256 etherCost,
292             UniswapExchangeInterface exchange
293         ) = price(_token, _value);
294 
295         IERC20(_token).transferTokens(_from, address(this), tokenCost);
296         IERC20(_token).approveTokens(address(exchange), tokenCost);
297         exchange.swapTokens(_value, tokenCost, etherCost, _deadline, outToken);
298         outToken.approveTokens(recipient, _value);
299     }
300 
301     function pay(
302         uint256 _value,
303         uint256 _deadline
304     ) public payable {
305         (
306             uint256 etherCost,
307             UniswapExchangeInterface exchange
308         ) = price(_value);
309 
310         require(msg.value >= etherCost, "Insufficient ether sent.");
311         exchange.swapEther(_value, etherCost, _deadline, outToken);
312         outToken.approveTokens(recipient, _value);
313         msg.sender.transfer(msg.value.sub(etherCost));
314     }
315 }