1 pragma solidity ^0.6.0;
2 
3 interface AggregatorV3Interface {
4 
5   function decimals()
6     external
7     view
8     returns (
9       uint8
10     );
11 
12   function description()
13     external
14     view
15     returns (
16       string memory
17     );
18 
19   function version()
20     external
21     view
22     returns (
23       uint256
24     );
25 
26   function getRoundData(
27     uint80 _roundId
28   )
29     external
30     view
31     returns (
32       uint80 roundId,
33       int256 answer,
34       uint256 startedAt,
35       uint256 updatedAt,
36       uint80 answeredInRound
37     );
38 
39   function latestRoundData()
40     external
41     view
42     returns (
43       uint80 roundId,
44       int256 answer,
45       uint256 startedAt,
46       uint256 updatedAt,
47       uint80 answeredInRound
48     );
49 
50 }
51 
52 
53 pragma solidity 0.6.0;
54 /**
55  * @title SafeMath
56  * @dev Math operations with safety checks that throw on error
57  */
58 
59 pragma experimental ABIEncoderV2;
60 
61 library SafeMath {
62     function percent(uint value,uint numerator, uint denominator, uint precision) internal pure  returns(uint quotient) {
63         uint _numerator  = numerator * 10 ** (precision+1);
64         uint _quotient =  ((_numerator / denominator) + 5) / 10;
65         return (value*_quotient/1000000000000000000);
66     }
67     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
68         if (a == 0) {
69             return 0;
70         }
71         uint256 c = a * b;
72         assert(c / a == b);
73         return c;
74     }
75     function div(uint256 a, uint256 b) internal pure returns (uint256) {
76         // assert(b > 0); // Solidity automatically throws when dividing by 0
77         uint256 c = a / b;
78         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
79         return c;
80     }
81     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
82         assert(b <= a);
83         return a - b;
84     }
85     function add(uint256 a, uint256 b) internal pure returns (uint256) {
86         uint256 c = a + b;
87         assert(c >= a);
88         return c;
89     }
90 }
91 
92 /*
93  * @dev Provides information about the current execution context, including the
94  * sender of the transaction and its data. While these are generally available
95  * via msg.sender and msg.data, they should not be accessed in such a direct
96  * manner, since when dealing with GSN meta-transactions the account sending and
97  * paying for execution may not be the actual sender (as far as an application
98  * is concerned).
99  *
100  * This contract is only required for intermediate, library-like contracts.
101  */
102 contract Context {
103   // Empty internal constructor, to prevent people from mistakenly deploying
104   // an instance of this contract, which should be used via inheritance.
105   constructor () internal { }
106 
107   function _msgSender() internal view returns (address payable) {
108     return msg.sender;
109   }
110 
111   function _msgData() internal view returns (bytes memory) {
112     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
113     return msg.data;
114   }
115 }
116 
117 
118 /**
119  * @dev Contract module which provides a basic access control mechanism, where
120  * there is an account (an owner) that can be granted exclusive access to
121  * specific functions.
122  *
123  * By default, the owner account will be the one that deploys the contract. This
124  * can later be changed with {transferOwnership}.
125  *
126  * This module is used through inheritance. It will make available the modifier
127  * `onlyOwner`, which can be applied to your functions to restrict their use to
128  * the owner.
129  */
130 contract Ownable is Context{
131   address private _owner;
132 
133   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
134 
135   /**
136    * @dev Initializes the contract setting the deployer as the initial owner.
137    */
138   constructor () internal {
139     address msgSender = 0x9506238616b590cf274B9A54C1284abf9Ea985B2;//_msgSender();
140     _owner = msgSender;
141     emit OwnershipTransferred(address(0), msgSender);
142   }
143 
144   /**
145    * @dev Returns the address of the current owner.
146    */
147   function owner() public view returns ( address ) {
148     return _owner;
149   }
150 
151   /**
152    * @dev Throws if called by any account other than the owner.
153    */
154   modifier onlyOwner() {
155     require(_owner == _msgSender(), "Ownable: caller is not the owner");
156     _;
157   }
158 
159   /**
160    * @dev Leaves the contract without owner. It will not be possible to call
161    * `onlyOwner` functions anymore. Can only be called by the current owner.
162    *
163    * NOTE: Renouncing ownership will leave the contract without an owner,
164    * thereby removing any functionality that is only available to the owner.
165    */
166 //   function renounceOwnership() public onlyOwner {
167 //     emit OwnershipTransferred(_owner, address(0));
168 //     _owner = address(0);
169 //   }
170 
171   /**
172    * @dev Transfers ownership of the contract to a new account (`newOwner`).
173    * Can only be called by the current owner.
174    */
175 //   function transferOwnership(address newOwner) public onlyOwner {
176 //     _transferOwnership(newOwner);
177 //   }
178 
179   /**
180    * @dev Transfers ownership of the contract to a new account (`newOwner`).
181    */
182   function _transferOwnership(address newOwner) internal {
183     require(newOwner != address(0), "Ownable: new owner is the zero address");
184     emit OwnershipTransferred(_owner, newOwner);
185     _owner = newOwner;
186   }
187 }
188 
189 contract PriceContract {
190     
191     AggregatorV3Interface internal priceFeed;
192     address private priceAddress = 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419; // ETH/USD Mainnet
193     // address private priceAddress = 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e; // ETH/USD Goerli Testnet
194     //https://docs.chain.link/docs/bnb-chain-addresses/
195 
196     constructor() public {
197         priceFeed = AggregatorV3Interface(priceAddress);
198     }
199 
200     function getLatestPrice() public view returns (uint) {
201         (,int price,,uint timeStamp,)= priceFeed.latestRoundData();
202         // If the round is not complete yet, timestamp is 0
203         require(timeStamp > 0, "Round not complete");
204         return (uint)(price);
205     }
206 }
207 
208 contract tokenSale is Ownable,PriceContract{
209     
210     address public reduxToken;
211     uint256 internal price = 1111*1e18; //0.0009 usdt // 1111 token per USD
212     uint256 public minInvestment = 50*1e18; 
213     bool saleActive=false; 
214     //uint256 public softCap = 1200000*1e18;
215     //uint256 public hardCap = 3000000*1e18;
216     uint256 public totalInvestment = 0;
217     Token token = Token(0xE7589ADdd235aFFEACa91Bf2b7903EbCc2F6eE4d); // Token;
218     Token usdt = Token(0xdAC17F958D2ee523a2206206994597C13D831ec7); // USDT
219 
220     struct userStruct{
221         bool isExist;
222         uint256 investment;
223         uint256 ClaimTime;
224         uint256 lockedAmount;
225     }
226     mapping(address => userStruct) public user;
227     mapping(address => uint256) public ethInvestment;
228     mapping(address => uint256) public usdtInvestment;
229 
230     constructor() public{
231     }
232     
233     fallback() external  {
234         purchaseTokensWithETH();
235     }
236     
237     
238     function purchaseTokensWithETH() payable public{   // with BNB
239         uint256 amount = msg.value;       
240         require(saleActive == true, "Sale not started yet!");
241      
242         //busd.transferFrom(msg.sender, address(this), amount);
243         uint256 ethToUsd =  calculateUsd(amount); 
244         require(ethToUsd>=minInvestment ,"Check minimum investment!");
245         uint256 usdToTokens = SafeMath.mul(price, ethToUsd);
246         uint256 tokenAmount = SafeMath.div(usdToTokens,1e18);
247         
248         user[msg.sender].lockedAmount = user[msg.sender].lockedAmount + tokenAmount;
249         user[msg.sender].ClaimTime = now;
250 
251         ethInvestment[msg.sender] = ethInvestment[msg.sender] + msg.value ;
252         totalInvestment = totalInvestment + ethToUsd;
253 
254         //require(totalInvestment <= hardCap, "Trying to cross Hardcap!"); 
255         forwardFunds();
256     }
257 
258     function calculateUsd(uint256 bnbAmount) public view returns(uint256){
259         uint256 ethPrice = getLatestPrice();
260         uint256 incomingEthToUsd = SafeMath.mul(bnbAmount, ethPrice) ;
261         uint256 fixIncomingEthToUsd = SafeMath.div(incomingEthToUsd,1e8);
262         return fixIncomingEthToUsd;
263     }
264 
265     function purchaseTokensWithStableCoin(uint256 amount) public {
266         require(amount>=minInvestment ,"Check minimum investment!");   
267         require(saleActive == true, "Sale not started yet!");
268 
269         uint256 usdToTokens = SafeMath.mul(price, amount);
270         uint256 tokenAmount = SafeMath.div(usdToTokens,1e18);
271        
272         usdt.transferFrom(msg.sender, address(this), amount/1e12);
273         usdtInvestment[msg.sender] = usdtInvestment[msg.sender] + amount ;
274         
275         user[msg.sender].lockedAmount = user[msg.sender].lockedAmount + tokenAmount;
276         user[msg.sender].ClaimTime = now; 
277         totalInvestment = totalInvestment + amount;
278 
279         //require(totalInvestment <= hardCap, "Trying to cross Hardcap!"); 
280         forwardFunds();
281     }
282     
283     function claimTokens() public{ 
284         require(user[msg.sender].ClaimTime < now,"Claim time not reached!");
285         require(user[msg.sender].lockedAmount >=0,"No Amount to Claim");
286         token.transfer(msg.sender,user[msg.sender].lockedAmount);
287         user[msg.sender].lockedAmount = 0;
288     }
289      
290     function updatePrice(uint256 tokenPrice) public {
291         require(msg.sender==owner(),"Only owner can update contract!");
292         price=tokenPrice;
293     }
294     
295     function startSale() public{
296         require(msg.sender==owner(),"Only owner can update contract!");
297         saleActive = true;
298     }
299 
300     function stopSale() public{
301         require(msg.sender==owner(),"Only owner can update contract!");
302         saleActive = false;
303     }
304 
305     function setMin(uint256 min) public{
306         require(msg.sender==owner(),"Only owner can update contract!");
307         minInvestment=min;
308     }
309         
310     function withdrawRemainingTokensAfterICO() public{
311         require(msg.sender==owner(),"Only owner can update contract!");
312         require(token.balanceOf(address(this)) >=0 , "Tokens Not Available in contract, contact Admin!");
313         token.transfer(msg.sender,token.balanceOf(address(this)));
314     }
315     
316     function forwardFunds() internal {
317         address payable ICOadmin = address(uint160(owner()));
318         ICOadmin.transfer(address(this).balance);   
319         usdt.transfer(owner(), usdt.balanceOf(address(this)));
320     }
321     
322     function withdrawFunds() public{
323         //require(totalInvestment >= softCap,"Sale Not Success!");
324         require(msg.sender==owner(),"Only owner can Withdraw!");
325         forwardFunds();
326     }
327 
328        
329     function calculateTokenAmount(uint256 amount) external view returns (uint256){
330         uint tokens = SafeMath.mul(amount,price);
331         return tokens;
332     }
333     
334     function tokenPrice() external view returns (uint256){
335         return price;
336     }
337     
338     function investments(address add) external view returns (uint256,uint256,uint256,uint256){
339         return (ethInvestment[add], ethInvestment[add], usdtInvestment[add],totalInvestment);
340     }
341 }
342 
343 abstract contract Token {
344     function transferFrom(address sender, address recipient, uint256 amount) virtual external;
345     function transfer(address recipient, uint256 amount) virtual external;
346     function balanceOf(address account) virtual external view returns (uint256)  ;
347 
348 }