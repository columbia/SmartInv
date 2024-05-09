1 pragma solidity ^0.4.23;
2 
3 
4 library SafeMath {
5 
6   /**
7   * @dev Multiplies two numbers, throws on overflow.
8   */
9   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
10     if (a == 0) {
11       return 0;
12     }
13     c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   /**
19   * @dev Integer division of two numbers, truncating the quotient.
20   */
21   function div(uint256 a, uint256 b) internal pure returns (uint256) {
22     // assert(b > 0); // Solidity automatically throws when dividing by 0
23     // uint256 c = a / b;
24     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25     return a / b;
26   }
27 
28   /**
29   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
30   */
31   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   /**
37   * @dev Adds two numbers, throws on overflow.
38   */
39   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
40     c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 }
45 
46 
47 contract ERC20Basic {
48   function totalSupply() public view returns (uint256);
49   function balanceOf(address who) public view returns (uint256);
50   function transfer(address to, uint256 value) public returns (bool);
51   event Transfer(address indexed from, address indexed to, uint256 value);
52 }
53 
54 contract ERC20 is ERC20Basic {
55   function allowance(address owner, address spender) public view returns (uint256);
56   function transferFrom(address from, address to, uint256 value) public returns (bool);
57   function approve(address spender, uint256 value) public returns (bool);
58   event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 
61 
62 contract Ownable {
63   address public owner;
64 
65 
66   event OwnershipRenounced(address indexed previousOwner);
67   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
68 
69 
70   /**
71    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
72    * account.
73    */
74   constructor() public {
75     owner = msg.sender;
76   }
77 
78   /**
79    * @dev Throws if called by any account other than the owner.
80    */
81   modifier onlyOwner() {
82     require(msg.sender == owner);
83     _;
84   }
85 
86   /**
87    * @dev Allows the current owner to transfer control of the contract to a newOwner.
88    * @param newOwner The address to transfer ownership to.
89    */
90   function transferOwnership(address newOwner) public onlyOwner {
91     require(newOwner != address(0));
92     emit OwnershipTransferred(owner, newOwner);
93     owner = newOwner;
94   }
95 
96   /**
97    * @dev Allows the current owner to relinquish control of the contract.
98    */
99   function renounceOwnership() public onlyOwner {
100     emit OwnershipRenounced(owner);
101     owner = address(0);
102   }
103 }
104 
105 contract Crowdsale is Ownable {
106   using SafeMath for uint256;
107 
108   // The token being sold
109   ERC20 public token;
110 
111   // Address where funds are collected
112   address public wallet;
113 
114   // How many token units a buyer gets per wei
115   uint256 public rate;
116 
117   // Amount of wei raised
118   uint256 public weiRaised;
119 
120   /**
121    * Event for token purchase logging
122    * @param purchaser who paid for the tokens
123    * @param beneficiary who got the tokens
124    * @param value weis paid for purchase
125    * @param amount amount of tokens purchased
126    */
127   event TokenPurchase(
128     address indexed purchaser,
129     address indexed beneficiary,
130     uint256 value,
131     uint256 amount
132   );
133 
134   /**
135    * @param _rate Number of token units a buyer gets per wei
136    * @param _wallet Address where collected funds will be forwarded to
137    * @param _token Address of the token being sold
138    */
139   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
140     require(_rate > 0);
141     require(_wallet != address(0));
142     require(_token != address(0));
143 
144     rate = _rate;
145     wallet = _wallet;
146     token = _token;
147   }
148 
149   // -----------------------------------------
150   // Crowdsale external interface
151   // -----------------------------------------
152 
153   /**
154    * @dev fallback function ***DO NOT OVERRIDE***
155    */
156   function () external payable {
157     buyTokens(msg.sender);
158   }
159 
160   /**
161    * @dev low level token purchase ***DO NOT OVERRIDE***
162    * @param _beneficiary Address performing the token purchase
163    */
164   function buyTokens(address _beneficiary) public payable {
165 
166     uint256 weiAmount = msg.value;
167     _preValidatePurchase(_beneficiary, weiAmount);
168 
169     // calculate token amount to be created
170     uint256 tokens = _getTokenAmount(weiAmount);
171 
172     // update state
173     weiRaised = weiRaised.add(weiAmount);
174 
175     _processPurchase(_beneficiary, tokens);
176     emit TokenPurchase(
177       msg.sender,
178       _beneficiary,
179       weiAmount,
180       tokens
181     );
182 
183     _updatePurchasingState(_beneficiary, weiAmount);
184 
185     _forwardFunds();
186     _postValidatePurchase(_beneficiary, weiAmount);
187   }
188 
189   // -----------------------------------------
190   // Internal interface (extensible)
191   // -----------------------------------------
192 
193   /**
194    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
195    * @param _beneficiary Address performing the token purchase
196    * @param _weiAmount Value in wei involved in the purchase
197    */
198   function _preValidatePurchase(
199     address _beneficiary,
200     uint256 _weiAmount
201   )
202     internal
203   {
204     require(_beneficiary != address(0));
205     require(_weiAmount != 0);
206   }
207 
208   /**
209    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
210    * @param _beneficiary Address performing the token purchase
211    * @param _weiAmount Value in wei involved in the purchase
212    */
213   function _postValidatePurchase(
214     address _beneficiary,
215     uint256 _weiAmount
216   )
217     internal
218   {
219     // optional override
220   }
221 
222   /**
223    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
224    * @param _beneficiary Address performing the token purchase
225    * @param _tokenAmount Number of tokens to be emitted
226    */
227   function _deliverTokens(
228     address _beneficiary,
229     uint256 _tokenAmount
230   )
231     internal
232   {
233     token.transfer(_beneficiary, _tokenAmount);
234   }
235 
236   /**
237    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
238    * @param _beneficiary Address receiving the tokens
239    * @param _tokenAmount Number of tokens to be purchased
240    */
241   function _processPurchase(
242     address _beneficiary,
243     uint256 _tokenAmount
244   )
245     internal
246   {
247     _deliverTokens(_beneficiary, _tokenAmount);
248   }
249 
250   /**
251    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
252    * @param _beneficiary Address receiving the tokens
253    * @param _weiAmount Value in wei involved in the purchase
254    */
255   function _updatePurchasingState(
256     address _beneficiary,
257     uint256 _weiAmount
258   )
259     internal
260   {
261     // optional override
262   }
263 
264   /**
265    * @dev Override to extend the way in which ether is converted to tokens.
266    * @param _weiAmount Value in wei to be converted into tokens
267    * @return Number of tokens that can be purchased with the specified _weiAmount
268    */
269   function _getTokenAmount(uint256 _weiAmount)
270     internal view returns (uint256)
271   {
272     return _weiAmount.mul(rate);
273   }
274 
275   /**
276    * @dev Determines how ETH is stored/forwarded on purchases.
277    */
278   function _forwardFunds() internal {
279     wallet.transfer(msg.value);
280   }
281 
282 
283   function destroy() onlyOwner public {
284     _deliverTokens(owner, token.balanceOf(this));
285     selfdestruct(owner);
286   }
287 
288   function destroyAndSend(address _recipient) onlyOwner public {
289     _deliverTokens(_recipient, token.balanceOf(this));
290     selfdestruct(_recipient);
291   }
292 }