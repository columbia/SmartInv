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
69     TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
70 
71     _updatePurchasingState(_beneficiary, weiAmount);
72 
73     _forwardFunds();
74     _postValidatePurchase(_beneficiary, weiAmount);
75   }
76 
77   // -----------------------------------------
78   // Internal interface (extensible)
79   // -----------------------------------------
80 
81   /**
82    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
83    * @param _beneficiary Address performing the token purchase
84    * @param _weiAmount Value in wei involved in the purchase
85    */
86   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
87     require(_beneficiary != address(0));
88     require(_weiAmount != 0);
89   }
90 
91   /**
92    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
93    * @param _beneficiary Address performing the token purchase
94    * @param _weiAmount Value in wei involved in the purchase
95    */
96   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
97     // optional override
98   }
99 
100   /**
101    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
102    * @param _beneficiary Address performing the token purchase
103    * @param _tokenAmount Number of tokens to be emitted
104    */
105   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
106     token.transfer(_beneficiary, _tokenAmount);
107   }
108 
109   /**
110    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
111    * @param _beneficiary Address receiving the tokens
112    * @param _tokenAmount Number of tokens to be purchased
113    */
114   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
115     _deliverTokens(_beneficiary, _tokenAmount);
116   }
117 
118   /**
119    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
120    * @param _beneficiary Address receiving the tokens
121    * @param _weiAmount Value in wei involved in the purchase
122    */
123   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
124     // optional override
125   }
126 
127   /**
128    * @dev Override to extend the way in which ether is converted to tokens.
129    * @param _weiAmount Value in wei to be converted into tokens
130    * @return Number of tokens that can be purchased with the specified _weiAmount
131    */
132   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
133     return _weiAmount.mul(rate);
134   }
135 
136   /**
137    * @dev Determines how ETH is stored/forwarded on purchases.
138    */
139   function _forwardFunds() internal {
140     wallet.transfer(msg.value);
141   }
142 }
143 
144 contract AllowanceCrowdsale is Crowdsale {
145   using SafeMath for uint256;
146 
147   address public tokenWallet;
148 
149   /**
150    * @dev Constructor, takes token wallet address. 
151    * @param _tokenWallet Address holding the tokens, which has approved allowance to the crowdsale
152    */
153   function AllowanceCrowdsale(address _tokenWallet) public {
154     require(_tokenWallet != address(0));
155     tokenWallet = _tokenWallet;
156   }
157 
158   /**
159    * @dev Checks the amount of tokens left in the allowance.
160    * @return Amount of tokens left in the allowance
161    */
162   function remainingTokens() public view returns (uint256) {
163     return token.allowance(tokenWallet, this);
164   }
165 
166   /**
167    * @dev Overrides parent behavior by transferring tokens from wallet.
168    * @param _beneficiary Token purchaser
169    * @param _tokenAmount Amount of tokens purchased
170    */
171   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
172     token.transferFrom(tokenWallet, _beneficiary, _tokenAmount);
173   }
174 }
175 
176 library SafeMath {
177 
178   /**
179   * @dev Multiplies two numbers, throws on overflow.
180   */
181   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
182     if (a == 0) {
183       return 0;
184     }
185     uint256 c = a * b;
186     assert(c / a == b);
187     return c;
188   }
189 
190   /**
191   * @dev Integer division of two numbers, truncating the quotient.
192   */
193   function div(uint256 a, uint256 b) internal pure returns (uint256) {
194     // assert(b > 0); // Solidity automatically throws when dividing by 0
195     uint256 c = a / b;
196     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
197     return c;
198   }
199 
200   /**
201   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
202   */
203   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
204     assert(b <= a);
205     return a - b;
206   }
207 
208   /**
209   * @dev Adds two numbers, throws on overflow.
210   */
211   function add(uint256 a, uint256 b) internal pure returns (uint256) {
212     uint256 c = a + b;
213     assert(c >= a);
214     return c;
215   }
216 }
217 
218 contract Ownable {
219   address public owner;
220 
221 
222   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
223 
224 
225   /**
226    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
227    * account.
228    */
229   function Ownable() public {
230     owner = msg.sender;
231   }
232 
233   /**
234    * @dev Throws if called by any account other than the owner.
235    */
236   modifier onlyOwner() {
237     require(msg.sender == owner);
238     _;
239   }
240 
241   /**
242    * @dev Allows the current owner to transfer control of the contract to a newOwner.
243    * @param newOwner The address to transfer ownership to.
244    */
245   function transferOwnership(address newOwner) public onlyOwner {
246     require(newOwner != address(0));
247     OwnershipTransferred(owner, newOwner);
248     owner = newOwner;
249   }
250 
251 }
252 
253 contract ERC20Basic {
254   function totalSupply() public view returns (uint256);
255   function balanceOf(address who) public view returns (uint256);
256   function transfer(address to, uint256 value) public returns (bool);
257   event Transfer(address indexed from, address indexed to, uint256 value);
258 }
259 
260 contract ERC20 is ERC20Basic {
261   function allowance(address owner, address spender) public view returns (uint256);
262   function transferFrom(address from, address to, uint256 value) public returns (bool);
263   function approve(address spender, uint256 value) public returns (bool);
264   event Approval(address indexed owner, address indexed spender, uint256 value);
265 }
266 
267 contract TVCrowdsale is AllowanceCrowdsale, Ownable {
268   uint256 public currentRate;
269   
270   function TVCrowdsale(uint256 _rate, address _wallet, ERC20 _token, address _tokenWallet)
271     Crowdsale(_rate, _wallet, _token)
272     AllowanceCrowdsale(_tokenWallet) public {
273     currentRate = _rate;
274   }
275   
276   function setRate(uint256 _rate) public onlyOwner returns (bool) {
277     currentRate = _rate;
278     return true;
279   }
280   
281   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
282     return _weiAmount.mul(currentRate);
283   }
284 
285 }