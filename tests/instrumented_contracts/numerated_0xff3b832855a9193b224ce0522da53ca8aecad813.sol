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
71 contract ASTRICOPreSale is Ownable {
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
88   uint256 internal ALLOC_CROWDSALE    = 10000000 * decimalsConversion; // (10 ** uint256(decimals)); // 10 mill in ICO
89   // we have already sold some
90   // 
91   // 90MIL      90000000
92   // 10MIL      10000000
93   // 90MIL 4DCP 900000000000
94   // 10MIL 4dCP 100000000000
95 
96   uint internal BASIC_RATE        = 75 * decimalsConversion; // based on the price of ether at 330 USD
97   uint internal PRICE_STAGE_PS    = 431 * decimalsConversion; 
98   uint internal STAGE_PS_TIME_END = 60 minutes; // THIS IS TO BE SET PROPERLY
99   uint internal PRICE_VARIABLE    = 0 * decimalsConversion;
100   uint256 public astrSold         = 0;
101 
102   bool public halted;
103   bool public crowdsaleClosed;
104 
105   // simple event to track purchases
106   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
107 
108   modifier isNotHalted() {     require(!halted);    _;  }
109   modifier afterDeadline() { if (now >= endTime) _; }
110 
111   /**
112     * Constructor for ASTRICOPreSale
113     * param _token  ASTRCoin   0x567354a9F8367ff25F6967C947239fe75649e64e
114     * param _startTime start time for public sale
115     * param _ethWallet all incoming eth transfered here. Use multisig wallet 0xeA173bf22d7fF1ad9695652432b8759A331d668b
116     *
117     *     *
118 
119 0x80E7a4d750aDe616Da896C49049B7EdE9e04C191
120 
121 
122 1510911600
123 2017-11-17 17:40:00
124 
125 1511758800
126 2017-11-27 13:00:00
127 
128     *
129     * 90000000000
130   */
131     function ASTRICOPreSale() public  {
132 
133     crowdsaleClosed = false;
134     halted          = false;
135     startTime       = 1510911600; //1510563716; //_startTime;  make it +20 minutes for it to work
136     endTime         = 1511758800; //_startTime + STAGE_FOUR_TIME_END; set start and end the same :/
137     wallet          = ERC20(0x3baDA155408AB1C9898FDF28e545b51f2f9a65CC); // This wallet needs to give permission for the ICO to transfer Tokens  Ropsten 0xeA173bf22d7fF1ad9695652432b8759A331d668b
138     ownerAddress    = ERC20(0x3EFAe2e152F62F5cc12cc0794b816d22d416a721);  // This is bad in theory but does fix the 2300 gas problem Ropsten 0xeA173bf22d7fF1ad9695652432b8759A331d668b
139     token           = ERC20(0x80E7a4d750aDe616Da896C49049B7EdE9e04C191); // Ropsten we have pregenerated thiss
140   }
141 
142         // fallback function can be used to buy tokens
143   function () public payable {
144     require(msg.sender                 != 0x0);
145     require(validPurchase());
146     require(!halted); // useful to test if we have paused it
147     uint256 weiAmount                  = msg.value; // money sent in wei
148     uint256 tokens                     = SafeMath.div(SafeMath.mul(weiAmount, getCurrentRate()), 1 ether);
149     require(ALLOC_CROWDSALE - astrSold >= tokens);
150     weiRaised                          += weiAmount;
151     astrSold                           += tokens;
152     token.transferFrom(ownerAddress, msg.sender, tokens);
153     wallet.transfer(msg.value); // transfer straight away PRESALE wallet
154   }
155 
156 
157   function validPurchase() internal constant returns (bool) {
158     bool withinPeriod = now >= startTime && now <= endTime;
159     bool nonZeroPurchase = (msg.value != 0);
160     bool astrAvailable = (ALLOC_CROWDSALE - astrSold) > 0; 
161     return withinPeriod && nonZeroPurchase && astrAvailable && ! crowdsaleClosed;
162   }
163 
164   function getCurrentRate() internal constant returns (uint256) {  
165     if( PRICE_VARIABLE > 0 ) {
166       return PRICE_VARIABLE; // we can manually set prices if we want
167     }
168     return PRICE_STAGE_PS;
169   }
170 
171 
172   // this closes it when we want to close - rather than waiting 
173   function setNewRate(uint256 _coinsPerEther) onlyOwner public {
174     if( _coinsPerEther > 0 ) {
175         PRICE_VARIABLE = _coinsPerEther * decimalsConversion;
176     }
177   }
178     // this closes it when we want to close - rather than waiting 
179   function setFixedRate() onlyOwner public {
180      PRICE_VARIABLE = 0 * decimalsConversion;
181   }
182 
183 
184   // this closes it when we want to close - rather than waiting - this is BAD
185   function closeSaleAnyway() onlyOwner public {
186       // wallet.transfer(weiRaised);
187       crowdsaleClosed = true;
188     }
189 
190     // this closes it when we want to close - rather than waiting 
191   function safeCloseSale()  onlyOwner afterDeadline public {
192     // wallet.transfer(weiRaised);
193     crowdsaleClosed = true;
194   }
195 
196   function pause() onlyOwner public {
197     halted = true;
198   }
199 
200 
201   function unpause() onlyOwner public {
202     halted = false;
203   }
204 }