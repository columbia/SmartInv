1 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11     address private _owner;
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     constructor () internal {
20         _owner = msg.sender;
21         emit OwnershipTransferred(address(0), _owner);
22     }
23 
24     /**
25      * @return the address of the owner.
26      */
27     function owner() public view returns (address) {
28         return _owner;
29     }
30 
31     /**
32      * @dev Throws if called by any account other than the owner.
33      */
34     modifier onlyOwner() {
35         require(isOwner());
36         _;
37     }
38 
39     /**
40      * @return true if `msg.sender` is the owner of the contract.
41      */
42     function isOwner() public view returns (bool) {
43         return msg.sender == _owner;
44     }
45 
46     /**
47      * @dev Allows the current owner to relinquish control of the contract.
48      * @notice Renouncing to ownership will leave the contract without an owner.
49      * It will not be possible to call the functions with the `onlyOwner`
50      * modifier anymore.
51      */
52     function renounceOwnership() public onlyOwner {
53         emit OwnershipTransferred(_owner, address(0));
54         _owner = address(0);
55     }
56 
57     /**
58      * @dev Allows the current owner to transfer control of the contract to a newOwner.
59      * @param newOwner The address to transfer ownership to.
60      */
61     function transferOwnership(address newOwner) public onlyOwner {
62         _transferOwnership(newOwner);
63     }
64 
65     /**
66      * @dev Transfers control of the contract to a newOwner.
67      * @param newOwner The address to transfer ownership to.
68      */
69     function _transferOwnership(address newOwner) internal {
70         require(newOwner != address(0));
71         emit OwnershipTransferred(_owner, newOwner);
72         _owner = newOwner;
73     }
74 }
75 
76 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
77 
78 pragma solidity ^0.5.0;
79 
80 /**
81  * @title ERC20 interface
82  * @dev see https://github.com/ethereum/EIPs/issues/20
83  */
84 interface IERC20 {
85     function transfer(address to, uint256 value) external returns (bool);
86 
87     function approve(address spender, uint256 value) external returns (bool);
88 
89     function transferFrom(address from, address to, uint256 value) external returns (bool);
90 
91     function totalSupply() external view returns (uint256);
92 
93     function balanceOf(address who) external view returns (uint256);
94 
95     function allowance(address owner, address spender) external view returns (uint256);
96 
97     event Transfer(address indexed from, address indexed to, uint256 value);
98 
99     event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 // File: contracts/uniswap/UniswapExchangeInterface.sol
103 
104 pragma solidity ^0.5.0;
105 
106 contract UniswapExchangeInterface {
107     // Address of ERC20 token sold on this exchange
108     function tokenAddress() external view returns (address token);
109     // Address of Uniswap Factory
110     function factoryAddress() external view returns (address factory);
111     // Provide Liquidity
112     function addLiquidity(uint256 min_liquidity, uint256 max_tokens, uint256 deadline) external payable returns (uint256);
113     function removeLiquidity(uint256 amount, uint256 min_eth, uint256 min_tokens, uint256 deadline) external returns (uint256, uint256);
114     // Get Prices
115     function getEthToTokenInputPrice(uint256 eth_sold) external view returns (uint256 tokens_bought);
116     function getEthToTokenOutputPrice(uint256 tokens_bought) external view returns (uint256 eth_sold);
117     function getTokenToEthInputPrice(uint256 tokens_sold) external view returns (uint256 eth_bought);
118     function getTokenToEthOutputPrice(uint256 eth_bought) external view returns (uint256 tokens_sold);
119     // Trade ETH to ERC20
120     function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline) external payable returns (uint256  tokens_bought);
121     function ethToTokenTransferInput(uint256 min_tokens, uint256 deadline, address recipient) external payable returns (uint256  tokens_bought);
122     function ethToTokenSwapOutput(uint256 tokens_bought, uint256 deadline) external payable returns (uint256  eth_sold);
123     function ethToTokenTransferOutput(uint256 tokens_bought, uint256 deadline, address recipient) external payable returns (uint256  eth_sold);
124     // Trade ERC20 to ETH
125     function tokenToEthSwapInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline) external returns (uint256  eth_bought);
126     function tokenToEthTransferInput(uint256 tokens_sold, uint256 min_tokens, uint256 deadline, address recipient) external returns (uint256  eth_bought);
127     function tokenToEthSwapOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline) external returns (uint256  tokens_sold);
128     function tokenToEthTransferOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline, address recipient) external returns (uint256  tokens_sold);
129     // Trade ERC20 to ERC20
130     function tokenToTokenSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address token_addr) external returns (uint256  tokens_bought);
131     function tokenToTokenTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_bought);
132     function tokenToTokenSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address token_addr) external returns (uint256  tokens_sold);
133     function tokenToTokenTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_sold);
134     // Trade ERC20 to Custom Pool
135     function tokenToExchangeSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address exchange_addr) external returns (uint256  tokens_bought);
136     function tokenToExchangeTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_bought);
137     function tokenToExchangeSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address exchange_addr) external returns (uint256  tokens_sold);
138     function tokenToExchangeTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_sold);
139     // ERC20 comaptibility for liquidity tokens
140     bytes32 public name;
141     bytes32 public symbol;
142     uint256 public decimals;
143     function transfer(address _to, uint256 _value) external returns (bool);
144     function transferFrom(address _from, address _to, uint256 value) external returns (bool);
145     function approve(address _spender, uint256 _value) external returns (bool);
146     function allowance(address _owner, address _spender) external view returns (uint256);
147     function balanceOf(address _owner) external view returns (uint256);
148     // Never use
149     function setup(address token_addr) external;
150 }
151 
152 // File: contracts/uniswap/UniswapFactoryInterface.sol
153 
154 pragma solidity ^0.5.0;
155 
156 contract UniswapFactoryInterface {
157     // Public Variables
158     address public exchangeTemplate;
159     uint256 public tokenCount;
160     // Create Exchange
161     function createExchange(address token) external returns (address exchange);
162     // Get Exchange and Token Info
163     function getExchange(address token) external view returns (address exchange);
164     function getToken(address exchange) external view returns (address token);
165     function getTokenWithId(uint256 tokenId) external view returns (address token);
166     // Never use
167     function initializeFactory(address template) external;
168 }
169 
170 // File: contracts/PaymentProcessor.sol
171 
172 pragma solidity ^0.5.0;
173 
174 
175 
176 
177 
178 contract PaymentProcessor is Ownable {
179     uint256 constant UINT256_MAX = ~uint256(0);
180 
181     address public fundManager;
182     UniswapFactoryInterface public uniswapFactory;
183     address public intermediaryToken;
184     UniswapExchangeInterface public intermediaryTokenExchange;
185 
186     constructor(UniswapFactoryInterface uniswapFactory_)
187         public {
188         uniswapFactory = uniswapFactory_;
189     }
190 
191     function setFundManager(address fundManager_)
192         onlyOwner
193         public {
194         fundManager = fundManager_;
195     }
196 
197     function isFundManager()
198         public view
199         returns (bool) {
200         return isOwner() || msg.sender == fundManager;
201     }
202 
203     function setIntermediaryToken(address token)
204         onlyFundManager
205         external {
206         intermediaryToken = token;
207         if (token != address(0)) {
208             intermediaryTokenExchange = UniswapExchangeInterface(uniswapFactory.getExchange(token));
209             require(address(intermediaryTokenExchange) != address(0), "The token does not have an exchange");
210         } else {
211             intermediaryTokenExchange = UniswapExchangeInterface(address(0));
212         }
213     }
214 
215     function depositEther(uint64 orderId)
216         payable
217         external {
218         require(msg.value > 0, "Minimal deposit is 0");
219         uint256 amountBought = 0;
220         if (intermediaryToken != address(0)) {
221             amountBought = intermediaryTokenExchange.ethToTokenSwapInput.value(msg.value)(
222                 1 /* min_tokens */,
223                 UINT256_MAX /* deadline */);
224         }
225         emit EtherDepositReceived(orderId, msg.value, intermediaryToken, amountBought);
226     }
227 
228     function withdrawEther(uint256 amount, address payable to)
229         onlyFundManager
230         external {
231         to.transfer(amount);
232         emit EtherDepositWithdrawn(to, amount);
233     }
234 
235     function withdrawToken(IERC20 token, uint256 amount, address to)
236         onlyFundManager
237         external {
238         require(token.transfer(to, amount), "Withdraw token failed");
239         emit TokenDepositWithdrawn(address(token), to, amount);
240     }
241 
242 
243     function depositToken(uint64 orderId, address depositor, IERC20 inputToken, uint256 amount)
244         hasExchange(address(inputToken))
245         onlyFundManager
246         external {
247         require(address(inputToken) != address(0), "Input token cannont be ZERO_ADDRESS");
248         UniswapExchangeInterface tokenExchange = UniswapExchangeInterface(uniswapFactory.getExchange(address(inputToken)));
249         require(inputToken.allowance(depositor, address(this)) >= amount, "Not enough allowance");
250         inputToken.transferFrom(depositor, address(this), amount);
251         uint256 amountBought = 0;
252         if (intermediaryToken != address(0)) {
253             if (intermediaryToken != address(inputToken)) {
254                 inputToken.approve(address(tokenExchange), amount);
255                 amountBought = tokenExchange.tokenToTokenSwapInput(
256                     amount /* (input) tokens_sold */,
257                     1 /* (output) min_tokens_bought */,
258                     1 /*  min_eth_bought */,
259                     UINT256_MAX /* deadline */,
260                     intermediaryToken /* (input) token_addr */);
261             } else {
262                 // same token
263                 amountBought = amount;
264             }
265         } else {
266             inputToken.approve(address(tokenExchange), amount);
267             amountBought = tokenExchange.tokenToEthSwapInput(
268                 amount /* tokens_sold */,
269                 1 /* min_eth */,
270                 UINT256_MAX /* deadline */);
271         }
272         emit TokenDepositReceived(orderId, address(inputToken), amount, intermediaryToken, amountBought);
273     }
274 
275     event EtherDepositReceived(uint64 indexed orderId, uint256 amount, address intermediaryToken, uint256 amountBought);
276     event EtherDepositWithdrawn(address to, uint256 amount);
277     event TokenDepositReceived(uint64 indexed orderId, address indexed inputToken, uint256 amount, address intermediaryToken, uint256 amountBought);
278     event TokenDepositWithdrawn(address indexed token, address to, uint256 amount);
279 
280     modifier hasExchange(address token) {
281         address tokenExchange = uniswapFactory.getExchange(token);
282         require(tokenExchange != address(0), "Token doesn't have an exchange");
283         _;
284     }
285 
286     modifier onlyFundManager() {
287         require(isFundManager(), "Only fund manager allowed");
288         _;
289     }
290 }