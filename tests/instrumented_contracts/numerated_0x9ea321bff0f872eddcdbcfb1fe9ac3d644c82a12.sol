1 pragma solidity 0.4.18;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29 
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   function Ownable() public {
35     owner = msg.sender;
36   }
37 
38 
39   /**
40    * @dev Throws if called by any account other than the owner.
41    */
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46 
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address newOwner) public onlyOwner {
53     require(newOwner != address(0));
54     OwnershipTransferred(owner, newOwner);
55     owner = newOwner;
56   }
57 
58 }
59 
60 
61 
62 
63 
64 /**
65  * @title SafeMath
66  * @dev Math operations with safety checks that throw on error
67  */
68 library SafeMath {
69   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
70     if (a == 0) {
71       return 0;
72     }
73     uint256 c = a * b;
74     assert(c / a == b);
75     return c;
76   }
77 
78   function div(uint256 a, uint256 b) internal pure returns (uint256) {
79     // assert(b > 0); // Solidity automatically throws when dividing by 0
80     uint256 c = a / b;
81     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
82     return c;
83   }
84 
85   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
86     assert(b <= a);
87     return a - b;
88   }
89 
90   function add(uint256 a, uint256 b) internal pure returns (uint256) {
91     uint256 c = a + b;
92     assert(c >= a);
93     return c;
94   }
95 }
96 
97 
98 
99 
100 
101 
102 
103 /**
104  * @title ERC20 interface
105  * @dev see https://github.com/ethereum/EIPs/issues/20
106  */
107 contract ERC20 is ERC20Basic {
108   function allowance(address owner, address spender) public view returns (uint256);
109   function transferFrom(address from, address to, uint256 value) public returns (bool);
110   function approve(address spender, uint256 value) public returns (bool);
111   event Approval(address indexed owner, address indexed spender, uint256 value);
112 }
113 
114 
115 
116 
117 /**
118  * @title Crowdsale
119  * @dev Crowdsale is a base contract for managing a token crowdsale.
120  * Crowdsales have a start and end timestamps, where investors can make
121  * token purchases and the crowdsale will assign them tokens based
122  * on a token per ETH rate. Funds collected are forwarded to a wallet
123  * as they arrive.
124  */
125 contract Crowdsale is Ownable {
126   using SafeMath for uint256;
127 
128   // The token being sold
129   ERC20 public token;
130   uint256 private transactionNum;
131 
132   // start and end timestamps where investments are allowed (both inclusive)
133   uint256 public startTime;
134   uint256 public endTime;
135 
136   // address where funds are collected
137   address public wallet;
138 
139   // how many token units a buyer gets per wei
140   uint256 public rate;
141   uint256 public discountRate = 3333;
142 
143   // amount of raised money in wei
144   uint256 public weiRaised;
145 
146   /**
147    * event for token purchase logging
148    * @param purchaser who paid for the tokens
149    * @param beneficiary who got the tokens
150    * @param value weis paid for purchase
151    * @param amount amount of tokens purchased
152    */
153   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
154 
155 
156   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, address _token) public {
157     require(_startTime >= now);
158     require(_endTime >= _startTime);
159     require(_rate > 0);
160     require(_wallet != address(0));
161 
162     token = ERC20(_token);
163     startTime = _startTime;
164     endTime = _endTime;
165     rate = _rate;
166     wallet = _wallet;
167   }
168 
169   // fallback function can be used to buy tokens
170   function () external payable {
171     buyTokens(msg.sender);
172   }
173 
174   // low level token purchase function
175   function buyTokens(address beneficiary) public payable {
176     require(beneficiary != address(0));
177     require(validPurchase());
178 
179     uint256 weiAmount = msg.value;
180     uint256 tokens;
181     if(transactionNum < 100) {
182       tokens = weiAmount.mul(discountRate);
183     } else {
184       tokens = weiAmount.mul(rate);
185     }
186 
187 
188     uint256 tokenBalance = token.balanceOf(this);
189     require(tokenBalance >= tokens);
190 
191     transactionNum = transactionNum + 1;
192     // update state
193     weiRaised = weiRaised.add(weiAmount);
194 
195     token.transfer(beneficiary, tokens);
196     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
197 
198     forwardFunds();
199   }
200 
201   // @return true if crowdsale event has ended
202   function hasEnded() public view returns (bool) {
203     return now > endTime;
204   }
205 
206 
207 
208   // send ether to the fund collection wallet
209   // override to create custom fund forwarding mechanisms
210   function forwardFunds() internal {
211     wallet.transfer(msg.value);
212   }
213 
214   // @return true if the transaction can buy tokens
215   function validPurchase() internal view returns (bool) {
216     bool withinPeriod = now >= startTime && now <= endTime;
217     bool nonZeroPurchase = msg.value != 0;
218 
219     return withinPeriod && nonZeroPurchase;
220   }
221 
222   function finalization() internal {
223     token.transfer(owner, token.balanceOf(this));
224   }
225 
226 }
227 
228 
229 
230 
231 contract PreICO is Crowdsale {
232   using SafeMath for uint256;
233   uint256 public cap;
234   bool public isFinalized;
235 
236   uint256 public minContribution = 100000000000000000;
237   uint256 public maxContribution = 1000 ether;
238   function PreICO(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _cap, address _wallet, address _token) public
239   Crowdsale(_startTime, _endTime, _rate, _wallet, _token)
240   {
241       cap = _cap;
242   }
243 
244   function hasEnded() public view returns (bool) {
245     bool capReached = weiRaised >= cap;
246     return capReached || super.hasEnded();
247   }
248 
249   // overriding Crowdsale#validPurchase to add extra cap logic
250   // @return true if investors can buy at the moment
251   function validPurchase() internal view returns (bool) {
252     //0.1 eth and 1000 eth
253     bool withinRange = msg.value >= minContribution && msg.value <= maxContribution;
254     bool withinCap = weiRaised.add(msg.value) <= cap;
255     return withinRange && withinCap && super.validPurchase();
256   }
257 
258   function changeMinContribution(uint256 _minContribution) public onlyOwner {
259     require(_minContribution > 0);
260     minContribution = _minContribution;
261   }
262 
263   function changeMaxContribution(uint256 _maxContribution) public onlyOwner {
264     require(_maxContribution > 0);
265     maxContribution = _maxContribution;
266   }
267 
268   function finalize() onlyOwner public {
269     require(!isFinalized);
270     require(hasEnded());
271     super.finalization();
272     isFinalized = true;
273   }
274 
275   function setNewWallet(address _newWallet) onlyOwner public {
276     wallet = _newWallet;
277   }
278 
279 }