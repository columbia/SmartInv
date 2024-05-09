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
94   uint internal BASIC_RATE        = 631 * decimalsConversion; // based on the price of ether at 755 USD
95   uint public   PRICE_VARIABLE    = 0 * decimalsConversion;
96 
97   //TIME LIMITS
98 
99   uint256 public astrSold            = 0;
100 
101   bool public halted;
102   bool public crowdsaleClosed;
103 
104   // simple event to track purchases
105   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
106 
107   modifier isNotHalted() {     require(!halted);    _;  }
108   modifier afterDeadline() { if (now >= endTime) _; }
109 
110 
111   /**
112     * Constructor for ASTRICOSale
113     *
114     * 1513908673
115     *  Friday, December 22, 2017 10:11:13 AM GMT+08:00
116     *
117     * 1517414400
118     * Thursday, February 1, 2018 12:00:00 AM GMT+08:00
119     *
120     * 90000000000
121   */
122   // function ASTRCoinCrowdSale(address _token, uint256 _startTime, address _ethWallet) public  {
123     function ASTRICOSale() public  {
124 
125     // require(_startTime >= now);
126     // require(_ethWallet != 0x0);   
127 
128     crowdsaleClosed = false;
129     halted          = false;
130     startTime       = 1513908673; // Friday, December 22, 2017 10:11:13 AM GMT+08:00
131     endTime         = 1517414400; // Thursday, February 1, 2018 12:00:00 AM GMT+08:00
132     wallet          = ERC20(0x3baDA155408AB1C9898FDF28e545b51f2f9a65CC); // This wallet needs to give permission for the ICO to transfer Tokens 
133     ownerAddress    = ERC20(0x3EFAe2e152F62F5cc12cc0794b816d22d416a721);  // This is bad in theory but does fix the 2300 gas problem 
134     token           = ERC20(0x80E7a4d750aDe616Da896C49049B7EdE9e04C191); // Ropsten we have pregenerated thiss
135   }
136 
137         // fallback function can be used to buy tokens
138   function () public payable {
139     require(msg.sender                 != 0x0);
140     require(validPurchase());
141     require(!halted); // useful to test if we have paused it
142     uint256 weiAmount                  = msg.value; // money sent in wei
143     uint256 tokens                     = SafeMath.div(SafeMath.mul(weiAmount, getCurrentRate()), 1 ether);
144     require(ALLOC_CROWDSALE - astrSold >= tokens);
145     weiRaised                          += weiAmount;
146     astrSold                           += tokens;
147     token.transferFrom(ownerAddress, msg.sender, tokens);
148     wallet.transfer(msg.value); // transfer straight away wallet
149   }
150 
151 
152   function validPurchase() internal constant returns (bool) {
153     bool withinPeriod = now >= startTime && now <= endTime;
154     bool nonZeroPurchase = (msg.value != 0);
155     bool astrAvailable = (ALLOC_CROWDSALE - astrSold) > 0; 
156     return withinPeriod && nonZeroPurchase && astrAvailable && ! crowdsaleClosed;
157   }
158 
159   function getCurrentRate() internal constant returns (uint256) {  
160     if( PRICE_VARIABLE > 0 ) {
161       return PRICE_VARIABLE; // we can manually set prices if we want
162     }
163 
164     return BASIC_RATE;
165   }
166 
167 
168   // this closes it when we want to close - rather than waiting 
169   function setNewRate(uint256 _coinsPerEther) onlyOwner public {
170     if( _coinsPerEther > 0 ) {
171         PRICE_VARIABLE = _coinsPerEther * decimalsConversion;
172     }
173   }
174     // this closes it when we want to close - rather than waiting 
175   function setFixedRate() onlyOwner public {
176      PRICE_VARIABLE = 0 * decimalsConversion;
177   }
178 
179 
180   // this closes it when we want to close - rather than waiting - this is bad
181   function closeSaleAnyway() onlyOwner public {
182       // wallet.transfer(weiRaised);
183       crowdsaleClosed = true;
184     }
185 
186     // this closes it when we want to close - rather than waiting 
187   function safeCloseSale()  onlyOwner afterDeadline public {
188     // wallet.transfer(weiRaised);
189     crowdsaleClosed = true;
190   }
191 
192   function pause() onlyOwner public {
193     halted = true;
194   }
195 
196 
197   function unpause() onlyOwner public {
198     halted = false;
199   }
200 }