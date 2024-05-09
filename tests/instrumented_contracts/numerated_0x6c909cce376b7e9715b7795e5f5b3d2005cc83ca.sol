1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * See https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 
19 
20 /**
21  * @title SafeERC20
22  * @dev Wrappers around ERC20 operations that throw on failure.
23  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
24  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
25  */
26 library SafeERC20 {
27   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
28     require(token.transfer(to, value));
29   }
30 
31   function safeTransferFrom(
32     ERC20 token,
33     address from,
34     address to,
35     uint256 value
36   )
37     internal
38   {
39     require(token.transferFrom(from, to, value));
40   }
41 
42   function safeApprove(ERC20 token, address spender, uint256 value) internal {
43     require(token.approve(spender, value));
44   }
45 }
46 
47 
48 
49 
50 
51 
52 /**
53  * @title ERC20 interface
54  * @dev see https://github.com/ethereum/EIPs/issues/20
55  */
56 contract ERC20 is ERC20Basic {
57   function allowance(address owner, address spender)
58     public view returns (uint256);
59 
60   function transferFrom(address from, address to, uint256 value)
61     public returns (bool);
62 
63   function approve(address spender, uint256 value) public returns (bool);
64   event Approval(
65     address indexed owner,
66     address indexed spender,
67     uint256 value
68   );
69 }
70 
71 
72 
73 /**
74  * @title SafeMath
75  * @dev Math operations with safety checks that throw on error
76  */
77 library SafeMath {
78 
79   /**
80   * @dev Multiplies two numbers, throws on overflow.
81   */
82   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
83     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
84     // benefit is lost if 'b' is also tested.
85     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
86     if (a == 0) {
87       return 0;
88     }
89 
90     c = a * b;
91     assert(c / a == b);
92     return c;
93   }
94 
95   /**
96   * @dev Integer division of two numbers, truncating the quotient.
97   */
98   function div(uint256 a, uint256 b) internal pure returns (uint256) {
99     // assert(b > 0); // Solidity automatically throws when dividing by 0
100     // uint256 c = a / b;
101     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
102     return a / b;
103   }
104 
105   /**
106   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
107   */
108   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
109     assert(b <= a);
110     return a - b;
111   }
112 
113   /**
114   * @dev Adds two numbers, throws on overflow.
115   */
116   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
117     c = a + b;
118     assert(c >= a);
119     return c;
120   }
121 }
122 
123 
124 
125 /**
126  * @title Crowdsale
127  * @dev Crowdsale is a base contract for managing a token crowdsale,
128  * allowing investors to purchase tokens with ether. This contract implements
129  * such functionality in its most fundamental form and can be extended to provide additional
130  * functionality and/or custom behavior.
131  * The external interface represents the basic interface for purchasing tokens, and conform
132  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
133  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
134  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
135  * behavior.
136  */
137 contract Crowdsale {
138   using SafeMath for uint256;
139   using SafeERC20 for ERC20;
140 
141   // The token being sold
142   ERC20 public token;
143 
144   // Address where funds are collected
145   address public wallet;
146 
147   // How many token units a buyer gets per wei.
148   // The rate is the conversion between wei and the smallest and indivisible token unit.
149   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
150   // 1 wei will give you 1 unit, or 0.001 TOK.
151   // 14 decimals: 0.00000000000001
152   uint256 public rate;
153 
154   // Amount of tokens sold
155   uint256 public tokenSold;
156 
157   /**
158    * Event for token purchase logging
159    * @param purchaser who paid for the tokens
160    * @param beneficiary who got the tokens
161    * @param value weis paid for purchase
162    * @param amount amount of tokens purchased
163    */
164   event TokenPurchase(
165     address indexed purchaser,
166     address indexed beneficiary,
167     uint256 value,
168     uint256 amount
169   );
170 
171   /**
172    * @param _rate Number of token units a buyer gets per wei
173    * @param _wallet Address where collected funds will be forwarded to
174    * @param _token Address of the token being sold
175    */
176   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
177     require(_rate > 0);
178     require(_wallet != address(0));
179     require(_token != address(0));
180 
181     rate = _rate;
182     wallet = _wallet;
183     token = _token;
184   }
185 
186   // -----------------------------------------
187   // Crowdsale external interface
188   // -----------------------------------------
189 
190   /**
191    * @dev fallback function ***DO NOT OVERRIDE***
192    */
193   function () external payable {
194     buyTokens(msg.sender, "", "");
195   }
196   
197     function getReferrals(address referrer) public view returns (uint256){
198       return referraltokenamount[referrer];
199   }
200 
201   /**
202    * @dev low level token purchase ***DO NOT OVERRIDE***
203    * @param _beneficiary Address performing the token purchase
204    */
205    mapping(string => address) referrals;
206    mapping(address => uint256) referraltokenamount;
207   function buyTokens(address _beneficiary, string referralemail, string youremail) public payable {
208 
209     uint256 weiAmount = msg.value;
210     _preValidatePurchase(_beneficiary, weiAmount);
211 
212     // calculate token amount to be created
213     uint256 tokens = _getTokenAmount(weiAmount);
214 
215     // update state
216     tokenSold = tokenSold.add(tokens);
217     
218     if((bytes(referralemail).length != 0) && (referrals[referralemail] != 0)){
219         address referral = referrals[referralemail];
220         uint256 referraltokens = tokens.mul(5) / 100;
221         token.safeTransfer(referral, referraltokens);
222         referraltokenamount[referral] = referraltokenamount[referral] + tokens;
223         tokenSold = tokenSold.add(referraltokens);
224     }
225     
226     if((bytes(youremail).length != 0) && (referrals[youremail] == 0)){
227         referrals[youremail] = _beneficiary;
228     }
229     
230 
231     
232     _processPurchase(_beneficiary, tokens);
233     emit TokenPurchase(
234       msg.sender,
235       _beneficiary,
236       weiAmount,
237       tokens
238     );
239 
240     _updatePurchasingState(_beneficiary, weiAmount);
241 
242     _forwardFunds();
243     _postValidatePurchase(_beneficiary, weiAmount);
244   }
245 
246   // -----------------------------------------
247   // Internal interface (extensible)
248   // -----------------------------------------
249 
250   /**
251    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
252    * @param _beneficiary Address performing the token purchase
253    * @param _weiAmount Value in wei involved in the purchase
254    */
255   function _preValidatePurchase(
256     address _beneficiary,
257     uint256 _weiAmount
258   )
259     internal
260   {
261     require(_beneficiary != address(0));
262     require(_weiAmount != 0);
263   }
264 
265   /**
266    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
267    * @param _beneficiary Address performing the token purchase
268    * @param _weiAmount Value in wei involved in the purchase
269    */
270   function _postValidatePurchase(
271     address _beneficiary,
272     uint256 _weiAmount
273   )
274     internal
275   {
276     // optional override
277   }
278 
279   /**
280    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
281    * @param _beneficiary Address performing the token purchase
282    * @param _tokenAmount Number of tokens to be emitted
283    */
284   function _deliverTokens(
285     address _beneficiary,
286     uint256 _tokenAmount
287   )
288     internal
289   {
290     token.safeTransfer(_beneficiary, _tokenAmount);
291   }
292 
293   /**
294    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
295    * @param _beneficiary Address receiving the tokens
296    * @param _tokenAmount Number of tokens to be purchased
297    */
298   function _processPurchase(
299     address _beneficiary,
300     uint256 _tokenAmount
301   )
302     internal
303   {
304     _deliverTokens(_beneficiary, _tokenAmount);
305   }
306 
307   /**
308    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
309    * @param _beneficiary Address receiving the tokens
310    * @param _weiAmount Value in wei involved in the purchase
311    */
312   function _updatePurchasingState(
313     address _beneficiary,
314     uint256 _weiAmount
315   )
316     internal
317   {
318     // optional override
319   }
320 
321   /**
322    * @dev Override to extend the way in which ether is converted to tokens.
323    * @param _weiAmount Value in wei to be converted into tokens
324    * @return Number of tokens that can be purchased with the specified _weiAmount
325    */
326   function _getTokenAmount(uint256 _weiAmount)
327     internal view returns (uint256)
328   {
329     return _weiAmount.mul(rate) / 2;
330   }
331 
332   /**
333    * @dev Determines how ETH is stored/forwarded on purchases.
334    */
335   function _forwardFunds() internal {
336     wallet.transfer(msg.value);
337   }
338   
339 
340 }