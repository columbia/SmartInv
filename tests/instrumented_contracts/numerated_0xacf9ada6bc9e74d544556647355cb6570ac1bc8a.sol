1 // File: @chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol
2 
3 
4 pragma solidity ^0.6.0;
5 
6 interface AggregatorV3Interface {
7 
8   function decimals()
9     external
10     view
11     returns (
12       uint8
13     );
14 
15   function description()
16     external
17     view
18     returns (
19       string memory
20     );
21 
22   function version()
23     external
24     view
25     returns (
26       uint256
27     );
28 
29   function getRoundData(
30     uint80 _roundId
31   )
32     external
33     view
34     returns (
35       uint80 roundId,
36       int256 answer,
37       uint256 startedAt,
38       uint256 updatedAt,
39       uint80 answeredInRound
40     );
41 
42   function latestRoundData()
43     external
44     view
45     returns (
46       uint80 roundId,
47       int256 answer,
48       uint256 startedAt,
49       uint256 updatedAt,
50       uint80 answeredInRound
51     );
52 
53 }
54 
55 // File: presaleContract.sol
56 
57 pragma solidity 0.6.0;
58 /**
59  * @title SafeMath
60  * @dev Math operations with safety checks that throw on error
61  */
62 
63 pragma experimental ABIEncoderV2;
64 
65 library SafeMath {
66     function percent(uint value,uint numerator, uint denominator, uint precision) internal pure  returns(uint quotient) {
67         uint _numerator  = numerator * 10 ** (precision+1);
68         uint _quotient =  ((_numerator / denominator) + 5) / 10;
69         return (value*_quotient/1000000000000000000);
70     }
71     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
72         if (a == 0) {
73             return 0;
74         }
75         uint256 c = a * b;
76         assert(c / a == b);
77         return c;
78     }
79     function div(uint256 a, uint256 b) internal pure returns (uint256) {
80         // assert(b > 0); // Solidity automatically throws when dividing by 0
81         uint256 c = a / b;
82         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
83         return c;
84     }
85     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
86         assert(b <= a);
87         return a - b;
88     }
89     function add(uint256 a, uint256 b) internal pure returns (uint256) {
90         uint256 c = a + b;
91         assert(c >= a);
92         return c;
93     }
94 }
95 
96 /*
97  * @dev Provides information about the current execution context, including the
98  * sender of the transaction and its data. While these are generally available
99  * via msg.sender and msg.data, they should not be accessed in such a direct
100  * manner, since when dealing with GSN meta-transactions the account sending and
101  * paying for execution may not be the actual sender (as far as an application
102  * is concerned).
103  *
104  * This contract is only required for intermediate, library-like contracts.
105  */
106 contract Context {
107   // Empty internal constructor, to prevent people from mistakenly deploying
108   // an instance of this contract, which should be used via inheritance.
109   constructor () internal { }
110 
111   function _msgSender() internal view returns (address payable) {
112     return msg.sender;
113   }
114 
115   function _msgData() internal view returns (bytes memory) {
116     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
117     return msg.data;
118   }
119 }
120 
121 
122 /**
123  * @dev Contract module which provides a basic access control mechanism, where
124  * there is an account (an owner) that can be granted exclusive access to
125  * specific functions.
126  *
127  * By default, the owner account will be the one that deploys the contract. This
128  * can later be changed with {transferOwnership}.
129  *
130  * This module is used through inheritance. It will make available the modifier
131  * `onlyOwner`, which can be applied to your functions to restrict their use to
132  * the owner.
133  */
134 contract Ownable is Context{
135   address private _owner;
136 
137   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
138 
139   /**
140    * @dev Initializes the contract setting the deployer as the initial owner.
141    */
142   constructor () internal {
143     address msgSender = 0x2C2ed7349332Eaf2d84851Dd5F50d81E5c488fA1;//_msgSender();
144     _owner = msgSender;
145     emit OwnershipTransferred(address(0), msgSender);
146   }
147 
148   /**
149    * @dev Returns the address of the current owner.
150    */
151   function owner() public view returns ( address ) {
152     return _owner;
153   }
154 
155   /**
156    * @dev Throws if called by any account other than the owner.
157    */
158   modifier onlyOwner() {
159     require(_owner == _msgSender(), "Ownable: caller is not the owner");
160     _;
161   }
162 
163   /**
164    * @dev Leaves the contract without owner. It will not be possible to call
165    * `onlyOwner` functions anymore. Can only be called by the current owner.
166    *
167    * NOTE: Renouncing ownership will leave the contract without an owner,
168    * thereby removing any functionality that is only available to the owner.
169    */
170 //   function renounceOwnership() public onlyOwner {
171 //     emit OwnershipTransferred(_owner, address(0));
172 //     _owner = address(0);
173 //   }
174 
175   /**
176    * @dev Transfers ownership of the contract to a new account (`newOwner`).
177    * Can only be called by the current owner.
178    */
179 //   function transferOwnership(address newOwner) public onlyOwner {
180 //     _transferOwnership(newOwner);
181 //   }
182 
183   /**
184    * @dev Transfers ownership of the contract to a new account (`newOwner`).
185    */
186   function _transferOwnership(address newOwner) internal {
187     require(newOwner != address(0), "Ownable: new owner is the zero address");
188     emit OwnershipTransferred(_owner, newOwner);
189     _owner = newOwner;
190   }
191 }
192 
193 contract PriceContract {
194     
195     AggregatorV3Interface internal priceFeed;
196     address private priceAddress = 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419; // ETH/USD Mainnet
197     //address private priceAddress = 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e; // ETH/USD Goerli Testnet
198     //https://docs.chain.link/docs/bnb-chain-addresses/
199 
200     constructor() public {
201         priceFeed = AggregatorV3Interface(priceAddress);
202     }
203 
204     function getLatestPrice() public view returns (uint) {
205         (,int price,,uint timeStamp,)= priceFeed.latestRoundData();
206         // If the round is not complete yet, timestamp is 0
207         require(timeStamp > 0, "Round not complete");
208         return (uint)(price);
209     }
210 }
211 
212 contract tokenSale is Ownable,PriceContract{
213     
214     address public reduxToken;
215     uint256 internal price = 200*1e18; //0.005 usdt // 200 token per USD
216     uint256 public minInvestment = 15*1e18; 
217     bool saleActive=false; 
218     //uint256 public softCap = 1200000*1e18;
219     //uint256 public hardCap = 3000000*1e18;
220     uint256 public totalInvestment = 0;
221     Token token = Token(0x2d6e9d6b362354a5Ca7b03581Aa2aAc81bb530Db); // Token;
222     Token usdt = Token(0xdAC17F958D2ee523a2206206994597C13D831ec7); // USDT
223 
224     struct userStruct{
225         bool isExist;
226         uint256 investment;
227         uint256 ClaimTime;
228         uint256 lockedAmount;
229     }
230     mapping(address => userStruct) public user;
231     mapping(address => uint256) public ethInvestment;
232     mapping(address => uint256) public usdtInvestment;
233 
234     constructor() public{
235     }
236     
237     fallback() external  {
238         purchaseTokensWithETH();
239     }
240     
241     
242     function purchaseTokensWithETH() payable public{   // with BNB
243         uint256 amount = msg.value;       
244         require(saleActive == true, "Sale not started yet!");
245      
246         //busd.transferFrom(msg.sender, address(this), amount);
247         uint256 ethToUsd =  calculateUsd(amount); 
248         require(ethToUsd>=minInvestment ,"Check minimum investment!");
249         uint256 usdToTokens = SafeMath.mul(price, ethToUsd);
250         uint256 tokenAmount = SafeMath.div(usdToTokens,1e18);
251         
252         user[msg.sender].lockedAmount = user[msg.sender].lockedAmount + tokenAmount;
253         user[msg.sender].ClaimTime = now;
254 
255         ethInvestment[msg.sender] = ethInvestment[msg.sender] + msg.value ;
256         totalInvestment = totalInvestment + ethToUsd;
257 
258         //require(totalInvestment <= hardCap, "Trying to cross Hardcap!"); 
259         forwardFunds();
260     }
261 
262     function calculateUsd(uint256 bnbAmount) public view returns(uint256){
263         uint256 ethPrice = getLatestPrice();
264         uint256 incomingEthToUsd = SafeMath.mul(bnbAmount, ethPrice) ;
265         uint256 fixIncomingEthToUsd = SafeMath.div(incomingEthToUsd,1e8);
266         return fixIncomingEthToUsd;
267     }
268 
269     function purchaseTokensWithStableCoin(uint256 amount) public {
270         require(amount>=minInvestment ,"Check minimum investment!");   
271         require(saleActive == true, "Sale not started yet!");
272 
273         uint256 usdToTokens = SafeMath.mul(price, amount);
274         uint256 tokenAmount = SafeMath.div(usdToTokens,1e18);
275        
276         usdt.transferFrom(msg.sender, address(this), amount/1e12);
277         usdtInvestment[msg.sender] = usdtInvestment[msg.sender] + amount ;
278         
279         user[msg.sender].lockedAmount = user[msg.sender].lockedAmount + tokenAmount;
280         user[msg.sender].ClaimTime = now; 
281         totalInvestment = totalInvestment + amount;
282 
283         //require(totalInvestment <= hardCap, "Trying to cross Hardcap!"); 
284         forwardFunds();
285     }
286     
287     function claimTokens() public{ 
288         require(saleActive == false,"Sale should be close before claim!");
289         require(user[msg.sender].ClaimTime < now,"Claim time not reached!");
290         require(user[msg.sender].lockedAmount >=0,"No Amount to Claim");
291         token.transfer(msg.sender,user[msg.sender].lockedAmount);
292         user[msg.sender].lockedAmount = 0;
293     }
294      
295     function updatePrice(uint256 tokenPrice) public {
296         require(msg.sender==owner(),"Only owner can update contract!");
297         price=tokenPrice;
298     }
299     
300     function startSale() public{
301         require(msg.sender==owner(),"Only owner can update contract!");
302         saleActive = true;
303     }
304 
305     function stopSale() public{
306         require(msg.sender==owner(),"Only owner can update contract!");
307         saleActive = false;
308     }
309 
310     function setMin(uint256 min) public{
311         require(msg.sender==owner(),"Only owner can update contract!");
312         minInvestment=min;
313     }
314         
315     function withdrawRemainingTokensAfterICO() public{
316         require(msg.sender==owner(),"Only owner can update contract!");
317         require(token.balanceOf(address(this)) >=0 , "Tokens Not Available in contract, contact Admin!");
318         token.transfer(msg.sender,token.balanceOf(address(this)));
319     }
320     
321     function forwardFunds() internal {
322         address payable ICOadmin = address(uint160(owner()));
323         ICOadmin.transfer(address(this).balance);   
324         usdt.transfer(owner(), usdt.balanceOf(address(this)));
325     }
326     
327     function withdrawFunds() public{
328         //require(totalInvestment >= softCap,"Sale Not Success!");
329         require(msg.sender==owner(),"Only owner can Withdraw!");
330         forwardFunds();
331     }
332 
333        
334     function calculateTokenAmount(uint256 amount) external view returns (uint256){
335         uint tokens = SafeMath.mul(amount,price);
336         return tokens;
337     }
338     
339     function tokenPrice() external view returns (uint256){
340         return price;
341     }
342     
343     function investments(address add) external view returns (uint256,uint256,uint256,uint256){
344         return (ethInvestment[add], ethInvestment[add], usdtInvestment[add],totalInvestment);
345     }
346 }
347 
348 abstract contract Token {
349     function transferFrom(address sender, address recipient, uint256 amount) virtual external;
350     function transfer(address recipient, uint256 amount) virtual external;
351     function balanceOf(address account) virtual external view returns (uint256)  ;
352 
353 }