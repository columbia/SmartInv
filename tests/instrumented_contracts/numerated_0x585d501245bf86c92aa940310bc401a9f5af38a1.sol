1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10     function totalSupply() public view returns (uint256);
11     function balanceOf(address who) public view returns (uint256);
12     function transfer(address to, uint256 value) public returns (bool);
13     event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 /**
18  * @title ERC20 interface
19  * @dev see https://github.com/ethereum/EIPs/issues/20
20  */
21 contract ERC20 is ERC20Basic {
22     function allowance(address owner, address spender) public view returns (uint256);
23     function transferFrom(address from, address to, uint256 value) public returns (bool);
24     function approve(address spender, uint256 value) public returns (bool);
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 
29 /**
30  * @title SafeMath
31  * @dev Math operations with safety checks that throw on error
32  */
33 library SafeMath {
34 
35     /**
36     * @dev Multiplies two numbers, throws on overflow.
37     */
38     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
39         if (a == 0) {
40             return 0;
41         }
42         c = a * b;
43         assert(c / a == b);
44         return c;
45     }
46 
47     /**
48     * @dev Integer division of two numbers, truncating the quotient.
49     */
50     function div(uint256 a, uint256 b) internal pure returns (uint256) {
51         // assert(b > 0); // Solidity automatically throws when dividing by 0
52         // uint256 c = a / b;
53         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
54         return a / b;
55     }
56 
57     /**
58     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
59     */
60     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61         assert(b <= a);
62         return a - b;
63     }
64 
65     /**
66     * @dev Adds two numbers, throws on overflow.
67     */
68     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
69         c = a + b;
70         assert(c >= a);
71         return c;
72     }
73 }
74 
75 
76 /**
77  * @title Crowdsale
78  * @dev Crowdsale is a base contract for managing a token crowdsale,
79  * allowing investors to purchase tokens with ether. This contract implements
80  * such functionality in its most fundamental form and can be extended to provide additional
81  * functionality and/or custom behavior.
82  * The external interface represents the basic interface for purchasing tokens, and conform
83  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
84  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
85  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
86  * behavior.
87  */
88 contract Crowdsale {
89     using SafeMath for uint256;
90 
91     // The token being sold
92     ERC20 public token;
93 
94     // Address where funds are collected
95     address public wallet;
96 
97     // How many token units a buyer gets per wei
98     uint256 public rate;
99 
100     // Amount of wei raised
101     uint256 public weiRaised;
102 
103     /**
104      * Event for token purchase logging
105      * @param purchaser who paid for the tokens
106      * @param beneficiary who got the tokens
107      * @param value weis paid for purchase
108      * @param amount amount of tokens purchased
109      */
110     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
111 
112     /**
113      * @param _rate Number of token units a buyer gets per wei
114      * @param _wallet Address where collected funds will be forwarded to
115      * @param _token Address of the token being sold
116      */
117     function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
118         require(_rate > 0);
119         require(_wallet != address(0));
120         require(_token != address(0));
121 
122         rate = _rate;
123         wallet = _wallet;
124         token = _token;
125     }
126 
127     // -----------------------------------------
128     // Crowdsale external interface
129     // -----------------------------------------
130 
131     /**
132      * @dev fallback function ***DO NOT OVERRIDE***
133      */
134     function () external payable {
135         buyTokens(msg.sender);
136     }
137 
138     /**
139      * @dev low level token purchase ***DO NOT OVERRIDE***
140      * @param _beneficiary Address performing the token purchase
141      */
142     function buyTokens(address _beneficiary) public payable {
143 
144         uint256 weiAmount = msg.value;
145         _preValidatePurchase(_beneficiary, weiAmount);
146 
147         // calculate token amount to be created
148         uint256 tokens = 0;
149 
150         // update state
151         weiRaised = weiRaised.add(weiAmount);
152 
153         _processPurchase(_beneficiary, tokens);
154         emit TokenPurchase(
155         msg.sender,
156         _beneficiary,
157         weiAmount,
158         tokens
159         );
160 
161         _updatePurchasingState(_beneficiary, weiAmount);
162 
163         _forwardFunds();
164         _postValidatePurchase(_beneficiary, weiAmount);
165     }
166 
167     // -----------------------------------------
168     // Internal interface (extensible)
169     // -----------------------------------------
170 
171     /**
172      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
173      * @param _beneficiary Address performing the token purchase
174      * @param _weiAmount Value in wei involved in the purchase
175      */
176     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
177         require(_beneficiary != address(0));
178         require(_weiAmount != 0);
179     }
180 
181     /**
182      * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
183      * @param _beneficiary Address performing the token purchase
184      * @param _weiAmount Value in wei involved in the purchase
185      */
186     function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
187         // optional override
188     }
189 
190     /**
191      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
192      * @param _beneficiary Address performing the token purchase
193      * @param _tokenAmount Number of tokens to be emitted
194      */
195     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
196         token.transfer(_beneficiary, _tokenAmount);
197     }
198 
199     /**
200      * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
201      * @param _beneficiary Address receiving the tokens
202      * @param _tokenAmount Number of tokens to be purchased
203      */
204     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
205         _deliverTokens(_beneficiary, _tokenAmount);
206     }
207 
208     /**
209      * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
210      * @param _beneficiary Address receiving the tokens
211      * @param _weiAmount Value in wei involved in the purchase
212      */
213     function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
214         // optional override
215     }
216 
217     /**
218      * @dev Override to extend the way in which ether is converted to tokens.
219      * @param _weiAmount Value in wei to be converted into tokens
220      * @return Number of tokens that can be purchased with the specified _weiAmount
221      */
222     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
223         return _weiAmount.mul(rate);
224     }
225 
226     /**
227      * @dev Determines how ETH is stored/forwarded on purchases.
228      */
229     function _forwardFunds() internal {
230         wallet.transfer(msg.value);
231     }
232 }
233 
234 
235 /**
236  * @title Ownable
237  * @dev The Ownable contract has an owner address, and provides basic authorization control
238  * functions, this simplifies the implementation of "user permissions".
239  */
240 contract Ownable {
241     address public owner;
242 
243 
244     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
245 
246 
247     /**
248      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
249      * account.
250      */
251     function Ownable() public {
252         owner = msg.sender;
253     }
254 
255     /**
256      * @dev Throws if called by any account other than the owner.
257      */
258     modifier onlyOwner() {
259         require(msg.sender == owner);
260         _;
261     }
262 
263     /**
264      * @dev Allows the current owner to transfer control of the contract to a newOwner.
265      * @param newOwner The address to transfer ownership to.
266      */
267     function transferOwnership(address newOwner) public onlyOwner {
268         require(newOwner != address(0));
269         emit OwnershipTransferred(owner, newOwner);
270         owner = newOwner;
271     }
272 
273 }
274 
275 
276 /**
277  * @title HexanCoinCrowdsale
278  * @dev Crowdsale that locks tokens from withdrawal until it ends.
279  */
280 contract HexanCoinCrowdsale is Crowdsale, Ownable {
281     using SafeMath for uint256;
282 
283     // Map of all purchaiser's balances (doesn't include bounty amounts)
284     mapping(address => uint256) public balances;
285 
286     // Amount of issued tokens
287     uint256 public tokensIssued;
288 
289     // Bonus tokens rate multiplier x1000 (i.e. 1200 is 1.2 x 1000 = 120% x1000 = +20% bonus)
290     uint256 public bonusMultiplier;
291 
292     // Is a crowdsale closed?
293     bool public closed;
294 
295     /**
296      * Event for token withdrawal logging
297      * @param receiver who receive the tokens
298      * @param amount amount of tokens sent
299      */
300     event TokenDelivered(address indexed receiver, uint256 amount);
301 
302     /**
303    * Event for token adding by referral program
304    * @param beneficiary who got the tokens
305    * @param amount amount of tokens added
306    */
307     event TokenAdded(address indexed beneficiary, uint256 amount);
308 
309     /**
310     * Init crowdsale by setting its params
311     *
312     * @param _rate Number of token units a buyer gets per wei
313     * @param _wallet Address where collected funds will be forwarded to
314     * @param _token Address of the token being sold
315     * @param _bonusMultiplier bonus tokens rate multiplier x1000
316     */
317     function HexanCoinCrowdsale(
318         uint256 _rate,
319         address _wallet,
320         ERC20 _token,
321         uint256 _bonusMultiplier
322     ) Crowdsale(
323         _rate,
324         _wallet,
325         _token
326     ) {
327         bonusMultiplier = _bonusMultiplier;
328     }
329 
330     /**
331      * @dev Withdraw tokens only after crowdsale ends.
332      */
333     function withdrawTokens() public {
334         _withdrawTokensFor(msg.sender);
335     }
336 
337     /**
338      * @dev Overrides parent by storing balances instead of issuing tokens right away.
339      * @param _beneficiary Token purchaser
340      * @param _tokenAmount Amount of tokens purchased
341      */
342     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
343         require(!hasClosed());
344         balances[_beneficiary] = balances[_beneficiary].add(_tokenAmount);
345         tokensIssued = tokensIssued.add(_tokenAmount);
346     }
347 
348     /**
349    * @dev Overrides the way in which ether is converted to tokens.
350    * @param _weiAmount Value in wei to be converted into tokens
351    * @return Number of tokens that can be purchased with the specified _weiAmount
352    */
353     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
354         return _weiAmount.mul(rate).mul(bonusMultiplier).div(1000);
355     }
356 
357     /**
358      * @dev Deliver tokens to receiver_ after crowdsale ends.
359      */
360     function withdrawTokensFor(address receiver_) public onlyOwner {
361         _withdrawTokensFor(receiver_);
362     }
363 
364     /**
365      * @dev Checks whether the period in which the crowdsale is open has already elapsed.
366      * @return Whether crowdsale period has elapsed
367      */
368     function hasClosed() public view returns (bool) {
369         return closed;
370     }
371 
372     /**
373      * @dev Closes the period in which the crowdsale is open.
374      */
375     function closeCrowdsale(bool closed_) public onlyOwner {
376         closed = closed_;
377     }
378 
379     /**
380      * @dev set the bonus multiplier.
381      */
382     function setBonusMultiplier(uint256 bonusMultiplier_) public onlyOwner {
383         bonusMultiplier = bonusMultiplier_;
384     }
385 
386     /**
387      * @dev Withdraw tokens excess on the contract after crowdsale.
388      */
389     function postCrowdsaleWithdraw(uint256 _tokenAmount) public onlyOwner {
390         token.transfer(wallet, _tokenAmount);
391     }
392 
393     /**
394      * @dev Add tokens for specified beneficiary (referral system tokens, for example).
395      * @param _beneficiary Token purchaser
396      * @param _tokenAmount Amount of tokens added
397      */
398     function addTokens(address _beneficiary, uint256 _tokenAmount) public onlyOwner {
399         balances[_beneficiary] = balances[_beneficiary].add(_tokenAmount);
400         tokensIssued = tokensIssued.add(_tokenAmount);
401         emit TokenAdded(_beneficiary, _tokenAmount);
402     }
403 
404     /**
405      * @dev Withdraw tokens for receiver_ after crowdsale ends.
406      */
407     function _withdrawTokensFor(address receiver_) internal {
408         require(hasClosed());
409         uint256 amount = balances[receiver_];
410         require(amount > 0);
411         balances[receiver_] = 0;
412         emit TokenDelivered(receiver_, amount);
413         _deliverTokens(receiver_, amount);
414     }
415 }