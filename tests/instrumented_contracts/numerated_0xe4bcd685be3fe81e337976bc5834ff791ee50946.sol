1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title Helps contracts guard agains reentrancy attacks.
5  * @author Remco Bloemen <remco@2π.com>
6  * @notice If you mark a function `nonReentrant`, you should also
7  * mark it `external`.
8  */
9 contract ReentrancyGuard {
10 
11   /**
12    * @dev We use a single lock for the whole contract.
13    */
14   bool private reentrancyLock = false;
15 
16   /**
17    * @dev Prevents a contract from calling itself, directly or indirectly.
18    * @notice If you mark a function `nonReentrant`, you should also
19    * mark it `external`. Calling one nonReentrant function from
20    * another is not supported. Instead, you can implement a
21    * `private` function doing the actual work, and a `external`
22    * wrapper marked as `nonReentrant`.
23    */
24   modifier nonReentrant() {
25     require(!reentrancyLock);
26     reentrancyLock = true;
27     _;
28     reentrancyLock = false;
29   }
30 
31 }
32 
33 /**
34  * @title SafeMath
35  * @dev Math operations with safety checks that throw on error
36  */
37 library SafeMath {
38 
39   /**
40   * @dev Multiplies two numbers, throws on overflow.
41   */
42   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
44     // benefit is lost if 'b' is also tested.
45     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
46     if (a == 0) {
47       return 0;
48     }
49 
50     c = a * b;
51     assert(c / a == b);
52     return c;
53   }
54 
55   /**
56   * @dev Integer division of two numbers, truncating the quotient.
57   */
58   function div(uint256 a, uint256 b) internal pure returns (uint256) {
59     // assert(b > 0); // Solidity automatically throws when dividing by 0
60     // uint256 c = a / b;
61     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
62     return a / b;
63   }
64 
65   /**
66   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
67   */
68   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69     assert(b <= a);
70     return a - b;
71   }
72 
73   /**
74   * @dev Adds two numbers, throws on overflow.
75   */
76   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
77     c = a + b;
78     assert(c >= a);
79     return c;
80   }
81 }
82 
83 /**
84  * @title Ownable
85  * @dev The Ownable contract has an owner address, and provides basic authorization control
86  * functions, this simplifies the implementation of "user permissions".
87  */
88 contract Ownable {
89   address public owner;
90 
91 
92   event OwnershipRenounced(address indexed previousOwner);
93   event OwnershipTransferred(
94     address indexed previousOwner,
95     address indexed newOwner
96   );
97 
98 
99   /**
100    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
101    * account.
102    */
103   constructor() public {
104     owner = msg.sender;
105   }
106 
107   /**
108    * @dev Throws if called by any account other than the owner.
109    */
110   modifier onlyOwner() {
111     require(msg.sender == owner);
112     _;
113   }
114 
115   /**
116    * @dev Allows the current owner to relinquish control of the contract.
117    */
118   function renounceOwnership() public onlyOwner {
119     emit OwnershipRenounced(owner);
120     owner = address(0);
121   }
122 
123   /**
124    * @dev Allows the current owner to transfer control of the contract to a newOwner.
125    * @param _newOwner The address to transfer ownership to.
126    */
127   function transferOwnership(address _newOwner) public onlyOwner {
128     _transferOwnership(_newOwner);
129   }
130 
131   /**
132    * @dev Transfers control of the contract to a newOwner.
133    * @param _newOwner The address to transfer ownership to.
134    */
135   function _transferOwnership(address _newOwner) internal {
136     require(_newOwner != address(0));
137     emit OwnershipTransferred(owner, _newOwner);
138     owner = _newOwner;
139   }
140 }
141 
142 contract PriceUpdaterInterface {
143   enum Currency { ETH, BTC, WME, WMZ, WMR, WMX }
144 
145   uint public decimalPrecision = 3;
146 
147   mapping(uint => uint) public price;
148 }
149 
150 contract CrowdsaleInterface {
151   uint public rate;
152   uint public minimumAmount;
153 
154   function externalBuyToken(address _beneficiary, PriceUpdaterInterface.Currency _currency, uint _amount, uint _tokens) external;
155 }
156 
157 contract MerchantControllerInterface {
158   mapping(uint => uint) public totalInvested;
159   mapping(uint => bool) public paymentId;
160 
161   function calcPrice(PriceUpdaterInterface.Currency _currency, uint _tokens) public view returns(uint);
162   function buyTokens(address _beneficiary, PriceUpdaterInterface.Currency _currency, uint _amount, uint _tokens, uint _paymentId) external;
163 }
164 
165 contract MerchantController is MerchantControllerInterface, ReentrancyGuard, Ownable {
166   using SafeMath for uint;
167 
168   PriceUpdaterInterface public priceUpdater;
169   CrowdsaleInterface public crowdsale;
170 
171   constructor(PriceUpdaterInterface _priceUpdater, CrowdsaleInterface _crowdsale) public  {
172     priceUpdater = _priceUpdater;
173     crowdsale = _crowdsale;
174   }
175 
176   function calcPrice(PriceUpdaterInterface.Currency _currency, uint _tokens) 
177       public 
178       view 
179       returns(uint) 
180   {
181     uint priceInWei = _tokens.mul(1 ether).div(crowdsale.rate());
182     if (_currency == PriceUpdaterInterface.Currency.ETH) {
183       return priceInWei;
184     }
185     uint etherPrice = priceUpdater.price(uint(PriceUpdaterInterface.Currency.ETH));
186     uint priceInEur = priceInWei.mul(etherPrice).div(1 ether);
187 
188     uint currencyPrice = priceUpdater.price(uint(_currency));
189     uint tokensPrice = priceInEur.mul(currencyPrice);
190     
191     return tokensPrice;
192   }
193 
194   function buyTokens(
195     address _beneficiary,
196     PriceUpdaterInterface.Currency _currency,
197     uint _amount,
198     uint _tokens,
199     uint _paymentId)
200       external
201       onlyOwner
202       nonReentrant
203   {
204     require(_beneficiary != address(0));
205     require(_currency != PriceUpdaterInterface.Currency.ETH);
206     require(_amount != 0);
207     require(_tokens >= crowdsale.minimumAmount());
208     require(_paymentId != 0);
209     require(!paymentId[_paymentId]);
210     paymentId[_paymentId] = true;
211     crowdsale.externalBuyToken(_beneficiary, _currency, _amount, _tokens);
212   }
213 }