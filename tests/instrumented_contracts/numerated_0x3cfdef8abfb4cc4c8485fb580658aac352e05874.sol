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
100   mapping(address=>bool) public participated;
101 
102    // address where funds are collected
103   address public wallet;
104 
105   // how many token units a buyer gets per wei (for < 1ETH purchases)
106   uint256 public rate = 28000;
107 
108   // how many token units a buyer gets per wei (for < 5ETH purchases)
109   uint256 public rate1 = 32000;
110 
111   // how many token units a buyer gets per wei (for < 10ETH purchases)
112   uint256 public rate5 = 36000;
113 
114   // how many token units a buyer gets per wei (for >= 10ETH purchases)
115   uint256 public rate10 = 40000;
116 
117   // amount of raised money in wei
118   uint256 public weiRaised;
119 
120   /**
121    * event for token purchase logging
122    * @param purchaser who paid for the tokens
123    * @param beneficiary who got the tokens
124    * @param value weis paid for purchase
125    * @param amount amount of tokens purchased
126    */
127   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
128 
129   function Sale(address _tokenAddress, address _wallet) public {
130     token = SMEBankingPlatformToken(_tokenAddress);
131     wallet = _wallet;
132   }
133 
134   function () external payable {
135     buyTokens(msg.sender);
136   }
137 
138   function setRate(uint256 _rate) public onlyOwner {
139     require(_rate > 0);
140     rate = _rate;
141   }
142 
143   function setRate1(uint256 _rate) public onlyOwner {
144     require(_rate > 0);
145     rate1 = _rate;
146   }
147 
148   function setRate5(uint256 _rate) public onlyOwner {
149     require(_rate > 0);
150     rate5 = _rate;
151   }
152 
153   function setRate10(uint256 _rate) public onlyOwner {
154     require(_rate > 0);
155     rate10 = _rate;
156   }
157 
158   function buyTokens(address beneficiary) public payable {
159     require(beneficiary != address(0));
160     require(msg.value != 0);
161 
162     uint256 weiAmount = msg.value;
163 
164     uint256 tokens = getTokenAmount(beneficiary, weiAmount);
165 
166     weiRaised = weiRaised.add(weiAmount);
167 
168     token.transfer(beneficiary, tokens);
169 
170     TokenPurchase(
171       msg.sender,
172       beneficiary,
173       weiAmount,
174       tokens
175     );
176 
177     participated[beneficiary] = true;
178 
179     forwardFunds();
180   }
181 
182   function getTokenAmount(address beneficiary, uint256 weiAmount) internal view returns(uint256) {
183     uint256 tokenAmount;
184 
185     if (weiAmount >= 10 ether) {
186       tokenAmount = weiAmount.mul(rate10);
187     } else if (weiAmount >= 5 ether) {
188       tokenAmount = weiAmount.mul(rate5);
189     } else if (weiAmount >= 1 ether) {
190       tokenAmount = weiAmount.mul(rate1);
191     } else {
192       tokenAmount = weiAmount.mul(rate);
193     }
194 
195     if (!participated[beneficiary] && weiAmount >= 0.01 ether) {
196       tokenAmount = tokenAmount.add(200 * 10 ** 18);
197     }
198 
199     return tokenAmount;
200   }
201 
202   function forwardFunds() internal {
203     wallet.transfer(msg.value);
204   }
205 }
206 
207 
208 contract SMEBankingPlatformSale2 is Sale {
209   function SMEBankingPlatformSale2(address _tokenAddress, address _wallet) public
210     Sale(_tokenAddress, _wallet)
211   {
212 
213   }
214 
215   function drainRemainingTokens () public onlyOwner {
216     token.transfer(owner, token.balanceOf(this));
217   }
218 }