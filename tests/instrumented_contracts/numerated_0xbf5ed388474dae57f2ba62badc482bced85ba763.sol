1 pragma solidity 0.5.4;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19 
20         c = a * b;
21         assert(c / a == b);
22         return c;
23     }
24 
25     /**
26     * @dev Integer division of two numbers, truncating the quotient.
27     */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // assert(b > 0); // Solidity automatically throws when dividing by 0
30         // uint256 c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32         return a / b;
33     }
34 
35     /**
36     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37     */
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         assert(b <= a);
40         return a - b;
41     }
42 
43     /**
44     * @dev Adds two numbers, throws on overflow.
45     */
46     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47         c = a + b;
48         assert(c >= a);
49         return c;
50     }
51 }
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59     address public owner;
60 
61 
62     event OwnershipRenounced(address indexed previousOwner);
63     event OwnershipTransferred(
64         address indexed previousOwner,
65         address indexed newOwner
66     );
67 
68 
69     /**
70      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
71      * account.
72      */
73     constructor() public {
74         owner = msg.sender;
75     }
76 
77     /**
78      * @dev Throws if called by any account other than the owner.
79      */
80     modifier onlyOwner() {
81         require(msg.sender == owner);
82         _;
83     }
84 
85     /**
86      * @dev Allows the current owner to relinquish control of the contract.
87      * @notice Renouncing to ownership will leave the contract without an owner.
88      * It will not be possible to call the functions with the `onlyOwner`
89      * modifier anymore.
90      */
91     function renounceOwnership() public onlyOwner {
92         emit OwnershipRenounced(owner);
93         owner = address(0);
94     }
95 
96     /**
97      * @dev Allows the current owner to transfer control of the contract to a newOwner.
98      * @param _newOwner The address to transfer ownership to.
99      */
100     function transferOwnership(address _newOwner) public onlyOwner {
101         _transferOwnership(_newOwner);
102     }
103 
104     /**
105      * @dev Transfers control of the contract to a newOwner.
106      * @param _newOwner The address to transfer ownership to.
107      */
108     function _transferOwnership(address _newOwner) internal {
109         require(_newOwner != address(0));
110         emit OwnershipTransferred(owner, _newOwner);
111         owner = _newOwner;
112     }
113 }
114 
115 
116 /**
117  * @title ERC20 interface
118  * @dev see https://github.com/ethereum/EIPs/issues/20
119  */
120 contract ERC20  {
121     function allowance(address owner, address spender)
122     public view returns (uint256);
123 
124     function transferFrom(address from, address to, uint256 value)
125     public returns (bool);
126 
127     function approve(address spender, uint256 value) public returns (bool);
128     event Approval(
129         address indexed owner,
130         address indexed spender,
131         uint256 value
132     );
133 
134     function totalSupply() public view returns (uint256);
135     function balanceOf(address who) public view returns (uint256);
136     function transfer(address to, uint256 value) public returns (bool);
137     event Transfer(address indexed from, address indexed to, uint256 value);
138 }
139 
140 
141 /**
142  * @title SafeERC20
143  * @dev Wrappers around ERC20 operations that throw on failure.
144  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
145  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
146  */
147 library SafeERC20 {
148     function safeTransfer(ERC20 token, address to, uint256 value) internal {
149         require(token.transfer(to, value));
150     }
151 
152     function safeTransferFrom(
153         ERC20 token,
154         address from,
155         address to,
156         uint256 value
157     )
158     internal
159     {
160         require(token.transferFrom(from, to, value));
161     }
162 
163     function safeApprove(ERC20 token, address spender, uint256 value) internal {
164         require(token.approve(spender, value));
165     }
166 }
167 
168 
169 /**
170  * @title Crowdsale
171  * @dev Crowdsale is a base contract for managing a token crowdsale,
172  * allowing investors to purchase tokens with ether. This contract implements
173  * such functionality in its most fundamental form and can be extended to provide additional
174  * functionality and/or custom behavior.
175  * The external interface represents the basic interface for purchasing tokens, and conform
176  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
177  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
178  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
179  * behavior.
180  */
181 contract Crowdsale is Ownable {
182     using SafeMath for uint256;
183     using SafeERC20 for ERC20;
184 
185 
186     // The token being sold
187     ERC20 public token;
188 
189     // Address where funds are collected
190     address payable public wallet;
191 
192     // Amount of wei raised
193     uint256 public weiRaised;
194     uint256 public tokensSold;
195 
196     uint256 public cap = 30000000 ether; //cap in tokens
197 
198     mapping (uint => uint) prices;
199     mapping (address => address) referrals;
200 
201     /**
202      * Event for token purchase logging
203      * @param purchaser who paid for the tokens
204      * @param beneficiary who got the tokens
205      * @param value weis paid for purchase
206      * @param amount amount of tokens purchased
207      */
208     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
209     event Finalized();
210     /**
211      * @dev Reverts if not in crowdsale time range.
212      */
213 
214     constructor(address payable _wallet, address _token) public {
215         require(_wallet != address(0));
216         require(_token != address(0));
217 
218         wallet = _wallet;
219         token = ERC20(_token);
220 
221         prices[1] = 75000000000000000;
222         prices[2] = 105000000000000000;
223         prices[3] = 120000000000000000;
224         prices[4] = 135000000000000000;
225 
226     }
227 
228     // -----------------------------------------
229     // Crowdsale external interface
230     // -----------------------------------------
231 
232     /**
233      * @dev fallback function ***DO NOT OVERRIDE***
234      */
235     function () external payable {
236         buyTokens(msg.sender, bytesToAddress(msg.data));
237     }
238 
239     /**
240      * @dev low level token purchase ***DO NOT OVERRIDE***
241      * @param _beneficiary Address performing the token purchase
242      */
243     function buyTokens(address _beneficiary, address _referrer) public payable {
244         uint256 weiAmount = msg.value;
245         _preValidatePurchase(_beneficiary, weiAmount);
246 
247         // calculate token amount to be created
248         uint256 tokens;
249         uint256 bonus;
250         uint256 price;
251         (tokens, bonus, price) = _getTokenAmount(weiAmount);
252 
253         require(tokens >= 10 ether);
254 
255         price = tokens.div(1 ether).mul(price);
256         uint256 _diff =  weiAmount.sub(price);
257 
258         if (_diff > 0) {
259             weiAmount = weiAmount.sub(_diff);
260             msg.sender.transfer(_diff);
261         }
262 
263 
264         if (_referrer != address(0) && _referrer != _beneficiary) {
265             referrals[_beneficiary] = _referrer;
266         }
267 
268         if (referrals[_beneficiary] != address(0)) {
269             uint refTokens = valueFromPercent(tokens, 1000);
270             _processPurchase(referrals[_beneficiary], refTokens);
271             tokensSold = tokensSold.add(refTokens);
272         }
273 
274         tokens = tokens.add(bonus);
275 
276         require(tokensSold.add(tokens) <= cap);
277 
278         // update state
279         weiRaised = weiRaised.add(weiAmount);
280         tokensSold = tokensSold.add(tokens);
281 
282         _processPurchase(_beneficiary, tokens);
283         emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
284 
285         _forwardFunds(weiAmount);
286     }
287 
288     // -----------------------------------------
289     // Internal interface (extensible)
290     // -----------------------------------------
291 
292     /**
293      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
294      * @param _beneficiary Address performing the token purchase
295      * @param _weiAmount Value in wei involved in the purchase
296      */
297     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal pure {
298         require(_beneficiary != address(0));
299         require(_weiAmount != 0);
300     }
301 
302 
303     /**
304      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
305      * @param _beneficiary Address performing the token purchase
306      * @param _tokenAmount Number of tokens to be emitted
307      */
308     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
309         token.safeTransfer(_beneficiary, _tokenAmount);
310     }
311 
312     /**
313      * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
314      * @param _beneficiary Address receiving the tokens
315      * @param _tokenAmount Number of tokens to be purchased
316      */
317     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
318         _deliverTokens(_beneficiary, _tokenAmount);
319     }
320 
321     /**
322      * @dev Override to extend the way in which ether is converted to tokens.
323      * @param _weiAmount Value in wei to be converted into tokens
324      * @return Number of tokens that can be purchased with the specified _weiAmount
325      */
326     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256, uint256, uint256) {
327         if (block.timestamp >= 1551387600 && block.timestamp < 1554066000) {
328             return _calculateTokens(_weiAmount, 1);
329         } else if (block.timestamp >= 1554066000 && block.timestamp < 1556658000) {
330             return _calculateTokens(_weiAmount, 2);
331         } else if (block.timestamp >= 1556658000 && block.timestamp < 1559336400) {
332             return _calculateTokens(_weiAmount, 3);
333         } else if (block.timestamp >= 1559336400 && block.timestamp < 1561928400) {
334             return _calculateTokens(_weiAmount, 4);
335         } else return (0,0,0);
336 
337     }
338 
339 
340     function _calculateTokens(uint256 _weiAmount, uint _stage) internal view returns (uint256, uint256, uint256) {
341         uint price = prices[_stage];
342         uint tokens = _weiAmount.div(price);
343         uint bonus;
344         if (tokens >= 10 && tokens <= 100) {
345             bonus = 1000;
346         } else if (tokens > 100 && tokens <= 1000) {
347             bonus = 1500;
348         } else if (tokens > 1000 && tokens <= 10000) {
349             bonus = 2000;
350         } else if (tokens > 10000 && tokens <= 100000) {
351             bonus = 2500;
352         } else if (tokens > 100000 && tokens <= 1000000) {
353             bonus = 3000;
354         } else if (tokens > 1000000 && tokens <= 10000000) {
355             bonus = 3500;
356         } else if (tokens > 10000000) {
357             bonus = 4000;
358         }
359 
360         bonus = valueFromPercent(tokens, bonus);
361         return (tokens.mul(1 ether), bonus.mul(1 ether), price);
362 
363     }
364 
365     /**
366      * @dev Determines how ETH is stored/forwarded on purchases.
367      */
368     function _forwardFunds(uint _weiAmount) internal {
369         wallet.transfer(_weiAmount);
370     }
371 
372 
373     /**
374     * @dev Checks whether the cap has been reached.
375     * @return Whether the cap was reached
376     */
377     function capReached() public view returns (bool) {
378         return tokensSold >= cap;
379     }
380 
381     /**
382      * @dev Must be called after crowdsale ends, to do some extra finalization
383      * work. Calls the contract's finalization function.
384      */
385     function finalize() onlyOwner public {
386         finalization();
387         emit Finalized();
388     }
389 
390     /**
391      * @dev Can be overridden to add finalization logic. The overriding function
392      * should call super.finalization() to ensure the chain of finalization is
393      * executed entirely.
394      */
395     function finalization() internal {
396         token.safeTransfer(wallet, token.balanceOf(address(this)));
397     }
398 
399 
400     function updatePrice(uint _stage, uint _newPrice) onlyOwner external {
401         prices[_stage] = _newPrice;
402     }
403 
404     function bytesToAddress(bytes memory bys) private pure returns (address addr) {
405         assembly {
406             addr := mload(add(bys, 20))
407         }
408     }
409 
410     //1% - 100, 10% - 1000 50% - 5000
411     function valueFromPercent(uint _value, uint _percent) internal pure returns (uint amount)    {
412         uint _amount = _value.mul(_percent).div(10000);
413         return (_amount);
414     }
415 }