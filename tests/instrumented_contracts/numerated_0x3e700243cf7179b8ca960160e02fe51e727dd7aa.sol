1 /**
2  * Source Code first verified at https://etherscan.io on Thursday, May 30, 2019
3  (UTC) */
4 
5 pragma solidity ^0.5.7;
6 
7 /**
8  * @title SafeMath
9  * @dev Unsigned math operations with safety checks that revert on error.
10  */
11 library SafeMath {
12 
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         if (a == 0) {
15             return 0;
16         }
17 
18         uint256 c = a * b;
19         require(c / a == b, "SafeMath: multiplication overflow");
20 
21         return c;
22     }
23 
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         require(b > 0, "SafeMath: division by zero");
26         uint256 c = a / b;
27 
28         return c;
29     }
30 
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32         require(b <= a, "SafeMath: subtraction overflow");
33         uint256 c = a - b;
34 
35         return c;
36     }
37 
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         require(c >= a, "SafeMath: addition overflow");
41 
42         return c;
43     }
44 
45     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
46         require(b != 0, "SafeMath: modulo by zero");
47         return a % b;
48     }
49 }
50 
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57 
58     address internal _owner;
59 
60     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62     constructor(address initialOwner) internal {
63         _owner = initialOwner;
64         emit OwnershipTransferred(address(0), _owner);
65     }
66 
67     function owner() public view returns (address) {
68         return _owner;
69     }
70 
71     modifier onlyOwner() {
72         require(isOwner(), "Caller is not the owner");
73         _;
74     }
75 
76     function isOwner() public view returns (bool) {
77         return msg.sender == _owner;
78     }
79 
80     function renounceOwnership() public onlyOwner {
81         emit OwnershipTransferred(_owner, address(0));
82         _owner = address(0);
83     }
84 
85     function transferOwnership(address newOwner) public onlyOwner {
86         require(newOwner != address(0), "New owner is the zero address");
87         emit OwnershipTransferred(_owner, newOwner);
88         _owner = newOwner;
89     }
90 
91 }
92 
93 /**
94  * @title ERC20 interface
95  * @dev see https://eips.ethereum.org/EIPS/eip-20
96  */
97 interface IERC20 {
98     function transfer(address to, uint256 value) external returns (bool);
99     function balanceOf(address who) external view returns (uint256);
100 }
101 
102 /**
103  * @title PriceReceiver interface
104  * @dev Inherit from PriceReceiver to use the PriceProvider contract.
105  */
106 contract PriceReceiver {
107 
108     address public ethPriceProvider;
109 
110     modifier onlyEthPriceProvider() {
111         require(msg.sender == ethPriceProvider);
112         _;
113     }
114 
115     function receiveEthPrice(uint256 newPrice) external;
116 
117     function setEthPriceProvider(address provider) external;
118 
119 }
120 
121 /**
122  * @dev Contract module that helps prevent reentrant calls to a function.
123  */
124 contract ReentrancyGuard {
125     uint256 private _guardCounter;
126 
127     constructor () internal {
128         _guardCounter = 1;
129     }
130 
131     modifier nonReentrant() {
132         _guardCounter += 1;
133         uint256 localCounter = _guardCounter;
134         _;
135         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
136     }
137 }
138 
139 /**
140  * @title Crowdsale contract
141  * @author https://grox.solutions
142  */
143 contract Crowdsale is ReentrancyGuard, PriceReceiver, Ownable {
144     using SafeMath for uint256;
145 
146     // The token being sold
147     IERC20 private _token;
148 
149     // Address where funds are collected
150     address payable private _wallet;
151 
152     // Amount of wei raised
153     uint256 private _weiRaised;
154 
155     // Price of 1 ether in USD Cents
156     uint256 private _currentETHPrice;
157 
158     // How many token units a buyer gets per 1 USD Cent
159     uint256 private _rate;
160 
161     // Minimum amount of wei to invest
162     uint256 private _minimum = 0.5 ether;
163 
164     event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
165     event NewETHPrice(uint256 oldValue, uint256 newValue);
166 
167     /**
168      * @param rate Number of token units a buyer gets per wei
169      * @param initialETHPrice Price of Ether in USD Cents
170      * @param wallet Address where collected funds will be forwarded to
171      * @param token Address of the token being sold
172      */
173     constructor (uint256 rate, uint256 initialETHPrice, address payable wallet, IERC20 token, address initialOwner) public Ownable(initialOwner) {
174         require(rate != 0, "Rate is 0");
175         require(initialETHPrice != 0, "Initial ETH price is 0");
176         require(wallet != address(0), "Wallet is the zero address");
177         require(address(token) != address(0), "Token is the zero address");
178 
179         _rate = rate;
180         _currentETHPrice = initialETHPrice;
181         _wallet = wallet;
182         _token = token;
183     }
184 
185     /**
186      * @dev fallback function
187      */
188     function() external payable {
189         buyTokens(msg.sender);
190     }
191 
192     /**
193      * @dev low level token purchase
194      * This function has a non-reentrancy guard
195      * @param beneficiary Recipient of the token purchase
196      */
197     function buyTokens(address beneficiary) public nonReentrant payable {
198         require(beneficiary != address(0), "Beneficiary is the zero address");
199         require(msg.value >= _minimum, "Wei amount is less than 0.5 ether");
200 
201         uint256 weiAmount = msg.value;
202 
203         uint256 tokens = getTokenAmount(weiAmount);
204 
205         _weiRaised = _weiRaised.add(weiAmount);
206 
207         _wallet.transfer(weiAmount);
208 
209         _token.transfer(beneficiary, tokens);
210 
211         emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokens);
212     }
213 
214     /**
215      * @dev Calculate amount of tokens to recieve for a given amount of wei
216      * @param weiAmount Value in wei to be converted into tokens
217      * @return Number of tokens that can be purchased with the specified _weiAmount
218      */
219     function getTokenAmount(uint256 weiAmount) public view returns(uint256) {
220         return weiAmount.mul(_currentETHPrice).div(1 ether).mul(_rate);
221     }
222 
223     /**
224      * @dev Function to change the rate.
225      * Available only to the owner.
226      * @param newRate new value.
227      */
228     function setRate(uint256 newRate) external onlyOwner {
229         require(newRate != 0, "New rate is 0");
230 
231         _rate = newRate;
232     }
233 
234     /**
235      * @dev Function to change the PriceProvider address.
236      * Available only to the owner.
237      * @param provider new address.
238      */
239     function setEthPriceProvider(address provider) external onlyOwner {
240         require(provider != address(0), "Provider is the zero address");
241 
242         ethPriceProvider = provider;
243     }
244 
245     /**
246      * @dev Function to change the address to receive ether.
247      * Available only to the owner.
248      * @param newWallet new address.
249      */
250     function setWallet(address payable newWallet) external onlyOwner {
251         require(newWallet != address(0), "New wallet is the zero address");
252 
253         _wallet = newWallet;
254     }
255 
256     /**
257      * @dev Function to change the ETH Price.
258      * Available only to the owner and to the PriceProvider.
259      * @param newPrice amount of USD Cents for 1 ether.
260      */
261     function receiveEthPrice(uint256 newPrice) external {
262         require(newPrice != 0, "New price is 0");
263         require(msg.sender == ethPriceProvider || msg.sender == _owner, "Sender has no permission");
264 
265         emit NewETHPrice(_currentETHPrice, newPrice);
266         _currentETHPrice = newPrice;
267     }
268 
269     /**
270     * @dev Allows to any owner of the contract withdraw needed ERC20 token from this contract (promo or bounties for example).
271     * @param ERC20Token Address of ERC20 token.
272     * @param recipient Account to receive tokens.
273     */
274     function withdrawERC20(address ERC20Token, address recipient) external onlyOwner {
275 
276         uint256 amount = IERC20(ERC20Token).balanceOf(address(this));
277         IERC20(ERC20Token).transfer(recipient, amount);
278 
279     }
280 
281     /**
282      * @return the token being sold.
283      */
284     function token() public view returns (IERC20) {
285         return _token;
286     }
287 
288     /**
289      * @return the address where funds are collected.
290      */
291     function wallet() public view returns (address payable) {
292         return _wallet;
293     }
294 
295     /**
296      * @return the number of token units a buyer gets per wei.
297      */
298     function rate() public view returns (uint256) {
299         return _rate;
300     }
301 
302     /**
303      * @return the price of 1 ether in USD Cents.
304      */
305     function currentETHPrice() public view returns (uint256) {
306         return _currentETHPrice;
307     }
308 
309     /**
310      * @return minimum amount of wei to invest.
311      */
312     function minimum() public view returns (uint256) {
313         return _minimum;
314     }
315 
316     /**
317      * @return the amount of wei raised.
318      */
319     function weiRaised() public view returns (uint256) {
320         return _weiRaised;
321     }
322 
323 }