1 /**
2  * @title SafeMath
3  * @dev Math operations with safety checks that throw on error
4  */
5 library SafeMath {
6 
7     /**
8     * @dev Multiplies two numbers, throws on overflow.
9     */
10     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
11         if (a == 0) {
12             return 0;
13         }
14         c = a * b;
15         assert(c / a == b);
16         return c;
17     }
18 
19     /**
20     * @dev Integer division of two numbers, truncating the quotient.
21     */
22     function div(uint256 a, uint256 b) internal pure returns (uint256) {
23         // assert(b > 0); // Solidity automatically throws when dividing by 0
24         // uint256 c = a / b;
25         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26         return a / b;
27     }
28 
29     /**
30     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
31     */
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         assert(b <= a);
34         return a - b;
35     }
36 
37     /**
38     * @dev Adds two numbers, throws on overflow.
39     */
40     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
41         c = a + b;
42         assert(c >= a);
43         return c;
44     }
45 }
46 
47 contract FiatContract {
48   function ETH(uint _id) constant returns (uint256);
49   function USD(uint _id) constant returns (uint256);
50   function EUR(uint _id) constant returns (uint256);
51   function GBP(uint _id) constant returns (uint256);
52   function updatedAt(uint _id) constant returns (uint);
53 }
54 
55 /**
56  * @title ERC20Basic
57  * @dev Simpler version of ERC20 interface
58  * @dev see https://github.com/ethereum/EIPs/issues/179
59  */
60 contract ERC20Basic {
61     function totalSupply() public view returns (uint256);
62     function balanceOf(address who) public view returns (uint256);
63     function transfer(address to, uint256 value) public returns (bool);
64     event Transfer(address indexed from, address indexed to, uint256 value);
65 }
66 
67 /**
68  * @title ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/20
70  */
71 contract ERC20 is ERC20Basic {
72     function allowance(address owner, address spender)
73     public view returns (uint256);
74 
75     function transferFrom(address from, address to, uint256 value)
76     public returns (bool);
77 
78     function approve(address spender, uint256 value) public returns (bool);
79     event Approval(
80         address indexed owner,
81         address indexed spender,
82         uint256 value
83     );
84 }
85 
86 /**
87  * @title Ownable
88  * @dev The Ownable contract has an owner address, and provides basic authorization control
89  * functions, this simplifies the implementation of "user permissions".
90  */
91 contract Ownable {
92     address public owner;
93 
94 
95     event OwnershipRenounced(address indexed previousOwner);
96     event OwnershipTransferred(
97         address indexed previousOwner,
98         address indexed newOwner
99     );
100 
101 
102     /**
103      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
104      * account.
105      */
106     constructor() public {
107         owner = msg.sender;
108     }
109 
110     /**
111      * @dev Throws if called by any account other than the owner.
112      */
113     modifier onlyOwner() {
114         require(msg.sender == owner);
115         _;
116     }
117 
118     /**
119      * @dev Allows the current owner to transfer control of the contract to a newOwner.
120      * @param newOwner The address to transfer ownership to.
121      */
122     function transferOwnership(address newOwner) public onlyOwner {
123         require(newOwner != address(0));
124         emit OwnershipTransferred(owner, newOwner);
125         owner = newOwner;
126     }
127 
128     /**
129      * @dev Allows the current owner to relinquish control of the contract.
130      */
131     function renounceOwnership() public onlyOwner {
132         emit OwnershipRenounced(owner);
133         owner = address(0);
134     }
135 }
136 
137 /**
138  * @title Safe Guard Contract
139  */
140 contract SafeGuard is Ownable {
141 
142     event Transaction(address indexed destination, uint value, bytes data);
143 
144     /**
145      * @dev Allows owner to execute a transaction.
146      */
147     function executeTransaction(address destination, uint value, bytes data)
148     public
149     onlyOwner
150     {
151         require(externalCall(destination, value, data.length, data));
152         emit Transaction(destination, value, data);
153     }
154 
155     /**
156      * @dev call has been separated into its own function in order to take advantage
157      *  of the Solidity's code generator to produce a loop that copies tx.data into memory.
158      */
159     function externalCall(address destination, uint value, uint dataLength, bytes data)
160     private
161     returns (bool) {
162         bool result;
163         assembly { // solhint-disable-line no-inline-assembly
164             let x := mload(0x40)   // "Allocate" memory for output
165         // (0x40 is where "free memory" pointer is stored by convention)
166             let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that
167             result := call(
168             sub(gas, 34710), // 34710 is the value that solidity is currently emitting
169             // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
170             // callNewAccountGas (25000, in case the destination address does not exist and needs creating)
171             destination,
172             value,
173             d,
174             dataLength, // Size of the input (in bytes) - this is what fixes the padding problem
175             x,
176             0                  // Output is ignored, therefore the output size is zero
177             )
178         }
179         return result;
180     }
181 }
182 
183 /**
184  * @title Crowdsale
185  * @dev Crowdsale is a base contract for managing a token crowdsale,
186  * allowing investors to purchase tokens with ether. This contract implements
187  * such functionality in its most fundamental form and can be extended to provide additional
188  * functionality and/or custom behavior.
189  * The external interface represents the basic interface for purchasing tokens, and conform
190  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
191  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
192  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
193  * behavior.
194  */
195 contract Crowdsale {
196     using SafeMath for uint256;
197 
198     // The token being sold
199     ERC20 public token;
200 
201     // Address where funds are collected
202     address public wallet;
203 
204     // How many token units a buyer gets per wei
205     uint256 public rate;
206 
207     // Amount of wei raised
208     uint256 public weiRaised;
209 
210     /**
211      * Event for token purchase logging
212      * @param purchaser who paid for the tokens
213      * @param beneficiary who got the tokens
214      * @param value weis paid for purchase
215      * @param amount amount of tokens purchased
216      */
217     event TokenPurchase(
218         address indexed purchaser,
219         address indexed beneficiary,
220         uint256 value,
221         uint256 amount
222     );
223 
224     /**
225      * @param _rate Number of token units a buyer gets per wei
226      * @param _wallet Address where collected funds will be forwarded to
227      * @param _token Address of the token being sold
228      */
229     constructor(uint256 _rate, address _wallet, ERC20 _token) public {
230         require(_rate > 0);
231         require(_wallet != address(0));
232         require(_token != address(0));
233 
234         rate = _rate;
235         wallet = _wallet;
236         token = _token;
237     }
238 
239     // -----------------------------------------
240     // Crowdsale external interface
241     // -----------------------------------------
242 
243     /**
244      * @dev fallback function ***DO NOT OVERRIDE***
245      */
246     function () external payable {
247         buyTokens(msg.sender);
248     }
249 
250     /**
251      * @dev low level token purchase ***DO NOT OVERRIDE***
252      * @param _beneficiary Address performing the token purchase
253      */
254     function buyTokens(address _beneficiary) public payable {
255 
256         uint256 weiAmount = msg.value;
257         _preValidatePurchase(_beneficiary, weiAmount);
258 
259         // calculate token amount to be created
260         uint256 tokens = _getTokenAmount(weiAmount);
261 
262         // update state
263         weiRaised = weiRaised.add(weiAmount);
264 
265         _processPurchase(_beneficiary, tokens);
266         emit TokenPurchase(
267             msg.sender,
268             _beneficiary,
269             weiAmount,
270             tokens
271         );
272 
273         _updatePurchasingState(_beneficiary, weiAmount);
274 
275         _forwardFunds();
276         _postValidatePurchase(_beneficiary, weiAmount);
277     }
278 
279     // -----------------------------------------
280     // Internal interface (extensible)
281     // -----------------------------------------
282 
283     /**
284      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
285      * @param _beneficiary Address performing the token purchase
286      * @param _weiAmount Value in wei involved in the purchase
287      */
288     function _preValidatePurchase(
289         address _beneficiary,
290         uint256 _weiAmount
291     )
292     internal
293     {
294         require(_beneficiary != address(0));
295         require(_weiAmount != 0);
296     }
297 
298     /**
299      * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
300      * @param _beneficiary Address performing the token purchase
301      * @param _weiAmount Value in wei involved in the purchase
302      */
303     function _postValidatePurchase(
304         address _beneficiary,
305         uint256 _weiAmount
306     )
307     internal
308     {
309         // optional override
310     }
311 
312     /**
313      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
314      * @param _beneficiary Address performing the token purchase
315      * @param _tokenAmount Number of tokens to be emitted
316      */
317     function _deliverTokens(
318         address _beneficiary,
319         uint256 _tokenAmount
320     )
321     internal
322     {
323         token.transfer(_beneficiary, _tokenAmount);
324     }
325 
326     /**
327      * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
328      * @param _beneficiary Address receiving the tokens
329      * @param _tokenAmount Number of tokens to be purchased
330      */
331     function _processPurchase(
332         address _beneficiary,
333         uint256 _tokenAmount
334     )
335     internal
336     {
337         _deliverTokens(_beneficiary, _tokenAmount);
338     }
339 
340     /**
341      * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
342      * @param _beneficiary Address receiving the tokens
343      * @param _weiAmount Value in wei involved in the purchase
344      */
345     function _updatePurchasingState(
346         address _beneficiary,
347         uint256 _weiAmount
348     )
349     internal
350     {
351         // optional override
352     }
353 
354     /**
355      * @dev Override to extend the way in which ether is converted to tokens.
356      * @param _weiAmount Value in wei to be converted into tokens
357      * @return Number of tokens that can be purchased with the specified _weiAmount
358      */
359     function _getTokenAmount(uint256 _weiAmount)
360     internal view returns (uint256)
361     {
362         return _weiAmount.mul(rate);
363     }
364 
365     /**
366      * @dev Determines how ETH is stored/forwarded on purchases.
367      */
368     function _forwardFunds() internal {
369         wallet.transfer(msg.value);
370     }
371 }
372 
373 /**
374  * @title TimedCrowdsale
375  * @dev Crowdsale accepting contributions only within a time frame.
376  */
377 contract TimedCrowdsale is Crowdsale {
378     using SafeMath for uint256;
379 
380     uint256 public openingTime;
381     uint256 public closingTime;
382 
383     /**
384      * @dev Reverts if not in crowdsale time range.
385      */
386     modifier onlyWhileOpen {
387         // solium-disable-next-line security/no-block-members
388         require(block.timestamp >= openingTime && block.timestamp <= closingTime);
389         _;
390     }
391 
392     /**
393      * @dev Constructor, takes crowdsale opening and closing times.
394      * @param _openingTime Crowdsale opening time
395      * @param _closingTime Crowdsale closing time
396      */
397     constructor(uint256 _openingTime, uint256 _closingTime) public {
398         // solium-disable-next-line security/no-block-members
399         require(_openingTime >= block.timestamp);
400         require(_closingTime >= _openingTime);
401 
402         openingTime = _openingTime;
403         closingTime = _closingTime;
404     }
405 
406     /**
407      * @dev Checks whether the period in which the crowdsale is open has already elapsed.
408      * @return Whether crowdsale period has elapsed
409      */
410     function hasClosed() public view returns (bool) {
411         // solium-disable-next-line security/no-block-members
412         return block.timestamp > closingTime;
413     }
414 
415     /**
416      * @dev Extend parent behavior requiring to be within contributing period
417      * @param _beneficiary Token purchaser
418      * @param _weiAmount Amount of wei contributed
419      */
420     function _preValidatePurchase(
421         address _beneficiary,
422         uint256 _weiAmount
423     )
424     internal
425     onlyWhileOpen
426     {
427         super._preValidatePurchase(_beneficiary, _weiAmount);
428     }
429 
430 }
431 
432 /**
433  * @title AllowanceCrowdsale
434  * @dev Extension of Crowdsale where tokens are held by a wallet, which approves an allowance to the crowdsale.
435  */
436 contract AllowanceCrowdsale is Crowdsale {
437     using SafeMath for uint256;
438 
439     address public tokenWallet;
440 
441     /**
442      * @dev Constructor, takes token wallet address.
443      * @param _tokenWallet Address holding the tokens, which has approved allowance to the crowdsale
444      */
445     constructor(address _tokenWallet) public {
446         require(_tokenWallet != address(0));
447         tokenWallet = _tokenWallet;
448     }
449 
450     /**
451      * @dev Checks the amount of tokens left in the allowance.
452      * @return Amount of tokens left in the allowance
453      */
454     function remainingTokens() public view returns (uint256) {
455         return token.allowance(tokenWallet, this);
456     }
457 
458     /**
459      * @dev Overrides parent behavior by transferring tokens from wallet.
460      * @param _beneficiary Token purchaser
461      * @param _tokenAmount Amount of tokens purchased
462      */
463     function _deliverTokens(
464         address _beneficiary,
465         uint256 _tokenAmount
466     )
467     internal
468     {
469         token.transferFrom(tokenWallet, _beneficiary, _tokenAmount);
470     }
471 }
472 
473 /**
474  * @title Antiderivative Pre Token crowdsale
475  */
476 contract PADVTCrowdsale is AllowanceCrowdsale, TimedCrowdsale, SafeGuard {
477     
478     FiatContract fContract;
479 
480     /**
481      * @param _rate Multiplied by 0.01$ to calculate final price
482      * @param _wallet Address where collected funds will be forwarded to
483      * @param _token Address of the token being sold
484      * @param _tokenWallet Address holding the tokens, which has approved allowance to the crowdsale
485      * @param _openingTime Crowdsale opening time
486      * @param _closingTime Crowdsale closing time
487      */
488     constructor(uint256 _rate, address _wallet, ERC20 _token, address _tokenWallet, uint256 _openingTime, uint256 _closingTime)
489     Crowdsale(_rate, _wallet, _token)
490     AllowanceCrowdsale(_tokenWallet)
491     TimedCrowdsale(_openingTime, _closingTime)
492     public
493     {
494         fContract = FiatContract(0x8055d0504666e2B6942BeB8D6014c964658Ca591);
495     }
496 
497     /**
498      * @dev Override to extend the way in which ether is converted to tokens.
499      * @param _weiAmount Value in wei to be converted into tokens
500      * @return Number of tokens that can be purchased with the specified _weiAmount
501      */
502     function _getTokenAmount(uint256 _weiAmount)
503     internal view returns (uint256)
504     {
505         // returns $0.01 ETH wei * rate
506         uint256 ethCent = fContract.USD(0) * rate;
507         return _weiAmount.div(ethCent);
508     }
509 }