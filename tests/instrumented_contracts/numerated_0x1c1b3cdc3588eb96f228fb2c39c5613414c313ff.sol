1 pragma solidity ^0.5.7;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error.
6  */
7 library SafeMath {
8 
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         if (a == 0) {
11             return 0;
12         }
13 
14         uint256 c = a * b;
15         require(c / a == b, "SafeMath: multiplication overflow");
16 
17         return c;
18     }
19 
20     function div(uint256 a, uint256 b) internal pure returns (uint256) {
21         require(b > 0, "SafeMath: division by zero");
22         uint256 c = a / b;
23 
24         return c;
25     }
26 
27     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28         require(b <= a, "SafeMath: subtraction overflow");
29         uint256 c = a - b;
30 
31         return c;
32     }
33 
34     function add(uint256 a, uint256 b) internal pure returns (uint256) {
35         uint256 c = a + b;
36         require(c >= a, "SafeMath: addition overflow");
37 
38         return c;
39     }
40 
41     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
42         require(b != 0, "SafeMath: modulo by zero");
43         return a % b;
44     }
45 }
46 
47 /**
48  * @title Ownable
49  * @dev The Ownable contract has an owner address, and provides basic authorization control
50  * functions, this simplifies the implementation of "user permissions".
51  */
52 contract Ownable {
53 
54     address internal _owner;
55 
56     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
57 
58     constructor(address initialOwner) internal {
59         _owner = initialOwner;
60         emit OwnershipTransferred(address(0), _owner);
61     }
62 
63     function owner() public view returns (address) {
64         return _owner;
65     }
66 
67     modifier onlyOwner() {
68         require(isOwner(), "Caller is not the owner");
69         _;
70     }
71 
72     function isOwner() public view returns (bool) {
73         return msg.sender == _owner;
74     }
75 
76     function renounceOwnership() public onlyOwner {
77         emit OwnershipTransferred(_owner, address(0));
78         _owner = address(0);
79     }
80 
81     function transferOwnership(address newOwner) public onlyOwner {
82         require(newOwner != address(0), "New owner is the zero address");
83         emit OwnershipTransferred(_owner, newOwner);
84         _owner = newOwner;
85     }
86 
87 }
88 
89 /**
90  * @title ERC20 interface
91  * @dev see https://eips.ethereum.org/EIPS/eip-20
92  */
93 interface IERC20 {
94     function transfer(address to, uint256 value) external returns (bool);
95     function balanceOf(address who) external view returns (uint256);
96 }
97 
98 /**
99  * @title PriceReceiver interface
100  * @dev Inherit from PriceReceiver to use the PriceProvider contract.
101  */
102 contract PriceReceiver {
103 
104     address public ethPriceProvider;
105 
106     modifier onlyEthPriceProvider() {
107         require(msg.sender == ethPriceProvider);
108         _;
109     }
110 
111     function receiveEthPrice(uint256 newPrice) external;
112 
113     function setEthPriceProvider(address provider) external;
114 
115 }
116 
117 /**
118  * @dev Contract module that helps prevent reentrant calls to a function.
119  */
120 contract ReentrancyGuard {
121     uint256 private _guardCounter;
122 
123     constructor () internal {
124         _guardCounter = 1;
125     }
126 
127     modifier nonReentrant() {
128         _guardCounter += 1;
129         uint256 localCounter = _guardCounter;
130         _;
131         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
132     }
133 }
134 
135 /**
136  * @title Crowdsale contract
137  * @author https://grox.solutions
138  */
139 contract Crowdsale is ReentrancyGuard, PriceReceiver, Ownable {
140     using SafeMath for uint256;
141 
142     // The token being sold
143     IERC20 private _token;
144 
145     // Address where funds are collected
146     address payable private _wallet;
147 
148     // Amount of wei raised
149     uint256 private _weiRaised;
150 
151     // Price of 1 ether in USD Cents
152     uint256 private _currentETHPrice;
153 
154     // How many token units a buyer gets per 1 USD Cent
155     uint256 private _rate;
156 
157     // Minimum amount of wei to invest
158     uint256 private _minimum = 0.5 ether;
159 
160     event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
161     event NewETHPrice(uint256 oldValue, uint256 newValue);
162 
163     /**
164      * @param rate Number of token units a buyer gets per wei
165      * @param initialETHPrice Price of Ether in USD Cents
166      * @param wallet Address where collected funds will be forwarded to
167      * @param token Address of the token being sold
168      */
169     constructor (uint256 rate, uint256 initialETHPrice, address payable wallet, IERC20 token, address initialOwner) public Ownable(initialOwner) {
170         require(rate != 0, "Rate is 0");
171         require(initialETHPrice != 0, "Initial ETH price is 0");
172         require(wallet != address(0), "Wallet is the zero address");
173         require(address(token) != address(0), "Token is the zero address");
174 
175         _rate = rate;
176         _wallet = wallet;
177         _token = token;
178     }
179 
180     /**
181      * @dev fallback function
182      */
183     function() external payable {
184         buyTokens(msg.sender);
185     }
186 
187     /**
188      * @dev low level token purchase
189      * This function has a non-reentrancy guard
190      * @param beneficiary Recipient of the token purchase
191      */
192     function buyTokens(address beneficiary) public nonReentrant payable {
193         require(beneficiary != address(0), "Beneficiary is the zero address");
194         require(msg.value >= _minimum, "Wei amount is less than 0.5 ether");
195 
196         uint256 weiAmount = msg.value;
197 
198         uint256 tokens = getTokenAmount(weiAmount);
199 
200         _weiRaised = _weiRaised.add(weiAmount);
201 
202         _wallet.transfer(weiAmount);
203 
204         _token.transfer(beneficiary, tokens);
205 
206         emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokens);
207     }
208 
209     /**
210      * @dev Calculate amount of tokens to recieve for a given amount of wei
211      * @param weiAmount Value in wei to be converted into tokens
212      * @return Number of tokens that can be purchased with the specified _weiAmount
213      */
214     function getTokenAmount(uint256 weiAmount) public view returns(uint256) {
215         return weiAmount.mul(_currentETHPrice).div(1 ether).mul(_rate);
216     }
217 
218     /**
219      * @dev Function to change the rate.
220      * Available only to the owner.
221      * @param newRate new value.
222      */
223     function setRate(uint256 newRate) external onlyOwner {
224         require(newRate != 0, "New rate is 0");
225 
226         _rate = newRate;
227     }
228 
229     /**
230      * @dev Function to change the PriceProvider address.
231      * Available only to the owner.
232      * @param provider new address.
233      */
234     function setEthPriceProvider(address provider) external onlyOwner {
235         require(provider != address(0), "Provider is the zero address");
236 
237         ethPriceProvider = provider;
238     }
239 
240     /**
241      * @dev Function to change the address to receive ether.
242      * Available only to the owner.
243      * @param newWallet new address.
244      */
245     function setWallet(address payable newWallet) external onlyOwner {
246         require(newWallet != address(0), "New wallet is the zero address");
247 
248         _wallet = newWallet;
249     }
250 
251     /**
252      * @dev Function to change the ETH Price.
253      * Available only to the owner and to the PriceProvider.
254      * @param newPrice amount of USD Cents for 1 ether.
255      */
256     function receiveEthPrice(uint256 newPrice) external {
257         require(newPrice != 0, "New price is 0");
258         require(msg.sender == ethPriceProvider || msg.sender == _owner, "Sender has no permission");
259 
260         emit NewETHPrice(_currentETHPrice, newPrice);
261         _currentETHPrice = newPrice;
262     }
263 
264     /**
265     * @dev Allows to any owner of the contract withdraw needed ERC20 token from this contract (promo or bounties for example).
266     * @param ERC20Token Address of ERC20 token.
267     * @param recipient Account to receive tokens.
268     */
269     function withdrawERC20(address ERC20Token, address recipient) external onlyOwner {
270 
271         uint256 amount = IERC20(ERC20Token).balanceOf(address(this));
272         IERC20(ERC20Token).transfer(recipient, amount);
273 
274     }
275 
276     /**
277      * @return the token being sold.
278      */
279     function token() public view returns (IERC20) {
280         return _token;
281     }
282 
283     /**
284      * @return the address where funds are collected.
285      */
286     function wallet() public view returns (address payable) {
287         return _wallet;
288     }
289 
290     /**
291      * @return the number of token units a buyer gets per wei.
292      */
293     function rate() public view returns (uint256) {
294         return _rate;
295     }
296 
297     /**
298      * @return the price of 1 ether in USD Cents.
299      */
300     function currentETHPrice() public view returns (uint256) {
301         return _currentETHPrice;
302     }
303 
304     /**
305      * @return minimum amount of wei to invest.
306      */
307     function minimum() public view returns (uint256) {
308         return _minimum;
309     }
310 
311     /**
312      * @return the amount of wei raised.
313      */
314     function weiRaised() public view returns (uint256) {
315         return _weiRaised;
316     }
317 
318 }