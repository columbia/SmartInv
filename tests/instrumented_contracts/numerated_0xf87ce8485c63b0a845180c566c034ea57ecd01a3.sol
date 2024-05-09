1 pragma solidity ^0.4.21;
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
51 contract RealEstateCryptoFund {
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
89     emit OwnershipTransferred(owner, newOwner);
90     owner = newOwner;
91   }
92 }
93 
94 
95 contract RECFCO is Ownable {
96   
97   using SafeMath for uint256;
98 
99   RealEstateCryptoFund public token;
100 
101   mapping(address=>bool) public participated;
102    
103    
104    // address where funds are collected
105   address public wallet;
106   
107   //address public token_wallet;
108   
109   //date stop crodwsale
110   uint256 public  salesdeadline;
111 
112   // how many token units a buyer gets per wei (for < 1ETH purchases)
113   uint256 public rate;
114 
115   // amount of raised money in wei
116   uint256 public weiRaised;
117   
118  event sales_deadlineUpdated(uint256 sales_deadline );// volessimo allungare il contratto di sale 
119  event WalletUpdated(address wallet);
120  event RateUpdate(uint256 rate);
121  //event tokenWalletUpdated(address token_wallet);
122 
123   /**
124    * event for token purchase logging
125    * @param purchaser who paid for the tokens
126    * @param beneficiary who got the tokens
127    * @param value weis paid for purchase
128    * @param amount amount of tokens purchased
129    */
130   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
131 
132   function RECFCO(address _tokenAddress, address _wallet) public {
133     token = RealEstateCryptoFund(_tokenAddress);
134     wallet = _wallet;
135   }
136 
137   function () external payable {
138     buyTokens(msg.sender);
139   }
140 
141  
142 
143   
144 
145   function buyTokens(address beneficiary) public payable {
146     require(now < salesdeadline);
147     require(beneficiary != address(0));
148     require(msg.value != 0);
149 
150     uint256 weiAmount = msg.value;
151 
152     uint256 tokens = getTokenAmount( weiAmount);
153 
154     weiRaised = weiRaised.add(weiAmount);
155 
156     token.transfer(beneficiary, tokens);
157 
158     emit TokenPurchase(
159       msg.sender,
160       beneficiary,
161       weiAmount,
162       tokens
163     );
164 
165     participated[beneficiary] = true;
166 
167     forwardFunds();
168   }
169 
170  
171 
172 function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
173     uint256 tokenAmount;
174     tokenAmount = weiAmount.mul(rate);
175     return tokenAmount;
176   }
177 
178   
179   function forwardFunds() internal {
180     wallet.transfer(msg.value);
181       
182   }
183  
184 function setRate(uint256 _rate) public onlyOwner {
185     require(_rate > 0);
186     rate = _rate;
187     emit RateUpdate(rate);
188 }
189 
190 //wallet update
191 function setWallet (address _wallet) onlyOwner public {
192 wallet=_wallet;
193 emit WalletUpdated(wallet);
194 }
195 
196 //SALES_DEADLINE update
197 function setsalesdeadline (uint256 _salesdeadline) onlyOwner public {
198 salesdeadline=_salesdeadline;
199 require(now < salesdeadline);
200 emit sales_deadlineUpdated(salesdeadline);
201 }
202     
203 
204 }