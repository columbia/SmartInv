1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {  //was constant
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 /************************************************************************************************
35  * 
36  *************************************************************************************************/
37 
38 contract Ownable {
39   address public owner;
40 
41   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43   function Ownable() public {
44     owner = msg.sender;
45   }
46 
47 
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 
53   function transferOwnership(address newOwner) onlyOwner public {
54     require(newOwner != address(0));
55     OwnershipTransferred(owner, newOwner);
56     owner = newOwner;
57   }
58 
59 }
60 
61 contract ERC20 { 
62     function transfer(address receiver, uint amount) public ;
63     function transferFrom(address sender, address receiver, uint amount) public returns(bool success); // do token.approve on the ICO contract
64     function balanceOf(address _owner) constant public returns (uint256 balance);
65 }
66 
67 /************************************************************************************************
68  * 
69  *************************************************************************************************/
70 
71 contract ASTRICOSale is Ownable {
72   ERC20 public token;  // using the ASTRCoin token - will set an address
73 
74   // start and end of the sale - 4 weeks
75   uint256 public startTime;
76   uint256 public endTime;
77 
78   // where funds are collected 
79 
80   address public wallet;  // beneficiary
81   address public ownerAddress;  // deploy owner
82 
83   // amount of raised money in wei
84   uint256 public weiRaised;
85   
86   uint8 internal decimals             = 4; // 4 decimal places should be enough in general
87   uint256 internal decimalsConversion = 10 ** uint256(decimals);
88   uint256 internal ALLOC_CROWDSALE    = 90000000 * decimalsConversion; // (10 ** uint256(decimals)); // 90 mill in ICO
89 
90   // 90MIL      90000000
91   // 10MIL      10000000
92   // 90MIL 4DCP 900000000000
93 
94   uint internal BASIC_RATE        = 133 * decimalsConversion; // based on the price of ether at 330 USD
95   uint internal PRICE_STAGE_PS    = 625 * decimalsConversion; 
96   uint internal PRICE_STAGE_ONE   = 445 * decimalsConversion;
97   uint internal PRICE_STAGE_TWO   = 390 * decimalsConversion;
98   uint internal PRICE_STAGE_THREE = 347 * decimalsConversion;
99   uint internal PRICE_STAGE_FOUR  = 312 * decimalsConversion;
100   uint public   PRICE_VARIABLE    = 0 * decimalsConversion;
101 
102   //TIME LIMITS
103   // uint public constant STAGE_ONE_TIME_END   = 1 weeks;
104   // uint public constant STAGE_TWO_TIME_END   = 2 weeks;
105   // uint public constant STAGE_THREE_TIME_END = 3 weeks;
106   // uint public constant STAGE_FOUR_TIME_END  = 4 weeks;
107 
108   uint internal STAGE_ONE_TIME_END   = 1 weeks;
109   uint internal STAGE_TWO_TIME_END   = 2 weeks;
110   uint internal STAGE_THREE_TIME_END = 3 weeks;
111   uint internal STAGE_FOUR_TIME_END  = 4 weeks;
112   uint256 public astrSold            = 0;
113 
114   bool public halted;
115   bool public crowdsaleClosed;
116 
117   // simple event to track purchases
118   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
119 
120   modifier isNotHalted() {     require(!halted);    _;  }
121   modifier afterDeadline() { if (now >= endTime) _; }
122 
123 
124   /**
125     * Constructor for ASTRICOSale
126     * param _token  ASTRCoin   0x80E7a4d750aDe616Da896C49049B7EdE9e04C191
127     *
128     * 1511798400
129     * Tuesday, November 28, 2017 12:00:00 AM GMT+08:00
130     *
131     * 90000000000
132   */
133   // function ASTRCoinCrowdSale(address _token, uint256 _startTime, address _ethWallet) public  {
134     function ASTRICOSale() public  {
135 
136     // require(_startTime >= now);
137     // require(_ethWallet != 0x0);   
138 
139     crowdsaleClosed = false;
140     halted          = false;
141     startTime       = 1511798400; // Tuesday, November 28, 2017 12:00:00 AM GMT+08:00
142     endTime         = startTime + STAGE_FOUR_TIME_END; //_startTime + STAGE_FOUR_TIME_END; set start and end the same :/
143     wallet          = ERC20(0x3baDA155408AB1C9898FDF28e545b51f2f9a65CC); // This wallet needs to give permission for the ICO to transfer Tokens 
144     ownerAddress    = ERC20(0x3EFAe2e152F62F5cc12cc0794b816d22d416a721);  // This is bad in theory but does fix the 2300 gas problem 
145     token           = ERC20(0x80E7a4d750aDe616Da896C49049B7EdE9e04C191); // Ropsten we have pregenerated thiss
146   }
147 
148         // fallback function can be used to buy tokens
149   function () public payable {
150     require(msg.sender                 != 0x0);
151     require(validPurchase());
152     require(!halted); // useful to test if we have paused it
153     uint256 weiAmount                  = msg.value; // money sent in wei
154     uint256 tokens                     = SafeMath.div(SafeMath.mul(weiAmount, getCurrentRate()), 1 ether);
155     require(ALLOC_CROWDSALE - astrSold >= tokens);
156     weiRaised                          += weiAmount;
157     astrSold                           += tokens;
158     token.transferFrom(ownerAddress, msg.sender, tokens);
159     wallet.transfer(msg.value); // transfer straight away PRESALE wallet
160   }
161 
162 
163   function validPurchase() internal constant returns (bool) {
164     bool withinPeriod = now >= startTime && now <= endTime;
165     bool nonZeroPurchase = (msg.value != 0);
166     bool astrAvailable = (ALLOC_CROWDSALE - astrSold) > 0; 
167     return withinPeriod && nonZeroPurchase && astrAvailable && ! crowdsaleClosed;
168   }
169 
170   function getCurrentRate() internal constant returns (uint256) {  
171     uint delta = SafeMath.sub(now, startTime);
172 
173     if( PRICE_VARIABLE > 0 ) {
174       return PRICE_VARIABLE; // we can manually set prices if we want
175     }
176 
177     if (delta > STAGE_THREE_TIME_END) {
178       return PRICE_STAGE_FOUR;
179     }
180     if (delta > STAGE_TWO_TIME_END) {
181       return PRICE_STAGE_THREE;
182     }
183     if (delta > STAGE_ONE_TIME_END) {
184       return PRICE_STAGE_TWO;
185     }
186     return PRICE_STAGE_ONE;
187   }
188 
189 
190   // this closes it when we want to close - rather than waiting 
191   function setNewRate(uint256 _coinsPerEther) onlyOwner public {
192     if( _coinsPerEther > 0 ) {
193         PRICE_VARIABLE = _coinsPerEther * decimalsConversion;
194     }
195   }
196     // this closes it when we want to close - rather than waiting 
197   function setFixedRate() onlyOwner public {
198      PRICE_VARIABLE = 0 * decimalsConversion;
199   }
200 
201 
202   // this closes it when we want to close - rather than waiting - this is bad
203   function closeSaleAnyway() onlyOwner public {
204       // wallet.transfer(weiRaised);
205       crowdsaleClosed = true;
206     }
207 
208     // this closes it when we want to close - rather than waiting 
209   function safeCloseSale()  onlyOwner afterDeadline public {
210     // wallet.transfer(weiRaised);
211     crowdsaleClosed = true;
212   }
213 
214   function pause() onlyOwner public {
215     halted = true;
216   }
217 
218 
219   function unpause() onlyOwner public {
220     halted = false;
221   }
222 }