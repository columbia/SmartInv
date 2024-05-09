1 library SafeMath {
2 
3   /**
4   * @dev Multiplies two numbers, throws on overflow.
5   */
6   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
7     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
8     // benefit is lost if 'b' is also tested.
9     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
10     if (a == 0) {
11       return 0;
12     }
13 
14     c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   /**
20   * @dev Integer division of two numbers, truncating the quotient.
21   */
22   function div(uint256 a, uint256 b) internal pure returns (uint256) {
23     // assert(b > 0); // Solidity automatically throws when dividing by 0
24     // uint256 c = a / b;
25     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26     return a / b;
27   }
28 
29   /**
30   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
31   */
32   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   /**
38   * @dev Adds two numbers, throws on overflow.
39   */
40   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
41     c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 contract ERC20Basic {
48   function totalSupply() public view returns (uint256);
49   function balanceOf(address who) public view returns (uint256);
50   function transfer(address to, uint256 value) public returns (bool);
51   event Transfer(address indexed from, address indexed to, uint256 value);
52 }
53 
54 contract ERC20 is ERC20Basic {
55   function allowance(address owner, address spender)
56     public view returns (uint256);
57 
58   function transferFrom(address from, address to, uint256 value)
59     public returns (bool);
60 
61   function approve(address spender, uint256 value) public returns (bool);
62   event Approval(
63     address indexed owner,
64     address indexed spender,
65     uint256 value
66   );
67 }
68 
69 contract Ownable {
70   address public owner;
71 
72 
73   event OwnershipRenounced(address indexed previousOwner);
74   event OwnershipTransferred(
75     address indexed previousOwner,
76     address indexed newOwner
77   );
78 
79 
80   /**
81    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
82    * account.
83    */
84   constructor() public {
85     owner = msg.sender;
86   }
87 
88   /**
89    * @dev Throws if called by any account other than the owner.
90    */
91   modifier onlyOwner() {
92     require(msg.sender == owner);
93     _;
94   }
95 
96   /**
97    * @dev Allows the current owner to relinquish control of the contract.
98    */
99   function renounceOwnership() public onlyOwner {
100     emit OwnershipRenounced(owner);
101     owner = address(0);
102   }
103 
104   /**
105    * @dev Allows the current owner to transfer control of the contract to a newOwner.
106    * @param _newOwner The address to transfer ownership to.
107    */
108   function transferOwnership(address _newOwner) public onlyOwner {
109     _transferOwnership(_newOwner);
110   }
111 
112   /**
113    * @dev Transfers control of the contract to a newOwner.
114    * @param _newOwner The address to transfer ownership to.
115    */
116   function _transferOwnership(address _newOwner) internal {
117     require(_newOwner != address(0));
118     emit OwnershipTransferred(owner, _newOwner);
119     owner = _newOwner;
120   }
121 }
122 
123 contract Pausable is Ownable {
124   event Pause();
125   event Unpause();
126 
127   bool public paused = false;
128 
129 
130   /**
131    * @dev Modifier to make a function callable only when the contract is not paused.
132    */
133   modifier whenNotPaused() {
134     require(!paused);
135     _;
136   }
137 
138   /**
139    * @dev Modifier to make a function callable only when the contract is paused.
140    */
141   modifier whenPaused() {
142     require(paused);
143     _;
144   }
145 
146   /**
147    * @dev called by the owner to pause, triggers stopped state
148    */
149   function pause() onlyOwner whenNotPaused public {
150     paused = true;
151     emit Pause();
152   }
153 
154   /**
155    * @dev called by the owner to unpause, returns to normal state
156    */
157   function unpause() onlyOwner whenPaused public {
158     paused = false;
159     emit Unpause();
160   }
161 }
162 
163 contract Crowdsale {
164   using SafeMath for uint256;
165 
166   // The token being sold
167   ERC20 public token;
168 
169   // Address where funds are collected
170   address public wallet;
171 
172   // How many token units a buyer gets per wei.
173   // The rate is the conversion between wei and the smallest and indivisible token unit.
174   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
175   // 1 wei will give you 1 unit, or 0.001 TOK.
176   uint256 public rate;
177 
178   // Amount of wei raised
179   uint256 public weiRaised;
180 
181   /**
182    * Event for token purchase logging
183    * @param purchaser who paid for the tokens
184    * @param beneficiary who got the tokens
185    * @param value weis paid for purchase
186    * @param amount amount of tokens purchased
187    */
188   event TokenPurchase(
189     address indexed purchaser,
190     address indexed beneficiary,
191     uint256 value,
192     uint256 amount
193   );
194 
195   /**
196    * @param _rate Number of token units a buyer gets per wei
197    * @param _wallet Address where collected funds will be forwarded to
198    * @param _token Address of the token being sold
199    */
200   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
201     require(_rate > 0);
202     require(_wallet != address(0));
203     require(_token != address(0));
204 
205     rate = _rate;
206     wallet = _wallet;
207     token = _token;
208   }
209 
210   // -----------------------------------------
211   // Crowdsale external interface
212   // -----------------------------------------
213 
214   /**
215    * @dev fallback function ***DO NOT OVERRIDE***
216    */
217   function () external payable {
218     buyTokens(msg.sender);
219   }
220 
221   /**
222    * @dev low level token purchase ***DO NOT OVERRIDE***
223    * @param _beneficiary Address performing the token purchase
224    */
225   function buyTokens(address _beneficiary) public payable {
226 
227     uint256 weiAmount = msg.value;
228     _preValidatePurchase(_beneficiary, weiAmount);
229 
230     // calculate token amount to be created
231     uint256 tokens = _getTokenAmount(weiAmount);
232 
233     // update state
234     weiRaised = weiRaised.add(weiAmount);
235 
236     _processPurchase(_beneficiary, tokens);
237     emit TokenPurchase(
238       msg.sender,
239       _beneficiary,
240       weiAmount,
241       tokens
242     );
243 
244     _updatePurchasingState(_beneficiary, weiAmount);
245 
246     _forwardFunds();
247     _postValidatePurchase(_beneficiary, weiAmount);
248   }
249 
250   // -----------------------------------------
251   // Internal interface (extensible)
252   // -----------------------------------------
253 
254   /**
255    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
256    * @param _beneficiary Address performing the token purchase
257    * @param _weiAmount Value in wei involved in the purchase
258    */
259   function _preValidatePurchase(
260     address _beneficiary,
261     uint256 _weiAmount
262   )
263     internal
264   {
265     require(_beneficiary != address(0));
266     require(_weiAmount != 0);
267   }
268 
269   /**
270    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
271    * @param _beneficiary Address performing the token purchase
272    * @param _weiAmount Value in wei involved in the purchase
273    */
274   function _postValidatePurchase(
275     address _beneficiary,
276     uint256 _weiAmount
277   )
278     internal
279   {
280     // optional override
281   }
282 
283   /**
284    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
285    * @param _beneficiary Address performing the token purchase
286    * @param _tokenAmount Number of tokens to be emitted
287    */
288   function _deliverTokens(
289     address _beneficiary,
290     uint256 _tokenAmount
291   )
292     internal
293   {
294     token.transfer(_beneficiary, _tokenAmount);
295   }
296 
297   /**
298    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
299    * @param _beneficiary Address receiving the tokens
300    * @param _tokenAmount Number of tokens to be purchased
301    */
302   function _processPurchase(
303     address _beneficiary,
304     uint256 _tokenAmount
305   )
306     internal
307   {
308     _deliverTokens(_beneficiary, _tokenAmount);
309   }
310 
311   /**
312    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
313    * @param _beneficiary Address receiving the tokens
314    * @param _weiAmount Value in wei involved in the purchase
315    */
316   function _updatePurchasingState(
317     address _beneficiary,
318     uint256 _weiAmount
319   )
320     internal
321   {
322     // optional override
323   }
324 
325   /**
326    * @dev Override to extend the way in which ether is converted to tokens.
327    * @param _weiAmount Value in wei to be converted into tokens
328    * @return Number of tokens that can be purchased with the specified _weiAmount
329    */
330   function _getTokenAmount(uint256 _weiAmount)
331     internal view returns (uint256)
332   {
333     return _weiAmount.mul(rate);
334   }
335 
336   /**
337    * @dev Determines how ETH is stored/forwarded on purchases.
338    */
339   function _forwardFunds() internal {
340     wallet.transfer(msg.value);
341   }
342 }
343 
344 contract PGCoinSeller is Crowdsale, Pausable {
345     uint256 internal initialRate = 10000;
346     constructor(ERC20 _token) public Crowdsale(initialRate, msg.sender, _token) {}
347 
348     function buyTokens(address _beneficiary) public payable whenNotPaused {
349         super.buyTokens(_beneficiary);
350     }
351 
352     function changeRate(uint256 _newRate) public onlyOwner {
353         require(_newRate > 0);
354         rate = _newRate;
355     }
356 
357     function changeWallet(address _newWallet) public onlyOwner {
358         require(_newWallet != address(0));
359         wallet = _newWallet;
360     }
361 
362     function returnCoins(uint256 _value) public onlyOwner {
363         token.transfer(msg.sender,_value);
364     }
365 
366     function destroy() public onlyOwner {
367         returnCoins(token.balanceOf(this));
368         selfdestruct(owner);
369     }
370 }