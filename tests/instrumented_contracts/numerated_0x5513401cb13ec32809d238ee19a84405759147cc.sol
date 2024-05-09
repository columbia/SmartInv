1 pragma solidity ^0.4.24;
2 
3 /**
4  * SmartEth.co
5  * ERC20 Token and ICO smart contracts development, smart contracts audit, ICO websites.
6  * contact@smarteth.co
7  */
8 
9 /**
10  * @title SafeMath
11  */
12 library SafeMath {
13 
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27     return c;
28   }
29 
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   function add(uint256 a, uint256 b) internal pure returns (uint256) {
36     uint256 c = a + b;
37     assert(c >= a);
38     return c;
39   }
40 }
41 
42 /**
43  * @title Ownable
44  */
45 contract Ownable {
46   address public owner;
47 
48   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50   constructor() public {
51     owner = 0x81FF7d5cA83707C23d663ADE4432bdc8eD6ccCE1;
52   }
53 
54   modifier onlyOwner() {
55     require(msg.sender == owner);
56     _;
57   }
58 
59   function transferOwnership(address newOwner) public onlyOwner {
60     require(newOwner != address(0));
61     emit OwnershipTransferred(owner, newOwner);
62     owner = newOwner;
63   }
64 
65 }
66 
67 /**
68  * @title Pausable
69  */
70 contract Pausable is Ownable {
71   event Pause();
72   event Unpause();
73 
74   bool public paused = false;
75 
76   modifier whenNotPaused() {
77     require(!paused);
78     _;
79   }
80 
81   modifier whenPaused() {
82     require(paused);
83     _;
84   }
85 
86   function pause() onlyOwner whenNotPaused public {
87     paused = true;
88     emit Pause();
89   }
90 
91   function unpause() onlyOwner whenPaused public {
92     paused = false;
93     emit Unpause();
94   }
95 }
96 
97 /**
98  * @title ERC20Basic
99  */
100 contract ERC20Basic {
101   function totalSupply() public view returns (uint256);
102   function balanceOf(address who) public view returns (uint256);
103   function transfer(address to, uint256 value) public returns (bool);
104   event Transfer(address indexed from, address indexed to, uint256 value);
105 }
106 
107 /**
108  * @title ERC20 interface
109  */
110 contract ERC20 is ERC20Basic {
111   function allowance(address owner, address spender) public view returns (uint256);
112   function transferFrom(address from, address to, uint256 value) public returns (bool);
113   function approve(address spender, uint256 value) public returns (bool);
114   event Approval(address indexed owner, address indexed spender, uint256 value);
115 }
116 
117 contract INTO_ICO is Pausable {
118   using SafeMath for uint256;
119 
120   // The token being sold
121   ERC20 public token;
122 
123   // Address where funds are collected
124   address public wallet;
125 
126   // Max supply of tokens offered in the crowdsale
127   uint256 public supply;
128 
129   // How many token units a buyer gets per wei
130   uint256 public rate;
131 
132   // Amount of wei raised
133   uint256 public weiRaised;
134   
135   // Crowdsale opening time
136   uint256 public openingTime;
137   
138   // Crowdsale closing time
139   uint256 public closingTime;
140 
141   // Crowdsale duration in days
142   uint256 public duration;
143 
144   // Min amount of wei an investor can send
145   uint256 public minInvest;
146 
147   /**
148    * Event for token purchase logging
149    * @param purchaser who paid for the tokens
150    * @param beneficiary who got the tokens
151    * @param value weis paid for purchase
152    * @param amount amount of tokens purchased
153    */
154   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
155 
156   constructor() public {
157     rate = 50000;
158     wallet = owner;
159     token = ERC20(0x7f738ffbdE7ECAC18D31ECba1e9B6eEF5b9214b7);
160     minInvest = 0.05 * 1 ether;
161     duration = 176 days;
162     openingTime = 1530446400;  // Determined by start()
163     closingTime = openingTime + duration;  // Determined by start()
164   }
165   
166   /**
167    * @dev called by the owner to start the crowdsale
168    */
169   function start() public onlyOwner {
170     openingTime = now;
171     closingTime =  now + duration;
172   }
173 
174   // -----------------------------------------
175   // Crowdsale external interface
176   // -----------------------------------------
177 
178   /**
179    * @dev fallback function ***DO NOT OVERRIDE***
180    */
181   function () external payable {
182     buyTokens(msg.sender);
183   }
184 
185   /**
186    * @dev low level token purchase ***DO NOT OVERRIDE***
187    * @param _beneficiary Address performing the token purchase
188    */
189   function buyTokens(address _beneficiary) public payable {
190 
191     uint256 weiAmount = msg.value;
192     _preValidatePurchase(_beneficiary, weiAmount);
193 
194     // calculate token amount to be created
195     uint256 tokens = _getTokenAmount(weiAmount);
196 
197     // update state
198     weiRaised = weiRaised.add(weiAmount);
199 
200     _processPurchase(_beneficiary, tokens);
201     emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
202 
203     _forwardFunds();
204   }
205 
206   // -----------------------------------------
207   // Internal interface (extensible)
208   // -----------------------------------------
209 
210   /**
211    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
212    * @param _beneficiary Address performing the token purchase
213    * @param _weiAmount Value in wei involved in the purchase
214    */
215   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal whenNotPaused {
216     require(_beneficiary != address(0));
217     require(_weiAmount >= minInvest);
218     require(now >= openingTime && now <= closingTime);
219   }
220 
221   /**
222    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
223    * @param _beneficiary Address performing the token purchase
224    * @param _tokenAmount Number of tokens to be emitted
225    */
226   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
227     token.transfer(_beneficiary, _tokenAmount);
228   }
229 
230   /**
231    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
232    * @param _beneficiary Address receiving the tokens
233    * @param _tokenAmount Number of tokens to be purchased
234    */
235   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
236     _deliverTokens(_beneficiary, _tokenAmount);
237   }
238 
239   /**
240    * @dev Override to extend the way in which ether is converted to tokens.
241    * @param _weiAmount Value in wei to be converted into tokens
242    * @return Number of tokens that can be purchased with the specified _weiAmount
243    */
244   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
245     return _weiAmount.div(10 ** 18).mul(rate);
246   }
247 
248   /**
249    * @dev Determines how ETH is stored/forwarded on purchases.
250    */
251   function _forwardFunds() internal {
252     wallet.transfer(msg.value);
253   }
254   
255   /**
256    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
257    * @return Whether crowdsale period has elapsed
258    */
259   function hasClosed() public view returns (bool) {
260     return now > closingTime;
261   }
262 
263   /**
264    * @dev called by the owner to withdraw unsold tokens
265    */
266   function withdrawTokens() public onlyOwner {
267     uint256 unsold = token.balanceOf(this);
268     token.transfer(owner, unsold);
269   }
270 
271 }