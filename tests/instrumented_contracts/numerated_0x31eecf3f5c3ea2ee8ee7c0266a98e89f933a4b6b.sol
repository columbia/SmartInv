1 // Sources flattened with hardhat v2.8.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v4.4.1
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 
31 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.1
32 
33 
34 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev Contract module which provides a basic access control mechanism, where
40  * there is an account (an owner) that can be granted exclusive access to
41  * specific functions.
42  *
43  * By default, the owner account will be the one that deploys the contract. This
44  * can later be changed with {transferOwnership}.
45  *
46  * This module is used through inheritance. It will make available the modifier
47  * `onlyOwner`, which can be applied to your functions to restrict their use to
48  * the owner.
49  */
50 abstract contract Ownable is Context {
51     address private _owner;
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor() {
59         _transferOwnership(_msgSender());
60     }
61 
62     /**
63      * @dev Returns the address of the current owner.
64      */
65     function owner() public view virtual returns (address) {
66         return _owner;
67     }
68 
69     /**
70      * @dev Throws if called by any account other than the owner.
71      */
72     modifier onlyOwner() {
73         require(owner() == _msgSender(), "Ownable: caller is not the owner");
74         _;
75     }
76 
77     /**
78      * @dev Leaves the contract without owner. It will not be possible to call
79      * `onlyOwner` functions anymore. Can only be called by the current owner.
80      *
81      * NOTE: Renouncing ownership will leave the contract without an owner,
82      * thereby removing any functionality that is only available to the owner.
83      */
84     function renounceOwnership() public virtual onlyOwner {
85         _transferOwnership(address(0));
86     }
87 
88     /**
89      * @dev Transfers ownership of the contract to a new account (`newOwner`).
90      * Can only be called by the current owner.
91      */
92     function transferOwnership(address newOwner) public virtual onlyOwner {
93         require(newOwner != address(0), "Ownable: new owner is the zero address");
94         _transferOwnership(newOwner);
95     }
96 
97     /**
98      * @dev Transfers ownership of the contract to a new account (`newOwner`).
99      * Internal function without access restriction.
100      */
101     function _transferOwnership(address newOwner) internal virtual {
102         address oldOwner = _owner;
103         _owner = newOwner;
104         emit OwnershipTransferred(oldOwner, newOwner);
105     }
106 }
107 
108 
109 // File @chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol@v0.6.1
110 
111 
112 pragma solidity ^0.8.0;
113 
114 interface AggregatorV3Interface {
115   function decimals() external view returns (uint8);
116 
117   function description() external view returns (string memory);
118 
119   function version() external view returns (uint256);
120 
121   function getRoundData(uint80 _roundId)
122     external
123     view
124     returns (
125       uint80 roundId,
126       int256 answer,
127       uint256 startedAt,
128       uint256 updatedAt,
129       uint80 answeredInRound
130     );
131 
132   function latestRoundData()
133     external
134     view
135     returns (
136       uint80 roundId,
137       int256 answer,
138       uint256 startedAt,
139       uint256 updatedAt,
140       uint80 answeredInRound
141     );
142 }
143 
144 
145 // File contracts/ETHSeedSale.sol
146 
147 
148 pragma solidity ^0.8.9;
149 
150 
151 /// @title Seed Sale
152 contract ETHSeedSale is Ownable {
153 
154     mapping(address => uint256) public participants;
155 
156     mapping(address => int256) public participantTokens; 
157 
158     int256 internal constant PRECISION = 1 ether;
159 
160     int256 internal constant DECIMALS = 10**8;
161 
162     int256 public  BUY_PRICE; //buy price in format 1 base token = amount of sell token, 1 ETH = 0.01 Token
163     uint256 public  SOFTCAP; //soft cap
164     uint256 public  HARDCAP; //hard cap
165     uint256 public  MIN_ETH_PER_WALLET; //min base token per wallet
166     uint256 public  MAX_ETH_PER_WALLET; //max base token per wallet
167     uint256 public  SALE_LENGTH; //sale length in seconds
168 
169     enum STATUS {
170         QUED,
171         ACTIVE,
172         SUCCESS,
173         FAILED
174     }
175 
176     uint256 public totalCollected; //total ETH collected
177     int256 public totalSold; //total sold tokens
178 
179     uint256 public startTime; //start time for presale
180     uint256 public endTime; //end time for presale
181 
182     bool forceFailed; //force failed, emergency
183     
184     AggregatorV3Interface internal priceFeed;
185 
186     event SellToken(address recipient, int256 tokensSold, uint256 value, int256 amountInUSD, int256 price);
187     event Refund(address recipient, uint256 ETHToRefund);
188     event ForceFailed();
189     event Withdraw(address recipient, uint256 amount);
190     event SaleTokenChanged(address saleToken);
191     constructor(
192         int256 _buyPrice,
193         uint256 _softCap,
194         uint256 _hardCap,
195         uint256 _minETHPerWallet,
196         uint256 _maxETHPerWallet,
197         uint256 _startTime,
198         uint256 _sellLengh,
199         address _priceFeed
200     ) {
201         BUY_PRICE = _buyPrice;
202         SOFTCAP = _softCap;
203         HARDCAP = _hardCap;
204         MIN_ETH_PER_WALLET = _minETHPerWallet;
205         MAX_ETH_PER_WALLET = _maxETHPerWallet;
206         SALE_LENGTH = _sellLengh; //2 days, 48 hours
207 
208         startTime = _startTime;
209         endTime = _startTime + SALE_LENGTH;
210 
211         priceFeed = AggregatorV3Interface(
212             _priceFeed
213         );
214     }
215 
216     receive() external payable {
217         sell();
218     }
219     
220     /// @notice sell
221     /// @dev before this, need approve
222     function sell() public payable {
223         uint256 _amount = msg.value;
224 
225         require(status() == STATUS.ACTIVE, "SeedSale: sale is not started yet or ended");
226         require(_amount >= MIN_ETH_PER_WALLET, "SeedSale: insufficient purchase amount");
227         require(_amount <= MAX_ETH_PER_WALLET, "SeedSale: reached purchase amount");
228         require(participants[_msgSender()] < MAX_ETH_PER_WALLET, "SeedSale: the maximum amount of purchases has been reached");
229 
230         uint256 newTotalCollected = totalCollected + _amount;
231 
232         if (HARDCAP < newTotalCollected) {
233             // Refund anything above the hard cap
234             uint256 diff = newTotalCollected - HARDCAP;
235             _amount = _amount - diff;
236         }
237 
238         if (_amount >= MAX_ETH_PER_WALLET - participants[_msgSender()]) {
239             _amount = MAX_ETH_PER_WALLET - participants[_msgSender()];
240         }
241 
242         // Save participants eth
243         participants[_msgSender()] = participants[_msgSender()] + _amount;
244         
245         // 2* 10^18 * 182221 * 10^6 / 10^8 = 364442 * 10^16
246         int256 price = getLatestPrice();
247 
248         int256 amountInUSD = int256(_amount) * price / DECIMALS;
249         int256 tokensSold = amountInUSD * PRECISION / BUY_PRICE;
250 
251         // Save participant tokens
252         participantTokens[_msgSender()] = participantTokens[_msgSender()] + tokensSold;
253 
254         // Update total ETH
255         totalCollected = totalCollected + _amount;
256 
257         // Update tokens sold
258         totalSold = totalSold + tokensSold;
259 
260 
261         if (_amount < msg.value) {
262             //refund
263             _deliverFunds(_msgSender(), msg.value - _amount, "Cant send ETH");
264         }
265 
266         emit SellToken(_msgSender(), tokensSold, _amount, amountInUSD, price);
267     }
268 
269     function getLatestPrice() public view returns (int) {
270         // prettier-ignore
271         (
272             /* uint80 roundID */,
273             int price,
274             /*uint startedAt*/,
275             /*uint timeStamp*/,
276             /*uint80 answeredInRound*/
277         ) = priceFeed.latestRoundData();
278         return price;
279     }
280 
281     /// @notice refund base tokens
282     /// @dev only if sale status is failed
283     function refund() external {
284         require(status() == STATUS.FAILED, "SeedSale: sale is failed");
285 
286         require(participants[_msgSender()] > 0, "SeedSale: no tokens for refund");
287 
288         uint256 ETHToRefund = participants[_msgSender()];
289 
290         participants[_msgSender()] = 0;
291 
292         _withdraw(_msgSender(), ETHToRefund);
293 
294         emit Refund(_msgSender(), ETHToRefund);
295     }
296 
297 
298     ///@notice withdraw all ETH
299     ///@param _recipient address
300     ///@dev from owner
301     function withdraw(address _recipient) external virtual onlyOwner {
302         require(status() == STATUS.SUCCESS, "SeedSale: failed or active");
303         _withdraw(_recipient, address(this).balance);
304     }
305 
306     /// @notice force fail contract
307     /// @dev in other world, emergency exit
308     function forceFail() external onlyOwner {
309         forceFailed = true;
310         emit ForceFailed();
311     }
312 
313     /// sale status
314     function status() public view returns (STATUS) {
315         if (forceFailed) {
316             return STATUS.FAILED;
317         }
318         if ((block.timestamp > endTime) && (totalCollected < SOFTCAP)) {
319             return STATUS.FAILED; // FAILED - SOFTCAP not met by end time
320         }
321 
322         if (totalCollected >= HARDCAP) {
323             return STATUS.SUCCESS; // SUCCESS - HARDCAP met
324         }
325 
326         if ((block.timestamp > endTime) && (totalCollected >= SOFTCAP)) {
327             return STATUS.SUCCESS; // SUCCESS - endblock and soft cap reached
328         }
329         if ((block.timestamp >= startTime) && (block.timestamp <= endTime)) {
330             return STATUS.ACTIVE; // ACTIVE - deposits enabled
331         }
332 
333         return STATUS.QUED; // QUED - awaiting start time
334     }
335 
336 
337     ///@notice get token amount
338     ///@param _account account
339     function getTokenAmount(address _account) public view returns (int256 tokenAmount) {
340         tokenAmount = participantTokens[_account];
341     }
342 
343     function _withdraw(address _recipient, uint256 _amount) internal virtual {
344         require(_recipient != address(0x0), "SeedSale: address is zero");
345         require(_amount <= address(this).balance, "SeedSale: not enought ETH balance");
346 
347         _deliverFunds(_recipient, _amount, "SeedSale: Cant send ETH");
348     }
349 
350     function _deliverFunds(
351         address _recipient,
352         uint256 _value,
353         string memory _message
354     ) internal {
355         if (_value > address(this).balance) {
356             _value = address(this).balance;
357         }
358 
359         (bool sent, ) = payable(_recipient).call{value: _value}("");
360 
361         require(sent, _message);
362 
363         emit Withdraw(_recipient, _value);
364     }
365 
366 }