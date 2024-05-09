1 pragma solidity ^0.4.13;
2 
3 contract Crowdsale {
4   using SafeMath for uint256;
5 
6   // The token being sold
7   ERC20 public token;
8 
9   // Address where funds are collected
10   address public wallet;
11 
12   // How many token units a buyer gets per wei
13   uint256 public rate;
14 
15   // Amount of wei raised
16   uint256 public weiRaised;
17 
18   /**
19    * Event for token purchase logging
20    * @param purchaser who paid for the tokens
21    * @param beneficiary who got the tokens
22    * @param value weis paid for purchase
23    * @param amount amount of tokens purchased
24    */
25   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
26 
27   /**
28    * @param _rate Number of token units a buyer gets per wei
29    * @param _wallet Address where collected funds will be forwarded to
30    * @param _token Address of the token being sold
31    */
32   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
33     require(_rate > 0);
34     require(_wallet != address(0));
35     require(_token != address(0));
36 
37     rate = _rate;
38     wallet = _wallet;
39     token = _token;
40   }
41 
42   // -----------------------------------------
43   // Crowdsale external interface
44   // -----------------------------------------
45 
46   /**
47    * @dev fallback function ***DO NOT OVERRIDE***
48    */
49   function () external payable {
50     buyTokens(msg.sender);
51   }
52 
53   /**
54    * @dev low level token purchase ***DO NOT OVERRIDE***
55    * @param _beneficiary Address performing the token purchase
56    */
57   function buyTokens(address _beneficiary) public payable {
58 
59     uint256 weiAmount = msg.value;
60     _preValidatePurchase(_beneficiary, weiAmount);
61 
62     // calculate token amount to be created
63     uint256 tokens = _getTokenAmount(weiAmount);
64 
65     // update state
66     weiRaised = weiRaised.add(weiAmount);
67 
68     _processPurchase(_beneficiary, tokens);
69     emit TokenPurchase(
70       msg.sender,
71       _beneficiary,
72       weiAmount,
73       tokens
74     );
75 
76     _updatePurchasingState(_beneficiary, weiAmount);
77 
78     _forwardFunds();
79     _postValidatePurchase(_beneficiary, weiAmount);
80   }
81 
82   // -----------------------------------------
83   // Internal interface (extensible)
84   // -----------------------------------------
85 
86   /**
87    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
88    * @param _beneficiary Address performing the token purchase
89    * @param _weiAmount Value in wei involved in the purchase
90    */
91   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
92     require(_beneficiary != address(0));
93     require(_weiAmount != 0);
94   }
95 
96   /**
97    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
98    * @param _beneficiary Address performing the token purchase
99    * @param _weiAmount Value in wei involved in the purchase
100    */
101   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
102     // optional override
103   }
104 
105   /**
106    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
107    * @param _beneficiary Address performing the token purchase
108    * @param _tokenAmount Number of tokens to be emitted
109    */
110   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
111     token.transfer(_beneficiary, _tokenAmount);
112   }
113 
114   /**
115    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
116    * @param _beneficiary Address receiving the tokens
117    * @param _tokenAmount Number of tokens to be purchased
118    */
119   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
120     _deliverTokens(_beneficiary, _tokenAmount);
121   }
122 
123   /**
124    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
125    * @param _beneficiary Address receiving the tokens
126    * @param _weiAmount Value in wei involved in the purchase
127    */
128   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
129     // optional override
130   }
131 
132   /**
133    * @dev Override to extend the way in which ether is converted to tokens.
134    * @param _weiAmount Value in wei to be converted into tokens
135    * @return Number of tokens that can be purchased with the specified _weiAmount
136    */
137   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
138     return _weiAmount.mul(rate);
139   }
140 
141   /**
142    * @dev Determines how ETH is stored/forwarded on purchases.
143    */
144   function _forwardFunds() internal {
145     wallet.transfer(msg.value);
146   }
147 }
148 
149 contract AllowanceCrowdsale is Crowdsale {
150   using SafeMath for uint256;
151 
152   address public tokenWallet;
153 
154   /**
155    * @dev Constructor, takes token wallet address. 
156    * @param _tokenWallet Address holding the tokens, which has approved allowance to the crowdsale
157    */
158   function AllowanceCrowdsale(address _tokenWallet) public {
159     require(_tokenWallet != address(0));
160     tokenWallet = _tokenWallet;
161   }
162 
163   /**
164    * @dev Checks the amount of tokens left in the allowance.
165    * @return Amount of tokens left in the allowance
166    */
167   function remainingTokens() public view returns (uint256) {
168     return token.allowance(tokenWallet, this);
169   }
170 
171   /**
172    * @dev Overrides parent behavior by transferring tokens from wallet.
173    * @param _beneficiary Token purchaser
174    * @param _tokenAmount Amount of tokens purchased
175    */
176   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
177     token.transferFrom(tokenWallet, _beneficiary, _tokenAmount);
178   }
179 }
180 
181 library SafeMath {
182 
183   /**
184   * @dev Multiplies two numbers, throws on overflow.
185   */
186   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
187     if (a == 0) {
188       return 0;
189     }
190     c = a * b;
191     assert(c / a == b);
192     return c;
193   }
194 
195   /**
196   * @dev Integer division of two numbers, truncating the quotient.
197   */
198   function div(uint256 a, uint256 b) internal pure returns (uint256) {
199     // assert(b > 0); // Solidity automatically throws when dividing by 0
200     // uint256 c = a / b;
201     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
202     return a / b;
203   }
204 
205   /**
206   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
207   */
208   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
209     assert(b <= a);
210     return a - b;
211   }
212 
213   /**
214   * @dev Adds two numbers, throws on overflow.
215   */
216   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
217     c = a + b;
218     assert(c >= a);
219     return c;
220   }
221 }
222 
223 contract Ownable {
224   address public owner;
225 
226 
227   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
228 
229 
230   /**
231    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
232    * account.
233    */
234   function Ownable() public {
235     owner = msg.sender;
236   }
237 
238   /**
239    * @dev Throws if called by any account other than the owner.
240    */
241   modifier onlyOwner() {
242     require(msg.sender == owner);
243     _;
244   }
245 
246   /**
247    * @dev Allows the current owner to transfer control of the contract to a newOwner.
248    * @param newOwner The address to transfer ownership to.
249    */
250   function transferOwnership(address newOwner) public onlyOwner {
251     require(newOwner != address(0));
252     emit OwnershipTransferred(owner, newOwner);
253     owner = newOwner;
254   }
255 
256 }
257 
258 contract ERC20Basic {
259   function totalSupply() public view returns (uint256);
260   function balanceOf(address who) public view returns (uint256);
261   function transfer(address to, uint256 value) public returns (bool);
262   event Transfer(address indexed from, address indexed to, uint256 value);
263 }
264 
265 contract ERC20 is ERC20Basic {
266   function allowance(address owner, address spender) public view returns (uint256);
267   function transferFrom(address from, address to, uint256 value) public returns (bool);
268   function approve(address spender, uint256 value) public returns (bool);
269   event Approval(address indexed owner, address indexed spender, uint256 value);
270 }
271 
272 contract TVCrowdsale is AllowanceCrowdsale, Ownable {
273   uint256 public currentRate;
274   
275   function TVCrowdsale(uint256 _rate, address _wallet, ERC20 _token, address _tokenWallet)
276     Crowdsale(_rate, _wallet, _token)
277     AllowanceCrowdsale(_tokenWallet) public {
278     currentRate = _rate;
279   }
280   
281   function setRate(uint256 _rate) public onlyOwner returns (bool) {
282     currentRate = _rate;
283     return true;
284   }
285   
286   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
287     return _weiAmount.mul(currentRate);
288   }
289 
290 }