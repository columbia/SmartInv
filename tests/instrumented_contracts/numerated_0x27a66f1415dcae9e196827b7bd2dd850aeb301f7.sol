1 // v7
2 
3 /**
4  * Presale.sol
5  */
6 
7 pragma solidity ^0.4.23;
8 
9 /**
10  * @title SafeMath
11  * @dev Math operations with safety checks that throw on error
12  */
13 library SafeMath {
14 
15   /**
16    * @dev Multiplies two numbers, throws on overflow.
17    * @param a First number
18    * @param b Second number
19    */
20   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21     if (a == 0) {
22       return 0;
23     }
24     uint256 c = a * b;
25     assert(c / a == b);
26     return c;
27   }
28 
29   /**
30    * @dev Integer division of two numbers, truncating the quotient.
31    * @param a First number
32    * @param b Second number
33    */
34   function div(uint256 a, uint256 b) internal pure returns (uint256) {
35     // assert(b > 0); // Solidity automatically throws when dividing by 0
36     uint256 c = a / b;
37     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38     return c;
39   }
40 
41   /**
42    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
43    * @param a First number
44    * @param b Second number
45    */
46   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47     assert(b <= a);
48     return a - b;
49   }
50 
51   /**
52    * @dev Adds two numbers, throws on overflow.
53    * @param a First number
54    * @param b Second number
55    */
56   function add(uint256 a, uint256 b) internal pure returns (uint256) {
57     uint256 c = a + b;
58     assert(c >= a);
59     return c;
60   }
61 }
62 
63 /**
64  * @title Ownable
65  * @dev The Ownable contract has an owner address, and provides basic authorization control
66  * functions, this simplifies the implementation of "user permissions".
67  */
68 contract Ownable {
69   address public owner;
70 
71   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
72 
73   /**
74    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
75    * account.
76    */
77   constructor() public {
78     owner = msg.sender;
79   }
80 
81   /**
82    * @dev Throws if called by any account other than the owner.
83    */
84   modifier onlyOwner() {
85     require(msg.sender == owner);
86     _;
87   }
88 
89   /**
90    * @dev Allows the current owner to transfer control of the contract to a newOwner.
91    * @param newOwner The address to transfer ownership to.
92    */
93   function transferOwnership(address newOwner) public onlyOwner {
94     require(newOwner != address(0));
95     emit OwnershipTransferred(owner, newOwner);
96     owner = newOwner;
97   }
98 }
99 
100 // interface to the crowdsale contract
101 interface CrowdSale {
102   function crowdSaleCheck() external view returns (bool);
103 }
104 
105 /**
106  * @title InvestorsStorage
107  * @dev InvestorStorage contract interface with newInvestment and getInvestedAmount functions which need to be implemented
108  */
109 interface InvestorsStorage {
110   function newInvestment(address _investor, uint256 _amount) external;
111   function getInvestedAmount(address _investor) external view returns (uint256);
112 }
113 
114 /**
115  * @title TokenContract
116  * @dev Token contract interface with transfer and balanceOf functions which need to be implemented
117  */
118 interface TokenContract {
119 
120   /**
121   * @dev Transfer funds to recipient address
122   * @param _recipient Recipients address
123   * @param _amount Amount to transfer
124   */
125   function transfer(address _recipient, uint256 _amount) external returns (bool);
126 
127   /**
128    * @dev Return balance of holders address
129    * @param _holder Holders address
130    */
131   function balanceOf(address _holder) external view returns (uint256);
132 }
133 
134 /**
135  * @title PreSale
136  * @dev PreSale Contract which executes and handles presale of the tokens
137  */
138 contract PreSale  is Ownable {
139   using SafeMath for uint256;
140 
141   // variables
142 
143   TokenContract public tkn;
144   CrowdSale public cSale;
145   InvestorsStorage public investorsStorage;
146   uint256 public levelEndDate;
147   uint256 public currentLevel;
148   uint256 public levelTokens = 375000;
149   uint256 public tokensSold;
150   uint256 public weiRised;
151   uint256 public ethPrice;
152   address[] public investorsList;
153   bool public presalePaused;
154   bool public presaleEnded;
155   uint256[12] private tokenPrice = [4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48];
156   uint256 private baseTokens = 375000;
157   uint256 private usdCentValue;
158   uint256 private minInvestment;
159 
160   /**
161    * @dev Constructor of Presale contract
162    */
163   constructor() public {
164     tkn = TokenContract(0xea674f79acf3c974085784f0b3e9549b39a5e10a);                    // address of the token contract
165     investorsStorage = InvestorsStorage(0x15c7c30B980ef442d3C811A30346bF9Dd8906137);      // address of the storage contract
166     minInvestment = 100 finney;
167     updatePrice(5000);
168   }
169 
170   /**
171    * @dev Fallback payable function which executes additional checks and functionality when tokens need to be sent to the investor
172    */
173   function() payable public {
174     require(msg.value >= minInvestment);   // check for minimum investment amount
175     require(!presalePaused);
176     require(!presaleEnded);
177     prepareSell(msg.sender, msg.value);
178   }
179 
180   /**
181    * @dev Prepare sell of the tokens
182    * @param _investor Investors address
183    * @param _amount Amount invested
184    */
185   function prepareSell(address _investor, uint256 _amount) private {
186     uint256 remaining;
187     uint256 pricePerCent;
188     uint256 pricePerToken;
189     uint256 toSell;
190     uint256 amount = _amount;
191     uint256 sellInWei;
192     address investor = _investor;
193 
194     pricePerCent = getUSDPrice();
195     pricePerToken = pricePerCent.mul(tokenPrice[currentLevel]); // calculate the price for each token in the current level
196     toSell = _amount.div(pricePerToken); // calculate the amount to sell
197 
198     if (toSell < levelTokens) { // if there is enough tokens left in the current level, sell from it
199       levelTokens = levelTokens.sub(toSell);
200       weiRised = weiRised.add(_amount);
201       executeSell(investor, toSell, _amount);
202       owner.transfer(_amount);
203     } else { // if not, sell from 2 or more different levels
204       while (amount > 0) {
205         if (toSell > levelTokens) {
206           toSell = levelTokens; // sell all the remaining in the level
207           sellInWei = toSell.mul(pricePerToken);
208           amount = amount.sub(sellInWei);
209           if (currentLevel < 11) { // if is the last level, sell only the tokens left,
210             currentLevel += 1;
211             levelTokens = baseTokens;
212           } else {
213             remaining = amount;
214             amount = 0;
215           }
216         } else {
217           sellInWei = amount;
218           amount = 0;
219         }
220         
221         executeSell(investor, toSell, sellInWei); 
222         weiRised = weiRised.add(sellInWei);
223         owner.transfer(amount);
224         if (amount > 0) {
225           toSell = amount.div(pricePerToken);
226         }
227         if (remaining > 0) { // if there is any mount left, it means that is the the last level an there is no more tokens to sell
228           investor.transfer(remaining);
229           owner.transfer(address(this).balance);
230           presaleEnded = true;
231         }
232       }
233     }
234   }
235 
236   /**
237    * @dev Execute sell of the tokens - send investor to investors storage and transfer tokens
238    * @param _investor Investors address
239    * @param _tokens Amount of tokens to be sent
240    * @param _weiAmount Amount invested in wei
241    */
242   function executeSell(address _investor, uint256 _tokens, uint256 _weiAmount) private {
243     uint256 totalTokens = _tokens * (10 ** 18);
244     tokensSold += _tokens; // update tokens sold
245     investorsStorage.newInvestment(_investor, _weiAmount); // register the invested amount in the storage
246 
247     require(tkn.transfer(_investor, totalTokens)); // transfer the tokens to the investor
248     emit NewInvestment(_investor, totalTokens);   
249   }
250 
251   /**
252    * @dev Getter for USD price of tokens
253    */
254   function getUSDPrice() private view returns (uint256) {
255     return usdCentValue;
256   }
257 
258   /**
259    * @dev Change USD price of tokens
260    * @param _ethPrice New Ether price
261    */
262   function updatePrice(uint256 _ethPrice) private {
263     uint256 centBase = 1 * 10 ** 16;
264     require(_ethPrice > 0);
265     ethPrice = _ethPrice;
266     usdCentValue = centBase.div(_ethPrice);
267   }
268 
269   /**
270    * @dev Set USD to ETH value
271    * @param _ethPrice New Ether price
272    */
273   function setUsdEthValue(uint256 _ethPrice) onlyOwner external { // set the ETH value in USD
274     updatePrice(_ethPrice);
275   }
276 
277   /**
278    * @dev Set the crowdsale contract address
279    * @param _crowdSale Crowdsale contract address
280    */
281   function setCrowdSaleAddress(address _crowdSale) onlyOwner public { // set the crowdsale contract address
282     cSale = CrowdSale(_crowdSale);
283   }
284 
285   /**
286    * @dev Set the storage contract address
287    * @param _investorsStorage Investors storage contract address
288    */
289   function setStorageAddress(address _investorsStorage) onlyOwner public { // set the storage contract address
290     investorsStorage = InvestorsStorage(_investorsStorage);
291   }
292 
293   /**
294    * @dev Pause the presale
295    * @param _paused Paused state - true/false
296    */
297   function pausePresale(bool _paused) onlyOwner public { // pause the presale
298     presalePaused = _paused;
299   }
300 
301   /**
302    * @dev Get funds
303    */
304   function getFunds() onlyOwner public { // request the funds
305     owner.transfer(address(this).balance);
306   }
307 
308   event NewInvestment(address _investor, uint256 tokens);
309 }