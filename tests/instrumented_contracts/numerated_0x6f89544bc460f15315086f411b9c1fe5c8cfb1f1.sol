1 pragma solidity ^0.4.23;
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
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     if (a == 0) {
15       return 0;
16     }
17     c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return a / b;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44     c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 /**
51  * @title token
52  * @dev token function singnature
53  */
54 contract token { function transfer(address receiver, uint amount){ receiver; amount; } }
55 
56 /**
57  * @title Crowdsale
58  * @dev Crowdsale is a base contract for managing a token crowdsale,
59  * allowing investors to purchase tokens with ether. This contract implements
60  * such functionality in its most fundamental form and can be extended to provide additional
61  * functionality and/or custom behavior.
62  * The external interface represents the basic interface for purchasing tokens, and conform
63  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
64  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
65  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
66  * behavior.
67  */
68 contract Crowdsale {
69   using SafeMath for uint256;
70 
71   // The token being sold
72   token public vppToken;
73 
74   // Owner address
75   address public owner;
76 
77   // Address where funds are collected
78   address public wallet;
79 
80   // How many token units a buyer gets per wei
81   uint256 public rate;
82 
83   // Amount of wei raised
84   uint256 public weiRaised;
85 
86   modifier onlyOwner() { 
87     require (msg.sender == owner); 
88     _;
89   }
90   
91   /**
92    * Event for token purchase logging
93    * @param purchaser who paid for the tokens
94    * @param beneficiary who got the tokens
95    * @param value weis paid for purchase
96    * @param amount amount of tokens purchased
97    */
98   event TokenPurchase(
99     address indexed purchaser,
100     address indexed beneficiary,
101     uint256 value,
102     uint256 amount
103   );
104 
105   /**
106    * @param _rate Number of token units a buyer gets per wei
107    * @param _wallet Address where collected funds will be forwarded to
108    * @param _vppToken Address of the token being sold
109    */
110   constructor(uint256 _rate, address _wallet, token _vppToken) public {
111     require(_rate > 0);
112     require(_wallet != address(0));
113     require(_vppToken != address(0));
114 
115     owner = msg.sender;
116     rate = _rate;
117     wallet = _wallet;
118     vppToken = _vppToken;
119   }
120 
121   // -----------------------------------------
122   // Crowdsale external interface
123   // -----------------------------------------
124 
125   /**
126    * @dev fallback function ***DO NOT OVERRIDE***
127    */
128   function () external payable {
129     buyTokens(msg.sender);
130   }
131 
132   /**
133    * @dev low level token purchase ***DO NOT OVERRIDE***
134    * @param _beneficiary Address performing the token purchase
135    */
136   function buyTokens(address _beneficiary) public payable {
137 
138     uint256 weiAmount = msg.value;
139     _preValidatePurchase(_beneficiary, weiAmount);
140 
141     // calculate token amount to be created
142     uint256 tokens = _getTokenAmount(weiAmount);
143 
144     // update state
145     weiRaised = weiRaised.add(weiAmount);
146 
147     _processPurchase(_beneficiary, tokens);
148     emit TokenPurchase(
149       msg.sender,
150       _beneficiary,
151       weiAmount,
152       tokens
153     );
154 
155     _forwardFunds();
156 
157   }
158 
159   // -----------------------------------------
160   // owner only function
161   // -----------------------------------------
162    /**
163    * @dev owner transfer token to specific address, directly
164    * @param _beneficiary Address
165    * @param _tokenAmount to _beneficiary address
166    */
167   function ownerTokenTransfer(address _beneficiary, uint _tokenAmount) public onlyOwner {
168     _deliverTokens(_beneficiary, _tokenAmount);
169   }
170 
171   /*
172    * @dev owner set owner
173    * @param new owner address
174    */ 
175   function ownerSetOwner(address _newOwner) public onlyOwner {
176     owner = _newOwner;
177   }
178 
179   /*
180    * @dev owner set new wallet
181    * @param new wallet to collect funds
182    */ 
183   function ownerSetWallet(address _newWallet) public onlyOwner {
184     wallet = _newWallet;
185   }
186 
187   /*
188    * @dev owner set new wallet
189    * @param new wallet to collect funds
190    */ 
191   function ownerSetRate(uint256 _newRate) public onlyOwner {
192     rate = _newRate;
193   }
194 
195   /*
196    * @dev owner selfdestruct contract ***BE CAREFUL! EMERGENCY ONLY*** 
197    * before self destruct, execute ownerTokenTransfer() to GET TOKEN OUT.
198    */ 
199   function ownerSelfDestruct() public onlyOwner {
200     selfdestruct(owner);
201   }
202 
203 
204 
205   // -----------------------------------------
206   // Internal interface (extensible)
207   // -----------------------------------------
208 
209   /**
210    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
211    * @param _beneficiary Address performing the token purchase
212    * @param _weiAmount Value in wei involved in the purchase
213    */
214   function _preValidatePurchase(
215     address _beneficiary,
216     uint256 _weiAmount
217   )
218     internal pure
219   {
220     require(_beneficiary != address(0));
221     require(_weiAmount != 0);
222   }
223 
224 
225   /**
226    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
227    * @param _beneficiary Address performing the token purchase
228    * @param _tokenAmount Number of tokens to be emitted
229    */
230   function _deliverTokens(
231     address _beneficiary,
232     uint256 _tokenAmount
233   )
234     internal
235   {
236     vppToken.transfer(_beneficiary, _tokenAmount);
237   }
238 
239   /**
240    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
241    * @param _beneficiary Address receiving the tokens
242    * @param _tokenAmount Number of tokens to be purchased
243    */
244   function _processPurchase(
245     address _beneficiary,
246     uint256 _tokenAmount
247   )
248     internal
249   {
250     _deliverTokens(_beneficiary, _tokenAmount);
251   }
252 
253   /**
254    * @dev Override to extend the way in which ether is converted to tokens.
255    * @param _weiAmount Value in wei to be converted into tokens
256    * @return Number of tokens that can be purchased with the specified _weiAmount
257    */
258   function _getTokenAmount(uint256 _weiAmount)
259     internal view returns (uint256)
260   {
261     return _weiAmount.mul(rate);
262   }
263 
264   /**
265    * @dev Determines how ETH is stored/forwarded on purchases.
266    */
267   function _forwardFunds() internal {
268     wallet.transfer(msg.value);
269   }
270 }