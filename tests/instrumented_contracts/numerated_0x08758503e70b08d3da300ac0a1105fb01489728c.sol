1 library SafeMath {
2 
3   /**
4   * @dev Multiplies two numbers, throws on overflow.
5   */
6   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
7     if (a == 0) {
8       return 0;
9     }
10     c = a * b;
11     assert(c / a == b);
12     return c;
13   }
14 
15   /**
16   * @dev Integer division of two numbers, truncating the quotient.
17   */
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     // uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return a / b;
23   }
24 
25   /**
26   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
27   */
28   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   /**
34   * @dev Adds two numbers, throws on overflow.
35   */
36   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
37     c = a + b;
38     assert(c >= a);
39     return c;
40   }
41 }
42 
43 contract ERC20Basic {
44   function totalSupply() public view returns (uint256);
45   function balanceOf(address who) public view returns (uint256);
46   function transfer(address to, uint256 value) public returns (bool);
47   event Transfer(address indexed from, address indexed to, uint256 value);
48 }
49 
50 contract ERC20 is ERC20Basic {
51   function allowance(address owner, address spender) public view returns (uint256);
52   function transferFrom(address from, address to, uint256 value) public returns (bool);
53   function approve(address spender, uint256 value) public returns (bool);
54   event Approval(address indexed owner, address indexed spender, uint256 value);
55 }
56 
57 
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64 
65   /**
66    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
67    * account.
68    */
69   function Ownable() public {
70     owner = msg.sender;
71   }
72 
73   /**
74    * @dev Throws if called by any account other than the owner.
75    */
76   modifier onlyOwner() {
77     require(msg.sender == owner);
78     _;
79   }
80 
81   /**
82    * @dev Allows the current owner to transfer control of the contract to a newOwner.
83    * @param newOwner The address to transfer ownership to.
84    */
85   function transferOwnership(address newOwner) public onlyOwner {
86     require(newOwner != address(0));
87     emit OwnershipTransferred(owner, newOwner);
88     owner = newOwner;
89   }
90 
91 }
92 
93 contract Pausable is Ownable {
94   event Pause();
95   event Unpause();
96 
97   bool public paused = false;
98 
99 
100   /**
101    * @dev Modifier to make a function callable only when the contract is not paused.
102    */
103   modifier whenNotPaused() {
104     require(!paused);
105     _;
106   }
107 
108   /**
109    * @dev Modifier to make a function callable only when the contract is paused.
110    */
111   modifier whenPaused() {
112     require(paused);
113     _;
114   }
115 
116   /**
117    * @dev called by the owner to pause, triggers stopped state
118    */
119   function pause() onlyOwner whenNotPaused public {
120     paused = true;
121     emit Pause();
122   }
123 
124   /**
125    * @dev called by the owner to unpause, returns to normal state
126    */
127   function unpause() onlyOwner whenPaused public {
128     paused = false;
129     emit Unpause();
130   }
131 }
132 
133 contract Crowdsale {
134   using SafeMath for uint256;
135 
136   // The token being sold
137   ERC20 public token;
138 
139   // Address where funds are collected
140   address public wallet;
141 
142   // How many token units a buyer gets per wei
143   uint256 public rate;
144 
145   // Amount of wei raised
146   uint256 public weiRaised;
147 
148   /**
149    * Event for token purchase logging
150    * @param purchaser who paid for the tokens
151    * @param beneficiary who got the tokens
152    * @param value weis paid for purchase
153    * @param amount amount of tokens purchased
154    */
155   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
156 
157   /**
158    * @param _rate Number of token units a buyer gets per wei
159    * @param _wallet Address where collected funds will be forwarded to
160    * @param _token Address of the token being sold
161    */
162   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
163     require(_rate > 0);
164     require(_wallet != address(0));
165     require(_token != address(0));
166 
167     rate = _rate;
168     wallet = _wallet;
169     token = _token;
170   }
171 
172   // -----------------------------------------
173   // Crowdsale external interface
174   // -----------------------------------------
175 
176   /**
177    * @dev fallback function ***DO NOT OVERRIDE***
178    */
179   function () external payable {
180     buyTokens(msg.sender);
181   }
182 
183   /**
184    * @dev low level token purchase ***DO NOT OVERRIDE***
185    * @param _beneficiary Address performing the token purchase
186    */
187   function buyTokens(address _beneficiary) public payable {
188 
189     uint256 weiAmount = msg.value;
190     _preValidatePurchase(_beneficiary, weiAmount);
191 
192     // calculate token amount to be created
193     uint256 tokens = _getTokenAmount(weiAmount);
194 
195     // update state
196     weiRaised = weiRaised.add(weiAmount);
197 
198     _processPurchase(_beneficiary, tokens);
199     emit TokenPurchase(
200       msg.sender,
201       _beneficiary,
202       weiAmount,
203       tokens
204     );
205 
206     _updatePurchasingState(_beneficiary, weiAmount);
207 
208     _forwardFunds();
209     _postValidatePurchase(_beneficiary, weiAmount);
210   }
211 
212   // -----------------------------------------
213   // Internal interface (extensible)
214   // -----------------------------------------
215 
216   /**
217    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
218    * @param _beneficiary Address performing the token purchase
219    * @param _weiAmount Value in wei involved in the purchase
220    */
221   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
222     require(_beneficiary != address(0));
223     require(_weiAmount != 0);
224   }
225 
226   /**
227    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
228    * @param _beneficiary Address performing the token purchase
229    * @param _weiAmount Value in wei involved in the purchase
230    */
231   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
232     // optional override
233   }
234 
235   /**
236    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
237    * @param _beneficiary Address performing the token purchase
238    * @param _tokenAmount Number of tokens to be emitted
239    */
240   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
241     token.transfer(_beneficiary, _tokenAmount);
242   }
243 
244   /**
245    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
246    * @param _beneficiary Address receiving the tokens
247    * @param _tokenAmount Number of tokens to be purchased
248    */
249   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
250     _deliverTokens(_beneficiary, _tokenAmount);
251   }
252 
253   /**
254    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
255    * @param _beneficiary Address receiving the tokens
256    * @param _weiAmount Value in wei involved in the purchase
257    */
258   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
259     // optional override
260   }
261 
262   /**
263    * @dev Override to extend the way in which ether is converted to tokens.
264    * @param _weiAmount Value in wei to be converted into tokens
265    * @return Number of tokens that can be purchased with the specified _weiAmount
266    */
267   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
268     return _weiAmount.mul(rate);
269   }
270 
271   /**
272    * @dev Determines how ETH is stored/forwarded on purchases.
273    */
274   function _forwardFunds() internal {
275     wallet.transfer(msg.value);
276   }
277 }
278 
279 contract TSCoinSeller is Crowdsale, Pausable {
280     uint256 internal initialRate = 10000;
281     constructor(ERC20 _token) Crowdsale(initialRate, msg.sender, _token) public {}
282 
283     function buyTokens(address _beneficiary) public payable whenNotPaused {
284         super.buyTokens(_beneficiary);
285     }
286 
287     function changeRate(uint256 _newRate) public onlyOwner {
288         require(_newRate > 0);
289         rate = _newRate;
290     }
291 
292     function changeWallet(address _newWallet) public onlyOwner {
293         require(_newWallet != address(0));
294         wallet = _newWallet;
295     }
296 
297     function returnCoins(uint256 _value) public onlyOwner {
298         token.transfer(msg.sender,_value);
299     }
300 
301     function destroy() public onlyOwner {
302         returnCoins(token.balanceOf(this));
303         selfdestruct(owner);
304     }
305 }