1 pragma solidity ^0.4.18;
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
51 contract SMEBankingPlatformToken {
52   function transfer(address to, uint256 value) public returns (bool);
53   function balanceOf(address who) public constant returns (uint256);
54 }
55 
56 
57 /**
58  * @title Ownable
59  * @dev The Ownable contract has an owner address, and provides basic authorization control
60  * functions, this simplifies the implementation of "user permissions".
61  */
62 contract Ownable {
63   address public owner;
64 
65   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
66 
67   /**
68    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
69    * account.
70    */
71   function Ownable() public {
72     owner = msg.sender;
73   }
74 
75   /**
76    * @dev Throws if called by any account other than the owner.
77    */
78   modifier onlyOwner() {
79     require(msg.sender == owner);
80     _;
81   }
82 
83   /**
84    * @dev Allows the current owner to transfer control of the contract to a newOwner.
85    * @param newOwner The address to transfer ownership to.
86    */
87   function transferOwnership(address newOwner) onlyOwner public {
88     require(newOwner != address(0));
89     OwnershipTransferred(owner, newOwner);
90     owner = newOwner;
91   }
92 }
93 
94 
95 contract Sale is Ownable {
96   using SafeMath for uint256;
97 
98   SMEBankingPlatformToken public token;
99 
100    // address where funds are collected
101   address public wallet;
102 
103   // how many token units a buyer gets per wei
104   uint256 public rate = 26434;
105 
106   // amount of raised money in wei
107   uint256 public weiRaised;
108 
109   /**
110    * event for token purchase logging
111    * @param purchaser who paid for the tokens
112    * @param beneficiary who got the tokens
113    * @param value weis paid for purchase
114    * @param amount amount of tokens purchased
115    */
116   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
117 
118   function Sale(address _tokenAddress, address _wallet) public {
119     token = SMEBankingPlatformToken(_tokenAddress);
120     wallet = _wallet;
121   }
122 
123   function () external payable {
124     buyTokens(msg.sender);
125   }
126 
127   function setRate(uint256 _rate) public onlyOwner {
128     require(_rate > 0);
129     rate = _rate;
130   }
131 
132   function buyTokens(address beneficiary) public payable {
133     require(beneficiary != address(0));
134     require(msg.value != 0);
135 
136     uint256 weiAmount = msg.value;
137 
138     uint256 tokens = getTokenAmount(weiAmount);
139 
140     weiRaised = weiRaised.add(weiAmount);
141 
142     token.transfer(beneficiary, tokens);
143 
144     TokenPurchase(
145       msg.sender,
146       beneficiary,
147       weiAmount,
148       tokens
149     );
150 
151     forwardFunds();
152   }
153 
154   // Override this method to have a way to add business logic to your crowdsale when buying
155   function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
156     return weiAmount.mul(rate);
157   }
158 
159   function forwardFunds() internal {
160     wallet.transfer(msg.value);
161   }
162 }
163 
164 
165 contract SMEBankingPlatformSale is Sale {
166   function SMEBankingPlatformSale(address _tokenAddress, address _wallet) public
167     Sale(_tokenAddress, _wallet)
168   {
169 
170   }
171 
172   function drainRemainingTokens () public onlyOwner {
173     token.transfer(owner, token.balanceOf(this));
174   }
175 }