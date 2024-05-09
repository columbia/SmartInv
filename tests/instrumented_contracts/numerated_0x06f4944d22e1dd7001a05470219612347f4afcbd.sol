1 pragma solidity ^0.4.13;
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
70   // Minimum wei
71   uint256 public weiMinimum;
72 
73   // Amount of wei raised
74   uint256 public weiRaised;
75 
76   /**
77    * Event for token purchase logging
78    * @param beneficiary who got the tokens
79    * @param value weis paid for purchase
80    * @param amount amount of tokens purchased
81    */
82   event TokenPurchase(
83     address indexed beneficiary,
84     uint256 value,
85     uint256 amount
86   );
87 
88   bool public isFinalized = false;
89 
90   event Finalized();
91 
92   /**
93    * @param _token Address of the token being sold
94    * @param _price How many wei units a buyer gets per token
95    * @param _minimum Minimal wei per transaction
96    */
97   constructor(ERC20 _token, uint256 _price, uint256 _minimum) public {
98     require(_token != address(0));
99     require(_price > 0);
100     require(_minimum >= 0);
101     token = _token;
102     price = _price;
103     weiMinimum = _minimum * (10 ** 18);
104   }
105 
106   /**
107    * Crowdsale token purchase logic
108    */
109   function () external payable {
110     require(!isFinalized);
111 
112     address beneficiary = msg.sender;
113     uint256 weiAmount = msg.value;
114 
115     require(beneficiary != address(0));
116     require(weiAmount != 0);
117     require(weiAmount >= weiMinimum);
118 
119     uint256 tokens = weiAmount.div(price);
120     uint256 selfBalance = balance();
121     require(tokens > 0);
122     require(tokens <= selfBalance);
123 
124     // Get tokens to beneficiary
125     token.transfer(beneficiary, tokens);
126 
127     emit TokenPurchase(
128       beneficiary,
129       weiAmount,
130       tokens
131     );
132 
133     // Transfet eth to owner
134     owner.transfer(msg.value);
135 
136     // update state
137     weiRaised = weiRaised.add(weiAmount);
138   }
139 
140 
141   /**
142    * Self tokken ballance
143    */
144   function balance() public view returns (uint256) {
145     address self = address(this);
146     uint256 selfBalance = token.balanceOf(self);
147     return selfBalance;
148   }
149 
150   /**
151    * Set new price
152    * @param _price How many wei units a buyer gets per token
153    */
154   function setPrice(uint256 _price) onlyOwner public {
155     require(_price > 0);
156     price = _price;
157   }
158 
159   /**
160    * Set new minimum
161    * @param _minimum Minimal wei per transaction
162    */
163   function setMinimum(uint256 _minimum) onlyOwner public {
164     require(_minimum >= 0);
165     weiMinimum = _minimum * (10 ** 18);
166   }
167 
168   /**
169    * Must be called after crowdsale ends, to do some extra finalization work.
170    */
171   function finalize() onlyOwner public {
172     require(!isFinalized);
173 
174     transferBallance();
175 
176     emit Finalized();
177     isFinalized = true;
178   }
179 
180   /**
181    * Send all token ballance to owner
182    */
183   function transferBallance() onlyOwner public {
184     uint256 selfBalance = balance();
185     token.transfer(msg.sender, selfBalance);
186   }
187 }
188 
189 library SafeMath {
190 
191   /**
192   * @dev Multiplies two numbers, throws on overflow.
193   */
194   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
195     if (a == 0) {
196       return 0;
197     }
198     c = a * b;
199     assert(c / a == b);
200     return c;
201   }
202 
203   /**
204   * @dev Integer division of two numbers, truncating the quotient.
205   */
206   function div(uint256 a, uint256 b) internal pure returns (uint256) {
207     // assert(b > 0); // Solidity automatically throws when dividing by 0
208     // uint256 c = a / b;
209     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
210     return a / b;
211   }
212 
213   /**
214   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
215   */
216   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
217     assert(b <= a);
218     return a - b;
219   }
220 
221   /**
222   * @dev Adds two numbers, throws on overflow.
223   */
224   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
225     c = a + b;
226     assert(c >= a);
227     return c;
228   }
229 }