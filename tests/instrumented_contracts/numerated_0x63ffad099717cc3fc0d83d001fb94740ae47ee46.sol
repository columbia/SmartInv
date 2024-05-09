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
51  * @title ERC20Basic
52  * @dev Simpler version of ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/179
54  */
55 contract ERC20Basic {
56   function totalSupply() public view returns (uint256);
57   function balanceOf(address who) public view returns (uint256);
58   function transfer(address to, uint256 value) public returns (bool);
59   event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 /**
63  * @title ERC20 interface
64  * @dev see https://github.com/ethereum/EIPs/issues/20
65  */
66 contract ERC20 is ERC20Basic {
67   function allowance(address owner, address spender)
68     public view returns (uint256);
69 
70   function transferFrom(address from, address to, uint256 value)
71     public returns (bool);
72 
73   function approve(address spender, uint256 value) public returns (bool);
74   event Approval(
75     address indexed owner,
76     address indexed spender,
77     uint256 value
78   );
79 }
80 
81 /**
82  * @title Crowdsale
83  * @dev Crowdsale is a base contract for managing a token crowdsale,
84  * allowing investors to purchase tokens with ether. This contract implements
85  * such functionality in its most fundamental form and can be extended to provide additional
86  * functionality and/or custom behavior.
87  * The external interface represents the basic interface for purchasing tokens, and conform
88  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
89  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
90  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
91  * behavior.
92  */
93 contract Crowdsale {
94   using SafeMath for uint256;
95 
96   // The token being sold
97   ERC20 public token;
98 
99   // Owner address
100   address public owner;
101 
102   // Address where funds are collected
103   address public wallet;
104 
105   // How many token units a buyer gets per wei
106   uint256 public rate;
107 
108   // Amount of wei raised
109   uint256 public weiRaised;
110 
111   modifier onlyOwner() { 
112     require (msg.sender == owner); 
113     _;
114   }
115   
116   /**
117    * Event for token purchase logging
118    * @param purchaser who paid for the tokens
119    * @param beneficiary who got the tokens
120    * @param value weis paid for purchase
121    * @param amount amount of tokens purchased
122    */
123   event TokenPurchase(
124     address indexed purchaser,
125     address indexed beneficiary,
126     uint256 value,
127     uint256 amount
128   );
129 
130   /**
131    * @param _rate Number of token units a buyer gets per wei
132    * @param _wallet Address where collected funds will be forwarded to
133    * @param _token Address of the token being sold
134    */
135   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
136     require(_rate > 0);
137     require(_wallet != address(0));
138     require(_token != address(0));
139 
140     owner = msg.sender;
141     rate = _rate;
142     wallet = _wallet;
143     token = _token;
144   }
145 
146   // -----------------------------------------
147   // Crowdsale external interface
148   // -----------------------------------------
149 
150   /**
151    * @dev fallback function ***DO NOT OVERRIDE***
152    */
153   function () external payable {
154     buyTokens(msg.sender);
155   }
156 
157   /**
158    * @dev low level token purchase ***DO NOT OVERRIDE***
159    * @param _beneficiary Address performing the token purchase
160    */
161   function buyTokens(address _beneficiary) public payable {
162 
163     uint256 weiAmount = msg.value;
164     _preValidatePurchase(_beneficiary, weiAmount);
165 
166     // calculate token amount to be created
167     uint256 tokens = _getTokenAmount(weiAmount);
168 
169     // update state
170     weiRaised = weiRaised.add(weiAmount);
171 
172     _processPurchase(_beneficiary, tokens);
173     emit TokenPurchase(
174       msg.sender,
175       _beneficiary,
176       weiAmount,
177       tokens
178     );
179 
180     _forwardFunds();
181 
182   }
183 
184   // -----------------------------------------
185   // owner only function
186   // -----------------------------------------
187    /**
188    * @dev owner transfer token to specific address, directly
189    * @param _beneficiary Address
190    * @param _tokenAmount to _beneficiary address
191    */
192   function ownerTokenTransfer(address _beneficiary, uint _tokenAmount) onlyOwner {
193     _deliverTokens(_beneficiary, _tokenAmount);
194   }
195 
196   /*
197    * @dev owner set owner
198    * @param new owner address
199    */ 
200   function ownerSetOwner(address _newOwner) onlyOwner {
201     owner = _newOwner;
202   }
203 
204   /*
205    * @dev owner set new wallet
206    * @param new wallet to collect funds
207    */ 
208   function ownerSetWallet(address _newWallet) onlyOwner {
209     wallet = _newWallet;
210   }
211 
212   /*
213    * @dev owner set new wallet
214    * @param new wallet to collect funds
215    */ 
216   function ownerSetRate(uint256 _newRate) onlyOwner {
217     rate = _newRate;
218   }
219 
220   /*
221    * @dev owner selfdestruct contract ***BE CAREFUL! EMERGENCY ONLY*** 
222    * before self destruct, execute ownerTokenTransfer() to GET TOKEN OUT.
223    */ 
224   function ownerSelfDestruct() onlyOwner {
225     selfdestruct(owner);
226   }
227 
228 
229 
230   // -----------------------------------------
231   // Internal interface (extensible)
232   // -----------------------------------------
233 
234   /**
235    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
236    * @param _beneficiary Address performing the token purchase
237    * @param _weiAmount Value in wei involved in the purchase
238    */
239   function _preValidatePurchase(
240     address _beneficiary,
241     uint256 _weiAmount
242   )
243     internal
244   {
245     require(_beneficiary != address(0));
246     require(_weiAmount != 0);
247   }
248 
249 
250   /**
251    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
252    * @param _beneficiary Address performing the token purchase
253    * @param _tokenAmount Number of tokens to be emitted
254    */
255   function _deliverTokens(
256     address _beneficiary,
257     uint256 _tokenAmount
258   )
259     internal
260   {
261     token.transfer(_beneficiary, _tokenAmount);
262   }
263 
264   /**
265    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
266    * @param _beneficiary Address receiving the tokens
267    * @param _tokenAmount Number of tokens to be purchased
268    */
269   function _processPurchase(
270     address _beneficiary,
271     uint256 _tokenAmount
272   )
273     internal
274   {
275     _deliverTokens(_beneficiary, _tokenAmount);
276   }
277 
278   /**
279    * @dev Override to extend the way in which ether is converted to tokens.
280    * @param _weiAmount Value in wei to be converted into tokens
281    * @return Number of tokens that can be purchased with the specified _weiAmount
282    */
283   function _getTokenAmount(uint256 _weiAmount)
284     internal view returns (uint256)
285   {
286     return _weiAmount.mul(rate);
287   }
288 
289   /**
290    * @dev Determines how ETH is stored/forwarded on purchases.
291    */
292   function _forwardFunds() internal {
293     wallet.transfer(msg.value);
294   }
295 }