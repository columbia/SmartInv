1 /**
2  *Submitted for verification at Etherscan.io on 2023-04-26
3 */
4 
5 // Sources flattened with hardhat v2.8.0 https://hardhat.org
6 
7 // File @openzeppelin/contracts/utils/Context.sol@v4.4.1
8 
9 // SPDX-License-Identifier: MIT
10 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
11 
12 pragma solidity ^0.8.0;
13 
14 /**
15  * @dev Provides information about the current execution context, including the
16  * sender of the transaction and its data. While these are generally available
17  * via msg.sender and msg.data, they should not be accessed in such a direct
18  * manner, since when dealing with meta-transactions the account sending and
19  * paying for execution may not be the actual sender (as far as an application
20  * is concerned).
21  *
22  * This contract is only required for intermediate, library-like contracts.
23  */
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address) {
26         return msg.sender;
27     }
28 
29     function _msgData() internal view virtual returns (bytes calldata) {
30         return msg.data;
31     }
32 }
33 
34 
35 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.1
36 
37 
38 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
39 
40 pragma solidity ^0.8.0;
41 
42 /**
43  * @dev Contract module which provides a basic access control mechanism, where
44  * there is an account (an owner) that can be granted exclusive access to
45  * specific functions.
46  *
47  * By default, the owner account will be the one that deploys the contract. This
48  * can later be changed with {transferOwnership}.
49  *
50  * This module is used through inheritance. It will make available the modifier
51  * `onlyOwner`, which can be applied to your functions to restrict their use to
52  * the owner.
53  */
54 abstract contract Ownable is Context {
55     address private _owner;
56 
57     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 
59     /**
60      * @dev Initializes the contract setting the deployer as the initial owner.
61      */
62     constructor() {
63         _transferOwnership(_msgSender());
64     }
65 
66     /**
67      * @dev Returns the address of the current owner.
68      */
69     function owner() public view virtual returns (address) {
70         return _owner;
71     }
72 
73     /**
74      * @dev Throws if called by any account other than the owner.
75      */
76     modifier onlyOwner() {
77         require(owner() == _msgSender(), "Ownable: caller is not the owner");
78         _;
79     }
80 
81     /**
82      * @dev Leaves the contract without owner. It will not be possible to call
83      * `onlyOwner` functions anymore. Can only be called by the current owner.
84      *
85      * NOTE: Renouncing ownership will leave the contract without an owner,
86      * thereby removing any functionality that is only available to the owner.
87      */
88     function renounceOwnership() public virtual onlyOwner {
89         _transferOwnership(address(0));
90     }
91 
92     /**
93      * @dev Transfers ownership of the contract to a new account (`newOwner`).
94      * Can only be called by the current owner.
95      */
96     function transferOwnership(address newOwner) public virtual onlyOwner {
97         require(newOwner != address(0), "Ownable: new owner is the zero address");
98         _transferOwnership(newOwner);
99     }
100 
101     /**
102      * @dev Transfers ownership of the contract to a new account (`newOwner`).
103      * Internal function without access restriction.
104      */
105     function _transferOwnership(address newOwner) internal virtual {
106         address oldOwner = _owner;
107         _owner = newOwner;
108         emit OwnershipTransferred(oldOwner, newOwner);
109     }
110 }
111 
112 
113 // File @chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol@v0.6.1
114 
115 
116 pragma solidity ^0.8.0;
117 
118 interface AggregatorV3Interface {
119   function decimals() external view returns (uint8);
120 
121   function description() external view returns (string memory);
122 
123   function version() external view returns (uint256);
124 
125   function getRoundData(uint80 _roundId)
126     external
127     view
128     returns (
129       uint80 roundId,
130       int256 answer,
131       uint256 startedAt,
132       uint256 updatedAt,
133       uint80 answeredInRound
134     );
135 
136   function latestRoundData()
137     external
138     view
139     returns (
140       uint80 roundId,
141       int256 answer,
142       uint256 startedAt,
143       uint256 updatedAt,
144       uint80 answeredInRound
145     );
146 }
147 
148 
149 // File contracts/ETHPublicSale.sol
150 
151 
152 pragma solidity ^0.8.9;
153 
154 
155 /// @title Public Sale
156 contract ETHPublicSale2 is Ownable {
157 
158     mapping(address => uint256) public participants;
159 
160     mapping(address => int256) public participantTokens; 
161 
162     int256 internal constant PRECISION = 1 ether;
163 
164     int256 internal constant DECIMALS = 10**8;
165 
166     int256 public  BUY_PRICE; //buy price in format 1 base token = amount of buy token, 1 ETH = 0.01 Token
167     uint256 public  SOFTCAP; //soft cap
168     uint256 public  HARDCAP; //hard cap
169     uint256 public  MIN_ETH_PER_WALLET; //min base token per wallet
170     uint256 public  MAX_ETH_PER_WALLET; //max base token per wallet
171     uint256 public  SALE_LENGTH; //sale length in seconds
172 
173     enum STATUS {
174         QUED,
175         ACTIVE,
176         SUCCESS,
177         FAILED
178     }
179 
180     uint256 public totalCollected; //total ETH collected
181     int256 public totalSold; //total sold tokens
182 
183     uint256 public startTime; //start time for presale
184     uint256 public endTime; //end time for presale
185 
186     bool forceFailed; //force failed, emergency
187     
188     AggregatorV3Interface internal priceFeed;
189 
190     event buyToken(address recipient, int256 tokensSold, uint256 value, int256 amountInUSD, int256 price);
191     event Refund(address recipient, uint256 ETHToRefund);
192     event ForceFailed();
193     event Withdraw(address recipient, uint256 amount);
194     event SaleTokenChanged(address saleToken);
195     constructor(
196         int256 _buyPrice,
197         uint256 _softCap,
198         uint256 _hardCap,
199         uint256 _minETHPerWallet,
200         uint256 _maxETHPerWallet,
201         uint256 _startTime,
202         uint256 _buyLengh,
203         address _priceFeed
204     ) {
205         BUY_PRICE = _buyPrice;
206         SOFTCAP = _softCap;
207         HARDCAP = _hardCap;
208         MIN_ETH_PER_WALLET = _minETHPerWallet;
209         MAX_ETH_PER_WALLET = _maxETHPerWallet;
210         SALE_LENGTH = _buyLengh; //2 days, 48 hours
211 
212         startTime = _startTime;
213         endTime = _startTime + SALE_LENGTH;
214 
215         priceFeed = AggregatorV3Interface(
216             _priceFeed
217         );
218     }
219 
220     receive() external payable {
221         buy();
222     }
223     
224     /// @notice buy
225     /// @dev before this, need approve
226     function buy() public payable {
227         uint256 _amount = msg.value;
228 
229         require(status() == STATUS.ACTIVE, "PublicSale: sale is not started yet or ended");
230         require(_amount >= MIN_ETH_PER_WALLET, "PublicSale: insufficient purchase amount");
231         require(_amount <= MAX_ETH_PER_WALLET, "PublicSale: reached purchase amount");
232         require(participants[_msgSender()] < MAX_ETH_PER_WALLET, "PublicSale: the maximum amount of purchases has been reached");
233 
234         uint256 newTotalCollected = totalCollected + _amount;
235 
236         if (HARDCAP < newTotalCollected) {
237             // Refund anything above the hard cap
238             uint256 diff = newTotalCollected - HARDCAP;
239             _amount = _amount - diff;
240         }
241 
242         if (_amount >= MAX_ETH_PER_WALLET - participants[_msgSender()]) {
243             _amount = MAX_ETH_PER_WALLET - participants[_msgSender()];
244         }
245 
246         // Save participants eth
247         participants[_msgSender()] = participants[_msgSender()] + _amount;
248         
249         // 2* 10^18 * 182221 * 10^6 / 10^8 = 364442 * 10^16
250         int256 price = getLatestPrice();
251 
252         int256 amountInUSD = int256(_amount) * price / DECIMALS;
253         int256 tokensSold = amountInUSD * PRECISION / BUY_PRICE;
254 
255         // Save participant tokens
256         participantTokens[_msgSender()] = participantTokens[_msgSender()] + tokensSold;
257 
258         // Update total ETH
259         totalCollected = totalCollected + _amount;
260 
261         // Update tokens sold
262         totalSold = totalSold + tokensSold;
263 
264 
265         if (_amount < msg.value) {
266             //refund
267             _deliverFunds(_msgSender(), msg.value - _amount, "Cant send ETH");
268         }
269 
270         emit buyToken(_msgSender(), tokensSold, _amount, amountInUSD, price);
271     }
272 
273     function getLatestPrice() public view returns (int) {
274         // prettier-ignore
275         (
276             /* uint80 roundID */,
277             int price,
278             /*uint startedAt*/,
279             /*uint timeStamp*/,
280             /*uint80 answeredInRound*/
281         ) = priceFeed.latestRoundData();
282         return price;
283     }
284 
285     /// @notice refund base tokens
286     /// @dev only if sale status is failed
287     function refund() external {
288         require(status() == STATUS.FAILED, "PublicSale: sale is failed");
289 
290         require(participants[_msgSender()] > 0, "PublicSale: no tokens for refund");
291 
292         uint256 ETHToRefund = participants[_msgSender()];
293 
294         participants[_msgSender()] = 0;
295 
296         _withdraw(_msgSender(), ETHToRefund);
297 
298         emit Refund(_msgSender(), ETHToRefund);
299     }
300 
301 
302     ///@notice withdraw all ETH
303     ///@param _recipient address
304     ///@dev from owner
305     function withdraw(address _recipient) external virtual onlyOwner {
306         require(status() == STATUS.SUCCESS, "PublicSale: failed or active");
307         _withdraw(_recipient, address(this).balance);
308     }
309 
310     /// @notice force fail contract
311     /// @dev in other world, emergency exit
312     function forceFail() external onlyOwner {
313         forceFailed = true;
314         emit ForceFailed();
315     }
316 
317     /// sale status
318     function status() public view returns (STATUS) {
319         if (forceFailed) {
320             return STATUS.FAILED;
321         }
322         if ((block.timestamp > endTime) && (totalCollected < SOFTCAP)) {
323             return STATUS.FAILED; // FAILED - SOFTCAP not met by end time
324         }
325 
326         if (totalCollected >= HARDCAP) {
327             return STATUS.SUCCESS; // SUCCESS - HARDCAP met
328         }
329 
330         if ((block.timestamp > endTime) && (totalCollected >= SOFTCAP)) {
331             return STATUS.SUCCESS; // SUCCESS - endblock and soft cap reached
332         }
333         if ((block.timestamp >= startTime) && (block.timestamp <= endTime)) {
334             return STATUS.ACTIVE; // ACTIVE - deposits enabled
335         }
336 
337         return STATUS.QUED; // QUED - awaiting start time
338     }
339 
340 
341     ///@notice get token amount
342     ///@param _account account
343     function getTokenAmount(address _account) public view returns (int256 tokenAmount) {
344         tokenAmount = participantTokens[_account];
345     }
346 
347     function _withdraw(address _recipient, uint256 _amount) internal virtual {
348         require(_recipient != address(0x0), "PublicSale: address is zero");
349         require(_amount <= address(this).balance, "PublicSale: not enought ETH balance");
350 
351         _deliverFunds(_recipient, _amount, "PublicSale: Cant send ETH");
352     }
353 
354     function _deliverFunds(
355         address _recipient,
356         uint256 _value,
357         string memory _message
358     ) internal {
359         if (_value > address(this).balance) {
360             _value = address(this).balance;
361         }
362 
363         (bool sent, ) = payable(_recipient).call{value: _value}("");
364 
365         require(sent, _message);
366 
367         emit Withdraw(_recipient, _value);
368     }
369 
370 }