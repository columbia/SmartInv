1 pragma solidity ^0.4.19;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64 
65   /**
66    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
67    * account.
68    */
69   function Ownable() public {
70     owner = msg.sender;
71   }
72 
73   /**
74    * @dev Throws if called by any account other than the owner.
75    */
76   modifier onlyOwner() {
77     require(msg.sender == owner);
78     _;
79   }
80 
81   /**
82    * @dev Allows the current owner to transfer control of the contract to a newOwner.
83    * @param newOwner The address to transfer ownership to.
84    */
85   function transferOwnership(address newOwner) public onlyOwner {
86     require(newOwner != address(0));
87     OwnershipTransferred(owner, newOwner);
88     owner = newOwner;
89   }
90 
91 }
92 
93 
94 
95 contract WelCoinICO is Ownable {
96 
97   using SafeMath for uint256;
98 
99   // start and end timestamps where main-investments are allowed (both inclusive)
100   uint256 public mainSaleStartTime;
101   uint256 public mainSaleEndTime;
102 
103   // maximum amout of wei for  main sale
104   //uint256 public mainSaleWeiCap;
105 
106   // maximum amout of wei to allow for investors
107   uint256 public mainSaleMinimumWei;
108 
109   // address where funds are collected
110   address public wallet;
111 
112   // address of erc20 token contract
113   address public token;
114 
115   // how many token units a buyer gets per wei
116   uint256 public rate;
117 
118   // bonus percent to apply
119   uint256 public percent;
120 
121   // amount of raised money in wei
122   //uint256 public weiRaised;
123 
124   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
125 
126   function WelCoinICO(uint256 _mainSaleStartTime, uint256 _mainSaleEndTime, address _wallet, address _token) public {
127 
128     // the end of main sale can't happen before it's start
129     require(_mainSaleStartTime < _mainSaleEndTime);
130     require(_wallet != 0x0);
131 
132     mainSaleStartTime = _mainSaleStartTime;
133     mainSaleEndTime = _mainSaleEndTime;
134     wallet = _wallet;
135     token = _token;
136     rate = 2500;
137     percent = 0;
138     mainSaleMinimumWei = 100000000000000000; // 0.1
139   }
140 
141   // fallback function can be used to buy tokens
142   function () external payable {
143     buyTokens(msg.sender);
144   }
145 
146   // low level token purchase function
147   function buyTokens(address beneficiary) public payable {
148 
149     require(beneficiary != 0x0);
150     require(msg.value != 0x0);
151     require(msg.value >= mainSaleMinimumWei);
152     require(now >= mainSaleStartTime && now <= mainSaleEndTime);
153 
154     uint256 weiAmount = msg.value;
155 
156     // calculate token amount to be created
157     uint256 tokens = weiAmount.mul(rate);
158 
159     // add bonus to tokens depends on the period
160     uint256 bonusedTokens = applyBonus(tokens, percent);
161 
162     require(token.call(bytes4(keccak256("transfer(address,uint256)")), beneficiary, bonusedTokens));
163 
164     // token.mint(beneficiary, bonusedTokens);
165     TokenPurchase(msg.sender, beneficiary, weiAmount, bonusedTokens);
166 
167     forwardFunds();
168   }
169 
170   // set new dates for main-sale (emergency case)
171   function setMainSaleParameters(uint256 _mainSaleStartTime, uint256 _mainSaleEndTime, uint256 _mainSaleMinimumWei) public onlyOwner {
172     require(_mainSaleStartTime < _mainSaleEndTime);
173     mainSaleStartTime = _mainSaleStartTime;
174     mainSaleEndTime = _mainSaleEndTime;
175     mainSaleMinimumWei = _mainSaleMinimumWei;
176   }
177 
178   // set new wallets (emergency case)
179   function setWallet(address _wallet) public onlyOwner {
180     require(_wallet != 0x0);
181     wallet = _wallet;
182   }
183 
184     // set new rate (emergency case)
185   function setRate(uint256 _rate) public onlyOwner {
186     require(_rate > 0);
187     rate = _rate;
188   }
189 
190   // send tokens to specified wallet wallet
191   function transferTokens(address _wallet, uint256 _amount) public onlyOwner {
192     require(_wallet != 0x0);
193     require(_amount != 0);
194     require(token.call(bytes4(keccak256("transfer(address,uint256)")), _wallet, _amount));
195   }
196 
197 
198   // @return true if main sale event has ended
199   function mainSaleHasEnded() external constant returns (bool) {
200     return now > mainSaleEndTime;
201   }
202 
203   // send ether to the fund collection wallet
204   function forwardFunds() internal {
205     wallet.transfer(msg.value);
206   }
207 
208 
209   function applyBonus(uint256 tokens, uint256 percentToApply) internal pure returns (uint256 bonusedTokens) {
210     uint256 tokensToAdd = tokens.mul(percentToApply).div(100);
211     return tokens.add(tokensToAdd);
212   }
213 
214 }