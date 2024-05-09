1 pragma solidity ^0.4.24;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender)
12     public view returns (uint256);
13 
14   function transferFrom(address from, address to, uint256 value)
15     public returns (bool);
16 
17   function approve(address spender, uint256 value) public returns (bool);
18   event Approval(
19     address indexed owner,
20     address indexed spender,
21     uint256 value
22   );
23 }
24 
25 contract Ownable {
26   address public owner;
27 
28 
29   event OwnershipTransferred(
30     address indexed previousOwner,
31     address indexed newOwner
32   );
33 
34 
35   /**
36    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
37    * account.
38    */
39   constructor() public {
40     owner = msg.sender;
41   }
42 
43   /**
44    * @dev Throws if called by any account other than the owner.
45    */
46   modifier onlyOwner() {
47     require(msg.sender == owner);
48     _;
49   }
50 
51   /**
52    * @dev Allows the current owner to transfer control of the contract to a newOwner.
53    * @param newOwner The address to transfer ownership to.
54    */
55   function transferOwnership(address newOwner) public onlyOwner {
56     require(newOwner != address(0));
57     emit OwnershipTransferred(owner, newOwner);
58     owner = newOwner;
59   }
60 }
61 
62 contract Crowdsale is Ownable {
63   using SafeMath for uint256;
64 
65   ERC20 public token;
66 
67   // How many wei units a buyer gets per token
68   uint256 public price;
69 
70   // Amount of wei raised
71   uint256 public weiRaised;
72 
73   /**
74    * Event for token purchase logging
75    * @param beneficiary who got the tokens
76    * @param value weis paid for purchase
77    * @param amount amount of tokens purchased
78    */
79   event TokenPurchase(
80     address indexed beneficiary,
81     uint256 value,
82     uint256 amount
83   );
84 
85   bool public isFinalized = false;
86 
87   event Finalized();
88 
89   /**
90    * @param _token Address of the token being sold
91    * @param _price How many wei units a buyer gets per token
92    */
93   constructor(ERC20 _token, uint256 _price) public {
94     require(_token != address(0));
95     require(_price > 0);
96     token = _token;
97     price = _price;
98   }
99 
100   /**
101    * Crowdsale token purchase logic
102    */
103   function () external payable {
104     require(!isFinalized);
105 
106     address beneficiary = msg.sender;
107     uint256 weiAmount = msg.value;
108 
109     require(beneficiary != address(0));
110     require(weiAmount != 0);
111 
112     uint256 tokens = weiAmount.div(price);
113     uint256 selfBalance = balance();
114     require(tokens > 0);
115     require(tokens <= selfBalance);
116 
117     // Get tokens to beneficiary
118     token.transfer(beneficiary, tokens);
119 
120     emit TokenPurchase(
121       beneficiary,
122       weiAmount,
123       tokens
124     );
125 
126     // Transfet eth to owner
127     owner.transfer(msg.value);
128 
129     // update state
130     weiRaised = weiRaised.add(weiAmount);
131   }
132 
133 
134   /**
135    * Self tokken ballance
136    */
137   function balance() public view returns (uint256) {
138     address self = address(this);
139     uint256 selfBalance = token.balanceOf(self);
140     return selfBalance;
141   }
142 
143   /**
144    * Set new price
145    * @param _price How many wei units a buyer gets per token
146    */
147   function setPrice(uint256 _price) onlyOwner public {
148     require(_price > 0);
149     price = _price;
150   }
151 
152   /**
153    * Must be called after crowdsale ends, to do some extra finalization work.
154    */
155   function finalize() onlyOwner public {
156     require(!isFinalized);
157 
158     transferBallance();
159 
160     emit Finalized();
161     isFinalized = true;
162   }
163 
164   /**
165    * Send all token ballance to owner
166    */
167   function transferBallance() onlyOwner public {
168     uint256 selfBalance = balance();
169     token.transfer(msg.sender, selfBalance);
170   }
171 }
172 
173 library SafeMath {
174 
175   /**
176   * @dev Multiplies two numbers, throws on overflow.
177   */
178   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
179     if (a == 0) {
180       return 0;
181     }
182     c = a * b;
183     assert(c / a == b);
184     return c;
185   }
186 
187   /**
188   * @dev Integer division of two numbers, truncating the quotient.
189   */
190   function div(uint256 a, uint256 b) internal pure returns (uint256) {
191     // assert(b > 0); // Solidity automatically throws when dividing by 0
192     // uint256 c = a / b;
193     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
194     return a / b;
195   }
196 
197   /**
198   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
199   */
200   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
201     assert(b <= a);
202     return a - b;
203   }
204 
205   /**
206   * @dev Adds two numbers, throws on overflow.
207   */
208   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
209     c = a + b;
210     assert(c >= a);
211     return c;
212   }
213 }